if Sky.Config.vehiclekeys ~= "quasar" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "qs-vehiclekeys"

function Sky.Functions.GiveVehicleKeys(vehicle, plate, model)
    if not model then return end
    exports[RESOURCE]:GiveKeys(plate, model, true)
end

function Sky.Functions.RemoveVehicleKeys(vehicle, plate, model)
    if not model then return end
    exports[RESOURCE]:RemoveKeys(plate, model)
end
