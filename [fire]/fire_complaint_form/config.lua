Config = {}

Config.ServiceName = 'Midnight Fire & Rescue'
Config.FireJobName = 'fire'

Config.Permissions = {
    ReviewAccess = 1
}

Config.Categories = {
    'Staff Conduct / Behaviour',
    'Emergency Response',
    'Fire Safety or Inspection',
    'Response Time or Delay',
    'Communication or Information',
    'Equipment / Facilities',
    'Other Matter'
}

Config.StaffJobs = {
    [Config.FireJobName] = Config.Permissions.ReviewAccess
}

Config.PublicCommand = 'firecomplaint'
Config.OfficerCommand = 'firecomplaints'

Config.MaxTitleLength = 100
Config.MaxDescLength = 2000
Config.MaxLocLength = 150
Config.MaxContactLength = 100
Config.MaxNoteLength = 1000
Config.MaxPerHour = 5

Config.Desk = {
    Enabled = true,
    Coords = vec3(-1189.79, -1317.42, 5.33),
    Radius = 1.0,
    Distance = 1.0,
    PublicIcon = 'fa-solid fa-pen-to-square',
    PublicLabel = 'Submit Fire Services Feedback',
    StaffIcon = 'fa-solid fa-clipboard-list',
    StaffLabel = 'Fire Staff: View Complaints'
}

Config.DiscordWebhook = ''
