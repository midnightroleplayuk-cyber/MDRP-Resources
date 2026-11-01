if Sky.Config.fuel ~= "stg-van" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "stg-vanaheimfuel"

function Sky.Functions.GetVehicleFuel(vehicle)
    return exports[RESOURCE]:GetFuel(vehicle)
end

function Sky.Functions.SetVehicleFuel(vehicle, fuel)
    exports[RESOURCE]:SetFuel(vehicle, fuel)
end
