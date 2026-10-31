cfg = cfg or {} cfg.store = cfg.store or {} cfg.vehicles = cfg.vehicles or {}

cfg.starting_data = {
    currency = 2500,      -- Starts player with 25 XNT to begin boosting
    contracts = 3,      -- Starts player with 1 contract to begin boosting
}

cfg.ped_purchase_tablet = {
    enabled = true,
    coord = vector4(-759.24, -209.56, 36.27, 119.43),
    model = "a_m_y_genstreet_02",
    tablet_cost = 20000,
    payment_type = 'cash',
}

cfg.store.pickup = {
    coord = vector4(309.47, -2861.61, 6.16, 89.4),
    model = "u_m_y_smugmech_01",
}

-- Price and Stock can be a fixed number or a range using a table
-- Example: price = 3 or price = {min = 3, max = 5}
cfg.store.inventory = {
    {item = 'lockpick', price = {min = 4, max = 6}, level = 0, stock = {min = 25, max = 75}},
    {item = 'gg_rattle_can', price = {min = 3, max = 5}, level = 0, stock = {min = 20, max = 30}},
    {item = 'gg_boost_plate', price = {min = 5, max = 10}, level = 0, stock = {min = 15, max = 25}},
    {item = 'gg_wire_cutters', price = {min = 7, max = 12}, level = 0, stock = {min = 2, max = 10}},
    {item = 'weapon_digiscanner', price = {min = 30, max = 40}, level = 5, stock = {min = 0, max = 3}},
    {item = 'gg_tracker_scrambler', price = {min = 40, max = 60}, level = 5, stock = {min = 3, max = 6}},
    {item = 'gg_signal_jammer', price = {min = 10, max = 20}, level = 20, stock = {min = 20, max = 40}},
} 

cfg.vehicles.classes = {
    {
        class = "S+",                                                         -- Vehicle Class
        payout = { min = 100, max = 200 },                                    -- XNT Currency Payout (Split With Group)
        rep = { min = 80, max = 100 },                                        -- Reputation Eanred (Not Split with group)
        class_timer = { min = 18, max = 32 },                                 -- Lifetime of contract until deleted
        unlock_requirements = { required_level = 45, chance_weight = 25, },   -- Required Level and Probability of finding contract in unlocks page
        police_required = 2,                                                  -- Specific Police Required to start job (Default is in cfg.settings.gameplay)
        rewards = {                                                           -- Bonus Cash / Items on completion
            cash = {chance = 100, count = {min = 250, max = 500}},
            items = {
                {item = "lockpick", chance = 50, count = {min = 1, max = 1}},
                {item = "gg_signal_jammer", chance = 10, count = {min = 1, max = 1}},
            },
        },
    },
    {
        class = "S",
        payout = { min = 90, max = 160 },
        rep = { min = 60, max = 80 },
        class_timer = { min = 16, max = 30 },
        unlock_requirements = { required_level = 35, chance_weight = 75, },
        police_required = 2,
        rewards = {
            cash = {chance = 100, count = {min = 250, max = 500}},
            items = {
                {item = "lockpick", chance = 50, count = {min = 1, max = 1}},
                {item = "gg_signal_jammer", chance = 10, count = {min = 1, max = 1}},
            },
        },
    },
    {
        class = "A+",
        payout = { min = 75, max = 140 },
        rep = { min = 40, max = 60 },
        class_timer = { min = 14, max = 28 },
        police_required = 0,
        unlock_requirements = { required_level = 30, chance_weight = 50, },
        rewards = {
            cash = {chance = 100, count = {min = 225, max = 450}},
            items = {
                {item = "lockpick", chance = 50, count = {min = 1, max = 1}},
                {item = "gg_signal_jammer", chance = 10, count = {min = 1, max = 1}},
            },
        },
    },
    {
        class = "A",
        payout = { min = 60, max = 120 },
        rep = { min = 25, max = 40 },
        class_timer = { min = 12, max = 26 },
        police_required = 0,
        unlock_requirements = { required_level = 20, chance_weight = 150, },
        rewards = {
            cash = {chance = 100, count = {min = 225, max = 450}},
            items = {
                {item = "lockpick", chance = 50, count = {min = 1, max = 1}},
                {item = "gg_signal_jammer", chance = 10, count = {min = 1, max = 1}},
            },
        },
    },
    {
        class = "B+",
        payout = { min = 40, max = 85 },
        rep = { min = 15, max = 25 },
        class_timer = { min = 10, max = 24 },
        police_required = 0,
        unlock_requirements = { required_level = 15, chance_weight = 100, },
        rewards = {
            cash = {chance = 100, count = {min = 200, max = 400}},
            items = {
                {item = "gg_wire_cutters", chance = 10, count = {min = 1, max = 1}},
            },
        },
    },
    {
        class = "B",
        payout = { min = 35, max = 70 },
        rep = { min = 10, max = 20 },
        class_timer = { min = 8, max = 22 },
        police_required = 0,
        unlock_requirements = { required_level = 12, chance_weight = 300, },
        rewards = {
            cash = {chance = 100, count = {min = 200, max = 400}},
            items = {
                {item = "gg_wire_cutters", chance = 10, count = {min = 1, max = 1}},
            },
        },
    },
    {
        class = "C+",
        payout = { min = 28, max = 60 },
        rep = { min = 8, max = 14 },
        class_timer = { min = 7, max = 20 },
        police_required = 0,
        unlock_requirements = { required_level = 8, chance_weight = 250, },
        rewards = {
            cash = {chance = 100, count = {min = 175, max = 350}},
            items = {
                {item = "gg_rattle_can", chance = 10, count = {min = 1, max = 1}},
            },
        },
    },
    {
        class = "C",
        payout = { min = 20, max = 45 },
        rep = { min = 6, max = 10 },
        class_timer = { min = 6, max = 18 },
        police_required = 0,
        unlock_requirements = { required_level = 5, chance_weight = 400, },
        rewards = {
            cash = {chance = 100, count = {min = 175, max = 350}},
            items = {
                {item = "gg_rattle_can", chance = 10, count = {min = 1, max = 1}},
            },
        },
    },
    {
        class = "D+",
        payout = { min = 15, max = 35 },
        rep = { min = 5, max = 8 },
        class_timer = { min = 6, max = 16 },
        police_required = 0,
        unlock_requirements = { required_level = 3, chance_weight = 450, },
        rewards = {
            cash = {chance = 100, count = {min = 150, max = 300}},
            items = {
                {item = "gg_rattle_can", chance = 10, count = {min = 1, max = 1}},
                {item = "gg_boost_plate", chance = 10, count = {min = 1, max = 1}},
            },
        },
    },
    {
        class = "D",
        payout = { min = 10, max = 25 },
        rep = { min = 3, max = 6 },
        class_timer = { min = 5, max = 14 },
        police_required = 0,
        unlock_requirements = { required_level = 1, chance_weight = 600,},
        rewards = {
            cash = {chance = 100, count = {min = 150, max = 300}},
            items = {
                {item = "gg_rattle_can", chance = 10, count = {min = 1, max = 1}},
                {item = "gg_boost_plate", chance = 10, count = {min = 1, max = 1}},
            },
        },
    },
}



cfg.ped_types = {
    ['default'] = {
        'a_m_m_skater_01',
        'a_m_m_hillbilly_01',
        'a_m_y_soucent_01',
        'a_m_y_vinewood_01',
        'a_f_o_ktown_01',
        'a_m_m_golfer_01',
        'a_m_y_beachvesp_01',
        'a_f_y_vinewood_04',
        'a_m_m_stlat_02',
        'a_m_m_rurmeth_01',
    },
    ['delivery'] = {
        'a_m_y_soucent_03',
        'a_m_y_ktown_02',
        'a_m_y_mexthug_01',
        'cs_carbuyer',
        'a_m_y_smartcaspat_01',
    },
    ['gang'] = {
        'g_f_y_families_01',
        'ig_ramp_gang',
        'g_f_y_ballas_01',
        'g_f_y_vagos_01',
        'g_m_y_ballaorig_01',
        'g_m_y_ballasout_01',
        'g_m_y_famfor_01',
    },
    ['military'] = {
        's_m_y_armymech_01',
        's_m_y_blackops_01',
        's_m_y_blackops_02',
        's_m_y_blackops_03',
        's_m_y_marine_01',
        's_m_y_marine_02',
        's_m_y_marine_03',
    },
}


cfg.general = true

-- IGNORE
-- IGNORE
-- Used to Auto Set Ids
for k,v in pairs(cfg.store.inventory) do cfg.store.inventory[k].id = k end