--[[
    Apex Billing — German (DE) locale
]]

Locales = Locales or {}
Locales.de = {
    -- Benachrichtigungen
    n_issued_ok        = 'Rechnung #%s ausgestellt — %s.',
    n_received_invoice = 'Du hast eine Rechnung von %s erhalten — %s.',
    n_paid_ok          = 'Rechnung #%s bezahlt (%s).',
    n_paid_in          = '%s hat die Rechnung #%s bezahlt — %s.',
    n_declined_ok      = 'Rechnung #%s abgelehnt.',
    n_declined_in      = '%s hat die Rechnung #%s abgelehnt.',
    n_amount_invalid   = 'Ungültiger Betrag.',
    n_no_funds         = 'Du hast nicht genug Geld, um diese Rechnung zu bezahlen.',
    n_no_society_funds = 'Die Firmenkasse kann diese Rechnung nicht decken.',
    n_no_printer       = 'Du benötigst einen Rechnungsdrucker, um Rechnungen auszustellen.',
    n_no_recipient     = 'Es wurde kein Empfänger ausgewählt.',
    n_no_perm          = 'Du hast keine Berechtigung, Rechnungen für diesen Beruf auszustellen.',
    n_inv_not_found    = 'Rechnung nicht gefunden.',
    n_inv_already_paid = 'Diese Rechnung wurde bereits bezahlt.',
    n_inv_expired      = 'Diese Rechnung ist abgelaufen.',
    n_too_many_pending = 'Du hast zu viele offene Rechnungen.',
    n_self_billed      = 'Du kannst dir selbst keine Rechnung ausstellen.',
    n_payout_received  = 'Während deiner Abwesenheit bezahlte Rechnungen: %s auf dein Konto gutgeschrieben.',

    -- HUD
    hud_open_billing   = 'Abrechnung öffnen',

    -- UI
    wm_first           = 'APEX',
    wm_second          = 'BILLING',
    ui_brand           = 'Apex Billing',
    ui_dashboard       = 'Übersicht',
    ui_new_invoice     = 'Neue Rechnung',
    ui_sent            = 'Gesendet',
    ui_received        = 'Erhalten',
    ui_society         = 'Firma',
    ui_templates       = 'Vorlagen',
    ui_settings        = 'Einstellungen',

    ui_recipient       = 'Empfänger',
    ui_recipient_hint  = 'Wähle einen Spieler in der Nähe oder füge eine Bürger-ID ein',
    ui_title           = 'Titel',
    ui_due_date        = 'Fällig am',
    ui_line_items      = 'Positionen',
    ui_add_item        = 'Position hinzufügen',
    ui_qty             = 'Anz',
    ui_unit_price      = 'Preis',
    ui_subtotal        = 'Zwischensumme',
    ui_vat             = 'MwSt',
    ui_total           = 'Gesamt',
    ui_send_invoice    = 'Rechnung senden',
    ui_save_template   = 'Als Vorlage speichern',
    ui_pay             = 'Bezahlen',
    ui_decline         = 'Ablehnen',
    ui_cancel          = 'Abbrechen',

    ui_status_draft    = 'Entwurf',
    ui_status_sent     = 'Offen',
    ui_status_paid     = 'Bezahlt',
    ui_status_declined = 'Abgelehnt',
    ui_status_expired  = 'Abgelaufen',
    ui_status_cancelled= 'Storniert',

    ui_empty_sent      = 'Noch keine Rechnungen gesendet.',
    ui_empty_received  = 'Keine Rechnungen erhalten.',
    ui_empty_society   = 'Noch keine Firmenrechnungen.',
    ui_empty_template  = 'Noch keine Vorlagen.',
}
