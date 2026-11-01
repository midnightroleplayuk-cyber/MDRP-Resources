JobConfigLocales["sky_jobcreator:cz"] = {
    Nui = {
        workshopConfig = {
            creatorSections = { stations = { label = "Stanice", entryLabel = "Stanice", entryPluralLabel = "Stanice" } },
            jobDocuments = {
                title = "Registr dokumentů",
                description = "Čtení a tisk dokumentů tohoto zaměstnání.",
                templates = "Šablony",
                hint = "Pro pole použijte {{CUSTOMER}}. {{AUTHOR}}, {{JOB}} a {{DATE}} se vyplní automaticky.",
                key = "Technický klíč",
                label = "Šablona",
                body = "Text šablony",
                active = "Aktivní",
                enabled = "Registr dokumentů",
            },
            configs = {
                sky_jobscreator = { title = "profese Tvůrce", subtitle = "Spravujte práce, hodnosti a výchozí hodnoty nových záznamů." },
                sky_jobscreator_gangs = { title = "Gang Stvořitel", subtitle = "Spravujte nativní gangy a jejich hodnosti." },
            },
            extensions = {
                billingSettings = { label = "Faktury", description = "Povolit této práci vystavovat nové faktury. Stávající faktury zůstávají dostupné." },
                billingPrices = { label = "Katalog faktur", description = "Důvody a ceny pro faktury této práce.", itemLabel = "Položka faktury" },
            },
            billingFields = {
                enabled = "Vystavovat faktury", reason = "Identifikátor důvodu", label = "Zobrazovaný název", amount = "Částka",
            },
            settingSections = {
                creatorDefaults = "Nové práce",
                creatorGrades = "Výchozí hodnosti",
            },
            settings = {
                creatorDefaultJobType = {
                    label = "Výchozí typ práce",
                    description = "Klasifikace frameworku pro nové práce QBCore/Qbox, například civ, police nebo ems.",
                },
                creatorDefaultDuty = {
                    label = "Začínat ve službě",
                    description = "Počáteční stav služby pro nově vytvořené práce QBCore/Qbox.",
                },
                creatorOffDutyPay = {
                    label = "Plat mimo službu",
                    description = "Počáteční pravidlo výplaty mimo službu pro nové práce QBCore/Qbox.",
                },
                creatorInitialGradeName = {
                    label = "Technický název hodnosti",
                    description = "Výchozí interní název hodnosti 0. Používejte malá písmena bez diakritiky, čísla a podtržítka. Název boss je vyhrazen pro hodnost 1.",
                },
                creatorInitialGradeLabel = {
                    label = "Zobrazovaný název hodnosti",
                    description = "Výchozí název první hodnosti nové práce nebo gangu.",
                },
                creatorInitialGradeSalary = {
                    label = "Počáteční plat",
                    description = "Výchozí plat pro hodnosti nového zaměstnání. Gangy nemají plat.",
                },
                creatorInitialGradeBoss = {
                    label = "Přístup šéfa",
                    description = "Počáteční oprávnění šéfa pro hodnost 1 nových prací a gangů QBCore/Qbox.",
                },
                creatorInitialGradeBankAuth = {
                    label = "Přístup k účtu práce",
                    description = "Počáteční bankovní oprávnění hodnosti 1 nových prací QBCore/Qbox. Gangy toto oprávnění nepoužívají.",
                },
            },
        },
    },
}

