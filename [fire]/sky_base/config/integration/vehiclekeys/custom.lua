-- Set Config.vehiclekeys = "custom" to enable this client-side template.
if Sky.Config.vehiclekeys ~= "custom" then return end
if IsDuplicityVersion() then return end

function Sky.Functions.GiveVehicleKeys(vehicle, plate, model)
    error("Custom vehicle keys integration: GiveVehicleKeys is not implemented")
end

function Sky.Functions.RemoveVehicleKeys(vehicle, plate, model)
    error("Custom vehicle keys integration: RemoveVehicleKeys is not implemented")
end
