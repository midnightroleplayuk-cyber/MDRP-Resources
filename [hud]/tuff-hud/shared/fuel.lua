Fuel = {}

Fuel.GetFuel = function(vehicle)
    if Settings.Fuel == "ox_fuel" then
        return Entity(vehicle).state.fuel
    elseif Settings.Fuel == "x-fuel" then
        local fuel = exports['x-fuel']:GetFuel(vehicle)
        return fuel
    elseif Settings.Fuel == "LegacyFuel" then
        local fuel = exports["LegacyFuel"]:GetFuel(vehicle)
        return fuel
    elseif Settings.Fuel == "cdn-fuel" then
        local fuel = exports["cdn-fuel"]:GetFuel(vehicle)
        return fuel
    elseif Settings.Fuel == "Renewed-Fuel" then
        local fuel = exports['Renewed-Fuel']:GetFuel(vehicle)
        return fuel
    elseif Settings.Fuel == "qb-fuel" then
        local fuel = exports['qb-fuel']:GetFuel(vehicle)
        return fuel
    elseif Settings.Fuel == "lc_fuel" then
        local fuel = exports["lc_fuel"]:GetFuel(vehicle)
        return fuel
    elseif Settings.Fuel == "ps-fuel" then
        local fuel = exports["ps-fuel"]:GetFuel(vehicle)
        return fuel
    elseif Settings.Fuel == "rcore_fuel" then
        local fuel = exports["rcore_fuel"]:GetVehicleFuelLiters(vehicle)
        return fuel
    elseif Settings.Fuel == "lj-fuel" then
        local fuel = exports['lj-fuel']:GetFuel(vehicle)
        return fuel
    elseif Settings.Fuel == "native" then
        local fuel = GetVehicleFuelLevel(vehicle)
        return fuel
    end
end
