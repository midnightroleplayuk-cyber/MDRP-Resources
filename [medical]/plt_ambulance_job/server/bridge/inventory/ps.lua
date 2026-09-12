if Bridge.Inventory ~= 'ps' then return end

Inventory = Inventory or {}

local Core = exports['qb-core']:GetCoreObject()

local function GetPlayer(src)
    return Core.Functions.GetPlayer(src)
end

local function GetSharedItems()
    return Core.Shared and Core.Shared.Items or {}
end

local function TryExport(method, ...)
    local args = { ... }
    local ok, result = pcall(function()
        return exports['ps-inventory'][method](table.unpack(args))
    end)
    return ok, result
end

function Inventory.AddItem(owner, item, amount, metadata, slot)
    if type(metadata) == 'number' and slot == nil then
        slot = metadata
        metadata = nil
    end
    return exports['ps-inventory']:AddItem(owner, item, amount, slot or false, metadata)
end

function Inventory.RemoveItem(owner, item, amount, slot)
    return exports['ps-inventory']:RemoveItem(owner, item, amount, slot or false)
end

function Inventory.HasItem(src, item, count)
    return exports['ps-inventory']:HasItem(src, item, count or 1)
end

function Inventory.GetItem(src, item)
    return exports['ps-inventory']:GetItemByName(src, item)
end

function Inventory.GetItemCount(src, item)
    local count = 0
    for _, entry in pairs(Inventory.GetItems(src)) do
        if entry and entry.name == item then
            count = count + (tonumber(entry.amount or entry.count or entry.quantity) or 0)
        end
    end
    return count
end

function Inventory.GetItems(owner)
    if type(owner) == 'number' then
        local player = GetPlayer(owner)
        return player and player.PlayerData.items or {}
    end
    local ok, items = TryExport('GetStashItems', owner)
    return ok and type(items) == 'table' and items or {}
end

function Inventory.GetInventoryInfo(owner)
    local items = Inventory.GetItems(owner)
    return { items = items }
end

function Inventory.Clear(src)
    local ok, result = TryExport('ClearInventory', src)
    if ok then return result ~= false end
    local player = GetPlayer(src)
    if not player or type(player.Functions.ClearInventory) ~= 'function' then return false end
    player.Functions.ClearInventory()
    return true
end

function Inventory.CanCarryItem(owner, item, amount)
    local ok, result = TryExport('CanAddItem', owner, item, amount)
    if ok then return result == true end
    ok, result = TryExport('CanCarryItem', owner, item, amount)
    return not ok or result == true
end

function Inventory.RegisterStash()
    return true
end

function Inventory.GetItemLabel(itemName)
    local item = GetSharedItems()[itemName]
    return item and item.label or itemName
end

function Inventory.GetSystem()
    return 'ps-inventory'
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
