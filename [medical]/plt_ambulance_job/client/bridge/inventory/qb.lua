if Bridge.Inventory ~= 'qb' then return end
if GetResourceState('qbx_core') ~= 'started' and GetResourceState('qb-core') ~= 'started' then return end

Inventory = Inventory or {}

local hasItemCache = {}
local hasItemCacheTime = 0

local function clearCache()
    hasItemCache = {}
    hasItemCacheTime = 0
end

local function getItems()
    local playerData = exports['qb-core']:GetCoreObject().Functions.GetPlayerData()
    return playerData and playerData.items or {}
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

function Inventory.OpenStash(stashId, label, maxWeight, slots)
    local data = { label = label, maxweight = maxWeight, maxWeight = maxWeight, slots = slots }
    TriggerEvent('inventory:client:SetCurrentStash', stashId)
    TriggerEvent('qb-inventory:client:SetCurrentStash', stashId)
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', stashId, data)
    TriggerServerEvent('qb-inventory:server:OpenInventory', 'stash', stashId, data)
    TriggerEvent('inventory:client:OpenInventory', 'stash', stashId, data)
    TriggerEvent('qb-inventory:client:OpenInventory', 'stash', stashId, data)
    TriggerEvent('qb-inventory:client:openInventory', 'stash', stashId, data)
    return true
end

function Inventory.Close()
    TriggerEvent('inventory:client:closeInventory')
    TriggerEvent('qb-inventory:client:closeInventory')
end

RegisterNetEvent('qb-inventory:client:updateInventory', clearCache)
RegisterNetEvent('qb-inventory:client:ItemBox', clearCache)
RegisterNetEvent('QBCore:Player:SetPlayerData', clearCache)
RegisterNetEvent('QBCore:Player:UpdatePlayerData', clearCache)
