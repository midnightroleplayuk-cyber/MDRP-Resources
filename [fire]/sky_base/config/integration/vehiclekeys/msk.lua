if Sky.Config.vehiclekeys ~= "msk" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "msk_vehiclekeys"

function Sky.Functions.GiveVehicleKeys(vehicle, plate, model)
    local vehicle_data = vehicle or {
        plate = plate,
        model = type(model) == "string" and joaat(model) or model
    }
    exports[RESOURCE]:AddKey(vehicle_data, "temporary")
end

function Sky.Functions.RemoveVehicleKeys(vehicle, plate, model)
    local vehicle_data = vehicle or {
        plate = plate,
        model = type(model) == "string" and joaat(model) or model
    }
    exports[RESOURCE]:RemoveKey(vehicle_data, "temporary")
end
