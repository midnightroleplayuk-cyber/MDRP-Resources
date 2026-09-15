-- Client integration for cloud-shop 3.0.1. Configurable without changing FA.
local RESOURCE = 'fa_shoprobbery'
local MATCH_DISTANCE = 2.0
local activeCoords

local function findStore(coords)
    if not coords or GetResourceState(RESOURCE) ~= 'started' then return end
    return exports[RESOURCE]:FindClerkStore(coords, MATCH_DISTANCE)
end

local function canUse(coords)
    local storeId = findStore(coords)
    if not storeId then return true end
    return exports[RESOURCE]:CanUseClerkShop(storeId)
end

local function getEntity(coords)
    local storeId = findStore(coords)
    if storeId then return exports[RESOURCE]:GetClerkEntity(storeId) end
end

local function setActive(coords)
    activeCoords = coords
end

local function canUseActive()
    return activeCoords ~= nil and canUse(activeCoords)
end

return {
    FindStore = findStore,
    CanUse = canUse,
    GetEntity = getEntity,
    SetActive = setActive,
    CanUseActive = canUseActive,
}
