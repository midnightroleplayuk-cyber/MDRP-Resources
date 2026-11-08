Config.Informants = {
    item = 'burner_phone',   -- used to call the handler (ox_inventory: use the client export useBurner)
    command = false,         -- or a command name, e.g. 'burner', if you don't want an item

    maxTipsPerDay = 5,
    reliableAfter = 5,       -- tips before the source is graded 1 (reliable) instead of 2 (untested)

    -- pay = cash to the informant; cooldown = minutes before they can pass that kind again;
    -- targetHours = how long before anyone can leak the same target again
    tips = {
        safehouse  = { pay = 2500, cooldown = 60, targetHours = 24, grade = 'A' },
        enterprise = { pay = 3000, cooldown = 60, targetHours = 24, grade = 'A' },
        rackets    = { pay = 1500, cooldown = 90, targetHours = 12, grade = 'B' },
        member     = { pay = 1000, cooldown = 30, targetHours = 24, grade = 'B' },
        run        = { pay = 2000, cooldown = 45, targetHours = 1,  grade = 'A' },
    },

    suspicionChance  = 0.35,        -- share of tips gang leaders get a suspicious-activity report about
    reportDelay      = { 5, 20 },   -- minutes before that report arrives
    investigateCost  = 10000,       -- dirty money to look into a leak
    investigateAccuracy = 0.7,      -- chance the real informant is on the shortlist
    shortlistSize    = 3,

    handlingCode = 'C',  -- 3x5x2 handling code for informant intelligence (conditions apply)
}
