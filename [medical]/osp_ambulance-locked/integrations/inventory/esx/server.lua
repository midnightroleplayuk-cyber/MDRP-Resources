Inventory = Inventory or {}

Inventory['esx'] = {
    CreateUseableItem = function(name, cb)
        ESX.RegisterUsableItem(name, cb)
    end,

    ClearInventory = function(sourcePlayer)
        for i = 1, #sourcePlayer.inventory, 1 do
            if sourcePlayer.inventory[i].count > 0 then
                local excluded = false

                for _, itemName in pairs(Config.ExcludeItems) do
                    if itemName == sourcePlayer.inventory[i].name then
                        excluded = true
                        break
                    end
                end

                if not excluded then
                    sourcePlayer.setInventoryItem(sourcePlayer.inventory[i].name, 0)
                end
            end
        end
    end,

    AddItem = function(src, name, amount, info)
        local sourcePlayer = GetPlayer(src)
        sourcePlayer.addInventoryItem(name, amount)
    end,

    RemoveItem = function(src, name, amount)
        local sourcePlayer = GetPlayer(src)
        sourcePlayer.removeInventoryItem(name, amount)
    end,

    GetInventory = function(source)
        local sourcePlayer = GetPlayer(source)
        return sourcePlayer.getInventory()
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