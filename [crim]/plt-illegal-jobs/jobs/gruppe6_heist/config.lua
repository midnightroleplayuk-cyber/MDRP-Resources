---@type Job
return {
    level = 4,
    label = locale('gruppe6_heist.label'),
    description = locale('gruppe6_heist.description'),
    image = 'gruppe6_heist.png',
  reward = {
        exp = 280,
        money = 28000,
    },
    cooldown = { enabled = true, minutes = 25 },
    information = locale('gruppe6_heist.information'),
    teamSize = { min = 1, max = 4 },
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    steps = {
        { label = locale('gruppe6_heist.steps.1'), timeLimit = 600 },
        { label = locale('gruppe6_heist.steps.2'), timeLimit = 900 },
        { label = locale('gruppe6_heist.steps.3'), timeLimit = 600 },
        { label = locale('gruppe6_heist.steps.4'), timeLimit = 300 },
        { label = locale('gruppe6_heist.steps.5'), timeLimit = 600, progress = { target = 4 } },
        { label = locale('gruppe6_heist.steps.6'), timeLimit = 300 },
    },
    blips = {
        tipster = { sprite = 280, color = 1, text = locale('gruppe6_heist.blips.tipster') },
        van = { sprite = 67, color = 1, text = locale('gruppe6_heist.blips.van') },
    },
    game = {
        police_alert_chance = 0.55,
        tipster_model = 's_m_m_armoured_01',
        van_model = 'stockade',
        driver_model = 's_m_m_armoured_02',
        guard_model = 's_m_m_armoured_01',
        guard_weapon = `WEAPON_CARBINERIFLE`,
        base_guards = 3,
        guards_per_member = 1,
        loot = {
            { itemName = 'black_money', min = 8000, max = 14000 },
        },
        tipster_locations = {
            vec4(-1986.19, -313.04, 48.11, 136.75),
            vector4(-295.64, -829.48, 32.42, 20.0),
            vec4(-319.83, -1389.63, 36.5, 98.67),
        },
        van_routes = {
            {
                start = vector4(359.42, -273.18, 53.74, 340.0),
                waypoints = {
                    vector3(255.12, -311.42, 49.0),
                    vector3(116.84, -404.22, 41.0),
                    vector3(-48.22, -512.88, 40.0),
                    vector3(-212.64, -652.14, 33.0),
                    vector3(-356.88, -804.42, 31.0),
                    vector3(-512.22, -956.48, 23.0),
                },
            },
            {
                start = vector4(-1108.42, -1690.88, 4.36, 215.0),
                waypoints = {
                    vector3(-1024.12, -1512.44, 5.0),
                    vector3(-880.64, -1288.22, 5.0),
                    vector3(-712.48, -1044.88, 14.0),
                    vector3(-512.22, -844.12, 30.0),
                    vector3(-312.88, -712.44, 33.0),
                    vector3(-112.42, -612.88, 36.0),
                },
            },
        },
    },
    -- Opening contact VO (tipster ped reused on client)
    briefing = {
        reuseExistingPed = true,
        audio = 'gruppe6_heist.mp3',
        line  = 'That van\'s carrying more than paperwork — go take it.',
    },
}
