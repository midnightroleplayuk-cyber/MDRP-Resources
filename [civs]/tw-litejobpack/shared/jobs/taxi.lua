local TaxiJob = {

    id = "taxi",

    icon = "./img/jobs/taxi_icon.svg",
    image = "./img/jobs/taxi_bg.png",
    video = "https://tworst.info/uploads/videos/420490b734ec685c52c2bd9e3a95d770_1784463029.mp4",
    enabled = true, -- true = job active | false = job disabled
    soloOnly = true, -- true = single-player only: hides the invite/multiplayer option (taxi runs per-player)
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0, -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(895.31, -178.47, 74.69, 232.0),
        model = "cs_manuel",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 198,
            color = 5,
            scale = 0.8,
        },
    },

    xprewards = {
        xpPerHundredMeters = 50,
        jobCompleted = 50,
    },

    payment = {
        mode = "distance", -- "distance" = pay based on distance traveled | "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        perHundredMeters = 8, -- base pay per 100 meters traveled
        levelGrowthFactor = 1.02,
        bonusMultiplier = 1.2,
        coopMode = "full", -- "full" = everyone gets full pay | "split" = pay divided by player count
        coopBonus = 1.0, -- multiplier for coop play (1.0 = no bonus, 1.2 = 20% bonus)
    },

    missioncompletedItems = {
        giveItemPlayer = false, -- true = give items on job complete | false = no items given
        dropMode = "weightedPool", -- "weightedPool" = pick one item by chance weight | "perItem" = each item rolls independently
        itemList = {
            { item = "sandwich",     count = 1, chance = 50 },
            { item = "water_bottle", count = 1, chance = 30 },
        },
    },

    bonus = {
        secondsPerMeter = 0.08,
        crashPenalty = 15,
        enabled = true,
    },

    passenger = {
        sleepChance = 10,
        despawnDelay = 30000, -- ms the dropped-off passenger walks around before despawning
        -- Seat the fare rides in. GTA seat indices: -1 driver | 0 front passenger
        -- | 1 rear LEFT | 2 rear RIGHT. Los Santos drives on the right, so the
        -- kerb is on the right — 2 puts the passenger in at the kerb-side door.
        seatIndex = 2,
        -- How far from the pickup point the fare spawns (metres). Kept under
        -- ~150 so the ground/collision at the pickup is already streamed in
        -- (a ped spawned farther out can drop through unloaded terrain).
        spawnDistance = 150.0,
        models = {

            "a_m_m_afriamer_01", "a_m_m_beach_01", "a_m_m_bevhills_01", "a_m_m_bevhills_02",
            "a_m_m_business_01", "a_m_m_eastsa_01", "a_m_m_farmer_01", "a_m_m_fatlatin_01",
            "a_m_m_genfat_01", "a_m_m_golfer_01", "a_m_m_hasjew_01", "a_m_m_hillbilly_01",
            "a_m_m_indian_01", "a_m_m_ktown_01", "a_m_m_malibu_01", "a_m_m_mexcntry_01",
            "a_m_m_mexlabor_01", "a_m_m_og_boss_01", "a_m_m_paparazzi_01", "a_m_m_polynesian_01",
            "a_m_m_prolhost_01", "a_m_m_rurmeth_01", "a_m_m_salton_01", "a_m_m_skater_01",
            "a_m_m_socenlat_01", "a_m_m_soucent_01", "a_m_m_stlat_02", "a_m_m_tennis_01",
            "a_m_m_tourist_01", "a_m_m_tramp_01", "a_m_m_trampbeac_01", "a_m_m_tranvest_01",

            "a_f_m_beach_01", "a_f_m_bevhills_01", "a_f_m_bevhills_02", "a_f_m_bodybuild_01",
            "a_f_m_business_02", "a_f_m_downtown_01", "a_f_m_eastsa_01", "a_f_m_eastsa_02",
            "a_f_m_fatbla_01", "a_f_m_fatcult_01", "a_f_m_fatwhite_01", "a_f_m_ktown_01",
            "a_f_m_ktown_02", "a_f_m_prolhost_01", "a_f_m_salton_01", "a_f_m_skidrow_01",
            "a_f_m_soucent_01", "a_f_m_soucent_02", "a_f_m_soucentmc_01", "a_f_m_tourist_01",
            "a_f_m_tramp_01", "a_f_m_trampbeac_01",
        },
    },

    runtime = {

        vehicle = {
            models = { "taxi" },
            plate = "TAXI",
            useCustomPlate = false,

            -- These spawn slots sit closer together than the default 7.0 clear
            -- radius (VehicleManager), which made one parked vehicle block every
            -- neighbouring slot and capped the job at one lobby at a time.
            -- Must stay BELOW the smallest slot-to-slot gap.
            spawnClearRadius = 3.0,
            spawnLocations = {
                vector4(898.92, -180.4, 73.82, 238.54),
                vector4(897.4, -183.6, 73.76, 239.29),
                vector4(905.68, -189.32, 73.81, 56.6),
                vector4(907.39, -186.44, 74.03, 62.95),
                vector4(909.29, -183.58, 74.19, 60.71),
                vector4(911.35, -163.17, 74.38, 199.78),
                vector4(914.07, -160.41, 74.74, 197.14),
                vector4(921.18, -163.46, 74.86, 96.32),
                vector4(918.35, -167.02, 74.63, 98.34),
                vector4(916.45, -170.62, 74.44, 103.39),
            },
        },

        -- MENU AREAS (UI-facing, level-gated) — the city region to work in. The
        -- player picks a region in the menu (higher regions need a higher level);
        -- fares are drawn from that region's pickup/dropoff pools. An area with no
        -- pickup/dropoff lists. Every region carries its OWN pools (no shared
        -- global fallback) so each is fully self-contained.
        areas = {
            { id = "los_santos", name = "Los Santos", type = "taxi", requiredLevel = 0,
              payMultiplier = 1.0, -- fare per-distance scale for this region
              coord = vector3(895.31, -178.47, 74.69),
              pickupLocations = {
                  vector4(1131.52, -855.23, 52.57, 3.32),
                  vector4(1231.03, -1305.17, 33.96, 257.42),
                  vector4(1259.85, -1737.57, 49.02, 207.62),
                  vector4(913.23, -2192.32, 29.49, 263.16),
                  vector4(286.35, -2025.17, 18.34, 55.87),
                  vector4(327.74, -1767.18, 27.94, 221.99),
                  vector4(-83.01, -1580.73, 30.04, 320.82),
                  vector4(-721.239, -331.41, 34.56, 158.74),
                  vector4(-1343.35, -671.63, 25.06, 209.76),
                  vector4(-698.373, -849.24, 22.61, 354.33),
                  vector4(-1239.37, -1372.15, 3.07, 209.76),
                  vector4(926.703, -2220.026, 29.54, 85.03),
              },
              dropoffLocations = {
                  vector3(-572.59, -1081.78, 22.33),
                  vector3(-569.59, -1084.78, 22.33),
                  vector3(-239.38, -990.13, 29.29),
                  vector3(-317.79, -297.73, 30.93),
                  vector3(-78.58, 271.89, 101.15),
                  vector3(-481.53, 117.88, 63.91),
                  vector3(-1200.08, -273.57, 37.79),
                  vector3(922.03, 46.71, 81.11),
                  vector3(-155.55, -1519.42, 33.96),
                  vector3(-26.14, -762.69, 32.53),
                  vector3(102.29, 218.32, 107.85),
                  vector3(-751.84, -754.06, 26.61),
                  vector3(-46.21, -1655.20, 29.27),
              },
            },
            { id = "blaine", name = "Blaine County", type = "taxi", requiredLevel = 4,
              payMultiplier = 1.4, -- higher-level region pays more per distance
              coord = vector3(1960.0, 3740.0, 32.34),
              pickupLocations = {
                  vector4(2084.6880, 3724.6304, 32.8958, 32.1725),
                  vector4(1645.6099, 3587.1262, 35.3243, 298.5285),
                  vector4(921.5373, 3562.6448, 33.7104, 271.6651),
                  vector4(1789.4432, 3328.9443, 41.3558, 306.5924),
                  vector4(1717.6708, 3592.7144, 35.2869, 216.9273),
                  vector4(1555.7418, 3772.7188, 34.3963, 211.7291),
              },
              dropoffLocations = {
                  vector3(1757.0129, 3772.2271, 33.8108),
                  vector3(1840.4980, 3895.7571, 33.2670),
                  vector3(1870.7971, 3918.0405, 32.9728),
                  vector3(1908.0095, 3820.0554, 32.2201),
                  vector3(2504.5759, 4103.1343, 38.1811),
                  vector3(2707.7266, 4152.9448, 43.5472),
              },
            },
        },

        customerCall = {
            minTime = 0,
            maxTime = 1,
        },

        depot = {
            coord = vector3(895.31, -178.47, 74.69),
            interactDistance = 15.0, -- E-press radius for return/end-shift (was 8.0 — too tight)
        },

        blips = {
            pickup = { sprite = 280, color = 5, scale = 0.8 },
            dropoff = { sprite = 1, color = 2, scale = 0.8 },
            depot = { sprite = 198, color = 5, scale = 0.9 },
        },

        distanceMultiplier = 1.3,
    },

    clothes = {
        male = {
            tshirt_1 = 15,
            tshirt_2 = 0,
            torso_1 = 251,
            torso_2 = 0,
            arms = 1,
            pants_1 = 4,
            pants_2 = 0,
            shoes_1 = 10,
            shoes_2 = 0,
            chain_1 = 0,
            chain_2 = 0,
            helmet_1 = -1,
            helmet_2 = 0,
        },
        female = {
            tshirt_1 = 15,
            tshirt_2 = 0,
            torso_1 = 251,
            torso_2 = 0,
            decals_1 = 0,
            decals_2 = 0,
            arms = 1,
            pants_1 = 4,
            pants_2 = 0,
            shoes_1 = 10,
            shoes_2 = 0,
            chain_1 = -1,
            chain_2 = 0,
            helmet_1 = -1,
            helmet_2 = 0,
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

TaxiJob.preview = {
    playerPosition = vector3(895.0, -178.0, 74.69),
    vehicleStep = 2,
    steps = {
        {
            title = "Start the Job",
            description = {
                "Walk up to the taxi dispatcher NPC",
                "Press E to open the job menu",
                "Accept a shift to start driving",
            },
            camCoord = vector3(892.16, -180.93, 76.19),
            camTarget = vector3(895.31, -178.47, 75.19),
        },
        {
            title = "Get Your Taxi",
            description = {
                "Pick up an available taxi from the lot",
                "The meter will start when you pick up a fare",
                "Wait for a passenger request on your radio",
            },
            autoVehicle = true,
            camCoord = vector3(895.51, -182.49, 75.32),
            camTarget = vector3(898.92, -180.4, 74.32),
        },
        {
            title = "Pick Up Your Passenger",
            description = {
                "Drive to the pickup location on your map",
                "Stop near the passenger and wait for them",
                "They will get in the taxi automatically",
            },
            camCoord = vector3(1134.5, -852.5, 55.0),
            camTarget = vector3(1131.52, -855.23, 54.07),
            entities = {
                { type = "ped", model = "a_f_y_business_01", coords = vector4(1131.52, -855.23, 53.57, 90.0),
                  scenario = "WORLD_HUMAN_STAND_IMPATIENT" },
                { type = "vehicle", model = "taxi", coords = vector4(1129.0, -855.23, 53.57, 270.0) },
            },
        },
        {
            title = "Drive to the Destination",
            description = {
                "Follow the GPS route to the drop-off point",
                "Drive safely to earn a good tip",
                "Reckless driving will reduce your payment",
            },
            camCoord = vector3(-569.5, -1079.0, 23.5),
            camTarget = vector3(-572.59, -1081.78, 22.83),
            entities = {
                { type = "vehicle", model = "taxi", coords = vector4(-572.59, -1081.78, 22.33, 180.0) },
            },
        },
        {
            title = "Complete the Fare",
            description = {
                "Stop at the marked destination",
                "The passenger will pay and leave",
                "Pick up the next fare or return to the depot",
            },
            camCoord = vector3(898.5, -176.0, 76.0),
            camTarget = vector3(895.31, -178.47, 75.19),
        },
    },
}

return TaxiJob
