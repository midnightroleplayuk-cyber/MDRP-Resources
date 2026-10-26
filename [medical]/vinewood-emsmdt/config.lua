Config = {}

Config.Debug = false

-- 'auto' detects qbx_core, qb-core or es_extended
Config.Framework = 'qbx_core'

---------------------------------------------------------------------
-- Branding (all shown in the MDT; change freely per server)
---------------------------------------------------------------------
Config.Branding = {
    name      = 'Midnight Health Service',
    short     = 'MHS',
    -- Logo: a file in web/img/ (e.g. 'img/logo.svg') or a full https:// URL. '' shows the short name instead.
    logo      = 'img/mhs.svg',
    -- Battenburg pair + accents
    primary   = '#00843D',  -- service green
    secondary = '#FFD200',  -- hi-vis yellow
    footer    = 'Patient information is confidential. Access is logged.',
}

---------------------------------------------------------------------
-- Access
---------------------------------------------------------------------
Config.Jobs = {             -- job names allowed to use the MDT
    ambulance = true,
}
Config.RequireOnDuty = true
Config.Command       = 'mhsmdt'
Config.Keybind       = 'F7'   -- false to disable
Config.Item          = 'mhs_mdt'  -- e.g. 'ems_tablet' to require an item (ox_inventory / framework usable item)
Config.TabletProp    = true

---------------------------------------------------------------------
-- Ranks (job grade -> clinical scope)
-- formulary: 'basic' = only medications marked basic=true below, 'full' = everything
-- prescribe: can issue prescriptions; transfuse: can give blood products
-- supervisor: can view the audit log, amend finalised ePRFs and manage incidents
-- A grade not listed uses the nearest listed grade below it.
---------------------------------------------------------------------

Config.Ranks = {
    [0]  = { label = 'Apprentice EMT',                 formulary = 'basic', prescribe = false, transfuse = false, hems = false, supervisor = false },
    [1]  = { label = 'Student Nurse',                  formulary = 'basic', prescribe = false, transfuse = false, hems = false, supervisor = false },
    [2]  = { label = 'EMT',                            formulary = 'basic', prescribe = false, transfuse = false, hems = false, supervisor = false },
    [3]  = { label = 'Nurse',                          formulary = 'basic', prescribe = false, transfuse = false, hems = false, supervisor = false },
    [4]  = { label = 'Paramedic',                      formulary = 'basic', prescribe = false, transfuse = false, hems = false, supervisor = false },
    [5]  = { label = 'Advanced Paramedic',             formulary = 'full',  prescribe = true,  transfuse = false, hems = false, supervisor = false },
    [6]  = { label = 'Doctor',                         formulary = 'full',  prescribe = true,  transfuse = true,  hems = false, supervisor = false },
    [7]  = { label = 'HEMS - Crit Care Paramedic',     formulary = 'full',  prescribe = true,  transfuse = true,  hems = true,  supervisor = false },
    [8]  = { label = 'HART - Advanced Paramedic',      formulary = 'full',  prescribe = true,  transfuse = false, hems = false, supervisor = false },
    [9]  = { label = 'HEMS - Crit Care Doctor',        formulary = 'full',  prescribe = true,  transfuse = true,  hems = true,  supervisor = false },
    [10] = { label = 'HART - Crit Care Doctor',        formulary = 'full',  prescribe = true,  transfuse = true,  hems = false, supervisor = false },
    [11] = { label = 'HART Team Lead',                 formulary = 'full',  prescribe = true,  transfuse = true,  hems = false, supervisor = true,  trainer = true },
    [12] = { label = 'HEMS Team Lead',                 formulary = 'full',  prescribe = true,  transfuse = true,  hems = true,  supervisor = true,  trainer = true },
    [13] = { label = 'Ambulance Team Lead',            formulary = 'full',  prescribe = true,  transfuse = true,  hems = false, supervisor = true,  trainer = true },
    [14] = { label = 'Training & Development',         formulary = 'full',  prescribe = true,  transfuse = true,  hems = true,  supervisor = true,  trainer = true },
    [15] = { label = 'Hospital Operations Manager',   formulary = 'full',  prescribe = true,  transfuse = true,  hems = false, supervisor = true,  trainer = true },
    [16] = { label = 'Ambulance Operations Manager',  formulary = 'full',  prescribe = true,  transfuse = true,  hems = true,  supervisor = true,  trainer = true },
    [17] = { label = 'Human Resources',                formulary = 'basic', prescribe = false, transfuse = false, hems = false, supervisor = true },
    [18] = { label = 'Director of Operations',         formulary = 'full',  prescribe = true,  transfuse = true,  hems = true,  supervisor = true,  trainer = true },
    [19] = { label = 'Deputy Chief Medicial Officer', formulary = 'full',  prescribe = true,  transfuse = true,  hems = true,  supervisor = true,  trainer = true },
    [20] = { label = 'Chief Medical Officer',         formulary = 'full',  prescribe = true,  transfuse = true,  hems = true,  supervisor = true,  trainer = true },
}

-- trainer = can sign off competencies and record courses (supervisors can too)

---------------------------------------------------------------------
-- Formulary: OSP Ambulance V2 items (item = inventory item name)
-- basic     = available to the 'basic' formulary (Paramedic)
-- scene     = shown in the ePRF medication list (things given on scene)
-- prescribe = can be prescribed; the patient is handed `qty` of the item
-- Recording a drug in the ePRF does not take the item: OSP removes it when you
-- actually use it from its treatment menu.
---------------------------------------------------------------------
Config.Medications = {
    { name = 'Epinephrine',  item = 'epinephrine', basic = true,  scene = true, routes = { 'IV', 'IO', 'IM' },   dose = '1 mg' },
    { name = 'Morphine',     item = 'morphine',    basic = true,  scene = true, routes = { 'IV', 'IO', 'IM' },   dose = '5 mg' },
    { name = 'Narcan',       item = 'narcan',      basic = true,  scene = true, routes = { 'IV', 'IM', 'IN' },   dose = '400 mcg' },
    { name = 'Paracetamol',  item = 'paracetamol', basic = true,  scene = true, routes = { 'Oral', 'IV' },       dose = '1 g',
      prescribe = true, qty = 4,  maxQty = 10 },
    { name = 'Propofol',     item = 'propofol',    basic = false, scene = true, routes = { 'IV' },               dose = '100 mg' },
    { name = 'Saline 250ml', item = 'saline250ml', basic = false, scene = true, routes = { 'IV', 'IO' },         dose = '250 ml' },
    { name = 'Saline 500ml', item = 'saline500ml', basic = false, scene = true, routes = { 'IV', 'IO' },         dose = '500 ml' },
    { name = 'Tramadol',     item = 'tramadol',    basic = false, scene = true, routes = { 'Oral' },             dose = '50 mg',
      prescribe = true, qty = 3,  maxQty = 6 },
    { name = 'Vicodin',      item = 'vicodin',     basic = false, scene = true, routes = { 'Oral' },             dose = '1 tablet',
      prescribe = true, qty = 2,  maxQty = 4 },
    { name = 'Xanax',        item = 'xanax',       basic = false, scene = false, routes = { 'Oral' },            dose = '0.5 mg',
      prescribe = true, qty = 3,  maxQty = 6 },
    { name = 'Melatonin',    item = 'melatonin',   basic = false, scene = false, routes = { 'Oral' },            dose = '3 mg',
      prescribe = true, qty = 5,  maxQty = 10 },
    { name = 'Cough Syrup',  item = 'cough_syrup', basic = false, scene = false, routes = { 'Oral' },            dose = '10 ml',
      prescribe = true, qty = 2,  maxQty = 4 },
}

Config.Prescriptions = {
    -- Hand the items over now if the patient is this close (metres). Otherwise the
    -- prescription is saved as "Not collected" and you hand it over when you're with them.
    handoverDistance = 5.0,
    -- Shown on the item in ox_inventory (metadata.description)
    label = 'Prescribed by %s. %s',
}

-- Interventions. item = the OSP item, for reference in the ePRF.
-- transfuse = true restricts it to ranks with transfusion scope (CCP).
Config.Interventions = {
    { name = 'CPR' },
    { name = 'Defibrillation' },
    { name = 'ECG monitoring',        item = 'ecg' },
    { name = 'Tourniquet',            item = 'tourniquet' },
    { name = 'Field dressing',        item = 'field_dressing' },
    { name = 'Elastic bandage',       item = 'elastic_bandage' },
    { name = 'Packing bandage',       item = 'packing_bandage' },
    { name = 'Quick clot',            item = 'quick_clot' },
    { name = 'Sutures (sewing kit)',  item = 'sewing_kit' },
    { name = 'Neck brace',            item = 'neckbrace' },
    { name = 'Neck cast',             item = 'neckcast' },
    { name = 'Arm splint',            item = 'armsplint' },
    { name = 'Arm cast',              item = 'armcast' },
    { name = 'Leg splint',            item = 'legsplint' },
    { name = 'Leg cast',              item = 'legcast' },
    { name = 'Blood sample taken',    item = 'bloodsample' },
    { name = 'Stretcher',             item = 'stretcher' },
    { name = 'Blood transfusion O-',  item = 'blood500ml_ominus',  transfuse = true },
    { name = 'Blood transfusion O+',  item = 'blood500ml_oplus',   transfuse = true },
    { name = 'Blood transfusion A-',  item = 'blood500ml_aminus',  transfuse = true },
    { name = 'Blood transfusion A+',  item = 'blood500ml_aplus',   transfuse = true },
    { name = 'Blood transfusion B-',  item = 'blood500ml_bminus',  transfuse = true },
    { name = 'Blood transfusion B+',  item = 'blood500ml_bplus',   transfuse = true },
    { name = 'Blood transfusion AB-', item = 'blood500ml_abminus', transfuse = true },
    { name = 'Blood transfusion AB+', item = 'blood500ml_abplus',  transfuse = true },
}

Config.ECGRhythms = {
    { name = 'Not recorded' },
    { name = 'Sinus rhythm' },
    { name = 'Sinus tachycardia' },
    { name = 'Sinus bradycardia' },
    { name = 'Atrial fibrillation' },
    { name = 'STEMI changes' },
    { name = 'Ventricular fibrillation (VF)', arrest = true },
    { name = 'Pulseless VT',                 arrest = true },
    { name = 'PEA',                          arrest = true },
    { name = 'Asystole (flatline)',          arrest = true },
}

---------------------------------------------------------------------
-- Protocols
---------------------------------------------------------------------
Config.Protocol = {
    -- If a patient flatlines (any arrest rhythm or the arrest box is ticked) they must be
    -- conveyed to hospital, even if revived. Finalising with another outcome is blocked.
    flatlineRequiresConveyance = true,
    -- Outcomes allowed for a flatline patient
    flatlineAllowedOutcomes = { conveyed = true, role = true },
}

-- Editing finalised ePRFs. Every edit needs a reason, keeps the previous version, and is
-- shown in the ePRF's edit history, the audit log and the eprf webhook.
Config.Editing = {
    enabled = true,
    crew = true,              -- attending crew can edit their own ePRFs (supervisors always can)
    crewWindowHours = 0,      -- 0 = no time limit; e.g. 24 = crew can only edit for a day after finalising
}

Config.Outcomes = {
    { id = 'conveyed',   label = 'Conveyed to hospital' },
    { id = 'discharged', label = 'Discharged on scene' },
    { id = 'referred',   label = 'Referred to GP / other service' },
    { id = 'refused',    label = 'Refused treatment / conveyance' },
    { id = 'role',       label = 'Deceased (ROLE)' },
}

-- UK ambulance response categories
Config.Categories = {
    { id = 1, label = 'Cat 1', desc = 'Life-threatening' },
    { id = 2, label = 'Cat 2', desc = 'Emergency' },
    { id = 3, label = 'Cat 3', desc = 'Urgent' },
    { id = 4, label = 'Cat 4', desc = 'Less urgent' },
}

Config.UnitStatuses = {
    'Available', 'En route', 'On scene', 'Conveying', 'At hospital', 'Meal break', 'Unavailable',
}

Config.Hospitals = {
    { id = 'burton', label = 'MHS Burton Hospital', coords = vec3(-356.14, -105.32, 37.74) },
    { id = 'paleto',  label = 'MHS Paleto Bay Medical Centre',    coords = vec3(-255.7, 6318.66, 31.45) },
}

Config.AuditReasons = {
    'Active patient care', 'Clinical handover', 'Safeguarding concern',
    'Responding to police request', 'Supervisor review', 'Clinical audit',
}

Config.ERKReasons = {
    'Bug / glitch', 'Killed by a modder', 'Server crash / desync', 'Other (staff approved)',
}

---------------------------------------------------------------------
-- Discord webhooks ('' disables). Kept in config, not server.cfg.
---------------------------------------------------------------------
Config.Webhooks = {
    eprf       = '',
    incidents  = '',
    hems       = '',
    admissions = '',
    erk        = '',
    audit      = '',
    police     = '',
    training   = '',
}

---------------------------------------------------------------------
-- Live 999 calls from your dispatch script (same sources as vinewood-mdt):
-- cd_dispatch3d, cd_dispatch, ps-dispatch (read directly), qs-dispatch and rcore_dispatch
-- (alerts captured as they're sent). Only calls for these jobs are shown.
-- vinewood-dispatch is used first when it's running: clinicians can attach to calls and post
-- call updates from the MDT. Callsigns are shared with the dispatch (see README).
---------------------------------------------------------------------
Config.Dispatch = {
    enabled = true,
    Jobs = { 'ambulance', 'ems' },
    Service = 'ambulance',       -- vinewood-dispatch service to show calls for
    KeepMinutes = 30,
    MaxCalls = 60,
    Sources = {                 -- set one to false to ignore it
        -- ['ps-dispatch'] = false,
    },
}

---------------------------------------------------------------------
-- Integrations
---------------------------------------------------------------------
Config.Integrations = {
    policeResource = 'vinewood-mdt', -- informational; the police MDT calls our exports
}

-- Live vitals ("Pull vitals from patient" on the ePRF).
-- Read from OSP Ambulance V2 (exports.osp_ambulance:GetAmbulanceData). Change the
-- resource name if you renamed the folder.
Config.Vitals = {
    resource = 'osp_ambulance',
    distance = 5.0,             -- how close the patient must be (metres)
    saveBloodType = true,       -- fill the patient record's blood type if it's empty
}

-- Optional override for a different medical script. Return a table like
-- { hr=, sbp=, dbp=, rr=, spo2=, temp=, gcs=, bm=, pain=, avpu= } or nil to use OSP.
Config.GetVitals = nil

---------------------------------------------------------------------
-- Training and qualifications
---------------------------------------------------------------------
Config.Training = {
    enabled = true,
    warnDays = 30,              -- show "expiring" this many days before expiry

    -- Competencies are signed off by a trainer or supervisor. expiryMonths = 0 never expires.
    Competencies = {
        { id = 'driving',     label = 'Blue light driving',          expiryMonths = 36 },
        { id = 'bls',         label = 'Basic life support',          expiryMonths = 12 },
        { id = 'als',         label = 'Advanced life support',       expiryMonths = 12 },
        { id = 'airway',      label = 'Advanced airway (i-gel)',     expiryMonths = 12 },
        { id = 'prescribing', label = 'Independent prescribing',     expiryMonths = 24 },
        { id = 'blood',       label = 'Blood transfusion',           expiryMonths = 12 },
        { id = 'hems',        label = 'HEMS / air operations',       expiryMonths = 12 },
        { id = 'safeguarding',label = 'Safeguarding level 2',        expiryMonths = 36 },
        { id = 'major',       label = 'Major incident (JESIP)',      expiryMonths = 24 },
        { id = 'mentor',      label = 'Practice educator / mentor',  expiryMonths = 0  },
    },

    -- Courses. A pass signs off the competencies in `grants` automatically.
    Courses = {
        { id = 'induction',  label = 'Service induction',                 expiryMonths = 0,  grants = {} },
        { id = 'bls',        label = 'Basic Life Support (BLS)',          expiryMonths = 12, grants = { 'bls' } },
        { id = 'als',        label = 'Advanced Life Support (ALS)',       expiryMonths = 12, grants = { 'als', 'airway' } },
        { id = 'driving',    label = 'Emergency response driving (C1)',   expiryMonths = 36, grants = { 'driving' } },
        { id = 'phtls',      label = 'Pre-hospital trauma (PHTLS)',       expiryMonths = 24, grants = {} },
        { id = 'prescriber', label = 'Non-medical prescribing',           expiryMonths = 24, grants = { 'prescribing' } },
        { id = 'ccp',        label = 'Critical care / HEMS course',       expiryMonths = 12, grants = { 'hems', 'blood' } },
        { id = 'safeguard',  label = 'Safeguarding adults and children',  expiryMonths = 36, grants = { 'safeguarding' } },
        { id = 'jesip',      label = 'JESIP major incident',              expiryMonths = 24, grants = { 'major' } },
    },

    -- Clinical scope that also needs a valid competency, on top of rank.
    -- An expired or revoked competency removes that scope until it's renewed.
    -- Set enforceScope = false to show training records without changing scope.
    enforceScope = true,
    ScopeRequires = {
        transfuse = 'blood',
        prescribe = 'prescribing',
        hems      = 'hems',
    },

    Probation = {
        defaultWeeks = 6,       -- suggested length when starting probation
    },
}
