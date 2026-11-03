-- Set Config.fuel = "custom" to enable this client-side template.
if Sky.Config.fuel ~= "custom" then return end
if IsDuplicityVersion() then return end

function Sky.Functions.GetVehicleFuel(vehicle)
    -- Return the vehicle's fuel level as a number.
    error("Custom fuel integration: GetVehicleFuel is not implemented")
end

function Sky.Functions.SetVehicleFuel(vehicle, fuel)
    -- Set the vehicle's fuel level.
    error("Custom fuel integration: SetVehicleFuel is not implemented")
end

-- Optional provider feature. Remove this function when fuel types are unsupported.
function Sky.Functions.SetVehicleFuelType(vehicle, fuel_type)
    error("Custom fuel integration: SetVehicleFuelType is not implemented")
end
