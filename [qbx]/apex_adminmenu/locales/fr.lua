-- ============================================================
-- FRANÇAIS (fr)
-- ------------------------------------------------------------
-- Surcouche de configs/strings.lua. Toute clé absente d'ici
-- garde automatiquement le texte anglais, donc une traduction
-- partielle ne casse jamais la ressource.
--
-- Les marqueurs %s doivent être conservés et dans le MÊME ordre
-- que l'original : ils sont remplis par :format() dans le code.
-- Un %% affiche un signe pourcentage littéral.
--
-- Activation :  Config.Locale = 'fr'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

-- ============================================================
-- Panneau F6 (NUI)
-- ------------------------------------------------------------
-- Le panneau est en HTML ; ses chaînes vivent dans leur propre
-- table. Réservé pour l'internationalisation du panneau — le
-- menu rapide et les notifications ci-dessous, eux, sont bien
-- traduits dès maintenant.
-- ============================================================
PanelLocales = PanelLocales or {}

PanelLocales['fr'] = {
    -- Navigation
    nav_home = 'Accueil',
    nav_players = 'Joueurs',
    nav_monitoring = 'Surveillance',
    nav_moderation = 'Modération',
    nav_chats = 'Discussions',
    nav_items = 'Objets',
    nav_vehicles = 'Véhicules',
    nav_console = 'Console',
    nav_events = 'Journal d\'Événements',
    nav_staff = 'Équipe',
    nav_jobs = 'Métiers',
    nav_blips = 'Blips',
    nav_logs = 'Journaux',
    nav_settings = 'Paramètres',

    -- Barre supérieure
    tb_players = 'Joueurs :',
    tb_uptime = 'En ligne depuis :',
    tb_search = 'Rechercher joueurs, pages, métiers…',
    tb_announce = 'Annoncer',

    -- En-têtes de page
    page_home = 'Accueil',
    page_home_sub = 'Carte en direct et état du serveur',
    page_players = 'Joueurs',
    page_players_sub = 'Joueurs connectés',

    -- Cartes de l'accueil
    kpi_players = 'Joueurs connectés',
    kpi_staff = 'Équipe connectée',
    kpi_new_today = 'Nouveaux joueurs aujourd\'hui',
    card_vehicle_delete = 'Nettoyage des Véhicules',
    card_vehicle_delete_sub = 'Supprime les véhicules inutilisés',
    card_next_deletion = 'Prochain nettoyage',
    card_server_time = 'Heure du Serveur',
    card_server_time_sub = 'Horloge du jeu',
    card_weather = 'Météo',
    card_latest = 'Derniers Joueurs',
    card_latest_sub = 'Connexions les plus récentes',
    btn_update = 'Mettre à jour',

    -- Paramètres
    set_appearance = 'Apparence',
    set_behaviour = 'Comportement',
    set_notifications = 'Notifications',
    set_stafftag = 'Étiquette d\'Équipe',
    set_keybinds = 'Touches',
    set_discord = 'Journaux Discord',
    set_theme = 'Thème et Marque',
    set_background = 'Arrière-plan',
    set_uisize = 'Taille de l\'Interface',
    set_display_mode = 'Mode d\'Affichage',
    set_opacity = 'Opacité du Panneau',
    set_custom_colour = 'Couleur personnalisée',
    set_reset_default = 'Rétablir les valeurs Apex',
    set_dark = 'Sombre',
    set_light = 'Clair',
    set_default = 'Par défaut',
    set_brighter = 'Interface plus claire',

    -- Communs
    common_close = 'Fermer',
    common_save = 'Enregistrer',
    common_cancel = 'Annuler',
    common_search = 'Rechercher',
    common_select_player = 'Sélectionnez un joueur',
    common_select_vehicle = 'Sélectionnez un véhicule pour voir les propriétaires',
    common_no_results = 'Aucun résultat'
}

Locales['fr'] = {
    -- ── Menu principal ──────────────────────────────────────
    main_title = 'Menu Admin',
    self_options = 'Options Personnelles',
    self_options_desc = 'Options vous concernant',
    player_options_title = 'Options Joueur',
    player_options_desc = 'Options concernant les joueurs',
    vehicle_options = 'Options Véhicule',
    vehicle_options_desc = 'Options concernant les véhicules',
    server_options = 'Options Serveur',
    server_options_desc = 'Options concernant le serveur',
    admin_zone_options = 'Zones Admin',
    admin_zone_options_desc = 'Gérer, ajouter et supprimer des zones admin',
    developer_options = 'Options Développeur',
    developer_options_desc = '',

    -- ── Options personnelles ────────────────────────────────
    self_options_menu = 'Options Personnelles',
    self_health = 'Vie (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Réanimer',
    self_revive_desc = 'Vous réanimer',
    self_heal = 'Soigner',
    self_heal_desc = 'Vous soigner',
    self_skinmenu = 'Menu Apparence',
    self_set_ped = 'Changer de Ped',
    self_skinmenu_desc = 'Ouvrir le menu d\'apparence en local',
    self_invisible = 'Invisible',
    self_godmode = 'Mode Dieu',
    self_wallhack = 'Wallhack',

    -- ── Options joueur ──────────────────────────────────────
    player_options_menu = 'Joueurs Connectés %s/%s',
    player_options = 'Joueur : %s',
    player_health = 'Vie du Joueur (%s%%)',
    player_freeze = 'Geler',
    player_freeze_desc = 'Activer / désactiver',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Activer / désactiver',
    player_spectate = 'Observer',
    player_spectate_desc = 'Regarder les actions de ce joueur',
    player_playerdata = 'Données du Joueur',
    player_playerdata_desc = 'Consulter les données du joueur',
    player_revive = 'Réanimer',
    player_revive_desc = 'Réanimer le joueur',
    player_heal = 'Soigner',
    player_heal_desc = 'Soigner le joueur',
    player_skinmenu = 'Menu Apparence',
    player_skinmenu_desc = 'Ouvrir un menu d\'apparence chez le joueur',
    player_money = 'Donner de l\'Argent',
    player_money_desc = 'Donner de l\'argent au joueur sélectionné',
    player_item = 'Donner un Objet',
    player_item_desc = 'Donner un objet au joueur sélectionné',
    player_openinv = 'Ouvrir l\'Inventaire',
    player_openinv_desc = 'Ouvrir l\'inventaire du joueur',
    player_clearinv = 'Vider l\'Inventaire',
    player_clearinv_desc = 'Vider l\'inventaire du joueur',
    player_teleport_to = 'Se Téléporter au Joueur',
    player_teleport_to_desc = 'Se téléporter jusqu\'au joueur',
    player_bring = 'Amener',
    player_bring_desc = 'Amener le joueur à votre position',
    player_kick = 'Expulser',
    player_kick_desc = 'Expulser le joueur du serveur',
    player_ban = 'Bannir le Joueur',

    -- ── Menu véhicule ───────────────────────────────────────
    vehicle_menu = 'Menu Véhicule',
    spawn_car = 'Faire Apparaître un Véhicule',
    spawn_car_desc = 'Faire apparaître un véhicule',
    repair_car = 'Réparer le Véhicule',
    repair_car_desc = 'Réparer le véhicule actuel ou le plus proche',
    delete_car = 'Supprimer le Véhicule',
    delete_car_desc = 'Supprimer le véhicule actuel ou le plus proche',
    number_plate = 'Modifier la Plaque',
    number_plate_desc = 'Changer le texte de la plaque actuelle',
    refuel = 'Faire le Plein',
    refuel_desc = 'Remplir le réservoir du véhicule actuel ou le plus proche',
    give_keys = 'Donner les Clés',
    give_keys_desc = 'Vous donner les clés du véhicule actuel',
    doors = 'Verrouiller / Déverrouiller',
    doors_desc = 'Bascule les serrures du véhicule le plus proche',
    boost_car = 'Multiplicateur de Couple',
    boost_car_desc = 'Modifier le couple du véhicule actuel',
    color_change = 'Changer la Couleur',
    color_change_desc = 'Changer la couleur du véhicule actuel ou le plus proche',

    -- ── Gestion du serveur ──────────────────────────────────
    server_management = 'Gestion du Serveur',
    server_announcement = 'Annonce Serveur',
    server_announcement_desc = 'Envoyer une annonce globale à tout le serveur',
    ban_list = 'Liste des Bannissements',
    ban_list_desc = 'Consulter tous les bannissements actifs',
    objects_list = 'Supprimer des Entités',
    objects_list_desc = 'Supprimer des véhicules et des peds',
    objects_list_label = 'Options',
    weather_menu = 'Gestion de la Météo',
    weather_menu_desc = 'Gérer la météo',

    -- ── Zones admin ─────────────────────────────────────────
    zones_create = 'Créer une Zone',
    zones_create_desc = 'Créer une nouvelle zone admin',
    zones_manage = 'Gérer les Zones',
    zones_manage_desc = 'Modifier ou supprimer les zones actives',
    zone_edit_current = 'Modifier la Zone Actuelle',
    zone_edit_current_desc = 'Gérer la zone dans laquelle vous vous trouvez',
    zone_delete_current = 'Supprimer la Zone Actuelle',
    zone_delete_current_desc = 'Supprimer la zone dans laquelle vous vous trouvez',
    zone_manage_menu = 'Modification de la Zone (%s)',
    zone_edit = 'Modifier la Zone',
    zone_edit_desc = 'Modifier la zone : %s',
    zone_delete = 'Supprimer la Zone',
    zone_delete_desc = 'Supprimer la zone : %s',
    zone_teleport = 'Se Téléporter à la Zone',
    zone_teleport_desc = 'Aller à la zone : %s',

    -- ── Menu développeur ────────────────────────────────────
    dev_options = 'Options Développeur',
    debug_mode = 'Mode Debug',
    debug_mode_desc = 'Activer / désactiver le mode debug',
    copy_vec3 = 'Copier les Coordonnées Vector3',
    copy_vec3_desc = 'Copie votre position actuelle (vector3) dans le presse-papiers',
    copy_vec4 = 'Copier les Coordonnées Vector4',
    copy_vec4_desc = 'Copie votre position actuelle (vector4) dans le presse-papiers',
    copy_heading = 'Copier l\'Orientation',
    copy_heading_desc = 'Copie votre orientation actuelle dans le presse-papiers',
    cant_delete = 'Suppression Impossible !',
    cant_delete_player_desc = 'Vous ne pouvez pas supprimer le ped d\'un joueur !',
    cant_delete_entity_desc = 'Vous ne pouvez pas supprimer les objets par défaut de la carte !',

    -- ── Liste des bannissements ─────────────────────────────
    ban_list_menu = 'Liste des Bannissements',
    ban_list_name = 'Nom : %s',
    ban_list_license = 'Licence :',
    ban_list_by = 'Émis par : %s',
    ban_list_reason = 'Raison : %s',
    ban_list_length = 'Temps restant : %s heures %s minutes',
    ban_list_modify = 'Modifier le Bannissement',
    ban_list_unban = 'Débannir le Joueur',
    ban_list_no_data = 'Aucun Bannissement',
    ban_list_no_data_desc = 'Aucun bannissement actif n\'a été trouvé !',

    -- ── Données du joueur ───────────────────────────────────
    playerdata_menu = 'Données du Joueur',
    playerdata_license_esx = 'Licence : %s',
    playerdata_license_qbcore = 'Citizen ID : %s',
    playerdata_license_desc = 'Cliquez pour copier la licence complète',
    playerdata_igname = 'Nom : %s',
    playerdata_igname_desc = 'Nom complet du joueur en jeu',
    playerdata_steam = 'Nom Steam : %s',
    playerdata_steam_desc = 'Nom Steam complet du joueur',
    playerdata_gender = 'Sexe : %s',
    playerdata_gender_desc = 'Sexe du joueur',
    playerdata_cash = 'Liquide : %s',
    playerdata_cash_desc = 'Argent liquide du joueur',
    playerdata_bank = 'Banque : %s',
    playerdata_bank_desc = 'Solde bancaire du joueur',
    playerdata_blackmoney = 'Argent Sale : %s',
    playerdata_blackmoney_desc = 'Argent sale du joueur',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Appuyez sur [E] pour supprimer l\'entité  \nHash : %s  \nCoords : vec3(%s, %s, %s)  \nOrientation : %s  \nPropriétaire : [%s] - %s',
    debug_textui_noname = 'Appuyez sur [E] pour supprimer l\'entité\n  Hash : %s\n  Coords : vec3(%s, %s, %s)\n  Orientation : %s\n  Propriétaire : INCONNU',

    textui_invisible = 'Mode Invisible - Activé',
    textui_godmode = 'Mode Dieu - Activé',
    textui_wallhack = 'Wallhack - Activé',
    textui_noclip_activated = 'No Clip - Activé',
    textui_torque = 'Multiplicateur de Couple - %s',

    -- ── Annonces ────────────────────────────────────────────
    dialog_announce = 'Annonce',
    dialog_announce_label = 'Message',
    dialog_announce_select = 'Tout le monde',
    dialog_announce_everyone = 'Tout le monde',
    dialog_announce_placeholder = 'Message important ici. . .',

    -- ── Débannissement ──────────────────────────────────────
    dialog_unban = 'Êtes-vous sûr ?',
    dialog_unban_content = 'Voulez-vous vraiment débannir %s ?',

    -- ── Suppression d'entités ───────────────────────────────
    dialog_objects = 'Choisissez une option',
    dialog_clear_objects = 'Supprimer TOUS les objets',
    dialog_clear_cars = 'Supprimer TOUTES les voitures (sans conducteur)',
    dialog_clear_peds = 'Supprimer TOUS les peds',

    -- ── Donner de l'argent ──────────────────────────────────
    dialog_givemoney = 'Donner de l\'Argent',
    givemoney_input_label = 'Montant',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Compte',
    givemoney_select_option1 = 'Liquide',
    givemoney_select_option2 = 'Banque',
    givemoney_select_option3 = 'Argent Sale',

    -- ── Donner un objet ─────────────────────────────────────
    dialog_giveitem = 'Donner un Objet',
    giveitem_input_label = 'Nom de l\'Objet',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Quantité',
    giveitem_amount_input_placeholder = '3',

    -- ── Faire apparaître un véhicule ────────────────────────
    dialog_spawn_a_car = 'Faire Apparaître un Véhicule',
    dialog_car_model = 'Nom du Modèle',
    dialog_car_model_holder = 'Ex : 20charger',
    dialog_car_plate = 'Plaque (facultatif)',
    dialog_car_plate_holder = 'Ex : W4S4B1',
    dialog_car_color_primary = 'Couleur Primaire (facultatif)',
    dialog_car_color_second = 'Couleur Secondaire (facultatif)',
    dialog_car_maxed = 'Modifications Maximales (facultatif)',

    -- ── Expulsion ───────────────────────────────────────────
    dialog_kick = 'Expulser %s',
    dialog_kick_reason = 'Raison',
    dialog_kick_placeholder = 'Tricheur',
    kicked_reason_replace = 'Vous avez été expulsé du serveur !',

    -- ── Bannissement ────────────────────────────────────────
    dialog_ban = 'Bannir %s',
    dialog_ban_reason = 'Raison',
    dialog_ban_placeholder = 'Tricheur',
    ban_reason_replace = 'Vous avez été banni de ce serveur !',

    -- ── Création de zone ────────────────────────────────────
    dialog_zone_create = 'Création de Zone',
    dialog_zone_name = 'Nom',
    dialog_zone_name_desc = 'Le nom de la zone / du blip',
    dialog_zone_name_holder = 'Zone Admin',
    dialog_zone_text = 'Texte Affiché',
    dialog_zone_text_desc = 'Le texte affiché aux joueurs présents dans la zone',
    dialog_zone_text_holder = 'ZONE ADMIN - ACTIVE',
    dialog_zone_size = 'Taille',
    dialog_zone_speed = 'Limite de Vitesse',
    mph = 'MPH',
    kmh = 'KM/H',
    dialog_zone_blip_id = 'ID du Blip',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'ID de Couleur',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Blip Clignotant',
    dialog_zone_disarm = 'Désarmer',
    dialog_zone_revive = 'Réanimer',
    dialog_zone_invincible = 'Invincible',
    dialog_zone_edit = 'Modification de « %s »',
    dialog_zone_delete_confirm = 'Êtes-vous sûr ?',
    dialog_zone_delete_confirm_desc = 'Voulez-vous vraiment supprimer la zone : %s',

    -- ── Notifications : argent ──────────────────────────────
    notify_givemoney_success = 'Argent Crédité',
    notify_givemoney_success_desc = 'Vous avez crédité %s de %s $ sur le compte : %s',
    notify_givemoney_fail = 'Échec',
    notify_givemoney_fail_desc = 'Vous avez tenté de créditer %s mais une erreur est survenue ! Réessayez.',

    -- ── Notifications : objets ──────────────────────────────
    notify_giveitem_success = 'Objet Donné',
    notify_giveitem_success_desc = 'Vous avez crédité %s. Objet : %s Quantité : %s',
    notify_giveitem_fail = 'Échec',
    notify_giveitem_fail_desc = 'Vous avez tenté de créditer %s mais une erreur est survenue ! Réessayez.',

    -- ── Notifications : expulsion / bannissement ────────────
    notify_kicked_success = 'Expulsion Réussie',
    notify_kicked_success_desc = 'Vous avez expulsé %s avec succès',
    notify_banned_success = 'Bannissement Réussi',
    notify_banned_success_desc = 'Vous avez banni %s avec succès',

    -- ── Notifications : inventaire ──────────────────────────
    notify_clearedinv = 'Inventaire Vidé',
    notify_clearedinv_desc = 'Vous avez vidé l\'inventaire de %s avec succès',

    -- ── Notifications : ID invalide ─────────────────────────
    notify_invalidid = 'ID Invalide',
    notify_invalidid_desc = 'L\'ID saisi est invalide, réessayez.',

    -- ── Notifications : nettoyage ───────────────────────────
    notify_deleted_car = 'Voitures Supprimées',
    notify_deleted_car_desc = 'Vous avez supprimé toutes les voitures sans conducteur.',
    notify_deleted_ped = 'Peds Supprimés',
    notify_deleted_ped_desc = 'Vous avez supprimé tous les peds de la carte',
    notify_deleted_objects = 'Objets Supprimés',
    notify_deleted_objects_desc = 'Vous avez supprimé tous les objets de la carte',

    -- ── Notifications : météo ───────────────────────────────
    notify_weather = 'Météo Modifiée',
    notify_weather_desc = 'Météo changée en : %s',

    -- ── Notifications : copie de coordonnées ────────────────
    notify_copied = 'Copié',
    notify_copied_vec3 = 'Vector3 copié dans le presse-papiers !',
    notify_copied_vec4 = 'Vector4 copié dans le presse-papiers !',
    notify_copied_headin = 'Orientation copiée dans le presse-papiers !',

    -- ── Notifications : portes ──────────────────────────────
    notify_locked_doors = 'Verrouillé',
    notify_locked_doors_desc = 'Portes du véhicule verrouillées avec succès.',
    notify_unlocked_doors = 'Déverrouillé',
    notify_unlocked_doors_desc = 'Portes du véhicule déverrouillées avec succès.',

    -- ── Notifications : zones admin ─────────────────────────
    notify_zone_deleted = 'Zone Supprimée',
    notify_zone_deleted_desc = 'Vous avez supprimé la zone : %s.',
    notify_zone_not_deleted_desc = 'Une erreur est survenue lors de la suppression de la zone : %s.',
    notify_zone_edited = 'Zone Modifiée',
    notify_zone_edited_desc = 'Vous avez modifié la zone : %s.',
    notify_zone_not_edited_desc = 'Une erreur est survenue lors de la modification de la zone : %s.',
    notify_zone_action_cancelled = 'Action Annulée',
    notify_zone_delete_cancel = 'Vous avez annulé la suppression de la zone : %s',
    notify_zone_no_weapons = 'Armes Interdites',
    notify_zone_no_weapons_desc = 'Vous n\'êtes pas autorisé à utiliser une arme dans cette zone.',
    notify_zones_not_found = 'Aucune Zone',
    notify_zones_not_found_desc = 'Il n\'y a actuellement aucune zone active à gérer.',
    notify_zones_teleport = 'Téléporté',
    notify_zones_teleport_desc = 'Vous avez été téléporté à la zone : %s.',

    -- ── Notifications : débannissement ──────────────────────
    successfully_unbanned = 'Bannissement Levé',
    successfully_unbanned_desc = 'Vous avez débanni %s avec succès.',
    unsuccessful_unban = 'Une erreur est survenue en tentant de débannir : %s.',

    -- ── Connexion (deferrals) ───────────────────────────────
    deferral_welcome = '[%s] Bonjour %s, vérification des bannissements. . .',
    deferral_banned = 'Vous êtes banni de ce serveur. Raison : « %s » (Temps restant : %s heures %s minutes).',
    deferral_banned_perm = 'Vous êtes banni de ce serveur. Raison : « %s » (Temps restant : permanent).',

    -- ── Erreurs ─────────────────────────────────────────────
    notify_error = 'Erreur',
    notify_disabled_keys = 'Aucun script de clés de véhicule n\'est configuré. Contactez le développeur du serveur.',
    notify_no_appearance = 'Aucun script de vêtements / apparence détecté. Contactez le développeur du serveur.',
    notify_no_vehicle = 'Aucun véhicule trouvé !',
    notify_invalid_entry = 'Saisie invalide !',

    -- ── Raccourci clavier ───────────────────────────────────
    keymapping_desc = 'Ouvrir le Menu Admin (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Activé',
    noclip_deactivated = 'NoClip Désactivé',

    -- ── Invisibilité ────────────────────────────────────────
    invisibility_activated = 'Mode Invisible Activé',
    invisibility_deactivated = 'Mode Invisible Désactivé',

    -- ── Mode Dieu ───────────────────────────────────────────
    godmode_activated = 'Mode Dieu Activé',
    godmode_deactivated = 'Mode Dieu Désactivé',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Activé',
    wallhack_deactivated = 'Wallhack Désactivé',

    -- ── Mode debug ──────────────────────────────────────────
    debug_activated = 'Mode Debug Activé',
    debug_deactivated = 'Mode Debug Désactivé',

    -- ── Notifications : véhicules ───────────────────────────
    vehicle_repaired = 'Véhicule Réparé',
    vehicle_repaired_desc = 'Le véhicule a été réparé avec succès.',
    vehicle_deleted = 'Véhicule Supprimé',
    vehicle_deleted_desc = 'Le véhicule a été supprimé avec succès.',
    vehicle_spawned = 'Véhicule Apparu',
    vehicle_spawned_desc = 'Le véhicule %s est apparu avec succès.',
    vehicle_plate_changed = 'Plaque Modifiée',
    vehicle_plate_changed_desc = 'Plaque du véhicule changée en : %s',
    vehicle_refueled = 'Véhicule Ravitaillé',
    vehicle_refueled_desc = 'Le plein du véhicule a été fait avec succès.',
    vehicle_keys_given = 'Clés Reçues',
    vehicle_keys_given_desc = 'Vous avez reçu les clés du véhicule immatriculé : %s',
    vehicle_color_changed = 'Couleur du Véhicule Modifiée',
    vehicle_color_changed_desc = 'Couleur du véhicule changée en : %s',
    vehicle_torque_set = 'Multiplicateur de Couple Défini',
    vehicle_torque_set_desc = 'Couple réglé sur : %sx',
    vehicle_torque_disabled = 'Multiplicateur de Couple Désactivé',

    -- ── Observation ─────────────────────────────────────────
    spectate_started = 'Observation',
    spectate_started_desc = 'Vous observez %s. Appuyez sur X pour arrêter.',
    spectate_ended = 'Observation Terminée',
    spectate_ended_desc = 'Vous n\'observez plus personne.',
    spectate_error = 'Erreur d\'Observation',
    spectate_error_desc = 'Joueur cible introuvable ou déconnecté.',

    -- ── Téléportation ───────────────────────────────────────
    teleport_success = 'Téléporté',
    teleport_success_desc = 'Vous avez été téléporté avec succès.',

    -- ── Réanimation / soins ─────────────────────────────────
    player_revived = 'Joueur Réanimé',
    player_revived_desc = 'Vous avez réanimé %s avec succès.',
    player_healed = 'Joueur Soigné',
    player_healed_desc = 'Vous avez soigné %s avec succès.',
    self_revived = 'Réanimé',
    self_revived_desc = 'Vous vous êtes réanimé.',
    self_healed = 'Soigné',
    self_healed_desc = 'Vous vous êtes soigné.',

    -- ── Peds ────────────────────────────────────────────────
    ped_changed = 'Ped Modifié',
    ped_changed_desc = 'Votre modèle de ped a été modifié.',
    ped_restored = 'Ped Restauré',
    ped_restored_desc = 'Votre modèle de ped d\'origine a été restauré.',

    skin_menu_opened = 'Menu Apparence Ouvert',

    admin_menu_opened = 'Menu Admin Ouvert',
    admin_menu_closed = 'Menu Admin Fermé',

    entity_deleted = 'Entité Supprimée',
    entity_deleted_desc = 'L\'entité a été supprimée avec succès.',

    player_frozen = 'Joueur Gelé',
    player_frozen_desc = 'Le joueur %s a été gelé.',
    player_unfrozen = 'Joueur Dégelé',
    player_unfrozen_desc = 'Le joueur %s a été dégelé.',

    -- ── Plaque personnalisée ────────────────────────────────
    dialog_license_plate = 'Plaque Personnalisée',
    dialog_license_plate_label = 'Plaque',
    dialog_license_plate_placeholder = 'Plaque',

    -- ── Retirer de l'argent ─────────────────────────────────
    player_removemoney = 'Retirer de l\'Argent',
    player_removemoney_desc = 'Retirer de l\'argent au joueur sélectionné',
    dialog_removemoney = 'Retirer de l\'Argent',
    removemoney_input_label = 'Montant',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Compte',
    notify_removemoney_success = 'Argent Retiré',
    notify_removemoney_success_desc = 'Vous avez retiré %s $ à %s (compte : %s)',
    notify_removemoney_fail = 'Échec',
    notify_removemoney_fail_desc = 'Impossible de retirer de l\'argent à %s (fonds insuffisants ?).',

    -- ── Dimensions / routing buckets ────────────────────────
    self_dimension = 'Définir Ma Dimension',
    self_dimension_desc = 'Vous déplacer vers un routing bucket (0 = monde principal)',
    player_dimension = 'Définir la Dimension',
    player_dimension_desc = 'Déplacer ce joueur vers un routing bucket',
    player_dimension_bring = 'Amener Dans Ma Dimension',
    player_dimension_bring_desc = 'Attirer ce joueur dans votre dimension actuelle',
    player_dimension_goto = 'Rejoindre la Dimension du Joueur',
    player_dimension_goto_desc = 'Vous déplacer dans la dimension de ce joueur',
    dialog_dimension = 'Définir la Dimension',
    dimension_input_label = 'Dimension (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Dimension Modifiée',
    notify_dimension_self_desc = 'Vous êtes maintenant dans la dimension %s.',
    notify_dimension_player_desc = '%s a été déplacé vers la dimension %s.',
    notify_dimension_join_desc = 'Vous avez rejoint la dimension de %s (%s).',
    notify_dimension_fail = 'Erreur de Dimension',
    notify_dimension_fail_desc = 'Impossible de changer de dimension.',

    -- ── Téléportation dans le véhicule ──────────────────────
    player_tp_vehicle = 'Se Téléporter Dans le Véhicule',
    player_tp_vehicle_desc = 'Entrer dans le véhicule de ce joueur pour l\'aider à le récupérer',
    notify_tp_vehicle_fail = 'Aucun Véhicule',
    notify_tp_vehicle_fail_desc = '%s n\'est pas dans un véhicule.',
    notify_tp_vehicle_success = 'Téléporté',
    notify_tp_vehicle_success_desc = 'Vous avez été placé dans le véhicule de %s.',

    -- ── Récupération de véhicule ────────────────────────────
    recover_car = 'Récupérer / Redresser le Véhicule',
    recover_car_desc = 'Redresser et replacer sur la route la plus proche (mer / retourné)',
    vehicle_recovered = 'Véhicule Récupéré',
    vehicle_recovered_desc = 'Le véhicule a été redressé et placé sur la route la plus proche.',

    -- ── Véhicules possédés ──────────────────────────────────
    player_owned_vehicles = 'Véhicules Possédés',
    player_owned_vehicles_desc = 'Voir, ajouter ou retirer les voitures de ce joueur',
    owned_vehicles_menu = 'Véhicules Possédés (%s)',
    owned_vehicles_add = 'Ajouter un Véhicule',
    owned_vehicles_add_desc = 'Ajouter un véhicule au garage de ce joueur',
    owned_vehicles_none = 'Aucun Véhicule',
    owned_vehicles_none_desc = 'Ce joueur ne possède aucun véhicule.',
    owned_vehicle_desc = 'Plaque : %s · cliquez pour retirer',
    dialog_add_vehicle = 'Ajouter un Véhicule',
    add_vehicle_model_label = 'Nom du Modèle',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Plaque (facultatif)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = 'Retirer %s ?',
    notify_owned_added = 'Véhicule Ajouté',
    notify_owned_added_desc = '%s (plaque %s) ajouté à %s.',
    notify_owned_removed = 'Véhicule Retiré',
    notify_owned_removed_desc = 'Plaque %s retirée de %s.',
    notify_owned_fail = 'Erreur de Base de Données',
    notify_owned_fail_desc = 'L\'opération sur la base de données des véhicules a échoué.',

    -- ── Menu de peds ────────────────────────────────────────
    player_pedmenu = 'Donner le Menu de Peds',
    player_pedmenu_desc = 'Ouvrir un menu de sélection de ped sur l\'écran de ce joueur',
    pedmenu_title = 'Menu de Peds',
    pedmenu_given = 'Menu de Peds Envoyé',
    pedmenu_given_desc = 'Menu de peds ouvert pour %s.'
}
