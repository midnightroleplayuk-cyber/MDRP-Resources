-- ============================================================
-- DANSK (da)
-- ------------------------------------------------------------
-- Lag oven på configs/strings.lua. Enhver nøgle, der mangler
-- her, beholder den engelske tekst, så delvis oversættelse er
-- sikkert.
--
-- Pladsholderne %s skal bevares og i SAMME rækkefølge som i
-- originalen: de udfyldes af :format() i koden. %% udskriver
-- et bogstaveligt procenttegn.
--
-- Aktivering:  Config.Locale = 'da'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['da'] = {
    -- ── Hovedmenu ───────────────────────────────────────────
    main_title = 'Adminmenu',
    self_options = 'Egne Indstillinger',
    self_options_desc = 'Indstillinger der vedrører dig selv',
    player_options_title = 'Spillerindstillinger',
    player_options_desc = 'Indstillinger der vedrører andre spillere',
    vehicle_options = 'Køretøjsindstillinger',
    vehicle_options_desc = 'Indstillinger der vedrører køretøjer',
    server_options = 'Serverindstillinger',
    server_options_desc = 'Indstillinger der vedrører serveren',
    admin_zone_options = 'Adminzoner',
    admin_zone_options_desc = 'Administrer, tilføj og slet adminzoner',
    developer_options = 'Udviklerindstillinger',
    developer_options_desc = '',

    -- ── Egne indstillinger ──────────────────────────────────
    self_options_menu = 'Egne Indstillinger',
    self_health = 'Liv (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Genopliv',
    self_revive_desc = 'Genopliv dig selv',
    self_heal = 'Helbred',
    self_heal_desc = 'Helbred dig selv',
    self_skinmenu = 'Tøjmenu',
    self_set_ped = 'Skift Ped',
    self_skinmenu_desc = 'Åbn tøjmenuen lokalt',
    self_invisible = 'Usynlig',
    self_godmode = 'Gudetilstand',
    self_wallhack = 'Wallhack',

    -- ── Spillerindstillinger ────────────────────────────────
    player_options_menu = 'Spillere Online %s/%s',
    player_options = 'Spiller: %s',
    player_health = 'Spillerens Liv (%s%%)',
    player_freeze = 'Frys',
    player_freeze_desc = 'Slå til/fra',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Slå til/fra',
    player_spectate = 'Overvåg',
    player_spectate_desc = 'Se hvad denne spiller foretager sig',
    player_playerdata = 'Spillerdata',
    player_playerdata_desc = 'Se spillerens data',
    player_revive = 'Genopliv',
    player_revive_desc = 'Genopliv spilleren',
    player_heal = 'Helbred',
    player_heal_desc = 'Helbred spilleren',
    player_skinmenu = 'Tøjmenu',
    player_skinmenu_desc = 'Åbn en tøjmenu hos spilleren',
    player_money = 'Giv Penge',
    player_money_desc = 'Giv penge til den valgte spiller',
    player_item = 'Giv Genstand',
    player_item_desc = 'Giv en genstand til den valgte spiller',
    player_openinv = 'Åbn Inventar',
    player_openinv_desc = 'Åbn spillerens inventar',
    player_clearinv = 'Tøm Inventar',
    player_clearinv_desc = 'Tøm spillerens inventar',
    player_teleport_to = 'Teleportér til Spiller',
    player_teleport_to_desc = 'Teleportér dig til spilleren',
    player_bring = 'Hent',
    player_bring_desc = 'Hent spilleren til din position',
    player_kick = 'Smid Ud',
    player_kick_desc = 'Smid spilleren ud af serveren',
    player_ban = 'Bandlys Spiller',

    -- ── Køretøjsmenu ────────────────────────────────────────
    vehicle_menu = 'Køretøjsmenu',
    spawn_car = 'Spawn Køretøj',
    spawn_car_desc = 'Spawn et køretøj',
    repair_car = 'Reparér Køretøj',
    repair_car_desc = 'Reparér det nuværende eller nærmeste køretøj',
    delete_car = 'Slet Køretøj',
    delete_car_desc = 'Slet det nuværende eller nærmeste køretøj',
    number_plate = 'Ændr Nummerplade',
    number_plate_desc = 'Ændr teksten på den nuværende nummerplade',
    refuel = 'Tank Køretøj',
    refuel_desc = 'Tank det nuværende eller nærmeste køretøj',
    give_keys = 'Giv Nøgler',
    give_keys_desc = 'Giv dig selv nøglerne til det nuværende køretøj',
    doors = 'Lås/Lås Op',
    doors_desc = 'Skifter låsene på det nærmeste køretøj',
    boost_car = 'Momentmultiplikator',
    boost_car_desc = 'Ændr momentet på det nuværende køretøj',
    color_change = 'Ændr Køretøjsfarve',
    color_change_desc = 'Ændr farven på det nuværende eller nærmeste køretøj',

    -- ── Serveradministration ────────────────────────────────
    server_management = 'Serveradministration',
    server_announcement = 'Serverbesked',
    server_announcement_desc = 'Send en global besked til hele serveren',
    ban_list = 'Bandlysningsliste',
    ban_list_desc = 'Se alle aktive bandlysninger',
    objects_list = 'Slet Entiteter',
    objects_list_desc = 'Slet køretøjer og peds',
    objects_list_label = 'Indstillinger',
    weather_menu = 'Vejradministration',
    weather_menu_desc = 'Administrer vejret',

    -- ── Adminzoner ──────────────────────────────────────────
    zones_create = 'Opret Zone',
    zones_create_desc = 'Opret en ny adminzone',
    zones_manage = 'Administrer Zoner',
    zones_manage_desc = 'Redigér eller slet aktive zoner',
    zone_edit_current = 'Redigér Nuværende Zone',
    zone_edit_current_desc = 'Administrer den zone, du befinder dig i',
    zone_delete_current = 'Slet Nuværende Zone',
    zone_delete_current_desc = 'Slet den zone, du befinder dig i',
    zone_manage_menu = 'Redigerer Zone (%s)',
    zone_edit = 'Redigér Zone',
    zone_edit_desc = 'Ændr zone: %s',
    zone_delete = 'Slet Zone',
    zone_delete_desc = 'Slet zone: %s',
    zone_teleport = 'Teleportér til Zone',
    zone_teleport_desc = 'Gå til zone: %s',

    -- ── Udviklermenu ────────────────────────────────────────
    dev_options = 'Udviklerindstillinger',
    debug_mode = 'Fejlfindingstilstand',
    debug_mode_desc = 'Slå fejlfindingstilstand til/fra',
    copy_vec3 = 'Kopiér Vector3-koordinater',
    copy_vec3_desc = 'Kopierer din nuværende position (vector3) til udklipsholderen',
    copy_vec4 = 'Kopiér Vector4-koordinater',
    copy_vec4_desc = 'Kopierer din nuværende position (vector4) til udklipsholderen',
    copy_heading = 'Kopiér Retning',
    copy_heading_desc = 'Kopierer din nuværende retning til udklipsholderen',
    cant_delete = 'Kan ikke slettes!',
    cant_delete_player_desc = 'Du kan ikke slette spilleres peds!',
    cant_delete_entity_desc = 'Du kan ikke slette kortets standardobjekter!',

    -- ── Bandlysningsliste ───────────────────────────────────
    ban_list_menu = 'Bandlysningsliste',
    ban_list_name = 'Navn: %s',
    ban_list_license = 'Licens:',
    ban_list_by = 'Udstedt af: %s',
    ban_list_reason = 'Årsag: %s',
    ban_list_length = 'Tid tilbage: %s timer %s minutter',
    ban_list_modify = 'Ændr Bandlysning',
    ban_list_unban = 'Ophæv Bandlysning',
    ban_list_no_data = 'Ingen Bandlysninger',
    ban_list_no_data_desc = 'Der blev ikke fundet nogen aktive bandlysninger!',

    -- ── Spillerdata ─────────────────────────────────────────
    playerdata_menu = 'Spillerdata',
    playerdata_license_esx = 'Licens: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Klik for at kopiere hele licensen',
    playerdata_igname = 'Navn: %s',
    playerdata_igname_desc = 'Spillerens fulde navn i spillet',
    playerdata_steam = 'Steam-navn: %s',
    playerdata_steam_desc = 'Spillerens fulde Steam-navn',
    playerdata_gender = 'Køn: %s',
    playerdata_gender_desc = 'Spillerens køn',
    playerdata_cash = 'Kontanter: %s',
    playerdata_cash_desc = 'Spillerens kontantbeholdning',
    playerdata_bank = 'Bank: %s',
    playerdata_bank_desc = 'Spillerens banksaldo',
    playerdata_blackmoney = 'Sorte Penge: %s',
    playerdata_blackmoney_desc = 'Spillerens beholdning af sorte penge',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Tryk [E] for at slette entiteten  \nHash: %s  \nKoordinater: vec3(%s, %s, %s)  \nRetning: %s  \nEjer: [%s] - %s',
    debug_textui_noname = 'Tryk [E] for at slette entiteten\n  Hash: %s\n  Koordinater: vec3(%s, %s, %s)\n  Retning: %s\n  Ejer: UKENDT',

    textui_invisible = 'Usynlighedstilstand - Aktiv',
    textui_godmode = 'Gudetilstand - Aktiv',
    textui_wallhack = 'Wallhack - Aktiv',
    textui_noclip_activated = 'No Clip - Aktiv',
    textui_torque = 'Momentmultiplikator - %s',

    -- ── Beskeder ────────────────────────────────────────────
    dialog_announce = 'Besked',
    dialog_announce_label = 'Besked',
    dialog_announce_select = 'Alle',
    dialog_announce_everyone = 'Alle',
    dialog_announce_placeholder = 'Vigtig besked her. . .',

    -- ── Ophæv bandlysning ───────────────────────────────────
    dialog_unban = 'Er du sikker?',
    dialog_unban_content = 'Vil du virkelig ophæve bandlysningen af %s?',

    -- ── Slet entiteter ──────────────────────────────────────
    dialog_objects = 'Vælg en mulighed',
    dialog_clear_objects = 'Slet ALLE objekter',
    dialog_clear_cars = 'Slet ALLE biler (uden fører)',
    dialog_clear_peds = 'Slet ALLE peds',

    -- ── Giv penge ───────────────────────────────────────────
    dialog_givemoney = 'Giv Penge',
    givemoney_input_label = 'Beløb',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Konto',
    givemoney_select_option1 = 'Kontanter',
    givemoney_select_option2 = 'Bank',
    givemoney_select_option3 = 'Sorte Penge',

    -- ── Giv genstand ────────────────────────────────────────
    dialog_giveitem = 'Giv Genstand',
    giveitem_input_label = 'Genstandens Navn',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Antal',
    giveitem_amount_input_placeholder = '3',

    -- ── Spawn køretøj ───────────────────────────────────────
    dialog_spawn_a_car = 'Spawn Køretøj',
    dialog_car_model = 'Modelnavn',
    dialog_car_model_holder = 'F.eks: 20charger',
    dialog_car_plate = 'Nummerplade (valgfrit)',
    dialog_car_plate_holder = 'F.eks: W4S4B1',
    dialog_car_color_primary = 'Primær Farve (valgfrit)',
    dialog_car_color_second = 'Sekundær Farve (valgfrit)',
    dialog_car_maxed = 'Maksimale Modifikationer (valgfrit)',

    -- ── Smid ud ─────────────────────────────────────────────
    dialog_kick = 'Smid %s ud',
    dialog_kick_reason = 'Årsag',
    dialog_kick_placeholder = 'Snyder',
    kicked_reason_replace = 'Du er blevet smidt ud af serveren!',

    -- ── Bandlysning ─────────────────────────────────────────
    dialog_ban = 'Bandlys %s',
    dialog_ban_reason = 'Årsag',
    dialog_ban_placeholder = 'Snyder',
    ban_reason_replace = 'Du er blevet bandlyst fra denne server!',

    -- ── Opret zone ──────────────────────────────────────────
    dialog_zone_create = 'Opret Zone',
    dialog_zone_name = 'Navn',
    dialog_zone_name_desc = 'Navnet på zonen / blippet',
    dialog_zone_name_holder = 'Adminzone',
    dialog_zone_text = 'Vist Tekst',
    dialog_zone_text_desc = 'Teksten der vises til spillere inde i zonen',
    dialog_zone_text_holder = 'ADMINZONE - AKTIV',
    dialog_zone_size = 'Størrelse',
    dialog_zone_speed = 'Hastighedsgrænse',
    mph = 'MPH',
    kmh = 'KM/T',
    dialog_zone_blip_id = 'Blip-ID',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'Farve-ID',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Blinkende Blip',
    dialog_zone_disarm = 'Afvæbn',
    dialog_zone_revive = 'Genopliv',
    dialog_zone_invincible = 'Udødelig',
    dialog_zone_edit = 'Redigerer "%s"',
    dialog_zone_delete_confirm = 'Er du sikker?',
    dialog_zone_delete_confirm_desc = 'Vil du virkelig slette zonen: %s',

    -- ── Notifikationer: penge ───────────────────────────────
    notify_givemoney_success = 'Penge Givet',
    -- Argumentrækkefølgen skal følge engelsk: spiller, beløb, konto.
    notify_givemoney_success_desc = 'Du krediterede %s med $%s på kontoen: %s',
    notify_givemoney_fail = 'Mislykkedes',
    notify_givemoney_fail_desc = 'Du forsøgte at indsætte til %s, men noget gik galt! Prøv igen.',

    -- ── Notifikationer: genstande ───────────────────────────
    notify_giveitem_success = 'Genstand Givet',
    notify_giveitem_success_desc = 'Du gav til %s. Genstand: %s Antal: %s',
    notify_giveitem_fail = 'Mislykkedes',
    notify_giveitem_fail_desc = 'Du forsøgte at give til %s, men noget gik galt! Prøv igen.',

    -- ── Notifikationer: udsmidning / bandlysning ────────────
    notify_kicked_success = 'Udsmidning Lykkedes',
    notify_kicked_success_desc = 'Du smed %s ud',
    notify_banned_success = 'Bandlysning Lykkedes',
    notify_banned_success_desc = 'Du bandlyste %s',

    -- ── Notifikationer: inventar ────────────────────────────
    notify_clearedinv = 'Inventar Tømt',
    notify_clearedinv_desc = 'Du tømte inventaret for %s',

    -- ── Notifikationer: ugyldigt ID ─────────────────────────
    notify_invalidid = 'Ugyldigt ID',
    notify_invalidid_desc = 'Det indtastede ID var ugyldigt, prøv igen.',

    -- ── Notifikationer: oprydning ───────────────────────────
    notify_deleted_car = 'Biler Slettet',
    notify_deleted_car_desc = 'Du slettede alle biler uden fører.',
    notify_deleted_ped = 'Peds Slettet',
    notify_deleted_ped_desc = 'Du slettede alle peds på kortet',
    notify_deleted_objects = 'Objekter Slettet',
    notify_deleted_objects_desc = 'Du slettede alle objekter på kortet',

    -- ── Notifikationer: vejr ────────────────────────────────
    notify_weather = 'Vejr Ændret',
    notify_weather_desc = 'Vejret ændret til: %s',

    -- ── Notifikationer: kopiér koordinater ──────────────────
    notify_copied = 'Kopieret',
    notify_copied_vec3 = 'Vector3 kopieret til udklipsholderen!',
    notify_copied_vec4 = 'Vector4 kopieret til udklipsholderen!',
    notify_copied_headin = 'Retning kopieret til udklipsholderen!',

    -- ── Notifikationer: døre ────────────────────────────────
    notify_locked_doors = 'Låst',
    notify_locked_doors_desc = 'Køretøjets døre blev låst.',
    notify_unlocked_doors = 'Låst Op',
    notify_unlocked_doors_desc = 'Køretøjets døre blev låst op.',

    -- ── Notifikationer: adminzoner ──────────────────────────
    notify_zone_deleted = 'Zone Slettet',
    notify_zone_deleted_desc = 'Du fjernede zonen: %s.',
    notify_zone_not_deleted_desc = 'Der opstod en fejl under sletning af zonen: %s.',
    notify_zone_edited = 'Zone Ændret',
    notify_zone_edited_desc = 'Du ændrede zonen: %s.',
    notify_zone_not_edited_desc = 'Der opstod en fejl under ændring af zonen: %s.',
    notify_zone_action_cancelled = 'Handling Annulleret',
    notify_zone_delete_cancel = 'Du annullerede sletningen af zonen: %s',
    notify_zone_no_weapons = 'Våben Ikke Tilladt',
    notify_zone_no_weapons_desc = 'Du må ikke bruge våben inde i denne zone.',
    notify_zones_not_found = 'Ingen Zoner',
    notify_zones_not_found_desc = 'Der er i øjeblikket ingen aktive zoner at administrere.',
    notify_zones_teleport = 'Teleporteret',
    notify_zones_teleport_desc = 'Du blev teleporteret til zonen: %s.',

    -- ── Notifikationer: ophævet bandlysning ─────────────────
    successfully_unbanned = 'Bandlysning Ophævet',
    successfully_unbanned_desc = 'Du ophævede bandlysningen af: %s.',
    unsuccessful_unban = 'Noget gik galt ved ophævelse af bandlysningen for: %s.',

    -- ── Forbindelse (deferrals) ─────────────────────────────
    deferral_welcome = '[%s] Hej %s, tjekker bandlysninger. . .',
    deferral_banned = 'Du er bandlyst fra serveren. Årsag: "%s" (Tid tilbage: %s timer %s minutter).',
    deferral_banned_perm = 'Du er bandlyst fra serveren. Årsag: "%s" (Tid tilbage: Permanent).',

    -- ── Fejl ────────────────────────────────────────────────
    notify_error = 'Fejl',
    notify_disabled_keys = 'Der er ikke konfigureret noget script til køretøjsnøgler. Kontakt serverudvikleren.',
    notify_no_appearance = 'Der blev ikke fundet noget tøj-/udseendescript. Kontakt serverudvikleren.',
    notify_no_vehicle = 'Intet køretøj fundet!',
    notify_invalid_entry = 'Ugyldigt input!',

    -- ── Tastegenvej ─────────────────────────────────────────
    keymapping_desc = 'Åbn Adminmenuen (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Aktiveret',
    noclip_deactivated = 'NoClip Deaktiveret',

    -- ── Usynlighed ──────────────────────────────────────────
    invisibility_activated = 'Usynlighedstilstand Aktiveret',
    invisibility_deactivated = 'Usynlighedstilstand Deaktiveret',

    -- ── Gudetilstand ────────────────────────────────────────
    godmode_activated = 'Gudetilstand Aktiveret',
    godmode_deactivated = 'Gudetilstand Deaktiveret',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Aktiveret',
    wallhack_deactivated = 'Wallhack Deaktiveret',

    -- ── Fejlfindingstilstand ────────────────────────────────
    debug_activated = 'Fejlfindingstilstand Aktiveret',
    debug_deactivated = 'Fejlfindingstilstand Deaktiveret',

    -- ── Notifikationer: køretøjer ───────────────────────────
    vehicle_repaired = 'Køretøj Repareret',
    vehicle_repaired_desc = 'Køretøjet er blevet repareret.',
    vehicle_deleted = 'Køretøj Slettet',
    vehicle_deleted_desc = 'Køretøjet er blevet slettet.',
    vehicle_spawned = 'Køretøj Spawnet',
    vehicle_spawned_desc = 'Køretøjet %s er blevet spawnet.',
    vehicle_plate_changed = 'Nummerplade Ændret',
    vehicle_plate_changed_desc = 'Køretøjets nummerplade ændret til: %s',
    vehicle_refueled = 'Køretøj Tanket',
    vehicle_refueled_desc = 'Køretøjet er blevet tanket.',
    vehicle_keys_given = 'Nøgler Modtaget',
    vehicle_keys_given_desc = 'Du har modtaget nøglerne til køretøjet med pladen: %s',
    vehicle_color_changed = 'Køretøjsfarve Ændret',
    vehicle_color_changed_desc = 'Køretøjets farve ændret til: %s',
    vehicle_torque_set = 'Momentmultiplikator Sat',
    vehicle_torque_set_desc = 'Moment sat til: %sx',
    vehicle_torque_disabled = 'Momentmultiplikator Slået Fra',

    -- ── Overvågning ─────────────────────────────────────────
    spectate_started = 'Overvåger',
    spectate_started_desc = 'Du overvåger %s. Tryk X for at stoppe.',
    spectate_ended = 'Overvågning Afsluttet',
    spectate_ended_desc = 'Du overvåger ikke længere nogen.',
    spectate_error = 'Overvågningsfejl',
    spectate_error_desc = 'Målspilleren blev ikke fundet eller findes ikke længere.',

    -- ── Teleportering ───────────────────────────────────────
    teleport_success = 'Teleporteret',
    teleport_success_desc = 'Du er blevet teleporteret.',

    -- ── Genoplivning / helbredelse ──────────────────────────
    player_revived = 'Spiller Genoplivet',
    player_revived_desc = 'Du genoplivede %s.',
    player_healed = 'Spiller Helbredt',
    player_healed_desc = 'Du helbredte %s.',
    self_revived = 'Genoplivet',
    self_revived_desc = 'Du genoplivede dig selv.',
    self_healed = 'Helbredt',
    self_healed_desc = 'Du helbredte dig selv.',

    -- ── Peds ────────────────────────────────────────────────
    ped_changed = 'Ped Skiftet',
    ped_changed_desc = 'Din ped-model er blevet ændret.',
    ped_restored = 'Ped Gendannet',
    ped_restored_desc = 'Din oprindelige ped-model er blevet gendannet.',

    skin_menu_opened = 'Tøjmenu Åbnet',

    admin_menu_opened = 'Adminmenu Åbnet',
    admin_menu_closed = 'Adminmenu Lukket',

    entity_deleted = 'Entitet Slettet',
    entity_deleted_desc = 'Entiteten er blevet slettet.',

    player_frozen = 'Spiller Frosset',
    player_frozen_desc = 'Spilleren %s er blevet frosset.',
    player_unfrozen = 'Spiller Optøet',
    player_unfrozen_desc = 'Spilleren %s er blevet optøet.',

    -- ── Egen nummerplade ────────────────────────────────────
    dialog_license_plate = 'Egen Nummerplade',
    dialog_license_plate_label = 'Plade',
    dialog_license_plate_placeholder = 'Nummerplade',

    -- ── Tag penge ───────────────────────────────────────────
    player_removemoney = 'Tag Penge',
    player_removemoney_desc = 'Tag penge fra den valgte spiller',
    dialog_removemoney = 'Tag Penge',
    removemoney_input_label = 'Beløb',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Konto',
    notify_removemoney_success = 'Penge Fjernet',
    notify_removemoney_success_desc = 'Du tog $%s fra %s (konto: %s)',
    notify_removemoney_fail = 'Mislykkedes',
    notify_removemoney_fail_desc = 'Kunne ikke tage penge fra %s (måske utilstrækkelig saldo).',

    -- ── Dimensioner / routing buckets ───────────────────────
    self_dimension = 'Sæt Min Dimension',
    self_dimension_desc = 'Flyt dig til en routing bucket (0 = hovedverdenen)',
    player_dimension = 'Sæt Dimension',
    player_dimension_desc = 'Flyt denne spiller til en routing bucket',
    player_dimension_bring = 'Hent til Min Dimension',
    player_dimension_bring_desc = 'Træk denne spiller ind i din nuværende dimension',
    player_dimension_goto = 'Deltag i Spillerens Dimension',
    player_dimension_goto_desc = 'Flyt dig til denne spillers dimension',
    dialog_dimension = 'Sæt Dimension',
    dimension_input_label = 'Dimension (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Dimension Ændret',
    notify_dimension_self_desc = 'Du er nu i dimension %s.',
    notify_dimension_player_desc = '%s blev flyttet til dimension %s.',
    notify_dimension_join_desc = 'Du gik ind i %s dimension (%s).',
    notify_dimension_fail = 'Dimensionsfejl',
    notify_dimension_fail_desc = 'Kunne ikke skifte dimension.',

    -- ── Teleportér ind i køretøjet ──────────────────────────
    player_tp_vehicle = 'Teleportér ind i Køretøjet',
    player_tp_vehicle_desc = 'Sæt dig ind i denne spillers køretøj for at hjælpe med at bjærge det',
    notify_tp_vehicle_fail = 'Intet Køretøj',
    notify_tp_vehicle_fail_desc = '%s sidder ikke i et køretøj.',
    notify_tp_vehicle_success = 'Teleporteret',
    notify_tp_vehicle_success_desc = 'Du blev placeret i %s køretøj.',

    -- ── Bjærg køretøj ───────────────────────────────────────
    recover_car = 'Bjærg / Vend Køretøj',
    recover_car_desc = 'Vend det rigtigt og flyt det til nærmeste vej (vand/væltet)',
    vehicle_recovered = 'Køretøj Bjærget',
    vehicle_recovered_desc = 'Køretøjet blev vendt rigtigt og placeret på nærmeste vej.',

    -- ── Ejede køretøjer ─────────────────────────────────────
    player_owned_vehicles = 'Ejede Køretøjer',
    player_owned_vehicles_desc = 'Se, tilføj eller fjern denne spillers biler',
    owned_vehicles_menu = 'Ejede Køretøjer (%s)',
    owned_vehicles_add = 'Tilføj Køretøj',
    owned_vehicles_add_desc = 'Tilføj et køretøj til denne spillers garage',
    owned_vehicles_none = 'Ingen Køretøjer',
    owned_vehicles_none_desc = 'Denne spiller ejer ingen køretøjer.',
    owned_vehicle_desc = 'Plade: %s · klik for at fjerne',
    dialog_add_vehicle = 'Tilføj Køretøj',
    add_vehicle_model_label = 'Modelnavn',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Nummerplade (valgfrit)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = 'Fjern %s?',
    notify_owned_added = 'Køretøj Tilføjet',
    notify_owned_added_desc = 'Tilføjede %s (plade %s) til %s.',
    notify_owned_removed = 'Køretøj Fjernet',
    notify_owned_removed_desc = 'Fjernede pladen %s fra %s.',
    notify_owned_fail = 'Databasefejl',
    notify_owned_fail_desc = 'Databaseoperationen for køretøjer mislykkedes.',

    -- ── Ped-menu ────────────────────────────────────────────
    player_pedmenu = 'Giv Ped-menu',
    player_pedmenu_desc = 'Åbn en ped-valgmenu på denne spillers skærm',
    pedmenu_title = 'Ped-menu',
    pedmenu_given = 'Ped-menu Sendt',
    pedmenu_given_desc = 'Ped-menu åbnet for %s.'
}
