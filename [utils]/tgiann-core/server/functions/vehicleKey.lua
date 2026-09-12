local qb_vehiclekeys = GetResourceState("qb-vehiclekeys") ~= "missing"
local qbx_vehiclekeys = GetResourceState("qbx-vehiclekeys") ~= "missing"

---@param src number
---@param netId number
---@param keyType? "giveKey" | "nonRemoveable" | "garage"
---@diagnostic disable-next-line: duplicate-set-field
tgiCore.GiveVehicleKey = function(src, netId, keyType)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    local plate = GetVehicleNumberPlateText(vehicle)
    if qb_vehiclekeys then
        exports["qb-vehiclekeys"]:GiveKeys(src, plate)
    elseif qbx_vehiclekeys then
        exports["qbx-vehiclekeys"]:GiveKeys(src, plate, true)
    else
        TriggerClientEvent("tgiann-core:client:giveVehicleKey", src, netId, keyType)
    end
end

RegisterNetEvent("tgiann-core:server:giveVehicleKey")
AddEventHandler("tgiann-core:server:giveVehicleKey", function(netId, keyType)
    tgiCore.GiveVehicleKey(source, netId, keyType)
end)
