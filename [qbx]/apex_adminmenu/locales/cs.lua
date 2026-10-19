-- ============================================================
-- ČEŠTINA (cs)
-- ------------------------------------------------------------
-- Vrstva nad configs/strings.lua. Každý klíč, který zde chybí,
-- si ponechá anglický text, takže částečný překlad je bezpečný.
--
-- Zástupné znaky %s musí zůstat zachovány a ve STEJNÉM pořadí
-- jako v originále — vyplňuje je :format() v kódu. %% vypíše
-- doslovný znak procenta.
--
-- Zapnutí:  Config.Locale = 'cs'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['cs'] = {
    -- ── Hlavní menu ─────────────────────────────────────────
    main_title = 'Admin Menu',
    self_options = 'Vlastní Možnosti',
    self_options_desc = 'Možnosti týkající se tebe',
    player_options_title = 'Možnosti Hráče',
    player_options_desc = 'Možnosti týkající se ostatních hráčů',
    vehicle_options = 'Možnosti Vozidla',
    vehicle_options_desc = 'Možnosti týkající se vozidel',
    server_options = 'Možnosti Serveru',
    server_options_desc = 'Možnosti týkající se serveru',
    admin_zone_options = 'Admin Zóny',
    admin_zone_options_desc = 'Spravovat, přidávat a mazat admin zóny',
    developer_options = 'Možnosti Vývojáře',
    developer_options_desc = '',

    -- ── Vlastní možnosti ────────────────────────────────────
    self_options_menu = 'Vlastní Možnosti',
    self_health = 'Život (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Oživit',
    self_revive_desc = 'Oživit sám sebe',
    self_heal = 'Vyléčit',
    self_heal_desc = 'Vyléčit sám sebe',
    self_skinmenu = 'Menu Oblečení',
    self_set_ped = 'Změnit Peda',
    self_skinmenu_desc = 'Otevřít menu oblečení lokálně',
    self_invisible = 'Neviditelnost',
    self_godmode = 'God Mode',
    self_wallhack = 'Wallhack',

    -- ── Možnosti hráče ──────────────────────────────────────
    player_options_menu = 'Hráči Online %s/%s',
    player_options = 'Hráč: %s',
    player_health = 'Život Hráče (%s%%)',
    player_freeze = 'Zmrazit',
    player_freeze_desc = 'Zapnout/vypnout',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Zapnout/vypnout',
    player_spectate = 'Sledovat',
    player_spectate_desc = 'Sledovat počínání tohoto hráče',
    player_playerdata = 'Data Hráče',
    player_playerdata_desc = 'Zobrazit data hráče',
    player_revive = 'Oživit',
    player_revive_desc = 'Oživit hráče',
    player_heal = 'Vyléčit',
    player_heal_desc = 'Vyléčit hráče',
    player_skinmenu = 'Menu Oblečení',
    player_skinmenu_desc = 'Otevřít hráči menu oblečení',
    player_money = 'Dát Peníze',
    player_money_desc = 'Dát peníze vybranému hráči',
    player_item = 'Dát Předmět',
    player_item_desc = 'Dát předmět vybranému hráči',
    player_openinv = 'Otevřít Inventář',
    player_openinv_desc = 'Otevřít inventář hráče',
    player_clearinv = 'Vyprázdnit Inventář',
    player_clearinv_desc = 'Vyprázdnit inventář hráče',
    player_teleport_to = 'Teleportovat k Hráči',
    player_teleport_to_desc = 'Teleportovat se k hráči',
    player_bring = 'Přitáhnout',
    player_bring_desc = 'Přitáhnout hráče na tvou pozici',
    player_kick = 'Vyhodit',
    player_kick_desc = 'Vyhodit hráče ze serveru',
    player_ban = 'Zabanovat Hráče',

    -- ── Menu vozidla ────────────────────────────────────────
    vehicle_menu = 'Menu Vozidla',
    spawn_car = 'Vytvořit Vozidlo',
    spawn_car_desc = 'Vytvořit vozidlo',
    repair_car = 'Opravit Vozidlo',
    repair_car_desc = 'Opravit současné nebo nejbližší vozidlo',
    delete_car = 'Smazat Vozidlo',
    delete_car_desc = 'Smazat současné nebo nejbližší vozidlo',
    number_plate = 'Změnit SPZ',
    number_plate_desc = 'Změnit text současné SPZ',
    refuel = 'Natankovat Vozidlo',
    refuel_desc = 'Natankovat současné nebo nejbližší vozidlo',
    give_keys = 'Dát Klíče',
    give_keys_desc = 'Dát sobě klíče od současného vozidla',
    doors = 'Zamknout/Odemknout Dveře',
    doors_desc = 'Přepne zámky nejbližšího vozidla',
    boost_car = 'Násobič Točivého Momentu',
    boost_car_desc = 'Změnit točivý moment současného vozidla',
    color_change = 'Změnit Barvu Vozidla',
    color_change_desc = 'Změnit barvu současného nebo nejbližšího vozidla',

    -- ── Správa serveru ──────────────────────────────────────
    server_management = 'Správa Serveru',
    server_announcement = 'Oznámení Serveru',
    server_announcement_desc = 'Odeslat globální oznámení celému serveru',
    ban_list = 'Seznam Banů',
    ban_list_desc = 'Zobrazit všechny aktivní bany',
    objects_list = 'Smazat Entity',
    objects_list_desc = 'Smazat vozidla a pedy',
    objects_list_label = 'Možnosti',
    weather_menu = 'Správa Počasí',
    weather_menu_desc = 'Spravovat počasí',

    -- ── Admin zóny ──────────────────────────────────────────
    zones_create = 'Vytvořit Zónu',
    zones_create_desc = 'Vytvořit novou admin zónu',
    zones_manage = 'Spravovat Zóny',
    zones_manage_desc = 'Upravit nebo smazat aktivní zóny',
    zone_edit_current = 'Upravit Současnou Zónu',
    zone_edit_current_desc = 'Spravovat zónu, ve které se nacházíš',
    zone_delete_current = 'Smazat Současnou Zónu',
    zone_delete_current_desc = 'Smazat zónu, ve které se nacházíš',
    zone_manage_menu = 'Úprava Zóny (%s)',
    zone_edit = 'Upravit Zónu',
    zone_edit_desc = 'Upravit zónu: %s',
    zone_delete = 'Smazat Zónu',
    zone_delete_desc = 'Smazat zónu: %s',
    zone_teleport = 'Teleportovat do Zóny',
    zone_teleport_desc = 'Jít do zóny: %s',

    -- ── Menu vývojáře ───────────────────────────────────────
    dev_options = 'Možnosti Vývojáře',
    debug_mode = 'Debug Režim',
    debug_mode_desc = 'Zapnout/vypnout debug režim',
    copy_vec3 = 'Kopírovat Souřadnice Vector3',
    copy_vec3_desc = 'Zkopíruje tvou současnou pozici (vector3) do schránky',
    copy_vec4 = 'Kopírovat Souřadnice Vector4',
    copy_vec4_desc = 'Zkopíruje tvou současnou pozici (vector4) do schránky',
    copy_heading = 'Kopírovat Natočení',
    copy_heading_desc = 'Zkopíruje tvé současné natočení do schránky',
    cant_delete = 'Nelze smazat!',
    cant_delete_player_desc = 'Nemůžeš mazat pedy hráčů!',
    cant_delete_entity_desc = 'Nemůžeš mazat výchozí objekty mapy!',

    -- ── Seznam banů ─────────────────────────────────────────
    ban_list_menu = 'Seznam Banů',
    ban_list_name = 'Jméno: %s',
    ban_list_license = 'Licence:',
    ban_list_by = 'Udělil: %s',
    ban_list_reason = 'Důvod: %s',
    ban_list_length = 'Zbývá: %s hodin %s minut',
    ban_list_modify = 'Upravit Ban',
    ban_list_unban = 'Odbanovat Hráče',
    ban_list_no_data = 'Žádné Bany',
    ban_list_no_data_desc = 'Nebyly nalezeny žádné aktivní bany!',

    -- ── Data hráče ──────────────────────────────────────────
    playerdata_menu = 'Data Hráče',
    playerdata_license_esx = 'Licence: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Klikni pro zkopírování celé licence',
    playerdata_igname = 'Jméno: %s',
    playerdata_igname_desc = 'Celé jméno hráče ve hře',
    playerdata_steam = 'Steam Jméno: %s',
    playerdata_steam_desc = 'Celé Steam jméno hráče',
    playerdata_gender = 'Pohlaví: %s',
    playerdata_gender_desc = 'Pohlaví hráče',
    playerdata_cash = 'Hotovost: %s',
    playerdata_cash_desc = 'Zůstatek hotovosti hráče',
    playerdata_bank = 'Banka: %s',
    playerdata_bank_desc = 'Bankovní zůstatek hráče',
    playerdata_blackmoney = 'Špinavé Peníze: %s',
    playerdata_blackmoney_desc = 'Zůstatek špinavých peněz hráče',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Stiskni [E] pro smazání entity  \nHash: %s  \nSouřadnice: vec3(%s, %s, %s)  \nNatočení: %s  \nVlastník: [%s] - %s',
    debug_textui_noname = 'Stiskni [E] pro smazání entity\n  Hash: %s\n  Souřadnice: vec3(%s, %s, %s)\n  Natočení: %s\n  Vlastník: NEZNÁMÝ',

    textui_invisible = 'Režim Neviditelnosti - Aktivní',
    textui_godmode = 'God Mode - Aktivní',
    textui_wallhack = 'Wallhack - Aktivní',
    textui_noclip_activated = 'No Clip - Aktivní',
    textui_torque = 'Násobič Točivého Momentu - %s',

    -- ── Oznámení ────────────────────────────────────────────
    dialog_announce = 'Oznámení',
    dialog_announce_label = 'Zpráva',
    dialog_announce_select = 'Všichni',
    dialog_announce_everyone = 'Všichni',
    dialog_announce_placeholder = 'Důležitá zpráva sem. . .',

    -- ── Odbanování ──────────────────────────────────────────
    dialog_unban = 'Jsi si jistý?',
    dialog_unban_content = 'Opravdu chceš odbanovat %s?',

    -- ── Mazání entit ────────────────────────────────────────
    dialog_objects = 'Vyber možnost',
    dialog_clear_objects = 'Smazat VŠECHNY objekty',
    dialog_clear_cars = 'Smazat VŠECHNA auta (bez řidiče)',
    dialog_clear_peds = 'Smazat VŠECHNY pedy',

    -- ── Dání peněz ──────────────────────────────────────────
    dialog_givemoney = 'Dát Peníze',
    givemoney_input_label = 'Částka',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Účet',
    givemoney_select_option1 = 'Hotovost',
    givemoney_select_option2 = 'Banka',
    givemoney_select_option3 = 'Špinavé Peníze',

    -- ── Dání předmětu ───────────────────────────────────────
    dialog_giveitem = 'Dát Předmět',
    giveitem_input_label = 'Název Předmětu',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Množství',
    giveitem_amount_input_placeholder = '3',

    -- ── Vytvoření vozidla ───────────────────────────────────
    dialog_spawn_a_car = 'Vytvořit Vozidlo',
    dialog_car_model = 'Název Modelu',
    dialog_car_model_holder = 'Např: 20charger',
    dialog_car_plate = 'SPZ (volitelné)',
    dialog_car_plate_holder = 'Např: W4S4B1',
    dialog_car_color_primary = 'Primární Barva (volitelné)',
    dialog_car_color_second = 'Sekundární Barva (volitelné)',
    dialog_car_maxed = 'Maximální Úpravy (volitelné)',

    -- ── Vyhození ────────────────────────────────────────────
    dialog_kick = 'Vyhodit %s',
    dialog_kick_reason = 'Důvod',
    dialog_kick_placeholder = 'Cheater',
    kicked_reason_replace = 'Byl jsi vyhozen ze serveru!',

    -- ── Ban ─────────────────────────────────────────────────
    dialog_ban = 'Zabanovat %s',
    dialog_ban_reason = 'Důvod',
    dialog_ban_placeholder = 'Cheater',
    ban_reason_replace = 'Byl jsi zabanován na tomto serveru!',

    -- ── Vytvoření zóny ──────────────────────────────────────
    dialog_zone_create = 'Vytvoření Zóny',
    dialog_zone_name = 'Název',
    dialog_zone_name_desc = 'Název zóny / blipu',
    dialog_zone_name_holder = 'Admin Zóna',
    dialog_zone_text = 'Zobrazený Text',
    dialog_zone_text_desc = 'Text zobrazený hráčům uvnitř zóny',
    dialog_zone_text_holder = 'ADMIN ZÓNA - AKTIVNÍ',
    dialog_zone_size = 'Velikost',
    dialog_zone_speed = 'Rychlostní Limit',
    mph = 'MPH',
    kmh = 'KM/H',
    dialog_zone_blip_id = 'ID Blipu',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'ID Barvy',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Blikající Blip',
    dialog_zone_disarm = 'Odzbrojit',
    dialog_zone_revive = 'Oživit',
    dialog_zone_invincible = 'Nesmrtelnost',
    dialog_zone_edit = 'Úprava „%s"',
    dialog_zone_delete_confirm = 'Jsi si jistý?',
    dialog_zone_delete_confirm_desc = 'Opravdu chceš smazat zónu: %s',

    -- ── Upozornění: peníze ──────────────────────────────────
    notify_givemoney_success = 'Peníze Připsány',
    notify_givemoney_success_desc = 'Připsal jsi hráči %s $%s na účet: %s',
    notify_givemoney_fail = 'Neúspěch',
    notify_givemoney_fail_desc = 'Zkusil jsi připsat %s, ale něco se pokazilo! Zkus to znovu.',

    -- ── Upozornění: předměty ────────────────────────────────
    notify_giveitem_success = 'Předmět Předán',
    notify_giveitem_success_desc = 'Předal jsi hráči %s. Předmět: %s Množství: %s',
    notify_giveitem_fail = 'Selhalo',
    notify_giveitem_fail_desc = 'Zkusil jsi předat %s, ale něco se pokazilo! Zkus to znovu.',

    -- ── Upozornění: vyhození / ban ──────────────────────────
    notify_kicked_success = 'Vyhození Úspěšné',
    notify_kicked_success_desc = 'Úspěšně jsi vyhodil %s',
    notify_banned_success = 'Ban Úspěšný',
    notify_banned_success_desc = 'Úspěšně jsi zabanoval %s',

    -- ── Upozornění: inventář ────────────────────────────────
    notify_clearedinv = 'Inventář Vyprázdněn',
    notify_clearedinv_desc = 'Úspěšně jsi vyprázdnil inventář hráče %s',

    -- ── Upozornění: neplatné ID ─────────────────────────────
    notify_invalidid = 'Neplatné ID',
    notify_invalidid_desc = 'Zadané ID je neplatné, zkus to prosím znovu.',

    -- ── Upozornění: úklid ───────────────────────────────────
    notify_deleted_car = 'Auta Smazána',
    notify_deleted_car_desc = 'Úspěšně jsi smazal všechna auta bez řidiče.',
    notify_deleted_ped = 'Pedi Smazáni',
    notify_deleted_ped_desc = 'Úspěšně jsi smazal všechny pedy na mapě',
    notify_deleted_objects = 'Objekty Smazány',
    notify_deleted_objects_desc = 'Úspěšně jsi smazal všechny objekty na mapě',

    -- ── Upozornění: počasí ──────────────────────────────────
    notify_weather = 'Počasí Změněno',
    notify_weather_desc = 'Počasí změněno na: %s',

    -- ── Upozornění: kopírování souřadnic ────────────────────
    notify_copied = 'Zkopírováno',
    notify_copied_vec3 = 'Vector3 úspěšně zkopírován do schránky!',
    notify_copied_vec4 = 'Vector4 úspěšně zkopírován do schránky!',
    notify_copied_headin = 'Natočení úspěšně zkopírováno do schránky!',

    -- ── Upozornění: dveře ───────────────────────────────────
    notify_locked_doors = 'Zamčeno',
    notify_locked_doors_desc = 'Dveře vozidla úspěšně zamčeny.',
    notify_unlocked_doors = 'Odemčeno',
    notify_unlocked_doors_desc = 'Dveře vozidla úspěšně odemčeny.',

    -- ── Upozornění: admin zóny ──────────────────────────────
    notify_zone_deleted = 'Zóna Smazána',
    notify_zone_deleted_desc = 'Úspěšně jsi odstranil zónu: %s.',
    notify_zone_not_deleted_desc = 'Při mazání zóny nastala chyba: %s.',
    notify_zone_edited = 'Zóna Upravena',
    notify_zone_edited_desc = 'Úspěšně jsi upravil zónu: %s.',
    notify_zone_not_edited_desc = 'Při úpravě zóny nastala chyba: %s.',
    notify_zone_action_cancelled = 'Akce Zrušena',
    notify_zone_delete_cancel = 'Zrušil jsi mazání zóny: %s',
    notify_zone_no_weapons = 'Zbraně Zakázány',
    notify_zone_no_weapons_desc = 'Nemáš povoleno používat zbraně uvnitř této zóny.',
    notify_zones_not_found = 'Žádné Zóny',
    notify_zones_not_found_desc = 'Momentálně nejsou žádné aktivní zóny ke správě.',
    notify_zones_teleport = 'Teleportován',
    notify_zones_teleport_desc = 'Úspěšně ses teleportoval do zóny: %s.',

    -- ── Upozornění: odbanování ──────────────────────────────
    successfully_unbanned = 'Ban Zrušen',
    successfully_unbanned_desc = 'Úspěšně jsi odbanoval: %s.',
    unsuccessful_unban = 'Něco se pokazilo při odbanování: %s.',

    -- ── Připojení (deferraly) ───────────────────────────────
    deferral_welcome = '[%s] Ahoj %s, kontroluji bany. . .',
    deferral_banned = 'Jsi zabanován na tomto serveru. Důvod: „%s" (Zbývá: %s hodin %s minut).',
    deferral_banned_perm = 'Jsi zabanován na tomto serveru. Důvod: „%s" (Zbývá: Trvale).',

    -- ── Chyby ───────────────────────────────────────────────
    notify_error = 'Chyba',
    notify_disabled_keys = 'Není nastaven žádný skript pro klíče od vozidel. Kontaktuj vývojáře serveru.',
    notify_no_appearance = 'Nebyl detekován žádný skript oblečení / vzhledu. Kontaktuj vývojáře serveru.',
    notify_no_vehicle = 'Nebylo nalezeno žádné vozidlo!',
    notify_invalid_entry = 'Neplatný vstup!',

    -- ── Klávesová zkratka ───────────────────────────────────
    keymapping_desc = 'Otevřít Admin Menu (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Zapnut',
    noclip_deactivated = 'NoClip Vypnut',

    -- ── Neviditelnost ───────────────────────────────────────
    invisibility_activated = 'Režim Neviditelnosti Zapnut',
    invisibility_deactivated = 'Režim Neviditelnosti Vypnut',

    -- ── God Mode ────────────────────────────────────────────
    godmode_activated = 'God Mode Zapnut',
    godmode_deactivated = 'God Mode Vypnut',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Zapnut',
    wallhack_deactivated = 'Wallhack Vypnut',

    -- ── Debug režim ─────────────────────────────────────────
    debug_activated = 'Debug Režim Zapnut',
    debug_deactivated = 'Debug Režim Vypnut',

    -- ── Upozornění: vozidla ─────────────────────────────────
    vehicle_repaired = 'Vozidlo Opraveno',
    vehicle_repaired_desc = 'Vozidlo bylo úspěšně opraveno.',
    vehicle_deleted = 'Vozidlo Smazáno',
    vehicle_deleted_desc = 'Vozidlo bylo úspěšně smazáno.',
    vehicle_spawned = 'Vozidlo Vytvořeno',
    vehicle_spawned_desc = 'Vozidlo %s bylo úspěšně vytvořeno.',
    vehicle_plate_changed = 'SPZ Změněna',
    vehicle_plate_changed_desc = 'SPZ vozidla změněna na: %s',
    vehicle_refueled = 'Vozidlo Natankováno',
    vehicle_refueled_desc = 'Vozidlo bylo úspěšně natankováno.',
    vehicle_keys_given = 'Klíče Obdrženy',
    vehicle_keys_given_desc = 'Obdržel jsi klíče od vozidla se SPZ: %s',
    vehicle_color_changed = 'Barva Vozidla Změněna',
    vehicle_color_changed_desc = 'Barva vozidla změněna na: %s',
    vehicle_torque_set = 'Násobič Momentu Nastaven',
    vehicle_torque_set_desc = 'Točivý moment nastaven na: %sx',
    vehicle_torque_disabled = 'Násobič Momentu Vypnut',

    -- ── Sledování ───────────────────────────────────────────
    spectate_started = 'Sledování',
    spectate_started_desc = 'Sleduješ %s. Stiskni X pro ukončení.',
    spectate_ended = 'Sledování Ukončeno',
    spectate_ended_desc = 'Už nikoho nesleduješ.',
    spectate_error = 'Chyba Sledování',
    spectate_error_desc = 'Cílový hráč nebyl nalezen nebo už neexistuje.',

    -- ── Teleportace ─────────────────────────────────────────
    teleport_success = 'Teleportován',
    teleport_success_desc = 'Byl jsi úspěšně teleportován.',

    -- ── Oživení / léčení ────────────────────────────────────
    player_revived = 'Hráč Oživen',
    player_revived_desc = 'Úspěšně jsi oživil %s.',
    player_healed = 'Hráč Vyléčen',
    player_healed_desc = 'Úspěšně jsi vyléčil %s.',
    self_revived = 'Oživen',
    self_revived_desc = 'Oživil jsi sám sebe.',
    self_healed = 'Vyléčen',
    self_healed_desc = 'Vyléčil jsi sám sebe.',

    -- ── Pedi ────────────────────────────────────────────────
    ped_changed = 'Ped Změněn',
    ped_changed_desc = 'Tvůj model peda byl změněn.',
    ped_restored = 'Ped Obnoven',
    ped_restored_desc = 'Tvůj původní model peda byl obnoven.',

    skin_menu_opened = 'Menu Oblečení Otevřeno',

    admin_menu_opened = 'Admin Menu Otevřeno',
    admin_menu_closed = 'Admin Menu Zavřeno',

    entity_deleted = 'Entita Smazána',
    entity_deleted_desc = 'Entita byla úspěšně smazána.',

    player_frozen = 'Hráč Zmrazen',
    player_frozen_desc = 'Hráč %s byl zmrazen.',
    player_unfrozen = 'Hráč Rozmrazen',
    player_unfrozen_desc = 'Hráč %s byl rozmrazen.',

    -- ── Vlastní SPZ ─────────────────────────────────────────
    dialog_license_plate = 'Vlastní SPZ',
    dialog_license_plate_label = 'SPZ',
    dialog_license_plate_placeholder = 'SPZ',

    -- ── Odebrání peněz ──────────────────────────────────────
    player_removemoney = 'Odebrat Peníze',
    player_removemoney_desc = 'Odebrat peníze vybranému hráči',
    dialog_removemoney = 'Odebrat Peníze',
    removemoney_input_label = 'Částka',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Účet',
    notify_removemoney_success = 'Peníze Odebrány',
    notify_removemoney_success_desc = 'Odebral jsi $%s hráči %s (účet: %s)',
    notify_removemoney_fail = 'Neúspěch',
    notify_removemoney_fail_desc = 'Nepodařilo se odebrat peníze hráči %s (možná nedostatek prostředků).',

    -- ── Dimenze / routing buckety ───────────────────────────
    self_dimension = 'Nastavit Mou Dimenzi',
    self_dimension_desc = 'Přesunout se do routing bucketu (0 = hlavní svět)',
    player_dimension = 'Nastavit Dimenzi',
    player_dimension_desc = 'Přesunout tohoto hráče do routing bucketu',
    player_dimension_bring = 'Přitáhnout do Mé Dimenze',
    player_dimension_bring_desc = 'Přitáhnout tohoto hráče do tvé současné dimenze',
    player_dimension_goto = 'Připojit se k Dimenzi Hráče',
    player_dimension_goto_desc = 'Přesunout se do dimenze tohoto hráče',
    dialog_dimension = 'Nastavit Dimenzi',
    dimension_input_label = 'Dimenze (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Dimenze Změněna',
    notify_dimension_self_desc = 'Nyní jsi v dimenzi %s.',
    notify_dimension_player_desc = '%s byl přesunut do dimenze %s.',
    notify_dimension_join_desc = 'Připojil ses k dimenzi hráče %s (%s).',
    notify_dimension_fail = 'Chyba Dimenze',
    notify_dimension_fail_desc = 'Nepodařilo se změnit dimenzi.',

    -- ── Teleportace do vozidla ──────────────────────────────
    player_tp_vehicle = 'Teleportovat do Vozidla',
    player_tp_vehicle_desc = 'Nasednout do vozidla tohoto hráče a pomoct s jeho záchranou',
    notify_tp_vehicle_fail = 'Žádné Vozidlo',
    notify_tp_vehicle_fail_desc = '%s není ve vozidle.',
    notify_tp_vehicle_success = 'Teleportován',
    notify_tp_vehicle_success_desc = 'Byl jsi přesunut do vozidla hráče %s.',

    -- ── Záchrana vozidla ────────────────────────────────────
    recover_car = 'Zachránit / Otočit Vozidlo',
    recover_car_desc = 'Postavit na kola a přesunout na nejbližší silnici (moře/převrácené)',
    vehicle_recovered = 'Vozidlo Zachráněno',
    vehicle_recovered_desc = 'Vozidlo bylo postaveno na kola a umístěno na nejbližší silnici.',

    -- ── Vlastněná vozidla ───────────────────────────────────
    player_owned_vehicles = 'Vlastněná Vozidla',
    player_owned_vehicles_desc = 'Zobrazit, přidat nebo odebrat auta tohoto hráče',
    owned_vehicles_menu = 'Vlastněná Vozidla (%s)',
    owned_vehicles_add = 'Přidat Vozidlo',
    owned_vehicles_add_desc = 'Přidat vozidlo do garáže tohoto hráče',
    owned_vehicles_none = 'Žádná Vozidla',
    owned_vehicles_none_desc = 'Tento hráč nevlastní žádné vozidlo.',
    owned_vehicle_desc = 'SPZ: %s · klikni pro odebrání',
    dialog_add_vehicle = 'Přidat Vozidlo',
    add_vehicle_model_label = 'Název Modelu',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'SPZ (volitelné)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = 'Odebrat %s?',
    notify_owned_added = 'Vozidlo Přidáno',
    notify_owned_added_desc = 'Přidáno %s (SPZ %s) hráči %s.',
    notify_owned_removed = 'Vozidlo Odebráno',
    notify_owned_removed_desc = 'Odebrána SPZ %s hráči %s.',
    notify_owned_fail = 'Chyba Databáze',
    notify_owned_fail_desc = 'Operace s databází vozidel selhala.',

    -- ── Menu pedů ───────────────────────────────────────────
    player_pedmenu = 'Dát Menu Pedů',
    player_pedmenu_desc = 'Otevřít menu výběru peda na obrazovce tohoto hráče',
    pedmenu_title = 'Menu Pedů',
    pedmenu_given = 'Menu Pedů Odesláno',
    pedmenu_given_desc = 'Menu pedů otevřeno pro %s.'
}
