--[[
    BS PROP PLACER  |  config.lua
    --------------------------------------------------------------------------
    British Scripts - Bradadorez & SwiftlyChillin
    This is the ONLY file you should normally need to edit.
    Every option below is read by the client, server and NUI at runtime.
--------------------------------------------------------------------------]]

Config = {}

--======================================================================
-- 1. FRAMEWORK & GENERAL
--======================================================================

-- 'auto' detects qbx_core / qb-core / es_extended automatically.
-- Force a specific one with 'qbcore', 'qbox' or 'esx' if auto-detect ever guesses wrong.
Config.Framework = 'auto'

Config.Locale = 'en'           -- language key, must match a table in locales/

-- How the placer menu is opened.
Config.OpenCommand = 'signs'   -- chat command: /signs
Config.OpenKey     = 'F7'      -- key binding (set to false to disable the keybind)

--======================================================================
-- 2. JOB RESTRICTION
--======================================================================
-- Only these jobs can open the menu and place/remove signs.
-- Leave the table EMPTY ( Config.Jobs = {} ) to allow everyone.
Config.Jobs = {
    'police',
    'ambulance',
    'fire',
}

-- Require the player to be on-duty (QBCore/Qbox job.onduty). ESX has no duty flag,
-- so this is ignored on ESX. Set false to allow off-duty placement.
Config.RequireDuty = false

--======================================================================
-- 3. PLACEMENT
--======================================================================
Config.Placement = {
    distanceDefault = 3.0,   -- starting distance of the ghost in front of the player (m)
    distanceMin     = 1.0,
    distanceMax     = 12.0,
    distanceStep    = 0.2,   -- how much scroll changes the distance
    rotateSpeed     = 90.0,  -- Q/E rotation speed in degrees PER SECOND (frame-rate independent)
    zOffset         = 0.0,   -- global vertical nudge if signs float/sink (tune in testing)
    maxServerRange  = 15.0,  -- server rejects placements further than this from the player (anti-cheat)
}

-- Maximum signs a single player may have placed at once (anti-spam).
Config.MaxPropsPerPlayer = 25

-- Hard cap across the whole server (safety valve). 0 = unlimited.
Config.MaxPropsTotal = 300

--======================================================================
-- 4. PICKUP  (via ox_target / qb-target)
--======================================================================
Config.Pickup = {
    target   = 'auto',                 -- 'auto' = detect ox_target then qb-target | 'ox' | 'qb'
    distance = 2.5,                    -- target interaction distance (m)
    label    = 'Remove sign',
    icon     = 'fa-solid fa-trash-can',
    -- Only players whose job is in Config.Jobs can see/use this (server-enforced too).
}

--======================================================================
-- ANIMATIONS (played when placing / picking up a sign)
--======================================================================
Config.Animations = {
    enabled = true,
    flag    = 0,    -- 0 = full-body one-shot | 49 = upper-body + allow movement
    place   = { dict = 'anim@mp_snowball', clip = 'pickup_snowball', duration = 900 },
    pickup  = { dict = 'anim@mp_snowball', clip = 'pickup_snowball', duration = 900 },
    -- Swap dict/clip for any valid GTA anim; a dict that fails to load is skipped gracefully.
}

--======================================================================
-- 5. AUTO-DELETE TIMER
--======================================================================
-- Removes forgotten signs after a while to keep the map clean.
Config.AutoDelete = {
    enabled = true,
    minutes = 30,     -- delete a sign this many minutes after it was placed
    checkInterval = 30, -- how often (seconds) the janitor scans. Low-frequency = cheap.
}

--======================================================================
-- 6. ROAD CLOSURE / TRAFFIC CONTROL
--======================================================================
-- Signs flagged closeRoad=true (see Config.Props) will stop NPC traffic routing
-- through their area by disabling the game's vehicle path nodes nearby.
Config.RoadClosure = {
    enabled          = true,
    radius           = 30.0,   -- default closure radius (m). Override per sign with `radius`.
    -- While placing a road-closure sign, Arrow Up/Down extends/shrinks the closure live:
    radiusMin        = 5.0,
    radiusMax        = 80.0,
    radiusStep       = 2.5,
    disablePeds      = false,  -- also stop NPCs on foot walking through the area
    reassertInterval = 3000,   -- ms; re-disables nodes periodically (engine resets them on stream-in)

    -- When NPC traffic reaches a closure, bring it to a STOP so it doesn't drive through the
    -- sign (non-destructive - cars brake and wait, they are NOT deleted). This is the default
    -- and what makes a closure actually work. Set false to rely on path-node disabling only.
    haltTraffic      = true,

    -- Actively DELETE AI traffic that enters a closure - the only way NPCs truly "obey" a
    -- closed road (disabling path nodes alone is just a soft deterrent). This is the
    -- DEFAULT for new closures; you can also flip it per-sign with [G] while placing.
    -- Never touches a player or occupied vehicle.
    despawnVehicles  = true,
    despawnInterval  = 1000,   -- ms between despawn scans (only runs while a closure is active)
}

--======================================================================
-- SPEED ZONES  (speed-limit signs slow nearby NPC traffic)
--======================================================================
-- A sign with a `speedZone` value caps AI-driven vehicles that enter its radius
-- to that speed. Players are NOT affected by default. The radius can be sized
-- live while placing (Arrow Up/Down), same as road closures.
Config.SpeedZone = {
    enabled       = true,
    units         = 'mph',    -- 'mph' (UK) or 'kph' - affects how `speedZone` numbers are read
    radius        = 25.0,     -- default radius (m); per-sign `radius` overrides
    radiusMin     = 5.0,
    radiusMax     = 80.0,
    radiusStep    = 2.5,
    interval      = 500,      -- ms between speed scans (only runs while a zone exists)
    releaseSpeed  = 80.0,     -- m/s "uncap" applied when a vehicle leaves the zone
                              -- (~179mph; the vehicle's own model still limits real speed)
    affectPlayers = false,    -- true also caps player-driven vehicles (kept false)
}

--======================================================================
-- 7. ADMIN
--======================================================================
Config.Admin = {
    command = 'clearprops',          -- /clearprops wipes every sign placed by this resource
    acePermission = 'propplacer.admin', -- grant in server.cfg: add_ace group.admin propplacer.admin allow
    -- Fallback framework groups allowed to run admin commands if they lack the ACE above.
    frameworkGroups = { 'admin', 'superadmin', 'god' },
}

--======================================================================
-- 8. PROP CATALOGUE
--======================================================================
-- Tab order shown in the UI.
Config.Categories = { 'Warning', 'Prohibitory', 'Speed', 'Mandatory', 'Stop', 'Information', 'Traffic' }

--[[ Each entry:
       model     = exact archetype / .ydr name to spawn (must be streamed by your sign resource)
       label     = friendly name shown in the UI
       category  = one of Config.Categories (drives the tabs)
       image     = thumbnail file in html/img/  (onerror falls back to _placeholder.svg)
       closeRoad = (optional) true to make this sign close the road around it
       radius    = (optional) per-sign closure radius override
       zOffset   = (optional) per-sign vertical nudge
       speedZone = (optional) number (mph) -> caps NPC vehicles near the sign to that speed

     All 55 models use clean archetype names (e.g. 'no_overtaking', 'speed_30', 'traffic_cone').
     Prune any you don't want to sell, or add new signs by dropping in one more line. ]]
Config.Props = {

    ---------------------------------------------------------- WARNING (red triangle)
    { model = 'warning_slippery_road',       label = 'Slippery Road',       category = 'Warning', image = '01_slippery-road.png' },
    { model = 'warning_bend',                label = 'Bend',                category = 'Warning', image = '02_bend-right.png' },
    { model = 'warning_double_bend',         label = 'Double Bend',         category = 'Warning', image = '03_double-bend.png' },
    { model = 'warning_road_narrows',        label = 'Road Narrows',        category = 'Warning', image = '04_road-narrows-both.png' },
    { model = 'warning_crossroads',          label = 'Crossroads',          category = 'Warning', image = '05_crossroads-ahead.png' },
    { model = 'warning_t_junction',          label = 'T-Junction',          category = 'Warning', image = '06_t-junction.png' },
    { model = 'warning_roundabout_ahead',    label = 'Roundabout Ahead',    category = 'Warning', image = '07_roundabout-ahead.png' },
    { model = 'warning_uneven_road',         label = 'Uneven Road',         category = 'Warning', image = '08_road-hump.png' },
    { model = 'warning_pedestrian_crossing', label = 'Pedestrian Crossing', category = 'Warning', image = '09_pedestrian-crossing.png' },
    { model = 'warning_pedestrians',         label = 'Pedestrians',         category = 'Warning', image = '09_pedestrian-crossing.png' },
    { model = 'warning_traffic_signals',     label = 'Traffic Signals',     category = 'Warning', image = '12_traffic-signals.png' },
    { model = 'warning_wild_animals',        label = 'Wild Animals',        category = 'Warning', image = '13_wild-animals.png' },
    { model = 'warning_falling_rocks',       label = 'Falling Rocks',       category = 'Warning', image = '14_falling-rocks.png' },
    { model = 'warning_cyclists',            label = 'Cyclists',            category = 'Warning', image = '11_cycle-route.png' },
    { model = 'warning_roadworks',           label = 'Road Works',          category = 'Warning', image = '50_road-works.png' },
    { model = 'warning_two_way_traffic',     label = 'Two-Way Traffic',     category = 'Warning', image = '49_two-way-traffic.png' },
    { model = 'warning_blank_triangle',      label = 'Warning (blank)',     category = 'Warning', image = '_placeholder.svg' },

    ---------------------------------------------------------- PROHIBITORY (red circle)
    { model = 'no_motor_vehicles',    label = 'No Motor Vehicles',      category = 'Prohibitory', image = '16_no-motor-vehicles.png', closeRoad = true },
    { model = 'no_overtaking',        label = 'No Overtaking',          category = 'Prohibitory', image = '17_no-overtaking.png' },
    { model = 'no_u_turn',            label = 'No U-Turn',              category = 'Prohibitory', image = '18_no-u-turn.png' },
    { model = 'no_left_turn',         label = 'No Left Turn',           category = 'Prohibitory', image = '19_no-left-turn.png' },
    { model = 'no_right_turn',        label = 'No Right Turn',          category = 'Prohibitory', image = '20_no-right-turn.png' },
    { model = 'no_waiting',           label = 'No Waiting',             category = 'Prohibitory', image = '21_no-waiting.png' },
    { model = 'no_stopping_clearway', label = 'Clearway (No Stopping)', category = 'Prohibitory', image = '22_no-stopping-clearway.png' },
    { model = 'no_cycling',           label = 'No Cycling',             category = 'Prohibitory', image = '23_no-cycling.png' },
    { model = 'no_pedestrians',       label = 'No Pedestrians',         category = 'Prohibitory', image = '24_no-pedestrians.png' },

    ---------------------------------------------------------- SPEED (red circle)
    { model = 'speed_20',             label = 'Speed Limit 20',       category = 'Speed', image = '25_speed-20.png', speedZone = 20 },
    { model = 'speed_30',             label = 'Speed Limit 30',       category = 'Speed', image = '26_speed-30.png', speedZone = 30 },
    { model = 'speed_40',             label = 'Speed Limit 40',       category = 'Speed', image = '27_speed-40.png', speedZone = 40 },
    { model = 'speed_50',             label = 'Speed Limit 50',       category = 'Speed', image = '28_speed-50.png', speedZone = 50 },
    { model = 'speed_60',             label = 'Speed Limit 60',       category = 'Speed', image = '29_speed-60.png', speedZone = 60 },
    { model = 'speed_70',             label = 'Speed Limit 70',       category = 'Speed', image = '30_speed-70.png', speedZone = 70 },
    { model = 'national_speed_limit', label = 'National Speed Limit', category = 'Speed', image = '31_national-speed-limit.png', speedZone = 60 },
    { model = 'speed_minimum_30',     label = 'Minimum Speed 30',     category = 'Speed', image = '32_minimum-speed-30.png' },

    ---------------------------------------------------------- MANDATORY (blue circle)
    { model = 'ahead_only',       label = 'Ahead Only',         category = 'Mandatory', image = '33_ahead-only.png' },
    { model = 'turn_left_ahead',  label = 'Turn Left Ahead',    category = 'Mandatory', image = '34_turn-left-ahead.png' },
    { model = 'turn_right_ahead', label = 'Turn Right Ahead',   category = 'Mandatory', image = '35_turn-right-ahead.png' },
    { model = 'keep_left',        label = 'Keep Left',          category = 'Mandatory', image = '41_turn-left.png' },
    { model = 'mini_roundabout',  label = 'Mini Roundabout',    category = 'Mandatory', image = '38_mini-roundabout.png' },
    { model = 'pass_either_side', label = 'Pass Either Side',   category = 'Mandatory', image = '39_pass-either-side.png' },
    { model = 'cycle_route',      label = 'Cycle Route',        category = 'Mandatory', image = '40_cycle-route-only.png' },
    { model = 'lane_arrow_left',  label = 'Lane Arrow (Left)',  category = 'Mandatory', image = '36_keep-left.png' },
    { model = 'lane_arrow_right', label = 'Lane Arrow (Right)', category = 'Mandatory', image = '37_keep-right.png' },

    ---------------------------------------------------------- STOP
    { model = 'stop', label = 'Stop', category = 'Stop', image = '42_stop.png', closeRoad = true },

    ---------------------------------------------------------- INFORMATION
    { model = 'one_way_right',          label = 'One Way',                category = 'Information', image = '44_one-way.png' },
    { model = 'parking',                label = 'Parking',                category = 'Information', image = '45_parking.png' },
    { model = 'no_through_road',        label = 'No Through Road',        category = 'Information', image = '46_no-through-road.png' },
    { model = 'priority_over_oncoming', label = 'Priority Over Oncoming', category = 'Information', image = '47_priority-over-oncoming.png' },
    { model = 'two_way_arrows',         label = 'Give Priority',          category = 'Information', image = '48_give-priority-to-oncoming.png' },

    ---------------------------------------------------------- TRAFFIC MANAGEMENT (cones / barriers / works)
    { model = 'traffic_cone',            label = 'Traffic Cone',      category = 'Traffic', image = 'cone-orange.jpg', closeRoad = true, radius = 8.0 },
    { model = 'traffic_cone_no_waiting', label = 'No Waiting Cone',   category = 'Traffic', image = 'cone-no-waiting.webp', closeRoad = true, radius = 8.0 },
    { model = 'barrier',                 label = 'Barrier',           category = 'Traffic', image = 'barrier-construction.webp', closeRoad = true, radius = 12.0 },
    { model = 'road_ahead_closed',       label = 'Road Ahead Closed', category = 'Traffic', image = 'road-ahead-closed.jpg', closeRoad = true },
    { model = 'diversion_left',          label = 'Diversion (Left)',  category = 'Traffic', image = 'diversion-left.webp' },
    { model = 'diversion_right',         label = 'Diversion (Right)', category = 'Traffic', image = 'diversion-right.webp' },
}

-- Build a fast model -> definition lookup (used by the secure server callback to
-- reject any model that isn't in this catalogue). Do not edit below.
Config.PropIndex = {}
for _, p in ipairs(Config.Props) do
    Config.PropIndex[p.model] = p
end
