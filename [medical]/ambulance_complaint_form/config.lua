Config = {}

Config.ServiceName = 'Midnight Health Service'
Config.AmbulanceJobName = 'ambulance'

Config.Permissions = {
    ReviewAccess = 1
}

Config.Categories = {
    'Staff Conduct / Behaviour',
    'Quality of Care or Treatment',
    'Response Time or Delay',
    'Communication or Information',
    'Equipment / Facilities',
    'Other Matter'
}

Config.StaffJobs = {
    [Config.AmbulanceJobName] = Config.Permissions.ReviewAccess
}

Config.PublicCommand = 'ambulancecomplaint'
Config.OfficerCommand = 'ambulancecomplaints'

Config.MaxTitleLength = 100
Config.MaxDescLength = 2000
Config.MaxLocLength = 150
Config.MaxContactLength = 100
Config.MaxNoteLength = 1000
Config.MaxPerHour = 5

Config.Desk = {
    Enabled = true,
    Coords = vec3(307.2, -595.1, 43.3),
    Distance = 2.0,
    PublicIcon = 'fa-solid fa-pen-to-square',
    PublicLabel = 'Submit Ambulance Service Feedback',
    StaffIcon = 'fa-solid fa-clipboard-list',
    StaffLabel = 'Ambulance Staff: View Complaints'
}

Config.DiscordWebhook = ''
