local CarDetailerJob = {

    id = "cardetailer",

    icon = "./img/jobs/cardetailer_icon.svg",
    image = "./img/jobs/cardetailer_bg.png",
    video = "https://tworst.info/uploads/videos/0f190dfb2bc7755e6dac66ab8c7f09e7_1775405577.mp4",
    enabled = true, -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0, -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(-1.37, -1400.38, 29.27, 87.17),
        model = "s_m_m_gentransport",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 72,
            color = 3,
            scale = 0.8,
        },
    },

    xprewards = {
        carWashed = 40,
        carPolished = 25,
        jobCompleted = 500,
    },

    payment = {
        mode = "onJobEnd", -- "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        perCarWash = 80, -- pay per car washed
        perCarPolish = 50, -- pay per car polished
        completionBonus = 0, -- bonus paid once when job is fully completed
        coopMode = "full", -- "full" = everyone gets full pay | "split" = pay divided by player count
    },

    stepRewards = {
        -- Available phases: onWash (car washed), onPolish (car polished)
        onWash   = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 10 } } },
        onPolish = { enabled = false, dropMode = "perItem", itemList = { { item = "water_bottle", count = 1, chance = 8 } } },
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

    customerCar = {
        despawnDelay = 30000, -- ms the finished car lingers before it despawns
    },

    spray = {
        hitsRequired = 6,
        hitInterval = 400,
        maxDistance = 1.5,
        raycastDistance = 10.0,
        interactDistance = 8.0,
    },

    polish = {
        pointsPerCar = 3,

        breakSession = {
            hitsRequired = 8,
            ballsPerSession = 4,
            ballSize = 0.15,
            repeatPerBall = 2,
            maxDistance = 5.0,
            -- Hit-registration tuning (camera-ray-vs-sphere; bigger = easier to
            -- click in third person, no more spam-clicking).
            hitRadius = 0.45,
            targetSize = 0.16,
            glowSize = 0.28,
            hitCooldown = 600,    -- ms between accepted clicks (was a fixed 2000)
            finishAnimTime = 900, -- ms the final hit's polish anim plays before the session ends
        },

        decalOptions = {
            splatsMin = 6,
            splatsMax = 10,
            offset = 0.15,
            sizeMin = 0.10,
            sizeMax = 0.20,
            alpha = 1.0,
            r = 1.0,
            g = 1.0,
            b = 1.0,
        },
    },

    levelConfig = {
        [1] = { carCount = 1, phases = { "wash", "polish" }, carTier = 1 },
        [2] = { carCount = 1, phases = { "wash", "polish" }, carTier = 1 },
        [3] = { carCount = 1, phases = { "wash", "polish" }, carTier = 2 },
        [4] = { carCount = 1, phases = { "wash", "polish" }, carTier = 2 },
        [5] = { carCount = 1, phases = { "wash", "polish" }, carTier = 3 },
    },

    carModels = {
        [1] = { "exemplar" },
        [2] = { "oracle", "tailgater", "schafter2", "fugitive", "felon", "jackal" },
        [3] = { "exemplar", "windsor", "cognoscenti", "superd", "xls", "baller3" },
    },

    carLocations = {
        { coord = vector4(45.15, -599.12, 31.17, 338.23) },
        { coord = vector4(10.96, -589.67, 31.17, 248.82) },
        { coord = vector4(35.92, -580.36, 31.17, 340.36) },
        { coord = vector4(47.06, -872.44, 29.98, 159.0) },
        { coord = vector4(37.18, -841.46, 30.42, 160.22) },
        { coord = vector4(-332.02, -751.02, 33.51, 182.17) },
        { coord = vector4(58.01, 19.59, 68.95, 338.88) },
        { coord = vector4(-467.34, -813.23, 30.07, 91.71) },
        { coord = vector4(457.7, -1697.53, 28.85, 139.8) },
        { coord = vector4(-1447.8, -676.0, 26.0, 34.33) },
        { coord = vector4(-1428.58, -676.86, 26.2, 212.79) },
        { coord = vector4(-1493.55, -729.47, 25.56, 356.82) },
        { coord = vector4(-1619.58, -896.79, 8.6, 138.16) },
        { coord = vector4(-1683.88, -893.81, 7.9, 319.67) },
        { coord = vector4(-1691.21, -944.99, 7.21, 161.81) },
        { coord = vector4(-1657.87, -839.39, 9.11, 319.38) },
        { coord = vector4(1027.74, -785.32, 57.41, 127.48) },
        { coord = vector4(1016.99, -760.21, 57.51, 41.82) },
        { coord = vector4(1249.82, -334.77, 68.62, 172.03) },
        { coord = vector4(1272.3, -370.75, 68.57, 232.58) },
        { coord = vector4(336.49, -210.43, 53.62, 249.41) },
        { coord = vector4(316.1, -206.22, 53.62, 68.97) },
        { coord = vector4(436.47, 123.96, 99.52, 67.08) },
        { coord = vector4(387.85, 113.75, 101.77, 70.43) },
    },

    washSpots = {
        { offset = vector3(0.9, 0.8, 0.5),   labelKey = "cardetailer.spotRightFrontDoor" },
        { offset = vector3(-0.9, 0.8, 0.5),  labelKey = "cardetailer.spotLeftFrontDoor" },
        { offset = vector3(0.0, 2.2, 0.5),   labelKey = "cardetailer.spotHood" },
        { offset = vector3(0.0, -2.0, 0.5),  labelKey = "cardetailer.spotTrunk" },
        { offset = vector3(0.9, -0.6, 0.5),  labelKey = "cardetailer.spotRightRearDoor" },
        { offset = vector3(-0.9, -0.6, 0.5), labelKey = "cardetailer.spotLeftRearDoor" },
    },

    -- Pool authored via /polishtool on exemplar + oracle. Server picks
    -- `polish.pointsPerCar` random unique indices per car so each detail run
    -- gets a different combination. Offsets are normalized to the car's
    -- bounding box (-1..+1) and rescaled per model at spawn time.
    -- Bagaj ucu spotları |y|=0.75'e clamp edildi — raycast top-down bumper
    -- dışına düşerse zemine düşüyor, bu güvenli iç band.
    polishPoints = {
        { offset = vector3(-0.428, 0.454, 0.0),  labelKey = "cardetailer.spotHoodLeft",      normal = vector3(0.0, 0.0, 1.0) }, -- 1
        { offset = vector3(0.380, 0.486, 0.0),   labelKey = "cardetailer.spotHoodRight",     normal = vector3(0.0, 0.0, 1.0) }, -- 2
        { offset = vector3(-0.022, 0.762, 0.0),  labelKey = "cardetailer.spotHoodCenter",    normal = vector3(0.0, 0.0, 1.0) }, -- 3
        { offset = vector3(-0.444, -0.308, 0.0), labelKey = "cardetailer.spotDoorLeft",      normal = vector3(0.0, 0.0, 1.0) }, -- 4
        { offset = vector3(-0.495, -0.181, 0.0), labelKey = "cardetailer.spotDoorLeftFront", normal = vector3(0.0, 0.0, 1.0) }, -- 5
        { offset = vector3(0.244, -0.255, 0.0),  labelKey = "cardetailer.spotDoorRight",     normal = vector3(0.0, 0.0, 1.0) }, -- 6
        { offset = vector3(0.389, -0.209, 0.0),  labelKey = "cardetailer.spotDoorRightFront",normal = vector3(0.0, 0.0, 1.0) }, -- 7
        { offset = vector3(-0.249, -0.086, 0.0), labelKey = "cardetailer.spotRoofLeft",      normal = vector3(0.0, 0.0, 1.0) }, -- 8
        { offset = vector3(-0.260, -0.750, 0.0), labelKey = "cardetailer.spotTrunkLeft",     normal = vector3(0.0, 0.0, 1.0) }, -- 9
        { offset = vector3(0.282, -0.750, 0.0),  labelKey = "cardetailer.spotTrunkRight",    normal = vector3(0.0, 0.0, 1.0) }, -- 10
    },

    -- Per-model polish point exclusions. Body geometry varies enough that
    -- normalized offsets drift onto the wrong panel for some models:
    --   - short front overhang  → spotHoodCenter (3) lands on grille
    --   - long sloped rear      → spotTrunkLeft/Right (9, 10) land on rear glass / roof
    -- Listed indices are skipped when picking the random subset for that model.
    polishPointExcludes = {
        jackal   = { 3 },        -- kaputu kısa, spotHoodCenter grille'a düşüyor
        windsor  = { 9, 10 },    -- arka eğimli, bagaj decalları arka cama düşüyor
        xls      = { 9, 10 },    -- SUV, uzun arka — bagaj decalları tutmuyor
        baller3  = { 9, 10 },    -- SUV, uzun arka — bagaj decalları tutmuyor
        exemplar = { 9, 10 },    -- coupe, fastback arka cam — trunk decalları cama düşüyor
    },

    particles = {
        spray = {
            asset = "core",
            name = "water_cannon_jet",
            scale = 0.4,
            offset = vector3(0.9, 0.03, 0.05),
            rotation = vector3(0.0, 180.0, -90.0),
        },
        polish = {
            asset = "core",
            name = "ent_dst_gen_dust_raise",
            scale = 0.3,
        },
    },

    sound = {
        spray = "spray_loop",
        volume = 0.4,
    },

    tool = {
        wand = {
            prop = "w_ar_pressure1",
            objcoord = { 18905, 0.09, 0.01, 0.0, 300.0, 720.0, 330.0 },
        },
        cloth = {
            prop = "prop_sponge_01",
            bone = 28422,
            offset = vector3(0.1, 0.0, -0.03),
            rotation = vector3(90.0, 0.0, 0.0),
        },
    },

    tank = {
        prop = "veo_pipes_r",
        offset = vector3(0.0, -1.4, 0.0),
        rotation = vector3(0.0, 0.0, 180.0),
    },

    rope = {
        maxLength = 10.0,
        ropeType = 4,
        warningDistance = 8.0,

        tankOffset = vector3(0.0, 0.0, 0.44),
    },

    vehicle = {
        spawnLocations = {
            vector4(0.55, -1404.92, 28.81, 84.64),
            vector4(8.02, -1405.62, 28.81, 84.64),
            vector4(-8.3, -1413.46, 28.83, 0.63),
            vector4(14.65, -1413.26, 28.89, 88.64)
        },
        model = "speedo",
        color = { primary = 111, secondary = 111 },
        plate = "DETAIL",
        useCustomPlate = false,
        fuelOnSpawn = 100.0,
        trunkDoors = { 2, 3 },
        trunkOffset = -3.5, -- distance behind vehicle when picking up / returning tools
        toolPositions = {
            { offset = vector3(-0.4, -1.6, 0.45), rotation = vector3(0.0, 0.0, 90.0) },
            { offset = vector3(0.4, -1.6, 0.45),  rotation = vector3(0.0, 0.0, 90.0) },
            { offset = vector3(-0.4, -1.3, 0.45), rotation = vector3(0.0, 0.0, 90.0) },
            { offset = vector3(0.4, -1.3, 0.45),  rotation = vector3(0.0, 0.0, 90.0) },
        },
    },

    blip = {
        sprite = 1,
        color = 3,
        scale = 0.7,
        shortRange = true,
    },

    finishArea = {
        coord = vector4(-9.16, -1398.67, 29.1, 80.5),
        interactDistance = 2.0,
    },

    workClothes = {
        coord = vector4(-3.46, -1396.47, 28.267, 268.10),
    },
}

CarDetailerJob.runtime = runtime

CarDetailerJob.preview = {
    playerPosition = vector3(-1.37, -1400.38, 29.27),
    vehicleStep = 3,
    steps = {
        {
            camCoord = vector3(-3.6, -1400.5, 30.3),
            camTarget = vector3(1.3, -1400.2, 29.1),
        },
        {
            autoClothes = true,
            camCoord = vector3(-7.5, -1396.4, 31.2),
            camTarget = vector3(-3.2, -1396.5, 28.6),
        },
        {
            autoVehicle = true,
            autoTools = { model = runtime.tool.wand.prop },
            camCoord = vector3(4.7, -1405.3, 30.0),
            camTarget = vector3(-0.2, -1404.8, 29.2),
            entities = {
                { type = "prop", model = runtime.tool.cloth.prop, coords = vector4(0.0, -1405.5, 29.3, 0.0) },
                {
                    type = "prop",
                    model = runtime.tank.prop,
                    attachToStep = { step = 3, index = 1 },
                    attachOffset = runtime.tank.offset,
                    attachRotation = runtime.tank.rotation
                },
            },
        },
        {
            camCoord = vector3(50.0, -869.5, 31.5),
            camTarget = vector3(47.06, -872.44, 30.48),
            entities = {
                {
                    type = "vehicle",
                    model = "exemplar",
                    coords = vector4(47.06, -872.44, 29.98, 159.0),
                    openDoors = {},
                    color = { primary = 0, secondary = 0 },
                    persist = true
                },
                {
                    type = "vehicle",
                    model = runtime.vehicle.model,
                    coords = vector4(44.0, -868.0, 29.98, 250.0),
                    color = runtime.vehicle.color,
                    openDoors = runtime.vehicle.trunkDoors,
                    persist = true
                },
                {
                    type = "prop",
                    model = runtime.tank.prop,
                    attachTo = 2,
                    attachOffset = runtime.tank.offset,
                    attachRotation = runtime.tank.rotation,
                    persist = true
                },
                {
                    type = "ped",
                    model = "s_m_m_gentransport",
                    coords = vector4(47.5, -875.5, 29.98, 180.0),
                    faceCoord = vector3(47.06, -872.44, 29.98),
                    anim = { dict = "timetable@gardener@filling_can", name = "gar_ig_5_filling_can", flag = 49 },
                    persist = true
                },
                {
                    type = "prop",
                    model = runtime.tool.wand.prop,
                    attachTo = 4,
                    attachBone = 18905,
                    attachOffset = vector3(0.09, 0.01, 0.0),
                    attachRotation = vector3(300.0, 720.0, 330.0),
                    persist = true
                },
            },
        },
        {
            lockDuration = 2000,
            camCoord = vector3(44.0, -875.0, 31.5),
            camTarget = vector3(47.06, -872.44, 30.48),
        },
        {
            camCoord = vector3(-6.0, -1396.0, 30.5),
            camTarget = vector3(-9.16, -1398.67, 29.6),
            entities = {
                {
                    type = "vehicle",
                    model = runtime.vehicle.model,
                    coords = vector4(-9.16, -1398.67, 28.6, 80.5),
                    color = runtime.vehicle.color,
                    openDoors = {}
                },
                { type = "marker", markerType = 20, coords = vector4(runtime.finishArea.coord.x, runtime.finishArea.coord.y, runtime.finishArea.coord.z + 1.5, 0.0), scale = vector3(0.5, 0.5, 0.5), color = { r = 230, g = 180, b = 50, a = 200 }, bob = true, rotate = true },
            },
        },
    },
}

CarDetailerJob.clothes = {
    male = {
        tshirt_1 = 15,
        tshirt_2 = 0,
        torso_1 = 0,
        torso_2 = 3,
        arms = 85,
        pants_1 = 206,
        pants_2 = 0,
        shoes_1 = 31,
        shoes_2 = 2,
        chain_1 = 0,
        chain_2 = 0,
        helmet_1 = -1,
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
        helmet_1 = -1,
        helmet_2 = 0,
    },
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.startJobFunction)
-- Return true to allow the player to start, false to prevent
CarDetailerJob.startJobFunction = {
    enabled = false, -- true = enable start check for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId)
        return true
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.endJobFunction)
-- lobbyAmount / playerAmount meaning: total cars washed + polished
CarDetailerJob.endJobFunction = {
    enabled = false, -- true = enable end function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.resetJobFunction)
-- Called when the job is cancelled (owner/member leaves mid-job, lobby disbanded, etc.)
CarDetailerJob.resetJobFunction = {
    enabled = false, -- true = enable reset function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

return CarDetailerJob
