-- Inventory bridge for evidence bags. Open file: add another inventory at the bottom.
--
-- Supported: ox_inventory, qb-inventory (2.x), qs-inventory, ps-inventory, lj-inventory,
-- and the older qb-inventory (before 2.0). Picked automatically, or set Config.Evidence.Inventory.
--
-- Every adapter works with plain items: { slot, name, label, count, metadata }
Inv = { Adapters = {} }
local A = Inv.Adapters

local QBCore
local function qb()
    if not QBCore and GetResourceState('qb-core') == 'started' then
        local ok, core = pcall(function() return exports['qb-core']:GetCoreObject() end)
        QBCore = ok and core or nil
    end
    return QBCore
end
local function qbPlayer(src) local c = qb(); return c and c.Functions.GetPlayer(src) end
local function qbLabel(name)
    local c = qb()
    local it = c and c.Shared and c.Shared.Items and c.Shared.Items[name]
    return it and it.label or name
end

local function norm(it, labelFn)
    if not it or not it.name then return nil end
    return { slot = it.slot, name = it.name, label = it.label or (labelFn and labelFn(it.name)) or it.name,
        count = tonumber(it.count or it.amount) or 1, metadata = it.metadata or it.info }
end

---------------------------------------------------------------------------
-- ox_inventory
---------------------------------------------------------------------------
A.ox_inventory = {
    resource = 'ox_inventory', label = 'ox_inventory',
    label_of = function(name)
        local ok, d = pcall(function() return exports.ox_inventory:Items(name) end)
        return ok and type(d) == 'table' and d.label or name
    end,
    prepare = function(self, id, label, slots, weight, groups)
        exports.ox_inventory:RegisterStash(id, label, slots, weight, false, groups)
        return { kind = 'ox', id = id }
    end,
    playerItems = function(self, src)
        local out = {}
        for _, it in pairs(exports.ox_inventory:GetInventoryItems(src) or {}) do out[#out + 1] = norm(it, self.label_of) end
        return out
    end,
    playerSlot = function(self, src, slot) return norm(exports.ox_inventory:GetSlot(src, slot), self.label_of) end,
    take = function(self, src, it, count) return exports.ox_inventory:RemoveItem(src, it.name, count, it.metadata, it.slot) end,
    give = function(self, src, it, count) return exports.ox_inventory:AddItem(src, it.name, count, it.metadata) end,
    canCarry = function(self, src, it, count) return exports.ox_inventory:CanCarryItem(src, it.name, count, it.metadata) end,
    bagItems = function(self, id)
        local out = {}
        for _, it in pairs(exports.ox_inventory:GetInventoryItems(id) or {}) do out[#out + 1] = norm(it, self.label_of) end
        return out
    end,
    bagAdd = function(self, id, it, count) return exports.ox_inventory:AddItem(id, it.name, count, it.metadata) end,
    bagRemove = function(self, id, it, count) return exports.ox_inventory:RemoveItem(id, it.name, count, it.metadata, it.slot) end,
    bagClear = function(self, id) exports.ox_inventory:ClearInventory(id) end,
}

---------------------------------------------------------------------------
-- qb-inventory 2.x (CreateInventory / OpenInventory / AddItem(identifier, ...))
---------------------------------------------------------------------------
A['qb-inventory'] = {
    resource = 'qb-inventory', label = 'qb-inventory',
    detect = function() return pcall(function() return exports['qb-inventory']:GetInventory('__vwmdt_probe') end) end,
    label_of = qbLabel,
    prepare = function(self, id, label, slots, weight)
        exports['qb-inventory']:CreateInventory(id, { label = label, maxweight = weight, slots = slots })
        return { kind = 'server', id = id }
    end,
    open = function(self, src, id, label, slots, weight)
        exports['qb-inventory']:OpenInventory(src, id, { label = label, maxweight = weight, slots = slots })
    end,
    playerItems = function(self, src)
        local p, out = qbPlayer(src), {}
        for _, it in pairs(p and p.PlayerData.items or {}) do out[#out + 1] = norm(it, qbLabel) end
        return out
    end,
    playerSlot = function(self, src, slot)
        local p = qbPlayer(src)
        return p and norm(p.PlayerData.items[tonumber(slot)], qbLabel)
    end,
    take = function(self, src, it, count) return exports['qb-inventory']:RemoveItem(src, it.name, count, it.slot, 'vinewood-mdt evidence') end,
    give = function(self, src, it, count) return exports['qb-inventory']:AddItem(src, it.name, count, nil, it.metadata, 'vinewood-mdt evidence') end,
    canCarry = function(self, src, it, count) return exports['qb-inventory']:CanAddItem(src, it.name, count) end,
    bagItems = function(self, id)
        local inv, out = exports['qb-inventory']:GetInventory(id), {}
        for slot, it in pairs(inv and inv.items or {}) do it.slot = it.slot or slot; out[#out + 1] = norm(it, qbLabel) end
        return out
    end,
    bagAdd = function(self, id, it, count) return exports['qb-inventory']:AddItem(id, it.name, count, nil, it.metadata, 'vinewood-mdt evidence') end,
    bagRemove = function(self, id, it, count) return exports['qb-inventory']:RemoveItem(id, it.name, count, it.slot, 'vinewood-mdt evidence') end,
    bagClear = function(self, id) exports['qb-inventory']:ClearStash(id) end,
}

---------------------------------------------------------------------------
-- qs-inventory (Quasar)
---------------------------------------------------------------------------
local function qsLabel(name)
    local ok, l = pcall(function() return exports['qs-inventory']:GetItemLabel(name) end)
    return ok and l or name
end
A['qs-inventory'] = {
    resource = 'qs-inventory', label = 'qs-inventory',
    prepare = function(self, id, label, slots, weight)
        return { kind = 'legacy', id = id, slots = slots, weight = weight, event = 'inventory:server:OpenInventory', current = 'inventory:client:SetCurrentStash' }
    end,
    playerItems = function(self, src)
        local out = {}
        for slot, it in pairs(exports['qs-inventory']:GetInventory(src) or {}) do it.slot = it.slot or slot; out[#out + 1] = norm(it, qsLabel) end
        return out
    end,
    playerSlot = function(self, src, slot)
        local inv = exports['qs-inventory']:GetInventory(src) or {}
        local it = inv[tonumber(slot)]
        if not it then for _, x in pairs(inv) do if tonumber(x.slot) == tonumber(slot) then it = x end end end
        if it then it.slot = it.slot or tonumber(slot) end
        return norm(it, qsLabel)
    end,
    take = function(self, src, it, count) return exports['qs-inventory']:RemoveItem(src, it.name, count, it.slot, it.metadata) end,
    give = function(self, src, it, count) return exports['qs-inventory']:AddItem(src, it.name, count, nil, it.metadata) end,
    canCarry = function(self, src, it, count) return exports['qs-inventory']:CanCarryItem(src, it.name, count) end,
    bagItems = function(self, id)
        local out = {}
        for slot, it in pairs(exports['qs-inventory']:GetStashItems(id) or {}) do it.slot = it.slot or slot; out[#out + 1] = norm(it, qsLabel) end
        return out
    end,
    bagAdd = function(self, id, it, count)
        local c = Config.Evidence
        return exports['qs-inventory']:AddItemIntoStash(id, it.name, count, nil, it.metadata, c.Slots or 30, c.MaxWeight or 100000) ~= false
    end,
    bagRemove = function(self, id, it, count)
        local c = Config.Evidence
        return exports['qs-inventory']:RemoveItemIntoStash(id, it.name, count, it.slot, c.Slots or 30, c.MaxWeight or 100000) ~= false
    end,
    bagClear = function(self, id)
        for _, it in ipairs(self:bagItems(id)) do self:bagRemove(id, it, it.count) end
    end,
}

---------------------------------------------------------------------------
-- ps-inventory, lj-inventory and the older qb-inventory (before 2.0).
-- Players through QBCore; bags stored in the stashitems table.
---------------------------------------------------------------------------
local function legacyAdapter(resource, eventPrefix)
    local function readStash(id)
        local raw = MySQL.scalar.await('SELECT items FROM stashitems WHERE stash = ?', { id })
        local list = raw and json.decode(raw) or {}
        local bySlot = {}
        for k, it in pairs(list) do if type(it) == 'table' and it.name then it.slot = tonumber(it.slot or k); bySlot[it.slot] = it end end
        return bySlot
    end
    local function writeStash(id, bySlot)
        local list = {}
        for slot, it in pairs(bySlot) do
            list[#list + 1] = { name = it.name, amount = it.amount, info = it.info or {}, slot = slot, label = it.label, type = it.type, weight = it.weight }
        end
        MySQL.insert.await('INSERT INTO stashitems (stash, items) VALUES (?, ?) ON DUPLICATE KEY UPDATE items = VALUES(items)', { id, json.encode(list) })
    end
    return {
        resource = resource, label = resource,
        prepare = function(self, id, label, slots, weight)
            return { kind = 'legacy', id = id, slots = slots, weight = weight,
                event = eventPrefix .. ':server:OpenInventory', current = eventPrefix .. ':client:SetCurrentStash' }
        end,
        playerItems = function(self, src)
            local p, out = qbPlayer(src), {}
            for _, it in pairs(p and p.PlayerData.items or {}) do out[#out + 1] = norm(it, qbLabel) end
            return out
        end,
        playerSlot = function(self, src, slot)
            local p = qbPlayer(src)
            return p and norm(p.PlayerData.items[tonumber(slot)], qbLabel)
        end,
        take = function(self, src, it, count)
            local p = qbPlayer(src)
            return p and p.Functions.RemoveItem(it.name, count, it.slot) or false
        end,
        give = function(self, src, it, count)
            local p = qbPlayer(src)
            return p and p.Functions.AddItem(it.name, count, nil, it.metadata) or false
        end,
        canCarry = function() return true end,   -- AddItem refuses if they can't, and the item stays in the bag
        bagItems = function(self, id)
            local out = {}
            for _, it in pairs(readStash(id)) do out[#out + 1] = norm(it, qbLabel) end
            return out
        end,
        bagAdd = function(self, id, it, count)
            local items = readStash(id)
            local slot = 1
            while items[slot] and slot <= (Config.Evidence.Slots or 30) do slot = slot + 1 end
            if slot > (Config.Evidence.Slots or 30) then return false end
            items[slot] = { name = it.name, amount = count, info = it.metadata or {}, label = it.label }
            writeStash(id, items)
            return true
        end,
        bagRemove = function(self, id, it, count)
            local items = readStash(id)
            local cur = items[tonumber(it.slot)]
            if not cur or cur.name ~= it.name then return false end
            cur.amount = (tonumber(cur.amount) or 1) - count
            if cur.amount <= 0 then items[tonumber(it.slot)] = nil end
            writeStash(id, items)
            return true
        end,
        bagClear = function(self, id) writeStash(id, {}) end,
    }
end
A['ps-inventory'] = legacyAdapter('ps-inventory', 'ps-inventory')
A['lj-inventory'] = legacyAdapter('lj-inventory', 'inventory')
A['qb-inventory-old'] = legacyAdapter('qb-inventory', 'inventory')

---------------------------------------------------------------------------
-- Picking one
---------------------------------------------------------------------------
local picked, pickedName
function Inv.Pick()
    if picked then return picked, pickedName end
    local cfg = Config.Evidence or {}
    local want = cfg.Inventory or 'auto'
    local function ok(name)
        local a = A[name]
        if not a or GetResourceState(a.resource) ~= 'started' then return false end
        if name == 'qb-inventory' then return a.detect() end
        if name == 'qb-inventory-old' then return not A['qb-inventory'].detect() end
        return true
    end
    if want ~= 'auto' then
        if ok(want) then picked, pickedName = A[want], want end
    else
        for _, name in ipairs({ 'ox_inventory', 'qs-inventory', 'ps-inventory', 'lj-inventory', 'qb-inventory', 'qb-inventory-old' }) do
            if ok(name) then picked, pickedName = A[name], name break end
        end
    end
    return picked, pickedName
end

--- Give a player an item (bail notices, stop and search records) in whatever inventory is running.
function Inv.Give(src, name, count, metadata)
    local a = Inv.Pick()
    if not a then return false end
    local ok, res = pcall(function()
        return a:give(src, { name = name, label = name, count = count, metadata = metadata }, count or 1)
    end)
    return ok and res
end

function Inv.Name()
    local a, name = Inv.Pick()
    return a and (a.label or name) or nil
end

-- Add your own inventory below, following the same functions as the adapters above:
-- Inv.Adapters.my_inventory = { resource = 'my_inventory', label = 'My Inventory', prepare = ..., playerItems = ..., ... }
-- then set Config.Evidence.Inventory = 'my_inventory'.
