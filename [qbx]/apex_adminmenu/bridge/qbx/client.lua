-- ============================================================
-- QBox (qbx_core) — client bridge
-- ============================================================
if GetResourceState('qbx_core') ~= 'started' then return end

QBX = exports.qbx_core
-- Report as 'qb' (NOT 'qbx') so the whole client codebase — which only
-- ever branches on Framework == 'qb' / 'esx' — treats QBox exactly like
-- QBCore. Nothing reads 'qbx'; leaving it as 'qbx' made every QB branch
-- (revive, heal, skin, player-data labels, give-money…) silently no-op on
-- QBox. The dedicated QBox detection lives in `IsQBox`.
Framework, PlayerLoaded, PlayerData = 'qb', nil, {}
IsQBox = true

-- QBox uses state bags + ox_lib to publish player data. We mirror
-- the same `PlayerData` global that the QBCore bridge sets, so
-- downstream code can read it without caring about the framework.
local function refresh()
    local ok, data = pcall(function() return exports.qbx_core:GetPlayerData() end)
    if ok and data then PlayerData = data end
end

AddStateBagChangeHandler('isLoggedIn', '', function(_bag, _key, value)
    if value then
        PlayerLoaded = true
        refresh()
    else
        PlayerLoaded = false
        PlayerData = {}
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if LocalPlayer.state and LocalPlayer.state.isLoggedIn then
        PlayerLoaded = true
        refresh()
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerLoaded = true
    refresh()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerLoaded = false
    PlayerData = {}
end)

RegisterNetEvent('qbx_core:client:playerLoggedIn', function()
    PlayerLoaded = true
    refresh()
end)

RegisterNetEvent('qbx_core:client:playerLoggedOut', function()
    PlayerLoaded = false
    PlayerData = {}
end)

-- Generic helpers used by the rest of the client code.
Notify = function(msg, t)
    if lib and lib.notify then
        lib.notify({ description = msg, type = t or 'inform' })
    else
        TriggerEvent('chat:addMessage', { args = { 'Admin', msg } })
    end
end

TriggerCallback = function(name, cb, ...)
    if lib and lib.callback then
        local res = lib.callback.await(name, false, ...)
        if cb then cb(res) end
    end
end
