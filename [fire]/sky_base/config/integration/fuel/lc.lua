if Sky.Config.fuel ~= "lc" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "lc_fuel"

function Sky.Functions.GetVehicleFuel(vehicle)
    return exports[RESOURCE]:GetFuel(vehicle)
end

function Sky.Functions.SetVehicleFuel(vehicle, fuel)
    exports[RESOURCE]:SetFuel(vehicle, fuel)
end

function Sky.Functions.SetVehicleFuelType(vehicle, fuel_type)
    exports[RESOURCE]:SetFuelType(vehicle, fuel_type) -- nil resets to default
end
