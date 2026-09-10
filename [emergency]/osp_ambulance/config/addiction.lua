Config = Config or {}

Config.Addiction = {
    enabled = true,
    checkInterval = 1000,
    notifyOnAddiction = true,
    notifyOnRecovery = true,
    overdoseCheckInterval = 5000,
    recoveryCheckInterval = 30000,
}

Config.Narcan = {
    itemName = 'narcan',
    reversesClasses = { 'opioid' },
}

Config.AddictiveDrugs = {
    {
        id = 'morphine',
        label = 'Morphine',
        itemNames = { 'morphine' },
        source = 'ems',
        addictionChancePerUse = 0.20,
        usesToBecomeAddicted = 2,
        cravingInterval = 1200,
        withdrawalGracePeriod = 2400,
        withdrawalStages = {
            { afterSeconds = 2400,  tempIncrease = 1.3, sprintMultiplier = 0.9,  aimPenalty = false, heartbeat = false, healthDrain = 0, vomitChance = 0.0 },
            { afterSeconds = 4800,  tempIncrease = 1.6, sprintMultiplier = 0.85, aimPenalty = false, heartbeat = true,  healthDrain = 0, vomitChance = 0.0 },
            { afterSeconds = 9000,  tempIncrease = 2.2, sprintMultiplier = 0.75, aimPenalty = false, heartbeat = true,  healthDrain = 1, vomitChance = 0.12 },
        },
        recoveryAfterAbstinence = 72000,
        overdose = {
            maxDose = 3,
            doseWindowSeconds = 18000,
            narcanWindowSeconds = 300,
            passOutOnOverdose = true,
        },
        treatsWithdrawal = true,
        sharedClass = 'opioid',
    },
    {
        id = 'vicodin',
        label = 'Vicodin',
        itemNames = { 'vicodin' },
        source = 'prescription',
        addictionChancePerUse = 0.12,
        usesToBecomeAddicted = 4,
        cravingInterval = 1500,
        withdrawalGracePeriod = 3600,
        withdrawalStages = {
            { afterSeconds = 3600,  tempIncrease = 1.2, sprintMultiplier = 0.92, aimPenalty = false, heartbeat = false, healthDrain = 0, vomitChance = 0.0 },
            { afterSeconds = 7200,  tempIncrease = 1.5, sprintMultiplier = 0.88, aimPenalty = false, heartbeat = true,  healthDrain = 0, vomitChance = 0.0 },
            { afterSeconds = 12000, tempIncrease = 2.0, sprintMultiplier = 0.80, aimPenalty = false, heartbeat = true,  healthDrain = 1, vomitChance = 0.08 },
        },
        recoveryAfterAbstinence = 108000,
        overdose = {
            maxDose = 4,
            doseWindowSeconds = 36000,
            narcanWindowSeconds = 300,
            passOutOnOverdose = true,
        },
        treatsWithdrawal = true,
        sharedClass = 'opioid',
    },
    {
        id = 'tramadol',
        label = 'Tramadol',
        itemNames = { 'tramadol' },
        source = 'prescription',
        addictionChancePerUse = 0.08,
        usesToBecomeAddicted = 5,
        cravingInterval = 1800,
        withdrawalGracePeriod = 4800,
        withdrawalStages = {
            { afterSeconds = 4800,  tempIncrease = 1.2, sprintMultiplier = 0.93, aimPenalty = false, heartbeat = false, healthDrain = 0, vomitChance = 0.0 },
            { afterSeconds = 9000,  tempIncrease = 1.4, sprintMultiplier = 0.90, aimPenalty = false, heartbeat = true,  healthDrain = 0, vomitChance = 0.0 },
            { afterSeconds = 15000, tempIncrease = 1.8, sprintMultiplier = 0.82, aimPenalty = false, heartbeat = true,  healthDrain = 1, vomitChance = 0.06 },
        },
        recoveryAfterAbstinence = 144000,
        overdose = {
            maxDose = 5,
            doseWindowSeconds = 36000,
            narcanWindowSeconds = 300,
            passOutOnOverdose = true,
        },
        treatsWithdrawal = true,
        sharedClass = 'opioid',
    },
}
