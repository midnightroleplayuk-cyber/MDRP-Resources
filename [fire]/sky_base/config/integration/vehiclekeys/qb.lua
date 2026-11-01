if Sky.Config.vehiclekeys ~= "qb" then return end
if IsDuplicityVersion() then return end

function Sky.Functions.GiveVehicleKeys(vehicle, plate, model)
    TriggerEvent("vehiclekeys:client:SetOwner", Sky.Math.Trim(plate))
end

function Sky.Functions.RemoveVehicleKeys(vehicle, plate, model)
    TriggerEvent("qb-vehiclekeys:client:RemoveKeys", Sky.Math.Trim(plate))
end
