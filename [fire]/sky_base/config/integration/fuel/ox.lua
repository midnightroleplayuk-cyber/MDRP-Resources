if Sky.Config.fuel ~= "ox" then return end
if IsDuplicityVersion() then return end

function Sky.Functions.GetVehicleFuel(vehicle)
    return Entity(vehicle).state.fuel or GetVehicleFuelLevel(vehicle)
end

function Sky.Functions.SetVehicleFuel(vehicle, fuel)
    Entity(vehicle).state.fuel = fuel
end

function Sky.Functions.SetVehicleFuelType(_vehicle, _fuel_type)
    -- ox_fuel does not support per-vehicle fuel types.
end
