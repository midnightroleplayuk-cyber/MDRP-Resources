Locales = Locales or {}

-- Français. Garde les clés synchronisées avec en.lua.
Locales['fr'] = {
    -- ── Marque ──
    brand_name        = 'APEX',
    brand_accent      = 'GANGS',
    brand_sub         = 'Commandement de Gang',

    -- ── Générique ──
    ui_open           = 'Ouvrir',
    ui_close          = 'Fermer',
    ui_save           = 'Enregistrer',
    ui_cancel         = 'Annuler',
    ui_confirm        = 'Confirmer',
    ui_delete         = 'Supprimer',
    ui_edit           = 'Modifier',
    ui_create         = 'Créer',
    ui_refresh        = 'Actualiser',
    ui_search         = 'Rechercher…',
    ui_none           = 'Aucun',
    ui_loading        = 'Chargement…',

    -- ── Onglets ──
    tab_overview      = 'Aperçu',
    tab_members       = 'Membres',
    tab_ranks         = 'Grades',
    tab_turf          = 'Territoire',
    tab_graffiti      = 'Graffiti',
    tab_vault         = 'Coffre',
    tab_garage        = 'Garage',
    tab_operations    = 'Opérations',
    tab_tasks         = 'Tâches',
    tab_upgrades      = 'Améliorations',
    tab_medic         = 'Médecin',
    tab_logs          = 'Journaux',
    tab_settings      = 'Paramètres',
    tab_admin         = 'Admin',

    -- ── Notifications ──
    notify_no_gang        = "Tu n'es dans aucun gang.",
    notify_not_authorized = "Tu n'es pas autorisé.",
    notify_menu_failed    = "Impossible d'ouvrir le menu (%s) — ce n'est pas un problème de permissions. Regarde la console du serveur.",
    notify_perm_report    = 'Rapport de permissions affiché dans ta console F8.',
    notify_perm_report_offline = "Aucun joueur connecté avec cet id.",
    notify_no_permission  = "Tu n'as pas la permission pour cela.",
    notify_not_leader     = 'Seuls les chefs de gang peuvent faire cela.',
    notify_gang_created   = 'Gang "%s" créé.',
    notify_gang_deleted   = 'Gang supprimé.',
    notify_gang_full      = 'Le gang est complet.',
    notify_member_joined  = 'Tu as rejoint %s.',
    notify_member_kicked  = 'Tu as été retiré de %s.',
    notify_member_invited = '%s invité.',
    notify_promoted       = '%s promu.',
    notify_demoted        = '%s rétrogradé.',
    notify_lead_transfer  = 'Direction transférée à %s.',
    notify_cooldown       = 'En attente — réessaie plus tard.',
    notify_saved          = 'Enregistré.',
    notify_deleted        = 'Supprimé.',

    -- ── Territoire ──
    turf_entering         = 'Entrée dans le territoire de %s',
    turf_leaving          = 'Sortie du territoire de %s',
    turf_neutral          = 'Territoire neutre',
    turf_capturing        = 'Capture… %d%%',
    turf_contested        = 'Territoire contesté !',
    turf_captured         = '%s a capturé %s',
    turf_lost             = 'Ton gang a perdu %s',
    turf_tagging          = 'Marquage de ce territoire… %d/%d tags',

    -- ── Graffiti ──
    graffiti_placed       = 'Tag posé.',
    graffiti_removed      = 'Tag retiré.',
    graffiti_limit        = 'Limite de graffiti atteinte.',
    graffiti_no_wall      = 'Vise un mur plat.',
    graffiti_aim          = 'Vise où peindre · [E] confirmer · [Esc] annuler',
    graffiti_rotate       = 'Pivoter',
    graffiti_resize       = 'Redimensionner',
    graffiti_place        = 'Placer',
    graffiti_cancel       = 'Annuler',
    graffiti_spraying     = 'Application du graffiti…',
    graffiti_spraying_sub = 'Reste immobile pendant que tu tagues le mur',
    graffiti_shaking      = 'Agitation de la bombe…',
    graffiti_shaking_sub  = 'Mélange de la peinture',
    graffiti_size         = 'Taille',
    graffiti_rotation     = 'Rotation',
    graffiti_draw         = 'Dessiner',

    -- ── Coffre ──
    vault_deposited       = 'Tu as déposé %s.',
    vault_withdrawn       = 'Tu as retiré %s.',
    vault_insufficient    = 'Fonds insuffisants.',

    -- ── Garage ──
    garage_stored         = 'Véhicule rangé.',
    garage_out            = 'Véhicule sorti.',
    garage_limit          = 'Le garage est plein.',
    garage_not_here       = 'Aucun point de garage à proximité.',
    garage_not_yours      = "Ce n'est pas ton véhicule — seules tes propres voitures peuvent aller dans le garage du gang.",
    garage_not_gang       = 'Ce véhicule appartient à un autre gang.',

    -- ── Opérations ──
    scout_started         = 'Reconnaissance en cours…',
    scout_done            = 'Reconnaissance terminée — renseignements obtenus.',
    scout_failed          = 'Reconnaissance échouée.',
    scout_alerted         = 'Un rival te surveille !',
    scout_left_zone       = 'Reconnaissance annulée — tu as quitté le territoire.',
    scout_cancelled       = 'Reconnaissance annulée.',
    scout_busy            = 'Une reconnaissance est déjà en cours.',
    scout_prompt          = 'Reconnaître %s',
    raid_started          = 'Raid lancé !',
    raid_incoming         = 'Ton gang subit un raid !',
    raid_success          = 'Raid réussi.',
    raid_failed           = 'Raid échoué.',
    raid_need_scout       = "Fais d'abord la reconnaissance de la cible.",
    raid_need_attackers   = "Pas assez d'attaquants.",

    -- ── Tâches ──
    task_complete         = 'Tâche terminée : %s',
    task_progress         = '%s · %d/%d',
    hq_nothing            = 'Rien à explorer ici pour le moment — récupère d\'abord le contrat "Repérer le QG".',
    mission_started       = 'Mission : %s — suis le marqueur.',
    mission_done          = 'Mission terminée — paiement envoyé au gang.',
    mission_failed        = 'Mission échouée.',
    mission_busy          = 'Tu as déjà une mission en cours.',
    mission_deliver       = 'Livre-le au point de dépôt.',
    mission_cancelled     = 'Mission annulée.',
    mission_none          = "Tu n'as aucune mission en cours.",
    mission_cancel_hint   = 'Annule à tout moment avec /cancelmission (ou F6 → Annuler Mission).',
    mstep_travel          = "Rends-toi à l'endroit",
    mstep_eliminate       = 'Élimine la cible',
    mstep_meet            = "Rejoins l'acheteur pour récupérer",
    mstep_grab            = 'Récupère le colis',
    mstep_grab_person     = 'Porte la cible (F6 → Porter / [E])',
    mstep_grab_body       = 'Porte le corps (F6 → Porter / [E])',
    mstep_deliver         = 'Dépose la cible chez les acheteurs (F6 → Déposer / [E])',
    mstep_dispose         = 'Dépose le corps ici (F6 → Déposer / [E])',
    mstep_clear           = 'Élimine les gardes du cartel',
    mstep_grab_loot       = 'Récupère la cargaison',
    mstep_sell            = 'Vends aux acheteurs',

    -- ── Réputation ──
    rep_label             = 'Réputation',
    need_rep              = "Ton gang a besoin de plus de réputation pour faire un raid.",

    -- ── Niveaux / améliorations ──
    level_up              = 'Ton gang a atteint le niveau %d !',
    upgrade_bought        = 'Amélioration achetée : %s',
    upgrade_maxed         = 'Amélioration déjà au maximum.',
    upgrade_level_locked  = 'Nécessite un gang de niveau %d.',

    -- ── Médecin ──
    medic_healed          = 'Tu as été soigné.',
    medic_revived         = 'Tu as été réanimé.',
    medic_locked          = "Le médecin du gang n'est pas débloqué.",

    -- ── Créateur / éditeur ──
    creator_title         = 'Zones de Gang',
    creator_aim           = 'Vise où le point doit être · [E] confirmer · [Esc] annuler',
    creator_saved         = 'Zone "%s" enregistrée.',
    creator_deleted       = 'Zone supprimée.',

    -- ── Mode test ──
    test_enabled          = 'Mode test ACTIVÉ — invasions en solo + défenseurs PNJ.',
    test_disabled         = 'Mode test DÉSACTIVÉ.',
    test_defenders        = '%d défenseurs arrivent !',
    test_zone_cleared     = 'Zone nettoyée — tiens-la pour la capturer.',
    test_rival_created    = 'Gang rival de test prêt : %s',
    test_zone_created     = 'Zone de territoire rival créée ici (propriétaire : %s). Entre et appuie sur [E] pour reconnaître.',
    test_zone_nocoords    = "Pas encore de position — déplace-toi de quelques pas et réessaie.",

    -- ── Largage aérien ──
    airdrop_inbound       = 'Un largage aérien arrive — trouve la caisse !',
    airdrop_dispatched    = 'Largage aérien envoyé.',
    airdrop_no_zones      = 'Aucune zone de largage aérien activée.',
    airdrop_locked        = "La caisse est encore scellée — attends qu'elle s'arme.",
    airdrop_open          = 'Ouvrir le Largage',
    airdrop_looted        = 'Largage aérien pillé !',

    -- ── Invite dans le monde ──
    prompt_open_menu      = 'Ouvrir le Menu du Gang',
    target_open           = 'Ouvrir le Menu du Gang',
}
