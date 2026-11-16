--[[
    Apex Billing — French (FR) locale
]]

Locales = Locales or {}
Locales.fr = {
    -- Notifications
    n_issued_ok        = 'Facture #%s émise — %s.',
    n_received_invoice = 'Vous avez reçu une facture de %s — %s.',
    n_paid_ok          = 'Facture #%s payée (%s).',
    n_paid_in          = '%s a payé la facture #%s — %s.',
    n_declined_ok      = 'Facture #%s refusée.',
    n_declined_in      = '%s a refusé la facture #%s.',
    n_amount_invalid   = 'Montant invalide.',
    n_no_funds         = "Vous n'avez pas assez d'argent pour payer cette facture.",
    n_no_society_funds = "Le trésor de la société ne peut pas couvrir cette facture.",
    n_no_printer       = "Vous avez besoin d'une Imprimante à Factures pour émettre des factures.",
    n_no_recipient     = "Aucun destinataire sélectionné.",
    n_no_perm          = "Vous n'avez pas la permission d'émettre des factures pour ce travail.",
    n_inv_not_found    = 'Facture introuvable.',
    n_inv_already_paid = 'Cette facture a déjà été payée.',
    n_inv_expired      = 'Cette facture a expiré.',
    n_too_many_pending = 'Vous avez trop de factures en attente.',
    n_self_billed      = 'Vous ne pouvez pas vous facturer vous-même.',
    n_payout_received  = 'Factures payées pendant votre absence : %s versés sur votre compte.',

    -- HUD
    hud_open_billing   = 'Ouvrir la facturation',

    -- UI
    wm_first           = 'APEX',
    wm_second          = 'BILLING',
    ui_brand           = 'Apex Billing',
    ui_dashboard       = 'Tableau de bord',
    ui_new_invoice     = 'Nouvelle Facture',
    ui_sent            = 'Envoyées',
    ui_received        = 'Reçues',
    ui_society         = 'Société',
    ui_templates       = 'Modèles',
    ui_settings        = 'Paramètres',

    ui_recipient       = 'Destinataire',
    ui_recipient_hint  = "Choisis un joueur à proximité ou colle un ID citoyen",
    ui_title           = 'Titre',
    ui_due_date        = 'Échéance',
    ui_line_items      = 'Lignes',
    ui_add_item        = 'Ajouter une ligne',
    ui_qty             = 'Qté',
    ui_unit_price      = 'Prix',
    ui_subtotal        = 'Sous-total',
    ui_vat             = 'TVA',
    ui_total           = 'Total',
    ui_send_invoice    = 'Envoyer la facture',
    ui_save_template   = 'Enregistrer comme modèle',
    ui_pay             = 'Payer',
    ui_decline         = 'Refuser',
    ui_cancel          = 'Annuler',

    ui_status_draft    = 'Brouillon',
    ui_status_sent     = 'En attente',
    ui_status_paid     = 'Payée',
    ui_status_declined = 'Refusée',
    ui_status_expired  = 'Expirée',
    ui_status_cancelled= 'Annulée',

    ui_empty_sent      = 'Aucune facture envoyée.',
    ui_empty_received  = 'Aucune facture reçue.',
    ui_empty_society   = 'Aucune facture de société.',
    ui_empty_template  = 'Aucun modèle.',
}
