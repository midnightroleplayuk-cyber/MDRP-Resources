local TruckerJob = {

    id = "trucker",

    icon = "./img/jobs/trucker_icon.svg",
    image = "./img/jobs/trucker_bg.png",
    video = "https://tworst.info/uploads/videos/83a613862e4e5703ff4c80613a88bf56_1775405639.mp4",
    enabled = false, -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0, -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(880.3692, -929.8097, 26.2824, 83.4865),
        model = "s_m_m_gaffer_01",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 477,
            color = 56,
            scale = 0.8,
        },
    },

    xprewards = {
        xpPerHundredMeters = 10,
        jobCompleted = 0,
    },

    payment = {
        mode = "distance", -- "distance" = pay scales with route length | "flat" = fixed pay per delivery (distance ignored)

        -- distance mode
        perHundredMeters = 10, -- base pay per 100 meters traveled

        -- flat mode
        flatAmount = 500, -- fixed pay per delivery when mode = "flat"
        flatXp = 200, -- fixed XP per delivery when mode = "flat"

        illegalMultiplier = 2.0, -- pay multiplier for illegal routes (applies to BOTH modes)
        coopMode = "full", -- "full" = everyone gets full pay | "split" = pay divided by player count
        maxDamageDeduction = 0.5, -- max % of pay deducted for cargo/vehicle damage (0.5 = 50%) (applies to BOTH modes)
    },

    stepRewards = {
        -- Available phases: onDeliver (delivery/ride completed)
        onDeliver = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 10 }, { item = "water_bottle", count = 1, chance = 8 } } },
    },

    missioncompletedItems = {
        giveItemPlayer = false, -- true = give items on job complete | false = no items given
        dropMode = "weightedPool", -- "weightedPool" = pick one item by chance weight | "perItem" = each item rolls independently
        itemList = {
            { item = "sandwich",     count = 1, chance = 50 },
            { item = "water_bottle", count = 1, chance = 30 },
        },
    },

    illegal = {
        enabled = true,
        chance = 20,
        policeAlertChance = 90,
        policeAlertDecreasePerLevel = 1,
        minPoliceAlertChance = 50,
    },

    runtime = {

        vehicle = {
            models = { "packer" },
            plate = "TRUCKER",
            useCustomPlate = false,

            parkingSlots = {
                vector4(854.36, -905.97, 25.44, 269.84),
                vector4(854.5, -899.08, 25.44, 270.32),
                vector4(854.55, -892.29, 25.44, 269.54),
                vector4(854.35, -885.51, 25.44, 270.95),
            },
        },

        finishSync = {
            approvalTimeout = 5,
        },

        trailer = {
            models = { "docktrailer" },
            spawnDistance = 100.0,

            pickupLocations = {
                vector4(1062.2780, -3185.4834, 5.9017, 182.6632),
                vector4(1054.0912, -3185.7749, 5.9018, 182.2451),
                vector4(1046.2861, -3185.7974, 5.9010, 182.9360),
                vector4(1038.1793, -3185.7463, 5.9011, 182.7922),
                vector4(1030.0134, -3185.7703, 5.9011, 182.7078),
                vector4(1021.8876, -3185.8699, 5.9010, 182.6289),
                vector4(1013.6997, -3185.9106, 5.9010, 182.7469),
            },
        },

        deliveryLocations = {
            vector4(827.58, -3211.59, 5.0, 180.0),
            vector4(834.99, -3209.26, 5.0, 0.0),
            vector4(196.14, -1859.15, 26.25, 230.39),
            vector4(-160.32, -1305.03, 30.32, 85.91),
            vector4(-61.95, -1263.4, 28.2, 85.99),
            vector4(-493.56, -58.17, 39.2, 140.86),
            vector4(-1451.78, -366.78, 42.8, 0.0),
            vector4(-911.89, -1287.55, 4.22, 294.06),
            vector4(-592.23, -1585.65, 26.15, 82.55),
            vector4(-66.36, -2225.31, 6.9, 270.83),
        },

        illegalLocations = {
            vector4(1177.29, -3112.79, 5.13, 1.76),
            vector4(-1276.62, -812.56, 16.23, 130.42),
            vector4(-745.26, -1502.36, 4.1, 15.26),
            vector4(-1150.14, -210.77, 37.0, 14.26),
            vector4(-829.38, -1265.37, 4.1, 319.53),
        },

        truckDelivery = {
            interactDistance = 15.0,
            markerType = 1,
            markerScale = vector3(3.0, 3.0, 1.0),
            markerColor = { r = 0, g = 255, b = 0, a = 100 },
        },

        trailerAttach = {
            interactDistance = 8.0,
            detachDistance = 5.0,
        },

        markers = {

            deliveryZone = {
                width           = 4.0,
                length          = 14.0,
                colorFar        = { r = 255, g = 0, b = 0, a = 60 },
                colorClose      = { r = 0, g = 255, b = 0, a = 60 },
                borderFar       = { r = 255, g = 0, b = 0, a = 200 },
                borderClose     = { r = 0, g = 255, b = 0, a = 200 },
                drawDistance    = 50.0,  -- how far the zone marker is visible (navigation aid)
                interactDistance = 10.0, -- how close the TRAILER must be to deliver = zone turns green
                zOffset         = 0.0,
            },

            trailerAttach = {
                type = 20,
                scale = 1.5,
                color = { r = 0, g = 200, b = 255, a = 200 },
                reattachColor = { r = 255, g = 50, b = 50, a = 200 },
                drawDistance = 30.0,
                heightOffset = 4.0,
                bobAmplitude = 0.3,
                bobSpeed = 500.0,
            },
        },

        distanceMultiplier = 1.4,

        workClothes = {
            coord = vector4(877.204, -934.181, 25.299, 177.919),
        },

        blips = {
            trailerPickup = {
                sprite = 479,
                color = 5,
                scale = 0.8,
                label = "Pickup Trailer",
            },
            delivery = {
                sprite = 478,
                color = 2,
                scale = 0.8,
                label = "Deliver Cargo",
            },
            illegalDelivery = {
                sprite = 478,
                color = 1,
                scale = 0.8,
                label = "Illegal Delivery",
            },
            truckReturn = {
                sprite = 477,
                color = 3,
                scale = 0.8,
                label = "Return Truck",
            },
        },
    },

    clothes = {
        male = {
            tshirt_1 = 59,
            tshirt_2 = 0,
            torso_1 = 56,
            torso_2 = 0,
            arms = 32,
            pants_1 = 8,
            pants_2 = 0,
            shoes_1 = 25,
            shoes_2 = 0,
            chain_1 = 0,
            chain_2 = 0,
            helmet_1 = 5,
            helmet_2 = 0,
        },
        female = {
            tshirt_1 = 15,
            tshirt_2 = 0,
            torso_1 = 37,
            torso_2 = 0,
            decals_1 = 0,
            decals_2 = 0,
            arms = 1,
            pants_1 = 36,
            pants_2 = 0,
            shoes_1 = 12,
            shoes_2 = 0,
            chain_1 = -1,
            chain_2 = 0,
            helmet_1 = 46,
            helmet_2 = 0,
        },
    },
}

TruckerJob.preview = {
    playerPosition = vector3(880.0, -930.0, 26.28),
    vehicleStep = 3,
    steps = {
        {
            camCoord = vector3(877.2, -930.1, 27.5),
            camTarget = vector3(882.1, -929.7, 26.4),
        },
        {
            autoClothes = true,
            camCoord = vector3(877.5, -929.9, 27.8),
            camTarget = vector3(877.2, -934.4, 25.7),
        },
        {
            camCoord = vector3(862.5, -906.1, 29.4),
            camTarget = vector3(857.9, -906.0, 27.5),
            entities = {
                { type = "vehicle", model = "packer", coords = vector4(854.36, -905.97, 25.44, 269.84), persist = false },
            },
        },
        {
            camCoord = vector3(1062.7, -3196.4, 10.5),
            camTarget = vector3(1062.5, -3191.7, 8.8),
            entities = {
                { type = "vehicle", model = "packer",      coords = vector4(1055.0, -3185.87, 5.9, 2.0) },
                { type = "vehicle", model = "docktrailer", coords = vector4(1062.28, -3185.48, 5.9, 182.66) },
            },
        },
        {
            camCoord = vector3(217.1, -1872.4, 33.9),
            camTarget = vector3(212.9, -1870.0, 33.0),
            entities = {
                { type = "vehicle", model = "packer",      coords = vector4(208.0, -1867.0, 26.88, 230.39),  attachTrailer = 2 },
                { type = "vehicle", model = "docktrailer", coords = vector4(202.54, -1861.82, 27.69, 230.39) },
                {
                    type = "marker",
                    markerType = 20,
                    coords = vector4(206.13, -1865.2, 29.41, 0.0),
                    scale = vector3(0.5, 0.5, 0.5),
                    color = { r = 0, g = 255, b = 0, a = 200 },
                    bob = true
                },
            },
        },
        {
            camCoord = vector3(861.0, -905.9, 29.1),
            camTarget = vector3(856.5, -906.0, 27.0),
            entities = {
                { type = "vehicle", model = "packer", coords = vector4(854.36, -905.97, 25.44, 269.84) },
                {
                    type = "marker",
                    markerType = 20,
                    coords = vector4(854.36, -905.97, 27.5, 0.0),
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
    -- lobbyAmount / playerAmount meaning: number of trailers delivered
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

return TruckerJob
