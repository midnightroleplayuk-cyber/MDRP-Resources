local tgiann_hotwire = GetResourceState("tgiann-hotwire") ~= "missing"
local qb_vehiclekeys = GetResourceState("qb-vehiclekeys") ~= "missing"
local qbx_vehiclekeys = GetResourceState("qbx-vehiclekeys") ~= "missing"

-- Waits for a vehicle to actually be registered on the network before reading its netId (a
-- freshly CreateVehicle'd entity doesn't get one in the same tick); returns false on timeout
---@param vehicle number
---@return number|false
---@diagnostic disable-next-line: duplicate-set-field
tgiCore.WaitForVehicleNetId = function(vehicle)
    local success, netId = pcall(lib.waitFor, function()
        local netId = NetworkGetNetworkIdFromEntity(vehicle)
        if netId ~= 0 and NetworkDoesEntityExistWithNetworkId(netId) then
            return netId
        end
    end, "", 5000)
    if not success then return false end
    return netId
end

---@param vehicle number
---@param keyType? "giveKey" | "nonRemoveable" | "garage"
---@diagnostic disable-next-line: duplicate-set-field
tgiCore.GiveVehicleKey = function(vehicle, keyType)
    if tgiann_hotwire then
        if keyType == "giveKey" then
            exports["tgiann-hotwire"]:GiveKeyVehicle(vehicle, true)
        elseif keyType == "nonRemoveable" then
            exports["tgiann-hotwire"]:SetNonRemoveableIgnition(vehicle, true)
        elseif keyType == "garage" then
            exports["tgiann-hotwire"]:CheckKeyInIgnitionWhenSpawn(vehicle)
        end
    elseif qb_vehiclekeys then
        local netId = tgiCore.WaitForVehicleNetId(vehicle)
        if not netId then return end
        TriggerServerEvent("tgiann-core:server:giveVehicleKey", netId)
    elseif qbx_vehiclekeys then
        local netId = tgiCore.WaitForVehicleNetId(vehicle)
        if not netId then return end

        TriggerServerEvent("tgiann-core:server:giveVehicleKey", netId)
    else
        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerEvent("vehiclekeys:client:SetOwner", plate)
        TriggerEvent("x-hotwire:give-keys", vehicle)
        TriggerEvent('tgiann-hotwire:give-keys-with-carid', vehicle)
    end
end

RegisterNetEvent("tgiann-core:client:giveVehicleKey")
AddEventHandler("tgiann-core:client:giveVehicleKey", function(netId, keyType)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    tgiCore.GiveVehicleKey(vehicle, keyType)
end)
