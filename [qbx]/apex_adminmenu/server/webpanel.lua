-- ============================================================
-- WEB PANEL RELAY
-- ------------------------------------------------------------
-- Connects this server to the Apex web panel.
--
--   set apex_panel_url "https://panel.example.com"
--   set apex_panel_key "<the key from the panel's Setup tab>"
--
-- Transport: the server POSTs a heartbeat to /api/relay/heartbeat and
-- the RESPONSE carries any commands queued by the panel. That keeps the
-- whole thing outbound-only — no inbound port, no firewall change, and
-- it works behind NAT, which is where most FiveM boxes live.
--
-- Nothing here trusts the panel blindly: the key authenticates the
-- SERVER to the panel, and the panel has already authenticated the
-- admin. Commands arrive pre-authorised.
-- ============================================================

local PANEL_URL = GetConvar('apex_panel_url', '')
local PANEL_KEY = GetConvar('apex_panel_key', '')

-- Heartbeat cadence. Fast enough that the panel feels live, slow enough
-- that a busy server isn't spending its time on HTTP.
local HEARTBEAT_MS = 1500

local enabled = PANEL_URL ~= '' and PANEL_KEY ~= ''

-- Outbound buffers, flushed on the next heartbeat.
local pendingEvents, pendingConsole, pendingChat = {}, {}, {}
local startedAt = os.time()

-- ── Helpers ─────────────────────────────────────────────────

-- The panel URL, split once so the host can be rewritten below.
local SCHEME, HOSTPORT, BASEPATH = (PANEL_URL:gsub('/+$', '')):match('^(https?://)([^/]+)(.*)$')
local HOSTNAME, PORTPART = '', ''
if HOSTPORT then
    HOSTNAME, PORTPART = HOSTPORT:match('^([^:]+)(:?%d*)$')
    HOSTNAME = HOSTNAME or HOSTPORT
    PORTPART = PORTPART or ''
end

-- Some servers cannot resolve the panel's hostname the way it is written,
-- yet resolve the SAME name as an absolute FQDN (with a trailing dot),
-- because the resolver stops applying its DNS search suffixes. Seen with
-- .xyz domains on a Portuguese ISP router: every lookup failed before the
-- request left the machine (status 0), while "host." worked instantly.
-- The trailing dot must NOT reach the Host header, or IIS answers 400.
local canFqdn = HOSTNAME ~= '' and HOSTNAME:sub(-1) ~= '.'
    and not HOSTNAME:match('^%d+%.%d+%.%d+%.%d+$')
local fqdnMode = false

local function url(path, fqdn)
    if not HOSTPORT then return (PANEL_URL:gsub('/+$', '')) .. '/api/relay/' .. path end
    local hostPart = fqdn and (HOSTNAME .. '.' .. PORTPART) or HOSTPORT
    return SCHEME .. hostPart .. BASEPATH .. '/api/relay/' .. path
end

-- FiveM's `json` is dkjson, and its quotestring() escapes control characters
-- and well-formed multi-byte sequences — but a LONE high byte passes straight
-- through. Player names are arbitrary bytes: one player connecting with a
-- mangled name is enough to put invalid UTF-8 in the POST body, and a strict
-- JSON endpoint answers 4xx/5xx for exactly as long as that player is online.
-- That is the shape of a fault that comes and goes on its own.
--
-- Anything that is not valid UTF-8 becomes '?'. A name rendered with a
-- question mark in it is a cosmetic problem; a request the panel cannot parse
-- is not.
local function sanitizeUtf8(s)
    if type(s) ~= 'string' or s == '' then return s end
    local out, i, n = {}, 1, #s
    while i <= n do
        local b = s:byte(i)
        local len =
            (b < 0x80 and 1)
            or (b >= 0xC2 and b <= 0xDF and 2)
            or (b >= 0xE0 and b <= 0xEF and 3)
            or (b >= 0xF0 and b <= 0xF4 and 4)
            or nil

        local okSeq = len ~= nil and (i + len - 1) <= n
        if okSeq and len > 1 then
            for k = 1, len - 1 do
                local c = s:byte(i + k)
                if not c or c < 0x80 or c > 0xBF then okSeq = false break end
            end
        end

        if okSeq then
            out[#out + 1] = s:sub(i, i + len - 1)
            i = i + len
        else
            out[#out + 1] = '?'
            i = i + 1
        end
    end
    return table.concat(out)
end
PanelSanitizeUtf8 = sanitizeUtf8

local function encodeBody(body)
    -- dkjson returns nil + a message on a reference cycle rather than a
    -- string, and can raise on odd value types. Either way we want an
    -- answer, not a half-built request.
    local ok, payload = pcall(json.encode, body)
    if not ok or type(payload) ~= 'string' then return nil end
    return payload
end

local function post(path, body, cb)
    body.key = PANEL_KEY
    local payload = encodeBody(body)
    if not payload then
        -- Unencodable payload (a cycle, a userdata that slipped in). Dropping
        -- it here is strictly better than posting `nil` and having the panel
        -- answer 500 on a body it could never have parsed.
        if cb then cb(0, 'payload could not be encoded') end
        return
    end

    local function fire(fqdn)
        local headers = { ['Content-Type'] = 'application/json' }
        if fqdn then headers['Host'] = HOSTPORT end

        PerformHttpRequest(url(path, fqdn), function(status, text)
            -- Status 0 means the request never reached the panel at all, so
            -- retry once as an FQDN before reporting a failure. Whichever
            -- form works is kept for the rest of the session.
            if status == 0 and not fqdn and canFqdn and not fqdnMode then
                fqdnMode = true
                print('^3[apex_adminmenu] Web panel: hostname would not resolve; retrying as an absolute FQDN.^0')
                return fire(true)
            end
            if cb then cb(status, text) end
        end, 'POST', payload, headers)
    end

    fire(fqdnMode)
end

-- These buffers were unbounded. A slow or unreachable panel let them
-- grow between flushes until the POST body was megabytes — and one of
-- the feeders is a screen-watch frame, i.e. a full-resolution JPEG data
-- URI per frame per watched player. Oldest entries go first; a dropped
-- line in the Live feed is always better than a request nobody can read.
local MAX_PENDING = 200

local function pushCapped(buf, item)
    if #buf >= MAX_PENDING then table.remove(buf, 1) end
    buf[#buf + 1] = item
end

--- Queue something for the panel's Live feed.
function PanelRelayEvent(evt)
    if not enabled then return end
    -- join/leave lines carry the player's name verbatim.
    if type(evt) == 'table' and type(evt.message) == 'string' then
        evt.message = sanitizeUtf8(evt.message)
    end
    pushCapped(pendingEvents, evt)
end

-- server/adminpanel.lua monkey-patches `print` and mirrors EVERY server
-- console line into here. That includes the lines this file prints when the
-- panel is unreachable — so a failing panel printed an error, the hook
-- queued it, the next flush POSTed it, and the payload grew with every
-- single failure. Our own relay diagnostics are the one thing the panel
-- does not need to be told about.
local function isOwnRelayLine(text)
    return text:find('[apex_adminmenu] Web panel', 1, true) ~= nil
        or text:find('[paneltest]', 1, true) ~= nil
end

function PanelRelayConsole(line)
    if not enabled then return end
    local text = (type(line) == 'table' and line.text) or line
    if type(text) == 'string' and isOwnRelayLine(text) then return end
    if type(line) == 'table' and type(line.text) == 'string' then
        line.text = sanitizeUtf8(line.text)
    end
    pushCapped(pendingConsole, line)
end

function PanelRelayChat(line)
    if not enabled then return end
    -- Chat is the most player-controlled string on the server; a name or a
    -- message with a stray byte must not be able to break the whole POST.
    if type(line) == 'table' then
        line.author  = sanitizeUtf8(line.author)
        line.message = sanitizeUtf8(line.message)
    end
    pushCapped(pendingChat, line)
end

local function reply(reqId, ok, result)
    if not reqId then return end
    post('result', { reqId = reqId, ok = ok ~= false, result = result })
end

local function safeQuery(sql, params)
    local ok, res = pcall(MySQL.query.await, sql, params or {})
    if not ok then return nil end
    return res
end

--- The one place that decides "is this player staff, and as what?"
---
--- There are THREE ways to be staff and only one of them is a row in
--- apex_staff:
---   1. apex_staff table        → PanelGetMember
---   2. Config.AdminPerms.UserGroups (the framework group)
---   3. an ACE permission
---
--- PanelGetGroup covers all three, PanelGetMember only covers the
--- first. Everything staff-related must go through here, because using
--- the narrow check is exactly why the panel kept reporting 0 staff
--- while an admin was standing in the server.
---
--- @return string|nil groupName
local function staffGroupOf(src)
    if PanelGetGroup then
        local ok, group = pcall(PanelGetGroup, src)
        if ok and group then return group end
    end
    -- Last resort: a server that grants admin some other way still gets
    -- counted, just without a specific rank.
    if AdminPerms then
        local ok, isAdmin = pcall(AdminPerms, src)
        if ok and isAdmin then return 'admin' end
    end
    return nil
end
PanelStaffGroupOf = staffGroupOf

local function identifiersOf(src)
    local out = {}
    for _, id in ipairs(GetPlayerIdentifiers(src) or {}) do
        local kind = id:match('^(%a+):')
        if kind then out[kind] = id end
    end
    return out
end

-- ── State snapshot ──────────────────────────────────────────

-- Walking every resource costs a native call per resource and the answer
-- barely moves; recomputing it 40 times a minute was pure waste.
local resCache, resCacheAt = { started = 0, total = 0 }, 0

local function resourceCounts()
    local now = GetGameTimer()
    if now - resCacheAt < 30000 and resCache.total > 0 then return resCache end
    local started, total = 0, GetNumResources()
    for i = 0, total - 1 do
        if GetResourceState(GetResourceByFindIndex(i)) == 'started' then started = started + 1 end
    end
    resCache, resCacheAt = { started = started, total = total }, now
    return resCache
end

local function collectState()
    local players = {}
    local totalPing = 0

    for _, p in ipairs(GetPlayers()) do
        local src = tonumber(p)
        -- GetPlayerName is nil for a source that dropped between GetPlayers()
        -- and this line. Skipping them here is what keeps a half-connected
        -- player from putting a hole in the JSON.
        if src and GetPlayerName(src) then
            local ped = GetPlayerPed(src)
            local coords = ped and ped ~= 0 and GetEntityCoords(ped) or nil
            local ping = GetPlayerPing(src) or 0
            totalPing = totalPing + ping

            local ids = identifiersOf(src)
            local job

            -- Job comes from whichever framework is live; both bridges
            -- expose the same GetGroup shape.
            local okJob, jobName = pcall(function()
                if Framework == 'esx' and ESX then
                    local x = ESX.GetPlayerFromId(src)
                    return x and x.job and x.job.name
                end
                local pl = GetPlayer and GetPlayer(src)
                return pl and pl.PlayerData and pl.PlayerData.job and pl.PlayerData.job.name
            end)
            if okJob then job = jobName end

            -- Resolved ONCE. It walks the staff table, the framework group
            -- and the ACE tree, and it used to be called twice per player
            -- per heartbeat — 40 times a minute, for every player online.
            local group = staffGroupOf(src)

            -- Every field below is non-nil on purpose. A nil in Lua simply
            -- drops the key, so `x`/`name`/`steam` used to vanish from the
            -- JSON for anyone still loading in (ped 0, no steam linked) and
            -- a panel doing `p.x.toFixed(1)` answered 500 for that beat and
            -- 200 for the next one. That alternation IS the rejected/restored
            -- ladder in the console.
            players[#players + 1] = {
                id      = src,
                name    = sanitizeUtf8(GetPlayerName(src)) or ('Player ' .. src),
                ping    = ping,
                job     = job or 'civilian',
                -- Was `PanelGetMember(src) ~= nil`, i.e. the apex_staff
                -- table only. An ESX/ACE admin has no row there, so the
                -- Overview permanently read "Staff 0".
                isStaff    = group ~= nil,
                staffGroup = group or '',
                steam   = ids.steam and ids.steam:gsub('^steam:', '') or '',
                x       = coords and coords.x or 0.0,
                y       = coords and coords.y or 0.0,
                z       = coords and coords.z or 0.0,
                loaded  = coords ~= nil,
            }
        end
    end

    local counts = resourceCounts()
    local started, total = counts.started, counts.total

    return {
        hostname  = GetConvar('sv_hostname', 'FiveM Server'),
        maxSlots  = tonumber(GetConvar('sv_maxclients', '48')) or 48,
        players   = players,
        avgPing   = #players > 0 and math.floor(totalPing / #players) or 0,
        staff     = (function() local n = 0 for _, pl in ipairs(players) do if pl.isStaff then n = n + 1 end end return n end)(),
        uptime    = os.time() - startedAt,
        framework = (Framework == 'qb' and (IsQBox and 'QBox' or 'QBCore')) or 'ESX',
        resources = { started = started, total = total },
    }
end

-- ============================================================
-- COMMANDS
-- ------------------------------------------------------------
-- Fire-and-forget handlers. `a` is the argument array from the panel.
-- ============================================================

local Commands = {}

Commands['announce'] = function(a)
    TriggerClientEvent('apex_adminmenu:announceSlide', -1, {
        title = 'Server', message = tostring(a[1] or ''), type = 'info', duration = 8000,
    })
end

Commands['reviveAll'] = function()
    for _, p in ipairs(GetPlayers()) do ApexRevivePlayer(p) end
end

Commands['healAll'] = function()
    for _, p in ipairs(GetPlayers()) do ApexHealPlayer(p) end
end

Commands['setWeather'] = function(a)
    TriggerClientEvent('apex_adminmenu:weathersync', -1, tostring(a[1] or 'CLEAR'))
end

Commands['revivePlayer']   = function(a) ApexRevivePlayer(a[1]) end
Commands['healPlayer']     = function(a) ApexHealPlayer(a[1]) end
Commands['killPlayer']     = function(a) TriggerClientEvent('apex_adminmenu:setHealth', tonumber(a[1]), 0) end
Commands['freezePlayer']   = function(a) TriggerClientEvent('apex_adminmenu:setPlayerFrozen', -1, tonumber(a[1]), true) end
Commands['unfreezePlayer'] = function(a) TriggerClientEvent('apex_adminmenu:setPlayerFrozen', -1, tonumber(a[1]), false) end

Commands['messagePlayer'] = function(a)
    TriggerClientEvent('apex_adminmenu:notify', tonumber(a[1]), 'Staff', tostring(a[2] or ''), 'info')
end

Commands['kickPlayer'] = function(a)
    DropPlayer(tonumber(a[1]), tostring(a[2] or 'Kicked by an administrator'))
end

Commands['banPlayer'] = function(a)
    local target, reason, hours = tonumber(a[1]), tostring(a[2] or 'Banned'), tonumber(a[3])
    if not target then return end
    if BanPlayer then
        -- The existing ban system takes hours; nil means permanent.
        BanPlayer(target, hours, reason, 0)
    else
        DropPlayer(target, reason)
    end
end

Commands['warnPlayer'] = function(a)
    local target = tonumber(a[1])
    if not target then return end
    local reason = tostring(a[2] or '')
    TriggerClientEvent('apex_adminmenu:notify', target, 'Warning', reason, 'error')
    pcall(function()
        -- Column list must match apex_warnings exactly: `target` holds the
        -- LICENSE (every read path queries `WHERE target = <license>`) and
        -- `player` holds the name. There is no `target_lic` column, and
        -- `player` / `admin_lic` are NOT NULL without a default, so the
        -- old shape failed on every call.
        MySQL.insert.await(
            'INSERT INTO apex_warnings (target, player, reason, admin, admin_lic) VALUES (?, ?, ?, ?, ?)',
            { identifiersOf(target).license or '', GetPlayerName(target) or '', reason, 'Web panel', '' }
        )
    end)
end

Commands['giveMoney'] = function(a)
    local target, account, amount = tonumber(a[1]), tostring(a[2] or 'bank'), tonumber(a[3]) or 0
    if not target or amount == 0 then return end
    if Framework == 'esx' and ESX then
        local x = ESX.GetPlayerFromId(target)
        if x then x.addAccountMoney(account, amount) end
    else
        local pl = GetPlayer and GetPlayer(target)
        if pl and pl.Functions then pl.Functions.AddMoney(account == 'bank' and 'bank' or 'cash', amount, 'web-panel') end
    end
end

Commands['giveItem'] = function(a)
    local target, item, qty = tonumber(a[1]), tostring(a[2] or ''), tonumber(a[3]) or 1
    if not target or item == '' then return end
    if AddItem then AddItem(target, item, qty) end
end

Commands['setJob'] = function(a)
    local target, job, grade = tonumber(a[1]), tostring(a[2] or ''), tonumber(a[3]) or 0
    if not target or job == '' or not SetJob then return end
    -- ESX refuses job/grade pairs it doesn't know and says so only in the
    -- server console. Surface the reason on the panel's Live feed instead.
    local ok, reason = SetJob(target, job, grade)
    if ok == false then
        PanelRelayEvent({ type = 'error', message = ('setJob failed: %s'):format(reason or 'rejected by the framework') })
    end
end

Commands['fixVehicle']   = function(a) TriggerClientEvent('apex_adminmenu:panel:fixVehicle', tonumber(a[1])) end
Commands['cleanVehicle'] = function(a) TriggerClientEvent('apex_adminmenu:panel:cleanVehicle', tonumber(a[1])) end

Commands['spawnVehicle'] = function(a)
    TriggerClientEvent('apex_adminmenu:panel:spawnVehicle', tonumber(a[1]), tostring(a[2] or 'adder'))
end

-- Live Watch (the panel's Monitoring page).
--
-- This used to start its own capture on the watched client, through
-- screenshot-basic only: a server without that resource (it is optional)
-- answered every eye-icon click with "watchEnd" and a one-line error in
-- the Live feed, so the tile closed at once and the page sat on "Nobody
-- being watched" — while the in-game Monitoring page, which captures
-- through the resource's own NUI, worked. The browser now rides the same
-- stream the in-game page uses (server/adminpanel.lua): own NUI capture,
-- screenshot-basic as the fallback, latent upload, one capture loop no
-- matter how many admins watch.
Commands['startWatch'] = function(a)
    local target = tonumber(a[1])
    if not target or not GetPlayerName(target) then return false, 'That player is no longer online.' end
    if not PanelWebWatchStart then return false, 'Screen watch is not loaded on this server.' end
    local ok, err = PanelWebWatchStart(target)
    if ok == false then return false, err end
end
Commands['stopWatch'] = function(a)
    local target = tonumber(a[1])
    if target and PanelWebWatchStop then PanelWebWatchStop(target) end
end

Commands['console'] = function(a)
    local cmd = tostring(a[1] or '')
    if cmd == '' then return end
    PanelRelayConsole({ text = '> ' .. cmd, type = 'cmd', ts = os.time() * 1000 })
    ExecuteCommand(cmd)
end

Commands['resourceAction'] = function(a)
    local name, action = tostring(a[1] or ''), tostring(a[2] or '')
    if name == '' then return end
    if action == 'start'   then StartResource(name)
    elseif action == 'stop' then StopResource(name)
    elseif action == 'restart' then StopResource(name); Wait(250); StartResource(name) end
end

Commands['deleteVehicle'] = function(a)
    local plate = tostring(a[1] or '')
    if plate == '' then return end
    pcall(MySQL.query.await, 'DELETE FROM owned_vehicles WHERE plate = ?',  { plate })
    pcall(MySQL.query.await, 'DELETE FROM player_vehicles WHERE plate = ?', { plate })
end

-- Returns false + reason on refusal (runCommand sends it back to the panel).
-- Target = server id of an online player, or a license for someone offline.
-- Goes through PanelAddMember, so group aliases (mod → moderator) resolve
-- and a bad group or a missing table is reported instead of swallowed.
Commands['grantStaff'] = function(a)
    local raw, group = a[1], tostring(a[2] or 'helper')
    local lic, nick
    local id = tonumber(raw)
    if id then
        if not GetPlayerName(id) then return false, 'That player is no longer online.' end
        lic, nick = identifiersOf(id).license, GetPlayerName(id)
    elseif tostring(raw or ''):match('^license2?:%x+$') then
        lic, nick = tostring(raw):lower(), tostring(a[3] or '')
    end
    if not lic then return false, 'No license found for that player.' end
    if not PanelAddMember then return false, 'Staff system not loaded.' end
    local ok, res = PanelAddMember(lic, nick, group, '', 'web panel')
    if not ok then return false, res end
    if PanelReload then PanelReload() end
    return true
end

Commands['revokeStaff'] = function(a)
    local lic = tostring(a[1] or '')
    if lic == '' then return false, 'No license given.' end
    if not PanelRemoveMember then return false, 'Staff system not loaded.' end
    local ok, err = PanelRemoveMember(lic)
    if not ok then return false, err end
    if PanelReload then PanelReload() end
    return true
end

-- ============================================================
-- REQUESTS — return data to the panel
-- ============================================================

local Requests = {}

Requests['getResources'] = function()
    local out = {}
    for i = 0, GetNumResources() - 1 do
        local name = GetResourceByFindIndex(i)
        out[#out + 1] = {
            name = name,
            state = GetResourceState(name),
            version = GetResourceMetadata(name, 'version', 0),
        }
    end
    table.sort(out, function(x, y) return x.name < y.name end)
    return out
end

Requests['getPlayerDetail'] = function(a)
    local src = tonumber(a[1])
    if not src or not GetPlayerName(src) then return nil end

    local ped = GetPlayerPed(src)
    local coords = ped and ped ~= 0 and GetEntityCoords(ped) or nil
    local accounts = {}

    if Framework == 'esx' and ESX then
        local x = ESX.GetPlayerFromId(src)
        if x then
            for _, acc in pairs(x.getAccounts and x.getAccounts() or {}) do
                accounts[#accounts + 1] = { name = acc.name, amount = acc.money }
            end
        end
    else
        local pl = GetPlayer and GetPlayer(src)
        local money = pl and pl.PlayerData and pl.PlayerData.money
        for name, amount in pairs(money or {}) do
            accounts[#accounts + 1] = { name = name, amount = amount }
        end
    end

    return {
        health   = ped and ped ~= 0 and GetEntityHealth(ped) or 200,
        armour   = ped and ped ~= 0 and GetPedArmour(ped) or 0,
        ping     = GetPlayerPing(src),
        coords   = coords and { x = coords.x, y = coords.y, z = coords.z } or nil,
        accounts = accounts,
        identifiers = identifiersOf(src),
    }
end

Requests['getBans'] = function()
    -- ban_time, not id: older installs have no `id` column on apex_bans
    -- and the query would fail outright.
    return { rows = safeQuery('SELECT * FROM apex_bans ORDER BY ban_time DESC LIMIT 300') or {} }
end

Requests['getWarnings'] = function()
    return { rows = safeQuery('SELECT * FROM apex_warnings ORDER BY id DESC LIMIT 300') or {} }
end

Requests['getLogs'] = function(a)
    local opts = a[1] or {}
    local q, cat = tostring(opts.q or ''), tostring(opts.category or '')
    local sql = 'SELECT * FROM apex_staff_log WHERE 1=1'
    local params = {}
    if cat ~= '' then sql = sql .. ' AND category = ?'; params[#params + 1] = cat end
    if q ~= '' then
        sql = sql .. ' AND (admin LIKE ? OR target LIKE ? OR details LIKE ? OR action LIKE ?)'
        local like = '%' .. q .. '%'
        params[#params + 1] = like; params[#params + 1] = like
        params[#params + 1] = like; params[#params + 1] = like
    end
    sql = sql .. ' ORDER BY id DESC LIMIT 300'
    return { rows = safeQuery(sql, params) or {} }
end

Requests['getVehicles'] = function()
    local rows
    if Framework == 'qb' then
        rows = safeQuery([[
            SELECT v.plate, v.vehicle AS model, v.garage, v.state,
                   COALESCE(p.name, v.license) AS ownerName
            FROM player_vehicles v LEFT JOIN players p ON p.license = v.license
            ORDER BY v.plate LIMIT 1000
        ]])
    else
        rows = safeQuery([[
            SELECT v.plate, v.vehicle AS model, v.stored,
                   CONCAT(COALESCE(u.firstname,''),' ',COALESCE(u.lastname,'')) AS ownerName
            FROM owned_vehicles v LEFT JOIN users u ON u.identifier = v.owner
            ORDER BY v.plate LIMIT 1000
        ]])
        for _, r in ipairs(rows or {}) do
            r.state = (tonumber(r.stored) == 1) and 'stored' or 'out'
            -- ESX keeps the model inside a JSON blob.
            if r.model and r.model:sub(1, 1) == '{' then
                local ok, v = pcall(json.decode, r.model)
                if ok and v and v.model then r.model = tostring(v.model) end
            end
        end
    end
    return { rows = rows or {} }
end

Requests['getStaff'] = function()
    local hasTable = pcall(MySQL.scalar.await, 'SELECT 1 FROM apex_staff LIMIT 1')

    -- Group catalogue for the grant dropdown.
    local groups = {}
    for name, g in pairs(PanelGetGroups and PanelGetGroups() or {}) do
        groups[#groups + 1] = { name = name, label = g.label or name, hierarchy = g.hierarchy or 99 }
    end
    table.sort(groups, function(x, y) return (x.hierarchy or 99) < (y.hierarchy or 99) end)

    -- ── Members ─────────────────────────────────────────────
    -- TWO sources, and showing only the first was the bug: an admin
    -- who gets their rank from Config.AdminPerms.UserGroups or an ACE
    -- permission has NO row in apex_staff, so the list read "0 staff"
    -- while they were plainly standing in the server with access.
    --
    --   • db     — a row in apex_staff. Revocable from here.
    --   • config — resolved live from UserGroups/ACE. Read-only here,
    --              because it lives in server.cfg, not the database.
    --
    -- Rows and online players are matched by PanelLicKey (server/staff.lua):
    -- a row stored as the bare ESX identifier, as license2: or in another
    -- case is the same account as the player whose GetPlayerIdentifiers says
    -- "license:…". Compared raw, that one admin became two entries — one
    -- online, one offline.
    local members, byKey = {}, {}
    local keyOf = function(v) return PanelLicKey and PanelLicKey(v) or tostring(v or ''):lower() end

    -- Every key each online player can be found under, claimed up front.
    local online, onlineByKey, srcKeys = {}, {}, {}
    for _, p in ipairs(GetPlayers()) do
        local src = tonumber(p)
        if src and GetPlayerName(src) then
            online[#online + 1] = { id = src, name = GetPlayerName(src) }
            local keys = PanelPlayerKeys and PanelPlayerKeys(src) or { keyOf(identifiersOf(src).license) }
            srcKeys[src] = keys
            for _, k in ipairs(keys) do if k ~= '' then onlineByKey[k] = src end end
        end
    end
    local function claim(entry, keys)
        for _, k in ipairs(keys) do if k ~= '' and not byKey[k] then byKey[k] = entry end end
    end

    if hasTable then
        for _, r in ipairs(safeQuery('SELECT license, nickname, group_name FROM apex_staff') or {}) do
            local lic = tostring(r.license or '')
            local k = keyOf(lic)
            if lic ~= '' and k ~= '' and not byKey[k] then
                local src = onlineByKey[k]
                local entry = {
                    license  = lic,
                    nickname = r.nickname,
                    group    = r.group_name,
                    origin   = 'db',
                    online   = src ~= nil,
                    id       = src,
                }
                members[#members + 1] = entry
                claim(entry, { k })
                if src then claim(entry, srcKeys[src] or {}) end
            end
        end
    end

    -- Anyone online who resolves to a group but isn't already listed.
    for _, o in ipairs(online) do
        local src = o.id
        local lic = identifiersOf(src).license
        local keys = srcKeys[src] or {}
        local listed = nil
        for _, k in ipairs(keys) do if byKey[k] then listed = byKey[k]; break end end

        -- Same resolver the heartbeat uses, so the Overview counter
        -- and this list can never disagree again.
        local groupName = staffGroupOf(src)

        if groupName and not listed then
            local entry = {
                license  = lic or ('src:' .. src),
                nickname = o.name,
                group    = groupName,
                origin   = 'config',
                online   = true,
                id       = src,
            }
            members[#members + 1] = entry
            claim(entry, keys)
        end
    end

    -- Why each online player did or didn't resolve to a group. Surfaced
    -- so "0 staff" can be diagnosed from the response itself instead of
    -- needing console access.
    local debugRows = {}
    for _, o in ipairs(online) do
        local okA, isAdmin = pcall(AdminPerms, o.id)
        local okG, grp = pcall(PanelGetGroup, o.id)
        debugRows[#debugRows + 1] = {
            id = o.id,
            name = o.name,
            adminPerms  = okA and isAdmin or false,
            panelGroup  = okG and grp or nil,   -- table + UserGroups + ACE
            resolved    = staffGroupOf(o.id),   -- what the panel actually uses
        }
    end

    return {
        -- `hasSystem` now means "can I GRANT from here", which needs the
        -- table. Config-derived staff still show up without it.
        hasSystem = hasTable,
        groups    = groups,
        online    = online,
        members   = members,
        -- Bump this whenever getStaff changes shape. If the panel shows
        -- an older number than the code on disk, the resource has not
        -- been restarted — which is exactly the trap this hit.
        version   = 3,
        debug     = debugRows,
    }
end

Requests['getRichest'] = function()
    local rows
    if Framework == 'qb' then
        rows = safeQuery("SELECT name, money FROM players ORDER BY id DESC LIMIT 200")
        local out = {}
        for _, r in ipairs(rows or {}) do
            local ok, m = pcall(json.decode, r.money or '{}')
            local total = 0
            if ok and m then for _, v in pairs(m) do total = total + (tonumber(v) or 0) end end
            out[#out + 1] = { name = r.name, wealth = total }
        end
        table.sort(out, function(x, y) return x.wealth > y.wealth end)
        for i, r in ipairs(out) do r.rank = i end
        return { rows = { table.unpack(out, 1, math.min(10, #out)) } }
    end

    rows = safeQuery([[
        SELECT CONCAT(COALESCE(firstname,''),' ',COALESCE(lastname,'')) AS name, job,
               (COALESCE(JSON_EXTRACT(accounts,'$.money'),0) + COALESCE(JSON_EXTRACT(accounts,'$.bank'),0)) AS wealth
        FROM users ORDER BY wealth DESC LIMIT 10
    ]])
    for i, r in ipairs(rows or {}) do r.rank = i end
    return { rows = rows or {} }
end

-- Shares the panel's resolver (server/adminpanel.lua) rather than keeping
-- a second, divergent copy. The old version here fell back to
-- `SELECT name, label FROM items` — an ESX-only table that does not exist
-- in a QBCore schema — so the web panel's item list was empty on QB for
-- the same reason the in-game Items page was, but by a different route.
-- adminpanel.lua sorts alphabetically before webpanel.lua in the
-- `server/*.lua` glob, so the global is always defined by the time a
-- request can arrive.
Requests['getItems'] = function()
    if type(PanelItemCatalog) ~= 'function' then return { items = {} } end
    local list = PanelItemCatalog()
    return { items = list }
end

Requests['getJobs'] = function()
    local jobs = {}
    if Framework == 'qb' then
        local ok, shared = pcall(function() return exports['qb-core']:GetCoreObject().Shared.Jobs end)
        if ok and shared then
            for name, j in pairs(shared) do
                local grades = {}
                for g, gd in pairs(j.grades or {}) do
                    grades[#grades + 1] = { grade = tonumber(g) or 0, label = gd.name or ('Grade ' .. g) }
                end
                table.sort(grades, function(x, y) return x.grade < y.grade end)
                jobs[#jobs + 1] = { name = name, label = j.label or name, grades = grades }
            end
        end
        return { backend = IsQBox and 'qbox' or 'qbcore', jobs = jobs }
    end

    for _, j in ipairs(safeQuery('SELECT name, label FROM jobs') or {}) do
        local grades = {}
        for _, g in ipairs(safeQuery('SELECT grade, label FROM job_grades WHERE job_name = ? ORDER BY grade', { j.name }) or {}) do
            grades[#grades + 1] = { grade = tonumber(g.grade) or 0, label = g.label }
        end
        jobs[#jobs + 1] = { name = j.name, label = j.label, grades = grades }
    end
    return { backend = 'esx', jobs = jobs }
end

Requests['getJobMembers'] = function(a)
    local job = tostring(a[1] or '')
    if job == '' then return { members = {} } end

    -- Matched by PanelLicKey: the framework table spells the identifier
    -- differently from GetPlayerIdentifiers (bare on ESX, license2: on
    -- QBox), so a raw compare marked every online employee offline.
    local onlineByKey = {}
    for _, p in ipairs(GetPlayers()) do
        local src = tonumber(p)
        if src then
            local keys = PanelPlayerKeys and PanelPlayerKeys(src)
                or { (identifiersOf(src).license or ''):lower() }
            for _, k in ipairs(keys) do if k ~= '' then onlineByKey[k] = src end end
        end
    end

    local rows
    if Framework == 'qb' then
        rows = safeQuery("SELECT license, name, JSON_EXTRACT(job,'$.grade.level') AS grade FROM players WHERE JSON_EXTRACT(job,'$.name') = ? LIMIT 200", { job })
    else
        rows = safeQuery("SELECT identifier AS license, CONCAT(COALESCE(firstname,''),' ',COALESCE(lastname,'')) AS name, job_grade AS grade FROM users WHERE job = ? LIMIT 200", { job })
    end

    for _, r in ipairs(rows or {}) do
        local k = PanelLicKey and PanelLicKey(r.license) or tostring(r.license or ''):lower()
        r.online = onlineByKey[k] ~= nil
        r.id = onlineByKey[k]
        r.grade = tonumber(r.grade) or 0
    end
    return { members = rows or {} }
end

Commands['setMemberJob'] = function(a)
    local target, job, grade = a[1], tostring(a[2] or ''), tonumber(a[3]) or 0
    local src = tonumber(target)
    if src and GetPlayerName(src) then
        if SetJob then
            local ok, reason = SetJob(src, job, grade)
            if ok == false then
                PanelRelayEvent({ type = 'error', message = ('setJob failed: %s'):format(reason or 'rejected by the framework') })
                return false, ('setJob failed: %s'):format(reason or 'rejected by the framework')
            end
        end
        return
    end
    -- Offline: write straight to the framework's table.
    if Framework == 'qb' then
        pcall(MySQL.query.await, "UPDATE players SET job = JSON_SET(job,'$.name',?,'$.grade.level',?) WHERE license = ?", { job, grade, tostring(target) })
    else
        pcall(MySQL.query.await, 'UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', { job, grade, tostring(target) })
    end
end

Commands['fireMember'] = function(a)
    return Commands['setMemberJob']({ a[1], 'unemployed', 0 })
end

-- ============================================================
-- TRANSPORT
-- ============================================================

local function runCommand(entry)
    local name  = entry.name
    local args  = entry.args or {}
    local reqId = entry.reqId

    local handler = Requests[name]
    if handler then
        local ok, res = pcall(handler, args)
        reply(reqId, ok, ok and res or nil)
        if not ok then
            print(('^1[apex_adminmenu] panel request "%s" failed: %s^0'):format(name, tostring(res)))
        end
        return
    end

    handler = Commands[name]
    if not handler then
        print(('^3[apex_adminmenu] panel sent an unknown command: %s^0'):format(tostring(name)))
        reply(reqId, false, nil)
        return
    end

    -- A command may return false + a reason; the panel shows the reason.
    local ok, res, msg = pcall(handler, args)
    if not ok then
        print(('^1[apex_adminmenu] panel command "%s" failed: %s^0'):format(name, tostring(res)))
        reply(reqId, false, { error = tostring(res) })
        return
    end
    if res == false then
        reply(reqId, false, { error = msg and tostring(msg) or 'refused' })
        return
    end
    reply(reqId, true, nil)
end

local function flush()
    local events, console, chat = pendingEvents, pendingConsole, pendingChat
    pendingEvents, pendingConsole, pendingChat = {}, {}, {}
    if #events == 0 and #console == 0 and #chat == 0 then return end
    post('event', { events = events, console = console, chat = chat })
end

-- What is wrong with the configured URL, in words, or nil when it looks
-- usable. The two things people actually type in: the README's
-- placeholder left as-is, and the GAME server's address (the URL is where
-- the web panel is opened in the browser, not where FiveM listens).
function PanelUrlProblem(u)
    u = tostring(u or '')
    if u == '' then return nil end
    if u:find('your-panel-url', 1, true) or u:find('panel.example.com', 1, true) then
        return 'is still the placeholder from the README. Put the address you open the web panel at in the browser (https://…).'
    end
    if not u:match('^https?://') then
        return 'must start with https:// (or http://), exactly as the web panel is opened in the browser.'
    end
    if u:match('^https?://[^/]*:30120') then
        return 'points at the FiveM server (port 30120). It must be the web panel\'s own address, the one you log into in the browser, not the game server.'
    end
    return nil
end

CreateThread(function()
    if not enabled then
        if PANEL_URL ~= '' or PANEL_KEY ~= '' then
            print('^3[apex_adminmenu] Web panel: set BOTH apex_panel_url and apex_panel_key to connect.^0')
            print('^3[apex_adminmenu]   apex_panel_url = the address you open the web panel at in the browser (https://…)^0')
            print('^3[apex_adminmenu]   apex_panel_key = the server key shown on the panel\'s Setup tab^0')
        end
        return
    end

    local problem = PanelUrlProblem(PANEL_URL)
    if problem then
        print(('^1[apex_adminmenu] Web panel: apex_panel_url "%s" %s^0'):format(PANEL_URL, problem))
        print('^3[apex_adminmenu] Fix it in server.cfg, restart, then run `apexpaneltest` in the server console.^0')
    end

    print(('^2[apex_adminmenu] Web panel relay starting → %s^0'):format(PANEL_URL))

    -- ── Reporting policy ────────────────────────────────────
    -- The old rule was "print on the first failure, print again the moment
    -- ONE heartbeat succeeds". A panel that throws intermittently — say, on
    -- every beat where a player is still loading in — therefore produced an
    -- endless
    --      rejected the heartbeat (HTTP 500)
    --      connection restored.
    -- ladder, one pair every three seconds, forever. The connection was
    -- never actually down; the console was just narrating every flap.
    --
    -- Now the relay only speaks when something is genuinely wrong: it stays
    -- quiet until FAIL_STREAK heartbeats in a row have failed, says so once,
    -- and won't repeat itself for RENOTIFY_MS. "Restored" prints only if a
    -- failure was actually reported, and it says how many beats were lost.
    local FAIL_STREAK = 4              -- ≈ 6 s of solid failure before we speak
    local RENOTIFY_MS = 5 * 60 * 1000  -- and at most one report every 5 min

    -- One heartbeat in flight at a time. The old loop posted every
    -- HEARTBEAT_MS no matter what, so a panel slower than 1.5s left
    -- requests stacking on the shared HTTP client.
    local inFlight, backoff = false, 0
    local fails, reported, lastReportAt, lostBeats = 0, false, 0, 0

    while true do
        if not inFlight then
            inFlight = true
            post('heartbeat', { state = collectState(), meta = {
                hostname = GetConvar('sv_hostname', 'FiveM Server'),
                maxSlots = tonumber(GetConvar('sv_maxclients', '48')) or 48,
            } }, function(status, text)
                inFlight = false

                if status ~= 200 then
                    fails      = fails + 1
                    lostBeats  = lostBeats + 1
                    backoff    = math.min(backoff == 0 and 1 or backoff * 2, 20)

                    local now = GetGameTimer()
                    if fails >= FAIL_STREAK
                        and (not reported or now - lastReportAt >= RENOTIFY_MS) then
                        reported, lastReportAt = true, now
                        -- Print what the panel ACTUALLY answered. A 500 means
                        -- the request reached it and it threw, so the old
                        -- "check your url and key" advice sent people looking
                        -- at the two things that were fine.
                        print(('^1[apex_adminmenu] Web panel unreachable — %d heartbeats rejected (HTTP %s): %s^0')
                            :format(fails, tostring(status),
                                    tostring(text or ''):gsub('[\r\n]', ' '):sub(1, 300)))
                        if status == 0 or status == 401 or status == 403 or status == 404 then
                            print('^3[apex_adminmenu] Check apex_panel_url and apex_panel_key, then run `apexpaneltest` in the server console.^0')
                        elseif status == 500 then
                            print('^3[apex_adminmenu] HTTP 500 means the panel received the data and threw on it — the fault is on the panel side, not in your server.cfg. Retrying quietly.^0')
                        end
                    end
                    return
                end

                backoff, fails = 0, 0
                if reported then
                    reported = false
                    print(('^2[apex_adminmenu] Web panel connection restored (%d heartbeats lost).^0')
                        :format(lostBeats))
                end
                lostBeats = 0

                local ok, data = pcall(json.decode, text or '{}')
                if ok and data and data.commands then
                    for _, c in ipairs(data.commands) do runCommand(c) end
                end
            end)

            -- While the panel is failing, the buffers keep filling and
            -- pushCapped keeps them bounded. Posting them into a panel that
            -- is already throwing only doubles the traffic and the failures,
            -- so hold off until a heartbeat lands again.
            if fails < FAIL_STREAK then flush() end
        end

        -- Sleep in slices rather than one long Wait.
        --
        -- The backoff is decided when the request GOES OUT, but it is cleared
        -- by the callback, which lands a moment later. `Wait(HEARTBEAT_MS *
        -- backoff)` therefore committed to a sleep of up to 30 seconds using
        -- a backoff that the very next callback made obsolete: the panel came
        -- back and the relay kept sleeping, so the panel showed the server as
        -- offline for another half minute for no reason. Re-reading the
        -- backoff each slice means recovery is noticed within one beat.
        local slept = 0
        repeat
            Wait(HEARTBEAT_MS)
            slept = slept + HEARTBEAT_MS
        until slept >= HEARTBEAT_MS * (backoff > 0 and backoff or 1)
    end
end)

-- ============================================================
-- DIAGNOSTIC
-- ------------------------------------------------------------
--   apexpaneltest
-- Answers "can THIS server reach the panel?" without guesswork:
-- the plain URL, the FQDN form the relay falls back to, and two
-- outside controls that prove HTTPS works at all. Console only.
-- ============================================================
RegisterCommand('apexpaneltest', function(src)
    if src ~= 0 then return end
    if not enabled then
        print('^3[paneltest] apex_panel_url / apex_panel_key nao estao definidos.^0')
        return
    end

    local function probe(label, target, headers)
        local h = headers or {}
        h['Content-Type'] = 'application/json'
        PerformHttpRequest(target, function(status, text)
            local snippet = tostring(text or ''):gsub('[\r\n]', ' '):sub(1, 90)
            print(('^5[paneltest] %-30s -> HTTP %s | %s^0'):format(label, tostring(status), snippet))
        end, 'GET', '', h)
    end

    print(('^5[paneltest] URL=[%s]  host=[%s]  modo FQDN=%s^0')
        :format(PANEL_URL, HOSTPORT or '?', tostring(fqdnMode)))
    probe('URL normal', SCHEME .. HOSTPORT .. BASEPATH .. '/api/health')
    if canFqdn then
        probe('FQDN + Host', SCHEME .. HOSTNAME .. '.' .. PORTPART .. BASEPATH .. '/api/health',
            { ['Host'] = HOSTPORT })
    end
    probe('controlo: cloudflare', 'https://www.cloudflare.com/')
    probe('controlo: google', 'https://www.google.com/')
end, true)

-- ============================================================
-- DIAGNOSTIC
-- ------------------------------------------------------------
--   apexwho <serverId>
-- Prints every layer of the permission chain for one player, so a
-- "why am I not staff?" question is answered by data instead of
-- guesswork. Console only.
-- ============================================================
RegisterCommand('apexwho', function(src, args)
    if src ~= 0 then return end

    local target = tonumber(args[1])
    if not target then
        print('^3usage: apexwho <serverId>^0')
        return
    end
    if not GetPlayerName(target) then
        print(('^1No player online with id %s^0'):format(target))
        return
    end

    print(('^5=== apexwho %s (%s) ===^0'):format(target, GetPlayerName(target)))

    local ids = identifiersOf(target)
    print(('  license           : %s'):format(ids.license or '(none)'))

    -- Framework group
    local okG, fwGroup = pcall(function()
        local pl = GetPlayer and GetPlayer(target)
        if not pl then return nil end
        if pl.getGroup then return pl.getGroup() end
        return pl.PlayerData and pl.PlayerData.group
    end)
    print(('  framework group   : %s'):format(okG and tostring(fwGroup) or 'ERROR'))

    -- Config.AdminPerms.UserGroups
    if Config and Config.AdminPerms and Config.AdminPerms.UserGroups then
        print(('  UserGroups enabled: %s'):format(tostring(Config.AdminPerms.UserGroups.enabled)))
        for _, g in ipairs(Config.AdminPerms.UserGroups.Groups or {}) do
            local ok, res = pcall(HasPermission, target, g)
            print(('    HasPermission(%-11s) = %s'):format(g, ok and tostring(res) or 'ERROR'))
        end
    end

    -- ACE
    if Config and Config.AdminPerms and Config.AdminPerms.AcePerms then
        local perm = Config.AdminPerms.AcePerms.AcePerm
        print(('  AcePerms enabled  : %s (%s)'):format(tostring(Config.AdminPerms.AcePerms.enabled), tostring(perm)))
        if perm then
            print(('    IsPlayerAceAllowed = %s'):format(tostring(IsPlayerAceAllowed(target, perm))))
        end
    end

    -- Registry
    print(('  apex_staff row    : %s'):format(PanelGetMember and (PanelGetMember(target) and 'yes' or 'no') or 'n/a'))

    local groups = PanelGetGroups and PanelGetGroups() or {}
    local names = {}
    for n in pairs(groups) do names[#names + 1] = n end
    table.sort(names)
    print(('  known groups      : %s'):format(#names > 0 and table.concat(names, ', ') or '(NONE — this is the bug)'))

    -- The verdicts the panel actually uses
    local okAdmin, isAdmin = pcall(AdminPerms, target)
    print(('  AdminPerms()      : %s'):format(okAdmin and tostring(isAdmin) or 'ERROR'))

    local okGrp, resolved = pcall(PanelGetGroup, target)
    print(('^2  PanelGetGroup()   : %s^0'):format(okGrp and tostring(resolved) or 'ERROR'))

    if not resolved then
        print('^1  → No group resolved. The web panel staff list uses this,^0')
        print('^1    which is why the player does not appear there.^0')
    end
end, true)

-- ── Feed the panel's live views ─────────────────────────────

AddEventHandler('chatMessage', function(src, author, msg)
    PanelRelayChat({ id = src, author = author or GetPlayerName(src), message = msg, ts = os.time() * 1000 })
end)

AddEventHandler('playerConnecting', function(name)
    PanelRelayEvent({ type = 'join', message = ('%s is connecting'):format(name) })
end)

AddEventHandler('playerDropped', function(reason)
    PanelRelayEvent({ type = 'leave', message = ('%s left (%s)'):format(GetPlayerName(source) or '?', reason or '') })
end)

-- Screen-watch frames come from the shared spectate stream
-- (server/adminpanel.lua calls these when a target the browser watches
-- posts a frame, stops, or cannot capture).
--
-- Only the NEWEST frame per watched player is worth sending: a stale frame
-- is a picture of the past, and the generic 200-entry cap could still hold
-- 200 JPEG data URIs — a multi-megabyte POST that a panel will time out on
-- or reject outright. Replacing in place keeps the feed live and the body
-- small.
function PanelRelayWatchFrame(target, dataUri)
    if not enabled then return end
    if type(dataUri) ~= 'string' or dataUri == '' then return end

    for i = #pendingEvents, 1, -1 do
        local e = pendingEvents[i]
        if e.type == 'watchFrame' and e.target == target then
            e.dataUri = dataUri
            return
        end
    end
    PanelRelayEvent({ type = 'watchFrame', target = target, dataUri = dataUri })
end

-- Close the tile; with `reason`, also say why in the Live feed rather than
-- leaving the admin to guess.
function PanelRelayWatchEnd(target, reason)
    if not enabled then return end
    -- A frame still queued for this target would re-open the tile after
    -- the end marker; drop it.
    for i = #pendingEvents, 1, -1 do
        local e = pendingEvents[i]
        if e.type == 'watchFrame' and e.target == target then table.remove(pendingEvents, i) end
    end
    PanelRelayEvent({ type = 'watchEnd', target = target })
    if reason and reason ~= '' then
        PanelRelayEvent({
            type = 'error',
            message = ('%s: %s'):format(GetPlayerName(target) or ('#' .. tostring(target)), reason),
        })
    end
end

-- Something the stream wants the Live feed to know without closing the tile.
function PanelRelayWatchNotice(target, message)
    if not enabled then return end
    PanelRelayEvent({
        type = 'error',
        message = ('%s: %s'):format(GetPlayerName(target) or ('#' .. tostring(target)), tostring(message or '')),
    })
end
