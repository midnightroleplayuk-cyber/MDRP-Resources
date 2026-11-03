JobConfigLocales["sky_jobcreator:rs"] = {
    Nui = {
        workshopConfig = {
            creatorSections = { stations = { label = "Stanice", entryLabel = "Stanica", entryPluralLabel = "Stanice" } },
            jobDocuments = {
                title = "Registar dokumenata",
                description = "Čitanje i štampanje dokumenata ovog posla.",
                templates = "Šabloni",
                hint = "Za polja koristi {{CUSTOMER}}. {{AUTHOR}}, {{JOB}} i {{DATE}} se popunjavaju automatski.",
                key = "Tehnički ključ",
                label = "Šablon",
                body = "Tekst šablona",
                active = "Aktivan",
                enabled = "Registar dokumenata",
            },
            configs = {
                sky_jobscreator = { title = "ствараоци професија", subtitle = "Upravljajte poslovima, činovima i podrazumevanim vrednostima novih unosa." },
                sky_jobscreator_gangs = { title = "Стваралац банди", subtitle = "Upravljajte izvornim bandama i njihovim činovima." },
            },
            extensions = {
                billingSettings = { label = "Računi", description = "Dozvoli ovom poslu izdavanje novih računa. Postojeći računi ostaju dostupni." },
                billingPrices = { label = "Katalog računa", description = "Razlozi i cene za račune ovog posla.", itemLabel = "Stavka računa" },
            },
            billingFields = {
                enabled = "Izdavanje računa", reason = "Oznaka razloga", label = "Prikazano ime", amount = "Iznos",
            },
            settingSections = {
                creatorDefaults = "Novi poslovi",
                creatorGrades = "Podrazumevani činovi",
            },
            settings = {
                creatorDefaultJobType = {
                    label = "Podrazumevana vrsta posla",
                    description = "Klasifikacija frameworka za nove QBCore/Qbox poslove, na primer civ, police ili ems.",
                },
                creatorDefaultDuty = {
                    label = "Početak na dužnosti",
                    description = "Početno stanje dužnosti za novokreirane QBCore/Qbox poslove.",
                },
                creatorOffDutyPay = {
                    label = "Plata van dužnosti",
                    description = "Početno pravilo isplate van dužnosti za nove QBCore/Qbox poslove.",
                },
                creatorInitialGradeName = {
                    label = "Tehnički naziv čina",
                    description = "Podrazumevani interni naziv čina 0. Koristite mala slova bez dijakritike, brojeve i donje crte. Naziv boss je rezervisan za rang 1.",
                },
                creatorInitialGradeLabel = {
                    label = "Prikazani naziv čina",
                    description = "Podrazumevani prikazani naziv prvog čina novog posla ili bande.",
                },
                creatorInitialGradeSalary = {
                    label = "Početna plata",
                    description = "Podrazumevana plata za činove novog posla. Bande ne primaju platu.",
                },
                creatorInitialGradeBoss = {
                    label = "Pristup šefa",
                    description = "Početno ovlašćenje šefa za čin 1 novih QBCore/Qbox poslova i bandi.",
                },
                creatorInitialGradeBankAuth = {
                    label = "Pristup računu posla",
                    description = "Početno bankarsko ovlašćenje čina 1 novih QBCore/Qbox poslova. Bande ne koriste ovo ovlašćenje.",
                },
            },
        },
    },
}

