VPO.Inventory._Register('ox',
    function() return GetResourceState('ox_inventory') == 'started' end,
    {
        Count = function(src, item, metadata) return exports.ox_inventory:Search(src, 'count', item, metadata) or 0 end,
        Add = function(src, item, count, metadata)
            local ok = exports.ox_inventory:AddItem(src, item, count, metadata)
            return ok and true or false
        end,
        Remove = function(src, item, count, metadata, slot)
            -- strict = false: match on the fields given (e.g. serial) rather than the whole metadata table
            return exports.ox_inventory:RemoveItem(src, item, count, metadata, slot, nil, false) and true or false
        end,
        CanCarry = function(src, item, count, metadata)
            return exports.ox_inventory:CanCarryItem(src, item, count, metadata) and true or false
        end,
        List = function(src)
            local out = {}
            for _, it in pairs(exports.ox_inventory:GetInventoryItems(src) or {}) do
                out[#out + 1] = { slot = it.slot, name = it.name, label = it.label or it.name, count = it.count, metadata = it.metadata }
            end
            table.sort(out, function(a, b) return a.slot < b.slot end)
            return out
        end,
        ForceOpen = function(officer, target)
            exports.ox_inventory:forceOpenInventory(officer, 'player', target)
            return true
        end,
        -- Police-only stashes (property bags)
        MoveToStash = function(src, stashId, label, keep)
            local groups = {}
            for job in pairs(Config.Jobs) do groups[job] = 0 end
            exports.ox_inventory:RegisterStash(stashId, label, 50, 200000, false, groups)
            local moved = {}
            for _, it in pairs(exports.ox_inventory:GetInventoryItems(src) or {}) do
                if not VPO.Util.Contains(keep, it.name) then
                    if exports.ox_inventory:RemoveItem(src, it.name, it.count, it.metadata, it.slot) then
                        if exports.ox_inventory:AddItem(stashId, it.name, it.count, it.metadata) then
                            moved[#moved + 1] = { name = it.name, label = it.label or it.name, count = it.count }
                        else
                            exports.ox_inventory:AddItem(src, it.name, it.count, it.metadata) -- bag full: give it back
                        end
                    end
                end
            end
            return moved
        end,
        ReturnFromStash = function(stashId, src)
            local groups = {}
            for job in pairs(Config.Jobs) do groups[job] = 0 end
            exports.ox_inventory:RegisterStash(stashId, 'Property', 50, 200000, false, groups)
            local returned, left = {}, 0
            for _, it in pairs(exports.ox_inventory:GetInventoryItems(stashId) or {}) do
                if exports.ox_inventory:CanCarryItem(src, it.name, it.count, it.metadata)
                    and exports.ox_inventory:RemoveItem(stashId, it.name, it.count, it.metadata, it.slot) then
                    exports.ox_inventory:AddItem(src, it.name, it.count, it.metadata)
                    returned[#returned + 1] = { name = it.name, label = it.label or it.name, count = it.count }
                else
                    left = left + 1
                end
            end
            return returned, left
        end,
        OpenStash = function(officer, stashId, label)
            local groups = {}
            for job in pairs(Config.Jobs) do groups[job] = 0 end
            exports.ox_inventory:RegisterStash(stashId, label or 'Property', 50, 200000, false, groups)
            exports.ox_inventory:forceOpenInventory(officer, 'stash', stashId)
        end,
    })
