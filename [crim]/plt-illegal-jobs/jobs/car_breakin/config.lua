---@type Job
return {
    level = 1,
    label = locale('car_breakin.label'),
    description = locale('car_breakin.description'),
    image = 'car_breakin.png',
    reward = { exp = 90, money = 3200 },
    cooldown = { enabled = true, minutes = 8 },
    information = locale('car_breakin.information'),
    teamSize = { min = 1, max = 4 },
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    steps = {
        { label = locale('car_breakin.steps.1'), progress = { target = 4 } },
        { label = locale('car_breakin.steps.2') },
    },
    blips = {
        hotspot = { sprite = 161, color = 5, text = locale('car_breakin.blips.hotspot') or 'Break-in zone' },
        target = { sprite = 225, color = 5, text = locale('car_breakin.blips.target') or 'Target car' },
    },
    game = {
        interact_distance = 2.4,
        heading_tolerance = 55.0,
        alarm_chance = 0.35,
        police_alert_chance = 0.45,
        cooldown_ms = 10000,
        duration_ms = 12 * 60 * 1000,
        -- How many mission cars to spawn (should be >= step target)
        spawn_count =4 ,
        vehicle_models = {
            `blista`, `asea`, `premier`, `ingot`, `emperor`,
            `primo`, `stanier`, `stratum`, `intruder`, `asterope`,
        },
        -- Soft search areas + explicit parking slots (vector4 x,y,z,heading)
        hotspots = {
            {
                center = vec3(15.08, -1067.95, 38.15),
                radius = 90.0,
                spawns = {
                    vec4(38.72, -1077.17, 37.55, 247.98),
                    vec4(48.69, -1053.84, 37.55, 252.19),
                    vec4(-4.87, -1043.37, 37.55, 66.2),
                    vec4(-13.42, -1067.96, 37.55, 69.29),
                },
            },
            {
                center = vec3(423.51, -1335.64, 45.42),
                radius = 80.0,
                spawns = {
                    vec4(456.35, -1362.92, 42.95, 49.91),
                    vec4(382.33, -1301.11, 42.95, 46.78),
                    vec4(413.9, -1335.81, 40.45, 142.94),
                    vec4(382.28, -1300.97, 37.95, 48.84),
                },
            },
            {
                center = vec3(-514.18, 52.41, 51.97),
                radius = 90.0,
                spawns = {
                    vec4(-495.79, 50.84, 51.97, 266.12),
                    vec4(-494.29, 67.09, 51.97, 266.88),
                    vec4(-536.03, 47.85, 51.97, 91.93),
                    vec4(-496.79, 67.83, 55.89, 0.06),
                },
            },
            {
                center = vec3(-1686.38, -900.28, 7.61),
                radius = 85.0,
                spawns = {
                    vec4(-1686.14, -919.23, 7.2, 139.69),
                    vec4(-1706.6, -901.72, 7.2, 139.69),
                    vec4(-1689.92, -871.66, 7.98, 320.06),
                    vec4(-1629.01, -897.98, 8.33, 139.69),
                },
            },
        },
        loot = {
            { itemName = 'phone', chance = 0.35, min = 1, max = 1 },
            { itemName = 'radio', chance = 0.20, min = 1, max = 1 },
            { itemName = 'black_money', chance = 0.55, min = 40, max = 220 },
        },
        banned_models = {
            [`stockade`] = true,
            [`police`] = true,
            [`police2`] = true,
            [`police3`] = true,
            [`riot`] = true,
        },
    },
    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `g_m_y_mexgoon_01`,
        coords   = vec4(-471.13, -1718.75, 18.69, 284.8),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'car_breakin.mp3',
        line     = 'One window, one grab, and you\'re a ghost.',
    },
}
