if Sky.Config.vehiclekeys ~= "ic3d" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "ic3d_vehiclekeys"

function Sky.Functions.GiveVehicleKeys(vehicle, plate, model)
    exports[RESOURCE]:ClientInventoryKeys('add', plate)
end

function Sky.Functions.RemoveVehicleKeys(vehicle, plate, model)
    exports[RESOURCE]:ClientInventoryKeys('remove', plate)
end
