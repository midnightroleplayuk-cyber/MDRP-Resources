JobConfigLocales["sky_jobcreator:se"] = {
    Nui = {
        workshopConfig = {
            creatorSections = { stations = { label = "Stationer", entryLabel = "Station", entryPluralLabel = "Stationer" } },
            jobDocuments = {
                title = "Dokumentregister",
                description = "Läsa och skriva ut dokument för det här jobbet.",
                templates = "Mallar",
                hint = "Använd {{CUSTOMER}} för fält. {{AUTHOR}}, {{JOB}} och {{DATE}} fylls i automatiskt.",
                key = "Teknisk nyckel",
                label = "Mall",
                body = "Malltext",
                active = "Aktiv",
                enabled = "Dokumentregister",
            },
            configs = {
                sky_jobscreator = { title = "Yrken som skapar", subtitle = "Hantera jobb, grader och standardvärden för nya poster." },
                sky_jobscreator_gangs = { title = "Gängskapare", subtitle = "Hantera inbyggda gäng och deras grader." },
            },
            extensions = {
                billingSettings = { label = "Fakturering", description = "Tillåt jobbet att skapa nya fakturor. Befintliga fakturor finns kvar." },
                billingPrices = { label = "Fakturakatalog", description = "Orsaker och priser för jobbets fakturor.", itemLabel = "Fakturarad" },
            },
            billingFields = {
                enabled = "Skapa fakturor", reason = "Orsakskod", label = "Visningsnamn", amount = "Belopp",
            },
            settingSections = {
                creatorDefaults = "Nya jobb",
                creatorGrades = "Standardgrader",
            },
            settings = {
                creatorDefaultJobType = {
                    label = "Standardtyp för jobb",
                    description = "Ramverkets klassificering för nya QBCore/Qbox-jobb, till exempel civ, police eller ems.",
                },
                creatorDefaultDuty = {
                    label = "Börja i tjänst",
                    description = "Ursprunglig tjänstestatus för nya QBCore/Qbox-jobb.",
                },
                creatorOffDutyPay = {
                    label = "Lön utanför tjänst",
                    description = "Ursprunglig löneregel utanför tjänst för nya QBCore/Qbox-jobb.",
                },
                creatorInitialGradeName = {
                    label = "Gradens tekniska namn",
                    description = "Internt standardnamn för grad 0. Använd små bokstäver utan diakritiska tecken, siffror och understreck. Namnet boss är reserverat för rang 1.",
                },
                creatorInitialGradeLabel = {
                    label = "Gradens visningsnamn",
                    description = "Standardnamn som visas för första graden i ett nytt jobb eller gäng.",
                },
                creatorInitialGradeSalary = {
                    label = "Ingångslön",
                    description = "Standardlön för graderna i ett nytt jobb. Gäng får ingen lön.",
                },
                creatorInitialGradeBoss = {
                    label = "Chefsåtkomst",
                    description = "Ursprunglig chefsbehörighet för grad 1 i nya QBCore/Qbox-jobb och gäng.",
                },
                creatorInitialGradeBankAuth = {
                    label = "Åtkomst till jobbkonto",
                    description = "Ursprunglig bankbehörighet för grad 1 i nya QBCore/Qbox-jobb. Gäng använder inte denna behörighet.",
                },
            },
        },
    },
}

