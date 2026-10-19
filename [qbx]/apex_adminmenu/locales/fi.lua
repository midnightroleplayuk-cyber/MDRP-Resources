-- ============================================================
-- SUOMI (fi)
-- ------------------------------------------------------------
-- Kerros configs/strings.lua:n päällä. Jokainen avain, joka
-- puuttuu täältä, säilyttää englanninkielisen tekstin, joten
-- osittainen käännös on turvallinen.
--
-- %s-paikkamerkit on säilytettävä ja SAMASSA järjestyksessä kuin
-- alkuperäisessä: koodin :format() täyttää ne. %% tulostaa
-- kirjaimellisen prosenttimerkin.
--
-- Käyttöönotto:  Config.Locale = 'fi'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['fi'] = {
    -- ── Päävalikko ──────────────────────────────────────────
    main_title = 'Ylläpitovalikko',
    self_options = 'Omat Asetukset',
    self_options_desc = 'Itseäsi koskevat asetukset',
    player_options_title = 'Pelaaja-asetukset',
    player_options_desc = 'Muita pelaajia koskevat asetukset',
    vehicle_options = 'Ajoneuvoasetukset',
    vehicle_options_desc = 'Ajoneuvoja koskevat asetukset',
    server_options = 'Palvelinasetukset',
    server_options_desc = 'Palvelinta koskevat asetukset',
    admin_zone_options = 'Ylläpitoalueet',
    admin_zone_options_desc = 'Hallitse, lisää ja poista ylläpitoalueita',
    developer_options = 'Kehittäjäasetukset',
    developer_options_desc = '',

    -- ── Omat asetukset ──────────────────────────────────────
    self_options_menu = 'Omat Asetukset',
    self_health = 'Elämä (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Elvytä',
    self_revive_desc = 'Elvytä itsesi',
    self_heal = 'Paranna',
    self_heal_desc = 'Paranna itsesi',
    self_skinmenu = 'Vaatevalikko',
    self_set_ped = 'Vaihda Ped',
    self_skinmenu_desc = 'Avaa vaatevalikko paikallisesti',
    self_invisible = 'Näkymätön',
    self_godmode = 'Jumaltila',
    self_wallhack = 'Wallhack',

    -- ── Pelaaja-asetukset ───────────────────────────────────
    player_options_menu = 'Pelaajia Paikalla %s/%s',
    player_options = 'Pelaaja: %s',
    player_health = 'Pelaajan Elämä (%s%%)',
    player_freeze = 'Jäädytä',
    player_freeze_desc = 'Päälle/pois',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Päälle/pois',
    player_spectate = 'Tarkkaile',
    player_spectate_desc = 'Seuraa tämän pelaajan toimintaa',
    player_playerdata = 'Pelaajan Tiedot',
    player_playerdata_desc = 'Näytä pelaajan tiedot',
    player_revive = 'Elvytä',
    player_revive_desc = 'Elvytä pelaaja',
    player_heal = 'Paranna',
    player_heal_desc = 'Paranna pelaaja',
    player_skinmenu = 'Vaatevalikko',
    player_skinmenu_desc = 'Avaa pelaajalle vaatevalikko',
    player_money = 'Anna Rahaa',
    player_money_desc = 'Anna rahaa valitulle pelaajalle',
    player_item = 'Anna Esine',
    player_item_desc = 'Anna esine valitulle pelaajalle',
    player_openinv = 'Avaa Tavaraluettelo',
    player_openinv_desc = 'Avaa pelaajan tavaraluettelo',
    player_clearinv = 'Tyhjennä Tavaraluettelo',
    player_clearinv_desc = 'Tyhjennä pelaajan tavaraluettelo',
    player_teleport_to = 'Teleporttaa Pelaajan Luo',
    player_teleport_to_desc = 'Teleporttaa itsesi pelaajan luo',
    player_bring = 'Tuo',
    player_bring_desc = 'Tuo pelaaja sijaintiisi',
    player_kick = 'Potki',
    player_kick_desc = 'Potki pelaaja pois palvelimelta',
    player_ban = 'Porttikielto Pelaajalle',

    -- ── Ajoneuvovalikko ─────────────────────────────────────
    vehicle_menu = 'Ajoneuvovalikko',
    spawn_car = 'Luo Ajoneuvo',
    spawn_car_desc = 'Luo ajoneuvo',
    repair_car = 'Korjaa Ajoneuvo',
    repair_car_desc = 'Korjaa nykyinen tai lähin ajoneuvo',
    delete_car = 'Poista Ajoneuvo',
    delete_car_desc = 'Poista nykyinen tai lähin ajoneuvo',
    number_plate = 'Muuta Rekisterikilpeä',
    number_plate_desc = 'Muuta nykyisen rekisterikilven tekstiä',
    refuel = 'Tankkaa Ajoneuvo',
    refuel_desc = 'Tankkaa nykyinen tai lähin ajoneuvo',
    give_keys = 'Anna Avaimet',
    give_keys_desc = 'Anna itsellesi nykyisen ajoneuvon avaimet',
    doors = 'Lukitse/Avaa Ovet',
    doors_desc = 'Vaihtaa lähimmän ajoneuvon lukot',
    boost_car = 'Vääntökerroin',
    boost_car_desc = 'Muuta nykyisen ajoneuvon vääntöä',
    color_change = 'Vaihda Ajoneuvon Väri',
    color_change_desc = 'Vaihda nykyisen tai lähimmän ajoneuvon väri',

    -- ── Palvelimen hallinta ─────────────────────────────────
    server_management = 'Palvelimen Hallinta',
    server_announcement = 'Palvelinilmoitus',
    server_announcement_desc = 'Lähetä yleinen ilmoitus koko palvelimelle',
    ban_list = 'Porttikieltolista',
    ban_list_desc = 'Tarkista kaikki voimassa olevat porttikiellot',
    objects_list = 'Poista Entiteettejä',
    objects_list_desc = 'Poista ajoneuvoja ja pedejä',
    objects_list_label = 'Asetukset',
    weather_menu = 'Sään Hallinta',
    weather_menu_desc = 'Hallitse säätä',

    -- ── Ylläpitoalueet ──────────────────────────────────────
    zones_create = 'Luo Alue',
    zones_create_desc = 'Luo uusi ylläpitoalue',
    zones_manage = 'Hallitse Alueita',
    zones_manage_desc = 'Muokkaa tai poista aktiivisia alueita',
    zone_edit_current = 'Muokkaa Nykyistä Aluetta',
    zone_edit_current_desc = 'Hallitse aluetta, jolla olet',
    zone_delete_current = 'Poista Nykyinen Alue',
    zone_delete_current_desc = 'Poista alue, jolla olet',
    zone_manage_menu = 'Muokataan Aluetta (%s)',
    zone_edit = 'Muokkaa Aluetta',
    zone_edit_desc = 'Muuta aluetta: %s',
    zone_delete = 'Poista Alue',
    zone_delete_desc = 'Poista alue: %s',
    zone_teleport = 'Teleporttaa Alueelle',
    zone_teleport_desc = 'Siirry alueelle: %s',

    -- ── Kehittäjävalikko ────────────────────────────────────
    dev_options = 'Kehittäjäasetukset',
    debug_mode = 'Debug-tila',
    debug_mode_desc = 'Kytke debug-tila päälle/pois',
    copy_vec3 = 'Kopioi Vector3-koordinaatit',
    copy_vec3_desc = 'Kopioi nykyisen sijaintisi (vector3) leikepöydälle',
    copy_vec4 = 'Kopioi Vector4-koordinaatit',
    copy_vec4_desc = 'Kopioi nykyisen sijaintisi (vector4) leikepöydälle',
    copy_heading = 'Kopioi Suunta',
    copy_heading_desc = 'Kopioi nykyisen suuntasi leikepöydälle',
    cant_delete = 'Ei voi poistaa!',
    cant_delete_player_desc = 'Et voi poistaa pelaajien pedejä!',
    cant_delete_entity_desc = 'Et voi poistaa kartan oletusobjekteja!',

    -- ── Porttikieltolista ───────────────────────────────────
    ban_list_menu = 'Porttikieltolista',
    ban_list_name = 'Nimi: %s',
    ban_list_license = 'Lisenssi:',
    ban_list_by = 'Antanut: %s',
    ban_list_reason = 'Syy: %s',
    ban_list_length = 'Aikaa jäljellä: %s tuntia %s minuuttia',
    ban_list_modify = 'Muokkaa Porttikieltoa',
    ban_list_unban = 'Poista Porttikielto',
    ban_list_no_data = 'Ei Porttikieltoja',
    ban_list_no_data_desc = 'Voimassa olevia porttikieltoja ei löytynyt!',

    -- ── Pelaajan tiedot ─────────────────────────────────────
    playerdata_menu = 'Pelaajan Tiedot',
    playerdata_license_esx = 'Lisenssi: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Napsauta kopioidaksesi koko lisenssin',
    playerdata_igname = 'Nimi: %s',
    playerdata_igname_desc = 'Pelaajan koko nimi pelissä',
    playerdata_steam = 'Steam-nimi: %s',
    playerdata_steam_desc = 'Pelaajan koko Steam-nimi',
    playerdata_gender = 'Sukupuoli: %s',
    playerdata_gender_desc = 'Pelaajan sukupuoli',
    playerdata_cash = 'Käteinen: %s',
    playerdata_cash_desc = 'Pelaajan käteissaldo',
    playerdata_bank = 'Pankki: %s',
    playerdata_bank_desc = 'Pelaajan pankkisaldo',
    playerdata_blackmoney = 'Mustat Rahat: %s',
    playerdata_blackmoney_desc = 'Pelaajan mustan rahan saldo',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Paina [E] poistaaksesi entiteetin  \nHash: %s  \nKoordinaatit: vec3(%s, %s, %s)  \nSuunta: %s  \nOmistaja: [%s] - %s',
    debug_textui_noname = 'Paina [E] poistaaksesi entiteetin\n  Hash: %s\n  Koordinaatit: vec3(%s, %s, %s)\n  Suunta: %s\n  Omistaja: TUNTEMATON',

    textui_invisible = 'Näkymättömyystila - Aktiivinen',
    textui_godmode = 'Jumaltila - Aktiivinen',
    textui_wallhack = 'Wallhack - Aktiivinen',
    textui_noclip_activated = 'No Clip - Aktiivinen',
    textui_torque = 'Vääntökerroin - %s',

    -- ── Ilmoitukset ─────────────────────────────────────────
    dialog_announce = 'Ilmoitus',
    dialog_announce_label = 'Viesti',
    dialog_announce_select = 'Kaikki',
    dialog_announce_everyone = 'Kaikki',
    dialog_announce_placeholder = 'Tärkeä viesti tähän. . .',

    -- ── Porttikiellon poisto ────────────────────────────────
    dialog_unban = 'Oletko varma?',
    dialog_unban_content = 'Haluatko todella poistaa pelaajan %s porttikiellon?',

    -- ── Entiteettien poisto ─────────────────────────────────
    dialog_objects = 'Valitse vaihtoehto',
    dialog_clear_objects = 'Poista KAIKKI objektit',
    dialog_clear_cars = 'Poista KAIKKI autot (ilman kuljettajaa)',
    dialog_clear_peds = 'Poista KAIKKI pedit',

    -- ── Rahan antaminen ─────────────────────────────────────
    dialog_givemoney = 'Anna Rahaa',
    givemoney_input_label = 'Summa',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Tili',
    givemoney_select_option1 = 'Käteinen',
    givemoney_select_option2 = 'Pankki',
    givemoney_select_option3 = 'Mustat Rahat',

    -- ── Esineen antaminen ───────────────────────────────────
    dialog_giveitem = 'Anna Esine',
    giveitem_input_label = 'Esineen Nimi',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Määrä',
    giveitem_amount_input_placeholder = '3',

    -- ── Ajoneuvon luonti ────────────────────────────────────
    dialog_spawn_a_car = 'Luo Ajoneuvo',
    dialog_car_model = 'Mallin Nimi',
    dialog_car_model_holder = 'Esim: 20charger',
    dialog_car_plate = 'Rekisterikilpi (valinnainen)',
    dialog_car_plate_holder = 'Esim: W4S4B1',
    dialog_car_color_primary = 'Ensisijainen Väri (valinnainen)',
    dialog_car_color_second = 'Toissijainen Väri (valinnainen)',
    dialog_car_maxed = 'Maksimimuutokset (valinnainen)',

    -- ── Potkiminen ──────────────────────────────────────────
    dialog_kick = 'Potki %s',
    dialog_kick_reason = 'Syy',
    dialog_kick_placeholder = 'Huijari',
    kicked_reason_replace = 'Sinut on potkittu palvelimelta!',

    -- ── Porttikielto ────────────────────────────────────────
    dialog_ban = 'Anna porttikielto: %s',
    dialog_ban_reason = 'Syy',
    dialog_ban_placeholder = 'Huijari',
    ban_reason_replace = 'Sinulle on annettu porttikielto tälle palvelimelle!',

    -- ── Alueen luonti ───────────────────────────────────────
    dialog_zone_create = 'Alueen Luonti',
    dialog_zone_name = 'Nimi',
    dialog_zone_name_desc = 'Alueen / blipin nimi',
    dialog_zone_name_holder = 'Ylläpitoalue',
    dialog_zone_text = 'Näytettävä Teksti',
    dialog_zone_text_desc = 'Teksti, joka näytetään alueella oleville pelaajille',
    dialog_zone_text_holder = 'YLLÄPITOALUE - AKTIIVINEN',
    dialog_zone_size = 'Koko',
    dialog_zone_speed = 'Nopeusrajoitus',
    mph = 'MPH',
    kmh = 'KM/H',
    dialog_zone_blip_id = 'Blipin ID',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'Värin ID',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Vilkkuva Blippi',
    dialog_zone_disarm = 'Riisu Aseista',
    dialog_zone_revive = 'Elvytä',
    dialog_zone_invincible = 'Kuolematon',
    dialog_zone_edit = 'Muokataan "%s"',
    dialog_zone_delete_confirm = 'Oletko varma?',
    dialog_zone_delete_confirm_desc = 'Haluatko todella poistaa alueen: %s',

    -- ── Ilmoitukset: raha ───────────────────────────────────
    notify_givemoney_success = 'Raha Annettu',
    notify_givemoney_success_desc = 'Hyvitit pelaajalle %s $%s tilille: %s',
    notify_givemoney_fail = 'Epäonnistui',
    notify_givemoney_fail_desc = 'Yritit hyvittää pelaajalle %s, mutta jokin meni pieleen! Yritä uudelleen.',

    -- ── Ilmoitukset: esineet ────────────────────────────────
    notify_giveitem_success = 'Esine Annettu',
    notify_giveitem_success_desc = 'Annoit pelaajalle %s. Esine: %s Määrä: %s',
    notify_giveitem_fail = 'Epäonnistui',
    notify_giveitem_fail_desc = 'Yritit antaa pelaajalle %s, mutta jokin meni pieleen! Yritä uudelleen.',

    -- ── Ilmoitukset: potkut / porttikielto ──────────────────
    notify_kicked_success = 'Potkut Onnistuivat',
    notify_kicked_success_desc = 'Potkit pelaajan %s onnistuneesti',
    notify_banned_success = 'Porttikielto Onnistui',
    notify_banned_success_desc = 'Annoit porttikiellon pelaajalle %s',

    -- ── Ilmoitukset: tavaraluettelo ─────────────────────────
    notify_clearedinv = 'Tavaraluettelo Tyhjennetty',
    notify_clearedinv_desc = 'Tyhjensit onnistuneesti pelaajan %s tavaraluettelon',

    -- ── Ilmoitukset: virheellinen ID ────────────────────────
    notify_invalidid = 'Virheellinen ID',
    notify_invalidid_desc = 'Antamasi ID oli virheellinen, yritä uudelleen.',

    -- ── Ilmoitukset: siivous ────────────────────────────────
    notify_deleted_car = 'Autot Poistettu',
    notify_deleted_car_desc = 'Poistit onnistuneesti kaikki autot ilman kuljettajaa.',
    notify_deleted_ped = 'Pedit Poistettu',
    notify_deleted_ped_desc = 'Poistit onnistuneesti kaikki pedit kartalta',
    notify_deleted_objects = 'Objektit Poistettu',
    notify_deleted_objects_desc = 'Poistit onnistuneesti kaikki objektit kartalta',

    -- ── Ilmoitukset: sää ────────────────────────────────────
    notify_weather = 'Sää Muutettu',
    notify_weather_desc = 'Sää muutettu: %s',

    -- ── Ilmoitukset: koordinaattien kopiointi ───────────────
    notify_copied = 'Kopioitu',
    notify_copied_vec3 = 'Vector3 kopioitiin leikepöydälle!',
    notify_copied_vec4 = 'Vector4 kopioitiin leikepöydälle!',
    notify_copied_headin = 'Suunta kopioitiin leikepöydälle!',

    -- ── Ilmoitukset: ovet ───────────────────────────────────
    notify_locked_doors = 'Lukittu',
    notify_locked_doors_desc = 'Ajoneuvon ovet lukittiin onnistuneesti.',
    notify_unlocked_doors = 'Avattu',
    notify_unlocked_doors_desc = 'Ajoneuvon ovet avattiin onnistuneesti.',

    -- ── Ilmoitukset: ylläpitoalueet ─────────────────────────
    notify_zone_deleted = 'Alue Poistettu',
    notify_zone_deleted_desc = 'Poistit onnistuneesti alueen: %s.',
    notify_zone_not_deleted_desc = 'Alueen poistamisessa tapahtui virhe: %s.',
    notify_zone_edited = 'Alue Muutettu',
    notify_zone_edited_desc = 'Muutit onnistuneesti aluetta: %s.',
    notify_zone_not_edited_desc = 'Alueen muuttamisessa tapahtui virhe: %s.',
    notify_zone_action_cancelled = 'Toiminto Peruutettu',
    notify_zone_delete_cancel = 'Peruutit alueen poistamisen: %s',
    notify_zone_no_weapons = 'Aseet Kielletty',
    notify_zone_no_weapons_desc = 'Sinulla ei ole lupaa käyttää aseita tällä alueella.',
    notify_zones_not_found = 'Ei Alueita',
    notify_zones_not_found_desc = 'Tällä hetkellä ei ole aktiivisia alueita hallittavaksi.',
    notify_zones_teleport = 'Teleportattu',
    notify_zones_teleport_desc = 'Teleporttasit onnistuneesti alueelle: %s.',

    -- ── Ilmoitukset: porttikiellon poisto ───────────────────
    successfully_unbanned = 'Porttikielto Peruttu',
    successfully_unbanned_desc = 'Poistit onnistuneesti porttikiellon: %s.',
    unsuccessful_unban = 'Jokin meni pieleen porttikieltoa poistettaessa: %s.',

    -- ── Yhteys (deferral) ───────────────────────────────────
    deferral_welcome = '[%s] Hei %s, tarkistetaan porttikieltoja. . .',
    deferral_banned = 'Sinulla on porttikielto tälle palvelimelle. Syy: "%s" (Aikaa jäljellä: %s tuntia %s minuuttia).',
    deferral_banned_perm = 'Sinulla on porttikielto tälle palvelimelle. Syy: "%s" (Aikaa jäljellä: Pysyvä).',

    -- ── Virheet ─────────────────────────────────────────────
    notify_error = 'Virhe',
    notify_disabled_keys = 'Ajoneuvon avainskriptiä ei ole määritetty. Ota yhteyttä palvelimen kehittäjään.',
    notify_no_appearance = 'Vaate-/ulkonäköskriptiä ei havaittu. Ota yhteyttä palvelimen kehittäjään.',
    notify_no_vehicle = 'Ajoneuvoa ei löytynyt!',
    notify_invalid_entry = 'Virheellinen syöte!',

    -- ── Pikanäppäin ─────────────────────────────────────────
    keymapping_desc = 'Avaa Ylläpitovalikko (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Käytössä',
    noclip_deactivated = 'NoClip Pois Käytöstä',

    -- ── Näkymättömyys ───────────────────────────────────────
    invisibility_activated = 'Näkymättömyystila Käytössä',
    invisibility_deactivated = 'Näkymättömyystila Pois Käytöstä',

    -- ── Jumaltila ───────────────────────────────────────────
    godmode_activated = 'Jumaltila Käytössä',
    godmode_deactivated = 'Jumaltila Pois Käytöstä',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Käytössä',
    wallhack_deactivated = 'Wallhack Pois Käytöstä',

    -- ── Debug-tila ──────────────────────────────────────────
    debug_activated = 'Debug-tila Käytössä',
    debug_deactivated = 'Debug-tila Pois Käytöstä',

    -- ── Ilmoitukset: ajoneuvot ──────────────────────────────
    vehicle_repaired = 'Ajoneuvo Korjattu',
    vehicle_repaired_desc = 'Ajoneuvo on korjattu onnistuneesti.',
    vehicle_deleted = 'Ajoneuvo Poistettu',
    vehicle_deleted_desc = 'Ajoneuvo on poistettu onnistuneesti.',
    vehicle_spawned = 'Ajoneuvo Luotu',
    vehicle_spawned_desc = 'Ajoneuvo %s luotiin onnistuneesti.',
    vehicle_plate_changed = 'Rekisterikilpi Vaihdettu',
    vehicle_plate_changed_desc = 'Ajoneuvon rekisterikilpi vaihdettu: %s',
    vehicle_refueled = 'Ajoneuvo Tankattu',
    vehicle_refueled_desc = 'Ajoneuvo on tankattu onnistuneesti.',
    vehicle_keys_given = 'Avaimet Saatu',
    vehicle_keys_given_desc = 'Sait avaimet ajoneuvoon, jonka rekisterikilpi on: %s',
    vehicle_color_changed = 'Ajoneuvon Väri Vaihdettu',
    vehicle_color_changed_desc = 'Ajoneuvon väri vaihdettu: %s',
    vehicle_torque_set = 'Vääntökerroin Asetettu',
    vehicle_torque_set_desc = 'Vääntö asetettu: %sx',
    vehicle_torque_disabled = 'Vääntökerroin Pois Käytöstä',

    -- ── Tarkkailu ───────────────────────────────────────────
    spectate_started = 'Tarkkaillaan',
    spectate_started_desc = 'Tarkkailet pelaajaa %s. Paina X lopettaaksesi.',
    spectate_ended = 'Tarkkailu Päättyi',
    spectate_ended_desc = 'Et tarkkaile enää ketään.',
    spectate_error = 'Tarkkailuvirhe',
    spectate_error_desc = 'Kohdepelaajaa ei löytynyt tai häntä ei enää ole.',

    -- ── Teleporttaus ────────────────────────────────────────
    teleport_success = 'Teleportattu',
    teleport_success_desc = 'Sinut on teleportattu onnistuneesti.',

    -- ── Elvytys / parannus ──────────────────────────────────
    player_revived = 'Pelaaja Elvytetty',
    player_revived_desc = 'Elvytit onnistuneesti pelaajan %s.',
    player_healed = 'Pelaaja Parannettu',
    player_healed_desc = 'Paransit onnistuneesti pelaajan %s.',
    self_revived = 'Elvytetty',
    self_revived_desc = 'Elvytit itsesi.',
    self_healed = 'Parannettu',
    self_healed_desc = 'Paransit itsesi.',

    -- ── Pedit ───────────────────────────────────────────────
    ped_changed = 'Ped Vaihdettu',
    ped_changed_desc = 'Ped-mallisi on vaihdettu.',
    ped_restored = 'Ped Palautettu',
    ped_restored_desc = 'Alkuperäinen ped-mallisi on palautettu.',

    skin_menu_opened = 'Vaatevalikko Avattu',

    admin_menu_opened = 'Ylläpitovalikko Avattu',
    admin_menu_closed = 'Ylläpitovalikko Suljettu',

    entity_deleted = 'Entiteetti Poistettu',
    entity_deleted_desc = 'Entiteetti on poistettu onnistuneesti.',

    player_frozen = 'Pelaaja Jäädytetty',
    player_frozen_desc = 'Pelaaja %s on jäädytetty.',
    player_unfrozen = 'Pelaajan Jäädytys Poistettu',
    player_unfrozen_desc = 'Pelaajan %s jäädytys on poistettu.',

    -- ── Oma rekisterikilpi ──────────────────────────────────
    dialog_license_plate = 'Oma Rekisterikilpi',
    dialog_license_plate_label = 'Kilpi',
    dialog_license_plate_placeholder = 'Rekisterikilpi',

    -- ── Rahan ottaminen ─────────────────────────────────────
    player_removemoney = 'Ota Rahaa',
    player_removemoney_desc = 'Ota rahaa valitulta pelaajalta',
    dialog_removemoney = 'Ota Rahaa',
    removemoney_input_label = 'Summa',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Tili',
    notify_removemoney_success = 'Raha Otettu',
    notify_removemoney_success_desc = 'Otit $%s pelaajalta %s (tili: %s)',
    notify_removemoney_fail = 'Epäonnistui',
    notify_removemoney_fail_desc = 'Rahaa ei voitu ottaa pelaajalta %s (ehkä katetta ei ole).',

    -- ── Ulottuvuudet / routing bucketit ─────────────────────
    self_dimension = 'Aseta Oma Ulottuvuus',
    self_dimension_desc = 'Siirrä itsesi routing bucketiin (0 = päämaailma)',
    player_dimension = 'Aseta Ulottuvuus',
    player_dimension_desc = 'Siirrä tämä pelaaja routing bucketiin',
    player_dimension_bring = 'Tuo Omaan Ulottuvuuteeni',
    player_dimension_bring_desc = 'Vedä tämä pelaaja nykyiseen ulottuvuuteesi',
    player_dimension_goto = 'Liity Pelaajan Ulottuvuuteen',
    player_dimension_goto_desc = 'Siirrä itsesi tämän pelaajan ulottuvuuteen',
    dialog_dimension = 'Aseta Ulottuvuus',
    dimension_input_label = 'Ulottuvuus (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Ulottuvuus Vaihdettu',
    notify_dimension_self_desc = 'Olet nyt ulottuvuudessa %s.',
    notify_dimension_player_desc = '%s siirrettiin ulottuvuuteen %s.',
    notify_dimension_join_desc = 'Liityit pelaajan %s ulottuvuuteen (%s).',
    notify_dimension_fail = 'Ulottuvuusvirhe',
    notify_dimension_fail_desc = 'Ulottuvuutta ei voitu vaihtaa.',

    -- ── Teleporttaus ajoneuvoon ─────────────────────────────
    player_tp_vehicle = 'Teleporttaa Ajoneuvoon',
    player_tp_vehicle_desc = 'Siirry tämän pelaajan ajoneuvoon auttaaksesi sen pelastamisessa',
    notify_tp_vehicle_fail = 'Ei Ajoneuvoa',
    notify_tp_vehicle_fail_desc = '%s ei ole ajoneuvossa.',
    notify_tp_vehicle_success = 'Teleportattu',
    notify_tp_vehicle_success_desc = 'Sinut siirrettiin pelaajan %s ajoneuvoon.',

    -- ── Ajoneuvon pelastus ──────────────────────────────────
    recover_car = 'Pelasta / Käännä Ajoneuvo',
    recover_car_desc = 'Käännä pyörilleen ja siirrä lähimmälle tielle (meri/kaatunut)',
    vehicle_recovered = 'Ajoneuvo Pelastettu',
    vehicle_recovered_desc = 'Ajoneuvo käännettiin pyörilleen ja siirrettiin lähimmälle tielle.',

    -- ── Omistetut ajoneuvot ─────────────────────────────────
    player_owned_vehicles = 'Omistetut Ajoneuvot',
    player_owned_vehicles_desc = 'Katso, lisää tai poista tämän pelaajan autoja',
    owned_vehicles_menu = 'Omistetut Ajoneuvot (%s)',
    owned_vehicles_add = 'Lisää Ajoneuvo',
    owned_vehicles_add_desc = 'Lisää ajoneuvo tämän pelaajan talliin',
    owned_vehicles_none = 'Ei Ajoneuvoja',
    owned_vehicles_none_desc = 'Tämä pelaaja ei omista yhtään ajoneuvoa.',
    owned_vehicle_desc = 'Rekisterikilpi: %s · napsauta poistaaksesi',
    dialog_add_vehicle = 'Lisää Ajoneuvo',
    add_vehicle_model_label = 'Mallin Nimi',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Rekisterikilpi (valinnainen)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = 'Poistetaanko %s?',
    notify_owned_added = 'Ajoneuvo Lisätty',
    notify_owned_added_desc = 'Lisättiin %s (kilpi %s) pelaajalle %s.',
    notify_owned_removed = 'Ajoneuvo Poistettu',
    notify_owned_removed_desc = 'Poistettiin kilpi %s pelaajalta %s.',
    notify_owned_fail = 'Tietokantavirhe',
    notify_owned_fail_desc = 'Ajoneuvojen tietokantatoiminto epäonnistui.',

    -- ── Ped-valikko ─────────────────────────────────────────
    player_pedmenu = 'Anna Ped-valikko',
    player_pedmenu_desc = 'Avaa ped-valintavalikko tämän pelaajan ruudulle',
    pedmenu_title = 'Ped-valikko',
    pedmenu_given = 'Ped-valikko Lähetetty',
    pedmenu_given_desc = 'Ped-valikko avattiin pelaajalle %s.'
}
