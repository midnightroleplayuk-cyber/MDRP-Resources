local FishingJob = {

    id = "fishing",

    icon = "./img/jobs/fishing_icon.svg",
    image = "./img/jobs/fishing_bg.png",
    video = "https://tworst.info/uploads/videos/32ceafe238d4ae84d41885c81d5f4b7a_1775405598.mp4",
    enabled = true,    -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0,      -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    mode = "free",     -- dont change this, only "free" is currently supported

    shopNpcs = {
        [1] = {
            coord = vector4(-1814.56, -1212.65, 13.02, 43.91),
            model = "s_m_m_mariachi_01",
            scenario = "WORLD_HUMAN_STAND_FISHING",
            blip = { sprite = 317, color = 3, scale = 0.8, label = "Fishing Shop" },
            interactDistance = 2.0,
        },
    },

    buyerNpcs = {
        [1] = {
            coord = vector4(-1820.22, -1220.61, 13.02, 31.9),
            model = "s_m_y_baywatch_01",
            scenario = "WORLD_HUMAN_CLIPBOARD",
            blip = { sprite = 317, color = 2, scale = 0.7, label = "Fish Buyer" },
            interactDistance = 2.0,
        },
        [2] = {
            coord = vector4(-3426.26, 967.72, 8.35, 180.0),
            model = "s_m_y_baywatch_01",
            scenario = "WORLD_HUMAN_CLIPBOARD",
            blip = { sprite = 317, color = 2, scale = 0.7, label = "Fish Buyer" },
            interactDistance = 2.0,
        },
    },

    xprewards = {
        fishCaught = 20,
        fishDelivered = 40,
        jobCompleted = 400,
    },

    payment = {
        mode = "custom",     -- "custom" = job-specific payment logic | "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        deliveryBonus = 0, -- bonus pay for delivering/selling items
        completionBonus = 0, -- bonus paid once when job is fully completed
        coopMode = "full",   -- "full" = everyone gets full pay | "split" = pay divided by player count
    },

    missioncompletedItems = {
        giveItemPlayer = false,    -- true = give items on job complete | false = no items given
        dropMode = "weightedPool", -- "weightedPool" = pick one item by chance weight | "perItem" = each item rolls independently
        itemList = {
            { item = "sandwich",     count = 1, chance = 50 },
            { item = "water_bottle", count = 1, chance = 30 },
        },
    },

    minigame = {
        easy   = { sweetSpotSize = 0.30, speed = 1.0, hitsRequired = 1, timeLimit = 15 },
        medium = { sweetSpotSize = 0.20, speed = 1.5, hitsRequired = 2, timeLimit = 15 },
        hard   = { sweetSpotSize = 0.12, speed = 2.2, hitsRequired = 3, timeLimit = 15 },
    },

    rods = {
        standartrod = {
            price = 500,
            requiredLevel = 0,
            priority = 1,
            prop = "prop_fishing_rod_01",
            catchBonus = { easy = 0, medium = 0, hard = 0 },
        },
        carbonrod = {
            price = 2500,
            requiredLevel = 3,
            priority = 2,
            prop = "prop_fishing_rod_01",
            catchBonus = { easy = 0, medium = 5, hard = 3 },
        },
        prorod = {
            price = 7500,
            requiredLevel = 5,
            priority = 3,
            prop = "prop_fishing_rod_01",
            catchBonus = { easy = 0, medium = 10, hard = 8 },
        },
    },

    rodByLevel = {
        { minLevel = 5, rod = "prorod" },
        { minLevel = 3, rod = "carbonrod" },
        { minLevel = 0, rod = "standartrod" },
    },

    baits = {
        basicbait = {
            price = 25,
            requiredLevel = 0,
            biteSpeedBonus = 0,
            catchChanceBonus = 0,
        },
        spoonlure = {
            price = 75,
            requiredLevel = 0,
            biteSpeedBonus = 2,
            catchChanceBonus = 0,
        },
        threesided = {
            price = 150,
            requiredLevel = 2,
            biteSpeedBonus = 3,
            catchChanceBonus = 5,
        },
        tailfish = {
            price = 250,
            requiredLevel = 3,
            biteSpeedBonus = 4,
            catchChanceBonus = 10,
        },
        doublehook = {
            price = 500,
            requiredLevel = 5,
            biteSpeedBonus = 5,
            catchChanceBonus = 15,
            doubleChance = 30,
        },
        triplehook = {
            price = 800,
            requiredLevel = 7,
            biteSpeedBonus = 5,
            catchChanceBonus = 20,
            doubleChance = 40,
            tripleChance = 15,
        },
    },

    defaultFishTypes = { "anchovy", "trout", "mackerel" },

    runtime = {

        -- Each zone's `fishTypes` controls which fish bite there. TWO formats:
        --   list       → fishTypes = { "tuna", "shark" }
        --                 each fish uses its GLOBAL spawnWeight (runtime.fishTypes below)
        --   weight map → fishTypes = { tuna = 40, shark = 5 }
        --                 PER-ZONE weight override (higher = more common; 0 = never here)
        -- Both are supported and can be mixed across zones. Level/rod bonuses still
        -- apply on top. Weights are relative, not percentages (tuna=40 vs shark=5
        -- → tuna bites 8x as often), so they need not sum to any total.
        zones = {
            [1] = {
                id = "coast_south",
                name = "South Coast",
                coord = vector3(-1850.0, -1250.0, 1.0),
                radius = 200.0,
                requiredLevel = 0,
                fishTypes = { "anchovy", "trout", "mackerel" },
                blip = {
                    sprite = 317,
                    color = 3,
                    label = "South Coast",
                },
            },
            [2] = {
                id = "coast_west",
                name = "West Coast",
                coord = vector3(-3399.12, 946.28, 1.0),
                radius = 250.0,
                requiredLevel = 0,
                fishTypes = { "trout", "salmon", "snapper" },
                blip = {
                    sprite = 317,
                    color = 3,
                    label = "West Coast",
                },
            },
            [3] = {
                id = "deep_sea",
                name = "Deep Sea",
                coord = vector3(-3000.0, 400.0, 1.0),
                radius = 350.0,
                requiredLevel = 3,
                fishTypes = { "tuna", "swordfish", "grouper", "shark" },
                blip = {
                    sprite = 317,
                    color = 1,
                    label = "Deep Sea",
                },
            },
        },

        fishTypes = {
            anchovy   = { label = "Anchovy", price = { min = 80, max = 150 }, difficulty = "easy", itemName = "fish_anchovy", fishEntity = "a_c_fish", weight = { min = 0.3, max = 1.0 }, spawnWeight = 40 },
            trout     = { label = "Trout", price = { min = 150, max = 235 }, difficulty = "easy", itemName = "fish_trout", fishEntity = "a_c_fish", weight = { min = 1.0, max = 3.0 }, spawnWeight = 30 },
            mackerel  = { label = "Mackerel", price = { min = 120, max = 200 }, difficulty = "easy", itemName = "fish_mackerel", fishEntity = "a_c_fish", weight = { min = 0.5, max = 2.0 }, spawnWeight = 35 },
            salmon    = { label = "Salmon", price = { min = 235, max = 350 }, difficulty = "medium", itemName = "fish_salmon", fishEntity = "a_c_fish", weight = { min = 2.0, max = 6.0 }, spawnWeight = 25 },
            snapper   = { label = "Snapper", price = { min = 200, max = 300 }, difficulty = "medium", itemName = "fish_snapper", fishEntity = "a_c_fish", weight = { min = 1.5, max = 4.0 }, spawnWeight = 20 },
            tuna      = { label = "Tuna", price = { min = 300, max = 550 }, difficulty = "medium", itemName = "fish_tuna", fishEntity = "a_c_fish", weight = { min = 5.0, max = 15.0 }, spawnWeight = 15 },
            grouper   = { label = "Grouper", price = { min = 280, max = 450 }, difficulty = "hard", itemName = "fish_grouper", fishEntity = "a_c_fish", weight = { min = 3.0, max = 10.0 }, spawnWeight = 10 },
            swordfish = { label = "Swordfish", price = { min = 400, max = 600 }, difficulty = "hard", itemName = "fish_swordfish", fishEntity = "a_c_fish", weight = { min = 10.0, max = 30.0 }, spawnWeight = 8 },
            shark     = { label = "Shark", price = { min = 500, max = 800 }, difficulty = "hard", itemName = "fish_shark", fishEntity = "a_c_sharkhammer", weight = { min = 20.0, max = 50.0 }, spawnWeight = 5 },
        },

        rod = {
            prop = "prop_fishing_rod_01",
            bone = 18905,
            offset = vector3(0.1, 0.05, 0.0),
            rotation = vector3(80.0, 120.0, 160.0),
        },

        rope = {
            type = 5,
            lengthMultiplier = 4,
            segments = 15,
            rodTipOffset = vector3(0, 0, 2.5),
        },

        biteWait = { min = 4, max = 15 },

        biteWindow = 3.0,

        -- Casting requires standing near water. The check probes vertically for
        -- a water surface around the player, then compares the distance to it.
        waterCheck = {
            maxDistance = 10.0, -- max distance (units) from the player to the water hit point to allow casting
            probeUp     = 3.0,  -- vertical probe start: this far above the player
            probeDown   = 15.0, -- vertical probe end: this far below the player (raise for high piers/cliffs)
        },

        -- Anti-float fix: the standing fishing idle animation can slowly lift the ped into
        strictPosition = true,

        vehicle = {
            model = "dinghy2",
            color = { primary = 111, secondary = 36 },
            plate = "FISHING",
            useCustomPlate = false,
            fuelOnSpawn = 100.0,
            -- Map marker for the dock itself. The boat gets its own blip only
            -- after it spawns, which doesn't help a player who doesn't know
            -- where to walk. Set enabled = false to hide it; omit label to use
            -- the translated fishing.dockBlip string.
            blip = { enabled = true, sprite = 410, color = 3, scale = 0.8 },
            -- These spawn slots sit closer together than the default 7.0 clear
            -- radius (VehicleManager), which made one parked vehicle block every
            -- neighbouring slot and capped the job at one lobby at a time.
            -- Must stay BELOW the smallest slot-to-slot gap.
            spawnClearRadius = 5.5,
            spawnLocations = {
                vector4(-1832.38, -1228.85, 0.5, 230.0),
                vector4(-1836.24, -1233.45, 0.5, 230.0),
                vector4(-1828.52, -1224.25, 0.5, 230.0),
            },
            trunkDoors = {},
        },

        finishPoint = {
            coords = vector4(-1821.61, -1199.54, 14.31, 322.45),
        },
    },

    clothes = {
        male = {
            tshirt_1 = 2,
            tshirt_2 = 1,
            torso_1 = 69,
            torso_2 = 0,
            arms = 17,
            pants_1 = 8,
            pants_2 = 0,
            shoes_1 = 12,
            shoes_2 = 3,
            chain_1 = 0,
            chain_2 = 0,
            helmet_1 = -1,
            helmet_2 = 0,
            glasses_1 = -1,
            glasses_2 = 0,
        },
        female = {
            tshirt_1 = 15,
            tshirt_2 = 0,
            torso_1 = 0,
            torso_2 = 0,
            decals_1 = 0,
            decals_2 = 0,
            arms = 1,
            pants_1 = 10,
            pants_2 = 0,
            shoes_1 = 3,
            shoes_2 = 0,
            chain_1 = -1,
            chain_2 = 0,
            helmet_1 = 39,
            helmet_2 = 0,
            glasses_1 = 5,
            glasses_2 = 0,
        },
    },

    -- Per-job override (if enabled = true, this runs INSTEAD of the global Config.startJobFunction)
    -- Return true to allow the player to start, false to prevent
    startJobFunction = {
        enabled = false, -- true = enable start check for THIS job only | false = use global
        func = function(source, ownerIdentifier, jobId)
            return true
        end,
    },

    -- Per-job override (if enabled = true, this runs INSTEAD of the global Config.endJobFunction)
    endJobFunction = {
        enabled = false, -- true = enable end function for THIS job only | false = use global
        func = function(source, ownerIdentifier, jobId)
        end,
    },

    -- Per-job override (if enabled = true, this runs INSTEAD of the global Config.resetJobFunction)
    -- Called when the job is cancelled (owner/member leaves mid-job, lobby disbanded, etc.)
    resetJobFunction = {
        enabled = false, -- true = enable reset function for THIS job only | false = use global
        func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
        end,
    },
}

--[[ FishingJob.preview = {
    playerPosition = vector3(-1814.0, -1212.0, 13.02),
    steps = {
        {
            title = "Buy Rod & Bait",
            description = {
                "Walk up to the fishing shop NPC at the pier",
                "Press E to open the shop menu",
                "Buy a fishing rod and bait to get started",
            },
            camCoord = vector3(-1811.82, -1209.76, 14.52),
            camTarget = vector3(-1814.56, -1212.65, 13.52),
        },
        {
            title = "Find a Fishing Spot",
            description = {
                "Walk to any water edge in the fishing zone",
                "Look for the fishing icon on the map",
                "Stand near the water and face it",
            },
            camCoord = vector3(-1822.0, -1199.0, 15.5),
            camTarget = vector3(-1825.0, -1196.0, 13.5),
            entities = {
                {
                    type = "ped",
                    model = "a_m_y_beach_03",
                    coords = vector4(-1824.0, -1197.0, 13.02, 310.0),
                    scenario = "WORLD_HUMAN_STAND_FISHING",
                },
            },
        },
        {
            title = "Cast Your Line",
            description = {
                "Press E to cast your fishing line",
                "Wait for a fish to bite — watch for the splash",
                "Press E again when prompted to start reeling",
            },
            lockDuration = 3500,
            camCoord = vector3(-1826.0, -1194.0, 14.5),
            camTarget = vector3(-1824.0, -1197.0, 13.52),
            entities = {
                {
                    type = "ped",
                    model = "a_m_y_beach_03",
                    coords = vector4(-1824.0, -1197.0, 13.02, 310.0),
                    anim = { dict = "amb@world_human_stand_fishing@idle_a", name = "idle_a", flag = 1 },
                },
                {
                    type = "prop",
                    model = "prop_fishing_rod_01",
                    attachTo = 1,
                    attachBone = 18905,
                    attachOffset = vector3(0.1, 0.05, 0.0),
                    attachRotation = vector3(80.0, 120.0, 160.0),
                },
            },
        },
        {
            title = "Complete the Minigame",
            description = {
                "Follow the fishing minigame on screen",
                "Keep the bar in the sweet spot to reel in",
                "Harder fish require more skill and better gear",
            },
            lockDuration = 3000,
            camCoord = vector3(-1821.5, -1198.5, 14.5),
            camTarget = vector3(-1824.0, -1197.0, 13.52),
            entities = {
                {
                    type = "ped",
                    model = "a_m_y_beach_03",
                    coords = vector4(-1824.0, -1197.0, 13.02, 310.0),
                    anim = { dict = "amb@world_human_stand_fishing@idle_a", name = "idle_a", flag = 1 },
                },
                {
                    type = "prop",
                    model = "prop_fishing_rod_01",
                    attachTo = 1,
                    attachBone = 18905,
                    attachOffset = vector3(0.1, 0.05, 0.0),
                    attachRotation = vector3(80.0, 120.0, 160.0),
                },
            },
        },
        {
            title = "Sell Your Catch",
            description = {
                "Walk to the fish buyer NPC nearby",
                "Press E to sell your caught fish",
                "Bigger and rarer fish are worth more money",
            },
            camCoord = vector3(-1817.0, -1223.5, 14.2),
            camTarget = vector3(-1820.22, -1220.61, 13.52),
            entities = {
                { type = "ped", model = "s_m_y_baywatch_01", coords = vector4(-1820.22, -1220.61, 13.02, 31.9),
                  scenario = "WORLD_HUMAN_CLIPBOARD" },
            },
        },
    },
} ]]

return FishingJob
