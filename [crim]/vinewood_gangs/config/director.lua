Config.Director = {
    intervalMinutes = { 30, 60 }, -- a new event is considered somewhere in this window
    maxActive  = 3,
    minPlayers = 1,               -- nothing starts on an empty server

    kinds = {
        shortage   = { weight = 3, minutes = 90, cooldown = 120, costMult = 1.5 },
        boom       = { weight = 2, minutes = 60, cooldown = 120, priceMult = 1.35 },
        crash      = { weight = 2, minutes = 60, cooldown = 120, priceMult = 0.70 },
        crackdown  = { weight = 3, minutes = 60, cooldown = 90,  heatMult = 2.0, witnessMult = 2.0 },
        crew       = { weight = 3, minutes = 90, cooldown = 120, strength = 60, pressure = 3.0,
                       bounty = 15000, reputation = 10, lossOnFail = 30 },
        drop       = { weight = 2, minutes = 20, cooldown = 90, value = { 8000, 20000 },
                       vans = { 'mule', 'pony', 'burrito3' } },
        undercover = { weight = 1, minutes = 120, cooldown = 240, heatMult = 1.5, minHeat = 30 },
        hotwork    = { weight = 2, minutes = 60, cooldown = 120, rewardMult = 1.5 },
    },

    -- Fewer gangs online makes PvE events (crews, hot work) more likely than PvP ones (drops)
    quietBoost = { crew = 2.0, hotwork = 1.5, drop = 0.5 },
}
