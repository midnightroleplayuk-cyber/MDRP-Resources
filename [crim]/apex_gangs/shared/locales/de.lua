Locales = Locales or {}

-- Deutsch. Schlüssel mit en.lua synchron halten.
Locales['de'] = {
    -- ── Marke ──
    brand_name        = 'APEX',
    brand_accent      = 'GANGS',
    brand_sub         = 'Gang-Kommando',

    -- ── Allgemein ──
    ui_open           = 'Öffnen',
    ui_close          = 'Schließen',
    ui_save           = 'Speichern',
    ui_cancel         = 'Abbrechen',
    ui_confirm        = 'Bestätigen',
    ui_delete         = 'Löschen',
    ui_edit           = 'Bearbeiten',
    ui_create         = 'Erstellen',
    ui_refresh        = 'Aktualisieren',
    ui_search         = 'Suchen…',
    ui_none           = 'Keine',
    ui_loading        = 'Lädt…',

    -- ── Reiter ──
    tab_overview      = 'Übersicht',
    tab_members       = 'Mitglieder',
    tab_ranks         = 'Ränge',
    tab_turf          = 'Gebiet',
    tab_graffiti      = 'Graffiti',
    tab_vault         = 'Tresor',
    tab_garage        = 'Garage',
    tab_operations    = 'Operationen',
    tab_tasks         = 'Aufgaben',
    tab_upgrades      = 'Verbesserungen',
    tab_medic         = 'Sanitäter',
    tab_logs          = 'Protokolle',
    tab_settings      = 'Einstellungen',
    tab_admin         = 'Admin',

    -- ── Benachrichtigungen ──
    notify_no_gang        = 'Du bist in keiner Gang.',
    notify_not_authorized = 'Du bist nicht autorisiert.',
    notify_menu_failed    = 'Menü konnte nicht geöffnet werden (%s) — das ist kein Berechtigungsproblem. Siehe Server-Konsole.',
    notify_perm_report    = 'Berechtigungsbericht in deiner F8-Konsole ausgegeben.',
    notify_perm_report_offline = 'Kein Spieler mit dieser Server-ID online.',
    notify_no_permission  = 'Dir fehlt die Berechtigung dafür.',
    notify_not_leader     = 'Nur Gang-Anführer können das tun.',
    notify_gang_created   = 'Gang "%s" erstellt.',
    notify_gang_deleted   = 'Gang gelöscht.',
    notify_gang_full      = 'Die Gang ist voll.',
    notify_member_joined  = 'Du bist %s beigetreten.',
    notify_member_kicked  = 'Du wurdest aus %s entfernt.',
    notify_member_invited = '%s eingeladen.',
    notify_promoted       = '%s befördert.',
    notify_demoted        = '%s degradiert.',
    notify_lead_transfer  = 'Führung an %s übertragen.',
    notify_cooldown       = 'Abklingzeit — versuch es später erneut.',
    notify_saved          = 'Gespeichert.',
    notify_deleted        = 'Gelöscht.',

    -- ── Gebiet ──
    turf_entering         = 'Betrete %s-Gebiet',
    turf_leaving          = 'Verlasse %s-Gebiet',
    turf_neutral          = 'Neutrales Gebiet',
    turf_capturing        = 'Einnahme… %d%%',
    turf_contested        = 'Gebiet umkämpft!',
    turf_captured         = '%s hat %s eingenommen',
    turf_lost             = 'Deine Gang hat %s verloren',
    turf_tagging          = 'Markiere dieses Gebiet… %d/%d Tags',

    -- ── Graffiti ──
    graffiti_placed       = 'Tag angebracht.',
    graffiti_removed      = 'Tag entfernt.',
    graffiti_limit        = 'Graffiti-Limit erreicht.',
    graffiti_no_wall      = 'Ziele auf eine ebene Wand.',
    graffiti_aim          = 'Ziele, wo gesprüht wird · [E] bestätigen · [Esc] abbrechen',
    graffiti_rotate       = 'Drehen',
    graffiti_resize       = 'Größe ändern',
    graffiti_place        = 'Platzieren',
    graffiti_cancel       = 'Abbrechen',
    graffiti_spraying     = 'Sprühe Graffiti…',
    graffiti_spraying_sub = 'Halt still, während du die Wand taggst',
    graffiti_shaking      = 'Schüttle die Dose…',
    graffiti_shaking_sub  = 'Mische die Farbe',
    graffiti_size         = 'Größe',
    graffiti_rotation     = 'Drehung',
    graffiti_draw         = 'Zeichnen',

    -- ── Tresor ──
    vault_deposited       = '%s eingezahlt.',
    vault_withdrawn       = '%s abgehoben.',
    vault_insufficient    = 'Nicht genug Geld.',

    -- ── Garage ──
    garage_stored         = 'Fahrzeug eingelagert.',
    garage_out            = 'Fahrzeug herausgeholt.',
    garage_limit          = 'Die Garage ist voll.',
    garage_not_here       = 'Kein Garagenpunkt in der Nähe.',
    garage_not_yours      = 'Das ist nicht dein Fahrzeug — nur deine eigenen Autos dürfen in die Gang-Garage.',
    garage_not_gang       = 'Dieses Fahrzeug gehört einer anderen Gang.',

    -- ── Operationen ──
    scout_started         = 'Auskundschaften läuft…',
    scout_done            = 'Auskundschaften abgeschlossen — Infos gesammelt.',
    scout_failed          = 'Auskundschaften fehlgeschlagen.',
    scout_alerted         = 'Ein Rivale kundschaftet dich aus!',
    scout_left_zone       = 'Auskundschaften abgebrochen — du hast das Gebiet verlassen.',
    scout_cancelled       = 'Auskundschaften abgebrochen.',
    scout_busy            = 'Ein Auskundschaften läuft bereits.',
    scout_prompt          = '%s auskundschaften',
    raid_started          = 'Überfall gestartet!',
    raid_incoming         = 'Deine Gang wird überfallen!',
    raid_success          = 'Überfall erfolgreich.',
    raid_failed           = 'Überfall fehlgeschlagen.',
    raid_need_scout       = 'Kundschafte zuerst das Ziel aus.',
    raid_need_attackers   = 'Nicht genug Angreifer.',

    -- ── Aufgaben ──
    task_complete         = 'Aufgabe erledigt: %s',
    task_progress         = '%s · %d/%d',
    hq_nothing            = 'Hier gibt es gerade nichts zu erkunden — hol dir zuerst den Auftrag "HQ auskundschaften".',
    mission_started       = 'Mission: %s — folge der Markierung.',
    mission_done          = 'Mission abgeschlossen — Auszahlung an die Gang gesendet.',
    mission_failed        = 'Mission fehlgeschlagen.',
    mission_busy          = 'Du hast bereits eine laufende Mission.',
    mission_deliver       = 'Liefere es an der Abgabestelle ab.',
    mission_cancelled     = 'Mission abgebrochen.',
    mission_none          = 'Du hast keine laufende Mission.',
    mission_cancel_hint   = 'Brich jederzeit mit /cancelmission ab (oder F6 → Mission abbrechen).',
    mstep_travel          = 'Reise zum Ort',
    mstep_eliminate       = 'Schalte das Ziel aus',
    mstep_meet            = 'Triff den Käufer zur Übergabe',
    mstep_grab            = 'Schnapp dir das Paket',
    mstep_grab_person     = 'Trage das Ziel (F6 → Tragen / [E])',
    mstep_grab_body       = 'Trage die Leiche (F6 → Tragen / [E])',
    mstep_deliver         = 'Bring das Ziel zu den Käufern (F6 → Ablegen / [E])',
    mstep_dispose         = 'Lege die Leiche hier ab (F6 → Ablegen / [E])',
    mstep_clear           = 'Schalte die Kartellwächter aus',
    mstep_grab_loot       = 'Schnapp dir die Lieferung',
    mstep_sell            = 'Verkaufe an die Käufer',

    -- ── Reputation ──
    rep_label             = 'Reputation',
    need_rep              = 'Deine Gang braucht mehr Reputation für einen Überfall.',

    -- ── Stufen / Verbesserungen ──
    level_up              = 'Deine Gang hat Stufe %d erreicht!',
    upgrade_bought        = 'Verbesserung gekauft: %s',
    upgrade_maxed         = 'Verbesserung bereits auf Maximum.',
    upgrade_level_locked  = 'Erfordert Gang-Stufe %d.',

    -- ── Sanitäter ──
    medic_healed          = 'Du wurdest geheilt.',
    medic_revived         = 'Du wurdest wiederbelebt.',
    medic_locked          = 'Der Gang-Sanitäter ist nicht freigeschaltet.',

    -- ── Ersteller / Editor ──
    creator_title         = 'Gang-Zonen',
    creator_aim           = 'Ziele, wo der Punkt sein soll · [E] bestätigen · [Esc] abbrechen',
    creator_saved         = 'Zone "%s" gespeichert.',
    creator_deleted       = 'Zone gelöscht.',

    -- ── Testmodus ──
    test_enabled          = 'Testmodus AN — Solo-Invasionen + NPC-Verteidiger.',
    test_disabled         = 'Testmodus AUS.',
    test_defenders        = '%d Verteidiger im Anmarsch!',
    test_zone_cleared     = 'Bereich gesäubert — halte ihn, um ihn einzunehmen.',
    test_rival_created    = 'Test-Rivalengang bereit: %s',
    test_zone_created     = 'Rivalengebiet hier erstellt (Besitzer: %s). Geh hinein und drücke [E] zum Auskundschaften.',
    test_zone_nocoords    = 'Noch keine Position — geh ein paar Schritte und versuch es erneut.',

    -- ── Airdrop ──
    airdrop_inbound       = 'Ein Airdrop ist im Anflug — finde die Kiste!',
    airdrop_dispatched    = 'Airdrop abgeworfen.',
    airdrop_no_zones      = 'Keine Airdrop-Zonen aktiviert.',
    airdrop_locked        = 'Die Kiste ist noch versiegelt — warte, bis sie sich aktiviert.',
    airdrop_open          = 'Airdrop öffnen',
    airdrop_looted        = 'Airdrop geplündert!',

    -- ── Welt-Hinweis ──
    prompt_open_menu      = 'Gang-Menü öffnen',
    target_open           = 'Gang-Menü öffnen',
}
