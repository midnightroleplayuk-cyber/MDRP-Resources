Config = Config or {}

Config.Debug = false
Config.Locale = 'en'

-- 'auto' detects qbx_core, qb-core or es_extended
Config.Framework = 'auto'

-- Framework job names that count as prison staff
Config.Jobs = { 'prison', 'police' }

-- qb/qbx only: staff must be on duty to use permissions. ESX has no duty, so staff always count as on duty.
Config.RequireDuty = true

-- Prison used when an integration sends prison = 'auto' (matches prison_prisons.code)
Config.DefaultPrison = 'VINEWOOD'

Config.Tablet = {
    command = false,   -- false to disable the command
    item = 'prison_tablet',     -- ox_inventory item (see README); false to disable

    -- Show the tablet inside the rugged device artwork (false: a plain window)
    Device = true,
    -- What the device's buttons do. Power always closes the tablet.
    -- Pages: roll, regime, incidents, adjudications, industries, security, cctv, visits,
    --        movements, parole, healthcare, cells, audit. 'alarm' raises a general alarm
    --        (press twice within 3 seconds). 'none' does nothing.
    Buttons = { p1 = 'roll', p2 = 'incidents', p3 = 'alarm', home = 'roll' },
}

Config.Editor = {
    command = 'prisoneditor',
    ace = 'vinewood_prison.editor',
}

-- Door sounds, played at the nearest door and heard within `distance`.
-- Each is a list of steps played in order; `delay` is milliseconds after the previous step.
--   { game = { 'SoundName', 'SoundSet' } }  a sound built into GTA (no files to ship)
--   { file = 'mybuzzer.ogg' }                your own recording in web/build/sounds/
-- Use /prisonsoundtest in game to hear the built-in candidates and pick your favourites.
Config.DoorSounds = {
    enabled = true,
    distance = 35.0,
    volume = 0.6,      -- for file sounds (game sounds follow the player's SFX volume)

    UnlockAll = {      -- cells unlocked together: buzzer, then the locks
        { game = { 'DOOR_BUZZ', 'MP_PLAYER_APARTMENT' } },
        { game = { 'Unlock_Cell', 'DLC_Biker_POW_Sounds' }, delay = 900 },
    },
    LockAll = {        -- cells locked together: buzzer, then the doors shutting
        { game = { 'DOOR_BUZZ', 'MP_PLAYER_APARTMENT' } },
        { game = { 'Generic_Door_Closed', 'GTAO_Script_Doors_Sounds' }, delay = 800 },
    },
    Unlock = {         -- a single door
        { game = { 'Unlock_Cell', 'DLC_Biker_POW_Sounds' } },
    },
    Lock = {
        { game = { 'Generic_Door_Closed', 'GTAO_Script_Doors_Sounds' } },
    },
}

-- Notifications stay up long enough to read: MinSeconds, plus a little per word, up to MaxSeconds
Config.Notify = {
    MinSeconds = 6,
    MaxSeconds = 15,
    SecondsPerWord = 0.35,
    Position = nil,    -- e.g. 'top-right', 'center-right'; nil uses ox_lib's default
}

Config.Interact = {
    -- 'auto' uses ox_target or qb-target if running, otherwise [E] prompts. false forces prompts.
    Target = 'auto',
    key = 38,              -- E
    doorDistance = 2.0,
    deskDistance = 2.0,
}

-- Phase 1 containment: prisoners who leave the boundary are returned to their cell.
-- Escape gameplay replaces this in Phase 6.
Config.Boundary = {
    interval = 5000,        -- ms between server checks
    fallbackRadius = 250.0, -- used when a prison has no boundary drawn
}
