-- ====================================================================
-- REGIONS 2 & 3 -- Tower Crane: Stone / Wall
-- ====================================================================
-- Same mechanic, two separate sites (jobMetadata.instanceId = main / site2).
-- The server side is server/tower_sync.lua (this region has no server/jobs file).
-- ====================================================================

local TOWER_RENT_ALLOWED  = { 'bison2' }
local TOWER_CREW_PROFILES = {
    [1] = { vehicles = { bison2 = 1 } },
    [3] = { vehicles = { bison2 = 1 } },
}

local TOWER_MIN_PLAYERS = 1
local TOWER_MAX_PLAYERS = 2

Config.TowerStoneJob = {
    -- which regionData record this block belongs to
    jobType = 'kulestone',
    placeRotOrder = 2,

    instanceId = 'main',

    rentAllowed  = TOWER_RENT_ALLOWED,
    crewProfiles = TOWER_CREW_PROFILES,
    minPlayers   = TOWER_MIN_PLAYERS,
    maxPlayers   = TOWER_MAX_PLAYERS,

    zoneId = 'buildermainzone',

    model = 'tworst_buildstonebricko',

    pickup = {
        base            = vector3(971.768, 2413.770, 51.345),
        rot             = vector3(90.000, -54.982, -90.000),
-- ⚠ The hologram and the PLACEMENT must use the same rotation order.
-- The ghost slot is drawn with order 2 (ZXY) and this value drives the
-- placement. If they differ, panels drift on multi-axis slots.
        rotOrder        = 0,
        stackCount      = 5,
        stackStep       = vector3(0.000, 0.020, 0.795),
        respawnOnPlaced = true,
    },

    slots = {
        { coords = vector3(918.795, 2429.740, 54.710), rot = vector3(0.00, 0.00,   16.72) },
        { coords = vector3(923.850, 2427.041, 54.710), rot = vector3(0.00, 0.00,   36.24) },
        { coords = vector3(929.473, 2426.023, 54.710), rot = vector3(0.00, 0.00,   52.18) },
        { coords = vector3(935.184, 2426.779, 54.710), rot = vector3(0.00, 0.00,   73.69) },
        { coords = vector3(940.358, 2429.282, 54.710), rot = vector3(0.00, 0.00,   88.15) },
        { coords = vector3(944.485, 2433.233, 54.710), rot = vector3(0.00, 0.00,  109.46) },
        { coords = vector3(947.214, 2438.323, 54.708), rot = vector3(0.00, 0.00,  124.79) },
        { coords = vector3(948.253, 2443.982, 54.708), rot = vector3(0.00, 0.00,  144.00) },
        { coords = vector3(947.489, 2449.699, 54.708), rot = vector3(0.00, 0.00,  161.69) },
        { coords = vector3(944.987, 2454.867, 54.708), rot = vector3(0.00, 0.00, -179.57) },
        { coords = vector3(941.022, 2459.022, 54.708), rot = vector3(0.00, 0.00, -161.68) },
        { coords = vector3(935.973, 2461.756, 54.708), rot = vector3(0.00, 0.00, -143.74) },
        { coords = vector3(930.295, 2462.790, 54.708), rot = vector3(0.00, 0.00, -126.86) },
        { coords = vector3(912.294, 2439.046, 54.717), rot = vector3(0.00, 0.00,  -17.78) },
        { coords = vector3(911.496, 2444.739, 54.717), rot = vector3(0.00, 0.00,  -36.31) },
        { coords = vector3(912.504, 2450.398, 54.717), rot = vector3(0.00, 0.00,  -54.83) },
        { coords = vector3(915.223, 2455.453, 54.717), rot = vector3(0.00, 0.00,  -72.10) },
        { coords = vector3(924.609, 2462.026, 54.708), rot = vector3(0.00, 0.00, -106.16) },
        { coords = vector3(919.424, 2459.464, 54.708), rot = vector3(0.00, 0.00,  -91.56) },
        { coords = vector3(914.822, 2433.894, 54.710), rot = vector3(0.00, 0.00,    0.25) },
    },

    grabRange  = 4.0,
    placeRange = 4.0,

    hookAttach = {
        offset = vector3(0.0, 0.0, -0.4),
        rot    = vector3(0.0, 0.0, 0.0),
    },

    placementStyle = 'simple',
}

local TOWER_TEST_SLOT_LIMIT = 0
if TOWER_TEST_SLOT_LIMIT and TOWER_TEST_SLOT_LIMIT > 0
    and #Config.TowerStoneJob.slots > TOWER_TEST_SLOT_LIMIT then
    local full = #Config.TowerStoneJob.slots
    for i = full, TOWER_TEST_SLOT_LIMIT + 1, -1 do
        Config.TowerStoneJob.slots[i] = nil
    end
    print(('^1[kulestone][RELEASE BLOCKER] R2 slot count TEST OVERRIDE: %d → %d — set TOWER_TEST_SLOT_LIMIT = 0 before release.^7')
        :format(full, TOWER_TEST_SLOT_LIMIT))
end

Config.TowerSite2Job = {
    -- which regionData record this block belongs to
    jobType = 'kulestone',
    placeRotOrder = 2,

    instanceId = 'site2',
    zoneId     = 'site2',

    rentAllowed  = TOWER_RENT_ALLOWED,
    crewProfiles = TOWER_CREW_PROFILES,
    minPlayers   = TOWER_MIN_PLAYERS,
    maxPlayers   = TOWER_MAX_PLAYERS,
    model      = 'tworst_buildjob6wall1',

    stages = {
        elevator = {
            order          = 1,
            labelKey = 'kulestage_1', label          = TL('kulestage_1', 'Stage 1 - Elevator assembly'),
            sequential     = true,
            prereq         = nil,
            placementStyle    = 'elevatorAuto',
            forceLinearAuto   = true,
            aboveClearance    = 4.0,
            phase1Duration    = 1100,
            phase2Duration    = 1400,
            hookAttach = {
                offset = vector3(0.8, 1.0, -0.5),
                rot    = vector3(0.0, 0.0, 0.0),
            },
            pickupList = {
                { coords = vector3(81.346, -425.041, 39.331), rot = vector3(0.0, 0.0, 0.0), model = 'tworst_buildelvvent'  },
                { coords = vector3(68.741, -430.400, 39.024), rot = vector3(0.0, 0.0, 0.0), model = 'tworst_buildelvvent2' },
                { coords = vector3(79.750, -429.769, 39.331), rot = vector3(0.0, 0.0, 0.0), model = 'tworst_buildelvvent'  },
                { coords = vector3(71.297, -423.832, 39.024), rot = vector3(0.0, 0.0, 0.0), model = 'tworst_buildelvvent2' },
                { coords = vector3(77.849, -434.256, 39.331), rot = vector3(0.0, 0.0, 0.0), model = 'tworst_buildelvvent'  },
            },
        },
        roofPosts = {
            order          = 2,
            labelKey = 'kulestage_2', label          = TL('kulestage_2', 'Stage 2 - Roof posts'),
            sequential     = false,
            prereq         = 'elevator',
            placementStyle = 'simple',
            yawSymmetry    = 180,
            sling          = { count = 2 },
            hookAttach = {
                offset = vector3(0.0, 0.0, -1.0),
                rot    = vector3(0.0, 0.0, 0.0),
            },
            pickupList = {
                { coords = vector3(73.529, -431.604, 36.704), rot = vector3(0.0, 0.0, -45.0), model = 'tworst_buildjob6mblok' },
                { coords = vector3(72.801, -431.240, 36.704), rot = vector3(0.0, 0.0, -45.0), model = 'tworst_buildjob6mblok' },
                { coords = vector3(72.022, -430.812, 36.704), rot = vector3(0.0, 0.0, -45.0), model = 'tworst_buildjob6mblok' },
                { coords = vector3(74.474, -431.745, 36.704), rot = vector3(0.0, 0.0, -45.0), model = 'tworst_buildjob6mblok' },
            },
        },
        roofWalls = {
            order          = 3,
            labelKey = 'kulestage_3', label          = TL('kulestage_3', 'Stage 3 - Roof walls'),
            sequential     = false,
            prereq         = 'roofPosts',
            placementStyle = 'simple',
            yawSymmetry    = 180,
            hookAttach = {
                offset = vector3(0.0, 0.0, -0.5),
                rot    = vector3(0.0, 0.0, 0.0),
            },
            zstack = true,
            pickupList = {
                { coords = vector3(74.645, -431.453, 38.386), rot = vector3(0.0, 0.0, 0.0), model = 'tworst_buildjob6s' },
                { coords = vector3(74.645, -431.453, 37.875), rot = vector3(0.0, 0.0, 0.0), model = 'tworst_buildjob6s' },
                { coords = vector3(74.645, -431.453, 37.363), rot = vector3(0.0, 0.0, 0.0), model = 'tworst_buildjob6s' },
                { coords = vector3(74.645, -431.453, 36.851), rot = vector3(0.0, 0.0, 0.0), model = 'tworst_buildjob6s' },
            },
        },
        sideWalls = {
            order          = 4,
            labelKey = 'kulestage_4', label          = TL('kulestage_4', 'Stage 4 - Side walls'),
            sequential     = false,
            prereq         = 'roofWalls',
            placementStyle = 'fourPhase',
            yawSymmetry    = 180,
            hookAttach = {
                offset = vector3(0.0, 0.0, -0.4),
                rot    = vector3(0.0, 90.0, 0.0),
            },
            pickup = {
                base            = vector3(77.520, -430.944, 36.620),
                rot             = vector3(20.270, 90.000, 0.000),
                rotOrder        = 0,
                stackCount      = 5,
                stackStep       = vector3(0.000, 0.000, 0.245),
                respawnOnPlaced = true,
                model           = 'tworst_buildjob6wall1',
            },
        },
    },

    purgeProps = {
        { model = 'prop_pipes_02b', coords = vector3(69.858, -431.157, 36.507), radius = 5.0 },
    },

    slots = {
        { stage = 'elevator',  model = 'tworst_buildelvvent',  coords = vector3(34.417, -429.220, 46.953), rot = vector3(0.0, 0.0, 90.0) },
        { stage = 'elevator',  model = 'tworst_buildelvvent2', coords = vector3(35.280, -429.781, 51.313), rot = vector3(0.0, 0.0, 90.0) },
        { stage = 'elevator',  model = 'tworst_buildelvvent',  coords = vector3(34.417, -429.220, 56.657), rot = vector3(0.0, 0.0, 90.0) },
        { stage = 'elevator',  model = 'tworst_buildelvvent2', coords = vector3(35.280, -429.781, 61.018), rot = vector3(0.0, 0.0, 90.0) },
        { stage = 'elevator',  model = 'tworst_buildelvvent',  coords = vector3(34.417, -429.220, 66.370), rot = vector3(0.0, 0.0, 90.0) },

        { stage = 'roofPosts', model = 'tworst_buildjob6mblok', coords = vector3(35.696, -429.880, 72.752), rot = vector3(0.0, 0.0,  89.17) },
        { stage = 'roofPosts', model = 'tworst_buildjob6mblok', coords = vector3(35.447, -430.288, 72.752), rot = vector3(0.0, 0.0,  -1.58) },
        { stage = 'roofPosts', model = 'tworst_buildjob6mblok', coords = vector3(29.659, -445.705, 72.752), rot = vector3(0.0, 0.0,  -1.58) },
        { stage = 'roofPosts', model = 'tworst_buildjob6mblok', coords = vector3(29.908, -445.297, 72.752), rot = vector3(0.0, 0.0,  89.17) },

        { stage = 'roofWalls', model = 'tworst_buildjob6s', coords = vector3(32.841, -446.153, 73.045), rot = vector3(0.0, 0.0,  90.0) },
        { stage = 'roofWalls', model = 'tworst_buildjob6s', coords = vector3(26.496, -445.103, 73.045), rot = vector3(0.0, 0.0, 270.0) },
        { stage = 'roofWalls', model = 'tworst_buildjob6s', coords = vector3(32.054, -429.422, 72.983), rot = vector3(0.0, 0.0, 270.0) },
        { stage = 'roofWalls', model = 'tworst_buildjob6s', coords = vector3(38.400, -430.471, 72.983), rot = vector3(0.0, 0.0,  90.0) },

        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(41.797, -437.722, 60.352), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(43.629, -432.610, 60.352), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(45.479, -427.526, 60.352), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(45.479, -427.526, 55.897), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(43.629, -432.610, 55.897), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(41.797, -437.722, 55.897), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(41.696, -437.685, 46.403), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(43.527, -432.572, 46.403), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(45.378, -427.489, 46.403), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(45.378, -427.489, 50.857), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(43.527, -432.572, 50.857), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(41.696, -437.685, 50.857), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(41.801, -437.724, 70.111), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(43.633, -432.611, 70.111), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(45.483, -427.528, 70.111), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(45.483, -427.528, 65.657), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(43.633, -432.611, 65.657), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(41.801, -437.724, 65.657), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(36.266, -453.027, 65.657), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(38.098, -447.915, 65.657), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(39.948, -442.832, 65.657), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(39.948, -442.832, 70.111), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(38.098, -447.915, 70.111), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(36.266, -453.027, 70.111), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(36.266, -453.027, 60.924), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(38.098, -447.915, 60.924), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(39.948, -442.832, 60.924), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(39.948, -442.832, 56.470), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(38.098, -447.915, 56.470), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(36.266, -453.027, 56.470), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(36.266, -453.027, 46.365), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(38.098, -447.915, 46.365), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(39.948, -442.832, 46.365), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(39.948, -442.832, 50.820), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(38.098, -447.915, 50.820), rot = vector3(0.0, 0.0, 157.292) },
        { stage = 'sideWalls', model = 'tworst_buildjob6wall1', coords = vector3(36.266, -453.027, 50.820), rot = vector3(0.0, 0.0, 157.292) },
    },

    grabRange  = 5.0,
    placeRange = 7.0,

    hookAttach = {
        offset = vector3(0.0, 0.0, -0.4),
        rot    = vector3(0.000, 90.000, 0.000),
    },

    placementStyle = 'fourPhase',

    staticFurniture = {
        { model = 'tworst_buildjob6frame', coords = vector3(40.992, -438.613, 59.696), rot = vector3(0.0, 0.0, 0.0) },
    },
}

Config.TowerCraneJobs = Config.TowerCraneJobs or {}
CreateThread(function()
    Wait(0)
    for _, val in pairs(Config) do
        if type(val) == 'table'
            and type(val.instanceId) == 'string'
            and type(val.slots) == 'table'
            and (type(val.pickup) == 'table' or type(val.stages) == 'table') then
            Config.TowerCraneJobs[val.instanceId] = val
        end
    end
end)
