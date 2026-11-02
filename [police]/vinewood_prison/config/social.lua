Config.Visits = {
    Phases = { 'assoc', 'evening' },   -- regime phases that are visiting sessions
    Duration = 600,                    -- seconds a visit lasts (ends earlier if the session ends)
    Allowance = { basic = 1, standard = 2, enhanced = 3 },  -- social visits per regime day / week
    RequireApproval = false,           -- staff approve each booking on the tablet
    LegalJobs = { 'lawyer', 'solicitor' },  -- visitors in these jobs book legal visits (no allowance, never monitored)
    TableDepth = 1.6,                  -- metres from the prisoner's seat to the visitor's seat
    DogChance = 0.3,                   -- chance the drug dog flags a visitor carrying contraband at check-in
    PassDetectChance = 0.35,           -- chance staff spot an item being passed
    BanDays = 7,                       -- visitor ban after being caught
    NPCVisits = {
        enabled = true,                -- prisoners with no visitors can book a family visit at the kiosk
        models = { 'a_f_m_bevhills_02', 'a_m_m_business_01', 'a_f_y_eastsa_03', 'a_m_y_stwhi_02' },
    },
}

Config.Phone = {
    PinLength = 4,
    CostPerMinute = 1,                 -- deducted from phone credit
    CreditItems = { 5, 10, 20 },       -- credit amounts prisoners can buy from spends at the kiosk
    MaxContacts = 10,
    ApproveContacts = 'no_staff',      -- 'always' | 'no_staff' | 'never' (as industries)
    Monitor = 'random',                -- 'all' | 'random' | 'none'; legal contacts are never monitored
    MonitorChance = 0.3,
    RingSeconds = 25,
    -- Ring the person's real phone with the prison as the caller (LB Phone). Other phones use the pop-up.
    NativeCalls = true,
    CallChannelBase = 7400,            -- pma-voice call channels used for prison calls
}

Config.Gangs = {
    CreateRep = 20,                    -- reputation needed to start a gang
    MaxGangs = 4,                      -- per prison
    MaxMembers = 8,
    TerritoryTick = 120,               -- seconds between territory counts
    ControlPoints = 3,                 -- consecutive wins needed to take a territory
    InfluencePerTick = 1,              -- influence for each territory held, per tick
    MarketDiscount = 0.2,              -- members pay 20% less at markets inside their territory
    Rep = { fightWin = 2, fightLoss = -1, territoryHeld = 1, contraband = 1 },
    TensionAlert = true,               -- rival gangs in the same territory notify security staff
}

Config.Healthcare = {
    -- Non-prison jobs and the nodes they get while on duty
    Jobs = { ambulance = { 'roster.view', 'healthcare.view', 'healthcare.manage', 'alarm.raise', 'welfare.manage' } },
    Categories = { 'GP', 'Nurse', 'Dental', 'Mental health', 'Pharmacy', 'Optician' },
    MedsRounds = { 'unlock', 'tea' },  -- regime phases with a medication round
    MedsItem = nil,                    -- optional ox_inventory item handed over with each dose
    WelfareIntervals = { 30, 60, 120 },-- minutes between observations a plan can require
}
