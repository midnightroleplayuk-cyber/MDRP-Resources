JobConfigLocales["sky_policejob:de"] = {
    JobConfiguratorComingSoon = "Dieser Job-Konfigurator ist in Kürze verfügbar.",
    JobConfiguratorImportFailed = "Die config.lua-Werte für '%s' konnten nicht importiert werden: %s.",
    JobConfiguratorImportHistoryFailed = "Der Import war erfolgreich, aber der Historieneintrag konnte nicht gespeichert werden.",
    JobConfiguratorImportNoData = "Für '%s' sind keine config.lua-Importdaten registriert.",
    JobConfiguratorImportSuccess = "config.lua-Werte für '%s' importiert: %d Jobs, %d Settings-, %d Feature- und %d Interaktionsabweichungen angewendet.",
    JobConfiguratorNoPermission = "Sie haben keine Berechtigung, diesen Befehl zu verwenden.",
    JobConfiguratorTitle = "Job-Konfigurator",
    JobConfiguratorUnknown = "Unbekannter Job-Konfigurator.",
    Nui = {
        workshopConfig = {
            configs = {
                sky_policejob = {
                    subtitle = "Konfigurieren Sie Polizeidienststellen, Shops, Props, Fahrzeuge, Stationen und die zentralen Funktionseinstellungen.",
                    title = "Polizeijobs",
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
                radioButton = "Taste",
                radioButtonAction = "Tastenaktion",
                radioButtonStatus = "FMS-Status",
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
                dispatchRadioButtons = "Legt die zentral vorgegebene Aktion jeder physischen Funktionstaste fest.",
                dispatchRadioFmsKeys = "Ordnet den physischen Zifferntasten FMS-Status zu. Das Tastenfeld führt nur FMS-Wechsel aus.",
            },
            extensions = {
                caseNumbering = {
                    label = "Aktennummern",
                    description = "Automatische Aktennummern für diesen Job konfigurieren.",
                    fields = {
                        prefix = {
                            label = "Aktenkürzel",
                            description = "Kürzel für neue Akten, z. B. LSPD oder LSCSD. Bis zu 16 Zeichen, automatisch in Großbuchstaben; leer verwendet CASE. Bestehende und manuell vergebene Nummern bleiben erhalten.",
                        },
                    },
                },
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
                dispatchRadioButtons = "Funkgerät-Funktionstasten",
                dispatchRadioFmsKeys = "FMS-Tastenbelegung",
            },
            features = {
                billing = {
                    description = "Aktiviert die Abrechnungsabläufe der Polizei.",
                    label = "Abrechnung",
                },
                devices = {
                    description = "Aktiviert einsetzbare Überwachungsgeräte.",
                    label = "CCTV und Blitzer",
                },
                evidence = {
                    description = "Aktiviert Beweislagerung, Spurensicherung im Feld und Scanner-Abläufe.",
                    label = "Beweise",
                },
                impound = {
                    description = "Aktiviert die Abläufe des Abschlepphofs.",
                    label = "Abschlepphof",
                },
                jail = {
                    description = "Aktiviert Gefängniszuweisungen und Häftlingsaktivitäten.",
                    label = "Gefängnis",
                },
                propPlacement = {
                    description = "Aktiviert konfigurierbare Polizei-Props und Fahrzeug-Prop-Ausstattungen.",
                    label = "Prop-Platzierung",
                },
                radial = {
                    description = "Aktiviert Polizei-Radialaktionen wie Abschleppen und Radkralle.",
                    label = "Radialaktionen",
                },
                restraints = {
                    description = "Aktiviert Handschellen, Zipties, Fußfesseln und Kopfsäcke.",
                    label = "Fesseln",
                },
                socialWork = {
                    description = "Aktiviert die Zuweisung von Sozialarbeit und deren Aufgaben.",
                    label = "Sozialarbeit",
                },
                tablet = {
                    description = "Aktiviert die von dieser Ressource konfigurierten Polizei-Tablet-Apps.",
                    label = "Polizei-Tablet",
                },
                tracking = {
                    description = "Aktiviert GPS-Tracker und elektronische Fußfesseln.",
                    label = "Ortung",
                },
                vehicleRadar = {
                    description = "Aktiviert das Radar für Streifenfahrzeuge.",
                    label = "Fahrzeug-Radar",
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
            settingFields = {
                gangMinimumGrade = "Mindestrang",
                gang = "Gang",
                component = "Komponente",
                description = "Beschreibung",
                fineAmount = "Bußgeldbetrag",
                itemName = "Gegenstandsname",
                length = "Länge",
                max = "Max.",
                maxOverKmh = "Max. Überschreitung",
                min = "Min.",
                minOverKmh = "Min. Überschreitung",
                model = "Prop-Modell",
                propModel = "Prop-Modell",
                reason = "Grund",
                vehicleClass = "Klasse",
            },
            settingGroups = {
                access = {
                    label = "Zugriff",
                },
                animation = {
                    label = "Animation",
                },
                ankleMonitor = {
                    label = "Elektronische Fußfessel",
                },
                ankleMonitorAccess = {
                    label = "Zugriff auf elektronische Fußfessel",
                },
                ankleMonitorPlacement = {
                    label = "Anlegen der elektronischen Fußfessel",
                },
                ankleMonitorZone = {
                    label = "Zone der elektronischen Fußfessel",
                },
                ankleMonitorZoneVisual = {
                    label = "Optik der Fußfesselzone",
                },
                assignment = {
                    label = "Zuweisung",
                },
                blip = {
                    label = "Stations-Blip",
                },
                carry = {
                    label = "Tragen",
                },
                cctv = {
                    label = "CCTV",
                },
                cctvDurability = {
                    label = "CCTV-Haltbarkeit",
                },
                cctvMotionDetection = {
                    label = "Bewegungserkennung",
                },
                cctvMotionDispatch = {
                    label = "Meldung bei Bewegungserkennung",
                },
                cctvMotionTiming = {
                    label = "Zeitverzögerung der Bewegungserkennung",
                },
                cctvPlacement = {
                    label = "CCTV-Platzierung",
                },
                cctvRepair = {
                    label = "CCTV-Reparatur",
                },
                cctvRepairAnimation = {
                    label = "CCTV-Reparaturanimation",
                },
                clamp = {
                    label = "Radkralle",
                },
                clampWeld = {
                    label = "Radkralle schweißen",
                },
                cleanup = {
                    label = "Bereinigung",
                },
                collection = {
                    label = "Sammlung",
                },
                controls = {
                    label = "Steuerung",
                },
                creator = {
                    label = "Ersteller",
                },
                crimeSceneTape = {
                    label = "Tatort-Absperrband",
                },
                crimeSceneTapeAccess = {
                    label = "Absperrband-Zugriff",
                },
                crimeSceneTapeInventory = {
                    label = "Absperrband-Inventar",
                },
                crimeSceneTapeLength = {
                    label = "Absperrband-Länge",
                },
                crimeSceneTapePlacement = {
                    label = "Absperrband-Platzierung",
                },
                database = {
                    label = "Datenbank",
                },
                delivery = {
                    label = "Zustellung",
                },
                detection = {
                    label = "Erkennung",
                },
                dispatch = {
                    label = "Leitstelle",
                },
                display = {
                    label = "Anzeige",
                },
                escape = {
                    label = "Entkommen",
                },
                escort = {
                    label = "Eskortieren",
                },
                evidenceStorage = {
                    label = "Beweislager",
                },
                fastLock = {
                    label = "Automatische Schnellsperre",
                },
                general = {
                    label = "Allgemein",
                },
                gpsTracker = {
                    label = "GPS-Tracker",
                },
                gpsTrackerAccess = {
                    label = "GPS-Tracker-Zugriff",
                },
                gpsTrackerPlacement = {
                    label = "GPS-Tracker-Platzierung",
                },
                gpsTrackerTiming = {
                    label = "GPS-Tracker-Zeitsteuerung",
                },
                gsr = {
                    label = "GSR",
                },
                handcuffs = {
                    label = "Handschellen",
                },
                handsUp = {
                    label = "Hände hoch",
                },
                header = {
                    label = "Kopfbereich",
                },
                impound = {
                    label = "Abschlepphof",
                },
                imprisonment = {
                    label = "Inhaftierung",
                },
                jailCanteenGeneral = {
                    label = "Gefängniskantine",
                },
                jailCanteenPackage = {
                    label = "Kantinenpaket",
                },
                jailCarry = {
                    label = "Tragejob",
                },
                jailCarryInspection = {
                    label = "Trage-Inspektion",
                },
                jailCleaning = {
                    label = "Reinigungsjob",
                },
                jailCleaningIllegalFinds = {
                    label = "Illegale Funde",
                },
                jailCleaningOutline = {
                    label = "Reinigungs-Umrandung",
                },
                jailDoctor = {
                    label = "Gefängnisarzt",
                },
                jailElectricalCodes = {
                    label = "Elektrik-Codes",
                },
                jailElectricalGeneral = {
                    label = "Gefängnis-Elektrik",
                },
                jailElectricalPenalties = {
                    label = "Elektrik-Strafen",
                },
                jailElectricalRewards = {
                    label = "Elektrik-Belohnungen",
                },
                jailInmatesAlcoholic = {
                    label = "Häftling: Alkoholiker",
                },
                jailInmatesCodeList = {
                    label = "Häftling: Informant",
                },
                jailInmatesDrugDealer = {
                    label = "Häftling: Drogendealer",
                },
                jailInmatesWireCutter = {
                    label = "Häftling: Werkzeugträger",
                },
                jailJobs = {
                    label = "Gefängnisjobs",
                },
                jailOutfitFemale = {
                    label = "Weibliches Outfit",
                },
                jailOutfitMale = {
                    label = "Männliches Outfit",
                },
                keybinds = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Tastenbelegung",
                },
                keybindsHandcuff = {
                    label = "Fesseln-Taste",
                },
                keybindsUnhandcuff = {
                    label = "Entfesseln-Taste",
                },
                marker = {
                    label = "Marker",
                },
                markerColor = {
                    label = "Markerfarbe",
                },
                mugshotAnimation = {
                    label = "Haftfoto-Animation",
                },
                mugshotBoard = {
                    label = "Haftfoto-Tafel",
                },
                mugshotCameraCoords = {
                    label = "Haftfoto-Kameraposition",
                },
                mugshotCameraRotation = {
                    label = "Haftfoto-Kamerarotation",
                },
                mugshotGeneral = {
                    label = "Haftfoto",
                },
                mugshotMetadata = {
                    label = "Haftfoto-Metadaten",
                },
                mugshotPosition = {
                    label = "Haftfoto-Position",
                },
                mugshotTiming = {
                    label = "Haftfoto-Zeitsteuerung",
                },
                officerDown = {
                    label = "Beamter angeschossen",
                },
                outfit = {
                    label = "Ausstattung",
                },
                overlay = {
                    label = "Kennzeichen-Overlay",
                },
                payment = {
                    label = "Zahlung",
                },
                paymentFlow = {
                    label = "Zahlungsablauf",
                },
                penalties = {
                    label = "Strafen",
                },
                playerSearch = {
                    label = "Durchsuchung",
                },
                playerSearchAnimation = {
                    label = "Durchsuchungs-Animation",
                },
                props = {
                    label = "Prop-Gegenstände",
                },
                reasons = {
                    label = "Gründe",
                },
                release = {
                    label = "Freigabe",
                },
                reports = {
                    label = "Berichte",
                },
                restore = {
                    label = "Wiederherstellung",
                },
                rules = {
                    label = "Regeln",
                },
                scan = {
                    label = "Untersuchung",
                },
                scanner = {
                    label = "Scanner",
                },
                sentence = {
                    label = "Haftstrafe",
                },
                shotsFired = {
                    label = "Schüsse gefallen",
                },
                sound = {
                    label = "Ton an",
                },
                speedcam = {
                    label = "Blitzersäulen",
                },
                speedcamAdvanced = {
                    label = "Erweiterter Blitzer",
                },
                speedcamBilling = {
                    label = "Blitzersäulen-Abrechnung",
                },
                speedcamDispatch = {
                    label = "Blitzersäulen-Dispatch",
                },
                speedcamDurability = {
                    label = "Blitzersäulen-Haltbarkeit",
                },
                speedcamPlacement = {
                    label = "Blitzersäulen-Platzierung",
                },
                speedcamRepair = {
                    label = "Blitzersäulen-Reparatur",
                },
                speedcamRepairAnimation = {
                    label = "Blitzersäulen-Reparaturanimation",
                },
                speedcamTiming = {
                    label = "Blitzersäulen-Zeitsteuerung",
                },
                speedcamVisual = {
                    label = "Blitzersäulen-Optik",
                },
                speedcams = {
                    label = "Blitzer",
                },
                storage = {
                    label = "Lagerung",
                },
                subscription = {
                    label = "App-Abo",
                },
                tackle = {
                    label = "Zu-Boden-Bringen",
                },
                tasks = {
                    label = "Aufgaben",
                },
                theme = {
                    label = "Design",
                },
                timing = {
                    label = "Zeitsteuerung",
                },
                vin = {
                    label = "VIN-Check",
                },
                warningUi = {
                    label = "Warn-UI",
                },
                world = {
                    label = "Welt",
                },
                zipties = {
                    label = "Kabelbinder",
                },
                ziptiesCutter = {
                    label = "Ziptie-Schneider",
                },
            },
            settingSections = {
                radarGun = "Radarpistole",
                billing = "Abrechnung",
                cctv = "CCTV",
                dispatch = "Leitstelle",
                equipment = "Ausrüstung",
                evidence = "Beweise",
                fakePlates = "Gefälschte Kennzeichen",
                general = "Allgemein",
                impound = "Abschlepphof",
                jail = "Gefängnis",
                radar = "Fahrzeug-Radar",
                radial = "Radialaktionen",
                restraints = "Fesseln",
                socialWork = "Sozialarbeit",
                speedCamera = "Blitzer",
                spikeStrips = "Reifenstacheln",
                stations = "Stationen",
                tablet = "Tablet-Apps",
                tracking = "Ortung",
            },
            settingSubsections = {
                app = "Blitzer-App",
                apps = "Apps",
                billing = "Abrechnung",
                canteen = "Gefängniskantine",
                dispatch = "Leitstelle",
                durability = "Haltbarkeit",
                electrical = "Gefängnis-Elektrik",
                general = "Allgemein",
                handcuffs = "Handschellen & Kabelbinder",
                inmates = "Häftlinge",
                jobs = "Gefängnisjobs",
                keybinds = "Tastenbelegung",
                motionDetection = "Bewegungserkennung",
                mugshot = "Haftfoto",
                placement = "Platzierung",
                repair = "Reparatur",
                timing = "Zeitsteuerung",
                visuals = "Optik",
            },
            settings = {
                radarGunClearKey = { label = "Radarpistole: Messwert löschen" },
                radarGunToggleUiKey = { label = "Radarpistole: Anzeige umschalten" },
                radarGunNoTargetHoldMs = { label = "Messwert-Haltezeit (ms)" },
                radarGunMinimumReading = { label = "Niedrigste angezeigte Geschwindigkeit" },
                radarGunSpeedSmoothing = { label = "Geschwindigkeitsglättung (0–1)" },
                radarGunBeamRadius = { label = "Strahlradius (m)" },
                radarGunRefreshRateMs = { label = "Messintervall (ms)" },
                radarGunUseMph = { label = "MPH verwenden", description = "Zeigt Messungen der Radarpistole in Meilen pro Stunde statt Kilometern pro Stunde an." },
                radarGunRange = { label = "Messreichweite", description = "Maximale Entfernung in Metern, auf die die Radarpistole Fahrzeuge erfasst." },
                radarGunRequireOnDuty = { label = "Dienst erforderlich", description = "Offiziere müssen im Dienst sein, bevor sie Fahrzeuge mit der Radarpistole messen können." },
                radarGunAllowedJobs = { label = "Erlaubte Jobs oder Gruppen", description = "police umfasst alle konfigurierten Police Jobs; direkte Jobnamen sind ebenfalls möglich. Eine leere Liste hebt die Jobbeschränkung auf.", itemLabel = "Job oder Gruppe" },
                radarGunEnabled = { label = "Radarpistole", description = "Aktiviert die handgehaltene SKY SR-2 Radarpistole." },
                tabletRegistry = {
                    label = "Register",
                    description = "Eigene RP-Register im File Explorer aktivieren. Personen- und Fahrzeugakten bleiben separat verfügbar.",
                },
                tabletFiles = {
                    label = "Datei-Explorer",
                    description = "Bündelt Polizeiakten im Datei-Explorer. DOJ-Dokumente erscheinen nur bei aktivem DOJ.",
                },
                ankleMonitorAnimDurationMs = {
                    description = "Millisekunden, die zum Anlegen einer elektronischen Fußfessel benötigt werden.",
                    label = "Anlegedauer",
                },
                ankleMonitorAnimScenario = {
                    description = "Szenario, das beim Anlegen einer elektronischen Fußfessel abgespielt wird.",
                    label = "Anlege-Szenario",
                },
                ankleMonitorAttachBone = {
                    description = "Ped-Knochen, an dem das Fußfessel-Prop angeheftet wird.",
                    label = "Anheftungsknochen",
                },
                ankleMonitorConsumeOnPlace = {
                    description = "Entfernt den Fußfessel-Gegenstand nach dem Anlegen.",
                    label = "Fußfessel verbrauchen",
                },
                ankleMonitorCutItem = {
                    description = "Inventargegenstand, der zum Entfernen elektronischer Fußfesseln verwendet wird.",
                    label = "Durchtrenn-Gegenstand",
                },
                ankleMonitorEnabled = {
                    description = "Aktiviert das Anlegen elektronischer Fußfesseln.",
                    label = "Elektronische Fußfessel",
                },
                ankleMonitorItem = {
                    description = "Inventargegenstand, der zum Anlegen elektronischer Fußfesseln verwendet wird.",
                    label = "Fußfessel-Gegenstand",
                },
                ankleMonitorMapUpdateIntervalMs = {
                    description = "Millisekunden zwischen Kartenaktualisierungen der elektronischen Fußfessel.",
                    label = "Kartenaktualisierungsintervall",
                },
                ankleMonitorPersistOnDisconnect = {
                    description = "Behält Fußfesseln in der Datenbank, wenn überwachte Spieler die Verbindung trennen, damit sie nach Reconnects und Serverneustarts wiederhergestellt werden.",
                    label = "Nach Trennung beibehalten",
                },
                ankleMonitorPlaceDistance = {
                    description = "Maximale Distanz, um eine elektronische Fußfessel anzulegen.",
                    label = "Anlegedistanz",
                },
                ankleMonitorPropModel = {
                    description = "Prop-Modell, das für die Optik der elektronischen Fußfessel verwendet wird.",
                    label = "Prop-Modell",
                },
                ankleMonitorRequireOnDuty = {
                    description = "Erfordert Dienststatus vor der Nutzung elektronischer Fußfesseln.",
                    label = "Fußfessel erfordert Dienst",
                },
                ankleMonitorRequirePoliceJob = {
                    description = "Erfordert, dass der Spieler zur Polizeigruppe gehört, bevor elektronische Fußfesseln verwendet werden.",
                    label = "Fußfessel erfordert Polizeijob",
                },
                ankleMonitorReturnOnRemove = {
                    description = "Gibt den Fußfessel-Gegenstand zurück, wenn sie entfernt wird.",
                    label = "Fußfessel beim Entfernen zurückgeben",
                },
                ankleMonitorWarningSeconds = {
                    description = "Warnzeit, bevor ein Zonenverstoß der Fußfessel per Dispatch gemeldet wird.",
                    label = "Zonenwarnung Sekunden",
                },
                ankleMonitorZoneBeepIntervalMs = {
                    description = "Millisekunden zwischen den Warnpieptönen der Fußfesselzone.",
                    label = "Zonen-Piepton-Intervall",
                },
                ankleMonitorZoneBeepSound = {
                    description = "Soundname, der für Warnungen der Fußfesselzone verwendet wird.",
                    label = "Piepton-Sound",
                },
                ankleMonitorZoneBeepSoundSet = {
                    description = "Sound-Set, das für Warnungen der Fußfesselzone verwendet wird.",
                    label = "Piepton-Sound-Set",
                },
                ankleMonitorZoneBlipAlpha = {
                    description = "Alphawert, der für Blips der Fußfesselzone verwendet wird.",
                    label = "Blip-Transparenz",
                },
                ankleMonitorZoneBlipColorAllowed = {
                    description = "Blip-Farbe, die verwendet wird, wenn sich ein Ziel innerhalb des erlaubten Bereichs befindet.",
                    label = "Blip-Farbe erlaubt",
                },
                ankleMonitorZoneBlipColorExcluded = {
                    description = "Blip-Farbe, die verwendet wird, wenn ein Ziel den erlaubten Bereich verlässt.",
                    label = "Blip-Farbe außerhalb",
                },
                ankleMonitorZoneCheckIntervalMs = {
                    description = "Millisekunden zwischen den Zonenprüfungen der elektronischen Fußfessel.",
                    label = "Zonenprüfungsintervall",
                },
                ankleMonitorZoneDispatchCooldownSeconds = {
                    description = "Sekunden, bevor erneut ein Fußfesselzonen-Dispatch gesendet werden kann.",
                    label = "Zonen-Dispatch-Cooldown",
                },
                ankleMonitorZoneEnabled = {
                    description = "Aktiviert die Zonenprüfung der elektronischen Fußfessel.",
                    label = "Fußfesselzonen",
                },
                ankleMonitorZoneLabelSprite = {
                    description = "Blip-Sprite, das für Marker der Fußfesselzone verwendet wird.",
                    label = "Zonen-Label-Sprite",
                },
                ankleMonitorZoneOutlineRadius = {
                    description = "Radius, der für Umrandungen der Fußfesselzone verwendet wird.",
                    label = "Umrandungsradius",
                },
                ankleMonitorZoneOutlineStep = {
                    description = "Schrittweite, die für Umrandungen der Fußfesselzone verwendet wird.",
                    label = "Umrandungsschritt",
                },
                billingAccount = {
                    description = "Ausweichkonto, das verwendet wird, wenn für einen Job kein Society-Konto konfiguriert ist.",
                    label = "Ausweich-Society-Konto",
                },
                billingCloseOnSuccess = {
                    description = "Schließt die Abrechnungs-UI, nachdem eine Rechnung ausgestellt wurde.",
                    label = "Nach Erfolg schließen",
                },
                billingCurrency = {
                    description = "Währungsschlüssel für die Abrechnung. Leer lassen, um die Standardwährung zu verwenden.",
                    label = "Währung",
                },
                billingCustomReasons = {
                    description = "Erlaubt eigene Abrechnungsgründe anstelle nur vorgegebener Optionen.",
                    label = "Eigene Gründe",
                },
                billingDepositToSociety = {
                    description = "Zahlt Einnahmen aus Rechnungen in das Society-Konto des Jobs ein.",
                    label = "In Society-Konto einzahlen",
                },
                billingMaxReasonLength = {
                    description = "Maximale Zeichenanzahl für eigene Abrechnungsgründe.",
                    label = "Länge des Grundes",
                },
                billingMode = {
                    description = "Legt fest, ob Polizeirechnungen sofort abgebucht werden, eine Bestätigung des Bürgers erfordern oder das Framework-Abrechnungssystem nutzen.",
                    label = "Abrechnungsmodus",
                    options = {
                        consent = "Bezahlen oder ablehnen",
                        framework = "Framework-Rechnung",
                        instant = "Sofortige Abbuchung",
                    },
                },
                billingRange = {
                    description = "Maximale Zieldistanz für das Ausstellen von Polizeirechnungen.",
                    label = "Abrechnungsreichweite",
                },
                billingReasonPresets = {
                    description = "Vorgegebene Abrechnungsgründe, die in der Abrechnungs-UI angezeigt werden.",
                    itemLabel = "Grund",
                    label = "Vorgegebene Gründe",
                },
                billingRefreshSeconds = {
                    description = "Aktualisierungsintervall des Ziels, während die Abrechnungs-UI geöffnet ist.",
                    label = "Aktualisierungssekunden",
                },
                billingShowRecipientName = {
                    description = "Zeigt den Namen der Person in Ticketvorschauen und auf Belegen an.",
                    label = "Empfängername anzeigen",
                },
                carryAllowCarrierInVehicle = {
                    description = "Erlaubt dem Träger, ein Fahrzeug zu betreten und zu fahren, ohne den Spieler abzulegen.",
                    label = "Träger im Fahrzeug erlauben",
                },
                carryAllowConscious = {
                    description = "Erlaubt das Tragen bewusster Ziele.",
                    label = "Bewusste Ziele tragen",
                },
                carryAllowSprint = {
                    description = "Erlaubt das Sprinten, während ein anderer Spieler getragen wird.",
                    label = "Sprinten beim Tragen erlauben",
                },
                carryEnabled = {
                    description = "Aktiviert das Tragen von Spielern.",
                    label = "Tragen",
                },
                carryMaxDistance = {
                    description = "Maximale Distanz, um das Tragen eines Spielers zu beginnen.",
                    label = "Tragedistanz",
                },
                carryRequireOnDuty = {
                    description = "Erfordert Dienststatus vor Beginn des Tragens.",
                    label = "Tragen erfordert Dienst",
                },
                cctvDamageCooldownMs = {
                    description = "Millisekunden, bevor CCTV-Schaden erneut zugefügt werden kann.",
                    label = "Schadens-Cooldown",
                },
                cctvDamagePerHit = {
                    description = "Haltbarkeitsschaden, der CCTV-Kameras pro Treffer zugefügt wird.",
                    label = "Schaden pro Treffer",
                },
                cctvDefaultName = {
                    description = "Standard-Anzeigename für aufgestellte CCTV-Kameras.",
                    label = "CCTV-Standardname",
                },
                cctvDefaultPitch = {
                    description = "Standard-Kameraneigung für die CCTV-Platzierung.",
                    label = "Standard-Neigung",
                },
                cctvDisassembleDistance = {
                    description = "Distanz, die zur Demontage von CCTV-Kameras verwendet wird.",
                    label = "Demontagedistanz",
                },
                cctvEnabled = {
                    description = "Aktiviert das Platzieren und Streamen von CCTV-Kameras.",
                    label = "CCTV-Kameras",
                },
                cctvHealthDisplayDistance = {
                    description = "Distanz, ab der der CCTV-Zustand angezeigt wird.",
                    label = "Zustandsanzeige-Distanz",
                },
                cctvHealthDisplayDurationMs = {
                    description = "Millisekunden, die der CCTV-Zustand sichtbar bleibt.",
                    label = "Zustandsanzeige-Dauer",
                },
                cctvHealthTextOffset = {
                    description = "Vertikaler Versatz, der für den CCTV-Zustandstext verwendet wird.",
                    label = "Zustandstext-Versatz",
                },
                cctvHeightStep = {
                    description = "Höhenschritt, der beim Ausrichten von CCTV-Kameras verwendet wird.",
                    label = "Höhenschritt",
                },
                cctvItem = {
                    description = "Inventargegenstand, der zum Platzieren von CCTV-Kameras verwendet wird.",
                    label = "CCTV-Gegenstand",
                },
                cctvMaintenanceThreshold = {
                    description = "Haltbarkeitsschwelle, ab der eine CCTV-Wartung empfohlen wird.",
                    label = "Wartungsschwelle",
                },
                cctvMaxDurability = {
                    description = "Maximale Haltbarkeit einer CCTV-Kamera.",
                    label = "CCTV-Haltbarkeit",
                },
                cctvMotionAlertCooldownSeconds = {
                    description = "Sekunden, bevor eine Kamera eine weitere Bewegungsmeldung erstellen kann.",
                    label = "Dispatch-Cooldown",
                },
                cctvMotionCheckIntervalMs = {
                    description = "Millisekunden zwischen clientseitigen Bewegungsscans.",
                    label = "Prüfintervall",
                },
                cctvMotionClientCooldownMs = {
                    description = "Millisekunden, bevor ein Client dieselbe Kamera erneut melden kann.",
                    label = "Client-Melde-Cooldown",
                },
                cctvMotionDefaultCameraEnabled = {
                    description = "Aktiviert Bewegungsmeldungen automatisch für neu platzierte CCTV-Kameras.",
                    label = "Neue Kameras standardmäßig aktiv",
                },
                cctvMotionDetectionEnabled = {
                    description = "Aktiviert kamerabezogene Dispatch-Meldungen bei erkannter Bewegung.",
                    label = "Bewegungsmeldungen",
                },
                cctvMotionDetectionRadius = {
                    description = "Maximale Entfernung der Bewegungserkennung in Metern.",
                    label = "Erfassungsradius",
                },
                cctvMotionFieldOfView = {
                    description = "Winkel des Erfassungskegels in Grad.",
                    label = "Sichtfeld",
                },
                cctvMotionJobs = {
                    description = "Jobnamen oder Jobgruppen, die CCTV-Bewegungsmeldungen erhalten.",
                    itemLabel = "Job oder Gruppe",
                    label = "Dispatch-Jobs",
                },
                cctvMotionMinimumSpeed = {
                    description = "Minimale Objektgeschwindigkeit in Metern pro Sekunde, die als Bewegung gilt.",
                    label = "Mindestbewegungsgeschwindigkeit",
                },
                cctvMoveStep = {
                    description = "Bewegungsschritt, der beim Ausrichten von CCTV-Kameras verwendet wird.",
                    label = "Bewegungsschritt",
                },
                cctvPropModel = {
                    description = "Prop-Modell, das für aufgestellte CCTV-Kameras verwendet wird.",
                    label = "CCTV-Prop-Modell",
                },
                cctvRepairAnimDict = {
                    description = "Anim Dict, das bei der Reparatur von CCTV-Kameras verwendet wird.",
                    label = "Reparatur-Anim Dict",
                },
                cctvRepairAnimFlag = {
                    description = "Animations-Flag, das bei der Reparatur von CCTV-Kameras verwendet wird.",
                    label = "Reparatur-Animations-Flag",
                },
                cctvRepairAnimName = {
                    description = "Animationsname, der bei der Reparatur von CCTV-Kameras verwendet wird.",
                    label = "Reparatur-Animationsname",
                },
                cctvRepairCancelDelayMs = {
                    description = "Millisekunden, bevor eine CCTV-Reparatur abgebrochen werden kann.",
                    label = "Reparaturabbruch-Verzögerung",
                },
                cctvRepairDistance = {
                    description = "Distanz, die zur Reparatur von CCTV-Kameras verwendet wird.",
                    label = "Reparaturdistanz",
                },
                cctvRepairItem = {
                    description = "Inventargegenstand, der zur Reparatur von CCTV-Kameras verwendet wird.",
                    label = "Reparaturgegenstand",
                },
                cctvRepairPerTick = {
                    description = "Haltbarkeit, die pro CCTV-Reparaturtakt wiederhergestellt wird.",
                    label = "Reparatur pro Takt",
                },
                cctvRepairTickMs = {
                    description = "Millisekunden zwischen den Reparaturtakten der CCTV-Kamera.",
                    label = "Reparaturtakt",
                },
                cctvRotateStep = {
                    description = "Drehschritt, der beim Ausrichten von CCTV-Kameras verwendet wird.",
                    label = "Drehschritt",
                },
                cctvStreamDistance = {
                    description = "Distanz, die zum Streamen von CCTV-Kameras verwendet wird.",
                    label = "Streamdistanz",
                },
                cctvViewOffset = {
                    description = "Sichtversatz, der für die CCTV-Live-Bildwiedergabe verwendet wird.",
                    label = "Sichtversatz",
                },
                crimeSceneTapeCollisionEnabled = {
                    description = "Erzeugt entlang des Bands eine blockierende Kollisionsfläche, damit Spieler nicht hindurchlaufen können.",
                    label = "Blockierende Bandkollision",
                },
                crimeSceneTapeConsumeItem = {
                    description = "Entfernt nach erfolgreicher Platzierung einen Absperrband-Gegenstand aus dem Inventar.",
                    label = "Absperrband verbrauchen",
                },
                crimeSceneTapeDynamic = {
                    description = "Lässt das Absperrband auf Physik und Schwerkraft reagieren, statt es fest zu verankern.",
                    label = "Dynamische Physik",
                },
                crimeSceneTapeEnabled = {
                    description = "Aktiviert das Platzieren von Tatort-Absperrband über einen Inventargegenstand.",
                    label = "Tatort-Absperrband",
                },
                crimeSceneTapeEnforceRemovalAccess = {
                    description = "Nur berechtigte Jobs dürfen das Absperrband entfernen; falls aktiviert, müssen sie im Dienst sein.",
                    label = "Entfernung beschränken",
                },
                crimeSceneTapeItem = {
                    description = "Name des Inventargegenstands, der die Platzierung des Tatort-Absperrbands startet.",
                    label = "Absperrband-Gegenstand",
                },
                crimeSceneTapeJobs = {
                    description = "Jobnamen, die das Tatort-Absperrband verwenden dürfen.",
                    itemLabel = "Beruf",
                    label = "Berechtigte Jobs",
                },
                crimeSceneTapeLabel = {
                    description = "Anzeigename des Tatort-Absperrbands während der Platzierung.",
                    label = "Absperrband-Bezeichnung",
                },
                crimeSceneTapeLengthStep = {
                    description = "Schrittweite in Metern, auf die die gewählte Bandlänge gerundet wird.",
                    label = "Längenschritt",
                },
                crimeSceneTapeMaxLength = {
                    description = "Größter zulässiger Abstand zwischen den beiden Bandpfosten in Metern.",
                    label = "Maximale Bandlänge",
                },
                crimeSceneTapeMaxPlacementDistance = {
                    description = "Maximale Entfernung eines der beiden Endpunkte vom platzierenden Beamten.",
                    label = "Maximale Platzierungsdistanz",
                },
                crimeSceneTapeMinLength = {
                    description = "Kleinster zulässiger Abstand zwischen den beiden Bandpfosten in Metern.",
                    label = "Minimale Bandlänge",
                },
                crimeSceneTapeModel = {
                    description = "Name des Prop-Modells für das platzierte Tatort-Absperrband.",
                    label = "Absperrband-Modell",
                },
                crimeSceneTapePostModel = {
                    description = "Prop-Modell, das für beide Bandpfosten verwendet wird.",
                    label = "Pfostenmodell",
                },
                crimeSceneTapeRemoveDistance = {
                    description = "Maximale Entfernung zum Entfernen eines platzierten Tatort-Absperrbands.",
                    label = "Entfernungsdistanz",
                },
                crimeSceneTapeRequireOnDuty = {
                    description = "Nur Angehörige berechtigter Jobs im Dienst dürfen das Absperrband platzieren.",
                    label = "Dienst erforderlich",
                },
                crimeSceneTapeReturnItemOnRemove = {
                    description = "Gibt den verbrauchten Gegenstand beim Entfernen des platzierten Absperrbands zurück.",
                    label = "Gegenstand beim Entfernen zurückgeben",
                },
                crimeSceneTapeSag = {
                    description = "Maximaler Durchhang des Bands zwischen den Pfosten in Metern.",
                    label = "Banddurchhang",
                },
                crimeSceneTapeSections = {
                    description = "Native Bandsegment-Modelle, aus denen die gewählte Länge zusammengesetzt wird.",
                    itemLabel = "Bandsegment",
                    label = "Bandsegmente",
                },
                crimeSceneTapeShowPosts = {
                    description = "Erzeugt sichtbare Stützpfosten an beiden Enden des variabel langen Tatort-Absperrbands.",
                    label = "Absperrband-Pfosten anzeigen",
                },
                crimeSceneTapeStreamDistance = {
                    description = "Entfernung, innerhalb der das platzierte Tatort-Absperrband geladen wird.",
                    label = "Streaming-Distanz",
                },
                crimeSceneTapeTapeHeight = {
                    description = "Höhe des Bands über den ausgewählten Bodenpunkten.",
                    label = "Bandhöhe",
                },
                crimeSceneTapeVariableLength = {
                    description = "Erlaubt Beamten, Start- und Endpunkt festzulegen und das Tatort-Absperrband in variabler Länge zu platzieren.",
                    label = "Variable Absperrband-Länge",
                },
                crimeSceneTapeZOffset = {
                    description = "Vertikaler Versatz beim Platzieren des Absperrband-Modells.",
                    label = "Höhenversatz",
                },
                cuffsAnimDict = {
                    description = "Anim Dict, das für gefesselte Spieler verwendet wird.",
                    label = "Anim Dict",
                },
                cuffsAnimFlag = {
                    description = "Animations-Flag, das für gefesselte Spieler verwendet wird.",
                    label = "Animations-Flag",
                },
                cuffsAnimName = {
                    description = "Animationsname, der für gefesselte Spieler verwendet wird.",
                    label = "Animationsname",
                },
                cuffsConsumeItem = {
                    description = "Entfernt den Handschellen-Gegenstand, wenn Handschellen angelegt werden.",
                    label = "Handschellen verbrauchen",
                },
                cuffsEnabled = {
                    description = "Aktiviert die Handschellen-Aktionen.",
                    label = "Handschellen",
                },
                cuffsEscapeEnabled = {
                    description = "Aktiviert das Minispiel zum Entkommen aus Handschellen.",
                    label = "Fesseln entkommen",
                },
                cuffsEscapeKeyPool = {
                    description = "Tasten, die im Handschellen-Entkommen-Minispiel erscheinen können.",
                    itemLabel = "Taste",
                    label = "Entkommen-Tastenpool",
                },
                cuffsEscapeRounds = {
                    description = "Anzahl der Runden, die im Handschellen-Entkommen-Minispiel benötigt werden.",
                    label = "Entkommen-Runden",
                },
                cuffsEscapeWindowMs = {
                    description = "Millisekunden, die pro Eingabefenster beim Entkommen aus Handschellen erlaubt sind.",
                    label = "Entkommen-Zeitfenster",
                },
                cuffsHandsUpEnabled = {
                    description = "Aktiviert den Hände-hoch-Zustand, der von Handschellen und Zipties verwendet wird.",
                    label = "Hände hoch",
                },
                cuffsHandsUpHoldSeconds = {
                    description = "Sekunden, die die Hände-hoch-Taste gehalten werden muss, bevor sie aktiviert wird.",
                    label = "Hände-hoch Haltesekunden",
                },
                cuffsHandsUpKey = {
                    description = "Tastaturtaste, um die Hände zu heben.",
                    label = "Hände-hoch-Taste",
                },
                cuffsItem = {
                    description = "Inventargegenstand, der für Handschellen-Aktionen verwendet wird.",
                    label = "Handschellen-Gegenstand",
                },
                cuffsMaxDistance = {
                    description = "Maximale Zieldistanz für Handschellen-Aktionen.",
                    label = "Fesseldistanz",
                },
                cuffsRequireItem = {
                    description = "Erfordert den konfigurierten Handschellen-Gegenstand.",
                    label = "Handschellen erfordern Gegenstand",
                },
                cuffsRequireOnDuty = {
                    description = "Erfordert Dienststatus vor dem Anlegen von Handschellen.",
                    label = "Handschellen erfordern Dienst",
                },
                cuffsReturnOnRemove = {
                    description = "Gibt den Handschellen-Gegenstand zurück, wenn die Handschellen entfernt werden.",
                    label = "Handschellen zurückgeben",
                },
                dispatchOfficerDownEnabled = {
                    description = "Sendet einen Dispatch-Alarm, wenn ein Beamter im Dienst kampfunfähig wird.",
                    label = "Beamter-angeschossen-Alarm",
                },
                dispatchOfficerDownJobs = {
                    description = "Jobs, die Dispatches bei Beamter-angeschossen erhalten sollen.",
                    itemLabel = "Beruf",
                    label = "Dispatch-Jobs (Beamter angeschossen)",
                },
                dispatchOfficerDownRequireDuty = {
                    description = "Benachrichtigt nur Spieler, die sich aktuell im Dienst befinden.",
                    label = "Beamter angeschossen erfordert Dienst",
                },
                dispatchShotsFiredChance = {
                    description = "Chance von 0.0 bis 1.0, mit der ein erkannter Schuss einen Alarm auslöst.",
                    label = "Alarmchance",
                },
                dispatchShotsFiredCooldownSeconds = {
                    description = "Sekunden, bevor derselbe Spieler erneut einen Schüsse-Alarm auslösen kann.",
                    label = "Schüsse-Cooldown",
                },
                dispatchShotsFiredEnabled = {
                    description = "Aktiviert Dispatch-Alarme bei Schüssen.",
                    label = "Schüsse-gefallen-Alarm",
                },
                dispatchShotsFiredIgnoredWeapons = {
                    description = "Waffen, die keinen Schüsse-Alarm auslösen sollen.",
                    itemLabel = "Waffe",
                    label = "Ignorierte Waffen",
                },
                dispatchShotsFiredJobs = {
                    description = "Jobs, die Dispatches bei Schüssen erhalten sollen.",
                    itemLabel = "Beruf",
                    label = "Dispatch-Jobs (Schüsse)",
                },
                dispatchShotsFiredRequireDuty = {
                    description = "Benachrichtigt nur Spieler, die sich aktuell im Dienst befinden.",
                    label = "Schüsse erfordern Dienst",
                },
                dispatchShotsFiredSendDispatch = {
                    description = "Erstellt Dispatch-Einträge, wenn Schüsse erkannt werden.",
                    label = "Dispatch bei Schüssen senden",
                },
                dispatchShotsFiredSuppressedChance = {
                    description = "Chance von 0.0 bis 1.0, mit der ein erkannter gedämpfter Schuss einen Alarm auslöst.",
                    label = "Alarmchance bei Schalldämpfer",
                },
                escortEnabled = {
                    description = "Aktiviert das Eskortieren von Spielern.",
                    label = "Eskortieren",
                },
                escortMaxDistance = {
                    description = "Maximale Distanz, um das Eskortieren eines Spielers zu beginnen.",
                    label = "Eskortdistanz",
                },
                escortRequireOnDuty = {
                    description = "Erfordert Dienststatus vor dem Eskortieren von Spielern.",
                    label = "Eskortieren erfordert Dienst",
                },
                escortVehicleDistance = {
                    description = "Maximale Distanz, um einen eskortierten Spieler in ein Fahrzeug zu setzen.",
                    label = "Eskort-Fahrzeugdistanz",
                },
                evidenceBloodDamageThreshold = {
                    description = "Mindestschadensschwelle, bevor Blutbeweise erstellt werden.",
                    label = "Blutschaden-Schwelle",
                },
                evidenceCasingCreateCooldownMs = {
                    description = "Millisekunden, bevor eine weitere Patronenhülse erstellt werden kann.",
                    label = "Hülsen-Cooldown",
                },
                evidenceCasingMergeRadius = {
                    description = "Radius, der zum Zusammenführen naher Patronenhülsen verwendet wird.",
                    label = "Hülsen-Zusammenführungsradius",
                },
                evidenceCleanupIntervalMs = {
                    description = "Millisekunden zwischen Bereinigungsdurchläufen der Beweise.",
                    label = "Bereinigungsintervall",
                },
                evidenceCleanupTtlSeconds = {
                    description = "Sekunden, bevor Beweise im Feld automatisch verfallen.",
                    label = "Bereinigungs-TTL",
                },
                evidenceCleanerAllowEveryone = {
                    label = "Reiniger für alle freigeben",
                    description = "Alle dürfen Spuren mit Wasserstoffperoxid entfernen. Deaktivieren, um die Job- und Ganglisten zu verwenden.",
                },
                evidenceCleanerJobs = {
                    label = "Jobs für den Reiniger",
                    description = "Interne Namen bei deaktivierter öffentlicher Freigabe. Ein passender Job oder eine passende Gang erlaubt den Zugriff; leere Listen sperren ihn.",
                    itemLabel = "Beruf",
                },
                evidenceCleanerGangs = {
                    label = "Gangs für den Reiniger",
                    description = "Interne Namen bei deaktivierter öffentlicher Freigabe. Ein passender Job oder eine passende Gang erlaubt den Zugriff; leere Listen sperren ihn.",
                    itemLabel = "Gang",
                },
                evidenceCollectDistance = {
                    description = "Distanz, um Beweise im Feld zu sammeln.",
                    label = "Sammeldistanz",
                },
                evidenceDiscoverDistance = {
                    description = "Distanz, um nahegelegene Beweismarker zu entdecken.",
                    label = "Entdeckungsdistanz",
                },
                evidenceFieldEnabled = {
                    description = "Aktiviert das Erstellen und Sammeln von Beweisen im Feld.",
                    label = "Beweise im Feld",
                },
                evidenceFieldFlashlightWeapon = {
                    description = "Waffe, die verwendet wird, um Beweise im Feld zu untersuchen und sichtbar zu machen.",
                    label = "Taschenlampen-Waffe",
                },
                evidenceGloveFreeHands = {
                    description = "Hand-Komponenten-Ids, die als nicht behandschuht gelten.",
                    label = "Handschuhfreie Hände",
                },
                evidenceGsrDurationSeconds = {
                    description = "Sekunden, die Schmauchspuren an den Händen eines Spielers verbleiben.",
                    label = "Dauer der Schmauchspuren",
                },
                evidenceGsrGlovesProtectHands = {
                    description = "Verhindert Schmauchspuren an den Händen, wenn der Schütze Handschuhe trägt.",
                    label = "Handschuhe schützen Hände",
                },
                evidenceGsrIgnoredWeapons = {
                    description = "Waffen, die keine Schmauchspuren verursachen.",
                    label = "Ignorierte Waffen",
                },
                evidenceGsrWashCheckIntervalMs = {
                    description = "Millisekunden zwischen Wasser-/Regenprüfungen, solange Schmauchspuren aktiv sind.",
                    label = "Prüfintervall zum Abwaschen",
                },
                evidenceGsrWashInRain = {
                    description = "Erlaubt das Entfernen von Schmauchspuren durch Regen.",
                    label = "Im Regen abwaschbar",
                },
                evidenceGsrWashInWater = {
                    description = "Erlaubt das Entfernen von Schmauchspuren durch Wasser.",
                    label = "In Wasser abwaschbar",
                },
                evidenceMarkerColor = {
                    description = "RGBA-Farbe, die für Beweismarker im Feld verwendet wird.",
                    label = "Markerfarbe",
                },
                evidenceMarkerDrawDistance = {
                    description = "Sichtdistanz, die für Beweismarker im Feld verwendet wird.",
                    label = "Sichtdistanz",
                },
                evidenceMarkerOffset = {
                    description = "Vertikaler Marker-Versatz, der für Beweise im Feld verwendet wird.",
                    label = "Versatz",
                },
                evidenceMarkerScaleX = {
                    description = "X-Skalierung des Markers, die für Beweise im Feld verwendet wird.",
                    label = "Skalierung X",
                },
                evidenceMarkerScaleY = {
                    description = "Y-Skalierung des Markers, die für Beweise im Feld verwendet wird.",
                    label = "Skalierung Y",
                },
                evidenceMarkerScaleZ = {
                    description = "Z-Skalierung des Markers, die für Beweise im Feld verwendet wird.",
                    label = "Skalierung Z",
                },
                evidenceMarkerType = {
                    description = "Markertyp, der für Beweise im Feld verwendet wird.",
                    label = "Markertyp",
                },
                evidenceMaxCreateDistance = {
                    description = "Maximale Distanz zum Erstellen von Beweiseinträgen.",
                    label = "Erstellungsdistanz",
                },
                evidenceSalivaConsentTimeoutMs = {
                    description = "Millisekunden, die für die Zustimmung zur Speichelprobe erlaubt sind.",
                    label = "Speichelprobe Zustimmungs-Timeout",
                },
                evidenceScannerDistance = {
                    description = "Distanz, die für Interaktionen mit dem Beweisscanner verwendet wird.",
                    label = "Scanner-Distanz",
                },
                evidenceScannerDurationMs = {
                    description = "Dauer der Fingerabdruck-/Scanner-Aktion in Millisekunden.",
                    label = "Scanner-Dauer",
                },
                evidenceStorageMaxCompartments = {
                    description = "Maximale Anzahl an Beweislagerfächern.",
                    label = "Lagerfächer",
                },
                fakePlateHeliDisplay = {
                    label = "Helikopterkamera zeigt gefälschtes Kennzeichen",
                    description = "Zeigt das gefälschte Kennzeichen in der Helikopterkamera an.",
                },
                fakePlateNormalToolsDisplay = {
                    label = "Normale Werkzeuge zeigen gefälschtes Kennzeichen",
                    description = "Zeigt das gefälschte Kennzeichen in den Standard-Polizeitools an.",
                },
                fakePlateRadarDisplay = {
                    label = "Radar zeigt gefälschtes Kennzeichen",
                    description = "Zeigt das gefälschte Kennzeichen auf dem Onboard-Radar an.",
                },
                fakePlateRecognitionEnabled = {
                    description = "Erlaubt Polizeisystemen, den gemeinsamen Statebag für gefälschte Kennzeichen auszulesen.",
                    label = "Gefälschte Kennzeichen erkennen",
                },
                fakePlateRecognitionStateBagKey = {
                    description = "Von Mechanicjob veröffentlichter Statebag-Key der Fahrzeug-Entity.",
                    label = "Statebag-Key",
                },
                fakePlateSpeedCamDisplay = {
                    label = "Blitzer zeigt gefälschtes Kennzeichen",
                    description = "Zeigt das gefälschte Kennzeichen in fest installierten Radarberichten an.",
                },
                fakePlateVinAllowedGrades = {
                    description = "Optionale Job-/Rang-Freigabeliste. Leer lassen, um alle Ränge der erlaubten Jobs zuzulassen.",
                    label = "FIN-Ränge",
                },
                fakePlateVinAllowedGangs = {
                    label = "Erlaubte Gangs",
                    description = "Wähle interne Gang- oder Organisationsnamen. Ein passender Job oder eine passende Gang gewährt die Freigabe bzw. Ausnahme. Dienstpflicht gilt nur für Jobs.",
                    itemLabel = "Gang",
                },
                fakePlateVinAllowedGangGrades = {
                    label = "Gang-Mindestränge",
                    description = "Optionale Gang-Mindestränge. Leer erlaubt alle Ränge. Anforderungen an Items gelten weiterhin.",
                },
                fakePlateVinAllowedJobs = {
                    label = "FIN-Jobs",
                    description = "Jobs, die die VIN-Verifizierung nutzen dürfen.",
                },
                fakePlateVinAudit = {
                    label = "FIN-Prüfungen protokollieren",
                    description = "Speichert VIN-Checks im Audit-Log.",
                },
                fakePlateVinCheckEnabled = {
                    label = "FIN-Prüfung aktiviert",
                    description = "Aktiviert den Befehl zur Fahrzeug-VIN-Verifizierung.",
                },
                fakePlateVinCommand = {
                    label = "FIN-Befehl",
                    description = "Befehl zum Überprüfen der Fahrgestellnummer (VIN) eines Fahrzeugs.",
                },
                fakePlateVinCooldown = {
                    label = "FIN-Cooldown",
                    description = "Verzögerung zwischen zwei VIN-Checks.",
                },
                fakePlateVinDistance = {
                    label = "Maximale FIN-Distanz",
                    description = "Maximale Entfernung zwischen dem Beamten und dem Fahrzeug zur VIN-Verifizierung.",
                },
                fakePlateVinIndicator = {
                    label = "Hinweis auf Fälschung anzeigen",
                    description = "Zeigt einen Indikator an, wenn eine Überprüfung ein gefälschtes Kennzeichen erkennt.",
                },
                fakePlateVinRequireDuty = {
                    label = "Dienst erforderlich",
                    description = "Erfordert, dass der Beamte im Dienst ist, um eine VIN zu verifizieren.",
                },
                fakePlateVinRequireScanner = {
                    label = "Scanner-Item erforderlich",
                    description = "Erfordert das konfigurierte Scanner-Objekt, um eine VIN zu verifizieren.",
                },
                fakePlateVinScannerItem = {
                    label = "Scanner-Item",
                    description = "Erforderlicher Inventargegenstand, um eine VIN zu verifizieren.",
                },
                gpsTrackerBeepDistance = {
                    description = "Distanz, ab der das Piepton-Feedback des GPS-Trackers relevant wird.",
                    label = "Piepton-Distanz",
                },
                gpsTrackerBeepIntervalFarMs = {
                    description = "Millisekunden zwischen Pieptönen bei Entfernung von einem Tracker.",
                    label = "Fernes Piepton-Intervall",
                },
                gpsTrackerBeepIntervalNearMs = {
                    description = "Millisekunden zwischen Pieptönen bei Nähe zu einem Tracker.",
                    label = "Nahes Piepton-Intervall",
                },
                gpsTrackerConsumeOnPlace = {
                    description = "Entfernt den Tracker-Gegenstand nach dem Platzieren.",
                    label = "GPS-Tracker verbrauchen",
                },
                gpsTrackerEnabled = {
                    description = "Aktiviert das Platzieren und Scannen von Fahrzeug-GPS-Trackern.",
                    label = "GPS-Tracker",
                },
                gpsTrackerItem = {
                    description = "Inventargegenstand, der zum Platzieren von GPS-Trackern verwendet wird.",
                    label = "Tracker-Gegenstand",
                },
                gpsTrackerMapUpdateIntervalMs = {
                    description = "Millisekunden zwischen Tracker-Kartenaktualisierungen.",
                    label = "Kartenaktualisierungsintervall",
                },
                gpsTrackerPlaceDistance = {
                    description = "Maximale Distanz, um einen GPS-Tracker an einem Fahrzeug zu platzieren.",
                    label = "Platzierungsdistanz",
                },
                gpsTrackerRemoveDistance = {
                    description = "Maximale Distanz, um einen platzierten GPS-Tracker zu entfernen.",
                    label = "Entfernungsdistanz",
                },
                gpsTrackerRemoveKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "GPS-Tracker entfernen",
                },
                gpsTrackerRequireOnDuty = {
                    description = "Erfordert Dienststatus vor der Nutzung von GPS-Trackern.",
                    label = "GPS erfordert Dienst",
                },
                gpsTrackerRequirePoliceJob = {
                    description = "Erfordert, dass der Spieler zur Polizeigruppe gehört, bevor GPS-Tracker verwendet werden.",
                    label = "GPS erfordert Polizeijob",
                },
                gpsTrackerReturnOnRemove = {
                    description = "Gibt den Tracker-Gegenstand zurück, wenn er entfernt wird.",
                    label = "Tracker beim Entfernen zurückgeben",
                },
                gpsTrackerScanDistance = {
                    description = "Maximale Distanz zum Scannen nach Trackern.",
                    label = "GPS-Scandistanz",
                },
                gpsTrackerScanDurationMs = {
                    description = "Millisekunden, die zum Scannen nach einem GPS-Tracker benötigt werden.",
                    label = "Scandauer",
                },
                gpsTrackerScannerWeapon = {
                    description = "Waffe oder Werkzeug, das zum Suchen nach GPS-Trackern verwendet wird.",
                    label = "Scanner-Waffe",
                },
                impoundAccount = {
                    description = "Konto, das für die Berechnung von Freigaben aus dem Abschlepphof verwendet wird.",
                    label = "Zahlungskonto",
                },
                impoundCreatorVehicleModel = {
                    description = "Fahrzeugmodell, das in der Vorschau des Abschlepp-Erstellers angezeigt wird.",
                    label = "Ersteller-Fahrzeugmodell",
                },
                impoundCustomGarageEnabled = {
                    description = "Verwendet eine eigene Garagenoberfläche für die Freigabe, sofern verfügbar.",
                    label = "Eigene Garagen-Freigabe",
                },
                impoundDefaultPrice = {
                    description = "Standard-Freigabepreis für den Abschlepphof.",
                    label = "Standardpreis",
                },
                impoundDeliveryDistance = {
                    description = "Distanz, die für Abschlepp-Zustellinteraktionen verwendet wird.",
                    label = "Zustelldistanz",
                },
                impoundDeliveryMarker = {
                    description = "Marker-Konfiguration, die für Abschlepp-Zustellungen verwendet wird.",
                    label = "Zustell-Marker",
                },
                impoundEnabled = {
                    description = "Aktiviert die Abschleppabläufe.",
                    label = "Abschlepphof",
                },
                impoundMarker = {
                    description = "Marker-Konfiguration, die für Abschlepp-Interaktionen verwendet wird.",
                    label = "Abschlepp-Marker",
                },
                impoundRadialEnabled = {
                    description = "Aktiviert das Abschleppen per Radialmenü.",
                    label = "Abschlepp-Aktion",
                },
                impoundRadialRequireOnDuty = {
                    description = "Erfordert Dienststatus, bevor die Abschlepp-Aktion per Radialmenü genutzt werden kann.",
                    label = "Abschleppen erfordert Dienst",
                },
                impoundRadialVehicleDistance = {
                    description = "Maximale Distanz zum Zielfahrzeug für das Abschleppen per Radialmenü.",
                    label = "Abschlepp-Fahrzeugdistanz",
                },
                impoundReleaseDistance = {
                    description = "Distanz, die für Freigabe-Interaktionen im Abschlepphof verwendet wird.",
                    label = "Freigabedistanz",
                },
                impoundReleaseKey = {
                    description = "Steuerungscode, der zum Freigeben abgeschleppter Fahrzeuge verwendet wird.",
                    label = "Freigabetaste",
                },
                impoundRequireDelivery = {
                    description = "Erfordert die Zustellung an einen konfigurierten Abschlepphof.",
                    label = "Zustellung erforderlich",
                },
                impoundStorageBasePrice = {
                    description = "Grund-Freigabepreis für eingelagerte Abschlepp-Fahrzeuge.",
                    label = "Lagerungs-Grundpreis",
                },
                impoundStorageDailyFee = {
                    description = "Zusätzliche Lagerungsgebühr für den Abschlepphof pro konfiguriertem Tag.",
                    label = "Lagerungs-Tagesgebühr",
                },
                impoundStorageDaySeconds = {
                    description = "Wie viele Sekunden als ein Lagerungs-Abrechnungstag zählen.",
                    label = "Lagerungstag in Sekunden",
                },
                impoundStorageEnabled = {
                    description = "Aktiviert die kostenpflichtige Verwaltung der Abschlepp-Lagerung.",
                    label = "Abschlepp-Lagerung",
                },
                jailAssignRange = {
                    description = "Maximale Distanz, um ein Ziel ins Gefängnis zu bringen.",
                    label = "Zuweisungsreichweite",
                },
                jailCanteenCooldownMinutes = {
                    description = "Minuten, die ein Häftling warten muss, bevor er ein weiteres Kantinenpaket beanspruchen kann.",
                    label = "Cooldown-Minuten",
                },
                jailCanteenPackage = {
                    description = "Gegenstände, die durch das Gefängniskantinenpaket gewährt werden.",
                    label = "Kantinenpaket",
                },
                jailCellStreamDistance = {
                    description = "Distanz, die für das Streaming von Einzelzellen-Props verwendet wird.",
                    label = "Zellen-Streamdistanz",
                },
                jailClearInventory = {
                    description = "Leert das Spielerinventar, wenn er ins Gefängnis geschickt wird.",
                    label = "Inventar leeren",
                },
                jailDefaultMonths = {
                    description = "Standard-Haftdauer beim Öffnen der Zuweisungs-UI.",
                    label = "Standardmonate",
                },
                jailDispatchJobs = {
                    description = "Jobs, die Gefängnis-Dispatches erhalten sollen.",
                    itemLabel = "Beruf",
                    label = "Dispatch-Jobs",
                },
                jailDoctorHealEvent = {
                    description = "Server- oder Client-Event, das ausgelöst wird, wenn der Gefängnisarzt einen Häftling heilt.",
                    label = "Heilungs-Event",
                },
                jailElectricalCodeListItem = {
                    description = "Inventargegenstand, der benötigt wird, um erzeugte Elektrik-Codes aufzudecken.",
                    label = "Codeliste-Gegenstand",
                },
                jailElectricalCodeMax = {
                    description = "Höchster zufälliger Codewert für den Elektrik-Kasten.",
                    label = "Höchst-Code",
                },
                jailElectricalCodeMin = {
                    description = "Niedrigster zufälliger Codewert für den Elektrik-Kasten.",
                    label = "Mindest-Code",
                },
                jailElectricalCodesCount = {
                    description = "Wie viele Kandidaten-Codes für den Elektrik-Kasten erzeugt werden.",
                    label = "Anzahl der Codes",
                },
                jailElectricalEnabled = {
                    description = "Aktiviert das Ausbruchs-Minispiel am Gefängnis-Elektrik-Kasten.",
                    label = "Elektrik-Kasten",
                },
                jailElectricalPinLength = {
                    description = "Anzahl der Ziffern, die für PIN-Codes des Elektrik-Kastens verwendet werden.",
                    label = "PIN-Länge",
                },
                jailElectricalPropModel = {
                    description = "Welt-Prop-Modell, das für den Gefängnis-Elektrik-Kasten verwendet wird.",
                    label = "Prop-Modell",
                },
                jailElectricalShockDamage = {
                    description = "Schaden, der entsteht, wenn ein Häftling die Elektrik-Sequenz nicht besteht.",
                    label = "Stromschlag-Schaden",
                },
                jailElectricalShockRagdollMs = {
                    description = "Millisekunden im Ragdoll-Zustand nach einem Stromschlag.",
                    label = "Stromschlag-Ragdoll",
                },
                jailElectricalSuccessReduceMinutes = {
                    description = "Haftminuten, die nach einem erfolgreichen Elektrik-Ausbruchsversuch abgezogen werden.",
                    label = "Minuten bei Erfolg reduzieren",
                },
                jailInmateAlcoholicRequiredAmount = {
                    description = "Menge, die für den Handel mit dem alkoholkranken Häftling benötigt wird.",
                    label = "Benötigte Menge",
                },
                jailInmateAlcoholicRequiredItem = {
                    description = "Gegenstand, der für den Handel mit dem alkoholkranken Häftling benötigt wird.",
                    label = "Benötigter Gegenstand",
                },
                jailInmateAlcoholicRewardAmount = {
                    description = "Belohnungsmenge für den Handel mit dem alkoholkranken Häftling.",
                    label = "Belohnungsmenge",
                },
                jailInmateAlcoholicRewardItem = {
                    description = "Belohnungsgegenstand für den Handel mit dem alkoholkranken Häftling.",
                    label = "Belohnungsgegenstand",
                },
                jailInmateAlcoholicRewardLabel = {
                    description = "Belohnungsbezeichnung, die für den Handel mit dem alkoholkranken Häftling angezeigt wird.",
                    label = "Belohnungsbezeichnung",
                },
                jailInmateCodeListRequiredAmount = {
                    description = "Menge, die für den Handel mit dem Informanten-Häftling benötigt wird.",
                    label = "Benötigte Menge",
                },
                jailInmateCodeListRequiredItem = {
                    description = "Gegenstand, der für den Handel mit dem Informanten-Häftling benötigt wird.",
                    label = "Benötigter Gegenstand",
                },
                jailInmateCodeListRewardAmount = {
                    description = "Belohnungsmenge für den Handel mit dem Informanten-Häftling.",
                    label = "Belohnungsmenge",
                },
                jailInmateCodeListRewardItem = {
                    description = "Belohnungsgegenstand für den Handel mit dem Informanten-Häftling.",
                    label = "Belohnungsgegenstand",
                },
                jailInmateCodeListRewardLabel = {
                    description = "Belohnungsbezeichnung, die für den Handel mit dem Informanten-Häftling angezeigt wird.",
                    label = "Belohnungsbezeichnung",
                },
                jailInmateDrugDealerAcceptedItems = {
                    description = "Akzeptierte Gegenstände für den Handel mit dem Drogendealer-Häftling.",
                    label = "Akzeptierte Gegenstände",
                },
                jailInmateDrugDealerRequiredAmount = {
                    description = "Menge, die für den Handel mit dem Drogendealer-Häftling benötigt wird.",
                    label = "Benötigte Menge",
                },
                jailInmateDrugDealerRewardAmount = {
                    description = "Belohnungsmenge für den Handel mit dem Drogendealer-Häftling.",
                    label = "Belohnungsmenge",
                },
                jailInmateDrugDealerRewardItem = {
                    description = "Belohnungsgegenstand für den Handel mit dem Drogendealer-Häftling.",
                    label = "Belohnungsgegenstand",
                },
                jailInmateDrugDealerRewardLabel = {
                    description = "Belohnungsbezeichnung, die für den Handel mit dem Drogendealer-Häftling angezeigt wird.",
                    label = "Belohnungsbezeichnung",
                },
                jailInmateDrugDealerUseCleaningContraband = {
                    description = "Erlaubt, dass während der Gefängnisreinigung gefundene Konterbande für den Handel mit dem Drogendealer-Häftling zählt.",
                    label = "Reinigungs-Konterbande verwenden",
                },
                jailInmateWireCutterRequiredAmount = {
                    description = "Menge, die für den Handel mit dem Werkzeugträger-Häftling benötigt wird.",
                    label = "Benötigte Menge",
                },
                jailInmateWireCutterRequiredItem = {
                    description = "Gegenstand, der für den Handel mit dem Werkzeugträger-Häftling benötigt wird.",
                    label = "Benötigter Gegenstand",
                },
                jailInmateWireCutterRewardAmount = {
                    description = "Belohnungsmenge für den Handel mit dem Werkzeugträger-Häftling.",
                    label = "Belohnungsmenge",
                },
                jailInmateWireCutterRewardItem = {
                    description = "Belohnungsgegenstand für den Handel mit dem Werkzeugträger-Häftling.",
                    label = "Belohnungsgegenstand",
                },
                jailInmateWireCutterRewardLabel = {
                    description = "Belohnungsbezeichnung, die für den Handel mit dem Werkzeugträger-Häftling angezeigt wird.",
                    label = "Belohnungsbezeichnung",
                },
                jailJobsCarryBoxModel = {
                    description = "Prop-Modell, das für die Kiste des Tragejobs im Gefängnis verwendet wird.",
                    label = "Trage-Kisten-Modell",
                },
                jailJobsCarryDropoffKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Gefängnisarbeit: abgeben",
                },
                jailJobsCarryDropoffRadius = {
                    description = "Abgaberadius für den Tragejob im Gefängnis.",
                    label = "Abgaberadius",
                },
                jailJobsCarryInspectKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Gefängnisarbeit: untersuchen",
                },
                jailJobsCarryInspectionJunkItems = {
                    description = "Wertlose Gegenstände, die beim Inspizieren von Kisten des Tragejobs gefunden werden können.",
                    label = "Wertlose Inspektionsgegenstände",
                },
                jailJobsCarryInspectionUsableChance = {
                    description = "Chance auf eine nützliche Belohnung beim Inspizieren von Kisten.",
                    label = "Chance auf nützliche Beute",
                },
                jailJobsCarryInspectionUsableItems = {
                    description = "Nützliche Gegenstände, die beim Inspizieren von Kisten des Tragejobs gefunden werden können.",
                    label = "Nützliche Inspektionsgegenstände",
                },
                jailJobsCarryInteractDistance = {
                    description = "Interaktionsdistanz für den Tragejob im Gefängnis.",
                    label = "Trage-Interaktionsdistanz",
                },
                jailJobsCarryMaxDistance = {
                    description = "Maximal erlaubte Distanz für den Fortschritt des Tragejobs im Gefängnis.",
                    label = "Trage-Maximaldistanz",
                },
                jailJobsCarryPickupKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Gefängnisarbeit: aufnehmen",
                },
                jailJobsCarryPickupOffset = {
                    description = "Versatzobjekt, das für den Aufhebepunkt des Tragejobs verwendet wird.",
                    label = "Aufhebe-Versatz",
                },
                jailJobsCarryTimeReduction = {
                    description = "Haftverkürzung für das Abschließen des Tragejobs im Gefängnis.",
                    label = "Trage-Zeitverkürzung",
                },
                jailJobsCleaningDumpsterKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Reinigung: entsorgen",
                },
                jailJobsCleaningDumpsterModel = {
                    description = "Modell, das für das Gefängnis-Mülleimer-Prop verwendet wird.",
                    label = "Mülleimer-Modell",
                },
                jailJobsCleaningIllegalFindChance = {
                    description = "Chance, während der Reinigung Konterbande zu finden.",
                    label = "Chance auf illegalen Fund",
                },
                jailJobsCleaningIllegalFindItems = {
                    description = "Gegenstände, die während der Reinigung im Gefängnis gefunden werden können.",
                    label = "Gegenstände für illegale Funde",
                },
                jailJobsCleaningIllegalFindPromptTimeoutMs = {
                    description = "Timeout für Abfragen bei illegalen Funden in Millisekunden.",
                    label = "Timeout für Fund-Abfrage",
                },
                jailJobsCleaningInteractDistance = {
                    description = "Distanz, die für die Interaktion mit Reinigungsmüll verwendet wird.",
                    label = "Reinigungs-Interaktionsdistanz",
                },
                jailJobsCleaningMaxDistance = {
                    description = "Maximale Distanz, bevor Reinigungs-Props zurückgesetzt werden oder verschwinden.",
                    label = "Reinigung Maximaldistanz",
                },
                jailJobsCleaningMaxTrashProps = {
                    description = "Maximale gleichzeitige Müllprops für die Gefängnisreinigung.",
                    label = "Maximale Müllprops",
                },
                jailJobsCleaningMinSpawnRadius = {
                    description = "Minimale Distanz vom Zentrum für Reinigungs-Müllspawns.",
                    label = "Mindest-Spawnradius",
                },
                jailJobsCleaningPickupKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Reinigung: aufnehmen",
                },
                jailJobsCleaningSpawnIntervalMs = {
                    description = "Millisekunden zwischen den Spawnversuchen von Reinigungsmüll.",
                    label = "Müll-Spawnintervall",
                },
                jailJobsCleaningSpawnRadius = {
                    description = "Radius, der zum Erzeugen von Reinigungs-Müllprops verwendet wird.",
                    label = "Müll-Spawnradius",
                },
                jailJobsCleaningTrashModels = {
                    description = "Müll-Prop-Modelle, die für den Gefängnis-Reinigungsjob verwendet werden.",
                    itemLabel = "Modell",
                    label = "Müllmodelle",
                },
                jailJobsCleaningTrashOutlineColor = {
                    description = "RGBA-Umrandungsfarbe, die für Gefängnis-Reinigungsmüllprops verwendet wird.",
                    label = "Umrandungsfarbe",
                },
                jailJobsCleaningTrashOutlineEnabled = {
                    description = "Aktiviert Umrandungen an Gefängnis-Reinigungsmüllprops.",
                    label = "Müll-Umrandung",
                },
                jailJobsCleaningTrashOutlineShader = {
                    description = "Shader-ID, die für Umrandungen des Gefängnis-Reinigungsmülls verwendet wird.",
                    label = "Umrandungs-Shader",
                },
                jailJobsTimeReduction = {
                    description = "Haftverkürzung für das Abschließen des Reinigungsjobs im Gefängnis.",
                    label = "Reinigungs-Zeitverkürzung",
                },
                jailJobsTrashGoal = {
                    description = "Anzahl der benötigten Müllteile, um den Reinigungsjob im Gefängnis abzuschließen.",
                    label = "Müll-Reinigungsziel",
                },
                jailMaxMonths = {
                    description = "Maximal wählbare Haftdauer.",
                    label = "Höchstmonate",
                },
                jailMinMonths = {
                    description = "Minimal wählbare Haftdauer.",
                    label = "Mindestmonate",
                },
                jailMonthMinutes = {
                    description = "Echtzeit-Minuten, die einem Gefängnismonat entsprechen.",
                    label = "Minuten pro Monat",
                },
                jailObjectStreamDistance = {
                    description = "Distanz, die für das Streaming dauerhafter Gefängnis-Weltobjekte verwendet wird.",
                    label = "Objekt-Streamdistanz",
                },
                jailOutfitApplyDelayMs = {
                    description = "Verzögerung nach dem Beitritt, bevor das Gefängnis-Outfit angelegt wird.",
                    label = "Outfit-Verzögerung",
                },
                jailOutfitEnabled = {
                    description = "Aktiviert Gefängnis-Outfits.",
                    label = "Gefängnis-Outfit",
                },
                jailOutfitFemaleArms = {
                    description = "Arm-Komponente des weiblichen Gefängnis-Outfits.",
                    label = "Arme",
                },
                jailOutfitFemaleChain1 = {
                    description = "Ketten-Drawable des weiblichen Gefängnis-Outfits.",
                    label = "Kette 1",
                },
                jailOutfitFemaleChain2 = {
                    description = "Ketten-Textur des weiblichen Gefängnis-Outfits.",
                    label = "Kette 2",
                },
                jailOutfitFemaleDecals1 = {
                    description = "Aufkleber-Drawable des weiblichen Gefängnis-Outfits.",
                    label = "Aufkleber 1",
                },
                jailOutfitFemaleDecals2 = {
                    description = "Aufkleber-Textur des weiblichen Gefängnis-Outfits.",
                    label = "Aufkleber 2",
                },
                jailOutfitFemaleGlasses1 = {
                    description = "Brillen-Drawable des weiblichen Gefängnis-Outfits (-1 entfernt die Brille).",
                    label = "Brille 1",
                },
                jailOutfitFemaleGlasses2 = {
                    description = "Brillen-Textur des weiblichen Gefängnis-Outfits.",
                    label = "Brille 2",
                },
                jailOutfitFemaleHelmet1 = {
                    description = "Helm-Drawable des weiblichen Gefängnis-Outfits.",
                    label = "Helm 1",
                },
                jailOutfitFemaleHelmet2 = {
                    description = "Helm-Textur des weiblichen Gefängnis-Outfits.",
                    label = "Helm 2",
                },
                jailOutfitFemalePants1 = {
                    description = "Hosen-Drawable des weiblichen Gefängnis-Outfits.",
                    label = "Hose 1",
                },
                jailOutfitFemalePants2 = {
                    description = "Hosen-Textur des weiblichen Gefängnis-Outfits.",
                    label = "Hose 2",
                },
                jailOutfitFemaleShoes1 = {
                    description = "Schuh-Drawable des weiblichen Gefängnis-Outfits.",
                    label = "Schuhe 1",
                },
                jailOutfitFemaleShoes2 = {
                    description = "Schuh-Textur des weiblichen Gefängnis-Outfits.",
                    label = "Schuhe 2",
                },
                jailOutfitFemaleTorso1 = {
                    description = "Oberkörper-Drawable des weiblichen Gefängnis-Outfits.",
                    label = "Oberkörper 1",
                },
                jailOutfitFemaleTorso2 = {
                    description = "Oberkörper-Textur des weiblichen Gefängnis-Outfits.",
                    label = "Oberkörper 2",
                },
                jailOutfitFemaleTshirt1 = {
                    description = "T-Shirt-Drawable des weiblichen Gefängnis-Outfits.",
                    label = "T-Shirt 1",
                },
                jailOutfitFemaleTshirt2 = {
                    description = "T-Shirt-Textur des weiblichen Gefängnis-Outfits.",
                    label = "T-Shirt 2",
                },
                jailOutfitMaleArms = {
                    description = "Arm-Komponente des männlichen Gefängnis-Outfits.",
                    label = "Arme",
                },
                jailOutfitMaleChain1 = {
                    description = "Ketten-Drawable des männlichen Gefängnis-Outfits.",
                    label = "Kette 1",
                },
                jailOutfitMaleChain2 = {
                    description = "Ketten-Textur des männlichen Gefängnis-Outfits.",
                    label = "Kette 2",
                },
                jailOutfitMaleDecals1 = {
                    description = "Aufkleber-Drawable des männlichen Gefängnis-Outfits.",
                    label = "Aufkleber 1",
                },
                jailOutfitMaleDecals2 = {
                    description = "Aufkleber-Textur des männlichen Gefängnis-Outfits.",
                    label = "Aufkleber 2",
                },
                jailOutfitMaleGlasses1 = {
                    description = "Brillen-Drawable des männlichen Gefängnis-Outfits (-1 entfernt die Brille).",
                    label = "Brille 1",
                },
                jailOutfitMaleGlasses2 = {
                    description = "Brillen-Textur des männlichen Gefängnis-Outfits.",
                    label = "Brille 2",
                },
                jailOutfitMaleHelmet1 = {
                    description = "Helm-Drawable des männlichen Gefängnis-Outfits.",
                    label = "Helm 1",
                },
                jailOutfitMaleHelmet2 = {
                    description = "Helm-Textur des männlichen Gefängnis-Outfits.",
                    label = "Helm 2",
                },
                jailOutfitMalePants1 = {
                    description = "Hosen-Drawable des männlichen Gefängnis-Outfits.",
                    label = "Hose 1",
                },
                jailOutfitMalePants2 = {
                    description = "Hosen-Textur des männlichen Gefängnis-Outfits.",
                    label = "Hose 2",
                },
                jailOutfitMaleShoes1 = {
                    description = "Schuh-Drawable des männlichen Gefängnis-Outfits.",
                    label = "Schuhe 1",
                },
                jailOutfitMaleShoes2 = {
                    description = "Schuh-Textur des männlichen Gefängnis-Outfits.",
                    label = "Schuhe 2",
                },
                jailOutfitMaleTorso1 = {
                    description = "Oberkörper-Drawable des männlichen Gefängnis-Outfits.",
                    label = "Oberkörper 1",
                },
                jailOutfitMaleTorso2 = {
                    description = "Oberkörper-Textur des männlichen Gefängnis-Outfits.",
                    label = "Oberkörper 2",
                },
                jailOutfitMaleTshirt1 = {
                    description = "T-Shirt-Drawable des männlichen Gefängnis-Outfits.",
                    label = "T-Shirt 1",
                },
                jailOutfitMaleTshirt2 = {
                    description = "T-Shirt-Textur des männlichen Gefängnis-Outfits.",
                    label = "T-Shirt 2",
                },
                jailRemoveJobOnJail = {
                    description = "Setzt den Gefangenen bei der Inhaftierung auf arbeitslos.",
                    label = "Job bei Inhaftierung entfernen",
                },
                jailRequireJailTerminal = {
                    description = "Haftstrafen durch Beamte nur in der Nähe eines Terminals des ausgewählten Gefängnisses erlauben.",
                    label = "Gefängnis-Terminal erforderlich",
                },
                jailRestoreOriginalJobOnRelease = {
                    description = "Stellt den ursprünglichen Job des Gefangenen nach der Entlassung wieder her. Deaktivieren, damit er arbeitslos bleibt.",
                    label = "Ursprünglichen Job wiederherstellen",
                },
                jailRestoreOutfitOnBreakout = {
                    description = "Stellt das gespeicherte zivile Outfit wieder her, wenn ein Häftling ausbricht.",
                    label = "Outfit bei Ausbruch wiederherstellen",
                },
                jailRestoreSpawnCorrectionMs = {
                    description = "Zeitfenster nach der Wiederherstellung, bevor die Spawn-Korrektur nicht mehr greift.",
                    label = "Wiederherstellungs-Korrekturfenster",
                },
                jailTeleportRestoreOutsideZone = {
                    description = "Teleportiert wiederhergestellte Häftlinge zurück zum Gefängnis-Spawn, wenn sie außerhalb der Gefängniszone laden.",
                    label = "Wiederhergestellte Häftlinge teleportieren",
                },
                jailTerminalRange = {
                    description = "Maximale Distanz des Beamten zu einem Terminal des ausgewählten Gefängnisses.",
                    label = "Gefängnis-Terminal-Reichweite",
                },
                jailZoneExitGraceMs = {
                    description = "Zeitfenster, bevor ein Verlassen der Gefängniszone als Ausbruch zählt.",
                    label = "Zonenausgangs-Toleranz",
                },
                mugshotAnimDict = {
                    description = "Anim Dict, das während der Haftfoto-Aufnahme verwendet wird.",
                    label = "Anim Dict",
                },
                mugshotAnimFlag = {
                    description = "Animations-Flag, das während der Haftfoto-Aufnahme verwendet wird.",
                    label = "Animations-Flag",
                },
                mugshotAnimName = {
                    description = "Animationsname, der während der Haftfoto-Aufnahme verwendet wird.",
                    label = "Animationsname",
                },
                mugshotBoardHeader = {
                    description = "Haupttitel, der auf der Haftfoto-Tafel angezeigt wird.",
                    label = "Tafel-Kopfzeile",
                },
                mugshotBoardSubheader = {
                    description = "Ausweich-Unterzeile, die auf der Haftfoto-Tafel angezeigt wird.",
                    label = "Tafel-Unterzeile",
                },
                mugshotCameraCoordsX = {
                    description = "Welt-X-Koordinate der Kamera für Haftfotos.",
                    label = "Kamera X",
                },
                mugshotCameraCoordsY = {
                    description = "Welt-Y-Koordinate der Kamera für Haftfotos.",
                    label = "Kamera Y",
                },
                mugshotCameraCoordsZ = {
                    description = "Welt-Z-Koordinate der Kamera für Haftfotos.",
                    label = "Kamera Z",
                },
                mugshotCameraFov = {
                    description = "Sichtfeld, das für Haftfoto-Aufnahmen verwendet wird.",
                    label = "Kamera-Sichtfeld",
                },
                mugshotCameraRotX = {
                    description = "Kamerarotation X, die für Haftfotos verwendet wird.",
                    label = "Drehung X",
                },
                mugshotCameraRotY = {
                    description = "Kamerarotation Y, die für Haftfotos verwendet wird.",
                    label = "Drehung Y",
                },
                mugshotCameraRotZ = {
                    description = "Kamerarotation Z, die für Haftfotos verwendet wird.",
                    label = "Drehung Z",
                },
                mugshotCaptureTimeout = {
                    description = "Maximale Millisekunden, die für Haftfoto-Aufnahme-Callbacks erlaubt sind.",
                    label = "Aufnahme-Timeout",
                },
                mugshotEnabled = {
                    description = "Aktiviert die Aufnahme von Haftfotos bei der Gefängnisaufnahme.",
                    label = "Haftfoto-Aufnahme",
                },
                mugshotHeading = {
                    description = "Ausrichtung, die bei der Haftfoto-Aufnahme angewendet wird.",
                    label = "Ausrichtung",
                },
                mugshotLocationX = {
                    description = "Welt-X-Koordinate, die für die Haftfoto-Aufnahme verwendet wird.",
                    label = "Position X",
                },
                mugshotLocationY = {
                    description = "Welt-Y-Koordinate, die für die Haftfoto-Aufnahme verwendet wird.",
                    label = "Position Y",
                },
                mugshotLocationZ = {
                    description = "Welt-Z-Koordinate, die für die Haftfoto-Aufnahme verwendet wird.",
                    label = "Position Z",
                },
                mugshotMetadataDescriptionFormat = {
                    description = "Beschreibungsformat, das für die gespeicherten Haftfoto-Metadaten verwendet wird.",
                    label = "Metadaten-Beschreibung",
                },
                mugshotMetadataName = {
                    description = "Name der Inventar-Metadaten, der für das gespeicherte Haftfoto verwendet wird.",
                    label = "Metadaten-Name",
                },
                mugshotWaitMs = {
                    description = "Millisekunden, die vor der Aufnahme des Haftfotos gewartet wird.",
                    label = "Wartezeit in Millisekunden",
                },
                playerSearchAnimDict = {
                    description = "Anim Dict, das während Durchsuchungen verwendet wird.",
                    label = "Anim Dict",
                },
                playerSearchAnimFlag = {
                    description = "Animations-Flag, das während Durchsuchungen verwendet wird.",
                    label = "Animations-Flag",
                },
                playerSearchAnimName = {
                    description = "Animationsname, der während Durchsuchungen verwendet wird.",
                    label = "Animationsname",
                },
                playerSearchDurationMs = {
                    description = "Dauer der Durchsuchungsvorschau in Millisekunden.",
                    label = "Durchsuchungsdauer",
                },
                playerSearchEnabled = {
                    description = "Aktiviert den Ablauf der Durchsuchungsvorschau.",
                    label = "Durchsuchung",
                },
                playerSearchRange = {
                    description = "Maximale Distanz, um eine Durchsuchung zu beginnen.",
                    label = "Durchsuchungsreichweite",
                },
                playerSearchScenario = {
                    description = "Szenario, das verwendet wird, wenn keine explizite Durchsuchungsanimation abgespielt wird.",
                    label = "Durchsuchungs-Szenario",
                },
                policeBillingControl200 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Rechnungen · ESCAPE",
                },
                policeBillingControl322 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Rechnungen · ESCAPE",
                },
                policeEditorControl10 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · PAGEUP",
                },
                policeEditorControl11 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · PAGEDOWN",
                },
                policeEditorControl172 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · UP",
                },
                policeEditorControl173 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · DOWN",
                },
                policeEditorControl174 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · LEFT",
                },
                policeEditorControl175 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · RIGHT",
                },
                policeEditorControl177 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · BACK",
                },
                policeEditorControl191 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · RETURN",
                },
                policeEditorControl201 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · RETURN",
                },
                policeEditorControl202 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · ESCAPE",
                },
                policeEditorControl21 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · LSHIFT",
                },
                policeEditorControl32 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · W",
                },
                policeEditorControl322 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · ESCAPE",
                },
                policeEditorControl33 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · S",
                },
                policeEditorControl34 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · A",
                },
                policeEditorControl35 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · D",
                },
                policeEditorControl36 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · LCONTROL",
                },
                policeEditorControl37 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · TAB",
                },
                policeEditorControl38 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · E",
                },
                policeEditorControl44 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · Q",
                },
                policeEditorControl73 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · X",
                },
                policePrimaryColor = {
                    description = "Standardfarbe für die Polizei-Jobgruppe.",
                    label = "Primärfarbe",
                },
                primaryColor = {
                    description = "Standardfarbe für die Polizei-Jobgruppe.",
                    label = "Primärfarbe",
                },
                propPlacementConsumeItem = {
                    description = "Entfernt einen Inventargegenstand, wenn ein Prop aus dem Inventar platziert wird.",
                    label = "Prop-Gegenstand verbrauchen",
                },
                propPlacementEnabled = {
                    description = "Erlaubt das Platzieren konfigurierter Polizei-Props aus Gegenständen oder Fahrzeugen.",
                    label = "Prop-Platzierung",
                },
                propPlacementItemNames = {
                    description = "Ordnet Prop-Modelle Inventar-Gegenstandsnamen für die gegenstandsbasierte Prop-Platzierung zu.",
                    label = "Prop-Gegenstandsnamen",
                },
                propPlacementRequireOnDuty = {
                    description = "Nur Beamte im Dienst können konfigurierte Props platzieren.",
                    label = "Props erfordern Dienst",
                },
                propPlacementReturnItem = {
                    description = "Gibt den verbrauchten Gegenstand zurück, wenn ein platziertes Prop entfernt wird.",
                    label = "Prop-Gegenstand zurückgeben",
                },
                propPlacementVehicleAccess = {
                    description = "Erlaubt Jobfahrzeugen, ihre konfigurierte Prop-Ausstattung bereitzustellen.",
                    label = "Fahrzeug-Prop-Zugriff",
                },
                radialEnabled = {
                    description = "Aktiviert die Radialaktionen der Polizei.",
                    label = "Polizei-Radialmenü",
                },
                radialHandcuffKeybindCommand = {
                    description = "Befehlsname, der für die Fesseln-Taste registriert wird.",
                    label = "Fesseln-Befehl",
                },
                radialHandcuffKeybindDescription = {
                    description = "Beschreibung, die für die Fesseln-Taste angezeigt wird.",
                    label = "Fesseln-Beschreibung",
                },
                radialHandcuffKeybindEnabled = {
                    description = "Aktiviert die direkte Taste zum Anlegen von Handschellen.",
                    label = "Fesseln-Taste",
                },
                radialHandcuffKeybindKey = {
                    description = "Tastaturtaste, die für das direkte Anlegen von Handschellen verwendet wird.",
                    label = "Fesseln-Taste (Taste)",
                },
                radialKeybindsEnabled = {
                    description = "Aktiviert direkte Tastenbelegungen für ausgewählte Radialaktionen.",
                    label = "Direkte Tastenbelegungen",
                },
                radialUnhandcuffKeybindCommand = {
                    description = "Befehlsname, der für die Entfesseln-Taste registriert wird.",
                    label = "Entfesseln-Befehl",
                },
                radialUnhandcuffKeybindDescription = {
                    description = "Beschreibung, die für die Entfesseln-Taste angezeigt wird.",
                    label = "Entfesseln-Beschreibung",
                },
                radialUnhandcuffKeybindEnabled = {
                    description = "Aktiviert die direkte Taste zum Entfernen von Handschellen.",
                    label = "Entfesseln-Taste",
                },
                radialUnhandcuffKeybindKey = {
                    description = "Tastaturtaste, die für das direkte Entfernen von Handschellen verwendet wird.",
                    label = "Entfesseln-Taste (Taste)",
                },
                socialWorkAssignRange = {
                    description = "Maximale Distanz, um Sozialarbeitsaufgaben zuzuweisen.",
                    label = "Zuweisungsreichweite",
                },
                socialWorkDeadlineDefault = {
                    description = "Standardfrist der Sozialarbeit in Minuten. Null deaktiviert Fristen.",
                    label = "Standardfrist",
                },
                socialWorkDeadlineMax = {
                    description = "Höchstfrist der Sozialarbeit in Minuten. Null deaktiviert die Obergrenze.",
                    label = "Höchstfrist",
                },
                socialWorkDeadlineMin = {
                    description = "Mindestfrist der Sozialarbeit in Minuten.",
                    label = "Mindestfrist",
                },
                socialWorkDefaultTasks = {
                    description = "Standard-Aufgabenanzahl beim Öffnen der Sozialarbeitszuweisung.",
                    label = "Standardaufgaben",
                },
                socialWorkEnabled = {
                    description = "Aktiviert die Zuweisung und Aufgabenabläufe der Sozialarbeit.",
                    label = "Sozialarbeit",
                },
                socialWorkImprisonmentJailId = {
                    description = "Gefängnis-ID, die verwendet wird, wenn Verstöße bei der Sozialarbeit zu Inhaftierung führen.",
                    label = "Ausweich-Gefängnis-ID",
                },
                socialWorkImprisonmentMonths = {
                    description = "Monate, die zugewiesen werden, wenn Verstöße bei der Sozialarbeit zu Gefängnis führen.",
                    label = "Inhaftierungsmonate",
                },
                socialWorkImprisonmentOfficerName = {
                    description = "Beamtenname, der für Inhaftierungseinträge der Sozialarbeit verwendet wird.",
                    label = "Beamtenname für Inhaftierung",
                },
                socialWorkImprisonmentSolitary = {
                    description = "Schickt Verstoßende bei Auslösen der Inhaftierung in Einzelhaft.",
                    label = "Einzelhaft verwenden",
                },
                socialWorkInactivityMinutes = {
                    description = "Minuten, bevor Strafen wegen Inaktivität bei der Sozialarbeit greifen.",
                    label = "Inaktivitätsminuten",
                },
                socialWorkInactivityTaskPenalty = {
                    description = "Aufgabenstrafe, die angewendet wird, wenn ein Sozialarbeiter zu lange inaktiv bleibt.",
                    label = "Inaktivitäts-Aufgabenstrafe",
                },
                socialWorkMaxTasks = {
                    description = "Maximal wählbare Sozialarbeitsaufgaben.",
                    label = "Höchstaufgaben",
                },
                socialWorkMinTasks = {
                    description = "Minimal wählbare Sozialarbeitsaufgaben.",
                    label = "Mindestaufgaben",
                },
                speedCamAdvancedAllowFakePlateApproval = {
                    description = "Erlaubt Rechnungen an den registrierten Halter, obwohl das Kennzeichen als falsch oder geklont markiert ist.",
                    label = "Verdächtige Kennzeichen erlauben",
                },
                speedCamProcessingMode = {
                    description = "Sofort abbuchen, eine Rechnung mit Zahlungsfrist erstellen oder die Aufnahme zur Prüfung durch Beamte speichern. Später bezahlen nutzt die konfigurierte Zahlungsfrist.",
                    label = "Verarbeitung",
                    options = {
                        instant = "Sofort abbuchen",
                        later = "Später bezahlen (Standard)",
                        review = "Nur Prüfung durch Beamte",
                    },
                },
                speedCamAdvancedPageSize = {
                    description = "Maximale Anzahl Aufnahmen pro Tablet-Seite.",
                    label = "Seitengröße der Prüfung",
                },
                speedCamAdvancedRecognizedSides = {
                    description = "Fahrzeugseiten, deren Fotos zur Kennzeichenerkennung verwendet werden. Erlaubt sind front und rear.",
                    itemLabel = "Seite",
                    label = "Erkannte Seiten",
                },
                speedCamAdvancedRequireEvidence = {
                    description = "Erlaubt die Freigabe erst nach abgeschlossenem Upload des Blitzerfotos.",
                    label = "Beweisfoto erforderlich",
                },
                speedCamAdvancedReviewPermission = {
                    description = "Bossmenu-Berechtigung zum Freigeben oder Verwerfen. 18 entspricht Rechnungswesen verwalten.",
                    label = "Berechtigungs-ID für Prüfung",
                },
                speedCamAdvancedStoreUnregistered = {
                    description = "Behält Aufnahmen, deren Kennzeichen nicht in der Fahrzeugdatenbank registriert ist.",
                    label = "Nicht registrierte Fahrzeuge speichern",
                },
                speedCamBillingEnabled = {
                    description = "Stellt automatisch Rechnungen aus, wenn eine Blitzersäule ein passendes Vergehen erfasst. Erfordert die aktivierte globale Abrechnungsfunktion.",
                    label = "Automatische Bußgelder",
                },
                speedCamBillingExcludedJobs = {
                    description = "Jobs, die niemals automatische Blitzerrechnungen erhalten.",
                    itemLabel = "Beruf",
                    label = "Ausgenommene Jobs",
                },
                speedCamBillingExcludedModels = {
                    description = "Spawnnamen von Fahrzeugen, die niemals automatische Blitzerrechnungen erhalten.",
                    itemLabel = "Modell",
                    label = "Ausgenommene Fahrzeugmodelle",
                },
                speedCamBillingRules = {
                    description = "Bußgeldregeln, die von Blitzersäulen verwendet werden. Der am engsten passende Überschreitungsbereich wird zuerst abgerechnet; passt keine Regel, wird ersatzweise das Vergehen „Geschwindigkeitsüberschreitung“ verwendet.",
                    label = "Bußgeldregeln",
                },
                speedCamCameraEaseMs = {
                    description = "Wie lange die Ansicht in den Blitzersäulen-Winkel übergeht. Niedriger = kürzerer Schwenk; zu niedrig kann das Foto verschieben.",
                    label = "Kamera-Übergang (ms)",
                },
                speedCamCameraFov = {
                    description = "Sichtfeld, das für Blitzersäulen-Aufnahmen verwendet wird.",
                    label = "Kamera-Sichtfeld",
                },
                speedCamCheckIntervalMs = {
                    description = "Millisekunden zwischen den Scans der Blitzersäule.",
                    label = "Prüfintervall",
                },
                speedCamCooldownMs = {
                    description = "Millisekunden, bevor dieselbe Blitzersäule erneut auslösen kann.",
                    label = "Auslöse-Cooldown",
                },
                speedCamDamageCooldownMs = {
                    description = "Millisekunden, bevor Blitzersäulen-Schaden erneut zugefügt werden kann.",
                    label = "Schadens-Cooldown",
                },
                speedCamDamagePerHit = {
                    description = "Haltbarkeitsschaden, der Blitzersäulen pro Treffer zugefügt wird.",
                    label = "Schaden pro Treffer",
                },
                speedCamDamagedModelThreshold = {
                    description = "Prozentanteil der maximalen Haltbarkeit, bei dem oder darunter das beschädigte Modell angezeigt wird. Beispiel: 50 bei maximal 200 Haltbarkeit wechselt bei 100 Haltbarkeit.",
                    label = "Schwelle für beschädigtes Modell (%)",
                },
                speedCamDefaultLimit = {
                    description = "Standard-Geschwindigkeitslimit der Blitzersäule.",
                    label = "Standard-Geschwindigkeitslimit",
                },
                speedCamDefaultName = {
                    description = "Vorgeschlagener Anzeigename beim Aufstellen eines Blitzers. Dieser Name darf übersetzt werden und ändert weder das Inventar-Item noch das Prop-Modell.",
                    label = "Standardname",
                },
                speedCamDefaultTolerance = {
                    description = "Standardtoleranz der Blitzersäule.",
                    label = "Standardtoleranz",
                },
                speedCamDisassembleDistance = {
                    description = "Distanz, die zur Demontage von Blitzersäulen verwendet wird.",
                    label = "Demontagedistanz",
                },
                speedCamEnabled = {
                    description = "Aktiviert tragbare Blitzersäulen.",
                    label = "Blitzersäulen",
                },
                speedCamFlashColor = {
                    description = "RGBA-Blitzfarbe, die von Blitzersäulen verwendet wird.",
                    label = "Blitzfarbe",
                },
                speedCamFlashDurationMs = {
                    description = "Ausblendzeit des roten Blitzersäulen-Blitzes. Nicht zu niedrig einstellen, sonst wird die Kameraschwenkung sichtbar.",
                    label = "Blitzdauer (ms)",
                },
                speedCamHealthDisplayDistance = {
                    description = "Distanz, ab der der Zustand der Blitzersäule angezeigt wird.",
                    label = "Zustandsanzeige-Distanz",
                },
                speedCamHealthDisplayDurationMs = {
                    description = "Millisekunden, die der Zustand der Blitzersäule sichtbar bleibt.",
                    label = "Zustandsanzeige-Dauer",
                },
                speedCamHealthTextOffset = {
                    description = "Vertikaler Versatz, der für den Zustandstext der Blitzersäule verwendet wird.",
                    label = "Zustandstext-Versatz",
                },
                speedCamItem = {
                    description = "Exakter interner Itemname aus dem Inventar, z. B. speedcam. Den Item-Schlüssel eintragen, nicht den Anzeigenamen; der Jobshop muss dasselbe Item ausgeben.",
                    label = "Blitzer-Itemname",
                },
                speedCamMaintenanceThreshold = {
                    description = "Haltbarkeitsschwelle, ab der eine Wartung der Blitzersäule empfohlen wird.",
                    label = "Wartungsschwelle",
                },
                speedCamMaxDurability = {
                    description = "Maximale Haltbarkeit aufgestellter Blitzersäulen.",
                    label = "Max. Haltbarkeit",
                },
                speedCamMaxLimit = {
                    description = "Maximal konfigurierbares Geschwindigkeitslimit der Blitzersäule.",
                    label = "Maximales Geschwindigkeitslimit",
                },
                speedCamMaxTolerance = {
                    description = "Maximal konfigurierbare Toleranz der Blitzersäule.",
                    label = "Maximaltoleranz",
                },
                speedCamPhotoLocale = {
                    description = "Optionales Gebietsschema für den Zeitstempel auf Blitzerfotos. Leer lassen, um das lokale Gebietsschema des geblitzten Spielers zu verwenden.",
                    label = "Foto-Gebietsschema",
                },
                speedCamPhotoTimeZone = {
                    description = "Optionale Zeitzone für den Zeitstempel auf Blitzerfotos. Leer lassen, um die lokale Zeitzone des geblitzten Spielers zu verwenden.",
                    label = "Foto-Zeitzone",
                },
                speedCamPoliceNotification = {
                    description = "Sendet eine Dispatch-Benachrichtigung, wenn eine Blitzersäule einen Verstoß erfasst.",
                    label = "Blitzersäulen-Polizeialarm",
                },
                speedCamPoliceNotificationGroup = {
                    description = "Behandelt das Dispatch-Ziel der Blitzersäule als Jobgruppe.",
                    label = "Dispatch-Ziel ist Gruppe",
                },
                speedCamPoliceNotificationJob = {
                    description = "Job- oder Gruppenschlüssel, der für Dispatch-Benachrichtigungen der Blitzersäule verwendet wird.",
                    label = "Dispatch-Ziel",
                },
                speedCamPoliceNotificationRequireDuty = {
                    description = "Benachrichtigt nur Dispatch-Ziele der Blitzersäule, die im Dienst sind.",
                    label = "Dispatch erfordert Dienst",
                },
                speedCamPoliceNotificationType = {
                    description = "Dispatch-Schweregrad/-Typ, der für Blitzersäulen-Alarme verwendet wird.",
                    label = "Dispatch-Typ",
                },
                speedCamPropModel = {
                    description = "Spawnname des intakten Blitzer-Props, z. B. sky_speedcam. Eine Vorlage setzt auch die beschädigten und zerstörten Modelle. Eigene Modelle müssen im Spiel verfügbar sein.",
                    label = "Blitzersäulen-Prop-Modell",
                    custom = "Eigenes Modell",
                    choose = "Modell auswählen",
                    preview = "3D-Vorschau",
                    customPlaceholder = "Prop-Spawnname",
                    previewDescription = "Zeigt das ausgewählte Prop im Spiel. Die Vorschau speichert keine Änderungen.",
                    invalidModel = "Gib zuerst einen gültigen Prop-Spawnnamen ein.",
                    modelMissing = "Dieses Prop-Modell ist im Spiel nicht verfügbar.",
                    previewFailed = "Die Modellvorschau konnte nicht geöffnet werden.",
                    intact = "Intaktes Prop-Modell",
                    previewRequiresGame = "Öffne /jobconfig in FiveM, um das Prop live anzusehen.",
                    previewHelp = "Pfeiltasten bewegen, Bild auf/ab ändert die Höhe, Mausrad dreht, Enter schließt die Vorschau, Rücktaste bricht ab.",
                    options = {
                        sky_speedcam = "Standard-Blitzer",
                        sky_germ_speedcam = "Deutscher Blitzer",
                    },
                },
                speedCamPropModelDamaged = {
                    description = "Spawnname des beschädigten Blitzer-Props, z. B. sky_speedcam2. Eine zum intakten Modell passende Variante verwenden.",
                    label = "Beschädigtes Prop-Modell",
                },
                speedCamPropModelDestroyed = {
                    description = "Spawnname für einen Blitzer mit 0 Haltbarkeit, z. B. sky_speedcam1. Eine zum intakten Modell passende Variante verwenden.",
                    label = "Zerstörtes Prop-Modell",
                },
                speedCamRepairAnimDict = {
                    description = "Anim Dict, das bei der Reparatur von Blitzersäulen verwendet wird.",
                    label = "Reparatur-Anim Dict",
                },
                speedCamRepairAnimFlag = {
                    description = "Animations-Flag, das bei der Reparatur von Blitzersäulen verwendet wird.",
                    label = "Reparatur-Animations-Flag",
                },
                speedCamRepairAnimName = {
                    description = "Animationsname, der bei der Reparatur von Blitzersäulen verwendet wird.",
                    label = "Reparatur-Animationsname",
                },
                speedCamRepairCancelDelayMs = {
                    description = "Millisekunden, bevor eine Blitzersäulen-Reparatur abgebrochen werden kann.",
                    label = "Reparaturabbruch-Verzögerung",
                },
                speedCamRepairDistance = {
                    description = "Distanz, die zur Reparatur von Blitzersäulen verwendet wird.",
                    label = "Reparaturdistanz",
                },
                speedCamRepairItem = {
                    description = "Exakter interner Itemname für die Reparatur, z. B. fixtool. Den Item-Schlüssel eintragen, nicht den Anzeigenamen.",
                    label = "Reparatur-Itemname",
                },
                speedCamRepairPerTick = {
                    description = "Haltbarkeit, die pro Blitzersäulen-Reparaturtakt wiederhergestellt wird.",
                    label = "Reparatur pro Takt",
                },
                speedCamRepairTickMs = {
                    description = "Millisekunden zwischen den Reparaturtakten der Blitzersäule.",
                    label = "Reparaturtakt",
                },
                speedCamStreamDistance = {
                    description = "Entfernung zum Spieler in Metern, innerhalb derer Blitzer-Props geladen werden. Außerhalb werden die Props ausgeblendet; gespeicherte Blitzer bleiben aufgestellt.",
                    label = "Streamdistanz",
                },
                speedCamTriggerRadius = {
                    description = "Erfassungsradius in Metern um den Blitzer für Fahrzeuge mit überhöhter Geschwindigkeit.",
                    label = "Auslöseradius",
                },
                speedCamUseMph = {
                    description = "Zeigt und verarbeitet Blitzersäulen-Limits in MPH.",
                    label = "MPH verwenden",
                },
                speedCamWeaponDamageRestrictionAllowedWeapons = {
                    description = "Waffen, die Blitzersäulen beschädigen dürfen, solange die Einschränkung aktiviert ist.",
                    itemLabel = "Waffe",
                    label = "Erlaubte Waffen",
                },
                speedCamWeaponDamageRestrictionEnabled = {
                    description = "Nur gelistete Waffen können Blitzersäulen beschädigen, solange dies aktiviert ist.",
                    label = "Einschränkung aktiviert",
                },
                speedCameraAppClearDistanceMeters = {
                    description = "Distanz in Metern, bevor Blitzerwarnungen gelöscht werden.",
                    label = "Löschdistanz",
                },
                speedCameraAppDefaultApp = {
                    description = "Zeigt die Blitzer-App als Standard-Tablet-App an.",
                    label = "Standard-App",
                },
                speedCameraAppDescription = {
                    description = "Beschreibung, die für die Blitzer-Tablet-App angezeigt wird.",
                    label = "Beschreibung",
                },
                speedCameraAppDeveloper = {
                    description = "Entwicklerbezeichnung, die für die Blitzer-Tablet-App angezeigt wird.",
                    label = "Entwickler",
                },
                speedCameraAppEnabled = {
                    description = "Aktiviert die Blitzer-App auf dem Polizei-Tablet.",
                    label = "Blitzer-Tablet-App",
                },
                speedCameraAppHeaderEyebrow = {
                    description = "Kicker-Text der Kopfzeile, der in der Blitzer-App angezeigt wird.",
                    label = "Kopfzeile Kicker",
                },
                speedCameraAppHeaderTitle = {
                    description = "Kopfzeilentitel, der in der Blitzer-App angezeigt wird.",
                    label = "Kopfzeilentitel",
                },
                speedCameraAppIcon = {
                    description = "Icon-Pfad, der für die Blitzer-Tablet-App verwendet wird.",
                    label = "Icon-Pfad",
                },
                speedCameraAppIdentifier = {
                    description = "Interne Kennung für die Blitzer-Tablet-App.",
                    label = "Kennung",
                },
                speedCameraAppInFrontDot = {
                    description = "Skalarprodukt-Schwelle, die bestimmt, ob sich ein Blitzer vor dem Spieler befindet.",
                    label = "Vorne-Skalarprodukt",
                },
                speedCameraAppMinimumVehicleSpeedKmh = {
                    description = "Mindestgeschwindigkeit des Fahrzeugs in km/h, bevor Warnungen angezeigt werden.",
                    label = "Mindest-Fahrzeuggeschwindigkeit",
                },
                speedCameraAppName = {
                    description = "Anzeigename der Blitzer-Tablet-App.",
                    label = "App-Name",
                },
                speedCameraAppNotifyDistanceMeters = {
                    description = "Distanz in Metern, bevor über nahe Blitzer informiert wird.",
                    label = "Hinweisdistanz",
                },
                speedCameraAppOnlyInVehicle = {
                    description = "Warnt nur vor Blitzern, während sich der Spieler in einem Fahrzeug befindet.",
                    label = "Nur im Fahrzeug",
                },
                speedCameraAppOverlayBackground = {
                    description = "Hintergrundfarbe, die für das Kennzeichen-Overlay verwendet wird.",
                    label = "Overlay-Hintergrund",
                },
                speedCameraAppOverlayBorder = {
                    description = "Rahmenfarbe, die für das Kennzeichen-Overlay verwendet wird.",
                    label = "Overlay-Rahmen",
                },
                speedCameraAppOverlayColor = {
                    description = "Textfarbe, die für das Kennzeichen-Overlay verwendet wird.",
                    label = "Overlay-Farbe",
                },
                speedCameraAppOverlayEnabled = {
                    description = "Aktiviert Kennzeichen-Overlays auf aufgenommenen Blitzerbildern.",
                    label = "Overlay aktiviert",
                },
                speedCameraAppOverlayFontScale = {
                    description = "Schriftskalierung, die für das Kennzeichen-Overlay verwendet wird.",
                    label = "Overlay-Schriftskalierung",
                },
                speedCameraAppOverlayX = {
                    description = "Normalisierte Overlay-X-Position von links nach rechts.",
                    label = "Überlagerung X",
                },
                speedCameraAppOverlayY = {
                    description = "Normalisierte Overlay-Y-Position von oben nach unten.",
                    label = "Überlagerung Y",
                },
                speedCameraAppRequireInFront = {
                    description = "Warnt nur vor Blitzern, die sich vor dem Spieler befinden.",
                    label = "Nur vorne erforderlich",
                },
                speedCameraAppRoute = {
                    description = "Router-Pfad, der von der Blitzer-Tablet-App geöffnet wird.",
                    label = "Art der Anwendung",
                },
                speedCameraAppSize = {
                    description = "Gemeldete Speichergröße der Blitzer-Tablet-App.",
                    label = "App-Größe",
                },
                speedCameraAppSoundCoord = {
                    description = "Spielt Warntöne der Blitzer-App an Weltkoordinaten ab.",
                    label = "Koordinaten-Sound",
                },
                speedCameraAppSoundEnabled = {
                    description = "Aktiviert Warntöne für die Blitzer-App.",
                    label = "Sound aktiviert",
                },
                speedCameraAppSoundFrontend = {
                    description = "Spielt Warntöne der Blitzer-App über den Frontend-Audiokanal ab.",
                    label = "Frontend-Sound",
                },
                speedCameraAppSoundLayers = {
                    description = "Anzahl der überlagerten Warntöne, die von der Blitzer-App abgespielt werden.",
                    label = "Soundschichten",
                },
                speedCameraAppSoundName = {
                    description = "Soundname, der für Warnungen der Blitzer-App verwendet wird.",
                    label = "Soundname",
                },
                speedCameraAppSoundRange = {
                    description = "Reichweite, die für Warntöne der Blitzer-App verwendet wird.",
                    label = "Soundreichweite",
                },
                speedCameraAppSoundRepeatCount = {
                    description = "Anzahl der Wiederholungen des Blitzer-Warntons.",
                    label = "Wiederholungsanzahl",
                },
                speedCameraAppSoundRepeatDelayMs = {
                    description = "Millisekunden zwischen den Wiederholungen des Blitzer-Warntons.",
                    label = "Wiederholungsverzögerung",
                },
                speedCameraAppSoundSet = {
                    description = "Sound-Set, das für Warnungen der Blitzer-App verwendet wird.",
                    label = "Sound-Set",
                },
                speedCameraAppSubscriptionAccount = {
                    description = "Konto, das für Zahlungen des Blitzer-Tablet-App-Abos verwendet wird.",
                    label = "Konto",
                },
                speedCameraAppSubscriptionEnabled = {
                    description = "Aktiviert kostenpflichtige Abos für die Blitzer-Tablet-App.",
                    label = "Abo aktiviert",
                },
                speedCameraAppSubscriptionIntervalDays = {
                    description = "Tage zwischen den Verlängerungen des Blitzer-Tablet-App-Abos.",
                    label = "Intervall in Tagen",
                },
                speedCameraAppSubscriptionPrice = {
                    description = "Preis, der für das Abo der Blitzer-Tablet-App berechnet wird.",
                    label = "Abo-Preis",
                },
                speedCameraAppThemeAccent = {
                    description = "Akzentfarbe, die von der Blitzer-App verwendet wird.",
                    label = "Akzent",
                },
                speedCameraAppThemeBackground = {
                    description = "Linearer Verlaufshintergrund, der von der Blitzer-App verwendet wird.",
                    label = "Hintergrund",
                },
                speedCameraAppThemeBorder = {
                    description = "Rahmenfarbe, die von der Blitzer-App verwendet wird.",
                    label = "Rahmen",
                },
                speedCameraAppThemeButtonText = {
                    description = "Textfarbe der Schaltfläche, die von der Blitzer-App verwendet wird.",
                    label = "Schaltflächentext",
                },
                speedCameraAppThemeDanger = {
                    description = "Gefahrenfarbe, die von der Blitzer-App verwendet wird.",
                    label = "Gefahr",
                },
                speedCameraAppThemeGhost = {
                    description = "Farbe der Geist-Schaltfläche, die von der Blitzer-App verwendet wird.",
                    label = "Geist",
                },
                speedCameraAppThemeGhostText = {
                    description = "Textfarbe der Geist-Schaltfläche, die von der Blitzer-App verwendet wird.",
                    label = "Geist-Text",
                },
                speedCameraAppThemeGradientSoft = {
                    description = "Weiche Verlaufsfarbe, die von der Blitzer-App verwendet wird.",
                    label = "Weicher Verlauf",
                },
                speedCameraAppThemeInactiveBorder = {
                    description = "Farbe des inaktiven Rahmens, die von der Blitzer-App verwendet wird.",
                    label = "Inaktiver Rahmen",
                },
                speedCameraAppThemeModal = {
                    description = "Modal-Hintergrundfarbe, die von der Blitzer-App verwendet wird.",
                    label = "Veränderlich",
                },
                speedCameraAppThemeMutedText = {
                    description = "Gedämpfte Textfarbe, die von der Blitzer-App verwendet wird.",
                    label = "Gedämpfter Text",
                },
                speedCameraAppThemeOverlay = {
                    description = "Overlay-Farbe, die von der Blitzer-App verwendet wird.",
                    label = "Überlagerung",
                },
                speedCameraAppThemePillText = {
                    description = "Textfarbe der Pill-Beschriftung, die von der Blitzer-App verwendet wird.",
                    label = "Pill-Text",
                },
                speedCameraAppThemePrimaryFrom = {
                    description = "Startfarbe des primären Verlaufs, die von der Blitzer-App verwendet wird.",
                    label = "Primär von",
                },
                speedCameraAppThemePrimaryTo = {
                    description = "Endfarbe des primären Verlaufs, die von der Blitzer-App verwendet wird.",
                    label = "Primär bis",
                },
                speedCameraAppThemeShadow = {
                    description = "Schattenfarbe, die von der Blitzer-App verwendet wird.",
                    label = "Schatten",
                },
                speedCameraAppThemeSpotlight = {
                    description = "Spotlight-Akzentfarbe, die von der Blitzer-App verwendet wird.",
                    label = "Spotlight",
                },
                speedCameraAppThemeSubtleText = {
                    description = "Dezente Textfarbe, die von der Blitzer-App verwendet wird.",
                    label = "Dezenter Text",
                },
                speedCameraAppThemeSuccess = {
                    description = "Erfolgsfarbe, die von der Blitzer-App verwendet wird.",
                    label = "Erfolg",
                },
                speedCameraAppThemeSurface = {
                    description = "Flächenfarbe, die von der Blitzer-App verwendet wird.",
                    label = "Fläche",
                },
                speedCameraAppThemeSurfaceSoft = {
                    description = "Weiche Flächenfarbe, die von der Blitzer-App verwendet wird.",
                    label = "Weiche Fläche",
                },
                speedCameraAppThemeText = {
                    description = "Primäre Textfarbe, die von der Blitzer-App verwendet wird.",
                    label = "Wortlaut",
                },
                speedCameraAppWarningUiAccent = {
                    description = "RGBA-Akzentfarbe, die für die Blitzer-Warn-UI verwendet wird.",
                    label = "Akzent RGBA",
                },
                speedCameraAppWarningUiBackground = {
                    description = "RGBA-Farbe, die für den Hintergrund der Blitzer-Warn-UI verwendet wird.",
                    label = "Hintergrund RGBA",
                },
                speedCameraAppWarningUiIcon = {
                    description = "RGBA-Icon-Farbe, die für die Blitzer-Warn-UI verwendet wird.",
                    label = "Ikone RGBA",
                },
                speedCameraAppWarningUiIconText = {
                    description = "RGBA-Icon-Textfarbe, die für die Blitzer-Warn-UI verwendet wird.",
                    label = "Icon-Text RGBA",
                },
                speedCameraAppWarningUiSeconds = {
                    description = "Sekunden, die die Warn-UI sichtbar bleibt.",
                    label = "Warn-UI Sekunden",
                },
                speedCameraAppWarningUiSubText = {
                    description = "RGBA-Untertextfarbe, die für die Blitzer-Warn-UI verwendet wird.",
                    label = "Untertext RGBA",
                },
                speedCameraAppWarningUiText = {
                    description = "RGBA-Textfarbe, die für die Blitzer-Warn-UI verwendet wird.",
                    label = "Text RGBA",
                },
                speedCameraAppWarningUiTitle = {
                    description = "RGBA-Titelfarbe, die für die Blitzer-Warn-UI verwendet wird.",
                    label = "Titel RGBA",
                },
                spikeStripsCheckIntervalMs = {
                    description = "Millisekunden zwischen den Nähe-Prüfungen der Reifenstacheln.",
                    label = "Prüfintervall",
                },
                spikeStripsEnabled = {
                    description = "Aktiviert ausgelegte Reifenstacheln.",
                    label = "Reifenstacheln",
                },
                spikeStripsModels = {
                    description = "Prop-Modelle, die als aktive Reifenstacheln behandelt werden.",
                    itemLabel = "Modell",
                    label = "Modelle",
                },
                spikeStripsRetryIntervalMs = {
                    description = "Millisekunden, bevor das Scannen der Reifenstacheln nach keinem Treffer erneut versucht wird.",
                    label = "Wiederholungsintervall",
                },
                spikeStripsScanDistance = {
                    description = "Distanz, die zum Scannen nach nahen Reifenstacheln verwendet wird.",
                    label = "Scandistanz",
                },
                spikeStripsTriggerDistance = {
                    description = "Distanz, ab der Reifen durch einen Reifenstachel platzen.",
                    label = "Auslösedistanz",
                },
                stationCreatorBlipCategoryLabel = {
                    description = "Kategoriebezeichnung, die für Stations-Blips des Erstellers verwendet wird.",
                    label = "Stations-Blip-Kategorie",
                },
                stationCreatorBlipColor = {
                    description = "Blipfarbe, die für Polizeistationen verwendet wird.",
                    label = "Stations-Blip-Farbe",
                },
                stationCreatorBlipScale = {
                    description = "Größe, die für Polizeistations-Blips verwendet wird.",
                    label = "Stations-Blip-Größe",
                },
                stationCreatorBlipShortRange = {
                    description = "Stations-Blips nur auf kurze Entfernung anzeigen.",
                    label = "Stations-Blip Kurzreichweite",
                },
                stationCreatorBlipSprite = {
                    description = "Blip (Sprite), das für Polizeistationen verwendet wird.",
                    label = "Stations-Blip-Sprite",
                },
                stationCreatorBlipUseStationName = {
                    description = "Den konfigurierten Stationsnamen für die Blip-Beschriftung verwenden.",
                    label = "Stationsname verwenden",
                },
                tabletAutoFillCitizens = {
                    description = "Befüllt das Bürgerregister vorab aus der Framework-Datenbank.",
                    label = "Bürger automatisch befüllen",
                },
                tabletAutoFillVehicles = {
                    description = "Befüllt das Fahrzeugregister vorab aus der Framework-Datenbank.",
                    label = "Fahrzeuge automatisch befüllen",
                },
                tabletBolos = {
                    description = "Zeigt die Fahndungs-App (BOLO) an.",
                    label = "Fahndungen",
                },
                tabletCases = {
                    description = "Zeigt die Fälle-App an.",
                    label = "Fälle",
                },
                tabletCitizens = {
                    description = "Zeigt die Bürgerregister-App an.",
                    label = "Bürger",
                },
                tabletConfiscations = {
                    description = "Zeigt das Protokoll der bei Durchsuchungen beschlagnahmten Gegenstände.",
                    label = "Beschlagnahmungen",
                },
                tabletOffences = {
                    description = "Zeigt die Vergehen-App an.",
                    label = "Vergehen",
                },
                tabletPrison = {
                    description = "Zeigt die Gefängnis-App an.",
                    label = "Gefängnis",
                },
                tabletReportEnforcement = {
                    description = "Erlaubt das Zuordnen von Delikten sowie Geld- und Haftstrafen aus gespeicherten Berichten.",
                    label = "Berichts-Vollstreckung",
                },
                tabletReports = {
                    description = "Zeigt die Berichte-App an.",
                    label = "Berichte",
                },
                tabletSocialWork = {
                    description = "Zeigt die Sozialarbeits-App an.",
                    label = "Sozialarbeit",
                },
                tabletSpeedcamReviews = {
                    description = "Zeigt bei aktivem erweitertem Modus die App zur Prüfung von Blitzeraufnahmen an.",
                    label = "Blitzer-Prüfung",
                },
                tabletVehicles = {
                    description = "Zeigt die Fahrzeugregister-App an.",
                    label = "Fahrzeuge",
                },
                tabletWarrants = {
                    description = "Zeigt die Haftbefehls-App an.",
                    label = "Haftbefehle",
                },
                tabletWeapons = {
                    description = "Zeigt die Waffenregister-App an.",
                    label = "Waffen",
                },
                tackleCommand = {
                    description = "Befehl zum Zu-Boden-Bringen der nächsten Person. Befehlsname ohne Schrägstrich eingeben.",
                    label = "Befehl zum Zu-Boden-Bringen",
                },
                tackleCuffCommand = {
                    description = "Befehl zum Fesseln der aktuell am Boden festgehaltenen Person. Befehlsname ohne Schrägstrich eingeben.",
                    label = "Fesselbefehl nach Zu-Boden-Bringen",
                },
                tackleCuffDescription = {
                    description = "Beschreibung der Fesselbelegung im FiveM-Menü für Tastenbelegungen.",
                    label = "Beschreibung der Fessel-Tastenbelegung",
                },
                tackleCuffKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Getackelte Person fesseln",
                },
                tackleDescription = {
                    description = "Beschreibung der Belegung zum Zu-Boden-Bringen im FiveM-Menü für Tastenbelegungen.",
                    label = "Beschreibung der Tastenbelegung",
                },
                tackleEnabled = {
                    description = "Aktiviert das Zu-Boden-Bringen der nächsten Person und das Festhalten am Boden.",
                    label = "Zu-Boden-Bringen",
                },
                tackleKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Tackeln",
                },
                tackleMaxDistance = {
                    description = "Maximale Distanz zum Ziel beim Starten des Zu-Boden-Bringens.",
                    label = "Distanz zum Zu-Boden-Bringen",
                },
                tackleNeedsSprint = {
                    description = "Der Beamte muss sprinten, bevor er eine Person zu Boden bringen kann.",
                    label = "Sprint für Zu-Boden-Bringen erforderlich",
                },
                tackleReleaseCommand = {
                    description = "Befehl zum Freigeben der aktuell am Boden festgehaltenen Person. Befehlsname ohne Schrägstrich eingeben.",
                    label = "Freigabebefehl nach Zu-Boden-Bringen",
                },
                tackleReleaseDescription = {
                    description = "Beschreibung der Freigabebelegung im FiveM-Menü für Tastenbelegungen.",
                    label = "Beschreibung der Freigabe-Tastenbelegung",
                },
                tackleReleaseKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Getackelte Person loslassen",
                },
                tackleRequireOnDuty = {
                    description = "Der Beamte muss im Dienst sein, bevor er eine Person zu Boden bringen kann.",
                    label = "Dienst für Zu-Boden-Bringen erforderlich",
                },
                vehicleRadarAlertCooldownMs = {
                    description = "Millisekunden, bevor ein weiterer Radaralarm ausgelöst werden kann.",
                    label = "Alarm-Cooldown",
                },
                vehicleRadarAllowedVehicleClasses = {
                    description = "Fahrzeugklassen, die das Radar verwenden dürfen.",
                    label = "Erlaubte Fahrzeugklassen",
                },
                vehicleRadarAutoFastLock = {
                    description = "Markiert sehr schnelle Ziele im Radar automatisch.",
                    label = "Automatische Schnellsperre",
                },
                vehicleRadarAutoFastLockThreshold = {
                    description = "Geschwindigkeitsschwelle, die für die automatische Schnellsperre verwendet wird.",
                    label = "Schnellsperr-Schwelle",
                },
                vehicleRadarCustomizeCommand = {
                    description = "Befehl zum Öffnen oder Schließen des Radar-Layout-Editors. Befehlsname ohne Schrägstrich eingeben.",
                    label = "Befehl für Radar-Layout",
                },
                vehicleRadarDecreaseLimitKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Radar: Limit verringern",
                },
                vehicleRadarDefaultLimit = {
                    description = "Standard-Geschwindigkeitslimit, das vom Fahrzeug-Radar verwendet wird.",
                    label = "Standard-Radarlimit",
                },
                vehicleRadarEnabled = {
                    description = "Aktiviert das Radar für Streifenfahrzeuge.",
                    label = "Fahrzeug-Radar",
                },
                vehicleRadarIncreaseLimitKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Radar: Limit erhöhen",
                },
                vehicleRadarLimitStep = {
                    description = "Wert, um den sich das Radarlimit pro Anpassung ändert.",
                    label = "Limit-Schritt",
                },
                vehicleRadarLockFrontKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Radar: Sperre vorne",
                },
                vehicleRadarLockRearKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Radar: Sperre hinten",
                },
                vehicleRadarMaxLimit = {
                    description = "Höchst-Geschwindigkeitslimit, das im Fahrzeug-Radar erlaubt ist.",
                    label = "Höchst-Radarlimit",
                },
                vehicleRadarMaxPitchDeg = {
                    description = "Maximale Neigung, die für die Radarzielerfassung erlaubt ist.",
                    label = "Max. Neigungsgrad",
                },
                vehicleRadarMinLimit = {
                    description = "Mindest-Geschwindigkeitslimit, das im Fahrzeug-Radar erlaubt ist.",
                    label = "Mindest-Radarlimit",
                },
                vehicleRadarMinTargetSpeed = {
                    description = "Mindestgeschwindigkeit, bevor das Radar ein Ziel als gültig betrachtet.",
                    label = "Mindest-Zielgeschwindigkeit",
                },
                vehicleRadarModeFrontKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Radar: Modus vorne",
                },
                vehicleRadarModeRearKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Radar: Modus hinten",
                },
                vehicleRadarMovingScanIntervalMs = {
                    description = "Millisekunden zwischen Radar-Scans, während sich das Streifenfahrzeug bewegt.",
                    label = "Scanintervall in Bewegung",
                },
                vehicleRadarPassengerControl = {
                    description = "Erlaubt Beifahrern, das Fahrzeug-Radar zu steuern.",
                    label = "Beifahrer-Steuerung",
                },
                vehicleRadarPassengerEnabled = {
                    description = "Erlaubt Beifahrern, gespiegelte Radardaten anzuzeigen.",
                    label = "Beifahrer-Spiegelung",
                },
                vehicleRadarPassengerSyncIntervalMs = {
                    description = "Millisekunden zwischen den Radar-Synchronisierungen für Beifahrer.",
                    label = "Beifahrer-Synchronisierungsintervall",
                },
                vehicleRadarProjectionThreshold = {
                    description = "Projektionsschwelle, die bei der Bewertung von Radarzielen verwendet wird.",
                    label = "Projektionsschwelle",
                },
                vehicleRadarRequireLineOfSight = {
                    description = "Erfordert eine klare Sichtlinie, bevor das Radar ein Ziel sperrt.",
                    label = "Sichtlinie erforderlich",
                },
                vehicleRadarRequireOnDuty = {
                    description = "Erfordert Dienststatus vor der Nutzung des Fahrzeug-Radars.",
                    label = "Radar erfordert Dienst",
                },
                vehicleRadarResetLayoutCommand = {
                    description = "Befehl zum Wiederherstellen des Standard-Radar-Layouts. Befehlsname ohne Schrägstrich eingeben.",
                    label = "Befehl zum Zurücksetzen des Radar-Layouts",
                },
                vehicleRadarScanIntervalMs = {
                    description = "Millisekunden zwischen stationären Radar-Scans.",
                    label = "Scanintervall",
                },
                vehicleRadarScanRadius = {
                    description = "Scanradius des Fahrzeug-Radars.",
                    label = "Scanradius",
                },
                vehicleRadarToggleKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Radar: Umschalten",
                },
                vehicleRadarUseMph = {
                    description = "Zeigt Radar-Geschwindigkeitswerte in MPH an.",
                    label = "Radar verwendet MPH",
                },
                vehicleRadarVehiclePoolRefreshMs = {
                    description = "Millisekunden zwischen den Aktualisierungen des nahen Fahrzeugpools.",
                    label = "Fahrzeugpool-Aktualisierung",
                },
                vehicleRadarXmitFrontKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Radar: Senden/Halten vorne",
                },
                vehicleRadarXmitRearKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Radar: Senden/Halten hinten",
                },
                wheelClampConsumeItem = {
                    description = "Entfernt den Radkralle-Gegenstand nach dem Anlegen.",
                    label = "Radkralle-Gegenstand verbrauchen",
                },
                wheelClampEnabled = {
                    description = "Aktiviert die Radkralle-Aktion.",
                    label = "Radkralle",
                },
                wheelClampItem = {
                    description = "Inventargegenstand, der zum Anlegen der Radkralle verwendet wird.",
                    label = "Radkralle-Gegenstand",
                },
                wheelClampPropModel = {
                    description = "Prop-Modell, das für die angelegte Radkralle verwendet wird.",
                    label = "Radkralle-Prop-Modell",
                },
                wheelClampRequireItem = {
                    description = "Erfordert den konfigurierten Radkralle-Gegenstand. Aktiviert lassen, wenn der Nutzungsmodus auf Inventar oder Beides steht.",
                    label = "Radkralle erfordert Gegenstand",
                },
                wheelClampRequireOnDuty = {
                    description = "Erfordert Diensstatus, bevor eine Radkralle angelegt werden kann.",
                    label = "Radkralle erfordert Dienst",
                },
                wheelClampTyreDistance = {
                    description = "Maximale Distanz zum Reifen beim Anlegen oder Losschweißen einer Radkralle.",
                    label = "Reifendistanz",
                },
                wheelClampUseItem = {
                    description = "Legt fest, ob die Radkralle per Radialmenü, Inventar oder beides angelegt wird. Inventar oder Beides sollte mit „Radkralle erfordert Gegenstand“ kombiniert werden.",
                    label = "Nutzungsmodus der Radkralle",
                    options = {
                        both = "Beides",
                        inventory = "Inventar",
                        radial = "Radialmenü",
                    },
                },
                wheelClampVehicleDistance = {
                    description = "Maximale Distanz zum Zielfahrzeug beim Anlegen einer Radkralle.",
                    label = "Fahrzeugdistanz",
                },
                wheelClampWeldBurstTyre = {
                    description = "Lässt den Reifen platzen, nachdem eine Radkralle losgeschweißt wurde.",
                    label = "Reifen platzen lassen",
                },
                wheelClampWeldDurationMs = {
                    description = "Millisekunden, die zum Entfernen einer Radkralle durch Schweißen benötigt werden.",
                    label = "Schweißdauer",
                },
                wheelClampWeldEnabled = {
                    description = "Erlaubt das Entfernen von Radkrallen mit einem Schweißgerät.",
                    label = "Radkralle schweißen",
                },
                wheelClampWeldItem = {
                    description = "Inventargegenstand, der zum Losschweißen der Radkralle benötigt wird.",
                    label = "Schweißgerät",
                },
                wheelClampWeldMinigame = {
                    description = "Erfordert das Schweiß-Minispiel für die Radkralle, bevor die Entfernung abgeschlossen wird.",
                    label = "Schweiß-Minispiel",
                },
                ziptiesConsumeItem = {
                    description = "Entfernt einen Ziptie-Gegenstand, wenn einer angelegt wird.",
                    label = "Zipties verbrauchen",
                },
                ziptiesCutterConsumeItem = {
                    description = "Entfernt den Schneider-Gegenstand nach dem Durchtrennen von Zipties.",
                    label = "Schneider-Gegenstand verbrauchen",
                },
                ziptiesCutterEnabled = {
                    description = "Erlaubt das Durchtrennen von Zipties mit einer Drahtschere.",
                    label = "Ziptie-Schneider",
                },
                ziptiesCutterItem = {
                    description = "Inventargegenstand, der zum Durchtrennen von Zipties verwendet wird.",
                    label = "Schneider-Gegenstand",
                },
                ziptiesEnabled = {
                    description = "Aktiviert die Ziptie-Aktionen.",
                    label = "Kabelbinder",
                },
                ziptiesItem = {
                    description = "Inventargegenstand, der für Ziptie-Aktionen verwendet wird.",
                    label = "Ziptie-Gegenstand",
                },
                ziptiesRequireHandsUp = {
                    description = "Erfordert den Hände-hoch-Zustand vor dem Anlegen von Zipties.",
                    label = "Zipties erfordern Hände hoch",
                },
                ziptiesRequireItem = {
                    description = "Erfordert den konfigurierten Ziptie-Gegenstand.",
                    label = "Zipties erfordern Gegenstand",
                },
                ziptiesReturnOnRemove = {
                    description = "Gibt einen Ziptie-Gegenstand zurück, wenn Zipties entfernt werden.",
                    label = "Zipties zurückgeben",
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
            warnings = {
                cuffsConsumeRequiresItem = "Handschellen verbrauchen hat keine Wirkung, solange Handschellen erfordern Gegenstand deaktiviert ist.",
                wheelClampUseItemRequiresItem = "Der Nutzungsmodus Inventar oder Beides erfordert, dass Radkralle erfordert Gegenstand aktiviert bleibt.",
                ziptiesConsumeRequiresItem = "Zipties verbrauchen hat keine Wirkung, solange Zipties erfordern Gegenstand deaktiviert ist.",
            },
            locationDescriptions = {
                jail_public_blip = "Position wird automatisch vom Gefängnis-Spawn übernommen, ersatzweise vom ersten Gefängnis-Terminal.",
            },
        },
    },
}
