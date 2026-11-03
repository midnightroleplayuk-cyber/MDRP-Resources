JobConfigLocales["sky_firejob:de"] = {
    Nui = {
        workshopConfig = {
            configs = {
                sky_firejob = {
                    subtitle = "Konfiguriere Feuerwehr-Jobs, Feuerzeug-Zündung, Fahrzeugbrände, technische Rettung, NPC-Rettungsabläufe, Feuerwachen und Missionseditor-Einstellungen.",
                    title = "Feuerwehr-Jobs",
                },
            },
            creatorSections = {
                fireStations = {
                    entryLabel = "Feuerwache",
                    entryPluralLabel = "Feuerwachen",
                    label = "Feuerwachen",
                },
            },
            dispatchActions = {
                addChannel = "Funkkanal hinzufügen",
                addKeyword = "Stichwort hinzufügen",
                addPoi = "POI hinzufügen",
                addReporter = "Melder hinzufügen",
                addStatus = "FMS-Status hinzufügen",
                addVehicle = "Virtuelle Einheit hinzufügen",
                addVehicleType = "Einheitentyp hinzufügen",
                currentLocation = "Aktuellen Standort übernehmen",
            },
            dispatchFieldDescriptions = {
                autoAlarm = "Alarmiert beim Anlegen des Einsatzes sofort passende verfügbare Einheiten.",
                available = "Einheiten mit diesem Status dürfen für einen neuen Einsatz vorgeschlagen und alarmiert werden.",
                averageResponseSpeedKmh = "Berechnet aus der Luftlinienentfernung die angezeigte geschätzte Ankunftszeit.",
                callsign = "Eindeutiger Funkrufname, der beim Besetzen dieser virtuellen Einheit angezeigt wird.",
                centerEnabled = "Erlaubt berechtigten Mitgliedern im Dienst, eine Leitstelle zu besetzen.",
                channelId = "Funkkanal-ID für PMA Voice, SaltyChat und YACA. Numerische IDs wie 2500 bleiben unverändert; PMA Voice bildet Text-IDs intern auf eine feste Zahl ab.",
                channelLabel = "Lesbarer Kanalname für Dispatcher und Einheiten.",
                crewCapacity = "Maximale Anzahl an Einsatzkräften in dieser Einheit. Der Wert 0 erlaubt eine unbegrenzte Besatzung.",
                defaultChannel = "Legt den Fallback-Kanal dieser Einsatzabteilung fest, wenn kein Kanal gewählt wurde. Einheiten treten weiterhin manuell bei. Keiner verwendet den Standard der Jobgruppe.",
                emergencyAppEnabled = "Zeigt diesen Job in der öffentlichen Emergency-Handy-App als auswählbaren Dienst an.",
                enabled = "Macht diesen Job in der Dispatch App und für jobübergreifende Einsätze verfügbar.",
                icon = "Wähle das Icon, das für diese Einheitenkategorie in der Dispatch App angezeigt wird.",
                incidentAssessmentEnabled = "Zeigt medizinische Fragen und die Gefahrenbewertung in der vollständigen Notrufaufnahme.",
                jobs = "Zusätzliche Jobnamen, die Einsätze mit diesem Stichwort erhalten.",
                joinLocked = "Verhindert, dass weitere Einsatzkräfte einer bereits besetzten Einheit beitreten.",
                minimumCrew = "Mindestanzahl an Einsatzkräften in den für diesen Alarmplan ausgewählten Einheiten.",
                noUnitFallback = "Ohne Leitstelle oder besetztes Fahrzeug wird eine Sky-Benachrichtigung an alle Mitglieder im Dienst gesendet.",
                poiId = "Stabile technische Kennung, auf die Leitstellenprofile auch nach einer Umbenennung des POIs verweisen können.",
                radius = "Maximale Entfernung in Metern, in der die Wachdurchsage hörbar ist.",
                readyStatusCode = "FMS-Status, der gesetzt wird, sobald diese Ressource einsatzbereit ist.",
                requirements = "Einheitenbedarf als TYP:ANZAHL, zum Beispiel PATROL:2,CRIME:1.",
                resourceType = "Klassifiziert die Einsatzressource für Filter und Koordination in der Leitstelle.",
                respondingStatusCode = "FMS-Status, der beim Ausrücken zu einem Einsatz gesetzt wird.",
                shortLabel = "Optionale Kurzbezeichnung auf den sechs Kanalspeichertasten des Funkgeräts.",
                stationId = "Ordnet diese Einheit einer Wache aus dem Leitstellenprofil zu.",
                statusCode = "Numerischer FMS-Status, der auf dem Funkgerät angezeigt wird.",
                statusLabel = "Bedeutung dieses FMS-Status für Dispatcher und Einheiten.",
                unitId = "Stabile technische Kennung, durch die diese Einheit auch nach einer Änderung des Funkrufnamens erhalten bleibt.",
                vehicleType = "Muss einem Fahrzeugtyp-Code aus dem vorherigen Unterbereich entsprechen.",
                vehicleTypeCode = "Kurzer Einheiten-Code für Alarmpläne, zum Beispiel PATROL, CRIME, EMS oder RESCUE.",
                vehicleTypeLabel = "Lesbare Bezeichnung dieser Einheitenkategorie.",
            },
            dispatchFields = {
                address = "Adresse",
                autoAlarm = "Automatisch alarmieren",
                available = "Für Alarmierung verfügbar",
                averageResponseSpeedKmh = "Geschätzte Einsatzgeschwindigkeit (km/h)",
                callsign = "Funkrufname",
                category = "Kategorie",
                centerEnabled = "Leitstelle aktivieren",
                channelId = "Kanal-ID",
                code = "Kürzel",
                crewCapacity = "Besatzungskapazität",
                defaultChannel = "Standard-Funkkanal",
                emergencyAppEnabled = "In Emergency-App anzeigen",
                enabled = "Dispatch aktivieren",
                icon = "Symbol",
                incidentAssessmentEnabled = "Notfallbewertung aktivieren",
                jobs = "Ziel-Jobs (kommagetrennt)",
                joinLocked = "Besatzungsbeitritt sperren",
                keywordCode = "Stichwortcode",
                label = "Bezeichnung",
                minimumCrew = "Mindestbesatzung",
                name = "Bezeichnung",
                noUnitFallback = "Personal ohne Fahrzeug benachrichtigen",
                noneChannel = "Keiner / Gruppenstandard",
                note = "Notiz",
                phone = "Telefon",
                poiId = "Stabile POI-ID",
                radius = "Durchsageradius",
                readyStatusCode = "Bereitschaftsstatus",
                requirements = "Benötigte Einheiten (zum Beispiel PATROL:2,CRIME:1)",
                resourceType = "Ressourcentyp",
                respondingStatusCode = "Ausrückestatus",
                shortLabel = "Funk-Speicherbezeichnung",
                stationId = "Wachen-ID",
                type = "Typ",
                unitId = "Stabile Einheiten-ID",
                vehicleType = "Einheitenkategorie",
            },
            dispatchIconOptions = {
                crime = "Kriminalitätseinheit",
                emergency = "Notfalleinheit",
                ems = "EMS Einheit",
                fire = "Feuereinheit",
                heavy = "Schwere Einheit",
                k9 = "K-9 Einheit",
                medical = "Medizinische Abteilung",
                patrol = "Patrouille",
                rescue = "Rettungseinheit",
                service = "Diensteinheit",
                supervisor = "Führungseinheit",
                tactical = "Taktische Einheit",
            },
            dispatchNavigation = {
                active = "Dispatch aktiv",
                description = "Konfiguriert Notrufannahme, Funk, Einheiten, Alarmpläne, Orte und Melderdaten für diesen Job.",
                inactive = "Dispatch deaktiviert",
                steps = {
                    accessText = "Aktiviere Dispatch und steuere öffentliche Notrufannahme und Fallback für diese Einsatzabteilung.",
                    accessTitle = "Zugriff und Notrufannahme",
                    fleetText = "Konfiguriere Kanäle, FMS-Status, Fahrzeugtypen und Funkrufnamen.",
                    fleetTitle = "Funk und Fuhrpark",
                    responseText = "Ergänze anschließend Stichwörter, Einheitenbedarf und POIs.",
                    responseTitle = "Alarmpläne",
                },
                summary = {
                    channels = "Funkkanäle",
                    plans = "Alarmpläne",
                    reporters = "Bekannte Melder",
                    statuses = "Verfügbare FMS",
                    units = "Virtuelle Einheiten",
                },
                title = "Leitstelle",
                warnings = {
                    channels = "Es gibt keine eigenen Funkkanäle; der Standardkanal der Jobgruppe wird verwendet.",
                    defaultChannel = "Der gewählte Standardkanal existiert nicht mehr.",
                    disabled = "Dispatch ist für diesen Job deaktiviert.",
                    statuses = "Mindestens ein FMS-Status muss für Alarmierungen verfügbar sein.",
                },
            },
            extensionDescriptions = {
                dispatchChannels = "Legt die Funkkanäle fest, denen Einheiten und besetzte Leitstellen beitreten können.",
                dispatchKeywords = "Definiert Einsatzstichwörter, benötigte Fahrzeugzahlen, beteiligte Jobs und optionale Auto-Alarmierung.",
                dispatchPois = "Speichert Wachen und häufige Orte für Einsatzformulare und ortsgebundene Wachdurchsagen.",
                dispatchReporters = "Pflegt jobbezogene Meldernamen, Rückrufnummern und Leitstellennotizen.",
                dispatchStatusCodes = "Konfiguriert FMS-Statusbezeichnungen und welche Status für neue Einsätze verfügbar sind.",
                dispatchVehicleTypes = "Definiert Einheitenkategorien für Alarmpläne, zum Beispiel Patrol, Crime Unit, EMS oder Rescue.",
                dispatchVehicles = "Definiert virtuelle Dispatch-Fahrzeuge, die ohne gespawntes Fahrzeug von überall besetzt werden können.",
            },
            extensions = {
                dispatchChannels = "Funkkanäle",
                dispatchKeywords = "Stichwörter und Alarmpläne",
                dispatchPois = "Dispatch-POIs",
                dispatchReporters = "Bekannte Melder",
                dispatchSettings = {
                    description = "Konfiguriert Leitstellenzugriff, Notrufannahme und den Standard-Funkkanal.",
                    label = "Dispatch-Einstellungen",
                },
                dispatchStatusCodes = "Statuscodes",
                dispatchVehicleTypes = "Dispatch-Fahrzeugtypen",
                dispatchVehicles = "Dispatch-Flottendaten",
                emptyDescription = "Lege über die Schaltfläche oben den ersten Eintrag an.",
                emptyTitle = "Noch nichts konfiguriert",
                invalidSelection = "Ungültige Auswahl: {value}",
                trainingSettings = {
                    description = "Konfiguriert Ausbildungszugriff, Anmeldungen, Freigaben und Lehrgangsplanung für diesen Job.",
                    label = "Ausbildungseinstellungen",
                },
            },
            extinguisherMaintenanceStates = {
                checked = "Geprüft",
                damaged = "Beschädigt",
                empty = "Leer",
                missing = "Kein Feuerlöscher",
            },
            extinguisherMountStates = {
                empty = "Halterung leer",
                mounted = "Feuerlöscher eingesetzt",
            },
            features = {
                waterMonitor = {
                    description = "Bekämpft größere Brände mit einem gleichmäßigen Wasserstrahl und einstellbarer Neigung. Benötigt eine Versorgungsleitung zu einem Feuerwehrfahrzeug mit Tankwasser, Hydrant oder Pumpe.",
                    label = "Wasserwerfer",
                },
            },
            messages = {
                dispatchEmergencyRequiresDispatch = "Die Anzeige in der Notruf-App setzt aktiviertes Dispatch voraus. Aktiviere Dispatch oder schalte „In Notruf-App anzeigen“ in den Dispatch-Einstellungen aus.",
                dispatchJobNotCovered = "Dem Job „{job}“ ist keine aktive Leitstelle zugeordnet. Trage „{job}“ in sky_jobs_base/config/config.lua unter coveredJobs im passenden Profil von Config.Dispatch.centers ein und starte sky_jobs_base neu. Das Zurücksetzen der Einstellungen ändert diese Zuordnung nicht.",
                invalidDispatchChannels = "Funkkanal-IDs müssen eindeutig sein und jeder Kanal benötigt eine gültige Bezeichnung.",
                invalidDispatchDefaultChannel = "Der Standard-Funkkanal existiert nicht. Wähle in den Dispatch-Einstellungen einen vorhandenen Kanal oder „Keiner“.",
                invalidDispatchKeywords = "Alarmpläne benötigen eindeutige Codes und gültige Anforderungen im Format TYP:ANZAHL.",
                invalidDispatchPois = "POI-IDs, Namen und Koordinaten müssen gültig und eindeutig sein.",
                invalidDispatchRadioButtons = "Prüfe die Funk-Funktionstasten: Jede unterstützte Taste darf nur einmal vorkommen. Wähle ihre Aktion aus der Liste.",
                invalidDispatchRadioFmsKeys = "Prüfe die Funk-FMS-Tasten: Jede Taste (0-9, * oder #) darf nur einmal vorkommen. Weise ihr einen vorhandenen Statuscode zu oder lasse sie unbelegt.",
                invalidDispatchReadyStatus = "Wähle in den Dispatch-Einstellungen einen Bereitschaftsstatus, der unter Statuscodes als verfügbar markiert ist.",
                invalidDispatchReporters = "Die Melderdaten überschreiten die erlaubte Anzahl oder Feldlänge.",
                invalidDispatchRespondingStatus = "Wähle in den Dispatch-Einstellungen einen Ausrückestatus, der unter Statuscodes als nicht verfügbar markiert ist.",
                invalidDispatchSettings = "Wähle einen vorhandenen verfügbaren Bereitschaftsstatus, einen nicht verfügbaren Ausrückestatus und einen gültigen Standardkanal.",
                invalidDispatchStatusCodes = "FMS-Codes müssen eindeutig sein und mindestens ein Status muss verfügbar sein.",
                invalidDispatchVehicleTypes = "Codes der Einheitentypen müssen eindeutig und vollständig sein.",
                invalidDispatchVehicles = "Einheiten-IDs und Funkrufnamen müssen eindeutig sein; alle Typ- und Wachenreferenzen müssen existieren.",
            },
            misc = {
                defaultFireTruckLabel = "Feuerwehrfahrzeug",
                fireStationCategoryLabel = "Feuerwache",
                fireStationEntryLabel = "Feuerwache",
                fireStationPosition = "Feuerwachen-Position",
                fireStationsTitle = "Feuerwachen",
                hoseConnectionEditorTitle = "Schlauch-Verbindungseditor",
                hydrantConnectionEditorTitle = "Hydranten-Schlauch-Verbindungseditor",
                pumpIntakeEditorTitle = "Pumpeneingang-Editor",
                pumpOutletEditorTitle = "Pumpenausgang-Editor",
                pumpPanelAccessEditorTitle = "Hose-Control-Zugriffseditor",
                scbaRefillBlipLabel = "Atemschutz-Füllung",
                scbaRefillStationLabel = "Atemschutz-Füllstation",
            },
            settingFields = {
                cannonId = "Wasserwerfer-Kennung",
                cannonLabel = "Wasserwerfer-Name",
                reason = "Grund",
                airBottleSlots = "Pressluftflaschen-Slots",
                amount = "Betrag",
                automatic = "Automatisch",
                canSpread = "Kann sich ausbreiten",
                component = "Komponente",
                connection = "Verbindung",
                currentPosition = "Aktuelle Position",
                delete = "Löschen",
                description = "Beschreibung",
                dispatchJobs = "Dispatch-Jobs",
                drawables = "Varianten",
                enabled = "Aktiv",
                fillLevel = "Füllmenge",
                fireType = "Feuertyp",
                foamTankEnabled = "Schaumtank",
                foamTankSize = "Schaum Liter",
                gearKey = "Typ",
                hydrantConnection = "Hydranten-Verbindung",
                hydrantRx = "Hydrante Rot X",
                hydrantRy = "Hydrante Rot Y",
                hydrantRz = "Hydrante Rot Z",
                hydrantX = "Hydrante X",
                hydrantY = "Hydrante Y",
                hydrantZ = "Hydrante Z",
                id = "ID",
                igniteDistance = "Zündentfernung",
                intensity = "Intensität",
                job = "Beruf",
                jobs = "Dienst-Jobs",
                key = "Schlüssel",
                label = "Bezeichnung",
                location = "Position",
                maintenanceStatus = "Wartungsstatus",
                minOnDuty = "Im Dienst benötigt",
                minimum = "Mindestens online",
                mission = "Einsatz",
                model = "Modell",
                name = "Bezeichnung",
                prop = "Objekt",
                pumpConnections = "Pumpenanschlüsse",
                pumpDischargeCount = "Pumpenausgänge",
                pumpIntake1Connection = "Eingang 1",
                pumpIntake1Label = "Eingang 1 – Bezeichnung",
                pumpIntake1Rx = "Eingang 1 – Rotation X",
                pumpIntake1Ry = "Eingang 1 – Rotation Y",
                pumpIntake1Rz = "Eingang 1 – Rotation Z",
                pumpIntake1X = "Eingang 1 – X",
                pumpIntake1Y = "Eingang 1 – Y",
                pumpIntake1Z = "Eingang 1 – Z",
                pumpIntake2Connection = "Eingang 2",
                pumpIntake2Label = "Eingang 2 – Bezeichnung",
                pumpIntake2Rx = "Eingang 2 – Rotation X",
                pumpIntake2Ry = "Eingang 2 – Rotation Y",
                pumpIntake2Rz = "Eingang 2 – Rotation Z",
                pumpIntake2X = "Eingang 2 – X",
                pumpIntake2Y = "Eingang 2 – Y",
                pumpIntake2Z = "Eingang 2 – Z",
                pumpIntakeCount = "Pumpeneingänge",
                pumpOutlet1Connection = "Ausgang 1",
                pumpOutlet1Label = "Ausgang 1 – Bezeichnung",
                pumpOutlet1Rx = "Ausgang 1 – Rotation X",
                pumpOutlet1Ry = "Ausgang 1 – Rotation Y",
                pumpOutlet1Rz = "Ausgang 1 – Rotation Z",
                pumpOutlet1X = "Ausgang 1 – X",
                pumpOutlet1Y = "Ausgang 1 – Y",
                pumpOutlet1Z = "Ausgang 1 – Z",
                pumpOutlet2Connection = "Ausgang 2",
                pumpOutlet2Label = "Ausgang 2 – Bezeichnung",
                pumpOutlet2Rx = "Ausgang 2 – Rotation X",
                pumpOutlet2Ry = "Ausgang 2 – Rotation Y",
                pumpOutlet2Rz = "Ausgang 2 – Rotation Z",
                pumpOutlet2X = "Ausgang 2 – X",
                pumpOutlet2Y = "Ausgang 2 – Y",
                pumpOutlet2Z = "Ausgang 2 – Z",
                pumpOutlet3Connection = "Ausgang 3",
                pumpOutlet3Label = "Ausgang 3 – Bezeichnung",
                pumpOutlet3Rx = "Ausgang 3 – Rotation X",
                pumpOutlet3Ry = "Ausgang 3 – Rotation Y",
                pumpOutlet3Rz = "Ausgang 3 – Rotation Z",
                pumpOutlet3X = "Ausgang 3 – X",
                pumpOutlet3Y = "Ausgang 3 – Y",
                pumpOutlet3Z = "Ausgang 3 – Z",
                pumpOutlet4Connection = "Ausgang 4",
                pumpOutlet4Label = "Ausgang 4 – Bezeichnung",
                pumpOutlet4Rx = "Ausgang 4 – Rotation X",
                pumpOutlet4Ry = "Ausgang 4 – Rotation Y",
                pumpOutlet4Rz = "Ausgang 4 – Rotation Z",
                pumpOutlet4X = "Ausgang 4 – X",
                pumpOutlet4Y = "Ausgang 4 – Y",
                pumpOutlet4Z = "Ausgang 4 – Z",
                pumpPanelAccess = "Hose-Control-Zugriff",
                pumpPanelConfigured = "Panel konfiguriert",
                pumpPanelSize = "Panelgröße",
                pumpPanelX = "Panel X",
                pumpPanelY = "Panel Y",
                pumpPanelZ = "Feld Z",
                resource = "Ressource",
                rx = "Rot X",
                ry = "Rot Y",
                rz = "Rot Z",
                scenario = "Einsatz",
                sourceScale = "Quellenskalierung",
                state = "Halterungsstatus",
                teleport = "Teleportieren",
                textures = "Texturen",
                turretBone = "Kanonenrohr-Bone",
                turretMuzzleOffsetX = "Mündungs-Offset X",
                turretMuzzleOffsetY = "Mündungs-Offset Y",
                turretMuzzleOffsetZ = "Mündungs-Offset Z",
                turretOffsetX = "Kanonen-Offset X",
                turretOffsetY = "Kanonen-Offset Y",
                turretOffsetZ = "Kanonen-Offset Z",
                turretTipOffset = "Abstand zur Rohrspitze",
                waterGravityScale = "Wasser-Schwerkraft",
                waterTankEnabled = "Wassertank",
                waterTankSize = "Wasser Liter",
                waterVelocity = "Wassergeschwindigkeit",
                weather = "Wettertyp",
                x = "X",
                y = "Y",
                z = "Z",
                zOffset = "Z-Versatz",
            },
            settingGroups = {
                billing = {
                    label = "Rechnungen",
                },
                absorbentMinigame = {
                    description = "Steuert das Verteilen des Bindemittels bei Ölspuren.",
                    label = "Bindemittel-Minispiel",
                },
                access = {
                    label = "Zugriff",
                },
                air = {
                    label = "Atemluft",
                },
                airItem = {
                    label = "Atemluftflaschen-Item",
                },
                airRefill = {
                    label = "Atemluft auffüllen",
                },
                ambulance = {
                    label = "Rettungsdienst",
                },
                animals = {
                    label = "Tierrettung",
                },
                attachment = {
                    label = "Befestigung",
                },
                automaticMissionDispatch = {
                    description = "Steuert Alarmierungen für automatisch und manuell gestartete Einsätze.",
                    label = "Alarmierung",
                },
                automaticMissionJobs = {
                    description = "Diese Jobs gelten, wenn für eine Mission keine eigenen Einsatz-Jobs eingetragen sind.",
                    label = "Standard-Dienst-Jobs",
                },
                automaticMissionList = {
                    description = "Alle Missionen aus dem Missionseditor werden automatisch aufgelistet.",
                    label = "Verfügbare Missionen",
                },
                automaticMissionTiming = {
                    description = "Steuert, wann der Scheduler versucht, eine automatische Mission zu starten.",
                    label = "Automatische Auslösung",
                },
                breathing = {
                    label = "Atmung",
                },
                breathingClothing = {
                    label = "Atemschutzkleidung",
                },
                burnDamage = {
                    label = "Verbrennungsschaden",
                },
                cleanup = {
                    description = "Steuert benötigte Items, Item-Verbrauch und Fallback-Fortschrittszeiten.",
                    label = "Reinigungsablauf",
                },
                consumption = {
                    label = "Verbrauch",
                },
                creator = {
                    label = "Ersteller",
                },
                detection = {
                    label = "Erkennung",
                },
                dispatch = {
                    label = "Leitstelle",
                },
                distance = {
                    label = "Entfernungen",
                },
                dump = {
                    label = "Wasserabwurf",
                },
                effects = {
                    label = "Effekte",
                },
                engineBehavior = {
                    label = "Fahrzeugsicherheit",
                },
                engineOutput = {
                    label = "Motorleistung",
                },
                engineRetention = {
                    label = "Motor-Nachlauf",
                },
                enterAnimation = {
                    label = "Einstiegsanimation",
                },
                exitAnimation = {
                    label = "Ausstiegsanimation",
                },
                explosion = {
                    label = "Sprengung",
                },
                external = {
                    label = "Extern",
                },
                extinguish = {
                    label = "Löschen",
                },
                extinguisher = {
                    label = "Feuerlöscher",
                },
                femaleBreathingClothing = {
                    label = "Atemschutzkleidung",
                },
                femaleHeatClothing = {
                    label = "Hitzeschutzkleidung",
                },
                femaleProtectiveMaskClothing = {
                    label = "Schutzmasken-Kleidung",
                },
                fieldFlow = {
                    label = "Einsatzablauf",
                },
                fireExtinguishFeedback = {
                    label = "Löschanzeige",
                },
                fireParticles = {
                    label = "Flammen und Rauch",
                },
                fireReward = {
                    description = "Steuert die Einzahlung ins Society-Konto, wenn ein einzelner Brand vollständig gelöscht wurde.",
                    label = "Brand-Auszahlung",
                },
                fireRewardJobs = {
                    description = "Job-Societys, die die Brand-Auszahlung erhalten. Jeder Job nutzt sein konfiguriertes Society-Konto.",
                    label = "Brand-Society-Jobs",
                },
                fireSoundAmbient = {
                    label = "Feuer-Umgebung",
                },
                fireSoundChainsaw = {
                    label = "Kettensäge",
                },
                fireSoundFlare = {
                    label = "Flare-Sound",
                },
                fireThirst = {
                    label = "Durst im Feuer",
                },
                flow = {
                    label = "Ablauf",
                },
                flowBehavior = {
                    label = "Durchflussverhalten",
                },
                foamRefill = {
                    label = "Schaum-Befüllen",
                },
                foamRefillVisual = {
                    label = "Schaum-Befüllen Visual",
                },
                fullFireStage = {
                    label = "Vollbrandphase",
                },
                general = {
                    label = "Allgemein",
                },
                glassMinigame = {
                    description = "Steuert das Schwachpunkt-Minispiel für Fahrzeugscheiben.",
                    label = "Scheiben-Minispiel",
                },
                groundActionAnimation = {
                    label = "Animation beim Ablegen und Aufheben",
                },
                hazard = {
                    description = "Steuert Rutschgefahr, Intensität und automatische Entfernen-Schwellen der Ölspur.",
                    label = "Gefahrenwerte",
                },
                heat = {
                    label = "Hitze",
                },
                heatClothing = {
                    label = "Hitzeschutzkleidung",
                },
                heatStress = {
                    label = "Hitzebelastung",
                },
                helicopters = {
                    label = "Hubschrauber",
                },
                hoseGrounding = {
                    label = "Bodenplatzierung",
                },
                hosePerformance = {
                    label = "Leistung",
                },
                hoseProp = {
                    label = "Schlauch-Prop",
                },
                hosePropGeometry = {
                    label = "Prop-Geometrie",
                },
                hoseSimulation = {
                    label = "Simulation",
                },
                hydrantSupply = {
                    label = "Hydrantenversorgung",
                },
                hydrants = {
                    label = "Hydranten",
                },
                idleAnimation = {
                    label = "Bedienanimation",
                },
                ignition = {
                    label = "Neue Menübrände",
                },
                interaction = {
                    label = "Interaktion",
                },
                item = {
                    label = "Gegenstand",
                },
                items = {
                    label = "Gegenstände",
                },
                keybinds = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Tastenbelegung",
                },
                landing = {
                    label = "Landung",
                },
                limits = {
                    label = "Grenzen",
                },
                maintenance = {
                    label = "Status",
                },
                maintenanceAccess = {
                    label = "Zugriff",
                },
                manual = {
                    label = "Manuelle Zündung",
                },
                manualOnly = {
                    label = "Nur manuell",
                },
                nozzle = {
                    label = "Strahlrohr",
                },
                nozzleAttachment = {
                    label = "Schlauchanschluss",
                },
                nozzleBend = {
                    label = "Anschlussbiegung",
                },
                nozzleDirection = {
                    label = "Austrittsrichtung",
                },
                nozzlePlacement = {
                    label = "Bodenplatzierung",
                },
                npcFireReactions = {
                    label = "NPC-Brandreaktionen",
                },
                npcFireReactionsModes = {
                    label = "NPC-Reaktionsarten",
                },
                offsets = {
                    label = "Befestigungs-Offsets",
                },
                oilReward = {
                    description = "Steuert die Einzahlung ins Society-Konto, wenn eine Ölspur gereinigt wurde.",
                    label = "Öl-Auszahlung",
                },
                oilRewardJobs = {
                    description = "Job-Societys, die Öl-Reinigungs-Auszahlungen erhalten. Jeder Job nutzt sein konfiguriertes Society-Konto.",
                    label = "Öl-Society-Jobs",
                },
                placement = {
                    label = "Platzierung",
                },
                playerEntrapment = {
                    label = "Spieler-Einklemmung",
                },
                portablePumpSupply = {
                    label = "Tragbare Pumpenversorgung",
                },
                pressureControl = {
                    label = "Drucksteuerung",
                },
                pressureLimits = {
                    label = "Druckgrenzen",
                },
                progression = {
                    label = "Entwicklung",
                },
                propGeneral = {
                    label = "Anzündbare Objekte",
                },
                propLimits = {
                    label = "Brandquellen-Limits",
                },
                propList = {
                    label = "Mögliche Anzündstellen",
                },
                props = {
                    label = "Objekte",
                },
                protectiveMask = {
                    label = "Waldbrand-Schutzmaske",
                },
                protectiveMaskClothing = {
                    label = "Schutzmasken-Kleidung",
                },
                protectiveMaskItem = {
                    label = "Schutzmasken-Item",
                },
                pump = {
                    label = "Pumpe",
                },
                pumpDamage = {
                    label = "Pumpenschaden",
                },
                pumpIntakeHose = {
                    label = "Ansaugschlauch",
                },
                pumpPanelGeneral = {
                    description = "Wählt zwischen der einfachen automatischen und der erweiterten manuellen Pumpensteuerung.",
                    label = "Panelmodus",
                },
                pumpTargets = {
                    label = "Anschluss-Targets",
                },
                rainFire = {
                    label = "Brandverhalten",
                },
                rainGeneral = {
                    label = "Allgemein",
                },
                rainVisuals = {
                    label = "Darstellung",
                },
                rainWeather = {
                    label = "Wetterintensität",
                },
                random = {
                    label = "Zufall",
                },
                randomJobs = {
                    label = "Zufällige Jobs",
                },
                reignition = {
                    label = "Wiederaufflammen",
                },
                release = {
                    label = "Freigabe",
                },
                render = {
                    label = "Sichtweite",
                },
                requirements = {
                    label = "Mindestanforderungen",
                },
                rescueReward = {
                    description = "Steuert die Einzahlung ins Society-Konto, wenn eine Rettungsaufgabe abgeschlossen wurde.",
                    label = "Rettungs-Auszahlung",
                },
                rescueRewardJobs = {
                    description = "Job-Societys, die Rettungs-Auszahlungen erhalten. Jeder Job nutzt sein konfiguriertes Society-Konto.",
                    label = "Rettungs-Society-Jobs",
                },
                restock = {
                    label = "Auffüllen",
                },
                rpmRange = {
                    label = "Drehzahlbereich",
                },
                seatbelt = {
                    description = "Steuert das Durchschneiden des Gurts bei eingeklemmten Patienten.",
                    label = "Anschnallgurt-Minispiel",
                },
                smallFireStage = {
                    label = "Kleinbrandphase",
                },
                smokeStage = {
                    label = "Rauchphase",
                },
                spreaderMinigame = {
                    description = "Steuert das Druck-Minispiel für den Tür-Spreizer.",
                    label = "Tür-Spreizer-Minispiel",
                },
                standaloneAccidents = {
                    label = "Eigenständige Unfälle",
                },
                standaloneResult = {
                    label = "Standalone-Ergebnis",
                },
                standaloneThresholds = {
                    label = "Standalone-Grenzwerte",
                },
                stream = {
                    label = "Wasserstrahl",
                },
                sweepMinigame = {
                    description = "Steuert das Kehren von Ölspuren.",
                    label = "Kehr-Minispiel",
                },
                tankFill = {
                    label = "Tankfüllung",
                },
                tankSupply = {
                    label = "Fahrzeugtank-Versorgung",
                },
                targets = {
                    label = "Ziele",
                },
                thermalWarnings = {
                    label = "Temperaturwarnungen",
                },
                timing = {
                    label = "Zeitsteuerung",
                },
                treeBase = {
                    description = "Grundwerte für Baum-Einsätze: Aktivierung, Dienstpflicht, Modell und Spawn-Reichweite.",
                    label = "Einsatz",
                },
                treeBlip = {
                    description = "Kartenmarkierung für aktive Baum-Einsätze.",
                    label = "Kartenmarkierung",
                },
                treeCarry = {
                    description = "Getragenes Holzmodell, Bone, Offsets und Bewegungsblend beim Tragen.",
                    label = "Trage-Prop",
                },
                treeCarryAnimation = {
                    description = "Animationsverzeichnis, Name und Flag beim Tragen von Holzstücken.",
                    label = "Trageanimation",
                },
                treeDispatch = {
                    description = "Steuert, ob Baum-Einsätze einen Dispatch senden und welche Jobs ihn erhalten.",
                    label = "Leitstelle",
                },
                treeDropMarker = {
                    description = "Marker-Stil und Farbe an der Holz-Ablage.",
                    label = "Ablagemarker",
                },
                treeDropZone = {
                    description = "Lokaler Offset, Radius und Cleanup-Reichweite für abgelegte Holzstücke.",
                    label = "Ablagezone",
                },
                treeInteractionMarker = {
                    description = "Marker-Stil und Farbe an der Baum-Interaktion.",
                    label = "Sägemarker",
                },
                treeInteractionPoint = {
                    description = "Interaktionsdistanz und lokale Position, an der Spieler den Baum zersägen.",
                    label = "Sägestelle",
                },
                treeLogSpawn = {
                    description = "Anzahl, Modell, Abstand und Aufnahmedistanz der erzeugten Holzstücke.",
                    label = "Holzstücke",
                },
                treeReward = {
                    description = "Steuert die Einzahlung ins Society-Konto, wenn ein umgestürzter Baum vollständig geräumt wurde.",
                    label = "Baum-Auszahlung",
                },
                treeRewardJobs = {
                    description = "Job-Societys, die Baum-Auszahlungen erhalten. Jeder Job nutzt sein konfiguriertes Society-Konto.",
                    label = "Baum-Society-Jobs",
                },
                treeSawAnimation = {
                    description = "Animationsverzeichnis, Name und Flag während des Sägens.",
                    label = "Sägeanimation",
                },
                treeSawAttach = {
                    description = "Feinjustierung von Position, Rotation, Kollision und Attachment-Verhalten der Kettensäge.",
                    label = "Kettensägen-Befestigung",
                },
                treeSawMinigame = {
                    description = "Wie viele Sägeabschnitte abgeschlossen werden müssen, bevor Holzstücke geräumt werden können.",
                    label = "Sägen-Minispiel",
                },
                treeSawTool = {
                    description = "Modell und Bone der Kettensäge beim Sägen.",
                    label = "Kettensägen-Prop",
                },
                types = {
                    label = "Typen",
                },
                usage = {
                    label = "Item und Befehl",
                },
                vehicle = {
                    label = "Fahrzeug-Zündung",
                },
                vehicleBend = {
                    label = "Fahrzeug-Anschlussbiegung",
                },
                vehicleEntrapment = {
                    label = "Fahrzeug-Einklemmung",
                },
                vehiclePumpBehavior = {
                    label = "Pumpen- und Motorverhalten",
                },
                vehicleSmokeClasses = {
                    label = "Geschützte Fahrzeugtypen",
                },
                vehicleSmokeProtection = {
                    label = "Fahrzeug-Rauchschutz",
                },
                vehicleState = {
                    label = "Fahrzeugzustand",
                },
                vehicleTransfer = {
                    label = "Fahrzeug-Wassertransfer",
                },
                vehicleTransferBehavior = {
                    label = "Transferverhalten",
                },
                vehicleTransferSourceOffset = {
                    label = "Quell-Anschluss",
                },
                vehicleTransferTargetOffset = {
                    label = "Ziel-Anschluss",
                },
                vehicles = {
                    label = "Fahrzeuge",
                },
                water = {
                    label = "Wasser",
                },
                waterCannon = {
                    label = "Fahrzeug-Wasserkanone",
                },
                waterReaction = {
                    label = "Wasserreaktion",
                },
            },
            settingSections = {
                billing = "Rechnungen",
                activeOilSpills = "Aktive Ölspuren",
                automaticMissions = "Automatische Einsätze",
                consumption = "Verbrauch",
                effects = "Effekte",
                extinguishFeedback = "Löschrückmeldung",
                extinguishing = "Löschen",
                fire = "Feuer",
                foamRefill = "Schaummittel auffüllen",
                foamRefillVisual = "Auffüllvisualisierung",
                general = "Allgemein",
                heliBucket = "Löschwasserbehälter",
                hose = "Schlauch",
                hydrants = "Hydranten",
                interiorExtinguishers = "Interior-Feuerlöscher",
                lighter = "Feuerzeug",
                minigames = "Minispiele",
                npcRescue = "NPC-Rettung",
                oilCleanup = "Reinigung",
                oilGeneral = "Allgemein",
                oilHazard = "Gefahr",
                oilSpills = "Ölspuren",
                protectiveGear = "Schutzkleidung",
                pump = "Pumpe",
                pumpPanel = "Pumpenpanel",
                rain = "Regen",
                reignition = "Wiederaufflammen",
                rendering = "Darstellung",
                rescueCushion = "Sprungretter",
                rewardFire = "Brand-Belohnung",
                rewardOil = "Öl-Belohnung",
                rewardRescue = "Rettungs-Belohnung",
                rewardTree = "Baum-Belohnung",
                rewards = "Belohnungen",
                scenarioCreator = "Missionseditor",
                sounds = "Geräusche",
                spread = "Brandausbreitung",
                treeDispatch = "Leitstelle",
                treeDrop = "Ablage",
                treeGeneral = "Allgemein",
                treeInteraction = "Interaktion",
                treeLogs = "Holzstücke",
                treeSaw = "Sägen",
                trees = "Bäume",
                vehicleEntrapment = "Fahrzeug-Einklemmung",
                vehicleFires = "Fahrzeugbrände",
                vehicleRescue = "Fahrzeugrettung",
                vehicles = "Fahrzeuge",
                waterMonitor = "Wasserwerfer",
            },
            settingSubsections = {
                weaponIgnition = "Waffenbrände",
                activeOilSpills = "Aktive Ölspuren",
                consumption = "Verbrauch",
                engineSafety = "Motor & Sicherheit",
                extinguishFeedback = "Löschrückmeldung",
                extinguisherCustomMounts = "Eigene Halterungen",
                extinguisherGeneral = "Allgemein",
                extinguisherMaintenance = "Wartung",
                extinguisherMounts = "Halter & Füllstand",
                extinguisherPlacement = "Platzierung",
                extinguishing = "Löschen",
                femaleClothing = "Frauenkleidung",
                foamRefill = "Schaummittel auffüllen",
                foamRefillVisual = "Auffüllvisualisierung",
                general = "Allgemein",
                hydrants = "Hydranten",
                hydraulics = "Hydraulik",
                keybinds = "Tastenbelegung",
                maleClothing = "Männerkleidung",
                minigameGlass = "Scheibe",
                minigameOilAbsorbent = "Öl binden",
                minigameOilSweep = "Öl kehren",
                minigameSaw = "Sägen",
                minigameSeatbelt = "Anschnallgurt",
                minigameSpreader = "Tür spreizen",
                nozzle = "Strahlrohr",
                oilCleanup = "Reinigung",
                oilGeneral = "Allgemein",
                oilHazard = "Gefahr",
                pressure = "Druck & Drehzahl",
                pump = "Pumpe",
                rain = "Regen",
                reignition = "Wiederaufflammen",
                rendering = "Darstellung",
                reward = "Belohnung",
                rewardFire = "Brandbelohnung",
                rewardOil = "Ölspur-Belohnung",
                rewardRescue = "Rettungsbelohnung",
                rewardTree = "Baum-Belohnung",
                simulation = "Simulation",
                sounds = "Geräusche",
                spread = "Brandausbreitung",
                treeDispatch = "Alarmierung",
                treeDrop = "Abgabestelle",
                treeGeneral = "Allgemein",
                treeInteraction = "Baum & Interaktion",
                treeLogs = "Holzstücke",
                vehicleFires = "Fahrzeugbrände",
                vehicleTransfer = "Fahrzeugtransfer",
                vehicles = "Fahrzeuge",
                visuals = "Darstellung",
            },
            settings = {
                fireWeaponIgnitionEnabled = {
                    label = "Waffenbrände aktivieren",
                    description = "Erzeugt Sky-Brände durch die aufgeführten Waffen. Bis zur Einrichtung der Feuerwehr deaktiviert lassen. Bestehende Brände und normale GTA-Flammen bleiben unverändert.",
                },
                fireWeaponIgnitionWeapons = {
                    label = "Waffen, die Brände auslösen können",
                    description = "Waffennamen, z. B. WEAPON_MOLOTOV oder WEAPON_FLAREGUN. Eine leere Liste deaktiviert Waffenbrände. Projektile oder Einschläge müssen erkennbar sein.",
                },
                hoseHollowNozzleGroundOffset = {
                    label = "Bodenversatz des Hohlstrahlrohrs",
                },
                hoseNozzleModel = {
                    label = "Strahlrohr-Modell",
                    choose = "Modell auswählen",
                    intact = "Strahlrohr-Modell",
                    description = "Wähle das normale oder das EU-Strahlrohr. Beim Wechsel werden ausgelegte Angriffsschläuche zurückgenommen.",
                    preview = "3D-Vorschau",
                    previewDescription = "Zeigt das echte Prop im Spiel. Die Auswahl wird separat gespeichert.",
                    previewHelp = "Pfeiltasten bewegen, Bild auf/ab ändert die Höhe, Mausrad dreht, Enter schließt, Rücktaste bricht ab.",
                    invalidModel = "Ungültiges Prop-Modell.",
                    modelMissing = "Dieses Prop ist im Spiel nicht verfügbar.",
                    previewFailed = "Die Prop-Vorschau konnte nicht geöffnet werden.",
                    previewRequiresGame = "Öffne /jobconfig in FiveM, um das Prop anzusehen.",
                    options = {
                        normal = "Normales Strahlrohr",
                        hohlstrahlrohr = "EU-Strahlrohr",
                    },
                },
                fireBillingEnabled = {
                    label = "Rechnungen aktivieren",
                    description = "Erlaubt Feuerwehrleuten im Dienst, Rechnungen über das Radialmenü auszustellen.",
                },
                fireBillingMode = {
                    label = "Rechnungssystem",
                    description = "Den in Sky Base gewählten Anbieter nutzen (standardmäßig Sky) oder lokal bar/per Karte bezahlen.",
                    options = {
                        consent = "Bargeld oder Karte",
                        framework = "Billing-Anbieter aus Sky Base",
                    },
                },
                fireBillingReasons = {
                    label = "Rechnungsgründe",
                    description = "Auswählbare Gründe und Preise. Mehrere Gründe können kombiniert werden.",
                    itemLabel = "Grund",
                },
                fireBillingRange = {
                    label = "Empfängerentfernung",
                    description = "Maximale Entfernung in Metern zwischen Aussteller und Empfänger.",
                },
                fireBillingMaxAmount = {
                    label = "Maximaler Rechnungsbetrag",
                    description = "Höchstbetrag einer einzelnen Rechnung für das interne und externe Rechnungssystem.",
                },
                airBottleSlots = {
                    description = "Konfiguriert: Pressluftflaschen-Slots.",
                    label = "Pressluftflaschen-Slots",
                },
                canSpread = {
                    description = "Erlaubt, dass sich ein hier gestarteter Brand über das Firejob-Ausbreitungssystem weiterentwickelt.",
                    label = "Brand darf sich ausbreiten",
                },
                connection = {
                    description = "Konfiguriert: Verbindung.",
                    label = "Verbindung",
                },
                customExtinguisherMounts = {
                    description = "Persistente eigene Halterungen mit aktuellem Feuerlöscher- und Wartungsstatus.",
                    label = "Platzierte Feuerlöscherhalterungen",
                },
                deckGunSprayGamepadKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Dachwerfer: Sprühen halten",
                },
                deckGunSprayKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Dachwerfer: Sprühen halten",
                },
                drawables = {
                    description = "Konfiguriert: Varianten.",
                    label = "Varianten",
                },
                fireBreathingAirEnabled = {
                    description = "Verbraucht begrenzten Luftdruck, während der Atemschutz getragen wird.",
                    label = "Flaschenluft nutzen",
                },
                fireBreathingCapacitySeconds = {
                    description = "Konfiguriert: Luftkapazität Sekunden.",
                    label = "Luftkapazität Sekunden",
                },
                fireBreathingComponents = {
                    description = "Komponentenregeln für Maske und Luftflasche. Varianten akzeptieren any, anyNonDefault, eine Zahl oder komma-getrennte Zahlen.",
                    itemLabel = "Komponente",
                    label = "Pflicht-Kleidungskomponenten",
                },
                fireBreathingCriticalPercent = {
                    description = "Konfiguriert: Kritischer Luft-Prozentwert.",
                    label = "Kritischer Luft-Prozentwert",
                },
                fireBreathingHeatConsumption = {
                    description = "Konfiguriert: Hitzeverbrauch.",
                    label = "Hitzeverbrauch",
                },
                fireBreathingHudUpdateInterval = {
                    description = "Konfiguriert: HUD-Aktualisierungsintervall.",
                    label = "HUD-Aktualisierungsintervall",
                },
                fireBreathingIdleConsumption = {
                    description = "Konfiguriert: Leerlaufverbrauch.",
                    label = "Leerlaufverbrauch",
                },
                fireBreathingItemEnabled = {
                    description = "Erfordert das konfigurierte Inventar-Item, bevor Atemschutz genutzt werden kann.",
                    label = "Flaschen-Item erforderlich",
                },
                fireBreathingItemName = {
                    description = "Konfiguriert: Name des Flaschen-Items.",
                    label = "Name des Flaschen-Items",
                },
                fireBreathingItemSaveInterval = {
                    description = "Konfiguriert: Druck-Speicherintervall.",
                    label = "Druck-Speicherintervall",
                },
                fireBreathingItemSavePressure = {
                    description = "Konfiguriert: Druck-Metadata speichern.",
                    label = "Druck-Metadata speichern",
                },
                fireBreathingJumpingConsumption = {
                    description = "Konfiguriert: Sprungverbrauch.",
                    label = "Sprungverbrauch",
                },
                fireBreathingLowPercent = {
                    description = "Konfiguriert: Niedriger Luft-Prozentwert.",
                    label = "Niedriger Luft-Prozentwert",
                },
                fireBreathingMaskForceFirstPerson = {
                    description = "Erzwingt die Ego-Kamera, solange das Masken-Overlay aktiv ist.",
                    label = "Ego-Perspektive erzwingen",
                },
                fireBreathingMaskOverlayEnabled = {
                    description = "Zeigt das Ego-Masken-Overlay, während Atemschutz aktiv ist.",
                    label = "Masken-Overlay",
                },
                fireBreathingPressureBar = {
                    description = "Konfiguriert: Voller Druckbalken.",
                    label = "Voller Druckbalken",
                },
                fireBreathingProps = {
                    description = "Konfiguriert: Pflicht-Props.",
                    itemLabel = "Objekt",
                    label = "Pflicht-Props",
                },
                fireBreathingRefillEnabled = {
                    description = "Erfordert das Flaschen-Item mit Druck-Metadata. Stationen werden über den Feuer-Editor platziert.",
                    label = "Füllstationen aktivieren",
                },
                fireBreathingRefillRate = {
                    description = "Konfiguriert: Füllrate bar pro Sekunde.",
                    label = "Füllrate bar pro Sekunde",
                },
                fireBreathingRunningConsumption = {
                    description = "Konfiguriert: Laufverbrauch.",
                    label = "Laufverbrauch",
                },
                fireBreathingSmokeConsumption = {
                    description = "Konfiguriert: Rauchverbrauch.",
                    label = "Rauchverbrauch",
                },
                fireBreathingSmokeMultiplier = {
                    description = "Rauchbelastung, die trotz aktivem Atemschutz noch beim Spieler ankommt.",
                    label = "Rauchkontakt-Multiplikator",
                },
                fireBreathingSprintingConsumption = {
                    description = "Konfiguriert: Sprintverbrauch.",
                    label = "Sprintverbrauch",
                },
                fireBreathingToxicConsumption = {
                    description = "Konfiguriert: Giftverbrauch.",
                    label = "Giftverbrauch",
                },
                fireBreathingToxicMultiplier = {
                    description = "Reservierte Abstimmung für giftige Belastung bei aktivem Atemschutz.",
                    label = "Gift-Rauch-Multiplikator",
                },
                fireEditorControl14 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · IOM_WHEEL_DOWN",
                },
                fireEditorControl15 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · IOM_WHEEL_UP",
                },
                fireEditorControl174 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · LEFT",
                },
                fireEditorControl175 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · RIGHT",
                },
                fireEditorControl177 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · BACK",
                },
                fireEditorControl191 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · RETURN",
                },
                fireEditorControl199 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · P",
                },
                fireEditorControl200 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · ESCAPE",
                },
                fireEditorControl202 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · ESCAPE",
                },
                fireEditorControl21 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · LSHIFT",
                },
                fireEditorControl24 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · MOUSE_LEFT",
                },
                fireEditorControl25 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · MOUSE_RIGHT",
                },
                fireEditorControl32 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · W",
                },
                fireEditorControl322 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · ESCAPE",
                },
                fireEditorControl33 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · S",
                },
                fireEditorControl34 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · A",
                },
                fireEditorControl35 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · D",
                },
                fireEditorControl36 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · LCONTROL",
                },
                fireEditorControl38 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · E",
                },
                fireEditorControl44 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · Q",
                },
                fireEditorControl45 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · R",
                },
                fireExtinguishFeedbackAlpha = {
                    description = "Deckkraft des Symbols von 0 bis 255.",
                    label = "Deckkraft der Löschanzeige",
                },
                fireExtinguishFeedbackEnabled = {
                    description = "Zeigt das Flammensymbol über einem Feuer, während es gelöscht wird.",
                    label = "Löschanzeige aktivieren",
                },
                fireExtinguishFeedbackHeight = {
                    description = "Vertikaler Versatz über dem Feuer, an dem das Symbol gezeichnet wird.",
                    label = "Höhe der Löschanzeige",
                },
                fireExtinguishFeedbackMaxScale = {
                    description = "Größte Symbolgröße, wenn das Löschen gerade erst begonnen hat.",
                    label = "Maximale Größe der Löschanzeige",
                },
                fireExtinguishFeedbackMinScale = {
                    description = "Kleinste Symbolgröße, wenn der Löschfortschritt fast abgeschlossen ist.",
                    label = "Minimale Größe der Löschanzeige",
                },
                fireExtinguisherEffectiveness = {
                    description = "Universeller Wirksamkeitsmultiplikator des Feuerlöschers.",
                    label = "Feuerlöscher-Wirksamkeit",
                },
                fireExtinguisherEnabled = {
                    description = "Erlaubt WEAPON_FIREEXTINGUISHER, jeden Brandtyp zu löschen.",
                    label = "Feuerlöscher aktivieren",
                },
                fireExtinguisherHitRadius = {
                    description = "Konfiguriert: Feuerlöscher-Trefferradius.",
                    label = "Feuerlöscher-Trefferradius",
                },
                fireExtinguisherProgressPerSecond = {
                    description = "Konfiguriert: Feuerlöscher-Löschgeschwindigkeit.",
                    label = "Feuerlöscher-Löschgeschwindigkeit",
                },
                fireExtinguisherRange = {
                    description = "Konfiguriert: Feuerlöscher-Reichweite.",
                    label = "Feuerlöscher-Reichweite",
                },
                fireFemaleBreathingComponents = {
                    description = "Komponentenregeln für weibliche Maske und Luftflasche.",
                    itemLabel = "Komponente",
                    label = "Pflicht-Kleidungskomponenten",
                },
                fireFemaleBreathingProps = {
                    description = "Konfiguriert: Pflicht-Props.",
                    itemLabel = "Objekt",
                    label = "Pflicht-Props",
                },
                fireFemaleHeatComponents = {
                    description = "Komponentenregeln für weibliche Hitzeschutzkleidung.",
                    itemLabel = "Komponente",
                    label = "Pflicht-Kleidungskomponenten",
                },
                fireFemaleHeatProps = {
                    description = "Konfiguriert: Pflicht-Props.",
                    itemLabel = "Objekt",
                    label = "Pflicht-Props",
                },
                fireFemaleProtectiveMaskComponents = {
                    description = "Weibliche Komponentenregeln, die beim Anlegen der Waldbrand-Schutzmaske angewendet werden.",
                    itemLabel = "Komponente",
                    label = "Erforderliche Kleidungskomponenten",
                },
                fireFemaleProtectiveMaskProps = {
                    description = "Konfiguriert: Erforderliche Props.",
                    itemLabel = "Objekt",
                    label = "Erforderliche Props",
                },
                fireFirstSpreadDelaySeconds = {
                    description = "Mindestzeit nach der Zündung, bevor sich ein Feuer ausbreiten darf.",
                    label = "Verzögerung bis zur ersten Ausbreitung",
                },
                fireFlameScaleMultiplier = {
                    description = "Multiplikator für die sichtbare Flammengröße. 1 ist normal; gilt auch für aktive Feuer und verändert nicht die Löschdauer.",
                    label = "Flammengröße",
                },
                fireGearEnabled = {
                    description = "Schaltet Kleidung, Atemschutz und Hitzeschutz-Prüfungen ein oder aus.",
                    label = "Schutzkleidung aktivieren",
                },
                fireHeatBurnDurationMultiplier = {
                    description = "Konfiguriert: Verbrennungsdauer-Multiplikator.",
                    label = "Verbrennungsdauer-Multiplikator",
                },
                fireHeatComponents = {
                    description = "Komponentenregeln für Schutzkleidung. Varianten akzeptieren any, anyNonDefault, eine Zahl oder komma-getrennte Zahlen.",
                    itemLabel = "Komponente",
                    label = "Pflicht-Kleidungskomponenten",
                },
                fireHeatIgnite = {
                    description = "Konfiguriert: Kann trotz Schutz entzünden.",
                    label = "Kann trotz Schutz entzünden",
                },
                fireHeatProps = {
                    description = "Konfiguriert: Pflicht-Props.",
                    itemLabel = "Objekt",
                    label = "Pflicht-Props",
                },
                fireHeatResistancePercent = {
                    description = "Einfache Schutzstärke für komplette Feuerwehrkleidung. 0 bedeutet keine Reduktion, 100 bedeutet kein direkter Feuerschaden.",
                    label = "Hitzeresistenz Prozent",
                },
                fireHeatStressBurnLevel = {
                    description = "Konfiguriert: Verbrennungsstufe.",
                    label = "Verbrennungsstufe",
                },
                fireHeatStressDamageInterval = {
                    description = "Konfiguriert: Hitze-Schadensintervall.",
                    label = "Hitze-Schadensintervall",
                },
                fireHeatStressDirectFlameDistance = {
                    description = "Konfiguriert: Direkte Flammen-Distanz.",
                    label = "Direkte Flammen-Distanz",
                },
                fireHeatStressEnabled = {
                    description = "Konfiguriert: Hitzestress aktivieren.",
                    label = "Hitzestress aktivieren",
                },
                fireHeatStressExposurePower = {
                    description = "Höhere Werte verlangsamen den Hitzaufbau, wenn der Spieler nah, aber nicht direkt im Feuer steht.",
                    label = "Distanz-Hitzekurve",
                },
                fireHeatStressFullHeatDistance = {
                    description = "Konfiguriert: Volle-Hitze-Distanz.",
                    label = "Volle-Hitze-Distanz",
                },
                fireHeatStressInitialGainMultiplier = {
                    description = "Multiplikator, solange die Kerntemperatur noch niedrig ist.",
                    label = "Anfangs-Hitzegewinn-Multiplikator",
                },
                fireHeatStressMaxDistance = {
                    description = "Konfiguriert: Maximale Hitzestress-Distanz.",
                    label = "Maximale Hitzestress-Distanz",
                },
                fireHeatStressProgressionPower = {
                    description = "Höhere Werte halten den frühen Anstieg langsamer und lassen ihn später stärker eskalieren.",
                    label = "Hitzeverlaufskurve",
                },
                fireHeatStressProtectedDamage = {
                    description = "Konfiguriert: Geschätzter Schaden.",
                    label = "Geschätzter Schaden",
                },
                fireHeatStressProtectedDamageLevel = {
                    description = "Konfiguriert: Geschätzte Schadensstufe.",
                    label = "Geschätzte Schadensstufe",
                },
                fireHeatStressProtectedDecay = {
                    description = "Konfiguriert: Geschätzter Abbau.",
                    label = "Geschätzter Abbau",
                },
                fireHeatStressProtectedDirectFlameDistance = {
                    description = "Konfiguriert: Geschätzte direkte Flammen-Distanz.",
                    label = "Geschätzte direkte Flammen-Distanz",
                },
                fireHeatStressProtectedGain = {
                    description = "Konfiguriert: Geschätzter Hitzegewinn.",
                    label = "Geschätzter Hitzegewinn",
                },
                fireHeatStressUnprotectedDamage = {
                    description = "Konfiguriert: Ungeschätzter Schaden.",
                    label = "Ungeschätzter Schaden",
                },
                fireHeatStressUnprotectedDamageLevel = {
                    description = "Konfiguriert: Ungeschätzte Schadensstufe.",
                    label = "Ungeschätzte Schadensstufe",
                },
                fireHeatStressUnprotectedDecay = {
                    description = "Konfiguriert: Ungeschätzter Abbau.",
                    label = "Ungeschätzter Abbau",
                },
                fireHeatStressUnprotectedDirectFlameDistance = {
                    description = "Konfiguriert: Ungeschätzte direkte Flammen-Distanz.",
                    label = "Ungeschätzte direkte Flammen-Distanz",
                },
                fireHeatStressUnprotectedGain = {
                    description = "Konfiguriert: Ungeschätzter Hitzegewinn.",
                    label = "Ungeschätzter Hitzegewinn",
                },
                fireIgnitionGrowthSeconds = {
                    description = "Sekunden, bis ein neu platzierter Menübrand seine volle Größe erreicht. Gilt für neue Brände.",
                    label = "Dauer des anfänglichen Wachstums",
                },
                fireIgnitionStartScale = {
                    description = "Anfängliche Flammengröße im Feuer-Menü. Werte unter 1 wachsen zur vollen Größe des Brandprofils.",
                    label = "Startgröße im Feuer-Menü",
                },
                fireInteriorExtinguishersControl38 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Wandfeuerlöscher · E",
                },
                fireMaxFlameSources = {
                    description = "Gemeinsames Limit für alle Brände pro Client. Nahe Flammen haben Vorrang; kleinere Limits lassen mehr Partikelkapazität für Wasserstrahlen frei.",
                    label = "Maximale sichtbare Flammenquellen",
                },
                fireMaxFlamesPerFire = {
                    description = "Maximale Anzahl an Flammen, die ein einzelnes Feuer enthalten darf.",
                    label = "Maximale Flammen pro Feuer",
                },
                fireMaxSmokeSources = {
                    description = "Gemeinsames Limit für Rauchwolken und Innenraumrauch pro Client. Nahe Quellen haben Vorrang.",
                    label = "Maximale sichtbare Rauchquellen",
                },
                fireMaxSpreadDistance = {
                    description = "Größte Entfernung zu einer bestehenden Flamme, in der eine neue Flamme entstehen darf.",
                    label = "Maximale Ausbreitungsdistanz",
                },
                fireMinSpreadDistance = {
                    description = "Kleinste Entfernung zu einer bestehenden Flamme, in der eine neue Flamme entstehen darf.",
                    label = "Minimale Ausbreitungsdistanz",
                },
                fireNozzleProgressPerSecond = {
                    description = "Löschfortschritt, den Wasser pro Sekunde erzeugt.",
                    label = "Löschgeschwindigkeit des Strahlrohrs",
                },
                fireNozzleRange = {
                    description = "Maximale Entfernung, aus der das Strahlrohr einen Brand treffen kann.",
                    label = "Löschreichweite des Strahlrohrs",
                },
                firePropIgnitionControl177 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Objekt anzünden · BACK",
                },
                firePropIgnitionControl38 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Objekt anzünden · E",
                },
                fireProtectiveMaskComponents = {
                    description = "Komponentenregeln, die beim Anlegen der Waldbrand-Schutzmaske angewendet werden.",
                    itemLabel = "Komponente",
                    label = "Erforderliche Kleidungskomponenten",
                },
                fireProtectiveMaskEnabled = {
                    description = "Aktiviert die wiederverwendbare Filtermaske für Waldbrandrauch ohne Atemluftflasche.",
                    label = "Schutzmaske aktivieren",
                },
                fireProtectiveMaskForceFirstPerson = {
                    description = "Erzwingt die Ego-Perspektive, solange das Schutzmasken-Overlay aktiv ist.",
                    label = "Ego-Perspektive erzwingen",
                },
                fireProtectiveMaskItemEnabled = {
                    description = "Erfordert das konfigurierte Inventar-Item, bevor die Schutzmaske verwendet werden kann.",
                    label = "Schutzmasken-Item erforderlich",
                },
                fireProtectiveMaskItemName = {
                    description = "Konfiguriert: Name des Schutzmasken-Items.",
                    label = "Name des Schutzmasken-Items",
                },
                fireProtectiveMaskOverlayEnabled = {
                    description = "Zeigt das Masken-Overlay in der Ego-Perspektive, solange die Schutzmaske aktiv ist.",
                    label = "Masken-Overlay",
                },
                fireProtectiveMaskProps = {
                    description = "Konfiguriert: Erforderliche Props.",
                    itemLabel = "Objekt",
                    label = "Erforderliche Props",
                },
                fireProtectiveMaskSmokeMultiplier = {
                    description = "Rauchexposition, die den Spieler bei aktiver Schutzmaske weiterhin erreicht.",
                    label = "Rauchexpositions-Multiplikator",
                },
                fireProtectiveMaskToxicMultiplier = {
                    description = "Giftige Exposition, die den Spieler weiterhin erreicht. Höhere Werte machen Pressluftatmer bei gefährlichem Rauch erforderlich.",
                    label = "Multiplikator für giftigen Rauch",
                },
                fireRainEnabled = {
                    description = "Lässt Regen Außenbrände beeinflussen.",
                    label = "Regeneffekte aktivieren",
                },
                fireRainFlameScale = {
                    description = "Optische Flammengröße bei voller Regenintensität.",
                    label = "Flammengröße bei Regen",
                },
                fireRainLargeFireSpreadMultiplier = {
                    description = "Ausbreitung großer Außenbrände bei voller Regenintensität.",
                    label = "Ausbreitungsmultiplikator großer Brände",
                },
                fireRainMinimumIntensity = {
                    description = "Regenwerte unterhalb dieser Schwelle haben keine Wirkung.",
                    label = "Minimale Regenintensität",
                },
                fireRainSmallFireMaxFlames = {
                    description = "Außenbrände bis zu dieser Flammenanzahl können durch Regen gelöscht werden.",
                    label = "Maximale Flammen für Kleinbrände",
                },
                fireRainSmallFireProgressPerSecond = {
                    description = "Löschfortschritt durch Regen pro Sekunde bei voller Wetterintensität.",
                    label = "Löschgeschwindigkeit kleiner Brände",
                },
                fireRainSmokeScale = {
                    description = "Optische Rauchgröße bei voller Regenintensität.",
                    label = "Rauchgröße bei Regen",
                },
                fireRainWeatherIntensity = {
                    description = "Regenwirkung je GTA-Wettertyp von 0.0 bis 1.0.",
                    itemLabel = "Wetter",
                    label = "Wetterintensität",
                },
                fireReignitionChancePercent = {
                    description = "Prozentchance, die jedes Mal gewürfelt wird, wenn eine brennbare Flamme gelöscht wurde.",
                    label = "Wiederaufflamm-Chance Prozent",
                },
                fireReignitionDelaySeconds = {
                    description = "Sekunden zwischen Löschen und der kleinen zurückkehrenden Flamme.",
                    label = "Wiederaufflamm-Verzögerung Sekunden",
                },
                fireReignitionEnabled = {
                    description = "Erlaubt gelöschten brennbaren Flammen, nach kurzer Verzögerung wieder aufzuflammen.",
                    label = "Wiederaufflammen aktivieren",
                },
                fireReignitionExtinguishRequiredPercent = {
                    description = "Prozent des normalen Löschfortschritts, ab dem eine wieder aufgeflammte Flamme endgültig aus ist.",
                    label = "Endgültig aus nach Wiederaufflammen",
                },
                fireReignitionFinalExtinguishHoldSeconds = {
                    description = "Sekunden, die nach vollem Löschfortschritt weiter gelöscht werden muss, bevor eine wieder aufgeflammte Flamme endgültig aus ist.",
                    label = "Endgültig-aus Haltezeit",
                },
                fireReignitionGrowthPerSecond = {
                    description = "Wie viel Skalierung die wieder aufgeflammte Flamme pro Sekunde gewinnt, bis sie volle Größe erreicht.",
                    label = "Wachstum pro Sekunde",
                },
                fireReignitionNearImpactAccuracy = {
                    description = "Löschgenauigkeit, die verwendet wird, wenn nur der Impact nahe an einer wieder aufgeflammten Mini-Flamme liegt.",
                    label = "Nahe Impact-Genauigkeit",
                },
                fireReignitionNearImpactTolerance = {
                    description = "Zusätzliche Meter um eine wieder aufgeflammte Mini-Flamme, in denen ein fast passender Impact noch als Treffer zählt.",
                    label = "Nahe Impact-Toleranz",
                },
                fireReignitionStartScale = {
                    description = "Skalierungs-Multiplikator, mit dem die Flamme wieder startet.",
                    label = "Startgröße der Flamme",
                },
                fireRenderDistance = {
                    description = "Gemeinsame maximale Sichtweite für Flammen und Rauch.",
                    label = "Feuer- und Rauch-Sichtweite",
                },
                fireSmokeDensityMultiplier = {
                    description = "Multipliziert die sichtbare Deckkraft: 0 blendet Rauch aus, 1 ist normal, 2 erhöht die Deckkraft bis zu ihrem Maximum. Rauchschäden bleiben unverändert.",
                    label = "Rauchdichte / Deckkraft",
                },
                fireSmokeScaleMultiplier = {
                    description = "Multiplikator für die Größe aufsteigender Rauchwolken. 1 ist normal; gilt auch für aktiven Rauch.",
                    label = "Rauchgröße",
                },
                fireSmokeWindResponse = {
                    description = "Wie stark die mitgelieferten Raucheffekte dem Wetterwind folgen. Ein Profilwechsel startet die Rauchwolken neu.",
                    label = "Windeinfluss auf Rauch",
                    options = {
                        gentle = "Sanft",
                        none = "Kein Windeinfluss",
                        normal = "Normal",
                        strong = "Stark",
                    },
                },
                fireSoundChainsawEnabled = {
                    description = "Spielt den Kettensägen-Sound in 3D, während ein Spieler einen Baum zersägt.",
                    label = "Kettensäge aktivieren",
                },
                fireSoundChainsawRange = {
                    description = "Entfernung in Metern, in der Spieler die Kettensäge hören können.",
                    label = "Kettensäge Reichweite",
                },
                fireSoundChainsawVolume = {
                    description = "Maximale Lautstärke für den 3D-Kettensägen-Sound.",
                    label = "Kettensäge Lautstärke",
                },
                fireSoundFireAmbientEnabled = {
                    description = "Spielt räumliche Feuergeräusche passend zur Brandart ab.",
                    label = "Feuer-Umgebungssound aktivieren",
                },
                fireSoundFireAmbientRange = {
                    description = "Entfernung in Metern, in der Spieler aktive Feuer hören können.",
                    label = "Feuer-Umgebung Reichweite",
                },
                fireSoundFireAmbientVolume = {
                    description = "Gesamtlautstärke aller räumlichen Feuergeräusche: 0 = stumm, 1 = volle Lautstärke. Änderungen gelten auch für aktive Brände.",
                    label = "Feuer-Umgebung Lautstärke",
                },
                fireSoundFireFlareEnabled = {
                    description = "Spielt den kurzen Flare-Sound bei Wasserreaktionen.",
                    label = "Flare-Sound aktivieren",
                },
                fireSoundFireFlareRange = {
                    description = "Entfernung in Metern, in der Spieler Wasserreaktions-Flare-Sounds hören können.",
                    label = "Flare-Sound Reichweite",
                },
                fireSoundFireFlareVolume = {
                    description = "Maximale Lautstärke für den Wasserreaktions-Flare-Sound.",
                    label = "Flare-Sound Lautstärke",
                },
                fireSpreadAttemptsPerTick = {
                    description = "Anzahl möglicher Ausbreitungspositionen, die bei jeder Aktualisierung geprüft werden.",
                    label = "Ausbreitungsversuche pro Aktualisierung",
                },
                fireSpreadEnabled = {
                    description = "Erlaubt aktiven Feuern, weitere Flammen auf brennbaren Flächen zu erzeugen.",
                    label = "Brandausbreitung aktivieren",
                },
                fireSpreadIntervalSeconds = {
                    description = "Grundintervall zwischen Ausbreitungsprüfungen. Kleinere Werte prüfen die Ausbreitung häufiger.",
                    label = "Ausbreitungsintervall Sekunden",
                },
                fireThirstEnabled = {
                    description = "Erhöht den Durstverbrauch, solange der Spieler Feuerhitze ausgesetzt ist.",
                    label = "Erhöhten Durst aktivieren",
                },
                fireThirstMinimumBaseLossPerMinute = {
                    description = "Minimaler Durstverlust als Multiplikatorbasis, wenn die Framework-Rate zu klein ist, um sie zu bemerken.",
                    label = "Minimaler Basisverlust pro Minute",
                },
                fireThirstMultiplier = {
                    description = "Multipliziert den normalen Durstverlust bei Feuerhitze.",
                    label = "Durst-Multiplikator",
                },
                fireThirstUpdateInterval = {
                    description = "Zeit zwischen Framework-Statusabfragen bei anhaltender Feuerhitze.",
                    label = "Status-Prüfintervall ms",
                },
                fireType = {
                    description = "Bestimmt, welches Firejob-Brandprofil an dieser Anzündstelle verwendet wird.",
                    label = "Art der Brandquelle",
                },
                fireWaterMonitorControl172 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Löschmonitor · UP",
                },
                fireWaterMonitorControl173 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Löschmonitor · DOWN",
                },
                fireWaterMonitorControl174 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Löschmonitor · LEFT",
                },
                fireWaterMonitorControl175 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Löschmonitor · RIGHT",
                },
                fireWaterMonitorControl177 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Löschmonitor · BACK",
                },
                fireWaterMonitorControl202 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Löschmonitor · ESCAPE",
                },
                fireWaterMonitorControl24 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Löschmonitor · MOUSE_LEFT",
                },
                fireWaterMonitorControl241 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Löschmonitor · IOM_WHEEL_UP",
                },
                fireWaterMonitorControl242 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Löschmonitor · IOM_WHEEL_DOWN",
                },
                fireWaterMonitorControl25 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Löschmonitor · MOUSE_RIGHT",
                },
                firetruckHudCursorKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Löschfahrzeug-HUD: Mausbedienung halten",
                },
                firetruckHudToggleKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Löschfahrzeug-HUD umschalten",
                },
                firetruckWaterCannonEnabled = {
                    description = "Erlaubt eingebauten Wasserkanonen unterstützter Fahrzeuge, Brände zu löschen.",
                    label = "Fahrzeug-Wasserkanone aktivieren",
                },
                firetruckWaterCannonMinRange = {
                    description = "Kleinste erreichbare Distanz der festen Fahrzeugkanone, da sie nicht vollständig nach unten zielen kann.",
                    label = "Mindestreichweite der Wasserkanone",
                },
                firetruckWaterCannonModels = {
                    description = "Eine Zeile pro Werfer. Für Dach- und Frontwerfer dasselbe Modell mit unterschiedlichen Kennungen und dem jeweils passenden Rohr-Bone eintragen. Bestehende Einträge nutzen deckGun. Jeder Wasserwerfer braucht pro Fahrzeugmodell eine eindeutige Kennung (1-48 Buchstaben, Ziffern, Unterstriche oder Bindestriche).",
                    itemLabel = "Wasserwerfer",
                    label = "Fahrzeug-Wasserwerfer",
                },
                firetruckWaterCannonProgressPerSecond = {
                    description = "Löschfortschritt, den Fahrzeug-Wasserkanonen pro Sekunde erzeugen.",
                    label = "Löschgeschwindigkeit der Wasserkanone",
                },
                foamTankEnabled = {
                    description = "Konfiguriert: Schaumtank.",
                    label = "Schaumtank",
                },
                foamTankSize = {
                    description = "Konfiguriert: Schaum Liter.",
                    label = "Schaum Liter",
                },
                gearKey = {
                    options = {
                        helmet = "Helm",
                        mask = "Maske",
                        other = "Sonstiges (kein Schutz)",
                        pants = "Hose",
                        shoes = "Schuhe",
                        top = "Oberteil",
                    },
                },
                heatLevelHudPosition = {
                    description = "Position der HUD-Anzeige für Hitzebelastung.",
                    label = "Position der Hitzebelastungsanzeige",
                },
                heliBucketAllowedJobs = {
                    description = "Leer lassen, um alle in diesem Firejob konfigurierten Jobs zu erlauben.",
                    itemLabel = "Beruf",
                    label = "Erlaubte Jobs",
                },
                heliBucketAttachDistance = {
                    description = "Maximale Entfernung zwischen dem Befestigungspunkt am Hubschrauber und dem Behälter.",
                    label = "Maximale Befestigungsdistanz",
                },
                heliBucketAttachKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Helikopter-Löschbehälter an-/abhängen",
                },
                heliBucketAutoAttachOnGround = {
                    description = "Befestigt einen nahen Behälter am Boden automatisch, wenn der Hubschrauber in Reichweite ist.",
                    label = "Seil am Boden automatisch befestigen",
                },
                heliBucketBucketOffsetX = {
                    description = "Lokale X-Position, an der das Seil am Behälter befestigt wird.",
                    label = "Behälter-Seilversatz X",
                },
                heliBucketBucketOffsetY = {
                    description = "Lokale Y-Position, an der das Seil am Behälter befestigt wird.",
                    label = "Behälter-Seilversatz Y",
                },
                heliBucketBucketOffsetZ = {
                    description = "Lokale Z-Position, an der das Seil am Behälter befestigt wird.",
                    label = "Behälter-Seilversatz Z",
                },
                heliBucketCommand = {
                    description = "Befehlsname ohne Schrägstrich, zum Beispiel waterbucket.",
                    label = "Befehl",
                },
                heliBucketCommandEnabled = {
                    description = "Erlaubt das Platzieren des Löschwasserbehälters ohne Item über den Befehl.",
                    label = "Befehlsnutzung aktivieren",
                },
                heliBucketConsumeItem = {
                    description = "Entfernt nach erfolgreicher Platzierung ein konfiguriertes Item.",
                    label = "Item beim Platzieren verbrauchen",
                },
                heliBucketDetachMaxGroundDistance = {
                    description = "Maximale Höhe des Behälters über dem Boden, in der das Abnehmen erlaubt ist.",
                    label = "Maximale Abnahmehöhe",
                },
                heliBucketDumpEnabled = {
                    description = "Erlaubt das Ablassen des gespeicherten Wassers aus dem Behälter.",
                    label = "Wasserabwurf aktivieren",
                },
                heliBucketDumpHitRadius = {
                    description = "Radius um die fallende Wassersäule, in dem Feuer getroffen werden können.",
                    label = "Trefferradius",
                },
                heliBucketDumpJetScale = {
                    description = "Visuelle Größe des Hauptwasserstrahls unter dem Behälter.",
                    label = "Strahlskalierung",
                },
                heliBucketDumpKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Helikopter-Löschwasser ablassen",
                },
                heliBucketDumpLitersPerSecond = {
                    description = "Menge des gespeicherten Wassers, die beim Abwurf pro Sekunde freigesetzt wird.",
                    label = "Abwurfliter pro Sekunde",
                },
                heliBucketDumpProgressPerSecond = {
                    description = "Grundstärke beim Löschen von Feuern innerhalb der Wassersäule.",
                    label = "Löschfortschritt pro Sekunde",
                },
                heliBucketDumpRayLength = {
                    description = "Maximale Distanz nach unten, in der unter dem Behälter nach Feuern gesucht wird.",
                    label = "Prüflänge",
                },
                heliBucketDumpSprayScale = {
                    description = "Visuelle Größe des breiten Sprüheffekts unter dem Behälter.",
                    label = "Sprühskalierung",
                },
                heliBucketEnabled = {
                    description = "Aktiviert Platzierung, Hubschrauberbefestigung, Befüllen und Wasserabwurf des Behälters.",
                    label = "Löschwasserbehälter aktivieren",
                },
                heliBucketGroundAttachDistance = {
                    description = "Maximale Höhe des Behälters über dem Boden für die automatische Befestigung.",
                    label = "Bodenabstand zum Befestigen",
                },
                heliBucketHelicopterOffsets = {
                    description = "Seilbefestigungsposition je Hubschraubermodell; default wird als Standard verwendet.",
                    itemLabel = "Versatz",
                    label = "Hubschrauber-Seilversatz",
                },
                heliBucketHelicopters = {
                    description = "Hubschraubermodelle, die den Löschwasserbehälter befestigen dürfen.",
                    itemLabel = "Hubschrauber",
                    label = "Erlaubte Hubschraubermodelle",
                },
                heliBucketItem = {
                    description = "Inventar-Item zum Platzieren des Löschwasserbehälters.",
                    label = "Itemname",
                },
                heliBucketItemEnabled = {
                    description = "Erlaubt das Platzieren des Löschwasserbehälters mit dem konfigurierten Inventar-Item.",
                    label = "Itemnutzung aktivieren",
                },
                heliBucketLabel = {
                    description = "Name, der bei Interaktionen und Benachrichtigungen angezeigt wird.",
                    label = "Anzeigename",
                },
                heliBucketModel = {
                    description = "Propmodell, das für den Löschwasserbehälter erzeugt wird.",
                    label = "Behälter-Propmodell",
                },
                heliBucketMovingStreamDistance = {
                    description = "Maximale Synchronisierungsdistanz, während der Behälter befestigt ist und bewegt wird.",
                    label = "Streaming-Distanz in Bewegung",
                },
                heliBucketPickupDistance = {
                    description = "Maximale Entfernung, aus der ein unbefestigter Löschwasserbehälter aufgenommen werden kann.",
                    label = "Aufnahmedistanz",
                },
                heliBucketRequireOnDuty = {
                    description = "Erlaubt die Nutzung nur Mitgliedern eines erlaubten Jobs, die im Dienst sind.",
                    label = "Dienst erforderlich",
                },
                heliBucketRequirePilot = {
                    description = "Der Spieler muss auf dem Pilotensitz des Hubschraubers sitzen, um den Behälter zu steuern.",
                    label = "Pilotensitz erforderlich",
                },
                heliBucketReturnItemOnRemove = {
                    description = "Gibt beim Aufnehmen des Löschwasserbehälters ein konfiguriertes Item zurück.",
                    label = "Item beim Aufnehmen zurückgeben",
                },
                heliBucketRopeLength = {
                    description = "Länge des Seils zwischen Hubschrauber und Löschwasserbehälter.",
                    label = "Seillänge",
                },
                heliBucketRopeType = {
                    description = "GTA-Seiltyp-ID für die Verbindung des Behälters.",
                    label = "Seiltyp",
                },
                heliBucketStreamDistance = {
                    description = "Maximale Synchronisierungsdistanz, während der Löschwasserbehälter stillsteht.",
                    label = "Streaming-Distanz",
                },
                heliBucketWaterCapacityLiters = {
                    description = "Maximale Wassermenge, die der Behälter aufnehmen kann.",
                    label = "Kapazität in Litern",
                },
                heliBucketWaterCheckIntervalMs = {
                    description = "Intervall in Millisekunden zwischen den Prüfungen, ob der Behälter eingetaucht ist.",
                    label = "Wasserprüfintervall ms",
                },
                heliBucketWaterEnabled = {
                    description = "Erlaubt dem Löschwasserbehälter, beim Eintauchen Wasser aufzunehmen.",
                    label = "Wasseraufnahme aktivieren",
                },
                heliBucketWaterFillRateLitersPerSecond = {
                    description = "Wassermenge, die pro Sekunde hinzugefügt wird, während der Behälter eingetaucht ist.",
                    label = "Füllrate Liter pro Sekunde",
                },
                heliBucketZOffset = {
                    description = "Vertikale Korrektur beim Platzieren des Behälter-Props auf dem Boden.",
                    label = "Bodenversatz Z",
                },
                hoseAddPointDistance = {
                    description = "Bewegungsdistanz, nach der ein weiterer Schlauchpunkt ergänzt wird.",
                    label = "Distanz für neue Punkte",
                },
                hoseDeployDistance = {
                    description = "Maximale Entfernung zum Fahrzeug, in der ein Schlauch ausgegeben werden darf.",
                    label = "Ausgabedistanz",
                },
                hoseFoamLitersPerSecond = {
                    description = "Verbrauch des Schaumtanks beim Versprühen von Schaum.",
                    label = "Schaum Liter pro Sekunde",
                },
                hoseFoamRefillAnimDict = {
                    description = "Anim Dict während des Schaumauffüllens.",
                    label = "Schaum-Befüllen Anim Dict",
                },
                hoseFoamRefillAnimFlag = {
                    description = "Wiedergabe-Flag der Animation für das Schaumauffüllen.",
                    label = "Schaum-Befüllen Anim Flag",
                },
                hoseFoamRefillAnimName = {
                    description = "Animationsclip während des Schaumauffüllens.",
                    label = "Schaum-Befüllen Anim Name",
                },
                hoseFoamRefillBone = {
                    description = "Ped-Bone, an dem das Auffüll-Prop befestigt wird.",
                    label = "Schaum-Befüllen Bone",
                },
                hoseFoamRefillDistance = {
                    description = "Maximale Distanz zum Fahrzeug während des Befüllens.",
                    label = "Schaum-Befüllen Distanz",
                },
                hoseFoamRefillDurationMs = {
                    description = "Dauer des Fortschrittsbalkens für einen Füllvorgang.",
                    label = "Schaum-Befüllen Dauer ms",
                },
                hoseFoamRefillEnabled = {
                    description = "Erlaubt das Auffüllen von Fahrzeug-Schaumtanks mit einem Inventar-Item.",
                    label = "Schaum-Befüllen aktivieren",
                },
                hoseFoamRefillItem = {
                    description = "Inventar-Item, das zum Befüllen des Schaumtanks benötigt wird.",
                    label = "Schaum-Befüllen Item",
                },
                hoseFoamRefillLiters = {
                    description = "Wie viele Liter Schaum ein Kanister dem Fahrzeugtank hinzufügt.",
                    label = "Schaum-Befüllen Liter",
                },
                hoseFoamRefillOffsetRx = {
                    description = "Neigungsrotation für das Auffüll-Prop.",
                    label = "Schaum-Befüllen Rotation X",
                },
                hoseFoamRefillOffsetRy = {
                    description = "Rollrotation für das Auffüll-Prop.",
                    label = "Schaum-Befüllen Rotation Y",
                },
                hoseFoamRefillOffsetRz = {
                    description = "Gierrotation für das Auffüll-Prop.",
                    label = "Schaum-Befüllen Rotation Z",
                },
                hoseFoamRefillOffsetX = {
                    description = "Horizontaler Handversatz für das Auffüll-Prop.",
                    label = "Schaum-Befüllen Offset X",
                },
                hoseFoamRefillOffsetY = {
                    description = "Vorwärts- oder Rückwärtsversatz an der Hand für das Auffüll-Prop.",
                    label = "Schaum-Befüllen Offset Y",
                },
                hoseFoamRefillOffsetZ = {
                    description = "Vertikaler Handversatz für das Auffüll-Prop.",
                    label = "Schaum-Befüllen Offset Z",
                },
                hoseFoamRefillProp = {
                    description = "Prop, der während des Befüllens in der Hand angezeigt wird.",
                    label = "Schaum-Befüllen Prop",
                },
                hoseFoamRefillRequireOnDuty = {
                    description = "Nur Spieler, die aktuell im Dienst sind, können Schaumtanks auffüllen.",
                    label = "Dienst für Schaum-Befüllen erforderlich",
                },
                hoseFoamWaterLitersPerSecond = {
                    description = "Verbrauch des Wassertanks beim Versprühen von Schaum ohne externe Versorgung.",
                    label = "Schaum-Wasser Liter pro Sekunde",
                },
                hoseGroundActionAnimationDict = {
                    description = "Konfiguriert: Anim Dict.",
                    label = "Anim Dict",
                },
                hoseGroundActionAnimationDurationMs = {
                    description = "Gesamtdauer der Animation in Millisekunden.",
                    label = "Animationsdauer",
                },
                hoseGroundActionAnimationEnabled = {
                    description = "Spielt beim Ablegen und Aufheben des Angriffsschlauchs eine Animation ab.",
                    label = "Handhabungsanimation aktivieren",
                },
                hoseGroundActionAnimationFlag = {
                    description = "Konfiguriert: Animations-Flag.",
                    label = "Animations-Flag",
                },
                hoseGroundActionAnimationLayDownName = {
                    description = "Konfiguriert: Ablegeanimation.",
                    label = "Ablegeanimation",
                },
                hoseGroundActionAnimationPickUpName = {
                    description = "Konfiguriert: Aufhebeanimation.",
                    label = "Aufhebeanimation",
                },
                hoseGroundActionAnimationTransitionMs = {
                    description = "Zeit in Millisekunden, zu der das Strahlrohr zwischen Hand und Boden wechselt.",
                    label = "Zeitpunkt des Objektwechsels",
                },
                hoseGroundOffset = {
                    description = "Vertikaler Offset für neue Schlauchpunkte auf dem Boden.",
                    label = "Schlauch-Bodenoffset",
                },
                hoseGroundedNozzleHeadingOffset = {
                    description = "Gierwinkel-Korrektur, die beim Ablegen zur Blickrichtung des Spielers addiert wird.",
                    label = "Richtungsversatz des Strahlrohrs",
                },
                hoseGroundedNozzleOffset = {
                    description = "Vertikale Korrektur der abgelegten Weapon nach der Bodenplatzierung. Negative Werte setzen sie tiefer.",
                    label = "Bodenoffset des Strahlrohrs",
                },
                hoseGroundedNozzlePitch = {
                    description = "Neigungswinkel, mit dem das Strahlrohr flach auf den Boden gelegt wird.",
                    label = "Neigung des abgelegten Strahlrohrs",
                },
                hoseGroundedNozzleRoll = {
                    description = "Rollkorrektur für das abgelegte Strahlrohr-Modell.",
                    label = "Rollwinkel des abgelegten Strahlrohrs",
                },
                hoseHydrantConnectDistance = {
                    description = "Maximale Distanz zu einem Hydranten-Objekt beim Anschließen einer Versorgungsleitung.",
                    label = "Hydranten-Anschlussdistanz",
                },
                hoseHydrants = {
                    description = "Objektmodelle, die für Schlauchanschlüsse und auf der Karte als Hydranten erkannt werden.",
                    itemLabel = "Hydranten",
                    label = "Hydranten-Objektmodelle",
                },
                hoseMaxLength = {
                    description = "Maximale Schlauchlänge in Metern, bevor sich das Strahlrohr trennt.",
                    label = "Maximale Schlauchlänge",
                },
                hoseNozzleBendDistance = {
                    description = "Distanz zum Formen der Schlauchbiegung hinter dem Strahlrohr.",
                    label = "Strahlrohr-Biegedistanz",
                },
                hoseNozzleExitDirectionX = {
                    description = "Lokale X-Richtung, in der der Schlauch das Strahlrohr verlässt.",
                    label = "Austrittsrichtung X",
                },
                hoseNozzleExitDirectionY = {
                    description = "Lokale Y-Richtung, in der der Schlauch das Strahlrohr verlässt.",
                    label = "Austrittsrichtung Y",
                },
                hoseNozzleExitDirectionZ = {
                    description = "Lokale Z-Richtung, in der der Schlauch das Strahlrohr verlässt.",
                    label = "Austrittsrichtung Z",
                },
                hoseNozzleExitLength = {
                    description = "Gerade Schlauchlänge am Strahlrohr vor der ersten Biegung.",
                    label = "Strahlrohr-Austrittslänge",
                },
                hoseNozzleOffsetX = {
                    description = "X-Offset des Schlauchanschlusses an der Strahlrohr-Weapon.",
                    label = "Strahlrohr-Offset X",
                },
                hoseNozzleOffsetY = {
                    description = "Y-Offset des Schlauchanschlusses an der Strahlrohr-Weapon.",
                    label = "Strahlrohr-Offset Y",
                },
                hoseNozzleOffsetZ = {
                    description = "Z-Offset des Schlauchanschlusses an der Strahlrohr-Weapon.",
                    label = "Strahlrohr-Offset Z",
                },
                hoseDividing = {
                    description = "Aktiviert den platzierbaren Dreifachverteiler mit einzelnen Ventilen und Wasserfluss. Standardmäßig aus.",
                    label = "Schlauchverteiler",
                },
                hosePerformanceMode = {
                    description = "High End priorisiert die flüssigste Schlauchbewegung. Performance reduziert Aktualisierungen und Clientlast.",
                    label = "Schlauch-Performance-Modus",
                    options = {
                        high_end = "Hohes Ende",
                        performance = "Leistung",
                    },
                },
                hosePropBaseLength = {
                    description = "Ursprüngliche Länge des Schlauchsegment-Modells vor der Skalierung.",
                    label = "Prop-Basislänge",
                },
                hosePropBaseRadius = {
                    description = "Ursprünglicher Radius des Schlauchsegment-Modells vor der Skalierung.",
                    label = "Prop-Basisradius",
                },
                hosePropLengthRatio = {
                    description = "Längenkorrektur beim Skalieren des Schlauchsegment-Modells.",
                    label = "Prop-Längenverhältnis",
                },
                hosePropRoll = {
                    description = "Rollkorrektur des Schlauchsegment-Modells in Grad.",
                    label = "Prop-Rollwinkel",
                },
                hosePropsEnabled = {
                    description = "Spawnt sichtbare Schlauchsegmente, während das Strahlrohr genutzt wird. Hydrantenleitungen bleiben auch deaktiviert sichtbar.",
                    label = "Sichtbare Schlauch-Props rendern",
                },
                hosePumpConnectDistance = {
                    description = "Distanz, die geprüft wird, wenn die Pumpe Wasser aus der Umgebung ansaugen soll.",
                    label = "Pumpen-Anschlussdistanz",
                },
                hosePumpControlIdlePressure = {
                    description = "Druck, mit dem eine neue Pumpensteuerung startet.",
                    label = "Startdruck",
                },
                hosePumpControlIdleRpm = {
                    description = "Angezeigte Pumpenmotordrehzahl beim niedrigsten Druck.",
                    label = "Leerlaufdrehzahl",
                },
                hosePumpControlMaxPressure = {
                    description = "Höchster am erweiterten Pumpenpanel einstellbarer Druck.",
                    label = "Maximaldruck",
                },
                hosePumpControlMaxRpm = {
                    description = "Angezeigte Pumpenmotordrehzahl beim Maximaldruck.",
                    label = "Maximaldrehzahl",
                },
                hosePumpControlMinPressure = {
                    description = "Mindestdruck in PSI, ab dem ein Ausgang Wasser liefern kann.",
                    label = "Mindestdruck",
                },
                hosePumpControlPresetPressure = {
                    description = "Druck des Preset-Knopfs und Referenz für den normalen Durchfluss.",
                    label = "Voreingestellter Druck",
                },
                hosePumpControlPressureStep = {
                    description = "PSI, die ein Tastendruck hinzufügt oder entfernt.",
                    label = "Druckschritt",
                },
                hosePumpControlTankFillLitersPerSecond = {
                    description = "Wassermenge, die bei aktiver Tankfüllung pro Sekunde in den Fahrzeugtank fließt.",
                    label = "Tankfüllung Liter/Sekunde",
                },
                hosePumpEnabled = {
                    description = "Erlaubt das Ansaugen aus erkannten natürlichen Wasserquellen.",
                    label = "Tragkraftspritze aktivieren",
                },
                hosePumpIntakeExtraLength = {
                    description = "Zusätzliche Ansaugschlauchlänge in die erkannte Wasseroberfläche hinein.",
                    label = "Zusätzliche Ansauglänge",
                },
                hosePumpIntakeSubmergeDepth = {
                    description = "Tiefe des Ansaugschlauch-Endpunkts unter der erkannten Wasseroberfläche.",
                    label = "Eintauchtiefe des Ansaugschlauchs",
                },
                hosePumpItem = {
                    description = "Inventar-Item, mit dem die tragbare Pumpe direkt platziert wird.",
                    label = "Pumpen-Itemname",
                },
                hosePumpItemEnabled = {
                    description = "Registriert das konfigurierte Pumpen-Item, sodass seine Nutzung die Platzierung startet.",
                    label = "Pumpen-Itemnutzung aktivieren",
                },
                hosePumpItemRequired = {
                    description = "Spieler müssen das konfigurierte Pumpen-Item besitzen, bevor sie eine Pumpenversorgung starten können.",
                    label = "Pumpen-Item erforderlich",
                },
                hosePumpModel = {
                    description = "Objekt, das als tragbare Ansaugpumpe gespawnt wird.",
                    label = "Pumpen-Objektmodell",
                },
                hosePumpNaturalWaterEnabled = {
                    description = "Erlaubt der tragbaren Pumpe, Wasser aus Flüssen, Seen und anderen erkannten Wasserflächen zu entnehmen.",
                    label = "Natürliche Wasserentnahme aktivieren",
                },
                hosePumpPanelStyle = {
                    description = "Einfach nutzt die automatische Pumpensteuerung mit einem Eingang und einem Ausgang. Erweitert aktiviert manuelle Bedienelemente mit bis zu zwei Eingängen und vier Ausgängen.",
                    label = "Pumpenpanel",
                    options = {
                        enhanced = "Erweitertes Panel",
                        simple = "Einfaches Panel",
                    },
                },
                hosePumpTargetDistance = {
                    description = "Maximaler Abstand des Spielers zu einem konfigurierten Pumpenanschluss-Target.",
                    label = "Target-Interaktionsdistanz",
                },
                hosePumpTargetSize = {
                    description = "Radius jedes Targetpunkts an einem Pumpenanschluss.",
                    label = "Targetpunktradius",
                },
                hosePumpWaterProbeDepth = {
                    description = "Wie weit unter jedem Prüfpunkt nach Wasser gesucht wird.",
                    label = "Pumpen-Wasserprüftiefe",
                },
                hosePumpWaterProbeDistance = {
                    description = "Wie weit um den Platzierungspunkt der Pumpe nach Wasser gesucht wird.",
                    label = "Pumpen-Wasserprüfdistanz",
                },
                hoseRadius = {
                    description = "Dargestellter Radius der Schlauchsegmente.",
                    label = "Schlauchradius",
                },
                hoseRelaxPasses = {
                    description = "Anzahl der Constraint-Durchläufe zur Schlauchglättung pro Aktualisierung.",
                    label = "Glättungsdurchläufe",
                },
                hoseSegmentLength = {
                    description = "Zielabstand zwischen simulierten Schlauchpunkten.",
                    label = "Segmentlänge",
                },
                hoseSegmentOverlap = {
                    description = "Sichtbare Überlappung benachbarter Schlauch-Props zum Verbergen von Lücken.",
                    label = "Segmentüberlappung",
                },
                hoseSegmentProp = {
                    description = "Modell, das für jedes sichtbare Schlauchsegment verwendet wird.",
                    label = "Segment-Prop",
                },
                hoseSegmentUpdateDistance = {
                    description = "Mindestbewegung, bevor sichtbare Schlauchsegmente neu aufgebaut werden.",
                    label = "Segment-Aktualisierungsdistanz",
                },
                hoseUpdateInterval = {
                    description = "Basisintervall der Schlauchsimulation in Millisekunden.",
                    label = "Aktualisierungsintervall",
                },
                hoseVehicleBendDistance = {
                    description = "Distanz zum Formen der Schlauchbiegung am Fahrzeug.",
                    label = "Fahrzeug-Biegedistanz",
                },
                hoseVehicleExitLength = {
                    description = "Gerade Schlauchlänge am Fahrzeuganschluss.",
                    label = "Fahrzeug-Austrittslänge",
                },
                hoseVehiclePumpBehaviorActiveRpm = {
                    description = "RPM-Wert, der bei aktiver Fahrzeugpumpe gesetzt wird. Von 0.0 bis 1.0.",
                    label = "Aktive RPM",
                },
                hoseVehiclePumpBehaviorAmbientTemperature = {
                    description = "Niedrigste Pumpentemperatur und Abkühlziel in Grad Celsius.",
                    label = "Umgebungstemperatur",
                },
                hoseVehiclePumpBehaviorCavitationTemperatureGain = {
                    description = "Zusätzliche Zieltemperatur bei vollständiger Kavitation.",
                    label = "Kavitations-Temperaturanstieg",
                },
                hoseVehiclePumpBehaviorCriticalTemperature = {
                    description = "Pumpentemperatur, ab der die kritische Warnung erscheint.",
                    label = "Kritische Temperatur",
                },
                hoseVehiclePumpBehaviorDamageTemperature = {
                    description = "Pumpentemperatur, ab der Motorschaden entsteht.",
                    label = "Schadenstemperatur",
                },
                hoseVehiclePumpBehaviorDryRunDamagePerSecond = {
                    description = "Motorschaden pro Sekunde beim Trockenlauf.",
                    label = "Trockenlauf-Schaden/Sekunde",
                },
                hoseVehiclePumpBehaviorDryRunTemperature = {
                    description = "Zieltemperatur beim Pumpen ohne Wasser.",
                    label = "Trockenlauf-Temperatur",
                },
                hoseVehiclePumpBehaviorEnabled = {
                    description = "Hält Motoren am Laufen und steuert die Pumpen-RPM, während Schlauchsysteme das Fahrzeug nutzen.",
                    label = "Pumpenverhalten aktivieren",
                },
                hoseVehiclePumpBehaviorEngagementMaxSpeed = {
                    description = "Höchste Fahrzeuggeschwindigkeit in Metern pro Sekunde, bei der die Pumpe geschaltet werden darf.",
                    label = "Maximale Aktivierungsgeschwindigkeit",
                },
                hoseVehiclePumpBehaviorEngineDamageEnabled = {
                    description = "Erlaubt Motorschäden durch Überhitzung und Trockenlauf. Standardmäßig deaktiviert; Pumpenwarnungen bleiben aktiv.",
                    label = "Motorschaden durch Pumpe",
                },
                hoseVehiclePumpBehaviorFuelPercentPerMinute = {
                    description = "Grundverbrauch der laufenden Pumpe pro Minute.",
                    label = "Kraftstoff Prozent/Minute",
                },
                hoseVehiclePumpBehaviorImmobilizePumpVehicles = {
                    description = "Verhindert das Losfahren, solange die Fahrzeugpumpe aktiv ist.",
                    label = "Fahrzeug beim Pumpen sperren",
                },
                hoseVehiclePumpBehaviorImmobilizeTransferVehicles = {
                    description = "Verhindert das Losfahren, solange eine Fahrzeug-zu-Fahrzeug-Transferleitung angeschlossen ist.",
                    label = "Transferfahrzeuge blockieren",
                },
                hoseVehiclePumpBehaviorKeepEngineOnDuringPump = {
                    description = "Hält den Motor des Quellfahrzeugs am Laufen, während Handschlauch oder Wasserkanone sprühen.",
                    label = "Motor beim Sprühen an",
                },
                hoseVehiclePumpBehaviorKeepEngineOnDuringTransfer = {
                    description = "Hält Fahrzeugmotoren am Laufen, solange eine Transferleitung angeschlossen ist.",
                    label = "Motor beim Transfer an",
                },
                hoseVehiclePumpBehaviorKeepEngineOnWhenAbandoned = {
                    description = "Hält konfigurierte Pumpenfahrzeuge nach dem Aussteigen am Laufen.",
                    label = "Motor beim Aussteigen anlassen",
                },
                hoseVehiclePumpBehaviorMaxEngineDamagePerSecond = {
                    description = "Maximaler Motorschaden pro Sekunde durch Pumpenbelastung.",
                    label = "Maximaler Schaden/Sekunde",
                },
                hoseVehiclePumpBehaviorOverloadWarningLoad = {
                    description = "Motorlast-Verhältnis, ab dem die Überlastwarnung erscheint.",
                    label = "Überlast-Warnschwelle",
                },
                hoseVehiclePumpBehaviorRpmEnabled = {
                    description = "Hebt die Fahrzeug-RPM an, während Handschlauch oder Wasserkanone aus diesem Fahrzeug sprühen.",
                    label = "Pumpen-RPM anheben",
                },
                hoseVehiclePumpBehaviorThermalResponse = {
                    description = "Wie schnell sich die Pumpe ihrer berechneten Zieltemperatur annähert.",
                    label = "Temperaturreaktion",
                },
                hoseVehiclePumpBehaviorUpdateMs = {
                    description = "Wie oft der Client Motor-, Blockier- und RPM-Verhalten in Millisekunden erneut setzt.",
                    label = "Updateintervall",
                },
                hoseVehiclePumpBehaviorWarningTemperature = {
                    description = "Pumpentemperatur, ab der die Überhitzungswarnung erscheint.",
                    label = "Warntemperatur",
                },
                hoseVehiclePumpHydraulicsCavitationStartRatio = {
                    description = "Anteil der Quellkapazität, ab dem Kavitation beginnt.",
                    label = "Kavitations-Startverhältnis",
                },
                hoseVehiclePumpHydraulicsFrictionLossPsiPerTenMeters = {
                    description = "Druckverlust je zehn Meter aktivem Schlauch.",
                    label = "Reibungsverlust PSI je 10 m",
                },
                hoseVehiclePumpHydraulicsHydrantIntakePressure = {
                    description = "Vom Hydranten gelieferter Eingangsdruck in PSI.",
                    label = "Hydranten-Eingangsdruck",
                },
                hoseVehiclePumpHydraulicsHydrantSupplyLitersPerSecond = {
                    description = "Maximaler Wasserdurchfluss eines Hydranten in Litern pro Sekunde.",
                    label = "Hydrantenleistung",
                },
                hoseVehiclePumpHydraulicsPumpIntakePressure = {
                    description = "Von einer tragbaren Pumpe gelieferter Eingangsdruck in PSI.",
                    label = "Pumpen-Eingangsdruck",
                },
                hoseVehiclePumpHydraulicsPumpSupplyGpm = {
                    description = "Maximaler Wasserdurchfluss aus einer tragbaren Pumpe.",
                    label = "Pumpenversorgung GPM",
                },
                hoseVehiclePumpHydraulicsTankIntakePressure = {
                    description = "Vom Fahrzeugtank gelieferter Eingangsdruck in PSI.",
                    label = "Tank-Eingangsdruck",
                },
                hoseVehiclePumpHydraulicsTankSupplyGpm = {
                    description = "Maximaler Wasserdurchfluss aus dem Fahrzeugtank.",
                    label = "Tankversorgung GPM",
                },
                hoseVehicleTransferAllowExternalSource = {
                    description = "Ein Quellfahrzeug mit Hydranten- oder Pumpenversorgung kann das Ziel füllen, ohne den eigenen Tank zu leeren.",
                    label = "Externe Quelle erlauben",
                },
                hoseVehicleTransferConnectDistance = {
                    description = "Maximale Entfernung des Spielers zum Anschließen der Transferleitung.",
                    label = "Anschlussdistanz",
                },
                hoseVehicleTransferDisconnectWhenSourceEmpty = {
                    description = "Trennt den Transfer automatisch, wenn der Quelltank leer ist.",
                    label = "Stoppen wenn Quelle leer",
                },
                hoseVehicleTransferDisconnectWhenTargetFull = {
                    description = "Trennt den Transfer automatisch, wenn der Zieltank voll ist.",
                    label = "Stoppen wenn Ziel voll",
                },
                hoseVehicleTransferEnabled = {
                    description = "Erlaubt eine Schlauchleitung, die Wasser von einem Feuerwehrfahrzeugtank in einen anderen transferiert.",
                    label = "Fahrzeugtransfer aktivieren",
                },
                hoseVehicleTransferLitersPerSecond = {
                    description = "Wassermenge, die pro Sekunde vom Quellfahrzeug in das Zielfahrzeug bewegt wird.",
                    label = "Liter pro Sekunde",
                },
                hoseVehicleTransferMaxLength = {
                    description = "Maximale Entfernung zwischen zwei verbundenen Fahrzeugen.",
                    label = "Maximale Leitungslange",
                },
                hoseVehicleTransferRequireOnDuty = {
                    description = "Nur Feuerwehrleute im Dienst können Fahrzeug-Wassertransfers erstellen.",
                    label = "Dienst erforderlich",
                },
                hoseVehicleTransferSourceDirectionX = {
                    description = "Konfiguriert: Quelle Richtung X.",
                    label = "Quelle Richtung X",
                },
                hoseVehicleTransferSourceDirectionY = {
                    description = "Konfiguriert: Quelle Richtung Y.",
                    label = "Quelle Richtung Y",
                },
                hoseVehicleTransferSourceDirectionZ = {
                    description = "Konfiguriert: Quelle Richtung Z.",
                    label = "Quelle Richtung Z",
                },
                hoseVehicleTransferSourceOffsetX = {
                    description = "Konfiguriert: Quelle X.",
                    label = "Quelle X",
                },
                hoseVehicleTransferSourceOffsetY = {
                    description = "Konfiguriert: Quelle Y.",
                    label = "Quelle Y",
                },
                hoseVehicleTransferSourceOffsetZ = {
                    description = "Konfiguriert: Quelle Z.",
                    label = "Quelle Z",
                },
                hoseVehicleTransferTargetDirectionX = {
                    description = "Konfiguriert: Ziel Richtung X.",
                    label = "Ziel Richtung X",
                },
                hoseVehicleTransferTargetDirectionY = {
                    description = "Konfiguriert: Ziel Richtung Y.",
                    label = "Ziel Richtung Y",
                },
                hoseVehicleTransferTargetDirectionZ = {
                    description = "Konfiguriert: Ziel Richtung Z.",
                    label = "Ziel Richtung Z",
                },
                hoseVehicleTransferTargetOffsetX = {
                    description = "Konfiguriert: Ziel X.",
                    label = "Ziel X",
                },
                hoseVehicleTransferTargetOffsetY = {
                    description = "Konfiguriert: Ziel Y.",
                    label = "Ziel Y",
                },
                hoseVehicleTransferTargetOffsetZ = {
                    description = "Konfiguriert: Ziel Z.",
                    label = "Ziel Z",
                },
                hoseVehicleTransferTickMs = {
                    description = "Server-Updateintervall für aktive Transferleitungen.",
                    label = "Transfer-Tick ms",
                },
                hoseVehicles = {
                    description = "Fahrzeugmodelle mit Pumpenpanel, Tanks sowie einzeln konfigurierbaren Ein- und Ausgängen.",
                    itemLabel = "Fahrzeug",
                    label = "Pumpenfahrzeuge",
                },
                hoseWaterLitersPerSecond = {
                    description = "Verbrauch des Wassertanks beim Versprühen von Wasser ohne externe Versorgung.",
                    label = "Wasser Liter pro Sekunde",
                },
                hydrantConnection = {
                    description = "Konfiguriert: Hydranten-Verbindung.",
                    label = "Hydranten-Verbindung",
                },
                hydrantRx = {
                    description = "Konfiguriert: Hydrant RX.",
                    label = "Hydrante RX",
                },
                hydrantRy = {
                    description = "Konfiguriert: Hydrant RY.",
                    label = "Hydrante RY",
                },
                hydrantRz = {
                    description = "Konfiguriert: Hydrant RZ.",
                    label = "Hydrante RZ",
                },
                hydrantX = {
                    description = "Konfiguriert: Hydrant X.",
                    label = "Hydrante X",
                },
                hydrantY = {
                    description = "Konfiguriert: Hydrant Y.",
                    label = "Hydrante Y",
                },
                hydrantZ = {
                    description = "Konfiguriert: Hydrant Z.",
                    label = "Hydrante Z",
                },
                igniteDistance = {
                    description = "Wie nah ein Spieler an diese Brandquelle heran muss, um eine Zündung zu setzen.",
                    label = "Abstand zum Setzen der Zündung",
                },
                interiorExtinguishersAllowedJobs = {
                    description = "Leer lassen, um alle Jobs zu erlauben. Dienst erforderlich ausschalten, damit jeder Feuerlöscher entnehmen und auffüllen kann.",
                    itemLabel = "Beruf",
                    label = "Erlaubte Jobs",
                },
                interiorExtinguishersEmptyMountHeadingOffset = {
                    description = "Modellspezifische Drehkorrektur für den leeren Halter.",
                    label = "Halter-Ausrichtung",
                },
                interiorExtinguishersEmptyMountModel = {
                    description = "Custom-Prop, das an der ursprünglichen Position angezeigt wird, solange der Feuerlöscher fehlt.",
                    label = "Modell des leeren Halters",
                },
                interiorExtinguishersEmptyMountOffsetX = {
                    description = "Lokaler Links-/Rechtsversatz nach Anwendung der Prop-Rotation. Negative Werte verschieben nach links.",
                    label = "Halter-Versatz X",
                },
                interiorExtinguishersEmptyMountOffsetY = {
                    description = "Lokaler Vor-/Rückwärtsversatz nach Anwendung der Prop-Rotation.",
                    label = "Halter-Versatz Y",
                },
                interiorExtinguishersEmptyMountOffsetZ = {
                    description = "Lokaler Höhenversatz nach Anwendung der Prop-Rotation.",
                    label = "Halter-Versatz Z",
                },
                interiorExtinguishersEmptyMountStreamDistance = {
                    description = "Entfernung, innerhalb derer leere Feuerlöscher-Halter geladen werden.",
                    label = "Streaming-Distanz des Halters",
                },
                interiorExtinguishersEmptyThresholdPercent = {
                    description = "Füllstand, ab dem ein Feuerlöscher als leer gilt.",
                    label = "Leer-Schwelle in Prozent",
                },
                interiorExtinguishersEnabled = {
                    description = "Erlaubt Feuerwehrleuten, konfigurierte Feuerlöscher-Props aus Interiors zu entnehmen.",
                    label = "Aufnehmen aktivieren",
                },
                interiorExtinguishersFullAmmo = {
                    description = "Roher Waffen-Munitionswert, der bei Inventaren ohne prozentuale Metadaten 100 Prozent Füllstand entspricht.",
                    label = "Munition bei vollem Feuerlöscher",
                },
                interiorExtinguishersInteractionDistance = {
                    description = "Maximale Entfernung, aus der am Feuerlöscher-Prop E gedrückt werden kann.",
                    label = "Aufnahmedistanz",
                },
                interiorExtinguishersItem = {
                    description = "Item oder Waffe, die beim Entnehmen gegeben und beim Auffüllen eines Halters verbraucht wird.",
                    label = "Inventar-Item",
                },
                interiorExtinguishersLabel = {
                    description = "Name, der bei Aufnahme- und Auffüllinteraktionen angezeigt wird.",
                    label = "Anzeigename",
                },
                interiorExtinguishersMaintenanceAllowedJobs = {
                    description = "Zusätzliche Jobs für Feuerlöscher-Radialaktionen. Feuerwehr-Jobs sind immer enthalten.",
                    itemLabel = "Beruf",
                    label = "Radial- und Wartungs-Jobs",
                },
                interiorExtinguishersMaintenanceEnabled = {
                    description = "Verwaltet leere und beschädigte Feuerlöscher.",
                    label = "Wartungsstatus aktivieren",
                },
                interiorExtinguishersMaintenanceRequireOnDuty = {
                    description = "Erlaubte Wartungs-Jobs müssen im Dienst sein.",
                    label = "Dienst erforderlich",
                },
                interiorExtinguishersModels = {
                    description = "Interior-Objektmodelle, die entnommen werden können.",
                    itemLabel = "Modell",
                    label = "Feuerlöscher-Propmodelle",
                },
                interiorExtinguishersNoDutyJobs = {
                    description = "Jobs in dieser Liste dürfen Feuerlöscher ohne Dienst entnehmen und auffüllen.",
                    itemLabel = "Beruf",
                    label = "Jobs ohne Dienst",
                },
                interiorExtinguishersPickupDurationMs = {
                    description = "Animations- und Fortschrittsdauer, bevor der Feuerlöscher entnommen wird.",
                    label = "Entnahmedauer ms",
                },
                interiorExtinguishersPlacementAllowedJobs = {
                    description = "Leer lassen, um die allgemeinen Feuerlöscher-Jobs beziehungsweise alle konfigurierten Feuerwehrjobs zu verwenden.",
                    itemLabel = "Beruf",
                    label = "Jobs für Platzierung",
                },
                interiorExtinguishersPlacementConsumeItem = {
                    description = "Entfernt genau ein Anbauset erst nach erfolgreicher Platzierung.",
                    label = "Item beim Platzieren verbrauchen",
                },
                interiorExtinguishersPlacementDynamic = {
                    description = "Aktiviert Physik für den platzierten Feuerlöscher.",
                    label = "Dynamisches Prop",
                },
                interiorExtinguishersPlacementEnabled = {
                    description = "Erlaubt berechtigten Feuerwehrleuten, Feuerlöscher-Anbausets frei in der Spielwelt zu platzieren.",
                    label = "Platzierung aktivieren",
                },
                interiorExtinguishersPlacementItem = {
                    description = "Inventar-Item, das die Platzierung eines kompletten Feuerlöscher-Anbausets startet.",
                    label = "Platzierungs-Item",
                },
                interiorExtinguishersPlacementModel = {
                    description = "Objektmodell des frei platzierten Feuerlöschers.",
                    label = "Platziertes Prop-Modell",
                },
                interiorExtinguishersPlacementPickupDistance = {
                    description = "Maximale Entfernung zum Entfernen eines platzierten Feuerlöschers.",
                    label = "Aufnahmedistanz",
                },
                interiorExtinguishersPlacementRequireOnDuty = {
                    description = "Nur Feuerwehrleute im Dienst dürfen Feuerlöscher platzieren und aufnehmen.",
                    label = "Dienst für Platzierung erforderlich",
                },
                interiorExtinguishersPlacementReturnItem = {
                    description = "Gibt das Anbauset beim Entfernen des platzierten Props zurück.",
                    label = "Item beim Aufnehmen zurückgeben",
                },
                interiorExtinguishersPlacementStreamDistance = {
                    description = "Entfernung, innerhalb derer der platzierte Feuerlöscher geladen wird.",
                    label = "Streaming-Distanz",
                },
                interiorExtinguishersPlacementWallEnabled = {
                    description = "Richtet den Feuerlöscher an senkrechten Flächen aus, die mit dem Platzierungsstrahl anvisiert werden.",
                    label = "Wandplatzierung aktivieren",
                },
                interiorExtinguishersPlacementWallHeadingOffset = {
                    description = "Dreht den Feuerlöscher nach der Wandausrichtung um seine vertikale Achse.",
                    label = "Wand-Drehkorrektur",
                },
                interiorExtinguishersPlacementWallOffset = {
                    description = "Verschiebt den Feuerlöscher entlang der Oberflächennormale aus der Wand heraus.",
                    label = "Wandabstand",
                },
                interiorExtinguishersPlacementZOffset = {
                    description = "Vertikaler Versatz des platzierten Feuerlöschers.",
                    label = "Boden-Z-Versatz",
                },
                interiorExtinguishersRequireOnDuty = {
                    description = "Nur Mitglieder erlaubter Jobs im Dienst dürfen Feuerlöscher entnehmen und auffüllen.",
                    label = "Dienst erforderlich",
                },
                interiorExtinguishersRestoreDistance = {
                    description = "Maximale Entfernung zu einem leeren Halter, wenn mit Feuerlöscher-Item E gedrückt wird.",
                    label = "Auffülldistanz",
                },
                interiorExtinguishersRestoreDurationMs = {
                    description = "Animations- und Fortschrittsdauer, bevor das Feuerlöscher-Item verbraucht wird.",
                    label = "Auffülldauer ms",
                },
                interiorExtinguishersScanDistance = {
                    description = "Objekt-Scanradius um den Spieler.",
                    label = "Scan-Distanz",
                },
                label = {
                    description = "Konfiguriert: Bezeichnung.",
                    label = "Bezeichnung",
                },
                lighterAnimationDict = {
                    description = "Anim-Dictionary für das Setzen der Zündung.",
                    label = "Animations-Dict",
                },
                lighterAnimationDurationMs = {
                    description = "Wie lange die Anzünd-Animation und der Fortschritt laufen, bevor die Zündung gesetzt wird.",
                    label = "Animationsdauer ms",
                },
                lighterAnimationFlag = {
                    description = "TaskPlayAnim-Flag für die Zünd-Animation.",
                    label = "Animations-Flag",
                },
                lighterAnimationName = {
                    description = "Anim-Clip für das Setzen der Zündung.",
                    label = "Animations-Name",
                },
                lighterConsumeItem = {
                    description = "Verbraucht das konfigurierte Feuerzeug-Item nach erfolgreichem Zündvorgang.",
                    label = "Feuerzeug-Item verbrauchen",
                },
                lighterCooldownSeconds = {
                    description = "Gemeinsamer Cooldown zwischen Feuerzeug-Nutzungen für Props und Fahrzeuge.",
                    label = "Cooldown Sekunden",
                },
                lighterIgniteDelaySeconds = {
                    description = "Verzögerung zwischen erfolgreichem Anzünden und dem eigentlichen Brand, damit der Spieler Zeit zum Weglaufen hat.",
                    label = "Zündverzögerung Sekunden",
                },
                lighterItem = {
                    description = "Inventar-Item, das zum Setzen von Zündungen an Fahrzeugen und anderen Brandquellen genutzt wird.",
                    label = "Feuerzeug-Item",
                },
                lighterVehicleEnabled = {
                    description = "Erlaubt dem Feuerzeug-Item, nahe Fahrzeuge anzuzünden.",
                    label = "Fahrzeug-Zündung aktivieren",
                },
                lighterVehicleMaxDistance = {
                    description = "Maximale Distanz zu einem Fahrzeug, um die Zündung zu setzen.",
                    label = "Fahrzeug-Zünddistanz",
                },
                lighterVehicleOffsetX = {
                    description = "Lokaler X-Offset für die gesetzte Fahrzeugbrand-Position.",
                    label = "Fahrzeug-Brandoffset X",
                },
                lighterVehicleOffsetY = {
                    description = "Lokaler Y-Offset für die gesetzte Fahrzeugbrand-Position.",
                    label = "Fahrzeug-Brandoffset Y",
                },
                lighterVehicleOffsetZ = {
                    description = "Lokaler Z-Offset für die gesetzte Fahrzeugbrand-Position.",
                    label = "Fahrzeug-Brandoffset Z",
                },
                lighterVehicleRequireOnDuty = {
                    description = "Erlaubt die Fahrzeugzündung nur, wenn der Spieler im konfigurierten Feuerwehrjob im Dienst ist.",
                    label = "Feuerwehrdienst erforderlich",
                },
                lighterVehicleRequiredJobs = {
                    description = "Wenn ausgefüllt, funktioniert die Fahrzeugzündung nur bei der konfigurierten Anzahl bestimmter Online-Jobs.",
                    itemLabel = "Beruf",
                    label = "Erforderliche Online-Jobs",
                },
                lighterVehicleSourceScale = {
                    description = "Skalierungs-Multiplikator für mit dem Feuerzeug gestartete Fahrzeugbrände.",
                    label = "Fahrzeug-Brandgröße",
                },
                npcFireReactionsCooldownMs = {
                    description = "Wartezeit, bis derselbe NPC erneut auf einen Brand reagieren darf.",
                    label = "NPC-Reaktions-Cooldown ms",
                },
                npcFireReactionsDurationMs = {
                    description = "Wie lange eine aktive NPC-Reaktion anhält, bevor sie ausläuft.",
                    label = "NPC-Reaktionsdauer ms",
                },
                npcFireReactionsEnabled = {
                    description = "Lässt zivile Npcs in der Nähe aktiver Brände panisch reagieren oder mit dem Handy filmen.",
                    label = "NPC-Brandreaktionen aktivieren",
                },
                npcFireReactionsFilmChance = {
                    description = "Chance von 0.0 bis 1.0, dass ein geeigneter NPC filmt statt gar nicht zu reagieren.",
                    label = "Handy-Filmchance",
                },
                npcFireReactionsFilmEnabled = {
                    description = "Lässt passende Zivilisten anhalten und nahe Brände mit dem Handy filmen.",
                    label = "Handy-Filmen aktivieren",
                },
                npcFireReactionsFilmRadius = {
                    description = "Innerhalb dieser Distanz können Npcs den Brand mit dem Handy filmen.",
                    label = "NPC-Filmradius",
                },
                npcFireReactionsFleeDistance = {
                    description = "Wie weit panische Npcs vor dem Brand fliehen sollen.",
                    label = "NPC-Fluchtdistanz",
                },
                npcFireReactionsMaxTrackedPeds = {
                    description = "Begrenzt, wie viele Npcs gleichzeitig vom System gesteuert werden.",
                    label = "Maximale reagierende Npcs",
                },
                npcFireReactionsPanicEnabled = {
                    description = "Lässt nahe Zivilisten in Panik geraten und fliehen, wenn ein Brand zu nah kommt.",
                    label = "Panikreaktionen aktivieren",
                },
                npcFireReactionsPanicRadius = {
                    description = "Innerhalb dieser Distanz geraten Npcs bevorzugt in Panik und fliehen.",
                    label = "NPC-Panikradius",
                },
                npcFireReactionsRadius = {
                    description = "Maximale Distanz eines Npcs zu einem Brand, um überhaupt reagieren zu können.",
                    label = "NPC-Reaktionsradius",
                },
                npcFireReactionsUpdateInterval = {
                    description = "Wie oft nach passenden Npcs in der Nähe aktiver Brände gesucht wird.",
                    label = "NPC-Reaktionsintervall ms",
                },
                npcRescueAnimalEntrapmentEnabled = {
                    description = "Konfiguriert: Tier-Einklemmung.",
                    label = "Tier-Einklemmung",
                },
                npcRescueAnimalEntrapmentPanicChance = {
                    description = "Konfiguriert: Panikchance eingeklemmtes Tier.",
                    label = "Panikchance eingeklemmtes Tier",
                },
                npcRescueAnimalTreeEnabled = {
                    description = "Konfiguriert: Tier auf Baum / Höhe.",
                    label = "Tier auf Baum / Höhe",
                },
                npcRescueAnimalTreePanicChance = {
                    description = "Konfiguriert: Panikchance Baumtier.",
                    label = "Panikchance Baumtier",
                },
                npcRescueAnimalWaterEnabled = {
                    description = "Konfiguriert: Tier-Wasserrettung.",
                    label = "Tier-Wasserrettung",
                },
                npcRescueAnimalWaterPanicChance = {
                    description = "Konfiguriert: Panikchance Wassertier.",
                    label = "Panikchance Wassertier",
                },
                npcRescueBicycleEnabled = {
                    description = "Konfiguriert: Ländlicher Fahrradunfall.",
                    label = "Ländlicher Fahrradunfall",
                },
                npcRescueDropoffRadius = {
                    description = "Distanz, die nötig ist, um einen geretteten Patienten am Krankenwagen zu übergeben.",
                    label = "Übergaberadius",
                },
                npcRescueEnabled = {
                    description = "Aktiviert NPC-Rettungsmissionen und Aufgabenabläufe.",
                    label = "Aktiviert",
                },
                npcRescueFieldExtractionDurationMs = {
                    description = "Konfiguriert: Standard Rettungs-/Bergungsdauer ms.",
                    label = "Standard Rettungs-/Bergungsdauer ms",
                },
                npcRescueFieldStabilizationDurationMs = {
                    description = "Konfiguriert: Standard Stabilisierungsdauer ms.",
                    label = "Standard Stabilisierungsdauer ms",
                },
                npcRescueForestEnabled = {
                    description = "Konfiguriert: Waldverletzung / Waldrettung.",
                    label = "Waldverletzung / Waldrettung",
                },
                npcRescueRubbleEnabled = {
                    description = "Konfiguriert: Verschüttung / Trümmerrettung.",
                    label = "Verschüttung / Trümmerrettung",
                },
                npcRescueSearchRadius = {
                    description = "Suchradius für Rettungsszenen außerhalb von Fahrzeugen.",
                    label = "Suchradius",
                },
                oilAbsorbentBrushRadius = {
                    description = "Radius jedes Bindemittel-Strichs im Bindemittel-Minispiel.",
                    label = "Streuradius",
                },
                oilAbsorbentGranulesPerMove = {
                    description = "Wie viele Granulat-Partikel pro gültigem Bewegungsschritt erzeugt werden.",
                    label = "Granulat pro Bewegung",
                },
                oilAbsorbentMinigameEnabled = {
                    description = "Ersetzt die einfache Bindeaktion durch das Streu-Minispiel.",
                    label = "Bindemittel-Minispiel aktivieren",
                },
                oilAbsorbentRequiredCoverage = {
                    description = "Wie viel der Spur bedeckt sein muss, damit die Bindemittel-Phase erfolgreich ist.",
                    label = "Nötige Abdeckung",
                },
                oilCleanupAbsorbentItem = {
                    description = "Inventar-Item für die Bindemittel-Phase der Ölspurbeseitigung.",
                    label = "Bindemittel-Item",
                },
                oilCleanupAllowedJobs = {
                    description = "Jobs in dieser Whitelist dürfen Ölspuren zusätzlich zu den in diesem Feuerwehrjob konfigurierten Jobs beseitigen.",
                    label = "Zusätzlich erlaubte Jobs",
                },
                oilCleanupBindDurationMs = {
                    description = "Fallback-Fortschrittsdauer, wenn das Bindemittel-Minispiel deaktiviert ist.",
                    label = "Fallback-Bindezeit ms",
                },
                oilCleanupBroomItem = {
                    description = "Inventar-Item, das zum Aufkehren einer gebundenen Ölspur benötigt wird.",
                    label = "Besen-Item",
                },
                oilCleanupConsumeAbsorbent = {
                    description = "Verbraucht bei erfolgreicher Nutzung ein Bindemittel-Item.",
                    label = "Bindemittel verbrauchen",
                },
                oilCleanupConsumeBroom = {
                    description = "Verbraucht das konfigurierte Besen-Item nach erfolgreicher Reinigung.",
                    label = "Besen-Item verbrauchen",
                },
                oilCleanupRequireOnDuty = {
                    description = "Mitglieder aller erlaubten Reinigungs-Jobs müssen im Dienst sein.",
                    label = "Dienst erforderlich",
                },
                oilCleanupSweepDurationMs = {
                    description = "Fallback-Fortschrittsdauer, wenn das Kehr-Minispiel deaktiviert ist.",
                    label = "Fallback-Kehrzeit ms",
                },
                oilSpillsActive = {
                    description = "Live-Liste aktiver Ölspuren mit Aktionen zum Teleportieren und Löschen.",
                    label = "Aktive Ölspuren",
                },
                oilSpillsDefaultIntensity = {
                    description = "Standard-Gefahrenintensität für neu erzeugte Ölspuren.",
                    label = "Standard-Intensität",
                },
                oilSpillsDeleteOnRestart = {
                    description = "Löscht gespeicherte Ölspuren beim Ressourcenstart, anstatt sie wiederherzustellen.",
                    label = "Bei Neustart löschen",
                },
                oilSpillsEnabled = {
                    description = "Aktiviert Ölpfützen, Rutscheffekte und Reinigung. Automatische Ölspuren nach Unfällen oder durch Verschleiß benötigen Sky Mechanic oder eine andere angebundene Ressource.",
                    label = "Ölspur-System aktivieren",
                },
                oilSpillsInteractionDistance = {
                    description = "Distanz, die für Interaktion und Reinigung einer Ölspur nötig ist.",
                    label = "Interaktionsdistanz",
                },
                oilSpillsLifetimeMinutes = {
                    description = "Wie lange unbeseitigte Ölspuren aktiv bleiben, bevor sie verfallen.",
                    label = "Lebensdauer Minuten",
                },
                oilSpillsMaxActive = {
                    description = "Maximale Anzahl synchronisierter Ölspuren, die gleichzeitig existieren dürfen.",
                    label = "Maximal aktive Ölspuren",
                },
                oilSpillsObjectGroundOffset = {
                    description = "Bodenoffset für Ölspur-Props, damit sie besser auf der Straße liegen.",
                    label = "Objekt-Bodenoffset",
                },
                oilSpillsRemoveBelow = {
                    description = "Spuren werden automatisch entfernt, sobald ihre Intensität unter diesen Wert fällt.",
                    label = "Entfernen unter Intensität",
                },
                oilSpillsResetIds = {
                    buttonLabel = "Ids zurücksetzen",
                    description = "Nummeriert alle aktiven Ölspuren ab 1 lückenlos neu und synchronisiert alle Spieler.",
                    label = "Ölspuren-Ids zurücksetzen",
                },
                oilSpillsSlipRadius = {
                    description = "Radius, in dem Spieler und Peds auf der Spur ausrutschen können.",
                    label = "Rutschradius",
                },
                oilSweepBrushRadius = {
                    description = "Radius um den Besenstrich, der zum Kehrfortschritt beiträgt.",
                    label = "Kehr-Radius",
                },
                oilSweepMaxSidewaysRatio = {
                    description = "Maximal erlaubter seitlicher Bewegungsanteil, bevor ein Kehrstrich ignoriert wird.",
                    label = "Seitliche Toleranz",
                },
                oilSweepMinStrokeDistance = {
                    description = "Minimale Cursorstrecke, bevor ein Kehrstrich Fortschritt erzeugen kann.",
                    label = "Minimale Kehrstrecke",
                },
                oilSweepMinUpwardDelta = {
                    description = "Minimale Aufwärtsbewegung für einen gültigen Besenstrich.",
                    label = "Minimale Aufwärtsbewegung",
                },
                oilSweepMinigameEnabled = {
                    description = "Ersetzt den einfachen Kehr-Fortschrittsbalken durch das Besen-Minispiel.",
                    label = "Kehr-Minispiel aktivieren",
                },
                oilSweepRequiredProgress = {
                    description = "Fortschritt von 0.0 bis 1.0, der für das Entfernen einer gebundenen Ölspur benötigt wird.",
                    label = "Nötiger Kehrfortschritt",
                },
                oilSweepToolWidth = {
                    description = "Angezeigte Breite des Besenbilds im Kehr-Minispiel.",
                    label = "Besenbild-Breite",
                },
                playerEntrapmentAllowOffDuty = {
                    description = "Zählt beim Prüfen der Mindestanforderungen auch den konfigurierten Off-Duty-Gegenpart eines Jobs mit.",
                    label = "Off-Duty Jobs mitzählen",
                },
                playerEntrapmentAutoReleaseWhenRepaired = {
                    description = "Konfiguriert: Bei Reparatur freigeben.",
                    label = "Bei Reparatur freigeben",
                },
                playerEntrapmentBaseChance = {
                    description = "Konfiguriert: Basis-Chance.",
                    label = "Basis-Chance",
                },
                playerEntrapmentCooldownSeconds = {
                    description = "Konfiguriert: Cooldown Sekunden.",
                    label = "Cooldown Sekunden",
                },
                playerEntrapmentDoorOverviewEnabled = {
                    description = "Zeigt im Einklemm-HUD ein kleines Fahrzeug mit beschädigten, geöffneten und nutzbaren Ausstiegstüren.",
                    label = "Türübersicht anzeigen",
                },
                playerEntrapmentEnabled = {
                    description = "Spieler können nach ausreichendem Fahrzeugschaden oder einem Überschlag eingeklemmt werden.",
                    label = "Spieler-Einklemmung aktivieren",
                },
                playerEntrapmentHudEnabled = {
                    description = "Konfiguriert: Einklemm-HUD anzeigen.",
                    label = "Einklemm-HUD anzeigen",
                },
                playerEntrapmentMinBodyHealthLoss = {
                    description = "Karosserie-Schadenspunkte, die bei einem Zusammenstoß mindestens verloren gehen müssen. Kleinere Werte lösen leichter aus.",
                    label = "Minimaler Karosserieschaden",
                },
                playerEntrapmentMinEngineHealthLoss = {
                    description = "Motor-Schadenspunkte, die bei einem Zusammenstoß mindestens verloren gehen müssen. Kleinere Werte lösen leichter aus.",
                    label = "Minimaler Motorschaden",
                },
                playerEntrapmentPreventExit = {
                    description = "Konfiguriert: Fahrzeug verlassen blockieren.",
                    label = "Fahrzeug verlassen blockieren",
                },
                playerEntrapmentReleaseOnAnyDoor = {
                    description = "Konfiguriert: Nach beliebiger geöffneter Tür freigeben.",
                    label = "Nach beliebiger geöffneter Tür freigeben",
                },
                playerEntrapmentRepairedBodyHealthThreshold = {
                    description = "Konfiguriert: Reparatur-Karosserieschwelle.",
                    label = "Reparatur-Karosserieschwelle",
                },
                playerEntrapmentRepairedEngineHealthThreshold = {
                    description = "Konfiguriert: Reparatur-Motorschwelle.",
                    label = "Reparatur-Motorschwelle",
                },
                playerEntrapmentRepairedMaxRoll = {
                    description = "Konfiguriert: Reparatur-Maximal-Rollwinkel.",
                    label = "Reparatur-Maximal-Rollwinkel",
                },
                playerEntrapmentRequiredJobs = {
                    description = "Wenn hier Einträge vorhanden sind, wird eine Fahrzeug-Einklemmung nur ausgelöst, wenn die angegebene Anzahl bestimmter Jobs online ist.",
                    itemLabel = "Beruf",
                    label = "Nötige Online-Jobs",
                },
                playerEntrapmentRolloverBonusChance = {
                    description = "Konfiguriert: Überschlag-Bonus-Chance.",
                    label = "Überschlag-Bonus-Chance",
                },
                playerEntrapmentRolloverMinRoll = {
                    description = "Konfiguriert: Überschlag-Schwelle.",
                    label = "Überschlag-Schwelle",
                },
                propIgnitionDuplicateDistance = {
                    description = "Verhindert das Setzen einer weiteren Zündung zu nah an einem bereits bestehenden Brand.",
                    label = "Mindestabstand zu bestehendem Brand",
                },
                propIgnitionEnabled = {
                    description = "Erlaubt es, ausgewählte Objekte und feste Brandquellen mit dem Feuerzeug zu entzünden.",
                    label = "Zündbare Objekte aktivieren",
                },
                propIgnitionHighlightEnabled = {
                    description = "Markiert passende Brandquellen während der Suche mit einer Umrandung.",
                    label = "Anzündstellen markieren",
                },
                propIgnitionMaxActiveFires = {
                    description = "Maximale Anzahl gleichzeitig aktiver Brände, die über solche Anzündstellen gestartet wurden.",
                    label = "Maximal aktive Objektbrände",
                },
                propIgnitionProps = {
                    description = "Objektmodelle oder feste Brandquellen, an denen mit dem Feuerzeug eine Zündung gesetzt werden darf.",
                    itemLabel = "Brandquelle",
                    label = "Mögliche Anzündstellen",
                },
                propIgnitionRequireLineOfSight = {
                    description = "Nur Brandquellen mit freier Sicht dürfen markiert und verwendet werden.",
                    label = "Freie Sicht erforderlich",
                },
                propIgnitionScanDistance = {
                    description = "Radius, in dem mögliche Anzündstellen in der Umgebung erkannt werden.",
                    label = "Suchradius für Anzündstellen",
                },
                propIgnitionScanDurationMs = {
                    description = "Wie lange mögliche Anzündstellen sichtbar markiert bleiben, bevor die Suche endet.",
                    label = "Markersdauer ms",
                },
                pumpDischargeCount = {
                    description = "Konfiguriert: Pumpenausgaenge.",
                    label = "Pumpenausgaenge",
                },
                rescueCushionAllowedJobs = {
                    description = "Leer lassen, damit alle konfigurierten Feuerwehrjobs den Sprungretter platzieren duerfen.",
                    itemLabel = "Beruf",
                    label = "Erlaubte Jobs",
                },
                rescueCushionConsumeItem = {
                    description = "Entfernt beim Platzieren ein Sprungretter-Item aus dem Inventar.",
                    label = "Item beim Platzieren verbrauchen",
                },
                rescueCushionEnabled = {
                    description = "Schaltet das Sprungretter-System vollständig ein oder aus.",
                    label = "Sprungretter aktivieren",
                },
                rescueCushionItem = {
                    description = "Inventar-Item zum Platzieren des Sprungretters.",
                    label = "Itemname",
                },
                rescueCushionLabel = {
                    description = "Anzeigename für den platzierten Sprungretter.",
                    label = "Bezeichnung",
                },
                rescueCushionLandingHeight = {
                    description = "Maximaler Höhenunterschied über dem Sprungretter, bei dem der Landeschutz noch greift.",
                    label = "Landehöhe",
                },
                rescueCushionLandingRadius = {
                    description = "Horizontaler Radius um den Sprungretter, in dem fallende Spieler geschützt werden.",
                    label = "Landeradius",
                },
                rescueCushionModel = {
                    description = "Welt-Propmodell, das beim Platzieren des Sprungretters erzeugt wird.",
                    label = "Propmodell",
                },
                rescueCushionPickupDistance = {
                    description = "Entfernung, aus der ein Spieler den platzierten Sprungretter aufnehmen kann.",
                    label = "Aufnahmedistanz",
                },
                rescueCushionRequireOnDuty = {
                    description = "Nur Feuerwehrleute im Dienst dürfen den Sprungretter platzieren.",
                    label = "Dienst erforderlich",
                },
                rescueCushionReturnItemOnRemove = {
                    description = "Gibt dem Spieler beim Aufnehmen des Sprungretters das konfigurierte Item zurück.",
                    label = "Item beim Aufnehmen zurückgeben",
                },
                rescueCushionStreamDistance = {
                    description = "Distanz, ab der der platzierte Sprungretter für Spieler in der Nähe gestreamt wird.",
                    label = "Streaming-Distanz",
                },
                rescueCushionZOffset = {
                    description = "Vertikaler Versatz für das platzierte Sprungretter-Prop.",
                    label = "Platzierungsversatz Z",
                },
                rx = {
                    description = "Konfiguriert: RX.",
                    label = "RX",
                },
                ry = {
                    description = "Konfiguriert: RY.",
                    label = "RY",
                },
                rz = {
                    description = "Konfiguriert: RZ.",
                    label = "RZ",
                },
                scbaHudPosition = {
                    description = "Position der Atemschutz-Manometeranzeige.",
                    label = "Manometer-Position",
                },
                scenarioAutomaticMissions = {
                    description = "Aktiviere den automatischen Start pro Einsatz, lege die benötigte Anzahl im Dienst fest, wähle die dafür zählenden Dienst-Jobs und die Jobs, die den Dispatch erhalten. Leere Listen verwenden die globalen Dienst- bzw. Dispatch-Jobs.",
                    itemLabel = "Einsatz",
                    label = "Verfügbare Einsätze",
                },
                scenarioCreatorAllowRescue = {
                    description = "Erlaubt dem Missionseditor, Patienten- und Tierrettungsaufgaben zu platzieren.",
                    label = "Rettungs-Tab",
                },
                scenarioCreatorAllowVehicleFire = {
                    description = "Erlaubt dem Missionseditor, konfigurierte brennende Fahrzeuge zu platzieren.",
                    label = "Fahrzeugbrand-Tab",
                },
                scenarioCreatorEnabled = {
                    description = "Aktiviert den Feuer-Missionseditor und die Hub-Werkzeuge.",
                    label = "Aktiviert",
                },
                scenarioCreatorOpenMenu = {
                    buttonLabel = "Missionseditor öffnen",
                    description = "Öffnet das Sky Fire Missionseditor-Menü und schließt den Job-Konfigurator.",
                    label = "Missionseditor-Menü",
                    unsavedTooltip = "Zuerst speichern",
                },
                scenarioDispatchEnabled = {
                    description = "Erstellt einen \"sky_jobs_base\"-Einsatz, wenn eine Mission gestartet wird.",
                    label = "Dispatch senden",
                },
                scenarioDispatchJobs = {
                    description = "Wird verwendet, wenn für einen Einsatz keine eigenen Dispatch-Jobs eingetragen sind.",
                    itemLabel = "Beruf",
                    label = "Dispatch-Zielberufe",
                },
                scenarioRandomChance = {
                    description = "Chance pro Intervall von 0.0 bis 1.0.",
                    label = "Auslösechance",
                },
                scenarioRandomEnabled = {
                    description = "Startet nach dem konfigurierten Intervall automatisch eine aktivierte Mission.",
                    label = "Automatische Missionen aktivieren",
                },
                scenarioRandomSelectionMode = {
                    description = "Die zufällige Rotation startet jeden aktuell geeigneten Einsatz einmal, bevor sich einer wiederholt. Reiner Zufall erlaubt Wiederholungen.",
                    label = "Einsatzauswahl",
                    options = {
                        rotation = "Zufällige Rotation",
                        random = "Reiner Zufall",
                    },
                },
                scenarioRandomIntervalMax = {
                    description = "Konfiguriert: Maximales Intervall Minuten.",
                    label = "Maximales Intervall Minuten",
                },
                scenarioRandomIntervalMin = {
                    description = "Konfiguriert: Minimales Intervall Minuten.",
                    label = "Minimales Intervall Minuten",
                },
                scenarioRandomJobs = {
                    description = "Spieler dieser Jobs im Dienst zählen, wenn für die ausgewählte Mission keine eigenen Einsatz-Jobs eingetragen sind.",
                    itemLabel = "Beruf",
                    label = "Standard-Dienst-Jobs",
                },
                scenarioRandomManualOnly = {
                    description = "Konfiguriert: Nur manuell startbare Einsätze.",
                    label = "Nur manuell startbare Einsätze",
                },
                smokePoisoningEnabled = {
                    description = "Schaltet Rauchbelastung, Rauchvergiftung und zugehörige Raucheffekte ein oder aus.",
                    label = "Rauchvergiftung aktivieren",
                },
                smokeVehicleClosedExposureMultiplier = {
                    description = "Rauchbelastungs-Multiplikator, solange alle relevanten Seitenscheiben noch intakt sind.",
                    label = "Rauch-Multiplikator bei geschlossenem Fahrzeug",
                },
                smokeVehicleExposureMultiplier = {
                    description = "Rauchbelastungs-Multiplikator, sobald ein geschütztes Fahrzeug seinen Scheibenschutz verliert oder der Fahrzeugtyp nicht geschützt ist.",
                    label = "Rauch-Multiplikator bei offenem oder beschädigtem Fahrzeug",
                },
                smokeVehicleProtectAutomobiles = {
                    description = "Konfiguriert: Autos schützen.",
                    label = "Autos schützen",
                },
                smokeVehicleProtectBoats = {
                    description = "Konfiguriert: Boote schützen.",
                    label = "Boote schützen",
                },
                smokeVehicleProtectCycles = {
                    description = "Konfiguriert: Fahrrader schützen.",
                    label = "Fahrrader schützen",
                },
                smokeVehicleProtectHelicopters = {
                    description = "Konfiguriert: Helikopter schützen.",
                    label = "Helikopter schützen",
                },
                smokeVehicleProtectMotorcycles = {
                    description = "Konfiguriert: Motorrader schützen.",
                    label = "Motorrader schützen",
                },
                smokeVehicleProtectPlanes = {
                    description = "Konfiguriert: Flugzeuge schützen.",
                    label = "Flugzeuge schützen",
                },
                smokeVehicleProtectionEnabled = {
                    description = "Lässt konfigurierte Fahrzeugtypen ihre Insassen vor Rauch schützen, solange das Fahrzeug dicht bleibt.",
                    label = "Fahrzeug-Rauchschutz aktivieren",
                },
                smokeWarningHudPosition = {
                    description = "Position der HUD-Anzeige für Rauchvergiftung.",
                    label = "Position der Rauchvergiftungsanzeige",
                },
                societyRewardFireEnabled = {
                    description = "Globaler Schalter für Society-Auszahlungen, nachdem ein Brand gelöscht wurde.",
                    label = "Brand-Auszahlungen aktivieren",
                },
                societyRewardFireJobs = {
                    description = "Konfiguriere jeden Job einzeln mit eigenem Aktiv-Status und Auszahlungsbetrag. Trage den Jobnamen ein; dessen konfigurierte Society erhält das Geld.",
                    itemLabel = "Beruf",
                    label = "Brand-Belohnungsjobs",
                },
                societyRewardFireScenarioEnabled = {
                    description = "Zahlt die Brand-Belohnung auch aus, wenn ein Brand aus einer Mission des Mission Creators gelöscht wurde.",
                    label = "Missionsbrände auszahlen",
                },
                societyRewardOilEnabled = {
                    description = "Globaler Schalter für Society-Auszahlungen, nachdem eine Ölspur gereinigt wurde.",
                    label = "Öl-Auszahlungen aktivieren",
                },
                societyRewardOilJobs = {
                    description = "Konfiguriere jeden Job einzeln mit eigenem Aktiv-Status und Auszahlungsbetrag. Trage den Jobnamen ein; dessen konfigurierte Society erhält das Geld.",
                    itemLabel = "Beruf",
                    label = "Öl-Belohnungsjobs",
                },
                societyRewardOilScenarioEnabled = {
                    description = "Zahlt die Öl-Belohnung auch aus, wenn eine Ölspur aus einer Mission des Mission Creators gereinigt wurde.",
                    label = "Missionsölspuren auszahlen",
                },
                societyRewardRescueEnabled = {
                    description = "Globaler Schalter für Society-Auszahlungen, nachdem eine Rettungsaufgabe abgeschlossen wurde.",
                    label = "Rettungs-Auszahlungen aktivieren",
                },
                societyRewardRescueJobs = {
                    description = "Konfiguriere jeden Job einzeln mit eigenem Aktiv-Status und Auszahlungsbetrag. Trage den Jobnamen ein; dessen konfigurierte Society erhält das Geld.",
                    itemLabel = "Beruf",
                    label = "Rettungs-Belohnungsjobs",
                },
                societyRewardRescueScenarioEnabled = {
                    description = "Zahlt die Rettungs-Belohnung auch aus, wenn eine Rettungsaufgabe aus einer Mission des Mission Creators abgeschlossen wurde.",
                    label = "Missionsrettungen auszahlen",
                },
                societyRewardTreeEnabled = {
                    description = "Globaler Schalter für Society-Auszahlungen, nachdem ein umgestürzter Baum geräumt wurde.",
                    label = "Baum-Auszahlungen aktivieren",
                },
                societyRewardTreeJobs = {
                    description = "Konfiguriere jeden Job einzeln mit eigenem Aktiv-Status und Auszahlungsbetrag. Trage den Jobnamen ein; dessen konfigurierte Society erhält das Geld.",
                    itemLabel = "Beruf",
                    label = "Baum-Belohnungsjobs",
                },
                societyRewardTreeScenarioEnabled = {
                    description = "Zahlt die Baum-Belohnung auch aus, wenn ein umgestürzter Baum aus einer Mission des Mission Creators geräumt wurde.",
                    label = "Missionsbäume auszahlen",
                },
                sourceScale = {
                    description = "Skalierungs-Multiplikator für den Brand, der an dieser Anzündstelle entsteht.",
                    label = "Größe des entstehenden Brandes",
                },
                textures = {
                    description = "Konfiguriert: Texturen.",
                    label = "Texturen",
                },
                trappedRescueAllowAnyDoor = {
                    description = "Konfiguriert: Beliebige entfernte Tür erlauben.",
                    label = "Beliebige entfernte Tür erlauben",
                },
                trappedRescueAllowCarry = {
                    description = "Konfiguriert: Gerettete Person tragen erlauben.",
                    label = "Gerettete Person tragen erlauben",
                },
                trappedRescueAllowDrop = {
                    description = "Konfiguriert: Person absetzen erlauben.",
                    label = "Person absetzen erlauben",
                },
                trappedRescueAmbulanceFreeze = {
                    description = "Konfiguriert: Krankenwagen einfrieren.",
                    label = "Krankenwagen einfrieren",
                },
                trappedRescueAmbulanceInvincible = {
                    description = "Konfiguriert: Krankenwagen unzerstörbar.",
                    label = "Krankenwagen unzerstörbar",
                },
                trappedRescueAmbulanceLights = {
                    description = "Konfiguriert: Blaulicht aktivieren.",
                    label = "Blaulicht aktivieren",
                },
                trappedRescueAmbulanceOpenRearDoors = {
                    description = "Konfiguriert: Hecktüren öffnen.",
                    label = "Hecktüren öffnen",
                },
                trappedRescueDropoffRadius = {
                    description = "Konfiguriert: Krankenwagen-Übergaberadius.",
                    label = "Krankenwagen-Übergaberadius",
                },
                trappedRescueEnabled = {
                    description = "Aktiviert szenariobasierte Personen- und Tierrettungsaufgaben.",
                    label = "NPC-Rettungsaufgaben aktivieren",
                },
                trappedRescueExtractionDurationMs = {
                    description = "Konfiguriert: Fahrzeug-Rettungsdauer ms.",
                    label = "Fahrzeug-Rettungsdauer ms",
                },
                trappedRescueForceGain = {
                    description = "Konfiguriert: Kraftgewinn pro Sekunde.",
                    label = "Kraftgewinn pro Sekunde",
                },
                trappedRescueForceLoss = {
                    description = "Konfiguriert: Kraftverlust pro Sekunde.",
                    label = "Kraftverlust pro Sekunde",
                },
                trappedRescueForceMax = {
                    description = "Konfiguriert: Guter Zug Maximum.",
                    label = "Guter Zug Maximum",
                },
                trappedRescueForceMin = {
                    description = "Konfiguriert: Guter Zug Minimum.",
                    label = "Guter Zug Minimum",
                },
                trappedRescueInteractionDistance = {
                    description = "Konfiguriert: NPC-Interaktionsdistanz.",
                    label = "NPC-Interaktionsdistanz",
                },
                trappedRescueJamChance = {
                    description = "Konfiguriert: Gurtklemmen-Chance.",
                    label = "Gurtklemmen-Chance",
                },
                trappedRescueMaxMisses = {
                    description = "Konfiguriert: Erlaubte Fehlversuche.",
                    label = "Erlaubte Fehlversuche",
                },
                trappedRescuePullsRequired = {
                    description = "Konfiguriert: Nötige starke Züge.",
                    label = "Nötige starke Züge",
                },
                trappedRescueReliefHoldMs = {
                    description = "Konfiguriert: Spannung halten ms.",
                    label = "Spannung halten ms",
                },
                trappedRescueReliefZoneMax = {
                    description = "Konfiguriert: Spannungszone Maximum.",
                    label = "Spannungszone Maximum",
                },
                trappedRescueReliefZoneMin = {
                    description = "Konfiguriert: Spannungszone Minimum.",
                    label = "Spannungszone Minimum",
                },
                trappedRescueRequireDoor = {
                    description = "Konfiguriert: Entfernte Tür erforderlich.",
                    label = "Entfernte Tür erforderlich",
                },
                trappedRescueRequireGlass = {
                    description = "Konfiguriert: Eingeschlagene Scheibe erforderlich.",
                    label = "Eingeschlagene Scheibe erforderlich",
                },
                trappedRescueRequireMatchingSide = {
                    description = "Konfiguriert: Scheibe muss zur Patientenseite passen.",
                    label = "Scheibe muss zur Patientenseite passen",
                },
                trappedRescueRequireOnDuty = {
                    description = "Konfiguriert: Dienst erforderlich.",
                    label = "Dienst erforderlich",
                },
                trappedRescueSeatbeltDurationMs = {
                    description = "Konfiguriert: Zeitlimit ms.",
                    label = "Zeitlimit ms",
                },
                trappedRescueSeatbeltEnabled = {
                    description = "Konfiguriert: Sicherheitsgurt-Minispiel aktivieren.",
                    label = "Sicherheitsgurt-Minispiel aktivieren",
                },
                treeBlipColor = {
                    description = "Konfiguriert: Blip-Farbe.",
                    label = "Blip-Farbe",
                },
                treeBlipLabel = {
                    description = "Konfiguriert: Blip-Beschriftung.",
                    label = "Blip-Beschriftung",
                },
                treeBlipScale = {
                    description = "Konfiguriert: Blip-Größe.",
                    label = "Blip-Größe",
                },
                treeBlipSprite = {
                    description = "Konfiguriert: Blip-Symbol.",
                    label = "Blip-Symbol",
                },
                treeCarryAnimDict = {
                    description = "Konfiguriert: Trage-Animationsverzeichnis.",
                    label = "Trage-Animationsverzeichnis",
                },
                treeCarryAnimFlag = {
                    description = "Konfiguriert: Trage-Animations-Flag.",
                    label = "Trage-Animations-Flag",
                },
                treeCarryAnimName = {
                    description = "Konfiguriert: Trage-Animationsname.",
                    label = "Trage-Animationsname",
                },
                treeCarryMoveBlend = {
                    description = "Konfiguriert: Trage-Bewegungsfaktor.",
                    label = "Trage-Bewegungsfaktor",
                },
                treeCarryOffsetRx = {
                    description = "Konfiguriert: Trage-Rotation X.",
                    label = "Trage-Rotation X",
                },
                treeCarryOffsetRy = {
                    description = "Konfiguriert: Trage-Rotation Y.",
                    label = "Trage-Rotation Y",
                },
                treeCarryOffsetRz = {
                    description = "Konfiguriert: Trage-Rotation Z.",
                    label = "Trage-Rotation Z",
                },
                treeCarryOffsetX = {
                    description = "Konfiguriert: Trage-Versatz X.",
                    label = "Trage-Versatz X",
                },
                treeCarryOffsetY = {
                    description = "Konfiguriert: Trage-Versatz Y.",
                    label = "Trage-Versatz Y",
                },
                treeCarryOffsetZ = {
                    description = "Konfiguriert: Trage-Versatz Z.",
                    label = "Trage-Versatz Z",
                },
                treeCarryProp = {
                    description = "Konfiguriert: Getragenes Prop-Modell.",
                    label = "Getragenes Prop-Modell",
                },
                treeCarryPropBone = {
                    description = "Konfiguriert: Trage-Bone.",
                    label = "Trage-Bone",
                },
                treeDispatchEnabled = {
                    description = "Konfiguriert: Baum-Dispatch senden.",
                    label = "Baum-Dispatch senden",
                },
                treeDispatchJobs = {
                    description = "Konfiguriert: Dispatch-Zieljobs.",
                    itemLabel = "Beruf",
                    label = "Dispatch-Zieljobs",
                },
                treeDropCleanupRadius = {
                    description = "Abgelegte Holzstücke werden entfernt, wenn sich kein Spieler mehr in diesem Bereich befindet.",
                    label = "Cleanup-Reichweite",
                },
                treeDropMarkerA = {
                    description = "Konfiguriert: Marker-Transparenz.",
                    label = "Marker-Transparenz",
                },
                treeDropMarkerB = {
                    description = "Konfiguriert: Marker Blau.",
                    label = "Marker Blau",
                },
                treeDropMarkerG = {
                    description = "Konfiguriert: Marker Grün.",
                    label = "Marker Grün",
                },
                treeDropMarkerHeight = {
                    description = "Konfiguriert: Marker-Höhe.",
                    label = "Marker-Höhe",
                },
                treeDropMarkerR = {
                    description = "Konfiguriert: Marker Rot.",
                    label = "Marker Rot",
                },
                treeDropMarkerType = {
                    description = "Konfiguriert: Marker-Typ.",
                    label = "Marker-Typ",
                },
                treeDropOffsetX = {
                    description = "Lokaler seitlicher Versatz vom umgestürzten Baum.",
                    label = "Ablage-Versatz X",
                },
                treeDropOffsetY = {
                    description = "Lokaler Versatz entlang der Baumrichtung.",
                    label = "Ablage-Versatz Y",
                },
                treeDropOffsetZ = {
                    description = "Vertikaler Versatz der Ablage.",
                    label = "Ablage-Versatz Z",
                },
                treeDropRadius = {
                    description = "Konfiguriert: Ablageradius.",
                    label = "Ablageradius",
                },
                treeEnabled = {
                    description = "Konfiguriert: Umgestürzte-Baum-Einsätze aktivieren.",
                    label = "Umgestürzte-Baum-Einsätze aktivieren",
                },
                treeInteractionDistance = {
                    description = "Konfiguriert: Interaktionsdistanz.",
                    label = "Interaktionsdistanz",
                },
                treeInteractionOffsetX = {
                    description = "Lokaler seitlicher Versatz vom Baummodell.",
                    label = "Sägepunkt-Versatz X",
                },
                treeInteractionOffsetY = {
                    description = "Lokaler Längsversatz vom Baummodell.",
                    label = "Sägepunkt-Versatz Y",
                },
                treeInteractionOffsetZ = {
                    description = "Vertikaler Versatz vom Baummodell.",
                    label = "Sägepunkt-Versatz Z",
                },
                treeMarkerA = {
                    description = "Konfiguriert: Marker-Transparenz.",
                    label = "Marker-Transparenz",
                },
                treeMarkerB = {
                    description = "Konfiguriert: Marker Blau.",
                    label = "Marker Blau",
                },
                treeMarkerG = {
                    description = "Konfiguriert: Marker Grün.",
                    label = "Marker Grün",
                },
                treeMarkerHeight = {
                    description = "Konfiguriert: Marker-Höhe.",
                    label = "Marker-Höhe",
                },
                treeMarkerR = {
                    description = "Konfiguriert: Marker Rot.",
                    label = "Marker Rot",
                },
                treeMarkerSize = {
                    description = "Konfiguriert: Marker-Größe.",
                    label = "Marker-Größe",
                },
                treeMarkerType = {
                    description = "Konfiguriert: Marker-Typ.",
                    label = "Marker-Typ",
                },
                treePickupDistance = {
                    description = "Konfiguriert: Aufhebedistanz.",
                    label = "Aufhebedistanz",
                },
                treePieceCount = {
                    description = "Konfiguriert: Anzahl Holzstücke.",
                    label = "Anzahl Holzstücke",
                },
                treePieceModel = {
                    description = "Konfiguriert: Holzstück-Modell.",
                    label = "Holzstück-Modell",
                },
                treePieceSpacing = {
                    description = "Konfiguriert: Abstand der Holzstücke.",
                    label = "Abstand der Holzstücke",
                },
                treePropModel = {
                    description = "Objektmodell, das für den umgestürzten Baum gespawnt wird.",
                    label = "Baummodell",
                },
                treeRequireOnDuty = {
                    description = "Konfiguriert: Dienst erforderlich.",
                    label = "Dienst erforderlich",
                },
                treeSawAnimDict = {
                    description = "Konfiguriert: Animationsverzeichnis.",
                    label = "Animationsverzeichnis",
                },
                treeSawAnimFlag = {
                    description = "Konfiguriert: Animations-Flag.",
                    label = "Animations-Flag",
                },
                treeSawAnimName = {
                    description = "Konfiguriert: Animationsname.",
                    label = "Animationsname",
                },
                treeSawCollision = {
                    description = "Konfiguriert: Prop-Kollision aktivieren.",
                    label = "Prop-Kollision aktivieren",
                },
                treeSawIsPed = {
                    description = "Konfiguriert: Am Ped befestigen.",
                    label = "Am Ped befestigen",
                },
                treeSawOffsetRx = {
                    description = "Konfiguriert: Kettensägen-Rotation X.",
                    label = "Kettensägen-Rotation X",
                },
                treeSawOffsetRy = {
                    description = "Konfiguriert: Kettensägen-Rotation Y.",
                    label = "Kettensägen-Rotation Y",
                },
                treeSawOffsetRz = {
                    description = "Konfiguriert: Kettensägen-Rotation Z.",
                    label = "Kettensägen-Rotation Z",
                },
                treeSawOffsetX = {
                    description = "Konfiguriert: Kettensägen-Versatz X.",
                    label = "Kettensägen-Versatz X",
                },
                treeSawOffsetY = {
                    description = "Konfiguriert: Kettensägen-Versatz Y.",
                    label = "Kettensägen-Versatz Y",
                },
                treeSawOffsetZ = {
                    description = "Konfiguriert: Kettensägen-Versatz Z.",
                    label = "Kettensägen-Versatz Z",
                },
                treeSawProp = {
                    description = "Konfiguriert: Kettensägen-Prop.",
                    label = "Kettensägen-Prop",
                },
                treeSawPropBone = {
                    description = "Konfiguriert: Kettensägen-Bone.",
                    label = "Kettensägen-Bone",
                },
                treeSawRotationOrder = {
                    description = "Konfiguriert: Rotationsreihenfolge.",
                    label = "Rotationsreihenfolge",
                },
                treeSawSections = {
                    description = "Konfiguriert: Benötigte Sägeabschnitte.",
                    label = "Benötigte Sägeabschnitte",
                },
                treeSawSoftPinning = {
                    description = "Konfiguriert: Soft Pinning verwenden.",
                    label = "Soft Pinning verwenden",
                },
                treeSawSyncRotation = {
                    description = "Konfiguriert: Rotation synchronisieren.",
                    label = "Rotation synchronisieren",
                },
                treeSpawnRange = {
                    description = "Der synchronisierte Baum erscheint, sobald ein Spieler diesen Bereich betritt.",
                    label = "Spawn-Reichweite",
                },
                vehicleFiresBurnDamageBreakWindows = {
                    description = "Konfiguriert: Scheiben bei Vollbrand zerstören.",
                    label = "Scheiben bei Vollbrand zerstören",
                },
                vehicleFiresBurnDamageBurstTyres = {
                    description = "Konfiguriert: Reifen bei Vollbrand platzen lassen.",
                    label = "Reifen bei Vollbrand platzen lassen",
                },
                vehicleFiresBurnDamageDeformation = {
                    description = "Konfiguriert: Stärke der optischen Verformung.",
                    label = "Stärke der optischen Verformung",
                },
                vehicleFiresBurnDamageEnabled = {
                    description = "Beschädigt und verformt das brennende Fahrzeug schrittweise vor der verzögerten Explosion.",
                    label = "Fahrzeug während Brand beschädigen",
                },
                vehicleFiresBurnDamageFullBodyHealth = {
                    description = "Konfiguriert: Karosseriegesundheit bei Vollbrand.",
                    label = "Karosseriegesundheit bei Vollbrand",
                },
                vehicleFiresBurnDamageIntervalSeconds = {
                    description = "Sekunden zwischen weiteren Schadensticks in der Vollbrand-Phase.",
                    label = "Vollbrand-Schadensintervall",
                },
                vehicleFiresBurnDamageMinimumBodyHealth = {
                    description = "Konfiguriert: Minimale Karosseriegesundheit vor Explosion.",
                    label = "Minimale Karosseriegesundheit vor Explosion",
                },
                vehicleFiresBurnDamagePerTick = {
                    description = "Konfiguriert: Karosserieschaden pro Intervall.",
                    label = "Karosserieschaden pro Intervall",
                },
                vehicleFiresBurnDamageSmallBodyHealth = {
                    description = "Konfiguriert: Karosseriegesundheit bei Kleinbrand.",
                    label = "Karosseriegesundheit bei Kleinbrand",
                },
                vehicleFiresCanExtinguishFoam = {
                    description = "Erlaubt Schaum aus Schlauch oder Fahrzeugversorgung zum Löschen dieses Fahrzeugbrand-Materials.",
                    label = "Mit Schaum löschbar",
                },
                vehicleFiresCanExtinguishWater = {
                    description = "Erlaubt Schlauchwasser, Fahrzeug-Wasserkanonen und Hubschrauber-Löschwasserbehälter zum Löschen dieses Fahrzeugbrand-Materials.",
                    label = "Mit Wasser löschbar",
                },
                vehicleFiresCanExtinguishWaterMonitor = {
                    description = "Erlaubt dem tragbaren Wasserwerfer, dieses Fahrzeugbrand-Material zu löschen.",
                    label = "Mit Wasserwerfer löschbar",
                },
                vehicleFiresDuplicateDistance = {
                    description = "Verhindert, dass ein weiterer Fahrzeugbrand zu nah an einem bestehenden erstellt wird.",
                    label = "Duplikat-Distanz",
                },
                vehicleFiresEnabled = {
                    description = "Aktiviert das Fahrzeugbrand-System.",
                    label = "Aktiviert",
                },
                vehicleFiresEngineHealth = {
                    description = "Bleibt bei 300 oder höher, um Gtas nativen Fahrzeugbrand und eine frühe Explosion zu verhindern.",
                    label = "Motorzustand während Brand",
                },
                vehicleFiresEngineOff = {
                    description = "Konfiguriert: Motor ausschalten.",
                    label = "Motor ausschalten",
                },
                vehicleFiresExplosionCameraShake = {
                    description = "Konfiguriert: Kamerärschütterung.",
                    label = "Kamerärschütterung",
                },
                vehicleFiresExplosionDamageScale = {
                    description = "Konfiguriert: Explosions-Schadensskalierung.",
                    label = "Explosions-Schadensskalierung",
                },
                vehicleFiresExplosionDelaySeconds = {
                    description = "Sekunden, bis ein brennendes Fahrzeug explodiert.",
                    label = "Explosionsverzögerung Sekunden",
                },
                vehicleFiresExplosionEnabled = {
                    description = "Fahrzeuge explodieren nicht sofort; dies steuert die optionale verzögerte Explosion.",
                    label = "Verzögerte Explosion aktivieren",
                },
                vehicleFiresExplosionPostBurnSeconds = {
                    description = "Sekunden, die das zerstörte Fahrzeug nach der Explosion weiter brennt.",
                    label = "Branddauer nach Explosion",
                },
                vehicleFiresExplosionRemoveFire = {
                    description = "Entfernt das Feuer nach der konfigurierten Nachbranddauer. Deaktivieren für ein unbegrenztes Wrackfeuer.",
                    label = "Feuer nach Nachbrand entfernen",
                },
                vehicleFiresExplosionType = {
                    description = "Konfiguriert: Explosionsart.",
                    label = "Explosionsart",
                },
                vehicleFiresExternalAllowedResources = {
                    description = "Ressourcen, die über den externen Hook Fahrzeugbrände erstellen dürfen.",
                    itemLabel = "Ressource",
                    label = "Erlaubte Ressourcen",
                },
                vehicleFiresExternalEnabled = {
                    description = "Erlaubt mechanicjob oder freigegebenen Skripten, Firejob-Fahrzeugbrände zu erstellen.",
                    label = "Externe Erstellung aktivieren",
                },
                vehicleFiresExternalMaxSourceDistance = {
                    description = "Maximale Distanz zwischen externen Trigger-Koordinaten und dem Fahrzeug.",
                    label = "Maximale Quell-Distanz",
                },
                vehicleFiresFireType = {
                    description = "Typ der Brandquelle, der beim Erstellen eines Fahrzeugbrands genutzt wird.",
                    label = "Brandtyp",
                },
                vehicleFiresFoamEffectiveness = {
                    description = "Höhere Werte lassen Schaum Fahrzeugbrände schneller löschen.",
                    label = "Schaum-Wirksamkeit",
                },
                vehicleFiresKeepUndriveable = {
                    description = "Konfiguriert: Fahrzeug unfahrbar halten.",
                    label = "Fahrzeug unfahrbar halten",
                },
                vehicleFiresManualConsumeItem = {
                    description = "Konfiguriert: Feuerzeug-Item verbrauchen.",
                    label = "Feuerzeug-Item verbrauchen",
                },
                vehicleFiresManualEnabled = {
                    description = "Erlaubt Spielern, nahe Fahrzeuge manuell anzuzünden.",
                    label = "Manuelle Zündung",
                },
                vehicleFiresManualItem = {
                    description = "Inventar-Item, das für das manuelle Entzünden benötigt wird.",
                    label = "Zünd-Item",
                },
                vehicleFiresManualMaxDistance = {
                    description = "Konfiguriert: Maximale Zünddistanz.",
                    label = "Maximale Zünddistanz",
                },
                vehicleFiresManualSourceScale = {
                    description = "Konfiguriert: Brandskalierung manuelle Zündung.",
                    label = "Brandskalierung manuelle Zündung",
                },
                vehicleFiresMaterial = {
                    description = "Materialprofil für das Kraftstoffverhalten des Fahrzeugs.",
                    label = "Brandmaterial",
                },
                vehicleFiresMaxActive = {
                    description = "Konfiguriert: Maximal aktive Fahrzeugbrände.",
                    label = "Maximal aktive Fahrzeugbrände",
                },
                vehicleFiresPetrolTankHealth = {
                    description = "Bleibt bei 1000, damit nur die konfigurierte Firejob-Explosion das Fahrzeug zerstören kann.",
                    label = "Tankzustand während Brand",
                },
                vehicleFiresProgressionEnabled = {
                    description = "Fahrzeugbrände starten mit Rauch, wachsen zu einem Kleinbrand und erreichen dann die volle Intensität.",
                    label = "Stufenweisen Fahrzeugbrand aktivieren",
                },
                vehicleFiresProgressionExplosionAfterFullFire = {
                    description = "Addiert Rauch- und Kleinbranddauer, bevor die konfigurierte Explosionsverzögerung startet.",
                    label = "Explosionstimer nach Vollbrand",
                },
                vehicleFiresProgressionFullIntensity = {
                    description = "Konfiguriert: Vollbrand-Intensität.",
                    label = "Vollbrand-Intensität",
                },
                vehicleFiresProgressionFullSize = {
                    description = "Konfiguriert: Vollbrand-Größe.",
                    label = "Vollbrand-Größe",
                },
                vehicleFiresProgressionFullSmokeDensity = {
                    description = "Konfiguriert: Vollbrand-Rauchdichte.",
                    label = "Vollbrand-Rauchdichte",
                },
                vehicleFiresProgressionSmallDurationSeconds = {
                    description = "Konfiguriert: Kleinbrand-Dauer Sekunden.",
                    label = "Kleinbrand-Dauer Sekunden",
                },
                vehicleFiresProgressionSmallIntensity = {
                    description = "Konfiguriert: Kleinbrand-Intensität.",
                    label = "Kleinbrand-Intensität",
                },
                vehicleFiresProgressionSmallSize = {
                    description = "Konfiguriert: Kleinbrand-Größe.",
                    label = "Kleinbrand-Größe",
                },
                vehicleFiresProgressionSmallSmokeDensity = {
                    description = "Konfiguriert: Kleinbrand-Rauchdichte.",
                    label = "Kleinbrand-Rauchdichte",
                },
                vehicleFiresProgressionSmallSourceScale = {
                    description = "Konfiguriert: Kleinbrand-Skalierung.",
                    label = "Kleinbrand-Skalierung",
                },
                vehicleFiresProgressionSmokeDensity = {
                    description = "Konfiguriert: Rauchstufen-Dichte.",
                    label = "Rauchstufen-Dichte",
                },
                vehicleFiresProgressionSmokeDurationSeconds = {
                    description = "Konfiguriert: Rauchdauer Sekunden.",
                    label = "Rauchdauer Sekunden",
                },
                vehicleFiresProgressionSmokeIntensity = {
                    description = "Konfiguriert: Rauchstufen-Intensität.",
                    label = "Rauchstufen-Intensität",
                },
                vehicleFiresProgressionSmokeSize = {
                    description = "Konfiguriert: Rauchstufen-Größe.",
                    label = "Rauchstufen-Größe",
                },
                vehicleFiresProgressionSmokeSourceScale = {
                    description = "Sehr niedrig halten, wenn hauptsächlich Rauch mit kaum sichtbaren Flammen gewünscht ist.",
                    label = "Rauchstufen-Flammenskalierung",
                },
                vehicleFiresServerCooldownSeconds = {
                    description = "Globaler Cooldown für manuelle Feuerzeug-Zündung.",
                    label = "Serverweiter Zünd-Cooldown",
                },
                vehicleFiresSourceScale = {
                    description = "Konfiguriert: Standard-Brandskalierung.",
                    label = "Standard-Brandskalierung",
                },
                vehicleFiresStandaloneAllowNpcVehicles = {
                    description = "Konfiguriert: NPC-Fahrzeuge erlauben.",
                    label = "NPC-Fahrzeuge erlauben",
                },
                vehicleFiresStandaloneChance = {
                    description = "Konfiguriert: Unfall-Brandchance.",
                    label = "Unfall-Brandchance",
                },
                vehicleFiresStandaloneCooldownSeconds = {
                    description = "Konfiguriert: Unfall-Cooldown Sekunden.",
                    label = "Unfall-Cooldown Sekunden",
                },
                vehicleFiresStandaloneEnabled = {
                    description = "Lässt Firejob bei schweren Unfällen Fahrzeugbrände erzeugen, ohne Mechanicjob zu benötigen.",
                    label = "Eigenständige Unfälle aktivieren",
                },
                vehicleFiresStandaloneForwardMotionRatio = {
                    description = "Konfiguriert: Vorwärtsbewegungs-Verhältnis.",
                    label = "Vorwärtsbewegungs-Verhältnis",
                },
                vehicleFiresStandaloneIgnoreElectric = {
                    description = "Konfiguriert: Elektrofahrzeuge ignorieren.",
                    label = "Elektrofahrzeuge ignorieren",
                },
                vehicleFiresStandaloneMechanicResources = {
                    description = "Ressourcen, die die Fallback-Unfallerkennung deaktivieren, während sie laufen.",
                    itemLabel = "Ressource",
                    label = "Mechanic-Ressourcen",
                },
                vehicleFiresStandaloneMinBodyHealthLoss = {
                    description = "Konfiguriert: Minimaler Karosserieschaden.",
                    label = "Minimaler Karosserieschaden",
                },
                vehicleFiresStandaloneMinEngineHealthLoss = {
                    description = "Konfiguriert: Minimaler Motorschaden.",
                    label = "Minimaler Motorschaden",
                },
                vehicleFiresStandaloneMinImpactSpeedKmh = {
                    description = "Konfiguriert: Minimale Aufprallgeschwindigkeit.",
                    label = "Minimale Aufprallgeschwindigkeit",
                },
                vehicleFiresStandaloneMinSpeedDropKmh = {
                    description = "Konfiguriert: Minimaler Geschwindigkeitsverlust.",
                    label = "Minimaler Geschwindigkeitsverlust",
                },
                vehicleFiresStandaloneMode = {
                    description = "Fallback läuft nur, wenn konfigurierte Mechanic-Ressourcen nicht aktiv sind. Immer kann parallel zu Mechanicjob laufen. Deaktiviert behält nur manuelle, externe oder Mechanic-Trigger.",
                    label = "Eigenständiger Modus",
                    options = {
                        always = "Immer",
                        disabled = "Deaktiviert",
                        fallback = "Rückfall",
                    },
                },
                vehicleFiresStandaloneRequireDriver = {
                    description = "Konfiguriert: Spielerfahrer erforderlich.",
                    label = "Spielerfahrer erforderlich",
                },
                vehicleFiresStandaloneServerMaxDistance = {
                    description = "Maximal erlaubte Spieler-Distanz zu den Unfallkoordinaten.",
                    label = "Server-Maximaldistanz",
                },
                vehicleFiresStandaloneSmokeDensity = {
                    description = "Konfiguriert: Unfall-Rauchdichte.",
                    label = "Unfall-Rauchdichte",
                },
                vehicleFiresStandaloneSourceScale = {
                    description = "Konfiguriert: Unfall-Brandskalierung.",
                    label = "Unfall-Brandskalierung",
                },
                vehicleFiresWaterEffectiveness = {
                    description = "Nutze 0, damit Wasser Fahrzeug-Kraftstoffbrände nicht löscht.",
                    label = "Wasser-Wirksamkeit",
                },
                vehicleFiresWaterReactionChance = {
                    description = "Konfiguriert: Reaktionschance.",
                    label = "Reaktionschance",
                },
                vehicleFiresWaterReactionEnabled = {
                    description = "Erlaubt, dass Wasser auf Fahrzeug-Kraftstoffbrände je nach Werten unten Feuer verbreitet, Rauch erzeugt oder Explosionen auslöst.",
                    label = "Wasser verschlimmert es",
                },
                vehicleFiresWaterReactionExplosionChance = {
                    description = "Konfiguriert: Explosions-Reaktionschance.",
                    label = "Explosions-Reaktionschance",
                },
                vehicleFiresWaterReactionInterval = {
                    description = "Konfiguriert: Reaktionsintervall ms.",
                    label = "Reaktionsintervall ms",
                },
                vehicleFiresWaterReactionSmokeIncrease = {
                    description = "Konfiguriert: Rauchzunahme.",
                    label = "Rauchzunahme",
                },
                vehicleFiresWaterReactionSpreadCount = {
                    description = "Konfiguriert: Verbreitungsanzahl.",
                    label = "Verbreitungsanzahl",
                },
                vehicleRescueAllowMissionCreatorVehicles = {
                    description = "Erlaubt, dass durch den Feuer-Missionseditor platzierte Fahrzeuge zu Rettungszielen werden.",
                    label = "Missionseditor-Fahrzeuge",
                },
                vehicleRescueAllowStateBag = {
                    description = "Externe Skripte können Fahrzeuge mit Entity(vehicle).state[configuredKey] = true markieren.",
                    label = "State-Bag-Marker erlauben",
                },
                vehicleRescueAllowWorldVehicles = {
                    description = "Erlaubt, dass normale beschädigte Fahrzeuge in der Welt zu Rettungszielen werden.",
                    label = "Weltfahrzeuge",
                },
                vehicleRescueBreakDoorOnComplete = {
                    description = "Konfiguriert: GTA-Tür bei Erfolg zerbrechen.",
                    label = "GTA-Tür bei Erfolg zerbrechen",
                },
                vehicleRescueBreakWindowOnComplete = {
                    description = "Konfiguriert: GTA-Scheibe bei Erfolg zerbrechen.",
                    label = "GTA-Scheibe bei Erfolg zerbrechen",
                },
                vehicleRescueDoorLabel = {
                    description = "Interaktionsbezeichnung für das Aufspreizen einer Fahrzeugtür.",
                    label = "Tür-Interaktionsbezeichnung",
                },
                vehicleRescueDoorWheelLabel = {
                    description = "Nutze %s als Platzhalter für die erkannte Türseite.",
                    label = "Tür-Radialbezeichnung",
                },
                vehicleRescueEnabled = {
                    description = "Aktiviert technische Rettungsinteraktionen an Fahrzeugen.",
                    label = "Aktiviert",
                },
                vehicleRescueGlassDurationMs = {
                    description = "Konfiguriert: Dauer ms.",
                    label = "Dauer ms",
                },
                vehicleRescueGlassGoodZone = {
                    description = "Konfiguriert: Guter Bereich.",
                    label = "Guter Bereich",
                },
                vehicleRescueGlassHammerItem = {
                    description = "Inventar-Item, das zum Einschlagen von Fahrzeugscheiben benötigt wird.",
                    label = "Glashammer-Item",
                },
                vehicleRescueGlassHammerProp = {
                    description = "Konfiguriert: Glashammer-Objekt.",
                    label = "Glashammer-Objekt",
                },
                vehicleRescueGlassHitPoints = {
                    description = "Konfiguriert: Schwachpunkte.",
                    label = "Schwachpunkte",
                },
                vehicleRescueGlassLabel = {
                    description = "Interaktionsbezeichnung für das Einschlagen einer Fahrzeugscheibe.",
                    label = "Scheiben-Interaktionsbezeichnung",
                },
                vehicleRescueGlassMaxMisses = {
                    description = "Konfiguriert: Erlaubte Fehlversuche.",
                    label = "Erlaubte Fehlversuche",
                },
                vehicleRescueGlassMinigameEnabled = {
                    description = "Konfiguriert: Glas-Minispiel aktivieren.",
                    label = "Glas-Minispiel aktivieren",
                },
                vehicleRescueGlassMistakePenalty = {
                    description = "Konfiguriert: Fehler-Strafpunkte.",
                    label = "Fehler-Strafpunkte",
                },
                vehicleRescueGlassPerfectZone = {
                    description = "Konfiguriert: Perfekter Bereich.",
                    label = "Perfekter Bereich",
                },
                vehicleRescueGlassRequiredHits = {
                    description = "Konfiguriert: Nötige Treffer.",
                    label = "Nötige Treffer",
                },
                vehicleRescueGlassWheelLabel = {
                    description = "Nutze %s als Platzhalter für die erkannte Türseite.",
                    label = "Scheiben-Radialbezeichnung",
                },
                vehicleRescueInteractionDistance = {
                    description = "Konfiguriert: Interaktionsdistanz.",
                    label = "Interaktionsdistanz",
                },
                vehicleRescueMaxScanDistance = {
                    description = "Konfiguriert: Fahrzeug-Scandistanz.",
                    label = "Fahrzeug-Scandistanz",
                },
                vehicleRescuePatientAccessibleAfterAnyDoor = {
                    description = "Setzt den Rettungsstatus auf erreichbar, sobald irgendeine Tür entfernt wurde.",
                    label = "Patient nach einer Tür erreichbar",
                },
                vehicleRescuePlayerEntrapmentEnabled = {
                    description = "Klemmt Spieler in stark beschädigten Fahrzeugen ein, bis ein Rettungszugang geschaffen wurde.",
                    label = "Spieler-Einklemmung",
                },
                vehicleRescueRequireMatchingGlassForDoor = {
                    description = "Der Türpunkt erscheint erst, wenn die Scheibe auf derselben Seite entfernt wurde.",
                    label = "Tür erfordert passende Scheibe",
                },
                vehicleRescueRequireOnDuty = {
                    description = "Nur Feuerwehrleute im Dienst können Scheiben zerstören und Türen aufbrechen.",
                    label = "Dienst erforderlich",
                },
                vehicleRescueSpreaderDecayPerTick = {
                    description = "Konfiguriert: Abbau pro Tick.",
                    label = "Abbau pro Tick",
                },
                vehicleRescueSpreaderDurationMs = {
                    description = "Konfiguriert: Dauer ms.",
                    label = "Dauer ms",
                },
                vehicleRescueSpreaderItem = {
                    description = "Inventar-Item, das zum Öffnen von Fahrzeugtüren benötigt wird.",
                    label = "Spreizer-Item",
                },
                vehicleRescueSpreaderMaxPumpPower = {
                    description = "Konfiguriert: Gute Pumpkraft Maximum.",
                    label = "Gute Pumpkraft Maximum",
                },
                vehicleRescueSpreaderMinPumpPower = {
                    description = "Konfiguriert: Gute Pumpkraft Minimum.",
                    label = "Gute Pumpkraft Minimum",
                },
                vehicleRescueSpreaderMinigameEnabled = {
                    description = "Konfiguriert: Spreizer-Minispiel aktivieren.",
                    label = "Spreizer-Minispiel aktivieren",
                },
                vehicleRescueSpreaderOverPressurePenalty = {
                    description = "Konfiguriert: Überdruck-Strafe.",
                    label = "Überdruck-Strafe",
                },
                vehicleRescueSpreaderPressureGain = {
                    description = "Konfiguriert: Druckgewinn.",
                    label = "Druckgewinn",
                },
                vehicleRescueSpreaderPressureLoss = {
                    description = "Konfiguriert: Druckverlust.",
                    label = "Druckverlust",
                },
                vehicleRescueSpreaderProgressPerTick = {
                    description = "Konfiguriert: Fortschritt pro Tick.",
                    label = "Fortschritt pro Tick",
                },
                vehicleRescueSpreaderProp = {
                    description = "Konfiguriert: Spreizer-Objekt.",
                    label = "Spreizer-Objekt",
                },
                vehicleRescueSpreaderPumpsRequired = {
                    description = "Die Tür wird nach ungefähr 3 bis 5 guten Spreizer-Pumpen entfernt.",
                    label = "Nötige Pumpzyklen",
                },
                vehicleRescueSpreaderRequiredProgress = {
                    description = "Konfiguriert: Nötiger Fortschritt.",
                    label = "Nötiger Fortschritt",
                },
                vehicleRescueSpreaderSweetSpotMax = {
                    description = "Konfiguriert: Druck-Sweetspot Maximum.",
                    label = "Druck-Sweetspot Maximum",
                },
                vehicleRescueSpreaderSweetSpotMin = {
                    description = "Konfiguriert: Druck-Sweetspot Minimum.",
                    label = "Druck-Sweetspot Minimum",
                },
                vehicleRescueStateBagKey = {
                    description = "Konfiguriert: State-Bag-Key.",
                    label = "State-Bag-Key",
                },
                vehicleRescueWorldBodyHealthThreshold = {
                    description = "Konfiguriert: Karosserie-Schwelle.",
                    label = "Karosserie-Schwelle",
                },
                vehicleRescueWorldEngineHealthThreshold = {
                    description = "Konfiguriert: Motor-Schwelle.",
                    label = "Motor-Schwelle",
                },
                vehicleRescueWorldRequiresDamage = {
                    description = "Wenn aktiv, müssen normale Weltfahrzeuge unter die konfigurierten Schwellen beschädigt sein.",
                    label = "Weltfahrzeuge brauchen Schaden",
                },
                waterMonitorAllowedJobs = {
                    description = "Leer lassen, um alle in diesem Firejob konfigurierten Jobs zu erlauben.",
                    itemLabel = "Beruf",
                    label = "Erlaubte Jobs",
                },
                waterMonitorCommand = {
                    description = "Befehlsname ohne Schrägstrich, zum Beispiel watermonitor.",
                    label = "Befehl",
                },
                waterMonitorCommandEnabled = {
                    description = "Erlaubt das Platzieren des Wasserwerfers ohne Item über den Befehl.",
                    label = "Befehlsnutzung aktivieren",
                },
                waterMonitorConsumeItem = {
                    description = "Entfernt nach erfolgreicher Platzierung ein konfiguriertes Item.",
                    label = "Item beim Platzieren verbrauchen",
                },
                waterMonitorEnabled = {
                    description = "Aktiviert die Platzierung und Bedienung des tragbaren Wasserwerfers.",
                    label = "Wasserwerfer aktivieren",
                },
                waterMonitorEnterAnimDict = {
                    description = "Animationsverzeichnis, das beim Start der Wasserwerfer-Bedienung geladen wird.",
                    label = "Animationsverzeichnis",
                },
                waterMonitorEnterAnimDurationMs = {
                    description = "Dauer der Einstiegsanimation in Millisekunden; -1 deaktiviert das Zeitlimit.",
                    label = "Dauer ms",
                },
                waterMonitorEnterAnimName = {
                    description = "Animationsclip beim Einnehmen der Bedienposition.",
                    label = "Animationsname",
                },
                waterMonitorExitAnimDict = {
                    description = "Animationsverzeichnis, das beim Beenden der Wasserwerfer-Bedienung geladen wird.",
                    label = "Animationsverzeichnis",
                },
                waterMonitorExitAnimDurationMs = {
                    description = "Dauer der Ausstiegsanimation in Millisekunden; -1 deaktiviert das Zeitlimit.",
                    label = "Dauer ms",
                },
                waterMonitorExitAnimName = {
                    description = "Animationsclip beim Verlassen der Bedienposition.",
                    label = "Animationsname",
                },
                waterMonitorIdleAnimDict = {
                    description = "Animationsverzeichnis während der Bedienung des Wasserwerfers.",
                    label = "Animationsverzeichnis",
                },
                waterMonitorIdleAnimDurationMs = {
                    description = "Dauer der Bedienanimation in Millisekunden; -1 lässt sie dauerhaft aktiv.",
                    label = "Dauer ms",
                },
                waterMonitorIdleAnimName = {
                    description = "Wiederholter Animationsclip während der Wasserwerfer-Bedienung.",
                    label = "Animationsname",
                },
                waterMonitorInteractionDistance = {
                    description = "Maximale Entfernung, aus der der Wasserwerfer bedient werden kann.",
                    label = "Interaktionsdistanz",
                },
                waterMonitorItem = {
                    description = "Inventar-Item zum Platzieren des Wasserwerfers.",
                    label = "Itemname",
                },
                waterMonitorItemEnabled = {
                    description = "Erlaubt das Platzieren des Wasserwerfers mit dem konfigurierten Inventar-Item.",
                    label = "Itemnutzung aktivieren",
                },
                waterMonitorLabel = {
                    description = "Name, der bei Interaktionen und Benachrichtigungen angezeigt wird.",
                    label = "Anzeigename",
                },
                waterMonitorModel = {
                    description = "Propmodell, das für den Wasserwerfer erzeugt wird.",
                    label = "Propmodell",
                },
                waterMonitorPickupDistance = {
                    description = "Maximale Entfernung, aus der ein platzierter Wasserwerfer aufgenommen werden kann.",
                    label = "Aufnahmedistanz",
                },
                waterMonitorRequireOnDuty = {
                    description = "Erlaubt die Nutzung nur Mitgliedern eines erlaubten Jobs, die im Dienst sind.",
                    label = "Dienst erforderlich",
                },
                waterMonitorReturnItemOnRemove = {
                    description = "Gibt beim Aufnehmen des Wasserwerfers ein konfiguriertes Item zurück.",
                    label = "Item beim Aufnehmen zurückgeben",
                },
                waterMonitorStreamDistance = {
                    description = "Maximale Entfernung, in der platzierte Wasserwerfer synchronisiert und dargestellt werden.",
                    label = "Streaming-Distanz",
                },
                waterMonitorStreamHitRadius = {
                    description = "Radius um die Wasserflugbahn, in dem ein Feuer getroffen werden kann.",
                    label = "Trefferradius",
                },
                waterMonitorStreamMinRange = {
                    description = "Minimale Strahlentfernung beim Zielen mit dem Wasserwerfer.",
                    label = "Mindestreichweite",
                },
                waterMonitorStreamProgressPerSecond = {
                    description = "Grundstärke beim Löschen von Feuern, die vom Wasserstrahl getroffen werden.",
                    label = "Löschfortschritt pro Sekunde",
                },
                waterMonitorStreamRange = {
                    description = "Maximale Flugdistanz des Wasserstrahls in Metern.",
                    label = "Reichweite",
                },
                waterMonitorStreamTrajectorySegments = {
                    description = "Anzahl der Segmente zur Berechnung der gekrümmten Wasserflugbahn.",
                    label = "Flugbahnsegmente",
                },
                waterMonitorStreamWaterGravityScale = {
                    description = "Bestimmt, wie stark die Schwerkraft die Wasserflugbahn nach unten biegt.",
                    label = "Schwerkraftskalierung",
                },
                waterMonitorStreamWaterLitersPerSecond = {
                    description = "Wasserverbrauch aus der angeschlossenen Versorgung während des Sprühens.",
                    label = "Wasserliter pro Sekunde",
                },
                waterMonitorStreamWaterVelocity = {
                    description = "Anfangsgeschwindigkeit zur Berechnung der Wasserflugbahn.",
                    label = "Wassergeschwindigkeit",
                },
                waterMonitorZOffset = {
                    description = "Vertikale Korrektur beim Platzieren des Props auf dem Boden.",
                    label = "Bodenversatz Z",
                },
                waterTankEnabled = {
                    description = "Konfiguriert: Wassertank.",
                    label = "Wassertank",
                },
                waterTankSize = {
                    description = "Konfiguriert: Wasser Liter.",
                    label = "Wasser Liter",
                },
                x = {
                    description = "Konfiguriert: X.",
                    label = "X",
                },
                y = {
                    description = "Konfiguriert: Y.",
                    label = "Y",
                },
                z = {
                    description = "Konfiguriert: Z.",
                    label = "Z",
                },
                zOffset = {
                    description = "Vertikaler Offset, damit der entstehende Brand sauber auf der gewählten Brandquelle sitzt.",
                    label = "Höhenanpassung der Brandquelle",
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
