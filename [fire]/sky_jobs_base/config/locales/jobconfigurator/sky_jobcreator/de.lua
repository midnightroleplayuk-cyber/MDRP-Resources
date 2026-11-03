JobConfigLocales["sky_jobcreator:de"] = {
    Nui = {
        workshopConfig = {
            creatorSections = { stations = { label = "Stationen", entryLabel = "Station", entryPluralLabel = "Stationen" } },
            jobDocuments = {
                title = "Dokumentenregister",
                description = "Dokumente dieses Jobs lesen und drucken.",
                templates = "Vorlagen",
                hint = "Nutze {{CUSTOMER}} für Eingabefelder. {{AUTHOR}}, {{JOB}} und {{DATE}} werden automatisch ausgefüllt.",
                key = "Technischer Schlüssel",
                label = "Vorlage",
                body = "Vorlagentext",
                active = "Aktiv",
                enabled = "Dokumentenregister",
            },
            configs = {
                sky_jobscreator = { title = "Job Creator", subtitle = "Jobs, Ränge und Vorgaben für neue Einträge verwalten." },
                sky_jobscreator_gangs = { title = "Schöpfer der Gangs", subtitle = "Native Gangs und deren Ränge verwalten." },
            },
            extensions = {
                billingSettings = { label = "Rechnungen", description = "Diesem Job neue Rechnungen erlauben. Bestehende Rechnungen bleiben verfügbar." },
                billingPrices = { label = "Rechnungskatalog", description = "Gründe und Preise für Rechnungen dieses Jobs.", itemLabel = "Rechnungsposten" },
            },
            billingFields = {
                enabled = "Rechnungen ausstellen", reason = "Grund-Kennung", label = "Anzeigename", amount = "Betrag",
            },
            settingSections = {
                creatorDefaults = "Neue Jobs",
                creatorGrades = "Standardränge",
            },
            settings = {
                creatorDefaultJobType = {
                    label = "Standard-Jobtyp",
                    description = "Framework-Klassifizierung für neue QBCore-/Qbox-Jobs, zum Beispiel civ, police oder ems.",
                },
                creatorDefaultDuty = {
                    label = "Im Dienst starten",
                    description = "Vorgabe für neue QBCore-/Qbox-Jobs: Spieler starten bei Jobzuweisung im Dienst. Beim Login gilt der Wert nur bei aktiviertem ForceJobDefaultDutyAtLogin. Der separate Off-Duty-Job wird unabhängig davon eingerichtet.",
                },
                creatorOffDutyPay = {
                    label = "Gehalt außer Dienst",
                    description = "Anfängliche Gehaltsregel des Frameworks für neue QBCore-/Qbox-Jobs.",
                },
                creatorInitialGradeName = {
                    label = "Rang-Name",
                    description = "Interner Standardname für Rang 0. Erlaubt sind Kleinbuchstaben, Zahlen und Unterstriche. Der Name boss ist für Rang 1 reserviert.",
                },
                creatorInitialGradeLabel = {
                    label = "Rang-Label",
                    description = "Standard-Label für Rang 0 eines neuen Jobs oder einer Gang.",
                },
                creatorInitialGradeSalary = {
                    label = "Anfangsgehalt",
                    description = "Standardgehalt für die Ränge eines neuen Jobs. Gangs erhalten kein Gehalt.",
                },
                creatorInitialGradeBoss = {
                    label = "Boss-Zugriff",
                    description = "Anfänglicher Boss-Wert für Rang 1 neuer QBCore-/Qbox-Jobs und Gangs.",
                },
                creatorInitialGradeBankAuth = {
                    label = "Zugriff auf die Jobkasse",
                    description = "Anfängliche Bankberechtigung für Rang 1 neuer QBCore-/Qbox-Jobs. Gangs nutzen diesen Job-Wert nicht.",
                },
            },
        },
    },
}

