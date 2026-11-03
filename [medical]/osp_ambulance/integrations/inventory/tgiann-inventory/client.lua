Inventory = Inventory or {}

Inventory['tgiann-inventory'] = {
    GetInventory = function()
        local items = {}
        local inventory = lib.callback.await('osp_ambulance:getInventory', 1000) or {}

        for _, x in pairs(inventory) do
            table.insert(items, {
                item = x.name,
                slot = x.slot,
                amount = x.amount,
                info = x.metadata or {}
            })
        end

        return items
    end,

    OpenStash = function(stashid)
        TriggerServerEvent('osp_ambulance:registerStash', stashid)
        Wait(100)
        exports['tgiann-inventory']:OpenInventory('stash', stashid)
    end,

    OpenBloodStorage = function(stashid)
        TriggerServerEvent('osp_ambulance:registerBloodstorage', stashid)
        Wait(100)
        exports["tgiann-inventory"]:OpenInventory('stash', stashid)
    end,

    OpenMedicalBagStash = function(stashid)
        TriggerServerEvent('osp_ambulance:registerMedicalBagStash', stashid)
        Wait(100)
        local bagConfig = Config.MedicalBag or {}
        exports["tgiann-inventory"]:OpenInventory('stash', { id = stashid, label = bagConfig.stashLabel or 'Medical Bag' })
    end
}