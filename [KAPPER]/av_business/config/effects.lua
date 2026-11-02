Config = Config or {}
-- Is important to say that effects are linked to INGREDIENTS but if none of the product ingredients triggers an effect.. 
-- the script will trigger one of the defaulteffects table based on the item type (drink, food, alcohol, etc...)

Config.DefaultEffects = { -- If the item doesn't have ingredients or the ingredients don't trigger any effect we will use this based on the item type
    ['drink'] = function()
        exports['av_laptop']:addMetadata("thirst", 50) -- adds 50 points to thirst
    end,
    ['food'] = function()
        exports['av_laptop']:addMetadata("hunger", 50) -- adds 50 points to hunger
    end,
    ['alcohol'] = function()
        alcohol(30) -- Trigger an alcohol effect for 30 seconds)
    end,
    ['joint'] = function()
        drugs(30)-- Trigger a drug effect for 30 seconds
    end,
}

Config.Effects = {
    ['drink'] = { -- index key should be unique
        label = "+25 Thirst", -- label for admin panel
        effect = function() -- function to trigger (client side only)
            exports['av_laptop']:addMetadata("thirst", 25)
        end
    },
    ['eat'] = { -- index key should be unique
        label = "-25 Hunger", -- label for admin panel
        effect = function() -- function to trigger (client side only)
            exports['av_laptop']:addMetadata("hunger", 25)
        end
    },
    ['drunk'] = { -- index key should be unique
        label = "Alcohol (30 seconds)", -- label for admin panel
        effect = function() -- function to trigger (client side only)
            alcohol(30)
        end
    },
    ['drugs'] = { -- index key should be unique
        label = "Drugs (30 seconds)", -- label for admin panel
        effect = function() -- function to trigger (client side only)
            drugs(30)
        end
    },
}
