Inventory = Inventory or {}

Inventory['origen_inventory'] = {
    CreateUseableItem = function(name, cb)
        if GetActiveFramework() == 'qb' then
            QBCreateUseableItem(name, cb)
        else
            ESX.RegisterUsableItem(name, cb)
        end
    end,

    ClearInventory = function(sourcePlayer)
        local src = sourcePlayer.source or sourcePlayer.PlayerData.source
        exports.origen_inventory:ClearInventory(src, Config.ExcludeItems)
    end,

    AddItem = function(src, name, amount, info)
        exports.origen_inventory:addItem(src, name, amount, info)
    end,

    RemoveItem = function(src, name, amount)
        exports.origen_inventory:removeItem(src, name, amount)
    end,

    GetInventory = function(source)
        return {}
    end,

    SetItemMetadata = function(src, slot, info)
        return false
    end,

    RegisterStash = function(src, stashid)
        exports.origen_inventory:registerStash(stashid, {
            label = 'Ambulance Locker',
            slots = 20,
            weight = 20000
        })
    end,

    RegisterBloodStorage = function(src, stashid)
        exports.origen_inventory:registerStash(stashid, {
            label = 'Blood Storage',
            slots = 20,
            weight = 20000
        })
    end
}