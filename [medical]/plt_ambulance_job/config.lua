Config = {}

Config.Debug = false
Config.Language = "en"
Config.UseLicenseWhitelist = false -- Optional: set true to allow access via listed licenses
Config.LicenseWhitelist = {
    "license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
}

Config.CommandName = "mhsadmin"
Config.Permission = "admin" -- who can use the command
Config.AdminBypass = false -- if true, admins bypass all rankings, duty, etc. (mainly for config/testing)
Config.ShowNotifications = true -- false = disable all internal notifications
Config.EnableBlurEffect = true 
    -- true = enable ui/injury blur
    -- false = no blur effects

Config.MDT = {
    enabled = false, -- Medical usually doesn't link to police MDT BOLOs
    type = 'export', 
}

Config.DefaultNodes = {
    departments = {
        { id = 'ambulance', label = 'Ambulance', type = 'department' },
        { id = 'fire', label = 'Fire Dept', type = 'department' },
    },
    permissions = {
        { id = 'garage', label = 'Access Garage', type = 'permission' },
        { id = 'vault', label = 'Open Safe', type = 'permission' },
    }
}

Config.EMSItems = {
    first_kit = {
        { name = "plt_medkit", label = "Medkit", icon = "plt_medkit.png", weight = 500 },
        { name = "plt_bandage", label = "Bandage", icon = "plt_bandage.png", weight = 100 },
        { name = "plt_painkillers", label = "Painkillers", icon = "plt_painkillers.png", weight = 50 },
    },
    operations = {
        { name = "plt_surgical_kit", label = "Surgical Kit", icon = "plt_surgical_kit.png", weight = 1000 },
        { name = "plt_surgical_scissors", label = "Surgical Scissors", icon = "plt_surgical_scissors.png", weight = 200 },
    },
    equipments = {
        { name = "plt_medical_bag", label = "Medical Bag", icon = "plt_medical_bag.png", weight = 2000 },
        { name = "plt_bp_monitor", label = "BP Monitor", icon = "plt_bp_monitor.png", weight = 500 },
    }
}

Config.Pharmacy = {
    Locations = {
        { coords = vector3(311.2, -594.3, 43.3), heading = 10.0, label = "MHS Pillbox Pharmacy" },
        { coords = vector3(1831.5, 3677.4, 34.3), heading = 210.0, label = "Sandy Shores Clinic" },
        { coords = vector3(-246.8, 6330.5, 32.4), heading = 315.0, label = "Paleto Bay Medical" }
    },
    Insurance = {
        Price = 5000, -- Cost to buy medical insurance
        Discount = 0.5, -- 50% off
        Duration = 7, -- Days (RP wise, we can track this or keep it permanent until reset)
    },
    Items = {
        { name = "plt_bandage", label = "Elastic Bandage", price = 50, professionalOnly = false, prescriptionRequired = false, icon = "plt_bandage.png" },
        { name = "plt_painkillers", label = "Painkillers (OTC)", price = 150, professionalOnly = false, prescriptionRequired = false, icon = "plt_painkillers.png" },
        -- { name = "plt_painkillers_adv", label = "Advanced Painkillers", price = 350, professionalOnly = false, prescriptionRequired = true, icon = "plt_painkillers_adv.png" },
        { name = "plt_antibiotics", label = "Antibiotics", price = 500, professionalOnly = false, prescriptionRequired = true, icon = "plt_antibiotics.png" },
        { name = "plt_medkit", label = "Advanced First Aid Kit", price = 1200, professionalOnly = false, prescriptionRequired = true, icon = "plt_medkit.png" },
        -- { name = "plt_surgical_kit", label = "Field Surgical Kit", price = 2500, professionalOnly = true, prescriptionRequired = false, icon = "plt_surgical_kit.png" },
        { name = "plt_surgical_scissors", label = "Surgical Scissors", price = 300, professionalOnly = true, prescriptionRequired = false, icon = "plt_surgical_scissors.png" },
        { name = "plt_bp_monitor", label = "Digital BP Monitor", price = 850, professionalOnly = true, prescriptionRequired = false, icon = "plt_bp_monitor.png" },
        { name = "plt_medical_bag", label = "EMS Field Bag", price = 1500, professionalOnly = true, prescriptionRequired = false, icon = "plt_medical_bag.png" },
        { name = "iak_wheelchair", label = "Wheelchair", price = 2500, professionalOnly = false, prescriptionRequired = true, icon = "wheelchair.png" },
        { name = "plt_walking_stick", label = "Walking Stick", price = 900, professionalOnly = false, prescriptionRequired = false, icon = "walking_stick.png" },
        { name = "plt_cane", label = "Cane", price = 900, professionalOnly = false, prescriptionRequired = false, icon = "cane.png" },
        { name = "plt_crutches", label = "Crutches", price = 1100, professionalOnly = false, prescriptionRequired = false, icon = "walking_stick.png" }
    }
}

Config.WheelchairItemName = "iak_wheelchair" -- The item name in your inventory
Config.WheelchairDuration = 15 -- How many minutes the wheelchair stays before disappearing
Config.WalkingAidClipset = "move_m@limping@a" -- Clipset used when cane/walking stick effect is active
Config.CrutchesClipset = "move_lester_CaneUp" -- Clipset used specifically for crutches
Config.CrutchesModel = "v_med_crutch01" -- GTA prop model name for the crutches object


Config.RadioCodes = {
    { label = "AVAIL", code = "10-8" },
    { label = "EN ROUTE", code = "10-97" },
    { label = "ON SCENE", code = "10-23" },
    { label = "BUSY", code = "10-6" },
    { label = "OFF DUTY", code = "10-7" },
    { label = "HOSPITAL", code = "10-15" },
    { label = "RTB", code = "10-19" },
}

Config.DefaultDeptBalance = 500000

-- Department finance: "internal", "Renewed-Banking", or "RxBanking"
Config.DepartmentFinance = "internal"

Config.EMSInvoice = {
    CommandName = "mhsinvoice",
    PayCommandName = "paymhsinvoice",
    DeclineCommandName = "declinemhsinvoice",
    MaxDistance = 8.0,
    ExpireMinutes = 10,
    MaxAmount = 100000,
    PaymentAccounts = { "bank", "cash" }
}

-- Health & Injury System
Config.Health = {
    DownedThreshold = 0,      -- Health at which player enters downed state (0 = standard death)
    BleedChance = 0,         -- Percentage chance to start bleeding on hit
    BleedInterval = 2000,     -- Damage interval in MS
    BleedDecalMin = 2,        -- Min bleeding level to start leaving blood on floor
    MaxInjuryLevel = 5,       -- Max level for a specific body part injury
    DeathTimer = 5,         -- Time in seconds before bleeding out (default 5 mins)
    Knockout = {
        Enabled = true,
        HealthPercent = 50,
        WakeHealthPercent = 60,
        Duration = 30,
        Weapons = {
            [`WEAPON_UNARMED`] = true,
            [`WEAPON_KNUCKLE`] = true,
            [`WEAPON_BAT`] = true,
            [`WEAPON_NIGHTSTICK`] = true,
            [`WEAPON_CROWBAR`] = true,
            [`WEAPON_HAMMER`] = true,
            [`WEAPON_GOLFCLUB`] = true,
            [`WEAPON_POOLCUE`] = true,
            [`WEAPON_WRENCH`] = true,
            [`WEAPON_FLASHLIGHT`] = true
        }
    },
    CallEMSTimer = 0,        -- Seconds to wait before being able to call EMS (press G)
    HospitalTransportDelay = 5, -- Seconds before "Go To Hospital" is allowed on death screen
    ClearInventoryOnHospitalRespawn = false, -- If true, clears inventory only when using deathscreen hospital teleport
    
    -- Bleeding Settings
    BleedChance = 0,         -- Percentage chance to start bleeding on hit
    BleedInterval = 2000,     -- Damage interval in MS
    BleedRate = 1,            -- Health lost per interval (set to 0 to disable persistent bleeding damage)
    BulletBleedChance = 50,   -- Chance to start bleeding when hit by a bullet
    BleedDecalMin = 2,        -- Min bleeding level to start leaving blood on floor
    
    -- Bone Fracture Settings
    FractureChance = 60,     -- % chance to break a bone on fatal fall/car hit
    FractureTime = 600,      -- Seconds (10 mins) the fracture lasts if not treated by EMS
    LimpAnimation = "move_m@limping@a", -- Animation clip set for leg fractures
    AllowRunningWhileInjured = false, -- If true, injured players can still sprint
    BandageAsClothing = true, -- If false, bandages still treat injuries but will not change clothing/accessory component 7

    -- Restrictions while player is dead/downed
    DeadRestrictions = {
        DisableVoice = true,     -- Mute player voice while downed; restored on revive
        DisableInventory = true  -- Blocks inventory usage while downed; restored on revive
    },

    -- Self-use medication progress bars (duration in ms)
    Medication = {
        plt_bandage = { duration = 4000, dict = "missheistprowlprepb", anim = "low_reach_loop", label = "applying_bandage" },
        plt_painkillers = { duration = 3000, dict = "mp_suicide", anim = "pill", label = "taking_medication" },
        plt_painkillers_adv = { duration = 3500, dict = "mp_suicide", anim = "pill", label = "taking_medication" },
        plt_antibiotics = { duration = 3500, dict = "mp_suicide", anim = "pill", label = "taking_medication" },
        plt_medkit = { duration = 5000, dict = "missheistprowlprepb", anim = "low_reach_loop", label = "applying_first_aid" },
    },
}

Config.ClothingRemoval = {
    male = {
        top = {
            { component = 11, drawable = 15, texture = 0, palette = 0 },
            { component = 8, drawable = 15, texture = 0, palette = 0 },
            { component = 3, drawable = 15, texture = 0, palette = 0 },
        },
        bottom = {
            { component = 4, drawable = 21, texture = 0, palette = 0 },
        },
    },
    female = {
        top = {
            { component = 11, drawable = 15, texture = 0, palette = 0 },
            { component = 8, drawable = 34, texture = 0, palette = 0 },
            { component = 3, drawable = 15, texture = 0, palette = 0 },
        },
        bottom = {
            { component = 4, drawable = 15, texture = 0, palette = 0 },
        },
    },
}

-- Built-in deathscreen toggle.
-- true  = use plt_ambulance_job deathscreen UI/logic
-- false = disable built-in deathscreen so you can use another deathscreen script
Config.Deathscreen = {
    UseBuiltIn = true
}

-- Local NPC Doctor (when EMS are off duty)
Config.LocalDoctor = {
    HealTime = 5000, -- Time in MS to be healed by Local Doctor
    LieAnim = { dict = "amb@world_human_sunbathe@male@back@base", name = "base" }, -- Emote while being treated
    DoctorPedModel = "s_m_m_doctor_01", -- Ped model for Local Doctor NPC
    ChargePlayer = true, -- false = free check-in, true = charge the configured price
    Price = 1,
    PaymentAccount = "bank", -- "cash" or "bank"
}

-- Medical Interactions
Config.Medical = {
    EMSJobs = { 'ambulance', 'fire' }, -- Jobs allowed to use medical target options
    DiagnosisTime = 3000,              -- Time to diagnose in MS
    ReviveTime = 10000,                -- Time to revive in MS
    TreatmentTime = 5000,              -- Time to apply basic treatment in MS
    EnablePronounceBodyBag = true,     -- If true, EMS can pronounce dead and replace ped with a body bag
    BodyBagModel = "xm_prop_body_bag",
    BodyBagOffset = { x = 0.0, y = 0.0, z = 0.0 },
    BodyBagRotation = { x = 0.0, y = 0.0, z = 0.0 }
}

-- Fernocot / Ambulance Bed (from vehicle trunk)
Config.FernocotModel = "fernocot" -- Model name of the ambulance bed prop
-- Vehicle models that have the bed in trunk. Add the exact spawn name from your vehicle node (e.g. ambulance, ems_ambulance).
Config.FernocotVehicleModels = { 'ambulance', 'firetruk', 'ambulance2' }
Config.FernocotDisableVehicleCollision = true -- Prevent stretcher/ambulance physics collisions that can launch vehicles
-- Player position when lying on bed (offset from bed center).
Config.FernocotLieOffset = { x = 0.020, y = 0.000, z = 2.100 }
-- Lie pose: vanilla GTA5 animations. Alternatives: savecouch@/t_sleep_loop_couch, misslamar1dead_body/dead_idle
Config.FernocotLieAnim = { dict = "amb@world_human_sunbathe@male@back@base", name = "base" }
-- Heading offset when lying (degrees). 0 = feet toward bed head.
Config.FernocotLieHeading = 86.0
-- Drag offset: bed IN FRONT of player (positive Y = forward). Like pushing a stretcher.
Config.FernocotDragOffset = { x = -0.190, y = 1.520, z = -0.960 }
Config.FernocotDragRotation = { x = 0.0, y = 1.0, z = 96.0 }

-- Fake Players for Display
Config.ShowFakePlayers = true
Config.FakePlayers = {
    { cid = "FAKE_1", name = "Dr. John Doe", jobLabel = "Ambulance", jobGradeLabel = "Chief", jobName = "ambulance", jobGradeLevel = 5, isOnline = true },
    { cid = "FAKE_2", name = "Jane Smith", jobLabel = "Ambulance", jobGradeLabel = "Paramedic", jobName = "ambulance", jobGradeLevel = 2, isOnline = false },
    { cid = "FAKE_3", name = "Mike Miller", jobLabel = "Fire Dept", jobGradeLabel = "Captain", jobName = "fire", jobGradeLevel = 4, isOnline = true },
}
