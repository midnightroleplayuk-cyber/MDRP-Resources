--[[ apex_garage — locales/fr.lua

    Traduction française. Le fichier canonique est locales/en.lua : shared/utils.lua
    retombe clé par clé sur Locales.dict['en'], donc une traduction manquante
    n'est jamais fatale.

    Les spécificateurs de format sont critiques — garde-les tels quels :
        ui_sell_confirm  %s (véhicule), %s (prix)
        ui_hours         %s (heures)
        n_paid_fee       %s (montant)
        n_sold           $%s (montant)
]]

Locales = Locales or {}
Locales.dict = Locales.dict or {}

Locales.dict['fr'] = {
    -- ─────────────────────────────────────────────────────────────
    -- Prompts (TextUI / labels de target)
    -- ─────────────────────────────────────────────────────────────
    prompt_open      = 'Ouvrir le garage',
    prompt_store     = 'Ranger le véhicule',
    prompt_impound   = 'Fourrière',

    -- Phrase TextUI : <prefix> [E] <suffix> <prompt_* en minuscules>
    -- ex. "Appuie sur [E] pour ouvrir le garage"
    ui_press_prefix  = 'Appuie sur',
    ui_press_suffix  = 'pour',

    -- ─────────────────────────────────────────────────────────────
    -- UI — coquille, listes et filtres
    -- ─────────────────────────────────────────────────────────────
    ui_garage        = 'GARAGE',
    ui_impound       = 'FOURRIÈRE',
    ui_search        = 'Rechercher par nom ou plaque…',
    ui_cash          = 'Espèces',
    ui_bank          = 'Banque',
    ui_all           = 'Tous',
    ui_empty         = 'Tu n\'as aucun véhicule dans ce garage.',
    ui_empty_impound = 'Aucun véhicule en fourrière.',
    ui_sort_name     = 'Nom (A-Z)',
    ui_sort_status   = 'Statut',
    ui_confirm       = 'Confirmer',
    ui_cancel        = 'Annuler',
    ui_fee           = 'Frais',

    -- ─────────────────────────────────────────────────────────────
    -- UI — fiche véhicule
    -- ─────────────────────────────────────────────────────────────
    ui_nickname       = 'Surnom',
    ui_nickname_set   = 'Définir un surnom',
    ui_nickname_ph    = 'Surnom du véhicule',
    ui_fuel           = 'Carburant',
    ui_engine         = 'Moteur',
    ui_body           = 'Carrosserie',
    ui_status_stored  = 'Au garage',
    ui_status_out     = 'Dehors',
    ui_status_impound = 'En fourrière',
    ui_financed       = 'En cours de financement',

    -- ─────────────────────────────────────────────────────────────
    -- UI — actions véhicule
    -- ─────────────────────────────────────────────────────────────
    ui_drive         = 'Sortir',
    ui_return_drive  = 'Récupérer et conduire',
    ui_transfer      = 'Transférer',
    ui_release       = 'Rendre au propriétaire',
    ui_recover       = 'Récupérer',
    ui_sell          = 'Vendre',
    ui_sell_title    = 'Vendre le véhicule',
    ui_sell_confirm  = 'Tu vas vendre %s pour %s. C\'est irréversible.',

    -- ─────────────────────────────────────────────────────────────
    -- UI — transfert
    -- ─────────────────────────────────────────────────────────────
    ui_transfer_title       = 'Transférer le véhicule',
    ui_transfer_garage      = 'Vers un autre garage',
    ui_transfer_player      = 'Vers un autre joueur',
    ui_transfer_pick_garage = 'Choisis le garage de destination',
    ui_transfer_pick_player = 'Joueurs à proximité',
    ui_transfer_no_players  = 'Personne à proximité.',

    -- ─────────────────────────────────────────────────────────────
    -- UI — mise en fourrière (côté police / admin)
    -- ─────────────────────────────────────────────────────────────
    ui_impound_title       = 'Mettre en fourrière',
    ui_impound_reason      = 'Motif',
    ui_impound_reason_ph   = 'Motif de la mise en fourrière…',
    ui_impound_retrievable = 'Le propriétaire peut récupérer',
    ui_impound_time        = 'Délai avant récupération',
    ui_impound_cost        = 'Coût de récupération',
    ui_impound_confirm     = 'Mettre en fourrière',
    ui_hours               = '%sh',
    ui_time_none           = 'Sans limite',
    ui_reason              = 'Motif',

    ui_impound_lot              = 'Fourrière',
    ui_impound_lot_nearest      = 'La plus proche',
    ui_impound_owner            = 'Propriétaire',
    ui_impound_roster           = 'Véhicules retenus',
    ui_impound_retrievable_desc = 'Le propriétaire pourra racheter ce véhicule à la fin du délai.',
    ui_impound_locked_hint      = 'Seul un agent peut rendre ce véhicule.',
    ui_impound_held_at          = 'Retenu à',
    ui_impound_officer          = 'Mis en fourrière par',
    ui_impound_no_reason        = 'Aucun motif',
    ui_impound_release          = 'Rendre',
    ui_impound_release_owner    = 'Récupérable',
    ui_impound_release_police   = 'Police uniquement',
    ui_impound_available        = 'Disponible dans',
    ui_impound_available_now    = 'Disponible',
    ui_impound_free             = 'Gratuit',
    ui_impound_wait             = 'Disponible dans %s',
    ui_at_impound               = 'En fourrière',
    ui_time_immediate           = 'Immédiat',
    ui_time_now                 = 'Immédiat',
    ui_owner                    = 'Propriétaire',
    ui_unknown_owner            = 'Propriétaire inconnu',
    ui_dur_h                    = '%sh',
    ui_dur_m                    = '%smin',
    ui_dur_hm                   = '%hh %mmin',

    -- ─────────────────────────────────────────────────────────────
    -- UI — apparence (panneau admin : thème global du serveur)
    -- ─────────────────────────────────────────────────────────────
    ui_theme            = 'Apparence',
    ui_theme_colors     = 'Couleurs',
    ui_theme_brand      = 'Couleur d\'accent',
    ui_theme_bg         = 'Couleur de fond',
    ui_theme_derive     = 'Chaque surface, bordure et nuance dérive de ces deux couleurs. En sauvegardant, le nouveau rendu s\'applique instantanément à TOUS les joueurs.',
    ui_theme_presets    = 'Préréglages',
    ui_theme_preview    = 'Aperçu',
    ui_theme_apply      = 'Appliquer à tout le monde',
    ui_theme_reset_def  = 'Rétablir par défaut',

    -- contenu fictif de la carte d'aperçu (jamais affiché hors du panneau apparence)
    ui_theme_demo_title      = 'Mes véhicules',
    ui_theme_demo_stored     = 'Rangé',
    ui_theme_demo_finance    = 'Financé',
    ui_theme_demo_kpi_stored = 'Rangés',
    ui_theme_demo_kpi_out    = 'Dehors',
    ui_theme_demo_take       = 'Sortir',
    ui_theme_demo_transfer   = 'Transférer',
    ui_theme_demo_search     = 'Rechercher un véhicule',

    -- ─────────────────────────────────────────────────────────────
    -- Notifications (n_) — toasts côté joueur
    -- ─────────────────────────────────────────────────────────────
    n_no_access      = 'Tu ne peux pas accéder à ce garage.',
    n_no_vehicle     = 'Tu n\'es pas dans un véhicule.',
    n_not_driver     = 'Tu dois être le conducteur.',
    -- Config.occupantGuard : sans ça le véhicule serait supprimé avec des gens dedans
    n_occupied         = 'Fais descendre tes passagers avant de ranger le véhicule.',
    n_occupied_impound = 'Fais descendre tout le monde avant de mettre le véhicule en fourrière.',
    n_impound_on_foot = 'Descends du véhicule pour utiliser la fourrière.',
    n_wrong_class    = 'Ce véhicule n\'appartient pas à ce garage.',
    n_stored         = 'Véhicule rangé.',
    n_taken_out      = 'Véhicule sorti.',
    n_blocked        = 'Pas assez de place pour sortir le véhicule ici.',
    n_paid_fee       = 'Frais payés : %s.',
    n_nickname_ok    = 'Surnom mis à jour.',
    n_transferred    = 'Véhicule transféré.',
    n_sold           = 'Véhicule vendu pour $%s.',
    n_impounded      = 'Véhicule mis en fourrière.',
    n_released       = 'Véhicule rendu au garage du propriétaire.',
    n_recovered      = 'Véhicule récupéré de la fourrière.',
    n_no_target      = 'Aucun véhicule à proximité.',

    n_impound_locked     = 'Seul un agent peut rendre ce véhicule.',
    n_impound_not_ready  = 'Ce véhicule ne peut pas encore être récupéré.',
    n_impound_empty      = 'Tu n\'as aucun véhicule dans cette fourrière.',
    n_impound_released   = 'Ton véhicule %s est sorti de la fourrière et t\'attend à %s.',
    n_impounded_reason   = 'Mis en fourrière par %s — %s',
    n_impound_no_reason  = 'Aucun motif',
    n_too_far            = 'Tu es trop loin de la fourrière.',

    -- ─────────────────────────────────────────────────────────────
    -- Notifications — commandes admin & garages privés
    -- ─────────────────────────────────────────────────────────────
    n_npc_removed    = 'Véhicule sans propriétaire supprimé.',
    n_priv_created   = 'Garage privé créé.',
    n_priv_deleted   = 'Garage privé supprimé.',
    n_priv_noperm    = 'Tu ne peux pas créer de garages privés.',
    n_priv_name      = 'Ce nom existe déjà.',
    n_plate_changed  = 'Plaque modifiée.',
    n_veh_returned   = 'Véhicule renvoyé au garage.',
    n_veh_deleted    = 'Véhicule supprimé de la base de données.',

    -- ─────────────────────────────────────────────────────────────
    -- Erreurs (e_) — renvoyées par le serveur, résolues dynamiquement
    -- ─────────────────────────────────────────────────────────────
    e_nil         = 'Une erreur est survenue.',
    e_invalid     = 'Invalide.',
    e_no_access   = 'Accès refusé.',
    e_not_owner   = 'Tu n\'es pas le propriétaire.',
    e_wrong_class = 'Ce véhicule n\'appartient pas à ce garage.',
    e_no_money    = 'Fonds insuffisants.',
    e_unavailable = 'Indisponible.',
    -- le serveur a refusé la sortie : toutes les places sont occupées
    e_blocked     = 'Pas assez de place pour sortir le véhicule ici.',
    e_busy        = 'Tu as déjà une action en cours.',
    e_no_target   = 'Aucun véhicule à proximité.',
    e_already_out = 'Ce véhicule est déjà sorti.',
    -- affiché aussi sur le bouton de récupération, garde-le court
    e_occupied    = 'Quelqu\'un se trouve dans ce véhicule.',
    e_name        = 'Ce nom est déjà pris.',
    e_no_vehicle  = 'Tu n\'es pas dans un véhicule.',

    -- erreurs — flotte d'entreprise
    e_stock_all_out    = 'Tous ceux-là sont déjà sortis.',
    e_fleet_admin_only = 'Seul un admin peut changer les véhicules proposés par ce garage.',
    e_stock_boss_only  = 'Seul un patron désigné ou un admin peut changer la capacité de la flotte.',

    -- erreurs — fourrière
    e_impound_locked    = 'Agent uniquement.',
    e_impound_not_ready = 'Pas encore disponible.',
    e_too_far           = 'Trop loin.',
    e_no_lot            = 'Aucune fourrière n\'accepte ce véhicule.',
    e_impounded         = 'En fourrière.',

    -- erreurs — vente
    e_sell_off      = 'La vente instantanée n\'est pas disponible.',
    e_sell_financed = 'Tu ne peux pas vendre un véhicule financé.',
    e_sell_out      = 'Le véhicule est dehors.',
    e_sell_parked   = 'Le véhicule est stationné.',
    e_sell_impound  = 'Le véhicule est en fourrière.',
    e_sell_noprice  = 'Ce véhicule n\'a pas de prix de marché.',
    e_sell_payfail  = 'Le paiement de la vente a échoué. Contacte un administrateur.',

    -- ─────────────────────────────────────────────────────────────
    -- Erreurs — stationnement persistant
    -- ─────────────────────────────────────────────────────────────
    e_park_off         = 'Le stationnement persistant est désactivé.',
    e_park_noperm      = 'Tu n\'as pas le droit de stationner ici.',
    e_park_notowned    = 'Ce véhicule n\'est pas à toi.',
    e_park_max         = 'Tu as atteint ta limite de véhicules stationnés.',
    e_park_occupied    = 'Un véhicule est déjà stationné ici.',
    e_park_none        = 'Aucun véhicule stationné avec cette plaque.',
    e_park_notowner    = 'Seul le propriétaire peut reprendre ce véhicule.',
    e_park_busy        = 'Le système de stationnement démarre encore.',
    e_park_already     = 'Ce véhicule est déjà stationné.',
    e_park_parked      = 'Ce véhicule est stationné dans la rue — va le chercher là-bas.',
    e_park_notdriving  = 'Tu dois être dans le véhicule que tu veux stationner.',
    e_park_moving      = 'Arrête complètement le véhicule avant de le stationner.',
    e_park_blacklisted = 'Le stationnement est interdit dans cette zone.',
    e_park_in_garage   = 'Tu ne peux pas stationner dans un garage.',

    -- ─────────────────────────────────────────────────────────────
    -- UI — libellés génériques (boutons, chips, étiquettes)
    -- ─────────────────────────────────────────────────────────────
    ui_save          = 'Enregistrer',
    ui_close         = 'Fermer',
    ui_collapse      = 'Réduire',
    ui_remove        = 'Retirer',
    ui_edit          = 'Modifier',
    ui_teleport      = 'Téléporter',
    ui_name          = 'Nom',
    ui_set           = 'Définir',
    ui_class         = 'Classe',
    ui_add           = 'Ajouter',
    ui_create        = 'Créer',
    ui_delete        = 'Supprimer',
    ui_clear         = 'Effacer',
    ui_place         = 'Placer',
    ui_none          = 'Aucun',
    ui_optional      = 'facultatif',
    ui_yes           = 'Oui',
    ui_no            = 'Non',
    ui_vehicle       = 'Véhicule',
    ui_min_grade     = 'Grade minimum',
    ui_add_vehicle   = 'Ajouter un véhicule',

    -- compteurs (%s = nombre) — le JS choisit la forme puis remplace %s
    ui_count_one     = '%s véhicule',
    ui_count_many    = '%s véhicules',
    ui_grade         = 'grade %s',

    -- bandeau de la carte véhicule (majuscules voulues)
    ui_brand_air     = 'AIR',
    ui_brand_sea     = 'MER',
    ui_brand_car     = 'VÉHICULE',

    ui_impound_section = 'Fourrière',

    -- forme de zone & état
    ui_shape_corners = 'Coins',
    ui_shape_circle  = 'Cercle',
    ui_state_set     = 'Défini',
    ui_state_unset   = 'À définir',

    -- infobulles du dock d'aperçu 3D
    ui_pv_rotate_left  = 'Tourner à gauche',
    ui_pv_autorotate   = 'Rotation auto',
    ui_pv_rotate_right = 'Tourner à droite',
    ui_pv_zoom_out     = 'Dézoomer',
    ui_pv_zoom_in      = 'Zoomer',
    ui_pv_reset        = 'Réinitialiser la caméra',

    -- ─────────────────────────────────────────────────────────────
    -- Panneau admin & panneau patron (adm_)
    -- ─────────────────────────────────────────────────────────────
    adm_count_one       = '%s garage',
    adm_count_many      = '%s garages',
    adm_garages         = 'Garages',
    adm_new_garage      = 'Nouveau garage',
    adm_edit_garage     = 'Modifier le garage',
    adm_empty           = 'Aucun garage',
    adm_empty_sub       = 'Crée le premier avec « Nouveau garage ».',
    adm_row_vehicles    = '%s véh.',
    adm_tp_garage       = 'Se téléporter au garage',
    adm_src_config      = 'Défini dans shared/config.lua',
    adm_src_created     = 'Créé en jeu',
    adm_src_config_chip = 'config.lua',
    adm_src_config_hint = 'Modifie-le dans shared/config.lua et redémarre la ressource',
    adm_type_public     = 'Public',
    adm_type_job        = 'Emploi',
    adm_type_private    = 'Privé',
    adm_type_impound    = 'Fourrière',
    adm_pick_player     = 'Choisir un joueur',
    adm_nobody_online   = 'Personne en ligne.',

    adm_company         = 'ENTREPRISE',
    adm_management      = 'DIRECTION',
    adm_admin           = 'ADMIN',
    adm_company_garage  = 'GARAGE D\'ENTREPRISE',
    adm_company_fallback = 'Entreprise',
    adm_boss_stock      = 'Par stock',
    adm_boss_infinite   = 'Sortie illimitée',
    adm_boss_empty      = 'Aucun véhicule',
    adm_boss_empty_sub  = 'Ajoute ceux que l\'entreprise peut sortir.',
    adm_boss_empty_adm  = 'Un admin définit cette flotte dans /apexgarage.',

    adm_priv_title          = 'Garages privés',
    adm_priv_empty          = 'Tu n\'as pas encore de garage privé.',
    adm_priv_create_here    = 'Créer un garage privé ici',
    adm_priv_delete_confirm = 'Supprimer ce garage privé ?',
    adm_priv_create_title   = 'Créer un garage privé',
    adm_class_car_fallback  = 'Voiture',

    -- ─────────────────────────────────────────────────────────────
    -- Éditeur de garage (ed_)
    -- ─────────────────────────────────────────────────────────────
    ed_identification    = 'Identification',
    ed_name_ph           = 'Nom du garage',
    ed_type              = 'Type',
    ed_class_land        = 'Terre',
    ed_class_air         = 'Air',
    ed_class_sea         = 'Mer',
    ed_officer_job       = 'Emploi des agents',
    ed_veh_mode          = 'Mode véhicules',
    ed_veh_mode_personal = 'Personnel',
    ed_veh_mode_company  = 'Entreprise',
    ed_veh_mode_list     = 'Liste',
    ed_stock_mode        = 'Mode de stock',
    ed_stock             = 'Stock',
    ed_stock_start       = 'Stock de départ',
    ed_spawn_code        = 'Code de spawn',
    ed_veh_edit          = 'Modifier le véhicule',
    ed_veh_fleet_hint    = 'Seul un admin change les véhicules proposés. Le patron ajuste les quantités.',
    ed_stock_infinite    = 'Illimité',
    ed_stock_by_stock    = 'Par stock',
    ed_boss_grade        = 'Grade patron',
    ed_owners            = 'Propriétaires',
    ed_owner_add         = 'Ajouter un propriétaire',
    ed_owners_existing   = '%s propriétaire(s) actuel(s) (conservés ; ajoutes-en un pour les remplacer).',
    ed_owners_none       = 'Aucun propriétaire — le garage reste inaccessible tant que tu n\'en ajoutes pas.',
    ed_zone_poly         = 'Polygone · %s coins',
    ed_zone_circle       = 'Cercle · rayon %s m',
    ed_zone_unset        = 'Pas encore définie',
    ed_store_set         = 'Point dédié défini',
    ed_store_unset       = 'Facultatif — la zone est utilisée si vide',
    ed_placement         = 'Placement dans le monde',
    ed_zone              = 'Zone du garage',
    ed_tp_zone           = 'Se téléporter à la zone',
    ed_spawns            = 'Points d\'apparition',
    ed_spawns_sub        = 'Où le véhicule apparaît à la sortie',
    ed_store_point       = 'Point de rangement',
    ed_list_vehicles     = 'Véhicules de la liste',
    ed_no_vehicles       = 'Aucun véhicule. Ajoute ceux que cet emploi peut sortir.',

    -- ─────────────────────────────────────────────────────────────
    -- Stationnement persistant — panneau admin (pk_)
    -- Le nom de la commande est configurable (Config.commands.park) : ne jamais
    -- l'écrire en dur dans une traduction — reste générique.
    -- ─────────────────────────────────────────────────────────────
    pk_title             = 'Stationnement',
    pk_tab_parking       = 'Stationnés',
    pk_tab_noparking     = 'Interdictions',
    pk_tab_settings      = 'Réglages',
    pk_settings          = 'Paramètres',
    pk_enabled           = 'Stationnement activé',
    pk_enabled_desc      = 'Autorise les joueurs à stationner leur véhicule n\'importe où sur le serveur.',
    pk_nocol             = 'Sans collision',
    pk_nocol_desc        = 'Les autres véhicules traversent les voitures stationnées.',
    pk_jobveh            = 'Véhicules d\'entreprise',
    pk_jobveh_desc       = 'Permet de stationner les véhicules de service.',
    pk_nogarage          = 'Interdire dans les garages',
    pk_nogarage_desc     = 'Empêche de stationner dans toute zone de garage.',
    pk_who               = 'Qui peut stationner',
    pk_who_desc          = 'Définit qui a accès à la commande.',
    pk_mode_public       = 'Tout le monde',
    pk_mode_job          = 'Par emploi',
    pk_mode_permission   = 'Par permission',
    pk_jobs              = 'Emplois autorisés',
    pk_jobs_desc         = 'Séparés par des virgules.',
    pk_max               = 'Maximum par joueur',
    pk_max_desc          = 'Combien de véhicules chaque joueur peut laisser stationnés.',
    pk_unit_count        = 'u.',
    pk_radius            = 'Rayon anti-chevauchement',
    pk_radius_desc       = 'Distance minimale avec un autre véhicule déjà stationné.',
    pk_perms             = 'Permissions',
    pk_grant             = 'Accorder',
    pk_grant_title       = 'Accorder la permission',
    pk_perms_empty       = 'Aucune permission',
    pk_perms_empty_sub   = 'Accorde l\'accès à un joueur connecté.',
    pk_revoke            = 'Révoquer',
    pk_offline           = 'Hors ligne',
    pk_zones             = 'Zones interdites',
    pk_zones_empty       = 'Aucune zone interdite',
    pk_zones_empty_sub   = 'Trace une zone où personne ne peut stationner.',
    pk_zone              = 'Zone',
    pk_zone_corners      = '%s coins',
    pk_zone_radius       = 'rayon %s m',
    pk_parked            = 'Véhicules stationnés',
    pk_parked_empty      = 'Rien de stationné',
    pk_parked_empty_sub  = 'Personne n\'a laissé de véhicule dans le monde.',
    pk_save_note         = 'Les changements ne s\'appliquent qu\'après enregistrement.',

    -- ─────────────────────────────────────────────────────────────
    -- Placement dans le monde — touches & titres (prompt_)
    -- ─────────────────────────────────────────────────────────────
    prompt_key_radius       = 'Rayon',
    prompt_key_place        = 'Placer',
    prompt_key_cancel       = 'Annuler',
    prompt_key_rotate       = 'Tourner',
    prompt_key_add_corner   = 'Ajouter un coin',
    prompt_key_finish       = 'Terminer',
    prompt_key_remove_last  = 'Retirer le dernier',
    prompt_key_place_spawn  = 'Placer l\'apparition',
    prompt_title_zone       = 'Définir la zone',
    prompt_title_corners    = 'Coins de la zone',
    prompt_title_spawn      = 'Définir le point d\'apparition',
    prompt_title_spawns     = 'Points d\'apparition',
    prompt_spawns_count     = '%s — %s placé(s)',
    prompt_place_zone_poly  = 'Coins de la zone — marque-en 3 ou plus',
    prompt_place_zone_circle = 'Zone du garage — la molette ajuste le rayon',
    prompt_place_store      = 'Point de rangement',
    prompt_back_panel       = 'Retour au panneau',
    prompt_pk_zone_circle   = 'Zone interdite — la molette ajuste le rayon',
    prompt_pk_zone_poly     = 'Zone interdite — marque 3 coins ou plus',

    -- ─────────────────────────────────────────────────────────────
    -- Notifications — admin & stationnement
    -- ─────────────────────────────────────────────────────────────
    n_garage_created      = 'Garage créé.',
    n_garage_updated      = 'Garage mis à jour.',
    n_garage_deleted      = 'Garage supprimé.',
    n_theme_saved         = 'Apparence enregistrée pour tout le serveur.',
    n_theme_reset         = 'Apparence rétablie par défaut.',
    n_veh_added           = 'Véhicule ajouté.',
    n_parked              = 'Véhicule stationné.',
    n_unparked            = 'Véhicule repris — renvoyé au garage.',
    n_park_exiting        = 'Stationnement — tu sors du véhicule…',
    n_park_exit_failed    = 'Tu n\'es pas sorti correctement, mais le véhicule est stationné.',
    n_park_released       = 'Véhicule libéré. Tu peux le conduire.',
    n_park_settings_saved = 'Paramètres de stationnement enregistrés.',
    n_park_veh_removed    = 'Véhicule stationné supprimé.',
    n_park_zone_created   = 'Zone interdite créée.',
    n_park_zone_removed   = 'Zone supprimée.',

    -- ─────────────────────────────────────────────────────────────
    -- Erreurs — admin & stationnement
    -- ─────────────────────────────────────────────────────────────
    e_noperm          = 'Pas de permission.',
    e_theme_invalid   = 'Couleurs invalides.',
    e_zone_create     = 'Échec de la création de la zone.',
    e_no_zone         = 'Ce garage n\'a pas encore de zone définie.',
    e_need_placement  = 'Définis la zone et au moins un point d\'apparition.',
    e_config_readonly = 'Ce garage est défini dans shared/config.lua : modifie-le là-bas et redémarre la ressource.',
    diag_nearest      = 'Garage le plus proche : %s (%s), à %s m — point d\'accès %s',
    diag_none         = 'Aucun garage chargé sur ce client pour l\'instant.',
    e_no_boss_garage  = 'Tu ne gères aucun garage d\'entreprise.',
    e_park_none_near  = 'Tu n\'es près d\'aucun de tes véhicules stationnés.',

    -- ─────────────────────────────────────────────────────────────
    -- INUTILISÉ — plus référencé par aucun code Lua ou NUI.
    -- Conservé pour compatibilité.
    -- ─────────────────────────────────────────────────────────────
    ui_leave            = 'Quitter',
    ui_sort_recent      = 'Récent',
    ui_plate            = 'Plaque',
    ui_theme_brand_desc = 'Boutons, marqueurs et surbrillances sur tout le serveur.',
    ui_theme_bg_desc    = 'Ton de base de l\'interface ; toutes les autres surfaces en dérivent.',
    ui_theme_reset      = 'Réinitialiser',
    ui_theme_save       = 'Enregistrer',
    ui_theme_hint       = 'Les couleurs s\'appliquent à tous les joueurs dès que tu enregistres.',
    ui_theme_unsaved    = 'Aperçu — pas encore enregistré.',
    n_not_owner         = 'Ce véhicule n\'est pas à toi.',
    n_unavailable       = 'Véhicule actuellement indisponible.',
    n_already_out       = 'Ce véhicule est déjà sorti.',
    n_no_money          = 'Fonds insuffisants.',
    n_invalid           = 'Action invalide.',
}
