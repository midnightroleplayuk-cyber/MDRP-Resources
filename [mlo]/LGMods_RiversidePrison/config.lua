Config = {}

Config.BlockScenarios = true     -- block vanilla scenario peds inside the site
Config.AmbientCleanup = false    -- delete any ambient ped / car that ends up inside the walls

-- Gate access
Config.GateAccess = {
    RequireJob = true,          -- true = only the jobs below can use the intercoms / auto-open
    Framework = 'auto',          -- 'auto', 'qbx', 'qbcore', 'esx' or 'custom'
    Jobs = {                     -- job = minimum grade (gates can override with `jobs`)
        police = 0,
    },
    RequireOnDuty = false,
    CustomCheck = function(source, gateId)   -- Framework = 'custom' only (server side)
        return true
    end,
}

-- Gates, shutters and sliding doors
Config.Intercom = {
    Enabled = true,
    Interaction = 'ox_target',   -- 'ox_target' or 'custom' (exports.LGMods_RiversidePrison:useIntercom(gateId))
    TargetDistance = 2.0,
    Size = vec3(0.45, 0.35, 0.65),
    Cooldown = 2,
    AutoOpenDriverOnly = true,
    Debug = false,

    Gates = {
        main = {
            label = 'Main Gate',
            type = 'swing',
            OpenTime = 5,        -- seconds open before closing (0 = stays open)
            SwingTime = 8.0,
            maxAngle = 90.0,
            poles = {
                { coords = vec3(1204.466, -1387.695, 35.403), heading = 20.0 },
            },
            exitZone = { coords = vec3(1190.5, -1392.0, 35.0), size = vec3(11.0, 4.4, 5.0), heading = 0.0 },
            -- map data, don't change
            leaves = {
                { model = `lgmods_rvp_maingate_l`, hinge = vec3(1197.980, -1394.300, 33.951), dir = 1, pivot = vec3(-0.15, 0.04, 0.0) },
                { model = `lgmods_rvp_maingate_r`, hinge = vec3(1197.980, -1389.700, 33.951), dir = -1, pivot = vec3(-0.15, -0.04, 0.0) },
            },
            wicket = { model = `lgmods_rvp_mainwicket`, cloneModel = `lgmods_rvp_mainwicket_s`, coords = vec3(1197.980, -1390.380, 33.951), leaf = 2, offset = vec3(0.0, -0.68, 0.0) },
        },
        delivery = {
            label = 'Delivery Gate',
            type = 'bifold',
            OpenTime = 5,
            FoldTime = 7.0,
            poles = {
                { coords = vec3(1139.484, -1416.955, 34.148), heading = 200.0 },
            },
            exitZone = { coords = vec3(1148.8, -1412.75, 34.5), size = vec3(8.5, 7.0, 5.0), heading = 0.0 },
            -- map data, don't change
            model = `lgmods_rvp_bifold`,
            panelWidth = 1.84,
            foldOffset = 0.10,
            maxAngle = 90.0,
            inward = vec3(1.0, 0.0, 0.0),
            leaves = {
                { hinge = vec3(1143.0, -1416.46, 33.51), along = vec3(0.0, 1.0, 0.0) },
                { hinge = vec3(1143.0, -1409.04, 33.51), along = vec3(0.0, -1.0, 0.0) },
            },
        },
    },

    Shutters = {
        ws_bay1 = {
            label = 'Workshops Loading Bay 1',
            OpenTime = 3,
            RollTime = 2.5,
            zones = {
                { coords = vec3(1140.80, -1386.0, 34.5), size = vec3(4.2, 4.0, 5.0), heading = 0.0 },
                { coords = vec3(1140.80, -1381.8, 35.5), size = vec3(4.2, 3.4, 4.0), heading = 0.0 },
            },
            model = `lgmods_rvp_shutter_ws`, coords = vec3(1140.80, -1383.67, 37.37), heading = 0.0,
        },
        ws_bay2 = {
            label = 'Workshops Loading Bay 2',
            OpenTime = 3,
            RollTime = 2.5,
            zones = {
                { coords = vec3(1153.80, -1386.0, 34.5), size = vec3(4.2, 4.0, 5.0), heading = 0.0 },
                { coords = vec3(1153.80, -1381.8, 35.5), size = vec3(4.2, 3.4, 4.0), heading = 0.0 },
            },
            model = `lgmods_rvp_shutter_ws`, coords = vec3(1153.80, -1383.67, 37.37), heading = 0.0,
        },
        kitchen = {
            label = 'Kitchen Goods In',
            OpenTime = 3,
            RollTime = 2.5,
            zones = {
                { coords = vec3(1127.70, -1374.0, 34.5), size = vec3(4.6, 4.0, 5.0), heading = 0.0 },
                { coords = vec3(1127.70, -1369.7, 35.5), size = vec3(5.0, 3.6, 4.0), heading = 0.0 },
            },
            model = `lgmods_rvp_shutter_kg`, coords = vec3(1127.50, -1371.67, 37.426), heading = 0.0,
        },
    },

    Text = {
        target = 'Use Intercom',
        opening = '%s opening',
        closing = '%s closing',
        noaccess = 'Access denied',
    },
}
