JobConfigLocales["sky_jobcreator:nl"] = {
    Nui = {
        workshopConfig = {
            creatorSections = { stations = { label = "Stations", entryLabel = "Station", entryPluralLabel = "Stations" } },
            jobDocuments = {
                title = "Documentenregister",
                description = "Documenten van deze baan lezen en afdrukken.",
                templates = "Sjablonen",
                hint = "Gebruik {{CUSTOMER}} voor invulvelden. {{AUTHOR}}, {{JOB}} en {{DATE}} worden automatisch ingevuld.",
                key = "Technische sleutel",
                label = "Sjabloon",
                body = "Sjabloontekst",
                active = "Actief",
                enabled = "Documentenregister",
            },
            configs = {
                sky_jobscreator = { title = "Beroepen Maker", subtitle = "Beheer banen, rangen en standaardwaarden voor nieuwe items." },
                sky_jobscreator_gangs = { title = "Bendemaker", subtitle = "Beheer native gangs en hun rangen." },
            },
            extensions = {
                billingSettings = { label = "Facturering", description = "Laat deze baan nieuwe facturen uitschrijven. Bestaande facturen blijven beschikbaar." },
                billingPrices = { label = "Factuurcatalogus", description = "Redenen en prijzen voor facturen van deze baan.", itemLabel = "Factuurpost" },
            },
            billingFields = {
                enabled = "Facturen uitschrijven", reason = "Redencode", label = "Weergavenaam", amount = "Bedrag",
            },
            settingSections = {
                creatorDefaults = "Nieuwe banen",
                creatorGrades = "Standaardrangen",
            },
            settings = {
                creatorDefaultJobType = {
                    label = "Standaard baantype",
                    description = "Frameworkclassificatie voor nieuwe QBCore/Qbox-banen, bijvoorbeeld civ, police of ems.",
                },
                creatorDefaultDuty = {
                    label = "In dienst beginnen",
                    description = "Eerste dienststatus voor nieuw aangemaakte QBCore/Qbox-banen.",
                },
                creatorOffDutyPay = {
                    label = "Salaris buiten dienst",
                    description = "Eerste salarisregel buiten dienst voor nieuwe QBCore/Qbox-banen.",
                },
                creatorInitialGradeName = {
                    label = "Technische rangnaam",
                    description = "Standaard interne naam voor rang 0. Gebruik kleine letters zonder accenten, cijfers en underscores. De naam boss is gereserveerd voor rang 1.",
                },
                creatorInitialGradeLabel = {
                    label = "Zichtbare rangnaam",
                    description = "Standaard weergavenaam voor de eerste rang van een nieuwe baan of gang.",
                },
                creatorInitialGradeSalary = {
                    label = "Beginsalaris",
                    description = "Standaardsalaris voor de rangen van een nieuwe job. Gangs ontvangen geen salaris.",
                },
                creatorInitialGradeBoss = {
                    label = "Baastoegang",
                    description = "Eerste baasrechten voor rang 1 van nieuwe QBCore/Qbox-banen en gangs.",
                },
                creatorInitialGradeBankAuth = {
                    label = "Toegang tot de baankas",
                    description = "Eerste bankrechten voor rang 1 van nieuwe QBCore/Qbox-banen. Gangs gebruiken deze rechten niet.",
                },
            },
        },
    },
}

