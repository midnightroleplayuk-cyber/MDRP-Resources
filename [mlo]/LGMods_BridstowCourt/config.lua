Config = {}

-- =======================================================
--  General
-- =======================================================

Config.debug    = false   -- Console logging + /bridstow_debug, /bridstow_sets and /bridstow_plaques

-- =======================================================
--  Building / floors
-- =======================================================

Config.iplPrefix = 'lgmods_bridstowcourts_floor_'
Config.minFloor  = 0
Config.maxFloor  = 19

Config.building = {
    x = -288.982,
    y = -1629.618,
    room = 'foyer',
}

Config.buildingRadius = 30.0
Config.unloadRadius   = 60.0

Config.floors = {
    [0]  = { z = 31.44,  ref = vector3(-290.25, -1627.69, 32.34)  },
    [1]  = { z = 35.19,  ref = vector3(-289.39, -1628.80, 36.11)  },
    [2]  = { z = 38.94,  ref = vector3(-290.16, -1629.13, 39.86)  },
    [3]  = { z = 42.69,  ref = vector3(-289.95, -1629.15, 43.61)  },
    [4]  = { z = 46.44,  ref = vector3(-291.48, -1628.67, 47.36)  },
    [5]  = { z = 50.19,  ref = vector3(-291.15, -1629.55, 51.11)  },
    [6]  = { z = 53.94,  ref = vector3(-291.03, -1629.53, 54.88)  },
    [7]  = { z = 57.69,  ref = vector3(-291.10, -1629.30, 58.61)  },
    [8]  = { z = 61.44,  ref = vector3(-289.94, -1629.50, 62.36)  },
    [9]  = { z = 65.19,  ref = vector3(-290.21, -1629.25, 66.11)  },
    [10] = { z = 68.94,  ref = vector3(-289.09, -1629.43, 69.86)  },
    [11] = { z = 72.69,  ref = vector3(-290.07, -1629.26, 73.61)  },
    [12] = { z = 76.44,  ref = vector3(-289.86, -1628.80, 77.36)  },
    [13] = { z = 80.19,  ref = vector3(-290.16, -1629.11, 81.11)  },
    [14] = { z = 83.94,  ref = vector3(-290.58, -1629.68, 84.86)  },
    [15] = { z = 87.69,  ref = vector3(-290.40, -1629.17, 88.61)  },
    [16] = { z = 91.44,  ref = vector3(-290.60, -1629.26, 92.36)  },
    [17] = { z = 95.19,  ref = vector3(-289.86, -1628.83, 96.11)  },
    [18] = { z = 98.94,  ref = vector3(-292.34, -1628.78, 99.86)  },
    [19] = { z = 102.69, ref = vector3(-290.75, -1629.43, 103.61) },
}

Config.layouts = {
    gf = {
        archetype = 2118847047, -- lgmods_bridstowcourts_shellgfcol
        flats = {
            { room = 'room', set = 'gf_furniture',
              door = vector3(0.3853, -6.5734, -0.5877), plaque = vector3(0.705, -6.37, -0.42), face = vector3(0.0, 1.0, 0.0) },
        },
    },
    main = {
        archetype = 2688410579, -- lgmods_bridstowcourts_shellcol
        legacy = 'main_furniture',
        flats = {
            { room = 'room_1', set = 'main_room1_furniture',
              door = vector3(0.4167, -5.8245, -0.5877), plaque = vector3(0.736, -5.68, -0.42), face = vector3(0.0, 1.0, 0.0) },
            { room = 'room_2', set = 'main_room2_furniture',
              door = vector3(-4.8604, -1.3019, -0.5877), plaque = vector3(-4.714, -1.62, -0.42), face = vector3(1.0, 0.0, 0.0) },
            { room = 'room_3', set = 'main_room3_furniture',
              door = vector3(4.2297, 0.1981, -0.5877), plaque = vector3(4.083, 0.52, -0.42), face = vector3(-1.0, 0.0, 0.0) },
        },
    },
    tp = {
        archetype = 915664316, -- lgmods_bridstowcourts_shelltpcol
        legacy = 'tp_furniture',
        flats = {
            { room = 'room_1', set = 'tp_room1_furniture',
              door = vector3(0.4167, -5.8245, -0.5877), plaque = vector3(0.736, -5.68, -0.42), face = vector3(0.0, 1.0, 0.0) },
            { room = 'room_2', set = 'tp_room2_furniture',
              door = vector3(-4.8604, -1.3019, -0.5877), plaque = vector3(-4.714, -1.62, -0.42), face = vector3(1.0, 0.0, 0.0) },
            { room = 'room_3', set = 'tp_room3_furniture',
              door = vector3(4.2297, 0.1981, -0.5877), plaque = vector3(4.083, 0.52, -0.42), face = vector3(-1.0, 0.0, 0.0) },
        },
    },
}

function Config.LayoutForFloor(floor)
    if floor == 0 then return 'gf' end
    if floor == 19 then return 'tp' end
    return 'main'
end

-- =======================================================
--  Furniture
-- =======================================================

Config.furniture = {
    default = false,              -- State for any flat nobody has changed
    command = 'flatfurniture',    -- /flatfurniture [on|off|toggle] [flat|all]
    ace     = 'bridstow.furniture', -- ACE needed to use it (false = everyone)
}

-- =======================================================
--  Flat numbers (3D text)
-- =======================================================

Config.plaques = {
    enabled      = true,
    format       = '%s',          -- e.g. 'Flat %s'
    drawDistance = 6.0,
    scale        = 0.5,
    font         = 4,
    colour       = { 240, 240, 235, 235 },
    doorModel    = 'lgmods_bridstowcourts_frontdoor',
    rotation     = 'auto',        -- 'auto', 'inverse' or 'normal' (how the MLO rotation is applied)
}
