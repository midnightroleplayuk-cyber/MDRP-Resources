if Sky.Config.vehiclekeys ~= "brutal" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "brutal_keys"

function Sky.Functions.GiveVehicleKeys(vehicle, plate, model)
    exports[RESOURCE]:addVehicleKey(plate, "Vehicle Keys")
end

function Sky.Functions.RemoveVehicleKeys(vehicle, plate, model)
    exports[RESOURCE]:removeKey(plate, false)
end
