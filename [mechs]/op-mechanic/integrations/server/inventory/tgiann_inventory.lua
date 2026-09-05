if Config.Inventory.inventoryScript ~= 'tgiann_inventory' then return end

function Fr.HasItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if count <= 0 then
        return true
    end
    local n = 0
    local ok, result = pcall(function()
        return exports['tgiann-inventory']:GetItemCount(src, item)
    end)
    if ok then
        n = tonumber(result) or 0
    end
    return n >= count
end

function Fr.RemoveItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if count <= 0 then
        return true
    end
    local ok = pcall(function()
        return exports['tgiann-inventory']:RemoveItem(src, item, count)
    end)
    return ok
end

function Fr.AddItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if not src or not item or count <= 0 then
        return false
    end
    local ok = pcall(function()
        return exports['tgiann-inventory']:AddItem(src, item, count)
    end)
    return ok
end

function Fr.AddItemToStash(stashId, item, count)
    count = math.floor(tonumber(count) or 1)
    if type(stashId) ~= 'string' or stashId == '' or not item or count <= 0 then
        return false
    end
    local ok = pcall(function()
        return exports['tgiann-inventory']:AddItemToSecondaryInventory('stash', stashId, item, count)
    end)
    if ok then
        return true
    end
    ok = pcall(function()
        return exports['tgiann-inventory']:AddItem(stashId, item, count)
    end)
    return ok
end

function Fr.RemoveItemFromStash(stashId, item, count)
    count = math.floor(tonumber(count) or 1)
    if type(stashId) ~= 'string' or stashId == '' or not item or count <= 0 then
        return false
    end
    local ok = pcall(function()
        return exports['tgiann-inventory']:RemoveItem(stashId, item, count)
    end)
    return ok
end

function Fr.RegisterStash(stashId, label, slots, weight, _owner)
    local ok = pcall(function()
        exports['tgiann-inventory']:RegisterStash(
            stashId,
            label or stashId,
            tonumber(slots) or 50,
            tonumber(weight) or 100000
        )
    end)
    return ok
end

function Fr.OpenStash(src, stashId, data)
    data = data or {}
    local ok = pcall(function()
        exports['tgiann-inventory']:OpenInventory(src, 'stash', stashId, {
            label = data.label or stashId,
            maxweight = tonumber(data.weight) or 100000,
            slots = tonumber(data.slots) or 50,
        })
    end)
    return ok
end

function Fr.AddItemToVehicleTrunk(_src, netId, item, count, plateHint)
    count = math.floor(tonumber(count) or 1)
    if not item or count <= 0 then
        return false
    end
    local plate = Fr.ResolveVehiclePlate(netId, plateHint)
    if not plate then
        return false
    end
    local ok, result = pcall(function()
        return exports['tgiann-inventory']:AddItemToSecondaryInventory('trunk', plate, item, count)
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
        return exports['tgiann-inventory']:RemoveItem(stashId, item, count)
    end)
    return ok and result ~= false
end