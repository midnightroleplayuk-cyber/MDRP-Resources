---@type Job
return {
    level = 3,
    label = locale('safehouse_defense.label'),
    description = locale('safehouse_defense.description'),
    image = 'safehouse_defense.png',
    reward = { exp = 240, money = 18000 },
    cooldown = { enabled = true, minutes = 20 },
    information = locale('safehouse_defense.information'),
    teamSize = { min = 1, max = 4 },
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    steps = {
        { label = locale('safehouse_defense.steps.1'), timeLimit = 120 },
        { label = locale('safehouse_defense.steps.2'), timeLimit = 90 },
        { label = locale('safehouse_defense.steps.3'), timeLimit = 300, progress = { target = 3 } },
        { label = locale('safehouse_defense.steps.4'), timeLimit = 60 },
    },
    blips = {
        safehouse = { sprite = 40, color = 1, text = locale('safehouse_defense.blips.safehouse') },
    },
    game = {
        --[[ EDITABLE LOCATIONS ]]
        safehouses = {
            {
                center = vector3(2435.12, 4968.88, 42.35), -- TODO: stash / safehouse
                prepare_radius = 25.0,
                integrity_max = 100,
                -- Damage applied when attackers reach the center unchecked (simplified)
                breach_proximity = 8.0,
                wave_spawns = {
                    -- Wave 1
                    {
                        vector4(2410.12, 4985.44, 45.0, 200.0), -- TODO
                        vector4(2455.88, 4988.22, 45.0, 220.0), -- TODO
                        vector4(2420.44, 4945.12, 44.0, 10.0),  -- TODO
                    },
                    -- Wave 2
                    {
                        vector4(2405.12, 4970.44, 45.0, 180.0), -- TODO
                        vector4(2460.88, 4960.22, 45.0, 270.0), -- TODO
                        vector4(2430.44, 4995.12, 45.0, 200.0), -- TODO
                        vector4(2448.12, 4940.88, 44.0, 0.0),   -- TODO
                    },
                    -- Wave 3
                    {
                        vector4(2412.12, 4990.44, 45.0, 200.0), -- TODO
                        vector4(2458.88, 4992.22, 45.0, 220.0), -- TODO
                        vector4(2415.44, 4948.12, 44.0, 10.0),  -- TODO
                        vector4(2465.12, 4955.88, 45.0, 280.0), -- TODO
                        vector4(2435.88, 5005.22, 45.0, 180.0), -- TODO
                    },
                },
            },
            {
                center = vector3(1391.42, 3608.88, 34.98), -- TODO
                prepare_radius = 20.0,
                integrity_max = 100,
                breach_proximity = 8.0,
                wave_spawns = {
                    {
                        vector4(1375.12, 3625.44, 34.89, 200.0), -- TODO
                        vector4(1408.88, 3595.22, 34.89, 40.0),  -- TODO
                    },
                    {
                        vector4(1370.12, 3610.44, 34.89, 180.0), -- TODO
                        vector4(1412.88, 3618.22, 34.89, 220.0), -- TODO
                        vector4(1385.44, 3588.12, 34.89, 10.0),  -- TODO
                    },
                    {
                        vector4(1368.12, 3628.44, 34.89, 200.0), -- TODO
                        vector4(1415.88, 3590.22, 34.89, 40.0),  -- TODO
                        vector4(1378.44, 3585.12, 34.89, 10.0),  -- TODO
                        vector4(1400.12, 3635.88, 34.89, 180.0), -- TODO
                    },
                },
            },
        },
        --[[ TUNING ]]
        prepare_lead_ms = 45000,
        wave_interval_ms = 45000,
        hold_duration_ms = 150000,
        attacker_model = 'g_m_y_ballaeast_01',
        attacker_weapon = `WEAPON_MICROSMG`,
        integrity_damage_per_tick = 4,
        integrity_tick_ms = 2000,
        police_alert_chance = 0.25,
    },
    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `g_m_y_lost_01`,
        coords   = vec4(2889.57, 4391.41, 50.45, 294.9),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'safehouse_defense.mp3',
        line     = 'They know where we sleep tonight — hold the line.',
    },
}
