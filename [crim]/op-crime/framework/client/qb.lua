QBCore = GetResourceState('qb-core') == 'started' and true or false
local tryQBox = GetResourceState('qbx_core') == 'started' and true or false

if not QBCore then return end
if tryQBox then return end

Framework = exports['qb-core']:GetCoreObject()
Fr.PlayerLoaded = 'QBCore:Client:OnPlayerLoaded'
Fr.PlayerUnLoaded = 'QBCore:Client:OnPlayerUnload'
Fr.VehicleEncode = "mods"
Fr.identificatorTable = "citizenid"
Fr.JobUpdateEvent = "QBCore:Client:OnJobUpdate"

Fr.TriggerServerCallback = function(...)
    return Framework.Functions.TriggerCallback(...)
end
Fr.GetVehicleProperties = function(vehicle) 
    return Framework.Functions.GetVehicleProperties(vehicle)
end
Fr.DeleteVehicle = function(vehicle)
    if Config.AdditionalScripts.advancedParking then
        exports["AdvancedParking"]:DeleteVehicle(tonumber(vehicle), false)
    end
    
    return Framework.Functions.DeleteVehicle(vehicle)
end
Fr.SetVehicleProperties = function(...) 
    return Framework.Functions.SetVehicleProperties(...)
end
Fr.GetPlayerData = function()
    return Framework.Functions.GetPlayerData()
end
Fr.isDead = function()
    local playerData = Fr.GetPlayerData()
    return playerData.metadata['isdead']
end