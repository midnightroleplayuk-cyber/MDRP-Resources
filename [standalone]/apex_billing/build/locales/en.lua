Locales = Locales or {}
Locales.en = {
    -- ─── Notifications ─────────────────────────────────────
    n_issued_ok        = 'Invoice #%s issued — %s.',
    n_received_invoice = 'You received an invoice from %s — %s.',
    n_paid_ok          = 'Invoice #%s paid (%s).',
    n_paid_in          = '%s paid invoice #%s — %s.',
    n_declined_ok      = 'Invoice #%s declined.',
    n_declined_in      = '%s declined invoice #%s.',
    n_amount_invalid   = 'Invalid amount.',
    n_no_funds         = 'You do not have enough money to pay this invoice.',
    n_no_society_funds = 'The society treasury cannot cover this invoice.',
    n_no_printer       = 'You need an Invoice Printer to issue invoices.',
    n_no_recipient     = 'No recipient was selected.',
    n_no_perm          = 'You do not have permission to issue invoices for this job.',
    n_inv_not_found    = 'Invoice not found.',
    n_inv_already_paid = 'This invoice has already been paid.',
    n_inv_expired      = 'This invoice has expired.',
    n_too_many_pending = 'You have too many pending invoices.',
    n_self_billed      = 'You cannot bill yourself.',
    n_payout_received  = 'Invoices paid while you were away: %s added to your bank.',

    -- ─── HUD ───────────────────────────────────────────────
    hud_open_billing   = 'Open billing',

    -- ─── UI ────────────────────────────────────────────────
    wm_first           = 'APEX',
    wm_second          = 'BILLING',
    ui_brand           = 'Apex Billing',
    ui_dashboard       = 'Dashboard',
    ui_new_invoice     = 'New Invoice',
    ui_sent            = 'Sent',
    ui_received        = 'Received',
    ui_society         = 'Society',
    ui_templates       = 'Templates',
    ui_settings        = 'Settings',

    ui_recipient       = 'Recipient',
    ui_recipient_hint  = 'Pick a nearby player or paste a citizen ID',
    ui_title           = 'Title',
    ui_due_date        = 'Due',
    ui_line_items      = 'Line items',
    ui_add_item        = 'Add item',
    ui_qty             = 'Qty',
    ui_unit_price      = 'Unit',
    ui_subtotal        = 'Subtotal',
    ui_vat             = 'VAT',
    ui_total           = 'Total',
    ui_send_invoice    = 'Send invoice',
    ui_save_template   = 'Save as template',
    ui_pay             = 'Pay',
    ui_decline         = 'Decline',
    ui_cancel          = 'Cancel',

    ui_status_draft    = 'Draft',
    ui_status_sent     = 'Pending',
    ui_status_paid     = 'Paid',
    ui_status_declined = 'Declined',
    ui_status_expired  = 'Expired',
    ui_status_cancelled= 'Cancelled',

    ui_empty_sent      = 'No invoices sent yet.',
    ui_empty_received  = 'No invoices received.',
    ui_empty_society   = 'No society invoices yet.',
    ui_empty_template  = 'No templates yet.',
}

function Locales.t(key, ...)
    local lang = (Config and Config.locale) or 'en'
    local s = (Locales[lang] and Locales[lang][key]) or Locales.en[key] or key
    local n = select('#', ...)
    if n == 0 then return s end
    local args, i = { ... }, 0
    return (s:gsub('%%s', function() i = i + 1; return tostring(args[i]) end))
end
