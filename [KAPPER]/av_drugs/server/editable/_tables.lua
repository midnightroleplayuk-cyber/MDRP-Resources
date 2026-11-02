--[[

    IMPORTANT!!!, All values used for every table are random, added for testing... make sure to read and edit everything to fit your server...
    IMPORTANT!!!, All values used for every table are random, added for testing... make sure to read and edit everything to fit your server...
    IMPORTANT!!!, All values used for every table are random, added for testing... make sure to read and edit everything to fit your server...
]]--

Config = Config or {}

lib.callback.register('av_drugs:getTableInfo', function(source, name, identifier)
    if isCooking[identifier] then
        TriggerClientEvent('av_laptop:notification',source,Lang['table_title'],Lang['isCooking'],'inform')
        return false 
    end
    return Config.Tables and Config.Tables[name] or false
end)

Config.Tables = { -- items used to place tables for cooking
    ['moonshine_still'] = { -- item name and key index that needs to match with config/tables.lua > Config.Tables
        drug = "moonshine", -- Drug linked to this table, should exist in server/editable/_drugs.lua too
        model = `prop_still`, -- model to spawn
        slots = 5, -- stash slots
        weight = 5000, -- stash weight
        ingredients = { -- needed ingredients for cooking (['itemName'] = amount needed)
            ['water'] = 4, -- needs 4x water
            ['burger'] = 4, -- needs 4x burger
        },
        products = { -- finished product, make sure it fits the stash weight and slots
            {name = "moonshine", min = 3, max = 5}, -- it will give item moonshine a min of 3 and max 5
        },
        cookingXP = {min = 3, max = 5}, -- XP received for every successful cook / every 100XP is 1 level
        cookingTime = 30, -- in minutes, time for completing a cook
        cooldownTime = 60, -- in minutes, after every cook the table enters in cooldown
        particles = { -- particles used for object when is cooking, smoke by default or false (particles = false)
            dict = "core",
            asset = "ent_amb_smoke_scrap",
            offset = {x = 0.0, y = 0.0, z = 0.5},
        }
    },
    ['fentanyl_table'] = { -- item name and key index that needs to match with config/tables.lua > Config.Tables
        drug = "fentanyl", -- Drug linked to this table, should exist in server/editable/_drugs.lua too
        model = `v_ret_ml_tableb`, -- model to spawn
        slots = 5, -- stash slots
        weight = 5000, -- stash weight
        ingredients = { -- needed ingredients for cooking (['itemName'] = amount needed)
            ['water'] = 4, -- needs 4x water
            ['burger'] = 4, -- needs 4x burger
            
        },
        products = { -- finished product, make sure it fits the stash weight and slots
            {name = "fentanyl_batch", min = 1, max = 2}, -- it will give item moonshine a min of 3 and max 5
        },
        cookingXP = {min = 3, max = 5}, -- XP received for every successful cook / every 100XP is 1 level
        cookingTime = 30, -- in minutes, time for completing a cook
        cooldownTime = 60, -- in minutes, after every cook the table enters in cooldown
        particles = { -- particles used for object when is cooking, smoke by default or false (particles = false)
            dict = "core",
            asset = "ent_amb_smoke_scrap",
            offset = {x = 0.0, y = 0.0, z = 0.5},
        }
    },
    ['heroin_table'] = { -- item name and key index that needs to match with config/tables.lua > Config.Tables
        drug = "heroin", -- Drug linked to this table, should exist in server/editable/_drugs.lua too
        model = `v_ret_ml_tablea`, -- model to spawn
        slots = 5, -- stash slots
        weight = 5000, -- stash weight
        ingredients = { -- needed ingredients for cooking (['itemName'] = amount needed)
            ['water'] = 4, -- needs 4x water
            ['burger'] = 4, -- needs 4x burger
            
        },
        products = { -- finished product, make sure it fits the stash weight and slots
            {name = "heroin_batch", min = 1, max = 2}, -- it will give item moonshine a min of 3 and max 5
        },
        cookingXP = {min = 3, max = 5}, -- XP received for every successful cook / every 100XP is 1 level
        cookingTime = 30, -- in minutes, time for completing a cook
        cooldownTime = 60, -- in minutes, after every cook the table enters in cooldown
        particles = { -- particles used for object when is cooking, smoke by default or false (particles = false)
            dict = "core",
            asset = "ent_amb_smoke_scrap",
            offset = {x = 0.0, y = 0.0, z = 0.5},
        }
    },
    ['ketamine_table'] = { -- item name and key index that needs to match with config/tables.lua > Config.Tables
        drug = "ketamine", -- Drug linked to this table, should exist in server/editable/_drugs.lua too
        model = `v_ret_ml_tablec`, -- model to spawn
        slots = 5, -- stash slots
        weight = 5000, -- stash weight
        ingredients = { -- needed ingredients for cooking (['itemName'] = amount needed)
            ['water'] = 4, -- needs 4x water
            ['burger'] = 4, -- needs 4x burger
            
        },
        products = { -- finished product, make sure it fits the stash weight and slots
            {name = "ketamine_batch", min = 1, max = 2}, -- it will give item moonshine a min of 3 and max 5
        },
        cookingXP = {min = 3, max = 5}, -- XP received for every successful cook / every 100XP is 1 level
        cookingTime = 30, -- in minutes, time for completing a cook
        cooldownTime = 60, -- in minutes, after every cook the table enters in cooldown
        particles = { -- particles used for object when is cooking, smoke by default or false (particles = false)
            dict = "core",
            asset = "ent_amb_smoke_scrap",
            offset = {x = 0.0, y = 0.0, z = 0.5},
        }
    },
}