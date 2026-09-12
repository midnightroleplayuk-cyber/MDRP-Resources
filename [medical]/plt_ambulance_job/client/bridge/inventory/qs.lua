if Bridge.Inventory ~= 'quasar' then return end

Inventory = Inventory or {}

local hasItemCache = {}
local hasItemCacheTime = 0

local function clearCache()
    hasItemCache = {}
    hasItemCacheTime = 0
end

function Inventory.GetItemCount(item)
    return tonumber(exports['qs-inventory']:Search(item)) or 0
end

function Inventory.HasItem(item)
    local now = GetGameTimer()
    if hasItemCacheTime > 0 and (now - hasItemCacheTime) < 1000 and hasItemCache[item] ~= nil then
        return hasItemCache[item]
    end
    local has = Inventory.GetItemCount(item) > 0
    hasItemCache[item] = has
    hasItemCacheTime = now
    return has
end

function Inventory.OpenStash(stashId)
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', stashId)
    TriggerEvent('inventory:client:SetCurrentStash', stashId)
    return true
end

function Inventory.Close()
    TriggerEvent('inventory:client:closeInventory')
end

RegisterNetEvent('inventory:client:updateInventory', clearCache)
RegisterNetEvent('inventory:client:ItemBox', clearCache)
RegisterNetEvent('QBCore:Player:SetPlayerData', clearCache)
RegisterNetEvent('QBCore:Player:UpdatePlayerData', clearCache)
