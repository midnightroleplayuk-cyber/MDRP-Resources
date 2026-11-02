Config.Discipline = {
    -- Charges follow Prison Rule 51 (wording paraphrased)
    Charges = {
        { code = '51(1)',  text = 'Commits an assault' },
        { code = '51(4)',  text = 'Fights with any person' },
        { code = '51(7)',  text = 'Escapes or absconds' },
        { code = '51(9)',  text = 'Administers or uses a controlled drug' },
        { code = '51(12)', text = 'Has an unauthorised article' },
        { code = '51(16)', text = 'Sets fire to any part of the prison' },
        { code = '51(17)', text = 'Destroys or damages property' },
        { code = '51(20)', text = 'Uses threatening, abusive or insulting words or behaviour' },
        { code = '51(22)', text = 'Disobeys a lawful order' },
        { code = '51(23)', text = 'Fails to comply with a rule or regulation' },
        { code = '51(25)', text = 'Attempts, incites or assists any of the above' },
    },

    -- Limits for each punishment a governor can give at a hearing
    Punishments = {
        caution               = { enabled = true },
        loss_of_privileges    = { enabled = true, maxHours = 72 },   -- privileges as Basic while active
        stoppage_of_earnings  = { enabled = true, maxHours = 72, maxPercent = 50 },
        canteen_ban           = { enabled = true, maxHours = 72 },
        cellular_confinement  = { enabled = true, maxMinutes = 60 }, -- held in segregation
        additional_days       = { enabled = true, maxMinutes = 120, node = 'adjudication.additional_days' },
    },

    ProvenBehaviourPoints = -2,   -- behaviour entry when a charge is proven
    SegregationMaxMinutes = 240,  -- longest a manager can place someone in segregation in one go
}
