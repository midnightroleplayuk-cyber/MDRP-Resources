-- ============================================================
-- NEDERLANDS (nl)
-- ------------------------------------------------------------
-- Overlay op configs/strings.lua. Elke sleutel die hier ontbreekt
-- houdt automatisch de Engelse tekst, dus gedeeltelijk vertalen
-- is veilig.
--
-- De %s-plaatshouders moeten behouden blijven en in DEZELFDE
-- volgorde staan als in het origineel: ze worden in de code door
-- :format() ingevuld. %% toont een letterlijk procentteken.
--
-- Activeren:  Config.Locale = 'nl'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['nl'] = {
    -- ── Hoofdmenu ───────────────────────────────────────────
    main_title = 'Adminmenu',
    self_options = 'Eigen Opties',
    self_options_desc = 'Opties over jezelf',
    player_options_title = 'Spelersopties',
    player_options_desc = 'Opties over andere spelers',
    vehicle_options = 'Voertuigopties',
    vehicle_options_desc = 'Opties over voertuigen',
    server_options = 'Serveropties',
    server_options_desc = 'Opties over de server',
    admin_zone_options = 'Adminzones',
    admin_zone_options_desc = 'Adminzones beheren, toevoegen en verwijderen',
    developer_options = 'Ontwikkelaarsopties',
    developer_options_desc = '',

    -- ── Eigen opties ────────────────────────────────────────
    self_options_menu = 'Eigen Opties',
    self_health = 'Leven (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Reanimeren',
    self_revive_desc = 'Jezelf reanimeren',
    self_heal = 'Genezen',
    self_heal_desc = 'Jezelf genezen',
    self_skinmenu = 'Kledingmenu',
    self_set_ped = 'Ped Wisselen',
    self_skinmenu_desc = 'Het kledingmenu lokaal openen',
    self_invisible = 'Onzichtbaar',
    self_godmode = 'Godmodus',
    self_wallhack = 'Wallhack',

    -- ── Spelersopties ───────────────────────────────────────
    player_options_menu = 'Spelers Online %s/%s',
    player_options = 'Speler: %s',
    player_health = 'Leven van Speler (%s%%)',
    player_freeze = 'Bevriezen',
    player_freeze_desc = 'Aan/uit zetten',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Aan/uit zetten',
    player_spectate = 'Toekijken',
    player_spectate_desc = 'De acties van deze speler bekijken',
    player_playerdata = 'Spelersgegevens',
    player_playerdata_desc = 'De gegevens van de speler bekijken',
    player_revive = 'Reanimeren',
    player_revive_desc = 'De speler reanimeren',
    player_heal = 'Genezen',
    player_heal_desc = 'De speler genezen',
    player_skinmenu = 'Kledingmenu',
    player_skinmenu_desc = 'Een kledingmenu bij de speler openen',
    player_money = 'Geld Geven',
    player_money_desc = 'De geselecteerde speler geld geven',
    player_item = 'Item Geven',
    player_item_desc = 'De geselecteerde speler een item geven',
    player_openinv = 'Inventaris Openen',
    player_openinv_desc = 'De inventaris van de speler openen',
    player_clearinv = 'Inventaris Legen',
    player_clearinv_desc = 'De inventaris van de speler legen',
    player_teleport_to = 'Naar Speler Teleporteren',
    player_teleport_to_desc = 'Jezelf naar de speler teleporteren',
    player_bring = 'Halen',
    player_bring_desc = 'De speler naar jouw positie halen',
    player_kick = 'Kicken',
    player_kick_desc = 'De speler van de server kicken',
    player_ban = 'Speler Bannen',

    -- ── Voertuigmenu ────────────────────────────────────────
    vehicle_menu = 'Voertuigmenu',
    spawn_car = 'Voertuig Spawnen',
    spawn_car_desc = 'Een voertuig spawnen',
    repair_car = 'Voertuig Repareren',
    repair_car_desc = 'Het huidige of dichtstbijzijnde voertuig repareren',
    delete_car = 'Voertuig Verwijderen',
    delete_car_desc = 'Het huidige of dichtstbijzijnde voertuig verwijderen',
    number_plate = 'Kenteken Wijzigen',
    number_plate_desc = 'De tekst van het huidige kenteken wijzigen',
    refuel = 'Voertuig Tanken',
    refuel_desc = 'Het huidige of dichtstbijzijnde voertuig tanken',
    give_keys = 'Sleutels Geven',
    give_keys_desc = 'Jezelf de sleutels van het huidige voertuig geven',
    doors = 'Deuren Ver-/Ontgrendelen',
    doors_desc = 'Schakelt het slot van het dichtstbijzijnde voertuig om',
    boost_car = 'Koppelvermenigvuldiger',
    boost_car_desc = 'Het koppel van het huidige voertuig aanpassen',
    color_change = 'Voertuigkleur Wijzigen',
    color_change_desc = 'De kleur van het huidige of dichtstbijzijnde voertuig wijzigen',

    -- ── Serverbeheer ────────────────────────────────────────
    server_management = 'Serverbeheer',
    server_announcement = 'Serveraankondiging',
    server_announcement_desc = 'Een globale aankondiging naar de hele server sturen',
    ban_list = 'Banlijst',
    ban_list_desc = 'Alle actieve bans bekijken',
    objects_list = 'Entiteiten Verwijderen',
    objects_list_desc = 'Voertuigen en peds verwijderen',
    objects_list_label = 'Opties',
    weather_menu = 'Weerbeheer',
    weather_menu_desc = 'Het weer beheren',

    -- ── Adminzones ──────────────────────────────────────────
    zones_create = 'Zone Aanmaken',
    zones_create_desc = 'Een nieuwe adminzone aanmaken',
    zones_manage = 'Zones Beheren',
    zones_manage_desc = 'Actieve zones bewerken of verwijderen',
    zone_edit_current = 'Huidige Zone Bewerken',
    zone_edit_current_desc = 'De zone beheren waarin je je bevindt',
    zone_delete_current = 'Huidige Zone Verwijderen',
    zone_delete_current_desc = 'De zone verwijderen waarin je je bevindt',
    zone_manage_menu = 'Zone Bewerken (%s)',
    zone_edit = 'Zone Bewerken',
    zone_edit_desc = 'Zone aanpassen: %s',
    zone_delete = 'Zone Verwijderen',
    zone_delete_desc = 'Zone verwijderen: %s',
    zone_teleport = 'Naar Zone Teleporteren',
    zone_teleport_desc = 'Ga naar zone: %s',

    -- ── Ontwikkelaarsmenu ───────────────────────────────────
    dev_options = 'Ontwikkelaarsopties',
    debug_mode = 'Debugmodus',
    debug_mode_desc = 'Debugmodus aan/uit zetten',
    copy_vec3 = 'Vector3-coördinaten Kopiëren',
    copy_vec3_desc = 'Kopieert je huidige positie (vector3) naar het klembord',
    copy_vec4 = 'Vector4-coördinaten Kopiëren',
    copy_vec4_desc = 'Kopieert je huidige positie (vector4) naar het klembord',
    copy_heading = 'Kijkrichting Kopiëren',
    copy_heading_desc = 'Kopieert je huidige kijkrichting naar het klembord',
    cant_delete = 'Verwijderen niet mogelijk!',
    cant_delete_player_desc = 'Je kunt geen peds van spelers verwijderen!',
    cant_delete_entity_desc = 'Je kunt geen standaardobjecten van de map verwijderen!',

    -- ── Banlijst ────────────────────────────────────────────
    ban_list_menu = 'Banlijst',
    ban_list_name = 'Naam: %s',
    ban_list_license = 'Licentie:',
    ban_list_by = 'Uitgegeven door: %s',
    ban_list_reason = 'Reden: %s',
    ban_list_length = 'Resterend: %s uur %s minuten',
    ban_list_modify = 'Ban Aanpassen',
    ban_list_unban = 'Speler Ontbannen',
    ban_list_no_data = 'Geen Bans',
    ban_list_no_data_desc = 'Er zijn geen actieve bans gevonden!',

    -- ── Spelersgegevens ─────────────────────────────────────
    playerdata_menu = 'Spelersgegevens',
    playerdata_license_esx = 'Licentie: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Klik om de volledige licentie te kopiëren',
    playerdata_igname = 'Naam: %s',
    playerdata_igname_desc = 'Volledige naam van de speler in het spel',
    playerdata_steam = 'Steamnaam: %s',
    playerdata_steam_desc = 'Volledige Steamnaam van de speler',
    playerdata_gender = 'Geslacht: %s',
    playerdata_gender_desc = 'Geslacht van de speler',
    playerdata_cash = 'Contant: %s',
    playerdata_cash_desc = 'Contant saldo van de speler',
    playerdata_bank = 'Bank: %s',
    playerdata_bank_desc = 'Banksaldo van de speler',
    playerdata_blackmoney = 'Zwart Geld: %s',
    playerdata_blackmoney_desc = 'Zwartgeldsaldo van de speler',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Druk op [E] om de entiteit te verwijderen  \nHash: %s  \nCoördinaten: vec3(%s, %s, %s)  \nKijkrichting: %s  \nEigenaar: [%s] - %s',
    debug_textui_noname = 'Druk op [E] om de entiteit te verwijderen\n  Hash: %s\n  Coördinaten: vec3(%s, %s, %s)\n  Kijkrichting: %s\n  Eigenaar: ONBEKEND',

    textui_invisible = 'Onzichtbaarheid - Actief',
    textui_godmode = 'Godmodus - Actief',
    textui_wallhack = 'Wallhack - Actief',
    textui_noclip_activated = 'No Clip - Actief',
    textui_torque = 'Koppelvermenigvuldiger - %s',

    -- ── Aankondigingen ──────────────────────────────────────
    dialog_announce = 'Aankondiging',
    dialog_announce_label = 'Bericht',
    dialog_announce_select = 'Iedereen',
    dialog_announce_everyone = 'Iedereen',
    dialog_announce_placeholder = 'Belangrijk bericht hier. . .',

    -- ── Ontbannen ───────────────────────────────────────────
    dialog_unban = 'Weet je het zeker?',
    dialog_unban_content = 'Wil je %s echt ontbannen?',

    -- ── Entiteiten verwijderen ──────────────────────────────
    dialog_objects = 'Kies een optie',
    dialog_clear_objects = 'ALLE objecten verwijderen',
    dialog_clear_cars = 'ALLE auto\'s verwijderen (zonder bestuurder)',
    dialog_clear_peds = 'ALLE peds verwijderen',

    -- ── Geld geven ──────────────────────────────────────────
    dialog_givemoney = 'Geld Geven',
    givemoney_input_label = 'Bedrag',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Rekening',
    givemoney_select_option1 = 'Contant',
    givemoney_select_option2 = 'Bank',
    givemoney_select_option3 = 'Zwart Geld',

    -- ── Item geven ──────────────────────────────────────────
    dialog_giveitem = 'Item Geven',
    giveitem_input_label = 'Itemnaam',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Aantal',
    giveitem_amount_input_placeholder = '3',

    -- ── Voertuig spawnen ────────────────────────────────────
    dialog_spawn_a_car = 'Voertuig Spawnen',
    dialog_car_model = 'Modelnaam',
    dialog_car_model_holder = 'Bijv: 20charger',
    dialog_car_plate = 'Kenteken (optioneel)',
    dialog_car_plate_holder = 'Bijv: W4S4B1',
    dialog_car_color_primary = 'Primaire Kleur (optioneel)',
    dialog_car_color_second = 'Secundaire Kleur (optioneel)',
    dialog_car_maxed = 'Maximale Tuning (optioneel)',

    -- ── Kicken ──────────────────────────────────────────────
    dialog_kick = '%s kicken',
    dialog_kick_reason = 'Reden',
    dialog_kick_placeholder = 'Valsspeler',
    kicked_reason_replace = 'Je bent van de server gekickt!',

    -- ── Bannen ──────────────────────────────────────────────
    dialog_ban = '%s bannen',
    dialog_ban_reason = 'Reden',
    dialog_ban_placeholder = 'Valsspeler',
    ban_reason_replace = 'Je bent van deze server geband!',

    -- ── Zone aanmaken ───────────────────────────────────────
    dialog_zone_create = 'Zone Aanmaken',
    dialog_zone_name = 'Naam',
    dialog_zone_name_desc = 'De naam van de zone / blip',
    dialog_zone_name_holder = 'Adminzone',
    dialog_zone_text = 'Weergegeven Tekst',
    dialog_zone_text_desc = 'De tekst die spelers binnen de zone te zien krijgen',
    dialog_zone_text_holder = 'ADMINZONE - ACTIEF',
    dialog_zone_size = 'Grootte',
    dialog_zone_speed = 'Snelheidslimiet',
    mph = 'MPH',
    kmh = 'KM/H',
    dialog_zone_blip_id = 'Blip-ID',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'Kleur-ID',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Knipperende Blip',
    dialog_zone_disarm = 'Ontwapenen',
    dialog_zone_revive = 'Reanimeren',
    dialog_zone_invincible = 'Onkwetsbaar',
    dialog_zone_edit = '„%s" bewerken',
    dialog_zone_delete_confirm = 'Weet je het zeker?',
    dialog_zone_delete_confirm_desc = 'Wil je de zone echt verwijderen: %s',

    -- ── Meldingen: geld ─────────────────────────────────────
    notify_givemoney_success = 'Geld Gegeven',
    notify_givemoney_success_desc = 'Je hebt %s $%s bijgeschreven op rekening: %s',
    notify_givemoney_fail = 'Mislukt',
    notify_givemoney_fail_desc = 'Je probeerde %s bij te schrijven maar er ging iets mis! Probeer opnieuw.',

    -- ── Meldingen: items ────────────────────────────────────
    notify_giveitem_success = 'Item Gegeven',
    notify_giveitem_success_desc = 'Je hebt %s bijgeschreven. Item: %s Aantal: %s',
    notify_giveitem_fail = 'Mislukt',
    notify_giveitem_fail_desc = 'Je probeerde %s bij te schrijven maar er ging iets mis! Probeer opnieuw.',

    -- ── Meldingen: kick / ban ───────────────────────────────
    notify_kicked_success = 'Kick Gelukt',
    notify_kicked_success_desc = 'Je hebt %s succesvol gekickt',
    notify_banned_success = 'Ban Gelukt',
    notify_banned_success_desc = 'Je hebt %s succesvol geband',

    -- ── Meldingen: inventaris ───────────────────────────────
    notify_clearedinv = 'Inventaris Geleegd',
    notify_clearedinv_desc = 'Je hebt de inventaris van %s succesvol geleegd',

    -- ── Meldingen: ongeldig ID ──────────────────────────────
    notify_invalidid = 'Ongeldig ID',
    notify_invalidid_desc = 'Het ingevoerde ID is ongeldig, probeer opnieuw.',

    -- ── Meldingen: opruimen ─────────────────────────────────
    notify_deleted_car = 'Auto\'s Verwijderd',
    notify_deleted_car_desc = 'Je hebt alle auto\'s zonder bestuurder succesvol verwijderd.',
    notify_deleted_ped = 'Peds Verwijderd',
    notify_deleted_ped_desc = 'Je hebt alle peds op de map succesvol verwijderd',
    notify_deleted_objects = 'Objecten Verwijderd',
    notify_deleted_objects_desc = 'Je hebt alle objecten op de map succesvol verwijderd',

    -- ── Meldingen: weer ─────────────────────────────────────
    notify_weather = 'Weer Aangepast',
    notify_weather_desc = 'Weer gewijzigd naar: %s',

    -- ── Meldingen: coördinaten kopiëren ─────────────────────
    notify_copied = 'Gekopieerd',
    notify_copied_vec3 = 'Vector3 succesvol naar het klembord gekopieerd!',
    notify_copied_vec4 = 'Vector4 succesvol naar het klembord gekopieerd!',
    notify_copied_headin = 'Kijkrichting succesvol naar het klembord gekopieerd!',

    -- ── Meldingen: deuren ───────────────────────────────────
    notify_locked_doors = 'Vergrendeld',
    notify_locked_doors_desc = 'Voertuigdeuren succesvol vergrendeld.',
    notify_unlocked_doors = 'Ontgrendeld',
    notify_unlocked_doors_desc = 'Voertuigdeuren succesvol ontgrendeld.',

    -- ── Meldingen: adminzones ───────────────────────────────
    notify_zone_deleted = 'Zone Verwijderd',
    notify_zone_deleted_desc = 'Je hebt de zone succesvol verwijderd: %s.',
    notify_zone_not_deleted_desc = 'Er ging iets mis bij het verwijderen van de zone: %s.',
    notify_zone_edited = 'Zone Aangepast',
    notify_zone_edited_desc = 'Je hebt de zone succesvol aangepast: %s.',
    notify_zone_not_edited_desc = 'Er ging iets mis bij het aanpassen van de zone: %s.',
    notify_zone_action_cancelled = 'Actie Geannuleerd',
    notify_zone_delete_cancel = 'Je hebt het verwijderen van de zone geannuleerd: %s',
    notify_zone_no_weapons = 'Wapens Niet Toegestaan',
    notify_zone_no_weapons_desc = 'Je mag binnen deze zone geen wapens gebruiken.',
    notify_zones_not_found = 'Geen Zones Gevonden',
    notify_zones_not_found_desc = 'Er zijn momenteel geen actieve zones om te beheren.',
    notify_zones_teleport = 'Geteleporteerd',
    notify_zones_teleport_desc = 'Je bent succesvol naar de zone geteleporteerd: %s.',

    -- ── Meldingen: ontbannen ────────────────────────────────
    successfully_unbanned = 'Ban Ingetrokken',
    successfully_unbanned_desc = 'Je hebt %s succesvol ontband.',
    unsuccessful_unban = 'Er ging iets mis bij het ontbannen van: %s.',

    -- ── Verbinden (deferrals) ───────────────────────────────
    deferral_welcome = '[%s] Hallo %s, bans worden gecontroleerd. . .',
    deferral_banned = 'Je bent verbannen van deze server. Reden: „%s" (Resterend: %s uur %s minuten).',
    deferral_banned_perm = 'Je bent verbannen van deze server. Reden: „%s" (Resterend: Permanent).',

    -- ── Fouten ──────────────────────────────────────────────
    notify_error = 'Fout',
    notify_disabled_keys = 'Er is geen script voor voertuigsleutels ingesteld. Neem contact op met de serverontwikkelaar.',
    notify_no_appearance = 'Geen kleding-/uiterlijkscript gedetecteerd. Neem contact op met de serverontwikkelaar.',
    notify_no_vehicle = 'Geen voertuig gevonden!',
    notify_invalid_entry = 'Ongeldige invoer!',

    -- ── Sneltoets ───────────────────────────────────────────
    keymapping_desc = 'Adminmenu openen (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Ingeschakeld',
    noclip_deactivated = 'NoClip Uitgeschakeld',

    -- ── Onzichtbaarheid ─────────────────────────────────────
    invisibility_activated = 'Onzichtbaarheid Ingeschakeld',
    invisibility_deactivated = 'Onzichtbaarheid Uitgeschakeld',

    -- ── Godmodus ────────────────────────────────────────────
    godmode_activated = 'Godmodus Ingeschakeld',
    godmode_deactivated = 'Godmodus Uitgeschakeld',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Ingeschakeld',
    wallhack_deactivated = 'Wallhack Uitgeschakeld',

    -- ── Debugmodus ──────────────────────────────────────────
    debug_activated = 'Debugmodus Ingeschakeld',
    debug_deactivated = 'Debugmodus Uitgeschakeld',

    -- ── Meldingen: voertuigen ───────────────────────────────
    vehicle_repaired = 'Voertuig Gerepareerd',
    vehicle_repaired_desc = 'Het voertuig is succesvol gerepareerd.',
    vehicle_deleted = 'Voertuig Verwijderd',
    vehicle_deleted_desc = 'Het voertuig is succesvol verwijderd.',
    vehicle_spawned = 'Voertuig Gespawnd',
    vehicle_spawned_desc = 'Voertuig %s is succesvol gespawnd.',
    vehicle_plate_changed = 'Kenteken Gewijzigd',
    vehicle_plate_changed_desc = 'Kenteken van het voertuig gewijzigd naar: %s',
    vehicle_refueled = 'Voertuig Getankt',
    vehicle_refueled_desc = 'Het voertuig is succesvol getankt.',
    vehicle_keys_given = 'Sleutels Ontvangen',
    vehicle_keys_given_desc = 'Je hebt de sleutels ontvangen van het voertuig met kenteken: %s',
    vehicle_color_changed = 'Voertuigkleur Gewijzigd',
    vehicle_color_changed_desc = 'Voertuigkleur gewijzigd naar: %s',
    vehicle_torque_set = 'Koppelvermenigvuldiger Ingesteld',
    vehicle_torque_set_desc = 'Koppel ingesteld op: %sx',
    vehicle_torque_disabled = 'Koppelvermenigvuldiger Uitgeschakeld',

    -- ── Toekijken ───────────────────────────────────────────
    spectate_started = 'Aan het Toekijken',
    spectate_started_desc = 'Je kijkt nu bij %s. Druk op X om te stoppen.',
    spectate_ended = 'Toekijken Beëindigd',
    spectate_ended_desc = 'Je kijkt niet meer bij iemand.',
    spectate_error = 'Fout bij Toekijken',
    spectate_error_desc = 'Doelspeler niet gevonden of bestaat niet meer.',

    -- ── Teleporteren ────────────────────────────────────────
    teleport_success = 'Geteleporteerd',
    teleport_success_desc = 'Je bent succesvol geteleporteerd.',

    -- ── Reanimeren / genezen ────────────────────────────────
    player_revived = 'Speler Gereanimeerd',
    player_revived_desc = 'Je hebt %s succesvol gereanimeerd.',
    player_healed = 'Speler Genezen',
    player_healed_desc = 'Je hebt %s succesvol genezen.',
    self_revived = 'Gereanimeerd',
    self_revived_desc = 'Je hebt jezelf gereanimeerd.',
    self_healed = 'Genezen',
    self_healed_desc = 'Je hebt jezelf genezen.',

    -- ── Peds ────────────────────────────────────────────────
    ped_changed = 'Ped Gewisseld',
    ped_changed_desc = 'Je pedmodel is gewijzigd.',
    ped_restored = 'Ped Hersteld',
    ped_restored_desc = 'Je oorspronkelijke pedmodel is hersteld.',

    skin_menu_opened = 'Kledingmenu Geopend',

    admin_menu_opened = 'Adminmenu Geopend',
    admin_menu_closed = 'Adminmenu Gesloten',

    entity_deleted = 'Entiteit Verwijderd',
    entity_deleted_desc = 'De entiteit is succesvol verwijderd.',

    player_frozen = 'Speler Bevroren',
    player_frozen_desc = 'Speler %s is bevroren.',
    player_unfrozen = 'Speler Ontdooid',
    player_unfrozen_desc = 'Speler %s is ontdooid.',

    -- ── Eigen kenteken ──────────────────────────────────────
    dialog_license_plate = 'Eigen Kenteken',
    dialog_license_plate_label = 'Kenteken',
    dialog_license_plate_placeholder = 'Kenteken',

    -- ── Geld afnemen ────────────────────────────────────────
    player_removemoney = 'Geld Afnemen',
    player_removemoney_desc = 'Geld afnemen van de geselecteerde speler',
    dialog_removemoney = 'Geld Afnemen',
    removemoney_input_label = 'Bedrag',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Rekening',
    notify_removemoney_success = 'Geld Afgenomen',
    notify_removemoney_success_desc = 'Je hebt $%s afgenomen van %s (rekening: %s)',
    notify_removemoney_fail = 'Mislukt',
    notify_removemoney_fail_desc = 'Kon geen geld afnemen van %s (mogelijk onvoldoende saldo).',

    -- ── Dimensies / routing buckets ─────────────────────────
    self_dimension = 'Mijn Dimensie Instellen',
    self_dimension_desc = 'Jezelf naar een routing bucket verplaatsen (0 = hoofdwereld)',
    player_dimension = 'Dimensie Instellen',
    player_dimension_desc = 'Deze speler naar een routing bucket verplaatsen',
    player_dimension_bring = 'Naar Mijn Dimensie Halen',
    player_dimension_bring_desc = 'Deze speler naar jouw huidige dimensie trekken',
    player_dimension_goto = 'Dimensie van Speler Betreden',
    player_dimension_goto_desc = 'Jezelf naar de dimensie van deze speler verplaatsen',
    dialog_dimension = 'Dimensie Instellen',
    dimension_input_label = 'Dimensie (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Dimensie Gewijzigd',
    notify_dimension_self_desc = 'Je bent nu in dimensie %s.',
    notify_dimension_player_desc = '%s is verplaatst naar dimensie %s.',
    notify_dimension_join_desc = 'Je bent de dimensie van %s binnengegaan (%s).',
    notify_dimension_fail = 'Dimensiefout',
    notify_dimension_fail_desc = 'De dimensie kon niet worden gewijzigd.',

    -- ── Naar het voertuig teleporteren ──────────────────────
    player_tp_vehicle = 'Naar Voertuig Teleporteren',
    player_tp_vehicle_desc = 'In het voertuig van deze speler stappen om het te helpen bergen',
    notify_tp_vehicle_fail = 'Geen Voertuig',
    notify_tp_vehicle_fail_desc = '%s zit niet in een voertuig.',
    notify_tp_vehicle_success = 'Geteleporteerd',
    notify_tp_vehicle_success_desc = 'Je bent in het voertuig van %s geplaatst.',

    -- ── Voertuig bergen ─────────────────────────────────────
    recover_car = 'Voertuig Bergen / Rechtzetten',
    recover_car_desc = 'Rechtzetten en naar de dichtstbijzijnde weg verplaatsen (water/omgeslagen)',
    vehicle_recovered = 'Voertuig Geborgen',
    vehicle_recovered_desc = 'Het voertuig is rechtgezet en op de dichtstbijzijnde weg geplaatst.',

    -- ── Voertuigen in bezit ─────────────────────────────────
    player_owned_vehicles = 'Voertuigen in Bezit',
    player_owned_vehicles_desc = 'De auto\'s van deze speler bekijken, toevoegen of verwijderen',
    owned_vehicles_menu = 'Voertuigen in Bezit (%s)',
    owned_vehicles_add = 'Voertuig Toevoegen',
    owned_vehicles_add_desc = 'Een voertuig aan de garage van deze speler toevoegen',
    owned_vehicles_none = 'Geen Voertuigen',
    owned_vehicles_none_desc = 'Deze speler bezit geen voertuigen.',
    owned_vehicle_desc = 'Kenteken: %s · klik om te verwijderen',
    dialog_add_vehicle = 'Voertuig Toevoegen',
    add_vehicle_model_label = 'Modelnaam',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Kenteken (optioneel)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = '%s verwijderen?',
    notify_owned_added = 'Voertuig Toegevoegd',
    notify_owned_added_desc = '%s (kenteken %s) toegevoegd aan %s.',
    notify_owned_removed = 'Voertuig Verwijderd',
    notify_owned_removed_desc = 'Kenteken %s verwijderd van %s.',
    notify_owned_fail = 'Databasefout',
    notify_owned_fail_desc = 'De databasebewerking voor voertuigen is mislukt.',

    -- ── Pedmenu ─────────────────────────────────────────────
    player_pedmenu = 'Pedmenu Geven',
    player_pedmenu_desc = 'Een pedselectiemenu op het scherm van deze speler openen',
    pedmenu_title = 'Pedmenu',
    pedmenu_given = 'Pedmenu Verzonden',
    pedmenu_given_desc = 'Pedmenu geopend voor %s.'
}
