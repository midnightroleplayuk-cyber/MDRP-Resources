--[[
  Progression: app unlock tiers + crypto economy + skill-tree unlock mirror.
  Edit thresholds / crypto payouts here without touching job scripts.
]]

Config.Progression = Config.Progression or {}

Config.Progression.JobToApp = {
    car_theft = 'boosting',
    chop_shop = 'chopshop',
    car_breakin = 'carbreakin',
    rob_npc = 'robnpc',
    delivery_weed = 'deliveryweed',
    delivery_meth = 'deliverymeth',
    delivery_coke = 'deliverycoke',
    delivery_container = 'deliverycontainer',
    corner_weed = 'cornerweed',
    corner_meth = 'cornermeth',
    corner_coke = 'cornercoke',
    corner_oxy = 'corneroxy',
    fraud = 'fraud',
    document_forgery = 'docforgery',
    atm_drilling = 'atmdrilling',
    crypto_distribution = 'cryptodistro',
    gun_smuggling = 'gunsmuggling',
    marina_smuggling = 'marinasmuggle',
    diving = 'illegaldiving',
    heli_cargo = 'helicargo',
    weapons_airdrop = 'weaponsairdrop',
    gruppe6_heist = 'gruppe6heist',
    train_heist = 'trainheist',
    dam_sabotage = 'damsabotage',
    kidnapping = 'kidnapping',
    safehouse_defense = 'safehousedefense',
    drug_lab_raid = 'druglabraid',
    getaway_driver = 'getawaydriver',
    money_laundering = 'moneylaundering',
    moonshine = 'moonshine',
    counterfeit_money = 'counterfeit',
    npc_boxing = 'npcboxing',
}

--[[
  Hard app-unlock tiers. Tier 0 is always available.
  Higher tiers unlock when minCompletions (sum of fromApps) AND optional anyNodes are met.
]]
Config.Progression.Tiers = {
    [0] = {
        label = 'Street',
        apps = {
             'cornermeth', 'cornercoke', 'corneroxy',
            'carbreakin', 'cornerweed',
        },
    },
    [1] = {
        label = 'Courier',
        apps = {
            'boosting', 'chopshop',
            'deliveryweed', 'deliverymeth', 'deliverycoke', 'deliverycontainer',
        },
        require = {
            fromApps = {
                 'cornermeth', 'cornercoke', 'corneroxy',
                'carbreakin',
            },
            minCompletions = 12,
            anyNodes = { 'cor_pitch' },
        },
    },
    [2] = {
        label = 'Specialist',
        apps = {
            'fraud', 'docforgery', 'atmdrilling', 'crypto', 'getawaydriver',
        },
        require = {
            fromApps = {
                'boosting', 'chopshop',
                'deliveryweed', 'deliverymeth', 'deliverycoke', 'deliverycontainer',
                 'cornermeth', 'cornercoke', 'corneroxy',
                'carbreakin',
            },
            minCompletions = 28,
            anyNodes = { 'chop_strip', 'del_route', 'cor_read' },
        },
    },
    [3] = {
        label = 'Operator',
        apps = {
            'gunsmuggling', 'marinasmuggle', 'illegaldiving',
            'weaponsairdrop', 'cryptodistro',
        },
        require = {
            fromApps = {
                'fraud', 'docforgery', 'atmdrilling', 'getawaydriver',
                'boosting', 'chopshop',
                'deliveryweed', 'deliverymeth', 'deliverycoke', 'deliverycontainer',
            },
            minCompletions = 20,
            anyNodes = { 'hack_decrypt', 'del_timing', 'chop_tool' },
        },
    },
    [4] = {
        label = 'Elite',
        apps = {
            'gruppe6heist', 'trainheist', 'damsabotage',
            'kidnapping', 'safehousedefense', 'druglabraid',
        },
        require = {
            fromApps = {
                'gunsmuggling', 'marinasmuggle', 'illegaldiving',
                'helicargo', 'weaponsairdrop', 'cryptodistro',
                'fraud', 'atmdrilling', 'getawaydriver',
            },
            minCompletions = 18,
            anyNodes = { 'hack_breach', 'smug_hold', 'del_runner', 'cor_turf' },
        },
    },
}

Config.Progression.AlwaysOpenApps = {
    trash = true, settings = true, vpn = true, browser = true,
    market = true, skills = true, crew = true,
    moneylaundering = true, moonshine = true, counterfeit = true, npcboxing = true,
}

--[[
  Black Market catalog → inventory item names.
  Prices are in SNC units (same as web/src/data/marketItems.js).
]]
Config.Progression.Market = {
    sncUsd = 0.42,
    coinUsd = { snc = 0.42, dnt = 1.15, xmr = 168.2 },
    --- After purchase, items are held until collected at a spawned van or contact ped.
    pickup = {
        expire_ms = 15 * 60 * 1000,
        --- 'ped' | 'van' | 'random'
        delivery_mode = 'random',
        van_model = 'rumpo',
        ped_model = 'g_m_y_mexgoon_01',
        blip = { sprite = 501, color = 1, text = 'Black Market Pickup', scale = 0.85 },
        locations = {
            vector4(139.12, -3105.88, 5.90, 270.0),
            vector4(1185.44, -2996.22, 5.90, 0.0),
            vector4(-315.88, -2780.44, 5.00, 320.0),
            vector4(1737.22, 3709.12, 34.14, 20.0),
            vector4(1962.88, 3747.44, 32.34, 210.0),
            vector4(-1095.42, -2173.88, 13.28, 45.0),
            vector4(852.12, -2113.44, 30.54, 90.0),
            vector4(2341.88, 3127.22, 48.21, 180.0),
        },
    },
    items = {
        lockpick  = { itemName = 'lockpick',       price = 2500, stock = 12 },
        fakeid    = { itemName = 'fake_id',        price = 5000, stock = 6 },
        burner    = { itemName = 'phone',          price = 1200, stock = 20 },
        vest      = { itemName = 'armor',          price = 8000, stock = 4 },
        scanner   = { itemName = 'radio',          price = 3400, stock = 9 },
        gloves    = { itemName = 'gloves',         price = 900,  stock = 18 },
        passports = { itemName = 'blank_passport', price = 12000, stock = 2 },
        drill     = { itemName = 'drill',          price = 4200, stock = 7 },
        thermite  = { itemName = 'thermite',       price = 6500, stock = 8 },
        c4        = { itemName = 'c4',             price = 7200, stock = 6 },
        still     = { itemName = 'moonshine_still', price = 5500, stock = 6 },
        mashpack  = { itemName = 'moonshine_pack',  price = 1800, stock = 10 },

        -- Money laundering lab (buy here, place in lab)
        washer_basic         = { itemName = 'washer_basic',         price = 800,  stock = 10 },
        washer_industrial    = { itemName = 'washer_industrial',    price = 1800, stock = 6 },
        washer_heavy         = { itemName = 'washer_heavy',         price = 3500, stock = 4 },
        generator_small      = { itemName = 'generator_small',      price = 1200, stock = 8 },
        generator_large      = { itemName = 'generator_large',      price = 2800, stock = 4 },
        cooling_fan          = { itemName = 'cooling_fan',          price = 450,  stock = 12 },
        cash_press           = { itemName = 'cash_press',           price = 1000, stock = 6 },
        launder_chem_basic   = { itemName = 'launder_chem_basic',   price = 50,   stock = 40 },
        launder_chem_premium = { itemName = 'launder_chem_premium', price = 120,  stock = 25 },
        fuel_can             = { itemName = 'fuel_can',             price = 35,   stock = 40 },
        repair_kit           = { itemName = 'repair_kit',           price = 80,   stock = 30 },
    },
}

--[[
  Per-job crypto (Lua job keys). cost deducted on start; reward on finishJob.
  Optional per-job override on jobs/<key>/config.lua reward table:
    reward = { ..., cryptoCost = 10, cryptoReward = { min = 5, max = 12 } }
]]
Config.Progression.Crypto = {
    -- Set to false to turn off the SNC job-start cost/reward economy entirely.
    -- Job start costs then fall back to Config.DirtyMoney / Config.CleanMoney
    -- (whichever `fallbackCurrency` below points at) instead of SNC, and job
    -- completion no longer pays out SNC reward.
    enabled = true,
    -- 'dirty' -> Config.DirtyMoney, 'clean' -> Config.CleanMoney
    fallbackCurrency = 'dirty',
    defaultBalances = { snc = 0, dnt = 0, xmr = 0 },
    dirtyMoneyPerSnc = 100,
    jobs = {
        corner_weed = { cost = 0, reward = { min = 3, max = 8 } },
        corner_meth = { cost = 0, reward = { min = 4, max = 10 } },
        corner_coke = { cost = 0, reward = { min = 5, max = 12 } },
        corner_oxy = { cost = 0, reward = { min = 4, max = 9 } },
        car_breakin = { cost = 0, reward = { min = 2, max = 6 } },
        rob_npc = { cost = 0, reward = { min = 2, max = 5 } },
        car_theft = { cost = 0, reward = { min = 8, max = 16 } },
        chop_shop = { cost = 0, reward = { min = 8, max = 15 } },
        delivery_weed = { cost = 0, reward = { min = 6, max = 12 } },
        delivery_meth = { cost = 0, reward = { min = 7, max = 14 } },
        delivery_coke = { cost = 0, reward = { min = 8, max = 16 } },
        delivery_container = { cost = 0, reward = { min = 10, max = 18 } },
        fraud = { cost = 5, reward = { min = 15, max = 28 } },
        document_forgery = { cost = 5, reward = { min = 14, max = 26 } },
        atm_drilling = { cost = 8, reward = { min = 18, max = 35 } },
        getaway_driver = { cost = 5, reward = { min = 16, max = 30 } },
        gun_smuggling = { cost = 15, reward = { min = 30, max = 55 } },
        marina_smuggling = { cost = 15, reward = { min = 32, max = 58 } },
        diving = { cost = 12, reward = { min = 28, max = 50 } },
        heli_cargo = { cost = 20, reward = { min = 40, max = 70 } },
        weapons_airdrop = { cost = 25, reward = { min = 45, max = 80 } },
        crypto_distribution = { cost = 40, reward = { min = 60, max = 100 } },
        gruppe6_heist = { cost = 50, reward = { min = 90, max = 150 } },
        train_heist = { cost = 55, reward = { min = 100, max = 170 } },
        dam_sabotage = { cost = 45, reward = { min = 85, max = 140 } },
        kidnapping = { cost = 35, reward = { min = 70, max = 120 } },
        safehouse_defense = { cost = 30, reward = { min = 65, max = 110 } },
        drug_lab_raid = { cost = 40, reward = { min = 80, max = 135 } },
        money_laundering = { cost = 0, reward = { min = 10, max = 20 } },
        moonshine = { cost = 0, reward = { min = 8, max = 16 } },
        counterfeit_money = { cost = 0, reward = { min = 8, max = 16 } },
        npc_boxing = { cost = 0, reward = { min = 5, max = 12 } },
    },
}

--[[
  Skill tree nodes unlock automatically once their `tasks` job-completion
  counts are met (see Progression.reconcileSkillUnlocks). An optional
  `grants` array on a node is paid out once, the first time that node
  unlocks for a player (Progression.payoutSkillGrants, called from
  onJobFinished) — items land straight in inventory with a notify toast.
  Grants are the primary way players obtain job tools (lockpick, drill,
  c4, grinder, anchor, moonshine_still, ...) without buying them from the
  Black Market below; the market stays available as a paid shortcut.
]]
Config.Progression.SkillTrees = {
    {
        id = 'chopshop',
        nodes = {
            { id = 'chop_strip', requires = {}, tasks = { { job = 'chopshop', count = 2 }, { job = 'carbreakin', count = 1 } },
              grants = { { item = 'lockpick', count = 2 } } },
            { id = 'chop_tool', requires = { 'chop_strip' }, tasks = { { job = 'chopshop', count = 3 }, { job = 'carbreakin', count = 2 } },
              grants = { { item = 'lockpick', count = 1 } } },
            { id = 'chop_fence', requires = { 'chop_tool' }, tasks = { { job = 'chopshop', count = 4 }, { job = 'boosting', count = 2 } } },
            { id = 'chop_crane', requires = { 'chop_fence' }, tasks = { { job = 'chopshop', count = 5 }, { job = 'carbreakin', count = 3 } },
              grants = { { item = 'drill', count = 1 } } },
            { id = 'chop_ghost', requires = { 'chop_crane' }, tasks = { { job = 'chopshop', count = 6 }, { job = 'boosting', count = 3 } },
              grants = { { item = 'lockpick', count = 2 } } },
            { id = 'chop_king', requires = { 'chop_ghost' }, tasks = { { job = 'chopshop', count = 8 }, { job = 'boosting', count = 4 } } },
        },
    },
    {
        id = 'delivery',
        nodes = {
            { id = 'del_route', requires = {}, tasks = { { job = 'deliveryweed', count = 2 }, { job = 'boosting', count = 1 } } },
            { id = 'del_stash', requires = { 'del_route' }, tasks = { { job = 'deliveryweed', count = 2 }, { job = 'deliverymeth', count = 1 } } },
            { id = 'del_timing', requires = { 'del_stash' }, tasks = { { job = 'boosting', count = 3 }, { job = 'deliverycontainer', count = 2 }, { job = 'deliveryweed', count = 3 } } },
            { id = 'del_runner', requires = { 'del_timing' }, tasks = { { job = 'deliverymeth', count = 4 }, { job = 'deliverycoke', count = 3 }, { job = 'deliverycontainer', count = 3 } } },
            { id = 'del_cover', requires = { 'del_runner' }, tasks = { { job = 'boosting', count = 5 }, { job = 'deliveryweed', count = 4 }, { job = 'deliverymeth', count = 4 } } },
            { id = 'del_king', requires = { 'del_cover' }, tasks = { { job = 'boosting', count = 6 }, { job = 'deliverycontainer', count = 4 }, { job = 'deliverycoke', count = 4 } } },
        },
    },
    {
        id = 'corner',
        nodes = {
            { id = 'cor_pitch', requires = {}, tasks = { { job = 'cornermeth', count = 1 } } },
            { id = 'cor_read', requires = { 'cor_pitch' }, tasks = { { job = 'cornerweed', count = 2 }, { job = 'cornercoke', count = 1 }, { job = 'corneroxy', count = 1 } } },
            { id = 'cor_turf', requires = { 'cor_read' }, tasks = { { job = 'cornermeth', count = 2 }, { job = 'cornercoke', count = 2 }, { job = 'cornerweed', count = 2 } } },
            { id = 'cor_bulk', requires = { 'cor_turf' }, tasks = { { job = 'corneroxy', count = 3 }, { job = 'cornermeth', count = 2 }, { job = 'cornercoke', count = 2 } },
              grants = { { item = 'moonshine_still', count = 1 } } },
            { id = 'cor_lookout', requires = { 'cor_bulk' }, tasks = { { job = 'cornerweed', count = 3 }, { job = 'cornermeth', count = 3 }, { job = 'cornercoke', count = 2 } },
              grants = { { item = 'moonshine_pack', count = 2 } } },
            { id = 'cor_boss', requires = { 'cor_lookout' }, tasks = { { job = 'cornerweed', count = 4 }, { job = 'cornermeth', count = 4 }, { job = 'cornercoke', count = 3 }, { job = 'corneroxy', count = 3 } },
              grants = { { item = 'money_sheet', count = 3 } } },
        },
    },
    {
        id = 'hacking',
        nodes = {
            { id = 'hack_decrypt', requires = {}, tasks = { { job = 'fraud', count = 2 }, { job = 'atmdrilling', count = 1 } },
              grants = { { item = 'drill', count = 1 }, { item = 'atm_hack_device', count = 1 } } },
            { id = 'hack_spoof', requires = { 'hack_decrypt' }, tasks = { { job = 'fraud', count = 2 }, { job = 'docforgery', count = 1 }, { job = 'atmdrilling', count = 1 } },
              grants = { { item = 'blank_card', count = 3 } } },
            { id = 'hack_breach', requires = { 'hack_spoof' }, tasks = { { job = 'atmdrilling', count = 2 }, { job = 'fraud', count = 2 }, { job = 'cryptodistro', count = 1 } },
              grants = { { item = 'c4', count = 2 } } },
            { id = 'hack_trace', requires = { 'hack_breach' }, tasks = { { job = 'docforgery', count = 2 }, { job = 'fraud', count = 3 }, { job = 'atmdrilling', count = 2 } },
              grants = { { item = 'fake_credit_card', count = 2 } } },
            { id = 'hack_ghost', requires = { 'hack_trace' }, tasks = { { job = 'atmdrilling', count = 3 }, { job = 'cryptodistro', count = 2 }, { job = 'docforgery', count = 2 } },
              grants = { { item = 'c4', count = 1 } } },
            { id = 'hack_root', requires = { 'hack_ghost' }, tasks = { { job = 'fraud', count = 5 }, { job = 'cryptodistro', count = 3 }, { job = 'atmdrilling', count = 4 } } },
        },
    },
    {
        id = 'smuggle',
        nodes = {
            { id = 'smug_hold', requires = {}, tasks = { { job = 'gunsmuggling', count = 2 }, { job = 'deliverycontainer', count = 1 } },
              grants = { { item = 'lockpick', count = 1 } } },
            { id = 'smug_route', requires = { 'smug_hold' }, tasks = { { job = 'marinasmuggle', count = 1 }, { job = 'gunsmuggling', count = 2 } },
              grants = { { item = 'lockpick', count = 1 } } },
            { id = 'smug_dive', requires = { 'smug_route' }, tasks = { { job = 'illegaldiving', count = 2 }, { job = 'marinasmuggle', count = 1 } },
              grants = { { item = 'anchor', count = 1 } } },
            { id = 'smug_air', requires = { 'smug_dive' }, tasks = { { job = 'helicargo', count = 2 }, { job = 'weaponsairdrop', count = 1 } },
              grants = { { item = 'grinder', count = 1 } } },
            { id = 'smug_ghost', requires = { 'smug_air' }, tasks = { { job = 'gunsmuggling', count = 3 }, { job = 'helicargo', count = 2 }, { job = 'marinasmuggle', count = 2 } },
              grants = { { item = 'anchor', count = 1 } } },
            { id = 'smug_king', requires = { 'smug_ghost' }, tasks = { { job = 'weaponsairdrop', count = 3 }, { job = 'helicargo', count = 3 }, { job = 'illegaldiving', count = 3 } } },
        },
    },
}


Config.Progression.AppTierOverride = {
    -- appId = tier number (0-4)
}

do
    local overrides = Config.Progression.AppTierOverride
    local tiers = Config.Progression.Tiers
    if overrides and tiers then
        for appId, targetTier in pairs(overrides) do
            if tiers[targetTier] then
                -- Remove appId from whichever tier currently lists it
                for _, tierDef in pairs(tiers) do
                    if tierDef.apps then
                        for i = #tierDef.apps, 1, -1 do
                            if tierDef.apps[i] == appId then
                                table.remove(tierDef.apps, i)
                            end
                        end
                    end
                end
                -- Add it to the target tier (skip if already present)
                tiers[targetTier].apps = tiers[targetTier].apps or {}
                local alreadyThere = false
                for _, existing in ipairs(tiers[targetTier].apps) do
                    if existing == appId then
                        alreadyThere = true
                        break
                    end
                end
                if not alreadyThere then
                    tiers[targetTier].apps[#tiers[targetTier].apps + 1] = appId
                end
            else
                print(('[progression] AppTierOverride: tier %s does not exist for app "%s"'):format(tostring(targetTier), appId))
            end
        end
    end
end
