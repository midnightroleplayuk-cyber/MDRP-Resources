Bridge = Bridge or {}

local clerkEntities = {}
local clerkStates = {}

local function buildClerkPayload(store, entity, state, previousState, reason)
    local clerk = type(store.clerk) == 'table' and store.clerk or nil
    local coords = clerk and clerk.coords and {
        x = clerk.coords.x,
        y = clerk.coords.y,
        z = clerk.coords.z
    } or nil

    return {
        storeId = store.id,
        entity = entity,
        state = state,
        previousState = previousState,
        reason = reason,
        coords = coords
    }
end

function Bridge.PublishClerkCreated(store, entity, state)
    if not store or not store.id or not entity or entity == 0 then return end

    local storeId = store.id
    local previousState = clerkStates[storeId]
    local currentState = state or previousState

    clerkEntities[storeId] = entity
    clerkStates[storeId] = currentState
    TriggerEvent('fa_shoprobbery:client:clerkCreated', buildClerkPayload(store, entity, currentState, previousState))

    if currentState ~= previousState then
        TriggerEvent('fa_shoprobbery:client:clerkStateChanged', buildClerkPayload(store, entity, currentState, previousState))
    end
end

function Bridge.PublishClerkState(store, state)
    if not store or not store.id or type(state) ~= 'string' then return end

    local storeId = store.id
    local previousState = clerkStates[storeId]
    local entity = clerkEntities[storeId]

    if previousState == state then return end

    clerkStates[storeId] = state
    TriggerEvent('fa_shoprobbery:client:clerkStateChanged', buildClerkPayload(store, entity, state, previousState))
end

function Bridge.PublishClerkRemoved(store, entity, reason)
    if not store or not store.id then return end

    local storeId = store.id
    local trackedEntity = clerkEntities[storeId]
    if trackedEntity and entity and trackedEntity ~= entity then return end

    clerkEntities[storeId] = nil
    TriggerEvent('fa_shoprobbery:client:clerkRemoved', buildClerkPayload(store, entity or trackedEntity, clerkStates[storeId], nil, reason or 'removed'))
end

---@param storeId string
---@return number? entity
local function getClerkEntity(storeId)
    local entity = clerkEntities[storeId]
    if not entity or entity == 0 or not DoesEntityExist(entity) then return end
    return entity
end

---@param storeId string
---@return string? state
local function getClerkState(storeId)
    if not Utils.GetStore(storeId) then return end
    return clerkStates[storeId]
end

---@param storeId string
---@return boolean canUse
local function canUseClerkShop(storeId)
    local entity = getClerkEntity(storeId)
    return entity ~= nil and not IsEntityDead(entity) and getClerkState(storeId) == 'idle'
end

---@param storeId string
---@return table? data
local function getClerkData(storeId)
    local store = Utils.GetStore(storeId)
    if not store then return end

    local entity = getClerkEntity(storeId)
    local state = getClerkState(storeId)
    local clerk = type(store.clerk) == 'table' and store.clerk or nil
    local coords = clerk and clerk.coords and {
        x = clerk.coords.x,
        y = clerk.coords.y,
        z = clerk.coords.z
    } or nil

    return {
        storeId = storeId,
        entity = entity,
        state = state,
        available = entity ~= nil and not IsEntityDead(entity) and state == 'idle',
        coords = coords
    }
end

---@param coords vector3 | vector4 | table
---@param maxDistance? number
---@return string? storeId
local function findClerkStore(coords, maxDistance)
    if type(coords) ~= 'vector3' and type(coords) ~= 'vector4' and type(coords) ~= 'table' then return end

    local x = tonumber(coords.x)
    local y = tonumber(coords.y)
    local z = tonumber(coords.z)
    if not x or not y or not z then return end

    local limit = math.max(tonumber(maxDistance) or 2.0, 0.1)
    local closestStoreId
    local closestDistanceSquared = limit * limit

    for i = 1, #Config.Stores do
        local store = Config.Stores[i]
        if Utils.IsClerkEnabled(store) and store.clerk.coords then
            local clerkCoords = store.clerk.coords
            local dx = clerkCoords.x - x
            local dy = clerkCoords.y - y
            local dz = clerkCoords.z - z
            local distanceSquared = dx * dx + dy * dy + dz * dz

            if distanceSquared <= closestDistanceSquared then
                closestStoreId = store.id
                closestDistanceSquared = distanceSquared
            end
        end
    end

    return closestStoreId
end

exports('GetClerkEntity', getClerkEntity)
exports('GetClerkState', getClerkState)
exports('CanUseClerkShop', canUseClerkShop)
exports('GetClerkData', getClerkData)
exports('FindClerkStore', findClerkStore)