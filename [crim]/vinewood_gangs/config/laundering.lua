Config.Laundering = {
    enabled = true,

    -- Ways to turn dirty money into clean. cut = share kept by whoever washes it.
    methods = {
        cleaner = {
            label = 'A cleaner', cut = 0.30, minutes = 30, min = 1000,
            dailyLimit = 25000,       -- per gang, rolling 24 hours
            leadChance = 0.10,        -- per £10,000 washed, chance the police get a financial lead
            description = 'Someone who asks no questions. Expensive, but anyone can use them.',
        },
        fronts = {
            label = 'Your protected businesses', cut = 0.12, minutes = 60, min = 1000,
            perBusiness = 6000,       -- per shop paying you protection, per day
            leadChance = 0.05,
            needs = 'rackets',        -- gang tier feature needed (see config/progression.lua)
            description = 'Run it through the tills of shops that pay you. Cheaper, and less likely to be noticed.',
        },
    },

    heatPer1000 = 0.3,  -- heat added per £1,000 washed
}
