

---[[
--- All accepted values are specified in `shared/types/__job.lua`.
---]]

---@type Job
return {
    -- Minimum required level to start the job
    level = 2,

    -- Job title displayed in the UI
    label = locale('corner_deal.label'),

    -- Short mission description
    description = locale('corner_deal.description'),

    -- UI image for the mission
    image = 'corner_deal.png',

    reward = { money = 'Random' },

    -- Additional info or lore for the mission
    information = locale('corner_deal.information'),

    -- Step-by-step instructions for the mission
    steps = {
        { label = locale('corner_deal.steps.1') },
        { label = locale('corner_deal.steps.2'), },
        { label = locale('corner_deal.steps.3'), },
    },

    teamSize = { min = 1, max = 1 },

    -- Blips
    blips = {
        area = { sprite = 270, color = 5, text = locale('corner_deal.blips.area') },
        customer = { sprite = 270, color = 5, text = locale('corner_deal.blips.customer') },
    },

    setCornerAreaCommand = 'drugsell',

    -- Minimum required police officers to start the job
    requiredMinCopCount = 0,

    --- The type of money you will get when you sell,
    --- Money related settings are in the ``config/config.lua`` file.
    ---@type 'clean_money' | 'dirty_money'
    money_type = 'clean_money',

    drugs = {
        ['meth'] = { label = 'Meth', itemName = 'packed_meth', minPrice = 25, maxPrice = 400, exp = 10 },
        ['weed'] = { label = 'Weed', itemName = 'packed_weed', minPrice = 25, maxPrice = 400, exp = 10 },
        ['coke'] = { label = 'Coke', itemName = 'packed_coke', minPrice = 25, maxPrice = 400, exp = 10 },
    },

    game = {
        areas = {
            { label = 'Area (low risk)',  coords = vector3(2319.5386, 5074.2871, 45.6101), radius = 50.0, alertChance = 0.1 },
            { label = 'Area (med risk)',  coords = vector3(59.3743, -1901.7849, 21.6863),  radius = 50.0, alertChance = 0.2 },
            { label = 'Area (high risk)', coords = vector3(33.8028, 256.6443, 109.6017),   radius = 50.0, alertChance = 0.5 },
        },

        pedModels = {
            'a_f_y_hipster_02',
            'a_f_y_vinewood_02',
            'a_m_m_hillbilly_02',
            'a_m_o_soucent_02',
            'a_m_o_tramp_01',
        },

        -- Cooldown for spawning NPCs after a deal (in seconds) if you want to add delay
        extra_client_ped_cooldown = 30,
    },

    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `s_m_y_dealer_01`,
        coords   = vector4(112.40, -1961.20, 20.94, 20.0),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'corner_deal.mp3',
        line     = 'Keep it quiet, keep it moving — cops love a slow hand.',
    },
}

