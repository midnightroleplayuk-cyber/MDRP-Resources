Config = {}
Config.DefaultModel = 'prop_door_bell_01' -- Dedicated bell model
Config.DefaultCoords = vec4(441.18, -981.92, 30.69, 0.0)
Config.TargetRadius = 0.8
Config.InteractDistance = 2.0
Config.CooldownSeconds = 60
Config.AlertJobs = { police = true }
Config.NotificationDuration = 7000
Config.EnablePlacementEditor = false -- Set false after placement is final
Config.PlacementIdentifier = 'fivem:1059188' -- Only this identifier can use the placement editor

-- Place your own OGG file in html/sounds/ and set its filename here.
Config.SoundFile = 'bell.ogg'
Config.SoundVolume = 0.65 -- 0.0 to 1.0
Config.SoundDistance = 15.0 -- Nearby players who can hear the bell (metres)
