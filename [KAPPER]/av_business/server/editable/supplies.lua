CreateThread(function()
    local Inventory = exports['av_laptop']:getInventory()
    if Inventory and Inventory == "ox_inventory" then
        exports.ox_inventory:registerHook('swapItems', function(payload)
            local to = payload['toInventory']
            if to and string.find(to, Config.SuppliesStash['prefix']) then
                return false
            end
            return true
        end)
    end
end)