Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Engine / gearbox hoist
-- ──────────────────────────────────────────────────────────────────────────────
Config.EngineHoist = {
    enabled = true,
    hoistModel = 'prop_engine_hoist',
    hoistModelFallbacks = {
        'xs_prop_x18_engine_hoist_02a',
        'ba_dlc_ba_int2_engine_hoist',
    },
    engineModel = 'prop_car_engine_01',
    engineModelFallbacks = {},
    gearboxModel = 'imp_prop_impexp_gearbox_01',
    gearboxModelFallbacks = {},

    collision = false,
    spawnAtPlayer = true,

    cargoOffset = vector3(0.0, -1.35, 1.48),
    cargoRot = vector3(0.0, 0.0, 90.0),

    cargoAttachByHoist = {
        prop_engine_hoist = {
            offset = vector3(0.0, -1.35, 1.48),
            rot = vector3(0.0, 0.0, 90.0),
        },
        xs_prop_x18_engine_hoist_02a = {
            offset = vector3(0.0, -1.20, 1.55),
            rot = vector3(0.0, 0.0, 90.0),
        },
        ba_dlc_ba_int2_engine_hoist = {
            offset = vector3(0.0, -1.15, 1.45),
            rot = vector3(0.0, 0.0, 90.0),
        },
    },

    cargoAttachByModel = {
        prop_car_engine_01 = {
            offset = vector3(0.0, -1.35, 1.48),
            rot = vector3(0.0, 0.0, 90.0),
        },
        imp_prop_impexp_gearbox_01 = {
            offset = vector3(0.0, -1.30, 1.58),
            rot = vector3(0.0, 0.0, 90.0),
        },
    },

    pushOffset = vector3(0.0, 1.55, -0.95),
    headingOffset = 180.0,

    placeDistance = 3.2,

    bayForward = 1.9,
    bayRear = -1.9,
    bayZ = -0.15,

    placeForward = 3.55,
    placeRear = -3.55,

    rearEngineDot = -0.35,

    placeControl = 191,
    cancelControl = 194,
}