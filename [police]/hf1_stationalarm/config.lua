Config = {}

-- Add as many alarm and reset points as you like. Each station ID has independent alarm state.
-- Use vec4(x, y, z, heading) to only allow use from one side: heading = the way a player faces when using it.
-- Plain vec3 points can be used from any direction.
Config.Stations = {
    vinewood = {
        label = 'Vinewood Station',
        alarmPoints = {
            vec4(385.93, -310.46, 46.82, 340.89), -- Cell 1
            vec4(382.97, -309.38, 46.86, 332.46), -- Cell 2
            vec4(381.58, -308.67, 46.97, 338.27), -- Cell 3
            vec4(378.29, -307.67, 46.83, 339.9), -- Cell 4
            vec4(375.31, -306.48, 46.94, 326.32), -- Cell 5
            vec4(372.61, -305.25, 46.79, 352.89), -- Cell 6
            vec4(369.63, -304.04, 46.78, 325.06), -- Cell 7
            vec4(366.83, -302.94, 46.87, 342.22), -- Cell 8

            --HOLDING
            vec4(363.77, -314.89, 47.53, 64.15), -- Holding 1
            vec4(362.98, -316.92, 47.46, 65.89), -- Holding 2
        },
        resetPoints = {
            vec4(384.54, -318.7, 47.36, 338.41), -- Vinewood Station Reset Point
        },
        soundOrigin = vec3(378.9, -314.24, 45.94),
    },
}

Config.SoundFile = 'alarm.ogg' -- Put your own .ogg in sounds/
Config.SoundVolume = 0.45 -- 0.0 to 1.0
Config.SoundDistance = 30.0 -- 3D audio falloff radius (metres)
Config.InteractDistance = 2.0
Config.ServerInteractDistance = 4.0 -- Server validation tolerance

-- True when pos is on the side a vec4 point faces; vec3 points have no restriction.
function Config.InFront(point, pos)
    if type(point) ~= 'vector4' then return true end
    local h = math.rad(point.w)
    return (point.x - pos.x) * -math.sin(h) + (point.y - pos.y) * math.cos(h) > 0
end
