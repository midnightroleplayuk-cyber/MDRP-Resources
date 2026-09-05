if Config.Inventory.inventoryScript ~= 'codem-inventory' then return end

function Fr.HasItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if count <= 0 then
        return true
    end
    local n = 0
    local ok, result = pcall(function()
        return exports['codem-inventory']:GetItemsTotalAmount(src, item)
    end)
    if ok and result then
        n = tonumber(result) or 0
    else
        ok, result = pcall(function()
            return exports['codem-inventory']:GetItemCount(src, item)
        end)
        if ok then
            n = tonumber(result) or 0
        end
    end
    return n >= count
end

function Fr.RemoveItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if count <= 0 then
        return true
    end
    local ok = pcall(function()
        exports['codem-inventory']:RemoveItem(src, item, count)
    end)
    return ok
end

function Fr.AddItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if not src or not item or count <= 0 then
        return false
    end
    local ok = pcall(function()
        exports['codem-inventory']:AddItem(src, item, count)
    end)
    return ok
end

function Fr.AddItemToStash(stashId, item, count)
    count = math.floor(tonumber(count) or 1)
    if type(stashId) ~= 'string' or stashId == '' or not item or count <= 0 then
        return false
    end
    local ok = pcall(function()
        exports['codem-inventory']:AddItem(stashId, item, count)
    end)
    if ok then
        return true
    end
    ok = pcall(function()
        TriggerEvent('codem-inventory:server:AddItem', stashId, item, count)
    end)
    return ok
end

function Fr.RemoveItemFromStash(stashId, item, count)
    count = math.floor(tonumber(count) or 1)
    if type(stashId) ~= 'string' or stashId == '' or not item or count <= 0 then
        return false
    end
    local ok = pcall(function()
        exports['codem-inventory']:RemoveItem(stashId, item, count)
    end)
    return ok
end

function Fr.OpenStash(src, stashId, data)
    data = data or {}
    local slots = tonumber(data.slots) or 50
    local weight = tonumber(data.weight) or 100000
    local label = data.label or stashId
    TriggerClientEvent('codem-inventory:client:openstash', src, stashId, slots, weight, label)
    -- Fallback server event used by some codem builds
    pcall(function()
        TriggerEvent('codem-inventory:server:openstash', stashId, slots, weight, label, src)
    end)
    return true
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
        return exports['codem-inventory']:AddItem(stashId, item, count)
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
        return exports['codem-inventory']:RemoveItem(stashId, item, count)
    end)
    return ok and result ~= false
end