if Sky.Config.vehiclekeys ~= "tgiann" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "tgiann-hotwire"

function Sky.Functions.GiveVehicleKeys(vehicle, plate, model)
    plate = Sky.Math.Trim(plate)
    if exports[RESOURCE]:HaveKeyPlate(plate) then return end

    exports[RESOURCE]:GiveKeyPlate(plate, false)
end

function Sky.Functions.RemoveVehicleKeys(vehicle, plate, model)
    -- Tgiann intentionally exposes no removal export; physical keys stay with the player.
    return false
end
