JobConfigLocales["sky_dojjob:de"] = {
    Nui = {
        tablet = {
            apps = {
                doj_finance = "Finanzen",
                doj_conditions = "Auflagen",
                doj_elections = "Wahlen",
                doj_files = "Akten-Explorer",
                doj_hearings = "Verhandlungen",
                doj_law = "Gesetzbücher",
                doj_offences = "Bußgeldkatalog",
                doj_shared_files = "Freigegebene Dokumente",
            },
        },
        workshopConfig = {
            registryFiles = {
                licenseType = "Lizenzart",
                licenseLabel = "Name des Registers",
                marriages = "Heiratsregister",
            },
            configs = {
                sky_dojjob = {
                    subtitle = "DOJ-Jobs, Gerichtsgebäude und die Gesetzbuch-App konfigurieren.",
                    title = "Department-of-Justice-Jobs",
                },
            },
            creatorSections = {
                courthouses = {
                    entryLabel = "Gerichtsgebäude",
                    entryPluralLabel = "Gerichtsgebäude",
                    label = "Gerichtsgebäude",
                },
            },
            extensions = {
                invalidSelection = "Ungültige Auswahl: {value}",
                trainingSettings = {
                    description = "Konfiguriert Ausbildungszugriff, Anmeldungen, Freigaben und Lehrgangsplanung für diesen Job.",
                    label = "Ausbildungseinstellungen",
                },
            },
            features = {
                dojHandovers = {
                    label = "Übergaben",
                    description = "Aktiviert Übergaben, gerichtliche Entscheidungen und Vollzugsrückmeldungen. Dokumente und Freigaben bleiben verfügbar.",
                },
                dojBodycamRequests = {
                    label = "Bodycam-Anfragen",
                    description = "Polizeiaufnahmen anfordern. Benötigt Übergaben; gespeicherte Aufnahmen bleiben unabhängig verfügbar.",
                },
                dojFinance = {
                    label = "Finanzen",
                    description = "Fraktionsguthaben, Staatskonto-Überweisungen und Buchungsverlauf.",
                },
                dojConditions = {
                    description = "Aktiviert strukturierte Auflagen, Nachweise, Fristen und die Bearbeitung von Verstößen.",
                    label = "Auflagen",
                },
                dojCourtroom = {
                    description = "Aktiviert sichere Saalsitzungen, Beweispräsentation und rollenbasierte Saalinteraktionen.",
                    label = "Live-Gerichtssaal",
                },
                dojElections = {
                    description = "Aktiviert die Wahlverwaltung und sicheres Abstimmen an registrierten Wahlkabinen.",
                    label = "Wahlen",
                },
                dojHearings = {
                    description = "Aktiviert Saalplanung, Check-in und verbindliche Verhandlungsstatus.",
                    label = "Verhandlungen",
                },
                dojLegalCodes = {
                    description = "Aktiviert Gesetzbücher, den Rich-Text-Editor und die Revisionshistorie.",
                    label = "Gesetzbücher",
                },
                dojOffences = {
                    description = "Aktiviert den kompakten Deliktkatalog und die Rechner-Vorschau.",
                    label = "Bußgeld- und Strafkatalog",
                },
                dojPrinters = {
                    description = "Aktiviert physische Drucker und ihre Laufzeit-Infrastruktur.",
                    label = "Drucker",
                },
                dojPublicDisplays = {
                    description = "Aktiviert datenschutzgefilterte Live-Daten für Anzeigen im Gerichtsgebäude.",
                    label = "Öffentliche Saalanzeigen",
                },
                dojTablet = {
                    description = "Aktiviert den Zugriff auf die DOJ-Tablet-Apps.",
                    label = "DOJ-Tablet",
                },
                dojTaxes = {
                    description = "Zieht regelmäßig Fahrzeug- und Haussteuern von Online-Spielern ein.",
                    label = "Vermögenssteuern",
                },
            },
            locations = {
                stationPosition = "Standort / Karten-Blip",
                stationPositionHint = "Hauptpunkt dieses Job-Standorts. Wenn der Karten-Blip unter Job → Blips aktiviert ist, erscheint er hier.",
                addCourtroom = "Gerichtssaal hinzufügen",
                courtroom = "Gerichtssaal",
                courtroom_display_desk_27 = "Beweisanzeige – 27-Zoll-Tischmonitor",
                courtroom_display_wall_55 = "Beweisanzeige – 55-Zoll-Wandfernseher",
                courtroom_display_wall_75 = "Beweisanzeige – 75-Zoll-Wandfernseher",
                courtroom_display_wall_100 = "Beweisanzeige – 100-Zoll-Wandfernseher",
                courtroom_display_wall_120 = "Beweisanzeige – 120-Zoll-Wandfernseher",
                courtroom_display_wall_150 = "Beweisanzeige – 150-Zoll-Wandfernseher",
                courtroom_display_board_93 = "Interaktives Saalboard – 150 Zoll mit Rollständer",
                courtroom_display_projection = "Beweisanzeige – 4,5-m-Leinwand",
                courtroom_judge_mic = "Gerichtssaal – Richtermikrofon",
                courtroom_jury_room = "Gerichtssaal – Juryraum",
                courtroom_room = "Gerichtssaal – Zuschauer-/Saalmitte",
                courtroom_witness = "Gerichtssaal – Zeugenstand",
                electionBooth = "Wahlkabine",
                publicDisplayDesk27 = "Öffentliche Anzeige – 27-Zoll-Tischmonitor",
                publicDisplayTerminal43 = "Öffentliche Anzeige – 43-Zoll-Standterminal",
                publicDisplayWall55 = "Öffentliche Anzeige – 55-Zoll-Wandfernseher",
                publicDisplayWall75 = "Öffentliche Anzeige – 75-Zoll-Wandfernseher",
                publicDisplayWall100 = "Öffentliche Anzeige – 100-Zoll-Wandfernseher",
                publicDisplayWall120 = "Öffentliche Anzeige – 120-Zoll-Wandfernseher",
                publicDisplayWall150 = "Öffentliche Anzeige – 150-Zoll-Wandfernseher",
                publicDisplayProjection = "Öffentliche Anzeige – 4,5-m-Leinwand",
                publicLegalCode = "Öffentliches Gesetzbuch",
            },
            printers = {
                groups = {
                    paper = "Papier",
                    ink = "Tinte",
                    general = "Drucker",
                    printing = "Druck & Zugriff",
                    placement = "Modell & Position",
                },
                actions = {
                    selectExisting = "Vorhandenen Drucker auswählen",
                    selectExistingHint = "Drucker anvisieren. Enter: auswählen · Esc: abbrechen",
                    add = "Drucker hinzufügen",
                    open = "Drucker prüfen",
                    place = "Drucker platzieren",
                    setPosition = "Aktuellen Standort verwenden",
                },
                classes = {
                    office = "Büro",
                    professional = "Professionell",
                    standard = "Standard",
                },
                description = "Drucker, Verbrauchsmaterial, Warteschlangen, Zugriff und Platzierung für diesen Job konfigurieren.",
                fieldDescriptions = {
                    paperCapacity = "Maximaler Papierbestand für jeden Drucker dieses Jobs.",
                    paperEnabled = "Wenn aktiviert, starten alle Drucker dieses Jobs leer und benötigen das gemeinsame Nachfüllitem.",
                    refillAmount = "Papiermenge, die das gemeinsame Nachfüllitem bei jedem Drucker dieses Jobs nachfüllt.",
                    refillItem = "Interner Name des Inventaritems, das beim Nachfüllen eines Druckers dieses Jobs verbraucht wird.",
                },
                fields = {
                    active = "Aktiv",
                    class = "Klasse",
                    heading = "Ausrichtung",
                    id = "Stabile ID",
                    label = "Bezeichnung",
                    maxQueue = "Warteschlangenkapazität",
                    minimumGrade = "Mindestrang",
                    paperCapacity = "Papierkapazität",
                    paperEnabled = "Papiernachfüllen erforderlich",
                    propModel = "Prop-Modell",
                    refillAmount = "Papier pro Nachfüllitem",
                    refillItem = "Nachfüllitem",
                    deleteCopiesAfterRestart = "Kopien nach Neustart löschen",
                    deleteCopiesAfterRestartHint = "Nicht abgeholte Ausdrucke beim Neustart des Druckerdienstes löschen.",
                    spawnProp = "Prop erzeugen",
                    speed = "Druckgeschwindigkeit",
                    status = "Status",
                    x = "X",
                    y = "Y",
                    z = "Z",
                },
                info = {
                    class = "Klasse: {class}",
                    paper = "Papier: {paper} / {capacity}",
                    queue = "Warteschlange: {queue} / {maxQueue}",
                    status = "Status: {status}",
                    title = "Drucker",
                },
                messages = {
                    grade_too_low = "Dein Rang ist für diesen Drucker zu niedrig.",
                    invalid_amount = "Die Nachfüllmenge ist ungültig.",
                    missingModel = "Wähle vor der Platzierung ein gültiges Drucker-Prop-Modell.",
                    missing_refill_item = "Du hast das konfigurierte Nachfüllitem nicht.",
                    no_refill_printer = "Kein zugänglicher Drucker mit aktiviertem Papierbestand ist in der Nähe.",
                    paper_capacity_exceeded = "Die Papierkapazität würde überschritten.",
                    paper_disabled = "Für diesen Drucker ist kein Papierbestand aktiviert.",
                    paper_full = "Der Papierbestand dieses Druckers ist bereits voll.",
                    printer_inactive = "Dieser Drucker ist inaktiv.",
                    printer_not_found = "Der Drucker existiert nicht mehr.",
                    refill_cooldown = "Warte kurz vor dem nächsten Nachfüllen.",
                    refilled = "{amount} Papier nachgefüllt. Bestand: {paper} / {capacity}.",
                    too_far_away = "Gehe näher an den Drucker.",
                    unavailable = "Der Drucker ist nicht verfügbar.",
                    wrong_job = "Du gehörst nicht zum Job dieses Druckers.",
                },
                settings = {
                    description = "Diese Einstellungen gelten für alle Drucker, die in diesem Job konfiguriert sind.",
                    title = "Jobweite Druckereinstellungen",
                },
                statuses = {
                    maintenance = "Wartung",
                    offline = "Offline gehen",
                    online = "Online",
                },
                title = "Drucker",
                values = {
                    disabled = "Deaktiviert",
                    enabled = "Aktiviert",
                    selectItem = "Item auswählen",
                },
            },
            recordsAccessGuide = {
                description = "Lege fest, wer Akten öffnen darf und in welchem Fachbereich gearbeitet wird. Ohne Zuordnung bleibt der Zugriff gesperrt.",
                grades = {
                    assigned = "Ränge zugeordnet",
                    chooseDomain = "Zuordnung klären",
                    conflict = "Ein Rang ist mehrfach zugeordnet. Wähle einen Fachbereich oder Kein Zugriff, um den Konflikt zu lösen.",
                    description = "Wähle pro Rang einen Fachbereich. Mit Kein Zugriff bleibt ein Rang gesperrt.",
                    domainColumn = "Fachbereich",
                    empty = "Für den eingerichteten DOJ-Job wurden keine Dienstgrade gefunden.",
                    emptyHint = "Lege zuerst die DOJ-Dienstgrade im Framework an und öffne den Konfigurator danach erneut.",
                    gradeColumn = "Rang",
                    noAccess = "Kein Zugriff",
                    noResults = "Kein passender Dienstgrad gefunden.",
                    notFound = "Im Framework nicht mehr vorhanden",
                    search = "Ränge durchsuchen",
                    title = "Ränge und Fachbereiche",
                },
                publish = {
                    saveHint = "Klicke oben auf Speichern, um die Änderungen zu übernehmen. Danach können Spieler ihren Zugriff erneut prüfen.",
                },
                status = {
                    conflict = "Doppelte Zuordnung lösen",
                    disabled = "DOJ-Tablet deaktiviert",
                    incomplete = "Mindestens einen Dienstgrad zuordnen",
                    ready = "Bereit zum Speichern",
                    unpublished = "Zuordnung noch nicht veröffentlicht",
                },
                steps = {
                    gradesText = "Klicke bei jedem berechtigten Dienstgrad genau einen Aktenbereich an.",
                    gradesTitle = "Dienstgrade zuordnen",
                    publishText = "Nach jeder Änderung wird automatisch eine neue Zuordnungsversion vorbereitet.",
                    publishTitle = "Veröffentlichen und speichern",
                    tabletText = "Das Tablet muss aktiviert sein, damit die Akten-Apps geöffnet werden können.",
                    tabletTitle = "DOJ-Tablet aktivieren",
                },
                title = "Aktenzugriff einrichten",
            },
            settingGroups = {
                dojWarrants = {
                    label = "Richterliche Beschlüsse",
                },
                dojAccess = {
                    label = "Zugriff",
                },
                dojCourthouseBlip = {
                    label = "Kartenmarkierung",
                },
                dojLegalBooks = {
                    label = "Bücher",
                },
                dojLegalContentLimits = {
                    label = "Inhaltsgrenzen",
                },
                dojLegalItem = {
                    label = "Inventar-Item",
                },
                dojLegalRateLimits = {
                    label = "Rate-Limits",
                },
                dojLegalRevisions = {
                    label = "Revisionen",
                },
                dojLegalTransfers = {
                    label = "Große Dokumente",
                },
                dojOffenceCalculation = {
                    label = "Rechner",
                },
                dojOffenceRateLimits = {
                    label = "Rate-Limits",
                },
                dojOffenceMiranda = {
                    label = "Kataloghinweise",
                },
                dojOffenceSource = {
                    label = "Katalogquelle",
                },
                dojRecordsGradeBindings = {
                    description = "Ordne jeden vorhandenen DOJ-Dienstgrad genau einem Aktenbereich zu und veröffentliche anschließend die Zuordnung.",
                    label = "Dienstgrade und Aktenbereiche",
                },
                dojTaxPayment = {
                    label = "Zahlung",
                },
                dojTaxRates = {
                    label = "Steuersätze",
                },
                dojTaxSchedule = {
                    label = "Zeitplan",
                },
            },
            registryCatalog = {
                names = {
                    notarial_contracts = "Notarielle Verträge",
                    powers_of_attorney = "Vollmachten",
                    name_changes = "Namensänderungen",
                    company_registry = "Unternehmensregister",
                    association_registry = "Vereinsregister",
                    licensing = "Lizenzwesen",
                    administrative_decisions = "Verwaltungsbeschlüsse",
                    administrative_objections = "Widersprüche",
                },
            },
            settingSections = {
                finance = "Finanzen",
                courtroom = "Gerichtssaal",
                registries = "Register",
                courthouses = "Gerichtsgebäude",
                general = "Allgemein",
                legalCodes = "Gesetzbücher",
                offences = "Bußgeldkatalog",
                recordsAccess = "Aktenzugriff",
                tablet = "Tabletten",
                taxes = "Steuern",
            },
            gavel = {
                enabled = "Aktiviert",
                cooldown = "Pause zwischen Auslösungen (ms)",
                defaultPreset = "Standard-Schlagfolge",
                prop = "Hammermodell",
                model = "Modellname",
                bone = "Handknochen-ID",
                offset = "Versatz (Meter)",
                rotation = "Drehung (Grad)",
                presets = "Schlagfolgen",
                single = "Einzelschlag",
                double = "Doppelschlag",
                strikes = "Anzahl der Schläge",
                interval = "Schlagabstand (ms)",
                impact = "Tonverzögerung (ms)",
                audio = "Ton",
                asset = "Audiodatei",
                volume = "Lautstärke",
                animation = "Animation",
                dict = "Animationsverzeichnis",
                clip = "Animationsname",
                duration = "Bewegungsdauer (ms)",
                flag = "Animationsflags",
                x = "X",
                y = "Y",
                z = "Z",
            },
            settings = {
                dojRegistryLicenses = {
                    label = "Lizenzregister",
                    description = "Wähle die Lizenzen, die das DOJ ausstellen darf. Jeder Eintrag erscheint als eigenes Register. Beim Entfernen bleiben bestehende Lizenzen erhalten.",
                },
                dojRegistryAccess = {
                    label = "Zugriff auf Registerdateien",
                    description = "Zugriff auf Register aus config/registry anpassen. Eine leere Liste nutzt die Dateivorgaben. Felder und Server-/Client-Funktionen werden in den Lua-Dateien bearbeitet.",
                },
                dojTreasuryJob = {
                    label = "Staatskonto-Job",
                    description = "Job, dessen Fraktionskonto Einzüge empfängt und Überweisungen bezahlt.",
                },
                dojFinanceJobs = {
                    label = "Sichtbare Fraktionen",
                    description = "Registrierte Job-Schlüssel für die Kontoübersicht. Das Staatskonto ist immer enthalten.",
                },
                dojFinanceLimit = {
                    label = "Buchungslimit",
                    description = "Höchstbetrag pro Überweisung oder Einzug.",
                },
                dojFinePaymentMode = {
                    label = "Auflagenstrafen bezahlen",
                    description = "Direkte Bankzahlung oder externe Rechnung. Eine erstellte Rechnung bestätigt keine Zahlung.",
                    options = {
                        bank = "Bankzahlung",
                        billing = "Rechnung",
                    },
                },
                dojFineSociety = {
                    label = "Empfänger der Geldstrafen",
                    description = "Job, dessen Fraktionskonto Auflagenstrafen empfängt.",
                },
                dojCourtroomBoardMove = {
                    label = "Saalboard verschieben",
                    description = "Standardtaste zum Anfassen oder Abstellen (z. B. F). Spieler können sie in den FiveM-Tastenbelegungen ändern. Die Position wird beim Neustart zurückgesetzt.",
                },
                dojCourtroomGavel = {
                    label = "Richterhammer",
                    description = "Hammermodell, Handbefestigung, Animation, Ton und Schlagfolgen. Änderungen gelten auch ohne Neustart.",
                },
                dojHearingParticipantRoles = {
                    label = "Teilnehmerrollen",
                    description = "Standard: defendant (Angeklagter), witness (Zeuge), juror (Geschworener), judge (Richter). Eigene Rollenschlüssel in Kleinbuchstaben ergänzen (max. 24 Zeichen, Unterstriche erlaubt). judge beibehalten. Eigene Rollen vergeben keine Richter- oder Juryrechte.",
                },
                dojWarrantTemplateCodes = {
                    label = "Vorlagencodes für richterliche Befehle",
                    description = "Vorlagencodes, die nach richterlicher Unterschrift und Freigabe unter PD Warrants erscheinen. Standard: HB, DB, RB.",
                },
                dojRegistryCatalog = {
                    label = "DOJ-Register",
                    description = "DOJ-Register aktivieren und benennen sowie Jobzugriff und Freigabestufen festlegen. Bestehende DOJ-Rollenrechte gelten weiterhin. Eigene RP-Register werden in Jobs Base verwaltet.",
                },
                dojCourthouseBlipCategory = {
                    description = "Kategoriebezeichnung für Kartenmarkierungen von Gerichtsgebäuden.",
                    label = "Blip-Kategorie",
                },
                dojCourthouseBlipColor = {
                    description = "Kartenfarbe für Gerichtsgebäude.",
                    label = "Blip-Farbe",
                },
                dojCourthouseBlipScale = {
                    description = "Kartengröße der Gerichtsgebäude-Blips.",
                    label = "Blip-Größe",
                },
                dojCourthouseBlipShortRange = {
                    description = "Gerichtsgebäude-Blips nur in kurzer Entfernung anzeigen.",
                    label = "Kurzreichweite",
                },
                dojCourthouseBlipSprite = {
                    description = "Blip für Gerichtsgebäude.",
                    label = "Blip-Sprite",
                },
                dojLegalBookItem = {
                    description = "Inventar-Item für eine feste Gesetzbuchausgabe. Beim ersten Benutzen werden Inhalt und Stand gespeichert; einzelne Items mit Metadaten werden benötigt.",
                    label = "Gesetzbuch-Item",
                },
                dojLegalCreateBookRateLimitMs = {
                    description = "Mindestabstand in Millisekunden zwischen Erstellungsanfragen.",
                    label = "Abklingzeit Gesetzbuch erstellen",
                },
                dojLegalCreateRevisionRateLimitMs = {
                    description = "Mindestabstand in Millisekunden zwischen neuen Revisionen.",
                    label = "Abklingzeit Revision erstellen",
                },
                dojLegalDeleteBookRateLimitMs = {
                    description = "Mindestabstand in Millisekunden zwischen Gesetzbuchlöschungen.",
                    label = "Abklingzeit Gesetzbuch löschen",
                },
                dojLegalDeleteRevisionRateLimitMs = {
                    description = "Mindestabstand in Millisekunden zwischen Revisionslöschungen.",
                    label = "Abklingzeit Revision löschen",
                },
                dojLegalGetBookRateLimitMs = {
                    description = "Mindestabstand in Millisekunden zwischen Anfragen eines Gesetzbuchs.",
                    label = "Abklingzeit Gesetzbuch laden",
                },
                dojLegalGetBooksRateLimitMs = {
                    description = "Mindestabstand in Millisekunden zwischen Anfragen der Gesetzbuchliste.",
                    label = "Abklingzeit Bibliothek laden",
                },
                dojLegalLargeRequestTimeoutMs = {
                    description = "Mindestzeitlimit für Anfragen mit großen Dokumentinhalten.",
                    label = "Zeitlimit großer Anfragen in Millisekunden",
                },
                dojLegalMaxAbbreviationLength = {
                    description = "Maximale Zeichenanzahl für das Kürzel eines Gesetzbuchs.",
                    label = "Maximale Kürzellänge",
                },
                dojLegalMaxBookTitleLength = {
                    description = "Maximale Zeichenanzahl für den Titel eines Gesetzbuchs.",
                    label = "Maximale Länge des Buchtitels",
                },
                dojLegalMaxContentBytes = {
                    description = "Maximale serialisierte Größe einer vollständigen Gesetzbuchrevision.",
                    label = "Maximale Inhaltsgröße in Bytes",
                },
                dojLegalMaxParagraphTitleLength = {
                    description = "Maximale Titellänge beim Import alter strukturierter Paragrafen.",
                    label = "Maximale Länge alter Paragrafentitel",
                },
                dojLegalMaxParagraphsPerBook = {
                    description = "Maximale Anzahl strukturierter Paragrafen bei älteren Importformaten.",
                    label = "Maximale alte Paragrafen pro Buch",
                },
                dojLegalMaxRevisionSummaryLength = {
                    description = "Maximale Zeichenanzahl für die Beschreibung einer Änderung.",
                    label = "Maximale Länge der Revisionsnotiz",
                },
                dojLegalMaxRichTextNodes = {
                    description = "Maximale Anzahl von Editor-Knoten innerhalb einer Revision.",
                    label = "Maximale Rich-Text-Knoten",
                },
                dojLegalPayloadBytesPerSecond = {
                    description = "Bandbreitenlimit pro Spieler für die Übertragung großer Gesetzbücher.",
                    label = "Übertragungsrate in Bytes pro Sekunde",
                },
                dojLegalReorderBooksRateLimitMs = {
                    description = "Mindestabstand in Millisekunden zwischen Sortierungsanfragen.",
                    label = "Abklingzeit Bücher sortieren",
                },
                dojLegalUpdateBookRateLimitMs = {
                    description = "Mindestabstand in Millisekunden zwischen Metadatenänderungen.",
                    label = "Abklingzeit Gesetzbuch bearbeiten",
                },
                dojLegalVisibleRevisionHistory = {
                    description = "Maximale Anzahl geladener Revisionen beim Öffnen eines Gesetzbuchs.",
                    label = "Sichtbare Revisionshistorie",
                },
                dojOffenceCalculateRateLimitMs = {
                    description = "Mindestabstand in Millisekunden zwischen serverseitigen Rechner-Vorschauen.",
                    label = "Abklingzeit Rechner",
                },
                dojOffenceGetCatalogueRateLimitMs = {
                    description = "Mindestabstand in Millisekunden zwischen Kataloganfragen.",
                    label = "Abklingzeit Katalog laden",
                },
                dojOffenceMaxSelection = {
                    description = "Maximale Anzahl von Delikten in einer Rechner-Vorschau.",
                    label = "Maximale Auswahl",
                },
                dojOffenceMutationRateLimitMs = {
                    description = "Mindestabstand in Millisekunden zwischen Änderungen am Strafkatalog.",
                    label = "Abklingzeit Katalogbearbeitung",
                },
                dojOffenceMirandaWarning = {
                    description = "Eigene Belehrung im Strafkatalog. Leer lassen, um den Standardtext in der ausgewählten Sprache zu verwenden.",
                    label = "Miranda-Belehrung",
                },
                dojPrimaryColor = {
                    description = "Hauptfarbe der DOJ-Jobgruppe und des Tablets.",
                    label = "Primärfarbe",
                },
                dojRecordsCourtAdministrationGradeKeys = {
                    description = "Diese Dienstgrade bearbeiten Verwaltungs- und Registerakten des Gerichts.",
                    label = "Gerichtsverwaltung",
                },
                dojRecordsJudiciaryGradeKeys = {
                    description = "Diese Dienstgrade bearbeiten richterliche Akten und Entscheidungen.",
                    label = "Richterschaft",
                },
                dojRecordsMappingVersion = {
                    description = "Veröffentlichter Stand der Dienstgrad- und Aktenbereichszuordnung. Ein leerer Wert sperrt den Aktenzugriff.",
                    label = "Veröffentlichungsversion",
                },
                dojRecordsProsecutionGradeKeys = {
                    description = "Diese Dienstgrade bearbeiten staatsanwaltschaftliche Akten.",
                    label = "Staatsanwaltschaft",
                },
                dojTabletRequireDuty = {
                    description = "Nur DOJ-Mitarbeiter im Dienst dürfen die Gesetzbuch-App öffnen.",
                    label = "Dienst erforderlich",
                },
                dojTaxCurrency = {
                    description = "Sky-Base-Währung, die nur bei direkter Zahlungsart verwendet wird.",
                    label = "Währung für Direkteinzug",
                },
                dojTaxHouseAmount = {
                    description = "Betrag, der für jedes Haus eines Spielers erhoben wird.",
                    label = "Steuer pro Haus",
                },
                dojTaxInitialDelaySeconds = {
                    description = "Sekunden bis zur ersten Erhebung, wenn noch kein vorheriger Steuerlauf gespeichert ist.",
                    label = "Startverzögerung",
                },
                dojTaxIntervalMinutes = {
                    description = "Minuten zwischen den automatischen Vermögenssteuerläufen.",
                    label = "Erhebungsintervall",
                },
                dojTaxNotifyPlayer = {
                    description = "Benachrichtigt Spieler nach Direkteinzug, Rechnungsübermittlung oder bei unzureichendem Guthaben.",
                    label = "Spieler benachrichtigen",
                },
                dojTaxPaymentMode = {
                    description = "Nutzt das gewählte Bank-/Money-Guthaben direkt oder übermittelt je steuerpflichtigem Spieler und Steuerlauf eine Sky-Base-Society-Rechnung.",
                    label = "Zahlungsart",
                    options = {
                        bills = "Sky-Base-Rechnungen",
                        direct = "Bank-/Money-Guthaben",
                    },
                },
                dojTaxSocietyJob = {
                    description = "DOJ-Job, dessen im JobConfig hinterlegtes Society-Konto alle Steuereinnahmen erhält.",
                    label = "Empfänger-DOJ-Job",
                },
                dojTaxVehicleAmount = {
                    description = "Betrag, der für jedes Fahrzeug eines Spielers erhoben wird.",
                    label = "Steuer pro Fahrzeug",
                },
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "Erlaubt Mitarbeitern, sich selbst für verfügbare Ausbildungstermine anzumelden.",
                approvalRequired = "Selbstanmeldungen bleiben offen, bis ein berechtigter Ausbilder sie freigibt.",
                defaultCapacity = "Standardanzahl der Plätze beim Erstellen eines neuen Ausbildungstermins.",
                enabled = "Macht die Ausbildungs-App für diesen Job verfügbar.",
                requireOnDuty = "Mitarbeiter müssen im Dienst sein, bevor sie die Ausbildungs-App öffnen oder verwenden können.",
                upcomingDays = "Anzahl der zukünftigen Tage, die im Zeitplan der Ausbildungs-App angezeigt werden.",
            },
            trainingFields = {
                allowSelfEnrollment = "Selbstanmeldung erlauben",
                approvalRequired = "Anmeldefreigabe erforderlich",
                defaultCapacity = "Standardkapazität",
                enabled = "Ausbildung aktivieren",
                requireOnDuty = "Dienst erforderlich",
                upcomingDays = "Vorschauzeitraum (Tage)",
            },
        },
    },
}
