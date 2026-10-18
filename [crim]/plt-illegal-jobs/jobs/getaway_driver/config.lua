--[[
  Getaway Driver Contract — edit pickup / drop-off / vehicle spawn below.
]]
---@type Job
return {
    level = 3,
    label = locale('getaway_driver.label'),
    description = locale('getaway_driver.description'),
    image = 'getaway_driver.png',
    reward = { exp = 200, money = 16000 },
    cooldown = { enabled = true, minutes = 15 },
    information = locale('getaway_driver.information'),
    teamSize = { min = 1, max = 2 },
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    steps = {
        { label = locale('getaway_driver.steps.1'), timeLimit = 600 },
        { label = locale('getaway_driver.steps.2'), timeLimit = 300 },
        { label = locale('getaway_driver.steps.3'), timeLimit = 120 },
        { label = locale('getaway_driver.steps.4'), timeLimit = 240 },
        { label = locale('getaway_driver.steps.5'), timeLimit = 300 },
        { label = locale('getaway_driver.steps.6'), timeLimit = 180 },
    },
    blips = {
        vehicle = { sprite = 225, color = 5, text = locale('getaway_driver.blips.vehicle') },
        pickup = { sprite = 280, color = 1, text = locale('getaway_driver.blips.pickup') },
        dropoff = { sprite = 280, color = 2, text = locale('getaway_driver.blips.dropoff') },
    },
    game = {
        --[[ EDITABLE LOCATIONS ]]
        -- Spawn getaway car for the player (nil boat_spawn style — always provide a car)
        vehicle_spawns = {
            vec4(234.78, -751.75, 33.99, 71.22), -- TODO
            vec4(-236.22, -1179.39, 22.34, 356.73), -- TODO
            vector4(1204.42, -3117.88, 5.54, 0.0),  -- TODO
        },
        vehicle_models = { 'sultan', 'buffalo', 'kuruma', 'jugular' }, -- TODO
        -- Hot pickup points (passenger waiting under heat)
        pickups = {
            {
                coords = vec4(122.16, -1927.47, 21.01, 125.79), -- TODO
                passenger_model = 'g_m_y_mexgoon_01', -- TODO
            },
            {
                coords = vec4(105.36, -1569.6, 29.73, 319.01), -- TODO
                passenger_model = 'g_m_y_ballaorig_01',
            },
            {
                coords = vec4(-355.24, -1536.98, 27.71, 267.72), -- TODO
                passenger_model = 'g_m_y_famca_01',
            },
        },
        -- Safe drop-offs (revealed after evade success)
        dropoffs = {
            vec4(899.66, 3607.18, 32.81, 263.04), -- TODO
            vec4(1536.12, 6334.57, 24.08, 326.16),  -- TODO
            vec4(1190.78, -1261.06, 35.15, 271.02),  -- TODO
        },
        --[[ TUNING ]]
        -- Evade: lose pursuit by staying outside chase radius OR lasting the timer
        evade_time_ms = 90000,
        chase_radius = 120.0, -- distance from pickup where "heat" is considered active
        clean_bonus_money = 6000,   -- no vehicle damage + quick lose
        quick_lose_ms = 45000,      -- evade under this = quick bonus
        damage_penalty_per_pct = 80, -- money removed per % body health lost
        min_payout = 5000,
        police_alert_on_pickup = true,
        spawn_chase_npcs = true,
        pickup_board_radius = 10.0, -- passenger hops in when car is this close
        pickup_max_speed = 8.0,     -- m/s — slow down for pickup UI / auto-board
        chase_npc_spawns = {
            -- Relative-ish city chase spawns near pickups — edit freely
            vec4(152.4, -1961.12, 19.05, 145.52), -- TODO
            vec4(201.91, -2000.8, 18.86, 224.45), -- TODO
        },
        chase_vehicle = 'police3',
        chase_ped = 's_m_y_cop_01',
        chase_weapon = `WEAPON_PISTOL`,
    },
    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `g_m_y_ballaorig_01`,
        coords   = vec4(-217.92, -267.09, 49.08, 77.3),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'getaway_driver.mp3',
        line     = 'Keys are warm, engine\'s hot — get in and drive.',
    },
}
