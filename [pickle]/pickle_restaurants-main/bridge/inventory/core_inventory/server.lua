-- bridge/inventory/core_inventory — core_inventory.
--
-- The odd one out, and the reason the driver layer takes PRIMITIVES rather than
-- export names: core_inventory is not addressed by a player at all. Every call
-- names an INVENTORY — a string id, which for a player's pockets is
-- `"content-" .. identifier` — so the source has to be translated on the way in,
-- and none of the qb-shaped machinery applies.
--
-- Its exports are lowercase-first (`addItem`, `removeItem`, `getInventory`) and
-- take metadata as a first-class argument, so per-slot variations are native and
-- no overlay is needed.
--
-- THIS IS THE LEAST-VERIFIED ADAPTER IN THE FOLDER. core_inventory has no public
-- API reference to check against, so the export names below are candidate lists
-- rather than certainties — if yours differs, add its name to the list beside the
-- primitive that's misbehaving and nothing else in the resource needs touching.
-- The `INVENTORY_PREFIX` is likewise the one value a fork is likely to change.
local RES = "core_inventory"
local INVENTORY_PREFIX = "content-"

-- source → the inventory id core_inventory knows those pockets by.
local function invId(src)
    local id = GetIdentifier and GetIdentifier(tonumber(src))
    if not id then return nil end
    return INVENTORY_PREFIX .. id
end

RegisterInventoryDriver({
    name     = RES,
    resource = RES,
    priority = 70,
    metadata = true,
    build = function()
        local P = {}

        P.items = function()
            local base = InventoryImageBase()
            local ok, list = InvExportAny(RES, "items", { "getItemsList", "getItems", "GetItemList", "Items" })
            local out = {}
            if ok and type(list) == "table" then
                for k, data in pairs(list) do
                    local name = (type(data) == "table" and data.name) or (type(k) == "string" and k)
                    if name then
                        out[name] = {
                            label = (type(data) == "table" and data.label) or PrettyItemName(name),
                            image = InvImageUrl(base, name, type(data) == "table" and data.image or nil),
                        }
                    end
                end
            end
            if next(out) ~= nil then return out end
            return InvFrameworkItems() or {}
        end

        P.slots = function(src, name)
            local inv = invId(src); if not inv then return {} end
            local ok, rows = InvExportAny(RES, "inventory", { "getInventory" }, inv)
            local out = {}
            if ok and type(rows) == "table" then
                for _, row in pairs(rows) do
                    local s = InvNormalizeSlot(row)
                    if s and s.name == name then
                        out[#out + 1] = { slot = s.slot, count = s.count, metadata = s.metadata }
                    end
                end
            end
            return out
        end

        P.count = function(src, name)
            local inv = invId(src); if not inv then return 0 end
            local ok, n = InvExportAny(RES, "count", { "getItemCount", "getItemsCount" }, inv, name)
            if ok and tonumber(n) then return tonumber(n) end
            local total = 0
            for _, s in ipairs(P.slots(src, name)) do total = total + (s.count or 1) end
            return total
        end

        P.inventory = function(src)
            local inv = invId(src); if not inv then return {} end
            local ok, rows = InvExportAny(RES, "inventory", { "getInventory" }, inv)
            local out = {}
            if ok and type(rows) == "table" then
                for _, row in pairs(rows) do
                    local s = InvNormalizeSlot(row)
                    if s and s.name then
                        out[#out + 1] = { name = s.name, label = s.label, count = s.count, weight = s.weight }
                    end
                end
            end
            return out
        end

        P.add = function(src, name, count, metadata)
            local inv = invId(src); if not inv then return false end
            local ok, ret = InvExportAny(RES, "add", { "addItem", "AddItem" }, inv, name, count, metadata)
            return ok and ret ~= false
        end

        P.remove = function(src, name, count, metadata, slot)
            local inv = invId(src); if not inv then return false end
            -- Metadata IS the removal filter here, so an exact variation needs no
            -- slot lookup. A slot is only used to recover the metadata to filter by.
            if metadata == nil and slot and tonumber(slot) and tonumber(slot) > 0 then
                for _, s in ipairs(P.slots(src, name)) do
                    if s.slot == tonumber(slot) then metadata = s.metadata break end
                end
            end
            local ok, ret = InvExportAny(RES, "remove", { "removeItem", "RemoveItem" }, inv, name, count, metadata)
            return ok and ret ~= false
        end

        P.setMetadata = function(src, _name, slot, metadata)
            local inv = invId(src); if not inv then return false end
            local ok, ret = InvExportAny(RES, "setMetadata",
                { "setMetadata", "updateMetadata", "setItemMetadata" }, inv, slot, metadata)
            return ok and ret ~= false
        end

        P.canCarry = function(src, name, count)
            local inv = invId(src); if not inv then return nil end
            local ok, ret = InvExportAny(RES, "canCarry", { "canCarryItem", "canCarry" }, inv, name, count)
            if not ok then return nil end
            return ret ~= false
        end

        P.registerUsable = function(name, cb)
            return (InvExportAny(RES, "usable", { "usableItem", "createUsableItem" }, name, cb))
        end

        return P
    end,
})
