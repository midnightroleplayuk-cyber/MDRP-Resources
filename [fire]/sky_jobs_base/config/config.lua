-- Activity access lists accept exact jobs/groups and "gang:<internal_name>" selectors.
-- Gangs use their own membership; configured job duty requirements apply only to job grants.
-- true: Use saved configurator settings + shipped defaults; ignore managed config.lua values.
-- false: Use config.lua. Restart after toggling; saved configurator settings are kept.
-- Bootstrap values, Lua callbacks/metadata and webhooks.lua remain active in both modes.
-- Import config.lua edits: restart, then run /jobconfigimport sky_jobs_base.
Config.UseIngameConfigurator = true

Config.MenuColor = "#1DD1CE" -- Accent color used by the Jobs Base Configurator menu.
Config.AutoExecuteQuery = true -- Plaintext-only startup setting. Automatically creates/updates database tables; false disables it.
Config.DutySystem = true -- Set to false to make job members always count as on duty
Config.ForceOffDutyOnLogin = false -- Set to true to put duty-capable players off duty on every framework login.

-- Global gathering, processing and sale points. No job is required for public points.
-- Configure these in Job Creator -> Farming or /jobconfig -> Jobs Base -> World -> Farming.
-- Set accessMode = "job" and job = "police" to restrict a point to one employment job.
-- Saved configurator values take priority while UseIngameConfigurator is enabled.
Config.Farming = { stations = {} }

-- Shared invoice storage, payments and society income. Players open /billing;
-- staff manage society invoices in their tablet File Explorer.
Config.Billing = {
    enabled = true,
    command = "billing",
    openKey = "", -- Unbound by default; players can assign it in FiveM key bindings.
    defaultCurrency = "bank",
    depositToSociety = true,
    requireOnDuty = true,
    maxAmount = 1000000, -- Limit for manually issued invoices; job services validate their own prices.
    range = 6.0,
    paymentTermDays = 7, -- Pay Later invoices keep the deadline set when they are issued.
    autoPayOverdue = true, -- Try overdue payments automatically; insufficient funds leave the invoice open.
    onsiteTimeoutSeconds = 120, -- Time allowed to complete payment while the issuer is nearby.
    -- Approved job -> plans recipients can choose before an unpaid Pay Later invoice expires.
    -- The first installment is paid on selection. Remaining rates keep fixed intervals.
    -- Missing jobs / empty lists disable new plans; existing agreements remain unchanged.
    -- Edit these in Jobs Base -> Administration -> Billing when /jobconfig is enabled.
    installmentPlans = {
        -- police = {
        --     { id = "weekly_3", count = 3, intervalDays = 7 },
        --     { id = "monthly_4", count = 4, intervalDays = 30 },
        -- },
    },
    -- Approved job -> employee percentage (whole number, 0-100). Missing jobs / 0 disable the share.
    -- Only new society-to-player monetary invoices qualify. The society receives the remainder.
    -- Offline employee shares are saved and paid to their bank account after login.
    -- With /jobconfig enabled, edit Jobs Base -> Administration -> Billing -> Employee shares by job.
    employeeShares = {
        -- police = 10,    -- A paid $500 fine gives the officer $50 and the society $450.
        -- sheriff = 5,    -- A paid $500 fine gives the deputy $25 and the society $475.
        -- ambulance = 10, -- A paid $200 treatment invoice gives the medic $20 and the society $180.
    },
}

Config.ToggleFeatures = {
    units = true, -- Shared department/unit system for every job registered in Jobs Base.
}

Config.OrganizationUnits = {
    requireOnDuty = true,
    maxUnitsPerJob = 100,
    maxPermissionsPerUnit = 32,
    maxVehiclesPerUnit = 100,
}

-- Cross-job training rules only. Documents/folders use their explicit Shared
-- Documents grants; these switches never grant or block access to job records.
Config.Sharing = {
    enabled = true,
    maxTargetsPerRule = 64
}

-- Additional record clearance, shared by Police and DOJ. Rules match an exact
-- framework job and numeric grade. Membership/sharing is still required.
Config.RecordAccess = {
    defaultLevel = 1,
    levels = {
        { level = 1, label = "Level 1" },
        { level = 2, label = "Level 2" },
        { level = 3, label = "Level 3" },
        { level = 4, label = "Level 4" },
        { level = 5, label = "Level 5" },
    },
    gradeRules = {},
}

-- Shared RP registers with configurable fields and job access. Job-specific
-- registers are configured in their owning resource. Removing a definition keeps
-- its records in storage; restoring the same key restores access to that data.
Config.Registries = {
    definitions = {},
}

-- ============================================================================
-- Per-command permissions
-- Define which groups are allowed to use each command.
-- Group names match FiveM ACE principals (e.g. "admin" resolves to "group.admin").
-- If a command is NOT listed here, only the server console can use it.
-- The framework wires `add_ace group.<g> sky_jobs_base.<command> allow`
-- for each listed group at server start.
-- ============================================================================
Config.CommandPermissions = {
    -- /jobconfig - Open the unified job configurator selector
    jobconfig = { "god", "superadmin", "admin" },
    -- /setboss <job> <grade> - Grant rank permissions for a regular job (no player assignment)
    setboss  = { "god", "superadmin", "admin" },
    -- /setcrimeboss <organization> <playerId> - Assign the highest Crime organization rank
    setcrimeboss = { "god", "superadmin", "admin" },
    -- /removecrimeboss <organization> <playerId> - Remove only that player's Crime membership
    removecrimeboss = { "god", "superadmin", "admin" },
    -- /admincuff <playerId> <handcuffs|zipties> - Force-apply restraints to a player
    admincuff = { "god", "superadmin", "admin" },
    -- /adminuncuff <playerId> - Force-remove cuffs or zipties from a player
    adminuncuff = { "god", "superadmin", "admin" },
    -- /skygivejob <playerId> <job> [grade] - Add a job to the player's multi-job list
    skygivejob = { "god", "superadmin", "admin" },
    -- /skyremovejob <playerId> <job> - Remove a job from the player's multi-job list
    skyremovejob = { "god", "superadmin", "admin" },
    -- /multijobadmin <playerId> [list|add|set|remove] [job] [grade] - Inspect and edit a player's multi-job list
    multijobadmin = { "god", "superadmin", "admin" },
    -- /dutytest [playerId] [on|off] - Debug command to force a duty state on a player
    dutytest = { "god", "superadmin", "admin" },
    -- /propoffset [supplyOffset|operatorOffset|outletOffset] - Measure local transforms on world props
    propoffset = { "god", "superadmin", "admin" },
}

Config.PropOffsetTool = {
    enabled = true,
    maxDistance = 150.0,
    outputKey = "supplyOffset"
}

-- One framework job can use Ambulance and Fire at the same time.
-- Example: register "firefighter" as the "Job name" in BOTH /jobconfig -> Fire Jobs
-- and /jobconfig -> Ambulance Jobs. If UseJobConfigurator is disabled, add the same
-- job name to Config.Jobs in both resources instead.
-- The job then belongs to both groups, "fire" and "ambulance", so both resources'
-- features, matching tablet apps and radial actions can be used, subject to their
-- normal duty, grade and permission requirements.
--
-- This table selects which group supplies the shared settings for that job.
-- It does not register the job in either resource; both registrations above are required.
-- Format: ["actual_framework_job_name"] = "primary_group"
-- Left: the framework job name, e.g. "firefighter" or "jfrd".
-- Right: "fire" for Fire or "ambulance" for Ambulance (not the resource name).
--
-- With ["firefighter"] = "fire", the Fire definition supplies the shared society
-- account, management, sharing rules, job visuals, duty/off-duty mapping, and
-- Dispatch/Training settings. Use "ambulance" instead to take these from Ambulance.
-- Configure Dispatch vehicles and statuses in the selected group for the combined fleet.
-- Both group memberships remain active regardless of which group is selected.
--
-- Each creator location keeps its own group's vehicle/shop catalogs, trunk equipment,
-- garage rules and storage/locker capacities: a Fire station uses Fire's configuration,
-- while a hospital uses Ambulance's. Their catalogs are not automatically combined.
-- Legacy locations without creator context use the selected primary definition.
--
-- If no override exists, or the selected group has not registered this job, the
-- alphabetically first registered group wins: "ambulance" before "fire".
-- This is independent of resource start order once both groups have registered.
-- This Jobs Base setting stays in config.lua, outside the individual /jobconfig stores.
-- After changing it, restart Jobs Base and its dependent job resources, or the server.
Config.PrimaryJobGroups = {
    -- ["firefighter"] = "fire", -- Uncomment and replace "firefighter" with your shared job name.
}

Config.MultiJob = {
    enabled = true,
    command = "jobs",
    giveJobCommand = "skygivejob",
    removeJobCommand = "skyremovejob",
    adminCommand = "multijobadmin",
    -- Standard job used when a player has no active multi-job anymore.
    -- Example: unemployed rank 0
    defaultJob = "unemployed",
    defaultGrade = 0,
    -- Show the default job as a selectable entry in the multi-job menu.
    showDefaultJob = true,
    -- Backwards compatible aliases. Leave nil to use defaultJob/defaultGrade.
    fallbackJob = nil,
    fallbackGrade = nil,
    -- Maximum number of assigned jobs. The permanent default job does not consume a slot.
    maxJobs = 8,
    includeCurrentJob = true,
    switchOffDuty = true,
    allowUnregisteredFrameworkJobs = true,
    -- Jobs listed here cannot be removed by the player from the self-service menu.
    -- Admin commands and exports can still remove them.
    selfRemoveBlacklist = {
        -- "police",
        -- "ambulance"
    },
    autoDetectOffDutyJobs = true, -- Automatically links framework pairs such as ballas and off_ballas.
    offDutyPrefix = "off_",
    policeColor = "#173B73",
    medicalColor = "#C73535",
    openKey = nil -- Optional keybind, e.g. "F6". Leave nil to use /jobs only.
}

-- ============================================================================
-- Colleague map blips
-- Live world-map blips for on-duty colleagues of the player's own job.
-- Works for every Sky job (police, ambulance, mechanic, ...) - the server
-- pushes a per-job snapshot every ~1s and the client only renders while the
-- player is on-duty and has the pause/tablet map open.
-- ============================================================================
Config.ColleagueMapBlips = {
    enabled = true,
    showSelf = true,            -- Show your own blip too
    -- Jobs allowed to use colleague map blips. Set to nil to allow every job.
    allowedJobs = { "police", "ambulance" },
    -- Optional per-job map visibility. The key is the viewer job, the values
    -- are the jobs whose colleague blips it can see. If a viewer job is not
    -- listed here, only its own job is shown.
    groups = {
        police = { "police", "ambulance" },
        ambulance = { "police", "ambulance" },
    },
    requireItem = false,         -- If true, a player is only shown while carrying item
    item = "gps",
    showOnMinimap = false,      -- true = render colleague blips outside the pause-menu map as normal map/minimap blips
    updateIntervalMs = 500,     -- Legacy fallback for pauseMenuRenderIntervalMs
    pauseMenuSnapshotIntervalMs = 500, -- Server snapshot interval while the pause-menu map is open
    pauseMenuRenderIntervalMs = 200,   -- Local blip refresh interval while the pause-menu map is open
    display = 4,                -- Legacy option; pause-menu colleague blips always use display flag 2.
    shortRange = false,
    scale = 0.85,
    color = 3,
    colorLights = 3,            -- Color while vehicle siren is on
    colorLightsAlt = nil,       -- Optional second color for siren flashing
    colorLightsIntervalMs = 450,
    sprites = {
        foot = 1,
        car = 225,
        boat = 427,
        heli = 64,
        car_lights = 56,
        boat_lights = 427,
        heli_lights = 43,
    }
}

Config.EmployeeGpsJammer = {
    enabled = true,
    item = "gps_jammer",
    consumeOnUse = true,
    maxDistance = 3.0,
    durationSeconds = 300,
    cooldownMs = 1500,
    animScenario = "WORLD_HUMAN_STAND_MOBILE",
    animDurationMs = 2500,
    jobs = {
        police = true
    }
}

Config.DrugTests = {
    enabled = true,
    crimeResource = "sky_crimesystem",
    maxDistance = 3.0,
    cooldownSeconds = 2,
    requireOnDuty = true,
    fakeSample = {
        enabled = true,
        item = "fake_drug_sample_clean",
        durationSeconds = 300,
        consumeOnUse = true,
        weight = 100
    },
    records = {
        enabled = true,
        openAfterTest = true,
        maxRecords = 250,
        maxSubjectNameLength = 120,
        accessGroups = { "police", "ambulance", "doj" },
        shareGroups = { "police", "ambulance", "doj" }
    },
    simple = {
        item = "drug_test_kit",
        group = "police",
        consumeOnUse = true,
        weight = 100
    },
    advanced = {
        item = "advanced_drug_test_kit",
        group = "ambulance",
        consumeOnUse = true,
        weight = 150
    }
}

Config.Nui = {
    -- Sources are tried from top to bottom. Move entries to change priority.
    -- nui:// entries are normalized to FiveM's current https://cfx-nui-* URL format.
    -- If no source contains the requested image, each NUI uses its built-in default image.
    itemImageBases = {
        -- Inventory image presets: uncomment one or more entries. The first matching image wins.
        -- "https://cfx-nui-inventory_images/images",                    -- tgiann-inventory
        -- "https://cfx-nui-jaksam_inventory/_images",                   -- jaksam_inventory
        -- "https://cfx-nui-ak47_inventory/web/build/images",            -- ak47_inventory
        -- "https://cfx-nui-ak47_qb_inventory/web/build/images",         -- ak47_qb_inventory
        -- "https://cfx-nui-qs-inventory/html/images",                   -- qs-inventory
        -- "https://cfx-nui-core_inventory/html/img",                    -- core_inventory
        -- "https://cfx-nui-inventory/web/dist/assets/items",            -- inventory
        -- Standard inventories
        -- "https://cfx-nui-ox_inventory/web/images",                    -- ox_inventory
        -- "https://cfx-nui-qb-inventory/html/images",                   -- qb-inventory
        -- "https://cfx-nui-esx_addoninventory/web/images",              -- esx_addoninventory
        "https://cdn.sky-systems.net/items",
    },
    weaponImageBases = {
        -- Inventory image presets: uncomment one or more entries. The first matching image wins.
        -- "https://cfx-nui-inventory_images/images",                    -- tgiann-inventory
        -- "https://cfx-nui-jaksam_inventory/_images",                   -- jaksam_inventory
        -- "https://cfx-nui-ak47_inventory/web/build/images",            -- ak47_inventory
        -- "https://cfx-nui-ak47_qb_inventory/web/build/images",         -- ak47_qb_inventory
        -- "https://cfx-nui-qs-inventory/html/images",                   -- qs-inventory
        -- "https://cfx-nui-core_inventory/html/img",                    -- core_inventory
        -- "https://cfx-nui-inventory/web/dist/assets/items",            -- inventory
        -- Standard inventories
        -- "https://cfx-nui-ox_inventory/web/images",                    -- ox_inventory
        -- "https://cfx-nui-qb-inventory/html/images",                   -- qb-inventory
        -- "https://cfx-nui-esx_addoninventory/web/images",              -- esx_addoninventory
        "https://cdn.sky-systems.net/weapons",
    },
    propImageBases = {
        "https://cdn.sky-systems.net/props",
        -- Example: "nui://your_resource/img/props"
    },
    pedImageBases = {
        "https://cdn.sky-systems.net/peds",
        -- Example: "nui://your_resource/img/peds"
    },
    vehicleImageBases = {
        "https://cdn.sky-systems.net/vehicles",
        -- Example: "nui://your_resource/img/vehicles"
    },
    vehicleStudioImageSet = "default", -- Image set used when jg-vehiclestudio is started.
}

Config.Tablet = {
    enabled = true, -- Set to false to remove tablet from radial + disable all apps
    requireItem = false, -- If true, opening the tablet (radial menu, exports) requires carrying the configured item.
    item = "tablet", -- Usable inventory item that opens the tablet (set to "" to disable the usable item).
    computerAccess = {
        enabled = true, -- Allow on-duty employees to open the job tablet from matching world computers near their job locations without the tablet item.
        stationRadius = 100.0, -- Computer props are usable only when they are inside this radius around a configured job location.
        interactionDistance = 1.0, -- Target/TextUI interaction distance from the computer prop.
        animation = {
            dict = "anim@heists@prison_heiststation@cop_reactions",
            name = "cop_b_idle",
            flag = 49 -- Looping upper-body animation so the ped remains positioned at the computer.
        },
        props = {
            "prop_monitor_01a",
            "prop_monitor_02",
            "prop_monitor_w_large",
            "prop_laptop_01a",
            "xm_prop_x17_laptop_milo",
            "prop_id_monitor_01",
            "prompt-sandy_sheriff_computer_old",
            "prop_monitor_01d",
            "gn_monitor_01",
            "sf_prop_sf_monitor_b_02b",
            "xm_int02_security_monitor",
            "m24_2_prop_m42_monitor_w_large",
            "ch_prop_ch_monitor_01a",
            "sf_prop_sf_monitor_01a",
            "m25_2_prop_m52_monitor_01a",
            "tr_prop_tr_monitor_01a",
            "prop_monitor_01c",
            "prop_ld_monitor_01",
            "v_serv_ct_monitor01",
            "v_res_monitorsquare",
            "v_serv_ct_monitor05",
            "ex_prop_monitor_01_ex",
            "sf_prop_sf_monitor_b_02a",
            "v_serv_ct_monitor06",
            "v_res_monitor",
            "prop_monitor_03b",
            "prop_monitor_li",
            "tr_prop_tr_monitor_01b",
            "m25_1_prop_m51_monitor_w_large",
            "ex_prop_trailer_monitor_01",
            "v_54_lng_mesh_compmonitor",
            "m24_1_prop_m41_monitor_02a",
            "vw_prop_vw_trailer_monitor_01",
            "v_serv_ct_monitor07",
            "sf_prop_sf_monitor_s_02a",
            "m24_1_prop_m41_monitor_01a"
        }
    },
    vehicleAccess = {
        enabled = false, -- Allow the job tablet to open without its item while the player is inside an allowed vehicle.
        vehicles = {
            -- "police",
            -- "ambulance"
        }
    },
    prop = {
        model = "prop_cs_tablet",
        bone = 60309,
        offset = vector3(0.03, 0.002, -0.0),
        rotation = vector3(10.0, 160.0, 0.0),
        anim = {
            dict = "amb@code_human_in_bus_passenger_idles@female@tablet@base",
            name = "base",
            flag = 49 -- upper body + loop
        }
    },
    map = {
        closeOnDispatchAccept = true -- Close the tablet automatically after accepting a dispatch on the map
    },
    apps = {
        -- Set an app to false to hide it, or use a table for options:
        -- cctv = { enabled = true, isNew = true }
        forms = true,
        training = { enabled = true, isNew = false },
        management = true,
        business = true,
        online_shop = true, -- Optional per job: enable Online shop in the job's General settings.
        online_shop_deliveries = true, -- Uses the same per-job Online shop access.
        cctv = true,
        camera = true,
        gallery = true,
        dispatch = { enabled = true, isNew = false },
        map = true,
        tracking = true,
        chat = true,
        dark_chat = true,
        calendar = true,
        personal_notes = { enabled = true, isNew = false },
        calculator = true,
        settings = true,
        crime_heist_planning = true,
        crime_pvp_events = true,
        crime_drug_market = true,
        crime_drug_heat = true,
        crime_drug_contacts = true,
        crime_drug_business = true,
        crime_darknet_market = true
    },
    external = {
        enabled = true, -- Used when sky_base Config.tablet is "lb" or "roadpad".
        mode = "apps", -- "apps": one provider app per Sky app; "all-in-one": one Sky Jobs app with the full home NUI.
        identifierPrefix = "sky_jobs_",
        developer = "Sky-Systems",
        defaultApp = true, -- LB: pre-install; RoadPad: add directly instead of only showing it in the store.
        removable = false,
        size = 5120,
        icon = "https://cfx-nui-sky_jobs_base/source/html/logo.svg",
        allInOne = {
            identifier = "sky_jobs",
            name = "Sky Jobs",
            description = "All Sky Jobs tablet apps in one place.",
            icon = "https://cfx-nui-sky_jobs_base/source/html/logo.svg",
            defaultApp = true,
            removable = false,
            size = 10240,
            -- Optional RoadPad job filters. The Sky home still applies its own app permissions.
            allowJobs = {},
            disallowJobs = {}
        },
        -- Configure individual external-provider apps by registry key. `false` disables an app,
        -- `true` enables it with its defaults, and a table enables it with custom options.
        -- Camera and Calculator default to off because LB Tablet already provides both natively.
        appOverrides = {
            camera = false,
            calculator = false,
            -- management = { name = "Company", icon = "https://example.com/company.png", fixBlur = false }
        },
        lb = {
            -- Keep Sky apps at LB's native iframe size. Set false only for a legacy app whose CSS
            -- explicitly depends on LB's oversized iframe plus transform-scale compatibility path.
            fixBlur = true,
            -- Bump this value when shipped LB descriptors change (for example icons) or an older
            -- release left duplicate entries. Each client/server pair runs the repair once.
            layoutRepairVersion = "2026-08-17-app-icons-native-scale-1",
            -- Optional: in App Mode, hide LB's native apps that overlap with a Sky app.
            -- Keep this false by default: LB Settings, Photos, etc. are not exact replacements.
            hideNativeDuplicates = false,
            nativeDuplicates = {
                camera = "Camera",
                gallery = "Photos",
                map = "Maps",
                calculator = "Calculator",
                settings = "Settings"
            },
            -- Add keys from separately installed Sky job resources here. Identifiers discovered
            -- through the registry are remembered automatically after their first registration.
            managedAppKeys = {}
        },
        roadpad = {
            -- RoadPad has no documented dynamic AddCustomApp API. This file is generated at runtime;
            -- copy its `apps` entries into roadpad/public/static/config/config.json -> AppStore.
            outputFile = "roadpad-apps.generated.json",
            category = "apps",
            darkmode = true
        }
    }
}

Config.Tracking = {
    enabled = true,
    -- Entries may be exact job keys or whole job-group keys. Add "doj" here when that group should gain access.
    allowedJobs = { "police" },
    -- Minimum grade per exact job key. Jobs not listed here default to grade 0.
    minimumGrades = {
        police = 1,
        sheriff = 2
    },
    -- Jobs or job groups that receive the tracking dispatch and search-area blip.
    dispatchJobs = { "police", "sheriff" },
    requireOnDuty = true,
    phone = {
        cooldownSeconds = 10,
        maxNumberLength = 32,
        itemCheck = {
            enabled = true, -- Require the tracked online player to carry any configured phone item.
            item = { "phone" }, -- Add other phone item names here. Legacy single strings remain supported.
            amount = 1
        },
        -- The dispatch center is randomly offset from the target. Keep the radius larger than offsetMax.
        offsetMin = 25.0,
        offsetMax = 60.0,
        blip = {
            sprite = 9,
            scale = 0.65,
            color = 1,
            alpha = 128,
            radius = 80.0,
            durationSeconds = 120 -- Blip/dispatch lifetime and global per-number deduplication window.
        }
    },
    socialMedia = {
        cooldownSeconds = 2,
        maxUsernameLength = 64
    }
}

Config.Training = {
    -- Master switch for the Training App and its Job Configurator settings.
    enabled = true,
    appJobs = { "police", "ambulance", "fire", "firefighter", "mechanic", "doj" },
    requireOnDuty = true,
    upcomingDays = 90,
    historyDays = 365,
    reminderMinutes = 60,
    readCooldownMs = 350,
    mutationCooldownMs = 350,
    allowSelfEnrollment = true,
    approvalRequired = true,
    defaultCapacity = 12,
    permissions = {
        schedule = 1001,
        catalog = 1002,
        viewRecords = 1003,
        delete = 1004,
        manageSessions = 1005,
        reviewEnrollments = 1006,
        recordResults = 1007,
        issueQualifications = 1008,
        revokeQualifications = 1009,
        viewAudit = 1010
    },
    jobConfiguratorExtensions = {
        {
            key = "trainingSettings",
            field = "trainingSettings",
            type = "jsonObject",
            icon = "GraduationCap",
            label = "Training settings",
            labelKey = "workshopConfig.extensions.trainingSettings.label",
            description = "Configure training access, enrollment, approvals, and course planning for this job.",
            descriptionKey = "workshopConfig.extensions.trainingSettings.description",
            copyOnCreate = true,
            defaultValue = {},
            fields = {
                { key = "enabled", type = "boolean", label = "Enable training", labelKey = "workshopConfig.trainingFields.enabled", description = "Makes the Training App available to this job.", descriptionKey = "workshopConfig.trainingFieldDescriptions.enabled" },
                { key = "requireOnDuty", type = "boolean", label = "Require duty", labelKey = "workshopConfig.trainingFields.requireOnDuty", description = "Requires employees to be on duty before opening or using the Training App.", descriptionKey = "workshopConfig.trainingFieldDescriptions.requireOnDuty", requiresAll = { { key = "enabled", value = true } } },
                { key = "allowSelfEnrollment", type = "boolean", label = "Allow self-enrollment", labelKey = "workshopConfig.trainingFields.allowSelfEnrollment", description = "Allows employees to enroll themselves in available training sessions.", descriptionKey = "workshopConfig.trainingFieldDescriptions.allowSelfEnrollment", requiresAll = { { key = "enabled", value = true } } },
                { key = "approvalRequired", type = "boolean", label = "Require enrollment approval", labelKey = "workshopConfig.trainingFields.approvalRequired", description = "Keeps self-enrollments pending until an authorized instructor approves them.", descriptionKey = "workshopConfig.trainingFieldDescriptions.approvalRequired", requiresAll = { { key = "enabled", value = true }, { key = "allowSelfEnrollment", value = true } } },
                { key = "defaultCapacity", type = "integer", label = "Default capacity", labelKey = "workshopConfig.trainingFields.defaultCapacity", description = "Default number of seats used when a new training session is created.", descriptionKey = "workshopConfig.trainingFieldDescriptions.defaultCapacity", min = 1, max = 200, requiresAll = { { key = "enabled", value = true } } },
                { key = "upcomingDays", type = "integer", label = "Upcoming period (days)", labelKey = "workshopConfig.trainingFields.upcomingDays", description = "Number of future days shown in the Training App schedule.", descriptionKey = "workshopConfig.trainingFieldDescriptions.upcomingDays", min = 1, max = 365, requiresAll = { { key = "enabled", value = true } } }
            }
        }
    }
}

local training_job_defaults = {
    enabled = true,
    requireOnDuty = Config.Training.requireOnDuty,
    allowSelfEnrollment = Config.Training.allowSelfEnrollment,
    approvalRequired = Config.Training.approvalRequired,
    defaultCapacity = Config.Training.defaultCapacity,
    upcomingDays = Config.Training.upcomingDays
}
local training_settings_extension = Config.Training.jobConfiguratorExtensions[1]
training_settings_extension.defaultValue = training_job_defaults
for _, field in ipairs(training_settings_extension.fields) do
    field.default = training_job_defaults[field.key]
end

-- ============================================================================
-- DISPATCH
-- Quick setup: enabled / legacyAlertBanner
--   true  / false -> Dispatch App with radio alerts
--   true  / true  -> Dispatch App with radio alerts and the classic banner
--   false / any   -> Classic map dispatch with its original banner
-- radio.enabled controls the radio UI; existing /jobconfig overrides still apply.
-- Center routing and global mode changes saved in /jobconfig apply immediately.
-- Full setup: docs/DISPATCH_EINRICHTUNG.md
-- ============================================================================
Config.Dispatch = {
    -- ========================================================================
    -- 01 - System mode and incoming alerts
    -- ========================================================================
    enabled = true, -- false selects the classic map dispatch system.
    legacyAlertBanner = false, -- Additional top-center banner while enabled = true.

    -- Technical job/group keys for Dispatch App access.
    appJobs = { "police", "sheriff", "ambulance", "fire", "firefighter", "mechanic" },

    -- ========================================================================
    -- 02 - Handheld radio
    -- ========================================================================
    radio = {
        -- Display pages and available controls
        enabled = true,
        incidentDisplay = true,
        assignedUnitsDisplay = true,
        crewDisplay = true,
        maxIncidentUnits = 12,
        fmsControl = true,

        -- Incident channel and panic button
        autoSwitchIncidentChannel = true,
        incidentChannel = "",
        panicEnabled = true,
        panicCooldownSeconds = 45,

        -- Personal volume and display preferences
        volumeKnob = true,
        allowPersonalDisplayProfiles = true,
        defaultTextScale = 1.1,
        minTextScale = 0.85,
        maxTextScale = 1.45,

        -- Keypad -> FMS status code. An empty string leaves the key unassigned.
        fmsKeyBindings = {
            ["1"] = 1,
            ["2"] = 2,
            ["3"] = 3,
            ["4"] = 4,
            ["5"] = 5,
            ["6"] = 6,
            ["7"] = 7,
            ["8"] = 8,
            ["9"] = 9,
            ["*"] = "",
            ["0"] = "",
            ["#"] = ""
        },

        -- Physical buttons. "default" keeps the built-in action for that button.
        buttonBindings = {
            ["soft-left"] = "default",
            ["soft-center"] = "default",
            ["soft-right"] = "default",
            ["call"] = "default",
            ["end"] = "default",
            ["panic"] = "panic",
            ["dpad-up"] = "default",
            ["dpad-down"] = "default",
            ["dpad-left"] = "default",
            ["dpad-right"] = "default",
            ["dpad-ok"] = "default"
        }
    },

    -- ========================================================================
    -- 03 - Dispatch centers and staffing
    -- ========================================================================
    -- Keep profile IDs stable. The array order breaks ties when routing new incidents.
    -- dispatcherJobs may staff a center; coveredJobs are the jobs it may dispatch.
    centers = {
        -- Police Dispatch: Police and Sheriff
        {
            id = "central_dispatch",
            label = "",
            enabled = true,
            restrictToDispatcherJob = false,
            dispatcherJobs = { "police", "sheriff" },
            coveredJobs = { "police", "sheriff" },
            primaryJobs = { "police", "sheriff" },

            -- Shared operations uses the same ID in both centers and in responder defaults.
            -- Radio channels and FMS control
            -- label overrides the display name; empty keeps the standard translation or channel ID.
            -- Custom example: { id = "RANGER_MAIN", label = "Ranger Hauptkanal", shortLabel = "RAG" }
            channels = {
                { id = "POLICE_MAIN", label = "", shortLabel = "POL" },
                { id = "SHERIFF_MAIN", label = "", shortLabel = "SHF" },
                { id = "DISPATCH_MAIN", label = "", shortLabel = "OPS" }
            },
            defaultChannel = "DISPATCH_MAIN",
            statusControl = "dispatcher_preferred",
            noDispatcherFallback = true,

            -- Self-dispatch when unstaffed and optional cooperation when staffed
            hybrid = {
                enabled = true,
                activationDelaySeconds = 0,
                cooperativeWhenStaffed = false,
                writtenOnlyWhenUnstaffed = true,
                allowCallback = true,

                allowedPriorities = { 1, 2, 3, 4, 5 },
                incidentCommander = true,
                selfClose = true,

                requestAvailableUnits = true,
                requestCooldownSeconds = 30,
                requestDurationSeconds = 180,
                automaticAlarmAfterSeconds = 0,
                maxIncidentsPerUnit = 1,

                reportPdf = true,
                crossCenterTransfer = true
            },

            -- Staffing roles and connections to other centers
            roles = {
                { id = "call_taker", default = true },
                { id = "dispatcher", default = true },
                { id = "situation" }
            },
            stations = {},
            connectedCenters = {
                {
                    id = "ems_dispatch",
                    type = "internal",
                    profileId = "ems_dispatch",
                    contactMethods = { "written", "incident_transfer" }
                }
            },
            alarmMethods = { "tablet", "radio_tone", "station_announcement" }
        },

        -- Fire & EMS Dispatch: shared fire and ambulance control room
        {
            id = "ems_dispatch",
            label = "",
            enabled = true,
            restrictToDispatcherJob = false,
            dispatcherJobs = { "ambulance", "fire", "firefighter" },
            coveredJobs = { "ambulance", "fire", "firefighter" },
            -- Primary unattended intake; other covered centers remain available for staffed routing and transfers.
            primaryJobs = { "ambulance", "fire", "firefighter" },

            -- Shared operations uses the same ID in both centers and in responder defaults.
            -- Radio channels and FMS control
            -- label overrides the display name; empty keeps the standard translation or channel ID.
            -- Custom example: { id = "RANGER_MAIN", label = "Ranger Hauptkanal", shortLabel = "RAG" }
            channels = {
                { id = "EMS_MAIN", label = "", shortLabel = "EMS" },
                { id = "FIRE_MAIN", label = "", shortLabel = "FIR" },
                { id = "DISPATCH_MAIN", label = "", shortLabel = "OPS" }
            },
            defaultChannel = "DISPATCH_MAIN",
            statusControl = "dispatcher_preferred",
            noDispatcherFallback = true,

            -- Self-dispatch when unstaffed and optional cooperation when staffed
            hybrid = {
                enabled = true,
                activationDelaySeconds = 0,
                cooperativeWhenStaffed = false,
                writtenOnlyWhenUnstaffed = true,
                allowCallback = true,

                allowedPriorities = { 1, 2, 3, 4, 5 },
                incidentCommander = true,
                selfClose = true,

                requestAvailableUnits = true,
                requestCooldownSeconds = 30,
                requestDurationSeconds = 180,
                automaticAlarmAfterSeconds = 0,
                maxIncidentsPerUnit = 1,

                reportPdf = true,
                crossCenterTransfer = true
            },

            -- Staffing roles and connections to other centers
            roles = {
                { id = "call_taker", default = true },
                { id = "dispatcher", default = true },
                { id = "situation" }
            },
            stations = {},
            connectedCenters = {
                {
                    id = "central_dispatch",
                    type = "internal",
                    profileId = "central_dispatch",
                    contactMethods = { "written", "incident_transfer" }
                }
            },
            alarmMethods = { "tablet", "radio_tone", "station_announcement" }
        }
    },

    -- ========================================================================
    -- 04 - Unit routing, default channels and FMS
    -- ========================================================================
    -- Estimated travel time and fallback behavior
    averageResponseSpeedKmh = 70,
    noUnitFallback = true,

    -- Automatic FMS transitions
    readyStatusCode = 1,
    respondingStatusCode = 3,

    -- Shared operations is the starting channel for responders and both centers.
    -- Department main/tactical channels remain selectable; per-job settings can override this.
    groupDefaults = {
        police = { defaultChannel = "DISPATCH_MAIN" },
        ambulance = { defaultChannel = "DISPATCH_MAIN" },
        fire = { defaultChannel = "DISPATCH_MAIN" },
        firefighter = { defaultChannel = "DISPATCH_MAIN" },
        mechanic = { defaultChannel = "DISPATCH_MAIN" }
    },

    -- available marks statuses treated as available when selecting units.
    defaultStatusCodes = {
        { code = 1, available = true },
        { code = 2, available = true },
        { code = 3, available = false },
        { code = 4, available = false },
        { code = 5, available = false },
        { code = 6, available = false }
    },

    -- ========================================================================
    -- 05 - Dispatcher permissions
    -- ========================================================================
    -- Values are Bossmenu permission IDs, not job grades.
    bossPermissions = {
        enabled = true,
        capabilities = {
            take_calls = 28,
            manage_calls = 28,
            callback_calls = 28,
            create_incidents = 24,
            manage_incidents = 24,
            manage_situation = 24,
            alarm_units = 25,
            alarm_response_plan = 26,
            send_sds = 27,
            send_warnings = 23,
            send_announcements = 23,
            map_move_incidents = 29,
            map_draw = 30,
            map_alarm = 31
        }
    },

    -- ========================================================================
    -- 06 - SDS messages and public warnings
    -- ========================================================================
    -- Public alerts and their optional EmergencyDispatch mapping
    publicWarnings = {
        enabled = true,
        maxMessageLength = 2000,
        historyLimit = 100,
        rateLimitSeconds = 3,
        templates = {
            warning = "",
            clear = "",
            traffic_warning = "",
            traffic_clear = "",
            information = "",
            announcement = ""
        },
        emergencyDispatch = {
            enabled = true,
            typeMap = {
                warning = "warnung",
                clear = "entwarnung",
                traffic_warning = "verkehr_warnung",
                traffic_clear = "verkehr_entwarnung",
                information = "info",
                announcement = "announce"
            }
        }
    },

    -- Internal messages sent to units
    sds = {
        enabled = true,
        maxMessageLength = 1000,
        historyLimit = 100,
        rateLimitSeconds = 1,
        template = ""
    },

    -- ========================================================================
    -- 07 - Enhanced MDT interface
    -- ========================================================================
    enhanced = {
        enabled = true,

        -- Operational map: visibility, zoom, live movement and interaction
        map = {
            filters = true,
            clustering = true,
            clusterRadiusPercent = 0.045,
            minZoom = 1.0,
            maxZoom = 6.0,
            zoomStep = 0.35,
            markerSizePx = 28,
            autoCenterUnit = true,
            autoCenter = true,
            -- Positions are published every five seconds; the UI completes the visible move quickly.
            smoothMovementMs = 650,
            vehicleUpdateIntervalMs = 5000,
            movementTrailSeconds = 900,
            highlightRadioTraffic = true,
            visibleOnlyRendering = true,
            spiderfyClusters = true,
            liveRoutes = true,
            dragDropActions = true,
            contextMenu = true,
            nearestAvailableOnly = true, -- false also considers occupied units in the map's nearest-unit search.
            tacticalTools = false,
            timeline = false,
            defaultLayers = {
                "incidents", "units", "facilities", "pois"
            }
        },

        -- Layout and scale of the dispatcher workspace
        workspace = {
            resizableColumns = true,
            collapsiblePanels = true,
            defaultDensity = "comfortable",
            defaultUiScale = 1.0,
            minUiScale = 0.85,
            maxUiScale = 1.3
        },

        -- Dispatcher actions and undo window
        operations = {
            priorityDrag = true,
            multiUnitAlarm = true,
            quickActions = true,
            selectCreatedIncident = false,
            takeCreatedIncident = false, -- Uses the normal ownership checks; another active incident is never displaced.
            suggestUnitsOnSelect = false,
            recommendationStrategy = "crew", -- "crew" preserves the existing priority; "distance" prefers nearby units.
            responsePlanMode = "full", -- "remaining" counts staffed assigned/offered units before suggesting reinforcements.
            undoSeconds = 8
        },

        -- Highlights inside the MDT; the top-center banner is legacyAlertBanner.
        notifications = {
            enabled = true,
            newCalls = true,
            newIncidents = true,
            highlightSeconds = 12
        },

        -- Draft saving and reconnect behavior
        resilience = {
            autoSaveDrafts = true,
            autoReconnect = true,
            reconnectIntervalMs = 5000
        }
    },

    -- Optional postal lookup from a JSON file matching your server's postal map.
    -- Bundled: oulsen_satmap_postals.json, new-postals.json, old-postals.json, ocrp-postals.json.
    -- JSON rows: { "code": "001", "x": 57.89, "y": 7211.67 }; z and label are optional.
    -- Set resource/file in /jobconfig; inline entries optionally override matching JSON codes.
    postalSearch = {
        enabled = false,
        resource = "sky_jobs_base",
        file = "config/postal/oulsen_satmap_postals.json",
        entries = {}
    },

    -- ========================================================================
    -- 08 - Phone and audio integrations
    -- ========================================================================
    -- Emergency phone app and callback handoff
    phone = {
        enabled = true,
        autoDetectCallerNumber = true,
        allowManualCallbackNumber = true,
        identifier = "sky_dispatch",
        developer = "Sky-Systems",
        icon = "https://cfx-nui-sky_jobs_base/source/html/img/dispatch_emergency_app.svg",
        route = "/dispatch-call",

        callbackHandoff = {
            enabled = true,
            clientEvent = "",
            exportResource = "",
            exportName = ""
        }
    },

    -- Station announcements / text-to-speech audio
    announcement = {
        enabled = false,
        resource = "xsound",
        defaultRadius = 65.0,
        ttsUrlTemplate = "",
        allowedAudioHosts = {}
    },

    -- Positional audio around responders; separate from the private UI alert tone.
    -- Volume: 0.0-1.0. Radius: meters.
    spatialSounds = {
        enabled = true,
        resource = "xsound",
        dispatch = {
            enabled = true,
            url = "https://cfx-nui-sky_jobs_base/source/html/assets/sky-dispatch_radio_end.ogg",
            volume = 0.35,
            radius = 12.0
        },
        panic = {
            enabled = true,
            url = "https://cfx-nui-sky_jobs_base/source/html/assets/sky-dispatch_radio_start.ogg",
            volume = 0.65,
            radius = 25.0
        }
    },

    -- ========================================================================
    -- 09 - Runtime intervals and rate limits
    -- ========================================================================
    -- Technical tuning. Suffixes indicate milliseconds (Ms) or seconds (Seconds).
    cleanupIntervalMs = 5000,
    chatRateLimitSeconds = 2,
    callActionRateLimitSeconds = 1,
    alarmRateLimitSeconds = 1,
    radioButtonRateLimitSeconds = 1,
    radioLogMinSeconds = 2,
    alarmAckTimeoutMs = 1500,
    positionUpdateMs = 4000
}

Config.EmergencyDispatch = {
    enabled = false,
    resource = "emergencydispatch",
    client = {
        enabled = true,
        fallbackCallsign = false,
        fallbackRadioOpen = false,
        fallbackIsManned = false,
        fallbackJobs = {}
    },
    server = {
        enabled = true,
        configuratorJobRefreshMs = 10000,
        fallbackMannedVehicles = {},
        fallbackMannedControl = {},
        fallbackVehicleTypes = {},
        dispatch = {
            enabled = true,
            -- sky_only: keep incidents in Sky only.
            -- mirror: keep Sky incidents and mirror them to EmergencyDispatch when available.
            -- emergencydispatch_only: use EmergencyDispatch while available, otherwise fall back to Sky.
            -- fallback: prefer EmergencyDispatch and use Sky only while it is unavailable.
            mode = "sky_only",
            useTitlePrefix = true,
            titleSeparator = ": "
        }
    },

}

Config.Cctv = {
    -- Optional camera-app allowlist. Use job keys for specific jobs (e.g. "fib"),
    -- or group keys for whole job groups (e.g. "police"). Leave nil to keep the
    -- default police/ambulance CCTV app access.
    allowedJobs = { "police", "ambulance", "fire", "doj" },
    requireBodycamItem = false,
    bodycamItem = "bodycam",
    -- Enabling it records the last Config.Cctv.recordBufferMinutes minutes and can noticeably increase client CPU usage.
    bodycamRecorderEnabled = true,
    -- Requested bitrate; the rolling recorder reduces it to fit the upload size limit.
    recordBitrateKbps = 1500,
    recordMaxSizeMb = 32, -- Match the media provider's maximum upload size (decimal MB).

    -- Optional per-job bodycam visibility. The key is the viewer job, the values
    -- are the jobs whose bodycams it can see. If a viewer job is not listed here,
    -- the default camera network applies: own job and jobs in the same job group.
    -- Example (replace lspd with your actual LSPD job key, e.g. police):
    -- bodycamViewJobs = {
    --     fbi = { "fbi", "lspd" }, -- FBI sees FBI + LSPD bodycams
    --     lspd = { "lspd" }        -- LSPD only sees its own bodycams
    -- }
    bodycamViewJobs = nil
}

Config.Chat = {
    -- Optional per-job chat visibility. The key is the viewer job, the values are
    -- the jobs whose members it may see and chat with. If a viewer job has no
    -- explicit rule, only its own job and jobs in the same job group are allowed.
    -- Set a rule to true to let that job see and chat with every registered job.
    -- Example:
    -- jobViewJobs = {
    --     fbi = { "fbi", "lspd" },
    --     lspd = { "lspd" }
    -- }
    jobViewJobs = nil,
    disabledGroups = { "crime" }
}

Config.DarkChat = {
    enabled = true,
    allowedGroups = { "crime", "police" },
    policeRequiredResource = "sky_crimesystem",
    usernameMinLength = 3,
    usernameMaxLength = 24
}

Config.HeliCam = {
    enabled = true,
    requireOnDuty = false,
    allowedJobs = { "police", "ambulance" },
    models = { "polmav" },
    minHeight = 1.5,
    maxLockDistance = 700.0,
    speedUnit = "Km/h",
    visionModes = {
        nightVision = true, -- Allow night vision when cycling camera modes.
        thermal = true -- Allow thermal vision; normal vision always remains available.
    },
    keys = {
        toggle_cam = 51,
        toggle_vision = 25,
        toggle_spotlight = 183,
        toggle_lock = 22,
        toggle_display = 44,
        rappel = 154,
        take_photo = 74,
        light_up = 246,
        light_down = 173,
        radius_up = 137,
        radius_down = 21
    },
    cam = {
        fovMin = 6.0,
        fovMax = 80.0,
        zoomSpeed = 3.0,
        zoomSmooth = 0.05,
        rotateSpeedX = 4.0,
        rotateSpeedZ = 4.0,
        minPitch = -89.5,
        maxPitch = 20.0
    },
    spotlight = {
        brightness = 1.0,
        radius = 4.0,
        minBrightness = 1.0,
        maxBrightness = 10.0,
        minRadius = 4.0,
        maxRadius = 10.0,
        distance = 800.0
    },
    capture = {
        cooldownMs = 1500,
        folder = "camera"
    }
}

Config.ManagementFinance = {
    historyDays = 14,
    maxTransactionAmount = 2000000000,
    dirtyMoney = {
        enabledForGangs = true,
        currency = "black_money"
    }
}

-- Payroll applies only to jobs registered through Sky_Jobs.RegisterJob.
-- enabled = false disables payroll globally. Override per registered job via Sky_Jobs.SetJobSalaryEnabled(jobKey, false).
Config.Salary = {
    enabled = true,
    deductFromSocietyFunds = true, -- When false, salaries are created without checking or charging faction funds.
    accountType = "bank", -- Currency/account used for payouts. Use "money" or "bank", or set `currency` for a custom sky_base currency.
    currency = nil, -- Optional custom currency key from sky_base/config/currency.lua. When set, this overrides accountType.
    payIntervalsWhileOnDuty = true,
    useGradeIntervals = true, -- False uses defaultIntervalMinutes for every rank; a job interval override takes priority.
    jobSocietyPayments = {}, -- Per-job override: true debits the society, false creates money. Native jobs require the framework paycheck hook.
    defaultIntervalMinutes = 30,
    minIntervalMinutes = 10,
    maxIntervalMinutes = 180
}

-- Set a flag to false to lock the value in the management menu (read-only; edit via database only).
-- Override per job via Sky_Jobs.SetJobManagementEditing(jobKey, { salary = false, ... }).
Config.ManagementEditing = {
    roleName = true,       -- grade/role display name
    salary = true,         -- salary amount per payout
    salaryInterval = true, -- payout interval minutes
    roleStructure = true   -- create / delete / reorder roles
}

Config.Invites = {
    expireSeconds = 60,
    maxDistance = 10.0 -- Maximum distance in meters between recruiter and candidate.
}

Config.JobPlayerInteractions = {
    groups = {
        police = {
            requireOnDuty = true,
            cuffs = true,
            zipties = true,
            legRestraints = true,
            escort = true,
            vehicle = true,
            headBag = true,
            search = true,
            identity = true,
            licenses = true,
        },
        crime = {
            requireOnDuty = false,
            cuffs = false,
            zipties = true,
            legRestraints = true,
            escort = true,
            vehicle = true,
            headBag = true,
            search = true,
            identity = true,
            licenses = true,
        },
    },
}

Config.PoliceCuffs = {
    enabled = true,
    requireItem = true,
    item = "handcuffs",
    consumeItem = true,
    returnOnRemove = true,
    maxDistance = 4.0,
    key = {
        enabled = false,
        item = "handcuffs_keys"
    },
    breakout = {
        -- Tools for freeing another player; no job permission is required.
        -- Uses the minigame difficulty below under escape, independently of its random opportunities.
        enabled = true,
        item = "restraint_tool",
        ziptiesItem = "", -- Empty uses item for both; set another item for zipties only.
        registerUsableItem = true, -- Disable when another script owns this item's use callback.
        consumeItem = false
    },
    zipties = {
        enabled = true,
        item = "zipties",
        requireItem = true,
        consumeItem = true,
        returnOnRemove = true,
        requireHandsUp = true,
        cutter = {
            enabled = true,
            item = "wire_cutter",
            consumeItem = false
        }
    },
    handsUp = {
        enabled = true, -- Sky's own hands-up key; external animation detection is configured separately below.
        key = "H",
        holdSeconds = 3
    },
    animationCheck = {
        enabled = true, -- Recognize external hands-up animations independently of Sky's own key.
        animations = {
            -- RPEmotes Reborn: /handsup, then /e handsup through /e handsup5.
            { dict = "random@mugging3", name = "handsup_standing_base" },
            { dict = "missminuteman_1ig_2", name = "handsup_base" },
            { dict = "anim@mp_player_intuppersurrender", name = "idle_a_fp" },
            { dict = "anim@mp_rollarcoaster", name = "hands_up_idle_a_player_one" },
            { dict = "anim@scripted@bty2@ig2_beat_target@male@", name = "leaning_idle_bounty" },
            { dict = "anim@scripted@bty2@ig2_beat_target@male@", name = "standing_idle_bounty" }
        }
    },
    escape = {
        -- Lower chance / higher delay and cooldown make opportunities rarer.
        enabled = true,
        chancePercent = 3.0,
        delayMinSeconds = 30,
        delayMaxSeconds = 120,
        cooldownSeconds = 900,
        -- More rounds, less time and more decoys make the minigame harder.
        rounds = 6,
        windowMs = 700,
        minimumInputMs = 125,
        latencyGraceMs = 175,
        decoyCount = 5,
        allowZipties = false,
        keyPool = { "W", "A", "S", "D", "Q", "E" }
    },
    anim = {
        dict = "mp_arresting",
        name = "idle",
        flag = 49
    }
}

-- Optional civilian access to the shared player-interaction runtime.
-- Enable this single switch to expose the actions through usable items, exports,
-- and the configured Sky target adapter (ox_target is detected automatically by sky_base).
Config.CivilianUse = {
    enabled = false,
    target = true,
    cuffs = true,
    zipties = true,
    legRestraints = true,
    escort = true,
    vehicle = true,
    headBag = true,
    search = true
}

Config.LegRestraints = {
    enabled = true,
    requireItem = false,
    item = "legcuffs",
    useItem = "radial", -- "radial", "inventory", or "both"
    maxDistance = 2.0,
    requireCuffed = true,
    animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
    animName = "machinic_loop_mechandplayer",
    applyDurationMs = 1600
}

Config.HeadBag = {
    enabled = true,
    requireItem = true,
    item = "headbag",
    useItem = "both",
    maxDistance = 2.0,
    requireRestrained = true,
    propModel = "prop_money_bag_01",
    selfRemoveCommand = "sky_jobs_base_headbag_remove_self",
    selfRemoveKey = "G",
    applyScenario = "CODE_HUMAN_MEDIC_KNEEL",
    applyDurationMs = 1200
}

Config.PoliceEscort = {
    enabled = true,
    maxDistance = 2.5,
    vehicleDistance = 4.0
}

-- Shared civilian carry command. This lives in sky_jobs_base so it works without
-- sky_ambulancejob and every installed job resource uses the same command owner.
Config.PlayerCarry = {
    enabled = true,
    command = "carry",             -- Command without the leading slash
    requireAcceptance = true,       -- Require conscious carried players to accept first
    requestTimeoutSeconds = 15,
    maxDistance = 2.5,
    allowConsciousTargets = true,  -- False limits the command to dead/downed players
    allowSprint = false,
    allowCarrierInVehicle = true,
    acceptKey = "E",
    declineKey = "X",
    carrierAnimation = {
        dict = "missfinale_c2mcs_1",
        name = "fin_c2_mcs_1_camman",
        flag = 49
    },
    passengerAnimation = {
        dict = "nm",
        name = "firemans_carry",
        flag = 33
    },
    attachBone = 0,
    attachOffsets = {
        x = 0.27,
        y = 0.0,
        z = 0.63,
        pitch = 0.5,
        roll = 0.5,
        yaw = 180.0
    }
}

Config.PlayerSearch = {
    enabled = true,
    showTargetName = false, -- Show the searched player's name below the inventory title.
    combineWeapons = true, -- Show searched items and weapons together. Set false to use separate tabs.
    range = 2.0,
    durationMs = 8000, -- Search preview duration before the inventory opens, in milliseconds.
    animDict = "anim@gangops@morgue@table@",
    animName = "player_search",
    animFlag = 49,
    scenario = "CODE_HUMAN_POLICE_INVESTIGATE" -- Used when animDict or animName is empty; a complete animation takes priority.
}

-- Interaction NPC options (all optional):
--   pedHash  = "s_m_m_doctor_01"          -- model name or joaat hash
--   heading  = 0.0                        -- facing direction
--   scenario = "WORLD_HUMAN_CLIPBOARD"    -- GTA scenario to play on spawn (e.g. CODE_HUMAN_MEDIC_KNEEL, WORLD_HUMAN_AA_COFFEE)
--   onSpawn  = function(ped)              -- runs once after ped is created (outfits, weapons, props, extra tasks)
--       SetPedArmour(ped, 100)
--       GiveWeaponToPed(ped, `WEAPON_NIGHTSTICK`, 1, false, true)
--   end
-- Shared job bells. Place individual bells in /jobconfig -> [resource] -> [job] -> Bells.
-- Shared business/authority announcements. Per-job access and appearance: /jobconfig > job > Business.
Config.Business = {
    enabled = true,
    durationSeconds = 8,
    cooldownSeconds = 300,
    position = "top-center", -- top-left / top-center / top-right
    maxPending = 3,
    announceExclusionZones = true,
    discord = {
        publicEnabled = false, -- Public announcements; webhook URL in server-only config/webhooks.lua.
        adminEnabled = false, -- Detailed administrator log; use a separate private channel.
    },
}

Config.Bells = {
    enabled = true,
    keyMappings = { accept = "Y", dismiss = "RETURN" }, -- Personal FiveM bindings are preserved.
    requestCooldown = 30, -- Seconds between staff requests for the same job, across all its bells.
    -- Add local files under config/sounds/bells/custom/. The manifest packages this folder.
    -- { id = "my_bell", label = "My bell", file = "config/sounds/bells/custom/my_bell.ogg", duration = 2.0 },
    customSounds = {},
}

-- Defaults for the common supply-delivery runtime. Job-specific delivery mode
-- and ETA are configured in that job's Online shop settings.
Config.OnlineShopDelivery = {
    allowsprint = true,
    openDurationMs = 5500,
    interactionDistance = 2.0,
    boxModel = "prop_cs_cardbox_01",
    carryItems = {
        enabled = true,
        storageDistance = 2.5,
        forkliftModels = { "forklift" },
        items = {},
        deliveryPallet = { enabled = true, prop = "prop_boxpile_02c" },
    },
}

Config.Interactions = {
    job_garage = {
        duty = true,
        unique = false,
        object = { enabled = false, model = "", pitch = 0.0, roll = 0.0, heading = 0.0, offset = vector3(0.0, 0.0, 0.0) },
        marker = {
            enabled = true,
            type = 1,
            offset = vector3(0.0, 0.0, 0.0)
        },
        blip = {
            enabled = false,
            name = "JobGarage",
            sprite = 1,
            color = 5
        },
        npc = {
            enabled = false,
            pedHash = "a_f_y_business_01",
            heading = 0.0
        }
    },
    garage_vehicle_spawn = {
        duty = true,
        unique = false,
        requiresHeading = true,
        interaction = false,
        object = { enabled = false, model = "", pitch = 0.0, roll = 0.0, heading = 0.0, offset = vector3(0.0, 0.0, 0.0) },
        marker = {
            enabled = false
        },
        blip = {
            enabled = false
        },
        npc = {
            enabled = false
        }
    },
    garage_vehicle_park = {
        duty = true,
        unique = false,
        object = { enabled = false, model = "", pitch = 0.0, roll = 0.0, heading = 0.0, offset = vector3(0.0, 0.0, 0.0) },
        marker = {
            enabled = true,
            type = 1,
            offset = vector3(0.0, 0.0, 0.0)
        },
        blip = {
            enabled = false
        },
        npc = {
            enabled = false
        }
    },
    garage_helicopter_menu = {
        duty = true,
        unique = false,
        labelKey = "locationCreator.markers.garage_helicopter_menu",
        addLabelKey = "locationCreator.actions.add.garage_helicopter_menu",
        object = { enabled = false, model = "", pitch = 0.0, roll = 0.0, heading = 0.0, offset = vector3(0.0, 0.0, 0.0) },
        marker = {
            enabled = true,
            type = 1,
            offset = vector3(0.0, 0.0, 0.0)
        },
        blip = {
            enabled = false,
            name = "Helipad",
            sprite = 1,
            color = 5
        },
        npc = {
            enabled = false,
            pedHash = "a_f_y_business_01",
            heading = 0.0
        }
    },
    garage_helicopter_spawn = {
        duty = true,
        unique = false,
        requiresHeading = true,
        interaction = false,
        labelKey = "locationCreator.markers.garage_helicopter_spawn",
        addLabelKey = "locationCreator.actions.add.garage_helicopter_spawn",
        object = { enabled = false, model = "", pitch = 0.0, roll = 0.0, heading = 0.0, offset = vector3(0.0, 0.0, 0.0) },
        marker = {
            enabled = false
        },
        blip = {
            enabled = false
        },
        npc = {
            enabled = false
        }
    },
    garage_helicopter_park = {
        duty = true,
        unique = false,
        labelKey = "locationCreator.markers.garage_helicopter_park",
        addLabelKey = "locationCreator.actions.add.garage_helicopter_park",
        object = { enabled = false, model = "", pitch = 0.0, roll = 0.0, heading = 0.0, offset = vector3(0.0, 0.0, 0.0) },
        marker = {
            enabled = true,
            type = 1,
            offset = vector3(0.0, 0.0, 0.0)
        },
        blip = {
            enabled = false
        },
        npc = {
            enabled = false
        }
    },
    garage_boat_menu = {
        duty = true,
        unique = false,
        labelKey = "locationCreator.markers.garage_boat_menu",
        addLabelKey = "locationCreator.actions.add.garage_boat_menu",
        object = { enabled = false, model = "", pitch = 0.0, roll = 0.0, heading = 0.0, offset = vector3(0.0, 0.0, 0.0) },
        marker = {
            enabled = true,
            type = 1,
            offset = vector3(0.0, 0.0, 0.0)
        },
        blip = {
            enabled = false,
            name = "Dock",
            sprite = 1,
            color = 5
        },
        npc = {
            enabled = false,
            pedHash = "a_f_y_business_01",
            heading = 0.0
        }
    },
    garage_boat_spawn = {
        duty = true,
        unique = false,
        requiresHeading = true,
        interaction = false,
        labelKey = "locationCreator.markers.garage_boat_spawn",
        addLabelKey = "locationCreator.actions.add.garage_boat_spawn",
        object = { enabled = false, model = "", pitch = 0.0, roll = 0.0, heading = 0.0, offset = vector3(0.0, 0.0, 0.0) },
        marker = {
            enabled = false
        },
        blip = {
            enabled = false
        },
        npc = {
            enabled = false
        }
    },
    garage_boat_park = {
        duty = true,
        unique = false,
        labelKey = "locationCreator.markers.garage_boat_park",
        addLabelKey = "locationCreator.actions.add.garage_boat_park",
        object = { enabled = false, model = "", pitch = 0.0, roll = 0.0, heading = 0.0, offset = vector3(0.0, 0.0, 0.0) },
        marker = {
            enabled = true,
            type = 1,
            offset = vector3(0.0, 0.0, 0.0)
        },
        blip = {
            enabled = false
        },
        npc = {
            enabled = false
        }
    },
    boss_menu = {
        unique = false,
        duty = true,
        object = { enabled = false, model = "", pitch = 0.0, roll = 0.0, heading = 0.0, offset = vector3(0.0, 0.0, 0.0) },
        marker = {
            enabled = true,
            type = 1,
            offset = vector3(0.0, 0.0, 0.0)
        },
        blip = {
            enabled = false,
            name = "Boss Menu",
            sprite = 487,
            color = 46
        },
        npc = {
            enabled = false,
            pedHash = "s_m_m_doctor_01",
            heading = 0.0
        }
    },
    duty_terminal = {
        unique = false,
        duty = false,
        -- interactionDistance = 2.0, -- optional: target / interaction range
        -- drawDistance = 25.0, -- optional: visual marker draw range; lower values keep the default buffer
        -- markerSize = 1.2, -- optional: visual marker size only
        object = { enabled = false, model = "", pitch = 0.0, roll = 0.0, heading = 0.0, offset = vector3(0.0, 0.0, 0.0) },
        marker = {
            enabled = true,
            type = 1,
            offset = vector3(0.0, 0.0, 0.0)
        },
        blip = {
            enabled = false,
            name = "Duty Terminal",
            sprite = 351,
            color = 3
        },
        npc = {
            enabled = false,
            pedHash = "s_m_m_paramedic_01",
            heading = 0.0
        }
    },
    wardrobe = {
        unique = false,
        duty = true,
        object = { enabled = false, model = "", pitch = 0.0, roll = 0.0, heading = 0.0, offset = vector3(0.0, 0.0, 0.0) },
        marker = {
            enabled = true,
            type = 1,
            offset = vector3(0.0, 0.0, 0.0)
        },
        blip = {
            enabled = false,
            name = "Wardrobe",
            sprite = 73,
            color = 5
        },
        npc = {
            enabled = false,
            pedHash = "a_m_m_business_01",
            heading = 0.0
        }
    },
    storage = {
        unique = false, -- Multiple access points in one station open the same storage.
        duty = true,
        object = { enabled = false, model = "", pitch = 0.0, roll = 0.0, heading = 0.0, offset = vector3(0.0, 0.0, 0.0) },
        marker = {
            enabled = true,
            type = 1,
            offset = vector3(0.0, 0.0, 0.0)
        },
        blip = {
            enabled = false,
            name = "Storage",
            sprite = 52,
            color = 2
        },
        npc = {
            enabled = false,
            pedHash = "a_m_y_business_03",
            heading = 0.0
        }
    },
    locker = {
        unique = false,
        duty = true,
        object = { enabled = false, model = "", pitch = 0.0, roll = 0.0, heading = 0.0, offset = vector3(0.0, 0.0, 0.0) },
        marker = {
            enabled = true,
            type = 1,
            offset = vector3(0.0, 0.0, 0.0)
        },
        blip = {
            enabled = false,
            name = "Locker",
            sprite = 354,
            color = 5
        },
        npc = {
            enabled = false,
            pedHash = "a_f_y_business_01",
            heading = 0.0
        }
    },
    wholesale_shop = {
        unique = false, -- Multiple points use the same job catalogue.
        duty = true,
        object = { enabled = false, model = "", pitch = 0.0, roll = 0.0, heading = 0.0, offset = vector3(0.0, 0.0, 0.0) },
        marker = {
            enabled = true,
            type = 1,
            offset = vector3(0.0, 0.0, 0.0)
        },
        blip = {
            enabled = false,
            name = "Wholesale Supplier",
            sprite = 614,
            color = 46
        },
        npc = {
            enabled = false,
            pedHash = "s_m_m_paramedic_01",
            heading = 0.0
        }
    },
    public_forms = {
        unique = false,
        duty = false,
        public = true,
        object = { enabled = false, model = "", pitch = 0.0, roll = 0.0, heading = 0.0, offset = vector3(0.0, 0.0, 0.0) },
        marker = {
            enabled = true,
            type = 1,
            offset = vector3(0.0, 0.0, 0.0)
        },
        blip = {
            enabled = false,
            name = "Public Forms",
            sprite = 58,
            color = 3
        },
        npc = {
            enabled = false
        }
    }
}

Config.StationBlip = {
    enabled = true,
    name = "Station",
    useStationName = true,
    useBlipPrefix = true,
    sprite = 280,
    color = 3,
    scale = 0.9,
    display = 4,
    shortRange = true
}

Config.Cloakroom = {
    -- auto: use built-in detection (rcore, custom hook, 17movement, qs-appearance, ak47-clothing, ak47-qb-clothing, tgiann-clothing, nf-skin, bl-appearance, izzy-appearance, codem-appearance, hex-clothing, op-clothing, illenium, qb-clothing, ESX skinchanger/esx_skin)
    -- sky: force the Sky ESX wardrobe editor (requires esx_skin + skinchanger)
    -- rcore: force rcore_clothing job changing room
    -- qb-clothing: force qb-clothing outfit menu
    -- 17movement: force 17mov_CharacterSystem outfit menu
    -- qs-appearance: force qs-appearance outfit menu
    -- ak47-clothing: force ak47_clothing outfit menu
    -- ak47-qb-clothing: force ak47_qb_clothing outfit menu
    -- tgiann-clothing: force tgiann-clothing wardrobe menu
    -- nf-skin: force nf-skin outfit menu
    -- bl-appearance: force bl_appearance outfit menu
    -- izzy-appearance: force izzy-appearance clothing menu
    -- codem-appearance: force codem-appearance wardrobe menu
    -- hex-clothing: force hex_clothing outfit menu
    -- op-clothing: force op-clothing job locker menu
    -- illenium: force illenium-appearance outfit menu
    -- custom: force the custom hook below
    -- disabled: disable wardrobe interactions
    backend = "auto",

    custom = {
        -- Optional resource name. If set, the wardrobe is only available when this resource is started.
        resource = nil,

        -- Optional availability hook. Return true when your clothing system can handle the wardrobe.
        -- isAvailable = function(context)
        --     return GetResourceState("my_clothing") == "started"
        -- end,

        -- Optional open hook. Return false to tell sky_jobs_base the open call failed.
        -- open = function(context)
        --     TriggerEvent("my_clothing:client:openOutfits", context)
        --     return true
        -- end,
    },

    editableComponents = {
        "mask_1",
        "mask_2",
        "arms",
        "arms_2",
        "torso_1",
        "torso_2",
        "tshirt_1",
        "tshirt_2",
        "pants_1",
        "pants_2",
        "shoes_1",
        "shoes_2",
        "bags_1",
        "bags_2",
        "decals_1",
        "decals_2",
        "chain_1",
        "chain_2",
        "helmet_1",
        "helmet_2",
        "glasses_1",
        "glasses_2",
        "bracelets_1",
        "bracelets_2",
        "watches_1",
        "watches_2",
        "bproof_1",
        "bproof_2",
        "ears_1",
        "ears_2"
    }
}

-- ============================================================================
-- Job vehicle entries
-- Each job defines its purchasable vehicles in its own Config.Jobs[*].vehicles
-- list (e.g. sky_ambulancejob/config/config.lua), not here. Every entry supports:
--   name              (string)  Display name in the garage menu. Required.
--   model             (string)  Spawn model name. Required.
--   price             (number)  Purchase price, >= 0. Required.
--   garageType        (string)  "vehicle" | "helicopter" | "boat". Default "vehicle".
--   trunkCapacity     (number)  Trunk weight capacity. Falls back to defaultTrunkCapacity.
--   trunkEnabled      (boolean) false disables the trunk entirely. Default true.
--   props / propCounts          Vehicle prop catalog and optional limits for Radial > Vehicle interactions.
--   hasStretcher      (boolean) Ambulance only: false hides the stretcher action.
--   livery            (number)  Livery index applied on spawn.
--   extras            (table)   Vehicle extras, e.g. { [1] = true, [3] = false }.
--   fuelType          (string)  lc_fuel fuel type: "regular" | "plus" | "premium" | "diesel".
--   primaryColor      (number)  Primary paint index (0-160).
--   secondaryColor    (number)  Secondary paint index (0-160).
--   pearlescentColor  (number)  Pearlescent paint index.
--   wheelColor        (number)  Wheel paint index.
--   properties        (table)   Raw vehicle-properties passthrough for anything else
--                               (customPrimaryColor = { r, g, b }, windowTint, neonColor,
--                               modEngine, plateIndex, ...). The named color fields above
--                               override matching keys set here.
-- Colors and `properties` apply only to freshly bought vehicles; once a player
-- repaints a vehicle and parks it, its stored customization is kept.
-- ============================================================================
Config.JobGarage = {
    parkRadius = 4.0,
    parkKey = 38,
    -- Start the selected provider before sky_jobs_base so parked vehicles can be reconciled during startup.
    persistenceProvider = "auto", -- "auto", "advancedparking", "cd_garage", or "none". Auto selects one started provider, uses native mode with none, and rejects both.
    deleteVehicleOnPlayerDropped = false, -- Only applies without a persistence provider. Keep the OneSync vehicle after its original garage user disconnects.
    destroyedVehicleRecovery = { enabled = true, repairPrice = 5000 }, -- Defaults; override per job in /jobconfig > General. 0 repairs for free.
    ownershipMode = "shared", -- "shared", "personal", or "personal_transferable".
    paymentSource = "job", -- "job" uses faction funds; "personal" uses the buyer's account.
    personalPaymentAccount = "bank", -- Framework account used when paymentSource = "personal".
    allowPlateChange = true, -- Set to false to disable license plate changes in the garage menu.
    vehicleRemovalMode = "sell", -- "disabled", "remove" (no refund), or "sell" (refund configured below).
    allowAllEmployeesToRemove = false, -- Shared vehicles: true allows every on-duty employee; false requires SELL_VEHICLES.
    sellPercentage = 50, -- Default percentage of the stored purchase price returned in "sell" mode (1-100; 0 makes sales unavailable).
    warpIntoVehicle = false, -- Set to true to put the player directly into the spawned garage vehicle.
    spawnBlockRadius = 3.0,
    maxSpawnFallbackDistance = 100.0,
    defaultTrunkCapacity = 40,
    trunk = {
        interactDistance = 5.0, -- Max distance from the vehicle rear to open the trunk via the "Open trunk" radial (G) action.
        distanceTolerance = 1.5,
        propStreamDistance = 150.0, -- Placed world props are spawned locally only within this range.
        propStreamDespawnBuffer = 25.0, -- Extra distance before an already streamed prop is despawned.
        propRemoveEnabled = true, -- Show a keypress prompt next to placed props to remove them (the radial action stays available).
        propRemoveKey = 38, -- Control id for the prop removal keypress.
        propRemoveKeyLabel = "E", -- Key label shown in the removal prompt.
        propRemoveDistance = 2.2, -- Max distance for keypress/radial prop removal.
    }
}

Config.PropPlacement = {
    -- Item job_access accepts exact jobs/job groups and "gang:<name>" selectors for QB/Qbox gangs
    -- or independent organizations. Gang matches do not require job duty; publicAccess bypasses the lists.
    enabled = true, -- Set true to allow placing configured job props from usable inventory items.
    vehicleAccess = true, -- Enable vehicle prop selection through Radial > Vehicle interactions.
    vehicleCollectDistance = 30.0, -- Collect this vehicle's placed props within this radius (metres, 1-200).
    requireOnDuty = true,
    consumeItem = true,
    returnItemOnRemove = true, -- Give the consumed item back when the placed prop is removed (only for props placed from an item).
    persistPlacedProps = false, -- Keep newly placed world props across resource/server restarts until they are removed.
    items = {
        {
            model = "prop_roadcone02a",
            item_name = "job_traffic_cone",
            job_access = { "police", "ambulance" },
            publicAccess = false
        },
        {
            model = "prop_barrier_work05",
            item_name = "police_barrier",
            job_access = { "police" },
            publicAccess = false
        },
        {
            model = "prop_barrier_work06a",
            item_name = "police_road_barrier",
            job_access = { "police" },
            publicAccess = false
        },
        {
            model = "ch_prop_ch_fib_01a",
            item_name = "police_evidence_marker",
            job_access = { "police" },
            publicAccess = false
        },
        {
            model = "p_ld_stinger_s",
            item_name = "police_stinger_spikes",
            job_access = { "police" },
            publicAccess = false
        },
        {
            model = "v_31a_worklight_03b",
            item_name = "job_worklight_stand",
            job_access = { "police", "ambulance" },
            publicAccess = false
        },
        {
            model = "prop_worklight_02a",
            item_name = "job_worklight",
            job_access = { "police", "ambulance" },
            publicAccess = false
        },
        {
            model = "prop_gazebo_03",
            item_name = "police_checkpoint_tent",
            job_access = { "police" },
            publicAccess = false
        },
        {
            model = "prop_mp_barrier_02b",
            item_name = "ambulance_barrier",
            job_access = { "ambulance" },
            publicAccess = false
        },
        {
            model = "xm_prop_smug_crate_s_medical",
            item_name = "ambulance_medical_crate",
            job_access = { "ambulance" },
            publicAccess = false
        },
        {
            model = "v_med_oscillator3",
            item_name = "ambulance_defibrillator",
            job_access = { "ambulance" },
            publicAccess = false
        },
        {
            model = "xm_prop_x17_bag_med_01a",
            item_name = "ambulance_medical_bag",
            job_access = { "ambulance" },
            publicAccess = false
        }
    }
}

Config.WholesaleShop = {
    -- Purchases grant inventory items immediately by default. Set true only when
    -- an external resource handles payment and delivery through the order events/exports.
    externalOrders = false
}

Config.Storage = {
    storageCapacity = 1000, -- Default shared storage capacity for jobs without Config.Jobs[*].storage (<= 0 for unlimited)
    lockerCapacity = 10     -- Default personal locker capacity for jobs without Config.Jobs[*].storage (<= 0 for unlimited)
}

-- Shared identity-card presentation. Editable artwork and styles: config/documents/.
Config.PlayerIdentityCard = {
    enabled = true, -- Sky identity, license and service document actions/exports.
    serviceEnabled = true, -- Disable only employment service cards while keeping identity/licenses.
    position = "right", -- left, center, right, or custom
    x = 75, -- Card centre as a percentage of screen width; used for custom placement.
    y = 50, -- Card centre as a percentage of screen height; used for custom placement.
    scale = 85, -- Percentage of the template's original size.
    issuer = "", -- Optional issuer name; empty hides it.
    logo = "", -- Optional filename inside config/documents, for example logo.svg.
    licenseTypes = { "dmv", "drive", "drive_bike", "drive_truck", "driver", "weapon", "business" }, -- Visible license types on Sky's card. Use { "*" } to show all held licenses.
    serviceCards = { -- Exact job takes priority over *. Local logo filenames live in config/documents/.
        { job = "police", template = "official", background = "matte", color = "#3177b7", logo = "", title = "", prefix = "PD", format = "{prefix}-{number}", digits = 3 },
        { job = "ambulance", template = "medical", background = "matte", color = "#bf465b", logo = "", title = "", prefix = "EMS", format = "{prefix}-{number}", digits = 3 },
        { job = "mechanic", template = "compact", background = "matte", color = "#a36a24", logo = "", title = "", prefix = "MECH", format = "{prefix}-{number}", digits = 3 },
        { job = "fire", template = "official", background = "matte", color = "#b84732", logo = "", title = "", prefix = "FD", format = "{prefix}-{number}", digits = 3 },
        { job = "doj", template = "official", background = "matte", color = "#775487", logo = "", title = "", prefix = "DOJ", format = "{prefix}-{number}", digits = 3 },
        { job = "*", template = "official", background = "matte", color = "#3e6770", logo = "", title = "", prefix = "", format = "{prefix}-{number}", digits = 3 }
    }
}

Config.JobRadial = {
    enabled = true, -- Controls Sky's radial UI. Set false for an external radial using getExternalRadialActions / triggerExternalRadialMenuAction, or use ox_target / qb-target. Exports and direct action keybinds remain available. Tablet access through a target system uses the tablet item's usable-item flow.
    key = "g",
    mode = "toggle", -- "hold" (hold key, release to select) or "toggle" (press to open/close)
    logo = "", -- Radial centre logo: HTTPS image URL or path relative to source/html. Empty hides it; "logo.svg" uses the shipped Sky logo.
    deadzone = 0.25, -- only used in "hold" mode (stick/mouse deadzone for directional selection)
    submenuOpenDelayMs = 350, -- Hold mode only: time a submenu direction must stay selected before that level opens.
    keybinds = {
        enabled = true, -- Shared direct keybinds for every authorized job group, including police and crime.
        dispatch_radio_operate = {
            enabled = true,
            command = "sky_jobs_dispatch_radio",
            key = "", -- Unbound by default. Server owners can set a default, e.g. "F11"; players can rebind it in FiveM.
            description = "Jobs: Operate radio"
        },
        handcuff = {
            enabled = true,
            command = "sky_jobs_handcuff",
            key = "Z",
            description = "Jobs: Toggle handcuffs on nearest person"
        },
        crime_ziptie = {
            enabled = true,
            command = "sky_jobs_ziptie",
            key = "Z",
            description = "Jobs: Toggle zipties on nearest person"
        },
        escort = {
            enabled = true,
            command = "sky_jobs_escort",
            key = "6",
            description = "Jobs: Escort or release nearest person"
        },
        escort_vehicle = {
            enabled = true,
            command = "sky_jobs_escort_vehicle",
            key = "7",
            description = "Jobs: Place escorted person in vehicle"
        },
        escort_take_out = {
            enabled = true,
            command = "sky_jobs_escort_take_out",
            key = "8",
            description = "Jobs: Remove restrained person from vehicle"
        }
    },
    providers = {
        -- Add only custom providers that cannot self-register through registerRadialProvider.
    },
    targetContext = {
        enabled = true, -- Resolve camera targets for Sky's radial and the external radial API. Disable this to keep these menus context-free; ox_target selections still supply their own context.
        maxDistance = 3.0,
        playerToleranceRadius = 1.1, -- Accept nearby players within this radius of the look line without requiring an exact body hit.
        playerToleranceAngleDegrees = 24.0, -- Allow a natural camera angle while still requiring the person to be in front of the look direction.
        playerToleranceCloseRangeSlack = 0.45, -- Allows very close players (for example right after dropping a carry target) to still count even if their body is slightly behind the exact ray origin.
        marker = {
            enabled = true, -- Draw a marker under the looked-at player while the normal G radial is open.
            type = 2,
            attachTo = "head", -- "head" or "feet"
            scaleX = 0.2,
            scaleY = 0.2,
            scaleZ = 0.12,
            offsetZ = 0.40,
            red = 90,
            green = 190,
            blue = 255,
            alpha = 160,
            bobUpAndDown = true,
            faceCamera = false,
            rotate = false
        }
    },
    oxTarget = {
        enabled = true -- Registers non-tablet job radial actions as target actions so they can be used without opening the radial menu. Requires sky_base Config.target = "ox" or "qb" (or "auto" with the matching resource started). Tablet access stays on the tablet item's usable-item flow.
    }
}

Config.Panic = {
    enabled = true,
    -- Exact job keys allowed to use/see panic. Add custom service jobs explicitly; nil or {} denies access.
    allowedJobs = { "police", "ambulance", "fire" },
    -- Optional per-sender visibility groups. The key is the job that triggers
    -- the panic, the values are the jobs that receive it. If a sender job is
    -- not listed here, the default own-job + notifyJobs behavior applies.
    -- groups = {
    --     police = { "police", "sheriff", "fib" }
    -- },
    groups = nil,
    requireItem = false, -- If true, the player must carry item to trigger panic.
    item = "gps",
    useKeybind = true, -- Set to false to stop registering the panic keybind.
    keyMapping = "K", -- FiveM default key; personal bindings remain in the player's settings.
    useRadial = false, -- Set to true to show the panic button in the job radial menu.
    requireOnDuty = true,
    cooldownSeconds = 45,
    alertDurationSeconds = 120,
    notifyOffDuty = false,
    showSelf = true,
    notifyJobs = {
        -- "ambulance"
    },
    blip = {
        sprite = 161,
        color = 1,
        scale = 1.05,
        flashing = true,
        flashInterval = 850,
        shortRange = false,
        radius = 80.0,
        radiusColor = 1,
        radiusAlpha = 95
    }
}

Config.Ping = {
    enabled = true,
    keyMapping = "L", -- FiveM default key; personal bindings remain in the player's settings.
    -- Optional per-sender visibility groups. The key is the job that sends the
    -- ping, the values are the jobs that receive it. If a sender job is not
    -- listed here, the default own-job + notifyJobs behavior applies.
    -- groups = {
    --     police = { "police", "sheriff", "fib" }
    -- },
    groups = nil,
    requireItem = false, -- If true, the player must carry item to send a ping.
    item = "gps",
    requireOnDuty = true,
    cooldownSeconds = 8,
    alertDurationSeconds = 30,
    notifyOffDuty = false,
    showSelf = true,
    notifyJobs = {
        -- "ambulance"
    },
    blip = {
        sprite = 280,
        color = 3,
        scale = 0.95,
        flashing = false,
        shortRange = false,
        radius = 60.0,
        radiusColor = 3,
        radiusAlpha = 80
    }
}

Config.IncidentNotification = {
    durationMs = 30000,
    -- FiveM default keys. Existing personal bindings are not overwritten.
    keyMappings = {
        acceptDispatch = "J", -- Accept the displayed dispatch or the unit's pending radio assignment.
        setWaypoint = "G",
        openMap = "", -- Unbound by default; players can assign it in FiveM settings.
        dismiss = "BACK"
    }
}
