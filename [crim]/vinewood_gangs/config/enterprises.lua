Config.Enterprises = {
    tickMinutes  = 10,    -- production, wages and street sales run this often
    marketMinutes = 60,   -- wholesale prices move this often
    marketSwing  = 0.15,  -- prices drift up to this far either side of normal
    maxStaff     = 4,
    staffBonus   = 0.25,  -- each member of staff adds this much to production
    raidSeizure  = { product = 1.0, supplies = 0.5 }, -- share seized when police raid the safehouse

    -- Street distribution sells this many units per hour in every area the gang holds
    streetPerArea = 6,

    types = {
        weed = {
            label = 'Weed grow', product = 'bags of weed', supplies = 'grow supplies',
            setup = 40000,               -- clean treasury
            rate = 20,                   -- units per hour at level 1 with no staff
            suppliesPerUnit = 1,
            maxSupplies = 400, maxProduct = 600,
            wholesale = 110, street = 170, -- per unit, dirty money
            supplyCost = 35,             -- per unit of supplies when collected
            staffWage = 120,             -- per member of staff per hour, dirty
            heatPerUnit = 0.02,
            levels = { { price = 0, rate = 1.0 }, { price = 25000, rate = 1.5 }, { price = 60000, rate = 2.2 } },
        },
        coke = {
            label = 'Cocaine lab', product = 'grams of cocaine', supplies = 'precursor chemicals',
            setup = 90000, rate = 12, suppliesPerUnit = 2,
            maxSupplies = 400, maxProduct = 300,
            wholesale = 320, street = 480, supplyCost = 70, staffWage = 220, heatPerUnit = 0.06,
            levels = { { price = 0, rate = 1.0 }, { price = 45000, rate = 1.5 }, { price = 110000, rate = 2.2 } },
        },
        counterfeit = {
            label = 'Counterfeit cash', product = 'bundles of fake notes', supplies = 'paper and ink',
            setup = 60000, rate = 10, suppliesPerUnit = 1,
            maxSupplies = 200, maxProduct = 200,
            wholesale = 260, street = nil, -- can't be sold on the street
            supplyCost = 90, staffWage = 160, heatPerUnit = 0.03,
            levels = { { price = 0, rate = 1.0 }, { price = 35000, rate = 1.5 }, { price = 80000, rate = 2.2 } },
        },
    },
}

Config.Supply = {
    deliveryMarkup  = 1.5,   -- delivery costs this much more than collecting
    deliveryMinutes = 30,
    seizureChance   = 0.08,  -- police intercept a delivery
    collectWindow   = 60,    -- minutes to start a collection run once ordered
    runMinutes      = 20,    -- minutes to get the van home once collected
    tipChance       = 0.4,   -- chance each rival gang with someone online hears about a run
    tipMinutes      = 8,     -- how long tipped-off rivals can see the van
    fenceShare      = 0.6,   -- rivals who steal a load get this share of its value
    vans = { 'burrito3', 'speedo', 'rumpo', 'youga' },
    pickups = 'general',     -- location pool from config/contracts.lua
}
