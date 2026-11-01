if Sky.Config.vehiclekeys ~= "qb" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "qb-vehiclekeys"

function Sky.VehicleKeys.GetLockState(vehicle)
    if GetResourceState("qbx_vehiclekeys") == "started" then
        return Entity(vehicle).state.doorslockstate or 0
    end
    return GetVehicleDoorLockStatus(vehicle)
end

function Sky.VehicleKeys.SetLockState(vehicle, locked)
    if type(locked) ~= "boolean" then
        Sky.Debug("error", "[vehiclekeys/qb] Invalid lock state for vehicle %s: %s", tostring(vehicle), tostring(locked))
        return false
    end
    if GetResourceState("qbx_vehiclekeys") == "started" then
        exports.qbx_vehiclekeys:SetLockState(vehicle, locked and "lock" or "unlock")
        if Entity(vehicle).state.doorslockstate ~= (locked and 2 or 1) then
            Sky.Debug("error", "[vehiclekeys/qb] Qbox rejected lock state for vehicle %s; check its noLock/shared vehicle configuration.", tostring(vehicle))
            return false
        end
    else
        SetVehicleDoorsLocked(vehicle, locked and 2 or 1)
    end
    return true
end

function Sky.VehicleKeys.Give(player_id, plate, model)
    exports[RESOURCE]:GiveKeys(player_id, plate)
end

function Sky.VehicleKeys.Remove(player_id, plate, model)
    exports[RESOURCE]:RemoveKeys(player_id, plate)
end

AddEventHandler("onResourceStart", function(resource_name)
    if resource_name == RESOURCE or resource_name == "qbx_vehiclekeys" then
        TriggerEvent("sky_base:vehicleKeysReady")
    end
end)
