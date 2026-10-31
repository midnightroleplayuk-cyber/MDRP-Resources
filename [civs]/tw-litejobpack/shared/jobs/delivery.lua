local DeliveryJob = {

    id = "delivery",

    icon = "./img/jobs/delivery_icon.svg",
    image = "./img/jobs/delivery_bg.png",
    video = "https://tworst.info/uploads/videos/175783569502965cc194949ff4f0ee85_1775405588.mp4",
    enabled = true, -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0, -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(157.0, -3191.22, 7.03, 182.06),
        model = "mp_m_forgery_01",
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

    --
    xprewards = {
        deliveryCompleted = 50,
        jobCompleted = 0,
    },

    payment = {
        mode = "onJobEnd", -- "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        perDelivery = 225, -- pay per delivery completed
        completionBonus = 0, -- bonus paid once when job is fully completed
        coopMode = "full", -- "full" = everyone gets full pay | "split" = pay divided by player count
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

    runtime = {

        multiBox = {
            enabled = true,
            chance = 0.3,
            requiredBoxes = 2,
        },

        locationPool = {
            vector4(-61.19, -1093.85, 25.51, 43.03),
            vector4(474.47, -1757.54, 28.09, 257.69),
            vector4(519.62, -1734.22, 29.69, 59.31),
            vector4(500.7, -1697.14, 28.79, 144.18),
            vector4(443.4, -1707.35, 28.71, 51.68),
            vector4(464.61, -1672.67, 28.29, 51.46),
            vector4(431.24, -1725.41, 28.6, 134.35),
            vector4(419.1, -1735.45, 28.61, 136.59),
            vector4(405.65, -1751.24, 28.71, 136.46),
            vector4(479.74, -1736.11, 28.15, 206.93),
            vector4(313.90, -2040.67, 19.92, 308.98),
            vector4(353.25, -2036.40, 21.34, 107.72),
            vector4(152.66, -1823.60, 26.86, 56.69),
            vector4(-111.06, -1593.85, 30.98, 238.11),
            vector4(-125.63, -1473.48, 32.81, 317.48),
            vector4(168.15, -1299.18, 28.36, 68.03),
            vector4(52.35, -1588.22, 28.58, 48.19),
            vector4(-1098.75, -1679.82, 3.37, 138.81),
            vector4(-696.67, -1386.53, 4.50, 120.04),
            vector4(-712.28, -1298.52, 4.10, 53.37),

            vector4(-1011.08, -1224.77, 4.82, 270.70),
            vector4(-1002.37, -1219.47, 4.77, 166.70),
            vector4(15.63, -1309.80, 28.18, 303.82),
            vector4(-645.69, -1223.50, 10.22, 320.97),
            vector4(-650.10, -1149.75, 8.15, 169.19),
            vector4(-861.80, -1226.88, 5.25, 338.35),
            vector4(-717.68, -1119.78, 9.65, 324.58),
            vector4(-5.05, -1109.65, 27.82, 129.75),
            vector4(-667.70, -1104.73, 13.63, 71.25),
            vector4(472.43, -1277.76, 28.56, 293.74),

            vector4(-766.92, -1034.78, 13.13, 293.62),
            vector4(-703.35, -1040.54, 15.11, 249.29),
            vector4(-1025.38, -1137.81, 1.16, 26.35),
            vector4(-1101.90, -1231.05, 1.77, 95.33),
            vector4(-1229.12, -1035.15, 7.27, 54.11),
            vector4(15.19, -1032.53, 28.35, 130.38),
            vector4(-1612.55, -1028.77, 12.15, 238.88),
            vector4(-546.50, -889.48, 24.10, 185.46),

            vector4(-463.13, -276.30, 34.88, 13.40),
            vector4(-468.36, -62.54, 43.51, 351.81),
            vector4(-22.99, -192.27, 51.36, 109.59),
            vector4(-103.12, -69.93, 57.86, 302.54),
            vector4(93.35, 71.28, 72.42, 134.47),
            vector4(-512.04, 108.84, 62.80, 351.50),
            vector4(-697.17, 43.79, 42.32, 219.28),
            vector4(-1298.08, -393.13, 35.46, 253.15),
            vector4(-583.85, 195.23, 70.44, 99.70),
            vector4(597.10, 87.04, 91.77, 204.16),

            vector4(-136.65, 593.06, 203.52, 23.59),
            vector4(-635.17, 529.93, 108.69, 222.78),
            vector4(-1407.26, 537.01, 121.92, 80.63),
            vector4(-1974.53, 627.44, 121.54, 180.37),
            vector4(-2006.01, 449.67, 101.42, 345.54),
            vector4(-2185.30, -406.62, 12.09, 249.08),

            vector4(-392.43, 1238.26, 324.76, 158.93),
            vector4(-441.14, 1590.43, 356.91, 223.71),
            vector4(-1508.87, 1499.67, 114.29, 181.42),
        },

        workClothes = {
            coord = vector4(160.054, -3191.643, 5.047, 86.451),
        },

        finishPoint = vector4(164.93, -3225.23, 5.91, 260.0),

        depotLeaveDistance = 75.0,

        vehicle = {
            model = "boxville2",
            -- These spawn slots sit closer together than the default 7.0 clear
            -- radius (VehicleManager), which made one parked vehicle block every
            -- neighbouring slot and capped the job at one lobby at a time.
            -- Must stay BELOW the smallest slot-to-slot gap.
            spawnClearRadius = 4.5,
            spawnLocations = {
                vector4(146.77, -3189.67, 5.76, 180.58),
                vector4(140.52, -3189.24, 5.76, 179.26),
                vector4(150.12, -3208.84, 5.76, 1.61),
                vector4(135.89, -3210.48, 5.76, 2.12),
                vector4(127.06, -3208.68, 5.79, 358.47),
                vector4(125.31, -3204.03, 5.82, 268.59),
                vector4(126.7, -3196.94, 5.79, 270.82),
            },
            color = { primary = 111, secondary = 80 },
            plate = "KARGO",
            useCustomPlate = true,
            trunkDoors = { 2, 3 },
            trunkOffset = -4.5, -- distance behind vehicle when loading/taking cargo
            fuelOnSpawn = 100.0,

            cargoPositions = {
                { offset = vector3(-0.70, -3.13, 0.265), rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(-0.70, -2.75, 0.265), rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(-0.70, -2.35, 0.265), rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(-0.70, -1.95, 0.265), rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(0.70, -3.13, 0.265),  rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(0.70, -2.75, 0.265),  rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(0.70, -2.35, 0.265),  rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(0.70, -1.95, 0.265),  rotation = vector3(0.0, 0.0, 0.0) },
            },
        },

        cargo = {
            prop = "prop_cs_cardbox_01",
            carryBone = 57005,
            carryOffset = vector3(0.1, 0.0, -0.15),
            carryRotation = vector3(0.0, 0.0, 0.0),
            trunkPositions = {

                { pos = vector3(-0.70, -3.13, 0.265), rot = vector3(0.0, 0.0, 0.0) },
                { pos = vector3(-0.70, -2.75, 0.265), rot = vector3(0.0, 0.0, 0.0) },
                { pos = vector3(-0.70, -2.35, 0.265), rot = vector3(0.0, 0.0, 0.0) },
                { pos = vector3(-0.70, -1.95, 0.265), rot = vector3(0.0, 0.0, 0.0) },

                { pos = vector3(0.70, -3.13, 0.265),  rot = vector3(0.0, 0.0, 0.0) },
                { pos = vector3(0.70, -2.75, 0.265),  rot = vector3(0.0, 0.0, 0.0) },
                { pos = vector3(0.70, -2.35, 0.265),  rot = vector3(0.0, 0.0, 0.0) },
                { pos = vector3(0.70, -1.95, 0.265),  rot = vector3(0.0, 0.0, 0.0) },
            },
        },

        depot = {
            coords = vector4(134.79, -3200.03, 4.88, 10.48),
            model = "s_m_m_warehouse_01",
            scenario = "WORLD_HUMAN_CLIPBOARD",
            interactDistance = 2.0,
            marker = {
                type = 1,
                size = vector3(1.5, 1.5, 1.0),
                color = { r = 255, g = 165, b = 0, a = 150 },
            },
        },

        customer = {
            models = {
                "a_f_m_eastsa_02",
                "a_m_m_farmer_01",
                "a_f_y_business_02",
                "a_m_m_hasjew_01",
                "a_f_y_yoga_01",
                "a_m_y_genstreet_01",
                "a_f_y_hipster_02",
                "a_m_m_salton_02",
            },
            spawnDistance = 50.0,
            despawnDistance = 100.0,
            scenario = "WORLD_HUMAN_STAND_MOBILE",
            interactDistance = 2.0,
        },

        deliveryBlip = {
            sprite = 478,
            color = 47,
            scale = 0.8,
            label = "Delivery Point",
        },
    },

    clothes = {
        male = {
            tshirt_1 = 15,
            tshirt_2 = 0,
            torso_1 = 241,
            torso_2 = 3,
            arms = 0,
            pants_1 = 129,
            pants_2 = 1,
            shoes_1 = 12,
            shoes_2 = 0,
            chain_1 = 0,
            chain_2 = 0,
            helmet_1 = 142,
            helmet_2 = 0,
        },
        female = {
            tshirt_1 = 15,
            tshirt_2 = 0,
            torso_1 = 251,
            torso_2 = 3,
            decals_1 = 0,
            decals_2 = 0,
            arms = 1,
            pants_1 = 99,
            pants_2 = 0,
            shoes_1 = 12,
            shoes_2 = 0,
            chain_1 = -1,
            chain_2 = 0,
            helmet_1 = 141,
            helmet_2 = 0,
        },
    },
}

local runtime = DeliveryJob.runtime

DeliveryJob.preview = {
    playerPosition = vector3(157.0, -3191.0, 7.0),
    vehicleStep = 3,
    steps = {

        {
            camCoord = vector3(156.86, -3195.22, 8.53),
            camTarget = vector3(157.0, -3191.22, 7.53),
        },

        {
            autoClothes = true,
            camCoord = vector3(164.6, -3191.8, 8.0),
            camTarget = vector3(160.1, -3191.6, 5.6),
        },

        {
            autoVehicle = true,
            camCoord = vector3(146.6, -3183.8, 7.5),
            camTarget = vector3(146.7, -3188.6, 6.5),
        },

        {
            camCoord = vector3(135.7, -3200.7, 6.4),
            camTarget = vector3(134.1, -3196.8, 3.7),
            entities = {

                {
                    type = "ped",
                    model = "s_m_m_warehouse_01",
                    coords = vector4(134.79, -3200.03, 4.88, 10.48),
                    scenario = "WORLD_HUMAN_CLIPBOARD",
                    rawZ = true,
                },

                { type = "prop", model = "prop_cs_cardbox_01", coords = vector4(133.5, -3199.0, 4.88, 25.0), rawZ = true },
                { type = "prop", model = "prop_cs_cardbox_01", coords = vector4(133.3, -3199.3, 5.18, 45.0), rawZ = true },
                { type = "prop", model = "prop_cs_cardbox_01", coords = vector4(133.7, -3198.5, 4.88, 10.0), rawZ = true },

                {
                    type = "ped",
                    model = "mp_m_forgery_01",
                    coords = vector4(135.0, -3198.5, 4.88, 190.0),
                    anim = { dict = "anim@heists@load_box", name = "lift_box", flag = 1 },
                    rawZ = true,
                    persist = false,
                },

                {
                    type = "prop",
                    model = "prop_cs_cardbox_01",
                    attachTo = 5,
                    attachBone = 57005,
                    attachOffset = vector3(0.1, 0.0, -0.15),
                    attachRotation = vector3(0.0, 0.0, 0.0),
                    persist = false,
                },
            },
        },

        {
            autoCargo = { count = 6, model = "prop_cs_cardbox_01" },
            camCoord = vector3(146.7, -3183.4, 7.8),
            camTarget = vector3(146.8, -3188.2, 6.3),
            entities = {

                {
                    type = "ped",
                    model = "s_m_m_warehouse_01",
                    coords = vector4(147.5, -3188.0, 5.76, 130.0),
                    anim = { dict = "anim@heists@load_box", name = "lift_box", flag = 49 },
                    persist = false,
                },

                {
                    type = "prop",
                    model = runtime.cargo.prop,
                    attachTo = 1,
                    attachBone = runtime.cargo.carryBone,
                    attachOffset = runtime.cargo.carryOffset,
                    attachRotation = runtime.cargo.carryRotation,
                    persist = false,
                },
            },
        },

        {
            lockDuration = 3000,
            camCoord = vector3(481.1, -1741.5, 30.5),
            camTarget = vector3(482.3, -1737.6, 27.6),
            entities = {

                {
                    type = "vehicle",
                    model = "boxville2",
                    coords = vector4(482.36, -1747.01, 28.64, 245.83),
                    openDoors = { 2, 3 },
                },

                {
                    type = "ped",
                    model = "a_f_m_eastsa_02",
                    coords = vector4(480.65, -1737.9, 28.15, 206.93),
                    scenario = "WORLD_HUMAN_STAND_MOBILE",
                },

                {
                    type = "ped",
                    model = "mp_m_forgery_01",
                    coords = vector4(480.92, -1738.97, 28.15, 348.96),
                    anim = { dict = "anim@heists@load_box", name = "lift_box", flag = 49 },
                    persist = false,
                },

                {
                    type = "prop",
                    model = "prop_cs_cardbox_01",
                    attachTo = 3,
                    attachBone = 57005,
                    attachOffset = vector3(0.1, 0.0, -0.15),
                    attachRotation = vector3(0.0, 0.0, 0.0),
                    persist = false,
                },
            },
        },

        {
            camCoord = vector3(169.4, -3220.8, 9.3),
            camTarget = vector3(166.3, -3224.0, 6.9),
            entities = {

                {
                    type = "vehicle",
                    model = "boxville2",
                    coords = vector4(164.93, -3225.23, 5.91, 260.0),
                },

                {
                    type = "marker",
                    markerType = 20,
                    coords = vector4(164.93, -3225.23, 9.0, 0.0),
                    scale = vector3(0.5, 0.5, 0.5),
                    color = { r = 230, g = 180, b = 50, a = 200 },
                    bob = true,
                    rotate = true,
                },

                {
                    type = "prop",
                    model = "prop_mp_cone_01",
                    coords = vector4(163.5, -3225.5, 5.91, 0.0),
                    rawZ = true,
                },

                {
                    type = "prop",
                    model = "prop_mp_cone_01",
                    coords = vector4(166.5, -3225.0, 5.91, 0.0),
                    rawZ = true,
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
    -- lobbyAmount / playerAmount meaning: number of boxes delivered
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

return DeliveryJob
