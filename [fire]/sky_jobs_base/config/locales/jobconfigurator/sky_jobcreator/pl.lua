JobConfigLocales["sky_jobcreator:pl"] = {
    Nui = {
        workshopConfig = {
            creatorSections = { stations = { label = "Placówki", entryLabel = "Placówka", entryPluralLabel = "Placówki" } },
            jobDocuments = {
                title = "Rejestr dokumentów",
                description = "Odczyt i drukowanie dokumentów tej pracy.",
                templates = "Szablony",
                hint = "Użyj {{CUSTOMER}} dla pól. {{AUTHOR}}, {{JOB}} i {{DATE}} są wypełniane automatycznie.",
                key = "Klucz techniczny",
                label = "Szablon",
                body = "Treść szablonu",
                active = "Aktywny",
                enabled = "Rejestr dokumentów",
            },
            configs = {
                sky_jobscreator = { title = "Stwórca zawodów", subtitle = "Zarządzaj pracami, rangami i wartościami domyślnymi nowych wpisów." },
                sky_jobscreator_gangs = { title = "Stwórca gangów", subtitle = "Zarządzaj natywnymi gangami i ich rangami." },
            },
            extensions = {
                billingSettings = { label = "Faktury", description = "Zezwól tej pracy na wystawianie nowych faktur. Istniejące faktury pozostają dostępne." },
                billingPrices = { label = "Katalog faktur", description = "Powody i ceny faktur dla tej pracy.", itemLabel = "Pozycja faktury" },
            },
            billingFields = {
                enabled = "Wystawiaj faktury", reason = "Identyfikator powodu", label = "Wyświetlana nazwa", amount = "Kwota",
            },
            settingSections = {
                creatorDefaults = "Nowe prace",
                creatorGrades = "Domyślne rangi",
            },
            settings = {
                creatorDefaultJobType = {
                    label = "Domyślny typ pracy",
                    description = "Klasyfikacja frameworka dla nowych prac QBCore/Qbox, na przykład civ, police lub ems.",
                },
                creatorDefaultDuty = {
                    label = "Rozpocznij na służbie",
                    description = "Początkowy stan służby nowo utworzonych prac QBCore/Qbox.",
                },
                creatorOffDutyPay = {
                    label = "Wypłata poza służbą",
                    description = "Początkowa zasada wypłaty poza służbą dla nowych prac QBCore/Qbox.",
                },
                creatorInitialGradeName = {
                    label = "Techniczna nazwa rangi",
                    description = "Domyślna nazwa wewnętrzna rangi 0. Używaj małych liter bez znaków diakrytycznych, cyfr i podkreśleń. Nazwa boss jest zarezerwowana dla rangi 1.",
                },
                creatorInitialGradeLabel = {
                    label = "Wyświetlana nazwa rangi",
                    description = "Domyślna wyświetlana nazwa pierwszej rangi nowej pracy lub gangu.",
                },
                creatorInitialGradeSalary = {
                    label = "Początkowa pensja",
                    description = "Domyślna pensja dla rang nowej pracy. Gangi nie otrzymują pensji.",
                },
                creatorInitialGradeBoss = {
                    label = "Dostęp szefa",
                    description = "Początkowe uprawnienie szefa dla rangi 1 nowych prac i gangów QBCore/Qbox.",
                },
                creatorInitialGradeBankAuth = {
                    label = "Dostęp do konta pracy",
                    description = "Początkowe uprawnienie bankowe rangi 1 nowych prac QBCore/Qbox. Gangi nie używają tego uprawnienia.",
                },
            },
        },
    },
}

