Inventory = Inventory or {}

Inventory['tgiann-inventory'] = {
    CreateUseableItem = function(name, cb)
        if GetActiveFramework() == 'qb' then
            QBCreateUseableItem(name, cb)
        else
            ESX.RegisterUsableItem(name, cb)
        end
    end,

    ClearInventory = function(sourcePlayer)
        local src = sourcePlayer.source or sourcePlayer.PlayerData.source
        exports['tgiann-inventory']:ClearInventory(src, Config.ExcludeItems)
    end,

    AddItem = function(src, name, amount, info)
        exports['tgiann-inventory']:AddItem(src, name, amount, nil, info)
    end,

    RemoveItem = function(src, name, amount)
        exports['tgiann-inventory']:RemoveItem(src, name, amount)
    end,

    GetInventory = function(source)
        return exports['tgiann-inventory']:GetPlayerItems(source)
    end,

    SetItemMetadata = function(src, slot, info)
        local item = exports['tgiann-inventory']:GetItemBySlot(src, slot)

        if not item then return false end

        local itemMeta = item.metadata or {}
        itemMeta.durability = info.quality

        exports['tgiann-inventory']:SetItemData(src, item, slot, itemMeta)

        return true
    end,

    RegisterStash = function(src, stashid)
        exports['tgiann-inventory']:RegisterStash(stashid, 'Ambulance Stash', 20, 20000, true)
    end,

    RegisterBloodStorage = function(src, stashid)
        return false
    end
}