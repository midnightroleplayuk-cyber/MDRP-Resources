-- bridge/inventory/ox_inventory — the reference driver.
--
-- ox is the one inventory whose metadata model matches ours exactly: metadata is a
-- table on a SLOT, `Search(src, "slots", item)` hands back every slot holding an
-- item with its metadata attached, and `SetMetadata` rewrites one in place. So
-- everything below is a direct call — no candidate-name probing, no overlay.
--
-- Item USE on ox is not registered here: ox calls the export named in the item
-- definition (`server.export = 'pickle_restaurants.useItem'`), which modules/consume
-- publishes. That is why `registerUsable` is absent rather than a no-op — an absent
-- primitive is a truthful "this inventory does it another way".
RegisterInventoryDriver({
    name     = "ox_inventory",
    resource = "ox_inventory",
    priority = 100,
    metadata = true,
    build = function()
        local ox = exports.ox_inventory
        return {
            items = function()
                local base = InventoryImageBase()
                local out = {}
                for item, data in pairs(ox:Items() or {}) do
                    out[item] = { label = data.label, image = InvImageUrl(base, item, data.image) }
                end
                return out
            end,

            -- Live, so an item registered after we booted is still recognised.
            exists = function(name) return ox:Items(name) ~= nil end,

            count    = function(src, name) return ox:GetItemCount(src, name) or 0 end,
            canCarry = function(src, name, count) return ox:CanCarryItem(src, name, count) end,

            inventory = function(src)
                local out = {}
                for _, item in pairs(ox:GetInventoryItems(src) or {}) do
                    out[#out + 1] = { name = item.name, label = item.label, count = item.count, weight = item.weight }
                end
                return out
            end,

            add = function(src, name, count, metadata)
                local ok = ox:AddItem(src, name, count, metadata)
                return ok ~= false
            end,

            -- ox takes the metadata AND the slot as removal filters, so both of our
            -- removal shapes (by variation, by exact slot) are native here.
            remove = function(src, name, count, metadata, slot)
                local ok = ox:RemoveItem(src, name, count, metadata, tonumber(slot))
                return ok ~= false
            end,

            slots = function(src, name)
                local out = {}
                for _, s in ipairs(ox:Search(src, "slots", name) or {}) do
                    out[#out + 1] = { slot = s.slot, count = s.count or 1, metadata = s.metadata }
                end
                return out
            end,

            setMetadata = function(src, _name, slot, metadata)
                ox:SetMetadata(src, tonumber(slot), metadata)
                return true
            end,
        }
    end,
})
