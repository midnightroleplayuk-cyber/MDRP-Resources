--[[
    Apex Restaurant — Shared Config
    ────────────────────────────────────────────────────────────
    All user-facing settings. Restaurant *zones* live in
    data/restaurants.json (managed by the in-game node editor).
]]

Config = Config or {}

-- ─── General ──────────────────────────────────────────────
Config.debug         = false
Config.locale        = 'en'
Config.resourceName  = GetCurrentResourceName()

-- Admin permission (ACE). Open editor with /restaurantcreator
Config.adminAce      = 'apex_restaurant.admin'
Config.adminCommand  = 'restaurantcreator'
Config.toggleKey     = nil -- optional RegisterKeyMapping (e.g. 'F6'), nil = command-only

-- ─── Creator access (who can open /restaurantcreator) ─────
-- Multiple ways to grant access to the node editor / job creator.
-- ANY matching rule grants access. Works on ESX, QBCore and Qbox.
-- (The actual matching lives in shared/integrations.lua → Integrations.Admin,
--  which is OPEN SOURCE so you can extend it however you like.)
Config.creatorAccess = {
    -- 1) ACE permission — recommended, framework-independent.
    --    Grant in server.cfg:  add_ace group.admin apex_restaurant.admin allow
    ace = { enabled = true, permission = 'apex_restaurant.admin' },

    -- 2) Admin GROUPS. Checked against the framework group
    --    (ESX getGroup / QBCore permission / Qbox HasGroup) AND the ACE
    --    principal `group.<name>` — so txAdmin/vMenu admins match too.
    --    Set to {} to disable.
    groups = { 'admin', 'superadmin' },

    -- 3) JOB-based access. Give a management/owner job the creator.
    --    Format: [jobName] = minGrade
    jobs = {
        -- ['management'] = 0,
        -- ['realestate'] = 2,
    },

    -- 4) Specific player IDENTIFIERS (any of license/steam/discord/fivem/xbl).
    --    Handy for a head-dev who isn't in an admin group.
    identifiers = {
        -- 'license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
        -- 'discord:123456789012345678',
    },
}

-- ─── Interaction ──────────────────────────────────────────
-- 'target'  = look-at + on-screen interaction (eye)
-- 'textui'  = proximity + key press
Config.interaction       = 'textui'
Config.textUIKey         = 38      -- E
Config.textUIDistance    = 2.5
Config.targetMaxDistance = 4.0

-- ─── 3D marker visibility (public vs job-locked) ──────────
-- Controls WHO sees each restaurant's 3D world markers.
--   • JOB-LOCKED zones only show to players employed at that restaurant
--     (they never clutter the map for random customers).
--   • PUBLIC zones show to everyone — used for the customer-facing shop
--     and the menu board, so any player can order / read the menu.
--
-- Only the four "flexible" kinds below can be toggled. The staff tools
-- (boss, duty, wardrobe, register, preparation, station, storage,
-- delivery) are ALWAYS job-locked regardless of this table.
Config.publicMarkers = {
    customerShop = true,   -- "Order Here" customer shop  (public)
    menuDisplay  = true,   -- menu board                  (public)
    npcShop      = false,  -- supplier / restock          (staff only)
    tray         = false,  -- kitchen pickup tray         (staff only)
}

-- ─── UI Theme (matches apex_notify palette) ───────────────
-- `brand` (accent) and `bg` (page background base) are the two colours
-- editable live from the creator's settings popover. They are SERVER-GLOBAL
-- (persisted in data/theme.json, broadcast to every player). "Reset" in the
-- creator always restores the values declared here.
Config.theme = {
    brand        = '#1F5EFF',
    brandDark    = '#0048F0',
    bg           = '#0A0A0B',
    bgCard       = '#1A1A1B',
    bgRaised     = '#232325',
    bgSidebar    = '#131314',
    border       = '#1F1F21',
    borderHi     = '#2A2A2D',
    text         = '#F4F4F5',
    textSub      = 'rgba(244,244,245,.55)',
    info         = '#4E9CE5',
    success      = '#34C77B',
    warning      = '#E5A93C',
    error        = '#E5564B',
}

-- ─── Currency ─────────────────────────────────────────────
-- The symbol used by every money UI (register display, boss
-- dashboard funds & revenue, customer order prices, etc.).
--   '$'  · '€'  · '£'  · '¥'  · 'R$' · 'kr' · 'zł'  · '₽' · '₺' · '₪'
-- position: 'before' → $100   'after' → 100 €
Config.currency = {
    symbol   = '£',
    position = 'before',
}

-- ─── Notifications ────────────────────────────────────────
Config.notify = {
    position = 'top-right', -- top-right | top-left | top-center | bottom-right | bottom-left | bottom-center
    duration = 5000,
    sound    = true,
    -- Notification title. nil = use the restaurant name automatically (the
    -- player's job label). Set a fixed brand here to force it on every
    -- notification instead, e.g. title = 'McDonalds'.
    title    = nil,
}

-- ─── Universal items (single-item shortcut) ───────────────
-- When true, every customer purchase collapses into ONE inventory item
-- (`restaurant_food`) carrying metadata for label/calories/anim. Set
-- this to FALSE (default) so buyers receive the actual item that the
-- restaurant deposited — e.g. ordering a cheeseburger gives them a
-- `cheeseburger`, not a generic "Food" item.
Config.useUniversalItems = false
Config.universalItems    = {
    food = 'restaurant_food',
    box  = 'restaurant_box',
    menu = 'restaurant_menu',
}

-- ─── Item image source ────────────────────────────────────
-- Where the NUI fetches item icons from. Switch this depending on
-- what inventory you have installed.
--   ox_inventory:    'nui://ox_inventory/web/images/'
--   local (shipped): 'nui://apex_restaurant/build/html/img/'
--   custom CDN:      'https://your-cdn.com/items/'
Config.itemImageBase = 'nui://ox_inventory/web/images/'

-- ─── Station animations ───────────────────────────────────
-- Animations played at each kind of station node. Used by the
-- preparation table + cooking stations. Each entry can carry:
--   anim     = { dict, clip }                  played via TaskPlayAnimAdvanced
--   scenario = 'WORLD_HUMAN_STAND_IMPATIENT'   played via TaskStartScenarioInPlace
--   duration is ignored here (Utils.recipeTime decides cook time)
-- Station animations — identical to the kronix_restaurant setup.
-- Grilling and frying use scenarios (their built-in BBQ / impatient
-- poses); cutting, pouring and assembly use plain loop anims.
Config.stationAnimations = {
    cutting   = { anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' } },
    grilling  = { scenario = 'PROP_HUMAN_BBQ' },
    frying    = { scenario = 'WORLD_HUMAN_STAND_IMPATIENT' },
    pouring   = { anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' } },
    assembly  = { anim = { dict = 'mini@repair',                              clip = 'fixing_a_player' } },
}

-- Map each station kind → which entry of stationAnimations it uses
Config.stationKindAnim = {
    preparation = 'cutting',
    grill       = 'grilling',
    assembly    = 'assembly',
    fryer       = 'frying',
    drinks      = 'pouring',
    coffee      = 'pouring',
}

-- ─── Food animations (eat / drink + prop attachment) ──────
-- Picked from the boss-menu Recipes builder, one per recipe. The
-- key is stored on the recipe and travels through the universal
-- restaurant_food metadata so the right animation + prop plays
-- when the player uses the item.
--
-- bone IDs:
--   18905 = SKEL_R_Hand    (right hand)
--   28422 = SKEL_R_Finger12 (between fingers, for cups)
--   60309 = BONETAG_PH_R_HAND (right-hand prop tag)
Config.foodAnimations = {
    cup           = { label = 'Cup',            anim = { dict = 'amb@world_human_drinking@coffee@male@idle_a', clip = 'idle_c' },                                prop = { model = 'prop_plastic_cup_02',              pos = vec3(0.0, 0.0, 0.0),       rot = vec3(0.0, 0.0, 0.0),       bone = 28422 } },
    burger        = { label = 'Burger',         anim = { dict = 'mp_player_inteat@burger',                    clip = 'mp_player_int_eat_burger' },                prop = { model = 'prop_cs_burger_01',                pos = vec3(0.0, 0.0, -0.02),     rot = vec3(0.0, 0.0, 30.0),      bone = 60309 } },
    taco          = { label = 'Taco',           anim = { dict = 'mp_player_inteat@burger',                    clip = 'mp_player_int_eat_burger' },                prop = { model = 'prop_taco_01',                     pos = vec3(-0.017, 0.007, -0.021), rot = vec3(107.98, -105.03, 55.78), bone = 60309 } },
    hotdog        = { label = 'Hotdog',         anim = { dict = 'mp_player_inteat@burger',                    clip = 'mp_player_int_eat_burger' },                prop = { model = 'prop_cs_hotdog_02',                pos = vec3(-0.03, 0.01, -0.01),  rot = vec3(95.11, 94.70, -66.92), bone = 60309 } },
    bagel         = { label = 'Bagel',          anim = { dict = 'mp_player_inteat@burger',                    clip = 'mp_player_int_eat_burger' },                prop = { model = 'p_ing_bagel_01',                   pos = vec3(0.14, 0.05, 0.03),    rot = vec3(145.40, -53.90, 4.84), bone = 18905 } },
    donut         = { label = 'Donut',          anim = { dict = 'mp_player_inteat@burger',                    clip = 'mp_player_int_eat_burger' },                prop = { model = 'prop_amb_donut',                   pos = vec3(0.13, 0.05, 0.02),    rot = vec3(-50.0, 16.0, 60.0),   bone = 18905 } },
    apple         = { label = 'Apple',          anim = { dict = 'mp_player_inteat@burger',                    clip = 'mp_player_int_eat_burger' },                prop = { model = 'sf_prop_sf_apple_01b',             pos = vec3(0.0, 0.015, -0.02),   rot = vec3(-124.70, -166.58, 8.46), bone = 60309 } },
    winebottle    = { label = 'Wine Bottle',    anim = { dict = 'amb@world_human_drinking@beer@female@idle_a', clip = 'idle_e' },                                 prop = { model = 'prop_wine_rose',                   pos = vec3(0.0, 0.04, -0.19),    rot = vec3(10.0, 0.0, 0.0),      bone = 28422 } },
    coffee        = { label = 'Coffee',         anim = { dict = 'amb@world_human_drinking@coffee@male@idle_a', clip = 'idle_c' },                                 prop = { model = 'p_amb_coffeecup_01',               pos = vec3(0.0, 0.0, 0.0),       rot = vec3(0.0, 0.0, 0.0),       bone = 28422 } },
    whiskey       = { label = 'Whiskey',        anim = { dict = 'amb@world_human_drinking@coffee@male@idle_a', clip = 'idle_c' },                                 prop = { model = 'prop_drink_whisky',                pos = vec3(0.01, -0.01, -0.06),  rot = vec3(0.0, 0.0, 0.0),       bone = 28422 } },
    whiskeybottle = { label = 'Whiskey Bottle', anim = { dict = 'amb@world_human_drinking@coffee@male@idle_a', clip = 'idle_c' },                                 prop = { model = 'ba_prop_battle_whiskey_bottle_2_s', pos = vec3(0.0, 0.0, 0.5),      rot = vec3(0.0, 0.0, 0.0),       bone = 28422 } },
    beer          = { label = 'Beer',           anim = { dict = 'amb@world_human_drinking@coffee@male@idle_a', clip = 'idle_c' },                                 prop = { model = 'prop_amb_beer_bottle',             pos = vec3(0.0, 0.0, 0.06),      rot = vec3(0.0, 15.0, 0.0),      bone = 28422 } },
    wine          = { label = 'Wine',           anim = { dict = 'anim@heists@humane_labs@finale@keycards',     clip = 'ped_a_enter_loop' },                        prop = { model = 'prop_drink_redwine',               pos = vec3(0.10, -0.03, 0.03),   rot = vec3(-100.0, 0.0, -10.0),  bone = 18905 } },
    flute         = { label = 'Flute',          anim = { dict = 'anim@heists@humane_labs@finale@keycards',     clip = 'ped_a_enter_loop' },                        prop = { model = 'prop_champ_flute',                 pos = vec3(0.10, -0.03, 0.03),   rot = vec3(-100.0, 0.0, -10.0),  bone = 18905 } },
    champagne     = { label = 'Champagne',      anim = { dict = 'anim@heists@humane_labs@finale@keycards',     clip = 'ped_a_enter_loop' },                        prop = { model = 'prop_drink_champ',                 pos = vec3(0.10, -0.03, 0.03),   rot = vec3(-100.0, 0.0, -10.0),  bone = 18905 } },
    beans         = { label = 'Beans Bowl',     anim = { dict = 'anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1', clip = 'base_idle' },           prop = { model = 'h4_prop_h4_caviar_tin_01a',        pos = vec3(0.0, 0.03, 0.01),     rot = vec3(0.0, 0.0, 0.0),       bone = 60309 } },
    dinner        = { label = 'Dinner Dish',    anim = { dict = 'anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1', clip = 'base_idle' },           prop = { model = 'prop_cs_plate_01',                 pos = vec3(0.0, 0.0, 0.0),       rot = vec3(0.0, 0.0, 0.0),       bone = 60309 } },
    sandwich      = { label = 'Sandwich',       anim = { dict = 'mp_player_inteat@burger',                    clip = 'mp_player_int_eat_burger' },                prop = { model = 'prop_sandwich_01',                 pos = vec3(0.13, 0.05, 0.02),    rot = vec3(-50.0, 16.0, 60.0),   bone = 18905 } },
}

-- Default food animation per item category if the boss didn't pick one.
Config.defaultFoodAnimByCategory = {
    food         = 'burger',
    drink        = 'cup',
    fruit        = 'apple',
    vegetable    = 'apple',
    raw          = 'sandwich',
    cutted       = 'sandwich',
    universal    = 'burger',
}

-- ─── Calories ─────────────────────────────────────────────
-- Higher-calorie items refill more hunger/thirst. The values per
-- food item live in shared/items.lua. The formula below decides
-- how those kcal are converted to status points (0-100 scale).
--
-- Final restored values when consuming an item:
--   hungerGain = clamp( calories * hungerPerCalorie * categoryMul, 0, maxFillPerItem )
--   thirstGain = clamp( calories * thirstPerCalorie * categoryMul, 0, maxFillPerItem )
--
--   categoryMul defaults to 1.0; for items in the 'drink' category
--   we apply `drinkMultiplier` to thirst (and `solidPenalty` to
--   hunger so soda doesn't fill the player up). For 'food' items
--   we apply `foodMultiplier` to hunger and `liquidPenalty` to
--   thirst (so a burger doesn't act like Gatorade).
--
-- Tuning hint: at hungerPerCalorie = 0.10 a 500 kcal cheeseburger
-- restores 50 hunger points (50% of the bar).
Config.calorieSystem = {
    enabled           = true,
    hungerPerCalorie  = 0.10,   -- food: % hunger per kcal
    thirstPerCalorie  = 0.05,   -- drink: % thirst per kcal
    foodMultiplier    = 1.0,    -- bumps hunger gain for 'food' category
    drinkMultiplier   = 1.0,    -- bumps thirst gain for 'drink' category
    solidPenalty      = 0.10,   -- drinks contribute only 10% of their kcal to hunger
    liquidPenalty     = 0.20,   -- food contributes 20% of its kcal to thirst
    maxFillPerItem    = 100,    -- hard cap (one item can never overfill either bar)
    eatAnim           = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
    drinkAnim         = { dict = 'mp_player_intdrink',      clip = 'loop_bottle' },
    eatTime           = 4000,   -- ms — also used as the progress duration
}

-- ─── Timers (ms) ──────────────────────────────────────────
-- Base recipe durations + per-ingredient scaling. A recipe with an
-- explicit `time` field (set in the boss menu's Recipes builder, or
-- in the editor's per-node recipes) overrides these values.
-- Otherwise the duration is computed as:
--     prepareBase + (units − 1) × prepareExtra   (preparation table)
--     cookBase    + (units − 1) × cookExtra      (cooking station)
-- where `units` is the SUM of ingredient quantities for the recipe.
-- So a burger with { meat=2, lettuce=1, tomato=1 } cooks longer than
-- a single-ingredient nugget, even with the same `cookBase`.
Config.times = {
    prepareBase  = 3000,   -- base cut time
    prepareExtra = 500,    -- + per additional input unit
    cookBase     = 4000,   -- base cook time
    cookExtra    = 800,    -- + per additional ingredient unit
    eatFood      = 4000,
    takeOrder    = 5000,
    -- Per-station multipliers applied on top of cookBase + cookExtra.
    -- Grilling takes the longest (meat needs to actually cook); drinks
    -- + coffee are quick to serve.
    kindMultiplier = {
        grill    = 1.6,
        assembly = 1.0,
        fryer    = 1.0,
        drinks   = 0.6,
        coffee   = 0.8,
    },
}

-- ─── Delivery routes (city-wide pool) ─────────────────────
-- Used when a restaurant's delivery node has NO dropoffs configured
-- in the editor. A random one is picked for each run. Each entry is
-- a vec4(x, y, z, heading) + a friendly label shown in the HUD.
Config.deliveryLocations = {
    -- PinkCage
    { coords = vec4(309.5,  -208.06, 53.22, 251.41), label = 'Pink Cage Motel' },
    { coords = vec4(319.29, -196.16, 53.23, 154.93), label = 'Pink Cage Motel' },
    { coords = vec4(341.05, -214.76, 53.22, 67.86),  label = 'Pink Cage Motel' },
    -- Mirror Park
    { coords = vec4(1010.39, -423.41, 64.35, 306.75), label = 'Mirror Park' },
    { coords = vec4(1014.68, -469.29, 63.5,  35.45),  label = 'Mirror Park' },
    { coords = vec4(945.74,  -519.02, 59.82, 299.21), label = 'Mirror Park' },
    { coords = vec4(861.46,  -508.95, 56.72, 225.58), label = 'Mirror Park' },
    { coords = vec4(964.32,  -596.21, 55.9,  71.99),  label = 'Mirror Park' },
    { coords = vec4(959.87,  -669.9,  57.45, 298.56), label = 'Mirror Park' },
    -- Rich Zone
    { coords = vec4(-305.24, 430.99, 109.48, 10.32),  label = 'Rockford Hills' },
    { coords = vec4(-580.41, 491.57, 107.9,  9.17),   label = 'Rockford Hills' },
    { coords = vec4(-762.09, 430.83, 99.2,   19.55),  label = 'West Vinewood' },
    { coords = vec4(-765.8,  650.54, 144.7,  293.03), label = 'Vinewood Hills' },
    { coords = vec4(-1056.4, 761.57, 166.32, 274.3),  label = 'Richman' },
    -- North Rockford Drive
    { coords = vec4(-1940.56, 387.63, 95.69,  190.19), label = 'North Rockford Drive' },
    { coords = vec4(-2009.25, 367.44, 93.82,  267.99), label = 'North Rockford Drive' },
    { coords = vec4(-2011.24, 445.02, 102.02, 290.37), label = 'North Rockford Drive' },
    { coords = vec4(-1942.66, 449.63, 101.93, 103.03), label = 'North Rockford Drive' },
    -- Downtown
    { coords = vec4(-47.45,   -1757.51, 29.42, 48.12),  label = 'Davis' },
    { coords = vec4(265.13,   -1899.64, 26.76, 230.0),  label = 'Strawberry' },
    { coords = vec4(-1196.72, -1560.73, 4.61,  215.0),  label = 'Vespucci Beach' },
    { coords = vec4(-1044.55, -1399.62, 5.55,  300.0),  label = 'Vespucci Canals' },
}

-- Customer ped models — a random one is spawned at the drop-off point
-- so the player has someone to deliver the order to.
Config.deliveryPeds = {
    'a_f_y_hipster_01',  'a_f_y_hipster_02',  'a_f_y_bevhills_01', 'a_f_y_bevhills_02',
    'a_f_y_business_01', 'a_f_y_fitness_01',  'a_f_y_vinewood_01',
    'a_m_m_bevhills_01', 'a_m_m_bevhills_02', 'a_m_m_business_01', 'a_m_m_eastsa_01',
    'a_m_m_farmer_01',   'a_m_m_golfer_01',   'a_m_m_malibu_01',
    'a_m_y_hipster_01',  'a_m_y_business_01', 'a_m_y_vinewood_01',
    'ig_barry', 'ig_bestmen', 'ig_beverly', 'ig_casey', 'ig_chef', 'ig_clay',
    'ig_dale',  'ig_dreyfuss', 'ig_floyd', 'ig_hao', 'ig_hunter', 'ig_josh',
    'ig_lazlow','ig_milton',  'ig_nervousron', 'ig_nigel', 'ig_orleans',
    'ig_paper','ig_terry', 'ig_wade',
    's_m_m_paramedic_01',
    'a_m_m_afriamer_01', 'a_m_m_beach_01', 'a_m_m_beach_02', 'a_m_m_fatlatin_01',
    'a_m_m_genfat_01',   'a_m_m_genfat_02','a_m_m_indian_01','a_m_m_ktown_01',
    'a_m_m_polynesian_01',
    'a_f_m_tourist_01',  'a_f_y_tourist_01', 'a_f_y_tourist_02', 'a_f_y_genhot_01',
    'a_f_y_soucent_01',  'a_f_y_eastsa_01',
}

-- ─── Storage / boxes ──────────────────────────────────────
Config.boxes = { slots = 5, weight = 50 }

-- ─── Hot reload ───────────────────────────────────────────
-- After saving in the editor the server pushes the new layout
-- to every client. No restart required.
Config.hotReload = true

-- ─── Discord webhooks (optional, leave empty to disable) ──
Config.logs = {
    editorSave    = '',
    npcShopBuy    = '',
    register      = '',
    delivery      = '',
    boss          = '',
}




