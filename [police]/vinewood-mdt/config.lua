Config = {}

-- 'auto', 'qbx', 'qb' or 'esx'
Config.Framework = 'qbx'

-- Force name shown on the MDT header and bail notices.
Config.ForceName = 'Midnight Police Constabulary'
Config.ForceShort = 'MPC'
-- Crest shown top left. A URL or nui:// path to a PNG/SVG, or false for the built-in star.
Config.ForceCrest = false

-- Jobs that can use the MDT. job = minimum grade.
Config.Jobs = {
    police = 0,
}
Config.RequireOnDuty = true

-- Ways to open it. Set any to false to disable.
Config.Command = 'mdt'
Config.Keybind = 'F6'
Config.Item = 'mdt'            -- e.g. 'mdt_tablet' (ox_inventory / framework usable item)
Config.UseTabletProp = true

-- Minimum grade for destructive actions (deleting records, removing markers).
Config.SupervisorGrade = 10

---------------------------------------------------------------------------
-- Licence sources. Every enabled source that is running is checked and shown.
---------------------------------------------------------------------------
Config.Licences = {
    -- DVLA driver record: vinewood_licensing, or the older citydriving.
    -- The first one running is used. vinewood_licensing also queues points and bans
    -- for offline drivers, so officers can endorse someone who isn't in the city.
    dvla = {
        enabled = true,
        resources = { 'vinewood_licensing', 'citydriving' },
        -- Names shown for each category the licence script stores.
        categoryLabels = { car = 'Car (B)', bike = 'Motorcycle (A)', truck = 'HGV (C)' },
        -- Endorsement codes officers can pick from. points = default points.
        codes = {
            { code = 'SP30', label = 'Exceeding statutory speed limit on a public road', points = 3 },
            { code = 'SP50', label = 'Exceeding speed limit on a motorway', points = 3 },
            { code = 'CU80', label = 'Using a mobile phone while driving', points = 6 },
            { code = 'TS10', label = 'Failing to comply with traffic light signals', points = 3 },
            { code = 'CD10', label = 'Driving without due care and attention', points = 3 },
            { code = 'CD30', label = 'Driving without due care or reasonable consideration', points = 3 },
            { code = 'IN10', label = 'Using a vehicle uninsured against third party risks', points = 6 },
            { code = 'LC20', label = 'Driving otherwise than in accordance with a licence', points = 3 },
            { code = 'MS90', label = 'Failure to give information as to identity of driver', points = 6 },
            { code = 'AC10', label = 'Failing to stop after an accident', points = 5 },
            { code = 'DR10', label = 'Driving with alcohol level above limit', points = 3 },
            { code = 'DD40', label = 'Dangerous driving', points = 3 },
        },
    },

    -- Qbox / QBCore character metadata licences (metadata.licences)
    framework = {
        enabled = false,
        labels = {
            driver = 'Driving licence',
            weapon = 'Firearm certificate',
            business = 'Business licence',
            hunting = 'Shotgun certificate',
            pilot = 'Pilot licence',
        },
    },

    -- esx_license (user_licenses table)
    esx_license = {
        enabled = false,
        labels = {
            dmv = 'Theory test pass',
            drive = 'Driving licence (B)',
            drive_bike = 'Motorcycle licence (A)',
            drive_truck = 'HGV licence (C)',
            weapon = 'Firearm certificate',
        },
    },

    -- Add your own source. Return a list of { label = '', status = 'valid'|'revoked'|'suspended'|'provisional', detail = '' }
    -- custom = function(citizenid, src) return {} end,
    custom = nil,
}

---------------------------------------------------------------------------
-- Housing sources. Every enabled source that is running is checked.
---------------------------------------------------------------------------
Config.Housing = {
    rxhousing      = { enabled = true, resource = 'RxHousing' },
    qbx_properties = { enabled = true, resource = 'qbx_properties' },
    ps_housing     = { enabled = true, resource = 'ps-housing' },
    qb_houses      = { enabled = true, resource = 'qb-houses' },
    qs_housing     = { enabled = true, resource = 'qs-housing' },
    next_housing   = { enabled = true, resource = 'next_housing' },
    -- custom = function(citizenid, src) return { { label = '', address = '', role = 'Owner' } } end,
    custom = nil,
}

---------------------------------------------------------------------------
-- vinewood-interviews integration. Used automatically when the resource is running.
---------------------------------------------------------------------------
Config.Interviews = {
    enabled = true,
    resource = 'vinewood-interviews',
    -- Jobs that can listen to interviews from the MDT. job = minimum grade.
    jobs = { police = 1, sheriff = 0, cps = 0 },
}

---------------------------------------------------------------------------
-- Crown Prosecution Service
-- Officers submit custody cases for a charging decision. CPS lawyers apply the
-- Full Code Test (evidential stage, then public interest) and charge, NFA,
-- or send an action plan back for more evidence.
---------------------------------------------------------------------------
Config.CPS = {
    enabled = true,
    -- Jobs that act as CPS lawyers. job = minimum grade. They only see the CPS section and interviews.
    jobs = { cps = 0 },
    RequireOnDuty = false,
    -- Police can only NFA a case themselves before it is sent to the CPS.
    -- true lets police NFA a case that is still awaiting a CPS decision (it is withdrawn).
    PoliceCanWithdraw = true,
    EvidenceTypes = {
        'Body-worn video', 'CCTV', 'Witness statement', 'Officer statement', 'Victim statement',
        'Interview record', 'Forensic', 'Photographs', 'Phone download', 'Exhibit', 'Other',
    },
    NfaReasons = {
        'Evidential difficulties',
        'Not in the public interest',
        'Victim withdrew support',
        'Suspect not identified as offender',
        'Statutory time limit expired',
    },
}

---------------------------------------------------------------------------
-- Custody and bail
---------------------------------------------------------------------------
Config.Stations = {
    'Vinewood Police Station',
    'Paleto Bay Police Station',
}

-- Days ahead the return date defaults to.
Config.DefaultBailDays = 7

Config.BailTypes = {
    { id = 'pre_charge', label = 'Pre-charge bail (s.37 PACE)', needsDate = true },
    { id = 'rui',        label = 'Released under investigation', needsDate = false },
    { id = 'charged',    label = 'Charged and bailed to court', needsDate = true },
    { id = 'street',     label = 'Street bail (s.30A PACE)', needsDate = true },
}

Config.BailConditions = {
    { id = 'reside',   label = 'Reside and sleep each night at', input = 'address' },
    { id = 'curfew',   label = 'Curfew between', input = 'text', placeholder = '21:00 and 07:00' },
    { id = 'contact',  label = 'Not to contact, directly or indirectly', input = 'text', placeholder = 'Named person' },
    { id = 'exclude',  label = 'Not to enter', input = 'text', placeholder = 'Area or premises' },
    { id = 'report',   label = 'Report to police station', input = 'text', placeholder = 'Mondays and Thursdays' },
    { id = 'passport', label = 'Surrender passport', input = false },
    { id = 'vehicle',  label = 'Not to drive any motor vehicle', input = false },
}

-- Give the released person a bail notice item (ox_inventory). false to disable.
Config.BailNoticeItem = 'bail_document'   -- e.g. 'bail_notice'

-- Called after a bail record is saved. target is the server id (nil if offline).
-- Use it to free someone from your custody script.
Config.OnBailGranted = function(target, bail)
    -- Someone held on remand by vinewood-moj who is bailed here is let out of prison.
    if target and GetResourceState('vinewood-moj') == 'started' then
        exports['vinewood-moj']:ReleaseFromCustody(target)
    end
end

---------------------------------------------------------------------------
-- Prison (remand)
-- Choosing "Remanded in custody" sends the person to the prison script, and releasing
-- them on bail or NFA lets them out. Supported: vinewood_prison, rcore_prison, tk_jail,
-- qb_tk_jail, qb-prison. Add others in server/prison.lua.
---------------------------------------------------------------------------
Config.Prison = {
    enabled = true,
    resource = 'auto',        -- 'auto' (first one running), a name from the list above, or 'custom'
    RemandMinutes = 60,       -- how long a remand lasts in scripts that need a time (until court)
    ReleaseOnBail = true,     -- bail or NFA lets a remanded person out of prison
    -- For resource = 'custom'. target = { src, cid }, data = { minutes, seconds, reason, caseRef, offences, officer }
    -- Custom = function(target, data) exports.my_prison:Jail(target.src, data.minutes) return true end,
    -- CustomRelease = function(target, data) exports.my_prison:Release(target.src) return true end,
}

-- The first outcome is used when someone is booked in and is still in custody.
Config.Outcomes = {
    'In custody',
    'Charged', 'Released on bail', 'Released under investigation', 'Remanded in custody',
    'Simple caution', 'Community resolution', 'No further action', 'Fixed penalty notice',
}

Config.Offences = {
    { act = 'Theft Act 1968', items = { 's.1 Theft', 's.8 Robbery', 's.9 Burglary', 's.12 Taking a vehicle without consent', 's.22 Handling stolen goods' } },
    { act = 'Offences Against the Person Act 1861', items = { 's.18 Wounding with intent', 's.20 Unlawful wounding', 's.47 Assault occasioning ABH' } },
    { act = 'Criminal Justice Act 1988', items = { 's.39 Common assault', 's.139 Possession of a bladed article' } },
    { act = 'Misuse of Drugs Act 1971', items = { 's.4 Supply of a controlled drug', 's.5(2) Possession of a controlled drug', 's.5(3) Possession with intent to supply' } },
    { act = 'Firearms Act 1968', items = { 's.1 Possession without certificate', 's.5 Possession of a prohibited weapon', 's.16 Possession with intent to endanger life' } },
    { act = 'Road Traffic Act 1988', items = { 's.1 Causing death by dangerous driving', 's.2 Dangerous driving', 's.3 Careless driving', 's.5 Driving with excess alcohol', 's.103 Driving while disqualified', 's.143 No insurance', 's.170 Failing to stop' } },
    { act = 'Public Order Act 1986', items = { 's.4 Fear or provocation of violence', 's.4A Intentional harassment', 's.5 Harassment, alarm or distress' } },
    { act = 'Criminal Damage Act 1971', items = { 's.1(1) Criminal damage', 's.1(3) Arson' } },
    { act = 'Bail Act 1976', items = { 's.6 Failing to surrender to bail' } },
    { act = 'Police Act 1996', items = { 's.89 Assault on a constable', 's.89(2) Obstructing a constable' } },
}

---------------------------------------------------------------------------
-- Defence solicitors
-- The custody officer assigns a solicitor to a custody record. The solicitor
-- only ever sees the clients and cases assigned to them: a pre-interview
-- disclosure pack, never the client's wider PNC record.
---------------------------------------------------------------------------
Config.Defence = {
    enabled = true,
    jobs = { lawyer = 0, solicitor = 0 },
    RequireOnDuty = false,
    -- What the solicitor sees on top of the officer's written disclosure.
    ShowOffences = true,      -- offences the client was arrested for
    ShowNarrative = false,    -- the officer's full circumstances of arrest (usually withheld pre-interview)
    ShowBail = true,          -- bail and conditions for that case
    ShowInterviews = true,    -- recordings of their client's interviews on that case
    ShowCpsDecision = true,   -- the CPS outcome once one is made
    ShowHistory = true,       -- the client's previous custody records, outcomes, bail and fines
    Notes = true,             -- private case notes for the solicitor (police can never read them)
    -- Assignments end on their own this many days after the case closes (NFA or charged). 0 = never.
    ExpireDaysAfterClose = 14,
}

---------------------------------------------------------------------------
-- Dispatch (live calls on the dashboard and the Calls page)
-- vinewood-dispatch is used first when it's running: officers can attach to calls and post
-- call updates from the MDT, and the list refreshes as calls change.
-- Read directly:   cd_dispatch3d, cd_dispatch, ps-dispatch
-- Listened to:     qs-dispatch, rcore_dispatch (their alert events are cached as they arrive)
-- Anything else:   exports['vinewood-mdt']:AddCall({ title, code, message, location, coords, priority, jobs })
---------------------------------------------------------------------------
Config.Dispatch = {
    enabled = true,
    -- Only show calls sent to these jobs (calls with no job info are always shown).
    Jobs = { 'police', 'sheriff' },
    -- vinewood-dispatch service to show calls for
    Service = 'police',
    -- Set a resource to false to ignore it, e.g. ['ps-dispatch'] = false
    Sources = {},
    -- Calls the MDT caches itself (listened or pushed) drop off after this long.
    KeepMinutes = 30,
    MaxCalls = 60,
}

---------------------------------------------------------------------------
-- ANPR
-- In-car: officers in an ANPR-fitted vehicle read plates in front and behind them.
-- Fixed cameras: any vehicle driving past a camera is read, and hits go to officers on duty.
---------------------------------------------------------------------------
Config.ANPR = {
    enabled = true,

    -- Who can run in-car ANPR. job = minimum grade.
    Jobs = { police = 0, sheriff = 0 },
    -- Vehicles fitted with ANPR (spawn names). Empty table = every emergency-class vehicle.
    Vehicles = { 'sr6pd', 'sr3pd', 'sen5tourpd', 'strcoupepd', 'rhinea19xpd', 'tailstmk', 'taurionpd', 'clubrpd' },
    -- Turn on automatically when an officer gets into a fitted vehicle. /anpr toggles it.
    AutoStart = true,
    Command = 'anpr',
    ViewCommand = 'anprview',     -- opens the last hit in the MDT
    ViewKey = 'J',
    LayoutCommand = 'anprlayout',
    -- In-game setup: fit vehicles with ANPR and place roadside cameras.
    -- Allowed for police at ManageGrade or above, or anyone with the ace 'vinewood-mdt.anpradmin'.
    AdminCommand = 'anpradmin',
    ManageGrade = 10,
    CameraProp = 'prop_cctv_pole_02',   -- pole spawned at cameras placed in game. false = no prop -- drag the ANPR strip and alert to where you want them (saved per player)

    Range = 30.0,                 -- metres in front of and behind the car
    LaneWidth = 9.0,              -- how far to each side a camera sees
    ReadEvery = 300,              -- ms between scans
    RereadAfter = 90,             -- seconds before the same plate alerts that officer again

    -- Vehicle markers that cause a hit, and how serious each is.
    HitMarkers = {
        ['Stolen'] = { level = 'red', action = 'Stop. Vehicle reported stolen.' },
        ['Seize s.165'] = { level = 'red', action = 'Stop and seize under s.165 RTA.' },
        ['Used in crime'] = { level = 'red', action = 'Stop with caution. Check driver and occupants.' },
        ['No insurance'] = { level = 'amber', action = 'Stop. Check insurance, seize if uninsured.' },
        ['No MOT'] = { level = 'amber', action = 'Stop if safe. Check MOT.' },
        ['ANPR interest'] = { level = 'amber', action = 'Report sighting to intelligence.' },
    },
    -- Hits from the registered keeper's record.
    KeeperWanted = true,          -- keeper has an arrest warrant or Wanted marker
    KeeperDisqualified = true,    -- keeper is disqualified from driving (vinewood_licensing / citydriving)
    KeeperBailNoDriving = true,   -- keeper is bailed not to drive
    UnregisteredPlates = false,   -- hit on plates with no registered keeper (noisy with locals)

    -- Actions officers can choose when putting a plate on ANPR.
    Actions = { 'Stop vehicle', 'Stop and arrest driver', 'Stop - check occupants', 'Do not stop - report sighting', 'Do not stop - inform intelligence' },

    -- Fixed roadside cameras from config. Cameras can also be placed in game with /anpradmin.
    Cameras = {
        { name = 'Del Perro Fwy (Westbound)', coords = vec3(-1394.0, -722.0, 23.5), radius = 18.0 },
        { name = 'Olympic Fwy (Eastbound)',   coords = vec3(469.0, -567.0, 28.5),    radius = 18.0 },
        { name = 'Route 68 (Harmony)',        coords = vec3(1199.0, 2684.0, 37.6),   radius = 16.0 },
        { name = 'Great Ocean Hwy (Paleto)',  coords = vec3(-176.0, 6380.0, 31.5),   radius = 18.0 },
        { name = 'Senora Fwy (Sandy Shores)', coords = vec3(2427.0, 2915.0, 48.9),   radius = 20.0 },
    },
    -- Who hears fixed camera hits: 'all' on-duty police, or 'anpr' (only officers with in-car ANPR on).
    CameraAlerts = 'all',
    -- Also put fixed camera hits on the Live calls page.
    CameraHitsAsCalls = true,
}

---------------------------------------------------------------------------
-- Audit log
-- Like the real PNC, every person or vehicle check needs a reason, and every
-- check and sensitive change is logged. Supervisors can read the log.
---------------------------------------------------------------------------
Config.Audit = {
    enabled = true,
    RequireReason = true,
    Reasons = {
        'Vehicle stop', 'Stop and account', 'Stop and search', 'Arrest / custody', 'Incident enquiry',
        'Warrant / wanted check', 'Intelligence development', 'Missing person', 'Victim / witness contact', 'Other',
    },
    -- Minimum grade to read the audit log and a record's access history.
    ViewGrade = 3,
    -- How long log entries are kept (days). 0 = forever.
    KeepDays = 90,
}

---------------------------------------------------------------------------
-- Custody clock (PACE)
-- The clock starts when the custody record is opened. Reviews are due at 6 hours,
-- then every 9 hours. 24 hours is the limit unless it is extended.
---------------------------------------------------------------------------
Config.Custody = {
    -- Real minutes in one "custody hour". 60 = real time. At 2, the 24 hour limit is 48 minutes.
    HourLength = 2,
    FirstReview = 6,
    ReviewEvery = 9,
    Limit = 24,
    Extensions = {
        { id = 'superintendent', label = 'Superintendent extension (to 36 hours)', hours = 36, grade = 4 },
        { id = 'warrant36', label = 'Warrant of further detention (to 72 hours)', hours = 72, grade = 3 },
        { id = 'warrant96', label = 'Warrant extended by court (to 96 hours)', hours = 96, grade = 3 },
    },
    ReviewGrade = 2,          -- inspector
    ReviewReasons = {
        'To secure or preserve evidence',
        'To obtain evidence by questioning',
        'Awaiting charging decision',
        'Detainee not fit to be dealt with',
    },
}

-- Custody photos (mugshots). The Fivemanage key goes in server/sv_config.lua.
-- Needs screenshot-basic. The officer must be close to the detainee.
Config.Mugshot = {
    enabled = true,
    MaxDistance = 4.0,
    Encoding = 'png',
    Quality = 0.75,              -- lower = smaller upload
    Camera = { Distance = 0.75, HeightOffset = 0.02, Fov = 28.0 },
}

---------------------------------------------------------------------------
-- Stop and search
---------------------------------------------------------------------------
Config.StopSearch = {
    enabled = true,
    Powers = {
        { id = 'pace1',  label = 's.1 PACE 1984 (stolen or prohibited articles)' },
        { id = 'mda23',  label = 's.23 Misuse of Drugs Act 1971 (controlled drugs)' },
        { id = 'fa47',   label = 's.47 Firearms Act 1968 (firearms)' },
        { id = 'cjpoa60', label = 's.60 CJPOA 1994 (authorised area, no grounds needed)', authorisation = true },
        { id = 'cjpoa60aa', label = 's.60AA CJPOA 1994 (face coverings)', authorisation = true },
        { id = 'pa139b', label = 's.139B Criminal Justice Act 1988 (school premises)' },
    },
    Objects = { 'Controlled drugs', 'Offensive weapon', 'Bladed article', 'Firearm', 'Stolen property', 'Going equipped', 'Fireworks', 'Criminal damage articles', 'Other' },
    Outcomes = { 'No further action', 'Arrest', 'Community resolution', 'Penalty notice', 'Cannabis or khat warning', 'Summons / postal requisition', 'Caution' },
    -- Give the person searched a record of the search (ox_inventory item). false = notice only.
    ReceiptItem = false,     -- e.g. 'stop_search_record'
}

---------------------------------------------------------------------------
-- vinewood-vehicleservices (insurance on the MID, MOT, vehicle tax / SORN)
-- Used automatically when it's running.
---------------------------------------------------------------------------
Config.VehicleServices = {
    enabled = true,
    resource = 'vinewood-vehicleservices',
    ShowInsurance = true,     -- MID status on searches, records and ANPR
    ShowMOT = true,
    ShowTax = true,
    -- ANPR hits. Set any to false to stop that hit.
    AnprNoInsurance = true,   -- red: no insurance / void
    AnprDangerousMOT = true,  -- red: failed MOT with dangerous defects
    AnprNoMOT = true,         -- amber
    AnprUntaxed = true,       -- amber
    AnprSorn = true,          -- amber: SORN vehicle seen on the road
}

---------------------------------------------------------------------------
-- Ambulance service (vinewood-emsmdt)
-- Officers can request an injury statement on an incident. Clinicians answer from
-- the ambulance MDT and only their statement comes back, never the patient record.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Courts, prison and probation (vinewood-moj)
-- A CPS "charge" decision opens a court case there. Court dates, sentences,
-- prison status, probation orders and court warrants show on person records.
---------------------------------------------------------------------------
Config.MoJ = {
    enabled = true,
    resource = 'vinewood-moj',
}

Config.Ambulance = {
    enabled = true,
    resource = 'vinewood-emsmdt',
    ShowAdmissions = true,    -- banner on a person's record while they are admitted to hospital
}

---------------------------------------------------------------------------
-- Fines and traffic offence reports
-- FPN = fixed penalty notice (traffic), PND = penalty notice for disorder,
-- TOR = traffic offence report: no fine at the roadside, the case goes to court.
---------------------------------------------------------------------------
Config.Fines = {
    enabled = true,
    Currency = '£',
    Account = 'bank',
    DueDays = 28,                -- real days to pay
    UnpaidIncrease = 50,         -- % added when unpaid after DueDays (registered as a fine). 0 = off.
    PayCommand = 'fines',        -- players use /fines to see and pay what they owe
    -- Points are added through vinewood_licensing (or citydriving) when the code matches an endorsement code.
    Offences = {
        { code = 'SP30', label = 'Exceeding the speed limit', amount = 100, points = 3, type = 'FPN' },
        { code = 'CU80', label = 'Using a hand-held phone while driving', amount = 200, points = 6, type = 'FPN' },
        { code = 'TS10', label = 'Failing to comply with a red traffic light', amount = 100, points = 3, type = 'FPN' },
        { code = 'TS20', label = 'Failing to comply with double white lines', amount = 100, points = 3, type = 'FPN' },
        { code = 'CD10', label = 'Careless driving (lower level)', amount = 100, points = 3, type = 'FPN' },
        { code = 'IN10', label = 'Using a vehicle uninsured', amount = 300, points = 6, type = 'FPN' },
        { code = 'LC20', label = 'Driving otherwise than in accordance with a licence', amount = 100, points = 3, type = 'FPN' },
        { code = 'MOT', label = 'No MOT certificate', amount = 100, points = 0, type = 'FPN' },
        { code = 'SB', label = 'Not wearing a seat belt', amount = 100, points = 0, type = 'FPN' },
        { code = 'OB', label = 'Causing an unnecessary obstruction', amount = 50, points = 0, type = 'FPN' },
        { code = 'PND1', label = 'Drunk and disorderly', amount = 90, points = 0, type = 'PND' },
        { code = 'PND2', label = 's.5 Public Order Act (harassment, alarm or distress)', amount = 90, points = 0, type = 'PND' },
        { code = 'PND3', label = 'Retail theft under £100', amount = 90, points = 0, type = 'PND' },
        { code = 'PND4', label = 'Criminal damage under £300', amount = 90, points = 0, type = 'PND' },
        { code = 'PND5', label = 'Possession of cannabis', amount = 90, points = 0, type = 'PND' },
    },
    -- Called when a fine is paid, e.g. to pay it into a society account.
    OnPaid = function(amount, fine)
        -- exports['qb-management']:AddMoney('police', amount)
    end,
}

---------------------------------------------------------------------------
-- Statements (MG11)
---------------------------------------------------------------------------
Config.Statements = {
    enabled = true,
    Kinds = { 'Officer', 'Witness', 'Victim', 'Expert' },
    Declaration = 'This statement is true to the best of my knowledge and belief and I make it knowing that, if it is tendered in evidence, I shall be liable to prosecution if I have wilfully stated in it anything which I know to be false, or do not believe to be true.',
}

---------------------------------------------------------------------------
-- Incidents and evidence
---------------------------------------------------------------------------
Config.IncidentTypes = {
    'Armed robbery', 'Robbery', 'Burglary', 'Theft', 'Vehicle crime', 'Assault', 'Public order',
    'RTC - damage only', 'RTC - injuries', 'Drugs', 'Weapons', 'Criminal damage', 'Domestic',
    'Concern for welfare', 'Missing person', 'Sudden death', 'Suspicious activity', 'Other',
}
-- Grade 1 = immediate, 2 = priority, 3 = scheduled, 4 = resolved without deployment
Config.IncidentGrades = { 'Grade 1', 'Grade 2', 'Grade 3', 'Grade 4' }
Config.IncidentStatuses = { 'Open', 'In progress', 'Closed' }
Config.IncidentRoles = { 'Suspect', 'Victim', 'Witness', 'Informant', 'Involved' }

Config.EvidenceTypes = {
    'Weapon', 'Firearm', 'Ammunition', 'Drugs', 'Cash', 'Mobile phone', 'Clothing',
    'Vehicle', 'Document', 'CCTV footage', 'Body-worn video', 'Forensic sample', 'Photograph', 'Other',
}
Config.EvidenceStatuses = { 'Seized', 'In property store', 'Sent for forensics', 'With CPS', 'Returned to owner', 'Destroyed' }

-- Forensics. Shooting leaves shell casings and injuries leave blood at the scene. Officers find
-- them in forensics mode (/forensics, or hold a torch), collect them, bag them as exhibits on an
-- incident and send them to the lab. Results link suspects to the scene.
Config.Forensics = {
    enabled = true,
    TraceMinutes = 60,           -- how long casings and blood stay at a scene
    LabMinutes = 10,             -- how long the lab takes (real minutes)
    DNAOnArrest = true,          -- booking someone into custody puts their DNA on the database
    CasingDNAChance = 0.25,      -- chance a casing also carries the shooter's DNA (from loading the gun)
    BloodHealthLoss = 10,        -- health lost in one hit before they bleed
    ViewDistance = 30.0,         -- how far officers see traces in forensics mode
    Command = 'forensics',       -- toggles forensics mode
    TorchShowsTraces = true,     -- holding a torch also shows traces
    CollectKey = 38,             -- E
    IgnoreJobs = {},             -- e.g. { police = true } so police shots leave no casings
}

-- Evidence storage. Every exhibit can hold real items in its own evidence bag (ox, qb, qs, ps or lj inventory).
-- Officers seize items straight from a suspect's inventory, open the bag from the MDT, and
-- return or destroy the contents. Items are linked to the person they were seized from.
Config.Evidence = {
    enabled = true,              -- switches itself off if no supported inventory is running
    -- 'auto', 'ox_inventory', 'qb-inventory' (2.x), 'qs-inventory', 'ps-inventory', 'lj-inventory',
    -- 'qb-inventory-old' (before 2.0), or your own from server/inventory.lua
    Inventory = 'auto',
    Slots = 30,
    MaxWeight = 100000,
    SeizeDistance = 4.0,         -- officer must be this close to the suspect to seize
    ReturnDistance = 4.0,        -- and to the owner to give items back
    -- true = bags can only be opened at a property store below; false = anywhere
    RequireStore = false,
    Stores = {
        -- { name = 'Mission Row property store', coords = vec3(474.0, -995.0, 26.3), radius = 3.0 },
    },
}

---------------------------------------------------------------------------
-- Intelligence (3x5x2 grading)
---------------------------------------------------------------------------
Config.IntelSource = { { id = '1', label = '1 - Reliable' }, { id = '2', label = '2 - Untested' }, { id = '3', label = '3 - Not reliable' } }
Config.IntelAssessment = {
    { id = 'A', label = 'A - Known directly' },
    { id = 'B', label = 'B - Known indirectly, corroborated' },
    { id = 'C', label = 'C - Known indirectly' },
    { id = 'D', label = 'D - Not known' },
    { id = 'E', label = 'E - Suspected to be false' },
}
Config.IntelHandling = { { id = 'P', label = 'P - Lawful sharing permitted' }, { id = 'C', label = 'C - Sharing with conditions' } }

---------------------------------------------------------------------------
-- Warrants
---------------------------------------------------------------------------
Config.WarrantTypes = {
    { id = 'arrest',  label = 'Arrest warrant', wanted = true },
    { id = 'fta',     label = 'Warrant not backed for bail (FTA)', wanted = true },
    { id = 'pace8',   label = 'Search warrant (s.8 PACE)' },
    { id = 'mda23',   label = 'Search warrant (s.23 Misuse of Drugs Act)' },
    { id = 'fa46',    label = 'Search warrant (s.46 Firearms Act)' },
}
-- Minimum grade to record a warrant on the system.
Config.WarrantGrade = 0

-- Markers that put the HIGH RISK badge on a person.
Config.HighRiskMarkers = { Violent = true, Weapons = true, Escaper = true, Wanted = true }

-- Warning markers that can be set on a person or vehicle.
Config.Markers = {
    person = { 'Violent', 'Weapons', 'Drugs', 'Escaper', 'Associates', 'Mental health', 'Self-harm', 'Wanted', 'Missing', 'Ailment', 'Contagious' },
    vehicle = { 'Stolen', 'No insurance', 'No MOT', 'Seize s.165', 'ANPR interest', 'Used in crime' },
}
