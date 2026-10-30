-- bridge/inventory/qb — qb-core's OWN item storage (no qb-inventory resource, or a
-- QBox server whose inventory is the core's).
--
-- Unlike ESX, qb-core has slots and an `info` table per slot, so metadata is
-- native and no overlay is needed. The player's `PlayerData.items` IS the store,
-- which is why every primitive below reads it directly instead of going through an
-- export — there is no inventory resource here to export anything.
--
-- Lowest priority alongside the ESX driver: qb-inventory / ps / lj / qs / ox all
-- outrank it, which is the correct outcome on a server that runs one.
RegisterInventoryDriver({
    name     = "qb-core",
    priority = 20,
    metadata = true,
    ok       = function() return QBCore ~= nil end,
    build = function()
        local function player(src) return QBCore.Functions.GetPlayer(tonumber(src)) end

        local P = {}

        P.items = function() return InvFrameworkItems() or {} end

        P.exists = function(name)
            return QBCore.Shared.Items[tostring(name):lower()] ~= nil
        end

        -- EVERY slot holding this item, not just the first. Anything shipped
        -- `stack = false` (the meal / bag / takeout box) sits one per slot, so
        -- reading a single slot's amount reports 1 however many the player carries
        -- — which reads as "the add did nothing" to callers that compare counts
        -- either side of an AddItem (see giveVessel).
        P.count = function(src, name)
            local xPlayer = player(src); if not xPlayer then return 0 end
            local items = xPlayer.Functions.GetItemsByName and xPlayer.Functions.GetItemsByName(name)
            if type(items) == "table" then
                local n = 0
                for _, it in pairs(items) do n = n + (it.amount or it.count or 0) end
                return n
            end
            local item = xPlayer.Functions.GetItemByName(name)
            return (item and (item.amount or item.count)) or 0
        end

        P.slots = function(src, name)
            local xPlayer = player(src); if not xPlayer then return {} end
            local out = {}
            for slot, item in pairs((xPlayer.PlayerData and xPlayer.PlayerData.items) or {}) do
                if item and item.name == name then
                    out[#out + 1] = { slot = item.slot or slot, count = item.amount or 1, metadata = item.info }
                end
            end
            return out
        end

        P.inventory = function(src)
            local xPlayer = player(src); if not xPlayer then return {} end
            local out = {}
            for _, item in pairs((xPlayer.PlayerData and xPlayer.PlayerData.items) or {}) do
                if item then
                    out[#out + 1] = { name = item.name, label = item.label,
                                      count = item.amount, weight = item.weight }
                end
            end
            return out
        end

        -- Be defensive: GetTotalWeight can return nil, the item may be unknown, and
        -- an item can lack a weight field. Any missing piece → assume it fits (the
        -- real AddItem still enforces capacity) rather than erroring out the caller
        -- — a whole order fulfilment — on an arithmetic-on-nil.
        P.canCarry = function(src, name, count)
            local xPlayer = player(src); if not xPlayer or not xPlayer.PlayerData then return nil end
            local ok, weight = pcall(QBCore.Player.GetTotalWeight, xPlayer.PlayerData.items)
            if not ok or type(weight) ~= "number" then return true end
            local item = QBCore.Shared.Items[tostring(name):lower()]
            if not item or type(item.weight) ~= "number" then return true end
            local max = QBCore.Config and QBCore.Config.Player and QBCore.Config.Player.MaxWeight
            if type(max) ~= "number" then return true end
            return (weight + (item.weight * count)) <= max
        end

        P.add = function(src, name, count, metadata)
            local xPlayer = player(src); if not xPlayer then return false end
            return xPlayer.Functions.AddItem(name, count, nil, metadata) ~= false
        end

        -- qb's RemoveItem takes a SLOT, never a metadata filter, so an exact
        -- variation is removed by finding its slot first — otherwise a plain
        -- burger could be spent to fill an order for a loaded one.
        P.remove = function(src, name, count, metadata, slot)
            local xPlayer = player(src); if not xPlayer then return false end
            slot = tonumber(slot)
            if (not slot or slot <= 0) and metadata ~= nil then
                for _, s in ipairs(P.slots(src, name)) do
                    if InvMetaMatches(metadata, s.metadata) then slot = s.slot break end
                end
            end
            return xPlayer.Functions.RemoveItem(name, count, (slot and slot > 0) and slot or nil) ~= false
        end

        -- Rewrite ONE slot's metadata in place (a Restaurant Bag losing the item the
        -- customer just ate) so the bag keeps its slot instead of being re-added.
        P.setMetadata = function(src, _name, slot, metadata)
            local xPlayer = player(src); if not xPlayer then return false end
            local items = xPlayer.PlayerData and xPlayer.PlayerData.items
            local it = items and items[tonumber(slot)]
            if not it then return false end
            it.info = metadata
            xPlayer.Functions.SetInventory(items)
            return true
        end

        return P
    end,
})
