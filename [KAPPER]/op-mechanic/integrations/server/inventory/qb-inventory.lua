if Config.Inventory.inventoryScript ~= 'qb-inventory' then return end

function Fr.HasItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if count <= 0 then
        return true
    end
    local player = Fr.GetPlayer(src)
    if not player then
        return false
    end
    local entry = player.Functions.GetItemByName(item)
    local amount = entry and (entry.amount or entry.count or 0) or 0
    return amount >= count
end

function Fr.GetItemCount(src, item)
    local player = Fr.GetPlayer(src)
    if not player then
        return 0
    end
    local entry = player.Functions.GetItemByName(item)
    return entry and (entry.amount or entry.count or 0) or 0
end

function Fr.RemoveItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if count <= 0 then
        return true
    end
    local player = Fr.GetPlayer(src)
    if not player then
        return false
    end
    return player.Functions.RemoveItem(item, count) and true or false
end

function Fr.AddItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if not src or not item or count <= 0 then
        return false
    end
    local player = Fr.GetPlayer(src)
    if not player then
        return false
    end
    return player.Functions.AddItem(item, count) and true or false
end

function Fr.AddItemToStash(stashId, item, count)
    count = math.floor(tonumber(count) or 1)
    if type(stashId) ~= 'string' or stashId == '' or not item or count <= 0 then
        return false
    end
    local ok, result = pcall(function()
        return exports['qb-inventory']:AddItem(stashId, item, count, false, false, 'op-mechanic-parts')
    end)
    if ok and result ~= false then
        return true
    end
    ok, result = pcall(function()
        return exports['qb-inventory']:AddItem(stashId, item, count)
    end)
    return ok and result ~= false
end

function Fr.RemoveItemFromStash(stashId, item, count)
    count = math.floor(tonumber(count) or 1)
    if type(stashId) ~= 'string' or stashId == '' or not item or count <= 0 then
        return false
    end
    local ok, result = pcall(function()
        return exports['qb-inventory']:RemoveItem(stashId, item, count, false, 'op-mechanic-parts')
    end)
    if ok and result ~= false then
        return true
    end
    ok, result = pcall(function()
        return exports['qb-inventory']:RemoveItem(stashId, item, count)
    end)
    return ok and result ~= false
end

function Fr.OpenStash(src, stashId, data)
    data = data or {}
    local payload = {
        label = data.label or stashId,
        maxweight = tonumber(data.weight) or 100000,
        slots = tonumber(data.slots) or 50,
    }
    local ok = pcall(function()
        exports['qb-inventory']:OpenInventory(src, stashId, payload)
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
        return exports['qb-inventory']:AddItem(stashId, item, count, false, false, 'op-mechanic-parts')
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
        return exports['qb-inventory']:RemoveItem(stashId, item, count, false, 'op-mechanic-parts')
    end)
    return ok and result ~= false
end