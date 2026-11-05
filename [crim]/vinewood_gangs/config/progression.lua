Config.Progression = {
    enabled = true,     -- false: every gang has everything from the start

    -- A gang keeps a tier while its reputation stays above this share of the tier's requirement.
    -- Below it they drop back: what they own keeps working, but they can't start anything new at that level.
    keepShare = 0.7,

    -- Milestone types: contracts, tags (cumulative); members, areas, safehouses (right now);
    -- area_hours (hours of area control, one per area per hour); racket_income, enterprise_income (money, cumulative)
    tiers = {
        { label = 'Street crew', reputation = 0, milestones = {}, unlocks = {} },
        { label = 'Firm', reputation = 100,
          milestones = { { type = 'contracts', need = 5 }, { type = 'tags', need = 10 }, { type = 'members', need = 3 } },
          unlocks = { 'rackets', 'safehouses', 'contracts_medium' } },
        { label = 'Organisation', reputation = 400,
          milestones = { { type = 'areas', need = 1 }, { type = 'area_hours', need = 12 }, { type = 'racket_income', need = 15000 }, { type = 'safehouses', need = 1 } },
          unlocks = { 'enterprises', 'diplomacy', 'second_safehouse', 'heists' } },
        { label = 'Syndicate', reputation = 1000,
          milestones = { { type = 'areas', need = 2 }, { type = 'contracts', need = 30 }, { type = 'enterprise_income', need = 150000 } },
          unlocks = { 'auctions', 'contracts_high' } },
    },

    -- Reputation per activity (multiplied like influence). victim = applied to the gang on the receiving end.
    -- Contracts and crew bounties already give reputation by difficulty; broken deals take it away.
    reputation = {
        graffiti_tag    = { gain = 0.5 },
        graffiti_cross  = { gain = 1.0, victim = -0.5 },
        contract_failed = { gain = -2 },
        racket_agreed   = { gain = 2 },
        racket_takeover = { gain = 3, victim = -2 },
        racket_payment  = { gain = 0.5 },
        drug_sale       = { gain = 0.1 },
        police_raid     = { gain = -15 },
        heist_complete  = { gain = 25 },
        heist_failed    = { gain = -5 },
    },
    areaHourReputation = 1, -- per area held, per hour
}
