-- Every criminal action goes through Activity.Record(). This table decides what it is worth.
-- influence      : added to the acting gang in the zone
-- heat           : added to the gang (and member, if known)
-- rivalInfluence : applied to data.targetGangId in the same zone (negative = damage)
Config.Activities = {
    drug_sale         = { influence = 2.0,   heat = 1.5 }, -- per unit; what it does to hex control is in config/hexes.lua
    intimidation      = { influence = 3.0,   heat = 2.0 },
    graffiti_tag      = { influence = 5.0,   heat = 0.5 },
    graffiti_cross    = { influence = 3.0,   heat = 0.5, rivalInfluence = -6.0 },
    graffiti_cleaned  = { influence = 0.0,   heat = 0.0, rivalInfluence = -4.0 },
    contract_complete = { influence = 4.0,   heat = 1.0 },
    contract_failed   = { influence = -2.0,  heat = 2.0 },
    racket_agreed     = { influence = 4.0,   heat = 1.0 },
    racket_takeover   = { influence = 4.0,   heat = 2.0, rivalInfluence = -5.0 },
    racket_payment    = { influence = 3.0,   heat = 1.0 }, -- per period collected
    racket_refused    = { influence = -1.0,  heat = 3.0 },
    police_raid       = { influence = -25.0, heat = -10.0 },
    heist_complete    = { influence = 20.0,  heat = 25.0 },
    heist_failed      = { influence = -5.0,  heat = 10.0 },
}
