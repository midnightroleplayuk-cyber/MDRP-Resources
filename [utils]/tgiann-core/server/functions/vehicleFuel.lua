local ox_fuel = GetResourceState("ox_fuel") ~= "missing"

---@param src number
---@param netId number
---@param level number 0-100
---@diagnostic disable-next-line: duplicate-set-field
tgiCore.SetVehicleFuel = function(src, netId, level)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if ox_fuel then
        Entity(vehicle).state:set("fuel", level, true)
    else
        TriggerClientEvent("tgiann-core:client:setVehicleFuel", src, netId, level)
    end
end

RegisterNetEvent("tgiann-core:server:setVehicleFuel")
AddEventHandler("tgiann-core:server:setVehicleFuel", function(netId, level)
    tgiCore.SetVehicleFuel(source, netId, level)
end)
