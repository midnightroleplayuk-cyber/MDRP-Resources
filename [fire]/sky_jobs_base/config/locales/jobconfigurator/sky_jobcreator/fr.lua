JobConfigLocales["sky_jobcreator:fr"] = {
    Nui = {
        workshopConfig = {
            creatorSections = { stations = { label = "Stations", entryLabel = "Station", entryPluralLabel = "Stations" } },
            jobDocuments = {
                title = "Registre des documents",
                description = "Lire et imprimer les documents de ce métier.",
                templates = "Modèles",
                hint = "Utilisez {{CUSTOMER}} pour les champs. {{AUTHOR}}, {{JOB}} et {{DATE}} sont remplis automatiquement.",
                key = "Clé technique",
                label = "Modèle",
                body = "Texte du modèle",
                active = "Actif",
                enabled = "Registre des documents",
            },
            configs = {
                sky_jobscreator = { title = "Professions", subtitle = "Gérez les métiers, les grades et les valeurs par défaut des nouvelles entrées." },
                sky_jobscreator_gangs = { title = "Créateur de gangs", subtitle = "Gérez les gangs natifs et leurs grades." },
            },
            extensions = {
                billingSettings = { label = "Facturation", description = "Autoriser ce métier à émettre de nouvelles factures. Les factures existantes restent accessibles." },
                billingPrices = { label = "Catalogue des factures", description = "Motifs et prix des factures de ce métier.", itemLabel = "Ligne de facture" },
            },
            billingFields = {
                enabled = "Émettre des factures", reason = "Identifiant du motif", label = "Nom affiché", amount = "Montant",
            },
            settingSections = {
                creatorDefaults = "Nouveaux métiers",
                creatorGrades = "Grades par défaut",
            },
            settings = {
                creatorDefaultJobType = {
                    label = "Type de métier par défaut",
                    description = "Classification du framework pour les nouveaux métiers QBCore/Qbox, par exemple civ, police ou ems.",
                },
                creatorDefaultDuty = {
                    label = "Commencer en service",
                    description = "État de service initial des nouveaux métiers QBCore/Qbox.",
                },
                creatorOffDutyPay = {
                    label = "Salaire hors service",
                    description = "Règle initiale de rémunération hors service des nouveaux métiers QBCore/Qbox.",
                },
                creatorInitialGradeName = {
                    label = "Nom technique du grade",
                    description = "Nom interne par défaut du grade 0. Utilisez des lettres minuscules sans accents, des chiffres et des traits de soulignement. Le nom boss est réservé au rang 1.",
                },
                creatorInitialGradeLabel = {
                    label = "Nom affiché du grade",
                    description = "Nom affiché par défaut du premier grade d'un nouveau métier ou gang.",
                },
                creatorInitialGradeSalary = {
                    label = "Salaire initial",
                    description = "Salaire par défaut des grades d'un nouveau métier. Les gangs ne reçoivent pas de salaire.",
                },
                creatorInitialGradeBoss = {
                    label = "Accès du patron",
                    description = "Droit de patron initial du grade 1 des nouveaux métiers et gangs QBCore/Qbox.",
                },
                creatorInitialGradeBankAuth = {
                    label = "Accès au compte du métier",
                    description = "Autorisation bancaire initiale du grade 1 des nouveaux métiers QBCore/Qbox. Les gangs n'utilisent pas ce droit.",
                },
            },
        },
    },
}

