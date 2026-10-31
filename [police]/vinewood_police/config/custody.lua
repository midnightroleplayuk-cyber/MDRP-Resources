---------------------------------------------------------------------------
-- Custody suites (phase 3).
-- vinewood-mdt keeps the custody record, PACE clock, reviews, bail, NFA and CPS. This is the building:
-- booking in, property, cells, welfare checks and the custody log.
-- The coordinates below are placeholders for the base-game Mission Row cells: set your MLO's.
---------------------------------------------------------------------------
Config.Custody = {
    Command = 'custody',          -- opens the custody panel while you're in a suite
    AreaRadius = 45.0,            -- how far from the desk counts as "in the suite"
    DeskRadius = 4.0,             -- booking in / property: officer and detainee this close to the desk
    CellRadius = 2.6,             -- a detainee further than this from their cell spot is put back
    RemoveCuffsInCell = true,
    HourLength = 2,               -- real minutes per custody hour, for the clock shown here (match the MDT)
    LimitHours = 24,

    -- Property: everything they carry goes into a property bag at booking in, except these items.
    -- Needs ox_inventory (bags are police-only stashes).
    TakeProperty = true,
    PropertyKeep = {},            -- e.g. { 'id_card' }
    ReturnPropertyOnRelease = true,

    -- Observation levels (PACE Code C / APP). minutes = real minutes between welfare checks.
    Observation = {
        { level = 1, label = 'Level 1: general observation', minutes = 30 },
        { level = 2, label = 'Level 2: intermittent observation', minutes = 15 },
        { level = 3, label = 'Level 3: constant observation', minutes = 5 },
    },
    -- Grounds for authorising detention
    DetentionGrounds = {
        'To secure or preserve evidence relating to an offence',
        'To obtain evidence by questioning',
        'Charged: detained pending court',
        'Arrested on warrant',
        'Breach of bail',
    },
    -- Why a detainee is out of their cell
    OutReasons = { 'Interview', 'Legal consultation', 'Charge or caution', 'Medical / healthcare', 'Fingerprints, photo and DNA', 'Other' },
    -- Outcomes the custody panel can release on. With vinewood-mdt, record the outcome there: the person is
    -- released here automatically. These are for releasing by hand (or servers without the MDT).
    ReleaseOutcomes = { 'Released on bail', 'Released under investigation', 'No further action', 'Simple caution',
        'Community resolution', 'Charged and released to court', 'Detention not authorised' },

    -- NPC detainees. Outcomes the custody panel offers for them (they can't go to the MDT, CPS or court).
    -- A caution or community resolution needs an admission in interview.
    NpcOutcomes = { 'No further action', 'Simple caution', 'Community resolution', 'Released under investigation',
        'Charged and bailed to court', 'Charged and remanded to court' },
    NpcFallbackModel = 'a_m_y_downtown_01',

    Suites = {
        {
            id = 'mission_row',
            label = 'Mission Row custody',
            desk = { coords = vec3(473.0, -1007.5, 26.3), size = vec3(2.0, 1.2, 2.0), rotation = 0.0 },
            release = vec4(434.0, -981.9, 30.7, 90.0),
            -- A cell can have a lockable door: door = { model = `door_model`, coords = vec3(...) }.
            -- Easiest to set in game: vpo locations, Custody, "Set door (look at it)".
            cells = {
                { id = 'C1', label = 'Cell 1', coords = vec4(460.0, -994.0, 24.9, 270.0) },
                { id = 'C2', label = 'Cell 2', coords = vec4(459.4, -998.0, 24.9, 270.0) },
                { id = 'C3', label = 'Cell 3', coords = vec4(459.6, -1001.6, 24.9, 270.0) },
            },
        },
    },
}

---------------------------------------------------------------------------
-- Custody CCTV: cameras in cells and around the suite, watched from the custody computer.
-- Place them in game: vpo locations, Custody, "Place cameras in the world".
---------------------------------------------------------------------------
Config.Custody.CCTV = {
    Filter = 'scanline_cam_cheap', -- timecycle look while watching
    FilterStrength = 0.6,
    MaxPitch = 40.0,               -- how far the operator can tilt from the saved view
    MaxYaw = 70.0,                 -- how far they can pan from it
    MinFov = 15.0, MaxFov = 90.0,
    PanSpeed = 18.0,               -- degrees per second with WASD (slower when zoomed in)
    MouseSensitivity = 2.5,
    ZoomStep = 4.0,
    Smoothing = 5.0,
}

---------------------------------------------------------------------------
-- Cell buzzers: detainees press the call button in their cell; the custody suite hears it and the
-- computer shows which cell. Each cell's buzzer can be muted from the custody computer.
---------------------------------------------------------------------------
Config.Custody.Buzzer = {
    Enabled = true,
    Key = 'E',               -- detainee's call button (rebindable in GTA settings)
    Cooldown = 20,           -- seconds between presses from the same cell
    AutoClear = 180,         -- a call nobody answers stops showing after this many seconds
    HearRadius = 45.0,       -- metres from the custody desk where the buzzer is heard
    Volume = 0.55,
    NpcChance = 8,           -- % chance every 5 minutes that an NPC detainee presses theirs
}
