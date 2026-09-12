local ox_fuel = GetResourceState("ox_fuel") ~= "missing"
local legacy_fuel = GetResourceState("LegacyFuel") ~= "missing"
local ps_fuel = GetResourceState("ps-fuel") ~= "missing"
local cdn_fuel = GetResourceState("cdn-fuel") ~= "missing"
local lj_fuel = GetResourceState("lj-fuel") ~= "missing"
local lc_fuel = GetResourceState("lc_fuel") ~= "missing"

---@param vehicle number
---@param level number 0-100
---@diagnostic disable-next-line: duplicate-set-field
tgiCore.SetVehicleFuel = function(vehicle, level)
    if ox_fuel then
        Entity(vehicle).state:set("fuel", level, true)
    elseif legacy_fuel then
        exports["LegacyFuel"]:SetFuel(vehicle, level)
    elseif ps_fuel then
        exports["ps-fuel"]:SetFuel(vehicle, level)
    elseif cdn_fuel then
        exports["cdn-fuel"]:SetFuel(vehicle, level)
    elseif lj_fuel then
        exports["lj-fuel"]:SetFuel(vehicle, level)
    elseif lc_fuel then
        exports["lc_fuel"]:SetFuel(vehicle, level)
    else
        SetVehicleFuelLevel(vehicle, level + 0.0)
    end
end

RegisterNetEvent("tgiann-core:client:setVehicleFuel")
AddEventHandler("tgiann-core:client:setVehicleFuel", function(netId, level)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    tgiCore.SetVehicleFuel(vehicle, level)
end)
