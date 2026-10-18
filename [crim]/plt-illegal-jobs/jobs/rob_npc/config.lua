---@type Job
return {
    level = 1,
    label = locale('rob_npc.label'),
    description = locale('rob_npc.description'),
    image = 'rob_npc.png',
    reward = { exp = 80, money = 2500 },
    cooldown = { enabled = true, minutes = 6 },
    information = locale('rob_npc.information'),
    teamSize = { min = 1, max = 1 },
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    steps = {
        { label = locale('rob_npc.steps.1'), progress = { target = 5 } },
        { label = locale('rob_npc.steps.2') },
    },
    blips = {
        hotspot = { sprite = 161, color = 1, text = locale('rob_npc.blips.hotspot') or 'Robbery zone' },
        target = { sprite = 480, color = 1, text = locale('rob_npc.blips.target') or 'Soft target' },
    },
    game = {
        interact_distance = 2.2,
        aim_distance = 12.0,
        gunpoint_hold_ms = 900,
        witness_radius = 18.0,
        -- Chance the mark bottles you instead of handing over cash
        resist_chance_base = 0.28,
        resist_chance_per_witness = 0.10,
        police_alert_chance = 0.40,
        call_police_on_resist = 0.65,
        payout_min = 80,
        payout_max = 420,
        cooldown_ms = 8000,
        duration_ms = 12 * 60 * 1000,
        -- How many mission NPCs to plant (should be >= step target)
        spawn_count = 5,
        ped_models = {
            `a_m_m_beach_01`,
            `a_m_m_bevhills_01`,
            `a_m_m_business_01`,
            `a_m_y_hipster_01`,
            `a_f_y_hipster_01`,
            `a_f_y_business_02`,
            `a_m_y_stlat_01`,
            `a_f_m_tourist_01`,
        },
        hotspots = {
            {
                center = vec3(296.37, 189.15, 104.24),
                radius = 70.0,
                spawns = {
                    vec4(288.03, 136.51, 104.3, 332.54),
                    vec4(270.33, 137.63, 104.14, 65.94),
                    vec4(259.81, 154.12, 104.68, 263.19),
                    vec4(259.28, 190.78, 104.9, 205.6),
                    vec4(284.9, 191.38, 104.41, 138.04),
                },
            },
            {
                center = vec3(-1038.05, -2737.08, 20.17),
                radius = 80.0,
                spawns = {
                    vec4(-1055.71, -2721.94, 20.17, 338.48),
                    vec4(-1024.86, -2707.62, 20.17, 32.65),
                    vec4(-1003.29, -2733.44, 20.17, 118.9),
                    vec4(-1028.44, -2765.31, 20.32, 205.7),
                    vec4(-1040.2, -2758.1, 20.2, 120.0),
                },
            },
            {
                center = vec3(926.93, 54.4, 81.1),
                radius = 75.0,
                spawns = {
                    vec4(915.7, 34.39, 80.81, 58.32),
                    vec4(896.0, -1.69, 78.9, 164.45),
                    vec4(995.13, 71.41, 80.99, 257.75),
                    vec4(964.37, 79.35, 81.01, 64.72),
                    vec4(932.5, 62.21, 80.26, 57.65),
                },
            },
            {
                center = vec3(141.79, -1299.52, 29.19),
                radius = 70.0,
                spawns = {
                    vec4(165.75, -1305.35, 29.35, 66.57),
                    vec4(139.49, -1283.34, 29.36, 310.17),
                    vec4(126.47, -1267.78, 29.34, 211.58),
                    vec4(85.72, -1287.89, 29.3, 29.88),
                    vec4(98.58, -1308.71, 29.28, 121.64),
                },
            },
        },
        banned_models = {
            [`s_m_y_cop_01`] = true,
            [`s_f_y_cop_01`] = true,
            [`s_m_y_sheriff_01`] = true,
            [`s_m_m_armoured_01`] = true,
            [`s_m_m_armoured_02`] = true,
        },
    },
    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `g_m_y_famfor_01`,
        coords   = vec4(118.09, -1768.09, 29.34, 324.06),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'rob_npc.mp3',
        line     = 'Fast, quiet, gone — that\'s the only way this works.',
    },
}
