if Config.Inventory.inventoryScript ~= 'origen_inventory' then return end

function Fr.OpenStash(stashId, data)
    data = data or {}
    exports.origen_inventory:openInventory('stash', stashId, {
        label = data.label or stashId,
    })
end

function Fr.OpenStashDirect(stashId, data)
    Fr.OpenStash(stashId, data)
end