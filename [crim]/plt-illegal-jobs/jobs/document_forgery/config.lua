--[[
  Document Forgery — edit pickup / forger / buyer coords below.
]]
---@type Job
return {
    level = 2,
    label = locale('document_forgery.label'),
    description = locale('document_forgery.description'),
    image = 'document_forgery.png',
    reward = { exp = 160, money = 14000 },
    cooldown = { enabled = true, minutes = 12 },
    information = locale('document_forgery.information'),
    teamSize = { min = 1, max = 2 },
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    steps = {
        { label = locale('document_forgery.steps.1'), timeLimit = 600 },
        { label = locale('document_forgery.steps.2'), timeLimit = 300 },
        { label = locale('document_forgery.steps.3'), timeLimit = 300 },
        { label = locale('document_forgery.steps.4'), timeLimit = 180 },
        { label = locale('document_forgery.steps.5'), timeLimit = 900, progress = { target = 3 } },
        { label = locale('document_forgery.steps.6'), timeLimit = 120 },
    },
    blips = {
        materials = { sprite = 478, color = 5, text = locale('document_forgery.blips.materials') },
        forger = { sprite = 280, color = 5, text = locale('document_forgery.blips.forger') },
        buyer = { sprite = 280, color = 2, text = locale('document_forgery.blips.buyer') },
    },
    game = {
        --[[ EDITABLE LOCATIONS ]]
        material_pickups = {
            vector4(127.42, -1929.88, 21.38, 0.0), -- TODO: blank stock stash
            vec4(321.84, -1284.49, 30.57, 225.07), -- TODO
        },
        -- Optional prop model at pickup (nil = interaction zone only)
        materials_prop = 'prop_cs_cardbox_01', -- TODO
        forger_locations = {
            {
                npc = vector4(707.22, -966.88, 29.41, 180.0), -- TODO: forger ped
                collect = vector4(709.12, -964.44, 29.41, 0.0), -- TODO: finished docs
            }

        },
        buyer_drops = {
            vec4(175.25, -1279.83, 28.48, 338.57), -- TODO
            vec4(76.16, -1948.21, 20.17, 206.65),  -- TODO
            vec4(1229.67, -725.09, 59.96, 94.39), -- TODO
            vec4(255.25, -46.42, 68.94, 164.58),   -- TODO
            vec4(-46.92, -1758.4, 28.42, 47.16), -- TODO
        },
        --[[ TUNING ]]
        forger_model = 'a_m_m_business_01',
        forge_duration_ms = 35000,
        materials_item = 'paper', -- TODO: blank materials item
        materials_count = 1,
        forged_item = 'id_card', -- TODO: forged docs item
        forged_per_buyer = 1,
        buyer_count = 3,
        pay_per_delivery = 3200,
        police_alert_chance = 0.18,
        buyer_models = {
            'a_m_m_business_01',
            'a_f_y_business_02',
            'a_m_y_business_02',
            'a_m_m_hasjew_01',
            'g_m_y_mexgoon_03',
            'a_f_m_eastsa_02',
        },
    },
    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `a_m_m_business_01`,
        coords   = vec4(1269.04, -1711.27, 54.77, 32.19),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'document_forgery.mp3',
        line     = 'Ink\'s still wet — don\'t let anyone look too close.',
    },
}
