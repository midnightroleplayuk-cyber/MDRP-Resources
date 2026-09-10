Config = Config or {}

Config.PrescriptionBranding = {
    hospitalName = 'Los Santos Medical Center',
    hospitalAddress = '124 Capital Boulevard, Los Santos',
    hospitalPhone = 'Tel: (555) 123-4567',
    hospitalCertId = 'LSMB-54289',
}

Config.PrescriptionExpiryDays = 2
Config.PrescriptionIdPrefix = 'RX'

Config.PharmacyNPCModel = 's_m_m_doctor_01'
Config.PharmacyNPCScenario = 'WORLD_HUMAN_CLIPBOARD'

-- Over-the-counter items anyone can buy at the pharmacy NPC (no prescription required)
Config.PharmacyOTCMaxAmount = 10
Config.PharmacyOTCItems = {
    {
        label = 'Elastic Bandage',
        name = 'elastic_bandage',
        price = 25,
        icon = 'fa-solid fa-bandage',
    },
    {
        label = 'Tourniquet',
        name = 'tourniquet',
        price = 50,
        icon = 'fa-solid fa-kit-medical',
    },
    {
        label = 'Paracetamol',
        name = 'paracetamol',
        price = 50,
        icon = 'fa-solid fa-pills',
    },
}

Config.DiseaseSpread = {
    enabled = true,                     -- Master toggle for random infection and player-to-player spread
    randomCheckInterval = 20*60*1000,       -- How often (ms) the server rolls for random disease acquisition per player
    randomAcquireChance = 0.02,         -- Default chance (0.0-1.0) per check when a condition has no randomAcquireChance set
    spreadCheckInterval = 30*1000,        -- How often (ms) contagious players are checked for nearby targets
    spreadRadius = 4.0,                 -- Distance (meters) required to spread a contagious disease
    spreadChance = 0.3,                -- Default spread chance (0.0-1.0) per check when near an infected player
    notifyOnInfection = true,           -- Notify players when they contract a disease
    notifyOnRecovery = true,            -- Notify players when a disease naturally expires
    immunityAfterRecovery = 3600,       -- Seconds of immunity after recovering (0 = disabled)

    -- Clothing that stops the wearer from spreading contagious diseases, and from catching them from others.
    -- type: 'component' (default) or 'prop'
    -- category: GTA clothing component (1 = masks, 7 = accessories, 8 = undershirt, 11 = tops)
    --           or prop index when type = 'prop' (0 = hats, 1 = glasses)
    -- ids: drawable IDs that count as protective. Leave empty {} to accept any worn item on that category (except none).
    -- Optional maleIds / femaleIds override ids for mp_m_freemode_01 / mp_f_freemode_01.
    protectiveMasks = {
        { category = 1, ids = {} }, -- any mask (component 1)
        -- { category = 1, ids = { 51, 52, 53, 54, 169 } }, -- only specific mask drawables
        -- { type = 'prop', category = 0, ids = { 18 } }, -- hat prop example
        -- { category = 8, maleIds = { 151 }, femaleIds = { 187 } }, -- undershirt-style mask
    },
}

Config.PrescriptionConditions = {
    -- Contagious cough/cold-style illness. Spreads to nearby players and can be
    -- cured completely by cough syrup (curesCondition = true on that medication).
    {
        enabled = true,                 -- Set to false to disable this condition entirely
        id = 'respiratory_infection',
        label = 'Respiratory Infection',
        symptomInterval = 45*1000,        -- Cough symptom every 45 seconds
        effects = {
            coughAnim = true,           -- Plays cough animation + sound on symptom tick
        },
        requiresPrescription = true,
        contagious = true,              -- Can infect nearby players within DiseaseSpread.spreadRadius
        canRandomlyAcquire = true,      -- Eligible for random acquisition rolls
        randomAcquireChance = 0.025,    -- 2.5% chance per random check
        spreadChance = 0.18,            -- 18% chance per spread check when near an infected player
        duration = 3*60*60,                 -- Natural recovery after 2 hours (nil = does not expire)
    },

    -- Non-contagious pain flares. Medications typically suppress symptoms rather
    -- than permanently cure (see curesCondition on each medication).
    {
        enabled = true,
        id = 'acute_pain',
        label = 'Acute Pain',
        symptomInterval = 60*1000,        -- Pain flare every 60 seconds
        effects = {
            painPulse = true,           -- Adds pain on symptom tick
            painAmount = 2.0,           -- Pain points added per flare (scale roughly 0-10)
        },
        requiresPrescription = true,
        contagious = false,
        canRandomlyAcquire = true,
        randomAcquireChance = 0.015,
        duration = 3*60*60,                 -- Natural recovery after 3 hours
    },

    -- Non-contagious anxiety. Causes camera shake and optional stress HUD gain.
    {
        enabled = true,
        id = 'anxiety',
        label = 'Anxiety',
        symptomInterval = 50000,        -- Anxiety symptom every 50 seconds
        effects = {
            cameraShake = true,         -- Mild gameplay camera shake
            stressAmount = 5,           -- Stress added to HUD systems that listen for GainStress
        },
        requiresPrescription = true,
        contagious = false,
        canRandomlyAcquire = true,
        randomAcquireChance = 0.02,
        duration = 3*60*60,                -- Natural recovery after 3 hours
    },

    -- Non-contagious insomnia / fatigue. Reduces sprint ability and drains stamina.
    {
        enabled = true,
        id = 'insomnia',
        label = 'Insomnia',
        symptomInterval = 90*1000,        -- Fatigue symptom every 90 seconds
        effects = {
            staminaDrain = true,        -- Drains stamina and applies sprintMultiplier
            sprintMultiplier = 0.6,     -- Sprint speed multiplier while symptom is active (1.0 = normal)
        },
        requiresPrescription = true,
        contagious = false,
        canRandomlyAcquire = true,
        randomAcquireChance = 0.015,
        duration = 3*60*60,                -- Natural recovery after 3 hours
    },
}

Config.PrescriptionMedications = { -- Medication used to treat diseases/conditions
    -- suppressionDuration: seconds symptoms stay suppressed after a dose
    -- recoveryReduction: seconds shaved off remaining condition duration per dose
    {
        id = 'cough_syrup',
        label = 'Cough Syrup',
        itemName = 'cough_syrup',
        treatsConditions = { 'respiratory_infection' },
        suppressionDuration = 10*60,
        recoveryReduction = 30*60,      -- Speeds recovery by 30 minutes per dose
        curesCondition = false,
        maxQuantity = 10,
        doseLabel = 'Doses',
        price = 35, -- Cost per dose when redeeming at pharmacy
        prop = 'v_club_vu_pills',
    },
    {
        id = 'paracetamol',
        label = 'Paracetamol',
        itemName = 'paracetamol',
        treatsConditions = { 'acute_pain' },
        suppressionDuration = 10*60,
        recoveryReduction = 30*60,      -- Speeds recovery by 30 minutes per dose
        curesCondition = false,
        maxQuantity = 10,
        doseLabel = 'Doses',
        price = 25,
        prop = 'v_club_vu_pills',
        effects = {
            painReduce = 0.5,               -- Slightly reduces pain
            healthRestore = 5,
        },
    },
    {
        id = 'tramadol',
        label = 'Tramadol',
        itemName = 'tramadol',
        treatsConditions = { 'acute_pain' },
        suppressionDuration = 15*60,
        recoveryReduction = 45*60,      -- Speeds recovery by 45 minutes per dose
        curesCondition = false,
        maxQuantity = 10,
        doseLabel = 'Doses',
        price = 85,
        prop = 'v_club_vu_pills',
        effects = {
            painReduce = 2.0,               -- Moderate pain relief
            healthRestore = 10,
            stressRelief = 30,
            drowsiness = {
                duration = 60,             -- Seconds
                sprintMultiplier = 0.85,
                timecycle = 'spectator5',
                timecycleStrength = 0.2,
            },
        },
    },
    {
        id = 'vicodin',
        label = 'Vicodin',
        itemName = 'vicodin',
        treatsConditions = { 'acute_pain' },
        suppressionDuration = 20*60,
        recoveryReduction = 60*60,      -- Speeds recovery by 1 hour per dose
        curesCondition = false,
        maxQuantity = 10,
        doseLabel = 'Doses',
        price = 150,
        prop = 'v_club_vu_pills',
        effects = {
            painReduce = 5.0,               -- Strong pain relief
            healthRestore = 15,
            stressRelief = 50,
            drowsiness = {
                duration = 180,
                sprintMultiplier = 0.7,
                timecycle = 'spectator5',
                timecycleStrength = 0.35,
            },
            slowHeartbeat = true,
            hrDecrease = 30,
        },
    },
    {
        id = 'xanax',
        label = 'Xanax',
        itemName = 'xanax',
        treatsConditions = { 'anxiety' },
        suppressionDuration = 15*60,
        recoveryReduction = 45*60,      -- Speeds recovery by 45 minutes per dose
        curesCondition = false,
        maxQuantity = 10,
        doseLabel = 'Doses',
        price = 60,
        prop = 'v_club_vu_pills',
    },
    {
        id = 'melatonin',
        label = 'Melatonin',
        itemName = 'melatonin',
        treatsConditions = { 'insomnia' },
        suppressionDuration = 20*60,
        recoveryReduction = 45*60,      -- Speeds recovery by 45 minutes per dose
        curesCondition = false,
        maxQuantity = 10,
        doseLabel = 'Doses',
        price = 40,
        prop = 'v_club_vu_pills',
    },
}

