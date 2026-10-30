-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/inventory/metadata (server) — PER-SLOT METADATA FOR AN INVENTORY THAT
-- HAS NONE.
--
-- This resource's three vessels — a meal, a Restaurant Bag, a takeout box — are
-- ONE item each whose entire identity is its metadata (the one-item consolidation
-- rule: every drink is the drink item, every boxed food the box item). An
-- inventory that cannot attach metadata to a slot therefore cannot carry them: a
-- bag put in a pocket on bare ESX came back out as a generic "Restaurant Bag"
-- holding nothing, and the POS could not tell a Lardboy from a Smelly Kat.
--
-- So where the driver reports `metadata = false`, the inventory layer wraps it in
-- this OVERLAY. The real inventory still owns the units — how many of an item a
-- player holds is always the framework's answer, never ours — and we hold one row
-- per unit that has metadata, in a table of our own. Two stores, one authority:
-- the COUNT is theirs, the VARIATION is ours, and every read reconciles the second
-- against the first.
--
-- WHY ONLY UNITS WITH METADATA GET A ROW: a row per unit outright would mean 500
-- rows for 500 bottles of water. Plain units are not tracked at all — they are the
-- REMAINDER (`count` minus the tracked rows), reported as one synthetic entry on
-- SLOT 0. Virtual slots start at 1 and are ours alone; slot 0 always means "one of
-- the plain ones", which is also why removing against it deletes no row.
--
-- RECONCILIATION is what keeps this honest. A player can drop, trade, or lose an
-- item by any of a hundred paths this resource never sees, so tracked rows are
-- capped against the live count on every read: more rows than units means units
-- left, and the NEWEST rows are dropped (a bag the player still holds is far more
-- likely to be the one they've had longest). We never invent units — a row can
-- only ever describe a unit the inventory itself agrees is there.
--
-- The table is created only if an overlay is actually installed, so a server on
-- ox_inventory never grows one. That is also why the CREATE lives here and not in
-- core's CreateTables(): it belongs to a bridge that may never load.
-- ─────────────────────────────────────────────────────────────────────────────

local TABLE = "pickle_restaurant_item_meta"

-- The overlay is installed at boot, before the database is necessarily up, so the
-- CREATE is hung off MySQL.ready and every read waits for this flag rather than
-- racing it. Nothing here is on a hot path — a bag is looked up when someone opens
-- it, not per frame — so a short wait costs nothing and a query against a table
-- that doesn't exist yet costs a player their bag's contents.
local ready = false
local created = false

local function ensureTable()
    if created then return end
    created = true
    MySQL.ready(function()
        MySQL.query.await(([[
        CREATE TABLE IF NOT EXISTS `%s` (
            `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `identifier` VARCHAR(80)  NOT NULL,
            `item`       VARCHAR(64)  NOT NULL,
            `slot`       INT          NOT NULL,
            `metadata`   LONGTEXT     NULL,
            PRIMARY KEY (`id`),
            UNIQUE KEY `owner_slot` (`identifier`, `item`, `slot`),
            KEY `owner_item` (`identifier`, `item`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
        ]]):format(TABLE))
        ready = true
    end)
end

local function awaitReady()
    while not ready do Wait(100) end
end

-- [identifier] = { [item] = { { id, slot, metadata }, … } }, ordered oldest-first.
-- Cached because every POS fulfilment pass reads a staff member's vessels, and
-- because we are the only writer — nothing else on the server touches this table.
local Cache = {}

local function loadOwner(identifier)
    if Cache[identifier] then return Cache[identifier] end
    awaitReady()
    if Cache[identifier] then return Cache[identifier] end   -- another caller won the wait
    local byItem = {}
    for _, row in ipairs(MySQL.query.await(
        ("SELECT id, item, slot, metadata FROM `%s` WHERE identifier = ? ORDER BY slot ASC"):format(TABLE),
        { identifier }) or {}) do
        local meta
        if row.metadata and row.metadata ~= "" then
            local ok, decoded = pcall(json.decode, row.metadata)
            meta = ok and decoded or nil
        end
        byItem[row.item] = byItem[row.item] or {}
        byItem[row.item][#byItem[row.item] + 1] = { id = row.id, slot = row.slot, metadata = meta }
    end
    Cache[identifier] = byItem
    return byItem
end

local function rowsFor(identifier, item)
    local byItem = loadOwner(identifier)
    byItem[item] = byItem[item] or {}
    return byItem[item]
end

local function nextSlot(rows)
    local max = 0
    for _, r in ipairs(rows) do if r.slot > max then max = r.slot end end
    return max + 1
end

-- Deleted by the UNIQUE KEY, not by `id`: a row claimed by insertRow may still
-- have its insert in flight and no id yet, and deleting by an id that is nil would
-- leave the row behind in the table forever while it vanished from the cache.
local function dropRow(identifier, item, index)
    local rows = rowsFor(identifier, item)
    local row = table.remove(rows, index)
    if row then
        MySQL.update(("DELETE FROM `%s` WHERE identifier = ? AND item = ? AND slot = ?"):format(TABLE),
            { identifier, item, row.slot })
    end
    return row
end

-- Claim the next virtual slot and write the row. THE CLAIM HAPPENS BEFORE THE
-- INSERT AWAITS, which is the whole point: `MySQL.insert.await` yields, and two
-- cooks bagging up at the same moment would otherwise both read the same
-- `nextSlot` and collide on the unique key — one of them silently losing their
-- bag's contents. Seating the row in the cache first means the second caller
-- already sees the slot as taken.
local function insertRow(identifier, item, metadata)
    local rows = rowsFor(identifier, item)
    local row = { id = nil, slot = nextSlot(rows), metadata = metadata }
    rows[#rows + 1] = row
    row.id = MySQL.insert.await(
        ("INSERT INTO `%s` (identifier, item, slot, metadata) VALUES (?, ?, ?, ?)"):format(TABLE),
        { identifier, item, row.slot, metadata ~= nil and json.encode(metadata) or nil })
    return row
end

-- Cap tracked rows against the live count and return them. THE ONE PLACE the two
-- stores are reconciled — every read goes through it, so a stale row can never
-- outlive the unit it described by more than one call.
local function reconcile(identifier, item, liveCount)
    local rows = rowsFor(identifier, item)
    while #rows > liveCount do dropRow(identifier, item, #rows) end
    return rows
end

-- ─── the overlay ─────────────────────────────────────────────────────────────
-- Takes a driver's primitives and returns primitives with the same signatures,
-- metadata added. Everything it cannot answer itself it delegates, so a driver
-- gains metadata without knowing this file exists.
function InventoryMetaOverlay(P)
    ensureTable()

    local O = {}
    for k, v in pairs(P) do O[k] = v end

    -- Identity is the FRAMEWORK's identifier, not the source: a player's server id
    -- changes every reconnect and their pockets do not.
    local function ident(src)
        return (GetIdentifier and GetIdentifier(tonumber(src))) or nil
    end

    local function liveCount(src, name)
        return (P.count and tonumber(P.count(src, name))) or 0
    end

    O.slots = function(src, name)
        local id = ident(src)
        local total = liveCount(src, name)
        if not id then
            -- No identifier (a console/unloaded source): report the plain remainder
            -- only. Better a variation-blind answer than pinning rows to a key that
            -- will not be the same one next session.
            return total > 0 and { { slot = 0, count = total, metadata = nil } } or {}
        end
        local rows = reconcile(id, name, total)
        local out = {}
        for _, r in ipairs(rows) do
            out[#out + 1] = { slot = r.slot, count = 1, metadata = r.metadata }
        end
        local plain = total - #rows
        if plain > 0 then out[#out + 1] = { slot = 0, count = plain, metadata = nil } end
        return out
    end

    -- HOW MANY UNITS ACTUALLY MOVED, not how many were asked for. No inventory
    -- agrees on what add/remove returns (most return nothing at all), so the count
    -- either side of the call is the only trustworthy answer — the same test
    -- `giveVessel` uses to decide whether a vessel reached a pocket. Writing rows
    -- for units that never arrived is how an overlay starts lying.
    O.add = function(src, name, count, metadata)
        count = tonumber(count) or 1
        local before = liveCount(src, name)
        local ok = P.add and P.add(src, name, count, metadata)
        if ok == false then return false end
        local landed = math.max(0, liveCount(src, name) - before)
        if landed == 0 then return false end
        if metadata == nil then return true end   -- nothing to record; the units landed
        local id = ident(src)
        if not id then return true end
        for _ = 1, landed do insertRow(id, name, metadata) end
        return true
    end

    O.remove = function(src, name, count, metadata, slot)
        count = tonumber(count) or 1
        local id = ident(src)
        local before = liveCount(src, name)
        local ok = P.remove and P.remove(src, name, count, nil, nil)
        if ok == false then return false end
        local taken = math.max(0, before - liveCount(src, name))
        if taken == 0 then return false end
        count = taken
        if not id then return true end

        local rows = reconcile(id, name, before)

        -- An explicit virtual slot is the exact instance the caller was shown.
        if slot and tonumber(slot) and tonumber(slot) > 0 then
            slot = tonumber(slot)
            for i, r in ipairs(rows) do
                if r.slot == slot then dropRow(id, name, i) break end
            end
            return true
        end

        -- Otherwise spend the plain units FIRST and only then tracked rows: a
        -- caller asking for "any two" must not destroy a bag's recorded contents
        -- while an identical plain unit was sitting right there. With a metadata
        -- filter, only matching rows are eligible at all.
        local left = count
        if metadata == nil then
            left = math.max(0, left - math.max(0, before - #rows))
        end
        local i = 1
        while left > 0 and i <= #rows do
            if InvMetaMatches(metadata, rows[i].metadata) then
                dropRow(id, name, i)
                left = left - 1
            else
                i = i + 1
            end
        end
        return true
    end

    O.count = function(src, name)
        return liveCount(src, name)
    end

    O.setMetadata = function(src, name, slot, metadata)
        local id = ident(src)
        if not id then return false end
        slot = tonumber(slot) or 0
        local rows = reconcile(id, name, liveCount(src, name))
        for _, r in ipairs(rows) do
            if r.slot == slot then
                r.metadata = metadata
                MySQL.update(
                    ("UPDATE `%s` SET metadata = ? WHERE identifier = ? AND item = ? AND slot = ?"):format(TABLE),
                    { metadata ~= nil and json.encode(metadata) or nil, id, name, slot })
                return true
            end
        end
        -- Slot 0 is the plain remainder, which has no row to rewrite — PROMOTE one
        -- of those units into a tracked row instead of refusing. That is what makes
        -- "this generic bag now holds something" expressible at all.
        if slot == 0 and liveCount(src, name) > #rows and metadata ~= nil then
            insertRow(id, name, metadata)
            return true
        end
        return false
    end

    return O
end
