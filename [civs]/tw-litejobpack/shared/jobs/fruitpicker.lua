local OrangeJob = {

    id = "fruitpicker",

    icon = "./img/jobs/fruitpicker_icon.svg",
    image = "./img/jobs/fruitpicker_bg.png",
    video = "https://tworst.info/uploads/videos/cb1911e0dec7c0b57021fc37d109dd1e_1775405605.mp4",
    enabled = true, -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0, -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(2383.85, 5023.0, 45.94, 136.67),
        model = "a_m_m_farmer_01",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 631,
            color = 17,
            scale = 0.8,
        },
    },

    xprewards = {
        fruitPicked = 25,
        jobCompleted = 500,
    },

    payment = {
        mode = "onJobEnd", -- "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        completionBonus = 0, -- bonus paid once when job is fully completed
        coopMode = "full", -- "full" = everyone gets full pay | "split" = pay divided by player count
    },

    stepRewards = {
        -- Available phases: onLoad (box loaded into truck), onScale (box placed on scale), onProcess (scale boxes processed)
        onLoad    = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 10 } } },
        onProcess = { enabled = false, dropMode = "perItem", itemList = { { item = "water_bottle", count = 1, chance = 8 } } },
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

    produceTypes = {
        orange = {
            name = "Orange",
            model = "ng_proc_food_ornge1a",
            price = 28,
            kgPerItem = 0.25,
            zOffset = 0.0,
        },
        apple = {
            name = "Apple",
            model = "sf_prop_sf_apple_01a",
            price = 32,
            kgPerItem = 0.20,
            zOffset = 0.0,
        },
    },

    treeLocations = {

        { coords = vector3(2083.5461, 4852.2129, 41.9267) },
        { coords = vector3(2097.9065, 4841.5806, 41.6721) },
        { coords = vector3(2118.0273, 4841.6055, 41.5652) },
        { coords = vector3(2122.2754, 4861.0273, 41.1088) },
        { coords = vector3(2145.9148, 4867.1484, 40.6898) },
        { coords = vector3(2123.4907, 4883.8271, 40.8859) },
        { coords = vector3(2102.2217, 4878.2090, 41.0646) },
        { coords = vector3(2060.6858, 4843.0156, 41.8497) },
        { coords = vector3(2064.1694, 4820.0112, 41.8303) },
        { coords = vector3(2086.6577, 4825.4263, 41.5900) },

        { coords = vector3(2316.3662, 5023.0181, 43.2977), produceType = "apple" },
        { coords = vector3(2329.8904, 5036.9355, 44.4203), produceType = "apple" },
        { coords = vector3(2341.3801, 5035.2676, 44.3373), produceType = "apple" },
        { coords = vector3(2330.5054, 5022.3564, 42.9704), produceType = "apple" },
        { coords = vector3(2316.8284, 5009.4658, 42.5537), produceType = "apple" },
        { coords = vector3(2304.7952, 4997.6152, 42.3384), produceType = "apple" },
        { coords = vector3(2330.7666, 5007.2842, 42.3450), produceType = "apple" },
        { coords = vector3(2343.1177, 5022.4561, 43.4962), produceType = "apple" },
        { coords = vector3(2356.6716, 5020.6250, 43.8605), produceType = "apple" },
        { coords = vector3(2344.8286, 5008.3691, 42.7652), produceType = "apple" },
        { coords = vector3(2331.9026, 4997.0117, 42.1458), produceType = "apple" },
        { coords = vector3(2317.9473, 4984.9653, 41.8093), produceType = "apple" },
        { coords = vector3(2335.8994, 4975.6362, 42.6122), produceType = "apple" },
        { coords = vector3(2349.0010, 4989.3730, 43.0395), produceType = "apple" },
        { coords = vector3(2360.5403, 5001.8145, 43.3952), produceType = "apple" },
        { coords = vector3(2369.8223, 5010.6938, 44.3452), produceType = "apple" },
        { coords = vector3(2376.0703, 5016.2876, 45.3667), produceType = "apple" },
        { coords = vector3(2378.0593, 5003.8711, 44.6562), produceType = "apple" },
        { coords = vector3(2362.0183, 4989.4292, 43.3561), produceType = "apple" },
        { coords = vector3(2349.4980, 4976.3252, 42.7850), produceType = "apple" },
        { coords = vector3(2362.0217, 4976.7930, 43.2530), produceType = "apple" },
        { coords = vector3(2373.6772, 4989.0000, 43.9875), produceType = "apple" },
        { coords = vector3(2389.1765, 5004.7515, 45.7094), produceType = "apple" },
        { coords = vector3(2390.3081, 4992.8550, 45.2204), produceType = "apple" },
    },

    trees = {
        interactDistance = 3.0,
        fruitsPerTree = 5,             -- fruits available per tree before depletion
        respawnTime = 60,              -- legacy lobby-scoped respawn (seconds) — only used when globalCooldownMinutes = 0
        globalCooldownMinutes = 15,    -- 0 = disabled (use legacy lobby-scoped respawnTime). >0 = server-wide cooldown in minutes; once depleted, NO lobby can harvest this tree until cooldown expires.
    },

    pickAnim = {
        dict = "amb@prop_human_movie_bulb@idle_a",
        name = "idle_a",
        duration = 4000,
        ptfxDict = "core",
        ptfxName = "ent_dst_leaves",
        ptfxScale = 1.5,
        ptfxHeightOffset = 6.0,
    },

    box = {

        models = {
            v1 = "prop_crate_03a",
            v2 = "prop_crate_03a",
            v3 = "prop_box_wood05a",
        },

        capacity = {
            v1 = 16,
            v2 = 20,
            v3 = 25,
        },

        playerAttach = {
            bone = 28422,
            offset = vector3(0.01, -0.30, -0.15),
            rotation = vector3(0.0, 0.0, 90.0),
        },

        carryAnim = {
            dict = "anim@heists@box_carry@",
            name = "idle",
        },

        groundOffset = vector3(0.0, 0.5, -0.5),
    },

    produceAttach = {
        bone = 0,
        positions = {
            { offset = vector3(-0.200, -0.340, 0.020), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.070, -0.340, 0.020), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.070, -0.340, 0.020),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.200, -0.340, 0.020),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.200, -0.170, 0.020), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.070, -0.170, 0.020), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.070, -0.170, 0.020),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.200, -0.170, 0.020),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.200, 0.000, 0.020),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.070, 0.000, 0.020),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.070, 0.000, 0.020),   rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.200, 0.000, 0.020),   rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.200, 0.170, 0.020),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.070, 0.170, 0.020),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.070, 0.170, 0.020),   rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.200, 0.170, 0.020),   rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.200, 0.340, 0.020),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.070, 0.340, 0.020),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.070, 0.340, 0.020),   rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.200, 0.340, 0.020),   rotation = vector3(0.0, 0.0, 0.0) },
        },
    },

    animations = {
        pickOrange = {
            dict = "amb@prop_human_movie_bulb@idle_a",
            name = "idle_a",
            duration = 2000,
        },
        pickupBox = {
            dict = "pickup_object",
            name = "pickup_low",
        },
        putdownBox = {
            dict = "pickup_object",
            name = "putdown_low",
        },
    },

    vehicle = {
        spawnLocations = {
            vector4(2370.57, 5020.9, 44.34, 129.65),
            vector4(2360.05, 5012.39, 43.06, 129.64),
            vector4(2381.64, 5010.0, 44.99, 106.45),
            vector4(2368.12, 5002.76, 43.23, 230.72),
        },
        model = "bison",
        color = { primary = 64, secondary = 111 },
        plate = "ORANGE",
        useCustomPlate = false,
        fuelOnSpawn = 100.0,
        trunkDoors = { 5 },

        boxPositions = {

            { offset = vector3(-0.350, -2.100, 0.270), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.410, -2.100, 0.270),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.010, -1.160, 0.270),  rotation = vector3(0.0, 0.0, 0.0) },

            { offset = vector3(-0.350, -2.100, 0.570), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.410, -2.100, 0.570),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.010, -1.160, 0.570),  rotation = vector3(0.0, 0.0, 0.0) },
        },

        emptyBoxPositions = {
            { offset = vector3(-0.350, -2.100, 0.270), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.410, -2.100, 0.270),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.010, -1.160, 0.270),  rotation = vector3(0.0, 0.0, 0.0) },
        },
    },

    processing = {
        coord = vector4(2374.900, 5028.530, 44.883, -44.116),
        prop = "tw_baskul",
        propOffset = vector3(0.0, 0.0, 0.0),
        propRotation = vector3(0.0, 0.0, 0.0),
        spawnDistance = 50.0,
        interactDistance = 2.5,
        maxDistanceFromScale = 15.0,
        maxScaleItems = 20,
        -- When true, loading a FULL box into the truck immediately spawns a fresh
        -- EMPTY box back in the trunk (1:1 swap). Lets a crew keep harvesting at a
        -- distant field — drop the full box, grab an empty one — instead of driving
        -- back to the scale every time a box fills up. Off by default.
        refillEmptyBoxOnLoad = false,
        progressTarget = 5, -- FALLBACK only. The progress bar now fills against the number of boxes loaded into the truck per round (#vehicle.emptyBoxPositions), so it always reaches 100%. This value is only used if that list is missing.
        scaleItemSpacing = 0.5,
        scaleStackHeight = 0.5,

        economyItem = "fruitpicker",

        levelPayBonus = 0.02,

        levelChanceBonus = 0.5,

        qualityTiers = {
            { name = "Common",  chance = 60, multiplier = 1.0 },
            { name = "Fresh",   chance = 25, multiplier = 1.3 },
            { name = "Premium", chance = 10, multiplier = 1.6 },
            { name = "Organic", chance = 5,  multiplier = 2.0 },
        },
        npc = {
            model = "s_m_y_construct_01",
            coord = vector4(2372.57, 5030.32, 45.66, 155.24),
            scenario = "WORLD_HUMAN_CLIPBOARD",
            interactDistance = 2.0,
        },

        carrier = {
            npcModel        = "s_m_y_construct_02",
            carryProp       = "prop_crate_03a",
            maxItemsToCarry = 3,
            walkSpeed       = 1.0,

            spawnCoord      = vector4(2378.75, 5037.68, 46.16, 224.77),
            dropCoord       = vector4(2383.55, 5033.57, 45.88, 50.44),

            carryBone       = 28422,
            carryOffset     = vector3(0.01, -0.30, -0.15),
            carryRotation   = vector3(0.0, 0.0, 90.0),
            pickupTime      = 2000,
            dropTime        = 1500,
        },
    },

    workClothes = {
        coord = vector4(2387.091, 5018.923, 45.001, -45.010),
    },
}

OrangeJob.runtime = runtime

local vehSpawn = runtime.vehicle.spawnLocations[1]
local headingRad = math.rad(vehSpawn.w)
local trunkX = vehSpawn.x + math.sin(headingRad) * 3.0
local trunkY = vehSpawn.y - math.cos(headingRad) * 3.0
local trunkHeading = (vehSpawn.w + 180.0) % 360.0

OrangeJob.preview = {
    playerPosition = vector3(2383.85, 5023.0, 45.94),
    vehicleStep = 3,
    steps = {

        {
            camCoord = vector3(2382.0, 5021.1, 46.7),
            camTarget = vector3(2385.5, 5024.7, 46.2),
        },

        {
            autoClothes = true,
            camCoord = vector3(2384.4, 5016.0, 47.6),
            camTarget = vector3(2387.4, 5019.2, 45.3),
        },

        {
            autoVehicle = true,
            autoCargo = { count = 2, model = runtime.box.models.v1 },
            camCoord = vector3(2374.2, 5023.9, 47.4),
            camTarget = vector3(2370.8, 5021.1, 45.0),
        },

        {
            camCoord = vector3(2085.5, 4856.1, 42.9),
            camTarget = vector3(2083.2, 4851.6, 42.4),
            entities = {
                {
                    type = "ped",
                    model = "a_m_m_farmer_01",
                    coords = vector4(2084.55, 4852.21, 41.93, 270.0),
                    faceCoord = vector3(2083.55, 4852.21, 41.93),
                    anim = { dict = runtime.animations.pickOrange.dict, name = runtime.animations.pickOrange.name, flag = 1 },
                    persist = false
                },
            },
        },

        {
            camCoord = vector3(2085.8, 4856.3, 43.3),
            camTarget = vector3(2083.8, 4852.0, 41.8),
            entities = {
                {
                    type = "ped",
                    model = "a_m_m_farmer_01",
                    coords = vector4(2084.5, 4853.0, 41.93, 220.0),
                    anim = { dict = runtime.box.carryAnim.dict, name = runtime.box.carryAnim.name, flag = 49 },
                    persist = false
                },
                {
                    type = "prop",
                    model = runtime.box.models.v1,
                    attachTo = 1,
                    attachBone = runtime.box.playerAttach.bone,
                    attachOffset = runtime.box.playerAttach.offset,
                    attachRotation = runtime.box.playerAttach.rotation,
                    persist = false
                },
                {
                    type = "prop",
                    model = runtime.produceTypes.orange.model,
                    attachTo = 2,
                    attachBone = 0,
                    attachOffset = runtime.produceAttach.positions[1].offset,
                    attachRotation = runtime.produceAttach.positions[1].rotation,
                    persist = false
                },
                {
                    type = "prop",
                    model = runtime.produceTypes.orange.model,
                    attachTo = 2,
                    attachBone = 0,
                    attachOffset = runtime.produceAttach.positions[3].offset,
                    attachRotation = runtime.produceAttach.positions[3].rotation,
                    persist = false
                },
                {
                    type = "prop",
                    model = runtime.produceTypes.orange.model,
                    attachTo = 2,
                    attachBone = 0,
                    attachOffset = runtime.produceAttach.positions[5].offset,
                    attachRotation = runtime.produceAttach.positions[5].rotation,
                    persist = false
                },
            },
        },

        {
            camCoord = vector3(2374.1, 5023.9, 47.6),
            camTarget = vector3(2370.8, 5021.1, 45.0),
            entities = {
                {
                    type = "ped",
                    model = "a_m_m_farmer_01",
                    coords = vector4(trunkX, trunkY, vehSpawn.z, vehSpawn.w),
                    anim = { dict = runtime.box.carryAnim.dict, name = runtime.box.carryAnim.name, flag = 49 },
                    persist = false
                },
                {
                    type = "prop",
                    model = runtime.box.models.v1,
                    attachTo = 1,
                    attachBone = runtime.box.playerAttach.bone,
                    attachOffset = runtime.box.playerAttach.offset,
                    attachRotation = runtime.box.playerAttach.rotation,
                    persist = false
                },
                {
                    type = "prop",
                    model = runtime.produceTypes.orange.model,
                    attachTo = 2,
                    attachBone = 0,
                    attachOffset = runtime.produceAttach.positions[1].offset,
                    attachRotation = runtime.produceAttach.positions[1].rotation,
                    persist = false
                },
                {
                    type = "prop",
                    model = runtime.produceTypes.orange.model,
                    attachTo = 2,
                    attachBone = 0,
                    attachOffset = runtime.produceAttach.positions[3].offset,
                    attachRotation = runtime.produceAttach.positions[3].rotation,
                    persist = false
                },
            },
        },

        {
            autoScale = true,
            autoCarrier = true,
            scaleDUI = { rockCount = 2, payPerRock = runtime.produceTypes.orange.price },
            camCoord = vector3(2371.4, 5025.2, 46.9),
            camTarget = vector3(2374.8, 5028.5, 45.4),
            entities = {
                {
                    type = "prop",
                    model = runtime.box.models.v1,
                    coords = vector4(runtime.processing.coord.x, runtime.processing.coord.y,
                        runtime.processing.coord.z + 2.0, 0.0),
                    spawnDelay = 2000
                },
                {
                    type = "prop",
                    model = runtime.produceTypes.orange.model,
                    coords = vector4(runtime.processing.coord.x - 0.07, runtime.processing.coord.y - 0.17,
                        runtime.processing.coord.z + 2.0, 0.0),
                    spawnDelay = 2500
                },
                {
                    type = "prop",
                    model = runtime.produceTypes.orange.model,
                    coords = vector4(runtime.processing.coord.x + 0.07, runtime.processing.coord.y + 0.17,
                        runtime.processing.coord.z + 2.0, 0.0),
                    spawnDelay = 2500
                },
            },
        },
    },
}

OrangeJob.clothes = {
    male = {
        tshirt_1 = 15,
        tshirt_2 = 1,
        torso_1 = 271,
        torso_2 = 0,
        arms = 0,
        pants_1 = 90,
        pants_2 = 0,
        shoes_1 = 12,
        shoes_2 = 0,
        chain_1 = 0,
        chain_2 = 0,
        helmet_1 = 13,
        helmet_2 = 1,
    },
    female = {
        tshirt_1 = 36,
        tshirt_2 = 1,
        torso_1 = 9,
        torso_2 = 6,
        decals_1 = 0,
        decals_2 = 0,
        arms = 0,
        pants_1 = 92,
        pants_2 = 2,
        shoes_1 = 12,
        shoes_2 = 0,
        chain_1 = -1,
        chain_2 = 0,
        helmet_1 = 141,
        helmet_2 = 6,
    },
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.startJobFunction)
-- Return true to allow the player to start, false to prevent
OrangeJob.startJobFunction = {
    enabled = false, -- true = enable start check for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId)
        return true
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.endJobFunction)
-- lobbyAmount / playerAmount meaning: number of fruit boxes processed
OrangeJob.endJobFunction = {
    enabled = false, -- true = enable end function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.resetJobFunction)
-- Called when the job is cancelled (owner/member leaves mid-job, lobby disbanded, etc.)
OrangeJob.resetJobFunction = {
    enabled = false, -- true = enable reset function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

return OrangeJob
