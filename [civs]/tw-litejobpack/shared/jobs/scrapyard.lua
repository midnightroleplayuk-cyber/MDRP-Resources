local ScrapyardJob = {

    id = "scrapyard",

    icon = "./img/jobs/scrapyard_icon.svg",
    image = "./img/jobs/scrapyard_bg.png",
    video = "https://tworst.info/uploads/videos/dbac5dfcc52fb5741e3bef78d24fad5a_1775405629.mp4",
    enabled = true, -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0, -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(2403.48, 3127.78, 48.15, 247.39),
        model = "a_m_m_hillbilly_01",
        scenario = "WORLD_HUMAN_WELDING",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 446,
            color = 47,
            scale = 0.8,
        },
    },

    xprewards = {
        scrapCollected = 20,
        jobCompleted = 400,
    },

    payment = {
        mode = "onJobEnd", -- "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        completionBonus = 0, -- bonus paid once when job is fully completed
        coopMode = "full", -- "full" = everyone gets full pay | "split" = pay divided by player count
    },

    stepRewards = {
        -- Available phases: onBreak (object broken), onPickup (picked up from ground), onScale (placed on scale), onProcess (scale items processed)
        onBreak   = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 10 } } },
        onPickup  = { enabled = false, dropMode = "perItem", itemList = { { item = "water_bottle", count = 1, chance = 8 } } },
        onProcess = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 15 } } },
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

    spawnsPerLobby = 6,

    scrapSpawns = {

        vector4(2423.01, 3112.84, 47.71, 126.17),
        vector4(2429.43, 3126.57, 47.69, 16.26),
        vector4(2425.63, 3133.88, 47.69, 96.9),
        vector4(2419.25, 3147.86, 47.72, 325.0),
        vector4(2409.14, 3137.21, 47.71, 196.01),
        vector4(2394.42, 3122.37, 47.69, 226.06),

        vector4(2413.17, 3041.98, 47.7, 25.07),
        vector4(2404.34, 3039.79, 47.69, 325.07),
        vector4(2382.22, 3039.44, 47.61, 16.07),
        vector4(2353.15, 3052.21, 47.69, 7.07),
        vector4(2352.65, 3038.66, 47.69, 337.07),

        vector4(2370.84, 3052.69, 47.69, 90.0),
        vector4(2363.27, 3041.12, 47.69, 180.0),
        vector4(2433.91, 3140.55, 47.69, 45.0),
        vector4(2415.70, 3155.32, 47.72, 270.0),
        vector4(2401.55, 3145.88, 47.71, 150.0),
        vector4(2388.42, 3038.15, 47.61, 200.0),
        vector4(2345.80, 3045.92, 47.69, 60.0),
    },

    wreckVehicles = {
        "emperor",
        "tornado",
        "voodoo",
        "buccaneer",
        "manana",
        "peyote",
        "primo",
        "regina",
    },

    scraps = {
        models = {
            "emperor",
        },
    },

    breakSession = {
        type = "scrap",
        ballCount = { min = 4, max = 5 },
        ballSize = 0.18,
    },

    animations = {
        dismantling = {
            dict = "melee@large_wpn@streamed_core",
            name = "car_down_attack",
            duration = 8000,
        },
        carry = {
            dict = "anim@heists@box_carry@",
            name = "idle",
        },
    },

    collectedProp = {
        model = "prop_rub_carpart_02",
        bone = 57005,
        offset = vector3(0.050, 0.350, 0.150),
        rotation = vector3(0.1, 162.1, 90.1),
    },

    scrapCarryConfig = {
        ["prop_rub_carpart_02"] = {
            bone = 57005,
            offset = vector3(0.050, 0.350, 0.150),
            rotation = vector3(0.1, 162.1, 90.1),
        },
        ["prop_rub_carpart_03"] = {
            bone = 57005,
            offset = vector3(0.050, 0.350, 0.150),
            rotation = vector3(0.1, 162.1, 90.1),
        },
        ["prop_stockade_wheel_flat"] = {
            bone = 57005,
            offset = vector3(0.000, 0.400, -0.400),
            rotation = vector3(5.9, -10.5, 35.5),
        },
        ["prop_wheel_rim_01"] = {
            bone = 57005,
            offset = vector3(0.100, 0.140, -0.270),
            rotation = vector3(0.0, 0.0, 0.0),
        },
        ["v_ind_cs_hubcap"] = {
            bone = 57005,
            offset = vector3(0.190, 0.110, -0.220),
            rotation = vector3(90.0, -10.0, 32.0),
        },
        ["prop_ejector_seat_01"] = {
            bone = 57005,
            offset = vector3(0.150, 0.340, -0.360),
            rotation = vector3(-98.2, 105.0, -20.0),
        },
        ["prop_car_exhaust_01"] = {
            bone = 57005,
            offset = vector3(0.160, -0.040, -0.490),
            rotation = vector3(-90.0, -21.0, 0.0),
        },
        ["imp_prop_impexp_radiator_04"] = {
            bone = 28422,
            offset = vector3(0.010, 0.010, -0.130),
            rotation = vector3(59.0, 0.0, 0.0),
        },
        ["prop_car_engine_01"] = {
            bone = 36029,
            offset = vector3(0.000, 0.000, 0.000),
            rotation = vector3(0.0, 0.0, 0.0),
        },
    },

    dropCount = { min = 2, max = 3 },

    scrapPickup = {
        models = {
            "prop_rub_carpart_02",
            "prop_rub_carpart_03",
            "prop_stockade_wheel_flat",
            "prop_wheel_rim_01",
            "v_ind_cs_hubcap",
            "prop_ejector_seat_01",
            "prop_car_exhaust_01",
            "imp_prop_impexp_radiator_04",
            "prop_car_engine_01",
        },
        interactionDistance = 1.5,
        pickupTime = 2000,
    },

    particles = "core",

    outline = {
        enabled = true,
        unbrokenColor = { r = 255, g = 165, b = 0, a = 255 },
        pickupColor = { r = 50, g = 255, b = 100, a = 255 },
        range = 20.0,
    },

    breakCompleteEffect = {
        asset = "core",
        name = "ent_brk_metal_parts_lrg",
        scale = 1.5,
        zOffset = 0.5,
        name2 = "ent_dst_gen_sparks",
        scale2 = 1.5,
        zOffset2 = 0.3,
        shake = { type = "SMALL_EXPLOSION_SHAKE", intensity = 0.06 },
    },

    vehicle = {
        spawnLocations = {
            vector4(2410.32, 3109.47, 47.68, 165.99),
            vector4(2416.23, 3107.62, 47.69, 178.62),
            vector4(2404.12, 3112.74, 47.71, 161.15)
        },
        model = "bison",
        toolProp = Config.Tools.scrapyard.default.prop,
        color = { primary = 10, secondary = 0 },
        plate = "SCRAP",
        useCustomPlate = false,
        fuelOnSpawn = 100.0,
        trunkDoors = { 5 },
        trunkOffset = -3.5, -- distance behind vehicle when picking up / returning tools

        toolPositions = {
            { offset = vector3(-0.650, -1.510, 0.580), rotation = vector3(0.9, -210.0, 0.0) },
            { offset = vector3(-0.650, -1.890, 0.580), rotation = vector3(0.9, -210.0, 0.0) },
            { offset = vector3(-0.650, -2.200, 0.580), rotation = vector3(0.9, -210.0, 0.0) },
        },

        cargoPositions = {
            { offset = vector3(-0.18, -1.0, 0.45), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.18, -1.0, 0.45),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.18, -1.4, 0.45), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.18, -1.4, 0.45),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.18, -1.8, 0.45), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.18, -1.8, 0.45),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.18, -1.0, 0.8),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.18, -1.0, 0.8),   rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.18, -1.4, 0.8),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.18, -1.4, 0.8),   rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.18, -1.8, 0.8),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.18, -1.8, 0.8),   rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.18, -2.2, 0.45), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.18, -2.2, 0.45),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.18, -2.2, 0.75), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.18, -2.2, 0.75),  rotation = vector3(0.0, 0.0, 0.0) },
        },
    },

    processing = {
        coord = vector4(2376.08, 3108.47, 48.08, -110.25),
        prop = "tw_baskul",
        propOffset = vector3(0.0, 0.0, 0.0),
        propRotation = vector3(0.0, 0.0, 0.0),
        spawnDistance = 50.0,
        interactDistance = 2.5,
        maxDistanceFromScale = 15.0,
        payPerScrap = 75,
        kgPerItem = 25,
        maxScaleItems = 20,

        -- Mixed scrap models (engines, doors, wheels, hubcaps) have very different
        -- sizes. Force a shared grid + fixed stack height so layout stays flat and
        -- predictable regardless of which model goes where.
        scaleGridSpacing = { x = 0.55, y = 0.55 },
        scaleStackHeight = 0.30,

        levelPayBonus = 0.02,

        levelChanceBonus = 0.5,

        qualityTiers = {
            { name = "Scrap",    chance = 55, multiplier = 1.0 },
            { name = "Salvage",  chance = 25, multiplier = 1.3 },
            { name = "Parts",    chance = 13, multiplier = 1.8 },
            { name = "Pristine", chance = 7,  multiplier = 2.5 },
        },

        npc = {
            model = "s_m_y_garbage",
            coord = vector4(2377.94, 3110.77, 47.1, 58.94),
            scenario = "WORLD_HUMAN_CLIPBOARD",
            interactDistance = 2.0,
        },

        carrier = {
            npcModel        = "s_m_y_construct_02",
            carryProp       = "prop_metal_plates01",
            maxItemsToCarry = 3,
            walkSpeed       = 1.0,

            spawnCoord      = vector4(2360.58, 3132.33, 48.21, 251.9),
            dropCoord       = vector4(2360.58, 3132.33, 48.21, 251.9),

            carryBone       = 57005,
            carryOffset     = vector3(0.1, 0.0, -0.15),
            carryRotation   = vector3(0.0, 0.0, 0.0),
            pickupTime      = 2000,
            dropTime        = 1500,

            npcCarryConfig  = {
                ["prop_rub_carpart_02"] = {
                    bone = 57005,
                    offset = vector3(0.050, 0.350, 0.150),
                    rotation = vector3(0.1, 162.1, 90.1),
                },
                ["prop_rub_carpart_03"] = {
                    bone = 57005,
                    offset = vector3(0.050, 0.350, 0.150),
                    rotation = vector3(0.1, 162.1, 90.1),
                },
                ["prop_stockade_wheel_flat"] = {
                    bone = 57005,
                    offset = vector3(0.000, 0.400, -0.400),
                    rotation = vector3(5.9, -10.5, 35.5),
                },
                ["prop_wheel_rim_01"] = {
                    bone = 57005,
                    offset = vector3(0.100, 0.140, -0.270),
                    rotation = vector3(0.0, 0.0, 0.0),
                },
                ["v_ind_cs_hubcap"] = {
                    bone = 57005,
                    offset = vector3(0.190, 0.110, -0.220),
                    rotation = vector3(90.0, -10.0, 32.0),
                },
                ["prop_ejector_seat_01"] = {
                    bone = 57005,
                    offset = vector3(0.150, 0.340, -0.360),
                    rotation = vector3(-98.2, 105.0, -20.0),
                },
                ["prop_car_exhaust_01"] = {
                    bone = 57005,
                    offset = vector3(0.160, -0.040, -0.490),
                    rotation = vector3(-90.0, -21.0, 0.0),
                },
                ["imp_prop_impexp_radiator_04"] = {
                    bone = 28422,
                    offset = vector3(0.010, 0.010, -0.130),
                    rotation = vector3(59.0, 0.0, 0.0),
                },
                ["prop_car_engine_01"] = {
                    bone = 36029,
                    offset = vector3(0.000, 0.000, 0.000),
                    rotation = vector3(0.0, 0.0, 0.0),
                },
            },
        },
    },

    workClothes = {
        coord = vector4(2406.39, 3131.53, 46.99, 66.05),
    },
}

ScrapyardJob.runtime = runtime

local vehSpawn = runtime.vehicle.spawnLocations[1]
local headingRad = math.rad(vehSpawn.w)
local trunkX = vehSpawn.x + math.sin(headingRad) * 3.5
local trunkY = vehSpawn.y - math.cos(headingRad) * 3.5
local trunkHeading = (vehSpawn.w + 180.0) % 360.0

ScrapyardJob.preview = {
    playerPosition = vector3(2362.0, 3125.0, 48.2),
    vehicleStep = 3,
    steps = {

        {
            camCoord = vector3(2406.7, 3126.5, 49.5),
            camTarget = vector3(2402.2, 3128.3, 48.3),
        },

        {
            autoClothes = true,
            camCoord = vector3(2410.5, 3129.8, 49.4),
            camTarget = vector3(2406.3, 3131.6, 47.4),
        },

        {
            autoVehicle = true,
            autoTools = { model = Config.Tools.scrapyard.default.prop },
            camCoord = vector3(2411.4, 3113.9, 50.4),
            camTarget = vector3(2410.3, 3109.5, 48.2),
        },

        {
            lockDuration = 3500,
            camCoord = vector3(2420.6, 3114.5, 49.9),
            camTarget = vector3(2424.1, 3112.1, 47.4),
            entities = {

                { type = "prop", model = "prop_rub_carwreck_5",  coords = vector4(2423.01, 3112.84, 47.71, 126.17), removeDelay = 3500 },

                { type = "prop", model = "prop_rub_carwreck_3",  coords = vector4(2429.43, 3126.57, 47.69, 16.26) },
                { type = "prop", model = "prop_rub_carwreck_10", coords = vector4(2425.63, 3133.88, 47.69, 96.9) },

                {
                    type = "ped",
                    model = "s_m_y_garbage",
                    coords = vector4(2424.51, 3112.84, 47.71, 270.0),
                    faceCoord = vector3(2423.01, 3112.84, 47.71),
                    anim = { dict = runtime.animations.dismantling.dict, name = runtime.animations.dismantling.name, flag = 1 },
                    persist = false
                },

                {
                    type = "prop",
                    model = Config.Tools.scrapyard.default.prop,
                    attachTo = 4,
                    attachBone = Config.Tools.scrapyard.default.handAttach.boneId,
                    attachOffset = vector3(Config.Tools.scrapyard.default.handAttach.x,
                        Config.Tools.scrapyard.default.handAttach.y, Config.Tools.scrapyard.default.handAttach.z),
                    attachRotation = vector3(Config.Tools.scrapyard.default.handAttach.rotX,
                        Config.Tools.scrapyard.default.handAttach.rotY, Config.Tools.scrapyard.default.handAttach.rotZ),
                    persist = false
                },

                {
                    type = "prop",
                    model = runtime.scrapPickup.models[1],
                    coords = vector4(2423.01, 3112.84, 47.71, 0.0),
                    spawnDelay = 3500,
                    persist = false
                },
            },
        },

        {
            camCoord = vector3(2419.8, 3114.7, 49.5),
            camTarget = vector3(2423.9, 3112.3, 47.9),
            entities = {

                {
                    type = "ped",
                    model = "s_m_y_garbage",
                    coords = vector4(2423.01, 3112.84, 47.71, 270.0),
                    faceCoord = vehSpawn,
                    anim = { dict = "anim@heists@load_box", name = "lift_box", flag = 1 },
                    persist = false
                },

                {
                    type = "prop",
                    model = runtime.collectedProp.model,
                    attachTo = 1,
                    attachBone = runtime.collectedProp.bone,
                    attachOffset = runtime.collectedProp.offset,
                    attachRotation = runtime.collectedProp.rotation,
                    persist = false
                },
            },
        },

        {
            autoCargo = { count = 4, model = "prop_rub_carpart_03" },
            camCoord = vector3(2411.5, 3114.2, 50.9),
            camTarget = vector3(2410.4, 3110.0, 48.5),
            entities = {

                {
                    type = "ped",
                    model = "s_m_y_garbage",
                    coords = vector4(trunkX, trunkY, vehSpawn.z, vehSpawn.w),
                    anim = { dict = runtime.animations.carry.dict, name = runtime.animations.carry.name, flag = 49 },
                    persist = false
                },

                {
                    type = "prop",
                    model = runtime.collectedProp.model,
                    attachTo = 1,
                    attachBone = runtime.collectedProp.bone,
                    attachOffset = runtime.collectedProp.offset,
                    attachRotation = runtime.collectedProp.rotation,
                    persist = false
                },
            },
        },

        {
            autoScale = true,
            scaleDUI = { rockCount = 2, payPerRock = runtime.processing.payPerScrap },
            camCoord = vector3(2371.9, 3110.0, 49.5),
            camTarget = vector3(2376.5, 3108.4, 48.4),
            entities = {

                { type = "prop", model = "prop_car_engine_01",  coords = vector4(runtime.processing.coord.x, runtime.processing.coord.y, runtime.processing.coord.z + 2.0, 0.0),               spawnDelay = 2000 },
                { type = "prop", model = "prop_rub_carpart_03", coords = vector4(runtime.processing.coord.x - 0.3, runtime.processing.coord.y + 0.26, runtime.processing.coord.z + 2.0, 45.0), spawnDelay = 2000 },
            },
        },
    },
}

ScrapyardJob.clothes = {
    male = {
        tshirt_1 = 59,
        tshirt_2 = 1,
        torso_1 = 56,
        torso_2 = 0,
        arms = 30,
        pants_1 = 98,
        pants_2 = 1,
        shoes_1 = 24,
        shoes_2 = 0,
        chain_1 = 0,
        chain_2 = 0,
        helmet_1 = -1,
        helmet_2 = 0,
        glasses_1 = 15,
        glasses_2 = 0,
    },
    female = {
        tshirt_1 = 36,
        tshirt_2 = 1,
        torso_1 = 75,
        torso_2 = 3,
        decals_1 = 0,
        decals_2 = 0,
        arms = 30,
        pants_1 = 99,
        pants_2 = 1,
        shoes_1 = 24,
        shoes_2 = 0,
        chain_1 = -1,
        chain_2 = 0,
        helmet_1 = -1,
        helmet_2 = 0,
        glasses_1 = 5,
        glasses_2 = 0,
    },
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.startJobFunction)
-- Return true to allow the player to start, false to prevent
ScrapyardJob.startJobFunction = {
    enabled = false, -- true = enable start check for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId)
        return true
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.endJobFunction)
-- lobbyAmount / playerAmount meaning: number of scrap items processed on the scale
ScrapyardJob.endJobFunction = {
    enabled = false, -- true = enable end function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.resetJobFunction)
-- Called when the job is cancelled (owner/member leaves mid-job, lobby disbanded, etc.)
ScrapyardJob.resetJobFunction = {
    enabled = false, -- true = enable reset function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

return ScrapyardJob
