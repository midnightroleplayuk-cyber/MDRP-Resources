function searchPlayerClientSide(src)
    if Config.Inventory.inventoryScript == "origen_inventory" then
        exports.origen_inventory:openInventory('player', src)
    elseif Config.Inventory.inventoryScript == "old-qb-inventory" then
        TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", src)
    end
end