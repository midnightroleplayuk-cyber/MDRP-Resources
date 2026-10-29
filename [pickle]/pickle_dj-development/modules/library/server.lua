-- Per-player music library backed by FiveManage uploads.
-- API host/token is configured in config_sv.lua under ConfigSV.FiveManage.
-- Tracks are isolated per player identifier and never shared.
--
-- Upload flow (presigned-URL based, no file bytes through FiveM events):
--   1) NUI -> client -> server: pickle_dj:library:requestUploadUrl
--      Server validates the request (enabled, identifier, size, per-player cap)
--      and asks Fivemanage for a presigned upload URL. Server stashes a
--      pending entry keyed by an opaque `remoteId` (the presigned token) and
--      replies to the client with { presignedUrl, remoteId, contentType }.
--   2) NUI uploads the file blob directly to the presigned URL (POST,
--      multipart/form-data) — bytes never touch the FiveM event stream.
--   3) NUI -> client -> server: pickle_dj:library:confirmUpload with the
--      Fivemanage-returned { remoteId (real file id), url, title, ... }.
--      Server validates the pending entry, inserts the DB row, replies.

-- Read lazily through a metatable so config order in fxmanifest doesn't matter:
-- accessing FM.<key> resolves against the current ConfigSV.FiveManage table at
-- call time, not at this file's load time.
local FM = setmetatable({}, { __index = function(_, k)
    local cfg = (rawget(_G, "ConfigSV") or {}).FiveManage or {}
    return cfg[k]
end })

-- FiveManage presigned-URL endpoint (returns { status, data = { presignedUrl } }).
-- https://docs.fivemanage.com/api-reference/files/create-presigned-upload-url
local FM_PRESIGN_URL = "https://api.fivemanage.com/api/v3/file/presigned-url"
local FM_DELETE_URL  = "https://api.fivemanage.com/api/file"

local function getPlayerIdentifier(src)
    src = tonumber(src)
    if not src then return nil end
    if Config and Config.IdentifierPrefix and GetPlayerPrefixIdentifier then
        local ok, id = pcall(GetPlayerPrefixIdentifier, src)
        if ok and id and id ~= "" then return id end
    end
    for _, t in ipairs({ "license2", "license", "steam", "fivem", "discord" }) do
        local v = GetPlayerIdentifierByType(src, t)
        if v and v ~= "" then return v end
    end
    return nil
end

local function sanitizeFilename(name)
    if type(name) ~= "string" or name == "" then return "track.mp3" end
    -- strip path separators, keep a sensible subset
    name = name:gsub("[\\/]+", "_"):gsub("[^%w%._%-%s%(%)%[%]]", "_")
    if #name > 120 then name = name:sub(1, 120) end
    return name
end

CreateThread(function()
    MySQL.ready(function()
        MySQL.Async.execute([[
            CREATE TABLE IF NOT EXISTS `pickle_dj_library` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `identifier` VARCHAR(255) NOT NULL,
                `title` VARCHAR(255) NOT NULL,
                `url` TEXT NOT NULL,
                `remote_id` VARCHAR(128),
                `mime` VARCHAR(64),
                `file_size` INT(11),
                `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (`id`),
                INDEX `idx_identifier` (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], {})
        debugPrint("^2[pickle_dj]^0 Library table initialized")
    end)
end)

lib.callback.register('pickle_dj:library:list', function(source)
    local identifier = getPlayerIdentifier(source)
    if not identifier then return { ok = false, error = "no_identifier", items = {} } end
    local rows = MySQL.Sync.fetchAll(
        "SELECT id, title, url, mime, file_size, created_at FROM `pickle_dj_library` WHERE identifier = @id ORDER BY created_at DESC",
        { ['@id'] = identifier }
    ) or {}
    local uploadEnabled = FM.enabled == true and type(FM.apiKey) == "string" and FM.apiKey ~= ""
    return { ok = true, items = rows, uploadEnabled = uploadEnabled }
end)

lib.callback.register('pickle_dj:library:delete', function(source, itemId)
    local identifier = getPlayerIdentifier(source)
    if not identifier then return { ok = false, error = "no_identifier" } end
    itemId = tonumber(itemId)
    if not itemId then return { ok = false, error = "bad_id" } end

    local row = MySQL.Sync.fetchAll(
        "SELECT id, remote_id FROM `pickle_dj_library` WHERE id = @id AND identifier = @ident LIMIT 1",
        { ['@id'] = itemId, ['@ident'] = identifier }
    )
    if not row or not row[1] then return { ok = false, error = "not_found" } end

    MySQL.Async.execute(
        "DELETE FROM `pickle_dj_library` WHERE id = @id AND identifier = @ident",
        { ['@id'] = itemId, ['@ident'] = identifier }
    )

    -- Best-effort remote delete; ignore failure (DB row already gone)
    if FM.enabled and FM.apiKey and FM.apiKey ~= "" and row[1].remote_id and row[1].remote_id ~= "" then
        local url = FM_DELETE_URL .. "/" .. row[1].remote_id
        PerformHttpRequest(url, function(status, respBody, _)
            if status and (status < 200 or status >= 300) then
                print(("^3[pickle_dj]^0 FiveManage delete failed remote_id=%s status=%s body=%s"):format(
                    tostring(row[1].remote_id), tostring(status), tostring(respBody)))
            else
                debugPrint(("[pickle_dj] FiveManage delete remote_id=%s status=%s"):format(row[1].remote_id, tostring(status)))
            end
        end, "DELETE", "", { ["Authorization"] = FM.apiKey })
    end

    return { ok = true }
end)

-- ---------------------------------------------------------------------------
-- Presigned-URL upload protocol (requestUploadUrl / confirmUpload)
-- ---------------------------------------------------------------------------
-- PendingUploads stashes per-request metadata between the presign call and the
-- client's confirmation. Keyed by an opaque server-issued `remoteId` (which is
-- the presigned-URL token — unique per presign and unguessable). The value
-- records the requesting source/identifier so the confirm step can verify
-- ownership, plus the title/mime/size we already validated.
local PendingUploads = {}
local PENDING_TTL = 600 -- seconds (10 minutes) before a pending entry is pruned

local function prunePending()
    local now = os.time()
    for id, p in pairs(PendingUploads) do
        if (now - (p.createdAt or 0)) > PENDING_TTL then
            PendingUploads[id] = nil
        end
    end
end

local function dropPendingForSource(src)
    for id, p in pairs(PendingUploads) do
        if p.source == src then PendingUploads[id] = nil end
    end
end

AddEventHandler('playerDropped', function()
    dropPendingForSource(source)
end)

-- Extract the presigned-URL token (the trailing path segment) so we can use it
-- as a stable, unguessable handle ("remoteId") for the pending stash. We do
-- *not* return the raw token to the DB — the real Fivemanage file id arrives
-- on the confirm step.
local function extractPresignToken(presignedUrl)
    if type(presignedUrl) ~= "string" then return nil end
    return presignedUrl:match("/presigned%-url/([^/?#]+)$")
end

-- Sanity-check a client-supplied request id before echoing it back on the
-- response event. Keeps the reply event from being abused to broadcast
-- arbitrary payloads keyed by attacker-chosen ids.
local function isValidReqId(reqId)
    return type(reqId) == "string" and #reqId > 0 and #reqId <= 64
end

local function replyUpload(src, reqId, result)
    TriggerClientEvent('pickle_dj:library:uploadResponse', src, reqId, result)
end

RegisterNetEvent('pickle_dj:library:requestUploadUrl', function(reqId, payload)
    local src = source
    if not isValidReqId(reqId) then return end
    local function reply(result) replyUpload(src, reqId, result) end

    prunePending()

    if not FM.enabled then return reply({ ok = false, error = "disabled" }) end
    if not FM.apiKey or FM.apiKey == "" then return reply({ ok = false, error = "no_api_key" }) end

    local identifier = getPlayerIdentifier(src)
    if not identifier then return reply({ ok = false, error = "no_identifier" }) end
    if type(payload) ~= "table" then return reply({ ok = false, error = "bad_payload" }) end

    local totalBytes = tonumber(payload.totalBytes)
    if not totalBytes or totalBytes <= 0 then
        return reply({ ok = false, error = "bad_size" })
    end

    local maxBytes = (tonumber(FM.maxFileSizeMB) or 12) * 1024 * 1024
    if totalBytes > maxBytes then
        return reply({ ok = false, error = "too_large", maxFileSizeMB = FM.maxFileSizeMB })
    end

    local mime = type(payload.mimeType) == "string" and payload.mimeType or "audio/mpeg"
    -- Light mime sanity: must look like an audio/* type.
    if not mime:match("^audio/") then
        return reply({ ok = false, error = "bad_mime" })
    end

    local filename = sanitizeFilename(payload.filename)
    local title = type(payload.title) == "string" and payload.title ~= "" and payload.title or filename

    -- Per-player cap (re-checked again on confirm before commit).
    local cap = tonumber(FM.maxTracksPerPlayer) or 0
    if cap > 0 then
        local count = MySQL.Sync.fetchScalar(
            "SELECT COUNT(*) FROM `pickle_dj_library` WHERE identifier = @ident",
            { ['@ident'] = identifier }
        ) or 0
        if tonumber(count) and tonumber(count) >= cap then
            return reply({ ok = false, error = "library_full", maxTracksPerPlayer = cap })
        end
    end

    -- Ask Fivemanage for a presigned upload URL. The docs spec the create call
    -- as GET with no body — the file's contentType/filename are not declared
    -- up-front; they're folded into the multipart/form-data POST to the
    -- presigned URL itself.
    local p = promise.new()
    PerformHttpRequest(FM_PRESIGN_URL, function(status, respBody, _)
        p:resolve({ status = status, body = respBody })
    end, "GET", "", { ["Authorization"] = FM.apiKey })
    local result = Citizen.Await(p)

    if not result or not result.status or result.status < 200 or result.status >= 300 then
        print(("^1[pickle_dj]^0 FiveManage presign failed status=%s body=%s"):format(
            tostring(result and result.status), tostring(result and result.body)))
        if result and (result.status == 401 or result.status == 403) then
            print("^1[pickle_dj]^0 Hint: 401/403 usually means the FiveManage API key is invalid or lacks the 'Files' scope.")
        end
        return reply({ ok = false, error = "presign_failed", status = result and result.status })
    end

    local parsed
    pcall(function() parsed = json.decode(result.body or "{}") end)
    local presignedUrl = parsed and parsed.data and parsed.data.presignedUrl
    if type(presignedUrl) ~= "string" or presignedUrl == "" then
        return reply({ ok = false, error = "bad_presign_response" })
    end

    local token = extractPresignToken(presignedUrl)
    if not token or token == "" then
        return reply({ ok = false, error = "bad_presign_response" })
    end

    PendingUploads[token] = {
        source = src,
        identifier = identifier,
        title = title,
        filename = filename,
        mime = mime,
        expectedSize = totalBytes,
        createdAt = os.time(),
    }

    reply({
        ok = true,
        presignedUrl = presignedUrl,
        remoteId = token,
        contentType = mime,
    })
end)

RegisterNetEvent('pickle_dj:library:confirmUpload', function(reqId, payload)
    local src = source
    if not isValidReqId(reqId) then return end
    local function reply(result) replyUpload(src, reqId, result) end

    prunePending()

    if type(payload) ~= "table" then return reply({ ok = false, error = "bad_payload" }) end

    local pendKey = payload.remoteId -- our stash key (presign token)
    if type(pendKey) ~= "string" or pendKey == "" then
        return reply({ ok = false, error = "bad_remote_id" })
    end

    local pend = PendingUploads[pendKey]
    if not pend then return reply({ ok = false, error = "no_pending" }) end
    if pend.source ~= src then
        return reply({ ok = false, error = "pending_owner_mismatch" })
    end

    -- One-shot: consume the pending entry regardless of outcome.
    PendingUploads[pendKey] = nil

    -- Per-player cap (re-check immediately before commit).
    local cap = tonumber(FM.maxTracksPerPlayer) or 0
    if cap > 0 then
        local count = MySQL.Sync.fetchScalar(
            "SELECT COUNT(*) FROM `pickle_dj_library` WHERE identifier = @ident",
            { ['@ident'] = pend.identifier }
        ) or 0
        if tonumber(count) and tonumber(count) >= cap then
            return reply({ ok = false, error = "library_full", maxTracksPerPlayer = cap })
        end
    end

    -- Resolve the public URL + real file id from what the NUI got back from
    -- Fivemanage (response shape: { status, data = { id, url, originalUrl } }).
    -- We trust the NUI's reported url only after the presign-token-keyed
    -- pending entry has been validated above; the url field itself is what
    -- the docs say is the canonical public URL (CDN-aware).
    local publicUrl = type(payload.url) == "string" and payload.url or nil
    local fmFileId  = type(payload.fileId) == "string" and payload.fileId or nil

    if not publicUrl or publicUrl == "" then
        return reply({ ok = false, error = "no_url" })
    end

    -- Prefer the FM-issued file id (used by the delete endpoint). Fall back to
    -- parsing the trailing slug of the URL if the NUI didn't echo an id.
    local remoteIdForDb = fmFileId
    if not remoteIdForDb or remoteIdForDb == "" then
        remoteIdForDb = publicUrl:match("/([^/?#]+)%.[%w]+$") or publicUrl:match("/([^/?#]+)$") or ""
    end

    local reportedSize = tonumber(payload.fileSize) or pend.expectedSize or 0

    local insertId = MySQL.Sync.insert(
        "INSERT INTO `pickle_dj_library` (identifier, title, url, remote_id, mime, file_size) VALUES (@ident, @title, @url, @rid, @mime, @sz)",
        {
            ['@ident'] = pend.identifier,
            ['@title'] = pend.title,
            ['@url']   = publicUrl,
            ['@rid']   = tostring(remoteIdForDb or ""),
            ['@mime']  = pend.mime,
            ['@sz']    = reportedSize,
        }
    )

    reply({
        ok = true,
        item = {
            id = insertId,
            title = pend.title,
            url = publicUrl,
            mime = pend.mime,
            file_size = reportedSize,
        }
    })
end)

CreateThread(function()
    while true do
        Wait(60000)
        prunePending()
    end
end)
