-- ============================================================
-- ITALIANO (it)
-- ------------------------------------------------------------
-- Sovrapposizione a configs/strings.lua. Ogni chiave mancante
-- qui conserva il testo inglese, quindi tradurre a pezzi è sicuro.
--
-- I segnaposto %s vanno mantenuti e nello STESSO ordine
-- dell'originale: vengono riempiti da :format() nel codice.
-- %% stampa un segno di percentuale letterale.
--
-- Attivazione:  Config.Locale = 'it'   (configs/config.lua)
-- ============================================================

Locales = Locales or {}

Locales['it'] = {
    -- ── Menu principale ─────────────────────────────────────
    main_title = 'Menu Amministrazione',
    self_options = 'Opzioni Personali',
    self_options_desc = 'Opzioni che riguardano te',
    player_options_title = 'Opzioni Giocatore',
    player_options_desc = 'Opzioni che riguardano gli altri giocatori',
    vehicle_options = 'Opzioni Veicolo',
    vehicle_options_desc = 'Opzioni che riguardano i veicoli',
    server_options = 'Opzioni Server',
    server_options_desc = 'Opzioni che riguardano il server',
    admin_zone_options = 'Zone Admin',
    admin_zone_options_desc = 'Gestire, aggiungere ed eliminare zone admin',
    developer_options = 'Opzioni Sviluppatore',
    developer_options_desc = '',

    -- ── Opzioni personali ───────────────────────────────────
    self_options_menu = 'Opzioni Personali',
    self_health = 'Vita (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Rianima',
    self_revive_desc = 'Rianima te stesso',
    self_heal = 'Cura',
    self_heal_desc = 'Cura te stesso',
    self_skinmenu = 'Menu Abbigliamento',
    self_set_ped = 'Cambia Ped',
    self_skinmenu_desc = 'Apri il menu abbigliamento in locale',
    self_invisible = 'Invisibile',
    self_godmode = 'Modalità Dio',
    self_wallhack = 'Wallhack',

    -- ── Opzioni giocatore ───────────────────────────────────
    player_options_menu = 'Giocatori Online %s/%s',
    player_options = 'Giocatore: %s',
    player_health = 'Vita del Giocatore (%s%%)',
    player_freeze = 'Congela',
    player_freeze_desc = 'Attiva/disattiva',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Attiva/disattiva',
    player_spectate = 'Osserva',
    player_spectate_desc = 'Guarda le azioni di questo giocatore',
    player_playerdata = 'Dati del Giocatore',
    player_playerdata_desc = 'Vedi i dati del giocatore',
    player_revive = 'Rianima',
    player_revive_desc = 'Rianima il giocatore',
    player_heal = 'Cura',
    player_heal_desc = 'Cura il giocatore',
    player_skinmenu = 'Menu Abbigliamento',
    player_skinmenu_desc = 'Apri un menu abbigliamento sul giocatore',
    player_money = 'Dai Denaro',
    player_money_desc = 'Dai denaro al giocatore selezionato',
    player_item = 'Dai Oggetto',
    player_item_desc = 'Dai un oggetto al giocatore selezionato',
    player_openinv = 'Apri Inventario',
    player_openinv_desc = 'Apri l\'inventario del giocatore',
    player_clearinv = 'Svuota Inventario',
    player_clearinv_desc = 'Svuota l\'inventario del giocatore',
    player_teleport_to = 'Teletrasportati dal Giocatore',
    player_teleport_to_desc = 'Teletrasportati dal giocatore',
    player_bring = 'Porta Qui',
    player_bring_desc = 'Porta il giocatore alla tua posizione',
    player_kick = 'Espelli',
    player_kick_desc = 'Espelli il giocatore dal server',
    player_ban = 'Banna Giocatore',

    -- ── Menu veicolo ────────────────────────────────────────
    vehicle_menu = 'Menu Veicolo',
    spawn_car = 'Genera Veicolo',
    spawn_car_desc = 'Genera un veicolo',
    repair_car = 'Ripara Veicolo',
    repair_car_desc = 'Ripara il veicolo attuale o il più vicino',
    delete_car = 'Elimina Veicolo',
    delete_car_desc = 'Elimina il veicolo attuale o il più vicino',
    number_plate = 'Modifica Targa',
    number_plate_desc = 'Cambia il testo della targa attuale',
    refuel = 'Rifornisci Veicolo',
    refuel_desc = 'Rifornisci il veicolo attuale o il più vicino',
    give_keys = 'Dai le Chiavi',
    give_keys_desc = 'Dai a te stesso le chiavi del veicolo attuale',
    doors = 'Blocca/Sblocca Portiere',
    doors_desc = 'Commuta le serrature del veicolo più vicino',
    boost_car = 'Moltiplicatore di Coppia',
    boost_car_desc = 'Modifica la coppia del veicolo attuale',
    color_change = 'Cambia Colore Veicolo',
    color_change_desc = 'Cambia il colore del veicolo attuale o il più vicino',

    -- ── Gestione del server ─────────────────────────────────
    server_management = 'Gestione del Server',
    server_announcement = 'Annuncio del Server',
    server_announcement_desc = 'Invia un annuncio globale a tutto il server',
    ban_list = 'Lista Ban',
    ban_list_desc = 'Consulta tutti i ban attivi',
    objects_list = 'Elimina Entità',
    objects_list_desc = 'Elimina veicoli e ped',
    objects_list_label = 'Opzioni',
    weather_menu = 'Gestione del Meteo',
    weather_menu_desc = 'Gestisci il meteo',

    -- ── Zone admin ──────────────────────────────────────────
    zones_create = 'Crea Zona',
    zones_create_desc = 'Crea una nuova zona admin',
    zones_manage = 'Gestisci Zone',
    zones_manage_desc = 'Modifica o elimina le zone attive',
    zone_edit_current = 'Modifica Zona Attuale',
    zone_edit_current_desc = 'Gestisci la zona in cui ti trovi',
    zone_delete_current = 'Elimina Zona Attuale',
    zone_delete_current_desc = 'Elimina la zona in cui ti trovi',
    zone_manage_menu = 'Modifica Zona (%s)',
    zone_edit = 'Modifica Zona',
    zone_edit_desc = 'Modifica la zona: %s',
    zone_delete = 'Elimina Zona',
    zone_delete_desc = 'Elimina la zona: %s',
    zone_teleport = 'Teletrasportati alla Zona',
    zone_teleport_desc = 'Vai alla zona: %s',

    -- ── Menu sviluppatore ───────────────────────────────────
    dev_options = 'Opzioni Sviluppatore',
    debug_mode = 'Modalità Debug',
    debug_mode_desc = 'Attiva/disattiva la modalità debug',
    copy_vec3 = 'Copia Coordinate Vector3',
    copy_vec3_desc = 'Copia la tua posizione attuale (vector3) negli appunti',
    copy_vec4 = 'Copia Coordinate Vector4',
    copy_vec4_desc = 'Copia la tua posizione attuale (vector4) negli appunti',
    copy_heading = 'Copia Orientamento',
    copy_heading_desc = 'Copia il tuo orientamento attuale negli appunti',
    cant_delete = 'Impossibile eliminare!',
    cant_delete_player_desc = 'Non puoi eliminare i ped dei giocatori!',
    cant_delete_entity_desc = 'Non puoi eliminare gli oggetti predefiniti della mappa!',

    -- ── Lista ban ───────────────────────────────────────────
    ban_list_menu = 'Lista Ban',
    ban_list_name = 'Nome: %s',
    ban_list_license = 'Licenza:',
    ban_list_by = 'Emesso da: %s',
    ban_list_reason = 'Motivo: %s',
    ban_list_length = 'Tempo rimanente: %s ore %s minuti',
    ban_list_modify = 'Modifica Ban',
    ban_list_unban = 'Sbanna Giocatore',
    ban_list_no_data = 'Nessun Ban',
    ban_list_no_data_desc = 'Non è stato trovato nessun ban attivo!',

    -- ── Dati del giocatore ──────────────────────────────────
    playerdata_menu = 'Dati del Giocatore',
    playerdata_license_esx = 'Licenza: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Clicca per copiare la licenza completa',
    playerdata_igname = 'Nome: %s',
    playerdata_igname_desc = 'Nome completo del giocatore in gioco',
    playerdata_steam = 'Nome Steam: %s',
    playerdata_steam_desc = 'Nome Steam completo del giocatore',
    playerdata_gender = 'Sesso: %s',
    playerdata_gender_desc = 'Sesso del giocatore',
    playerdata_cash = 'Contanti: %s',
    playerdata_cash_desc = 'Saldo in contanti del giocatore',
    playerdata_bank = 'Banca: %s',
    playerdata_bank_desc = 'Saldo bancario del giocatore',
    playerdata_blackmoney = 'Denaro Sporco: %s',
    playerdata_blackmoney_desc = 'Saldo di denaro sporco del giocatore',

    -- ── TextUI ──────────────────────────────────────────────
    debug_textui_name = 'Premi [E] per eliminare l\'entità  \nHash: %s  \nCoordinate: vec3(%s, %s, %s)  \nOrientamento: %s  \nProprietario: [%s] - %s',
    debug_textui_noname = 'Premi [E] per eliminare l\'entità\n  Hash: %s\n  Coordinate: vec3(%s, %s, %s)\n  Orientamento: %s\n  Proprietario: SCONOSCIUTO',

    textui_invisible = 'Modalità Invisibile - Attiva',
    textui_godmode = 'Modalità Dio - Attiva',
    textui_wallhack = 'Wallhack - Attivo',
    textui_noclip_activated = 'No Clip - Attivo',
    textui_torque = 'Moltiplicatore di Coppia - %s',

    -- ── Annunci ─────────────────────────────────────────────
    dialog_announce = 'Annuncio',
    dialog_announce_label = 'Messaggio',
    dialog_announce_select = 'Tutti',
    dialog_announce_everyone = 'Tutti',
    dialog_announce_placeholder = 'Messaggio importante qui. . .',

    -- ── Sban ────────────────────────────────────────────────
    dialog_unban = 'Sei sicuro?',
    dialog_unban_content = 'Vuoi davvero sbannare %s?',

    -- ── Eliminazione entità ─────────────────────────────────
    dialog_objects = 'Scegli un\'opzione',
    dialog_clear_objects = 'Elimina TUTTI gli oggetti',
    dialog_clear_cars = 'Elimina TUTTE le auto (senza conducente)',
    dialog_clear_peds = 'Elimina TUTTI i ped',

    -- ── Dai denaro ──────────────────────────────────────────
    dialog_givemoney = 'Dai Denaro',
    givemoney_input_label = 'Importo',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Conto',
    givemoney_select_option1 = 'Contanti',
    givemoney_select_option2 = 'Banca',
    givemoney_select_option3 = 'Denaro Sporco',

    -- ── Dai oggetto ─────────────────────────────────────────
    dialog_giveitem = 'Dai Oggetto',
    giveitem_input_label = 'Nome Oggetto',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Quantità',
    giveitem_amount_input_placeholder = '3',

    -- ── Genera veicolo ──────────────────────────────────────
    dialog_spawn_a_car = 'Genera Veicolo',
    dialog_car_model = 'Nome del Modello',
    dialog_car_model_holder = 'Es: 20charger',
    dialog_car_plate = 'Targa (facoltativo)',
    dialog_car_plate_holder = 'Es: W4S4B1',
    dialog_car_color_primary = 'Colore Primario (facoltativo)',
    dialog_car_color_second = 'Colore Secondario (facoltativo)',
    dialog_car_maxed = 'Modifiche al Massimo (facoltativo)',

    -- ── Espulsione ──────────────────────────────────────────
    dialog_kick = 'Espelli %s',
    dialog_kick_reason = 'Motivo',
    dialog_kick_placeholder = 'Cheater',
    kicked_reason_replace = 'Sei stato espulso dal server!',

    -- ── Ban ─────────────────────────────────────────────────
    dialog_ban = 'Banna %s',
    dialog_ban_reason = 'Motivo',
    dialog_ban_placeholder = 'Cheater',
    ban_reason_replace = 'Sei stato bannato da questo server!',

    -- ── Creazione zona ──────────────────────────────────────
    dialog_zone_create = 'Creazione Zona',
    dialog_zone_name = 'Nome',
    dialog_zone_name_desc = 'Il nome della zona / del blip',
    dialog_zone_name_holder = 'Zona Admin',
    dialog_zone_text = 'Testo Visualizzato',
    dialog_zone_text_desc = 'Il testo mostrato ai giocatori dentro la zona',
    dialog_zone_text_holder = 'ZONA ADMIN - ATTIVA',
    dialog_zone_size = 'Dimensione',
    dialog_zone_speed = 'Limite di Velocità',
    mph = 'MPH',
    kmh = 'KM/H',
    dialog_zone_blip_id = 'ID del Blip',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'ID Colore',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Blip Lampeggiante',
    dialog_zone_disarm = 'Disarma',
    dialog_zone_revive = 'Rianima',
    dialog_zone_invincible = 'Invincibile',
    dialog_zone_edit = 'Modifica di «%s»',
    dialog_zone_delete_confirm = 'Sei sicuro?',
    dialog_zone_delete_confirm_desc = 'Vuoi davvero eliminare la zona: %s',

    -- ── Notifiche: denaro ───────────────────────────────────
    notify_givemoney_success = 'Denaro Accreditato',
    notify_givemoney_success_desc = 'Hai accreditato a %s $%s sul conto: %s',
    notify_givemoney_fail = 'Non riuscito',
    notify_givemoney_fail_desc = 'Hai provato ad accreditare %s ma qualcosa è andato storto! Riprova.',

    -- ── Notifiche: oggetti ──────────────────────────────────
    notify_giveitem_success = 'Oggetto Consegnato',
    notify_giveitem_success_desc = 'Hai accreditato %s. Oggetto: %s Quantità: %s',
    notify_giveitem_fail = 'Fallito',
    notify_giveitem_fail_desc = 'Hai provato ad accreditare %s ma qualcosa è andato storto! Riprova.',

    -- ── Notifiche: espulsione / ban ─────────────────────────
    notify_kicked_success = 'Espulsione Riuscita',
    notify_kicked_success_desc = 'Hai espulso %s con successo',
    notify_banned_success = 'Ban Riuscito',
    notify_banned_success_desc = 'Hai bannato %s con successo',

    -- ── Notifiche: inventario ───────────────────────────────
    notify_clearedinv = 'Inventario Svuotato',
    notify_clearedinv_desc = 'Hai svuotato con successo l\'inventario di %s',

    -- ── Notifiche: ID non valido ────────────────────────────
    notify_invalidid = 'ID Non Valido',
    notify_invalidid_desc = 'L\'ID inserito non è valido, riprova.',

    -- ── Notifiche: pulizia ──────────────────────────────────
    notify_deleted_car = 'Auto Eliminate',
    notify_deleted_car_desc = 'Hai eliminato con successo tutte le auto senza conducente.',
    notify_deleted_ped = 'Ped Eliminati',
    notify_deleted_ped_desc = 'Hai eliminato con successo tutti i ped sulla mappa',
    notify_deleted_objects = 'Oggetti Eliminati',
    notify_deleted_objects_desc = 'Hai eliminato con successo tutti gli oggetti sulla mappa',

    -- ── Notifiche: meteo ────────────────────────────────────
    notify_weather = 'Meteo Modificato',
    notify_weather_desc = 'Meteo cambiato in: %s',

    -- ── Notifiche: copia coordinate ─────────────────────────
    notify_copied = 'Copiato',
    notify_copied_vec3 = 'Vector3 copiato negli appunti!',
    notify_copied_vec4 = 'Vector4 copiato negli appunti!',
    notify_copied_headin = 'Orientamento copiato negli appunti!',

    -- ── Notifiche: portiere ─────────────────────────────────
    notify_locked_doors = 'Bloccato',
    notify_locked_doors_desc = 'Portiere del veicolo bloccate con successo.',
    notify_unlocked_doors = 'Sbloccato',
    notify_unlocked_doors_desc = 'Portiere del veicolo sbloccate con successo.',

    -- ── Notifiche: zone admin ───────────────────────────────
    notify_zone_deleted = 'Zona Eliminata',
    notify_zone_deleted_desc = 'Hai rimosso con successo la zona: %s.',
    notify_zone_not_deleted_desc = 'Si è verificato un errore durante l\'eliminazione della zona: %s.',
    notify_zone_edited = 'Zona Modificata',
    notify_zone_edited_desc = 'Hai modificato con successo la zona: %s.',
    notify_zone_not_edited_desc = 'Si è verificato un errore durante la modifica della zona: %s.',
    notify_zone_action_cancelled = 'Azione Annullata',
    notify_zone_delete_cancel = 'Hai annullato l\'eliminazione della zona: %s',
    notify_zone_no_weapons = 'Armi Non Autorizzate',
    notify_zone_no_weapons_desc = 'Non ti è permesso usare armi all\'interno di questa zona.',
    notify_zones_not_found = 'Nessuna Zona',
    notify_zones_not_found_desc = 'Al momento non ci sono zone attive da gestire.',
    notify_zones_teleport = 'Teletrasportato',
    notify_zones_teleport_desc = 'Ti sei teletrasportato con successo alla zona: %s.',

    -- ── Notifiche: sban ─────────────────────────────────────
    successfully_unbanned = 'Ban Revocato',
    successfully_unbanned_desc = 'Hai sbannato con successo: %s.',
    unsuccessful_unban = 'Qualcosa è andato storto sbannando: %s.',

    -- ── Connessione (deferral) ──────────────────────────────
    deferral_welcome = '[%s] Ciao %s, controllo dei ban in corso. . .',
    deferral_banned = 'Sei bannato dal server. Motivo: «%s» (Tempo rimanente: %s ore %s minuti).',
    deferral_banned_perm = 'Sei bannato dal server. Motivo: «%s» (Tempo rimanente: Permanente).',

    -- ── Errori ──────────────────────────────────────────────
    notify_error = 'Errore',
    notify_disabled_keys = 'Non è configurato nessuno script per le chiavi dei veicoli. Contatta lo sviluppatore del server.',
    notify_no_appearance = 'Nessuno script di abbigliamento / aspetto rilevato. Contatta lo sviluppatore del server.',
    notify_no_vehicle = 'Nessun veicolo trovato!',
    notify_invalid_entry = 'Voce non valida!',

    -- ── Scorciatoia da tastiera ─────────────────────────────
    keymapping_desc = 'Apri il Menu Amministrazione (apex_adminmenu)',

    -- ── No Clip ─────────────────────────────────────────────
    noclip_activated = 'NoClip Attivato',
    noclip_deactivated = 'NoClip Disattivato',

    -- ── Invisibilità ────────────────────────────────────────
    invisibility_activated = 'Modalità Invisibile Attivata',
    invisibility_deactivated = 'Modalità Invisibile Disattivata',

    -- ── Modalità Dio ────────────────────────────────────────
    godmode_activated = 'Modalità Dio Attivata',
    godmode_deactivated = 'Modalità Dio Disattivata',

    -- ── Wallhack ────────────────────────────────────────────
    wallhack_activated = 'Wallhack Attivato',
    wallhack_deactivated = 'Wallhack Disattivato',

    -- ── Modalità debug ──────────────────────────────────────
    debug_activated = 'Modalità Debug Attivata',
    debug_deactivated = 'Modalità Debug Disattivata',

    -- ── Notifiche: veicoli ──────────────────────────────────
    vehicle_repaired = 'Veicolo Riparato',
    vehicle_repaired_desc = 'Il veicolo è stato riparato con successo.',
    vehicle_deleted = 'Veicolo Eliminato',
    vehicle_deleted_desc = 'Il veicolo è stato eliminato con successo.',
    vehicle_spawned = 'Veicolo Generato',
    vehicle_spawned_desc = 'Il veicolo %s è stato generato con successo.',
    vehicle_plate_changed = 'Targa Modificata',
    vehicle_plate_changed_desc = 'Targa del veicolo cambiata in: %s',
    vehicle_refueled = 'Veicolo Rifornito',
    vehicle_refueled_desc = 'Il veicolo è stato rifornito con successo.',
    vehicle_keys_given = 'Chiavi Ricevute',
    vehicle_keys_given_desc = 'Hai ricevuto le chiavi del veicolo con targa: %s',
    vehicle_color_changed = 'Colore del Veicolo Cambiato',
    vehicle_color_changed_desc = 'Colore del veicolo cambiato in: %s',
    vehicle_torque_set = 'Moltiplicatore di Coppia Impostato',
    vehicle_torque_set_desc = 'Coppia impostata a: %sx',
    vehicle_torque_disabled = 'Moltiplicatore di Coppia Disattivato',

    -- ── Osservazione ────────────────────────────────────────
    spectate_started = 'In Osservazione',
    spectate_started_desc = 'Stai osservando %s. Premi X per uscire.',
    spectate_ended = 'Osservazione Terminata',
    spectate_ended_desc = 'Non stai più osservando nessuno.',
    spectate_error = 'Errore di Osservazione',
    spectate_error_desc = 'Giocatore bersaglio non trovato o non più esistente.',

    -- ── Teletrasporto ───────────────────────────────────────
    teleport_success = 'Teletrasportato',
    teleport_success_desc = 'Sei stato teletrasportato con successo.',

    -- ── Rianimazione / cura ─────────────────────────────────
    player_revived = 'Giocatore Rianimato',
    player_revived_desc = 'Hai rianimato con successo %s.',
    player_healed = 'Giocatore Curato',
    player_healed_desc = 'Hai curato con successo %s.',
    self_revived = 'Rianimato',
    self_revived_desc = 'Ti sei rianimato.',
    self_healed = 'Curato',
    self_healed_desc = 'Ti sei curato.',

    -- ── Ped ─────────────────────────────────────────────────
    ped_changed = 'Ped Cambiato',
    ped_changed_desc = 'Il tuo modello di ped è stato cambiato.',
    ped_restored = 'Ped Ripristinato',
    ped_restored_desc = 'Il tuo modello di ped originale è stato ripristinato.',

    skin_menu_opened = 'Menu Abbigliamento Aperto',

    admin_menu_opened = 'Menu Admin Aperto',
    admin_menu_closed = 'Menu Admin Chiuso',

    entity_deleted = 'Entità Eliminata',
    entity_deleted_desc = 'L\'entità è stata eliminata con successo.',

    player_frozen = 'Giocatore Congelato',
    player_frozen_desc = 'Il giocatore %s è stato congelato.',
    player_unfrozen = 'Giocatore Scongelato',
    player_unfrozen_desc = 'Il giocatore %s è stato scongelato.',

    -- ── Targa personalizzata ────────────────────────────────
    dialog_license_plate = 'Targa Personalizzata',
    dialog_license_plate_label = 'Targa',
    dialog_license_plate_placeholder = 'Targa',

    -- ── Togli denaro ────────────────────────────────────────
    player_removemoney = 'Togli Denaro',
    player_removemoney_desc = 'Togli denaro al giocatore selezionato',
    dialog_removemoney = 'Togli Denaro',
    removemoney_input_label = 'Importo',
    removemoney_input_placeholder = '123456',
    removemoney_select = 'Conto',
    notify_removemoney_success = 'Denaro Tolto',
    notify_removemoney_success_desc = 'Hai tolto $%s a %s (conto: %s)',
    notify_removemoney_fail = 'Non riuscito',
    notify_removemoney_fail_desc = 'Impossibile togliere denaro a %s (forse fondi insufficienti).',

    -- ── Dimensioni / routing bucket ─────────────────────────
    self_dimension = 'Imposta la Mia Dimensione',
    self_dimension_desc = 'Spostati in un routing bucket (0 = mondo principale)',
    player_dimension = 'Imposta Dimensione',
    player_dimension_desc = 'Sposta questo giocatore in un routing bucket',
    player_dimension_bring = 'Porta nella Mia Dimensione',
    player_dimension_bring_desc = 'Tira questo giocatore nella tua dimensione attuale',
    player_dimension_goto = 'Entra nella Dimensione del Giocatore',
    player_dimension_goto_desc = 'Spostati nella dimensione di questo giocatore',
    dialog_dimension = 'Imposta Dimensione',
    dimension_input_label = 'Dimensione (routing bucket)',
    dimension_input_placeholder = '0',
    notify_dimension = 'Dimensione Cambiata',
    notify_dimension_self_desc = 'Ora sei nella dimensione %s.',
    notify_dimension_player_desc = '%s è stato spostato nella dimensione %s.',
    notify_dimension_join_desc = 'Sei entrato nella dimensione di %s (%s).',
    notify_dimension_fail = 'Errore di Dimensione',
    notify_dimension_fail_desc = 'Impossibile cambiare dimensione.',

    -- ── Teletrasporto nel veicolo ───────────────────────────
    player_tp_vehicle = 'Teletrasportati nel Veicolo',
    player_tp_vehicle_desc = 'Entra nel veicolo di questo giocatore per aiutarlo a recuperarlo',
    notify_tp_vehicle_fail = 'Nessun Veicolo',
    notify_tp_vehicle_fail_desc = '%s non è in un veicolo.',
    notify_tp_vehicle_success = 'Teletrasportato',
    notify_tp_vehicle_success_desc = 'Sei stato messo dentro il veicolo di %s.',

    -- ── Recupero veicolo ────────────────────────────────────
    recover_car = 'Recupera / Raddrizza Veicolo',
    recover_car_desc = 'Raddrizza e sposta sulla strada più vicina (mare/ribaltato)',
    vehicle_recovered = 'Veicolo Recuperato',
    vehicle_recovered_desc = 'Il veicolo è stato raddrizzato e messo sulla strada più vicina.',

    -- ── Veicoli posseduti ───────────────────────────────────
    player_owned_vehicles = 'Veicoli Posseduti',
    player_owned_vehicles_desc = 'Vedi, aggiungi o rimuovi le auto di questo giocatore',
    owned_vehicles_menu = 'Veicoli Posseduti (%s)',
    owned_vehicles_add = 'Aggiungi Veicolo',
    owned_vehicles_add_desc = 'Aggiungi un veicolo al garage di questo giocatore',
    owned_vehicles_none = 'Nessun Veicolo',
    owned_vehicles_none_desc = 'Questo giocatore non possiede nessun veicolo.',
    owned_vehicle_desc = 'Targa: %s · clicca per rimuovere',
    dialog_add_vehicle = 'Aggiungi Veicolo',
    add_vehicle_model_label = 'Nome del Modello',
    add_vehicle_model_placeholder = 'adder',
    add_vehicle_plate_label = 'Targa (facoltativo)',
    add_vehicle_plate_placeholder = 'ADMIN1',
    dialog_remove_vehicle = 'Rimuovere %s?',
    notify_owned_added = 'Veicolo Aggiunto',
    notify_owned_added_desc = 'Aggiunto %s (targa %s) a %s.',
    notify_owned_removed = 'Veicolo Rimosso',
    notify_owned_removed_desc = 'Rimossa la targa %s da %s.',
    notify_owned_fail = 'Errore del Database',
    notify_owned_fail_desc = 'L\'operazione sul database dei veicoli è fallita.',

    -- ── Menu ped ────────────────────────────────────────────
    player_pedmenu = 'Dai Menu Ped',
    player_pedmenu_desc = 'Apri un menu di selezione ped sullo schermo di questo giocatore',
    pedmenu_title = 'Menu Ped',
    pedmenu_given = 'Menu Ped Inviato',
    pedmenu_given_desc = 'Menu ped aperto per %s.'
}
