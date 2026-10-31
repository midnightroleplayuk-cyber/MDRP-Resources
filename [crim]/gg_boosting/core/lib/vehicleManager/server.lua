gg.vehicleManager = gg.vehicleManager or {}


gg.vehicleManager.spawnVehicle = function(model, coords)
    model = type(model) == 'string' and GetHashKey(model) or model
    if not coords then return end
    coords = type(coords) == 'table' and vec4(coords.x, coords.y, coords.z, coords.w or 0.0) or coords
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, true)
    while not DoesEntityExist(veh) do Wait(0) end
    local netId = NetworkGetNetworkIdFromEntity(veh)
    return netId
end


gg.vehicleManager.removeVehicle = function(netid)
    local entity = NetworkGetEntityFromNetworkId(netid)
    if not netid or type(entity) ~= "number" or entity == 0 then
        return false
    end

    if GetResourceState("AdvancedParking") == "started" then
            exports["AdvancedParking"]:DeleteVehicle(entity, false)
        return true
    end

    if not DoesEntityExist(entity) then
        return false
    end

    DeleteEntity(entity)
    return not DoesEntityExist(entity)
end

