local LumberjackJob = {

    id = "lumberjack",

    icon = "./img/jobs/lumberjack_icon.svg",
    image = "./img/jobs/lumberjack_bg.png",
    video = "https://tworst.info/uploads/videos/dc18bd5d881001afb8e83666e768d49d_1775405623.mp4",
    enabled = true,    -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0,      -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(-559.7979, 5356.7124, 70.2, 78.3917),
        model = "a_m_m_farmer_01",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 436,
            color = 2,
            scale = 0.8,
        },
    },

    xprewards = {
        logProcessed = 100,
        jobCompleted = 500,
    },

    payment = {
        mode = "onJobEnd",   -- "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        completionBonus = 0, -- bonus paid once when job is fully completed
        coopMode = "full",   -- "full" = everyone gets full pay | "split" = pay divided by player count
    },

    stepRewards = {
        -- Available phases: onBreak (object broken), onPickup (picked up from ground), onScale (placed on scale), onProcess (scale items processed)
        onBreak   = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 10 } } },
        onPickup  = { enabled = false, dropMode = "perItem", itemList = { { item = "water_bottle", count = 1, chance = 8 } } },
        onProcess = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 15 } } },
    },

    missioncompletedItems = {
        giveItemPlayer = false,    -- true = give items on job complete | false = no items given
        dropMode = "weightedPool", -- "weightedPool" = pick one item by chance weight | "perItem" = each item rolls independently
        itemList = {
            { item = "sandwich",     count = 1, chance = 50 },
            { item = "water_bottle", count = 1, chance = 30 },
        },
    },

}

local runtime = {

    treeTiers = {
        [1] = {
            name = "Pine",
            model = "prop_tree_pine_02",
            dropModel = "tw_cuttree",
            groundZAdjust = -0.5,
            health = 100,
            requiredLevel = 0,
            respawnTime = 30000,
            experience = 30,
            drops = {
                { item = "wood",          chance = 100, amount = { min = 2, max = 4 } },
                { item = "pine_resin",    chance = 25,  amount = { min = 1, max = 2 } },
                { item = "wood_shavings", chance = 15,  amount = { min = 1, max = 1 } },
            },
            blip = { sprite = 1, color = 2, scale = 0.6 },
        },
        [2] = {
            name = "Oak",
            model = "prop_tree_oak_01",
            dropModel = "tw_cuttree",
            health = 200,
            requiredLevel = 3,
            respawnTime = 45000,
            experience = 50,
            trunkRadius = 0.85,
            playerOffset = 3.0,
            spreadWidth = 1.2,
            ballFrontDistance = 1.0,
            ballChestOffset = 0.7,
            drops = {
                { item = "oak_wood",      chance = 100, amount = { min = 2, max = 4 } },
                { item = "oak_bark",      chance = 30,  amount = { min = 1, max = 2 } },
                { item = "wood_shavings", chance = 20,  amount = { min = 1, max = 2 } },
            },
            blip = { sprite = 1, color = 25, scale = 0.6 },
        },
        [3] = {
            name = "Maple",
            model = "prop_tree_birch_04",
            dropModel = "tw_cuttree",
            health = 300,
            requiredLevel = 7,
            respawnTime = 60000,
            experience = 75,
            drops = {
                { item = "maple_wood",    chance = 100, amount = { min = 2, max = 4 } },
                { item = "maple_sap",     chance = 35,  amount = { min = 1, max = 2 } },
                { item = "wood_shavings", chance = 25,  amount = { min = 1, max = 3 } },
            },
            blip = { sprite = 1, color = 27, scale = 0.6 },
        },
    },

    treeZOffset = -1.0,

    levelBonus = {
        dropChancePerLevel = 0.5,
        bonusAmountAtLevel10 = { chance = 25, extraAmount = 1 },
    },

    treeSpawns = {

        { coord = vector4(-622.9656, 5500.0391, 51.3581, 154.9108),                      tier = 1 },
        { coord = vector4(-618.0844, 5501.2227, 51.1275, 306.3838),                      tier = 1 },
        { coord = vector4(-628.9519, 5506.2837, 51.2952, 112.9625),                      tier = 1 },
        { coord = vector4(-599.6562, 5524.4834, 49.8086, 327.2852),                      tier = 1 },
        { coord = vector4(-595.5886, 5533.9688, 49.3167, 150.5597),                      tier = 1 },
        { coord = vector4(-578.7582, 5529.8989, 52.0475, 126.6012),                      tier = 1 },
        { coord = vector4(-580.1907, 5513.8848, 53.3412, 154.1225),                      tier = 1 },
        { coord = vector4(-610.7286, 5487.7920, 52.5106, 113.3707),                      tier = 1 },
        { coord = vector4(-623.6525, 5474.9883, 53.2221, 50.8282),                       tier = 1 },

        { coord = vector4(-429.78479003906, 5114.0317382812, 128.32527160645, 108.7410), tier = 2 },
        { coord = vector4(-436.6448059082, 5099.8627929688, 133.0337677002, 282.1778),   tier = 2 },
        { coord = vector4(-451.46551513672, 5093.4609375, 131.66151428223, 318.2665),    tier = 2 },
        { coord = vector4(-463.56408691406, 5094.748046875, 127.53249359131, 129.9461),  tier = 2 },
        { coord = vector4(-475.41390991211, 5109.9228515625, 118.83428192139, 300.2714), tier = 2 },
        { coord = vector4(-463.4758, 5126.9482, 114.8000, 108.5009),                     tier = 2 },
        { coord = vector4(-441.75531005859, 5140.4057617188, 110.85556030273, 106.2247), tier = 2 },
        { coord = vector4(-410.81790161133, 5156.2055664062, 109.71938323975, 53.7552),  tier = 2 },
        { coord = vector4(-451.00479125977, 5163.8369140625, 98.446746826172, 274.4018), tier = 2 },
        { coord = vector4(-508.93771362305, 5124.1240234375, 102.9383392334, 132.3461),  tier = 2 },

        { coord = vector4(-391.5370, 5822.2686, 52.5379, 50.5945),                       tier = 3 },
        { coord = vector4(-398.7094, 5818.3325, 53.0780, 145.3103),                      tier = 3 },
        { coord = vector4(-402.8769, 5800.3042, 56.3064, 298.2545),                      tier = 3 },
        { coord = vector4(-420.0493, 5788.0454, 56.5696, 167.8292),                      tier = 3 },
        { coord = vector4(-433.9449, 5775.0776, 57.4026, 165.7425),                      tier = 3 },
        { coord = vector4(-439.9830, 5800.5703, 52.8733, 355.8024),                      tier = 3 },
        { coord = vector4(-419.0450, 5862.3311, 45.5359, 330.7614),                      tier = 3 },
        { coord = vector4(-386.4062, 5874.7769, 49.3200, 141.6990),                      tier = 3 },
        { coord = vector4(-363.1449, 5902.1709, 46.1521, 138.5165),                      tier = 3 },
        { coord = vector4(-646.0052, 5479.5630, 52.0225, 159.4229),                      tier = 3 },
    },

    treeBlips = {
        enabled = true,
    },

    breakSession = {
        type = "tree",
        ballCount = { min = 4, max = 6 },
        ballSize = 0.15,
        repeatPerBall = 2,
    },

    animations = {
        chopping = {
            dict = "melee@large_wpn@streamed_core",
            name = "ground_attack_on_spot_body",
            duration = 8000,
        },
        carry = {
            dict = "anim@heists@box_carry@",
            name = "idle",
        },
    },

    sounds = {
        enabled = true,
        axeHit = { name = "axe_hit", volume = 0.15 },
        treeFall = { name = "tree_fall", volume = 0.6 },
        itemPickup = { name = "item_pickup", volume = 0.3 },
        levelUp = { name = "level_up", volume = 0.5 },
    },

    collectedProp = {
        model = "tw_cuttree",
        bone = 24818,
        offset = vector3(-0.310, 0.360, 0.020),
        rotation = vector3(0.0, 90.0, 0.0),
    },

    logPickup = {
        model = "tw_cuttree",
        interactionDistance = 1.5,
        pickupTime = 2000,
    },

    particles = "ent_dst_wood_splinter",

    outline = {
        enabled = true,
        unbrokenColor = { r = 100, g = 200, b = 50, a = 255 },
        pickupColor = { r = 255, g = 200, b = 50, a = 255 },
        range = 20.0,
    },

    breakCompleteEffect = {
        asset = "des_vaultdoor",
        name = "ent_dst_wood_splinter",
        scale = 2.0,
        zOffset = 1.0,
        shake = { type = "SMALL_EXPLOSION_SHAKE", intensity = 0.075 },
    },

    vehicle = {
        spawnLocations = {
            vector4(-576.1255, 5374.6016, 70.2464, 299.7000),
            vector4(-573.15, 5369.39, 70.2464, 299.7000),
            vector4(-579.11, 5379.81, 70.2464, 299.7000),
        },
        model = "bison",
        color = { primary = 28, secondary = 0 },
        plate = "LUMBER",
        useCustomPlate = false,
        fuelOnSpawn = 100.0,
        trunkDoors = { 5 },
        trunkOffset = -3.5, -- distance behind vehicle when picking up / returning tools

        toolPositions = {
            { offset = vector3(-0.500, -1.010, 0.610), rotation = vector3(90.0, 0.0, 0.0) },
            { offset = vector3(0.560, -1.010, 0.610),  rotation = vector3(90.0, 0.0, 0.0) },
            { offset = vector3(0.010, -0.910, 0.300),  rotation = vector3(90.0, 0.0, 0.0) },
        },

        cargoPositions = {
            { offset = vector3(-0.179, -1.017, 0.250), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.304, -1.100, 0.250),  rotation = vector3(0.5, 0.0, 90.0) },
            { offset = vector3(-0.179, -1.402, 0.250), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.304, -1.608, 0.250),  rotation = vector3(0.0, 0.0, 90.0) },
            { offset = vector3(-0.179, -1.696, 0.250), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.613, -1.669, 0.250),  rotation = vector3(0.0, 0.0, 90.0) },
            { offset = vector3(-0.482, -1.563, 0.250), rotation = vector3(0.0, 0.0, 90.0) },
            { offset = vector3(-0.179, -2.036, 0.250), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.545, -2.045, 0.250), rotation = vector3(0.0, 0.0, 90.0) },
            { offset = vector3(-0.181, -2.422, 0.250), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.295, -2.138, 0.250),  rotation = vector3(0.0, 0.0, 90.0) },
            { offset = vector3(0.618, -2.191, 0.250),  rotation = vector3(0.0, 0.0, 90.0) },

            { offset = vector3(-0.179, -1.017, 0.640), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.304, -1.100, 0.640),  rotation = vector3(0.5, 0.0, 90.0) },
            { offset = vector3(-0.179, -1.402, 0.640), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.304, -1.608, 0.640),  rotation = vector3(0.0, 0.0, 90.0) },
            { offset = vector3(-0.179, -1.696, 0.640), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.613, -1.669, 0.640),  rotation = vector3(0.0, 0.0, 90.0) },
            { offset = vector3(-0.482, -1.563, 0.640), rotation = vector3(0.0, 0.0, 90.0) },
            { offset = vector3(-0.179, -2.036, 0.640), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.545, -2.045, 0.640), rotation = vector3(0.0, 0.0, 90.0) },
            { offset = vector3(-0.181, -2.422, 0.640), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.295, -2.138, 0.640),  rotation = vector3(0.0, 0.0, 90.0) },
            { offset = vector3(0.618, -2.191, 0.640),  rotation = vector3(0.0, 0.0, 90.0) },
        },
    },

    processing = {
        coord = vector4(-570.6354, 5332.8, 69.2145, 251.2287),
        prop = "tw_baskul",
        propOffset = vector3(0.0, 0.0, 0.0),
        propRotation = vector3(0.0, 0.0, 0.0),
        spawnDistance = 50.0,
        interactDistance = 2.5,
        maxDistanceFromScale = 15.0,
        payPerLog = 100,
        kgPerItem = 25,
        maxScaleItems = 20,

        levelPayBonus = 0.02,

        levelChanceBonus = 0.5,

        qualityTiers = {
            { name = "Common",   chance = 50, multiplier = 1.0 },
            { name = "Fine",     chance = 25, multiplier = 1.3 },
            { name = "Superior", chance = 15, multiplier = 1.8 },
            { name = "Ancient",  chance = 10, multiplier = 2.5 },
        },

        npc = {
            model = "s_m_y_construct_02",
            coord = vector4(-569.92, 5335.32, 69.21, 68.01),
            scenario = "WORLD_HUMAN_CLIPBOARD",
            interactDistance = 2.0,
        },

        carrier = {
            npcModel        = "s_m_y_construct_02",
            carryProp       = "tw_cuttree",
            maxItemsToCarry = 3,
            walkSpeed       = 1.0,

            spawnCoord      = vector4(-565.41, 5325.77, 73.6, 70.14),
            dropCoord       = vector4(-565.41, 5325.77, 73.6, 70.14),

            carryBone       = 24818,
            carryOffset     = vector3(-0.15, 0.4, 0.01),
            carryRotation   = vector3(0.0, 90.0, 0.0),
            pickupTime      = 2000,
            dropTime        = 1500,
        },
    },

    workClothes = {
        coord = vector4(-571.152, 5361.175, 69.240, 70.693),
    },
}

LumberjackJob.runtime = runtime

local vehSpawn = runtime.vehicle.spawnLocations[1]
local headingRad = math.rad(vehSpawn.w)
local trunkX = vehSpawn.x + math.sin(headingRad) * 3.5
local trunkY = vehSpawn.y - math.cos(headingRad) * 3.5
local trunkHeading = (vehSpawn.w + 180.0) % 360.0

LumberjackJob.preview = {
    playerPosition = vector3(-560.0, 5357.0, 69.2),
    vehicleStep = 3,
    steps = {

        {
            camCoord = vector3(-563.5, 5357.3, 71.5),
            camTarget = vector3(-558.6, 5356.5, 70.4),
        },

        {
            autoClothes = true,
            camCoord = vector3(-566.5, 5359.6, 72.0),
            camTarget = vector3(-570.8, 5361.0, 69.9),
        },

        {
            autoVehicle = true,
            autoTools = { model = Config.Tools.lumberjack.default.prop },
            camCoord = vector3(-580.3, 5372.0, 72.0),
            camTarget = vector3(-576.2, 5374.6, 70.8),
        },

        {
            lockDuration = 4000,
            camCoord = vector3(-616.8, 5497.0, 53.4),
            camTarget = vector3(-618.2, 5501.5, 51.5),
            entities = {

                { type = "prop", model = runtime.treeTiers[1].model, coords = vector4(-618.08, 5501.22, 50.13, 306.38), rawZ = true, removeDelay = 3500 },

                { type = "prop", model = runtime.treeTiers[1].model, coords = vector4(-628.95, 5506.28, 50.30, 112.96), rawZ = true },
                { type = "prop", model = runtime.treeTiers[1].model, coords = vector4(-622.97, 5500.04, 50.36, 154.91), rawZ = true },

                {
                    type = "ped",
                    model = "a_m_m_farmer_01",
                    coords = vector4(-616.58, 5501.22, 51.13, 270.0),
                    faceCoord = vector3(-618.08, 5501.22, 51.13),
                    anim = { dict = runtime.animations.chopping.dict, name = runtime.animations.chopping.name, flag = 1 },
                    persist = false
                },

                {
                    type = "prop",
                    model = Config.Tools.lumberjack.default.prop,
                    attachTo = 4,
                    attachBone = Config.Tools.lumberjack.default.handAttach.boneId,
                    attachOffset = vector3(Config.Tools.lumberjack.default.handAttach.x,
                        Config.Tools.lumberjack.default.handAttach.y, Config.Tools.lumberjack.default.handAttach.z),
                    attachRotation = vector3(Config.Tools.lumberjack.default.handAttach.rotX,
                        Config.Tools.lumberjack.default.handAttach.rotY, Config.Tools.lumberjack.default.handAttach.rotZ),
                    persist = false
                },

                {
                    type = "prop",
                    model = runtime.logPickup.model,
                    coords = vector4(-618.08, 5501.22, 51.13, 0.0),
                    spawnDelay = 3000,
                    persist = false
                },
            },
        },

        {
            camCoord = vector3(-616.6, 5505.4, 53.0),
            camTarget = vector3(-618.2, 5500.9, 51.5),
            entities = {

                {
                    type = "ped",
                    model = "a_m_m_farmer_01",
                    coords = vector4(-618.08, 5501.22, 51.13, 120.0),
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
            camCoord = vector3(-628.9, 5503.8, 53.6),
            camTarget = vector3(-629.1, 5499.1, 51.9),
            entities = {
                {
                    type = "vehicle",
                    model = runtime.vehicle.model,
                    coords = vector4(-629.12, 5497.87, 50.92, 175.52),
                    color = runtime.vehicle.color,
                    openDoors = runtime.vehicle.trunkDoors
                },
                {
                    type = "prop",
                    model = runtime.collectedProp.model,
                    attachTo = 1,
                    attachOffset = runtime.vehicle.cargoPositions[1].offset,
                    attachRotation = runtime.vehicle.cargoPositions[1].rotation
                },
                {
                    type = "prop",
                    model = runtime.collectedProp.model,
                    attachTo = 1,
                    attachOffset = runtime.vehicle.cargoPositions[2].offset,
                    attachRotation = runtime.vehicle.cargoPositions[2].rotation
                },
                {
                    type = "prop",
                    model = runtime.collectedProp.model,
                    attachTo = 1,
                    attachOffset = runtime.vehicle.cargoPositions[3].offset,
                    attachRotation = runtime.vehicle.cargoPositions[3].rotation
                },
                {
                    type = "ped",
                    model = "a_m_m_farmer_01",
                    coords = vector4(-629.12, 5501.37, 50.92, 175.52),
                    anim = { dict = runtime.animations.carry.dict, name = runtime.animations.carry.name, flag = 49 },
                    persist = false
                },
                {
                    type = "prop",
                    model = runtime.collectedProp.model,
                    attachTo = 5,
                    attachBone = runtime.collectedProp.bone,
                    attachOffset = runtime.collectedProp.offset,
                    attachRotation = runtime.collectedProp.rotation,
                    persist = false
                },
            },
        },

        {
            autoScale = true,
            scaleDUI = { rockCount = 2, payPerRock = runtime.processing.payPerLog },
            camCoord = vector3(-574.5, 5334.2, 71.8),
            camTarget = vector3(-570.4, 5332.7, 69.5),
            entities = {

                { type = "prop", model = runtime.collectedProp.model, coords = vector4(runtime.processing.coord.x, runtime.processing.coord.y, runtime.processing.coord.z + 2.0, 0.0),               spawnDelay = 2000 },
                { type = "prop", model = runtime.collectedProp.model, coords = vector4(runtime.processing.coord.x - 0.3, runtime.processing.coord.y + 0.26, runtime.processing.coord.z + 2.0, 45.0), spawnDelay = 2000 },
            },
        },
    },
}

LumberjackJob.clothes = {
    male = {
        tshirt_1 = 15,
        tshirt_2 = 0,
        torso_1 = 234,
        torso_2 = 19,
        decals_1 = 0,
        decals_2 = 0,
        arms = 0,
        pants_1 = 123,
        pants_2 = 0,
        shoes_1 = 72,
        shoes_2 = 11,
        chain_1 = 0,
        chain_2 = 0,
        helmet_1 = 145,
        helmet_2 = 1,
        ears_1 = -1,
        ears_2 = 0,
        bproof_1 = 0,
        bproof_2 = 0,

    },
    female = {
        tshirt_1 = 14,
        tshirt_2 = 0,
        torso_1 = 9,
        torso_2 = 7,
        decals_1 = 0,
        decals_2 = 0,
        arms = 0,
        pants_1 = 129,
        pants_2 = 0,
        shoes_1 = 75,
        shoes_2 = 11,
        chain_1 = -1,
        chain_2 = 0,
        helmet_1 = 144,
        helmet_2 = 1,
    },
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.startJobFunction)
-- Return true to allow the player to start, false to prevent
LumberjackJob.startJobFunction = {
    enabled = false, -- true = enable start check for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId)
        return true
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.endJobFunction)
-- lobbyAmount / playerAmount meaning: number of logs processed
LumberjackJob.endJobFunction = {
    enabled = false, -- true = enable end function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.resetJobFunction)
-- Called when the job is cancelled (owner/member leaves mid-job, lobby disbanded, etc.)
LumberjackJob.resetJobFunction = {
    enabled = false, -- true = enable reset function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

return LumberjackJob
