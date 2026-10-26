local ForkliftJob = {
    id = "forklift",
    icon = "./img/jobs/forklift_icon.svg",
    image = "./img/jobs/forklift_bg.png",
    video = "https://tworst.info/uploads/videos/08cd184a8365061a6dbafdb7b283bcc8_1775405600.mp4",
    enabled = true, -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0, -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(-733.81, -2466.26, 13.94, 55.6),
        model = "s_m_m_warehouse_01",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 478,
            color = 47,
            scale = 0.8,
        },
    },

    crateTypes = {
        jewellery = { value = 200, xp = 50 },
        antiques  = { value = 150, xp = 40 },
        tobacco   = { value = 120, xp = 30 },
        hazard    = { value = 80, xp = 20 },
        fake      = { value = 50, xp = 10 },
    },

    crateProps = {
        { prop = "yusuf_prop_m52_crate_m_jewellery_01", category = "jewellery" },
        { prop = "yusuf_prop_m52_crate_m_jewellery_02", category = "jewellery" },
        { prop = "yusuf_prop_m52_crate_m_jewellery_03", category = "jewellery" },
        { prop = "yusuf_prop_m52_crate_m_antiques_01",  category = "antiques" },
        { prop = "yusuf_prop_m52_crate_m_antiques_02",  category = "antiques" },
        { prop = "yusuf_prop_m52_crate_m_antiques_03",  category = "antiques" },
        { prop = "yusuf_prop_m52_crate_m_tobacco_01",   category = "tobacco" },
        { prop = "yusuf_prop_m52_crate_m_tobacco_02",   category = "tobacco" },
        { prop = "yusuf_prop_m52_crate_m_tobacco_03",   category = "tobacco" },
        { prop = "yusuf_prop_m52_crate_m_hazard_01",    category = "hazard" },
        { prop = "yusuf_prop_m52_crate_m_hazard_02",    category = "hazard" },
        { prop = "yusuf_prop_m52_crate_m_hazard_03",    category = "hazard" },
        { prop = "yusuf_prop_m52_crate_m_fake_01",      category = "fake" },
        { prop = "yusuf_prop_m52_crate_m_fake_02",      category = "fake" },
        { prop = "yusuf_prop_m52_crate_m_fake_03",      category = "fake" },
    },

    xprewards = {
        jobCompleted = 0,
    },

    payment = {
        mode = "custom", -- "custom" = job-specific payment logic | "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        coopMode = "full", -- "full" = everyone gets full pay | "split" = pay divided by player count
        completionBonus = 0, -- bonus paid once when job is fully completed
        completionOnly = false, -- true = ignore per-crate values and only pay completionBonus | false = pay sum of crateTypes[*].value
    },

    stepRewards = {
        -- Available phases: onProcess (conveyor batch delivered), onPlace (crate placed on shelf)
        onProcess = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 10 } } },
        onPlace   = { enabled = false, dropMode = "perItem", itemList = { { item = "water_bottle", count = 1, chance = 8 } } },
    },

    missioncompletedItems = {
        giveItemPlayer = false, -- true = give items on job complete | false = no items given
        dropMode = "weightedPool", -- "weightedPool" = pick one item by chance weight | "perItem" = each item rolls independently
        itemList = {
            { item = "sandwich",     count = 1, chance = 50 },
            { item = "water_bottle", count = 1, chance = 30 },
        },
    },

    runtime = {

        defaultBucket = 0,

        teleportCoord = vector4(-788.28, -2556.81, -87.51, 333.52),

        returnCoord = vector4(-735.42, -2465.75, 13.94, 55.6),

        forklift = {
            model = "forklift",
            plate = "FORKLFT",
            useCustomPlate = false,
            spawnPoints = {
                vector4(-776.31, -2565.31, -88.06, 334.17),
                vector4(-761.46, -2543.97, -88.06, 54.98),
                vector4(-774.84, -2538.36, -88.06, 147.86),
            },
        },

        crateCount = { min = 6, max = 15 },

        crateSpawns = {
            vector3(-778.2843, -2567.91846, -87.46007),
            vector3(-776.1797, -2568.93335, -88.52148),
            vector3(-761.5729, -2538.88721, -88.52148),
            vector3(-777.627563, -2535.05078, -88.52148),
            vector3(-781.4484, -2554.35229, -88.52845),
            vector3(-780.032532, -2551.9, -87.0401154),
            vector3(-789.547, -2554.993, -87.00725),
            vector3(-774.9908, -2555.05835, -88.50178),
            vector3(-771.7839, -2548.43359, -88.50178),
            vector3(-770.62616, -2546.42822, -88.50178),
            vector3(-774.2556, -2552.71484, -88.50178),
            vector3(-774.551, -2542.4, -88.50178),
            vector3(-780.0345, -2541.066, -88.50178),
            vector3(-771.4135, -2560.03052, -88.51469),
            vector3(-782.4088, -2545.17847, -88.50178),
            vector3(-757.4447, -2541.27075, -88.52148),

            vector3(-771.640, -2548.612, -86.221),
            vector3(-772.900, -2550.671, -86.221),
            vector3(-769.307, -2544.409, -86.221),
            vector3(-782.409, -2545.178, -86.276),
        },

        conveyor = {

            slots = {
                vector4(-774.148, -2531.940, -87.660, -30.0),
                vector4(-772.250, -2533.034, -87.660, -30.0),
                vector4(-770.352, -2534.128, -87.660, -30.0),
            },

            buttonCoord = vector3(-769.51, -2535.58, -87.41),

            exitPoint = vector3(-776.626, -2530.501, -87.660),

            animDuration = 3.0,
        },

        interaction = {
            cratePickupDistance = 1.2,
            beltPlaceDistance = 1.5,
            beltPickupDistance = 1.2,
            shelfPlaceDistance = 1.5,
            buttonDistance = 1.5,
            forkZMaxDiff = 0.30, -- max Z distance between fork bone and crate for pickup/place
        },

        crateAttachOffset = {
            boneId = 4,
            pos = { x = 0.0, y = 0.1, z = -0.2 },
            rot = vector3(0.0, 0.0, 0.0),
        },

        autoClothes = true,

        -- Permanent exit NPC in the underground depot. It exists whether or not a
        -- job is running: while a job is active it cancels the job (leader only,
        -- unchanged); with no job it just teleports the player back up top — the
        -- escape hatch for anyone stuck inside after a server restart.
        exitNpc = {
            coords = vector4(-765.4, -2535.54, -88.52, 157.11),
            model = "s_m_m_warehouse_01",
            scenario = "WORLD_HUMAN_CLIPBOARD",
            interactionDistance = 2.0,
            -- Ground-level spot the no-job exit teleports to (next to the start NPC).
            teleportOut = vector4(-734.9911, -2467.1655, 13.9403, 57.3123),
        },

        blips = {
            forklift = {
                sprite = 67,
                color = 47,
                scale = 0.7,
                label = "Forklift",
            },
            conveyor = {
                sprite = 478,
                color = 2,
                scale = 0.8,
                label = "Conveyor Belt",
            },
        },
    },

    clothes = {
        male = {
            tshirt_1 = 15,
            tshirt_2 = 0,
            torso_1 = 56,
            torso_2 = 0,
            arms = 63,
            pants_1 = 36,
            pants_2 = 0,
            shoes_1 = 25,
            shoes_2 = 0,
            chain_1 = 0,
            chain_2 = 0,
            helmet_1 = -1,
            helmet_2 = 0,
        },
        female = {
            tshirt_1 = 15,
            tshirt_2 = 0,
            torso_1 = 161,
            torso_2 = 0,
            decals_1 = 0,
            decals_2 = 0,
            arms = 0,
            pants_1 = 69,
            pants_2 = 0,
            shoes_1 = 27,
            shoes_2 = 7,
            chain_1 = -1,
            chain_2 = 0,
            helmet_1 = -1,
            helmet_2 = 0,
        },
    },
}

local rt = ForkliftJob.runtime

ForkliftJob.preview = {
    playerPosition = vector3(-788.28, -2556.81, -87.51),
    steps = {
        {
            camCoord = vector3(-735.9, -2465.3, 15.0),
            camTarget = vector3(-731.5, -2467.3, 13.9),
        },
        {
            camCoord = vector3(-774.2, -2560.3, -85.2),
            camTarget = vector3(-776.0, -2564.5, -87.2),
            entities = {
                { type = "vehicle", model = rt.forklift.model, coords = vector4(-776.31, -2565.31, -88.06, 334.17) },
            },
        },
        {
            camCoord = vector3(-781.9, -2557.9, -86.1),
            camTarget = vector3(-780.5, -2553.5, -88.2),
            entities = {
                { type = "prop", model = ForkliftJob.crateProps[1].prop, coords = vector4(-781.45, -2554.35, -88.53, 0.0), rawZ = true },
                { type = "prop", model = ForkliftJob.crateProps[7].prop, coords = vector4(-780.03, -2551.9, -88.53, 30.0), rawZ = true },
            },
        },
        {
            camCoord = vector3(-771.8, -2539.8, -85.0),
            camTarget = vector3(-773.2, -2535.1, -86.3),
            entities = {
                { type = "prop", model = ForkliftJob.crateProps[1].prop, coords = vector4(rt.conveyor.slots[1].x, rt.conveyor.slots[1].y, rt.conveyor.slots[1].z, rt.conveyor.slots[1].w), rawZ = true },
                { type = "prop", model = ForkliftJob.crateProps[7].prop, coords = vector4(rt.conveyor.slots[2].x, rt.conveyor.slots[2].y, rt.conveyor.slots[2].z, rt.conveyor.slots[2].w), rawZ = true },
            },
        },
    },
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.startJobFunction)
-- Return true to allow the player to start, false to prevent
ForkliftJob.startJobFunction = {
    enabled = false, -- true = enable start check for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId)
        return true
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.endJobFunction)
-- lobbyAmount / playerAmount meaning: number of crates placed on belt/shelf
ForkliftJob.endJobFunction = {
    enabled = false, -- true = enable end function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.resetJobFunction)
-- Called when the job is cancelled (owner/member leaves mid-job, lobby disbanded, etc.)
ForkliftJob.resetJobFunction = {
    enabled = false, -- true = enable reset function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

--[[ OLD preview = {
        {
            title = "Start the Job",
            description = {
                "Walk up to the warehouse NPC outside",
                "Press E to open the job menu and start",
                "You will be teleported to the underground depot",
            },
            camCoord = vector3(-730.51, -2463.53, 15.44),
            camTarget = vector3(-733.81, -2466.26, 14.44),
        },
        {
            title = "Enter the Depot",
            description = {
                "You are teleported to an underground depot",
                "Find your assigned forklift nearby",
                "Crates are scattered around the warehouse",
            },
            camCoord = vector3(-770.0, -2560.0, -85.5),
            camTarget = vector3(-775.0, -2555.0, -87.5),
            entities = {
                -- Forklift
                { type = "vehicle", model = rt.forklift.model, coords = vector4(-776.31, -2565.31, -88.06, 334.17), persist = true },
                -- Scattered crates around depot
                { type = "prop", model = ForkliftJob.crateProps[1].prop, coords = vector4(-781.45, -2554.35, -88.53, 10.0), rawZ = true, persist = true },
                { type = "prop", model = ForkliftJob.crateProps[4].prop, coords = vector4(-780.03, -2551.9, -88.53, 45.0), rawZ = true, persist = true },
                { type = "prop", model = ForkliftJob.crateProps[7].prop, coords = vector4(-774.99, -2555.06, -88.50, 80.0), rawZ = true, persist = true },
                { type = "prop", model = ForkliftJob.crateProps[10].prop, coords = vector4(-771.78, -2548.43, -88.50, 25.0), rawZ = true, persist = true },
                { type = "prop", model = ForkliftJob.crateProps[13].prop, coords = vector4(-789.55, -2554.99, -87.01, 55.0), rawZ = true, persist = true },
                { type = "prop", model = ForkliftJob.crateProps[2].prop, coords = vector4(-774.55, -2542.4, -88.50, 130.0), rawZ = true, persist = true },
                -- Warehouse workers
                {
                    type = "ped", model = "s_m_m_warehouse_01",
                    coords = vector4(-778.0, -2553.0, -88.53, 200.0),
                    scenario = "WORLD_HUMAN_CLIPBOARD",
                    rawZ = true, persist = true
                },
                {
                    type = "ped", model = "s_m_m_warehouse_01",
                    coords = vector4(-772.0, -2546.0, -88.50, 90.0),
                    anim = { dict = "anim@heists@box_carry@", name = "idle", flag = 49 },
                    rawZ = true, persist = true
                },
            },
        },
        {
            title = "Pick Up a Crate",
            description = {
                "Drive the forklift to a crate",
                "Lower the forks and align them under the crate",
                "Raise the forks to lift it — be careful!",
            },
            lockDuration = 3000,
            camCoord = vector3(-783.0, -2556.0, -86.0),
            camTarget = vector3(-780.0, -2552.5, -87.5),
        },
        {
            title = "Deliver to Conveyor",
            description = {
                "Drive the loaded forklift to the conveyor belt",
                "Align the crate over a free slot",
                "Lower the forks to place it — slots light up when ready",
            },
            lockDuration = 3000,
            camCoord = vector3(-768.0, -2530.0, -86.0),
            camTarget = vector3(-772.0, -2533.0, -87.5),
            entities = {
                -- Forklift arriving with crate
                { type = "vehicle", model = rt.forklift.model, coords = vector4(-770.0, -2536.0, -88.06, 330.0) },
                -- Crates already on belt
                { type = "prop", model = ForkliftJob.crateProps[1].prop, coords = vector4(rt.conveyor.slots[1].x, rt.conveyor.slots[1].y, rt.conveyor.slots[1].z, rt.conveyor.slots[1].w), rawZ = true },
                { type = "prop", model = ForkliftJob.crateProps[7].prop, coords = vector4(rt.conveyor.slots[2].x, rt.conveyor.slots[2].y, rt.conveyor.slots[2].z, rt.conveyor.slots[2].w), rawZ = true },
                -- Button marker
                { type = "marker", markerType = 20, coords = vector4(rt.conveyor.buttonCoord.x, rt.conveyor.buttonCoord.y, rt.conveyor.buttonCoord.z + 1.0, 0.0),
                  scale = vector3(0.3, 0.3, 0.3), color = { r = 0, g = 200, b = 0, a = 200 }, bob = true },
            },
        },
        {
            title = "Finish and Collect Pay",
            description = {
                "Once all crates are sorted, talk to the NPC",
                "Different crate types have different values",
                "You will be teleported back outside",
            },
            camCoord = vector3(-762.5, -2538.0, -87.0),
            camTarget = vector3(-765.4, -2535.54, -88.02),
            entities = {
                { type = "ped", model = rt.exitNpc.model,
                  coords = vector4(rt.exitNpc.coords.x, rt.exitNpc.coords.y, rt.exitNpc.coords.z, rt.exitNpc.coords.w),
                  scenario = rt.exitNpc.scenario, rawZ = true },
                -- Crates near exit
                { type = "prop", model = ForkliftJob.crateProps[3].prop, coords = vector4(-763.0, -2537.0, -88.52, 45.0), rawZ = true },
                { type = "prop", model = ForkliftJob.crateProps[9].prop, coords = vector4(-764.0, -2538.5, -88.52, 120.0), rawZ = true },
            },
        },
    },
} ]]

return ForkliftJob
