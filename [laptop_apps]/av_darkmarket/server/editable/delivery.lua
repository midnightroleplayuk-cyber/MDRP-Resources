CreateThread(function()
    -- prevents from people dropping items into stash
    local Inventory = exports['av_laptop']:getInventory()
    if Inventory and (Inventory == "ox_inventory" or Inventory == "origen_inventory") then
        exports[Inventory]:registerHook('swapItems', function(payload)
            local to = payload['toInventory']
            if to and string.find(to, "dark_market") then
                return false
            end
            return true
        end)
    else
        exports["av_laptop"]:addRestricted("dark_market")
    end
end)

lib.callback.register('av_darkmarket:getIdentifier', function(source)
    return exports['av_laptop']:getIdentifier(source)
end)