if Bridge.Inventory ~= 'ox' then return end

Inventory = Inventory or {}

function Inventory.AddItem(owner, item, amount, metadata, slot)
    return exports.ox_inventory:AddItem(owner, item, amount, metadata, slot)
end

function Inventory.RemoveItem(owner, item, amount, slot)
    return exports.ox_inventory:RemoveItem(owner, item, amount, nil, slot)
end

function Inventory.HasItem(owner, item, count)
    return (exports.ox_inventory:Search(owner, 'count', item) or 0) >= (count or 1)
end

function Inventory.GetItem(owner, item)
    return exports.ox_inventory:GetItem(owner, item, nil, false)
end

function Inventory.GetItemCount(owner, item)
    return exports.ox_inventory:GetItemCount(owner, item) or 0
end

function Inventory.GetItems(owner)
    local inventory = exports.ox_inventory:GetInventory(owner)
    return inventory and inventory.items or {}
end

function Inventory.GetInventoryInfo(owner)
    local inventory = exports.ox_inventory:GetInventory(owner)
    if not inventory then return nil end
    return {
        items = inventory.items or {},
        maxWeight = inventory.maxWeight,
        slots = inventory.slots
    }
end

function Inventory.Clear(src)
    return exports.ox_inventory:ClearInventory(src) ~= false
end

function Inventory.CanCarryItem(owner, item, amount)
    return exports.ox_inventory:CanCarryItem(owner, item, amount)
end

function Inventory.RegisterStash(stashId, label, slots, maxWeight)
    local ok = pcall(function()
        exports.ox_inventory:RegisterStash(stashId, label, slots, maxWeight)
    end)
    return ok
end

function Inventory.GetItemLabel(itemName)
    local item = exports.ox_inventory:Items(itemName)
    return item and item.label or itemName
end

function Inventory.GetSystem()
    return 'ox_inventory'
end

function Inventory.GetItemData(itemName)
    local item = exports.ox_inventory:Items(itemName)
    if not item then return { name = itemName, label = itemName, image = itemName } end
    return {
        name = itemName,
        label = item.label or itemName,
        image = itemName
    }
end
