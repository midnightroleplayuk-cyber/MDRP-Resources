-- ------------------------------------------------------------
-- NOTE ABOUT THE TEXTS IN THIS FILE
-- Many labels below are written in Portuguese ON PURPOSE (device colours, shop texts, Eats menus,
-- services, map places...): they are the translation keys of the phone, which shows each one in the
-- language chosen by the player (15 languages). The English text is given in a trailing "-- EN:"
-- comment. If you replace a label with your own text it is shown exactly as you write it, in every
-- language.
-- ------------------------------------------------------------
Config = {}

-- ------------------------------------------------------------
-- Framework
-- ------------------------------------------------------------
-- 'auto' detects in this order: qbx_core (QBox) > qb-core (QBCore) > es_extended (ESX).
-- Force it with 'qb' | 'qbx' | 'esx' if you have more than one started.
-- 'standalone' = NO framework: the identity is the player's license, the name is the FiveM name, the job is
-- 'unemployed', the number lives only in apex_phone_accounts and money only exists if you wire up the hooks
-- in Config.Standalone (below). Admin = ACE 'apex_phone.admin'. 'auto' NEVER falls back to standalone
-- on its own (on a QB server with qb-core stopped it would create new accounts keyed by license).
-- A forced value ('qb' | 'qbx' | 'esx' | 'standalone') applies on BOTH sides: the client uses it too.
Config.Framework = 'qbx'

-- Only for Config.Framework = 'standalone'. All hooks are optional (they only run on the SERVER).
--   identifier  = identifier type used as the "citizenid" ('license' | 'license2' | 'fivem' | 'discord' ...)
--   getMoney(src, tipo)                  -> number        tipo = 'cash' | 'bank'
--   addMoney(src, tipo, valor, motivo)   -> true/false
--   removeMoney(src, tipo, valor, motivo)-> true/false
--   addMoneyOffline(cid, tipo, valor)    -> true/false    (transfers to offline players)
--   notify(src, mensagem, tipo)          -> in-game notifications (by default they go to chat)
-- Without money hooks: balance is 0 and every payment is refused (money is never invented).
-- Job apps (admin panel) in standalone, also optional:
--   getJob(src)          -> { name, label, grade, gradeLevel, onduty }   without this hook everyone is 'unemployed' (no team side)
--   setDuty(src, on)     -> true/false                                    without it the Duty module is read-only
--   jobs = { { name = 'police', label = 'Policia', grades = { { level = 0, label = 'Cadete' } } } }   list used by the app builder
Config.Standalone = {
    identifier = 'license',
    getMoney = nil, addMoney = nil, removeMoney = nil, addMoneyOffline = nil, notify = nil,
    getJob = nil, setDuty = nil, jobs = nil,
}
-- Society accounts (invoices with society=job): 'auto' picks the first one started
-- (qb-banking > qb-management > Renewed-Banking; ESX: esx_addonaccount > Renewed-Banking).
-- You can force the resource name ('qb-banking', 'Renewed-Banking', 'esx_addonaccount', ...) or 'none'.
Config.SocietyProvider = 'auto'

-- ------------------------------------------------------------
-- Keys / commands
-- ------------------------------------------------------------
-- The phone opens in ONLY two ways: the Config.OpenKey key (opens the first phone in the inventory, or the last one
-- you used) and USING the item in the inventory. There are no other keys or chat commands.
Config.OpenKey  = 'F1'      -- open/close
Config.Command  = ''        -- chat command to open (e.g. 'phone' -> /phone). EMPTY = no chat command

-- ⚠️ FiveM stores the key PER COMMAND NAME in each player's profile, and that saved bind SURVIVES the resource
-- no longer registering the shortcut. That is how F2 kept opening the phone: F2 stayed bound to the old
-- Vera command ('apex_vera') and, in other profiles, to 'phone'. Those old commands are now registered WITHOUT
-- doing anything (client/main.lua), so those saved binds die, and the open key lives on a NEW command:
-- changing this name forces FiveM to apply Config.OpenKey to everyone again.
Config.KeyCommand = 'apexphone_open'

-- Vera assistant with the phone closed. EMPTY = no key (default).
-- ⚠️ Never use F2: it is the ox_inventory inventory key.
Config.VeraKey  = ''

-- ------------------------------------------------------------
-- Device
-- ------------------------------------------------------------
-- On-screen scale (1.0 = 440x956 px). Players can change it in Settings > Display.
-- ⚠️ An account that picks a size in Settings > Display saves that choice (`phoneScaleV2`, in
--    html/js/system.js) and it overrides this line: for those accounts, changing it here does nothing until they
--    pick again (the three sizes are 0.58 / 0.68 / 0.80). Choices saved BEFORE that key
--    (`phoneScale`) are ignored on purpose, since they prevented a higher scale set here
--    from reaching players who had already picked a size.
Config.Scale      = 0.68          -- previously 0.6; raised slightly (+13%)
Config.Offset     = { right = 24, bottom = 16 }   -- distance (px) from the phone to the bottom-right corner of the game screen (keeps it clear of the HUD)
Config.Frame      = 'black'       -- default frame colour: black | white | blue | wine | orange | silver

-- Mouse cursor visible while the phone is open. false = keyboard/gestures only, and the pointer is ALSO hidden
-- in the Camera and Face Key (they use the same value).
Config.ShowCursor    = true
-- Walk with the phone open (NUI focus with "keep input"). Walking (WASD), sprinting, jumping and voice stay
-- free; everything else is blocked for the game while the phone is open: mouse look,
-- attack/aim, weapons (wheel, 1-9, reload), P/Esc, M, T/Y (chat), Enter, F (enter/exit
-- vehicles), E/Q and V/C. The full list is in client/main.lua (WALK_BLOCK).
Config.AllowWalking  = true
-- Keep the VOICE working while the phone (and the phone shop) is open, even with Config.AllowWalking = false.
-- Without it the NUI takes the keyboard away from the game and the push-to-talk key (pma-voice, mumble-voip,
-- SaltyChat: the game's INPUT_PUSH_TO_TALK or a key mapping) never fires: players could not talk on a call with the
-- phone in front of them nor while buying a phone. With it the game keeps receiving the keyboard, every game control
-- is disabled frame by frame except push-to-talk, and the player stands still. Typing in a text field still cuts the
-- game input, so letters never reach the game. false = the old behaviour (no voice with the phone or the shop open).
Config.KeepVoice     = true
-- Walk with the Camera open (W/A/S/D, run and jump), even with Config.AllowWalking = false. Looking around still has to
-- only happen while dragging in the viewfinder. false = the camera keeps the player standing still.
Config.CameraWalk    = true
-- Hold this key to look around with the mouse while the phone is open: the pointer hides and the mouse turns the game
-- camera; release it and the pointer comes back. Never while typing in a text field or with the Camera open. Default
-- 'LMENU' (left Alt); ox_target also uses Alt but stays off while the phone has focus. Players can rebind it in
-- Settings > Key Bindings > FiveM. '' = no look key.
-- 1.2.0: the phone page itself also listens for Alt (LMENU / RMENU), so holding it works even when the game does not
-- receive the keyboard (Config.AllowWalking and Config.KeepVoice both false) and while the mouse is over the phone.
-- ⚠️ FiveM saves the key per player the first time: changing it here only reaches players who never had it.
Config.LookKey       = 'LMENU'
-- Closes the phone on death (or last stand) and prevents opening it while dead.
Config.BlockWhenDead = true

-- Language and theme a NEW account starts with (the setup assistant preselects them; the player can change them later in
-- Settings > General > Language). Also applies to in-game notifications, chat and command suggestions until
-- the player's phone has reported its language. Languages (16):
--   'en' English · 'es' Español · 'zh-Hans' 简体中文 · 'zh-Hant' 繁體中文 · 'ja' 日本語 · 'fr' Français · 'de' Deutsch
--   'ru' Русский · 'pt' Português · 'it' Italiano · 'ko' 한국어 · 'nl' Nederlands · 'tr' Türkçe · 'pl' Polski · 'sv' Svenska
--   'da' Dansk
-- A code that is not in the list falls back to 'en' (phone and in-game texts alike).
Config.DefaultLanguage = 'en'
Config.DefaultTheme    = 'dark'    -- 'light' | 'dark' | 'auto'

-- Your own language (1.1.8). Every text of the phone and of the game notifications is translatable from the readable
-- files, so a language that is not shipped can be added without touching the build:
--   1. copy html/js/i18n-en.js to html/js/i18n-<code>.js, change the code in I18N.add("en", ...) and translate the
--      values (the keys are the Portuguese source texts: never change them);
--   2. copy locales/en.lua to locales/<code>.lua, change Locales["en"] to Locales["<code>"] and translate the values
--      (these are the texts shown outside the phone: notifications, chat, command help, key names, shop blip);
--   3. add 'locales/<code>.lua' to client_scripts in fxmanifest.lua (after 'locales/da.lua');
--   4. list the language here: it appears in the setup assistant and in Settings > General > Language, and it is a
--      valid value for Config.DefaultLanguage. `name` is the language's own name, as shown to the player.
-- Example: Config.ExtraLanguages = { { code = 'no', name = 'Norsk' }, { code = 'fi', name = 'Suomi' } }
Config.ExtraLanguages = {}

-- Currency shown across the whole phone (Wallet, Bills, Marketplace, Eats, Onion/crypto, custom apps) and in the
-- server notifications. It is display only: the amounts themselves come from the framework.
--   symbol    '$' | '€' | '£' | 'R$' | ...
--   position  'before' ($1,250.00) | 'after' (1 250,00 €)
--   space     true/false: a space between the number and the symbol (default: none with 'before', one with 'after')
--   thousands / decimal  separators used by the SERVER in notifications (the phone UI follows the player's language)
-- Euro example: Config.Currency = { symbol = '€', position = 'after', thousands = ' ', decimal = ',' }
-- The phone shop (Config.Shop.currency) starts from this too; the admin panel can still override the shop's symbol.
Config.Currency = { symbol = '£', position = 'before', thousands = ',', decimal = '.' }

-- FormatMoney(1250.5) -> '$1,250.50' (or '1 250,50 €' with the euro example). Shared: server and client.
function FormatMoney(n, symbol, position)
    local c = type(Config.Currency) == 'table' and Config.Currency or {}
    n = tonumber(n) or 0
    local neg = n < 0
    n = math.abs(n)
    local int = math.floor(n + 0.000001)
    local cents = math.floor((n - int) * 100 + 0.5)
    if cents >= 100 then int, cents = int + 1, 0 end
    local s = tostring(int)
    local pos = position or c.position
    local sep = c.thousands
    if sep == nil then sep = (pos == 'after') and ' ' or ',' end
    if sep ~= '' then
        local k
        repeat s, k = s:gsub('^(%d+)(%d%d%d)', '%1' .. sep:gsub('%%', '%%%%') .. '%2') until k == 0
    end
    if cents > 0 then s = s .. (c.decimal or ((pos == 'after') and ',' or '.')) .. string.format('%02d', cents) end
    local sym = tostring(symbol or c.symbol or '$')
    local space = c.space
    if space == nil then space = (pos == 'after') end
    local sp = space and ' ' or ''
    local out = (pos == 'after') and (s .. sp .. sym) or (sym .. sp .. s)
    return (neg and '-' or '') .. out
end

-- Where the prop is attached to the hand: ped bone + offset + rotation (degrees).
-- A device can have its own `attach = { bone, pos, rot }` in Config.Devices.
Config.PropAttach = { bone = 28422, pos = vector3(0.0, 0.0, 0.0), rot = vector3(0.0, 0.0, 0.0) }
-- Prop that follows the frame COLOUR when the phone opens without one of the Config.Devices
-- (key with Config.RequireItem = false, or the generic item Config.PhoneItem).
-- PearPhone 18 Pro Max models (stream/apex_pear18_*.ydr). Legacy frames map to the closest colour.
Config.FrameProps = { black = 'apex_pear18_black', white = 'apex_pear18_white', blue = 'apex_pear18_ice', wine = 'apex_pear18_wine',
    -- Android (NOVA S26 Ultra): stream/apex_s26_*.ydr + apex_s26_devices.ytyp
    ['s26-black'] = 'apex_s26_black', ['s26-white'] = 'apex_s26_white', ['s26-violet'] = 'apex_s26_violet', ['s26-sky'] = 'apex_s26_sky',
    -- foldables: the whole fallback prop (normally the two pieces from Config.Devices[item].fold are used)
    ['fold-night'] = 'apex_pear18_ice', ['fold-star'] = 'apex_pear18_white',
    ['flip-lavender'] = 'apex_s26_violet', ['flip-grey'] = 'apex_s26_black', ['flip-cream'] = 'apex_s26_white', ['flip-pistachio'] = 'apex_s26_sky' }

-- ------------------------------------------------------------
-- DEVICES (ox_inventory items)
-- Each item has its own hand prop, its own frame colour AND its own wallpaper: using the black one opens a
-- black phone, using the wine one opens a wine phone, and so on. ONLY these four open the phone.
-- The models are in stream/ (apex_pear18_*.ydr + apex_pear18.ytyp).
-- Copy the items from inventory_items.lua into ox_inventory (see README).
-- ------------------------------------------------------------
-- `os` = device system: 'ios' (PearOS, the original) or 'android' (Nova UI, the NOVA S26 Ultra).
-- Apps, account, number and data are THE SAME on both systems: a player with a PearPhone calls, texts,
-- video calls and shares photos with someone who has an S26 (and vice versa). Only the system look changes.
-- Without `os` the device is 'ios'.
Config.Devices = {
    pear18_black = { label = 'PearPhone 18 Pro Max · Preto',     prop = 'apex_pear18_black', frame = 'black', os = 'ios' },  -- EN: PearPhone 18 Pro Max · Black
    pear18_white = { label = 'PearPhone 18 Pro Max · Branco',    prop = 'apex_pear18_white', frame = 'white', os = 'ios' },  -- EN: PearPhone 18 Pro Max · White
    pear18_ice   = { label = 'PearPhone 18 Pro Max · Azul-gelo', prop = 'apex_pear18_ice',   frame = 'blue',  os = 'ios' },  -- EN: PearPhone 18 Pro Max · Ice Blue
    pear18_wine  = { label = 'PearPhone 18 Pro Max · Bordô',     prop = 'apex_pear18_wine',  frame = 'wine',  os = 'ios' },  -- EN: PearPhone 18 Pro Max · Burgundy
    -- ANDROID: NOVA S26 Ultra (Nova UI 9). Models in stream/apex_s26_*.ydr + apex_s26_devices.ytyp (taken from the
    -- apex_s26_devices resource). Same grip as the PearPhone: bone 28422, position and rotation at
    -- zero. If it looks misaligned in game: `attach = { bone = 28422, pos = vector3(x, y, z), rot = vector3(x, y, z) }`.
    -- If a model is missing, the client uses the next prop (Config.FrameProps, then Config.PhoneProp) and warns in the console.
    s26_black    = { label = 'NOVA S26 Ultra · Preto',        prop = 'apex_s26_black',  frame = 's26-black',  os = 'android' },  -- EN: NOVA S26 Ultra · Black
    s26_white    = { label = 'NOVA S26 Ultra · Branco',       prop = 'apex_s26_white',  frame = 's26-white',  os = 'android' },  -- EN: NOVA S26 Ultra · White
    s26_violet   = { label = 'NOVA S26 Ultra · Violeta',      prop = 'apex_s26_violet', frame = 's26-violet', os = 'android' },  -- EN: NOVA S26 Ultra · Violet
    s26_sky      = { label = 'NOVA S26 Ultra · Azul-celeste', prop = 'apex_s26_sky',    frame = 's26-sky',    os = 'android' },  -- EN: NOVA S26 Ultra · Sky Blue

    -- FOLDABLES: each one is TWO pieces in stream/apex_fold_*_base/_leaf.ydr
    -- (+ apex_fold_apple.ytyp / apex_fold_samsung.ytyp). The base is attached to the hand (`fold.attach`) and the leaf to the base
    -- at the hinge: opening the phone unfolds it in the hand, closing folds it before it goes into the pocket.
    --   axis/dir   hinge axis and direction in the models (Fold: Z; Flip: X), as exported
    --   callAngle  how it sits at the ear during a call with the phone closed: 180 = closed (the Fold uses the outer screen),
    --              0 = open (the Flip is answered open)
    --   attach     bone SKEL_R_Hand (57005) + position/rotation. Starting values: confirm in game.
    -- `prop` is the whole fallback model if the pieces are missing.
    -- NOVA Fold8 keeps the novaflip_* / apex_fold_flip_* IDs and flip-* colours for existing inventories.
    -- The Fold8 opens like a book; the existing interface controls its state through the foldState event.
    -- Fold8 attach: conversion calibrated from the previous Flip geometry; confirm in game.
    pearfold_night = { label = 'PearPhone Fold · Azul-noite',    frame = 'fold-night', os = 'ios', model = 'PearPhone Fold', prop = 'apex_pear18_ice',  -- EN: PearPhone Fold · Midnight Blue
        fold = { base = 'apex_fold_apple_night_base', leaf = 'apex_fold_apple_night_leaf', axis = 'z', dir = 1.0, callAngle = 180.0,
                 attach = { bone = 57005, pos = vector3(0.1650, -0.0185, -0.0750), rot = vector3(153.0, 99.0, 0.0) } } },   -- /phonepos
    pearfold_star  = { label = 'PearPhone Fold · Branco-estrela', frame = 'fold-star', os = 'ios', model = 'PearPhone Fold', prop = 'apex_pear18_white',  -- EN: PearPhone Fold · Star White
        fold = { base = 'apex_fold_apple_star_base', leaf = 'apex_fold_apple_star_leaf', axis = 'z', dir = 1.0, callAngle = 180.0,
                 attach = { bone = 57005, pos = vector3(0.1650, -0.0185, -0.0750), rot = vector3(153.0, 99.0, 0.0) } } },   -- /phonepos
    novaflip_lavender  = { label = 'NOVA Fold8 · Lavanda',  frame = 'flip-lavender',  os = 'android', model = 'NOVA Fold8', prop = 'apex_s26_violet',  -- EN: NOVA Fold8 · Lavender
        fold = { base = 'apex_fold_flip_lavender_base', leaf = 'apex_fold_flip_lavender_leaf', axis = 'z', dir = 1.0, callAngle = 180.0,
                 attach = { bone = 57005, pos = vector3(0.1800, -0.0140, -0.0775), rot = vector3(33.75, -72.0, 185.5) } } },   -- /phonepos
    novaflip_grey      = { label = 'NOVA Fold8 · Cinzento', frame = 'flip-grey',      os = 'android', model = 'NOVA Fold8', prop = 'apex_s26_black',  -- EN: NOVA Fold8 · Grey
        fold = { base = 'apex_fold_flip_grey_base', leaf = 'apex_fold_flip_grey_leaf', axis = 'z', dir = 1.0, callAngle = 180.0,
                 attach = { bone = 57005, pos = vector3(0.1800, -0.0140, -0.0775), rot = vector3(33.75, -72.0, 185.5) } } },   -- /phonepos
    novaflip_cream     = { label = 'NOVA Fold8 · Creme',    frame = 'flip-cream',     os = 'android', model = 'NOVA Fold8', prop = 'apex_s26_white',  -- EN: NOVA Fold8 · Cream
        fold = { base = 'apex_fold_flip_cream_base', leaf = 'apex_fold_flip_cream_leaf', axis = 'z', dir = 1.0, callAngle = 180.0,
                 attach = { bone = 57005, pos = vector3(0.1800, -0.0140, -0.0775), rot = vector3(33.75, -72.0, 185.5) } } },   -- /phonepos
    novaflip_pistachio = { label = 'NOVA Fold8 · Pistácio', frame = 'flip-pistachio', os = 'android', model = 'NOVA Fold8', prop = 'apex_s26_sky',  -- EN: NOVA Fold8 · Pistachio
        fold = { base = 'apex_fold_flip_pistachio_base', leaf = 'apex_fold_flip_pistachio_leaf', axis = 'z', dir = 1.0, callAngle = 180.0,
                 attach = { bone = 57005, pos = vector3(0.1800, -0.0140, -0.0775), rot = vector3(33.75, -72.0, 185.5) } } },   -- /phonepos
}
-- Preference order when opening with the KEY (F1): uses the first one the player has.
Config.DeviceOrder = { 'pear18_black', 'pear18_white', 'pear18_ice', 'pear18_wine', 's26_black', 's26_white', 's26_violet', 's26_sky',
    'pearfold_night', 'pearfold_star', 'novaflip_lavender', 'novaflip_grey', 'novaflip_cream', 'novaflip_pistachio' }

-- Names shown by the Android phone (Settings > About phone, device name, welcome screen).
-- They are proper names on purpose (like "PearPhone"/"PearOS" on the iPhone): changing them here changes them everywhere.
Config.Android = { brand = 'NOVA', model = 'NOVA S26 Ultra', osName = 'Nova UI', osVersion = '9', store = 'NOVA Store' }
-- Test command (admin) that gives ALL devices in Config.DeviceOrder (ox_inventory, qb or esx). '' disables the command.
-- /phonegive [id] [item] gives a single one; /phoneopen [id] [app] and /phonenumber [id] [new] are also admin-only.
Config.DeviceGrantCommand = 'apexdevices'

-- Official wallpapers (optional): put the files in html/img/wallpapers/ and list them here.
-- The designed "PearPhone 18" wallpapers (rings) always exist, in every colour.
-- Since 1.1.4 an entry can also be an image LINK: 'https://i.imgur.com/xxxx.jpg' or { url = 'https://…', name = 'Los Santos' }.
-- Linked wallpapers show on both systems (PearPhone and NOVA). ⚠️ Discord attachment links (cdn.discordapp.com/attachments/…?ex=…)
-- expire after about 24 h; for a permanent wallpaper use a file in html/img/wallpapers/ or a permanent image host.
-- One per DEVICE COLOUR: the default wallpaper ("Cor do aparelho" (Device colour)) follows the frame of the item the
-- phone was opened with (pear18_black -> black.jpg, ...; see FRAME_FILE in html/js/wallpapers.js). Players who pick
-- another wallpaper in Settings keep that one.
Config.Wallpapers = {
    'black.jpg',   -- PearPhone 18 Pro Max Black
    'white.jpg',   -- PearPhone 18 Pro Max White (also the silver frame)
    'blue.jpg',    -- PearPhone 18 Pro Max Ice Blue
    'wine.jpg',    -- PearPhone 18 Pro Max Wine (also the legacy orange frame)
    -- Android (NOVA S26 Ultra): one per colour; the Android phone only shows the s26-* ones, the PearPhone only the others
    's26-black.jpg', 's26-white.jpg', 's26-violet.jpg', 's26-sky.jpg',
    -- { url = 'https://i.imgur.com/xxxx.jpg', name = 'Los Santos' },   -- example of a linked wallpaper
}
-- "Upload image" for players (1.1.4): Settings > Wallpaper > "Add image from link" and the "Link" category of "Add new wallpaper".
-- The player pastes a direct image link (Discord, Imgur, Fivemanage…) or a copied image (Ctrl+V), which is saved in Photos.
-- The link is only accepted once the image really loads (preview). The result is a normal "from Photos" wallpaper.
--   enabled    false = the option disappears everywhere
--   hosts      {} = any https site; or a list of allowed hosts, e.g. { 'cdn.discordapp.com', 'media.discordapp.net', 'i.imgur.com' }
--   maxLength  maximum length of a link (characters)
--   paste      false = links only (no pasted images)
-- ⚠️ Discord attachment links carry an expiry (?ex=…): the wallpaper stops loading after about 24 h and the player has to paste
--    a new link. Permanent hosts (Imgur, Fivemanage, your own CDN) do not have that problem.
Config.WallpaperLinks = { enabled = true, hosts = {}, maxLength = 512, paste = true }
-- Photos from links (1.3.0): Photos > Library > "Add from link" (PearOS: button in the header and in the empty gallery;
-- Nova UI: Images > "..." menu and the empty gallery). The player pastes a direct https image link (Discord, Imgur,
-- Fivemanage...) or a copied image (Ctrl+V); the link is only accepted once the image really loads and is saved as a
-- photo of the gallery (it can then be shared, posted, used as a contact photo or as a wallpaper). Same options as
-- Config.WallpaperLinks; when this table is missing (old config.lua) the WallpaperLinks values are used.
--   enabled    false = the option disappears from the Photos app
--   hosts      {} = any https site; or a list of allowed hosts, e.g. { 'i.imgur.com', 'cdn.discordapp.com', 'media.discordapp.net' }.
--              ⚠️ The list is ALSO enforced by the server (photos.add refuses other hosts with { error = 'host' }), and it applies to
--              every link saved into a gallery, including a mail attachment or a received photo that is itself a link.
--   maxLength  maximum length of a link (characters)
--   paste      false = links only (no pasted images)
-- With enabled = false here AND in Config.WallpaperLinks the server refuses every http(s) link in the gallery ({ error = 'disabled' }).
-- ⚠️ Discord attachment links expire after about 24 h: the photo stops loading and the player has to paste a new link.
Config.PhotoLinks = { enabled = true, hosts = {}, maxLength = 512, paste = true }
Config.DefaultPin = '1225'   -- only for accounts created some way other than the setup assistant (which sends the chosen passcode or "no passcode")
Config.PhoneProp  = 'apex_pear18_black'

-- Wrong passcode: the server counts attempts (per character, in memory) and locks.
-- After `attempts` consecutive failures it locks for seconds[1] seconds; each further failure moves up one step
-- (the last value repeats). A correct entry resets everything. false = no lockout.
Config.PinLock = { attempts = 5, seconds = { 30, 60, 300, 900 } }

-- The passcode is stored HASHED in the database (salted SHA-256, repeated `rounds` times; format
-- "h1$sal$rondas$hex"). Old plain-text passcodes are converted automatically on startup.
-- MEASURED cost: ~3.8 ms per check with 96 rounds (official Lua 5.4 in WebAssembly on a desktop PC,
-- usually slower than FXServer's Lua; not measured inside FXServer). More rounds = slower to
-- brute-force from a DB dump, but each unlock also costs the server more (maximum 10000).
-- The calculation runs on the server main thread (~0.04 ms per round): 1000 rounds already means a ~40 ms hitch for
-- all players on every unlock. Above 256 a warning is printed to the console on startup. Recommended: 64 to 128.
-- Changing the value does not invalidate stored passcodes: each hash carries its own rounds and is redone on the next unlock.
-- ⚠️ No going back: once converted, an EARLIER version of apex_phone no longer recognises the passcodes (it compares
--    plain text). Going back to an old version requires clearing the `pin` column of the accounts (they all end up without a passcode).
-- ⚠️ A 4-6 digit passcode has few combinations: anyone with the database can still guess it.
--    The hash prevents READING the passcode in clear text; in game, protection comes from the attempt lockout (Config.PinLock).
Config.PinHash = { rounds = 96 }

-- Item required to open. false = the key always opens (with the default frame);
-- true = only opens with one of the Config.Devices (or Config.PhoneItem) in the inventory.
Config.RequireItem = true
Config.PhoneItem   = ''           -- generic item (in addition to Config.Devices); '' = only the four Config.Devices open the phone
Config.EarbudsItem = 'airpods'    -- usable item: PUTS ON/TAKES OFF the AirBuds (3D props on the head, visible to everyone); connecting is done on the phone (Bluetooth)
                                  -- (the NOVA Buds 4 Pro have their own item in Config.SlateBuds.item)

-- ------------------------------------------------------------
-- AIRPODS (built into the phone)
-- Using the item puts the 3D earbuds on the head (everyone sees them, up to `maxDistance` m); using it again takes them off.
-- With the AirBuds on, the phone shows them in Settings > Bluetooth (and on the card when you put them on) so you can CONNECT them.
-- Connected: Music keeps playing with the phone closed (only for you: the audio comes from the NUI, nobody else hears it).
-- Without AirBuds connected: closing the phone PAUSES the music (resumes on open). `pauseWithoutAirpods = false` disables that.
-- Props in stream/apex_airpod_*_v3.ydr + apex_airpods.ytyp (declared in the fxmanifest). ⚠️ The old apex_airpods resource
-- declares the SAME archetypes: it must stay stopped.
-- ------------------------------------------------------------
Config.AirPods = {
    name = 'AirPods Pro 3',
    pauseWithoutAirpods = true,
    maxDistance = 45.0,          -- metres: props are only created for players within this distance
    reconcileMs = 300,
    modelLoadTimeoutMs = 5000,
    retryDelayMs = 10000,
    models = { left = 'apex_airpod_l_v3', right = 'apex_airpod_r_v3' },
    -- Measured on the "skel" armature of MALE RIG - TEMPLATE.blend (bone SKEL_Head 31086): offset in metres in the bone's
    -- LOCAL space, rotation in degrees (order 2). The models already carry the bone orientation in their geometry.
    defaultFit = 'male_template',
    modelFits = { mp_m_freemode_01 = 'male_template' },   -- mp_f_freemode_01 = 'female_custom' (measure and add a preset)
    fits = {
        male_template = {
            bone = 31086,
            left  = { offset = { x = 0.0404005757, y = 0.0063777828, z =  0.0693098525 }, rotation = { x = 0.0, y = 0.0, z = 0.0 } },
            right = { offset = { x = 0.0402122846, y = 0.0079051542, z = -0.0689525697 }, rotation = { x = 0.0, y = 0.0, z = 0.0 } },
        },
    },
}

-- ------------------------------------------------------------
-- NOVA BUDS 4 PRO (built into the phone): the black earbuds
-- designed for the NOVA S26, working EXACTLY like the AirBuds (the item puts on/takes off the 3D pair on the head, connect on the
-- phone via Bluetooth, Music only for you with the phone closed, calls with the phone in the pocket). They work with both
-- phones. Only one pair is used at a time: using the other item swaps the pair.
-- Props streamed from stream/apex_slate_bud_l/_r.ydr (+ case apex_slate_case*.ydr) and stream/apex_slate_buds.ytyp.
-- ⚠️ The standalone apex_slate_buds resource declares the SAME archetypes: do NOT install it alongside this one.
-- ------------------------------------------------------------
Config.SlateBuds = {
    item = 'slate_buds',         -- '' disables the item
    name = 'NOVA Buds 4 Pro',
    models = { left = 'apex_slate_bud_l', right = 'apex_slate_bud_r' },
    -- Measured on MALE RIG - TEMPLATE.blend (bone SKEL_Head 31086), like the AirBuds; orientation is already baked into the models.
    defaultFit = 'male_template',
    modelFits = { mp_m_freemode_01 = 'male_template' },   -- mp_f_freemode_01 = 'female_custom' (measure and add a preset)
    fits = {
        male_template = {
            bone = 31086,
            left  = { offset = { x = 0.0404005757, y = 0.0063777828, z =  0.0693098525 }, rotation = { x = 0.0, y = 0.0, z = 0.0 } },
            right = { offset = { x = 0.0402122846, y = 0.0079051542, z = -0.0689525697 }, rotation = { x = 0.0, y = 0.0, z = 0.0 } },
        },
    },
}

-- ------------------------------------------------------------
-- Number / SIM
-- ------------------------------------------------------------
Config.NumberFormat        = '#########'   -- '#' = random digit (used when the character has no number or when swapping SIM)
Config.NumberPrefix        = '07'           -- prefix shown BEFORE the number (e.g. '+351' -> "+351 555-1234"). Visual only:
                                          -- numbers are still stored without it; dialling with or without the prefix calls the same number
Config.SyncNumberToCharInfo = true        -- writes the number to the framework (QB/QBox: charinfo.phone; ESX: users.phone_number)
Config.AllowSimSwap        = true         -- Settings > SIM > Swap SIM (generates a new number)

-- ------------------------------------------------------------
-- eSIM and LINES (server/sim.lua + client/sim.lua): up to 3 numbers on the same phone
-- The eSIM card is an item (ox_inventory: client.export = 'apex_phone.useEsim'); using it opens the phone on the camera and
-- the player SCANS THE QR CODE on the card, held in the left hand (3D prop apex_esim_card). Activation consumes ONE card.
-- Optional item metadata: { iccid = '8935100000xxxxxxxxx', number = '555-1234' (pre-assigned number) }.
-- Everything except item/price/labels/colors/scan can be changed in the admin panel (/phoneadmin > Phone > SIM and lines).
--   required    false = each account keeps its original number as line 1 and eSIMs ADD numbers
--               true  = no number without an activated eSIM ("No SIM": cannot call or text). Players who played before this
--                       version ALWAYS keep the number they had (a number is never taken from anyone).
--   maxLines    1..3 numbers per character
--   allowRemove the player can remove a line in Settings (the number becomes free for someone else)
--   scanSeconds how long the camera takes to "lock on" to the QR code
--   scan        card in hand: model, bone (60309 = PH_L_Hand, left hand), position/rotation, animation and camera.
--               The camera frames the CARD (follows it), so the viewfinder shows the QR code even if the grip is crooked;
--               tune pos/rot in game if the card appears sideways. Without the model in stream/ scanning still works (the NUI
--               draws the card) and the camera looks at the left hand.
-- ------------------------------------------------------------
Config.Sim = {
    required    = true,
    maxLines    = 3,
    item        = 'esim',
    price       = 150,
    allowRemove = true,
    scanSeconds = 1.6,
    carrier     = 'Midnight Mobile',
    labels      = { 'Main', 'Personal', 'Work' },   -- default labels per line (the player can change them; the NUI translates these)
    colors      = { '#901ad4', '#34bdc7', '#0aff78' },      -- default colour per line
    scan = {
        -- 'desk'   = the card appears INSIDE the phone's viewfinder, with the QR code in the frame. The 3D card goes to the
        --            left hand (prop, bone, pos, rot) without taking the phone out of the right hand or changing the animation, and without
        --            a game camera. (anim, fov, fill, distance and side only apply in 'camera' mode)
        -- 'camera' = legacy mode: the card goes to the left hand and a game camera frames it
        view     = 'desk',
        prop     = 'apex_esim_card',
        bone     = 60309,                                   -- PH_L_Hand
        pos      = vector3(0.0, 0.0, 0.0),
        rot      = vector3(0.0, 0.0, 0.0),
        anim     = { dict = 'amb@world_human_tourist_map@male@base', clip = 'base', flag = 49 },   -- both hands in front of the chest
        fov      = 40.0,                                    -- degrees (vertical)
        fill     = 0.72,                                    -- fraction of the viewfinder width taken up by the card
        distance = nil,                                     -- metres from the camera to the card (nil = calculated from fov/fill)
        side     = 1,                                       -- 1 = camera on the FRONT side (QR code, model +Z) | -1 = back | 'auto' = side facing the face
        timeout  = 60,                                      -- seconds without a scan: scanning closes by itself
    },
}

-- ------------------------------------------------------------
-- Calls
-- ------------------------------------------------------------
-- Notifications: with the phone CLOSED it rises just enough to read the notification
-- and lowers by itself after these seconds. Opening the phone during that time cancels the lowering.
Config.PeekSeconds = 3

Config.AutoOpenOnCall = true   -- opens the phone on an incoming call
Config.CallTimeout    = 30     -- seconds ringing before "missed"
Config.UseVoice       = true   -- integrate voice into calls (false = calls without audio)
-- Call voice system (client/voice.lua + server/voice.lua):
--   'auto' detects in order pma-voice, saltychat, mumble-voip; 'none' = no voice
--   Only pma-voice has been tested in game; the others follow their public APIs and have NOT been tested in game.
Config.Voice          = 'auto'

-- ------------------------------------------------------------
-- Photos: stored as BASE64 in the apex_phone_photos.url column (LONGTEXT). Works with no configuration.
-- The photo is the Camera app's own viewfinder (WebGL canvas with the game view, html/js/gamerender.js):
-- it is created at the right size, sent to the server in 48 KB chunks and read back the same
-- way (no base64 image fits whole in a single FiveM network event).
-- ------------------------------------------------------------
-- ⚠️ Config.Upload is NO LONGER USED. It stays here, empty, for anyone who wants to wire up a
--    webhook/CDN again (type: 'discord' | 'fivemanage' | 'custom' with response {url=...}).
Config.Upload = { url = '', field = 'files[]', type = 'fivemanage', quality = 0.8 }
Config.MaxPhotos = 60   -- per player (favourites are never deleted by the prune, so there can be more)

-- How many photos each player can mark as FAVOURITES (default 60, same as MaxPhotos).
-- The MaxPhotos prune only deletes NON-favourite photos, so without this cap a player could mark everything as
-- favourite and keep PhotoMaxBytes rows forever: per-player storage had no limit.
-- Once the cap is reached, the photos.fav RPC returns { error = 'toomany' } and the photo stays as it was;
-- existing favourites are NEVER unmarked or deleted (0 = no cap, as before).
Config.MaxFavPhotos = 60

-- Maximum size (in base64 characters) of ONE photo stored in the database.
-- The phone downscales the image until it fits here; upload to the server is done in chunks
-- (RPC photos.upload), so this limit has nothing to do with event size.
Config.PhotoMaxBytes = 260000

-- ------------------------------------------------------------
-- Camera: the FRAMING is GTA's native camera (the same one lb-phone uses), driven by
-- client/camera.lua. Only the device prop stays in the hand and the phone is NOT hidden when shooting
-- (the image is the GAME render, the NUI is not in it); the HUD and radar are hidden frame by frame.
--
-- IN GAME:
--   - AIM   = hold the LEFT mouse button and DRAG on the screen. When the button is released the view
--             stays still (that is why the cursor hits the buttons on the first click).
--   - SHOOT = ONLY the round button on the phone. There are no keys or buttons in the middle of the screen: the game
--             also maps "accept" to left click and "cancel" to right click, so every
--             drag click used to take a photo.
--   - Flip camera and go back: the device's own buttons.
-- ------------------------------------------------------------
Config.Camera = {
    -- JPEG quality (0..1). The Camera app saves its own viewfinder at 0.9, downscaled until it fits
    -- within the limit; this value is used for the Face Key photo.
    Quality = 0.85,
    -- HORIZONTAL viewfinder offset for SELFIES. GTA's native camera leaves the character slightly
    -- off to the side; this shifts the framing to centre it.
    -- POSITIVE = framing slides to the LEFT (reveals the left edge of the frame);
    -- NEGATIVE = to the right. Useful range: -0.25 .. 0.25 (0 = no offset).
    -- If it goes the wrong way, just flip the sign.
    -- ⚠️ The offset uses up the MARGIN between the viewfinder's 3:4 crop and the screen, so the same number
    -- shifts a bit more on a wide screen (21:9) than on 16:9. Tune it on yours.
    SelfieOffsetX = 0.08,
    -- Vertical. ⚠️ NO EFFECT in portrait modes (3:4): there the crop is exactly the screen height
    -- and there is no margin to slide. Only applies in PANO mode (16:9). Kept here for symmetry.
    SelfieOffsetY = 0.0,

    -- VIDEO (Camera app, VIDEO and TIME-LAPSE modes). The viewfinder is recorded for real (MediaRecorder on the
    -- viewfinder canvas, WebM/VP8), stored in the same gallery table as the photos and played back in the gallery.
    -- A video is a lot bigger than a photo: 15 s at 500 kbit/s is about 1 MB of base64 in the database and about
    -- 25 chunks of 48 KB on the way up. Keep the limits modest on busy servers.
    -- The limits per phone model (length, size, sound) are in config_recording.lua (Config.Recording). The values
    -- below are only used when Config.Recording is missing.
    VideoMaxSeconds = 15,        -- recording stops by itself at this length (3..60)
    VideoBitrate    = 500000,    -- bits per second of the video track (150000..4000000)
    VideoHeight     = 640,       -- height in pixels of the recorded video (the width follows the viewfinder ratio; 240..1080)
    VideoMaxBytes   = 1600000,   -- maximum size in base64 characters of ONE video in the database (the recording stops before)
    VideoAudio      = false,     -- true = also record the player's microphone (needs the FiveM CEF to grant the microphone)
}

-- ------------------------------------------------------------
-- VideoCall: the picture of the OTHER person in a FaceCall / video call.
-- FiveM has no player-to-player video, so each phone shrinks its own self-view to a small JPEG and sends it
-- through the server to the other participant (NUI -> client -> server -> other client). These values set how
-- smooth that picture is and how much network it uses. The defaults are tuned: change them only if you need to.
--
-- NETWORK BUDGET (upload of each player in a video call): at most fps x maxKB x 1000 characters per second.
--   Defaults: 8 x 8 000 = 64 000 B/s. That is half of FXServer's limit for client -> server events
--   (netEventSize: 131 072 B/s with a 393 216 B burst; a player who goes over it is KICKED with
--   "Reliable network event size overflow"). The other half stays free for everything else the player sends
--   at the same time, for example a photo taken during the call (up to 6 chunks of 48 KB).
--   fps x maxKB is capped at 96 (96 000 B/s): above that, maxKB is lowered automatically.
--   Events: fps per second, far below FXServer's 50 events/s limiter.
-- The phone (NUI), the client and the server all derive their limits from this ONE block, so a frame rate the
-- phone sends is never dropped by the client or server rate limits. 1.3.0 sent 4 pictures per second of
-- 192x256 (a slideshow); 8 smaller pictures per second fit in the same network budget and look fluid.
-- ------------------------------------------------------------
Config.VideoCall = {
    fps        = 10,      -- pictures per second each phone sends (2..12)
    width      = 144,    -- size in pixels of each picture sent (64..320). Any ratio works: the picture is cropped to
    height     = 192,    --   fill the other screen. 3:4 is exactly what you see in your own small window.
                         --   A bigger picture needs a bigger maxKB, otherwise its JPEG quality drops to fit.
    quality    = 0.5,    -- starting JPEG quality (0.2..0.8); it adapts by itself between minQuality and maxQuality
    minQuality = 0.25,   --   so that every picture stays under maxKB
    maxQuality = 0.65,
    maxKB      = 8,      -- largest picture, in thousands of base64 characters (3..14)
    pipQuality = 0.5,    -- resolution of your OWN small window during the call, as a fraction of the Camera app's
                         --   resolution (0.25..1). The Live Photo button on the call screen still shoots at full resolution.
    pipFps     = 30,     -- maximum redraws per second of your own small window (10..60). Lower = lighter on the GPU
}

-- ------------------------------------------------------------
-- Face Key
-- Enrolment uses the REAL camera: it locks onto the character's face and you aim with the MOUSE
-- (move the head, like on PearPhone). The ring only fills with the angles covered.
-- At the end it takes a photo of the face, stored as the Face Key reference.
-- Keys: Enter = continue | Backspace = set up later
-- ------------------------------------------------------------
Config.FaceId = {
    Required   = 26,     -- ticks (out of 32) needed to complete the scan
    Spread     = 3,      -- ticks lit at a time (higher = fills faster)
    MinAngle   = 5.0,    -- degrees off centre from which a tick counts
    MaxAngle   = 46.0,   -- how far the camera orbits around the face
    Timeout    = 25,     -- seconds until continuing is allowed even without closing the circle (never traps anyone)
    Photo      = true,   -- save the face photo (screenshot-basic); false = ring only
}

-- ------------------------------------------------------------
-- System: debug, rate limit, notifications
-- ------------------------------------------------------------
-- Extra logs: server (each RPC with time in ms, notifications, calls), client (F8: open,
-- close, camera, Face Key) and NUI. Keep false in production.
Config.Debug = false

-- Dbg('tag', 'formato %s', ...): same on both sides (this file is shared) and only prints with
-- Config.Debug. A malformed format string never breaks the caller (the raw text is printed).
function Dbg(tag, fmt, ...)
    if not Config.Debug then return end
    local ok, msg = pcall(string.format, tostring(fmt or ''), ...)
    if not ok then msg = tostring(fmt) end
    print(('^5[apex_phone:%s]^0 %s'):format(tostring(tag or 'debug'), msg))
end

-- Per-player server request limit ("token bucket"): refills `perSecond` tokens per second
-- up to `burst`; each RPC costs 1 token (or the cost in `costs`). No tokens -> { error = 'ratelimit' }.
--   costs  = { ['messages.send'] = 2, ['bank.transfer'] = 3 }   (overrides the default costs in server/main.lua)
--   exempt = { 'minha.app.upload' }   RPCs outside the main bucket. CHUNKED uploads/downloads
--            (photos.upload, photos.data, social.*.upload, social.*.media and any '*.upload') are already
--            exempt: one photo is dozens of requests in a row. Those have their own wide bucket,
--            only against flooding: chunkPerSecond / chunkBurst (0 = no limit at all).
-- NOTE: costs is not empty at runtime. server/recado_extras.lua (Recado app: polls, events,
-- documents and GIFs) adds these costs at startup, but ONLY where you have not set anything; if
-- you write your own value here, yours wins:
--   recado.poll.create 4, recado.event.create 4, recado.doc.share 3, recado.gif.search 3
--   recado.poll.vote   2, recado.event.rsvp   2, recado.event.cancel 2
-- (creating a poll/event writes two rows and pushes a message to the whole group; GIF makes an
-- HTTP request to an external service; voting and replying are cheap but push to all members). The other
-- default costs, including the rest of Recado's, are in RL_COSTS in server/main.lua.
Config.RateLimit = { enabled = true, perSecond = 12, burst = 40, costs = {}, exempt = {}, chunkPerSecond = 60, chunkBurst = 300 }

-- Notifications stored on the server (table apex_phone_notifications): offline players receive them
-- when they join and the notification centre can read the history. Automatic cleanup every 15 minutes:
-- notifications older than keepDays days are deleted and, per player, those beyond maxPerPlayer.
Config.Notifications = { keepDays = 14, maxPerPlayer = 200 }

-- Throttle for notifications that ONE PLAYER triggers for ANOTHER (likes, story replies, reactions to
-- Instants, comments, sales...). Only applies to NotifyCitizen, which is the path one person uses to
-- notify another; server notices to the player themselves (NotifyPlayer) do not go through here.
--   seconds = window size in seconds
--   max     = how many notifications from the SAME pair and of the SAME type get through per window
--   noThrottleApps = apps that are NEVER throttled (list or map). Omitting this key = the five
--             below; {} = throttle every app (the behaviour before this version)
-- The key is (recipient, app, notice title). For SOCIAL notices this counts per pair and per type, because
-- there the title is '@sender' plus the type ('@x replied to you', '@x reacted to your Instant'). Without this, 12
-- requests per second would fill another person's notification centre and, since cleanup only keeps
-- maxPerPlayer (200) per owner, push their history out in about half a minute.
-- ⚠️ BUT some notices have a FIXED title ('Fatura paga', 'Cripto recebida', 'Entrega concluida', 'Item
-- devolvido'): for those the key lumps different people and transactions into the same bucket, and the 5th notice in each
-- window would vanish, neither delivered nor stored. Since it is often the ONLY sign that money
-- or an item came in, the money/item apps are excluded from the throttle by default: billing, marketplace, onion,
-- crypto and eats. The full cost of this: a player with crypto can send hundreds of
-- tiny transfers (the crypto.send minimum is 0.00000001 ₿, and it costs 3 rate-limit tokens =
-- 4 per second, measured) and fill another person's notification centre with 'Cripto recebida'; at that
-- rate the 200 notices that cleanup keeps per person (Config.Notifications.maxPerPlayer, above)
-- are all filled in under a minute. No money is lost (the money history
-- lives in the apps, not here), only the notification centre history; if this happens on your
-- server, remove 'crypto' from the list (write out the whole list without that app).
-- Default 4 per 60 s for the other apps: enough for normal use (several mails from the same
-- sender) and cuts spam. seconds = 0, max = 0 or Config.NotifyThrottle = false disable the throttle.
-- Anything rejected is neither stored nor delivered; the action itself (the like, the reaction) still goes through.
Config.NotifyThrottle = { seconds = 60, max = 4, noThrottleApps = { 'billing', 'marketplace', 'onion', 'crypto', 'eats' } }

-- Cap on what the phone writes to the ACCOUNT on each account.update: `settings` and `layout` come from the
-- client and go into a LONGTEXT as-is. Maximum characters PER FIELD, already as JSON; above that
-- the request is rejected with { error = 'toolarge' } and NOTHING is saved (the server cache is not touched either).
-- The two values differ ON PURPOSE:
--   layout   is app ids per home screen page: a few KB at most. 64 000 is plenty, and this is the
--            only one of the two that actually bites: a larger layout is rejected
--   settings carries "Das Fotos" (From Photos) WALLPAPERS in base64, ~200 000 characters each, and the lock screen
--            stores one PER SCREEN (no cap on the number of screens). A cap of 64 000 here would stop saving
--            the settings, silently, for anyone using a wallpaper taken from Photos
-- ⚠️ DO NOT RELY ON THE `settings` CAP: 400 000 NEVER triggers. A FiveM network event cannot carry
-- that much (~260 KB; above that the event is dropped and never reaches the server), so the real cap for
-- `settings` is still the event size: this line is not protecting the column, only catching a
-- case FiveM already prevents. Lowering it to 64 000 does not help either: it would SILENTLY reject
-- the settings of players with wallpapers taken from Photos. The fix is to move the base64 out of
-- `settings` (store them as media, like every other image on the phone), which is NUI work.
-- A number instead of the table (Config.AccountMaxBytes = 100000) applies to both fields. 0 = no cap.
Config.AccountMaxBytes = { settings = 400000, layout = 64000 }

-- Notes, reminders, events, alarms, world clocks, Maps places, Arcade high scores and screen time
-- are stored on the server (apex_phone_userdata, one JSON row per key and character, server/userdata.lua) and no
-- longer only in the game cache: switching PC or clearing the FiveM cache no longer loses them. Cap PER KEY in bytes
-- (the same ~260 KB network event limit applies here; the NUI shows a "not saved" warning when it is rejected).
Config.UserDataMaxBytes = 250000

-- ------------------------------------------------------------
-- Retention: how many DAYS to keep the tables that only ever grew (0 = never delete, for any key).
-- Notifications have their own cleanup above; so do media, stories and darkchat. These
-- had none. The cleanup runs every `minutes` minutes, starting 2 minutes after startup, and
-- deletes in chunks of `batch` rows, with a pause between them, so it never locks a large table.
-- It NEVER deletes what is still in progress: unpaid bills (pending), undelivered Eats orders
-- and Onion orders with money or an item held in escrow stay where they are.
-- ⚠️ THIS DELETES PLAYER DATA, PERMANENTLY AND IRREVERSIBLY. That is why it ships ALL AT ZERO (disabled): a
-- server that already has players must not lose anything just by updating the phone. Enable what you
-- want, one key at a time, and watch the console (Config.Debug = true shows how many rows were removed).
-- Values we recommend when you decide to enable it, from most to least useful:
--   posts = 180 · calls = 90 · transactions = 180 · bills = 180 · services = 14
--   eatsOrders = 30 · onionOrders = 90 · maxPostsPerAccount = 200 · messages = 0 (leave at 0)
-- ⚠️ Before enabling: the first pass runs 2 minutes after startup and deletes ALL history that
-- is already past the limit in one go (on a server that is years old that is a lot of rows). Back up the database.
--   posts        Instashot/Tweeter/Reels posts (the full image as base64 in a LONGTEXT: this is the
--                fastest-growing table). When deleted, their likes/comments/saves are removed too, as well as
--                REPLIES left without a post (with no parent they would never show to anyone again and
--                would keep taking up rows and counting towards maxPostsPerAccount). A REPOST whose
--                original was deleted STAYS: it still shows in the feed, just without the original's block.
--                ⚠️ this is the accounts' photo wall: deleting by age removes their old photos
--   messages     SMS and Recado chats. Leave at 0: it is the same table as Recado chats, and deleting
--                an old chat means losing content, not a log entry. If you enable it, this is what happens
--                to anything pointing at message ids (verified by reading the code, not in game):
--                · Recado reactions and marks (stars, pins, already-opened "view once") are
--                  deleted with the messages (orphan sweeper in server/main.lua)
--                · each group's last message (apex_phone_conversations.last_id) is repointed to the
--                  remaining message, or left empty if none remains: the group stays in the list,
--                  with no preview and sorted by its creation date
--                · each member's "unread" marker (last_read_id) needs no fix: it is a watermark
--                  and ids only grow, so it still separates read from unread
--                · a pinned or starred message deleted by age disappears from those lists, as
--                  expected, but it is content the player had saved on purpose
--   calls        call history
--   transactions entries shown in the Bank app (the money itself belongs to the framework, it is not stored here)
--   bills        bills ALREADY PAID or declined (pending ones are never removed)
--   services     service requests (police, EMS, mechanics): relevant for minutes, junk after days
--   eatsOrders   delivered or cancelled Eats orders
--   onionOrders  completed or cancelled Onion orders (with nothing in escrow)
--   maxPostsPerAccount  ROW cap per social account, like Config.MaxPhotos: the most recent
--                are kept. ⚠️ REPLIES count too (they are rows in the same table), so anyone who
--                replies a lot uses up the cap on replies and loses old posts. 0 = no cap
--   minutes      interval between passes (minimum 15) · batch  rows per DELETE (100..20000)
-- ------------------------------------------------------------
Config.Retention = {
    minutes = 60, batch = 2000,
    -- all at 0 = nothing is deleted (the original behaviour). Recommended values are in the warning above.
    posts = 0, messages = 0, calls = 0, transactions = 0, bills = 0,
    services = 0, eatsOrders = 0, onionOrders = 0,
    maxPostsPerAccount = 0,
}

-- External apps: iframes registered by other resources (RegisterApp export). The phone tags every request
-- one of those apps makes to the server, and the server:
--   rpc       = only accepts these RPCs from external apps. The phone has the SAME fixed list (EXT_RPC in
--               html/js/apps/thirdparty.js): removing one here closes it; a new RPC must be added in BOTH places and is
--               open to ALL external apps
--   Each app id (RegisterApp) may only contain letters, numbers, _ - . : (up to 64 characters): with any other id, all
--   of that app's requests to the server are rejected (the phone warns in the NUI console, nui_devtools, when the app is registered)
--   sensitive = RPC -> permission type it requires, STORED ON THE SERVER (table apex_phone_app_grants). The phone
--               only stores it after the player taps "Allow" ("Allow once" is kept in memory only until they leave);
--               revoking it in Settings > Privacy deletes it. The four defaults always apply; here you can only
--               add new types (which also need a prompt in html/js/apps/thirdparty.js) or remove
--               one with `false`.
--   rateLimit = separate bucket PER external APP, on top of the player's normal limit (costs = tokens per RPC)
--   maxGrants = stored permissions per character
-- ⚠️ Honest limit: the server cannot tell an iframe from a modified client. This stops third-party
--    pages from acting without the player's consent; a tampered client can still only touch its OWN
--    account (every RPC validates the owner, as always).
Config.ExternalApps = {
    rpc       = { 'contacts.list', 'photos.list', 'messages.send', 'bank.info', 'player.get', 'services.list' },
    sensitive = { ['messages.send'] = 'sms', ['contacts.list'] = 'contacts', ['photos.list'] = 'photos', ['bank.info'] = 'bank' },
    rateLimit = { perSecond = 1, burst = 10, costs = { ['messages.send'] = 3 } },
    maxGrants = 200,
    -- SDK 1.5.0 (docs/SDK.md): storage of each external app, per character (ApexPhone.storage / GetAppStorage).
    -- maxBytes is per value (up to 60000).
    kv        = { maxKeys = 200, maxBytes = 16000 },
}

-- ------------------------------------------------------------
-- Messages (Phase 2): pagination, edit/delete-for-everyone windows, groups, 'typing...' and reactions
-- ------------------------------------------------------------
Config.Messages = {
    pageSize        = 30,    -- messages per page when opening/scrolling up in a chat (maximum 50)
    editWindowMin   = 15,    -- minutes during which the sender can edit a text message
    deleteForAllMin = 60,    -- minutes during which the sender can delete for everyone
    maxGroupMembers = 32,    -- members per group, including the creator (2..256)
    maxGroupsPerMember = 100, -- active groups per person (prevents being spam-added to hundreds of groups)
    typingMs        = 3000,  -- minimum interval between 'typing...' signals
    reactions       = { '❤️', '👍', '😂', '😮', '😢', '🙏' },
}

-- Media for messages and mail (images and voice messages), uploaded in chunks and stored in apex_phone_media.
-- Voice messages depend on FiveM's CEF granting microphone access to the NUI (getUserMedia); without it the button shows a warning.
Config.Media = { maxImageBytes = 260000, maxAudioSec = 60, maxAudioBytes = 700000, chunkBytes = 48000, keepDays = 60 }

-- Mail (Phase 2): attachments and drafts
Config.Mail = { maxAttachments = 4, draftsMax = 50 }

-- ------------------------------------------------------------
-- Real GTA map: online tiles (same service and projection as apex_carplay).
-- tileUrl accepts {z} {x} {y}; levels 3..5 are the ones the tile server provides.
-- ------------------------------------------------------------
Config.Map = { tileUrl = 'https://www.gtamap.xyz/mapStyles/styleSatelite/{z}/{x}/{y}.jpg', minZoom = 3, maxZoom = 5, tile = 256, showPOI = false } -- showPOI: show the points of interest (Config.POI) as pins on the map
Config.POI = {
    { name = 'Legion Square',        x = 195.2,   y = -934.0,  icon = 'pin',       color = '#0A84FF' },
    { name = 'Hospital Pillbox',     x = 298.6,   y = -584.4,  icon = 'heart',     color = '#FF453A' },  -- EN: Pillbox Hospital
    { name = 'LSPD Mission Row',     x = 428.4,   y = -981.7,  icon = 'lock',      color = '#5E5CE6' },
    { name = 'Fleeca Bank (Legion)', x = 149.9,   y = -1040.4, icon = 'bank',      color = '#30D158' },
    { name = 'Los Santos Customs',   x = -337.4,  y = -136.9,  icon = 'car',       color = '#FF9F0A' },
    { name = "Benny's Garage",       x = -205.6,  y = -1310.3, icon = 'gear',      color = '#FF9F0A' },
    { name = 'Diamond Casino',       x = 925.3,   y = 46.5,    icon = 'sparkles',  color = '#BF5AF2' },
    { name = 'Del Perro Pier',       x = -1850.1, y = -1231.8, icon = 'nav',       color = '#00C7BE' },
    { name = 'Vespucci Beach',       x = -1238.7, y = -1491.1, icon = 'sun',       color = '#FFD60A' },
    { name = 'Mirror Park',          x = 1046.0,  y = -740.5,  icon = 'pin',       color = '#30D158' },
    { name = 'Câmara Municipal',     x = -544.6,  y = -204.5,  icon = 'home',      color = '#0A84FF' },  -- EN: City Hall
    { name = 'Aeroporto LSIA',       x = -1037.7, y = -2737.8, icon = 'airplane',  color = '#64D2FF' },  -- EN: LSIA Airport
    { name = 'Elysian Docks',        x = 129.5,   y = -3072.5, icon = 'briefcase', color = '#8E8E93' },
    { name = 'Sandy Shores',         x = 1961.2,  y = 3740.5,  icon = 'sun',       color = '#FFD60A' },
    { name = 'Paleto Bay',           x = -275.5,  y = 6228.4,  icon = 'pin',       color = '#BF5AF2' },
}

-- ------------------------------------------------------------
-- Services (Services app): job = framework job (QB/QBox/ESX) that receives the request
-- label: the default labels are phone texts, so every phone shows them in its own language ('Polícia' -> Police,
--   Polizei, ...); a label of your own ('LSPD') shows as written. The dispatch / MDT alert (Config.Integrations.dispatch)
--   gets the label in Config.DefaultLanguage. Optional dispatchLabel = '10-99 Police' sets the dispatch text yourself.
-- ------------------------------------------------------------
Config.Services = {
    { id = 'police',      label = 'Midnight Police',                 job = 'police',     icon = 'lock',  color = '#1e1bd8' },  -- EN: Police
    { id = 'ems',         label = 'Midnight Health Service',         job = 'ambulance',  icon = 'heart', color = '#005eb8' },
    { id = 'fire',        label = 'Midnight Fire & Rescue',          job = 'fire',       icon = 'fire',  color = '#b80000' },
    { id = 'mechanic',    label = 'Redline Mechanics',               job = 'mechanic',   icon = 'gear',  color = '#eb2525' },  -- EN: Mechanic
    { id = 'taxi',        label = 'Taxi',                            job = 'taxi',       icon = 'car',   color = '#000000' },  -- EN: Taxi
    { id = 'realestate',  label = 'Midnight Estates',                job = 'realestate', icon = 'home',  color = '#30D158' },  -- EN: Real Estate
    { id = 'burgershot',  label = 'Burger Shot',                     job = 'burgershot', icon = 'bag',   color = '#FF375F', business = true },
}
-- Seconds between two requests from the same player (per citizenid; only players with the service's job can accept).
Config.ServiceCooldown = 60

-- ------------------------------------------------------------
-- Bills (Billing app): limits for bills created FROM THE PHONE
-- (bills created through server exports are not subject to these limits).
-- ------------------------------------------------------------
Config.Billing = {
    maxAmount   = 1000000,  -- maximum amount of a bill
    societyJobs = nil,      -- nil = any job (except unemployed) with grade >= minGrade bills on behalf
                            -- of the society; or only these jobs, with their minimum grade: { mechanic = 0, police = 2 }
    minGrade    = 0,        -- minimum grade when societyJobs is nil
    cooldown    = 5,        -- seconds between two bills from the same issuer (each one sends a push and a mail)
}

-- Marketplace: maximum listing price (integer; the DB column holds up to 2 147 483 647)
-- transferItems ("item" listings): true = the server takes CUSTODY of the item (table apex_phone_item_escrow,
--   server/marketplace.lua): it leaves the seller's inventory on publishing, goes to the buyer on payment and returns to the owner
--   if the listing is cancelled/deleted. Nobody can sell the same item twice or an item they no longer have.
--   Full inventory or owner/buyer offline: it stays pending and is delivered when possible (periodic check).
--   false = disables NEW escrows (the inventory is only read and delivery is arranged in RP); anything already in
--   escrow is still delivered/returned, so no item gets stuck.
--   Metadata (durability, serial number, ammo): with ox_inventory it is removed slot by slot and passes intact
--   to the buyer (and on return). ⚠️ With qb/esx the inventory cannot pick the unit: the buyer receives a "clean" one.
--   ⚠️ Each delivery is recorded BEFORE touching the inventory: a server crash exactly midway can lose that
--      unit (never duplicate it).
Config.Marketplace = { maxPrice = 100000000, transferItems = true }

-- Known garages (for "Locate" in the Home > Garage app)
Config.Garages = {
    pillboxgarage = { x = 215.8,  y = -810.1 },
    motelgarage   = { x = 273.3,  y = -343.6 },
    spanishave    = { x = -1160.9, y = -740.4 },
    caears24      = { x = 69.8,   y = 12.6 },
}

-- Garage app: DELIVERY ("Request Delivery" on a vehicle that is IN a garage). The phone takes it out of the garage
-- system in use (Config.Integrations.garage), charges the fee and brings it to the player with the keys (every vehicle
-- key resource that is started), its mods, fuel and a GPS waypoint.
-- Impounded vehicles, vehicles already out, boats and aircraft are never delivered. Needs OneSync (the vehicle is
-- created by the server); without it the button is hidden and the console says why. `phonedelivery` (console)
-- prints the state, the key resources fed and the last delivery.
--   enabled      false = no delivery button
--   mode         'valet' (1.2.0, default) = a valet NPC drives the vehicle from a road `valet.minDistance`..`valet.maxDistance`
--                metres away up to the player, gets out and walks away; if the valet cannot reach the player in
--                `valet.timeout` seconds (blocked road, player moved away, no path) the vehicle is moved to the nearest
--                free road next to the player, like 'road'. 'road' = the vehicle appears parked on the nearest free
--                road `minDistance`..`maxDistance` metres away (the 1.1.9 behaviour).
--   price        fee per delivery (0 = free)          account  'bank' | 'cash'
--   cooldown     seconds between two deliveries of the same character
--   minDistance  /  maxDistance   metres from the player where the vehicle is left (on a road) in 'road' mode and when
--                the valet gives up
--   keys         'auto' = every key resource that is started · 'none' · or one resource name, e.g. 'qbx_vehiclekeys'
--   valet        ped = the valet's model · minDistance / maxDistance = where he starts driving from (metres) ·
--                timeout = seconds before the fallback · speed = cruise speed (m/s; 17 = 61 km/h) ·
--                drivingStyle = GTA driving flags (786603 = normal, stops at lights, avoids cars; 1074528293 = rushed)
Config.GarageDelivery = {
    enabled     = false,
    mode        = 'valet',
    price       = 250,
    account     = 'bank',
    cooldown    = 60,
    minDistance = 15,
    maxDistance = 90,
    keys        = 'auto',
    valet       = { ped = 's_m_y_valet_01', minDistance = 120, maxDistance = 260, timeout = 150, speed = 17.0, drivingStyle = 786603 },
}

-- ------------------------------------------------------------
-- Sounds heard by OTHER players (1.2.0): the ringtone, the notification and message chimes and the alarm of a phone are
-- heard by the players around it, fading with distance, so a ringing phone can be noticed in RP (before 1.2.0 every
-- phone sound played only for its owner). The sound is the same synthesized tone the owner hears; a phone on silent
-- or with the volume at 0 makes no sound for anybody.
--   enabled        false = phones are only heard by their owner
--   range          metres at which a phone can still be heard (the volume fades to 0 at this distance)
--   volume         0..1 loudness for the others at zero distance (1 = as loud as the owner hears it)
--   ring / notify  which sounds carry: the ringtone (incoming calls, up to Config.CallTimeout) · chimes (messages,
--                  notifications, alarms, timers)
--   speaker        true = the "Speaker" button of a call is a real speakerphone: players within `speakerRange` metres of
--                  the phone hear the other side of the call and are heard by it (pma-voice and mumble-voip; they are
--                  put on the call channel while they stay close and taken out when they walk away, when the speaker is
--                  turned off or when the call ends; players already in a call of their own are never pulled in).
--                  SaltyChat: Config.Radio.saltychat.speaker and the SaltyChat phone speaker handle this.
--   speakerRange   metres around the phone for the speakerphone
Config.WorldSounds = { enabled = true, range = 12.0, volume = 0.7, ring = true, notify = true, speaker = true, speakerRange = 3.5 }

-- ------------------------------------------------------------
-- Inventory item images on QBCore / QBox WITHOUT ox_inventory (1.2.0). qb-inventory (and ps-, lj-, qs-inventory and
-- the like) show an item's icon from THEIR OWN html/images/<image> file: a `nui://apex_phone/...` address in the item's
-- `image` field or a PNG that is not in that folder gives a blank slot. On start (and with the `phoneitems` console
-- command) the phone checks every device item in qb-core/shared/items.lua and, when a PNG is missing from the
-- inventory's images folder, copies it there from apex_phone/inventory_images/ (restart the inventory once afterwards).
-- The console says exactly what is missing or wrong (item not created, `image` not a plain file name, useable = false).
--   autoCopy   false = only report, never write into the inventory resource
--   resource   '' = detect (qb-inventory, ps-inventory, lj-inventory, qs-inventory, origen_inventory, codem-inventory,
--              tgiann-inventory, core_inventory); or the resource name
--   folder     the images folder inside that resource
Config.InventoryImages = { autoCopy = true, resource = '', folder = 'html/images' }

-- ------------------------------------------------------------
-- Match (dating app)
-- ------------------------------------------------------------
-- Cap for the 3 profile photos, in characters. On the phone a Match "photo" is always a
-- short REFERENCE (the seed number of a gallery photo or an http address), never base64:
-- photos.list does not return the base64 (server/photos.lua) and the app sends `url || seed`.
--   photoMax  = cap for EACH of the 3 photos (default 512, same as Mail attachments)
--   photosMax = cap for the SUM of all three (default 2048)
-- This is not just database size: the match.cards RPC sends up to 30 profiles in a SINGLE network
-- event, so ONE large photo in one profile would stop the Match app from loading FOR EVERYONE ELSE
-- (FiveM drops large events). Above the cap the profile is not saved ({ error = 'toolarge' }),
-- and old profiles already over the cap show without a photo instead of breaking everyone's deck.
-- ⚠️ There is no "no cap": below 16 the server uses 16. This limit is what stops one profile from
--    breaking the Match app for every other player.
Config.Match = { photoMax = 512, photosMax = 2048 }

-- ------------------------------------------------------------
-- Social / Dark Chat
-- ------------------------------------------------------------
-- storyHours: how many hours an Instashot story lasts before it disappears on its own.
-- The server clears expired ones every 10 minutes (server/social.lua).
-- instashot / twix / reels / darkchat: setting false REALLY CLOSES the network on the server: that network's RPCs
-- start answering { error = 'off' } and no new accounts can be created on it. Nothing is deleted: setting it back to
-- true restores everything as it was. ⚠️ The app icon still shows on the phone (hiding it is done on the
-- NUI side); only the network stops responding, and the phone will say "Name in use" when trying to
-- create an account on a closed network (the correct message is on the NUI side).
-- ⚠️ What closes is everything that can be DISCOVERED: feed, profiles, lists, search, stories, new accounts. The
--    RPCs that resolve the network from the ROW rather than the request (a post's photo chunks
--    and Instants requested by id) still answer anyone who ALREADY has the id: there is no way
--    to discover it with the network closed, but it is stated here rather than promising a full shutdown.
Config.Social = { instashot = true, twix = true, reels = true, darkchat = true, storyHours = 24 }

-- ------------------------------------------------------------
-- INSTANTS (Instashot): the photo of the MOMENT, viewed only once
-- In Instashot messages there is a stack of photos in the bottom-right corner: it opens the
-- camera, the photo is taken right there (not picked from the gallery), it can carry text (no filters
-- and no editing) and it is sent to close friends OR to people who follow you and you follow back.
-- Each person sees it ONCE: then it disappears for them. And after `hours` it disappears for everyone.
-- ------------------------------------------------------------
Config.Instants = {
    enabled    = true,
    hours      = 24,    -- lifetime (the server clears expired ones every 10 minutes)
    maxPerUser = 10,    -- simultaneous active Instants per person
    maxText    = 120,   -- text limit over the photo
    notify     = true,  -- notify those who can see it (phone notification)
}

-- ------------------------------------------------------------
-- Instashot STORIES: full editor (text, stickers, music, drawing)
-- Each story is saved as a list of LAYERS, so it is rebuilt exactly as it was
-- on any phone. See html/js/apps/stories.js.
-- ------------------------------------------------------------
Config.Stories = {
    duration    = 5,        -- seconds per story (image); the progress bar uses this
    maxLayers   = 24,       -- safety cap: a story cannot have more elements than this
    maxPerUser  = 20,       -- active stories at the same time per person
    closeFriends = true,    -- show the "Amigos proximos" (Close friends) button when posting

    -- Backgrounds for text-only stories (no photo).
    -- type 'grad' = gradient (two tones), 'solid' = single colour.
    backgrounds = {
        { id = 'ig',      type = 'grad', a = '#833AB4', b = '#FD1D1D' },
        { id = 'sunset',  type = 'grad', a = '#FF9F0A', b = '#FF375F' },
        { id = 'ocean',   type = 'grad', a = '#0A84FF', b = '#00C7BE' },
        { id = 'forest',  type = 'grad', a = '#30D158', b = '#0B6E4F' },
        { id = 'grape',   type = 'grad', a = '#BF5AF2', b = '#5E5CE6' },
        { id = 'ember',   type = 'grad', a = '#FF453A', b = '#8A1A12' },
        { id = 'night',   type = 'grad', a = '#2C2C2E', b = '#0A0A0B' },
        { id = 'black',   type = 'solid', a = '#000000' },
        { id = 'white',   type = 'solid', a = '#FFFFFF' },
        { id = 'gray',    type = 'solid', a = '#8E8E93' },
        { id = 'blue',    type = 'solid', a = '#0A84FF' },
        { id = 'pink',    type = 'solid', a = '#FF375F' },
    },

    -- Server places for the location sticker. If you leave the list empty,
    -- the phone uses the map's Config.POI.
    locations = {
        'Legion Square', 'Hospital Pillbox', 'Mission Row', 'Vespucci Beach',  -- EN: Pillbox Hospital
        'Del Perro Pier', 'Diamond Casino', 'Los Santos Customs', "Benny's Garage",
        'Mirror Park', 'Vinewood Hills', 'Aeroporto LSIA', 'Sandy Shores',  -- EN: LSIA Airport
        'Paleto Bay', 'Grove Street', 'Vanilla Unicorn', 'Port of Elysian',  -- EN: Port of Elysian
    },

    -- Sticker music: the SUGGESTIONS shown before searching.
    --
    -- ⚠️ Each entry needs its `vid` (the YouTube video id, the part after
    --    "watch?v="): the phone's own player uses it to play the preview in the
    --    editor and the snippet for whoever views the story. An entry WITHOUT `vid` is ignored.
    --    If you leave this list empty (or only with entries without `vid`), the suggestions become
    --    the Music app catalogue (Config.Music.Library), which is guaranteed to play.
    --
    -- Search inside the editor uses the Music app search (with Config.Music.Search = true: any song on YouTube or a
    -- pasted link; with false: only Config.Music.Library).
    -- Example:
    --   { vid = 'dQw4w9WgXcQ', title = 'Never Gonna Give You Up', artist = 'Rick Astley', dur = 213 },
    music = {},
}
Config.DarkChatTTL = 0          -- minutes until messages are deleted (0 = permanent)

-- ------------------------------------------------------------
-- Onion (anonymous market) and Crypto
-- Roleplay apps: anonymous listings paid in crypto, with an escrow deposit.
-- With transferItems = false they do not touch the inventory: delivery is done between players, like in Marketplace.
-- ------------------------------------------------------------
-- maxPrice = maximum price of a listing (in crypto, decimals allowed); maxStock = units per listing
-- transferItems ("item" listings): true = server CUSTODY (the same as Marketplace): the stock units
--   leave the seller's inventory when posting, each purchase reserves one and shipping delivers it to the buyer; any
--   left over go back to the seller when the listing is removed. false = disables NEW custody (the inventory is only
--   read and delivery is done between players, as before); anything already in custody is still delivered/returned.
Config.Onion = { enabled = false, crypto = false, maxPrice = 1000, maxStock = 1000, transferItems = false }

-- ------------------------------------------------------------
-- Crypto (the Onion currency): Config.Crypto. These options EXIST, but the values in effect are the ones
-- in server/onion.lua itself (function cryptoCfg): this line is left out ON PURPOSE, because writing
-- fixed numbers here makes them override and freezes them: if a new version of onion.lua changes the band or the
-- fees, your config would keep enforcing the old ones, silently. Before uncommenting, check the values
-- cryptoCfg uses and copy them; and read the warning onion.lua prints on startup when the band is too wide
-- for the fees (in that case buying at the floor price profits on average, which prints money).
--   min / max    price band in EUR (the floor and the ceiling)
--   step         noise amplitude of each step: (random - 0.5) * step, ZERO mean
--   revert       share of the distance to the band centre recovered each step (mean reversion;
--                0 = free random walk, which drifts to the limits and stays there)
--   tick         seconds between price steps (minimum 5)
--   feeBuyPct    house fee when buying, in % (you buy above the price)
--   feeSellPct   house fee when selling, in % (you sell below the price). 0 on both = neutral round trip
--   enforceBand  by default (true) a band too wide for the fee is NARROWED automatically to what the
--                fee can handle (same centre), with a console warning. false keeps the band you wrote
--                here, and onion.lua itself tells you that you now have a money printer
--   persist      save price and series in apex_phone_crypto_state. false = randomised on every startup, and anyone
--                holding crypto gains or loses thousands on every restart without touching the phone
-- Config.Crypto = { min = ..., max = ..., step = ..., revert = ..., tick = 30, feeBuyPct = 1.5, feeSellPct = 1.5, enforceBand = true, persist = true }
-- ------------------------------------------------------------

-- ------------------------------------------------------------
-- Music: by default the phone does it all by itself ('internal'): the Library
-- below as featured shelves plus open YouTube search (Search). With
-- Provider = 'apex_carradio' it uses the CarLink TubeMusic catalogue instead
-- (the same per-character library: likes and playlists shared with CarLink).
-- ------------------------------------------------------------
Config.Music = {
    -- 'internal' = the phone handles EVERYTHING on its own (catalogue, search, library).
    -- 'apex_carradio' = uses the Apex Car Radio TubeMusic catalogue, if you have it
    --                   ('apex_carplay', its name before 2.1.2, means the same thing).
    -- With 'internal' the phone does NOT depend on any other resource.
    Provider = 'internal',
    CarPlay  = true,            -- "Reproduzir no carro" (Play in car) button when you are in a vehicle
    -- The head unit's resource (folder) name. 'auto' = apex_carradio or apex_carplay,
    -- whichever is running. Only set a name here if you renamed the folder yourself.
    CarResource = 'auto',
    Volume   = 60,              -- initial app volume (the phone's volume button also controls it)

    -- ------------------------------------------------------------
    -- OPEN SEARCH (Provider = 'internal')
    -- true  = players search and play ANY song themselves, straight from YouTube, and can
    --         paste a YouTube link (watch?v=, youtu.be/, music.youtube.com, shorts) in the
    --         search box to play it. Likes, "your songs", playlists and history keep the
    --         searched tracks. The Library below stays as the featured shelves on Home.
    --         The search runs on the SERVER (no API key, nothing to install), with a shared
    --         cache and a per-player limit. Videos whose owner blocks playback outside
    --         YouTube are skipped (the phone tries another upload of the same song first).
    --         Server console: "phonemusic" shows the status, "phonemusic <text>" runs a test search.
    -- false = the old behaviour: players only find and play the Library below.
    -- SearchRegion = two-letter country YouTube uses for what is available ('US', 'PT', 'BR'...).
    -- ------------------------------------------------------------
    Search       = true,
    SearchRegion = 'GB',

    -- ------------------------------------------------------------
    -- SERVER CATALOGUE (Provider = 'internal')
    -- Playback uses the YouTube player that already lives inside the phone,
    -- so each track needs its `vid` (the YouTube video id: the part after
    -- "watch?v=" ). `len` is the duration in seconds, display only.
    -- Add, remove or replace whatever you want: it is just this list.
    -- `shelf` groups the tracks into the shelves on the app's Home screen.
    -- ------------------------------------------------------------
    Library = {
        { vid = 'dQw4w9WgXcQ', t = 'Never Gonna Give You Up', a = 'Rick Astley',  alb = 'Whenever You Need Somebody', len = 213, shelf = 'Clássicos' },  -- EN: Classics
        { vid = 'kJQP7kiw5Fk', t = 'Despacito',               a = 'Luis Fonsi',   alb = 'Vida',                       len = 282, shelf = 'Em alta' },  -- EN: Trending
        { vid = '9bZkp7q19f0', t = 'Gangnam Style',           a = 'PSY',          alb = 'Psy 6 (Six Rules), Part 1',  len = 253, shelf = 'Clássicos' },  -- EN: Classics
        { vid = 'JGwWNGJdvx8', t = 'Shape of You',            a = 'Ed Sheeran',   alb = '÷ (Deluxe)',                 len = 234, shelf = 'Em alta' },  -- EN: Trending
        { vid = 'RgKAFK5djSk', t = 'See You Again',           a = 'Wiz Khalifa',  alb = 'Furious 7',                  len = 230, shelf = 'Para conduzir' },  -- EN: For the Drive
        { vid = 'OPf0YbXqDm0', t = 'Uptown Funk',             a = 'Mark Ronson',  alb = 'Uptown Special',             len = 270, shelf = 'Para conduzir' },  -- EN: For the Drive
    },
}

-- ------------------------------------------------------------
-- EATS: food delivery ("Eats" app, in the style of Glovo / Uber Eats)
--
-- How it works:
--   1. The player picks a restaurant, fills the cart and places the order.
--   2. The order is charged (bank account or cash) and goes to the kitchen.
--   3. Every player in COURIER MODE within Eats.courierRadius receives the offer.
--      The first to accept gets it. If nobody accepts within `npcAfter` seconds,
--      an NPC courier steps in and the order still arrives (the server never gets stuck).
--   4. States: pending > accepted > preparing > picked > delivering > delivered.
--      The customer sees the map with the courier moving and the estimated time.
--   5. The courier receives `courierCutPct` % of the delivery fee + 100 % of the tip.
--
-- Restaurants with a `job` set belong to players: whoever is on duty
-- in that job receives the orders in the app and the food money goes to the society.
-- Without `job`, the restaurant is "NPC" and the money leaves the economy (like a shop).
-- ------------------------------------------------------------
Config.Eats = {
    enabled       = true,
    serviceFee    = 0.99,           -- fixed service fee per order
    smallOrder    = { under = 12.0, fee = 1.99 },   -- small order fee
    proPrice      = 24.99,          -- Eats Pro: free deliveries for proDays days
    proDays       = 30,
    tipPresets    = { 0, 1, 2, 5 }, -- suggested tips (€)
    payMethods    = { 'card', 'cash' },   -- card = bank account; cash = cash
    courierJob    = '',             -- '' = any player can be a courier; or 'delivery'
    courierCutPct = 70,             -- % of the delivery fee kept by the courier
    courierRadius = 1200.0,         -- metres: who receives the offer
    offerSeconds  = 30,             -- seconds to accept the offer
    npcAfter      = 75,             -- no courier after this, an NPC steps in
    prepSeconds   = { 90, 210 },    -- preparation time (min, max)
    npcSpeed      = 13.0,           -- NPC courier speed in m/s (~47 km/h)
    maxActive     = 3,              -- active orders per player
    giveItems     = true,           -- give the real inventory item when the dish has an `item`
    itemsResource = 'ox_inventory', -- (no longer used: items go through the detected inventory, ox_inventory, qb or esx)
    -- The order is charged up front, so delivery has to be checked (see server/eats.lua):
    itemRefund    = true,           -- item the inventory does not know (or that never fits): refund the money
                                    -- for THAT dish, with the promo discount already applied. false = only warns the player
    itemRetries   = 60,             -- food that does not fit in the inventory: attempts (one per minute while the player is
                                    -- online, plus one on each join) before giving up and refunding the money
    itemWarn      = true,           -- on startup, list in the console the menu items the inventory does not know
    ratingWindow  = 7,              -- days during which an order can still be rated

    -- Top bar categories (in the order they appear in the app)
    categories = {
        { id = 'all',      label = 'Tudo',          glyph = 'bag' },  -- EN: All
        { id = 'burger',   label = 'Hambúrgueres',  glyph = 'burger' },  -- EN: Burgers
        { id = 'pizza',    label = 'Pizza',         glyph = 'pizza' },
        { id = 'sushi',    label = 'Sushi',         glyph = 'sushi' },
        { id = 'chicken',  label = 'Frango',        glyph = 'chicken' },  -- EN: Chicken
        { id = 'mexican',  label = 'Mexicano',      glyph = 'taco' },  -- EN: Mexican
        { id = 'asian',    label = 'Asiático',      glyph = 'noodles' },  -- EN: Asian
        { id = 'italian',  label = 'Italian',      glyph = 'pasta' },
        { id = 'coffee',   label = 'Café',          glyph = 'coffee' },  -- EN: Coffee
        { id = 'dessert',  label = 'Sobremesas',    glyph = 'donut' },  -- EN: Desserts
        { id = 'healthy',  label = 'Saudável',      glyph = 'salad' },  -- EN: Healthy
        { id = 'grocery',  label = 'Mercearia',     glyph = 'grocery' },  -- EN: Grocery
        { id = 'pharmacy', label = 'Farmácia',      glyph = 'pills' },  -- EN: Pharmacy
    },

    -- Promo codes (percent = % discount on the subtotal; off = fixed amount in €;
    -- freeDelivery = free delivery). `uses` = how many times EACH player can use it.
    promos = {
        { code = 'BEMVINDO',  percent = 20, max = 8.0,  uses = 1, label = '-20% no primeiro pedido' },  -- EN: 20% off your first order
        { code = 'EATS5',     off = 5.0,    min = 20.0, uses = 3, label = '-5 € acima de 20 €' },  -- EN: €5 off orders over €20
        { code = 'SEMTAXA',   freeDelivery = true,      uses = 5, label = 'Entrega grátis' },  -- EN: Free Delivery
        { code = 'LATENIGHT', percent = 15, max = 6.0,  uses = 2, label = '-15% de madrugada' },  -- EN: 15% off late at night
    },

    -- ------------------------------------------------------------
    -- RESTAURANTS
    -- coords = where the courier picks up the food (approximate, adjust to your map).
    -- art = { top colour, bottom colour } of the card; glyph = SVG drawing (html/js/apps/eats.js).
    -- job/society = player-run restaurant (they receive the orders and the money goes to the society).
    -- open = { opening hour, closing hour } in GAME time (0..24; { 0, 24 } = always open).
    -- item = ox_inventory item name given at the end (optional, requires giveItems).
    -- ------------------------------------------------------------
    restaurants = {
        {
            id = 'burgershot', name = 'Burger Shot', tagline = 'Hambúrgueres · Fast food',  -- EN: Burgers · Fast food
            cats = { 'burger' }, rating = 4.5, votes = 1284, time = { 20, 35 }, fee = 2.49, min = 8.0,
            coords = { x = -1183.9, y = -885.9 }, job = 'burgershot', society = 'burgershot',
            art = { '#FF375F', '#B3122F' }, glyph = 'burger', open = { 0, 24 },
            promo = '2.º hambúrguer a -20%',  -- EN: 20% off your 2nd burger
            menu = {
                { name = 'Populares', items = {  -- EN: Popular
                    { id = 'bs_bleeder', name = 'Bleeder', desc = 'Carne grelhada, queijo cheddar, alface, tomate e molho da casa.', price = 9.90, kcal = 760, item = 'cheeseburger', art = { '#C9762F', '#7A3E12' }, glyph = 'burger', tag = 'popular',  -- EN: Grilled beef, cheddar cheese, lettuce, tomato and house sauce.
                        options = {
                            { id = 'size', name = 'Tamanho', min = 1, max = 1, choices = { { id = 'reg', name = 'Normal', price = 0 }, { id = 'menu', name = 'Menu (batatas + bebida)', price = 3.90 }, { id = 'double', name = 'Duplo', price = 2.60 } } },  -- EN: Size | Meal (fries + drink) | Double
                            { id = 'extra', name = 'Extras', min = 0, max = 6, choices = { { id = 'bacon', name = 'Bacon', price = 1.20 }, { id = 'cheese', name = 'Queijo extra', price = 0.80 }, { id = 'egg', name = 'Ovo estrelado', price = 1.00 }, { id = 'jala', name = 'Jalapeños', price = 0.60 }, { id = 'onionr', name = 'Onion rings dentro', price = 1.40 } } },  -- EN: Extra Cheese | Fried Egg | Onion Rings Inside
                            { id = 'rem', name = 'Retirar', min = 0, max = 5, choices = { { id = 'no_onion', name = 'Sem cebola', price = 0 }, { id = 'no_pickle', name = 'Sem pickles', price = 0 }, { id = 'no_sauce', name = 'Sem molho', price = 0 }, { id = 'no_tom', name = 'Sem tomate', price = 0 } } },  -- EN: Remove | No Onion | No Pickles | No Sauce | No Tomato
                        } },
                    { id = 'bs_double', name = 'Torpedo Duplo', desc = 'Duas carnes, queijo duplo, bacon e molho picante.', price = 13.50, kcal = 1120, item = 'double_burger', art = { '#B03A1E', '#5E1A0A' }, glyph = 'burger', tag = 'popular',  -- EN: Double Torpedo | Two patties, double cheese, bacon and spicy sauce.
                        options = { { id = 'size', name = 'Tamanho', min = 1, max = 1, choices = { { id = 'reg', name = 'Normal', price = 0 }, { id = 'menu', name = 'Menu (batatas + bebida)', price = 3.90 } } } } },  -- EN: Size | Meal (fries + drink)
                    { id = 'bs_chicken', name = 'Chicken Crisp', desc = 'Frango panado estaladiço, maionese e alface.', price = 10.50, kcal = 640, item = 'chicken_burger', art = { '#D9A441', '#8A5E13' }, glyph = 'chicken' },  -- EN: Crispy breaded chicken, mayo and lettuce.
                    { id = 'bs_veggie', name = 'Meat Free Burger', desc = 'Hambúrguer de soja, tomate e molho vegan.', price = 9.50, kcal = 420, item = 'veggie_burger', art = { '#5FA55A', '#2E6B2B' }, glyph = 'salad' },  -- EN: Soy patty, tomato and vegan sauce.
                    { id = 'bs_fish', name = 'Fish Burger', desc = 'Filete de peixe panado com molho tártaro.', price = 10.00, kcal = 520, item = 'fish_burger', art = { '#5C9EC7', '#255E85' }, glyph = 'fish' },  -- EN: Breaded fish fillet with tartare sauce.
                } },
                { name = 'Acompanhamentos', items = {  -- EN: Sides
                    { id = 'bs_fries', name = 'Batatas fritas', desc = 'Corte grosso, com sal.', price = 3.50, kcal = 380, item = 'fries', art = { '#E9B949', '#B07D14' }, glyph = 'fries',  -- EN: Fries | Thick-cut and salted.
                        options = { { id = 'size', name = 'Tamanho', min = 1, max = 1, choices = { { id = 's', name = 'Pequenas', price = 0 }, { id = 'm', name = 'Médias', price = 1.20 }, { id = 'l', name = 'Grandes', price = 2.20 } } },  -- EN: Size | Small | Medium | Large
                                    { id = 'sauce', name = 'Molho', min = 0, max = 3, choices = { { id = 'ketchup', name = 'Ketchup', price = 0.30 }, { id = 'mayo', name = 'Maionese', price = 0.30 }, { id = 'bbq', name = 'BBQ', price = 0.40 }, { id = 'cheddar', name = 'Cheddar quente', price = 0.90 } } } } },  -- EN: Sauce | Mayo | Melted Cheddar
                    { id = 'bs_rings', name = 'Onion rings', desc = 'Aros de cebola panados.', price = 3.90, kcal = 340, item = 'onion_rings', art = { '#D8A05E', '#8C5A18' }, glyph = 'rings' },  -- EN: Breaded onion rings.
                    { id = 'bs_nuggets', name = 'Nuggets (9)', desc = 'Nove nuggets de frango com molho à escolha.', price = 6.50, kcal = 480, item = 'chicken_nuggets', art = { '#DDB05A', '#9A6A1E' }, glyph = 'nuggets' },  -- EN: Nine chicken nuggets with your choice of sauce.
                } },
                { name = 'Bebidas', items = {  -- EN: Drinks
                    { id = 'bs_cola', name = 'Cola', desc = 'Lata 33 cl bem fresca.', price = 2.20, kcal = 140, item = 'cola', art = { '#8B2027', '#3A0A0E' }, glyph = 'drink' },  -- EN: Ice-cold 33 cl can.
                    { id = 'bs_shake', name = 'Milkshake', desc = 'Baunilha, morango ou chocolate.', price = 4.50, kcal = 350, item = 'milkshake', art = { '#E5A8B8', '#A6566E' }, glyph = 'shake',  -- EN: Vanilla, strawberry or chocolate.
                        options = { { id = 'flav', name = 'Sabor', min = 1, max = 1, choices = { { id = 'van', name = 'Baunilha', price = 0 }, { id = 'str', name = 'Morango', price = 0 }, { id = 'cho', name = 'Chocolate', price = 0 } } } } },  -- EN: Flavour | Vanilla | Strawberry
                    { id = 'bs_water', name = 'Água', desc = 'Garrafa 50 cl.', price = 1.50, kcal = 0, item = 'water', art = { '#7FC4E8', '#2F7CA8' }, glyph = 'drink' },  -- EN: Water | 50 cl bottle.
                } },
            },
        },
        {
            id = 'cluckin', name = "Cluckin' Bell", tagline = 'Frango · Fast food',  -- EN: Chicken · Fast food
            cats = { 'chicken', 'burger' }, rating = 4.2, votes = 903, time = { 25, 40 }, fee = 1.99, min = 7.0,
            coords = { x = -146.0, y = -256.0 }, art = { '#F0B429', '#B3540E' }, glyph = 'chicken', open = { 0, 24 },
            menu = {
                { name = 'Baldes', items = {  -- EN: Buckets
                    { id = 'cb_bucket', name = 'Balde Cluckin (8 peças)', desc = 'Oito peças de frango crocante com temperos secretos.', price = 18.90, kcal = 1980, art = { '#D2691E', '#7A3708' }, glyph = 'chicken', tag = 'popular',  -- EN: Cluckin Bucket (8 pieces) | Eight pieces of crispy chicken with secret seasoning.
                        options = { { id = 'spice', name = 'Tempero', min = 1, max = 1, choices = { { id = 'og', name = 'Original', price = 0 }, { id = 'hot', name = 'Picante', price = 0 }, { id = 'bbq', name = 'BBQ fumado', price = 0.90 } } },  -- EN: Seasoning | Spicy | Smoky BBQ
                                    { id = 'side', name = 'Acompanhamento', min = 0, max = 2, choices = { { id = 'fries', name = 'Batatas grandes', price = 3.20 }, { id = 'coles', name = 'Coleslaw', price = 2.40 }, { id = 'corn', name = 'Milho grelhado', price = 2.20 } } } } },  -- EN: Side | Large Fries | Grilled Corn
                    { id = 'cb_bucket16', name = 'Balde Família (16 peças)', desc = 'Para quatro pessoas com fome a sério.', price = 32.00, kcal = 3900, art = { '#C2410C', '#5C1A03' }, glyph = 'chicken' },  -- EN: Family Bucket (16 pieces) | For four seriously hungry people.
                } },
                { name = 'Sandes', items = {  -- EN: Sandwiches
                    { id = 'cb_wrap', name = 'Cluck Wrap', desc = 'Tiras de frango, alface e molho ranch numa tortilha.', price = 7.90, kcal = 520, art = { '#D9B382', '#8A6428' }, glyph = 'wrap', tag = 'popular' },  -- EN: Chicken strips, lettuce and ranch dressing in a tortilla.
                    { id = 'cb_sand', name = 'Bell Sandwich', desc = 'Peito de frango panado, pickles e maionese picante.', price = 9.20, kcal = 610, item = 'chicken_burger', art = { '#E0A53F', '#8A5A0E' }, glyph = 'burger' },  -- EN: Breaded chicken breast, pickles and spicy mayo.
                } },
                { name = 'Acompanhamentos e bebidas', items = {  -- EN: Sides & Drinks
                    { id = 'cb_fries', name = 'Batatas onduladas', desc = 'Corte ondulado com sal e pimenta.', price = 3.20, kcal = 360, item = 'fries', art = { '#E9B949', '#A97B12' }, glyph = 'fries' },  -- EN: Crinkle-Cut Fries | Crinkle-cut with salt and pepper.
                    { id = 'cb_juice', name = 'Sumo de laranja', desc = 'Natural, 33 cl.', price = 3.00, kcal = 110, item = 'orange_juice', art = { '#F09819', '#A85806' }, glyph = 'drink' },  -- EN: Orange Juice | Fresh, 33 cl.
                    { id = 'cb_cola', name = 'Cola', desc = 'Lata 33 cl.', price = 2.20, kcal = 140, item = 'cola', art = { '#8B2027', '#3A0A0E' }, glyph = 'drink' },  -- EN: 33 cl can.
                } },
            },
        },
        {
            id = 'upnatom', name = 'Up-n-Atom Burger', tagline = 'Diner americano · Pequenos-almoços',  -- EN: American diner · Breakfast
            cats = { 'burger' }, rating = 4.7, votes = 512, time = { 15, 30 }, fee = 2.99, min = 6.0,
            coords = { x = 81.0, y = 296.0 }, art = { '#31A9B8', '#0E5B6B' }, glyph = 'diner', open = { 6, 23 },
            promo = 'Pequeno-almoço até às 11h',  -- EN: Breakfast until 11am
            menu = {
                { name = 'Pequeno-almoço', items = {  -- EN: Breakfast
                    { id = 'ua_break', name = 'Atom Breakfast', desc = 'Dois ovos, bacon, salsicha, feijão e torrada.', price = 11.50, kcal = 890, art = { '#E4B363', '#9C6A17' }, glyph = 'breakfast', tag = 'popular' },  -- EN: Two eggs, bacon, sausage, beans and toast.
                    { id = 'ua_pancake', name = 'Panquecas com xarope', desc = 'Pilha de três com manteiga e xarope de ácer.', price = 8.40, kcal = 720, art = { '#D9A06B', '#8A5320' }, glyph = 'pancake' },  -- EN: Pancakes with Syrup | A stack of three with butter and maple syrup.
                    { id = 'ua_coffee', name = 'Café americano', desc = 'Chávena grande, sempre a escaldar.', price = 2.40, kcal = 5, item = 'coffe', art = { '#7A5230', '#3A2413' }, glyph = 'coffee' },  -- EN: Americano | Large mug, always piping hot.
                } },
                { name = 'Hambúrgueres', items = {  -- EN: Burgers
                    { id = 'ua_classic', name = 'Atom Classic', desc = 'Carne 180 g, cheddar e cebola caramelizada.', price = 12.90, kcal = 810, item = 'cheeseburger', art = { '#C9762F', '#6E3510' }, glyph = 'burger', tag = 'popular',  -- EN: 180 g beef patty, cheddar and caramelised onion.
                        options = { { id = 'point', name = 'Ponto da carne', min = 1, max = 1, choices = { { id = 'med', name = 'Médio', price = 0 }, { id = 'well', name = 'Bem passado', price = 0 }, { id = 'rare', name = 'Mal passado', price = 0 } } },  -- EN: Doneness | Medium | Well Done | Rare
                                    { id = 'extra', name = 'Extras', min = 0, max = 4, choices = { { id = 'bacon', name = 'Bacon', price = 1.50 }, { id = 'egg', name = 'Ovo', price = 1.00 }, { id = 'blue', name = 'Queijo azul', price = 1.80 } } } } },  -- EN: Egg | Blue Cheese
                    { id = 'ua_veg', name = 'Green Atom', desc = 'Hambúrguer de grão com abacate.', price = 11.20, kcal = 450, item = 'veggie_burger', art = { '#4E9C50', '#245223' }, glyph = 'salad' },  -- EN: Chickpea burger with avocado.
                } },
                { name = 'Batidos', items = {  -- EN: Shakes
                    { id = 'ua_shake', name = 'Batido do dia', desc = 'Feito na hora, com gelado a sério.', price = 5.20, kcal = 420, item = 'milkshake', art = { '#E9A8C0', '#9C4E6B' }, glyph = 'shake' },  -- EN: Shake of the Day | Made to order with real ice cream.
                } },
            },
        },
        {
            id = 'pizzathis', name = 'Pizza This...', tagline = 'Pizza · Italiano',  -- EN: Pizza · Italian
            cats = { 'pizza', 'italian' }, rating = 4.4, votes = 1607, time = { 30, 45 }, fee = 2.20, min = 10.0,
            coords = { x = 806.6, y = -752.3 }, art = { '#E23E3E', '#7A1414' }, glyph = 'pizza', open = { 11, 24 },
            promo = 'Pizza família ao preço de média',  -- EN: Family pizza for the price of a medium
            menu = {
                { name = 'Pizzas clássicas', items = {  -- EN: Classic Pizzas
                    { id = 'pz_marg', name = 'Margherita', desc = 'Tomate San Marzano, mozzarella e manjericão.', price = 9.90, kcal = 980, art = { '#E05C3E', '#8A2417' }, glyph = 'pizza', tag = 'popular',  -- EN: San Marzano tomatoes, mozzarella and basil.
                        options = { { id = 'size', name = 'Tamanho', min = 1, max = 1, choices = { { id = 'm', name = 'Média (30 cm)', price = 0 }, { id = 'l', name = 'Grande (40 cm)', price = 4.50 }, { id = 'xl', name = 'Família (50 cm)', price = 8.00 } } },  -- EN: Size | Medium (30 cm) | Large (40 cm) | Family (50 cm)
                                    { id = 'crust', name = 'Massa', min = 1, max = 1, choices = { { id = 'thin', name = 'Fina', price = 0 }, { id = 'thick', name = 'Alta', price = 0.80 }, { id = 'cheese', name = 'Bordo recheado', price = 2.50 } } },  -- EN: Crust | Thin | Thick | Stuffed Crust
                                    { id = 'extra', name = 'Ingredientes extra', min = 0, max = 8, choices = { { id = 'ham', name = 'Fiambre', price = 1.20 }, { id = 'mush', name = 'Cogumelos', price = 1.00 }, { id = 'pepp', name = 'Pepperoni', price = 1.50 }, { id = 'olive', name = 'Azeitonas', price = 0.80 }, { id = 'pine', name = 'Ananás', price = 1.00 }, { id = 'chili', name = 'Malagueta', price = 0.50 } } } } },  -- EN: Extra Toppings | Ham | Mushrooms | Olives | Pineapple | Chilli
                    { id = 'pz_pepp', name = 'Pepperoni', desc = 'Camada dupla de pepperoni picante.', price = 12.50, kcal = 1240, art = { '#C9302C', '#6B120F' }, glyph = 'pizza', tag = 'popular' },  -- EN: A double layer of spicy pepperoni.
                    { id = 'pz_quattro', name = 'Quattro Formaggi', desc = 'Mozzarella, gorgonzola, parmesão e taleggio.', price = 13.90, kcal = 1310, art = { '#E3C16F', '#96762A' }, glyph = 'pizza' },  -- EN: Mozzarella, gorgonzola, parmesan and taleggio.
                    { id = 'pz_diavola', name = 'Diavola', desc = 'Salame picante, malagueta e mel.', price = 13.20, kcal = 1180, art = { '#B02A2A', '#5A0D0D' }, glyph = 'pizza' },  -- EN: Spicy salami, chilli and honey.
                    { id = 'pz_veg', name = 'Ortolana', desc = 'Legumes grelhados da estação.', price = 11.90, kcal = 860, art = { '#5E9E4E', '#2C5423' }, glyph = 'salad' },  -- EN: Grilled seasonal vegetables.
                } },
                { name = 'Entradas', items = {  -- EN: Starters
                    { id = 'pz_bread', name = 'Pão de alho', desc = 'Fatias com manteiga de alho e orégãos.', price = 4.50, kcal = 420, art = { '#D9A55E', '#8A5B18' }, glyph = 'bread' },  -- EN: Garlic Bread | Slices with garlic butter and oregano.
                    { id = 'pz_wings', name = 'Asinhas búfalo (6)', desc = 'Com molho de queijo azul.', price = 7.90, kcal = 640, art = { '#C25C1E', '#6B2A08' }, glyph = 'wings' },  -- EN: Buffalo Wings (6) | With blue cheese dip.
                } },
                { name = 'Sobremesas e bebidas', items = {  -- EN: Desserts & Drinks
                    { id = 'pz_tira', name = 'Tiramisù', desc = 'Feito na casa, com café a sério.', price = 5.50, kcal = 480, art = { '#8A6746', '#463020' }, glyph = 'cake' },  -- EN: Homemade, with real coffee.
                    { id = 'pz_cola', name = 'Cola 1,5 L', desc = 'Para partilhar.', price = 3.90, kcal = 620, item = 'cola', art = { '#8B2027', '#3A0A0E' }, glyph = 'drink' },  -- EN: Cola 1.5 L | For sharing.
                } },
            },
        },
        {
            id = 'tacobomb', name = 'Taco Bomb', tagline = 'Mexican · Tex-Mex',
            cats = { 'mexican' }, rating = 4.1, votes = 744, time = { 20, 35 }, fee = 1.79, min = 6.0,
            coords = { x = 39.0, y = -1600.0 }, art = { '#E9762B', '#8A3908' }, glyph = 'taco', open = { 10, 4 },
            menu = {
                { name = 'Tacos e burritos', items = {  -- EN: Tacos & Burritos
                    { id = 'tb_taco3', name = 'Tacos (3)', desc = 'Três tacos com carne, coentros e cebola.', price = 8.50, kcal = 620, art = { '#E0A040', '#8A5A10' }, glyph = 'taco', tag = 'popular',  -- EN: Three tacos with meat, coriander and onion.
                        options = { { id = 'meat', name = 'Carne', min = 1, max = 1, choices = { { id = 'beef', name = 'Vaca', price = 0 }, { id = 'chick', name = 'Frango', price = 0 }, { id = 'pork', name = 'Porco (al pastor)', price = 0.80 }, { id = 'veg', name = 'Vegetariano', price = 0 } } },  -- EN: Meat | Beef | Chicken | Pork (al pastor) | Vegetarian
                                    { id = 'hot', name = 'Picante', min = 1, max = 1, choices = { { id = 'mild', name = 'Suave', price = 0 }, { id = 'med', name = 'Médio', price = 0 }, { id = 'hot', name = 'Muito picante', price = 0 } } } } },  -- EN: Spicy | Mild | Medium | Extra Spicy
                    { id = 'tb_burrito', name = 'Burrito Bomba', desc = 'Arroz, feijão preto, carne, queijo e guacamole.', price = 10.90, kcal = 980, art = { '#C98A3C', '#6E4610' }, glyph = 'wrap', tag = 'popular' },  -- EN: Bomb Burrito | Rice, black beans, meat, cheese and guacamole.
                    { id = 'tb_quesa', name = 'Quesadilla', desc = 'Tortilha tostada com muito queijo.', price = 7.50, kcal = 700, art = { '#E3B857', '#96741C' }, glyph = 'wrap' },  -- EN: Toasted tortilla with loads of cheese.
                } },
                { name = 'Para partilhar', items = {  -- EN: To Share
                    { id = 'tb_nachos', name = 'Nachos supremos', desc = 'Com cheddar quente, jalapeños e natas.', price = 8.90, kcal = 880, art = { '#E0A83C', '#8A5F10' }, glyph = 'nachos' },  -- EN: Supreme Nachos | With melted cheddar, jalapeños and sour cream.
                    { id = 'tb_guac', name = 'Guacamole e totopos', desc = 'Abacate esmagado na hora.', price = 5.90, kcal = 420, art = { '#6BA84F', '#31561F' }, glyph = 'salad' },  -- EN: Guacamole & Tortilla Chips | Freshly mashed avocado.
                } },
                { name = 'Bebidas', items = {  -- EN: Drinks
                    { id = 'tb_agua', name = 'Água fresca de melancia', desc = 'Doce e gelada.', price = 3.20, kcal = 120, art = { '#E8657A', '#8A2436' }, glyph = 'drink' },  -- EN: Watermelon Agua Fresca | Sweet and ice-cold.
                    { id = 'tb_cola', name = 'Cola', desc = 'Lata 33 cl.', price = 2.20, kcal = 140, item = 'cola', art = { '#8B2027', '#3A0A0E' }, glyph = 'drink' },  -- EN: 33 cl can.
                } },
            },
        },
        {
            id = 'noodle', name = 'Noodle Exchange', tagline = 'Asiático · Wok e sopas',  -- EN: Asian · Wok and soups
            cats = { 'asian' }, rating = 4.6, votes = 1122, time = { 25, 40 }, fee = 2.49, min = 9.0,
            coords = { x = -667.0, y = -883.0 }, art = { '#C9303C', '#4A0A10' }, glyph = 'noodles', open = { 11, 2 },
            menu = {
                { name = 'Noodles', items = {
                    { id = 'nx_ramen', name = 'Ramen de porco', desc = 'Caldo tonkotsu 12 horas, ovo marinado e chashu.', price = 13.90, kcal = 780, art = { '#B5651D', '#5A2E08' }, glyph = 'ramen', tag = 'popular',  -- EN: Pork Ramen | 12-hour tonkotsu broth, marinated egg and chashu.
                        options = { { id = 'spice', name = 'Picante', min = 1, max = 1, choices = { { id = '0', name = 'Sem picante', price = 0 }, { id = '1', name = 'Médio', price = 0 }, { id = '2', name = 'Muito picante', price = 0 } } },  -- EN: Spicy | Not Spicy | Medium | Extra Spicy
                                    { id = 'extra', name = 'Extras', min = 0, max = 4, choices = { { id = 'egg', name = 'Ovo extra', price = 1.50 }, { id = 'pork', name = 'Chashu extra', price = 3.00 }, { id = 'nori', name = 'Alga nori', price = 0.80 }, { id = 'corn', name = 'Milho', price = 0.80 } } } } },  -- EN: Extra Egg | Extra Chashu | Nori Seaweed | Corn
                    { id = 'nx_yaki', name = 'Yakisoba de legumes', desc = 'Noodles salteados no wok com molho tonkatsu.', price = 11.50, kcal = 640, art = { '#8A7A3C', '#463C14' }, glyph = 'noodles' },  -- EN: Vegetable Yakisoba | Wok-fried noodles with tonkatsu sauce.
                    { id = 'nx_pad', name = 'Pad Thai', desc = 'Arroz salteado com amendoim, lima e camarão.', price = 12.90, kcal = 710, art = { '#D98C3C', '#8A5010' }, glyph = 'noodles', tag = 'popular' },  -- EN: Stir-fried rice noodles with peanuts, lime and prawns.
                } },
                { name = 'Entradas', items = {  -- EN: Starters
                    { id = 'nx_gyoza', name = 'Gyoza (6)', desc = 'Empadinhas de porco tostadas na frigideira.', price = 6.90, kcal = 380, art = { '#D9BE8A', '#8A7238' }, glyph = 'dumpling' },  -- EN: Pan-fried pork dumplings.
                    { id = 'nx_spring', name = 'Crepes chineses (4)', desc = 'Estaladiços, com molho agridoce.', price = 5.50, kcal = 420, art = { '#D2A05E', '#7A5418' }, glyph = 'dumpling' },  -- EN: Spring Rolls (4) | Crispy, with sweet and sour sauce.
                } },
                { name = 'Bebidas', items = {  -- EN: Drinks
                    { id = 'nx_tea', name = 'Chá verde gelado', desc = 'Sem açúcar, 50 cl.', price = 3.00, kcal = 20, art = { '#7FB069', '#3A5C2A' }, glyph = 'drink' },  -- EN: Iced Green Tea | Unsweetened, 50 cl.
                } },
            },
        },
        {
            id = 'sakura', name = 'Sakura Sushi', tagline = 'Sushi · Japonês',  -- EN: Sushi · Japanese
            cats = { 'sushi', 'asian' }, rating = 4.8, votes = 655, time = { 35, 55 }, fee = 3.49, min = 15.0,
            coords = { x = -1285.0, y = -1116.0 }, art = { '#E8899B', '#8A3348' }, glyph = 'sushi', open = { 12, 23 },
            promo = 'Combinado 40 peças a -15%',  -- EN: 15% off the 40-piece platter
            menu = {
                { name = 'Combinados', items = {  -- EN: Platters
                    { id = 'sk_c20', name = 'Combinado 20 peças', desc = 'Nigiri, maki e california do chef.', price = 24.90, kcal = 980, art = { '#E8899B', '#8A3348' }, glyph = 'sushi', tag = 'popular' },  -- EN: 20-Piece Platter | Chef's selection of nigiri, maki and california rolls.
                    { id = 'sk_c40', name = 'Combinado 40 peças', desc = 'Para duas pessoas, com salmão, atum e camarão.', price = 44.90, kcal = 1960, art = { '#D96B84', '#6E1E30' }, glyph = 'sushi' },  -- EN: 40-Piece Platter | For two, with salmon, tuna and prawns.
                } },
                { name = 'À peça', items = {  -- EN: By the Piece
                    { id = 'sk_salmon', name = 'Nigiri de salmão (2)', desc = 'Salmão fresco sobre arroz avinagrado.', price = 5.50, kcal = 120, item = 'grilled_fish', art = { '#E2874F', '#8A4315' }, glyph = 'sushi' },  -- EN: Salmon Nigiri (2) | Fresh salmon on vinegared rice.
                    { id = 'sk_cali', name = 'California roll (8)', desc = 'Caranguejo, abacate e pepino.', price = 9.90, kcal = 320, art = { '#E5B96B', '#8A6B1E' }, glyph = 'sushi' },  -- EN: California Roll (8) | Crab, avocado and cucumber.
                    { id = 'sk_temaki', name = 'Temaki de atum', desc = 'Cone de alga com atum picante.', price = 7.20, kcal = 260, art = { '#B0424F', '#5A1620' }, glyph = 'sushi' },  -- EN: Tuna Temaki | Seaweed cone with spicy tuna.
                } },
                { name = 'Quentes', items = {  -- EN: Hot Dishes
                    { id = 'sk_gyoza', name = 'Gyoza de camarão (5)', desc = 'Ao vapor, com molho ponzu.', price = 7.90, kcal = 340, art = { '#D9BE8A', '#8A7238' }, glyph = 'dumpling' },  -- EN: Prawn Gyoza (5) | Steamed, with ponzu sauce.
                    { id = 'sk_miso', name = 'Sopa miso', desc = 'Com tofu, alga wakame e cebolinho.', price = 3.90, kcal = 90, art = { '#C08A3C', '#6B4A10' }, glyph = 'soup' },  -- EN: Miso Soup | With tofu, wakame seaweed and spring onion.
                } },
            },
        },
        {
            id = 'beanmachine', name = 'Bean Machine', tagline = 'Café · Pastelaria',  -- EN: Coffee · Pastries
            cats = { 'coffee', 'dessert' }, rating = 4.3, votes = 2043, time = { 10, 20 }, fee = 1.49, min = 4.0,
            coords = { x = -629.9, y = 233.2 }, art = { '#8A6244', '#3E2A1B' }, glyph = 'coffee', open = { 6, 21 },
            promo = 'Café + croissant por 4,50 €',  -- EN: Coffee + croissant for €4.50
            menu = {
                { name = 'Cafés', items = {  -- EN: Coffee
                    { id = 'bm_espresso', name = 'Espresso', desc = 'Curto, intenso, como deve ser.', price = 1.60, kcal = 3, item = 'coffe', art = { '#5C3A21', '#2A1710' }, glyph = 'coffee', tag = 'popular' },  -- EN: Short and intense, as it should be.
                    { id = 'bm_latte', name = 'Latte', desc = 'Leite vaporizado com arte no topo.', price = 3.40, kcal = 190, item = 'coffe', art = { '#B08968', '#6B4A2A' }, glyph = 'coffee', tag = 'popular',  -- EN: Steamed milk with latte art on top.
                        options = { { id = 'milk', name = 'Leite', min = 1, max = 1, choices = { { id = 'cow', name = 'Semi-skimmed', price = 0 }, { id = 'oat', name = 'Aveia', price = 0.50 }, { id = 'soy', name = 'Soja', price = 0.50 }, { id = 'no', name = 'Sem lactose', price = 0.50 } } },  -- EN: Milk | Oat | Soy | Lactose-Free
                                    { id = 'shot', name = 'Extras', min = 0, max = 3, choices = { { id = 'shot', name = 'Café extra', price = 0.80 }, { id = 'van', name = 'Xarope de baunilha', price = 0.60 }, { id = 'car', name = 'Xarope de caramelo', price = 0.60 } } } } },  -- EN: Extra Shot | Vanilla Syrup | Caramel Syrup
                    { id = 'bm_cappu', name = 'Cappuccino', desc = 'Espuma densa e canela.', price = 3.20, kcal = 140, item = 'coffe', art = { '#A87C56', '#5E4028' }, glyph = 'coffee' },  -- EN: Thick foam and cinnamon.
                    { id = 'bm_cold', name = 'Cold brew', desc = '18 horas de infusão a frio.', price = 4.20, kcal = 15, art = { '#4A2E1C', '#1F1109' }, glyph = 'drink' },  -- EN: Cold Brew | Cold-steeped for 18 hours.
                } },
                { name = 'Pastelaria', items = {  -- EN: Pastries
                    { id = 'bm_croissant', name = 'Croissant de manteiga', desc = 'Folhado, feito de madrugada.', price = 2.40, kcal = 280, art = { '#DCAE6B', '#8A6220' }, glyph = 'bread' },  -- EN: Butter Croissant | Flaky, baked at dawn.
                    { id = 'bm_cinnamon', name = 'Rolo de canela', desc = 'Com cobertura de queijo creme.', price = 3.60, kcal = 420, art = { '#C08A5A', '#6E4A22' }, glyph = 'cake' },  -- EN: Cinnamon Roll | With cream cheese frosting.
                    { id = 'bm_cheesecake', name = 'Cheesecake de frutos vermelhos', desc = 'Base de bolacha e compota caseira.', price = 4.80, kcal = 460, art = { '#D96B84', '#7A2438' }, glyph = 'cake' },  -- EN: Red Berry Cheesecake | Biscuit base and homemade jam.
                } },
            },
        },
        {
            id = 'rustybrowns', name = "Rusty Brown's", tagline = 'Donuts · Sobremesas',  -- EN: Donuts · Desserts
            cats = { 'dessert' }, rating = 4.0, votes = 388, time = { 15, 25 }, fee = 1.99, min = 5.0,
            coords = { x = 1249.0, y = -348.0 }, art = { '#E8748F', '#8A2B44' }, glyph = 'donut', open = { 5, 22 },
            menu = {
                { name = 'Donuts', items = {
                    { id = 'rb_box6', name = 'Caixa de 6 donuts', desc = 'Sortido do dia, à escolha do balcão.', price = 9.90, kcal = 1620, art = { '#E8748F', '#8A2B44' }, glyph = 'donut', tag = 'popular' },  -- EN: Box of 6 Donuts | Today's assortment, picked at the counter.
                    { id = 'rb_glazed', name = 'Donut glaceado', desc = 'O clássico, ainda morno.', price = 1.90, kcal = 280, art = { '#E8C06B', '#8A6A1E' }, glyph = 'donut' },  -- EN: Glazed Donut | The classic, still warm.
                    { id = 'rb_choc', name = 'Donut de chocolate', desc = 'Cobertura espessa e granulado.', price = 2.20, kcal = 320, art = { '#6B4423', '#2E1B0D' }, glyph = 'donut' },  -- EN: Chocolate Donut | Thick icing and sprinkles.
                } },
                { name = 'Gelados', items = {  -- EN: Ice Cream
                    { id = 'rb_sundae', name = 'Sundae de caramelo', desc = 'Com amendoim e chantilly.', price = 5.40, kcal = 520, art = { '#D9A05E', '#7A5218' }, glyph = 'icecream' },  -- EN: Caramel Sundae | With peanuts and whipped cream.
                } },
                { name = 'Bebidas', items = {  -- EN: Drinks
                    { id = 'rb_coffee', name = 'Café filtrado', desc = 'Sem fim, como nos diners.', price = 2.00, kcal = 5, item = 'coffe', art = { '#5C3A21', '#2A1710' }, glyph = 'coffee' },  -- EN: Filter Coffee | Bottomless refills, diner-style.
                } },
            },
        },
        {
            id = 'vanilla', name = 'Vanilla Green', tagline = 'Saudável · Poke e sumos',  -- EN: Healthy · Poke and juices
            cats = { 'healthy' }, rating = 4.5, votes = 296, time = { 20, 35 }, fee = 2.29, min = 8.0,
            coords = { x = -1194.0, y = -1500.0 }, art = { '#5FBF77', '#1F6B34' }, glyph = 'salad', open = { 8, 21 },
            menu = {
                { name = 'Taças', items = {  -- EN: Bowls
                    { id = 'vg_poke', name = 'Poke de salmão', desc = 'Arroz, salmão, edamame, abacate e sésamo.', price = 13.50, kcal = 620, art = { '#E2874F', '#7A3A12' }, glyph = 'bowl', tag = 'popular',  -- EN: Salmon Poke | Rice, salmon, edamame, avocado and sesame.
                        options = { { id = 'base', name = 'Base', min = 1, max = 1, choices = { { id = 'rice', name = 'Arroz de sushi', price = 0 }, { id = 'quinoa', name = 'Quinoa', price = 1.00 }, { id = 'salad', name = 'Folhas verdes', price = 0 } } },  -- EN: Sushi Rice | Mixed Greens
                                    { id = 'top', name = 'Toppings', min = 0, max = 5, choices = { { id = 'avo', name = 'Abacate', price = 1.50 }, { id = 'mango', name = 'Manga', price = 1.00 }, { id = 'crisp', name = 'Cebola crocante', price = 0.80 }, { id = 'ses', name = 'Sésamo', price = 0.40 } } } } },  -- EN: Avocado | Mango | Crispy Onion | Sesame
                    { id = 'vg_caesar', name = 'Salada César', desc = 'Frango grelhado, parmesão e croutons.', price = 11.20, kcal = 480, art = { '#6BA84F', '#31561F' }, glyph = 'salad' },  -- EN: Caesar Salad | Grilled chicken, parmesan and croutons.
                } },
                { name = 'Sumos', items = {  -- EN: Juices
                    { id = 'vg_green', name = 'Sumo verde detox', desc = 'Maçã, pepino, aipo, limão e gengibre.', price = 5.90, kcal = 120, item = 'apple_juice', art = { '#7FB069', '#31561F' }, glyph = 'drink', tag = 'popular' },  -- EN: Green Detox Juice | Fresh apple, cucumber, celery, lemon and ginger.
                    { id = 'vg_orange', name = 'Laranja natural', desc = 'Espremida na hora.', price = 4.50, kcal = 110, item = 'orange_juice', art = { '#F09819', '#A85806' }, glyph = 'drink' },  -- EN: Fresh Orange Juice | Freshly squeezed.
                    { id = 'vg_smooth', name = 'Smoothie de frutos vermelhos', desc = 'Morango, framboesa e banana.', price = 6.20, kcal = 240, art = { '#D9536B', '#7A1E30' }, glyph = 'shake' },  -- EN: Red Berry Smoothie | Strawberry, raspberry and banana.
                } },
            },
        },
        {
            id = 'ltd247', name = 'LTD / 24-7', tagline = 'Mercearia · Loja de conveniência',  -- EN: Grocery · Convenience store
            cats = { 'grocery' }, rating = 3.9, votes = 1892, time = { 15, 30 }, fee = 2.99, min = 5.0,
            coords = { x = 24.0, y = -1345.0 }, art = { '#3B82C4', '#134268' }, glyph = 'grocery', open = { 0, 24 },
            menu = {
                { name = 'Essenciais', items = {  -- EN: Essentials
                    { id = 'lt_water', name = 'Pack de água (6)', desc = 'Seis garrafas de 50 cl.', price = 4.20, kcal = 0, item = 'water', art = { '#7FC4E8', '#2F7CA8' }, glyph = 'drink', tag = 'popular' },  -- EN: Water Pack (6) | Six 50 cl bottles.
                    { id = 'lt_bread', name = 'Pão de forma', desc = 'Fatiado, embalado.', price = 2.30, kcal = 1200, item = 'bread_bun', art = { '#DCAE6B', '#8A6220' }, glyph = 'bread' },  -- EN: Sandwich Loaf | Sliced and packaged.
                    { id = 'lt_cola', name = 'Pack de cola (4)', desc = 'Quatro latas de 33 cl.', price = 5.60, kcal = 560, item = 'cola', art = { '#8B2027', '#3A0A0E' }, glyph = 'drink' },  -- EN: Cola Pack (4) | Four 33 cl cans.
                } },
                { name = 'Fruta e legumes', items = {  -- EN: Fruit & Vegetables
                    { id = 'lt_apple', name = 'Maçãs (1 kg)', desc = 'Da região, doces.', price = 3.40, kcal = 500, item = 'apple', art = { '#C0392B', '#5E1A12' }, glyph = 'fruit' },  -- EN: Apples (1 kg) | Locally grown and sweet.
                    { id = 'lt_banana', name = 'Bananas (1 kg)', desc = 'Maduras q.b.', price = 2.80, kcal = 900, item = 'banana', art = { '#E3C04A', '#8A7010' }, glyph = 'fruit' },  -- EN: Just ripe enough.
                    { id = 'lt_tomato', name = 'Tomate (500 g)', desc = 'Bom para saladas.', price = 2.20, kcal = 100, item = 'tomato', art = { '#C0392B', '#5E1A12' }, glyph = 'fruit' },  -- EN: Tomatoes (500 g) | Great for salads.
                } },
                { name = 'Snacks', items = {
                    { id = 'lt_chips', name = 'Batatas fritas de pacote', desc = 'Sal e vinagre.', price = 2.60, kcal = 540, art = { '#E9B949', '#A97B12' }, glyph = 'fries' },  -- EN: Potato Crisps | Salt and vinegar.
                } },
            },
        },
        {
            id = 'pharmacy', name = 'Farmácia Pillbox', tagline = 'Farmácia · 24 horas',  -- EN: Pillbox Pharmacy | Pharmacy · 24 hours
            cats = { 'pharmacy' }, rating = 4.9, votes = 431, time = { 10, 25 }, fee = 3.49, min = 4.0,
            coords = { x = 298.6, y = -584.4 }, art = { '#3FA79A', '#14554E' }, glyph = 'pills', open = { 0, 24 },
            menu = {
                { name = 'Primeiros socorros', items = {  -- EN: First Aid
                    { id = 'ph_band', name = 'Pensos rápidos', desc = 'Caixa com 20 unidades.', price = 6.90, kcal = 0, item = 'bandage', art = { '#E8E8EA', '#9A9AA0' }, glyph = 'pills', tag = 'popular' },  -- EN: Bandages | Box of 20.
                    { id = 'ph_pain', name = 'Analgésico', desc = 'Caixa de 20 comprimidos.', price = 8.50, kcal = 0, art = { '#5CA9E8', '#1E5C8A' }, glyph = 'pills' },  -- EN: Painkillers | Box of 20 tablets.
                } },
                { name = 'Wellness', items = {
                    { id = 'ph_vit', name = 'Multivitamínico', desc = 'Um mês de tratamento.', price = 12.90, kcal = 0, art = { '#E8A83C', '#8A5F10' }, glyph = 'pills' },  -- EN: Multivitamins | A one-month supply.
                    { id = 'ph_water', name = 'Água (1,5 L)', desc = 'Para tomar os comprimidos.', price = 1.90, kcal = 0, item = 'water', art = { '#7FC4E8', '#2F7CA8' }, glyph = 'drink' },  -- EN: Water (1.5 L) | For taking your tablets.
                } },
            },
        },
    },
}

-- ------------------------------------------------------------
-- Automatic mail
-- ------------------------------------------------------------
Config.AutoMails   = true
-- Automatic emails: the text is SAVED in the mailbox (it does not go through the NUI translator), so write it in your server's language.
Config.WelcomeMail = { sender = 'Midnight Mobile', subject = 'Welcome to Midnight Mobile',
    body = 'Hi!\n\nYour account is now active. You can manage your number, passcode and preferences in the Settings app.\n\nMidnight Mobile' }
-- Email for a new invoice (server/billing.lua): %s = amount, who issued it, reason
Config.BillMail = { sender = 'Bills', email = 'bills@midnight.co.uk', subject = 'New bill: %s',
    body = 'You received a bill of %s from %s.\n\nReason: %s\n\nYou can pay it in the Bills app.' }

-- ------------------------------------------------------------
-- AirShare (docs/ARQUITETURA.md 10.1): radius in metres to see/send to people nearby and
-- seconds an offer waits for a reply before expiring (server/airdrop.lua).
-- ------------------------------------------------------------
Config.AirDrop = { radius = 12.0, offerSeconds = 60 }
-- ------------------------------------------------------------
-- Surf (browser): enabled = false disables the app; allow = { 'wikipedia.org', ... } restricts it to those sites
-- (empty = no restriction). sites = shortcuts on the home page (your server's sites: store, rules, web discord...).
-- Many large sites (Google, YouTube, social networks) REFUSE to open inside another page and stay blank.
-- ------------------------------------------------------------
Config.Browser = {
    enabled = true,
    allow   = {},
    search  = 'https://www.bing.com/search?q=',   -- search engine (must allow being opened inside an iframe)
    sites   = {
        -- { name = 'Regras do servidor', url = 'https://exemplo.com/regras', color = '#0A84FF', letter = 'R' },
    },
}

-- ------------------------------------------------------------
-- Vera Chat (AI assistant, Gemini). THE KEY DOES NOT GO HERE: this file is downloaded by every player.
-- Put it in server/ai_key.lua (server only) or in server.cfg:  set apex_phone_gemini_key "a_tua_chave"
-- ------------------------------------------------------------
Config.AI = {
    enabled     = true,
    name        = 'Vera Chat',
    models      = { 'gemini-3.5-flash', 'gemini-3.6-flash', 'gemini-flash-latest' },  -- tried in order (Google retires models)
    maxHistory  = 12,        -- previous messages sent as context
    maxChars    = 600,       -- maximum length of each question
    cooldownMs  = 3000,      -- minimum wait between questions from the same player
    perHour     = 40,        -- questions per player per hour
    -- Vera VOICE: saying "Vera" (or "Hey Vera, open maps") opens it and runs the request. The microphone only records when
    -- there is speech and each sentence is transcribed by Gemini (1 API request per sentence). Each player can turn it off in
    -- Settings > Vera. whenClosed = true also listens with the phone put away (more API requests).
    -- ⚠️ Gemini FREE TIER: 500 requests/DAY per model. Listening sends every sentence spoken with the phone open;
    -- perDay is the cap for the whole server (when the quota runs out, voice turns itself off until the next day). For serious
    -- use, enable billing on Google (ai.dev) or set enabled = false (Vera's microphone button uses the same cap).
    voice       = { enabled = true, whenClosed = false, perMinute = 6, perDay = 400, models = { 'gemini-3.5-flash-lite', 'gemini-3.1-flash-lite', 'gemini-3.5-flash' } },
    serverName  = 'Midnight Roleplay',
    -- What the AI knows about the server (rules, jobs, locations, commands). Write it here in plain text.
    serverInfo  = [[
Midnight Roleplay FiveM UK.
James Kapper can not drive. He crashes all the time. Michael Smith's Moustache is genuine, not glued.
]],
}

-- ============================================================
-- ADMIN PANEL (/phoneadmin)
-- Everything changed in the panel is stored in the database (apex_phone_admin) and overrides this file:
-- phone settings, apps on/off, the shop and custom apps (with webhooks).
-- "Repor" (Reset) in the panel removes the change and goes back to what is here.
-- Who can use it: ACE 'apex_phone.admin' (or 'command'), or the ESX / QBCore / QBox admin group.
-- ============================================================
Config.Admin = {
    command = 'phoneadmin',      -- '' disables the command (the panel can still be opened via the OpenAdminPanel export)
    ace     = 'apex_phone.admin',
    logKeep = 2000,              -- lines kept in the panel's change log
}

-- ============================================================
-- CUSTOM APPS (created in the admin panel)
-- Custom categories in the AppShop. The apps themselves are created in the panel (Work apps > New app).
-- ============================================================
Config.CustomApps = {
    categories = { 'Public Services', 'Job', 'Businesses' },  -- EN: Public services | Job | Businesses
    maxApps    = 40,            -- custom apps on the server
    maxModules = 10,            -- modules per app
    itemsKeepDays = 90,         -- reports, requests and appointments closed longer ago than this are removed from the database (0 = never)
}

-- ============================================================
-- PHONE SHOP
-- Vendor (NPC), categories, 3D viewer and purchase. All of this is the starting point: the admin panel
-- turns the shop on/off, changes prices, hides products and moves the shops without touching this file.
-- ============================================================
Config.Shop = {
    enabled  = true,
    currency = { symbol = Config.Currency.symbol, position = Config.Currency.position },   -- follows Config.Currency; 'after' = "1 499 €" | 'before' = "$1,499"
    imagePath = 'nui://apex_phone/inventory_images/%s.png',
    payment  = { accounts = { 'bank', 'cash' }, default = 'bank' },
    rateLimit = { cooldownMs = 1500, perMinute = 8 },
    interaction = {
        mode     = 'auto',          -- 'auto' (ox_target if it is running, otherwise key) | 'target' | 'key'
        distance = 2.0,
        key      = 38,              -- 38 = E
        keyLabel = 'E',
        icon     = 'fa-solid fa-mobile-screen-button',
    },
    closeDistance  = 6.0,           -- the shop closes if the player moves further than this from the vendor
    serverDistance = 10.0,          -- the server rejects purchases made further than this from a shop
    camera = { enabled = true, distance = 1.85, height = 0.55, shift = 0.78, fov = 42.0, ease = 700 },
    hidePlayer = true,
    ped = { model = 's_m_m_lifeinvad_01', scenario = 'WORLD_HUMAN_STAND_MOBILE', spawnDistance = 70.0, snapToPavement = true, snapMax = 6.0 },
    -- sprite 817 = radar_payphone (a phone handset): exists since build 2545 and in the minimap.gfx that HUDs stream.
    -- spriteModern is used from build `modernBuild` on. 899 = radar_mobile_phone (a smartphone, build 3570+) looks
    -- nicer, BUT many HUDs and blip scripts stream their own older minimap.gfx without it, and then the blip shows
    -- as a plain round dot. Only set spriteModern = 899 if no resource on your server streams a minimap.gfx.
    -- label: the name of every shop blip on the map. nil = "Phone shop" translated into the player's phone language
    -- (locales/<code>.lua, key "Loja de telemóveis"); a text here is shown as written. One shop can override it
    -- with `blipLabel = '...'` in its entry below (also editable in /phoneadmin > Shop > Locations).
    blip = { enabled = true, sprite = 817, spriteModern = 817, modernBuild = 3570, color = 3, scale = 0.85, label = nil },
    -- One shop by default. Add more entries here (or in /phoneadmin > Shop > Locations), each with its own id.
    shops = {
        { id = 'hawick', label = 'Midnight Mobiles', coords = vec4(85.08, -228.85, 53.63, 343.97),
          vendor = { name = 'Steve', role = 'Seller', greeting = 'Hi! We have the PearPhone, the NOVA and the foldables. Spin them around as much as you like before you buy.' },  -- EN: Seller
          ped = { snapToPavement = false } },   -- hand-picked position: the vendor stands exactly here
    },
    categories = {
        { id = 'all',          label = 'All',         icon = 'grid' },  -- EN: All
        { id = 'pearphone',    label = 'PearPhone',   icon = 'pear' },
        { id = 'nova',         label = 'NOVA',        icon = 'nova' },
        { id = 'foldables',    label = 'Foldables',   icon = 'fold' },  -- EN: Foldables
        { id = 'audio',        label = 'Audio',       icon = 'buds' },  -- EN: Earbuds
        { id = 'accessories',   label = 'Accessories', icon = 'sim' },   -- eSIM
    },
    -- One card per model; each colour is an inventory item. viewer.kind: phone | fold | buds
    -- viewer.hide = materials to hide (JS regular expression) and viewer.mark = fictional brand shown in their place
    products = {
        { id = 'pear18', name = 'PearPhone 18 Pro Max', brand = 'PearPhone', os = 'PearOS 27', categories = { 'pearphone' }, price = 1499,
          tagline = 'The most advanced PearPhone ever',  -- EN: The most advanced PearPhone ever.
          features = { '6.9-inch 120 Hz OLED display', '48 MP Pro camera system', 'PearOS 27 with the Vera assistant', 'All-day battery' },  -- EN: 6.9-inch 120 Hz OLED display | 48 MP Pro camera system | PearOS 27 with the Vera assistant | All-day battery
          specs = { screen = '6,9"', camera = '48 MP', chip = 'P19 Pro', battery = '4 685 mAh' },
          usage = 'Use it from your inventory to open PearOS. Works with any PearPhone or NOVA.',  -- EN: Use it from your inventory to open PearOS. Works with any PearPhone or NOVA.
          viewer = { kind = 'phone', yaw = -0.5, pitch = 0.10 },
          variants = {
            { item = 'pear18_black', color = 'Black',     swatch = '#2C2D31', model = 'pear18_black.glb' },  -- EN: Black
            { item = 'pear18_white', color = 'White',    swatch = '#E7E5E0', model = 'pear18_white.glb' },  -- EN: White
            { item = 'pear18_ice',   color = 'Ice Blue', swatch = '#AFC7DA', model = 'pear18_ice.glb' },  -- EN: Ice Blue
            { item = 'pear18_wine',  color = 'Burgundy',     swatch = '#6A2433', model = 'pear18_wine.glb' },  -- EN: Burgundy
          } },
        { id = 's26', name = 'NOVA S26 Ultra', brand = 'NOVA', os = 'Nova UI 9', categories = { 'nova' }, price = 1399,
          tagline = 'Limitless power, with Nova UI 9.',  -- EN: Limitless power, with Nova UI 9.
          features = { '6.8-inch 120 Hz display', '200 MP camera with 10x zoom', 'Nova UI 9 with the Vera assistant', 'The same apps and account as your PearPhone' },  -- EN: 6.8-inch 120 Hz display | 200 MP camera with 10x zoom | Nova UI 9 with the Vera assistant | The same apps and account as your PearPhone
          specs = { screen = '6,8"', camera = '200 MP', chip = 'Nova X5', battery = '5 000 mAh' },
          usage = 'Use it from your inventory to open Nova UI. Same account and number as your PearPhone.',  -- EN: Use it from your inventory to open Nova UI. Same account and number as your PearPhone.
          viewer = { kind = 'phone', yaw = -0.5, pitch = 0.10 },
          variants = {
            { item = 's26_black',  color = 'Black',        swatch = '#25272C', model = 's26_black.glb' },  -- EN: Black
            { item = 's26_white',  color = 'White',       swatch = '#E6E5E1', model = 's26_white.glb' },  -- EN: White
            { item = 's26_violet', color = 'Violet',      swatch = '#8576B0', model = 's26_violet.glb' },  -- EN: Violet
            { item = 's26_sky',    color = 'Sky Blue', swatch = '#9DBFE0', model = 's26_sky.glb' },  -- EN: Sky Blue
          } },
        { id = 'pearfold', name = 'PearPhone Fold', brand = 'PearPhone', os = 'PearOS 27', categories = { 'pearphone', 'foldables' }, price = 2199, badge = 'Novo',  -- EN: New
          tagline = 'A big screen that folds into your pocket.',  -- EN: A big screen that folds into your pocket.
          features = { '7.8-inch foldable inner display', 'Hinge that closes completely flat', 'Two apps side by side on the open screen', 'PearOS 27 with the Vera assistant' },  -- EN: 7.8-inch foldable inner display | Hinge that closes completely flat | Two apps side by side on the open screen | PearOS 27 with the Vera assistant
          specs = { screen = '7,8"', camera = '48 MP', chip = 'P19 Pro', battery = '4 400 mAh' },
          usage = 'Use it from your inventory to open PearOS. Try the Fold button in the 3D view.',  -- EN: Use it from your inventory to open PearOS. Try the Fold button in the 3D view.
          viewer = { kind = 'fold', yaw = 2.55, pitch = 0.10, hide = { '\\.Logo$' }, mark = { kind = 'pear' } },
          variants = {
            { item = 'pearfold_night', color = 'Midnight Blue',     swatch = '#27344E', model = 'pearfold_night.glb' },  -- EN: Midnight Blue
            { item = 'pearfold_star',  color = 'Star White',        swatch = '#D9DEE4', model = 'pearfold_star.glb' },  -- EN: Star White
          } },
        { id = 'novaflip', name = 'NOVA Fold8', brand = 'NOVA', os = 'Nova UI 9', categories = { 'nova', 'foldables' }, price = 1199, badge = 'Novo',  -- EN: New
          tagline = 'Opens like a book, with a wide inner screen.',  -- EN: Opens like a book, with a wide inner screen.
          features = { 'Side hinge that opens like a book', 'Outer screen for using the device closed', 'Wide inner screen for your apps', 'Nova UI 9 with the Vera assistant' },  -- EN: Side hinge that opens like a book | Outer screen for using the device closed | Wide inner screen for your apps | Nova UI 9 with the Vera assistant
          specs = { screen = '8,0"', camera = '200 MP', chip = 'Nova X5', battery = '4 400 mAh' },
          usage = 'Use it from your inventory to open Nova UI. Try the Fold button in the 3D view.',  -- EN: Use it from your inventory to open Nova UI. Try the Fold button in the 3D view.
          viewer = { kind = 'fold', yaw = 2.6, pitch = 0.10, revision = 'fold8-black-20261001' },
          variants = {
            { item = 'novaflip_lavender',  color = 'Lavender',  swatch = '#BBAED8', model = 'novaflip_lavender.glb' },  -- EN: Lavender
            { item = 'novaflip_grey',      color = 'Grey', swatch = '#5D6266', model = 'novaflip_grey.glb' },  -- EN: Grey
            { item = 'novaflip_cream',     color = 'Cream',    swatch = '#E8DDB9', model = 'novaflip_cream.glb' },  -- EN: Cream
            { item = 'novaflip_pistachio', color = 'Pistachio', swatch = '#AEC08A', model = 'novaflip_pistachio.glb' },  -- EN: Pistachio
          } },
        { id = 'airpods', name = 'AirPods Pro 3', brand = 'PearPhone', os = 'Bluetooth', categories = { 'audio' }, price = 279,
          tagline = 'Immersion sound, completely wireless.',  -- EN: Immersive sound, completely wireless.
          features = { 'Connect to your phone via Bluetooth', 'Music just for you, with your phone closed', 'Answer calls without taking your phone out', 'Active noise cancellation' },
          specs = { battery = '30 h', audio = 'ANC' },
          usage = 'Use the item to put them in, then connect them in Settings > Bluetooth.',  -- EN: Use the item to put them in, then connect them in Settings > Bluetooth.
          viewer = { kind = 'buds', yaw = 0.35, pitch = 0.28, revision = 'airpods-white-20261112' },
          variants = {
            { item = 'airpods', color = 'White', swatch = '#F2F2F0', model = 'airpods.glb', image = 'nui://apex_phone/inventory_images/airpods_case.png' },  -- EN: White
          } },
        { id = 'slate_buds', name = 'NOVA Buds 4 Pro', brand = 'NOVA', os = 'Bluetooth', categories = { 'audio' }, price = 229,
          tagline = 'Connect to any phone via Bluetooth.',  -- EN: Connect to any phone via Bluetooth.
          features = { 'Charging case', 'Active noise cancellation', 'MMusic just for you, with your phone in your pocket', 'Hands-free calls' },  -- EN: Charging case | Active noise cancellation | Music just for you, with your phone in your pocket | Hands-free calls
          specs = { battery = '28 h', audio = 'ANC' },
          usage = 'Use the item to put them in, then connect them in Settings > Bluetooth.',  -- EN: Use the item to put them in, then connect them in Settings > Bluetooth.
          viewer = { kind = 'buds', yaw = -0.35, pitch = 0.32, revision = 'nova-all-black-20261112' },
          variants = {
            { item = 'slate_buds', color = 'Black', swatch = '#202124', model = 'slate_buds.glb' },  -- EN: Black
          } },
        -- eSIM: card with a QR code; viewer.kind 'card' = simple rotating object (no folding, no case)
        { id = 'esim', name = 'eSIM Midnight Mobile', brand = 'Midnight Mobile', os = 'eSIM', categories = { 'accessories' },
          price = (Config.Sim and Config.Sim.price) or 150,
          tagline = 'One more number on the same phone.',  -- EN: One more number on the same phone.
          features = { 'Activate it with the camera: scan the QR code', 'Up to three numbers on the same phone', 'Give each line a name and a color', 'Works on PearPhone and NOVA' },  -- EN: Activate it with the camera: scan the QR code | Up to three numbers on the same phone | Give each line a name and a color | Works on PearPhone and NOVA
          specs = { network = '5G', lines = '1' },
          usage = 'Use the card from your inventory: the phone opens the camera so you can scan the QR code.',  -- EN: Use the card from your inventory: the phone opens the camera so you can scan the QR code.
          viewer = { kind = 'card', yaw = -0.45, pitch = 0.18 },
          variants = {
            { item = 'esim', color = 'Apex Mobile', swatch = '#1F5EFF', model = 'esim_card.glb' },
          } },
    },
}

-- >>> INTEG
-- ------------------------------------------------------------
-- INTEGRATIONS: connect your own server scripts to the phone apps (Garage, Wallet, Home, Bills).
-- The phone ALWAYS works on its own: when nothing is configured, or the configured resource is not
-- started, or it throws an error, the app falls back to the phone's built-in behaviour (one console warning).
--
-- Each category accepts:
--   'auto'     (default) a provider registered at runtime by another resource, then your adapter in
--              integrations/custom.lua (when you filled it in), then the FIRST supported resource below that
--              is started, else 'builtin'
--   'builtin'  the phone's own behaviour:
--                garage  = the framework vehicles table (player_vehicles / owned_vehicles) + Config.Garages
--                bank    = framework bank money (+ apex_banking IBAN/history when it is started)
--                housing = qb-houses (the Home app says "no housing system" without it)
--                billing = the phone's own bills (apex_phone_bills)
--   'custom'   your adapter in integrations/custom.lua (open file, documented there), or a provider that
--              another resource registered with exports.apex_phone:RegisterIntegration(category, impl)
--   '<id>'     force one supported resource (ids below). Not started = 'builtin' until it starts.
--
-- Supported ids ('auto' tries them in this order):
--   garage : 'apex_garage', 'jg-advancedgarages', 'cd_garage', 'okokGarage', 'qs-advancedgarages', 'vms_garagesv2',
--            'codem-garagesv2', 'codem-garage', 'op-garages', 'kartik-garages', 'tgiann-realparking', 'tgiann-garage',
--            'ak47_garage', 'ak47_qb_garage', 'zerio-garage', 'renzu_garage', 'rhd_garage', 'lunar_garage',
--            'MojiaGarages', 't1ger_garage', 'esx_advancedgarage', 'qbx_garages', 'qb-garages', 'esx_garage'
--   bank   : 'apex_banking' (= builtin), 'Renewed-Banking', 'okokBanking', 'tgg-banking', 'ps-banking', 'qb-banking' (2.x),
--            'pefcl', 'fd_banking', 'qs-banking', 'kartik-banking', 'wasabi_banking', 'crm-banking', 'snipe-banking',
--            'nfs-banking', 'esx_banking' (ESX only)
--   housing: 'ps-housing', 'kartik-properties', 'tk_housing', 'nolag_properties', 'bcs_housing', 'vms_housing',
--            'qs-housing', 'RxHousing', 'origen_housing', 'ak47_qb_housing', 'ak47_housing', 'loaf_housing',
--            'qbx_properties', 'qb-houses' (= builtin), 'esx_property' (list + GPS only: no lock/key API)
--            (+ apartments from qb-apartments / qbx_apartments, see Config.Integrations.apartments)
-- Full list with what each one supports: integrations/README.md
--   billing: 'wasabi_billing', 'apex_billing', 'elevate_billing', 'bs_billing', 'peleg-billing', 'okokBilling',
--            'qs-billing', 'esx_billing', 'jim-payments', 'qb-phone' (phone_invoices)   (phone bills always stay visible too)
-- Console: `phoneintegrations` prints what is active, what is detected and what is registered.
-- ------------------------------------------------------------
Config.Integrations = {
    garage  = 'auto',
    bank    = 'auto',
    housing = 'auto',
    billing = 'auto',
    debug   = false,   -- true = extra console lines from the integration layer
}
-- INTEG2 (society): company / job accounts. Where the money of bills issued "on behalf of the company" goes (Bills app,
-- job apps billing module, police fines), and Eats restaurant payouts. 'builtin' = Config.SocietyProvider (top of this
-- file), exactly as before (and the value used while Config.SocietyProvider is forced to one resource or 'none').
-- Supported ids ('auto' tries them in this order):
--   'apex_bossmenu', 'Renewed-Banking', 'qb-banking' (2.x), 'qb-management' (versions with money), 'okokBanking',
--   'tgg-banking', 'fd_banking', 'qs-banking', 'kartik-banking', 'wasabi_banking', 'tgiann-bank', 'crm-banking',
--   'snipe-banking', 'esx_addonaccount' (esx_society 'society_<job>')
Config.Integrations.society = 'auto'
-- INTEG2 (apartments): starter apartments are ADDED to the Home app list of any housing system (GPS to the door only).
-- 'auto' = qb-apartments or qbx_apartments when started; false = hide them; or force 'qb-apartments' / 'qbx_apartments'.
Config.Integrations.apartments = 'auto'
-- INTEG2 (dispatch): a request made in the Services app (Config.Services) to one of the jobs below ALSO becomes an
-- alert in your dispatch / MDT, so on-duty units see it there (caller name, number, message, GPS position).
-- 'builtin' = only the phone's own Services notifications (as before). Same values as the other categories.
-- Supported ids ('auto' tries them in this order):
--   'apex_mdt', 'ps-dispatch', 'cd_dispatch', 'qs-dispatch', 'rcore_dispatch', 'core_dispatch', 'tk_dispatch',
--   'linden_outlawalert', 'lb-tablet', 'kartik-mdt', 'origen_police', 'wasabi_mdt' (police), 'redutzu-mdt' (police),
--   'ND_MDT' (police)
Config.Integrations.dispatch = 'auto'
-- service job (Config.Services[].job, or the service id) -> the job names your dispatch sends the alert to.
-- Services not listed here (mechanic, taxi, ...) stay phone only; add e.g. mechanic = { 'mechanic' } to send them too.
-- ps-dispatch also accepts QBCore job types here ('leo', 'ems').
Config.Integrations.dispatchJobs = {
    police    = { 'police', 'sheriff' },
    ambulance = { 'ambulance' },
}
Config.Integrations.dispatchOnly = false   -- true = when the dispatch took the alert, the agents' phones are NOT notified
Config.Integrations.dispatchCode = '999'   -- code shown on the alert
-- <<< INTEG

-- >>> STOLEN
-- ------------------------------------------------------------
-- SOMEONE ELSE'S PHONE (off by default)
-- On: every phone (item from Config.Devices) gets an OWNER, saved in the item metadata the first time
-- someone uses it. Whoever uses SOMEONE ELSE'S phone (stolen, borrowed, found) opens the OWNER's account:
-- messages, contacts, photos, social networks, mail, notes... When the owner has a passcode, their lock screen asks for it
-- (the same attempts and lockouts as Config.PinLock); Face Key and fingerprint never work for another person.
-- Money, account settings, passcode, eSIM/lines and phone reset are ALWAYS blocked in that case.
-- Putting the phone away (or using your own) goes back to your own account.
-- Needs an inventory with per-slot metadata: ox_inventory (any framework) or qb-inventory (QBCore).
-- Without it the option switches itself off with a console warning. Off = everything exactly as before.
-- ------------------------------------------------------------
Config.StolenPhones = {
    enabled           = true,  -- true = phones have an owner and can be used by someone else
    requirePin        = true,   -- owner with a passcode: always ask for it (false = someone else's phone opens without the passcode)
    allowWhenNoPin    = true,   -- owner WITHOUT a passcode: opens straight away (false = someone else's phone without a passcode does not open)
    allowSendMessages = true,   -- SMS, Zapp, mail and darkchat on behalf of the owner (the other side sees the owner's number)
    allowSocial       = true,   -- post, comment, like and follow on the owner's social networks
    allowCalls        = true,   -- call and answer with the owner's number
    routeIncoming     = true,   -- while someone else's phone is OPEN, the owner's SMS, calls and alerts go to that device
    blockMoney        = true,   -- bank, bills, crypto, purchases (Onion, Marketplace, Eats, shop), services, job apps and houses
    notifyOwner       = true,   -- the owner's account gets a notice: "Your phone was unlocked by someone else"
    notifyOwnerGame   = false,  -- and also an on-screen notice for the owner, if online
    blocked           = {},     -- extra RPCs to block on someone else's phone (exact names, or prefixes ending in '.': 'music.')
    allowed           = {},     -- RPCs that pass even when they are in the block lists (e.g. 'bank.info')
    debug             = false,  -- true = lines in the server console (sessions, stamps, blocks)
}
-- <<< STOLEN

-- >>> RADIO
-- ------------------------------------------------------------
-- RADIO APP: a walkie-talkie inside the phone. Players tune a frequency and talk to everyone on it.
-- The voice goes through the server's voice resource (same detection as calls: Config.Voice, then 'auto'):
--   pma-voice   the SERVER puts the player on a pma radio channel (setPlayerRadio). With voice.lockChannels, only players
--               admitted by the phone can be on those channels (addChannelCheck). Talking: the phone's PTT key and the
--               app button run pma's own '+radiotalk' command; pma's own radio key (voice_defaultRadio) also works.
--               Mic clicks, the radio submix and the radio animation (voice_enableRadioAnim) are pma's.
--   saltychat   the SERVER sets the radio channel (SetPlayerRadioChannel). Talking runs SaltyChat's '+primaryRadio'
--               command (voice.saltychat.pttCommand); SaltyChat's own radio key also works. (not tested in game)
--   mumble-voip the CLIENT sets the radio channel (SetRadioChannel). mumble-voip has no talk command: its own radio key
--               is used, and the phone presses that control while transmitting (voice.mumble.radioControl). (not tested)
--   none        no running voice resource with radio support: the app says so and stays disabled.
-- Restricted frequencies, items, earbuds and private codes are always checked on the SERVER.
-- Server exports: GetRadioChannel(src), SetRadioChannel(src, freq[, code]) (nil/0 = leave), GetChannelMembers(freq).
-- Client exports: GetRadioFrequency(), IsRadioTransmitting() (true while the mic is live, in every talk mode),
-- GetRadioTalkMode() ('ptt' | 'toggle' | 'open').
-- ------------------------------------------------------------
Config.Radio = {
    enabled          = false,      -- false = the app is hidden for everyone and nobody can join a frequency
    preinstalled     = false,      -- true = added once to every phone's home screen (otherwise install it from the store)

    -- Band
    minFreq          = 1.0,       -- lowest frequency (MHz)
    maxFreq          = 999.9,     -- highest frequency (MHz)
    step             = 0.1,       -- +/- step AND resolution: 0.1 = one decimal, 0.05 / 0.01 = two decimals, 1 = whole numbers
    defaultFreq      = 100.0,     -- what the dial shows the first time
    defaultVolume    = 60,        -- radio volume 0..100 until the player changes it (saved per character)

    -- Requirements (checked when joining AND while connected; leaving the condition disconnects the radio)
    requireEarbuds   = false,     -- true = must be WEARING AirBuds or NOVA Buds 4 Pro (Config.EarbudsItem / slate_buds)
    requireItem      = '',        -- '' = none; an item the player must carry (e.g. 'radio'), checked on the server
    requireItemLabel = '',        -- name of that item shown in the app ('' = the item name)
    allowInVehicle   = true,      -- false = getting into a vehicle disconnects the radio
    disableWhenDead  = true,      -- dead or down = disconnected
    disableInWater   = false,     -- true = swimming disconnects the radio
    keepOnWhenPhoneClosed = true, -- false = putting the phone away disconnects the radio

    -- Talking
    talkMode         = 'ptt',     -- how the radio key and the app's big button transmit:
                                  --   'ptt'    hold to talk (hold the key / hold the button)
                                  --   'toggle' press once to start transmitting, press again to stop (key or a tap on the
                                  --            button); maxTalkSeconds still applies
                                  --   'open'   open mic: you transmit the whole time you are on a frequency, like a voice
                                  --            channel. The key and the button become a MUTE toggle; no time limit
    allowPlayerMode  = false,     -- true = each player can pick their own mode in the app (saved per character);
                                  -- talkMode above is the default until they do
    playerModes      = { 'ptt', 'toggle', 'open' },  -- modes players may pick when allowPlayerMode = true
    pttKeyEnabled    = true,      -- false = no key from the phone (players use the voice resource's own radio key)
    pttKey           = 'CAPITAL', -- default key (Caps Lock). Players can rebind it in Settings > Key Bindings > FiveM
    pttCommand       = 'apexradio_ptt', -- command behind the key (+name / -name). FiveM saves keys per command NAME:
                                  -- to give everyone a new default key, change this name (changing pttKey alone does not)
                                  -- 'toggle' / 'open' with pma-voice or SaltyChat: give their own radio key a DIFFERENT
                                  -- key, otherwise releasing it also ends the phone's transmission for a moment
    maxTalkSeconds   = 60,        -- 'ptt' and 'toggle': a transmission is released after this long (0 = no limit).
                                  -- Ignored in 'open'
    animation = {                 -- radio-to-mouth animation while transmitting
        enabled = true,           -- false = never play it (any mode)
        dict = 'random@arrests', clip = 'generic_radio_chatter', flag = 49,
        whenPhoneOpen = false,    -- true = also with the phone in the hand
        inVehicle = true,         -- false = no animation inside vehicles
        openMic = false,          -- 'open' mode: true = keep the animation for the whole open-mic session (usually not wanted)
    },

    -- Channels
    restricted = {
        -- only these jobs may join these frequencies (job = minimum grade level), checked on the server for QBCore, QBox,
        -- ESX ('off<job>' counts as off duty) and standalone (Config.Standalone.getJob). Optional per entry:
        -- onDuty = true (must be on duty), ace = 'some.ace' (an ACE that also gives access).
        { from = 1.0, to = 10.0, label = 'Emergency', jobs = { police = 0, ambulance = 0 }, onDuty = false },
    },
    privateChannels  = true,      -- the first person on an empty frequency can lock it with a code; others need the code
    maxMembersPerChannel = 32,    -- 0 = no limit
    showMembers      = 'names',   -- 'names' (character name or callsign) | 'numbers' (phone number) | 'count' | 'none'
    allowCallsign    = true,      -- players can set a callsign shown instead of their name (showMembers = 'names')
    maxPresets       = 12,        -- favourite frequencies per character
    notifyOnJoin     = true,      -- members see a short notice when someone joins or leaves
    gameNotify       = true,      -- with the phone put away, a game notification says why the radio switched off

    -- Sounds (synthesised by the phone, no audio files). The voice resource may add its own clicks (pma-voice micClicks).
    sounds = { enabled = true, volume = 0.6, txChirp = true, rxSquelch = true },

    voice = {
        provider     = 'auto',    -- 'auto' | 'pma-voice' | 'saltychat' | 'mumble-voip' | 'none'
        channelBase  = 2000000,   -- pma-voice / mumble-voip channel = channelBase + frequency x 10^decimals (calls use 50000+)
        lockChannels = true,      -- pma-voice: only players admitted by the phone can be on these channels
        saltychat    = { prefix = 'apexphone_', speaker = false, pttCommand = 'primaryRadio' },
        mumble       = { radioControl = 137 },  -- control pressed while the phone transmits (137 = Caps Lock)
    },
}
-- <<< RADIO

-- >>> PSIM
-- ------------------------------------------------------------
-- PHYSICAL SIM CARDS (off by default). server/psim.lua + client/psim.lua + html/js/apps/psim.js
-- On: the phone NUMBER lives on a 'sim_card' item (metadata { iccid, number }) that sits in the SIM tray of a phone item.
--   * Whoever's phone holds the SIM uses that number (calls, SMS, Zapp, caller ID) and receives its calls/messages.
--     Move the SIM to another phone and the number goes with it. A phone without a SIM shows "No SIM" (no calls, no SMS)
--     but still opens: every app that does not need a number keeps working.
--   * Data ON the phone stays with the phone: contacts, photos, notes, settings/wallpaper, passcode/Face Key, call history,
--     notifications, app layout. Messages (they follow the number), group chats, social accounts, bank and bills stay
--     "in the cloud" exactly as before.
--   * This also turns on phone ownership (Config.StolenPhones, its options still apply): a phone belongs to the first
--     character who used it, and using somebody else's phone opens THEIR phone behind THEIR lock screen (passcode only,
--     Face Key never works for another person). Putting it away locks it again but it stays the phone in your hand.
--   * The phone in your hand = the last phone you used (the open key opens that one); use another phone item to switch.
--   * Insert / eject: Settings > Mobile Service (PearOS) or Connections > SIM manager (Nova UI), or use a SIM card item
--     (goes into the phone in your hand; if that phone already has a SIM they swap and the old one goes to your inventory).
--   * Existing characters lose nothing: the first time they are seen with a phone their number becomes a SIM inside it
--     (extra eSIM lines become SIM cards in the inventory).
--   * 1.3.0 - LOST / STOLEN number (recover): a number belongs to the character it was issued to (shop, migration, starter
--     SIM, eSIM card, /givesim). When that card is not in the player's hands any more (phone stolen, lost, destroyed), Settings >
--     Mobile Service (PearOS) / SIM manager (Nova UI) shows "Recover my number": the carrier cancels the old card for good and
--     hands out a new SIM card with the SAME number (messages, calls and - with contactsOnSim - the contacts come back), put
--     straight into the phone in hand when its tray is empty. Whoever still has the old card loses the number at once and
--     inserting it says "cancelled by the carrier". Admins: /givesim [id] [number] re-issues a number that belongs to that
--     character for free. Server event apex_phone:simRecovered (src, number, oldIccid, newIccid); export RecoverSimCard(src, number).
--   * 1.3.0 - contactsOnSim: the CONTACTS live on the card too (apex_phone_contacts owner "sim:<number>"): whoever has the
--     card in a phone sees them, and they survive a lost phone and a re-issued card. The first time a card is used with this on,
--     the contacts of the account it belongs to are COPIED onto it (the phone keeps its own copy). false = contacts stay with
--     the phone (the device owner's account), exactly as in 1.2.0.
-- Needs ox_inventory (any framework) or qb-inventory / ps-inventory / lj-inventory (QBCore), and Config.RequireItem = true.
-- Without them it switches itself off with a console warning. Off = everything exactly as before.
-- Inventory: add 'sim_card' from inventory_items.lua (image inventory_images/sim_card.png). Admin: /givesim [id] [number].
-- The admin panel (/phoneadmin > Phone > Physical SIM) can switch it on or off: restart apex_phone afterwards.
-- ------------------------------------------------------------
Config.PhysicalSim = {
    enabled      = true,      -- true = physical SIM cards (see above)
    item         = 'sim_card', -- the SIM card item
    contactsOnSim = true,      -- true = contacts are stored on the SIM card (see above) | false = contacts stay with the phone
    recover      = {           -- carrier re-issue of a lost / stolen number (see above)
        enabled  = true,       --   false = no "Recover my number" (admins can still /givesim [id] [number])
        price    = 100,        --   bank money charged for a new card with the same number (0 = free)
        free     = false,      --   true = never charge, whatever the price
        blockOld = true,       --   true = the old card is cancelled for good (table apex_phone_sims_blocked) | false = it just stops working
    },
    starterSim   = 'auto',     -- phone accounts created while this is on: 'auto' = their new number is a SIM already inside the
                               -- phone | 'item' = a SIM card in the inventory | 'none' = no number until they get a SIM
    esimCards    = 'slot',     -- eSIM QR cards (Config.Sim.item): 'slot' = activating one puts a SIM with that number in the
                               -- empty tray | 'off' = eSIM cards cannot be activated
    carrier      = nil,        -- carrier name shown in Settings (nil = Config.Sim.carrier)
    cardLabel    = 'SIM Card', -- item label shown by the inventory for a SIM card
    cardDescription = 'Number: %s', -- item description (tooltip) for a SIM card, %s = the number
    shopProduct  = true,       -- add a "SIM card" product to the phone shop (shown only if the item exists in the inventory)
    shopPrice    = 50,
    giveCommand  = 'givesim',  -- admin/console command: /givesim [id] [number] (nil = no command)
    checkSeconds = 5,          -- how often the server re-checks which phone each player carries (phones that changed hands)
    debug        = false,      -- true = console lines (inserts, ejects, migrations, number changes)
}
if Config.PhysicalSim.enabled == true and Config.PhysicalSim.shopProduct ~= false and type(Config.Shop) == 'table' and type(Config.Shop.products) == 'table' then
    Config.Shop.products[#Config.Shop.products + 1] = {
        -- (texts in Portuguese like the other products: they are translation keys, the shop NUI translates them)
        id = 'sim_card', name = 'Cartão SIM Apex Mobile', brand = 'Apex Mobile', os = 'SIM', categories = { 'acessorios' },  -- EN: Apex Mobile SIM Card
        price = Config.PhysicalSim.shopPrice or 50,
        tagline = 'Um número novo num cartão. Mete-o em qualquer telemóvel.',  -- EN: A new number on a card. Put it in any phone.
        features = { 'Um número de telefone novo', 'Serve em todos os PearPhone e NOVA', 'Muda-o de telemóvel e o número vai com ele' },  -- EN: A new phone number | Fits every PearPhone and NOVA | Move it to another phone and the number goes with it
        specs = { network = '5G' },
        usage = 'Usa o cartão no inventário para o meteres no telemóvel que tens na mão.',  -- EN: Use the card from your inventory to put it in the phone in your hand.
        viewer = { kind = 'card', yaw = -0.45, pitch = 0.18 },
        variants = {
            { item = Config.PhysicalSim.item or 'sim_card', color = 'Apex Mobile', swatch = '#1F5EFF', image = 'nui://apex_phone/inventory_images/sim_card.png' },
        },
    }
end
-- <<< PSIM

-- >>> CSHARE
-- ------------------------------------------------------------
-- CONTACT SHARING (server/contactshare.lua, client/contactshare.lua, html/js/apps/contactshare.js)
-- Hand your contact card to the people next to you:
--   * Phone: Contacts > "Share my contact" (also on My Card) and "Share" on any contact's page list the people within
--     `distance` metres who can receive cards. The other person sees a preview (name, number, photo) and taps Accept
--     (saved in their Contacts; an existing contact with the same number is merged) or Decline. Requests expire after
--     `offerSeconds`.
--   * Two people sharing their own card with each other at the same time swap both cards at once.
--   * ox_target (or qb-target when ox_target is not running): "Share contact" and "Ask for contact" on other players
--     within `targetDistance`. Only shown to players with a usable phone. No target resource = no option, the phone
--     side keeps working.
--   * The server builds every card: your character name, the CURRENT number of the phone in your hand (eSIM line,
--     physical SIM...) and your account colour/photo. No SIM = nothing to share (clear message).
--   * Receivers choose who may send them cards in Settings > AirShare / Quick Share > "Contact cards":
--     Everyone / Contacts only / Off. Players who never changed it get `receive`. Blocked numbers count as Off.
-- Server event for other resources: apex_phone:contactShared (fromSrc, toSrc, kind, number).
-- Server exports: exports.apex_phone:ShareContact(src, target) / exports.apex_phone:RequestContact(src, target).
-- ------------------------------------------------------------
Config.ContactShare = {
    enabled         = true,        -- false = no contact sharing at all (phone and target)
    distance        = 3.0,         -- metres: who shows up in the phone's share sheet (same routing bucket only)
    target          = true,        -- ox_target / qb-target options on other players
    targetDistance  = 2.0,         -- metres for the target options
    askForContact   = true,        -- also offer "Ask for contact" on players (they accept and their card comes back)
    cooldownSeconds = 5,           -- seconds before the same person can send to the same target again
    offerSeconds    = 30,          -- a request not answered by then expires
    requirePhoneOut = false,       -- true = the sender must have the phone open (also for the target options)
    receive         = 'everyone',  -- default for players that never changed it: 'everyone' | 'contacts' | 'off'
    sharePhoto      = true,        -- send the account photo with "my card" (preview only; the saved contact keeps the colour)
}
-- <<< CSHARE
