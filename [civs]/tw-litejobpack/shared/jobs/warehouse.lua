local WarehouseJob = {
    id = "warehouse",
    icon = "./img/jobs/warehouse_icon.svg",
    image = "./img/jobs/warehouse_bg.png",
    video = "https://tworst.info/uploads/videos/24d27c3dbe03a4080dffd362b534cd05_1775405641.mp4",
    enabled = true, -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0, -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(24.83, -2653.69, 6.00, 6.03),
        model = "s_m_m_warehouse_01",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 478,
            color = 47,
            scale = 0.8,
        },
    },

    xprewards = {
        perBox = 15,
        perPallet = 50,
        jobCompleted = 100,
    },

    payment = {
        mode = "custom", -- "custom" = job-specific payment logic | "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        perBox = 50, -- pay per box loaded
        perPallet = 200, -- pay per pallet loaded
        completionBonus = 0, -- bonus paid once when job is fully completed
        coopMode = "full", -- "full" = everyone gets full pay | "split" = pay divided by player count
    },

    stepRewards = {
        -- Available phases: onLoad (box/pallet loaded into truck)
        onLoad = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 10 }, { item = "water_bottle", count = 1, chance = 8 } } },
    },

    missioncompletedItems = {
        giveItemPlayer = false, -- true = give items on job complete | false = no items given
        dropMode = "weightedPool", -- "weightedPool" = pick one item by chance weight | "perItem" = each item rolls independently
        itemList = {
            { item = "sandwich",     count = 1, chance = 50 },
            { item = "water_bottle", count = 1, chance = 30 },
        },
    },

    runtime = {

        forklift = {
            model = "forklift",
            spawnPoints = {
                vector4(44.46, -2648.06, 5.46, 89.8),
                vector4(44.24, -2643.15, 5.46, 95.8),
                vector4(44.67, -2647.2, 5.46, 91.08),
                vector4(50.37, -2647.09, 5.46, 91.08),
                vector4(49.95, -2644.92, 5.47, 89.78),
            },

            forkBoneId = 4,
            pickupHeightMax = 0.25,
            loadHeightMin = 1.40,
            loadHeightMax = 2.35,
        },

        npcTruck = {
            model = "mule2",
            plate = "WHSE001",
            useCustomPlate = false,

            driverModel = "s_m_m_trucker_01",
            drivingSpeed = 15.0,

            spawnPoint = vector4(130.71, -2687.66, 5.46, 6.76),
            loadingPoints = {
                vector4(71.04, -2641.89, 5.47, 10.56),
                vector4(60.26, -2641.46, 5.47, 7.67),
            },
            exitPoint = vector4(194.41, -2635.07, 5.46, 184.13),

            boxCapacity = 8,
            palletCapacity = 3,

            maxConcurrentTrucks = 3,

            trucksPerLevel = {
                [0] = 1,
            },
            despawnDistance = 150.0,

            trunkDoors = { 5 },
            trunkOffset = -4.0, -- distance behind truck when loading boxes

            palletPositions = {
                { offset = vector3(0.0, 0.5, -0.1), rotation = vector3(0, 0, 0) },
                { offset = vector3(0.0, 2.0, -0.1), rotation = vector3(0, 0, 0) },
                { offset = vector3(0.0, 3.5, -0.1), rotation = vector3(0, 0, 0) },
            },

            boxPositions = {

                { offset = vector3(-0.4, -2.5, -0.2), rotation = vector3(0, 0, 0) },
                { offset = vector3(0.4, -2.5, -0.2),  rotation = vector3(0, 0, 0) },
                { offset = vector3(-0.4, -1.5, -0.2), rotation = vector3(0, 0, 0) },
                { offset = vector3(0.4, -1.5, -0.2),  rotation = vector3(0, 0, 0) },

                { offset = vector3(-0.4, -2.5, 0.35), rotation = vector3(0, 0, 0) },
                { offset = vector3(0.4, -2.5, 0.35),  rotation = vector3(0, 0, 0) },
                { offset = vector3(-0.4, -1.5, 0.35), rotation = vector3(0, 0, 0) },
                { offset = vector3(0.4, -1.5, 0.35),  rotation = vector3(0, 0, 0) },
            },
        },

        boxSpawns = {
            { index = 1, coord = vector4(34.0, -2675.0, 5.03, 0.0), prop = "prop_box_wood01a", type = "small" },
            { index = 2, coord = vector4(34.0, -2677.0, 5.03, 0.0), prop = "prop_box_wood01a", type = "small" },
            { index = 3, coord = vector4(34.0, -2679.0, 5.03, 0.0), prop = "prop_box_wood01a", type = "small" },
            { index = 4, coord = vector4(36.0, -2675.0, 5.03, 0.0), prop = "prop_box_wood04a", type = "large" },
            { index = 5, coord = vector4(36.0, -2677.0, 5.03, 0.0), prop = "prop_box_wood04a", type = "large" },
            { index = 6, coord = vector4(36.0, -2679.0, 5.03, 0.0), prop = "prop_box_wood04a", type = "large" },
            { index = 7, coord = vector4(38.0, -2675.0, 5.03, 0.0), prop = "prop_box_wood01a", type = "small" },
            { index = 8, coord = vector4(38.0, -2677.0, 5.03, 0.0), prop = "prop_box_wood01a", type = "small" },
        },

        palletSpawns = {
            { index = 1, coord = vector4(32.0, -2676.0, 5.03, 0.0), prop = "prop_boxpile_06a" },
            { index = 2, coord = vector4(32.0, -2679.0, 5.03, 0.0), prop = "prop_boxpile_06a" },
            { index = 3, coord = vector4(32.0, -2682.0, 5.03, 0.0), prop = "prop_boxpile_06a" },
        },

        forkliftPalletOffset = {
            pos = vector3(0.0, 0.1, -0.2),
            rot = vector3(0.0, 0.0, 0.0),
        },

        orders = {
            easy = {
                boxes = { min = 2, max = 3 },
                pallets = { min = 1, max = 1 },
                levelRange = { 0, 2 },
            },
            medium = {
                boxes = { min = 4, max = 5 },
                pallets = { min = 1, max = 2 },
                levelRange = { 3, 5 },
            },
            hard = {
                boxes = { min = 6, max = 8 },
                pallets = { min = 2, max = 3 },
                levelRange = { 6, 99 },
            },
        },

        deliveryRoutes = {
            {
                coords = vector4(68.0, -1393.0, 29.0, 270.0),
                name = "Vinewood Market",
                rewardMultiplier = 1.0,
            },
            {
                coords = vector4(-47.0, -1757.0, 29.0, 45.0),
                name = "Davis Supermarket",
                rewardMultiplier = 1.2,
            },
            {
                coords = vector4(25.0, -1347.0, 29.0, 270.0),
                name = "Strawberry Market",
                rewardMultiplier = 1.1,
            },
        },

        blips = {
            truck = {
                sprite = 477,
                color = 47,
                scale = 0.8,
                label = "Truck",
            },
            delivery = {
                sprite = 1,
                color = 2,
                scale = 1.0,
                label = "Delivery Point",
            },
            forklift = {
                sprite = 67,
                color = 47,
                scale = 0.7,
                label = "Forklift",
            },
        },

        interaction = {
            boxPickupDistance = 1.5,
            forkliftBoxPickupDistance = 3.5,
            palletPickupDistance = 3.5,
            trunkLoadDistance = 8.0,
            palletLoadDistance = 8.0,
            deliveryDistance = 5.0,
        },

        workClothes = {
            coord = vector4(44.64, -2635.38, 4.92, 3.21),
        },

        carry = {
            boxSmall = {
                prop = "prop_box_wood01a",
                bone = 57005,
                offset = vector3(0.1, 0.0, -0.15),
                rotation = vector3(0.0, -90.0, 0.0),
                animDict = "anim@heists@box_carry@",
                animName = "idle",
            },
            boxLarge = {
                prop = "prop_box_wood04a",
                bone = 57005,
                offset = vector3(0.15, 0.0, -0.2),
                rotation = vector3(0.0, -90.0, 0.0),
                animDict = "anim@heists@box_carry@",
                animName = "idle",
            },
        },
    },

    clothes = {
        male = {
            tshirt_1 = 15,
            tshirt_2 = 0,
            torso_1 = 56,
            torso_2 = 0,
            arms = 63,
            pants_1 = 36,
            pants_2 = 0,
            shoes_1 = 25,
            shoes_2 = 0,
            chain_1 = 0,
            chain_2 = 0,
            helmet_1 = -1,
            helmet_2 = 0,
        },
        female = {
            tshirt_1 = 15,
            tshirt_2 = 0,
            torso_1 = 161,
            torso_2 = 0,
            decals_1 = 0,
            decals_2 = 0,
            arms = 0,
            pants_1 = 69,
            pants_2 = 0,
            shoes_1 = 27,
            shoes_2 = 7,
            chain_1 = -1,
            chain_2 = 0,
            helmet_1 = -1,
            helmet_2 = 0,
        },
    },
}

WarehouseJob.preview = {
    playerPosition = vector3(24.83, -2653.0, 6.0),
    steps = {
        {
            camCoord = vector3(24.7, -2650.0, 7.4),
            camTarget = vector3(24.9, -2654.8, 6.2),
        },
        {
            autoClothes = true,
            camCoord = vector3(45.0, -2640.0, 7.8),
            camTarget = vector3(44.7, -2635.6, 5.5),
        },
        {
            camCoord = vector3(39.2, -2648.0, 7.3),
            camTarget = vector3(44.1, -2648.1, 6.1),
            entities = {
                { type = "vehicle", model = "forklift", coords = vector4(44.46, -2648.06, 5.46, 89.8) },
            },
        },
        {
            camCoord = vector3(34.1, -2669.1, 7.9),
            camTarget = vector3(34.0, -2673.9, 6.3),
            entities = {
                {
                    type = "vehicle",
                    model = "mule2",
                    coords = vector4(71.04, -2641.89, 5.47, 10.56),
                    openDoors = { 5 },
                    persist = true
                },
                { type = "prop", model = "prop_box_wood01a", coords = vector4(34.0, -2675.0, 5.03, 0.0), rawZ = true },
                { type = "prop", model = "prop_box_wood01a", coords = vector4(34.0, -2677.0, 5.03, 0.0), rawZ = true },
                { type = "prop", model = "prop_box_wood04a", coords = vector4(36.0, -2675.0, 5.03, 0.0), rawZ = true },
                { type = "prop", model = "prop_boxpile_06a", coords = vector4(32.0, -2676.0, 5.03, 0.0), rawZ = true },
                { type = "prop", model = "prop_boxpile_06a", coords = vector4(32.0, -2679.0, 5.03, 0.0), rawZ = true },
            },
        },
        {
            camCoord = vector3(73.0, -2650.2, 7.9),
            camTarget = vector3(71.9, -2645.4, 6.8),
            entities = {},
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
    -- lobbyAmount / playerAmount meaning: total boxes + pallets loaded onto trucks
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

return WarehouseJob
