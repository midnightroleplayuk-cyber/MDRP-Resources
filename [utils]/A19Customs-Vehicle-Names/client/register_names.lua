-- Registers both the vehicles.meta gameName label and the spawn code as aliases.
-- This provides compatibility with resources that look up either value.

local function registerVehicleNames(vehicles)
    for _, vehicle in ipairs(vehicles) do
        AddTextEntry(vehicle.gameName, vehicle.displayName)
        AddTextEntry(vehicle.model, vehicle.displayName)
    end
end

CreateThread(function()
    registerVehicleNames(A19VehicleNamesPack1)
    registerVehicleNames(A19VehicleNamesPack2)
end)
