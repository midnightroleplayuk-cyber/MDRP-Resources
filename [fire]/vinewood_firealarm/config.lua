Config = {}

Config.Debug = false

-- 'auto' | 'qbx' | 'qb' | 'esx' | 'standalone'
Config.Framework = 'auto'

-- Admin access (ace). Add to server.cfg:  add_ace group.admin vinewood.firealarm.admin allow
Config.AdminAce = 'vinewood.firealarm.admin'
Config.AdminCommand = 'firealarm'

-- Panels show 8 zones (matches the panel fascia)
Config.MaxZones = 8

---------------------------------------------------------------------
-- Props. Swap these for your own models once they're streamed.
-- Pivot should sit at the BACK-CENTRE of the model so it mounts flush
-- to walls. If a model isn't found, that device falls back to a
-- target point (no prop) automatically.
---------------------------------------------------------------------
Config.Props = {
    mcp        = 'prop_vw_firealert',    -- red break glass call point (streamed in /stream)
    mcp_active = nil,                    -- optional: broken-glass model swapped in while activated
    panel      = 'prop_vw_firepanel',    -- control panel (streamed in /stream)
    sounder    = 'vinewood_sounder',     -- not made yet: places as a target point until it exists
    detector   = 'vinewood_detector',    -- not made yet: places as a target point until it exists
}

-- Where each model touches the wall. anchor = the point on the model (in its
-- own local space) that sits on the surface you aim at: normally the centre
-- of its back. heading = extra rotation so the front faces out of the wall
-- (180 for models whose front faces -Y). Read from the model bounds.
Config.PropAnchors = {
    prop_vw_firepanel = { anchor = vec3(0.0, 0.081, 0.212), heading = 180.0 },
    prop_vw_firealert = { anchor = vec3(-0.0425, 0.014, 0.038), heading = 180.0 },
}

-- Extra gap from the surface (metres), on top of the anchor.
Config.WallOffset = 0.0
Config.CeilingOffset = 0.0

Config.SpawnDistance = 80.0          -- props spawn/despawn around players
Config.TargetDistance = 1.5

---------------------------------------------------------------------
-- Live screen on the panel prop (DUI). Everyone near a panel sees its
-- status on the model's screen without opening the UI.
--  txd     : texture dictionary holding the screen texture (firealarm_txd.ytd)
--  texture : the screen texture's name inside it
--  width/height : resolution of the live page. Match the SHAPE of the screen
--            face on the model (not the texture, which is 1024x1024), or
--            the text will look stretched.
---------------------------------------------------------------------
Config.Screen = {
    enabled = true,
    txd = 'firealarm_txd',
    texture = 'firealarmscreen',
    width = 768,
    height = 416,   -- screen face on prop_vw_firepanel is 27.6 x 14.9 cm
    distance = 20.0,
}

---------------------------------------------------------------------
-- Access levels (BS 5839 / EN 54-2 style)
--  Level 1 : anyone — view status, mute panel buzzer, lamp test
--  Level 2 : user code / business staff / fire service — silence, reset, evacuate, disablements
--  Level 3 : engineer code / admin — test mode, view who triggered devices
---------------------------------------------------------------------
Config.AccessTimeout = 300           -- seconds of inactivity before dropping back to level 1
Config.MaxCodeAttempts = 5
Config.CodeLockout = 60              -- seconds locked out after too many wrong codes

-- Jobs that get access to every panel. job = { minGrade, level }
Config.FireServiceJobs = {
    fire = { minGrade = 0, level = 2 },
    lfb  = { minGrade = 0, level = 2 },
}

-- Business owner job (set per system in the admin menu) gets level 2 automatically
Config.OwnerJobGetsLevel2 = true

---------------------------------------------------------------------
-- Behaviour
---------------------------------------------------------------------
Config.BreakGlassCooldown = 60       -- per player, seconds
Config.RequireCallPointReset = true  -- activated MCPs must be reset with the key at the device before the panel can reset
Config.NewZoneResounds = true        -- a new zone going into alarm resounds silenced sounders
Config.TestSoundDuration = 5         -- seconds sounders run per device during test mode
Config.DetectorRange = 12.0          -- TriggerAtCoords export: max distance to a detector
Config.EventLogSize = 50

---------------------------------------------------------------------
-- Sound
-- Tones: 'bs_alternating' (recorded BS two-tone 800/970Hz at 2Hz, html/sounds),
--        'alternating' (generated 800/970Hz two-tone), 'continuous' (970Hz),
--        'pulsed' (970Hz 1s on/off — UK 'alert'), 'sweep' (800-970Hz whoop)
---------------------------------------------------------------------
Config.DefaultTone = 'bs_alternating'
Config.DefaultSoundRadius = 40.0
Config.MasterVolume = 0.35
Config.InteriorDampen = 0.35         -- volume multiplier when you're not in the same interior as the sounder
Config.Beacons = true                -- red flashing light at sounders while sounding
Config.BeaconRange = 6.0

---------------------------------------------------------------------
-- Alarm Receiving Centre / dispatch
---------------------------------------------------------------------
Config.Dispatch = {
    enabled = true,
    defaultDelay = 30,               -- seconds between first alarm and fire service being called (if not reset)

    -- Runs on the SERVER. Hook into your dispatch here.
    Send = function(data)
        -- data = { system, zone, zoneName, device, reason, coords (vector3) }
        if GetResourceState('vinewood_dispatch') == 'started' then
            -- Adjust to match your vinewood_dispatch export signature
            local ok, err = pcall(function()
                exports.vinewood_dispatch:SendAlert({
                    service = { 'fire' },
                    code = 'AFA',
                    title = 'Automatic Fire Alarm',
                    message = ('%s — Zone %d %s (%s)'):format(data.system, data.zone, data.zoneName, data.reason),
                    coords = data.coords,
                })
            end)
            if not ok then print(('[vinewood_firealarm] dispatch export failed: %s'):format(err)) end
        else
            print(('[vinewood_firealarm] ARC call: %s Zone %d (%s)'):format(data.system, data.zone, data.zoneName))
        end
    end,
}

-- Discord webhook for activation logs (leave blank to disable)
Config.Webhook = ''

---------------------------------------------------------------------
-- Placement controls
---------------------------------------------------------------------
Config.Placement = {
    maxDistance = 10.0,
    rotateStep = 5.0,
    fineRotateStep = 1.0,
}
