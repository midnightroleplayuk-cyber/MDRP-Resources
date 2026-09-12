if Bridge.Inventory ~= 'esx' then return end
if GetResourceState('es_extended') ~= 'started' then return end

Inventory = Inventory or {}

local hasItemCache = {}
local hasItemCacheTime = 0

local function clearCache()
    hasItemCache = {}
    hasItemCacheTime = 0
end

local function getItems()
    local playerData = exports['es_extended']:getSharedObject().GetPlayerData()
    return playerData and playerData.inventory or {}
end

local function getCount(item)
    local count = 0
    for _, v in pairs(getItems()) do
        if v and v.name == item then
            count = count + (tonumber(v.amount or v.count or v.quantity or 0) or 0)
        end
    end
    return count
end

function Inventory.GetItemCount(item)
    return getCount(item)
end

function Inventory.HasItem(item)
    local now = GetGameTimer()
    if hasItemCacheTime > 0 and (now - hasItemCacheTime) < 1000 and hasItemCache[item] ~= nil then
        return hasItemCache[item]
    end
    local has = getCount(item) > 0
    hasItemCache[item] = has
    hasItemCacheTime = now
    return has
end

function Inventory.Close()
    TriggerEvent('esx_inventoryhud:closeInventory')
end

RegisterNetEvent('esx:addInventoryItem', clearCache)
RegisterNetEvent('esx:removeInventoryItem', clearCache)
