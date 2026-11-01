if Sky.Config.vehiclekeys ~= "vehicles_keys" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "vehicles_keys"

function Sky.VehicleKeys.Give(player_id, plate, model)
    -- Crime owns persistence; session keys must be restored from its current authorization.
    exports[RESOURCE]:giveVehicleKeysToPlayerId(player_id, plate, "temporary")
end

function Sky.VehicleKeys.Remove(player_id, plate, model)
    exports[RESOURCE]:removeKeysFromPlayerId(player_id, plate)
end

AddEventHandler("onResourceStart", function(resource_name)
    if resource_name == "vehicles_keys" then
        TriggerEvent("sky_base:vehicleKeysReady")
    end
end)
