---------------------------------------------------------------------------
-- Duty, sign-on and shift reports
---------------------------------------------------------------------------
Config.Duty = {
    -- Opens the police hub (duty, notebook, locker, who's on duty).
    Command = 'police',
    -- Optional keybind for the hub ('' = none). Players can rebind it in GTA settings.
    Keybind = '',

    -- Sign on only at a station sign-on point (Config.Stations). false = anywhere.
    SignOnAtStation = true,
    -- Sign off only at a station. false = anywhere (recommended: players log off mid-patrol).
    SignOffAtStation = false,
    -- How close to a sign-on point counts as "at" it (metres).
    PointRadius = 3.0,

    -- Callsigns: a callsign is needed to sign on.
    RequireCallsign = true,
    CallsignMaxLength = 8,
    CallsignPattern = '^[%w%-]+$', -- letters, numbers and dashes (vinewood-dispatch applies its own rules when running)

    -- Officers without a collar number may pick their own at first sign-on (still unique).
    -- false = a sergeant must set it with /collar first.
    SelfAssignCollar = true,
    RequireCollar = true,

    -- Keep the framework's duty flag (QB/Qbox) in step with sign-on. Turning a police officer
    -- on duty any other way (qb-core's duty toggle, another police job) is undone.
    EnforceFrameworkDuty = true,

    -- Unit types an officer can sign on as. qualifications: all must be held and in date.
    UnitTypes = {
        { id = 'response',      label = 'Response' },
        { id = 'neighbourhood', label = 'Neighbourhood' },
        { id = 'roads',         label = 'Roads policing',  qualifications = { 'advanced_driver' } },
        { id = 'arv',           label = 'Armed response',  qualifications = { 'firearms', 'advanced_driver' } },
        { id = 'dogs',          label = 'Dog section',     qualifications = { 'dog_handler' } },
        { id = 'cid',           label = 'CID',             minRank = 'pc' },
        { id = 'custody',       label = 'Custody',         minRank = 'ps' },
        { id = 'control',       label = 'Control room' },
    },

    -- Officer statuses. tone: 'ok' | 'busy' | 'away' (colour in the hub).
    Statuses = {
        { id = 'available',  label = 'Available',          tone = 'ok' },
        { id = 'attending',  label = 'Attending',          tone = 'busy' },
        { id = 'at_scene',   label = 'At scene',           tone = 'busy' },
        { id = 'committed',  label = 'Committed',          tone = 'busy' },
        { id = 'prisoner',   label = 'Prisoner transport', tone = 'busy' },
        { id = 'at_station', label = 'At station',         tone = 'away' },
        { id = 'refs',       label = 'Refreshments',       tone = 'away' },
    },
    DefaultStatus = 'available',

    -- End-of-shift report.
    Report = {
        Required = false,   -- must write something to sign off
        MaxLength = 2000,
    },
}

---------------------------------------------------------------------------
-- Pocket notebook. Entries can't be edited or deleted, only corrected.
---------------------------------------------------------------------------
Config.Notebook = {
    MaxLength = 1000,
    PageSize = 25,
}

---------------------------------------------------------------------------
-- Radial menu (ox_lib, default key Z). A "Police" section appears while you're signed on.
---------------------------------------------------------------------------
Config.Radial = {
    Enabled = true,
    DisableWhenCuffed = true,   -- nobody uses the radial menu while handcuffed
    CloseDistance = 3.0,        -- how close the person or vehicle must be for radial actions
}
