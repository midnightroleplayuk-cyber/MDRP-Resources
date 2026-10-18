
---@type Job
return {
    level = 3,
    label = locale('weapons_airdrop.label'),
    description = locale('weapons_airdrop.description'),
    image = 'weapons_airdrop.png',
    reward = { exp = 220, money = 21000 },
    cooldown = { enabled = true, minutes = 20 },
    information = locale('weapons_airdrop.information'),
    teamSize = { min = 1, max = 4 },
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    steps = {
        { label = locale('weapons_airdrop.steps.1'), timeLimit = 300 },
        { label = locale('weapons_airdrop.steps.2'), timeLimit = 180 },
        { label = locale('weapons_airdrop.steps.3'), timeLimit = 300 },
        { label = locale('weapons_airdrop.steps.4'), timeLimit = 120 },
        { label = locale('weapons_airdrop.steps.5'), timeLimit = 180 },
        { label = locale('weapons_airdrop.steps.6'), timeLimit = 600 },
    },
    blips = {
        zone = { sprite = 94, color = 1, text = locale('weapons_airdrop.blips.zone') },
        crate = { sprite = 478, color = 1, text = locale('weapons_airdrop.blips.crate') },
        delivery = { sprite = 478, color = 2, text = locale('weapons_airdrop.blips.delivery') },
    },
    game = {
        plane_model = 'cuban800',
        plane_pilot = 's_m_m_pilot_02',
        parachute_prop = 'p_cargo_chute_s',
        flare_weapon = 'weapon_flare',
        crate_prop = 'ex_prop_adv_case_sm',
        flyover_delay_ms = 25000,
        -- Drop when plane is this close (xy) to the landing mark
        drop_trigger_dist = 35.0,

        drop_zones = {
            {
                center = vector3(1702.12, 3248.88, 41.12),
                radius = 120.0,
                landing_points = {
                    vector4(1718.44, 3262.12, 41.15, 0.0),
                    vector4(1688.22, 3235.88, 40.85, 0.0),
                    vector4(1725.88, 3228.44, 41.05, 0.0),
                },
                -- Plane pass that crosses the zone (SW → NE)
                plane_start = vector4(1500.0, 3050.0, 180.0, 45.0),
                plane_end = vector4(1920.0, 3450.0, 180.0, 45.0),
                rival_spawns = {
                    vector4(1705.12, 3275.44, 41.12, 180.0),
                    vector4(1690.88, 3255.22, 40.90, 90.0),
                },
            },
            {
                center = vector3(2450.12, 4960.88, 45.0),
                radius = 100.0,
                landing_points = {
                    vector4(2462.44, 4972.12, 45.5, 0.0),
                    vector4(2438.22, 4950.88, 44.8, 0.0),
                },
                plane_start = vector4(2240.0, 4760.0, 190.0, 45.0),
                plane_end = vector4(2660.0, 5160.0, 190.0, 45.0),
                rival_spawns = {
                    vector4(2470.12, 4945.44, 45.0, 0.0),
                },
            },
        },
        deliveries = {
            vector4(1391.42, 3608.88, 34.98, 200.0),
            vector4(721.88, -2016.42, 29.29, 90.0),
        },
        rival_model = 'g_m_y_lost_01',
        rival_weapon = `WEAPON_PUMPSHOTGUN`,
        evade_radius = 90.0,
        evade_time_ms = 60000,
        reward_item = 'weapon_pistol',
        reward_item_count = 1,
        police_alert_chance = 0.40,
    },
    briefing = {
        pedModel = `s_m_y_blackops_01`,
        coords   = vec4(2633.6, 3257.76, 55.46, 327.73),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'weapons_airdrop.mp3',
        line     = 'Plane\'s on approach — watch for the flare and grab that crate fast.',
    },
}
