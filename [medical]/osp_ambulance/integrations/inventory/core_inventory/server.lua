Inventory = Inventory or {}

Inventory['core_inventory'] = {
    CreateUseableItem = function(name, cb)
        if GetActiveFramework() == 'qb' then
            QBCreateUseableItem(name, cb)
        else
            ESX.RegisterUsableItem(name, cb)
        end
    end,

    ClearInventory = function(sourcePlayer)
        return false
    end,

    AddItem = function(src, name, amount, info)
        return false
    end,

    RemoveItem = function(src, name, amount)
        return false
    end,

    GetInventory = function(source)
        local inventory = exports['core_inventory']:getInventory(source)
        return inventory and inventory.content or {}
    end,

    SetItemMetadata = function(src, slot, info)
        return false
    end,

    RegisterStash = function(src, stashid)
        return false
    end,

    RegisterBloodStorage = function(src, stashid)
        return false
    end
}