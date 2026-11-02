Config.AI = {
    -- Client-side peds at editor points: cheap, no network sync, only near players
    OfficerModel = 's_m_m_prisguard_01',
    InmateModel = 's_m_y_prisoner_01',
    SpawnDistance = 70.0,
    MaxOfficers = 8,               -- per client
    MaxInmates = 12,               -- per client
    InmateScenarios = { 'WORLD_HUMAN_SMOKING', 'WORLD_HUMAN_HANG_OUT_STREET', 'WORLD_HUMAN_LEANING', 'WORLD_HUMAN_STAND_IMPATIENT', 'WORLD_HUMAN_PUSH_UPS', 'WORLD_HUMAN_SIT_UPS' },
    OfficerScenarios = { 'WORLD_HUMAN_CLIPBOARD', 'WORLD_HUMAN_GUARD_STAND', 'WORLD_HUMAN_COP_IDLES' },

    -- Automated incident response when no staff are on duty
    ResponseSeconds = 45,
    FightCharge = '51(4)',
}

Config.Transport = {
    Vehicle = 'policet',
    MaxMinutes = 30,               -- escorts out longer than this alert staff
    ContractorSeconds = 20,        -- automated transfers when nobody can escort
    EscortLeash = 50.0,            -- an escorted prisoner further than this from any officer is escaping
    Destinations = {
        { id = 'court',    label = 'Crown Court',      kind = 'court',    coords = vec4(-544.7, -204.3, 38.2, 210.0) },
        { id = 'hospital', label = 'Pillbox Hospital', kind = 'hospital', coords = vec4(298.6, -584.5, 43.3, 70.0) },
    },
}

Config.Escape = {
    -- 'contain': prisoners outside the boundary are returned to their cell (Phase 1 behaviour)
    -- 'escape' : leaving the boundary is an escape, with alarms, dispatch and recapture
    Mode = 'escape',
    GraceSeconds = 5,
    Lockdown = true,                 -- lock the prison down when someone escapes
    AdditionalMinutes = 60,          -- added to the release date on recapture
    CategoryAfter = 'B',             -- security category after recapture
    SegregationMinutes = 20,         -- held in segregation after recapture (0 = no)
    VoluntaryReturnDiscount = 0.5,   -- handing yourself in halves the additional time

    -- Lockpicking doors from the inside
    LockpickItem = 'lockpick',
    PickSeconds = 8,                 -- how long a picked door stays open
    BreakChance = 0.35,
    AlarmChance = 0.25,

    -- Jobs outside the prison service that can recapture and escort
    PoliceJobs = { police = { 'escape.recapture', 'transport.escort' } },
}

Config.Parole = {
    MinTermMinutes = 120,            -- only sentences at least this long can apply
    EligibleFraction = 0.3,          -- eligible after serving this share of the term
    RetryMinutes = 60,               -- after a refusal
    AutoDecideMinutes = 10,          -- decided automatically if no reviewer acts in time
    PassScore = 60,
    Conditions = {
        'Report to probation as directed',
        'Curfew 19:00 to 07:00 at an approved address',
        'No contact with victims or co-defendants',
        'Do not enter the exclusion zone set by probation',
    },
}
