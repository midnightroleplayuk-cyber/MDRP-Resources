--[[ Apex Laundry — Deutsch ]]
Locales = Locales or {}
Locales.de = {
    -- Benachrichtigungen
    n_no_permission   = 'Du hast keinen Zugriff auf diese Maschine.',
    n_no_dirty        = 'Du hast nicht genug Schwarzgeld.',
    n_no_cleaners     = 'Nicht genug Reinigungsmittel in der Maschine.',
    n_wash_started    = 'Waschvorgang gestartet.',
    n_wash_cancelled  = 'Wäsche abgebrochen — dein Schwarzgeld wurde zurückgegeben.',
    n_wash_collected  = '%s an sauberem Geld erhalten.',
    n_wash_in_progress= 'In dieser Maschine läuft bereits eine Wäsche.',
    n_no_wash         = 'In dieser Maschine läuft keine Wäsche.',
    n_wash_not_done   = 'Die Wäsche ist noch nicht fertig.',
    n_upgrade_ok      = 'Maschine verbessert.',
    n_upgrade_maxed   = 'Dieses Upgrade ist bereits auf maximalem Level.',
    n_upgrade_no_money= 'Du kannst dir dieses Upgrade nicht leisten.',
    n_cleaners_added  = '%s Reinigungsmittel in die Maschine geladen.',
    n_cleaners_full   = 'Diese Maschine kann keine weiteren Reinigungsmittel aufnehmen.',
    n_cleaners_none   = 'So viele Reinigungsmittel hast du nicht.',
    n_amount_invalid  = 'Ungültiger Betrag.',
    n_feature_off     = 'Diese Funktion ist auf diesem Server deaktiviert.',
    n_over_capacity   = 'Das übersteigt die Waschkapazität dieser Maschine.',
    n_not_near        = 'Du bist nicht in der Nähe einer Waschmaschine.',
    n_inventory_full  = 'Dein Inventar ist voll — schaffe Platz und versuche es erneut.',
    n_creator_placed    = 'Waschsalon platziert.',
    n_creator_removed   = 'Waschsalon entfernt.',
    n_creator_none      = 'Kein platzierter Waschsalon in der Nähe.',
    n_creator_cancelled = 'Platzierung abgebrochen.',
    n_creator_load_fail = 'Prop des Waschsalons konnte nicht geladen werden.',

    -- HUD / textui
    hud_use_machine   = 'Maschine benutzen',
    ld_world_label    = 'Maschine benutzen',
    ld_loader_status  = 'Verbinde mit Terminal',
    ld_loader_foot    = 'Verschlüsselt · Apex Wäsche-Netz',

    -- Wordmark
    wm_first          = 'APEX',
    wm_second         = 'LAUNDRY',

    -- Kopfzeile
    ui_brand          = 'Apex Waschsalon',
    ui_subtitle       = 'Geldwäsche-Terminal',
    ui_status_idle    = 'Inaktiv',
    ui_status_washing = 'Wäscht',
    ui_status_ready   = 'Bereit zum Abholen',
    ui_offline        = 'Kein Zugriff',

    -- Reinigungsmittel
    ui_cleaners       = 'Reinigungsmittel',
    ui_cleaners_sub   = 'Befülle die Maschine, um eine Wäsche zu starten',
    ui_in_stock       = 'In Maschine',
    ui_deposit        = 'Einzahlen',
    ui_units          = 'Einheiten',

    -- Wäsche
    ui_wash           = 'Geld waschen',
    ui_wash_sub       = 'Wandle Schwarzgeld in sauberes Geld um',
    ui_amount         = 'Betrag',
    ui_amount_ph      = 'Schwarzgeld-Betrag eingeben',
    ui_on_hand        = 'Verfügbar',
    ui_capacity       = 'Kapazität',
    ui_needs          = 'Benötigte Reiniger',
    ui_you_get        = 'Du erhältst',
    ui_start          = 'Wäsche starten',
    ui_max            = 'Max',
    ui_dirty          = 'Schwarzgeld',
    ui_clean          = 'Sauberes Geld',

    -- Aktive Wäsche
    ui_active         = 'Wäsche läuft',
    ui_remaining      = 'Verbleibende Zeit',
    ui_payout         = 'Auszahlung',
    ui_collect        = 'Abholen',
    ui_cancel         = 'Abbrechen',
    ui_complete       = 'Fertig',

    -- Upgrades
    ui_upgrades       = 'Upgrades',
    ui_level          = 'Stufe',
    ui_max_level      = 'Maximal',
    ui_upgrade        = 'Verbessern',
    ui_next           = 'Nächste',
    up_efficiency       = 'Effizienz',
    up_efficiency_desc  = 'Erhöht den maximalen Betrag, den du in einer einzigen Wäsche waschen kannst.',
    up_potency          = 'Leistung',
    up_potency_desc     = 'Verbessert die Hardware, um die Waschzeit zu verkürzen.',

    -- Fußzeile / Meta
    ui_tax_rate       = 'Steuer',
    ui_wash_rate      = 'Basisgeschwindigkeit',
    ui_close          = 'Schließen',
    ui_locked_title   = 'Zugriff verweigert',
    ui_locked_text    = 'Diese Maschine ist eingeschränkt. Du bist nicht berechtigt, sie zu bedienen.',

    -- Dialoge
    md_deposit_title  = 'Reinigungsmittel einzahlen',
    md_deposit_text   = 'Wie viele Einheiten möchtest du in die Maschine laden?',
    md_deposit_ph     = 'Einheiten',
    md_cancel_title   = 'Wäsche abbrechen?',
    md_cancel_text    = 'Dein Schwarzgeld wird zurückgegeben, aber bereits verbrauchte Reinigungsmittel sind verloren.',
    md_upgrade_title  = 'Upgrade bestätigen',
    md_upgrade_text   = '%s auf Stufe %s für %s verbessern?',
    md_confirm        = 'Bestätigen',
    md_dismiss        = 'Verwerfen',

    -- Einstellungen (pro Spieler)
    ui_settings       = 'Einstellungen',
    ui_brand_color    = 'Markenfarbe',
    ui_background     = 'Hintergrund',
    ui_position       = 'Position',
    ui_pos_left       = 'Links',
    ui_pos_center     = 'Mitte',
    ui_pos_right      = 'Rechts',
    ui_opacity        = 'Deckkraft',
    ui_size           = 'Größe',
    ui_size_s         = 'Klein',
    ui_size_m         = 'Mittel',
    ui_size_l         = 'Groß',
    ui_reset_default  = 'Zurücksetzen',
}
