if Sky.Config.vehiclekeys ~= "jota" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "jc_vehiclekeys"

function Sky.Functions.GiveVehicleKeys(vehicle, plate, model)
    exports[RESOURCE]:GiveKeys(plate)
end

function Sky.Functions.RemoveVehicleKeys(vehicle, plate, model)
    exports[RESOURCE]:RemoveKeys(plate)
end
