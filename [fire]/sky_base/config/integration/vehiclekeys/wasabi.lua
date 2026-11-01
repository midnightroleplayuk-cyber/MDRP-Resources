if Sky.Config.vehiclekeys ~= "wasabi" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "wasabi_carlock"

function Sky.Functions.GiveVehicleKeys(vehicle, plate, model)
    exports[RESOURCE]:GiveKey(plate)
end

function Sky.Functions.RemoveVehicleKeys(vehicle, plate, model)
    exports[RESOURCE]:RemoveKey(plate)
end
