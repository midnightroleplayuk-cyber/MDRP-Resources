local PowerwashJob = {

    id = "powerwash",

    icon = "./img/jobs/powerwash_icon.svg",
    image = "./img/jobs/powerwash_bg.png",
    video = "https://tworst.info/uploads/videos/b295ba55a8dd946c1f112205c45fc82b_1775405625.mp4",
    enabled = true, -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0, -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(890.3691, -1028.1973, 35.1136, 3.8060),
        model = "s_m_m_gentransport",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 566,
            color = 3,
            scale = 0.8,
        },
    },

    xprewards = {
        stainCleaned = 35,
        jobCompleted = 600,
    },

    payment = {
        mode = "onJobEnd", -- "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        perStain = 100, -- pay per spot cleaned
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
        color = { r = 52, g = 152, b = 219, a = 200 },
        drawDistance = 30.0,
        zOffset = 1.5,
        bob = true,
    },

    blip = {
        sprite = 1,
        color = 3,
        scale = 0.7,
        shortRange = true,
    },

    spray = {
        -- Spatial cleaning: the jet erases the splats it actually lands on, so
        -- progress is coverage, not repetitions. brushRadius is the erase radius
        -- in metres on the stain surface; coverageFactor pads the disc-count math
        -- the server uses to decide when a stain counts as fully washed
        -- (higher = more thorough sweeping required).
        brushRadius = 0.16,
        coverageFactor = 1.8,
        hitInterval = 120,
        maxDistance = 0.8,
        raycastDistance = 10.0,
        interactDistance = 5.0,
    },

    routes = {

        [1] = {
            name = "Mirror Park",
            requiredLevel = 1,
            coord = vector3(969.86, -701.47, 58.83),
            locations = {
                { coord = vector4(974.7936, -700.0529, 58.5581, 138.2), normal = vector3(0.810, 0.587, -0.005) },
                { coord = vector4(967.8981, -698.7702, 58.6804, 126.2), normal = vector3(0.809, 0.588, -0.000) },
                { coord = vector4(969.7049, -691.7129, 58.4317, 21.5), normal = vector3(0.629, -0.777, 0.000) },
                { coord = vector4(969.7738, -688.8948, 58.3551, 88.4), normal = vector3(0.777, 0.629, -0.000) },
                { coord = vector4(963.5042, -694.0102, 58.4614, 350.1), normal = vector3(-0.777, -0.629, 0.000) },
                { coord = vector4(960.4695, -701.2255, 58.8420, 212.5), normal = vector3(-0.588, 0.809, -0.000) },
                { coord = vector4(960.6542, -706.1496, 58.8601, 307.8), normal = vector3(-0.809, -0.588, 0.000) },
                { coord = vector4(963.9529, -710.6946, 60.6238, 269.1), normal = vector3(-0.809, -0.588, -0.001) },
                { coord = vector4(964.9952, -712.1247, 58.7522, 271.6), normal = vector3(-0.809, -0.588, 0.000) },
                { coord = vector4(968.2051, -710.8763, 58.6499, 15.0), normal = vector3(0.588, -0.809, 0.000) },
                { coord = vector4(971.6350, -708.3845, 58.6956, 356.8), normal = vector3(0.588, -0.809, 0.000) },
                { coord = vector4(976.4615, -704.8841, 58.7754, 15.2), normal = vector3(0.587, -0.810, -0.000) },
                { coord = vector4(977.2327, -701.2665, 58.8194, 115.2), normal = vector3(0.809, 0.588, 0.000) },
                { coord = vector4(969.8617, -701.4730, 59.8291, 143.8), normal = vector3(0.809, 0.588, -0.000) },
                { coord = vector4(968.0789, -693.0297, 58.3009, 37.0), normal = vector3(0.629, -0.777, 0.000) },
            },
        },

        [2] = {
            name = "Rockford Hills",
            requiredLevel = 2,
            coord = vector3(-1084.34, 465.49, 78.29),
            locations = {
                { coord = vector4(-1084.34, 465.49, 78.29, 213.4), normal = vector3(-0.551, -0.835, 0.000) },
                { coord = vector4(-1086.12, 466.67, 78.15, 213.4), normal = vector3(-0.551, -0.835, 0.000) },
                { coord = vector4(-1087.87, 467.82, 78.26, 213.4), normal = vector3(-0.551, -0.835, 0.000) },
                { coord = vector4(-1090.69, 469.68, 78.33, 213.4), normal = vector3(-0.551, -0.835, 0.000) },
                { coord = vector4(-1088.51, 477.39, 78.02, 303.4), normal = vector3(-0.835, 0.551, 0.000) },
                { coord = vector4(-1081.76, 466.38, 78.24, 123.4), normal = vector3(0.835, -0.551, 0.000) },
                { coord = vector4(-1080.46, 468.34, 78.24, 123.4), normal = vector3(0.835, -0.551, 0.000) },
                { coord = vector4(-1079.24, 470.19, 78.30, 123.4), normal = vector3(0.835, -0.551, 0.000) },
            },
        },

        [3] = {
            name = "Burton",
            requiredLevel = 3,
            coord = vector3(-1053.04, 225.38, 63.97),
            locations = {
                { coord = vector4(-1053.04, 225.38, 63.97, 180.0), normal = vector3(0.000, -1.000, 0.000) },
                { coord = vector4(-1048.03, 225.38, 64.08, 180.0), normal = vector3(0.000, -1.000, 0.000) },
                { coord = vector4(-1038.97, 218.78, 64.30, 269.2), normal = vector3(-1.000, -0.014, 0.000) },
                { coord = vector4(-1036.51, 214.03, 64.37, 179.2), normal = vector3(0.014, -1.000, 0.000) },
                { coord = vector4(-1032.80, 208.54, 64.77, 269.0), normal = vector3(-1.000, -0.017, 0.000) },
                { coord = vector4(-1025.68, 210.98, 64.11, 89.0),  normal = vector3(1.000, 0.017, 0.000) },
                { coord = vector4(-1025.72, 213.68, 66.29, 89.0),  normal = vector3(1.000, 0.017, 0.000) },
                { coord = vector4(-1026.33, 229.93, 65.86, 90.4),  normal = vector3(1.000, -0.006, 0.000) },
                { coord = vector4(-1026.30, 234.07, 64.16, 90.4),  normal = vector3(1.000, -0.006, 0.000) },
                { coord = vector4(-1027.35, 236.75, 64.79, 90.0),  normal = vector3(1.000, -0.001, 0.000) },
                { coord = vector4(-1032.37, 238.93, 65.37, 0.0),   normal = vector3(0.001, 1.000, 0.000) },
                { coord = vector4(-1040.33, 238.11, 64.47, 270.0), normal = vector3(-1.000, 0.001, 0.000) },
                { coord = vector4(-1050.84, 234.54, 64.29, 360.0), normal = vector3(0.000, 1.000, 0.000) },
                { coord = vector4(-1053.84, 230.81, 64.46, 270.0), normal = vector3(-1.000, 0.000, 0.000) },
                { coord = vector4(-1053.84, 227.85, 64.75, 270.0), normal = vector3(-1.000, 0.000, 0.000) },
            },
        },

        [4] = {
            name = "Tataviam Mountains",
            requiredLevel = 4,
            coord = vector3(1339.38, -612.69, 75.10),
            locations = {
                { coord = vector4(1339.38, -612.69, 75.10, 126.0), normal = vector3(0.809, -0.588, 0.000) },
                { coord = vector4(1341.19, -610.20, 76.27, 126.0), normal = vector3(0.809, -0.588, 0.000) },
                { coord = vector4(1344.24, -606.00, 76.26, 126.0), normal = vector3(0.809, -0.588, 0.000) },
                { coord = vector4(1344.33, -604.69, 74.11, 36.0),  normal = vector3(0.588, 0.809, 0.000) },
                { coord = vector4(1339.20, -593.16, 75.20, 36.6),  normal = vector3(0.596, 0.803, 0.000) },
                { coord = vector4(1333.68, -597.04, 75.08, 306.0), normal = vector3(-0.809, 0.588, 0.000) },
                { coord = vector4(1330.64, -601.22, 75.05, 306.0), normal = vector3(-0.809, 0.588, 0.000) },
                { coord = vector4(1328.17, -604.62, 76.50, 306.0), normal = vector3(-0.809, 0.588, 0.000) },
                { coord = vector4(1329.22, -606.70, 74.45, 216.0), normal = vector3(-0.588, -0.809, 0.000) },
                { coord = vector4(1333.70, -609.95, 76.87, 216.0), normal = vector3(-0.588, -0.809, 0.000) },
                { coord = vector4(1336.92, -612.29, 74.12, 216.0), normal = vector3(-0.588, -0.809, 0.000) },
            },
        },

        [5] = {
            name = "Strawberry",
            requiredLevel = 5,
            coord = vector3(-300.28, -1899.18, 30.31),
            locations = {
                { coord = vector4(-300.28, -1899.18, 30.31, 40.1),  normal = vector3(0.644, 0.765, 0.000) },
                { coord = vector4(-294.70, -1903.86, 30.47, 40.0),  normal = vector3(0.643, 0.766, 0.000) },
                { coord = vector4(-284.46, -1911.14, 29.69, 40.0),  normal = vector3(0.643, 0.766, 0.000) },
                { coord = vector4(-276.45, -1919.00, 29.91, 310.0), normal = vector3(-0.766, 0.643, 0.000) },
                { coord = vector4(-274.09, -1919.84, 32.94, 40.0),  normal = vector3(0.643, 0.766, 0.000) },
                { coord = vector4(-271.97, -1922.93, 31.76, 40.0),  normal = vector3(0.643, 0.766, 0.000) },
                { coord = vector4(-284.53, -1913.74, 31.54, 130.0), normal = vector3(0.766, -0.643, 0.000) },
                { coord = vector4(-293.89, -1905.84, 32.62, 130.0), normal = vector3(0.766, -0.643, 0.000) },
                { coord = vector4(-299.60, -1901.22, 31.99, 130.1), normal = vector3(0.765, -0.644, 0.000) },
                { coord = vector4(-301.63, -1899.51, 31.70, 310.1), normal = vector3(-0.765, 0.644, 0.000) },
                { coord = vector4(-265.92, -1927.98, 30.91, 39.1),  normal = vector3(0.630, 0.776, 0.000) },
                { coord = vector4(-262.06, -1932.35, 30.98, 310.0), normal = vector3(-0.766, 0.643, 0.000) },
                { coord = vector4(-256.58, -1937.17, 29.83, 313.0), normal = vector3(-0.731, 0.682, 0.000) },
                { coord = vector4(-254.70, -1937.44, 32.00, 43.0),  normal = vector3(0.682, 0.731, 0.000) },
                { coord = vector4(-249.92, -1942.39, 30.67, 49.0),  normal = vector3(0.755, 0.656, 0.000) },
                { coord = vector4(-249.64, -1944.19, 29.53, 139.0), normal = vector3(0.656, -0.755, 0.000) },
                { coord = vector4(-245.30, -1948.28, 29.62, 55.0),  normal = vector3(0.819, 0.574, 0.000) },
                { coord = vector4(-246.58, -1947.67, 31.33, 325.0), normal = vector3(-0.574, 0.819, 0.000) },
                { coord = vector4(-242.76, -1953.85, 30.61, 331.0), normal = vector3(-0.484, 0.875, 0.000) },
                { coord = vector4(-239.67, -1960.40, 31.70, 337.0), normal = vector3(-0.390, 0.921, 0.000) },
                { coord = vector4(-236.75, -1967.04, 29.82, 343.0), normal = vector3(-0.292, 0.956, 0.000) },
                { coord = vector4(-236.01, -1974.86, 29.70, 259.0), normal = vector3(-0.982, -0.190, 0.000) },
                { coord = vector4(-234.30, -1981.28, 30.28, 355.0), normal = vector3(-0.086, 0.996, 0.000) },
                { coord = vector4(-234.63, -1989.70, 29.82, 271.0), normal = vector3(-1.000, 0.017, 0.000) },
                { coord = vector4(-235.46, -2002.77, 32.26, 13.0),  normal = vector3(0.225, 0.974, 0.000) },
                { coord = vector4(-237.21, -2009.76, 29.97, 19.0),  normal = vector3(0.326, 0.945, 0.000) },
                { coord = vector4(-240.83, -2018.92, 30.67, 205.0), normal = vector3(-0.423, -0.906, 0.000) },
                { coord = vector4(-244.42, -2023.85, 30.15, 310.0), normal = vector3(-0.766, 0.642, 0.000) },
                { coord = vector4(-247.14, -2025.54, 30.33, 310.0), normal = vector3(-0.766, 0.643, 0.000) },
                { coord = vector4(-251.55, -2033.68, 30.29, 40.0),  normal = vector3(0.643, 0.766, 0.000) },
                { coord = vector4(-260.34, -2041.95, 30.48, 55.0),  normal = vector3(0.819, 0.573, 0.000) },
            },
        },
    },

    decal = {
        type = 1030,
        -- Many small splats instead of a few big ones: spatial cleaning removes
        -- them one by one, so grain size decides how smoothly the dirt recedes.
        splatsMin = 38,
        splatsMax = 50,
        offset = 0.40,
        sizeMin = 0.14,
        sizeMax = 0.24,
        alpha = 0.95,
        color = { r = 0.0, g = 0.0, b = 0.0 },
    },

    particles = {
        spray = {
            asset = "core",
            name = "water_cannon_jet",
            scale = 0.5,

            offset = vector3(0.9, 0.03, 0.05),
            rotation = vector3(0.0, 180.0, -90.0),
        },

    },

    sound = {
        spray = "spray_loop",
        volume = 0.4,
    },

    tool = {
        prop = "w_ar_pressure1",
        objcoord = { 18905, 0.09, 0.01, 0.0, 300.0, 720.0, 330.0 },
    },

    interaction = {
        stainDistance = 5.0,
    },

    vehicle = {
        -- These spawn slots sit closer together than the default 7.0 clear
        -- radius (VehicleManager), which made one parked vehicle block every
        -- neighbouring slot and capped the job at one lobby at a time.
        -- Must stay BELOW the smallest slot-to-slot gap.
        spawnClearRadius = 5.5,
        spawnLocations = {
            vector4(901.0092, -1032.2794, 34.9878, 358.5442),
            vector4(907.01, -1032.43, 34.9878, 358.5442),
            vector4(895.01, -1032.13, 34.9878, 358.5442),
        },
        model = "paradise",
        color = { primary = 36, secondary = 111 },
        plate = "PWRWASH",
        useCustomPlate = false,
        fuelOnSpawn = 100.0,
        trunkDoors = {},
        toolPositions = {
            { offset = vector3(-0.24, 0.0, -0.40), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.0, 0.0, -0.40),   rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.24, 0.0, -0.40),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.44, 0.0, -0.40),  rotation = vector3(0.0, 0.0, 0.0) },
        },
    },

    finishArea = {
        enabled = true,
        coord = vector4(896.63, -1018.28, 34.99, 179.39),
        interactDistance = 2.0,
    },

    workClothes = {
        coord = vector4(888.718, -1014.631, 34.128, 47.516),
    },
}

PowerwashJob.runtime = runtime

PowerwashJob.preview = {
    playerPosition = vector3(890.4, -1028.2, 35.11),
    vehicleStep = 3,
    steps = {

        {
            camCoord = vector3(890.64, -1024.21, 36.61),
            camTarget = vector3(890.3691, -1028.1973, 35.61),
        },

        {
            autoClothes = true,
            camCoord = vector3(892.2, -1017.9, 36.6),
            camTarget = vector3(888.8, -1014.7, 34.7),
        },

        {
            autoVehicle = true,
            autoTools = { model = runtime.tool.prop },
            camCoord = vector3(900.9, -1036.8, 35.7),
            camTarget = vector3(901.0, -1031.8, 35.5),
        },

        {
            camCoord = vector3(992.7, -721.4, 59.3),
            camTarget = vector3(992.2, -726.2, 57.8),
            entities = {
                {
                    type = "vehicle",
                    model = runtime.vehicle.model,
                    coords = vector4(1007.78, -726.21, 57.51, 308.99),
                    color = runtime.vehicle.color,
                    openDoors = {},
                    persist = true
                },
                { type = "marker", markerType = 20,                               coords = vector4(992.3, -724.83, 59.24, 0.0),  scale = vector3(0.4, 0.4, 0.4), color = { r = 52, g = 152, b = 219, a = 200 }, bob = true },
                { type = "marker", markerType = 20,                               coords = vector4(989.0, -726.5, 59.40, 0.0),   scale = vector3(0.4, 0.4, 0.4), color = { r = 52, g = 152, b = 219, a = 200 }, bob = true },
                { type = "marker", markerType = 20,                               coords = vector4(987.16, -728.69, 59.43, 0.0), scale = vector3(0.4, 0.4, 0.4), color = { r = 52, g = 152, b = 219, a = 200 }, bob = true },
                { type = "decal",  coords = vector4(992.3, -724.83, 57.74, 0.0),  normal = vector3(0.0, 0.0, 1.0),               decalType = 1030,               splatsMin = 8,                                 splatsMax = 12, offset = 0.30, sizeMin = 0.50, sizeMax = 0.80, alpha = 0.95, r = 0.0, g = 0.0, b = 0.0 },
                { type = "decal",  coords = vector4(989.0, -726.5, 57.90, 0.0),   normal = vector3(0.0, 0.0, 1.0),               decalType = 1030,               splatsMin = 8,                                 splatsMax = 12, offset = 0.30, sizeMin = 0.50, sizeMax = 0.80, alpha = 0.95, r = 0.0, g = 0.0, b = 0.0 },
                { type = "decal",  coords = vector4(987.16, -728.69, 57.93, 0.0), normal = vector3(0.0, 0.0, 1.0),               decalType = 1030,               splatsMin = 8,                                 splatsMax = 12, offset = 0.30, sizeMin = 0.50, sizeMax = 0.80, alpha = 0.95, r = 0.0, g = 0.0, b = 0.0 },
            },
        },

        {
            lockDuration = 3500,
            camCoord = vector3(994.0, -721.6, 59.5),
            camTarget = vector3(991.8, -725.8, 57.9),
            entities = {
                {
                    type = "ped",
                    model = "s_m_m_gentransport",
                    coords = vector4(991.0, -723.5, 57.74, 180.0),
                    faceCoord = vector3(992.3, -724.83, 57.74),
                    anim = { dict = "timetable@gardener@filling_can", name = "gar_ig_5_filling_can", flag = 49 },
                    persist = false
                },
                {
                    type = "prop",
                    model = runtime.tool.prop,
                    attachTo = 1,
                    attachBone = 18905,
                    attachOffset = vector3(0.09, 0.01, 0.0),
                    attachRotation = vector3(300.0, 720.0, 330.0),
                    persist = false
                },
                { type = "decal", coords = vector4(989.0, -726.5, 57.90, 0.0), normal = vector3(0.0, 0.0, 1.0), decalType = 1030, splatsMin = 4, splatsMax = 6, offset = 0.15, sizeMin = 0.25, sizeMax = 0.40, alpha = 0.4, r = 0.0, g = 0.0, b = 0.0 },
            },
        },

        {
            camCoord = vector3(896.5, -1024.4, 36.9),
            camTarget = vector3(896.6, -1019.6, 35.8),
            entities = {
                {
                    type = "vehicle",
                    model = runtime.vehicle.model,
                    coords = vector4(896.63, -1018.28, 34.49, 179.39),
                    color = runtime.vehicle.color,
                    openDoors = {}
                },
                { type = "marker", markerType = 20, coords = vector4(896.63, -1018.28, 36.49, 0.0), scale = vector3(0.5, 0.5, 0.5), color = { r = 230, g = 180, b = 50, a = 200 }, bob = true, rotate = true },
            },
        },
    },
}

PowerwashJob.clothes = {
    male = {
        tshirt_1 = 15,
        tshirt_2 = 0,
        torso_1 = 389,
        torso_2 = 0,
        arms = 75,
        pants_1 = 94,
        pants_2 = 0,
        shoes_1 = 57,
        shoes_2 = 10,
        chain_1 = 0,
        chain_2 = 0,
        helmet_1 = 83,
        helmet_2 = 0,
    },
    female = {
        tshirt_1 = 59,
        tshirt_2 = 1,
        torso_1 = 412,
        torso_2 = 0,
        decals_1 = 0,
        decals_2 = 0,
        arms = 88,
        pants_1 = 102,
        pants_2 = 0,
        shoes_1 = 60,
        shoes_2 = 10,
        chain_1 = -1,
        chain_2 = 0,
        helmet_1 = 82,
        helmet_2 = 0,
    },
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.startJobFunction)
-- Return true to allow the player to start, false to prevent
PowerwashJob.startJobFunction = {
    enabled = false, -- true = enable start check for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId)
        return true
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.endJobFunction)
-- lobbyAmount / playerAmount meaning: number of stains power-washed
PowerwashJob.endJobFunction = {
    enabled = false, -- true = enable end function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.resetJobFunction)
-- Called when the job is cancelled (owner/member leaves mid-job, lobby disbanded, etc.)
PowerwashJob.resetJobFunction = {
    enabled = false, -- true = enable reset function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

return PowerwashJob
