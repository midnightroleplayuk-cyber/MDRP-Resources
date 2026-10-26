local K4MB1Cave = false -- Enable only if you have the K4MB1 Cave asset

local MinerJob = {

    id = "miner",

    icon = "./img/jobs/miner_icon.svg",
    image = "./img/jobs/miner_bg.png",
    video = "https://tworst.info/uploads/videos/a40eee3a6561e2a360c7a5b75a25a815_1775405622.mp4",
    enabled = true,    -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0,      -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)
    -- maxConcurrentLobbies = 2, -- max teams/lobbies doing this job at once (requires Config.MaxConcurrentLobbies.enabled). nil/omitted = unlimited

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = K4MB1Cave
            and vector4(-594.52, 2127.86, 128.55, 76.53)
            or vector4(2944.13, 2743.39, 43.3, 349.75),
        model = "s_m_y_construct_02",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 618,
            color = 28,
            scale = 0.8,
        },
    },

    xprewards = {
        oreExtracted = 25,
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

    -- Where the truck is handed back in to close the shift. Matches the vehicle
    -- spawn area, so you return it where you took it instead of the truck being
    -- deleted under you the moment you press End Job.
    depot = {
        coord = K4MB1Cave
            and vector3(-597.20, 2130.50, 128.55)
            or vector3(2952.4795, 2748.9543, 43.5048),
        vehicleRadius = 30.0, -- how close the truck must be to hand in
    },

    rockSpawns = K4MB1Cave and {
        { coord = vector4(-579.1385, 1912.2461, 120.1003, 0.0),   prop = "prop_rock_4_e" },
        { coord = vector4(-589.7802, 1892.3715, 121.0271, 53.0),  prop = "prop_rock_4_e" },
        { coord = vector4(-587.6703, 1866.6857, 123.0322, 323.0), prop = "prop_rock_4_e" },
        { coord = vector4(-553.4769, 1899.3759, 118.4202, 23.0),  prop = "prop_rock_4_e" },
        { coord = vector4(-567.9033, 1903.9517, 120.3195, 2.0),   prop = "prop_rock_4_e" },
        { coord = vector4(-577.7011, 1914.5538, 120.2014, 314.0), prop = "prop_rock_4_e" },
        { coord = vector4(-580.5626, 1885.7142, 120.5721, 280.0), prop = "prop_rock_4_e" },
        { coord = vector4(-567.5604, 1865.8945, 122.1392, 197.0), prop = "prop_rock_4_e" },
        { coord = vector4(-563.8813, 1856.5714, 120.4037, 259.0), prop = "prop_rock_4_e" },
        { coord = vector4(-551.4066, 1871.6835, 118.2941, 276.0), prop = "prop_rock_4_e" },
        { coord = vector4(-516.1187, 1880.7935, 119.6622, 240.0), prop = "prop_rock_4_e" },
    } or {
        { coord = vector4(2947.3215, 2775.0278, 39.2098, 0.4355),   prop = "prop_rock_4_e" },
        { coord = vector4(2942.9736, 2781.1245, 39.4767, 53.7776),  prop = "prop_rock_4_e" },
        { coord = vector4(2942.3884, 2793.7419, 40.4890, 323.3751), prop = "prop_rock_4_e" },
        { coord = vector4(2933.0562, 2794.9812, 40.6525, 23.3731),  prop = "prop_rock_4_e" },
        { coord = vector4(2933.3738, 2801.5969, 41.2817, 2.5912),   prop = "prop_rock_4_e" },
        { coord = vector4(2937.8716, 2806.1570, 41.8021, 314.8870), prop = "prop_rock_4_e" },
        { coord = vector4(2943.9722, 2806.7549, 41.4724, 280.8404), prop = "prop_rock_4_e" },
        { coord = vector4(2945.6067, 2801.8035, 41.1874, 197.1808), prop = "prop_rock_4_e" },
        { coord = vector4(2950.5522, 2799.7483, 41.2166, 259.2867), prop = "prop_rock_4_e" },
        { coord = vector4(2955.1768, 2800.5999, 41.5068, 276.8328), prop = "prop_rock_4_e" },
        { coord = vector4(2967.0620, 2797.4790, 40.9890, 240.7660), prop = "prop_rock_4_e" },
    },

    rocks = {
        models = {
            "prop_rock_4_e",
            "prop_rock_4_a",
            "prop_rock_4_b",
        },
    },

    oreTypes = {
        { id = 'coal',    name = 'Coal',    prop = 'prop_rock_5_d_coal',    economyItem = 'coal_ore',    payPerItem = 60,  weight = 100 },
        { id = 'iron',    name = 'Iron',    prop = 'prop_rock_5_d_iron',    economyItem = 'iron_ore',    payPerItem = 85,  weight = 40 },
        { id = 'gold',    name = 'Gold',    prop = 'prop_rock_5_d_gold',    economyItem = 'gold_ore',    payPerItem = 120, weight = 10 },
        { id = 'emerald', name = 'Emerald', prop = 'prop_rock_5_d_emerald', economyItem = 'emerald_ore', payPerItem = 160, weight = 7 },
        { id = 'diamond', name = 'Diamond', prop = 'prop_rock_5_d_diamond', economyItem = 'diamond_ore', payPerItem = 210, weight = 3 },
    },

    breakSession = {
        type = "rock",
        ballCount = { min = 3, max = 5 },
        ballSize = 0.15,
    },

    animations = {
        mining = {
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
        model = "prop_rock_5_d_coal",
        bone = 24818,
        offset = vector3(-0.15, 0.4, 0.01),
        rotation = vector3(0.0, 90.0, 0.0),
    },

    orePickup = {
        model = "prop_rock_5_d_coal",
        interactionDistance = 1.5,
        pickupTime = 2000,
    },

    particles = "ent_col_rocks",

    outline = {
        enabled = true,
        unbrokenColor = { r = 255, g = 200, b = 50, a = 255 },
        pickupColor = { r = 50, g = 255, b = 100, a = 255 },
        range = 15.0,
    },

    breakCompleteEffect = {
        asset = "core",
        name = "ent_dst_rocks",
        scale = 2.0,
        zOffset = 0.5,
        name2 = "ent_dst_rocks_dusty",
        scale2 = 1.5,
        zOffset2 = 1.5,
        shake = { type = "SMALL_EXPLOSION_SHAKE", intensity = 0.08 },
    },

    vehicle = {
        spawnLocations = K4MB1Cave and {
            vector4(-597.20, 2130.50, 128.55, 76.0),
            vector4(-597.20, 2125.50, 128.55, 76.0),
            vector4(-597.20, 2120.50, 128.55, 76.0),
        } or {
            vector4(2952.4795, 2748.9543, 43.5048, 278.4335),
            vector4(2953.36, 2743.02, 43.5048, 278.4335),
            vector4(2951.60, 2754.88, 43.5048, 278.4335),
        },
        model = "bison",
        toolProp = Config.Tools.miner.default.prop,
        color = { primary = 6, secondary = 0 },
        plate = "MINER",
        useCustomPlate = false,
        fuelOnSpawn = 100.0,
        trunkDoors = { 5 },
        trunkOffset = -3.5, -- distance behind vehicle when picking up / returning tools

        toolPositions = {
            { offset = vector3(-0.78, -2.2, 0.94), rotation = vector3(0.90, -210.0, 90.0) },
            { offset = vector3(-0.78, -1.7, 0.94), rotation = vector3(0.90, -210.0, 90.0) },
            { offset = vector3(0.78, -1.7, 0.97),  rotation = vector3(0.90, -160.0, 90.0) },
            { offset = vector3(0.78, -2.2, 0.97),  rotation = vector3(0.90, -160.0, 90.0) },
        },

        cargoPositions = {
            { offset = vector3(-0.157, -0.947, 0.450), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.244, -0.947, 0.450),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.145, -1.337, 0.450), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.272, -1.377, 0.450),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.540, -1.652, 0.450), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.073, -1.691, 0.450), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.263, -1.731, 0.450),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.543, -1.732, 0.450),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.522, -2.075, 0.450), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.084, -2.031, 0.450), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.366, -2.145, 0.450),  rotation = vector3(0.0, 0.0, 0.0) },

            { offset = vector3(-0.157, -0.947, 0.768), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.244, -0.947, 0.768),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.145, -1.337, 0.768), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.272, -1.377, 0.768),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.540, -1.652, 0.768), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.073, -1.691, 0.768), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.263, -1.731, 0.768),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.543, -1.732, 0.768),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.522, -2.075, 0.768), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.084, -2.031, 0.768), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.366, -2.145, 0.768),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.500, -1.500, 0.768),  rotation = vector3(0.0, 0.0, 0.0) },
        },
    },

    processing = {

        coord = K4MB1Cave
            and vector4(-590.52, 2123.86, 128.55, 76.0)
            or vector4(2686.54, 2768.6, 37.88, 212.9),
        prop = "tw_baskul",
        propOffset = vector3(0.0, 0.0, 0.0),
        propRotation = vector3(0.0, 0.0, 120.0),
        spawnDistance = 50.0,
        interactDistance = 2.5,
        maxDistanceFromScale = 15.0,
        payPerRock = 100,
        kgPerItem = 25,
        maxScaleItems = 20,

        levelPayBonus = 0.02,

        levelChanceBonus = 0.5,

        qualityTiers = {
            { name = "Common",    chance = 55, multiplier = 1.0 },
            { name = "Uncommon",  chance = 25, multiplier = 1.3 },
            { name = "Rare",      chance = 13, multiplier = 1.8 },
            { name = "Legendary", chance = 7,  multiplier = 2.5 },
        },

        npc = {
            model = "s_m_y_construct_01",

            coord = K4MB1Cave
                and vector4(-588.52, 2121.86, 128.55, 76.0)
                or vector4(2689.28, 2768.6, 37.88, 141.58),
            scenario = "WORLD_HUMAN_CLIPBOARD",
            interactDistance = 2.0,
        },

        carrier = {
            npcModel        = "s_m_y_construct_02",
            carryProp       = "prop_rock_4_a",
            maxItemsToCarry = 3,
            walkSpeed       = 1.0,

            spawnCoord      = K4MB1Cave
                and vector4(-593.50, 2119.00, 128.55, 76.0)
                or vector4(2675.78, 2762.11, 37.88, 283.86),
            dropCoord       = K4MB1Cave
                and vector4(-590.52, 2123.86, 128.55, 100.0)
                or vector4(2686.54, 2768.6, 37.88, 100.0),

            carryBone       = 24818,
            carryOffset     = vector3(-0.15, 0.4, 0.01),
            carryRotation   = vector3(0.0, 90.0, 0.0),

            pickupTime      = 2000,
            dropTime        = 1500,
        },
    },

    workClothes = {
        coord = K4MB1Cave
            and vector4(-591.69, 2132.88, 128.08, 76.0)
            or vector4(2942.135, 2748.299, 42.380, 78.459),
    },
}

MinerJob.runtime = runtime

MinerJob.preview = {
    playerPosition = K4MB1Cave and vector3(-594.52, 2127.86, 128.55) or vector3(2944.0, 2743.0, 43.3),
    vehicleStep = 3,
    steps = {

        {
            camCoord = K4MB1Cave and vector3(-592.5, 2129.0, 130.0) or vector3(2944.5, 2746.4, 44.6),
            camTarget = K4MB1Cave and vector3(-594.5, 2127.8, 128.5) or vector3(2943.9, 2741.6, 43.3),
        },

        {
            autoClothes = true,
            camCoord = K4MB1Cave and vector3(-589.5, 2134.0, 130.0) or vector3(2946.6, 2747.3, 44.8),
            camTarget = K4MB1Cave and vector3(-591.7, 2132.9, 128.0) or vector3(2942.1, 2748.3, 42.9),
        },

        {
            autoVehicle = true,
            autoTools = { model = Config.Tools.miner.default.prop },
            camCoord = K4MB1Cave and vector3(-595.0, 2132.0, 130.5) or vector3(2947.4, 2748.2, 45.0),
            camTarget = K4MB1Cave and vector3(-597.2, 2130.5, 128.5) or vector3(2952.2, 2748.9, 44.0),
        },

        {
            lockDuration = 3500,
            camCoord = K4MB1Cave and vector3(-577.0, 1914.0, 122.0) or vector3(2945.0, 2772.5, 40.7),
            camTarget = K4MB1Cave and vector3(-579.1, 1912.2, 120.1) or vector3(2947.9, 2776.0, 38.7),
            entities = {

                { type = "prop", model = runtime.rockSpawns[1].prop, coords = runtime.rockSpawns[1].coord, removeDelay = 3000 },

                { type = "prop", model = runtime.rockSpawns[2].prop, coords = runtime.rockSpawns[2].coord },
                { type = "prop", model = runtime.rockSpawns[3].prop, coords = runtime.rockSpawns[3].coord },

                {
                    type = "ped",
                    model = "s_m_y_construct_02",
                    coords = K4MB1Cave
                        and vector4(-578.0, 1913.0, 120.1, 233.0)
                        or vector4(2946.3, 2775.8, 39.21, 233.0),
                    anim = { dict = runtime.animations.mining.dict, name = runtime.animations.mining.name, flag = 1 },
                    persist = false
                },

                {
                    type = "prop",
                    model = Config.Tools.miner.default.prop,
                    attachTo = 4,
                    attachBone = Config.Tools.miner.default.handAttach.boneId,
                    attachOffset = vector3(Config.Tools.miner.default.handAttach.x,
                        Config.Tools.miner.default.handAttach.y, Config.Tools.miner.default.handAttach.z),
                    attachRotation = vector3(Config.Tools.miner.default.handAttach.rotX,
                        Config.Tools.miner.default.handAttach.rotY, Config.Tools.miner.default.handAttach.rotZ),
                    persist = false
                },

                {
                    type = "prop",
                    model = runtime.orePickup.model,
                    coords = runtime.rockSpawns[1].coord,
                    spawnDelay = 3000,
                    persist = false
                },
            },
        },

        {
            camCoord = K4MB1Cave and vector3(-577.0, 1910.0, 122.0) or vector3(2944.5, 2773.6, 40.7),
            camTarget = K4MB1Cave and vector3(-579.1, 1912.2, 120.1) or vector3(2948.5, 2775.6, 38.6),
            entities = {

                {
                    type = "ped",
                    model = "s_m_y_construct_02",
                    coords = vector4(runtime.rockSpawns[1].coord.x, runtime.rockSpawns[1].coord.y,
                        runtime.rockSpawns[1].coord.z, 180.0),
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
            autoCargo = { count = 4 },
            camCoord = K4MB1Cave and vector3(-595.0, 2132.0, 131.0) or vector3(2946.9, 2747.1, 46.5),
            camTarget = K4MB1Cave and vector3(-597.2, 2130.5, 128.5) or vector3(2951.3, 2748.5, 44.4),
            entities = {

                {
                    type = "ped",
                    model = "s_m_y_construct_02",
                    coords = K4MB1Cave
                        and vector4(-596.0, 2129.0, 128.55, 269.0)
                        or vector4(2949.2, 2749.0, 43.50, 269.0),
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
            scaleDUI = { rockCount = 2, payPerRock = runtime.processing.payPerRock },
            camCoord = K4MB1Cave and vector3(-588.5, 2121.5, 130.0) or vector3(2684.8, 2765.1, 39.2),
            camTarget = K4MB1Cave and vector3(-590.5, 2123.8, 128.5) or vector3(2686.9, 2769.4, 37.7),
            entities = {

                { type = "prop", model = runtime.collectedProp.model, coords = vector4(runtime.processing.coord.x, runtime.processing.coord.y, runtime.processing.coord.z + 2.0, 0.0),               spawnDelay = 2000 },
                { type = "prop", model = runtime.collectedProp.model, coords = vector4(runtime.processing.coord.x - 0.3, runtime.processing.coord.y + 0.26, runtime.processing.coord.z + 2.0, 45.0), spawnDelay = 2000 },
            },
        },
    },
}

MinerJob.clothes = {
    male = {
        tshirt_1 = 59,
        tshirt_2 = 1,
        torso_1 = 38,
        torso_2 = 0,
        arms = 47,
        pants_1 = 130,
        pants_2 = 1,
        shoes_1 = 24,
        shoes_2 = 0,
        chain_1 = 0,
        chain_2 = 0,
        helmet_1 = 145,
        helmet_2 = 1,
    },
    female = {
        tshirt_1 = 36,
        tshirt_2 = 1,
        torso_1 = 75,
        torso_2 = 3,
        decals_1 = 0,
        decals_2 = 0,
        arms = 54,
        pants_1 = 136,
        pants_2 = 1,
        shoes_1 = 24,
        shoes_2 = 0,
        chain_1 = -1,
        chain_2 = 0,
        helmet_1 = 144,
        helmet_2 = 1,
    },
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.startJobFunction)
-- Return true to allow the player to start, false to prevent
MinerJob.startJobFunction = {
    enabled = false, -- true = enable start check for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId)
        return true
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.endJobFunction)
-- lobbyAmount / playerAmount meaning: number of ore rocks processed on the scale
MinerJob.endJobFunction = {
    enabled = false, -- true = enable end function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.resetJobFunction)
-- Called when the job is cancelled (owner/member leaves mid-job, lobby disbanded, etc.)
MinerJob.resetJobFunction = {
    enabled = false, -- true = enable reset function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

return MinerJob
