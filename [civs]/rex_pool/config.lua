--[[
    ██████╗ ███████╗██╗  ██╗    ██████╗  ██████╗  ██████╗ ██╗
    ██╔══██╗██╔════╝╚██╗██╔╝    ██╔══██╗██╔═══██╗██╔═══██╗██║
    ██████╔╝█████╗   ╚███╔╝     ██████╔╝██║   ██║██║   ██║██║
    ██╔══██╗██╔══╝   ██╔██╗     ██╔═══╝ ██║   ██║██║   ██║██║
    ██║  ██║███████╗██╔╝ ██╗    ██║     ╚██████╔╝╚██████╔╝███████╗
    ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝    ╚═╝      ╚═════╝  ╚═════╝ ╚══════╝
    Rex Pool - Rex Studio (rex-studio.com)

    This file is NOT encrypted by escrow. Every option is commented.
    Values marked (est.) are estimates: tune them in game with /pooldebug.
]]

Config = {}

-- 'auto' | 'esx' | 'qb' | 'qbox' | 'standalone'
Config.Framework = 'qbox'

-- 'en' | 'fr' | 'es'  (locales/*.lua, add your own freely)
Config.Locale = 'en'

-- 'ox' (ox_lib notify) | 'framework' (ESX / QB notification)
Config.Notify = 'ox'

-- 'auto' | 'ox_target' | 'qb-target' | 'none'  ('none' = [E] prompt + marker only)
Config.Target = 'ox_target'

-- Always draw the [E] prompt / marker, even when a target resource is running.
Config.AlwaysShowPrompt = false

-- ACE permission for /pooladmin, /poolspawn, /poolscan, /pooldebug
-- server.cfg:  add_ace group.admin rexpool.admin allow
Config.AdminAce = 'rexpool.admin'

Config.Debug = false

---------------------------------------------------------------------------------------------------
-- Tables
---------------------------------------------------------------------------------------------------

-- Pool table models detected anywhere on the map (vanilla + MLO + spawned).
-- Both models share the same mesh (1.986 x 3.062 x 0.945 m bbox, long side = model Y axis).
-- length / width   : playing surface (cloth inside the cushions, cushion nose to nose), metres
-- clothZ           : height of the cloth above the model origin
-- longAxis         : 'y' when the long side of the table is the model Y axis
-- offsetX/offsetY  : (optional) cloth centre offset from the model origin, model axes, metres
-- cornerMouth / sideMouth : (optional) per-model pocket mouths in ball radii (else Config.Physics)
-- Tune all of this in game with /poolcalibrate: saved values (data/calibration.json) override these.
Config.TableModels = {
    -- Calibrated in game with /poolcalibrate (Yellow Jack table).
    ['prop_pooltable_02'] = { length = 2.750, width = 1.590, clothZ = 0.895, offsetX = -0.060, offsetY = 0.110, cornerMouth = 2.90, sideMouth = 1.90, longAxis = 'y', label = 'Pool table' },
    -- 3b is the same mesh (same bbox): it uses the same values unless you recalibrate it with /poolcalibrate.
    ['prop_pooltable_3b'] = { length = 2.750, width = 1.590, clothZ = 0.895, offsetX = -0.060, offsetY = 0.110, cornerMouth = 2.90, sideMouth = 1.90, longAxis = 'y', label = 'Pool table' },
}

-- How far (m) the client scans around the player for table props.
Config.ScanRadius = 30.0
-- Interaction distance from the table edge.
Config.InteractDistance = 1.8
-- Players closer than this to a table receive its live sync (spectators included).
Config.SyncDistance = 35.0
-- Ball props are streamed in under this distance.
Config.RenderDistance = 40.0

-- Hide the decorative vanilla props lying on tables while a game runs (model hide, client only).
Config.HideVanillaProps = { 'prop_pool_ball_01', 'prop_pool_tri' }

-- Extra tables you place yourself (e.g. in an MLO without a pool table prop).
-- The table prop is spawned server-side (networked) at start.
-- { model = 'prop_pooltable_02', coords = vec3(x, y, z), heading = 0.0, zone = 'yellowjack' }
Config.SpawnTables = {
}

---------------------------------------------------------------------------------------------------
-- Zones: per-area rental fee / society (first matching zone wins, else Config.Rental)
---------------------------------------------------------------------------------------------------
Config.Zones = {
    {
        name = 'yellowjack', label = 'Yellow Jack Inn',
        coords = vec3(1992.80, 3047.31, 46.23), radius = 15.0,
        rental = { price = 50, society = 'yellowjack' }, -- society = job/society account credited
        blip = false,
    },
    -- Example for a casino penthouse table (coords est., use /poolscan in the penthouse):
    -- { name = 'penthouse', label = 'Penthouse', coords = vec3(976.6, 66.0, 116.2), radius = 15.0,
    --   rental = { price = 0 } },
}

-- Default rental when the table is not in a zone.
Config.Rental = {
    enabled = false,
    price = 25,          -- paid by the lobby host when the match starts (0 = free)
    account = 'cash',    -- 'cash' | 'bank'
    society = nil,       -- e.g. 'bar' to credit a job/society account, nil = money is removed
}

-- Map blips for tables in zones with blip = true.
Config.Blip = { sprite = 498, color = 0, scale = 0.7 }

---------------------------------------------------------------------------------------------------
-- Wagers (server-side escrow)
---------------------------------------------------------------------------------------------------
Config.Wagers = {
    enabled = true,
    account = 'cash',          -- 'cash' | 'bank'
    min = 0,
    max = 50000,
    houseCut = 0.05,           -- 5% of the pot goes to the house (0 = none)
    houseSociety = nil,        -- society credited with the house cut (nil = removed)
    onDisconnect = 'forfeit',  -- 'forfeit' (other team wins the pot) | 'refund'
    requireRules = true,       -- wagers only allowed with the automatic rules engine on
}

---------------------------------------------------------------------------------------------------
-- Game modes
---------------------------------------------------------------------------------------------------
-- assist: default aim assist per mode. 0 = none, 1 = short line, 2 = ghost ball + object line,
--         3 = full (2 + cue ball path + first cushion rebound). Lobby can only lower it if lockAssist.
Config.Modes = {
    eightball = { enabled = true, assist = 2, maxAssist = 3 },
    nineball  = { enabled = true, assist = 2, maxAssist = 3 },
    straight  = { enabled = true, assist = 2, maxAssist = 3, targetScores = { 15, 25, 50, 100 } },
    free      = { enabled = true, assist = 3, maxAssist = 3 }, -- free table, anyone shoots, no rules
}

Config.Rules = {
    eightOnBreak = 'respot',       -- 'respot' | 'win'
    scratchOnBreak = 'kitchen',    -- ball in hand behind the head string ('kitchen') or 'anywhere'
    ballInHand = 'anywhere',       -- after a normal foul
    callPocketDefault = false,     -- 8-ball: call the pocket for the 8 / straight: call every shot
    shotClock = 60,                -- seconds per shot before the turn passes (0 = off)
    inactivityTimeout = 300,       -- seconds without a shot before the match is closed (refund)
    lobbyTimeout = 180,            -- seconds a lobby stays open without starting
}

Config.Formats = { '1v1', '2v2' } -- free mode also allows solo practice

---------------------------------------------------------------------------------------------------
-- Physics (shared by server and clients, MUST be identical everywhere: do not change per client)
---------------------------------------------------------------------------------------------------
Config.Physics = {
    Hz = 400,                 -- fixed simulation steps per second
    MaxSteps = 400 * 14,      -- hard stop after 14 s
    Gravity = 9.81,
    BallRadius = 0.0375,      -- vanilla poolball props are ~0.075 m wide (est.)
    MaxSpeed = 6.5,           -- m/s at 100 % power
    MinPower = 0.02,
    MuSlide = 0.2,            -- sliding friction (cloth)
    MuRoll = 0.011,           -- rolling resistance
    MuSpin = 0.045,           -- side spin decay
    SlipEpsilon = 0.0005,
    RestSpeed = 0.004,
    BallRestitution = 0.94,
    CushionRestitution = 0.78,
    CushionFriction = 0.92,   -- tangential speed kept on a cushion hit
    CushionSpinGrip = 0.45,   -- how much english bends the rebound
    CushionSpinLimit = 0.8,
    CushionSpinKeep = 0.55,
    CushionRollKeep = 0.15,
    SpinThrow = 0.02,
    MaxTipOffset = 0.5,       -- cue tip offset at 100 % spin, in ball radii
    SideSpinFactor = 1.0,
    CornerMouth = 2.9,        -- corner jaw distance from the corner, in ball radii
    SideMouth = 1.9,          -- half width of the side pocket mouth, in ball radii
    ServerChunk = 600,        -- server sim steps per tick before yielding (keeps the tick light)
}

---------------------------------------------------------------------------------------------------
-- Visuals & controls
---------------------------------------------------------------------------------------------------
Config.Props = {
    cue = 'prop_pool_cue',            -- 0.031 x 0.027 x 1.502, long axis = model Z
    cueTipPositiveZ = true,           -- (est.) flip if the cue points the wrong way while aiming
    cueTilt = 7.0,                    -- degrees, butt raised above the tip while aiming
    -- cue in the right hand between shots (bone 57005), (est.)
    handOffset = { pos = vec3(0.08, 0.03, -0.02), rot = vec3(-70.0, 10.0, 0.0) },
    -- after the strike the cue stays on the line this long (ms), then goes back to the hand
    followThroughMs = 200,
    balls = 'prop_poolball_%d',       -- prop_poolball_1 .. prop_poolball_15
    cueBall = 'prop_poolball_cue',
    fallbackBall = 'prop_pool_ball_01',
}

Config.Anims = {
    -- holding the cue between shots (vanilla 2-handed pool cue grip)
    idle = { dict = 'anim@weapons@melee_2h@pool_cue', clip = 'grip_idle', flag = 49 },
    -- bent over the table while aiming
    aim = { dict = 'timetable@maid@cleaning_surface@base', clip = 'base', flag = 1 },
    -- fallback if a dict fails to load
    fallback = { dict = 'mini@repair', clip = 'fixing_a_ped', flag = 1 },
}

-- Control indexes: https://docs.fivem.net/docs/game-references/controls/
Config.Controls = {
    interact = 38,        -- E
    shoot = 24,           -- LMB (hold & pull back) / Space when PowerMode = 'hold'
    shootAlt = 22,        -- SPACE
    fineAim = 21,         -- SHIFT (slow aim)
    topView = 26,         -- C
    spinUp = 172,         -- ARROW UP
    spinDown = 173,       -- ARROW DOWN
    spinLeft = 174,       -- ARROW LEFT
    spinRight = 175,      -- ARROW RIGHT
    spinReset = 45,       -- R
    callPocket = 44,      -- Q (cycle called pocket)
    confirm = 191,        -- ENTER (place ball in hand)
    cancel = 177,         -- BACKSPACE (stand up / leave aim)
    menu = 47,            -- G (open the table menu while playing)
}

-- 'drag' = hold LMB and pull the mouse back, push forward to strike
-- 'hold' = hold SPACE / LMB, a meter oscillates, release to strike
Config.PowerMode = 'drag'
Config.MouseSensitivity = 1.0

-- Local view while YOU aim / place the cue ball / watch from the top camera.
-- Only your own screen is affected, other players always see your ped normally.
Config.Aim = {
    -- 'auto'   : fade your ped only when it gets between the camera and the cue ball (or too close to the camera)
    -- 'always' : always fade your ped while aiming / top view
    -- 'never'  : never touch it
    HideLocalPed = 'auto',
    -- 0 = fully invisible for you (SetEntityLocallyInvisible, every frame), 1..254 = local alpha
    -- (GTA applies alpha in steps of ~51: 51, 102, 153, 204)
    LocalPedAlpha = 51,
    -- the cue stays visible (aiming reference) but turns semi-transparent when its butt is near the camera
    CueNearDistance = 0.35,
    CueAlpha = 153,
    -- a body part closer than this (m) to the camera -> cue ball line counts as blocking
    BlockRadius = 0.22,
    -- keep faded this long after the ped stops blocking (avoids flicker)
    HoldMs = 350,
}

Config.Sound = {
    enabled = true,
    volume = 0.8,         -- master volume (0..1)
    maxDistance = 20.0,   -- inaudible beyond this distance
}

---------------------------------------------------------------------------------------------------
-- Stats (oxmysql). Set to false to run without a database.
---------------------------------------------------------------------------------------------------
Config.Stats = {
    enabled = true,
    leaderboardSize = 25,
    leaderboardCommand = 'poolstats',
}
