JobConfigLocales["sky_ambulancejob:de"] = {
    Nui = {
        tablet = {
            apps = {
                medicalEvaluations = "Medizinische Gutachten",
                sharedMedicalEvaluations = "Freigegebene Gutachten",
            },
        },
        workshopConfig = {
            creatorFields = {
                hospitalBeds = {
                    allowRespawn = {
                        label = "Respawn erlauben",
                        description = "Legt fest, ob dieses Bett für Spieler-Respawns verwendet werden darf.",
                    },
                },
            },
            configs = {
                sky_ambulancejob = {
                    subtitle = "Konfigurieren Sie Rettungsdienst-Jobs, Krankenhausbetten, Todessysteme, Interaktionen und die zentralen Funktionseinstellungen.",
                    title = "Rettungsdienst-Jobs",
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
            features = {
                bleeding = {
                    description = "Aktiviert das Blutungssystem.",
                    label = "Blutung",
                },
                bodybags = {
                    description = "Aktiviert Leichensäcke und die Abläufe zur Leichensack-Zustellung.",
                    label = "Leichensäcke",
                },
                consciousScenarioBloodPressure = {
                    description = "Erlaubt Blutdruckmessungen, während der Patient bei Bewusstsein ist.",
                    label = "Blutdruck bei Bewusstsein",
                },
                deathTimeout = {
                    description = "Aktiviert den Ablauf des Kampfunfähigkeits-Timeouts.",
                    label = "Kampfunfähigkeits-Timeout",
                },
                fractures = {
                    description = "Aktiviert die Behandlung von Frakturen.",
                    label = "Frakturen",
                },
                knockout = {
                    description = "Aktiviert das Knockout-System.",
                    label = "Knockout",
                },
                legShotRagdoll = {
                    description = "Lässt Spieler bei Treffern in konfigurierte Bein- oder Fußzonen stürzen.",
                    label = "Sturz bei Beinschuss",
                },
                pain = {
                    description = "Aktiviert das Schmerzsystem.",
                    label = "Schmerz",
                },
                respawnInBed = {
                    description = "Lässt wiederbelebte Spieler in einem verfügbaren Krankenhausbett respawnen.",
                    label = "Respawn im Bett",
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
                gang = "Gang",
                allowInVehicle = "Im Fahrzeug erlauben",
                allowMovement = "Bewegung erlauben",
                animDict = "Anim Dict",
                animFlag = "Animations-Flag",
                animName = "Animationsname",
                bleeding = "Blutung",
                cause = "Ursache",
                chance = "Wahrscheinlichkeit",
                class = "Klasse",
                companyPrice = "Firmenpreis",
                companyPricePerEmployee = "Preis pro Mitarbeiter",
                copayPercent = "Zuzahlung %",
                description = "Beschreibung",
                dictionary = "Anim Dict",
                duration = "Dauer",
                durationMs = "Dauer (ms)",
                effect = "Effekt",
                effectDurationMs = "Effektdauer (ms)",
                effectDurationSeconds = "Effektdauer (Sekunden)",
                enabled = "Aktiviert",
                extractionType = "Entfernungsart",
                foreignObject = "Fremdkörper",
                heal = "Heilung",
                id = "ID",
                itemName = "Gegenstandsname",
                key = "Schlüssel",
                label = "Bezeichnung",
                lang = "Sprache",
                limit = "Begrenzen",
                lossPerSecond = "Verlust pro Sekunde",
                max = "Höchstmenge",
                min = "Mindestgehalt",
                minGrade = "Mindestrang",
                minigame = "Minispiel",
                model = "Prop-Modell",
                name = "Jobname",
                options = "Optionen (Auswahltypen)",
                pain = "Schmerz",
                pauseBleedingSeconds = "Blutung pausieren (Sekunden)",
                price = "Preis",
                progressbarAllowInVehicle = "Fortschritt: im Fahrzeug erlauben",
                progressbarAllowMovement = "Fortschritt: Bewegung erlauben",
                progressbarCanCancel = "Fortschritt abbrechbar",
                progressbarDisableCarMovement = "Fortschritt: Fahrzeugbewegung sperren",
                progressbarDisableCombat = "Fortschritt: Kampf sperren",
                progressbarDisableMouse = "Fortschritt: Maus sperren",
                progressbarDisableMovement = "Fortschritt: Bewegung sperren",
                progressbarDisableSprint = "Fortschritt: Sprinten sperren",
                progressbarDuration = "Fortschrittsdauer",
                progressbarEnabled = "Fortschrittsbalken aktiviert",
                progressbarLabel = "Fortschrittsbalken-Text",
                progressbarUseWhileDead = "Fortschritt im Tod verwendbar",
                questions = "Fragen",
                requireItems = "Gegenstände erforderlich",
                required = "Pflichtfeld",
                requiresExtraction = "Entfernung erforderlich",
                requiresOpenWound = "Offene Wunde erforderlich",
                sort = "Reihenfolge",
                state = "Status",
                stopBleeding = "Blutung stoppen",
                threshold = "Schwellenwert",
                time = "Zeit",
                type = "Typ",
                useAnimation = "Animation verwenden",
                value = "Wert",
                zone = "Gebiet",
                zones = "Zonen",
                systolic = "Systolischer Blutdruck",
                diastolic = "Diastolischer Blutdruck",
                cardiacArrest = "Herzstillstand",
            },
            settingGroups = {
                appointmentsGeneral = {
                    label = "Allgemein",
                },
                appointmentsLimits = {
                    label = "Begrenzungen",
                },
                appointmentsNotifications = {
                    label = "Benachrichtigungen",
                },
                appointmentsScheduling = {
                    label = "Terminplanung",
                },
                billingGeneral = {
                    label = "Allgemein",
                },
                billingRange = {
                    label = "Reichweite",
                },
                billingReasons = {
                    label = "Vorgegebene Gründe",
                },
                billingUi = {
                    label = "UI",
                },
                bodyBagAnimation = {
                    label = "Animation",
                },
                bodyBagAttachGeneral = {
                    label = "Anheftung",
                },
                bodyBagAttachOffsets = {
                    label = "Versätze",
                },
                bodyBagAttachRotation = {
                    label = "Drehung",
                },
                bodyBagDeliveryGeneral = {
                    label = "Allgemein",
                },
                bodyBagDeliveryRewardGeneral = {
                    label = "Allgemein",
                },
                bodyBagDeliveryRewardPayment = {
                    label = "Zahlung",
                },
                bodyBagDeliveryUi = {
                    label = "UI",
                },
                bodyBagGeneral = {
                    label = "Allgemein",
                },
                crutchAssign = {
                    label = "Zuweisung",
                },
                crutchDuration = {
                    label = "Dauer",
                },
                crutchGeneral = {
                    label = "Allgemein",
                },
                crutchItems = {
                    label = "Gegenstand",
                },
                crutchRestrictions = {
                    label = "Einschränkungen",
                },
                damageHandlingBladeWeapons = {
                    label = "Klingenwaffen",
                },
                damageHandlingBleedingBlacklist = {
                    label = "Blutungs-Ausschlussliste",
                },
                damageHandlingBleedingClasses = {
                    label = "Blutungsklassen",
                },
                damageHandlingBloodSystem = {
                    label = "Blutsystem",
                },
                damageHandlingDeathInjuries = {
                    label = "Todesverletzungen",
                },
                damageHandlingInjuryEffects = {
                    label = "Verletzungseffekte",
                },
                damageHandlingInjuryThresholds = {
                    label = "Verletzungsschwellen",
                },
                damageHandlingLegShotRagdoll = {
                    label = "Beinschuss-Ragdoll",
                },
                damageHandlingLegShotRagdollZones = {
                    label = "Beinschuss-Zonen",
                },
                damageHandlingLiveDamageFractures = {
                    label = "Frakturen bei aktivem Schaden",
                },
                damageHandlingLiveDamageFracturesZones = {
                    label = "Zonen-Wahrscheinlichkeiten",
                },
                damageHandlingLiveOpenWoundStacks = {
                    label = "Offene-Wunden-Stacks",
                },
                damageHandlingLiveOpenWoundStacksZones = {
                    label = "Zonenlimits",
                },
                damageHandlingLiveWoundBleedingClass = {
                    label = "Blutungsklassen (aktive Wunden)",
                },
                damageHandlingMedications = {
                    label = "Medikamente",
                },
                damageHandlingPainClasses = {
                    label = "Schmerzklassen",
                },
                damageHandlingPainEffects = {
                    label = "Schmerzeffekte",
                },
                damageHandlingStatusEffects = {
                    label = "Statuseffekte",
                },
                damageHandlingVehicleDamage = {
                    label = "Fahrzeugschaden",
                },
                damageHandlingVehicleImpactCauses = {
                    label = "Schadensursachen",
                },
                damageHandlingVehicleImpactInjuries = {
                    label = "Verletzungen",
                },
                damageHandlingVehicleImpactProtection = {
                    label = "Fahrzeugaufprallschutz",
                },
                deathAnimal = {
                    label = "Tier-Ausweichlösung",
                },
                deathAnimalAnimation = {
                    label = "Tier-Animation",
                },
                deathAnimation = {
                    label = "Animation",
                },
                deathGeneral = {
                    label = "Allgemein",
                },
                deathModels = {
                    label = "Modell-Überschreibungen",
                },
                deathScreenAiMedic = {
                    label = "Allgemein",
                },
                deathScreenAiMedicAvailability = {
                    label = "Verfügbarkeit",
                },
                deathScreenAiMedicBehaviour = {
                    label = "Verhalten",
                },
                deathScreenAiMedicForceRevive = {
                    label = "Erzwungene Wiederbelebung",
                },
                deathScreenAiMedicPayment = {
                    label = "Zahlung",
                },
                deathScreenAiMedicReviveInBed = {
                    label = "Wiederbelebung im Bett",
                },
                deathScreenAiMedicSpawn = {
                    label = "Spawnen",
                },
                deathScreenAiMedicTiming = {
                    label = "Zeitsteuerung",
                },
                deathScreenControls = {
                    label = "Steuerung",
                },
                deathScreenDamageLogs = {
                    label = "Schadenslogs",
                },
                deathScreenDimensions = {
                    label = "Dimensionen",
                },
                deathScreenDispatch = {
                    label = "Leitstelle",
                },
                deathScreenEarlyRespawn = {
                    label = "Allgemein",
                },
                deathScreenEarlyRespawnAvailability = {
                    label = "Verfügbarkeit",
                },
                deathScreenEarlyRespawnPayment = {
                    label = "Zahlung",
                },
                deathScreenGeneral = {
                    label = "Allgemein",
                },
                deathScreenHospitalSelection = {
                    label = "Krankenhausauswahl",
                },
                deathScreenHospitalSelectionCamera = {
                    label = "Auswahlkamera",
                },
                deathScreenInformation = {
                    label = "Allgemein",
                },
                deathScreenIntegration = {
                    label = "Integration",
                },
                deathScreenLogs = {
                    label = "Todeslogs",
                },
                deathScreenMinigame = {
                    label = "Minispiel",
                },
                deathScreenRespawn = {
                    label = "Allgemein",
                },
                deathScreenRespawnAccounts = {
                    label = "Konten",
                },
                deathScreenRespawnFallback = {
                    label = "Ausweich-Koordinaten",
                },
                deathScreenRespawnItems = {
                    label = "Gegenstände",
                },
                deathScreenRespawnWeapons = {
                    label = "Waffen",
                },
                deathScreenStyle = {
                    label = "Todesbildschirm-Design",
                },
                deathScreenVoice = {
                    label = "Sprache",
                },
                deathTimeoutGeneral = {
                    label = "Allgemein",
                },
                deathTimeoutWhitelist = {
                    label = "Ausgenommene Jobs",
                },
                diagnoseAnim = {
                    label = "Animation",
                },
                diagnoseCpr = {
                    label = "CPR",
                },
                diagnoseFullHeal = {
                    label = "Vollheilung",
                },
                diagnoseGeneral = {
                    label = "Allgemein",
                },
                doctorNpcAvailability = {
                    label = "Verfügbarkeit",
                },
                doctorNpcGeneral = {
                    label = "Allgemein",
                },
                doctorNpcHealOther = {
                    label = "Andere heilen",
                },
                doctorNpcHealSelf = {
                    label = "Selbst heilen",
                },
                doctorNpcRanges = {
                    description = "Diese Reichweiten steuern nicht, wie nah ein Spieler sein muss, um die Doctor-NPC-Interaktion zu öffnen. Sie greifen erst, nachdem das Doctor-Menü geöffnet wurde.",
                    label = "Reichweiten",
                },
                doctorNpcRevive = {
                    label = "Wiederbeleben",
                },
                doctorNpcReviveInBed = {
                    label = "Wiederbelebung im Bett",
                },
                firstAidAnimation = {
                    label = "Animation",
                },
                firstAidGeneral = {
                    label = "Allgemein",
                },
                firstAidLicenseAdd = {
                    label = "Lizenz hinzufügen",
                },
                firstAidLicenseRemove = {
                    label = "Lizenz entfernen",
                },
                firstAidPosition = {
                    label = "Platzieren",
                },
                healthCompatibility = {
                    label = "Gesundheitskompatibilität",
                },
                healthInsuranceExpiration = {
                    label = "Ablauf",
                },
                healthInsuranceGeneral = {
                    label = "Allgemein",
                },
                healthInsurancePayment = {
                    label = "Zahlung",
                },
                healthInsuranceProviders = {
                    label = "Anbieter",
                },
                hospitalBedsBedAnimation = {
                    label = "Bett-Animation",
                },
                hospitalBedsCreator = {
                    label = "Ersteller",
                },
                hospitalBedsDistances = {
                    label = "Distanzen",
                },
                hospitalBedsGeneral = {
                    label = "Allgemein",
                },
                hospitalBedsGetupAnimation = {
                    label = "Aufsteh-Animation",
                },
                hospitalBedsModels = {
                    label = "Modelle",
                },
                hospitalBedsOffsets = {
                    label = "Versätze",
                },
                hospitalBlip = {
                    label = "Krankenhaus-Blip",
                },
                imagingGeneral = {
                    label = "Allgemein",
                },
                imagingRanges = {
                    label = "Reichweiten",
                },
                keybinds = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Tastenbelegung",
                },
                knockoutGeneral = {
                    label = "Allgemein",
                },
                knockoutWeapons = {
                    label = "Waffen",
                },
                medicCarryAttach = {
                    label = "Anheftung",
                },
                medicCarryAttachOffsets = {
                    label = "Versätze",
                },
                medicCarryAttachRotation = {
                    label = "Drehung",
                },
                medicCarryCarrierAnimation = {
                    label = "Träger-Animation",
                },
                medicCarryGeneral = {
                    label = "Allgemein",
                },
                medicCarryPassengerAnimation = {
                    label = "Passagier-Animation",
                },
                medicCarryRestrictions = {
                    label = "Einschränkungen",
                },
                medicRevivePersistence = {
                    label = "Allgemein",
                },
                medicalEvaluationRecipients = {
                    label = "Empfänger-Jobs",
                },
                medicalEvaluationSharing = {
                    label = "Geteilte Felder",
                },
                medicalEvaluationTypes = {
                    label = "Gutachtenarten",
                },
                medicalEvaluationsGeneral = {
                    label = "Allgemein",
                },
                medicalWearablesArmRestrictions = {
                    label = "Einschränkungen bei Armgips",
                },
                medicalWearablesCasts = {
                    label = "Gipsverbände",
                },
                medicalWearablesDuration = {
                    label = "Tragedauer",
                },
                medicalWearablesGeneral = {
                    label = "Allgemein",
                },
                medicalWearablesHeadBandage = {
                    label = "Kopfverband",
                },
                medicalWearablesLegRestrictions = {
                    label = "Einschränkungen bei Beingips",
                },
                medicalWearablesNeckBrace = {
                    label = "Halskrause",
                },
                medicalWearablesOxygenMask = {
                    label = "Sauerstoffmaske",
                },
                medicalWearablesPatientHud = {
                    label = "Patientenanzeige",
                },
                medicalWearablesRemoval = {
                    label = "Entfernung",
                },
                medicalWearablesSplints = {
                    label = "Schienen",
                },
                medicalWearablesTorsoBandage = {
                    label = "Oberkörperverband",
                },
                minigamesBloodTransfusionGeneral = {
                    label = "Allgemein",
                },
                minigamesCprGeneral = {
                    label = "Allgemein",
                },
                minigamesEnabled = {
                    label = "Aktiviert",
                },
                minigamesRandomization = {
                    label = "Zufallsvariation",
                },
                minigamesVentilationGeneral = {
                    label = "Allgemein",
                },
                operationsAnesthesia = {
                    label = "Narkose",
                },
                operationsDistances = {
                    label = "Distanzen",
                },
                operationsDoctorAnimation = {
                    label = "Arztanimation",
                },
                operationsGeneral = {
                    label = "Allgemein",
                },
                operationsPatientAnimation = {
                    label = "Patientenanimation",
                },
                operationsTrainingAnimation = {
                    label = "Trainingsanimation",
                },
                propPlacement = {
                    label = "Prop-Platzierung",
                },
                propPlacementItems = {
                    label = "Prop-Gegenstände",
                },
                publicTreatmentGeneral = {
                    label = "Allgemein",
                },
                publicTreatmentJobs = {
                    label = "Erlaubte Jobs",
                },
                publicTreatmentRequirements = {
                    label = "Anforderungen",
                },
                reviveRewardGeneral = {
                    label = "Allgemein",
                },
                reviveRewardPayment = {
                    label = "Zahlung",
                },
                selfDiagnoseGeneral = {
                    label = "Allgemein",
                },
                stretcherAnimation = {
                    label = "Animation",
                },
                stretcherCarryAttach = {
                    label = "Trage-Anheftung",
                },
                stretcherFolded = {
                    label = "Zusammengeklappte Variante",
                },
                stretcherFoldedPatientAttach = {
                    label = "Anheftung (zusammengeklappt)",
                },
                stretcherGeneral = {
                    label = "Allgemein",
                },
                stretcherHelicopter = {
                    label = "Helikopter",
                },
                stretcherPatientAttach = {
                    label = "Patienten-Anheftung",
                },
                stretcherTreatmentAnim = {
                    label = "Animation",
                },
                stretcherVehicleAttach = {
                    label = "Fahrzeug-Anheftung",
                },
                stretcherVehicleLists = {
                    label = "Fahrzeugmodelle",
                },
                treatmentAnim = {
                    label = "Animation",
                },
                treatmentEnable = {
                    label = "Aktivieren",
                },
                trunk = {
                    label = "Kofferraum",
                },
                vehiclePullGeneral = {
                    label = "Allgemein",
                },
                wheelchairAssign = {
                    label = "Zuweisung",
                },
                wheelchairDuration = {
                    label = "Dauer",
                },
                wheelchairGeneral = {
                    label = "Allgemein",
                },
                wheelchairItems = {
                    label = "Gegenstand",
                },
                wheelchairRestrictions = {
                    label = "Einschränkungen",
                },
                xrayGeneral = {
                    label = "Allgemein",
                },
                xrayRanges = {
                    label = "Reichweiten",
                },
            },
            settingSections = {
                billing = "Abrechnung",
                bodyBag = "Leichensack",
                damageHandling = "Schadensverwaltung",
                death = "Tod",
                deathScreen = "Todesbildschirm",
                diagnose = "Diagnose",
                doctorNpc = "Feldarzt",
                general = "Allgemein",
                healthInsurance = "Krankenversicherung",
                hospitalBeds = "Krankenhausbetten",
                knockout = "Knockout",
                medicCarry = "Patiententransport",
                minigames = "Minispiele",
                mobilityAid = "Mobilitätshilfen",
                operations = "Operationen",
                organization = "Organisation",
                rewards = "Belohnungen",
                treatment = "Behandlung",
                vehiclePull = "Fahrzeugbergung",
            },
            settingSubsections = {
                aiMedic = "KI-Sanitäter",
                anesthesia = "Narkose",
                animation = "Animation",
                animations = "Animationen",
                appointments = "Termine",
                attach = "Anheftung",
                bedAnimation = "Bett-Animation",
                blood = "Blut",
                bloodTransfusion = "Bluttransfusion",
                bodyBagDeliveryReward = "Leichensack-Zustellungsbelohnung",
                carrierAnimation = "Träger-Animation",
                classification = "Klassifizierung",
                cpr = "CPR",
                crutch = "Krücke",
                deathInjuries = "Todesverletzungen",
                deathScreenStyle = "Todesbildschirm-Design",
                deathTimeout = "Kampfunfähigkeits-Timeout",
                delivery = "Zustellung",
                diagnoseAnim = "Diagnose-Animation",
                dispatch = "Leitstelle",
                earlyRespawn = "Frühzeitiger Respawn",
                effects = "Effekte",
                firstAid = "Erste Hilfe",
                general = "Allgemein",
                getupAnimation = "Aufsteh-Animation",
                imaging = "Bildgebung",
                information = "Unterrichtung",
                keybinds = "Tastenbelegung",
                liveDamage = "Akuter Schaden",
                logs = "Protokolle",
                medicRevivePersistence = "Wiederbelebungs-Persistenz",
                medicalEvaluations = "Medizinische Gutachten",
                medicalWearables = "Medizinische Hilfsmittel",
                medications = "Medikamente",
                minigame = "Minispiel",
                passengerAnimation = "Passagier-Animation",
                pricing = "Preisgestaltung",
                propPlacement = "Prop-Platzierung",
                publicTreatment = "Öffentliche Behandlung",
                respawn = "Im Krankenhaus aufwachen",
                reviveInBed = "Wiederbelebung im Bett",
                reviveReward = "Wiederbelebungs-Belohnung",
                selfDiagnose = "Selbstdiagnose",
                stretcher = "Trage",
                stretcherTreatmentAnim = "Trage-Behandlungsanimation",
                thresholds = "Schwellenwerte",
                treatmentAnim = "Behandlungs-Animation",
                trunk = "Kofferraum",
                vehicleImpact = "Fahrzeugaufprall",
                ventilation = "Beatmung",
                wheelchair = "Rollstuhl",
                xray = "Röntgen",
            },
            settings = {
                ambulanceEditorControl172 = {
                    label = "Editor: Nach oben",
                    description = "Konfiguriert: Editor: Nach oben.",
                },
                ambulanceEditorControl173 = {
                    label = "Editor: Nach unten",
                    description = "Konfiguriert: Editor: Nach unten.",
                },
                ambulanceEditorControl174 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · LEFT",
                },
                ambulanceEditorControl175 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · RIGHT",
                },
                ambulanceEditorControl177 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · BACK",
                },
                ambulanceEditorControl201 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · RETURN",
                },
                ambulanceEditorControl202 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · ESCAPE",
                },
                ambulanceEditorControl21 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · LSHIFT",
                },
                ambulanceEditorControl32 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · W",
                },
                ambulanceEditorControl33 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · S",
                },
                ambulanceEditorControl34 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · A",
                },
                ambulanceEditorControl35 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · D",
                },
                ambulanceEditorControl36 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · LCONTROL",
                },
                ambulanceEditorControl37 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · TAB",
                },
                ambulanceEditorControl38 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · E",
                },
                ambulanceEditorControl44 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Editor · Q",
                },
                ambulanceFirstAidControl38 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Erste Hilfe · E",
                },
                ambulanceStretcherEditorControl177 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Interaktion · BACK",
                },
                ambulanceStretcherEditorControl201 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Interaktion · RETURN",
                },
                ambulanceStretcherEditorControl202 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Interaktion · ESCAPE",
                },
                ambulanceStretcherEditorControl21 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Interaktion · LSHIFT",
                },
                ambulanceStretcherEditorControl241 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Interaktion · IOM_WHEEL_UP",
                },
                ambulanceStretcherEditorControl242 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Interaktion · IOM_WHEEL_DOWN",
                },
                ambulanceStretcherEditorControl25 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Interaktion · MOUSE_RIGHT",
                },
                ambulanceStretcherEditorControl32 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Interaktion · W",
                },
                ambulanceStretcherEditorControl33 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Interaktion · S",
                },
                ambulanceStretcherEditorControl34 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Interaktion · A",
                },
                ambulanceStretcherEditorControl35 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Interaktion · D",
                },
                ambulanceStretcherEditorControl36 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Interaktion · LCONTROL",
                },
                ambulanceStretcherEditorControl38 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Interaktion · E",
                },
                ambulanceStretcherEditorControl44 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Interaktion · Q",
                },
                appointmentsBookingCooldownSeconds = {
                    description = "Cooldown in Sekunden zwischen Buchungsversuchen eines Patienten.",
                    label = "Buchungs-Cooldown",
                },
                appointmentsEnabled = {
                    description = "Aktiviert die Terminbuchung für Patienten und den persönlichen Sanitäterkalender.",
                    label = "Aktiviert",
                },
                appointmentsMaxAdvanceDays = {
                    description = "Maximale Anzahl an Tagen, die Patienten im Voraus buchen dürfen.",
                    label = "Maximaler Buchungsvorlauf",
                },
                appointmentsMaxAppointmentsPerPlayer = {
                    description = "Maximale Anzahl aktiver zukünftiger Termine, die ein Patient gleichzeitig haben darf.",
                    label = "Maximale Termine pro Patient",
                },
                appointmentsMinLeadMinutes = {
                    description = "Mindestanzahl an Minuten zwischen Buchung und Termin.",
                    label = "Mindestvorlaufzeit",
                },
                appointmentsNotificationApp = {
                    description = "Kennung der Handy-App für Terminbenachrichtigungen.",
                    label = "Benachrichtigungs-App",
                },
                appointmentsNotificationsEnabled = {
                    description = "Benachrichtigt Patienten auf ihrem Handy, wenn Termine gebucht oder abgesagt werden.",
                    label = "Handy-Benachrichtigungen",
                },
                appointmentsReasonMaxLength = {
                    description = "Maximale Anzahl an Zeichen für den Termingrund.",
                    label = "Zeichenlimit für den Grund",
                },
                appointmentsSlotDurationMinutes = {
                    description = "Dauer und Rasterintervall eines Termins in Minuten.",
                    label = "Termindauer",
                },
                billingAccount = {
                    description = "Veraltetes Ausweich-Society-Konto für die Abrechnung.",
                    label = "Konto",
                },
                billingCloseOnSuccess = {
                    description = "Schließt die Abrechnungs-UI automatisch nach erfolgreicher Rechnungsstellung.",
                    label = "Nach Erfolg schließen",
                },
                billingCurrency = {
                    description = "Optionaler Währungsschlüssel für Abrechnungszahlungen.",
                    label = "Währung",
                },
                billingCustomBillingReasons = {
                    description = "Erlaubt Sanitätern, eigene Abrechnungsgründe einzugeben.",
                    label = "Eigene Gründe",
                },
                billingDepositToSociety = {
                    description = "Zahlt Einnahmen aus der Abrechnung in das Society-Konto ein.",
                    label = "In Society-Konto einzahlen",
                },
                billingEnabled = {
                    description = "Aktiviert das medizinische Abrechnungssystem.",
                    label = "Aktiviert",
                },
                billingMaxReasonLength = {
                    description = "Maximale Zeichenanzahl für eigene Abrechnungsgründe.",
                    label = "Maximale Länge des Grundes",
                },
                billingMode = {
                    description = "Wählt, ob medizinische Rechnungen sofort abbuchen, eine Bestätigung erfordern oder das Framework-Abrechnungssystem verwenden.",
                    label = "Abrechnungsmodus",
                    options = {
                        consent = "Bezahlen oder ablehnen",
                        framework = "Framework-Rechnung",
                        instant = "Sofort abbuchen",
                    },
                },
                billingRange = {
                    description = "Maximale Reichweite zum Finden abrechenbarer Patienten.",
                    label = "Reichweite",
                },
                billingReasonPresets = {
                    description = "Vorgegebene Abrechnungsgründe, die in der Abrechnungs-UI angezeigt werden.",
                    itemLabel = "Grund",
                    label = "Vorgegebene Gründe",
                },
                billingRefreshSeconds = {
                    description = "Sekunden zwischen Aktualisierungen abrechenbarer Spieler.",
                    label = "Aktualisierungssekunden",
                },
                bladeWeapons = {
                    description = "Waffennamen oder Hashes, die als Messerschaden statt als stumpfer Schaden eingestuft werden sollen.",
                    itemLabel = "Waffe",
                    label = "Klingenwaffen",
                },
                bleedingBlacklist = {
                    description = "Waffen, die niemals aktive Blutungen oder offene Wunden verursachen sollen.",
                    itemLabel = "Waffe",
                    label = "Blutungs-Ausschlussliste",
                },
                bleedingClassesProfiles = {
                    description = "Schweregradprofile der Blutung und ihre Blutverlustrate.",
                    label = "Blutungsklassen",
                },
                bloodSystemDebugLogInterval = {
                    description = "Sekunden zwischen Debug-Protokollmeldungen des Blutsystems.",
                    label = "Debug-Protokollintervall",
                },
                bloodSystemMaxVolume = {
                    description = "Maximaler Blutvolumenwert des Patientenzustandssystems.",
                    label = "Maximales Volumen",
                },
                bloodSystemRegenPerSecond = {
                    description = "Passive Blutregeneration, wenn der Patient nicht aktiv blutet.",
                    label = "Regeneration pro Sekunde",
                },
                bloodSystemTickIntervalMs = {
                    description = "Server-Tick-Intervall für Aktualisierungen von Blutverlust und -erholung.",
                    label = "Tick-Intervall (ms)",
                },
                bloodSystemUnconsciousThreshold = {
                    description = "Blutvolumen-Schwellenwert, unterhalb dessen der Patient bewusstlos wird.",
                    label = "Bewusstlosigkeits-Schwellenwert",
                },
                bodyBagAnimationDict = {
                    description = "Anim Dict für das Tragen eines Leichensacks.",
                    label = "Anim Dict",
                },
                bodyBagAnimationEnabled = {
                    description = "Verwendet eine eigene Trage-Animation beim Tragen eines Leichensacks.",
                    label = "Aktiviert",
                },
                bodyBagAnimationFlag = {
                    description = "TaskPlayAnim-Flag für die Trage-Animation.",
                    label = "Animations-Flag",
                },
                bodyBagAnimationName = {
                    description = "Animationsclip für das Tragen eines Leichensacks.",
                    label = "Animationsname",
                },
                bodyBagAttachBone = {
                    description = "Ped-Knochenname oder Knochen-ID für die Leichensack-Anheftung.",
                    label = "Knochen",
                },
                bodyBagAttachRx = {
                    description = "X-Rotation der Leichensack-Anheftung.",
                    label = "Anheftung RX",
                },
                bodyBagAttachRy = {
                    description = "Y-Rotation der Leichensack-Anheftung.",
                    label = "Anheftung RY",
                },
                bodyBagAttachRz = {
                    description = "Z-Rotation der Leichensack-Anheftung.",
                    label = "Anheftung RZ",
                },
                bodyBagAttachX = {
                    description = "X-Versatz der Leichensack-Anheftung.",
                    label = "Anheftung X",
                },
                bodyBagAttachY = {
                    description = "Y-Versatz der Leichensack-Anheftung.",
                    label = "Anheftung Y",
                },
                bodyBagAttachZ = {
                    description = "Z-Versatz der Leichensack-Anheftung.",
                    label = "Anheftung Z",
                },
                bodyBagDeliveryHelpLabelKey = {
                    description = "Locale-Schlüssel für den Hilfehinweis bei der Leichensack-Abgabe.",
                    label = "Hilfetext-Schlüssel",
                },
                bodyBagDeliveryInteractDistance = {
                    description = "Distanz zur Prüfung der Leichensack-Abgabe.",
                    label = "Interaktionsdistanz",
                },
                bodyBagDeliveryInteractKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Leichensack abgeben",
                },
                bodyBagDeliveryInteraction = {
                    description = "Schlüssel der Interaktionsvorlage für Leichensack-Abgaben.",
                    label = "Interaktionsvorlage",
                },
                bodyBagDeliveryRequireDropOff = {
                    description = "Erfordert, dass Sanitäter Leichensäcke an konfigurierten Übergabepunkten abgeben.",
                    label = "Abgabe erforderlich",
                },
                bodyBagDeliveryRequireOnDuty = {
                    description = "Erfordert, dass Sanitäter im Dienst sind, bevor sie einen Leichensack zustellen.",
                    label = "Dienst erforderlich",
                },
                bodyBagDeliveryRewardAccount = {
                    description = "Primärer Kontoschlüssel für Belohnungen bei der Leichensack-Zustellung.",
                    label = "Konto",
                },
                bodyBagDeliveryRewardAccountType = {
                    description = "Primärer Kontotyp für Belohnungen bei der Leichensack-Zustellung.",
                    label = "Kontotyp",
                },
                bodyBagDeliveryRewardAmount = {
                    description = "Belohnungsbetrag für eine Leichensack-Zustellung.",
                    label = "Betrag",
                },
                bodyBagDeliveryRewardCurrency = {
                    description = "Optionaler eigener Währungsschlüssel für Belohnungen bei der Leichensack-Zustellung.",
                    label = "Währung",
                },
                bodyBagDeliveryRewardEnabled = {
                    description = "Zahlt eine konfigurierte Belohnung nach einer abgeschlossenen Leichensack-Zustellung aus.",
                    label = "Aktiviert",
                },
                bodyBagDeliveryRewardPayFromSociety = {
                    description = "Zieht Belohnungen für die Leichensack-Zustellung vom gemeinsamen Society-Konto des Jobs ab, bevor der Sanitäter bezahlt wird.",
                    label = "Aus Society-Konto zahlen",
                },
                bodyBagEnabled = {
                    description = "Aktiviert das Leichensack-System.",
                    label = "Aktiviert",
                },
                bodyBagHidePatient = {
                    description = "Blendet den Patienten-Ped aus, während der Leichensack angeheftet ist.",
                    label = "Patient ausblenden",
                },
                bodyBagModel = {
                    description = "Prop-Modell für Leichensäcke.",
                    label = "Modell",
                },
                bodyBagPatientAlpha = {
                    description = "Transparenzwert des Patienten, während er im Leichensack liegt.",
                    label = "Patienten-Transparenz",
                },
                crutchAssignMaxDistance = {
                    description = "Maximale Distanz zum Zuweisen einer Krücke an einen anderen Spieler.",
                    label = "Maximale Zuweisungsdistanz",
                },
                crutchAutoUnequipOnExpire = {
                    description = "Legt die Krücke automatisch ab, wenn die Zuweisung abläuft.",
                    label = "Automatisch ablegen bei Ablauf",
                },
                crutchClipset = {
                    description = "Bewegungs-Clipset bei der Nutzung der Krücke.",
                    label = "Clipset",
                },
                crutchDefaultDurationMinutes = {
                    description = "Standard-Zuweisungsdauer der Krücke in Minuten.",
                    label = "Standarddauer",
                },
                crutchDisableSprint = {
                    description = "Blockiert Sprinten, während eine Krücke ausgerüstet ist.",
                    label = "Sprinten deaktivieren",
                },
                crutchDisableWeapons = {
                    description = "Blockiert die Waffennutzung, während eine Krücke ausgerüstet ist.",
                    label = "Waffen deaktivieren",
                },
                crutchItemName = {
                    description = "Inventargegenstand für die Krücke.",
                    label = "Gegenstandsname",
                },
                crutchMaxDurationMinutes = {
                    description = "Maximal erlaubte Zuweisungsdauer der Krücke in Minuten.",
                    label = "Maximaldauer",
                },
                crutchMinDurationMinutes = {
                    description = "Minimal erlaubte Zuweisungsdauer der Krücke in Minuten.",
                    label = "Mindestdauer",
                },
                crutchProp = {
                    description = "Prop-Modell für die Krücke.",
                    label = "Objekt",
                },
                damageLogBatchIntervalSeconds = {
                    description = "Sekunden, in denen einzelne Treffer in einer Discord-Nachricht gesammelt werden.",
                    label = "Bündelintervall",
                },
                damageLogMaxEntriesPerMessage = {
                    description = "Maximale Anzahl einzelner Treffer pro Discord-Nachricht.",
                    label = "Treffer pro Nachricht",
                },
                damageLogsEnabled = {
                    description = "Serverseitig bestätigte, nicht tödliche Spielertreffer an Discord senden.",
                    label = "Schadenslogs",
                },
                deathAnimalAnimationDictionary = {
                    description = "Anim Dict für die Todesanimation der Tier-Ausweichlösung.",
                    label = "Tier-Dictionary",
                },
                deathAnimalAnimationName = {
                    description = "Animationsclip für die Todesanimation der Tier-Ausweichlösung.",
                    label = "Tier-Animationsname",
                },
                deathAnimalUseAnimation = {
                    description = "Erlaubt der konfigurierten Tier-Ausweichlösung, eine skriptgesteuerte Todesanimation zu verwenden.",
                    label = "Tier-Animation",
                },
                deathAnimationDictionary = {
                    description = "Anim Dict für die Standard-Todesanimation.",
                    label = "Anim Dict",
                },
                deathAnimationName = {
                    description = "Animationsclip für die Standard-Todesanimation.",
                    label = "Animationsname",
                },
                deathInjuriesProfiles = {
                    description = "Verletzungsprofile, die angewendet werden, wenn ein Spieler an einer bestimmten Ursache stirbt.",
                    itemLabel = "Verletzung",
                    label = "Todesverletzungen",
                },
                deathModels = {
                    description = "Überschreibt das Todesanimationsverhalten pro Ped-Modell oder Modell-Hash.",
                    label = "Modell-Überschreibungen",
                },
                deathScreenAiMedicAccount = {
                    description = "Primärkonto, das für den KI-Sanitäter belastet wird.",
                    label = "Konto",
                },
                deathScreenAiMedicAddDeathTimerSeconds = {
                    description = "Sekunden, die dem Bleedout-Timer hinzugefügt werden, wenn der KI-Sanitäter angefordert wird.",
                    label = "Todes-Timer verlängern",
                },
                deathScreenAiMedicAllowFatalWounds = {
                    description = "Erlaubt dem KI-Sanitäter, auch bei tödlichen Verletzungen wiederzubeleben.",
                    label = "Tödliche Verletzungen erlauben",
                },
                deathScreenAiMedicApproachDistance = {
                    description = "Distanz, bei der der KI-Sanitäter anhält und sich zu Fuß nähert.",
                    label = "Annäherungsdistanz",
                },
                deathScreenAiMedicCooldownSeconds = {
                    description = "Abklingzeit, bevor der KI-Sanitäter erneut gerufen werden kann.",
                    label = "Abklingzeit (Sekunden)",
                },
                deathScreenAiMedicCurrency = {
                    description = "Optionaler Währungsschlüssel für Zahlungen an den KI-Sanitäter.",
                    label = "Währung",
                },
                deathScreenAiMedicCurrencyFormatter = {
                    description = "Währungsformatierung für Zahlungen an den KI-Sanitäter.",
                    label = "Währungsformatierung",
                },
                deathScreenAiMedicDespawnDelaySeconds = {
                    description = "Sekunden, bevor der KI-Sanitäter nach Abschluss despawnt.",
                    label = "Despawn-Verzögerung",
                },
                deathScreenAiMedicDispatchDelaySeconds = {
                    description = "Verzögerung, bevor der Dispatch des KI-Sanitäters beginnt.",
                    label = "Dispatch-Verzögerung",
                },
                deathScreenAiMedicDriveSpeed = {
                    description = "Fahrgeschwindigkeit des KI-Sanitäter-Fahrzeugs.",
                    label = "Fahrgeschwindigkeit",
                },
                deathScreenAiMedicDriveTimeoutSeconds = {
                    description = "Maximale Fahrzeit, bevor die erzwungene Wiederbelebung ausgelöst wird.",
                    label = "Fahrt-Timeout",
                },
                deathScreenAiMedicEnabled = {
                    description = "Aktiviert den Rettungsablauf des KI-Sanitäters.",
                    label = "Aktiviert",
                },
                deathScreenAiMedicFallbackAccount = {
                    description = "Ausweichkonto, das verwendet wird, wenn das Primärkonto des KI-Sanitäters nicht über ausreichend Guthaben verfügt.",
                    label = "Ausweichkonto",
                },
                deathScreenAiMedicForceReviveEnabled = {
                    description = "Erzwingt eine Wiederbelebung, wenn der KI-Sanitäter den Spieler nicht erreichen kann.",
                    label = "Erzwungene Wiederbelebung aktiviert",
                },
                deathScreenAiMedicMaxMedicsOnline = {
                    description = "Der KI-Sanitäter funktioniert nur, solange die Anzahl der Sanitäter im Dienst diesem Wert entspricht oder darunter liegt.",
                    label = "Maximale Sanitäter online",
                },
                deathScreenAiMedicMissionTimeoutSeconds = {
                    description = "Maximale Einsatzdauer, bevor die erzwungene Wiederbelebung ausgelöst wird.",
                    label = "Einsatz-Timeout",
                },
                deathScreenAiMedicPedModel = {
                    description = "Ped-Modell des KI-Sanitäters.",
                    label = "Ped-Modell",
                },
                deathScreenAiMedicPlayerRequestMode = {
                    description = "Ziel, wenn der bewusstlose Spieler selbst den KI-Sanitäter ruft.",
                    label = "Ziel bei Spieleranfrage",
                    options = {
                        hospital = "Krankenhaus",
                        location = "Aktuelle Position",
                    },
                },
                deathScreenAiMedicPrice = {
                    description = "Preis für das Rufen des KI-Sanitäters.",
                    label = "Preis",
                },
                deathScreenAiMedicRemoteDispatchDelaySeconds = {
                    description = "Sekunden nach dem Tod des Spielers, bevor ein Sanitäter einen Remote-KI-Sanitäter anbieten kann.",
                    label = "Wartezeit für Remote-Dispatch",
                },
                deathScreenAiMedicRemoteDispatchEnabled = {
                    description = "Erlaubt Sanitätern, den KI-Sanitäter über die Dispatch-Karte oder den /aimedic-Befehl zu einem bewusstlosen Spieler zu schicken.",
                    label = "Remote-Dispatch",
                },
                deathScreenAiMedicRemoteDispatchMaxMedicsOnline = {
                    description = "Der Remote-KI-Sanitäter-Dispatch funktioniert nur, solange die Anzahl der Sanitäter im Dienst diesem Wert entspricht oder darunter liegt.",
                    label = "Maximale Sanitäter online für Remote-Dispatch",
                },
                deathScreenAiMedicRemoteDispatchMode = {
                    description = "Ziel, wenn ein Remote-KI-Sanitäter gesendet und angenommen wird.",
                    label = "Ziel bei Remote-Dispatch",
                    options = {
                        hospital = "Krankenhaus",
                        location = "Aktuelle Position",
                    },
                },
                deathScreenAiMedicRemoteOfferTimeoutSeconds = {
                    description = "Sekunden, in denen der Spieler ein Remote-KI-Sanitäter-Angebot annehmen kann.",
                    label = "Timeout des Remote-Angebots",
                },
                deathScreenAiMedicReviveDistance = {
                    description = "Erforderliche Distanz, bevor der KI-Sanitäter mit der Wiederbelebung beginnt.",
                    label = "Wiederbelebungsdistanz",
                },
                deathScreenAiMedicReviveDurationSeconds = {
                    description = "Sekunden, die für die Wiederbelebung des Spielers aufgewendet werden.",
                    label = "Wiederbelebungsdauer",
                },
                deathScreenAiMedicReviveInBedEnabled = {
                    description = "Teleportiert den Spieler in ein Krankenhausbett, statt ihn vor Ort wiederzubeleben.",
                    label = "Wiederbelebung im Bett",
                },
                deathScreenAiMedicReviveInBedSearchRadius = {
                    description = "Suchradius zum Finden eines Wiederbelebungsbetts.",
                    label = "Bett-Suchradius",
                },
                deathScreenAiMedicSecondsTillAvailable = {
                    description = "Sekunden nach dem Tod, bis der KI-Sanitäter verfügbar wird.",
                    label = "Sekunden bis verfügbar",
                },
                deathScreenAiMedicSpawnRadiusMax = {
                    description = "Maximaler Spawn-Radius des KI-Sanitäters.",
                    label = "Maximaler Spawn-Radius",
                },
                deathScreenAiMedicSpawnRadiusMin = {
                    description = "Minimaler Spawn-Radius des KI-Sanitäters.",
                    label = "Minimaler Spawn-Radius",
                },
                deathScreenAiMedicVehicleModel = {
                    description = "Fahrzeugmodell des KI-Sanitäters.",
                    label = "Fahrzeugmodell",
                },
                deathScreenAllowVoiceWhileUnconscious = {
                    description = "Sprachmodus während der Bewusstlosigkeit: keine, nur zuhören oder vollständig.",
                    label = "Sprachmodus",
                    options = {
                        full = "Vollständig",
                        listen = "Nur zuhören",
                        none = "Keine",
                    },
                },
                deathScreenAllowedControls = {
                    description = "Steuerungscodes, die während der Bewusstlosigkeit aktiviert bleiben.",
                    label = "Erlaubte Steuerungen",
                },
                deathScreenAutoRespawnOnExpiredReconnect = {
                    description = "Lässt Spieler automatisch respawnen, wenn der Bleedout-Timer während der Trennung bereits abgelaufen ist.",
                    label = "Automatischer Respawn bei abgelaufenem Reconnect",
                },
                deathScreenBackgroundEnd = {
                    description = "Endfarbe des Todesbildschirm-Hintergrunds.",
                    label = "Hintergrund Ende",
                },
                deathScreenBackgroundStart = {
                    description = "Startfarbe des Todesbildschirm-Hintergrunds.",
                    label = "Hintergrund Start",
                },
                deathScreenBleedOutTimerSeconds = {
                    description = "Sekunden, bevor der Bleedout-Timer abläuft.",
                    label = "Bleedout-Timer",
                },
                deathScreenBlockedDimensions = {
                    description = "Dimensionen, in denen der Respawn-Ablauf des Todesbildschirms gesperrt ist.",
                    label = "Gesperrte Dimensionen",
                },
                deathScreenBorderColor = {
                    description = "Rahmenfarbe des Todesbildschirms.",
                    label = "Rahmenfarbe",
                },
                deathScreenDispatchEnabled = {
                    description = "Sendet Dispatch-Ereignisse aus dem Todesbildschirm-Ablauf.",
                    label = "Dispatch aktiviert",
                },
                deathScreenDispatchFallbackJobs = {
                    description = "Ersatzempfänger, wenn bei den primären Jobs niemand lebt und im Dienst ist. Leer lassen, um immer die primären Jobs zu alarmieren.",
                    itemLabel = "Beruf",
                    label = "Vertretungsjobs",
                },
                deathScreenDispatchJobs = {
                    description = "Jobs, die alarmiert werden, wenn ein kampfunfähiger Spieler Hilfe anfordert.",
                    itemLabel = "Beruf",
                    label = "Alarmierte Jobs",
                },
                deathScreenEarlyRespawnAccount = {
                    description = "Primärkonto, das für den frühzeitigen Respawn belastet wird.",
                    label = "Konto",
                },
                deathScreenEarlyRespawnAllowFatalWounds = {
                    description = "Hält den frühzeitigen Respawn auch bei tödlichen Verletzungen verfügbar.",
                    label = "Tödliche Verletzungen erlauben",
                },
                deathScreenEarlyRespawnCurrency = {
                    description = "Optionaler Währungsschlüssel für Zahlungen des frühzeitigen Respawns.",
                    label = "Währung",
                },
                deathScreenEarlyRespawnCurrencyFormatter = {
                    description = "Währungsformatierung für Zahlungen des frühzeitigen Respawns.",
                    label = "Währungsformatierung",
                },
                deathScreenEarlyRespawnEnabled = {
                    description = "Aktiviert den kostenpflichtigen frühzeitigen Respawn.",
                    label = "Aktiviert",
                },
                deathScreenEarlyRespawnFallbackAccount = {
                    description = "Ausweichkonto, das verwendet wird, wenn das Primärkonto nicht über ausreichend Guthaben verfügt.",
                    label = "Ausweichkonto",
                },
                deathScreenEarlyRespawnPaymentLabel = {
                    description = "Optionale Bezeichnung für die Zahlung des frühzeitigen Respawns.",
                    label = "Zahlungsbezeichnung",
                },
                deathScreenEarlyRespawnPrice = {
                    description = "Preis für einen frühzeitigen Respawn.",
                    label = "Preis",
                },
                deathScreenEarlyRespawnRequireNoMedics = {
                    description = "Erlaubt den frühzeitigen Respawn nur, wenn keine Sanitäter im Dienst sind.",
                    label = "Keine Sanitäter erforderlich",
                },
                deathScreenEarlyRespawnSecondsTillAvailable = {
                    description = "Sekunden nach dem Tod, bis der frühzeitige Respawn verfügbar wird.",
                    label = "Sekunden bis verfügbar",
                },
                deathScreenEnableKeyboard = {
                    description = "Erlaubt die Tastaturnutzung auf dem Todesbildschirm.",
                    label = "Tastatur aktivieren",
                },
                deathScreenExternalVoiceSystem = {
                    description = "Externes Sprach-Backend, das bei Aktivierung stummgeschaltet wird.",
                    label = "Externes Sprachsystem",
                    options = {
                        saltychat = "SaltyChat",
                        yaca = "YACA",
                    },
                },
                deathScreenFocusKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Todesbildschirm: Mausbedienung",
                },
                deathScreenHandlingMode = {
                    description = "Verwendet die statische Todesanimation oder erhält die natürliche Ragdoll-Physik, bis der Körper stabil liegt.",
                    label = "Todesdarstellung",
                    options = {
                        natural = "Natürlich",
                        static = "Statisch",
                    },
                },
                deathScreenHideOverlayWithoutFocus = {
                    description = "Blendet den Todesbildschirm aus, nachdem die LEERTASTE zur Spielsteuerung wechselt; deaktivieren Sie diese Option, um das bisherige sichtbare Overlay beizubehalten.",
                    label = "Overlay bei Spielsteuerung ausblenden",
                },
                deathScreenHospitalSelectionCameraFocusHeight = {
                    description = "Höhenversatz des Kamera-Fokusziels.",
                    label = "Fokushöhe",
                },
                deathScreenHospitalSelectionCameraFov = {
                    description = "Sichtfeld der Vorschaukamera.",
                    label = "Sichtfeld",
                },
                deathScreenHospitalSelectionCameraHeadingOffset = {
                    description = "Ausrichtungsversatz beim Platzieren der Vorschaukamera.",
                    label = "Ausrichtungsversatz",
                },
                deathScreenHospitalSelectionCameraHeight = {
                    description = "Höhenversatz der Vorschaukamera.",
                    label = "Kamerahöhe",
                },
                deathScreenHospitalSelectionCameraPitch = {
                    description = "Neigung der Vorschaukamera.",
                    label = "Neigung",
                },
                deathScreenHospitalSelectionCameraRadius = {
                    description = "Distanz der Vorschaukamera zum Spawnpunkt.",
                    label = "Kameraradius",
                },
                deathScreenHospitalSelectionCameraTransition = {
                    description = "Verwendet einen sanften Übergang beim Öffnen der Kamera für die Krankenhausauswahl.",
                    label = "Sanfter Übergang",
                },
                deathScreenHospitalSelectionEnabled = {
                    description = "Erlaubt Spielern, vor dem Respawn ein Krankenhaus auszuwählen.",
                    label = "Krankenhausauswahl",
                },
                deathScreenHospitalSelectionRequireMultipleHospitals = {
                    description = "Zeigt die Krankenhausauswahl nur, wenn mehr als ein Krankenhaus existiert.",
                    label = "Mehrere Krankenhäuser erforderlich",
                },
                deathScreenInformationEnabled = {
                    description = "Zeigt den Informationsblock auf dem Todesbildschirm an.",
                    label = "Aktiviert",
                },
                deathScreenInformationShowDeathCause = {
                    description = "Zeigt die Todesursache im Informationsblock des Todesbildschirms an.",
                    label = "Todesursache anzeigen",
                },
                deathScreenInformationShowInjuries = {
                    description = "Zeigt Verletzungen im Informationsblock des Todesbildschirms an.",
                    label = "Verletzungen anzeigen",
                },
                deathScreenInformationShowKiller = {
                    description = "Zeigt den Namen des Angreifers im Informationsblock des Todesbildschirms an.",
                    label = "Angreifer anzeigen",
                },
                deathScreenInformationShowWeapon = {
                    description = "Zeigt die Waffe im Informationsblock des Todesbildschirms an.",
                    label = "Waffe anzeigen",
                },
                deathScreenInformationWhitelistedGangs = {
                    label = "Gangs auf der Whitelist",
                    description = "Wähle interne Gang- oder Organisationsnamen. Ein passender Job oder eine passende Gang gewährt die Freigabe bzw. Ausnahme. Dienstpflicht gilt nur für Jobs.",
                    itemLabel = "Gang",
                },
                deathScreenInformationWhitelistedJobs = {
                    description = "Jobs, die erweiterte Informationen des Todesbildschirms sehen dürfen.",
                    itemLabel = "Beruf",
                    label = "Ausgenommene Jobs",
                },
                deathScreenLogScreenshotTimeoutSeconds = {
                    description = "Maximale Sekunden pro Screenshot-Upload.",
                    label = "Screenshot-Zeitlimit",
                },
                deathScreenLogScreenshots = {
                    description = "Nach dem Text-Log Bilder aus Sicht des Opfers und des bestätigten Killers hochladen.",
                    label = "Screenshots",
                },
                deathScreenLogsEnabled = {
                    description = "Bei jedem Tod einen Discord-Log senden.",
                    label = "Todeslogs",
                },
                deathScreenMedicNearbyRadius = {
                    description = "Distanz in Metern, ab der ein Sanitäter als in der Nähe gilt.",
                    label = "Radius für Sanitäter in der Nähe",
                },
                deathScreenMinigameEnabled = {
                    description = "Aktiviert das Minispiel des Todesbildschirms.",
                    label = "Aktiviert",
                },
                deathScreenMinigameUrl = {
                    description = "URL, die für das Minispiel des Todesbildschirms geöffnet wird.",
                    label = "Minispiel-URL",
                },
                deathScreenMode = {
                    description = "Verwendet den integrierten Todesbildschirm oder eine externe Integration.",
                    label = "Bildschirmmodus",
                    options = {
                        external = "Extern",
                        internal = "Intern",
                    },
                },
                deathScreenMuteExternalVoiceOnDeath = {
                    description = "Schaltet externe Sprachsysteme stumm, während der Spieler tot ist.",
                    label = "Externe Sprachübertragung stummschalten",
                },
                deathScreenMutedTextColor = {
                    description = "Gedämpfte Textfarbe des Todesbildschirms.",
                    label = "Gedämpfte Textfarbe",
                },
                deathScreenNaturalRagdollDebug = {
                    description = "Gibt detaillierte Client- und Servergründe aus, solange ein natürlich verstorbener Körper im Ragdoll bleibt.",
                    label = "Natural-Ragdoll-Debug",
                },
                deathScreenNaturalStabilizationMode = {
                    description = "Stabilisiert ruhig liegende Körper automatisch oder verlangt, dass eine Rettungskraft sie in die stabile Seitenlage bringt.",
                    label = "Natürliche Stabilisierung",
                    options = {
                        automatic = "Automatisch",
                        medic = "Medic erforderlich",
                    },
                },
                deathScreenPanelBackground = {
                    description = "Panel-Hintergrundfarbe des Todesbildschirms.",
                    label = "Panel-Hintergrund",
                },
                deathScreenPreventAutoRespawn = {
                    description = "Blockiert den automatischen Respawn nach dem Bleedout.",
                    label = "Automatischen Respawn verhindern",
                },
                deathScreenPreventAutoRespawnIfMedicNearby = {
                    description = "Blockiert den automatischen Respawn, solange ein Sanitäter in der Nähe ist.",
                    label = "Blockieren, wenn Sanitäter in der Nähe ist",
                },
                deathScreenPreventReviveOnExpiry = {
                    description = "Blockiert Wiederbelebungen, nachdem der Bleedout-Timer abgelaufen ist.",
                    label = "Wiederbelebung bei Ablauf verhindern",
                },
                deathScreenPrimaryColor = {
                    description = "Basis-CSS-Farbe für das Design des Todesbildschirms.",
                    label = "Primärfarbe",
                },
                deathScreenPrimaryDark = {
                    description = "Optionale dunklere Akzentfarbe für den Todesbildschirm.",
                    label = "Primär dunkel",
                },
                deathScreenPrimaryStrong = {
                    description = "Optionale kräftigere Akzentfarbe für den Todesbildschirm.",
                    label = "Primär kräftig",
                },
                deathScreenRespawnDefaultHeading = {
                    description = "Ausrichtung, die verwendet wird, wenn für die Station keine Ausrichtung definiert ist.",
                    label = "Standard-Ausrichtung",
                },
                deathScreenRespawnFallbackCoordsHeading = {
                    description = "Ausweich-Respawn-Ausrichtung, wenn keine Krankenhauspositionen existieren.",
                    label = "Ausweich-Ausrichtung",
                },
                deathScreenRespawnFallbackCoordsX = {
                    description = "Ausweich-Respawn-X-Koordinate, wenn keine Krankenhauspositionen existieren.",
                    label = "Ausweich X",
                },
                deathScreenRespawnFallbackCoordsY = {
                    description = "Ausweich-Respawn-Y-Koordinate, wenn keine Krankenhauspositionen existieren.",
                    label = "Ausweich Y",
                },
                deathScreenRespawnFallbackCoordsZ = {
                    description = "Ausweich-Respawn-Z-Koordinate, wenn keine Krankenhauspositionen existieren.",
                    label = "Ausweich Z",
                },
                deathScreenRespawnHospitalId = {
                    description = "Wählt ein festes Krankenhaus für Respawns. Leer lassen, um das nächstgelegene Krankenhaus zu verwenden.",
                    label = "Respawn-Krankenhaus",
                },
                deathScreenRespawnRemoveAccountsEnabled = {
                    description = "Entfernt Kontostände beim Respawn.",
                    label = "Kontostände entfernen",
                },
                deathScreenRespawnRemoveAccountsNames = {
                    description = "Kontonamen, die beim Respawn entfernt werden.",
                    itemLabel = "Konto",
                    label = "Kontonamen",
                },
                deathScreenRespawnRemoveItemsEnabled = {
                    description = "Entfernt Inventargegenstände beim Respawn.",
                    label = "Gegenstände entfernen",
                },
                deathScreenRespawnRemoveItemsIgnore = {
                    description = "Inventargegenstände, die beim Respawn erhalten bleiben.",
                    itemLabel = "Gegenstand",
                    label = "Ausgenommene Gegenstände",
                },
                deathScreenRespawnRemoveWeaponsEnabled = {
                    description = "Entfernt Waffen aus dem Waffenrad beim Respawn.",
                    label = "Waffen entfernen",
                },
                deathScreenRespawnRemoveWeaponsIgnore = {
                    description = "Waffen, die beim Respawn erhalten bleiben.",
                    itemLabel = "Waffe",
                    label = "Ausgenommene Waffen",
                },
                deathScreenRespawnTeleportToHospital = {
                    description = "Teleportiert den Spieler beim Respawn in ein Krankenhaus.",
                    label = "Ins Krankenhaus teleportieren",
                },
                deathScreenResumeBleedOutOnReconnect = {
                    description = "Setzt den Bleedout-Timer nach einem Reconnect fort, statt ihn zurückzusetzen.",
                    label = "Bei Reconnect fortsetzen",
                },
                deathScreenShadowLight = {
                    description = "Weiche Schattenfarbe des Todesbildschirms.",
                    label = "Schatten hell",
                },
                deathScreenShadowMid = {
                    description = "Mittlere Schattenfarbe des Todesbildschirms.",
                    label = "Schatten mittel",
                },
                deathScreenShowNearestMedic = {
                    description = "Zeigt den nächstgelegenen Sanitäter auf dem Todesbildschirm an.",
                    label = "Nächsten Sanitäter anzeigen",
                },
                deathScreenTextColor = {
                    description = "Primäre Textfarbe des Todesbildschirms.",
                    label = "Textfarbe",
                },
                deathScreenTextShadow = {
                    description = "Textschattenfarbe des Todesbildschirms.",
                    label = "Textschatten",
                },
                deathTimeoutApplyOnKnockout = {
                    description = "Wendet den Kampfunfähigkeits-Timeout auch nach Knockout-Wiederbelebungen an.",
                    label = "Bei Knockout anwenden",
                },
                deathTimeoutSeconds = {
                    description = "Sekunden nach einer Wiederbelebung, in denen Kampfhandlungen deaktiviert bleiben.",
                    label = "Sekunden",
                },
                deathTimeoutShowUi = {
                    description = "Zeigt das Countdown-Banner des Kampfunfähigkeits-Timeouts an, solange dieser aktiv ist.",
                    label = "UI anzeigen",
                },
                deathTimeoutWhitelistedGangs = {
                    label = "Gangs auf der Whitelist",
                    description = "Wähle interne Gang- oder Organisationsnamen. Ein passender Job oder eine passende Gang gewährt die Freigabe bzw. Ausnahme. Dienstpflicht gilt nur für Jobs.",
                    itemLabel = "Gang",
                },
                deathTimeoutWhitelistedJobs = {
                    description = "Jobs, die von den Einschränkungen des Kampfunfähigkeits-Timeouts ausgenommen sind.",
                    itemLabel = "Beruf",
                    label = "Ausgenommene Jobs",
                },
                deathUseAnimation = {
                    description = "Spielt die konfigurierte Todesanimation für unterstützte Peds ab.",
                    label = "Animation verwenden",
                },
                diagnoseAnimClip = {
                    description = "Animationsclip beim Öffnen der Diagnose. Leer lassen, um stattdessen ein Szenario zu verwenden.",
                    label = "Animationsname",
                },
                diagnoseAnimDict = {
                    description = "Anim Dict beim Öffnen der Diagnose. Leer lassen, um stattdessen ein Szenario zu verwenden.",
                    label = "Anim Dict",
                },
                diagnoseAnimScenario = {
                    description = "Szenario beim Öffnen der Diagnose. Leer lassen, um stattdessen Dictionary + Clip zu verwenden.",
                    label = "Szenario",
                },
                diagnoseCprAnimDict = {
                    description = "Anim Dict für die CPR.",
                    label = "Anim Dict",
                },
                diagnoseCprAnimName = {
                    description = "Animationsclip für die CPR.",
                    label = "Animationsname",
                },
                diagnoseFullHealDelaySeconds = {
                    description = "Erforderliche durchgehende Diagnosezeit, bevor die Vollheilung erscheint.",
                    label = "Verzögerung (Sekunden)",
                },
                diagnoseRequireRescueBackpack = {
                    label = "Rettungsrucksack voraussetzen",
                    description = "Für die linke Leiste mit Untersuchungstools rescue_backpack voraussetzen. Deaktivieren, um sie immer anzuzeigen; die Item-Voraussetzungen einzelner Tools bleiben bestehen.",
                },
                diagnoseFullHealEnabled = {
                    description = "Erlaubt die Vollheilung nach einer durchgehenden Diagnosesitzung.",
                    label = "Aktiviert",
                },
                diagnoseInteractDistance = {
                    description = "Maximale Distanz, um einen Patienten zu diagnostizieren oder in einen Leichensack zu legen.",
                    label = "Interaktionsdistanz",
                },
                diagnosePatientMovementMode = {
                    label = "Patientenbewegung",
                    description = "Patienten einfrieren, solange ein anderer Spieler das Behandlungsmenü geöffnet hat, oder Bewegung erlauben und das Menü bei überschrittener Behandlungsdistanz schließen. Selbstdiagnosen werden separat eingestellt.",
                    options = {
                        freeze = "Patient einfrieren",
                        distance = "Bei Distanzüberschreitung schließen",
                    },
                },
                diagnoseMaxTreatmentDistance = {
                    label = "Behandlungsdistanz (m)",
                    description = "Maximale Entfernung zwischen Behandler und Patient, bevor sich das Behandlungsmenü im Distanzmodus schließt. Die Distanz zum Öffnen wird separat eingestellt.",
                },
                diagnoseKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Diagnose-Interaktion",
                },
                diagnoseOpenDelayMs = {
                    description = "Verzögerung, bevor die Diagnose-UI geöffnet wird.",
                    label = "Öffnungsverzögerung (ms)",
                },
                diagnosePromptDistance = {
                    description = "Distanz, ab der der Diagnose-Hinweis angezeigt wird.",
                    label = "Hinweisdistanz",
                },
                diagnoseTreatmentDurationMs = {
                    description = "Dauer für Behandlungsanimationen.",
                    label = "Behandlungsdauer (ms)",
                },
                doctorNpcAddRevenueToSociety = {
                    description = "Zahlt Arztzahlungen bei direkter Abbuchung in das gemeinsame Society-Konto ein.",
                    label = "Einnahmen ins Society-Konto",
                },
                doctorNpcEnabled = {
                    description = "Aktiviert den Feldarzt-Dienst.",
                    label = "Aktiviert",
                },
                doctorNpcHealOtherAccount = {
                    description = "Primärer Kontoschlüssel für die Abbuchung beim Heilen eines anderen Spielers.",
                    label = "Konto",
                },
                doctorNpcHealOtherAccountType = {
                    description = "Primärer Kontotyp für die Abbuchung beim Heilen eines anderen Spielers.",
                    label = "Kontotyp",
                },
                doctorNpcHealOtherCurrency = {
                    description = "Optionaler eigener Währungsschlüssel für die Abbuchung beim Heilen eines anderen Spielers.",
                    label = "Währung",
                },
                doctorNpcHealOtherPrice = {
                    description = "Preis, um einen anderen Spieler beim Feldarzt heilen zu lassen.",
                    label = "Preis",
                },
                doctorNpcHealSelfAccount = {
                    description = "Primärer Kontoschlüssel für die Abbuchung der Selbstheilung.",
                    label = "Konto",
                },
                doctorNpcHealSelfAccountType = {
                    description = "Primärer Kontotyp für die Abbuchung der Selbstheilung.",
                    label = "Kontotyp",
                },
                doctorNpcHealSelfCurrency = {
                    description = "Optionaler eigener Währungsschlüssel für die Abbuchung der Selbstheilung.",
                    label = "Währung",
                },
                doctorNpcHealSelfPrice = {
                    description = "Preis, um sich selbst beim Feldarzt heilen zu lassen.",
                    label = "Preis",
                },
                doctorNpcInteractionRange = {
                    description = "Wie nah der Nutzer während des geöffneten Doctor-Menüs am Doctor NPC bleiben muss. Das ändert nicht die Distanz für den ersten NPC-Prompt.",
                    label = "Interaktionsreichweite",
                },
                doctorNpcMaxMedicsOnline = {
                    description = "Der Feldarzt funktioniert nur, solange die Anzahl der Sanitäter im Dienst unter diesem Grenzwert liegt.",
                    label = "Maximale Sanitäter online",
                },
                doctorNpcPatientRange = {
                    description = "Wie nah der Patient am Doctor NPC sein muss, damit Andere heilen oder Wiederbeleben nach der Auswahl funktioniert.",
                    label = "Patientenreichweite",
                },
                doctorNpcPaymentMode = {
                    description = "Belastet Spieler sofort oder sendet eine Rechnung.",
                    label = "Zahlungsmodus",
                    options = {
                        bill = "Rechnung stellen",
                        remove = "Sofort abbuchen",
                    },
                },
                doctorNpcPlayerScanRange = {
                    description = "Wird nur verwendet, um nahe Spieler in der Doctor-NPC-UI aufzulisten. Allein dadurch wird keine Behandlung erlaubt.",
                    label = "Spieler-Scanreichweite",
                },
                doctorNpcReviveAccount = {
                    description = "Primärer Kontoschlüssel für die Abbuchung von Feldarzt-Wiederbelebungen.",
                    label = "Konto",
                },
                doctorNpcReviveAccountType = {
                    description = "Primärer Kontotyp für die Abbuchung von Feldarzt-Wiederbelebungen.",
                    label = "Kontotyp",
                },
                doctorNpcReviveAllowFatalWounds = {
                    description = "Erlaubt dem Arzt-NPC, Patienten mit tödlichen oder nicht wiederbelebbaren Verletzungen wiederzubeleben. Ein abgelaufener Bleedout bleibt gesperrt.",
                    label = "Tödliche Verletzungen erlauben",
                },
                doctorNpcReviveCurrency = {
                    description = "Optionaler eigener Währungsschlüssel für die Abbuchung von Feldarzt-Wiederbelebungen.",
                    label = "Währung",
                },
                doctorNpcReviveInBedEnabled = {
                    description = "Platziert wiederbelebte Spieler nach einer Feldarzt-Wiederbelebung im nächstgelegenen Krankenhausbett.",
                    label = "Aktiviert",
                },
                doctorNpcReviveInBedSearchRadius = {
                    description = "Maximale Distanz zum Finden eines nahen Krankenhausbetts für Feldarzt-Wiederbelebungen.",
                    label = "Suchradius",
                },
                doctorNpcRevivePrice = {
                    description = "Preis, um einen Spieler beim Feldarzt wiederzubeleben.",
                    label = "Preis",
                },
                enforceMaxHealth = {
                    description = "Hält die maximale Spielergesundheit bei 200. Deaktiviere dies, wenn eine andere Ressource die maximale Gesundheit verwaltet.",
                    label = "Maximale Gesundheit auf 200 begrenzen",
                },
                firstAidActionDurationMs = {
                    description = "Wie lange die Erste-Hilfe-Aktion dauert.",
                    label = "Aktionsdauer (ms)",
                },
                firstAidAnimationDict = {
                    description = "Anim Dict während der Erste-Hilfe-Aktion.",
                    label = "Anim Dict",
                },
                firstAidAnimationFlag = {
                    description = "TaskPlayAnim-Flag während der Erste-Hilfe-Aktion.",
                    label = "Animations-Flag",
                },
                firstAidAnimationName = {
                    description = "Animationsclip während der Erste-Hilfe-Aktion.",
                    label = "Animationsname",
                },
                firstAidBleedoutExtensionSeconds = {
                    description = "Sekunden, die dem Bleedout-Timer des Patienten nach Erster Hilfe hinzugefügt werden.",
                    label = "Verlängerung des Bleedout-Timers (Sekunden)",
                },
                firstAidEnabled = {
                    description = "Aktiviert die Erste-Hilfe-Funktion für lizenzierte Spieler.",
                    label = "Erste Hilfe aktiviert",
                },
                firstAidLicense = {
                    description = "Framework-Lizenzname, mit dem der Zugang zur Ersten Hilfe geprüft wird.",
                    label = "Lizenzname",
                },
                firstAidLicenseManagementAddEnabled = {
                    description = "Erlaubt dem Rettungsdienst, freigegebene Lizenzen in Patientenakten zu vergeben. Die Radialaktion vergibt nur die Erste-Hilfe-Lizenz.",
                    label = "Lizenz vergeben aktiviert",
                },
                firstAidLicenseManagementAddRadial = {
                    description = "Zeigt die Aktion zum Vergeben der Lizenz im Radialmenü an.",
                    label = "Lizenz vergeben im Radialmenü",
                },
                firstAidLicenseManagementAddRequireDuty = {
                    description = "Erfordert EMS-Dienst, bevor die Aktion zum Vergeben der Lizenz genutzt werden kann.",
                    label = "Lizenz vergeben erfordert Dienst",
                },
                firstAidLicenseManagementAdditionalLicenses = {
                    description = "Weitere Framework-Lizenzen, die der Rettungsdienst in Patientenakten vergeben oder entfernen darf. Die konfigurierte Erste-Hilfe-Lizenz ist immer enthalten.",
                    itemLabel = "Lizenz",
                    label = "Zusätzliche Patientenlizenzen",
                },
                firstAidLicenseManagementRemoveEnabled = {
                    description = "Erlaubt dem Rettungsdienst, freigegebene Lizenzen in Patientenakten zu entfernen. Die Radialaktion entfernt nur die Erste-Hilfe-Lizenz.",
                    label = "Lizenz entfernen aktiviert",
                },
                firstAidLicenseManagementRemoveRadial = {
                    description = "Zeigt die Aktion zum Entfernen der Lizenz im Radialmenü an.",
                    label = "Lizenz entfernen im Radialmenü",
                },
                firstAidLicenseManagementRemoveRequireDuty = {
                    description = "Erfordert EMS-Dienst, bevor die Aktion zum Entfernen der Lizenz genutzt werden kann.",
                    label = "Lizenz entfernen erfordert Dienst",
                },
                firstAidPositionChestOffset = {
                    description = "Brust-Versatz bei der Ausrichtung für Erste Hilfe.",
                    label = "Brust-Versatz",
                },
                firstAidPositionSideOffset = {
                    description = "Seitlicher Versatz bei der Ausrichtung für Erste Hilfe.",
                    label = "Seitlicher Versatz",
                },
                firstAidPositionZOffset = {
                    description = "Vertikaler Versatz bei der Ausrichtung für Erste Hilfe.",
                    label = "Z-Versatz",
                },
                firstAidRequireLicense = {
                    description = "Erfordert die konfigurierte Erste-Hilfe-Lizenz, bevor ein Spieler Erste Hilfe leisten kann.",
                    label = "Lizenz erforderlich",
                },
                firstAidTargetDistance = {
                    description = "Maximal erlaubte Distanz für die Nutzung von Erster Hilfe.",
                    label = "Zieldistanz",
                },
                healthInsuranceAccount = {
                    description = "Ausweich-Kontoschlüssel für Versicherungszahlungen.",
                    label = "Konto",
                },
                healthInsuranceAccountType = {
                    description = "Primärer Kontotyp für Versicherungszahlungen.",
                    label = "Kontotyp",
                },
                healthInsuranceAvailableDays = {
                    description = "Verfügbare Versicherungsdauern in Tagen.",
                    label = "Verfügbare Tage",
                },
                healthInsuranceCommand = {
                    description = "Chat-Befehl zum Öffnen der Krankenversicherungs-UI.",
                    label = "Befehl",
                },
                healthInsuranceCurrency = {
                    description = "Optionaler eigener Währungsschlüssel für Versicherungszahlungen.",
                    label = "Währung",
                },
                healthInsuranceEnabled = {
                    description = "Aktiviert das Krankenversicherungssystem.",
                    label = "Aktiviert",
                },
                healthInsurancePricesManagedInTablet = {
                    description = "Erlaubt berechtigten Mitarbeitern, Versicherungspreise im Tablet zu ändern. Deaktivieren, um die Preise aus der untenstehenden Anbietertabelle vorzugeben.",
                    label = "Tablet-Preisverwaltung",
                },
                healthInsuranceProviders = {
                    description = "Versicherungsanbieter, die Spielern angeboten werden.",
                    itemLabel = "Anbieter",
                    label = "Anbieter",
                },
                healthInsuranceSharedAcrossJobs = {
                    description = "Verwendet dieselben Versicherungsanbieter und Policen für alle in dieser Ambulance-Ressource eingetragenen Jobs.",
                    label = "Jobübergreifend teilen",
                },
                hospitalBedsBedAnimationDict = {
                    description = "Anim Dict, das in einer Schleife läuft, während der Spieler im Bett liegt. Leer lassen, um auf die Standard-Todesanimation zurückzugreifen.",
                    label = "Anim Dict",
                },
                hospitalBedsBedAnimationDurationMs = {
                    description = "Optionale manuelle Dauer für die in Schleife laufende Bett-Animation. Wird nur verwendet, wenn eine eigene Bett-Animation konfiguriert ist.",
                    label = "Dauer (ms)",
                },
                hospitalBedsBedAnimationFlag = {
                    description = "TaskPlayAnim-Flag für die in Schleife laufende Bett-Animation. Wird nur verwendet, wenn eine eigene Bett-Animation konfiguriert ist.",
                    label = "Animations-Flag",
                },
                hospitalBedsBedAnimationName = {
                    description = "Animationsclip, der in einer Schleife läuft, während der Spieler im Bett liegt. Leer lassen, um auf die Standard-Todesanimation zurückzugreifen.",
                    label = "Animationsname",
                },
                hospitalBedsBreakDistance = {
                    description = "Distanz, ab der der Spieler zwangsweise aus dem Bett entfernt wird.",
                    label = "Abbruchdistanz",
                },
                hospitalBedsCreatorPedModel = {
                    description = "Vorschau-Ped-Modell im Positions-Editor für Krankenhausbetten.",
                    label = "Ersteller-Ped-Modell",
                },
                hospitalBedsEnabled = {
                    description = "Aktiviert die konfigurierten Krankenhausbett-Interaktionen.",
                    label = "Aktiviert",
                },
                hospitalBedsGetupAnimationDict = {
                    description = "Anim Dict, das beim Aufstehen aus dem Bett abgespielt wird. Leer lassen, um das Standard-Aufstehverhalten zu verwenden.",
                    label = "Anim Dict",
                },
                hospitalBedsGetupAnimationDurationMs = {
                    description = "Optionale manuelle Dauer für die Aufsteh-Animation. Wird nur verwendet, wenn eine eigene Aufsteh-Animation konfiguriert ist.",
                    label = "Dauer (ms)",
                },
                hospitalBedsGetupAnimationFlag = {
                    description = "TaskPlayAnim-Flag für die Aufsteh-Animation. Wird nur verwendet, wenn eine eigene Aufsteh-Animation konfiguriert ist.",
                    label = "Animations-Flag",
                },
                hospitalBedsGetupAnimationName = {
                    description = "Animationsclip, der beim Aufstehen aus dem Bett abgespielt wird. Leer lassen, um das Standard-Aufstehverhalten zu verwenden.",
                    label = "Animationsname",
                },
                hospitalBedsHeadingOffset = {
                    description = "Ausrichtungsversatz beim Platzieren des Spielers auf dem Bett.",
                    label = "Ausrichtungsversatz",
                },
                hospitalBedsHeightOffset = {
                    description = "Vertikaler Versatz beim Platzieren des Spielers auf dem Bett.",
                    label = "Höhenversatz",
                },
                hospitalBedsInteractDistance = {
                    description = "Maximale Distanz zur Nutzung eines Krankenhausbetts.",
                    label = "Interaktionsdistanz",
                },
                hospitalBedsInteractKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Krankenbett bedienen",
                },
                hospitalBedsModels = {
                    description = "Weltobjekt-Modelle, die als nutzbare Krankenhausbetten behandelt werden.",
                    itemLabel = "Modell",
                    label = "Bettmodelle",
                },
                hospitalBedsSearchRadius = {
                    description = "Radius, um nahe Bett-Props oder konfigurierte Betten zu finden.",
                    label = "Suchradius",
                },
                hospitalBlipColor = {
                    description = "Blip-Farb-ID, die für Krankenhaus-Blips verwendet wird.",
                    label = "Farbe",
                },
                hospitalBlipEnabled = {
                    description = "Zeigt Blips für konfigurierte Krankenhauspositionen an.",
                    label = "Aktiviert",
                },
                hospitalBlipName = {
                    description = "Ausweichname für das Krankenhaus-Blip, wenn kein Stationsname verfügbar ist.",
                    label = "Bezeichnung",
                },
                hospitalBlipScale = {
                    description = "Blip-Größe, die für Krankenhaus-Blips verwendet wird.",
                    label = "Größe",
                },
                hospitalBlipSprite = {
                    description = "Blip-Sprite-ID, die für Krankenhaus-Blips verwendet wird.",
                    label = "Sprite",
                },
                imagingInteractionRange = {
                    description = "Maximale Distanz zur Bildgebungsstation für die bedienende Person.",
                    label = "Interaktionsreichweite",
                },
                imagingPatientRange = {
                    description = "Maximale Distanz zur Bildgebungsstation für den Patienten.",
                    label = "Patientenreichweite",
                },
                imagingScanDurationSeconds = {
                    description = "Dauer in Sekunden für CT- und MRT-Scanergebnisse.",
                    label = "Scandauer",
                },
                injuryEffectsBleedingOverlayIntensity = {
                    description = "Rein visueller Multiplikator für Blutungs-Overlay-Effekte.",
                    label = "Intensität des Blutungs-Overlays",
                },
                injuryEffectsPainScreenIntensity = {
                    description = "Rein visueller Multiplikator für Schmerz-Bildschirmeffekte.",
                    label = "Intensität des Schmerz-Bildschirmeffekts",
                },
                injuryThresholdBleedingPainMinPercent = {
                    description = "Mindestprozentsatz der maximalen Gesundheit, der bei einem einzelnen Treffer verloren gehen muss, bevor Blutung und Schmerz angewendet werden.",
                    label = "Mindestprozent für Blutung/Schmerz",
                },
                injuryThresholdRespectArmor = {
                    description = "Überspringt Blutung und Schmerz, wenn der Treffer von der Rüstung absorbiert wurde.",
                    label = "Rüstung berücksichtigen",
                },
                knockoutRegenerateDamage = {
                    description = "Regeneriert den Knockout-Schaden, nachdem der Respawn-Timer abgelaufen ist.",
                    label = "Schaden regenerieren",
                },
                knockoutRegenerateDurationSeconds = {
                    description = "Sekunden, über die der Knockout-Schaden zurückgeheilt wird.",
                    label = "Regenerationsdauer",
                },
                knockoutRespawnSeconds = {
                    description = "Sekunden bis zum automatischen Respawn, wenn ein Spieler K.o. geht.",
                    label = "Respawn-Sekunden",
                },
                knockoutWeapons = {
                    description = "Waffennamen oder Hashes, die einen Knockout statt des vollständigen Todesbildschirms auslösen sollen.",
                    itemLabel = "Waffe",
                    label = "Waffen",
                },
                legShotRagdollChance = {
                    description = "Prozentchance, dass ein passender Treffer Ragdoll auslöst.",
                    label = "Wahrscheinlichkeit",
                },
                legShotRagdollCooldownMs = {
                    description = "Mindestverzögerung zwischen Beinschuss-Ragdolls.",
                    label = "Abkühlung ms",
                },
                legShotRagdollDebug = {
                    description = "Protokolliert Beinschuss-Ragdoll-Entscheidungen zum Testen.",
                    label = "Fehler",
                },
                legShotRagdollDurationMs = {
                    description = "Wie lange der Ragdoll-Zustand anhält.",
                    label = "Dauer ms",
                },
                legShotRagdollFeet = {
                    description = "Erlaubt Fuß-Treffer als Auslöser.",
                    label = "Füße",
                },
                legShotRagdollIgnoreArmorHits = {
                    description = "Überspringt Ragdoll, wenn die Rüstung den Treffer absorbiert hat.",
                    label = "Rüstungstreffer ignorieren",
                },
                legShotRagdollLeftLowerLeg = {
                    description = "Erlaubt Treffer am linken Unterschenkel.",
                    label = "Linkes Unterschenkel",
                },
                legShotRagdollLeftUpperLeg = {
                    description = "Erlaubt Treffer am linken Oberschenkel.",
                    label = "Linkes Oberschenkel",
                },
                legShotRagdollOnlyGunshots = {
                    description = "Nur Schusswaffen dürfen Ragdoll auslösen.",
                    label = "Nur Schüsse",
                },
                legShotRagdollRightLowerLeg = {
                    description = "Erlaubt Treffer am rechten Unterschenkel.",
                    label = "Rechtes Unterschenkel",
                },
                legShotRagdollRightUpperLeg = {
                    description = "Erlaubt Treffer am rechten Oberschenkel.",
                    label = "Rechtes Oberschenkel",
                },
                liveDamageFracturesChance = {
                    description = "Grundwahrscheinlichkeit, dass ein Treffer bei Bewusstsein eine Fraktur auslöst.",
                    label = "Wahrscheinlichkeit",
                },
                liveDamageFracturesEnabled = {
                    description = "Erlaubt, dass Treffer bei Bewusstsein Frakturen auslösen können.",
                    label = "Aktiviert",
                },
                liveDamageFracturesMinDamagePercent = {
                    description = "Mindestanteil der maximalen Gesundheit, der durch einen Treffer verloren gehen muss, bevor eine Fraktur ausgelöst werden kann.",
                    label = "Mindestschaden in Prozent",
                },
                liveDamageFracturesZones = {
                    description = "Frakturwahrscheinlichkeiten pro Zone bei Schaden im Bewusstsein.",
                    label = "Zonen-Wahrscheinlichkeiten",
                },
                liveOpenWoundStacksDefault = {
                    description = "Maximale offene-Wunden-Stacks pro Zone ohne Zonen-Override.",
                    label = "Standardlimit",
                },
                liveOpenWoundStacksZones = {
                    description = "Optionale offene-Wunden-Stack-Limits pro Zone.",
                    itemLabel = "Gebiet",
                    label = "Zonenlimits",
                },
                liveWoundBleedingClassProfiles = {
                    description = "Anfängliche Blutungsklasse pro Ursache von Schaden im Bewusstsein.",
                    label = "Blutungsklasse aktiver Wunden",
                },
                medicCarryAllowCarrierInVehicle = {
                    description = "Erlaubt dem Träger, ein Fahrzeug zu betreten und zu fahren, ohne den Patienten abzulegen.",
                    label = "Träger im Fahrzeug erlauben",
                },
                medicCarryAllowConsciousTargets = {
                    description = "Erlaubt das Tragen bewusster Spieler.",
                    label = "Bewusste Ziele erlauben",
                },
                medicCarryAllowSprint = {
                    description = "Erlaubt Sprinten beim Tragen eines Patienten.",
                    label = "Sprinten erlauben",
                },
                medicCarryAttachBone = {
                    description = "Knochenindex zur Anheftung des getragenen Spielers.",
                    label = "Anheftungsknochen",
                },
                medicCarryAttachOffsetsPitch = {
                    description = "Neigungsrotation der Trage-Anheftung.",
                    label = "Neigung",
                },
                medicCarryAttachOffsetsRoll = {
                    description = "Rollwinkel-Rotation der Trage-Anheftung.",
                    label = "Rollwinkel",
                },
                medicCarryAttachOffsetsX = {
                    description = "X-Versatz der Trage-Anheftung.",
                    label = "Versatz X",
                },
                medicCarryAttachOffsetsY = {
                    description = "Y-Versatz der Trage-Anheftung.",
                    label = "Versatz Y",
                },
                medicCarryAttachOffsetsYaw = {
                    description = "Gierwinkel-Rotation der Trage-Anheftung.",
                    label = "Gierwinkel",
                },
                medicCarryAttachOffsetsZ = {
                    description = "Z-Versatz der Trage-Anheftung.",
                    label = "Versatz Z",
                },
                medicCarryCarrierAnimationDict = {
                    description = "Anim Dict des Sanitäters beim Tragen eines Patienten.",
                    label = "Anim Dict",
                },
                medicCarryCarrierAnimationFlag = {
                    description = "TaskPlayAnim-Flag für die Sanitäter-Trage-Animation.",
                    label = "Animations-Flag",
                },
                medicCarryCarrierAnimationName = {
                    description = "Animationsclip des Sanitäters beim Tragen eines Patienten.",
                    label = "Animationsname",
                },
                medicCarryEnabled = {
                    description = "Aktiviert das Sanitäter-Trage-System.",
                    label = "Aktiviert",
                },
                medicCarryMaxDistance = {
                    description = "Maximale Distanz zum Aufnehmen eines Patienten.",
                    label = "Maximale Distanz",
                },
                medicCarryPassengerAnimationDict = {
                    description = "Anim Dict des getragenen Patienten.",
                    label = "Anim Dict",
                },
                medicCarryPassengerAnimationFlag = {
                    description = "TaskPlayAnim-Flag für die Animation des getragenen Patienten.",
                    label = "Animations-Flag",
                },
                medicCarryPassengerAnimationName = {
                    description = "Animationsclip des getragenen Patienten.",
                    label = "Animationsname",
                },
                medicCarryReapplyDeathAnimation = {
                    description = "Wendet die Todesanimation erneut an, nachdem ein bewusstloser Patient abgesetzt wurde.",
                    label = "Todesanimation erneut anwenden",
                },
                medicCarryRequireOnDuty = {
                    description = "Nur Sanitäter im Dienst können einen Tragevorgang starten.",
                    label = "Dienst erforderlich",
                },
                medicReviveAllowFatalWounds = {
                    description = "Erlaubt diensthabenden Medizinern, Patienten mit tödlichen oder nicht wiederbelebbaren Verletzungen zu behandeln und wiederzubeleben. Ein abgelaufener Bleedout bleibt gesperrt.",
                    label = "Tödliche Verletzungen erlauben",
                },
                medicRevivePersistenceKeepInjuries = {
                    description = "Behält ungelöste Verletzungen nach Behandlungs- oder Checklisten-Wiederbelebungen bei.",
                    label = "Verletzungen beibehalten",
                },
                medicRevivePersistenceKeepPain = {
                    description = "Behält Schmerzwerte nach Behandlungs- oder Checklisten-Wiederbelebungen bei, wenn Verletzungen erhalten bleiben.",
                    label = "Schmerz beibehalten",
                },
                medicalEvaluationPatientSelectionRange = {
                    description = "Maximale Entfernung, in der Spieler beim Erstellen eines medizinischen Gutachtens angezeigt werden.",
                    label = "Patientenradius",
                },
                medicalEvaluationRecipientJobs = {
                    description = "Jobs, für die medizinische Gutachten ausgestellt und freigegeben werden dürfen.",
                    label = "Empfänger-Jobs",
                },
                medicalEvaluationShareBirthDate = {
                    description = "Erlaubt Empfänger-Jobs, das Geburtsdatum des Patienten zu sehen.",
                    label = "Geburtsdatum teilen",
                },
                medicalEvaluationShareConclusion = {
                    description = "Erlaubt Empfänger-Jobs, das medizinische Fazit zu sehen.",
                    label = "Fazit teilen",
                },
                medicalEvaluationShareEvaluationTypes = {
                    description = "Erlaubt Empfänger-Jobs zu sehen, welche Gutachtenarten durchgeführt wurden.",
                    label = "Gutachtenarten teilen",
                },
                medicalEvaluationShareFullName = {
                    description = "Erlaubt Empfänger-Jobs, den vollständigen Namen des Patienten zu sehen.",
                    label = "Vollständigen Namen teilen",
                },
                medicalEvaluationShareGender = {
                    description = "Erlaubt Empfänger-Jobs, das Geschlecht des Patienten zu sehen.",
                    label = "Geschlecht teilen",
                },
                medicalEvaluationShareHeight = {
                    description = "Erlaubt Empfänger-Jobs, die Größe des Patienten zu sehen.",
                    label = "Größe teilen",
                },
                medicalEvaluationShareHobbies = {
                    description = "Erlaubt Empfänger-Jobs, Freizeitaktivitäten und Hobbys des Patienten zu sehen.",
                    label = "Freizeit und Hobbys teilen",
                },
                medicalEvaluationShareIssuer = {
                    description = "Den Namen des Autors anzeigen. Der ausstellende Job bleibt als Ordner unter Geteilte Dokumente sichtbar.",
                    label = "Autorendaten teilen",
                },
                medicalEvaluationSharePersonalId = {
                    description = "Erlaubt Empfänger-Jobs, die Personalausweis-ID des Patienten zu sehen.",
                    label = "Personalausweis teilen",
                },
                medicalEvaluationShareProfession = {
                    description = "Erlaubt Empfänger-Jobs, den Beruf des Patienten zu sehen.",
                    label = "Beruf teilen",
                },
                medicalEvaluationShareQuestionnaireAnswers = {
                    description = "Erlaubt Empfänger-Jobs, Fragebogenfragen und die erfassten Antworten zu sehen.",
                    label = "Fragen und Antworten teilen",
                },
                medicalEvaluationShareResult = {
                    description = "Erlaubt Empfänger-Jobs zu sehen, ob das Gutachten offen, bestanden oder nicht bestanden ist.",
                    label = "Ergebnis teilen",
                },
                medicalEvaluationShareWeight = {
                    description = "Erlaubt Empfänger-Jobs, das Gewicht des Patienten zu sehen.",
                    label = "Gewicht teilen",
                },
                medicalEvaluationTypes = {
                    description = "Konfiguriert Gutachtenarten, Fragen, Antworttypen und ob einzelne Fragen aktiv sind.",
                    label = "Gutachtenarten und Fragebögen",
                    options = {
                        boolean = "Ja / Nein",
                        boolean_text = "Ja / Nein mit Details",
                        date = "Datum",
                        multi_select = "Mehrfachauswahl",
                        number = "Zahl",
                        rating = "Bewertung",
                        select = "Einfachauswahl",
                        text = "Wortlaut",
                        textarea = "Textbereich",
                        time = "Uhrzeit",
                    },
                },
                medicalEvaluationsEnabled = {
                    description = "Aktiviert medizinische Gutachten im Rettungsdienst-Tablet.",
                    label = "Aktiviert",
                },
                medicalWearablesAllowUntilRemoved = {
                    description = "Bietet eine dauerhafte Laufzeit an, die aktiv bleibt, bis ein Sanitäter das medizinische Hilfsmittel entfernt.",
                    label = "Bis zur Entfernung erlauben",
                },
                medicalWearablesArmCastsDisableMelee = {
                    description = "Verhindert Nahkampfangriffe, solange ein Armgips getragen wird.",
                    label = "Nahkampf deaktivieren",
                },
                medicalWearablesArmCastsDisableWeapons = {
                    description = "Erzwingt unbewaffneten Zustand und verhindert Waffenwechsel, solange ein Armgips getragen wird.",
                    label = "Waffen deaktivieren",
                },
                medicalWearablesArmCastsRestrictionsEnabled = {
                    description = "Wendet Kampfeinschränkungen an, solange ein Armgips getragen wird.",
                    label = "Aktiviert",
                },
                medicalWearablesAutoFromFractures = {
                    description = "Behandelt passende Frakturen, wenn ein Gips oder eine Schiene angelegt wird.",
                    label = "Fraktur-Integration",
                },
                medicalWearablesCastsEnabled = {
                    description = "Erlaubt Gipsverbände für linken/rechten Arm und linkes/rechtes Bein.",
                    label = "Aktiviert",
                },
                medicalWearablesCastsItem = {
                    description = "Inventar-Item, das beim Anlegen eines Gipsverbands verbraucht wird.",
                    label = "Gegenstand",
                },
                medicalWearablesCastsMinigame = {
                    description = "Vorhandenes Behandlungs-Minispiel für Gipsverbände.",
                    label = "Minispiel",
                },
                medicalWearablesDefaultDurationMinutes = {
                    description = "Standarddauer eines medizinischen Hilfsmittels in Minuten. 0 bedeutet bis zur Entfernung.",
                    label = "Standarddauer in Minuten",
                },
                medicalWearablesDurationOptionsMinutes = {
                    description = "Auswahlmöglichkeiten für die Tragedauer medizinischer Hilfsmittel, die Sanitätern in Minuten angezeigt werden.",
                    label = "Dauerauswahl",
                },
                medicalWearablesEnabled = {
                    description = "Aktiviert Gips-, Schienen-, Verband-, Halskrausen- und Sauerstoffmasken-Props in der Behandlungsoberfläche.",
                    label = "Aktiviert",
                },
                medicalWearablesExpiryCheckSeconds = {
                    description = "Intervall, in dem abgelaufene zeitgesteuerte medizinische Hilfsmittel entfernt werden.",
                    label = "Ablaufprüfung in Sekunden",
                },
                medicalWearablesHeadBandageEnabled = {
                    description = "Erlaubt das Kopfverband-Prop.",
                    label = "Aktiviert",
                },
                medicalWearablesHeadBandageItem = {
                    description = "Inventar-Item, das für einen Kopfverband verbraucht wird.",
                    label = "Gegenstand",
                },
                medicalWearablesHeadBandageMinigame = {
                    description = "Vorhandenes Behandlungs-Minispiel für einen Kopfverband.",
                    label = "Minispiel",
                },
                medicalWearablesLegCastsDisableJump = {
                    description = "Verhindert Springen, solange ein Beingips getragen wird.",
                    label = "Springen deaktivieren",
                },
                medicalWearablesLegCastsDisableSprint = {
                    description = "Verhindert Sprinten, solange ein Beingips getragen wird.",
                    label = "Sprinten deaktivieren",
                },
                medicalWearablesLegCastsForceInjuredWalk = {
                    description = "Erzwingt das verletzte Bewegungs-Clipset, solange ein Beingips getragen wird.",
                    label = "Verletzten Gang erzwingen",
                },
                medicalWearablesLegCastsMoveRate = {
                    description = "Überschreibt die Bewegungsgeschwindigkeit, solange ein Beingips getragen wird.",
                    label = "Bewegungsgeschwindigkeit",
                },
                medicalWearablesLegCastsRestrictionsEnabled = {
                    description = "Wendet Bewegungseinschränkungen an, solange ein Beingips getragen wird.",
                    label = "Aktiviert",
                },
                medicalWearablesNeckBraceEnabled = {
                    description = "Erlaubt das Halskrausen-Prop.",
                    label = "Aktiviert",
                },
                medicalWearablesNeckBraceItem = {
                    description = "Inventar-Item, das für eine Halskrause verbraucht wird.",
                    label = "Gegenstand",
                },
                medicalWearablesNeckBraceMinigame = {
                    description = "Vorhandenes Behandlungs-Minispiel für eine Halskrause.",
                    label = "Minispiel",
                },
                medicalWearablesOxygenMaskEnabled = {
                    description = "Erlaubt das Sauerstoffmasken-Prop.",
                    label = "Aktiviert",
                },
                medicalWearablesOxygenMaskItem = {
                    description = "Inventar-Item, das für eine Sauerstoffmaske verbraucht wird.",
                    label = "Gegenstand",
                },
                medicalWearablesOxygenMaskMinigame = {
                    description = "Vorhandenes Behandlungs-Minispiel für eine Sauerstoffmaske.",
                    label = "Minispiel",
                },
                medicalWearablesPatientHudEnabled = {
                    description = "Zeigt Patienten ihre aktiven medizinischen Hilfsmittel und die verbleibende Tragedauer.",
                    label = "Aktiviert",
                },
                medicalWearablesPatientHudPosition = {
                    description = "Wählt die Position der Patientenanzeige für medizinische Hilfsmittel.",
                    label = "Platzieren",
                    options = {
                        ["bottom-center"] = "Unten Mitte",
                        ["bottom-left"] = "Unten links",
                        ["bottom-right"] = "Unten rechts",
                        center = "Mitte",
                        ["center-left"] = "Mitte links",
                        ["center-right"] = "Mitte rechts",
                        ["top-center"] = "Oben Mitte",
                        ["top-left"] = "Oben links",
                        ["top-right"] = "Oben rechts",
                    },
                },
                medicalWearablesPersistence = {
                    description = "Stellt zeitgesteuerte Gipse, Schienen, Halskrausen und Oberkörperverbände nach Reconnects und Ressourcen-Neustarts wieder her.",
                    label = "Hilfsmittel speichern",
                },
                medicalWearablesRemoval = {
                    description = "Erlaubt Sanitätern, aktive Gipse, Schienen, Halskrausen und Oberkörperverbände in der Behandlungsoberfläche zu entfernen.",
                    label = "Entfernung durch Sanitäter",
                },
                medicalWearablesRemovalTreatmentEnabled = {
                    description = "Zeigt die Entfernung medizinischer Hilfsmittel mit dem konfigurierten Werkzeug in der Behandlungsoberfläche an.",
                    label = "Entfernungsbehandlung aktiviert",
                },
                medicalWearablesRemovalTreatmentItem = {
                    description = "Wiederverwendbares Inventarwerkzeug, das zum Entfernen eines medizinischen Hilfsmittels benötigt wird.",
                    label = "Gegenstand",
                },
                medicalWearablesRemovalTreatmentMinigame = {
                    description = "Minispiel beim Entfernen medizinischer Hilfsmittel (standardmäßig cast_saw).",
                    label = "Minispiel",
                },
                medicalWearablesSplintsEnabled = {
                    description = "Erlaubt Armschlingen-Schienen für den linken und rechten Arm.",
                    label = "Aktiviert",
                },
                medicalWearablesSplintsItem = {
                    description = "Inventar-Item, das beim Anlegen einer Schiene verbraucht wird.",
                    label = "Gegenstand",
                },
                medicalWearablesSplintsMinigame = {
                    description = "Vorhandenes Behandlungs-Minispiel für Schienen.",
                    label = "Minispiel",
                },
                medicalWearablesTorsoBandageEnabled = {
                    description = "Erlaubt das Oberkörperverband-Prop.",
                    label = "Aktiviert",
                },
                medicalWearablesTorsoBandageItem = {
                    description = "Inventar-Item, das für einen Oberkörperverband verbraucht wird.",
                    label = "Gegenstand",
                },
                medicalWearablesTorsoBandageMinigame = {
                    description = "Vorhandenes Behandlungs-Minispiel für einen Oberkörperverband.",
                    label = "Minispiel",
                },
                medicationsProfiles = {
                    description = "Deklarative Medikamenteneinträge für Behandlung und Selbstmedikation.",
                    itemLabel = "Medikament",
                    label = "Medikamente",
                },
                minigamesBagValveMaskEnabled = {
                    description = "Aktiviert das Beatmungsbeutel-Minispiel.",
                    label = "Beatmungsbeutel",
                },
                minigamesCastSawEnabled = {
                    description = "Aktiviert das Gipssägen-Minispiel zum Entfernen medizinischer Hilfsmittel.",
                    label = "Gipssäge",
                },
                minigamesBandageWrapEnabled = {
                    description = "Aktiviert das Minispiel zum Verbandswickeln.",
                    label = "Verbandswickeln",
                },
                minigamesBandageWrapRandomization = {
                    description = "Variiert Richtung, Form und Proportionen des Mullpfads zufällig.",
                    label = "Variation beim Verbandwickeln",
                },
                minigamesBloodPressureEnabled = {
                    description = "Aktiviert das Blutdruck-Minispiel.",
                    label = "Blutdruck",
                },
                minigamesBloodTransfusionAccessRandomization = {
                    description = "Variiert den venösen Zugangsweg für Bluttransfusionen zufällig.",
                    label = "Variation des Transfusionszugangs",
                },
                minigamesBloodTransfusionEnabled = {
                    description = "Aktiviert das Bluttransfusions-Minispiel.",
                    label = "Bluttransfusion",
                },
                minigamesBloodTransfusionVenousAccess = {
                    description = "Erfordert vor der Flusskontrolle den mehrstufigen venösen Zugang. Deaktivieren, um die alte einfache Version zu verwenden.",
                    label = "Venöser Zugang",
                },
                minigamesBulletExtractionEnabled = {
                    description = "Aktiviert das Minispiel zur Kugelentfernung.",
                    label = "Kugelentfernung",
                },
                minigamesBulletExtractionRandomization = {
                    description = "Variiert Form, Breite und Hindernisse des Wundkanals zufällig.",
                    label = "Variation der Geschossextraktion",
                },
                minigamesCprBreathsPerCycle = {
                    description = "Erforderliche Atemzüge in jeder Beatmungsphase.",
                    label = "Atemzüge pro Zyklus",
                },
                minigamesCprCompressionDurationPerSet = {
                    description = "Sekunden zum Abschließen eines Kompressionssatzes.",
                    label = "Kompressionsdauer pro Satz",
                },
                minigamesCprCompressionWindow = {
                    description = "Erlaubte Abweichung beim Treffen eines Kompressionstakts.",
                    label = "Kompressions-Zeitfenster",
                },
                minigamesCprCompressionsEnabled = {
                    description = "Aktiviert die Kompressionsphase des CPR-Minispiels.",
                    label = "CPR-Kompressionen",
                },
                minigamesCprCompressionsPerSet = {
                    description = "Anzahl der Kompressionen pro Satz.",
                    label = "Kompressionen pro Satz",
                },
                minigamesCprCycles = {
                    description = "Wie viele CPR-Zyklen zum Abschluss des Minispiels benötigt werden.",
                    label = "Zyklen",
                },
                minigamesCprEnabled = {
                    description = "Aktiviert das CPR-Minispiel.",
                    label = "CPR",
                },
                minigamesCprIntroDelaySeconds = {
                    description = "Countdown, bevor die CPR-Kompressionen beginnen.",
                    label = "Einleitungsverzögerung (Sekunden)",
                },
                minigamesCprMaxMisses = {
                    description = "Erlaubte Fehlschläge, bevor das CPR-Minispiel fehlschlägt.",
                    label = "Maximale Fehlschläge",
                },
                minigamesCprSetsPerCycle = {
                    description = "Wie viele Kompressionssätze vor einer Atemphase ablaufen.",
                    label = "Sätze pro Zyklus",
                },
                minigamesCprVentilationEnabled = {
                    description = "Aktiviert die Beatmungsphase des CPR-Minispiels.",
                    label = "CPR-Beatmung",
                },
                minigamesGlucoseMeterEnabled = {
                    description = "Aktiviert das Blutzuckermessungs-Minispiel.",
                    label = "Blutzuckermessgerät",
                },
                minigamesPulseMeasurementEnabled = {
                    description = "Aktiviert das Pulsmessungs-Minispiel.",
                    label = "Pulsmessung",
                },
                minigamesPulseOximeterEnabled = {
                    description = "Aktiviert das Pulsoximeter-Minispiel.",
                    label = "Pulsoximeter",
                },
                minigamesSalineInfusionEnabled = {
                    description = "Aktiviert das Kochsalzinfusions-Minispiel.",
                    label = "Kochsalzinfusion",
                },
                minigamesVentilationBreathTimeoutSeconds = {
                    description = "Sekunden, bevor ein Beatmungsversuch abläuft. Auf 0 setzen, um zu deaktivieren.",
                    label = "Atemzug-Timeout (Sekunden)",
                },
                minigamesVentilationEnabled = {
                    description = "Aktiviert das Beatmungs-Minispiel.",
                    label = "Beatmung",
                },
                minigamesVentilationTolerance = {
                    description = "Pixelabstand-Toleranz beim Nachzeichnen der Luftstromwelle.",
                    label = "Toleranz",
                },
                operationsBreakDistance = {
                    description = "Maximale Entfernung der Teilnehmer zum Raum, bevor der Eingriff abgebrochen wird.",
                    label = "Abbruchdistanz",
                },
                operationsDoctorAnimationDict = {
                    description = "GTA-Anim Dict für den Arzt während eines echten Eingriffs.",
                    label = "Arzt-Anim Dict",
                },
                operationsDoctorAnimationFlag = {
                    description = "GTA-Animations-Flag für die Arztanimation während eines echten Eingriffs.",
                    label = "Arzt-Animations-Flag",
                },
                operationsDoctorAnimationName = {
                    description = "Animationsclip für den Arzt während eines echten Eingriffs.",
                    label = "Arzt-Animationsname",
                },
                operationsEnabled = {
                    description = "Aktiviert Operationsräume und chirurgische Eingriffe.",
                    label = "Aktiviert",
                },
                operationsFadeInMs = {
                    description = "Dauer der Bildschirmeinblendung des Patienten beim Aufwachen in Millisekunden.",
                    label = "Einblenden beim Aufwachen (ms)",
                },
                operationsFadeOutMs = {
                    description = "Dauer der Bildschirmausblendung des Patienten bei der Narkose in Millisekunden.",
                    label = "Ausblenden bei Narkose (ms)",
                },
                operationsIdleTimeoutSeconds = {
                    description = "Maximale Zeit ohne gültige Minispielaktion, bevor die Sitzung abgebrochen wird.",
                    label = "Zeitlimit bei Inaktivität (Sekunden)",
                },
                operationsInteractDistance = {
                    description = "Maximale Entfernung, in der Operationsraum-Interaktionen angezeigt und verwendet werden können.",
                    label = "Interaktionsdistanz",
                },
                operationsInteractKey = {
                    description = "Control-ID für Interaktionen mit Operationsbett und Arztposition.",
                    label = "Interaktionstaste",
                },
                operationsPatientAnimationDict = {
                    description = "GTA-Anim Dict für den Patienten während der Vollnarkose auf dem Operationsbett.",
                    label = "Patienten-Anim Dict",
                },
                operationsPatientAnimationFlag = {
                    description = "GTA-Animations-Flag für die Liegeanimation des Patienten.",
                    label = "Patienten-Animations-Flag",
                },
                operationsPatientAnimationName = {
                    description = "Animationsclip für den Patienten während der Vollnarkose auf dem Operationsbett.",
                    label = "Patienten-Animationsname",
                },
                operationsPatientRange = {
                    description = "Maximaler Radius, in dem ein Patient auf dem Operationsbett erkannt wird.",
                    label = "Patientenradius",
                },
                operationsRequireOnDuty = {
                    description = "Operierende Ärzte müssen im Dienst sein, bevor sie einen Operationsraum verwenden dürfen.",
                    label = "Dienst erforderlich",
                },
                operationsSelectionTimeoutSeconds = {
                    description = "Maximale Zeit, die der Arzt in der Operationsauswahl bleiben darf, bevor die Sitzung abgebrochen wird.",
                    label = "Zeitlimit für Auswahl (Sekunden)",
                },
                operationsTrainingAnimationDict = {
                    description = "GTA-Anim Dict für das OP-Training ohne Patienten.",
                    label = "Trainings-Anim Dict",
                },
                operationsTrainingAnimationFlag = {
                    description = "GTA-Animations-Flag für die OP-Trainingsanimation.",
                    label = "Trainings-Animations-Flag",
                },
                operationsTrainingAnimationName = {
                    description = "Animationsclip für das OP-Training ohne Patienten.",
                    label = "Trainings-Animationsname",
                },
                painClassesProfiles = {
                    description = "Schmerzschwellenwerte, Bezeichnungen und Postprocessing-Effekte.",
                    label = "Schmerzklassen",
                },
                painEffectsMinPainLevel = {
                    description = "Mindest-Schmerzlevel, bevor Bildschirmeffekte für Schmerz einsetzen.",
                    label = "Mindest-Schmerzlevel",
                },
                primaryColor = {
                    description = "Hauptfarbe für die Rettungsdienst-Oberfläche und die Rettungsdienst-Jobgruppe.",
                    label = "Primärfarbe",
                },
                propPlacementConsumeItem = {
                    description = "Verbraucht den passenden Inventargegenstand, wenn das Prop platziert wird.",
                    label = "Gegenstand verbrauchen",
                },
                propPlacementEnabled = {
                    description = "Erlaubt das Platzieren konfigurierter EMS-Props aus nutzbaren Inventargegenständen.",
                    label = "Aktiviert",
                },
                propPlacementItemNames = {
                    description = "Ordnet EMS-Prop-Modelle Inventar-Gegenstandsnamen für die gegenstandsbasierte Platzierung zu.",
                    label = "Prop-Gegenstandsnamen",
                },
                propPlacementRequireOnDuty = {
                    description = "Erfordert, dass der Spieler im Dienst ist, bevor EMS-Props platziert werden können.",
                    label = "Dienst erforderlich",
                },
                propPlacementReturnItem = {
                    description = "Gibt den verbrauchten Gegenstand zurück, wenn ein platziertes Prop entfernt wird.",
                    label = "Gegenstand beim Entfernen zurückgeben",
                },
                propPlacementVehicleAccess = {
                    description = "Erlaubt, dass Kofferraum-Props den Platzierungsablauf öffnen, statt nur per Gegenstand nutzbar zu sein.",
                    label = "Fahrzeug-Zugriff",
                },
                publicTreatmentAllowConsciousPatients = {
                    description = "Erlaubt die öffentliche Behandlung bei bewussten Spielern.",
                    label = "Bewusste Patienten erlauben",
                },
                publicTreatmentAllowedGangs = {
                    label = "Erlaubte Gangs",
                    description = "Wähle interne Gang- oder Organisationsnamen. Ein passender Job oder eine passende Gang gewährt die Freigabe bzw. Ausnahme. Dienstpflicht gilt nur für Jobs. Optionale Gang-Mindestränge. Leer erlaubt alle Ränge. Anforderungen an Items gelten weiterhin.",
                },
                publicTreatmentAllowedJobs = {
                    description = "Jobs, die die öffentliche Behandlung nutzen dürfen, ohne EMS zu sein.",
                    label = "Erlaubte Jobs",
                },
                publicTreatmentEnabled = {
                    description = "Aktiviert die öffentliche Behandlung für Nicht-EMS-Helfer mit gültigem Zugriff.",
                    label = "Öffentliche Behandlung aktiviert",
                },
                publicTreatmentInteractDistance = {
                    description = "Maximale Distanz zum Starten der öffentlichen Behandlung.",
                    label = "Interaktionsdistanz",
                },
                publicTreatmentKeybind = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Erste Hilfe leisten",
                },
                publicTreatmentInteractionEnabled = {
                    description = "Behandlungshinweis anzeigen und die zugehörige Taste aktivieren. Bei Verwendung von Exports oder einem eigenen Radialmenü deaktivieren.",
                    label = "Tastaturinteraktion aktiviert",
                },
                publicTreatmentPromptDistance = {
                    description = "Distanz, ab der der Hinweis zur öffentlichen Behandlung angezeigt wird.",
                    label = "Hinweisdistanz",
                },
                publicTreatmentRequireAllItems = {
                    description = "Erfordert jeden aufgelisteten medizinischen Gegenstand statt nur einen.",
                    label = "Alle Gegenstände erforderlich",
                },
                publicTreatmentRequiredItems = {
                    description = "Inventargegenstände, die als gültige Ausrüstung für die öffentliche Behandlung zählen.",
                    itemLabel = "Gegenstand",
                    label = "Erforderliche Gegenstände",
                },
                reviveRewardAccount = {
                    description = "Primärer Kontoschlüssel für Wiederbelebungs-Belohnungszahlungen.",
                    label = "Konto",
                },
                reviveRewardAccountType = {
                    description = "Primärer Kontotyp für Wiederbelebungs-Belohnungszahlungen.",
                    label = "Kontotyp",
                },
                reviveRewardAmount = {
                    description = "Belohnungsbetrag, der dem Sanitäter für eine Wiederbelebung ausgezahlt wird.",
                    label = "Betrag",
                },
                reviveRewardCurrency = {
                    description = "Optionaler eigener Währungsschlüssel für Wiederbelebungs-Belohnungszahlungen.",
                    label = "Währung",
                },
                reviveRewardEnabled = {
                    description = "Zahlt eine konfigurierte Belohnung nach einer erfolgreichen Wiederbelebung durch einen Sanitäter aus.",
                    label = "Aktiviert",
                },
                reviveRewardPayFromSociety = {
                    description = "Zieht Wiederbelebungs-Belohnungen vom gemeinsamen Society-Konto des Jobs ab, bevor der Sanitäter bezahlt wird.",
                    label = "Aus Society-Konto zahlen",
                },
                selfDiagnoseCommand = {
                    description = "Chat-Befehl zum Öffnen der Selbstdiagnose.",
                    label = "Befehl",
                },
                selfDiagnoseEnabled = {
                    description = "Erlaubt Spielern, die Diagnose-UI bei sich selbst zu öffnen.",
                    label = "Selbstdiagnose aktiviert",
                },
                selfDiagnoseKeybind = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Selbstdiagnose",
                },
                selfDiagnoseOpenDelayMs = {
                    description = "Verzögerung, bevor die Selbstdiagnose-UI geöffnet wird.",
                    label = "Öffnungsverzögerung (ms)",
                },
                selfDiagnoseRequireMedicJob = {
                    description = "Beschränkt die Selbstdiagnose auf Sanitäter-Jobs.",
                    label = "Sanitäter-Job erforderlich",
                },
                selfDiagnoseSkipFreezeOnSelf = {
                    description = "Friert den Spieler während der Selbstdiagnose nicht ein.",
                    label = "Einfrieren bei sich selbst überspringen",
                },
                statusEffectsProfiles = {
                    description = "Konfigurierte Bildschirmeffekte und Schwellenwerte für Blutung, niedriges Blutvolumen, Hunger und Durst.",
                    label = "Statuseffekte",
                },
                stretcherAnimDict = {
                    description = "Anim Dict, das beim Tragen der Trage verwendet wird.",
                    label = "Anim Dict",
                },
                stretcherAnimName = {
                    description = "Animationsname, der beim Tragen der Trage verwendet wird.",
                    label = "Animationsname",
                },
                stretcherAttachRx = {
                    description = "X-Rotation der Trage-Anheftung beim Tragen.",
                    label = "Anheftung RX",
                },
                stretcherAttachRy = {
                    description = "Y-Rotation der Trage-Anheftung beim Tragen.",
                    label = "Anheftung RY",
                },
                stretcherAttachRz = {
                    description = "Z-Rotation der Trage-Anheftung beim Tragen.",
                    label = "Anheftung RZ",
                },
                stretcherAttachX = {
                    description = "X-Versatz der Trage-Anheftung beim Tragen.",
                    label = "Anheftung X",
                },
                stretcherAttachY = {
                    description = "Y-Versatz der Trage-Anheftung beim Tragen.",
                    label = "Anheftung Y",
                },
                stretcherAttachZ = {
                    description = "Z-Versatz der Trage-Anheftung beim Tragen.",
                    label = "Anheftung Z",
                },
                stretcherFoldedEnabled = {
                    description = "Aktiviert die optionale zusammengeklappte Tragen-Variante in Fahrzeugen.",
                    label = "Zusammengeklappt aktiviert",
                },
                stretcherFoldedModel = {
                    description = "Prop-Modell für die zusammengeklappte Tragen-Variante.",
                    label = "Zusammengeklapptes Modell",
                },
                stretcherFoldedPatientAttachHeading = {
                    description = "Ausrichtung des Patienten bei der zusammengeklappten Tragen-Variante.",
                    label = "Zusammengeklappt Patienten-Ausrichtung",
                },
                stretcherFoldedPatientAttachX = {
                    description = "X-Versatz der Patienten-Anheftung bei der zusammengeklappten Trage.",
                    label = "Zusammengeklappt Patient X",
                },
                stretcherFoldedPatientAttachY = {
                    description = "Y-Versatz der Patienten-Anheftung bei der zusammengeklappten Trage.",
                    label = "Zusammengeklappt Patient Y",
                },
                stretcherFoldedPatientAttachZ = {
                    description = "Z-Versatz der Patienten-Anheftung bei der zusammengeklappten Trage.",
                    label = "Zusammengeklappt Patient Z",
                },
                stretcherHelicopterInteractDistance = {
                    description = "Überschreibung der Interaktionsdistanz für Helikopter.",
                    label = "Helikopter-Interaktionsdistanz",
                },
                stretcherHelicopterModels = {
                    description = "Fahrzeugmodelle, die als Trage-Helikopter behandelt werden.",
                    itemLabel = "Modell",
                    label = "Helikoptermodelle",
                },
                stretcherHelicopterPickupDistance = {
                    description = "Überschreibung der Aufnahmedistanz für Helikopter.",
                    label = "Helikopter-Aufnahmedistanz",
                },
                stretcherInteractDistance = {
                    description = "Maximale Distanz für Interaktionshinweise der Trage.",
                    label = "Interaktionsdistanz",
                },
                stretcherItemEnabled = {
                    description = "Aktiviert das Tragen-Inventaritem einschließlich Kauf im Shop und Verwendung.",
                    label = "Tragen-Item",
                },
                stretcherItemPickupEnabled = {
                    description = "Erlaubt, Tragen, die über den Inventargegenstand platziert wurden, wieder ins Inventar aufzunehmen.",
                    label = "Item-Aufnahme",
                },
                stretcherModel = {
                    description = "Primäres Trage-Prop-Modell des EMS-Tragesystems.",
                    label = "Modell",
                },
                stretcherPatientAnimationDict = {
                    description = "Anim Dict für Tragenpatienten und den Vorschau-NPC.",
                    label = "Anim Dict des Patienten",
                },
                stretcherPatientAnimationName = {
                    description = "Animationsclip für Tragenpatienten und den Vorschau-NPC.",
                    label = "Animationsname des Patienten",
                },
                stretcherPatientAttachHeading = {
                    description = "Ausrichtung des Patienten beim Liegen auf der Trage.",
                    label = "Patienten-Ausrichtung",
                },
                stretcherPatientAttachX = {
                    description = "X-Versatz der Patienten-Anheftung auf der Trage.",
                    label = "Patient X",
                },
                stretcherPatientAttachY = {
                    description = "Y-Versatz der Patienten-Anheftung auf der Trage.",
                    label = "Patient Y",
                },
                stretcherPatientAttachZ = {
                    description = "Z-Versatz der Patienten-Anheftung auf der Trage.",
                    label = "Patient Z",
                },
                stretcherPickupDistance = {
                    description = "Erforderliche Distanz, um die Trage aufzunehmen und mit ihr zu interagieren.",
                    label = "Aufnahmedistanz",
                },
                stretcherTreatmentAnimClip = {
                    description = "Animationsclip bei der Behandlung eines Patienten auf einer Trage. Leer lassen, um ein Szenario oder die Standard-Behandlungsanimation zu verwenden.",
                    label = "Animationsname",
                },
                stretcherTreatmentAnimDict = {
                    description = "Anim Dict bei der Behandlung eines Patienten auf einer Trage. Leer lassen, um ein Szenario oder die Standard-Behandlungsanimation zu verwenden.",
                    label = "Anim Dict",
                },
                stretcherTreatmentAnimScenario = {
                    description = "Optionales Szenario bei der Behandlung eines Patienten auf einer Trage. Leer lassen, um Dictionary + Clip oder die Standard-Behandlungsanimation zu verwenden.",
                    label = "Szenario",
                },
                stretcherVehicleAttachEditor = {
                    description = "Positioniert und dreht die Trage in einem konfigurierten Rettungsfahrzeug.",
                    label = "Fahrzeugbefestigung",
                },
                stretcherVehicleAttachRx = {
                    description = "X-Rotation der Fahrzeug-Anheftung beim Verladen der Trage.",
                    label = "Fahrzeug RX",
                },
                stretcherVehicleAttachRy = {
                    description = "Y-Rotation der Fahrzeug-Anheftung beim Verladen der Trage.",
                    label = "Fahrzeug RY",
                },
                stretcherVehicleAttachRz = {
                    description = "Z-Rotation der Fahrzeug-Anheftung beim Verladen der Trage.",
                    label = "Fahrzeug RZ",
                },
                stretcherVehicleAttachX = {
                    description = "X-Versatz der Fahrzeug-Anheftung beim Verladen der Trage.",
                    label = "Fahrzeug X",
                },
                stretcherVehicleAttachY = {
                    description = "Y-Versatz der Fahrzeug-Anheftung beim Verladen der Trage.",
                    label = "Fahrzeug Y",
                },
                stretcherVehicleAttachZ = {
                    description = "Z-Versatz der Fahrzeug-Anheftung beim Verladen der Trage.",
                    label = "Fahrzeug Z",
                },
                stretcherVehicleModels = {
                    description = "Fahrzeugmodelle, die die Trage verladen dürfen.",
                    itemLabel = "Modell",
                    label = "Fahrzeugmodelle",
                },
                treatmentAnimClip = {
                    description = "Animationsclip bei der Behandlung eines Patienten. Leer lassen, um stattdessen ein Szenario zu verwenden.",
                    label = "Animationsname",
                },
                treatmentAnimDict = {
                    description = "Anim Dict bei der Behandlung eines Patienten. Leer lassen, um stattdessen ein Szenario zu verwenden.",
                    label = "Anim Dict",
                },
                treatmentAnimScenario = {
                    description = "Szenario bei der Behandlung eines Patienten. Leer lassen, um stattdessen Dictionary + Clip zu verwenden.",
                    label = "Szenario",
                },
                trunkPropsEnabled = {
                    label = "Fahrzeug-Props",
                    description = "Props direkt am Dienstfahrzeug auswählen.",
                },
                trunkEnabled = {
                    description = "Aktiviert die Kofferraum-Funktion für Rettungsdienstfahrzeuge.",
                    label = "Aktiviert",
                },
                vehicleDamageModifier = {
                    description = "Schadensmultiplikator, der angewendet wird, während sich der Spieler in einem Fahrzeug befindet.",
                    label = "Fahrzeugschaden-Multiplikator",
                },
                vehicleImpactProtectionCauses = {
                    description = "Todesursachen, die als geschützte Fahrzeugaufpralle zählen sollen.",
                    itemLabel = "Ursache",
                    label = "Schadensursachen",
                },
                vehicleImpactProtectionEnabled = {
                    description = "Verhindert, dass Fahrzeugaufpralle bei niedriger Geschwindigkeit den Spieler töten.",
                    label = "Aktiviert",
                },
                vehicleImpactProtectionFatalSpeedKmh = {
                    description = "Fahrzeugaufpralle unterhalb dieser Geschwindigkeit können den Spieler nicht töten.",
                    label = "Tödliche Geschwindigkeit (km/h)",
                },
                vehicleImpactProtectionFullDamageSpeedKmh = {
                    description = "Fahrzeugaufpralle bei oder über dieser Geschwindigkeit verwenden die normale Todesverletzungs-Konfiguration.",
                    label = "Vollschadensgeschwindigkeit (km/h)",
                },
                vehicleImpactProtectionInjuries = {
                    description = "Verletzungen, die angewendet werden, wenn der Fahrzeugaufprallschutz einen tödlichen Treffer verhindert.",
                    itemLabel = "Verletzung",
                    label = "Verletzungen",
                },
                vehicleImpactProtectionSurvivalHealthPercent = {
                    description = "Prozentsatz der maximalen Gesundheit, der erhalten bleibt, wenn ein geschützter Aufprall den Spieler getötet hätte.",
                    label = "Überlebens-Gesundheitsprozentsatz",
                },
                vehiclePullEnabled = {
                    description = "Aktiviert das Herausziehen von Patienten aus Fahrzeugen.",
                    label = "Aktiviert",
                },
                vehiclePullMaxDistance = {
                    description = "Maximale Distanz, um einen Patienten aus einem Fahrzeug zu ziehen.",
                    label = "Maximale Distanz",
                },
                wheelchairAssignMaxDistance = {
                    description = "Maximale Distanz zum Zuweisen eines Rollstuhls an einen anderen Spieler.",
                    label = "Maximale Zuweisungsdistanz",
                },
                wheelchairAutoUnequipOnExpire = {
                    description = "Legt den Rollstuhl automatisch ab, wenn die Zuweisung abläuft.",
                    label = "Automatisch ablegen bei Ablauf",
                },
                wheelchairDefaultDurationMinutes = {
                    description = "Standard-Zuweisungsdauer des Rollstuhls in Minuten.",
                    label = "Standarddauer",
                },
                wheelchairDisableSprint = {
                    description = "Blockiert Sprinten, während der Rollstuhl genutzt wird.",
                    label = "Sprinten deaktivieren",
                },
                wheelchairDisableWeapons = {
                    description = "Blockiert die Waffennutzung, während der Rollstuhl genutzt wird.",
                    label = "Waffen deaktivieren",
                },
                wheelchairExitControl = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Rollstuhl verlassen",
                },
                wheelchairItemName = {
                    description = "Inventargegenstand für den Rollstuhl.",
                    label = "Gegenstandsname",
                },
                wheelchairMaxDurationMinutes = {
                    description = "Maximal erlaubte Zuweisungsdauer des Rollstuhls in Minuten.",
                    label = "Maximaldauer",
                },
                wheelchairMinDurationMinutes = {
                    description = "Minimal erlaubte Zuweisungsdauer des Rollstuhls in Minuten.",
                    label = "Mindestdauer",
                },
                wheelchairVehicle = {
                    description = "Fahrzeugmodell für den Rollstuhl.",
                    label = "Fahrzeugmodell",
                },
                xrayInteractionRange = {
                    description = "Maximale Distanz zur Röntgenstation für die bedienende Person.",
                    label = "Interaktionsreichweite",
                },
                xrayPatientRange = {
                    description = "Maximale Distanz zur Röntgenstation für den Patienten.",
                    label = "Patientenreichweite",
                },
                xrayScanDurationSeconds = {
                    description = "Dauer in Sekunden für das Röntgen-Scanergebnis.",
                    label = "Scandauer",
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
                firstAidPublicTreatmentConflict = "Erste Hilfe und Öffentliche Behandlung können nicht gleichzeitig aktiviert sein. Beim Speichern werden beide deaktiviert.",
            },
        },
    },
}
