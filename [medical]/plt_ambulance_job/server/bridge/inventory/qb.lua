if Bridge.Inventory ~= 'qb' then return end

Inventory = Inventory or {}

local Core = exports['qb-core']:GetCoreObject()

local function GetPlayer(src)
    return Core.Functions.GetPlayer(src)
end

local function GetSharedItems()
    return Core.Shared and Core.Shared.Items or {}
end

function Inventory.AddItem(owner, item, amount, metadata, slot)
    if type(metadata) == 'number' and slot == nil then
        slot = metadata
        metadata = nil
    end
    return exports['qb-inventory']:AddItem(owner, item, amount, slot, metadata, 'plt_ambulance_job')
end

function Inventory.RemoveItem(owner, item, amount, slot)
    return exports['qb-inventory']:RemoveItem(owner, item, amount, slot, 'plt_ambulance_job')
end

function Inventory.HasItem(src, item, count)
    return exports['qb-inventory']:HasItem(src, item, count or 1)
end

function Inventory.GetItem(src, item)
    return exports['qb-inventory']:GetItemByName(src, item)
end

function Inventory.GetItemCount(src, item)
    return exports['qb-inventory']:GetItemCount(src, item) or 0
end

function Inventory.GetItems(owner)
    if type(owner) == 'number' then
        local player = GetPlayer(owner)
        return player and player.PlayerData.items or {}
    end
    local inventory = exports['qb-inventory']:GetInventory(owner)
    return inventory and inventory.items or {}
end

function Inventory.GetInventoryInfo(owner)
    if type(owner) == 'number' then
        local player = GetPlayer(owner)
        return player and { items = player.PlayerData.items or {} } or nil
    end
    local inventory = exports['qb-inventory']:GetInventory(owner)
    if not inventory then return nil end
    return {
        items = inventory.items or {},
        maxWeight = inventory.maxweight,
        slots = inventory.slots
    }
end

function Inventory.Clear(src)
    if not GetPlayer(src) then return false end
    exports['qb-inventory']:ClearInventory(src)
    return true
end

function Inventory.CanCarryItem(owner, item, amount)
    return exports['qb-inventory']:CanAddItem(owner, item, amount) == true
end

function Inventory.RegisterStash(stashId, label, slots, maxWeight)
    if not exports['qb-inventory']:GetInventory(stashId) then
        exports['qb-inventory']:CreateInventory(stashId, {
            label = label,
            slots = slots,
            maxweight = maxWeight
        })
    end
    return exports['qb-inventory']:GetInventory(stashId) ~= nil
end

function Inventory.GetItemLabel(itemName)
    local item = GetSharedItems()[itemName]
    return item and item.label or itemName
end

function Inventory.GetSystem()
    return 'qb-inventory'
end

function Inventory.GetItemData(itemName)
    local item = GetSharedItems()[itemName]
    if not item then return { name = itemName, label = itemName, image = itemName } end
    return {
        name = itemName,
        label = item.label or itemName,
        image = item.image or itemName
    }
end
