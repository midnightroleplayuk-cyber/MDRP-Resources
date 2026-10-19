-- ============================================================
-- NORSK (no)
-- ------------------------------------------------------------
-- Lag oppå configs/strings.lua. Enhver nøkkel som mangler her
-- beholder den engelske teksten, så delvis oversettelse er trygt.
--
-- Plassholderne %s må beholdes og i SAMME rekkefølge som i
-- originalen: de fylles ut av :format() i koden. %% skriver ut
-- et bokstavelig prosenttegn.
--
-- Aktivering:  Config.Locale = 'no'   (configs/config.lua)
-- Koden 'nb' (bokmål) faller også tilbake hit via basespråket.
-- ============================================================

Locales = Locales or {}

Locales['no'] = {
    -- ── Hovedmeny ───────────────────────────────────────────
    main_title = 'Adminmeny',
    self_options = 'Egne Valg',
    self_options_desc = 'Valg som gjelder deg selv',
    player_options_title = 'Spillervalg',
    player_options_desc = 'Valg som gjelder andre spillere',
    vehicle_options = 'Kjøretøyvalg',
    vehicle_options_desc = 'Valg som gjelder kjøretøy',
    server_options = 'Servervalg',
    server_options_desc = 'Valg som gjelder serveren',
    admin_zone_options = 'Adminsoner',
    admin_zone_options_desc = 'Administrer, legg til og slett adminsoner',
    developer_options = 'Utviklervalg',
    developer_options_desc = '',

    -- ── Egne valg ───────────────────────────────────────────
    self_options_menu = 'Egne Valg',
    self_health = 'Liv (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Gjenopplivning',
    self_revive_desc = 'Gjenopplive deg selv',
    self_heal = 'Helbred',
    self_heal_desc = 'Helbrede deg selv',
    self_skinmenu = 'Klesmeny',
    self_set_ped = 'Bytt Ped',
    self_skinmenu_desc = 'Åpne klesmenyen lokalt',
    self_invisible = 'Usynlig',
    self_godmode = 'Gudemodus',
    self_wallhack = 'Wallhack',

    -- ── Spillervalg ─────────────────────────────────────────
    player_options_menu = 'Spillere Online %s/%s',
    player_options = 'Spiller: %s',
    player_health = 'Spillerens Liv (%s%%)',
    player_freeze = 'Frys',
    player_freeze_desc = 'Slå på/av',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Slå på/av',
    player_spectate = 'Observer',
    player_spectate_desc = 'Se hva denne spilleren gjør',
    player_playerdata = 'Spillerdata',
    player_playerdata_desc = 'Vis spillerens data',
    player_revive = 'Gjenopplivning',
    player_revive_desc = 'Gjenopplive spilleren',
    player_heal = 'Helbred',
    player_heal_desc = 'Helbrede spilleren',
    player_skinmenu = 'Klesmeny',
    player_skinmenu_desc = 'Åpne en klesmeny hos spilleren',
    player_money = 'Gi Penger',
    player_money_desc = 'Gi penger til den valgte spilleren',
    player_item = 'Gi Gjenstand',
    player_item_desc = 'Gi en gjenstand til den valgte spilleren',
    player_openinv = 'Åpne Inventar',
    player_openinv_desc = 'Åpne spillerens inventar',
    player_clearinv = 'Tøm Inventar',
    player_clearinv_desc = 'Tømme spillerens inventar',
    player_teleport_to = 'Teleporter til Spiller',
    player_teleport_to_desc = 'Teleporter deg til spilleren',
    player_bring = 'Hent',
    player_bring_desc = 'Hent spilleren til posisjonen din',
    player_kick = 'Kast Ut',
    player_kick_desc = 'Kast spilleren ut av serveren',
    player_ban = 'Utesteng Spiller',

    -- ── Kjøretøymeny ────────────────────────────────────────
    vehicle_menu = 'Kjøretøymeny',
    spawn_car = 'Spawn Kjøretøy',
    spawn_car_desc = 'Spawn et kjøretøy',
    repair_car = 'Reparer Kjøretøy',
    repair_car_desc = 'Reparer nåværende eller nærmeste kjøretøy',
    delete_car = 'Slett Kjøretøy',
    delete_car_desc = 'Slett nåværende eller nærmeste kjøretøy',
    number_plate = 'Endre Skilt',
    number_plate_desc = 'Endre teksten på nåværende skilt',
    refuel = 'Fyll Kjøretøy',
    refuel_desc = 'Fyll drivstoff på nåværende eller nærmeste kjøretøy',
    give_keys = 'Gi Nøkler',
    give_keys_desc = 'Gi deg selv nøklene til nåværende kjøretøy',
    doors = 'Lås/Lås Opp Dører',
    doors_desc = 'Veksler låsene på nærmeste kjøretøy',
    boost_car = 'Dreiemomentmultiplikator',
    boost_car_desc = 'Endre dreiemomentet på nåværende kjøretøy',
    color_change = 'Endre Kjøretøyfarge',
    color_change_desc = 'Endre fargen på nåværende eller nærmeste kjøretøy',

    -- ── Serveradministrasjon ────────────────────────────────
    server_management = 'Serveradministrasjon',
    server_announcement = 'Servermelding',
    server_announcement_desc = 'Send en global melding til hele serveren',
    ban_list = 'Utestengelsesliste',
    ban_list_desc = 'Se alle aktive utestengelser',
    objects_list = 'Slett Entiteter',
    objects_list_desc = 'Slett kjøretøy og peds',
    objects_list_label = 'Valg',
    weather_menu = 'Væradministrasjon',
    weather_menu_desc = 'Administrer været',

    -- ── Adminsoner ──────────────────────────────────────────
    zones_create = 'Opprett Sone',
    zones_create_desc = 'Opprett en ny adminsone',
    zones_manage = 'Administrer Soner',
    zones_manage_desc = 'Rediger eller slett aktive soner',
    zone_edit_current = 'Rediger Nåværende Sone',
    zone_edit_current_desc = 'Administrer sonen du befinner deg i',
    zone_delete_current = 'Slett Nåværende Sone',
    zone_delete_current_desc = 'Slett sonen du befinner deg i',
    zone_manage_menu = 'Redigerer Sone (%s)',
    zone_edit = 'Rediger Sone',
    zone_edit_desc = 'Endre sone: %s',
    zone_delete = 'Slett Sone',
    zone_delete_desc = 'Slett sone: %s',
    zone_teleport = 'Teleporter til Sone',
    zone_teleport_desc = 'Gå til sone: %s',

    -- ── Utviklermeny ────────────────────────────────────────
    dev_options = 'Utviklervalg',
    debug_mode = 'Feilsøkingsmodus',
    debug_mode_desc = 'Slå feilsøkingsmodus på/av',
    copy_vec3 = 'Kopier Vector3-koordinater',
    copy_vec3_desc = 'Kopierer din nåværende posisjon (vector3) til utklippstavlen',
    copy_vec4 = 'Kopier Vector4-koordinater',
    copy_vec4_desc = 'Kopierer din nåværende posisjon (vector4) til utklippstavlen',
    copy_heading = 'Kopier Retning',
    copy_heading_desc = 'Kopierer din nåværende retning til utklippstavlen',
    cant_delete = 'Kan ikke slettes!',
    cant_delete_player_desc = 'Du kan ikke slette spilleres peds!',
    cant_delete_entity_desc = 'Du kan ikke slette kartets standardobjekter!',

    -- ── Utestengelsesliste ──────────────────────────────────
    ban_list_menu = 'Utestengelsesliste',
    ban_list_name = 'Navn: %s',
    ban_list_license = 'Lisens:',
    ban_list_by = 'Utstedt av: %s',
    ban_list_reason = 'Årsak: %s',
    ban_list_length = 'Tid igjen: %s timer %s minutter',
    ban_list_modify = 'Endre Utestengelse',
    ban_list_unban = 'Opphev Utestengelse',
    ban_list_no_data = 'Ingen Utestengelser',
    ban_list_no_data_desc = 'Ingen aktive utestengelser ble funnet!',

    -- ── Spillerdata ─────────────────────────────────────────
    playerdata_menu = 'Spillerdata',
    playerdata_license_esx = 'Lisens: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Klikk for å kopiere hele lisensen',
    playerdata_igname = 'Navn: %s',
    playerdata_igname_desc = 'Spillerens fulle navn i spillet',
    playerdata_steam = 'Steam-navn: %s',
    playerdata_steam_desc = 'Spillerens fulle Steam-navn',
    playerdata_gender = 'Kjønn: %s',
    playerdata_gender_desc = 'Spillerens kjønn',
    playerdata_cash = 'Kontanter: %s',
    playerdata_cash_desc = 'Spillerens kontantbeholdning',
    playerdata_bank = 'Bank: %s',
    playerdata_bank_desc = 'Spillerens banksaldo',
    playerdata_blackmoney = 'Svarte Penger: %s',
    playerdata_blackmoney_desc = 'Spillerens beholdning av svarte penger',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Trykk [E] for å slette entiteten  \nHash: %s  \nKoordinater: vec3(%s, %s, %s)  \nRetning: %s  \nEier: [%s] - %s',
    debug_textui_noname = 'Trykk [E] for å slette entiteten\n  Hash: %s\n  Koordinater: vec3(%s, %s, %s)\n  Retning: %s\n  Eier: UKJENT',

    textui_invisible = 'Usynlighetsmodus - Aktiv',
    textui_godmode = 'Gudemodus - Aktiv',
    textui_wallhack = 'Wallhack - Aktiv',
    textui_noclip_activated = 'No Clip - Aktiv',
    textui_torque = 'Dreiemomentmultiplikator - %s',

    -- ── Meldinger ───────────────────────────────────────────
    dialog_announce = 'Melding',
    dialog_announce_label = 'Melding',
    dialog_announce_select = 'Alle',
    dialog_announce_everyone = 'Alle',
    dialog_announce_placeholder = 'Viktig melding her. . .',

    -- ── Oppheve utestengelse ────────────────────────────────
    dialog_unban = 'Er du sikker?',
    dialog_unban_content = 'Vil du virkelig oppheve utestengelsen av %s?',

    -- ── Slette entiteter ────────────────────────────────────
    dialog_objects = 'Velg et alternativ',
    dialog_clear_objects = 'Slett ALLE objekter',
    dialog_clear_cars = 'Slett ALLE biler (uten sjåfør)',
    dialog_clear_peds = 'Slett ALLE peds',

    -- ── Gi penger ───────────────────────────────────────────
    dialog_givemoney = 'Gi Penger',
    givemoney_input_label = 'Beløp',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Konto',
    givemoney_select_option1 = 'Kontanter',
    givemoney_select_option2 = 'Bank',
    givemoney_select_option3 = 'Svarte Penger',

    -- ── Gi gjenstand ────────────────────────────────────────
    dialog_giveitem = 'Gi Gjenstand',
    giveitem_input_label = 'Gjenstandens Navn',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Antall',
    giveitem_amount_input_placeholder = '3',

    -- ── Spawn kjøretøy ──────────────────────────────────────
    dialog_spawn_a_car = 'Spawn Kjøretøy',
    dialog_car_model = 'Modellnavn',
    dialog_car_model_holder = 'F.eks: 20charger',
    dialog_car_plate = 'Skilt (valgfritt)',
    dialog_car_plate_holder = 'F.eks: W4S4B1',
    dialog_car_color_primary = 'Primærfarge (valgfritt)',
    dialog_car_color_second = 'Sekundærfarge (valgfritt)',
    dialog_car_maxed = 'Maksimale Modifikasjoner (valgfritt)',

    -- ── Kaste ut ────────────────────────────────────────────
    dialog_kick = 'Kast ut %s',
    dialog_kick_reason = 'Årsak',
    dialog_kick_placeholder = 'Juksemaker',
    kicked_reason_replace = 'Du har blitt kastet ut av serveren!',

    -- ── Utestengelse ────────────────────────────────────────
    dialog_ban = 'Utesteng %s',
    dialog_ban_reason = 'Årsak',
    dialog_ban_placeholder = 'Juksemaker',
    ban_reason_replace = 'Du har blitt utestengt fra denne serveren!',

    -- ── Opprette sone ───────────────────────────────────────
    dialog_zone_create = 'Opprett Sone',
    dialog_zone_name = 'Navn',
    dialog_zone_name_desc = 'Navnet på sonen / blippen',
    dialog_zone_name_holder = 'Adminsone',
    dialog_zone_text = 'Vist Tekst',
    dialog_zone_text_desc = 'Teksten som vises til spillere inne i sonen',
    dialog_zone_text_holder = 'ADMINSONE - AKTIV',
    dialog_zone_size = 'Størrelse',
    dialog_zone_speed = 'Fartsgrense',
    mph = 'MPH',
    kmh = 'KM/T',
    dialog_zone_blip_id = 'Blipp-ID',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'Farge-ID',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Blinkende Blipp',
    dialog_zone_disarm = 'Avvæpne',
    dialog_zone_revive = 'Gjenopplivning',
    dialog_zone_invincible = 'Udødelig',
    dialog_zone_edit = 'Redigerer "%s"',
    dialog_zone_delete_confirm = 'Er du sikker?',
    dialog_zone_delete_confirm_desc = 'Vil du virkelig slette sonen: %s',

    -- ── Varsler: penger ─────────────────────────────────────
    notify_givemoney_success = 'Penger Gitt',
    -- Argumentrekkefølgen må følge engelsk: spiller, beløp, konto.
    notify_givemoney_success_desc = 'Du krediterte %s med $%s på kontoen: %s',
    notify_givemoney_fail = 'Mislyktes',
    notify_givemoney_fail_desc = 'Du prøvde å sette inn til %s, men noe gikk galt! Prøv igjen.',

    -- ── Varsler: gjenstander ────────────────────────────────
    notify_giveitem_success = 'Gjenstand Gitt',
    notify_giveitem_success_desc = 'Du ga til %s. Gjenstand: %s Antall: %s',
    notify_giveitem_fail = 'Mislyktes',
    notify_giveitem_fail_desc = 'Du prøvde å gi til %s, men noe gikk galt! Prøv igjen.',

    -- ── Varsler: utkasting / utestengelse ───────────────────
    notify_kicked_success = 'Utkasting Vellykket',
    notify_kicked_success_desc = 'Du kastet ut %s',
    notify_banned_success = 'Utestengelse Vellykket',
    notify_banned_success_desc = 'Du utestengte %s',

    -- ── Varsler: inventar ───────────────────────────────────
    notify_clearedinv = 'Inventar Tømt',
    notify_clearedinv_desc = 'Du tømte inventaret til %s',

    -- ── Varsler: ugyldig ID ─────────────────────────────────
    notify_invalidid = 'Ugyldig ID',
    notify_invalidid_desc = 'ID-en du oppga var ugyldig, prøv igjen.',

    -- ── Varsler: opprydding ─────────────────────────────────
    notify_deleted_car = 'Biler Slettet',
    notify_deleted_car_desc = 'Du slettet alle biler uten sjåfør.',
    notify_deleted_ped = 'Peds Slettet',
    notify_deleted_ped_desc = 'Du slettet alle peds på kartet',
    notify_deleted_objects = 'Objekter Slettet',
    notify_deleted_objects_desc = 'Du slettet alle objekter på kartet',

    -- ── Varsler: vær ────────────────────────────────────────
    notify_weather = 'Vær Endret',
    notify_weather_desc = 'Været endret til: %s',

    -- ── Varsler: kopier koordinater ─────────────────────────
    notify_copied = 'Kopiert',
    notify_copied_vec3 = 'Vector3 kopiert til utklippstavlen!',
    notify_copied_vec4 = 'Vector4 kopiert til utklippstavlen!',
    notify_copied_headin = 'Retning kopiert til utklippstavlen!',

    -- ── Varsler: dører ──────────────────────────────────────
    notify_locked_doors = 'Låst',
    notify_locked_doors_desc = 'Kjøretøyets dører ble låst.',
    notify_unlocked_doors = 'Låst Opp',
    notify_unlocked_doors_desc = 'Kjøretøyets dører ble låst opp.',

    -- ── Varsler: adminsoner ─────────────────────────────────
    notify_zone_deleted = 'Sone Slettet',
    notify_zone_deleted_desc = 'Du fjernet sonen: %s.',
    notify_zone_not_deleted_desc = 'Det oppstod en feil ved sletting av sonen: %s.',
    notify_zone_edited = 'Sone Endret',
    notify_zone_edited_desc = 'Du endret sonen: %s.',
    notify_zone_not_edited_desc = 'Det oppstod en feil ved endring av sonen: %s.',
    notify_zone_action_cancelled = 'Handling Avbrutt',
    notify_zone_delete_cancel = 'Du avbrøt slettingen av sonen: %s',
    notify_zone_no_weapons = 'Våpen Ikke Tillatt',
    notify_zone_no_weapons_desc = 'Du har ikke lov til å bruke våpen inne i denne sonen.',
    notify_zones_not_found = 'Ingen Soner',
    notify_zones_not_found_desc = 'Det finnes for øyeblikket ingen aktive soner å administrere.',
    notify_zones_teleport = 'Teleportert',
    notify_zones_teleport_desc = 'Du ble teleportert til sonen: %s.',

    -- ── Varsler: opphevet utestengelse ──────────────────────
    successfully_unbanned = 'Utestengelse Opphevet',
    successfully_unbanned_desc = 'Du opphevet utestengelsen av: %s.',
    unsuccessful_unban = 'Noe gikk galt ved oppheving av utestengelsen for: %s.',

    -- ── Tilkobling (deferrals) ──────────────────────────────
    deferral_welcome = '[%s] Hei %s, sjekker utestengelser. . .',
    deferral_banned = 'Du er utestengt fra serveren. Årsak: "%s" (Tid igjen: %s timer %s minutter).',
    deferral_banned_perm = 'Du er utestengt fra serveren. Årsak: "%s" (Tid igjen: Permanent).',

    -- ── Feil ────────────────────────────────────────────────
    notify_error = 'Feil',
    notify_disabled_keys = 'Det er ikke konfigurert noe skript for kjøretøynøkler. Kontakt serverutvikleren.',
    notify_no_appearance = 'Ingen klær-/utseendeskript funnet. Kontakt serverutvikleren.',
    notify_no_vehicle = 'Ingen kjøretøy funnet!',
    notify_invalid_entry = 'Ugyldig inndata!',

    -- ── Hurtigtast ──────────────────────────────────────────
    keymapping_desc = 'Åpne Adminmenyen (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Aktivert',
    noclip_deactivated = 'NoClip Deaktivert',

    -- ── Usynlighet ──────────────────────────────────────────
    invisibility_activated = 'Usynlighetsmodus Aktivert',
    invisibility_deactivated = 'Usynlighetsmodus Deaktivert',

    -- ── Gudemodus ───────────────────────────────────────────
    godmode_activated = 'Gudemodus Aktivert',
    godmode_deactivated = 'Gudemodus Deaktivert',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Aktivert',
    wallhack_deactivated = 'Wallhack Deaktivert',

    -- ── Feilsøkingsmodus ────────────────────────────────────
    debug_activated = 'Feilsøkingsmodus Aktivert',
    debug_deactivated = 'Feilsøkingsmodus Deaktivert',

    -- ── Varsler: kjøretøy ───────────────────────────────────
    vehicle_repaired = 'Kjøretøy Reparert',
    vehicle_repaired_desc = 'Kjøretøyet har blitt reparert.',
    vehicle_deleted = 'Kjøretøy Slettet',
    vehicle_deleted_desc = 'Kjøretøyet har blitt slettet.',
    vehicle_spawned = 'Kjøretøy Spawnet',
    vehicle_spawned_desc = 'Kjøretøyet %s har blitt spawnet.',
    vehicle_plate_changed = 'Skilt Endret',
    vehicle_plate_changed_desc = 'Kjøretøyets skilt endret til: %s',
    vehicle_refueled = 'Kjøretøy Fylt',
    vehicle_refueled_desc = 'Kjøretøyet har blitt fylt med drivstoff.',
    vehicle_keys_given = 'Nøkler Mottatt',
    vehicle_keys_given_desc = 'Du har mottatt nøklene til kjøretøyet med skiltet: %s',
    vehicle_color_changed = 'Kjøretøyfarge Endret',
    vehicle_color_changed_desc = 'Kjøretøyets farge endret til: %s',
    vehicle_torque_set = 'Dreiemomentmultiplikator Satt',
    vehicle_torque_set_desc = 'Dreiemoment satt til: %sx',
    vehicle_torque_disabled = 'Dreiemomentmultiplikator Slått Av',

    -- ── Observering ─────────────────────────────────────────
    spectate_started = 'Observerer',
    spectate_started_desc = 'Du observerer %s. Trykk X for å stoppe.',
    spectate_ended = 'Observering Avsluttet',
    spectate_ended_desc = 'Du observerer ikke lenger noen.',
    spectate_error = 'Observeringsfeil',
    spectate_error_desc = 'Målspilleren ble ikke funnet eller finnes ikke lenger.',

    -- ── Teleportering ───────────────────────────────────────
    teleport_success = 'Teleportert',
    teleport_success_desc = 'Du har blitt teleportert.',

    -- ── Gjenopplivning / helbredelse ────────────────────────
    player_revived = 'Spiller Gjenopplivet',
    player_revived_desc = 'Du gjenopplivet %s.',
    player_healed = 'Spiller Helbredet',
    player_healed_desc = 'Du helbredet %s.',
    self_revived = 'Gjenopplivet',
    self_revived_desc = 'Du gjenopplivet deg selv.',
    self_healed = 'Helbredet',
    self_healed_desc = 'Du helbredet deg selv.',

    -- ── Peds ────────────────────────────────────────────────
    ped_changed = 'Ped Byttet',
    ped_changed_desc = 'Ped-modellen din har blitt endret.',
    ped_restored = 'Ped Gjenopprettet',
    ped_restored_desc = 'Din opprinnelige ped-modell har blitt gjenopprettet.',

    skin_menu_opened = 'Klesmeny Åpnet',

    admin_menu_opened = 'Adminmeny Åpnet',
    admin_menu_closed = 'Adminmeny Lukket',

    entity_deleted = 'Entitet Slettet',
    entity_deleted_desc = 'Entiteten har blitt slettet.',

    player_frozen = 'Spiller Frosset',
    player_frozen_desc = 'Spilleren %s har blitt frosset.',
    player_unfrozen = 'Spiller Tint',
    player_unfrozen_desc = 'Spilleren %s har blitt tint opp.',

    -- ── Eget skilt ──────────────────────────────────────────
    dialog_license_plate = 'Eget Skilt',
    dialog_license_plate_label = 'Skilt',
    dialog_license_plate_placeholder = 'Skilt',

    -- ── Ta penger ───────────────────────────────────────────
    player_removemoney = 'Ta Penger',
    player_removemoney_desc = 'Ta penger fra den valgte spilleren',
    dialog_removemoney = 'Ta Penger',
    removemoney_input_label = 'Beløp',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Konto',
    notify_removemoney_success = 'Penger Fjernet',
    notify_removemoney_success_desc = 'Du tok $%s fra %s (konto: %s)',
    notify_removemoney_fail = 'Mislyktes',
    notify_removemoney_fail_desc = 'Kunne ikke ta penger fra %s (kanskje for lav saldo).',

    -- ── Dimensjoner / routing buckets ───────────────────────
    self_dimension = 'Sett Min Dimensjon',
    self_dimension_desc = 'Flytt deg til en routing bucket (0 = hovedverdenen)',
    player_dimension = 'Sett Dimensjon',
    player_dimension_desc = 'Flytt denne spilleren til en routing bucket',
    player_dimension_bring = 'Hent til Min Dimensjon',
    player_dimension_bring_desc = 'Dra denne spilleren inn i din nåværende dimensjon',
    player_dimension_goto = 'Bli med i Spillerens Dimensjon',
    player_dimension_goto_desc = 'Flytt deg til denne spillerens dimensjon',
    dialog_dimension = 'Sett Dimensjon',
    dimension_input_label = 'Dimensjon (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Dimensjon Endret',
    notify_dimension_self_desc = 'Du er nå i dimensjon %s.',
    notify_dimension_player_desc = '%s ble flyttet til dimensjon %s.',
    notify_dimension_join_desc = 'Du ble med i dimensjonen til %s (%s).',
    notify_dimension_fail = 'Dimensjonsfeil',
    notify_dimension_fail_desc = 'Kunne ikke bytte dimensjon.',

    -- ── Teleporter inn i kjøretøyet ─────────────────────────
    player_tp_vehicle = 'Teleporter inn i Kjøretøyet',
    player_tp_vehicle_desc = 'Sett deg inn i denne spillerens kjøretøy for å hjelpe med å berge det',
    notify_tp_vehicle_fail = 'Ingen Kjøretøy',
    notify_tp_vehicle_fail_desc = '%s sitter ikke i et kjøretøy.',
    notify_tp_vehicle_success = 'Teleportert',
    notify_tp_vehicle_success_desc = 'Du ble plassert i kjøretøyet til %s.',

    -- ── Berge kjøretøy ──────────────────────────────────────
    recover_car = 'Berg / Snu Kjøretøy',
    recover_car_desc = 'Snu det riktig vei og flytt til nærmeste vei (vann/veltet)',
    vehicle_recovered = 'Kjøretøy Berget',
    vehicle_recovered_desc = 'Kjøretøyet ble snudd riktig vei og plassert på nærmeste vei.',

    -- ── Eide kjøretøy ───────────────────────────────────────
    player_owned_vehicles = 'Eide Kjøretøy',
    player_owned_vehicles_desc = 'Se, legg til eller fjern denne spillerens biler',
    owned_vehicles_menu = 'Eide Kjøretøy (%s)',
    owned_vehicles_add = 'Legg Til Kjøretøy',
    owned_vehicles_add_desc = 'Legg til et kjøretøy i denne spillerens garasje',
    owned_vehicles_none = 'Ingen Kjøretøy',
    owned_vehicles_none_desc = 'Denne spilleren eier ingen kjøretøy.',
    owned_vehicle_desc = 'Skilt: %s · klikk for å fjerne',
    dialog_add_vehicle = 'Legg Til Kjøretøy',
    add_vehicle_model_label = 'Modellnavn',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Skilt (valgfritt)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = 'Fjerne %s?',
    notify_owned_added = 'Kjøretøy Lagt Til',
    notify_owned_added_desc = 'La til %s (skilt %s) hos %s.',
    notify_owned_removed = 'Kjøretøy Fjernet',
    notify_owned_removed_desc = 'Fjernet skiltet %s fra %s.',
    notify_owned_fail = 'Databasefeil',
    notify_owned_fail_desc = 'Databaseoperasjonen for kjøretøy mislyktes.',

    -- ── Ped-meny ────────────────────────────────────────────
    player_pedmenu = 'Gi Ped-meny',
    player_pedmenu_desc = 'Åpne en ped-valgmeny på denne spillerens skjerm',
    pedmenu_title = 'Ped-meny',
    pedmenu_given = 'Ped-meny Sendt',
    pedmenu_given_desc = 'Ped-meny åpnet for %s.'
}
