-- ============================================================
-- ROMÂNĂ (ro)
-- ------------------------------------------------------------
-- Strat peste configs/strings.lua. Orice cheie care lipsește
-- aici păstrează textul în engleză, deci traducerea parțială
-- este sigură.
--
-- Marcajele %s trebuie păstrate și în ACEEAȘI ordine ca în
-- original: sunt completate de :format() în cod. %% afișează
-- un semn de procent literal.
--
-- Activare:  Config.Locale = 'ro'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['ro'] = {
    -- ── Meniu principal ─────────────────────────────────────
    main_title = 'Meniu Administrare',
    self_options = 'Opțiuni Personale',
    self_options_desc = 'Opțiuni care te privesc',
    player_options_title = 'Opțiuni Jucător',
    player_options_desc = 'Opțiuni care privesc alți jucători',
    vehicle_options = 'Opțiuni Vehicul',
    vehicle_options_desc = 'Opțiuni care privesc vehiculele',
    server_options = 'Opțiuni Server',
    server_options_desc = 'Opțiuni care privesc serverul',
    admin_zone_options = 'Zone Admin',
    admin_zone_options_desc = 'Gestionează, adaugă și șterge zone admin',
    developer_options = 'Opțiuni Dezvoltator',
    developer_options_desc = '',

    -- ── Opțiuni personale ───────────────────────────────────
    self_options_menu = 'Opțiuni Personale',
    self_health = 'Viață (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Reanimare',
    self_revive_desc = 'Reanimează-te',
    self_heal = 'Vindecare',
    self_heal_desc = 'Vindecă-te',
    self_skinmenu = 'Meniu Haine',
    self_set_ped = 'Schimbă Ped',
    self_skinmenu_desc = 'Deschide meniul de haine local',
    self_invisible = 'Invizibil',
    self_godmode = 'Mod Zeu',
    self_wallhack = 'Wallhack',

    -- ── Opțiuni jucător ─────────────────────────────────────
    player_options_menu = 'Jucători Online %s/%s',
    player_options = 'Jucător: %s',
    player_health = 'Viața Jucătorului (%s%%)',
    player_freeze = 'Îngheață',
    player_freeze_desc = 'Activează/dezactivează',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Activează/dezactivează',
    player_spectate = 'Urmărește',
    player_spectate_desc = 'Urmărește acțiunile acestui jucător',
    player_playerdata = 'Date Jucător',
    player_playerdata_desc = 'Vezi datele jucătorului',
    player_revive = 'Reanimare',
    player_revive_desc = 'Reanimează jucătorul',
    player_heal = 'Vindecare',
    player_heal_desc = 'Vindecă jucătorul',
    player_skinmenu = 'Meniu Haine',
    player_skinmenu_desc = 'Deschide un meniu de haine la jucător',
    player_money = 'Dă Bani',
    player_money_desc = 'Dă bani jucătorului selectat',
    player_item = 'Dă Obiect',
    player_item_desc = 'Dă un obiect jucătorului selectat',
    player_openinv = 'Deschide Inventarul',
    player_openinv_desc = 'Deschide inventarul jucătorului',
    player_clearinv = 'Golește Inventarul',
    player_clearinv_desc = 'Golește inventarul jucătorului',
    player_teleport_to = 'Teleportare la Jucător',
    player_teleport_to_desc = 'Teleportează-te la jucător',
    player_bring = 'Adu',
    player_bring_desc = 'Adu jucătorul la poziția ta',
    player_kick = 'Dă Afară',
    player_kick_desc = 'Dă jucătorul afară de pe server',
    player_ban = 'Banează Jucătorul',

    -- ── Meniu vehicul ───────────────────────────────────────
    vehicle_menu = 'Meniu Vehicul',
    spawn_car = 'Creează Vehicul',
    spawn_car_desc = 'Creează un vehicul',
    repair_car = 'Repară Vehiculul',
    repair_car_desc = 'Repară vehiculul curent sau cel mai apropiat',
    delete_car = 'Șterge Vehiculul',
    delete_car_desc = 'Șterge vehiculul curent sau cel mai apropiat',
    number_plate = 'Modifică Numărul',
    number_plate_desc = 'Schimbă textul numărului de înmatriculare curent',
    refuel = 'Alimentează Vehiculul',
    refuel_desc = 'Alimentează vehiculul curent sau cel mai apropiat',
    give_keys = 'Dă Cheile',
    give_keys_desc = 'Dă-ți cheile vehiculului curent',
    doors = 'Blochează/Deblochează Ușile',
    doors_desc = 'Comută încuietorile celui mai apropiat vehicul',
    boost_car = 'Multiplicator de Cuplu',
    boost_car_desc = 'Modifică cuplul vehiculului curent',
    color_change = 'Schimbă Culoarea Vehiculului',
    color_change_desc = 'Schimbă culoarea vehiculului curent sau cel mai apropiat',

    -- ── Administrarea serverului ────────────────────────────
    server_management = 'Administrarea Serverului',
    server_announcement = 'Anunț Server',
    server_announcement_desc = 'Trimite un anunț global întregului server',
    ban_list = 'Listă Banuri',
    ban_list_desc = 'Verifică toate banurile active',
    objects_list = 'Șterge Entități',
    objects_list_desc = 'Șterge vehicule și ped-uri',
    objects_list_label = 'Opțiuni',
    weather_menu = 'Administrarea Vremii',
    weather_menu_desc = 'Administrează vremea',

    -- ── Zone admin ──────────────────────────────────────────
    zones_create = 'Creează Zonă',
    zones_create_desc = 'Creează o nouă zonă admin',
    zones_manage = 'Administrează Zonele',
    zones_manage_desc = 'Editează sau șterge zonele active',
    zone_edit_current = 'Editează Zona Curentă',
    zone_edit_current_desc = 'Administrează zona în care te afli',
    zone_delete_current = 'Șterge Zona Curentă',
    zone_delete_current_desc = 'Șterge zona în care te afli',
    zone_manage_menu = 'Editare Zonă (%s)',
    zone_edit = 'Editează Zona',
    zone_edit_desc = 'Modifică zona: %s',
    zone_delete = 'Șterge Zona',
    zone_delete_desc = 'Șterge zona: %s',
    zone_teleport = 'Teleportare la Zonă',
    zone_teleport_desc = 'Mergi la zona: %s',

    -- ── Meniu dezvoltator ───────────────────────────────────
    dev_options = 'Opțiuni Dezvoltator',
    debug_mode = 'Mod Debug',
    debug_mode_desc = 'Activează/dezactivează modul debug',
    copy_vec3 = 'Copiază Coordonatele Vector3',
    copy_vec3_desc = 'Copiază poziția ta curentă (vector3) în clipboard',
    copy_vec4 = 'Copiază Coordonatele Vector4',
    copy_vec4_desc = 'Copiază poziția ta curentă (vector4) în clipboard',
    copy_heading = 'Copiază Orientarea',
    copy_heading_desc = 'Copiază orientarea ta curentă în clipboard',
    cant_delete = 'Nu se poate șterge!',
    cant_delete_player_desc = 'Nu poți șterge ped-urile jucătorilor!',
    cant_delete_entity_desc = 'Nu poți șterge obiectele implicite ale hărții!',

    -- ── Listă banuri ────────────────────────────────────────
    ban_list_menu = 'Listă Banuri',
    ban_list_name = 'Nume: %s',
    ban_list_license = 'Licență:',
    ban_list_by = 'Emis de: %s',
    ban_list_reason = 'Motiv: %s',
    ban_list_length = 'Timp rămas: %s ore %s minute',
    ban_list_modify = 'Modifică Banul',
    ban_list_unban = 'Debanează Jucătorul',
    ban_list_no_data = 'Niciun Ban',
    ban_list_no_data_desc = 'Nu a fost găsit niciun ban activ!',

    -- ── Date jucător ────────────────────────────────────────
    playerdata_menu = 'Date Jucător',
    playerdata_license_esx = 'Licență: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Apasă pentru a copia licența completă',
    playerdata_igname = 'Nume: %s',
    playerdata_igname_desc = 'Numele complet al jucătorului în joc',
    playerdata_steam = 'Nume Steam: %s',
    playerdata_steam_desc = 'Numele complet Steam al jucătorului',
    playerdata_gender = 'Sex: %s',
    playerdata_gender_desc = 'Sexul jucătorului',
    playerdata_cash = 'Numerar: %s',
    playerdata_cash_desc = 'Soldul în numerar al jucătorului',
    playerdata_bank = 'Bancă: %s',
    playerdata_bank_desc = 'Soldul bancar al jucătorului',
    playerdata_blackmoney = 'Bani Negri: %s',
    playerdata_blackmoney_desc = 'Soldul de bani negri al jucătorului',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Apasă [E] pentru a șterge entitatea  \nHash: %s  \nCoordonate: vec3(%s, %s, %s)  \nOrientare: %s  \nProprietar: [%s] - %s',
    debug_textui_noname = 'Apasă [E] pentru a șterge entitatea\n  Hash: %s\n  Coordonate: vec3(%s, %s, %s)\n  Orientare: %s\n  Proprietar: NECUNOSCUT',

    textui_invisible = 'Mod Invizibil - Activ',
    textui_godmode = 'Mod Zeu - Activ',
    textui_wallhack = 'Wallhack - Activ',
    textui_noclip_activated = 'No Clip - Activ',
    textui_torque = 'Multiplicator de Cuplu - %s',

    -- ── Anunțuri ────────────────────────────────────────────
    dialog_announce = 'Anunț',
    dialog_announce_label = 'Mesaj',
    dialog_announce_select = 'Toată lumea',
    dialog_announce_everyone = 'Toată lumea',
    dialog_announce_placeholder = 'Mesaj important aici. . .',

    -- ── Debanare ────────────────────────────────────────────
    dialog_unban = 'Ești sigur?',
    dialog_unban_content = 'Chiar vrei să îl debanezi pe %s?',

    -- ── Ștergere entități ───────────────────────────────────
    dialog_objects = 'Alege o opțiune',
    dialog_clear_objects = 'Șterge TOATE obiectele',
    dialog_clear_cars = 'Șterge TOATE mașinile (fără șofer)',
    dialog_clear_peds = 'Șterge TOATE ped-urile',

    -- ── Dare de bani ────────────────────────────────────────
    dialog_givemoney = 'Dă Bani',
    givemoney_input_label = 'Sumă',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Cont',
    givemoney_select_option1 = 'Numerar',
    givemoney_select_option2 = 'Bancă',
    givemoney_select_option3 = 'Bani Negri',

    -- ── Dare de obiect ──────────────────────────────────────
    dialog_giveitem = 'Dă Obiect',
    giveitem_input_label = 'Numele Obiectului',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Cantitate',
    giveitem_amount_input_placeholder = '3',

    -- ── Creare vehicul ──────────────────────────────────────
    dialog_spawn_a_car = 'Creează Vehicul',
    dialog_car_model = 'Numele Modelului',
    dialog_car_model_holder = 'Ex: 20charger',
    dialog_car_plate = 'Număr (opțional)',
    dialog_car_plate_holder = 'Ex: W4S4B1',
    dialog_car_color_primary = 'Culoare Primară (opțional)',
    dialog_car_color_second = 'Culoare Secundară (opțional)',
    dialog_car_maxed = 'Modificări la Maxim (opțional)',

    -- ── Dare afară ──────────────────────────────────────────
    dialog_kick = 'Dă afară pe %s',
    dialog_kick_reason = 'Motiv',
    dialog_kick_placeholder = 'Cheater',
    kicked_reason_replace = 'Ai fost dat afară de pe server!',

    -- ── Ban ─────────────────────────────────────────────────
    dialog_ban = 'Banează pe %s',
    dialog_ban_reason = 'Motiv',
    dialog_ban_placeholder = 'Cheater',
    ban_reason_replace = 'Ai fost banat de pe acest server!',

    -- ── Creare zonă ─────────────────────────────────────────
    dialog_zone_create = 'Creare Zonă',
    dialog_zone_name = 'Nume',
    dialog_zone_name_desc = 'Numele zonei / blip-ului',
    dialog_zone_name_holder = 'Zonă Admin',
    dialog_zone_text = 'Text Afișat',
    dialog_zone_text_desc = 'Textul afișat jucătorilor din interiorul zonei',
    dialog_zone_text_holder = 'ZONĂ ADMIN - ACTIVĂ',
    dialog_zone_size = 'Dimensiune',
    dialog_zone_speed = 'Limită de Viteză',
    mph = 'MPH',
    kmh = 'KM/H',
    dialog_zone_blip_id = 'ID Blip',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'ID Culoare',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Blip Intermitent',
    dialog_zone_disarm = 'Dezarmează',
    dialog_zone_revive = 'Reanimare',
    dialog_zone_invincible = 'Invincibil',
    dialog_zone_edit = 'Se editează „%s"',
    dialog_zone_delete_confirm = 'Ești sigur?',
    dialog_zone_delete_confirm_desc = 'Chiar vrei să ștergi zona: %s',

    -- ── Notificări: bani ────────────────────────────────────
    notify_givemoney_success = 'Bani Acordați',
    notify_givemoney_success_desc = 'I-ai creditat lui %s suma de $%s în contul: %s',
    notify_givemoney_fail = 'Nereușit',
    notify_givemoney_fail_desc = 'Ai încercat să îi creditezi lui %s dar ceva n-a mers! Încearcă din nou.',

    -- ── Notificări: obiecte ─────────────────────────────────
    notify_giveitem_success = 'Obiect Acordat',
    notify_giveitem_success_desc = 'I-ai dat lui %s. Obiect: %s Cantitate: %s',
    notify_giveitem_fail = 'Eșuat',
    notify_giveitem_fail_desc = 'Ai încercat să îi dai lui %s dar ceva n-a mers! Încearcă din nou.',

    -- ── Notificări: dare afară / ban ────────────────────────
    notify_kicked_success = 'Dat Afară cu Succes',
    notify_kicked_success_desc = 'L-ai dat afară cu succes pe %s',
    notify_banned_success = 'Banat cu Succes',
    notify_banned_success_desc = 'L-ai banat cu succes pe %s',

    -- ── Notificări: inventar ────────────────────────────────
    notify_clearedinv = 'Inventar Golit',
    notify_clearedinv_desc = 'Ai golit cu succes inventarul lui %s',

    -- ── Notificări: ID invalid ──────────────────────────────
    notify_invalidid = 'ID Invalid',
    notify_invalidid_desc = 'ID-ul introdus este invalid, încearcă din nou.',

    -- ── Notificări: curățare ────────────────────────────────
    notify_deleted_car = 'Mașini Șterse',
    notify_deleted_car_desc = 'Ai șters cu succes toate mașinile fără șofer.',
    notify_deleted_ped = 'Ped-uri Șterse',
    notify_deleted_ped_desc = 'Ai șters cu succes toate ped-urile de pe hartă',
    notify_deleted_objects = 'Obiecte Șterse',
    notify_deleted_objects_desc = 'Ai șters cu succes toate obiectele de pe hartă',

    -- ── Notificări: vreme ───────────────────────────────────
    notify_weather = 'Vreme Modificată',
    notify_weather_desc = 'Vremea schimbată în: %s',

    -- ── Notificări: copiere coordonate ──────────────────────
    notify_copied = 'Copiat',
    notify_copied_vec3 = 'Vector3 copiat cu succes în clipboard!',
    notify_copied_vec4 = 'Vector4 copiat cu succes în clipboard!',
    notify_copied_headin = 'Orientare copiată cu succes în clipboard!',

    -- ── Notificări: uși ─────────────────────────────────────
    notify_locked_doors = 'Blocat',
    notify_locked_doors_desc = 'Ușile vehiculului au fost blocate cu succes.',
    notify_unlocked_doors = 'Deblocat',
    notify_unlocked_doors_desc = 'Ușile vehiculului au fost deblocate cu succes.',

    -- ── Notificări: zone admin ──────────────────────────────
    notify_zone_deleted = 'Zonă Ștearsă',
    notify_zone_deleted_desc = 'Ai eliminat cu succes zona: %s.',
    notify_zone_not_deleted_desc = 'A apărut o eroare la ștergerea zonei: %s.',
    notify_zone_edited = 'Zonă Modificată',
    notify_zone_edited_desc = 'Ai modificat cu succes zona: %s.',
    notify_zone_not_edited_desc = 'A apărut o eroare la modificarea zonei: %s.',
    notify_zone_action_cancelled = 'Acțiune Anulată',
    notify_zone_delete_cancel = 'Ai anulat ștergerea zonei: %s',
    notify_zone_no_weapons = 'Arme Neautorizate',
    notify_zone_no_weapons_desc = 'Nu ai permisiunea să folosești arme în această zonă.',
    notify_zones_not_found = 'Nicio Zonă',
    notify_zones_not_found_desc = 'Momentan nu există zone active de administrat.',
    notify_zones_teleport = 'Teleportat',
    notify_zones_teleport_desc = 'Te-ai teleportat cu succes în zona: %s.',

    -- ── Notificări: debanare ────────────────────────────────
    successfully_unbanned = 'Ban Revocat',
    successfully_unbanned_desc = 'L-ai debanat cu succes pe: %s.',
    unsuccessful_unban = 'Ceva n-a mers la debanarea lui: %s.',

    -- ── Conectare (deferral) ────────────────────────────────
    deferral_welcome = '[%s] Salut %s, se verifică banurile. . .',
    deferral_banned = 'Ești banat de pe acest server. Motiv: „%s" (Timp rămas: %s ore %s minute).',
    deferral_banned_perm = 'Ești banat de pe acest server. Motiv: „%s" (Timp rămas: Permanent).',

    -- ── Erori ───────────────────────────────────────────────
    notify_error = 'Eroare',
    notify_disabled_keys = 'Nu este configurat niciun script de chei pentru vehicule. Contactează dezvoltatorul serverului.',
    notify_no_appearance = 'Niciun script de haine / aspect detectat. Contactează dezvoltatorul serverului.',
    notify_no_vehicle = 'Niciun vehicul găsit!',
    notify_invalid_entry = 'Intrare invalidă!',

    -- ── Scurtătură de tastatură ─────────────────────────────
    keymapping_desc = 'Deschide Meniul de Administrare (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Activat',
    noclip_deactivated = 'NoClip Dezactivat',

    -- ── Invizibilitate ──────────────────────────────────────
    invisibility_activated = 'Mod Invizibil Activat',
    invisibility_deactivated = 'Mod Invizibil Dezactivat',

    -- ── Mod Zeu ─────────────────────────────────────────────
    godmode_activated = 'Mod Zeu Activat',
    godmode_deactivated = 'Mod Zeu Dezactivat',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Activat',
    wallhack_deactivated = 'Wallhack Dezactivat',

    -- ── Mod debug ───────────────────────────────────────────
    debug_activated = 'Mod Debug Activat',
    debug_deactivated = 'Mod Debug Dezactivat',

    -- ── Notificări: vehicule ────────────────────────────────
    vehicle_repaired = 'Vehicul Reparat',
    vehicle_repaired_desc = 'Vehiculul a fost reparat cu succes.',
    vehicle_deleted = 'Vehicul Șters',
    vehicle_deleted_desc = 'Vehiculul a fost șters cu succes.',
    vehicle_spawned = 'Vehicul Creat',
    vehicle_spawned_desc = 'Vehiculul %s a fost creat cu succes.',
    vehicle_plate_changed = 'Număr Schimbat',
    vehicle_plate_changed_desc = 'Numărul vehiculului a fost schimbat în: %s',
    vehicle_refueled = 'Vehicul Alimentat',
    vehicle_refueled_desc = 'Vehiculul a fost alimentat cu succes.',
    vehicle_keys_given = 'Chei Primite',
    vehicle_keys_given_desc = 'Ai primit cheile vehiculului cu numărul: %s',
    vehicle_color_changed = 'Culoarea Vehiculului Schimbată',
    vehicle_color_changed_desc = 'Culoarea vehiculului a fost schimbată în: %s',
    vehicle_torque_set = 'Multiplicator de Cuplu Setat',
    vehicle_torque_set_desc = 'Cuplu setat la: %sx',
    vehicle_torque_disabled = 'Multiplicator de Cuplu Dezactivat',

    -- ── Urmărire ────────────────────────────────────────────
    spectate_started = 'Se Urmărește',
    spectate_started_desc = 'Îl urmărești pe %s. Apasă X pentru a opri.',
    spectate_ended = 'Urmărire Încheiată',
    spectate_ended_desc = 'Nu mai urmărești pe nimeni.',
    spectate_error = 'Eroare de Urmărire',
    spectate_error_desc = 'Jucătorul țintă nu a fost găsit sau nu mai există.',

    -- ── Teleportare ─────────────────────────────────────────
    teleport_success = 'Teleportat',
    teleport_success_desc = 'Ai fost teleportat cu succes.',

    -- ── Reanimare / vindecare ───────────────────────────────
    player_revived = 'Jucător Reanimat',
    player_revived_desc = 'L-ai reanimat cu succes pe %s.',
    player_healed = 'Jucător Vindecat',
    player_healed_desc = 'L-ai vindecat cu succes pe %s.',
    self_revived = 'Reanimat',
    self_revived_desc = 'Te-ai reanimat singur.',
    self_healed = 'Vindecat',
    self_healed_desc = 'Te-ai vindecat singur.',

    -- ── Ped-uri ─────────────────────────────────────────────
    ped_changed = 'Ped Schimbat',
    ped_changed_desc = 'Modelul tău de ped a fost schimbat.',
    ped_restored = 'Ped Restaurat',
    ped_restored_desc = 'Modelul tău original de ped a fost restaurat.',

    skin_menu_opened = 'Meniu Haine Deschis',

    admin_menu_opened = 'Meniu Admin Deschis',
    admin_menu_closed = 'Meniu Admin Închis',

    entity_deleted = 'Entitate Ștearsă',
    entity_deleted_desc = 'Entitatea a fost ștearsă cu succes.',

    player_frozen = 'Jucător Înghețat',
    player_frozen_desc = 'Jucătorul %s a fost înghețat.',
    player_unfrozen = 'Jucător Dezghețat',
    player_unfrozen_desc = 'Jucătorul %s a fost dezghețat.',

    -- ── Număr personalizat ──────────────────────────────────
    dialog_license_plate = 'Număr Personalizat',
    dialog_license_plate_label = 'Număr',
    dialog_license_plate_placeholder = 'Număr',

    -- ── Luare de bani ───────────────────────────────────────
    player_removemoney = 'Ia Bani',
    player_removemoney_desc = 'Ia bani de la jucătorul selectat',
    dialog_removemoney = 'Ia Bani',
    removemoney_input_label = 'Sumă',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Cont',
    notify_removemoney_success = 'Bani Luați',
    notify_removemoney_success_desc = 'Ai luat $%s de la %s (cont: %s)',
    notify_removemoney_fail = 'Nereușit',
    notify_removemoney_fail_desc = 'Nu s-au putut lua bani de la %s (poate fonduri insuficiente).',

    -- ── Dimensiuni / routing buckets ────────────────────────
    self_dimension = 'Setează Dimensiunea Mea',
    self_dimension_desc = 'Mută-te într-un routing bucket (0 = lumea principală)',
    player_dimension = 'Setează Dimensiunea',
    player_dimension_desc = 'Mută acest jucător într-un routing bucket',
    player_dimension_bring = 'Adu în Dimensiunea Mea',
    player_dimension_bring_desc = 'Trage acest jucător în dimensiunea ta curentă',
    player_dimension_goto = 'Intră în Dimensiunea Jucătorului',
    player_dimension_goto_desc = 'Mută-te în dimensiunea acestui jucător',
    dialog_dimension = 'Setează Dimensiunea',
    dimension_input_label = 'Dimensiune (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Dimensiune Schimbată',
    notify_dimension_self_desc = 'Acum ești în dimensiunea %s.',
    notify_dimension_player_desc = '%s a fost mutat în dimensiunea %s.',
    notify_dimension_join_desc = 'Ai intrat în dimensiunea lui %s (%s).',
    notify_dimension_fail = 'Eroare de Dimensiune',
    notify_dimension_fail_desc = 'Dimensiunea nu a putut fi schimbată.',

    -- ── Teleportare în vehicul ──────────────────────────────
    player_tp_vehicle = 'Teleportare în Vehicul',
    player_tp_vehicle_desc = 'Intră în vehiculul acestui jucător pentru a-l ajuta să îl recupereze',
    notify_tp_vehicle_fail = 'Niciun Vehicul',
    notify_tp_vehicle_fail_desc = '%s nu este într-un vehicul.',
    notify_tp_vehicle_success = 'Teleportat',
    notify_tp_vehicle_success_desc = 'Ai fost plasat în vehiculul lui %s.',

    -- ── Recuperare vehicul ──────────────────────────────────
    recover_car = 'Recuperează / Întoarce Vehiculul',
    recover_car_desc = 'Îl pune pe roți și îl mută pe cel mai apropiat drum (mare/răsturnat)',
    vehicle_recovered = 'Vehicul Recuperat',
    vehicle_recovered_desc = 'Vehiculul a fost pus pe roți și plasat pe cel mai apropiat drum.',

    -- ── Vehicule deținute ───────────────────────────────────
    player_owned_vehicles = 'Vehicule Deținute',
    player_owned_vehicles_desc = 'Vezi, adaugă sau elimină mașinile acestui jucător',
    owned_vehicles_menu = 'Vehicule Deținute (%s)',
    owned_vehicles_add = 'Adaugă Vehicul',
    owned_vehicles_add_desc = 'Adaugă un vehicul în garajul acestui jucător',
    owned_vehicles_none = 'Niciun Vehicul',
    owned_vehicles_none_desc = 'Acest jucător nu deține niciun vehicul.',
    owned_vehicle_desc = 'Număr: %s · apasă pentru a elimina',
    dialog_add_vehicle = 'Adaugă Vehicul',
    add_vehicle_model_label = 'Numele Modelului',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Număr (opțional)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = 'Elimini %s?',
    notify_owned_added = 'Vehicul Adăugat',
    notify_owned_added_desc = 'Adăugat %s (număr %s) la %s.',
    notify_owned_removed = 'Vehicul Eliminat',
    notify_owned_removed_desc = 'Numărul %s eliminat de la %s.',
    notify_owned_fail = 'Eroare de Bază de Date',
    notify_owned_fail_desc = 'Operațiunea pe baza de date a vehiculelor a eșuat.',

    -- ── Meniu ped-uri ───────────────────────────────────────
    player_pedmenu = 'Dă Meniul de Ped-uri',
    player_pedmenu_desc = 'Deschide un meniu de selecție ped pe ecranul acestui jucător',
    pedmenu_title = 'Meniu Ped-uri',
    pedmenu_given = 'Meniu Ped-uri Trimis',
    pedmenu_given_desc = 'Meniul de ped-uri deschis pentru %s.'
}
