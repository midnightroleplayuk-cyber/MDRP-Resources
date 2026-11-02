Config.Security = {
    -- Items that are contraband inside. Any weapon item (WEAPON_*) also counts.
    -- severity 1-3 sets the behaviour points and whether a charge is raised.
    Contraband = {
        phone      = { label = 'Mobile phone', severity = 2 },
        radio      = { label = 'Radio', severity = 2 },
        lockpick   = { label = 'Lockpick', severity = 3 },
        weed       = { label = 'Cannabis', severity = 2 },
        joint      = { label = 'Joint', severity = 1 },
        prison_spice  = { label = 'Spice', severity = 3 },
        prison_hooch  = { label = 'Hooch', severity = 1 },
        prison_shiv   = { label = 'Improvised weapon', severity = 3 },
        money      = { label = 'Cash', severity = 1 },
    },
    WeaponsAreContraband = true,
    ChargeAtSeverity = 2,          -- finds at or above this raise a 51(12) charge automatically
    ChargeCode = '51(12)',

    Search = {
        CellPrompt = true,         -- show "[E] Search cell" when standing in a cell (false: use /prisonsearchcell only)
        CellPromptRadius = 1.6,    -- how close to the cell's spot counts as "in the cell"
        CellDuration = 10000,
        PersonDuration = 6000,
        RubDownChance = 0.6,       -- chance a rub-down finds each contraband item carried
        CellFindChance = 0.65,     -- chance a cell search finds the cell stash
        SpotFindChance = 0.4,      -- chance a search of a hiding spot finds what's there
        IntelBonus = 0.25,         -- added for 24h after an intelligence report on that prisoner
        Random = {                 -- automated searches when the regime runs itself
            enabled = true,
            chancePerPhase = 0.35,
            cells = 2,
        },
    },

    Stash = {
        Slots = 5,
        MaxWeight = 3000,
        HideDuration = 5000,
    },

    -- Black market at 'market' points. Paid in a currency item (canteen goods are prison currency).
    -- Prices rise when stock is low and for a while after staff seize contraband.
    Market = {
        enabled = true,
        Currency = { item = 'twerks_candy', label = 'Chocolate bars' },
        RestockMinutes = 30,
        HeatMinutes = 60,          -- how long a find pushes prices up
        HeatMultiplier = 0.5,      -- +50% while hot
        Items = {
            { item = 'prison_hooch', label = 'Hooch',  base = 3, stock = 6 },
            { item = 'joint',     label = 'Joint',  base = 4, stock = 6 },
            { item = 'prison_spice', label = 'Spice',  base = 8, stock = 3 },
            { item = 'phone',     label = 'Phone',  base = 20, stock = 1 },
            { item = 'prison_shiv',  label = 'Shiv',   base = 10, stock = 2 },
        },
    },
}

Config.Incidents = {
    -- Alarm types: who is told, which dispatch jobs, priority 1 (highest) - 3
    Types = {
        general   = { label = 'General alarm',         priority = 1, dispatch = nil },
        code_red  = { label = 'Code Red (bleeding)',   priority = 1, dispatch = { 'ambulance' } },
        code_blue = { label = 'Code Blue (not breathing)', priority = 1, dispatch = { 'ambulance' } },
        fight     = { label = 'Fight',                 priority = 2, dispatch = nil },
        fire      = { label = 'Fire',                  priority = 1, dispatch = { 'fire' } },
        riot      = { label = 'Concerted indiscipline', priority = 1, dispatch = { 'police' } },
        cell_bell = { label = 'Cell bell',             priority = 3, dispatch = nil },
        escape    = { label = 'Escape',                priority = 1, dispatch = { 'police' } },
        other     = { label = 'Incident',              priority = 2, dispatch = nil },
    },
    BlipSeconds = 120,
    AlarmSound = true,              -- staff hear the alarm tone for priority 1 alarms
    FightDetection = true,          -- prisoners hurting each other raise a fight alarm
    MedicalDetection = true,        -- a prisoner going down raises a Code Blue
    CellBellCooldown = 120,

    Riot = { fights = 3, windowSeconds = 180, autoLockdown = true },

    Lockdown = {
        ReturnGrace = 60,           -- seconds before prisoners still out are returned to their cell
        ForceReturn = true,
        AutoLiftMinutes = 20,       -- automatic lockdowns lift after this when no staff are on duty
    },
}

Config.CCTV = {
    Filter = 'scanline_cam_cheap',
    FilterStrength = 0.6,
    MaxPitch = 40.0,       -- how far an operator can tilt from the saved view
    MaxYaw = 70.0,         -- how far an operator can pan from the saved view
    MinFov = 15.0,         -- most zoomed in
    MaxFov = 90.0,         -- most zoomed out (same range as placing cameras)
    PanSpeed = 18.0,       -- degrees per second with WASD at the saved zoom (slower when zoomed in)
    MouseSensitivity = 2.5,
    ZoomStep = 4.0,        -- per scroll notch
    Smoothing = 5.0,       -- higher is snappier, lower is heavier
}
