Inventory = Inventory or {}

local function registerQsStash(src, stashid, slots, weight)
    exports['qs-inventory']:RegisterStash(src, stashid, slots, weight)
end

Inventory['qs-inventory'] = {
    CreateUseableItem = function(name, cb)
        exports['qs-inventory']:CreateUsableItem(name, cb)
    end,

    ClearInventory = function(sourcePlayer)
        local src = sourcePlayer.source or sourcePlayer.PlayerData.source
        exports['qs-inventory']:ClearInventory(src, Config.ExcludeItems)
    end,

    AddItem = function(src, name, amount, info)
        exports['qs-inventory']:AddItem(src, name, amount, nil, info)
    end,

    RemoveItem = function(src, name, amount)
        exports['qs-inventory']:RemoveItem(src, name, amount)
    end,

    RemoveItemBySlot = function(src, slot, amount)
        local inventory = exports['qs-inventory']:GetInventory(src)
        local item = inventory and inventory[slot]
        if not item or not item.name then return false end

        exports['qs-inventory']:RemoveItem(src, item.name, amount or 1, slot)
        return true
    end,

    GetInventory = function(source)
        return exports['qs-inventory']:GetInventory(source)
    end,

    SetItemMetadata = function(src, slot, info)
        exports['qs-inventory']:SetItemMetadata(src, slot, info)
        return true
    end,

    RegisterStash = function(src, stashid)
        registerQsStash(src, stashid, 50, 10000)
    end,

    RegisterBloodStorage = function(src, stashid)
        registerQsStash(src, stashid, 50, 10000)
    end,

    RegisterMedicalBagStash = function(src, stashid)
        local bagConfig = Config.MedicalBag or {}
        registerQsStash(src, stashid, bagConfig.stashSlots or 15, bagConfig.stashWeight or 10000)
    end
}
