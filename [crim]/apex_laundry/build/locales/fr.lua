--[[ Apex Laundry — Français ]]
Locales = Locales or {}
Locales.fr = {
    -- Notifications
    n_no_permission   = "Vous n'avez pas accès à cette machine.",
    n_no_dirty        = "Vous n'avez pas assez d'argent sale.",
    n_no_cleaners     = "Pas assez de produits d'entretien dans la machine.",
    n_wash_started    = 'Cycle de lavage démarré.',
    n_wash_cancelled  = 'Lavage annulé — votre argent sale a été rendu.',
    n_wash_collected  = 'Vous avez récupéré %s en argent propre.',
    n_wash_in_progress= 'Un lavage est déjà en cours sur cette machine.',
    n_no_wash         = "Aucun lavage n'est en cours sur cette machine.",
    n_wash_not_done   = "Le lavage n'est pas encore terminé.",
    n_upgrade_ok      = 'Machine améliorée.',
    n_upgrade_maxed   = 'Cette amélioration est déjà au niveau maximum.',
    n_upgrade_no_money= "Vous n'avez pas les moyens pour cette amélioration.",
    n_cleaners_added  = "Vous avez chargé %s produits d'entretien dans la machine.",
    n_cleaners_full   = "Cette machine ne peut pas contenir plus de produits d'entretien.",
    n_cleaners_none   = "Vous n'avez pas autant de produits d'entretien.",
    n_amount_invalid  = 'Montant invalide.',
    n_feature_off     = 'Cette fonctionnalité est désactivée sur ce serveur.',
    n_over_capacity   = 'Cela dépasse la capacité de lavage de cette machine.',
    n_not_near        = "Vous n'êtes pas près d'une machine de laverie.",
    n_inventory_full  = "Votre inventaire est plein — libérez de la place et réessayez.",
    n_creator_placed    = 'Laverie placée.',
    n_creator_removed   = 'Laverie supprimée.',
    n_creator_none      = "Aucune laverie placée à proximité.",
    n_creator_cancelled = 'Placement annulé.',
    n_creator_load_fail = "Échec du chargement du prop de la laverie.",

    -- HUD / textui
    hud_use_machine   = 'Utiliser la machine',
    ld_world_label    = 'Utiliser la machine',
    ld_loader_status  = 'Connexion au terminal',
    ld_loader_foot    = 'Chiffré · Réseau de blanchiment Apex',

    -- Wordmark
    wm_first          = 'APEX',
    wm_second         = 'LAUNDRY',

    -- En-tête
    ui_brand          = 'Laverie Apex',
    ui_subtitle       = "Terminal de blanchiment d'argent",
    ui_status_idle    = 'Inactive',
    ui_status_washing = 'Lavage',
    ui_status_ready   = 'Prêt à récupérer',
    ui_offline        = 'Aucun accès',

    -- Produits d'entretien
    ui_cleaners       = "Produits d'entretien",
    ui_cleaners_sub   = 'Alimentez la machine pour lancer un lavage',
    ui_in_stock       = 'Dans la machine',
    ui_deposit        = 'Déposer',
    ui_units          = 'unités',

    -- Lavage
    ui_wash           = "Blanchir l'argent",
    ui_wash_sub       = "Convertit l'argent sale en argent propre",
    ui_amount         = 'Montant',
    ui_amount_ph      = 'Saisir le montant sale',
    ui_on_hand        = 'Disponible',
    ui_capacity       = 'Capacité',
    ui_needs          = 'Nettoyeurs requis',
    ui_you_get        = 'Vous recevez',
    ui_start          = 'Lancer le lavage',
    ui_max            = 'Max',
    ui_dirty          = 'Argent sale',
    ui_clean          = 'Argent propre',

    -- Lavage actif
    ui_active         = 'Lavage en cours',
    ui_remaining      = 'Temps restant',
    ui_payout         = 'Gain',
    ui_collect        = 'Récupérer',
    ui_cancel         = 'Annuler',
    ui_complete       = 'Terminé',

    -- Améliorations
    ui_upgrades       = 'Améliorations',
    ui_level          = 'Niveau',
    ui_max_level      = 'Au max',
    ui_upgrade        = 'Améliorer',
    ui_next           = 'Suivant',
    up_efficiency       = 'Efficacité',
    up_efficiency_desc  = "Augmente le montant maximum que vous pouvez blanchir en un seul lavage.",
    up_potency          = 'Puissance',
    up_potency_desc     = 'Améliore le matériel pour réduire le temps de lavage.',

    -- Pied / méta
    ui_tax_rate       = 'Taxe',
    ui_wash_rate      = 'Vitesse de base',
    ui_close          = 'Fermer',
    ui_locked_title   = 'Accès refusé',
    ui_locked_text    = "Cette machine est restreinte. Vous n'êtes pas autorisé à l'utiliser.",

    -- Fenêtres
    md_deposit_title  = "Déposer des produits d'entretien",
    md_deposit_text   = "Combien d'unités voulez-vous charger dans la machine ?",
    md_deposit_ph     = 'Unités',
    md_cancel_title   = 'Annuler le lavage ?',
    md_cancel_text    = "Votre argent sale sera rendu, mais les produits d'entretien déjà utilisés sont perdus.",
    md_upgrade_title  = "Confirmer l'amélioration",
    md_upgrade_text   = 'Améliorer %s au niveau %s pour %s ?',
    md_confirm        = 'Confirmer',
    md_dismiss        = 'Annuler',

    -- Paramètres (par joueur)
    ui_settings       = 'Paramètres',
    ui_brand_color    = 'Couleur de marque',
    ui_background     = 'Arrière-plan',
    ui_position       = 'Position',
    ui_pos_left       = 'Gauche',
    ui_pos_center     = 'Centre',
    ui_pos_right      = 'Droite',
    ui_opacity        = 'Opacité',
    ui_size           = 'Taille',
    ui_size_s         = 'Petit',
    ui_size_m         = 'Moyen',
    ui_size_l         = 'Grand',
    ui_reset_default  = 'Réinitialiser',
}
