---@type Job
return {
    level = 1,
    label = 'Corner Meth',
    description = 'Sell meth packs on a hot corner.',
    image = 'corner_deal.png',
    reward = { money = 'Random', exp = 0 },
    information = 'A random corner is assigned. High-value product — keep rotating blocks.',
    steps = {
        { label = locale('corner_deal.steps.1') },
        { label = locale('corner_deal.steps.2') },
        { label = locale('corner_deal.steps.3') },
    },
    -- Solo only — each dealer tracks their own product/sales/progress independently
    teamSize = { min = 1, max = 1 },
    blips = {
        area = { sprite = 270, color = 5, text = 'Meth Corner' },
        customer = { sprite = 480, color = 5, text = 'Buyer' },
    },
    setCornerAreaCommand = 'drugsell_meth',
    -- Minimum police-job players online required to deal (0 = no minimum).
    -- This is the live corner_meth job — jobs/corner_deal/config.lua is
    -- unused legacy config and has no effect on gameplay.
    requiredMinCopCount = 2,
    money_type = 'dirty_money',
    drugKey = 'meth',
    drugs = {
        meth = { label = 'Meth', itemName = 'packed_meth', minPrice = 40, maxPrice = 520, exp = 12 },
    },
    game = {
        rotate_after_sales = { min = 2, max = 4 },
        -- Every this many successful sales, award a skill-tree/progression
        -- completion for this job (corner dealing never "finishes" on its
        -- own, so this is what actually advances cornermeth job_stats).
        completion_sales = 8,
        handoff = {
            drug_prop = 'prop_meth_bag_01',
            cash_prop = 'prop_anim_cash_note',
            duration = 2800,
        },
        areas = {
            { label = 'Rancho (med)', coords = vec3(363.46, -1934.69, 24.6), radius = 50.0, alertChance = 0.25 },
            { label = 'Cypress (high)', coords =vec3(898.03, -2458.1, 28.6), radius = 50.0, alertChance = 0.4 },
            { label = 'Paleto (low)', coords = vec3(-60.44, 6313.06, 31.3), radius = 50.0, alertChance = 0.15 },
        },
        pedModels = {
            'a_m_m_hillbilly_02', 'a_m_o_tramp_01', 'g_m_y_mexgoon_01',
            'a_m_y_methhead_01', 'a_f_m_skidrow_01', 'a_m_o_soucent_02',
        },
        extra_client_ped_cooldown = 15,
    },

    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `s_m_y_dealer_01`,
        coords   = vector4(1392.80, 3606.40, 34.98, 200.0),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'corner_deal.mp3',
        line     = 'Keep it quiet, keep it moving — cops love a slow hand.',
    },
}
