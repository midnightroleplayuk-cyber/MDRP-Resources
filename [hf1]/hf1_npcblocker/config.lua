Config = {}

-- Add more entries to this table as you add new MLOs.
-- Corners can be vec3 or vec4 (vec4 heading is ignored).
-- Put corners in perimeter order, clockwise or counterclockwise.
Config.Zones = {
    {
        name = 'Courts',
        corners = {
            vec4(-451.52, -399.60, 32.36, 271.35),
            vec4(-360.96, -411.09, 29.62, 260.43),
            vec4(-365.99, -466.36, 29.14, 94.81),
            vec4(-458.46, -459.12, 32.06, 75.30)
        },
        minZ = 23.0,
        maxZ = 42.0,
        -- Disable AI vehicle road paths inside this zone.
        disableRoads = true,
        -- Disable ambient population spawns near players inside this zone.
        suppressPopulation = true,
        -- Periodically remove only ambient non-mission, non-player NPCs/vehicles.
        cleanupAmbient = true,
        cleanupIntervalMs = 3000,
        -- How far from the zone to begin applying local density suppression.
        activationDistance = 110.0
    },
        {
        name = 'Sandy Estates',
        corners = {
            vec4(1640.35, 3683.43, 33.17, 116.41),
            vec4(1369.32, 3567.62, 34.25, 212.41),
            vec4(1388.42, 3520.8, 35.01, 258.42),
            vec4(1631.63, 3489.75, 35.84, 279.94),
            vec4(1685.59, 3513.7, 35.55, 46.24)
        },
        minZ = 31.0,
        maxZ = 44.0,
        -- Disable AI vehicle road paths inside this zone.
        disableRoads = true,
        -- Disable ambient population spawns near players inside this zone.
        suppressPopulation = true,
        -- Periodically remove only ambient non-mission, non-player NPCs/vehicles.
        cleanupAmbient = true,
        cleanupIntervalMs = 3000,
        -- How far from the zone to begin applying local density suppression.
        activationDistance = 110.0
    },
}

Config.Debug = false
