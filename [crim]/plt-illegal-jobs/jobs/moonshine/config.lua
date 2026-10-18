---@type Job
return {
    -- Minimum required level to start the job
    level = 4,

    -- Job title displayed in the UI
    label = locale('moonshine.label'),

    -- Short mission description
    description = locale('moonshine.description'),

    -- UI image for the mission
    image = 'moonshine.png',

    -- Rewards for completing the mission
    reward = { exp = 300, money = 10000 },

    -- Restart cooldown applied per player when the job finishes or is manually stopped.
    cooldown = { enabled = true, minutes = 15 },

    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,

    -- Additional info or lore for the mission
    information = locale('moonshine.information'),

    -- Step-by-step instructions for the mission
    steps = {
        { label = locale('moonshine.steps.1') },
        { label = locale('moonshine.steps.2'), progress = { target = 1 } },
        { label = locale('moonshine.steps.3') },
        { label = locale('moonshine.steps.4') },
        { label = locale('moonshine.steps.5'), progress = { target = 5 } },
    },

    -- Blips
    blips = {
        contact_npc  = { sprite = 270, color = 5, text = locale('moonshine.blips.contact_npc') },
        vehicle      = { sprite = 67, color = 5, text = locale('moonshine.blips.vehicle') },
        delivery     = { sprite = 270, color = 5, text = locale('moonshine.blips.delivery') },
        distillation = { sprite = 499, color = 5, text = locale('moonshine.blips.distillation') },
    },

    -- Required item(s). Mid-job craft items are not checked at start.
    requiredItems = {
        ['moonshine_pack'] = { itemName = 'moonshine_pack', label = 'Bootleg Pack', requiredAtStart = false },
        ['moonshine_still'] = { itemName = 'moonshine_still', label = 'Still', requiredAtStart = true },
        ['old_corn'] = { itemName = 'old_corn', label = 'Old Corn', requiredAtStart = false },
        ['old_fruit'] = { itemName = 'old_fruit', label = 'Old Fruit', requiredAtStart = false },
        ['tap_water'] = { itemName = 'tap_water', label = 'Tap Water', requiredAtStart = false },
        ['crushed_ingredients'] = { itemName = 'crushed_ingredients', label = 'Crushed Ingredients', requiredAtStart = false },
        ['blended_ingredients'] = { itemName = 'blended_ingredients', label = 'Blended Ingredients', requiredAtStart = false },
        ['moonshine'] = { itemName = 'moonshine', label = 'Bootleg Spirits', production = 3, quantityPerPack = 9, requiredAtStart = false },
    },

    -- Preparation time, in seconds
    cookingTime = 180,

    game = {
        police_alert_chance = 0.2, -- 20% chance to alert police when placing package in vehicle

        locations = {
            [1] = {
                npc_location = vector4(283.7112, 6795.4688, 14.6949, 253.0113),
                table_location = vector4(1544.27, 6330.99, 23.08, 180.0),
                vehicle_spawn_location = vector4(281.20, 6801.14, 15.25, 255.90),
                distillation_location = { coords = vector3(1540.7693, 6335.1919, 24.0742), radius = 50.0 },
                crushing_crate_locations = {
                    vector4(1546.05, 6335.45, 23.66, 60.0),
                    vector4(1544.66, 6337.15, 23.08, 60.0),
                    vector4(1543.39, 6337.77, 23.08, 60.0),
                    vector4(1542.21, 6338.35, 23.08, 60.0),
                },
                blending_barrel_location = vector4(1546.41, 6331.89, 23.52, 0.0),
            },
        },

        delivery_locations = {
            vector4(-685.9651, 5787.2026, 17.3309, 219.8593),
        },

        npc_model = 's_m_m_cntrybar_01',
        object_gizmo_resource_name = 'object_gizmo',
        table_model = 'bkr_prop_weed_table_01b',
    },
    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `a_m_m_hillbilly_01`,
        coords   = vec4(281.77, 6790.46, 15.69, 258.54),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'moonshine.mp3',
        line     = 'Careful with the still — it bites back if you rush it.',
    },
}

