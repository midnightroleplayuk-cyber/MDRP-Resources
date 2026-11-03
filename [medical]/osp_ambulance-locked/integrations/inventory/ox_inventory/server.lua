Inventory = Inventory or {}

Inventory['ox_inventory'] = {
    CreateUseableItem = function(name, cb)
        if GetActiveFramework() == 'qb' then
            QBCreateUseableItem(name, cb)
        else
            ESX.RegisterUsableItem(name, cb)
        end
    end,

    ClearInventory = function(sourcePlayer)
        local src = sourcePlayer.source or sourcePlayer.PlayerData.source
        exports.ox_inventory:ClearInventory(src, Config.ExcludeItems)
    end,

    AddItem = function(src, name, amount, info)
        exports.ox_inventory:AddItem(src, name, amount, info)
    end,

    RemoveItem = function(src, name, amount)
        exports.ox_inventory:RemoveItem(src, name, amount)
    end,

    RemoveItemBySlot = function(src, slot, amount)
        local inventoryItems = exports.ox_inventory:GetInventoryItems(src)
        if not inventoryItems then return false end

        for _, item in pairs(inventoryItems) do
            if item.slot == slot then
                return exports.ox_inventory:RemoveItem(src, item.name, amount or 1, nil, slot)
            end
        end

        return false
    end,

    GetInventory = function(source)
        return exports.ox_inventory:GetInventoryItems(source)
    end,

    SetItemMetadata = function(src, slot, info)
        local inventoryItems = exports.ox_inventory:GetInventoryItems(src)
        if not inventoryItems then return false end

        local item
        for _, inventoryItem in pairs(inventoryItems) do
            if inventoryItem.slot == slot then
                item = inventoryItem
                break
            end
        end

        if not item then return false end

        local itemMeta = item.metadata or {}

        for key, value in pairs(info) do
            itemMeta[key] = value
        end

        exports.ox_inventory:SetMetadata(src, item.slot, itemMeta)

        return true
    end,

    RegisterStash = function(src, stashid)
        exports.ox_inventory:RegisterStash(stashid, 'Ambulance Stash', 20, 20000, true)
    end,

    RegisterBloodStorage = function(src, stashid)
        exports.ox_inventory:RegisterStash(stashid, 'Blood Storage', 20, 20000, true)
    end,

    RegisterMedicalBagStash = function(src, stashid)
        local bagConfig = Config.MedicalBag or {}
        exports.ox_inventory:RegisterStash(
            stashid,
            bagConfig.stashLabel or 'Medical Bag',
            bagConfig.stashSlots or 15,
            bagConfig.stashWeight or 10000,
            true
        )
    end
}