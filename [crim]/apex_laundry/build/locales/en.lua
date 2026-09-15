--[[
    Apex Laundry — English locale (master / fallback)
    ────────────────────────────────────────────────────────────
    EN is the source of truth. Every other language overlays this
    table; any missing key falls back to English automatically.
]]

Locales = Locales or {}
Locales.en = {
    -- ─── Notifications ──────────────────────────────────
    n_no_permission   = 'You do not have access to this machine.',
    n_no_dirty        = 'You do not have enough dirty money.',
    n_no_cleaners     = 'Not enough cleaning supplies in the machine.',
    n_wash_started    = 'Wash cycle started.',
    n_wash_cancelled  = 'Wash cancelled — your dirty money was returned.',
    n_wash_collected  = 'Collected %s in clean money.',
    n_wash_in_progress= 'A wash is already running on this machine.',
    n_no_wash         = 'There is no wash running on this machine.',
    n_wash_not_done   = 'The wash is not finished yet.',
    n_upgrade_ok      = 'Machine upgraded.',
    n_upgrade_maxed   = 'This upgrade is already at the maximum level.',
    n_upgrade_no_money= 'You cannot afford this upgrade.',
    n_cleaners_added  = 'Loaded %s cleaning supplies into the machine.',
    n_cleaners_full   = 'This machine cannot hold any more cleaning supplies.',
    n_cleaners_none   = 'You do not have that many cleaning supplies.',
    n_amount_invalid  = 'Invalid amount.',
    n_feature_off     = 'That feature is disabled on this server.',
    n_over_capacity   = "That exceeds this machine's wash capacity.",
    n_not_near        = 'You are not near a laundromat machine.',
    n_inventory_full  = 'Your inventory is full — free some space and try again.',
    n_creator_placed    = 'Laundromat placed.',
    n_creator_removed   = 'Laundromat removed.',
    n_creator_none      = 'No placed laundromat nearby.',
    n_creator_cancelled = 'Placement cancelled.',
    n_creator_load_fail = 'Failed to load the laundromat prop.',

    -- ─── HUD / textui ───────────────────────────────────
    hud_use_machine   = 'Use the machine',
    ld_world_label    = 'Use the machine',
    ld_loader_status  = 'Connecting to terminal',
    ld_loader_foot    = 'Encrypted · Apex laundering grid',

    -- ─── Wordmark (split into two coloured halves) ───────
    wm_first          = 'Midnight',
    wm_second         = 'LAUNDRY',

    -- ─── Panel header ───────────────────────────────────
    ui_brand          = 'Apex Laundromat',
    ui_subtitle       = 'Money laundering terminal',
    ui_status_idle    = 'Idle',
    ui_status_washing = 'Laundering',
    ui_status_ready   = 'Ready to collect',
    ui_offline        = 'No access',

    -- ─── Cleaners card ──────────────────────────────────
    ui_cleaners       = 'Cleaning supplies',
    ui_cleaners_sub   = 'Fuel the machine to run a wash',
    ui_in_stock       = 'In machine',
    ui_deposit        = 'Deposit',
    ui_units          = 'units',

    -- ─── Wash card ──────────────────────────────────────
    ui_wash           = 'Launder money',
    ui_wash_sub       = 'Convert dirty money into clean money',
    ui_amount         = 'Amount',
    ui_amount_ph      = 'Enter dirty amount',
    ui_on_hand        = 'On hand',
    ui_capacity       = 'Capacity',
    ui_needs          = 'Cleaners needed',
    ui_you_get        = 'You receive',
    ui_start          = 'Start wash',
    ui_max            = 'Max',
    ui_dirty          = 'Dirty money',
    ui_clean          = 'Clean money',

    -- ─── Active wash ────────────────────────────────────
    ui_active         = 'Wash in progress',
    ui_remaining      = 'Time remaining',
    ui_payout         = 'Payout',
    ui_collect        = 'Collect',
    ui_cancel         = 'Cancel',
    ui_complete       = 'Complete',

    -- ─── Upgrades ───────────────────────────────────────
    ui_upgrades       = 'Upgrades',
    ui_level          = 'Level',
    ui_max_level      = 'Maxed',
    ui_upgrade        = 'Upgrade',
    ui_next           = 'Next',
    up_efficiency       = 'Efficiency',
    up_efficiency_desc  = 'Raises the maximum amount you can launder in a single wash.',
    up_potency          = 'Potency',
    up_potency_desc     = 'Upgrades the hardware to cut down wash time.',

    -- ─── Footer / meta ──────────────────────────────────
    ui_tax_rate       = 'Tax',
    ui_wash_rate      = 'Base speed',
    ui_close          = 'Close',
    ui_locked_title   = 'Access denied',
    ui_locked_text    = 'This machine is restricted. You are not authorised to operate it.',

    -- ─── Modals ─────────────────────────────────────────
    md_deposit_title  = 'Deposit cleaning supplies',
    md_deposit_text   = 'How many units do you want to load into the machine?',
    md_deposit_ph     = 'Units',
    md_cancel_title   = 'Cancel the wash?',
    md_cancel_text    = 'Your dirty money will be returned, but cleaning supplies already used are lost.',
    md_upgrade_title  = 'Confirm upgrade',
    md_upgrade_text   = 'Upgrade %s to level %s for %s?',
    md_confirm        = 'Confirm',
    md_dismiss        = 'Dismiss',

    -- ─── Settings (per-player) ──────────────────────────
    ui_settings       = 'Settings',
    ui_brand_color    = 'Brand colour',
    ui_background     = 'Background',
    ui_position       = 'Position',
    ui_pos_left       = 'Left',
    ui_pos_center     = 'Centre',
    ui_pos_right      = 'Right',
    ui_opacity        = 'Opacity',
    ui_size           = 'Size',
    ui_size_s         = 'Small',
    ui_size_m         = 'Medium',
    ui_size_l         = 'Large',
    ui_reset_default  = 'Reset to default',

    -- ─── Creator (admin placement menu) ─────────────────
    cr_title          = 'New Laundromat',
    cr_machine        = 'Machine',
    cr_access         = 'Access',
    cr_public         = 'Public',
    cr_jobs_hint      = 'Add the jobs that may use this machine (with a minimum grade).',
    cr_invisible      = 'Invisible prop',
    cr_place          = 'Place',
    cr_controls       = 'Placement controls',
    cr_rotate         = 'Rotate',
    cr_depth          = 'Push / Pull',
    cr_height         = 'Height',
    cr_add_job        = 'Add job…',
    cr_grade          = 'Grade',
}

-- ─── Resolver: Locales.t('key', ...) ─────────────────────
-- Resolves the active language (Config.locale) → English →
-- the raw key. Each %s is replaced by the next arg, in order.
function Locales.t(key, ...)
    local lang = (Config and Config.locale) or 'en'
    local s = (Locales[lang] and Locales[lang][key]) or Locales.en[key] or key
    if select('#', ...) == 0 then return s end
    local args, i = { ... }, 0
    return (s:gsub('%%s', function() i = i + 1; return tostring(args[i]) end))
end

-- ─── Active table for the NUI ────────────────────────────
-- Returns a FLAT table for the active language: the English base
-- with Config.locale overlaid, so untranslated keys still resolve
-- to English. Carries __lang so the NUI can set <html lang>. This
-- is what makes switching Config.locale actually change the UI.
function Locales.active(lang)
    lang = lang or (Config and Config.locale) or 'en'
    local out = {}
    for k, v in pairs(Locales.en or {}) do out[k] = v end
    if lang ~= 'en' and Locales[lang] then
        for k, v in pairs(Locales[lang]) do out[k] = v end
    end
    out.__lang = lang
    return out
end
