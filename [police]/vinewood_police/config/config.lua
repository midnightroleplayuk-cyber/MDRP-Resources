Config = {}

---------------------------------------------------------------------------
-- Core
---------------------------------------------------------------------------
-- 'auto' detects the framework. Force one if auto picks wrong:
-- 'qbox' | 'qbcore' | 'esx'. (Qbox running under the qb-core name is detected as Qbox.)
Config.Framework = 'auto'
-- 'auto' | 'ox' | 'qb' | 'esx'
Config.Inventory = 'auto'
-- 'auto' | 'ox' | 'qb'
Config.Target = 'auto'
-- 'auto' | 'ox' | 'qb' | 'esx' | 'native'
Config.Notify = 'auto'

Config.Locale = 'en'
-- 'error' | 'warn' | 'info' | 'debug'
Config.LogLevel = 'info'
-- Enables the test helpers in /vpo (state set/clear). Leave off on live servers.
Config.Debug = false

-- Shown on forms and used in references when the MDT isn't installed.
-- When vinewood-mdt is running, its Config.ForceName / ForceShort are used instead.
Config.Force = {
    name = 'Los Santos Police',
    short = 'LSP',
}

-- Players with this ace can use admin commands (/vpo status, granting qualifications during setup).
-- It does NOT give police powers: arrests, searches and records always need the police job.
-- Any one of these aces is enough. 'command' is the ace the default server.cfg gives group.admin,
-- so normal server admins are covered without adding anything.
Config.AdminAce = { 'vinewood_police.admin', 'command' }
-- Also count framework admins (ESX groups admin/superadmin, QBCore admin/god permission).
Config.FrameworkAdmins = true
-- Admins may grant/revoke qualifications without being a supervisor (needed to set up the first sergeants).
Config.AllowAdminQualifications = true

Config.Commands = {
    admin = 'vpo',             -- /vpo status | /vpo state ...
    quals = 'quals',           -- /quals [id]
    qualGrant = 'qualgrant',   -- /qualgrant [id] [qualification] [days]
    qualRevoke = 'qualrevoke', -- /qualrevoke [id] [qualification] [reason]
    collar = 'collar',         -- /collar [id] [number]
}

-- Collar numbers: digits only, at most this many.
Config.CollarMaxDigits = 5

---------------------------------------------------------------------------
-- Audit log (append-only)
---------------------------------------------------------------------------
Config.Audit = {
    -- Entries older than this are removed on start. 0 = keep forever.
    KeepDays = 365,
    -- Also print every entry to the server console.
    Console = false,
}

---------------------------------------------------------------------------
-- Rate limits for player-triggered actions: max calls per window (ms)
---------------------------------------------------------------------------
Config.RateLimits = {
    default = { max = 10, window = 5000 },
    command = { max = 5, window = 5000 },
    hub = { max = 20, window = 5000 },
    duty = { max = 4, window = 10000 },
    notebook = { max = 6, window = 10000 },
    equipment = { max = 8, window = 5000 },
    restraint = { max = 6, window = 5000 },
    arrest = { max = 4, window = 10000 },
    search = { max = 8, window = 10000 },
    roads = { max = 10, window = 10000 },
    scene = { max = 12, window = 5000 },
    custody = { max = 15, window = 10000 },
    calls = { max = 15, window = 10000 },
    incident = { max = 15, window = 10000 },
    cid = { max = 15, window = 10000 },
    standards = { max = 15, window = 10000 },
    discharge = { max = 3, window = 10000 },
    dogs = { max = 10, window = 5000 },
    manage = { max = 10, window = 10000 },
}

---------------------------------------------------------------------------
-- Optional Vinewood integrations. Each is detected while running and can be
-- switched off here. None of them are required.
---------------------------------------------------------------------------
Config.Integrations = {
    -- How long to wait for another resource to answer (ms).
    Timeout = 5000,

    mdt = {
        enabled = true,
        resources = { 'vinewood-mdt' },
        minVersion = '2.18.0',
        -- Lawful purpose recorded in the MDT audit log for actions the police job sends.
        -- Each must match an entry in the MDT's Config.Audit.Reasons.
        Reasons = {
            default = 'Arrest / custody',
            createRecord = 'Arrest / custody',
            stopSearchCreate = 'Stop and search',
            checkDriver = 'Vehicle stop',
            getVehicle = 'Vehicle stop',
            searchVehicles = 'Vehicle stop',
            createIncident = 'Incident enquiry',
            getIncident = 'Incident enquiry',
            searchIncidents = 'Incident enquiry',
        },
    },
    dispatch        = { enabled = true, resources = { 'vinewood-dispatch' } },
    interviews      = { enabled = true, resources = { 'vinewood-interviews' } },
    vehicleservices = { enabled = true, resources = { 'vinewood-vehicleservices', 'vinewood-motinsurance' }, minVersion = '1.5.0' },
    licensing       = { enabled = true, resources = { 'vinewood_licensing' }, minVersion = '2.0.0' },
    radio           = { enabled = true, resources = { 'vinewood_radio', 'vinewood-radio' } },
    prison          = { enabled = true, resources = { 'vinewood_prison' }, minVersion = '2.4.0' },
    moj             = { enabled = true, resources = { 'vinewood-moj' }, minVersion = '1.2.0' },
}

-- Paper notices the public are handed (fixed penalties, vehicle seizure notices, and stop and search
-- records when the MDT isn't running). Using the item shows the notice again. false = no item.
-- (Bail notices and stop and search records with the MDT are vinewood-mdt items: bail_notice, stop_search_record.)
Config.NoticeItem = 'police_notice'
