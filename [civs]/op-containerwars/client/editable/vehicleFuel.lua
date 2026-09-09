function getFuel(veh)
    if Config.FuelDependency == "cdn-fuel" then
        return exports['cdn-fuel']:GetFuel(veh)
    elseif Config.FuelDependency == "ox-fuel" then
        return Entity(veh).state.fuel
    elseif Config.FuelDependency == "none" then
        return GetVehicleFuelLevel(veh, level)
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
    end
end

function setFuel(veh, level)
    if level == nil then
        level = 50.0
    end

    if Config.FuelDependency == "cdn-fuel" then
        exports['cdn-fuel']:SetFuel(veh, level)
    elseif Config.FuelDependency == "ox-fuel" then
        Entity(veh).state.fuel = level
        SetVehicleFuelLevel(veh, level)
    elseif Config.FuelDependency == "none" then
        SetVehicleFuelLevel(veh, level)
    elseif Config.FuelDependency == "LegacyFuel" then
        exports["LegacyFuel"]:SetFuel(veh, level)
    elseif Config.FuelDependency == "qs-fuel" then
        exports['qs-fuelstations']:GetFuel(veh)
    elseif Config.FuelDependency == "rcore-fuel" then
        exports["rcore_fuel"]:SetVehicleFuel(veh, level)
    elseif Config.FuelDependency == "codem-xfuel" then
        exports['x-fuel']:SetFuel(veh, level)
    elseif Config.FuelDependency == "lc_fuel" then
        exports["lc_fuel"]:SetFuel(veh, level)
    end
end