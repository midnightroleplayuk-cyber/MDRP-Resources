-- Just in case you want to add a prefix to the item naem
-- if isNew = true then you should NOT modify the item name
function getItemName(playerId, job, type, isNew, name)
    return name
end

function itemRegistered(job, name, label, type, image, description, weight, ingredients, prop, price, cashier)
    -- This function is called when a new item is registered. You can use it to perform additional actions or integrations.
    -- Adds the item to an internal cooldown, can't be crafter until next restart, most inventories can't handle new items being added on the fly, so this is a safe way to prevent issues. 
    -- You can remove this line if your inventory supports it.
    cooldownItems[name] = true
end