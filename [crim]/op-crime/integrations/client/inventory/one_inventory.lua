------------------------------------------------------------------------------
-- OPEN STASH FUNCTION / this is called when user press 'e' or use target ----
------------------------------------------------------------------------------

if Config.Inventory.inventoryScript ~= "one_inventory" then return end

function openStash(orgId, stashName, capacity, gangLabel)
    TriggerServerEvent('op-crime:openOneStash')
end

function openFurnitureStorage(stashName, capacity, slots, label)
    TriggerServerEvent('op-crime:openOneStash_furniture', stashName, capacity, slots, label)
end