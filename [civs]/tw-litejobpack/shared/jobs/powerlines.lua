local PowerlinesJob = {

    id = "powerlines",

    icon = "./img/jobs/powerlines_icon.svg",
    image = "./img/jobs/powerlines_bg.png",
    video = "https://tworst.info/uploads/videos/504817dd03ed652aa5734bfb03d77580_1775405593.mp4",
    enabled = true, -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0, -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(743.48, -1905.99, 29.3, 81.8),
        model = "s_m_y_construct_01",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 354,
            color = 5,
            scale = 0.8,
        },
    },

    xprewards = {
        panelFixed = 50,
        poleFixed = 100,
        jobCompleted = 300,
    },

    payment = {
        mode = "onJobEnd", -- "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        perPanel = 525, -- pay per repair done
        perPole = 525, -- pay per pole repaired
        completionBonus = 0, -- bonus paid once when job is fully completed
        coopMode = "full", -- "full" = everyone gets full pay | "split" = pay divided by player count
    },

    stepRewards = {
        -- Available phases: onRepair (panel/tire repaired)
        onRepair = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 10 }, { item = "water_bottle", count = 1, chance = 8 } } },
    },

    missioncompletedItems = {
        giveItemPlayer = false, -- true = give items on job complete | false = no items given
        dropMode = "weightedPool", -- "weightedPool" = pick one item by chance weight | "perItem" = each item rolls independently
        itemList = {
            { item = "sandwich",     count = 1, chance = 50 },
            { item = "water_bottle", count = 1, chance = 30 },
        },
    },

    panelMinigame = {
        gridRows = 4,
        gridCols = 5,
        timeLimit = 30,
    },

    poleMinigame = {
        wireCount = 4,
        wireWidth = 0.74,
        maxWeldFails = 2,
        time = 45,
    },

    runtime = {

        usesRoutes = true,

        routes = {
            [1] = {
                name = "Rockford Hills",
                requiredLevel = 1,
                coord = vector3(125.10, -397.95, 55.60),
                panelCount = { min = 1, max = 1 },
                poleCount = { min = 1, max = 1 },
                panelLocations = {
                    { coords = vector4(215.55, -143.54, 58.55, 0.0), fixed = false, open = false },
                    { coords = vector4(229.16, -112.05, 69.73, 0.0), fixed = false, open = false },
                    { coords = vector4(151.14, -90.72, 64.27, 0.0),  fixed = false, open = false },
                    { coords = vector4(57.32, -77.21, 62.26, 0.0),   fixed = false, open = false },
                    { coords = vector4(49.02, -92.97, 61.28, 0.0),   fixed = false, open = false },
                    { coords = vector4(48.46, -94.49, 61.26, 0.0),   fixed = false, open = false },
                    { coords = vector4(51.46, -60.3, 67.46, 0.0),    fixed = false, open = false },
                },
                poleLocations = {
                    { coords = vector4(-4.89, -1355.66, 40.07, 0.0), parkCoords = vector4(-2.14, -1357.37, 29.22, 269.6), fixed = false, open = false },
                    { coords = vector4(0.73, -1378.96, 38.61, 0.0),  fixed = false,                                       open = false },
                    { coords = vector4(-68.67, -1379.1, 39.46, 0.0), fixed = false,                                       open = false },
                },
            },
            [2] = {
                name = "Davis",
                requiredLevel = 2,
                coord = vector3(896.21, -1932.64, 32.91),
                panelCount = { min = 1, max = 2 },
                poleCount = { min = 1, max = 2 },
                panelLocations = {
                    { coords = vector4(709.88, -2139.19, 29.07, 0.0), fixed = false, open = false },
                    { coords = vector4(709.05, -2149.26, 28.96, 0.0), fixed = false, open = false },
                    { coords = vector4(708.18, -2158.47, 29.45, 0.0), fixed = false, open = false },
                    { coords = vector4(707.28, -2168.47, 28.75, 0.0), fixed = false, open = false },
                },
                poleLocations = {
                    { coords = vector4(894.94, -2253.68, 40.58, 0.0), fixed = false, open = false },
                    { coords = vector4(776.15, -2284.71, 38.18, 0.0), fixed = false, open = false },
                },
            },
            [3] = {
                name = "Vespucci",
                requiredLevel = 3,
                coord = vector3(-1206.85, -1230.07, 7.49),
                panelCount = { min = 2, max = 2 },
                poleCount = { min = 2, max = 2 },
                panelLocations = {
                    { coords = vector4(-1114.89, -1218.55, 2.82, 0.0), fixed = false, open = false },
                    { coords = vector4(-1108.51, -1223.37, 2.73, 0.0), fixed = false, open = false },
                    { coords = vector4(-1114.95, -1260.07, 7.12, 0.0), fixed = false, open = false },
                },
                poleLocations = {
                    { coords = vector4(-1268.56, -1034.12, 19.10, 0.0), fixed = false, open = false },
                    { coords = vector4(-1281.57, -1070.53, 16.77, 0.0), fixed = false, open = false },
                    { coords = vector4(-1295.11, -1077.01, 17.10, 0.0), fixed = false, open = false },
                },
            },
            [4] = {
                name = "Strawberry",
                requiredLevel = 4,
                coord = vector3(-872.13, -360.44, 39.48),
                panelCount = { min = 2, max = 3 },
                poleCount = { min = 2, max = 3 },
                panelLocations = {
                    { coords = vector4(-1160.88, -214.45, 37.63, 0.0), fixed = false, open = false },
                    { coords = vector4(-1146.97, -361.66, 38.08, 0.0), fixed = false, open = false },
                    { coords = vector4(-678.76, -176.53, 37.67, 0.0),  fixed = false, open = false },
                },
                poleLocations = {
                    { coords = vector4(-1650.41, -354.58, 60.19, 0.0), fixed = false, open = false },
                    { coords = vector4(-1669.68, -368.92, 60.02, 0.0), fixed = false, open = false },
                    { coords = vector4(-1702.68, -406.54, 57.31, 0.0), fixed = false, open = false },
                },
            },
            [5] = {
                name = "Central LS",
                requiredLevel = 5,
                coord = vector3(-166.51, -811.18, 41.34),
                panelCount = { min = 3, max = 3 },
                poleCount = { min = 3, max = 3 },
                -- Route-specific bucket override: bu route'taki direkler yüksek/uzak,
                -- default 6.0m radius + 2.0m altta dar geliyor. onStartExtra
                -- runtime.bucket'a merge ediyor.
                bucket = { maxInteractDistance = 12.0, minHeightForRepair = 6.0 },
                panelLocations = {
                    { coords = vector4(-884.74, 446.88, 86.91, 0.0),   fixed = false, open = false },
                    { coords = vector4(150.83, -90.53, 64.56, 0.0),    fixed = false, open = false },
                    { coords = vector4(108.23, 65.84, 73.42, 0.0),     fixed = false, open = false },
                    { coords = vector4(-686.42, -1026.34, 15.99, 0.0), fixed = false, open = false },
                    { coords = vector4(-725.83, -1030.74, 15.08, 0.0), fixed = false, open = false },
                },
                poleLocations = {
                    { coords = vector4(1236.32, -367.78, 80.01, 0.0),  fixed = false, open = false },
                    { coords = vector4(-634.1, -1023.66, 32.26, 0.0),  fixed = false, open = false },
                    { coords = vector4(-1011.63, -837.31, 26.96, 0.0), fixed = false, open = false },
                },
            },
            [6] = {
                name = "South LS",
                requiredLevel = 6,
                coord = vector3(62.89, -666.35, 55.11),
                panelCount = { min = 3, max = 4 },
                poleCount = { min = 3, max = 4 },
                panelLocations = {
                    { coords = vector4(-726.62, -1029.18, 15.08, 0.0), fixed = false, open = false },
                    { coords = vector4(-718.42, -1043.32, 15.09, 0.0), fixed = false, open = false },
                    { coords = vector4(-717.7, -1044.68, 15.09, 0.0),  fixed = false, open = false },
                    { coords = vector4(-951.84, -1063.87, 2.17, 0.0),  fixed = false, open = false },
                    { coords = vector4(-1021.52, -1122.16, 2.16, 0.0), fixed = false, open = false },
                },
                poleLocations = {
                    { coords = vector4(-171.98, -1464.54, 42.27, 0.0), fixed = false, open = false },
                    { coords = vector4(786.06, -1316.11, 37.57, 0.0),  fixed = false, open = false },
                    { coords = vector4(786.85, -1290.18, 37.23, 0.0),  fixed = false, open = false },
                    { coords = vector4(490.94, -691.01, 33.82, 0.0),   fixed = false, open = false },
                    { coords = vector4(276.79, -2518.02, 17.47, 0.0),  fixed = false, open = false },
                    { coords = vector4(-1078.39, 418.6, 81.47, 0.0),   fixed = false, open = false },
                },
            },
        },

        panelCount = { min = 1, max = 1 },
        poleCount = { min = 1, max = 1 },

        vehicle = {
            model = "utillitruck4",
            color = { primary = 89, secondary = 0 },
            plate = "ELECTRIC",
            useCustomPlate = false,
            fuelOnSpawn = 100.0,
            trunkDoors = {},
            spawnLocations = {
                vector4(734.32, -1905.68, 29.29, 172.83),
                vector4(732.44, -1920.52, 29.29, 173.79),
                vector4(730.87, -1934.76, 29.29, 173.77),
                vector4(734.82, -1968.26, 29.27, 356.38),
            },
        },

        bucket = {
            seatIndex = 1,
            maxInteractDistance = 6.0,
            minHeightForRepair = 2.0,
            parkingMarker = {
                type = 1,
                scale = vec3(3.0, 3.0, 1.0),
                color = { r = 0, g = 200, b = 100, a = 120 },
                drawDistance = 50.0,
            },
            controls = {
                up = 172,
                down = 173,
            },
        },

        panelLocations = {},
        poleLocations = {},

        panelInteractDistance = 2.0,
        poleInteractDistance = 3.0,

        blips = {
            panel = {
                sprite = 354,
                color = 5,
                scale = 0.6,
                label = "Electrical Panel",
            },
            pole = {
                sprite = 354,
                color = 28,
                scale = 0.7,
                label = "Phone Pole",
            },
            vehicle = {
                sprite = 67,
                color = 5,
                scale = 0.8,
                label = "Bucket Truck",
            },
        },

        workClothes = {
            coord = vector4(742.870, -1903.290, 28.330, -98.626),
        },

        finishPoint = {
            coord = vector4(738.97, -1921.65, 29.29, 4.49),
        },
    },

    clothes = {
        male = {
            tshirt_1 = 57,
            tshirt_2 = 0,
            torso_1 = 66,
            torso_2 = 1,
            arms = 17,
            pants_1 = 39,
            pants_2 = 1,
            shoes_1 = 25,
            shoes_2 = 0,
            chain_1 = 0,
            chain_2 = 0,
            helmet_1 = 2,
            helmet_2 = 0,
        },
        female = {
            tshirt_1 = 15,
            tshirt_2 = 0,
            torso_1 = 300,
            torso_2 = 0,
            decals_1 = 0,
            decals_2 = 0,
            arms = 0,
            pants_1 = 99,
            pants_2 = 0,
            shoes_1 = 52,
            shoes_2 = 0,
            chain_1 = -1,
            chain_2 = 0,
            helmet_1 = 39,
            helmet_2 = 0,
        },
    },
}

PowerlinesJob.preview = {
    playerPosition = vector3(743.0, -1906.0, 29.3),
    vehicleStep = 3,
    steps = {
        {
            camCoord = vector3(739.9, -1905.5, 30.6),
            camTarget = vector3(744.7, -1906.1, 29.5),
        },
        {
            autoClothes = true,
            camCoord = vector3(738.3, -1902.5, 31.0),
            camTarget = vector3(742.8, -1903.3, 28.9),
        },
        {
            autoVehicle = true,
            camCoord = vector3(733.3, -1913.3, 31.7),
            camTarget = vector3(733.9, -1908.5, 30.5),
        },
        {
            lockDuration = 3500,
            camCoord = vector3(710.1, -2137.8, 29.6),
            camTarget = vector3(709.2, -2142.7, 29.5),
            entities = {
                {
                    type = "vehicle",
                    model = "utillitruck4",
                    coords = vector4(712.0, -2142.0, 28.57, 0.0),
                    color = { primary = 89, secondary = 0 },
                    openDoors = {}
                },
                {
                    type = "ped",
                    model = "s_m_y_construct_01",
                    coords = vector4(710.5, -2139.19, 28.57, 270.0),
                    faceCoord = vector3(709.88, -2139.19, 29.07),
                    anim = { dict = "amb@prop_human_movie_studio_light@base", name = "base", flag = 1 },
                },
                {
                    type = "marker",
                    markerType = 20,
                    coords = vector4(709.88, -2139.19, 30.57, 0.0),
                    scale = vector3(0.3, 0.3, 0.3),
                    color = { r = 255, g = 200, b = 0, a = 200 },
                    bob = true
                },
            },
        },
        {
            lockDuration = 3500,
            camCoord = vector3(6.3, -1356.1, 32.3),
            camTarget = vector3(1.4, -1355.9, 31.3),
            entities = {
                {
                    type = "vehicle",
                    model = "utillitruck4",
                    coords = vector4(-2.14, -1357.37, 29.22, 269.6),
                    color = { primary = 89, secondary = 0 },
                    openDoors = {}
                },
                {
                    type = "marker",
                    markerType = 20,
                    coords = vector4(-4.89, -1355.66, 41.0, 0.0),
                    scale = vector3(0.4, 0.4, 0.4),
                    color = { r = 0, g = 200, b = 255, a = 200 },
                    bob = true
                },
            },
        },
        {
            camCoord = vector3(738.3, -1912.9, 31.4),
            camTarget = vector3(738.7, -1917.8, 30.5),
            entities = {
                {
                    type = "vehicle",
                    model = "utillitruck4",
                    coords = vector4(738.97, -1921.65, 28.79, 4.49),
                    color = { primary = 89, secondary = 0 },
                    openDoors = {}
                },
                {
                    type = "marker",
                    markerType = 20,
                    coords = vector4(738.97, -1921.65, 31.0, 0.0),
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
    -- lobbyAmount / playerAmount meaning: total panels + poles fixed
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

return PowerlinesJob
