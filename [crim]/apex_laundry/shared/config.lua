--[[
    Apex Laundry — Shared Config
    ────────────────────────────────────────────────────────────
    Standalone money-laundering machines. A player walks up to a
    laundromat machine, deposits "cleaner" items to fuel it, feeds
    in dirty money, waits for the wash to complete, then collects
    the laundered (clean) money minus a configurable tax. Machines
    can be upgraded (more capacity / faster washes).

    NO JSON FILES are used anywhere — everything that needs to
    persist (cleaners, upgrade levels, in-progress washes) lives in
    the database (oxmysql). Edit this file + restart to apply.

    Compatible with ESX Legacy, QBCore, and QBox (auto-detected).
]]

Config = Config or {}

-- ─── General ──────────────────────────────────────────────
Config.debug         = false
Config.locale        = 'en'           -- 'en' | 'pt' | 'es' | 'fr' | 'de'
Config.resourceName  = GetCurrentResourceName()

-- ─── Framework override (auto-detected by default) ───────
-- Leave 'auto' to pick the running framework automatically.
-- Force a specific one only if you run multiple at once.
-- Supported: 'auto' | 'esx' | 'qb' | 'qbx'
Config.framework     = 'auto'

-- ═══════════════════════════════════════════════════════════
-- PROVIDERS — plug into resources you already run. Set each to
-- 'auto' to detect at runtime, a specific name to force it, or
-- 'none' to disable the integration entirely.
-- ═══════════════════════════════════════════════════════════
Config.providers = {
    -- Notifications — 'auto' order: apex_notify → ox_lib → okokNotify
    -- → mythic → esx/qb default → built-in NUI toast.
    -- 'auto'|'apex_notify'|'ox_lib'|'okok'|'mythic'|'esx'|'qb'|'custom'|'none'
    notify    = 'auto',

    -- Target system for the laundry machine. Falls back to the
    -- built-in proximity prompt (textui) when no target is found.
    -- 'auto'|'ox_target'|'qb-target'|'qtarget'|'none'
    target    = 'auto',

    -- Interaction prompt shown when Config.interaction is NOT 'target':
    --   'auto'/'apex' = built-in floating 3D NUI marker (showcase look)
    --   'ox_lib'      = ox_lib lib.showTextUI
    --   'qb'          = qb-core DrawText
    --   'custom'      = Integrations.OnPrompt (your own)
    --   'none'        = no prompt
    textui    = 'auto',

    -- Inventory provider for dirty money + cleaner items.
    -- 'auto'|'ox_inventory'|'qb-inventory'|'qs-inventory'|'esx'|'none'
    inventory = 'auto',

    -- Logging sink. 'webhook' uses Config.logs.* URLs.
    -- 'fivem_logs' prints to the txAdmin console only.
    -- 'custom' calls Integrations.OnLog(payload).
    logger    = 'webhook',
}

-- ═══════════════════════════════════════════════════════════
-- FEATURE TOGGLES — flip entire subsystems on/off per server.
-- Disabled features hide their UI panes and the server callbacks
-- refuse the action, but persisted data is kept so you can turn
-- them back on without losing progress.
-- ═══════════════════════════════════════════════════════════
Config.features = {
    cleaners      = true,    -- the "fuel the machine with cleaners" flow
    washing       = true,    -- the core dirty → clean wash
    cancel        = true,    -- allow cancelling an in-progress wash (refunds)
    upgrades      = true,    -- the upgrade cards (efficiency + potency)
    upgradeEffic  = true,    -- the Efficiency upgrade specifically
    upgradePotncy = true,    -- the Potency upgrade specifically
    blips         = true,    -- map blips for machines
    spawnProps    = true,    -- spawn the physical dryer prop per machine
    interactAnim  = true,    -- player animation when operating a machine
    sounds        = false,   -- NUI click / cash / chime sounds
}

-- ─── Commands ─────────────────────────────────────────────
-- Admin commands (/laundrycreator, /removelaundry, /laundryadmin) are
-- granted to anyone in one of Config.adminGroups (the framework group
-- you set with ESX `setgroup <id> admin`) OR who holds Config.adminAce.
Config.adminGroups   = { 'admin', 'superadmin' }   -- framework permission groups
Config.adminAce      = 'apex_laundry.admin'        -- ACE perm (add_ace ...)
Config.adminCommand  = 'laundryadmin'              -- /laundryadmin (debug/reset)

-- ─── Laundry creator (admin placement tool) ──────────────
-- /laundrycreator spawns a ghost dryer you aim with the camera, rotate
-- with the scroll wheel, nudge up/down, toggle an INVISIBLE prop, and
-- drop with E. Placed machines persist in the database, spawn for every
-- player and work exactly like config machines.
-- /removelaundry deletes the closest placed machine.
Config.creatorCommand       = 'laundrycreator'
Config.creatorRemoveCommand = 'removelaundry'
Config.creatorMaxDistance   = 12.0   -- how far the ghost can sit from the camera

-- Machine props offered in the creation menu (pick one before placing).
-- Add any prop model you like — these are just sensible defaults.
Config.creatorModels = {
    { model = 'bkr_prop_prtmachine_dryer_spin', label = 'Laundromat Dryer' },
    { model = 'prop_vend_soda_01',              label = 'Vending Machine'  },
    { model = 'prop_vend_water_01',             label = 'Water Vending'    },
    { model = 'prop_atm_01',                    label = 'ATM Terminal'     },
}

-- Fallback access rule used when a placed machine has NO permission
-- configured in the creation menu (e.g. legacy rows). nil/empty = public.
Config.creatorDefaultPermission = { groups = { 'admin' }, ace = 'apex_laundry.use' }

-- ─── Interaction ──────────────────────────────────────────
-- 'target'  = look-at + on-screen interaction (eye)
-- 'textui'  = proximity + key press (built-in 3D marker by default)
Config.interaction       = 'textui'
Config.textUIKey         = 38      -- E
Config.textUIDistance    = 1.8
Config.targetMaxDistance = 2.0

-- Vertical offset (metres) of the floating 3D marker relative to the
-- machine coords. Negative = lower. (User asked for -1.)
Config.markerZOffset     = -1.0

-- ─── Text-UI prompt position (ox_lib / qb providers) ──────
Config.textui = { position = 'left-center' }

-- ─── Optional native ground marker (off by default) ───────
Config.marker = {
    enabled = false,
    type    = 1,
    color   = { r = 31, g = 94, b = 255, a = 120 },
    scale   = { x = 1.1, y = 1.1, z = 0.5 },
    zOffset = 0.98,
    bob     = false,
    rotate  = false,
}

-- ═══════════════════════════════════════════════════════════
-- UI THEME — exact apex_bossmenu palette (flat, no gradients).
-- Brand is bossmenu pink #ff5be4. This is the DEFAULT applied to
-- everyone when the script boots; each player can override the
-- brand colour / background / position / opacity / size from the
-- in-menu Settings (persisted per-player via KVP). The NUI
-- recomputes the FULL brand ramp from `brand`, so one hex re-skins
-- the whole panel.
-- ═══════════════════════════════════════════════════════════
Config.theme = {
    brand        = '#ff5be4',
    brandDark    = '#ff5be4',
    accent       = '#ff5be4',   -- flattened to brand (bossmenu has no separate accent)
    bg           = '#0A0A0B',
    bgCard       = '#1A1A1B',
    bgRaised     = '#232325',
    bgSidebar    = '#131314',
    border       = '#1F1F21',
    borderHi     = '#2A2A2D',
    text         = '#F4F4F5',
    textSub      = 'rgba(244,244,245,.55)',
    info         = '#ff5be4',
    success      = '#34C77B',
    warning      = '#E5A93C',
    error        = '#E5564B',
}

-- Color presets offered in the per-player Settings panel.
Config.colorPresets = {
    '#ff5be4', '#1F5EFF', '#34C77B', '#E5A93C',
    '#E5564B', '#A66DF0', '#36D1FF', '#F4F4F5',
}

-- ─── Currency ─────────────────────────────────────────────
Config.currency = {
    symbol   = '£',
    position = 'before',   -- 'before' = $100   'after' = 100 €
}

-- ─── Notifications ────────────────────────────────────────
Config.notify = {
    position = 'top-right',
    duration = 4500,
    title    = 'Laundromat',
}

-- ═══════════════════════════════════════════════════════════
-- ITEMS — the inventory items the laundromat moves around.
-- `dirtyMoney` and `cleaner` are ALWAYS inventory items.
-- The clean payout + upgrade cost can be items OR money accounts
-- (see Config.economy.payout / Config.economy.upgradePayment).
-- ═══════════════════════════════════════════════════════════
Config.items = {
    dirtyMoney = 'black_money',     -- the item fed into the machine
    cleanMoney = 'money',           -- item given back when payout = 'item'
    cleaner    = 'cleaning_kit',    -- the consumable that fuels the machine
}

-- ═══════════════════════════════════════════════════════════
-- ECONOMY — the laundering maths.
--   washTime    : seconds to wash one `baseValue` chunk
--   cleanerCost : cleaners burned per `baseValue` chunk
--   taxPercent  : % skimmed off the laundered amount
-- A wash of `amount`:
--   cleaners needed = ceil(amount / baseValue) * cleanerCost
--   wash seconds    = washTime * (amount / baseValue)   (− potency bonus)
--   payout          = amount − (amount * taxPercent/100)
-- ═══════════════════════════════════════════════════════════
Config.economy = {
    baseValue   = 1000,
    washTime    = 5,
    cleanerCost = 1,
    taxPercent  = 5,

    -- Where the laundered (clean) money lands:
    --   'item' = give Config.items.cleanMoney item
    --   'cash' = add to the player's cash account (framework)
    --   'bank' = add to the player's bank account (framework)
    payout = 'cash',

    -- How upgrades are paid for:
    --   'cash' | 'bank' = framework money account
    --   'clean_item'    = Config.items.cleanMoney item
    --   'dirty_item'    = Config.items.dirtyMoney item
    upgradePayment = 'cash',

    -- Hard ceiling on a single wash before ANY efficiency upgrade.
    -- Efficiency upgrades raise this (see Config.upgrades.efficiency).
    baseLimit   = 1000000,

    -- Cap on how many cleaners a single machine can stockpile.
    maxCleaners = 500,
}

-- ═══════════════════════════════════════════════════════════
-- UPGRADES — two upgrade tracks, 5 levels each. Prices are paid
-- in Config.economy.upgradePayment. Edit freely; the NUI renders
-- whatever you define here (level meters, prices, tooltips).
-- ═══════════════════════════════════════════════════════════
Config.upgrades = {
    -- Efficiency raises the maximum amount a machine can wash at once.
    efficiency = {
        enabled     = true,
        icon        = 'fa-solid fa-gauge-high',
        levels = {
            { limit = 2000000,  price = 100000 },
            { limit = 3000000,  price = 150000 },
            { limit = 5000000,  price = 250000 },
            { limit = 7500000,  price = 400000 },
            { limit = 10000000, price = 600000 },
        },
    },
    -- Potency reduces the wash time, as a percentage.
    potency = {
        enabled     = true,
        icon        = 'fa-solid fa-bolt',
        levels = {
            { reducePercent = 10, price = 100000 },
            { reducePercent = 15, price = 150000 },
            { reducePercent = 20, price = 250000 },
            { reducePercent = 25, price = 400000 },
            { reducePercent = 30, price = 600000 },
        },
    },
}

-- ─── Machine prop ─────────────────────────────────────────
Config.defaultProp = 'bkr_prop_prtmachine_dryer_spin'

-- ─── Machine blip ─────────────────────────────────────────
Config.blip = { sprite = 500, color = 2, scale = 0.8, label = 'Laundromat' }

-- ═══════════════════════════════════════════════════════════
-- MACHINES — every laundromat machine in the world.
-- Schema:
--   id          unique string (persisted; DON'T change once live or
--               you orphan that machine's saved upgrades/wash)
--   label       shown in the UI header
--   coords      vec4(x, y, z, heading)
--   spawnProp   spawn the physical dryer prop here (Config.features.spawnProps)
--   prop        override Config.defaultProp for this machine
--   blip        show a map blip for this machine
--   permission  access rule — a player may use the machine if they
--               match ANY ONE of these (OR logic):
--                 groups = { 'admin', ... }       framework perm group(s)
--                 jobs   = { 'gang', ... }         job name(s)
--                 ace    = 'apex_laundry.use'      ACE permission
--               nil / empty = PUBLIC (anyone can use it)
-- ═══════════════════════════════════════════════════════════
-- Empty by default — machines are created in-game with /laundrycreator
-- (persisted in the database). You can still hard-code static machines
-- here using the schema above if you prefer; both sources work together.
Config.machines = {}

-- ─── Discord webhooks (optional, leave empty to disable) ──
Config.logs = {
    wash     = '',
    collect  = '',
    upgrade  = '',
    admin    = '',
}
Config.webhookColor = 2055679   -- Apex brand #1F5EFF in decimal
