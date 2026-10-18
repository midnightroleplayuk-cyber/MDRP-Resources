---@type Job
return {
    level = 3,
    label = locale('kidnapping.label'),
    description = locale('kidnapping.description'),
    image = 'kidnapping.png',
    reward = { exp = 180, money = 14500 },
    cooldown = { enabled = true, minutes = 15 },
    information = locale('kidnapping.information'),
    teamSize = { min = 1, max = 2 },
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    steps = {
        { label = locale('kidnapping.steps.1'), timeLimit = 600 },
        { label = locale('kidnapping.steps.2'), timeLimit = 300 },
        { label = locale('kidnapping.steps.3'), timeLimit = 600 },
        { label = locale('kidnapping.steps.4'), timeLimit = 180 },
    },
    blips = {
        target = { sprite = 280, color = 1, text = locale('kidnapping.blips.target') },
        dropoff = { sprite = 514, color = 1, text = locale('kidnapping.blips.dropoff') },
        van = { sprite = 67, color = 1, text = locale('kidnapping.blips.van') },
    },
    game = {
        police_alert_chance = 0.35,
        witness_radius = 25.0,
        break_free_chance = 0.06,
        break_free_check_ms = 14000,
        aim_distance = 12.0,
        lose_aim_ms = 4500,
        target_model = 'a_f_y_business_02', -- female mark matches drag-into-van anim root better
        static_target = true,
        vehicle_snatch_distance = 6.0,
        preview_position_tolerance = 2.0,
        preview_heading_tolerance = 14.0,
        client_model = 'g_m_y_mexgoon_01',
        delivery_vehicle = 'baller2', -- buyer vehicle for the hand-off drive-away
        ambush_chance = 0.18,
        ambush_guards = 3,
        ambush_model = 'g_m_y_mexgoon_02',
        ambush_weapon = `WEAPON_PISTOL`,

        -- Cinematic drag-into-van when first loading the mark (letterbox + synced scene)
        cutscene = {
            enabled = true,
            vehicle = 'burrito',
            anim_dict = 'random@kidnap_girl',
            -- These gang members replace players in the visual grab scene.
            -- The real crew stays inside the real getaway van.
            helper_models = { 'g_m_y_mexgoon_01', 'g_m_y_mexgoon_02' },
            helper_weapon = `WEAPON_MICROSMG`,
        },

        routes = {
            {
                -- Static hostage and transparent real-van parking guide.
                start = vec4(17.54, -1066.48, 38.15, 156.96),
                scene_vehicle = vec4(14.93, -1072.05, 37.97, 159.04),
            },
        },
        dropoffs = {
            vec4(1396.04, 3599.85, 34.0, 189.93),
            vec4(2553.98, 4668.0, 33.02, 21.06),
            vec4(721.96, -2016.31, 28.43, 258.03),
        },
    },
    briefing = {
        pedModel = `g_m_y_korean_01`,
        coords   = vec4(557.01, -1761.72, 29.31, 248.6),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'kidnapping.mp3',
        line     = 'Nobody hears a name after tonight - walk close, make the grab, then bring the van to the buyer.',
    },
}
