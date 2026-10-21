Config.weedTypes = {
    ['og_kush'] = {
        -- Display name of the breed
        label = 'OG Kush',

        seedItem = 'kq_weed_seed_og_kush',
        baggieItem = 'kq_weed_bag_og_kush',
        jointItem = 'kq_weed_joint_og_kush',
        brickItem = 'kq_weed_brick_og_kush',

        -- Base growth time in minutes (Excluding any multipliers, think optimal conditions, fertilizer etc.)
        -- Recommended minimum of 4 minutes
        baseGrowTime = 25, -- 1440 change to 

        -- The yield of the plant
        yield = {
            -- Amount of buds the plant should give (excluding any multipliers)
            buds = {
                item = 'kq_weed_bud_og_kush',
                min = 6,
                max = 8,
            },
            seeds = {
                -- The chances of receiving any seeds back
                chance = 50,
                -- Min/max amounts of seed once the random chance hits
                min = 1,
                max = 2,

                -- Chances of receiving a different seed after plant collection
                mutations = {
                    {
                        item = 'kq_weed_seed_purple_haze',
                        chance = 15,
                    },
                    {
                        item = 'kq_weed_seed_white_widow',
                        chance = 5,
                    },
                }
            }
        },
        -- Re-water time in minutes (How often does the plant need watering)
        -- (Players are able to add water as soon as the level drops below 50%)
        -- After this time, the plant will immediately start losing health. Treat this as the max time between watering
        -- Recommended minimum of 3 minutes
        wateringTime = 9, -- 720 change to

        -- The amount of health plants will lose per second when the soil fully dries out (max health = 100)
        -- Plants will also halt growing without any water
        dryHealthLoss = 0.83, -- (0.83) By default plants will survive for 2 minutes without any water

        -- Full growth lifespan in minutes
        -- The time players have between the plant fully growing and it dying after not being picked
        -- Recommended minimum of 4 minutes
        collectionLifespan = 45,

        -- Requires "optimal conditions" to grow
        -- Optimal conditions are defined in the config where pots are created, or by a player placed pot with a grow tent
        -- The plant will die (at +-20% of growth process) if its not grown in optimal conditions (Lockups, Grow Ops or a grow tent)
        needsConditions = false,

        growthMultipliers = {
            -- The growth speed multiplier of the plant when planted in a pot with optimal conditions
            optimalConditions = 1.2,
        },

        -- Chance of insect infestation to occur throughout the plants growth process
        insectInfestationChance = 0,
        insectDamagePerMinute = 0, -- Damage per minute. Plants will die after 5 minutes with insects

        -- Color of the leaves
        -- 0 = Green (classic) -- 1 = Light purple -- 2 = Red -- 3 = Blue -- 4 = Yellow -- 5 = Bright pink -- 6 = White -- 7 = Black/dark
        -- The following colors are more extreme and less realistic
        -- 8 = Neon Green -- 9 = Cyan/Red -- 10 = Pink -- 11 = Gold -- 12 = Cyan -- 13 = Red/pink -- 14 = Yellow/Blue -- 15 = Purple/Red
        plantColor = 0,

        -- Amount of buds needed for a brick
        -- Recommended 10 - 40 buds per brick
        budsPerBrick = 20,

        -- Amount of buds per baggie (minigame will always represent this amount as 1 bud object)
        budsPerBaggie = 1,
    },
    ['purple_haze'] = {
        -- Display name of the breed
        label = 'Purple Haze',

        seedItem = 'kq_weed_seed_purple_haze',
        baggieItem = 'kq_weed_bag_purple_haze',
        jointItem = 'kq_weed_joint_purple_haze',
        brickItem = 'kq_weed_brick_purple_haze',

        -- Base growth time in minutes (Excluding any multipliers, think optimal conditions, fertilizer etc.)
        -- Recommended minimum of 4 minutes
        baseGrowTime = 20,

        -- The yield of the plant
        yield = {
            -- Amount of buds the plant should give (excluding any multipliers)
            buds = {
                item = 'kq_weed_bud_purple_haze',
                min = 5,
                max = 6,
            },
            seeds = {
                -- The chances of receiving any seeds back
                chance = 30,
                -- Min/max amounts of seed once the random chance hits
                min = 1,
                max = 2,

                -- Chances of receiving a different seed after plant collection
                mutations = {
                    {
                        item = 'kq_weed_seed_og_kush',
                        chance = 15,
                    },
                    {
                        item = 'kq_weed_seed_white_widow',
                        chance = 15,
                    },
                    {
                        item = 'kq_weed_seed_blue_dream',
                        chance = 5,
                    },
                }
            }
        },
        -- Re-water time in minutes (How often does the plant need watering)
        -- (Players are able to add water as soon as the level drops below 50%)
        -- After this time, the plant will immediately start losing health. Treat this as the max time between watering
        -- Recommended minimum of 3 minutes
        wateringTime = 12,

        -- The amount of health plants will lose per second when the soil fully dries out (max health = 100)
        -- Plants will also halt growing without any water
        dryHealthLoss = 0.83, -- (0.83) By default plants will survive for 2 minutes without any water

        -- Full growth lifespan in minutes
        -- The time players have between the plant fully growing and it dying after not being picked
        -- Recommended minimum of 4 minutes
        collectionLifespan = 30,

        -- Requires "optimal conditions" to grow
        -- Optimal conditions are defined in the config where pots are created, or by a player placed pot with a grow tent
        -- The plant will die if its not grown in optimal conditions (Lockups, Grow Ops or a grow tent)
        needsConditions = false,

        growthMultipliers = {
            -- The growth speed multiplier of the plant when planted in a pot with optimal conditions
            optimalConditions = 1.2,
        },

        -- Chance of insect infestation to occur throughout the plants growth process
        insectInfestationChance = 0,
        insectDamagePerMinute = 0, -- Damage per minute. Plants will die after 5 minutes with insects

        -- Color of the leaves
        -- 0 = Green (classic) -- 1 = Light purple -- 2 = Red -- 3 = Blue -- 4 = Yellow -- 5 = Bright pink -- 6 = White -- 7 = Black/dark
        plantColor = 1,

        -- Amount of buds needed for a brick
        -- Recommended 10 - 40 buds per brick
        budsPerBrick = 20,

        -- Amount of buds per baggie (minigame will always represent this amount as 1 bud object)
        budsPerBaggie = 1,
    },
    ['white_widow'] = {
        -- Display name of the breed
        label = 'White widow',

        seedItem = 'kq_weed_seed_white_widow',
        baggieItem = 'kq_weed_bag_white_widow',
        jointItem = 'kq_weed_joint_white_widow',
        brickItem = 'kq_weed_brick_white_widow',

        -- Base growth time in minutes (Excluding any multipliers, think optimal conditions, fertilizer etc.)
        -- Recommended minimum of 4 minutes
        baseGrowTime = 30,

        -- The yield of the plant
        yield = {
            -- Amount of buds the plant should give (excluding any multipliers)
            buds = {
                item = 'kq_weed_bud_white_widow',
                min = 5,
                max = 6,
            },
            seeds = {
                -- The chances of receiving any seeds back
                chance = 35,
                -- Min/max amounts of seed once the random chance hits
                min = 1,
                max = 2,

                -- Chances of receiving a different seed after plant collection
                mutations = {
                    {
                        item = 'kq_weed_seed_purple_haze',
                        chance = 10,
                    }
                }
            }
        },
        -- Re-water time in minutes (How often does the plant need watering)
        -- (Players are able to add water as soon as the level drops below 50%)
        -- After this time, the plant will immediately start losing health. Treat this as the max time between watering
        -- Recommended minimum of 3 minutes
        wateringTime = 15,

        -- The amount of health plants will lose per second when the soil fully dries out (max health = 100)
        -- Plants will also halt growing without any water
        dryHealthLoss = 0.83, -- (0.83) By default plants will survive for ~2 minutes without any water

        -- Full growth lifespan in minutes
        -- The time players have between the plant fully growing and it dying after not being picked
        -- Recommended minimum of 4 minutes
        collectionLifespan = 20,

        -- Requires "optimal conditions" to grow
        -- Optimal conditions are defined in the config where pots are created, or by a player placed pot with a grow tent
        -- The plant will die if its not grown in optimal conditions (Lockups, Grow Ops or a grow tent)
        needsConditions = true,

        growthMultipliers = {
            -- The growth speed multiplier of the plant when planted in a pot with optimal conditions
            optimalConditions = 1.0,
        },

        -- Chance of insect infestation to occur throughout the plants growth process
        insectInfestationChance = 0,
        insectDamagePerMinute = 0, -- Damage per minute. Plants will die after 10 minutes with insects

        -- Color of the leaves
        -- 0 = Green (classic) -- 1 = Light purple -- 2 = Red -- 3 = Blue -- 4 = Yellow -- 5 = Bright pink -- 6 = White -- 7 = Black/dark
        -- The following colors are more extreme and less realistic
        -- 8 = Neon Green -- 9 = Cyan/Red -- 10 = Pink -- 11 = Gold -- 12 = Cyan -- 13 = Red/pink -- 14 = Yellow/Blue -- 15 = Purple/Red
        plantColor = 6,

        -- Amount of buds needed for a brick
        -- Recommended 10 - 40 buds per brick
        budsPerBrick = 20,

        -- Amount of buds per baggie (minigame will always represent this amount as 1 bud object)
        budsPerBaggie = 1,
    },
    ['blue_dream'] = {
        -- Display name of the breed
        label = 'Blue dream',

        seedItem = 'kq_weed_seed_blue_dream',
        baggieItem = 'kq_weed_bag_blue_dream',
        jointItem = 'kq_weed_joint_blue_dream',
        brickItem = 'kq_weed_brick_blue_dream',

        -- Base growth time in minutes (Excluding any multipliers, think optimal conditions, fertilizer etc.)
        -- Recommended minimum of 4 minutes
        baseGrowTime = 45,

        -- The yield of the plant
        yield = {
            -- Amount of buds the plant should give (excluding any multipliers)
            buds = {
                item = 'kq_weed_bud_blue_dream',
                min = 5,
                max = 7,
            },
            seeds = {
                -- The chances of receiving any seeds back
                chance = 35,
                -- Min/max amounts of seed once the random chance hits
                min = 1,
                max = 3,

                -- Chances of receiving a different seed after plant collection
                mutations = {
                    {
                        item = 'kq_weed_seed_white_widow',
                        chance = 15,
                    }
                }
            }
        },
        -- Re-water time in minutes (How often does the plant need watering)
        -- (Players are able to add water as soon as the level drops below 50%)
        -- After this time, the plant will immediately start losing health. Treat this as the max time between watering
        -- Recommended minimum of 3 minutes
        wateringTime = 18,

        -- The amount of health plants will lose per second when the soil fully dries out (max health = 100)
        -- Plants will also halt growing without any water
        dryHealthLoss = 0.83, -- (0.83) By default plants will survive for ~2 minutes without any water

        -- Full growth lifespan in minutes
        -- The time players have between the plant fully growing and it dying after not being picked
        -- Recommended minimum of 4 minutes
        collectionLifespan = 60,

        -- Requires "optimal conditions" to grow
        -- Optimal conditions are defined in the config where pots are created, or by a player placed pot with a grow tent
        -- The plant will die if its not grown in optimal conditions (Lockups, Grow Ops or a grow tent)
        needsConditions = true,

        growthMultipliers = {
            -- The growth speed multiplier of the plant when planted in a pot with optimal conditions
            optimalConditions = 1.0,
        },

        -- Chance of insect infestation to occur throughout the plants growth process
        insectInfestationChance = 0,
        insectDamagePerMinute = 0 -- Damage per minute. Plants will die after ~15 minutes with insects

        -- Color of the leaves
        -- 0 = Green (classic) -- 1 = Light purple -- 2 = Red -- 3 = Blue -- 4 = Yellow -- 5 = Bright pink -- 6 = White -- 7 = Black/dark
        -- The following colors are more extreme and less realistic
        -- 8 = Neon Green -- 9 = Cyan/Red -- 10 = Pink -- 11 = Gold -- 12 = Cyan -- 13 = Red/pink -- 14 = Yellow/Blue -- 15 = Purple/Red
        plantColor = 3,

        -- Amount of buds needed for a brick
        -- Recommended 10 - 40 buds per brick
        budsPerBrick = 20,

        -- Amount of buds per baggie (minigame will always represent this amount as 1 bud object)
        budsPerBaggie = 1,
    },

    -- You can add as many different strains of weed as you want
}
