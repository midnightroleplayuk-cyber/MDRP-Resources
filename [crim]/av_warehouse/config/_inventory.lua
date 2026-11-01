-- Your inventory isn't listed here? no worries, we will use the Framework functions :)
Config = Config or {}
Config.Inventory = false

CreateThread(function()
    if GetResourceState("ox_inventory") ~= "missing" then
        Config.Inventory = "ox_inventory"
        return
    end
    if GetResourceState("qb-inventory") ~= "missing" then
        Config.Inventory = "qb-inventory"
        return
    end
    if GetResourceState("qs-inventory") ~= "missing" then
        Config.Inventory = "qs-inventory"
        return
    end
    if GetResourceState("tgiann-inventory") ~= "missing" then
        Config.Inventory = "tgiann-inventory"
        return
    end
    dbug("Inventory?:", Config.Inventory)
end)