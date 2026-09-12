if Bridge.Inventory ~= 'ps' then return end

Inventory = Inventory or {}

local Core = exports['qb-core']:GetCoreObject()
local hasItemCache = {}
local hasItemCacheTime = 0

local function ClearCache()
    hasItemCache = {}
    hasItemCacheTime = 0
end

local function GetItems()
    local playerData = Core.Functions.GetPlayerData()
    return playerData and playerData.items or {}
end

function Inventory.GetItemCount(item)
    local count = 0
    for _, entry in pairs(GetItems()) do
        if entry and entry.name == item then
            count = count + (tonumber(entry.amount or entry.count or entry.quantity) or 0)
        end
    end
    return count
end

function Inventory.HasItem(item)
    local now = GetGameTimer()
    if hasItemCacheTime > 0 and now - hasItemCacheTime < 1000 and hasItemCache[item] ~= nil then
        return hasItemCache[item]
    end
    local hasItem = Inventory.GetItemCount(item) > 0
    hasItemCache[item] = hasItem
    hasItemCacheTime = now
    return hasItem
end

function Inventory.OpenStash(stashId, label, maxWeight, slots)
    local data = { label = label, maxweight = maxWeight, maxWeight = maxWeight, slots = slots }
    TriggerEvent('inventory:client:SetCurrentStash', stashId)
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', stashId, data)
    return true
end

function Inventory.Close()
    TriggerEvent('inventory:client:closeInventory')
end

RegisterNetEvent('inventory:client:updateInventory', ClearCache)
RegisterNetEvent('inventory:client:ItemBox', ClearCache)
RegisterNetEvent('QBCore:Player:SetPlayerData', ClearCache)
RegisterNetEvent('QBCore:Player:UpdatePlayerData', ClearCache)
