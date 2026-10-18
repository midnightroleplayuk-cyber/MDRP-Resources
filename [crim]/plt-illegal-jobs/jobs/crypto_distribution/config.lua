---@type Job
return {
    level = 3,
    label = locale('crypto_distribution.label'),
    description = locale('crypto_distribution.description'),
    image = 'crypto_distribution.png',
    reward = { exp = 200, money = 16000 },
    cooldown = { enabled = true, minutes = 15 },
    information = locale('crypto_distribution.information'),
    teamSize = { min = 1, max = 2 },
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    requiredItems = {
        lockpick = { itemName = 'lockpick', label = 'Lockpick' },
    },
    steps = {
        { label = locale('crypto_distribution.steps.1'), timeLimit = 600 },
        { label = locale('crypto_distribution.steps.2'), timeLimit = 300 },
        { label = locale('crypto_distribution.steps.3'), timeLimit = 1200, progress = { target = 4 } },
        { label = locale('crypto_distribution.steps.4'), timeLimit = 180 },
    },
    blips = {
        van = { sprite = 67, color = 5, text = locale('crypto_distribution.blips.van') },
        drop = { sprite = 521, color = 5, text = locale('crypto_distribution.blips.drop') },
    },
    game = {
        police_alert_chance = 0.22,
        van_model = 'rumpo',
        snc_per_drop = 2500,
        completion_bonus_money = 6500,
        completion_bonus_exp = 80,
        passenger_signal = true,
        van_spawns = {
            vec4(961.42, -201.63, 73.12, 326.39),
            vec4(-1186.55, -1573.85, 4.31, 304.1),
            vec4(161.48, -3017.09, 5.97, 264.74),
        },
        drop_points = {
            vec4(-44.2, -1749.45, 29.42, 51.15),
            vector4(312.88, -1284.22, 30.55, 0.0),
            vector4(-48.22, -1757.44, 29.42, 0.0),
            vector4(1138.64, -982.12, 46.42, 0.0),
            vector4(-705.88, -913.42, 19.22, 0.0),
            vector4(255.12, -47.88, 69.94, 0.0),
            vector4(-1222.44, -907.22, 12.33, 0.0),
            vector4(373.88, 326.42, 103.57, 0.0),
        },
    },
    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `a_m_y_business_02`,
        coords   = vec4(-422.28, 1067.12, 323.85, 167.61),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'crypto_distribution.mp3',
        line     = 'Spread it thin, spend it smart, and don\'t get greedy.',
    },
}
