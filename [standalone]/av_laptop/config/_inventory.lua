Config = Config or {}
Config.Inventory = false -- DONT MODIFY THIS DONT MODIFY THIS DONT MODIFY THIS
Config.OldQBInventory = false -- true if you are using old qb-inventory (check the fxmanifest.lua, version should be 1.x)
Config.InventoryPath = {
    ['qb-inventory'] = "qb-inventory/html/images/",
    ['lj-inventory'] = "lj-inventory/html/images/",
    ['ox_inventory'] = "ox_inventory/web/images/",
    ['qs-inventory'] = "qs-inventory/html/images/",
    ['ps-inventory'] = "ps-inventory/html/images/",
    ['origen_inventory'] = "origen_inventory/html/images/",
    ['codem-inventory'] = "codem-inventory/html/itemimages/",
    ['tgiann-inventory'] = "inventory_images/images/",
    ['jaksam_inventory'] = "jaksam_inventory/_images/",
}

CreateThread(function()
    if Config.Inventory then return end
    if GetResourceState("jaksam_inventory") ~= "missing" then
        Config.Inventory = "jaksam_inventory"
        return
    end
    if GetResourceState("origen_inventory") ~= "missing" then
        Config.Inventory = "origen_inventory"
        return
    end
    if GetResourceState("ox_inventory") ~= "missing" then
        Config.Inventory = "ox_inventory"
        return
    end
    if GetResourceState("qb-inventory") ~= "missing" then
        Config.Inventory = "qb-inventory"
        return
    end
    if GetResourceState("lj-inventory") ~= "missing" then
        Config.Inventory = "lj-inventory"
        return
    end
    if GetResourceState("ps-inventory") ~= "missing" then
        Config.Inventory = "ps-inventory"
        return
    end
    if GetResourceState("qs-inventory") ~= "missing" then
        Config.Inventory = "qs-inventory"
        return
    end
    if GetResourceState("codem-inventory") ~= "missing" then
        Config.Inventory = "codem-inventory"
        return
    end
    if GetResourceState("tgiann-inventory") ~= "missing" then
        Config.Inventory = "tgiann-inventory"
        return
    end
    if not Config.Inventory then
        print("^1[ERROR] ^3We couldn't find a compatible inventory, this resource will just stop working...^7")
        print("^1[ERROR] ^3We couldn't find a compatible inventory, this resource will just stop working...^7")
        print("^1[ERROR] ^3We couldn't find a compatible inventory, this resource will just stop working...^7")
        print("^1[ERROR] ^3We couldn't find a compatible inventory, this resource will just stop working...^7")
        print("^1[ERROR] ^3We couldn't find a compatible inventory, this resource will just stop working...^7")
    end
end)

exports("getInventoryPath", function()
    return Config.InventoryPath[Config.Inventory]
end)