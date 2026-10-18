---@type Job
return {
    level = 5,
    label = locale('heli_cargo.label'),
    description = locale('heli_cargo.description'),
    image = 'heli_cargo.png',
    reward = { exp = 320, money = 32000 },
    cooldown = { enabled = true, minutes = 30 },
    information = locale('heli_cargo.information'),
    teamSize = { min = 1, max = 2 },
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    requiredItems = {
        lockpick = { itemName = 'lockpick', label = 'Lockpick' },
    },
    steps = {
        { label = locale('heli_cargo.steps.1'), timeLimit = 600 },
        { label = locale('heli_cargo.steps.2'), timeLimit = 600 },
        { label = locale('heli_cargo.steps.3'), timeLimit = 900 },
        { label = locale('heli_cargo.steps.4'), timeLimit = 600 },
    },
    blips = {
        heli = { sprite = 43, color = 5, text = locale('heli_cargo.blips.heli') },
        vehicle = { sprite = 225, color = 1, text = locale('heli_cargo.blips.vehicle') },
        dropoff = { sprite = 50, color = 2, text = locale('heli_cargo.blips.dropoff') },
    },
    game = {
        police_alert_chance = 0.30,
        heli_model = 'cargobob',
        vehicle_models = { 'sultan', 'buffalo', 'dominator', 'baller' },
        drop_height_max = 8.0,
        heli_spawns = {
            vector4(-745.42, -1468.88, 5.00, 140.0),
            vector4(1770.12, 3239.88, 42.12, 100.0),
            vector4(-1145.88, -2864.42, 13.95, 150.0),
        },
        vehicle_spawns = {
            vec4(209.1, -793.3, 30.34, 249.33),
            vec4(-330.01, -756.13, 52.64, 34.7),
            vec4(1143.29, -3271.92, 5.29, 90.81),
            vec4(-464.65, -768.86, 44.41, 267.23),
            vec4(1538.76, 3540.35, 34.76, 29.4),
        },
        dropoffs = {
            vec4(2136.27, 4808.33, 40.48, 294.49),
            vec4(1541.25, -2095.63, 76.54, 202.67),
            vec4(-1681.5, -766.78, 9.58, 230.34),
        },
    },
    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `s_m_y_pilot_01`,
        coords   = vec4(-829.99, -1255.39, 6.58, 137.95),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'heli_cargo.mp3',
        line     = 'Hook it, haul it, don\'t look down.',
    },
}
