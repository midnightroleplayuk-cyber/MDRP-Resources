if Sky.Config.vehiclekeys ~= "mk" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "mk_vehiclekeys"

function Sky.Functions.GiveVehicleKeys(vehicle, plate, model)
    if not vehicle then
        Sky.Debug("warn", "[vehiclekeys/mk] Cannot give keys for plate '%s': a vehicle entity is required", tostring(plate))
        return
    end
    exports[RESOURCE]:AddKey(vehicle)
end

function Sky.Functions.RemoveVehicleKeys(vehicle, plate, model)
    if not vehicle then
        Sky.Debug("warn", "[vehiclekeys/mk] Cannot remove keys for plate '%s': a vehicle entity is required", tostring(plate))
        return
    end
    exports[RESOURCE]:RemoveKey(vehicle)
end
