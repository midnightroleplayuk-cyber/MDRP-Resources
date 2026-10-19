-- ============================================================
-- SVENSKA (sv)
-- ------------------------------------------------------------
-- Lager ovanpå configs/strings.lua. Varje nyckel som saknas här
-- behåller den engelska texten, så delvis översättning är säkert.
--
-- Platshållarna %s måste behållas och i SAMMA ordning som i
-- originalet: de fylls i av :format() i koden. %% skriver ut
-- ett bokstavligt procenttecken.
--
-- Aktivering:  Config.Locale = 'sv'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['sv'] = {
    -- ── Huvudmeny ───────────────────────────────────────────
    main_title = 'Adminmeny',
    self_options = 'Egna Alternativ',
    self_options_desc = 'Alternativ som gäller dig själv',
    player_options_title = 'Spelaralternativ',
    player_options_desc = 'Alternativ som gäller andra spelare',
    vehicle_options = 'Fordonsalternativ',
    vehicle_options_desc = 'Alternativ som gäller fordon',
    server_options = 'Serveralternativ',
    server_options_desc = 'Alternativ som gäller servern',
    admin_zone_options = 'Adminzoner',
    admin_zone_options_desc = 'Hantera, lägg till och ta bort adminzoner',
    developer_options = 'Utvecklaralternativ',
    developer_options_desc = '',

    -- ── Egna alternativ ─────────────────────────────────────
    self_options_menu = 'Egna Alternativ',
    self_health = 'Liv (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Återuppliva',
    self_revive_desc = 'Återuppliva dig själv',
    self_heal = 'Läk',
    self_heal_desc = 'Läk dig själv',
    self_skinmenu = 'Klädmeny',
    self_set_ped = 'Byt Ped',
    self_skinmenu_desc = 'Öppna klädmenyn lokalt',
    self_invisible = 'Osynlig',
    self_godmode = 'Gudsläge',
    self_wallhack = 'Wallhack',

    -- ── Spelaralternativ ────────────────────────────────────
    player_options_menu = 'Spelare Online %s/%s',
    player_options = 'Spelare: %s',
    player_health = 'Spelarens Liv (%s%%)',
    player_freeze = 'Frys',
    player_freeze_desc = 'Slå på/av',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Slå på/av',
    player_spectate = 'Åskåda',
    player_spectate_desc = 'Följ den här spelarens handlingar',
    player_playerdata = 'Spelardata',
    player_playerdata_desc = 'Visa spelarens data',
    player_revive = 'Återuppliva',
    player_revive_desc = 'Återuppliva spelaren',
    player_heal = 'Läk',
    player_heal_desc = 'Läk spelaren',
    player_skinmenu = 'Klädmeny',
    player_skinmenu_desc = 'Öppna en klädmeny hos spelaren',
    player_money = 'Ge Pengar',
    player_money_desc = 'Ge pengar till den valda spelaren',
    player_item = 'Ge Föremål',
    player_item_desc = 'Ge ett föremål till den valda spelaren',
    player_openinv = 'Öppna Inventarie',
    player_openinv_desc = 'Öppna spelarens inventarie',
    player_clearinv = 'Töm Inventarie',
    player_clearinv_desc = 'Töm spelarens inventarie',
    player_teleport_to = 'Teleportera till Spelare',
    player_teleport_to_desc = 'Teleportera dig till spelaren',
    player_bring = 'Hämta',
    player_bring_desc = 'Hämta spelaren till din position',
    player_kick = 'Kicka',
    player_kick_desc = 'Kicka spelaren från servern',
    player_ban = 'Banna Spelare',

    -- ── Fordonsmeny ─────────────────────────────────────────
    vehicle_menu = 'Fordonsmeny',
    spawn_car = 'Spawna Fordon',
    spawn_car_desc = 'Spawna ett fordon',
    repair_car = 'Reparera Fordon',
    repair_car_desc = 'Reparera nuvarande eller närmaste fordon',
    delete_car = 'Ta Bort Fordon',
    delete_car_desc = 'Ta bort nuvarande eller närmaste fordon',
    number_plate = 'Ändra Registreringsskylt',
    number_plate_desc = 'Ändra texten på nuvarande registreringsskylt',
    refuel = 'Tanka Fordon',
    refuel_desc = 'Tanka nuvarande eller närmaste fordon',
    give_keys = 'Ge Nycklar',
    give_keys_desc = 'Ge dig själv nycklarna till nuvarande fordon',
    doors = 'Lås/Lås Upp Dörrar',
    doors_desc = 'Växlar låsen på närmaste fordon',
    boost_car = 'Vridmomentsmultiplikator',
    boost_car_desc = 'Ändra vridmomentet på nuvarande fordon',
    color_change = 'Ändra Fordonsfärg',
    color_change_desc = 'Ändra färgen på nuvarande eller närmaste fordon',

    -- ── Serverhantering ─────────────────────────────────────
    server_management = 'Serverhantering',
    server_announcement = 'Servermeddelande',
    server_announcement_desc = 'Skicka ett globalt meddelande till hela servern',
    ban_list = 'Bannlista',
    ban_list_desc = 'Se alla aktiva bannlysningar',
    objects_list = 'Ta Bort Entiteter',
    objects_list_desc = 'Ta bort fordon och peds',
    objects_list_label = 'Alternativ',
    weather_menu = 'Väderhantering',
    weather_menu_desc = 'Hantera vädret',

    -- ── Adminzoner ──────────────────────────────────────────
    zones_create = 'Skapa Zon',
    zones_create_desc = 'Skapa en ny adminzon',
    zones_manage = 'Hantera Zoner',
    zones_manage_desc = 'Redigera eller ta bort aktiva zoner',
    zone_edit_current = 'Redigera Nuvarande Zon',
    zone_edit_current_desc = 'Hantera zonen du befinner dig i',
    zone_delete_current = 'Ta Bort Nuvarande Zon',
    zone_delete_current_desc = 'Ta bort zonen du befinner dig i',
    zone_manage_menu = 'Redigerar Zon (%s)',
    zone_edit = 'Redigera Zon',
    zone_edit_desc = 'Ändra zon: %s',
    zone_delete = 'Ta Bort Zon',
    zone_delete_desc = 'Ta bort zon: %s',
    zone_teleport = 'Teleportera till Zon',
    zone_teleport_desc = 'Gå till zon: %s',

    -- ── Utvecklarmeny ───────────────────────────────────────
    dev_options = 'Utvecklaralternativ',
    debug_mode = 'Felsökningsläge',
    debug_mode_desc = 'Slå på/av felsökningsläget',
    copy_vec3 = 'Kopiera Vector3-koordinater',
    copy_vec3_desc = 'Kopierar din nuvarande position (vector3) till urklipp',
    copy_vec4 = 'Kopiera Vector4-koordinater',
    copy_vec4_desc = 'Kopierar din nuvarande position (vector4) till urklipp',
    copy_heading = 'Kopiera Riktning',
    copy_heading_desc = 'Kopierar din nuvarande riktning till urklipp',
    cant_delete = 'Kan inte tas bort!',
    cant_delete_player_desc = 'Du kan inte ta bort spelares peds!',
    cant_delete_entity_desc = 'Du kan inte ta bort kartans standardobjekt!',

    -- ── Bannlista ───────────────────────────────────────────
    ban_list_menu = 'Bannlista',
    ban_list_name = 'Namn: %s',
    ban_list_license = 'Licens:',
    ban_list_by = 'Utfärdad av: %s',
    ban_list_reason = 'Anledning: %s',
    ban_list_length = 'Tid kvar: %s timmar %s minuter',
    ban_list_modify = 'Ändra Bannlysning',
    ban_list_unban = 'Avbanna Spelare',
    ban_list_no_data = 'Inga Bannlysningar',
    ban_list_no_data_desc = 'Inga aktiva bannlysningar hittades!',

    -- ── Spelardata ──────────────────────────────────────────
    playerdata_menu = 'Spelardata',
    playerdata_license_esx = 'Licens: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Klicka för att kopiera hela licensen',
    playerdata_igname = 'Namn: %s',
    playerdata_igname_desc = 'Spelarens fullständiga namn i spelet',
    playerdata_steam = 'Steam-namn: %s',
    playerdata_steam_desc = 'Spelarens fullständiga Steam-namn',
    playerdata_gender = 'Kön: %s',
    playerdata_gender_desc = 'Spelarens kön',
    playerdata_cash = 'Kontanter: %s',
    playerdata_cash_desc = 'Spelarens kontantsaldo',
    playerdata_bank = 'Bank: %s',
    playerdata_bank_desc = 'Spelarens banksaldo',
    playerdata_blackmoney = 'Svarta Pengar: %s',
    playerdata_blackmoney_desc = 'Spelarens saldo av svarta pengar',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Tryck [E] för att ta bort entiteten  \nHash: %s  \nKoordinater: vec3(%s, %s, %s)  \nRiktning: %s  \nÄgare: [%s] - %s',
    debug_textui_noname = 'Tryck [E] för att ta bort entiteten\n  Hash: %s\n  Koordinater: vec3(%s, %s, %s)\n  Riktning: %s\n  Ägare: OKÄND',

    textui_invisible = 'Osynlighetsläge - Aktivt',
    textui_godmode = 'Gudsläge - Aktivt',
    textui_wallhack = 'Wallhack - Aktivt',
    textui_noclip_activated = 'No Clip - Aktivt',
    textui_torque = 'Vridmomentsmultiplikator - %s',

    -- ── Meddelanden ─────────────────────────────────────────
    dialog_announce = 'Meddelande',
    dialog_announce_label = 'Meddelande',
    dialog_announce_select = 'Alla',
    dialog_announce_everyone = 'Alla',
    dialog_announce_placeholder = 'Viktigt meddelande här. . .',

    -- ── Avbannning ──────────────────────────────────────────
    dialog_unban = 'Är du säker?',
    dialog_unban_content = 'Vill du verkligen avbanna %s?',

    -- ── Ta bort entiteter ───────────────────────────────────
    dialog_objects = 'Välj ett alternativ',
    dialog_clear_objects = 'Ta bort ALLA objekt',
    dialog_clear_cars = 'Ta bort ALLA bilar (utan förare)',
    dialog_clear_peds = 'Ta bort ALLA peds',

    -- ── Ge pengar ───────────────────────────────────────────
    dialog_givemoney = 'Ge Pengar',
    givemoney_input_label = 'Belopp',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Konto',
    givemoney_select_option1 = 'Kontanter',
    givemoney_select_option2 = 'Bank',
    givemoney_select_option3 = 'Svarta Pengar',

    -- ── Ge föremål ──────────────────────────────────────────
    dialog_giveitem = 'Ge Föremål',
    giveitem_input_label = 'Föremålets Namn',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Antal',
    giveitem_amount_input_placeholder = '3',

    -- ── Spawna fordon ───────────────────────────────────────
    dialog_spawn_a_car = 'Spawna Fordon',
    dialog_car_model = 'Modellnamn',
    dialog_car_model_holder = 'T.ex: 20charger',
    dialog_car_plate = 'Registreringsskylt (valfritt)',
    dialog_car_plate_holder = 'T.ex: W4S4B1',
    dialog_car_color_primary = 'Primärfärg (valfritt)',
    dialog_car_color_second = 'Sekundärfärg (valfritt)',
    dialog_car_maxed = 'Maximala Modifieringar (valfritt)',

    -- ── Kicka ───────────────────────────────────────────────
    dialog_kick = 'Kicka %s',
    dialog_kick_reason = 'Anledning',
    dialog_kick_placeholder = 'Fuskare',
    kicked_reason_replace = 'Du har blivit kickad från servern!',

    -- ── Bannlysning ─────────────────────────────────────────
    dialog_ban = 'Banna %s',
    dialog_ban_reason = 'Anledning',
    dialog_ban_placeholder = 'Fuskare',
    ban_reason_replace = 'Du har blivit bannad från den här servern!',

    -- ── Skapa zon ───────────────────────────────────────────
    dialog_zone_create = 'Skapa Zon',
    dialog_zone_name = 'Namn',
    dialog_zone_name_desc = 'Namnet på zonen / blippen',
    dialog_zone_name_holder = 'Adminzon',
    dialog_zone_text = 'Visad Text',
    dialog_zone_text_desc = 'Texten som visas för spelare inne i zonen',
    dialog_zone_text_holder = 'ADMINZON - AKTIV',
    dialog_zone_size = 'Storlek',
    dialog_zone_speed = 'Hastighetsgräns',
    mph = 'MPH',
    kmh = 'KM/H',
    dialog_zone_blip_id = 'Blipp-ID',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'Färg-ID',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Blinkande Blipp',
    dialog_zone_disarm = 'Avväpna',
    dialog_zone_revive = 'Återuppliva',
    dialog_zone_invincible = 'Odödlig',
    dialog_zone_edit = 'Redigerar "%s"',
    dialog_zone_delete_confirm = 'Är du säker?',
    dialog_zone_delete_confirm_desc = 'Vill du verkligen ta bort zonen: %s',

    -- ── Aviseringar: pengar ─────────────────────────────────
    notify_givemoney_success = 'Pengar Givna',
    -- Argumentordningen måste följa engelskan: spelare, belopp, konto.
    notify_givemoney_success_desc = 'Du krediterade %s med $%s på kontot: %s',
    notify_givemoney_fail = 'Misslyckades',
    notify_givemoney_fail_desc = 'Du försökte sätta in till %s men något gick fel! Försök igen.',

    -- ── Aviseringar: föremål ────────────────────────────────
    notify_giveitem_success = 'Föremål Givet',
    notify_giveitem_success_desc = 'Du gav till %s. Föremål: %s Antal: %s',
    notify_giveitem_fail = 'Misslyckades',
    notify_giveitem_fail_desc = 'Du försökte ge till %s men något gick fel! Försök igen.',

    -- ── Aviseringar: kick / ban ─────────────────────────────
    notify_kicked_success = 'Kick Lyckades',
    notify_kicked_success_desc = 'Du kickade %s',
    notify_banned_success = 'Bannlysning Lyckades',
    notify_banned_success_desc = 'Du bannade %s',

    -- ── Aviseringar: inventarie ─────────────────────────────
    notify_clearedinv = 'Inventarie Tömd',
    notify_clearedinv_desc = 'Du tömde inventariet för %s',

    -- ── Aviseringar: ogiltigt ID ────────────────────────────
    notify_invalidid = 'Ogiltigt ID',
    notify_invalidid_desc = 'ID:t du angav var ogiltigt, försök igen.',

    -- ── Aviseringar: städning ───────────────────────────────
    notify_deleted_car = 'Bilar Borttagna',
    notify_deleted_car_desc = 'Du tog bort alla bilar utan förare.',
    notify_deleted_ped = 'Peds Borttagna',
    notify_deleted_ped_desc = 'Du tog bort alla peds på kartan',
    notify_deleted_objects = 'Objekt Borttagna',
    notify_deleted_objects_desc = 'Du tog bort alla objekt på kartan',

    -- ── Aviseringar: väder ──────────────────────────────────
    notify_weather = 'Väder Ändrat',
    notify_weather_desc = 'Vädret ändrat till: %s',

    -- ── Aviseringar: kopiera koordinater ────────────────────
    notify_copied = 'Kopierat',
    notify_copied_vec3 = 'Vector3 kopierades till urklipp!',
    notify_copied_vec4 = 'Vector4 kopierades till urklipp!',
    notify_copied_headin = 'Riktningen kopierades till urklipp!',

    -- ── Aviseringar: dörrar ─────────────────────────────────
    notify_locked_doors = 'Låst',
    notify_locked_doors_desc = 'Fordonets dörrar låstes.',
    notify_unlocked_doors = 'Upplåst',
    notify_unlocked_doors_desc = 'Fordonets dörrar låstes upp.',

    -- ── Aviseringar: adminzoner ─────────────────────────────
    notify_zone_deleted = 'Zon Borttagen',
    notify_zone_deleted_desc = 'Du tog bort zonen: %s.',
    notify_zone_not_deleted_desc = 'Ett fel uppstod vid borttagning av zonen: %s.',
    notify_zone_edited = 'Zon Ändrad',
    notify_zone_edited_desc = 'Du ändrade zonen: %s.',
    notify_zone_not_edited_desc = 'Ett fel uppstod vid ändring av zonen: %s.',
    notify_zone_action_cancelled = 'Åtgärd Avbruten',
    notify_zone_delete_cancel = 'Du avbröt borttagningen av zonen: %s',
    notify_zone_no_weapons = 'Vapen Ej Tillåtna',
    notify_zone_no_weapons_desc = 'Du får inte använda vapen inne i den här zonen.',
    notify_zones_not_found = 'Inga Zoner',
    notify_zones_not_found_desc = 'Det finns för närvarande inga aktiva zoner att hantera.',
    notify_zones_teleport = 'Teleporterad',
    notify_zones_teleport_desc = 'Du teleporterades till zonen: %s.',

    -- ── Aviseringar: avbannning ─────────────────────────────
    successfully_unbanned = 'Bannlysning Upphävd',
    successfully_unbanned_desc = 'Du avbannade: %s.',
    unsuccessful_unban = 'Något gick fel vid avbannning av: %s.',

    -- ── Anslutning (deferrals) ──────────────────────────────
    deferral_welcome = '[%s] Hej %s, kontrollerar bannlysningar. . .',
    deferral_banned = 'Du är bannad från servern. Anledning: "%s" (Tid kvar: %s timmar %s minuter).',
    deferral_banned_perm = 'Du är bannad från servern. Anledning: "%s" (Tid kvar: Permanent).',

    -- ── Fel ─────────────────────────────────────────────────
    notify_error = 'Fel',
    notify_disabled_keys = 'Inget skript för fordonsnycklar är konfigurerat. Kontakta serverutvecklaren.',
    notify_no_appearance = 'Inget kläd-/utseendeskript hittades. Kontakta serverutvecklaren.',
    notify_no_vehicle = 'Inget fordon hittades!',
    notify_invalid_entry = 'Ogiltig inmatning!',

    -- ── Tangentbindning ─────────────────────────────────────
    keymapping_desc = 'Öppna Adminmenyn (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Aktiverat',
    noclip_deactivated = 'NoClip Avaktiverat',

    -- ── Osynlighet ──────────────────────────────────────────
    invisibility_activated = 'Osynlighetsläge Aktiverat',
    invisibility_deactivated = 'Osynlighetsläge Avaktiverat',

    -- ── Gudsläge ────────────────────────────────────────────
    godmode_activated = 'Gudsläge Aktiverat',
    godmode_deactivated = 'Gudsläge Avaktiverat',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Aktiverat',
    wallhack_deactivated = 'Wallhack Avaktiverat',

    -- ── Felsökningsläge ─────────────────────────────────────
    debug_activated = 'Felsökningsläge Aktiverat',
    debug_deactivated = 'Felsökningsläge Avaktiverat',

    -- ── Aviseringar: fordon ─────────────────────────────────
    vehicle_repaired = 'Fordon Reparerat',
    vehicle_repaired_desc = 'Fordonet har reparerats.',
    vehicle_deleted = 'Fordon Borttaget',
    vehicle_deleted_desc = 'Fordonet har tagits bort.',
    vehicle_spawned = 'Fordon Spawnat',
    vehicle_spawned_desc = 'Fordonet %s har spawnats.',
    vehicle_plate_changed = 'Registreringsskylt Ändrad',
    vehicle_plate_changed_desc = 'Fordonets registreringsskylt ändrad till: %s',
    vehicle_refueled = 'Fordon Tankat',
    vehicle_refueled_desc = 'Fordonet har tankats.',
    vehicle_keys_given = 'Nycklar Mottagna',
    vehicle_keys_given_desc = 'Du har fått nycklarna till fordonet med skylten: %s',
    vehicle_color_changed = 'Fordonsfärg Ändrad',
    vehicle_color_changed_desc = 'Fordonets färg ändrad till: %s',
    vehicle_torque_set = 'Vridmomentsmultiplikator Satt',
    vehicle_torque_set_desc = 'Vridmoment satt till: %sx',
    vehicle_torque_disabled = 'Vridmomentsmultiplikator Avstängd',

    -- ── Åskådning ───────────────────────────────────────────
    spectate_started = 'Åskådar',
    spectate_started_desc = 'Du åskådar %s. Tryck X för att sluta.',
    spectate_ended = 'Åskådning Avslutad',
    spectate_ended_desc = 'Du åskådar inte längre någon.',
    spectate_error = 'Åskådningsfel',
    spectate_error_desc = 'Målspelaren hittades inte eller finns inte längre.',

    -- ── Teleportering ───────────────────────────────────────
    teleport_success = 'Teleporterad',
    teleport_success_desc = 'Du har teleporterats.',

    -- ── Återuppliva / läka ──────────────────────────────────
    player_revived = 'Spelare Återupplivad',
    player_revived_desc = 'Du återupplivade %s.',
    player_healed = 'Spelare Läkt',
    player_healed_desc = 'Du läkte %s.',
    self_revived = 'Återupplivad',
    self_revived_desc = 'Du återupplivade dig själv.',
    self_healed = 'Läkt',
    self_healed_desc = 'Du läkte dig själv.',

    -- ── Peds ────────────────────────────────────────────────
    ped_changed = 'Ped Bytt',
    ped_changed_desc = 'Din ped-modell har bytts.',
    ped_restored = 'Ped Återställd',
    ped_restored_desc = 'Din ursprungliga ped-modell har återställts.',

    skin_menu_opened = 'Klädmeny Öppnad',

    admin_menu_opened = 'Adminmeny Öppnad',
    admin_menu_closed = 'Adminmeny Stängd',

    entity_deleted = 'Entitet Borttagen',
    entity_deleted_desc = 'Entiteten har tagits bort.',

    player_frozen = 'Spelare Frusen',
    player_frozen_desc = 'Spelaren %s har frusits.',
    player_unfrozen = 'Spelare Upptinad',
    player_unfrozen_desc = 'Spelaren %s har tinats upp.',

    -- ── Egen registreringsskylt ─────────────────────────────
    dialog_license_plate = 'Egen Registreringsskylt',
    dialog_license_plate_label = 'Skylt',
    dialog_license_plate_placeholder = 'Registreringsskylt',

    -- ── Ta pengar ───────────────────────────────────────────
    player_removemoney = 'Ta Pengar',
    player_removemoney_desc = 'Ta pengar från den valda spelaren',
    dialog_removemoney = 'Ta Pengar',
    removemoney_input_label = 'Belopp',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Konto',
    notify_removemoney_success = 'Pengar Borttagna',
    notify_removemoney_success_desc = 'Du tog $%s från %s (konto: %s)',
    notify_removemoney_fail = 'Misslyckades',
    notify_removemoney_fail_desc = 'Kunde inte ta pengar från %s (kanske otillräckligt saldo).',

    -- ── Dimensioner / routing buckets ───────────────────────
    self_dimension = 'Sätt Min Dimension',
    self_dimension_desc = 'Flytta dig till en routing bucket (0 = huvudvärlden)',
    player_dimension = 'Sätt Dimension',
    player_dimension_desc = 'Flytta den här spelaren till en routing bucket',
    player_dimension_bring = 'Hämta till Min Dimension',
    player_dimension_bring_desc = 'Dra in den här spelaren i din nuvarande dimension',
    player_dimension_goto = 'Gå med i Spelarens Dimension',
    player_dimension_goto_desc = 'Flytta dig till den här spelarens dimension',
    dialog_dimension = 'Sätt Dimension',
    dimension_input_label = 'Dimension (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Dimension Ändrad',
    notify_dimension_self_desc = 'Du är nu i dimension %s.',
    notify_dimension_player_desc = '%s flyttades till dimension %s.',
    notify_dimension_join_desc = 'Du gick med i %s dimension (%s).',
    notify_dimension_fail = 'Dimensionsfel',
    notify_dimension_fail_desc = 'Kunde inte byta dimension.',

    -- ── Teleportera in i fordonet ───────────────────────────
    player_tp_vehicle = 'Teleportera in i Fordonet',
    player_tp_vehicle_desc = 'Hoppa in i den här spelarens fordon för att hjälpa till att bärga det',
    notify_tp_vehicle_fail = 'Inget Fordon',
    notify_tp_vehicle_fail_desc = '%s sitter inte i ett fordon.',
    notify_tp_vehicle_success = 'Teleporterad',
    notify_tp_vehicle_success_desc = 'Du placerades i %s fordon.',

    -- ── Bärga fordon ────────────────────────────────────────
    recover_car = 'Bärga / Vända Fordon',
    recover_car_desc = 'Vänd rätt och flytta till närmaste väg (vatten/vält)',
    vehicle_recovered = 'Fordon Bärgat',
    vehicle_recovered_desc = 'Fordonet vändes rätt och placerades på närmaste väg.',

    -- ── Ägda fordon ─────────────────────────────────────────
    player_owned_vehicles = 'Ägda Fordon',
    player_owned_vehicles_desc = 'Visa, lägg till eller ta bort den här spelarens bilar',
    owned_vehicles_menu = 'Ägda Fordon (%s)',
    owned_vehicles_add = 'Lägg Till Fordon',
    owned_vehicles_add_desc = 'Lägg till ett fordon i den här spelarens garage',
    owned_vehicles_none = 'Inga Fordon',
    owned_vehicles_none_desc = 'Den här spelaren äger inga fordon.',
    owned_vehicle_desc = 'Skylt: %s · klicka för att ta bort',
    dialog_add_vehicle = 'Lägg Till Fordon',
    add_vehicle_model_label = 'Modellnamn',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Registreringsskylt (valfritt)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = 'Ta bort %s?',
    notify_owned_added = 'Fordon Tillagt',
    notify_owned_added_desc = 'La till %s (skylt %s) hos %s.',
    notify_owned_removed = 'Fordon Borttaget',
    notify_owned_removed_desc = 'Tog bort skylten %s från %s.',
    notify_owned_fail = 'Databasfel',
    notify_owned_fail_desc = 'Databasoperationen för fordon misslyckades.',

    -- ── Ped-meny ────────────────────────────────────────────
    player_pedmenu = 'Ge Ped-meny',
    player_pedmenu_desc = 'Öppna en ped-valsmeny på den här spelarens skärm',
    pedmenu_title = 'Ped-meny',
    pedmenu_given = 'Ped-meny Skickad',
    pedmenu_given_desc = 'Ped-meny öppnad för %s.'
}
