local TreasureHunterJob = {
    id = "treasurehunter",

    icon = "./img/jobs/treasurehunter_icon.svg",
    image = "./img/jobs/treasurehunter_bg.png",
    video = "https://tworst.info/uploads/videos/beae3aeb21b68998300e55ffd95365b1_1775405635.mp4",
    enabled = true, -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0, -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(167.82, -2222.7, 7.24, 240.0),
        model = "s_m_y_baywatch_01",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 729,
            color = 50,
            scale = 0.8,
        },
    },

    xprewards = {
        treasureCollected = 50,
        jobCompleted = 500,
    },

    payment = {
        mode = "custom", -- "custom" = job-specific payment logic | "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        completionBonus = 0, -- bonus paid once when job is fully completed
        coopMode = "full", -- "full" = everyone gets full pay | "split" = pay divided by player count
        coopBonus = 1.2, -- multiplier for coop play (1.0 = no bonus, 1.2 = 20% bonus)
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

        sharedTreasure = true,

        minimumPlayers = 1,

        requiredItem = "none",
        requireItemFromWholeTeam = true,

        treasureBlip = {
            sprite = 366,
            color = 50,
            scale = 0.8,
            shortRange = false,
            areaRadius = 50.0,
            areaColor = 1,
            areaAlpha = 80,
            randomOffset = 15, -- treasure pin coords are offset by +/- this many meters so players don't get the exact spot
        },

        treasureLocations = {
            { coord = vector3(1815.49768, -2954.997, -45.5570831) },
            { coord = vector3(1864.00513, -2943.36328, -45.1559143) },
            { coord = vector3(2087.157, -3039.93726, -47.4239426) },
            { coord = vector3(2193.7627, -3127.48364, -94.57767) },
            { coord = vector3(2378.85034, -2499.71631, -35.8349953) },
            { coord = vector3(2627.7478, -2413.352, -54.75626) },
            { coord = vector3(2626.367, -2423.33521, -55.3033142) },
            { coord = vector3(2846.15332, -2222.815, -41.333744) },
            { coord = vector3(2859.74365, -1891.47119, -34.197506) },
            { coord = vector3(2984.12964, -1498.41418, -27.9075184) },
            { coord = vector3(3177.29468, -581.065247, -127.739563) },
            { coord = vector3(3281.40527, -402.4866, -117.204651) },
            { coord = vector3(3299.69238, -406.8575, -124.827339) },
            { coord = vector3(3299.3125, -397.5286, -116.688576),   current = { dir = vector3(0.4, -0.2, 0.0), force = 0.3 } },
            { coord = vector3(3256.39038, -420.755249, -77.03309) },
            { coord = vector3(3201.50244, -402.942261, -25.67505) },
            { coord = vector3(3412.09766, -74.54607, -140.977844) },
            { coord = vector3(3460.43457, 378.9865, -122.711594) },
            { coord = vector3(3422.76685, 965.6635, -128.906647) },
            { coord = vector3(3317.28442, 1120.36389, -112.818596) },
            { coord = vector3(3355.995, 1508.01233, -139.310776) },
            { coord = vector3(3410.40137, 1958.86682, -51.6830864) },
            { coord = vector3(3902.61035, 3058.50049, -29.4393253) },
            { coord = vector3(3883.802, 3039.01636, -25.3941383) },
            { coord = vector3(3583.80859, 2718.93262, -27.3160973) },
        },

        lootTable = {
            { id = "common",    name = "Treasure Bag", chance = 85, value = 1000, carryProp = "prop_cs_heist_bag_02" },
            { id = "legendary", name = "Gold Chest",   chance = 10, value = 1200, carryProp = "prop_ld_gold_chest" },
        },
        levelChanceBonus = 0.5,

        dig = {
            progressPerHit = 100,
            scenario = "WORLD_HUMAN_GARDENER_PLANT",
            scenarioDuration = 5000,
            chestRiseDistance = 0.8,
            chestBuriedOffset = -0.5,
            chestProp = "prop_box_wood01a",
        },

        chestOpen = {
            animDict = "mini@repair",
            animName = "fixing_a_ped",
            duration = 2500,
        },

        tracker = {
            enabled = true,
            startDistance = 30.0,
            blipDistance = 15.0,
            collectDistance = 3.0,

            tiers = {
                { distance = 30.0, interval = 1500 },
                { distance = 20.0, interval = 1000 },
                { distance = 10.0, interval = 500 },
                { distance = 5.0,  interval = 250 },
            },
            sound = { name = "Beep_Red", ref = "DLC_HEIST_HACKING_SNAKE_SOUNDS" },
            nearbySound = { name = "Close", ref = "DLC_H3_Tracker_App_Sounds" },
        },

        easyMode = true,
        easyModeDistance = 20.0,

        fakeChance = 15,
        fakeRestartTime = 30000,

        anchor = {
            speedThreshold = 2.0,
            interactDistance = 3.5,
        },

        oxygen = {
            drainRate = 1.5,
            surfaceRefillTime = 12.0, -- seconds for an empty tank to fully refill at the surface (was 5.0)
            warningThreshold = 0.25,
            criticalThreshold = 0.10,
            damagePerSecond = 10,
        },

        gear = {
            [1] = { label = "Basic Scuba", oxygenMax = 90.0, tankProp = "xm_prop_x17_scuba_tank", requiredLevel = 0 },
            [2] = { label = "Standard Scuba", oxygenMax = 130.0, tankProp = "p_michael_scuba_tank_s", requiredLevel = 3 },
            [3] = { label = "Pro Scuba", oxygenMax = 170.0, tankProp = "p_s_scuba_tank_s", requiredLevel = 7 },
        },

        scubaClothes = {
            male = {
                jacket = { component = 11, drawable = 243, texture = 0 },
                shirt  = { component = 8, drawable = 15, texture = 0 },
                arms   = { component = 3, drawable = 17, texture = 0 },
                legs   = { component = 4, drawable = 94, texture = 0 },
                shoes  = { component = 6, drawable = 67, texture = 0 },
            },

            female = {
                jacket = { component = 11, drawable = 251, texture = 0 },
                shirt  = { component = 8, drawable = 15, texture = 0 },
                arms   = { component = 3, drawable = 18, texture = 0 },
                legs   = { component = 4, drawable = 101, texture = 0 },
                shoes  = { component = 6, drawable = 70, texture = 0 },
            },
        },

        tankAttachment = {
            male   = { bone = 24818, offset = vector3(-0.25, -0.25, 0.0), rotation = vector3(180.0, 90.0, 0.0) },
            female = { bone = 24818, offset = vector3(-0.20, -0.22, 0.0), rotation = vector3(180.0, 90.0, 0.0) },
        },

        maskAttachment = {
            bone = 12844,
            prop = "p_d_scuba_mask_s",
            offset = vector3(0.0, 0.0, 0.0),
            rotation = vector3(180.0, 90.0, 0.0),
        },

        depthWarning = {
            threshold = -145.0,
            extraDrainMultiplier = 1.5,
        },

        shark = {
            enabled = true,
            spawnChance = 40,
            maxSharks = 2,
            models = { "a_c_sharkhammer", "a_c_sharktiger" },
            spawnRadius = 40.0,
            approachDistance = 5.0,
            despawnDistance = 80.0,
        },

        vehiclePenalty = {
            enabled = true,
            amount = 500,
            dontPayWithoutVehicle = false,
        },

        vehicle = {
            model = "dinghy",
            plate = "TRHUNT",
            useCustomPlate = false,
            trunkDoors = {},

            blip = {
                sprite = 410,
                color = 50,
                scale = 0.8,
                shortRange = false,
            },

            spawnLocations = {
                vector4(163.3, -2263.33, 0.11, 268.86),
                vector4(178.31, -2262.95, 0.13, 91.49),
                vector4(79.79, -2261.47, 0.48, 87.93)
            },
            teleportIntoVehicle = false,
            maxCargo = 6,

            cargoPositionsByProp = {
                ["prop_cs_heist_bag_02"] = {
                    { offset = vector3(0.000, 2.920, 0.810),  rotation = vector3(0.0, 0.0, 0.0) }, -- 1
                    { offset = vector3(0.000, 2.550, 0.810),  rotation = vector3(0.0, 0.0, 0.0) }, -- 2

                    { offset = vector3(-0.300, 2.100, 0.520), rotation = vector3(0.0, 0.0, 0.0) }, -- 3
                    { offset = vector3(0.300, 2.100, 0.520),  rotation = vector3(0.0, 0.0, 0.0) }, -- 4

                    { offset = vector3(-0.300, 1.650, 0.520), rotation = vector3(0.0, 0.0, 0.0) }, -- 5
                    { offset = vector3(0.300, 1.650, 0.520),  rotation = vector3(0.0, 0.0, 0.0) }, -- 6
                },

                ["prop_ld_gold_chest"] = {
                    { offset = vector3(0.000, 2.920, 0.720),  rotation = vector3(0.0, 0.0, 0.0) }, -- 1
                    { offset = vector3(0.000, 2.270, 0.490),  rotation = vector3(0.0, 0.0, 0.0) }, -- 2

                    { offset = vector3(-0.300, 1.810, 0.490), rotation = vector3(0.0, 0.0, 0.0) }, -- 3
                    { offset = vector3(0.300, 1.810, 0.490),  rotation = vector3(0.0, 0.0, 0.0) }, -- 4

                    { offset = vector3(-0.300, 1.360, 0.490), rotation = vector3(0.0, 0.0, 0.0) }, -- 5
                    { offset = vector3(0.300, 1.360, 0.490),  rotation = vector3(0.0, 0.0, 0.0) }, -- 6
                },
            },

            cargoPositions = {
                { offset = vector3(0.000, 2.920, 0.810),  rotation = vector3(0.0, 0.0, 0.0) }, -- 1
                { offset = vector3(0.000, 2.550, 0.810),  rotation = vector3(0.0, 0.0, 0.0) }, -- 2

                { offset = vector3(-0.300, 2.100, 0.520), rotation = vector3(0.0, 0.0, 0.0) }, -- 3
                { offset = vector3(0.300, 2.100, 0.520),  rotation = vector3(0.0, 0.0, 0.0) }, -- 4

                { offset = vector3(-0.300, 1.650, 0.520), rotation = vector3(0.0, 0.0, 0.0) }, -- 5
                { offset = vector3(0.300, 1.650, 0.520),  rotation = vector3(0.0, 0.0, 0.0) }, -- 6
            },

            carryBone = 57005,
            carryOffset = vector3(0.1, 0.0, -0.15),
            carryRotation = vector3(0.0, 0.0, 0.0),
        },

        steal = {
            enabled = true,
            interactDistance = 2.5,
            takeAnimDuration = 2000,
        },

        finishLocation = {
            coords = vector3(163.3, -2263.33, 1.5),
            radius = 15.0,
        },

    },

    clothes = {
        male = {
            tshirt_1 = 15, -- shirt (component 8)
            tshirt_2 = 0,
            torso_1 = 243, -- jacket (component 11)
            torso_2 = 0,
            arms = 17,     -- arms (component 3)
            pants_1 = 94,  -- legs (component 4)
            pants_2 = 0,
            shoes_1 = 67,  -- shoes (component 6)
            shoes_2 = 0,
            chain_1 = 0,
            chain_2 = 0,
            helmet_1 = -1,
            helmet_2 = 0,
        },

        female = {
            tshirt_1 = 15, -- shirt
            tshirt_2 = 0,
            torso_1 = 251, -- jacket
            torso_2 = 0,
            decals_1 = 0,
            decals_2 = 0,
            arms = 18,     -- arms
            pants_1 = 101, -- legs
            pants_2 = 0,
            shoes_1 = 70,  -- shoes
            shoes_2 = 0,
            chain_1 = -1,
            chain_2 = 0,
            helmet_1 = -1,
            helmet_2 = 0,
        },
    },
}

local rt = TreasureHunterJob.runtime

TreasureHunterJob.preview = {
    playerPosition = vector3(167.82, -2222.7, 7.24),
    steps = {
        {
            camCoord = vector3(170.2, -2224.1, 8.4),
            camTarget = vector3(166.0, -2221.6, 7.2),
        },
        {
            camCoord = vector3(168.1, -2263.5, 4.0),
            camTarget = vector3(163.6, -2263.3, 1.7),
            entities = {
                {
                    type = "vehicle",
                    model = "dinghy",
                    coords = vector4(163.3, -2263.33, 0.11, 268.86),
                    color = { primary = 111, secondary = 111 }
                },
            },
        },
        {
            lockDuration = 3000,
            camCoord = vector3(1817.7, -2951.8, -43.0),
            camTarget = vector3(1815.2, -2955.4, -45.3),
            entities = {
                { type = "prop", model = rt.dig.chestProp,       coords = vector4(1815.5, -2955.0, -45.56, 0.0),  rawZ = true, removeDelay = 2500 },
                { type = "prop", model = "prop_cs_heist_bag_02", coords = vector4(1815.5, -2955.0, -44.76, 30.0), rawZ = true, spawnDelay = 2500 },
                {
                    type = "ped",
                    model = "s_m_y_baywatch_01",
                    coords = vector4(1816.0, -2955.5, -45.56, 0.0),
                    anim = { dict = "mini@repair", name = "fixing_a_ped", flag = 1 },
                    rawZ = true,
                },
                {
                    type = "ped",
                    model = "a_c_sharkhammer",
                    coords = vector4(1820.0, -2950.0, -43.0, 200.0),
                    rawZ = true,
                },
            },
        },
        {
            camCoord = vector3(1819.4, -2952.9, 5.3),
            camTarget = vector3(1816.2, -2955.2, 2.2),
            entities = {
                {
                    type = "vehicle",
                    model = "dinghy",
                    coords = vector4(1815.28, -2955.9, 0.71, 306.7),
                    color = { primary = 111, secondary = 111 }
                },
                {
                    type = "prop",
                    model = "prop_cs_heist_bag_02",
                    attachTo = 1,
                    attachOffset = rt.vehicle.cargoPositions[1].offset,
                    attachRotation = rt.vehicle.cargoPositions[1].rotation
                },
                {
                    type = "prop",
                    model = "prop_cs_heist_bag_02",
                    attachTo = 1,
                    attachOffset = rt.vehicle.cargoPositions[3].offset,
                    attachRotation = rt.vehicle.cargoPositions[3].rotation
                },
            },
        },
        {
            camCoord = vector3(168.9, -2263.5, 4.8),
            camTarget = vector3(164.6, -2263.4, 2.3),
            entities = {
                {
                    type = "vehicle",
                    model = "dinghy",
                    coords = vector4(163.3, -2263.33, 0.11, 268.86),
                    color = { primary = 111, secondary = 111 }
                },
                {
                    type = "marker",
                    markerType = 20,
                    coords = vector4(163.3, -2263.33, 3.0, 0.0),
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
    -- lobbyAmount / playerAmount meaning: number of treasures loaded onto the boat
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

return TreasureHunterJob
