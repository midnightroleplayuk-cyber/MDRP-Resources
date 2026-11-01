if Sky.Config.vehiclekeys ~= "zyke_garages" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "zyke_garages"

function Sky.Functions.GiveVehicleKeys(vehicle, plate, model)
    if not DoesEntityExist(vehicle) then return end

    exports[RESOURCE]:GiveKey(vehicle)
end

function Sky.Functions.RemoveVehicleKeys(vehicle, plate, model)
    if not DoesEntityExist(vehicle) then return end

    exports[RESOURCE]:RemoveKey(vehicle)
end
