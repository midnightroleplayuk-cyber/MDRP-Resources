local NewspaperJob = {

    id = "newspaper",

    icon = "./img/jobs/newspaper_icon.svg",
    image = "./img/jobs/newspaper_bg.png",
    video = "https://tworst.info/uploads/videos/eea35170b71e0a221bbf76a5aacf3402_1775405644.mp4",
    enabled = true,    -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0,      -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(-604.82, -926.45, 23.86, 181.1),
        model = "s_m_m_postal_02",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 459,
            color = 46,
            scale = 0.75,
        },
    },

    xprewards = {
        deliveryCompleted = 50,
        jobCompleted = 300,
    },

    payment = {
        mode = "onJobEnd", -- "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        coopMode = "full", -- "full" = everyone gets full pay | "split" = pay divided by player count
    },

    stepRewards = {
        -- Available phases: onDeliver (delivery/ride completed)
        onDeliver = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 10 }, { item = "water_bottle", count = 1, chance = 8 } } },
    },

    missioncompletedItems = {
        giveItemPlayer = false,    -- true = give items on job complete | false = no items given
        dropMode = "weightedPool", -- "weightedPool" = pick one item by chance weight | "perItem" = each item rolls independently
        itemList = {
            { item = "sandwich",     count = 1, chance = 50 },
            { item = "water_bottle", count = 1, chance = 30 },
        },
    },

    weapon = {
        hash = "WEAPON_ACIDPACKAGE",
        label = "Newspaper Bundle",
        oxBasedInventory = false, -- auto-detected for ox_inventory / core_inventory | set true only if your inventory is item-based (weapons are inventory items) but uses a different Config.Inventory name
    },

    runtime = {

        -- Time window gate (in-game GTA hours, 0-23). When enabled, the job
        -- can only be STARTED inside the window — already-running jobs continue
        -- past the window. Default OFF for backwards-compatibility.
        timeWindow = {
            enabled   = false, -- true = restrict start to [startHour, endHour) | false = always available
            startHour = 5,     -- inclusive
            endHour   = 11,    -- exclusive (no wraparound: endHour must be > startHour)
        },

        -- Each area defines a `locationPool` (geographic cluster of possible
        -- delivery houses) and a `totalTasks = {min, max}` range. On every
        -- round, the server picks a random count in [min, max] and selects
        -- that many UNIQUE locations from the pool. Pool stays clustered so
        -- selected deliveries are always near each other.
        areas = {
            [1] = {
                id = "restoran",
                name = "Restaurant Route",
                type = "daily",
                coord = vector3(99.4583, -1418.8939, 29.4216),
                payment = 700,
                experience = 1500,
                isDaily = true,
                requiredLevel = 0,
                totalTasks = { min = 6, max = 10 },
                locationPool = {
                    vector3(99.4583, -1418.8939, 29.4216),
                    vector3(90.0274, -1411.2307, 29.4207),
                    vector3(84.9615, -1404.7639, 29.4072),
                    vector3(84.7607, -1396.6549, 29.2961),
                    vector3(117.3404, -1344.2161, 29.2914),
                    vector3(122.5481, -1348.6562, 29.2915),
                    vector3(158.2740, -1365.3118, 29.3047),
                    vector3(76.3893, -1455.4827, 29.291),
                    vector3(66.4517, -1467.4576, 29.2912),
                    vector3(53.2621, -1480.3451, 29.2673),
                },
            },
            [2] = {
                id = "easy",
                name = "Easy Route",
                type = "standard",
                coord = vector3(-28.3897, -1568.3716, 29.8801),
                payment = 200,
                experience = 300,
                isDaily = false,
                requiredLevel = 1,
                totalTasks = { min = 3, max = 5 },
                locationPool = {
                    vector3(-28.3897, -1568.3716, 29.8801),
                    vector3(-84.0474, -1525.1554, 34.3149),
                    vector3(-123.4288, -1490.2723, 33.7796),
                    vector3(-158.5127, -1543.9950, 35.0270),
                    vector3(-134.8391, -1564.5510, 34.2593),
                    vector3(-112.3095, -1595.2559, 32.0383),
                },
            },
            [3] = {
                id = "headline",
                name = "Headline Circuit",
                type = "standard",
                coord = vector3(760.1693, -909.4398, 25.2546),
                payment = 250,
                experience = 400,
                isDaily = false,
                requiredLevel = 3,
                totalTasks = { min = 4, max = 6 },
                locationPool = {
                    vector3(760.1693, -909.4398, 25.2546),
                    vector3(799.9420, -950.5016, 25.7201),
                    vector3(720.3177, -978.2911, 24.1212),
                    vector3(760.1342, -817.8022, 26.2835),
                    vector3(805.9797, -810.2922, 26.2019),
                    vector3(760.2377, -777.4681, 26.4550),
                },
            },
            [4] = {
                id = "express",
                name = "Express Route",
                type = "standard",
                coord = vector3(450.3793, -651.0438, 28.4577),
                payment = 300,
                experience = 700,
                isDaily = false,
                requiredLevel = 5,
                totalTasks = { min = 3, max = 5 },
                locationPool = {
                    vector3(450.3793, -651.0438, 28.4577),
                    vector3(450.3065, -644.0713, 28.4840),
                    vector3(451.2492, -636.3403, 28.5160),
                    vector3(451.5219, -629.8257, 28.535),
                    vector3(452.0367, -622.4101, 28.5587),
                    vector3(452.8796, -615.5856, 28.5761),
                },
            },
            [5] = {
                id = "morning",
                name = "Morning Gazette",
                type = "standard",
                coord = vector3(-126.4467, 215.0760, 94.8084),
                payment = 400,
                experience = 1000,
                isDaily = false,
                requiredLevel = 8,
                totalTasks = { min = 4, max = 6 },
                locationPool = {
                    vector3(-126.4467, 215.0760, 94.8084),
                    vector3(-140.0880, 214.7770, 94.8084),
                    vector3(-147.9742, 214.8707, 94.8084),
                    vector3(-133.5815, 215.4340, 98.3294),
                    vector3(-145.4203, 215.2231, 98.3293),
                    vector3(-154.9975, 214.4351, 98.3293),
                    vector3(-174.9759, 217.9398, 89.9275),
                },
            },
            [6] = {
                id = "editorial",
                name = "Editorial Run",
                type = "standard",
                coord = vector3(176.3900, 227.0467, 106.0258),
                payment = 500,
                experience = 1200,
                isDaily = false,
                requiredLevel = 8,
                totalTasks = { min = 3, max = 5 },
                locationPool = {
                    vector3(176.3900, 227.0467, 106.0258),
                    vector3(259.1299, 202.7461, 106.2089),
                    vector3(335.5081, 178.2452, 103.1007),
                    vector3(349.0529, 172.1411, 103.0946),
                    vector3(366.4161, 194.3901, 103.0546),
                },
            },
        },

        delivery = {
            markerType = 1, -- horizontal ground circle (was 6 = vertical ring)
            markerSize = vector3(2.5, 2.5, 1.0),
            markerColor = { r = 255, g = 255, b = 0, a = 165 },
            detectionRadius = 5.0,
            interactionDistance = 25.0,
            drawDistance = 15.0, -- visible within ~15m (was 30m)
        },

        -- Ground marker + "get on the cycle" hint at the bicycle spawn, shown
        -- until the player mounts it. Horizontal ground circle (metaldetector
        -- marker pattern), configurable size/color/distance.
        cycleMarker = {
            enabled = true,
            type = 1,
            scale = vector3(2.5, 2.5, 1.0),
            color = { r = 80, g = 180, b = 255, a = 150 },
            drawDistance = 15.0,
        },

        deliveryBlip = {
            sprite = 40,
            color = 61,
            scale = 0.65,
            label = "Newspaper Delivery",
        },

        routeBlip = {
            sprite = 1,
            color = 3,
            scale = 1.0,
        },

        vehicle = {
            model = "scorcher",
            plate = "NEWS",
            useCustomPlate = false,
            trunkDoors = {},
            spawnLocations = {
                vector4(-615.75, -939.69, 22.11, 97.79),
                vector4(-615.1, -928.48, 22.4, 121.87),
                vector4(-615.85, -920.26, 23.11, 106.04),
            },
        },

        workClothes = {
            coord = vector4(-599.253, -930.000, 22.882, -91.327),
        },

        finishPoint = {
            coords = vector4(-616.2, -938.51, 22.14, 120.05),
            interactDistance = 2.0,
        },
    },

    clothes = {
        male = {
            tshirt_1 = 15,
            tshirt_2 = 0,
            torso_1 = 241,
            torso_2 = 1,
            arms = 0,
            pants_1 = 6,
            pants_2 = 0,
            shoes_1 = 2,
            shoes_2 = 6,
            chain_1 = 0,
            chain_2 = 0,
            helmet_1 = -1,
            helmet_2 = 0,
        },
        female = {
            tshirt_1 = 15,
            tshirt_2 = 0,
            torso_1 = 5,
            torso_2 = 0,
            decals_1 = 0,
            decals_2 = 0,
            arms = 11,
            pants_1 = 24,
            pants_2 = 0,
            shoes_1 = 7,
            shoes_2 = 0,
            chain_1 = -1,
            chain_2 = 0,
            helmet_1 = 12,
            helmet_2 = 0,
        },
    },
}

NewspaperJob.preview = {
    playerPosition = vector3(-604.0, -926.0, 23.86),
    vehicleStep = 3,
    steps = {
        {
            camCoord = vector3(-604.9, -929.6, 25.1),
            camTarget = vector3(-604.8, -924.7, 23.9),
        },
        {
            autoClothes = true,
            camCoord = vector3(-604.0, -929.7, 25.6),
            camTarget = vector3(-599.5, -930.0, 23.5),
        },
        {
            autoVehicle = true,
            camCoord = vector3(-619.8, -940.1, 23.6),
            camTarget = vector3(-614.9, -939.6, 22.4),
        },
        {
            camCoord = vector3(102.2, -1415.6, 31.0),
            camTarget = vector3(99.1, -1419.4, 29.8),
            entities = {
                { type = "vehicle", model = "scorcher", coords = vector4(97.0, -1419.5, 29.42, 335.0) },
                {
                    type = "marker",
                    markerType = 1,
                    coords = vector4(99.46, -1418.89, 28.42, 0.0),
                    scale = vector3(4.0, 4.0, 2.0),
                    color = { r = 227, g = 14, b = 88, a = 165 }
                },
            },
        },
        {
            lockDuration = 2000,
            camCoord = vector3(53.6, -1484.7, 31.0),
            camTarget = vector3(53.2, -1479.9, 29.8),
            entities = {
                { type = "vehicle", model = "scorcher",          coords = vector4(55.0, -1479.0, 29.29, 200.0) },
                {
                    type = "marker",
                    markerType = 1,
                    coords = vector4(53.26, -1480.35, 28.29, 0.0),
                    scale = vector3(4.0, 4.0, 2.0),
                    color = { r = 227, g = 14, b = 88, a = 165 }
                },
                { type = "prop",    model = "prop_cs_newspaper", coords = vector4(53.26, -1480.35, 29.29, 45.0) },
            },
        },
        {
            camCoord = vector3(-619.5, -941.0, 23.5),
            camTarget = vector3(-615.6, -938.0, 22.5),
            entities = {
                {
                    type = "marker",
                    markerType = 20,
                    coords = vector4(-616.2, -938.51, 23.5, 0.0),
                    scale = vector3(0.5, 0.5, 0.5),
                    color = { r = 230, g = 180, b = 50, a = 200 },
                    bob = true,
                    rotate = true
                },
            },
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
    -- lobbyAmount / playerAmount meaning: number of newspapers delivered
    endJobFunction = {
        enabled = false, -- true = enable end function for THIS job only | false = use global
        func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
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

return NewspaperJob
