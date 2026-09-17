--[[
    Apex Fishing — Shared Config
    ────────────────────────────────────────────────────────────
    Ocean-teal palette (intentionally distinct from apex_banking
    which is blue #1F5EFF). All public settings live here.
]]

Config = {}

-- ─── General ──────────────────────────────────────────────
Config.debug        = false
Config.locale       = 'en'   -- 'en' | 'pt' | 'es' | 'fr' | 'de'
Config.resourceName = GetCurrentResourceName()

-- ─── Framework (auto-detected: ESX, QB, QBox) ─────────────
Config.framework = 'auto'    -- 'auto' | 'esx' | 'qb' | 'qbx'

-- ═══════════════════════════════════════════════════════════
-- FEATURE TOGGLES
-- ═══════════════════════════════════════════════════════════
-- Disable any subsystem you don't want. Each toggle is honoured
-- in both the server logic and the NUI render — disabling here
-- removes the corresponding tab/blip/handler entirely.
Config.features = {
    -- Core panel tabs (hides nav button + skips render)
    enableOverview          = true,
    enableGuide             = true,
    enableShop              = true,
    enableSell              = true,
    enableBoats             = true,
    enableRanking           = true,
    enableUpgrades          = true,
    enableSettings          = true,

    -- World features
    enableNpc               = true,   -- spawn the fisherman ped + blip
    enable3DMarker          = true,   -- world marker on the NPC
    enableDeepSeaBlips      = true,   -- map blips for deep-sea zones
    enableBoatReturnMarker  = true,   -- 3D marker over the boat return dock

    -- Gameplay
    enableMinigame          = true,   -- catch minigame; false = auto-success
    enableRodBreakage       = true,   -- rods can snap after catches
    enableJunkDrops         = true,   -- allow junk / non-fish catches
    enableConditionsTracker = true,   -- live coast/deep zone detection
    enableKeepRelease       = true,   -- catch modal Keep/Release choice
    enableCustomCastAnim    = true,   -- play the wind-up + release animation
    enableSyncedSFX         = true,   -- positional SFX (bite, cash, etc.)
    enableRodPropAttach     = true,   -- attach the rod prop to the player
    enableCollection        = true,   -- Guide "Pokédex": undiscovered fish show
                                      -- as locked "???" silhouettes + a X/Y
                                      -- counter. false = all species shown.

    -- Economy / progression
    enableLeaderboard       = true,   -- server-wide MySQL leaderboard
    enableXPSpending        = true,   -- allow XP to be spent on upgrades
    enableBoatDeposit       = true,   -- require & refund boat deposits

    -- Junk drop variations (disable specific ones)
    enableMoneyBriefcase    = true,   -- sunken briefcase with random cash
    enableWeaponJunk        = true,   -- rusty weapon drops

    -- Notifications
    notifyOnLevelUp         = true,
    notifyOnBoatRented      = true,
    notifyOnRodBroke        = true,
    notifyOnSold            = true,

    -- Logging
    enablePrints            = false,  -- verbose server prints (debug only)
}

-- ─── Interaction ──────────────────────────────────────────
Config.textUIKey      = 38       -- E
Config.textUIDistance = 2.0

-- ─── UI Theme ────────────────────────────────────────────
-- `brand` and `bg` are the two master colours. Everything else in
-- the NUI (every surface, border and shadow) is DERIVED from `bg`
-- at runtime, so changing `bg` retints the whole interface. Both
-- are also player-overridable from the in-panel Settings (presets
-- + a custom colour picker) and persist per character.
Config.theme = {
    brand     = '#111111',   -- accent colour (buttons, highlights, links)
    brandDark = '#3a063b',
    accent    = '#ff5cce',
    bg        = '#192124',   -- changed for testing - master background — deep ocean ink (premium default)
    bgCard    = '#1A1A1B',   -- (legacy; surfaces are now derived from `bg`)
    bgRaised  = '#0000ff',
    bgSidebar = '#131314',
    border    = '#1F1F21',
    borderHi  = '#2A2A2D',
    text      = '#F4F4F5',
    textSub   = 'rgba(244,244,245,.55)',
    info      = '#4E9CE5',
    success   = '#34C77B',
    warning   = '#E5A93C',
    error     = '#E5564B',
}

-- ─── Player profile (sidebar card) ───────────────────────
-- The fishing panel sidebar shows the player's RP name, fishing
-- level and live cash. The avatar defaults to a generated
-- initials disc (always works, looks clean). If your server keeps
-- a per-character photo, point `imageUrl` at it: `%s` is replaced
-- by the player's identifier/citizenid at request time. The disc
-- is used as an automatic fallback when the image fails to load.
--
--   Note: GTA/FiveM has no native "RP character photo" that a web
--   panel can read directly, so a real photo requires your own
--   image host (e.g. a screenshot-basic + upload pipeline). When
--   `imageUrl` is nil the initials disc is shown.
Config.avatar = {
    enable     = true,
    -- Live in-game character headshot (same technique ox_inventory uses:
    -- RegisterPedheadshot + the FiveM `nui-img` texture scheme). Shows the
    -- player's actual RP character face. Falls back to the initials disc
    -- while the headshot renders or if it fails.
    useMugshot = true,
    -- Optional external per-character photo host. When set it OVERRIDES the
    -- live mugshot. `%s` is replaced by the player identifier/citizenid.
    imageUrl   = nil,   -- e.g. 'https://cdn.myserver.com/chars/%s.png'
    title      = 'Marina Member',   -- subtitle under the player name
}

-- ─── Currency ─────────────────────────────────────────────
Config.currency = { symbol = '£', position = 'before' }

-- ─── Item image source (NUI) ─────────────────────────────
-- Browser-side prefix used to render real item PNGs in the UI
-- (catch modal orb, guide cards, shop, sell list, rod list).
-- Defaults to ox_inventory's web/images directory.
Config.itemImageBase = 'nui://ox_inventory/web/images/'

-- ─── Notifications ────────────────────────────────────────
Config.notify = {
    title    = 'Fishing',
    duration = 4500,
}

-- ─── Required items ───────────────────────────────────────
-- Bait is consumed every cast. Rods are tiered and the player
-- automatically uses their best rod; better rods unlock rarer fish.
Config.baitItem    = 'fishing_bait'
Config.baitCostAtShop = 12         -- $ per bait at the shop

-- ─── Rod tiers (4 levels — model shown on player matches tier) ──
-- requiredLevel = ranking level required to PURCHASE this rod.
-- maxRarity     = the highest rarity tier the rod can ever hook.
-- catchBonus    = additive bonus to the success roll (0..1).
Config.rods = {
    { id = 'fishing_rod_basic',   label = 'Basic Rod',     price =   500, requiredLevel = 0,  maxRarity = 'rare',     catchBonus = 0.00, prop = 'prop_fishing_rod_01' },
    { id = 'fishing_rod_pro',     label = 'Pro Rod',       price =   2500, requiredLevel = 8,  maxRarity = 'epic',     catchBonus = 0.06, prop = 'prop_fishing_rod_01' },
    { id = 'fishing_rod_carbon',  label = 'Carbon Rod',    price =  8000, requiredLevel = 18, maxRarity = 'legendary',catchBonus = 0.12, prop = 'prop_fishing_rod_01' },
    { id = 'fishing_rod_master',  label = 'Master Rod',    price =  15000, requiredLevel = 30, maxRarity = 'mythic',   catchBonus = 0.20, prop = 'prop_fishing_rod_01' },
}

-- Default rod given to new players (set to nil to disable)
Config.starterRod = nil

-- ─── Upgrades ────────────────────────────────────────────
-- Spend XP for permanent passive boosts. Your TOTAL xp keeps
-- counting for level + leaderboard; only a separate `xp_spent`
-- counter ticks up. Available XP for upgrades = xp - xp_spent.
--
-- Each upgrade has a fixed number of levels with a cost table
-- and a value table (effect strength at that level). The `display`
-- field tells the UI how to format the value next to the cost.
Config.upgrades = {
    {
        id          = 'catch_power',
        label       = 'Catch Power',
        description = 'Higher weights on rare+ rolls. Bigger fish bite the hook more often.',
        icon        = 'fa-star',
        maxLevel    = 5,
        costs       = { 80, 200, 500, 1200, 3000 },
        values      = { 0.04, 0.09, 0.16, 0.25, 0.40 },
        display     = 'percent',     -- "+4%", "+9%", ...
    },
    {
        id          = 'line_strength',
        label       = 'Line Strength',
        description = 'Reduces the chance your rod snaps after a catch.',
        icon        = 'fa-shield-halved',
        maxLevel    = 5,
        costs       = { 60, 160, 400, 1000, 2400 },
        values      = { 0.20, 0.40, 0.60, 0.80, 1.00 },
        display     = 'reduction',   -- "−20%", "−40%", ...
    },
    {
        id          = 'bait_saver',
        label       = 'Bait Saver',
        description = 'Chance to keep your bait instead of consuming it on a cast.',
        icon        = 'fa-leaf',
        maxLevel    = 5,
        costs       = { 70, 180, 450, 1100, 2700 },
        values      = { 0.08, 0.18, 0.30, 0.42, 0.55 },
        display     = 'percent',
    },
    {
        id          = 'lucky_hook',
        label       = 'Lucky Hook',
        description = 'Fewer junk drops. The line snags less trash from the seabed.',
        icon        = 'fa-clover',
        maxLevel    = 5,
        costs       = { 90, 220, 550, 1300, 3200 },
        values      = { 0.15, 0.30, 0.50, 0.70, 0.90 },
        display     = 'reduction',
    },
    {
        id          = 'big_catch',
        label       = 'Big Catch',
        description = 'Sell your fish for a higher price at the marina.',
        icon        = 'fa-sack-dollar',
        maxLevel    = 5,
        costs       = { 100, 250, 600, 1500, 3600 },
        values      = { 0.05, 0.10, 0.18, 0.28, 0.40 },
        display     = 'percent',
    },
}

-- ─── Ranking / progression ───────────────────────────────
-- XP grows per catch (rarer fish = more XP). Levels are derived
-- from total XP using a soft polynomial curve.
Config.ranking = {
    xpPerLevel    = 250,   -- baseline; each level needs (level^1.35)*xpPerLevel
    curveExp      = 1.35,
    maxLevel      = 60,
}

-- ─── Fish weight / trophy system ─────────────────────────
-- Every fish is assigned a weight rolled within its rarity band
-- (biased toward the lighter end, so true monsters stay rare). The
-- weight shows in the catch modal, is tracked as a per-species
-- personal best (the Records ✓ in the Guide collection) and pays a
-- small trophy cash bonus on Keep that scales with how big it is.
Config.weightEnabled = true
Config.weightUnit    = 'kg'
Config.weightByRarity = {
    junk      = { 0.1,   3.0 },
    common    = { 0.2,   2.5 },
    uncommon  = { 0.5,   6.0 },
    rare      = { 2.0,   28.0 },
    epic      = { 8.0,   70.0 },
    legendary = { 30.0,  220.0 },
    mythic    = { 120.0, 900.0 },
}
-- Max trophy bonus, as a fraction of the fish's base sell price,
-- paid for a maximum-weight specimen (scales linearly with weight).
-- Set to 0 to disable the cash bonus entirely.
Config.weightTrophyBonusPct = 0.20

-- ─── Weekly tournament ───────────────────────────────────
-- A rolling 7-day XP competition shown in the Ranking tab with live
-- standings + a countdown. Resets automatically each week. Reward
-- payout is left to the server owner: listen to the server event
-- `apex_fishing:tournamentReset` (fired with the final top list) to
-- wire any prize you like.
Config.tournament = {
    enabled  = true,
    topCount = 5,
}

-- ─── Rod breakage ────────────────────────────────────────
Config.breakRodAfterFails    = true
Config.failAttemptsToBreak   = 6     -- consecutive fails on a single rod
Config.breakChancePerCatch   = 0.005 -- random per-catch wear (0.5%)

-- ─── Minigame difficulty (custom NUI minigame) ───────────
-- The minigame is a "track the fish" bar: Q/E move the zone and
-- the player has to keep the zone over the autonomously-swimming
-- fish. Per-rarity profiles below scale each parameter so that
-- a Common bites is a 0.4-second catch while a Mythic is a real
-- fight.
--
--   zoneWidth      = how wide the catch zone is (% of bar). Lower = harder
--   fishSpeed      = sine frequency of the fish's swim. Higher = faster
--   fillRate       = how fast the meter fills while fish is in zone (per ms)
--   drainRate      = how fast it drains while out of zone (per ms)
--   catchThreshold = % of meter required before SPACE will trigger a catch
--   durationMs     = total time the player has before the fish escapes
--
-- Required time-in-zone (with no drain) ≈ catchThreshold / fillRate ms.
-- Common: 200 ms · Mythic: ~1280 ms (and that's without losing meter
-- when the cursor drifts off).
Config.minigameByRarity = {
    junk      = { zoneWidth = 30, fishSpeed = 0.6, fillRate = 0.0025, drainRate = 0.0003, catchThreshold = 0.30, durationMs = 14000 },
    common    = { zoneWidth = 28, fishSpeed = 0.8, fillRate = 0.0020, drainRate = 0.0004, catchThreshold = 0.40, durationMs = 15000 },
    uncommon  = { zoneWidth = 25, fishSpeed = 1.0, fillRate = 0.0016, drainRate = 0.0006, catchThreshold = 0.50, durationMs = 16000 },
    rare      = { zoneWidth = 22, fishSpeed = 1.3, fillRate = 0.0012, drainRate = 0.0008, catchThreshold = 0.60, durationMs = 18000 },
    epic      = { zoneWidth = 18, fishSpeed = 1.6, fillRate = 0.0010, drainRate = 0.0010, catchThreshold = 0.70, durationMs = 20000 },
    legendary = { zoneWidth = 14, fishSpeed = 1.9, fillRate = 0.0008, drainRate = 0.0012, catchThreshold = 0.80, durationMs = 22000 },
    mythic    = { zoneWidth = 11, fishSpeed = 2.3, fillRate = 0.0007, drainRate = 0.0015, catchThreshold = 0.90, durationMs = 25000 },
}

-- ─── Minigame: global "perfect catch" threshold ──────────
-- Per-rarity difficulty lives in Config.minigameByRarity (above).
-- This single shared value is the meter fill (0..1) that counts as a
-- PERFECT catch — a perfect catch grants +25% bonus XP. 0.90 = the
-- player must have filled the meter to 90%+ when they lock the catch.
Config.minigame = {
    perfectThreshold = 0.90,
}

-- ─── Bite timing ─────────────────────────────────────────
-- Milliseconds between casting and the fish biting. Re-rolled at
-- RANDOM on every cast (never a fixed value) — higher-tier rods
-- shave a little off the wait. Widen this range for more variety.
Config.biteDelayMin = 3500
Config.biteDelayMax = 12000

-- ─── Catch table ─────────────────────────────────────────
-- Rarities (lowest to highest)
Config.rarities = {
    junk      = { label = 'Junk',      color = '#7C7C82', xp = 5  },
    common    = { label = 'Common',    color = '#94A3B8', xp = 8  },
    uncommon  = { label = 'Uncommon',  color = '#22C55E', xp = 14 },
    rare      = { label = 'Rare',      color = '#06B6D4', xp = 28 },
    epic      = { label = 'Epic',      color = '#A78BFA', xp = 55 },
    legendary = { label = 'Legendary', color = '#F59E0B', xp = 120 },
    mythic    = { label = 'Mythic',    color = '#EC4899', xp = 320 },
}

-- Each fish: item name (server gives it), label (UI), sell price,
-- rarity, weight (relative probability inside its rarity bucket),
-- zone ('coast' = shallow shore-fishing, 'deep' = open ocean / boat
-- only, 'any' = available in both).
Config.fish = {
    -- ══ COASTAL FISH (shore + shallow water) ══════════════════
    -- ── COMMON ──
    { item = 'fish_sardine',   label = 'Sardine',       rarity = 'common',    sell =   80, weight = 30, zone = 'coast' },
    { item = 'fish_anchovy',   label = 'Anchovy',       rarity = 'common',    sell =   95, weight = 28, zone = 'coast' },
    { item = 'fish_mackerel',  label = 'Mackerel',      rarity = 'common',    sell =  130, weight = 22, zone = 'coast' },
    { item = 'fish_herring',   label = 'Herring',       rarity = 'common',    sell =  140, weight = 20, zone = 'coast' },
    -- ── UNCOMMON ──
    { item = 'fish_bass',      label = 'Sea Bass',      rarity = 'uncommon',  sell =  280, weight = 25, zone = 'coast' },
    { item = 'fish_trout',     label = 'Trout',         rarity = 'uncommon',  sell =  310, weight = 23, zone = 'coast' },
    { item = 'fish_salmon',    label = 'Salmon',        rarity = 'uncommon',  sell =  380, weight = 18, zone = 'any'   },
    -- ── RARE ──
    { item = 'fish_grouper',   label = 'Grouper',       rarity = 'rare',      sell = 1100, weight = 18, zone = 'any'   },

    -- ══ DEEP-SEA FISH (boat only — open ocean) ════════════════
    -- ── RARE ──
    { item = 'fish_tuna',      label = 'Bluefin Tuna',  rarity = 'rare',      sell =  920, weight = 22, zone = 'deep'  },
    { item = 'fish_swordfish', label = 'Swordfish',     rarity = 'rare',      sell = 1450, weight = 14, zone = 'deep'  },
    -- ── EPIC ──
    { item = 'fish_marlin',    label = 'Blue Marlin',   rarity = 'epic',      sell = 3200, weight = 18, zone = 'deep'  },
    { item = 'fish_mahi',      label = 'Mahi-Mahi',     rarity = 'epic',      sell = 3800, weight = 14, zone = 'deep'  },
    -- ── LEGENDARY ──
    { item = 'fish_shark',     label = 'Tiger Shark',   rarity = 'legendary', sell = 9500, weight = 14, zone = 'any'   },
    { item = 'fish_giantsquid',label = 'Giant Squid',   rarity = 'legendary', sell =11500, weight = 10, zone = 'deep'  },
    -- ── MYTHIC ──
    { item = 'fish_leviathan', label = 'Leviathan',     rarity = 'mythic',    sell =28000, weight = 6,  zone = 'deep'  },
    { item = 'fish_kraken',    label = 'Young Kraken',  rarity = 'mythic',    sell =42000, weight = 3,  zone = 'deep'  },
}

-- ─── Fishing zones ───────────────────────────────────────
-- Detected by probing the seabed depth below the cast point.
-- A shoreline / pier rod-cast is "coast"; once you're far enough
-- from land (typically in a boat) it becomes "deep".
Config.zones = {
    coast = {
        label    = 'Coastal',
        icon     = 'water',
        -- Depth threshold (metres). Anything shallower than this
        -- counts as coast; anything deeper counts as deep sea.
        depthMax = 6.0,
        -- Allowed fish: coast + any. Probability stays at base.
        rarityBoost = { common = 1.0, uncommon = 1.0, rare = 0.8, epic = 0.4, legendary = 0.2, mythic = 0.05 },
    },
    deep = {
        label    = 'Deep Sea',
        icon     = 'sailboat',
        depthMax = 9999.0,
        -- Deep sea heavily favours the big game.
        rarityBoost = { common = 0.6, uncommon = 0.9, rare = 1.3, epic = 1.6, legendary = 2.0, mythic = 2.5 },
    },
}


-- ─── Junk table (also pulled when "junk" rarity rolls) ──
-- Configurable: add a gun, a suitcase, a shoe, whatever. Items
-- listed as `money` are credited as cash. Items with `give` are
-- inventory items.
Config.junk = {
    { item = 'old_shoe',         label = 'Old Shoe',         sell =   10, weight = 40 },
    { item = 'tin_can',          label = 'Rusty Tin Can',    sell =    5, weight = 35 },
    { item = 'plastic_bottle',   label = 'Plastic Bottle',   sell =    3, weight = 30 },
    { item = 'seaweed',          label = 'Tangled Seaweed',  sell =   15, weight = 25 },
    -- Special rare drops in the junk pool
    { item = 'money_briefcase',  label = 'Sunken Briefcase', money = { min = 2500, max = 9000 }, weight = 6  },
    { item = 'weapon_pistol',    label = 'Rusty Pistol',     weapon = true,  weight = 2  },
    { item = 'rolex_watch',      label = 'Antique Watch',    sell = 5500, weight = 3  },
}

-- ─── Junk roll chance ────────────────────────────────────
-- Even when the player would normally catch a fish, this is the
-- chance the catch becomes "junk" instead. Higher when no bait
-- was used (handled in server logic).
Config.junkChance = 0.10

-- ─── Rarity roll table (base, per attempt) ───────────────
-- Probabilities are renormalised against what the equipped rod
-- can pull. Anything above the rod's max rarity is clamped down.
Config.rarityRolls = {
    common    = 0.62,
    uncommon  = 0.22,
    rare      = 0.10,
    epic      = 0.045,
    legendary = 0.012,
    mythic    = 0.003,
}

-- ─── Boat rental ─────────────────────────────────────────
-- Only ONE active rental is allowed at a time — the player must
-- return (at the dock) or recover (lost-boat option in the panel)
-- before renting again.
--
-- boatLostRefundPct = fraction of the deposit refunded when the
-- player uses the "lost boat" recovery in the panel (boat sank,
-- got stuck or despawned). 1.0 = full deposit back, 0.5 = half, etc.
Config.boatLostRefundPct = 1.0

Config.boats = {
    { model = 'dinghy',   label = 'Dinghy',           price =  500, deposit = 1500 },
    { model = 'jetmax',   label = 'Jetmax',           price = 1800, deposit = 4500 },
    { model = 'speeder',  label = 'Speeder',          price = 1200, deposit = 3500 },
    { model = 'tropic',   label = 'Tropic',           price = 1500, deposit = 4000 },
    { model = 'marquis',  label = 'Marquis (Yacht)',  price = 5500, deposit =15000, requiredLevel = 20 },
}

-- ─── Deep-sea fishing spot ───────────────────────────────
-- A marked location in the open ocean where the player is
-- guaranteed to fish in the 'deep' zone (legendary + mythic
-- species). Shown on the map as a fish blip with a radius
-- overlay. Coordinates default to the open Pacific NW of
-- Paleto Cove — boat-reachable from the pier in ~45 seconds.
Config.deepSeaSpots = {
    {
        coords = vec3(-2688.290039, -1952.650513, 2.994141),
        radius = 220.0,
        blip   = {
            sprite      = 68,    -- fish sprite
            color       = 38,    -- light blue
            scale       = 0.9,
            label       = 'Deep-Sea Fishing',
            showRadius  = true,
            radiusColor = 38,
            radiusAlpha = 80,
        },
    },
}

-- ─── NPC location ────────────────────────────────────────
-- One NPC. Sells rods, sells fish, opens panel, rents boats.
-- Coords are at the Source dock pier (Paleto Cove). Override
-- if you want it elsewhere.
Config.npc = {
    model    = 'a_m_m_salton_01',
    coords   = vec4(-1862.795654, -1234.536255, 8.605103, 53.858269),  -- Paleto Cove pier
    marker   = vec3(-1862.795654, -1234.536255, 8.605103),
    blip     = { sprite = 68, color = 75, scale = 0.85, label = 'Fisherman' },
    boatSpawn  = vec4(-1795.054932, -1233.389038, 0.887939, 200.0),
    boatReturn = vec3(-1795.054932, -1233.389038, 0.887939),
}

-- ─── Notification strings ────────────────────────────────
Config.strings = {
    alreadyFishing    = 'You are already fishing.',
    notNearWater      = 'You need to be facing water to fish.',
    noBait            = 'You need fishing bait to cast a line.',
    noRod             = 'You need a fishing rod first — visit the shop.',
    rodBroke          = 'Your fishing rod snapped.',
    caught            = 'You caught %s!',
    junkCaught        = 'You hooked %s.',
    nothingCaught     = 'The line came back empty.',
    perfectCatch      = 'Perfect catch! +25%% bonus XP',
    boatRented        = 'Boat rented — return it to the dock.',
    boatReturned      = 'Boat returned. Deposit refunded.',
    notEnoughMoney    = 'You cannot afford that.',
    purchased         = 'Purchased: %s',
    sold              = 'Sold %s × %d for %s',
    sellNoFish        = 'You have no fish to sell.',
    rankUp            = 'Level up! You are now level %d',
    boatTooLow        = 'You need fishing level %d to rent this boat.',
}
