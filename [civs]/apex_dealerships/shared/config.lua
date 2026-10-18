--[[
    apex_dealerships — shared/config.lua  (open source, edit freely)
    Compatible with ESX Legacy / QBCore / QBox — framework is auto-detected.
]]

Config = Config or {}

Config.debug   = false               -- prints extra info with Utils.Debug()
Config.locale  = 'en'                -- must match a file in build/locales
Config.adminAce = 'command'          -- ace required for admin panel / catalog CRUD (IsPlayerAceAllowed)

-- =========================================================================
-- FRAMEWORK
-- =========================================================================
-- 'auto' detects es_extended / qb-core / qbx_core at start. Only pin this if
-- auto-detection guesses wrong (e.g. a heavily renamed core).
Config.framework = 'qbx'            -- 'auto' | 'esx' | 'qb' | 'qbx'

-- Where a purchased vehicle is filed. QB/QBox write this into
-- `player_vehicles.garage`; make sure the name exists in YOUR garage script.
Config.defaultGarage = 'G1'       -- matches apex_advancedgarage's default public garage

-- Society / business funds provider. 'auto' tries, in order: the apex_bossmenu
-- treasury, then the framework's banking resource, then this resource's own
-- internal wallet. LGMods_Banking is supported for QB/QBCore. Pin it if you run several.
Config.societyProvider = 'LGMods_Banking'      -- 'auto' | 'LGMods_Banking' | 'qb-banking' | 'qb-management' | 'okokBanking' | 'Renewed-Banking' | 'esx_addonaccount'

-- =========================================================================
-- PURCHASE / DELIVERY
-- =========================================================================
Config.purchase = {
    spawnVehicle  = true,            -- false: the car goes straight to the garage, nothing spawns
    warpIntoSeat  = true,            -- put the buyer behind the wheel of the delivered car
    fuelLevel     = 100.0,           -- fuel on a freshly delivered/test-driven vehicle
    payoutAccount = 'bank',          -- 'bank' | 'cash' — where sell-backs and commission land
}

-- =========================================================================
-- WORLD STREAMING — how close a player must be before we spawn anything.
-- Nothing exists on the map beyond these distances, so a player on the other
-- side of the city pays zero entity/physics cost for your dealerships.
-- =========================================================================
Config.display = {
    spawnDistance   = 120.0,         -- showcase vehicles + peds spawn within this
    despawnDistance = 180.0,         -- ...and are deleted again past this
    pedScenario     = 'WORLD_HUMAN_CLIPBOARD',
}

-- =========================================================================
-- THEME — Apex design system (sent to the NUI on bootstrap)
-- =========================================================================
-- ONLY these three are used. Every other surface, border, text tone and state
-- colour in the UI is derived from them at runtime (same ramp as the rest of
-- the Apex kit: `bg` is the BASE tone and the page background sits one step
-- below it). Admins can override brand + bg in-game from /dealerships →
-- Appearance, for every player at once.
Config.theme = {
    brand     = '#801fff',           -- accent: buttons, markers, highlights
    brandDark = '#8400f0',           -- pressed/hover shade of the accent
    bg        = '#131314',           -- base surface tone
}

Config.currency = { symbol = '£', position = 'before' }
Config.notify   = { position = 'top-right', duration = 5000, title = 'Dealership' }

-- =========================================================================
-- VEHICLE IMAGES — the thumbnails on the showroom cards and in the tables.
-- (The live 3D preview is always shown; these are only pictures.)
--
-- Resolution order for every vehicle, first hit wins:
--   1. YOUR OWN image:  build/html/images/<spawncode>.<ext>   e.g. adder.png
--   2. the fallback URL below (base-game screenshots from the FiveM docs)
--   3. a styled monogram with the brand initials
--
-- So to give a vehicle a custom picture you literally just drop a file named
-- after its spawn code into build/html/images/ — nothing else to configure.
-- Addon cars work the same way (they have no picture on the FiveM docs, so
-- without a custom image they fall through to the monogram).
-- =========================================================================
Config.vehicleImages = {
    enabled     = true,      -- false: never show pictures, always the monogram
    custom      = true,      -- false: skip build/html/images/ and go straight to the URL
    extensions  = { 'png', 'jpg', 'jpeg', 'webp' },   -- tried in this order
    -- %s is the spawn code. Set to false to use ONLY your own images.
    fallbackUrl = 'https://docs.fivem.net/vehicles/%s.webp',
}

-- =========================================================================
-- PLATES
-- =========================================================================
Config.plate = {
    format    = 'AA11A1A',          -- 1 = digit, A = letter, anything else literal
    testDrive = 'TEST ME',           -- plate on test-drive vehicles
    display   = 'BUY ME',              -- plate on showcase/display vehicles
}

-- =========================================================================
-- FINANCE — proper amortization (interest on the outstanding balance)
-- =========================================================================
Config.finance = {
    enabled            = true,
    downPaymentMin     = 0.10,       -- 10% minimum down payment
    downPaymentMax     = 0.60,
    terms              = { 6, 12, 24 },   -- number of installments the buyer can pick
    apr                = 0.12,       -- yearly interest rate (amortized per installment)
    intervalHours      = 12,         -- real hours between installments
    maxFinanced        = 3,          -- max financed vehicles per player
    missedGraceHours   = 6,          -- grace after a failed installment before it counts as missed
    maxMissed          = 2,          -- missed installments before repossession
    chargeOffline      = true,       -- charge offline players straight from the DB bank balance
    earlyPayoffOnPrincipal = true,   -- paying off early only charges remaining principal (no future interest)
}

-- =========================================================================
-- TEST DRIVES
-- =========================================================================
Config.testdrive = {
    seconds        = 150,
    useBucket      = true,           -- isolate the drive in a private routing bucket
    endCommand     = 'endtd',        -- end the test drive early
    exitControl    = 75,             -- control that ends the drive (75 = F / exit vehicle); the ped never actually leaves
    maxPerDealer   = 5,              -- concurrent test drives per dealership
    deposit        = 0,              -- refundable deposit (0 = disabled)
}

-- =========================================================================
-- OWNED DEALERSHIPS (player-run business)
-- =========================================================================
Config.business = {
    wholesaleRate      = 0.80,       -- stock orders cost price * rate
    orderMinutes       = 15,         -- minutes until ordered stock is delivered
    defaultCommission  = 10,         -- % of a direct sale paid to the selling employee
    maxCommission      = 30,
    priceFloor         = 0.70,       -- managers may reprice between floor..ceil * catalog price
    priceCeil          = 1.50,
    sellBackPercent    = 60,         -- default % of value paid when a player sells a car back
}

-- =========================================================================
-- STOCK RUNS — ordered stock must be FETCHED with a truck (RP method).
-- The order still "arrives" after Config.business.orderMinutes, but only at
-- the DOCKS. An employee then starts a run from the Orders tab:
--   1. the truck + empty trailer spawns at the stand's OWN stock point
--      (set it per stand in /dealerships → Zones → Stock point)
--   2. drive to the docks and load the vehicles (E)
--   3. drive back and unload at that same stock point (E) → stock added
-- Set enabled = false to go back to automatic timed delivery.
-- =========================================================================
Config.stockRun = {
    enabled = true,

    truckModel       = 'hauler',   -- spawns at the stand's stock point
    trailerSmall     = 'tr2',      -- car carrier (small + medium vehicles)
    trailerContainer = 'tr2',      -- container trailer (one large vehicle)

    -- Trailer capacity. The tr2 car carrier has 6 slots AND four physical decks:
    -- a small vehicle (bike/compact) takes 1 slot, a medium one takes 1.5 — so
    -- you can load 6 bikes or 4 cars, and never more than `maxVehicles` bodies
    -- (that is how many actually fit on the trailer model).
    maxSlots    = 6,
    maxVehicles = 4,
    slotSize    = { small = 1.0, medium = 1.5 },

    -- a vehicle's size comes from its category (override single models below)
    sizeByCategory = {
        motorcycles = 'small', compacts = 'small',
        commercial = 'large', planes = 'large', helicopters = 'large', boats = 'large',
        -- everything else defaults to 'medium'
    },
    sizeByModel = {},              -- e.g. ['titan'] = 'large'

    attachDistance = 12.0,         -- how close the truck must be to hitch
    dropRadius     = 10.0,         -- how close the trailer must be to count as delivered
    cargoRadius    = 15.0,         -- trailer must be this close to the truck
    timeoutMin     = 45,           -- mission expires after N minutes

    -- Cargo pickup yards. One mission occupies one yard at a time.
    pickupLocations = {
        { name = 'Elysian Island',                       coords = vector4(1200.46, -3238.60, 5.79, 0.00) },
        { name = 'Elysian Island',                       coords = vector4(1054.20, -3154.57, 5.90, 180.00) },
        { name = 'Port Container Yard',                  coords = vector4(863.25, -2927.89, 5.90, 270.00) },
        { name = 'Terminal - Freight Depot',             coords = vector4(804.98, -2911.98, 6.00, 270.00) },
        { name = 'Cypress Flats - RON Depot',            coords = vector4(630.34, -2748.96, 6.10, 304.89) },
        { name = 'Cypress Flats - Industrial Park',      coords = vector4(878.57, -2178.94, 30.52, 175.00) },
        { name = 'La Mesa - Logistics Center',           coords = vector4(858.13, -1712.15, 25.14, 352.00) },
        { name = 'El Burro Heights - Storage Facility',  coords = vector4(1526.53, -2113.84, 76.77, 0.00) },
        { name = 'LSIA - Cargo Terminal',                coords = vector4(-782.29, -2661.93, 13.99, 60.00) },
        { name = 'Grand Senora Desert - Logistics Hub',  coords = vector4(1777.37, 3309.64, 41.22, 298.00) },
        { name = 'Sandy Shores - Industrial Yard',       coords = vector4(2537.24, 2584.06, 37.94, 12.00) },
        { name = 'Paleto Cove - Shipping Yard',          coords = vector4(-361.33, 6065.99, 31.50, 311.00) },
        { name = 'East Vinewood - Import Facility',      coords = vector4(875.16, -953.48, 28.06, 2.00) },
        { name = 'Murrieta Heights - Distribution',      coords = vector4(1207.16, -1230.24, 35.23, 270.33) },
        { name = 'Terminal - Freight Depot',             coords = vector4(758.59, -1656.02, 31.38, 354.00) },
        { name = 'Elysian Island',                       coords = vector4(166.60, -3297.93, 5.22, 269.91) },
        { name = 'Elysian Island',                       coords = vector4(130.21, -3337.48, 5.36, 268.56) },
        { name = 'Elysian Island',                       coords = vector4(287.65, -3209.35, 5.16, 269.95) },
        { name = 'Elysian Island',                       coords = vector4(305.19, -3091.21, 5.17, 0.25) },
        { name = 'Elysian Island',                       coords = vector4(244.01, -2791.55, 5.34, 218.72) },
        { name = 'Terminal - Freight Depot',             coords = vector4(607.76, -2997.28, 5.38, 179.53) },
        { name = 'Terminal - Freight Depot',             coords = vector4(600.28, -2930.80, 5.38, 180.67) },
        { name = 'Terminal - Freight Depot',             coords = vector4(892.76, -3155.41, 5.24, 179.60) },
        { name = 'Terminal - Freight Depot',             coords = vector4(928.91, -3184.42, 5.24, 0.88) },
        { name = 'Buccaneer Way',                        coords = vector4(594.59, -2767.71, 5.39, 329.99) },
        { name = 'Buccaneer Way',                        coords = vector4(631.09, -2748.45, 5.44, 305.14) },
    },
}

-- Role -> permissions. ADMIN implies everything.
-- Permissions: ADMIN, MANAGE_EMPLOYEES, MANAGE_STOCK, MANAGE_FINANCES, SELL, VIEW_RECORDS
Config.roles = {
    ['Manager']    = { 'ADMIN' },
    ['Supervisor'] = { 'MANAGE_STOCK', 'MANAGE_FINANCES', 'SELL', 'VIEW_RECORDS' },
    ['Sales']      = { 'SELL', 'VIEW_RECORDS' },
}

-- When a location sets `bossJob = '<jobname>'`, players WITH that framework
-- job are treated as staff: their job grade maps to a role below (highest
-- entry <= grade wins). Staff is then managed through apex_bossmenu / your
-- job system instead of the internal employees table.
Config.jobGradeRoles = {
    [0] = 'Sales',
    [1] = 'Supervisor',
    [2] = 'Manager',
}

-- =========================================================================
-- COMMANDS / KEYS
-- =========================================================================
Config.commands = {
    myFinance  = 'myfinance',        -- open personal finance overview anywhere
    directSale = 'directsale',       -- employees: open the direct-sale showroom
    admin      = 'dealerships',      -- server admins: create/edit stands, listings, catalog, import
}
Config.interactKey = 38              -- E

-- =========================================================================
-- CATEGORIES — FIRST-BOOT SEED ONLY.
-- After the first start they live in `apex_dealerships_categories` and are
-- managed in-game (/dealerships → Categories), where you can add your own.
--
-- Every category belongs to a DOMAIN:
--   land = cars & bikes | air = planes & helicopters | sea = boats & jetskis
-- A vehicle's domain is its category's domain, and each stand configures the
-- domains it sells separately (own showroom point, preview, delivery, etc).
-- =========================================================================
Config.categories = {
    { key = 'compacts',       label = 'Compacts',        domain = 'land' },
    { key = 'sedans',         label = 'Sedans',          domain = 'land' },
    { key = 'suvs',           label = 'SUVs',            domain = 'land' },
    { key = 'coupes',         label = 'Coupes',          domain = 'land' },
    { key = 'muscle',         label = 'Muscle',          domain = 'land' },
    { key = 'sportsclassics', label = 'Sports Classics', domain = 'land' },
    { key = 'sports',         label = 'Sports',          domain = 'land' },
    { key = 'super',          label = 'Super',           domain = 'land' },
    { key = 'motorcycles',    label = 'Motorcycles',     domain = 'land' },
    { key = 'offroad',        label = 'Off-Road',        domain = 'land' },
    { key = 'vans',           label = 'Vans',            domain = 'land' },
    { key = 'commercial',     label = 'Commercial',      domain = 'land' },

    { key = 'helicopters',    label = 'Helicopters',     domain = 'air' },
    { key = 'planes',         label = 'Planes',          domain = 'air' },

    { key = 'boats',          label = 'Boats',           domain = 'sea' },
    { key = 'jetskis',        label = 'Jet Skis',        domain = 'sea' },
}

-- Per-domain defaults used by the showroom preview camera and the spawner.
Config.domains = {
    land = { label = 'Land',      icon = 'car',        camRadius = 5.5,  ground = true  },
    air  = { label = 'Air',       icon = 'helicopter', camRadius = 11.0, ground = false },
    sea  = { label = 'Sea',       icon = 'ship',       camRadius = 9.0,  ground = false },
}

-- =========================================================================
-- DISCORD WEBHOOKS (leave empty to disable)
-- =========================================================================
Config.webhooks = {
    purchase  = '',
    finance   = '',
    testdrive = '',
    business  = '',
    admin     = '',
}

-- ============================================================================
-- VEHICLE KEYS
-- ============================================================================

-- Which key resource receives the keys when a vehicle is bought or test driven.
--   'auto'       -> detect and feed every supported key resource that is running
--                   (qbx_vehiclekeys, qb-vehiclekeys, wasabi_carlock,
--                    qs-vehiclekeys, MrNewbVehicleKeys, Renewed-Vehiclekeys,
--                    tgiann-hotwire, vehicles_keys, codem-vehiclekeys,
--                    ti_vehicleKeys, rcore_carkeys, brutal_vehiclekeys,
--                    mono_carkeys, cd_garage, okokGarage, mk_vehiclekeys,
--                    t1ger_keys, ak47_vehiclekeys, F_RealCarKeysSystem,
--                    xd_locksystem, esx_vehiclelock)
--   'none'       -> never touch keys (your own script handles it elsewhere)
--   '<resource>' -> use ONLY that provider, skipping detection. Pin this if
--                   two key resources are running and only one should win.
--
-- ⚠ THE KEY IS NOW GIVEN ON BOTH SIDES. Most key resources own the key on the
-- SERVER, and a client-only grant is what made a key last until the car was
-- stored or the buyer relogged. It also meant a dealership set to deliver
-- straight to the garage (spawnVehicle = false) handed out no key at all,
-- because no car was ever spawned for the client to ask about.
--
-- Run /dealerkeys in the SERVER CONSOLE to see which key resources are running,
-- which ones this resource feeds, whether each has a server half, and what the
-- last attempt actually did.
--
-- Need something custom? Define Integrations.CustomGiveKeys (client) or
-- Integrations.CustomGiveKeysServer (server) in shared/integrations.lua —
-- they override everything above.
Config.vehicleKeys = 'Renewed-Vehiclekeys'
