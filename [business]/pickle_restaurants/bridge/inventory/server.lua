-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/inventory (server) — THE inventory layer.
--
-- `InitializeInventory()` is the one door: the framework bridges call it and, if a
-- driver claims the server, the global `Inventory` table is built here and they do
-- nothing further. Every inventory-specific line in this resource lives in a
-- driver file next to this one (bridge/inventory/<resource>/server.lua); this file
-- knows only the primitives those drivers expose (see bridge/inventory/shared.lua).
--
-- Two things it adds on top of a driver, and they are the reason it exists:
--
--   • THE METADATA OVERLAY. A driver that reports `metadata = false` is wrapped in
--     bridge/inventory/metadata, so per-slot metadata works everywhere — this
--     resource's three vessels ARE their metadata, and bare ESX has none.
--
--   • ONE ANSWER PER QUESTION. `GetItemSlots` / `RemoveItemSlot` /
--     `SetItemMetadata` used to be defined only on some paths, and every caller
--     carried an `if Inventory.GetItemSlots then … else …` fallback for the rest.
--     They are always defined now; a driver that genuinely cannot do a thing gets
--     the generic expression of it (slots become one anonymous pile, a slot
--     removal becomes a plain removal), which is what those fallbacks were.
--
-- DRIVER RESOLUTION is "highest priority whose resource is running". A dedicated
-- inventory always beats the framework's built-in item storage, which always beats
-- the do-nothing driver a bare server falls back to.
-- ─────────────────────────────────────────────────────────────────────────────

local initialized = false

local function started(res) return GetResourceState(res) == "started" end

local function pickDriver()
    local best
    for _, d in ipairs(InventoryDrivers or {}) do
        local running = (not d.resource) or started(d.resource)
        if running and (not d.ok or d.ok()) then
            if not best or (d.priority or 0) > (best.priority or 0) then best = d end
        end
    end
    return best
end

-- The active driver's name, for the boot log and for anything that wants to say
-- what it's talking to. nil until InitializeInventory has run.
function InventoryDriverName()
    return Inventory and Inventory.Driver or nil
end

function InitializeInventory()
    if initialized then return true end
    local driver = pickDriver()
    if not driver then return false end   -- caller keeps whatever it had
    initialized = true

    local P = (driver.build and driver.build()) or {}
    if driver.metadata == false then P = InventoryMetaOverlay(P) end

    Inventory = {}
    Inventory.Driver   = driver.name
    Inventory.Metadata = true                  -- always, thanks to the overlay
    Inventory.Items    = {}
    Inventory.Ready    = false

    -- ─── catalogue ───────────────────────────────────────────────────────────
    -- Rebuilt on demand (core re-reads it on every client sync request) so an item
    -- registered after boot is recognised without a restart.
    Inventory.RefreshItems = function()
        local items = P.items and P.items() or nil
        if type(items) == "table" then Inventory.Items = items end
    end

    Inventory.ItemExists = function(name)
        if not name or name == "" then return false end
        if P.exists then return P.exists(name) and true or false end
        return Inventory.Items[name] ~= nil
    end

    -- ─── counts & capacity ───────────────────────────────────────────────────
    Inventory.GetItemCount = function(source, name)
        if not P.count then return 0 end
        return tonumber(P.count(source, name)) or 0
    end

    Inventory.CanCarryItem = function(source, name, count)
        if not P.canCarry then return true end
        local ok = P.canCarry(source, name, tonumber(count) or 1)
        -- An inventory that cannot answer must not be read as "full": the add
        -- itself still enforces capacity, and a false negative here silently
        -- refuses whole orders.
        if ok == nil then return true end
        return ok and true or false
    end

    Inventory.GetInventory = function(source)
        return (P.inventory and P.inventory(source)) or {}
    end

    -- The client mirror is only ever a display list, so a lazy refresh is enough.
    Inventory.UpdateInventory = function(source)
        SetTimeout(1000, function()
            TriggerClientEvent("pickle_restaurants:updateInventory", source, Inventory.GetInventory(source))
        end)
    end

    -- ─── moving items ────────────────────────────────────────────────────────
    Inventory.AddItem = function(source, name, count, metadata)
        local ok = P.add and P.add(source, name, tonumber(count) or 1, metadata)
        Inventory.UpdateInventory(source)
        return ok
    end

    Inventory.RemoveItem = function(source, name, count, metadata)
        local ok = P.remove and P.remove(source, name, tonumber(count) or 1, metadata, nil)
        Inventory.UpdateInventory(source)
        return ok
    end

    -- ─── per-slot access (what keeps a variation intact) ─────────────────────
    -- Every entry is { slot, count, metadata }. A driver with no notion of slots
    -- reports the whole holding as ONE anonymous entry on slot 0 — which is
    -- exactly the shape the old `if not Inventory.GetItemSlots` fallbacks
    -- open-coded, now expressed once.
    Inventory.GetItemSlots = function(source, name)
        if P.slots then return P.slots(source, name) or {} end
        local n = Inventory.GetItemCount(source, name)
        return n > 0 and { { slot = 0, count = n, metadata = nil } } or {}
    end

    Inventory.RemoveItemSlot = function(source, name, count, slot)
        count = tonumber(count) or 1
        local ok
        if P.remove then ok = P.remove(source, name, count, nil, slot) end
        Inventory.UpdateInventory(source)
        return ok
    end

    Inventory.SetItemMetadata = function(source, name, slot, metadata)
        if not P.setMetadata then return false end
        local ok = P.setMetadata(source, name, slot, metadata)
        Inventory.UpdateInventory(source)
        return ok and true or false
    end

    -- ─── weapons ─────────────────────────────────────────────────────────────
    -- Only the ESX driver has a separate weapon store; everywhere else a weapon IS
    -- an item, which is what these default to.
    Inventory.AddWeapon = function(source, name, count, metadata)
        if P.addWeapon then return P.addWeapon(source, name, count, metadata) end
        return Inventory.AddItem(source, name, count or 1, metadata)
    end

    Inventory.RemoveWeapon = function(source, name, count)
        if P.removeWeapon then return P.removeWeapon(source, name, count) end
        return Inventory.RemoveItem(source, name, count or 1)
    end

    Inventory.HasWeapon = function(source, name)
        if P.hasWeapon then return P.hasWeapon(source, name) and true or false end
        return Inventory.GetItemCount(source, name) > 0
    end

    -- ─── item use ────────────────────────────────────────────────────────────
    -- The SECOND of the two usable-item routes. The framework's own hook
    -- (RegisterUsableItem) is the primary one and modules/consume always wires it;
    -- this covers the inventories that own item-use themselves and are running
    -- WITHOUT a framework to ask (Quasar or CodeM on a standalone server), where
    -- otherwise using a meal would do nothing at all. Returns false when the
    -- driver has no such hook, so the caller knows not to count on it.
    Inventory.RegisterUsable = function(name, cb)
        if not P.registerUsable then return false end
        return P.registerUsable(name, cb) and true or false
    end

    -- The client-side item list request predates this layer; keep answering it
    -- wherever the framework gives us a callback registrar to hang it on.
    if RegisterCallback then
        RegisterCallback("pickle_restaurants:getInventory", function(source, cb)
            cb(Inventory.GetInventory(source))
        end)
    end

    Inventory.RefreshItems()
    Inventory.Ready = true

    print(("[pickle_restaurants] inventory: %s%s"):format(
        driver.name,
        driver.metadata == false and " (metadata provided by pickle_restaurants)" or ""))
    return true
end
