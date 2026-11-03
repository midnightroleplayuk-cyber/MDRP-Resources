Inventory = Inventory or {}

local function openQsStash(stashid, slots, weight)
    local other = {
        maxweight = weight,
        slots = slots,
    }

    -- qs-inventory requires type "stash"; labels as the type leave the inventory locked after close
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', stashid, other)
    TriggerEvent('inventory:client:SetCurrentStash', stashid)
end

Inventory['qs-inventory'] = {
    GetInventory = function()
        local items = {}
        local inventory = lib.callback.await('osp_ambulance:getInventory', 1000) or {}

        for _, x in pairs(inventory) do
            table.insert(items, {
                item = x.name,
                slot = x.slot,
                amount = x.amount,
                info = x.info or {}
            })
        end

        return items
    end,

    OpenStash = function(stashid)
        TriggerServerEvent('osp_ambulance:registerStash', stashid)
        Wait(100)
        openQsStash(stashid, 50, 10000)
    end,

    OpenBloodStorage = function(stashid)
        TriggerServerEvent('osp_ambulance:registerBloodstorage', stashid)
        Wait(100)
        openQsStash(stashid, 50, 10000)
    end,

    OpenMedicalBagStash = function(stashid)
        TriggerServerEvent('osp_ambulance:registerMedicalBagStash', stashid)
        Wait(100)
        local bagConfig = Config.MedicalBag or {}
        openQsStash(stashid, bagConfig.stashSlots or 15, bagConfig.stashWeight or 10000)
    end
}
