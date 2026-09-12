if Bridge.Inventory ~= 'origen' then return end

Inventory = Inventory or {}

local function GetItems()
    local items = exports['origen_inventory']:getPlayerItems()
    return type(items) == 'table' and items or {}
end

function Inventory.GetItemCount(item)
    local count = 0
    for _, entry in pairs(GetItems()) do
        if entry and (entry.name or entry.item) == item then
            count = count + (tonumber(entry.amount or entry.count or entry.quantity) or 0)
        end
    end
    return count
end

function Inventory.HasItem(item)
    return exports['origen_inventory']:hasItem(item, 1) == true
end

function Inventory.OpenStash(stashId, label, maxWeight, slots)
    exports['origen_inventory']:openInventory(stashId, {
        label = label,
        maxweight = maxWeight,
        slots = slots
    })
    return true
end

function Inventory.Close()
    exports['origen_inventory']:CloseInventory()
end
