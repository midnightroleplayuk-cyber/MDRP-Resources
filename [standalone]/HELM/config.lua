Config = {}

-- Helm panel address. Already set to the hosted panel, so most servers only need the token below.
Config.PanelUrl = 'https://helm-panel.onrender.com'

-- The server token is NOT set here: this file is sent to every player's game client. It lives in
-- server_config.lua (server only), or set `set helm_token "hs_..."` in server.cfg.

-- 'auto' (default) detects what is running on your server. Or force one: 'qbox', 'qbcore', 'esx', 'standalone'.
-- Standalone = no framework: moderation, sessions and the activity log only.
Config.Framework = 'auto'

-- 'auto' (default) detects ox_inventory, qs-inventory, ps-inventory, lj-inventory, qb-inventory or ESX's own.
-- Or force one of those names, or 'none'.
Config.Inventory = 'auto'

-- Bank balances. 'auto' (default) uses LG Mods UK Banking when LGMods_Banking is running, otherwise the framework's
-- own bank money. Or force 'lgmods' or 'framework'.
Config.Banking = 'auto'

-- Client event fired on a player to revive them. nil = auto-detect from osp_ambulance, qbx_medical,
-- qb-ambulancejob, wasabi_ambulance or esx_ambulancejob. Set an event name if you use another ambulance script.
Config.ReviveEvent = nil

-- Garage that vehicles issued from the panel go to when staff leave the garage field blank.
-- Must match a garage ID in your garage script (qb-garages and many QBox setups use 'pillboxgarage').
-- OP Garages (op-garages) is detected automatically: it uses garage numbers from its Garage Admin, so put a number
-- here or in the panel's garage field; anything else parks the vehicle in the lowest numbered garage.
Config.DefaultGarage = 'pillboxgarage'

Config.HeartbeatSeconds = 20
Config.CommandPollSeconds = 4
Config.SyncSeconds = 120

-- If true, players who are not allowlisted in the panel are refused at connect. With Discord role allowlisting
-- set up on the panel (Servers page), players who lose the role while playing are kicked with "Whitelist revoked".
-- While on, nobody can join if the panel can't be reached, because the allowlist can't be checked.
Config.EnforceAllowlist = true

-- Connect queue. When the server is full (sv_maxclients), players wait in a queue instead of being refused.
-- Order: anyone reconnecting within RejoinMinutes of leaving goes to the front, then players with priority points
-- (Discord roles you give points on the panel's Servers page, e.g. subscriber tiers), then whoever waited longest.
-- Turn off any other queue resource (connectqueue, etc.) before enabling this.
Config.Queue = {
    Enabled = false,
    RejoinMinutes = 15,

    -- The screen players see while waiting (styled by Config.ConnectCards). false = FiveM's plain text line.
    Card = {
        Message = 'Subscribers skip ahead of the queue.', -- status shown to players with no priority
    },
}

-- Look of the cards in the connecting screen: the queue, bans and "not allowlisted".
Config.ConnectCards = {
    Logo = nil,        -- image URL; nil = the Helm logo. A wide PNG around 400x120 looks best.
    ServerName = 'Midnight RP',  -- shown under the logo, e.g. 'Midnight RP'
    -- Buttons on every card, opened in the player's browser. Up to 3 fit (ban cards add a Close button).
    Links = {
         { label = 'Discord', url = 'https://discord.gg/uwJqgwf6pC' },
        -- { label = 'Store', url = 'https://yourserver.tebex.io' },
        -- Ban cards already get an Appeal button to the panel's appeal page, with the ban ID filled in.
    },
}

-- Let the panel's Schedules page restart this server: players are dropped with a message, then the server quits.
-- Only turn this on if txAdmin (or your host) starts the server again automatically after it stops.
Config.ScheduledRestarts = false

-- Anti-cheat style alerts. Checked on the server every few seconds; nothing is punished automatically, staff get
-- an alert on the panel (Alerts page, Discord webhooks) and decide. Staff with the in-game menu are never flagged.
Config.AntiCheat = {
    Enabled = true,
    GodMode = true,        -- player stays invincible for over 15 seconds
    Health = true,         -- health or armour above the game maximum
    Invisible = true,      -- invisible for over 30 seconds (turn off if your scripts hide players, e.g. hiding in trunks)
    Weapons = true,        -- holding a weapon from the list below
    Teleport = true,       -- repeatedly moving faster than possible (housing/garage teleports alone won't trigger it)
    EntitySpam = true,     -- spawning lots of vehicles, peds or props at once
    MaxFootSpeed = 60,     -- metres per second on foot
    MaxVehicleSpeed = 250, -- metres per second in a vehicle (jets included)
    MaxSpawnsPer10s = 40,  -- raise it if prop or heist scripts spawn a lot at once
    BlacklistedWeapons = {
        'WEAPON_RAILGUN', 'WEAPON_RAILGUNXM3', 'WEAPON_MINIGUN', 'WEAPON_RPG', 'WEAPON_HOMINGLAUNCHER',
        'WEAPON_GRENADELAUNCHER', 'WEAPON_COMPACTLAUNCHER', 'WEAPON_RAYMINIGUN', 'WEAPON_RAYPISTOL', 'WEAPON_RAYCARBINE',
        'WEAPON_EMPLAUNCHER', 'WEAPON_FIREWORK', 'WEAPON_STICKYBOMB',
    },
}

-- Players report problems with /report [player id] message. Reports appear on the panel's Reports page and
-- staff with a linked game account get an in-game notification.
Config.ReportCommand = 'report'

-- Refuse players connecting from the same device as a banned player (hardware tokens). Off by default: shared
-- or family PCs can match, so staff are notified instead and can decide. Shared accounts (Discord, Steam, ...)
-- are always refused.
Config.BlockBanEvasion = true

-- Banned or non-allowlisted players see a card (styled by Config.ConnectCards) with the details while connecting.
-- Set to false for FiveM's plain text message only.
Config.BrandedRejections = true

-- On-screen notices. Announcements show as a banner at the top of the screen; warnings show a notice
-- in the middle that the player has to acknowledge. Staff alerts and report messages show as a card at the
-- top of the screen; staff can turn staff alerts off for themselves in the staff menu or with /helmalerts.
Config.Notices = {
    AnnouncementSeconds = 12,  -- how long an announcement stays up
    WarningMinSeconds = 5,     -- how long before a warning can be dismissed, so it gets read
    NoticeSeconds = 8,         -- how long a staff alert or report message stays up
    RemovalSeconds = 8,        -- kick/ban screen shown in game before disconnecting (0 = disconnect at once)
    Sound = true,
    AlsoChat = true,           -- also post to chat when the chat resource is running

    -- Tell players when staff do something to them (a card at the top of their screen). Warnings, kicks, bans,
    -- freezes and messages always show. Anything not listed here is on.
    ShowStaffName = true,      -- "Rhys teleported you" rather than "Staff teleported you"
    TellPlayer = {
        revive = true, heal = true, teleport = true, bring = true, sendback = true,
        give_item = true, remove_item = true, clear_inventory = true, set_money = true, set_job = true,
        give_vehicle = true,
        ['goto'] = false,      -- staff teleporting to the player
        spectate = false,      -- off by default so investigations stay quiet
        screenshot = false,
    },
}

-- Screenshots of a player's screen, taken from their player page on the panel. Built in: no other resource
-- is needed. They show the game and its HUD, but not menus drawn by scripts (NUI).
Config.Screenshots = {
    Enabled = true,
    MaxWidth = 1280,  -- pictures wider than this are scaled down (smaller uploads)
    Quality = 0.75,   -- JPEG quality, 0.1 to 1.0
}

-- Keep a local copy of the ban list so banned players are still refused if the panel is unreachable.
Config.BanCache = true
Config.BanListSeconds = 120

Config.Debug = false

-- In-game staff menu. Staff are matched by the Discord ID linked on the panel's Staff & roles page,
-- and every action is authorised by the panel, not by this resource.
Config.MenuCommand = 'helm'
Config.MenuKey = 'F7'

-- In-city activity logging. Everything is sent to the panel's Activity log.
Config.Logging = {
    Enabled = true,
    FlushSeconds = 5,          -- how often queued events are sent
    Connections = true,        -- join / leave
    Chat = true,               -- chat messages
    Commands = true,           -- slash commands
    CommandArguments = false,  -- false = log the command name only (arguments can hold private text); true = log everything
    -- Commands whose arguments are never logged (the command name still is).
    RedactCommands = { 'login', 'register', 'password' },
    Deaths = true,             -- needs the standard 'baseevents' resource
    Vehicles = true,           -- enter / leave vehicle (needs 'baseevents')
    Explosions = true,
    Combat = true,             -- who shot, hit or ran over whom, with weapon and distance (for RDM / VDM reports)
    Economy = true,            -- cash / bank changes
    Jobs = true,
    Characters = true,         -- character loaded / unloaded
    Inventory = true,          -- item moves between players, drops and stashes (ox_inventory only)
}
