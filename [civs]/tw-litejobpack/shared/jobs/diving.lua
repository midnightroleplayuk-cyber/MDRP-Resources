local DivingJob = {

    id = "diving",

    icon = "./img/jobs/diving_icon.svg",
    image = "./img/jobs/diving_bg.png",
    video = "https://tworst.info/uploads/videos/c82e13ef12bbc94276044b7cb1cdf748_1775405589.mp4",
    enabled = true, -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0, -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    sellMode = "auto",

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(-274.35, 6641.55, 7.41, 217.98),
        model = "s_m_y_baywatch_01",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 729,
            color = 3,
            scale = 0.8,
        },
    },

    xprewards = {
        taskCompleted = 25,
        itemSold = 50,
        jobCompleted = 500,
    },

    payment = {
        mode = "custom", -- "custom" = job-specific payment logic | "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        sellBonus = 0, -- one-time bonus added per sell action (not per item)
        completionBonus = 0, -- bonus paid once when job is fully completed
        coopMode = "full", -- "full" = everyone gets full pay | "split" = pay divided by player count
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

        anchor = {
            speedThreshold = 5.0,
        },

        sellConfig = {
            buyerNpc = {
                model = "s_m_m_cntrybar_01",
                coord = vector4(-279.59, 6636.75, 7.55, 270.0),
                scenario = "WORLD_HUMAN_CLIPBOARD",
                interactDistance = 2.0,
                blip = {
                    sprite = 500,
                    color = 2,
                    scale = 0.7,
                },
            },
        },

        sellItems = {
            dendrogyra_coral   = { label = "Dendrogyra Coral", price = 1500 },
            antipatharia_coral = { label = "Antipatharia Coral", price = 1500 },
        },

        taskTypes = {
            coral = {
                label = "Coral",
                props = { "prop_coral_pillar_01" },
                propSwap = "prop_coral_01",
                animation = {
                    dict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
                    name = "plant_floor",
                    duration = 2200,
                },
                lootTable = {
                    { item = "dendrogyra_coral",   weight = 70 },
                    { item = "antipatharia_coral", weight = 20 },

                },
                drawText = "drawText.collectCoral",
            },
            trash = {
                label = "Trash",
                props = {
                    "prop_rub_binbag_04",
                    "prop_rub_tyre_01",
                },
                animation = {
                    dict = "amb@world_human_gardener_plant@female@base",
                    name = "base_female",
                    duration = 3000,
                },
                lootTable = {},
                drawText = "drawText.cleanTrash",
            },
        },

        zones = {
            [1] = {
                id = "shallow_bay",
                name = "Shallow Bay",
                coord = vector3(-929.52, 6666.6, -27.55),
                areaDistance = 35.0,
                requiredLevel = 0,
                tasks = {
                    { type = "coral", count = 5 },
                    { type = "trash", count = 5 },
                },
                vehicleSpawns = {
                    vector4(-306.97, 6678.08, 0.62, 33.31),
                    vector4(-293.50, 6668.30, 0.50, 150.0),
                    vector4(-318.20, 6688.50, 0.55, 20.0),
                },
                deliveryPoint = {
                    coords = vector3(-306.97, 6678.08, 1.0),
                    radius = 15.0,
                    teleportTo = vector4(-273.87, 6641.97, 7.39, 87.43),
                    blip = { sprite = 38, color = 2, scale = 0.8, label = "Boat Delivery" },
                },
                blip = { sprite = 729, color = 3, label = "Shallow Bay" },
            },
            [2] = {
                id = "open_sea",
                name = "Open Sea",
                coord = vector3(1798.72, -2966.86, -43.23),
                areaDistance = 30.0,
                requiredLevel = 3,
                tasks = {
                    { type = "coral", count = 5 },
                    { type = "trash", count = 5 },
                },
                vehicleSpawns = {
                    vector4(1319.17, -3078.18, 0.37, 0.0),
                },
                deliveryPoint = {
                    coords = vector3(1320.3, -3071.16, -0.05),
                    radius = 15.0,
                    teleportTo = vector4(-273.87, 6641.97, 7.39, 87.43),
                    blip = { sprite = 38, color = 2, scale = 0.8, label = "Boat Delivery" },
                },
                blip = { sprite = 729, color = 1, label = "Open Sea" },
            },
            [3] = {
                id = "shipwreck",
                name = "Shipwreck",
                coord = vector3(4204.08, 3637.51, -43.38),
                areaDistance = 60.0,
                requiredLevel = 5,
                tasks = {
                    { type = "coral", count = 8 },
                    { type = "trash", count = 8 },
                },
                vehicleSpawns = {
                    vector4(3902.53, 4484.97, 0.19, 0.0),
                },
                deliveryPoint = {
                    coords = vector3(3902.53, 4484.97, 0.19),
                    radius = 15.0,
                    teleportTo = vector4(-273.87, 6641.97, 7.39, 87.43),
                    blip = { sprite = 38, color = 2, scale = 0.8, label = "Boat Delivery" },
                },
                blip = { sprite = 729, color = 5, label = "Shipwreck" },
            },
            [4] = {
                id = "deep_trench",
                name = "Deep Trench",
                coord = vector3(3323.94, 6580.64, -65.03),
                areaDistance = 70.0,
                requiredLevel = 7,
                tasks = {
                    { type = "coral", count = 10 },
                    { type = "trash", count = 10 },
                },
                vehicleSpawns = {
                    vector4(1540.32, 6712.64, 0.45, 0.0),
                },
                deliveryPoint = {
                    coords = vector3(1540.32, 6712.64, 0.45),
                    radius = 15.0,
                    teleportTo = vector4(-273.87, 6641.97, 7.39, 87.43),
                    blip = { sprite = 38, color = 2, scale = 0.8, label = "Boat Delivery" },
                },
                blip = { sprite = 729, color = 27, label = "Deep Trench" },
            },
        },

        areas = {
            { id = "shallow_bay", name = "Shallow Bay", type = "diving", requiredLevel = 0, coord = vector3(-929.52, 6666.6, -27.55) },
            { id = "open_sea",    name = "Open Sea",    type = "diving", requiredLevel = 3, coord = vector3(1798.72, -2966.86, -43.23) },
            { id = "shipwreck",   name = "Shipwreck",   type = "diving", requiredLevel = 5, coord = vector3(4204.08, 3637.51, -43.38) },
            { id = "deep_trench", name = "Deep Trench", type = "diving", requiredLevel = 7, coord = vector3(3323.94, 6580.64, -65.03) },
        },

        gear = {
            [1] = {
                label = "Basic Scuba",
                oxygenMax = 150.0,
                tankProp = "xm_prop_x17_scuba_tank",
                requiredLevel = 0,
            },
            [2] = {
                label = "Standard Scuba",
                oxygenMax = 200.0,
                tankProp = "p_michael_scuba_tank_s",
                requiredLevel = 3,
            },
            [3] = {
                label = "Pro Scuba",
                oxygenMax = 260.0,
                tankProp = "p_s_scuba_tank_s",
                requiredLevel = 7,
            },
        },

        scubaClothes = {
            male = {
                jacket = { component = 11, drawable = 243, texture = 0 },
                shirt  = { component = 8, drawable = 15, texture = 0 },
                arms   = { component = 3, drawable = 17, texture = 0 },
                legs   = { component = 4, drawable = 94, texture = 0 },
                shoes  = { component = 6, drawable = 67, texture = 0 },
            },

            female = {
                jacket = { component = 11, drawable = 251, texture = 0 },
                shirt  = { component = 8, drawable = 15, texture = 0 },
                arms   = { component = 3, drawable = 18, texture = 0 },
                legs   = { component = 4, drawable = 101, texture = 0 },
                shoes  = { component = 6, drawable = 70, texture = 0 },
            },
        },

        tankAttachment = {
            male = {
                bone = 24818,
                offset = vector3(-0.25, -0.25, 0.0),
                rotation = vector3(180.0, 90.0, 0.0),
            },
            female = {
                bone = 24818,
                offset = vector3(-0.20, -0.22, 0.0),
                rotation = vector3(180.0, 90.0, 0.0),
            },
        },

        maskAttachment = {
            bone = 12844,
            prop = "p_d_scuba_mask_s",
            offset = vector3(0.0, 0.0, 0.0),
            rotation = vector3(180.0, 90.0, 0.0),
        },

        oxygen = {
            drainRate = 1.5,
            surfaceRefillTime = 12.0, -- seconds for an empty tank to fully refill at the surface (was 5.0)
            warningThreshold = 0.25,
            criticalThreshold = 0.10,
            damagePerSecond = 10,
        },

        vehicle = {
            model = "dinghy",
            plate = "DIVING",
            useCustomPlate = false,
            trunkDoors = {},
        },

        interaction = {
            collectDistance = 2.5,
            sellDistance = 2.0,
            cooldown = 2000,
        },
    },

    clothes = {
        male = {
            tshirt_1 = 15, -- shirt (component 8)
            tshirt_2 = 0,
            torso_1 = 243, -- jacket (component 11)
            torso_2 = 0,
            arms = 17,     -- arms (component 3)
            pants_1 = 94,  -- legs (component 4)
            pants_2 = 0,
            shoes_1 = 67,  -- shoes (component 6)
            shoes_2 = 0,
            chain_1 = 0,
            chain_2 = 0,
            helmet_1 = -1,
            helmet_2 = 0,
        },

        female = {
            tshirt_1 = 15, -- shirt
            tshirt_2 = 0,
            torso_1 = 251, -- jacket
            torso_2 = 0,
            decals_1 = 0,
            decals_2 = 0,
            arms = 18,     -- arms
            pants_1 = 101, -- legs
            pants_2 = 0,
            shoes_1 = 70,  -- shoes
            shoes_2 = 0,
            chain_1 = -1,
            chain_2 = 0,
            helmet_1 = -1,
            helmet_2 = 0,
        },
    },
}

local runtime = DivingJob.runtime

DivingJob.preview = {
    playerPosition = vector3(-273.87, 6641.97, 7.39),
    steps = {

        {
            camCoord = vector3(-272.6, 6639.8, 8.5),
            camTarget = vector3(-276.0, 6643.2, 7.3),
        },

        {
            camCoord = vector3(-290.5, 6672.9, 3.3),
            camTarget = vector3(-292.7, 6668.7, 1.9),
            entities = {

                {
                    type = "vehicle",
                    model = "dinghy",
                    coords = vector4(-293.50, 6668.30, 0.50, 150.0),
                    color = { primary = 111, secondary = 111 },
                    persist = false,
                },
            },
        },

        {
            camCoord = vector3(-302.1, 6672.5, 4.1),
            camTarget = vector3(-304.9, 6676.6, 3.2),
            entities = {

                {
                    type = "vehicle",
                    model = "dinghy",
                    coords = vector4(-306.97, 6678.08, 0.62, 33.31),
                    color = { primary = 111, secondary = 111 },
                },

                {
                    type = "marker",
                    markerType = 20,
                    coords = vector4(-306.97, 6678.08, 4.0, 0.0),
                    scale = vector3(0.5, 0.5, 0.5),
                    color = { r = 0, g = 200, b = 255, a = 200 },
                    bob = true,
                    rotate = true,
                },
            },
        },

        {
            lockDuration = 3000,
            camCoord = vector3(-927.0, 6669.0, -25.0),
            camTarget = vector3(-929.52, 6666.6, -27.0),
            entities = {
                { type = "prop", model = "prop_coral_pillar_01", coords = vector4(-930.0, 6667.0, -27.55, 0.0),   rawZ = true },
                { type = "prop", model = "prop_coral_pillar_01", coords = vector4(-928.5, 6665.5, -27.55, 60.0),  rawZ = true },
                { type = "prop", model = "prop_coral_pillar_01", coords = vector4(-931.5, 6665.0, -27.55, 120.0), rawZ = true },
                { type = "prop", model = "prop_rub_binbag_04",   coords = vector4(-929.0, 6668.0, -27.55, 45.0),  rawZ = true },
                { type = "prop", model = "prop_rub_tyre_01",     coords = vector4(-932.0, 6667.5, -27.55, 90.0),  rawZ = true },
                {
                    type = "ped",
                    model = "s_m_y_baywatch_01",
                    coords = vector4(-929.5, 6666.5, -27.55, 180.0),
                    anim = { dict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", name = "plant_floor", flag = 1 },
                    rawZ = true,
                },
            },
        },

        {
            camCoord = vector3(-277.4, 6634.5, 9.1),
            camTarget = vector3(-280.7, 6637.7, 6.9),
            entities = {

                {
                    type = "ped",
                    model = "s_m_m_cntrybar_01",
                    coords = vector4(-279.59, 6636.75, 7.55, 270.0),
                    scenario = "WORLD_HUMAN_CLIPBOARD",
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
    endJobFunction = {
        enabled = false, -- true = enable end function for THIS job only | false = use global
        func = function(source, ownerIdentifier, jobId)
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

return DivingJob
