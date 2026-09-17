Inventory = Inventory or {}

Inventory['inventory'] = {
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
        TriggerEvent('inventory:openStorage', 'Locker', stashid, 20, 2000, { 'ambulance' })
    end,

    OpenBloodStorage = function(stashid)
        TriggerEvent('inventory:openStorage', 'Locker', stashid, 20, 2000, { 'ambulance' })
    end
}