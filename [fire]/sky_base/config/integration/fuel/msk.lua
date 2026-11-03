if Sky.Config.fuel ~= "msk" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "msk_fuel"

function Sky.Functions.GetVehicleFuel(vehicle)
    return exports[RESOURCE]:GetVehicleFuel(vehicle)
end

function Sky.Functions.SetVehicleFuel(vehicle, fuel)
    exports[RESOURCE]:SetVehicleFuel(vehicle, fuel)
end

function Sky.Functions.SetVehicleFuelType(vehicle, fuel_type)
    exports[RESOURCE]:SetVehicleFuelType(vehicle, fuel_type)
end
