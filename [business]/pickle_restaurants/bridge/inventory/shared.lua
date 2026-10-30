-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/inventory (shared) — the inventory DRIVER registry.
--
-- The framework bridges used to each carry their own copy of an inventory layer,
-- which meant three places to teach about a new inventory and three subtly
-- different answers to the same question (bare ESX had no per-slot metadata at
-- all, so a Restaurant Bag lost its contents the moment it entered a pocket).
-- There is now ONE inventory layer: `bridge/inventory/server.lua` builds the
-- global `Inventory` table out of a DRIVER, and a driver is one small file per
-- inventory resource — the same shape `bridge/phone` and `bridge/target` use.
--
-- WHY A DRIVER IS A SET OF PRIMITIVES, not an `Inventory` table of its own: every
-- inventory answers the same handful of questions (what items exist, how many does
-- this player hold, add/remove N, which slots hold it, rewrite one slot's
-- metadata), and everything else the resource asks for — weapons, the client
-- mirror, the getInventory callback, and CRUCIALLY the metadata OVERLAY for an
-- inventory that has none — is expressed once on top of them.
--
-- ADDING SUPPORT FOR YOUR INVENTORY is one file:
--
--     -- bridge/inventory/my-inventory/server.lua
--     RegisterInventoryDriver({
--         name     = "my-inventory",   -- resource name, also the boot-log label
--         priority = 90,               -- highest RUNNING driver wins
--         metadata = true,             -- does it store per-slot metadata itself?
--         build    = function()
--             return { items = ..., count = ..., add = ..., remove = ... }
--         end,
--     })
--
-- The primitives (all optional — an absent one degrades, it never errors):
--   items()                              → { [name] = { label, image } }
--   exists(name)                         → boolean (defaults to an items() lookup)
--   count(src, name)                     → number
--   add(src, name, count, metadata)      → truthy on success
--   remove(src, name, count, metadata, slot) → truthy on success
--   slots(src, name)                     → { { slot, count, metadata }, … }
--   setMetadata(src, name, slot, metadata) → truthy on success
--   canCarry(src, name, count)           → boolean
--   inventory(src)                       → { { name, label, count, weight }, … }
--   registerUsable(name, cb)             → truthy if the inventory owns item-use
--   addWeapon / removeWeapon / hasWeapon → default to the item primitives
--
-- `metadata = false` is not a limitation you have to live with: the layer wraps
-- such a driver in a DB-backed metadata overlay (bridge/inventory/metadata) so
-- meals, bags and takeout boxes keep their build stacks on bare ESX too.
-- ─────────────────────────────────────────────────────────────────────────────

InventoryDrivers = InventoryDrivers or {}

function RegisterInventoryDriver(def)
    if type(def) ~= "table" or type(def.name) ~= "string" then return end
    -- Idempotent by name: a re-registration REPLACES, so an edited driver reloaded
    -- with the resource can't end up listed twice at two priorities.
    for i, d in ipairs(InventoryDrivers) do
        if d.name == def.name then InventoryDrivers[i] = def return end
    end
    InventoryDrivers[#InventoryDrivers + 1] = def
end

-- ─── calling an export that might not exist ──────────────────────────────────
-- Same trap the phone bridge documents: `exports[res][name]` RAISES ON THE INDEX,
-- and as an ARGUMENT to pcall it is evaluated before pcall ever runs — so
-- `pcall(exports[res][name], …)` throws instead of returning false. The index has
-- to happen INSIDE the protected function, which is the whole reason this helper
-- exists rather than each driver reaching for a bare pcall.
--
-- Returns (ok, result). `ok == false` means "no such export / it errored", which
-- is what makes trying candidate names in turn possible at all.
function InvExport(resource, name, ...)
    local args = table.pack(...)
    return pcall(function()
        return exports[resource][name](nil, table.unpack(args, 1, args.n))
    end)
end

-- Try candidate export names in order and REMEMBER the winner. Inventory forks
-- rename exports far more often than they change their arguments (GetItemCount vs
-- GetItemsTotalAmount vs GetItemTotalAmount are the same question three times), so
-- a driver lists the names it has seen and this resolves once per key.
--
-- `key` scopes the memo, because one resource has several of these to resolve.
-- Returns (ok, result) exactly like InvExport; a miss on every name is (false, nil).
local resolvedNames = {}   -- "resource|key" → export name, or false once all missed

function InvExportAny(resource, key, names, ...)
    local memo = resource .. "|" .. key
    local hit = resolvedNames[memo]
    if hit then return InvExport(resource, hit, ...) end
    if hit == false then return false, nil end
    for _, name in ipairs(names) do
        local ok, ret = InvExport(resource, name, ...)
        if ok then
            resolvedNames[memo] = name
            return true, ret
        end
    end
    resolvedNames[memo] = false
    return false, nil
end

-- Has a candidate set been resolved to a real export? Used by the drivers to
-- report a capability honestly (e.g. "this build has no SetItemMetadata"), so the
-- layer can fall back rather than silently doing nothing.
function InvExportResolved(resource, key)
    return resolvedNames[resource .. "|" .. key] and true or false
end

-- ─── the qb-lineage shape ────────────────────────────────────────────────────
-- qb-inventory and the inventories forked from it (ps, lj, origen, codem, tgiann,
-- …) are the SAME six exports under different names and, occasionally, one extra
-- trailing argument. Writing that out six times would mean six places to fix the
-- day one of them renames something, so the shape lives here once and each driver
-- file is a resource name plus whatever it calls things.
--
--   InvQbShapedDriver("ps-inventory", { names = { count = { "GetItemsTotalAmount" } } })
--
-- Every `names` entry is a CANDIDATE LIST tried in order (InvExportAny), and a
-- driver's own list is tried BEFORE the defaults — so naming one export does not
-- cost you the fallbacks for the rest.
local QB_DEFAULT_NAMES = {
    items       = { "GetItemList", "getItemList", "Items", "GetItems" },
    count       = { "GetItemCount", "GetItemsTotalAmount", "GetItemTotalAmount", "GetItemsCount" },
    add         = { "AddItem" },
    remove      = { "RemoveItem" },
    -- PLURAL ONLY. `GetItemByName` returns ONE item table, and iterating that with
    -- pairs() walks its FIELDS as if they were slots — an `info` table would come
    -- back looking like a real slot and hand the POS a burger nobody is carrying.
    byName      = { "GetItemsByName" },
    inventory   = { "GetInventory", "GetPlayerItems", "GetInventoryItems" },
    setMetadata = { "SetItemMetadata", "SetMetadata", "UpdateItemMetadata" },
    canCarry    = { "CanCarryItem", "CanAddItem" },
    usable      = { "CreateUsableItem", "CreateUseableItem" },
}

-- The FRAMEWORK's own item definitions, as a catalogue.
--
-- An inventory resource stores what a player HOLDS; what an item IS usually lives
-- in the framework. So an inventory with no item-list export of its own is not
-- item-less — it is pointing at this, and every driver falls through to it.
--
-- IT HAS TO ANSWER ON ALL THREE FRAMEWORKS, not just QB. Most of these inventories
-- are framework-agnostic (Quasar, Origen, CodeM and ox all run on ESX and QB
-- alike), so asking only qb-core would leave an ESX server running one of them
-- with an EMPTY catalogue — and the catalogue is what the admin panel picks items
-- from, so the whole resource would look like it had no items installed.
--
-- Order: qb-core's shared items → ESX's live registry → the `items` table ESX
-- servers without that registry still have. The SQL read is last and pcall'd
-- because it is the only one that can be absent AND throw.
function InvFrameworkItems()
    local base = InventoryImageBase()
    local out = {}

    local qb = QBCore and QBCore.Shared and QBCore.Shared.Items
    if type(qb) == "table" then
        for item, data in pairs(qb) do
            if type(data) == "table" then
                out[item] = { label = data.label or PrettyItemName(item),
                              image = InvImageUrl(base, item, data.image) }
            end
        end
        if next(out) ~= nil then return out end
    end

    local esx = ESX and ESX.Items
    if type(esx) == "table" then
        for item, data in pairs(esx) do
            if type(data) == "table" then
                out[item] = { label = data.label or PrettyItemName(item),
                              image = InvImageUrl(base, item, nil) }
            end
        end
        if next(out) ~= nil then return out end
    end

    if ESX then
        local ok, rows = pcall(function()
            return MySQL.query.await("SELECT name, label FROM items")
        end)
        if ok then
            for _, row in ipairs(rows or {}) do
                out[row.name] = { label = row.label, image = InvImageUrl(base, row.name, nil) }
            end
        end
    end

    return next(out) ~= nil and out or nil
end

-- One inventory row → our { name, label, count, weight } shape, whatever the fork
-- calls the fields. `amount` is qb's word for count and `info` its word for
-- metadata; both spellings appear across the family, sometimes in one build.
function InvNormalizeSlot(row, fallbackName)
    if type(row) ~= "table" then return nil end
    -- A real slot row always identifies itself with a slot number or an item name.
    -- Demanding one is what stops a nested `info` table, reached by iterating
    -- something that was never a list, from being read as a slot.
    if row.slot == nil and row.name == nil then return nil end
    return {
        name     = row.name or fallbackName,
        label    = row.label,
        slot     = tonumber(row.slot) or 0,
        count    = tonumber(row.amount or row.count or row.quantity) or 1,
        weight   = row.weight,
        metadata = row.info or row.metadata,
    }
end

function InvQbShapedDriver(res, spec)
    spec = spec or {}
    local given = spec.names or {}

    -- A driver's own names first, then the family defaults.
    local function candidates(key)
        local out = {}
        for _, n in ipairs(given[key] or {}) do out[#out + 1] = n end
        for _, n in ipairs(QB_DEFAULT_NAMES[key] or {}) do out[#out + 1] = n end
        return out
    end

    -- The trailing "reason" argument qb-inventory logs a movement under. It is NOT
    -- universal: tgiann's sixth argument is `isClotheSlot` and its fifth on removal
    -- is METADATA, so a reason string passed blindly there would flag every meal as
    -- clothing and every removal as a metadata filter. `reason = false` says "this
    -- fork has no such argument — pass nothing".
    local reason = spec.reason
    if reason == nil then reason = "pickle_restaurants" end
    if reason == false then reason = nil end

    return function()
        local P = {}

        P.items = function()
            local base = InventoryImageBase()
            local ok, list = InvExportAny(res, "items", candidates("items"))
            local out = {}
            if ok and type(list) == "table" then
                for item, data in pairs(list) do
                    if type(data) == "table" and type(item) == "string" then
                        out[item] = { label = data.label or PrettyItemName(item),
                                      image = InvImageUrl(base, item, data.image) }
                    end
                end
            end
            if next(out) ~= nil then return out end
            return InvFrameworkItems() or {}
        end

        -- Every row this inventory holds of ONE item, normalized. The by-name
        -- export first; failing that, a scan of the whole inventory — a fork that
        -- publishes only `GetInventory` still gets per-slot metadata this way,
        -- which is what a vessel needs to survive a pocket.
        P.slots = function(src, name)
            local out = {}
            local ok, rows = InvExportAny(res, "byName", candidates("byName"), src, name)
            if ok and type(rows) == "table" then
                for _, row in pairs(rows) do
                    local s = InvNormalizeSlot(row, name)
                    if s and (s.name == name or s.name == nil) then
                        out[#out + 1] = { slot = s.slot, count = s.count, metadata = s.metadata }
                    end
                end
                if #out > 0 then return out end
            end
            local ok2, inv = InvExportAny(res, "inventory", candidates("inventory"), src)
            if ok2 and type(inv) == "table" then
                for _, row in pairs(type(inv.items) == "table" and inv.items or inv) do
                    local s = InvNormalizeSlot(row)
                    if s and s.name == name then
                        out[#out + 1] = { slot = s.slot, count = s.count, metadata = s.metadata }
                    end
                end
            end
            return out
        end

        P.count = function(src, name)
            local ok, n = InvExportAny(res, "count", candidates("count"), src, name)
            if ok and tonumber(n) then return tonumber(n) end
            -- No count export (or one that answered nothing): the slots ARE the
            -- count, and we already know how to read those.
            local total = 0
            for _, s in ipairs(P.slots(src, name)) do total = total + (s.count or 1) end
            return total
        end

        P.inventory = function(src)
            local out = {}
            local ok, inv = InvExportAny(res, "inventory", candidates("inventory"), src)
            if ok and type(inv) == "table" then
                for _, row in pairs(type(inv.items) == "table" and inv.items or inv) do
                    local s = InvNormalizeSlot(row)
                    if s and s.name then
                        out[#out + 1] = { name = s.name, label = s.label, count = s.count, weight = s.weight }
                    end
                end
            end
            return out
        end

        -- qb's AddItem is (src, item, amount, slot, info[, reason]); passing nil
        -- for the slot is how you say "wherever it fits", which is always what we
        -- mean — a vessel goes in a pocket, not in a particular pocket.
        P.add = function(src, name, count, metadata)
            local ok, ret = InvExportAny(res, "add", candidates("add"),
                src, name, count, nil, metadata, reason)
            if not ok then return false end
            return ret ~= false
        end

        -- REMOVAL IS BY SLOT WHEN IT HAS TO BE. qb's RemoveItem takes no metadata
        -- filter, so "remove this exact variation" means finding its slot first —
        -- otherwise a plain burger could be spent to fill an order for a loaded one.
        P.remove = function(src, name, count, metadata, slot)
            slot = tonumber(slot)
            if (not slot or slot <= 0) and metadata ~= nil then
                for _, s in ipairs(P.slots(src, name)) do
                    if InvMetaMatches(metadata, s.metadata) then slot = s.slot break end
                end
            end
            local ok, ret = InvExportAny(res, "remove", candidates("remove"),
                src, name, count, (slot and slot > 0) and slot or nil, reason)
            if not ok then return false end
            return ret ~= false
        end

        P.setMetadata = function(src, name, slot, metadata)
            local ok, ret = InvExportAny(res, "setMetadata", candidates("setMetadata"), src, slot, metadata)
            return ok and ret ~= false
        end

        P.canCarry = function(src, name, count)
            local ok, ret = InvExportAny(res, "canCarry", candidates("canCarry"), src, name, count)
            if not ok then return nil end   -- nil = "can't say", never "full"
            return ret ~= false
        end

        P.registerUsable = function(name, cb)
            local ok = InvExportAny(res, "usable", candidates("usable"), name, cb)
            return ok
        end

        if spec.extend then spec.extend(P) end
        return P
    end
end

-- ─── comparing metadata ──────────────────────────────────────────────────────
-- "Is this the same variation?" is asked by every remove path, and it has to be
-- ORDER-INSENSITIVE and NIL-TOLERANT: a build stack round-trips through JSON on
-- the way into a slot, and a caller that passes no metadata means "any", never
-- "the plain one". Shared because both the drivers and the metadata overlay ask it.
function InvMetaMatches(want, have)
    if want == nil then return true end        -- no filter = anything matches
    if type(want) ~= "table" then return want == have end
    if type(have) ~= "table" then return false end
    for k, v in pairs(want) do
        if type(v) == "table" then
            if not InvMetaMatches(v, have[k]) then return false end
        elseif have[k] ~= v then
            return false
        end
    end
    return true
end
