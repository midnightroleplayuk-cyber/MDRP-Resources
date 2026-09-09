Config = Config or {}

-- DAMAGE SYSTEM
Config.Framework = 'qb' -- don't touch this! (Framework setter)
Config.startDamageTimer = 1000 -- Time in ms before the player damages gets applied when loading the chracters
Config.UseRadialProgressBar = false -- Use the radial progress bar instead of the default one
Config.UseOxNotif = true -- Set this to false if you want to use the default framework notificatins
Config.UsedInventory = '' -- empty is framework inventory

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- To change the localization, go into server.cfg and paste the following code: setr ox:locale en
-- Change en with another lang of your choice, all available langs can be foung in /lang folder of the script.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 

Config.UseTarget = true -- Set to false if you don't want to use targetting at all and instead use drawtext
Config.UseOxTarget = true
Config.TargetName = false -- The name of the target resource (only needed if you use qb-target or qtarget)
Config.Dispatch = "default" -- 'default', 'ps-dispatch', 'cd_dispatch', 'lb-phone', 'lb-tablet', 'piotreq_gmt' (aliases: ps, cd, cd_dispatch3d, gmt)
Config.Banking = "default" -- 'default', 'okokBanking' (aliases: okok), 'wasabi_banking' (alias: wasabi), 'osp-banking' (aliases: osp, osp_banking)
Config.DispatchNotifyButton = "G" -- Avoid G if cd_dispatch uses G for Respond; change this or the cd_dispatch respond key
Config.UseXsound = false -- If set to false you'll use native audio, which is to be recommended to everyone who's got it working. 

Config.OpenKey = "O" -- The default key to open the medical menu
Config.OpenTargetKey = 'j' -- The default key to open the target medical menu (only requiered if you not use a target system)
Config.SkellyKey = "K" -- The default key to open the skelly overview
Config.EditSkellyKey = "I" -- Key or ''
Config.MedicalMenuMaxDistance = 10 -- Max distance a player can use the medical menu on another player 

Config.ServerDelay = 100 -- How many ms the server is behind by. Recommended to keep above 100ms. Should say in your server console by how far behind your server is.
Config.Debug = false -- Enable or disable debug mode to investigate issues with the script

Config.UseRoomLoad = false -- let us know if toggling this breaks/fixes screens

Config.MedicalMenuStyle = "console" -- 'default', 'console', 'legacy'
Config.AutoTriage = true -- When true, triage is computed automatically (blood, pain, LOC, severity). When false, medical staff must set triage manually.
Config.CustomDeathScreen = false -- Enable of disable a customised death timer screen, keep at false if you don't know what you are doing
Config.PopUpSkelly = true
Config.EnableWoundEditor = true -- Self-edit wounds/fractures for RP/scenes (command: woundeditor)
Config.WoundEditorAddOnly = true -- When true, players can only add new injuries (cannot remove existing wounds or turn off fractures)
Config.WoundEditorKey = '' -- Optional keybind; empty = command only
Config.ClientSettingsCommand = 'medicalsettings' -- Command to open personal FX settings menu
Config.ClientSettingsKey = '' -- Optional keybind; empty = command only

-- don't edit AmbulanceJobs! Enter your jobs in Config.Jobs (config/jobs.lua)
Config.AmbulanceJobs = {}

Config.InteractionDict = "anim@heists@narcotics@funding@gang_idle"
Config.InteractionAnim = "gang_chatting_idle01"

Config.JobBlips = true -- Whether or not ambulance personel can see eachother on the map.
Config.MinimalDoctors = 3 -- How many players with the ambulance job to prevent the hospital check-in system from being used
Config.DocCooldown = 1 -- Cooldown between doctor calls allowed, in minutes
Config.AIHealTimer = 10 -- How long it will take to be healed after checking in, in seconds
Config.WipeInventoryOnRespawn = true -- Enable or disable removing all the players items when they respawn at the hospital
Config.ExcludeItems = {'iphone', 'anotheritem'}
Config.Helicopter = "polmav" -- Helicopter model that players with the ambulance job can use
Config.LastStandTime = 120 -- How long before the player is percived as medically dead (in seconds)
Config.RespawnTime = 120 -- How long before the player can respawn (in seconds)
-- 'bed' = nearest available hospital bed (default). 'coords' = closest entry in Config.RespawnLocations (no bed).
-- Override HandleCustomRespawn / GetClosestRespawnLocation in client_open.lua (and server GetClosestRespawnLocation) for custom logic.
Config.RespawnMode = "bed"
Config.RespawnLocations = {
    -- vector4(x, y, z, heading),
    -- vector4(311.0, -583.0, 43.3, 340.0), -- Example: Pillbox front
}
Config.Crawl = true -- Enable to make the player crawl whilst in laststand
Config.PropDespawnTimer = 360000 -- How long before the ecg prop despawns after being placed in ms
Config.SavePlayerDataTimer = 60000 -- How often the player data should be saved in ms (the lower the more accurate the data is saved but the more performance impact) (The data is sent to the server so that the player data is saved when the player quits)
Config.AntiCombatLogLoop = 200 -- How often the anti combat log loop should run in ms (lower is better but has a higher performance impact)
Config.DeadBlipDelay = 360 -- How long the dead blip should be visible on the map in ms, with each tick of this reducing the transpaerncy of the blip 250 - 0
Config.AutomaticAmbulanceAlert = false -- Enable or disable the automatic ambulance alert when a player is downed
Config.inLastStandHealth = 150 -- MUST BE ABOVE ZERO 0, The health the player should have when they are in last stand
Config.DeathHealth = 200 -- MUST BE ABOVE ZERO 0, The health the player should have when they are dead
Config.XrayScreenTimeout = 10000 -- How long before the screen automatically shuts off after an xray
Config.CodeBlueTimeout = 300 -- The time in seconds before a code blue is automatically cleared (0 = disabled)
Config.BillCost = 2000 -- Price that players are charged for using the hospital check-in system
Config.WoundBills = false -- if this is true the checkin revive and respawn revive tooks wound calculator and set the price them
Config.WoundPrices = {
    ["abrasion"] = 200,
    ["avulsion"] = 100,
    ["contusion"] = 50,
    ["crush"] = 20,
    ["cut"] = 15,
    ["laceration"] = 30,
    ["lowvelocitywound"] = 80,
    ["mediumvelocitywound"] = 90,
    ["velocitywound"] = 100,
    ["puncturewound"] = 100,
    ["burn"] = 150,
    
    -- default price if wound missing in this list
    ["default"] = 50,
}

Config.MutePlayerOnLastStand = false
Config.MutePlayerOnDeath = true


-- Regen stuff
Config.BleedLossMultiplier = 1
Config.BleedingUpdate = 40000 -- How often should the bleeding update in ms?
Config.BloodRegen = 0.0025 -- The amount of blood that regen every 10 seconds in liter (6 liters is max). (When in stable condition)
Config.HealthRegen = 1 -- The amount of health that regen every 10 seconds in healthpoints (200 is max). (When in good condition)
Config.HealthRegenUpdate = 10000

Config.MinimumBleedAmountBeforeHealthDegen = 0.005 -- The minimum amount of blood that must be activly lost before health starts to degenerate
Config.HealthBleedingDegen = 1 -- The amount of health that degens every bleedingupdate, in healthpoints. (When bleeding)
Config.HealthDegenUpdate = 3000 -- How often the health should degenerate when bleeding in ms

Config.KillPlayerInCriticalCondition = true -- Enable or disable to kill player when in critical condition (lower bpm than 30 and next to no bloodpressure)

-- The different types of equipment and their time to apply in ms
Config.QuickCheckVitalsTime = 3000 -- How long it should take to check pulse etc in ms
Config.ReviveKitTime = 5000
Config.BodybagTime = 5000

-- SIDE EFFECTS
Config.SideEffectsTime = 60000 -- The interval for how often the side effects should be triggered in ms

Config.ArmInjuryChance = 10 -- Chance, in percent, that an arm injury side-effect gets applied
Config.ArmInjuryTimer = 10 -- How much time, in seconds. (This disables firing weapons and stearing a vehicles left/right)

Config.CameraShakeIntensity = 0.1 -- How intense the camera shake should be when injured
Config.LegInjuryChance = { -- The chance, in percent, that leg injury side-effects get applied
    Running = 30,
    Walking = 10
}

Config.UseMovementRate = true -- Might contradict with other gym scripts? Set to false if so
Config.MovementRate = { -- Set the player movement rate based on the leg health
    0.95,
    0.85,
    0.80,
}

Config.BleedTime = 5000 -- The interval for how often the bleed effect (only visual) should be triggered in ms

-- SCREEN EFFECTS
Config.PainThreshold = 10 -- The pain threshold for when the screen should start to flash
Config.PainFlashIntensity = 100 -- Default pain flash intensity (0-100). Players can still change this in personal settings

Config.BlackoutEffect = true -- Blackouts caused by very high or low bp, not to be confused with head injuries that can cause short blackouts.
Config.HeadInjuryChance = 25 -- Chance, in percent, that a head injury side-effect gets applied (MINI BLACKOUTS)

Config.PainEffect = true
Config.BleedEffect = true

-- Wheelchair and Crutch
Config.MaxWheelChairTime = 60 -- The maximum time a player can be set in a wheelchair in minutes
Config.MaxCrutchTime = 60 -- The maximum time a player can be set in a wheelchair in minutes


Config.AmbulanceBypassItems = false -- Set to true if you want to enable all buttons in ui for medics and disable item requierment

Config.UseGarageSystem = true -- left it true if you want use the integrated garage system

-- ELEVATOR CONFIGURATION
Config.ElevatorSound = "CONFIRM_BEEP" -- Sound played when the elevator is used (native frontend sound name)
Config.ElevatorSoundSet = "HUD_MINI_GAME_SOUNDSET" -- Soundset used for the elevator sound
Config.ElevatorUseFade = true -- Use the screen fade while travelling (recommended)

-- ECG CONFIGURATION
Config.Prop = "prop_ld_bomb"
Config.RenderDistance = 50 -- The rendering distance of an ECG, recommended to keep above 50 to avoid sync issues. 
Config.Alpha = 100 -- The prop transparency (51-300)
Config.AutoDeleteTime = 500 -- The time in seconds before the ECG is automatically deleted after being placed
Config.ECGCooldown = 1.5 -- The cooldown in seconds between being able to place ECGs

-- Recommended to have all different keys (only needed if you _dont_ use target)
-- Use a control name from config/controls.lua (e.g. 'E', 'G') or a 1-based index (e.g. 1, 2)
Config.PickupButton = "E"
Config.AttachButton = "G"
Config.DeleteButton = "Q"
Config.OptionsButton = "G"
Config.InjectButton = "M"
Config.CprButton = "L"

-- Change that control to detach the stretcher
Config.ReleaseStretcher = "E"

Config.Bones = { -- Correspond bone hash numbers to their label
    [0]     = 'NONE',
    [31085] = 'HEAD',
    [31086] = 'HEAD',
    [39317] = 'NECK',
    [57597] = 'SPINE',
    [23553] = 'SPINE',
    [24816] = 'SPINE',
    [24817] = 'SPINE',
    [24818] = 'SPINE',
    [10706] = 'UPPER_BODY',
    [64729] = 'UPPER_BODY',
    [11816] = 'LOWER_BODY',
    [45509] = 'LARM',
    [61163] = 'LARM',
    [18905] = 'LHAND',
    [4089] = 'LFINGER',
    [4090] = 'LFINGER',
    [4137] = 'LFINGER',
    [4138] = 'LFINGER',
    [4153] = 'LFINGER',
    [4154] = 'LFINGER',
    [4169] = 'LFINGER',
    [4170] = 'LFINGER',
    [4185] = 'LFINGER',
    [4186] = 'LFINGER',
    [26610] = 'LFINGER',
    [26611] = 'LFINGER',
    [26612] = 'LFINGER',
    [26613] = 'LFINGER',
    [26614] = 'LFINGER',
    [58271] = 'LLEG',
    [63931] = 'LLEG',
    [2108] = 'LFOOT',
    [14201] = 'LFOOT',
    [40269] = 'RARM',
    [28252] = 'RARM',
    [57005] = 'RHAND',
    [58866] = 'RFINGER',
    [58867] = 'RFINGER',
    [58868] = 'RFINGER',
    [58869] = 'RFINGER',
    [58870] = 'RFINGER',
    [64016] = 'RFINGER',
    [64017] = 'RFINGER',
    [64064] = 'RFINGER',
    [64065] = 'RFINGER',
    [64080] = 'RFINGER',
    [64081] = 'RFINGER',
    [64096] = 'RFINGER',
    [64097] = 'RFINGER',
    [64112] = 'RFINGER',
    [64113] = 'RFINGER',
    [36864] = 'RLEG',
    [51826] = 'RLEG',
    [20781] = 'RFOOT',
    [52301] = 'RFOOT',
}

Config.BoneIndexes = { -- Correspond bone labels to their hash number
    ['NONE'] = 0,
    ['HEAD'] = 31086,
    ['NECK'] = 39317,
    ['SPINE'] = 24818,
    ['UPPER_BODY'] = 64729,
    ['LOWER_BODY'] = 11816,
    ['LARM'] = 61163,
    ['LHAND'] = 18905,
    ['LFINGER'] = 26614,
    ['LLEG'] = 63931,
    ['LFOOT'] = 14201,
    ['RARM'] = 28252,
    ['RHAND'] = 57005,
    ['RFINGER'] = 64113,
    ['RLEG'] = 51826,
    ['RFOOT'] = 52301,
}
