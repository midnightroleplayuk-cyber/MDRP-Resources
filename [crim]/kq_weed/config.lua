Config = {}

-- Enabling this will add additional prints and debug visuals
Config.debug = false
--
Config.locale = 'en'

Config.sql = {
    driver = 'oxmysql', -- oxmysql or ghmattimysql or mysql
    -- If you're using an older version of oxmysql set this to false
    newOxMysql = true,
}

-- Plant saving system
-- If you use short grow times (sub 10 minutes), we recommend turning this off, as it shouldn't be necessary and will save on some performance
Config.saving = {
    -- Whether to save and load the plant state
    enabled = true,

    -- Systems: 'sql', 'kvp'
    system = 'sql',

    -- Saving interval in seconds (The save also occurs when a plant gets planted, collected or dies)
    -- Recommended 180 (3min) - 1800 (30min)
    interval = 600, -- default = 600 (10min)

    -- Delete plants data from the database which have not been updated for more than X days
    -- Specified in days
    deletePlantsOlderThan = 7,
}

-- Whether the pot should be deleted after the weed is collected
Config.removePotAfterCollection = false

Config.items = {
    emptyBaggie = 'kq_weed_bag_empty',
    rollingPaper = 'kq_weed_paper',

    weedPot = 'kq_weed_pot',
    weedTable = 'kq_weed_table',
    weedPress = 'kq_weed_press',

    weedTent = 'kq_weed_tent',
    wateringSystem = 'kq_weed_watering_system',

    pesticideSpray = 'kq_weed_pesticide_spray',
}

-- Various miscellaneous options
Config.misc = {
    -- Whether players should always be able to destroy the plants. When disabled, players may only destroy them once the plants die
    alwaysAllowPlantDestroy = true,

    -- Whether the lockup/growop doors should be closed automatically after few seconds of inactivity
    autoCloseDoors = true,

    -- Whether players should be able to look around with the Grow Op security camera
    allowSecurityCameraMovement = true,

    -- Whether the the pesticide spray should be consumed after usage. It will be required regardless
    consumePesticideSprayItem = true,

    -- Whether to display plant status in a UI box when standing near it
    showPlantStatusUI = false,
    -- Font used for the plant HUD
    hudFontId = 4,
    -- The general scale of the HUD
    hudScale = 1.0,

    -- Max bud count displayed in the collection minigame (Plants will still yield more if configured so. This only limits the minigame bud amount)
    collectionMaxBudCount = 12,

    -- Whether the weather should be set to CLEAR when inside a grow op. Disable sync calls also get made
    setWeatherInGrowops = false,

    -- Type of the mini-game interaction indication
    -- 'default' (Native FiveM outline) (Problematic for QuantV users but by far the best looking)
    -- 'box' (Custom outline drawn around the entity bounds)
    -- 'glow' (Glow effect on hovered entities)
    -- 'none'
    interactionIndicator = 'default',

    blips = {
        growop = {
            enabled = false,

            label = 'Weed Grow-op',
            sprite = 496,
            color = 62,
            alpha = 255,
            scale = 0.9,
        },
        lockup = {
            enabled = true,

            label = 'Weed Lockup',
            sprite = 496,
            color = 39,
            alpha = 255,
            scale = 0.7,
        },
    },

    -- The time between player ability refresh (server -> client)
    -- Used to limit/allow client sided interactions.
    -- Time in ms
    abilityRefreshInterval = 60000,
}

-- Watering minigame options
Config.watering = {
    -- General speed of water application to the soil
    -- (5 - 50)
    wateringSpeed = 17,

    -- Water brush size (max radius applied at once)
    -- Larger = quicker watering, Lower = slower watering
    -- (3 - 16)
    brushSize = 7,

    -- Require the player to have an item in order to water plants
    requiredItem = {
        -- Whether the required item check is enabled
        enabled = true,

        -- The item the player must have to water
        itemName = 'watering_can',

        -- Whether to consume one of the item on each watering
        consume = true,
    },
}

Config.placing = {
    checks = {
        -- Whether to only allow the placement of objects in routing buckets which are not `0`.
        -- This prevents players from placing the objects when not in a housing or other system utilizing routing buckets
        onlyInNonDefaultRoutingBucket = false,

        -- Whether to disallow placement on/near roads
        disallowPlacementNearRoads = true,

        -- Disallow players from placing more than a specified amount of objects
        limits = {
            -- Whether to enable the limits
            enabled = true,

            maxPots = 64,
            maxTables = 8,
            maxPresses = 8,
        },

        housing = {
            -- Whether to enable a housing check. This will allow placement of objects, only when inside a house.
            enabled = false,

            -- Available systems:
            -- nolag_properties
            -- origen_housing
            -- bcs_housing
            -- qs-housing
            -- vms_housing
            -- sn_properties
            -- loaf_housing
            -- rtx_housing

            -- If your system is not on the list. Chances are that the RoutingBucket detection will be sufficient.
            -- We still recommend implementing a housing integration if you know how to.
            -- Many popular systems are not pre-configured by us, as they lack the necessary exports/states or don't have any docs.
            system = 'nolag_properties',
        },

        -- You may also restrict the placement of objects to specific areas.
        -- When used with a housing check, it'll allow placement in houses as well as within the defined areas
        -- If you want greater customization, check the `IsAllowedToPlace` function in server/editable/editable.lua
        whitelistedAreas = {
            enabled = false,

            showBlips = false,
            areas = {
                { -- Grape Seed fields area
                    coords = vec3(1933.0, 4922.0, 46.0),
                    radius = 250.0
                },
                { -- Fields east of Grape Seed
                    coords = vec3(2880.0, 4624.0, 50.0),
                    radius = 150.0
                },
            }
        }
    },

    -- Whether only the player who has placed an object can pick it back up
    -- <!> Administrators can always pick them up. Check the editable server file for admin definition.
    onlyOwnerCanPickup = false,
}

-- You can utilize our debug placement commands to easily gather these coordinates
-- /kq_weed:potOffset
-- /kq_weed:tableOffset
-- /kq_weed:pressOffset
Config.prePlaced = {
    pots = {
        -- Barn up north
    --    { optimal = false, showTent = false, autoWatering = false, coords = vec3(433.70, 6455.19, 27.75),   rotation = vec3(0, 0, 320) },
    --    { optimal = false, showTent = false, autoWatering = false, coords = vec3(434.41, 6454.69, 27.75),   rotation = vec3(0, 0, 320) },
    --    { optimal = false, showTent = false, autoWatering = false, coords = vec3(435.09, 6454.19, 27.75),   rotation = vec3(0, 0, 320) },
    --    { optimal = false, showTent = false, autoWatering = false, coords = vec3(435.80, 6453.69, 27.75),   rotation = vec3(0, 0, 320) },
    --    { optimal = false, showTent = false, autoWatering = false, coords = vec3(436.51, 6453.19, 27.75),   rotation = vec3(0, 0, 320) },
    --   { optimal = false, showTent = false, autoWatering = false, coords = vec3(437.22, 6452.69, 27.75),   rotation = vec3(0, 0, 320) },

        -- Trevor's beach house
    --    { optimal = true,  showTent = true,  autoWatering = false, coords = vec3(-1150.66, -1513.53, 9.63), rotation = vec3(0, 0, 290) },

        -- Franklin's Mansion
    --    { optimal = true,  showTent = true,  autoWatering = false, coords = vec3(5.74, 530.42, 174.34),       rotation = vec3(0, 0, 331) },
    --    { optimal = true,  showTent = true,  autoWatering = false, coords = vec3(4.94, 530.86, 174.34),      rotation = vec3(0, 0, 331) },
    --    { optimal = true,  showTent = true,  autoWatering = false, coords = vec3(4.14, 531.3, 174.34),      rotation = vec3(0, 0, 331) },
    --    { optimal = true,  showTent = true,  autoWatering = false, coords = vec3(3.34, 531.74, 174.34),      rotation = vec3(0, 0, 331) },

        -- Lost MC HQ
    --    { optimal = false, showTent = false, autoWatering = false, coords = vec3(985.14, -90.25, 73.84), rotation = vec3(0, 0, 133) },
    --    { optimal = false, showTent = false, autoWatering = false, coords = vec3(985.58, -90.73, 73.84), rotation = vec3(0, 0, 133) },
    --    { optimal = false, showTent = false, autoWatering = false, coords = vec3(986.02, -91.21, 73.84), rotation = vec3(0, 0, 133) },
    --    { optimal = false, showTent = false, autoWatering = false, coords = vec3(986.46, -91.69, 73.84), rotation = vec3(0, 0, 133) },
    --    { optimal = false, showTent = false, autoWatering = false, coords = vec3(986.90, -92.17, 73.84), rotation = vec3(0, 0, 133) },

        -- Train cart in LS near Legion
    --    { optimal = true, showTent = true, autoWatering = false, coords = vec3(563.98, -510.97, 24.89), rotation = vec3(0, 0, 82) },
    --    { optimal = true, showTent = true, autoWatering = false, coords = vec3(564.11, -510.08, 24.89), rotation = vec3(0, 0, 82) },
    --    { optimal = true, showTent = true, autoWatering = false, coords = vec3(564.24, -509.19, 24.89), rotation = vec3(0, 0, 82) },
    --    { optimal = true, showTent = true, autoWatering = false, coords = vec3(564.37, -508.30, 24.89), rotation = vec3(0, 0, 82) },
    --    { optimal = true, showTent = true, autoWatering = false, coords = vec3(564.50, -507.41, 24.89), rotation = vec3(0, 0, 82) },

    },
    tables = {
        -- Barn up north
    --    { coords = vec3(439.45, 6453.96, 27.77), rotation = vec3(0, 0, 51) },

        -- Franklin's Mansion
    --    { coords = vec3(-2.15, 528.62, 173.99), rotation = vec3(0, 0, 59) },

        -- Lost MC HQ
    --    { coords = vec3(983.52, -91.41, 73.85), rotation = vec3(0, 0, 222) },

        -- Train cart in LS near Legion
    --    { coords = vec3(565.26, -501.37, 24.89), rotation = vec3(0, 0, 82) },
    },
    presses = {
        -- Barn up north
    --    { coords = vec3(435.37, 6457.92, 27.82), rotation = vec3(0, 0, 225) },

        -- Train cart in LS near Legion
    --    { coords = vec3(565.52, -499.61, 24.89), rotation = vec3(0, 0, 82) },
    },
}

-- Simple item shop system
-- We highly recommend adding these items to your shops, heists, robberies etc. instead
Config.vendors = {
    ["fertilizer_store"] = {
        coords = vector3(214.01, -913.2, 29.69),
        heading = 80.0,
        model = "a_m_m_hillbilly_01",
        idleAnim = {
            dict = "timetable@ron@ig_3_couch",
            anim = "base"
        },
        items = {
            ['kq_weed_fertilizer_speed'] = { label = "Fertilizer [Growth speed]", price = 200 },
            ['kq_weed_fertilizer_yield'] = { label = "Fertilizer [Yield amount]", price = 200 },
            ['kq_weed_fertilizer_resistance'] = { label = "Fertilizer [Resistance booster]", price = 200 },
            ['kq_weed_fertilizer_blackmarket'] = { label = "Fertilizer [Blackmarket]", price = 400 },
            ['watering_can'] = { label = "Watering Can", price = 50 },
            
        },
        blip = {
            enabled = true,

            label = 'Fertilizer dealer',
            sprite = 622,
            color = 62,
            alpha = 255,
            scale = 0.7,
        },
    },
    ["seed_store"] = {
        coords = vector3(218.48, -917.39, 29.69),
        heading = 055.061,
        model = "g_m_y_famdnf_01",
        idleAnim = {
            dict = "amb@world_human_leaning@male@wall@back@foot_up@idle_a",
            anim = "idle_a"
        },
        items = {
            ['kq_weed_seed_og_kush'] = { label = "Weed seed [OG Kush]", price = 100 },
            ['kq_weed_seed_purple_haze'] = { label = "Weed seed [Purple Haze]", price = 250 },
            ['kq_weed_seed_white_widow'] = { label = "Weed seed [White Widow]", price = 750 },
            ['kq_weed_bag_empty'] = { label = "Empty baggie", price = 30, amount = 5 },
        },
        blip = {
            enabled = true,

            label = 'Weed seed dealer',
            sprite = 140,
            color = 62,
            alpha = 255,
            scale = 0.7,
        },
    },
    ["tools_store"] = {
        coords = vector3(223.64, -912.57, 29.69),
        heading = 124.0,
        model = "g_m_y_famfor_01",
        idleAnim = {
            dict = "amb@world_human_leaning@male@wall@back@foot_up@idle_a",
            anim = "idle_a"
        },
        items = {
            ['kq_weed_paper'] = { label = "Rolling paper", price = 15, amount = 5 },
            ['kq_weed_pot'] = { label = "Weed Pot", price = 1000 },
            ['kq_weed_table'] = { label = "Weed workbench", price = 5000 },
            ['kq_weed_press'] = { label = "Weed press", price = 15000 },
            ['kq_weed_tent'] = { label = "Grow tent", price = 6000 },
            ['kq_weed_watering_system'] = { label = "Automatic watering system", price = 7000 },
        },
        blip = {
            enabled = true,

            label = 'Weed Paraphernalia dealer',
            sprite = 784,
            color = 62,
            alpha = 255,
            scale = 0.7,
        },
    },
}

-- Item quality metadata (Only for inventories supporting metadata)
-- The weed quality depends on the plant conditions, how well it has been watered, and how quickly it has been collected since finishing its growing process
Config.qualityMetadata = {
    -- Whether to enable the quality in the metadata for product. (Buds, bricks, baggies, joints)
    -- If you do not know how to setup your selling systems to work with the quality metadata, there is no point in enabling it.
    -- This is purely an option for advanced usage
    enabled = false,

    -- Whether to use the quality metadata for seeds as well. The quality of the seed will be the maximum quality of the weed buds collected
    seedQuality = false,
}

-- Smoking a joint. Every strain's jointItem becomes usable
Config.weedEffect = {
    enabled = true,

    -- How long a joint keeps you high (seconds). Smoking again refreshes this
    defaultDuration = 240,

    -- Seconds before the high kicks in
    delay = 10,

    -- Screen effect while high
    timecycle = 'spectator5',
    -- Intensity added per joint smoked
    timecycleStrength = 0.3,
    -- Intensity ceiling, no matter how many joints are smoked
    timecycleMaxStrength = 1.2,

    -- Seconds the screen effect takes to fade in at the start and out at the end
    fadeTime = 10,

    -- Health slowly regenerates while high
    health = {
        -- Health gained per tick
        amount = 2,
        -- Seconds between ticks
        tickTime = 4,
    },
}
