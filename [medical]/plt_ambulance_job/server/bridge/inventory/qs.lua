if Bridge.Inventory ~= 'quasar' then return end

Inventory = Inventory or {}

function Inventory.AddItem(owner, item, amount, metadata, slot)
    return exports['qs-inventory']:AddItem(owner, item, amount, slot, metadata)
end

function Inventory.RemoveItem(owner, item, amount, slot, metadata)
    return exports['qs-inventory']:RemoveItem(owner, item, amount, slot, metadata)
end

function Inventory.HasItem(owner, item, count)
    return (exports['qs-inventory']:GetItemTotalAmount(owner, item) or 0) >= (count or 1)
end

function Inventory.GetItem(owner, item)
    for _, entry in pairs(Inventory.GetItems(owner)) do
        if entry and entry.name == item then return entry end
    end
end

function Inventory.GetItemCount(owner, item)
    return exports['qs-inventory']:GetItemTotalAmount(owner, item) or 0
end

function Inventory.GetItems(owner)
    return exports['qs-inventory']:GetInventory(owner) or {}
end

function Inventory.GetInventoryInfo(owner)
    return { items = Inventory.GetItems(owner) }
end

function Inventory.Clear(src)
    local pending = {}
    for slotKey, entry in pairs(Inventory.GetItems(src)) do
        pending[#pending + 1] = { entry = entry, slot = entry and (entry.slot or slotKey) }
    end

    local success = true
    for _, pendingItem in ipairs(pending) do
        local entry = pendingItem.entry
        local amount = tonumber(entry and (entry.amount or entry.count or entry.quantity)) or 0
        if entry and entry.name and amount > 0 then
            if exports['qs-inventory']:RemoveItem(src, entry.name, amount, pendingItem.slot, entry.info) == false then
                success = false
            end
        end
    end
    return success
end

function Inventory.CanCarryItem(owner, item, amount)
    return exports['qs-inventory']:CanCarryItem(owner, item, amount) == true
end

function Inventory.RegisterStash(stashId, _, slots, maxWeight)
    local ok = pcall(function()
        exports['qs-inventory']:RegisterStash(stashId, slots, maxWeight)
    end)
    return ok
end

function Inventory.GetItemLabel(itemName)
    return exports['qs-inventory']:GetItemLabel(itemName) or itemName
end

function Inventory.GetSystem()
    return 'qs-inventory'
end

function Inventory.GetItemData(itemName)
    local items = exports['qs-inventory']:GetItemList() or {}
    local item = items[itemName]
    if not item then return { name = itemName, label = itemName, image = itemName } end
    return {
        name = itemName,
        label = item.label or itemName,
        image = item.image or itemName
    }
end
