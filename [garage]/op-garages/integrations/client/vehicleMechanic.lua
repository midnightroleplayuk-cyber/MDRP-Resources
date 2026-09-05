local function applyOxVehicleProperties(vehicle, props, fixVehicle)
    ScriptFunctions.EnsureVehicleOwnership(vehicle, 2000)
    local ok = lib.setVehicleProperties(vehicle, ScriptFunctions.SanitizeVehicleProps(vehicle, props), fixVehicle)
    ScriptFunctions.ClearVehiclePropStatebag(vehicle)
    return ok
end

local function waitForVehicleNetId(vehicle, timeoutMs)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return 0 end
    if not NetworkGetEntityIsNetworked(vehicle) then return 0 end

    timeoutMs = timeoutMs or 3000
    local deadline = GetGameTimer() + timeoutMs

    while GetGameTimer() < deadline do
        local netId = NetworkGetNetworkIdFromEntity(vehicle)
        if netId and netId ~= 0 and NetworkDoesNetworkIdExist(netId) then
            return netId
        end
        Wait(0)
    end

    return NetworkGetNetworkIdFromEntity(vehicle) or 0
end

ScriptFunctions.GetVehicleProperties = function(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return nil
    end

    if Config.MechanicScript == 'op-mechanic' then
        return exports['op-mechanic']:GetVehicleProperties(vehicle)
    end

    return lib.getVehicleProperties(vehicle)
end

ScriptFunctions.SetVehicleProperties = function(vehicle, props, fixVehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) or type(props) ~= 'table' then
        return false
    end

    if Config.MechanicScript == 'op-mechanic' then
        ScriptFunctions.EnsureVehicleOwnership(vehicle, 2000)
        local cleaned = ScriptFunctions.SanitizeVehicleProps(vehicle, props)
        local reliable = fixVehicle ~= false
        return exports['op-mechanic']:SetVehicleProperties(vehicle, cleaned, reliable)
    end

    if Config.MechanicScript == 'jg-mechanic' and Config.MechanicJgProps == true then
        local netId = waitForVehicleNetId(vehicle, 3000)
        if netId ~= 0 then
            ScriptFunctions.EnsureVehicleOwnership(vehicle, 2000)
            local cleaned = ScriptFunctions.SanitizeVehicleProps(vehicle, props)
            local ok, result = pcall(function()
                return exports['jg-mechanic']:setVehicleProperties(vehicle, cleaned, fixVehicle)
            end)
            if ok and result then return result end
        end
    end

    return applyOxVehicleProperties(vehicle, props, fixVehicle)
end

-- Load op-mechanic mileage into state bag after garage spawn
ScriptFunctions.EnsureVehicleMileage = function(vehicle, modelName)
    if Config.MechanicScript ~= 'op-mechanic' then return end
    if GetResourceState('op-mechanic') ~= 'started' then return end
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return end

    pcall(function()
        exports['op-mechanic']:EnsureVehicleMileage(vehicle)
    end)

    if NetworkGetEntityIsNetworked(vehicle) then
        local netId = NetworkGetNetworkIdFromEntity(vehicle)
        if netId and netId ~= 0 then
            TriggerServerEvent('op-garages:ensureVehicleMileage', netId, modelName)
        end
    end
end