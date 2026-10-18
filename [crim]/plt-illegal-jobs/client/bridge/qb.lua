
local QBCore = exports['qb-core']:GetCoreObject()
local groups = { 'job', 'gang' }
local playerGroups = {}

local function setPlayerData(playerData)
    table.wipe(playerGroups)
    for i = 1, #groups do
        local group = groups[i]
        local data = playerData[group]
        if data then playerGroups[group] = data end
    end
end

if LocalPlayer.state.isLoggedIn then
    setPlayerData(QBCore.Functions.GetPlayerData())
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    client.onPlayerLoad(true)
    setPlayerData(QBCore.Functions.GetPlayerData())
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    client.onPlayerLoad(false)
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(xPlayerData)
    setPlayerData(xPlayerData)
end)

function client.isPlayerLoaded()
    return LocalPlayer.state.isLoggedIn
end

function client.hasPlayerGotGroup(filter)
    local _type = type(filter)
    for i = 1, #groups do
        local group = groups[i]
        if _type == 'string' then
            local data = playerGroups[group]
            if filter == data?.name then return true end
        elseif _type == 'table' then
            local tabletype = table.type(filter)
            if tabletype == 'hash' then
                for name, grade in pairs(filter) do
                    local data = playerGroups[group]
                    if data?.name == name and grade <= data.grade then return true end
                end
            elseif tabletype == 'array' then
                for j = 1, #filter do
                    local name = filter[j]
                    local data = playerGroups[group]
                    if data?.name == name then return true end
                end
            end
        end
    end
end
