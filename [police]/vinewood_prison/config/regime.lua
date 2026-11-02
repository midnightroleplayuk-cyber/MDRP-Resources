Config.Regime = {
    -- 'cycle': a regime day runs in CycleMinutes of real time (good for RP sessions)
    -- 'real' : follows the server clock, plus RealOffsetHours
    Clock = 'cycle',
    CycleMinutes = 120,
    RealOffsetHours = 0,

    -- What the regime does with cell doors:
    --   'regime'   : unlocks them in unlocked phases and locks them at lock-up (default)
    --   'lockonly' : locks them at lock-up, never unlocks them; staff unlock from the tablet
    --   'manual'   : never touches cell doors
    Cells = 'regime',

    -- With fewer on-duty staff than this, the regime runs itself (automated mode)
    MinStaff = 1,
    -- Staffed mode: seconds officers have to run a phase's unlock/lock-up and roll check
    -- from the tablet before the system does it for them
    StaffGrace = 180,

    InCellRadius = 3.0,           -- how close to their cell point counts as "in cell"
    ReturnAtLockup = true,        -- automated lock-up returns prisoners to their cell
    LateForLockupPoints = -1,     -- behaviour entry for being out of cell at lock-up (0 = none)

    -- at = regime clock time (24h). locked = behind their door. roll = roll check at start.
    -- work = counts for wages. canteen = canteen orders delivered at start.
    Phases = {
        { id = 'unlock',  at = '07:30', label = 'Unlock and breakfast', locked = false },
        { id = 'work_am', at = '08:30', label = 'Work and education',  locked = false, work = true },
        { id = 'lunch',   at = '11:45', label = 'Lunch and lock-up',   locked = true,  roll = true },
        { id = 'work_pm', at = '13:30', label = 'Work and education',  locked = false, work = true },
        { id = 'assoc',   at = '16:30', label = 'Association',         locked = false },
        { id = 'tea',     at = '17:15', label = 'Tea',                 locked = false, canteen = true },
        { id = 'evening', at = '18:00', label = 'Evening association', locked = false },
        { id = 'bangup',  at = '19:30', label = 'Lock-up',             locked = true,  roll = true },
    },
}
