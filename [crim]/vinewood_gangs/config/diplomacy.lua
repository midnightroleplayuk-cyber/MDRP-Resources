Config.Diplomacy = {
    proposalHours  = 24,     -- unanswered proposals lapse after this
    maxPayment     = 500000, -- one-off payment that can be attached to a deal (clean money)
    messageLength  = 160,

    -- hours = choices offered; 0 = until someone breaks it
    types = {
        alliance     = { label = 'Alliance',        hours = { 0 } },
        ceasefire    = { label = 'Ceasefire',       hours = { 24, 48, 72 } },
        trade        = { label = 'Trade agreement', hours = { 72, 168 }, supplyDiscount = 0.10 },
        neutral_zone = { label = 'Neutral area',    hours = { 48, 168, 0 } },
    },
    maxSupplyDiscount = 0.20, -- trade deals stack up to this

    signTrust     = 10,   -- trust when a deal is signed
    honourTrust   = 10,   -- trust when a deal runs its full length
    breakTrust    = -50,  -- trust with the gang that was betrayed
    othersTrust   = -10,  -- trust with every other gang the breaker has deals with
    breakReputation = 15, -- reputation lost for breaking a deal
    announceBreaks = true, -- tell every gang when a deal is broken

    rivalBonus = 1.25,    -- influence multiplier for hostile acts against a declared rival
}
