JobConfigLocales["sky_jobcreator:sl"] = {
    Nui = {
        workshopConfig = {
            creatorSections = { stations = { label = "Postaje", entryLabel = "Postaja", entryPluralLabel = "Postaje" } },
            jobDocuments = {
                title = "Register dokumentov",
                description = "Branje in tiskanje dokumentov te službe.",
                templates = "Predloge",
                hint = "Za polja uporabi {{CUSTOMER}}. {{AUTHOR}}, {{JOB}} in {{DATE}} se izpolnijo samodejno.",
                key = "Tehnični ključ",
                label = "Predloga",
                body = "Besedilo predloge",
                active = "Aktivna",
                enabled = "Register dokumentov",
            },
            configs = {
                sky_jobscreator = { title = "ustvarjalec poklicev", subtitle = "Upravljajte službe, čine in privzete vrednosti novih vnosov." },
                sky_jobscreator_gangs = { title = "Ustvarjalec tolp", subtitle = "Upravljajte izvorne tolpe in njihove čine." },
            },
            extensions = {
                billingSettings = { label = "Računi", description = "Dovoli temu poklicu izdajo novih računov. Obstoječi računi ostanejo dostopni." },
                billingPrices = { label = "Katalog računov", description = "Razlogi in cene za račune tega poklica.", itemLabel = "Postavka računa" },
            },
            billingFields = {
                enabled = "Izdajanje računov", reason = "Oznaka razloga", label = "Prikazno ime", amount = "Znesek",
            },
            settingSections = {
                creatorDefaults = "Nove službe",
                creatorGrades = "Privzeti čini",
            },
            settings = {
                creatorDefaultJobType = {
                    label = "Privzeta vrsta službe",
                    description = "Razvrstitev ogrodja za nove službe QBCore/Qbox, na primer civ, police ali ems.",
                },
                creatorDefaultDuty = {
                    label = "Začni na dolžnosti",
                    description = "Začetno stanje dolžnosti novih služb QBCore/Qbox.",
                },
                creatorOffDutyPay = {
                    label = "Plača zunaj dolžnosti",
                    description = "Začetno pravilo plačila zunaj dolžnosti za nove službe QBCore/Qbox.",
                },
                creatorInitialGradeName = {
                    label = "Tehnično ime čina",
                    description = "Privzeto notranje ime čina 0. Uporabite male črke brez šumnikov, številke in podčrtaje. Ime boss je rezervirano za rang 1.",
                },
                creatorInitialGradeLabel = {
                    label = "Prikazano ime čina",
                    description = "Privzeto prikazano ime prvega čina nove službe ali tolpe.",
                },
                creatorInitialGradeSalary = {
                    label = "Začetna plača",
                    description = "Privzeta plača za čine nove službe. Tolpe ne prejemajo plače.",
                },
                creatorInitialGradeBoss = {
                    label = "Dostop vodje",
                    description = "Začetno dovoljenje vodje za čin 1 novih služb in tolp QBCore/Qbox.",
                },
                creatorInitialGradeBankAuth = {
                    label = "Dostop do računa službe",
                    description = "Začetno bančno dovoljenje čina 1 novih služb QBCore/Qbox. Tolpe tega dovoljenja ne uporabljajo.",
                },
            },
        },
    },
}

