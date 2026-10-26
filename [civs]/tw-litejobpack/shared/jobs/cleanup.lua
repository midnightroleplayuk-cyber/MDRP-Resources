local CleanupJob = {

    id = "cleanup",

    icon = "./img/jobs/cleanup_icon.svg",
    image = "./img/jobs/cleanup_bg.png",
    video = "https://tworst.info/uploads/videos/0ca1dae8b6f98296eac09002a39d885a_1775405605.mp4",
    enabled = true,    -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0,      -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(-322.25, -1545.87, 31.02, 267.96),
        model = "s_m_y_garbage",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 67,
            color = 2,
            scale = 0.8,
        },
    },

    xprewards = {
        bagCollected = 10,
        truckDelivered = 100,
        jobCompleted = 500,
    },

    payment = {
        mode = "onJobEnd",   -- "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        perBag = 50,         -- pay per bag collected
        deliveryBonus = 0,   -- bonus pay for delivering/selling items
        completionBonus = 0, -- bonus paid once when job is fully completed
        coopMode = "full",   -- "full" = everyone gets full pay | "split" = pay divided by player count
    },

    stepRewards = {
        -- Available phases: onCollect (item collected/deposited)
        onCollect = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 10 }, { item = "water_bottle", count = 1, chance = 8 } } },
    },

    missioncompletedItems = {
        giveItemPlayer = false,    -- true = give items on job complete | false = no items given
        dropMode = "weightedPool", -- "weightedPool" = pick one item by chance weight | "perItem" = each item rolls independently
        itemList = {
            { item = "sandwich",     count = 1, chance = 50 },
            { item = "water_bottle", count = 1, chance = 30 },
        },
    },

    runtime = {

        binModels = {

            'prop_bin_01a',
            'prop_bin_02a',
            'prop_bin_03a',
            'prop_bin_04a',
            'prop_bin_05a',
            'prop_bin_06a',
            'prop_bin_07a',
            'prop_bin_07b',
            'prop_bin_08a',
            'prop_bin_08open',
            'prop_bin_09a',
            'prop_bin_10a',
            'prop_bin_10b',
            'prop_bin_11a',
            'prop_bin_12a',
            'prop_bin_13a',
            'prop_bin_14a',
            'prop_bin_14b',

            'prop_dumpster_01a',
            'prop_dumpster_02a',
            'prop_dumpster_02b',
            'prop_dumpster_3a',
            'prop_dumpster_4a',
            'prop_dumpster_4b',
        },

        binDetection = {
            scanRadius = 50.0,
            interactDistance = 2.0,
        },

        binLoot = {
            chance = 90,
            minBags = 1,
            maxBags = 3,
        },

        cleanupBag = {
            model = "prop_cs_rub_binbag_01",
            bone = 57005,
            offset = vector3(0.12, 0.0, -0.05),
            rotation = vector3(220.0, 120.0, 0.0),
        },

        animations = {

            rummage = {
                dict = "amb@prop_human_bum_bin@base",
                name = "base",
                duration = 2500,
                flag = 1,
            },

            pickup = {
                dict = "missfbi4prepp1",
                name = "_bag_throw_garbage_man",
                duration = 500,
            },

            carry = {
                dict = "missfbi4prepp1",
                name = "_bag_walk_garbage_man",
                flag = 49,
            },

            throw = {
                dict = "missfbi4prepp1",
                name = "_bag_throw_garbage_man",
                duration = 1100,
                flag = 48,
            },

            exit = {
                dict = "missfbi4prepp1",
                name = "exit",
                duration = 800,
                flag = 48,
            },
        },

        vehicle = {
            -- These spawn slots sit closer together than the default 7.0 clear
            -- radius (VehicleManager), which made one parked vehicle block every
            -- neighbouring slot and capped the job at one lobby at a time.
            -- Must stay BELOW the smallest slot-to-slot gap.
            spawnClearRadius = 5.5,
            spawnLocations = {
                vector4(-326.95, -1524.44, 27.25, 268.4),
                vector4(-327.12, -1530.44, 27.25, 268.4),
                vector4(-326.78, -1518.44, 27.25, 268.4),
            },
            spawnBlockRadius = 7.0,
            model = "trash",
            color = { primary = 0, secondary = 0 },
            plate = "CLEANUP",
            useCustomPlate = false,
            fuelOnSpawn = 100.0,
            trunkDoors = {},
            trunkOffset = -5.5, -- distance behind vehicle when depositing trash bags
            maxCapacity = 16,   -- max number of bags the truck can hold before delivery is forced

            depositZone = {
                offset = vector3(0.0, -5.0, 0.0),
                radius = 3.0,
            },
        },

        delivery = {
            coord = vector3(-339.86, -1522.48, 27.46),
            radius = 5.0,
            marker = {
                type = 1,
                color = { r = 0, g = 255, b = 0, a = 100 },
                scale = vector3(3.0, 3.0, 1.0),
            },
            blip = {
                sprite = 318,
                color = 2,
                scale = 1.0,
                label = "Cleanup Delivery",
            },
        },

        workClothes = {
            coord = vector4(-318.63, -1546.48, 26.75, 173.75),
        },
    },

    clothes = {
        male = {
            tshirt_1 = 59,
            tshirt_2 = 0,
            torso_1 = 38,
            torso_2 = 3,
            arms = 69,
            pants_1 = 36,
            pants_2 = 0,
            shoes_1 = 25,
            shoes_2 = 0,
            chain_1 = 0,
            chain_2 = 0,
            helmet_1 = -1,
            helmet_2 = 0,
            glasses_1 = -1,
            glasses_2 = 0,
        },
        female = {
            tshirt_1 = 2,
            tshirt_2 = 0,
            torso_1 = 38,
            torso_2 = 3,
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
            glasses_1 = -1,
            glasses_2 = 0,
        },
    },
}

CleanupJob.preview = {
    playerPosition = vector3(-322.0, -1546.0, 31.02),
    vehicleStep = 3,
    steps = {
        {
            camCoord = vector3(-319.8, -1545.7, 32.1),
            camTarget = vector3(-324.7, -1546.0, 30.9),
        },
        {
            autoClothes = true,
            camCoord = vector3(-318.2, -1542.2, 29.2),
            camTarget = vector3(-318.7, -1546.8, 27.1),
        },
        {
            camCoord = vector3(-335.3, -1524.2, 30.0),
            camTarget = vector3(-330.5, -1524.3, 28.7),
            entities = {
                {
                    type = "vehicle",
                    model = "trash",
                    coords = vector4(-326.95, -1524.44, 27.25, 268.4),
                    color = { primary = 0, secondary = 0 },
                    openDoors = {},
                    persist = false
                },
            },
        },
        {
            lockDuration = 3000,
            camCoord = vector3(-328.9, -1075.7, 24.9),
            camTarget = vector3(-327.1, -1071.6, 22.5),
            entities = {
                { type = "prop",   model = "prop_dumpster_01a", coords = vector4(-327.19, -1071.76, 22.04, 336.39) },
                { type = "marker", markerType = 20,             coords = vector4(-327.19, -1071.76, 24.04, 0.0),   scale = vector3(0.4, 0.4, 0.4), color = { r = 230, g = 180, b = 50, a = 200 }, bob = true },
                {
                    type = "ped",
                    model = "s_m_y_garbage",
                    coords = vector4(-327.46, -1072.61, 22.03, 336.32),
                    scenario = "PROP_HUMAN_BUM_BIN",
                },
            },
        },
        {
            lockDuration = 2500,
            camCoord = vector3(-290.9, -1121.5, 26.0),
            camTarget = vector3(-293.8, -1125.1, 24.1),
            entities = {
                {
                    type = "vehicle",
                    model = "trash",
                    coords = vector4(-298.0, -1127.0, 22.62, 128.0),
                    color = { primary = 0, secondary = 0 },
                    openDoors = { 5 }
                },
                {
                    type = "ped",
                    model = "s_m_y_garbage",
                    coords = vector4(-293.7, -1123.6, 22.62, 128.0),
                    anim = { dict = "missfbi4prepp1", name = "_bag_throw_garbage_man", flag = 48 },
                },
                {
                    type = "prop",
                    model = "prop_cs_rub_binbag_01",
                    attachTo = 2,
                    attachBone = 57005,
                    attachOffset = vector3(0.12, 0.0, -0.05),
                    attachRotation = vector3(220.0, 120.0, 0.0),
                },
            },
        },
        {
            camCoord = vector3(-328.3, -1523.2, 30.6),
            camTarget = vector3(-333.2, -1522.9, 29.5),
            entities = {
                {
                    type = "vehicle",
                    model = "trash",
                    coords = vector4(-339.86, -1522.48, 26.96, 268.0),
                    color = { primary = 0, secondary = 0 },
                    openDoors = {}
                },
                { type = "marker", markerType = 20, coords = vector4(-339.86, -1522.48, 29.0, 0.0), scale = vector3(0.5, 0.5, 0.5), color = { r = 230, g = 180, b = 50, a = 200 }, bob = true, rotate = true },
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
    -- lobbyAmount / playerAmount meaning: number of trash bags collected
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

return CleanupJob
