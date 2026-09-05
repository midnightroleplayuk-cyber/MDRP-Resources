------------------------------------------------------------------------------
-- OPEN STASH FUNCTION / this is called when user press 'e' or use target ----
------------------------------------------------------------------------------

if Config.Inventory.inventoryScript ~= "old-qb-inventory" then return end

function openStash(orgId, stashName, capacity, gangLabel)
    TriggerEvent("inventory:client:SetCurrentStash", stashName)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", stashName, { maxweight = (capacity), slots = 500 })
end

function openFurnitureStorage(stashName, capacity, slots, label)
    TriggerEvent("inventory:client:SetCurrentStash", stashName)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", stashName, { maxweight = (capacity), slots = slots })
end