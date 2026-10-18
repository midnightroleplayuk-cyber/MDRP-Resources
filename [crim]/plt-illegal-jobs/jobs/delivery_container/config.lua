---@type Job
return {
    level = 5,
    label = locale('delivery_container.label'),
    description = locale('delivery_container.description'),
    image = 'delivery_container.png',
    reward = { exp = 220, money = 18500 },
    cooldown = { enabled = true, minutes = 20 },
    information = locale('delivery_container.information'),
    teamSize = { min = 1, max = 2 },
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    steps = {
        { label = locale('delivery_container.steps.1'), timeLimit = 600 },
        { label = locale('delivery_container.steps.2'), timeLimit = 600 },
        { label = locale('delivery_container.steps.3'), timeLimit = 300 },
        { label = locale('delivery_container.steps.4'), timeLimit = 180 },
    },
    blips = {
        zone = { sprite = 615, color = 17, text = locale('delivery_container.blips.zone') },
        container = { sprite = 615, color = 5, text = locale('delivery_container.blips.container') },
    },
    game = {
        police_alert_chance = 0.35,
        container_model = 'tr_prop_tr_container_01a',
        fakecontainer_model = 'prop_ld_container',
        -- Prop spawned inside the opened container for the player to loot
        crate_model = 'prop_box_wood02a',
        -- Offset from container origin (local x, y, z) — tweak if crate sits wrong
        crate_offset = vector3(0.0, -1.2, 0.35),

        lockpick = { itemName = 'lockpick', label = 'Lockpick', count = 1 },

        guards = {
            model = 's_m_y_blackops_01',
            weapon = `WEAPON_PISTOL`,
            count = 3,
            radius = 10.0,
        },

        --[[
            How to add a container location:

            containers = {
                {
                    coords = vector4(x, y, z, heading), -- REQUIRED: where the container spawns
                    gate   = vector4(x, y, z, heading), -- OPTIONAL: open/loot target at the door
                    guard_spawns = {                     -- OPTIONAL: guards for this container only
                        vector4(x, y, z, heading),
                    },
                },
                -- Or short form (coords only):
                vector4(x, y, z, heading),
            }
        ]]
        sites = {
            {
                label = 'Elysian Island Yard',
                center = vec3(548.0, -2963.39, 11.67),
                radius = 55.0,
                guard_spawns = {
                    vec4(553.44, -2963.18, 10.67, 269.71),
                    vec4(563.85, -2960.62, 10.67, 353.33),
                    vec4(563.8, -2956.29, 5.05, 6.33),
                },
                containers = {
                    {
                        coords = vec4(548.0, -2963.39, 10.67, 263.2),
                        gate = vec4(548.0, -2963.39, 10.67, 263.2),
                    },
                },
            },
            {
                label = 'Terminal Storage',
                center =  vec3(548.0, -2963.39, 11.67),
                radius = 60.0,
                guard_spawns = {
                    vec4(553.44, -2963.18, 10.67, 269.71),
                    vec4(563.85, -2960.62, 10.67, 353.33),
                    vec4(563.8, -2956.29, 5.05, 6.33),
                },
                containers = {
                    {
                        coords = vec4(548.0, -2963.39, 10.67, 263.2),
                        gate = vec4(548.0, -2963.39, 10.67, 263.2),
                    },
                    {
                        coords = vec4(548.0, -2963.39, 10.67, 263.2),
                        gate = vec4(548.0, -2963.39, 10.67, 263.2),
                    },
                    {
                        coords = vec4(548.0, -2963.39, 10.67, 263.2),
                        gate = vec4(548.0, -2963.39, 10.67, 263.2),
                    },
                },
            },
            {
                label = 'Cypress Freight',
                center = vector3(1012.88, -2510.64, 28.40),
                radius = 50.0,
                guard_spawns = {
                    vector4(1017.20, -2506.40, 28.40, 175.0),
                    vector4(1008.40, -2515.20, 28.30, 355.0),
                    vector4(1016.80, -2516.80, 28.35, 265.0),
                },
                containers = {
                    {
                        coords = vector4(1012.88, -2510.64, 27.40, 355.0),
                        gate = vector4(1012.88, -2507.40, 28.00, 355.0),
                    },
                    {
                        coords = vector4(1002.12, -2518.40, 27.30, 265.0),
                        gate = vector4(999.00, -2518.40, 27.90, 265.0),
                    },
                    {
                        coords = vector4(1024.44, -2502.88, 27.45, 85.0),
                        gate = vector4(1027.60, -2502.88, 28.05, 85.0),
                    },
                },
            },
        },
        -- Seconds before opened container / crate props despawn after mission ends
        despawn_delay_ms = 45000,

      
        loot = {
            { itemName = 'c4', chance = 1.0, min = 1, max = 2 },
            { itemName = 'lockpick', chance = 1.0, min = 1, max = 1 },
            { itemName = 'black_money', chance = 1.0, min = 1000, max = 2500 },
            { itemName = 'thermite', chance = 0.35, min = 1, max = 1 },
        },
    },
    briefing = {
        pedModel = `s_m_m_dockwork_01`,
        coords   = vec4(1239.08, -3109.44, 6.03, 0.98),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'delivery_container.mp3',
        line     = 'That container doesn\'t exist until it\'s off my dock.',
    },
}
