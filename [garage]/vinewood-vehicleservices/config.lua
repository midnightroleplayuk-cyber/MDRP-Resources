Config = {}

-- 'auto', 'qbx', 'qb' or 'esx'
Config.Framework = 'qbx'

Config.Debug = false   -- extra console logging (new vehicle cover etc.)

Config.Currency = '£'
Config.DateFormat = '%d/%m/%Y'

-- Length of one "day" in seconds for policy terms and MOT validity.
-- 86400 = real days. Drop it (e.g. 60) while testing.
Config.DaySeconds = 86400

---------------------------------------------------------------------------
-- Licence hook
-- Return points (number) and disqualified (boolean) for a citizenid.
-- Wire this to your citydriving licence script. Return nil if unknown.
---------------------------------------------------------------------------
Config.GetLicence = function(citizenid)
    -- Example:
    -- local rec = exports['citydriving']:GetLicence(citizenid)
    -- if rec then return rec.points, rec.disqualified end
    return nil
end

---------------------------------------------------------------------------
-- Insurance (NPC broker offices)
---------------------------------------------------------------------------
Config.Insurance = {
    brokers = {
        {
            label = 'Vinewood Insurance Brokers',
            coords = vec4(-1083.05, -245.86, 37.76, 206.0),
            ped = 'a_m_y_business_02',
            blip = { sprite = 408, colour = 2, scale = 0.7 },
        },
    },
    interactDistance = 2.5,     -- textUI fallback when ox_target is not running
    serverRange = 6.0,          -- server-side check that the player is at a broker

    account = 'bank',
    basePremium = 120,          -- base price for 7 days of cover
    defaultValue = 25000,       -- vehicle value when the price can't be found

    covers = {
        { id = 'tpo',  label = 'Third Party Only',                mult = 1.00, valueRate = 0.000, anyDriver = false },
        { id = 'tpft', label = 'Third Party, Fire and Theft',     mult = 1.25, valueRate = 0.004, anyDriver = false },
        { id = 'comp', label = 'Comprehensive',                   mult = 1.60, valueRate = 0.008, anyDriver = true  },
    },

    terms = {
        { days = 7,  label = '7 days',  mult = 1.00 },
        { days = 14, label = '14 days', mult = 1.85 },
        { days = 30, label = '30 days', mult = 3.60 },
    },

    anyDriverMult = 1.5,        -- comprehensive only
    namedDriverCost = 25,       -- per named driver, per 7 days
    maxNamedDrivers = 3,
    namedDriverRange = 10.0,    -- named drivers must be stood with the policyholder

    -- Highest band first. Uses Config.GetLicence.
    pointsLoading = {
        { points = 9, mult = 1.75 },
        { points = 6, mult = 1.35 },
        { points = 3, mult = 1.15 },
    },
    refuseDisqualified = true,

    cancelRefund = 0.5,         -- share of the unused premium refunded on cancel/replace
    voidOnKeeperChange = true,  -- policy stops covering if the vehicle changes keeper

    certificateItem = false,    -- e.g. 'insurance_certificate' (ox_inventory)
    society = nil,              -- function(amount, reason) end  -- where premiums go
}

---------------------------------------------------------------------------
-- MOT (mechanic job at garages)
---------------------------------------------------------------------------
Config.MOT = {
    command = 'mot',
    stationsCommand = 'motstations', -- lists approved MOT stations; click one to set a waypoint

    -- Which mechanic setup decides where MOTs happen and who can test:
    --  'auto'        jg-mechanic if it's running, otherwise the garages and jobs below
    --  'jg-mechanic' always use jg-mechanic
    --  'config'      only the garages and jobs below. Use this for qb-mechanicjob,
    --                qbx_mechanicjob, esx_mechanicjob, wasabi_mechanic and other
    --                scripts that use framework jobs.
    provider = 'auto',

    jgMechanic = {
        enabled = true,
        ownedOnly = true,           -- only "owned" locations, not self-service
        locationPadding = 15.0,     -- metres added to each location's size for the test area
        keepConfigGarages = false,  -- also allow the garages below alongside jg locations
        -- Built-in job system (Config.UseFrameworkJobs = false in jg-mechanic).
        -- Checked on start; if not found, testers are matched on the location's job.
        employeesTable = 'mechanic_employees',
        employeeIdColumn = 'identifier',
        employeeMechanicColumn = 'mechanic',
        serviceAdvisory = true,     -- "due a service" advisory from jg-mechanic servicing
    },

    -- Odometer reading on each test (jg-vehiclemileage, or the hook below).
    recordMileage = true,
    -- GetMileage = function(vehicle, plate) return miles end,

    -- Custom permission hook for any other mechanic script. Return true/false,
    -- or nil to fall through to the default checks.
    -- CanTest = function(src, garage) return nil end,

    jobs = { mechanic = 0 },    -- job = minimum grade (config garages)
    requireDuty = true,

    -- Used when provider = 'config' (or no jg-mechanic). A garage can have its own
    -- jobs = { bennys = 0 } to override the list above.
    garages = {
        { label = "Benny's Original Motorworks", coords = vec3(-211.55, -1324.55, 30.89), radius = 25.0 },
        { label = 'LS Customs Burton',          coords = vec3(-337.39, -136.92, 39.01),  radius = 20.0 },
    },

    validDays = 30,
    carryOverDays = 7,          -- passing within this many days of expiry keeps the old expiry date
    duration = 20000,           -- test length in ms
    cooldown = 15,              -- seconds between tests per tester
    requireRegistered = true,   -- only registered (owned) vehicles can be tested
    historyLimit = 10,

    fee = 55,                   -- paid by the customer (server ID entered by the tester)
    account = 'bank',
    testerCommission = 0.30,    -- tester's cut of the fee
    society = nil,              -- function(amount, garageLabel) end -- the rest of the fee
    customerRange = 10.0,

    -- Detected by the game. dangerous = vehicle must not be driven.
    autoChecks = {
        lights     = { label = 'Headlamp damaged or inoperative',            dangerous = false },
        tyres      = { label = 'Tyre deflated or seriously damaged',         dangerous = true  },
        windscreen = { label = "Windscreen damaged in driver's line of sight", dangerous = false },
        doors      = { label = 'Door missing or insecure',                   dangerous = false },
        body       = { label = 'Body or chassis seriously damaged',          dangerous = true  },
        engine     = { label = 'Engine fault / excessive emissions',         dangerous = false },
        plate      = { label = 'Registration plate missing or illegible',    dangerous = false },
    },
    bodyFailBelow = 550.0,      -- GetVehicleBodyHealth (0-1000)
    engineFailBelow = 500.0,    -- GetVehicleEngineHealth (-4000-1000)

    -- Ticked by the tester.
    manualChecks = {
        { id = 'brakes',    label = 'Brakes',                 dangerous = true  },
        { id = 'steering',  label = 'Steering and suspension', dangerous = true  },
        { id = 'seatbelts', label = 'Seatbelts',              dangerous = false },
        { id = 'horn',      label = 'Horn',                   dangerous = false },
        { id = 'exhaust',   label = 'Exhaust system',         dangerous = false },
        { id = 'mirrors',   label = 'Mirrors and wipers',     dangerous = false },
    },

    certificateItem = false,    -- e.g. 'mot_certificate' (ox_inventory), given to the customer on a pass
}

---------------------------------------------------------------------------
-- Vehicle tax (VED) and SORN
---------------------------------------------------------------------------
Config.Tax = {
    online = true,              -- /tax works anywhere (like GOV.UK). Always available at brokers.
    command = 'tax',
    account = 'bank',

    requireInsurance = true,    -- vehicle must be insured to tax it
    requireMOT = true,          -- vehicle must have a current MOT certificate

    -- Band by vehicle value (same value source as insurance). weekly = price per 7 days.
    bands = {
        { maxValue = 15000,  label = 'Band A', weekly = 15 },
        { maxValue = 40000,  label = 'Band B', weekly = 30 },
        { maxValue = 100000, label = 'Band C', weekly = 55 },
        { maxValue = nil,    label = 'Band D (expensive car supplement)', weekly = 90 },
    },
    defaultValue = 25000,

    terms = {
        { days = 7,  label = '7 days',  mult = 1.0 },
        { days = 30, label = '30 days', mult = 4.0 },
    },

    cancelRefund = 1.0,         -- share of unused whole days refunded on cancel or SORN
    endsOnKeeperChange = true,  -- tax and SORN don't pass to a new keeper
    society = nil,              -- function(amount) end -- where tax money goes
}

---------------------------------------------------------------------------
-- Society vehicles (jg-advancedgarages job/gang garages)
---------------------------------------------------------------------------
Config.Fleet = {
    enabled = true,

    -- Crown / emergency vehicles: no insurance, MOT or tax needed. They show as
    -- "Exempt" in the MDT and never trigger ANPR hits. job = label shown.
    exemptJobs = {
        police = 'Police (Crown vehicle)',
        ambulance = 'Ambulance service (Crown vehicle)',
        fire = 'Fire and rescue (Crown vehicle)',
    },

    -- Spawner garages don't save vehicles, so they're recognised by model while
    -- spawned. Models from jg-advancedgarages spawner garages for the jobs above are
    -- read automatically; add any others here.
    importJgSpawners = true,
    exemptModels = {
        -- { model = 'police3', label = 'Police (Crown vehicle)' },
    },

    -- Other society vehicles (mechanic, taxi, gangs...) need insurance, MOT and tax
    -- like anyone else. Bosses can manage them at a broker and with /tax.
    manageGrade = nil,        -- or a grade number; nil = framework boss flag only
    gangs = true,             -- gang bosses can manage gang vehicles too
    anyDriver = true,         -- society policies cover any member/driver
    anyDriverMult = 1.0,      -- premium multiplier for that cover
}

---------------------------------------------------------------------------
-- New vehicles (e.g. from jg-dealerships): free insurance, MOT and tax
-- Given by exports['vinewood-vehicleservices']:IssueNewVehicle(plate, src, opts)
---------------------------------------------------------------------------
Config.NewVehicle = {
    enabled = true,
    days = 30,                  -- length of each, in Config.DaySeconds days
    insurance = true,
    cover = 'tpft',             -- id from Config.Insurance.covers
    mot = true,
    tax = true,
    societyVehicles = true,     -- also cover vehicles bought for a society/job
    motTester = 'New vehicle registration',
    notify = true,
}

---------------------------------------------------------------------------
-- Police quick check (/mid) for servers without vinewood-mdt
---------------------------------------------------------------------------
Config.Police = {
    command = 'mid',
    jobs = { police = 0 },
}
