if Sky.Config.fuel ~= "rcore" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "rcore_fuel"

function Sky.Functions.GetVehicleFuel(vehicle)
    return exports[RESOURCE]:GetVehicleFuelPercentage(vehicle)
end

function Sky.Functions.SetVehicleFuel(vehicle, fuel)
    exports[RESOURCE]:SetVehicleFuel(vehicle, fuel)
end
