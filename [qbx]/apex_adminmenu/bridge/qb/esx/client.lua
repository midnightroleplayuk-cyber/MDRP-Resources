-- See bridge/qb/esx/server.lua for the dual-framework reasoning;
-- the same guard applies on the client side.
if GetResourceState('qb-core')   == 'started' then return end
if GetResourceState('qbx_core')  == 'started' then return end
if GetResourceState('es_extended') ~= 'started' then return end

Framework = 'esx'
ESX = nil

-- Wait for ESX to be initialized
CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Wait(0)
    end
    
    PlayerLoaded = true
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    PlayerLoaded = true
    TriggerEvent('apex_adminmenu:playerLoaded')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    TriggerEvent('apex_adminmenu:setJob', job.name)
end)

ShowNotification = function(msg, type)
    ESX.ShowNotification(msg)
end

ServerCallback = function(name, cb, ...)
    ESX.TriggerServerCallback(name, cb, ...)
end

HasGroup = function(filter)
    local type = type(filter)

    if type == 'string' then
        if PlayerData.job.name == filter then
            return PlayerData.job.name, PlayerData.job.grade
        end
    else
        local tabletype = table.type(filter)

        if tabletype == 'hash' then
            local grade = filter[PlayerData.job.name]

            if grade and grade <= PlayerData.job.grade then
                return PlayerData.job.name, PlayerData.job.grade
            end
        elseif tabletype == 'array' then
            for i = 1, #filter do
                local group = filter[i]

                if PlayerData.job.name == group then
                    return PlayerData.job.name, PlayerData.job.grade
                end
            end
        end
    end
end

GetGroup = function()
    return PlayerData.job.name, PlayerData.job.grade
end

GetGender = function()
    return (PlayerData.sex or 0)
end

IsPlayerDead = function()
    return IsEntityDead(cache.ped)
end
