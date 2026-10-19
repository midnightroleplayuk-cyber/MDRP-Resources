--[[
    Apex MDT - Client Apex Lib
    NUI bridge: SendUI, Notify, the client→server callback bus, and
    the UI-close focus helper. Mirrors the apex_fishing convention.
]]

Apex = Apex or {}

local function sendUI(action, data)
    SendNUIMessage({ action = action, payload = data or {} })
end
Apex.SendUI = sendUI

-- ─── Notify ──────────────────────────────────────────────
function Apex.Notify(message, type, duration)
    local title = (Config and Config.notify and Config.notify.title) or 'MDT'
    local dur   = duration or (Config and Config.notify and Config.notify.duration) or 4500

    -- ⚠ An export that does not exist raises while being INDEXED, so the
    -- state check alone is not a guard: wrap the call as well.
    if GetResourceState('apex_notify') == 'started' then
        local ok = pcall(function()
            exports['apex_notify']:Notify(message, type or 'info', title, dur)
        end)
        if ok then return end
    end

    --[[ ox_lib through its EVENT, not through `lib`.

         `lib` only exists in a resource that loads '@ox_lib/init.lua' as a
         shared_script, and doing that makes ox_lib a hard requirement: a
         server without it cannot start this resource at all. ox_lib itself
         registers `ox_lib:notify` as a net event and calls it that way in its
         own test code, so this gets the identical toast on servers that have
         ox_lib while servers without it lose nothing but this branch. ]]
    if GetResourceState('ox_lib') == 'started' then
        TriggerEvent('ox_lib:notify',
            { title = title, description = message, type = type or 'inform', duration = dur })
        return
    end

    sendUI('notify', { title = title, message = message, type = type or 'info', duration = dur })
end

RegisterNetEvent('apex_mdt:notify', function(message, type, duration)
    Apex.Notify(message, type, duration)
end)

-- ─── Callback bus (client → server with auto-id + promise) ──
local callbacks = {}
local cbCounter = 0

local function pack(...) return { n = select('#', ...), ... } end
local function unpackPacked(t) return table.unpack(t, 1, t.n or #t) end

function Apex.Callback(name, ...)
    cbCounter = cbCounter + 1
    local id = cbCounter
    local p  = promise.new()
    callbacks[id] = function(...)
        callbacks[id] = nil
        p:resolve(pack(...))
    end
    TriggerServerEvent('apex_mdt:cb', name, id, ...)
    return unpackPacked(Citizen.Await(p))
end

RegisterNetEvent('apex_mdt:cbResp', function(id, ...)
    local fn = callbacks[id]; if fn then fn(...) end
end)

-- ─── UI close helper ─────────────────────────────────────
RegisterNUICallback('ui_close', function(_, cb)
    cb({}); SetNuiFocus(false, false); SetNuiFocusKeepInput(false)
end)
