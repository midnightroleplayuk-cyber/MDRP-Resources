Config = {}

-- Framework Configuration
-- Options: "QB", "ESX", or "AUTO"
Config.Framework = "AUTO" 

-- Notification Type
-- Options: "qb", "esx", "chat", or "AUTO"
Config.NotifyType = "AUTO"

-- UI Header Configuration
Config.HeaderLeftText = "POLICE DEPT."
Config.HeaderRightText = "MDT SYSTEM V1.2"

-- Optimization Settings
Config.RenderDistance = 10.0 -- The CAD will only render and run when within this distance (meters)

-- Command Configuration
Config.Commands = {
    open = "cad",
    close = "cadclose",
    key = "cadkey",
    test = "cad2d",
    edit = "cadedit"
}

-- Discord Integration
Config.Webhook = "https://discord.com/api/webhooks/1460262545570009168/mqhxLPDNzEVGg54LAV8e8vS7hiYsTXjmuqc2rPsTASMRCXJuY7c3zqWy2YRW9HNvaRBm" -- Paste your Discord Webhook URL here
Config.WebhookName = "LSPD Records"
Config.WebhookIcon = "https://i.imgur.com/83uA5fG.png"

-- UI Features
Config.AddFakeOfficers = true -- Add 2 fake officers to the unit status for testing

-- Access Configuration
Config.Jobs = { "police", "sheriff", "fib" } -- The jobs required to use/spawn the CAD

-- Mouse Settings
Config.MouseSensitivity = 0.040 -- Sensitivity of the custom cursor in 3D mode

-- Localization / Translations
Config.Locales = {
    -- Notifications & Commands
    ['no_vehicle'] = "You must be in a vehicle to use the CAD",
    ['access_denied'] = "Access Denied: Authorized Jobs Only",
    ['cad_not_active'] = "CAD is not active. Use /%{command} first.",
    ['interaction_started'] = "CAD Interaction Started (ESC to exit)",
    ['interaction_stopped'] = "CAD Interaction Stopped",
    ['interaction_too_far'] = "CAD Interaction Stopped (Too far away)",
    ['cad_deactivated'] = "CAD Deactivated",
    ['cad_initialized'] = "Police CAD Initialized",
    ['cad_failed'] = "Failed to create CAD panel",
    ['cad_deleted'] = "CAD Closed: Vehicle deleted",
    ['unknown_officer'] = "Unknown Officer",

    -- UI General
    ['nav_cad'] = "CAD",
    ['nav_search'] = "Search",
    ['nav_history'] = "History",
    ['nav_forms'] = "Forms",
    ['nav_notepad'] = "Notepad",
    ['nav_records'] = "Records",
    ['supervisor'] = "SUPERVISOR",
    ['status_label'] = "STATUS:",
    ['no_active_call'] = "NO ACTIVE CALL",
    ['state_returns'] = "STATE RETURNS:",

    -- Dashboard
    ['active_calls_title'] = "ACTIVE CALLS FOR SERVICE",
    ['unit_status_title'] = "UNIT STATUS / ACTIVE PERSONNEL",
    ['col_call_id'] = "CALL#",
    ['col_nature'] = "NATURE",
    ['col_location'] = "LOCATION",
    ['col_status'] = "STATUS",
    ['col_assigned'] = "ASSIGNED",
    ['col_officer'] = "OFFICER",
    ['col_unit'] = "UNIT",
    ['col_agency'] = "AGENCY",
    ['col_description'] = "DESCRIPTION",

    -- Statuses
    ['status_available'] = "AVAILABLE",
    ['status_busy'] = "BUSY",
    ['status_unavailable'] = "UNAVAILABLE",
    ['status_training'] = "TRAINING",

    -- Vehicle Search
    ['vehicle_inquiry_title'] = "VEHICLE DATABASE INQUIRY",
    ['begin_scan'] = "BEGIN SYSTEM SCAN",
    ['scanning_freq'] = "SCANNING FREQUENCIES...",
    ['wait_scan'] = "[ PLEASE WAIT 5.0s ]",
    ['scanned_plate'] = "SCANNED PLATE:",
    ['model'] = "MODEL:",
    ['owner'] = "OWNER:",
    ['bolo_hit'] = "⚠️ ALPR HIT: BOLO DETECTED",
    ['bolo_title'] = "TITLE:",
    ['bolo_reason'] = "REASON:",
    ['inquiry_completed'] = ">>> INQUIRY COMPLETED <<<",
    ['scan_failed'] = "FAILED TO SCAN PLATE - NO VEHICLE IN RANGE",

    -- Call Details & History
    ['history_title'] = "PREVIOUS DISPATCH CALLS",
    ['call_details_title'] = "CALL DETAILS #",
    ['resolve_call'] = "RESOLVE CALL",
    ['assign_unit'] = "ASSIGN UNIT",
    ['back'] = "BACK",
    ['coordinates'] = "COORDINATES:",
    ['add_info'] = "ADDITIONAL INFORMATION:",
    ['no_info'] = "NO ADDITIONAL INFORMATION PROVIDED",

    -- Criminal Search
    ['criminal_inquiry_title'] = "CRIMINAL DATABASE INQUIRY",
    ['search_placeholder'] = "ENTER NAME OR CID...",
    ['search_btn'] = "SEARCH",

    -- Forms
    ['forms_title'] = "DEPARTMENTAL FORMS & REPORTS",
    ['arrest_report'] = "ARREST REPORT",
    ['traffic_citation'] = "TRAFFIC CITATION",
    ['incident_report'] = "INCIDENT REPORT",
    ['select_form'] = "SELECT A FORM FROM THE LEFT TO BEGIN",
    ['file_report'] = "FILE REPORT",
    ['issue_citation'] = "ISSUE CITATION",
    ['save_report'] = "SAVE REPORT",
    ['filed_success'] = "FILED SUCCESSFULLY",
    ['transmitted'] = "THE DATA HAS BEEN TRANSMITTED TO CENTRAL DISPATCH",
    ['return_dash'] = "RETURN TO DASHBOARD",

    -- Notepad
    ['notepad_title'] = "FIELD NOTEPAD (AUTO-SAVING)",
    ['notepad_placeholder'] = "ENTER FIELD NOTES HERE...",
    ['notepad_note'] = "NOTE: DATA IS PERSISTENT TO THIS TERMINAL ONLY",
    ['clear_all'] = "CLEAR ALL",

    -- Records
    ['records_title'] = "LSPD CASE FILES & RECORDS",
    ['col_date'] = "DATE",
    ['col_type'] = "TYPE",
    ['col_action'] = "ACTION",
    ['view_btn'] = "VIEW",
    ['filed_by'] = "FILED BY %{officer} ON %{date}",
    ['back_records'] = "BACK TO RECORDS",

    -- Discord Embeds
    ['discord_new_filed'] = "NEW %{type} FILED",
    ['discord_officer'] = "OFFICER:",
    ['discord_subject'] = "SUBJECT:",
    ['discord_footer'] = "LSPD Record Management System"
}

