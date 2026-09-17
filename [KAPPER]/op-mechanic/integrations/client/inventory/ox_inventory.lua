if Config.Inventory.inventoryScript ~= 'ox_inventory' then return end

function Fr.OpenStash(stashId, _data)
    exports.ox_inventory:openInventory('stash', stashId)
end

function Fr.OpenStashDirect(stashId, _data)
    exports.ox_inventory:openInventory('stash', stashId)
end