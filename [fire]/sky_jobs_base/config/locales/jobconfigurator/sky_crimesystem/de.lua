JobConfigLocales["sky_crimesystem:de"] = {
    Nui = {
        workshopConfig = {
            creatorCommand = "Direktbefehl",
            roleDefaults = {
                title = "Rollen",
                description = "Lege für jedes Standardrecht den Mindestrang fest. Im Bossmenü gespeicherte Rangrechte haben Vorrang.",
                bossHint = "Boss- und CoBoss-Ränge behalten immer Vollzugriff.",
                empty = "Für diese Fraktion sind noch keine Ränge verfügbar.",
                gradesTitle = "Fraktionsränge",
                noDefault = "Kein Standardrecht",
                rankOption = "{grade} – {label}",
            },
            weaponDefaultsDescription = "Gemeinsame Vorgaben gelten für übernehmende Felder. Eine Änderung auf der Einstellungsseite stellt das Feld auf einen eigenen Wert um. Bestehende Einträge behalten ihre Werte.",
            weaponStreetDescription = "Bei einem Drogenkontakt kann der Server gelegentlich stattdessen eine zulässige Waffe ankaufen. Auswahl, Preis und Auszahlung werden ausschließlich serverseitig bestimmt.",
            weaponGroups = {
                general = "Allgemeine Vorgaben",
                access = "Zugriffsvorgaben",
                collection = "Sammelvorgaben",
                production = "Produktionsvorgaben",
                market = "Marktvorgaben",
                delivery = "Auftragsvorgaben",
                street = "Waffen-Straßenverkauf",
            },
            weaponOptions = {
                scrap_search = "Schrotthaufen durchsuchen",
                player = "Pro Spieler",
                global = "Global",
                money = "Bargeld",
                bank = "Bankkonto",
                black_money = "Schwarzgeld",
                timing = "Stoppe den Zeiger innerhalb des optimalen Bereichs.",
                precision = "Führe jeden Schnitt innerhalb des Präzisionsfensters aus.",
                pressure = "Stoppe die Presse beim optimalen Druck.",
            },

            reputation = {
                remove = "Löschen",
                title = "Ruf",
                action = "Aktion",
                points = "Punkte pro Abschluss",
                enabled = "Aktiv",
                search = "Aktionen suchen",
                added = "Bereits hinzugefügt",
                noResults = "Keine passenden Aktionen gefunden.",
                empty = "Noch keine Aktionen. Über Plus eine Aktion hinzufügen.",
                name = "Regelname",
                target = "Ziel (optional)",
            },
            configs = {
                sky_crimesystem = {
                    entries = "Fraktionen",
                    subtitle = "Konfiguriere Crime-Fraktionen und ihre gemeinsamen Orte.",
                    title = "Crime-System",
                },
            },
            creatorSections = {
                mainbaseZones = {
                    entryLabel = "Hauptdatenbank",
                    entryPluralLabel = "Hauptdatenbanken",
                    label = "Mainbase-Zone",
                },
                presetTerritories = {
                    label = "Vordefinierte Bezirke",
                    entryLabel = "Vordefinierter Bezirk",
                    entryPluralLabel = "Vordefinierte Bezirke",
                },
                customTerritories = {
                    label = "Eigene Territorien",
                    entryLabel = "Eigenes Territorium",
                    entryPluralLabel = "Eigene Territorien",
                },
                objectsSection = {
                    label = "Verhörobjekte",
                    entryLabel = "Objekt",
                    entryPluralLabel = "Verhörobjekte",
                },
                blockedZonesSection = {
                    label = "Sperrzonen",
                    entryLabel = "Gebiet",
                    entryPluralLabel = "Sperrzonen",
                },
                toolsSection = {
                    label = "Werkzeuge",
                    entryLabel = "Werkzeug",
                    entryPluralLabel = "Werkzeuge",
                },
                sessionsSection = {
                    label = "Laufende Verhöre",
                    entryLabel = "Verhör",
                    entryPluralLabel = "Laufende Verhöre",
                },
                orphansSection = {
                    label = "Verwaiste Objekte",
                    entryLabel = "Objekt",
                    entryPluralLabel = "Verwaiste Objekte",
                },
            },
            darknetActions = {
                currentLocation = "Aktuellen Standort übernehmen",
            },
            drugSettings = {
                drugGrowthCurve = {
                    description = "Hoehere Werte verlangsamen das Wachstum bei schlechter Pflege, erhalten aber starke Boni bei guter Pflege.",
                    label = "Reaktionskurve der Pflege",
                },
                drugGrowthMaxMultiplier = {
                    description = "Maximaler Wachstumsmultiplikator bei ausgezeichneten Bedingungen.",
                    label = "Multiplikator bei perfekter Pflege",
                },
                drugGrowthMinMultiplier = {
                    description = "Wachstumsmultiplikator bei kritisch schlechten Pflanzenbedingungen.",
                    label = "Multiplikator bei kritischer Pflege",
                },
                drugGrowthQualityBonusMax = {
                    description = "Maximaler zusaetzlicher Wachstumsbonus durch die Pflanzenqualitaet.",
                    label = "Wachstumsbonus durch Qualitaet",
                },
            },
            errors = {
                invalid_role_permission_defaults = "Wähle gültige Mindestränge für die Rollenrechte.",
                base_raid_locked = "Die Base wird geraidet. Ihre Lagerorte und Konfiguration sind gesperrt.",
                base_storage_outside_zone = "Alle Storage-, Spind- und Heist-Lagerpunkte müssen in der Base-Zone liegen.",
                base_zone_invalid_polygon = "Setze mindestens drei verschiedene Punkte ohne sich kreuzende Kanten. Prüfe außerdem Höhe (3–200 m) und Routing-Bucket.",
                base_zone_point_limit = "Eine Mainbase-Zone unterstützt höchstens 64 Eckpunkte.",
                base_zone_required = "Richte zuerst eine gültige Mainbase-Zone für diesen Crime-Job ein.",
                crime_interrogation_invalid_model = "Gib ein gültiges Objektmodell an.",
                crime_interrogation_invalid_coords = "Platziere das Objekt an einer gültigen Position.",
                crime_interrogation_invalid_zone_points = "Setze mindestens drei gültige Grenzpunkte.",
                crime_interrogation_duplicate_id = "Ein Objekt mit dieser ID existiert bereits.",
                crime_interrogation_tool_invalid = "Überprüfe die Werkzeugdefinition.",
                crime_interrogation_tool_id_invalid = "Gib eine gültige Werkzeug-ID an.",
                crime_interrogation_tool_label_missing = "Gib einen Namen für das Werkzeug an.",
                crime_interrogation_effect_missing = "Konfiguriere eine Wirkung für das Werkzeug.",
                crime_interrogation_effect_type_unknown = "Wähle einen unterstützten Wirkungstyp.",
                crime_interrogation_effect_status_missing = "Gib den Status an, den dieses Werkzeug beeinflusst.",
                crime_interrogation_minigame_missing = "Konfiguriere ein Minispiel für das Werkzeug.",
                crime_interrogation_minigame_type_unknown = "Wähle einen unterstützten Minispieltyp.",
                crime_interrogation_keys_missing = "Konfiguriere die Steuerung des Werkzeugs.",
                crime_interrogation_keys_invalid = "Überprüfe die konfigurierten Steuerungstasten des Werkzeugs.",
                crime_interrogation_keys_duplicate = "Ordne jede Werkzeugaktion und Steuerungstaste nur einmal zu.",
                crime_interrogation_anim_invalid = "Überprüfe Animationsverzeichnis und Clip des Werkzeugs.",
                crime_interrogation_anim_missing = "Konfiguriere eine Animation für den Werkzeugnutzer.",
                crime_interrogation_occupied = "An diesem Objekt ist bereits jemand fixiert.",
                crime_interrogation_not_found = "Das gibt es nicht mehr.",
            },
            extensions = {
                baseZone = {
                    description = "Setze 3 bis 64 Eckpunkte der Reihe nach. Der tiefste gesetzte Punkt bestimmt die Unterkante; die Höhe reicht von dort nach oben. Punkte werden als Entwurf gesichert; mit Speichern wendest du die Zone an. Nur Storage, Spind und Heist-Lager innerhalb der Zone sind bei Raids zugänglich. Punkte außerhalb verhindern weder das Speichern noch den Raid-Start. Bis zum Speichern gelten die bisherigen Grenzen weiter.",
                    fields = {
                        bucket = "Routing-Bucket",
                        configured = "Eingerichtet",
                        height = "Höhe (Meter)",
                        radius = "Radius (Meter)",
                        x = "Mittelpunkt X",
                        y = "Mittelpunkt Y",
                        z = "Mittelpunkt Z",
                    },
                    label = "Mainbase-Zone",
                },
                invalidSelection = "Ungültige Auswahl: {value}",
            },
            locationDescriptions = {
                crimeStationPosition = "Hauptpunkt dieses Job-Standorts. Wenn der Karten-Blip unter Job → Blips aktiviert ist, erscheint er hier.",
            },
            locationTypes = {
                crimeStationPosition = "Standort / Karten-Blip",
                heistCrafting = "Heist-Werkstatt",
                heistStorage = "Heist-Lager",
            },
            membershipMigration = {
                cancel = "Abbrechen",
                confirm = "Migrieren und speichern",
                message = "Bestehende Organisationsmitgliedschaften werden in das ausgewählte Modell übertragen. Im unabhängigen Modus bleibt das normale Arbeitsverhältnis getrennt bestehen.",
                title = "Mitgliedschaftsmodell ändern?",
            },
            moneywashActions = {
                currentLocation = "Aktuelle Position verwenden",
                invalidLocations = "Prüft IDs, Namen, Innenraum-Auswahl und Koordinaten. Jede Position benötigt eine eindeutige ID.",
                position = "Platzieren",
            },
            moneywashBusiness = {
                moneywashBuildNodes = { label = "Bauplätze", description = "Hier werden passende Geräte gebaut. Koordinaten sind Versätze zum gewählten Innenraum." },
                mwBuildNodes = "Bauplätze",
                moneywashPublicEquipment = { label = "Öffentliche Ausstattung", description = "Ordne öffentlichen Standorten Waschmaschinen, Generatoren und Ventilatoren auf passenden Bauplätzen zu." },
                mwPublicEquipment = "Öffentliche Ausstattung",
                moneywashMaterials = { label = "Materialien", description = "Verwende exakte Inventar-Itemnamen. Gewicht in Gramm; fehlende Items im Inventar installieren." },
                mwMaterials = "Materialien",
                moneywashMaterialRecipes = { label = "Materialrezepte", description = "Eingaben, Ausgaben und Dauer gelten pro Einheit. Verarbeiter verwenden diese Rezepte." },
                mwMaterialRecipes = "Materialrezepte",
                moneywashProductionRecipes = { label = "Druckrezepte", description = "Papier, Farbe und Schrittzeiten gelten pro Einheit. Bargeld erst nach Trocknen und Qualitätsprüfung." },
                mwProductionRecipes = "Druckrezepte",
                moneywashCollectors = { label = "Sammler", description = "Konfiguriere Ertrag, Werkzeug, Abklingzeit und Weltposition jedes Sammlers." },
                mwCollectors = "Sammler",
                moneywashProcessors = { label = "Verarbeiter", description = "Wähle für jeden Verarbeiter ein Materialrezept und die Weltposition." },
                mwProcessors = "Verarbeiter",

                control = "Control Panel",
                editor = {
                    addBusiness = "Betrieb anlegen",
                    addInterior = "Innenraum anlegen",
                    advanced = "Technische Angaben",
                    asset_ipl = "IPL: Tragt den exakten IPL-Namen und die Position des Innenraums ein.",
                    asset_mlo = "MLO: Nutzt die Position des bereits installierten Innenraums. Der Zugang erfolgt aktuell über den Betriebseingang.",
                    asset_shell = "Shell: Das Modell muss auf dem Server installiert und gestartet sein.",
                    businessHelp = "Gebt dem Betrieb einen Namen, wählt den Innenraum und legt den Kaufpreis fest.",
                    businessListHelp = "Eingänge und Kaufpreise für eure Betriebe verwalten.",
                    businesses = "Betriebe",
                    capture = "Im Spiel setzen",
                    captureOrigin = "Raumposition setzen",
                    chooseInterior = "Innenraum auswählen",
                    coordinates = "Koordinaten bearbeiten",
                    editSections = "Einrichtung",
                    emptyBusinessHelp = "Verknüpft einen Eingang auf der Karte mit einem Innenraum. Eure Organisationen können den leeren Betrieb anschließend kaufen.",
                    emptyBusinesses = "Der erste Betrieb",
                    emptyInteriorHelp = "Bindet eine IPL, eine Shell oder ein installiertes MLO ein. Legt danach die Punkte für den Betrieb fest.",
                    emptyInteriors = "Der erste Innenraum",
                    entranceHelp = "Setzt den Eingang dort, wo Spieler den Betrieb kaufen und betreten sollen.",
                    freecamHelp = "Freecam: WASD bewegen, Q/E hoch/runter, Shift schneller, Strg langsamer. Rechte Maus: umsehen. Gizmo ziehen, R drehen/verschieben, Enter setzen, Rücktaste abbrechen.",
                    general = "Allgemein",
                    heading = "Ausrichtung",
                    interiorHelp = "Wählt den Raumtyp und hinterlegt das passende Asset.",
                    interiorListHelp = "Leere Räume vorbereiten. Maschinen und Ausstattung stellen die Spieler selbst auf.",
                    interiors = "Innenräume",
                    listEmpty = "Noch keine Einträge.",
                    locationTypes = "Standortverwaltung",
                    newBusiness = "Neuer Betrieb",
                    newInterior = "Neuer Innenraum",
                    noResults = "Keine passenden Einträge.",
                    notSet = "Noch offen",
                    offsetHelp = "Die Eingabewerte sind Abstände zum Ursprung. Oben steht die Weltposition.",
                    origin = "Ursprung",
                    originHelp = "Position des Innenraums. Alle weiteren Punkte beziehen sich darauf.",
                    originRequired = "Setzt zuerst unter Allgemein die Raumposition.",
                    outsideRange = "Außerhalb des {range}-Meter-Umkreises",
                    point_control = "Verschiebe und drehe das Wandpanel mit dem Gizmo direkt an die Wand. Die bestätigte Objekthöhe wird exakt übernommen. Den Marker schaltest du unter Interactions → Money Wash: Control Panel um.",
                    point_entry = "Hier kommen Spieler an und verlassen den Innenraum. Zurück geht es automatisch zum Eingang ihres Betriebs draußen.",
                    point_position = "Dieser Punkt liegt draußen vor dem Betrieb.",
                    point_storage = "Verschiebe und drehe das Regal mit dem Gizmo bis es auf dem Boden steht. Hier greifen Mitglieder auf gekaufte Geräte zu. Den Marker schaltest du unter Interactions → Money Wash: Lager um.",
                    points = "Punkte",
                    pointsHelp = "Wählt einen Punkt aus und setzt ihn direkt im Spiel.",
                    rangeNote = "Es gilt ein {range}-Meter-Umkreis um den Interior-Ursprung, ohne Höhenbegrenzung.",
                    remove = "Entfernen",
                    repairRange = "Setze diese Punkte näher an den Interior-Ursprung.",
                    saveHint = "Änderungen oben mit Speichern übernehmen.",
                    search = "Suchen …",
                    set = "Gesetzt",
                    teleport = "Teleportieren",
                    viewInteriors = "Innenräume ansehen",
                    visit = "Ansehen",
                    visitHint = "Bewege dich frei. Rücktaste öffnet den Editor.",
                    visitTitle = "Innenraum begehen",
                },
                entry = "Ein- und Austrittspunkt",
                fields = {
                    mode = "Zugangsart",
                    ownerKind = "Eigentümertyp",
                    productionEnabled = "Gelddruck-Erweiterung verfügbar",
                    feePercent = "Gebühr (%) / -1 = global",
                    storageCapacity = "Lagerkapazität (Items)",
                    maximumOrders = "Gleichzeitige Aufträge pro Spieler",
                    gridPower = "Netzstrom-Einheiten / 0 = Generator",
                    autoService = "Öffentliche Maschinen automatisch warten",
                    maximumPendingOutputs = "Maximale offene Auszahlungen",
                    placementRange = "Platzierungsradius (m)",
                    placementHeight = "Höhenbereich zur Platzierung (m)",
                    interiorId = "Innenraum-ID",
                    equipmentId = "Geräte-ID",
                    nodeId = "Bauplatz-ID",
                    generatorNode = "Generator-Bauplatz-ID",
                    maxOffset = "Maximaler Abstand zum Bauplatz (m)",
                    maxHeight = "Maximaler Höhenversatz (m)",
                    weight = "Itemgewicht (g)",
                    inputItem = "Eingabematerial",
                    secondItem = "Zweites Eingabematerial",
                    outputItem = "Ausgabematerial",
                    requiredTool = "Erforderliches Werkzeug",
                    baseQuality = "Anfangsqualität (%)",
                    minimumQuality = "Mindestqualität (%)",
                    inspectionCards = "Prüfkarten",
                    inspectionPenalty = "Qualitätsverlust pro Fehler (%)",
                    rejectPercent = "Aussortierte Scheine (%)",
                    accessoryModel = "Zusätzliches Prop-Modell",
                    accessoryMaximum = "Maximal sichtbare Zusatzprops",
                    accessoryActiveOnly = "Zusatzprops nur bei Verarbeitung",
                    animDict = "Anim Dict",
                    animClip = "Animationsclip",
                    cooldown = "Abklingzeit (Sekunden)",
                    minimum = "Mindestertrag",
                    maximum = "Maximalertrag",
                    productionPrice = "Gelddruck · Kaufpreis",
                    recipeId = "Rezept ID",
                    inputAmount = "Material / pro Einheit",
                    secondAmount = "Material / pro Einheit",
                    outputAmount = "Material / pro Einheit",
                    paperItem = "Druckpapier",
                    inkItem = "Druckfarbe",
                    paperAmount = "Druckpapier / pro Einheit",
                    inkAmount = "Druckfarbe / pro Einheit",
                    notesPerUnit = "Geldscheine / pro Einheit",
                    valuePerNote = "Bargeld / Geldscheine",
                    maximumUnits = "Einheiten (max.)",
                    printSeconds = "Drucken / pro Einheit (Sekunden)",
                    inspectionSeconds = "Prüfen / pro Einheit (Sekunden)",
                    rinseSeconds = "Auswaschen / pro Einheit (Sekunden)",
                    drySeconds = "Trocknen / pro Einheit (Sekunden)",
                    accessoryUnit = "Geldscheine / pro Einheit",
                    accessoryX = "Zusätzliches Prop-Modell · X (m)",
                    accessoryY = "Zusätzliches Prop-Modell · Y (m)",
                    accessoryZ = "Zusätzliches Prop-Modell · Z (m)",
                    accessoryStep = "Zusätzliches Prop-Modell · Z (m)",

                    capacity = "Kapazität pro Waschgang",
                    controlHeading = "Control Panel Ausrichtung",
                    controlHeight = "Montagehöhe über dem Punkt (m)",
                    controlModel = "Wandpanel-Modell",
                    controlX = "Control Panel X",
                    controlY = "Control Panel Y",
                    controlZ = "Control Panel Z",
                    disableSets = "Ausgeblendete Entity-Sets (Komma getrennt)",
                    enableSets = "Aktivierte Entity-Sets (Komma getrennt)",
                    entryX = "Eingang-Versatz X",
                    entryY = "Eingang-Versatz Y",
                    entryZ = "Eingang-Versatz Z",
                    heading = "Ausrichtung",
                    id = "Eindeutige ID",
                    interior = "Innenraum",
                    ipl = "IPL-Name",
                    kind = "Typ",
                    label = "Bezeichnung",
                    model = "Modellname",
                    power = "Stromeinheiten",
                    price = "Kaufpreis",
                    radius = "Aufstellradius (m)",
                    repairPrice = "Reparaturpreis (0 = kostenlos)",
                    seconds = "Waschdauer (Sekunden)",
                    storageHeading = "Lagerpunkt Ausrichtung",
                    storageModel = "Regalmodell",
                    storageX = "Lagerpunkt X",
                    storageY = "Lagerpunkt Y",
                    storageZ = "Lagerpunkt Z",
                    wear = "Verschleiß pro Waschgang (%)",
                    x = "Ursprung X",
                    y = "Ursprung Y",
                    z = "Ursprung Z",
                },
                interactions = {
                    control = "Money Wash: Control Panel",
                    storage = "Money Wash: Lager",
                },
                item = "Eintrag",
                moneywashBucketStart = {
                    description = "Reserviert diesen Bereich ausschließlich für Money Wash. Änderungen gelten beim nächsten Betreten.",
                    label = "Beginn des Instanzbereichs",
                },
                moneywashEquipment = {
                    description = "Spieler kaufen und platzieren Geräte. Kapazität, Dauer und Verschleiß gelten für Waschmaschinen. Strom ist Generatorleistung oder Gerätebedarf. Änderungen gelten für neue Käufe.",
                    label = "Kaufbare Ausstattung",
                },
                moneywashInteriors = {
                    description = "Leere IPL-, Shell- oder MLO-Innenräume einrichten. Eintrittspunkt, Control Panel, Lager und Baugrenzen beziehen sich auf den Ursprung. Beim Verlassen geht es zum Eingang des eigenen Betriebs zurück.",
                    label = "Innenräume (IPL, Shell oder MLO)",
                },
                moneywashMaximumEquipment = {
                    description = "Maximale Anzahl gekaufter Geräte und Reparatursets pro Betrieb.",
                    label = "Gerätelimit",
                },
                moneywashPreviewBucketStart = {
                    description = "Visit nutzt diesen Wert plus Spieler-ID für eine eigene Admin-Instanz. Separat von Betrieben und anderen Ressourcen reservieren. Änderungen gelten ab der nächsten Vorschau.",
                    label = "Beginn des Vorschau-Instanzbereichs",
                },
                moneywashProperties = {
                    description = "Eingang setzen, Innenraum auswählen und Kaufpreis festlegen. Gekaufte Betriebe behalten ihren gespeicherten Innenraum und ihre Einrichtung.",
                    label = "Betriebseingänge",
                },
                moneywashRepairShops = {
                    description = "Legt Repair Shops an, teleportiert dorthin und bestimmt den Reparaturpreis. Sie verkaufen Reparatursets und warten eingelagerte Maschinen.",
                    label = "Shop-Standorte",
                },
                moneywashShops = {
                    description = "Platziert Shops für Waschmaschinen, Generatoren und Ventilatoren. Käufe gehen an den gewählten Organisationsbetrieb.",
                    label = "Shop-Standorte",
                },
                mwEquipment = "Geräteshop",
                mwInteriors = "Leere Innenräume",
                mwProperties = "Locations",
                mwRepairShops = "Repair Shop",
                mwSettings = "Betriebseinstellungen",
                names = {
                    mwPublicLaundry = "Öffentliche Wäscherei",
                    mwPaperPulp = "Papierfasern",
                    mwPrintingPaper = "Druckpapier",
                    mwPrintingInk = "Druckfarbe",
                    mwPaperRecipe = "Druckpapier herstellen",
                    mwPrintingRecipe = "Standard-Geldscheine",
                    mwPaperCollector = "Papiersammler",
                    mwInkCollector = "Farbsammler",
                    mwPaperProcessor = "Papierverarbeiter",
                    mwPrinter = "Druckmaschine",
                    mwInspectionTable = "Prüftisch",
                    mwDryingCabinet = "Trockenschrank",
                    mwNode1 = "1 · Auswaschen",
                    mwNode2 = "2 · Auswaschen",
                    mwNode3 = "3 · Bauplätze",
                    mwNode4 = "4 · Drucken",
                    mwNode5 = "5 · Prüfen",
                    mwNode6 = "6 · Trocknen",
                    mwNode7 = "7 · Bauplätze",

                    mwInteriorWarehouse = "Leere Lagerhalle",
                },
                options = {
                    private = "Privat",
                    public = "Öffentlich",
                    faction = "Fraktion",
                    person = "Charakter",
                    printer = "Druckmaschine",
                    inspection = "Prüftisch",
                    dryer = "Trockenschrank",

                    fan = "Ventilator",
                    generator = "Generator",
                    ipl = "IPL",
                    mlo = "MLO",
                    repair = "Reparaturset",
                    shell = "Shell-Modell",
                    washer = "Waschmaschine",
                },
                origin = "Ursprung",
                storage = "Lagerpunkt",
            },
            settingFields = {
                cultivationLevel = "Anbau-Level",
                cultivationTitle = "Levelname",
                cultivationRequiredXp = "Benötigte Gesamt-XP",
                cultivationAction = "Aktion",
                cultivationXp = "XP",
                cultivationCategory = "Kategorie",
                cultivationEntry = "Eintrag",
                cultivationRequiredLevel = "Benötigtes Level",
                alias = "Alias",
                atmHeading = "Ausrichtung",
                atmId = "ID",
                atmModel = "ATM-Modell",
                centerX = "Zentrum X",
                centerY = "Zentrum Y",
                centerZ = "Zentrum Z",
                deliveryMethod = "Übergabeart",
                description = "Beschreibung",
                enabled = "Aktiv",
                groupKey = "Gruppenschlüssel",
                id = "ID",
                itemLabel = "Warenname",
                itemName = "Inventar-Itemname",
                knownScammer = "Bekannter Betrüger",
                locationName = "Standortname",
                observerW = "Zuschauer-Ausrichtung",
                observerX = "Zuschauer X",
                observerY = "Zuschauer Y",
                observerZ = "Zuschauer Z",
                pedModel = "NPC-Pedmodell",
                pickpocketItemChance = "Zufall (%)",
                pickpocketItemMaximum = "Höchstmenge",
                pickpocketItemMinimum = "Mindestmenge",
                pickpocketItemName = "Inventar-Itemname",
                quantity = "Menge",
                radius = "Radius",
                rating = "Angezeigte Bewertung",
                ratingCount = "Angezeigte Bewertungsanzahl",
                scamChance = "Händler-Betrugswahrscheinlichkeit (%)",
                shopCategory = "Kategorie",
                shopClerkHeading = "Angestelltenausrichtung",
                shopClerkModel = "Angestelltenmodell",
                shopClerkRequired = "Angestellter erforderlich",
                shopClerkX = "Angestellter X",
                shopClerkY = "Angestellter Y",
                shopClerkZ = "Angestellter Z",
                shopCodeEnabled = "Öffnen per Code erlauben",
                shopDrillEnabled = "Aufbohren erlauben",
                shopEnabled = "Aktiviert",
                shopHackEnabled = "Hacken erlauben",
                shopLocationId = "Laden-ID",
                shopLocationLabel = "Bezeichnung",
                shopRegisterId = "Kassen-ID",
                shopSafeEnabled = "Tresor aktiviert",
                shopSafeHeading = "Tresorausrichtung",
                shopSafeX = "Tresor X",
                shopSafeY = "Tresor Y",
                shopSafeZ = "Tresor Z",
                side = "Marktseite",
                spawns = "Team-Spawns",
                successfulTrades = "Angezeigte erfolgreiche Handel",
                title = "Anzeigentitel",
                unitPrice = "Stückpreis",
                verified = "Verifizierter Händler",
                w = "Ausrichtung",
                x = "X",
                y = "Y",
                z = "Z",
                shopClerkPosition = "Angestelltenposition",
                shopRegisterPosition = "Kassenposition",
                shopSafePosition = "Tresorposition",
                registerId = "Kassen-ID",
                registerX = "Kasse X",
                registerY = "Kasse Y",
                registerZ = "Kasse Z",
                heading = "Ausrichtung",
                captureLocation = "Position erfassen",
            },
            crimeDashboard = {
                jobs = "Fraktionen, Mitglieder, Berechtigungen und Standorte verwalten.",
                jobCreator = "Eine Fraktion auswählen, um ihre Standorte und Bereiche zu bearbeiten.",
                jobsQuestion = "Wo bearbeite ich Fraktionen und Standorte?",
                jobsAnswer = "Öffne {path}, wähle eine Fraktion aus und klicke auf Bearbeiten. Dort kannst du ihre Einstellungen und Standorte anpassen.",
                creatorsAnswer = "Die Editoren findest du unter {path}. Diese Links öffnen den Editor; Fraktionswerkzeuge beginnen mit der Fraktionsauswahl.",
                missingAnswer = "Die verfügbaren Editoren richten sich nach der Ressource und ihren Einstellungen. Fraktionswerkzeuge beginnen bei der jeweiligen Fraktion.",
                creators = {
                    mainbaseZones = "Eine Fraktion auswählen und ihren Basisbereich konfigurieren.",
                    presetTerritories = "Vorgegebene Gebiete ansehen und auswählen, welche aktiviert sind.",
                    objectsSection = "Dauerhafte Verhörstühle und Werkzeugwagen verwalten.",
                    blockedZonesSection = "Bereiche festlegen, in denen keine Verhörobjekte platziert werden dürfen.",
                    toolsSection = "Die bei Verhören verfügbaren Werkzeuge konfigurieren.",
                    sessionsSection = "Laufende Verhöre ansehen und Sitzungen bei Bedarf beenden.",
                    orphansSection = "Verlassene Verhörobjekte prüfen und entfernen.",
                },
            },
            crimeGroupDescriptions = {
                general = {
                    crimeMembership = "Lege fest, wie Crime-Organisationen ihre Mitglieder speichern und verwalten.",
                },
                territories = {
                    zones = "Einstellungen für „Territoriumszonen“ im Bereich „Territorien“ anpassen.",
                    ownership = "Einstellungen für „Besitz“ im Bereich „Territorien“ anpassen.",
                    decay = "Einstellungen für „Verfall“ im Bereich „Territorien“ anpassen.",
                    presence = "Einstellungen für „Präsenz“ im Bereich „Territorien“ anpassen.",
                    activity = "Einstellungen für „Aktivitätswertung“ im Bereich „Territorien“ anpassen.",
                    ownershipBenefits = "Einstellungen für „Besitzboni“ im Bereich „Territorien“ anpassen.",
                },
                graffiti = {
                    general = "Einstellungen für „Allgemein“ im Bereich „Graffiti“ anpassen.",
                    streaming = "Einstellungen für „Darstellung“ im Bereich „Graffiti“ anpassen.",
                    moderation = "Einstellungen für „Moderation“ im Bereich „Graffiti“ anpassen.",
                },
                pvpEvents = {
                    pvpAvailability = "Steuert, ob die PvP-Event-App verfügbar ist und wo sie angezeigt wird.",
                    pvpAutomation = "Konfiguriert wiederkehrende Events und automatische Starts.",
                    pvpRuntime = "Stellt Anfragen, Tode und Respawns während laufender Events ein.",
                    pvpModes = "Konfiguriert den vorausgewählten Spielmodus für das PvP-Tablet.",
                    pvpArenas = "Erstellt die runde Kampfzone, den Zuschauerpunkt und die Team-Spawns für PvP-Events.",
                    pvpLimits = "Legt Limits für Belohnungen und den Tablet-Verlauf fest.",
                    pvpPermissions = "Ordnet Eventverwaltung und Finanzen ACE- und Job-Berechtigungen zu.",
                    pvpTakeoverRules = "Steuert die Verfügbarkeit und die Voraussetzungen für Labor- und Camperübernahmen.",
                    pvpTakeoverZones = "Legt Interaktions-, Alarm- und Eroberungsbereiche sowie deren Dauer fest.",
                    pvpTakeoverMethods = "Legt fest, wie lange die einzelnen Methoden zum Aufbrechen eines Eingangs dauern.",
                },
                drugs = {
                    creator = "Öffnet den Sky-Crime-Drogen-Editor und schließt den Job-Konfigurator.",
                    creatorSettings = "Einstellungen für „Editor-Einstellungen“ im Bereich „Drogensystem“ anpassen.",
                    interfaceHud = "Einstellungen für „UI-Locations“ im Bereich „Drogensystem“ anpassen.",
                    drugsGeneral = "Einstellungen für „Allgemein“ im Bereich „Drogensystem“ anpassen.",
                    runtimeAccess = "Einstellungen für „Zugriff & Eigentum“ im Bereich „Drogensystem“ anpassen.",
                    runtimePayouts = "Einstellungen für „Auszahlungen“ im Bereich „Drogensystem“ anpassen.",
                    runtimeDispatch = "Einstellungen für „Leitstelle & Polizei“ im Bereich „Drogensystem“ anpassen.",
                    performanceInactiveControlIntervalMs = "Konfigurationswert für Leistung / Inaktiv / Steuerung / Intervall / ms.",
                    performanceInteractionIdleScanIntervalMs = "Konfigurationswert für Leistung / Interaktion / Leerlauf / Prüfintervall / ms.",
                    performanceInteractionPromptIntervalMs = "Konfigurationswert für Leistung / Interaktion / Interaktionshinweis / Intervall / ms.",
                    performanceInteractionScanIntervalMs = "Konfigurationswert für Leistung / Interaktion / Prüfintervall / ms.",
                    performanceMinimumScanIntervalMs = "Konfigurationswert für Leistung / Minimum / Prüfintervall / ms.",
                    performanceStreetPedActivationDistance = "Konfigurationswert für Leistung / Straße / NPC / Aktivierung / Entfernung.",
                    performanceStreetPedIdleScanIntervalMs = "Konfigurationswert für Leistung / Straße / NPC / Leerlauf / Prüfintervall / ms.",
                    performanceStreetPedScanIntervalMs = "Konfigurationswert für Leistung / Straße / NPC / Prüfintervall / ms.",
                    performanceWorldCachePadding = "Konfigurationswert für Leistung / Welt / Zwischenspeicher / Zusatzabstand.",
                    performanceWorldCacheRefreshIntervalMs = "Konfigurationswert für Leistung / Welt / Zwischenspeicher / Aktualisierung / Intervall / ms.",
                    performanceWorldIdleIntervalMs = "Konfigurationswert für Leistung / Welt / Leerlauf / Intervall / ms.",
                },
                drugProduction = {
                    qualityWeights = "Einstellungen für „Qualität / Gewichtungen“ im Bereich „Drogenproduktion“ anpassen.",
                    qualityTiers = "Einstellungen für „Qualität / Qualitätsstufen“ im Bereich „Drogenproduktion“ anpassen.",
                    packagingGeneral = "Einstellungen für „Allgemein“ im Bereich „Drogenproduktion“ anpassen.",
                    processingFlow = "Einstellungen für „Verarbeitungsablauf“ im Bereich „Drogenproduktion“ anpassen.",
                    processingGeneral = "Einstellungen für „Allgemein“ im Bereich „Drogenproduktion“ anpassen.",
                },
                drugOperations = {
                    growingGeneral = "Einstellungen für „Allgemein“ im Bereich „Drogenbetriebe“ anpassen.",
                    plantDefaults = "Einstellungen für „Pflanze / Standardwerte“ im Bereich „Drogenbetriebe“ anpassen.",
                    harvestWindow = "Einstellungen für „Ernte / Zeitfenster“ im Bereich „Drogenbetriebe“ anpassen.",
                    labsGeneral = "Aktiviert: Labore und Wohnmobile im Spielbetrieb.",
                    labRent = "Einstellungen für „Miete & Laufzeit“ im Bereich „Drogenbetriebe“ anpassen.",
                    camperDefaults = "Einstellungen für „Wohnmobil“ im Bereich „Drogenbetriebe“ anpassen.",
                    labUpgrades = "Multiplikator für Labor / Stufe / Verbesserung / Preise.",
                    labDefaults = "Einstellungen für „Labor / Standardwerte“ im Bereich „Drogenbetriebe“ anpassen.",
                    powerGeneral = "Einstellungen für „Allgemein“ im Bereich „Drogenbetriebe“ anpassen.",
                    generators = "Einstellungen für „Generatoren“ im Bereich „Drogenbetriebe“ anpassen.",
                    equipmentWear = "Globaler Multiplikator für Ausrüstungsverschleiß / Verarbeitung.",
                    workersGeneral = "Einstellungen für „Allgemein“ im Bereich „Drogenbetriebe“ anpassen.",
                    cultivationGeneral = "Einstellungen für „Allgemein“ im Bereich „Drogenbetriebe“ anpassen.",
                    cultivationCurve = "Legt Namen und benötigte Gesamt-XP für jedes Anbau-Level fest.",
                    cultivationExperience = "Legt fest, wie viele Anbau-XP jede Anbauaktion vergibt.",
                    cultivationUnlocks = "Legt die benötigten Anbau-Level für Behälter, Substrate, Ausrüstung, Sorten und Scannerstufen fest.",
                    powerRuntime = "Intervall in Sekunden für Aktualisierung von Generatorverbrauch und Stromsignaturen.",
                    powerHeat = "Einstellungen für „Fahndungsdruck & Stromsignatur“ im Bereich „Drogenbetriebe“ anpassen.",
                    powerModes = "Einstellungen für „Verwaltung / Modi“ im Bereich „Drogenbetriebe“ anpassen.",
                    powerPriorities = "Einstellungen für „Auslastung / Prioritäten“ im Bereich „Drogenbetriebe“ anpassen.",
                },
                drugMarketRisk = {
                    marketGeneral = "Einstellungen für „Allgemein“ im Bereich „Markt & Risiko“ anpassen.",
                    marketPrices = "Einstellungen für „Preise“ im Bereich „Markt & Risiko“ anpassen.",
                    distribution = "Einstellungen für „Vertrieb“ im Bereich „Markt & Risiko“ anpassen.",
                    threatsGeneral = "Einstellungen für „Allgemein“ im Bereich „Markt & Risiko“ anpassen.",
                    threatHeat = "Einstellungen für „Fahndungsdruck“ im Bereich „Markt & Risiko“ anpassen.",
                    threatChances = "Einstellungen für „Wahrscheinlichkeiten“ im Bereich „Markt & Risiko“ anpassen.",
                    consumptionGeneral = "Einstellungen für „Allgemein“ im Bereich „Markt & Risiko“ anpassen.",
                    consumerDecay = "Einstellungen für „Abbau von Toleranz & Abhängigkeit“ im Bereich „Markt & Risiko“ anpassen.",
                    consumerEffects = "Einstellungen für „Wirkungen & Risiken“ im Bereich „Markt & Risiko“ anpassen.",
                },
                drugNetworks = {
                    dynamicMarketActionCooldownSeconds = "Konfigurationswert für Dynamischer Markt / Aktions-Cooldown / Sekunden.",
                    dynamicMarketActionHistoryLimit = "Konfigurationswert für Dynamischer Markt / Aktion / Historienlimit.",
                    dynamicMarketAmountSaturationWeight = "Konfigurationswert für Dynamischer Markt / Menge / Marktsättigung / Gewichtung.",
                    dynamicMarketBaseIntelAccuracy = "Konfigurationswert für Dynamischer Markt / Grundwert / Informationsgenauigkeit.",
                    dynamicMarketDefaultAverageQuality = "Konfigurationswert für Dynamischer Markt / Standardwert / Durchschnitt / Qualität.",
                    dynamicMarketDefaultResourceElasticity = "Konfigurationswert für Dynamischer Markt / Standardwert / Rohstoff / Elastizität.",
                    dynamicMarketDemandCenter = "Konfigurationswert für Dynamischer Markt / Nachfrage / Mittelwert.",
                    dynamicMarketDemandPriceImpact = "Konfigurationswert für Dynamischer Markt / Nachfrage / Preis / Einfluss.",
                    dynamicMarketDirectionThreshold = "Konfigurationswert für Dynamischer Markt / Richtung / Schwellenwert.",
                    dynamicMarketEnabled = "Konfigurationswert für Dynamischer Markt / Aktiviert.",
                    dynamicMarketEventChance = "Konfigurationswert für Dynamischer Markt / Ereignis / Chance.",
                    dynamicMarketEventDurationMinutes = "Konfigurationswert für Dynamischer Markt / Ereignis / Dauer / Minuten.",
                    dynamicMarketEventMinimumDurationMinutes = "Konfigurationswert für Dynamischer Markt / Ereignis / Minimum / Dauer / Minuten.",
                    dynamicMarketEventStrengthMaximum = "Konfigurationswert für Dynamischer Markt / Ereignis / Stärke / Maximum.",
                    dynamicMarketEventStrengthMinimum = "Konfigurationswert für Dynamischer Markt / Ereignis / Stärke / Minimum.",
                    dynamicMarketEvents = "Einstellungen für „Ereignisse“ im Bereich „Drogennetzwerke“ anpassen.",
                    dynamicMarketExactIntelReputation = "Konfigurationswert für Dynamischer Markt / Genaue Informationen / Ruf.",
                    dynamicMarketExactIntelTrust = "Konfigurationswert für Dynamischer Markt / Genaue Informationen / Vertrauen.",
                    dynamicMarketGlobalZoneLabel = "Konfigurationswert für Dynamischer Markt / Global / Zone / Bezeichnung.",
                    dynamicMarketHistoryLimit = "Konfigurationswert für Dynamischer Markt / Historienlimit.",
                    dynamicMarketInitialDemand = "Konfigurationswert für Dynamischer Markt / Anfangswert / Nachfrage.",
                    dynamicMarketInitialPriceMultiplier = "Konfigurationswert für Dynamischer Markt / Anfangswert / Preismultiplikator.",
                    dynamicMarketIntelDemandError = "Konfigurationswert für Dynamischer Markt / Informationen / Nachfrage / Fehler.",
                    dynamicMarketIntelMaximumAccuracy = "Konfigurationswert für Dynamischer Markt / Informationen / Maximum / Genauigkeit.",
                    dynamicMarketIntelMinimumAccuracy = "Konfigurationswert für Dynamischer Markt / Informationen / Minimum / Genauigkeit.",
                    dynamicMarketIntelPoliceError = "Konfigurationswert für Dynamischer Markt / Informationen / Polizei / Fehler.",
                    dynamicMarketIntelPriceError = "Konfigurationswert für Dynamischer Markt / Informationen / Preis / Fehler.",
                    dynamicMarketIntelPriceMaximum = "Konfigurationswert für Dynamischer Markt / Informationen / Preis / Maximum.",
                    dynamicMarketIntelPriceMinimum = "Konfigurationswert für Dynamischer Markt / Informationen / Preis / Minimum.",
                    dynamicMarketIntelReputationWeight = "Konfigurationswert für Dynamischer Markt / Informationen / Ruf / Gewichtung.",
                    dynamicMarketIntelResourcePriceError = "Konfigurationswert für Dynamischer Markt / Informationen / Rohstoff / Preis / Fehler.",
                    dynamicMarketIntelSaturationError = "Konfigurationswert für Dynamischer Markt / Informationen / Marktsättigung / Fehler.",
                    dynamicMarketIntelSeedBucketSeconds = "Konfigurationswert für Dynamischer Markt / Zeitfenster für den Informations-Zufallswert / Sekunden.",
                    dynamicMarketIntelStatusAccuracyThreshold = "Konfigurationswert für Dynamischer Markt / Informationen / Status / Genauigkeit / Schwellenwert.",
                    dynamicMarketIntelStatusErrorThreshold = "Konfigurationswert für Dynamischer Markt / Informationen / Status / Fehler / Schwellenwert.",
                    dynamicMarketIntelSupplyError = "Konfigurationswert für Dynamischer Markt / Informationen / Versorgung / Fehler.",
                    dynamicMarketIntelTrustWeight = "Konfigurationswert für Dynamischer Markt / Informationen / Vertrauen / Gewichtung.",
                    dynamicMarketManipulationCooldownMinutes = "Konfigurationswert für Dynamischer Markt / Manipulation / Cooldown-Minuten.",
                    dynamicMarketManipulationDemandShift = "Konfigurationswert für Dynamischer Markt / Manipulation / Nachfrage / Verschiebung.",
                    dynamicMarketManipulationDurationMinutes = "Konfigurationswert für Dynamischer Markt / Manipulation / Dauer / Minuten.",
                    dynamicMarketManipulationHeat = "Konfigurationswert für Dynamischer Markt / Manipulation / Fahndungsdruck.",
                    dynamicMarketManipulationMinimumBatchAmount = "Konfigurationswert für Dynamischer Markt / Manipulation / Minimum / Charge / Menge.",
                    dynamicMarketManipulationPaymentAccount = "Konfigurationswert für Dynamischer Markt / Manipulation / Zahlungskonto.",
                    dynamicMarketManipulationPrice = "Konfigurationswert für Dynamischer Markt / Manipulation / Preis.",
                    dynamicMarketManipulationZoneHeatMultiplier = "Konfigurationswert für Dynamischer Markt / Manipulation / Zone / Fahndungsdruck / Multiplikator.",
                    dynamicMarketMaximumIntelAgeMinutes = "Konfigurationswert für Dynamischer Markt / Maximum / Informationsalter / Minuten.",
                    dynamicMarketMaximumPriceMultiplier = "Konfigurationswert für Dynamischer Markt / Maximum / Preismultiplikator.",
                    dynamicMarketMinimumIntelAgeMinutes = "Konfigurationswert für Dynamischer Markt / Minimum / Informationsalter / Minuten.",
                    dynamicMarketMinimumMetricWindowMinutes = "Konfigurationswert für Dynamischer Markt / Minimum / Messwert / Zeitfenster / Minuten.",
                    dynamicMarketMinimumPriceMultiplier = "Konfigurationswert für Dynamischer Markt / Mindestpreis / Multiplikator.",
                    dynamicMarketMinimumUpdateMinutes = "Konfigurationswert für Dynamischer Markt / Minimum / Aktualisierung / Minuten.",
                    dynamicMarketPoliceDemandWeight = "Konfigurationswert für Dynamischer Markt / Polizei / Nachfrage / Gewichtung.",
                    dynamicMarketPolicePriceImpact = "Konfigurationswert für Dynamischer Markt / Polizei / Preis / Einfluss.",
                    dynamicMarketPoorQualityDemandPenalty = "Konfigurationswert für Dynamischer Markt / Schlechte Qualität / Nachfrage / Abzug.",
                    dynamicMarketPoorQualityThreshold = "Konfigurationswert für Dynamischer Markt / Schlechte Qualität / Schwellenwert.",
                    dynamicMarketPremiumQualityDemandBonus = "Konfigurationswert für Dynamischer Markt / Premiumqualität / Nachfragebonus.",
                    dynamicMarketPremiumQualityThreshold = "Konfigurationswert für Dynamischer Markt / Premiumqualität / Schwellenwert.",
                    dynamicMarketProductionSupplyWeight = "Konfigurationswert für Dynamischer Markt / Produktion / Versorgung / Gewichtung.",
                    dynamicMarketProductionWindowMinutes = "Konfigurationswert für Dynamischer Markt / Produktion / Zeitfenster / Minuten.",
                    dynamicMarketQualityCenter = "Konfigurationswert für Dynamischer Markt / Qualität / Mittelwert.",
                    dynamicMarketQualityConfidenceImpact = "Konfigurationswert für Dynamischer Markt / Qualität / Verlässlichkeit / Einfluss.",
                    dynamicMarketQualityRange = "Konfigurationswert für Dynamischer Markt / Qualität / Wertebereich.",
                    dynamicMarketRarityBonusMaximum = "Konfigurationswert für Dynamischer Markt / Seltenheit / Bonus / Maximum.",
                    dynamicMarketRegionalGlobalWeight = "Konfigurationswert für Dynamischer Markt / Regional / Global / Gewichtung.",
                    dynamicMarketRegionalLocalWeight = "Konfigurationswert für Dynamischer Markt / Regional / Lokal / Gewichtung.",
                    dynamicMarketResourceAliases = "Einstellungen für „Rohstoff / Alternative Bezeichnungen“ im Bereich „Drogennetzwerke“ anpassen.",
                    dynamicMarketResourceDirectionFallThreshold = "Konfigurationswert für Dynamischer Markt / Rohstoff / Richtung / Rückgang / Schwellenwert.",
                    dynamicMarketResourceDirectionRiseThreshold = "Konfigurationswert für Dynamischer Markt / Rohstoff / Richtung / Anstieg / Schwellenwert.",
                    dynamicMarketResources = "Einstellungen für „Rohstoffe“ im Bereich „Drogennetzwerke“ anpassen.",
                    dynamicMarketSalesWindowMinutes = "Konfigurationswert für Dynamischer Markt / Verkäufe / Zeitfenster / Minuten.",
                    dynamicMarketSaturationDemandWeight = "Konfigurationswert für Dynamischer Markt / Marktsättigung / Nachfrage / Gewichtung.",
                    dynamicMarketSaturationPriceImpact = "Konfigurationswert für Dynamischer Markt / Marktsättigung / Preis / Einfluss.",
                    dynamicMarketScarcityDemandWeight = "Konfigurationswert für Dynamischer Markt / Knappheit / Nachfrage / Gewichtung.",
                    dynamicMarketScarcityPriceImpact = "Konfigurationswert für Dynamischer Markt / Knappheit / Preis / Einfluss.",
                    dynamicMarketSeasonEndMonths = "Einstellungen für „Jahreszeit / Ende / Monate“ im Bereich „Drogennetzwerke“ anpassen.",
                    dynamicMarketSeasonMultipliers = "Einstellungen für „Jahreszeit / Multiplikatoren“ im Bereich „Drogennetzwerke“ anpassen.",
                    dynamicMarketShortageRumorThreshold = "Konfigurationswert für Dynamischer Markt / Engpass / Gerücht / Schwellenwert.",
                    dynamicMarketStatusThresholds = "Einstellungen für „Status / Schwellenwerte“ im Bereich „Drogennetzwerke“ anpassen.",
                    dynamicMarketTargetSupply = "Konfigurationswert für Dynamischer Markt / Ziel / Versorgung.",
                    dynamicMarketTrendChance = "Konfigurationswert für Dynamischer Markt / Trend / Chance.",
                    dynamicMarketTrendDurationMinutes = "Konfigurationswert für Dynamischer Markt / Trend / Dauer / Minuten.",
                    dynamicMarketTrendMaximumStrength = "Konfigurationswert für Dynamischer Markt / Trend / Maximum / Stärke.",
                    dynamicMarketTrendMinimumStrength = "Konfigurationswert für Dynamischer Markt / Trend / Minimum / Stärke.",
                    dynamicMarketUpdateMinutes = "Konfigurationswert für Dynamischer Markt / Aktualisierung / Minuten.",
                    dynamicMarketVolatilityMaximum = "Konfigurationswert für Dynamischer Markt / Preisschwankung / Maximum.",
                    dynamicMarketVolatilityMinimum = "Konfigurationswert für Dynamischer Markt / Preisschwankung / Minimum.",
                    dynamicMarketWeatherMultipliers = "Einstellungen für „Wetter / Multiplikatoren“ im Bereich „Drogennetzwerke“ anpassen.",
                    dynamicMarketWeatherState = "Konfigurationswert für Dynamischer Markt / Wetter / Status.",
                    heatActionCooldownSeconds = "Konfigurationswert für Fahndungsdruck & Risiko / Aktions-Cooldown / Sekunden.",
                    heatActivityRiskWeights = "Einstellungen für „Aktivität / Risiko / Gewichtungen“ im Bereich „Drogennetzwerke“ anpassen.",
                    heatAggressiveHeatMultiplier = "Konfigurationswert für Fahndungsdruck & Risiko / Aggressive Arbeitsweise / Fahndungsdruck / Multiplikator.",
                    heatBurnerBurnThreshold = "Konfigurationswert für Fahndungsdruck & Risiko / Wegwerftelefon / Enttarnung / Schwellenwert.",
                    heatBurnerHeatPerWholesale = "Konfigurationswert für Fahndungsdruck & Risiko / Wegwerftelefon / Fahndungsdruck / Je Großhandelsgeschäft.",
                    heatBurnerPhoneItem = "Konfigurationswert für Fahndungsdruck & Risiko / Wegwerfhandy / Gegenstand.",
                    heatCamperOperationalHeatMultiplier = "Konfigurationswert für Fahndungsdruck & Risiko / Wohnmobil im Betrieb / Fahndungsdruck / Multiplikator.",
                    heatCamperOperationalHeatThreshold = "Konfigurationswert für Fahndungsdruck & Risiko / Wohnmobil im Betrieb / Fahndungsdruck / Schwellenwert.",
                    heatCamperParkedHeat = "Konfigurationswert für Fahndungsdruck & Risiko / Geparktes Wohnmobil / Fahndungsdruck.",
                    heatContaminatedHeatMultiplier = "Konfigurationswert für Fahndungsdruck & Risiko / Verunreinigung / Fahndungsdruck / Multiplikator.",
                    heatContaminatedThreshold = "Konfigurationswert für Fahndungsdruck & Risiko / Verunreinigung / Schwellenwert.",
                    heatCultivationFreePlants = "Konfigurationswert für Fahndungsdruck & Risiko / Anbau / Pflanzen ohne Risikozuschlag.",
                    heatCultivationHeatPerPlant = "Konfigurationswert für Fahndungsdruck & Risiko / Anbau / Fahndungsdruck / Je Pflanze.",
                    heatDealerHiddenMinutes = "Konfigurationswert für Fahndungsdruck & Risiko / Dealer / versteckt / Minuten.",
                    heatDecayPerTick = "Einstellungen für „Verfall / Je Aktualisierungsschritt“ im Bereich „Drogennetzwerke“ anpassen.",
                    heatEnabled = "Konfigurationswert für Fahndungsdruck & Risiko / Aktiviert.",
                    heatEnforcementHeat = "Einstellungen für „Polizeipräsenz / Fahndungsdruck“ im Bereich „Drogennetzwerke“ anpassen.",
                    heatEnforcementMultipliers = "Einstellungen für „Polizeipräsenz / Multiplikatoren“ im Bereich „Drogennetzwerke“ anpassen.",
                    heatEntityTypes = "Einstellungen für „Spielobjekt / Typen“ im Bereich „Drogennetzwerke“ anpassen.",
                    heatEventCooldownMinutes = "Konfigurationswert für Fahndungsdruck & Risiko / Ereignis / Cooldown-Minuten.",
                    heatEventHistoryLimit = "Konfigurationswert für Fahndungsdruck & Risiko / Ereignis / Historienlimit.",
                    heatLabHeatSyncThreshold = "Konfigurationswert für Fahndungsdruck & Risiko / Labor / Fahndungsdruck / Abgleich / Schwellenwert.",
                    heatLayLowCooldownMinutes = "Konfigurationswert für Fahndungsdruck & Risiko / Untertauchen / Cooldown-Minuten.",
                    heatLayLowIdleMinutes = "Konfigurationswert für Fahndungsdruck & Risiko / Untertauchen / Leerlauf / Minuten.",
                    heatLayLowReduction = "Konfigurationswert für Fahndungsdruck & Risiko / Untertauchen / Verringerung.",
                    heatLockdownMinutes = "Konfigurationswert für Fahndungsdruck & Risiko / Abriegelung / Minuten.",
                    heatMinimumDurationMinutes = "Konfigurationswert für Fahndungsdruck & Risiko / Minimum / Dauer / Minuten.",
                    heatMinimumEventCooldownSeconds = "Konfigurationswert für Fahndungsdruck & Risiko / Minimum / Ereignis / Abklingzeit (Sekunden).",
                    heatMinimumIdleSeconds = "Konfigurationswert für Fahndungsdruck & Risiko / Minimum / Leerlauf / Sekunden.",
                    heatProcessingHeatMultiplier = "Konfigurationswert für Fahndungsdruck & Risiko / Verarbeitung / Fahndungsdruck / Multiplikator.",
                    heatRiskWeights = "Einstellungen für „Risiko / Gewichtungen“ im Bereich „Drogennetzwerke“ anpassen.",
                    heatRotateBurnerReduction = "Konfigurationswert für Fahndungsdruck & Risiko / Wegwerftelefon wechseln / Verringerung.",
                    heatRouteControlMinutes = "Konfigurationswert für Fahndungsdruck & Risiko / Route / Steuerung / Minuten.",
                    heatSaleHeat = "Einstellungen für „Verkauf / Fahndungsdruck“ im Bereich „Drogennetzwerke“ anpassen.",
                    heatThresholds = "Einstellungen für „Schwellenwerte“ im Bereich „Drogennetzwerke“ anpassen.",
                    heatTickMinutes = "Konfigurationswert für Fahndungsdruck & Risiko / Aktualisierungsschritt / Minuten.",
                    heatWholesaleHeatMultiplier = "Konfigurationswert für Fahndungsdruck & Risiko / Großhandel / Fahndungsdruck / Multiplikator.",
                    heatWorkerLeakAlertRadius = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Alarmradius.",
                    heatWorkerLeakBaseChance = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Grundwert / Chance.",
                    heatWorkerLeakFactionMultiplier = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Fraktion / Multiplikator.",
                    heatWorkerLeakHighSeverityThreshold = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Hoch / Schweregrad / Schwellenwert.",
                    heatWorkerLeakLoyaltyChanceMultiplier = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Loyalität / Chance / Multiplikator.",
                    heatWorkerLeakLoyaltyThreshold = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Loyalität / Schwellenwert.",
                    heatWorkerLeakMaximumChance = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Maximum / Chance.",
                    heatWorkerLeakMinimumCooldownSeconds = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Minimum / Abklingzeit (Sekunden).",
                    heatWorkerLeakRouteMultiplier = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Route / Multiplikator.",
                    heatWorkerLeakStrengthMaximum = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Stärke / Maximum.",
                    heatWorkerLeakStrengthMinimum = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Stärke / Minimum.",
                    heatWorkerLeakStrengthMultiplier = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Stärke / Multiplikator.",
                    heatWorkerLeakStressChanceMultiplier = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Stress / Chance / Multiplikator.",
                    heatWorkerLeakStressThreshold = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Stress / Schwellenwert.",
                    contactsActionCooldownSeconds = "Konfigurationswert für Kontaktnetzwerk / Aktions-Cooldown / Sekunden.",
                    contactsActiveHotspotCount = "Konfigurationswert für Kontaktnetzwerk / Anzahl aktiver Brennpunkte.",
                    contactsBurnerHintTrust = "Konfigurationswert für Kontaktnetzwerk / Wegwerfhandy-Hinweis / Vertrauen.",
                    contactsBurnerOfferMaximumMultiplier = "Konfigurationswert für Kontaktnetzwerk / Wegwerftelefon / Angebot / Maximum / Multiplikator.",
                    contactsBurnerOfferMinimumMultiplier = "Konfigurationswert für Kontaktnetzwerk / Wegwerftelefon / Angebot / Minimum / Multiplikator.",
                    contactsBuyerCooldownMinutes = "Konfigurationswert für Kontaktnetzwerk / Käufer / Cooldown-Minuten.",
                    contactsBuyerDeliveryDistance = "Konfigurationswert für Kontaktnetzwerk / Käufer / Zustelldistanz.",
                    contactsBuyerPremiumSuccessScore = "Konfigurationswert für Kontaktnetzwerk / Käufer / Premium / Erfolg / Punktzahl.",
                    contactsBuyerPremiumTrustGain = "Konfigurationswert für Kontaktnetzwerk / Käufer / Premium / Vertrauen / Zuwachs.",
                    contactsBuyerRequestHeatRiskWeight = "Konfigurationswert für Kontaktnetzwerk / Käufer / Anfrage / Fahndungsdruck und Risiko / Gewichtung.",
                    contactsBuyerStandardTrustGain = "Konfigurationswert für Kontaktnetzwerk / Käufer / Standard / Vertrauen / Zuwachs.",
                    contactsContactActiveDelaySeconds = "Einstellungen für „Wartezeit bis zur Kontaktaktivierung / Sekunden“ im Bereich „Drogennetzwerke“ anpassen.",
                    contactsContactDemandRange = "Einstellungen für „Kontakt / Nachfrage / Wertebereich“ im Bereich „Drogennetzwerke“ anpassen.",
                    contactsContactLossTrust = "Konfigurationswert für Kontaktnetzwerk / Kontakt / Verlust / Vertrauen.",
                    contactsDarknetExactIntelMinutes = "Konfigurationswert für Kontaktnetzwerk / Darknet / Genaue Informationen / Minuten.",
                    contactsDarknetHotspotIntelPrice = "Konfigurationswert für Kontaktnetzwerk / Darknet / Brennpunkt / Informationen / Preis.",
                    contactsDarknetIntelPrice = "Konfigurationswert für Kontaktnetzwerk / Darknet / Informationen / Preis.",
                    contactsDealerBasePrice = "Konfigurationswert für Kontaktnetzwerk / Dealer / Grundpreis.",
                    contactsDealerHireCapacity = "Einstellungen für „Dealer / Einstellung / Kapazität“ im Bereich „Drogennetzwerke“ anpassen.",
                    contactsDealerHireRisk = "Einstellungen für „Dealer / Einstellung / Risiko“ im Bereich „Drogennetzwerke“ anpassen.",
                    contactsDealerHireSkill = "Einstellungen für „Dealer / Einstellung / Fähigkeit“ im Bereich „Drogennetzwerke“ anpassen.",
                    contactsDealerOffers = "Einstellungen für „Dealer-Angebote“ im Bereich „Drogennetzwerke“ anpassen.",
                    contactsDealerProtectionHours = "Konfigurationswert für Kontaktnetzwerk / Dealer / Schutz / Stunden.",
                    contactsDealerProtectionPrice = "Konfigurationswert für Kontaktnetzwerk / Dealer / Schutz / Preis.",
                    contactsDealerSaleMax = "Konfigurationswert für Kontaktnetzwerk / Dealer / Verkauf / Maximum.",
                    contactsDealerSaleMin = "Konfigurationswert für Kontaktnetzwerk / Dealer / Verkauf / Minimum.",
                    contactsDealerSimulation = "Einstellungen für „Dealer / Simulation“ im Bereich „Drogennetzwerke“ anpassen.",
                    contactsDealerTickMinutes = "Konfigurationswert für Kontaktnetzwerk / Dealer / Aktualisierungsschritt / Minuten.",
                    contactsDealerWage = "Konfigurationswert für Kontaktnetzwerk / Dealer / Lohn.",
                    contactsDealerWageDecay = "Konfigurationswert für Kontaktnetzwerk / Dealer / Lohn / Verfall.",
                    contactsDealerWageLoyaltyGain = "Konfigurationswert für Kontaktnetzwerk / Dealer / Lohn / Loyalität / Zuwachs.",
                    contactsDealerWeaknesses = "Einstellungen für „Dealer / Schwachstellen“ im Bereich „Drogennetzwerke“ anpassen.",
                    contactsDefaultContactDemand = "Konfigurationswert für Kontaktnetzwerk / Standardwert / Kontakt / Nachfrage.",
                    contactsDefaultContactRisk = "Konfigurationswert für Kontaktnetzwerk / Standardwert / Kontakt / Risiko.",
                    contactsDefaultDealerCapacity = "Konfigurationswert für Kontaktnetzwerk / Standarddealer / Kapazität.",
                    contactsDefaultDealerRisk = "Konfigurationswert für Kontaktnetzwerk / Standarddealer / Risiko.",
                    contactsDefaultDealerSkill = "Konfigurationswert für Kontaktnetzwerk / Standarddealer / Fähigkeit.",
                    contactsDefaultHotspotRadius = "Konfigurationswert für Kontaktnetzwerk / Standardwert / Brennpunkt / Radius.",
                    contactsDemandResetMinutes = "Konfigurationswert für Kontaktnetzwerk / Nachfrage zurücksetzen (Minuten).",
                    contactsEnabled = "Konfigurationswert für Kontaktnetzwerk / Aktiviert.",
                    contactsExactLocationTrust = "Konfigurationswert für Kontaktnetzwerk / Genauer Standort / Vertrauen.",
                    contactsFactionDiscoveryReputation = "Konfigurationswert für Kontaktnetzwerk / Fraktion / Entdeckung / Ruf.",
                    contactsFactionHintTrust = "Konfigurationswert für Kontaktnetzwerk / Fraktion / Hinweis / Vertrauen.",
                    contactsFailedDeliveryCooldownMinutes = "Konfigurationswert für Kontaktnetzwerk / Fehlgeschlagene Lieferung / Cooldown-Minuten.",
                    contactsFakeDealEncounter = "Einstellungen für „Vorgetäuschtes Geschäft / Begegnung“ im Bereich „Drogennetzwerke“ anpassen.",
                    contactsFallbackPreferredDrug = "Konfigurationswert für Kontaktnetzwerk / Ersatzwert / Bevorzugte Droge.",
                    contactsFallbackProductLabel = "Konfigurationswert für Kontaktnetzwerk / Ersatzwert / Produktbezeichnung.",
                    contactsGuideBookItem = "Konfigurationswert für Kontaktnetzwerk / Anleitung / Buch / Gegenstand.",
                    contactsGuideBookTrust = "Konfigurationswert für Kontaktnetzwerk / Anleitung / Buch / Vertrauen.",
                    contactsHireDealerPrice = "Konfigurationswert für Kontaktnetzwerk / Dealer anheuern / Preis.",
                    contactsHistoryLimit = "Konfigurationswert für Kontaktnetzwerk / Historienlimit.",
                    contactsHotspotIntelMinutes = "Konfigurationswert für Kontaktnetzwerk / Brennpunkt / Informationen / Minuten.",
                    contactsHotspotRotationMinutes = "Konfigurationswert für Kontaktnetzwerk / Brennpunkt / Wechsel / Minuten.",
                    contactsListingDurationMinutes = "Konfigurationswert für Kontaktnetzwerk / Angebot / Dauer / Minuten.",
                    contactsMaxOwnedDealers = "Konfigurationswert für Kontaktnetzwerk / Maximum / Im Besitz / Dealer.",
                    contactsMinimumBuyerDeliveryDistance = "Konfigurationswert für Kontaktnetzwerk / Minimum / Käufer / Zustelldistanz.",
                    contactsMinimumContactRotationMinutes = "Konfigurationswert für Kontaktnetzwerk / Minimum / Kontaktrotation (Minuten).",
                    contactsMinimumDemandResetMinutes = "Konfigurationswert für Kontaktnetzwerk / Minimum / Nachfrage zurücksetzen (Minuten).",
                    contactsMinimumHeatMultiplier = "Konfigurationswert für Kontaktnetzwerk / Minimum / Fahndungsdruck / Multiplikator.",
                    contactsMinimumHotspotIntelMinutes = "Konfigurationswert für Kontaktnetzwerk / Minimum / Brennpunkt / Informationen / Minuten.",
                    contactsMinimumHotspotRadius = "Konfigurationswert für Kontaktnetzwerk / Minimum / Brennpunkt / Radius.",
                    contactsMinimumHotspotRotationMinutes = "Konfigurationswert für Kontaktnetzwerk / Minimum / Brennpunkt / Wechsel / Minuten.",
                    contactsMinimumListingDurationMinutes = "Konfigurationswert für Kontaktnetzwerk / Minimum / Angebot / Dauer / Minuten.",
                    contactsMinimumRewardMultiplier = "Konfigurationswert für Kontaktnetzwerk / Minimale Belohnung / Multiplikator.",
                    contactsMinimumRobberyMultiplier = "Konfigurationswert für Kontaktnetzwerk / Minimum / Raubüberfälle / Multiplikator.",
                    contactsMinimumSpotPriceMultiplier = "Konfigurationswert für Kontaktnetzwerk / Minimum / Standort / Preismultiplikator.",
                    contactsOtherDrugPriceMultiplier = "Konfigurationswert für Kontaktnetzwerk / Sonstige / Droge / Preismultiplikator.",
                    contactsPaymentAccount = "Konfigurationswert für Kontaktnetzwerk / Zahlungskonto.",
                    contactsPostDeliveryDemandResetSeconds = "Konfigurationswert für Kontaktnetzwerk / Nach der Lieferung / Nachfrage / Zurücksetzen / Sekunden.",
                    contactsPreferredDrugPriceMultiplier = "Konfigurationswert für Kontaktnetzwerk / Bevorzugte Droge / Preismultiplikator.",
                    contactsRegionLocationTrust = "Konfigurationswert für Kontaktnetzwerk / Region / Ort / Vertrauen.",
                    contactsRequestAmounts = "Einstellungen für „Anfrage / Mengen“ im Bereich „Drogennetzwerke“ anpassen.",
                    contactsRotationMinutes = "Konfigurationswert für Kontaktnetzwerk / Wechsel / Minuten.",
                    contactsSpotPools = "Einstellungen für „Standort / Auswahlpools“ im Bereich „Drogennetzwerke“ anpassen.",
                    contactsStreetHotspots = "Einstellungen für „Straße / Brennpunkte“ im Bereich „Drogennetzwerke“ anpassen.",
                    contactsTrustLevels = "Einstellungen für „Vertrauen / Stufen“ im Bereich „Drogennetzwerke“ anpassen.",
                    businessActionCooldownSeconds = "Konfigurationswert für Unternehmensnetzwerk / Aktions-Cooldown / Sekunden.",
                    businessBalance = "Einstellungen für „Guthaben“ im Bereich „Drogennetzwerke“ anpassen.",
                    businessContracts = "Einstellungen für „Verträge“ im Bereich „Drogennetzwerke“ anpassen.",
                    businessDefaultBusinessName = "Konfigurationswert für Unternehmensnetzwerk / Standardwert / Betriebsname.",
                    businessDefaultRankId = "Konfigurationswert für Unternehmensnetzwerk / Standardwert / Rang / ID.",
                    businessDefaultStaffStyle = "Konfigurationswert für Unternehmensnetzwerk / Standardwert / Personal / Arbeitsweise.",
                    businessDefaultTransport = "Konfigurationswert für Unternehmensnetzwerk / Standardwert / Transport.",
                    businessEnabled = "Konfigurationswert für Unternehmensnetzwerk / Aktiviert.",
                    businessHubs = "Einstellungen für „Verteilzentren“ im Bereich „Drogennetzwerke“ anpassen.",
                    businessLimits = "Einstellungen für „Grenzwerte“ im Bereich „Drogennetzwerke“ anpassen.",
                    businessPayments = "Lege fest, welches Guthaben Käufe und laufende Kosten im Vertriebsnetz bezahlt.",
                    businessPayoutAccount = "Konfigurationswert für Unternehmensnetzwerk / Auszahlung / Konto.",
                    businessRanks = "Einstellungen für „Ränge“ im Bereich „Drogennetzwerke“ anpassen.",
                    businessReportDays = "Konfigurationswert für Unternehmensnetzwerk / Berichtszeitraum / Tage.",
                    businessRouteEndpointTypes = "Einstellungen für „Route / Endpunkt / Typen“ im Bereich „Drogennetzwerke“ anpassen.",
                    businessRuntime = "Einstellungen für „Spielbetrieb“ im Bereich „Drogennetzwerke“ anpassen.",
                    businessSocietyPermission = "Konfigurationswert für Unternehmensnetzwerk / Organisation / Berechtigung.",
                    businessStaff = "Einstellungen für „Personal“ im Bereich „Drogennetzwerke“ anpassen.",
                    businessTickMinutes = "Konfigurationswert für Unternehmensnetzwerk / Aktualisierungsschritt / Minuten.",
                    businessTransports = "Einstellungen für „Transporte“ im Bereich „Drogennetzwerke“ anpassen.",
                },
                robbery = {
                    atmAvailability = "Aktiviert oder deaktiviert das eigenständige ATM-Raubsystem.",
                    atmLocations = "Verwaltet die serverseitig freigegebenen Standorte für ATM-Raube.",
                    atmPolice = "Legt die benötigten Polizisten im Dienst fest.",
                    atmItems = "Legt die benötigten Bohrer-, Schlingen- und Sprengladungs-Items fest.",
                    atmActionTimes = "Legt die Dauer von Anbringen, Platzieren, Zündung und Plündern fest.",
                    atmTimeouts = "Bestimmt, wie lange ein aufgebrochener ATM plünderbar bleibt.",
                    atmPayout = "Legt Zielkonto und zufälligen Belohnungsbereich fest.",
                    atmDistances = "Legt die Reichweiten für Spieler- und Fahrzeuginteraktionen fest.",
                    atmExplosionEffects = "Konfiguriert die Native-Parameter der Explosion.",
                    atmDispatchAlert = "Legt Radius, Dauer und Priorität des Polizeialarms fest.",
                    atmDispatchRecipients = "Legt fest, welche Jobs ATM-Alarme erhalten.",
                    shopAvailability = "Überfälle und Polizeivoraussetzung konfigurieren.",
                    shopTiming = "Einschüchterung, Aktionen, Zeitlimit und Abklingzeit.",
                    shopSafe = "Codeversuche und Bohrmaschinen-Item konfigurieren.",
                    shopRegisterReward = "Zufallsbelohnung jeder Kasse konfigurieren.",
                    shopSafeReward = "Zufällige Tresorbelohnung konfigurieren.",
                    shopDispatchSettings = "Empfänger und Alarmeigenschaften konfigurieren.",
                    shopLocationTable = "Bediente Läden und Tresore verwalten.",
                    pickpocketAvailability = "Aktiviert das Feature und beschränkt es optional auf konfigurierte Crime-Jobs.",
                    pickpocketGameplay = "Wählt die Herausforderung sowie unabhängige Flucht-, Notruf- und Gegenwehrchancen.",
                    pickpocketItemRewards = "Steuert leere Taschen sowie sichtbare Item-Slots bis 0,0001 Prozent.",
                    pickpocketMoney = "Konfiguriert den serverseitig ausgewürfelten Bargeldbereich.",
                    pickpocketDistances = "Legt die NPC-Reichweite für das gemeinsame Radial- und Target-System fest.",
                    pickpocketRateLimits = "Steuert Anfragebegrenzung, NPC-Cooldown und Sitzungsablauf.",
                    pickpocketDispatchSettings = "Konfiguriert den Alarm, wenn ein NPC den Notruf wählt.",
                    heistCrafting = "Lege fest, wie aufwendig Heist-Ausrüstung hergestellt wird. Gilt für neue Versuche im gesamten Crime-System.",
                    heistCreatorMenu = "Modulare Heists im eigenen Heist Creator erstellen, bearbeiten und veröffentlichen.",
                    heistExecution = "Startfenster, Inaktivität und Cooldown für Heist-Durchläufe.",
                    npcPoliceSupport = "Dieses Feature ist wegen Stabilitätsproblemen vorübergehend deaktiviert und kann aktuell nicht im Job Configurator aktiviert werden.",
                },
                baseRaids = {
                    baseRaids = "Raid-Zugriff, Voraussetzungen und einzeln wählbare Loot-Arten. Offene Raids haben kein Transport-Zeitlimit.",
                },
                weapons = {
                    weaponCreatorMenu = "Verwalte Waffenrouten und Geldwäsche in einem Creator.",
                    weaponRuntime = "Steuert die Verfügbarkeit und den Zugriff auf Waffenrouten.",
                    weaponDefaultsgeneral = "Einstellungen für „Allgemeine Vorgaben“ im Bereich „Waffenrouten“ anpassen.",
                    weaponDefaultsaccess = "Einstellungen für „Zugriffsvorgaben“ im Bereich „Waffenrouten“ anpassen.",
                    weaponDefaultscollection = "Einstellungen für „Sammelvorgaben“ im Bereich „Waffenrouten“ anpassen.",
                    weaponDefaultsproduction = "Einstellungen für „Produktionsvorgaben“ im Bereich „Waffenrouten“ anpassen.",
                    weaponDefaultsmarket = "Einstellungen für „Marktvorgaben“ im Bereich „Waffenrouten“ anpassen.",
                    weaponDefaultsdelivery = "Einstellungen für „Auftragsvorgaben“ im Bereich „Waffenrouten“ anpassen.",
                    weaponStreet = "Einstellungen für „Waffen-Straßenverkauf“ im Bereich „Waffenrouten“ anpassen.",
                },
                darknetMarket = {
                    darknetAvailability = "Steuert die Tablet-App und ihre Position.",
                    darknetEconomy = "Konfiguriert Wallet-Guthaben, Coin-Wechsel und Zahlungskurse.",
                    darknetListings = "Steuert Anzeigenlimits, Preise und automatischen Ablauf.",
                    darknetChat = "Begrenzt verschlüsselte Marktplatznachrichten.",
                    darknetIdentity = "Konfiguriert Identitätswechsel, Verifizierung und Betrugswarnungen.",
                    darknetDelivery = "Konfiguriert persönliche Treffen und stehlbare Kisten in der Welt.",
                    darknetDeliveryLocations = "Konfiguriert die Standortlisten, aus denen BlackBay bei NPC-Handeln zufällig auswählt.",
                    darknetPolice = "Jobgruppen für Lockangebote und Ermittlungen.",
                    darknetNpcTraders = "Dauerhafte NPC-Käufer und -Verkäufer mit konfigurierbarem Risiko.",
                },
                interrogation = {
                    general = "Einstellungen für „Allgemein“ im Bereich „Verhör“ anpassen.",
                    consent = "Einstellungen für „Spielerschutz“ im Bereich „Verhör“ anpassen.",
                    objects = "Einstellungen für „Objekte“ im Bereich „Verhör“ anpassen.",
                    grab = "Einstellungen für „Überwältigen“ im Bereich „Verhör“ anpassen.",
                    session = "Einstellungen für „Ablauf“ im Bereich „Verhör“ anpassen.",
                    dispatch = "Einstellungen für „Polizeimeldungen“ im Bereich „Verhör“ anpassen.",
                    logging = "Einstellungen für „Protokollierung“ im Bereich „Verhör“ anpassen.",
                    security = "Einstellungen für „Sicherheit“ im Bereich „Verhör“ anpassen.",
                    presentation = "Einstellungen für „Darstellung“ im Bereich „Verhör“ anpassen.",
                },
                reputation = {
                    crimeReputation = "Einstellungen für „Ruf“ im Bereich „Ruf“ anpassen.",
                },
            },
            settingGroups = {
                weaponRuntime = { label = "Allgemein", description = "Steuert die Verfügbarkeit und den Zugriff auf Waffenrouten." },
                weaponCreatorMenu = { label = "Illegaler Unternehmer", description = "Verwalte Waffenrouten und Geldwäsche in einem Creator." },
                atmActionTimes = {
                    description = "Legt die Dauer von Anbringen, Platzieren, Zündung und Plündern fest.",
                    label = "Aktionszeiten",
                },
                atmAvailability = {
                    description = "Aktiviert oder deaktiviert das eigenständige ATM-Raubsystem.",
                    label = "Verfügbarkeit",
                },
                atmDispatchAlert = {
                    description = "Legt Radius, Dauer und Priorität des Polizeialarms fest.",
                    label = "Alarmeigenschaften",
                },
                atmDispatchRecipients = {
                    description = "Legt fest, welche Jobs ATM-Alarme erhalten.",
                    label = "Empfänger",
                },
                atmDistances = {
                    description = "Legt die Reichweiten für Spieler- und Fahrzeuginteraktionen fest.",
                    label = "Interaktionsdistanzen",
                },
                atmExplosionEffects = {
                    description = "Konfiguriert die Native-Parameter der Explosion.",
                    label = "Explosionseffekte",
                },
                atmItems = {
                    description = "Legt die benötigten Bohrer-, Schlingen- und Sprengladungs-Items fest.",
                    label = "Benötigte Items",
                },
                atmLocations = {
                    description = "Verwaltet die serverseitig freigegebenen Standorte für ATM-Raube.",
                    label = "ATM-Standorte",
                },
                atmPayout = {
                    description = "Legt Zielkonto und zufälligen Belohnungsbereich fest.",
                    label = "Auszahlung",
                },
                atmPolice = {
                    description = "Legt die benötigten Polizisten im Dienst fest.",
                    label = "Polizeivoraussetzung",
                },
                atmPulling = {
                    description = "Legt die nötige Fahrzeugbewegung zum Herausreißen des ATMs fest.",
                    label = "Erkennung des Herausreißens",
                },
                atmTimeouts = {
                    description = "Bestimmt, wie lange ein aufgebrochener ATM plünderbar bleibt.",
                    label = "Plünderzeitfenster",
                },
                baseRaids = {
                    description = "Raid-Zugriff, Voraussetzungen und einzeln wählbare Loot-Arten. Offene Raids haben kein Transport-Zeitlimit.",
                    label = "Fraktionsüberfälle",
                },
                businessPayments = {
                    description = "Lege fest, welches Guthaben Käufe und laufende Kosten im Vertriebsnetz bezahlt.",
                    label = "Zahlungen",
                },
                crimeMembership = {
                    description = "Lege fest, wie Crime-Organisationen ihre Mitglieder speichern und verwalten.",
                    label = "Mitgliedschaftsmodell",
                },
                darknetAvailability = {
                    description = "Steuert die Tablet-App und ihre Position.",
                    label = "Verfügbarkeit",
                },
                darknetChat = {
                    description = "Begrenzt verschlüsselte Marktplatznachrichten.",
                    label = "Privater Chat",
                },
                darknetDelivery = {
                    description = "Konfiguriert persönliche Treffen und stehlbare Kisten in der Welt.",
                    label = "Übergaben und Dead Drops",
                },
                darknetDeliveryLocations = {
                    description = "Konfiguriert die Standortlisten, aus denen BlackBay bei NPC-Handeln zufällig auswählt.",
                    label = "Übergabeorte",
                },
                darknetEconomy = {
                    description = "Konfiguriert Wallet-Guthaben, Coin-Wechsel und Zahlungskurse.",
                    label = "Kryptowährung",
                },
                darknetIdentity = {
                    description = "Konfiguriert Identitätswechsel, Verifizierung und Betrugswarnungen.",
                    label = "Aliase und Reputation",
                },
                darknetListings = {
                    description = "Steuert Anzeigenlimits, Preise und automatischen Ablauf.",
                    label = "Anzeigen und Ablauf",
                },
                darknetNpcTraders = {
                    description = "Dauerhafte NPC-Käufer und -Verkäufer mit konfigurierbarem Risiko.",
                    label = "NPC-Händler",
                },
                darknetPolice = {
                    description = "Jobgruppen für Lockangebote und Ermittlungen.",
                    label = "Polizeizugriff",
                },
                heistCrafting = {
                    description = "Lege fest, wie aufwendig Heist-Ausrüstung hergestellt wird. Gilt für neue Versuche im gesamten Crime-System.",
                    label = "Heist-Werkstatt",
                },
                heistCreatorMenu = {
                    description = "Modulare Heists im eigenen Heist Creator erstellen, bearbeiten und veröffentlichen.",
                    label = "Creator-Menü",
                },
                heistExecution = {
                    description = "Startfenster, Inaktivität und Cooldown für Heist-Durchläufe.",
                    label = "Heist-Zeitlimits",
                },
                moneywashEconomy = {
                    description = "Betriebe aktivieren und Einzahlungskonto, Servicegebühr sowie Interaktionsdistanzen einstellen.",
                    label = "Allgemein",
                },
                npcPoliceSupport = {
                    description = "Dieses Feature ist wegen Stabilitätsproblemen vorübergehend deaktiviert und kann aktuell nicht im Job Configurator aktiviert werden.",
                    label = "NPC-Polizeiverstärkung (aktuell deaktiviert)",
                },
                pickpocketAvailability = {
                    description = "Aktiviert das Feature und beschränkt es optional auf konfigurierte Crime-Jobs.",
                    label = "Verfügbarkeit",
                },
                pickpocketDispatchSettings = {
                    description = "Konfiguriert den Alarm, wenn ein NPC den Notruf wählt.",
                    label = "Notruf-Dispatch",
                },
                pickpocketDistances = {
                    description = "Legt die NPC-Reichweite für das gemeinsame Radial- und Target-System fest.",
                    label = "Interaktionsdistanzen",
                },
                pickpocketGameplay = {
                    description = "Wählt die Herausforderung sowie unabhängige Flucht-, Notruf- und Gegenwehrchancen.",
                    label = "Risiko und Minigame",
                },
                pickpocketItemRewards = {
                    description = "Steuert leere Taschen sowie sichtbare Item-Slots bis 0,0001 Prozent.",
                    label = "Sichtbarer Tascheninhalt",
                },
                pickpocketMoney = {
                    description = "Konfiguriert den serverseitig ausgewürfelten Bargeldbereich.",
                    label = "Bargeldbeute",
                },
                pickpocketRateLimits = {
                    description = "Steuert Anfragebegrenzung, NPC-Cooldown und Sitzungsablauf.",
                    label = "Serverschutz",
                },
                pvpArenas = {
                    description = "Erstellt die runde Kampfzone, den Zuschauerpunkt und die Team-Spawns für PvP-Events.",
                    label = "Arenen und Kampfzonen",
                },
                pvpAutomation = {
                    description = "Konfiguriert wiederkehrende Events und automatische Starts.",
                    label = "Automatisierung",
                },
                pvpAvailability = {
                    description = "Steuert, ob die PvP-Event-App verfügbar ist und wo sie angezeigt wird.",
                    label = "Verfügbarkeit",
                },
                pvpLimits = {
                    description = "Legt Limits für Belohnungen und den Tablet-Verlauf fest.",
                    label = "Limits und Verlauf",
                },
                pvpModes = {
                    description = "Konfiguriert den vorausgewählten Spielmodus für das PvP-Tablet.",
                    label = "Spielmodi",
                },
                pvpPermissions = {
                    description = "Ordnet Eventverwaltung und Finanzen ACE- und Job-Berechtigungen zu.",
                    label = "Berechtigungen",
                },
                pvpRuntime = {
                    description = "Stellt Anfragen, Tode und Respawns während laufender Events ein.",
                    label = "Eventablauf",
                },
                pvpTakeoverMethods = {
                    description = "Legt fest, wie lange die einzelnen Methoden zum Aufbrechen eines Eingangs dauern.",
                    label = "Einbruchsmethoden",
                },
                pvpTakeoverRules = {
                    description = "Steuert die Verfügbarkeit und die Voraussetzungen für Labor- und Camperübernahmen.",
                    label = "Übernahmeregeln",
                },
                pvpTakeoverZones = {
                    description = "Legt Interaktions-, Alarm- und Eroberungsbereiche sowie deren Dauer fest.",
                    label = "Zonen und Zeiten",
                },
                shopAvailability = {
                    description = "Überfälle und Polizeivoraussetzung konfigurieren.",
                    label = "Verfügbarkeit",
                },
                shopDispatchSettings = {
                    description = "Empfänger und Alarmeigenschaften konfigurieren.",
                    label = "Polizeialarm",
                },
                shopLocationTable = {
                    description = "Bediente Läden und Tresore verwalten.",
                    label = "Ladenstandorte",
                },
                shopRegisterReward = {
                    description = "Zufallsbelohnung jeder Kasse konfigurieren.",
                    label = "Kassenbelohnung",
                },
                shopRegisterTable = {
                    description = "Einzelne Kassen Läden zuweisen.",
                    label = "Kassen",
                },
                shopSafe = {
                    description = "Codeversuche und Bohrmaschinen-Item konfigurieren.",
                    label = "Tresor",
                },
                shopSafeReward = {
                    description = "Zufällige Tresorbelohnung konfigurieren.",
                    label = "Tresorbelohnung",
                },
                shopTiming = {
                    description = "Einschüchterung, Aktionen, Zeitlimit und Abklingzeit.",
                    label = "Zeiten",
                },
            },
            settingSections = {
                weapons = "Waffenrouten",
                drugs = "Drogensystem",
                drugProduction = "Drogenproduktion",
                drugOperations = "Drogenbetriebe",
                drugMarketRisk = "Markt & Risiko",
                drugNetworks = "Drogennetzwerke",
                atmRobbery = "Bankautomatenraub",
                baseRaids = "Fraktionsüberfälle",
                crimeOrganizations = "Organisationen",
                darknetMarket = "Darknet-Marktplatz",
                moneywash = "Geldwäsche",
                pvpEvents = "Fraktions-PvP",
                robbery = "Raubüberfälle",
                territories = "Territorien",
                graffiti = "Graffiti",
                interrogation = "Verhör",
            },
            settingSubsections = {
                baseRaidEquipment = "Benötigte Ausrüstung",
                baseRaidBreach = "Aufbrechen",
                baseRaidLoot = "Beute & Fahrzeuge",
                graffitiLimits = "Grenzen & Moderation",
                interrogationTechnical = "Protokollierung & Sicherheit",
                atmDispatch = "Polizeialarm",
                atmEquipment = "Ausrüstung",
                atmExplosion = "Sprengung",
                atmOverview = "Übersicht & Standorte",
                atmRewards = "Auszahlung",
                atmTiming = "Zeiten",
                atmVehicle = "Fahrzeug & Herausreißen",
                baseRaids = "Fraktionsüberfälle",
                crimeMembership = "Mitgliedschaft",
                heistCreator = "Heist-Creator",
                npcPoliceSupport = "NPC-Polizeiverstärkung (aktuell deaktiviert)",
                pickpocket = "NPC-Taschendiebstahl",
                pvpArenas = "Arenen",
                pvpEquipment = "Spielmodi",
                pvpOverview = "Übersicht",
                pvpRuntime = "Eventablauf",
                pvpTakeovers = "Laborübernahmen",
                shopRobbery = "Ladenüberfälle",
                atmRobbery = "Bankautomatenraub",
            },
            settings = {
                weaponDefaultGeneralInteractionDistance = { label = "Interaktionsabstand" },
                weaponDefaultGeneralPedModel = { label = "Standard-NPC-Modell" },
                weaponDefaultAccessActiveHourStart = { label = "Öffnet um (UTC)" },
                weaponDefaultAccessActiveHourEnd = { label = "Schließt um (UTC)" },
                weaponDefaultAccessPoliceRequired = { label = "Benötigte Polizisten im Dienst" },
                weaponDefaultAccessPoliceJobs = { label = "Polizeijobs" },
                weaponDefaultCollectionDurationSeconds = { label = "Dauer in Sekunden" },
                weaponDefaultCollectionCooldownSeconds = { label = "Cooldown in Sekunden" },
                weaponDefaultCollectionCooldownScope = { label = "Cooldown-Geltungsbereich" },
                weaponDefaultCollectionUseMinigame = { label = "Minispiel verwenden" },
                weaponDefaultCollectionMinigame = { label = "Minispiel" },
                weaponDefaultCollectionMinigameRounds = { label = "Minispiel-Runden" },
                weaponDefaultProductionDurationSeconds = { label = "Dauer in Sekunden" },
                weaponDefaultProductionSuccessChance = { label = "Erfolgschance (%)" },
                weaponDefaultProductionFailureConsumesInputs = { label = "Zutaten bei Fehlschlag verbrauchen" },
                weaponDefaultProductionUseMinigame = { label = "Minispiel verwenden" },
                weaponDefaultProductionMinigame = { label = "Minispiel" },
                weaponDefaultProductionMinigameRounds = { label = "Minispiel-Runden" },
                weaponDefaultProductionQualityMin = { label = "Mindestqualität" },
                weaponDefaultProductionQualityMax = { label = "Höchstqualität" },
                weaponDefaultProductionCooldownSeconds = { label = "Cooldown in Sekunden" },
                weaponDefaultProductionCooldownScope = { label = "Cooldown-Geltungsbereich" },
                weaponDefaultMarketPayoutAccount = { label = "Auszahlungskonto" },
                weaponDefaultMarketPriceMultiplierMin = { label = "Mindestpreisfaktor (%)" },
                weaponDefaultMarketPriceMultiplierMax = { label = "Höchstpreisfaktor (%)" },
                weaponDefaultMarketRestockSeconds = { label = "Auffüllintervall in Sekunden" },
                weaponDefaultMarketCooldownSeconds = { label = "Cooldown in Sekunden" },
                weaponDefaultMarketCooldownScope = { label = "Cooldown-Geltungsbereich" },
                weaponDefaultDeliveryContractDurationMinutes = { label = "Auftragsfrist in Minuten" },
                weaponDefaultDeliveryContractBonusPercent = { label = "Auftragsbonus (%)" },
                weaponStreetEnabled = { label = "Seltene Waffenverkäufe an Straßenkäufer" },
                weaponStreetChance = { label = "Chance auf Waffenangebot (%)" },
                weaponStreetCooldown = { label = "Cooldown in Sekunden" },
                weaponStreetAmount = { label = "Höchstmenge" },
                weaponStreetPriceMin = { label = "Mindestpreisfaktor (%)" },
                weaponStreetPriceMax = { label = "Höchstpreisfaktor (%)" },
                weaponStreetAccount = { label = "Auszahlungskonto" },
                weaponStreetDirect = { label = "Direktverkauf" },
                weaponStreetBulk = { label = "Sammelverkauf" },
                weaponStreetContract = { label = "Kartellauftrag" },
                weaponSystemEnabled = { label = "Waffenrouten aktivieren", description = "Aktiviert das Sammeln, Verarbeiten und Verkaufen von Waffen an Kartelle." },
                weaponRuntimeEnabled = { label = "Waffenaktionen aktivieren", description = "Erlaubt die Nutzung konfigurierter Waffenrouten in der Spielwelt." },
                weaponCreatorAccess = { label = "Weapon-Creator-Zugriff", description = "Legt fest, wer den Weapon Creator öffnen darf.", options = { permission = "Nur mit Berechtigung", jobManagement = "Jobverwaltung", ownerOnly = "Nur Eigentümer" } },
                openWeaponCreator = { label = "Illegaler Unternehmer", description = "Verwalte Waffenrouten und Geldwäsche in einem Creator.", buttonLabel = "Illegaler Unternehmer", unsavedTooltip = "Zuerst speichern" },

                drugCultivationProgressionEnabled = {
                    label = "Anbau-Level aktivieren",
                    description = "Aktiviert Anbau-XP, Level und levelabhängige Freischaltungen.",
                },
                drugCultivationMaxLevel = {
                    label = "Maximales Anbau-Level",
                    description = "Höchstes erreichbares Anbau-Level. Konfigurierte Level darüber bleiben unerreichbar.",
                },
                drugCultivationLevels = {
                    label = "Levelkurve",
                    description = "Legt Namen und benötigte Gesamt-XP für jedes Anbau-Level fest.",
                },
                drugCultivationActionXp = {
                    label = "XP-Belohnungen",
                    description = "Legt fest, wie viele Anbau-XP jede Anbauaktion vergibt.",
                },
                drugCultivationUnlocks = {
                    label = "Level-Freischaltungen",
                    description = "Legt die benötigten Anbau-Level für Behälter, Substrate, Ausrüstung, Sorten und Scannerstufen fest.",
                },
                reputationRewards = {
                    label = "Reputationsaktionen",
                    description = "Aktionen hinzufügen, Punkte ändern und Einträge deaktivieren oder löschen. Nur aktive Einträge vergeben Punkte.",
                },
                reputationEnabled = {
                    label = "Crime-Reputation aktivieren",
                    description = "Persönliche Reputation vergeben.",
                },
                reputationPointsPerLevel = {
                    label = "Punkte pro Level",
                    description = "Jedes Level benötigt diese Anzahl zusätzlicher Punkte.",
                },
                reputationMinimumJoinPoints = {
                    label = "Mindest-Reputation zum Beitritt",
                    description = "Benötigte Gesamtpunkte für den Beitritt zu einer Crime-Fraktion. 0 deaktiviert die Voraussetzung. Bestehende Mitglieder behalten ihren Zugang.",
                },
                reputation_atm = {
                    label = "ATM-Raub",
                    description = "Punkte pro erfolgreichem Abschluss. 0 deaktiviert diese Belohnung.",
                },
                reputation_shop_register = {
                    label = "Ladenkasse",
                    description = "Punkte pro erfolgreichem Abschluss. 0 deaktiviert diese Belohnung.",
                },
                reputation_shop_safe = {
                    label = "Ladentresor",
                    description = "Punkte pro erfolgreichem Abschluss. 0 deaktiviert diese Belohnung.",
                },
                reputation_pickpocket = {
                    label = "Taschendiebstahl",
                    description = "Punkte pro erfolgreichem Abschluss. 0 deaktiviert diese Belohnung.",
                },
                reputation_heist = {
                    label = "Heist-Abschluss",
                    description = "Punkte pro erfolgreichem Abschluss. 0 deaktiviert diese Belohnung.",
                },
                reputation_drug_harvest = {
                    label = "Drogenernte",
                    description = "Punkte pro erfolgreichem Abschluss. 0 deaktiviert diese Belohnung.",
                },
                reputation_drug_processing = {
                    label = "Drogenverarbeitung",
                    description = "Punkte pro erfolgreichem Abschluss. 0 deaktiviert diese Belohnung.",
                },
                reputation_drug_sale = {
                    label = "Drogenverkauf",
                    description = "Punkte pro erfolgreichem Abschluss. 0 deaktiviert diese Belohnung.",
                },
                reputation_drug_delivery = {
                    label = "Drogenlieferung",
                    description = "Punkte pro erfolgreichem Abschluss. 0 deaktiviert diese Belohnung.",
                },
                reputation_drug_contract = {
                    label = "Vertriebsvertrag",
                    description = "Punkte pro erfolgreichem Abschluss. 0 deaktiviert diese Belohnung.",
                },
                reputation_drug_raid = {
                    label = "Drogenüberfall",
                    description = "Punkte pro erfolgreichem Abschluss. 0 deaktiviert diese Belohnung.",
                },
                reputation_graffiti = {
                    label = "Graffiti",
                    description = "Punkte pro erfolgreichem Abschluss. 0 deaktiviert diese Belohnung.",
                },
                reputation_moneywash = {
                    label = "Geldwäsche",
                    description = "Punkte pro erfolgreichem Abschluss. 0 deaktiviert diese Belohnung.",
                },
                reputation_base_raid = {
                    label = "Fraktionsüberfall",
                    description = "Punkte pro erfolgreichem Abschluss. 0 deaktiviert diese Belohnung.",
                },
                reputation_pvp_win = {
                    label = "PvP-Sieg",
                    description = "Punkte pro erfolgreichem Abschluss. 0 deaktiviert diese Belohnung.",
                },
                atmChargeProp = {
                    description = "Objektmodell, das während der Zündphase am ATM angezeigt wird.",
                    label = "Objekt der Sprengladung",
                },
                atmConsumeDrill = {
                    description = "Verbraucht die eingestellte Anzahl nach jedem erfolgreich abgeschlossenen ATM-Bohrpunkt.",
                    label = "Bohrer verbrauchen",
                },
                atmDrillItem = {
                    description = "Inventar-Item-ID zum Aufbohren herausgerissener Geldautomaten. Unabhängig vom Tresor-Bohrer.",
                    label = "Bohrmaschinen-Item",
                },
                atmDrillItemAmount = {
                    description = "Anzahl der Bohrmaschinen, die für jeden ATM-Bohrpunkt vorhanden sein muss.",
                    label = "Benötigte Bohrmaschinen",
                },
                atmDebug = {
                    description = "Schreibt detaillierte Diagnosemeldungen zum ATM-Raub in die Serverkonsole und die clientseitige F8-Konsole.",
                    label = "ATM-Debug-Logs",
                },
                atmDispatchDurationSeconds = {
                    description = "Sekunden, die der ATM-Alarm für Dispatch-Empfänger relevant bleibt.",
                    label = "Alarmdauer",
                },
                atmDispatchEnabled = {
                    description = "Erstellt einen Jobs-Base-Einsatz, sobald ein ATM aufgebrochen wurde.",
                    label = "Polizeialarm aktivieren",
                },
                atmDispatchJobs = {
                    description = "Kommagetrennte Jobnamen, die den ATM-Alarm erhalten.",
                    label = "Alarm-Jobs",
                },
                atmDispatchPriority = {
                    description = "Prioritätswert, der unverändert an die Dispatch-Integration übergeben wird.",
                    label = "Alarmpriorität",
                },
                atmDispatchRadius = {
                    description = "Ungefährer Radius des Alarms für die Dispatch-Integration.",
                    label = "Alarmradius",
                },
                atmEnabled = {
                    description = "Macht konfigurierte ATMs für Schlingen- und Sprengraube verfügbar.",
                    label = "ATM-Raube aktivieren",
                },
                atmExplosionCameraShake = {
                    description = "Stärke des Kamerawackelns beim Client, der die Explosion erzeugt.",
                    label = "Kamerawackeln",
                },
                atmExplosionDamageScale = {
                    description = "Schadens- und Impulsstärke für die Explosions-Native.",
                    label = "Explosionsschaden",
                },
                atmExplosionType = {
                    description = "GTA-Explosionstyp bei der Zündung. Andere Typen nur nach Laufzeittest verwenden.",
                    label = "Explosionstyp",
                },
                atmDrillDurationSeconds = {
                    label = "Mindestbohrzeit pro Schraube (s)",
                    description = "Mindestbohrzeit in Sekunden pro Schraube (vier insgesamt). Kühlpausen verlängern den Versuch. Gilt für neu gestartete Bohrversuche.",
                },
                atmExplosiveDurationSeconds = {
                    description = "Benötigte Sekunden zum Platzieren der Sprengladung.",
                    label = "Dauer Sprengladung anbringen",
                },
                atmExplosiveItem = {
                    description = "Inventaritem, das nach dem Anbringen der Ladung verbraucht wird.",
                    label = "Sprengladungs-Item",
                },
                atmExplosiveItemAmount = {
                    description = "Anzahl verbrauchter Sprengladungs-Items pro Ladung.",
                    label = "Verbrauchte Sprengladungsmenge",
                },
                atmFuseSeconds = {
                    description = "Sekunden zwischen Platzierung und Detonation.",
                    label = "Zündzeit",
                },
                atmInteractionDistance = {
                    description = "Maximale Client-Reichweite; die Serverprüfung ergänzt einen Sicherheitspuffer.",
                    label = "Interaktionsdistanz",
                },
                atmLocations = {
                    description = "Verbindliche Produktivstandorte. Mit /atmtest erstellte Standorte bleiben temporär.",
                    itemLabel = "ATM-Standort",
                    label = "ATM-Standorte",
                },
                atmLootDurationSeconds = {
                    description = "Benötigte Sekunden zum Aufbrechen des gelösten ATMs.",
                    label = "Plünderdauer",
                },
                atmLootReservationTimeoutSeconds = {
                    description = "Maximale Sekunden, die ein Spieler den ATM beim Aufbrechen reserviert; wird automatisch über der Plünderdauer gehalten.",
                    label = "Reservierungszeit beim Plündern",
                },
                atmLootWindowMinutes = {
                    description = "Minuten, die ein aufgebrochener ATM plünderbar bleibt.",
                    label = "Plünderzeitfenster",
                },
                atmMinimumPolice = {
                    description = "Anzahl der Mitglieder der festgelegten Polizeigruppe, die im Dienst sein müssen.",
                    label = "Benötigte Polizisten",
                },
                atmPoliceGroup = {
                    description = "sky_jobs_base Jobgruppe, die für die Polizeivoraussetzung zählt.",
                    label = "Polizei-Jobgruppe",
                },
                atmPullDistance = {
                    description = "Fahrzeugversatz vom ATM-Standort, der den Durchbruch auslöst.",
                    label = "Benötigte Zugdistanz",
                },
                atmPullMinimumSpeed = {
                    description = "Minimale Fahrzeuggeschwindigkeit in Metern pro Sekunde beim Erreichen der Zugdistanz.",
                    label = "Minimale Zuggeschwindigkeit",
                },
                atmReservationTimeoutSeconds = {
                    description = "Maximale Sekunden beim Anbringen von Schlinge oder Ladung; wird automatisch über der Aktionsdauer gehalten.",
                    label = "Reservierungszeit für Vorbereitung",
                },
                atmRewardAccount = {
                    description = "Wähle zwischen Bargeld und dem Gegenstand black_money.",
                    label = "ATM-Auszahlungsart",
                },
                atmRewardMaximum = {
                    description = "Höchste Geldbelohnung; niemals niedriger als das Minimum.",
                    label = "Maximale Belohnung",
                },
                atmRewardMinimum = {
                    description = "Niedrigste Geldbelohnung eines ATMs.",
                    label = "Minimale Belohnung",
                },
                atmSlingDurationSeconds = {
                    description = "Benötigte Sekunden zum Anbringen der Schlinge.",
                    label = "Dauer Schlinge anbringen",
                },
                atmSlingItem = {
                    description = "Wiederverwendbares Inventaritem für die Fahrzeugmethode.",
                    label = "Schlingen-Item",
                },
                atmSlingItemAmount = {
                    description = "Anzahl benötigter Schlingen-Items; sie werden nicht verbraucht.",
                    label = "Benötigte Schlingenmenge",
                },
                atmTestScanDistance = {
                    description = "Maximale Distanz, in der /atmtest nach einem unterstützten ATM-Prop sucht.",
                    label = "ATM-Test-Suchdistanz",
                },
                atmVehicleMaxDistance = {
                    description = "Maximaler Abstand zwischen ATM und geeignetem Fahrzeug beim Anbringen der Schlinge.",
                    label = "Fahrzeugdistanz beim Anbringen",
                },
                baseRaid_breachTimeoutSeconds = {
                    description = "Zeitlimit je Aufbruchversuch an einem Lagerpunkt (Sekunden).",
                    label = "Aufbruch-Zeitfenster (Sekunden)",
                },
                baseRaid_command = {
                    description = "Command ohne Schrägstrich. Nach einer Änderung das Crime-System neu starten.",
                    label = "Raid-Command",
                },
                baseRaid_crimeItem = {
                    description = "Gang-Aufbruchitem.",
                    label = "Gang-Aufbruchitem",
                },
                baseRaid_crimeVehicles = {
                    description = "Gang-Fahrzeugzugriff.",
                    label = "Gang-Fahrzeugzugriff",
                },
                baseRaid_difficulty = {
                    description = "Skillcheck-Schwierigkeit.",
                    label = "Skillcheck-Schwierigkeit",
                    options = {
                        easy = "Leicht",
                        expert = "Experte",
                        hard = "Schwer",
                        normal = "Normal",
                    },
                },
                baseRaid_enabled = {
                    description = "Fraktionsüberfälle aktivieren.",
                    label = "Fraktionsüberfälle aktivieren",
                },
                baseRaid_failedCooldownMinutes = {
                    description = "Sperre nach einem Raid, bei dem kein Lagerpunkt geöffnet wurde (Minuten).",
                    label = "Sperre nach Fehlschlag (Minuten)",
                },
                baseRaid_interactionDistance = {
                    description = "Interaktionsdistanz am Lager.",
                    label = "Interaktionsdistanz am Lager",
                },
                baseRaid_lootHeistStorage = {
                    description = "Erlaubt das vollständige Leeren dieser Lagerart während eines aktiven Raids.",
                    label = "Heist-Lager plündern",
                },
                baseRaid_lootLaboratories = {
                    description = "Erlaubt das vollständige Leeren dieser Lagerart während eines aktiven Raids.",
                    label = "Laborlager plündern",
                },
                baseRaid_lootPersonalLockers = {
                    description = "Erlaubt das vollständige Leeren dieser Lagerart während eines aktiven Raids.",
                    label = "Persönliche Spinde plündern",
                },
                baseRaid_lootStorage = {
                    description = "Erlaubt das vollständige Leeren dieser Lagerart während eines aktiven Raids.",
                    label = "Storage plündern",
                },
                baseRaid_lootVehicleGloveboxes = {
                    description = "Erlaubt das vollständige Leeren dieser Lagerart während eines aktiven Raids.",
                    label = "Handschuhfächer plündern",
                },
                baseRaid_lootVehicleTrunks = {
                    description = "Erlaubt das vollständige Leeren dieser Lagerart während eines aktiven Raids.",
                    label = "Kofferräume plündern",
                },
                baseRaid_minimumDefenders = {
                    description = "Verteidiger mindestens online.",
                    label = "Verteidiger mindestens online",
                },
                baseRaid_policeItem = {
                    description = "Polizei-Aufbruchitem.",
                    label = "Polizei-Aufbruchitem",
                },
                baseRaid_policeRequireDuty = {
                    description = "Polizei muss im Dienst sein.",
                    label = "Polizei muss im Dienst sein",
                },
                baseRaid_policeVehicles = {
                    description = "Polizei-Fahrzeugzugriff.",
                    label = "Polizei-Fahrzeugzugriff",
                },
                baseRaid_protectionHours = {
                    description = "Schutz nach Erfolg (Stunden).",
                    label = "Schutz nach Erfolg (Stunden)",
                },
                baseRaid_requiredHits = {
                    description = "Benötigte Skillcheck-Treffer.",
                    label = "Benötigte Skillcheck-Treffer",
                },
                baseRaid_warrantItem = {
                    description = "Bei jedem gültigen Polizei-Raidstart wird genau eines dieser Items verbraucht.",
                    label = "Durchsuchungsbefehl-Item",
                },
                crimeMembershipMode = {
                    description = "Der Framework-Modus behält die bisherige Job- oder native Gang-Anbindung. Der unabhängige Modus führt die Crime-Organisation parallel zum normalen Beruf im Hintergrund und übernimmt bestehende Mitgliedschaften automatisch.",
                    label = "Organisations-Mitgliedschaftsmodell",
                    options = {
                        framework = "Framework-Job / Gang",
                        independent = "Unabhängige Organisation",
                    },
                },
                darknetAliasChangeCooldownHours = {
                    description = "Mindestalter einer Identität, bevor sie erneut stillgelegt werden kann.",
                    label = "Aliaswechsel-Cooldown (Stunden)",
                },
                darknetCurrencyCode = {
                    description = "Kurzes Kürzel für die interne Kryptowährung.",
                    label = "Währungskürzel",
                },
                darknetDeadDropInteractionDistance = {
                    description = "Erforderliche Distanz zum Durchsuchen einer Kiste.",
                    label = "Dead-Drop-Interaktionsdistanz",
                },
                darknetDeadDropLifetimeHours = {
                    description = "Zeit, nach der eine nicht abgeholte Kiste abläuft.",
                    label = "Dead-Drop-Laufzeit (Stunden)",
                },
                darknetDeadDropModel = {
                    description = "GTA-Propmodell für verfügbare Dead Drops.",
                    label = "Dead-Drop-Kistenmodell",
                },
                darknetDeadDropPollIntervalMs = {
                    description = "Intervall zum Aktualisieren naher Kisten und NPC-Treffen.",
                    label = "Welt-Aktualisierung (ms)",
                },
                darknetDeadDropStreamDistance = {
                    description = "Distanz, in der Kisten und NPC-Kontakte geladen werden.",
                    label = "Dead-Drop-Sichtweite",
                },
                darknetDropLocations = {
                    description = "Aus diesen Orten wird bei Dead-Drop-Handeln mit NPCs zufällig ausgewählt. Mindestens zwei eintragen.",
                    itemLabel = "Dead Drop",
                    label = "Dead-Drop-Standorte",
                },
                darknetEnabled = {
                    description = "Aktiviert die Schwarzmarkt-App im Tablet und ihre Laufzeitlogik.",
                    label = "Darknet-Marktplatz aktivieren",
                },
                darknetExchangeBuyPrice = {
                    description = "Betrag, der für einen Coin vom Zahlungskonto abgezogen wird.",
                    label = "Kaufpreis pro Coin",
                },
                darknetExchangeEnabled = {
                    description = "Erlaubt angemeldeten BlackBay-Nutzern, Coins auf ihrer Kontoseite zu kaufen und zu verkaufen.",
                    label = "Coin-Wechsel aktivieren",
                },
                darknetExchangeMaximumAmount = {
                    description = "Größte ganze Coin-Menge, die in einem Wechsel akzeptiert wird.",
                    label = "Maximale Coins pro Wechsel",
                },
                darknetExchangeMinimumAmount = {
                    description = "Kleinste ganze Coin-Menge, die in einem Wechsel akzeptiert wird.",
                    label = "Minimale Coins pro Wechsel",
                },
                darknetExchangePaymentAccount = {
                    description = "Framework-Konto für Coin-Käufe und Auszahlungen aus Coin-Verkäufen.",
                    label = "Zahlungskonto für Coin-Wechsel",
                    options = {
                        bank = "Bank",
                        black_money = "Schwarzgeld",
                        money = "Bargeld",
                    },
                },
                darknetExchangeSellPrice = {
                    description = "Betrag, der für einen Coin auf das Zahlungskonto ausgezahlt wird.",
                    label = "Verkaufspreis pro Coin",
                },
                darknetFaceToFaceDistance = {
                    description = "Maximale Entfernung zwischen beiden Spielern oder zum NPC-Punkt.",
                    label = "Übergabedistanz",
                },
                darknetKnownScammerReports = {
                    description = "Eindeutige Handelsmeldungen für das Abzeichen als bekannter Betrüger.",
                    label = "Meldungen für Betrügerwarnung",
                },
                darknetListingExpiryHours = {
                    description = "Aktive Anzeigen laufen nach dieser Zeit automatisch aus.",
                    label = "Anzeigenlaufzeit (Stunden)",
                },
                darknetMaximumListingQuantity = {
                    description = "Obergrenze der Warenmenge in einer Anzeige.",
                    label = "Maximale Warenmenge",
                },
                darknetMaximumListings = {
                    description = "Maximale Anzeigenanzahl pro aktivem Alias.",
                    label = "Maximale aktive Anzeigen",
                },
                darknetMaximumMessageLength = {
                    description = "Maximale Zeichenzahl einer verschlüsselten Chatnachricht.",
                    label = "Maximale Nachrichtenlänge",
                },
                darknetMaximumUnitPrice = {
                    description = "Maximaler Kryptopreis für ein Stück.",
                    label = "Maximaler Stückpreis",
                },
                darknetMeetingLocations = {
                    description = "Aus diesen Orten wird bei persönlichen NPC-Handeln zufällig ausgewählt. Mindestens zwei eintragen.",
                    itemLabel = "Treffpunkt",
                    label = "Treffpunkte",
                },
                darknetNpcBuyerAliases = {
                    description = "Fiktive Namen, die neuen NPC-Kaufgesuchen zufällig zugeteilt werden. Mindestens zwei eindeutige Aliase eintragen.",
                    label = "NPC-Käufer-Aliase",
                },
                darknetNpcMaximumBuyListings = {
                    description = "Obergrenze für die zufällig gewählte Anzahl aktiver NPC-Kaufgesuche.",
                    label = "Maximale NPC-Kaufgesuche",
                },
                darknetNpcMaximumSellListings = {
                    description = "Obergrenze für die zufällig gewählte Anzahl aktiver NPC-Verkaufsangebote.",
                    label = "Maximale NPC-Verkaufsangebote",
                },
                darknetNpcMinimumBuyListings = {
                    description = "Beim Auffüllen bleiben mindestens so viele zufällig ausgewählte NPC-Kaufgesuche aktiv.",
                    label = "Minimale NPC-Kaufgesuche",
                },
                darknetNpcMinimumSellListings = {
                    description = "Beim Auffüllen bleiben mindestens so viele zufällig ausgewählte NPC-Verkaufsangebote aktiv.",
                    label = "Minimale NPC-Verkaufsangebote",
                },
                darknetNpcSellerAliases = {
                    description = "Fiktive Namen, die neuen NPC-Verkaufsangeboten zufällig zugeteilt werden. Mindestens zwei eindeutige Aliase eintragen.",
                    label = "NPC-Verkäufer-Aliase",
                },
                darknetNpcTraders = {
                    description = "Konfiguriert NPC-Anzeigen, Übergabeart, Reputation und Betrugswahrscheinlichkeit.",
                    label = "NPC-Käufer und -Verkäufer",
                },
                darknetPoliceGroups = {
                    description = "Gruppenschlüssel für Lockangebote und Ermittlungen.",
                    label = "Berechtigte Polizeigruppen",
                },
                darknetRenewalHours = {
                    description = "Zeit, die beim Verlängern einer Anzeige hinzugefügt wird.",
                    label = "Verlängerungsdauer (Stunden)",
                },
                darknetScamChance = {
                    description = "Mindestwahrscheinlichkeit, dass ein NPC bei einem Handel die Zahlung oder Ware nimmt, ohne die Gegenleistung zu liefern. Ein höherer Händlerwert gilt weiterhin.",
                    label = "Globale NPC-Betrugswahrscheinlichkeit (%)",
                },
                darknetStarterBalance = {
                    description = "Krypto, die nur beim allerersten Öffnen des Marktplatzes vergeben wird.",
                    label = "Startguthaben neuer Wallets",
                },
                darknetTabletOrder = {
                    description = "Bestimmt die Position des Darknet-Marktplatzes im Tablet.",
                    label = "Tablet-App-Reihenfolge",
                },
                darknetVerifiedMinimumRating = {
                    description = "Benötigte Durchschnittsbewertung für einen verifizierten Verkäufer.",
                    label = "Bewertung für Verifizierung",
                },
                darknetVerifiedMinimumSales = {
                    description = "Benötigte erfolgreiche Verkäufe für einen verifizierten Verkäufer.",
                    label = "Verkäufe für Verifizierung",
                },
                drugAdvancedBusinessNetworkPaymentAccount = {
                    description = "Wird verwendet, wenn als Zahlungsquelle das Spielerkonto gewählt ist. Organisationszahlungen laufen immer über das Bossmenü-Konto.",
                    label = "Zahlungskonto des Spielers",
                    options = {
                        bank = "Bank",
                        black_money = "Schwarzgeld",
                        money = "Bargeld",
                    },
                    requiresWarning = "Wird nur mit der Zahlungsquelle Spielerkonto verwendet.",
                },
                drugAdvancedBusinessNetworkPaymentSource = {
                    description = "Verwende entweder das Konto des kaufenden Spielers oder das Organisationskonto aus dem Bossmenü.",
                    label = "Zahlungsquelle",
                    options = {
                        player = "Spielerkonto",
                        society = "Organisationskonto",
                    },
                },
                drugCamperLockKey = {
                    description = "Legt die Standardtaste zum Auf- und Abschließen eigener oder mit der Fraktion geteilter Camper fest. Spieler können sie in den FiveM-Tastaturbelegungen persönlich ändern.",
                    label = "Standardtaste für Camper-Schloss",
                    options = {
                        L = "L",
                        U = "U",
                        K = "K",
                        J = "J",
                        G = "G",
                        H = "H",
                        X = "X",
                        Y = "Y",
                        F6 = "F6",
                        F7 = "F7",
                    },
                },
                drugCollectorInventoryMetadata = {
                    description = "Fügt Sammelergebnissen standardmäßig Qualitäts- und Chargendaten hinzu. Deaktivieren, damit Rohmaterialien normal stacken.",
                    label = "Metadaten für Sammel-Items",
                },
                drugLabAssaultAlertDuration = {
                    description = "Sekunden, die der Alarmradius für die Verteidiger auf der Karte sichtbar bleibt.",
                    label = "Alarmdauer",
                },
                drugLabAssaultAlertRadius = {
                    description = "Radius des Angriffsbereichs, der der verteidigenden Fraktion auf der Karte angezeigt wird.",
                    label = "Alarmradius für Verteidiger",
                },
                drugLabAssaultBreachRadius = {
                    description = "Radius, in dem ein Angreifer bleiben muss, während der Eingang aufgebrochen wird.",
                    label = "Aktionsradius beim Aufbrechen",
                },
                drugLabAssaultCaptureDuration = {
                    description = "Sekunden, die Angreifer den Eingang unangefochten halten müssen, um das Labor oder den Camper zu übernehmen.",
                    label = "Übernahmedauer",
                },
                drugLabAssaultCaptureRadius = {
                    description = "Bereich am Eingang, in dem Angreifer und verteidigende Gegner gezählt werden.",
                    label = "Eroberungsradius",
                },
                drugLabAssaultElectronicDuration = {
                    description = "Sekunden, die das Hacken des Eingangssystems benötigt.",
                    label = "Dauer des elektronischen Einbruchs",
                },
                drugLabAssaultEnabled = {
                    description = "Erlaubt Fraktionen, gegnerische Labore und mit Fraktionen geteilte Camper aufzubrechen und zu übernehmen.",
                    label = "Labor- und Camperübernahmen aktivieren",
                },
                drugLabAssaultExplosiveDuration = {
                    description = "Sekunden, die das Aufbrechen des Eingangs mit einer Sprengladung benötigt.",
                    label = "Dauer mit Sprengladung",
                },
                drugLabAssaultInteractionDistance = {
                    description = "Maximale Entfernung zum Labor- oder Campereingang beim Start eines Angriffs.",
                    label = "Interaktionsdistanz am Eingang",
                },
                drugLabAssaultMechanicalDuration = {
                    description = "Sekunden, die das Aufbohren des Eingangsschlosses benötigt.",
                    label = "Dauer des mechanischen Einbruchs",
                },
                drugLabAssaultMinimumDefenders = {
                    description = "So viele Mitglieder der verteidigenden Fraktion müssen online sein, bevor ein Angriff starten kann.",
                    label = "Mindestanzahl Verteidiger",
                },
                drugLabAssaultRequireDuty = {
                    description = "Berücksichtigt nur Mitglieder der verteidigenden Fraktion, die im Dienst sind.",
                    label = "Nur diensthabende Verteidiger zählen",
                },
                drugProcessingInventoryMetadata = {
                    description = "Fügt Verarbeitungsergebnissen standardmäßig Qualitäts- und Chargendaten hinzu. Einzelne Rezepte können diese Einstellung überschreiben.",
                    label = "Metadaten für Verarbeitungs-Items",
                },
                graffitiItemName = {
                    description = "Inventar-Item, das bei aktivierter Item-Pflicht zum Sprühen benötigt wird. Das Item muss im aktiven Inventar existieren.",
                    label = "Benötigtes Graffiti-Item",
                },
                heistCooldownMinutes = {
                    description = "Sperrt denselben Heist nach Ende und Bereinigung eines Durchlaufs mit tatsächlichen Interaktionen. Null deaktiviert den Cooldown. Ein ungenutztes Startfenster löst ihn nicht aus.",
                    label = "Heist-Cooldown (Minuten)",
                },
                heistCraftingMode = {
                    optionDescriptions = {
                        simple = "Fünf Sekunden Fortschrittsbalken. Benötigte Zutaten werden bei Erfolg verbraucht.",
                        medium = "Zutaten in der angezeigten Reihenfolge auswählen und je Zutat eine Timing-Prüfung bestehen.",
                        advanced = "Vollständige Gerätemontage bei Rezepten mit Geräteprofil; sonst zwei präzise Timing-Prüfungen je Zutat.",
                    },
                    description = "Einfach: fünf Sekunden Fortschrittsbalken. Mittel: Zutatenauswahl und Timing-Prüfungen. Maximal: vollständige Gerätemontage; Rezepte ohne Geräteprofil nutzen zwei präzise Timing-Prüfungen je Zutat.",
                    label = "Crafting-Aufwand",
                    options = {
                        advanced = "Maximal aufwendig",
                        medium = "Mittel komplex",
                        simple = "Ganz einfach",
                    },
                },
                heistInactivityTimeoutMinutes = {
                    description = "Nach der ersten Interaktion setzt jede weitere Heist-Aktion diesen Timer zurück. Beim Ablauf endet der Durchlauf und seine Weltobjekte werden entfernt. Gilt für neue Durchläufe.",
                    label = "Heist-Inaktivitätslimit (Minuten)",
                },
                heistStartTimeoutMinutes = {
                    description = "Zeit nach Start bis zu einer Aktion am Ziel. Ohne Interaktion wird der Durchlauf zurückgesetzt und kann erneut gestartet werden. Gilt für neue Durchläufe.",
                    label = "Minuten bis zur ersten Heist-Interaktion",
                },
                moneywashAccount = {
                    options = {
                        bank = "Bank",
                        black_money = "Schwarzgeld",
                        money = "Bargeld",
                    },
                },
                moneywashDirtyAccount = {
                    description = "Konto, von dem das Schwarzgeld des Spielers beim Start eines Waschgangs abgezogen wird.",
                    label = "Einzahlungskonto",
                },
                moneywashDrawDistance = {
                    description = "Maximale Entfernung in Metern für die Anzeige der Betriebseingänge und Shops.",
                    label = "Anzeigedistanz",
                },
                moneywashEnabled = {
                    description = "Macht die Geldwäschebetriebe der Crime-Organisationen verfügbar.",
                    label = "Geldwäsche aktivieren",
                },
                moneywashFeePercent = {
                    description = "Prozentsatz, der vor der Auszahlung an die Organisation von jedem Waschgang abgezogen wird.",
                    label = "Servicegebühr (%)",
                },
                moneywashInteractionDistance = {
                    description = "Maximale Entfernung in Metern zur Nutzung von Betriebseingängen und Shops.",
                    label = "Interaktionsdistanz",
                },
                npcPoliceAccuracy = {
                    description = "Treffsicherheit der NPC-Polizisten von 0 bis 100.",
                    label = "Schussgenauigkeit",
                },
                npcPoliceArmour = {
                    description = "Rüstungswert jedes NPC-Polizisten von 0 bis 100.",
                    label = "Schutzweste",
                },
                npcPoliceAtms = {
                    description = "Entsendet NPC-Polizeiverstärkung, wenn der Alarm eines Geldautomatenraubs ausgelöst wird.",
                    label = "Unterstützung bei Geldautomatenräuben",
                },
                npcPoliceDurationSeconds = {
                    description = "Maximale Zeit, die NPC-Polizisten nach dem Spawnen im Einsatz bleiben (30–900 Sekunden).",
                    label = "Einsatzdauer (Sekunden)",
                },
                npcPoliceEnabled = {
                    description = "Aktuell wegen Stabilitätsproblemen deaktiviert. Dieser Schalter kann das Feature derzeit nicht aktivieren.",
                    label = "NPC-Polizeiverstärkung aktivieren",
                },
                npcPoliceHeists = {
                    description = "Entsendet NPC-Polizeiverstärkung, wenn ein Heist-Alarm ausgelöst wird.",
                    label = "Unterstützung bei Heists",
                },
                npcPoliceOfficerCount = {
                    description = "Anzahl bewaffneter NPC-Polizisten, die pro Raubalarm entsendet werden (1–8).",
                    label = "Polizisten pro Einsatz",
                },
                npcPoliceResponseDelaySeconds = {
                    description = "Zeit zwischen dem Raubalarm und dem Eintreffen der NPC-Polizisten (0–300 Sekunden).",
                    label = "Reaktionsverzögerung (Sekunden)",
                },
                npcPoliceShops = {
                    description = "Entsendet NPC-Polizeiverstärkung, wenn der Alarm eines Ladenraubs ausgelöst wird.",
                    label = "Unterstützung bei Ladenräuben",
                },
                npcPoliceSpawnDistance = {
                    description = "Angestrebte Entfernung zum Tatort, in der NPC-Polizisten spawnen (15–150 Meter).",
                    label = "Spawnentfernung (Meter)",
                },
                npcPoliceWeapon = {
                    description = "Waffe, mit der jeder entsendete NPC-Polizist ausgerüstet wird. Standardmäßig eine Pistole.",
                    label = "Dienstwaffe",
                    options = {
                        WEAPON_CARBINERIFLE = "Karabiner",
                        WEAPON_PISTOL = "Pistole",
                        WEAPON_PUMPSHOTGUN = "Pumpgun",
                    },
                },
                openHeistCreator = {
                    buttonLabel = "Heist Creator öffnen",
                    description = "Öffnet den Heist Creator und schließt den Job-Konfigurator.",
                    label = "Heist-Creator",
                    unsavedTooltip = "Zuerst Änderungen speichern",
                },
                pickpocketAggressionChance = {
                    description = "Unabhängige Chance, dass der NPC nach einem fehlgeschlagenen, abgebrochenen oder abgelaufenen Versuch angreift.",
                    label = "Gegenwehrchance (%)",
                },
                pickpocketAlertChance = {
                    description = "Unabhängige Chance, dass der NPC einen fehlgeschlagenen, abgebrochenen oder abgelaufenen Versuch meldet.",
                    label = "Notrufchance (%)",
                },
                pickpocketDifficulty = {
                    description = "Steuert Zeigergeschwindigkeit, Verkleinerung des Zielbereichs, Sequenzlänge und erlaubte Fehler.",
                    label = "Schwierigkeit",
                    options = {
                        easy = "Leicht",
                        expert = "Experte",
                        hard = "Schwer",
                        normal = "Normal",
                    },
                },
                pickpocketDispatchAlways = {
                    description = "Jeden gestarteten Taschendiebstahl einmal melden, auch bei Erfolg und unabhängig von der Notrufchance.",
                    label = "Immer Dispatch auslösen",
                },
                pickpocketDispatchDurationSeconds = {
                    description = "Sekunden, die der Notruf für Dispatch-Empfänger relevant bleibt.",
                    label = "Dispatch-Dauer",
                },
                pickpocketDispatchJobs = {
                    description = "Kommagetrennte Jobnamen, die Notrufe erhalten.",
                    label = "Dispatch-Jobs",
                },
                pickpocketDispatchPriority = {
                    description = "Priorität, die unverändert an die Dispatch-Integration geht.",
                    label = "Dispatch-Priorität",
                },
                pickpocketDispatchRadius = {
                    description = "Ungefährer Alarmradius für die Dispatch-Integration.",
                    label = "Dispatch-Radius",
                },
                pickpocketEmptyChance = {
                    description = "Chance, dass der NPC überhaupt keine auswählbare Beute bei sich trägt.",
                    label = "Leere-Taschen-Chance (%)",
                },
                pickpocketEnabled = {
                    description = "Erlaubt Versuche bei geeigneten, zufälligen und synchronisierten NPCs.",
                    label = "NPC-Taschendiebstahl aktivieren",
                },
                pickpocketFleeChance = {
                    description = "Unabhängige Chance, dass der NPC nach einem fehlgeschlagenen, abgebrochenen oder abgelaufenen Versuch wegläuft.",
                    label = "Fluchtchance des NPCs (%)",
                },
                pickpocketInteractionDistance = {
                    description = "Maximale Client-Reichweite; der Server prüft mit kleinem Synchronisationspuffer.",
                    label = "Interaktionsdistanz",
                },
                pickpocketItems = {
                    description = "Jede Zeile steuert ihre Erscheinungschance. Vier Nachkommastellen erlauben 0,0001 Prozent.",
                    itemLabel = "Item-Chance",
                    label = "Item-Beute",
                },
                pickpocketItemsEnabled = {
                    description = "Würfelt konfigurierte Items in den sichtbaren Tascheninhalt.",
                    label = "Item-Beute aktivieren",
                },
                pickpocketMaximumLootChoices = {
                    description = "Höchstzahl serverseitig erzeugter Bargeld- oder Item-Slots pro NPC.",
                    label = "Maximal sichtbare Beute",
                },
                pickpocketMinigame = {
                    description = "Wählt eine Herausforderung oder rotiert zufällig zwischen allen drei.",
                    label = "Minispiel",
                    options = {
                        pulse = "Druckimpuls",
                        random = "Zufällige Rotation",
                        sequence = "Richtungsfolge",
                        timing = "Timing-Leiste",
                    },
                },
                pickpocketMoneyMaximum = {
                    description = "Höchster sichtbarer Bargeldbetrag; wird nie unter das Minimum gesetzt.",
                    label = "Maximales Bargeld",
                },
                pickpocketMoneyMinimum = {
                    description = "Niedrigster serverseitig erzeugter Betrag eines sichtbaren Bargeld-Slots.",
                    label = "Minimales Bargeld",
                },
                pickpocketRequestCooldownSeconds = {
                    description = "Mindestsekunden zwischen Startanfragen eines Spielers.",
                    label = "Anfrage-Cooldown",
                },
                pickpocketRequireCrimeJob = {
                    description = "Aktiv: zeigt die Aktion nur registrierten Crime-System-Jobs. Inaktiv: entfernt die interne Radial-Aktion und verlangt den Server-Export.",
                    label = "Crime-Job-Radial verwenden",
                },
                pickpocketRequiredHits = {
                    description = "Basiswert für alle Minigames. Wertvolles Bargeld erhöht ihn schrittweise; extrem seltene Items verlangen mindestens acht Treffer.",
                    label = "Mindestanzahl Treffer",
                },
                pickpocketSessionTimeoutSeconds = {
                    description = "Sekunden, bis eine unvollständige Server-Challenge abläuft.",
                    label = "Sitzungs-Timeout",
                },
                pickpocketTargetCooldownMinutes = {
                    description = "Sperre nach abgebrochenen oder fehlgeschlagenen Versuchen; erfolgreich geleerte NPCs bleiben gesperrt.",
                    label = "NPC-Cooldown",
                },
                pvpAdminAce = {
                    description = "ACE-Objekt für den globalen Zugriff auf die PvP-Eventverwaltung.",
                    label = "Administrator-ACE",
                },
                pvpArenaReturnSeconds = {
                    description = "Standard-Rückkehrzeit für neue Events. Die Eventleitung kann sie im Tablet anpassen.",
                    label = "Rückkehrzeit zur Arena",
                },
                pvpArenaWarningPosition = {
                    description = "Legt fest, wo die Rückkehrwarnung der Arena angezeigt wird.",
                    label = "Zonenwarnungs-Position",
                    options = {
                        bottom_center = "Unten mittig",
                        bottom_left = "Unten links",
                        bottom_right = "Unten rechts",
                        middle_center = "Bildschirmmitte",
                        middle_left = "Mittig links",
                        middle_right = "Mittig rechts",
                        top_center = "Oben mittig",
                        top_left = "Oben links",
                        top_right = "Oben rechts",
                    },
                },
                pvpArenas = {
                    description = "Erstellt runde Kampfzonen mit Zuschauerpunkt und mindestens zwei Team-Spawns.",
                    itemLabel = "Arena",
                    label = "PvP-Arenen",
                },
                pvpCountdownPosition = {
                    description = "Legt fest, wo der Start-Countdown angezeigt wird.",
                    label = "Countdown-Position",
                    options = {
                        bottom_center = "Unten mittig",
                        bottom_left = "Unten links",
                        bottom_right = "Unten rechts",
                        middle_center = "Bildschirmmitte",
                        middle_left = "Mittig links",
                        middle_right = "Mittig rechts",
                        top_center = "Oben mittig",
                        top_left = "Oben links",
                        top_right = "Oben rechts",
                    },
                },
                pvpDefaultMode = {
                    description = "Vorausgewählter Spielmodus für neue Events.",
                    label = "Standard-Spielmodus",
                    options = {
                        free_for_all = "Jeder gegen jeden",
                        last_man_standing = "Letzter Mann, der steht",
                        team_deathmatch = "Team-Deathmatch",
                    },
                },
                pvpDefaultScoreLimit = {
                    description = "Standardanzahl an Kills für den Sieg in Team-Deathmatch oder Jeder gegen jeden.",
                    label = "Standard-Kill-Ziel",
                },
                pvpEventsEnabled = {
                    description = "Schaltet die Fraktions-PvP-App und die Eventlogik frei.",
                    label = "Fraktions-PvP-Events aktivieren",
                },
                pvpKillfeedPosition = {
                    description = "Legt fest, wo die letzten Abschüsse angezeigt werden.",
                    label = "Killfeed-Position",
                    options = {
                        bottom_center = "Unten mittig",
                        bottom_left = "Unten links",
                        bottom_right = "Unten rechts",
                        middle_center = "Bildschirmmitte",
                        middle_left = "Mittig links",
                        middle_right = "Mittig rechts",
                        top_center = "Oben mittig",
                        top_left = "Oben links",
                        top_right = "Oben rechts",
                    },
                },
                pvpLeaderPermission = {
                    description = "Job-Berechtigung zum Erstellen, Anmelden, Starten und Verwalten von Fraktions-Events.",
                    label = "Fraktionsleitungs-Berechtigung",
                },
                pvpMatchDurationMinutes = {
                    description = "Standarddauer in Minuten für neue Events. Null deaktiviert das Zeitlimit.",
                    label = "Matchdauer",
                },
                pvpMaxHistory = {
                    description = "Maximale Anzahl beendeter oder abgebrochener Events im Tablet.",
                    label = "Sichtbarer Eventverlauf",
                },
                pvpMaxRewards = {
                    description = "Maximale Anzahl kombinierter Item-, Waffen-, Fahrzeug- oder Geldbelohnungen pro Event.",
                    label = "Maximale Zusatzbelohnungen",
                },
                pvpMoneyPermission = {
                    description = "Job-Berechtigung für Einsätze und Preisgelder.",
                    label = "Fraktionsfinanz-Berechtigung",
                },
                pvpRequestCooldownMs = {
                    description = "Mindestabstand in Millisekunden zwischen verändernden PvP-Anfragen eines Spielers.",
                    label = "Aktions-Cooldown",
                },
                pvpRespawnDelaySeconds = {
                    description = "Sekunden bis ein Spieler respawnt oder nach einem Tod in den Zuschauerbereich versetzt wird.",
                    label = "Respawn-Verzögerung",
                },
                pvpSchedulePollSeconds = {
                    description = "Sekunden zwischen den Prüfungen wiederkehrender Vorlagen und automatischer Starts.",
                    label = "Zeitplan-Prüfintervall",
                },
                pvpScoreboardPosition = {
                    description = "Legt fest, wo das kompakte Live-Scoreboard während eines Fraktionskampfs angezeigt wird.",
                    label = "Scoreboard-Position",
                    options = {
                        bottom_center = "Unten mittig",
                        bottom_left = "Unten links",
                        bottom_right = "Unten rechts",
                        middle_center = "Bildschirmmitte",
                        middle_left = "Mittig links",
                        middle_right = "Mittig rechts",
                        top_center = "Oben mittig",
                        top_left = "Oben links",
                        top_right = "Oben rechts",
                    },
                },
                pvpSoloTestingEnabled = {
                    description = "Erlaubt PvP-Administratoren die Anmeldung und den manuellen Start mit einem Fraktionsmitglied. Auf Produktivservern deaktivieren.",
                    label = "Administrator-Solotest aktivieren",
                },
                pvpStartCountdownSeconds = {
                    description = "Standard-Countdown für neue Events. Die Eventleitung kann ihn im Tablet anpassen.",
                    label = "Start-Countdown",
                },
                pvpTabletOrder = {
                    description = "Bestimmt die Position der Fraktions-PvP-App auf dem Tablet.",
                    label = "Tablet-App-Reihenfolge",
                },
                shopActiveTimeoutMinutes = {
                    description = "Minuten bis ein verlassener Überfall fehlschlägt.",
                    label = "Aktives Zeitlimit",
                },
                shopConsumeDrill = {
                    description = "Bohrmaschine nach Erfolg verbrauchen.",
                    label = "Bohrmaschine verbrauchen",
                },
                shopConsumeHackItem = {
                    description = "Das Hacking-Item nach erfolgreichem Öffnen verbrauchen.",
                    label = "Hacking-Item verbrauchen",
                },
                shopCooldownMinutes = {
                    description = "Laufzeit-Minuten bis zur Rücksetzung.",
                    label = "Laden-Abklingzeit",
                },
                shopDispatchAlways = {
                    description = "Jeden Ladenüberfall beim Start einmal melden, auch bei ununterbrochener Bedrohung und Läden ohne Verkäuferpflicht.",
                    label = "Immer Dispatch auslösen",
                },
                shopDispatchDurationSeconds = {
                    description = "Relevanzdauer des Alarms in Sekunden.",
                    label = "Dispatch-Dauer",
                },
                shopDispatchJobs = {
                    description = "Kommagetrennte Empfänger-Jobs.",
                    label = "Dispatch-Jobs",
                },
                shopDispatchPriority = {
                    description = "An Dispatch übergebene Priorität.",
                    label = "Dispatch-Priorität",
                },
                shopDispatchRadius = {
                    description = "Ungefährer Polizeialarmradius.",
                    label = "Dispatch-Radius",
                },
                shopDrillDurationSeconds = {
                    description = "Sekunden zum Aufbohren des Tresors.",
                    label = "Dauer Tresorbohrung",
                },
                shopDrillItem = {
                    description = "Inventar-Item-ID zum Aufbohren von Ladentresoren. Unabhängig vom ATM-Bohrer.",
                    label = "Bohrmaschinen-Item",
                },
                shopDrillItemAmount = {
                    description = "Benötigte Itemanzahl.",
                    label = "Benötigte Bohrmaschinen",
                },
                shopEnabled = {
                    description = "Aktiviert Überfälle in konfigurierten Läden.",
                    label = "Ladenüberfälle aktivieren",
                },
                shopHackItem = {
                    description = "Benötigtes Item für das Tresor-Hack-Minispiel. Der Öffnungsweg wird pro Laden freigeschaltet.",
                    label = "Hacking-Item",
                },
                shopHackItemAmount = {
                    description = "Benötigte Anzahl des Hacking-Items.",
                    label = "Hacking-Item: Anzahl",
                },
                shopIntimidationSeconds = {
                    description = "Sekunden ununterbrochener Bedrohung.",
                    label = "Einschüchterungsdauer",
                },
                shopLocations = {
                    description = "Ein Angestellter, eine Kasse und ein optionaler Tresor pro Laden.",
                    itemLabel = "Laden",
                    label = "Ladenstandorte",
                },
                shopMinimumPolice = {
                    description = "Benötigte diensthabende Mitglieder der Polizeigruppe.",
                    label = "Mindestanzahl Polizei",
                },
                shopPoliceGroup = {
                    description = "Für die Voraussetzung gezählte Jobgruppe.",
                    label = "Polizei-Jobgruppe",
                },
                shopRegisterDurationSeconds = {
                    description = "Sekunden zum Leeren einer Kasse.",
                    label = "Dauer Kassenplünderung",
                },
                shopRegisterRewardMaximum = {
                    description = "Höchste Kassenauszahlung.",
                    label = "Maximale Kassenbelohnung",
                },
                shopRegisterRewardMinimum = {
                    description = "Niedrigste Kassenauszahlung.",
                    label = "Minimale Kassenbelohnung",
                },
                shopRegisterRewardName = {
                    description = "Optionaler Item- oder Kontoname.",
                    label = "Kassen-Belohnungsname",
                },
                shopRegisterRewardSort = {
                    description = "Wähle zwischen Bargeld und dem Gegenstand black_money.",
                    label = "Kassen-Auszahlungsart",
                },
                shopRegisters = {
                    description = "Per Laden-ID zugewiesene Kassenpositionen.",
                    itemLabel = "Kasse",
                    label = "Kassen",
                },
                shopSafeLootDurationSeconds = {
                    description = "Sekunden zum Entnehmen des Geldes nach einer gültigen Codeeingabe.",
                    label = "Dauer Tresorplünderung",
                },
                shopSafeRewardMaximum = {
                    description = "Höchste Tresorauszahlung.",
                    label = "Maximale Tresorbelohnung",
                },
                shopSafeRewardMinimum = {
                    description = "Niedrigste Tresorauszahlung.",
                    label = "Minimale Tresorbelohnung",
                },
                shopSafeRewardName = {
                    description = "Optionaler Item- oder Kontoname.",
                    label = "Tresor-Belohnungsname",
                },
                shopSafeRewardSort = {
                    description = "Wähle zwischen Bargeld und dem Gegenstand black_money.",
                    label = "Tresor-Auszahlungsart",
                },
                shopThreatGraceSeconds = {
                    description = "Erlaubte Unterbrechung vor dem Alarm.",
                    label = "Ziel-Toleranz",
                },
                territoryDrugSalesEnabled = {
                    description = "Erfolgreiche Straßenverkäufe an NPCs geben der Gang des Verkäufers Einfluss im aktuellen Straßenterritorium.",
                    label = "NPC-Verkäufe geben Gebietseinfluss",
                },
                atmLocationMode = {
                    label = "Standortmodus für Geldautomaten",
                    description = "Erkennt unterstützte Weltobjekte automatisch oder verwendet ausschließlich manuell konfigurierte Standorte.",
                    options = {
                        automatic = "Automatisch",
                        manual = "Manuell",
                    },
                },
                atmPoliceRequirementEnabled = {
                    label = "Polizisten im Dienst voraussetzen",
                    description = "Ein Geldautomatenüberfall erfordert die konfigurierte Anzahl an Polizisten im Dienst.",
                },
                openDrugCreator = {
                    label = "Drogen-Editor",
                    description = "Öffnet den Sky-Crime-Drogen-Editor und schließt den Job-Konfigurator.",
                    buttonLabel = "Drogen-Editor öffnen",
                    unsavedTooltip = "Zuerst speichern",
                },
                drugCreatorRuntimeDensity = {
                    label = "Darstellungsdichte der Betriebsübersicht",
                    description = "Bestimmt, wie kompakt die Betriebsübersicht im Drogen-Editor dargestellt wird.",
                    options = {
                        comfortable = "Komfortabel",
                        compact = "Kompakt",
                    },
                },
                drugCreatorListDensity = {
                    label = "Darstellungsdichte der Liste",
                    description = "Bestimmt, wie kompakt die Eintragsliste im Editor dargestellt wird.",
                    options = {
                        comfortable = "Komfortabel",
                        compact = "Kompakt",
                    },
                },
                drugCreatorShowEmptyRuntimeLists = {
                    label = "Leere Betriebslisten anzeigen",
                    description = "Zeigt Bereiche der Betriebsübersicht auch ohne Einträge an.",
                },
                drugCreatorHideDisabledEntries = {
                    label = "Deaktivierte Einträge ausblenden",
                    description = "Blendet deaktivierte Moduleinträge in der Liste des Drogen-Editors aus.",
                },
                drugCreatorAutoGenerateId = {
                    label = "IDs automatisch erzeugen",
                    description = "Erzeugt beim Anlegen neuer Einträge im Drogen-Editor die IDs aus deren Namen.",
                },
                drugCreatorOpenEditorOnModuleChange = {
                    label = "Editor bei Modulwechsel öffnen",
                    description = "Öffnet den Editor automatisch beim Wechsel des aktiven Moduls.",
                },
                drugCreatorSmartDuplicateSuffix = {
                    label = "Automatischer Namenszusatz für Kopien",
                    description = "Ergänzt beim Duplizieren von Einträgen im Drogen-Editor einen automatisch erzeugten Namenszusatz.",
                },
                drugCreatorAutoSelectRuntimeTargets = {
                    label = "Spielziele automatisch vorwählen",
                    description = "Wählt verfügbare Labore und Chargen automatisch vor.",
                },
                drugCreatorAttentionOnOpen = {
                    label = "Beim Öffnen auf Probleme fokussieren",
                    description = "Öffnet die Betriebsübersicht mit Fokus auf Einträge, die Aufmerksamkeit erfordern.",
                },
                drugActivityHudPosition = {
                    label = "Position der Aktivitätsanzeige",
                    description = "Ziehe die Anzeige für Platzierung und Ernte an die gewünschte Bildschirmposition.",
                },
                drugInteractionHudPosition = {
                    label = "Position der Interaktionsanzeige",
                    description = "Ziehe die Interaktionsanzeige für Pflanzen, Labore und Camper an die gewünschte Bildschirmposition.",
                },
                drugPlantStatusHudPosition = {
                    label = "Position der Pflanzenstatusanzeige",
                    description = "Ziehe die ausführliche Pflanzenstatusanzeige an die gewünschte Bildschirmposition.",
                },
                drugSystemEnabled = {
                    label = "Drogensystem",
                    description = "Aktiviert: Drogenproduktion, Editor-Daten und Spielschnittstellen für diesen Crime-Job.",
                },
                drugCreatorAccess = {
                    label = "Zugriff auf den Drogen-Editor",
                    description = "Bestimmt, wer den erweiterten Drogen-Editor öffnen darf.",
                    options = {
                        permission = "Nur mit Berechtigung",
                        job_management = "Jobverwaltung",
                        owner_only = "Nur Eigentümer",
                    },
                },
                drugRuntimeEnabled = {
                    label = "Schnittstellen für den Spielbetrieb",
                    description = "Erlaubt Spielern die Labor-, Pflanzen-, Verarbeitungs- und Marktaktionen im Spiel.",
                },
                drugRuntimePlayerCreateLabs = {
                    label = "Laborerstellung durch Spieler",
                    description = "Erlaubt Spielern mit Spielzugriff, auch ohne Adminrechte Labore aus Editor-Vorlagen zu erstellen.",
                },
                drugRuntimeOutdoorPlanting = {
                    label = "Anbau im Freien",
                    description = "Erlaubt Spielern eigene Freilandpflanzungen außerhalb konfigurierter Labore.",
                },
                drugRuntimePublicOutdoorHarvest = {
                    label = "Freilandernte durch andere Spieler",
                    description = "Erlaubt anderen Spielern, Freilandpflanzen zu ernten, die sie nicht selbst gepflanzt haben.",
                },
                drugRuntimeChargeLabPurchase = {
                    label = "Laborkauf berechnen",
                    description = "Berechnet Spielern beim Erstellen eines Labors den konfigurierten Kaufpreis.",
                },
                drugRuntimeStrictInventory = {
                    label = "Inventarzugriffe strikt prüfen",
                    description = "Spielaktionen werden nur fortgesetzt, wenn die konfigurierten Gegenstands-, Werkzeug- und Geldzugriffe erfolgreich sind.",
                },
                drugRuntimeSalePayouts = {
                    label = "Verkauf / Auszahlungen",
                    description = "Zahlt Spielern Geld aus, wenn Chargen oder Routen über das Marktsystem verkauft werden.",
                },
                drugRuntimeSalePayoutAccount = {
                    label = "Auszahlung / Konto",
                    description = "Konto für Auszahlungen aus Drogenverkäufen, zum Beispiel black_money.",
                },
                drugRuntimeDispatchEnabled = {
                    label = "Leitstelle / Alarme",
                    description = "Leitet Drogenrisiko-Ereignisse an die Leitstelle und die konfigurierten Polizeijobs weiter.",
                },
                drugRuntimeNotifyPoliceJobs = {
                    label = "Polizei / Benachrichtigungen",
                    description = "Benachrichtigt die konfigurierten Polizeijobs, wenn ein Drogenrisiko-Ereignis einen Polizeialarm auslöst.",
                },
                drugBatchPrefix = {
                    label = "Charge / Präfix",
                    description = "Präfix für die IDs neu erzeugter Drogenchargen.",
                },
                drugTestingKitAccuracy = {
                    label = "Testausrüstung / Genauigkeit",
                    description = "Erlaubte Abweichung verborgener Werte bei einem einfachen Testset.",
                },
                drugDecayIntervalMinutes = {
                    label = "Verfall / Intervall",
                    description = "Intervall in Minuten für Prüfungen zum Abbau von Frische und Verunreinigung.",
                },
                drugDefaultPackaging = {
                    label = "Standardwert / Verpackung",
                    description = "Verpackung für neu erzeugte Roh- oder Verarbeitungs-Chargen ohne ausdrücklich festgelegten Verpackungstyp.",
                    options = {
                        loose = "Lose Ware",
                        baggy = "Tütchen",
                        jar = "Glas",
                        vacuum = "Vakuumbeutel",
                        brick = "Blockverpackung",
                        premium_seal = "Premiumversiegelung",
                    },
                },
                drugQualityWeightQuality = {
                    label = "Qualität / Gewichtung",
                    description = "Einfluss auf die Gesamtqualität: Grundqualität.",
                },
                drugQualityWeightPurity = {
                    label = "Reinheit / Gewichtung",
                    description = "Einfluss auf die Gesamtqualität: Reinheit.",
                },
                drugQualityWeightFreshness = {
                    label = "Frische / Gewichtung",
                    description = "Einfluss auf die Gesamtqualität: Frische.",
                },
                drugQualityWeightPotency = {
                    label = "Wirkstärke / Gewichtung",
                    description = "Einfluss auf die Gesamtqualität: Wirkstärke.",
                },
                drugQualityWeightStability = {
                    label = "Stabilität / Gewichtung",
                    description = "Einfluss auf die Gesamtqualität: Stabilität.",
                },
                drugQualityWeightContamination = {
                    label = "Verunreinigung / Abzug",
                    description = "Abzug von der Qualitätsbewertung verunreinigter Produkte.",
                },
                drugTierGoodMin = {
                    label = "Gut / Stufe / Minimum",
                    description = "Mindestpunktzahl für die Qualitätsstufe Gut.",
                },
                drugTierPremiumMin = {
                    label = "Premium / Stufe / Minimum",
                    description = "Mindestpunktzahl für die Qualitätsstufe Premium.",
                },
                drugTierTopShelfMin = {
                    label = "Spitzenqualität / Stufe / Minimum",
                    description = "Mindestpunktzahl für die Qualitätsstufe Spitzenqualität.",
                },
                drugTierLabGradeMin = {
                    label = "Laborqualität / Stufe / Minimum",
                    description = "Mindestpunktzahl für die Qualitätsstufe Laborqualität.",
                },
                drugBaggyDecayMultiplier = {
                    label = "Tütchen / Verfall",
                    description = "Multiplikator für Frischeverlust / Tütchen.",
                },
                drugJarDecayMultiplier = {
                    label = "Glas / Verfall",
                    description = "Multiplikator für Frischeverlust / Gläser.",
                },
                drugVacuumDecayMultiplier = {
                    label = "Vakuum / Verfall",
                    description = "Multiplikator für Frischeverlust / Vakuumbeutel.",
                },
                drugPremiumSealPriceMultiplier = {
                    label = "Premiumversiegelung / Preis",
                    description = "Multiplikator für Premium / Versiegeltes Produkt / Preis.",
                },
                drugGrowingEnabled = {
                    label = "Anbau / Aktiviert",
                    description = "Aktiviert: Pflanzenwachstum und Ernte.",
                },
                drugEnvironmentSurveyEnabled = {
                    label = "Standortprüfung für Pflanzen",
                    description = "Aktiviert: Frei gesetzte Pflanzen wachsen erst nach einer automatischen Standortprüfung durch einen Admin. Deaktiviert: Wachstum ohne Admin-Freigabe.",
                },
                drugGrowthTickMinutes = {
                    label = "Wachstum / Aktualisierungsschritt / Minuten",
                    description = "Intervall in Minuten für Aktualisierung des Pflanzenwachstums.",
                },
                drugBaseGrowthPerTick = {
                    label = "Grundwert / Wachstum / Je Aktualisierungsschritt",
                    description = "Grundwachstum vor den Einflüssen von Sorte, Ausrüstung und Pflege.",
                },
                drugWildPlantRespawnMinutes = {
                    label = "Wildpflanze / Wiedererscheinen",
                    description = "Wartezeit in Minuten bis Wildpflanze / Wiedererscheinen.",
                },
                drugWildPlantHighlightEnabled = {
                    label = "Wildpflanzen hervorheben",
                    description = "Zeigt eine Umrandung gespawnter Wildpflanzen, sobald ein Spieler im Hervorhebungsradius ist.",
                },
                drugWildPlantHighlightDistance = {
                    label = "Hervorhebungsradius für Wildpflanzen",
                    description = "Entfernung in Metern um jede gespawnte Wildpflanze, innerhalb der ihre Umrandung sichtbar wird.",
                },
                drugDefaultPlantWater = {
                    label = "Standardwert / Wasser",
                    description = "Anfangswert beim Erstellen einer Pflanze: Wasser.",
                },
                drugDefaultPlantFertilizer = {
                    label = "Standardwert / Dünger",
                    description = "Anfangswert beim Erstellen einer Pflanze: Dünger.",
                },
                drugDefaultPlantHealth = {
                    label = "Standardwert / Gesundheit",
                    description = "Anfangswert beim Erstellen einer Pflanze: Gesundheit.",
                },
                drugDefaultPlantMutationChance = {
                    label = "Standardwert / Mutationschance",
                    description = "Grundwahrscheinlichkeit einer Mutation, falls die Pflanzensorte keinen eigenen Wert vorgibt.",
                },
                drugHarvestPerfectStart = {
                    label = "Beginn des optimalen Erntefensters",
                    description = "Wachstumsstand in Prozent für das optimale Erntefenster: Beginn.",
                },
                drugHarvestPerfectEnd = {
                    label = "Ende des optimalen Erntefensters",
                    description = "Wachstumsstand in Prozent für das optimale Erntefenster: Ende.",
                },
                drugLabsEnabled = {
                    label = "Labore / Aktiviert",
                    description = "Aktiviert: Labore und Wohnmobile im Spielbetrieb.",
                },
                drugMaxLaboratoriesPerCharacter = {
                    label = "Labore pro Charakter",
                    description = "Maximale Anzahl gekaufter oder gemieteter fester Labore pro Besitzer. 0 bedeutet unbegrenzt; Wohnmobile und geteilte Zugriffe zählen nicht.",
                },
                drugMaxLaboratoriesPerFaction = {
                    label = "Labore pro Fraktion",
                    description = "Maximale Anzahl gekaufter oder gemieteter fester Labore pro Besitzer. 0 bedeutet unbegrenzt; Wohnmobile und geteilte Zugriffe zählen nicht.",
                },
                drugDefaultRentDays = {
                    label = "Standardwert / Miettage",
                    description = "Standardwert für Labor / Miete / Dauer.",
                },
                drugCamperHotVehicleMinutes = {
                    label = "Gestohlenes Wohnmobil / Minuten",
                    description = "Dauer, während der gestohlene Wohnmobile ein erhöhtes Risiko haben.",
                },
                drugLabRentWarningHours = {
                    label = "Miete / Warnung / Stunden",
                    description = "Stunden vor Ablauf der Labormiete, ab denen eine Warnung angezeigt wird.",
                },
                drugLabRentExpiredHeatGain = {
                    label = "Abgelaufene Miete / Fahndungsdruck",
                    description = "Zusätzlicher Fahndungsdruck, wenn die Labormiete abläuft.",
                },
                drugCamperMoveCooldownMinutes = {
                    label = "Wohnmobil / Verschieben / Abklingzeit",
                    description = "Wartezeit in Minuten bis Wohnmobil / Labor / Erneutes Versetzen.",
                },
                drugLabUpgradeCostMultiplier = {
                    label = "Verbesserung / Kosten / Multiplikator",
                    description = "Multiplikator für Labor / Stufe / Verbesserung / Preise.",
                },
                drugCamperBaseSlots = {
                    label = "Wohnmobil / Plätze",
                    description = "Standardwert für Wohnmobillabore / Ausrüstungsplätze.",
                },
                drugCamperBaseStorage = {
                    label = "Wohnmobil / Lager",
                    description = "Standardwert für Wohnmobillabore / Lagerkapazität.",
                },
                drugCamperBasePower = {
                    label = "Wohnmobil / Strom",
                    description = "Standardwert für Wohnmobillabore / Integrierte Stromversorgung.",
                },
                drugBasementBaseSlots = {
                    label = "Kellerlabor / Plätze",
                    description = "Standardwert für Kellerlabore / Ausrüstungsplätze.",
                },
                drugBasementBaseStorage = {
                    label = "Kellerlabor / Lager",
                    description = "Standardwert für Kellerlabore / Lagerkapazität.",
                },
                drugWarehouseBasePower = {
                    label = "Lagerhallenlabor / Strom",
                    description = "Standardwert für Lagerhallenlabore / Integrierte Stromversorgung.",
                },
                drugPowerEnabled = {
                    label = "Strom / System",
                    description = "Aktiviert: Stromerzeugung, Stromverbrauch und Überlastungsprüfungen im Labor.",
                },
                drugOverloadGraceSeconds = {
                    label = "Überlastung / Schonfrist",
                    description = "Sekunden, bevor eine Stromüberlastung gefährlich wird.",
                },
                drugHeatPerKilowatt = {
                    label = "Fahndungsdruck / Je Kilowatt",
                    description = "Fahndungsdruck im Labor, der durch den Stromverbrauch entsteht.",
                },
                drugGeneratorT1Watts = {
                    label = "Generator T1 Watt",
                    description = "Leistung der Generatorstufe T1 in Watt.",
                },
                drugGeneratorT2Watts = {
                    label = "Generator T2 Watt",
                    description = "Leistung der Generatorstufe T2 in Watt.",
                },
                drugGeneratorT3Watts = {
                    label = "Generator T3 Watt",
                    description = "Leistung der Generatorstufe T3 in Watt.",
                },
                drugEquipmentConditionWearMultiplier = {
                    label = "Verschleiß / Multiplikator",
                    description = "Globaler Multiplikator für Ausrüstungsverschleiß / Verarbeitung.",
                },
                drugWorkersEnabled = {
                    label = "Mitarbeiter / Aktiviert",
                    description = "Aktiviert: Chemiker, Anbauer, Verpacker und Sicherheitspersonal in Drogenlaboren.",
                },
                drugMaxWorkersPerLab = {
                    label = "Maximum / Mitarbeiter / Labor",
                    description = "Maximale Anzahl der Arbeitskräfte pro Labor.",
                },
                drugWorkerFatiguePerProcessStep = {
                    label = "Ermüdung durch Verarbeitung",
                    description = "Zusätzliche Ermüdung für Mitarbeiter nach folgender Arbeit: Verarbeitungsschritt.",
                },
                drugWorkerFatiguePerGrowAction = {
                    label = "Anbau / Müdigkeit",
                    description = "Zusätzliche Ermüdung für Anbauer nach folgender Arbeit: Ernte oder Anbauarbeit.",
                },
                drugWorkerRecoveryPerTick = {
                    label = "Mitarbeiter / Erholung",
                    description = "Erholung von Müdigkeit bei jedem Schritt: Wachstumsaktualisierung.",
                },
                drugMarketEnabled = {
                    label = "Markt / Aktiviert",
                    description = "Aktiviert: Käufer, Dealer und den Verkauf von Chargen.",
                },
                drugMarketBasePriceFallback = {
                    label = "Ersatzwert / Grundpreis",
                    description = "Grundpreis für Drogen ohne eigens konfigurierten Preis.",
                },
                drugMarketStreetMultiplier = {
                    label = "Straße / Multiplikator",
                    description = "Globaler Multiplikator für Preis / Straßenverkauf.",
                },
                drugMarketWholesaleMultiplier = {
                    label = "Großhandel / Multiplikator",
                    description = "Globaler Multiplikator für Preis / Großhandel / Geschäfte.",
                },
                drugMarketPremiumMultiplier = {
                    label = "Premium / Multiplikator",
                    description = "Globaler Multiplikator für Preis / Premium / Käufer.",
                },
                drugMarketHeatPerSale = {
                    label = "Fahndungsdruck / Verkauf",
                    description = "Grundwert des Fahndungsdrucks, der beim Verkauf einer Charge zum Labor hinzukommt.",
                },
                drugDistributionTickMinutes = {
                    label = "Vertrieb / Aktualisierungsschritt",
                    description = "Intervall in Minuten für Aktualisierung der Dealer-Vertriebsaufträge.",
                },
                drugDistributionIntervalMinutes = {
                    label = "Vertrieb / Intervall",
                    description = "Standardwert für Dealer / Wartezeit vor einem Verkauf / Minuten.",
                },
                drugDistributionMaxPerDealer = {
                    label = "Maximum / Dealer / Aufträge",
                    description = "Standardwert für Dealer / Maximale Anzahl aktiver Vertriebsaufträge.",
                },
                drugThreatsEnabled = {
                    label = "Bedrohungen / Aktiviert",
                    description = "Aktiviert: Abbau des Fahndungsdrucks, Razzien und Sabotageereignisse in Laboren.",
                },
                drugThreatTickMinutes = {
                    label = "Bedrohung / Aktualisierungsschritt",
                    description = "Intervall in Minuten für Abbau des Fahndungsdrucks sowie Razzia- und Sabotageprüfungen.",
                },
                drugRaidHeatThreshold = {
                    label = "Fahndungsschwelle für Razzien",
                    description = "Erforderlicher Fahndungsdruck im Labor, bevor Razzien & Raids ausgelöst werden kann.",
                },
                drugSabotageHeatThreshold = {
                    label = "Fahndungsschwelle für Sabotage",
                    description = "Erforderlicher Fahndungsdruck im Labor, bevor Sabotage ausgelöst werden kann.",
                },
                drugThreatHeatDecay = {
                    label = "Fahndungsdruck / Verfall",
                    description = "Verringert den Fahndungsdruck im Labor bei jeder Bedrohungsaktualisierung um diesen Wert.",
                },
                drugRaidChanceAtThreshold = {
                    label = "Razziawahrscheinlichkeit",
                    description = "Grundwahrscheinlichkeit für Überfall, sobald der zugehörige Fahndungsschwellenwert erreicht ist.",
                },
                drugSabotageChanceAtThreshold = {
                    label = "Sabotage / Chance",
                    description = "Grundwahrscheinlichkeit für Sabotage, sobald der zugehörige Fahndungsschwellenwert erreicht ist.",
                },
                drugConsumptionEnabled = {
                    label = "Konsum aktiviert",
                    description = "Aktiviert: Drogenwirkungen sowie die Erfassung von Toleranz und Abhängigkeit.",
                },
                drugDoseConsumesBatch = {
                    label = "Charge beim Konsum verbrauchen",
                    description = "Entfernt eine konsumierte Charge aus dem laufenden Bestand.",
                },
                drugToleranceDecayMinutes = {
                    label = "Toleranz / Verfall",
                    description = "Intervall in Minuten für Aktualisierung des Toleranzabbaus.",
                },
                drugAddictionDecayMinutes = {
                    label = "Abhängigkeit / Verfall",
                    description = "Intervall in Minuten für Aktualisierung des Abhängigkeitsabbaus.",
                },
                drugPotencyEffectMultiplier = {
                    label = "Wirkstärke / Multiplikator",
                    description = "Bestimmt, wie stark die Potenz die Intensität der Wirkung erhöht.",
                },
                drugOverdosePotencyThreshold = {
                    label = "Überdosis / Schwellenwert",
                    description = "Erforderliche Wirkstoffbelastung, bevor eine Überdosis ausgewürfelt werden kann.",
                },
                drugBaseAddictionGain = {
                    label = "Grundwert / Abhängigkeit / Zuwachs",
                    description = "Grundwert der Abhängigkeitszunahme pro Dosis.",
                },
                drugProcessingEnabled = {
                    label = "Verarbeitung / Aktiviert",
                    description = "Aktiviert: Verarbeitungsaufträge, Verpackung und Testsets.",
                },
                drugBatchMetadataItemKey = {
                    label = "Charge / Metadaten / Schlüssel",
                    description = "Metadaten-Schlüssel im Inventar, den Integrationen für Chargendaten verwenden.",
                },
                drugDefaultProcessDuration = {
                    label = "Standarddauer der Verarbeitung",
                    description = "Standardwert für Verarbeitung / Dauer / Sekunden / Ohne eigene Rezeptvorgabe.",
                },
                drugDefaultFailureRisk = {
                    label = "Standardwert / Fehlerrisiko",
                    description = "Standardwert für Verarbeitung / Fehlerrisiko / Ohne eigene Rezeptvorgabe.",
                },
                drugPackagingDuration = {
                    label = "Verpackungsdauer",
                    description = "Standardwert für Verpackung / Dauer / Sekunden.",
                },
                drugPowerTickSeconds = {
                    label = "Strom / Aktualisierungsschritt / Sekunden",
                    description = "Intervall in Sekunden für Aktualisierung von Generatorverbrauch und Stromsignaturen.",
                },
                drugPowerSignatureHeatPerHour = {
                    label = "Stromsignatur / Fahndungsdruck / Stunde",
                    description = "Fahndungsdruck pro Stunde durch den erkennbaren Stromverbrauch des Labors.",
                },
                drugPowerOverloadHeatPerHour = {
                    label = "Überlastung / Fahndungsdruck / Stunde",
                    description = "Zusätzlicher Fahndungsdruck pro Stunde bei überlastetem Labor.",
                },
                drugPowerIdleHeatDecayPerHour = {
                    label = "Leerlauf / Fahndungsdruck / Verfall / Stunde",
                    description = "Abbau des Fahndungsdrucks pro Stunde, solange das Labor keinen erkennbaren Stromverbrauch hat.",
                },
                drugPowerModeManualMaxLoadPercent = {
                    label = "Manuell / Maximum / Auslastung",
                    description = "Wert für den Energiemodus Manuell: Maximum / Auslastung.",
                },
                drugPowerModeManualHeatMultiplier = {
                    label = "Manuell / Fahndungsdruck / Multiplikator",
                    description = "Wert für den Energiemodus Manuell: Fahndungsdruck / Multiplikator.",
                },
                drugPowerModeManualNoiseMultiplier = {
                    label = "Manuell / Lärm / Multiplikator",
                    description = "Wert für den Energiemodus Manuell: Lärm / Multiplikator.",
                },
                drugPowerModeBalancedMaxLoadPercent = {
                    label = "Ausgeglichen / Maximum / Auslastung",
                    description = "Wert für den Energiemodus Ausgeglichen: Maximum / Auslastung.",
                },
                drugPowerModeBalancedHeatMultiplier = {
                    label = "Ausgeglichen / Fahndungsdruck / Multiplikator",
                    description = "Wert für den Energiemodus Ausgeglichen: Fahndungsdruck / Multiplikator.",
                },
                drugPowerModeBalancedNoiseMultiplier = {
                    label = "Ausgeglichen / Lärm / Multiplikator",
                    description = "Wert für den Energiemodus Ausgeglichen: Lärm / Multiplikator.",
                },
                drugPowerModeStealthMaxLoadPercent = {
                    label = "Unauffällig / Maximum / Auslastung",
                    description = "Wert für den Energiemodus Unauffällig: Maximum / Auslastung.",
                },
                drugPowerModeStealthHeatMultiplier = {
                    label = "Unauffällig / Fahndungsdruck / Multiplikator",
                    description = "Wert für den Energiemodus Unauffällig: Fahndungsdruck / Multiplikator.",
                },
                drugPowerModeStealthNoiseMultiplier = {
                    label = "Unauffällig / Lärm / Multiplikator",
                    description = "Wert für den Energiemodus Unauffällig: Lärm / Multiplikator.",
                },
                drugPowerPrioritySmellControl = {
                    label = "Geruchskontrolle / Priorität",
                    description = "Priorität beim automatischen Lastabwurf: Geruchskontrolle / Ausstattung.",
                },
                drugPowerPriorityAirflow = {
                    label = "Belüftung / Priorität",
                    description = "Priorität beim automatischen Lastabwurf: Belüftung / Ausstattung.",
                },
                drugPowerPrioritySecurity = {
                    label = "Sicherheit / Priorität",
                    description = "Priorität beim automatischen Lastabwurf: Sicherheitstechnik.",
                },
                drugPowerPriorityGrowing = {
                    label = "Anbau / Priorität",
                    description = "Priorität beim automatischen Lastabwurf: Anbau / Ausstattung.",
                },
                drugPowerPriorityLight = {
                    label = "Beleuchtung / Priorität",
                    description = "Priorität beim automatischen Lastabwurf: Beleuchtung / Ausstattung.",
                },
                drugPowerPriorityTesting = {
                    label = "Prüfung / Priorität",
                    description = "Priorität beim automatischen Lastabwurf: Prüfung / Ausstattung.",
                },
                drugPowerPriorityPackaging = {
                    label = "Verpackung / Priorität",
                    description = "Priorität beim automatischen Lastabwurf: Verpackung / Ausstattung.",
                },
                drugPowerPriorityChemistry = {
                    label = "Chemie / Priorität",
                    description = "Priorität beim automatischen Lastabwurf: Chemie / Ausstattung.",
                },
                drugPowerPriorityHeating = {
                    label = "Heizung / Priorität",
                    description = "Priorität beim automatischen Lastabwurf: Heizung / Ausstattung.",
                },
                drugPowerPriorityPressing = {
                    label = "Pressen / Priorität",
                    description = "Priorität beim automatischen Lastabwurf: Pressen / Ausstattung.",
                },
                drugPowerPriorityGeneral = {
                    label = "Allgemein / Priorität",
                    description = "Priorität beim automatischen Lastabwurf: Allgemeine Ausrüstung.",
                },
                drugAdvancedPerformanceInactiveControlIntervalMs = {
                    label = "Leistung / Inaktiv / Steuerung / Intervall / ms",
                    description = "Konfigurationswert für Leistung / Inaktiv / Steuerung / Intervall / ms.",
                },
                drugAdvancedPerformanceInteractionIdleScanIntervalMs = {
                    label = "Leistung / Interaktion / Leerlauf / Prüfintervall / ms",
                    description = "Konfigurationswert für Leistung / Interaktion / Leerlauf / Prüfintervall / ms.",
                },
                drugAdvancedPerformanceInteractionPromptIntervalMs = {
                    label = "Leistung / Interaktion / Interaktionshinweis / Intervall / ms",
                    description = "Konfigurationswert für Leistung / Interaktion / Interaktionshinweis / Intervall / ms.",
                },
                drugAdvancedPerformanceInteractionScanIntervalMs = {
                    label = "Leistung / Interaktion / Prüfintervall / ms",
                    description = "Konfigurationswert für Leistung / Interaktion / Prüfintervall / ms.",
                },
                drugAdvancedPerformanceMinimumScanIntervalMs = {
                    label = "Leistung / Minimum / Prüfintervall / ms",
                    description = "Konfigurationswert für Leistung / Minimum / Prüfintervall / ms.",
                },
                drugAdvancedPerformanceStreetPedActivationDistance = {
                    label = "Leistung / Straße / NPC / Aktivierung / Entfernung",
                    description = "Konfigurationswert für Leistung / Straße / NPC / Aktivierung / Entfernung.",
                },
                drugAdvancedPerformanceStreetPedIdleScanIntervalMs = {
                    label = "Leistung / Straße / NPC / Leerlauf / Prüfintervall / ms",
                    description = "Konfigurationswert für Leistung / Straße / NPC / Leerlauf / Prüfintervall / ms.",
                },
                drugAdvancedPerformanceStreetPedScanIntervalMs = {
                    label = "Leistung / Straße / NPC / Prüfintervall / ms",
                    description = "Konfigurationswert für Leistung / Straße / NPC / Prüfintervall / ms.",
                },
                drugAdvancedPerformanceWorldCachePadding = {
                    label = "Leistung / Welt / Zwischenspeicher / Zusatzabstand",
                    description = "Konfigurationswert für Leistung / Welt / Zwischenspeicher / Zusatzabstand.",
                },
                drugAdvancedPerformanceWorldCacheRefreshIntervalMs = {
                    label = "Leistung / Welt / Zwischenspeicher / Aktualisierung / Intervall / ms",
                    description = "Konfigurationswert für Leistung / Welt / Zwischenspeicher / Aktualisierung / Intervall / ms.",
                },
                drugAdvancedPerformanceWorldIdleIntervalMs = {
                    label = "Leistung / Welt / Leerlauf / Intervall / ms",
                    description = "Konfigurationswert für Leistung / Welt / Leerlauf / Intervall / ms.",
                },
                drugAdvancedDynamicMarketActionCooldownSeconds = {
                    label = "Dynamischer Markt / Aktions-Cooldown / Sekunden",
                    description = "Konfigurationswert für Dynamischer Markt / Aktions-Cooldown / Sekunden.",
                },
                drugAdvancedDynamicMarketActionHistoryLimit = {
                    label = "Dynamischer Markt / Aktion / Historienlimit",
                    description = "Konfigurationswert für Dynamischer Markt / Aktion / Historienlimit.",
                },
                drugAdvancedDynamicMarketAmountSaturationWeight = {
                    label = "Dynamischer Markt / Menge / Marktsättigung / Gewichtung",
                    description = "Konfigurationswert für Dynamischer Markt / Menge / Marktsättigung / Gewichtung.",
                },
                drugAdvancedDynamicMarketBaseIntelAccuracy = {
                    label = "Dynamischer Markt / Grundwert / Informationsgenauigkeit",
                    description = "Konfigurationswert für Dynamischer Markt / Grundwert / Informationsgenauigkeit.",
                },
                drugAdvancedDynamicMarketDefaultAverageQuality = {
                    label = "Dynamischer Markt / Standardwert / Durchschnitt / Qualität",
                    description = "Konfigurationswert für Dynamischer Markt / Standardwert / Durchschnitt / Qualität.",
                },
                drugAdvancedDynamicMarketDefaultResourceElasticity = {
                    label = "Dynamischer Markt / Standardwert / Rohstoff / Elastizität",
                    description = "Konfigurationswert für Dynamischer Markt / Standardwert / Rohstoff / Elastizität.",
                },
                drugAdvancedDynamicMarketDemandCenter = {
                    label = "Dynamischer Markt / Nachfrage / Mittelwert",
                    description = "Konfigurationswert für Dynamischer Markt / Nachfrage / Mittelwert.",
                },
                drugAdvancedDynamicMarketDemandPriceImpact = {
                    label = "Dynamischer Markt / Nachfrage / Preis / Einfluss",
                    description = "Konfigurationswert für Dynamischer Markt / Nachfrage / Preis / Einfluss.",
                },
                drugAdvancedDynamicMarketDirectionThreshold = {
                    label = "Dynamischer Markt / Richtung / Schwellenwert",
                    description = "Konfigurationswert für Dynamischer Markt / Richtung / Schwellenwert.",
                },
                drugAdvancedDynamicMarketEnabled = {
                    label = "Dynamischer Markt / Aktiviert",
                    description = "Konfigurationswert für Dynamischer Markt / Aktiviert.",
                },
                drugAdvancedDynamicMarketEventChance = {
                    label = "Dynamischer Markt / Ereignis / Chance",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignis / Chance.",
                },
                drugAdvancedDynamicMarketEventDurationMinutes = {
                    label = "Dynamischer Markt / Ereignis / Dauer / Minuten",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignis / Dauer / Minuten.",
                },
                drugAdvancedDynamicMarketEventMinimumDurationMinutes = {
                    label = "Dynamischer Markt / Ereignis / Minimum / Dauer / Minuten",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignis / Minimum / Dauer / Minuten.",
                },
                drugAdvancedDynamicMarketEventStrengthMaximum = {
                    label = "Dynamischer Markt / Ereignis / Stärke / Maximum",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignis / Stärke / Maximum.",
                },
                drugAdvancedDynamicMarketEventStrengthMinimum = {
                    label = "Dynamischer Markt / Ereignis / Stärke / Minimum",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignis / Stärke / Minimum.",
                },
                drugAdvancedDynamicMarketEventsCrackdownDemand = {
                    label = "Dynamischer Markt / Ereignisse / Polizeioffensive / Nachfrage",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Polizeioffensive / Nachfrage.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPolice = {
                    label = "Dynamischer Markt / Ereignisse / Polizeioffensive / Polizei",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Polizeioffensive / Polizei.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPrice = {
                    label = "Dynamischer Markt / Ereignisse / Polizeioffensive / Preis",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Polizeioffensive / Preis.",
                },
                drugAdvancedDynamicMarketEventsFestivalDemand = {
                    label = "Dynamischer Markt / Ereignisse / Festival / Nachfrage",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Festival / Nachfrage.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem1 = {
                    label = "Dynamischer Markt / Ereignisse / Festival / Wirkungen / 1",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Festival / Wirkungen / 1.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem2 = {
                    label = "Dynamischer Markt / Ereignisse / Festival / Wirkungen / 2",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Festival / Wirkungen / 2.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem3 = {
                    label = "Dynamischer Markt / Ereignisse / Festival / Wirkungen / 3",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Festival / Wirkungen / 3.",
                },
                drugAdvancedDynamicMarketEventsFestivalPrice = {
                    label = "Dynamischer Markt / Ereignisse / Festival / Preis",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Festival / Preis.",
                },
                drugAdvancedDynamicMarketEventsFestivalProfilesItem1 = {
                    label = "Dynamischer Markt / Ereignisse / Festival / Profile / 1",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Festival / Profile / 1.",
                },
                drugAdvancedDynamicMarketEventsGangconflictDemand = {
                    label = "Dynamischer Markt / Ereignisse / Gangkonflikt / Nachfrage",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Gangkonflikt / Nachfrage.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPolice = {
                    label = "Dynamischer Markt / Ereignisse / Gangkonflikt / Polizei",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Gangkonflikt / Polizei.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPrice = {
                    label = "Dynamischer Markt / Ereignisse / Gangkonflikt / Preis",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Gangkonflikt / Preis.",
                },
                drugAdvancedDynamicMarketEventsGangconflictProfilesItem1 = {
                    label = "Dynamischer Markt / Ereignisse / Gangkonflikt / Profile / 1",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Gangkonflikt / Profile / 1.",
                },
                drugAdvancedDynamicMarketEventsLabbustDemand = {
                    label = "Dynamischer Markt / Ereignisse / Laborrazzia / Nachfrage",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Laborrazzia / Nachfrage.",
                },
                drugAdvancedDynamicMarketEventsLabbustPolice = {
                    label = "Dynamischer Markt / Ereignisse / Laborrazzia / Polizei",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Laborrazzia / Polizei.",
                },
                drugAdvancedDynamicMarketEventsLabbustPrice = {
                    label = "Dynamischer Markt / Ereignisse / Laborrazzia / Preis",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Laborrazzia / Preis.",
                },
                drugAdvancedDynamicMarketEventsLabbustSupply = {
                    label = "Dynamischer Markt / Ereignisse / Laborrazzia / Versorgung",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Laborrazzia / Versorgung.",
                },
                drugAdvancedDynamicMarketEventsPartyDemand = {
                    label = "Dynamischer Markt / Ereignisse / Party / Nachfrage",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Party / Nachfrage.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem1 = {
                    label = "Dynamischer Markt / Ereignisse / Party / Wirkungen / 1",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Party / Wirkungen / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem2 = {
                    label = "Dynamischer Markt / Ereignisse / Party / Wirkungen / 2",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Party / Wirkungen / 2.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem3 = {
                    label = "Dynamischer Markt / Ereignisse / Party / Wirkungen / 3",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Party / Wirkungen / 3.",
                },
                drugAdvancedDynamicMarketEventsPartyPrice = {
                    label = "Dynamischer Markt / Ereignisse / Party / Preis",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Party / Preis.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem1 = {
                    label = "Dynamischer Markt / Ereignisse / Party / Profile / 1",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Party / Profile / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem2 = {
                    label = "Dynamischer Markt / Ereignisse / Party / Profile / 2",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Party / Profile / 2.",
                },
                drugAdvancedDynamicMarketEventsShortageDemand = {
                    label = "Dynamischer Markt / Ereignisse / Engpass / Nachfrage",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Engpass / Nachfrage.",
                },
                drugAdvancedDynamicMarketEventsShortagePrice = {
                    label = "Dynamischer Markt / Ereignisse / Engpass / Preis",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Engpass / Preis.",
                },
                drugAdvancedDynamicMarketEventsShortageSupply = {
                    label = "Dynamischer Markt / Ereignisse / Engpass / Versorgung",
                    description = "Konfigurationswert für Dynamischer Markt / Ereignisse / Engpass / Versorgung.",
                },
                drugAdvancedDynamicMarketExactIntelReputation = {
                    label = "Dynamischer Markt / Genaue Informationen / Ruf",
                    description = "Konfigurationswert für Dynamischer Markt / Genaue Informationen / Ruf.",
                },
                drugAdvancedDynamicMarketExactIntelTrust = {
                    label = "Dynamischer Markt / Genaue Informationen / Vertrauen",
                    description = "Konfigurationswert für Dynamischer Markt / Genaue Informationen / Vertrauen.",
                },
                drugAdvancedDynamicMarketGlobalZoneLabel = {
                    label = "Dynamischer Markt / Global / Zone / Bezeichnung",
                    description = "Konfigurationswert für Dynamischer Markt / Global / Zone / Bezeichnung.",
                },
                drugAdvancedDynamicMarketHistoryLimit = {
                    label = "Dynamischer Markt / Historienlimit",
                    description = "Konfigurationswert für Dynamischer Markt / Historienlimit.",
                },
                drugAdvancedDynamicMarketInitialDemand = {
                    label = "Dynamischer Markt / Anfangswert / Nachfrage",
                    description = "Konfigurationswert für Dynamischer Markt / Anfangswert / Nachfrage.",
                },
                drugAdvancedDynamicMarketInitialPriceMultiplier = {
                    label = "Dynamischer Markt / Anfangswert / Preismultiplikator",
                    description = "Konfigurationswert für Dynamischer Markt / Anfangswert / Preismultiplikator.",
                },
                drugAdvancedDynamicMarketIntelDemandError = {
                    label = "Dynamischer Markt / Informationen / Nachfrage / Fehler",
                    description = "Konfigurationswert für Dynamischer Markt / Informationen / Nachfrage / Fehler.",
                },
                drugAdvancedDynamicMarketIntelMaximumAccuracy = {
                    label = "Dynamischer Markt / Informationen / Maximum / Genauigkeit",
                    description = "Konfigurationswert für Dynamischer Markt / Informationen / Maximum / Genauigkeit.",
                },
                drugAdvancedDynamicMarketIntelMinimumAccuracy = {
                    label = "Dynamischer Markt / Informationen / Minimum / Genauigkeit",
                    description = "Konfigurationswert für Dynamischer Markt / Informationen / Minimum / Genauigkeit.",
                },
                drugAdvancedDynamicMarketIntelPoliceError = {
                    label = "Dynamischer Markt / Informationen / Polizei / Fehler",
                    description = "Konfigurationswert für Dynamischer Markt / Informationen / Polizei / Fehler.",
                },
                drugAdvancedDynamicMarketIntelPriceError = {
                    label = "Dynamischer Markt / Informationen / Preis / Fehler",
                    description = "Konfigurationswert für Dynamischer Markt / Informationen / Preis / Fehler.",
                },
                drugAdvancedDynamicMarketIntelPriceMaximum = {
                    label = "Dynamischer Markt / Informationen / Preis / Maximum",
                    description = "Konfigurationswert für Dynamischer Markt / Informationen / Preis / Maximum.",
                },
                drugAdvancedDynamicMarketIntelPriceMinimum = {
                    label = "Dynamischer Markt / Informationen / Preis / Minimum",
                    description = "Konfigurationswert für Dynamischer Markt / Informationen / Preis / Minimum.",
                },
                drugAdvancedDynamicMarketIntelReputationWeight = {
                    label = "Dynamischer Markt / Informationen / Ruf / Gewichtung",
                    description = "Konfigurationswert für Dynamischer Markt / Informationen / Ruf / Gewichtung.",
                },
                drugAdvancedDynamicMarketIntelResourcePriceError = {
                    label = "Dynamischer Markt / Informationen / Rohstoff / Preis / Fehler",
                    description = "Konfigurationswert für Dynamischer Markt / Informationen / Rohstoff / Preis / Fehler.",
                },
                drugAdvancedDynamicMarketIntelSaturationError = {
                    label = "Dynamischer Markt / Informationen / Marktsättigung / Fehler",
                    description = "Konfigurationswert für Dynamischer Markt / Informationen / Marktsättigung / Fehler.",
                },
                drugAdvancedDynamicMarketIntelSeedBucketSeconds = {
                    label = "Dynamischer Markt / Zeitfenster für den Informations-Zufallswert / Sekunden",
                    description = "Konfigurationswert für Dynamischer Markt / Zeitfenster für den Informations-Zufallswert / Sekunden.",
                },
                drugAdvancedDynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Dynamischer Markt / Informationen / Status / Genauigkeit / Schwellenwert",
                    description = "Konfigurationswert für Dynamischer Markt / Informationen / Status / Genauigkeit / Schwellenwert.",
                },
                drugAdvancedDynamicMarketIntelStatusErrorThreshold = {
                    label = "Dynamischer Markt / Informationen / Status / Fehler / Schwellenwert",
                    description = "Konfigurationswert für Dynamischer Markt / Informationen / Status / Fehler / Schwellenwert.",
                },
                drugAdvancedDynamicMarketIntelSupplyError = {
                    label = "Dynamischer Markt / Informationen / Versorgung / Fehler",
                    description = "Konfigurationswert für Dynamischer Markt / Informationen / Versorgung / Fehler.",
                },
                drugAdvancedDynamicMarketIntelTrustWeight = {
                    label = "Dynamischer Markt / Informationen / Vertrauen / Gewichtung",
                    description = "Konfigurationswert für Dynamischer Markt / Informationen / Vertrauen / Gewichtung.",
                },
                drugAdvancedDynamicMarketManipulationCooldownMinutes = {
                    label = "Dynamischer Markt / Manipulation / Cooldown-Minuten",
                    description = "Konfigurationswert für Dynamischer Markt / Manipulation / Cooldown-Minuten.",
                },
                drugAdvancedDynamicMarketManipulationDemandShift = {
                    label = "Dynamischer Markt / Manipulation / Nachfrage / Verschiebung",
                    description = "Konfigurationswert für Dynamischer Markt / Manipulation / Nachfrage / Verschiebung.",
                },
                drugAdvancedDynamicMarketManipulationDurationMinutes = {
                    label = "Dynamischer Markt / Manipulation / Dauer / Minuten",
                    description = "Konfigurationswert für Dynamischer Markt / Manipulation / Dauer / Minuten.",
                },
                drugAdvancedDynamicMarketManipulationHeat = {
                    label = "Dynamischer Markt / Manipulation / Fahndungsdruck",
                    description = "Konfigurationswert für Dynamischer Markt / Manipulation / Fahndungsdruck.",
                },
                drugAdvancedDynamicMarketManipulationMinimumBatchAmount = {
                    label = "Dynamischer Markt / Manipulation / Minimum / Charge / Menge",
                    description = "Konfigurationswert für Dynamischer Markt / Manipulation / Minimum / Charge / Menge.",
                },
                drugAdvancedDynamicMarketManipulationPaymentAccount = {
                    label = "Dynamischer Markt / Manipulation / Zahlungskonto",
                    description = "Konfigurationswert für Dynamischer Markt / Manipulation / Zahlungskonto.",
                },
                drugAdvancedDynamicMarketManipulationPrice = {
                    label = "Dynamischer Markt / Manipulation / Preis",
                    description = "Konfigurationswert für Dynamischer Markt / Manipulation / Preis.",
                },
                drugAdvancedDynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Dynamischer Markt / Manipulation / Zone / Fahndungsdruck / Multiplikator",
                    description = "Konfigurationswert für Dynamischer Markt / Manipulation / Zone / Fahndungsdruck / Multiplikator.",
                },
                drugAdvancedDynamicMarketMaximumIntelAgeMinutes = {
                    label = "Dynamischer Markt / Maximum / Informationsalter / Minuten",
                    description = "Konfigurationswert für Dynamischer Markt / Maximum / Informationsalter / Minuten.",
                },
                drugAdvancedDynamicMarketMaximumPriceMultiplier = {
                    label = "Dynamischer Markt / Maximum / Preismultiplikator",
                    description = "Konfigurationswert für Dynamischer Markt / Maximum / Preismultiplikator.",
                },
                drugAdvancedDynamicMarketMinimumIntelAgeMinutes = {
                    label = "Dynamischer Markt / Minimum / Informationsalter / Minuten",
                    description = "Konfigurationswert für Dynamischer Markt / Minimum / Informationsalter / Minuten.",
                },
                drugAdvancedDynamicMarketMinimumMetricWindowMinutes = {
                    label = "Dynamischer Markt / Minimum / Messwert / Zeitfenster / Minuten",
                    description = "Konfigurationswert für Dynamischer Markt / Minimum / Messwert / Zeitfenster / Minuten.",
                },
                drugAdvancedDynamicMarketMinimumPriceMultiplier = {
                    label = "Dynamischer Markt / Mindestpreis / Multiplikator",
                    description = "Konfigurationswert für Dynamischer Markt / Mindestpreis / Multiplikator.",
                },
                drugAdvancedDynamicMarketMinimumUpdateMinutes = {
                    label = "Dynamischer Markt / Minimum / Aktualisierung / Minuten",
                    description = "Konfigurationswert für Dynamischer Markt / Minimum / Aktualisierung / Minuten.",
                },
                drugAdvancedDynamicMarketPoliceDemandWeight = {
                    label = "Dynamischer Markt / Polizei / Nachfrage / Gewichtung",
                    description = "Konfigurationswert für Dynamischer Markt / Polizei / Nachfrage / Gewichtung.",
                },
                drugAdvancedDynamicMarketPolicePriceImpact = {
                    label = "Dynamischer Markt / Polizei / Preis / Einfluss",
                    description = "Konfigurationswert für Dynamischer Markt / Polizei / Preis / Einfluss.",
                },
                drugAdvancedDynamicMarketPoorQualityDemandPenalty = {
                    label = "Dynamischer Markt / Schlechte Qualität / Nachfrage / Abzug",
                    description = "Konfigurationswert für Dynamischer Markt / Schlechte Qualität / Nachfrage / Abzug.",
                },
                drugAdvancedDynamicMarketPoorQualityThreshold = {
                    label = "Dynamischer Markt / Schlechte Qualität / Schwellenwert",
                    description = "Konfigurationswert für Dynamischer Markt / Schlechte Qualität / Schwellenwert.",
                },
                drugAdvancedDynamicMarketPremiumQualityDemandBonus = {
                    label = "Dynamischer Markt / Premiumqualität / Nachfragebonus",
                    description = "Konfigurationswert für Dynamischer Markt / Premiumqualität / Nachfragebonus.",
                },
                drugAdvancedDynamicMarketPremiumQualityThreshold = {
                    label = "Dynamischer Markt / Premiumqualität / Schwellenwert",
                    description = "Konfigurationswert für Dynamischer Markt / Premiumqualität / Schwellenwert.",
                },
                drugAdvancedDynamicMarketProductionSupplyWeight = {
                    label = "Dynamischer Markt / Produktion / Versorgung / Gewichtung",
                    description = "Konfigurationswert für Dynamischer Markt / Produktion / Versorgung / Gewichtung.",
                },
                drugAdvancedDynamicMarketProductionWindowMinutes = {
                    label = "Dynamischer Markt / Produktion / Zeitfenster / Minuten",
                    description = "Konfigurationswert für Dynamischer Markt / Produktion / Zeitfenster / Minuten.",
                },
                drugAdvancedDynamicMarketQualityCenter = {
                    label = "Dynamischer Markt / Qualität / Mittelwert",
                    description = "Konfigurationswert für Dynamischer Markt / Qualität / Mittelwert.",
                },
                drugAdvancedDynamicMarketQualityConfidenceImpact = {
                    label = "Dynamischer Markt / Qualität / Verlässlichkeit / Einfluss",
                    description = "Konfigurationswert für Dynamischer Markt / Qualität / Verlässlichkeit / Einfluss.",
                },
                drugAdvancedDynamicMarketQualityRange = {
                    label = "Dynamischer Markt / Qualität / Wertebereich",
                    description = "Konfigurationswert für Dynamischer Markt / Qualität / Wertebereich.",
                },
                drugAdvancedDynamicMarketRarityBonusMaximum = {
                    label = "Dynamischer Markt / Seltenheit / Bonus / Maximum",
                    description = "Konfigurationswert für Dynamischer Markt / Seltenheit / Bonus / Maximum.",
                },
                drugAdvancedDynamicMarketRegionalGlobalWeight = {
                    label = "Dynamischer Markt / Regional / Global / Gewichtung",
                    description = "Konfigurationswert für Dynamischer Markt / Regional / Global / Gewichtung.",
                },
                drugAdvancedDynamicMarketRegionalLocalWeight = {
                    label = "Dynamischer Markt / Regional / Lokal / Gewichtung",
                    description = "Konfigurationswert für Dynamischer Markt / Regional / Lokal / Gewichtung.",
                },
                drugAdvancedDynamicMarketResourceAliasesDrugpackaging = {
                    label = "Dynamischer Markt / Rohstoff / Alternative Bezeichnungen / Droge / Verpackung",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoff / Alternative Bezeichnungen / Droge / Verpackung.",
                },
                drugAdvancedDynamicMarketResourceAliasesFuelcan = {
                    label = "Dynamischer Markt / Rohstoff / Alternative Bezeichnungen / Benzinkanister",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoff / Alternative Bezeichnungen / Benzinkanister.",
                },
                drugAdvancedDynamicMarketResourceAliasesMachineoil = {
                    label = "Dynamischer Markt / Rohstoff / Alternative Bezeichnungen / Maschinenöl",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoff / Alternative Bezeichnungen / Maschinenöl.",
                },
                drugAdvancedDynamicMarketResourceAliasesPlantnutrients = {
                    label = "Dynamischer Markt / Rohstoff / Alternative Bezeichnungen / Pflanzennährstoffe",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoff / Alternative Bezeichnungen / Pflanzennährstoffe.",
                },
                drugAdvancedDynamicMarketResourceAliasesRepairkit = {
                    label = "Dynamischer Markt / Rohstoff / Alternative Bezeichnungen / Reparaturset",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoff / Alternative Bezeichnungen / Reparaturset.",
                },
                drugAdvancedDynamicMarketResourceDirectionFallThreshold = {
                    label = "Dynamischer Markt / Rohstoff / Richtung / Rückgang / Schwellenwert",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoff / Richtung / Rückgang / Schwellenwert.",
                },
                drugAdvancedDynamicMarketResourceDirectionRiseThreshold = {
                    label = "Dynamischer Markt / Rohstoff / Richtung / Anstieg / Schwellenwert",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoff / Richtung / Anstieg / Schwellenwert.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterBasePrice = {
                    label = "Dynamischer Markt / Rohstoffe / Aktivkohlefilter / Grundpreis",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Aktivkohlefilter / Grundpreis.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterElasticity = {
                    label = "Dynamischer Markt / Rohstoffe / Aktivkohlefilter / Elastizität",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Aktivkohlefilter / Elastizität.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLabel = {
                    label = "Dynamischer Markt / Rohstoffe / Aktivkohlefilter / Bezeichnung",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Aktivkohlefilter / Bezeichnung.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem1 = {
                    label = "Dynamischer Markt / Rohstoffe / Aktivkohlefilter / Verknüpfte Drogen / 1",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Aktivkohlefilter / Verknüpfte Drogen / 1.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem2 = {
                    label = "Dynamischer Markt / Rohstoffe / Aktivkohlefilter / Verknüpfte Drogen / 2",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Aktivkohlefilter / Verknüpfte Drogen / 2.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem3 = {
                    label = "Dynamischer Markt / Rohstoffe / Aktivkohlefilter / Verknüpfte Drogen / 3",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Aktivkohlefilter / Verknüpfte Drogen / 3.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorBasePrice = {
                    label = "Dynamischer Markt / Rohstoffe / Chemischer Ausgangsstoff / Grundpreis",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Chemischer Ausgangsstoff / Grundpreis.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorElasticity = {
                    label = "Dynamischer Markt / Rohstoffe / Chemischer Ausgangsstoff / Elastizität",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Chemischer Ausgangsstoff / Elastizität.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLabel = {
                    label = "Dynamischer Markt / Rohstoffe / Chemischer Ausgangsstoff / Bezeichnung",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Chemischer Ausgangsstoff / Bezeichnung.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem1 = {
                    label = "Dynamischer Markt / Rohstoffe / Chemischer Ausgangsstoff / Verknüpfte Drogen / 1",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Chemischer Ausgangsstoff / Verknüpfte Drogen / 1.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem2 = {
                    label = "Dynamischer Markt / Rohstoffe / Chemischer Ausgangsstoff / Verknüpfte Drogen / 2",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Chemischer Ausgangsstoff / Verknüpfte Drogen / 2.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsBasePrice = {
                    label = "Dynamischer Markt / Rohstoffe / Geräteteile / Grundpreis",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Geräteteile / Grundpreis.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsElasticity = {
                    label = "Dynamischer Markt / Rohstoffe / Geräteteile / Elastizität",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Geräteteile / Elastizität.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsLabel = {
                    label = "Dynamischer Markt / Rohstoffe / Geräteteile / Bezeichnung",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Geräteteile / Bezeichnung.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerBasePrice = {
                    label = "Dynamischer Markt / Rohstoffe / Dünger / Grundpreis",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Dünger / Grundpreis.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerElasticity = {
                    label = "Dynamischer Markt / Rohstoffe / Dünger / Elastizität",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Dünger / Elastizität.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLabel = {
                    label = "Dynamischer Markt / Rohstoffe / Dünger / Bezeichnung",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Dünger / Bezeichnung.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLinkedDrugsItem1 = {
                    label = "Dynamischer Markt / Rohstoffe / Dünger / Verknüpfte Drogen / 1",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Dünger / Verknüpfte Drogen / 1.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelBasePrice = {
                    label = "Dynamischer Markt / Rohstoffe / Laborkraftstoff / Grundpreis",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Laborkraftstoff / Grundpreis.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelElasticity = {
                    label = "Dynamischer Markt / Rohstoffe / Laborkraftstoff / Elastizität",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Laborkraftstoff / Elastizität.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelLabel = {
                    label = "Dynamischer Markt / Rohstoffe / Laborkraftstoff / Bezeichnung",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Laborkraftstoff / Bezeichnung.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagBasePrice = {
                    label = "Dynamischer Markt / Rohstoffe / Verpackungsbeutel / Grundpreis",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Verpackungsbeutel / Grundpreis.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagElasticity = {
                    label = "Dynamischer Markt / Rohstoffe / Verpackungsbeutel / Elastizität",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Verpackungsbeutel / Elastizität.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagLabel = {
                    label = "Dynamischer Markt / Rohstoffe / Verpackungsbeutel / Bezeichnung",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Verpackungsbeutel / Bezeichnung.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotBasePrice = {
                    label = "Dynamischer Markt / Rohstoffe / Pflanzentopf / Grundpreis",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Pflanzentopf / Grundpreis.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotElasticity = {
                    label = "Dynamischer Markt / Rohstoffe / Pflanzentopf / Elastizität",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Pflanzentopf / Elastizität.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLabel = {
                    label = "Dynamischer Markt / Rohstoffe / Pflanzentopf / Bezeichnung",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Pflanzentopf / Bezeichnung.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLinkedDrugsItem1 = {
                    label = "Dynamischer Markt / Rohstoffe / Pflanzentopf / Verknüpfte Drogen / 1",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Pflanzentopf / Verknüpfte Drogen / 1.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedBasePrice = {
                    label = "Dynamischer Markt / Rohstoffe / Cannabissamen / Grundpreis",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Cannabissamen / Grundpreis.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedElasticity = {
                    label = "Dynamischer Markt / Rohstoffe / Cannabissamen / Elastizität",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Cannabissamen / Elastizität.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLabel = {
                    label = "Dynamischer Markt / Rohstoffe / Cannabissamen / Bezeichnung",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Cannabissamen / Bezeichnung.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLinkedDrugsItem1 = {
                    label = "Dynamischer Markt / Rohstoffe / Cannabissamen / Verknüpfte Drogen / 1",
                    description = "Konfigurationswert für Dynamischer Markt / Rohstoffe / Cannabissamen / Verknüpfte Drogen / 1.",
                },
                drugAdvancedDynamicMarketSalesWindowMinutes = {
                    label = "Dynamischer Markt / Verkäufe / Zeitfenster / Minuten",
                    description = "Konfigurationswert für Dynamischer Markt / Verkäufe / Zeitfenster / Minuten.",
                },
                drugAdvancedDynamicMarketSaturationDemandWeight = {
                    label = "Dynamischer Markt / Marktsättigung / Nachfrage / Gewichtung",
                    description = "Konfigurationswert für Dynamischer Markt / Marktsättigung / Nachfrage / Gewichtung.",
                },
                drugAdvancedDynamicMarketSaturationPriceImpact = {
                    label = "Dynamischer Markt / Marktsättigung / Preis / Einfluss",
                    description = "Konfigurationswert für Dynamischer Markt / Marktsättigung / Preis / Einfluss.",
                },
                drugAdvancedDynamicMarketScarcityDemandWeight = {
                    label = "Dynamischer Markt / Knappheit / Nachfrage / Gewichtung",
                    description = "Konfigurationswert für Dynamischer Markt / Knappheit / Nachfrage / Gewichtung.",
                },
                drugAdvancedDynamicMarketScarcityPriceImpact = {
                    label = "Dynamischer Markt / Knappheit / Preis / Einfluss",
                    description = "Konfigurationswert für Dynamischer Markt / Knappheit / Preis / Einfluss.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsDecember = {
                    label = "Dynamischer Markt / Jahreszeit / Ende / Monate / Dezember",
                    description = "Konfigurationswert für Dynamischer Markt / Jahreszeit / Ende / Monate / Dezember.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSpring = {
                    label = "Dynamischer Markt / Jahreszeit / Ende / Monate / Frühling",
                    description = "Konfigurationswert für Dynamischer Markt / Jahreszeit / Ende / Monate / Frühling.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSummer = {
                    label = "Dynamischer Markt / Jahreszeit / Ende / Monate / Sommer",
                    description = "Konfigurationswert für Dynamischer Markt / Jahreszeit / Ende / Monate / Sommer.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsWinter = {
                    label = "Dynamischer Markt / Jahreszeit / Ende / Monate / Winter",
                    description = "Konfigurationswert für Dynamischer Markt / Jahreszeit / Ende / Monate / Winter.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersAutumn = {
                    label = "Dynamischer Markt / Jahreszeit / Multiplikatoren / Herbst",
                    description = "Konfigurationswert für Dynamischer Markt / Jahreszeit / Multiplikatoren / Herbst.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSpring = {
                    label = "Dynamischer Markt / Jahreszeit / Multiplikatoren / Frühling",
                    description = "Konfigurationswert für Dynamischer Markt / Jahreszeit / Multiplikatoren / Frühling.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSummer = {
                    label = "Dynamischer Markt / Jahreszeit / Multiplikatoren / Sommer",
                    description = "Konfigurationswert für Dynamischer Markt / Jahreszeit / Multiplikatoren / Sommer.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersWinter = {
                    label = "Dynamischer Markt / Jahreszeit / Multiplikatoren / Winter",
                    description = "Konfigurationswert für Dynamischer Markt / Jahreszeit / Multiplikatoren / Winter.",
                },
                drugAdvancedDynamicMarketShortageRumorThreshold = {
                    label = "Dynamischer Markt / Engpass / Gerücht / Schwellenwert",
                    description = "Konfigurationswert für Dynamischer Markt / Engpass / Gerücht / Schwellenwert.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHighDemand = {
                    label = "Dynamischer Markt / Status / Schwellenwerte / Hohe Nachfrage",
                    description = "Konfigurationswert für Dynamischer Markt / Status / Schwellenwerte / Hohe Nachfrage.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHot = {
                    label = "Dynamischer Markt / Status / Schwellenwerte / Gesucht",
                    description = "Konfigurationswert für Dynamischer Markt / Status / Schwellenwerte / Gesucht.",
                },
                drugAdvancedDynamicMarketStatusThresholdsLowDemand = {
                    label = "Dynamischer Markt / Status / Schwellenwerte / Geringe Nachfrage",
                    description = "Konfigurationswert für Dynamischer Markt / Status / Schwellenwerte / Geringe Nachfrage.",
                },
                drugAdvancedDynamicMarketStatusThresholdsSaturated = {
                    label = "Dynamischer Markt / Status / Schwellenwerte / Gesättigt",
                    description = "Konfigurationswert für Dynamischer Markt / Status / Schwellenwerte / Gesättigt.",
                },
                drugAdvancedDynamicMarketTargetSupply = {
                    label = "Dynamischer Markt / Ziel / Versorgung",
                    description = "Konfigurationswert für Dynamischer Markt / Ziel / Versorgung.",
                },
                drugAdvancedDynamicMarketTrendChance = {
                    label = "Dynamischer Markt / Trend / Chance",
                    description = "Konfigurationswert für Dynamischer Markt / Trend / Chance.",
                },
                drugAdvancedDynamicMarketTrendDurationMinutes = {
                    label = "Dynamischer Markt / Trend / Dauer / Minuten",
                    description = "Konfigurationswert für Dynamischer Markt / Trend / Dauer / Minuten.",
                },
                drugAdvancedDynamicMarketTrendMaximumStrength = {
                    label = "Dynamischer Markt / Trend / Maximum / Stärke",
                    description = "Konfigurationswert für Dynamischer Markt / Trend / Maximum / Stärke.",
                },
                drugAdvancedDynamicMarketTrendMinimumStrength = {
                    label = "Dynamischer Markt / Trend / Minimum / Stärke",
                    description = "Konfigurationswert für Dynamischer Markt / Trend / Minimum / Stärke.",
                },
                drugAdvancedDynamicMarketUpdateMinutes = {
                    label = "Dynamischer Markt / Aktualisierung / Minuten",
                    description = "Konfigurationswert für Dynamischer Markt / Aktualisierung / Minuten.",
                },
                drugAdvancedDynamicMarketVolatilityMaximum = {
                    label = "Dynamischer Markt / Preisschwankung / Maximum",
                    description = "Konfigurationswert für Dynamischer Markt / Preisschwankung / Maximum.",
                },
                drugAdvancedDynamicMarketVolatilityMinimum = {
                    label = "Dynamischer Markt / Preisschwankung / Minimum",
                    description = "Konfigurationswert für Dynamischer Markt / Preisschwankung / Minimum.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersCold = {
                    label = "Dynamischer Markt / Wetter / Multiplikatoren / Kälte",
                    description = "Konfigurationswert für Dynamischer Markt / Wetter / Multiplikatoren / Kälte.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersHeatwave = {
                    label = "Dynamischer Markt / Wetter / Multiplikatoren / Hitzewelle",
                    description = "Konfigurationswert für Dynamischer Markt / Wetter / Multiplikatoren / Hitzewelle.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersNormal = {
                    label = "Dynamischer Markt / Wetter / Multiplikatoren / Normal",
                    description = "Konfigurationswert für Dynamischer Markt / Wetter / Multiplikatoren / Normal.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersRain = {
                    label = "Dynamischer Markt / Wetter / Multiplikatoren / Regen",
                    description = "Konfigurationswert für Dynamischer Markt / Wetter / Multiplikatoren / Regen.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersStorm = {
                    label = "Dynamischer Markt / Wetter / Multiplikatoren / Sturm",
                    description = "Konfigurationswert für Dynamischer Markt / Wetter / Multiplikatoren / Sturm.",
                },
                drugAdvancedDynamicMarketWeatherState = {
                    label = "Dynamischer Markt / Wetter / Status",
                    description = "Konfigurationswert für Dynamischer Markt / Wetter / Status.",
                },
                drugAdvancedHeatActionCooldownSeconds = {
                    label = "Fahndungsdruck & Risiko / Aktions-Cooldown / Sekunden",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Aktions-Cooldown / Sekunden.",
                },
                drugAdvancedHeatActivityRiskWeightsAmount = {
                    label = "Fahndungsdruck & Risiko / Aktivität / Risiko / Gewichtungen / Menge",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Aktivität / Risiko / Gewichtungen / Menge.",
                },
                drugAdvancedHeatActivityRiskWeightsDurationMinutes = {
                    label = "Fahndungsdruck & Risiko / Aktivität / Risiko / Gewichtungen / Dauer / Minuten",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Aktivität / Risiko / Gewichtungen / Dauer / Minuten.",
                },
                drugAdvancedHeatActivityRiskWeightsPolicePressure = {
                    label = "Fahndungsdruck & Risiko / Aktivität / Risiko / Gewichtungen / Polizeidruck",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Aktivität / Risiko / Gewichtungen / Polizeidruck.",
                },
                drugAdvancedHeatActivityRiskWeightsReputation = {
                    label = "Fahndungsdruck & Risiko / Aktivität / Risiko / Gewichtungen / Ruf",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Aktivität / Risiko / Gewichtungen / Ruf.",
                },
                drugAdvancedHeatActivityRiskWeightsSecurity = {
                    label = "Fahndungsdruck & Risiko / Aktivität / Risiko / Gewichtungen / Sicherheit",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Aktivität / Risiko / Gewichtungen / Sicherheit.",
                },
                drugAdvancedHeatAggressiveHeatMultiplier = {
                    label = "Fahndungsdruck & Risiko / Aggressive Arbeitsweise / Fahndungsdruck / Multiplikator",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Aggressive Arbeitsweise / Fahndungsdruck / Multiplikator.",
                },
                drugAdvancedHeatBurnerBurnThreshold = {
                    label = "Fahndungsdruck & Risiko / Wegwerftelefon / Enttarnung / Schwellenwert",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Wegwerftelefon / Enttarnung / Schwellenwert.",
                },
                drugAdvancedHeatBurnerHeatPerWholesale = {
                    label = "Fahndungsdruck & Risiko / Wegwerftelefon / Fahndungsdruck / Je Großhandelsgeschäft",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Wegwerftelefon / Fahndungsdruck / Je Großhandelsgeschäft.",
                },
                drugAdvancedHeatBurnerPhoneItem = {
                    label = "Fahndungsdruck & Risiko / Wegwerfhandy / Gegenstand",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Wegwerfhandy / Gegenstand.",
                },
                drugAdvancedHeatCamperOperationalHeatMultiplier = {
                    label = "Fahndungsdruck & Risiko / Wohnmobil im Betrieb / Fahndungsdruck / Multiplikator",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Wohnmobil im Betrieb / Fahndungsdruck / Multiplikator.",
                },
                drugAdvancedHeatCamperOperationalHeatThreshold = {
                    label = "Fahndungsdruck & Risiko / Wohnmobil im Betrieb / Fahndungsdruck / Schwellenwert",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Wohnmobil im Betrieb / Fahndungsdruck / Schwellenwert.",
                },
                drugAdvancedHeatCamperParkedHeat = {
                    label = "Fahndungsdruck & Risiko / Geparktes Wohnmobil / Fahndungsdruck",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Geparktes Wohnmobil / Fahndungsdruck.",
                },
                drugAdvancedHeatContaminatedHeatMultiplier = {
                    label = "Fahndungsdruck & Risiko / Verunreinigung / Fahndungsdruck / Multiplikator",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verunreinigung / Fahndungsdruck / Multiplikator.",
                },
                drugAdvancedHeatContaminatedThreshold = {
                    label = "Fahndungsdruck & Risiko / Verunreinigung / Schwellenwert",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verunreinigung / Schwellenwert.",
                },
                drugAdvancedHeatCultivationFreePlants = {
                    label = "Fahndungsdruck & Risiko / Anbau / Pflanzen ohne Risikozuschlag",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Anbau / Pflanzen ohne Risikozuschlag.",
                },
                drugAdvancedHeatCultivationHeatPerPlant = {
                    label = "Fahndungsdruck & Risiko / Anbau / Fahndungsdruck / Je Pflanze",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Anbau / Fahndungsdruck / Je Pflanze.",
                },
                drugAdvancedHeatDealerHiddenMinutes = {
                    label = "Fahndungsdruck & Risiko / Dealer / versteckt / Minuten",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Dealer / versteckt / Minuten.",
                },
                drugAdvancedHeatDecayPerTickBatch = {
                    label = "Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Charge",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Charge.",
                },
                drugAdvancedHeatDecayPerTickCamper = {
                    label = "Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Wohnmobil",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Wohnmobil.",
                },
                drugAdvancedHeatDecayPerTickDealer = {
                    label = "Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Dealer",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Dealer.",
                },
                drugAdvancedHeatDecayPerTickFaction = {
                    label = "Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Fraktion",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Fraktion.",
                },
                drugAdvancedHeatDecayPerTickHub = {
                    label = "Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Verteilzentrum",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Verteilzentrum.",
                },
                drugAdvancedHeatDecayPerTickLab = {
                    label = "Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Labor",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Labor.",
                },
                drugAdvancedHeatDecayPerTickPlayer = {
                    label = "Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Spieler",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Spieler.",
                },
                drugAdvancedHeatDecayPerTickRoute = {
                    label = "Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Route",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Route.",
                },
                drugAdvancedHeatDecayPerTickZone = {
                    label = "Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Zone",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verfall / Je Aktualisierungsschritt / Zone.",
                },
                drugAdvancedHeatEnabled = {
                    label = "Fahndungsdruck & Risiko / Aktiviert",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Aktiviert.",
                },
                drugAdvancedHeatEnforcementHeatCritical = {
                    label = "Fahndungsdruck & Risiko / Polizeipräsenz / Fahndungsdruck / Kritisch",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Polizeipräsenz / Fahndungsdruck / Kritisch.",
                },
                drugAdvancedHeatEnforcementHeatHigh = {
                    label = "Fahndungsdruck & Risiko / Polizeipräsenz / Fahndungsdruck / Hoch",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Polizeipräsenz / Fahndungsdruck / Hoch.",
                },
                drugAdvancedHeatEnforcementHeatLow = {
                    label = "Fahndungsdruck & Risiko / Polizeipräsenz / Fahndungsdruck / Niedrig",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Polizeipräsenz / Fahndungsdruck / Niedrig.",
                },
                drugAdvancedHeatEnforcementHeatMedium = {
                    label = "Fahndungsdruck & Risiko / Polizeipräsenz / Fahndungsdruck / Mittel",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Polizeipräsenz / Fahndungsdruck / Mittel.",
                },
                drugAdvancedHeatEnforcementMultipliersBatch = {
                    label = "Fahndungsdruck & Risiko / Polizeipräsenz / Multiplikatoren / Charge",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Polizeipräsenz / Multiplikatoren / Charge.",
                },
                drugAdvancedHeatEnforcementMultipliersFaction = {
                    label = "Fahndungsdruck & Risiko / Polizeipräsenz / Multiplikatoren / Fraktion",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Polizeipräsenz / Multiplikatoren / Fraktion.",
                },
                drugAdvancedHeatEnforcementMultipliersZone = {
                    label = "Fahndungsdruck & Risiko / Polizeipräsenz / Multiplikatoren / Zone",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Polizeipräsenz / Multiplikatoren / Zone.",
                },
                drugAdvancedHeatEntityTypesBatch = {
                    label = "Fahndungsdruck & Risiko / Spielobjekt / Typen / Charge",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Spielobjekt / Typen / Charge.",
                },
                drugAdvancedHeatEntityTypesCamper = {
                    label = "Fahndungsdruck & Risiko / Spielobjekt / Typen / Wohnmobil",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Spielobjekt / Typen / Wohnmobil.",
                },
                drugAdvancedHeatEntityTypesDealer = {
                    label = "Fahndungsdruck & Risiko / Spielobjekt / Typen / Dealer",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Spielobjekt / Typen / Dealer.",
                },
                drugAdvancedHeatEntityTypesFaction = {
                    label = "Fahndungsdruck & Risiko / Spielobjekt / Typen / Fraktion",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Spielobjekt / Typen / Fraktion.",
                },
                drugAdvancedHeatEntityTypesHub = {
                    label = "Fahndungsdruck & Risiko / Spielobjekt / Typen / Verteilzentrum",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Spielobjekt / Typen / Verteilzentrum.",
                },
                drugAdvancedHeatEntityTypesLab = {
                    label = "Fahndungsdruck & Risiko / Spielobjekt / Typen / Labor",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Spielobjekt / Typen / Labor.",
                },
                drugAdvancedHeatEntityTypesPlayer = {
                    label = "Fahndungsdruck & Risiko / Spielobjekt / Typen / Spieler",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Spielobjekt / Typen / Spieler.",
                },
                drugAdvancedHeatEntityTypesRoute = {
                    label = "Fahndungsdruck & Risiko / Spielobjekt / Typen / Route",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Spielobjekt / Typen / Route.",
                },
                drugAdvancedHeatEntityTypesZone = {
                    label = "Fahndungsdruck & Risiko / Spielobjekt / Typen / Zone",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Spielobjekt / Typen / Zone.",
                },
                drugAdvancedHeatEventCooldownMinutes = {
                    label = "Fahndungsdruck & Risiko / Ereignis / Cooldown-Minuten",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Ereignis / Cooldown-Minuten.",
                },
                drugAdvancedHeatEventHistoryLimit = {
                    label = "Fahndungsdruck & Risiko / Ereignis / Historienlimit",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Ereignis / Historienlimit.",
                },
                drugAdvancedHeatLabHeatSyncThreshold = {
                    label = "Fahndungsdruck & Risiko / Labor / Fahndungsdruck / Abgleich / Schwellenwert",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Labor / Fahndungsdruck / Abgleich / Schwellenwert.",
                },
                drugAdvancedHeatLayLowCooldownMinutes = {
                    label = "Fahndungsdruck & Risiko / Untertauchen / Cooldown-Minuten",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Untertauchen / Cooldown-Minuten.",
                },
                drugAdvancedHeatLayLowIdleMinutes = {
                    label = "Fahndungsdruck & Risiko / Untertauchen / Leerlauf / Minuten",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Untertauchen / Leerlauf / Minuten.",
                },
                drugAdvancedHeatLayLowReduction = {
                    label = "Fahndungsdruck & Risiko / Untertauchen / Verringerung",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Untertauchen / Verringerung.",
                },
                drugAdvancedHeatLockdownMinutes = {
                    label = "Fahndungsdruck & Risiko / Abriegelung / Minuten",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Abriegelung / Minuten.",
                },
                drugAdvancedHeatMinimumDurationMinutes = {
                    label = "Fahndungsdruck & Risiko / Minimum / Dauer / Minuten",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Minimum / Dauer / Minuten.",
                },
                drugAdvancedHeatMinimumEventCooldownSeconds = {
                    label = "Fahndungsdruck & Risiko / Minimum / Ereignis / Abklingzeit (Sekunden)",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Minimum / Ereignis / Abklingzeit (Sekunden).",
                },
                drugAdvancedHeatMinimumIdleSeconds = {
                    label = "Fahndungsdruck & Risiko / Minimum / Leerlauf / Sekunden",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Minimum / Leerlauf / Sekunden.",
                },
                drugAdvancedHeatProcessingHeatMultiplier = {
                    label = "Fahndungsdruck & Risiko / Verarbeitung / Fahndungsdruck / Multiplikator",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verarbeitung / Fahndungsdruck / Multiplikator.",
                },
                drugAdvancedHeatRiskWeightsBatch = {
                    label = "Fahndungsdruck & Risiko / Risiko / Gewichtungen / Charge",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Risiko / Gewichtungen / Charge.",
                },
                drugAdvancedHeatRiskWeightsCamper = {
                    label = "Fahndungsdruck & Risiko / Risiko / Gewichtungen / Wohnmobil",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Risiko / Gewichtungen / Wohnmobil.",
                },
                drugAdvancedHeatRiskWeightsDealer = {
                    label = "Fahndungsdruck & Risiko / Risiko / Gewichtungen / Dealer",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Risiko / Gewichtungen / Dealer.",
                },
                drugAdvancedHeatRiskWeightsFaction = {
                    label = "Fahndungsdruck & Risiko / Risiko / Gewichtungen / Fraktion",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Risiko / Gewichtungen / Fraktion.",
                },
                drugAdvancedHeatRiskWeightsHub = {
                    label = "Fahndungsdruck & Risiko / Risiko / Gewichtungen / Verteilzentrum",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Risiko / Gewichtungen / Verteilzentrum.",
                },
                drugAdvancedHeatRiskWeightsLab = {
                    label = "Fahndungsdruck & Risiko / Risiko / Gewichtungen / Labor",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Risiko / Gewichtungen / Labor.",
                },
                drugAdvancedHeatRiskWeightsPlayer = {
                    label = "Fahndungsdruck & Risiko / Risiko / Gewichtungen / Spieler",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Risiko / Gewichtungen / Spieler.",
                },
                drugAdvancedHeatRiskWeightsRoute = {
                    label = "Fahndungsdruck & Risiko / Risiko / Gewichtungen / Route",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Risiko / Gewichtungen / Route.",
                },
                drugAdvancedHeatRiskWeightsZone = {
                    label = "Fahndungsdruck & Risiko / Risiko / Gewichtungen / Zone",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Risiko / Gewichtungen / Zone.",
                },
                drugAdvancedHeatRotateBurnerReduction = {
                    label = "Fahndungsdruck & Risiko / Wegwerftelefon wechseln / Verringerung",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Wegwerftelefon wechseln / Verringerung.",
                },
                drugAdvancedHeatRouteControlMinutes = {
                    label = "Fahndungsdruck & Risiko / Route / Steuerung / Minuten",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Route / Steuerung / Minuten.",
                },
                drugAdvancedHeatSaleHeatBatch = {
                    label = "Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Charge",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Charge.",
                },
                drugAdvancedHeatSaleHeatCamper = {
                    label = "Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Wohnmobil",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Wohnmobil.",
                },
                drugAdvancedHeatSaleHeatDealer = {
                    label = "Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Dealer",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Dealer.",
                },
                drugAdvancedHeatSaleHeatFaction = {
                    label = "Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Fraktion",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Fraktion.",
                },
                drugAdvancedHeatSaleHeatHub = {
                    label = "Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Verteilzentrum",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Verteilzentrum.",
                },
                drugAdvancedHeatSaleHeatLab = {
                    label = "Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Labor",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Labor.",
                },
                drugAdvancedHeatSaleHeatPlayer = {
                    label = "Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Spieler",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Spieler.",
                },
                drugAdvancedHeatSaleHeatRoute = {
                    label = "Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Route",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Route.",
                },
                drugAdvancedHeatSaleHeatZone = {
                    label = "Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Zone",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Verkauf / Fahndungsdruck / Zone.",
                },
                drugAdvancedHeatThresholdsCritical = {
                    label = "Fahndungsdruck & Risiko / Schwellenwerte / Kritisch",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Schwellenwerte / Kritisch.",
                },
                drugAdvancedHeatThresholdsHigh = {
                    label = "Fahndungsdruck & Risiko / Schwellenwerte / Hoch",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Schwellenwerte / Hoch.",
                },
                drugAdvancedHeatThresholdsLockdown = {
                    label = "Fahndungsdruck & Risiko / Schwellenwerte / Abriegelung",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Schwellenwerte / Abriegelung.",
                },
                drugAdvancedHeatThresholdsLow = {
                    label = "Fahndungsdruck & Risiko / Schwellenwerte / Niedrig",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Schwellenwerte / Niedrig.",
                },
                drugAdvancedHeatThresholdsMedium = {
                    label = "Fahndungsdruck & Risiko / Schwellenwerte / Mittel",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Schwellenwerte / Mittel.",
                },
                drugAdvancedHeatTickMinutes = {
                    label = "Fahndungsdruck & Risiko / Aktualisierungsschritt / Minuten",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Aktualisierungsschritt / Minuten.",
                },
                drugAdvancedHeatWholesaleHeatMultiplier = {
                    label = "Fahndungsdruck & Risiko / Großhandel / Fahndungsdruck / Multiplikator",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Großhandel / Fahndungsdruck / Multiplikator.",
                },
                drugAdvancedHeatWorkerLeakAlertRadius = {
                    label = "Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Alarmradius",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Alarmradius.",
                },
                drugAdvancedHeatWorkerLeakBaseChance = {
                    label = "Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Grundwert / Chance",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Grundwert / Chance.",
                },
                drugAdvancedHeatWorkerLeakFactionMultiplier = {
                    label = "Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Fraktion / Multiplikator",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Fraktion / Multiplikator.",
                },
                drugAdvancedHeatWorkerLeakHighSeverityThreshold = {
                    label = "Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Hoch / Schweregrad / Schwellenwert",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Hoch / Schweregrad / Schwellenwert.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Loyalität / Chance / Multiplikator",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Loyalität / Chance / Multiplikator.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyThreshold = {
                    label = "Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Loyalität / Schwellenwert",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Loyalität / Schwellenwert.",
                },
                drugAdvancedHeatWorkerLeakMaximumChance = {
                    label = "Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Maximum / Chance",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Maximum / Chance.",
                },
                drugAdvancedHeatWorkerLeakMinimumCooldownSeconds = {
                    label = "Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Minimum / Abklingzeit (Sekunden)",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Minimum / Abklingzeit (Sekunden).",
                },
                drugAdvancedHeatWorkerLeakRouteMultiplier = {
                    label = "Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Route / Multiplikator",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Route / Multiplikator.",
                },
                drugAdvancedHeatWorkerLeakStrengthMaximum = {
                    label = "Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Stärke / Maximum",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Stärke / Maximum.",
                },
                drugAdvancedHeatWorkerLeakStrengthMinimum = {
                    label = "Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Stärke / Minimum",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Stärke / Minimum.",
                },
                drugAdvancedHeatWorkerLeakStrengthMultiplier = {
                    label = "Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Stärke / Multiplikator",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Stärke / Multiplikator.",
                },
                drugAdvancedHeatWorkerLeakStressChanceMultiplier = {
                    label = "Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Stress / Chance / Multiplikator",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Stress / Chance / Multiplikator.",
                },
                drugAdvancedHeatWorkerLeakStressThreshold = {
                    label = "Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Stress / Schwellenwert",
                    description = "Konfigurationswert für Fahndungsdruck & Risiko / Mitarbeiter / Informationsleck / Stress / Schwellenwert.",
                },
                drugAdvancedContactNetworkActionCooldownSeconds = {
                    label = "Kontaktnetzwerk / Aktions-Cooldown / Sekunden",
                    description = "Konfigurationswert für Kontaktnetzwerk / Aktions-Cooldown / Sekunden.",
                },
                drugAdvancedContactNetworkActiveHotspotCount = {
                    label = "Kontaktnetzwerk / Anzahl aktiver Brennpunkte",
                    description = "Konfigurationswert für Kontaktnetzwerk / Anzahl aktiver Brennpunkte.",
                },
                drugAdvancedContactNetworkBurnerHintTrust = {
                    label = "Kontaktnetzwerk / Wegwerfhandy-Hinweis / Vertrauen",
                    description = "Konfigurationswert für Kontaktnetzwerk / Wegwerfhandy-Hinweis / Vertrauen.",
                },
                drugAdvancedContactNetworkBurnerOfferMaximumMultiplier = {
                    label = "Kontaktnetzwerk / Wegwerftelefon / Angebot / Maximum / Multiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Wegwerftelefon / Angebot / Maximum / Multiplikator.",
                },
                drugAdvancedContactNetworkBurnerOfferMinimumMultiplier = {
                    label = "Kontaktnetzwerk / Wegwerftelefon / Angebot / Minimum / Multiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Wegwerftelefon / Angebot / Minimum / Multiplikator.",
                },
                drugAdvancedContactNetworkBuyerCooldownMinutes = {
                    label = "Kontaktnetzwerk / Käufer / Cooldown-Minuten",
                    description = "Konfigurationswert für Kontaktnetzwerk / Käufer / Cooldown-Minuten.",
                },
                drugAdvancedContactNetworkBuyerDeliveryDistance = {
                    label = "Kontaktnetzwerk / Käufer / Zustelldistanz",
                    description = "Konfigurationswert für Kontaktnetzwerk / Käufer / Zustelldistanz.",
                },
                drugAdvancedContactNetworkBuyerPremiumSuccessScore = {
                    label = "Kontaktnetzwerk / Käufer / Premium / Erfolg / Punktzahl",
                    description = "Konfigurationswert für Kontaktnetzwerk / Käufer / Premium / Erfolg / Punktzahl.",
                },
                drugAdvancedContactNetworkBuyerPremiumTrustGain = {
                    label = "Kontaktnetzwerk / Käufer / Premium / Vertrauen / Zuwachs",
                    description = "Konfigurationswert für Kontaktnetzwerk / Käufer / Premium / Vertrauen / Zuwachs.",
                },
                drugAdvancedContactNetworkBuyerRequestHeatRiskWeight = {
                    label = "Kontaktnetzwerk / Käufer / Anfrage / Fahndungsdruck und Risiko / Gewichtung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Käufer / Anfrage / Fahndungsdruck und Risiko / Gewichtung.",
                },
                drugAdvancedContactNetworkBuyerStandardTrustGain = {
                    label = "Kontaktnetzwerk / Käufer / Standard / Vertrauen / Zuwachs",
                    description = "Konfigurationswert für Kontaktnetzwerk / Käufer / Standard / Vertrauen / Zuwachs.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMax = {
                    label = "Kontaktnetzwerk / Wartezeit bis zur Kontaktaktivierung / Sekunden / Maximum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Wartezeit bis zur Kontaktaktivierung / Sekunden / Maximum.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMin = {
                    label = "Kontaktnetzwerk / Wartezeit bis zur Kontaktaktivierung / Sekunden / Minimum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Wartezeit bis zur Kontaktaktivierung / Sekunden / Minimum.",
                },
                drugAdvancedContactNetworkContactDemandRangeMax = {
                    label = "Kontaktnetzwerk / Kontakt / Nachfrage / Wertebereich / Maximum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Kontakt / Nachfrage / Wertebereich / Maximum.",
                },
                drugAdvancedContactNetworkContactDemandRangeMin = {
                    label = "Kontaktnetzwerk / Kontakt / Nachfrage / Wertebereich / Minimum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Kontakt / Nachfrage / Wertebereich / Minimum.",
                },
                drugAdvancedContactNetworkContactLossTrust = {
                    label = "Kontaktnetzwerk / Kontakt / Verlust / Vertrauen",
                    description = "Konfigurationswert für Kontaktnetzwerk / Kontakt / Verlust / Vertrauen.",
                },
                drugAdvancedContactNetworkDarknetExactIntelMinutes = {
                    label = "Kontaktnetzwerk / Darknet / Genaue Informationen / Minuten",
                    description = "Konfigurationswert für Kontaktnetzwerk / Darknet / Genaue Informationen / Minuten.",
                },
                drugAdvancedContactNetworkDarknetHotspotIntelPrice = {
                    label = "Kontaktnetzwerk / Darknet / Brennpunkt / Informationen / Preis",
                    description = "Konfigurationswert für Kontaktnetzwerk / Darknet / Brennpunkt / Informationen / Preis.",
                },
                drugAdvancedContactNetworkDarknetIntelPrice = {
                    label = "Kontaktnetzwerk / Darknet / Informationen / Preis",
                    description = "Konfigurationswert für Kontaktnetzwerk / Darknet / Informationen / Preis.",
                },
                drugAdvancedContactNetworkDealerBasePrice = {
                    label = "Kontaktnetzwerk / Dealer / Grundpreis",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Grundpreis.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMax = {
                    label = "Kontaktnetzwerk / Dealer / Einstellung / Kapazität / Maximum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Einstellung / Kapazität / Maximum.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMin = {
                    label = "Kontaktnetzwerk / Dealer / Einstellung / Kapazität / Minimum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Einstellung / Kapazität / Minimum.",
                },
                drugAdvancedContactNetworkDealerHireRiskMax = {
                    label = "Kontaktnetzwerk / Dealer / Einstellung / Risiko / Maximum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Einstellung / Risiko / Maximum.",
                },
                drugAdvancedContactNetworkDealerHireRiskMin = {
                    label = "Kontaktnetzwerk / Dealer / Einstellung / Risiko / Minimum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Einstellung / Risiko / Minimum.",
                },
                drugAdvancedContactNetworkDealerHireSkillMax = {
                    label = "Kontaktnetzwerk / Dealer / Einstellung / Fähigkeit / Maximum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Einstellung / Fähigkeit / Maximum.",
                },
                drugAdvancedContactNetworkDealerHireSkillMin = {
                    label = "Kontaktnetzwerk / Dealer / Einstellung / Fähigkeit / Minimum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Einstellung / Fähigkeit / Minimum.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Id = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 1 / ID",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 1 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Item = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 1 / Gegenstand",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 1 / Gegenstand.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Label = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 1 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 1 / Bezeichnung.",
                },
                drugAdvancedContactNetworkDealerOffersItem1MinTrust = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 1 / Mindestvertrauen",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 1 / Mindestvertrauen.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Price = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 1 / Preis",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 1 / Preis.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Id = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 2 / ID",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 2 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Item = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 2 / Gegenstand",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 2 / Gegenstand.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Label = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 2 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 2 / Bezeichnung.",
                },
                drugAdvancedContactNetworkDealerOffersItem2MinTrust = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 2 / Mindestvertrauen",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 2 / Mindestvertrauen.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Price = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 2 / Preis",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 2 / Preis.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Id = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 3 / ID",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 3 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Item = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 3 / Gegenstand",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 3 / Gegenstand.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Label = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 3 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 3 / Bezeichnung.",
                },
                drugAdvancedContactNetworkDealerOffersItem3MinTrust = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 3 / Mindestvertrauen",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 3 / Mindestvertrauen.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Price = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 3 / Preis",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 3 / Preis.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Id = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 4 / ID",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 4 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Item = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 4 / Gegenstand",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 4 / Gegenstand.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Label = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 4 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 4 / Bezeichnung.",
                },
                drugAdvancedContactNetworkDealerOffersItem4MinTrust = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 4 / Mindestvertrauen",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 4 / Mindestvertrauen.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Price = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 4 / Preis",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 4 / Preis.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Id = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 5 / ID",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 5 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Item = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 5 / Gegenstand",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 5 / Gegenstand.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Label = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 5 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 5 / Bezeichnung.",
                },
                drugAdvancedContactNetworkDealerOffersItem5MinTrust = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 5 / Mindestvertrauen",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 5 / Mindestvertrauen.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Price = {
                    label = "Kontaktnetzwerk / Dealer-Angebote / 5 / Preis",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer-Angebote / 5 / Preis.",
                },
                drugAdvancedContactNetworkDealerProtectionHours = {
                    label = "Kontaktnetzwerk / Dealer / Schutz / Stunden",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Schutz / Stunden.",
                },
                drugAdvancedContactNetworkDealerProtectionPrice = {
                    label = "Kontaktnetzwerk / Dealer / Schutz / Preis",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Schutz / Preis.",
                },
                drugAdvancedContactNetworkDealerSaleMax = {
                    label = "Kontaktnetzwerk / Dealer / Verkauf / Maximum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Verkauf / Maximum.",
                },
                drugAdvancedContactNetworkDealerSaleMin = {
                    label = "Kontaktnetzwerk / Dealer / Verkauf / Minimum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Verkauf / Minimum.",
                },
                drugAdvancedContactNetworkDealerSimulationAggressivePriceMultiplier = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Aggressive Arbeitsweise / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Aggressive Arbeitsweise / Preismultiplikator.",
                },
                drugAdvancedContactNetworkDealerSimulationBaseQualityPriceFactor = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Grundqualität / Preisfaktor",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Grundqualität / Preisfaktor.",
                },
                drugAdvancedContactNetworkDealerSimulationBulkPriceMultiplier = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Großmenge / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Großmenge / Preismultiplikator.",
                },
                drugAdvancedContactNetworkDealerSimulationCheapPriceMultiplier = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Günstige Verkäufe / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Günstige Verkäufe / Preismultiplikator.",
                },
                drugAdvancedContactNetworkDealerSimulationDefaultQuality = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Standardwert / Qualität",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Standardwert / Qualität.",
                },
                drugAdvancedContactNetworkDealerSimulationDisloyalThreshold = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Schwelle für Illoyalität",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Schwelle für Illoyalität.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerLevel = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Erfahrung / Je Stufe",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Erfahrung / Je Stufe.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerUnit = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Erfahrung / Je Einheit",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Erfahrung / Je Einheit.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentLoyaltyLoss = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Zwischenfall / Loyalität / Verlust",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Zwischenfall / Loyalität / Verlust.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentRollMaximum = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Zwischenfall / Zufallsprüfung / Maximum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Zwischenfall / Zufallsprüfung / Maximum.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelPriceBonus = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Stufe / Preis / Bonus",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Stufe / Preis / Bonus.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelSaleDivisor = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Stufe / Verkauf / Divisor",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Stufe / Verkauf / Divisor.",
                },
                drugAdvancedContactNetworkDealerSimulationLoyaltyRiskWeight = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Loyalität / Risiko / Gewichtung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Loyalität / Risiko / Gewichtung.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumIncidentChance = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Maximum / Zwischenfall / Chance",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Maximum / Zwischenfall / Chance.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumLevel = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Maximum / Stufe",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Maximum / Stufe.",
                },
                drugAdvancedContactNetworkDealerSimulationPremiumPriceMultiplier = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Premium / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Premium / Preismultiplikator.",
                },
                drugAdvancedContactNetworkDealerSimulationProfileRiskWeight = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Profil / Risiko / Gewichtung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Profil / Risiko / Gewichtung.",
                },
                drugAdvancedContactNetworkDealerSimulationProtectionRiskReduction = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Schutz / Risiko / Verringerung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Schutz / Risiko / Verringerung.",
                },
                drugAdvancedContactNetworkDealerSimulationQualityPriceDivisor = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Qualität / Preis / Divisor",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Qualität / Preis / Divisor.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryBaseChance = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Erholung / Grundwert / Chance",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Erholung / Grundwert / Chance.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryLoyaltyWeight = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Erholung / Loyalität / Gewichtung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Erholung / Loyalität / Gewichtung.",
                },
                drugAdvancedContactNetworkDealerSimulationRobbedStockLoss = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Bestandsverlust durch Raub",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Bestandsverlust durch Raub.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillRiskReduction = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Fähigkeit / Risiko / Verringerung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Fähigkeit / Risiko / Verringerung.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillSaleDivisor = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Fähigkeit / Verkauf / Divisor",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Fähigkeit / Verkauf / Divisor.",
                },
                drugAdvancedContactNetworkDealerSimulationStableLoyaltyThreshold = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Loyalitätsschwelle für Stabilität",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Loyalitätsschwelle für Stabilität.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryPriceMultiplier = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Territorium / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Territorium / Preismultiplikator.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryRiskReduction = {
                    label = "Kontaktnetzwerk / Dealer / Simulation / Territorium / Risiko / Verringerung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Simulation / Territorium / Risiko / Verringerung.",
                },
                drugAdvancedContactNetworkDealerTickMinutes = {
                    label = "Kontaktnetzwerk / Dealer / Aktualisierungsschritt / Minuten",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Aktualisierungsschritt / Minuten.",
                },
                drugAdvancedContactNetworkDealerWage = {
                    label = "Kontaktnetzwerk / Dealer / Lohn",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Lohn.",
                },
                drugAdvancedContactNetworkDealerWageDecay = {
                    label = "Kontaktnetzwerk / Dealer / Lohn / Verfall",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Lohn / Verfall.",
                },
                drugAdvancedContactNetworkDealerWageLoyaltyGain = {
                    label = "Kontaktnetzwerk / Dealer / Lohn / Loyalität / Zuwachs",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Lohn / Loyalität / Zuwachs.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem1 = {
                    label = "Kontaktnetzwerk / Dealer / Schwachstellen / 1",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Schwachstellen / 1.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem2 = {
                    label = "Kontaktnetzwerk / Dealer / Schwachstellen / 2",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Schwachstellen / 2.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem3 = {
                    label = "Kontaktnetzwerk / Dealer / Schwachstellen / 3",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Schwachstellen / 3.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem4 = {
                    label = "Kontaktnetzwerk / Dealer / Schwachstellen / 4",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Schwachstellen / 4.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem5 = {
                    label = "Kontaktnetzwerk / Dealer / Schwachstellen / 5",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer / Schwachstellen / 5.",
                },
                drugAdvancedContactNetworkDefaultContactDemand = {
                    label = "Kontaktnetzwerk / Standardwert / Kontakt / Nachfrage",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standardwert / Kontakt / Nachfrage.",
                },
                drugAdvancedContactNetworkDefaultContactRisk = {
                    label = "Kontaktnetzwerk / Standardwert / Kontakt / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standardwert / Kontakt / Risiko.",
                },
                drugAdvancedContactNetworkDefaultDealerCapacity = {
                    label = "Kontaktnetzwerk / Standarddealer / Kapazität",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standarddealer / Kapazität.",
                },
                drugAdvancedContactNetworkDefaultDealerRisk = {
                    label = "Kontaktnetzwerk / Standarddealer / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standarddealer / Risiko.",
                },
                drugAdvancedContactNetworkDefaultDealerSkill = {
                    label = "Kontaktnetzwerk / Standarddealer / Fähigkeit",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standarddealer / Fähigkeit.",
                },
                drugAdvancedContactNetworkDefaultHotspotRadius = {
                    label = "Kontaktnetzwerk / Standardwert / Brennpunkt / Radius",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standardwert / Brennpunkt / Radius.",
                },
                drugAdvancedContactNetworkDemandResetMinutes = {
                    label = "Kontaktnetzwerk / Nachfrage zurücksetzen (Minuten)",
                    description = "Konfigurationswert für Kontaktnetzwerk / Nachfrage zurücksetzen (Minuten).",
                },
                drugAdvancedContactNetworkEnabled = {
                    label = "Kontaktnetzwerk / Aktiviert",
                    description = "Konfigurationswert für Kontaktnetzwerk / Aktiviert.",
                },
                drugAdvancedContactNetworkExactLocationTrust = {
                    label = "Kontaktnetzwerk / Genauer Standort / Vertrauen",
                    description = "Konfigurationswert für Kontaktnetzwerk / Genauer Standort / Vertrauen.",
                },
                drugAdvancedContactNetworkFactionDiscoveryReputation = {
                    label = "Kontaktnetzwerk / Fraktion / Entdeckung / Ruf",
                    description = "Konfigurationswert für Kontaktnetzwerk / Fraktion / Entdeckung / Ruf.",
                },
                drugAdvancedContactNetworkFactionHintTrust = {
                    label = "Kontaktnetzwerk / Fraktion / Hinweis / Vertrauen",
                    description = "Konfigurationswert für Kontaktnetzwerk / Fraktion / Hinweis / Vertrauen.",
                },
                drugAdvancedContactNetworkFailedDeliveryCooldownMinutes = {
                    label = "Kontaktnetzwerk / Fehlgeschlagene Lieferung / Cooldown-Minuten",
                    description = "Konfigurationswert für Kontaktnetzwerk / Fehlgeschlagene Lieferung / Cooldown-Minuten.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerCount = {
                    label = "Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Angreifer / Anzahl",
                    description = "Konfigurationswert für Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Angreifer / Anzahl.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem1 = {
                    label = "Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Angreifer / Modelle / 1",
                    description = "Konfigurationswert für Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Angreifer / Modelle / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem2 = {
                    label = "Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Angreifer / Modelle / 2",
                    description = "Konfigurationswert für Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Angreifer / Modelle / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem3 = {
                    label = "Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Angreifer / Modelle / 3",
                    description = "Konfigurationswert für Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Angreifer / Modelle / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterDurationSeconds = {
                    label = "Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Dauer (Sekunden)",
                    description = "Konfigurationswert für Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Dauer (Sekunden).",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem1 = {
                    label = "Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Polizei / Modelle / 1",
                    description = "Konfigurationswert für Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Polizei / Modelle / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem2 = {
                    label = "Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Polizei / Modelle / 2",
                    description = "Konfigurationswert für Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Polizei / Modelle / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem3 = {
                    label = "Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Polizei / Modelle / 3",
                    description = "Konfigurationswert für Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Polizei / Modelle / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterSpawnRadius = {
                    label = "Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Spawn-Radius",
                    description = "Konfigurationswert für Kontaktnetzwerk / Vorgetäuschtes Geschäft / Begegnung / Spawn-Radius.",
                },
                drugAdvancedContactNetworkFallbackPreferredDrug = {
                    label = "Kontaktnetzwerk / Ersatzwert / Bevorzugte Droge",
                    description = "Konfigurationswert für Kontaktnetzwerk / Ersatzwert / Bevorzugte Droge.",
                },
                drugAdvancedContactNetworkFallbackProductLabel = {
                    label = "Kontaktnetzwerk / Ersatzwert / Produktbezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Ersatzwert / Produktbezeichnung.",
                },
                drugAdvancedContactNetworkGuideBookItem = {
                    label = "Kontaktnetzwerk / Anleitung / Buch / Gegenstand",
                    description = "Konfigurationswert für Kontaktnetzwerk / Anleitung / Buch / Gegenstand.",
                },
                drugAdvancedContactNetworkGuideBookTrust = {
                    label = "Kontaktnetzwerk / Anleitung / Buch / Vertrauen",
                    description = "Konfigurationswert für Kontaktnetzwerk / Anleitung / Buch / Vertrauen.",
                },
                drugAdvancedContactNetworkHireDealerPrice = {
                    label = "Kontaktnetzwerk / Dealer anheuern / Preis",
                    description = "Konfigurationswert für Kontaktnetzwerk / Dealer anheuern / Preis.",
                },
                drugAdvancedContactNetworkHistoryLimit = {
                    label = "Kontaktnetzwerk / Historienlimit",
                    description = "Konfigurationswert für Kontaktnetzwerk / Historienlimit.",
                },
                drugAdvancedContactNetworkHotspotIntelMinutes = {
                    label = "Kontaktnetzwerk / Brennpunkt / Informationen / Minuten",
                    description = "Konfigurationswert für Kontaktnetzwerk / Brennpunkt / Informationen / Minuten.",
                },
                drugAdvancedContactNetworkHotspotRotationMinutes = {
                    label = "Kontaktnetzwerk / Brennpunkt / Wechsel / Minuten",
                    description = "Konfigurationswert für Kontaktnetzwerk / Brennpunkt / Wechsel / Minuten.",
                },
                drugAdvancedContactNetworkListingDurationMinutes = {
                    label = "Kontaktnetzwerk / Angebot / Dauer / Minuten",
                    description = "Konfigurationswert für Kontaktnetzwerk / Angebot / Dauer / Minuten.",
                },
                drugAdvancedContactNetworkMaxOwnedDealers = {
                    label = "Kontaktnetzwerk / Maximum / Im Besitz / Dealer",
                    description = "Konfigurationswert für Kontaktnetzwerk / Maximum / Im Besitz / Dealer.",
                },
                drugAdvancedContactNetworkMinimumBuyerDeliveryDistance = {
                    label = "Kontaktnetzwerk / Minimum / Käufer / Zustelldistanz",
                    description = "Konfigurationswert für Kontaktnetzwerk / Minimum / Käufer / Zustelldistanz.",
                },
                drugAdvancedContactNetworkMinimumContactRotationMinutes = {
                    label = "Kontaktnetzwerk / Minimum / Kontaktrotation (Minuten)",
                    description = "Konfigurationswert für Kontaktnetzwerk / Minimum / Kontaktrotation (Minuten).",
                },
                drugAdvancedContactNetworkMinimumDemandResetMinutes = {
                    label = "Kontaktnetzwerk / Minimum / Nachfrage zurücksetzen (Minuten)",
                    description = "Konfigurationswert für Kontaktnetzwerk / Minimum / Nachfrage zurücksetzen (Minuten).",
                },
                drugAdvancedContactNetworkMinimumHeatMultiplier = {
                    label = "Kontaktnetzwerk / Minimum / Fahndungsdruck / Multiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Minimum / Fahndungsdruck / Multiplikator.",
                },
                drugAdvancedContactNetworkMinimumHotspotIntelMinutes = {
                    label = "Kontaktnetzwerk / Minimum / Brennpunkt / Informationen / Minuten",
                    description = "Konfigurationswert für Kontaktnetzwerk / Minimum / Brennpunkt / Informationen / Minuten.",
                },
                drugAdvancedContactNetworkMinimumHotspotRadius = {
                    label = "Kontaktnetzwerk / Minimum / Brennpunkt / Radius",
                    description = "Konfigurationswert für Kontaktnetzwerk / Minimum / Brennpunkt / Radius.",
                },
                drugAdvancedContactNetworkMinimumHotspotRotationMinutes = {
                    label = "Kontaktnetzwerk / Minimum / Brennpunkt / Wechsel / Minuten",
                    description = "Konfigurationswert für Kontaktnetzwerk / Minimum / Brennpunkt / Wechsel / Minuten.",
                },
                drugAdvancedContactNetworkMinimumListingDurationMinutes = {
                    label = "Kontaktnetzwerk / Minimum / Angebot / Dauer / Minuten",
                    description = "Konfigurationswert für Kontaktnetzwerk / Minimum / Angebot / Dauer / Minuten.",
                },
                drugAdvancedContactNetworkMinimumRewardMultiplier = {
                    label = "Kontaktnetzwerk / Minimale Belohnung / Multiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Minimale Belohnung / Multiplikator.",
                },
                drugAdvancedContactNetworkMinimumRobberyMultiplier = {
                    label = "Kontaktnetzwerk / Minimum / Raubüberfälle / Multiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Minimum / Raubüberfälle / Multiplikator.",
                },
                drugAdvancedContactNetworkMinimumSpotPriceMultiplier = {
                    label = "Kontaktnetzwerk / Minimum / Standort / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Minimum / Standort / Preismultiplikator.",
                },
                drugAdvancedContactNetworkOtherDrugPriceMultiplier = {
                    label = "Kontaktnetzwerk / Sonstige / Droge / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Sonstige / Droge / Preismultiplikator.",
                },
                drugAdvancedContactNetworkPaymentAccount = {
                    label = "Kontaktnetzwerk / Zahlungskonto",
                    description = "Konfigurationswert für Kontaktnetzwerk / Zahlungskonto.",
                },
                drugAdvancedContactNetworkPostDeliveryDemandResetSeconds = {
                    label = "Kontaktnetzwerk / Nach der Lieferung / Nachfrage / Zurücksetzen / Sekunden",
                    description = "Konfigurationswert für Kontaktnetzwerk / Nach der Lieferung / Nachfrage / Zurücksetzen / Sekunden.",
                },
                drugAdvancedContactNetworkPreferredDrugPriceMultiplier = {
                    label = "Kontaktnetzwerk / Bevorzugte Droge / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Bevorzugte Droge / Preismultiplikator.",
                },
                drugAdvancedContactNetworkRegionLocationTrust = {
                    label = "Kontaktnetzwerk / Region / Ort / Vertrauen",
                    description = "Konfigurationswert für Kontaktnetzwerk / Region / Ort / Vertrauen.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMax = {
                    label = "Kontaktnetzwerk / Anfrage / Mengen / Großmenge / Maximum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Anfrage / Mengen / Großmenge / Maximum.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMin = {
                    label = "Kontaktnetzwerk / Anfrage / Mengen / Großmenge / Minimum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Anfrage / Mengen / Großmenge / Minimum.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMax = {
                    label = "Kontaktnetzwerk / Anfrage / Mengen / Premium / Maximum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Anfrage / Mengen / Premium / Maximum.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMin = {
                    label = "Kontaktnetzwerk / Anfrage / Mengen / Premium / Minimum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Anfrage / Mengen / Premium / Minimum.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMax = {
                    label = "Kontaktnetzwerk / Anfrage / Mengen / Standard / Maximum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Anfrage / Mengen / Standard / Maximum.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMin = {
                    label = "Kontaktnetzwerk / Anfrage / Mengen / Standard / Minimum",
                    description = "Konfigurationswert für Kontaktnetzwerk / Anfrage / Mengen / Standard / Minimum.",
                },
                drugAdvancedContactNetworkRotationMinutes = {
                    label = "Kontaktnetzwerk / Wechsel / Minuten",
                    description = "Konfigurationswert für Kontaktnetzwerk / Wechsel / Minuten.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 1 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 1 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 1 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 1 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 1 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 1 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 1 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 1 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 1 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 1 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 1 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 1 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 1 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 1 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 1 / Risiko.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 2 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 2 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 2 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 2 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 2 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 2 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 2 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 2 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 2 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 2 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 2 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 2 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 2 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 2 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 2 / Risiko.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 3 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 3 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 3 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 3 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 3 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 3 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 3 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 3 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 3 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 3 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 3 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 3 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 3 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 3 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Straßendealer / 3 / Risiko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 1 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 1 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 1 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 1 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 1 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 1 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 1 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 1 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 1 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 1 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 1 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 1 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 1 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 1 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 1 / Risiko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 2 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 2 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 2 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 2 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 2 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 2 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 2 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 2 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 2 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 2 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 2 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 2 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 2 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 2 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 2 / Risiko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 3 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 3 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 3 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 3 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 3 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 3 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 3 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 3 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 3 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 3 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 3 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 3 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 3 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 3 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standardkäufer / 3 / Risiko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 1 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 1 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 1 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 1 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 1 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 1 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 1 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 1 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 1 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 1 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 1 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 1 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 1 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 1 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 1 / Risiko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 2 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 2 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 2 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 2 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 2 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 2 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 2 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 2 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 2 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 2 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 2 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 2 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 2 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 2 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 2 / Risiko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 3 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 3 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 3 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 3 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 3 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 3 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 3 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 3 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 3 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 3 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 3 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 3 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 3 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 3 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Standarddealer / 3 / Risiko.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 1 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 1 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 1 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 1 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 1 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 1 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 1 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 1 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 1 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 1 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 1 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 1 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 1 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 1 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 1 / Risiko.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 2 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 2 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 2 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 2 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 2 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 2 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 2 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 2 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 2 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 2 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 2 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 2 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 2 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 2 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 2 / Risiko.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 3 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 3 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 3 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 3 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 3 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 3 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 3 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 3 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 3 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 3 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 3 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 3 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 3 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 3 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Netzwerkdealer / 3 / Risiko.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 1 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 1 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 1 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 1 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 1 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 1 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 1 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 1 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 1 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 1 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 1 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 1 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 1 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 1 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 1 / Risiko.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 2 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 2 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 2 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 2 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 2 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 2 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 2 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 2 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 2 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 2 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 2 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 2 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 2 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 2 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 2 / Risiko.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 3 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 3 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 3 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 3 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 3 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 3 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 3 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 3 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 3 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 3 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 3 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 3 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 3 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 3 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Premiumvermittler / 3 / Risiko.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 1 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 1 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 1 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 1 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 1 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 1 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 1 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 1 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 1 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 1 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 1 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 1 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 1 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 1 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 1 / Risiko.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 2 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 2 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 2 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 2 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 2 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 2 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 2 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 2 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 2 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 2 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 2 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 2 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 2 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 2 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 2 / Risiko.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsX = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 3 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 3 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsY = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 3 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 3 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsZ = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 3 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 3 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsW = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 3 / Koordinaten / W",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 3 / Koordinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Label = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 3 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 3 / Bezeichnung.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3PriceMultiplier = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 3 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 3 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Region = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 3 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Risk = {
                    label = "Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 3 / Risiko",
                    description = "Konfigurationswert für Kontaktnetzwerk / Standort / Auswahlpools / Großhandelskontakt / 3 / Risiko.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1AcceptBonus = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 1 / Annahmebonus",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 1 / Annahmebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Archetype = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 1 / Grundtyp",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 1 / Grundtyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsX = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 1 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 1 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsY = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 1 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 1 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsZ = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 1 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 1 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1DemandBonus = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 1 / Nachfragebonus",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 1 / Nachfragebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1HeatMultiplier = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 1 / Fahndungsdruck / Multiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 1 / Fahndungsdruck / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Id = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 1 / ID",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 1 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Label = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 1 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 1 / Bezeichnung.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem1 = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 1 / Bevorzugte Drogen / 1",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 1 / Bevorzugte Drogen / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem2 = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 1 / Bevorzugte Drogen / 2",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 1 / Bevorzugte Drogen / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem3 = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 1 / Bevorzugte Drogen / 3",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 1 / Bevorzugte Drogen / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem4 = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 1 / Bevorzugte Drogen / 4",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 1 / Bevorzugte Drogen / 4.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PriceMultiplier = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 1 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 1 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Radius = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 1 / Radius",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 1 / Radius.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Region = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 1 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 1 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1RobberyMultiplier = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 1 / Raubüberfälle / Multiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 1 / Raubüberfälle / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2AcceptBonus = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 2 / Annahmebonus",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 2 / Annahmebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Archetype = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 2 / Grundtyp",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 2 / Grundtyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsX = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 2 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 2 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsY = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 2 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 2 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsZ = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 2 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 2 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2DemandBonus = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 2 / Nachfragebonus",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 2 / Nachfragebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2HeatMultiplier = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 2 / Fahndungsdruck / Multiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 2 / Fahndungsdruck / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Id = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 2 / ID",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 2 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Label = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 2 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 2 / Bezeichnung.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2MinimumQuality = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 2 / Mindestqualität",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 2 / Mindestqualität.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem1 = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 2 / Bevorzugte Drogen / 1",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 2 / Bevorzugte Drogen / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem2 = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 2 / Bevorzugte Drogen / 2",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 2 / Bevorzugte Drogen / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PriceMultiplier = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 2 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 2 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Radius = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 2 / Radius",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 2 / Radius.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Region = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 2 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 2 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2RobberyMultiplier = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 2 / Raubüberfälle / Multiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 2 / Raubüberfälle / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3AcceptBonus = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 3 / Annahmebonus",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 3 / Annahmebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Archetype = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 3 / Grundtyp",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 3 / Grundtyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsX = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 3 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 3 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsY = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 3 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 3 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsZ = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 3 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 3 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3DemandBonus = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 3 / Nachfragebonus",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 3 / Nachfragebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3HeatMultiplier = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 3 / Fahndungsdruck / Multiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 3 / Fahndungsdruck / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Id = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 3 / ID",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 3 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Label = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 3 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 3 / Bezeichnung.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem1 = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 3 / Bevorzugte Drogen / 1",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 3 / Bevorzugte Drogen / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem2 = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 3 / Bevorzugte Drogen / 2",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 3 / Bevorzugte Drogen / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem3 = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 3 / Bevorzugte Drogen / 3",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 3 / Bevorzugte Drogen / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PriceMultiplier = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 3 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 3 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Radius = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 3 / Radius",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 3 / Radius.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Region = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 3 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 3 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3RobberyMultiplier = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 3 / Raubüberfälle / Multiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 3 / Raubüberfälle / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4AcceptBonus = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 4 / Annahmebonus",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 4 / Annahmebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Archetype = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 4 / Grundtyp",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 4 / Grundtyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsX = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 4 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 4 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsY = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 4 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 4 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsZ = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 4 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 4 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4DemandBonus = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 4 / Nachfragebonus",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 4 / Nachfragebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4HeatMultiplier = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 4 / Fahndungsdruck / Multiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 4 / Fahndungsdruck / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Id = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 4 / ID",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 4 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Label = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 4 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 4 / Bezeichnung.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem1 = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 4 / Bevorzugte Drogen / 1",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 4 / Bevorzugte Drogen / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem2 = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 4 / Bevorzugte Drogen / 2",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 4 / Bevorzugte Drogen / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem3 = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 4 / Bevorzugte Drogen / 3",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 4 / Bevorzugte Drogen / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PriceMultiplier = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 4 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 4 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Radius = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 4 / Radius",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 4 / Radius.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Region = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 4 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 4 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4RobberyMultiplier = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 4 / Raubüberfälle / Multiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 4 / Raubüberfälle / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5AcceptBonus = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 5 / Annahmebonus",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 5 / Annahmebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Archetype = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 5 / Grundtyp",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 5 / Grundtyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsX = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 5 / Koordinaten / X",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 5 / Koordinaten / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsY = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 5 / Koordinaten / Y",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 5 / Koordinaten / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsZ = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 5 / Koordinaten / Z",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 5 / Koordinaten / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5DemandBonus = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 5 / Nachfragebonus",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 5 / Nachfragebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5HeatMultiplier = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 5 / Fahndungsdruck / Multiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 5 / Fahndungsdruck / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Id = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 5 / ID",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 5 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Label = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 5 / Bezeichnung",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 5 / Bezeichnung.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem1 = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 5 / Bevorzugte Drogen / 1",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 5 / Bevorzugte Drogen / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem2 = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 5 / Bevorzugte Drogen / 2",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 5 / Bevorzugte Drogen / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PriceMultiplier = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 5 / Preismultiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 5 / Preismultiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Radius = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 5 / Radius",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 5 / Radius.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Region = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 5 / Region",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 5 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5RobberyMultiplier = {
                    label = "Kontaktnetzwerk / Straße / Brennpunkte / 5 / Raubüberfälle / Multiplikator",
                    description = "Konfigurationswert für Kontaktnetzwerk / Straße / Brennpunkte / 5 / Raubüberfälle / Multiplikator.",
                },
                drugAdvancedContactNetworkTrustLevelsKnown = {
                    label = "Kontaktnetzwerk / Vertrauen / Stufen / Bekannt",
                    description = "Konfigurationswert für Kontaktnetzwerk / Vertrauen / Stufen / Bekannt.",
                },
                drugAdvancedContactNetworkTrustLevelsReliable = {
                    label = "Kontaktnetzwerk / Vertrauen / Stufen / Zuverlässig",
                    description = "Konfigurationswert für Kontaktnetzwerk / Vertrauen / Stufen / Zuverlässig.",
                },
                drugAdvancedContactNetworkTrustLevelsTrusted = {
                    label = "Kontaktnetzwerk / Vertrauen / Stufen / Vertrauenswürdig",
                    description = "Konfigurationswert für Kontaktnetzwerk / Vertrauen / Stufen / Vertrauenswürdig.",
                },
                drugAdvancedBusinessNetworkActionCooldownSeconds = {
                    label = "Unternehmensnetzwerk / Aktions-Cooldown / Sekunden",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Aktions-Cooldown / Sekunden.",
                },
                drugAdvancedBusinessNetworkBalanceBaseUnitPrice = {
                    label = "Unternehmensnetzwerk / Guthaben / Grundwert / Stückpreis",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Guthaben / Grundwert / Stückpreis.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerDealer = {
                    label = "Unternehmensnetzwerk / Guthaben / Fahndungsdruck im Netzwerk / Je Dealer",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Guthaben / Fahndungsdruck im Netzwerk / Je Dealer.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerHub = {
                    label = "Unternehmensnetzwerk / Guthaben / Fahndungsdruck im Netzwerk / Je Verteilzentrum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Guthaben / Fahndungsdruck im Netzwerk / Je Verteilzentrum.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerRoute = {
                    label = "Unternehmensnetzwerk / Guthaben / Fahndungsdruck im Netzwerk / Je Route",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Guthaben / Fahndungsdruck im Netzwerk / Je Route.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerStaff = {
                    label = "Unternehmensnetzwerk / Guthaben / Fahndungsdruck im Netzwerk / Je Mitarbeiter",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Guthaben / Fahndungsdruck im Netzwerk / Je Mitarbeiter.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityGain = {
                    label = "Unternehmensnetzwerk / Guthaben / Zuverlässigkeit / Zuwachs",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Guthaben / Zuverlässigkeit / Zuwachs.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityLoss = {
                    label = "Unternehmensnetzwerk / Guthaben / Zuverlässigkeit / Verlust",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Guthaben / Zuverlässigkeit / Verlust.",
                },
                drugAdvancedBusinessNetworkBalanceRouteHeatDecay = {
                    label = "Unternehmensnetzwerk / Guthaben / Route / Fahndungsdruck / Verfall",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Guthaben / Route / Fahndungsdruck / Verfall.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Gang / Menge / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Gang / Menge / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Gang / Menge / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Gang / Menge / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangMinRank = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Gang / Minimum / Rang",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Gang / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Gang / Qualität / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Gang / Qualität / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Gang / Qualität / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Gang / Qualität / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Gang / Belohnung / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Gang / Belohnung / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Gang / Belohnung / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Gang / Belohnung / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Gang / Risiko / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Gang / Risiko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Gang / Risiko / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Gang / Risiko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Menge / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Menge / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Menge / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Menge / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkMinRank = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Minimum / Rang",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Qualität / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Qualität / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Qualität / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Qualität / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Belohnung / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Belohnung / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Belohnung / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Belohnung / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Risiko / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Risiko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Risiko / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Kontaktnetzwerk / Risiko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Menge / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Menge / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Menge / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Menge / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationMinRank = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Minimum / Rang",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Qualität / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Qualität / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Qualität / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Qualität / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Belohnung / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Belohnung / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Belohnung / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Belohnung / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Risiko / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Risiko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Risiko / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Organisation / Risiko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Premium / Menge / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Premium / Menge / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Premium / Menge / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Premium / Menge / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumMinRank = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Premium / Minimum / Rang",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Premium / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Premium / Qualität / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Premium / Qualität / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Premium / Qualität / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Premium / Qualität / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Premium / Belohnung / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Premium / Belohnung / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Premium / Belohnung / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Premium / Belohnung / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Premium / Risiko / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Premium / Risiko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Premium / Risiko / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Premium / Risiko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Menge / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Menge / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Menge / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Menge / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherMinRank = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Minimum / Rang",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Qualität / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Qualität / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Qualität / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Qualität / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Belohnung / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Belohnung / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Belohnung / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Belohnung / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Risiko / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Risiko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Risiko / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Straßenverkäufer / Risiko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Menge / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Menge / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Menge / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Menge / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialMinRank = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Minimum / Rang",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Qualität / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Qualität / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Qualität / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Qualität / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Belohnung / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Belohnung / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Belohnung / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Belohnung / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Risiko / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Risiko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Risiko / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Besonders / Risiko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Menge / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Menge / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Menge / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Menge / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleMinRank = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Minimum / Rang",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Qualität / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Qualität / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Qualität / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Qualität / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Belohnung / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Belohnung / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Belohnung / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Belohnung / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Risiko / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Risiko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Risiko / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Kategorien / Großhandel / Risiko / 2.",
                },
                drugAdvancedBusinessNetworkContractsDeliveryDistance = {
                    label = "Unternehmensnetzwerk / Verträge / Zustelldistanz",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Zustelldistanz.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMax = {
                    label = "Unternehmensnetzwerk / Verträge / Dauer / Minuten / Maximum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Dauer / Minuten / Maximum.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMin = {
                    label = "Unternehmensnetzwerk / Verträge / Dauer / Minuten / Minimum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Dauer / Minuten / Minimum.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsX = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 1 / Koordinaten / X",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 1 / Koordinaten / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsY = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 1 / Koordinaten / Y",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 1 / Koordinaten / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsZ = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 1 / Koordinaten / Z",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 1 / Koordinaten / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Id = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 1 / ID",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 1 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Label = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 1 / Bezeichnung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 1 / Bezeichnung.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Region = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 1 / Region",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 1 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1RewardMultiplier = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 1 / Belohnung / Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 1 / Belohnung / Multiplikator.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Risk = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 1 / Risiko",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 1 / Risiko.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsX = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 2 / Koordinaten / X",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 2 / Koordinaten / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsY = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 2 / Koordinaten / Y",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 2 / Koordinaten / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsZ = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 2 / Koordinaten / Z",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 2 / Koordinaten / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Id = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 2 / ID",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 2 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Label = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 2 / Bezeichnung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 2 / Bezeichnung.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Region = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 2 / Region",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 2 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2RewardMultiplier = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 2 / Belohnung / Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 2 / Belohnung / Multiplikator.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Risk = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 2 / Risiko",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 2 / Risiko.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsX = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 3 / Koordinaten / X",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 3 / Koordinaten / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsY = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 3 / Koordinaten / Y",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 3 / Koordinaten / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsZ = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 3 / Koordinaten / Z",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 3 / Koordinaten / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Id = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 3 / ID",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 3 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Label = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 3 / Bezeichnung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 3 / Bezeichnung.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Region = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 3 / Region",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 3 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3RewardMultiplier = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 3 / Belohnung / Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 3 / Belohnung / Multiplikator.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Risk = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 3 / Risiko",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 3 / Risiko.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsX = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 4 / Koordinaten / X",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 4 / Koordinaten / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsY = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 4 / Koordinaten / Y",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 4 / Koordinaten / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsZ = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 4 / Koordinaten / Z",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 4 / Koordinaten / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Id = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 4 / ID",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 4 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Label = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 4 / Bezeichnung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 4 / Bezeichnung.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Region = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 4 / Region",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 4 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4RewardMultiplier = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 4 / Belohnung / Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 4 / Belohnung / Multiplikator.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Risk = {
                    label = "Unternehmensnetzwerk / Verträge / Treffen / Punkte / 4 / Risiko",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Treffen / Punkte / 4 / Risiko.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem1 = {
                    label = "Unternehmensnetzwerk / Verträge / Verhandlung / Vorschuss / Optionen / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Verhandlung / Vorschuss / Optionen / 1.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem2 = {
                    label = "Unternehmensnetzwerk / Verträge / Verhandlung / Vorschuss / Optionen / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Verhandlung / Vorschuss / Optionen / 2.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem3 = {
                    label = "Unternehmensnetzwerk / Verträge / Verhandlung / Vorschuss / Optionen / 3",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Verhandlung / Vorschuss / Optionen / 3.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAmountFlexPercent = {
                    label = "Unternehmensnetzwerk / Verträge / Verhandlung / Menge / Verhandlungsspielraum / Prozent",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Verhandlung / Menge / Verhandlungsspielraum / Prozent.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationBaseAcceptance = {
                    label = "Unternehmensnetzwerk / Verträge / Verhandlung / Grundwert / Annahme",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Verhandlung / Grundwert / Annahme.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationDeadlineFlexPercent = {
                    label = "Unternehmensnetzwerk / Verträge / Verhandlung / Frist / Verhandlungsspielraum / Prozent",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Verhandlung / Frist / Verhandlungsspielraum / Prozent.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationMaxRounds = {
                    label = "Unternehmensnetzwerk / Verträge / Verhandlung / Maximum / Runden",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Verhandlung / Maximum / Runden.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationQualityFlex = {
                    label = "Unternehmensnetzwerk / Verträge / Verhandlung / Qualität / Verhandlungsspielraum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Verhandlung / Qualität / Verhandlungsspielraum.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRejectionCooldownMinutes = {
                    label = "Unternehmensnetzwerk / Verträge / Verhandlung / Ablehnung / Cooldown-Minuten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Verhandlung / Ablehnung / Cooldown-Minuten.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRoundPressure = {
                    label = "Unternehmensnetzwerk / Verträge / Verhandlung / Runde / Druck",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Verhandlung / Runde / Druck.",
                },
                drugAdvancedBusinessNetworkContractsOfferCount = {
                    label = "Unternehmensnetzwerk / Verträge / Angebot / Anzahl",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Angebot / Anzahl.",
                },
                drugAdvancedBusinessNetworkContractsRefreshMinutes = {
                    label = "Unternehmensnetzwerk / Verträge / Aktualisierung / Minuten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verträge / Aktualisierung / Minuten.",
                },
                drugAdvancedBusinessNetworkDefaultBusinessName = {
                    label = "Unternehmensnetzwerk / Standardwert / Betriebsname",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Standardwert / Betriebsname.",
                },
                drugAdvancedBusinessNetworkDefaultRankId = {
                    label = "Unternehmensnetzwerk / Standardwert / Rang / ID",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Standardwert / Rang / ID.",
                },
                drugAdvancedBusinessNetworkDefaultStaffStyle = {
                    label = "Unternehmensnetzwerk / Standardwert / Personal / Arbeitsweise",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Standardwert / Personal / Arbeitsweise.",
                },
                drugAdvancedBusinessNetworkDefaultTransport = {
                    label = "Unternehmensnetzwerk / Standardwert / Transport",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Standardwert / Transport.",
                },
                drugAdvancedBusinessNetworkEnabled = {
                    label = "Unternehmensnetzwerk / Aktiviert",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Aktiviert.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterCapacity = {
                    label = "Unternehmensnetzwerk / Verteilzentren / Verteilzentrum / Kapazität",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verteilzentren / Verteilzentrum / Kapazität.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterPurchasePrice = {
                    label = "Unternehmensnetzwerk / Verteilzentren / Verteilzentrum / Kaufpreis",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verteilzentren / Verteilzentrum / Kaufpreis.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterSecurity = {
                    label = "Unternehmensnetzwerk / Verteilzentren / Verteilzentrum / Sicherheit",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verteilzentren / Verteilzentrum / Sicherheit.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterUpkeep = {
                    label = "Unternehmensnetzwerk / Verteilzentren / Verteilzentrum / Unterhalt",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verteilzentren / Verteilzentrum / Unterhalt.",
                },
                drugAdvancedBusinessNetworkHubsStashCapacity = {
                    label = "Unternehmensnetzwerk / Verteilzentren / Versteck / Kapazität",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verteilzentren / Versteck / Kapazität.",
                },
                drugAdvancedBusinessNetworkHubsStashPurchasePrice = {
                    label = "Unternehmensnetzwerk / Verteilzentren / Versteck / Kaufpreis",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verteilzentren / Versteck / Kaufpreis.",
                },
                drugAdvancedBusinessNetworkHubsStashSecurity = {
                    label = "Unternehmensnetzwerk / Verteilzentren / Versteck / Sicherheit",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verteilzentren / Versteck / Sicherheit.",
                },
                drugAdvancedBusinessNetworkHubsStashUpkeep = {
                    label = "Unternehmensnetzwerk / Verteilzentren / Versteck / Unterhalt",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verteilzentren / Versteck / Unterhalt.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseCapacity = {
                    label = "Unternehmensnetzwerk / Verteilzentren / Lagerhallenlabor / Kapazität",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verteilzentren / Lagerhallenlabor / Kapazität.",
                },
                drugAdvancedBusinessNetworkHubsWarehousePurchasePrice = {
                    label = "Unternehmensnetzwerk / Verteilzentren / Lagerhallenlabor / Kaufpreis",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verteilzentren / Lagerhallenlabor / Kaufpreis.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseSecurity = {
                    label = "Unternehmensnetzwerk / Verteilzentren / Lagerhallenlabor / Sicherheit",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verteilzentren / Lagerhallenlabor / Sicherheit.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseUpkeep = {
                    label = "Unternehmensnetzwerk / Verteilzentren / Lagerhallenlabor / Unterhalt",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Verteilzentren / Lagerhallenlabor / Unterhalt.",
                },
                drugAdvancedBusinessNetworkLimitsActiveContracts = {
                    label = "Unternehmensnetzwerk / Grenzwerte / Aktive Verträge",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Grenzwerte / Aktive Verträge.",
                },
                drugAdvancedBusinessNetworkLimitsHubs = {
                    label = "Unternehmensnetzwerk / Grenzwerte / Verteilzentren",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Grenzwerte / Verteilzentren.",
                },
                drugAdvancedBusinessNetworkLimitsLedgerRows = {
                    label = "Unternehmensnetzwerk / Grenzwerte / Geschäftsbuch / Einträge",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Grenzwerte / Geschäftsbuch / Einträge.",
                },
                drugAdvancedBusinessNetworkLimitsRoutes = {
                    label = "Unternehmensnetzwerk / Grenzwerte / Routen",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Grenzwerte / Routen.",
                },
                drugAdvancedBusinessNetworkLimitsStaff = {
                    label = "Unternehmensnetzwerk / Grenzwerte / Personal",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Grenzwerte / Personal.",
                },
                drugAdvancedBusinessNetworkPayoutAccount = {
                    label = "Unternehmensnetzwerk / Auszahlung / Konto",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Auszahlung / Konto.",
                },
                drugAdvancedBusinessNetworkRanksItem1Contracts = {
                    label = "Unternehmensnetzwerk / Ränge / 1 / Verträge",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 1 / Verträge.",
                },
                drugAdvancedBusinessNetworkRanksItem1Dealers = {
                    label = "Unternehmensnetzwerk / Ränge / 1 / Dealer",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 1 / Dealer.",
                },
                drugAdvancedBusinessNetworkRanksItem1Hubs = {
                    label = "Unternehmensnetzwerk / Ränge / 1 / Verteilzentren",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 1 / Verteilzentren.",
                },
                drugAdvancedBusinessNetworkRanksItem1Id = {
                    label = "Unternehmensnetzwerk / Ränge / 1 / ID",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 1 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem1Label = {
                    label = "Unternehmensnetzwerk / Ränge / 1 / Bezeichnung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 1 / Bezeichnung.",
                },
                drugAdvancedBusinessNetworkRanksItem1Routes = {
                    label = "Unternehmensnetzwerk / Ränge / 1 / Routen",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 1 / Routen.",
                },
                drugAdvancedBusinessNetworkRanksItem1Score = {
                    label = "Unternehmensnetzwerk / Ränge / 1 / Punktzahl",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 1 / Punktzahl.",
                },
                drugAdvancedBusinessNetworkRanksItem1Staff = {
                    label = "Unternehmensnetzwerk / Ränge / 1 / Personal",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 1 / Personal.",
                },
                drugAdvancedBusinessNetworkRanksItem2Contracts = {
                    label = "Unternehmensnetzwerk / Ränge / 2 / Verträge",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 2 / Verträge.",
                },
                drugAdvancedBusinessNetworkRanksItem2Dealers = {
                    label = "Unternehmensnetzwerk / Ränge / 2 / Dealer",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 2 / Dealer.",
                },
                drugAdvancedBusinessNetworkRanksItem2Hubs = {
                    label = "Unternehmensnetzwerk / Ränge / 2 / Verteilzentren",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 2 / Verteilzentren.",
                },
                drugAdvancedBusinessNetworkRanksItem2Id = {
                    label = "Unternehmensnetzwerk / Ränge / 2 / ID",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 2 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem2Label = {
                    label = "Unternehmensnetzwerk / Ränge / 2 / Bezeichnung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 2 / Bezeichnung.",
                },
                drugAdvancedBusinessNetworkRanksItem2Routes = {
                    label = "Unternehmensnetzwerk / Ränge / 2 / Routen",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 2 / Routen.",
                },
                drugAdvancedBusinessNetworkRanksItem2Score = {
                    label = "Unternehmensnetzwerk / Ränge / 2 / Punktzahl",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 2 / Punktzahl.",
                },
                drugAdvancedBusinessNetworkRanksItem2Staff = {
                    label = "Unternehmensnetzwerk / Ränge / 2 / Personal",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 2 / Personal.",
                },
                drugAdvancedBusinessNetworkRanksItem3Contracts = {
                    label = "Unternehmensnetzwerk / Ränge / 3 / Verträge",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 3 / Verträge.",
                },
                drugAdvancedBusinessNetworkRanksItem3Dealers = {
                    label = "Unternehmensnetzwerk / Ränge / 3 / Dealer",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 3 / Dealer.",
                },
                drugAdvancedBusinessNetworkRanksItem3Hubs = {
                    label = "Unternehmensnetzwerk / Ränge / 3 / Verteilzentren",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 3 / Verteilzentren.",
                },
                drugAdvancedBusinessNetworkRanksItem3Id = {
                    label = "Unternehmensnetzwerk / Ränge / 3 / ID",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 3 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem3Label = {
                    label = "Unternehmensnetzwerk / Ränge / 3 / Bezeichnung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 3 / Bezeichnung.",
                },
                drugAdvancedBusinessNetworkRanksItem3Routes = {
                    label = "Unternehmensnetzwerk / Ränge / 3 / Routen",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 3 / Routen.",
                },
                drugAdvancedBusinessNetworkRanksItem3Score = {
                    label = "Unternehmensnetzwerk / Ränge / 3 / Punktzahl",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 3 / Punktzahl.",
                },
                drugAdvancedBusinessNetworkRanksItem3Staff = {
                    label = "Unternehmensnetzwerk / Ränge / 3 / Personal",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 3 / Personal.",
                },
                drugAdvancedBusinessNetworkRanksItem4Contracts = {
                    label = "Unternehmensnetzwerk / Ränge / 4 / Verträge",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 4 / Verträge.",
                },
                drugAdvancedBusinessNetworkRanksItem4Dealers = {
                    label = "Unternehmensnetzwerk / Ränge / 4 / Dealer",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 4 / Dealer.",
                },
                drugAdvancedBusinessNetworkRanksItem4Hubs = {
                    label = "Unternehmensnetzwerk / Ränge / 4 / Verteilzentren",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 4 / Verteilzentren.",
                },
                drugAdvancedBusinessNetworkRanksItem4Id = {
                    label = "Unternehmensnetzwerk / Ränge / 4 / ID",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 4 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem4Label = {
                    label = "Unternehmensnetzwerk / Ränge / 4 / Bezeichnung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 4 / Bezeichnung.",
                },
                drugAdvancedBusinessNetworkRanksItem4Routes = {
                    label = "Unternehmensnetzwerk / Ränge / 4 / Routen",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 4 / Routen.",
                },
                drugAdvancedBusinessNetworkRanksItem4Score = {
                    label = "Unternehmensnetzwerk / Ränge / 4 / Punktzahl",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 4 / Punktzahl.",
                },
                drugAdvancedBusinessNetworkRanksItem4Staff = {
                    label = "Unternehmensnetzwerk / Ränge / 4 / Personal",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 4 / Personal.",
                },
                drugAdvancedBusinessNetworkRanksItem5Contracts = {
                    label = "Unternehmensnetzwerk / Ränge / 5 / Verträge",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 5 / Verträge.",
                },
                drugAdvancedBusinessNetworkRanksItem5Dealers = {
                    label = "Unternehmensnetzwerk / Ränge / 5 / Dealer",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 5 / Dealer.",
                },
                drugAdvancedBusinessNetworkRanksItem5Hubs = {
                    label = "Unternehmensnetzwerk / Ränge / 5 / Verteilzentren",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 5 / Verteilzentren.",
                },
                drugAdvancedBusinessNetworkRanksItem5Id = {
                    label = "Unternehmensnetzwerk / Ränge / 5 / ID",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 5 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem5Label = {
                    label = "Unternehmensnetzwerk / Ränge / 5 / Bezeichnung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 5 / Bezeichnung.",
                },
                drugAdvancedBusinessNetworkRanksItem5Routes = {
                    label = "Unternehmensnetzwerk / Ränge / 5 / Routen",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 5 / Routen.",
                },
                drugAdvancedBusinessNetworkRanksItem5Score = {
                    label = "Unternehmensnetzwerk / Ränge / 5 / Punktzahl",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 5 / Punktzahl.",
                },
                drugAdvancedBusinessNetworkRanksItem5Staff = {
                    label = "Unternehmensnetzwerk / Ränge / 5 / Personal",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Ränge / 5 / Personal.",
                },
                drugAdvancedBusinessNetworkReportDays = {
                    label = "Unternehmensnetzwerk / Berichtszeitraum / Tage",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Berichtszeitraum / Tage.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesBuyer = {
                    label = "Unternehmensnetzwerk / Route / Endpunkt / Typen / Käufer",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Route / Endpunkt / Typen / Käufer.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesContract = {
                    label = "Unternehmensnetzwerk / Route / Endpunkt / Typen / Vertrag",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Route / Endpunkt / Typen / Vertrag.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesDealer = {
                    label = "Unternehmensnetzwerk / Route / Endpunkt / Typen / Dealer",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Route / Endpunkt / Typen / Dealer.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesGang = {
                    label = "Unternehmensnetzwerk / Route / Endpunkt / Typen / Gang",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Route / Endpunkt / Typen / Gang.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesHub = {
                    label = "Unternehmensnetzwerk / Route / Endpunkt / Typen / Verteilzentrum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Route / Endpunkt / Typen / Verteilzentrum.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesLab = {
                    label = "Unternehmensnetzwerk / Route / Endpunkt / Typen / Labor",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Route / Endpunkt / Typen / Labor.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesOrganization = {
                    label = "Unternehmensnetzwerk / Route / Endpunkt / Typen / Organisation",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Route / Endpunkt / Typen / Organisation.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesPusher = {
                    label = "Unternehmensnetzwerk / Route / Endpunkt / Typen / Straßenverkäufer",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Route / Endpunkt / Typen / Straßenverkäufer.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMax = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Vertrag / Rhythmus / Minuten / Maximum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Vertrag / Rhythmus / Minuten / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMin = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Vertrag / Rhythmus / Minuten / Minimum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Vertrag / Rhythmus / Minuten / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCooldownMinimumMinutes = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Vertrag / Abklingzeit / Minimum / Minuten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Vertrag / Abklingzeit / Minimum / Minuten.",
                },
                drugAdvancedBusinessNetworkRuntimeContractFailureReliabilityLoss = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Vertrag / Fehlschlag / Zuverlässigkeit / Verlust",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Vertrag / Fehlschlag / Zuverlässigkeit / Verlust.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumCadenceMinutes = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Vertrag / Minimum / Rhythmus / Minuten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Vertrag / Minimum / Rhythmus / Minuten.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumMeetingMultiplier = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Vertrag / Minimum / Treffen / Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Vertrag / Minimum / Treffen / Multiplikator.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyGrowth = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Vertragsstrafe / Wachstum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Vertragsstrafe / Wachstum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyMultiplier = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Vertragsstrafe / Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Vertragsstrafe / Multiplikator.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityFailureCooldownMinutes = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Vertrag / Qualität / Fehlschlag / Cooldown-Minuten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Vertrag / Qualität / Fehlschlag / Cooldown-Minuten.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceBase = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Vertrag / Qualität / Preis / Grundwert",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Vertrag / Qualität / Preis / Grundwert.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceDivisor = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Vertrag / Qualität / Preis / Divisor",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Vertrag / Qualität / Preis / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossBase = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Vertrag / Zuverlässigkeit / Verlust / Grundwert",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Vertrag / Zuverlässigkeit / Verlust / Grundwert.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossMaximum = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Vertrag / Zuverlässigkeit / Verlust / Maximum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Vertrag / Zuverlässigkeit / Verlust / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossQualityWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Vertrag / Zuverlässigkeit / Verlust / Qualität / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Vertrag / Zuverlässigkeit / Verlust / Qualität / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReputationQualityWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Vertrag / Ruf / Qualität / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Vertrag / Ruf / Qualität / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsCategory = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Vertrag / Risiko / Gewichtungen / Kategorie",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Vertrag / Risiko / Gewichtungen / Kategorie.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsMeeting = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Vertrag / Risiko / Gewichtungen / Treffen",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Vertrag / Risiko / Gewichtungen / Treffen.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubCapacity = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Standardwert / Verteilzentrum / Kapazität",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Standardwert / Verteilzentrum / Kapazität.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubSecurity = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Standardwert / Verteilzentrum / Sicherheit",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Standardwert / Verteilzentrum / Sicherheit.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultMeetingRisk = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Standardwert / Treffen / Risiko",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Standardwert / Treffen / Risiko.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultQuality = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Standardwert / Qualität",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Standardwert / Qualität.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteCapacity = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Standardwert / Routenkapazität",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Standardwert / Routenkapazität.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteIntervalMinutes = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Standardwert / Route / Intervall / Minuten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Standardwert / Route / Intervall / Minuten.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteRisk = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Standardwert / Route / Risiko",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Standardwert / Route / Risiko.",
                },
                drugAdvancedBusinessNetworkRuntimeHubHeatDecay = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Fahndungsdruck / Verfall",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Fahndungsdruck / Verfall.",
                },
                drugAdvancedBusinessNetworkRuntimeHubLoadHeat = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Auslastung / Fahndungsdruck",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Auslastung / Fahndungsdruck.",
                },
                drugAdvancedBusinessNetworkRuntimeHubRaidRecoveryMinutes = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Überfall / Erholung / Minuten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Überfall / Erholung / Minuten.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostBase = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Sicherheit / Kosten / Grundwert",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Sicherheit / Kosten / Grundwert.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostPerLevel = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Sicherheit / Kosten / Je Stufe",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Sicherheit / Kosten / Je Stufe.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityMaximum = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Sicherheit / Maximum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Sicherheit / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityUpgrade = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Sicherheit / Verbesserung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Sicherheit / Verbesserung.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidHeat = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Zahlungsausfall / Fahndungsdruck",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Zahlungsausfall / Fahndungsdruck.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidSecurityLoss = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Zahlungsausfall / Sicherheit / Verlust",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Zahlungsausfall / Sicherheit / Verlust.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUpkeepIntervalHours = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Unterhalt / Intervall / Stunden",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verteilzentrum / Unterhalt / Intervall / Stunden.",
                },
                drugAdvancedBusinessNetworkRuntimeInitialReliability = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Anfangswert / Zuverlässigkeit",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Anfangswert / Zuverlässigkeit.",
                },
                drugAdvancedBusinessNetworkRuntimeMaximumBusinessNameLength = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Maximum / Betriebsname / Länge",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Maximum / Betriebsname / Länge.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumContractDeliveryMinutes = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Minimum / Vertrag / Zustellung / Minuten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Minimum / Vertrag / Zustellung / Minuten.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumDeliveryDistance = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Minimum / Zustelldistanz",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Minimum / Zustelldistanz.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumLedgerRows = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Minimum / Geschäftsbuch / Einträge",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Minimum / Geschäftsbuch / Einträge.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumRouteIntervalMinutes = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Minimum / Route / Intervall / Minuten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Minimum / Route / Intervall / Minuten.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvanceCostWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Vorschuss / Kosten / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Vorschuss / Kosten / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvancePriceWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Vorschuss / Preis / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Vorschuss / Preis / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountCostWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Menge / Kosten / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Menge / Kosten / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountFlexMaximum = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Menge / Verhandlungsspielraum / Maximum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Menge / Verhandlungsspielraum / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountRiskWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Menge / Risiko / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Menge / Risiko / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationCounterOfferWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Gegenangebot / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Gegenangebot / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationDeadlineFlexMaximum = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Frist / Verhandlungsspielraum / Maximum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Frist / Verhandlungsspielraum / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMaximumAcceptance = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Maximum / Annahme",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Maximum / Annahme.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMinimumAcceptance = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Minimum / Annahme",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Minimum / Annahme.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityBenefitWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Qualität / Nutzen / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Qualität / Nutzen / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityCostWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Qualität / Kosten / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Qualität / Kosten / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityFlexMaximum = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Qualität / Verhandlungsspielraum / Maximum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Qualität / Verhandlungsspielraum / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityRewardWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Qualität / Belohnung / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Qualität / Belohnung / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReliabilityWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Zuverlässigkeit / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Zuverlässigkeit / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReputationWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Ruf / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Ruf / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMax = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Angeforderte Belohnung / Maximum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Angeforderte Belohnung / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMin = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Angeforderte Belohnung / Minimum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Angeforderte Belohnung / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardCostWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Belohnung / Kosten / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Belohnung / Kosten / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMax = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Belohnung / Maximum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Belohnung / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMin = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Belohnung / Minimum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Belohnung / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBase = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Dringlichkeit / Grundwert",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Dringlichkeit / Grundwert.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBenefitWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Dringlichkeit / Nutzen / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Dringlichkeit / Nutzen / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyRiskWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Dringlichkeit / Risiko / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Dringlichkeit / Risiko / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Dringlichkeit / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Verhandlung / Dringlichkeit / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeOtherFailureHeat = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Sonstige / Fehlschlag / Fahndungsdruck",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Sonstige / Fehlschlag / Fahndungsdruck.",
                },
                drugAdvancedBusinessNetworkRuntimePersonalHeatWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Persönlicher Fahndungsdruck / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Persönlicher Fahndungsdruck / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimePoliceFailureHeat = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Polizei / Fehlschlag / Fahndungsdruck",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Polizei / Fehlschlag / Fahndungsdruck.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBaseUnits = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Grundwert / Einheiten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Grundwert / Einheiten.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBulkMultiplier = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Großmenge / Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Großmenge / Multiplikator.",
                },
                drugAdvancedBusinessNetworkRuntimePusherCheapMultiplier = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Günstige Verkäufe / Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Günstige Verkäufe / Multiplikator.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerLevel = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Erfahrung / Je Stufe",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Erfahrung / Je Stufe.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerUnit = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Erfahrung / Je Einheit",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Erfahrung / Je Einheit.",
                },
                drugAdvancedBusinessNetworkRuntimePusherHubHeatPerUnit = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Verteilzentrum / Fahndungsdruck / Je Einheit",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Verteilzentrum / Fahndungsdruck / Je Einheit.",
                },
                drugAdvancedBusinessNetworkRuntimePusherPremiumMultiplier = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Premium / Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Premium / Multiplikator.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillDivisor = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Fähigkeit / Divisor",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Fähigkeit / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillGain = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Fähigkeit / Zuwachs",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Straßenverkäufer / Fähigkeit / Zuwachs.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationBaseSeconds = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Dauer / Grundwert / Sekunden",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Dauer / Grundwert / Sekunden.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationPerUnitSeconds = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Dauer / Je Einheit / Sekunden",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Dauer / Je Einheit / Sekunden.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem1 = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Fehlschlag / Ursachen / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Fehlschlag / Ursachen / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem2 = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Fehlschlag / Ursachen / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Fehlschlag / Ursachen / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem3 = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Fehlschlag / Ursachen / 3",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Fehlschlag / Ursachen / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem4 = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Fehlschlag / Ursachen / 4",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Fehlschlag / Ursachen / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureValueMultiplier = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Fehlschlag / Wert / Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Fehlschlag / Wert / Multiplikator.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatAmountDivisor = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Fahndungsdruck / Menge / Divisor",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Fahndungsdruck / Menge / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostBase = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Fahndungsdruck-Abbau / Kosten / Grundwert",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Fahndungsdruck-Abbau / Kosten / Grundwert.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostPerHeat = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Fahndungsdruck-Abbau / Kosten / Je Fahndungspunkt",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Fahndungsdruck-Abbau / Kosten / Je Fahndungspunkt.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMaximum = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Risiko / Maximum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Risiko / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMinimum = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Risiko / Minimum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Risiko / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsHeat = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Risiko / Gewichtungen / Fahndungsdruck",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Risiko / Gewichtungen / Fahndungsdruck.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsLoyalty = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Risiko / Gewichtungen / Loyalität",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Risiko / Gewichtungen / Loyalität.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsRunnerRisk = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Risiko / Gewichtungen / Kurier / Risiko",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Risiko / Gewichtungen / Kurier / Risiko.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsSkill = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Risiko / Gewichtungen / Fähigkeit",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Risiko / Gewichtungen / Fähigkeit.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationHeatReduction = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Routenwechsel / Fahndungsdruck-Abbau",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Routenwechsel / Fahndungsdruck-Abbau.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationRiskReduction = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Routenwechsel / Risiko / Verringerung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Routenwechsel / Risiko / Verringerung.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityBase = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Verkauf / Basisqualität",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Verkauf / Basisqualität.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityDivisor = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Verkauf / Qualität / Divisor",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Verkauf / Qualität / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleRiskDivisor = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Verkauf / Risiko / Divisor",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Verkauf / Risiko / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteStartHeat = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Route / Beginn / Fahndungsdruck",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Route / Beginn / Fahndungsdruck.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerLevel = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Kurier / Erfahrung / Je Stufe",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Kurier / Erfahrung / Je Stufe.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerUnit = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Kurier / Erfahrung / Je Einheit",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Kurier / Erfahrung / Je Einheit.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureLoyaltyLoss = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Kurier / Fehlschlag / Loyalität / Verlust",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Kurier / Fehlschlag / Loyalität / Verlust.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureRiskGain = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Kurier / Fehlerrisiko / Zuwachs",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Kurier / Fehlerrisiko / Zuwachs.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerSkillGain = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Kurier / Fähigkeit / Zuwachs",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Kurier / Fähigkeit / Zuwachs.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsHeat = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Punktzahl / Gewichtungen / Fahndungsdruck",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Punktzahl / Gewichtungen / Fahndungsdruck.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReliability = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Punktzahl / Gewichtungen / Zuverlässigkeit",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Punktzahl / Gewichtungen / Zuverlässigkeit.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReputation = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Punktzahl / Gewichtungen / Ruf",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Punktzahl / Gewichtungen / Ruf.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsStructure = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Punktzahl / Gewichtungen / Struktur",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Punktzahl / Gewichtungen / Struktur.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffCapacityBaseMultiplier = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Kapazität / Grundwert / Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Kapazität / Grundwert / Multiplikator.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMax = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Einstellung / Loyalität / Maximum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Einstellung / Loyalität / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMin = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Einstellung / Loyalität / Minimum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Einstellung / Loyalität / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMax = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Einstellung / Risiko / Maximum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Einstellung / Risiko / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMin = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Einstellung / Risiko / Minimum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Einstellung / Risiko / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMax = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Einstellung / Fähigkeit / Maximum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Einstellung / Fähigkeit / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMin = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Einstellung / Fähigkeit / Minimum",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Einstellung / Fähigkeit / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentLoyaltyWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Zwischenfall / Loyalität / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Zwischenfall / Loyalität / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentMaximumChance = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Zwischenfall / Maximum / Chance",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Zwischenfall / Maximum / Chance.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem1 = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Zwischenfall / Ergebnisse / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Zwischenfall / Ergebnisse / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem2 = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Zwischenfall / Ergebnisse / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Zwischenfall / Ergebnisse / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem3 = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Zwischenfall / Ergebnisse / 3",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Zwischenfall / Ergebnisse / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem4 = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Zwischenfall / Ergebnisse / 4",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Zwischenfall / Ergebnisse / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentRiskWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Zwischenfall / Risiko / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Zwischenfall / Risiko / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffLoyaltyDecay = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Loyalität / Verfall",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Loyalität / Verfall.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffMaximumLevel = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Maximum / Stufe",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Maximum / Stufe.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffPoachedLoyaltyLoss = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Loyalitätsverlust durch Abwerbung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Loyalitätsverlust durch Abwerbung.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionCostBase = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Schutz / Kosten / Grundwert",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Schutz / Kosten / Grundwert.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionHours = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Schutz / Stunden",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Schutz / Stunden.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionIncidentReduction = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Schutz / Zwischenfall / Verringerung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Schutz / Zwischenfall / Verringerung.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionRiskCost = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Schutz / Risiko / Kosten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Schutz / Risiko / Kosten.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryBaseChance = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Erholung / Grundwert / Chance",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Erholung / Grundwert / Chance.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryLoyaltyWeight = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Erholung / Loyalität / Gewichtung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Erholung / Loyalität / Gewichtung.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageBaseMultiplier = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Lohn / Grundwert / Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Lohn / Grundwert / Multiplikator.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageLoyaltyGain = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Lohn / Loyalität / Zuwachs",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Lohn / Loyalität / Zuwachs.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageSkillDivisor = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Lohn / Fähigkeit / Divisor",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Lohn / Fähigkeit / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem1 = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Schwachstellen / 1",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Schwachstellen / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem2 = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Schwachstellen / 2",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Schwachstellen / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem3 = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Schwachstellen / 3",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Schwachstellen / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem4 = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Schwachstellen / 4",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Schwachstellen / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem5 = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Schwachstellen / 5",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Schwachstellen / 5.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem6 = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Personal / Schwachstellen / 6",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Personal / Schwachstellen / 6.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsContracts = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Struktur / Gewichtungen / Verträge",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Struktur / Gewichtungen / Verträge.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsDealers = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Struktur / Gewichtungen / Dealer",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Struktur / Gewichtungen / Dealer.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsHubs = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Struktur / Gewichtungen / Verteilzentren",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Struktur / Gewichtungen / Verteilzentren.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsRoutes = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Struktur / Gewichtungen / Routen",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Struktur / Gewichtungen / Routen.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsStaff = {
                    label = "Unternehmensnetzwerk / Spielbetrieb / Struktur / Gewichtungen / Personal",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Spielbetrieb / Struktur / Gewichtungen / Personal.",
                },
                drugAdvancedBusinessNetworkSocietyPermission = {
                    label = "Unternehmensnetzwerk / Organisation / Berechtigung",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Organisation / Berechtigung.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseCapacity = {
                    label = "Unternehmensnetzwerk / Personal / Straßenverkäufer / Grundwert / Kapazität",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Personal / Straßenverkäufer / Grundwert / Kapazität.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseWage = {
                    label = "Unternehmensnetzwerk / Personal / Straßenverkäufer / Grundwert / Lohn",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Personal / Straßenverkäufer / Grundwert / Lohn.",
                },
                drugAdvancedBusinessNetworkStaffPusherCommission = {
                    label = "Unternehmensnetzwerk / Personal / Straßenverkäufer / Provision",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Personal / Straßenverkäufer / Provision.",
                },
                drugAdvancedBusinessNetworkStaffPusherHirePrice = {
                    label = "Unternehmensnetzwerk / Personal / Straßenverkäufer / Einstellung / Preis",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Personal / Straßenverkäufer / Einstellung / Preis.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseCapacity = {
                    label = "Unternehmensnetzwerk / Personal / Kurier / Grundwert / Kapazität",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Personal / Kurier / Grundwert / Kapazität.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseWage = {
                    label = "Unternehmensnetzwerk / Personal / Kurier / Grundwert / Lohn",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Personal / Kurier / Grundwert / Lohn.",
                },
                drugAdvancedBusinessNetworkStaffRunnerCommission = {
                    label = "Unternehmensnetzwerk / Personal / Kurier / Provision",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Personal / Kurier / Provision.",
                },
                drugAdvancedBusinessNetworkStaffRunnerHirePrice = {
                    label = "Unternehmensnetzwerk / Personal / Kurier / Einstellung / Preis",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Personal / Kurier / Einstellung / Preis.",
                },
                drugAdvancedBusinessNetworkTickMinutes = {
                    label = "Unternehmensnetzwerk / Aktualisierungsschritt / Minuten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Aktualisierungsschritt / Minuten.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCapacity = {
                    label = "Unternehmensnetzwerk / Transporte / Flugzeug / Kapazität",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Flugzeug / Kapazität.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCost = {
                    label = "Unternehmensnetzwerk / Transporte / Flugzeug / Kosten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Flugzeug / Kosten.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftDurationMultiplier = {
                    label = "Unternehmensnetzwerk / Transporte / Flugzeug / Dauer-Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Flugzeug / Dauer-Multiplikator.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftRisk = {
                    label = "Unternehmensnetzwerk / Transporte / Flugzeug / Risiko",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Flugzeug / Risiko.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCapacity = {
                    label = "Unternehmensnetzwerk / Transporte / Boot / Kapazität",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Boot / Kapazität.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCost = {
                    label = "Unternehmensnetzwerk / Transporte / Boot / Kosten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Boot / Kosten.",
                },
                drugAdvancedBusinessNetworkTransportsBoatDurationMultiplier = {
                    label = "Unternehmensnetzwerk / Transporte / Boot / Dauer-Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Boot / Dauer-Multiplikator.",
                },
                drugAdvancedBusinessNetworkTransportsBoatRisk = {
                    label = "Unternehmensnetzwerk / Transporte / Boot / Risiko",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Boot / Risiko.",
                },
                drugAdvancedBusinessNetworkTransportsCarCapacity = {
                    label = "Unternehmensnetzwerk / Transporte / Auto / Kapazität",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Auto / Kapazität.",
                },
                drugAdvancedBusinessNetworkTransportsCarCost = {
                    label = "Unternehmensnetzwerk / Transporte / Auto / Kosten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Auto / Kosten.",
                },
                drugAdvancedBusinessNetworkTransportsCarDurationMultiplier = {
                    label = "Unternehmensnetzwerk / Transporte / Auto / Dauer-Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Auto / Dauer-Multiplikator.",
                },
                drugAdvancedBusinessNetworkTransportsCarRisk = {
                    label = "Unternehmensnetzwerk / Transporte / Auto / Risiko",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Auto / Risiko.",
                },
                drugAdvancedBusinessNetworkTransportsFootCapacity = {
                    label = "Unternehmensnetzwerk / Transporte / Zu Fuß / Kapazität",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Zu Fuß / Kapazität.",
                },
                drugAdvancedBusinessNetworkTransportsFootCost = {
                    label = "Unternehmensnetzwerk / Transporte / Zu Fuß / Kosten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Zu Fuß / Kosten.",
                },
                drugAdvancedBusinessNetworkTransportsFootDurationMultiplier = {
                    label = "Unternehmensnetzwerk / Transporte / Zu Fuß / Dauer-Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Zu Fuß / Dauer-Multiplikator.",
                },
                drugAdvancedBusinessNetworkTransportsFootRisk = {
                    label = "Unternehmensnetzwerk / Transporte / Zu Fuß / Risiko",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Zu Fuß / Risiko.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCapacity = {
                    label = "Unternehmensnetzwerk / Transporte / LKW / Kapazität",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / LKW / Kapazität.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCost = {
                    label = "Unternehmensnetzwerk / Transporte / LKW / Kosten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / LKW / Kosten.",
                },
                drugAdvancedBusinessNetworkTransportsTruckDurationMultiplier = {
                    label = "Unternehmensnetzwerk / Transporte / LKW / Dauer-Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / LKW / Dauer-Multiplikator.",
                },
                drugAdvancedBusinessNetworkTransportsTruckRisk = {
                    label = "Unternehmensnetzwerk / Transporte / LKW / Risiko",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / LKW / Risiko.",
                },
                drugAdvancedBusinessNetworkTransportsVanCapacity = {
                    label = "Unternehmensnetzwerk / Transporte / Transporter / Kapazität",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Transporter / Kapazität.",
                },
                drugAdvancedBusinessNetworkTransportsVanCost = {
                    label = "Unternehmensnetzwerk / Transporte / Transporter / Kosten",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Transporter / Kosten.",
                },
                drugAdvancedBusinessNetworkTransportsVanDurationMultiplier = {
                    label = "Unternehmensnetzwerk / Transporte / Transporter / Dauer-Multiplikator",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Transporter / Dauer-Multiplikator.",
                },
                drugAdvancedBusinessNetworkTransportsVanRisk = {
                    label = "Unternehmensnetzwerk / Transporte / Transporter / Risiko",
                    description = "Konfigurationswert für Unternehmensnetzwerk / Transporte / Transporter / Risiko.",
                },
                interrogationDispatchAdapter = {
                    options = {
                        sky_jobs_base = "Sky Jobs Base",
                        generic = "Allgemeine Anbindung",
                        custom = "Eigene Anbindung",
                        none = "Deaktiviert",
                    },
                },
                reputationRules = {
                    label = "Reputationsregeln",
                    description = "Benannte Regeln für Aktionen und optionale Ziele festlegen. Nur aktivierte Regeln vergeben Punkte.",
                },
            },
            territoryMap = {
                addPoint = "Punkt hinzufügen",
                clear = "Leeren",
                create = "Erstellen",
                custom = "Eigene Gebiete",
                deletePoint = "Punkt löschen",
                eyebrow = "Gebietseditor",
                minimum = "Mindestens 3",
                pointCount = "{count} Punkte",
                presets = "Vordefinierte Bezirke",
                shown = "Auf der Karte anzeigen",
                street = "Straße",
                supply = "Versorgung",
                territories = "Gebiete",
                type = "Gebietstyp",
                undo = "Rückgängig",
            },
            shopPositionTools = {
                currentPosition = "Eigene Position",
                selectEntity = "Entity auswählen",
                selectEntityHint = "Mit dem Laser auf Kasse oder Tresor zielen. Enter: Position und Ausrichtung des umrandeten Objekts übernehmen. Rücktaste: abbrechen.",
            },
            drugSettingSubsections = {
                cultivationLevels = "Anbau-Level",
                general = "Allgemein",
                runtime = "Zugriff auf Spielaktionen",
                quality = "Qualität",
                packaging = "Verpackung",
                growing = "Anbau",
                labs = "Labore & Wohnmobile",
                power = "Stromversorgung & Ausrüstung",
                workers = "Mitarbeiter",
                market = "Markt & Vertrieb",
                threats = "Razzien & Sabotage",
                pvpTakeovers = "Laborübernahmen",
                consumption = "Konsum",
                processing = "Verarbeitung",
                performance = "Leistung",
                dynamicMarket = "Dynamischer Markt",
                heat = "Fahndungsdruck & Risiko",
                contacts = "Kontaktnetzwerk",
                business = "Unternehmensnetzwerk",
            },
            drugSettingGroups = {
                cultivationGeneral = {
                    label = "Allgemein",
                },
                cultivationCurve = {
                    label = "Levelkurve",
                },
                cultivationExperience = {
                    label = "XP-Belohnungen",
                },
                cultivationUnlocks = {
                    label = "Level-Freischaltungen",
                },
                creator = {
                    label = "Editor öffnen",
                },
                creatorSettings = {
                    label = "Editor-Einstellungen",
                },
                interfaceHud = {
                    label = "UI-Locations",
                },
                drugsGeneral = {
                    label = "Allgemein",
                },
                runtimeAccess = {
                    label = "Zugriff & Eigentum",
                },
                runtimePayouts = {
                    label = "Auszahlungen",
                },
                runtimeDispatch = {
                    label = "Leitstelle & Polizei",
                },
                qualityWeights = {
                    label = "Qualität / Gewichtungen",
                },
                qualityTiers = {
                    label = "Qualität / Qualitätsstufen",
                },
                packagingGeneral = {
                    label = "Allgemein",
                },
                growingGeneral = {
                    label = "Allgemein",
                },
                plantDefaults = {
                    label = "Pflanze / Standardwerte",
                },
                harvestWindow = {
                    label = "Ernte / Zeitfenster",
                },
                labsGeneral = {
                    label = "Allgemein",
                },
                labRent = {
                    label = "Miete & Laufzeit",
                },
                camperDefaults = {
                    label = "Wohnmobil",
                },
                labUpgrades = {
                    label = "Verbesserungen",
                },
                labDefaults = {
                    label = "Labor / Standardwerte",
                },
                powerGeneral = {
                    label = "Allgemein",
                },
                generators = {
                    label = "Generatoren",
                },
                equipmentWear = {
                    label = "Ausstattung",
                },
                workersGeneral = {
                    label = "Allgemein",
                },
                marketGeneral = {
                    label = "Allgemein",
                },
                marketPrices = {
                    label = "Preise",
                },
                distribution = {
                    label = "Vertrieb",
                },
                threatsGeneral = {
                    label = "Allgemein",
                },
                threatHeat = {
                    label = "Fahndungsdruck",
                },
                threatChances = {
                    label = "Wahrscheinlichkeiten",
                },
                pvpTakeoverRules = {
                    label = "Übernahmeregeln",
                },
                pvpTakeoverZones = {
                    label = "Gebiete & Zeiten",
                },
                pvpTakeoverMethods = {
                    label = "Einbruchsmethoden",
                },
                consumptionGeneral = {
                    label = "Allgemein",
                },
                consumerDecay = {
                    label = "Abbau von Toleranz & Abhängigkeit",
                },
                consumerEffects = {
                    label = "Wirkungen & Risiken",
                },
                processingFlow = {
                    label = "Verarbeitungsablauf",
                },
                processingGeneral = {
                    label = "Allgemein",
                },
                powerRuntime = {
                    label = "Spielbetrieb",
                },
                powerHeat = {
                    label = "Fahndungsdruck & Stromsignatur",
                },
                powerModes = {
                    label = "Verwaltung / Modi",
                },
                powerPriorities = {
                    label = "Auslastung / Prioritäten",
                },
                performanceInactiveControlIntervalMs = {
                    label = "Inaktiv / Steuerung / Intervall / ms",
                },
                performanceInteractionIdleScanIntervalMs = {
                    label = "Interaktion / Leerlauf / Prüfintervall / ms",
                },
                performanceInteractionPromptIntervalMs = {
                    label = "Interaktion / Interaktionshinweis / Intervall / ms",
                },
                performanceInteractionScanIntervalMs = {
                    label = "Interaktion / Prüfintervall / ms",
                },
                performanceMinimumScanIntervalMs = {
                    label = "Minimum / Prüfintervall / ms",
                },
                performanceStreetPedActivationDistance = {
                    label = "Straße / NPC / Aktivierung / Entfernung",
                },
                performanceStreetPedIdleScanIntervalMs = {
                    label = "Straße / NPC / Leerlauf / Prüfintervall / ms",
                },
                performanceStreetPedScanIntervalMs = {
                    label = "Straße / NPC / Prüfintervall / ms",
                },
                performanceWorldCachePadding = {
                    label = "Welt / Zwischenspeicher / Zusatzabstand",
                },
                performanceWorldCacheRefreshIntervalMs = {
                    label = "Welt / Zwischenspeicher / Aktualisierung / Intervall / ms",
                },
                performanceWorldIdleIntervalMs = {
                    label = "Welt / Leerlauf / Intervall / ms",
                },
                dynamicMarketActionCooldownSeconds = {
                    label = "Aktions-Cooldown / Sekunden",
                },
                dynamicMarketActionHistoryLimit = {
                    label = "Aktion / Historienlimit",
                },
                dynamicMarketAmountSaturationWeight = {
                    label = "Menge / Marktsättigung / Gewichtung",
                },
                dynamicMarketBaseIntelAccuracy = {
                    label = "Grundwert / Informationsgenauigkeit",
                },
                dynamicMarketDefaultAverageQuality = {
                    label = "Standardwert / Durchschnitt / Qualität",
                },
                dynamicMarketDefaultResourceElasticity = {
                    label = "Standardwert / Rohstoff / Elastizität",
                },
                dynamicMarketDemandCenter = {
                    label = "Nachfrage / Mittelwert",
                },
                dynamicMarketDemandPriceImpact = {
                    label = "Nachfrage / Preis / Einfluss",
                },
                dynamicMarketDirectionThreshold = {
                    label = "Richtung / Schwellenwert",
                },
                dynamicMarketEnabled = {
                    label = "Aktiviert",
                },
                dynamicMarketEventChance = {
                    label = "Ereignis / Chance",
                },
                dynamicMarketEventDurationMinutes = {
                    label = "Ereignis / Dauer / Minuten",
                },
                dynamicMarketEventMinimumDurationMinutes = {
                    label = "Ereignis / Minimum / Dauer / Minuten",
                },
                dynamicMarketEventStrengthMaximum = {
                    label = "Ereignis / Stärke / Maximum",
                },
                dynamicMarketEventStrengthMinimum = {
                    label = "Ereignis / Stärke / Minimum",
                },
                dynamicMarketEvents = {
                    label = "Ereignisse",
                },
                dynamicMarketExactIntelReputation = {
                    label = "Genaue Informationen / Ruf",
                },
                dynamicMarketExactIntelTrust = {
                    label = "Genaue Informationen / Vertrauen",
                },
                dynamicMarketGlobalZoneLabel = {
                    label = "Global / Zone / Bezeichnung",
                },
                dynamicMarketHistoryLimit = {
                    label = "Historienlimit",
                },
                dynamicMarketInitialDemand = {
                    label = "Anfangswert / Nachfrage",
                },
                dynamicMarketInitialPriceMultiplier = {
                    label = "Anfangswert / Preismultiplikator",
                },
                dynamicMarketIntelDemandError = {
                    label = "Informationen / Nachfrage / Fehler",
                },
                dynamicMarketIntelMaximumAccuracy = {
                    label = "Informationen / Maximum / Genauigkeit",
                },
                dynamicMarketIntelMinimumAccuracy = {
                    label = "Informationen / Minimum / Genauigkeit",
                },
                dynamicMarketIntelPoliceError = {
                    label = "Informationen / Polizei / Fehler",
                },
                dynamicMarketIntelPriceError = {
                    label = "Informationen / Preis / Fehler",
                },
                dynamicMarketIntelPriceMaximum = {
                    label = "Informationen / Preis / Maximum",
                },
                dynamicMarketIntelPriceMinimum = {
                    label = "Informationen / Preis / Minimum",
                },
                dynamicMarketIntelReputationWeight = {
                    label = "Informationen / Ruf / Gewichtung",
                },
                dynamicMarketIntelResourcePriceError = {
                    label = "Informationen / Rohstoff / Preis / Fehler",
                },
                dynamicMarketIntelSaturationError = {
                    label = "Informationen / Marktsättigung / Fehler",
                },
                dynamicMarketIntelSeedBucketSeconds = {
                    label = "Zeitfenster für den Informations-Zufallswert / Sekunden",
                },
                dynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Informationen / Status / Genauigkeit / Schwellenwert",
                },
                dynamicMarketIntelStatusErrorThreshold = {
                    label = "Informationen / Status / Fehler / Schwellenwert",
                },
                dynamicMarketIntelSupplyError = {
                    label = "Informationen / Versorgung / Fehler",
                },
                dynamicMarketIntelTrustWeight = {
                    label = "Informationen / Vertrauen / Gewichtung",
                },
                dynamicMarketManipulationCooldownMinutes = {
                    label = "Manipulation / Cooldown-Minuten",
                },
                dynamicMarketManipulationDemandShift = {
                    label = "Manipulation / Nachfrage / Verschiebung",
                },
                dynamicMarketManipulationDurationMinutes = {
                    label = "Manipulation / Dauer / Minuten",
                },
                dynamicMarketManipulationHeat = {
                    label = "Manipulation / Fahndungsdruck",
                },
                dynamicMarketManipulationMinimumBatchAmount = {
                    label = "Manipulation / Minimum / Charge / Menge",
                },
                dynamicMarketManipulationPaymentAccount = {
                    label = "Manipulation / Zahlungskonto",
                },
                dynamicMarketManipulationPrice = {
                    label = "Manipulation / Preis",
                },
                dynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Manipulation / Zone / Fahndungsdruck / Multiplikator",
                },
                dynamicMarketMaximumIntelAgeMinutes = {
                    label = "Maximum / Informationsalter / Minuten",
                },
                dynamicMarketMaximumPriceMultiplier = {
                    label = "Maximum / Preismultiplikator",
                },
                dynamicMarketMinimumIntelAgeMinutes = {
                    label = "Minimum / Informationsalter / Minuten",
                },
                dynamicMarketMinimumMetricWindowMinutes = {
                    label = "Minimum / Messwert / Zeitfenster / Minuten",
                },
                dynamicMarketMinimumPriceMultiplier = {
                    label = "Mindestpreis / Multiplikator",
                },
                dynamicMarketMinimumUpdateMinutes = {
                    label = "Minimum / Aktualisierung / Minuten",
                },
                dynamicMarketPoliceDemandWeight = {
                    label = "Polizei / Nachfrage / Gewichtung",
                },
                dynamicMarketPolicePriceImpact = {
                    label = "Polizei / Preis / Einfluss",
                },
                dynamicMarketPoorQualityDemandPenalty = {
                    label = "Schlechte Qualität / Nachfrage / Abzug",
                },
                dynamicMarketPoorQualityThreshold = {
                    label = "Schlechte Qualität / Schwellenwert",
                },
                dynamicMarketPremiumQualityDemandBonus = {
                    label = "Premiumqualität / Nachfragebonus",
                },
                dynamicMarketPremiumQualityThreshold = {
                    label = "Premiumqualität / Schwellenwert",
                },
                dynamicMarketProductionSupplyWeight = {
                    label = "Produktion / Versorgung / Gewichtung",
                },
                dynamicMarketProductionWindowMinutes = {
                    label = "Produktion / Zeitfenster / Minuten",
                },
                dynamicMarketQualityCenter = {
                    label = "Qualität / Mittelwert",
                },
                dynamicMarketQualityConfidenceImpact = {
                    label = "Qualität / Verlässlichkeit / Einfluss",
                },
                dynamicMarketQualityRange = {
                    label = "Qualität / Wertebereich",
                },
                dynamicMarketRarityBonusMaximum = {
                    label = "Seltenheit / Bonus / Maximum",
                },
                dynamicMarketRegionalGlobalWeight = {
                    label = "Regional / Global / Gewichtung",
                },
                dynamicMarketRegionalLocalWeight = {
                    label = "Regional / Lokal / Gewichtung",
                },
                dynamicMarketResourceAliases = {
                    label = "Rohstoff / Alternative Bezeichnungen",
                },
                dynamicMarketResourceDirectionFallThreshold = {
                    label = "Rohstoff / Richtung / Rückgang / Schwellenwert",
                },
                dynamicMarketResourceDirectionRiseThreshold = {
                    label = "Rohstoff / Richtung / Anstieg / Schwellenwert",
                },
                dynamicMarketResources = {
                    label = "Rohstoffe",
                },
                dynamicMarketSalesWindowMinutes = {
                    label = "Verkäufe / Zeitfenster / Minuten",
                },
                dynamicMarketSaturationDemandWeight = {
                    label = "Marktsättigung / Nachfrage / Gewichtung",
                },
                dynamicMarketSaturationPriceImpact = {
                    label = "Marktsättigung / Preis / Einfluss",
                },
                dynamicMarketScarcityDemandWeight = {
                    label = "Knappheit / Nachfrage / Gewichtung",
                },
                dynamicMarketScarcityPriceImpact = {
                    label = "Knappheit / Preis / Einfluss",
                },
                dynamicMarketSeasonEndMonths = {
                    label = "Jahreszeit / Ende / Monate",
                },
                dynamicMarketSeasonMultipliers = {
                    label = "Jahreszeit / Multiplikatoren",
                },
                dynamicMarketShortageRumorThreshold = {
                    label = "Engpass / Gerücht / Schwellenwert",
                },
                dynamicMarketStatusThresholds = {
                    label = "Status / Schwellenwerte",
                },
                dynamicMarketTargetSupply = {
                    label = "Ziel / Versorgung",
                },
                dynamicMarketTrendChance = {
                    label = "Trend / Chance",
                },
                dynamicMarketTrendDurationMinutes = {
                    label = "Trend / Dauer / Minuten",
                },
                dynamicMarketTrendMaximumStrength = {
                    label = "Trend / Maximum / Stärke",
                },
                dynamicMarketTrendMinimumStrength = {
                    label = "Trend / Minimum / Stärke",
                },
                dynamicMarketUpdateMinutes = {
                    label = "Aktualisierung / Minuten",
                },
                dynamicMarketVolatilityMaximum = {
                    label = "Preisschwankung / Maximum",
                },
                dynamicMarketVolatilityMinimum = {
                    label = "Preisschwankung / Minimum",
                },
                dynamicMarketWeatherMultipliers = {
                    label = "Wetter / Multiplikatoren",
                },
                dynamicMarketWeatherState = {
                    label = "Wetter / Status",
                },
                heatActionCooldownSeconds = {
                    label = "Aktions-Cooldown / Sekunden",
                },
                heatActivityRiskWeights = {
                    label = "Aktivität / Risiko / Gewichtungen",
                },
                heatAggressiveHeatMultiplier = {
                    label = "Aggressive Arbeitsweise / Fahndungsdruck / Multiplikator",
                },
                heatBurnerBurnThreshold = {
                    label = "Wegwerftelefon / Enttarnung / Schwellenwert",
                },
                heatBurnerHeatPerWholesale = {
                    label = "Wegwerftelefon / Fahndungsdruck / Je Großhandelsgeschäft",
                },
                heatBurnerPhoneItem = {
                    label = "Wegwerfhandy / Gegenstand",
                },
                heatCamperOperationalHeatMultiplier = {
                    label = "Wohnmobil im Betrieb / Fahndungsdruck / Multiplikator",
                },
                heatCamperOperationalHeatThreshold = {
                    label = "Wohnmobil im Betrieb / Fahndungsdruck / Schwellenwert",
                },
                heatCamperParkedHeat = {
                    label = "Geparktes Wohnmobil / Fahndungsdruck",
                },
                heatContaminatedHeatMultiplier = {
                    label = "Verunreinigung / Fahndungsdruck / Multiplikator",
                },
                heatContaminatedThreshold = {
                    label = "Verunreinigung / Schwellenwert",
                },
                heatCultivationFreePlants = {
                    label = "Anbau / Pflanzen ohne Risikozuschlag",
                },
                heatCultivationHeatPerPlant = {
                    label = "Anbau / Fahndungsdruck / Je Pflanze",
                },
                heatDealerHiddenMinutes = {
                    label = "Dealer / versteckt / Minuten",
                },
                heatDecayPerTick = {
                    label = "Verfall / Je Aktualisierungsschritt",
                },
                heatEnabled = {
                    label = "Aktiviert",
                },
                heatEnforcementHeat = {
                    label = "Polizeipräsenz / Fahndungsdruck",
                },
                heatEnforcementMultipliers = {
                    label = "Polizeipräsenz / Multiplikatoren",
                },
                heatEntityTypes = {
                    label = "Spielobjekt / Typen",
                },
                heatEventCooldownMinutes = {
                    label = "Ereignis / Cooldown-Minuten",
                },
                heatEventHistoryLimit = {
                    label = "Ereignis / Historienlimit",
                },
                heatLabHeatSyncThreshold = {
                    label = "Labor / Fahndungsdruck / Abgleich / Schwellenwert",
                },
                heatLayLowCooldownMinutes = {
                    label = "Untertauchen / Cooldown-Minuten",
                },
                heatLayLowIdleMinutes = {
                    label = "Untertauchen / Leerlauf / Minuten",
                },
                heatLayLowReduction = {
                    label = "Untertauchen / Verringerung",
                },
                heatLockdownMinutes = {
                    label = "Abriegelung / Minuten",
                },
                heatMinimumDurationMinutes = {
                    label = "Minimum / Dauer / Minuten",
                },
                heatMinimumEventCooldownSeconds = {
                    label = "Minimum / Ereignis / Abklingzeit (Sekunden)",
                },
                heatMinimumIdleSeconds = {
                    label = "Minimum / Leerlauf / Sekunden",
                },
                heatProcessingHeatMultiplier = {
                    label = "Verarbeitung / Fahndungsdruck / Multiplikator",
                },
                heatRiskWeights = {
                    label = "Risiko / Gewichtungen",
                },
                heatRotateBurnerReduction = {
                    label = "Wegwerftelefon wechseln / Verringerung",
                },
                heatRouteControlMinutes = {
                    label = "Route / Steuerung / Minuten",
                },
                heatSaleHeat = {
                    label = "Verkauf / Fahndungsdruck",
                },
                heatThresholds = {
                    label = "Schwellenwerte",
                },
                heatTickMinutes = {
                    label = "Aktualisierungsschritt / Minuten",
                },
                heatWholesaleHeatMultiplier = {
                    label = "Großhandel / Fahndungsdruck / Multiplikator",
                },
                heatWorkerLeakAlertRadius = {
                    label = "Mitarbeiter / Informationsleck / Alarmradius",
                },
                heatWorkerLeakBaseChance = {
                    label = "Mitarbeiter / Informationsleck / Grundwert / Chance",
                },
                heatWorkerLeakFactionMultiplier = {
                    label = "Mitarbeiter / Informationsleck / Fraktion / Multiplikator",
                },
                heatWorkerLeakHighSeverityThreshold = {
                    label = "Mitarbeiter / Informationsleck / Hoch / Schweregrad / Schwellenwert",
                },
                heatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Mitarbeiter / Informationsleck / Loyalität / Chance / Multiplikator",
                },
                heatWorkerLeakLoyaltyThreshold = {
                    label = "Mitarbeiter / Informationsleck / Loyalität / Schwellenwert",
                },
                heatWorkerLeakMaximumChance = {
                    label = "Mitarbeiter / Informationsleck / Maximum / Chance",
                },
                heatWorkerLeakMinimumCooldownSeconds = {
                    label = "Mitarbeiter / Informationsleck / Minimum / Abklingzeit (Sekunden)",
                },
                heatWorkerLeakRouteMultiplier = {
                    label = "Mitarbeiter / Informationsleck / Route / Multiplikator",
                },
                heatWorkerLeakStrengthMaximum = {
                    label = "Mitarbeiter / Informationsleck / Stärke / Maximum",
                },
                heatWorkerLeakStrengthMinimum = {
                    label = "Mitarbeiter / Informationsleck / Stärke / Minimum",
                },
                heatWorkerLeakStrengthMultiplier = {
                    label = "Mitarbeiter / Informationsleck / Stärke / Multiplikator",
                },
                heatWorkerLeakStressChanceMultiplier = {
                    label = "Mitarbeiter / Informationsleck / Stress / Chance / Multiplikator",
                },
                heatWorkerLeakStressThreshold = {
                    label = "Mitarbeiter / Informationsleck / Stress / Schwellenwert",
                },
                contactsActionCooldownSeconds = {
                    label = "Aktions-Cooldown / Sekunden",
                },
                contactsActiveHotspotCount = {
                    label = "Anzahl aktiver Brennpunkte",
                },
                contactsBurnerHintTrust = {
                    label = "Wegwerfhandy-Hinweis / Vertrauen",
                },
                contactsBurnerOfferMaximumMultiplier = {
                    label = "Wegwerftelefon / Angebot / Maximum / Multiplikator",
                },
                contactsBurnerOfferMinimumMultiplier = {
                    label = "Wegwerftelefon / Angebot / Minimum / Multiplikator",
                },
                contactsBuyerCooldownMinutes = {
                    label = "Käufer / Cooldown-Minuten",
                },
                contactsBuyerDeliveryDistance = {
                    label = "Käufer / Zustelldistanz",
                },
                contactsBuyerPremiumSuccessScore = {
                    label = "Käufer / Premium / Erfolg / Punktzahl",
                },
                contactsBuyerPremiumTrustGain = {
                    label = "Käufer / Premium / Vertrauen / Zuwachs",
                },
                contactsBuyerRequestHeatRiskWeight = {
                    label = "Käufer / Anfrage / Fahndungsdruck und Risiko / Gewichtung",
                },
                contactsBuyerStandardTrustGain = {
                    label = "Käufer / Standard / Vertrauen / Zuwachs",
                },
                contactsContactActiveDelaySeconds = {
                    label = "Wartezeit bis zur Kontaktaktivierung / Sekunden",
                },
                contactsContactDemandRange = {
                    label = "Kontakt / Nachfrage / Wertebereich",
                },
                contactsContactLossTrust = {
                    label = "Kontakt / Verlust / Vertrauen",
                },
                contactsDarknetExactIntelMinutes = {
                    label = "Darknet / Genaue Informationen / Minuten",
                },
                contactsDarknetHotspotIntelPrice = {
                    label = "Darknet / Brennpunkt / Informationen / Preis",
                },
                contactsDarknetIntelPrice = {
                    label = "Darknet / Informationen / Preis",
                },
                contactsDealerBasePrice = {
                    label = "Dealer / Grundpreis",
                },
                contactsDealerHireCapacity = {
                    label = "Dealer / Einstellung / Kapazität",
                },
                contactsDealerHireRisk = {
                    label = "Dealer / Einstellung / Risiko",
                },
                contactsDealerHireSkill = {
                    label = "Dealer / Einstellung / Fähigkeit",
                },
                contactsDealerOffers = {
                    label = "Dealer-Angebote",
                },
                contactsDealerProtectionHours = {
                    label = "Dealer / Schutz / Stunden",
                },
                contactsDealerProtectionPrice = {
                    label = "Dealer / Schutz / Preis",
                },
                contactsDealerSaleMax = {
                    label = "Dealer / Verkauf / Maximum",
                },
                contactsDealerSaleMin = {
                    label = "Dealer / Verkauf / Minimum",
                },
                contactsDealerSimulation = {
                    label = "Dealer / Simulation",
                },
                contactsDealerTickMinutes = {
                    label = "Dealer / Aktualisierungsschritt / Minuten",
                },
                contactsDealerWage = {
                    label = "Dealer / Lohn",
                },
                contactsDealerWageDecay = {
                    label = "Dealer / Lohn / Verfall",
                },
                contactsDealerWageLoyaltyGain = {
                    label = "Dealer / Lohn / Loyalität / Zuwachs",
                },
                contactsDealerWeaknesses = {
                    label = "Dealer / Schwachstellen",
                },
                contactsDefaultContactDemand = {
                    label = "Standardwert / Kontakt / Nachfrage",
                },
                contactsDefaultContactRisk = {
                    label = "Standardwert / Kontakt / Risiko",
                },
                contactsDefaultDealerCapacity = {
                    label = "Standarddealer / Kapazität",
                },
                contactsDefaultDealerRisk = {
                    label = "Standarddealer / Risiko",
                },
                contactsDefaultDealerSkill = {
                    label = "Standarddealer / Fähigkeit",
                },
                contactsDefaultHotspotRadius = {
                    label = "Standardwert / Brennpunkt / Radius",
                },
                contactsDemandResetMinutes = {
                    label = "Nachfrage zurücksetzen (Minuten)",
                },
                contactsEnabled = {
                    label = "Aktiviert",
                },
                contactsExactLocationTrust = {
                    label = "Genauer Standort / Vertrauen",
                },
                contactsFactionDiscoveryReputation = {
                    label = "Fraktion / Entdeckung / Ruf",
                },
                contactsFactionHintTrust = {
                    label = "Fraktion / Hinweis / Vertrauen",
                },
                contactsFailedDeliveryCooldownMinutes = {
                    label = "Fehlgeschlagene Lieferung / Cooldown-Minuten",
                },
                contactsFakeDealEncounter = {
                    label = "Vorgetäuschtes Geschäft / Begegnung",
                },
                contactsFallbackPreferredDrug = {
                    label = "Ersatzwert / Bevorzugte Droge",
                },
                contactsFallbackProductLabel = {
                    label = "Ersatzwert / Produktbezeichnung",
                },
                contactsGuideBookItem = {
                    label = "Anleitung / Buch / Gegenstand",
                },
                contactsGuideBookTrust = {
                    label = "Anleitung / Buch / Vertrauen",
                },
                contactsHireDealerPrice = {
                    label = "Dealer anheuern / Preis",
                },
                contactsHistoryLimit = {
                    label = "Historienlimit",
                },
                contactsHotspotIntelMinutes = {
                    label = "Brennpunkt / Informationen / Minuten",
                },
                contactsHotspotRotationMinutes = {
                    label = "Brennpunkt / Wechsel / Minuten",
                },
                contactsListingDurationMinutes = {
                    label = "Angebot / Dauer / Minuten",
                },
                contactsMaxOwnedDealers = {
                    label = "Maximum / Im Besitz / Dealer",
                },
                contactsMinimumBuyerDeliveryDistance = {
                    label = "Minimum / Käufer / Zustelldistanz",
                },
                contactsMinimumContactRotationMinutes = {
                    label = "Minimum / Kontaktrotation (Minuten)",
                },
                contactsMinimumDemandResetMinutes = {
                    label = "Minimum / Nachfrage zurücksetzen (Minuten)",
                },
                contactsMinimumHeatMultiplier = {
                    label = "Minimum / Fahndungsdruck / Multiplikator",
                },
                contactsMinimumHotspotIntelMinutes = {
                    label = "Minimum / Brennpunkt / Informationen / Minuten",
                },
                contactsMinimumHotspotRadius = {
                    label = "Minimum / Brennpunkt / Radius",
                },
                contactsMinimumHotspotRotationMinutes = {
                    label = "Minimum / Brennpunkt / Wechsel / Minuten",
                },
                contactsMinimumListingDurationMinutes = {
                    label = "Minimum / Angebot / Dauer / Minuten",
                },
                contactsMinimumRewardMultiplier = {
                    label = "Minimale Belohnung / Multiplikator",
                },
                contactsMinimumRobberyMultiplier = {
                    label = "Minimum / Raubüberfälle / Multiplikator",
                },
                contactsMinimumSpotPriceMultiplier = {
                    label = "Minimum / Standort / Preismultiplikator",
                },
                contactsOtherDrugPriceMultiplier = {
                    label = "Sonstige / Droge / Preismultiplikator",
                },
                contactsPaymentAccount = {
                    label = "Zahlungskonto",
                },
                contactsPostDeliveryDemandResetSeconds = {
                    label = "Nach der Lieferung / Nachfrage / Zurücksetzen / Sekunden",
                },
                contactsPreferredDrugPriceMultiplier = {
                    label = "Bevorzugte Droge / Preismultiplikator",
                },
                contactsRegionLocationTrust = {
                    label = "Region / Ort / Vertrauen",
                },
                contactsRequestAmounts = {
                    label = "Anfrage / Mengen",
                },
                contactsRotationMinutes = {
                    label = "Wechsel / Minuten",
                },
                contactsSpotPools = {
                    label = "Standort / Auswahlpools",
                },
                contactsStreetHotspots = {
                    label = "Straße / Brennpunkte",
                },
                contactsTrustLevels = {
                    label = "Vertrauen / Stufen",
                },
                businessActionCooldownSeconds = {
                    label = "Aktions-Cooldown / Sekunden",
                },
                businessBalance = {
                    label = "Guthaben",
                },
                businessContracts = {
                    label = "Verträge",
                },
                businessDefaultBusinessName = {
                    label = "Standardwert / Betriebsname",
                },
                businessDefaultRankId = {
                    label = "Standardwert / Rang / ID",
                },
                businessDefaultStaffStyle = {
                    label = "Standardwert / Personal / Arbeitsweise",
                },
                businessDefaultTransport = {
                    label = "Standardwert / Transport",
                },
                businessEnabled = {
                    label = "Aktiviert",
                },
                businessHubs = {
                    label = "Verteilzentren",
                },
                businessLimits = {
                    label = "Grenzwerte",
                },
                businessPayments = {
                    label = "Zahlungen",
                },
                businessPayoutAccount = {
                    label = "Auszahlung / Konto",
                },
                businessRanks = {
                    label = "Ränge",
                },
                businessReportDays = {
                    label = "Berichtszeitraum / Tage",
                },
                businessRouteEndpointTypes = {
                    label = "Route / Endpunkt / Typen",
                },
                businessRuntime = {
                    label = "Spielbetrieb",
                },
                businessSocietyPermission = {
                    label = "Organisation / Berechtigung",
                },
                businessStaff = {
                    label = "Personal",
                },
                businessTickMinutes = {
                    label = "Aktualisierungsschritt / Minuten",
                },
                businessTransports = {
                    label = "Transporte",
                },
            },
            territorySettings = {
                section = "Territorien",
                zonesGroup = "Territoriumszonen",
                sourceLabel = "Zonenquelle",
                sourceDescription = "Verwende die geschützten Bezirksvorlagen oder definiere eigene Territoriumspolygone.",
                sourcePreset = "Vordefinierte Bezirke",
                sourceCustom = "Eigene Territorien",
                editLabel = "Territorien-Editor",
                editDescription = "Bearbeite die Bezirke der ausgewählten Zonenquelle.",
                editButton = "Territorien bearbeiten",
                presetSection = "Vordefinierte Bezirke",
                presetEntry = "Vordefinierter Bezirk",
                customSection = "Eigene Territorien",
                customEntry = "Eigenes Territorium",
                typeLabel = "Territoriumstyp",
                streetType = "Straße",
                supplyType = "Versorgung",
                enabledLabel = "Auf Karte anzeigen",
                enabledDescription = "Deaktivierte Bezirke werden von der Karte entfernt und können nicht beansprucht werden.",
                zoneLabel = "Territoriumsgrenze",
                zoneDescription = "Setze mindestens drei Punkte der Reihe nach entlang der Territoriumsgrenze.",
                ownershipGroup = "Besitz",
                decayGroup = "Verfall",
                presenceGroup = "Präsenz",
                activityGroup = "Aktivitätswertung",
                ownershipBenefitsGroup = "Besitzboni",
                ownershipThresholdLabel = "Besitzschwelle",
                ownershipThresholdDescription = "Kontrollanteil, den eine Gang überschreiten muss, um ein Territorium offiziell zu besitzen.",
                activityFloorLabel = "Feste Aktivitätsgrenze",
                activityFloorDescription = "Benötigte Einflusspunkte, wenn größenbasierte Grenzen deaktiviert sind.",
                floorByZoneSizeLabel = "Grenze nach Zonengröße skalieren",
                floorByZoneSizeDescription = "Berechnet die Aktivitätsgrenze aus der Polygonfläche statt die feste Grenze zu verwenden.",
                floorPointsPerSizeUnitLabel = "Grenzpunkte pro km²",
                floorPointsPerSizeUnitDescription = "Benötigte Aktivitätspunkte pro Quadratkilometer Territoriumsfläche.",
                fixedFloorRequirement = "Deaktiviere größenbasierte Grenzen, um die feste Aktivitätsgrenze zu bearbeiten.",
                sizeFloorRequirement = "Aktiviere größenbasierte Grenzen, um Punkte pro Quadratkilometer zu bearbeiten.",
                dailyDecayLabel = "Täglicher Einflussverfall",
                dailyDecayDescription = "Prozentualer Einflussverlust innerhalb von 24 Stunden.",
                presenceIntervalLabel = "Präsenzintervall",
                presenceIntervalDescription = "Minuten zwischen automatischen Präsenzvergaben.",
                presencePointsLabel = "Präsenzpunkte pro Mitglied",
                presencePointsDescription = "Präsenzpunkte für jedes berechtigte Gangmitglied pro Intervall.",
                drugSalesEnabledLabel = "NPC-Verkäufe geben Gebietseinfluss",
                drugSalesEnabledDescription = "Erfolgreiche Straßenverkäufe an NPCs geben der Gang des Verkäufers Einfluss im aktuellen Straßenterritorium.",
                drugSalePointsLabel = "Punkte pro verkaufter Droge",
                drugSalePointsDescription = "Einflusspunkte für jede als verkauft gemeldete Drogeneinheit.",
                drugSalesRequirement = "Aktiviere den Gebietseinfluss durch NPC-Verkäufe, um die Punkte einzustellen.",
                graffitiPointsLabel = "Graffiti-Punkte pro 24 Stunden",
                graffitiPointsDescription = "Präsenzpunkte, wenn ein Graffiti insgesamt 24 gemeldete Stunden existiert hat.",
                streetSellingPriceBonusLabel = "Verkaufspreisbonus in Straßenterritorien",
                streetSellingPriceBonusDescription = "Prozentualer Bonus auf Drogenverkaufspreise für den offiziellen Besitzer eines Straßenterritoriums.",
                supplyProductionSpeedBonusLabel = "Produktionsgeschwindigkeitsbonus in Versorgungsterritorien",
                supplyProductionSpeedBonusDescription = "Prozentualer Bonus auf die Drogenproduktionsgeschwindigkeit für den offiziellen Besitzer eines Versorgungsterritoriums.",
                pruneToleranceLabel = "Toleranz für Einflussbereinigung",
                pruneToleranceDescription = "Effektiver Einfluss unter diesem Wert wird als null behandelt.",
            },
            graffitiSettings = {
                section = "Graffiti",
                generalGroup = "Allgemein",
                streamingGroup = "Darstellung",
                moderationGroup = "Moderation",
                graffitiEnabledLabel = "Graffiti aktivieren",
                graffitiEnabledDescription = "Erlaubt Spielern, Graffiti zu sprühen und zu sehen.",
                graffitiRequireItemLabel = "Sprühdose erforderlich",
                graffitiRequireItemDescription = "Spieler benötigen eine Sprühdose zum Sprühen. Sonst wird der /graffiti-Befehl genutzt.",
                graffitiChargesPerCanLabel = "Ladungen pro Dose",
                graffitiChargesPerCanDescription = "Wie viele Graffiti mit einer einzelnen Sprühdose gesprüht werden können.",
                graffitiCooldownSecondsLabel = "Sprüh-Abklingzeit",
                graffitiCooldownSecondsDescription = "Sekunden, die ein Spieler zwischen zwei Graffiti warten muss.",
                graffitiMaxPerPlayerLabel = "Max. Graffiti pro Spieler",
                graffitiMaxPerPlayerDescription = "Maximale Anzahl aktiver Graffiti pro Spieler. 0 bedeutet unbegrenzt.",
                graffitiMaxDistanceLabel = "Max. Sprühdistanz",
                graffitiMaxDistanceDescription = "Wie weit eine Wand entfernt sein darf, um noch darauf zu sprühen, in Metern.",
                graffitiSprayDurationLabel = "Sprühdauer",
                graffitiSprayDurationDescription = "Wie lange die Sprüh-Animation dauert, in Millisekunden.",
                graffitiExpiryDaysLabel = "Ablaufzeit",
                graffitiExpiryDaysDescription = "Tage, bis ein Graffiti automatisch verschwindet. 0 bedeutet nie.",
                graffitiTerritoryHoursLabel = "Territoriumsstunden pro Graffiti",
                graffitiTerritoryHoursDescription = "Territoriums-Präsenzstunden, die ein frisches Graffiti seiner Gang gewährt.",
                graffitiStreamRadiusLabel = "Streaming-Radius",
                graffitiStreamRadiusDescription = "Entfernung in Metern, ab der Graffiti für Spieler sichtbar wird.",
                graffitiPoolSizeLabel = "Decal-Poolgröße",
                graffitiPoolSizeDescription = "Wie viele Graffiti gleichzeitig gerendert werden. Höhere Werte kosten mehr Leistung.",
                graffitiReportsEnabledLabel = "Meldungen aktivieren",
                graffitiReportsEnabledDescription = "Erlaubt Spielern, anstößige Graffiti zu melden.",
                graffitiAutoHideThresholdLabel = "Schwelle zum automatischen Ausblenden",
                graffitiAutoHideThresholdDescription = "Anzahl an Meldungen, die ein Graffiti automatisch ausblendet. 0 deaktiviert dies.",
            },
            darknetSettings = {
                section = "Darknet-Marktplatz",
                availabilityGroup = "Verfügbarkeit",
                economyGroup = "Kryptowährung",
                listingsGroup = "Anzeigen und Ablauf",
                chatGroup = "Privater Chat",
                identityGroup = "Aliase und Reputation",
                deliveryGroup = "Übergaben und Dead Drops",
                policeGroup = "Polizeizugriff",
                npcGroup = "NPC-Händler",
                enabledLabel = "Darknet-Marktplatz aktivieren",
                enabledDescription = "Aktiviert die Schwarzmarkt-App im Tablet und ihre Laufzeitlogik.",
                tabletOrderLabel = "Tablet-App-Reihenfolge",
                tabletOrderDescription = "Bestimmt die Position des Darknet-Marktplatzes im Tablet.",
                currencyCodeLabel = "Währungskürzel",
                currencyCodeDescription = "Kurzes Kürzel für die interne Kryptowährung.",
                starterBalanceLabel = "Startguthaben neuer Wallets",
                starterBalanceDescription = "Kryptoguthaben, das nur beim allerersten Öffnen des Marktplatzes vergeben wird.",
                exchangeEnabledLabel = "Coin-Wechsel aktivieren",
                exchangeEnabledDescription = "Erlaubt angemeldeten BlackBay-Nutzern, Coins auf ihrer Kontoseite zu kaufen und zu verkaufen.",
                exchangeAccountLabel = "Zahlungskonto für Coin-Wechsel",
                exchangeAccountDescription = "Framework-Konto für Coin-Käufe und Auszahlungen aus Coin-Verkäufen.",
                exchangeBuyPriceLabel = "Kaufpreis pro Coin",
                exchangeBuyPriceDescription = "Betrag, der für einen Coin vom Zahlungskonto abgezogen wird.",
                exchangeSellPriceLabel = "Verkaufspreis pro Coin",
                exchangeSellPriceDescription = "Betrag, der für einen Coin auf das Zahlungskonto ausgezahlt wird.",
                exchangeMinimumLabel = "Minimale Coins pro Wechsel",
                exchangeMinimumDescription = "Kleinste ganze Coin-Menge, die in einem Wechsel akzeptiert wird.",
                exchangeMaximumLabel = "Maximale Coins pro Wechsel",
                exchangeMaximumDescription = "Größte ganze Coin-Menge, die in einem Wechsel akzeptiert wird.",
                accountMoney = "Bargeld",
                accountBank = "Bank",
                accountBlackMoney = "Schwarzgeld",
                scamChanceLabel = "Globale NPC-Betrugswahrscheinlichkeit (%)",
                scamChanceDescription = "Mindestwahrscheinlichkeit, dass ein NPC bei einem Handel die Zahlung oder Ware nimmt, ohne die Gegenleistung zu liefern. Ein höherer Händlerwert gilt weiterhin.",
                listingExpiryLabel = "Anzeigenlaufzeit (Stunden)",
                listingExpiryDescription = "Aktive Anzeigen laufen nach dieser Zeit automatisch aus.",
                renewalHoursLabel = "Verlängerungsdauer (Stunden)",
                renewalHoursDescription = "Zeit, die beim Verlängern einer Anzeige hinzugefügt wird.",
                maximumListingsLabel = "Maximale aktive Anzeigen",
                maximumListingsDescription = "Maximale Anzeigenanzahl pro aktivem Alias.",
                maximumQuantityLabel = "Maximale Warenmenge",
                maximumQuantityDescription = "Obergrenze der Warenmenge in einer Anzeige.",
                maximumPriceLabel = "Maximaler Stückpreis",
                maximumPriceDescription = "Maximaler Kryptopreis für ein Stück.",
                maximumMessageLengthLabel = "Maximale Nachrichtenlänge",
                maximumMessageLengthDescription = "Maximale Zeichenzahl einer verschlüsselten Chatnachricht.",
                aliasCooldownLabel = "Aliaswechsel-Cooldown (Stunden)",
                aliasCooldownDescription = "Mindestalter einer Identität, bevor sie erneut stillgelegt werden kann.",
                verifiedSalesLabel = "Verkäufe für Verifizierung",
                verifiedSalesDescription = "Benötigte erfolgreiche Verkäufe für einen verifizierten Verkäufer.",
                verifiedRatingLabel = "Bewertung für Verifizierung",
                verifiedRatingDescription = "Benötigte Durchschnittsbewertung für einen verifizierten Verkäufer.",
                scammerReportsLabel = "Meldungen für Betrügerwarnung",
                scammerReportsDescription = "Eindeutige Handelsmeldungen für das Abzeichen als bekannter Betrüger.",
                meetingDistanceLabel = "Übergabedistanz",
                meetingDistanceDescription = "Maximale Entfernung zwischen beiden Spielern oder zum NPC-Punkt.",
                dropModelLabel = "Dead-Drop-Kistenmodell",
                dropModelDescription = "GTA-Propmodell für verfügbare Dead Drops.",
                dropStreamLabel = "Dead-Drop-Sichtweite",
                dropStreamDescription = "Distanz, in der Kisten und NPC-Kontakte geladen werden.",
                dropInteractionLabel = "Dead-Drop-Interaktionsdistanz",
                dropInteractionDescription = "Erforderliche Distanz zum Durchsuchen einer Kiste.",
                dropLifetimeLabel = "Dead-Drop-Laufzeit (Stunden)",
                dropLifetimeDescription = "Zeit, nach der eine nicht abgeholte Kiste abläuft.",
                dropPollLabel = "Welt-Aktualisierung (ms)",
                dropPollDescription = "Intervall zum Aktualisieren naher Kisten und NPC-Treffen.",
                policeGroupsLabel = "Berechtigte Polizeigruppen",
                policeGroupsDescription = "Job-Configurator-Gruppenschlüssel für Lockangebote und Ermittlungen.",
                policeGroupEntry = "Polizeigruppe",
                groupKeyLabel = "Gruppenschlüssel",
                npcTradersLabel = "NPC-Käufer und -Verkäufer",
                npcTradersDescription = "Konfiguriert dauerhafte NPC-Anzeigen, Übergabeart, Reputation und Betrugswahrscheinlichkeit.",
                npcTraderEntry = "NPC-Händler",
                npcIdLabel = "ID",
                npcAliasLabel = "Alias",
                npcSideLabel = "Marktseite",
                sideSell = "Verkauft an Spieler",
                sideBuy = "Kauft von Spielern",
                npcTitleLabel = "Anzeigentitel",
                npcDescriptionLabel = "Beschreibung",
                npcItemNameLabel = "Inventar-Itemname",
                npcItemLabelLabel = "Warenname",
                npcQuantityLabel = "Menge",
                npcPriceLabel = "Stückpreis",
                npcDeliveryLabel = "Übergabeart",
                deliveryBoth = "Treffen und Dead Drop",
                deliveryMeeting = "Nur persönliches Treffen",
                deliveryDrop = "Nur Dead Drop",
                npcScamChanceLabel = "Händler-Betrugswahrscheinlichkeit (%)",
                npcPedModelLabel = "NPC-Pedmodell",
                npcRatingLabel = "Angezeigte Bewertung",
                npcRatingCountLabel = "Angezeigte Bewertungsanzahl",
                npcTradesLabel = "Angezeigte abgeschlossene Geschäfte",
                npcVerifiedLabel = "Verifizierter Händler",
                npcScammerLabel = "Bekannter Betrüger",
                npcEnabledLabel = "Aktiv",
            },
            interrogationSettings = {
                section = "Verhör",
                generalGroup = "Allgemein",
                consentGroup = "Spielerschutz",
                objectGroup = "Objekte",
                grabGroup = "Überwältigen",
                sessionGroup = "Ablauf",
                dispatchGroup = "Polizeimeldungen",
                loggingGroup = "Protokollierung",
                securityGroup = "Sicherheit",
                presentationGroup = "Darstellung",
                enabledLabel = "Verhörsystem aktivieren",
                enabledDescription = "Erlaubt Spielern, andere an Verhörstühle zu fesseln und Werkzeuge einzusetzen.",
                consentRequiredLabel = "Einwilligung erforderlich",
                consentRequiredDescription = "Nur Spieler mit erteilter Einwilligung können verhört werden. Es gibt keine separate Funktion zum Zustimmen; verwende dafür die Einstellung darunter.",
                consentDefaultLabel = "Standardmäßig zugestimmt",
                consentDefaultDescription = "Neue Charaktere starten mit erteilter statt verweigerter Einwilligung.",
                globalIntensityLabel = "Effektstärke",
                globalIntensityDescription = "Skaliert Bildschirmeffekte, Partikel und Sound. 0 schaltet sie ganz ab.",
                maxPerPlayerLabel = "Objekte pro Spieler",
                maxPerPlayerDescription = "Wie viele Stühle und Wagen ein Spieler platziert haben darf. 0 bedeutet unbegrenzt.",
                maxGlobalLabel = "Objekte serverweit",
                maxGlobalDescription = "Wie viele platzierte Objekte insgesamt erlaubt sind. 0 bedeutet unbegrenzt.",
                placementDistanceLabel = "Platzierungsdistanz",
                placementDistanceDescription = "Wie weit vom Spieler entfernt ein Objekt platziert werden darf, in Metern.",
                interactDistanceLabel = "Interaktionsdistanz",
                interactDistanceDescription = "Wie nah ein Spieler an Stuhl oder Wagen stehen muss, in Metern.",
                inactivityMinutesLabel = "Automatisch entfernen nach",
                inactivityMinutesDescription = "Minuten ohne Nutzung, bis ein platziertes Objekt verschwindet. 0 behält es dauerhaft.",
                persistObjectsLabel = "Objekte über Neustart behalten",
                persistObjectsDescription = "Platzierte Objekte werden nach einem Serverneustart aus der Datenbank wiederhergestellt.",
                grabEnabledLabel = "Überwältigen aktivieren",
                grabEnabledDescription = "Erlaubt Spielern, andere zu überwältigen und wegzuschaffen.",
                grabItemLabel = "Benötigtes Item",
                grabItemDescription = "Item, das der Täter zum Überwältigen braucht. Leer lassen für keins.",
                grabAngleLabel = "Annäherungswinkel",
                grabAngleDescription = "Wie weit seitlich von direkt hinter der Person der Täter stehen darf, in Grad.",
                grabHealthBelowLabel = "Gesundheitsschwelle",
                grabHealthBelowDescription = "Ein Opfer unter diesem Wert kann ungefesselt überwältigt werden. 0 deaktiviert das.",
                grabCooldownLabel = "Abklingzeit nach Fehlschlag",
                grabCooldownDescription = "Sekunden bis zum nächsten Versuch nach einem misslungenen Überwältigen.",
                grabVehiclesLabel = "Erlaubte Fahrzeuge",
                grabVehiclesDescription = "Fahrzeugmodelle, in die ein überwältigtes Opfer geladen werden kann.",
                carryEnabledLabel = "Tragen erlauben",
                carryEnabledDescription = "Der Täter kann das Opfer über der Schulter tragen.",
                restrictVisionLabel = "Sicht des Opfers einschränken",
                restrictVisionDescription = "Blendet den Bildschirm des Opfers während des Transports ab.",
                escapeEnabledLabel = "Fluchtversuche erlauben",
                escapeEnabledDescription = "Ein transportiertes Opfer kann versuchen, sich loszureißen.",
                escapeSecondsLabel = "Fluchtdauer",
                escapeSecondsDescription = "Sekunden, die das Opfer die Taste halten muss, um sich zu befreien.",
                maxDurationLabel = "Höchstdauer",
                maxDurationDescription = "Minuten, nach denen ein Verhör von selbst endet.",
                warnMinutesLabel = "Warnung vor dem Ende",
                warnMinutesDescription = "Minuten vor dem Limit, ab denen beide Seiten gewarnt werden.",
                idleMinutesLabel = "Freigabe bei Untätigkeit",
                idleMinutesDescription = "Minuten ohne jede Interaktion, bis das Opfer freigegeben wird.",
                selfReleaseMinutesLabel = "Selbstbefreiung nach",
                selfReleaseMinutesDescription = "Minuten ohne Täter-Interaktion, bis sich das Opfer selbst befreien kann.",
                graceSecondsLabel = "Frist nach Verbindungsabbruch",
                graceSecondsDescription = "Sekunden, die das Opfer gefesselt bleibt, wenn der Täter den Server verlässt.",
                rescueEnabledLabel = "Befreiung erlauben",
                rescueEnabledDescription = "Unbeteiligte Spieler können ein gefesseltes Opfer befreien.",
                rescueSecondsLabel = "Befreiungsdauer",
                rescueSecondsDescription = "Sekunden, die ein Retter zum Losschneiden braucht.",
                rescueItemLabel = "Befreiungs-Item",
                rescueItemDescription = "Item, das ein Retter braucht. Leer lassen für keins.",
                allowInventoryLabel = "Opfer behält Inventar",
                allowInventoryDescription = "Ein gefesseltes Opfer kann sein Inventar weiterhin öffnen.",
                dispatchEnabledLabel = "Polizeimeldungen aktivieren",
                dispatchEnabledDescription = "Meldet Entführungen und Verhöre an die Einsatzkräfte.",
                dispatchAdapterLabel = "Meldesystem",
                dispatchAdapterDescription = "Welches Dispatch-System die Meldungen erhält.",
                dispatchJobsLabel = "Empfangende Jobs",
                dispatchJobsDescription = "Jobs, die die Meldung bekommen.",
                dispatchGrabChanceLabel = "Wahrscheinlichkeit beim Überwältigen",
                dispatchGrabChanceDescription = "Prozentuale Chance, dass ein Überwältigen gemeldet wird.",
                dispatchFixateChanceLabel = "Wahrscheinlichkeit beim Fesseln",
                dispatchFixateChanceDescription = "Prozentuale Chance, dass das Fesseln an einen Stuhl gemeldet wird.",
                dispatchToolChanceLabel = "Wahrscheinlichkeit bei Werkzeugeinsatz",
                dispatchToolChanceDescription = "Prozentuale Chance, dass ein Werkzeugeinsatz gemeldet wird.",
                dispatchWitnessLabel = "Zeuge erforderlich",
                dispatchWitnessDescription = "Nur melden, wenn ein anderer Spieler nah genug ist, um etwas mitzubekommen.",
                dispatchWitnessRadiusLabel = "Zeugenradius",
                dispatchWitnessRadiusDescription = "Wie nah ein Zeuge sein muss, in Metern.",
                dispatchCooldownLabel = "Abklingzeit für Meldungen",
                dispatchCooldownDescription = "Sekunden zwischen zwei Meldungen aus demselben Verhör.",
                dispatchInaccuracyLabel = "Positionsungenauigkeit",
                dispatchInaccuracyDescription = "Meter, um die die gemeldete Position zufällig versetzt wird. 0 meldet den genauen Punkt.",
                loggingEnabledLabel = "Protokollierung aktivieren",
                loggingEnabledDescription = "Zeichnet Platzierungen, Überwältigungen, Werkzeugeinsatz, Freilassungen und Admin-Eingriffe auf.",
                logDatabaseLabel = "In Datenbank protokollieren",
                logDatabaseDescription = "Schreibt jeden Eintrag zusätzlich in die Verhör-Protokolltabelle.",
                logRetentionLabel = "Protokolle aufbewahren",
                logRetentionDescription = "Tage, bis Datenbank-Protokolle gelöscht werden. 0 behält sie dauerhaft.",
                pingToleranceLabel = "Distanztoleranz",
                pingToleranceDescription = "Meter, die jeder serverseitigen Distanzprüfung zugeschlagen werden, um Lag abzufangen.",
                violationThresholdLabel = "Schwelle für Verstöße",
                violationThresholdDescription = "Sicherheitsverstöße im Zeitfenster, bis die Reaktion greift. 0 deaktiviert sie.",
                violationActionLabel = "Reaktion auf Verstöße",
                violationActionDescription = "Was passiert, sobald ein Spieler die Verstoßschwelle überschreitet.",
                violationActionNone = "Nichts tun",
                violationActionLog = "Nur protokollieren",
                violationActionKick = "Kicken",
                violationActionCheating = "Als Cheating melden",
                particlesLabel = "Partikeleffekte",
                particlesDescription = "Zeigt Blut, Funken und Flammen beim Werkzeugeinsatz.",
                soundLabel = "Soundeffekte",
                soundDescription = "Spielt Werkzeuggeräusche für alle in der Nähe ab.",
                cameraWorkLabel = "Kameraführung",
                cameraWorkDescription = "Bewegt die Kamera beim Fesseln und während des Werkzeugeinsatzes.",
                screenEffectsLabel = "Bildschirmeffekte",
                screenEffectsDescription = "Erschütterung, Aufblenden, Unschärfe und Farbfilter auf dem Bildschirm des Opfers.",
                objectsSection = "Verhörobjekte",
                objectsEntry = "Objekt",
                objectsEditLabel = "Verhörobjekte",
                objectsEditDescription = "Dauerhafte Stühle und Werkzeugwagen auf der Karte platzieren.",
                objectsEditButton = "Objekte bearbeiten",
                objectsKindLabel = "Objektart",
                objectsKindChair = "Stuhl",
                objectsKindCart = "Werkzeugwagen",
                objectsModelLabel = "Prop-Modell",
                objectsPositionLabel = "Platzieren",
                blockedZonesSection = "Sperrzonen",
                blockedZonesEntry = "Gebiet",
                blockedZonesEditLabel = "Sperrzonen",
                blockedZonesEditDescription = "Bereiche, in denen kein Verhörobjekt platziert werden darf.",
                blockedZonesEditButton = "Zonen bearbeiten",
                blockedZonesZoneLabel = "Zonenumriss",
                blockedZonesZoneDescription = "Ecken verschieben, um den Bereich abzustecken, in dem nicht platziert werden darf.",
                toolsSection = "Werkzeuge",
                toolsEntry = "Werkzeug",
                toolsEditLabel = "Werkzeuge",
                toolsEditDescription = "Werkzeuge anlegen oder anpassen, die am Opfer eingesetzt werden können.",
                toolsEditButton = "Werkzeuge bearbeiten",
                toolsItemLabel = "Benötigtes Item",
                toolsConsumeLabel = "Item verbrauchen",
                toolsDamageLabel = "Schaden pro Einsatz",
                toolsHealthFloorLabel = "Gesundheits-Untergrenze",
                toolsCooldownLabel = "Abklingzeit in Sekunden",
                toolsProgressLabel = "Fortschritt pro Einsatz",
                sessionsSection = "Laufende Verhöre",
                sessionsEntry = "Verhör",
                sessionsEditLabel = "Laufende Verhöre",
                sessionsEditDescription = "Zeigt laufende Verhöre und ermöglicht es, sie bei Bedarf zu beenden.",
                sessionsEditButton = "Verhöre anzeigen",
                sessionsStateLabel = "Status",
                sessionsProgressLabel = "Fortschritt",
                orphansSection = "Verwaiste Objekte",
                orphansEntry = "Objekt",
                orphansEditLabel = "Verwaiste Objekte",
                orphansEditDescription = "Entfernt Objekte, deren Besitzer lange nicht mehr online war.",
                orphansEditButton = "Aufräumen",
                sessionStates = {
                    binding = "Wird gefesselt",
                    active = "Aktiv",
                    ending = "Wird beendet",
                },
            },
        },
    },
}
