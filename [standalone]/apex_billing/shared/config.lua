--[[
    Apex Billing — Shared Config
    ────────────────────────────────────────────────────────────
    Every option is hot-editable. Restart the resource (or run
    /apex_billing_reload on the server console) to push changes
    to connected clients.
]]

Config = Config or {}

-- ═══════════════════════════════════════════════════════════
-- GENERAL
-- ═══════════════════════════════════════════════════════════
Config.debug        = false
Config.locale       = 'en'    -- 'en' | 'pt'
Config.framework    = 'qbx'  -- 'auto' | 'esx' | 'qb' | 'qbx'

-- Commands & keybind
Config.command       = 'billing'      -- /billing → open the panel
Config.keybind       = 'F7'           -- player can rebind in Settings → Key Bindings
Config.adminCommand  = 'billingadmin' -- /billingadmin

-- ─── Who counts as an admin ────────────────────────────────
-- The three checks below are OR'd together: pass ANY of them and
-- /billingadmin opens. Leave them all as-is and the usual server
-- admins (group.admin via ace, or the framework's own permission
-- level) get in without extra setup.
--
--   adminAce    — ace permission. Grant it in server.cfg with:
--                     add_ace group.admin apex_billing.admin allow
--                 `group.admin command allow` (the QBCore default)
--                 does NOT cover this — it only allows commands.
Config.adminAce      = 'apex_billing.admin'

--   adminAcceptCommandAce — also accept the built-in `command` ace.
--                 A stock QBCore server.cfg contains exactly one
--                 permission line, `add_ace group.admin command allow`,
--                 so this is what makes your existing admins work
--                 without editing anything. Set to false to demand
--                 the dedicated ace above instead.
Config.adminAcceptCommandAce = true

--   adminGroups — staff groups. On start-up the resource grants
--                 `adminAce` to `group.<name>` and `qbcore.<name>`
--                 for each entry, so a stock server needs no
--                 server.cfg edit at all. The player's framework
--                 permission level (QBCore GetPermission / QBox
--                 HasGroup / ESX getGroup) is checked too.
--                 Set to {} to disable this path entirely and
--                 manage the ace yourself.
Config.adminGroups   = { 'admin', 'superadmin', 'god' }

--   adminIdentifiers — hard-coded escape hatch. Accepts any
--                 identifier the server exposes (license:, steam:,
--                 discord:, fivem:) or a citizenid / ESX identifier.
--                 e.g. { 'license:110000112345678' }
Config.adminIdentifiers = {}

-- ═══════════════════════════════════════════════════════════
-- PROVIDERS — each one auto-detected by default
-- ═══════════════════════════════════════════════════════════
Config.providers = {
    notify    = 'auto', -- apex_notify | ox_lib | okok | mythic | esx | qb | none
    target    = 'auto', -- ox_target | qb-target | qtarget | none
    inventory = 'auto', -- ox_inventory | qb-inventory | qs-inventory | codem | esx | none
    banking   = 'auto', -- apex_banking | esx | qb | qbx  (where the money lives)
    logger    = 'webhook',
}

-- ═══════════════════════════════════════════════════════════
-- FEATURE TOGGLES — disable entire modules per server
-- ═══════════════════════════════════════════════════════════
Config.features = {
    -- WHO CAN SEND INVOICES. Both can be on at the same time.
    --
    --   societyInvoices  — members of a Config.societies job (with
    --                      their grade in issueGrades) bill on behalf
    --                      of the job. The money goes to the society
    --                      treasury. false = nobody bills as a society.
    --
    --   personalInvoices — EVERY player can bill another player.
    --                      The money goes to the issuer's own bank
    --                      account. Tune it in Config.personal below.
    --
    -- When a player can do both, the New tab shows a
    -- "Society / Personal" switch so they pick who is billing.
    -- With both false, players can only pay what they receive.
    societyInvoices   = true,
    personalInvoices  = false,
    templates         = true,    -- reusable invoice templates
    vat               = true,    -- VAT / tax line on invoices
    autoExpire        = true,    -- auto-decline past-due invoices
    autoShowOnReceive = true,    -- pop the invoice modal on receipt
    issueAnimation    = true,    -- play the "sign / hand over" gesture
    sounds            = true,    -- NUI click / cash sounds
    discordLogs       = true,    -- forward to Config.logs.*
    statsPanel        = true,    -- society treasurer stats card
    adminPanel        = true,    -- /billingadmin
}

-- ═══════════════════════════════════════════════════════════
-- UI THEME — mirrors apex_banking exactly
-- ═══════════════════════════════════════════════════════════
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

-- ═══════════════════════════════════════════════════════════
-- CURRENCY
-- ═══════════════════════════════════════════════════════════
Config.currency = {
    symbol   = '£',
    position = 'before',   -- 'before' = $100  · 'after' = 100€
    decimals = 2,
}

-- ═══════════════════════════════════════════════════════════
-- INVOICE NUMBERING
-- ═══════════════════════════════════════════════════════════
Config.invoice = {
    prefix         = 'INV',
    digits         = 6,           -- INV000123
    yearInNumber   = true,        -- INV-2026-000123
    defaultDueDays = 7,
    maxLineItems   = 30,
    minAmount      = 1,
    maxAmount      = 50000000,
}

-- ═══════════════════════════════════════════════════════════
-- VAT / TAX
-- ═══════════════════════════════════════════════════════════
Config.vat = {
    enabled     = false,
    defaultRate = 0.0,    -- 0.23 = 23%
    label       = 'VAT',
}

-- ═══════════════════════════════════════════════════════════
-- FEES (deducted from total on payment, sent to system)
-- ═══════════════════════════════════════════════════════════
Config.fees = {
    issuePersonal = 0,           -- flat fee per personal invoice issued
    issueSociety  = 0,           -- flat fee per society invoice issued
    paymentPct    = 0.00,        -- percentage taken from each paid invoice
    maxFee        = 5000,
}

-- ═══════════════════════════════════════════════════════════
-- PERSONAL INVOICES  (Config.features.personalInvoices = true)
-- Player → player billing. The amount limits are in Config.limits
-- (minPersonalInvoice / maxPersonalInvoice / maxPendingPerPlayer)
-- and the issue fee is Config.fees.issuePersonal.
--   requiredItem  — item the issuer must carry ('' = none needed)
--   givePaperItem — the recipient also gets the apex_invoice paper
--                   item (false = the invoice only pops on screen)
--   jobs          — {} = every player. To limit personal billing
--                   to some jobs: { 'realestate', 'lawyer' }
-- If the issuer is offline when the invoice is paid, the money is
-- kept and paid into their bank the next time they join.
-- ═══════════════════════════════════════════════════════════
Config.personal = {
    requiredItem  = '',
    givePaperItem = true,
    jobs          = {},
}

-- ═══════════════════════════════════════════════════════════
-- SOCIETY BILLING ROSTER
-- Per-job permissions for issuing society invoices.
--   enabled    — set false to hide this job from the society UI
--   label      — display name (overrides framework label)
--   bossGrades — only these grades can manage templates / settle
--   issueGrades — grades that can SEND invoices (employees+)
--   minIssue   — minimum invoice amount this job can charge
--   maxIssue   — maximum invoice amount this job can charge
--   defaultVat — VAT rate applied to fresh invoices (overrides Config.vat.defaultRate)
-- ═══════════════════════════════════════════════════════════
-- Per-society fields:
--   enabled       — show this job in the society UI
--   label         — display name (overrides framework label)
--   bossGrades    — only these grades can manage templates
--   issueGrades   — grades that can SEND invoices (employees+)
--   minIssue      — minimum invoice amount this job can charge
--   maxIssue      — maximum invoice amount this job can charge
--   defaultVat    — VAT rate applied to fresh invoices
--   requiredItem  — inventory item the employee MUST carry to
--                   send an invoice. '' or nil = no item required.
--                   Each society can have its own (a police
--                   ticket book, a mechanic invoice pad, etc.)
--   givePaperItem — when true, the recipient receives a copy of
--                   the apex_invoice paper item in their inventory.
--                   When false, the modal still pops on screen but
--                   no physical item is created.
Config.societies = {
    police = {
        enabled    = false,
        label      = 'MPC',
        bossGrades = { 4 },
        issueGrades = { 1, 2, 3, 4 },
        minIssue   = 50,
        maxIssue   = 25000,
        defaultVat = 0.0,
        requiredItem  = nil,
        givePaperItem = true,
    },
    ambulance = {
        enabled    = false,
        label      = 'MHS',
        bossGrades = { 4 },
        issueGrades = { 0, 1, 2, 3, 4 },
        minIssue   = 50,
        maxIssue   = 50000,
        defaultVat = 0.0,
        requiredItem  = 'ems_clipboard',
        givePaperItem = true,
    },
    mechanic = {
        enabled    = true,
        label      = 'Redline',
        bossGrades = { 3 },
        issueGrades = { 0, 1, 2, 3 },
        minIssue   = 100,
        maxIssue   = 250000,
        defaultVat = 0.23,
        requiredItem  = 'mechanic_invoicepad',
        givePaperItem = true,
    },
    taxi = {
        enabled    = true,
        label      = 'Downtown Cab Co.',
        bossGrades = { 2 },
        issueGrades = { 0, 1, 2 },
        minIssue   = 25,
        maxIssue   = 5000,
        defaultVat = 0.0,
        requiredItem  = '',      -- no item required for taxi
        givePaperItem = false,   -- pop the modal only, no item
    },
}

-- ═══════════════════════════════════════════════════════════
-- LIMITS
-- ═══════════════════════════════════════════════════════════
Config.limits = {
    minPersonalInvoice = 10,
    maxPersonalInvoice = 100000,
    maxPendingPerPlayer = 30,
    maxPendingPerSociety = 80,
}

-- ═══════════════════════════════════════════════════════════
-- AUTO-EXPIRE
-- ═══════════════════════════════════════════════════════════
Config.expiry = {
    checkIntervalMinutes = 15,
    graceDays            = 3,    -- days past due_at before status = 'expired'
    refundFeesOnExpire   = true, -- refund issuance fee back to issuer
}

-- ═══════════════════════════════════════════════════════════
-- ITEMS (inventory)
-- Only the paper item is global. Per-society "required to issue"
-- items live on the Config.societies entries.
-- ═══════════════════════════════════════════════════════════
Config.items = {
    invoicePaper = {
        name  = 'apex_invoice',
        label = 'Invoice',
        description = 'A printed invoice. Inspect it to view details and pay.',
    },
}

-- ═══════════════════════════════════════════════════════════
-- ANIMATION — simple gesture, no prop attached. Plays when an
-- invoice is issued so the action reads to other players nearby.
-- ═══════════════════════════════════════════════════════════
Config.animation = {
    dict        = 'mp_common',
    name        = 'givetake1_a',
    duration    = 1600,
    flag        = 48,            -- upper-body + hold last frame
}

-- ═══════════════════════════════════════════════════════════
-- ATM-FREE DROP-OFF — anywhere players can settle invoices
-- (besides at-bank / via UI). Default: only via UI / phone.
-- ═══════════════════════════════════════════════════════════
Config.payment = {
    methods    = { bank = true, cash = true, society = true },
    -- Default chosen method when the recipient clicks Pay
    defaultMethod = 'bank',
    -- Force payment to a specific provider's bank account
    bankProvider  = 'auto', -- 'auto' uses Config.providers.banking
}

-- ═══════════════════════════════════════════════════════════
-- DISCORD WEBHOOKS (optional)
-- ═══════════════════════════════════════════════════════════
Config.logs = {
    issued   = '',
    paid     = '',
    declined = '',
    admin    = '',
    avatarUrl = '',
    username  = 'Apex Billing',
}

-- ═══════════════════════════════════════════════════════════
-- QUICK PRESETS — populate the "Quick amount" buttons in the UI
-- ═══════════════════════════════════════════════════════════
Config.quickAmounts = { 50, 100, 250, 500, 1000, 2500, 5000 }




