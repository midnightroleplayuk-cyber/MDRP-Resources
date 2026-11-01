JobConfigLocales["sky_dojjob:pl"] = {
    Nui = {
        tablet = { apps = { doj_finance = "Finanse" ,
                doj_conditions = "Stany",
                doj_elections = "Wybory",
                doj_files = "Eksplorer plików liter",
                doj_hearings = "Przesłuchania",
                doj_law = "Kodeksy prawne",
                doj_offences = "Wygodny katalog",
                doj_shared_files = "Udostępnione dokumenty",
            } },
        workshopConfig = {
            recordsAccessGuide = {
                title = "Konfiguracja dostępu do akt",
                description = "Wybierz, kto może korzystać z akt i w jakim obszarze pracuje. Rangi bez przypisania nie mają dostępu.",
                status = {
                    unpublished = "Przypisania nie zostały jeszcze opublikowane",
                    conflict = "Rozwiąż zduplikowane przypisania",
                    disabled = "Tablet DOJ jest wyłączony",
                    incomplete = "Przypisz co najmniej jedną rangę",
                    ready = "Gotowe do zapisania",
                },
                steps = {
                    tabletTitle = "Włącz tablet DOJ",
                    tabletText = "Tablet musi być włączony, aby otworzyć aplikacje akt.",
                    gradesTitle = "Przypisz rangi DOJ",
                    gradesText = "Wybierz dokładnie jeden obszar akt dla każdej rangi, która ma otrzymać dostęp.",
                    publishTitle = "Opublikuj i zapisz",
                    publishText = "Po każdej zmianie przypisania automatycznie przygotowywana jest nowa wersja.",
                },
                grades = {
                    title = "Przypisania rang",
                    description = "Wybierz jeden obszar na rangę. Wybierz Brak dostępu dla rang, które mają pozostać zablokowane.",
                    search = "Szukaj rang",
                    conflict = "Ranga ma więcej niż jedno przypisanie. Wybierz jeden obszar lub Brak dostępu, aby rozwiązać konflikt.",
                    notFound = "Nie istnieje już we frameworku",
                    noResults = "Nie znaleziono pasującej rangi.",
                    empty = "Nie znaleziono rang dla skonfigurowanej pracy DOJ.",
                    emptyHint = "Najpierw utwórz rangi DOJ we frameworku, a następnie otwórz ponownie konfigurator.",
                    gradeColumn = "Ranga",
                    domainColumn = "Obszar akt",
                    noAccess = "Brak dostępu",
                    chooseDomain = "Rozwiąż przypisanie",
                    assigned = "przypisanych rang",
                },
                publish = {
                    saveHint = "Kliknij Zapisz u góry, aby zastosować zmiany. Gracze mogą następnie ponownie sprawdzić swój dostęp.",
                },
            },
            registryFiles = { licenseType = "Rodzaj licencji", licenseLabel = "Nazwa rejestru", marriages = "Rejestr małżeństw" },
            features = {
                dojHandovers = {
                    label = "Przekazania",
                    description = "Włącza przekazania, decyzje sądowe i raporty wykonania. Dokumenty i udostępnianie pozostają dostępne.",
                },
                dojBodycamRequests = {
                    label = "Wnioski o nagrania z kamer nasobnych",
                    description = "Poproś o nagrania policyjne. Wymaga Przekazań; zapisane nagrania pozostają dostępne niezależnie.",
                },
                dojFinance = { label = "Finanse", description = "Salda frakcji, przelewy skarbca i historia transakcji." },
                dojConditions = {
                    description = "Aktywuj zorganizowane warunki, dowody, terminy i naruszenia.",
                    label = "Stany",
                },
                dojCourtroom = {
                    description = "Aktywuj bezpieczne sesje sali sądowej, prezentację dowodów i interakcje w pokoju opartym na roli.",
                    label = "Życie na sali sądowej",
                },
                dojElections = {
                    description = "Aktywacja administracji wyborczej i bezpieczne głosowanie w zarejestrowanych kabinach głosowania.",
                    label = "Wybory",
                },
                dojHearings = {
                    description = "Aktywuj harmonogram, check-in i autorytetowe kontrole stanu słuchu.",
                    label = "Przesłuchania",
                },
                dojLegalCodes = {
                    description = "Aktywacja książek prawnych, edycja bogatego tekstu i historia rewizji.",
                    label = "Kody prawne",
                },
                dojOffences = {
                    description = "Aktywuj kompaktowy katalog przestępstw i podgląd kalkulatora.",
                    label = "Wygodny katalog",
                },
                dojPrinters = {
                    description = "Aktywuj drukarki fizyczne i ich infrastrukturę jazdy.",
                    label = "Drukarki",
                },
                dojPublicDisplays = {
                    description = "Aktywuj dane na żywo dla wyświetlaczy sądu.",
                    label = "Wyświetlanie publicznego sądu sądowego",
                },
                dojTablet = {
                    description = "Aktywować dostęp do aplikacji DOJ tabletek.",
                    label = "DOJ tabletki",
                },
                dojTaxes = {
                    description = "Okresowe gromadzenie podatków pojazdowych i domowych od graczy online.",
                    label = "Podatki od aktywów",
                },
            },
            settingSections = {
                finance = "Finanse",
                courtroom = "Sądnictwo",
                registries = "Rejestr",
                courthouses = "Sądy sądowe",
                general = "Ogólny",
                legalCodes = "Kody prawne",
                offences = "Wygodny katalog",
                recordsAccess = "Dostęp do pliku przypadku",
                tablet = "Tabletka",
                taxes = "Podatki",
            },
            settings = {
                dojRegistryLicenses = {
                    label = "Rejestry licencji",
                    description = "Wybierz licencje, które DOJ może wydawać. Każda pozycja ma osobny rejestr. Usunięcie pozycji nie odbiera istniejących licencji.",
                },
                dojRegistryAccess = {
                    ["label"] = "Dostęp do rejestrów z plików",
                    ["description"] = "Dostosuj dostęp do rejestrów w config/registry. Pusta lista używa ustawień z plików. Pola i funkcje serwera/klienta edytuje się w plikach Lua.",
                },
                dojTreasuryJob = { label = "Praca skarbca", description = "Praca, której wspólne konto otrzymuje pobrania i finansuje przelewy." },
                dojFinanceJobs = { label = "Widoczne frakcje", description = "Klucze zarejestrowanych prac w przeglądzie kont. Skarbiec jest zawsze uwzględniony." },
                dojFinanceLimit = { label = "Limit transakcji", description = "Maksymalna kwota jednego przelewu lub pobrania." },
                dojFinePaymentMode = { label = "Płatność nałożonych grzywien", description = "Bezpośrednia płatność bankowa lub zewnętrzna faktura. Wystawienie faktury nie potwierdza zapłaty.", options = { bank = "Płatność bankowa", billing = "Faktura" } },
                dojFineSociety = { label = "Odbiorca grzywien", description = "Praca, której wspólne konto otrzymuje nałożone grzywny." },
                dojCourtroomBoardMove = {
                    label = "Przesuń tablicę sali sądowej",
                    description = "Domyślny klawisz do złapania lub uwolnienia tablicy mobilnej (np. F). Gracze mogą go zastąpić w przyłączaniu klawiszy FiveM. Przemieszczanie jest tymczasowe i resetuje się po restarcie.",
                },
                dojCourtroomGavel = {
                    label = "Sędzia Flawl",
                    description = "Model postawy, dołączenie ręczne, animacja, wzory dźwięku i strike. Zmiany również mają zastosowanie bez restartowania.",
                },
                dojHearingParticipantRoles = {
                    label = "Role uczestników",
                    description = "Role domyślne: oskarżony, świadk, przysięgły, sędzia. Dodaj tu specjalne małe klucze (do 24 znaków, dozwolone podkreślenia). Zachować sędzię. Zazwyczaj role nie udzielają sędziemu ani przysięgłym pozwoleń.",
                },
                dojWarrantTemplateCodes = {
                    label = "Kody szablonu nakazu",
                    description = "Kody szablonów przedstawione w pozycji PD Nakazy po podpisaniu sądowym i udostępnieniu. Domyślnie: HB, DB, RB.",
                },
                dojRegistryCatalog = {
                    label = "DOJ rejestry",
                    description = "Aktywacja i nazwa DOJ rejestrów, następnie ustaw zawód dostęp i klirens. Obowiązujące DOJ uprawnienia rola nadal obowiązują. Zastrzeżone RP rejestry są zarządzane w zawodach Base.",
                },
                dojCourthouseBlipCategory = {
                    description = "Etykieta kategorii używana do blips mapy sądu.",
                    label = "Kategoria blipsów",
                },
                dojCourthouseBlipColor = {
                    description = "Kolor mapy używany do sądu.",
                    label = "Kolor ciśnienia",
                },
                dojCourthouseBlipScale = {
                    description = "Skala mapy używana do blips sądu.",
                    label = "Skal Blip",
                },
                dojCourthouseBlipShortRange = {
                    description = "Pokaż tylko blipy sądu na krótkim zasięgu.",
                    label = "Krótki zakres",
                },
                dojCourthouseBlipSprite = {
                    description = "Mapa spryt używany do sądu.",
                    label = "Spryt błyszczący",
                },
                dojLegalBookItem = {
                    description = "Pozycja inwentaryczna dla stałej edycji kodu prawnego. Pierwsze użycie zachowuje jego zawartość i datę; wymaga poszczególnych elementów z metadanymi.",
                    label = "Pozycja książki prawnej",
                },
                dojLegalCreateBookRateLimitMs = {
                    description = "Minimalne milisekundy między żądaniami tworzenia książek prawnych.",
                    label = "Utwórz chłodzenie książki",
                },
                dojLegalCreateRevisionRateLimitMs = {
                    description = "Minimalne milisekundy między żądaniami o utworzenie rewizji.",
                    label = "Tworzenie modyfikacji chłodzenia",
                },
                dojLegalDeleteBookRateLimitMs = {
                    description = "Minimalne milisekundy między żądaniami usuwania książki prawnej.",
                    label = "Usuń chłodzenie książki",
                },
                dojLegalDeleteRevisionRateLimitMs = {
                    description = "Minimalne milisekundy między żądaniami usuwania rewizji.",
                    label = "Usuń chłodzenie poprawek",
                },
                dojLegalGetBookRateLimitMs = {
                    description = "Minimalne milisekundy między żądaniami o książkę prawną.",
                    label = "Wczytaj chłodzenie książki",
                },
                dojLegalGetBooksRateLimitMs = {
                    description = "Minimalne milisekundy między żądaniami w sprawie listy prawnych.",
                    label = "Wczytaj chłodzenie biblioteki",
                },
                dojLegalLargeRequestTimeoutMs = {
                    description = "Minimalny czas czasowy stosowany dla dużych wymagań dotyczących dokumentów.",
                    label = "Wielki czas oczekiwania w milisekundach",
                },
                dojLegalMaxAbbreviationLength = {
                    description = "Maksymalna liczba znaków dozwolonych w skrócie prawnym.",
                    label = "Maksymalna długość skrócenia",
                },
                dojLegalMaxBookTitleLength = {
                    description = "Maksymalna liczba znaków dozwolonych w tytule prawnym.",
                    label = "Maksymalna długość tytułu książki",
                },
                dojLegalMaxContentBytes = {
                    description = "Maksymalny rozmiar serializacji jednej kompletnej zmiany prawnej.",
                    label = "Maksymalny rozmiar zawartości w bajtach",
                },
                dojLegalMaxParagraphTitleLength = {
                    description = "Maksymalna długość tytułu zaakceptowana podczas przywozu ustrukturyzowanych akapitów.",
                    label = "Maksymalna długość tytułu akapitu starszego",
                },
                dojLegalMaxParagraphsPerBook = {
                    description = "Maksymalna liczba ustrukturyzowanych ustępów zaakceptowanych podczas przywozu z dawna.",
                    label = "Maksymalne ustępy dziedziczące na księgę",
                },
                dojLegalMaxRevisionSummaryLength = {
                    description = "Maksymalna liczba znaków dozwolonych w notatce do przeglądu.",
                    label = "Maksymalna długość modyfikacji",
                },
                dojLegalMaxRichTextNodes = {
                    description = "Maksymalna liczba węzłów edytorskich dozwolona w jednej zmianie.",
                    label = "Maksymalna liczba węzłów bogatego tekstu",
                },
                dojLegalPayloadBytesPerSecond = {
                    description = "Ograniczenie przepustowości dla każdego gracza wykorzystywane do przekazywania dużych dokumentów prawnych.",
                    label = "Stopa transferu w bajtach na sekundę",
                },
                dojLegalReorderBooksRateLimitMs = {
                    description = "Minimalne milisekundy między żądaniami ustawodawczymi.",
                    label = "Przekształcenie księg chłodzenia",
                },
                dojLegalUpdateBookRateLimitMs = {
                    description = "Minimalne milisekundy pomiędzy aktualizacjami metadanych prawnych.",
                    label = "Aktualizacja książki",
                },
                dojLegalVisibleRevisionHistory = {
                    description = "Maksymalna liczba zmian załadowanych przy otwarciu książki prawnej.",
                    label = "Widoczna historia przeglądów",
                },
                dojOffenceCalculateRateLimitMs = {
                    description = "Minimalne milisekundy pomiędzy podglądami kalkulatora na stronie serwera.",
                    label = "Zwijanie kalkulatora",
                },
                dojOffenceGetCatalogueRateLimitMs = {
                    description = "Minimalne milisekundy między wymogami katalogowymi.",
                    label = "Wczytaj katalog chłodzenie",
                },
                dojOffenceMaxSelection = {
                    description = "Maksymalna liczba przestępstw objętych podglądem jednego kalkulatora.",
                    label = "Maksymalny wybór",
                },
                dojOffenceMutationRateLimitMs = {
                    description = "Minimalne milisekundy pomiędzy zmianami w katalogu przestępstw.",
                    label = "Katalog edycja chłodzenia",
                },
                dojOffenceMirandaWarning = {
                    description = "Właściwe ostrzeżenie wyświetlone w drobnym katalogu. Pozostaw puste, aby używać standardowego tekstu w wybranym języku.",
                    label = "Ostrzeżenie Mirandy",
                },
                dojPrimaryColor = {
                    description = "Kolor główny używany w grupie zawodów DOJ i tabletki.",
                    label = "Kolor główny",
                },
                dojRecordsCourtAdministrationGradeKeys = {
                    description = "Oceny te pracują z administracją sądu i rejestrami.",
                    label = "Administracja sądu",
                },
                dojRecordsJudiciaryGradeKeys = {
                    description = "Te oceny pracują z rejestrami sądowymi i decyzjami.",
                    label = "Sędzia",
                },
                dojRecordsMappingVersion = {
                    description = "Opublikowano rewizję mapowania klasy-to-records-domain. Pusta wartość zachowuje zapisy niedostępne.",
                    label = "Wersja publikacji",
                },
                dojRecordsProsecutionGradeKeys = {
                    description = "Te oceny pracują z aktami oskarżenia.",
                    label = "Prokuratura",
                },
                dojTabletRequireDuty = {
                    description = "Jedynie pracownicy w służbie pracy DOJ mogą otworzyć aplikację legalnego kodu.",
                    label = "Wymagane cło",
                },
                dojTaxCurrency = {
                    description = "Sky Base currency used only when the payment method is direct.",
                    label = "Waluta bezpośrednia",
                },
                dojTaxHouseAmount = {
                    description = "Kwota naliczana za każdy dom należący do gracza.",
                    label = "Podatek na dom",
                },
                dojTaxInitialDelaySeconds = {
                    description = "W sekundy czekać przed pierwszą kolekcją, gdy nie jest przechowywany poprzedni cykl podatkowy.",
                    label = "Opóźnienie początkowe",
                },
                dojTaxIntervalMinutes = {
                    description = "Między automatycznymi cyklami zbierania aktywów i podatków.",
                    label = "Odstęp odstępu kolekcji",
                },
                dojTaxNotifyPlayer = {
                    description = "Powiadomienie graczy po bezpośredniej kolekcji, składaniu ustawy lub niewystarczających funduszy.",
                    label = "Informuj graczy",
                },
                dojTaxPaymentMode = {
                    description = "Użyj wybranego salda bankowego/pieniężnego bezpośrednio lub złożyć jeden rachunek społeczeństwa Sky Base na gracza opodatkowanego i cykl podatkowy.",
                    label = "Metoda płatności",
                    options = {
                        bills = "Sky Base bills",
                        direct = "Bank / saldo pieniędzy",
                    },
                },
                dojTaxSocietyJob = {
                    description = "DOJ zawodu, którego skonfigurowane konto społeczne otrzymuje wszystkie zgromadzone dochody podatkowe.",
                    label = "Odbiorca DOJ zawodu",
                },
                dojTaxVehicleAmount = {
                    description = "Kwota naliczana za każdy pojazd posiadany przez gracza.",
                    label = "Podatek na pojazd",
                },
            },
            printers = {
                groups = {
                    paper = "Papier",
                    ink = "Tusz",
                    general = "Drukarka",
                    printing = "Drukowanie i dostęp",
                    placement = "Model i położenie",
                },
                actions = {
                    selectExisting = "Wybierz istniejącą drukarkę",
                    selectExistingHint = "Wyceluj w drukarkę. Enter: wybierz · Esc: anuluj",
                    add = "Dodaj drukarkę",
                    open = "Sprawdź drukarkę",
                    place = "Ustaw drukarkę",
                    setPosition = "Użyj bieżącej pozycji",
                },
                classes = {
                    office = "Biurowa",
                    professional = "Profesjonalna",
                    standard = "Standardowa",
                },
                description = "Skonfiguruj drukarki, materiały, kolejki, dostęp i położenie dla tej pracy.",
                fieldDescriptions = {
                    paperCapacity = "Maksymalna ilość papieru w każdej drukarce tej pracy.",
                    paperEnabled = "Po włączeniu drukarki tej pracy są początkowo puste i wymagają wspólnego przedmiotu do uzupełniania.",
                    refillAmount = "Ilość papieru dodawana do drukarki tej pracy po użyciu wspólnego przedmiotu do uzupełniania.",
                    refillItem = "Wewnętrzna nazwa przedmiotu w ekwipunku zużywanego podczas uzupełniania drukarki tej pracy.",
                },
                fields = {
                    active = "Aktywna",
                    class = "Klasa",
                    heading = "Kierunek",
                    id = "Stały identyfikator",
                    label = "Nazwa",
                    maxQueue = "Pojemność kolejki",
                    minimumGrade = "Minimalny stopień",
                    paperCapacity = "Pojemność papieru",
                    paperEnabled = "Wymagaj uzupełniania papieru",
                    propModel = "Model obiektu",
                    refillAmount = "Papier na przedmiot do uzupełniania",
                    refillItem = "Przedmiot do uzupełniania",
                    deleteCopiesAfterRestart = "Usuń kopie po restarcie",
                    deleteCopiesAfterRestartHint = "Usuń nieodebrane wydruki po restarcie usługi drukowania.",
                    spawnProp = "Utwórz obiekt",
                    speed = "Szybkość drukowania",
                    status = "Stan",
                    x = "X",
                    y = "Y",
                    z = "Z",
                },
                info = {
                    class = "Klasa: {class}",
                    paper = "Papier: {paper} / {capacity}",
                    queue = "Kolejka: {queue} / {maxQueue}",
                    status = "Stan: {status}",
                    title = "Drukarka",
                },
                messages = {
                    grade_too_low = "Masz zbyt niski stopień, aby używać tej drukarki.",
                    invalid_amount = "Ilość do uzupełnienia jest nieprawidłowa.",
                    missingModel = "Przed ustawieniem wybierz prawidłowy model drukarki.",
                    missing_refill_item = "Nie masz skonfigurowanego przedmiotu do uzupełniania.",
                    no_refill_printer = "W pobliżu nie ma dostępnej drukarki zużywającej papier.",
                    paper_capacity_exceeded = "Pojemność papieru zostałaby przekroczona.",
                    paper_disabled = "Zużycie papieru jest wyłączone dla tej drukarki.",
                    paper_full = "Podajnik papieru tej drukarki jest już pełny.",
                    printer_inactive = "Ta drukarka jest nieaktywna.",
                    printer_not_found = "Drukarka już nie istnieje.",
                    refill_cooldown = "Poczekaj chwilę przed ponownym uzupełnieniem.",
                    refilled = "Dodano {amount} arkuszy. Zapas: {paper} / {capacity}.",
                    too_far_away = "Podejdź bliżej drukarki.",
                    unavailable = "Drukarka jest niedostępna.",
                    wrong_job = "Twoja praca nie zapewnia dostępu do tej drukarki.",
                },
                settings = {
                    description = "Te ustawienia dotyczą wszystkich drukarek skonfigurowanych dla tej pracy.",
                    title = "Wspólne ustawienia drukarek dla pracy",
                },
                statuses = {
                    maintenance = "Konserwacja",
                    offline = "Odłączona",
                    online = "Połączona",
                },
                title = "Drukarki",
                values = {
                    disabled = "Wyłączone",
                    enabled = "Włączone",
                    selectItem = "Wybierz przedmiot",
                },
            },
            configs = {
                sky_dojjob = {
                    subtitle = "Konfiguracja DOJ zawodów, lokalizacji sądu, i aplikacja legal-code.",
                    title = "Zawódy Ministerstwa Sprawiedliwości",
                },
            },
            creatorSections = {
                courthouses = {
                    entryLabel = "Sędzia",
                    entryPluralLabel = "Sądy sądowe",
                    label = "Sądy sądowe",
                },
            },
            extensions = {
                invalidSelection = "Nieprawidłowy wybór: {value}",
                trainingSettings = {
                    description = "Konfiguracja dostępu do szkoleń, rejestracji, zatwierdzeń i planowania kursu dla tej pracy.",
                    label = "Ustawienia treningu",
                },
            },
            locations = {
                stationPosition = "Lokalizacja / blip na mapie",
                stationPositionHint = "Główny punkt tej lokalizacji pracy. Jeśli znacznik na mapie jest włączony w Praca → Znaczniki, pojawi się tutaj.",
                addCourtroom = "Dodaj salę sądową",
                courtroom = "Sądnictwo",
                courtroom_display_desk_27 = "Wyświetlanie dowodów sądowych – 27-incowy monitor biurka",
                courtroom_display_wall_55 = "Wyświetlanie dowodów sądowych – 55-calowa ściana TV",
                courtroom_display_wall_75 = "Wyświetlanie dowodów sądowych – 75-calowa ściana TV",
                courtroom_display_wall_100 = "Wyświetlanie dowodów sądowych – 100-calowa ściana TV",
                courtroom_display_wall_120 = "Wyświetlanie dowodów sądowych – 120-calowa ściana TV",
                courtroom_display_wall_150 = "Wyświetlanie dowodów sądowych – 150-calowa ściana TV",
                courtroom_display_board_93 = "Zarząd interaktywny – 150-inch mobilne stoisko",
                courtroom_display_projection = "Wyświetlanie dowodów sądowych – 4.5 m ekran projekcji",
                courtroom_judge_mic = "Sąd – mikrofon sędzia",
                courtroom_jury_room = "Sąd – sala przysięgłych",
                courtroom_room = "Sądnictwo – publiczność / centrum pokoju",
                courtroom_witness = "Sędzia – stanowisko świadków",
                electionBooth = "Głosowanie Booth",
                publicDisplayDesk27 = "Wyświetlanie publiczne – 27-inch monitor biurka",
                publicDisplayTerminal43 = "Wyświetlanie publiczne – 43- inc Floor Terminal",
                publicDisplayWall55 = "Wyświetlanie publiczne – 55- calowa ściana TV",
                publicDisplayWall75 = "Wyświetlanie publiczne – 75- calowa ściana TV",
                publicDisplayWall100 = "Wyświetlanie publiczne – 100- calowa ściana TV",
                publicDisplayWall120 = "Wyświetlanie publiczne – 120- calowa ściana TV",
                publicDisplayWall150 = "Wyświetlanie publiczne – 150- calowa ściana TV",
                publicDisplayProjection = "Publiczny wyświetlacz – 4.5 m Projekcja Screen",
                publicLegalCode = "Kodeks prawny publiczny",
            },
            settingGroups = {
                dojWarrants = {
                    label = "Nakazy sądowe",
                },
                dojAccess = {
                    label = "Dostęp",
                },
                dojCourthouseBlip = {
                    label = "Blip mapa",
                },
                dojLegalBooks = {
                    label = "Książki",
                },
                dojLegalContentLimits = {
                    label = "Limity zawartości",
                },
                dojLegalItem = {
                    label = "Przedmiot ekwipunżu",
                },
                dojLegalRateLimits = {
                    label = "Ograniczenia stawek",
                },
                dojLegalRevisions = {
                    label = "Przeglądy",
                },
                dojLegalTransfers = {
                    label = "Duże dokumenty",
                },
                dojOffenceCalculation = {
                    label = "Kalkulator",
                },
                dojOffenceRateLimits = {
                    label = "Ograniczenia stawek",
                },
                dojOffenceMiranda = {
                    label = "Wskazówki katalogowe",
                },
                dojOffenceSource = {
                    label = "Źródło katalogu",
                },
                dojRecordsGradeBindings = {
                    description = "Przypisz każdy dostępny DOJ klasa do dokładnie jednej domeny rejestracji, a następnie opublikowaj mapowanie.",
                    label = "Domeny stopni i zapisów",
                },
                dojTaxPayment = {
                    label = "Płatność",
                },
                dojTaxRates = {
                    label = "Stopy",
                },
                dojTaxSchedule = {
                    label = "Harmonogram",
                },
            },
            registryCatalog = {
                names = {
                    notarial_contracts = "Umowy notarialne",
                    powers_of_attorney = "Uprawnienia prawnicze",
                    name_changes = "Zmiany nazw",
                    company_registry = "Rejestr przedsiębiorstw",
                    association_registry = "Rejestr stowarzyszeń",
                    licensing = "Licencja",
                    administrative_decisions = "Decyzje administracyjne",
                    administrative_objections = "Sprzeciwy administracyjne",
                },
            },
            gavel = {
                enabled = "Włączone",
                cooldown = "Uruchomienie (ms)",
                defaultPreset = "Domyślny wzór uderzenia",
                prop = "Prop. gazowy",
                model = "Nazwa modelu",
                bone = "Kość rączna ID",
                offset = "Przesunięcie (metry)",
                rotation = "Obrót (stopnie)",
                presets = "Wzór strike",
                single = "Pojedynczy strajk",
                double = "Podwójny strike",
                strikes = "Liczba strajków",
                interval = "Odstęp przekroczenia (ms)",
                impact = "Opóźnienie dźwięku (ms)",
                audio = "Dźwięk",
                asset = "Aktywa audio",
                volume = "Tom",
                animation = "Ożywienie",
                dict = "Słownik animacji",
                clip = "Nazwa animacji",
                duration = "Czas trwania ruchu (ms)",
                flag = "Flagdy animacji",
                x = "X",
                y = "Y",
                z = "Z",
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "Umożliwia pracownikom udział w dostępnych sesjach szkoleniowych.",
                approvalRequired = "Utrzymuje się do czasu zatwierdzenia ich przez upoważnionego instruktora.",
                defaultCapacity = "Domyślna liczba miejsc używanych przy tworzeniu nowej sesji treningowej.",
                enabled = "Udostępnia aplikację treningową do tej pracy.",
                requireOnDuty = "Wymaga, aby pracownicy byli na służbie przed otwarciem lub użyciem aplikacji szkoleniowej.",
                upcomingDays = "Liczba przyszłych dni pokazanych w programie Training App.",
            },
            trainingFields = {
                allowSelfEnrollment = "Zezwalaj na samodzielne włączanie",
                approvalRequired = "Wymagane zatwierdzenie rejestracji",
                defaultCapacity = "Domyślna pojemność",
                enabled = "Włącz szkolenie",
                requireOnDuty = "Wymagane cło",
                upcomingDays = "Okres bieżący (dni)",
            },
        },
    },
}
