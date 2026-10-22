local states = {}

local function isPolice(source)
    local player = exports.qbx_core:GetPlayer(source)
    return player and player.PlayerData and player.PlayerData.job
        and player.PlayerData.job.name == 'police' and player.PlayerData.job.onduty == true
end

local function nearPoint(source, station, enabled)
    local ped = GetPlayerPed(source)
    if ped == 0 then return false end
    local playerCoords = GetEntityCoords(ped)
    local points = enabled and station.alarmPoints or station.resetPoints
    for _, coords in ipairs(points) do
        if #(playerCoords - coords.xyz) <= Config.ServerInteractDistance and Config.InFront(coords, playerCoords) then return true end
    end
    return false
end

RegisterNetEvent('hf1_stationalarm:server:set', function(stationId, enabled)
    local src = source
    if type(stationId) ~= 'string' or type(enabled) ~= 'boolean' then return end
    local station = Config.Stations[stationId]
    if not station or not isPolice(src) or not nearPoint(src, station, enabled) then return end
    if (states[stationId] == true) == enabled then return end
    states[stationId] = enabled
    TriggerClientEvent('hf1_stationalarm:client:state', -1, stationId, enabled)
end)

lib.callback.register('hf1_stationalarm:server:getStates', function()
    return states
end)
