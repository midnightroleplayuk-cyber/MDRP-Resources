Inventory = Inventory or {}

Inventory['inventory'] = {
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
        exports.inventory:AddItemToPlayer(src, name, amount)
    end,

    RemoveItem = function(src, name, amount)
        exports.inventory:RemoveItemFromPlayer(src, name, amount)
    end,

    GetInventory = function(source)
        local sourcePlayer = GetPlayer(source)
        return exports.inventory:getInventory(sourcePlayer)
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