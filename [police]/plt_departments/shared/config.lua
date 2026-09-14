Config = {}

Config.CommandName = "managedepts" -- Command to open the UI
Config.Permission = "admin"        -- Permission level to use the command
Config.AuthorizedLicenses = {
    "license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    -- Add more licenses here
}
Config.ShowNotifications = true     -- Set to false to disable all internal notifications
-- Notification system selector:
-- "nui" = built-in PLT notifications
-- "ox_lib" = ox_lib notifications
Config.NotificationSystem = "ox_lib"

Config.MDT = {
    enabled = true, -- Set to true to link BOLOs and Warrants from your MDT
    type = 'export', -- 'ps-mdt', 'qb-mdt', or 'custom'
    
    -- ONLY used if type is 'custom'
    customMappings = {
        bolos = {
            table = 'mdt_bolos',
            columns = {
                id = 'id',
                type = 'type',
                title = 'title',
                description = 'description',
                plate = 'plate',
                owner = 'owner',
                lastSeen = 'lastseen',
                issuedBy = 'author',
                issuedDate = 'date'
            }
        },
        warrants = {
            table = 'mdt_warrants',
            columns = {
                id = 'id',
                subject = 'title',
                charges = 'charges',
                issuedBy = 'author',
                issuedDate = 'date',
                description = 'details'
            }
        }
    }
}

-- Target System Configuration
-- Options: "qb-target", "ox_target"
Config.Target = "ox_target" 

Config.DefaultNodes = {
    departments = {
        { id = 'police', label = 'LSPD', type = 'department' },
        { id = 'bcso', label = 'Sheriff', type = 'department' },
        { id = 'sasp', label = 'State Police', type = 'department' },
        { id = 'ambulance', label = 'EMS', type = 'department' },
    },
    permissions = {
        { id = 'armory', label = 'Access Armory', type = 'permission' },
        { id = 'garage', label = 'Access Garage', type = 'permission' },
        { id = 'vault', label = 'Open Vault', type = 'permission' },
        { id = 'cameras', label = 'Access Cameras', type = 'permission' },
        { id = 'evidence', label = 'Access Evidence', type = 'permission' },
    }
}

Config.K9 = {
    Model = "a_c_shepherd", -- Default K9 model. You can change this to any ped model (e.g., "a_c_rottweiler", "a_c_husky", etc.)
    SniffDistance = 6.0,
    SniffResultDelay = 2000,
    RevealDetectedItem = false, -- false = officer only knows the K9 alerted, true = notify exact configured item label
    VoiceCommands = {
        Enabled = true,
        RequirePmaVoice = true,
        RequirePmaProximityState = true,
        AllowRadioCommands = false,
        Controls = { 249 }, -- INPUT_PUSH_TO_TALK, default pma-voice N key
        MaxDogDistance = 22.0,
        CooldownMs = 1200,
        MaxRecordingMs = 4500,
        MinRecordingMs = 250,
        PmaReleaseGraceMs = 120,
        TalkingPollMs = 20,
        PreferBrowserRecognition = false,
        Language = "en-US",
        ShowTranscript = true,
        ServerTranscribe = true,
        ApiKeyConvar = "plt_departments_k9_stt_api_key",
        Endpoint = "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent",
        Model = "gemini-3.1-flash-lite",
        MaxTokens = 32,
        MaxAudioBase64Length = 1200000,
        AudioBitsPerSecond = 24000,
        SilenceMs = 450,
        SilenceThreshold = 0.014,
        Debug = false
    },
    SniffItems = {
        { name = "phone", label = "Marijuana" },
        { name = "weed", label = "Marijuana" },
        { name = "cocaine_bag", label = "Cocaine" },
        { name = "coke_baggy", label = "Cocaine" },
        { name = "meth", label = "Methamphetamine" },
        { name = "crack_baggy", label = "Crack Cocaine" },
        { name = "oxy", label = "Oxycodone" },
        { name = "weapon_pistol", label = "Firearm" },
        { name = "weapon_combatpistol", label = "Firearm" },
        { name = "weapon_smg", label = "Firearm" }
    }
}

Config.AIDispatcher = {
    Enabled = true,
    RequirePmaVoice = true,
    RequirePmaProximityState = true,
    RequireFrequencyRadio = true, -- Only listen while connected to and transmitting on the PLT F6 frequency radio.
    RequireDispatchWakeWord = true,
    CooldownMs = 250,
    MaxRecordingMs = 30000, -- Records until PLT pma-radio PTT is released, with this as a safety cap.
    MinRecordingMs = 250,
    PmaReleaseGraceMs = 20,
    TalkingPollMs = 5,
    StopOnSilence = false,
    RequireDetectedVoice = true,
    VoiceDetectThreshold = 0.012,
    MinVoiceMs = 140,
    Language = "en-US",
    ShowTranscript = false,
    ServerAnalyze = true,
    ApiKeyConvar = "plt_departments_k9_stt_api_key", -- Reuses your existing Gemini key unless you change this.
    Endpoint = "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent",
    Model = "gemini-3.1-flash-lite",
    MaxTokens = 320,
    SemanticRetry = true, -- If audio parsing is unsure, ask Gemini to reason over the transcript instead of relying on fixed phrases.
    SemanticRetryMaxTranscript = 1200,
    AnalysisTimeoutMs = 45000,
    MaxAudioBase64Length = 1200000,
    AudioBitsPerSecond = 16000,
    SilenceMs = 1200,
    SilenceThreshold = 0.004,
    ReplyVoice = true,
    HumanReplyVoice = true,
    InstantBrowserVoice = false, -- Keep Gemini's realistic dispatcher voice instead of the faster browser voice.
    BackgroundGeminiTTS = false,
    TTSProvider = "gemini",
    TTSApiKeyConvar = "plt_departments_k9_stt_api_key", -- Reuses your Gemini key.
    TTSModel = "gemini-3.1-flash-tts-preview",
    TTSFallbackModels = { "gemini-2.5-flash-preview-tts" },
    TTSVoiceName = "Kore", -- Gemini female voice: firm, realistic dispatcher tone.
    TTSFallbackVoices = { "Leda", "Zephyr", "Charon" }, -- Female fallbacks first; Charon last as a reliable backup.
    TTSMaxTextLength = 420,
    TTSPromptStyle = "Calm realistic police radio dispatcher, concise: ",
    TTSAudioRate = 24000,
    TTSRetries = 1,
    TTSRetryDelayMs = 0,
    TTSClientTimeoutMs = 45000,
    TTSCache = true,
    TTSCacheMax = 32,
    BrowserVoiceFallback = false,
    ReplyRate = 0.9,
    ReplyPitch = 0.72,
    ReplyVolume = 0.95,
    ReplyRadioEffect = true,
    ReplyRadioNoiseVolume = 0.045,
    ReplySquelchVolume = 0.16,
    UnitFallback = "Unit",
    ReplyNotify = false,
    ConsoleDebug = true,
    Debug = false,

    EMSFire = {
        EMSCode = "EMS",
        FireCode = "FIRE",
        Forward = {
            Enabled = false,
            Resource = "", -- Example: "your_ambulance_resource"
            Export = "", -- Example: "CreateDispatchCall". Called as exports[Resource][Export](payload)
            ServerEvent = "", -- Example: "your_ambulance:server:newDispatchCall"
            ClientEvent = "", -- Optional: broadcasts to ambulance/fire clients if your system uses a client event.
            Jobs = { "ambulance", "ems", "fire" }
        }
    }
}

Config.AIPoliceNPC = {
    Enabled = true,
    ApiKeyConvar = "plt_departments_k9_stt_api_key", -- Reuses your existing Gemini key by default.
    Endpoint = "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent",
    Model = "gemini-3.1-flash-lite",
    MaxTokens = 260,
    Temperature = 0.25,
    TimeoutMs = 30000,
    CooldownMs = 1200,
    MaxInteractDistance = 7.0,
    RequirePmaVoice = false,
    RecordOnTarget = true,
    StopOnSilence = true,
    RequireDetectedVoice = true,
    VoiceDetectThreshold = 0.035,
    MinVoiceMs = 100,
    NoVoiceTimeoutMs = 5000,
    WaitPrompt = "Speak to the officer",
    RecordingPrompt = "Speak now...",
    CancelKey = 177,
    PmaVoiceControls = { 249 },
    StartListenTimeoutMs = 12000,
    TalkingPollMs = 5,
    MaxRecordingMs = 9000,
    MinRecordingMs = 350,
    SilenceMs = 900,
    SilenceThreshold = 0.022,
    PmaReleaseGraceMs = 0,
    MediaRecorderTimesliceMs = 20,
    MaxKnowledgeChars = 24000,
    MaxQuestionChars = 500,
    MaxAudioBase64Length = 1200000,
    STTMaxTokens = 96,
    VoiceMaxMs = 12000,
    VoiceMinMs = 650,
    AudioBitsPerSecond = 24000,
    ReplyVoice = true,
    FastAudioAnswer = true, -- One Gemini audio request extracts the question and answer, avoiding separate STT + answer calls.
    InstantBrowserVoice = false, -- Keep Gemini's realistic NPC voice instead of the faster browser voice.
    BackgroundGeminiTTS = false,
    TTSApiKeyConvar = "plt_departments_k9_stt_api_key",
    TTSModel = "gemini-3.1-flash-tts-preview",
    TTSFallbackModels = { "gemini-2.5-flash-preview-tts" },
    TTSVoiceName = "Kore",
    TTSFallbackVoices = { "Leda", "Zephyr", "Charon" },
    TTSMaxTextLength = 420,
    TTSPromptStyle = "Say as a realistic calm front desk police officer: ",
    TTSAudioRate = 24000,
    Language = "en-US",
    ReplyRate = 0.96,
    ReplyPitch = 0.9,
    ReplyVolume = 1.0,
    ConsoleDebug = true,
    Debug = true
}

Config.Evidence = {
    CasingLifeTime = 30, -- Minutes before casings disappear from floor
    EvidenceItem = "evidence_bag", -- Item needed to pick up evidence
    MaxCasings = 50, -- Max casings tracked per area
    RequireTorch = true, -- If true, evidence markers/text only show when using a torch
    TorchItem = "weapon_flashlight", -- The weapon/item required to see evidence
    IgnoredShotWeapons = {
        "WEAPON_UNARMED",
        "WEAPON_STUNGUN",
        "WEAPON_FLAREGUN",
    },
}

Config.ArmoryWeapons = {
    { name = "weapon_pistol", label = "Pistol", icon = "pistol.png", category = "Sidearms", grade = 0 },
    { name = "weapon_combatpistol", label = "Combat Pistol", icon = "combat_pistol.png", category = "Sidearms", grade = 1 },
    { name = "weapon_stungun", label = "Taser", icon = "taser.png", category = "Sidearms", grade = 0 },
    { name = "weapon_nightstick", label = "Nightstick", icon = "nightstick.png", category = "Melee", grade = 0 },
    { name = "weapon_flashlight", label = "Flashlight", icon = "flashlight.png", category = "Melee", grade = 0 },
    { name = "weapon_pumpshotgun", label = "Pump Shotgun", icon = "shotgun.png", category = "Shotguns", grade = 2 },
    { name = "weapon_carbinerifle", label = "Carbine Rifle", icon = "carbine.png", category = "Rifles", grade = 3 },
    { name = "weapon_smg", label = "SMG", icon = "smg.png", category = "SMGs", grade = 2 },
}

Config.ArmoryItems = {
    { name = "radio", label = "Radio", icon = "radio.png", category = "Equipment", grade = 0 },
    { name = "handcuffs", label = "Handcuffs", icon = "handcuffs.png", category = "Equipment", grade = 0 },
    { name = "breathalyzer", label = "Breathalyzer", icon = "breathalyzer.png", category = "Equipment", grade = 0 },
    { name = "megaphone", label = "Megaphone", icon = "megaphone.png", category = "Equipment", grade = 0 },
    { name = "evidence_bag", label = "Evidence Bag", icon = "evidence_bag.png", category = "Equipment", grade = 0 },
    { name = "heavyarmor", label = "Heavy Armor", icon = "armor.png", category = "Protection", grade = 1 },
}

Config.AlcoholicItems = {
    ["beer"] = { strength = 0.02, decay = 0.001 },
    ["wine"] = { strength = 0.03, decay = 0.001 },
    ["whiskey"] = { strength = 0.05, decay = 0.001 },
    ["vodka"] = { strength = 0.06, decay = 0.001 },
}

Config.Inventory = "ox" -- Options: "qb", "ox", "qs", "codem", "core", "tgiann"
-- You can add more inventories in shared/inventory.lua

Config.SpeedUnit = "kmh" -- Options: "kmh", "mph"

Config.RadioCodes = {
    { label = "CODE-4", code = "CODE-4" },
    { label = "CODE-5", code = "CODE-5" },
    { label = "CODE-6", code = "CODE-6" },
    { label = "10-4", code = "10-4" },
    { label = "10-6", code = "10-6" },
    { label = "10-7", code = "10-7" },
    { label = "10-8", code = "10-8" },
    { label = "10-9", code = "10-9" },
    { label = "10-10", code = "10-10" },
    { label = "10-20", code = "10-20" },
    { label = "CODE-99", code = "CODE-99" },
}

Config.OfficerCommands = {
    search = "searchperson",
    cuff = "cuff",
    escort = "escort",
    putinvehicle = "putinvehicle",
    outofvehicle = "outofvehicle",
    plate = "plate",
    seize = "seize",
    alpr = "alpr",
    alprsize = "alprsize"
}

Config.OfficerMenuTabs = {
    interaction = true, -- Interaction actions
    radio = true,       -- Status/radio code panel
    frequency = true,   -- Frequency management panel
    objects = true,     -- Object placement panel
    vehicles = true,    -- Vehicle tools + ALPR panel
    monitoring = true,  -- Ankle monitor management
    poses = true        -- Pose/animation panel
}

Config.OfficerFrequencyRadio = {
    Enabled = true,
    Debug = true,
    PmaDebugMode = 4,
    TargetId = 29, -- Dedicated Mumble voice target used only by plt_departments F6 frequency radio. FiveM allows 1-30.
    Channels = {
        {
            title = "COMMAND NET",
            frequencies = {
                { id = 1, label = "SUPERVISORS" },
                { id = 2, label = "DISPATCH" }
            }
        },
        {
            title = "ADAM UNITS",
            frequencies = {
                { id = 3, label = "ADAM 01" },
                { id = 4, label = "ADAM 02" },
                { id = 5, label = "ADAM 03" },
                { id = 6, label = "ADAM 04" },
                { id = 7, label = "ADAM 05" },
                { id = 8, label = "ADAM 06" },
                { id = 9, label = "ADAM 07" },
                { id = 10, label = "ADAM 08" },
                { id = 11, label = "ADAM 09" }
            }
        },
        {
            title = "LINCOLN UNITS",
            frequencies = {
                { id = 12, label = "LINCOLN 01" },
                { id = 13, label = "LINCOLN 02" },
                { id = 14, label = "LINCOLN 03" },
                { id = 15, label = "LINCOLN 04" },
                { id = 16, label = "LINCOLN 05" },
                { id = 17, label = "LINCOLN 06" },
                { id = 18, label = "LINCOLN 07" },
                { id = 19, label = "LINCOLN 08" },
                { id = 20, label = "LINCOLN 09" }
            }
        },
        {
            title = "X-RAY UNITS",
            frequencies = {
                { id = 21, label = "X-RAY 01" },
                { id = 22, label = "X-RAY 02" },
                { id = 23, label = "X-RAY 03" },
                { id = 24, label = "X-RAY 04" },
                { id = 25, label = "X-RAY 05" },
                { id = 26, label = "X-RAY 06" },
                { id = 27, label = "X-RAY 07" },
                { id = 28, label = "X-RAY 08" },
                { id = 29, label = "X-RAY 09" }
            }
        }
    },
    PTTKey = "LMENU",
    PTTControls = { 19 }, -- INPUT_CHARACTER_WHEEL / Left Alt. Used as a direct fallback if key mapping is occupied.
    PollControlFallback = false, -- Keep idle resmon low. Enable only if FiveM key mapping does not fire on your setup.
    VolumeOverride = 0.65,
    RadioEffect = true,
    SpeakerEnabled = true,
    SpeakerRange = 8.0,
    SpeakerVolumeOverride = 0.75,
    SpeakerSelfMonitorVolume = 0.38,
    SpeakerNoiseVolume = 0.035,
    SpeakerSquelchVolume = 0.12,
    DebugNotify = false,
    BlockPmaRadioWhileConnected = false -- Keep PLT frequency independent; do not toggle pma's built-in radio cleanup.
}

Config.Jail = {
    Enabled = true,
    MaxMinutes = 60, -- 1 hour max
    MinMinutes = 0,
    MaxDistance = 2.0, -- Officer must be this close to target

    -- Where player is teleported when jailed
    JailLocation = { x = 1680.16, y = 2513.45, z = 45.56, h = 270.0 },

    -- Release behavior when timer is over
    ReturnToInitialPosition = true, -- If true, sends player back where they were arrested
    ReleaseLocation = { x = 425.1, y = -979.5, z = 30.7, h = 90.0 } -- Used when ReturnToInitialPosition = false
}

Config.AnkleMonitor = {
    Enabled = true,
    ItemName = "ankle_monitor",
    RequireItem = false,
    AttachDistance = 3.0,
    PingInterval = 5000,
    SignalLostSeconds = 75,
    ZoneWarningDistance = 35.0,
    ZoneAlertCooldownSeconds = 120,
    DefaultDurationHours = 72,
    MaxDurationHours = 720,
    AllowOffDuty = true,
    DispatchAlerts = true,
    Voice = {
        Enabled = true,
        TargetId = 30,
        NearbyListenRadius = 18.0,
        NearbyRefreshMs = 3000
    },
    Clothing = {
        component = 7, -- teef / accessories
        texture = 0,
        palette = 0,
        maleDrawable = 11,   -- mp_m_freemode_01^teef_011_u
        femaleDrawable = 8   -- mp_f_freemode_01^teef_008_u
    },
    Battery = {
        Enabled = true,
        DrainPerHour = 1.25,
        LowThreshold = 20
    },
    Map = {
        Image = "img/map.png",
        Bounds = {
            minX = -4000.0,
            maxX = 4500.0,
            minY = -4200.0,
            maxY = 8000.0
        }
    }
}

-- 3rd-eye action toggles (ox_target / qb-target)
Config.TargetActions = {
    player = {
        search = true,
        cuff = true,
        escort = true,
        put_in_vehicle = true,
        out_of_vehicle = true,
        fine = true,
        jail = true,
        ankle_monitor = true
    },
    vehicle = {
        check_plate = true,
        unlock = true,
        seize = true,
        wheel_clamp = true
    }
}

Config.DefaultDeptBalance = 250000

Config.Handcuffs = {
    RequireItem = false, -- If true, officers must have the 'handcuffs' item to cuff/uncuff
    ItemName = "handcuffs",
    RequireKey = false,  -- If true, officers must also have the 'handcuff_key' item to UNCUFF
    KeyItemName = "handcuff_key",
    Prop = {
        Enabled = true,
        Model = "p_cs_cuffs_02_s",
        OfficerDuration = 1500,
        Officer = { bone = 57005, x = 0.11, y = 0.035, z = -0.01, rx = 90.0, ry = 10.0, rz = 85.0 },
        Front = { bone = 57005, x = -0.0250, y = 0.0200, z = -0.0850, rx = 155.50, ry = -85.00, rz = -8.50 },
        Back = { bone = 57005, x = -0.0050, y = -0.0200, z = -0.0550, rx = 170.50, ry = -91.00, rz = 178.00 }
    }
}

Config.ESXAddonAccount = {
    enabled = true, -- Sync department balances to ESX addon_account_data when using ESX
    table = "addon_account_data",
    prefix = "society_" -- Account name format: society_<frameworkJob>
}

Config.OkOkBanking = {
    enabled = false, -- Sync department balances to okokBanking (okokbanking_societies table)
    prefix = "society_" -- Account name format: society_<frameworkJob>
}

Config.RenewedBanking = {
    enabled = false, -- Sync department balances to Renewed-Banking accounts
    prefix = "" -- Account name format: <prefix><frameworkJob> (usually no prefix)
}

Config.BossMenuTheme = "modern" -- "modern" or "vintage"

-- Fake Players for ESX (Display only)
Config.ShowFakePlayers = true
Config.FakePlayers = {
    { cid = "FAKE_1", name = "John Doe", jobLabel = "LSPD", jobGradeLabel = "Captain", jobName = "lspd", jobGradeLevel = 4, isOnline = true },
    { cid = "FAKE_2", name = "Jane Smith", jobLabel = "BCSO", jobGradeLabel = "Lieutenant", jobName = "bcso", jobGradeLevel = 3, isOnline = false },
    { cid = "FAKE_3", name = "Michael Scott", jobLabel = "LSPD", jobGradeLabel = "Sergeant", jobName = "lspd", jobGradeLevel = 2, isOnline = true },
    { cid = "FAKE_4", name = "Dwight Schrute", jobLabel = "BCSO", jobGradeLabel = "Officer", jobName = "bcso", jobGradeLevel = 1, isOnline = false },
    { cid = "FAKE_5", name = "Jim Halpert", jobLabel = "LSPD", jobGradeLabel = "Officer", jobName = "lspd", jobGradeLevel = 1, isOnline = true },
    { cid = "FAKE_6", name = "Pam Beesly", jobLabel = "BCSO", jobGradeLabel = "Officer", jobName = "bcso", jobGradeLevel = 1, isOnline = false },
    { cid = "FAKE_7", name = "Oscar Martinez", jobLabel = "LSPD", jobGradeLabel = "Cadet", jobName = "lspd", jobGradeLevel = 0, isOnline = true },
    { cid = "FAKE_8", name = "Angela Martin", jobLabel = "BCSO", jobGradeLabel = "Cadet", jobName = "bcso", jobGradeLevel = 0, isOnline = false },
}

Config.Animations = {
    ["shieldaim"] = {
        dict = "shieldaim@cartoon",
        anim = "shieldaim_clip",
        label = "Shield Aim",
        prop = "prop_ballistic_shield",
        bone = 36029,
        placement = {0.027805600627403, -0.03255339951872, -0.060990139100079, 90.982160207201, -21.248165304219, 156.23947846669},
        flag = 49
    },
    ["binocularsvehiclect"] = {
        dict = "binocularsvehicle@cartoon",
        anim = "binocularsvehicle_clip",
        label = "Binoculars Vehicle",
        prop = "prop_binoc_01",
        bone = 6286,
        placement = {0.11880772274878, 0.044755202937534, -0.030747995481285, 10.712522278647, 0.64370422614106, -0.65416974457932},
        flag = 49
    },
    ["carrybag"] = {
        dict = "carrybag@cartoon",
        anim = "carrybag_clip",
        label = "Carry Bag",
        prop = "prop_michael_backpack",
        bone = 6286,
        placement = {0.23478111022837, -0.062836073036813, 0.05806906884708, 0.0, -85.490671204531, -108.86722308239},
        flag = 49
    },
    ["binoculars"] = {
        dict = "binoculars@cartoon",
        anim = "binoculars_clip",
        label = "Binoculars",
        prop = "prop_binoc_01",
        bone = 6286,
        placement = {0.11880772274878, 0.044755202937534, -0.030747995481285, 10.712522278647, 0.64370422614106, -0.65416974457932},
        flag = 49
    },
    ["cb"] = {
        dict = "cb@cartoon",
        anim = "cb_clip",
        label = "Clipboard A2",
        prop = "prop_pencil_01",
        bone = 6286,
        placement = {0.082928788343793, 0.050464208571481, 0.0020748404558257, -141.74078727319, -53.322357680409, -32.311792760138},
        secondProp = "p_cs_clipboard",
        secondPropBone = 36029,
        secondPropPlacement = {0.13524608440798, 0.0085414392542884, 0.03848810645006, -102.9315136172, -9.6983151103175, -0.69277493769757},
        flag = 49
    },
    ["lidar"] = {
        dict = "lidar@cartoon",
        anim = "lidar_clip",
        label = "LIDAR",
        prop = "w_pi_prolaser4",
        bone = 36029,
        placement = {0.062651141213223, 0.0021050199691081, -0.018159487266964, -74.522617160545, 46.233061926035, -49.36915210942},
        flag = 1
    },
    ["leocamera"] = {
        dict = "leocamera@cartoon",
        anim = "leocamera_clip",
        label = "LEO Camera",
        prop = "prop_pap_camera_01",
        bone = 36029,
        placement = {0.13285316052281, 0.0, 0.069871774864649, 33.227620230838, -6.1944443550355, -175.88357401961},
        flag = 49
    },
    ["paperwr"] = {
        dict = "paperwr@cartoon",
        anim = "paperwr_clip",
        label = "paperwr",
        prop = "prop_pencil_01",
        bone = 6286,
        placement = {0.060599656206591, 0.046732695888124, -0.0063937846508236, -26.607334872995, 15.587682866106, -103.26106259071},
        secondProp = "prop_amanda_note_01",
        secondPropBone = 36029,
        secondPropPlacement = {0.090581818952046, -0.021753491438448, 0.024546692684615, -14.695840764735, -23.31810343791, -26.166845974374},
        flag = 49
    },
    ["coffeebelt"] = {
        dict = "coffeebelt@cartoon",
        anim = "coffeebelt_clip",
        label = "Belt Coffee",
        prop = "p_ing_coffeecup_01",
        bone = 6286,
        placement = {0.068731374555, 0.03139214340836, -0.023351558352198, -75.318575192433, -44.33497282459, -12.336044694332},
        flag = 49
    },
    ["onehandshield"] = {
        dict = "onehandshield@cartoon",
        anim = "onehandshield_clip",
        label = "One Hand Shield",
        prop = "prop_ballistic_shield",
        bone = 36029,
        placement = {0.019623858871796, -0.025687859612967, -0.054956156874566, 126.81588071928, -45.954690237389, 95.11293093132},
        flag = 49
    },
    ["duinotepad"] = {
        dict = "duinotepad@cartoon",
        anim = "duinotepad_clip",
        label = "DUI Notepad",
        prop = "prop_notepad_02",
        bone = 36029,
        placement = {0.07304768553945, 0.023114004912767, 0.027331673261111, -14.658680041603, -20.876521690057, 7.0228241658896},
        flag = 49
    },
    ["duiclipboard"] = {
        dict = "duiclipboard@cartoon",
        anim = "duiclipboard_clip",
        label = "DUI Clipboard",
        prop = "p_amb_clipboard_01",
        bone = 36029,
        placement = {0.13993051195837, 0.0, 0.04676158289303, -110.49532870263, -11.090240893683, 4.0392707320484},
        flag = 49
    },
    ["notepadradio"] = {
        dict = "notepadradio@cartoon",
        anim = "notepadradio_clip",
        label = "Notepad Radio",
        prop = "prop_notepad_01",
        bone = 6286,
        placement = {0.098910831737612, 0.033324336140049, -0.016786314964707, 168.36498169008, 2.9810680288095, -179.95204094406},
        secondProp = "prop_cs_hand_radio",
        secondPropBone = 36029,
        secondPropPlacement = {0.094187177673234, 0.043123484030153, 0.015793690996083, -119.28410788475, -21.670778059502, -38.557657668088},
        flag = 49
    },
    ["holddocs"] = {
        dict = "holddocs@cartoon",
        anim = "holddocs_clip",
        label = "Hold Documents",
        prop = "prop_cs_documents_01",
        bone = 36029,
        placement = {0.005071469297377, 0.072759381748999, 0.015371456632382, -2.1161039832604, 0.82599121143218, -25.02156640569},
        flag = 49
    },
    ["gundowntaser"] = {
        dict = "gundowntaser@cartoon",
        anim = "gundowntaser_clip",
        label = "Gun Down Taser",
        prop = "w_pi_taser7green",
        bone = 36029,
        placement = {0.067057589686442, 0.038482745768633, 0.018129898457137, -112.9863938932, -8.5258401847759, 2.6502677532856},
        flag = 49
    },
    ["beltcnb"] = { dict = "beltcnb@cartoon", anim = "beltcnb_clip", label = "Beltcnb", flag = 49 },
    ["beltgncs"] = { dict = "beltgncs@cartoon", anim = "beltgncs_clip", label = "Beltgncs", flag = 49 },
    ["belthnr"] = { dict = "belthnr@cartoon", anim = "belthnr_clip", label = "Belthnr", flag = 49 },
    ["beltidle3"] = { dict = "beltidle3@cartoon", anim = "beltidle3_clip", label = "Belt Idle 3", flag = 49 },
    ["beltjsm"] = { dict = "beltjsm@cartoon", anim = "beltjsm_clip", label = "Beltjsm", flag = 49 },
    ["beltohb"] = { dict = "beltohb@cartoon", anim = "beltohb_clip", label = "beltohb", flag = 49 },
    ["checkdoor"] = { dict = "checkdoor@cartoon", anim = "checkdoor_clip", label = "Check Door", flag = 49 },
    ["fence"] = { dict = "fence@cartoon", anim = "fence_clip", label = "Fence", flag = 1 },
    ["gundownpartner"] = { dict = "gundownpartner@cartoon", anim = "gundownpartner_clip", label = "Gun Down Partner", flag = 49 },
    ["gunuppartner"] = { dict = "gunuppartner@cartoon", anim = "gunuppartner_clip", label = "Gun Up Partner", flag = 49 },
    ["leanpoint"] = { dict = "leanpoint@cartoon", anim = "leanpoint_clip", label = "Lean Point", flag = 49 },
    ["radioidle"] = { dict = "radioidle@cartoon", anim = "radioidle_clip", label = "Radio Idle", flag = 49 },
    ["vehiclelow"] = { dict = "vehiclelow@cartoon", anim = "vehiclelow_clip", label = "Vehicle Low", flag = 49 },
    ["vehiclemed"] = { dict = "vehiclemed@cartoon", anim = "vehiclemed_clip", label = "Vehicle Med", flag = 49 },
    ["vehiclehigh"] = { dict = "vehiclehigh@cartoon", anim = "vehiclehigh_clip", label = "Vehicle High", flag = 49 },
    ["holdgunmid"] = { dict = "holdgunmid@cartoon", anim = "holdgunmid_clip", label = "Hold Gun Mid", flag = 49 },
}

Config.AnimPoses = {
    ["cartoonkneelsur"] = {
        dict = "cartoonkneelsur@animation",
        anim = "cartoonkneelsur_clip",
        label = "Surrender Kneel",
        flag = 1
    },
    ["cartoonlaysur3"] = {
        dict = "cartoonlaysur3@animation",
        anim = "cartoonlaysur3_clip",
        label = "Lay Ground Surrender",
        flag = 1
    },
    ["cartoonsidewalk"] = {
        dict = "cartoonsidewalk@animation",
        anim = "cartoonsidewalk_clip",
        label = "Sidewalk Surrender",
        flag = 1
    },
    ["cartoonsitsurrender"] = {
        dict = "cartoonsitsurrender@animation",
        anim = "cartoonsitsurrender_clip",
        label = "Sit Surrender",
        flag = 1
    },
    ["wall3"] = {
        dict = "wall3@animation",
        anim = "wall3_clip",
        label = "wall3",
        flag = 1
    },
    ["cartoonlaysur2"] = {
        dict = "cartoonlaysur2@animation",
        anim = "cartoonlaysur2_clip",
        label = "Lay Ground Hands Surrender",
        flag = 1
    },
    ["sitcuffed"] = {
        dict = "sitcuffed@cartoon",
        anim = "sitcuffed_clip",
        label = "sitcuffed",
        flag = 1
    },
    ["handsoutdriver"] = {
        dict = "handsoutdriver@cartoon",
        anim = "handsoutdriver_clip",
        label = "Driver Hands Out",
        flag = 16
    },
    ["handsoutpassanger"] = {
        dict = "handsoutpassanger@cartoon",
        anim = "handsoutpassanger_clip",
        label = "Passanger Hands Out",
        flag = 16
    },
}

-- ==========================================================================================
-- LOCALIZATION SYSTEM
-- ==========================================================================================
Config.Locale = "en" -- Set your language code here

Config.Translations = {
    ['en'] = {
        -- Notifications
        ["notification_title"] = "NOTIFICATION",
        ["attention_title"] = "ATTENTION",
        ["success_title"] = "SUCCESS",
        ["info_title"] = "INFORMATION",
        ["need_handcuffs"] = "You need handcuffs to do this!",
        ["need_handcuff_key"] = "You need a handcuff key to unlock these!",
        ["dept_debug_markers"] = "Department Debug Markers: {state}",
        ["door_locked"] = "Door Locked",
        ["door_unlocked"] = "Door Unlocked",
        ["lock_door"] = "[E] LOCK DOOR",
        ["unlock_door"] = "[E] UNLOCK DOOR",
        ["select_this_door"] = "[E] SELECT THIS DOOR",
        ["no_impounded_vehicles"] = "No vehicles currently in impound!",
        ["no_aircraft_configured"] = "No aircraft configured!",
        ["no_vehicles_configured"] = "No vehicles configured!",
        ["vehicle_stored"] = "Vehicle stored!",
        ["must_be_in_vehicle"] = "You must be in a vehicle!",
        ["no_boss_perms"] = "No boss permissions!",
        ["no_outfits_rank"] = "No outfits configured for your rank!",
        ["uniform_applied"] = "Uniform applied!",
        ["civilian_clothes_restored"] = "Civilian clothes restored.",
        ["not_part_of_dept"] = "You are not part of any department!",
        ["failed_fetch_data"] = "Failed to fetch data from server!",
        ["no_permission_manage"] = "You do not have permission to manage departments!",
        ["no_spawn_points"] = "No spawn points configured!",
        ["all_spawn_points_blocked"] = "All spawn points are blocked!",
        ["vehicle_unimpounded"] = "Vehicle unimpounded!",
        ["vehicle_spawned"] = "Vehicle spawned!",
        ["joined_freq"] = "Joined frequency: {freq}",
        ["disconnected_freq"] = "Disconnected from frequency",
        ["moved_to_freq"] = "You have been moved to frequency: {freq}",
        ["already_have_dog"] = "You already have a police dog!",
        ["dog_deployed"] = "Police dog deployed!",
        ["dog_returned"] = "Police dog returned.",
        ["no_dog"] = "You don't have a police dog!",
        ["object_placed"] = "Object placed!",
        ["too_far_away"] = "Too far away!",
        ["placement_cancelled"] = "Placement cancelled.",
        ["connecting_dmv"] = "Connecting to DMV...",
        ["vehicle_registration"] = "VEHICLE REGISTRATION",
        ["plate_check_failed"] = "PLATE CHECK FAILED",
        ["no_one_nearby"] = "No one nearby!",
        ["must_be_handcuffed"] = "Player must be handcuffed!",
        ["handcuff_unhandcuff"] = "Toggle Handcuffs",
        ["cannot_while_cuffed"] = "You cannot do this while handcuffed!",
        ["no_free_seats"] = "No free seats!",
        ["no_vehicle_nearby"] = "No vehicle nearby!",
        ["status_updated"] = "Status updated: {status}",
        ["no_command_permission"] = "You do not have permission to use this command!",
        ["you_were_uncuffed"] = "You have been uncuffed.",
        ["being_handcuffed"] = "You are being handcuffed...",
        ["forced_animation"] = "You were forced into an animation!",
        ["object_removed"] = "Object removed.",
        ["no_objects_nearby"] = "No objects nearby!",
        ["all_objects_cleared"] = "All objects cleared!",
        ["alpr_vehicle_required"] = "You must be in a vehicle to use ALPR!",
        ["alpr_speed_set"] = "ALPR Speed Limit set to {speed} {unit}",
        ["alpr_size_set"] = "ALPR Size set to {size}",
        ["alpr_must_be_active"] = "ALPR must be active to resize it!",
        ["alpr_size_msg"] = "ALPR Size: {size}",
        ["no_evidence_system"] = "Your department does not have an evidence analysis system configured.",
        ["report_unreadable"] = "This report is unreadable or empty.",
        ["no_evidence_node"] = "You cannot collect evidence without a department evidence node.",
        ["need_evidence_bag"] = "You need an evidence bag to collect this.",
        ["evidence_collected"] = "Evidence collected and bagged ({item})",
        ["failed_collect_evidence"] = "Failed to collect evidence! Inventory might be full.",
        ["no_print_report_node"] = "You cannot print reports without an evidence node.",
        ["forensic_report_printed"] = "Forensic report printed.",
        ["failed_print_report"] = "Failed to print report. Check inventory space!",
        -- Forensic PC / Evidence Analyzer UI
        ["evidence_no_samples"] = "No evidence samples found in inventory.",
        ["evidence_ready"] = "READY",
        ["evidence_none_detected"] = "NONE DETECTED",
        ["evidence_system_ready"] = "System ready...",
        ["evidence_error"] = "ERROR",
        ["evidence_no_sample_selected"] = "No sample selected.",
        ["evidence_scanning"] = "SCANNING...",
        ["evidence_analyzing_patterns"] = "Analyzing microscopic rifling patterns...",
        ["evidence_complete"] = "COMPLETE",
        ["evidence_bullet_casing"] = "BULLET CASING",
        ["evidence_matching_verified"] = "Matching successful. Pattern verified.",
        ["camera_placed"] = "Camera '{name}' placed successfully.",
        ["camera_removed"] = "Camera removed.",
        ["must_be_in_dept_armory"] = "You must be in a department to access the armory!",
        ["took_item"] = "You took a {label}",
        ["armory_limit_reached"] = "This item is currently out of stock in the armory!",
        ["could_not_give_item"] = "Could not give item! (Inventory full or invalid item)",
        ["auto_pay_updated"] = "Auto-Pay updated: {type}",
        ["vehicle_seized"] = "Vehicle seized: {plate}",
        ["paid_unimpound"] = "Paid ${amount} to unimpound vehicle.",
        ["not_enough_money_bank"] = "You don't have enough money in your bank!",
        ["warrant_issued"] = "Warrant issued successfully",
        ["warrant_updated"] = "Warrant updated successfully",
        ["warrant_completed"] = "Warrant marked as completed",
        ["no_permission"] = "No permission",
        ["warrant_deleted"] = "Warrant deleted",
        ["case_file_created"] = "Case file created successfully",
        ["case_file_updated"] = "Case file updated successfully",
        ["case_file_archived"] = "Case file archived",
        ["bolo_issued"] = "BOLO issued successfully",
        ["bolo_updated"] = "BOLO updated successfully",
        ["bolo_archived"] = "BOLO archived",
        ["article_posted"] = "Article posted successfully",
        ["article_deleted"] = "Article deleted",
        ["911_sent"] = "911 Call sent successfully!",
        ["911_no_description"] = "You must provide a description for your 911 call!",
        ["911_call_title"] = "911 Call",
        ["division_created"] = "Division '{name}' created!",
        ["division_removed"] = "Division removed!",
        ["division_removed_member"] = "Division removed from member",
        ["division_assigned_member"] = "Division assigned to member",
        ["report_submitted"] = "Report submitted successfully for {cid}",
        ["no_rank_structure"] = "No rank structure found for this department.",
        ["no_employees_salary"] = "No employees found with a configured salary.",
        ["not_enough_dept_funds"] = "Not enough department funds! Need ${amount}",
        ["cancel"] = "Cancel",
        ["display_name"] = "Display Name",
        ["framework_job_name"] = "Framework Job Name",
        ["framework_job_desc"] = "Leave empty to use Node ID. Must match your shared/jobs.lua",
        ["blip_name"] = "Blip Name",
        ["icon_select"] = "Icon Select",
        ["color_palette"] = "Color Palette",
        ["officer_blip_color"] = "Officer Blip Color",
        ["framework_job_desc"] = "Leave empty to use Node ID. Must match your shared/jobs.lua",
        ["location_vector3"] = "Location (Vector3)",
        ["dept_ranks"] = "Department Ranks",
        ["boss_menu_perms"] = "Boss Menu Permissions",
        ["boss_access"] = "Boss Access",
        ["rank_permissions"] = "Rank Permissions",
        ["wardrobe_location"] = "Wardrobe Location",
        ["rank_outfits"] = "Rank Outfits",
        ["add_new_outfit"] = "Add New Outfit",
        ["shirt"] = "Shirt",
        ["pants"] = "Pants",
        ["shoes"] = "Shoes",
        ["vest"] = "Vest",
        ["bags"] = "Bags",
        ["mask"] = "Mask",
        ["arms"] = "Arms",
        ["undershirt"] = "Undershirt",
        ["decals"] = "Decals",
        ["accessory"] = "Accessory",
        ["hair"] = "Hair",
        ["hat"] = "Hat",
        ["glasses"] = "Glasses",
        ["ears"] = "Ears",
        ["watch"] = "Watch",
        ["bracelet"] = "Bracelet",
        ["ped_type_node"] = "PED TYPE FOR THIS NODE",
        ["link_vehicle_warning"] = "LINK TO VEHICLE/HELIPAD/ARMORY NODE FOR MENU TO WORK",
        ["node_linked"] = "VEHICLE/HELIPAD/ARMORY NODE LINKED",
        ["link_rank_warning"] = "Link a Rank node to this node to manage permissions.",
        ["no_ranks_warning"] = "No ranks found in linked Rank node.",
        ["link_rank_wardrobe_warning"] = "Link a Rank node to this node to manage rank-specific outfits.",
        ["surveillance_cameras"] = "Surveillance Cameras",
        ["camera_label"] = "Camera Label",
        ["location"] = "Location",
        ["heading"] = "Heading",
        ["add_new_camera"] = "Add New Camera",
        ["analysis_pc_location"] = "Analysis PC Location",
        ["armory_location"] = "Armory Location",
        ["armory_weapons"] = "Armory Weapons",
        ["weapon_label"] = "Weapon Label",
        ["spawn_code"] = "Spawn Code / Model",
        ["min_grade"] = "Min. Grade",
        ["armory_limit"] = "Limit (0=Unlimited)",
        ["add_new_weapon"] = "Add New Weapon",
        ["armory_items"] = "Armory Items",
        ["item_label"] = "Item Label",
        ["add_new_item"] = "Add New Item",
        ["regular_spawn_locations"] = "Regular Spawn Locations",
        ["world_position"] = "World Position",
        ["add_spawn_point"] = "Add Spawn Point",
        ["impound_spawn_locations"] = "Impound Spawn Locations",
        ["add_impound_spawn"] = "Add Impound Spawn",
        ["store_locations"] = "Store Locations (Delete)",
        ["add_store_point"] = "Add Store Point",
        ["dept_vehicles"] = "Department Vehicles",
        ["dept_aircraft"] = "Department Aircraft",
        ["vehicle_label"] = "Vehicle Label",
        ["add_new_vehicle"] = "Add New Vehicle",
        ["configured_doors"] = "Configured Doors",
        ["door_label"] = "Door Label",
        ["add_new_door"] = "Add New Door",
        ["dog_bed_location"] = "Dog Bed Location (Prop)",
        ["dog_spawn_location"] = "Dog Spawn Location",
        ["camera_viewpoint"] = "Camera Location (Viewpoint)",
        ["camera_prop"] = "Camera Model / Prop (Optional)",
        ["boss_menu_location"] = "Boss Menu Location",
        ["form_computer_location"] = "Form Computer Location",
        ["k9_setup_info"] = "Set the dog bed prop location and where the K9 will spawn.",
        ["analysis_pc_location"] = "Analysis PC Location",
        ["armory_location"] = "Armory Location",
        ["wardrobe_location"] = "Wardrobe Location",
        ["regular_spawn_locations"] = "Regular Spawn Locations",
        ["impound_spawn_locations"] = "Impound Spawn Locations",
        ["store_locations"] = "Store Locations (Delete)",
        ["dept_vehicles"] = "Department Vehicles",
        ["dept_aircraft"] = "Department Aircraft",
        ["configured_doors"] = "Configured Doors",
        ["dog_bed_location"] = "Dog Bed Location (Prop)",
        ["dog_spawn_location"] = "Dog Spawn Location",
        ["camera_viewpoint"] = "Camera Location (Viewpoint)",
        ["camera_prop"] = "Camera Model / Prop (Optional)",
        ["surveillance_cameras"] = "Surveillance Cameras",
        ["add_new_rank"] = "ADD NEW RANK",
        ["add_new_outfit"] = "Add New Outfit",
        ["add_new_camera"] = "Add New Camera",
        ["add_new_weapon"] = "Add New Weapon",
        ["add_new_item"] = "Add New Item",
        ["add_spawn_point"] = "Add Spawn Point",
        ["add_impound_spawn"] = "Add Impound Spawn",
        ["add_store_point"] = "Add Store Point",
        ["add_new_vehicle"] = "Add New Vehicle",
        ["add_new_door"] = "Add New Door",
        ["rank_grade"] = "Rank / Grade",
        ["custom_dept"] = "Custom Department",
        ["desktop"] = "Desktop",
        ["file"] = "File",
        ["edit"] = "Edit",
        ["view"] = "View",
        ["window"] = "Window",
        ["help"] = "Help",
        ["bin"] = "Bin",
        ["system_status"] = "SYSTEM STATUS",
        ["online"] = "ONLINE",
        ["offline"] = "OFFLINE",

        -- Boss Menu Apps
        ["dept_roster"] = "Department Roster",
        ["personnel_records"] = "Personnel Records",
        ["dept_finances"] = "Department Finances",
        ["city_surveillance"] = "City Surveillance",
        ["calculator"] = "Calculator",
        ["clock"] = "Clock",
        ["settings"] = "Settings",
        ["netscape_navigator"] = "Netscape Navigator",

        -- Garage
        ["dept_garage"] = "DEPT GARAGE",
        ["search_fleet"] = "SEARCH FLEET...",
        ["units"] = "UNITS",

        -- Radar Setup
        ["place_radar_help"] = "[E] Place Radar | [Arrows] Rotate | [ESC] Cancel",

        -- Evidence / Citation
        ["citation_title"] = "CITY POLICE DEPARTMENT",
        ["citation_name"] = "NAME",
        ["citation_dl"] = "DL#",
        ["citation_date"] = "DATE",
        ["citation_location"] = "LOCATION",
        ["citation_time"] = "TIME",
        ["citation_plate"] = "PLATE",
        ["citation_model"] = "MODEL",
        ["citation_color"] = "COLOR",
        ["citation_reason"] = "REASON",
        ["citation_officer"] = "OFFICER",
        ["citation_amount"] = "AMOUNT",
        ["citation_signature"] = "SIGNATURE",

        -- Officer Menu Tabs
        ["tab_interaction"] = "Interaction",
        ["tab_radio"] = "Radio",
        ["tab_frequency"] = "Frequency",
        ["tab_objects"] = "Objects",
        ["tab_vehicles"] = "Vehicles",
        ["tab_monitoring"] = "Monitoring",
        ["tab_poses"] = "Poses",

        -- Officer Menu
        ["alpr_settings"] = "ALPR SETTINGS",
        ["toggle_dispatch"] = "TOGGLE DISPATCH",
        ["stop_all"] = "STOP ALL",
        ["waiting"] = "WAITING...",
        ["search_animations"] = "Search animations...",
        ["patrol_units"] = "PATROL UNITS",
        ["special_operations"] = "SPECIAL OPERATIONS",
        ["admin_channels"] = "ADMIN CHANNELS",
        ["connected"] = "Connected",
        ["freq_lspd_comisar_1"] = "LSPD COMISAR 1",
        ["freq_lspd_comisar_2"] = "LSPD COMISAR 2",
        ["freq_lspd_comisar_3"] = "LSPD COMISAR 3",
        ["freq_swat_tactical"] = "SWAT TACTICAL",
        ["freq_air_support"] = "AIR SUPPORT",
        ["freq_k9_unit"] = "K9 UNIT",
        ["freq_command_staff"] = "COMMAND STAFF",
        ["freq_training_channel"] = "TRAINING CHANNEL",
        ["hex_search"] = "Search",
        ["hex_handcuff"] = "Handcuff",
        ["hex_escort"] = "Escort",
        ["hex_put_in_car"] = "Put in Car",
        ["hex_out_of_car"] = "Out of Car",
        ["hex_fine"] = "Fine",
        ["hex_jail"] = "Jail",
        ["hex_plate"] = "Plate",
        ["hex_unlock"] = "Unlock",
        ["hex_seize"] = "Seize",
        ["hex_wheel_clamp"] = "Clamp",
        ["hex_alpr_system"] = "ALPR System",
        ["hex_toggle"] = "Toggle",
        ["hex_set_speed"] = "Set Speed",
        ["hex_move_resize"] = "Move / Resize",
        ["hex_back"] = "Back",
        ["hex_cone"] = "Cone",
        ["hex_barrier"] = "Barrier",
        ["hex_spikes"] = "Spikes",
        ["hex_light"] = "Light",
        ["hex_remove"] = "Remove",
        ["hex_clear_all"] = "Clear All",
        ["hex_monitor_center"] = "Monitor Center",
        ["hex_monitor_apply"] = "Apply Monitor",
        ["hex_monitor_remove"] = "Remove Monitor",

        -- Node Labels (Used in Editor)
        ["node_department"] = "Department Node",
        ["node_rank"] = "Rank Node",
        ["node_permission"] = "Permission Node",
        ["node_location"] = "Location Node",
        ["node_wardrobe"] = "Wardrobe Node",
        ["node_boss_menu"] = "Boss Menu",
        ["node_vehicle"] = "Vehicle Node",
        ["node_helipad"] = "Helipad Node",
        ["node_armory"] = "Armory Node",
        ["node_k9"] = "K9 Unit",
        ["node_camera"] = "Camera Node",
        ["node_evidence"] = "Evidence Node",
        ["node_form_computer"] = "Form Computer",
        ["node_mdt_dispatch"] = "MDT Dispatch",
        ["mdt_dispatch_location"] = "MDT Dispatch Location",
        ["node_ai_police_npc"] = "AI Police NPC",
        ["ai_police_npc"] = "AI Police NPC",
        ["ai_police_npc_location"] = "AI Police NPC Location",
        ["ai_police_npc_greeting"] = "NPC Greeting",
        ["ai_police_npc_knowledge"] = "NPC Knowledge",
        ["talk_ai_police_npc"] = "Talk to Police Assistant",
        ["words"] = "words",
        ["node_door"] = "Door Node",
        
        -- Editor Inputs
        ["display_name"] = "Display Name",
        ["framework_job_name"] = "Framework Job Name",
        ["blip_name"] = "Blip Name",
        ["icon_select"] = "ICON SELECT",
        ["color_palette"] = "COLOR PALETTE",
        ["location_vector3"] = "Location (Vector3)",
        ["dept_ranks"] = "Department Ranks",
        ["boss_menu_perms"] = "BOSS MENU PERMISSIONS",
        ["boss_access"] = "BOSS ACCESS",
        ["rank_perms"] = "RANK PERMISSIONS",
        ["wardrobe_loc"] = "WARDROBE LOCATION",
        ["rank_outfits"] = "RANK OUTFITS",
        ["camera_label"] = "CAMERA LABEL",
        ["ranks_configured"] = "RANKS CONFIGURED",
        ["perms_configured"] = "PERMISSIONS CONFIGURED",
        ["location_set"] = "LOCATION SET",
        ["no_location"] = "NO LOCATION",
        ["locations_set"] = "LOCATIONS SET",
        ["outfits"] = "OUTFITS",
        ["points"] = "POINTS",
        ["aircraft"] = "AIRCRAFT",
        ["vehicles"] = "VEHICLES",
        ["weapons"] = "WEAPONS",
        ["doors_configured"] = "DOORS CONFIGURED",
        ["cameras_configured"] = "CAMERAS CONFIGURED",
        ["boss_menu"] = "BOSS MENU",
        ["form_computer"] = "FORM COMPUTER",
        ["mdt_dispatch"] = "MDT DISPATCH",
        ["department"] = "DEPARTMENT",
        ["rank"] = "RANK",
        ["permission"] = "PERMISSION",
        ["location"] = "LOCATION",
        ["wardrobe"] = "WARDROBE",
        ["vehicle"] = "VEHICLE",
        ["helipad"] = "HELIPAD",
        ["armory"] = "ARMORY",
        ["door"] = "DOOR",
        ["camera"] = "CAMERA",
        ["evidence"] = "EVIDENCE",
        -- Boss Menu Actions
        ["promote"] = "Promote",
        ["demote"] = "Demote",
        ["honor"] = "Honor",
        ["fire"] = "Fire",
        ["divisions"] = "Divisions",
        ["no_honors"] = "No Honors Awarded",
        ["active_personnel"] = "ACTIVE PERSONNEL",
        ["roster"] = "ROSTER",
        ["recruitment"] = "RECRUITMENT",
        ["no_personnel"] = "No personnel found.",
        ["app_records"] = "Records",
        ["app_departments"] = "Departments",
        ["app_finances"] = "Finances",
        ["app_safari"] = "Safari",
        ["app_calculator"] = "Calculator",
        ["app_clock"] = "Clock",
        ["app_settings"] = "Settings",
        ["app_cameras"] = "Cameras",
        ["honored"] = "Honored",
        ["close_form"] = "Close Form",
        ["create_warrant"] = "Create Warrant",
        ["new_warrant"] = "New Warrant",
        ["new_case_file"] = "New Case File",
        ["create_case_file"] = "Create Case File",
        ["edit_case_file"] = "Edit Case File",
        ["edit_warrant"] = "Edit Warrant",
        ["new_bolo"] = "New BOLO",
        ["create_bolo"] = "Create BOLO",
        ["edit_bolo"] = "Edit BOLO",
        ["new_article"] = "New Article",
        ["post_alert"] = "Post Alert",
        ["update_alert"] = "Update Alert",
        ["close_alert"] = "Close Alert",
        ["close_record"] = "Close Record",
        ["close_file"] = "Close File",
        ["submit_to_db"] = "Submit to Database",
        ["save_case_file"] = "Save Case File",
        ["update_case_file"] = "Update Case File",
        ["update_warrant"] = "Update Warrant",
        ["manage_honors"] = "Manage Honors",
        ["manage_divisions"] = "Manage Divisions",
        ["personnel"] = "Personnel",
        ["active_honors"] = "Active Honors",
        ["award_new_medal"] = "Award New Medal",
        ["no_divisions_available"] = "No divisions available",
        ["done"] = "Done",
        ["no_dept_job"] = "No department job detected. Please ensure you are logged in.",
        ["finances_error"] = "Error loading financial data. Please try again.",
        ["dept_budget"] = "Department Budget",
        ["rank_salaries"] = "Rank Salaries",
        ["overview"] = "Overview",
        ["salary"] = "Salary",
        ["pay_once"] = "Pay Once",
        ["hourly"] = "Hourly",
        ["daily"] = "Daily",
        ["cancel"] = "Cancel",
        ["personnel_records"] = "Personnel Records",
        ["total_personnel"] = "TOTAL PERSONNEL",
        ["division_management"] = "DIVISION MANAGEMENT",
        ["database"] = "DATABASE",
        ["no_divisions"] = "No divisions",
        ["recruitment_portal"] = "RECRUITMENT PORTAL",
        ["hiring_placeholder"] = "Enter Citizen ID...",
        ["detect"] = "Detect",
        ["hiring_enter_id"] = "Enter Citizen ID to search...",
        ["no_player_id"] = "No player detected with ID #{id}. Ensure they are online.",
        ["citizen_id"] = "Citizen ID",
        ["current_job"] = "Current Job",
        ["assign_rank"] = "Assign Rank",
        ["default_grade"] = "Default Grade",
        ["hire_personnel"] = "Hire Personnel",
        ["surveillance"] = "Surveillance",
        ["cameras_registered"] = "CAMERAS REGISTERED",
        ["no_cameras_configured"] = "No cameras configured.",
        ["use_dept_manager_cameras"] = "Use Dept Manager to add cameras.",
        ["setup"] = "Setup",
        ["net_balance"] = "Net Balance",
        ["expenses"] = "Expenses",
        ["avg_salary"] = "Avg Salary",
        ["deposit"] = "Deposit",
        ["withdraw"] = "Withdraw",
        ["balance_history"] = "Balance History",
        ["last_7_days"] = "Last 7 Days",
        ["total_staff"] = "Total Staff",
        ["settings_general"] = "General",
        ["settings_appearance"] = "Appearance",
        ["settings_display"] = "Display",
        ["settings_accessibility"] = "Accessibility",
        ["settings_wallpaper"] = "Wallpaper",
        ["tab_intranet"] = "Intranet",
        ["tab_trackers"] = "Trackers",
        ["tab_comms"] = "Comms",
        ["tab_fines"] = "Fines",
        ["tab_forms"] = "Forms",
        ["tab_radars"] = "Radars",
        ["tab_logs"] = "Logs",
        ["performance_reports"] = "Performance Reports",
        ["add_new_report"] = "Add New Report",
        ["submit_report"] = "Submit Report",
        ["history"] = "History",
        ["no_reports"] = "No reports",
        ["close"] = "Close",
        ["judicial_record"] = "Judicial Record",
        ["intelligence_file"] = "Intelligence File",
        -- Officer Menu Actions
        ["alpr_settings"] = "ALPR SETTINGS",
        ["toggle_dispatch"] = "TOGGLE DISPATCH",
        ["stop_all"] = "STOP ALL",
        ["waiting"] = "WAITING...",
        ["search_animations"] = "Search animations...",
        ["patrol_units"] = "PATROL UNITS",
        ["special_operations"] = "SPECIAL OPERATIONS",
        ["admin_channels"] = "ADMIN CHANNELS",
        ["connected"] = "Connected",
        -- Frequency Labels
        ["freq_lspd_comisar_1"] = "LSPD COMISAR 1",
        ["freq_lspd_comisar_2"] = "LSPD COMISAR 2",
        ["freq_lspd_comisar_3"] = "LSPD COMISAR 3",
        ["freq_swat_tactical"] = "SWAT TACTICAL",
        ["freq_air_support"] = "AIR SUPPORT",
        ["freq_k9_unit"] = "K9 UNIT",
        ["freq_command_staff"] = "COMMAND STAFF",
        ["freq_training_channel"] = "TRAINING CHANNEL",
        -- Hex Grid Labels
        ["hex_search"] = "SEARCH",
        ["hex_handcuff"] = "HANDCUFF",
        ["hex_escort"] = "ESCORT",
        ["hex_put_in_car"] = "IN VEHICLE",
        ["hex_out_of_car"] = "OUT VEHICLE",
        ["hex_fine"] = "FINE",
        ["hex_jail"] = "JAIL",
        ["hex_plate"] = "PLATE",
        ["hex_unlock"] = "UNLOCK",
        ["hex_seize"] = "SEIZE",
        ["hex_wheel_clamp"] = "CLAMP",
        ["hex_alpr_system"] = "ALPR SYSTEM",
        ["hex_toggle"] = "TOGGLE",
        ["hex_set_speed"] = "SET SPEED",
        ["hex_move_resize"] = "MOVE / RESIZE",
        ["hex_back"] = "BACK",
        ["hex_cone"] = "CONE",
        ["hex_barrier"] = "BARRIER",
        ["hex_spikes"] = "SPIKES",
        ["hex_light"] = "LIGHT",
        ["hex_remove"] = "REMOVE",
        ["hex_clear_all"] = "CLEAR ALL",
        ["hex_monitor_center"] = "MONITOR CENTER",
        ["hex_monitor_apply"] = "APPLY MONITOR",
        ["hex_monitor_remove"] = "REMOVE MONITOR",
        ["unknown"] = "UNKNOWN",
        ["scanning_dots"] = "SCANNING...",
        ["bolo_alert"] = "BOLO ALERT",
        ["monitoring"] = "MONITORING",
        -- Forensic PC / Evidence Analyzer UI
        ["evidence_no_samples"] = "No evidence samples found in inventory.",
        ["evidence_ready"] = "READY",
        ["evidence_none_detected"] = "NONE DETECTED",
        ["evidence_system_ready"] = "System ready...",
        ["evidence_error"] = "ERROR",
        ["evidence_no_sample_selected"] = "No sample selected.",
        ["evidence_scanning"] = "SCANNING...",
        ["evidence_analyzing_patterns"] = "Analyzing microscopic rifling patterns...",
        ["evidence_complete"] = "COMPLETE",
        ["evidence_bullet_casing"] = "BULLET CASING",
        ["evidence_matching_verified"] = "Matching successful. Pattern verified.",
        ["now"] = "NOW",
        ["gps"] = "GPS",
        ["dismiss"] = "DISMISS",
        ["station_clear"] = "STATION CLEAR",
        ["dept_armory_header"] = "DEPARTMENT ARMORY",
        ["take"] = "TAKE",
        ["ready_to_test"] = "READY TO TEST",
        ["subject_ready"] = "SUBJECT READY",
        ["blowing_dots"] = "BLOWING...",
        ["calculating_dots"] = "CALCULATING...",
        ["over_limit"] = "OVER LIMIT",
        ["legal_limit"] = "LEGAL LIMIT",
        ["failed"] = "FAILED",
        ["accepted"] = "ACCEPTED",
        ["invalid_swipe"] = "INVALID SWIPE",
        ["assign_keybind"] = "Assign Keybind",
        ["select_key_for"] = "Select a key (0-9) for {label}",
        ["clear_key"] = "CLEAR KEY",
        -- HTML / UI Elements
        ["dept_manager_title"] = "DEPARTMENT MANAGER",
        ["dept_library"] = "DEPT LIBRARY",
        ["dept_library_desc"] = "Manage and deploy pre-configured departments",
        ["search_here"] = "Search here...",
        ["departments_title"] = "DEPARTMENTS",
        ["ranks_perms_title"] = "Ranks & Perms",
        ["locations_title"] = "LOCATIONS",
        ["other_title"] = "OTHER",
        ["import"] = "Import",
        ["export"] = "Export",
        ["save_and_reload"] = "Save and reload",
        ["fine_agreement"] = "I hereby agree to pay the fine amount indicated above. Failure to pay within 48 hours will result in automatic deduction from your bank account and potential license suspension.",
        ["violator_signature"] = "VIOLATOR SIGNATURE",
        ["sign_and_pay"] = "SIGN & PAY",
        ["decline"] = "DECLINE",
        ["issue_citation"] = "ISSUE CITATION",
        ["reason"] = "REASON",
        ["amount"] = "AMOUNT",
        ["send"] = "SEND",
        ["object_placement"] = "OBJECT PLACEMENT",
        ["place"] = "PLACE",
        ["rotate"] = "ROTATE",
        ["pose_library"] = "POSE LIBRARY",
        ["search_dots"] = "SEARCH...",
        ["radar_setup"] = "RADAR SETUP",
        ["location_name"] = "LOCATION NAME",
        ["limit_kmh"] = "LIMIT ({unit})",
        ["activate"] = "ACTIVATE",
        ["front_monitoring"] = "FRONT MONITORING",
        ["pwr"] = "PWR",
        ["op"] = "OP",
        ["ant"] = "ANT",
        ["lock"] = "LOCK",
        ["scan"] = "SCAN",
        -- HTML Labels
        ["station clear"] = "STATION CLEAR",
        -- K9 Menu
        ["follow"] = "Follow",
        ["stay"] = "Stay",
        ["sit"] = "Sit",
        ["bark"] = "Bark",
        ["attack"] = "Attack",
        ["search car"] = "Search Car",
        ["in/out"] = "In/Out",
        ["sniff person"] = "Sniff Person",
        ["lay down"] = "Lay Down",
        ["dismiss"] = "Dismiss",
        -- Citation Paper
        ["uniform traffic citation"] = "UNIFORM TRAFFIC CITATION",
        ["case number"] = "CASE NUMBER",
        ["violator information"] = "VIOLATOR INFORMATION",
        ["full name"] = "FULL NAME",
        ["drivers license / id"] = "DRIVERS LICENSE / ID",
        ["location of violation"] = "LOCATION OF VIOLATION",
        ["vehicle information"] = "VEHICLE INFORMATION",
        ["plate number"] = "PLATE NUMBER",
        ["make / model"] = "MAKE / MODEL",
        ["color"] = "COLOR",
        ["violation(s) charged"] = "VIOLATION(S) CHARGED",
        ["description of offense"] = "DESCRIPTION OF OFFENSE",
        ["officer certification"] = "OFFICER CERTIFICATION",
        ["issuing officer"] = "ISSUING OFFICER",
        ["total fine due"] = "TOTAL FINE DUE",
        -- HTML Labels
        ["issue citation"] = "ISSUE CITATION",
        ["violator signature"] = "VIOLATOR SIGNATURE",
        ["sign & pay"] = "SIGN & PAY",
        ["front monitoring"] = "FRONT MONITORING",
        ["radar setup"] = "RADAR SETUP",
        ["location name"] = "LOCATION NAME",
        ["limit (km/h)"] = "LIMIT ({unit})",
        ["pose library"] = "POSE LIBRARY",
        ["object placement"] = "OBJECT PLACEMENT",
        ["department manager"] = "DEPARTMENT MANAGER",
        ["dept library"] = "DEPT LIBRARY",
        ["import"] = "Import",
        ["export"] = "Export",
        ["save and reload"] = "Save and reload",
        ["search here..."] = "Search here...",
        ["departments"] = "DEPARTMENTS",
        ["ranks & perms"] = "Ranks & Perms",
        ["locations"] = "LOCATIONS",
        ["other"] = "OTHER",
        ["search..."] = "SEARCH...",
        ["node settings"] = "NODE SETTINGS",
        ["delete node"] = "Delete Node",
        ["member management"] = "Member Management",
        ["member_mgmt_desc"] = "Assign players to created departments and manage their ranks.",
        ["player_search_placeholder"] = "Search players by name or ID...",
        ["select_player_desc"] = "Select a player to manage their department",
        ["player name"] = "Player Name",
        ["department"] = "Department",
        ["rank / grade"] = "Rank / Grade",
        ["update member"] = "Update Member",
        ["fire from department"] = "Fire from Department",
        ["members"] = "MEMBERS",
        ["import configuration"] = "IMPORT CONFIGURATION",
        ["import_desc"] = "Paste the JSON configuration string below to import nodes and connections.",
        ["desktop"] = "Desktop",
        ["file"] = "File",
        ["edit"] = "Edit",
        ["view"] = "View",
        ["window"] = "Window",
        ["help"] = "Help",
        ["check_plate"] = "Check Plate",
        ["unlock_vehicle"] = "Unlock Vehicle",
        ["unlocking_vehicle"] = "Unlocking Vehicle...",
        ["vehicle_unlocked"] = "Vehicle unlocked!",
        ["cancelled"] = "Cancelled!",
        ["seize_vehicle"] = "Seize Vehicle",
        ["wheel_clamp"] = "Wheel Clamp",
        ["wheel_clamp_installing"] = "Installing wheel clamp...",
        ["wheel_clamp_removing"] = "Removing wheel clamp...",
        ["vehicle_clamped"] = "Vehicle clamped.",
        ["vehicle_unclamped"] = "Wheel clamp removed.",
        ["wheel_clamp_on_foot"] = "You must be on foot to use a wheel clamp.",
        ["wheel_clamp_model_failed"] = "Wheel clamp prop failed to load.",
    }
}

function PLTTranslate(key, vars)
    local locale = Config.Locale or "en"
    local langTable = Config.Translations[locale] or Config.Translations["en"]
    local text = langTable[key] or key

    if vars then
        for k, v in pairs(vars) do
            text = text:gsub("{" .. k .. "}", tostring(v))
        end
    end
    return text
end

function T(key, vars)
    return PLTTranslate(key, vars)
end

function PLTGetLocaleTable()
    return Config.Translations[Config.Locale or "en"] or Config.Translations["en"]
end
