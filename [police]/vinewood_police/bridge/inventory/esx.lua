-- ESX's built-in inventory (only used when ox_inventory isn't running).
VPO.Inventory._Register('esx',
    function() return VPO.Bridge.Name == 'esx' end,
    (function()
        local function x(src)
            local ESX = exports[VPO.Bridge.Resource]:getSharedObject()
            return ESX.GetPlayerFromId(src)
        end
        return {
            Count = function(src, item)
                local p = x(src); if not p then return 0 end
                local it = p.getInventoryItem(item)
                return it and it.count or 0
            end,
            Add = function(src, item, count)
                local p = x(src); if not p then return false end
                if not p.canCarryItem(item, count) then return false end
                p.addInventoryItem(item, count)
                return true
            end,
            Remove = function(src, item, count)
                local p = x(src); if not p then return false end
                local it = p.getInventoryItem(item)
                if not it or it.count < count then return false end
                p.removeInventoryItem(item, count)
                return true
            end,
            List = function(src)
                local p = x(src); if not p then return {} end
                local out = {}
                for i, it in ipairs(p.getInventory() or {}) do
                    if (it.count or 0) > 0 then out[#out + 1] = { slot = i, name = it.name, label = it.label, count = it.count } end
                end
                return out
            end,
            CanCarry = function(src, item, count)
                local p = x(src); if not p then return false end
                return p.canCarryItem(item, count) and true or false
            end,
        }
    end)())
