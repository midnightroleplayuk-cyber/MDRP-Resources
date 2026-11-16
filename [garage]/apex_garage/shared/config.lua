--[[============================================================================
    apex_garage — shared/config.lua   (open source, edit freely)
    ----------------------------------------------------------------------------
    Server-authoritative vehicle garage for ESX Legacy / QBCore / QBox.
    Same Apex design language as apex_dealerships / apex_bossmenu.

    Everything the owner is expected to touch lives in this one file. It is
    heavily commented on purpose — read the block above each section before
    editing it.
============================================================================]]

Config = Config or {}

-- ============================================================================
-- CORE
-- ============================================================================

-- 'auto' lets the framework bridge detect qbx_core / qb-core / es_extended.
-- Pin it ('esx' | 'qb' | 'qbx') only if detection ever guesses wrong.
Config.framework = 'auto'

Config.locale   = 'en'          -- key into locales/*.lua
Config.debug    = false         -- prints Utils.Debug lines
-- The ace that makes someone an admin of THIS resource: the in-game garage
-- creator (/apexgarage), the theme editor, the parking settings, and the
-- destructive staff commands (/vreturn, /vplate, /dvdb).
--
-- Grant it in server.cfg, e.g.:
--     add_ace group.admin apex_garage.admin allow
--
-- Deliberately NOT 'command': that generic ace is held by anyone allowed to run
-- any command on most servers, and /dvdb deletes a vehicle from the database.
Config.adminAce = 'apex_garage.admin'   -- IsPlayerAceAllowed(src, ace)

Config.currency = { symbol = '£', position = 'before' }   -- 'before' -> $1,000 · 'after' -> 1,000$

Config.notify = {
    title    = 'Apex Garage',
    position = 'top-right',      -- ox_lib notify position
    duration = 4000,
}

-- Use the static garages defined at the bottom of this file?
--   true  -> the config garages are layered together with the ones you create
--            in-game with /apexgarage. This is the shipped default: out of the
--            box you get working garages, an impound lot and blips with no
--            setup at all. (Edited a coordinate and nothing moved? See the
--            "EDITING THESE GARAGES" note above Config.garages.)
--   false -> ONLY the garages created in-game are active. Config.garages is
--            ignored EVERYWHERE — blips, zones, garage resolution, and the
--            impound lot. Turn this off only once you have built your own
--            garages in the panel, INCLUDING an impound one, or the resource
--            has nothing to open.
Config.useConfigGarages = true

-- The default garage every existing owned vehicle is filed under on first boot
-- (the DB migration sets garage_id to this for rows that have none).
Config.defaultGarage = 'legion'

-- Where impounded vehicles land when no lot is nearer the officer.
Config.defaultImpound = 'city_impound'

-- When false, every personal garage shows ALL of a player's vehicles (classic
-- ESX behaviour). When true, a vehicle only appears at the exact garage it was
-- stored in. Can be overridden per garage with `unique = true/false`.
Config.uniqueGarages = false

-- Chat commands (all admin/officer gated where relevant).
Config.commands = {
    impound        = 'iv',              -- officer: impound the nearest vehicle
    privateGarages = 'privategarages',  -- realestate/admin: quick private garage menu
    admin          = 'apexgarage',      -- admin: create / edit / delete garages in-game
    jobGarage      = 'jobgarage',       -- job boss: manage the company garage vehicles
    returnVehicle  = 'vreturn',         -- admin: force a plate back into its garage
    changePlate    = 'vplate',          -- admin: change a vehicle's plate
    deleteVehicle  = 'dvdb',            -- admin: delete a vehicle from the DB
    park           = 'park',            -- park the car you're driving anywhere (persistent)
    release        = 'unpark',          -- take your nearest parked car OUT of the parked
                                        -- state and drive it away (it stays where it is;
                                        -- the on-foot /park still sends it to the garage)
    where          = 'garagewhere',     -- anyone: which garage is nearest, where it comes
                                        -- from (config file or /apexgarage) and its
                                        -- coordinates, as the running build loaded them
}

-- ============================================================================
-- INTERACTION
-- ============================================================================

Config.interactKey     = 38     -- E
Config.interactDistance = 2.4   -- show the 3D "E" prompt within this range
Config.spawnClearRadius = 2.6   -- a spawn slot is "free" if no vehicle is this close
Config.warpIntoVehicle  = true  -- teleport the player into the car they pull out

-- Hold E instead of tapping it, with a progress outline drawn around the icon
-- badge of the built-in TextUI. Set enabled = false to restore the old
-- single-press behaviour (the prompt then fires the moment E is released).
-- Only the zone prompt holds; the admin "back to the panel" prompt stays instant.
Config.holdToOpen = {
    enabled  = true,
    duration = 400,   -- ms you must hold the key
}

-- Use ox_target instead of the proximity marker + keypress. When true the
-- world marker/prompt is skipped and each garage gets a target zone.
Config.useTarget = false

-- Which TextUI draws the "[E] Open garage" prompt in the zones.
--
--   provider:
--     'default' -> the built-in NUI pill that ships with this resource (the
--                  round brand-blue icon badge + sentence). No dependencies.
--     'ox_lib'  -> lib.showTextUI / lib.hideTextUI          (needs ox_lib)
--     'qb'      -> qb-core:client:DrawText / :HideText      (needs qb-core or qbx_core)
--     'okok'    -> exports.okokTextUI:Open / :Close         (needs okokTextUI)
--     'esx'     -> ESX.TextUI / ESX.HideUI                  (needs esx_textui)
--     'none'    -> draw nothing at all. For servers that already render their
--                  own prompt from a HUD resource and just want the keypress.
--
--   If the chosen provider's resource is not actually running we silently fall
--   back to 'default' — a missing dependency must never leave the player with
--   no prompt at all.
--
--   position: only used by the 'default' provider (the third-party ones are
--   positioned in their own config). 'right' | 'left' | 'top' | 'bottom'.
--   'right'/'left' are vertically centred against that edge; 'bottom' is the
--   classic bottom-centre pill.
Config.textui = {
    provider = 'default',
    position = 'right',
}

-- ============================================================================
-- VEHICLE PERSISTENCE
-- ============================================================================

Config.saveDamage      = true   -- persist body/engine health + door/window/tyre state
Config.checkVehicleModel = true -- refuse to spawn a model the client doesn't have

-- Anti-dupe: a vehicle already out in the world cannot be pulled again. Set a
-- category to true to lift that lock for it.
Config.allowInfiniteSpawns = false            -- personal garages
Config.jobAllowInfiniteSpawns = true          -- job spawner garages ignore the dupe lock
Config.gangAllowInfiniteSpawns = true

--[[ NOBODY VANISHES WITH THE CAR.
     ------------------------------------------------------------------------
     Three of this resource's actions destroy a vehicle entity: storing it,
     recovering one that was left out in the world, and impounding one. Each of
     them used to fire regardless of who was sitting in the seats, so a
     passenger — a hitchhiker, a hostage, a colleague on a ride-along — was
     deleted along with the car and dropped wherever the car happened to be.
     On a roleplay server that ends the scene outright, and the player it
     happens to has no way to see it coming.

     With the guard on, an action whose vehicle has another PLAYER aboard is
     refused and says so, on the button as well as in the notification. NPC
     passengers never block anything: an NPC disappearing with the car costs
     nobody a scene, and a stray pedestrian who wandered into a seat would
     otherwise make a car permanently unstorable.

     `self` is the one deliberate exception on the store path. The player doing
     the storing is by definition the driver, and refusing to store a car
     because its own driver is in it would refuse every store there is. ]]
Config.occupantGuard = {
    enabled = true,    -- master switch; false restores the old delete-anyway behaviour
    store   = true,    -- refuse to store a car that has passengers aboard
    recover = true,    -- refuse to recover/tow a car that has players aboard
    impound = true,    -- refuse to impound a car that has players aboard
}

-- ============================================================================
-- ECONOMY
-- ============================================================================

-- Reclaiming a vehicle that was left out in the world (server restart, blown
-- up, sunk, abandoned) costs a towing tax. 0 disables it.
Config.returnCost        = 850
Config.returnCostSociety = nil          -- job name to receive the fee, or nil to void it

-- Moving a car from one personal garage to another.
Config.transferGarageCost = 500
Config.enableGarageTransfer = true

-- Handing a vehicle to another (nearby, online) player.
Config.enablePlayerTransfer = true
Config.transferPlayerRadius = 20.0
Config.transferBlacklist = {           -- spawn names that can never be transferred to players
    -- 'adder', 'zentorno',
}
Config.disableTransferToUnregistered = true   -- block transfers to garage ids that aren't in Config.garages

-- ============================================================================
-- INSTANT SELL
-- ============================================================================

-- Selling a car straight from the garage. The payout is a percentage of the
-- apex_dealerships catalog price, so this whole feature is inert unless that
-- resource is running — there is no price to quote otherwise.
Config.instantSell = {
    enabled = true,
    percent = 50,        -- % of the dealership catalog price paid out
    account = 'bank',    -- where the money lands
}

-- ============================================================================
-- IMPOUND
-- ============================================================================

-- Hours offered in the impound form. 0 = "no fixed time / officer discretion".
Config.impoundTimeOptions = { 0, 2, 6, 24, 48, 120, 336 }
Config.impoundFeeSociety  = nil        -- job name that receives paid retrieval fees, or nil

-- Which account the retrieval fee comes out of.
--   'bank' -> bank only. Not enough in the bank fails the collection even if the
--             player is carrying the cash. Realistic for a fine paid at a counter.
--   'cash' -> cash only. Same rule the other way round.
--   'any'  -> bank first, then cash. The historic behaviour and the forgiving one.
-- Officers are never charged, whatever this says.
Config.impoundAccount = 'any'

-- ============================================================================
-- PRIVATE GARAGES  (DB-backed, created in-game)
-- ============================================================================

Config.privateGarages = {
    enabled      = true,
    createJobs   = { 'realestate' },   -- jobs allowed to run /privategarages (admins always can)
    blip         = { sprite = 357, colour = 4, scale = 0.65 },
    defaultDistance = 2.4,
}

-- ============================================================================
-- CATEGORIES  (vehicle classes a garage can accept)
--   key must match a garage's `class` and a vehicle's resolved domain.
-- ============================================================================

Config.categories = {
    { key = 'car', label = 'Ground', icon = 'fa-car' },
    { key = 'air', label = 'Air',    icon = 'fa-helicopter' },
    { key = 'sea', label = 'Sea',    icon = 'fa-ship' },
}

-- Native GTA vehicle classes -> our domain. Used to reject storing a boat at a
-- car garage, and to file freshly-owned vehicles under the right type.
Config.classDomain = {
    [8]  = 'car',  -- motorcycles
    [13] = 'car',  -- cycles
    [14] = 'sea',  -- boats
    [15] = 'air',  -- helicopters
    [16] = 'air',  -- planes
    -- everything else defaults to 'car'
}

-- ============================================================================
-- VEHICLE IMAGES  (same method as apex_dealerships)
--   The NUI tries, in order: your own file html/images/<spawncode>.<ext>,
--   then the fallback URL, then a monogram tile.
-- ============================================================================

Config.vehicleImages = {
    enabled     = true,      -- false: never show pictures, always the monogram
    custom      = true,      -- false: skip html/images/ and go straight to the URL
    extensions  = { 'png', 'jpg', 'jpeg', 'webp' },   -- tried in this order
    -- %s is the spawn code. Set to false to use ONLY your own images.
    -- Accepts a single URL or a LIST of sources, tried in order — no CDN has
    -- every vehicle (e.g. the docs site is missing some base cars), so chain
    -- them. A file in html/images/ always wins over any URL, which is the
    -- guaranteed fix for a stubborn model: drop html/images/<spawncode>.png
    fallbackUrl = {
        'https://docs.fivem.net/vehicles/%s.webp',
    },
}

-- ============================================================================
-- THEME  (mirrors apex_dealerships / apex_bossmenu — flat Apex blue)
--   Only three colours; the NUI derives the rest at runtime.
-- ============================================================================

-- These are only the DEFAULTS: admins can re-skin the whole UI live in
-- /apexgarage -> Appearance, and that choice is stored server-side and pushed
-- to every player.
Config.theme = { brand = '#1F5EFF', brandDark = '#0048F0', bg = '#131314' }

-- Blip presets per garage kind. A garage may override with its own `blip`.
Config.blips = {
    show    = true,
    garage  = { sprite = 357, colour = 38, scale = 0.72 },  -- personal / public
    job     = { sprite = 357, colour = 3,  scale = 0.72 },
    gang    = { sprite = 357, colour = 1,  scale = 0.72 },
    impound = { sprite = 68,  colour = 47, scale = 0.80 },
}

-- ============================================================================
-- VEHICLE KEYS
-- ============================================================================

-- Which key resource receives the keys when a vehicle is pulled out / stored.
--   'auto'       -> detect and feed every supported key resource that is running
--                   (qbx_vehiclekeys, qb-vehiclekeys, wasabi_carlock,
--                    qs-vehiclekeys, MrNewbVehicleKeys, Renewed-Vehiclekeys,
--                    tgiann-hotwire, vehicles_keys, codem-vehiclekeys,
--                    ti_vehicleKeys, rcore_carkeys, brutal_vehiclekeys,
--                    mono_carkeys, cd_garage, okokGarage, mk_vehiclekeys,
--                    t1ger_keys, ak47_vehiclekeys, F_RealCarKeysSystem,
--                    xd_locksystem, esx_vehiclelock)
--   'none'       -> never touch keys (your own script handles it elsewhere)
--   '<resource>' -> use ONLY that provider, skipping detection. Pin this if
--                   two key resources are running and only one should win.
--
-- ⚠ THE KEY IS NOW GIVEN ON BOTH SIDES. Most key resources own the key on the
-- SERVER, and a client-only grant is what made a key last until the car was
-- stored or the player relogged — "I have to lockpick my own car every time".
-- The server half runs from confirmSpawn, which is the one point on the
-- take-out path where the server has already proved the player owns the claim.
--
-- Run /garagekeys in the SERVER CONSOLE to see which key resources are running,
-- which ones this resource feeds, whether each has a server half, and what the
-- last attempt actually did. That is the command to ask a customer for.
--
-- Need something custom? Define Integrations.CustomGiveKeys /
-- Integrations.CustomRemoveKeys (client) or Integrations.CustomGiveKeysServer /
-- Integrations.CustomRemoveKeysServer (server) in shared/integrations.lua —
-- they override everything above.
Config.vehicleKeys = 'auto'

-- ============================================================================
-- VEHICLE PREVIEW  (showroom-style)
--   Selecting a vehicle in the garage list spawns a LOCAL-ONLY copy of it at
--   the garage's first spawn slot, seats you in the driver's seat and orbits a
--   camera around it. The car is never networked, so nobody else can see it.
--
--   useRoutingBucket: your PED is networked, so without this other players
--   would see you sitting in mid-air. When true the server moves you into a
--   private routing bucket (70000 + your server id) for the duration of the
--   preview and puts you back in bucket 0 the moment you close the garage,
--   pull a car out, disconnect, or the resource restarts. Turn it off only if
--   another script of yours already manages routing buckets for these players.
--
--   min/maxRadius: how close / far the orbit camera may sit. The radius is
--   sized from the model's own dimensions between these two bounds, so a bike
--   gets framed tightly and a Titan still fits on screen.
-- ============================================================================

Config.preview = {
    enabled          = true,
    autoRotate       = true,    -- start the turntable spinning on open
    useRoutingBucket = true,    -- hide the player from everyone else (recommended)
    minRadius        = 4.0,
    maxRadius        = 28.0,
}

-- ============================================================================
-- PERSISTENT PARKING  (/park, /unpark)
--   A player parks the car they are driving anywhere in the world and it stays
--   there through restarts: the row is stored in `apex_garage_parked` and the
--   vehicle is re-created server-side on boot, so everyone sees the same car.
--   While parked, the owned_vehicles row is flagged in_garage = 0 — the car can
--   never be pulled from a garage at the same time.
--
--   Every value here is only a DEFAULT: admins can change them live in
--   /apexgarage -> Parking, and those overrides are stored in
--   `apex_garage_settings` and win at boot.
-- ============================================================================

Config.parking = {
    enabled = true,          -- master switch for the whole feature

    -- Who may park:
    --   'public'     -> everyone
    --   'job'        -> only the jobs listed below
    --   'permission' -> only identifiers granted in the admin panel
    -- Admins (Config.adminAce) are always allowed, in every mode.
    mode = 'public',
    jobs = { 'police' },     -- used by mode = 'job'

    -- true: other vehicles drive straight THROUGH a parked car (no collision).
    -- Recommended on busy streets — a frozen car with collision is a road block.
    noCollision = true,

    maxPerPlayer  = 2,       -- how many cars one player may leave parked (0 = unlimited)
    overlapRadius = 3.5,     -- refuse to park this close to another parked car

    -- Allow society/gang vehicles (job_vehicle / gang_vehicle rows) to be parked.
    -- Off by default: one member could otherwise strand the whole fleet.
    allowJobVehicles = false,

    -- Refuse /park inside a garage's own zone, so nobody blocks the spawn slots
    -- of the garage they just came out of. Admin-drawn no-parking areas (the
    -- "No-parking zones" list in /apexgarage) are always enforced on top.
    blockInGarageZones = false,

    -- Extra breathing room, in ms, between the driver being out of the seat and
    -- the persistent copy taking the car's place.
    --
    -- The server already waits for the seat to actually empty before swapping the
    -- car (waitPedOut, server/modules/parking.lua) — this is on TOP of that. It
    -- exists because "out of the seat" and "finished climbing out and standing on
    -- the pavement" are not the same instant: the swap is invisible, but doing it
    -- while the exit animation is still playing can shove the ped or make the car
    -- appear to twitch. Raise it if the hand-off still looks abrupt on your server.
    -- 0 disables the extra wait entirely.
    exitDelay = 800,
}

-- ============================================================================
-- DISCORD WEBHOOKS
--   Configured in  server/webhook_config.lua  — NOT here.
--
--   This file is a shared_script: every player who connects downloads it. A
--   webhook URL is effectively a password (anyone holding it can post into your
--   channel or delete the webhook), so the URLs live in a server-only file that
--   never leaves your machine. Open server/webhook_config.lua to set them; it is
--   commented the same way as this file and everything is off by default.
-- ============================================================================

-- ============================================================================
-- GARAGES
--   Keyed by a UNIQUE id — that id is what gets written to owned_vehicles.garage_id.
--
--   type  : 'public' | 'job' | 'gang' | 'impound'   (access model / garageType)
--   class : 'car' | 'air' | 'sea'                    (vehicle class it accepts)
--   access: vector3  interaction / open point (also the blip)
--   store : vector3? optional separate "store your car here" point
--   spawns: { vector4, ... }  slots the car is pulled out at
--   unique: bool  when true, only vehicles whose garage_id == this id show here
--                 (when false/absent, a personal garage shows ALL your vehicles)
--
--   job/gang garages add:  job|gang = { 'name', ... }, minGrade = n,
--     vehiclesType = 'personal' | 'owned' | 'spawner'
--     vehicles = { { model=, plate=, nickname=, livery=, extras={}, minGrade= }, ... }  (spawner only)
--       paint (optional, spawner only — omit and the car uses the model's own
--       default paint, which is fixed, never random):
--         color1 = n | {r,g,b}   primary   (palette index, or a custom RGB colour)
--         color2 = n | {r,g,b}   secondary
--         colorCombination = n   carvariations index instead (0 = model default)
--
--   impound garages add:  job = { 'police', ... }  (officers who can release),
--     fee = n  (fallback retrieval fee if the record has none)
--   radius: number? how close (metres) the player has to be to the `access`
--     point for the prompt; defaults to Config.interactDistance. Raise it on a
--     boathouse, where the access point sits on a ramp at water level.
--
-- ⚠ EDITING THESE GARAGES — read this before you change a coordinate.
--
--   1. This file is a shared script: it is read ONCE, when the resource starts.
--      After editing it run `restart apex_garage` in the server console (or
--      restart the resource from txAdmin). `refresh` alone does nothing, and
--      players do NOT have to reconnect — the resource restart sends them the
--      new file. If nothing moves after a real restart, the server is loading a
--      different copy of the resource than the one you edited: look for a
--      second `apex_garage` folder anywhere under resources/ (txAdmin warns
--      about duplicates on boot) and for the path printed by `garagediag`.
--
--   2. Garages created in-game with /apexgarage are NOT in this file. They live
--      in the database (`apex_garage_garages`) and are edited in /apexgarage
--      too — editing a vector here never moves one of those. Since 1.1.7 the
--      /apexgarage list shows BOTH kinds, each tagged with where it comes from,
--      and `garagediag` (server console, or F8 in-game) prints every garage the
--      running build actually loaded, with its coordinates and its source.
--
--   3. The locations below are the classic public parking lots the community
--      garages use (Legion Square, Pillbox, the LSIA hangar, the LSYMC
--      boathouse, ...), so the spawn slots sit on real parking spaces. Keep the
--      ids: `garage_id` in the vehicle table refers to them.
-- ============================================================================

Config.garages = {

    -- ---- Public personal garages -------------------------------------------
    -- Legion Square — the public parking lot between Legion Square and Pillbox
    -- Hill (the classic "Legion Square Garage"). Five marked bays.
    legion = {
        label = 'Legion Square', type = 'public', class = 'car',
        access = vector3(213.20, -796.05, 30.86),
        spawns = {
            vector4(222.02, -804.19, 30.26, 248.19),
            vector4(223.93, -799.11, 30.25, 248.53),
            vector4(226.46, -794.33, 30.24, 248.29),
            vector4(232.33, -807.97, 30.02, 69.17),
            vector4(234.42, -802.76, 30.04, 67.20),
        },
    },
    -- San Andreas Avenue parking, next to the Vinewood Blvd / Pillbox border.
    sapcounsel = {
        label = 'San Andreas Parking', type = 'public', class = 'car',
        access = vector3(-330.01, -780.33, 33.96),
        spawns = { vector4(-341.57, -767.45, 33.56, 92.61) },
    },
    -- Vespucci beach front parking.
    beach = {
        label = 'Beach Parking', type = 'public', class = 'car',
        access = vector3(-1185.32, -1500.64, 4.38),
        spawns = { vector4(-1188.14, -1487.95, 3.97, 124.06) },
    },
    -- Long-stay parking by the LSIA terminal.
    airport = {
        label = 'Airport Parking', type = 'public', class = 'car',
        access = vector3(-773.12, -2033.04, 8.88),
        spawns = { vector4(-779.77, -2040.18, 8.47, 315.34) },
    },
    -- Harmony: The Motor Hotel parking lot on Route 68.
    mirror = {
        label = 'The Motor Hotel', type = 'public', class = 'car',
        access = vector3(1137.77, 2663.54, 37.90),
        spawns = { vector4(1127.70, 2647.84, 37.58, 1.41) },
    },
    -- Sandy Shores: the lot opposite the Alamo Sea shore.
    sandy = {
        label = 'Sandy Shores', type = 'public', class = 'car',
        access = vector3(1737.03, 3718.88, 34.05),
        spawns = { vector4(1725.40, 3716.78, 34.15, 20.54) },
    },
    -- Paleto Bay: the Bell Farms lot on the Great Ocean Highway.
    paleto = {
        label = 'Paleto Bay', type = 'public', class = 'car',
        access = vector3(76.88, 6397.30, 31.23),
        spawns = { vector4(62.15, 6403.41, 30.81, 211.38) },
    },

    -- ---- Air / Sea ---------------------------------------------------------
    -- LSIA: the hangar row on the south apron.
    lsia_hangar = {
        label = 'Hangar LSIA', type = 'public', class = 'air',
        access = vector3(-979.06, -2995.48, 13.95),
        spawns = { vector4(-998.37, -2985.01, 13.95, 61.09) },
    },
    -- LSYMC boathouse, Puerto Del Sol marina. The access point is on the boat
    -- ramp at water level, so the radius is wider than the land garages'.
    marina = {
        label = 'LSYMC Boathouse', type = 'public', class = 'sea',
        access = vector3(-785.95, -1497.84, -0.09),
        radius = 4.0,
        spawns = { vector4(-796.64, -1502.60, -0.09, 111.49) },
    },

    -- ---- Job garage (society owned vehicles) -------------------------------


    -- ---- Job garage (fixed spawner list, no DB) ----------------------------
    -- Pillbox Hill Medical Center: the ambulance bay on the lower car park.
    ambulance = {
        label = 'EMS Garage', type = 'job', class = 'car',
        job = { 'ambulance' }, minGrade = 0,
        vehiclesType = 'spawner',
        access = vector3(294.58, -574.76, 43.18),
        spawns = { vector4(294.58, -574.76, 43.18, 35.79) },
        vehicles = {
            { model = 'ambulance', nickname = 'Ambulance', minGrade = 0 },
            { model = 'polambulance', nickname = 'Rapid Response Unit', minGrade = 2 },
        },
    },

    -- ---- Impound -----------------------------------------------------------
    -- The Davis depot lot (Innocence Blvd).
    city_impound = {
        label = 'City Impound', type = 'impound', class = 'car',
        job = { 'police' }, fee = 2500,
        access = vector3(401.76, -1632.57, 29.29),
        spawns = { vector4(396.55, -1643.93, 28.88, 321.91) },
    },
}
