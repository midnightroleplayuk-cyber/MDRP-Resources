-- bridge/inventory/esx — es_extended's OWN inventory (no dedicated inventory
-- resource installed).
--
-- THE REASON THE METADATA OVERLAY EXISTS. ESX stores an item as a name and a
-- number: there are no slots and there is nowhere to put a build stack. Every
-- vessel this resource makes is one item whose whole identity is its metadata, so
-- on bare ESX a Restaurant Bag used to come back out of a pocket as an empty
-- generic bag and a boxed soup as an anonymous takeout box. `metadata = false`
-- hands that problem to bridge/inventory/metadata, which keeps one row per
-- metadata-bearing unit and reconciles it against ESX's count on every read — so
-- the primitives below can stay exactly as simple as ESX itself is.
--
-- Lowest priority alongside the qb-core driver: any real inventory resource on the
-- server is a better answer than this one, and will be chosen over it.
RegisterInventoryDriver({
    name     = "es_extended",
    resource = "es_extended",
    priority = 20,
    metadata = false,
    ok       = function() return ESX ~= nil end,
    build = function()
        local function player(src) return ESX.GetPlayerFromId(tonumber(src)) end

        return {
            -- The framework IS the catalogue here — there is no inventory resource
            -- to ask — so this is exactly the shared fallback every other driver
            -- lands on (ESX's live registry, then the `items` table). One source of
            -- truth: a catalogue that was empty at boot fills itself in, because
            -- core re-calls RefreshItems on every client sync request.
            items = function() return InvFrameworkItems() or {} end,

            count = function(src, name)
                local xPlayer = player(src); if not xPlayer then return 0 end
                local item = xPlayer.getInventoryItem(name)
                return (item and item.count) or 0
            end,

            canCarry = function(src, name, count)
                local xPlayer = player(src); if not xPlayer then return nil end
                if Config.InventoryLimit then
                    local item = xPlayer.getInventoryItem(name)
                    if not item or type(item.limit) ~= "number" then return true end
                    return item.limit >= (item.count or 0) + count
                end
                return xPlayer.canCarryItem(name, count)
            end,

            inventory = function(src)
                local xPlayer = player(src); if not xPlayer then return {} end
                local out = {}
                for _, item in ipairs(xPlayer.getInventory() or {}) do
                    if item then
                        out[#out + 1] = { name = item.name, label = item.label,
                                          count = item.count, weight = item.weight }
                    end
                end
                return out
            end,

            -- Metadata is accepted and ignored HERE on purpose: the overlay wrapped
            -- around this driver has already taken it, and ESX has nowhere to put it.
            add = function(src, name, count)
                local xPlayer = player(src); if not xPlayer then return false end
                xPlayer.addInventoryItem(name, count)
                return true
            end,

            remove = function(src, name, count)
                local xPlayer = player(src); if not xPlayer then return false end
                xPlayer.removeInventoryItem(name, count)
                return true
            end,

            -- ESX is the one framework where a weapon is NOT an item, so these
            -- can't fall through to the item primitives above.
            addWeapon = function(src, name)
                local xPlayer = player(src); if not xPlayer then return false end
                xPlayer.addWeapon(name, 0)
                return true
            end,

            removeWeapon = function(src, name)
                local xPlayer = player(src); if not xPlayer then return false end
                xPlayer.removeWeapon(name, 0)
                return true
            end,

            hasWeapon = function(src, name)
                local xPlayer = player(src); if not xPlayer then return false end
                return xPlayer.hasWeapon(name)
            end,
        }
    end,
})
