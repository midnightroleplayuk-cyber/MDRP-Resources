JobConfigLocales["sky_jobcreator:hu"] = {
    Nui = {
        workshopConfig = {
            creatorSections = { stations = { label = "Állomások", entryLabel = "Állomás", entryPluralLabel = "Állomások" } },
            jobDocuments = {
                title = "Dokumentumnyilvántartás",
                description = "A munka dokumentumainak olvasása és nyomtatása.",
                templates = "Sablonok",
                hint = "Mezőkhöz használd az {{CUSTOMER}} jelölést. Az {{AUTHOR}}, {{JOB}} és {{DATE}} automatikusan kitöltődik.",
                key = "Technikai kulcs",
                label = "Sablon",
                body = "Sablonszöveg",
                active = "Aktív",
                enabled = "Dokumentumnyilvántartás",
            },
            configs = {
                sky_jobscreator = { title = "foglalkozások Teremtő", subtitle = "Munkák, rangok és új bejegyzések alapértékeinek kezelése." },
                sky_jobscreator_gangs = { title = "Bandakészítő", subtitle = "Natív bandák és rangjaik kezelése." },
            },
            extensions = {
                billingSettings = { label = "Számlázás", description = "A munkakör új számlákat állíthat ki. A meglévő számlák továbbra is elérhetők." },
                billingPrices = { label = "Számlakatalógus", description = "A munkakör számláinak indokai és árai.", itemLabel = "Számlatétel" },
            },
            billingFields = {
                enabled = "Számlák kiállítása", reason = "Indok azonosítója", label = "Megjelenített név", amount = "Összeg",
            },
            settingSections = {
                creatorDefaults = "Új munkák",
                creatorGrades = "Alapértelmezett rangok",
            },
            settings = {
                creatorDefaultJobType = {
                    label = "Alapértelmezett munkatípus",
                    description = "Az új QBCore/Qbox-munkák keretrendszer szerinti besorolása, például civ, police vagy ems.",
                },
                creatorDefaultDuty = {
                    label = "Kezdés szolgálatban",
                    description = "Az új QBCore/Qbox-munkák kezdeti szolgálati állapota.",
                },
                creatorOffDutyPay = {
                    label = "Fizetés szolgálaton kívül",
                    description = "Az új QBCore/Qbox-munkák kezdeti fizetési szabálya szolgálaton kívül.",
                },
                creatorInitialGradeName = {
                    label = "A rang technikai neve",
                    description = "A 0. rang alapértelmezett belső neve. Kis ékezet nélküli betűk, számok és aláhúzás használható. A boss név az 1. rang számára van fenntartva.",
                },
                creatorInitialGradeLabel = {
                    label = "A rang megjelenített neve",
                    description = "Az új munka vagy banda első rangjának alapértelmezett megjelenített neve.",
                },
                creatorInitialGradeSalary = {
                    label = "Kezdő fizetés",
                    description = "Az új munkák rangjainak alapértelmezett fizetése. A bandák nem kapnak fizetést.",
                },
                creatorInitialGradeBoss = {
                    label = "Főnöki hozzáférés",
                    description = "Az új QBCore/Qbox-munkák és bandák 1. rangjának kezdeti főnöki jogosultsága.",
                },
                creatorInitialGradeBankAuth = {
                    label = "Hozzáférés a munka számlájához",
                    description = "Az új QBCore/Qbox-munkák 1. rangjának kezdeti banki jogosultsága. A bandák ezt nem használják.",
                },
            },
        },
    },
}

