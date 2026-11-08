-- The black market. Staff can close it and change all of this in game: /gangadmin > Black market (and its settings tab).
Config.Auctions = {
    intervalMinutes = { 90, 180 }, -- between auctions
    biddingMinutes  = 15,
    lotsPerAuction  = { 2, 3 },
    minPlayers      = 2,
    increment       = 0.05,  -- each bid at least 5% over the last (and at least 500)
    antiSnipe       = 60,    -- seconds: a bid this close to the end extends it by this much
    buyNowMultiplier = 2.5,  -- of the reserve
    bidPermission   = 'treasury_withdraw',

    -- Lot types, weights and how their reserve price is set
    lots = {
        supplies   = { weight = 3, amount = { 150, 300 }, reservePerUnit = 0.6 }, -- reserve = amount x supply cost x this
        contract   = { weight = 2, rewardMultiplier = 2.5, reserve = { 6000, 12000 } },
        copper     = { weight = 2, heat = 40, reserve = { 15000, 30000 } },
        connections = { weight = 2, influence = 15, reserve = { 10000, 25000 } }, -- influence = % control added to the winner's weakest hex
        items      = { weight = 3 }, -- only offered if Config.Auctions.items has entries
    },

    -- Rare contraband. Item names must exist in YOUR inventory; examples:
    --   { item = 'WEAPON_PISTOL50', label = 'Desert Eagle', count = 1, reserve = 20000 },  -- ox_inventory naming
    --   { item = 'weapon_pistol50', label = 'Desert Eagle', count = 1, reserve = 20000 },  -- qb-inventory naming
    --   { item = 'armour', label = 'Body armour', count = 5, reserve = 6000 },
    items = {},

    dropMinutes  = 30,    -- the winner has this long to collect contraband from the dead drop
    headStart    = 120,   -- seconds before tipped-off rivals hear where the drop is
    tipChance    = 0.35,  -- chance each other gang with someone online is tipped off
    unclaimedRefund = 0.5, -- share of the price refunded if a drop isn't collected by anyone
}
