Inventory = Inventory or {}

Inventory['codem-inventory'] = {
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
        return false
    end,

    OpenBloodStorage = function(stashid)
        return false
    end
}