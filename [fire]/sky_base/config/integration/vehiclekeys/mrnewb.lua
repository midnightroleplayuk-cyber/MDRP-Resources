if Sky.Config.vehiclekeys ~= "mrnewb" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "MrNewbVehicleKeys"

function Sky.Functions.GiveVehicleKeys(vehicle, plate, model)
    if not vehicle then return end
    exports[RESOURCE]:GiveKeys(vehicle)
end

function Sky.Functions.RemoveVehicleKeys(vehicle, plate, model)
    if not vehicle then return end
    exports[RESOURCE]:RemoveKeys(vehicle)
end
