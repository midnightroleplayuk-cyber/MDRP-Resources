-- CoreFx Client Bridge
-- handles client-side framework wrappers (ESX/QBCore/QBox/Standalone)

Bridge = Bridge or {}
Bridge.Client = Bridge.Client or {}

QBCore = nil
ESX = nil

-- init framework object
CreateThread(function()
    Wait(100)
    
    if Bridge.Framework == 'qbox' then
        if GetResourceState('qb-core') == 'started' then
            local success, result = pcall(function()
                return exports['qb-core']:GetCoreObject()
            end)
            if success and result then QBCore = result end
        end
        
        if not QBCore then
            local success, result = pcall(function()
                return exports['qbx_core']:GetCoreObject()
            end)
            
            if success and result then
                QBCore = result
            else
                local success2, result2 = pcall(function()
                    return exports['qbx_core']:GetSharedObject()
                end)
                if success2 and result2 then QBCore = result2 end
            end
        end
        
    elseif Bridge.Framework == 'qbcore' then
        local success, result = pcall(function()
            return exports['qb-core']:GetCoreObject()
        end)
        if success and result then QBCore = result end
        
    elseif Bridge.Framework == 'esx' then
        local success, result = pcall(function()
            return exports['es_extended']:getSharedObject()
        end)
        if success and result then ESX = result end
    end
end)

-- player data helpers
function Bridge.Client.GetPlayerData()
    if Bridge.Framework == 'esx' then
        if ESX then return ESX.GetPlayerData() or {} end
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        if QBCore then return QBCore.Functions.GetPlayerData() or {} end
    end
    
    return {
        identifier = GetPlayerServerId(PlayerId()),
        name = GetPlayerName(PlayerId())
    }
end

function Bridge.Client.GetIdentifier()
    local playerData = Bridge.Client.GetPlayerData()
    
    if Bridge.Framework == 'esx' then
        return playerData.identifier
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        return playerData.citizenid
    else
        return tostring(GetPlayerServerId(PlayerId()))
    end
end

function Bridge.Client.IsPlayerLoaded()
    if Bridge.Framework == 'esx' then
        return ESX and ESX.IsPlayerLoaded and ESX.IsPlayerLoaded() or false
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        local playerData = Bridge.Client.GetPlayerData()
        return playerData and playerData.citizenid ~= nil
    else
        return true
    end
end

-- notifications
function Bridge.Client.Notify(message, type, duration)
    type = type or 'inform'
    duration = duration or 5000
    
    if Bridge.HasOxLib and lib and lib.notify then
        lib.notify({
            title = 'CoreFx Admin',
            description = message,
            type = type,
            duration = duration
        })
        return
    end
    
    if Bridge.Framework == 'esx' then
        if ESX and ESX.ShowNotification then
            ESX.ShowNotification(message)
        else
            TriggerEvent('chat:addMessage', { args = { 'CoreFx Admin', message } })
        end
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        if QBCore then
            QBCore.Functions.Notify(message, type, duration)
        else
            TriggerEvent('chat:addMessage', { args = { 'CoreFx Admin', message } })
        end
    else
        TriggerEvent('chat:addMessage', { args = { 'CoreFx Admin', message } })
    end
end

-- server callbacks
function Bridge.Client.TriggerCallback(name, cb, ...)
    if Bridge.HasOxLib and lib and lib.callback then
        lib.callback(name, false, cb, ...)
        return
    end
    
    if Bridge.Framework == 'esx' then
        if ESX and ESX.TriggerServerCallback then
            ESX.TriggerServerCallback(name, cb, ...)
        end
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        if QBCore then
            QBCore.Functions.TriggerCallback(name, cb, ...)
        end
    end
end

-- vehicle mods & properties
function Bridge.Client.SetVehicleProperties(vehicle, props)
    if not DoesEntityExist(vehicle) or not props then return end
    
    if Bridge.Framework == 'esx' then
        if ESX and ESX.Game and ESX.Game.SetVehicleProperties then
            ESX.Game.SetVehicleProperties(vehicle, props)
            return
        end
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        if QBCore and QBCore.Functions and QBCore.Functions.SetVehicleProperties then
            QBCore.Functions.SetVehicleProperties(vehicle, props)
            return
        end
    end
    
    -- basic fallback mods
    SetVehicleModKit(vehicle, 0)
    if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
    if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
    if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
    if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
    if props.modTurbo then ToggleVehicleMod(vehicle, 18, props.modTurbo) end
    
    if props.color1 then 
        if type(props.color1) == 'table' then
             SetVehicleCustomPrimaryColour(vehicle, props.color1[1], props.color1[2], props.color1[3])
        else
             ClearVehicleCustomPrimaryColour(vehicle)
             ClearVehicleCustomSecondaryColour(vehicle)
             SetVehicleColours(vehicle, props.color1, props.color2 or 0)
        end
    end
end

exports('SetVehicleProperties', Bridge.Client.SetVehicleProperties)

-- job helpers
function Bridge.Client.GetJob()
    local playerData = Bridge.Client.GetPlayerData()
    
    if Bridge.Framework == 'esx' then
        if playerData and playerData.job then
            return {
                name = playerData.job.name,
                label = playerData.job.label,
                grade = playerData.job.grade,
                grade_label = playerData.job.grade_label
            }
        end
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        if playerData and playerData.job then
            return {
                name = playerData.job.name,
                label = playerData.job.label,
                grade = playerData.job.grade.level,
                grade_label = playerData.job.grade.name
            }
        end
    end
    
    return {
        name = 'unemployed',
        label = 'Unemployed',
        grade = 0,
        grade_label = 'Unemployed'
    }
end

function Bridge.Client.SetJob(job, grade)
    TriggerServerEvent('ac-test:setJob', job, grade)
end

-- exports
exports('GetPlayerData', Bridge.Client.GetPlayerData)
exports('GetIdentifier', Bridge.Client.GetIdentifier)
exports('IsPlayerLoaded', Bridge.Client.IsPlayerLoaded)
exports('GetJob', Bridge.Client.GetJob)
exports('SetJob', Bridge.Client.SetJob)
exports('BridgeNotify', Bridge.Client.Notify)
exports('GetFramework', function() return Bridge.Framework end)
