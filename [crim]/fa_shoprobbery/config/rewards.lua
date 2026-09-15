Rewards = {}

-- Stores use tier 1 by default.
-- Set `tier = 2` or `rewardTier = 2` in a store to use Rewards.Register[2], Rewards.Shelf[2] and Rewards.Safe[2].

Rewards.Register = {
    [1] = {
        { type = 'dirty', account = 'dirty', min = 250, max = 850, chance = 100 }
    },
    [2] = {
        { type = 'dirty', account = 'dirty', min = 450, max = 1200, chance = 100 }
    }
}

Rewards.Shelf = {
    [1] = {
        { type = 'item', name = 'cigarettes', min = 1, max = 3, chance = 60 },
        { type = 'item', name = 'lighter', min = 1, max = 2, chance = 35 },
        { type = 'item', name = 'scratch_ticket', min = 1, max = 4, chance = 45 },
        { type = 'item', name = 'beer', min = 1, max = 3, chance = 40 }
    },
    [2] = {
        { type = 'item', name = 'cigarettes', min = 2, max = 4, chance = 65 },
        { type = 'item', name = 'lighter', min = 1, max = 2, chance = 40 },
        { type = 'item', name = 'scratch_ticket', min = 2, max = 5, chance = 50 },
        { type = 'item', name = 'beer', min = 2, max = 4, chance = 45 }
    }
}

Rewards.Safe = {
    [1] = {
        { type = 'money', account = 'dirty', min = 2500, max = 8500, chance = 100 },
        { type = 'item', name = 'rolex', min = 1, max = 4, chance = 18 },
        { type = 'item', name = 'goldbar', min = 1, max = 1, chance = 4 }
    },
    [2] = {
        { type = 'money', account = 'dirty', min = 4500, max = 11500, chance = 100 },
        { type = 'item', name = 'rolex', min = 2, max = 5, chance = 22 },
        { type = 'item', name = 'goldbar', min = 1, max = 2, chance = 6 }
    }
}

Rewards.PoliceMultiplier = {
    Enabled = true,
    PerOfficer = 0.08,
    MaxMultiplier = 1.5
}
