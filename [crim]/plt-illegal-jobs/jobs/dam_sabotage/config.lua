--[[
  Dam Sabotage — edit dam / charge / extract coords below.
]]
---@type Job
return {
    level = 4,
    label = locale('dam_sabotage.label'),
    description = locale('dam_sabotage.description'),
    image = 'dam_sabotage.png',
    reward = { exp = 270, money = 25000 },
    cooldown = { enabled = true, minutes = 25 },
    information = locale('dam_sabotage.information'),
    teamSize = { min = 1, max = 4 },
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    requiredItems = {
        c4 = { itemName = 'c4', label = 'C4', count = 3 },
    },
    steps = {
        { label = locale('dam_sabotage.steps.1'), timeLimit = 600 },
        { label = locale('dam_sabotage.steps.2'), timeLimit = 600, progress = { target = 4 } },
        { label = locale('dam_sabotage.steps.3'), timeLimit = 300 },
        { label = locale('dam_sabotage.steps.4'), timeLimit = 400, progress = { target = 3 } },
        { label = locale('dam_sabotage.steps.5'), timeLimit = 120 },
        { label = locale('dam_sabotage.steps.6'), timeLimit = 60 },
        { label = locale('dam_sabotage.steps.7'), timeLimit = 300 },
        { label = locale('dam_sabotage.steps.8'), timeLimit = 300 },
    },
    blips = {
        dam = { sprite = 478, color = 1, text = locale('dam_sabotage.blips.dam') },
        charge = { sprite = 486, color = 1, text = locale('dam_sabotage.blips.charge') },
        safe = { sprite = 1, color = 2, text = locale('dam_sabotage.blips.safe') },
        extract = { sprite = 1, color = 2, text = locale('dam_sabotage.blips.extract') },
    },
    game = {
        --[[ EDITABLE LOCATIONS ]]
        sites = {
            {
                -- Approach / waypoint on accept (Land Act Dam area — replace with your spot)
                entrance = vector4(1661.88, -26.42, 173.77, 200.0), -- TODO
                -- Clear / arrive radius
                approach_radius = 40.0,
                -- Patrol guards around the structure
                guard_spawns = {
                    vec4(1666.29, -64.04, 174.17, 257.65), -- TODO
                    vec4(1666.72, -31.01, 173.77, 199.57),  -- TODO
                    vec4(1664.26, -20.66, 173.77, 278.8),  -- TODO
                    vec4(1664.16, 0.34, 173.78, 206.67), -- TODO
                    vec4(1638.22, 19.38, 173.77, 226.19),
                    vec4(1650.92, 5.27, 173.77, 263.08),
                    vec4(1659.35, -13.27, 169.99, 211.0),
                    vec4(1670.28, -25.16, 182.77, 285.03),
                    vec4(1672.82, -28.72, 182.77, 190.94),
                    vec4(1661.36, -30.53, 182.77, 111.68),
                    vec4(1660.04, -24.38, 182.77, 19.3),
                    vec4(1665.86, -9.35, 166.56, 109.54),
                    vec4(1657.04, 5.56, 166.12, 220.32),
                    vec4(1664.28, 5.67, 166.12, 136.84),
                    vec4(1659.95, 28.06, 168.61, 180.21),
                    vec4(1664.13, 39.36, 171.68, 94.82),
                    vec4(1655.74, 33.63, 179.88, 85.9),
                    vec4(1660.44, 22.17, 180.88, 186.51),
                    vec4(1650.74, 21.2, 180.88, 98.21),
                    vec4(1650.75, 27.74, 180.88, 29.03),
                    vec4(1683.72, -63.49, 174.46, 126.78)

                },
                -- Charge plant points (sequential — one at a time)
                charge_points = {
                    vec4(1664.09, -24.04, 173.77, 13.66),  -- TODO
                    vec4(1662.58, -54.55, 168.31, 181.28), -- TODO
                    vec4(1665.18, -0.8, 166.12, 215.76),-- TODO
                },
                -- Safe distance center for arm & retreat (leave this radius)
                safe_center = vec3(1670.09, -25.94, 173.77), -- TODO
                safe_radius = 50.0,
                -- Response wave after detonation
                response_spawns = {
                    vector4(1635.12, -5.44, 173.0, 200.0),  -- TODO
                    vector4(1688.88, -40.22, 173.0, 40.0),  -- TODO
                    vector4(1650.44, -55.12, 172.5, 10.0),  -- TODO
                },
                -- Final extraction
                extract = vec4(1458.88, -1930.69, 71.81, 84.34), -- TODO
            },
        },
        --[[ TUNING ]]
        guard_model = 's_m_y_marine_01',
        guard_weapon = `WEAPON_CARBINERIFLE`,
        response_model = 's_m_y_swat_01',
        response_weapon = `WEAPON_SMG`,
        allow_stealth_skip = true,
        plant_duration_ms = 5000,
        plant_interact_distance = 2.8,
        evacuate_seconds = 30,
        detonate_max_distance = 500.0, -- must be near site to arm, but OUTSIDE safe_radius to be "clear"
        police_alert_chance = 0.60,
        clear_all_guards = true,
        -- C4 plant / blast (heist thermal_charge anim + explosive brick prop)
        c4_item = 'c4',
        c4_prop = 'ch_prop_ch_explosive_01a', -- held in hand while planting
        charge_prop = 'ch_prop_ch_explosive_01a', -- left at charge point after plant
        blast = {
            -- GTA explosion types: 2 grenade, 7 sticky, 8 rocket, 29 tanker, 31 gas tanker
            explosion_type = 29,
            damage_scale = 1.0,
            camera_shake = 1.25,
            stagger_ms = 450,          -- delay between each charge blast
            particle = 'exp_grd_boat_lod',
            particle_asset = 'core',
            postfx = 'Dont_tazeme_bro',
            screen_shake_name = 'LARGE_EXPLOSION_SHAKE',
        },
    },
    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `s_m_y_construct_01`,
        coords   = vec4(2461.12, 1575.89, 33.11, 277.22),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'dam_sabotage.mp3',
        line     = 'Bring that water down, and bring yourself back up.',
    },
}
