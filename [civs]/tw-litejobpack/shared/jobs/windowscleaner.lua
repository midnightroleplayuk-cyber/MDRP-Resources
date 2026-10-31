local WindowCleanerJob = {

    id = "windowscleaner",

    icon = "./img/jobs/windowscleaner_icon.svg",
    image = "./img/jobs/windowscleaner_bg.png",
    video = "https://tworst.info/uploads/videos/3f21c8446ea19288e915acf492f1e4ec_1775405646.mp4",
    enabled = true, -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0, -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(-570.9614, -1775.8206, 23.1804, 153.3054),
        model = "s_m_m_gentransport",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 473,
            color = 3,
            scale = 0.8,
        },
    },

    xprewards = {
        windowCleaned = 30,
        jobCompleted = 500,
    },

    payment = {
        mode = "onJobEnd", -- "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        perWindow = 80, -- pay per window cleaned
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
        color = { r = 50, g = 150, b = 230, a = 200 },
        drawDistance = 30.0,
        zOffset = 1.5,
        normalOffset = 0.8,
        bob = true,
    },

    blip = {
        sprite = 1,
        color = 3,
        scale = 0.7,
        shortRange = true,
    },

    breakSession = {
        hitsRequired = 8,
        ballsPerSession = 4,
        ballSize = 0.15,
        repeatPerBall = 2,
    },

    routes = {

        [1] = {
            name = "Vespucci Beach",
            requiredLevel = 1,
            coord = vector3(-1385.64, -1053.75, 4.75),
            locations = {
                { coord = vector4(-1385.6398, -1053.7527, 4.7469, 326.8), normal = vector3(-0.867, -0.498, 0.000) },
                { coord = vector4(-1383.6605, -1057.1960, 4.8019, 216.0), normal = vector3(-0.867, -0.498, 0.000) },
                { coord = vector4(-1381.3037, -1061.2965, 4.8044, 212.5), normal = vector3(-0.867, -0.498, 0.000) },
                { coord = vector4(-1378.9795, -1065.3402, 4.7956, 254.9), normal = vector3(-0.867, -0.498, 0.000) },
                { coord = vector4(-1376.1427, -1070.2756, 4.8386, 291.6), normal = vector3(-0.867, -0.498, 0.000) },
                { coord = vector4(-1374.3156, -1073.4547, 4.8109, 227.9), normal = vector3(-0.867, -0.498, 0.000) },
            },
        },

        [2] = {
            name = "Vespucci Canals",
            requiredLevel = 2,
            coord = vector3(-1587.57, -1005.90, 13.62),
            locations = {
                { coord = vector4(-1587.5737, -1005.9008, 13.6245, 50.7), normal = vector3(0.766, -0.643, 0.000) },
                { coord = vector4(-1586.5706, -1004.7051, 13.6095, 60.6), normal = vector3(0.766, -0.643, 0.000) },
                { coord = vector4(-1585.6998, -1003.6672, 13.6461, 57.8), normal = vector3(0.766, -0.643, 0.000) },
                { coord = vector4(-1584.7426, -1002.5261, 13.6601, 48.5), normal = vector3(0.766, -0.643, 0.000) },
                { coord = vector4(-1583.8040, -1001.4073, 13.6526, 53.6), normal = vector3(0.766, -0.643, 0.000) },
                { coord = vector4(-1582.9775, -1000.4224, 13.6505, 46.7), normal = vector3(0.766, -0.643, 0.000) },
                { coord = vector4(-1582.0297, -999.2925, 13.6601, 18.0), normal = vector3(0.766, -0.643, 0.000) },
                { coord = vector4(-1581.0547, -998.1304, 13.6541, 64.9), normal = vector3(0.766, -0.643, 0.000) },
                { coord = vector4(-1580.2767, -997.2031, 13.6756, 36.8), normal = vector3(0.766, -0.643, 0.000) },
                { coord = vector4(-1579.2727, -995.9054, 13.6834, 61.5), normal = vector3(0.765, -0.644, -0.001) },
                { coord = vector4(-1578.4843, -994.9700, 13.6966, 33.4), normal = vector3(0.765, -0.644, -0.001) },
                { coord = vector4(-1577.7594, -994.1100, 13.7012, 12.9), normal = vector3(0.765, -0.644, -0.001) },
                { coord = vector4(-1576.9849, -993.1910, 13.7130, 46.9), normal = vector3(0.765, -0.644, -0.001) },
                { coord = vector4(-1576.1248, -992.1706, 13.7152, 42.8), normal = vector3(0.765, -0.644, -0.001) },
                { coord = vector4(-1575.3214, -991.2177, 13.6989, 43.7), normal = vector3(0.765, -0.644, -0.001) },
                { coord = vector4(-1574.7560, -990.5468, 13.6599, 34.6), normal = vector3(0.765, -0.644, -0.001) },
                { coord = vector4(-1573.8779, -989.5051, 13.6967, 39.5), normal = vector3(0.765, -0.644, -0.001) },
                { coord = vector4(-1573.0945, -988.5756, 13.6823, 42.2), normal = vector3(0.765, -0.644, -0.001) },
                { coord = vector4(-1572.3445, -987.6858, 13.6733, 23.4), normal = vector3(0.765, -0.644, -0.001) },
                { coord = vector4(-1573.2677, -985.8879, 13.6902, 135.7), normal = vector3(0.643, 0.766, -0.000) },
                { coord = vector4(-1574.2251, -985.0848, 13.6951, 111.6), normal = vector3(0.643, 0.766, -0.000) },
                { coord = vector4(-1572.4612, -986.5646, 13.6659, 143.6), normal = vector3(0.643, 0.766, -0.000) },
            },
        },

        [3] = {
            name = "Burton",
            requiredLevel = 3,
            coord = vector3(-1037.66, 312.03, 67.42),
            locations = {
                { coord = vector4(-1037.66, 312.03, 67.42, 341.1), normal = vector3(-0.323, 0.946, 0.000) },
                { coord = vector4(-1039.15, 311.52, 67.53, 341.1), normal = vector3(-0.323, 0.946, 0.000) },
                { coord = vector4(-1052.02, 304.86, 67.17, 251.2), normal = vector3(-0.947, -0.323, 0.000) },
                { coord = vector4(-1038.94, 299.71, 67.57, 161.1), normal = vector3(0.323, -0.946, 0.000) },
                { coord = vector4(-1036.41, 300.58, 67.56, 161.1), normal = vector3(0.323, -0.946, 0.000) },
                { coord = vector4(-1032.98, 301.75, 67.64, 161.1), normal = vector3(0.323, -0.946, 0.000) },
                { coord = vector4(-1030.43, 302.62, 67.50, 161.1), normal = vector3(0.323, -0.946, 0.000) },
                { coord = vector4(-1027.07, 313.29, 67.24, 71.1),  normal = vector3(0.946, 0.323, 0.000) },
            },
        },

        [4] = {
            name = "Rockford Hills",
            requiredLevel = 4,
            coord = vector3(-1131.30, 372.85, 71.22),
            locations = {
                { coord = vector4(-1131.30, 372.85, 71.22, 31.2),  normal = vector3(0.517, 0.856, 0.000) },
                { coord = vector4(-1130.16, 372.16, 71.17, 31.2),  normal = vector3(0.517, 0.856, 0.000) },
                { coord = vector4(-1126.16, 368.00, 71.37, 31.2),  normal = vector3(0.517, 0.856, 0.000) },
                { coord = vector4(-1123.22, 366.23, 71.42, 31.2),  normal = vector3(0.517, 0.856, 0.000) },
                { coord = vector4(-1121.87, 365.41, 71.31, 31.2),  normal = vector3(0.517, 0.856, 0.000) },
                { coord = vector4(-1120.37, 362.57, 71.25, 121.2), normal = vector3(0.856, -0.517, 0.000) },
                { coord = vector4(-1123.18, 357.93, 71.37, 121.2), normal = vector3(0.856, -0.517, 0.000) },
                { coord = vector4(-1131.36, 363.17, 71.91, 211.2), normal = vector3(-0.517, -0.856, 0.000) },
                { coord = vector4(-1132.85, 364.07, 71.86, 211.2), normal = vector3(-0.517, -0.856, 0.000) },
                { coord = vector4(-1129.86, 360.61, 71.93, 301.0), normal = vector3(-0.857, 0.516, 0.000) },
                { coord = vector4(-1142.69, 382.70, 71.48, 301.2), normal = vector3(-0.856, 0.517, 0.000) },
                { coord = vector4(-1144.66, 379.44, 71.52, 301.2), normal = vector3(-0.856, 0.517, 0.000) },
                { coord = vector4(-1143.75, 380.94, 71.53, 301.2), normal = vector3(-0.856, 0.517, 0.000) },
                { coord = vector4(-1149.54, 374.32, 71.61, 301.1), normal = vector3(-0.856, 0.517, 0.000) },
                { coord = vector4(-1148.23, 370.38, 71.66, 211.2), normal = vector3(-0.518, -0.856, 0.000) },
                { coord = vector4(-1146.83, 369.53, 71.71, 211.2), normal = vector3(-0.518, -0.856, 0.000) },
                { coord = vector4(-1142.75, 366.28, 71.51, 211.2), normal = vector3(-0.518, -0.856, 0.000) },
                { coord = vector4(-1141.37, 365.44, 71.49, 211.2), normal = vector3(-0.518, -0.856, 0.000) },
                { coord = vector4(-1140.11, 364.68, 71.60, 211.2), normal = vector3(-0.518, -0.856, 0.000) },
                { coord = vector4(-1146.52, 373.30, 75.17, 211.2), normal = vector3(-0.518, -0.856, 0.000) },
                { coord = vector4(-1143.80, 371.66, 75.17, 211.2), normal = vector3(-0.518, -0.856, 0.000) },
                { coord = vector4(-1142.76, 371.03, 75.25, 211.2), normal = vector3(-0.518, -0.856, 0.000) },
                { coord = vector4(-1140.83, 369.86, 75.26, 211.2), normal = vector3(-0.518, -0.856, 0.000) },
                { coord = vector4(-1138.59, 368.51, 75.17, 211.2), normal = vector3(-0.518, -0.856, 0.000) },
                { coord = vector4(-1135.61, 364.38, 75.24, 211.2), normal = vector3(-0.518, -0.856, 0.000) },
                { coord = vector4(-1134.02, 363.41, 75.19, 211.2), normal = vector3(-0.518, -0.856, 0.000) },
                { coord = vector4(-1132.25, 362.35, 75.21, 211.2), normal = vector3(-0.518, -0.856, 0.000) },
                { coord = vector4(-1125.63, 358.34, 75.27, 211.2), normal = vector3(-0.518, -0.856, 0.000) },
            },
        },

        [5] = {
            name = "Strawberry",
            requiredLevel = 5,
            coord = vector3(-262.10, -2034.91, 30.52),
            locations = {
                { coord = vector4(-262.10, -2034.91, 30.52, 140.9), normal = vector3(0.631, -0.776, 0.000) },
                { coord = vector4(-267.37, -2038.67, 30.39, 147.5), normal = vector3(0.538, -0.843, 0.000) },
                { coord = vector4(-273.07, -2041.90, 30.43, 153.4), normal = vector3(0.447, -0.894, 0.000) },
                { coord = vector4(-259.61, -2032.31, 30.33, 130.1), normal = vector3(0.765, -0.645, 0.000) },
                { coord = vector4(-256.31, -2028.38, 30.41, 130.1), normal = vector3(0.765, -0.643, 0.000) },
                { coord = vector4(-252.92, -2024.34, 30.39, 130.0), normal = vector3(0.766, -0.643, 0.000) },
                { coord = vector4(-248.01, -2017.99, 30.52, 119.1), normal = vector3(0.874, -0.487, 0.000) },
                { coord = vector4(-245.22, -2012.03, 30.57, 112.5), normal = vector3(0.924, -0.383, 0.000) },
                { coord = vector4(-243.25, -2006.45, 30.54, 106.6), normal = vector3(0.958, -0.285, 0.000) },
            },
        },
    },

    decal = {
        type = 1030,
        splatsMin = 6,
        splatsMax = 10,
        offset = 0.25,
        sizeMin = 0.45,
        sizeMax = 0.70,
        alpha = 0.95,
        color = { r = 0.0, g = 0.0, b = 0.0 },
    },

    particles = {
        enabled = true,
        asset = "core",
        name = "water_splash_obj_in",
        scale = 0.5,
        duration = 2000,
    },

    tool = {
        prop = "prop_sponge_01",

        objcoord = { 28422, 0.1, 0.0, -0.03, 90.0, 0.0, 0.0 },
        objcoord2 = { 28422, 0.01, 0.05, -0.02, 130.0, 0.0, 0.0 },

        animation_action = { "amb@world_human_maid_clean@", "base", 3000 },
        particles = "",
    },

    fallbackAnims = {
        idle = nil,
        action = { dict = "amb@world_human_maid_clean@", name = "base" },
    },

    interaction = {
        windowDistance = 2.0,
        cleanDuration = 3000,
    },

    vehicle = {
        -- Spawn points MUST be spaced further apart than the spawn-block radius (7.0,
        -- hardcoded in VehicleManager). The originals were ~6u apart, so one parked van
        -- sat inside the 7.0 radius of the other two slots — and FindAvailableSpawnPoint
        -- always fills slot 1 first, which then overlaps slots 2 & 3. Net effect:
        -- effective capacity = 1, so only one player could ever start at a time and a
        -- leaked/abandoned van (reconnect grace ~5-10 min) blocked everyone. Respaced to
        -- ~9u along the same parking row → all pairwise distances > 7.0.
        spawnLocations = {
            vector4(-586.9118, -1791.0530, 22.8388, 134.3930),
            vector4(-593.21, -1784.63, 22.8388, 134.3930),
            vector4(-580.61, -1797.47, 22.8388, 134.3930),
        },
        model = "burrito",
        color = { primary = 111, secondary = 42 },
        plate = "WNDCLEAN",
        useCustomPlate = false,
        fuelOnSpawn = 100.0,
        trunkDoors = {},

        toolPositions = {
            { offset = vector3(-0.58, -1.2, 0.54),  rotation = vector3(0.90, -90.0, 90.0) },
            { offset = vector3(-0.58, -1.05, 0.54), rotation = vector3(0.90, -90.0, 90.0) },
            { offset = vector3(0.55, -1.2, 0.59),   rotation = vector3(0.90, -90.0, 90.0) },
            { offset = vector3(0.55, -1.05, 0.59),  rotation = vector3(0.90, -90.0, 90.0) },
        },
    },

    finishArea = {
        coord = vector4(-586.3, -1772.81, 22.45, 201.63),
        interactDistance = 5.0,
    },

    workClothes = {
        coord = vector4(-577.540, -1775.130, 21.350, -36.330),
    },
}

WindowCleanerJob.runtime = runtime

WindowCleanerJob.preview = {
    playerPosition = vector3(-571.0, -1775.8, 23.18),
    vehicleStep = 3,
    steps = {

        {
            camCoord = vector3(-572.5, -1777.8, 24.3),
            camTarget = vector3(-569.5, -1773.9, 23.1),
        },

        {
            autoClothes = true,
            camCoord = vector3(-580.1, -1778.2, 24.3),
            camTarget = vector3(-577.4, -1775.0, 21.7),
        },

        {
            autoVehicle = true,
            autoTools = { model = runtime.tool.prop },
            camCoord = vector3(-583.3, -1787.5, 23.6),
            camTarget = vector3(-586.8, -1791.0, 23.3),
        },

        {
            camCoord = vector3(-1388.0, -1052.0, 6.0),
            camTarget = vector3(-1383.7, -1057.2, 5.0),
            entities = {
                { type = "marker", markerType = 20, coords = vector4(-1385.64, -1053.75, 6.25, 0.0), scale = vector3(0.4, 0.4, 0.4), color = { r = 50, g = 150, b = 230, a = 200 }, bob = true },
                { type = "marker", markerType = 20, coords = vector4(-1383.66, -1057.20, 6.30, 0.0), scale = vector3(0.4, 0.4, 0.4), color = { r = 50, g = 150, b = 230, a = 200 }, bob = true },
                { type = "marker", markerType = 20, coords = vector4(-1381.30, -1061.30, 6.30, 0.0), scale = vector3(0.4, 0.4, 0.4), color = { r = 50, g = 150, b = 230, a = 200 }, bob = true },
                { type = "decal",  coords = vector4(-1385.6398, -1053.7527, 4.7469, 326.8), normal = runtime.routes[1].locations[1].normal, decalType = 1030, splatsMin = 6, splatsMax = 10, offset = 0.25, sizeMin = 0.45, sizeMax = 0.70, alpha = 0.95, r = 0.0, g = 0.0, b = 0.0 },
                { type = "decal",  coords = vector4(-1383.6605, -1057.1960, 4.8019, 216.0), normal = runtime.routes[1].locations[2].normal, decalType = 1030, splatsMin = 6, splatsMax = 10, offset = 0.25, sizeMin = 0.45, sizeMax = 0.70, alpha = 0.95, r = 0.0, g = 0.0, b = 0.0 },
                { type = "decal",  coords = vector4(-1381.3037, -1061.2965, 4.8044, 212.5), normal = runtime.routes[1].locations[3].normal, decalType = 1030, splatsMin = 6, splatsMax = 10, offset = 0.25, sizeMin = 0.45, sizeMax = 0.70, alpha = 0.95, r = 0.0, g = 0.0, b = 0.0 },
            },
        },

        {
            lockDuration = 3500,
            camCoord = vector3(-1387.5, -1052.5, 5.8),
            camTarget = vector3(-1384.0, -1054.0, 5.0),
            entities = {
                {
                    type = "ped",
                    model = "s_m_m_gentransport",
                    coords = vector4(-1385.9, -1053.5, 3.35, 236.8),
                    rawZ = true,
                    faceCoord = vector3(-1385.64, -1053.75, 4.75),
                    anim = { dict = "amb@world_human_maid_clean@", name = "base", flag = 1 },
                },
                {
                    type = "prop",
                    model = runtime.tool.prop,
                    attachTo = 1,
                    attachBone = 28422,
                    attachOffset = vector3(0.1, 0.0, -0.03),
                    attachRotation = vector3(90.0, 0.0, 0.0),
                },
                { type = "decal", coords = vector4(-1383.6605, -1057.1960, 4.8019, 216.0), normal = runtime.routes[1].locations[2].normal, decalType = 1030, splatsMin = 3, splatsMax = 5, offset = 0.15, sizeMin = 0.25, sizeMax = 0.40, alpha = 0.4, r = 0.0, g = 0.0, b = 0.0 },
            },
        },

        {
            camCoord = vector3(-584.5, -1777.5, 24.2),
            camTarget = vector3(-586.2, -1773.0, 23.0),
            entities = {
                {
                    type = "vehicle",
                    model = runtime.vehicle.model,
                    coords = vector4(-586.3, -1772.81, 21.95, 201.63),
                    color = runtime.vehicle.color,
                    openDoors = {}
                },
                { type = "marker", markerType = 20, coords = vector4(-586.3, -1772.81, 24.0, 0.0), scale = vector3(0.5, 0.5, 0.5), color = { r = 230, g = 180, b = 50, a = 200 }, bob = true, rotate = true },
            },
        },
    },
}

WindowCleanerJob.clothes = {
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
        shoes_1 = 7,
        shoes_2 = 1,
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
WindowCleanerJob.startJobFunction = {
    enabled = false, -- true = enable start check for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId)
        return true
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.endJobFunction)
-- lobbyAmount / playerAmount meaning: number of windows cleaned
WindowCleanerJob.endJobFunction = {
    enabled = false, -- true = enable end function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.resetJobFunction)
-- Called when the job is cancelled (owner/member leaves mid-job, lobby disbanded, etc.)
WindowCleanerJob.resetJobFunction = {
    enabled = false, -- true = enable reset function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

return WindowCleanerJob
