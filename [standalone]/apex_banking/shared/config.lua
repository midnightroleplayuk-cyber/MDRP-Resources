--[[
    Apex Banking — Shared Config
    ────────────────────────────────────────────────────────────
    All user-facing settings. Bank LOCATIONS are defined in
    Config.banks below. NO JSON FILES are used anywhere in this
    resource — everything that needs to persist goes through the
    database. Edit this file + restart (or /apex_banking_reload)
    to broadcast new locations to every client.
]]

Config = Config or {}

-- ─── General ──────────────────────────────────────────────
Config.debug         = false
Config.locale        = 'en'           -- 'en' | 'pt' | 'es' | 'fr' | 'de'
Config.resourceName  = GetCurrentResourceName()

-- ATM front-end: true = realistic DUI ATM rendered on the prop's own
-- screen (atmdui/ — tune it in atmdui/config.lua); false = the classic
-- fullscreen NUI ATM terminal.
Config.useDuiAtm     = true

-- ─── Framework override (auto-detected by default) ───────
-- Leave 'auto' to pick the running framework automatically.
-- Force a specific one only if you run multiple at once.
-- Supported: 'auto' | 'esx' | 'qb' | 'qbx'
Config.framework     = 'qbx'

-- ═══════════════════════════════════════════════════════════
-- PROVIDERS — plug into the resources you already run on
-- your server. Set each one to 'auto' to detect at runtime,
-- to a specific provider name to force it, or to 'none' to
-- disable the integration entirely.
-- ═══════════════════════════════════════════════════════════
Config.providers = {
    -- Notifications — 'auto' picks the first available in the
    -- order: apex_notify → ox_lib → okokNotify → esx/qb default
    -- → built-in NUI toast.
    -- Supported: 'auto' | 'apex_notify' | 'ox_lib' | 'okok'
    --          | 'mythic' | 'esx' | 'qb' | 'custom' | 'none'
    notify    = 'ox_lib',

    -- Target system for the bank teller ped. Falls back to
    -- Config.interaction (textui) if no target resource is
    -- found and target is requested.
    -- Supported: 'auto' | 'ox_target' | 'qb-target' | 'qtarget'
    --          | 'interact' | 'none'
    target    = 'ox_target',

    -- Interaction prompt ("[E] Open the bank / Use the ATM") shown
    -- when Config.interaction is NOT 'target'. Pick the look:
    --   'auto'/'apex' = built-in floating 3D NUI marker (showcase look)
    --   'ox_lib'      = ox_lib lib.showTextUI
    --   'qb'          = qb-core DrawText
    --   'custom'      = Integrations.OnPrompt (your own)
    --   'none'        = no prompt
    -- Customise it fully in shared/integrations.lua.
    textui    = 'ox_lib',

    -- Inventory provider for the apex_atm_card item metadata.
    -- ox_inventory is strongly recommended — it lets the card
    -- carry per-card serial metadata. Other providers fall back
    -- to "any card in inventory = primary card".
    -- Supported: 'auto' | 'ox_inventory' | 'qb-inventory'
    --          | 'esx' | 'qs-inventory' | 'codem' | 'none'
    inventory = 'ox_inventory',

    -- Phone integration (optional). Used to surface in-app
    -- transfer requests if your phone resource exposes the right
    -- exports. Set to 'none' to skip.
    -- Supported: 'auto' | 'qb-phone' | 'roadphone' | 'lb-phone' | 'none'
    phone     = 'apex_phone',

    -- Logging sink. Default 'webhook' uses Config.logs.* URLs.
    -- 'fivem_logs' emits to txAdmin live console only.
    -- 'custom' calls Integrations.OnLog(payload).
    logger    = 'webhook',
}

-- ═══════════════════════════════════════════════════════════
-- FEATURE TOGGLES — enable/disable entire modules per server.
-- Disabled modules still keep their DB tables (so you can flip
-- them back on without losing data) but the UI panes hide and
-- the server callbacks return 'disabled'.
-- ═══════════════════════════════════════════════════════════
Config.features = {
    bank          = true,    -- the bank dashboard itself
    atm           = true,    -- ATM interaction + card flow
    transfers     = true,    -- IBAN transfers between accounts
    cards         = true,    -- debit-card issuance, freeze, revoke
    savings       = true,    -- savings pot w/ compounding interest
    loans         = true,    -- loans + trust-tier ceiling
    subAccounts   = true,    -- shared business / crew / family wallets
    business      = true,    -- job treasuries + auto-payroll
    billing       = true,    -- invoices tab (apex_billing integration)
    vehicleFinance= true,    -- vehicle finance tab (apex_dealerships integration)
    history       = true,    -- transactions tab
    privacyMode   = true,    -- "hide balances" toggle in settings
    settings      = true,    -- the Settings pane (theme/appearance)
    onboarding    = true,    -- first-visit fingerprint ceremony
    adminPanel    = true,    -- /bankadmin command
    blips         = true,    -- map blips for banks (+ optional ATMs)
    worldMarkers  = true,    -- in-world 3D markers on bank peds
    interactAnim  = true,    -- player animation when opening bank/ATM
    sounds        = false,   -- NUI click / cash / chime sounds
}

-- ─── Admin permission ─────────────────────────────────────
-- A staff member passes if ANY ONE of these matches (OR logic), so a
-- freshly-installed server needs NO extra server.cfg line:
--   1. Config.adminAce                    → add_ace group.admin apex_banking.admin allow
--   2. the ACE `command` / `command.<cmd>` → already granted by the
--      `add_ace group.admin command allow` line that ESX, QBCore, QBox
--      and the txAdmin recipes all ship with by default
--   3. Config.adminGroups                 → the framework's own admin
--      group (ESX `setgroup <id> admin`, QBCore qbcore.admin/god)
-- Set Config.adminStrict = true to disable path 2 and require the
-- explicit ACE / group instead.
Config.adminAce      = 'apex_banking.admin'
Config.adminGroups   = { 'admin', 'superadmin', 'god' }
Config.adminStrict   = false
Config.adminCommand  = 'bankadmin'
-- /bank opens the menu when the player stands at a bank. Set to false to
-- not register the command at all: players then open the bank in person
-- only, at the counter (E or target).
Config.bankCommand   = false
Config.atmCardCommand = 'atmcard'  -- /atmcard → admin gives self a card

-- Admin-only theme preview: opens the nearest bank and cycles every
-- theme and layout on YOUR screen so you can pick one before setting it
-- server-wide in /bankadmin → Appearance. Nothing is broadcast.
-- Set to false to not register the command at all.
Config.showcaseCommand = false

-- ─── Interaction ──────────────────────────────────────────
-- 'target'  = look-at + on-screen interaction (eye)
-- 'textui'  = proximity + key press
Config.interaction       = 'target'
Config.textUIKey         = 38      -- E
Config.textUIDistance    = 2.0
Config.targetMaxDistance = 3.5

-- ─── Text-UI prompt position (ox_lib / qb providers) ──────
-- The built-in 3D NUI marker ignores this (it floats in the world);
-- ox_lib / qb text-ui use it for the on-screen box position.
Config.textui = {
    position = 'left-center',   -- 'left-center'|'right-center'|'top-center'|'bottom-center'
}

-- ─── Optional native ground marker ────────────────────────
-- Off by default (the floating NUI marker is the showcase look). Turn
-- on to also draw a classic GTA cylinder on the ground at each bank /
-- ATM. Fully editable in shared/integrations.lua (DrawWorldMarker).
Config.marker = {
    enabled = false,
    type    = 1,
    color   = { r = 31, g = 94, b = 255, a = 120 },
    scale   = { x = 1.2, y = 1.2, z = 0.6 },
    zOffset = 0.95,
    bob     = false,
    rotate  = false,
}

-- ─── UI Theme (matches apex_restaurant creator palette) ───
-- Brand is Apex blue #1F5EFF (same as apex_restaurant's default).
-- The neutral surface stack is intentionally hue-free so the
-- brand colour reads cleanly against it.
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
Config.currency = {
    symbol   = '£',
    position = 'before',   -- 'before' = $100   'after' = 100 €
}

-- ─── Notifications (routed through apex_notify export) ────
Config.notify = {
    position = 'top-right',
    duration = 5000,
    title    = 'Banking',
}

-- ─── IBAN generator ───────────────────────────────────────
-- Each player + sub-account gets a unique IBAN-style identifier.
-- Format: prefix + N random digits (no spaces in storage; UI
-- groups them in chunks of 4 for readability).
Config.iban = {
    prefix     = 'MN',
    digits     = 10,
    groupBy    = 4,         -- UI display: AP12 3456 7890
}

-- ─── PIN code ─────────────────────────────────────────────
-- PINs are required for ATM card use. Bank counter (in-person)
-- does NOT require PIN — we trust the teller. Length is
-- enforced both client & server side.
Config.pin = {
    length    = 4,
    maxTries  = 3,    -- after this many wrong PINs the card is
                       -- temporarily locked at the ATM (one in-game
                       -- hour) and the player must visit a bank.
    lockoutMs = 60 * 60 * 1000,
}

-- ─── Fees ────────────────────────────────────────────────
-- All amounts in raw currency units. Set to 0 to disable.
Config.fees = {
    atmWithdraw      = 0,        -- flat
    atmWithdrawPct   = 0.00,     -- + percentage (0.01 = 1%)
    transferDomestic = 0,        -- flat fee per outgoing transfer
    transferPct      = 0.00,     -- percentage (e.g. 0.005 = 0.5%)
    newCard          = 250,
    newSubAccount    = 5000,
    changePin        = 500,
    changeIban       = 5000,
    savingsClose     = 100,
}

-- ─── Limits ───────────────────────────────────────────────
Config.limits = {
    minTransfer       = 1,
    maxTransfer       = 9999999,
    minDeposit        = 1,
    maxDeposit        = 9999999,
    minWithdraw       = 1,
    maxWithdraw       = 50000,       -- per ATM withdrawal
    dailyAtmWithdraw  = 100000,      -- per real-time 24h window
    minLoanAmount     = 1000,
    maxLoanAmount     = 250000,
    minSavingsDeposit = 100,
}

-- ─── Savings account interest (compounded per tick) ───────
Config.savings = {
    enabled       = true,
    -- Interest rate per tick (e.g. 0.0025 = 0.25% per tick).
    -- Default tick = 60 in-game minutes (≈ 2 real-time minutes).
    ratePerTick   = 0.0025,
    tickMinutes   = 60,
    -- A penalty applied when the player closes the savings
    -- pot before the lock-in period. Percentage of accrued interest.
    earlyClosePct = 0.50,
    lockInMinutes = 180,
}

-- ─── Loans ────────────────────────────────────────────────
Config.loans = {
    enabled         = true,
    -- Maximum loan as a multiple of the player's current
    -- main-account balance + savings (anti-cheese). Set to 0
    -- to disable the balance-derived cap entirely (the trust
    -- ceiling then becomes the only limit).
    maxMultiplier   = 4.0,
    interestPct     = 0.05,   -- 5% flat interest applied on issuance
    termDays        = 7,      -- repayment window (real-time days)
    autoCollect     = true,

    -- ── Trust / credit tier system ────────────────────────
    -- Every fully-repaid loan raises the player's borrowing
    -- ceiling. The math is:
    --   trust   = min(maxTrust, paidLoans*trustPerLoan
    --                          + totalRepaid/trustPerDollar)
    --   ceiling = Config.limits.maxLoanAmount * (1 + trust)
    -- So a player who already paid back 5 loans (5×0.20 = 1.0
    -- trust) can borrow 2× the base ceiling next time.
    trust = {
        enabled        = true,
        trustPerLoan   = 0.20,    -- bonus from each closed loan
        trustPerDollar = 50000,   -- $1 of repaid principal = 1/50,000 trust
        maxTrust       = 3.0,     -- absolute ceiling on the multiplier
    },
}

-- ─── Sub-accounts ─────────────────────────────────────────
-- Sub-accounts are shared wallets (e.g. business / family /
-- crew) that can hold multiple partners with per-partner
-- permissions (view, deposit, withdraw, transfer, manage).
Config.subAccounts = {
    enabled         = true,
    maxPerPlayer    = 5,
    maxPartners     = 12,
    defaultLabel    = 'Sub Account',
}

-- ─── ATM card item ────────────────────────────────────────
-- The script ships with a single inventory item — apex_atm_card.
-- Players can withdraw/deposit at ATMs ONLY if they carry this
-- item. The item carries metadata identifying which account it
-- is linked to (so stealing someone's card means stealing access
-- to their main account, *not* their identity).
Config.card = {
    item           = 'apex_atm_card',
    requireAtAtm   = true,
    autoIssueOnFirstBankVisit = true,  -- give a card the very first
                                       -- time a player walks into a bank
    label          = 'Debit Card',
}

-- ─── ATM models ───────────────────────────────────────────
Config.atmModels = {
    'prop_fleeca_atm',
    'prop_atm_01',
    'prop_atm_02',
    'prop_atm_03',
}

-- ─── Admin ATM placer ─────────────────────────────────────
-- /placeatm (admin only) spawns a transparent ghost ATM you aim
-- with the camera, rotate with the scroll wheel and drop with E.
-- Placed ATMs persist in the database, spawn for every player and
-- work exactly like map ATMs (same prop-model interaction).
-- /removeatm deletes the closest placed ATM (within 5 m).
Config.atmAdmin = {
    command       = 'placeatm',
    removeCommand = 'removeatm',
    maxDistance   = 12.0,   -- how far from the camera the ghost can sit
}

-- ─── Bank blips ───────────────────────────────────────────
Config.blips = {
    bank = { sprite = 108, color = 7,  scale = 0.85, label = 'Bank' },
    atm  = { sprite = 207, color = 2,  scale = 0.55, label = 'ATM',  enabled = false },
}

-- ─── Bank locations ───────────────────────────────────────
-- Source of truth for every bank in the world. Edit this list
-- to add / remove / move locations, then run
--     /apex_banking_reload
-- on the server console to broadcast the updated list to every
-- connected client without restarting the resource.
Config.banks = {
    {
        id         = 'pacific',
        label      = 'Legion Square',
        ped        = { model = 'ig_bankman', coords = vec4(103.51, -1096.49, 28.65, 239.93) },
        marker     = vec3(103.51, -1096.49, 28.65),
        blip       = true,
    },
    {
        id         = 'rockford',
        label      = 'Rockford Hills',
        ped        = { model = 'ig_bankman', coords = vec4(-1211.8585, -331.9854, 37.7809, 28.5983) },
        marker     = vec3(-1212.63, -330.78, 37.59),
        blip       = true,
    },
    {
        id         = 'great_ocean',
        label      = 'Great Ocean',
        ped        = { model = 'ig_bankman', coords = vec4(-2961.0720, 483.1107, 15.6970, 88.1986) },
        marker     = vec3(-2962.47, 482.93, 15.5),
        blip       = true,
    },
    {
        id         = 'paleto',
        label      = 'Paleto Bay',
        ped        = { model = 'ig_bankman', coords = vec4(-112.2223, 6471.1128, 31.6267, 132.7517) },
        marker     = vec3(-113.01, 6470.24, 31.43),
        blip       = true,
    },
    {
        id         = 'mission_row',
        label      = 'Mission Row',
        ped        = { model = 'ig_bankman', coords = vec4(313.8176, -280.5338, 54.1647, 339.1609) },
        marker     = vec3(314.16, -279.09, 53.97),
        blip       = true,
    },
    {
        id         = 'morningwood',
        label      = 'Morningwood',
        ped        = { model = 'ig_bankman', coords = vec4(-351.3247, -51.3466, 49.0365, 339.3305) },
        marker     = vec3(-350.99, -49.99, 48.84),
        blip       = true,
    },
    {
        id         = 'sandy_shores',
        label      = 'Sandy Shores',
        ped        = { model = 'ig_bankman', coords = vec4(1174.9718, 2708.2034, 38.0879, 178.2974) },
        marker     = vec3(1175.02, 2706.87, 37.89),
        blip       = true,
    },
    {
        id         = 'vinewood',
        label      = 'Vinewood',
        ped        = { model = 'ig_bankman', coords = vec4(247.0348, 225.1851, 106.2875, 158.7528) },
        marker     = vec3(246.63, 223.62, 106.0),
        blip       = true,
    },
}

-- ─── Discord webhooks (optional, leave empty to disable) ──
-- There is NO bot and NO token: the server POSTs straight to a
-- Discord *webhook URL*. To get one, in Discord open the channel →
-- Edit Channel → Integrations → Webhooks → New Webhook → Copy
-- Webhook URL, and paste it below. One URL per category, or the
-- same URL in several (or all) of them. An empty string turns that
-- category off. Requires Config.providers.logger = 'webhook'
-- (the default).
--
--   deposit  : bank/ATM deposits, savings pay-ins, sub-account pay-ins
--   withdraw : bank/ATM withdrawals, savings pay-outs, sub-account pay-outs
--   transfer : IBAN transfers (one post per transfer, with fee)
--   card     : card issued / frozen / unfrozen / revoked
--   loan     : loan granted / repaid
--   admin    : every action taken from /bankadmin
Config.logs = {
    deposit    = '',   -- 'https://discord.com/api/webhooks/…'
    withdraw   = '',
    transfer   = '',
    card       = '',
    loan       = '',
    admin      = '',
}

-- ─── Business / job accounts (payroll) ───────────────────
-- Jobs are AUTO-DISCOVERED from your framework's database at
-- boot:
--   • ESX  → `jobs` + `job_grades` tables
--   • QB   → QBCore.Shared.Jobs (cached in memory)
--
-- The treasury for each job is the SAME money as the framework's
-- society account (so `society_police` and Apex Bank's "police"
-- card are the same balance — bosses can move money in/out
-- through Apex and other resources still see it).
--
-- For each grade we DERIVE a default wage from the framework
-- (ESX stores it in `job_grades.salary`; QB in
-- `QBCore.Shared.Jobs[job].grades[grade].payment`). Bosses can
-- override the wage per-grade and pick a SEPARATE payInterval
-- per grade if they want different cadences for entry vs senior
-- staff. Bosses can also send one-off BONUSES to any online
-- employee.
Config.business = {
    enabled       = true,

    -- How often the payroll/scheduler thread fires.
    payTickMs     = 60 * 1000,

    -- Per-grade pay interval bounds (minutes). The minimum
    -- prevents abuse (1-second pay loops).
    minPayInterval     = 5,
    maxPayInterval     = 1440,    -- 24 h
    defaultPayInterval = 60,      -- minutes, used when the boss
                                  -- hasn't picked an interval yet
                                  -- AND framework doesn't carry one
    defaultBossGrades  = { 4 },   -- when DB doesn't tell us who's
                                  -- a boss, assume the top grade is

    -- Bonus payments (one-off, in addition to scheduled payroll)
    bonus = {
        enabled = true,
        max     = 100000,         -- per single bonus, anti-fat-finger
    },

    -- Per-job overrides — only needed when the DB-derived
    -- defaults don't match what you want. Anything missing
    -- here falls back to the framework values. Use the same
    -- keys as before (bossGrades, label, grades[grade].wage,
    -- grades[grade].payInterval) — they OVERRIDE the DB row.
    overrides = {
        -- Example:
        -- police = {
        --     bossGrades = { 4, 5, 6 },
        --     grades = {
        --         [6] = { wage = 5000, payInterval = 30 },
        --     },
        -- },
    },

    -- When false the Apex business treasury is its own pool
    -- (stored in apex_banking_business.balance). When true the
    -- balance MIRRORS the framework's society account
    -- (society_<job>) — recommended so multiple resources share
    -- the same money.
    syncSocietyMoney = true,
}

-- ─── Hot reload pulse ─────────────────────────────────────
-- After editing Config.banks above, run the console command
--     apex_banking_reload
-- to push the new locations to every connected client. No
-- resource restart required.
Config.hotReload = true
