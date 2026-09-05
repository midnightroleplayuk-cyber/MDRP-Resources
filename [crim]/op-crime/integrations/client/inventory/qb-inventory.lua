------------------------------------------------------------------------------
-- OPEN STASH FUNCTION / this is called when user press 'e' or use target ----
------------------------------------------------------------------------------

if Config.Inventory.inventoryScript ~= "qb-inventory" then return end

function openStash(orgId, stashName, capacity, gangLabel)
    TriggerServerEvent('op-crime:openQBStash')
end

function openFurnitureStorage(stashName, capacity, slots, label)
    TriggerServerEvent('op-crime:openQBStash_furniture', stashName, capacity, slots, label)
end