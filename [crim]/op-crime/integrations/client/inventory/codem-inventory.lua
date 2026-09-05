------------------------------------------------------------------------------
-- OPEN STASH FUNCTION / this is called when user press 'e' or use target ----
------------------------------------------------------------------------------

if Config.Inventory.inventoryScript ~= "codem-inventory" then return end

while Framework == nil do Wait(5) end

function openStash(orgId, stashName, capacity, gangLabel)
    Fr.TriggerServerCallback('op-crime:codem:getStashCapacity', function(cap)
        print('Server returned stash capacity:', cap)
        TriggerServerEvent('codem-inventory:server:openstash', stashName, 150, cap, gangLabel)
    end, orgId)
end

function openFurnitureStorage(stashName, capacity, slots, label)
    TriggerServerEvent('codem-inventory:server:openstash', stashName, slots, capacity, label)
end