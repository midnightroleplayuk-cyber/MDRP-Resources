------------------------------------------------------------------------------
-- OPEN STASH FUNCTION / this is called when user press 'e' or use target ----
------------------------------------------------------------------------------

if Config.Inventory.inventoryScript ~= "origen_inventory" then return end

function openStash(orgId, stashName, capacity, gangLabel)
    exports.origen_inventory:openInventory('stash', stashName, {
        label = gangLabel
    })
end

function openFurnitureStorage(stashName, capacity, slots, label)
    exports.origen_inventory:openInventory('stash', stashName, {
        label = label
    })
end