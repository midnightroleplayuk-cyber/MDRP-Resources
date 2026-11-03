JobConfigLocales["sky_mechanicjob:de"] = {
    Nui = {
        workshopConfig = {
            advancedPricingPreview = {
                compact = "Honda / Kompaktwagen",
                customer = "Kundenpreis",
                description = "Beispielrechnung für ein Cosmetic mit den aktuellen Regeln.",
                labor = "Arbeitskosten",
                live = "Live-Vorschau",
                margin = "Marge",
                sports = "Sportwagen",
                super = "Supersportwagen",
                supplier = "Lieferant",
                title = "Preisvorschau",
            },
            configs = {
                sky_mechanicjob = {
                    subtitle = "Konfiguriere Mechaniker-Jobs, Shops, Fahrzeuge und Werkstatt-Locations.",
                    title = "Mechaniker-Jobs",
                },
            },
            creatorSections = {
                mobileDyno = {
                    entryLabel = "Mobile Prüfstandanlage",
                    entryPluralLabel = "Mobile Prüfstandanlagen",
                    label = "Mobile Prüfstandanlagen",
                },
                workshops = {
                    entryLabel = "Werkstatt",
                    entryPluralLabel = "Werkstätten",
                    label = "Werkstätten",
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
            diagnosticsSettings = {
                enabledLabel = "Fahrzeugdiagnose aktivieren",
                enabledDescription = "Erlaubt diesem Job, die Fahrzeugdiagnose zu öffnen und darüber Teile zu reparieren.",
            },
            extensions = {
                diagnosticsSettings = {
                    label = "Fahrzeugdiagnose",
                    description = "Konfiguriere den Zugriff dieses Jobs auf die Fahrzeugdiagnose.",
                },
                billingPrices = {
                    description = "Konfiguriere Rechnungspreise für Wartungs- und Reparaturverlaufseinträge. Der Aktions-Key wird gegen action_key, action_type oder die Arbeitsbezeichnung abgeglichen.",
                    label = "Abrechnungspreise",
                },
                billingSettings = {
                    description = "Konfiguriere das Mechaniker-Abrechnungsverhalten für diesen Job.",
                    label = "Abrechnung",
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
                partsDeliveryShop = "Teile-Liefershop",
                trainingSettings = {
                    description = "Konfiguriert Ausbildungszugriff, Anmeldungen, Freigaben und Lehrgangsplanung für diesen Job.",
                    label = "Ausbildungseinstellungen",
                },
                tuningCostProfile = {
                    description = "Konfiguriere für diesen Job Performance-, Optik-, Rad- und Spezialkosten. Kosten unterstützen benötigte Item-Arrays und gestufte Upgrade-Objekte.",
                    label = "Tuning-Preise",
                },
            },
            features = {
                tuningFreeCamera = {
                    label = "Freie Kamera im Tuning-Menü",
                    description = "Erlaubt das Ausblenden des Cursors mit der Leertaste für freie Kamerabewegung. Escape schließt das Menü weiterhin.",
                },
                tuningCamera = {
                    description = "Richtet die Kamera automatisch auf das ausgewählte Teil. Ausgeschaltet bleibt die normale Spielkamera.",
                    label = "Automatische Tuning-Kamera",
                },
                jgMileage = {
                    description = "JG Vehicle Mileage als Kilometerquelle nutzen, solange die Ressource läuft. Sonst nutzt das System Sky-Kilometerstände. JG HUD wird separat eingestellt.",
                    label = "JG Mileage",
                },
                jgHud = {
                    description = "Den ausgewählten Kilometerstand im JG HUD anzeigen. Funktioniert ohne JG Vehicle Mileage; HUD-Anbindung laut README einrichten.",
                    label = "JG HUD",
                },
                antiLag = {
                    description = "Aktiviert Anti-Lag-Einbau und Auspuffeffekte.",
                    label = "Anti-Lag",
                },
                brakeOverheating = {
                    description = "Aktiviert stufenweise Bremsenhitze, glühende Scheiben, kritische Funken und kurze Bremsaussetzer.",
                    label = "Bremsenüberhitzung",
                },
                carryItems = {
                    description = "Gelieferte Teile müssen durch die Werkstatt transportiert werden.",
                    label = "Physischer Teiletransport",
                },
                customHandling = {
                    description = "Aktiviert benutzerdefinierte Antriebs- und Handling-Abstimmung.",
                    label = "Custom Handling",
                },
                electronicTuning = {
                    description = "Aktiviert persistente ECU-, Licht- und Fahrerassistenz-Tuningoptionen.",
                    label = "Elektronik-Tuning",
                },
                handlingEditor = {
                    description = "Aktiviert den Admin-Editor und seine automatischen Regeln für Kennzeichen und Fahrzeugmodelle. Nach dem Ausschalten betroffene Fahrzeuge erneut ausparken, um bereits angewendete Werte zurückzusetzen.",
                    label = "Handling-Editor",
                },
                instantTuning = {
                    description = "Erlaubt direktes Tuning an konfigurierten öffentlichen Tuning-Punkten.",
                    label = "Sofortiges Tuning",
                },
                kuv = {
                    description = "Global für Mechaniker und Polizei aktivieren. Ausschalten blendet Prüfungen und Aktionen aus; gespeicherte Nachweise bleiben erhalten.",
                    label = "Fahrzeugtechnische Überprüfung",
                },
                mileageHud = {
                    description = "Zeigt Fahrzeug-Kilometer während der Fahrt an.",
                    label = "Kilometer-HUD",
                },
                mobileDyno = {
                    description = "Aktiviert den mobilen Leistungsprüfstand mit Bedien- und Ergebnisdisplay, Lüftersteuerung und Tablet-App.",
                    label = "Mobiler Leistungsprüfstand",
                },
                nitro = {
                    description = "Aktiviert Nitro-Einbau und Fahrzeug-Boost.",
                    label = "Nitro",
                },
                partsDelivery = {
                    description = "Aktiviert Werkstatt-Teilebestellungen und Lieferzonen.",
                    label = "Teilelieferung",
                },
                selfServiceOrderNotifications = {
                    description = "Benachrichtigt Mitarbeiter im Dienst, wenn ein Self-Service-Tuning-Auftrag erstellt wird.",
                    label = "Self-Service-Auftragsbenachrichtigungen",
                },
                stance = {
                    description = "Zeigt Stance-Anpassungen in allen Tuning-Menüs an und aktiviert das Stance-Kit-Item.",
                    label = "Stand",
                },
                stanceWheelSize = {
                    description = "Zeigt, speichert und übernimmt Radgrößen-Anpassungen in Stance.",
                    label = "Stance-Radgröße",
                },
                stanceWheelWidth = {
                    description = "Zeigt, speichert und übernimmt Radbreiten-Anpassungen in Stance.",
                    label = "Stance-Radbreite",
                },
                subscriptions = {
                    description = "Aktiviert Abo-Terminals, Abo-Verwaltung und Kundenrabatte der Werkstatt.",
                    label = "Werkstatt-Abonnements",
                },
                twoStep = {
                    description = "Aktiviert Two-Step-Launch-Control und Auspuffeffekte.",
                    label = "Two-Step",
                },
                vehicleMaintenanceNotifications = {
                    description = "Benachrichtigt Halter, wenn ihr Fahrzeug den konfigurierten Wartungsschwellenwert erreicht.",
                    label = "Fahrzeug-Wartungsbenachrichtigungen",
                },
                vehicleRegistration = {
                    description = "Global für Mechaniker und Polizei aktivieren. Unabhängig von der technischen Überprüfung ein- und ausschaltbar.",
                    label = "KFZ-Anmeldung",
                },
                wheelDamage = {
                    description = "Aktiviert realistischen Radschaden und Reparaturen.",
                    label = "Radschaden",
                },
                workshopLift = {
                    description = "Aktiviert nutzbare Hebebühnenpunkte in Werkstätten.",
                    label = "Werkstatt-Hebebühne",
                },
            },
            fields = {
                quantity = "Menge",
            },
            locationDescriptions = {
                vehicle_registry = "Setze den Punkt auf den Prüfplatz der Werkstatt. Für Fahrzeugprüfung und KFZ-Anmeldung muss das Fahrzeug innerhalb der eingestellten Prüfentfernung stehen.",
            },
            locationTypes = {
                mobile_dyno_monitor = {
                    description = "Standort des Dyno-Ergebnismonitors.",
                    label = "Dyno-Ergebnismonitor",
                },
                mobile_dyno_station = {
                    description = "Standort des mobilen Leistungsprüfstands.",
                    label = "Mobile Dyno-Station",
                },
                vehicle_registry = "Prüf- und Zulassungsplatz",
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
            settingFieldDescriptions = {
                radialEnabled = "Mechaniker-Abrechnung über das Radialmenü öffnen.",
                allowTuningInvoices = "Den Tuningwarenkorb dem nächsten Kunden in Rechnung stellen. Der Einbau wird nach vollständiger Zahlung freigegeben.",
                customerRange = "Maximale Entfernung in Metern für Rechnungen an Kunden in der Nähe.",
                allowAnalytics = "Erlaubt Abrechnungsauswertungen, sofern keine Rangregel dies überschreibt.",
                allowCustomPrices = "Erlaubt Mechanikern, die Preise von Rechnungspositionen vor dem Ausstellen zu ändern.",
                allowEstimates = "Erlaubt Kostenvoranschläge, die Kunden vor der Zahlung annehmen müssen.",
                allowImmediatePayment = "Erlaubt die direkte Bezahlung von Rechnungen dieses Jobs.",
                allowManualItems = "Erlaubt Mechanikern, eigene Rechnungspositionen zu erstellen.",
                allowPartialPayments = "Erlaubt Anzahlungen und mehrere Zahlungen auf eine Rechnung.",
                analyticsPeriodDays = "Anzahl der Tage in der Abrechnungsauswertung.",
                defaultDueDays = "Tage, bis eine Rechnung überfällig wird.",
                depositPercent = "Erforderlicher Anzahlungsprozentsatz nach Ausstellung einer Rechnung oder Annahme eines Kostenvoranschlags.",
                enabled = "Erlaubt diesem Job, die Mechaniker-Abrechnung zu verwenden.",
                estimateLifetimeHours = "Stunden, bis ein unbeantworteter Kostenvoranschlag abläuft.",
                gradeRules = "Rechnungslimits und verfügbare Aktionen für jeden Mechaniker-Rang.",
                maxDiscountPercent = "Größter Rabatt, den eine Rechnung erhalten darf.",
                maximumInvoiceAmount = "Globale Höchstsumme vor Rangbegrenzungen.",
                maximumManualItems = "Maximale Anzahl eigener Locations pro Dokument.",
                maximumReminders = "Maximale Anzahl an Mahnungen pro Rechnung.",
                minimumInvoiceAmount = "Mindestgesamtbetrag für Kostenvoranschläge und Rechnungen.",
                minimumPartialPayment = "Kleinste Teilzahlung, ausgenommen ein kleinerer Restbetrag oder eine kleinere Anzahlung.",
                reminderFee = "Gebühr, die bei jeder gültigen Mahnung hinzugefügt wird.",
                reminderGraceDays = "Überfällige Tage, bevor die erste Mahnung erlaubt ist.",
                taxPercent = "Steuer, die nach Rabatten hinzugefügt wird.",
            },
            settingFields = {
                radialEnabled = "Rechnung im Radialmenü",
                allowTuningInvoices = "Tuning per Rechnung",
                customerRange = "Kundenentfernung",
                allowAnalytics = "Buchhaltungsauswertung",
                allowCancellation = "Stornierung",
                allowCustomPrices = "Eigene Preise erlauben",
                allowEstimates = "Kostenvoranschläge erlauben",
                allowImmediatePayment = "Sofortzahlung erlauben",
                allowManualItems = "Eigene Locations erlauben",
                allowPartialPayments = "Teilzahlungen erlauben",
                allowReminders = "Mahnungen",
                amount = "Menge",
                analyticsPeriodDays = "Auswertungszeitraum",
                bone = "Knochen",
                category = "Kategorie",
                classId = "Klassen-ID",
                defaultDueDays = "Zahlungsziel in Tagen",
                depositPercent = "Anzahlung in Prozent",
                difficulty = "Schwierigkeit",
                enabled = "Aktiviert",
                estimateLifetimeHours = "Gültigkeit des Kostenvoranschlags",
                flow = "Einbau-Ablauf",
                grade = "Rang",
                gradeRules = "Rangregeln",
                item = "Gegenstand",
                key = "Schlüssel",
                kilometersToZero = "Kilometer bis 0",
                label = "Bezeichnung",
                laborFee = "Arbeitskosten",
                laborMultiplier = "Arbeitskostenfaktor",
                marginAdjustmentPercent = "Margenanpassung",
                marginPercent = "Marge %",
                maxDiscountPercent = "Maximaler Rabatt",
                maximumInvoiceAmount = "Höchstbetrag",
                maximumManualItems = "Maximale eigene Locations",
                maximumPrice = "Höchstmenge",
                maximumReminders = "Maximale Mahnungen",
                minimumInvoiceAmount = "Mindestbetrag",
                minimumPartialPayment = "Kleinste Teilzahlung",
                minimumPrice = "Mindestgehalt",
                multiplier = "Multiplikator",
                name = "Itemname",
                partKey = "Teile-Key",
                price = "Preis",
                priceType = "Preistyp",
                prop = "Objekt",
                reason = "Grund",
                reminderFee = "Mahngebühr",
                reminderGraceDays = "Mahnfrist",
                removeAfterUse = "Item verbrauchen",
                repair = "Mit Kit reparieren",
                repairItem = "Reparatur-Item",
                rx = "Rot X",
                ry = "Rot Y",
                rz = "Rot Z",
                supplierSharePercent = "Lieferant %",
                taxPercent = "Rechnungssteuer",
                transport = "Verkehr",
                x = "X",
                y = "Y",
                z = "Z",
                upgrade = "Upgrade",
                maximumDiscountPercent = "Maximaler Rabatt",
            },
            settingGroups = {
                antiExploit = {
                    label = "Exploit-Schutz",
                },
                coach = {
                    label = "Telemetrie-Coach",
                },
                cooldownMultipliers = {
                    label = "Abkühlungsfaktoren",
                },
                crashFalloff = {
                    label = "Verlust bei Unfall",
                },
                criticalEngine = {
                    label = "Defekter Motor",
                },
                deformation = {
                    label = "Verformung",
                },
                diagnostics = {
                    label = "Diagnose",
                },
                fade = {
                    label = "Bremswirkung bei Überhitzung",
                },
                features = {
                    label = "Funktionen",
                },
                format = {
                    label = "Format Seiten",
                },
                frontalImpact = {
                    label = "Schwerer Frontalaufprall",
                },
                general = {
                    label = "Allgemein",
                },
                heatMultipliers = {
                    label = "Erwärmungsfaktoren",
                },
                illegalMarket = {
                    label = "Illegaler Markt",
                },
                integration = {
                    label = "Integration",
                },
                items = {
                    label = "Gegenstände",
                },
                keybinds = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Tastenbelegung",
                },
                lifetime = {
                    label = "Laufzeit",
                },
                limits = {
                    label = "Speichergrenzen",
                },
                repairRestore = {
                    label = "Reparatur Rücksetzung",
                },
                risk = {
                    label = "Risiko",
                },
                rules = {
                    label = "Regeln",
                },
                safety = {
                    label = "Prüfung & Sicherheit",
                },
                stages = {
                    label = "Überhitzungsstufen",
                },
                tyreRepair = {
                    label = "Reifenreparatur",
                },
                visuals = {
                    label = "Visuelle Effekte",
                },
            },
            settingSections = {
                electronicTuning = "ECU-Motorsoftware",
                advancedPricing = "Erweiterte Preise",
                brakeOverheating = "Bremsenüberhitzung",
                carryItems = "Tragbare Teile",
                fakePlates = "Gefälschte Kennzeichen",
                firejobVehicleFires = "Fahrzeugbrände",
                general = "Allgemein",
                handlingEditor = "Handling-Editor",
                instantTuning = "Sofortiges Tuning",
                maintenanceNotifications = "Wartungsbenachrichtigungen",
                mileageHud = "Kilometer-HUD",
                mobileDyno = "Mobiler Leistungsprüfstand",
                oilLeaks = "Fahrzeug-Flüssigkeitslecks",
                partsTheft = "Teilediebstahl",
                subscriptions = "Abonnements",
                tuning = "Abstimmung",
                vehicleCare = "Fahrzeugpflege",
                vehicleRegistry = "Fahrzeugnachweise",
                wear = "Verschleiß",
                wheelDamage = "Radschaden",
            },
            settingSubsectionGroups = {
                handlingAdditional = "Zusatz",
                handlingAir = "Luft",
                handlingGeneral = "Allgemein",
                handlingRoad = "Straße",
                handlingWater = "Wasser",
            },
            settingSubsections = {
                mechanicHotkeys = "Tastenbelegung",
                database = "Datenbank",
                handlingEditorGeneral = "Editor-Einstellungen",
                handlingMaximumCBikeHandlingData = "Motorrad",
                handlingMaximumCBoatHandlingData = "Boot",
                handlingMaximumCCarHandlingData = "Auto",
                handlingMaximumCFlyingHandlingData = "Flugzeug",
                handlingMaximumCHandlingData = "Fahrzeugbasis",
                handlingMaximumCSeaPlaneHandlingData = "Wasserflugzeug",
                handlingMaximumCSpecialFlightHandlingData = "Spezialflug",
                handlingMaximumCSubmarineHandlingData = "U-Boot",
                handlingMaximumCTrailerHandlingData = "Anhänger",
                handlingMaximumCVehicleWeaponHandlingData = "Fahrzeugwaffen",
                keybinds = "Tastenbelegung",
                operation = "Betrieb",
                placementRules = "Aufstellregeln",
                testFlow = "Testablauf",
                tuning = "Sofort-Tuningoptionen",
            },
            settingValues = {
                air_filter = "Luftfilter",
                brake_fluid = "Bremsflüssigkeit",
                brake_pads = "Bremsbeläge",
                catalytic_converter = "Katalysator",
                clutch = "Kupplung",
                coolant = "Kühlmittel",
                engine_oil = "Motoröl",
                inverter = "Inverter",
                spark_plugs = "Zündkerzen",
                suspension = "Fahrwerk",
                traction_battery = "Traktionsbatterie",
                transmission_fluid = "Getriebeflüssigkeit",
                tyres = "Reifen",
                vehicleClass_0 = "Kompaktwagen",
                vehicleClass_1 = "Limousinen",
                vehicleClass_10 = "Industrie",
                vehicleClass_11 = "Nutzfahrzeuge",
                vehicleClass_12 = "Transporter",
                vehicleClass_13 = "Fahrräder",
                vehicleClass_14 = "Boote",
                vehicleClass_15 = "Helikopter",
                vehicleClass_16 = "Flugzeuge",
                vehicleClass_17 = "Wartung",
                vehicleClass_18 = "Einsatzfahrzeuge",
                vehicleClass_19 = "Militär",
                vehicleClass_2 = "Suvs",
                vehicleClass_20 = "Gewerbe",
                vehicleClass_21 = "Züge",
                vehicleClass_22 = "Open-Wheel",
                vehicleClass_3 = "Coupés",
                vehicleClass_4 = "Muscle Cars",
                vehicleClass_5 = "Sportklassiker",
                vehicleClass_6 = "Sportwagen",
                vehicleClass_7 = "Supersportwagen",
                vehicleClass_8 = "Motorräder",
                vehicleClass_9 = "Offroad",
            },
            settings = {
                vehiclePriceSource = {
                    label = "Quelle der Fahrzeugpreise",
                    description = "Automatisch: ESX-SQL; Fahrzeugkatalog bei QBCore/Qbox. Datenbank: konfigurierte SQL-Tabelle bei jedem Framework.",
                    options = {
                        auto = "Automatisch (Framework)",
                        database = "Datenbank",
                    },
                },
                vehiclePriceTable = {
                    label = "Tabelle für Fahrzeugpreise",
                    description = "Tabelle mit Kaufpreisen, z. B. dealership_vehicles (JG).",
                },
                vehiclePriceModelColumn = {
                    label = "Spalte für Spawnnamen",
                    description = "Spalte mit Spawnnamen, z. B. spawn_code (JG), nicht der Anzeigename.",
                },
                vehiclePricePriceColumn = {
                    label = "Preisspalte",
                    description = "Spalte mit numerischen Kaufpreisen, z. B. price.",
                },
                vehiclePriceHashColumn = {
                    label = "Modellhash-Spalte (optional)",
                    description = "Optionale numerische Hashspalte, z. B. hashkey (JG). Leer lassen, um Spawnnamen zu hashen.",
                },
                addRevenueToSociety = {
                    description = "Bezahlte Tuning-Aufträge werden auf das Firmenkonto des Tuning-Jobs eingezahlt.",
                    label = "Einnahmen einzahlen",
                },
                advancedPricingAlwaysAvailableItemCategories = {
                    description = "Kategorien des Teileliefer-Shops, die bei aktiver erweiterter Preisberechnung frei kaufbar bleiben. Groß-/Kleinschreibung und Leerzeichen werden ignoriert.",
                    itemLabel = "Kategorie",
                    label = "Dauerhaft verfügbare Kategorien",
                },
                advancedPricingAlwaysAvailableItemsEnabled = {
                    description = "Hält konfigurierte Shopartikel aus den ausgewählten Kategorien ohne Tuningauftrag verfügbar und berechnet sie über das dynamische Lieferantensystem.",
                    label = "Dauerhaft verfügbare Shopartikel",
                },
                advancedPricingAnalyticsPeriodDays = {
                    description = "Anzahl der Tage in der Tablet-Gewinnanalyse.",
                    label = "Auswertungszeitraum",
                },
                advancedPricingCategoryRules = {
                    description = "Lieferantenanteil, Marge, Arbeitskosten und Preisgrenzen je Tuning-Kategorie.",
                    label = "Kategorie-Regeln",
                },
                advancedPricingDefaultMarginPercent = {
                    description = "Mechanikermarge vor Anpassungen durch Fahrzeugklasse und Rang.",
                    label = "Standardmarge",
                },
                advancedPricingDifficultyRules = {
                    description = "Zusätzliche Arbeitskosten je Tuning-Schwierigkeit.",
                    label = "Schwierigkeitsregeln",
                },
                advancedPricingEnabled = {
                    description = "Berechnet Tuningpreise serverseitig neu und bindet Dynasty-Teile bei aktivierter Teilelieferung an den jeweiligen Tuningauftrag.",
                    label = "Erweiterte Preise aktivieren",
                },
                advancedPricingInventoryBaseStock = {
                    description = "Normaler virtueller Bestand je Lieferantenartikel.",
                    label = "Grundbestand",
                },
                advancedPricingInventoryDemandDecayPerDay = {
                    description = "Nachfragepunkte, die pro vergangenem Tag verfallen.",
                    label = "Täglicher Nachfrageabbau",
                },
                advancedPricingInventoryDemandMarkupPerUnitPercent = {
                    description = "Lieferantenaufschlag pro Nachfragepunkt.",
                    label = "Nachfrageaufschlag je Einheit",
                },
                advancedPricingInventoryEnabled = {
                    description = "Erhöht Lieferantenpreise bei geringem Bestand oder hoher Nachfrage.",
                    label = "Dynamischer Lieferantenbestand",
                },
                advancedPricingInventoryLowStockMarkupPercent = {
                    description = "Maximaler Lieferantenaufschlag durch knappen Bestand.",
                    label = "Niedrigbestand-Aufschlag",
                },
                advancedPricingInventoryLowStockThreshold = {
                    description = "Bestand, ab dem der Knappheitsaufschlag beginnt.",
                    label = "Niedrigbestand-Grenze",
                },
                advancedPricingInventoryMaximumDemandMarkupPercent = {
                    description = "Obergrenze für den Nachfrageaufschlag.",
                    label = "Maximaler Nachfrageaufschlag",
                },
                advancedPricingInventoryRestockPerDay = {
                    description = "Virtuelle Einheiten, die pro vergangenem Tag aufgefüllt werden.",
                    label = "Tägliche Auffüllung",
                },
                advancedPricingMaximumDiscountPercent = {
                    description = "Globale Rabattobergrenze für Mechanikerrechnungen.",
                    label = "Maximalrabatt",
                },
                advancedPricingMaximumMarginPercent = {
                    description = "Höchste zulässige Mechanikermarge.",
                    label = "Höchstmarge",
                },
                advancedPricingMaximumRetailPrice = {
                    description = "Globale Preisobergrenze für ein Tuningteil.",
                    label = "Höchstverkaufspreis",
                },
                advancedPricingMechanicGradeRules = {
                    description = "Aufschlag, Arbeitskosten und Rabattgrenzen je Mechaniker-Rang.",
                    label = "Mechaniker-Rangregeln",
                },
                advancedPricingMinimumMarginPercent = {
                    description = "Niedrigste zulässige Mechanikermarge.",
                    label = "Mindestmarge",
                },
                advancedPricingMinimumRetailPrice = {
                    description = "Globale Preisuntergrenze für ein Tuningteil.",
                    label = "Mindestverkaufspreis",
                },
                advancedPricingPreviewCompactValue = {
                    description = "Fahrzeugwert für die Kompaktwagen-Beispielrechnung.",
                    label = "Kompaktwagen-Beispielwert",
                },
                advancedPricingPreviewCostPercent = {
                    description = "Beispielhafter Tuning-Prozentsatz für die Live-Vorschau.",
                    label = "Vorschau-Tuningsatz",
                },
                advancedPricingPreviewSportsValue = {
                    description = "Fahrzeugwert für die Sportwagen-Beispielrechnung.",
                    label = "Sportwagen-Beispielwert",
                },
                advancedPricingPreviewSuperValue = {
                    description = "Fahrzeugwert für die Supercar-Beispielrechnung.",
                    label = "Supercar-Beispielwert",
                },
                advancedPricingQuoteLifetimeMinutes = {
                    description = "Minuten bis ein unbezahltes Angebot neu berechnet wird.",
                    label = "Angebotsgültigkeit",
                },
                advancedPricingReturnRefundPercent = {
                    description = "Erstatteter Anteil für ein bereits beschafftes, auftragsgebundenes Teil.",
                    label = "Rückgabe-Erstattung",
                },
                advancedPricingRoundingStep = {
                    description = "Rundet jede Dynasty-Beschaffungsposition auf diesen Geldschritt.",
                    label = "Rundungsschritt Lieferant",
                },
                advancedPricingSupplierSharePercent = {
                    description = "Prozentualer Anteil des Kundenpreises, den Dynasty Auto Supply für das Teil berechnet.",
                    label = "Lieferantenanteil",
                },
                advancedPricingTaxPercent = {
                    description = "Steuersatz, der in der Preisbuchhaltung getrennt gespeichert wird.",
                    label = "Steuer",
                },
                advancedPricingVehicleClassRules = {
                    description = "Margen- und Arbeitskostenanpassungen je GTA-Fahrzeugklasse.",
                    label = "Fahrzeugklassen-Regeln",
                },
                brakeOverheatingCooldownBrakeUpgradeMultipliers = {
                    label = "Abkühlen nach Bremsenupgrade",
                },
                brakeOverheatingCooldownClassMultipliers = {
                    label = "Abkühlen nach Fahrzeugklasse",
                },
                brakeOverheatingCoolingDelayMs = {
                    description = "Zeit in Millisekunden nach dem Bremsen, bevor die aktive Abkühlung beginnt.",
                    label = "Abkühlverzögerung",
                },
                brakeOverheatingCoolingPerSecond = {
                    description = "Hitze, die pro Sekunde ohne Betätigung der Bremse abgebaut wird.",
                    label = "Abkühlrate",
                },
                brakeOverheatingCriticalThreshold = {
                    description = "Hitzewert, ab dem Funken und kurze Bremsaussetzer auftreten können.",
                    label = "Schwelle Kritisch",
                },
                brakeOverheatingFadeChancePerSecond = {
                    description = "Chance von 0 bis 1 für einen kurzen Bremsaussetzer bei kritischer Hitze.",
                    label = "Aussetzerchance pro Sekunde",
                },
                brakeOverheatingFadeCooldownMs = {
                    label = "Aussetzer-Cooldown",
                },
                brakeOverheatingFadeMaximumDurationMs = {
                    label = "Längste Aussetzerzeit",
                },
                brakeOverheatingFadeMinimumDurationMs = {
                    label = "Kürzeste Aussetzerzeit",
                },
                brakeOverheatingHeatBrakeUpgradeMultipliers = {
                    label = "Aufheizen nach Bremsenupgrade",
                },
                brakeOverheatingHeatClassMultipliers = {
                    label = "Aufheizen nach Fahrzeugklasse",
                },
                brakeOverheatingHeatGainPerSecond = {
                    description = "Basis-Hitze pro Sekunde beim Bremsen mit Referenzgeschwindigkeit.",
                    label = "Hitzeaufbau",
                },
                brakeOverheatingHotThreshold = {
                    label = "Schwelle Heiß",
                },
                brakeOverheatingMinimumSpeedKmh = {
                    description = "Mindestgeschwindigkeit in km/h, ab der Bremsen Hitze erzeugen.",
                    label = "Mindestgeschwindigkeit beim Bremsen",
                },
                brakeOverheatingReferenceSpeedKmh = {
                    description = "Geschwindigkeit in km/h, bei der der konfigurierte Basis-Hitzeaufbau gilt.",
                    label = "Referenzgeschwindigkeit",
                },
                brakeOverheatingSparkMaximumIntervalMs = {
                    label = "Größtes Funkenintervall",
                },
                brakeOverheatingSparkMinimumIntervalMs = {
                    label = "Kleinstes Funkenintervall",
                },
                brakeOverheatingVisualDistance = {
                    description = "Maximale Entfernung in Metern für Glüh- und Funkeneffekte.",
                    label = "Effektdistanz",
                },
                brakeOverheatingWarmThreshold = {
                    label = "Schwelle Warm",
                },
                carryItems = {
                    description = "Gelieferte Teile, die als physisch getragene Props transportiert werden sollen.",
                    fields = {
                        transport = {
                            options = {
                                engine_lift = "Motorheber",
                                forklift = "Gabelstapler",
                                hand = "Hand",
                            },
                        },
                    },
                    itemLabel = "Tragbares Teil",
                    label = "Tragbare Teile",
                },
                ecuEngineTorqueStage1 = {
                    description = "1,00 bedeutet keinen zusätzlichen Boost; 1,10 erhöht das Drehmoment um 10 %. Gilt für Fahrzeuge mit dieser ECU-Stufe.",
                    label = "Drehmoment-Faktor Stufe 1",
                },
                ecuEngineTorqueStage2 = {
                    description = "1,00 bedeutet keinen zusätzlichen Boost; 1,10 erhöht das Drehmoment um 10 %. Gilt für Fahrzeuge mit dieser ECU-Stufe.",
                    label = "Drehmoment-Faktor Stufe 2",
                },
                ecuEngineTorqueStage3 = {
                    description = "1,00 bedeutet keinen zusätzlichen Boost; 1,10 erhöht das Drehmoment um 10 %. Gilt für Fahrzeuge mit dieser ECU-Stufe.",
                    label = "Drehmoment-Faktor Stufe 3",
                },
                ecuEngineTorqueStage4 = {
                    description = "1,00 bedeutet keinen zusätzlichen Boost; 1,10 erhöht das Drehmoment um 10 %. Gilt für Fahrzeuge mit dieser ECU-Stufe.",
                    label = "Drehmoment-Faktor Stufe 4",
                },
                fakePlatesAudit = {
                    label = "Audit-Log",
                },
                fakePlatesBlacklist = {
                    description = "Gesperrte Wörter oder Fragmente, die nicht in gefälschten Kennzeichen vorkommen dürfen.",
                    label = "Sperrliste",
                },
                fakePlatesBlankPlateItem = {
                    description = "Herstellungs-/Shopmaterial für den Wirtschaftskreislauf gefälschter Kennzeichen.",
                    label = "Leeres Kennzeichen-Item",
                },
                fakePlatesCooldownMinutes = {
                    label = "Cooldown in Minuten",
                },
                fakePlatesCrashFalloffChance = {
                    label = "Verlustchance",
                },
                fakePlatesCrashFalloffEnabled = {
                    label = "Verlust bei Unfall aktiviert",
                },
                fakePlatesCrashFalloffMinSpeedKmh = {
                    label = "Mindest-Unfallgeschwindigkeit",
                },
                fakePlatesEnabled = {
                    description = "Erlaubt Spielern, Kennzeichenfälschungs-Kits an Fahrzeugen zu verwenden.",
                    label = "Gefälschte Kennzeichen aktivieren",
                },
                fakePlatesExpireMinutes = {
                    description = "0 lässt gefälschte Kennzeichen aktiv, bis ein Reset oder die Neustartbehandlung sie entfernt.",
                    label = "Ablaufzeit in Minuten",
                },
                fakePlatesExpireOnRestart = {
                    label = "Bei Neustart entfernen",
                },
                fakePlatesIllegalMarketAccount = {
                    label = "Zahlungskonto",
                },
                fakePlatesIllegalMarketEnabled = {
                    label = "Illegaler Markt aktiviert",
                },
                fakePlatesIllegalMarketPrice = {
                    label = "Preis am illegalen Markt",
                },
                fakePlatesIllegalMarketRiskMultiplier = {
                    label = "Risikomultiplikator",
                },
                fakePlatesInstallDurationMs = {
                    label = "Einbaudauer in ms",
                },
                fakePlatesItem = {
                    description = "Einmal-Item, das den Einbau eines gefälschten Kennzeichens startet.",
                    label = "Kennzeichenfälschungs-Kit",
                },
                fakePlatesMaxLength = {
                    label = "Maximallänge",
                },
                fakePlatesMaxVehicleDistance = {
                    label = "Fahrzeugdistanz",
                },
                fakePlatesMinLength = {
                    label = "Mindestlänge",
                },
                fakePlatesPattern = {
                    description = "Lua-Muster zur Prüfung des Kennzeichentextes, zum Beispiel ^[A-Z0-9]+$.",
                    label = "Lua-Muster",
                },
                fakePlatesPlateInstallDistance = {
                    label = "Distanz zur Kennzeichenposition",
                },
                fakePlatesPreventDuplicateDisplayPlates = {
                    label = "Doppelte aktive Fälschungen blockieren",
                },
                fakePlatesPrinterItem = {
                    description = "Herstellungs-/Shopwerkzeug für den Wirtschaftskreislauf gefälschter Kennzeichen.",
                    label = "Kennzeichendrucker-Item",
                },
                fakePlatesRequireEngineOff = {
                    label = "Motor muss ausgeschaltet sein",
                },
                fakePlatesRequireOwnerOrKeys = {
                    description = "Verwendet Config.Functions.CanApplyFakePlate, bevor der Einbau erlaubt wird.",
                    label = "Halter oder Schlüssel erforderlich",
                },
                fakePlatesRequireStopped = {
                    label = "Fahrzeug muss stehen",
                },
                fakePlatesResetOnGarageStore = {
                    description = "Für Garagen-Integrationen vorgesehen, die das Reset-Event oder den Export aufrufen.",
                    label = "Beim Einlagern zurücksetzen",
                },
                fakePlatesRiskCharacters = {
                    label = "Tippfehlerzeichen",
                },
                fakePlatesRiskEnabled = {
                    label = "Risiko-Tippfehler aktiviert",
                },
                fakePlatesRiskTypoChance = {
                    label = "Tippfehlerchance",
                },
                fallbackVehicleValue = {
                    description = "Wert, der genutzt wird, wenn kein Fahrzeugpreis ermittelt werden kann.",
                    label = "Fallback-Fahrzeugwert",
                },
                firejobVehicleFiresCriticalChance = {
                    description = "Chance von 0 bis 1, nachdem der Motor kritisch bleibt.",
                    label = "Defekter-Motor-Brandchance",
                },
                firejobVehicleFiresCriticalCooldownSeconds = {
                    description = "Sekunden, bevor erneut ein Defekter-Motor-Brand auslösen kann.",
                    label = "Defekter-Motor-Cooldown",
                },
                firejobVehicleFiresCriticalDelayMs = {
                    description = "Verzögerung in Millisekunden, bevor ein defekter Motor entzünden kann.",
                    label = "Defekter-Motor-Verzögerung ms",
                },
                firejobVehicleFiresCriticalEnabled = {
                    description = "Erlaubt kritisch beschädigten Motoren, nach einer Verzögerung einen Firejob-Fahrzeugbrand zu starten.",
                    label = "Defekte Motoren entzünden",
                },
                firejobVehicleFiresCriticalSmokeDensity = {
                    description = "Rauchdichte für Brandanfragen bei defektem Motor.",
                    label = "Defekter-Motor-Rauchdichte",
                },
                firejobVehicleFiresEnabled = {
                    description = "Erlaubt Mechanicjob-Schadenssystemen, Fahrzeugbrände bei Firejob anzufordern.",
                    label = "Firejob-Fahrzeugbrände aktivieren",
                },
                firejobVehicleFiresForwardMotionRatio = {
                    description = "Nötiges Vorwärtsbewegungs-Verhältnis von 0 bis 1.",
                    label = "Vorwärtsbewegungs-Verhältnis",
                },
                firejobVehicleFiresImpactChance = {
                    description = "Chance von 0 bis 1, dass ein gültiger Aufprall einen Brand startet.",
                    label = "Aufprall-Brandchance",
                },
                firejobVehicleFiresImpactCooldownSeconds = {
                    description = "Sekunden, bevor erneut ein Aufprallbrand auslösen kann.",
                    label = "Aufprall-Brand-Cooldown",
                },
                firejobVehicleFiresImpactEnabled = {
                    description = "Erlaubt starken Frontalaufprallen, einen Firejob-Fahrzeugbrand anzufordern.",
                    label = "Nach schweren Unfällen entzünden",
                },
                firejobVehicleFiresImpactSmokeDensity = {
                    description = "Rauchdichte für brandausgelöste Anfragen nach einem Unfall.",
                    label = "Aufprall-Rauchdichte",
                },
                firejobVehicleFiresIntegrationMode = {
                    description = "Automatisch nutzt die konfigurierte Firejob-Ressource. Deaktiviert verhindert, dass Mechanicjob Feuer erstellt.",
                    label = "Integrationsmodus",
                    options = {
                        automatic = "Automatisch",
                        disabled = "Deaktiviert",
                    },
                },
                firejobVehicleFiresMinBodyHealthLoss = {
                    description = "Minimal verlorene Karosseriegesundheit während des Aufpralls.",
                    label = "Mindest-Karosserieschaden",
                },
                firejobVehicleFiresMinEngineHealthLoss = {
                    description = "Minimal verlorene Motorgesundheit während des Aufpralls.",
                    label = "Mindest-Motorschaden",
                },
                firejobVehicleFiresMinFrontDeformation = {
                    description = "Nutze 0, um diese Verformungsprüfung zu deaktivieren.",
                    label = "Mindest-Frontverformung",
                },
                firejobVehicleFiresMinImpactSpeedKmh = {
                    description = "Minimale Geschwindigkeit vor dem Aufprall in km/h.",
                    label = "Mindest-Aufprallgeschwindigkeit",
                },
                firejobVehicleFiresMinSpeedDropKmh = {
                    description = "Nötiger Geschwindigkeitsverlust in km/h während des Aufpralls.",
                    label = "Mindest-Geschwindigkeitsverlust",
                },
                firejobVehicleFiresResource = {
                    description = "Ressource, die Fahrzeugbrand-Anfragen empfängt.",
                    label = "Firejob-Ressource",
                },
                firejobVehicleFiresServerEvent = {
                    description = "Internes Serverevent, das der Mechanic-Client nutzt, um einen Firejob-Fahrzeugbrand anzufordern.",
                    label = "Mechanic-Serverevent",
                },
                freeVehicles = {
                    description = "Spawn-Modelle, die kostenlose Tuning-Aufträge erhalten.",
                    itemLabel = "Fahrzeugmodell",
                    label = "Kostenlose Tuning-Fahrzeuge",
                },
                handlingEditorBlockCriticalValidation = {
                    description = "Verhindert Anwenden, solange ein kritischer Handling-Konflikt besteht.",
                    label = "Bei kritischen Befunden blockieren",
                },
                handlingEditorCoachMinimumBrakeDeceleration = {
                    description = "Erwartete maximale Verzögerung in m/s² für einen abgeschlossenen Bremstest.",
                    label = "Minimale Bremsverzögerung",
                },
                handlingEditorCoachMinimumSamples = {
                    description = "Benötigte Messpunkte, bevor der Telemetrie-Coach einen Lauf auswertet.",
                    label = "Mindestanzahl Messpunkte",
                },
                handlingEditorCoachWheelSlipWarningKmh = {
                    description = "Gemessener Radschlupf in km/h, ab dem Traktionsverlust gemeldet wird.",
                    label = "Radschlupf-Warnung",
                },
                handlingEditorDefaultTab = {
                    description = "Seite, die beim Öffnen des eigenständigen Handling-Editors ausgewählt wird.",
                    label = "Startseite",
                    options = {
                        advanced = "Erweitert",
                        export = "Ausfuhr",
                        flags = "Flaggen",
                        fleet = "Fuhrpark",
                        inspector = "Ebenen",
                        profiles = "Profile",
                        simple = "Einfach",
                        telemetry = "Telemetrie",
                    },
                },
                handlingEditorFieldDocumentationEnabled = {
                    description = "Erklärt Wirkung, Referenzbereich, Symptome, verbundene Felder und Live-Unterstützung für jeden Handling-Wert.",
                    label = "Felddokumentation",
                },
                handlingEditorFieldMaximum = {
                    description = "Fester Höchstwert, den der Editor für dieses Handling-Feld akzeptiert.",
                },
                handlingEditorFlagSearchEnabled = {
                    description = "Flag-Namen, Wirkungen, Bitpositionen und Hex-Masken suchen und filtern.",
                    label = "Flag-Suche",
                },
                handlingEditorFleetManagerEnabled = {
                    description = "Modell- und Kennzeichenregeln suchen, prüfen, veröffentlichen und wiederherstellen.",
                    label = "Fuhrpark-Manager",
                },
                handlingEditorFocusKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Zum Handling-Editor zurückkehren",
                },
                handlingEditorLayerInspectorEnabled = {
                    description = "Zeigt für jedes Feld Fahrzeugbasis, installiertes Custom Tuning, Modellregel, Kennzeichenregel und aktuellen Editor-Entwurf.",
                    label = "Ebenen-Inspektor",
                },
                handlingEditorMaxFleetResults = {
                    description = "Maximale Anzahl geladener Modell- und Kennzeichenregeln im Fuhrpark-Manager.",
                    label = "Fuhrpark-Ergebnislimit",
                },
                handlingEditorMaxProfileRevisions = {
                    description = "Maximal gespeicherte Revisionen pro Profil.",
                    label = "Profilrevisionen",
                },
                handlingEditorMaxWorkspacesPerAdmin = {
                    description = "Maximal gespeicherte Arbeitsbereiche pro Administrator.",
                    label = "Persönliche Arbeitsbereiche",
                },
                handlingEditorPayloadWarningBytes = {
                    description = "Kodierte Bytes, ab denen eine Editor-Anfrage, Antwort oder Momentaufnahme als groß gemeldet wird.",
                    label = "Grenzwert für große Payloads",
                },
                handlingEditorPerformanceChecksEnabled = {
                    description = "Misst Editor-Abläufe und warnt über Sky.Debug, wenn konfigurierte Grenzwerte überschritten werden.",
                    label = "Performance-Prüfungen",
                },
                handlingEditorPerformanceSummaryIntervalMs = {
                    description = "Millisekunden zwischen zusammengefassten Laufzeitberichten bei aktivierten ausführlichen Debug-Protokollen.",
                    label = "Zusammenfassungsintervall",
                },
                handlingEditorPerformanceWarningMs = {
                    description = "Millisekunden, ab denen ein gemessener Handling-Editor-Ablauf als langsam gemeldet wird.",
                    label = "Grenzwert für langsame Abläufe",
                },
                handlingEditorProfileVersioningEnabled = {
                    description = "Erzeugt bei jeder Aktualisierung oder Wiederherstellung eine nachvollziehbare Revision.",
                    label = "Profilversionierung",
                },
                handlingEditorSliderMaximumDeviationPercent = {
                    description = "Maximaler Prozentsatz, um den ein Zahlenregler von der eingelesenen Fahrzeugbasis nach oben oder unten abweichen darf. Direkte Eingaben und XML-Import bleiben verlustfrei. Ein vom Standard abweichender Feld-Höchstwert ersetzt die obere Reglergrenze.",
                    label = "Maximale Reglerabweichung",
                },
                handlingEditorTelemetryCoachEnabled = {
                    description = "Erstellt nachvollziehbare regelbasierte Empfehlungen aus gemessenen Testfahrtdaten.",
                    label = "Telemetrie-Coach",
                },
                handlingEditorValidatorEnabled = {
                    description = "Erkennt gefährliche oder widersprüchliche Kombinationen vor dem Anwenden.",
                    label = "Handling-Validator",
                },
                handlingEditorWorkspacesEnabled = {
                    description = "Erlaubt benannte private Editor-Entwürfe pro Administrator.",
                    label = "Persönliche Arbeitsbereiche",
                },
                instantTuningAllowedJobs = {
                    description = "Optionale globale Allowlist. Leer lassen, um alle zu erlauben, solange Nur-Mechaniker deaktiviert ist.",
                    itemLabel = "Jobname",
                    label = "Erlaubte Jobs",
                },
                instantTuningBlipColor = {
                    description = "GTA-Blip-Farb-ID.",
                    label = "Blip-Farbe",
                },
                instantTuningBlipEnabled = {
                    description = "Zeigt Karten-Blips für Instant-Tuning-Locations.",
                    label = "Blip aktiviert",
                },
                instantTuningBlipName = {
                    description = "Name des Karten-Blips.",
                    label = "Blip-Name",
                },
                instantTuningBlipSprite = {
                    description = "GTA-Blip-Sprite-ID.",
                    label = "Blip-Sprite",
                },
                instantTuningForceMarkerInteraction = {
                    description = "Nutze Marker-E-Interaktion, auch wenn Target-Support aktiv ist.",
                    label = "Marker-Interaktion erzwingen",
                },
                instantTuningInteractionDistance = {
                    description = "Standarddistanz zur Nutzung von Instant-Tuning-Punkten.",
                    label = "Interaktionsdistanz",
                },
                instantTuningLabel = {
                    description = "Standardtext an Instant-Tuning-Punkten.",
                    label = "Standard-Label",
                },
                instantTuningLocations = {
                    description = "Instant-Tuning-Punkte. Distanz 0 übernimmt die Standard-Interaktionsdistanz.",
                    itemLabel = "Locations",
                    label = "Locations",
                },
                instantTuningMarkerEnabled = {
                    description = "Zeichnet einen Weltmarker an Instant-Tuning-Locations.",
                    label = "Marker aktiviert",
                },
                instantTuningMarkerType = {
                    description = "GTA-Marker-Typ für Instant-Tuning-Locations.",
                    label = "Marker-Typ",
                },
                instantTuningMechanicOnly = {
                    description = "Beschränkt alle Instant-Tuning-Locations auf konfigurierte Mechaniker-Jobs.",
                    label = "Nur Mechaniker",
                },
                instantTuningRepairEnabled = {
                    label = "Fahrzeugreparatur",
                    description = "Fahrzeugreparatur an Sofort-Tuning-Punkten anbieten.",
                },
                instantTuningRepairPrice = {
                    label = "Reparaturpreis",
                    description = "Fester Reparaturpreis ohne Tuning-Preismultiplikator.",
                },
                instantTuningWashEnabled = {
                    label = "Fahrzeugwäsche",
                    description = "Fahrzeugwäsche an Sofort-Tuning-Punkten anbieten.",
                },
                instantTuningWashPrice = {
                    label = "Waschpreis",
                    description = "Fester Waschpreis ohne Tuning-Preismultiplikator.",
                },
                instantTuningPriceMultiplier = {
                    description = "Multiplikator für Instant-Tuning-Preise.",
                    label = "Preismultiplikator",
                },
                instantTuningProfile = {
                    description = "Konfiguriere, welche Tuning-Optionen an Instant-Tuning-Punkten verfügbar sind.",
                    label = "Instant-Tuning-Optionen",
                },
                maintenanceNotificationsCooldownMinutes = {
                    description = "Mindestanzahl an Minuten, bevor dasselbe Fahrzeug erneut eine Wartungserinnerung auslösen kann.",
                    label = "Benachrichtigungs-Cooldown",
                },
                maintenanceNotificationsEnabled = {
                    description = "Benachrichtigt Fahrzeughalter, wenn ein Verschleißteil den Wartungsschwellenwert erreicht.",
                    label = "Aktiviert",
                },
                maintenanceNotificationsThreshold = {
                    description = "Verschleißwert in Prozent, ab dem eine Wartung als fällig gilt.",
                    label = "Fälligkeitsschwelle",
                },
                mechanicCatalyticConverterCATALYTICACTIONCONTROL = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Katalysatordiebstahl · E",
                },
                mechanicCatalyticConverterCATALYTICCANCELCONTROL = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Katalysatordiebstahl · X",
                },
                mechanicDynoControl172 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Prüfstand · UP",
                },
                mechanicDynoControl173 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Prüfstand · DOWN",
                },
                mechanicDynoControl174 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Prüfstand · LEFT",
                },
                mechanicDynoControl175 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Prüfstand · RIGHT",
                },
                mechanicDynoControl177 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Prüfstand · BACK",
                },
                mechanicDynoControl38 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Prüfstand · E",
                },
                mechanicDynoControl45 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Prüfstand · R",
                },
                mechanicDynoControl47 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Prüfstand · G",
                },
                mechanicSprayPaintControl200 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Lackieren · ESCAPE",
                },
                mechanicSprayPaintControl202 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Lackieren · ESCAPE",
                },
                mechanicVehicleCareControl200 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Fahrzeugpflege · ESCAPE",
                },
                mechanicVehicleCareControl202 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Fahrzeugpflege · ESCAPE",
                },
                mechanicVehiclePushINPUTCONTEXT = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Fahrzeug schieben · E",
                },
                mechanicVehiclePushINPUTMOVEDOWN = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Fahrzeug schieben · S",
                },
                mechanicVehiclePushINPUTMOVELEFT = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Fahrzeug schieben · A",
                },
                mechanicVehiclePushINPUTMOVERIGHT = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Fahrzeug schieben · D",
                },
                mechanicVehiclePushINPUTMOVEUP = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Fahrzeug schieben · W",
                },
                mechanicVehiclePushINPUTSPRINT = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Fahrzeug schieben · LSHIFT",
                },
                mechanicWheelChangeControl200 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Radwechsel · ESCAPE",
                },
                mechanicWheelChangeControl202 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Radwechsel · ESCAPE",
                },
                mechanicWheelChangeControl22 = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Radwechsel · SPACE",
                },
                mechanicWheelTheftWHEELTHEFTACTIONCONTROL = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Raddiebstahl · E",
                },
                mechanicWheelTheftWHEELTHEFTCANCELCONTROL = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Raddiebstahl · X",
                },
                mileageHudDigits = {
                    description = "Anzahl der im Kilometer-HUD angezeigten Ziffern.",
                    label = "Ziffern",
                },
                mileageHudPosition = {
                    description = "Ziehe die Kilometer-HUD-Vorschau an die gewünschte Bildschirmposition.",
                    label = "Platzieren",
                },
                mobileDynoConsumeItem = {
                    description = "Nach erfolgreicher Platzierung ein Item entfernen.",
                    label = "Item verbrauchen",
                },
                mobileDynoCooldownMs = {
                    label = "Abkühldauer",
                },
                mobileDynoCountdownMs = {
                    label = "Start-Countdown",
                },
                mobileDynoDuiDistance = {
                    label = "Panel-Sichtweite",
                },
                mobileDynoFanInteractionDistance = {
                    description = "Interaktionsdistanz in Metern für den physischen Schalter zwischen den Lüftern.",
                    label = "Lüftersteuerungsdistanz",
                },
                mobileDynoFullLoadDurationMs = {
                    description = "Dauer der anhaltenden Volllaststufe in Millisekunden bei Profilen mit Volllastprüfung.",
                    label = "Volllastdauer",
                },
                mobileDynoHistoryLimit = {
                    label = "Historienlimit",
                },
                mobileDynoInteractionDistance = {
                    label = "Panel-Interaktionsdistanz",
                },
                mobileDynoItemUseEnabled = {
                    description = "Dyno und Monitor durch Benutzen eines Inventar-Items aufstellen.",
                    label = "Platzierung per Item",
                },
                mobileDynoMaxActiveSessions = {
                    label = "Limit aktiver Sitzungen",
                },
                mobileDynoMaxVehicleDistance = {
                    label = "Fahrzeug-Erfassungsdistanz",
                },
                mobileDynoMonitorItem = {
                    description = "Inventar-Item zum Aufstellen des Ergebnismonitors.",
                    label = "Monitor-Item",
                },
                mobileDynoPersistItems = {
                    description = "Neue Item-Platzierungen über Serverneustarts hinweg speichern.",
                    label = "Platzierungen speichern",
                },
                mobileDynoPickupDistance = {
                    description = "Maximale Entfernung in Metern zum Aufheben der Ausrüstung.",
                    label = "Aufhebeentfernung",
                },
                mobileDynoPlacementMaxHeightSpread = {
                    description = "Maximal zulässiger Bodenhöhenunterschied in Metern zwischen allen Prüfstand-Messpunkten.",
                    label = "Maximaler Höhenunterschied",
                },
                mobileDynoPlacementMaxSlopeDegrees = {
                    description = "Maximal zulässige Bodenneigung über den gesamten Prüfstand in Grad.",
                    label = "Maximale Stellflächenneigung",
                },
                mobileDynoRequireOnDuty = {
                    description = "Mechaniker müssen zum Aufstellen und Bedienen im Dienst sein.",
                    label = "Dienstpflicht",
                },
                mobileDynoResultDuiDistance = {
                    description = "Maximale Entfernung in Metern, in der der separate Ergebnismonitor gerendert wird.",
                    label = "Ergebnisdisplay-Sichtweite",
                },
                mobileDynoReturnItem = {
                    description = "Beim Aufheben das zuvor verbrauchte Item zurückgeben.",
                    label = "Item zurückgeben",
                },
                mobileDynoStationItem = {
                    description = "Inventar-Item zum Aufstellen des Prüfstands.",
                    label = "Dyno-Item",
                },
                mobileDynoTabletDistance = {
                    description = "Maximale Entfernung zum Prüfstand in Metern für Tablet-Bedienung und laufende Tests.",
                    label = "Tablet-Bedienreichweite",
                },
                nitroActivationKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Nitro halten",
                },
                oilLeaksCooldownSeconds = {
                    description = "Sekunden, bevor erneut ein Aufprallleck auslösen kann.",
                    label = "Aufprall-Cooldown",
                },
                oilLeaksEnabled = {
                    description = "Erlaubt beschädigten Verbrenner-Fahrzeugen, beim Fahren Flüssigkeit zu verlieren.",
                    label = "Flüssigkeitslecks aktivieren",
                },
                oilLeaksEngineOilChance = {
                    description = "Normale Leck-Chance von 0 bis 1.",
                    label = "Motoröl-Chance",
                },
                oilLeaksEngineOilCriticalChance = {
                    description = "Kritische Leck-Chance von 0 bis 1.",
                    label = "Kritische Motoröl-Chance",
                },
                oilLeaksEngineOilCriticalThreshold = {
                    description = "Motoröl-Zustand, ab dem die kritische Chance genutzt wird.",
                    label = "Kritische Motoröl-Schwelle",
                },
                oilLeaksEngineOilThreshold = {
                    description = "Motoröl-Zustand, ab dem ein Leck beginnen kann.",
                    label = "Motoröl-Schwelle",
                },
                oilLeaksForwardMotionRatio = {
                    description = "Nötiges Vorwärtsbewegungs-Verhältnis von 0 bis 1.",
                    label = "Vorwärtsbewegungs-Verhältnis",
                },
                oilLeaksFrontalImpactEnabled = {
                    description = "Erlaubt schweren Frontalaufprallen, temporäre Motorflüssigkeitslecks auszulösen.",
                    label = "Frontalaufprall-Lecks",
                },
                oilLeaksImpactChance = {
                    description = "Chance von 0 bis 1, dass ein gültiger Aufprall ein Leck startet.",
                    label = "Aufprall-Leck-Chance",
                },
                oilLeaksImpactRadius = {
                    description = "Radius des ersten Flüssigkeitspunkts, der durch einen Aufprall erzeugt wird.",
                    label = "Aufprall-Fleckradius",
                },
                oilLeaksIntervalSeconds = {
                    description = "Minimale Sekunden zwischen Spurpunkten.",
                    label = "Spurintervall",
                },
                oilLeaksLeakDurationSeconds = {
                    description = "Sekunden, die ein Leck nach einem gültigen Aufprall anhält.",
                    label = "Aufprall-Leckdauer",
                },
                oilLeaksMinBodyHealthLoss = {
                    description = "Minimal verlorene Karosseriegesundheit während des Aufpralls.",
                    label = "Mindest-Karosserieschaden",
                },
                oilLeaksMinDistance = {
                    description = "Minimale gefahrene Distanz zwischen Spurpunkten.",
                    label = "Spurdistanz",
                },
                oilLeaksMinEngineHealthLoss = {
                    description = "Minimal verlorene Motorgesundheit während des Aufpralls.",
                    label = "Mindest-Motorschaden",
                },
                oilLeaksMinFrontDeformation = {
                    description = "Nötige Frontverformung. Nutze 0, um diese Prüfung zu deaktivieren.",
                    label = "Mindest-Frontverformung",
                },
                oilLeaksMinImpactSpeedKmh = {
                    description = "Minimale Geschwindigkeit vor dem Aufprall in km/h.",
                    label = "Mindest-Aufprallgeschwindigkeit",
                },
                oilLeaksMinSpeedDropKmh = {
                    description = "Nötiger Geschwindigkeitsverlust in km/h während des Aufpralls.",
                    label = "Mindest-Geschwindigkeitsverlust",
                },
                oilLeaksMinSpeedKmh = {
                    description = "Minimale Fahrzeuggeschwindigkeit in km/h, bevor ein Flüssigkeitsleck eine Spur erzeugen kann.",
                    label = "Mindestgeschwindigkeit",
                },
                oilLeaksRadius = {
                    description = "Radius regulärer Fahrzeug-Flüssigkeitsspuren.",
                    label = "Spurradius",
                },
                oilLeaksTransmissionFluidChance = {
                    description = "Normale Leck-Chance von 0 bis 1.",
                    label = "Getriebeflüssigkeits-Chance",
                },
                oilLeaksTransmissionFluidCriticalChance = {
                    description = "Kritische Leck-Chance von 0 bis 1.",
                    label = "Kritische Getriebe-Chance",
                },
                oilLeaksTransmissionFluidCriticalThreshold = {
                    description = "Getriebeflüssigkeits-Zustand, ab dem die kritische Chance genutzt wird.",
                    label = "Kritische Getriebe-Schwelle",
                },
                oilLeaksTransmissionFluidThreshold = {
                    description = "Getriebeflüssigkeits-Zustand, ab dem ein Leck beginnen kann.",
                    label = "Getriebeflüssigkeits-Schwelle",
                },
                orderInstallLiftBypassVehicleClasses = {
                    description = "Fahrzeugklassen, die hebebühnenpflichtige Auftragsarbeiten ohne Werkstatt-Hebebühne durchführen können.",
                    itemLabel = "Fahrzeugklasse hinzufügen",
                    label = "Hebebühnen-Bypass Klassen",
                    options = {
                        ["0"] = "Kompaktwagen",
                        ["1"] = "Limousinen",
                        ["10"] = "Industriefahrzeuge",
                        ["11"] = "Nutzfahrzeuge",
                        ["12"] = "Transporter",
                        ["13"] = "Fahrräder",
                        ["14"] = "Boote",
                        ["15"] = "Hubschrauber",
                        ["16"] = "Flugzeuge",
                        ["17"] = "Servicefahrzeuge",
                        ["18"] = "Einsatzfahrzeuge",
                        ["19"] = "Militärfahrzeuge",
                        ["2"] = "Suvs",
                        ["20"] = "Gewerbefahrzeuge",
                        ["21"] = "Züge",
                        ["22"] = "Open-Wheel",
                        ["3"] = "Coupés",
                        ["4"] = "Muscle-Cars",
                        ["5"] = "Sportklassiker",
                        ["6"] = "Sportwagen",
                        ["7"] = "Supersportwagen",
                        ["8"] = "Motorräder",
                        ["9"] = "Geländewagen",
                    },
                },
                orderInstallLiftBypassVehicleModels = {
                    description = "Fahrzeug-Spawnmodelle, die hebebühnenpflichtige Auftragsarbeiten ohne Werkstatt-Hebebühne durchführen können.",
                    itemLabel = "Fahrzeugmodell",
                    label = "Hebebühnen-Bypass Modelle",
                },
                orderInstallNonMinigameDurationMs = {
                    description = "Millisekunden für Bestell-Einbauschritte ohne Minigame.",
                    label = "Einfache Einbaudauer",
                },
                orderInstallNonMinigameVehicleClasses = {
                    description = "Fahrzeugklassen-IDs, die immer den normalen Mechaniker-Einbau ohne spezielle Hebebühnen- oder Minispielabläufe verwenden.",
                    label = "Fahrzeugklassen ohne Minispiel",
                },
                orderInstallNonMinigameVehicleModels = {
                    description = "Fahrzeug-Spawnmodelle, die immer den normalen Mechaniker-Einbau ohne spezielle Hebebühnen- oder Minispielabläufe verwenden.",
                    label = "Fahrzeugmodelle ohne Minispiel",
                },
                partsDeliveryCompanyCard = {
                    description = "Teilelieferungen dürfen Firmenkonto-Mittel verwenden.",
                    label = "Firmenkarte",
                },
                partsDeliveryMode = {
                    description = "Verwendet den physischen Standardablauf oder legt die vollständige Lieferung direkt ins Inventar des abholenden Spielers.",
                    label = "Lieferabwicklung",
                    options = {
                        player_inventory = "Spielerinventar",
                        standard = "Standardablauf",
                    },
                },
                partsDeliveryOpenDurationMs = {
                    description = "Millisekunden zum Auspacken einer bereiten Teilelieferung.",
                    label = "Auspackdauer",
                },
                partsDeliveryOwnCard = {
                    description = "Spieler dürfen Teilelieferungen mit eigenem Geld bezahlen.",
                    label = "Eigene Karte",
                },
                partsDeliveryTimeSeconds = {
                    description = "Sekunden zwischen Teilebestellung und Bereitstellung der Lieferung.",
                    label = "Lieferzeit",
                },
                partsTheftCatalyticConverterItem = {
                    description = "Inventar-Item, das beim Katalysator-Diebstahl vergeben wird.",
                    label = "Katalysator-Item",
                },
                partsTheftDealerAccount = {
                    description = "Konto für Auszahlungen des Hehlers, z. B. money oder bank.",
                    label = "Händler-Auszahlungskonto",
                },
                partsTheftDealerItems = {
                    description = "Gestohlene Items, die der Händler ankauft, inklusive Auszahlung.",
                    itemLabel = "Händler-Item",
                    label = "Händler-Items",
                },
                partsTheftDealerPayoutItem = {
                    description = "Inventar-Item, das vergeben wird, wenn der Auszahlungstyp Item ist. Der Verkaufspreis wird als Item-Menge genutzt.",
                    label = "Händler-Auszahlungs-Item",
                },
                partsTheftDealerPayoutType = {
                    description = "Wähle, ob der Händler auf ein Framework-Konto auszahlt oder ein Inventar-Item gibt.",
                    label = "Händler-Auszahlungstyp",
                    options = {
                        account = "Konto",
                        item = "Gegenstand",
                    },
                },
                partsTheftDealerSellDistance = {
                    description = "Maximale Distanz zum Händler, um gestohlene Teile zu verkaufen.",
                    label = "Verkaufsdistanz",
                },
                partsTheftDispatchCooldownSeconds = {
                    description = "Sekunden, bis dasselbe Fahrzeugteil erneut einen Dispatch auslösen kann.",
                    label = "Dispatch-Cooldown",
                },
                partsTheftDispatchEnabled = {
                    description = "Erstellt einen Polizei-Dispatch, wenn ein Rad oder Katalysator gestohlen wird.",
                    label = "Polizei-Dispatch senden",
                },
                partsTheftDispatchJobs = {
                    description = "Jobnamen, die Teilediebstahl-Dispatches erhalten.",
                    itemLabel = "Jobname",
                    label = "Dispatch-Jobs",
                },
                partsTheftDispatchMessage = {
                    description = "Nachricht des Dispatch-Alarms. Unterstützt {plate}, {part} und {type}.",
                    label = "Dispatch-Nachricht",
                },
                partsTheftDispatchTitle = {
                    description = "Titel des Dispatch-Alarms. Unterstützt {plate}, {part} und {type}.",
                    label = "Dispatch-Titel",
                },
                partsTheftItem = {
                    description = "Inventar-Item zum Stehlen von Rädern und Katalysatoren.",
                    label = "Diebstahl-Werkzeug",
                },
                partsTheftRemoveItemAfterUse = {
                    description = "Diebstahl-Werkzeug nach einem erfolgreichen Diebstahl entfernen.",
                    label = "Werkzeug verbrauchen",
                },
                partsTheftStolenWheelItem = {
                    description = "Inventar-Item, das beim Rad-Diebstahl vergeben wird.",
                    label = "Gestohlenes-Rad-Item",
                },
                priceType = {
                    description = "Prozent berechnet Kosten aus dem Fahrzeugpreis. Fix nutzt Geldbeträge. Fahrzeugklasse nutzt die Klassentabelle.",
                    label = "Preistyp",
                    options = {
                        class = "Fahrzeugklasse",
                        fixed = "Fix",
                        percentage = "Prozent",
                    },
                },
                primaryColor = {
                    description = "Standardfarbe für die Mechaniker-Jobgruppe und neue Jobs. Nutze einen Hex-Wert wie #EDC001.",
                    label = "Primärfarbe",
                },
                publicUsersSeePrices = {
                    description = "Aktiviert: Kunden zahlen bei der Bestellung. Deaktiviert: unbezahlter Auftrag zur späteren Mechaniker-Abrechnung.",
                    label = "Öffentliche Self-Service-Aufträge berechnen",
                },
                registryBikeChecks = {
                    description = "Prüfpunkte für Motorräder",
                    label = "Prüfpunkte für Motorräder",
                },
                registryCarChecks = {
                    description = "Prüfpunkte für PKW",
                    label = "Prüfpunkte für PKW",
                },
                registryDistance = {
                    description = "Serviceabstand (Meter)",
                    label = "Serviceabstand (Meter)",
                },
                registryKuvFee = {
                    description = "Prüfgebühr",
                    label = "Prüfgebühr",
                },
                registryKuvValidityDays = {
                    description = "Gültigkeit neuer Prüfungen in Echtzeit. Standard: 30 Tage. Bestehende Ablaufdaten bleiben erhalten.",
                    label = "Prüfgültigkeit (reale Tage)",
                },
                registryKuvWarningDays = {
                    description = "Vorwarnzeit (Tage)",
                    label = "Vorwarnzeit (Tage)",
                },
                registryRegistrationFee = {
                    description = "Anmeldegebühr",
                    label = "Anmeldegebühr",
                },
                registryReinspectionFee = {
                    description = "Nachprüfungsgebühr",
                    label = "Nachprüfungsgebühr",
                },
                registryRequireKuv = {
                    description = "Gültige Fahrzeugtechnische Überprüfung für Anmeldung verlangen",
                    label = "Gültige Fahrzeugtechnische Überprüfung für Anmeldung verlangen",
                },
                registrySessionSeconds = {
                    description = "Bestätigungsdauer (Sekunden)",
                    label = "Bestätigungsdauer (Sekunden)",
                },
                registryTransferFee = {
                    description = "Ummeldegebühr",
                    label = "Ummeldegebühr",
                },
                registryVehicleTypes = {
                    description = "Erlaubte Fahrzeugtypen",
                    label = "Erlaubte Fahrzeugtypen",
                },
                subscriptionsAllowJobSubscriptions = {
                    description = "Erlaubt berechtigten Chefs, mit Firmengeldern ein Abonnement für den gesamten Job zu kaufen.",
                    label = "Firmen-Abonnements",
                },
                subscriptionsCurrency = {
                    description = "Die \"sky_base\"-Währung zum Kauf von Abonnements, zum Beispiel \"bank\".",
                    label = "Zahlungswährung",
                },
                subscriptionsEnabled = {
                    description = "Aktiviert Werkstatt-Abonnements, Kundenterminals und Abo-Rabatte.",
                    label = "Aktiviert",
                },
                subscriptionsMaximumDurations = {
                    description = "Maximale Anzahl an Laufzeit- und Preisoptionen pro Abo-Modell.",
                    label = "Maximale Laufzeiten",
                },
                subscriptionsMaximumModels = {
                    description = "Maximale Anzahl an Abo-Modellen, die eine Werkstatt im Tablet konfigurieren kann.",
                    label = "Maximale Modelle",
                },
                subscriptionsNpcEmoteClip = {
                    description = "Optionaler wiederholter Animationsclip, der bei leerem Szenario verwendet wird.",
                    label = "NPC-Emote-Clip",
                },
                subscriptionsNpcEmoteDict = {
                    description = "Optionales Anim Dict, das bei leerem Szenario verwendet wird.",
                    label = "NPC-Emote-Dictionary",
                },
                subscriptionsNpcPedModel = {
                    description = "Ped-Modell, das an Abo-Terminals gespawnt wird, zum Beispiel s_m_m_autoshop_01.",
                    label = "NPC-Ped-Modell",
                },
                subscriptionsNpcScenario = {
                    description = "Optionales GTA-Szenario wie WORLD_HUMAN_CLIPBOARD. Leer lassen, um die Emote-Animation zu verwenden.",
                    label = "NPC-Szenario",
                },
                tuningBlockedPlates = {
                    description = "Fahrzeuge mit einem dieser Kennzeichen können nicht getunt und deren Tuning weder ein- noch ausgebaut werden. Groß-/Kleinschreibung und Leerzeichen werden ignoriert.",
                    itemLabel = "Kennzeichen",
                    label = "Für Tuning gesperrte Kennzeichen",
                },
                tuningFocusKey = {
                    description = "FiveM-Standardbelegung, z. B. E, F6 oder MOUSE_BUTTON:MOUSE_RIGHT. Leer bedeutet keine Standardtaste. Spieler ändern ihre Belegung in den FiveM-Einstellungen; gespeicherte Spielerbelegungen bleiben erhalten.",
                    label = "Tuning: Mausbedienung",
                },
                tuningWorkshopDistance = {
                    description = "Maximale Distanz zu einem Self-Service-Tuning-Punkt für Einbau oder Ausbau.",
                    label = "Werkstatt-Distanz",
                },
                tuningWorkshopRequireForInstall = {
                    description = "Tuning-Einbauten müssen nahe an einem Self-Service-Tuning-Punkt starten und enden.",
                    label = "Werkstatt für Einbau nötig",
                },
                tuningWorkshopRequireForRemoval = {
                    description = "Tuning-Ausbau muss nahe an einem Self-Service-Tuning-Punkt starten und enden.",
                    label = "Werkstatt für Ausbau nötig",
                },
                vehicleCareRepairDurationMs = {
                    description = "Dauer des Reparatur-Fortschritts in Millisekunden.",
                    label = "Reparaturdauer",
                },
                vehicleCareRepairFixRealisticWheelDamage = {
                    description = "Setzt bei der Reparatur auch realistische Radschaden zurück.",
                    label = "Realistische Radschaden reparieren",
                },
                vehicleCareRepairItem = {
                    description = "Inventar-Item für die Fahrzeug-Reparaturaktion.",
                    label = "Reparatur-Item",
                },
                vehicleCareRepairMaxDistance = {
                    description = "Maximale Distanz zum Fahrzeug während der Reparatur.",
                    label = "Max. Reparaturdistanz",
                },
                vehicleCareRepairRemoveAfterUse = {
                    description = "Reparatur-Item nach Nutzung entfernen.",
                    label = "Reparatur-Item verbrauchen",
                },
                vehicleCareRepairVehicleDamage = {
                    description = "Normalen GTA-Fahrzeugschaden bei der Reparaturaktion beheben.",
                    label = "Fahrzeugschaden reparieren",
                },
                vehicleCareRepairWearParts = {
                    description = "Wähle, welche Verschleiß- und Serviceteile das Reparatur-Item wiederherstellt. Deaktiviere Flüssigkeiten hier, wenn Öl, Kühlmittel, Bremsflüssigkeit oder Getriebeflüssigkeit den Diagnose-Reparaturablauf brauchen.",
                    itemLabel = "Verschleißteil",
                    label = "Vom Reparaturkit reparierte Teile",
                },
                vehicleCareWashItem = {
                    description = "Inventar-Item zum Waschen eines Fahrzeugs.",
                    label = "Wasch-Item",
                },
                vehicleCareWashRemoveAfterUse = {
                    description = "Wasch-Item nach Nutzung entfernen.",
                    label = "Wasch-Item verbrauchen",
                },
                vehicleCareWaxCleanKilometers = {
                    description = "Distanz, die ein gewachstes Fahrzeug sauber bleibt.",
                    label = "Wachs-Sauber-Kilometer",
                },
                vehicleCareWaxItem = {
                    description = "Inventar-Item zum Wachsen eines Fahrzeugs.",
                    label = "Wachs-Item",
                },
                vehicleCareWaxRemoveAfterUse = {
                    description = "Wachs-Item nach Nutzung entfernen.",
                    label = "Wachs-Item verbrauchen",
                },
                vehicleClassPricing = {
                    description = "Überschreibt Preistyp und Kostenmultiplikator für jede GTA-Fahrzeugklasse.",
                    label = "Preise nach Fahrzeugklasse",
                },
                wearParts = {
                    description = "Fahrzeug-Verschleißteile, Laufleistung, benötigtes Reparatur-Item, Item-Verbrauch und Einbau-Ablauf.",
                    fields = {
                        flow = {
                            options = {
                                catalytic_converter = "Katalysator",
                                fluid_refill = "Flüssigkeit auffüllen",
                                hood_install = "Motorhaube einbauen",
                                oil_change = "Ölwechsel",
                                performance = "Leistung",
                                underbody_neon = "Unterboden / Hebebühne",
                                wheel = "Rad",
                            },
                        },
                    },
                    itemLabel = "Verschleißteil",
                    label = "Verschleißteile",
                },
                wheelDamageDefaultMultiplier = {
                    description = "Basis-Multiplikator für Radschaden.",
                    label = "Standard-Multiplikator",
                },
                wheelDamageDeformationAngleThreshold = {
                    description = "Filtert Verformungs-Probe-Punkte heraus, die nicht zur Fahrzeugkarosserie zurückzeigen.",
                    label = "Probe-Winkelschwelle",
                },
                wheelDamageDeformationDamageIncrement = {
                    description = "Zusätzliche Kraft, die pro Wiederherstellungsdurchlauf hinzugefügt wird.",
                    label = "Verformungsschaden-Erhöhung",
                },
                wheelDamageDeformationEnabled = {
                    description = "Erfasst und stellt Dellen der Karosserie wieder her, wenn die Reifenreparatur die Radgeometrie neu aufbaut.",
                    label = "Verformung wiederherstellen",
                },
                wheelDamageDeformationInitialDamage = {
                    description = "Startkraft für die Wiederherstellung von Dellen.",
                    label = "Anfänglicher Verformungsschaden",
                },
                wheelDamageDeformationMaxIterations = {
                    description = "Maximale Anzahl an SetVehicleDamage-Durchläufen zum Wiederaufbau von Dellen.",
                    label = "Verformungs-Iterationen",
                },
                wheelDamageDeformationThreshold = {
                    description = "Minimale erkannte Verformungsstärke, die gespeichert wird.",
                    label = "Verformungs-Schwelle",
                },
                wheelDamageOffroadWheelsMultiplier = {
                    description = "Multiplikator, wenn das Fahrzeug Offroad-Räder hat.",
                    label = "Offroad-Rad-Multiplikator",
                },
                wheelDamageRepairInstantDamageReapplyPasses = {
                    description = "Zusätzliche sofortige Wiederherstellungsdurchläufe für Nicht-Reifen-Schaden nach dem Neuaufbau der Radgeometrie.",
                    label = "Schaden-Reapply-Durchläufe",
                },
                wheelDamageRepairInstantWheelStateReapplyPasses = {
                    description = "Zusätzliche sofortige Durchläufe für weiterhin fehlende oder platte Reifen nach einer Reifenreparatur.",
                    label = "Radstatus-Reapply-Durchläufe",
                },
                wheelDamageRepairPreserveNonWheelDamage = {
                    description = "Behält Karosserie-, Motor-, Fenster-, Türen-, Schmutz- und Sichtschaden, wenn die Reifenreparatur die Radgeometrie neu aufbaut.",
                    label = "Fahrzeugschaden erhalten",
                },
                wheelDamageRepairQuietWindowRemoval = {
                    description = "Stellt kaputte Fenster soweit möglich ohne lauten Zerstörungseffekt wieder her.",
                    label = "Leise kaputte Fenster",
                },
                wheelDamageRepairSilentPoppedReapply = {
                    description = "Wendet weiterhin platte Reifen erneut an, ohne ein neues Reifenplatzgeräusch oder einen neuen Effekt auszulösen.",
                    label = "Leises Reapply platter Reifen",
                },
                wheelDamageTyreRepairAttachDistance = {
                    description = "Maximale Distanz zum beschädigten oder fehlenden Reifen für die Montageaktion.",
                    label = "Reifen-Montage-Distanz",
                },
                wheelDamageTyreRepairCarJackRemoveDistance = {
                    description = "Maximale Distanz zum platzierten Wagenheber für die Entfernen-Aktion.",
                    label = "Wagenheber-Entfernungsdistanz",
                },
                wheelDamageVehicleClassMultipliers = {
                    description = "Schadensmultiplikatoren pro GTA-Fahrzeugklasse.",
                    itemLabel = "Fahrzeugklasse",
                    label = "Fahrzeugklassen-Multiplikatoren",
                },
                vehicleCareRepairBlockForNonMechanicsWhenMechanicsOnDuty = {
                    label = "Andere Jobs bei Mechanikern im Dienst sperren",
                },
                allowsprint = {
                    label = "Sprinten mit Lieferkisten erlauben",
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
            tuningCategories = {
                bodywork = "Karosserie & Optik",
                electronics = "ECU & Fahrzeugelektronik",
                engineSounds = "Motorsounds",
                handling = "Fahrverhalten",
                lights = "Beleuchtung",
                other = "Sonstiges",
                paint = "Lackierung",
                performance = "Leistung",
                stance = "Stand",
                wheels = "Räder",
            },
            tuningOptions = {
                antilag_enabled = {
                    label = "Anti-Lag",
                    values = {
                        [0] = "Deaktiviert",
                        [1] = "GTA-Standard",
                        [2] = "Straßen-Pops",
                        [3] = "Rennsport-Anti-Lag",
                        [4] = "Rallye-Anti-Lag",
                    },
                },
                electronic_automatic_hazards = {
                    label = "Automatische Warnblinker",
                    values = {
                        [0] = "Aus",
                        [1] = "An",
                    },
                },
                electronic_brake_lights = {
                    label = "Bremslichter",
                    values = {
                        [0] = "Normal",
                        [1] = "Notbremsblinken",
                        [2] = "Aus",
                    },
                },
                electronic_engine_tune = {
                    label = "Motorsoftware",
                    values = {
                        [0] = "Serie",
                        [1] = "Stufe 1",
                        [2] = "Stufe 2",
                        [3] = "Stufe 3",
                        [4] = "Stufe 4",
                    },
                },
                electronic_headlight_brightness = {
                    label = "Scheinwerferhelligkeit",
                    values = {
                        [0] = "25 %",
                        [1] = "50 %",
                        [2] = "75 %",
                        [3] = "100 %",
                        [4] = "125 %",
                        [5] = "150 %",
                    },
                },
                electronic_highbeams_on_horn = {
                    label = "Fernlicht bei Hupe",
                    values = {
                        [0] = "Aus",
                        [1] = "An",
                    },
                },
                electronic_idle_rpm = {
                    label = "Leerlaufdrehzahl",
                    values = {
                        [0] = "Serie",
                        [1] = "20 %",
                        [2] = "30 %",
                        [3] = "40 %",
                        [4] = "50 %",
                    },
                },
                electronic_interior_light = {
                    label = "Innenraumlicht",
                    values = {
                        [0] = "Normal",
                        [1] = "Rot",
                    },
                },
                electronic_mood_color = {
                    label = "Ambientelicht-Farbe",
                    values = {
                        [0] = "Aus",
                        [1] = "Rot",
                        [10] = "Limette",
                        [11] = "Türkis",
                        [12] = "Indigo",
                        [13] = "Weiß",
                        [14] = "Warmweiß",
                        [15] = "Kaltweiß",
                        [16] = "Bernstein",
                        [2] = "Blau",
                        [3] = "Grün",
                        [4] = "Cyan",
                        [5] = "Magenta",
                        [6] = "Gelb",
                        [7] = "Orangen",
                        [8] = "Violett",
                        [9] = "Rosa",
                    },
                },
                electronic_mood_intensity = {
                    label = "Ambientelicht-Stärke",
                    values = {
                        [0] = "Gedimmt",
                        [1] = "Normal",
                        [2] = "Hell",
                    },
                },
                electronic_radio_power = {
                    label = "Radio-Stromversorgung",
                    values = {
                        [0] = "Aus",
                        [1] = "An",
                    },
                },
                electronic_throttle_response = {
                    label = "Gasannahme",
                    values = {
                        [0] = "Mehr Traktion",
                        [1] = "Aggressiv",
                    },
                },
                electronic_wheelie_tune = {
                    label = "Wheelie-Abstimmung",
                    values = {
                        [0] = "Aus",
                        [1] = "Sanft",
                        [2] = "Intensiv",
                    },
                },
            },
            vehicleClassLabel = "Klasse {id} ({name})",
        },
    },
}
