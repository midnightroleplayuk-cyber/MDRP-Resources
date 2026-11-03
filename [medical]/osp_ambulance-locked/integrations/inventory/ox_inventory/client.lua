Inventory = Inventory or {}

Inventory['ox_inventory'] = {
    GetInventory = function()
        local items = {}
        local inventory = lib.callback.await('osp_ambulance:getInventory', 1000) or {}

        for _, x in pairs(inventory) do
            table.insert(items, {
                item = x.name,
                slot = x.slot,
                amount = x.count,
                info = x.metadata or {}
            })
        end

        return items
    end,

    OpenStash = function(stashid)
        TriggerServerEvent('osp_ambulance:registerStash', stashid)
        Wait(100)
        exports.ox_inventory:openInventory('stash', { id = stashid, label = 'Ambulance Stash' })
    end,

    OpenBloodStorage = function(stashid)
        TriggerServerEvent('osp_ambulance:registerBloodstorage', stashid)
        Wait(100)
        exports.ox_inventory:openInventory('stash', stashid)
    end,

    OpenMedicalBagStash = function(stashid)
        TriggerServerEvent('osp_ambulance:registerMedicalBagStash', stashid)
        Wait(100)
        local bagConfig = Config.MedicalBag or {}
        exports.ox_inventory:openInventory('stash', { id = stashid, label = bagConfig.stashLabel or 'Medical Bag' })
    end
}