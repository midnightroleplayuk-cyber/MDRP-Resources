Inventory = Inventory or {}

Inventory['qb-inventory'] = {
    GetInventory = function()
        local items = {}
        local inventory

        if QBCore then
            local playerData = QBCore.Functions.GetPlayerData()
            if playerData and type(playerData.items) == 'table' then
                inventory = playerData.items
            end
        end

        inventory = inventory or lib.callback.await('osp_ambulance:getInventory', 1000) or {}

        for _, x in pairs(inventory) do
            if x and x.name then
                table.insert(items, {
                    item = x.name,
                    slot = x.slot,
                    amount = x.amount,
                    info = x.info or {}
                })
            end
        end

        return items
    end,

    OpenStash = function(stashid)
        TriggerServerEvent('osp_ambulance:registerStash', stashid)
    end,

    OpenBloodStorage = function(stashid)
        TriggerServerEvent('osp_ambulance:registerBloodstorage', stashid)
    end,

    OpenMedicalBagStash = function(stashid)
        TriggerServerEvent('osp_ambulance:registerMedicalBagStash', stashid)
    end
}