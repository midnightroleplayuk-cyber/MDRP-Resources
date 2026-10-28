Config = {}

Config.PoliceJobName = 'police'

Config.Permissions = {
    ReviewAccess = 1,
    PSDAccess = 6
}

Config.PublicCommand = 'complaint'
Config.OfficerCommand = 'policecomplaints'

Config.MaxTitleLength = 100
Config.MaxDescLength = 2000
Config.MaxLocLength = 150
Config.MaxContactLength = 100
Config.MaxNoteLength = 1000
Config.MaxPerHour = 5

Config.Desk = {
    Enabled = true,
    Coords = vec3(441.2, -981.9, 30.7), -- Change to your station's front desk.
    Distance = 2.0,
    PublicIcon = 'fa-solid fa-pen-to-square',
    PublicLabel = 'Submit Complaint / Enquiry',
    StaffIcon = 'fa-solid fa-clipboard-list',
    StaffLabel = 'Staff: View Complaints'
}

Config.DiscordWebhook = ''
