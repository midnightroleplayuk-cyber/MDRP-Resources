---@type Job
return {
    level = 1,
    label = 'Corner Coke',
    description = 'Move coke bags on premium corners.',
    image = 'corner_deal.png',
    reward = { money = 'Random', exp = 0 },
    information = 'A random corner is assigned. Quiet buyers — rotate before heat sticks.',
    steps = {
        { label = locale('corner_deal.steps.1') },
        { label = locale('corner_deal.steps.2') },
        { label = locale('corner_deal.steps.3') },
    },
    -- Solo only — each dealer tracks their own product/sales/progress independently
    teamSize = { min = 1, max = 1 },
    blips = {
        area = { sprite = 270, color = 3, text = 'Coke Corner' },
        customer = { sprite = 480, color = 3, text = 'Buyer' },
    },
    setCornerAreaCommand = 'drugsell_coke',
    -- Minimum police-job players online required to deal (0 = no minimum).
    -- This is the live corner_coke job — jobs/corner_deal/config.lua is
    -- unused legacy config and has no effect on gameplay.
    requiredMinCopCount = 2,
    money_type = 'dirty_money',
    drugKey = 'coke',
    drugs = {
        coke = { label = 'Coke', itemName = 'packed_coke', minPrice = 60, maxPrice = 700, exp = 15 },
    },
    game = {
        rotate_after_sales = { min = 2, max = 4 },
        -- Every this many successful sales, award a skill-tree/progression
        -- completion for this job (corner dealing never "finishes" on its
        -- own, so this is what actually advances cornercoke job_stats).
        completion_sales = 8,
        handoff = {
            drug_prop = 'prop_drug_package_02',
            cash_prop = 'prop_anim_cash_note',
            duration = 2800,
        },
        areas = {
            { label = 'Vespucci (med)', coords =vec3(-1294.76, -1479.34, 4.31), radius = 50.0, alertChance = 0.25 },
            { label = 'Rockford (high)', coords = vec3(-537.45, 256.33, 83.07), radius = 45.0, alertChance = 0.45 },
            { label = 'Downtown (high)', coords = vector3(33.8, 256.6, 109.6), radius = 45.0, alertChance = 0.5 },
        },
        pedModels = {
            'a_f_y_vinewood_02', 'a_m_y_business_02', 'a_f_y_business_02',
            'a_m_m_soucent_03', 'g_m_y_ballaeast_01', 'a_m_y_hipster_02',
        },
        extra_client_ped_cooldown = 18,
    },

    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `s_m_y_dealer_01`,
        coords   = vec4(-989.09, -1575.61, 5.17, 107.91),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'corner_deal.mp3',
        line     = 'Keep it quiet, keep it moving — cops love a slow hand.',
    },
}
