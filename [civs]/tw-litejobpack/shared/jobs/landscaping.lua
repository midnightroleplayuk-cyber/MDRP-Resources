local LandscapingJob = {

    id = "landscaping",

    icon = "./img/jobs/landscaping_icon.svg",
    image = "./img/jobs/landscaping_bg.png",
    video = "https://tworst.info/uploads/videos/eb1a34391163ab3b15124f84b644b5f5_1775405610.mp4",
    enabled = true, -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0, -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(-1083.27, -1261.93, 5.59, 306.89),
        model = "s_m_m_gardener_01",
        scenario = "WORLD_HUMAN_GARDENER_PLANT",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 631,
            color = 2,
            scale = 0.8,
        },
    },

    xprewards = {
        bushTrimmed = 30,
        lawnMowed = 20,
        jobCompleted = 500,
    },

    payment = {
        mode = "onJobEnd", -- "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        perBush = 50, -- pay per hedge trimmed
        perLawn = 30, -- pay per area mowed
        completionBonus = 0, -- bonus paid once when job is fully completed
        coopMode = "full", -- "full" = everyone gets full pay | "split" = pay divided by player count
    },

    stepRewards = {
        -- Available phases: onTrim (bush trimmed), onMow (lawn mowed)
        onTrim = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 10 } } },
        onMow  = { enabled = false, dropMode = "perItem", itemList = { { item = "water_bottle", count = 1, chance = 8 } } },
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

        usesRoutes = true,

        routes = {
            [1] = {
                name = "Vespucci",
                requiredLevel = 1,
                coord = vector3(-1324.90, -1400.68, 3.83),
                bushCount = { min = 2, max = 3 },
                lawnCount = { min = 2, max = 3 },
                bushLocations = {
                    { x = -1268.62, y = -1463.63, z = 3.4, heading = 215.0 },
                    { x = -1272.19, y = -1458.32, z = 3.4, heading = 215.0 },
                    { x = -1275.76, y = -1453.01, z = 3.4, heading = 215.0 },
                    { x = -1279.33, y = -1447.69, z = 3.4, heading = 215.0 },
                    { x = -1282.90, y = -1442.38, z = 3.4, heading = 215.0 },
                    { x = -1286.47, y = -1437.07, z = 3.4, heading = 215.0 },
                    { x = -1290.03, y = -1431.76, z = 3.4, heading = 215.0 },
                    { x = -1294.97, y = -1425.05, z = 3.4, heading = 215.5 },
                    { x = -1298.53, y = -1419.73, z = 3.4, heading = 215.5 },
                    { x = -1311.87, y = -1389.00, z = 3.4, heading = 200.0 },
                    { x = -1314.06, y = -1382.77, z = 3.4, heading = 200.0 },
                    { x = -1316.25, y = -1376.55, z = 3.4, heading = 200.0 },
                    { x = -1318.44, y = -1370.32, z = 3.4, heading = 200.0 },
                    { x = -1320.64, y = -1364.10, z = 3.4, heading = 200.0 },
                    { x = -1322.83, y = -1357.87, z = 3.4, heading = 200.0 },
                    { x = -1325.02, y = -1351.65, z = 3.4, heading = 200.0 },
                    { x = -1327.22, y = -1345.42, z = 3.4, heading = 200.0 },
                },
                lawnLocations = {
                    { x = -1325.62, y = -1391.54, z = 4.51 },
                    { x = -1320.62, y = -1432.54, z = 4.08 },
                    { x = -1340.62, y = -1393.54, z = 3.82 },
                    { x = -1348.62, y = -1402.54, z = 3.56 },
                    { x = -1347.62, y = -1348.54, z = 4.10 },
                    { x = -1322.62, y = -1396.54, z = 4.27 },
                    { x = -1305.62, y = -1436.54, z = 3.65 },
                    { x = -1319.62, y = -1378.54, z = 4.01 },
                    { x = -1328.62, y = -1358.54, z = 3.88 },
                    { x = -1334.62, y = -1376.54, z = 4.22 },
                    { x = -1365.62, y = -1362.54, z = 3.11 },
                    { x = -1332.62, y = -1383.54, z = 4.40 },
                    { x = -1305.62, y = -1432.54, z = 3.76 },
                    { x = -1335.62, y = -1360.54, z = 4.41 },
                    { x = -1286.62, y = -1449.54, z = 3.55 },
                    { x = -1343.62, y = -1342.54, z = 4.06 },
                    { x = -1321.62, y = -1387.54, z = 4.42 },
                    { x = -1303.62, y = -1434.54, z = 3.79 },
                    { x = -1345.62, y = -1406.54, z = 3.55 },
                    { x = -1327.62, y = -1375.54, z = 4.28 },
                },
            },
            [2] = {
                name = "Pillbox Hill",
                requiredLevel = 2,
                coord = vector3(-105.95, -440.47, 34.53),
                bushCount = { min = 3, max = 4 },
                lawnCount = { min = 3, max = 4 },
                bushLocations = {
                    { x = -98.33,  y = -393.62, z = 35.69, heading = 200.0 },
                    { x = -91.84,  y = -395.95, z = 35.74, heading = 200.0 },
                    { x = -83.18,  y = -399.05, z = 35.82, heading = 200.0 },
                    { x = -74.51,  y = -402.15, z = 36.08, heading = 200.0 },
                    { x = -155.42, y = -437.49, z = 32.73, heading = 200.0 },
                    { x = -152.69, y = -428.70, z = 32.68, heading = 200.0 },
                    { x = -149.97, y = -419.91, z = 32.62, heading = 200.0 },
                    { x = -147.24, y = -411.12, z = 32.55, heading = 200.0 },
                    { x = -144.52, y = -402.34, z = 32.51, heading = 200.0 },
                },
                lawnLocations = {
                    { x = -123.25, y = -466.81, z = 33.19 },
                    { x = -134.25, y = -388.81, z = 33.15 },
                    { x = -60.25,  y = -416.81, z = 37.31 },
                    { x = -102.25, y = -429.81, z = 35.19 },
                    { x = -99.25,  y = -462.81, z = 33.79 },
                    { x = -65.25,  y = -454.81, z = 37.39 },
                    { x = -81.25,  y = -421.81, z = 35.71 },
                    { x = -126.25, y = -378.81, z = 34.63 },
                    { x = -49.25,  y = -428.81, z = 38.74 },
                    { x = -103.25, y = -445.81, z = 34.91 },
                    { x = -159.25, y = -459.81, z = 32.81 },
                    { x = -134.25, y = -405.81, z = 33.22 },
                    { x = -133.25, y = -421.81, z = 33.12 },
                    { x = -109.25, y = -454.81, z = 33.84 },
                    { x = -80.25,  y = -394.81, z = 36.01 },
                    { x = -75.25,  y = -408.81, z = 36.21 },
                    { x = -80.25,  y = -460.81, z = 35.53 },
                    { x = -47.25,  y = -430.81, z = 38.81 },
                    { x = -164.25, y = -468.81, z = 32.23 },
                    { x = -70.25,  y = -462.81, z = 36.35 },
                },
            },
            [3] = {
                name = "Little Seoul",
                requiredLevel = 3,
                coord = vector3(-526.70, -230.12, 35.54),
                bushCount = { min = 3, max = 5 },
                lawnCount = { min = 3, max = 5 },
                bushLocations = {
                    { x = -560.15, y = -270.90, z = 34.09, heading = 200.0 },
                    { x = -567.01, y = -258.93, z = 34.48, heading = 200.0 },
                    { x = -573.86, y = -246.95, z = 34.86, heading = 200.0 },
                    { x = -581.86, y = -232.98, z = 35.30, heading = 200.0 },
                    { x = -588.72, y = -221.00, z = 35.69, heading = 200.0 },
                    { x = -596.71, y = -207.03, z = 36.10, heading = 200.0 },
                    { x = -498.63, y = -189.37, z = 36.28, heading = 200.0 },
                    { x = -506.84, y = -175.52, z = 36.72, heading = 200.0 },
                    { x = -513.87, y = -163.65, z = 37.08, heading = 200.0 },
                },
                lawnLocations = {
                    { x = -492.15, y = -211.35, z = 35.74 },
                    { x = -572.15, y = -245.35, z = 35.83 },
                    { x = -549.15, y = -249.35, z = 35.48 },
                    { x = -566.15, y = -244.35, z = 35.63 },
                    { x = -546.15, y = -250.35, z = 35.31 },
                    { x = -505.15, y = -193.35, z = 36.21 },
                    { x = -557.15, y = -253.35, z = 35.57 },
                    { x = -501.15, y = -209.35, z = 35.81 },
                    { x = -509.15, y = -182.35, z = 36.69 },
                    { x = -553.15, y = -257.35, z = 35.34 },
                    { x = -541.15, y = -267.35, z = 34.39 },
                    { x = -540.15, y = -245.35, z = 35.22 },
                    { x = -512.15, y = -236.35, z = 34.90 },
                    { x = -541.15, y = -252.35, z = 35.04 },
                    { x = -505.15, y = -195.35, z = 36.11 },
                    { x = -545.15, y = -246.35, z = 35.47 },
                },
            },
            [4] = {
                name = "Burton",
                requiredLevel = 4,
                coord = vector3(-975.43, 313.51, 69.08),
                bushCount = { min = 4, max = 6 },
                lawnCount = { min = 4, max = 6 },
                bushLocations = {
                    { x = -971.09, y = 284.17, z = 67.72, heading = 200.0 },
                    { x = -975.69, y = 284.26, z = 67.46, heading = 200.0 },
                    { x = -982.59, y = 284.39, z = 67.04, heading = 200.0 },
                    { x = -989.49, y = 284.52, z = 66.60, heading = 200.0 },
                    { x = -996.39, y = 284.64, z = 66.13, heading = 200.0 },
                    { x = -945.23, y = 275.25, z = 68.97, heading = 200.0 },
                    { x = -949.64, y = 276.56, z = 68.72, heading = 200.0 },
                    { x = -956.26, y = 278.53, z = 68.41, heading = 200.0 },
                    { x = -962.87, y = 280.49, z = 68.09, heading = 200.0 },
                },
                lawnLocations = {
                    { x = -1001.49, y = 314.62, z = 67.79 },
                    { x = -963.49,  y = 313.62, z = 69.65 },
                    { x = -936.49,  y = 284.62, z = 69.60 },
                    { x = -990.49,  y = 328.62, z = 69.23 },
                    { x = -1013.49, y = 328.62, z = 68.31 },
                    { x = -970.49,  y = 332.62, z = 70.10 },
                    { x = -981.49,  y = 292.62, z = 67.57 },
                    { x = -984.49,  y = 326.62, z = 69.36 },
                    { x = -994.49,  y = 313.62, z = 68.12 },
                    { x = -977.49,  y = 285.62, z = 67.59 },
                    { x = -981.49,  y = 345.62, z = 71.16 },
                    { x = -946.49,  y = 350.62, z = 71.01 },
                    { x = -975.49,  y = 323.62, z = 69.53 },
                    { x = -973.49,  y = 284.62, z = 67.78 },
                    { x = -1000.49, y = 295.62, z = 67.19 },
                    { x = -978.49,  y = 334.62, z = 70.11 },
                },
            },
            [5] = {
                name = "Vinewood Hills",
                requiredLevel = 5,
                coord = vector3(-811.38, 860.23, 202.23),
                bushCount = { min = 5, max = 7 },
                lawnCount = { min = 5, max = 7 },
                bushLocations = {
                    { x = -871.01, y = 857.59, z = 202.10, heading = 200.0 },
                    { x = -868.79, y = 860.02, z = 202.10, heading = 200.0 },
                    { x = -864.34, y = 864.90, z = 202.10, heading = 200.0 },
                    { x = -859.89, y = 869.77, z = 202.10, heading = 200.0 },
                    { x = -855.44, y = 874.64, z = 202.10, heading = 200.0 },
                    { x = -872.12, y = 853.42, z = 202.10, heading = 200.0 },
                    { x = -871.92, y = 850.12, z = 202.10, heading = 200.0 },
                    { x = -871.73, y = 846.83, z = 202.10, heading = 200.0 },
                    { x = -871.53, y = 843.53, z = 202.10, heading = 200.0 },
                },
                lawnLocations = {
                    { x = -795.32, y = 872.16, z = 202.17 },
                    { x = -823.32, y = 881.16, z = 202.19 },
                    { x = -800.32, y = 877.16, z = 202.16 },
                    { x = -825.32, y = 871.16, z = 202.02 },
                    { x = -809.32, y = 877.16, z = 202.19 },
                    { x = -812.32, y = 844.16, z = 202.21 },
                    { x = -802.32, y = 853.16, z = 202.53 },
                    { x = -806.32, y = 855.16, z = 202.37 },
                    { x = -816.32, y = 856.16, z = 202.07 },
                    { x = -791.32, y = 878.16, z = 202.16 },
                    { x = -824.32, y = 856.16, z = 201.91 },
                    { x = -825.32, y = 860.16, z = 201.90 },
                    { x = -821.32, y = 854.16, z = 201.95 },
                    { x = -813.32, y = 863.16, z = 202.09 },
                    { x = -800.32, y = 863.16, z = 202.18 },
                    { x = -815.32, y = 847.16, z = 202.12 },
                },
            },
        },

        workClothes = {
            coord = vector4(-1085.827, -1256.468, 4.555, 121.574),
        },

        vehicle = {
            model = "bison",
            color = { primary = 28, secondary = 111 },
            plate = "GARDEN",
            useCustomPlate = false,
            fuelOnSpawn = 100.0,
            -- These spawn slots sit closer together than the default 7.0 clear
            -- radius (VehicleManager), which made one parked vehicle block every
            -- neighbouring slot and capped the job at one lobby at a time.
            -- Must stay BELOW the smallest slot-to-slot gap.
            spawnClearRadius = 3.0,
            spawnLocations = {
                vector4(-1071.32, -1248.15, 5.14, 120.32),
                vector4(-1070.17, -1251.17, 5.25, 117.96),
                vector4(-1068.37, -1254.34, 5.38, 119.44),
                vector4(-1065.78, -1257.39, 5.5, 119.63),
                vector4(-1073.77, -1245.32, 4.97, 117.89),
            },
            trunkDoors = { 5 },
            trunkOffset = -3.5, -- distance behind vehicle when picking up / returning items from trunk
            toolProp = "prop_hedge_trimmer_01",

            toolPositions = {
                { offset = vector3(-0.4, -1.8, 0.55), rotation = vector3(0.0, 0.0, 90.0) },
                { offset = vector3(0.4, -1.8, 0.55),  rotation = vector3(0.0, 90.0, 0.0) },
            },
        },

        tools = {
            trimmer = { positionIndex = 1, prop = "prop_hedge_trimmer_01" },
            shovel  = { positionIndex = 2, prop = "prop_tool_shovel" },
        },

        shovel = {
            prop = "prop_tool_shovel",
            boneIndex = 28422,
            offset = vector3(0.0, 0.0, 0.24),
            rotation = vector3(0.0, 0.0, 0.0),
            idleOffset = {
                x = 0.03,
                y = 0.050,
                z = 0.400,
                rx = 0.0,
                ry = 0.0,
                rz = 0.0,
            },
            idleAnim = {
                dict = "missfbi4prepp1",
                name = "idle",
            },
            diggingAnimation = {
                dict = "random@burial",
                clip = "a_burial",
                duration = 5000,
            },
        },

        trimmer = {
            prop = "prop_hedge_trimmer_01",
            boneIndex = 57005,
            offset = vector3(0.09, 0.02, 0.01),
            rotation = vector3(-121.0, 181.0, 187.0),
            idleAnimation = nil,
            trimmingAnimation = {
                dict = "anim@mp_radio@garage@medium",
                clip = "idle_a",
                duration = 4300,
            },
        },

        bushTrimming = {
            taskCount = { min = 2, max = 3 },
            interactDistance = 2.0,
            blip = { sprite = 1, color = 24, scale = 0.6 },

            models = {
                before = { "prop_bush_neat_08" },
                after = { "prop_bush_ornament_04", "prop_bush_ornament_02", "prop_bush_ornament_03", "prop_bush_neat_02" },
            },

            fadeDelay = 90,
            fadeStep = 8,

            particle = {
                dict = "core",
                name = "ent_dst_wood_splinter",
            },

            locations = {
                { x = -1268.62, y = -1463.63, z = 3.4, heading = 215.0 },
                { x = -1270.41, y = -1460.98, z = 3.4, heading = 215.0 },
                { x = -1272.19, y = -1458.32, z = 3.4, heading = 215.0 },
                { x = -1273.98, y = -1455.66, z = 3.4, heading = 215.0 },
                { x = -1275.76, y = -1453.01, z = 3.4, heading = 215.0 },
                { x = -1277.54, y = -1450.35, z = 3.4, heading = 215.0 },
                { x = -1279.33, y = -1447.69, z = 3.4, heading = 215.0 },
                { x = -1281.11, y = -1445.04, z = 3.4, heading = 215.0 },
                { x = -1282.90, y = -1442.38, z = 3.4, heading = 215.0 },
                { x = -1284.68, y = -1439.73, z = 3.4, heading = 215.0 },
                { x = -1286.47, y = -1437.07, z = 3.4, heading = 215.0 },
                { x = -1288.25, y = -1434.41, z = 3.4, heading = 215.0 },
                { x = -1290.03, y = -1431.76, z = 3.4, heading = 215.0 },
                { x = -1291.82, y = -1429.10, z = 3.4, heading = 215.0 },
                { x = -1294.97, y = -1425.05, z = 3.4, heading = 215.5 },
                { x = -1296.75, y = -1422.39, z = 3.4, heading = 215.5 },
                { x = -1298.53, y = -1419.73, z = 3.4, heading = 215.5 },
                { x = -1311.87, y = -1389.00, z = 3.4, heading = 200.0 },
                { x = -1312.96, y = -1385.88, z = 3.4, heading = 200.0 },
                { x = -1314.06, y = -1382.77, z = 3.4, heading = 200.0 },
                { x = -1315.16, y = -1379.66, z = 3.4, heading = 200.0 },
                { x = -1316.25, y = -1376.55, z = 3.4, heading = 200.0 },
                { x = -1317.35, y = -1373.43, z = 3.4, heading = 200.0 },
                { x = -1318.44, y = -1370.32, z = 3.4, heading = 200.0 },
                { x = -1319.54, y = -1367.21, z = 3.4, heading = 200.0 },
                { x = -1320.64, y = -1364.10, z = 3.4, heading = 200.0 },
                { x = -1321.73, y = -1360.98, z = 3.4, heading = 200.0 },
                { x = -1322.83, y = -1357.87, z = 3.4, heading = 200.0 },
                { x = -1323.93, y = -1354.76, z = 3.4, heading = 200.0 },
                { x = -1325.02, y = -1351.65, z = 3.4, heading = 200.0 },
                { x = -1326.12, y = -1348.53, z = 3.4, heading = 200.0 },
                { x = -1327.22, y = -1345.42, z = 3.4, heading = 200.0 },
            },
        },

        lawnMowing = {
            taskCount = { min = 2, max = 3 },
            interactDistance = 2.0,
            blip = { sprite = 1, color = 25, scale = 0.6 },

            models = {
                "prop_weeddry_nxg04",
                "prop_weeds_nxg08",
                "prop_weeds_nxg07b001",
                "prop_weeds_nxg06",
                "prop_weeds_nxg07b",
                "prop_weeds_nxg08b",
            },

            zOffsets = {
                ["prop_weeds_nxg06"] = -0.28,
                ["prop_weeds_nxg08"] = -0.28,
                ["prop_weeds_nxg07b"] = -0.28,
                ["prop_weeds_nxg08b"] = -0.38,
                ["prop_weeddry_nxg04"] = 0.0,
                ["prop_weeds_nxg07b001"] = 0.0,
            },

            locations = {
                { x = -1325.62, y = -1391.54, z = 4.51 },
                { x = -1324.62, y = -1395.54, z = 4.28 },
                { x = -1320.62, y = -1432.54, z = 4.08 },
                { x = -1301.62, y = -1423.54, z = 3.60 },
                { x = -1340.62, y = -1393.54, z = 3.82 },
                { x = -1348.62, y = -1402.54, z = 3.56 },
                { x = -1297.62, y = -1425.54, z = 3.61 },
                { x = -1347.62, y = -1348.54, z = 4.10 },
                { x = -1336.62, y = -1338.54, z = 4.07 },
                { x = -1322.62, y = -1396.54, z = 4.27 },
                { x = -1305.62, y = -1436.54, z = 3.65 },
                { x = -1350.62, y = -1406.54, z = 3.56 },
                { x = -1319.62, y = -1378.54, z = 4.01 },
                { x = -1306.62, y = -1420.54, z = 3.55 },
                { x = -1328.62, y = -1358.54, z = 3.88 },
                { x = -1311.62, y = -1419.54, z = 3.64 },
                { x = -1334.62, y = -1376.54, z = 4.22 },
                { x = -1365.62, y = -1362.54, z = 3.11 },
                { x = -1325.62, y = -1426.54, z = 4.46 },
                { x = -1323.62, y = -1425.54, z = 4.52 },
                { x = -1332.62, y = -1383.54, z = 4.40 },
                { x = -1338.62, y = -1388.54, z = 4.02 },
                { x = -1305.62, y = -1432.54, z = 3.76 },
                { x = -1321.62, y = -1369.54, z = 3.79 },
                { x = -1335.62, y = -1360.54, z = 4.41 },
                { x = -1320.62, y = -1384.54, z = 4.09 },
                { x = -1286.62, y = -1449.54, z = 3.55 },
                { x = -1317.62, y = -1430.54, z = 3.79 },
                { x = -1343.62, y = -1342.54, z = 4.06 },
                { x = -1330.62, y = -1349.54, z = 4.22 },
                { x = -1321.62, y = -1387.54, z = 4.42 },
                { x = -1300.62, y = -1427.54, z = 3.75 },
                { x = -1292.62, y = -1435.54, z = 3.77 },
                { x = -1303.62, y = -1434.54, z = 3.79 },
                { x = -1345.62, y = -1406.54, z = 3.55 },
                { x = -1301.62, y = -1419.54, z = 3.55 },
                { x = -1327.62, y = -1375.54, z = 4.28 },
                { x = -1322.62, y = -1427.54, z = 4.46 },
                { x = -1331.62, y = -1394.54, z = 3.83 },
                { x = -1335.62, y = -1340.54, z = 4.16 },
                { x = -1303.62, y = -1440.54, z = 3.85 },
                { x = -1309.62, y = -1420.54, z = 3.71 },
                { x = -1325.62, y = -1439.54, z = 3.82 },
                { x = -1338.62, y = -1345.54, z = 4.33 },
                { x = -1340.62, y = -1388.54, z = 3.94 },
                { x = -1276.62, y = -1455.54, z = 3.51 },
                { x = -1373.62, y = -1369.54, z = 2.68 },
                { x = -1284.62, y = -1446.54, z = 3.55 },
                { x = -1360.62, y = -1368.54, z = 2.67 },
                { x = -1343.62, y = -1372.54, z = 3.70 },
            },
        },

        delivery = {
            coords = vector3(-1082.67, -1240.99, 4.61),
            distance = 5.0,
            blip = { sprite = 38, color = 29, scale = 0.8 },
        },

        workArea = {
            center = vector3(-1310.0, -1400.0, 4.0),
            radius = 150.0,
        },
    },

    clothes = {
        male = {
            tshirt_1 = 59,
            tshirt_2 = 0,
            torso_1 = 56,
            torso_2 = 0,
            arms = 73,
            pants_1 = 9,
            pants_2 = 1,
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
            torso_1 = 59,
            torso_2 = 2,
            decals_1 = 0,
            decals_2 = 0,
            arms = 0,
            pants_1 = 30,
            pants_2 = 0,
            shoes_1 = 55,
            shoes_2 = 0,
            chain_1 = -1,
            chain_2 = 0,
            helmet_1 = -1,
            helmet_2 = 0,
        },
    },
}

LandscapingJob.preview = {
    playerPosition = vector3(-1083.0, -1261.0, 5.59),
    vehicleStep = 3,
    steps = {
        {
            camCoord = vector3(-1080.0, -1260.1, 6.5),
            camTarget = vector3(-1084.3, -1262.5, 5.9),
        },
        {
            autoClothes = true,
            camCoord = vector3(-1082.4, -1254.1, 7.4),
            camTarget = vector3(-1086.0, -1256.6, 4.9),
        },
        {
            autoVehicle = true,
            autoTools = { model = "prop_hedge_trimmer_01" },
            camCoord = vector3(-1066.2, -1245.4, 7.1),
            camTarget = vector3(-1070.5, -1247.7, 5.9),
        },
        {
            lockDuration = 3500,
            camCoord = vector3(-1272.0, -1465.7, 5.7),
            camTarget = vector3(-1268.1, -1463.3, 3.7),
            entities = {
                { type = "prop", model = "prop_bush_neat_08", coords = vector4(-1268.62, -1463.63, 3.4, 215.0) },
                { type = "prop", model = "prop_bush_neat_08", coords = vector4(-1270.41, -1460.98, 3.4, 215.0) },
                {
                    type = "ped",
                    model = "s_m_m_gardener_01",
                    coords = vector4(-1269.5, -1462.5, 3.4, 215.0),
                    faceCoord = vector3(-1268.62, -1463.63, 3.4),
                    anim = { dict = "anim@mp_radio@garage@medium", name = "idle_a", flag = 1 },
                },
                {
                    type = "prop",
                    model = "prop_hedge_trimmer_01",
                    attachTo = 3,
                    attachBone = 57005,
                    attachOffset = vector3(0.09, 0.02, 0.01),
                    attachRotation = vector3(-121.0, 181.0, 187.0),
                },
            },
        },
        {
            lockDuration = 3500,
            camCoord = vector3(-1329.6, -1394.1, 7.2),
            camTarget = vector3(-1326.0, -1391.8, 4.7),
            entities = {
                { type = "prop", model = "prop_weeds_nxg08",   coords = vector4(-1325.62, -1391.54, 4.23, 0.0) },
                { type = "prop", model = "prop_weeddry_nxg04", coords = vector4(-1324.62, -1395.54, 4.28, 45.0) },
                {
                    type = "ped",
                    model = "s_m_m_gardener_01",
                    coords = vector4(-1325.0, -1392.5, 4.01, 180.0),
                    faceCoord = vector3(-1325.62, -1391.54, 4.01),
                    anim = { dict = "random@burial", name = "a_burial", flag = 1 },
                },
                {
                    type = "prop",
                    model = "prop_tool_shovel",
                    attachTo = 3,
                    attachBone = 28422,
                    attachOffset = vector3(0.0, 0.0, 0.24),
                    attachRotation = vector3(0.0, 0.0, 0.0),
                },
            },
        },
        {
            camCoord = vector3(-1087.7, -1243.5, 6.6),
            camTarget = vector3(-1083.4, -1241.4, 5.3),
            entities = {
                {
                    type = "vehicle",
                    model = "bison",
                    coords = vector4(-1082.67, -1240.99, 4.11, 120.0),
                    color = { primary = 28, secondary = 111 },
                    openDoors = {}
                },
                {
                    type = "marker",
                    markerType = 20,
                    coords = vector4(-1082.67, -1240.99, 6.5, 0.0),
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
    -- lobbyAmount / playerAmount meaning: total bushes trimmed + lawns mowed
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

return LandscapingJob
