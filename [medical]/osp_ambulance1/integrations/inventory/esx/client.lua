Inventory = Inventory or {}

Inventory['esx'] = {
    GetInventory = function()
        local items = {}
        local inventory = lib.callback.await('osp_ambulance:getInventory', 1000) or {}

        for _, x in pairs(inventory) do
            if x.count > 0 then
                table.insert(items, { item = x.name, amount = x.count })
            end
        end

        return items
    end,

    OpenStash = function(stashid)
        return false
    end,

    OpenBloodStorage = function(stashid)
        return false
    end,

    OpenMedicalBagStash = function(stashid)
        return false
    end
}