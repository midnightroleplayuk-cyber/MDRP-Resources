-- ============================================================
-- MAGYAR (hu)
-- ------------------------------------------------------------
-- Réteg a configs/strings.lua fölött. Minden kulcs, ami itt
-- hiányzik, megtartja az angol szöveget, így a részleges
-- fordítás biztonságos.
--
-- A %s helyőrzőket meg kell tartani, MEGEGYEZŐ sorrendben az
-- eredetivel: a kódban a :format() tölti ki őket. A %% egy
-- szó szerinti százalékjelet ír ki.
--
-- Bekapcsolás:  Config.Locale = 'hu'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['hu'] = {
    -- ── Főmenü ──────────────────────────────────────────────
    main_title = 'Admin Menü',
    self_options = 'Saját Beállítások',
    self_options_desc = 'Rád vonatkozó beállítások',
    player_options_title = 'Játékos Beállítások',
    player_options_desc = 'Más játékosokra vonatkozó beállítások',
    vehicle_options = 'Jármű Beállítások',
    vehicle_options_desc = 'Járművekre vonatkozó beállítások',
    server_options = 'Szerver Beállítások',
    server_options_desc = 'Szerverre vonatkozó beállítások',
    admin_zone_options = 'Admin Zónák',
    admin_zone_options_desc = 'Admin zónák kezelése, hozzáadása és törlése',
    developer_options = 'Fejlesztői Beállítások',
    developer_options_desc = '',

    -- ── Saját beállítások ───────────────────────────────────
    self_options_menu = 'Saját Beállítások',
    self_health = 'Élet (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Újraélesztés',
    self_revive_desc = 'Élessz újra magadat',
    self_heal = 'Gyógyítás',
    self_heal_desc = 'Gyógyítsd meg magadat',
    self_skinmenu = 'Ruha Menü',
    self_set_ped = 'Ped Váltás',
    self_skinmenu_desc = 'Ruha menü megnyitása helyben',
    self_invisible = 'Láthatatlanság',
    self_godmode = 'Isten Mód',
    self_wallhack = 'Wallhack',

    -- ── Játékos beállítások ─────────────────────────────────
    player_options_menu = 'Online Játékosok %s/%s',
    player_options = 'Játékos: %s',
    player_health = 'Játékos Élete (%s%%)',
    player_freeze = 'Lefagyasztás',
    player_freeze_desc = 'Be-/kikapcsolás',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Be-/kikapcsolás',
    player_spectate = 'Megfigyelés',
    player_spectate_desc = 'Ennek a játékosnak a tetteit figyeld',
    player_playerdata = 'Játékos Adatai',
    player_playerdata_desc = 'A játékos adatainak megtekintése',
    player_revive = 'Újraélesztés',
    player_revive_desc = 'Játékos újraélesztése',
    player_heal = 'Gyógyítás',
    player_heal_desc = 'Játékos gyógyítása',
    player_skinmenu = 'Ruha Menü',
    player_skinmenu_desc = 'Ruha menü megnyitása a játékosnál',
    player_money = 'Pénz Adása',
    player_money_desc = 'Pénz adása a kiválasztott játékosnak',
    player_item = 'Tárgy Adása',
    player_item_desc = 'Tárgy adása a kiválasztott játékosnak',
    player_openinv = 'Táska Megnyitása',
    player_openinv_desc = 'A játékos táskájának megnyitása',
    player_clearinv = 'Táska Ürítése',
    player_clearinv_desc = 'A játékos táskájának kiürítése',
    player_teleport_to = 'Teleport a Játékoshoz',
    player_teleport_to_desc = 'Teleportálj a játékoshoz',
    player_bring = 'Idehozás',
    player_bring_desc = 'Hozd a játékost a saját pozíciódra',
    player_kick = 'Kirúgás',
    player_kick_desc = 'Játékos kirúgása a szerverről',
    player_ban = 'Játékos Kitiltása',

    -- ── Jármű menü ──────────────────────────────────────────
    vehicle_menu = 'Jármű Menü',
    spawn_car = 'Jármű Létrehozása',
    spawn_car_desc = 'Jármű létrehozása',
    repair_car = 'Jármű Javítása',
    repair_car_desc = 'A jelenlegi vagy legközelebbi jármű javítása',
    delete_car = 'Jármű Törlése',
    delete_car_desc = 'A jelenlegi vagy legközelebbi jármű törlése',
    number_plate = 'Rendszám Módosítása',
    number_plate_desc = 'A jelenlegi rendszám szövegének módosítása',
    refuel = 'Jármű Tankolása',
    refuel_desc = 'A jelenlegi vagy legközelebbi jármű tankolása',
    give_keys = 'Kulcsok Adása',
    give_keys_desc = 'Add magadnak a jelenlegi jármű kulcsait',
    doors = 'Ajtók Zárása/Nyitása',
    doors_desc = 'Átkapcsolja a legközelebbi jármű zárjait',
    boost_car = 'Nyomaték Szorzó',
    boost_car_desc = 'A jelenlegi jármű nyomatékának módosítása',
    color_change = 'Jármű Színének Módosítása',
    color_change_desc = 'A jelenlegi vagy legközelebbi jármű színének módosítása',

    -- ── Szerverkezelés ──────────────────────────────────────
    server_management = 'Szerverkezelés',
    server_announcement = 'Szerver Közlemény',
    server_announcement_desc = 'Globális közlemény küldése az egész szervernek',
    ban_list = 'Kitiltási Lista',
    ban_list_desc = 'Az összes aktív kitiltás megtekintése',
    objects_list = 'Entitások Törlése',
    objects_list_desc = 'Járművek és pedek törlése',
    objects_list_label = 'Beállítások',
    weather_menu = 'Időjárás Kezelése',
    weather_menu_desc = 'Az időjárás kezelése',

    -- ── Admin zónák ─────────────────────────────────────────
    zones_create = 'Zóna Létrehozása',
    zones_create_desc = 'Új admin zóna létrehozása',
    zones_manage = 'Zónák Kezelése',
    zones_manage_desc = 'Aktív zónák szerkesztése vagy törlése',
    zone_edit_current = 'Jelenlegi Zóna Szerkesztése',
    zone_edit_current_desc = 'Annak a zónának a kezelése, amelyben vagy',
    zone_delete_current = 'Jelenlegi Zóna Törlése',
    zone_delete_current_desc = 'Annak a zónának a törlése, amelyben vagy',
    zone_manage_menu = 'Zóna Szerkesztése (%s)',
    zone_edit = 'Zóna Szerkesztése',
    zone_edit_desc = 'Zóna módosítása: %s',
    zone_delete = 'Zóna Törlése',
    zone_delete_desc = 'Zóna törlése: %s',
    zone_teleport = 'Teleport a Zónába',
    zone_teleport_desc = 'Ugrás a zónába: %s',

    -- ── Fejlesztői menü ─────────────────────────────────────
    dev_options = 'Fejlesztői Beállítások',
    debug_mode = 'Debug Mód',
    debug_mode_desc = 'Debug mód be-/kikapcsolása',
    copy_vec3 = 'Vector3 Koordináták Másolása',
    copy_vec3_desc = 'A jelenlegi pozíciódat (vector3) a vágólapra másolja',
    copy_vec4 = 'Vector4 Koordináták Másolása',
    copy_vec4_desc = 'A jelenlegi pozíciódat (vector4) a vágólapra másolja',
    copy_heading = 'Nézési Irány Másolása',
    copy_heading_desc = 'A jelenlegi nézési irányodat a vágólapra másolja',
    cant_delete = 'Nem törölhető!',
    cant_delete_player_desc = 'Nem törölheted a játékosok pedjeit!',
    cant_delete_entity_desc = 'Nem törölheted a pálya alapértelmezett objektumait!',

    -- ── Kitiltási lista ─────────────────────────────────────
    ban_list_menu = 'Kitiltási Lista',
    ban_list_name = 'Név: %s',
    ban_list_license = 'Licenc:',
    ban_list_by = 'Kiadta: %s',
    ban_list_reason = 'Indok: %s',
    ban_list_length = 'Hátralévő idő: %s óra %s perc',
    ban_list_modify = 'Kitiltás Módosítása',
    ban_list_unban = 'Kitiltás Feloldása',
    ban_list_no_data = 'Nincs Kitiltás',
    ban_list_no_data_desc = 'Nem található aktív kitiltás!',

    -- ── Játékos adatai ──────────────────────────────────────
    playerdata_menu = 'Játékos Adatai',
    playerdata_license_esx = 'Licenc: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Kattints a teljes licenc másolásához',
    playerdata_igname = 'Név: %s',
    playerdata_igname_desc = 'A játékos teljes neve a játékban',
    playerdata_steam = 'Steam Név: %s',
    playerdata_steam_desc = 'A játékos teljes Steam neve',
    playerdata_gender = 'Nem: %s',
    playerdata_gender_desc = 'A játékos neme',
    playerdata_cash = 'Készpénz: %s',
    playerdata_cash_desc = 'A játékos készpénz egyenlege',
    playerdata_bank = 'Bank: %s',
    playerdata_bank_desc = 'A játékos banki egyenlege',
    playerdata_blackmoney = 'Feketepénz: %s',
    playerdata_blackmoney_desc = 'A játékos feketepénz egyenlege',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Nyomd meg az [E]-t az entitás törléséhez  \nHash: %s  \nKoordináták: vec3(%s, %s, %s)  \nIrány: %s  \nTulajdonos: [%s] - %s',
    debug_textui_noname = 'Nyomd meg az [E]-t az entitás törléséhez\n  Hash: %s\n  Koordináták: vec3(%s, %s, %s)\n  Irány: %s\n  Tulajdonos: ISMERETLEN',

    textui_invisible = 'Láthatatlan Mód - Aktív',
    textui_godmode = 'Isten Mód - Aktív',
    textui_wallhack = 'Wallhack - Aktív',
    textui_noclip_activated = 'No Clip - Aktív',
    textui_torque = 'Nyomaték Szorzó - %s',

    -- ── Közlemények ─────────────────────────────────────────
    dialog_announce = 'Közlemény',
    dialog_announce_label = 'Üzenet',
    dialog_announce_select = 'Mindenki',
    dialog_announce_everyone = 'Mindenki',
    dialog_announce_placeholder = 'Fontos üzenet ide. . .',

    -- ── Kitiltás feloldása ──────────────────────────────────
    dialog_unban = 'Biztos vagy benne?',
    dialog_unban_content = 'Tényleg fel akarod oldani %s kitiltását?',

    -- ── Entitások törlése ───────────────────────────────────
    dialog_objects = 'Válassz egy lehetőséget',
    dialog_clear_objects = 'MINDEN objektum törlése',
    dialog_clear_cars = 'MINDEN autó törlése (vezető nélkül)',
    dialog_clear_peds = 'MINDEN ped törlése',

    -- ── Pénz adása ──────────────────────────────────────────
    dialog_givemoney = 'Pénz Adása',
    givemoney_input_label = 'Összeg',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Számla',
    givemoney_select_option1 = 'Készpénz',
    givemoney_select_option2 = 'Bank',
    givemoney_select_option3 = 'Feketepénz',

    -- ── Tárgy adása ─────────────────────────────────────────
    dialog_giveitem = 'Tárgy Adása',
    giveitem_input_label = 'Tárgy Neve',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Mennyiség',
    giveitem_amount_input_placeholder = '3',

    -- ── Jármű létrehozása ───────────────────────────────────
    dialog_spawn_a_car = 'Jármű Létrehozása',
    dialog_car_model = 'Modell Neve',
    dialog_car_model_holder = 'Pl: 20charger',
    dialog_car_plate = 'Rendszám (opcionális)',
    dialog_car_plate_holder = 'Pl: W4S4B1',
    dialog_car_color_primary = 'Elsődleges Szín (opcionális)',
    dialog_car_color_second = 'Másodlagos Szín (opcionális)',
    dialog_car_maxed = 'Maximális Tuning (opcionális)',

    -- ── Kirúgás ─────────────────────────────────────────────
    dialog_kick = '%s kirúgása',
    dialog_kick_reason = 'Indok',
    dialog_kick_placeholder = 'Csaló',
    kicked_reason_replace = 'Kirúgtak a szerverről!',

    -- ── Kitiltás ────────────────────────────────────────────
    dialog_ban = '%s kitiltása',
    dialog_ban_reason = 'Indok',
    dialog_ban_placeholder = 'Csaló',
    ban_reason_replace = 'Kitiltottak erről a szerverről!',

    -- ── Zóna létrehozása ────────────────────────────────────
    dialog_zone_create = 'Zóna Létrehozása',
    dialog_zone_name = 'Név',
    dialog_zone_name_desc = 'A zóna / blip neve',
    dialog_zone_name_holder = 'Admin Zóna',
    dialog_zone_text = 'Megjelenített Szöveg',
    dialog_zone_text_desc = 'A zónán belüli játékosoknak megjelenő szöveg',
    dialog_zone_text_holder = 'ADMIN ZÓNA - AKTÍV',
    dialog_zone_size = 'Méret',
    dialog_zone_speed = 'Sebességkorlát',
    mph = 'MPH',
    kmh = 'KM/H',
    dialog_zone_blip_id = 'Blip ID',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'Szín ID',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Villogó Blip',
    dialog_zone_disarm = 'Lefegyverzés',
    dialog_zone_revive = 'Újraélesztés',
    dialog_zone_invincible = 'Sebezhetetlen',
    dialog_zone_edit = '„%s" szerkesztése',
    dialog_zone_delete_confirm = 'Biztos vagy benne?',
    dialog_zone_delete_confirm_desc = 'Tényleg törölni akarod ezt a zónát: %s',

    -- ── Értesítések: pénz ───────────────────────────────────
    notify_givemoney_success = 'Pénz Jóváírva',
    notify_givemoney_success_desc = 'Jóváírtál %s részére $%s összeget a számlára: %s',
    notify_givemoney_fail = 'Sikertelen',
    notify_givemoney_fail_desc = 'Megpróbáltál jóváírni %s részére, de valami hiba történt! Próbáld újra.',

    -- ── Értesítések: tárgyak ────────────────────────────────
    notify_giveitem_success = 'Tárgy Átadva',
    notify_giveitem_success_desc = 'Átadtad %s részére. Tárgy: %s Mennyiség: %s',
    notify_giveitem_fail = 'Sikertelen',
    notify_giveitem_fail_desc = 'Megpróbáltál átadni %s részére, de valami hiba történt! Próbáld újra.',

    -- ── Értesítések: kirúgás / kitiltás ─────────────────────
    notify_kicked_success = 'Kirúgás Sikeres',
    notify_kicked_success_desc = 'Sikeresen kirúgtad %s játékost',
    notify_banned_success = 'Kitiltás Sikeres',
    notify_banned_success_desc = 'Sikeresen kitiltottad %s játékost',

    -- ── Értesítések: táska ──────────────────────────────────
    notify_clearedinv = 'Táska Kiürítve',
    notify_clearedinv_desc = 'Sikeresen kiürítetted %s táskáját',

    -- ── Értesítések: érvénytelen ID ─────────────────────────
    notify_invalidid = 'Érvénytelen ID',
    notify_invalidid_desc = 'A megadott ID érvénytelen, próbáld újra.',

    -- ── Értesítések: takarítás ──────────────────────────────
    notify_deleted_car = 'Autók Törölve',
    notify_deleted_car_desc = 'Sikeresen törölted az összes vezető nélküli autót.',
    notify_deleted_ped = 'Pedek Törölve',
    notify_deleted_ped_desc = 'Sikeresen törölted a pálya összes pedjét',
    notify_deleted_objects = 'Objektumok Törölve',
    notify_deleted_objects_desc = 'Sikeresen törölted a pálya összes objektumát',

    -- ── Értesítések: időjárás ───────────────────────────────
    notify_weather = 'Időjárás Módosítva',
    notify_weather_desc = 'Időjárás módosítva erre: %s',

    -- ── Értesítések: koordináta másolás ─────────────────────
    notify_copied = 'Másolva',
    notify_copied_vec3 = 'Vector3 sikeresen a vágólapra másolva!',
    notify_copied_vec4 = 'Vector4 sikeresen a vágólapra másolva!',
    notify_copied_headin = 'Nézési irány sikeresen a vágólapra másolva!',

    -- ── Értesítések: ajtók ──────────────────────────────────
    notify_locked_doors = 'Bezárva',
    notify_locked_doors_desc = 'A jármű ajtajai sikeresen bezárva.',
    notify_unlocked_doors = 'Kinyitva',
    notify_unlocked_doors_desc = 'A jármű ajtajai sikeresen kinyitva.',

    -- ── Értesítések: admin zónák ────────────────────────────
    notify_zone_deleted = 'Zóna Törölve',
    notify_zone_deleted_desc = 'Sikeresen eltávolítottad ezt a zónát: %s.',
    notify_zone_not_deleted_desc = 'Hiba történt a zóna törlése közben: %s.',
    notify_zone_edited = 'Zóna Módosítva',
    notify_zone_edited_desc = 'Sikeresen módosítottad ezt a zónát: %s.',
    notify_zone_not_edited_desc = 'Hiba történt a zóna módosítása közben: %s.',
    notify_zone_action_cancelled = 'Művelet Megszakítva',
    notify_zone_delete_cancel = 'Megszakítottad a zóna törlését: %s',
    notify_zone_no_weapons = 'Fegyverek Tiltva',
    notify_zone_no_weapons_desc = 'Nem használhatsz fegyvert ebben a zónában.',
    notify_zones_not_found = 'Nincs Zóna',
    notify_zones_not_found_desc = 'Jelenleg nincs kezelhető aktív zóna.',
    notify_zones_teleport = 'Teleportálva',
    notify_zones_teleport_desc = 'Sikeresen teleportáltál ebbe a zónába: %s.',

    -- ── Értesítések: kitiltás feloldása ─────────────────────
    successfully_unbanned = 'Kitiltás Visszavonva',
    successfully_unbanned_desc = 'Sikeresen feloldottad a kitiltását: %s.',
    unsuccessful_unban = 'Hiba történt a kitiltás feloldásakor: %s.',

    -- ── Csatlakozás (deferral) ──────────────────────────────
    deferral_welcome = '[%s] Szia %s, kitiltások ellenőrzése. . .',
    deferral_banned = 'Ki vagy tiltva erről a szerverről. Indok: „%s" (Hátralévő idő: %s óra %s perc).',
    deferral_banned_perm = 'Ki vagy tiltva erről a szerverről. Indok: „%s" (Hátralévő idő: Végleges).',

    -- ── Hibák ───────────────────────────────────────────────
    notify_error = 'Hiba',
    notify_disabled_keys = 'Nincs beállítva járműkulcs szkript. Vedd fel a kapcsolatot a szerver fejlesztőjével.',
    notify_no_appearance = 'Nem található ruha / megjelenés szkript. Vedd fel a kapcsolatot a szerver fejlesztőjével.',
    notify_no_vehicle = 'Nem található jármű!',
    notify_invalid_entry = 'Érvénytelen bevitel!',

    -- ── Gyorsbillentyű ──────────────────────────────────────
    keymapping_desc = 'Admin Menü megnyitása (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Bekapcsolva',
    noclip_deactivated = 'NoClip Kikapcsolva',

    -- ── Láthatatlanság ──────────────────────────────────────
    invisibility_activated = 'Láthatatlan Mód Bekapcsolva',
    invisibility_deactivated = 'Láthatatlan Mód Kikapcsolva',

    -- ── Isten mód ───────────────────────────────────────────
    godmode_activated = 'Isten Mód Bekapcsolva',
    godmode_deactivated = 'Isten Mód Kikapcsolva',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Bekapcsolva',
    wallhack_deactivated = 'Wallhack Kikapcsolva',

    -- ── Debug mód ───────────────────────────────────────────
    debug_activated = 'Debug Mód Bekapcsolva',
    debug_deactivated = 'Debug Mód Kikapcsolva',

    -- ── Értesítések: járművek ───────────────────────────────
    vehicle_repaired = 'Jármű Megjavítva',
    vehicle_repaired_desc = 'A jármű sikeresen meg lett javítva.',
    vehicle_deleted = 'Jármű Törölve',
    vehicle_deleted_desc = 'A jármű sikeresen törölve lett.',
    vehicle_spawned = 'Jármű Létrehozva',
    vehicle_spawned_desc = 'A(z) %s jármű sikeresen létrejött.',
    vehicle_plate_changed = 'Rendszám Módosítva',
    vehicle_plate_changed_desc = 'A jármű rendszáma erre módosult: %s',
    vehicle_refueled = 'Jármű Feltankolva',
    vehicle_refueled_desc = 'A jármű sikeresen fel lett tankolva.',
    vehicle_keys_given = 'Kulcsok Megkapva',
    vehicle_keys_given_desc = 'Megkaptad a jármű kulcsait, rendszám: %s',
    vehicle_color_changed = 'Jármű Színe Módosítva',
    vehicle_color_changed_desc = 'A jármű színe erre módosult: %s',
    vehicle_torque_set = 'Nyomaték Szorzó Beállítva',
    vehicle_torque_set_desc = 'Nyomaték beállítva: %sx',
    vehicle_torque_disabled = 'Nyomaték Szorzó Kikapcsolva',

    -- ── Megfigyelés ─────────────────────────────────────────
    spectate_started = 'Megfigyelés',
    spectate_started_desc = '%s játékost figyeled. Nyomj X-et a leállításhoz.',
    spectate_ended = 'Megfigyelés Vége',
    spectate_ended_desc = 'Már nem figyelsz senkit.',
    spectate_error = 'Megfigyelési Hiba',
    spectate_error_desc = 'A célzott játékos nem található vagy már nem létezik.',

    -- ── Teleport ────────────────────────────────────────────
    teleport_success = 'Teleportálva',
    teleport_success_desc = 'Sikeresen teleportáltál.',

    -- ── Újraélesztés / gyógyítás ────────────────────────────
    player_revived = 'Játékos Újraélesztve',
    player_revived_desc = 'Sikeresen újraélesztetted %s játékost.',
    player_healed = 'Játékos Meggyógyítva',
    player_healed_desc = 'Sikeresen meggyógyítottad %s játékost.',
    self_revived = 'Újraélesztve',
    self_revived_desc = 'Újraélesztetted magadat.',
    self_healed = 'Meggyógyítva',
    self_healed_desc = 'Meggyógyítottad magadat.',

    -- ── Pedek ───────────────────────────────────────────────
    ped_changed = 'Ped Megváltoztatva',
    ped_changed_desc = 'A ped modelled meg lett változtatva.',
    ped_restored = 'Ped Visszaállítva',
    ped_restored_desc = 'Az eredeti ped modelled vissza lett állítva.',

    skin_menu_opened = 'Ruha Menü Megnyitva',

    admin_menu_opened = 'Admin Menü Megnyitva',
    admin_menu_closed = 'Admin Menü Bezárva',

    entity_deleted = 'Entitás Törölve',
    entity_deleted_desc = 'Az entitás sikeresen törölve lett.',

    player_frozen = 'Játékos Lefagyasztva',
    player_frozen_desc = '%s játékos le lett fagyasztva.',
    player_unfrozen = 'Játékos Feloldva',
    player_unfrozen_desc = '%s játékos fagyasztása fel lett oldva.',

    -- ── Egyedi rendszám ─────────────────────────────────────
    dialog_license_plate = 'Egyedi Rendszám',
    dialog_license_plate_label = 'Rendszám',
    dialog_license_plate_placeholder = 'Rendszám',

    -- ── Pénz elvétele ───────────────────────────────────────
    player_removemoney = 'Pénz Elvétele',
    player_removemoney_desc = 'Pénz elvétele a kiválasztott játékostól',
    dialog_removemoney = 'Pénz Elvétele',
    removemoney_input_label = 'Összeg',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Számla',
    notify_removemoney_success = 'Pénz Elvéve',
    notify_removemoney_success_desc = 'Elvettél $%s összeget tőle: %s (számla: %s)',
    notify_removemoney_fail = 'Sikertelen',
    notify_removemoney_fail_desc = 'Nem sikerült pénzt elvenni tőle: %s (talán nincs elég fedezet).',

    -- ── Dimenziók / routing bucketek ────────────────────────
    self_dimension = 'Saját Dimenzió Beállítása',
    self_dimension_desc = 'Helyezd magad egy routing bucketbe (0 = fő világ)',
    player_dimension = 'Dimenzió Beállítása',
    player_dimension_desc = 'Helyezd ezt a játékost egy routing bucketbe',
    player_dimension_bring = 'Idehozás a Dimenziómba',
    player_dimension_bring_desc = 'Húzd be ezt a játékost a jelenlegi dimenziódba',
    player_dimension_goto = 'Csatlakozás a Játékos Dimenziójához',
    player_dimension_goto_desc = 'Helyezd magad ennek a játékosnak a dimenziójába',
    dialog_dimension = 'Dimenzió Beállítása',
    dimension_input_label = 'Dimenzió (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Dimenzió Megváltozott',
    notify_dimension_self_desc = 'Most a(z) %s dimenzióban vagy.',
    notify_dimension_player_desc = '%s át lett helyezve a(z) %s dimenzióba.',
    notify_dimension_join_desc = 'Csatlakoztál %s dimenziójához (%s).',
    notify_dimension_fail = 'Dimenzió Hiba',
    notify_dimension_fail_desc = 'Nem sikerült megváltoztatni a dimenziót.',

    -- ── Teleport a járműbe ──────────────────────────────────
    player_tp_vehicle = 'Teleport a Járműbe',
    player_tp_vehicle_desc = 'Szállj be ennek a játékosnak a járművébe, hogy segíts kimenteni',
    notify_tp_vehicle_fail = 'Nincs Jármű',
    notify_tp_vehicle_fail_desc = '%s nincs járműben.',
    notify_tp_vehicle_success = 'Teleportálva',
    notify_tp_vehicle_success_desc = 'Bekerültél %s járművébe.',

    -- ── Jármű mentése ───────────────────────────────────────
    recover_car = 'Jármű Mentése / Visszafordítása',
    recover_car_desc = 'Állítsd talpra és helyezd a legközelebbi útra (víz/felborult)',
    vehicle_recovered = 'Jármű Kimentve',
    vehicle_recovered_desc = 'A jármű talpra lett állítva és a legközelebbi útra került.',

    -- ── Tulajdonolt járművek ────────────────────────────────
    player_owned_vehicles = 'Tulajdonolt Járművek',
    player_owned_vehicles_desc = 'Ennek a játékosnak az autóit nézd meg, adj hozzá vagy távolíts el',
    owned_vehicles_menu = 'Tulajdonolt Járművek (%s)',
    owned_vehicles_add = 'Jármű Hozzáadása',
    owned_vehicles_add_desc = 'Jármű hozzáadása ennek a játékosnak a garázsához',
    owned_vehicles_none = 'Nincs Jármű',
    owned_vehicles_none_desc = 'Ennek a játékosnak nincs egyetlen járműve sem.',
    owned_vehicle_desc = 'Rendszám: %s · kattints az eltávolításhoz',
    dialog_add_vehicle = 'Jármű Hozzáadása',
    add_vehicle_model_label = 'Modell Neve',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Rendszám (opcionális)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = 'Eltávolítod: %s?',
    notify_owned_added = 'Jármű Hozzáadva',
    notify_owned_added_desc = '%s (rendszám %s) hozzáadva ehhez: %s.',
    notify_owned_removed = 'Jármű Eltávolítva',
    notify_owned_removed_desc = 'A(z) %s rendszám eltávolítva innen: %s.',
    notify_owned_fail = 'Adatbázis Hiba',
    notify_owned_fail_desc = 'A jármű adatbázis-művelet sikertelen volt.',

    -- ── Ped menü ────────────────────────────────────────────
    player_pedmenu = 'Ped Menü Adása',
    player_pedmenu_desc = 'Ped választó menü megnyitása ennek a játékosnak a képernyőjén',
    pedmenu_title = 'Ped Menü',
    pedmenu_given = 'Ped Menü Elküldve',
    pedmenu_given_desc = 'Ped menü megnyitva %s részére.'
}
