if Sky.Config.fuel ~= "legacy" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "LegacyFuel"

function Sky.Functions.GetVehicleFuel(vehicle)
    return exports[RESOURCE]:GetFuel(vehicle)
end

function Sky.Functions.SetVehicleFuel(vehicle, fuel)
    exports[RESOURCE]:SetFuel(vehicle, fuel)
end

function Sky.Functions.SetVehicleFuelType(_vehicle, _fuel_type)
    -- LegacyFuel does not support per-vehicle fuel types.
end
