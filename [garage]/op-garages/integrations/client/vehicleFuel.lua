function getFuel(veh)
    debugPrint('Getting fuel of vehicle', veh)
    if not veh or veh == 0 or not DoesEntityExist(veh) then
        return 100.0
    end

    if Config.FuelDependency == "cdn-fuel" then
        return exports['cdn-fuel']:GetFuel(veh)
    elseif Config.FuelDependency == "ox-fuel" then
        local stateFuel = Entity(veh).state and Entity(veh).state.fuel
        local nativeFuel = GetVehicleFuelLevel(veh)
        local value = tonumber(stateFuel) or tonumber(nativeFuel) or 100.0
        if value ~= value then -- NaN
            value = 100.0
        end
        return value
    elseif Config.FuelDependency == "LegacyFuel" then
        return exports["LegacyFuel"]:GetFuel(veh)
    elseif Config.FuelDependency == "qs-fuel" then
        return exports['qs-fuelstations']:GetFuel(veh)
    elseif Config.FuelDependency == "rcore-fuel" then
        return exports["rcore_fuel"]:GetVehicleFuelPercentage(veh)
    elseif Config.FuelDependency == "codem-xfuel" then
        return exports['x-fuel']:GetFuel(veh)
    elseif Config.FuelDependency == "lc_fuel" then
        return exports["lc_fuel"]:GetFuel(veh)
    elseif Config.FuelDependency == "stg-fuel" then
        return exports["stg-fuel"]:GetFuel(veh)
    elseif Config.FuelDependency == "myFuel" then
        return exports["myFuel"]:GetFuel(veh)
    elseif Config.FuelDependency == "lt-fuel" then
        return exports["lt-fuel"]:GetFuel(veh)
    else
        return GetVehicleFuelLevel(veh) or 100.0
    end
end

function setFuel(veh, level)
    if not veh or veh == 0 or not DoesEntityExist(veh) then
        return
    end

    if level == nil then
        level = 100.0
    end

    level = tonumber(level) or 100.0
    if level ~= level then -- NaN
        level = 100.0
    end
    if level < 0 then
        level = 0.0
    end
    if level > 100 then
        level = 100.0
    end

    if Config.FuelDependency == "none" then
        level = level > 0 and level or 100.0
    end

    debugPrint('Setting fuel of vehicle', veh, level)

    -- Always set native fuel immediately (local / engine start)
    SetVehicleFuelLevel(veh, level + 0.0)

    if Config.FuelDependency == "cdn-fuel" then
        exports['cdn-fuel']:SetFuel(veh, level)
    elseif Config.FuelDependency == "ox-fuel" then
        -- ONE replicated server set — do NOT write Entity.state from client
        -- (causes requestSetStateBag traffic) and do NOT retry-spam.
        if NetworkGetEntityIsNetworked(veh) then
            local netId = NetworkGetNetworkIdFromEntity(veh)
            if netId and netId ~= 0 then
                TriggerServerEvent('op-garages:setVehicleFuel', netId, level + 0.0)
            end
        end
    elseif Config.FuelDependency == "LegacyFuel" then
        exports["LegacyFuel"]:SetFuel(veh, level)
    elseif Config.FuelDependency == "qs-fuel" then
        exports['qs-fuelstations']:SetFuel(veh, level)
    elseif Config.FuelDependency == "rcore-fuel" then
        exports["rcore_fuel"]:SetVehicleFuel(veh, level)
    elseif Config.FuelDependency == "codem-xfuel" then
        exports['x-fuel']:SetFuel(veh, level)
    elseif Config.FuelDependency == "lc_fuel" then
        exports["lc_fuel"]:SetFuel(veh, level)
    elseif Config.FuelDependency == "stg-fuel" then
        exports["stg-fuel"]:SetFuel(veh, level)
    elseif Config.FuelDependency == "myFuel" then
        exports["myFuel"]:SetFuel(veh, level)
    elseif Config.FuelDependency == "lt-fuel" then
        exports["lt-fuel"]:SetFuel(veh, level)
    end
end
