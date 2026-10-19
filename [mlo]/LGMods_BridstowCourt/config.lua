Config = {}

-- =======================================================
--  General
-- =======================================================

Config.debug    = false    -- Console logging + /bridstow_roomdebug command
Config.target   = false   -- true = use target system, false = press-to-interact
Config.interact = 1.8     -- Interaction distance (metres)

-- =======================================================
--  Building
-- =======================================================

Config.buildingRadius = 30.0   -- Radius around the building that counts as "nearby"

-- =======================================================
--  Furniture
-- =======================================================

Config.furniture = true   -- true = load the furniture entity sets on every floor

-- Interior archetypes that make up the interiors
Config.furnitureArchetypes = {
    [2118847047]  = true,
    [-1606556717] = true,
    [915664316]   = true,
}

Config.furnitureCoords = {
    vector3(-290.25, -1627.69, 32.34),   -- Floor 0  (ground floor)
    vector3(-289.39, -1628.80, 36.11),   -- Floor 1
    vector3(-290.16, -1629.13, 39.86),   -- Floor 2
    vector3(-289.95, -1629.15, 43.61),   -- Floor 3
    vector3(-291.48, -1628.67, 47.36),   -- Floor 4
    vector3(-291.15, -1629.55, 51.11),   -- Floor 5
    vector3(-291.03, -1629.53, 54.88),   -- Floor 6
    vector3(-291.10, -1629.30, 58.61),   -- Floor 7
    vector3(-289.94, -1629.50, 62.36),   -- Floor 8
    vector3(-290.21, -1629.25, 66.11),   -- Floor 9
    vector3(-289.09, -1629.43, 69.86),   -- Floor 10
    vector3(-290.07, -1629.26, 73.61),   -- Floor 11
    vector3(-289.86, -1628.80, 77.36),   -- Floor 12
    vector3(-290.16, -1629.11, 81.11),   -- Floor 13
    vector3(-290.58, -1629.68, 84.86),   -- Floor 14
    vector3(-290.40, -1629.17, 88.61),   -- Floor 15
    vector3(-290.60, -1629.26, 92.36),   -- Floor 16
    vector3(-289.86, -1628.83, 96.11),   -- Floor 17
    vector3(-292.34, -1628.78, 99.86),   -- Floor 18
    vector3(-290.75, -1629.43, 103.61),  -- Floor 19 (top floor)
}