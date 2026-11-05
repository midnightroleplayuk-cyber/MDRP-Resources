Config = {}
Config.Debug = false
Config.SearchRadius = 35.0
Config.DrawDistance = 35.0
Config.Models = {
    [`des_tvsmash_start`] = { target = "tvscreen", scale = 0.085, offset = vector3(-1.02, -0.055, 1.04) },
    [`prop_flatscreen_overlay`] = { target = "tvscreen", scale = 0.085, offset = vector3(-1.02, -0.055, 1.04) },
    [`prop_laptop_lester2`] = { target = "tvscreen", scale = 0.085, offset = vector3(-1.02, -0.055, 1.04) },
    [`prop_monitor_02`] = { target = "tvscreen", scale = 0.085, offset = vector3(-1.02, -0.055, 1.04) },
    [`prop_trev_tv_01`] = { target = "tvscreen", scale = 0.085, offset = vector3(-1.02, -0.055, 1.04) },
    [`prop_tv_02`] = { target = "tvscreen", scale = 0.085, offset = vector3(-1.02, -0.055, 1.04) },
    [`prop_tv_03_overlay`] = { target = "tvscreen", scale = 0.085, offset = vector3(-1.02, -0.055, 1.04) },
    [`prop_tv_06`] = { target = "tvscreen", scale = 0.085, offset = vector3(-1.02, -0.055, 1.04) },
    [`prop_tv_flat_01`] = { target = "tvscreen", scale = 0.085, offset = vector3(-1.02, -0.055, 1.04) },
    [`prop_tv_flat_01_screen`] = { target = "tvscreen", scale = 0.085, offset = vector3(-1.02, -0.055, 1.04) },
    [`prop_tv_flat_02b`] = { target = "tvscreen", scale = 0.085, offset = vector3(-1.02, -0.055, 1.04) },
    [`prop_tv_flat_03`] = { target = "tvscreen", scale = 0.085, offset = vector3(-1.02, -0.055, 1.04) },
    [`prop_tv_flat_03b`] = { target = "tvscreen", scale = 0.085, offset = vector3(-1.02, -0.055, 1.04) },
    [`prop_tv_flat_michael`] = { target = "tvscreen", scale = 0.085, offset = vector3(-1.02, -0.055, 1.04) },
    [`prop_monitor_w_large`] = { target = "tvscreen", scale = 0.085, offset = vector3(-1.02, -0.055, 1.04) },
    [`prop_tv_03`] = { target = "tvscreen", scale = 0.085, offset = vector3(-1.02, -0.055, 1.04) },
    [`prop_tv_flat_02`] = { target = "tvscreen", scale = 0.085, offset = vector3(-1.02, -0.055, 1.04) },
}

-- Only players this close render a TV (metres). Others do not create a DUI.
Config.PerformanceRadius = 30.0
Config.InteractDistance = 2.5
Config.ScanInterval = 1200
Config.DuiWidth = 1280
Config.DuiHeight = 720
Config.DefaultVolume = 35
Config.MaxUrlLength = 1800
Config.AllowWebsites = true -- WARNING: arbitrary websites are untrusted content; allow only trusted domains in production.
Config.AllowedWebsiteHosts = {} -- empty = all HTTPS hosts; e.g. {'example.com'}

-- Blocked website domains (also blocks all subdomains). Add/remove domains as needed.
-- Applies to all TV URL types and Google toolbar direct navigation.
Config.BlockedWebsiteHosts = {
    -- Adult sites
    'pornhub.com', 'xvideos.com', 'xnxx.com', 'xhamster.com',
    'redtube.com', 'youporn.com', 'tube8.com', 'spankbang.com',
    'eporner.com', 'tnaflix.com', 'thumbzilla.com', 'beeg.com',
    'brazzers.com', 'bangbros.com', 'realitykings.com', 'naughtyamerica.com',
    'onlyfans.com', 'fansly.com', 'manyvids.com', 'chaturbate.com',
    'stripchat.com', 'bongacams.com', 'livejasmin.com', 'cam4.com',
    'myfreecams.com', 'flirt4free.com', 'jerkmate.com', 'adultfriendfinder.com',
    'literotica.com', 'nhentai.net', 'rule34.xxx', 'e621.net',
    -- Gambling, betting, casinos
    'bet365.com', 'betfair.com', 'paddypower.com', 'williamhill.com',
    'ladbrokes.com', 'coral.co.uk', 'skybet.com', 'betfred.com',
    'unibet.com', '888casino.com', '888sport.com', '888poker.com',
    'pokerstars.com', 'partypoker.com', 'bwin.com', 'betway.com',
    'draftkings.com', 'fanduel.com', 'stake.com', 'stake.us',
    'roobet.com', 'rollbit.com', 'bc.game', 'cloudbet.com',
    '1xbet.com', '22bet.com', 'betwinner.com', 'sportsbet.io',
    'gamdom.com', 'duelbits.com', 'jackpotcitycasino.com',
    'casumo.com', 'leovegas.com', 'mrgreen.com', 'grosvenorcasinos.com',
    'virgingames.com', 'tombola.co.uk', 'bingo.com', 'betmgm.com',
    'caesars.com', 'betrivers.com', 'pointsbet.com', 'betonline.ag',
}

Config.Debug = false

-- Positional audio: at/below FullVolumeDistance use selected volume; fade to zero at PerformanceRadius.
Config.FullVolumeDistance = 3.0
Config.AudioUpdateInterval = 250 -- milliseconds
Config.AudioFadeExponent = 1.5 -- 1=linear, >1 fades more strongly with distance

-- Twitch is served by the free Cloudflare Pages HTTPS site.
-- The Twitch iframe on that site uses its actual pages.dev hostname as parent.
Config.TwitchPlayerUrl = 'https://hf1-tv-twitch.pages.dev'

-- Placeable TV system: one ox_inventory item, selectable models.
Config.TelevisionItem = 'tv'
Config.PlacementShowHelp = true -- show placement controls while placing
Config.PlacementShowDiagnostics = false -- amber position marker and diagnostic logs
Config.PlacementMaxDistance = 10.0
Config.PlacementMinSpacing = 1.2
Config.WallOffset = 0.08 -- model pivot clearance; tune for your props
-- Floor/stand TVs need a floor raycast; flat screens require a vertical wall.
-- Model pivots vary in GTA; test placement and adjust wall offset if needed.
Config.PlaceableModels = {
    prop_tv_flat_01 = {label='Wall TV - Flat 01',wall=true},
    prop_tv_flat_02 = {label='Wall TV - Flat 02',wall=true},
    prop_tv_flat_02b = {label='Wall TV - Flat 02B',wall=true},
    prop_tv_flat_03 = {label='Wall TV - Flat 03',wall=true},
    prop_tv_flat_03b = {label='Wall TV - Flat 03B',wall=true},
    prop_tv_flat_michael = {label='Wall TV - Michael',wall=true},
    prop_tv_02 = {label='Standing TV - 02',wall=false},
    prop_tv_03 = {label='Standing TV - 03',wall=false},
    prop_tv_06 = {label='Standing TV - 06',wall=false},
    prop_trev_tv_01 = {label='Standing TV - Trevor',wall=false},
    des_tvsmash_start = {label='TV - Smash Start (experimental)',wall=false},
    prop_flatscreen_overlay = {label='Flat Screen Overlay (experimental)',wall=true},
    prop_laptop_lester2 = {label='Lester Laptop (experimental)',wall=false},
    prop_monitor_02 = {label='Monitor 02 (experimental)',wall=false},
    prop_tv_03_overlay = {label='TV 03 Overlay (experimental)',wall=false},
    prop_tv_flat_01_screen = {label='Flat 01 Screen (experimental)',wall=true},
    prop_monitor_w_large = {label='Large Monitor (experimental)',wall=false},
}
