if Sky.Config.fuel ~= "cdn" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "cdn-fuel"

function Sky.Functions.GetVehicleFuel(vehicle)
    return exports[RESOURCE]:GetFuel(vehicle)
end

function Sky.Functions.SetVehicleFuel(vehicle, fuel)
    exports[RESOURCE]:SetFuel(vehicle, fuel)
end
