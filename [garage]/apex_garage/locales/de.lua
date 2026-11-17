--[[ apex_garage — locales/de.lua

    German (informal "du"). Mirrors locales/en.lua key by key.
    shared/utils.lua falls back to Locales.dict['en'] per key, but this file is
    complete — nothing should ever fall through.

    Format specifiers are load-bearing — keep them exactly:
        ui_sell_confirm  %s (vehicle), %s (price)
        ui_hours         %s (hours)
        n_paid_fee       %s (amount)
        n_sold           $%s (amount)
]]

Locales = Locales or {}
Locales.dict = Locales.dict or {}

Locales.dict['de'] = {
    -- ─────────────────────────────────────────────────────────────
    -- Prompts (TextUI / target labels)
    -- ─────────────────────────────────────────────────────────────
    prompt_open      = 'Garage öffnen',
    prompt_store     = 'Fahrzeug einparken',
    prompt_impound   = 'Verwahrstelle',

    -- TextUI sentence: <prefix> [E] <suffix> <lowercased prompt_*>
    -- e.g. "Drücke [E] zum garage öffnen"
    ui_press_prefix  = 'Drücke',
    ui_press_suffix  = 'zum',

    -- ─────────────────────────────────────────────────────────────
    -- UI — shell, lists and filters
    -- ─────────────────────────────────────────────────────────────
    ui_garage        = 'GARAGE',
    ui_impound       = 'VERWAHRSTELLE',
    ui_search        = 'Nach Name oder Kennzeichen suchen…',
    ui_cash          = 'Bargeld',
    ui_bank          = 'Bank',
    ui_all           = 'Alle',
    ui_empty         = 'Du hast keine Fahrzeuge in dieser Garage.',
    ui_empty_impound = 'Keine beschlagnahmten Fahrzeuge.',
    ui_sort_name     = 'Name (A-Z)',
    ui_sort_status   = 'Status',
    ui_confirm       = 'Bestätigen',
    ui_cancel        = 'Abbrechen',
    ui_fee           = 'Gebühr',

    -- ─────────────────────────────────────────────────────────────
    -- UI — vehicle card
    -- ─────────────────────────────────────────────────────────────
    ui_nickname       = 'Spitzname',
    ui_nickname_set   = 'Spitzname festlegen',
    ui_nickname_ph    = 'Fahrzeug-Spitzname',
    ui_fuel           = 'Tank',
    ui_engine         = 'Motor',
    ui_body           = 'Karosserie',
    ui_status_stored  = 'In der Garage',
    ui_status_out     = 'Draußen',
    ui_status_impound = 'Beschlagnahmt',
    ui_financed       = 'Wird finanziert',

    -- ─────────────────────────────────────────────────────────────
    -- UI — vehicle actions
    -- ─────────────────────────────────────────────────────────────
    ui_drive         = 'Rausholen',
    ui_return_drive  = 'Auslösen & fahren',
    ui_transfer      = 'Übertragen',
    ui_release       = 'An Besitzer zurückgeben',
    ui_recover       = 'Auslösen',
    ui_sell          = 'Verkaufen',
    ui_sell_title    = 'Fahrzeug verkaufen',
    ui_sell_confirm  = 'Du verkaufst gleich %s für %s. Das lässt sich nicht rückgängig machen.',

    -- ─────────────────────────────────────────────────────────────
    -- UI — transfer flow
    -- ─────────────────────────────────────────────────────────────
    ui_transfer_title       = 'Fahrzeug übertragen',
    ui_transfer_garage      = 'In eine andere Garage',
    ui_transfer_player      = 'An einen anderen Spieler',
    ui_transfer_pick_garage = 'Wähle die Zielgarage',
    ui_transfer_pick_player = 'Spieler in der Nähe',
    ui_transfer_no_players  = 'Niemand in der Nähe.',

    -- ─────────────────────────────────────────────────────────────
    -- UI — impound flow (police / admin side)
    -- ─────────────────────────────────────────────────────────────
    ui_impound_title       = 'Fahrzeug beschlagnahmen',
    ui_impound_reason      = 'Grund',
    ui_impound_reason_ph   = 'Grund für die Beschlagnahmung…',
    ui_impound_retrievable = 'Besitzer darf auslösen',
    ui_impound_time        = 'Zeit bis zur Auslösung',
    ui_impound_cost        = 'Auslösekosten',
    ui_impound_confirm     = 'Beschlagnahmen',
    ui_hours               = '%sh',
    ui_time_none           = 'Kein Limit',
    ui_reason              = 'Grund',

    ui_impound_lot              = 'Verwahrstelle',
    ui_impound_lot_nearest      = 'Nächste Stelle',
    ui_impound_retrievable_desc = 'Der Besitzer darf das Fahrzeug nach Ablauf der Frist auslösen.',
    ui_impound_owner            = 'Besitzer',
    ui_impound_roster           = 'Fahrzeuge in Verwahrung',
    ui_impound_locked_hint      = 'Nur ein Beamter kann dieses Fahrzeug freigeben.',
    ui_impound_held_at          = 'Verwahrt in',
    ui_impound_officer          = 'Beschlagnahmt von',
    ui_impound_no_reason        = 'Kein Grund angegeben',
    ui_impound_release          = 'Freigeben',
    ui_impound_release_owner    = 'Besitzer darf abholen',
    ui_impound_release_police   = 'Nur Freigabe durch Polizei',
    ui_impound_available        = 'Verfügbar in',
    ui_impound_available_now    = 'Jetzt verfügbar',
    ui_impound_free             = 'Kostenlos',
    ui_impound_wait             = 'Verfügbar in %s',
    ui_at_impound               = 'In der Verwahrstelle',
    ui_owner                    = 'Besitzer',
    ui_unknown_owner            = 'Unbekannter Besitzer',
    ui_time_immediate           = 'Sofort verfügbar',
    ui_time_now                 = 'Sofort verfügbar',
    ui_dur_h                    = '%sh',
    ui_dur_m                    = '%smin',
    ui_dur_hm                   = '%hh %mmin',

    -- ─────────────────────────────────────────────────────────────
    -- UI — appearance (admin panel: the server-wide theme)
    -- ─────────────────────────────────────────────────────────────
    ui_theme            = 'Erscheinungsbild',
    ui_theme_colors     = 'Farben',
    ui_theme_brand      = 'Akzentfarbe',
    ui_theme_bg         = 'Hintergrundfarbe',
    ui_theme_derive     = 'Jede Fläche, Umrandung und Schattierung wird aus diesen beiden Farben abgeleitet. Beim Speichern gilt der neue Look sofort für JEDEN Spieler.',
    ui_theme_presets    = 'Vorlagen',
    ui_theme_preview    = 'Vorschau',
    ui_theme_apply      = 'Für alle übernehmen',
    ui_theme_reset_def  = 'Standard wiederherstellen',

    -- mock content of the preview card (never shown outside the appearance pane)
    ui_theme_demo_title      = 'Meine Fahrzeuge',
    ui_theme_demo_stored     = 'Eingeparkt',
    ui_theme_demo_finance    = 'Finanziert',
    ui_theme_demo_kpi_stored = 'Eingeparkt',
    ui_theme_demo_kpi_out    = 'Draußen',
    ui_theme_demo_take       = 'Rausholen',
    ui_theme_demo_transfer   = 'Übertragen',
    ui_theme_demo_search     = 'Fahrzeug suchen',

    -- ─────────────────────────────────────────────────────────────
    -- Notifications (n_) — player-facing toasts
    -- ─────────────────────────────────────────────────────────────
    n_no_access      = 'Du hast keinen Zugriff auf diese Garage.',
    n_no_vehicle     = 'Du sitzt in keinem Fahrzeug.',
    n_not_driver     = 'Du musst der Fahrer sein.',
    -- Config.occupantGuard: die Aktion hätte das Fahrzeug mit Leuten darin gelöscht
    n_occupied         = 'Lass deine Mitfahrer aussteigen, bevor du das Fahrzeug einstellst.',
    n_occupied_impound = 'Lass alle aussteigen, bevor du das Fahrzeug beschlagnahmst.',
    n_impound_on_foot = 'Steig aus, um den Verwahrhof zu nutzen.',
    n_wrong_class    = 'Dieses Fahrzeug gehört nicht in diese Garage.',
    n_stored         = 'Fahrzeug eingeparkt.',
    n_taken_out      = 'Fahrzeug rausgeholt.',
    n_blocked        = 'Hier ist kein Platz, um das Fahrzeug rauszuholen.',
    n_paid_fee       = 'Gebühr bezahlt: %s.',
    n_nickname_ok    = 'Spitzname aktualisiert.',
    n_transferred    = 'Fahrzeug übertragen.',
    n_sold           = 'Fahrzeug für $%s verkauft.',
    n_impounded      = 'Fahrzeug beschlagnahmt.',
    n_released       = 'Fahrzeug in die Garage des Besitzers zurückgebracht.',
    n_recovered      = 'Fahrzeug aus der Verwahrstelle ausgelöst.',
    n_no_target      = 'Kein Fahrzeug in der Nähe.',

    n_impound_locked    = 'Dieses Fahrzeug kann nur ein Beamter freigeben.',
    n_impound_not_ready = 'Dieses Fahrzeug kannst du noch nicht abholen.',
    n_impound_empty     = 'Du hast keine Fahrzeuge in dieser Verwahrstelle.',
    n_impound_released  = 'Dein Fahrzeug %s wurde freigegeben und wartet in %s.',
    n_impounded_reason  = 'Beschlagnahmt von %s — %s',
    n_impound_no_reason = 'Kein Grund angegeben',
    n_too_far           = 'Du bist zu weit von der Verwahrstelle entfernt.',

    -- ─────────────────────────────────────────────────────────────
    -- Notifications — admin commands & private garages
    -- ─────────────────────────────────────────────────────────────
    n_npc_removed    = 'Herrenloses Fahrzeug entfernt.',
    n_priv_created   = 'Private Garage erstellt.',
    n_priv_deleted   = 'Private Garage entfernt.',
    n_priv_noperm    = 'Du darfst keine privaten Garagen erstellen.',
    n_priv_name      = 'Diesen Namen gibt es bereits.',
    n_plate_changed  = 'Kennzeichen geändert.',
    n_veh_returned   = 'Fahrzeug in die Garage zurückgebracht.',
    n_veh_deleted    = 'Fahrzeug aus der Datenbank entfernt.',

    -- ─────────────────────────────────────────────────────────────
    -- Errors (e_) — returned by the server, looked up dynamically
    -- ─────────────────────────────────────────────────────────────
    e_nil         = 'Da ist etwas schiefgelaufen.',
    e_invalid     = 'Ungültig.',
    e_no_access   = 'Kein Zugriff.',
    e_not_owner   = 'Nicht der Besitzer.',
    e_wrong_class = 'Dieses Fahrzeug gehört nicht in diese Garage.',
    e_no_money    = 'Nicht genug Geld.',
    e_unavailable = 'Nicht verfügbar.',
    -- der Server hat das Rausholen abgelehnt: alle Spawnpunkte sind belegt
    e_blocked     = 'Hier ist kein Platz, um das Fahrzeug rauszuholen.',
    e_busy        = 'Du hast bereits eine Aktion laufen.',
    e_no_target   = 'Kein Fahrzeug in der Nähe.',
    e_already_out = 'Dieses Fahrzeug ist bereits draußen.',
    -- steht auch auf dem Abhol-Button, also kurz halten
    e_occupied    = 'In diesem Fahrzeug sitzt gerade jemand.',
    e_name        = 'Dieser Name ist bereits vergeben.',

    -- errors — job fleet (stock)
    e_stock_all_out     = 'Davon ist schon jedes draußen.',
    e_fleet_admin_only  = 'Nur ein Server-Admin kann ändern, welche Fahrzeuge diese Garage anbietet.',
    e_no_vehicle        = 'Du sitzt in keinem Fahrzeug.',
    e_stock_boss_only   = 'Nur ein eingesetzter Chef oder ein Server-Admin kann die Flottengröße ändern.',

    -- errors — impound
    e_impound_locked    = 'Nur Freigabe durch Beamte.',
    e_impound_not_ready = 'Noch nicht verfügbar.',
    e_too_far           = 'Zu weit weg.',
    e_no_lot            = 'Keine Verwahrstelle nimmt dieses Fahrzeug auf.',
    e_impounded         = 'Beschlagnahmt.',

    -- errors — selling
    e_sell_off      = 'Sofortverkauf ist nicht verfügbar.',
    e_sell_financed = 'Ein finanziertes Fahrzeug kannst du nicht verkaufen.',
    e_sell_out      = 'Das Fahrzeug ist draußen unterwegs.',
    e_sell_parked   = 'Das Fahrzeug ist abgestellt.',
    e_sell_impound  = 'Das Fahrzeug ist beschlagnahmt.',
    e_sell_noprice  = 'Dieses Fahrzeug hat keinen Marktwert.',
    e_sell_payfail  = 'Die Auszahlung des Verkaufs ist fehlgeschlagen. Melde dich bei einem Administrator.',

    -- ─────────────────────────────────────────────────────────────
    -- Errors — persistent parking (park command, see Config.commands.park)
    -- ─────────────────────────────────────────────────────────────
    e_park_off         = 'Dauerhaftes Parken ist deaktiviert.',
    e_park_noperm      = 'Du darfst hier nicht parken.',
    e_park_notowned    = 'Dieses Fahrzeug gehört dir nicht.',
    e_park_max         = 'Du hast dein Limit an geparkten Fahrzeugen erreicht.',
    e_park_occupied    = 'Hier steht bereits ein Fahrzeug.',
    e_park_none        = 'Kein geparktes Fahrzeug mit diesem Kennzeichen.',
    e_park_notowner    = 'Nur der Besitzer kann dieses Fahrzeug wieder mitnehmen.',
    e_park_busy        = 'Das Parksystem startet noch.',
    e_park_already     = 'Dieses Fahrzeug ist bereits geparkt.',
    e_park_parked      = 'Dieses Fahrzeug steht draußen auf der Straße — hol es dort ab.',
    e_park_notdriving  = 'Du musst in dem Fahrzeug sitzen, das du parken willst.',
    e_park_moving      = 'Bring das Fahrzeug zum vollständigen Stillstand, bevor du es parkst.',
    e_park_blacklisted = 'In diesem Bereich ist Parken nicht erlaubt.',
    e_park_in_garage   = 'In einer Garage kannst du nicht parken.',

    -- ─────────────────────────────────────────────────────────────
    -- UI — generic buttons and labels
    -- ─────────────────────────────────────────────────────────────
    ui_save           = 'Speichern',
    ui_close          = 'Schließen',
    ui_collapse       = 'Einklappen',
    ui_remove         = 'Entfernen',
    ui_teleport       = 'Teleportieren',
    ui_name           = 'Name',
    ui_set            = 'Festlegen',
    ui_class          = 'Klasse',
    ui_add            = 'Hinzufügen',
    ui_create         = 'Erstellen',
    ui_delete         = 'Löschen',
    ui_clear          = 'Leeren',
    ui_place          = 'Setzen',
    ui_none           = 'Keine',
    ui_optional       = 'optional',
    ui_yes            = 'Ja',
    ui_no             = 'Nein',
    ui_vehicle        = 'Fahrzeug',
    ui_min_grade      = 'Mindestrang',
    ui_add_vehicle    = 'Fahrzeug hinzufügen',
    ui_edit           = 'Bearbeiten',

    -- counters and fragments — %s is the count
    ui_count_one      = '%s Fahrzeug',
    ui_count_many     = '%s Fahrzeuge',
    ui_grade          = 'Rang %s',

    -- vehicle-card eyebrow, uppercase by design
    ui_brand_air      = 'LUFT',
    ui_brand_sea      = 'SEE',
    ui_brand_car      = 'FAHRZEUG',

    ui_impound_section = 'Beschlagnahmung',

    -- zone shapes and placement state
    ui_shape_corners  = 'Ecken',
    ui_shape_circle   = 'Kreis',
    ui_state_set      = 'Festgelegt',
    ui_state_unset    = 'Nicht festgelegt',

    -- preview dock tooltips
    ui_pv_rotate_left  = 'Nach links drehen',
    ui_pv_autorotate   = 'Auto-Drehung',
    ui_pv_rotate_right = 'Nach rechts drehen',
    ui_pv_zoom_out     = 'Rauszoomen',
    ui_pv_zoom_in      = 'Reinzoomen',
    ui_pv_reset        = 'Kamera zurücksetzen',

    -- ─────────────────────────────────────────────────────────────
    -- Admin panel (adm_)
    -- ─────────────────────────────────────────────────────────────
    adm_count_one       = '%s Garage',
    adm_count_many      = '%s Garagen',
    adm_garages         = 'Garagen',
    adm_new_garage      = 'Neue Garage',
    adm_edit_garage     = 'Garage bearbeiten',
    adm_empty           = 'Keine Garagen',
    adm_empty_sub       = 'Erstelle die erste über „Neue Garage“.',
    adm_row_vehicles    = '%s Fzg.',
    adm_tp_garage       = 'Zur Garage teleportieren',
    adm_src_config      = 'In shared/config.lua definiert',
    adm_src_created     = 'Im Spiel erstellt',
    adm_src_config_chip = 'config.lua',
    adm_src_config_hint = 'In shared/config.lua bearbeiten und die Ressource neu starten',
    adm_type_public     = 'Öffentlich',
    adm_type_job        = 'Job',
    adm_type_private    = 'Privat',
    adm_type_impound    = 'Verwahrstelle',
    adm_pick_player     = 'Spieler wählen',
    adm_nobody_online   = 'Niemand online.',

    -- boss panel
    adm_company         = 'FIRMA',
    adm_management      = 'VERWALTUNG',
    adm_admin           = 'ADMIN',
    adm_company_garage  = 'FIRMENGARAGE',
    adm_company_fallback = 'Firma',
    adm_boss_stock      = 'Nach Bestand',
    adm_boss_infinite   = 'Unbegrenzt rausholen',
    adm_boss_empty      = 'Keine Fahrzeuge',
    adm_boss_empty_sub  = 'Füge die hinzu, die die Firma rausholen darf.',
    adm_boss_empty_adm  = 'Ein Admin legt diesen Fuhrpark in /apexgarage fest.',

    -- private garages
    adm_priv_title          = 'Private Garagen',
    adm_priv_empty          = 'Du hast noch keine privaten Garagen.',
    adm_priv_create_here    = 'Hier eine private Garage erstellen',
    adm_priv_delete_confirm = 'Diese private Garage entfernen?',
    adm_priv_create_title   = 'Private Garage erstellen',
    adm_class_car_fallback  = 'Auto',

    -- ─────────────────────────────────────────────────────────────
    -- Garage editor (ed_)
    -- ─────────────────────────────────────────────────────────────
    ed_identification    = 'Identifikation',
    ed_name_ph           = 'Garagenname',
    ed_type              = 'Typ',
    ed_class_land        = 'Land',
    ed_class_air         = 'Luft',
    ed_class_sea         = 'See',
    ed_officer_job       = 'Job der Beamten',
    ed_veh_mode          = 'Fahrzeugmodus',
    ed_veh_mode_personal = 'Persönlich',
    ed_veh_mode_company  = 'Firma',
    ed_veh_mode_list     = 'Liste',
    ed_stock_infinite    = 'Unbegrenzt',
    ed_stock_by_stock    = 'Nach Bestand',
    ed_boss_grade        = 'Chef-Rang',
    ed_owners            = 'Besitzer',
    ed_owner_add         = 'Besitzer hinzufügen',
    ed_owners_existing   = '%s aktuelle(r) Besitzer (bleiben erhalten; füge einen hinzu, um sie zu ersetzen).',
    ed_owners_none       = 'Keine Besitzer — die Garage bleibt unzugänglich, bis du einen hinzufügst.',
    ed_zone_poly         = 'Polygon · %s Ecken',
    ed_zone_circle       = 'Kreis · Radius %s m',
    ed_zone_unset        = 'Noch nicht festgelegt',
    ed_store_set         = 'Eigener Punkt festgelegt',
    ed_store_unset       = 'Optional — ohne Angabe wird die Zone genutzt',
    ed_placement         = 'Platzierung in der Welt',
    ed_zone              = 'Garagenzone',
    ed_tp_zone           = 'Zur Zone teleportieren',
    ed_spawns            = 'Spawnpunkte',
    ed_spawns_sub        = 'Wo das Fahrzeug beim Rausholen erscheint',
    ed_store_point       = 'Einparkpunkt',
    ed_list_vehicles     = 'Fahrzeugliste',
    ed_no_vehicles       = 'Keine Fahrzeuge. Füge die hinzu, die dieser Job rausholen darf.',
    ed_stock_mode        = 'Bestandsmodus',
    ed_spawn_code        = 'Spawn-Code',
    ed_stock             = 'Bestand',
    ed_stock_start       = 'Startbestand',
    ed_veh_edit          = 'Fahrzeug bearbeiten',
    ed_veh_fleet_hint    = 'Nur ein Admin kann ändern, welche Fahrzeuge diese Garage anbietet. Der Chef legt fest, wie viele.',

    -- ─────────────────────────────────────────────────────────────
    -- Parking panel (pk_) — never name the park command here; it is
    -- configurable (Config.commands.park) and the call site passes no args.
    -- ─────────────────────────────────────────────────────────────
    pk_title             = 'Parken',
    pk_settings          = 'Einstellungen',
    pk_enabled           = 'Parken aktiviert',
    pk_enabled_desc      = 'Erlaubt Spielern, auf dem Server überall zu parken.',
    pk_nocol             = 'Keine Kollision',
    pk_nocol_desc        = 'Andere Fahrzeuge fahren durch geparkte Autos hindurch.',
    pk_jobveh            = 'Firmenfahrzeuge',
    pk_jobveh_desc       = 'Erlaubt das Parken von Job- und Firmenautos.',
    pk_nogarage          = 'In Garagen verbieten',
    pk_nogarage_desc     = 'Verhindert das Parken innerhalb jeder Garagenzone.',
    pk_who               = 'Wer darf parken',
    pk_who_desc          = 'Legt fest, wer Zugriff auf den Befehl hat.',
    pk_mode_public       = 'Jeder',
    pk_mode_job          = 'Nach Job',
    pk_mode_permission   = 'Nach Berechtigung',
    pk_jobs              = 'Erlaubte Jobs',
    pk_jobs_desc         = 'Mit Komma getrennt.',
    pk_max               = 'Maximum pro Spieler',
    pk_max_desc          = 'Wie viele Autos jeder Spieler geparkt lassen darf.',
    pk_unit_count        = 'St.',
    pk_radius            = 'Abstandsradius',
    pk_radius_desc       = 'Mindestabstand zu einem anderen bereits geparkten Auto.',
    pk_perms             = 'Berechtigungen',
    pk_grant             = 'Vergeben',
    pk_grant_title       = 'Berechtigung vergeben',
    pk_perms_empty       = 'Keine Berechtigungen',
    pk_perms_empty_sub   = 'Gib einem Spieler, der online ist, Zugriff.',
    pk_revoke            = 'Entziehen',
    pk_offline           = 'Offline',
    pk_zones             = 'Parkverbotszonen',
    pk_zones_empty       = 'Keine Verbotszonen',
    pk_zones_empty_sub   = 'Zeichne einen Bereich, in dem niemand parken darf.',
    pk_zone              = 'Zone',
    pk_zone_corners      = '%s Ecken',
    pk_zone_radius       = 'Radius %s m',
    pk_parked            = 'Geparkte Fahrzeuge',
    pk_parked_empty      = 'Nichts geparkt',
    pk_parked_empty_sub  = 'Niemand hat Fahrzeuge in der Welt abgestellt.',
    pk_save_note         = 'Änderungen gelten erst nach dem Speichern.',
    pk_tab_parking       = 'Geparkt',
    pk_tab_noparking     = 'Parkverbot',
    pk_tab_settings      = 'Einstellungen',

    -- ─────────────────────────────────────────────────────────────
    -- World placer — key hints and prompt titles (prompt_)
    -- ─────────────────────────────────────────────────────────────
    prompt_key_radius      = 'Radius',
    prompt_key_place       = 'Setzen',
    prompt_key_cancel      = 'Abbrechen',
    prompt_key_rotate      = 'Drehen',
    prompt_key_add_corner  = 'Ecke hinzufügen',
    prompt_key_finish      = 'Fertig',
    prompt_key_remove_last = 'Letzte entfernen',
    prompt_key_place_spawn = 'Spawn setzen',

    prompt_title_zone      = 'Zone festlegen',
    prompt_title_corners   = 'Zonenecken',
    prompt_title_spawn     = 'Spawnpunkt festlegen',
    prompt_title_spawns    = 'Spawnpunkte',
    prompt_spawns_count    = '%s — %s gesetzt',

    prompt_place_zone_poly   = 'Zonenecken — markiere 3 oder mehr',
    prompt_place_zone_circle = 'Garagenzone — Scrollen ändert den Radius',
    prompt_place_store       = 'Einparkpunkt',
    prompt_back_panel        = 'Zurück zum Panel',
    prompt_pk_zone_circle    = 'Parkverbotszone — Scrollen ändert den Radius',
    prompt_pk_zone_poly      = 'Parkverbotszone — markiere 3 oder mehr Ecken',

    -- ─────────────────────────────────────────────────────────────
    -- Notifications — admin panel, boss panel and parking
    -- ─────────────────────────────────────────────────────────────
    n_garage_created      = 'Garage erstellt.',
    n_garage_updated      = 'Garage aktualisiert.',
    n_garage_deleted      = 'Garage gelöscht.',
    n_theme_saved         = 'Erscheinungsbild für den ganzen Server gespeichert.',
    n_theme_reset         = 'Erscheinungsbild auf Standard zurückgesetzt.',
    n_veh_added           = 'Fahrzeug hinzugefügt.',
    n_parked              = 'Fahrzeug geparkt.',
    n_unparked            = 'Fahrzeug abgeholt — zurück in der Garage.',
    n_park_exiting        = 'Parken — du steigst aus…',
    n_park_exit_failed    = 'Du bist nicht sauber ausgestiegen, das Fahrzeug ist aber geparkt.',
    n_park_released       = 'Fahrzeug freigegeben. Du kannst jetzt losfahren.',
    n_park_settings_saved = 'Park-Einstellungen gespeichert.',
    n_park_veh_removed    = 'Geparktes Fahrzeug entfernt.',
    n_park_zone_created   = 'Parkverbotszone erstellt.',
    n_park_zone_removed   = 'Zone entfernt.',

    -- ─────────────────────────────────────────────────────────────
    -- Errors — admin panel, boss panel and parking
    -- ─────────────────────────────────────────────────────────────
    e_noperm          = 'Keine Berechtigung.',
    e_theme_invalid   = 'Ungültige Farben.',
    e_zone_create     = 'Die Zone konnte nicht erstellt werden.',
    e_no_zone         = 'Diese Garage hat noch keine Zone.',
    e_need_placement  = 'Lege die Zone und mindestens einen Spawnpunkt fest.',
    e_config_readonly = 'Diese Garage ist in shared/config.lua definiert – dort bearbeiten und die Ressource neu starten.',
    diag_nearest      = 'Nächste Garage: %s (%s), %s m entfernt – Zugangspunkt %s',
    diag_none         = 'Auf diesem Client ist noch keine Garage geladen.',
    e_no_boss_garage  = 'Du verwaltest keine Firmengarage.',
    e_park_none_near  = 'Du bist bei keinem deiner geparkten Fahrzeuge.',

    -- ─────────────────────────────────────────────────────────────
    -- UNUSED — no longer referenced by any Lua or NUI code.
    -- Kept for compatibility; safe to skip when translating.
    -- ─────────────────────────────────────────────────────────────
    ui_leave            = 'Verlassen',
    ui_sort_recent      = 'Zuletzt',
    ui_plate            = 'Kennzeichen',
    ui_theme_brand_desc = 'Buttons, Marker und Hervorhebungen auf dem ganzen Server.',
    ui_theme_bg_desc    = 'Grundton der Oberfläche; jede andere Fläche wird davon abgeleitet.',
    ui_theme_reset      = 'Zurücksetzen',
    ui_theme_save       = 'Speichern',
    ui_theme_hint       = 'Die Farben gelten für jeden Spieler, sobald du speicherst.',
    ui_theme_unsaved    = 'Vorschau — noch nicht gespeichert.',
    n_not_owner         = 'Das ist nicht dein Fahrzeug.',
    n_unavailable       = 'Fahrzeug derzeit nicht verfügbar.',
    n_already_out       = 'Dieses Fahrzeug ist bereits draußen.',
    n_no_money          = 'Nicht genug Geld.',
    n_invalid           = 'Ungültige Aktion.',
}
