if Config.Inventory.inventoryScript ~= 'one_inventory' then return end

function Fr.OpenStash(stashId, data)
    TriggerServerEvent('opm:server:inventory:openStash', stashId, data or {})
end