if Sky.Config.vehiclekeys ~= "vehicles_keys" then return end
if IsDuplicityVersion() then return end

function Sky.Functions.GiveVehicleKeys(vehicle, plate, model)
    TriggerServerEvent("vehicles_keys:selfGiveVehicleKeys", plate)
end

function Sky.Functions.RemoveVehicleKeys(vehicle, plate, model)
    TriggerServerEvent("vehicles_keys:selfRemoveKeys", plate)
end
