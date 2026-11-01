Config = {}

-- 'auto', 'qbx', 'qb' or 'esx'
Config.Framework = 'qbx'

-- Name shown on the system header and in notifications.
Config.ServiceName = 'Ministry of Justice'
Config.CourtsName = 'HM Courts & Tribunals Service'
-- Crest shown top left. A URL or nui:// path to a PNG/SVG, or false for the built-in crest.
Config.Crest = false

Config.Command = 'moj'          -- staff system (judges, clerks, CPS, defence, probation, prison)
Config.Keybind = false          -- e.g. 'F7'
Config.PortalCommand = 'mycase' -- anyone: their own hearings, fines, orders and unpaid work

---------------------------------------------------------------------------
-- Who can do what. job = minimum grade. Supervisor = minimum grade for
-- overrides (early release, cancelling warrants, deleting cases).
---------------------------------------------------------------------------
Config.Roles = {
    judge     = { jobs = { judge = 0, magistrate = 0 }, supervisor = 0, label = 'Judiciary' },
    clerk     = { jobs = { court = 0, clerk = 0 },      supervisor = 2, label = 'Court clerk' },
    cps       = { jobs = { cps = 0, police = 4 },       supervisor = 2, label = 'Crown Prosecution Service' },
    defence   = { jobs = { lawyer = 0, solicitor = 0 }, supervisor = 99, label = 'Defence solicitor' },
    probation = { jobs = { probation = 0 },             supervisor = 2, label = 'Probation Service' },
    prison    = { jobs = { prison = 0, doc = 0 },       supervisor = 2, label = 'HM Prison Service' },
    police    = { jobs = { police = 0, sheriff = 0 },   supervisor = 3, label = 'Police (read only)' },
}
Config.RequireOnDuty = true

---------------------------------------------------------------------------
-- vinewood-mdt link. Switches on by itself when the MDT is running.
---------------------------------------------------------------------------
Config.MDT = {
    enabled = true,
    resource = 'vinewood-mdt',
    CaseFromCharge = true,       -- a CPS "charge" decision in the MDT opens a court case here
    WriteNotes = true,           -- court results are added to the person's MDT timeline as notes
    MirrorWarrants = true,       -- warrants issued by the court appear in the MDT (and flag Wanted)
    UpdateBail = true,           -- court bail conditions replace the MDT's police bail conditions
    AlertPolice = true,          -- exclusion zone and curfew breaches go to police as MDT calls
}

---------------------------------------------------------------------------
-- Courts. kind = 'magistrates' or 'crown'. coords are used for the waypoint
-- a defendant gets with their hearing notice.
---------------------------------------------------------------------------
Config.Courts = {
    { id = 'lsmc', label = "Los Santos Magistrates' Court", kind = 'magistrates', coords = vec3(-545.0, -204.0, 38.2) },
    { id = 'lscc', label = 'Los Santos Crown Court', kind = 'crown', coords = vec3(-545.0, -204.0, 38.2) },
}

Config.CaseRefPrefix = { magistrates = 'MC', crown = 'T' }

Config.Listing = {
    -- Courts sit between these hours (server time, 24h). Hearings are listed into the next sitting.
    SittingFrom = 18,
    SittingTo = 23,
    SlotMinutes = 20,                -- gap between hearings in the same court
    FirstHearingHours = 24,          -- bailed defendants: first hearing at least this long after charge
    RemandHearingMinutes = 30,       -- in custody or arrested on warrant: listed this soon
    TrialHours = 48,                 -- not guilty plea: trial listed at least this long after
    SentenceHours = 0,               -- 0 = sentence straight after a guilty plea or verdict
    ReminderMinutes = { 60, 15 },    -- defendants online get reminders this long before
}

---------------------------------------------------------------------------
-- Auto court: when no judge deals with a hearing, the system does.
---------------------------------------------------------------------------
Config.AutoCourt = {
    enabled = true,
    GraceMinutes = 10,          -- after the listed time, wait this long for a judge to open the hearing
    JudgeTakeoverMinutes = 20,  -- a judge is online but hasn't opened it: auto court takes it after this
    PleaTimeoutSeconds = 120,   -- defendant gets a plea prompt; no answer = not guilty entered for them
    -- Defendant not in the city when an auto hearing is due:
    --   'wait'    = hold it until they next log in, then deal with it
    --   'warrant' = treat it as failing to appear (warrant issued)
    Offline = 'wait',
    -- Not guilty pleas need a trial. If no judge has held it TrialWaitHours after it was due:
    --   'wait'    = keep waiting for a judge (judges are reminded)
    --   'convict' = trial on the papers: convicted, no plea credit, sentenced automatically
    --   'acquit'  = case dismissed
    NotGuilty = 'convict',
    TrialWaitHours = 72,
    BreachAction = 'extra_hours', -- community order breach with no judge: 'extra_hours' or 'resentence'
}

---------------------------------------------------------------------------
-- Prison (custody). Time is served while the prisoner is in the city.
---------------------------------------------------------------------------
Config.Prison = {
    -- Who holds the prisoner:
    --   'auto'             Vinewood HMP, rcore_prison or pickle_prisons if running, otherwise the built-in prison
    --   'vinewood_prison'  Vinewood HMP: it runs the whole sentence (time, release, escapes) and reports back
    --   'builtin'          this resource (teleport, perimeter, time left on screen)
    --   'rcore_prison', 'pickle_prisons', 'wasabi_police_v2'
    --   'custom'           your own script, with the hooks in Config.Prison.Custom below
    -- Whichever holds them, the court still sets the sentence, counts time served and decides release.
    Script = 'auto',
    MinutesPerMonth = 1,          -- 1 month of sentence = 1 minute served in the city
    MinimumMinutes = 5,
    ReleasePoint = 0.5,           -- automatic release at the halfway point, onto licence
    RemandCounts = true,          -- time on remand comes off the sentence
    Name = 'HMP Bolingbroke',

    -- Built-in prison only
    Spawn = vec4(1661.05, 2524.68, 45.56, 260.5),
    ReleaseAt = vec4(1847.2, 2585.9, 45.67, 270.0),
    Perimeter = { centre = vec3(1690.0, 2590.0, 45.0), radius = 165.0 },
    ConfiscateItems = true,       -- ox_inventory ConfiscateInventory / ReturnInventory

    -- Other prison scripts
    RemandMinutes = 600,          -- time given to the prison script for remand (we let them out when bail is granted)
    -- The prison script stops holding someone before the court's release point (its own timer, a guard
    -- releasing them, a breakout). rcore_prison tells us which it was: breakouts are always escapes.
    -- For scripts that don't (wasabi_police_v2, custom with IsJailed):
    --   'release' = accept it: they're released (onto licence if sentenced)
    --   'escape'  = unlawfully at large: warrant issued, back to prison when police execute it
    EarlyExit = 'release',
    Scripts = {
        -- timeScale converts court minutes into the script's unit (1 = minutes).
        -- prison = estate code to send people to (nil = its default). category = 'A'..'D' or nil for its default.
        vinewood_prison = { timeScale = 1, prison = nil },
        rcore_prison = { timeScale = 1 },
        pickle_prisons = { timeScale = 1, prison = 'default' },
        wasabi_police_v2 = { timeScale = 1 },
    },
    Custom = {
        Jail = function(src, minutes, info)
            -- exports['my_prison']:Jail(src, minutes, info.reason)
        end,
        Release = function(src)
            -- exports['my_prison']:Release(src)
        end,
        IsJailed = nil,           -- optional: function(src) return true end
    },
}

---------------------------------------------------------------------------
-- Probation: community orders, suspended sentences and licence after release.
---------------------------------------------------------------------------
Config.Probation = {
    LicenceDays = 7,              -- real days on licence after release from prison
    RequirementDays = 7,          -- real days that curfew and exclusion requirements on a community order last
    WarningsBeforeBreach = 2,     -- missed appointments / violations before breach action
    RecallMinutes = 15,           -- licence recall: fixed-term return to prison (minutes served)
    BreachExtraHours = 20,        -- added to unpaid work when a breach is dealt with by extra hours
    MonitorEverySeconds = 60,     -- curfew and exclusion zone checks
    CurfewRadius = 40.0,          -- metres from the curfew address
    ExclusionRadius = 120.0,      -- default zone size when set from the officer's position
    -- Named exclusion zones the court can pick from, as well as "here".
    ExclusionZones = {
        { id = 'legion', label = 'Legion Square', coords = vec3(195.0, -935.0, 30.7), radius = 120.0 },
        { id = 'vespucci', label = 'Vespucci Beach', coords = vec3(-1350.0, -1450.0, 4.4), radius = 250.0 },
        { id = 'grove', label = 'Grove Street', coords = vec3(105.0, -1940.0, 20.8), radius = 150.0 },
    },
    Office = { label = 'Probation Office, Mission Row', coords = vec3(441.0, -981.0, 30.7) },
}

---------------------------------------------------------------------------
-- Unpaid work (community service)
---------------------------------------------------------------------------
Config.UnpaidWork = {
    HoursPerTask = 4,             -- one task done in the city counts for this many ordered hours
    TaskSeconds = 25,
    CooldownSeconds = 20,         -- between tasks, so it can't be spammed
    Sites = {
        { label = 'Legion Square clean-up', coords = vec3(195.0, -935.0, 30.7), radius = 45.0,
          scenario = 'WORLD_HUMAN_JANITOR', task = 'Litter picking' },
        { label = 'Vespucci Beach clean-up', coords = vec3(-1300.0, -1520.0, 4.4), radius = 60.0,
          scenario = 'WORLD_HUMAN_GARDENER_PLANT', task = 'Beach clean' },
        { label = 'Strawberry graffiti removal', coords = vec3(200.0, -1450.0, 29.2), radius = 50.0,
          scenario = 'WORLD_HUMAN_MAID_CLEAN', task = 'Graffiti removal' },
    },
}

---------------------------------------------------------------------------
-- Court fines, compensation and the victim surcharge
---------------------------------------------------------------------------
Config.Fines = {
    Currency = '£',
    Account = 'bank',
    DueDays = 28,
    VictimSurcharge = 10,         -- % added to every fine (minimum below). 0 = off.
    VictimSurchargeMin = 50,
    DefaultIncrease = 50,         -- % added when a fine goes into default. 0 = off.
    WarrantOnDefault = true,      -- unpaid this many days after it fell due: arrest warrant
    WarrantAfterDays = 14,
    OnPaid = function(amount, fine)
        -- exports['qb-management']:AddMoney('court', amount)
    end,
}

---------------------------------------------------------------------------
-- Court bail conditions (same ids as the MDT, so they carry over)
---------------------------------------------------------------------------
Config.BailConditions = {
    { id = 'reside',   label = 'Reside and sleep each night at', input = 'address' },
    { id = 'curfew',   label = 'Curfew between', input = 'text', placeholder = '21:00 and 07:00' },
    { id = 'contact',  label = 'Not to contact, directly or indirectly', input = 'text', placeholder = 'Named person' },
    { id = 'exclude',  label = 'Not to enter', input = 'text', placeholder = 'Area or premises' },
    { id = 'report',   label = 'Report to police station', input = 'text', placeholder = 'Mondays and Thursdays' },
    { id = 'passport', label = 'Surrender passport', input = false },
    { id = 'vehicle',  label = 'Not to drive any motor vehicle', input = false },
}

-- Who gets told about what in the city (ox_lib notifications).
Config.Notify = {
    JudgesOnOverdue = true,
    ProbationOnViolation = true,
}
