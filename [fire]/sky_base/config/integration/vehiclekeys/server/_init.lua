if not IsDuplicityVersion() then return end

-- Server-authorized grants. Providers with server exports override the client bridge below.
Sky.VehicleKeys = {}

function Sky.VehicleKeys.GetLockState(vehicle)
    return GetVehicleDoorLockStatus(vehicle)
end

function Sky.VehicleKeys.SetLockState(vehicle, locked)
    if type(locked) ~= "boolean" then
        Sky.Debug("error", "[vehiclekeys] Invalid lock state for vehicle %s: %s", tostring(vehicle), tostring(locked))
        return false
    end
    SetVehicleDoorsLocked(vehicle, locked and 2 or 1)
    return true
end

function Sky.VehicleKeys.Give(player_id, plate, model)
    if Sky.Config.vehiclekeys == "auto" or Sky.Config.vehiclekeys == "none" then return end
    TriggerClientEvent("sky_base:client:giveVehicleKeys", player_id, plate, model)
end

function Sky.VehicleKeys.Remove(player_id, plate, model)
    if Sky.Config.vehiclekeys == "auto" or Sky.Config.vehiclekeys == "none" then return end
    TriggerClientEvent("sky_base:client:removeVehicleKeys", player_id, plate, model)
end
