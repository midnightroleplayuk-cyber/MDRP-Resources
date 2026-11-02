---------------------------------------------------------------------------
-- Dynamic NPC callouts (phase 4).
-- Calls are created on the server, sent out through vinewood-dispatch (or the built-in call list),
-- and only come to life (peds and vehicles spawned) when an officer gets close. How many run at once
-- scales with how many officers are signed on.
---------------------------------------------------------------------------
Config.Callouts = {
    -- Default only: admins can switch callouts on and off in game with `vpo callouts on|off`, and that
    -- choice is kept (it survives restarts) until changed again.
    Enabled = true,
    MinOfficers = 1,            -- signed-on officers needed before any callouts are made
    PerOfficer = 0.75,          -- open calls allowed per signed-on officer (rounded up)...
    MaxActive = 6,              -- ...but never more than this
    ChancePerMinute = 35,       -- % chance each minute of a new call, while below the limit
    ActivationDistance = 120.0, -- the scene spawns when an officer is this close
    Unattended = 20,            -- minutes before an unattended call closes as "No police attendance"
    Abandoned = 10,             -- minutes with no officer within 300 m before an active scene is cleared
    MinSpacing = 150.0,         -- open calls are at least this far apart
    CreateMdtIncident = true,   -- closing a call creates an MDT incident (vinewood-mdt 2.18+)
    Command = 'calls',          -- the built-in call list (when vinewood-dispatch isn't running)

    -- Scenario weights (0 = off) and the fewest officers on duty each needs
    Scenarios = {
        shoplifting  = { weight = 30, minOfficers = 1, priority = 3 },
        disturbance  = { weight = 25, minOfficers = 1, priority = 2 },
        welfare      = { weight = 15, minOfficers = 1, priority = 3 },
        burglary     = { weight = 15, minOfficers = 1, priority = 2 },
        collision    = { weight = 15, minOfficers = 1, priority = 2 },
        shop_robbery = { weight = 8,  minOfficers = 2, priority = 1 },
        street_robbery = { weight = 10, minOfficers = 1, priority = 2 },
        stolen_vehicle = { weight = 10, minOfficers = 1, priority = 2 },
        missing_person = { weight = 6,  minOfficers = 2, priority = 2 },
    },

    -- Armed suspects. Robbers carry a knife, or a handgun only while an Armed response officer is on duty.
    Armed = {
        FirearmChance = 30,       -- % of shop robberies with a handgun (when an ARV officer is signed on)
        FirearmsNeedARV = true,   -- never a handgun unless an officer is signed on as Armed response
        SurrenderToARV = 70,      -- % who give up when armed police (ARV unit) reach them
        SurrenderToOfficers = 15, -- % who give up to unarmed officers
        Weapons = { knife = 'WEAPON_KNIFE', firearm = 'WEAPON_PISTOL' },
    },

    -- When a scene turns violent, an "officer needs urgent assistance" call goes out (once per call).
    AutoUrgentAssistance = true,
    -- Missing people: a sighting near where they really are is passed on after this many minutes
    MissingSightingAfter = 5,

    -- Where calls happen. vec4 = position and heading. These are base-game examples: add your own.
    Locations = {
        shops = {
            { label = '24/7, Innocence Boulevard', coords = vec4(25.7, -1347.3, 29.5, 270.0) },
            { label = 'LTD, Grove Street', coords = vec4(-47.4, -1758.6, 29.4, 50.0) },
            { label = 'LTD, Mirror Park', coords = vec4(1163.4, -323.8, 69.2, 100.0) },
            { label = '24/7, Clinton Avenue', coords = vec4(373.8, 325.9, 103.6, 255.0) },
            { label = 'LTD, Little Seoul', coords = vec4(-706.1, -914.5, 19.2, 90.0) },
            { label = "Rob's Liquor, El Rancho Boulevard", coords = vec4(1134.2, -982.5, 46.4, 280.0) },
            { label = '24/7, Palomino Freeway', coords = vec4(2557.4, 382.3, 108.6, 355.0) },
            { label = '24/7, Sandy Shores', coords = vec4(1960.1, 3740.0, 32.3, 300.0) },
            { label = '24/7, Paleto Bay', coords = vec4(1728.7, 6415.7, 35.0, 245.0) },
        },
        streets = {
            { label = 'Legion Square', coords = vec4(195.2, -933.8, 30.7, 145.0) },
            { label = 'Vespucci Beach front', coords = vec4(-1222.6, -1490.4, 4.3, 125.0) },
            { label = 'Grove Street', coords = vec4(105.1, -1938.6, 20.8, 45.0) },
            { label = 'Mirror Park Boulevard', coords = vec4(1080.6, -683.2, 57.4, 90.0) },
            { label = 'Del Perro Pier', coords = vec4(-1640.8, -1015.3, 13.0, 50.0) },
            { label = 'Strawberry Avenue', coords = vec4(274.6, -1271.9, 29.3, 0.0) },
            { label = 'Sandy Shores, Alhambra Drive', coords = vec4(1886.4, 3741.0, 32.6, 210.0) },
        },
        houses = {
            { label = 'Forum Drive, Strawberry', coords = vec4(-14.3, -1441.5, 31.1, 180.0) },
            { label = 'Grove Street', coords = vec4(-46.6, -1797.2, 27.8, 50.0) },
            { label = 'Nikola Place, Mirror Park', coords = vec4(1229.4, -725.4, 60.9, 280.0) },
            { label = 'Vespucci Canals', coords = vec4(-1083.9, -1255.2, 5.4, 210.0) },
            { label = 'Rockford Hills', coords = vec4(-818.4, 177.8, 72.2, 110.0) },
            { label = 'Paleto Bay, Procopio Drive', coords = vec4(-445.6, 6260.3, 30.0, 70.0) },
        },
        roads = {
            { label = 'Vespucci Boulevard junction', coords = vec4(-140.3, -878.9, 29.3, 160.0) },
            { label = 'Route 68', coords = vec4(1023.9, 2672.3, 39.5, 270.0) },
            { label = 'Great Ocean Highway', coords = vec4(-2122.7, -364.7, 13.0, 160.0) },
            { label = 'Mirror Park Boulevard', coords = vec4(1036.3, -767.1, 57.9, 330.0) },
            { label = 'Joshua Road', coords = vec4(1393.5, 3594.5, 34.9, 200.0) },
        },
    },

    -- Ped models scenarios pick from
    Models = {
        male = { 'a_m_y_downtown_01', 'a_m_y_stbla_01', 'a_m_y_hipster_01', 'a_m_m_eastsa_01', 'a_m_y_genstreet_01', 'a_m_m_skater_01' },
        female = { 'a_f_y_hipster_02', 'a_f_m_downtown_01', 'a_f_y_genhot_01', 'a_f_y_eastsa_03' },
        elderly = { 'a_m_o_soucent_02', 'a_f_o_soucent_01', 'a_m_o_genstreet_01' },
        shopkeeper = { 'mp_m_shopkeep_01' },
        cars = { 'asea', 'premier', 'stanier', 'primo', 'blista', 'ingot', 'emperor', 'fugitive' },
    },
}
