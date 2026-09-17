if Config.Inventory.inventoryScript ~= 'origen_inventory' then return end

local function normalizeCount(result)
    if result == nil then
        return 0
    end
    if type(result) == 'number' then
        return math.floor(result + 0.5)
    end
    if type(result) == 'table' then
        local sum = 0
        for _, slot in pairs(result) do
            if type(slot) == 'table' then
                sum = sum + (tonumber(slot.count or slot.amount or slot.quantity) or 0)
            end
        end
        return math.floor(sum + 0.5)
    end
    return math.floor(tonumber(result) or 0)
end

local function itemCount(src, item)
    local exportsList = {
        function()
            return exports.origen_inventory:getItemCount(src, item)
        end,
        function()
            return exports.origen_inventory:GetItemCount(src, item)
        end,
        function()
            return exports.origen_inventory:Search(src, 'count', item)
        end,
    }

    for i = 1, #exportsList do
        local ok, result = pcall(exportsList[i])
        if ok then
            local n = normalizeCount(result)
            if n > 0 or result ~= nil then
                return n
            end
        end
    end
    return 0
end

function Fr.HasItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if count <= 0 then
        return true
    end
    return itemCount(src, item) >= count
end

function Fr.GetItemCount(src, item)
    return itemCount(src, item)
end

function Fr.RemoveItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if count <= 0 then
        return true
    end

    local exportsList = {
        function()
            return exports.origen_inventory:removeItem(src, item, count)
        end,
        function()
            return exports.origen_inventory:RemoveItem(src, item, count)
        end,
    }

    for i = 1, #exportsList do
        local ok, result = pcall(exportsList[i])
        if ok and result ~= false then
            return true
        end
    end
    return false
end

function Fr.AddItem(src, item, count)
    count = math.floor(tonumber(count) or 1)
    if not src or not item or count <= 0 then
        return false
    end

    local exportsList = {
        function()
            return exports.origen_inventory:addItem(src, item, count)
        end,
        function()
            return exports.origen_inventory:AddItem(src, item, count)
        end,
    }

    for i = 1, #exportsList do
        local ok, result = pcall(exportsList[i])
        if ok and result ~= false then
            return true
        end
    end
    return false
end

function Fr.AddItemToStash(stashId, item, count)
    count = math.floor(tonumber(count) or 1)
    if type(stashId) ~= 'string' or stashId == '' or not item or count <= 0 then
        return false
    end
    local ok = pcall(function()
        return exports.origen_inventory:AddItem(stashId, item, count)
    end)
    if ok then
        return true
    end
    ok = pcall(function()
        return exports.origen_inventory:addItem(stashId, item, count)
    end)
    return ok
end

function Fr.RemoveItemFromStash(stashId, item, count)
    count = math.floor(tonumber(count) or 1)
    if type(stashId) ~= 'string' or stashId == '' or not item or count <= 0 then
        return false
    end
    local ok = pcall(function()
        return exports.origen_inventory:RemoveItem(stashId, item, count)
    end)
    if ok then
        return true
    end
    ok = pcall(function()
        return exports.origen_inventory:removeItem(stashId, item, count)
    end)
    return ok
end

function Fr.RegisterStash(stashId, label, slots, weight, _owner)
    local ok = pcall(function()
        exports.origen_inventory:RegisterStash(
            stashId,
            label or stashId,
            tonumber(slots) or 50,
            tonumber(weight) or 100000
        )
    end)
    if not ok then
        ok = pcall(function()
            exports.origen_inventory:registerStash(
                stashId,
                label or stashId,
                tonumber(slots) or 50,
                tonumber(weight) or 100000
            )
        end)
    end
    return ok
end

function Fr.OpenStash(src, stashId, data)
    TriggerClientEvent('opm:client:inventory:openStash', src, stashId, data or {})
    return true
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
    local invId = 'trunk' .. plate
    local ok, result = pcall(function()
        return exports.origen_inventory:AddItem(invId, item, count)
    end)
    return ok and result ~= false
end

function Fr.RemoveItemFromVehicleTrunk(_src, netId, item, count, plateHint)
    count = math.floor(tonumber(count) or 1)
    if not item or count <= 0 then
        return false
    end
    local plate = Fr.ResolveVehiclePlate(netId, plateHint)
    if not plate then
        return false
    end
    local invId = 'trunk' .. plate
    local ok, result = pcall(function()
        return exports.origen_inventory:RemoveItem(invId, item, count)
    end)
    return ok and result ~= false
end
