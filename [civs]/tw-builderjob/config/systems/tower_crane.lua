-- ====================================================================
-- TOWER CRANE
-- ====================================================================
-- Tower instances (position, height, reach), the cabin seating pose and the
-- hook/rope tuning. Each instance is bound through its own zoneId.
-- ====================================================================

Config = Config or {}

Config.TowerCrane = {

    autoSitOnStart = false,

    rescueRadius    = 80.0,
    rescueMinHeight = 4.0,
    rescueFootprint = 15.0,

    proofOfWork = {
        enabled      = true,
        snapMaxAgeMs = 3000,
        placePad     = 10.0,
    },

    -- ownerJob says which region each crane belongs to. Without it the scene
    -- layer cannot tell whether that region was switched off, and the crane
    -- kept standing on a disabled site.
    instances = {
        main = {
            model   = 'tworst_buildingcrane',
            coords  = vector3(948.8231, 2409.428, 76.28338),
            heading = -150.0,
            safeStand = vector3(946.56, 2413.73, 51.45),
            ownerJob  = { jobType = 'kulestone', instanceId = 'main' },
        },
        site2 = {
            model   = 'tworst_buildingcrane',
            coords  = vector3(47.2203445, -460.506836, 94.74577),
            heading = -150.0,
            safeStand = vector3(47.74, -455.52, 40.18),
            ownerJob  = { jobType = 'kulestone', instanceId = 'site2' },
        },
        wf2_t1 = {
            model   = 'tworst_buildingcrane',
            coords  = vector3(1051.16479, 2280.44824, 74.52749),
            heading = -150.0,
            safeStand = vector3(1048.90, 2284.74, 49.69),
            ownerJob  = { jobType = 'waterfacility2' },
        },
    },

    defaultInstance = 'main',

    chain = [[
        { name='trolley', model='tworst_buildingcrane2', parent=0, bone=nil, offset=vector3(0.300, -10.300, 3.900), rotation=vector3(0.00, 0.00, 0.00) },
        { name='hook',    model='tworst_buildingcrane3', parent=1, bone=nil, offset=vector3(-0.350, -0.050, -8.000), rotation=vector3(0.00, 0.00, 0.00) },
    ]],

    trolley = {
        nodeIdx = 1,
        axis    = 'y',
        min     = -59.500,
        max     = -3.000,
        speed   = 0.0683,
    },

    hook = {
        nodeIdx = 2,
        axis    = 'z',
        min     = -100.000,
        max     = -8.000,
        speed   = 0.048,
    },

    rotate = {
        speed = 0.24,
    },

    anim = {
        descendSpeed = 6.0,
        descendMin   = 450,
        descendMax   = 1600,
        liftDur      = 1900,
        autoLift     = 800,
        autoLiftRise = 2.5,
        placeSimple    = 1000,
        placeFourPhase = 2600,
        elevPhase1     = 700,
        elevPhase2     = 1000,
    },

    slowFactor = 0.25,

    smoothTime     = 0.30,
    limitLerpRange = 4.0,

    accelTime      = 0.45,
    decelTime      = 0.30,

    tipMaxSpeed    = 6.25,

    hookPhysics = {
        spring        = 60.0,
        damping       = 9.0,
        springLoaded  = 45.0,
        dampingLoaded = 12.8,
    },
}

local SQ = 0.015
Config.TowerCraneRopes = {
    { endA = vector3(-0.350 + SQ, -0.050 + SQ, 0.0), endB = vector3( SQ,  SQ, 0.0) },
    { endA = vector3(-0.350 - SQ, -0.050 + SQ, 0.0), endB = vector3(-SQ,  SQ, 0.0) },
    { endA = vector3(-0.350 + SQ, -0.050 - SQ, 0.0), endB = vector3( SQ, -SQ, 0.0) },
    { endA = vector3(-0.350 - SQ, -0.050 - SQ, 0.0), endB = vector3(-SQ, -SQ, 0.0) },
}

Config.TowerCraneScenery = {
    enabled        = true,
    checkInterval  = 1500,
}

Config.TowerCraneCabin = {

    offset    = vector3(-1.988, -2.800, 1.695),
    heading   = 189.92,

    driveSync = true,
    anchorModel = 'prop_cs_cardbox_01',

    animDict  = "amb@prop_human_seat_chair@male@base",
    animClip  = "base",

    camOperator    = { attachTo = 'ped',     offset = vector3(0.0, -3.5,  1.8),  lookAt = vector3(0.0,  12.0, -2.0), fov = 55.0 },
    camShowcase    = { attachTo = 'ped',     offset = vector3(0.0, -30.0, 18.0), lookAt = vector3(0.0,   2.0,  0.6), fov = 45.0 },
    camFirstPerson = { attachTo = 'ped',     offset = vector3(0.0,  0.30, 0.0),                                     fov = 60.0 },

    camOffset = vector3(0.0, -3.5, 1.8),
    camFov    = 55.0,
}
Config.TowerCrane.teleport = {
    enabled  = true,

    instances = { main = true, site2 = true, wf2_t1 = true },

    topOffset = vector3(-2.188, -3.4, 1.695),

    exitBack = 1.2,
    exitUp   = -0.3,

    enterRadius = 3.5,

    promptDistanceGround = 3.0,
    promptDistanceTop    = 3.5,
    fadeMs               = 400,
}
