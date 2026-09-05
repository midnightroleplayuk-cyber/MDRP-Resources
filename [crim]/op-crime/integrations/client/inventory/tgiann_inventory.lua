------------------------------------------------------------------------------
-- OPEN STASH FUNCTION / this is called when user press 'e' or use target ----
------------------------------------------------------------------------------

if Config.Inventory.inventoryScript ~= "tgiann_inventory" then return end

function openStash(orgId, stashName, capacity, gangLabel)
    TriggerServerEvent('op-crime:openTgiannStash')
end

function openFurnitureStorage(stashName, capacity, slots, label)
    TriggerServerEvent('op-crime:openTgiannStash_furniture', stashName, capacity, slots, label)
end