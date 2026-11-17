-- Training mode: the practice field and the module definitions.

Config = Config or {}

Config.TutorialEnabled = true

Config.TutorialPolicy = 'suggest'

Config.TutorialByJobType = {
    plank          = { 'cranev2', 'pumpv2' },
    kulestone      = { 'tower' },
    pipe           = { 'cranev2' },
    waterfacility  = { 'pumpv2', 'cranev2' },
    waterfacility2 = { 'cranev2', 'tower' },
    job8           = { 'cranev2' },
    job12          = { 'cranev2' },
}

local G = vector3(1770.0, 3255.0, 41.0)

Config.Tutorial = {
    bucketBase = 60000,

    field = {
        center      = G,
        playerSpawn = vector4(G.x + 11.0, G.y, G.z, 90.0),
        machineSpawn = vector4(G.x + 8.0, G.y, G.z, 0.0),
    },

    leashRadius = 250.0,

    minModuleSeconds = 45,

    xp = { cranev2 = 25, pumpv2 = 25, tower = 25 },

    medals = { gold = 90, silver = 180 },

    marker = {
        height = 2.6,
        scale  = 1.0,
        color  = { r = 255, g = 180, b = 40, a = 180 },
    },

    tower = {
        placesRequired = 1,
    },

    xox = {
        origin = vector3(G.x + 8.0, G.y + 14.0, G.z),
    },

    cranePipe = {
        model  = 'tworst_buildpipe',
        pile   = vector4(G.x + 16.0, G.y + 8.0, G.z, 0.0),
        target = vector4(G.x,        G.y + 8.0, G.z, 0.0),
        aimTarget = vector3(G.x,     G.y + 8.0, G.z),
    },
    pumpTarget = vector3(G.x + 16.0, G.y - 8.0, G.z),
}

local R2_TOWER  = vector3(948.8231, 2409.428, 76.28338)
local R2_STAND  = vector3(946.56, 2413.73, 51.45)

Config.TutorialTowerInstance = {
    model     = 'tworst_buildingcrane',
    coords    = R2_TOWER,
    heading   = -150.0,
    safeStand = R2_STAND,
}

Config.TutorialTowerJob = {
    instanceId = 'tutorial',

    model = 'tworst_buildstonebricko',

    pickup = {
        base            = vector3(971.768, 2413.770, 51.345),
        rot             = vector3(90.000, -54.982, -90.000),
        rotOrder        = 0,
        stackCount      = 5,
        stackStep       = vector3(0.000, 0.020, 0.795),
        respawnOnPlaced = true,
    },

    slots = {
        { coords = vector3(918.795, 2429.740, 54.710), rot = vector3(0.00, 0.00, 16.72) },
    },

    grabRange  = 5.0,
    placeRange = 7.0,

    hookAttach = {
        offset = vector3(0.0, 0.0, -0.4),
        rot    = vector3(0.0, 0.0, 0.0),
    },

    placementStyle = 'simple',
}
