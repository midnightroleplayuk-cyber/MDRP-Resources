Shared = {}

-- Debug configuration
Shared.Debug = {
    Enabled = false,    -- Set to false to disable all debug prints
    Levels = {
        Info = true,    -- General information
        Success = true, -- Success operations
        Warning = true  -- Warning and potential issues
    }
}

Shared.Trucks = {
    [`stockade`] = {
        model = "stockade",
        backOffset = { 0.0, -4.0, 0.0 },
        bombOffset = {
            { bone = "door_dside_r", offset={ 0.7, -0.03, -0.4, 0.0, -10.0, 0.0 } },
        },
        explosionOffset = {0.0, -2.5, 1.5},
        props = {
            { model = "prop_cs_heist_bag_01", offset = { 1.0, -2.0, 1.2, -10.0, -20.0, 90.0 } },
            { model = "prop_cs_heist_bag_01", offset = { -1.0, -2.0, 1.2, -30.0, -20.0, 90.0 } },
            { model = "prop_cash_crate_01", offset = { 0.4, -3.0, 0.45, 0.0, 0.0, 0.0 } },
            { model = "prop_cash_crate_01", offset = { -0.4, -3.0, 0.45, 0.0, 0.0, 0.0 } },
            { model = "ch_prop_diamond_trolly_01b", offset = { -0.4, -1.9, 0.9, 0.0, 0.0, -90.0} },
            { model = "ch_prop_gold_trolly_01b", offset = { 0.4, -1.9, 0.9, 0.0, 0.0, 90.0} },
        },
        rewards = {
            { item = "money", min = 5000, max = 15000, chance = 100 },
            { item = "goldbar", min = 1, max = 3, chance = 75 },
            { item = "diamond", min = 1, max = 2, chance = 50 },
        },
        rewardsMin = 2,
        rewardsMax = 5,
    }
}
Shared.HackingItems = {
    ["enigma"] = { itemName = "water", amount = 1 },
    ["bruteforce"] = { itemName = "water", amount = 1 },
}
Shared.BombItem = { itemName = "water", amount = 1 }
Shared.JammerItem = { itemName = "water", amount = 1 }


Shared.StartRequirements = {
    -- Item example:
    { name = "water", amount = 1, consume = true },
    -- Custom handler example:
    -- {
    --     label = "Crew Membership",
    --     icon = "fas fa-users",
    --     check = function(source)
    --         return true
    --     end,
    --     action = function(source)
    --         -- runs once the mission actually starts
    --     end,
    -- },
}


Shared.PedSettings = {
    enabled = true,
    peds = {
        {
            model = "ig_lestercrest",
            coords = vec4(2461.8679, 1574.7773, 33.1126, 3.3354),
            blip = {
                enabled = false,
                sprite = 1,
                color = 2,
                scale = 0.8,
                label = "Truck Robbery NPC",
            },
        },
        -- Add more peds here:
        -- {
        --     model = "ig_lestercrest",
        --     coords = vec4(0.0, 0.0, 0.0, 0.0),
        --     blip = {
        --         enabled = false,
        --         sprite = 1,
        --         color = 2,
        --         scale = 0.8,
        --         label = "Truck Robbery NPC",
        --     },
        -- },
    },
}
Shared.LaptopConfig = {
    enabled = true,
    traderId = 'trader_3',
    name = 'Truck Robbery',
    smallDescription = 'Intercept and rob heavily guarded armored trucks.',
    description = 'Join the queue and wait for your turn. Track the truck, hack its systems, set up a jammer at the destination, eliminate guards, and crack open the secured cargo.',
    bannerImage = 'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/truckRobbery/taskImage.webp',
    images = {
        'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/truckRobbery/img1.webp',
        'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/truckRobbery/img2.webp',
    },
    link = "https://store.devhub.gg",
    rewards = {
        items = {
            { name = 'weapon_pistol', quantity = 1 },
        },
        money = 1000,
        crimePoints = 500,
        xp = 250,
    },
    tasks = {
        ['uid_1'] = {
            name = 'Join the queue',
            description = 'Join the queue and wait for your turn.',
            icon = 'fas fa-sign-in-alt',
            order = 1,
        },
        ['uid_2'] = {
            name = 'Receive GPS location',
            description = 'You will receive a GPS marker showing where the truck will start its route.',
            icon = 'fas fa-map-marker-alt',
            order = 2,
        },
        ['uid_3'] = {
            name = 'Hack the truck',
            description = 'Drive close to the truck and start hacking. Not too close or they will detect you!',
            icon = 'fas fa-laptop-code',
            order = 3,
        },
        ['uid_4'] = {
            name = 'Get final destination',
            description = 'After successfully hacking the truck, you will receive the final destination coordinates.',
            icon = 'fas fa-route',
            order = 4,
        },
        ['uid_5'] = {
            name = 'Activate the jammer',
            description = 'Go to the destination and activate the jammer using your tablet.',
            icon = 'fas fa-broadcast-tower',
            order = 5,
        },
        ['uid_6'] = {
            name = 'Wait for the truck',
            description = 'Wait for the truck to arrive at the final destination.',
            icon = 'fas fa-truck',
            order = 6,
        },
        ['uid_7'] = {
            name = 'Eliminate the guards',
            description = 'Take down the guards protecting the truck.',
            icon = 'fas fa-user-shield',
            order = 7,
        },
        ['uid_8'] = {
            name = 'Open the rear doors',
            description = 'Open the back doors of the truck. You may need special items (Bomb, Blue Pendrive, or Red Pendrive).',
            icon = 'fas fa-door-open',
            order = 8,
        },
    }
}
