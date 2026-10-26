local DogwalkingJob = {

    id = "dogwalking",

    icon = "./img/jobs/dogwalking_icon.svg",
    image = "./img/jobs/dogwalking_bg.png",
    video = "https://tworst.info/uploads/videos/c59fbed5013849a06ba48d705784cdb8_1775405591.mp4",
    enabled = true,    -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0,      -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(-527.43, -679.73, 33.67, 51.13),
        model = "a_f_y_hipster_01",
        scenario = "WORLD_HUMAN_STAND_MOBILE",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 273,
            color = 2,
            scale = 0.8,
        },
    },

    xprewards = {
        xpPerHundredMeters = 15,
        poopCleanXP = 10,
        jobCompleted = 100,
    },

    payment = {
        mode = "distance",     -- "distance" = pay based on distance traveled | "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        perHundredMeters = 10, -- base pay per 100 meters traveled
        poopCleanBonus = 5,
        poopPenalty = 5,
        completionBonus = 0, -- bonus paid once when job is fully completed
        coopMode = "full",   -- "full" = everyone gets full pay | "split" = pay divided by player count
    },

    stepRewards = {
        -- Available phases: onDeliver (delivery/ride completed)
        onDeliver = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 10 }, { item = "water_bottle", count = 1, chance = 8 } } },
    },

    missioncompletedItems = {
        giveItemPlayer = false,    -- true = give items on job complete | false = no items given
        dropMode = "weightedPool", -- "weightedPool" = pick one item by chance weight | "perItem" = each item rolls independently
        itemList = {
            { item = "sandwich",     count = 1, chance = 50 },
            { item = "water_bottle", count = 1, chance = 30 },
        },
    },

    poop = {
        enabled = true,
        intervalMin = 60,
        intervalMax = 180,
        cleanupTime = 60,
        propModelSmall = "prop_big_shit_01",
        propModelBig = "prop_big_shit_02",
        interactDistance = 1.5,

        animation = {
            dict = "pickup_object",
            name = "pickup_low",
            duration = 2000,
        },

        dogAnimation = {
            dict = "creatures@rottweiler@amb@world_dog_sitting@base",
            name = "base",
            duration = 4000,
        },
    },

    leash = {
        enabled = true,
        length = 3.0,
        ropeType = 4,
    },

    restrictions = {
        allowSprint = false,
        allowJump = false,
        allowVehicle = false,
    },

    dogs = {

        models = {
            "a_c_husky",
            "a_c_rottweiler",
            "a_c_shepherd",
            "a_c_retriever",
            "a_c_poodle",
            "a_c_pug",
        },

        teleportDistance = 50.0,

        walkSpeed = 2.0,
    },

    runtime = {

        distanceRange = {
            min = 70,
            max = 150,
        },

        homeLocations = {
            { pos = vector3(-1043.85, 500.49, 83.14),  heading = 214.55 },
            { pos = vector3(-1839.35, 314.56, 89.92),  heading = 104.42 },
            { pos = vector3(-1808.25, 333.67, 88.38),  heading = 19.33 },
            { pos = vector3(-1733.52, 379.96, 88.72),  heading = 26.92 },
            { pos = vector3(-1676.23, 390.98, 88.05),  heading = 356.72 },
            { pos = vector3(-182.89, 969.8, 231.13),   heading = 60.01 },
            { pos = vector3(-159.09, 921.6, 234.66),   heading = 262.07 },
            { pos = vector3(-95.58, 834.67, 234.72),   heading = 58.92 },
            { pos = vector3(-1977.51, -532.78, 10.78), heading = 154.94 },
            { pos = vector3(1201.02, -584.03, 67.82),  heading = 108.63 },
            { pos = vector3(1205.18, -605.82, 66.69),  heading = 77.06 },
            { pos = vector3(-52.29, -1785.3, 26.83),   heading = 144.22 },
            { pos = vector3(-40.64, -1796.49, 26.32),  heading = 126.8 },
            { pos = vector3(165.51, -1633.28, 28.29),  heading = 38.78 },
        },

        ownerModels = {
            "a_f_y_bevhills_01",
            "a_f_y_bevhills_02",
            "a_f_y_bevhills_03",
            "a_f_y_bevhills_04",
            "a_m_y_bevhills_01",
            "a_m_y_bevhills_02",
            "a_f_m_bevhills_01",
            "a_f_m_bevhills_02",
            "a_m_m_bevhills_01",
            "a_m_m_bevhills_02",
        },

        ownerScenario = "WORLD_HUMAN_STAND_IMPATIENT",

        dogSpawnOffsets = {
            vector3(0.8, 0.8, 0.0),
            vector3(-0.8, 0.8, 0.0),
            vector3(0.0, 1.5, 0.0),
        },

        blips = {
            home = {
                sprite = 411,
                color = 5,
                scale = 0.8,
                label = "Client Home",
            },
        },

        spawnDistance = 100.0,

        pickupDistance = 3.0,
        deliverDistance = 3.0,

        bicycle = {
            enabled = false,
            model = "cruiser",
            spawn = vector4(-1373.0, -476.0, 32.31, 120.0),
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
    -- lobbyAmount / playerAmount meaning: number of dogs returned home
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

--[[ DogwalkingJob.preview = {
    playerPosition = vector3(-527.0, -680.0, 33.67),
    steps = {

        {
            title = "Start the Job",
            description = {
                "Find the Dog Walking NPC near the pet shop",
                "Press E to open the job menu",
                "Select your area and press Start",
            },
            camCoord = vector3(-529.0, -678.0, 34.8),
            camTarget = vector3(-525.8, -681.6, 33.6),
        },

        {
            title = "Pick Up the Dog",
            description = {
                "Drive to the client's home",
                "Meet the dog owner waiting outside",
                "Press E to take the dog on a leash",
            },
            camCoord = vector3(-52.8, -1786.8, 29.1),
            camTarget = vector3(-51.7, -1783.7, 25.4),
            entities = {
                {
                    type = "ped",
                    model = "a_f_y_bevhills_02",
                    coords = vector4(-52.29, -1785.3, 26.83, 144.22),
                    scenario = "WORLD_HUMAN_STAND_IMPATIENT",
                },
                {
                    type = "ped",
                    model = "a_c_husky",
                    coords = vector4(-51.49, -1785.3, 26.83, 144.22),
                    anim = { dict = "creatures@rottweiler@amb@world_dog_sitting@base", name = "base", flag = 1 },
                },
                {
                    type = "ped",
                    model = "a_c_poodle",
                    coords = vector4(-53.09, -1786.1, 26.83, 144.22),
                    anim = { dict = "creatures@rottweiler@amb@world_dog_sitting@base", name = "base", flag = 1 },
                },
            },
        },

        {
            title = "Walk the Dog",
            description = {
                "Walk with your dog on a leash",
                "Cover the required distance shown on your HUD",
                "Clean up after your dog for bonus pay",
            },
            camCoord = vector3(-45.0, -1798.0, 28.5),
            camTarget = vector3(-42.0, -1795.0, 27.0),
            entities = {
                {
                    type = "ped",
                    model = "a_m_y_bevhills_01",
                    coords = vector4(-42.0, -1795.0, 26.32, 320.0),
                    anim = { dict = "move_m@casual@a", name = "walk", flag = 1 },
                },
                {
                    type = "ped",
                    model = "a_c_husky",
                    coords = vector4(-41.5, -1796.0, 26.32, 320.0),
                    walkTo = vector3(-39.0, -1793.0, 26.32),
                    walkSpeed = 1.0,
                },
                {
                    type = "prop",
                    model = "prop_big_shit_01",
                    coords = vector4(-44.0, -1797.0, 26.32, 0.0),
                },
                {
                    type = "marker",
                    markerType = 20,
                    coords = vector4(-44.0, -1797.0, 27.8, 0.0),
                    scale = vector3(0.3, 0.3, 0.3),
                    color = { r = 200, g = 150, b = 50, a = 200 },
                    bob = true,
                },
            },
        },

        {
            title = "Return the Dog",
            description = {
                "Walk the dog back to the client's home",
                "The dog returns to its owner automatically",
                "Get paid based on distance walked and cleanups",
            },
            camCoord = vector3(-49.5, -1788.0, 28.3),
            camTarget = vector3(-52.29, -1785.3, 27.33),
            entities = {
                {
                    type = "ped",
                    model = "a_f_y_bevhills_02",
                    coords = vector4(-52.29, -1785.3, 26.83, 144.22),
                    scenario = "WORLD_HUMAN_STAND_IMPATIENT",
                },
                {
                    type = "ped",
                    model = "a_c_husky",
                    coords = vector4(-51.49, -1785.3, 26.83, 144.22),
                    anim = { dict = "creatures@rottweiler@amb@world_dog_sitting@base", name = "base", flag = 1 },
                },
                {
                    type = "ped",
                    model = "a_m_y_bevhills_01",
                    coords = vector4(-54.0, -1783.5, 26.83, 0.0),
                    faceCoord = vector3(-52.29, -1785.3, 26.83),
                },
            },
        },
    },
} ]]

return DogwalkingJob
