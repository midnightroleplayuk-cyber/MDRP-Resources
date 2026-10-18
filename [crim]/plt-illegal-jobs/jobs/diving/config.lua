

---[[
--- All accepted values are specified in `shared/types/__job.lua`.
---]]

---@type Job
return {
    -- Minimum required level to start the job
    level = 2,

    -- Job title displayed in the UI
    label = locale('diving.label'),

    -- Short mission description
    description = locale('diving.description'),

    -- UI image for the mission
    image = 'diving.png',

    -- Rewards for completing the mission
    reward = { exp = 150, money = 7000 },

    -- Restart cooldown applied per player when the job finishes or is manually stopped.
    cooldown = { enabled = true, minutes = 12 },

    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,

    -- Additional info or lore for the mission
    information = locale('diving.information'),

    -- Step-by-step instructions for the mission
    steps = {
        { label = locale('diving.steps.1'), timeLimit = 600, },
        { label = locale('diving.steps.2'), timeLimit = 600, },
        { label = locale('diving.steps.3'), timeLimit = 600, progress = { target = 15 }, },
        { label = locale('diving.steps.4'), timeLimit = 600, }
    },

    -- Blips
    blips = {
        diving_npc = { sprite = 270, color = 5, text = locale('diving.blips.diving_npc') },
        item = { sprite = 270, color = 5, text = locale('diving.blips.item') },
        boat = { sprite = 427, color = 5, text = locale('diving.blips.boat') },
    },

    requiredItems = {
        ['anchor'] = { itemName = 'anchor', label = 'Anchor' },
    },

    -- One of these items will be given randomly
    loots = {
        { itemName = 'scrapmetal', minCount = 1, maxCount = 3 },
    },

    -- Clothing
    outfit = {
        -- QB/QBOX
        ['t-shirt'] = { item = -1, texture = 0 },
        ['torso2'] = { item = 243, texture = 0 },
        ['pants'] = { item = 94, texture = 0 },
        ['shoes'] = { item = 67, texture = 0 },
        -- ESX
        ['tshirt_1'] = { item = -1, texture = 0 },
        ['tshirt_2'] = { item = -1, texture = 0 },
        ['torso_2'] = { item = 243, texture = 0 },
        ['pants_1'] = { item = 94, texture = 0 },
        ['shoes_1'] = { item = 67, texture = 0 },
    },

    --[[ Game mechanics and settings ]]
    game = {
        police_alert_chance            = 0.2, -- 20% chance to alert police when loot is collected

        locations                      = {
            [1] = {
                npc_location = vector4(-1608.7673, 5260.7729, 2.9741, 86.5547),
                boat_spawn_location = vector4(-1603.40, 5260.64, 0.12, 24.0),
                loot_location = vector3(-2125.8652, 5446.6196, -13.5445),
            },
            [2] = {
                npc_location = vector4(1304.5663, 4229.5273, 32.9086, 39.7877),
                boat_spawn_location = vector4(1310.40, 4234.40, 30.43, 260.0),
                loot_location = vector3(860.4232, 3923.5129, 5.7436),
            },
        },

        boat_model                     = 'dinghy',
        npc_model                      = 'a_m_m_hillbilly_01',
        -- Minimum loots to collect to finish the job
        min_collect_required_to_finish = 10,
    },
    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `a_m_y_surfer_01`,
        coords   = vec4(-1611.86, -1126.34, 2.31, 129.08),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'diving.mp3',
        line     = 'What\'s down there\'s worth more than your air supply.',
    },
}

