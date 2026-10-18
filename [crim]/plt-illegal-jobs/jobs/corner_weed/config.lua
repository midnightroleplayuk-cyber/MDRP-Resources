---@type Job
return {
    level = 1,
    label = 'Corner Weed',
    description = 'Sell weed bags on the street corner.',
    image = 'corner_deal.png',
    reward = { money = 'Random', exp = 0 },
    information = 'A random corner is assigned. Move product, then rotate when heat builds.',
    steps = {
        { label = locale('corner_deal.steps.1') },
        { label = locale('corner_deal.steps.2') },
        { label = locale('corner_deal.steps.3') },
    },
    -- Solo only — each dealer tracks their own product/sales/progress independently
    teamSize = { min = 1, max = 1 },
    blips = {
        area = { sprite = 270, color = 2, text = 'Weed Corner' },
        customer = { sprite = 480, color = 2, text = 'Buyer' },
    },
    setCornerAreaCommand = 'drugsell_weed',
    -- Minimum police-job players online required to deal (0 = no minimum).
    -- This is the live corner_weed job — jobs/corner_deal/config.lua is
    -- unused legacy config and has no effect on gameplay.
    requiredMinCopCount = 2,
    money_type = 'clean_money',
    drugKey = 'weed',
    drugs = {
        weed = { label = 'Weed', itemName = 'packed_weed', minPrice = 25, maxPrice = 400, exp = 10 },
    },
    game = {
        -- After this many successful sales, assign a different corner
        rotate_after_sales = { min = 2, max = 4 },
        -- Every this many successful sales, award a skill-tree/progression
        -- completion for this job (corner dealing never "finishes" on its
        -- own, so this is what actually advances cornerweed job_stats).
        completion_sales = 8,
        handoff = {
            drug_prop = 'bkr_prop_weed_bag_01a',
            cash_prop = 'prop_anim_cash_note',
            duration = 2800,
        },
        areas = {
            { label = 'Grove St (low)', coords = vec3(-126.75, -1738.34, 30.14), radius = 50.0, alertChance = 0.1 },
            { label = 'Mirror Park (med)', coords = vec3(1176.77, -511.18, 65.14), radius = 50.0, alertChance = 0.2 },
            { label = 'Sandy Shore (high)', coords = vec3(1885.2, 3841.37, 32.41), radius = 50.0, alertChance = 0.35 },
        },
        pedModels = {
            'a_f_y_hipster_02', 'a_m_m_hillbilly_02', 'a_m_o_soucent_02',
            'a_m_y_hipster_01', 'a_f_y_vinewood_02', 'a_m_o_tramp_01',
        },
        extra_client_ped_cooldown = 15,
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
