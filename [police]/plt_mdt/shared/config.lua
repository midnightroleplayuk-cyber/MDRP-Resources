Config = {}

Config.Departments = {
    ['police'] = {
        label = 'LSPD',
        theme = 'theme-police',
        icon = 'fa-shield-halved',
        color = '#63A6C0' -- Tactical Blue
    },
    ['ambulance'] = {
        label = 'EMS',
        theme = 'theme-ems',
        icon = 'fa-heart-pulse',
        color = '#e91e63' -- EMS Pink/Red
    },
    ['sasp'] = {
        label = 'SASP',
        theme = 'theme-police',
        icon = 'fa-building-shield',
        color = '#455a64' -- Slate Gray
    },
    ['ranger'] = {
        label = 'PARK RANGER',
        theme = 'theme-sheriff',
        icon = 'fa-tree',
        color = '#2e7d32' -- Forest Green
    }
}

Config.DefaultDepartment = {
    label = 'Police MDT',
    theme = 'theme-police',
    icon = 'fa-shield-halved',
    color = '#63A6C0'
}

-- MDT access by department and category.
-- Access values for each category:
-- "write" = can view and create/edit/delete/update in that category
-- "read"  = can view/search only
-- "none"  = cannot view that category
Config.MDTAccess = {
    enabled = true,
    default = "none",
    categories = {
        "dashboard",
        "citizens",
        "vehicles",
        "incidents",
        "warrants",
        "charges",
        "dispatch",
        "officers"
    },
    byJob = {
        police = {
            dashboard = "write",
            citizens = "write",
            vehicles = "write",
            incidents = "write",
            warrants = "write",
            charges = "read",
            dispatch = "write",
            officers = "write"
        },
        sheriff = {
            dashboard = "write",
            citizens = "write",
            vehicles = "write",
            incidents = "write",
            warrants = "write",
            charges = "write",
            dispatch = "write",
            officers = "write"
        },
        fib = {
            dashboard = "write",
            citizens = "write",
            vehicles = "write",
            incidents = "write",
            warrants = "write",
            charges = "write",
            dispatch = "write",
            officers = "write"
        },
        ambulance = {
            dashboard = "write",
            citizens = "write",
            vehicles = "write",
            incidents = "write",
            warrants = "write",
            charges = "write",
            dispatch = "write",
            officers = "write"
        },
        sasp = {
            dashboard = "write",
            citizens = "write",
            vehicles = "write",
            incidents = "write",
            warrants = "write",
            charges = "write",
            dispatch = "write",
            officers = "write"
        },
        ranger = {
            dashboard = "write",
            citizens = "write",
            vehicles = "write",
            incidents = "write",
            warrants = "write",
            charges = "write",
            dispatch = "write",
            officers = "write"
        }
    }
}

Config.AvatarWebhook = "https://discordapp.com/api/webhooks/1460262542189400176/lrUEjQechFK_ZS-HbcKbdIqVNYpf6qSu_6-YINPseJu_514cam99TjkRzf-vL5tuIYdM" -- Replace this with your actual webhook URL
Config.WarrantSyncDelay = 1500 -- Increased even more to troubleshoot the "snapback" issue

-- Internal Jail System Settings
-- Jail mode:
-- "default" = keep existing MDT behavior (internal DB jail if UseInternalJailSystem=true, otherwise framework jail)
-- "rcore"   = use rcore_prison commands for jail/unjail
-- "tk_jail" = use tk_jail exports
Config.JailMode = "default"

Config.UseInternalJailSystem = true -- If true, the MDT will handle jailing and release independently
Config.JailLocation = { x = 1677.2, y = 2509.7, z = 45.5, h = 0.0 } -- Coordinates where players are sent (Bolingbroke)
Config.TeleportBackOnRelease = true -- If true, players are sent back to their arrest location after jail
Config.JailRelease = {
    mode = "origin", -- "origin" = return to stored arrest location, "custom" = use customLocation below
    customLocation = { x = 1847.3, y = 2586.1, z = 45.7, h = 180.0 } -- Used when mode is "custom"
}

-- Jail Task Settings
Config.EnableJailTasks = true -- If true, players can do tasks in jail to reduce time
Config.JailTaskReduction = 1 -- Number of months reduced per task completed
Config.JailTaskCooldown = 30000 -- Cooldown between tasks in milliseconds (30 seconds)
Config.JailTaskLocations = {
    { x = 1691.5, y = 2565.8, z = 45.5, label = "Clean Trash", type = "trash" },
    { x = 1661.2, y = 2504.1, z = 45.5, label = "Do Pushups", type = "pushups" },
    { x = 1610.1, y = 2515.2, z = 45.5, label = "Sweep Yard", type = "sweep" },
    { x = 1645.5, y = 2488.2, z = 45.5, label = "Clean Trash", type = "trash" },
    { x = 1761.5, y = 2485.8, z = 45.7, label = "Do Pushups", type = "pushups" }
}

-- Dispatch Configuration
Config.EnableDispatch = true -- Set to false to completely disable the Dispatch system and hide its tab
-- Set this to true if you want to use plt_departments for dispatch calls.
-- Set this to false if you want the MDT to handle dispatch calls independently.
Config.UseExternalDispatch = false 
Config.EnableDispatchLiveNotifications = false -- True: show top-right live dispatch popup, False: disable it

-- Dispatcher Assignment Control
-- This only controls who can assign/manage units on Dispatch alerts.
-- It does NOT block opening/reading the Dispatch page.
Config.DispatchAccess = {
    enabled = true,
    defaultAllow = true,
    byJob = {
        police = { minGrade = 3 },
        sheriff = { minGrade = 3 },
        sasp = { minGrade = 2 },
        fib = { minGrade = 1 },
        ambulance = { minGrade = 3 },
        ranger = { minGrade = 2 }
    },
    identifiers = {
        -- ["license:xxxxxxxxxxxxxxxx"] = true,
        -- ["steam:xxxxxxxxxxxxxxxx"] = true,
        -- ["discord:xxxxxxxxxxxxxxxx"] = true
    },
    citizenids = {
        -- ["ABCD1234"] = true
    }
}

-- Independent Dispatch Settings
Config.EnableAutomaticGunshots = true -- If true, the MDT will detect gunshots automatically
Config.ReportEmergencyGunshots = true -- If true, police/ems/fib/etc gunshots are also reported
Config.ExcludeJobsFromGunshots = { -- Jobs that won't trigger gunshot alerts (Police, etc.)
    ['police'] = true,
    ['sheriff'] = true,
    ['fib'] = true,
    ['sasp'] = true,
    ['ranger'] = true
}
Config.GunshotAlert = {
    code = '10-71',
    title = 'Shots Fired',
    info = 'Gunshots detected in the area. Automatic acoustic sensor report.'
}
Config.IgnoredShotWeapons = {
    "WEAPON_UNARMED",
    "WEAPON_STUNGUN",
    "WEAPON_FLAREGUN",
}

-- Panic / Quick Dispatch Settings
Config.PanicAlerts = {
    { code = "Code 0", title = "OFFICER DISTRESS", color = "#ff3e3e", icon = "fa-triangle-exclamation" },
    { code = "Grade 1", title = "SHOTS FIRED", color = "#ff9800", icon = "fa-gun" },
    { code = "Code 0", title = "OFFICER DOWN", color = "#ff3e3e", icon = "fa-user-injured" },
    { code = "Grade 1", title = "PURSUIT IN PROGRESS", color = "#3498db", icon = "fa-car-side" },
    { code = "Grade 1", title = "ROBBERY IN PROGRESS", color = "#9b59b6", icon = "fa-mask" },
    { code = "Grade 2", title = "CRIME IN PROGRESS", color = "#e67e22", icon = "fa-person-running" },
}

-- Dispatch CCTV Cameras
Config.DispatchCameraAdminDiscord = {
    "201333298738364417"-- Add Discord IDs without the "discord:" prefix (example: "123456789012345678")
}

Config.DispatchCameras = {
    { id = 101, label = "City Camera 01", coords = { x = 1153.91, y = -326.87, z = 71.47 }, rot = { x = -17.11, y = -0.00, z = 297.20 }, fov = 100.00 },
    { id = 102, label = "City Camera 02", coords = { x = 241.95, y = 215.07, z = 108.63 }, rot = { x = -15.54, y = 0.00, z = 318.49 }, fov = 100.00 },
    { id = 103, label = "City Camera 03", coords = { x = 317.06, y = -280.14, z = 55.58 }, rot = { x = -8.06, y = -0.00, z = 47.57 }, fov = 100.00 },
    { id = 104, label = "City Camera 04", coords = { x = 152.67, y = -1041.85, z = 30.79 }, rot = { x = -7.32, y = -0.00, z = 58.23 }, fov = 100.00 },
    { id = 105, label = "City Camera 05", coords = { x = 92.45, y = -1943.94, z = 26.91 }, rot = { x = -29.53, y = -0.00, z = 292.68 }, fov = 100.00 },
}

-- Criminal Code / Offenses (MDT)
-- Edit this list to add/remove offenses shown in the MDT criminal code.
-- If syncEnabled is true, offenses here are synced to database on resource start.
Config.ChargeSync = {
    syncEnabled = true,
    removeMissingFromDatabase = true
}

Config.MDTCharges = {
   charges = {
             -- TRAFFIC
            {name = "Dangerous Driving", category = "Traffic", prison_time = 20, fine = 700},
            {name = "Drink Driving", category = "Traffic", prison_time = 15, fine = 700},
            {name = "Drug Driving", category = "Traffic", prison_time = 15, fine = 700},
            {name = "Driving Without Insurance", category = "Traffic", prison_time = 10, fine = 500},
            {name = "Driving Without License", category = "Traffic", prison_time = 10, fine = 500},
            {name = "Speeding", category = "Traffic", prison_time = 5, fine = 500},
            {name = "Using Mobile Phone While Driving", category = "Traffic", prison_time = 5, fine = 250},
            {name = "Failing to Stop After Accident", category = "Traffic", prison_time = 15, fine = 2000},
            {name = "Careless Driving", category = "Traffic", prison_time = 10, fine = 500}
        }
    }

-- Debugging & Mock Data
Config.Debug = false -- Set to true to show mock officers below
Config.MockOfficers = {
    {
        id = 9901,
        name = "Jack Reacher",
        job = "police",
        jobLabel = "LSPD",
        coords = { x = 425.1, y = -979.5, z = 30.7 },
        heading = 90.0,
        radioChannel = 1,
        callsign = "1A-01",
        image = "img/fake1.jpg",
        onDuty = true
    },
    {
        id = 9902,
        name = "Sarah Connor",
        job = "police",
        jobLabel = "LSPD",
        coords = { x = 441.2, y = -982.1, z = 30.6 },
        heading = 180.0,
        radioChannel = 1,
        callsign = "1A-02",
        image = "img/fake2.jpg",
        onDuty = true
    },
    {
        id = 9903,
        name = "Frank Castle",
        job = "sheriff",
        jobLabel = "BCSO",
        coords = { x = 1850.3, y = 3680.5, z = 34.2 },
        heading = 45.0,
        radioChannel = 2,
        callsign = "2B-10",
        image = "img/fake3.jpg",
        onDuty = true
    },
    {
        id = 9904,
        name = "Ellen Ripley",
        job = "ambulance",
        jobLabel = "EMS",
        coords = { x = 300.5, y = -1440.2, z = 29.8 },
        heading = 270.0,
        radioChannel = 3,
        callsign = "MED-01",
        image = "img/fake4.jpg",
        onDuty = true
    },
    {
        id = 9905,
        name = "James Bond",
        job = "fib",
        jobLabel = "FIB",
        coords = { x = 110.1, y = -750.5, z = 45.1 },
        heading = 0.0,
        radioChannel = 0,
        callsign = "007",
        image = "img/fake5.jpg",
        onDuty = true
    }
}

-- MDT Localization
-- Pick active language key from Config.Translations below.
Config.Locale = "en"

-- Add new language blocks (example: "fr", "es", "ar") and translate values.
-- Keep the same keys so scripts/UI can read the correct text.
Config.Translations = {
    ["en"] = {
        -- Generic
        app_title = "MDT",
        close = "Close",
        back = "Back",
        save = "Save",
        cancel = "Cancel",
        confirm = "Confirm",
        delete = "Delete",
        create = "Create",
        update = "Update",
        search = "Search",
        loading = "Loading...",
        no_data = "No data found",
        unknown = "Unknown",
        submit = "Submit",
        online = "Online",
        offline = "Offline",
        on_duty = "On Duty",
        off_duty = "Off Duty",

        -- Navigation
        nav_home = "Home",
        nav_dashboard = "Dashboard",
        nav_profiles = "Profiles",
        nav_vehicles = "Vehicles",
        nav_incidents = "Incidents",
        nav_warrants = "Warrants",
        nav_charges = "Charges",
        nav_dispatch = "Dispatch",
        nav_officers = "Officers",

        -- Dispatch
        dispatch_title = "Dispatch",
        dispatch_no_recent_alerts = "No recent alerts",
        dispatch_assign = "Assign",
        dispatch_direction = "Direction",
        dispatch_locate = "Locate",
        dispatch_assign_unit_placeholder = "Assign unit...",
        dispatch_no_units_created = "No units created",
        dispatch_no_units_assigned = "No units assigned",
        dispatch_gps_set = "GPS set to alert location.",
        dispatch_no_gps = "No GPS data available for this alert.",
        dispatch_camera_feed = "Camera Feed",
        dispatch_live_cctv = "Live CCTV",
        dispatch_camera_connected = "Connected to selected city camera",
        dispatch_add_camera = "Add Camera",
        dispatch_camera_created = "Dispatch camera created.",
        dispatch_camera_no_permission = "You don't have permission to create cameras.",
        dispatch_camera_exit = "Exit",
        dispatch_notification_title = "Live Dispatch",
        dispatch_notification_dismiss = "Dismiss",

        -- Units / Personnel
        unit_create = "Create Unit",
        unit_name = "Unit Name",
        unit_add_officer = "Add Officer",
        unit_remove = "Remove Unit",
        unit_available = "Available for assignment",
        personnel_activity = "Personnel Activity",
        no_online_officers = "No online officers",

        -- Officers
        officer_profile = "Officer Profile",
        officer_callsign = "Callsign",
        officer_rank = "Rank",
        officer_department = "Department",
        officer_radio_channel = "Radio Channel",

        -- Citizens / Profiles
        citizen_profiles = "Citizen Profiles",
        citizen_search_placeholder = "Search citizen by name...",
        citizen_no_results = "No citizens found",
        citizen_notes = "Notes",
        citizen_tags = "Tags",

        -- Vehicles
        vehicle_records = "Vehicle Records",
        vehicle_search_placeholder = "Search plate / model...",
        vehicle_no_results = "No vehicles found",
        vehicle_owner = "Owner",
        vehicle_model = "Model",
        vehicle_plate = "Plate",
        vehicle_status = "Status",

        -- Incidents / Reports
        incidents_title = "Incidents",
        incident_create = "Create Incident",
        incident_search_placeholder = "Search incidents...",
        incident_no_results = "No incidents found",
        incident_evidence = "Evidence",
        incident_officers = "Officers Involved",
        incident_civilians = "Civilians Involved",

        -- Warrants
        warrants_title = "Warrants",
        warrant_create = "Create Warrant",
        warrant_no_results = "No warrants found",
        warrant_expires = "Expires",
        warrant_status = "Status",

        -- Charges / Criminal Code
        charges_title = "Criminal Code",
        charges_search_placeholder = "Search charges...",
        charges_no_results = "No charges found",
        charges_category = "Category",
        charges_fine = "Fine",
        charges_jail_time = "Jail Time",

        -- Dynamic JS-rendered UI strings
        loading_warrants = "Loading warrants...",
        loading_reports = "Loading reports...",
        dashboard_no_active_bolos = "No active BOLOs",
        dashboard_no_active_warrants = "No active warrants",
        dashboard_no_recent_reports = "No recent reports",
        dashboard_no_notifications = "No notifications",
        dispatch_alert_default_title = "Dispatch Alert",
        dispatch_unknown_location = "Unknown Location",
        dispatch_no_units_online = "No units online",
        dispatch_no_units_created_yet = "No units created yet",
        dispatch_no_members = "No members",
        dispatch_no_available_officers = "No available officers",
        charges_no_selected = "No charges selected",
        charges_no_matching_offenses = "No matching offenses found. Please ensure charges are added to the database.",
        profile_no_vehicles_registered = "No vehicles registered.",
        profile_no_criminal_history = "No criminal history found.",
        profile_no_owner_information = "No owner information found.",
        profile_no_active_bolos_vehicle = "No active BOLOs for this vehicle.",
        incidents_no_description_provided = "No description provided.",
        incidents_no_summary_provided = "No summary provided.",
        incidents_no_linked_profiles = "No linked profiles.",
        warrants_no_title_provided = "No title provided",
        warrants_no_additional_details_provided = "No additional details provided.",
        generic_no_additional_notes = "No additional notes.",
        generic_no_additional_information = "No additional information.",
        bolo_unknown_owner = "Unknown Owner",
        officer_unknown_officer = "Unknown Officer",
        warrant_unknown_subject = "Unknown Subject",

        -- Notifications / Errors
        notify_mdt_loaded = "MDT successfully loaded",
        notify_no_permission = "You don't have permission.",
        notify_action_success = "Action completed successfully.",
        notify_action_failed = "Action failed.",
        notify_invalid_data = "Invalid data provided."
    }
}
