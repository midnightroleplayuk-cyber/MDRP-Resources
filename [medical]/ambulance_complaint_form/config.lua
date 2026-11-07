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
    Coords = vec3(-344.76, -128.13, 38.71),
    Radius = 0.5, -- Size of the target zone around the desk vector
    Distance = 0.5, -- Maximum distance for selecting an option
    Debug = false, -- Set true to display the target zone while testing
    PublicIcon = 'fa-solid fa-pen-to-square',
    PublicLabel = 'Submit MHS Feedback',
    StaffIcon = 'fa-solid fa-clipboard-list',
    StaffLabel = 'MHS Staff: View Complaints'
}

Config.DiscordWebhook = ''
