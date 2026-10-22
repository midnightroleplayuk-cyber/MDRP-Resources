Config = {}
Config.PoliceJob = 'police'
Config.CooldownSeconds = 60
Config.BuzzerInteractDistance = 1.0 -- Very close to the wall-mounted buzzer
Config.BuzzerServerDistance = 0.85 -- Small allowance for network position differences
Config.ControlInteractDistance = 1.5
Config.ControlServerDistance = 2.0
Config.SoundEnabled = true -- Put your own buzzer.ogg in html/; no sound until you replace placeholder
Config.SoundVolume = 0.35
Config.Stations = {
    vinewood = {
        label = 'VINEWOOD POLICE STATION',
        control = vec3(385.62, -322.14, 46.81),
        soundCenter = vec3(374.34, -318.14, 45.94),
        soundRadius = 30.0, -- Sound is audible to on-duty police inside this radius only
        buzzers = {
            { name = 'Cell 1', coords = vec3(388.1, -310.15, 47.15) },
            { name = 'Cell 2', coords = vec3(385.26, -309.0, 47.15) },
            { name = 'Cell 3', coords = vec3(379.8, -306.85, 47.15) },
            { name = 'Cell 4', coords = vec3(377.02, -305.75, 47.15) },
            { name = 'Cell 5', coords = vec3(374.05, -304.58, 47.13) },
            { name = 'Cell 6', coords = vec3(371.22, -303.45, 47.15) },
            { name = 'Cell 7', coords = vec3(368.37, -302.31, 47.15) },
            { name = 'Cell 8', coords = vec3(365.48, -301.18, 47.15) },
            { name = 'Holding Cell 1', coords = vec3(363.77, -312.63, 47.12) },
            { name = 'Holding Cell 2', coords = vec3(360.76, -320.22, 47.13) },
        }
    }
}
