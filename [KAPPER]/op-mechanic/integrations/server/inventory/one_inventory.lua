if Config.Inventory.inventoryScript ~= 'one_inventory' then return end

local fwHasItem = Fr.HasItem
local fwRemoveItem = Fr.RemoveItem
local fwAddItem = Fr.AddItem

function Fr.HasItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if count <= 0 then
        return true
    end
    if fwHasItem then
        return fwHasItem(src, item, count)
    end
    local ok, result = pcall(function()
        return exports.one_inventory:GetItemCount(src, item)
    end)
    return ok and (tonumber(result) or 0) >= count
end

function Fr.RemoveItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if count <= 0 then
        return true
    end
    if fwRemoveItem then
        return fwRemoveItem(src, item, count)
    end
    local ok = pcall(function()
        return exports.one_inventory:RemoveItem(src, item, count)
    end)
    return ok
end

function Fr.AddItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if not src or not item or count <= 0 then
        return false
    end
    if fwAddItem then
        return fwAddItem(src, item, count)
    end
    local ok = pcall(function()
        return exports.one_inventory:AddItem(src, item, count)
    end)
    return ok
end

function Fr.AddItemToStash(stashId, item, count)
    count = math.floor(tonumber(count) or 1)
    if type(stashId) ~= 'string' or stashId == '' or not item or count <= 0 then
        return false
    end
    local ok = pcall(function()
        return exports.one_inventory:AddItem(stashId, item, count)
    end)
    return ok
end

function Fr.RemoveItemFromStash(stashId, item, count)
    count = math.floor(tonumber(count) or 1)
    if type(stashId) ~= 'string' or stashId == '' or not item or count <= 0 then
        return false
    end
    local ok = pcall(function()
        return exports.one_inventory:RemoveItem(stashId, item, count)
    end)
    return ok
end

function Fr.OpenStash(src, stashId, data)
    data = data or {}
    local ok = pcall(function()
        exports.one_inventory:OpenInventory(src, 'stash', {
            id = stashId,
            owner = false,
            maxWeight = tonumber(data.weight) or 100000,
            slots = tonumber(data.slots) or 50,
            label = data.label or stashId,
        })
    end)
    return ok
end

function Fr.AddItemToVehicleTrunk(_src, netId, item, count, plateHint)
    count = math.floor(tonumber(count) or 1)
    if not item or count <= 0 then
        return false
    end
    local stashId = Fr.QbVehicleTrunkStashId(Fr.ResolveVehiclePlate(netId, plateHint))
    if not stashId then
        return false
    end
    local ok, result = pcall(function()
        return exports.one_inventory:AddItem(stashId, item, count)
    end)
    return ok and result ~= false
end

function Fr.RemoveItemFromVehicleTrunk(_src, netId, item, count, plateHint)
    count = math.floor(tonumber(count) or 1)
    if not item or count <= 0 then
        return false
    end
    local stashId = Fr.QbVehicleTrunkStashId(Fr.ResolveVehiclePlate(netId, plateHint))
    if not stashId then
        return false
    end
    local ok, result = pcall(function()
        return exports.one_inventory:RemoveItem(stashId, item, count)
    end)
    return ok and result ~= false
end