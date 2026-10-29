-- NUI <-> server bridge for the per-player music library.

-- Re-assert NUI focus. CEF loses keyboard/mouse focus on the NUI overlay
-- after the OS file picker closes; the NUI must call this to re-arm input
-- before subsequent clicks (like opening another file picker) will register.
RegisterNUICallback('keepFocus', function(_, cb)
    SetNuiFocus(true, true)
    cb({ ok = true })
end)


RegisterNUICallback('library_list', function(_, cb)
    lib.callback('pickle_dj:library:list', false, function(result)
        cb(result or { ok = false, error = "no_response", items = {} })
    end)
end)

-- Presigned-URL upload protocol.
-- The NUI uploads file bytes directly to Fivemanage via the presigned URL;
-- file bytes never transit FiveM events. This bridge only carries metadata:
--   1) library_upload_request: NUI asks server for a presigned URL.
--   2) (NUI does the PUT/POST to Fivemanage on its own.)
--   3) library_upload_confirm: NUI tells server the upload succeeded and
--      passes back the FM-returned file id + public URL so the DB row can
--      be created.
-- Both legs reuse a single `pickle_dj:library:uploadResponse` net event,
-- multiplexed by a client-generated reqId stored in `pending`.
local pending = {}

local function newReqId()
    return ("%s_%s"):format(GetGameTimer(), math.random(100000, 999999))
end

RegisterNetEvent('pickle_dj:library:uploadResponse', function(reqId, result)
    if type(reqId) ~= "string" then return end
    local cb = pending[reqId]
    if not cb then return end
    pending[reqId] = nil
    cb(result or { ok = false, error = "no_response" })
end)

local function dispatchUpload(eventName, timeoutMs, data, cb)
    local reqId = newReqId()
    pending[reqId] = cb
    SetTimeout(timeoutMs, function()
        local pendingCb = pending[reqId]
        if pendingCb then
            pending[reqId] = nil
            pendingCb({ ok = false, error = "timeout" })
        end
    end)
    TriggerServerEvent(eventName, reqId, data)
end

RegisterNUICallback('library_upload_request', function(data, cb)
    dispatchUpload('pickle_dj:library:requestUploadUrl', 30000, data, cb)
end)

RegisterNUICallback('library_upload_confirm', function(data, cb)
    dispatchUpload('pickle_dj:library:confirmUpload', 30000, data, cb)
end)

RegisterNUICallback('library_delete', function(data, cb)
    local id = data and data.id
    lib.callback('pickle_dj:library:delete', false, function(result)
        cb(result or { ok = false, error = "no_response" })
    end, id)
end)
