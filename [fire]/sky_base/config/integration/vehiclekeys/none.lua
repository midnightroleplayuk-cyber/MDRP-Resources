if Sky.Config.vehiclekeys ~= "none" or IsDuplicityVersion() then return end

-- There is no external key ownership to grant or revoke on this server.
function Sky.Functions.GiveVehicleKeys(vehicle, plate, model)
    return true
end

function Sky.Functions.RemoveVehicleKeys(vehicle, plate, model)
    return true
end
