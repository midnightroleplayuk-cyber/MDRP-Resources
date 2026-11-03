Inventory = Inventory or {}

Inventory['qb-inventory'] = {
    CreateUseableItem = function(name, cb)
        QBCreateUseableItem(name, cb)
    end,

    ClearInventory = function(sourcePlayer)
        exports['qb-inventory']:ClearInventory(sourcePlayer.PlayerData.source, Config.ExcludeItems)
        MySQL.update('UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode({}), sourcePlayer.PlayerData.citizenid })
    end,

    AddItem = function(src, name, amount, info)
        exports['qb-inventory']:AddItem(src, name, amount, false, info or {}, 'ambulancejob')
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[name], 'add')
    end,

    RemoveItem = function(src, name, amount)
        exports['qb-inventory']:RemoveItem(src, name, amount, false, 'ambulancejob')
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[name], 'remove')
    end,

    RemoveItemBySlot = function(src, slot, amount)
        local sourcePlayer = GetPlayer(src)
        if not sourcePlayer then return false end

        local inventoryItems = sourcePlayer.PlayerData.items
        local item = inventoryItems[slot]
        if not item then return false end

        exports['qb-inventory']:RemoveItem(src, item.name, amount or 1, slot, 'ambulancejob')
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'remove')
        return true
    end,

    GetInventory = function(source)
        local sourcePlayer = GetPlayer(source)
        if not sourcePlayer then return {} end

        local items = sourcePlayer.PlayerData.items
        if type(items) == 'table' then
            return items
        end

        return {}
    end,

    SetItemMetadata = function(src, slot, info)
        local sourcePlayer = GetPlayer(src)
        local inventoryItems = sourcePlayer.PlayerData.items
        local newItem = inventoryItems[slot]

        if not newItem then return false end

        newItem.info = newItem.info or {}

        for key, value in pairs(info) do
            newItem.info[key] = value
        end

        inventoryItems[slot] = newItem
        sourcePlayer.Functions.SetPlayerData('items', inventoryItems)

        return true
    end,

    RegisterStash = function(src, stashid)
        local data = { label = 'Ambulance Stash', maxweight = 40000, slots = 50 }
        exports['qb-inventory']:OpenInventory(src, stashid, data)
    end,

    RegisterBloodStorage = function(src, stashid)
        local data = { label = 'Blood Storage', maxweight = 40000, slots = 50 }
        exports['qb-inventory']:OpenInventory(src, stashid, data)
    end,

    RegisterMedicalBagStash = function(src, stashid)
        local bagConfig = Config.MedicalBag or {}
        local data = {
            label = bagConfig.stashLabel or 'Medical Bag',
            maxweight = bagConfig.stashWeight or 10000,
            slots = bagConfig.stashSlots or 15,
        }
        exports['qb-inventory']:OpenInventory(src, stashid, data)
    end
}