---@type Job
return {
    level = 1,
    label = 'Corner Oxy',
    description = 'Sell oxy pills on quiet residential corners.',
    image = 'corner_deal.png',
    reward = { money = 'Random', exp = 0 },
    information = 'A random corner is assigned. Fast turnover — keep rotating residential blocks.',
    steps = {
        { label = locale('corner_deal.steps.1') },
        { label = locale('corner_deal.steps.2') },
        { label = locale('corner_deal.steps.3') },
    },
    -- Solo only — each dealer tracks their own product/sales/progress independently
    teamSize = { min = 1, max = 1 },
    blips = {
        area = { sprite = 270, color = 46, text = 'Oxy Corner' },
        customer = { sprite = 480, color = 46, text = 'Buyer' },
    },
    setCornerAreaCommand = 'drugsell_oxy',
    -- Minimum police-job players online required to deal (0 = no minimum).
    -- This is the live corner_oxy job — jobs/corner_deal/config.lua is
    -- unused legacy config and has no effect on gameplay.
    requiredMinCopCount = 2,
    money_type = 'clean_money',
    drugKey = 'oxy',
    drugs = {
        oxy = { label = 'Oxy', itemName = 'oxy', minPrice = 30, maxPrice = 450, exp = 10 },
    },
    game = {
        rotate_after_sales = { min = 2, max = 4 },
        -- Every this many successful sales, award a skill-tree/progression
        -- completion for this job (corner dealing never "finishes" on its
        -- own, so this is what actually advances corneroxy job_stats).
        completion_sales = 8,
        handoff = {
            drug_prop = 'prop_cs_pills',
            cash_prop = 'prop_anim_cash_note',
            duration = 2800,
        },
        areas = {
            { label = 'Mirror Park (low)', coords = vec3(1072.15, -524.56, 62.33), radius = 50.0, alertChance = 0.15 },
            { label = 'Hawick (med)', coords = vec3(357.97, -267.5, 53.94), radius = 45.0, alertChance = 0.3 },
            { label = 'Vinewood (med)', coords = vec3(362.68, 136.17, 103.09), radius = 45.0, alertChance = 0.3 },
        },
        pedModels = {
            'a_f_y_hipster_02', 'a_m_y_hipster_01', 'a_f_y_tourist_01',
            'a_m_y_beachvesp_01', 'a_f_y_vinewood_04', 'a_m_m_bevhills_01',
        },
        extra_client_ped_cooldown = 12,
    },

    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `s_m_y_dealer_01`,
        coords   = vec4(365.11, -2064.83, 21.74, 55.75),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'corner_deal.mp3',
        line     = 'Keep it quiet, keep it moving — cops love a slow hand.',
    },
}
