
local QBX = nil

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    client.onPlayerLoad(true)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    client.onPlayerLoad(false)
end)

function client.isPlayerLoaded()
    return LocalPlayer.state.isLoggedIn
end

function client.hasPlayerGotGroup(filter)
    if QBX then return QBX:HasGroup(filter) end
    return true
end

if lib.checkDependency('qbx_core', '1.18.0', true) then
    QBX = exports.qbx_core
end
