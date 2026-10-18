---@type Job
return {
    level = 3,
    label = 'Boxing',
    description = 'Make money with illegal boxing.',
    image = 'npc_boxing.png',
    reward = { exp = 150, money = 2000 },
    cooldown = { enabled = true, minutes = 10 },
    information = 'Make money with illegal boxing.',

    steps = {
        { label = locale('npc_boxing.steps.1') },
        { label = locale('npc_boxing.steps.2'), progress = { target = 5 }, },
    },

    blips = {
        contact_npc = { sprite = 270, color = 5, text = locale('npc_boxing.blips.contact_npc') },
        ring = { sprite = 311, color = 1, text = locale('npc_boxing.blips.ring') or 'Boxing Ring' },
    },

    teamSize = { max = 1 },
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,

    game = {
        fighters = {
            [1] = { model = 'a_m_m_fatlatin_01', health = 300, armor = 0, accuracy = 10, count = 1 },
            [2] = { model = 'g_m_y_mexgoon_01', health = 350, armor = 25, accuracy = 10, count = 2 },
            [3] = { model = 'g_m_y_ballaeast_01', health = 300, armor = 25, accuracy = 10, weapon = 'weapon_bat', count = 1 },
            [4] = { model = 'g_m_y_lost_01', health = 300, armor = 25, accuracy = 25, weapon = 'weapon_bat', count = 2 },
            [5] = { model = 's_m_y_blackops_01', health = 400, armor = 25, accuracy = 25, weapon = 'weapon_bat', count = 2 },
        },

        ring_model = 'prop_legend_boxing_ring',

        locations = {
            [1] = {
                ring_coords = vector4(296.43, -2430.48, 11.04, 11.62),
                ring_z_nudge = 0.5,

                -- Horizontal leave-ring radius (meters from arena center) — kept large on purpose
                ring_radius = 5.5,

                npc_location = vector4(279.62, -2429.63, 8.8, 262.79),

                -- Exact stand spots (Z is used as-is from these vectors)
                opponent_1 = vec4(300.13, -2429.09, 9.0, 152.72),   -- player
                opponent_2 =vec4(296.15, -2434.89, 9.0, 327.37), -- NPC

                arena_location = {
                    center = vec3(298.11, -2431.74, 9.04),
                    -- Wide corners around the ring (increased radius)
                    corners = {
                        vector3(288.0, -2438.5, 9.0),
                        vector3(288.0, -2422.5, 9.0),
                        vector3(305.0, -2422.5, 9.0),
                        vector3(305.0, -2438.5, 9.0),
                    },
                },

                spectator_locations = {
                    vector4(291.10, -2426.20, 8.43, 200.0),
                    vector4(293.40, -2425.40, 8.43, 185.0),
                    vector4(301.80, -2426.50, 8.43, 150.0),
                    vector4(302.60, -2433.20, 8.43, 90.0),
                    vector4(290.40, -2433.80, 8.43, 280.0),
                },
            },
        },

        npc_model = 'a_m_y_ktown_01',
        spectatorModels = {
            'a_m_m_eastsa_01',
            'a_f_y_hipster_02',
            'a_m_y_musclbeac_01'
        }
    },

    briefing = {
        reuseExistingPed = true,
        audio = 'npc_boxing.mp3',
        line  = 'Step in that ring like you\'ve got something to prove.',
    },
}
