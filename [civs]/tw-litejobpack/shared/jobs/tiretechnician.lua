local MechanicJob = {
    id = "tiretechnician",

    icon = "./img/jobs/tiretechnician_icon.svg",
    image = "./img/jobs/tiretechnician_bg.png",
    video = "https://tworst.info/uploads/videos/f82641c22cae9dbbcaa86f8ea2a7c3ac_1775405632.mp4",
    enabled = true,    -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0,      -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(-174.78, -1273.2, 32.6, 91.27),
        model = "s_m_y_ammucity_01",
        scenario = "WORLD_HUMAN_WELDING",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 446,
            color = 1,
            scale = 0.8,
        },
    },

    xprewards = {
        repairFixed = 70,
        jobCompleted = 350,
    },

    payment = {
        mode = "onJobEnd",   -- "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        perRepair = 115,     -- pay per repair done
        completionBonus = 0, -- bonus paid once when job is fully completed
        coopMode = "full",   -- "full" = everyone gets full pay | "split" = pay divided by player count
    },

    stepRewards = {
        -- Available phases: onRepair (panel/tire repaired)
        onRepair = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 10 }, { item = "water_bottle", count = 1, chance = 8 } } },
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
        repairCount = { min = 2, max = 5 },

        vehicle = {
            model = "bison",
            color = { primary = 0, secondary = 0 },
            plate = "MECH",
            useCustomPlate = false,
            fuelOnSpawn = 100.0,
            trunkDoors = { 5 },
            trunkOffset = -3.0, -- distance behind vehicle when picking up / returning items from trunk

            toolPositions = {
                { offset = vector3(-0.4, -1.8, 0.26),     rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(0.583, -1.768, 0.557), rotation = vector3(0.0, 0.0, 90.0) },
                -- Decorative extra spare tires (not used by logic, pure visual)
                { offset = vector3(0.333, -1.768, 0.557), rotation = vector3(0.0, 0.0, 90.0) },
                { offset = vector3(0.333, -1.118, 0.557), rotation = vector3(0.0, 0.0, 90.0) },
                { offset = vector3(0.483, -2.268, 0.557), rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(0.133, -1.118, 0.557), rotation = vector3(0.0, 0.0, 90.0) },
            },
            spawnLocations = {
                vector4(-182.41, -1277.56, 30.3, 94.67),
                vector4(-181.85, -1274.3, 30.3, 86.29),
            },
        },

        tools = {

            jack       = { positionIndex = 1, prop = "prop_carjack_clsd", forTaskType = "tire" },
            spare      = { positionIndex = 2, prop = "prop_wheel_tyre", forTaskType = "tire" },
            -- Decorative spares (never taken — HandleTakeSpare uses position 2 only)
            spareDeco1 = { positionIndex = 3, prop = "prop_wheel_tyre", forTaskType = "tire" },
            spareDeco2 = { positionIndex = 4, prop = "prop_wheel_tyre", forTaskType = "tire" },
            spareDeco3 = { positionIndex = 5, prop = "prop_wheel_tyre", forTaskType = "tire" },
            spareDeco4 = { positionIndex = 6, prop = "prop_wheel_tyre", forTaskType = "tire" },
        },

        vehicleModels = {
            "picador", "exemplar", "gresley", "weevil", "rebel", "sabregt2",
            "sultan", "vigero", "retinue2", "oracle2", "vamos", "virgo",
            "hermes", "bifta", "emperor", "fugitive", "prairie", "surge",
            "stanier", "stratum", "ingot", "asterope", "premier", "intruder",
        },

        repairLocations = {
            { coords = vector4(-214.64, -1151.67, 22.35, 271.43), npcCoords = vector4(-213.49, -1153.53, 23.06, 91.0) },
            { coords = vector4(-219.9, -1128.22, 23.03, 87.62),   npcCoords = vector4(-219.07, -1123.13, 23.04, 172.33) },
            { coords = vector4(-285.02, -2191.34, 10.16, 48.6),   npcCoords = vector4(-288.8, -2193.83, 10.08, 326.53) },
            { coords = vector4(875.92, -3074.91, 5.9, 179.02),    npcCoords = vector4(876.86, -3083.67, 5.9, 1.02) },
            { coords = vector4(207.87, 1433.81, 239.77, 40.06),   npcCoords = vector4(211.15, 1437.26, 239.7, 141.53) },
            { coords = vector4(-3134.9, 881.64, 14.99, 2.77),     npcCoords = vector4(-3132.29, 882.52, 14.97, 91.47) },
            { coords = vector4(-569.29, -1240.91, 14.48, 330.5),  npcCoords = vector4(-564.46, -1241.8, 14.68, 56.94) },
            { coords = vector4(-399.76, -485.28, 25.41, 87.45),   npcCoords = vector4(-399.69, -480.7, 26.23, 174.41) },
            { coords = vector4(317.98, -1138.82, 29.36, 97.1),    npcCoords = vector4(320.16, -1142.49, 29.4, 25.26) },
            { coords = vector4(-2351.92, 4089.91, 33.25, 164.06), npcCoords = vector4(-2354.76, 4091.0, 33.22, 242.75) },
            { coords = vector4(-202.12, -549.28, 34.69, 340.49),  npcCoords = vector4(-196.84, -551.96, 34.69, 66.7) },
            { coords = vector4(1365.0, -2014.01, 52.15, 301.93),  npcCoords = vector4(1370.96, -2013.8, 53.72, 85.84) },
            { coords = vector4(1161.25, 6505.15, 21.1, 86.01),    npcCoords = vector4(1161.89, 6510.02, 20.99, 172.14) },
            { coords = vector4(253.67, -1187.43, 28.88, 267.5),   npcCoords = vector4(257.69, -1190.74, 29.5, 46.05) },
            { coords = vector4(-1525.53, -1075.28, 4.86, 48.31),  npcCoords = vector4(-1530.96, -1074.81, 5.09, 256.33) },
        },


        repairInteractDistance = 3.5,

        jackDuration = 5000,
        tireChangeDuration = 8000,

        blips = {
            repair = {
                sprite = 446,
                color = 1,
                scale = 0.6,
                label = "Vehicle Repair",
            },
            vehicle = {
                sprite = 67,
                color = 1,
                scale = 0.8,
                label = "Service Truck",
            },
        },

        npcModels = {
            "a_m_y_business_01", "a_m_m_business_01", "a_f_y_business_01",
            "a_m_y_hipster_01", "a_f_m_beach_01", "a_m_y_vinewood_01",
            "a_f_y_tourist_01", "a_m_m_farmer_01",
        },

        workClothes = {
            coord = vector4(-82.200, -1333.710, 28.287, 16.45),
        },

        returnPoint = {
            coord = vector4(-74.45, -1340.38, 29.26, 240.01),
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

MechanicJob.preview = {
    playerPosition = vector3(-68.9, -1331.0, 29.27),
    vehicleStep = 3,
    steps = {
        {
            camCoord = vector3(-69.1, -1334.5, 30.5),
            camTarget = vector3(-68.8, -1329.7, 29.3),
        },
        {
            autoClothes = true,
            camCoord = vector3(-80.9, -1337.6, 31.0),
            camTarget = vector3(-82.3, -1333.4, 28.6),
        },
        {
            autoVehicle = true,
            autoTools = { model = "prop_carjack_clsd" },
            camCoord = vector3(-69.2, -1337.8, 30.4),
            camTarget = vector3(-68.9, -1342.7, 29.3),
        },
        {
            camCoord = vector3(-218.3, -1154.3, 24.8),
            camTarget = vector3(-214.6, -1151.6, 22.8),
            entities = {
                {
                    type = "ped",
                    model = "a_m_y_business_01",
                    coords = vector4(-213.49, -1153.53, 22.35, 91.0),
                    scenario = "WORLD_HUMAN_STAND_IMPATIENT"
                },
                {
                    type = "vehicle",
                    model = "oracle",
                    coords = vector4(-214.64, -1151.67, 22.35, 271.43),
                    color = { primary = 0, secondary = 0 },
                    openDoors = {}
                },
            },
        },
        {
            lockDuration = 4000,
            camCoord = vector3(-212.5, -1154.0, 23.5),
            camTarget = vector3(-214.64, -1152.5, 22.85),
            entities = {
                {
                    type = "vehicle",
                    model = "oracle",
                    coords = vector4(-214.64, -1151.67, 22.65, 271.43),
                    color = { primary = 0, secondary = 0 },
                    openDoors = {},
                    rawZ = true
                },
                { type = "prop", model = "prop_carjack",    coords = vector4(-214.64, -1153.0, 22.35, 271.0) },
                { type = "prop", model = "prop_wheel_tyre", coords = vector4(-213.0, -1154.0, 22.35, 0.0) },
                {
                    type = "ped",
                    model = "s_m_y_ammucity_01",
                    coords = vector4(-214.14, -1153.3, 22.35, 0.0),
                    faceCoord = vector3(-214.64, -1152.0, 22.35),
                    anim = { dict = "missexile3", name = "ex03_dingy_search_case_base_scientist", flag = 1 },
                },
            },
        },
        {
            camCoord = vector3(-70.3, -1342.8, 31.0),
            camTarget = vector3(-74.5, -1340.4, 29.8),
            entities = {
                {
                    type = "vehicle",
                    model = "bison",
                    coords = vector4(-74.45, -1340.38, 28.76, 240.01),
                    color = { primary = 0, secondary = 0 },
                    openDoors = {}
                },
                {
                    type = "marker",
                    markerType = 20,
                    coords = vector4(-74.45, -1340.38, 31.0, 0.0),
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
    -- lobbyAmount / playerAmount meaning: number of tires repaired
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

return MechanicJob
