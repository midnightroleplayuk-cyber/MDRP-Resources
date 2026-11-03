Inventory = Inventory or {}

Inventory['codem-inventory'] = {
    CreateUseableItem = function(name, cb)
        if GetActiveFramework() == 'qb' then
            QBCreateUseableItem(name, cb)
        else
            ESX.RegisterUsableItem(name, cb)
        end
    end,

    ClearInventory = function(sourcePlayer)
        local src = sourcePlayer.source or sourcePlayer.PlayerData.source
        exports['codem-inventory']:ClearInventory(src, Config.ExcludeItems)
    end,

    AddItem = function(src, name, amount, info)
        exports['codem-inventory']:AddItem(src, name, amount, nil, info)
    end,

    RemoveItem = function(src, name, amount)
        exports['codem-inventory']:RemoveItem(src, name, amount)
    end,

    GetInventory = function(source)
        local sourcePlayer = GetPlayer(source)
        return exports['codem-inventory']:GetInventory(GetActiveFramework() == 'esx' and sourcePlayer or sourcePlayer.PlayerData.citizenid, source)
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