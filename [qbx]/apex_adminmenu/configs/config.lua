Config = {}

-- Language for every in-game string. Files live in locales/; a locale
-- only needs the keys it translates and anything missing falls back to
-- English, so partial translations are safe.
-- Shipped: 'en', 'pt'
Config.Locale = 'en'

-- Extra console output from the compatibility layer and the locale
-- merge. Leave off in production.
Config.Debug = false

-- Default key for opening the Quick Menu. Players can re-bind it in
-- FiveM > Settings > Key Bindings > FiveM. The Admin Panel is on F6.
Config.OpenKey = 'F9'

-- (The old Config.MenuPosition option was removed: the Quick Menu is
-- drag-to-move and remembers where each player left it.)
-- ============================================================
-- THIRD-PARTY INTEGRATIONS
-- ------------------------------------------------------------
-- They all accept 'auto' (recommended): the compatibility layer in
-- configs/compat.lua scans the running resources and picks the right
-- provider by itself — no matter whether you run ESX, QBCore or QBox.
-- Set an explicit id only if you run two providers at once and want to
-- force one. Every supported id is listed in configs/compat.lua.
-- ============================================================

-- 'auto' | false (disable) | 'qbx' | 'qb' | 'wasabi' | 'renewed' | 'mrnewb'
-- | 'quasar' | 'jaksam' | 'cd' | 't1ger' | 'okok' | 'mono' | 'apex' | 'custom'
Config.UsingVehicleKeys = 'renewed'

-- 'auto' | false | 'illenium' | 'fivem-appearance' | 'bl' | 'rcore' | 'codem'
-- | 'tgiann' | 'qb' | 'esx_skin' | 'custom'
Config.SkinMenu = 'auto'

Config.FuelSystem = false -- Supported options: 'ox' - ox_fuel/ 'legacyfuel' - LegacyFuel / false - anything else

-- 'auto' | false | 'ox' | 'qb' | 'qs' | 'ps' | 'codem' | 'origen' | 'tgiann'
-- | 'core' | 'mf' | 'cheeza' | 'esx'
Config.Inventory = 'ox'

-- Ambulance / medical resource used by Revive and Heal.
--
-- These scripts keep their OWN death state (qb-ambulancejob's isDead +
-- laststand, plus a death flag stored server-side on the character). A
-- revive done with raw natives alone leaves that state set, so their death
-- loop keeps the respawn timer and the disabled controls running and the
-- revive looks like it did nothing. Routing through the provider clears it.
--
-- Set to false to force the built-in standalone revive instead.
-- 'auto' | false | 'qbx' | 'qb' | 'wasabi' | 'codem' | 'ars' | 'esx' | 'custom'
Config.Medical = 'auto'

-- ============================================================
-- VEHICLE IMAGES  (same method and shape as apex_garage)
-- ------------------------------------------------------------
-- Thumbnails in the Vehicles Database page. The NUI can't ask whether
-- a file exists, so it walks a candidate list with <img onerror>:
--
--   1. your own file   html/images/<spawncode>.<ext>
--   2. the fallback    URLs below, %s replaced by the spawn code
--   3. a monogram      the vehicle's initials on a styled tile
--
-- Drop custom / addon car pictures in html/images/ named after the
-- spawn code in lowercase (html/images/adder.png). A local file always
-- beats a URL, which is the guaranteed fix for a stubborn model.
-- Restart the resource after adding files — FiveM only serves files
-- that existed at start-up.
-- ============================================================
Config.VehicleImages = {
    enabled    = true,   -- false: monogram only, never fetch a picture
    custom     = true,   -- false: skip html/images/ and go straight to the URL
    extensions = { 'png', 'jpg', 'jpeg', 'webp' },  -- tried in this order

    -- Accepts a single URL or a list, tried in order — no single CDN has
    -- every vehicle, so chaining them fills most of the gaps.
    -- Set to false to use ONLY your own images.
    fallbackUrl = {
        'https://docs.fivem.net/vehicles/%s.webp',
    },
}

-- ============================================================
-- Discord Webhook Configuration
-- ------------------------------------------------------------
-- `url` is the CATCH-ALL: every log lands there unless the matching
-- route below is filled in.
--
-- `routes` splits the logs across separate channels. Any route left
-- empty falls back to `url`, so you can start with a single webhook
-- and peel categories off one at a time.
--
-- The same routes are editable live from the panel
-- (F6 -> Settings -> Discord), which stores them in the database. A
-- route saved in the panel wins; a route set HERE is used whenever
-- the panel has nothing for that category. That makes config.lua the
-- safe place to keep them: nothing the panel does can erase this file.
--
-- Console helpers (server console, not chat):
--   apexdiscord                  show what is routed where
--   apexwebhook <cat> <url>      set one route and persist it
--   apexwebhook <cat> clear      remove a route
--   apexdiscordtest <url>        send a test message to a raw URL
-- ============================================================
Config.Webhooks = {
    enabled = true, -- Enable Discord webhook logging
    url = "", -- Catch-all webhook — used by any category without its own route
    botName = "Admin Menu Logs", -- Name that will appear for the webhook bot
    botAvatar = "https://i.imgur.com/XXXXXXX.png", -- Avatar URL for the webhook bot (optional)
    color = 3447003, -- Default color for embeds (blue)

    -- One webhook per category. Leave "" to fall back to `url` above.
    routes = {
        moderation = "",  -- bans / kicks / warns / jails
        economy    = "",  -- money / items / weapons given
        player     = "",  -- heal / revive / freeze / teleport
        vehicle    = "",  -- spawn / fix / clean / delete
        staff      = "",  -- staff logins / off-duty / config changes
        console    = "",  -- server-side commands run from the panel
        reports    = "",  -- reports created / accepted / resolved
        login      = "",  -- player connects & disconnects
        global     = ""   -- explicit catch-all (same job as `url`)
    },

    -- Individual log types (all enabled by default)
    logs = {
        playerActions = true, -- Player-related admin actions (kick, ban, etc.)
        vehicleActions = true, -- Vehicle-related admin actions (spawn, repair, etc.)
        moneyActions = true, -- Money/item related admin actions
        utilityActions = true, -- Other utility actions (weather changes, etc.)
        adminActivity = true, -- Admin menu usage logging
    }
}

Config.AdminPerms = { -- Different ways of defining who has permission to access and utilize the admin menu
    UserGroups = {
        enabled = true, -- Enable usergroups from framework (Esx/QBCore), example/common groups below by default.
        Groups = {
            'admin',
            'god',
            'mod',
            'superadmin'
        }
    },
    
    ----------------------------------------------------------------------------
    -- If ace perms are desired, an example of ace perms to set in server.cfg:--
    -- add_ace group.admin 'apex.adminmenu.allow' allow                     --
    ----------------------------------------------------------------------------
    AcePerms = { enabled = true, AcePerm = 'apex.adminmenu.allow' }
}

-- ── Who may OPEN each menu ───────────────────────────────────
-- Being staff (Config.AdminPerms, or a line on the Staff page) opens both
-- menus by default. The lists below narrow that down PER MENU. A menu
-- with at least one non-empty list opens only for players matching one
-- of its lists:
--   groups   : panel group names (owner, admin, moderator, helper, or a
--              group you created on the Staff page). Framework names work
--              too (superadmin and god count as owner, mod as moderator).
--              Listing a group also lets in everyone ranked ABOVE it, so
--              { 'admin' } means admins and owners.
--   licenses : exact identifiers, any type: 'license:...', 'discord:...',
--              'steam:...'. The Staff page and /apexwho show them.
-- Both lists empty = no restriction (the default).
-- This is about opening the menu. What a player can DO inside it stays
-- with the group permissions (Staff page) and Config.PermissionLevels.
Config.MenuAccess = {
    -- The Quick Menu: Config.OpenKey (F9) and /adminmenu.
    QuickMenu  = { groups = {}, licenses = {} },
    -- The Admin Panel: F6 and /adminpanel.
    AdminPanel = { groups = {}, licenses = {} },

    -- Examples:
    --   QuickMenu  = { groups = { 'admin' } },
    --       admins and owners only; moderators keep the panel
    --   AdminPanel = { licenses = { 'license:0123456789abcdef0123456789abcdef01234567' } },
    --       the panel opens for that one account only
    --   AdminPanel = { groups = { 'owner' }, licenses = { 'discord:557706198644949002' } },
    --       owners, plus that one account whatever its group
}

-- Who can add / edit / remove staff in the admin panel (Staff page).
--   Groups with the 'staff.write' or 'staff.*' permission (owner) manage
--   everything. With lowerRanks = true, any other staff group can also manage
--   members of groups BELOW its own rank (an admin can add moderators and
--   helpers, never another admin or an owner). Editing groups stays owner-only.
--
-- Making yourself OWNER the first time: in the server console (txAdmin live
-- console) type   apexstaff <server id> owner
-- Also: apexstaff <license:xxx> <group>   and   apexstaff remove <license:xxx>
Config.StaffManagement = {
    lowerRanks = true,
}

-- Permission levels for specific actions
Config.PermissionLevels = {
    -- Define which admin groups can access specific features
    -- Available groups should match those in Config.AdminPerms.UserGroups.Groups
    
    -- Player management permissions
    kickPlayers = {'admin', 'god', 'superadmin'},
    banPlayers = {'admin', 'god', 'superadmin'},
    teleportPlayers = {'admin', 'mod', 'god', 'superadmin'},
    
    -- Economy permissions
    giveMoney = {'admin', 'god', 'superadmin'},
    giveItems = {'admin', 'god', 'superadmin'},
    
    -- Vehicle permissions
    spawnVehicles = {'admin', 'mod', 'god', 'superadmin'},
    modifyVehicles = {'admin', 'mod', 'god', 'superadmin'},
    
    -- Server management permissions
    manageWeather = {'admin', 'god', 'superadmin'},
    serverAnnouncements = {'admin', 'mod', 'god', 'superadmin'},
    
    -- Developer permissions
    developerOptions = {'admin', 'god', 'superadmin'}
}

--- Commands
Config.Commands = {
    -- ── Menu commands ──────────────────────────────────────────
    -- The two entries below open the menus themselves. `aliases` is a
    -- list of EXTRA names for the same command, which is how you keep
    -- the command your staff already types working after swapping out
    -- another admin resource (qb-adminmenu ships /admin, for example).
    -- Use {} for no aliases.
    --
    -- These are registered CLIENT-side. FiveM resolves client commands
    -- before forwarding anything to the server, so an alias listed here
    -- wins over a server-side command of the same name in another
    -- resource — you do not have to uninstall the other menu first.
    AdminPanel = {
        enabled = true,           -- Enable the Admin Panel command?
        command = 'adminpanel',   -- Command (Default: 'adminpanel'), also bound to F6
        aliases = { 'admin' }     -- Extra names for the SAME command
        -- Example: /adminpanel or /admin  (opens the full Admin Panel)
    },
    AdminMenu = {
        enabled = true,           -- Enable the Quick Menu command?
        command = 'adminmenu',    -- Command (Default: 'adminmenu'), also bound to Config.OpenKey
        aliases = {}              -- Extra names, e.g. { 'quickmenu' }
        -- Example: /adminmenu  (opens the F9 Quick Menu)
        -- Want /admin to open THIS instead of the panel? Move 'admin'
        -- from AdminPanel.aliases up there down to this list.
    },

    -- ── Staff commands ─────────────────────────────────────────
    -- The six below do their work on the server and are ALSO registered
    -- on the client (since 2.2.10), for the same reason as the menu
    -- commands above: a client resolves its own commands first, so the
    -- Apex one answers even when your framework or another resource has a
    -- server-side command with the same name. ESX Legacy ships its own
    -- /noclip, for example, and qb-adminmenu its own /kick and /ban.
    --
    -- To let the OTHER resource keep a name, set `enabled = false` here
    -- (Apex then registers nothing under it), or change `command` to a
    -- name nothing else uses. Permissions are checked on the server
    -- either way.
    Ban = {
        enabled = true, -- Enable ban command?
        command = 'ban' -- Command (Default: 'ban')
        -- Example: /ban ID_HERE OPTIONAL_REASON_HERE
        -- Indefinite ban. Use menu for temporary ban
    },
    Kick = {
        enabled = true, -- Enable kick command?
        command = 'kick' -- Command (Default: 'kick')
        -- Example: /kick ID_HERE OPTIONAL_REASON_HERE
    },
    NoClip = {
        enabled = true, -- Enable noclip command?
        command = 'noclip' -- Command (Default: 'noclip')
        -- Example: /noclip
    },
    SearchInv = {
        enabled = true, -- Enable searchinv command?
        command = 'searchinv' -- Command (Default: 'searchinv')
        -- MUST HAVE Config.Inventory CONFIGURED TO PROPER INVENTORY!
        -- Example: /searchinv ID_HERE (Opens target inventory)
    },
    ClearInv = {
        enabled = true, -- Enable clearinv command?
        command = 'clearinv' -- Command (Default: 'clearinv')
        -- MUST HAVE Config.Inventory CONFIGURED TO PROPER INVENTORY!
        -- Example: /clearinv ID_HERE (Clears target inventory)
    },
    SkinMenu = {
        enabled = true, -- Enable skinmenu command?
        command = 'skinmenu' -- Command (Default: 'skinmenu')
        -- MUST HAVE Config.SkinMenu CONFIGURED TO PROPER SKIN / CLOTHING SCRIPT
        -- Example: /skinmenu ID_HERE (Opens skin menu on target's screen)
    }
}

--- WEATHER SETTING OPTIONS
Config.Weathers = {
    {label = 'Clear Skies', value = 'CLEAR'},
    {label = 'Extra Sunny', value = 'EXTRASUNNY'},
    {label = 'Cloudy', value = 'CLOUDS'},
    {label = 'Foggy', value = 'FOGGY'},
    {label = 'Thunder', value = 'THUNDER'},
    {label = 'Rainy', value = 'RAIN'},
    {label = 'Halloween', value = 'HALLOWEEN'},
    {label = 'Snow Light', value = 'SNOWLIGHT'},
    {label = 'XMAS', value = 'XMAS'}
}

--- BAN SETTING OPTIONS
Config.Ban = { --- value = ban time in hours
    {label = '2 Hours', value = 2}, 
    {label = '24 Hours', value = 24},
    {label = '1 Week', value = 168},
    {label = 'Permanent', value = 'perm'}
}

--- JAIL SETTING
--- Which jail system the panel's Jail action hands the player to. There is
--- no cell location to configure here on purpose: the panel does not own a
--- prison, it delegates to the one your server already runs, so the coords,
--- the countdown, the release and the "still jailed after a relog" handling
--- all stay in that resource.
---
--- 'auto'  detect it — qb-policejob (which forwards to qb-prison), else qb-prison
--- false   log the sentence to apex_jail only, confine nobody
--- 'res:client:Event'  any event name containing a ':' is triggered on the
---                     target with the sentence length in minutes
Config.Jail = 'auto'

--- NOTIFICATIONS
--- Where the panel's notifications are drawn. nil/false uses ox_lib (which
--- this resource already depends on). Set an event name to route them into
--- your own notification resource instead; it receives
--- (title, message, duration, type).
Config.NotifyEvent = false

--- JOB ANNOUNCEMENT OPTIONS
Config.Jobs = { -- label value is for how it is displayed in the menu. name must be exact as in your jobs database/table
    { label = 'Police', name = 'police' },
    { label = 'EMS', name = 'ambulance' },
    { label = 'Mechanic', name = 'mechanic' },
    { label = 'Car Dealer', name = 'cardealer' }
}

--- NO CLIP OPTIONS
Config.Noclip = {
     FirstPersonWhileNoclip = true,
     DefaultSpeed = 1.0,
     MaxSpeed = 12.0,
     Controls = {
         DecreaseSpeed = 14, -- Mouse wheel down
         IncreaseSpeed = 15, -- Mouse wheel up
         MoveFoward = 32, -- W
         MoveBackward = 33, -- S
         MoveLeft = 34, -- A
         MoveRight = 35, -- D
         MoveUp = 44, -- Q
         MoveDown = 46, -- E
         -- Speed modifiers. Left Alt is deliberately NOT used here so the
         -- movable-menu toggle key stays free while noclipping.
         SpeedBoost = 21, -- Left Shift  (x2)
         SpeedSlow  = 36, -- Left Ctrl   (x0.25)
     },
     Particle = {
         Fxname = 'core',
         Effectname = 'ent_dst_elec_fire_sp'
     }
}

---- VEHICLE RELATED OPTIONS
Config.VehicleColors = { --- https://pastebin.com/pwHci0xK
    { label = 'Red', value = 27 },
    { label = 'Black', value = 0 },
    { label = 'Sunset Red', value = 33 },
    { label = 'Hot Pink', value = 135 },
    { label = 'Salmon Pink', value = 136 },
    { label = 'Dark Green', value = 49 },
    { label = 'Surf Blue', value = 68 },
    { label = 'Woodbeech Brown', value = 102 },
    { label = 'Cast Iron Silver', value = 10 },
    { label = 'Ice White', value = 111 },
    { label = 'Cream', value = 107 },
    { label = 'Frost White', value = 112 }
}


Config.TorqueMultiplier = { --- https://docs.fivem.net/natives/?_0xB59E4BD37AE292DB
    { label = 'Off', value = 1.0 },
    { label = '25%', value = 4.0 },
    { label = '50%', value = 8.0 },
    { label = '75%', value = 10.0 },
    { label = '100%', value = 100.0 }
}

-- ============================================================
-- Movable Quick Menu
-- ------------------------------------------------------------
-- Lets staff walk around / look while the admin menu is open by
-- alternating between two modes:
--   • Cursor mode   → interact with the menu (mouse = cursor)
--   • Movement mode → full game control, the menu stays visible
-- Press the toggle key to switch between them. Works on every
-- framework (it only touches NUI focus + game controls).
-- ============================================================
Config.MovableMenu = {
    enabled = true,            -- allow moving with the menu open
    startInCursorMode = true,  -- open in cursor mode (true) or movement mode (false)
    blockCombat = true,        -- block attack/aim while in movement mode (avoids
                               -- firing by accident with the menu visible)

    -- The key used to alternate between the two modes.
    --   toggleControl  = FiveM control id (used WHILE in movement mode)
    --   toggleKey      = matching JS KeyboardEvent.code (used WHILE in cursor mode)
    --   toggleKeyLabel = how the key is shown in the on-screen hint
    -- Default: Left Alt
    toggleControl  = 19,
    toggleKey      = 'AltLeft',
    toggleKeyLabel = 'Alt',

    -- Windows virtual-key code read through IsRawKeyJustPressed. This is
    -- what makes the toggle work EVERYWHERE — inside sub-menus, while the
    -- NUI holds focus, and during noclip (where every control action is
    -- disabled every frame). 0xA4 = Left Alt, 0xA5 = Right Alt,
    -- 0x12 = either Alt, 0x14 = Caps Lock, 0x09 = Tab.
    rawToggleKey   = 0xA4
}

-- ============================================================
-- Dimensions / Routing Buckets
-- ------------------------------------------------------------
-- Move yourself or another player into an isolated instance of
-- the world so you can test things solo without a second server.
-- Bucket 0 is the default/main world. Uses native routing
-- buckets, so it is fully framework-agnostic.
-- ============================================================
Config.Dimensions = {
    enabled = true,
    max = 1000  -- safety cap for the dimension input
}

-- ============================================================
-- Monitoring (F6 panel → Monitoring / "Watch screen")
-- ------------------------------------------------------------
-- The watched player's game sends small still frames of its screen,
-- relayed through the server. Bigger or more frequent frames look
-- smoother but cost the watched player upload bandwidth:
-- at the defaults a frame is roughly 30-60 KB, twice a second.
-- ============================================================
Config.Monitoring = {
    Interval = 500,  -- ms between frames (minimum 200)
    Width    = 854,  -- frame width in pixels; height follows the screen
    Quality  = 0.5   -- JPEG quality 0.1 - 1.0
}

-- ============================================================
-- Owned Vehicles (database) — view / add / remove a player's cars
-- ------------------------------------------------------------
-- Defaults match ESX (owned_vehicles) and QBCore / QBox
-- (player_vehicles). Override the table/column names below if
-- your schema differs.
-- ============================================================
Config.OwnedVehicles = {
    enabled = true,

    -- How many rows the F6 panel's Vehicles page loads at once.
    -- Typing in its search box queries the database instead of filtering
    -- a huge list in the browser, so this only caps the FIRST page — you
    -- can still reach every vehicle by searching for it.
    -- Raise it if you prefer scrolling; oxmysql warns above 1000 rows.
    panelPageSize = 250,

    esx = {
        table       = 'owned_vehicles',
        ownerColumn = 'owner',    -- matches GetIdentifier() (license / identifier)
        plateColumn = 'plate',
        dataColumn  = 'vehicle'   -- JSON column holding the vehicle props
    },
    qb = {
        table       = 'player_vehicles',
        ownerColumn = 'citizenid',
        plateColumn = 'plate',
        modelColumn = 'vehicle',  -- spawn-name string column
        hashColumn  = 'hash'
    }
}

-- ============================================================
-- Reports Center
-- ============================================================
Config.Reports = {
    -- Cooldown between reports (seconds, per player identifier)
    Cooldown = 30,

    -- Maximum size of chat history kept per report (oldest dropped)
    MaxMessages = 200,

    -- Screenshot capture settings. Uses screenshot-basic (free, no API
    -- key) to grab a base64 JPEG that is embedded straight into the
    -- chat message as a data: URI — no external host or upload needed.
    Screenshot = {
        Quality = 0.7,    -- 0.0 - 1.0
        Encoding = 'jpg'  -- 'jpg' keeps the data URI small enough for NUI
    }
}
