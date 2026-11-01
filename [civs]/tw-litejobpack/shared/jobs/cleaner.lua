local CleanerJob = {

    id = "cleaner",

    icon = "./img/jobs/cleaner_icon.svg",
    image = "./img/jobs/cleaner_bg.png",
    video = "https://tworst.info/uploads/videos/d5688926a101cb705ba04f43ff75623e_1775405582.mp4",
    enabled = true, -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0, -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(-229.5865, -1377.3341, 31.26, 209.6366),
        model = "s_m_m_gentransport",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 318,
            color = 3,
            scale = 0.8,
        },
    },

    xprewards = {
        stainCleaned = 30,
        jobCompleted = 500,
    },

    payment = {
        mode = "onJobEnd", -- "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        perStain = 75, -- pay per spot cleaned
        completionBonus = 0, -- bonus paid once when job is fully completed
        coopMode = "full", -- "full" = everyone gets full pay | "split" = pay divided by player count
    },

    stepRewards = {
        -- Available phases: onClean (stain/surface cleaned)
        onClean = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 10 }, { item = "water_bottle", count = 1, chance = 8 } } },
    },

    missioncompletedItems = {
        giveItemPlayer = false, -- true = give items on job complete | false = no items given
        dropMode = "weightedPool", -- "weightedPool" = pick one item by chance weight | "perItem" = each item rolls independently
        itemList = {
            { item = "sandwich",     count = 1, chance = 50 },
            { item = "water_bottle", count = 1, chance = 30 },
        },
    },

}

local runtime = {

    marker = {
        type = 20,
        scale = { x = 0.4, y = 0.4, z = 0.4 },
        color = { r = 230, g = 180, b = 50, a = 200 },
        drawDistance = 30.0,
        zOffset = 1.5,
        bob = true,
    },

    blip = {
        sprite = 1,
        color = 5,
        scale = 0.7,
        shortRange = true,
    },

    routes = {

        [1] = {
            name = "Pillbox Hill",
            requiredLevel = 1,
            coord = vector3(-282.82, -1104.82, 23.4),
            locations = {
                { coord = vector4(-282.82, -1104.82, 23.4, 66.42) },
                { coord = vector4(-288.17, -1098.44, 23.42, 66.42) },
                { coord = vector4(-274.89, -1080.01, 24.77, 311.98) },
                { coord = vector4(-262.36, -1041.25, 27.62, 336.73) },
                { coord = vector4(-218.86, -1021.92, 29.15, 319.86) },
                { coord = vector4(-198.44, -1015.27, 29.29, 195.96) },
                { coord = vector4(-265.99, -1064.03, 25.81, 105.77) },
                { coord = vector4(-295.13, -1126.82, 23.12, 128.32) },
                { coord = vector4(-339.5, -1122.64, 27.07, 82.72) },
                { coord = vector4(-259.91, -1166.58, 23.05, 182.31) },
                { coord = vector4(-261.58, -1215.41, 25.4, 218.95) },
            },
        },

        [2] = {
            name = "La Mesa",
            requiredLevel = 2,
            coord = vector3(482.28, -1536.80, 29.27),
            locations = {
                { coord = vector4(482.2822, -1536.7952, 29.2701, 335.3844) },
                { coord = vector4(470.1936, -1566.0829, 29.2826, 349.9083) },
                { coord = vector4(444.4032, -1577.4465, 29.2826, 88.9332) },
                { coord = vector4(452.7091, -1548.8308, 29.4329, 359.2648) },
                { coord = vector4(460.9600, -1543.1838, 29.2826, 2.5179) },
                { coord = vector4(498.6881, -1581.9633, 29.6016, 158.3911) },
                { coord = vector4(512.2963, -1611.8629, 29.3358, 149.2663) },
                { coord = vector4(494.5436, -1683.7089, 29.2698, 179.8349) },
                { coord = vector4(501.2144, -1710.5902, 29.3247, 178.8073) },
            },
        },

        [3] = {
            name = "Textile City",
            requiredLevel = 3,
            coord = vector3(314.32, -1098.90, 29.40),
            locations = {
                { coord = vector4(314.3246, -1098.8964, 29.4011, 255.4307) },
                { coord = vector4(312.1354, -1078.2047, 29.4058, 53.3719) },
                { coord = vector4(325.1300, -1071.7865, 29.4734, 139.7340) },
                { coord = vector4(305.5328, -1032.9426, 29.2094, 127.5648) },
                { coord = vector4(263.3745, -1068.6906, 29.4188, 161.9892) },
                { coord = vector4(286.0663, -1064.7683, 29.4187, 340.5598) },
                { coord = vector4(303.8794, -1035.6466, 29.0532, 343.2774) },
                { coord = vector4(328.3827, -1021.7993, 29.2783, 29.5842) },
                { coord = vector4(345.1715, -1033.5098, 29.3307, 143.3533) },
                { coord = vector4(386.2063, -1024.5127, 29.3981, 343.7742) },
                { coord = vector4(412.9038, -996.4557, 29.3897, 191.7900) },
                { coord = vector4(410.1230, -971.5308, 29.4240, 47.0358) },
            },
        },

        [4] = {
            name = "Vinewood Hills",
            requiredLevel = 4,
            coord = vector3(-995.78, 384.63, 73.06),
            locations = {
                { coord = vector4(-995.7831, 384.6340, 73.0584, 222.4424) },
                { coord = vector4(-973.4306, 400.1141, 75.5372, 225.6076) },
                { coord = vector4(-960.4079, 421.0269, 78.2861, 356.0251) },
                { coord = vector4(-896.2921, 419.6543, 85.6266, 251.2909) },
                { coord = vector4(-874.2616, 413.7719, 87.2255, 273.8853) },
                { coord = vector4(-844.4418, 387.8695, 87.4202, 277.1676) },
                { coord = vector4(-847.1588, 346.1046, 86.5547, 181.4067) },
                { coord = vector4(-847.1890, 292.0798, 86.4578, 75.4914) },
                { coord = vector4(-840.0163, 273.7943, 84.5848, 127.7167) },
                { coord = vector4(-858.4726, 250.1052, 74.7624, 289.8376) },
                { coord = vector4(-871.4509, 259.7094, 75.8838, 273.0835) },
                { coord = vector4(-896.2963, 257.1815, 71.2144, 332.3036) },
            },
        },
    },

    breakSession = {
        hitsRequired = 8,
        ballsPerSession = 4,
        ballSize = 0.15,
        repeatPerBall = 2,
    },

    mop = {
        model = "prop_cs_mop_s",
        bone = 28422,

        objcoord = { 28422, -0.02, -0.06, -0.2, -13.377, 10.3568, 17.9681 },

        idleOffset = {
            x = -0.02,
            y = -0.06,
            z = -0.2,
            rx = -13.377,
            ry = 10.3568,
            rz = 17.9681
        },
        idleAnim = {
            dict = "missfbi4prepp1",
            name = "idle",
        },

        cleanOffset = {
            x = 0.0,
            y = 0.0,
            z = 0.12,
            rx = 0.0,
            ry = 0.0,
            rz = 0.0
        },
        cleanAnim = {
            dict = "move_mop",
            name = "idle_scrub_small_player",
        },
    },

    interaction = {
        stainDistance = 1.5,
    },

    vehicle = {
        -- These spawn slots sit closer together than the default 7.0 clear
        -- radius (VehicleManager), which made one parked vehicle block every
        -- neighbouring slot and capped the job at one lobby at a time.
        -- Must stay BELOW the smallest slot-to-slot gap.
        spawnClearRadius = 3.0,
        spawnLocations = {
            vector4(-229.45, -1393.02, 30.79, 101.81),
            vector4(-228.94, -1396.14, 30.8, 100.56),
            vector4(-228.34, -1399.32, 30.81, 99.73),
            vector4(-227.77, -1402.49, 30.82, 98.93),
            vector4(-214.26, -1397.13, 30.8, 354.22),
            vector4(-211.02, -1395.83, 30.79, 359.17),
            vector4(-207.69, -1394.23, 30.78, 357.33)
        },
        model = "bison",
        color = { primary = 111, secondary = 36 },
        plate = "CLEAN",
        useCustomPlate = false,
        fuelOnSpawn = 100.0,

        toolPositions = {
            { offset = vector3(-0.78, -2.2, 0.94), rotation = vector3(0.90, -210.0, 90.0) },
            { offset = vector3(-0.78, -1.7, 0.94), rotation = vector3(0.90, -210.0, 90.0) },
            { offset = vector3(0.78, -1.7, 0.97),  rotation = vector3(0.90, -160.0, 90.0) },
            { offset = vector3(0.78, -2.2, 0.97),  rotation = vector3(0.90, -160.0, 90.0) },
        },
    },

    finishArea = {
        coord = vector4(-232.8741, -1384.2105, 30.2582, 30.0),
        interactDistance = 5.0,
    },

    workClothes = {
        coord = vector4(-226.83, -1373.70, 30.275, 30.33),
    },
}

CleanerJob.runtime = runtime

CleanerJob.preview = {
    playerPosition = vector3(-229.6, -1377.3, 31.26),
    vehicleStep = 3,
    steps = {

        {
            camCoord = vector3(-227.6, -1380.5, 32.5),
            camTarget = vector3(-230.1, -1376.5, 31.0),
        },

        {
            autoClothes = true,
            camCoord = vector3(-224.7, -1377.2, 33.2),
            camTarget = vector3(-226.9, -1373.5, 30.6),
        },

        {
            autoVehicle = true,
            autoTools = "mop",
            camCoord = vector3(-225.8, -1391.8, 33.4),
            camTarget = vector3(-229.9, -1392.6, 30.7),
        },

        {
            camCoord = vector3(-279.5, -1107.5, 25.0),
            camTarget = vector3(-282.82, -1104.82, 23.9),
            entities = {
                {
                    type = "vehicle",
                    model = runtime.vehicle.model,
                    coords = vector4(-280.0, -1108.0, 23.4, 66.42),
                    color = runtime.vehicle.color,
                    openDoors = {},
                    persist = true
                },
                { type = "marker", markerType = 20,                                 coords = vector4(-282.82, -1104.82, 24.9, 0.0),  scale = vector3(0.4, 0.4, 0.4), color = { r = 230, g = 180, b = 50, a = 200 }, bob = true },
                { type = "marker", markerType = 20,                                 coords = vector4(-288.17, -1098.44, 24.92, 0.0), scale = vector3(0.4, 0.4, 0.4), color = { r = 230, g = 180, b = 50, a = 200 }, bob = true },
                { type = "decal",  coords = vector4(-282.82, -1104.82, 23.4, 0.0),  normal = vector3(0.0, 0.0, 1.0),                 decalType = 1030,               splatsMin = 8,                                 splatsMax = 12, offset = 0.30, sizeMin = 0.25, sizeMax = 0.45, alpha = 0.95, r = 0.0, g = 0.0, b = 0.0 },
                { type = "decal",  coords = vector4(-288.17, -1098.44, 23.42, 0.0), normal = vector3(0.0, 0.0, 1.0),                 decalType = 1030,               splatsMin = 8,                                 splatsMax = 12, offset = 0.30, sizeMin = 0.25, sizeMax = 0.45, alpha = 0.95, r = 0.0, g = 0.0, b = 0.0 },
                { type = "decal",  coords = vector4(-274.89, -1080.01, 24.77, 0.0), normal = vector3(0.0, 0.0, 1.0),                 decalType = 1030,               splatsMin = 8,                                 splatsMax = 12, offset = 0.30, sizeMin = 0.25, sizeMax = 0.45, alpha = 0.95, r = 0.0, g = 0.0, b = 0.0 },
            },
        },

        {
            lockDuration = 3500,
            camCoord = vector3(-285.5, -1101.0, 25.0),
            camTarget = vector3(-282.82, -1104.82, 23.9),
            entities = {
                {
                    type = "ped",
                    model = "s_m_m_gentransport",
                    coords = vector4(-282.82, -1104.82, 23.4, 66.42),
                    anim = { dict = runtime.mop.cleanAnim.dict, name = runtime.mop.cleanAnim.name, flag = 1 },
                    persist = false
                },
                {
                    type = "prop",
                    model = runtime.mop.model,
                    attachTo = 1,
                    attachBone = runtime.mop.bone,
                    attachOffset = vector3(-0.02, -0.06, -0.2),
                    attachRotation = vector3(-13.377, 10.3568, 17.9681),
                    persist = false
                },
                { type = "decal", coords = vector4(-282.82, -1104.82, 23.4, 0.0), normal = vector3(0.0, 0.0, 1.0), decalType = 1030, splatsMin = 3, splatsMax = 5, offset = 0.15, sizeMin = 0.10, sizeMax = 0.20, alpha = 0.4, r = 0.0, g = 0.0, b = 0.0 },
            },
        },

        {
            camCoord = vector3(-229.5, -1387.0, 32.5),
            camTarget = vector3(-232.87, -1384.21, 30.76),
            entities = {
                {
                    type = "vehicle",
                    model = runtime.vehicle.model,
                    coords = vector4(-232.87, -1384.21, 29.76, 30.0),
                    color = runtime.vehicle.color,
                    openDoors = {}
                },
                { type = "marker", markerType = 20, coords = vector4(runtime.finishArea.coord.x, runtime.finishArea.coord.y, runtime.finishArea.coord.z + 1.5, 0.0), scale = vector3(0.5, 0.5, 0.5), color = { r = 230, g = 180, b = 50, a = 200 }, bob = true, rotate = true },
            },
        },
    },
}

CleanerJob.clothes = {
    male = {
        tshirt_1 = 15,
        tshirt_2 = 0,
        torso_1 = 16,
        torso_2 = 0,
        decals_1 = 0,
        decals_2 = 0,
        arms = 0,
        pants_1 = 89,
        pants_2 = 21,
        shoes_1 = 25,
        shoes_2 = 0,
        chain_1 = 0,
        chain_2 = 0,
        helmet_1 = -1,
        helmet_2 = 0,
    },
    female = {
        tshirt_1 = 14,
        tshirt_2 = 0,
        torso_1 = 0,
        torso_2 = 0,
        decals_1 = 0,
        decals_2 = 0,
        arms = 0,
        pants_1 = 92,
        pants_2 = 24,
        shoes_1 = 10,
        shoes_2 = 1,
        chain_1 = -1,
        chain_2 = 0,
        helmet_1 = -1,
        helmet_2 = 0,
    },
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.startJobFunction)
-- Return true to allow the player to start, false to prevent
CleanerJob.startJobFunction = {
    enabled = false, -- true = enable start check for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId)
        return true
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.endJobFunction)
-- lobbyAmount / playerAmount meaning: number of stains cleaned
CleanerJob.endJobFunction = {
    enabled = false, -- true = enable end function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.resetJobFunction)
-- Called when the job is cancelled (owner/member leaves mid-job, lobby disbanded, etc.)
CleanerJob.resetJobFunction = {
    enabled = false, -- true = enable reset function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

return CleanerJob
