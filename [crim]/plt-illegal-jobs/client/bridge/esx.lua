
local ESX = exports.es_extended:getSharedObject()
local groups = { 'job', 'job2' }
local playerGroups = {}

local function setPlayerData(playerData)
    table.wipe(playerGroups)
    for i = 1, #groups do
        local group = groups[i]
        local data = playerData[group]
        if data then playerGroups[group] = data end
    end
end

if ESX.PlayerLoaded then setPlayerData(ESX.PlayerData) end

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    if source == '' then return end
    client.onPlayerLoad(true)
    setPlayerData(xPlayer)
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    if source == '' then return end
    client.onPlayerLoad(false)
end)

RegisterNetEvent('esx:setJob', function(job)
    if source == '' then return end
    playerGroups.job = job
end)

RegisterNetEvent('esx:setJob2', function(job)
    if source == '' then return end
    playerGroups.job2 = job
end)

function client.isPlayerLoaded()
    return ESX.IsPlayerLoaded()
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
