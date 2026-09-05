if Config.Inventory.inventoryScript ~= 'ox_inventory' then return end

local ox = exports.ox_inventory

function Fr.HasItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if count <= 0 then
        return true
    end
    return (ox:GetItemCount(src, item) or 0) >= count
end

function Fr.GetItemCount(src, item)
    return tonumber(ox:GetItemCount(src, item)) or 0
end

function Fr.RemoveItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if count <= 0 then
        return true
    end
    return ox:RemoveItem(src, item, count) and true or false
end

function Fr.AddItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if not src or not item or count <= 0 then
        return false
    end
    return ox:AddItem(src, item, count) and true or false
end

function Fr.AddItemToStash(stashId, item, count)
    count = math.floor(tonumber(count) or 1)
    if type(stashId) ~= 'string' or stashId == '' or not item or count <= 0 then
        return false
    end
    return ox:AddItem(stashId, item, count) and true or false
end

function Fr.RemoveItemFromStash(stashId, item, count)
    count = math.floor(tonumber(count) or 1)
    if type(stashId) ~= 'string' or stashId == '' or not item or count <= 0 then
        return false
    end
    return ox:RemoveItem(stashId, item, count) and true or false
end

function Fr.RegisterStash(stashId, label, slots, weight, owner)
    local ok = pcall(function()
        ox:RegisterStash(
            stashId,
            label or stashId,
            tonumber(slots) or 50,
            tonumber(weight) or 100000,
            owner == true
        )
    end)
    return ok
end

function Fr.OpenStash(src, stashId, _data)
    TriggerClientEvent('opm:client:inventory:openStash', src, stashId, _data or {})
    return true
end

function Fr.AddItemToVehicleTrunk(_src, netId, item, count, plateHint)
    count = math.floor(tonumber(count) or 1)
    if not item or count <= 0 then
        return false
    end

    local ref = Fr.OxVehicleTrunkRef(netId, plateHint)
    if not ref then
        return false
    end

    ox:GetInventory(ref)
    return ox:AddItem(ref, item, count) == true
end

function Fr.RemoveItemFromVehicleTrunk(_src, netId, item, count, plateHint)
    count = math.floor(tonumber(count) or 1)
    if not item or count <= 0 then
        return false
    end

    local ref = Fr.OxVehicleTrunkRef(netId, plateHint)
    if not ref then
        return false
    end

    ox:GetInventory(ref)
    return ox:RemoveItem(ref.id, item, count) == true
end
