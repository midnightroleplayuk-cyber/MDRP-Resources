ESX = GetResourceState('es_extended') == 'started' and true or false
if not ESX then return end

Framework = exports["es_extended"]:getSharedObject()
Fr.PlayerLoaded = 'esx:playerLoaded'
Fr.PlayerUnLoaded = 'esx:onPlayerLogout'
Fr.VehicleEncode = "vehicle"
Fr.identificatorTable = "identifier"
Fr.JobUpdateEvent = "esx:setJob"

Fr.TriggerServerCallback = function(...)
    return Framework.TriggerServerCallback(...)
end

Fr.GetVehicleProperties = function(vehicle)
    return lib.getVehicleProperties(vehicle)
end

Fr.DeleteVehicle = function(vehicle)
    if Config.AdditionalScripts.advancedParking then
        exports["AdvancedParking"]:DeleteVehicle(tonumber(vehicle), false)
    end

    return Framework.Game.DeleteVehicle(vehicle)
end

Fr.SetVehicleProperties = function(vehicle, props)
    return lib.setVehicleProperties(vehicle, props)
end

Fr.GetPlayerData = function()
    return Framework.GetPlayerData()
end

Fr.isDead = function()
    local playerData = Fr.GetPlayerData()
    return playerData.dead
end