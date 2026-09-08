Config = {}

-- Enabling this will add additional prints and display of the resource within the pot
Config.debug = false

Config.locale = 'en'

-- Whether or not to lock vehicles which have loot inside them
Config.lockVehicles = true

-- Police job names in Config.policeAlerts.policeJobs
Config.minimumPoliceOnline = 0

Config.lootingMinigame = {
    -- When disabled a normal kq_link progress bar will be used instead of the minigame
    enabled = true,

    -- Whether to use the skipping function of the minigame. Players can let go of the keybind when in the green zone to finish it.
    allowSkipping = true,
}

Config.windowSmash = {
    -- Whether to enable the built-in window smash system
    enabled = true,

    types = {
        melee = {
            -- Whether to use a minigame when smashing a window using your fists
            minigame = {
                enabled = true,
                difficulty = 4,
            },
            -- Damage inflicted to the player after smashing the window
            damageAmount = 5,
        },
        weapon = {
            -- Whether to use a minigame when smashing a window using any weapon
            minigame = {
                enabled = true,
                difficulty = 2,
            },
            -- Damage inflicted to the player after smashing the window
            damageAmount = 0,
        },
    }
}


Config.policeAlerts = {
    enabled = true,

    -- Max distance at which the npc's will be able to see and come over to report the smoke
    maxDistance = 50.0,

    -- Chance between 0 and 100
    chancePerPed = 100,

    -- Peds standing nearby the vehicle may also attack the player when they loot a vehicle
    combatEnabled = true,

    -- Jobs which will get notified about the van
    policeJobs = {
        'police',
        'lspd',
        'bcso',
    },

    -- List of possible titles for the dispatch message
    dispatchTitles = {
        'Car robbery',
        'Smash and grab!',
        'Car burglary',
    },
    -- List of possible messages for the dispatch message
    dispatchMessages = {
        'Someone just smashed a window and stole something!',
        'They just stole a bag from a parked car!',
        'Some car just got robbed, they smashed the window!',
        'Someone just smashed this cars window and robbed it',
    },

    -- Blip options for the dispatch
    blip = {
        sprite = 380,
        color = 1,
        scale = 1.5,
        text = 'Smash \'n grab',
        flash = true,
    },
}


-- Base odds of loot spawning inside a parked npc vehicle by class given in percentage (0-100) (can use decimal values)
Config.odds = {
    [0] = 20,    -- Compacts
    [1] = 30,   -- Sedans
    [2] = 30, -- SUVs
    [3] = 13,    -- Coupes
    [4] = 15,    -- Muscle
    [5] = 25, -- Sports Classics
    [6] = 30,   -- Sports
    [7] = 50,   -- Super
    [8] = 0,    -- Motorcycles
    [9] = 20,   -- Off-road
    [10] = 0,   -- Industrial
    [11] = 0,   -- Utility
    [12] = 5,   -- Vans
    [13] = 0,   -- Cycles
    [14] = 0,   -- Boats
    [15] = 0,   -- Helicopters
    [16] = 0,   -- Planes
    [17] = 0,   -- Service
    [18] = 0,   -- Emergency
    [19] = 0,   -- Military
    [20] = 0,   -- Commercial
    [21] = 0,   -- Trains
}

Config.lootTypes = {
    ['electronics'] = {
        difficulty = 4,
        duration = 8,

        -- Chance of the loot being empty (not giving anything)
        emptyChance = 25,
        items = {
            -- You can also attach item metadata by defining 'metadata' on the item (table)
            { item = 'laptop', min = 1, max = 1 },
            { item = 'phone', min = 1, max = 2 },
            { item = 'stolen_bag', min = 1, max = 1 },
        },
        money = {
            chance = 30,
            amount = {
                min = 100,
                max = 250,
            }
        },
        models = {
            {
                model = 'prop_michael_backpack',
                offset = vec3(0.0, -0.05, 0.05),
            },
            {
                model = 'bkr_prop_duffel_bag_01a',
                offset = vec3(0.0, -0.05, 0.1),
            },
        },
    },
    ['clothes'] = {
        difficulty = 2,
        duration = 6,

        -- Chance of the loot being empty (not giving anything)
        emptyChance = 25,
        items = {
            { item = 'expensive_sneakers', min = 1, max = 1 },
            { item = 'expensive_bag', min = 1, max = 1 },
        },
        models = {
            {
                model = 'prop_cs_cardbox_01',
                offset = vector3(0.0, 0.01, 0.05),
            },
            {
                model = 'prop_cs_box_clothes',
                offset = vector3(0.0, 0.03, 0.0),
            },
            {
                model = 'prop_nigel_bag_pickup',
                offset = vector3(0.0, -0.05, 0.05),
            },
        },
    },
    ['drugs'] = {
        difficulty = 4,
        duration = 10,

        -- Chance of the loot being empty (not giving anything)
        emptyChance = 0,
        items = {
            { item = 'cannabis', min = 1, max = 5 },
        },
        models = {
            {
                model = 'prop_drug_package',
                offset = vec3(0.0, 0.02, 0.03),
            },
        },
    },
    ['weapons'] = {
        difficulty = 6,
        duration = 12,

        -- Chance of the loot being empty (not giving anything)
        emptyChance = 50,
        items = {
            { item = 'stolen_weapon_case', min = 1, max = 1 },
        },
        models = {
            {
                model = 'prop_box_guncase_02a',
                offset = vec3(0.0, 0.0, 0.0),
            },
        },
    },
    ['cash'] = {
        difficulty = 2,
        duration = 6,

        -- Chance of the loot being empty (not giving anything)
        emptyChance = 30,
        money = {
            chance = 80,
            amount = {
                min = 100,
                max = 500,
            }
        },
        models = {
            {
                model = 'prop_stat_pack_01',
                offset = vector3(0.0, -0.06, 0.06),
            },
            {
                model = 'prop_cs_heist_bag_02',
                offset = vector3(0.0, -0.05, 0.1),
            },
            {
                model = 'bkr_prop_biker_case_shut',
                offset = vector3(0.0, -0.12, 0.05),
            },
        },
    },
    ['big_loot'] = {
        difficulty = 5,
        duration = 13,

        -- Chance of the loot being empty (not giving anything)
        emptyChance = 25,
        items = {
            { item = 'cement', min = 2, max = 4 },
            { item = 'copper', min = 2, max = 4 },
        },
        money = {
            chance = 30,
            amount = {
                min = 100,
                max = 250,
            }
        },
        models = {
            {
                model = 'prop_tool_box_01',
                offset = vec3(0.0, 0.1, 0.05),
            },
            {
                model = 'imp_prop_impexp_boxwood_01',
                offset = vec3(0.0, 0.1, 0.05),
                rotation = vec3(0, 0, 90)
            },
            {
                model = 'xm_prop_vancrate_01a',
                offset = vec3(0.0, 0.0, 0.28),
            },
            {
                model = 'prop_rub_boxpile_05',
                offset = vec3(0.0, 0.6, 0.29),
                rotation = vec3(0, 0, 90)
            },
        },
    },
}


-- The types are defined above in Config.lootTypes !
-- Do not enter item names here!

Config.loot = {
    -- Loot which can be found everywhere on the map
    global = {
        'electronics',
        'clothes',
    },
    -- Additional loot which can be found in specific vehicle classes
    class = {
        -- Super cars
        [7] = {
            'cash',
        }
    },
    -- Additional loot which can be found in specific game areas
    areas = {
        ['hood'] = {
            coords = vec3(270.0, -1870.0, 26.0),
            radius = 600.0,
            types = {
                'drugs',
                'weapons',
            }
        },
        ['rich'] = {
            coords = vec3(-713.0, -224.0, 36.0),
            radius = 800.0,
            types = {
                'cash',
            }
        },
    },

    -- Overwrite to loot per vehicle model. Vehicle models listed below will not use loot from the global, area or class pools
    modelOverwrite = {
        {
            models = {
                'sandking',
                'sandking2',
                'bison',
                'rebel',
                'rebel2',
            },
            types = {
                'big_loot',
            },
        },
    },
}

Config.lootableItems = {
    ['stolen_weapon_case'] = {
        duration = 3000,
        model = 'prop_box_guncase_02a',
        items = {
            { item = 'weapon_pistol', min = 1, max = 1 },
            { item = 'weapon_snspistol', min = 1, max = 1 },
        },
    },
    ['stolen_bag'] = {
        duration = 3000,
        model = 'bkr_prop_duffel_bag_01a',
        items = {
            { item = 'laptop', min = 1, max = 1 },
            { item = 'phone', min = 1, max = 1 },
        },
    },
}
