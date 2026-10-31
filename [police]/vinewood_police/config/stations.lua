---------------------------------------------------------------------------
-- Stations: sign-on points, equipment lockers and armouries (Tasers, firearms, ammunition).
-- A station without armouries simply has none: armed officers kit up elsewhere.
-- Easiest to set in game: vpo locations.
-- The coordinates below are for the base-game stations. Move them to fit your MLOs
-- (stand on the spot and use any coords tool, e.g. ox_lib's /coords via your admin menu).
---------------------------------------------------------------------------
Config.Stations = {
    {
        id = 'mission_row',
        label = 'Mission Row',
        signOn = { coords = vec3(441.2, -981.9, 30.7), size = vec3(1.6, 1.0, 2.0), rotation = 0.0 },
        lockers = {
            { coords = vec3(461.6, -996.3, 30.7), size = vec3(2.0, 1.0, 2.0), rotation = 0.0 },
        },
        armouries = {
            { coords = vec3(452.3, -980.0, 30.7), size = vec3(2.0, 1.2, 2.0), rotation = 0.0 },
        },
    },
    {
        id = 'sandy_shores',
        label = 'Sandy Shores',
        signOn = { coords = vec3(1853.2, 3689.6, 34.3), size = vec3(1.6, 1.0, 2.0), rotation = 30.0 },
        lockers = {
            { coords = vec3(1857.9, 3694.0, 34.3), size = vec3(2.0, 1.0, 2.0), rotation = 30.0 },
        },
    },
    {
        id = 'paleto_bay',
        label = 'Paleto Bay',
        signOn = { coords = vec3(-448.4, 6012.6, 31.7), size = vec3(1.6, 1.0, 2.0), rotation = 45.0 },
        lockers = {
            { coords = vec3(-451.4, 6015.1, 31.7), size = vec3(2.0, 1.0, 2.0), rotation = 45.0 },
        },
    },
}

-- How close to a locker or armoury counts as "at" it (metres).
Config.LockerRadius = 3.0
