-- =============================================================
--  Inventory bridge: ox_inventory, qb-inventory, qs-inventory,
--  core_inventory and codem-inventory.
--
--  Item metadata is optional. The driver record in the database
--  is the source of truth, so on inventories that can't store
--  metadata the licence is rebuilt from that record when shown.
-- =============================================================

INV = {}

local name
local adapters = {}

local function detect()
    local order = { 'ox_inventory', 'qb-inventory', 'qs-inventory', 'core_inventory', 'codem-inventory' }
    for _, res in ipairs(order) do
        if GetResourceState(res) == 'started' then
            name = res
            break
        end
    end
    if not name then
        print('^1[vinewood_licensing]^7 no supported inventory found - the physical licence item is disabled')
    else
        print(('^2[vinewood_licensing]^7 inventory: %s%s'):format(name, INV.SupportsMetadata and '' or ''))
    end
end

local function safe(fn, ...)
    local r = table.pack(pcall(fn, ...))
    if r[1] then return table.unpack(r, 2, r.n) end
    if Config and Config.Debug then
        print(('^3[vinewood_licensing]^7 inventory call failed: %s'):format(tostring(r[2])))
    end
end

---------------------------------------------------------------
-- ox_inventory
---------------------------------------------------------------
adapters.ox_inventory = {
    metadata = true,
    count = function(src, item)
        return tonumber(safe(function() return exports.ox_inventory:Search(src, 'count', item) end)) or 0
    end,
    slots = function(src, item)
        local slots = safe(function() return exports.ox_inventory:Search(src, 'slots', item) end)
        local out = {}
        for _, s in ipairs(type(slots) == 'table' and slots or {}) do
            out[#out + 1] = { slot = s.slot, metadata = type(s.metadata) == 'table' and s.metadata or {} }
        end
        return out
    end,
    add = function(src, item, count, metadata)
        return safe(function() return exports.ox_inventory:AddItem(src, item, count, metadata) end) == true
    end,
    remove = function(src, item, count)
        return safe(function() return exports.ox_inventory:RemoveItem(src, item, count) end) ~= nil
    end,
    setMetadata = function(src, slot, metadata)
        safe(function() exports.ox_inventory:SetMetadata(src, slot, metadata) end)
    end
}

---------------------------------------------------------------
-- qb-inventory (exports, with qb-core player fallback)
---------------------------------------------------------------
local function qbPlayerItems(src, item)
    local p = FW.Player(src)
    if not p or not p.PlayerData or not p.PlayerData.items then return {} end
    local out = {}
    for slot, it in pairs(p.PlayerData.items) do
        if it and it.name == item then
            out[#out + 1] = { slot = it.slot or slot, metadata = type(it.info) == 'table' and it.info or {} }
        end
    end
    return out
end

adapters['qb-inventory'] = {
    metadata = true,
    count = function(src, item) return #qbPlayerItems(src, item) end,
    slots = qbPlayerItems,
    add = function(src, item, count, metadata)
        local done = safe(function()
            return exports['qb-inventory']:AddItem(src, item, count, false, metadata, 'vinewood_licensing')
        end)
        if done ~= nil and done ~= false then return true end
        local p = FW.Player(src)
        return p and p.Functions.AddItem(item, count, false, metadata) == true or false
    end,
    remove = function(src, item, count)
        local done = safe(function()
            return exports['qb-inventory']:RemoveItem(src, item, count, false, 'vinewood_licensing')
        end)
        if done ~= nil and done ~= false then return true end
        local p = FW.Player(src)
        return p and p.Functions.RemoveItem(item, count) == true or false
    end,
    setMetadata = function(src, slot, metadata)
        if safe(function() return exports['qb-inventory']:SetItemData(src, slot, 'info', metadata) end) ~= nil then return end
        -- older builds: write straight onto the player's item table
        local p = FW.Player(src)
        if not p or not p.PlayerData or not p.PlayerData.items then return end
        local it = p.PlayerData.items[slot]
        if it then
            it.info = metadata
            if p.Functions.SetInventory then p.Functions.SetInventory(p.PlayerData.items, true) end
        end
    end
}

---------------------------------------------------------------
-- qs-inventory
---------------------------------------------------------------
adapters['qs-inventory'] = {
    metadata = true,
    count = function(src, item)
        return tonumber(safe(function() return exports['qs-inventory']:GetItemTotalAmount(src, item) end)) or 0
    end,
    slots = function(src, item)
        local items = safe(function() return exports['qs-inventory']:GetInventory(src) end)
        local out = {}
        for slot, it in pairs(type(items) == 'table' and items or {}) do
            if it and it.name == item then
                out[#out + 1] = { slot = it.slot or slot, metadata = type(it.info) == 'table' and it.info or {} }
            end
        end
        return out
    end,
    add = function(src, item, count, metadata)
        return safe(function()
            return exports['qs-inventory']:AddItem(src, item, count, nil, metadata)
        end) ~= nil
    end,
    remove = function(src, item, count)
        return safe(function() return exports['qs-inventory']:RemoveItem(src, item, count) end) ~= nil
    end,
    setMetadata = function(src, slot, metadata)
        safe(function() return exports['qs-inventory']:SetItemMetadata(src, slot, metadata) end)
    end
}

---------------------------------------------------------------
-- core_inventory (metadata model differs; treated as metadata-less)
---------------------------------------------------------------
adapters.core_inventory = {
    metadata = false,
    count = function(src, item)
        local n = safe(function() return exports.core_inventory:getItemCount(src, item) end)
        return tonumber(n) or 0
    end,
    slots = function(src, item)
        local n = adapters.core_inventory.count(src, item)
        local out = {}
        for i = 1, n do out[#out + 1] = { slot = i, metadata = {} } end
        return out
    end,
    add = function(src, item, count)
        return safe(function() return exports.core_inventory:addItem(src, item, count, nil, 'vinewood_licensing') end) ~= nil
    end,
    remove = function(src, item, count)
        return safe(function() return exports.core_inventory:removeItem(src, item, count) end) ~= nil
    end,
    setMetadata = function() end
}

---------------------------------------------------------------
-- codem-inventory
---------------------------------------------------------------
adapters['codem-inventory'] = {
    metadata = true,
    count = function(src, item)
        local it = safe(function() return exports['codem-inventory']:GetItemsTotalAmount(src, item) end)
        return tonumber(it) or 0
    end,
    slots = function(src, item)
        local items = safe(function() return exports['codem-inventory']:GetInventory(src) end)
        local out = {}
        for slot, it in pairs(type(items) == 'table' and items or {}) do
            if it and it.name == item then
                out[#out + 1] = { slot = it.slot or slot, metadata = type(it.info) == 'table' and it.info or {} }
            end
        end
        return out
    end,
    add = function(src, item, count, metadata)
        return safe(function() return exports['codem-inventory']:AddItem(src, item, count, nil, metadata) end) ~= nil
    end,
    remove = function(src, item, count)
        return safe(function() return exports['codem-inventory']:RemoveItem(src, item, count) end) ~= nil
    end,
    setMetadata = function(src, slot, metadata)
        safe(function() return exports['codem-inventory']:SetItemMetadata(src, slot, metadata) end)
    end
}

---------------------------------------------------------------
-- Public API
---------------------------------------------------------------
detect()

local function a()
    return name and adapters[name] or nil
end

function INV.Name() return name end
function INV.Available() return a() ~= nil end

--- Can this inventory store per-item metadata? When false the licence card is
--- rebuilt from the driver record instead.
function INV.SupportsMetadata()
    local ad = a()
    return ad ~= nil and ad.metadata == true
end

function INV.Count(src, item)
    local ad = a()
    return ad and ad.count(src, item) or 0
end

function INV.Slots(src, item)
    local ad = a()
    return ad and ad.slots(src, item) or {}
end

function INV.FirstMetadata(src, item)
    local slots = INV.Slots(src, item)
    local first = slots[1]
    return first and first.metadata or nil, first and first.slot or nil
end

function INV.Add(src, item, count, metadata)
    local ad = a()
    return ad and ad.add(src, item, count or 1, metadata) or false
end

function INV.Remove(src, item, count)
    local ad = a()
    return ad and ad.remove(src, item, count or 1) or false
end

function INV.SetMetadata(src, slot, metadata)
    local ad = a()
    if ad and slot then ad.setMetadata(src, slot, metadata) end
end

--- Registers the "use item" hook. ox_inventory uses a client export instead
--- (see client/main.lua), so this is a no-op there.
function INV.RegisterUsable(item, fn)
    if not item or name == 'ox_inventory' then return end
    local fw = FW.Name()
    if fw == 'esx' then
        local ok = pcall(function()
            exports['es_extended']:getSharedObject().RegisterUsableItem(item, fn)
        end)
        if ok then return end
    end
    pcall(function()
        local core = exports['qb-core']:GetCoreObject()
        core.Functions.CreateUseableItem(item, function(src) fn(src) end)
    end)
end
