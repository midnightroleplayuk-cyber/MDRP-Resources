-- Set Config.garage = "custom" to enable this server-side template.
if Sky.Config.garage ~= "custom" then return end
if not IsDuplicityVersion() then return end

function Sky.Functions.IsPlateUsed(plate)
    -- Return true when `plate` is already assigned to a persistent vehicle.
    error("Custom garage integration: IsPlateUsed is not implemented")
end

function Sky.Functions.GeneratePlate()
    -- Return a unique plate string. Use IsPlateUsed to prevent collisions.
    error("Custom garage integration: GeneratePlate is not implemented")
end

function Sky.Functions.GiveVehicle(source, model)
    -- Create the persistent ownership entry for `source` and `model`.
    error("Custom garage integration: GiveVehicle is not implemented")
end

function Sky.Functions.ChangePlate(old_plate, new_plate)
    -- Update the persistent vehicle record from `old_plate` to `new_plate`.
    error("Custom garage integration: ChangePlate is not implemented")
end
