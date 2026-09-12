if Bridge.Inventory ~= 'origen' then return end

Inventory = Inventory or {}

function Inventory.AddItem(owner, item, amount, metadata, slot)
    if type(metadata) == 'number' and slot == nil then
        slot = metadata
        metadata = nil
    end
    return exports['origen_inventory']:addItem(owner, item, amount, slot, metadata)
end

function Inventory.RemoveItem(owner, item, amount, slot)
    return exports['origen_inventory']:removeItem(owner, item, amount, slot)
end

function Inventory.HasItem(owner, item, count)
    return exports['origen_inventory']:HasItem(owner, item, count or 1) == true
end

function Inventory.GetItem(owner, item)
    return exports['origen_inventory']:getItem(owner, item)
end

function Inventory.GetItemCount(owner, item)
    return exports['origen_inventory']:getItemCount(owner, item) or 0
end

function Inventory.GetItems(owner)
    return exports['origen_inventory']:getItems(owner) or {}
end

function Inventory.GetInventoryInfo(owner)
    local inventory = exports['origen_inventory']:getInventory(owner)
    if not inventory then return nil end
    return {
        items = type(inventory.items) == 'table' and inventory.items or Inventory.GetItems(owner),
        maxWeight = inventory.maxWeight or inventory.maxweight,
        slots = inventory.slots or inventory.maxSlots
    }
end

function Inventory.Clear(owner)
    return exports['origen_inventory']:clearInventory(owner) ~= false
end

function Inventory.CanCarryItem(owner, item, amount)
    return exports['origen_inventory']:canCarryItem(owner, item, amount) == true
end

function Inventory.RegisterStash(stashId, label, slots, maxWeight)
    local ok = pcall(function()
        exports['origen_inventory']:registerStash(stashId, {
            label = label,
            slots = slots,
            maxweight = maxWeight
        })
    end)
    return ok
end

function Inventory.GetItemLabel(itemName)
    return exports['origen_inventory']:getItemLabel(itemName) or itemName
end

function Inventory.GetSystem()
    return 'origen_inventory'
end

function Inventory.GetItemData(itemName)
    return {
        name = itemName,
        label = Inventory.GetItemLabel(itemName),
        image = itemName
    }
end
