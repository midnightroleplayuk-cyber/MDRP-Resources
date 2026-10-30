-- bridge/inventory/jaksam_inventory — jaksam's inventory.
--
-- Not a qb-lineage fork, so `InvQbShapedDriver` doesn't fit: its own export names
-- and argument lists are stable and documented, so this reads like the ox driver —
-- direct calls, no candidate-name probing.
--
-- What it gives us natively:
--   • per-slot metadata (`getItemsByName` returns { name, amount, metadata, slot },
--     `setItemMetadataInSlot` rewrites one), so no overlay — a bag keeps its build
--     stack in a pocket;
--   • an item catalogue AND an image resolver (`getItemImagePath` already answers
--     `nui://jaksam_inventory/_images/<file>`, extension and fallback included), so
--     the driver hands that url straight through rather than guessing `<item>.png`
--     through InvImageUrl.
--
-- REMOVING AN EXACT VARIATION GOES BY SLOT, the same rule the qb family follows.
-- `removeItem`'s metadata argument is a match filter whose strictness is the
-- inventory's business, and "spend THIS burger" has to mean the instance we found —
-- so we resolve the slot ourselves with our own InvMetaMatches and remove by slot.
--
-- Item USE: `registerUsableItem` is published, but jaksam also routes use through
-- the framework when there is one, which is why the layer only ever reaches for
-- this after the framework hook has said no (see bridge/inventory/server.lua).
RegisterInventoryDriver({
    name     = "jaksam_inventory",
    resource = "jaksam_inventory",
    priority = 92,
    metadata = true,
    build = function()
        local jak = exports.jaksam_inventory

        -- `getItemImagePath` is the inventory's OWN answer (custom `image` field →
        -- .png/.webp lookup → its box placeholder), so it beats anything we could
        -- assemble; InvImageUrl is only the fallback for a build without it.
        local function imageFor(item, data)
            local ok, path = pcall(function() return jak:getItemImagePath(item) end)
            if ok and type(path) == "string" and path ~= "" then return path end
            return InvImageUrl(InventoryImageBase(), item, data and data.image)
        end

        local P = {}

        P.items = function()
            local list = jak:getStaticItemsList() or {}
            local out = {}
            for item, data in pairs(list) do
                if type(item) == "string" and type(data) == "table" then
                    out[item] = { label = data.label or PrettyItemName(item), image = imageFor(item, data) }
                end
            end
            return out
        end

        -- Live, so an item registered at runtime (`registerItem`) is recognised
        -- without waiting for the next catalogue refresh.
        P.exists = function(name) return jak:getStaticItem(name) ~= nil end

        -- skipContainers: a meal sitting inside somebody's backpack is not a meal
        -- this resource can spend — `removeItem` acts on the inventory itself — so
        -- counting it would report stock the POS can never reach.
        P.count = function(src, name)
            return tonumber(jak:getTotalItemAmount(src, name, nil, true)) or 0
        end

        P.canCarry = function(src, name, count) return jak:canCarryItem(src, name, count) end

        P.slots = function(src, name)
            local out = {}
            for _, row in pairs(jak:getItemsByName(src, name) or {}) do
                if type(row) == "table" and row.slot then
                    out[#out + 1] = { slot = tonumber(row.slot) or 0,
                                      count = tonumber(row.amount) or 1,
                                      metadata = row.metadata }
                end
            end
            return out
        end

        -- Slot nil = "wherever it fits", which is always what we mean.
        P.add = function(src, name, count, metadata)
            local ok = jak:addItem(src, name, count, metadata, nil)
            return ok ~= false
        end

        P.remove = function(src, name, count, metadata, slot)
            slot = tonumber(slot)
            if (not slot or slot <= 0) and metadata ~= nil then
                for _, s in ipairs(P.slots(src, name)) do
                    if InvMetaMatches(metadata, s.metadata) then slot = s.slot break end
                end
            end
            local ok = jak:removeItem(src, name, count, nil, (slot and slot > 0) and slot or nil)
            return ok ~= false
        end

        P.setMetadata = function(src, _name, slot, metadata)
            local ok = jak:setItemMetadataInSlot(src, tonumber(slot), metadata)
            return ok ~= false
        end

        -- getInventory answers { items = { ["SLOT-4"] = { name, amount, metadata } } },
        -- so the keys are labels rather than an array — pairs, never ipairs — and the
        -- rows carry no label/weight, which the item definition has instead.
        P.inventory = function(src)
            local inv = jak:getInventory(src)
            local out = {}
            if type(inv) == "table" and type(inv.items) == "table" then
                for _, row in pairs(inv.items) do
                    if type(row) == "table" and row.name then
                        local def = jak:getStaticItem(row.name)
                        out[#out + 1] = {
                            name   = row.name,
                            label  = (type(def) == "table" and def.label) or PrettyItemName(row.name),
                            count  = tonumber(row.amount) or 1,
                            weight = type(def) == "table" and def.weight or nil,
                        }
                    end
                end
            end
            return out
        end

        P.registerUsable = function(name, cb)
            return jak:registerUsableItem(name, cb) ~= false
        end

        return P
    end,
})
