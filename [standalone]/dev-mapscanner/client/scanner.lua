--[[
    Client-Side Scanner Module
    Handles entity scanning locally.
    Map file scanning is done server-side via filesystem access.
]]

Scanner = {}

function Scanner.ScanNearbyEntities(radius)
    radius = radius or 100.0
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local entities = {}

    local handle, entity = FindFirstObject()
    if handle ~= -1 then
        repeat
            local coords = GetEntityCoords(entity)
            local dist = #(playerCoords - coords)
            if dist <= radius then
                table.insert(entities, { type = "object", handle = entity, model = GetEntityModel(entity), coords = { x = coords.x, y = coords.y, z = coords.z }, distance = dist })
            end
        until not FindNextObject(handle, entity)
        EndFindObject(handle)
    end

    handle, entity = FindFirstPed()
    if handle ~= -1 then
        repeat
            local coords = GetEntityCoords(entity)
            local dist = #(playerCoords - coords)
            if dist <= radius and entity ~= playerPed then
                table.insert(entities, { type = "ped", handle = entity, model = GetEntityModel(entity), coords = { x = coords.x, y = coords.y, z = coords.z }, distance = dist })
            end
        until not FindNextPed(handle, entity)
        EndFindPed(handle)
    end

    handle, entity = FindFirstVehicle()
    if handle ~= -1 then
        repeat
            local coords = GetEntityCoords(entity)
            local dist = #(playerCoords - coords)
            if dist <= radius then
                table.insert(entities, { type = "vehicle", handle = entity, model = GetEntityModel(entity), coords = { x = coords.x, y = coords.y, z = coords.z }, distance = dist })
            end
        until not FindNextVehicle(handle, entity)
        EndFindVehicle(handle)
    end

    table.sort(entities, function(a, b) return a.distance < b.distance end)
    return entities
end

function Scanner.IdentifyEntitySource(entityHandle)
    local success, owner = pcall(function()
        return Entity(entityHandle).state._resourceOwner
    end)
    if success and owner then return owner end
    return "unknown (map/world)"
end
