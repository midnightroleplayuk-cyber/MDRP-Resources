-- ============================================================
-- DEUTSCH (de)
-- ------------------------------------------------------------
-- Overlay über configs/strings.lua. Jeder Schlüssel, der hier
-- fehlt, behält automatisch den englischen Text — Teilüberset-
-- zungen sind also unbedenklich.
--
-- Die %s-Platzhalter müssen erhalten bleiben und in DERSELBEN
-- Reihenfolge stehen wie im Original: sie werden im Code von
-- :format() gefüllt. %% gibt ein wörtliches Prozentzeichen aus.
--
-- Aktivierung:  Config.Locale = 'de'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['de'] = {
    -- ── Hauptmenü ───────────────────────────────────────────
    main_title = 'Admin-Menü',
    self_options = 'Eigene Optionen',
    self_options_desc = 'Optionen für dich selbst',
    player_options_title = 'Spieler-Optionen',
    player_options_desc = 'Optionen für andere Spieler',
    vehicle_options = 'Fahrzeug-Optionen',
    vehicle_options_desc = 'Optionen für Fahrzeuge',
    server_options = 'Server-Optionen',
    server_options_desc = 'Optionen für den Server',
    admin_zone_options = 'Admin-Zonen',
    admin_zone_options_desc = 'Admin-Zonen verwalten, hinzufügen und löschen',
    developer_options = 'Entwickler-Optionen',
    developer_options_desc = '',

    -- ── Eigene Optionen ─────────────────────────────────────
    self_options_menu = 'Eigene Optionen',
    self_health = 'Leben (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Wiederbeleben',
    self_revive_desc = 'Dich selbst wiederbeleben',
    self_heal = 'Heilen',
    self_heal_desc = 'Dich selbst heilen',
    self_skinmenu = 'Kleidungsmenü',
    self_set_ped = 'Ped wechseln',
    self_skinmenu_desc = 'Kleidungsmenü lokal öffnen',
    self_invisible = 'Unsichtbar',
    self_godmode = 'Gottmodus',
    self_wallhack = 'Wallhack',

    -- ── Spieler-Optionen ────────────────────────────────────
    player_options_menu = 'Spieler online %s/%s',
    player_options = 'Spieler: %s',
    player_health = 'Leben des Spielers (%s%%)',
    player_freeze = 'Einfrieren',
    player_freeze_desc = 'Ein-/ausschalten',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Ein-/ausschalten',
    player_spectate = 'Zuschauen',
    player_spectate_desc = 'Die Aktionen dieses Spielers beobachten',
    player_playerdata = 'Spielerdaten',
    player_playerdata_desc = 'Daten des Spielers ansehen',
    player_revive = 'Wiederbeleben',
    player_revive_desc = 'Spieler wiederbeleben',
    player_heal = 'Heilen',
    player_heal_desc = 'Spieler heilen',
    player_skinmenu = 'Kleidungsmenü',
    player_skinmenu_desc = 'Dem Spieler ein Kleidungsmenü öffnen',
    player_money = 'Geld geben',
    player_money_desc = 'Dem ausgewählten Spieler Geld geben',
    player_item = 'Item geben',
    player_item_desc = 'Dem ausgewählten Spieler ein Item geben',
    player_openinv = 'Inventar öffnen',
    player_openinv_desc = 'Inventar des Spielers öffnen',
    player_clearinv = 'Inventar leeren',
    player_clearinv_desc = 'Inventar des Spielers leeren',
    player_teleport_to = 'Zum Spieler teleportieren',
    player_teleport_to_desc = 'Dich zum Spieler teleportieren',
    player_bring = 'Herbringen',
    player_bring_desc = 'Den Spieler zu deiner Position holen',
    player_kick = 'Kicken',
    player_kick_desc = 'Den Spieler vom Server werfen',
    player_ban = 'Spieler bannen',

    -- ── Fahrzeugmenü ────────────────────────────────────────
    vehicle_menu = 'Fahrzeugmenü',
    spawn_car = 'Fahrzeug spawnen',
    spawn_car_desc = 'Ein Fahrzeug spawnen',
    repair_car = 'Fahrzeug reparieren',
    repair_car_desc = 'Das aktuelle oder nächstgelegene Fahrzeug reparieren',
    delete_car = 'Fahrzeug löschen',
    delete_car_desc = 'Das aktuelle oder nächstgelegene Fahrzeug löschen',
    number_plate = 'Kennzeichen ändern',
    number_plate_desc = 'Den Text des aktuellen Kennzeichens ändern',
    refuel = 'Fahrzeug betanken',
    refuel_desc = 'Das aktuelle oder nächstgelegene Fahrzeug betanken',
    give_keys = 'Schlüssel geben',
    give_keys_desc = 'Dir die Schlüssel des aktuellen Fahrzeugs geben',
    doors = 'Türen ver-/entriegeln',
    doors_desc = 'Schaltet die Verriegelung des nächstgelegenen Fahrzeugs um',
    boost_car = 'Drehmoment-Multiplikator',
    boost_car_desc = 'Das Drehmoment des aktuellen Fahrzeugs ändern',
    color_change = 'Fahrzeugfarbe ändern',
    color_change_desc = 'Die Farbe des aktuellen oder nächstgelegenen Fahrzeugs ändern',

    -- ── Serververwaltung ────────────────────────────────────
    server_management = 'Serververwaltung',
    server_announcement = 'Server-Ankündigung',
    server_announcement_desc = 'Eine globale Ankündigung an den ganzen Server senden',
    ban_list = 'Bannliste',
    ban_list_desc = 'Alle aktiven Banns einsehen',
    objects_list = 'Entitäten löschen',
    objects_list_desc = 'Fahrzeuge und Peds löschen',
    objects_list_label = 'Optionen',
    weather_menu = 'Wetterverwaltung',
    weather_menu_desc = 'Das Wetter verwalten',

    -- ── Admin-Zonen ─────────────────────────────────────────
    zones_create = 'Zone erstellen',
    zones_create_desc = 'Eine neue Admin-Zone erstellen',
    zones_manage = 'Zonen verwalten',
    zones_manage_desc = 'Aktive Zonen bearbeiten oder löschen',
    zone_edit_current = 'Aktuelle Zone bearbeiten',
    zone_edit_current_desc = 'Die Zone verwalten, in der du dich befindest',
    zone_delete_current = 'Aktuelle Zone löschen',
    zone_delete_current_desc = 'Die Zone löschen, in der du dich befindest',
    zone_manage_menu = 'Zone wird bearbeitet (%s)',
    zone_edit = 'Zone bearbeiten',
    zone_edit_desc = 'Zone ändern: %s',
    zone_delete = 'Zone löschen',
    zone_delete_desc = 'Zone löschen: %s',
    zone_teleport = 'Zur Zone teleportieren',
    zone_teleport_desc = 'Zur Zone gehen: %s',

    -- ── Entwicklermenü ──────────────────────────────────────
    dev_options = 'Entwickler-Optionen',
    debug_mode = 'Debug-Modus',
    debug_mode_desc = 'Debug-Modus ein-/ausschalten',
    copy_vec3 = 'Vector3-Koordinaten kopieren',
    copy_vec3_desc = 'Kopiert deine aktuelle Position (vector3) in die Zwischenablage',
    copy_vec4 = 'Vector4-Koordinaten kopieren',
    copy_vec4_desc = 'Kopiert deine aktuelle Position (vector4) in die Zwischenablage',
    copy_heading = 'Blickrichtung kopieren',
    copy_heading_desc = 'Kopiert deine aktuelle Blickrichtung in die Zwischenablage',
    cant_delete = 'Löschen nicht möglich!',
    cant_delete_player_desc = 'Du kannst keine Spieler-Peds löschen!',
    cant_delete_entity_desc = 'Du kannst keine Standardobjekte der Map löschen!',

    -- ── Bannliste ───────────────────────────────────────────
    ban_list_menu = 'Bannliste',
    ban_list_name = 'Name: %s',
    ban_list_license = 'Lizenz:',
    ban_list_by = 'Ausgestellt von: %s',
    ban_list_reason = 'Grund: %s',
    ban_list_length = 'Verbleibend: %s Stunden %s Minuten',
    ban_list_modify = 'Bann ändern',
    ban_list_unban = 'Spieler entbannen',
    ban_list_no_data = 'Keine Banns',
    ban_list_no_data_desc = 'Es wurden keine aktiven Banns gefunden!',

    -- ── Spielerdaten ────────────────────────────────────────
    playerdata_menu = 'Spielerdaten',
    playerdata_license_esx = 'Lizenz: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Klicken, um die vollständige Lizenz zu kopieren',
    playerdata_igname = 'Name: %s',
    playerdata_igname_desc = 'Vollständiger Ingame-Name des Spielers',
    playerdata_steam = 'Steam-Name: %s',
    playerdata_steam_desc = 'Vollständiger Steam-Name des Spielers',
    playerdata_gender = 'Geschlecht: %s',
    playerdata_gender_desc = 'Geschlecht des Spielers',
    playerdata_cash = 'Bargeld: %s',
    playerdata_cash_desc = 'Bargeldbestand des Spielers',
    playerdata_bank = 'Bank: %s',
    playerdata_bank_desc = 'Bankguthaben des Spielers',
    playerdata_blackmoney = 'Schwarzgeld: %s',
    playerdata_blackmoney_desc = 'Schwarzgeldbestand des Spielers',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = '[E] drücken, um die Entität zu löschen  \nHash: %s  \nKoordinaten: vec3(%s, %s, %s)  \nBlickrichtung: %s  \nBesitzer: [%s] - %s',
    debug_textui_noname = '[E] drücken, um die Entität zu löschen\n  Hash: %s\n  Koordinaten: vec3(%s, %s, %s)\n  Blickrichtung: %s\n  Besitzer: UNBEKANNT',

    textui_invisible = 'Unsichtbarkeit - Aktiviert',
    textui_godmode = 'Gottmodus - Aktiviert',
    textui_wallhack = 'Wallhack - Aktiviert',
    textui_noclip_activated = 'No Clip - Aktiviert',
    textui_torque = 'Drehmoment-Multiplikator - %s',

    -- ── Ankündigungen ───────────────────────────────────────
    dialog_announce = 'Ankündigung',
    dialog_announce_label = 'Nachricht',
    dialog_announce_select = 'Alle',
    dialog_announce_everyone = 'Alle',
    dialog_announce_placeholder = 'Wichtige Nachricht hier. . .',

    -- ── Entbannen ───────────────────────────────────────────
    dialog_unban = 'Bist du sicher?',
    dialog_unban_content = 'Willst du %s wirklich entbannen?',

    -- ── Entitäten löschen ───────────────────────────────────
    dialog_objects = 'Wähle eine Option',
    dialog_clear_objects = 'ALLE Objekte löschen',
    dialog_clear_cars = 'ALLE Fahrzeuge löschen (ohne Fahrer)',
    dialog_clear_peds = 'ALLE Peds löschen',

    -- ── Geld geben ──────────────────────────────────────────
    dialog_givemoney = 'Geld geben',
    givemoney_input_label = 'Betrag',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Konto',
    givemoney_select_option1 = 'Bargeld',
    givemoney_select_option2 = 'Bank',
    givemoney_select_option3 = 'Schwarzgeld',

    -- ── Item geben ──────────────────────────────────────────
    dialog_giveitem = 'Item geben',
    giveitem_input_label = 'Item-Name',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Menge',
    giveitem_amount_input_placeholder = '3',

    -- ── Fahrzeug spawnen ────────────────────────────────────
    dialog_spawn_a_car = 'Fahrzeug spawnen',
    dialog_car_model = 'Modellname',
    dialog_car_model_holder = 'Z. B.: 20charger',
    dialog_car_plate = 'Kennzeichen (optional)',
    dialog_car_plate_holder = 'Z. B.: W4S4B1',
    dialog_car_color_primary = 'Primärfarbe (optional)',
    dialog_car_color_second = 'Sekundärfarbe (optional)',
    dialog_car_maxed = 'Maximale Tuningstufe (optional)',

    -- ── Kicken ──────────────────────────────────────────────
    dialog_kick = '%s kicken',
    dialog_kick_reason = 'Grund',
    dialog_kick_placeholder = 'Cheater',
    kicked_reason_replace = 'Du wurdest vom Server gekickt!',

    -- ── Bannen ──────────────────────────────────────────────
    dialog_ban = '%s bannen',
    dialog_ban_reason = 'Grund',
    dialog_ban_placeholder = 'Cheater',
    ban_reason_replace = 'Du wurdest von diesem Server gebannt!',

    -- ── Zone erstellen ──────────────────────────────────────
    dialog_zone_create = 'Zonenerstellung',
    dialog_zone_name = 'Name',
    dialog_zone_name_desc = 'Der Name der Zone / des Blips',
    dialog_zone_name_holder = 'Admin-Zone',
    dialog_zone_text = 'Angezeigter Text',
    dialog_zone_text_desc = 'Der Text, der Spielern in der Zone angezeigt wird',
    dialog_zone_text_holder = 'ADMIN-ZONE - AKTIV',
    dialog_zone_size = 'Größe',
    dialog_zone_speed = 'Tempolimit',
    mph = 'MPH',
    kmh = 'KM/H',
    dialog_zone_blip_id = 'Blip-ID',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'Farb-ID',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Blinkender Blip',
    dialog_zone_disarm = 'Entwaffnen',
    dialog_zone_revive = 'Wiederbeleben',
    dialog_zone_invincible = 'Unverwundbar',
    dialog_zone_edit = '„%s" wird bearbeitet',
    dialog_zone_delete_confirm = 'Bist du sicher?',
    dialog_zone_delete_confirm_desc = 'Willst du die Zone wirklich löschen: %s',

    -- ── Benachrichtigungen: Geld ────────────────────────────
    notify_givemoney_success = 'Geld gutgeschrieben',
    notify_givemoney_success_desc = 'Du hast %s $%s auf das Konto gutgeschrieben: %s',
    notify_givemoney_fail = 'Fehlgeschlagen',
    notify_givemoney_fail_desc = 'Du wolltest %s gutschreiben, aber etwas ist schiefgelaufen! Bitte erneut versuchen.',

    -- ── Benachrichtigungen: Items ───────────────────────────
    notify_giveitem_success = 'Item gegeben',
    notify_giveitem_success_desc = 'Du hast %s gutgeschrieben. Item: %s Menge: %s',
    notify_giveitem_fail = 'Fehlgeschlagen',
    notify_giveitem_fail_desc = 'Du wolltest %s gutschreiben, aber etwas ist schiefgelaufen! Bitte erneut versuchen.',

    -- ── Benachrichtigungen: Kick / Bann ─────────────────────
    notify_kicked_success = 'Kick erfolgreich',
    notify_kicked_success_desc = 'Du hast %s erfolgreich gekickt',
    notify_banned_success = 'Bann erfolgreich',
    notify_banned_success_desc = 'Du hast %s erfolgreich gebannt',

    -- ── Benachrichtigungen: Inventar ────────────────────────
    notify_clearedinv = 'Inventar geleert',
    notify_clearedinv_desc = 'Du hast das Inventar von %s erfolgreich geleert',

    -- ── Benachrichtigungen: ungültige ID ────────────────────
    notify_invalidid = 'Ungültige ID',
    notify_invalidid_desc = 'Die eingegebene ID ist ungültig, bitte erneut versuchen.',

    -- ── Benachrichtigungen: Aufräumen ───────────────────────
    notify_deleted_car = 'Fahrzeuge gelöscht',
    notify_deleted_car_desc = 'Du hast alle Fahrzeuge ohne Fahrer erfolgreich gelöscht.',
    notify_deleted_ped = 'Peds gelöscht',
    notify_deleted_ped_desc = 'Du hast alle Peds auf der Map erfolgreich gelöscht',
    notify_deleted_objects = 'Objekte gelöscht',
    notify_deleted_objects_desc = 'Du hast alle Objekte auf der Map erfolgreich gelöscht',

    -- ── Benachrichtigungen: Wetter ──────────────────────────
    notify_weather = 'Wetter geändert',
    notify_weather_desc = 'Wetter geändert auf: %s',

    -- ── Benachrichtigungen: Koordinaten kopieren ────────────
    notify_copied = 'Kopiert',
    notify_copied_vec3 = 'Vector3 erfolgreich in die Zwischenablage kopiert!',
    notify_copied_vec4 = 'Vector4 erfolgreich in die Zwischenablage kopiert!',
    notify_copied_headin = 'Blickrichtung erfolgreich in die Zwischenablage kopiert!',

    -- ── Benachrichtigungen: Türen ───────────────────────────
    notify_locked_doors = 'Verriegelt',
    notify_locked_doors_desc = 'Fahrzeugtüren erfolgreich verriegelt.',
    notify_unlocked_doors = 'Entriegelt',
    notify_unlocked_doors_desc = 'Fahrzeugtüren erfolgreich entriegelt.',

    -- ── Benachrichtigungen: Admin-Zonen ─────────────────────
    notify_zone_deleted = 'Zone gelöscht',
    notify_zone_deleted_desc = 'Du hast die Zone erfolgreich entfernt: %s.',
    notify_zone_not_deleted_desc = 'Beim Löschen der Zone ist ein Fehler aufgetreten: %s.',
    notify_zone_edited = 'Zone geändert',
    notify_zone_edited_desc = 'Du hast die Zone erfolgreich geändert: %s.',
    notify_zone_not_edited_desc = 'Beim Ändern der Zone ist ein Fehler aufgetreten: %s.',
    notify_zone_action_cancelled = 'Aktion abgebrochen',
    notify_zone_delete_cancel = 'Du hast das Löschen der Zone abgebrochen: %s',
    notify_zone_no_weapons = 'Waffen nicht erlaubt',
    notify_zone_no_weapons_desc = 'Du darfst in dieser Zone keine Waffen benutzen.',
    notify_zones_not_found = 'Keine Zonen gefunden',
    notify_zones_not_found_desc = 'Es gibt derzeit keine aktiven Zonen zu verwalten.',
    notify_zones_teleport = 'Teleportiert',
    notify_zones_teleport_desc = 'Du wurdest erfolgreich zur Zone teleportiert: %s.',

    -- ── Benachrichtigungen: Entbannen ───────────────────────
    successfully_unbanned = 'Bann aufgehoben',
    successfully_unbanned_desc = 'Du hast %s erfolgreich entbannt.',
    unsuccessful_unban = 'Beim Entbannen ist etwas schiefgelaufen: %s.',

    -- ── Verbindung (Deferrals) ──────────────────────────────
    deferral_welcome = '[%s] Hallo %s, Banns werden geprüft. . .',
    deferral_banned = 'Du bist von diesem Server gebannt. Grund: „%s" (Verbleibend: %s Stunden %s Minuten).',
    deferral_banned_perm = 'Du bist von diesem Server gebannt. Grund: „%s" (Verbleibend: Permanent).',

    -- ── Fehler ──────────────────────────────────────────────
    notify_error = 'Fehler',
    notify_disabled_keys = 'Es ist kein Fahrzeugschlüssel-Skript konfiguriert. Bitte wende dich an den Serverentwickler.',
    notify_no_appearance = 'Kein Kleidungs-/Aussehen-Skript erkannt. Bitte wende dich an den Serverentwickler.',
    notify_no_vehicle = 'Kein Fahrzeug gefunden!',
    notify_invalid_entry = 'Ungültige Eingabe!',

    -- ── Tastenbelegung ──────────────────────────────────────
    keymapping_desc = 'Admin-Menü öffnen (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip aktiviert',
    noclip_deactivated = 'NoClip deaktiviert',

    -- ── Unsichtbarkeit ──────────────────────────────────────
    invisibility_activated = 'Unsichtbarkeit aktiviert',
    invisibility_deactivated = 'Unsichtbarkeit deaktiviert',

    -- ── Gottmodus ───────────────────────────────────────────
    godmode_activated = 'Gottmodus aktiviert',
    godmode_deactivated = 'Gottmodus deaktiviert',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack aktiviert',
    wallhack_deactivated = 'Wallhack deaktiviert',

    -- ── Debug-Modus ─────────────────────────────────────────
    debug_activated = 'Debug-Modus aktiviert',
    debug_deactivated = 'Debug-Modus deaktiviert',

    -- ── Benachrichtigungen: Fahrzeuge ───────────────────────
    vehicle_repaired = 'Fahrzeug repariert',
    vehicle_repaired_desc = 'Das Fahrzeug wurde erfolgreich repariert.',
    vehicle_deleted = 'Fahrzeug gelöscht',
    vehicle_deleted_desc = 'Das Fahrzeug wurde erfolgreich gelöscht.',
    vehicle_spawned = 'Fahrzeug gespawnt',
    vehicle_spawned_desc = 'Fahrzeug %s wurde erfolgreich gespawnt.',
    vehicle_plate_changed = 'Kennzeichen geändert',
    vehicle_plate_changed_desc = 'Kennzeichen geändert auf: %s',
    vehicle_refueled = 'Fahrzeug betankt',
    vehicle_refueled_desc = 'Das Fahrzeug wurde erfolgreich betankt.',
    vehicle_keys_given = 'Schlüssel erhalten',
    vehicle_keys_given_desc = 'Du hast die Schlüssel für das Fahrzeug mit dem Kennzeichen erhalten: %s',
    vehicle_color_changed = 'Fahrzeugfarbe geändert',
    vehicle_color_changed_desc = 'Fahrzeugfarbe geändert auf: %s',
    vehicle_torque_set = 'Drehmoment-Multiplikator gesetzt',
    vehicle_torque_set_desc = 'Drehmoment gesetzt auf: %sx',
    vehicle_torque_disabled = 'Drehmoment-Multiplikator deaktiviert',

    -- ── Zuschauen ───────────────────────────────────────────
    spectate_started = 'Zuschauen',
    spectate_started_desc = 'Du schaust %s zu. X drücken zum Beenden.',
    spectate_ended = 'Zuschauen beendet',
    spectate_ended_desc = 'Du schaust niemandem mehr zu.',
    spectate_error = 'Fehler beim Zuschauen',
    spectate_error_desc = 'Zielspieler nicht gefunden oder nicht mehr vorhanden.',

    -- ── Teleport ────────────────────────────────────────────
    teleport_success = 'Teleportiert',
    teleport_success_desc = 'Du wurdest erfolgreich teleportiert.',

    -- ── Wiederbeleben / Heilen ──────────────────────────────
    player_revived = 'Spieler wiederbelebt',
    player_revived_desc = 'Du hast %s erfolgreich wiederbelebt.',
    player_healed = 'Spieler geheilt',
    player_healed_desc = 'Du hast %s erfolgreich geheilt.',
    self_revived = 'Wiederbelebt',
    self_revived_desc = 'Du hast dich selbst wiederbelebt.',
    self_healed = 'Geheilt',
    self_healed_desc = 'Du hast dich selbst geheilt.',

    -- ── Peds ────────────────────────────────────────────────
    ped_changed = 'Ped gewechselt',
    ped_changed_desc = 'Dein Ped-Modell wurde gewechselt.',
    ped_restored = 'Ped zurückgesetzt',
    ped_restored_desc = 'Dein ursprüngliches Ped-Modell wurde wiederhergestellt.',

    skin_menu_opened = 'Kleidungsmenü geöffnet',

    admin_menu_opened = 'Admin-Menü geöffnet',
    admin_menu_closed = 'Admin-Menü geschlossen',

    entity_deleted = 'Entität gelöscht',
    entity_deleted_desc = 'Die Entität wurde erfolgreich gelöscht.',

    player_frozen = 'Spieler eingefroren',
    player_frozen_desc = 'Spieler %s wurde eingefroren.',
    player_unfrozen = 'Spieler aufgetaut',
    player_unfrozen_desc = 'Spieler %s wurde aufgetaut.',

    -- ── Eigenes Kennzeichen ─────────────────────────────────
    dialog_license_plate = 'Eigenes Kennzeichen',
    dialog_license_plate_label = 'Kennzeichen',
    dialog_license_plate_placeholder = 'Kennzeichen',

    -- ── Geld abnehmen ───────────────────────────────────────
    player_removemoney = 'Geld abnehmen',
    player_removemoney_desc = 'Dem ausgewählten Spieler Geld abnehmen',
    dialog_removemoney = 'Geld abnehmen',
    removemoney_input_label = 'Betrag',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Konto',
    notify_removemoney_success = 'Geld abgenommen',
    notify_removemoney_success_desc = 'Du hast $%s von %s abgenommen (Konto: %s)',
    notify_removemoney_fail = 'Fehlgeschlagen',
    notify_removemoney_fail_desc = 'Konnte %s kein Geld abnehmen (vielleicht zu wenig Guthaben).',

    -- ── Dimensionen / Routing Buckets ───────────────────────
    self_dimension = 'Meine Dimension setzen',
    self_dimension_desc = 'Dich in einen Routing Bucket verschieben (0 = Hauptwelt)',
    player_dimension = 'Dimension setzen',
    player_dimension_desc = 'Diesen Spieler in einen Routing Bucket verschieben',
    player_dimension_bring = 'In meine Dimension holen',
    player_dimension_bring_desc = 'Diesen Spieler in deine aktuelle Dimension ziehen',
    player_dimension_goto = 'Dimension des Spielers betreten',
    player_dimension_goto_desc = 'Dich in die Dimension dieses Spielers verschieben',
    dialog_dimension = 'Dimension setzen',
    dimension_input_label = 'Dimension (Routing Bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Dimension geändert',
    notify_dimension_self_desc = 'Du bist jetzt in Dimension %s.',
    notify_dimension_player_desc = '%s wurde in Dimension %s verschoben.',
    notify_dimension_join_desc = 'Du hast die Dimension von %s betreten (%s).',
    notify_dimension_fail = 'Dimensionsfehler',
    notify_dimension_fail_desc = 'Die Dimension konnte nicht geändert werden.',

    -- ── In das Fahrzeug teleportieren ───────────────────────
    player_tp_vehicle = 'In das Fahrzeug teleportieren',
    player_tp_vehicle_desc = 'In das Fahrzeug dieses Spielers steigen, um bei der Bergung zu helfen',
    notify_tp_vehicle_fail = 'Kein Fahrzeug',
    notify_tp_vehicle_fail_desc = '%s sitzt in keinem Fahrzeug.',
    notify_tp_vehicle_success = 'Teleportiert',
    notify_tp_vehicle_success_desc = 'Du wurdest in das Fahrzeug von %s gesetzt.',

    -- ── Fahrzeug bergen ─────────────────────────────────────
    recover_car = 'Fahrzeug bergen / umdrehen',
    recover_car_desc = 'Aufrichten und zur nächsten Straße versetzen (Wasser/überschlagen)',
    vehicle_recovered = 'Fahrzeug geborgen',
    vehicle_recovered_desc = 'Das Fahrzeug wurde aufgerichtet und auf die nächste Straße gesetzt.',

    -- ── Fahrzeuge im Besitz ─────────────────────────────────
    player_owned_vehicles = 'Fahrzeuge im Besitz',
    player_owned_vehicles_desc = 'Fahrzeuge dieses Spielers ansehen, hinzufügen oder entfernen',
    owned_vehicles_menu = 'Fahrzeuge im Besitz (%s)',
    owned_vehicles_add = 'Fahrzeug hinzufügen',
    owned_vehicles_add_desc = 'Ein Fahrzeug zur Garage dieses Spielers hinzufügen',
    owned_vehicles_none = 'Keine Fahrzeuge',
    owned_vehicles_none_desc = 'Dieser Spieler besitzt keine Fahrzeuge.',
    owned_vehicle_desc = 'Kennzeichen: %s · zum Entfernen klicken',
    dialog_add_vehicle = 'Fahrzeug hinzufügen',
    add_vehicle_model_label = 'Modellname',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Kennzeichen (optional)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = '%s entfernen?',
    notify_owned_added = 'Fahrzeug hinzugefügt',
    notify_owned_added_desc = '%s (Kennzeichen %s) zu %s hinzugefügt.',
    notify_owned_removed = 'Fahrzeug entfernt',
    notify_owned_removed_desc = 'Kennzeichen %s von %s entfernt.',
    notify_owned_fail = 'Datenbankfehler',
    notify_owned_fail_desc = 'Die Fahrzeug-Datenbankoperation ist fehlgeschlagen.',

    -- ── Ped-Menü ────────────────────────────────────────────
    player_pedmenu = 'Ped-Menü geben',
    player_pedmenu_desc = 'Ein Ped-Auswahlmenü auf dem Bildschirm dieses Spielers öffnen',
    pedmenu_title = 'Ped-Menü',
    pedmenu_given = 'Ped-Menü gesendet',
    pedmenu_given_desc = 'Ped-Menü für %s geöffnet.'
}
