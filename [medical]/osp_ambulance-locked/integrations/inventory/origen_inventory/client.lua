Inventory = Inventory or {}

Inventory['origen_inventory'] = {
    GetInventory = function()
        return {}
    end,

    OpenStash = function(stashid)
        exports.origen_inventory:openInventory('stash', stashid, {
            label = 'Ambulance Stash'
        })
    end,

    OpenBloodStorage = function(stashid)
        exports.origen_inventory:openInventory('stash', stashid, {
            label = 'Blood Storage'
        })
    end
}