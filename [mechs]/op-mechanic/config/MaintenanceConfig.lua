Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Vehicle maintenance (wear + service)
-- ──────────────────────────────────────────────────────────────────────────────
Config.Maintenance = {
    enabled = true,

    attentionBelow = 30, -- tablet warning threshold (%)

    syncMs = 12000, -- mileage batch sync interval
    scanDistance = 6.0,
    serviceInteractDistance = 2.25,
    undercarriageClearance = 1.15,

    requireSeated = true, -- OBD scan
    obdScanMs = 3200,

    odometerUnit = 'km', -- km | mi

    requireTools = false,
    requireParts = nil, -- nil = Config.Parts.requireParts

    serviceDurationMs = 6500,
    serviceAnim = {
        dict = 'mini@repair',
        clip = 'fixing_a_ped',
        flag = 1,
    },

    progressBar = {
        enabled = true,
        durationMs = 4000,
        usePartDuration = false,
        style = 'circle', -- circle | bar
        canCancel = true,
    },

    immuneModels = {
        -- 'police',
    },

    electricModels = {
        'cyclone',
        'voltic',
        'raiden',
        'iwagen',
        'neon',
        'omnisegt',
        'virtue',
        'pipistrello',
        'caddy',
        'caddy2',
        'caddy3',
        'airtug',
        'khamelion',
        'dilettante',
        'dilettante2',
        'surge',
        'tezeract',
        'imorgon',
    },

    components = {
        {
            id = 'oil',
            powertrain = 'ice', -- any | ice | ev
            lifespanKm = 100,
            item = 'engine_oil',
            amount = 1,
            ui = { side = 'right', anchor = 'front' },
            penalties = { driveForce = 0.28, topSpeed = 0.12 },
            service = {
                point = 'front',
                openHood = true,
                durationMs = 7000,
                minigame = 'fluid',
                minigameVariant = 'oil',
                anim = {
                    dict = 'weapons@misc@jerrycan@',
                    clip = 'fire',
                    flag = 1,
                },
                prop = {
                    model = 'prop_oiltub_04',
                    bone = 57005,
                    offset = vector3(0.18, 0.13, -0.24),
                    rot = vector3(-165.0, -11.0, -33.0),
                },
            },
        },
        {
            id = 'clutch',
            powertrain = 'ice',
            lifespanKm = 500,
            item = 'clutch_kit',
            amount = 1,
            ui = { side = 'right', anchor = 'mid' },
            penalties = { driveForce = 0.22, clutch = 0.35 },
            service = {
                point = 'under_vehicle',
                openHood = false,
                durationMs = 8000,
                minigame = 'gearbox',
                anim = {
                    dict = 'amb@prop_human_movie_bulb@idle_a',
                    clip = 'idle_b',
                    flag = 1,
                },
            },
        },
        {
            id = 'air_filter',
            powertrain = 'ice',
            lifespanKm = 250,
            item = 'air_filter',
            amount = 1,
            ui = { side = 'right', anchor = 'front' },
            penalties = { driveForce = 0.14, topSpeed = 0.08 },
            service = {
                point = 'engine',
                openHood = true,
                durationMs = 5500,
                minigame = 'airfilter',
            },
        },
        {
            id = 'spark_plugs',
            powertrain = 'ice',
            lifespanKm = 150,
            item = 'spark_plugs',
            amount = 4,
            ui = { side = 'right', anchor = 'front' },
            penalties = { driveForce = 0.18, topSpeed = 0.1 },
            service = {
                point = 'engine',
                openHood = true,
                durationMs = 6000,
                minigame = 'sparkplugs',
            },
        },
        {
            id = 'alternator',
            powertrain = 'ice',
            lifespanKm = 2000,
            item = 'alternator',
            amount = 1,
            ui = { side = 'right', anchor = 'front' },
            penalties = { driveForce = 0.1, topSpeed = 0.06 },
            service = {
                point = 'engine',
                openHood = true,
                durationMs = 7500,
                minigame = 'wire',
            },
            failure = {
                baseChancePerKm = 0.00008,
                wearMultiplier = 18.0,
                effects = {
                    lightsFlicker = true,
                    engineStall = true,
                    stallChancePerSec = 0.035,
                    flickerMinMs = 280,
                    flickerMaxMs = 1600,
                },
            },
        },
        {
            id = 'brake_pads',
            powertrain = 'any',
            lifespanKm = 500,
            item = 'brake_pads',
            amount = 4,
            ui = { side = 'right', anchor = 'rear' },
            penalties = { brakeForce = 0.45 },
            service = {
                points = {
                    'front_left_wheel',
                    'front_right_wheel',
                    'rear_left_wheel',
                    'rear_right_wheel',
                },
                openHood = false,
                durationMs = 6500,
                minigame = 'brakes',
                anim = {
                    dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                    clip = 'machinic_loop_mechandplayer',
                    flag = 1,
                },
            },
        },
        {
            id = 'suspension',
            powertrain = 'any',
            lifespanKm = 1000,
            item = 'service_suspension',
            amount = 1,
            ui = { side = 'left', anchor = 'front' },
            penalties = { traction = 0.18 },
            service = {
                points = {
                    'front_left_wheel',
                    'front_right_wheel',
                    'rear_left_wheel',
                    'rear_right_wheel',
                },
                openHood = false,
                durationMs = 7000,
                minigame = 'align',
                anim = {
                    dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                    clip = 'machinic_loop_mechandplayer',
                    flag = 1,
                },
            },
        },
        {
            id = 'tyres',
            powertrain = 'any',
            lifespanKm = 250,
            item = 'tyre_set',
            amount = 4,
            ui = { side = 'left', anchor = 'rear' },
            penalties = { traction = 0.4, brakeForce = 0.12 },
            service = {
                points = {
                    'front_left_wheel',
                    'front_right_wheel',
                    'rear_left_wheel',
                    'rear_right_wheel',
                },
                openHood = false,
                durationMs = 6500,
                minigame = 'lugs',
                anim = {
                    dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                    clip = 'machinic_loop_mechandplayer',
                    flag = 1,
                },
            },
        },

        {
            id = 'ev_motor',
            powertrain = 'ev',
            lifespanKm = 2000,
            item = 'ev_motor',
            amount = 1,
            ui = { side = 'right', anchor = 'mid' },
            penalties = { driveForce = 0.3, topSpeed = 0.15 },
            service = {
                point = 'engine',
                openHood = true,
                durationMs = 8000,
                minigame = 'engine',
            },
        },
        {
            id = 'ev_battery',
            powertrain = 'ev',
            lifespanKm = 500,
            item = 'ev_battery',
            amount = 1,
            ui = { side = 'right', anchor = 'front' },
            penalties = { driveForce = 0.25, topSpeed = 0.2 },
            service = {
                point = 'engine',
                openHood = true,
                durationMs = 8000,
                minigame = 'wire',
            },
        },
        {
            id = 'ev_coolant',
            powertrain = 'ev',
            lifespanKm = 250,
            item = 'ev_coolant',
            amount = 1,
            ui = { side = 'right', anchor = 'front' },
            penalties = { driveForce = 0.12, topSpeed = 0.08 },
            service = {
                point = 'engine',
                openHood = true,
                durationMs = 6500,
                minigame = 'fluid',
                minigameVariant = 'coolant',
                anim = {
                    dict = 'weapons@misc@jerrycan@',
                    clip = 'fire',
                    flag = 1,
                },
                prop = {
                    model = 'prop_oiltub_04',
                    bone = 57005,
                    offset = vector3(0.18, 0.13, -0.24),
                    rot = vector3(-165.0, -11.0, -33.0),
                },
            },
        },
    },
}