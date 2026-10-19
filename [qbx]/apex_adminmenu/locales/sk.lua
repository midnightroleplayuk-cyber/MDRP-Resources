-- ============================================================
-- SLOVENČINA (sk)
-- ------------------------------------------------------------
-- Vrstva nad configs/strings.lua. Každý kľúč, ktorý tu chýba,
-- si ponechá anglický text, takže čiastočný preklad je bezpečný.
--
-- Zástupné znaky %s musia zostať zachované a v ROVNAKOM poradí
-- ako v origináli — vypĺňa ich :format() v kóde. %% vypíše
-- doslovný znak percenta.
--
-- Zapnutie:  Config.Locale = 'sk'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['sk'] = {
    -- ── Hlavné menu ─────────────────────────────────────────
    main_title = 'Admin Menu',
    self_options = 'Vlastné Možnosti',
    self_options_desc = 'Možnosti týkajúce sa teba',
    player_options_title = 'Možnosti Hráča',
    player_options_desc = 'Možnosti týkajúce sa ostatných hráčov',
    vehicle_options = 'Možnosti Vozidla',
    vehicle_options_desc = 'Možnosti týkajúce sa vozidiel',
    server_options = 'Možnosti Servera',
    server_options_desc = 'Možnosti týkajúce sa servera',
    admin_zone_options = 'Admin Zóny',
    admin_zone_options_desc = 'Spravovať, pridávať a mazať admin zóny',
    developer_options = 'Možnosti Vývojára',
    developer_options_desc = '',

    -- ── Vlastné možnosti ────────────────────────────────────
    self_options_menu = 'Vlastné Možnosti',
    self_health = 'Život (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Oživiť',
    self_revive_desc = 'Oživiť sám seba',
    self_heal = 'Vyliečiť',
    self_heal_desc = 'Vyliečiť sám seba',
    self_skinmenu = 'Menu Oblečenia',
    self_set_ped = 'Zmeniť Peda',
    self_skinmenu_desc = 'Otvoriť menu oblečenia lokálne',
    self_invisible = 'Neviditeľnosť',
    self_godmode = 'God Mode',
    self_wallhack = 'Wallhack',

    -- ── Možnosti hráča ──────────────────────────────────────
    player_options_menu = 'Hráči Online %s/%s',
    player_options = 'Hráč: %s',
    player_health = 'Život Hráča (%s%%)',
    player_freeze = 'Zmraziť',
    player_freeze_desc = 'Zapnúť/vypnúť',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Zapnúť/vypnúť',
    player_spectate = 'Sledovať',
    player_spectate_desc = 'Sledovať počínanie tohto hráča',
    player_playerdata = 'Dáta Hráča',
    player_playerdata_desc = 'Zobraziť dáta hráča',
    player_revive = 'Oživiť',
    player_revive_desc = 'Oživiť hráča',
    player_heal = 'Vyliečiť',
    player_heal_desc = 'Vyliečiť hráča',
    player_skinmenu = 'Menu Oblečenia',
    player_skinmenu_desc = 'Otvoriť hráčovi menu oblečenia',
    player_money = 'Dať Peniaze',
    player_money_desc = 'Dať peniaze vybranému hráčovi',
    player_item = 'Dať Predmet',
    player_item_desc = 'Dať predmet vybranému hráčovi',
    player_openinv = 'Otvoriť Inventár',
    player_openinv_desc = 'Otvoriť inventár hráča',
    player_clearinv = 'Vyprázdniť Inventár',
    player_clearinv_desc = 'Vyprázdniť inventár hráča',
    player_teleport_to = 'Teleportovať k Hráčovi',
    player_teleport_to_desc = 'Teleportovať sa k hráčovi',
    player_bring = 'Pritiahnuť',
    player_bring_desc = 'Pritiahnuť hráča na tvoju pozíciu',
    player_kick = 'Vyhodiť',
    player_kick_desc = 'Vyhodiť hráča zo servera',
    player_ban = 'Zabanovať Hráča',

    -- ── Menu vozidla ────────────────────────────────────────
    vehicle_menu = 'Menu Vozidla',
    spawn_car = 'Vytvoriť Vozidlo',
    spawn_car_desc = 'Vytvoriť vozidlo',
    repair_car = 'Opraviť Vozidlo',
    repair_car_desc = 'Opraviť súčasné alebo najbližšie vozidlo',
    delete_car = 'Zmazať Vozidlo',
    delete_car_desc = 'Zmazať súčasné alebo najbližšie vozidlo',
    number_plate = 'Zmeniť ŠPZ',
    number_plate_desc = 'Zmeniť text súčasnej ŠPZ',
    refuel = 'Natankovať Vozidlo',
    refuel_desc = 'Natankovať súčasné alebo najbližšie vozidlo',
    give_keys = 'Dať Kľúče',
    give_keys_desc = 'Dať sebe kľúče od súčasného vozidla',
    doors = 'Zamknúť/Odomknúť Dvere',
    doors_desc = 'Prepne zámky najbližšieho vozidla',
    boost_car = 'Násobič Krútiaceho Momentu',
    boost_car_desc = 'Zmeniť krútiaci moment súčasného vozidla',
    color_change = 'Zmeniť Farbu Vozidla',
    color_change_desc = 'Zmeniť farbu súčasného alebo najbližšieho vozidla',

    -- ── Správa servera ──────────────────────────────────────
    server_management = 'Správa Servera',
    server_announcement = 'Oznam Servera',
    server_announcement_desc = 'Odoslať globálny oznam celému serveru',
    ban_list = 'Zoznam Banov',
    ban_list_desc = 'Zobraziť všetky aktívne bany',
    objects_list = 'Zmazať Entity',
    objects_list_desc = 'Zmazať vozidlá a pedov',
    objects_list_label = 'Možnosti',
    weather_menu = 'Správa Počasia',
    weather_menu_desc = 'Spravovať počasie',

    -- ── Admin zóny ──────────────────────────────────────────
    zones_create = 'Vytvoriť Zónu',
    zones_create_desc = 'Vytvoriť novú admin zónu',
    zones_manage = 'Spravovať Zóny',
    zones_manage_desc = 'Upraviť alebo zmazať aktívne zóny',
    zone_edit_current = 'Upraviť Súčasnú Zónu',
    zone_edit_current_desc = 'Spravovať zónu, v ktorej sa nachádzaš',
    zone_delete_current = 'Zmazať Súčasnú Zónu',
    zone_delete_current_desc = 'Zmazať zónu, v ktorej sa nachádzaš',
    zone_manage_menu = 'Úprava Zóny (%s)',
    zone_edit = 'Upraviť Zónu',
    zone_edit_desc = 'Upraviť zónu: %s',
    zone_delete = 'Zmazať Zónu',
    zone_delete_desc = 'Zmazať zónu: %s',
    zone_teleport = 'Teleportovať do Zóny',
    zone_teleport_desc = 'Ísť do zóny: %s',

    -- ── Menu vývojára ───────────────────────────────────────
    dev_options = 'Možnosti Vývojára',
    debug_mode = 'Debug Režim',
    debug_mode_desc = 'Zapnúť/vypnúť debug režim',
    copy_vec3 = 'Kopírovať Súradnice Vector3',
    copy_vec3_desc = 'Skopíruje tvoju súčasnú pozíciu (vector3) do schránky',
    copy_vec4 = 'Kopírovať Súradnice Vector4',
    copy_vec4_desc = 'Skopíruje tvoju súčasnú pozíciu (vector4) do schránky',
    copy_heading = 'Kopírovať Natočenie',
    copy_heading_desc = 'Skopíruje tvoje súčasné natočenie do schránky',
    cant_delete = 'Nedá sa zmazať!',
    cant_delete_player_desc = 'Nemôžeš mazať pedov hráčov!',
    cant_delete_entity_desc = 'Nemôžeš mazať predvolené objekty mapy!',

    -- ── Zoznam banov ────────────────────────────────────────
    ban_list_menu = 'Zoznam Banov',
    ban_list_name = 'Meno: %s',
    ban_list_license = 'Licencia:',
    ban_list_by = 'Udelil: %s',
    ban_list_reason = 'Dôvod: %s',
    ban_list_length = 'Zostáva: %s hodín %s minút',
    ban_list_modify = 'Upraviť Ban',
    ban_list_unban = 'Odbanovať Hráča',
    ban_list_no_data = 'Žiadne Bany',
    ban_list_no_data_desc = 'Neboli nájdené žiadne aktívne bany!',

    -- ── Dáta hráča ──────────────────────────────────────────
    playerdata_menu = 'Dáta Hráča',
    playerdata_license_esx = 'Licencia: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Klikni pre skopírovanie celej licencie',
    playerdata_igname = 'Meno: %s',
    playerdata_igname_desc = 'Celé meno hráča v hre',
    playerdata_steam = 'Steam Meno: %s',
    playerdata_steam_desc = 'Celé Steam meno hráča',
    playerdata_gender = 'Pohlavie: %s',
    playerdata_gender_desc = 'Pohlavie hráča',
    playerdata_cash = 'Hotovosť: %s',
    playerdata_cash_desc = 'Zostatok hotovosti hráča',
    playerdata_bank = 'Banka: %s',
    playerdata_bank_desc = 'Bankový zostatok hráča',
    playerdata_blackmoney = 'Špinavé Peniaze: %s',
    playerdata_blackmoney_desc = 'Zostatok špinavých peňazí hráča',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Stlač [E] pre zmazanie entity  \nHash: %s  \nSúradnice: vec3(%s, %s, %s)  \nNatočenie: %s  \nVlastník: [%s] - %s',
    debug_textui_noname = 'Stlač [E] pre zmazanie entity\n  Hash: %s\n  Súradnice: vec3(%s, %s, %s)\n  Natočenie: %s\n  Vlastník: NEZNÁMY',

    textui_invisible = 'Režim Neviditeľnosti - Aktívny',
    textui_godmode = 'God Mode - Aktívny',
    textui_wallhack = 'Wallhack - Aktívny',
    textui_noclip_activated = 'No Clip - Aktívny',
    textui_torque = 'Násobič Krútiaceho Momentu - %s',

    -- ── Oznamy ──────────────────────────────────────────────
    dialog_announce = 'Oznam',
    dialog_announce_label = 'Správa',
    dialog_announce_select = 'Všetci',
    dialog_announce_everyone = 'Všetci',
    dialog_announce_placeholder = 'Dôležitá správa sem. . .',

    -- ── Odbanovanie ─────────────────────────────────────────
    dialog_unban = 'Si si istý?',
    dialog_unban_content = 'Naozaj chceš odbanovať %s?',

    -- ── Mazanie entít ───────────────────────────────────────
    dialog_objects = 'Vyber možnosť',
    dialog_clear_objects = 'Zmazať VŠETKY objekty',
    dialog_clear_cars = 'Zmazať VŠETKY autá (bez vodiča)',
    dialog_clear_peds = 'Zmazať VŠETKÝCH pedov',

    -- ── Dávanie peňazí ──────────────────────────────────────
    dialog_givemoney = 'Dať Peniaze',
    givemoney_input_label = 'Suma',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Účet',
    givemoney_select_option1 = 'Hotovosť',
    givemoney_select_option2 = 'Banka',
    givemoney_select_option3 = 'Špinavé Peniaze',

    -- ── Dávanie predmetu ────────────────────────────────────
    dialog_giveitem = 'Dať Predmet',
    giveitem_input_label = 'Názov Predmetu',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Množstvo',
    giveitem_amount_input_placeholder = '3',

    -- ── Vytvorenie vozidla ──────────────────────────────────
    dialog_spawn_a_car = 'Vytvoriť Vozidlo',
    dialog_car_model = 'Názov Modelu',
    dialog_car_model_holder = 'Napr: 20charger',
    dialog_car_plate = 'ŠPZ (voliteľné)',
    dialog_car_plate_holder = 'Napr: W4S4B1',
    dialog_car_color_primary = 'Primárna Farba (voliteľné)',
    dialog_car_color_second = 'Sekundárna Farba (voliteľné)',
    dialog_car_maxed = 'Maximálne Úpravy (voliteľné)',

    -- ── Vyhodenie ───────────────────────────────────────────
    dialog_kick = 'Vyhodiť %s',
    dialog_kick_reason = 'Dôvod',
    dialog_kick_placeholder = 'Cheater',
    kicked_reason_replace = 'Bol si vyhodený zo servera!',

    -- ── Ban ─────────────────────────────────────────────────
    dialog_ban = 'Zabanovať %s',
    dialog_ban_reason = 'Dôvod',
    dialog_ban_placeholder = 'Cheater',
    ban_reason_replace = 'Bol si zabanovaný na tomto serveri!',

    -- ── Vytvorenie zóny ─────────────────────────────────────
    dialog_zone_create = 'Vytvorenie Zóny',
    dialog_zone_name = 'Názov',
    dialog_zone_name_desc = 'Názov zóny / blipu',
    dialog_zone_name_holder = 'Admin Zóna',
    dialog_zone_text = 'Zobrazený Text',
    dialog_zone_text_desc = 'Text zobrazený hráčom vnútri zóny',
    dialog_zone_text_holder = 'ADMIN ZÓNA - AKTÍVNA',
    dialog_zone_size = 'Veľkosť',
    dialog_zone_speed = 'Rýchlostný Limit',
    mph = 'MPH',
    kmh = 'KM/H',
    dialog_zone_blip_id = 'ID Blipu',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'ID Farby',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Blikajúci Blip',
    dialog_zone_disarm = 'Odzbrojiť',
    dialog_zone_revive = 'Oživiť',
    dialog_zone_invincible = 'Nesmrteľnosť',
    dialog_zone_edit = 'Úprava „%s"',
    dialog_zone_delete_confirm = 'Si si istý?',
    dialog_zone_delete_confirm_desc = 'Naozaj chceš zmazať zónu: %s',

    -- ── Upozornenia: peniaze ────────────────────────────────
    notify_givemoney_success = 'Peniaze Pripísané',
    notify_givemoney_success_desc = 'Pripísal si hráčovi %s $%s na účet: %s',
    notify_givemoney_fail = 'Neúspech',
    notify_givemoney_fail_desc = 'Skúsil si pripísať %s, ale niečo sa pokazilo! Skús to znova.',

    -- ── Upozornenia: predmety ───────────────────────────────
    notify_giveitem_success = 'Predmet Odovzdaný',
    notify_giveitem_success_desc = 'Odovzdal si hráčovi %s. Predmet: %s Množstvo: %s',
    notify_giveitem_fail = 'Zlyhalo',
    notify_giveitem_fail_desc = 'Skúsil si odovzdať %s, ale niečo sa pokazilo! Skús to znova.',

    -- ── Upozornenia: vyhodenie / ban ────────────────────────
    notify_kicked_success = 'Vyhodenie Úspešné',
    notify_kicked_success_desc = 'Úspešne si vyhodil %s',
    notify_banned_success = 'Ban Úspešný',
    notify_banned_success_desc = 'Úspešne si zabanoval %s',

    -- ── Upozornenia: inventár ───────────────────────────────
    notify_clearedinv = 'Inventár Vyprázdnený',
    notify_clearedinv_desc = 'Úspešne si vyprázdnil inventár hráča %s',

    -- ── Upozornenia: neplatné ID ────────────────────────────
    notify_invalidid = 'Neplatné ID',
    notify_invalidid_desc = 'Zadané ID je neplatné, skús to prosím znova.',

    -- ── Upozornenia: upratovanie ────────────────────────────
    notify_deleted_car = 'Autá Zmazané',
    notify_deleted_car_desc = 'Úspešne si zmazal všetky autá bez vodiča.',
    notify_deleted_ped = 'Pedovia Zmazaní',
    notify_deleted_ped_desc = 'Úspešne si zmazal všetkých pedov na mape',
    notify_deleted_objects = 'Objekty Zmazané',
    notify_deleted_objects_desc = 'Úspešne si zmazal všetky objekty na mape',

    -- ── Upozornenia: počasie ────────────────────────────────
    notify_weather = 'Počasie Zmenené',
    notify_weather_desc = 'Počasie zmenené na: %s',

    -- ── Upozornenia: kopírovanie súradníc ───────────────────
    notify_copied = 'Skopírované',
    notify_copied_vec3 = 'Vector3 úspešne skopírovaný do schránky!',
    notify_copied_vec4 = 'Vector4 úspešne skopírovaný do schránky!',
    notify_copied_headin = 'Natočenie úspešne skopírované do schránky!',

    -- ── Upozornenia: dvere ──────────────────────────────────
    notify_locked_doors = 'Zamknuté',
    notify_locked_doors_desc = 'Dvere vozidla úspešne zamknuté.',
    notify_unlocked_doors = 'Odomknuté',
    notify_unlocked_doors_desc = 'Dvere vozidla úspešne odomknuté.',

    -- ── Upozornenia: admin zóny ─────────────────────────────
    notify_zone_deleted = 'Zóna Zmazaná',
    notify_zone_deleted_desc = 'Úspešne si odstránil zónu: %s.',
    notify_zone_not_deleted_desc = 'Pri mazaní zóny nastala chyba: %s.',
    notify_zone_edited = 'Zóna Upravená',
    notify_zone_edited_desc = 'Úspešne si upravil zónu: %s.',
    notify_zone_not_edited_desc = 'Pri úprave zóny nastala chyba: %s.',
    notify_zone_action_cancelled = 'Akcia Zrušená',
    notify_zone_delete_cancel = 'Zrušil si mazanie zóny: %s',
    notify_zone_no_weapons = 'Zbrane Zakázané',
    notify_zone_no_weapons_desc = 'Nemáš povolené používať zbrane vnútri tejto zóny.',
    notify_zones_not_found = 'Žiadne Zóny',
    notify_zones_not_found_desc = 'Momentálne nie sú žiadne aktívne zóny na správu.',
    notify_zones_teleport = 'Teleportovaný',
    notify_zones_teleport_desc = 'Úspešne si sa teleportoval do zóny: %s.',

    -- ── Upozornenia: odbanovanie ────────────────────────────
    successfully_unbanned = 'Ban Zrušený',
    successfully_unbanned_desc = 'Úspešne si odbanoval: %s.',
    unsuccessful_unban = 'Niečo sa pokazilo pri odbanovaní: %s.',

    -- ── Pripájanie (deferraly) ──────────────────────────────
    deferral_welcome = '[%s] Ahoj %s, kontrolujem bany. . .',
    deferral_banned = 'Si zabanovaný na tomto serveri. Dôvod: „%s" (Zostáva: %s hodín %s minút).',
    deferral_banned_perm = 'Si zabanovaný na tomto serveri. Dôvod: „%s" (Zostáva: Trvale).',

    -- ── Chyby ───────────────────────────────────────────────
    notify_error = 'Chyba',
    notify_disabled_keys = 'Nie je nastavený žiadny skript pre kľúče od vozidiel. Kontaktuj vývojára servera.',
    notify_no_appearance = 'Nebol detekovaný žiadny skript oblečenia / vzhľadu. Kontaktuj vývojára servera.',
    notify_no_vehicle = 'Nebolo nájdené žiadne vozidlo!',
    notify_invalid_entry = 'Neplatný vstup!',

    -- ── Klávesová skratka ───────────────────────────────────
    keymapping_desc = 'Otvoriť Admin Menu (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Zapnutý',
    noclip_deactivated = 'NoClip Vypnutý',

    -- ── Neviditeľnosť ───────────────────────────────────────
    invisibility_activated = 'Režim Neviditeľnosti Zapnutý',
    invisibility_deactivated = 'Režim Neviditeľnosti Vypnutý',

    -- ── God Mode ────────────────────────────────────────────
    godmode_activated = 'God Mode Zapnutý',
    godmode_deactivated = 'God Mode Vypnutý',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Zapnutý',
    wallhack_deactivated = 'Wallhack Vypnutý',

    -- ── Debug režim ─────────────────────────────────────────
    debug_activated = 'Debug Režim Zapnutý',
    debug_deactivated = 'Debug Režim Vypnutý',

    -- ── Upozornenia: vozidlá ────────────────────────────────
    vehicle_repaired = 'Vozidlo Opravené',
    vehicle_repaired_desc = 'Vozidlo bolo úspešne opravené.',
    vehicle_deleted = 'Vozidlo Zmazané',
    vehicle_deleted_desc = 'Vozidlo bolo úspešne zmazané.',
    vehicle_spawned = 'Vozidlo Vytvorené',
    vehicle_spawned_desc = 'Vozidlo %s bolo úspešne vytvorené.',
    vehicle_plate_changed = 'ŠPZ Zmenená',
    vehicle_plate_changed_desc = 'ŠPZ vozidla zmenená na: %s',
    vehicle_refueled = 'Vozidlo Natankované',
    vehicle_refueled_desc = 'Vozidlo bolo úspešne natankované.',
    vehicle_keys_given = 'Kľúče Prijaté',
    vehicle_keys_given_desc = 'Dostal si kľúče od vozidla so ŠPZ: %s',
    vehicle_color_changed = 'Farba Vozidla Zmenená',
    vehicle_color_changed_desc = 'Farba vozidla zmenená na: %s',
    vehicle_torque_set = 'Násobič Momentu Nastavený',
    vehicle_torque_set_desc = 'Krútiaci moment nastavený na: %sx',
    vehicle_torque_disabled = 'Násobič Momentu Vypnutý',

    -- ── Sledovanie ──────────────────────────────────────────
    spectate_started = 'Sledovanie',
    spectate_started_desc = 'Sleduješ %s. Stlač X pre ukončenie.',
    spectate_ended = 'Sledovanie Ukončené',
    spectate_ended_desc = 'Už nikoho nesleduješ.',
    spectate_error = 'Chyba Sledovania',
    spectate_error_desc = 'Cieľový hráč nebol nájdený alebo už neexistuje.',

    -- ── Teleportácia ────────────────────────────────────────
    teleport_success = 'Teleportovaný',
    teleport_success_desc = 'Bol si úspešne teleportovaný.',

    -- ── Oživenie / liečenie ─────────────────────────────────
    player_revived = 'Hráč Oživený',
    player_revived_desc = 'Úspešne si oživil %s.',
    player_healed = 'Hráč Vyliečený',
    player_healed_desc = 'Úspešne si vyliečil %s.',
    self_revived = 'Oživený',
    self_revived_desc = 'Oživil si sám seba.',
    self_healed = 'Vyliečený',
    self_healed_desc = 'Vyliečil si sám seba.',

    -- ── Pedovia ─────────────────────────────────────────────
    ped_changed = 'Ped Zmenený',
    ped_changed_desc = 'Tvoj model peda bol zmenený.',
    ped_restored = 'Ped Obnovený',
    ped_restored_desc = 'Tvoj pôvodný model peda bol obnovený.',

    skin_menu_opened = 'Menu Oblečenia Otvorené',

    admin_menu_opened = 'Admin Menu Otvorené',
    admin_menu_closed = 'Admin Menu Zatvorené',

    entity_deleted = 'Entita Zmazaná',
    entity_deleted_desc = 'Entita bola úspešne zmazaná.',

    player_frozen = 'Hráč Zmrazený',
    player_frozen_desc = 'Hráč %s bol zmrazený.',
    player_unfrozen = 'Hráč Rozmrazený',
    player_unfrozen_desc = 'Hráč %s bol rozmrazený.',

    -- ── Vlastná ŠPZ ─────────────────────────────────────────
    dialog_license_plate = 'Vlastná ŠPZ',
    dialog_license_plate_label = 'ŠPZ',
    dialog_license_plate_placeholder = 'ŠPZ',

    -- ── Odobranie peňazí ────────────────────────────────────
    player_removemoney = 'Odobrať Peniaze',
    player_removemoney_desc = 'Odobrať peniaze vybranému hráčovi',
    dialog_removemoney = 'Odobrať Peniaze',
    removemoney_input_label = 'Suma',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Účet',
    notify_removemoney_success = 'Peniaze Odobrané',
    notify_removemoney_success_desc = 'Odobral si $%s hráčovi %s (účet: %s)',
    notify_removemoney_fail = 'Neúspech',
    notify_removemoney_fail_desc = 'Nepodarilo sa odobrať peniaze hráčovi %s (možno nedostatok prostriedkov).',

    -- ── Dimenzie / routing buckety ──────────────────────────
    self_dimension = 'Nastaviť Moju Dimenziu',
    self_dimension_desc = 'Presunúť sa do routing bucketu (0 = hlavný svet)',
    player_dimension = 'Nastaviť Dimenziu',
    player_dimension_desc = 'Presunúť tohto hráča do routing bucketu',
    player_dimension_bring = 'Pritiahnuť do Mojej Dimenzie',
    player_dimension_bring_desc = 'Pritiahnuť tohto hráča do tvojej súčasnej dimenzie',
    player_dimension_goto = 'Pripojiť sa k Dimenzii Hráča',
    player_dimension_goto_desc = 'Presunúť sa do dimenzie tohto hráča',
    dialog_dimension = 'Nastaviť Dimenziu',
    dimension_input_label = 'Dimenzia (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Dimenzia Zmenená',
    notify_dimension_self_desc = 'Teraz si v dimenzii %s.',
    notify_dimension_player_desc = '%s bol presunutý do dimenzie %s.',
    notify_dimension_join_desc = 'Pripojil si sa k dimenzii hráča %s (%s).',
    notify_dimension_fail = 'Chyba Dimenzie',
    notify_dimension_fail_desc = 'Nepodarilo sa zmeniť dimenziu.',

    -- ── Teleportácia do vozidla ─────────────────────────────
    player_tp_vehicle = 'Teleportovať do Vozidla',
    player_tp_vehicle_desc = 'Nasadnúť do vozidla tohto hráča a pomôcť s jeho záchranou',
    notify_tp_vehicle_fail = 'Žiadne Vozidlo',
    notify_tp_vehicle_fail_desc = '%s nie je vo vozidle.',
    notify_tp_vehicle_success = 'Teleportovaný',
    notify_tp_vehicle_success_desc = 'Bol si presunutý do vozidla hráča %s.',

    -- ── Záchrana vozidla ────────────────────────────────────
    recover_car = 'Zachrániť / Otočiť Vozidlo',
    recover_car_desc = 'Postaviť na kolesá a presunúť na najbližšiu cestu (more/prevrátené)',
    vehicle_recovered = 'Vozidlo Zachránené',
    vehicle_recovered_desc = 'Vozidlo bolo postavené na kolesá a umiestnené na najbližšiu cestu.',

    -- ── Vlastnené vozidlá ───────────────────────────────────
    player_owned_vehicles = 'Vlastnené Vozidlá',
    player_owned_vehicles_desc = 'Zobraziť, pridať alebo odobrať autá tohto hráča',
    owned_vehicles_menu = 'Vlastnené Vozidlá (%s)',
    owned_vehicles_add = 'Pridať Vozidlo',
    owned_vehicles_add_desc = 'Pridať vozidlo do garáže tohto hráča',
    owned_vehicles_none = 'Žiadne Vozidlá',
    owned_vehicles_none_desc = 'Tento hráč nevlastní žiadne vozidlo.',
    owned_vehicle_desc = 'ŠPZ: %s · klikni pre odobranie',
    dialog_add_vehicle = 'Pridať Vozidlo',
    add_vehicle_model_label = 'Názov Modelu',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'ŠPZ (voliteľné)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = 'Odobrať %s?',
    notify_owned_added = 'Vozidlo Pridané',
    notify_owned_added_desc = 'Pridané %s (ŠPZ %s) hráčovi %s.',
    notify_owned_removed = 'Vozidlo Odobrané',
    notify_owned_removed_desc = 'Odobraná ŠPZ %s hráčovi %s.',
    notify_owned_fail = 'Chyba Databázy',
    notify_owned_fail_desc = 'Operácia s databázou vozidiel zlyhala.',

    -- ── Menu pedov ──────────────────────────────────────────
    player_pedmenu = 'Dať Menu Pedov',
    player_pedmenu_desc = 'Otvoriť menu výberu peda na obrazovke tohto hráča',
    pedmenu_title = 'Menu Pedov',
    pedmenu_given = 'Menu Pedov Odoslané',
    pedmenu_given_desc = 'Menu pedov otvorené pre %s.'
}
