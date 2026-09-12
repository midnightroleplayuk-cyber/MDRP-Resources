if Bridge.Inventory ~= 'ox' then return end

Inventory = Inventory or {}

local hasItemCache = {}
local hasItemCacheTime = 0

local function clearCache()
    hasItemCache = {}
    hasItemCacheTime = 0
end

function Inventory.GetItemCount(item)
    return exports.ox_inventory:Search('count', item) or 0
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
    exports.ox_inventory:openInventory('stash', stashId)
    return true
end

function Inventory.Close()
    exports.ox_inventory:closeInventory()
end

RegisterNetEvent('ox_inventory:updateSlots', clearCache)
