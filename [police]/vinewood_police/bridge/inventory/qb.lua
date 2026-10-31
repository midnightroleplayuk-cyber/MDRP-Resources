-- qb-inventory 2.x (exports). Older qb-inventory isn't supported.
VPO.Inventory._Register('qb',
    function() return GetResourceState('qb-inventory') == 'started' end,
    {
        Count = function(src, item)
            local ok, n = pcall(function() return exports['qb-inventory']:GetItemCount(src, item) end)
            if ok and n then return n end
            return exports['qb-inventory']:HasItem(src, item, 1) and 1 or 0
        end,
        Add = function(src, item, count, metadata)
            return exports['qb-inventory']:AddItem(src, item, count, false, metadata, 'vinewood_police') and true or false
        end,
        Remove = function(src, item, count, _, slot)
            return exports['qb-inventory']:RemoveItem(src, item, count, slot or false, 'vinewood_police') and true or false
        end,
        CanCarry = function(src, item, count)
            return exports['qb-inventory']:CanAddItem(src, item, count) and true or false
        end,
        List = function(src)
            local QBCore = exports['qb-core']:GetCoreObject()
            local p = QBCore.Functions.GetPlayer(src)
            local out = {}
            for _, it in pairs(p and p.PlayerData.items or {}) do
                out[#out + 1] = { slot = it.slot, name = it.name, label = it.label or it.name, count = it.amount or it.count or 1, metadata = it.info }
            end
            table.sort(out, function(a, b) return (a.slot or 0) < (b.slot or 0) end)
            return out
        end,
        ForceOpen = function(officer, target)
            exports['qb-inventory']:OpenInventoryById(officer, target)
            return true
        end,
    })
