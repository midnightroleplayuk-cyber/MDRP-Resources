Config = {}

Config.AllowedJobs = {
    ambulance = true
}

Config.Command = "emsmdt"
Config.Keybind = "F9"

Config.UI = {
    appName = "PLT MDT EMS",
    departmentLabel = "EMS",
    accent = "#e76a8b"
}

Config.Camera = {
    -- Put your Discord webhook URL here to enable MDT camera uploads.
    -- Example: "https://discord.com/api/webhooks/...."
    DiscordWebhook = "",
    UploadField = "files[]",
    WaitBeforeCaptureMs = 600,
    OverlayLabel = "MDT LIVE CAMERA",
    ErrorNotify = "MDT camera is not configured. Add Discord webhook in config."
}

-- Dispatch map quick calls (panic button selector)
Config.QuickCalls = {
    { code = "10-52", title = "PATIENT IN DISTRESS", color = "#ff3e3e", icon = "fa-heart-pulse" },
    { code = "10-78", title = "EMS NEEDS HELP", color = "#ff9800", icon = "fa-triangle-exclamation" },
}

Config.Tabs = {
    { id = "dashboard", label = "Dashboard", icon = "fa-chart-line" },
    { id = "patient_database", label = "Patient Database", icon = "fa-user-group" },
    { id = "reports", label = "Reports", icon = "fa-file-signature" },
    { id = "medical_records", label = "Medical Tags Library", icon = "fa-file-waveform" },
    { id = "dispatch_gps", label = "Dispatch & GPS", icon = "fa-map-location-dot" },
    { id = "xray", label = "X-Ray", icon = "fa-x-ray" },
    { id = "directory_sops", label = "Directory & SOPs", icon = "fa-book-medical" }
}

Config.MedicalNoteTags = {
    { title = "Emergency Triage", category = "General Care", description = "Initial emergency triage and intake.", fine = 350, jail = 0 },
    { title = "Basic Consultation", category = "General Care", description = "Standard patient consultation and assessment.", fine = 250, jail = 0 },
    { title = "Vital Signs Monitoring", category = "General Care", description = "Continuous monitoring of vital signs.", fine = 180, jail = 0 },
    { title = "Wound Dressing", category = "Trauma", description = "Cleaning and dressing superficial wounds.", fine = 220, jail = 0 },
    { title = "Suturing Procedure", category = "Trauma", description = "Minor suturing procedure for lacerations.", fine = 600, jail = 0 },
    { title = "Fracture Stabilization", category = "Trauma", description = "Immobilization and stabilization of fracture.", fine = 1100, jail = 0 },
    { title = "Burn Treatment", category = "Trauma", description = "Initial management of burn injuries.", fine = 950, jail = 0 },
    { title = "Cardiac Assessment", category = "Cardiology", description = "Cardiac screening and emergency cardiac check.", fine = 800, jail = 0 },
    { title = "Respiratory Support", category = "Pulmonary", description = "Breathing support and respiratory intervention.", fine = 720, jail = 0 },
    { title = "Neurological Assessment", category = "Neurology", description = "Neurological checks after head trauma/symptoms.", fine = 780, jail = 0 },
    { title = "Laboratory Panel", category = "Diagnostics", description = "Standard blood and lab testing panel.", fine = 520, jail = 0 },
    { title = "Radiology Imaging", category = "Diagnostics", description = "Diagnostic imaging and x-ray review.", fine = 900, jail = 0 },
    { title = "Medication Administration", category = "Pharmacy", description = "Prescribed medication administration.", fine = 300, jail = 0 },
    { title = "IV Therapy", category = "Pharmacy", description = "IV fluids and supportive treatment.", fine = 480, jail = 0 },
    { title = "Observation Ward", category = "Inpatient", description = "Short in-patient observation and follow-up.", fine = 700, jail = 0 },
    { title = "Minor Surgery", category = "Surgery", description = "Minor operative procedure.", fine = 1800, jail = 0 },
    { title = "Major Surgery", category = "Surgery", description = "Major operative procedure and recovery.", fine = 4500, jail = 0 },
    { title = "Rehabilitation Session", category = "Recovery", description = "Post-trauma rehabilitation support.", fine = 400, jail = 0 },
    { title = "Psychological Evaluation", category = "Mental Health", description = "Mental health and trauma evaluation.", fine = 550, jail = 0 },
    { title = "Hospital Discharge Plan", category = "Administrative", description = "Discharge planning and clinical summary.", fine = 200, jail = 0 }
}
