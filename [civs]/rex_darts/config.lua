--[[
    Rex Darts - Rex Studio (rex-studio.com)
    This file is NOT encrypted by escrow. Every option is commented.
    Board geometry values marked (est.) come from the model bounding boxes:
    fine-tune them in game with /dartscalibrate (saved to data/calibration.json).
]]

Config = {}

-- 'auto' | 'esx' | 'qb' | 'qbox' | 'standalone'
Config.Framework = 'qbox'

-- 'en' | 'fr'  (locales/*.lua, add your own freely)
Config.Locale = 'en'

-- 'ox' (ox_lib notify) | 'framework' (ESX / QB notification)
Config.Notify = 'ox'

-- 'auto' | 'ox_target' | 'qb-target' | 'none'  ('none' = [E] prompt)
Config.Target = 'ox_target'

-- ACE permission for /dartsadmin, /dartscalibrate, /dartsplace
-- server.cfg:  add_ace group.admin rexdarts.admin allow
Config.AdminAce = 'rexdarts.admin'

Config.Debug = false

---------------------------------------------------------------------------------------------------
-- Boards
---------------------------------------------------------------------------------------------------
-- Vanilla dartboard models. Every prop of these models on the map becomes playable
-- (Yellow Jack Inn, MC clubhouses, MLOs that use the vanilla props, boards you place).
-- offset : board centre from the model origin (model axes, metres). The playing face looks
--          down the model -Y axis on both models.
-- radius : radius of the OUTER edge of the double ring in metres (regulation 170 mm of a 225 mm board).
Config.BoardModels = {
    ['prop_dart_bd_01']     = { offset = vec3(0.0, -0.067, 0.0), radius = 0.225, label = 'Dartboard' },        -- (est.) bbox 0.596 x 0.596 m
    ['prop_dart_bd_cab_01'] = { offset = vec3(0.0, -0.060, 0.0), radius = 0.225, label = 'Dartboard cabinet' },-- (est.) bbox 1.39 x 0.72 m, doors open
}

-- Oche (throw line) distance from the board face, metres (regulation 2.37).
Config.ThrowDistance = 2.37
-- How far a player may stand from the oche when throwing (server check).
Config.OcheTolerance = 1.25
-- Interaction distance from the board.
Config.InteractDistance = 2.6
-- Players within this distance of a board see the darts land and the live scoreboard.
Config.SpectateDistance = 20.0
-- Show the compact scoreboard to spectators.
Config.SpectatorHud = true

-- Boards spawned by the script (for MLOs without a dartboard).
-- { model = 'prop_dart_bd_01', coords = vec3(x, y, z), heading = 0.0, label = 'My bar' }
-- heading = direction the board FACES (the side players throw from).
Config.SpawnBoards = {
    -- { model = 'prop_dart_bd_01', coords = vec3(0.0, 0.0, 0.0), heading = 0.0, label = 'Example' },
}

-- Map blips (vanilla locations that have a dartboard).
Config.Blips = {
    enabled = false,
    sprite = 103, color = 47, scale = 0.7,
    list = {
        { coords = vec3(1992.80, 3047.31, 46.23), label = 'Yellow Jack Inn' },
    },
}

---------------------------------------------------------------------------------------------------
-- Game modes
---------------------------------------------------------------------------------------------------
Config.Modes = {
    ['501']     = { enabled = true, start = 501, maxRounds = 20 },
    ['301']     = { enabled = true, start = 301, maxRounds = 15 },
    ['atc']     = { enabled = true, maxRounds = 25, multiplierAdvance = true }, -- Around the Clock: a double moves you 2 numbers, a treble 3
    ['cricket'] = { enabled = true, maxRounds = 20 },
}
-- When maxRounds is reached the leg goes to the best player (lowest remaining / furthest / most points).

Config.MaxPlayers = 4              -- 2 .. 4
Config.AllowSolo = true            -- solo practice (no bets, no stats)
Config.LegsChoices = { 1, 3, 5 }   -- "first to" choices shown in the lobby
Config.DoubleOutDefault = true     -- 301 / 501: finish on a double (or the bull)
Config.CheckoutHints = true        -- show the classic checkout route (e.g. T20 T19 D12)
Config.TurnTime = 30               -- seconds per visit (3 darts) before the remaining darts count as misses
Config.LobbyTimeout = 300          -- seconds before an idle lobby is cancelled (stakes refunded)

---------------------------------------------------------------------------------------------------
-- Throw feel (the server decides where the dart lands)
---------------------------------------------------------------------------------------------------
Config.Throw = {
    sensitivity = 0.055,    -- aim speed (screen heights per mouse input unit, same feel with every camera)
    reticleMin = 0.010,     -- smallest reticle radius (metres on the board)
    swayAmplitude = 0.030,  -- hand sway radius in metres
    swaySpeed = 1.0,        -- sway speed multiplier
    steadyFactor = 0.25,    -- sway multiplier while holding Focus
    focusPerVisit = 2.4,    -- seconds of Focus per visit (3 darts)
    powerSpeed = 1.15,      -- power bar cycles per second while charging
    idealPower = 0.72,      -- centre of the perfect power window (0..1)
    idealWindow = 0.07,     -- half width of the perfect window
    powerDrop = 0.16,       -- metres the dart drops / rises per unit of power error
    baseScatter = 0.004,    -- server-side random scatter (metres, 1 sigma) on a perfect throw
    errorScatter = 0.05,    -- extra scatter per unit of power error
    minInterval = 1.1,      -- seconds between two throws (anti spam)
}

---------------------------------------------------------------------------------------------------
-- Bets (ESX / QBCore / QBox; disabled in standalone)
---------------------------------------------------------------------------------------------------
Config.Bets = {
    enabled = true,
    account = 'cash',        -- 'cash' | 'bank'
    min = 0,
    max = 25000,
    presets = { 0, 100, 500, 1000, 5000 },
    houseCut = 5,            -- % kept by the house
    society = nil,           -- job / society account credited with the house cut (e.g. 'yellowjack'), nil = destroyed
}

---------------------------------------------------------------------------------------------------
-- Placeable dartboard item
---------------------------------------------------------------------------------------------------
Config.Item = {
    enabled = true,
    name = 'dartboard',
    model = 'prop_dart_bd_01',
    persistent = true,       -- saved in the database (rex_darts_boards) and restored on restart
    maxPerPlayer = 2,
    placeDistance = 3.0,     -- max raycast distance when placing
    height = 1.73,           -- regulation bullseye height above the floor
}

---------------------------------------------------------------------------------------------------
-- Leaderboard / stats (oxmysql)
---------------------------------------------------------------------------------------------------
Config.Stats = {
    enabled = true,
    leaderboardSize = 10,
    cache = 60,              -- seconds the leaderboard is cached
}

-- Discord webhook for match logs (bets, payouts). Empty = off.
Config.Webhook = ''

-- Keys (GTA control ids). Defaults: aim with the mouse, LMB hold / release = throw, SHIFT = focus.
Config.Keys = {
    throw = 24,      -- INPUT_ATTACK
    focus = 21,      -- INPUT_SPRINT
    leave = 177,     -- INPUT_CELLPHONE_CANCEL (Backspace)
    interact = 38,   -- INPUT_PICKUP (E)
    camNext = 0,     -- INPUT_NEXT_CAMERA (V)
    camPrev = 26,    -- INPUT_LOOK_BEHIND (C)
}

-- Key names shown in the throw HUD (change them if you change Config.Keys).
Config.KeyLabels = { aim = 'Mouse', throw = 'LMB', focus = 'Shift', camera = 'C / V', leave = 'Bksp' }

---------------------------------------------------------------------------------------------------
-- Throw cameras. Positions are relative to the board: `back` = metres out from the board face
-- (from the oche when anchor = 'oche'), `side` = metres to the thrower's right (negative = left),
-- `up` = metres above the bullseye. The view looks at the bullseye (+ lookOut / lookSide / lookUp).
---------------------------------------------------------------------------------------------------
Config.Camera = {
    default = 'player',            -- view used the first time (then the player's last choice is kept)
    remember = true,               -- remember each player's last view (client KVP)
    order = { 'player', 'focus', 'shoulder', 'cinematic' }, -- C / V cycle order
    interp = 450,                  -- ms of interpolation between two views
    enterEase = 600,               -- ms to ease from the gameplay camera into the first view
    exitEase = 500,                -- ms to ease back to the gameplay camera
    cinematicBetweenThrows = true, -- switch to spectatorView while a visit / leg is being resolved
    spectatorView = 'cinematic',   -- view used between throws and by /dartscam
    spectator = true,              -- /dartscam: spectators and waiting players can watch with spectatorView
    spectatorKey = '',             -- default key for /dartscam (players can bind it in Settings > Key Bindings)
    views = {
        player    = { anchor = 'oche',  back = 0.45, side = 0.18,  up = 0.12, fov = 24.0 },               -- eyes of the thrower
        focus     = { anchor = 'board', back = 1.15, side = 0.00,  up = 0.02, fov = 26.0 },               -- close-up on the board
        shoulder  = { anchor = 'oche',  back = 1.10, side = -0.42, up = 0.10, fov = 40.0, lookOut = 0.0 }, -- over the left shoulder
        cinematic = { anchor = 'board', back = 1.30, side = 1.75,  up = 0.25, fov = 50.0, lookOut = 1.25, lookUp = -0.25 }, -- side view: thrower and board
    },
}

---------------------------------------------------------------------------------------------------
-- Dart held in the thrower's hand (visible to everyone in range, built locally on each client)
---------------------------------------------------------------------------------------------------
Config.HandDart = {
    enabled = true,
    -- SKEL_R_Hand (57005): the real hand bone, always where the hand is. Do NOT use PH_R_Hand (28422)
    -- here: the mini@darts clips can move that prop-holder bone away from the hand.
    bone = 57005,
    offset = vector3(0.100, 0.030, -0.020), -- metres in the hand bone space (x = towards the fingers)
    rotation = vector3(0.0, 90.0, 0.0),     -- degrees; tune in game with /dartshand
    releaseAt = 260,                        -- ms after the throw anim starts when the dart leaves the hand
    reattachDelay = 700,                    -- ms before the next dart appears in the hand
}

---------------------------------------------------------------------------------------------------
-- Animations / props (vanilla names, verified against the game files)
---------------------------------------------------------------------------------------------------
Config.Anims = {
    dict = 'mini@darts',
    idle = 'throw_idle_a',      -- aiming stance (upper body loop)
    throw = 'throw_overlay',    -- the throw itself
    wait = 'wait_idle',         -- waiting for your turn
}
Config.DartModels = { 'prop_dart_1', 'prop_dart_2' } -- alternate per player
Config.DartPitch = -90.0      -- rotation that points the dart model into the board; use 90.0 if darts appear reversed
Config.DartDepth = 0.075      -- how far the dart centre sits out of the board face (m)
