------------------------------------------------------------------------------
-- OPEN STASH FUNCTION / this is called when user press 'e' or use target ----
------------------------------------------------------------------------------

if Config.Inventory.inventoryScript ~= "ox_inventory" then return end

function openStash(orgId, stashName, capacity, gangLabel)
    exports.ox_inventory:openInventory('stash', stashName)
end

function openFurnitureStorage(stashName, capacity, slots, label)
    exports.ox_inventory:openInventory('stash', stashName)
end