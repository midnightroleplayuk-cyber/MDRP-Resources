Config = {}
    
-- Tables configuration
-- Only use this when you want to spawn crafting tables through this script
-- You can also spawn tables through your own scripts if preferred, check docs
Config.Tables = {  
    { 
        coords = vec4(3629.7241, 5683.1719, 7.8236, 343.4010), 
        -- tableUid = "spices", 
        recipeUids = { "craft1", "craft2", "craft3" },
        snapToGround = true,
    }, 
    -- You can add more tables with different locations and recipes
}

-- Function to add XP to players after crafting
Config.AddXP = function(source, xp)
    -- Add XP to player
    if Shared.DEVHUB_SKILLTREE_ENABLED then 
        -- Server side example
        exports['devhub_skillTree']:addXp('personal', xp, source)
    end
end

-- Server Functions (Hooks)
-- These functions are called at various points during the crafting process.
-- You can use them to add custom logic like logging, notifications, webhooks, etc.

-- Called when a player successfully finishes crafting
-- @param source: player server id
-- @param tableId: recipe table uid (e.g. "spices")
-- @param tableRecipe: multi-recipe uid or nil for single recipes
-- @param itemsRemoved: table { [itemName] = amount } of items taken from the player
-- @param itemsAdded: table { [itemName] = amount } of items given to the player
Config.OnCraftingFinished = function(source, tableId, tableRecipe, itemsRemoved, itemsAdded)
    -- Example: print to console
    -- print(("[CraftingTable] Player %d crafted recipe '%s'"):format(source, tableRecipe or tableId))
    
    -- Example: Discord webhook
    -- PerformHttpRequest("https://discord.com/api/webhooks/...", function() end, "POST",
    --     json.encode({ content = ("Player %d crafted %s"):format(source, tableRecipe or tableId) }),
    --     { ["Content-Type"] = "application/json" })
end

-- Called when a player starts the crafting process (opens the table and begins)
-- @param source: player server id
-- @param tableId: recipe table uid
-- @param tableRecipe: multi-recipe uid or nil
Config.OnCraftingStarted = function(source, tableId, tableRecipe)
    -- Example:
    -- print(("[CraftingTable] Player %d started crafting '%s'"):format(source, tableRecipe or tableId))
end

-- Called when crafting fails (e.g. player missing items at final server-side check)
-- @param source: player server id
-- @param tableId: recipe table uid
-- @param tableRecipe: multi-recipe uid or nil
-- @param reason: string describing why crafting failed
Config.OnCraftingFailed = function(source, tableId, tableRecipe, reason)
    -- Example:
    -- print(("[CraftingTable] Player %d failed to craft '%s': %s"):format(source, tableRecipe or tableId, reason))
end