Config = {}

-- Add as many alarm and reset points as you like. Each station ID has independent alarm state.
Config.Stations = {
    vinewood = {
        label = 'Vinewood Station',
        alarmPoints = {
            vec3(385.02, -312.72, 45.94), -- Cell 1
            vec3(382.11, -311.47, 45.94), -- Cell 2
            vec3(380.3, -310.95, 45.94), -- Cell 3
            vec3(378.36, -307.36, 46.9), -- Cell 4
            vec3(375.35, -306.2, 46.91), -- Cell 5
            vec3(372.72, -305.18, 46.91), -- Cell 6
            vec3(369.8, -304.0, 46.93), -- Cell 7
            vec3(366.85, -302.85, 46.91), -- Cell 8

            --HOLDING
            vec3(363.73, -314.77, 47.57), -- Holding 1
            vec3(362.88, -316.86, 47.38), -- Holding 2
        },
        resetPoints = {
            vec3(384.43, -318.68, 47.45), -- Vinewood Station Reset Point
        },
        soundOrigin = vec3(378.9, -314.24, 45.94),
    },
}

Config.SoundFile = 'alarm.ogg' -- Put your own .ogg in sounds/
Config.SoundVolume = 0.45 -- 0.0 to 1.0
Config.SoundDistance = 30.0 -- 3D audio falloff radius (metres)
Config.InteractDistance = 2.0
Config.ServerInteractDistance = 4.0 -- Server validation tolerance
