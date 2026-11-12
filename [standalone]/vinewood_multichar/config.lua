Config = {}

--[[ ─────────────────────────────────────────────────────────────
    FRAMEWORK
    'auto' detects Qbox (qbx_core, or qbx renamed to qb-core),
    QBCore and ESX Legacy. Force one with 'qbx', 'qb' or 'esx'.
───────────────────────────────────────────────────────────── ]]
Config.Framework = 'auto'

Config.Debug = false

--[[ ─────────────────────────────────────────────────────────────
    ADMIN
    Grant with:  add_ace group.admin vinewood.multichar.admin allow
───────────────────────────────────────────────────────────── ]]
Config.AdminAce      = 'vinewood.multichar.admin'
Config.AdminCommand  = 'charadmin'

-- Lets players go back to the selection screen. Set to false to disable.
Config.SwitchCommand = 'switchcharacter'
Config.SwitchAce     = false      -- e.g. 'vinewood.multichar.switch' to restrict it, false = everyone
Config.SwitchCooldown = 60        -- seconds

--[[ ─────────────────────────────────────────────────────────────
    SLOTS
    These are the defaults used on first start. After that the
    values saved from the in-game admin menu take priority.
───────────────────────────────────────────────────────────── ]]
Config.Slots = {
    Base  = 3,        -- everyone gets this many
    Max   = 10,       -- hard cap, nobody can go above this
    Stack = true,     -- true: bonuses add together. false: only the biggest bonus counts
    ShowLocked = 2,   -- how many locked slots to show after the last unlocked one (0 hides them)
    LockExcess = true -- characters sitting in slots above someone's allowance can't be played until they regain the slots
}

-- Default ACE bonuses (editable in the admin menu afterwards)
--   add_ace group.admin vinewood.multichar.staff allow
--   add_ace group.vip   vinewood.multichar.vip   allow
Config.AceBonuses = {
    { ace = 'vinewood.multichar.staff', slots = 2, label = 'Staff' },
    { ace = 'vinewood.multichar.vip',   slots = 1, label = 'VIP' },
}

-- Shown on locked slots
Config.LockedText = 'Unlock more slots by boosting our Discord or picking up VIP.'
Config.LockedLink = 'discord.gg/yourserver'

--[[ ─────────────────────────────────────────────────────────────
    CHARACTER CREATION
───────────────────────────────────────────────────────────── ]]
Config.Character = {
    MinAge = 18,
    MaxAge = 90,
    NameMin = 2,
    NameMax = 16,
    AllowDelete = true,
    DeleteConfirmName = true, -- player has to type the character's full name to delete
    DefaultNationality = 'British',
    Nationalities = {
        'British', 'English', 'Scottish', 'Welsh', 'Northern Irish', 'Irish',
        'American', 'Canadian', 'Australian', 'New Zealander', 'French', 'German',
        'Spanish', 'Italian', 'Portuguese', 'Dutch', 'Polish', 'Romanian', 'Greek',
        'Turkish', 'Indian', 'Pakistani', 'Bangladeshi', 'Chinese', 'Japanese',
        'Nigerian', 'Ghanaian', 'Jamaican', 'Brazilian', 'Mexican', 'Other',
    },
}

--[[ ─────────────────────────────────────────────────────────────
    CLOTHING
    'auto' picks the first one running from:
      op-clothing, rcore_clothing, qs-appearance, illenium-appearance,
      fivem-appearance, qb-clothing, skinchanger (ESX)
    Or force one of those names, or 'custom' to use the hooks in
    server/clothing.lua and client/open.lua.
───────────────────────────────────────────────────────────── ]]
Config.Clothing = 'auto'

-- Where brand new characters appear (before clothing / spawn selector)
Config.NewCharacterSpawn = vec4(-540.58, -212.02, 37.65, 208.88)

-- Items given to brand new characters (requires ox_inventory, leave empty to skip)
Config.StarterItems = {
    { name = 'phone', count = 1 },
}

--[[ ─────────────────────────────────────────────────────────────
    SCENES
    'random'  picks a weighted random enabled scene each time
    'fixed'   always uses the scene chosen in the admin menu
    (mode is also editable in the admin menu)
───────────────────────────────────────────────────────────── ]]
Config.SceneMode = 'random'

Config.Camera = {
    Transition = 1400,              -- ms between characters
    Ease = 'easeInOutCubic',
    Shake = 0.12,                   -- handheld sway amount (0 = locked off)
    Fov = 38.0,
    Dof = { enabled = true, strength = 0.7 },
}

-- Used when no scenes have been built yet
Config.FallbackScene = {
    id = 0,
    name = 'Fallback',
    env = { hour = 19, minute = 30, weather = 'EXTRASUNNY', freeze = true },
    camera = { transition = 1400, ease = 'easeInOutCubic', shake = 0.12, dof = { enabled = true, strength = 0.7 }, intro = {} },
    spots = {
        { pos = { x = 195.17, y = -933.77, z = 30.69 }, heading = 140.0, pose = { type = 'preset', preset = 'crossarms' } },
    },
    props = {},
}

--[[ ─────────────────────────────────────────────────────────────
    EDITOR
───────────────────────────────────────────────────────────── ]]
Config.Editor = {
    Speed = 0.12,
    FastMultiplier = 5.0,
    SlowMultiplier = 0.25,
    Sensitivity = 6.0,
    MaxProps = 80,
    MaxSpots = 12,
    MaxKeyframes = 30,
}

--[[ ─────────────────────────────────────────────────────────────
    UI
───────────────────────────────────────────────────────────── ]]
Config.UI = {
    ServerName = 'Vinewood',
    Tagline = 'Choose who you are tonight.',
    Currency = '£',
    Locale = 'en-GB',
}

--[[ ─────────────────────────────────────────────────────────────
    THEME
    Defaults only. Change the look in game: /charadmin > Appearance.
    Logo can be a https:// image link, or a file you drop into
    web/img/ referenced as 'img/yourlogo.png'.
───────────────────────────────────────────────────────────── ]]
Config.Theme = {
    preset = 'sodium',
    accent = '#F2A93B',
    surface = '#0E1218',
    text = '#F3EFE6',
    danger = '#E5484D',
    bar = '#000000',
    font = 'bigshoulders',
    logo = '',
    logoSize = 64,
    showName = true,
    letterbox = true,
    frame = true,
    vignette = 0.75,
    layout = 'left',
}

Config.Weathers = {
    'EXTRASUNNY', 'CLEAR', 'CLOUDS', 'OVERCAST', 'SMOG', 'FOGGY', 'RAIN',
    'THUNDER', 'CLEARING', 'NEUTRAL', 'SNOW', 'SNOWLIGHT', 'BLIZZARD', 'XMAS', 'HALLOWEEN',
}
