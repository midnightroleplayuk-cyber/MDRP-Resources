JobConfigLocales["sky_crimesystem:pl"] = {
    Nui = {
        workshopConfig = {
            creatorCommand = "Bezpośrednie polecenie",
            roleDefaults = {
                title = "Role",
                description = "Wybierz minimalną rangę dla każdego domyślnego uprawnienia. Uprawnienia rang zapisane w menu szefa mają pierwszeństwo.",
                bossHint = "Rangi szefa i zastępcy zawsze zachowują pełny dostęp.",
                empty = "Ta praca nie ma jeszcze dostępnych rang.",
                gradesTitle = "Rangi pracy",
                noDefault = "Brak domyślnego uprawnienia",
                rankOption = "{grade} – {label}",
            },
            weaponDefaultsDescription = "Wspólne wartości dotyczą pól dziedziczących. Zmiana na stronie ustawień przełącza pole na własną wartość. Istniejące wpisy zachowują swoje wartości.",
            weaponStreetDescription = "Podczas kontaktu ulicznego związanego z narkotykami serwer może czasem kupić dozwoloną broń. Wybór, cena i wypłata są ustalane po stronie serwera.",
            weaponGroups = {
                general = "Ogólne wartości domyślne",
                access = "Domyślny dostęp",
                collection = "Domyślne zbieranie",
                production = "Domyślna produkcja",
                market = "Domyślny rynek",
                delivery = "Domyślne zlecenia",
                street = "Uliczna sprzedaż broni",
            },
            weaponOptions = {
                scrap_search = "Przeszukaj stertę złomu",
                player = "Na gracza",
                global = "Globalny",
                money = "Gotówka",
                bank = "Konto bankowe",
                black_money = "Czarne pieniądze",
                timing = "Zatrzymaj wskaźnik w optymalnym zakresie.",
                precision = "Wykonuj każde cięcie w oknie precyzji.",
                pressure = "Zatrzymaj prasę przy optymalnym ciśnieniu.",
            },

            reputation = {
                remove = "Usuń",
                title = "Reputacja",
                action = "Akcja",
                points = "Punkty za ukończenie",
                enabled = "Aktywna",
                search = "Szukaj akcji",
                added = "Już dodana",
                noResults = "Nie znaleziono pasujących akcji.",
                empty = "Brak akcji. Dodaj akcję przyciskiem plus.",
                name = "Nazwa reguły",
                target = "Cel (opcjonalny)",
            },
            configs = {
                sky_crimesystem = {
                    entries = "Frakcje",
                    subtitle = "Skonfiguruj prace przestępcze i ich wspólne lokalizacje.",
                    title = "System przestępczości",
                },
            },
            creatorSections = {
                mainbaseZones = {
                    entryLabel = "Baza główna",
                    entryPluralLabel = "Bazy główne",
                    label = "Strefa bazy głównej",
                },
                presetTerritories = {
                    label = "Szablony dzielnic",
                    entryLabel = "Szablon dzielnicy",
                    entryPluralLabel = "Szablony dzielnic",
                },
                customTerritories = {
                    label = "Własne terytoria",
                    entryLabel = "Własne terytorium",
                    entryPluralLabel = "Własne terytoria",
                },
                objectsSection = {
                    label = "Obiekty przesłuchań",
                    entryLabel = "Obiekt",
                    entryPluralLabel = "Obiekty przesłuchań",
                },
                blockedZonesSection = {
                    label = "Strefy zablokowane",
                    entryLabel = "Strefa",
                    entryPluralLabel = "Strefy zablokowane",
                },
                toolsSection = {
                    label = "Narzędzia",
                    entryLabel = "Narzędzie",
                    entryPluralLabel = "Narzędzia",
                },
                sessionsSection = {
                    label = "Trwające przesłuchania",
                    entryLabel = "Przesłuchanie",
                    entryPluralLabel = "Trwające przesłuchania",
                },
                orphansSection = {
                    label = "Osierocone obiekty",
                    entryLabel = "Obiekt",
                    entryPluralLabel = "Osierocone obiekty",
                },
            },
            darknetActions = {
                currentLocation = "Użyj aktualnej lokalizacji",
            },
            drugSettings = {
                drugGrowthCurve = {
                    description = "Wyższe wartości znacznie spowalniają wzrost przy słabej pielęgnacji, zachowując jednocześnie silne bonusy przy dobrej pielęgnacji.",
                    label = "Krzywa reakcji na pielęgnację",
                },
                drugGrowthMaxMultiplier = {
                    description = "Maksymalny mnożnik wzrostu osiągnięty przy doskonałych warunkach.",
                    label = "Mnożnik przy idealnej pielęgnacji",
                },
                drugGrowthMinMultiplier = {
                    description = "Mnożnik wzrostu stosowany, gdy warunki uprawy są krytycznie złe.",
                    label = "Mnożnik przy krytycznej pielęgnacji",
                },
                drugGrowthQualityBonusMax = {
                    description = "Maksymalny dodatkowy bonus do wzrostu przyznawany przez jakość rośliny.",
                    label = "Bonus do wzrostu za jakość",
                },
            },
            errors = {
                invalid_role_permission_defaults = "Wybierz prawidłowe minimalne rangi dla uprawnień ról.",
                base_raid_locked = "Baza jest atakowana. Jej lokalizacje składowania i konfiguracja są zablokowane.",
                base_storage_outside_zone = "Wszystkie punkty składowania, szafek i napadów muszą znajdować się w strefie bazy.",
                base_zone_invalid_polygon = "Umieść co najmniej trzy odrębne punkty bez przecinających się krawędzi, a następnie sprawdź wysokość (3–200 m) oraz bucket routingu.",
                base_zone_point_limit = "Strefa głównej bazy obsługuje maksymalnie 64 punktów granicznych.",
                base_zone_required = "Najpierw skonfiguruj ważną strefę głównej bazy dla tej pracy przestępczej.",
                crime_interrogation_invalid_model = "Podaj prawidłowy model obiektu.",
                crime_interrogation_invalid_coords = "Umieść obiekt w prawidłowej pozycji.",
                crime_interrogation_invalid_zone_points = "Ustaw co najmniej trzy prawidłowe punkty graniczne.",
                crime_interrogation_duplicate_id = "Obiekt o tym ID już istnieje.",
                crime_interrogation_tool_invalid = "Sprawdź definicję narzędzia.",
                crime_interrogation_tool_id_invalid = "Podaj prawidłowy identyfikator narzędzia.",
                crime_interrogation_tool_label_missing = "Podaj nazwę narzędzia.",
                crime_interrogation_effect_missing = "Skonfiguruj efekt narzędzia.",
                crime_interrogation_effect_type_unknown = "Wybierz obsługiwany typ efektu.",
                crime_interrogation_effect_status_missing = "Określ stan zmieniany przez narzędzie.",
                crime_interrogation_minigame_missing = "Skonfiguruj minigrę narzędzia.",
                crime_interrogation_minigame_type_unknown = "Wybierz obsługiwany typ minigry.",
                crime_interrogation_keys_missing = "Skonfiguruj sterowanie narzędziem.",
                crime_interrogation_keys_invalid = "Sprawdź skonfigurowane klawisze narzędzia.",
                crime_interrogation_keys_duplicate = "Przypisz każdą akcję i klawisz narzędzia tylko raz.",
                crime_interrogation_anim_invalid = "Sprawdź słownik i klip animacji narzędzia.",
                crime_interrogation_anim_missing = "Skonfiguruj animację użytkownika narzędzia.",
                crime_interrogation_occupied = "Do tego obiektu jest już ktoś przywiązany.",
                crime_interrogation_not_found = "To już nie istnieje.",
            },
            extensions = {
                baseZone = {
                    description = "Ustaw punkty graniczne 3 do 64 w odpowiedniej kolejności. Najniżej umieszczony punkt określa dół; wysokość rozciąga się od niego w górę. Punkty są zapisywane jako szkic; użyj „Zapisz”, aby zastosować strefę. Tylko magazyny, szafki i magazyny napadów wewnątrz strefy są dostępne podczas rajdów. Punkty poza strefą nie uniemożliwiają zapisu ani rozpoczęcia rajdu. Dotychczasowe granice pozostają aktywne do momentu zapisania zmian.",
                    fields = {
                        bucket = "Routing wiadro",
                        configured = "Skonfigurowano",
                        height = "Wysokość (metry)",
                        radius = "Promień (metry)",
                        x = "Środek X",
                        y = "Środek Y",
                        z = "Środek Z",
                    },
                    label = "Strefa bazy głównej",
                },
                invalidSelection = "Nieprawidłowy wybór: {value}",
            },
            locationDescriptions = {
                crimeStationPosition = "Główny punkt tej lokalizacji pracy. Jeśli znacznik na mapie jest włączony w Praca → Znaczniki, pojawi się tutaj.",
            },
            locationTypes = {
                crimeStationPosition = "Lokalizacja / blip na mapie",
                heistCrafting = "Warsztat napadu",
                heistStorage = "Magazyn napadów",
            },
            membershipMigration = {
                cancel = "Anuluj",
                confirm = "Migruj i zapisz",
                message = "Istniejące członkostwa w organizacjach zostaną przeniesione do wybranego modelu. W trybie niezależnym normalne zatrudnienie pozostaje oddzielne.",
                title = "Czy zmienić model członkostwa?",
            },
            moneywashActions = {
                currentLocation = "Użyj bieżącej lokalizacji",
                invalidLocations = "Sprawdź ID, nazwy, wybór wnętrz i współrzędne. Każda lokalizacja musi mieć unikalne ID.",
                position = "Pozycja",
            },
            moneywashBusiness = {
                moneywashBuildNodes = { label = "Punkty budowy", description = "Ustawiaj zgodny sprzęt na tych punktach. Współrzędne są względem wybranego wnętrza." },
                mwBuildNodes = "Punkty budowy",
                moneywashPublicEquipment = { label = "Sprzęt publiczny", description = "Przypisz pralki, generatory i wentylatory do publicznych zakładów oraz zgodnych punktów." },
                mwPublicEquipment = "Sprzęt publiczny",
                moneywashMaterials = { label = "Materiały", description = "Używaj dokładnych nazw przedmiotów. Masa w gramach; zainstaluj brakujące przedmioty." },
                mwMaterials = "Materiały",
                moneywashMaterialRecipes = { label = "Receptury materiałów", description = "Wejścia, wyjścia i czas dotyczą jednostki. Przetwórcy używają tych receptur." },
                mwMaterialRecipes = "Receptury materiałów",
                moneywashProductionRecipes = { label = "Receptury druku", description = "Papier, farba i czasy dotyczą jednostki. Gotówka po suszeniu i kontroli jakości." },
                mwProductionRecipes = "Receptury druku",
                moneywashCollectors = { label = "Zbieracze", description = "Skonfiguruj uzysk, narzędzia, oczekiwanie i pozycję każdego zbieracza." },
                mwCollectors = "Zbieracze",
                moneywashProcessors = { label = "Przetwórcy", description = "Wybierz recepturę materiału i pozycję każdego przetwórcy." },
                mwProcessors = "Przetwórcy",

                control = "Panel sterowania",
                editor = {
                    addBusiness = "Dodaj firmę",
                    addInterior = "Dodaj wnętrze",
                    advanced = "Szczegóły techniczne",
                    asset_ipl = "IPL: Wprowadź dokładną nazwę IPL i pozycję wnętrza.",
                    asset_mlo = "MLO: Użyj pozycji zainstalowanego wnętrza. Obecnie dostęp odbywa się przez wejście do biznesu.",
                    asset_shell = "Shell: Zasób modelu musi być zainstalowany i uruchomiony na serwerze.",
                    businessHelp = "Nadaj nazwę firmie, wybierz jej wnętrze i ustal cenę zakupu.",
                    businessListHelp = "Zarządzaj wejściami i cenami zakupu dla swoich firm.",
                    businesses = "Biznesy",
                    capture = "Ustaw w grze",
                    captureOrigin = "Ustaw pozycję wnętrza",
                    chooseInterior = "Wybierz wnętrze",
                    coordinates = "Edytuj współrzędne",
                    editSections = "Konfiguracja",
                    emptyBusinessHelp = "Powiąż wejście na mapie z wnętrzem. Twoje organizacje będą mogły następnie kupić pusty biznes.",
                    emptyBusinesses = "Twój pierwszy biznes",
                    emptyInteriorHelp = "Połącz IPL, shell lub zainstalowane MLO, a następnie ustaw punkty używane przez firmę.",
                    emptyInteriors = "Twoje pierwsze wnętrze",
                    entranceHelp = "Ustaw wejście, przez które gracze będą kupować i wchodzić do firmy.",
                    freecamHelp = "Freecam: WASD ruch, Q/E góra/dół, Shift szybciej, Ctrl wolniej. Prawy przycisk myszy: rozglądanie. Przeciągnij gizmo, R obrót/przesunięcie, Enter ustaw, Backspace anuluj.",
                    general = "Ogólne",
                    heading = "Kierunek",
                    interiorHelp = "Wybierz typ wnętrza oraz jego zasób.",
                    interiorListHelp = "Przygotuj puste przestrzenie. Gracze sami umieszczają swoje maszyny i sprzęt.",
                    interiors = "Wnętrza",
                    listEmpty = "Brak wpisów.",
                    locationTypes = "Zarządzanie lokalizacją",
                    newBusiness = "Nowa firma",
                    newInterior = "Nowe wnętrze",
                    noResults = "Brak pasujących wpisów.",
                    notSet = "Nie ustawiono",
                    offsetHelp = "Wprowadzane wartości to przesunięcia względem punktu początkowego. Pozycja w świecie jest wyświetlana powyżej.",
                    origin = "Punkt początkowy",
                    originHelp = "Pozycja wnętrza. Wszystkie pozostałe punkty są względem niej.",
                    originRequired = "Najpierw ustaw pozycję wnętrza w zakładce Ogólne.",
                    outsideRange = "Poza zakresem {range} metrów",
                    point_control = "Przesuń i obróć panel ścienny za pomocą gizmo, aby ustawić go na miejscu. Potwierdzana wysokość obiektu zostanie zachowana dokładnie. Przełącz jego znacznik w menu Interakcje → Money Wash: panel sterowania.",
                    point_entry = "Tutaj gracze przybywają i stąd wychodzą. Wyjście automatycznie przenosi ich do wejścia do ich biznesu na zewnątrz.",
                    point_position = "Ten punkt znajduje się poza biznesem.",
                    point_storage = "Przesuń i obróć regał za pomocą gizmo, aż spocznie na podłodze. Członkowie korzystają tutaj z zakupionego sprzętu. Przełącz jego znacznik w menu Interakcje → Money Wash: magazyn.",
                    points = "Punkty",
                    pointsHelp = "Wybierz punkt i ustaw go bezpośrednio w grze.",
                    rangeNote = "Obowiązuje promień {range} metrów wokół punktu początkowego wnętrza, bez ograniczenia wysokości.",
                    remove = "Usuń",
                    repairRange = "Przesuń te punkty bliżej punktu początkowego wnętrza.",
                    saveHint = "Zastosuj zmiany, klikając Zapisz na górze.",
                    search = "Szukaj …",
                    set = "Ustawiono",
                    teleport = "Teleportacja",
                    viewInteriors = "Zobacz wnętrza",
                    visit = "Odwiedź",
                    visitHint = "Poruszaj się swobodnie. Naciśnij Backspace, aby wrócić do edytora.",
                    visitTitle = "Wizyta we wnętrzu",
                },
                entry = "Wejście i wyjście",
                fields = {
                    mode = "Tryb dostępu",
                    ownerKind = "Typ właściciela",
                    productionEnabled = "Dostępne rozszerzenie drukarskie",
                    feePercent = "Opłata (%) / -1 = globalna",
                    storageCapacity = "Pojemność magazynu (przedmioty)",
                    maximumOrders = "Równoczesne zamówienia na gracza",
                    gridPower = "Moc sieci / 0 = generator",
                    autoService = "Automatyczny serwis publiczny",
                    maximumPendingOutputs = "Maksymalna liczba oczekujących wypłat",
                    placementRange = "Promień ustawiania (m)",
                    placementHeight = "Zakres wysokości ustawiania (m)",
                    interiorId = "ID wnętrza",
                    equipmentId = "ID sprzętu",
                    nodeId = "ID punktu budowy",
                    generatorNode = "ID punktu generatora",
                    maxOffset = "Maksymalne przesunięcie od punktu (m)",
                    maxHeight = "Maksymalne przesunięcie pionowe (m)",
                    weight = "Masa przedmiotu (g)",
                    inputItem = "Materiał wejściowy",
                    secondItem = "Drugi materiał wejściowy",
                    outputItem = "Materiał wyjściowy",
                    requiredTool = "Wymagane narzędzie",
                    baseQuality = "Jakość początkowa (%)",
                    minimumQuality = "Minimalna jakość (%)",
                    inspectionCards = "Karty kontrolne",
                    inspectionPenalty = "Utrata jakości za błąd (%)",
                    rejectPercent = "Odrzucone banknoty (%)",
                    accessoryModel = "Model dodatkowy",
                    accessoryMaximum = "Maksymalna liczba widocznych dodatków",
                    accessoryActiveOnly = "Dodatki tylko podczas przetwarzania",
                    animDict = "Słownik animacji",
                    animClip = "Klip animacji",
                    cooldown = "Czas oczekiwania (sekundy)",
                    minimum = "Minimalny uzysk",
                    maximum = "Maksymalny uzysk",
                    productionPrice = "Drukowanie pieniędzy · Cena zakupu",
                    recipeId = "Receptura ID",
                    inputAmount = "Materiał / na jednostkę",
                    secondAmount = "Materiał / na jednostkę",
                    outputAmount = "Materiał / na jednostkę",
                    paperItem = "Papier drukarski",
                    inkItem = "Farba drukarska",
                    paperAmount = "Papier drukarski / na jednostkę",
                    inkAmount = "Farba drukarska / na jednostkę",
                    notesPerUnit = "Banknoty / na jednostkę",
                    valuePerNote = "Gotówka / Banknoty",
                    maximumUnits = "Jednostki (max.)",
                    printSeconds = "Drukowanie / na jednostkę (Sekundy)",
                    inspectionSeconds = "Kontrola / na jednostkę (Sekundy)",
                    rinseSeconds = "Płukanie / na jednostkę (Sekundy)",
                    drySeconds = "Suszenie / na jednostkę (Sekundy)",
                    accessoryUnit = "Banknoty / na jednostkę",
                    accessoryX = "Model dodatkowy · X (m)",
                    accessoryY = "Model dodatkowy · Y (m)",
                    accessoryZ = "Model dodatkowy · Z (m)",
                    accessoryStep = "Model dodatkowy · Z (m)",

                    capacity = "Pojemność na cykl",
                    controlHeading = "Kierunek panelu sterowania",
                    controlHeight = "Wysokość montażu nad punktem (m)",
                    controlModel = "Model panel ścienny",
                    controlX = "Panel sterowania X",
                    controlY = "Panel sterowania Y",
                    controlZ = "Panel sterowania Z",
                    disableSets = "Ukryte zbiory encji (oddzielone przecinkiem)",
                    enableSets = "Włączone zestawy encji (oddzielone przecinkiem)",
                    entryX = "Przesunięcie wejścia X",
                    entryY = "Przesunięcie wejścia Y",
                    entryZ = "Przesunięcie wejścia Z",
                    heading = "Kierunek patrzenia",
                    id = "Unikalne ID",
                    interior = "Wnętrze",
                    ipl = "Nazwa IPL",
                    kind = "Typ",
                    label = "Imię",
                    model = "Nazwa modelu",
                    power = "Jednostki mocy",
                    price = "Cena zakupu",
                    radius = "Promień rozmieszczenia (m)",
                    repairPrice = "Cena naprawy (0 = za darmo)",
                    seconds = "Czas cyklu (sekundy)",
                    storageHeading = "Kierunek punktu magazynowego",
                    storageModel = "Model półki",
                    storageX = "Punkt magazynowy X",
                    storageY = "Punkt magazynowy Y",
                    storageZ = "Punkt magazynowy Z",
                    wear = "Zużycie na cykl (%)",
                    x = "Punkt początkowy X",
                    y = "Punkt początkowy Y",
                    z = "Punkt początkowy Z",
                },
                interactions = {
                    control = "Pranie pieniędzy: panel sterowania",
                    storage = "Pranie pieniędzy: magazyn",
                },
                item = "Wpis",
                moneywashBucketStart = {
                    description = "Zarezerwuj ten zakres wyłącznie dla Money Wash. Zmiany zostaną zastosowane przy następnym wejściu.",
                    label = "Początek zakresu instancji",
                },
                moneywashEquipment = {
                    description = "Gracze kupują i umieszczają urządzenia. Pojemność, czas trwania i zużycie dotyczą pralek. Moc zależy od zasilania z generatora lub zapotrzebowania urządzeń. Zmiany dotyczą nowych zakupów.",
                    label = "Sprzęt do zakupu",
                },
                moneywashInteriors = {
                    description = "Konfiguruj puste wnętrza IPL, shell lub MLO. Punkt wejścia, panel sterowania, magazyn i granice budowy są relatywne względem punktu początkowego. Wyjście przenosi graczy do wejścia ich firmy.",
                    label = "Wnętrza (IPL, shell lub MLO)",
                },
                moneywashMaximumEquipment = {
                    description = "Maksymalna liczba zakupionych urządzeń i zestawów naprawczych na jeden biznes.",
                    label = "Limit wyposażenia",
                },
                moneywashPreviewBucketStart = {
                    description = "Wizyta dodaje ID gracza do tej wartości dla prywatnej instancji administratora. Rezerwuj ją oddzielnie od biznesów i innych zasobów. Zmiany zostaną zastosowane w następnym podglądzie.",
                    label = "Początek zakresu instancji podglądu",
                },
                moneywashProperties = {
                    description = "Ustaw wejście, wybierz wnętrze i ustal cenę zakupu. Zakupione biznesy zachowują swoje zapisane wnętrze i układ.",
                    label = "Wejścia do biznesu",
                },
                moneywashRepairShops = {
                    description = "Ustaw sklepy naprawcze, teleportuj się do nich i ustal cenę usługi. Sprzedają zestawy naprawcze i serwisują zgromadzone maszyny.",
                    label = "Lokalizacje sklepów",
                },
                moneywashShops = {
                    description = "Umieść sklepy dla pralek, generatorów i wentylatorów. Zamówienia trafiają do wybranej firmy organizacji.",
                    label = "Lokalizacje sklepów",
                },
                mwEquipment = "Sklep ze sprzętem",
                mwInteriors = "Puste wnętrza",
                mwProperties = "Lokalizacje",
                mwRepairShops = "Warsztat naprawczy",
                mwSettings = "Ustawienia firmy",
                names = {
                    mwPublicLaundry = "Publiczna pralnia",
                    mwPaperPulp = "Masa papiernicza",
                    mwPrintingPaper = "Papier drukarski",
                    mwPrintingInk = "Farba drukarska",
                    mwPaperRecipe = "Produkcja papieru drukarskiego",
                    mwPrintingRecipe = "Zwykłe banknoty",
                    mwPaperCollector = "Zbieracz papieru",
                    mwInkCollector = "Zbieracz farby",
                    mwPaperProcessor = "Przetwórca papieru",
                    mwPrinter = "Maszyna drukarska",
                    mwInspectionTable = "Stół kontrolny",
                    mwDryingCabinet = "Szafa susząca",
                    mwNode1 = "1 · Płukanie",
                    mwNode2 = "2 · Płukanie",
                    mwNode3 = "3 · Punkty budowy",
                    mwNode4 = "4 · Drukowanie",
                    mwNode5 = "5 · Kontrola",
                    mwNode6 = "6 · Suszenie",
                    mwNode7 = "7 · Punkty budowy",

                    mwInteriorWarehouse = "Pusta hala magazynowa",
                },
                options = {
                    private = "Prywatny",
                    public = "Publiczny",
                    faction = "Organizacja",
                    person = "Postać",
                    printer = "Maszyna drukarska",
                    inspection = "Stół kontrolny",
                    dryer = "Szafa susząca",

                    fan = "Wentylator",
                    generator = "Generator",
                    ipl = "IPL",
                    mlo = "MLO",
                    repair = "Zestaw naprawczy",
                    shell = "Model Shell",
                    washer = "Pralka",
                },
                origin = "Punkt początkowy",
                storage = "Punkt magazynowy",
            },
            settingFields = {
                cultivationLevel = "Poziom uprawy",
                cultivationTitle = "Nazwa poziomu",
                cultivationRequiredXp = "Wymagane łączne XP",
                cultivationAction = "Akcja",
                cultivationXp = "XP",
                cultivationCategory = "Kategoria",
                cultivationEntry = "Wpis",
                cultivationRequiredLevel = "Wymagany poziom",
                alias = "Alias",
                atmHeading = "Kierunek",
                atmId = "ID",
                atmModel = "Model bankomatu",
                centerX = "Centrum X",
                centerY = "Centrum Y",
                centerZ = "Centrum Z",
                deliveryMethod = "Metoda dostawy",
                description = "Opis",
                enabled = "Włączone",
                groupKey = "Klucz grupy",
                id = "ID",
                itemLabel = "Etykieta towaru",
                itemName = "Nazwa przedmiotu ekwipunżu",
                knownScammer = "Znany oszust",
                locationName = "Nazwa lokalizacji",
                observerW = "Kierunek obserwatora",
                observerX = "Obserwator X",
                observerY = "Obserwator Y",
                observerZ = "Obserwator Z",
                pedModel = "Model postaci NPC",
                pickpocketItemChance = "Szansa (%)",
                pickpocketItemMaximum = "Maksymalna ilość",
                pickpocketItemMinimum = "Minimalna ilość",
                pickpocketItemName = "Nazwa przedmiotu ekwipunżu",
                quantity = "Ilość",
                radius = "Promień",
                rating = "Wyświetlana ocena",
                ratingCount = "Wyświetlana liczba ocen",
                scamChance = "Szansa na oszustwo handlarza (%)",
                shopCategory = "Kategoria",
                shopClerkHeading = "Kierunek pracownika",
                shopClerkModel = "Model pracownika",
                shopClerkRequired = "Wymagany pracownik",
                shopClerkX = "Pracownik X",
                shopClerkY = "Pracownik Y",
                shopClerkZ = "Pracownik Z",
                shopCodeEnabled = "Zezwalaj na otwieranie kodem",
                shopDrillEnabled = "Zezwalaj na wiercenie",
                shopEnabled = "Włączone",
                shopHackEnabled = "Zezwalaj na hakowanie",
                shopLocationId = "ID sklepu",
                shopLocationLabel = "Etykieta",
                shopRegisterId = "ID kasy",
                shopSafeEnabled = "Sejf włączony",
                shopSafeHeading = "Kierunek sejfu",
                shopSafeX = "Sejf X",
                shopSafeY = "Sejf Y",
                shopSafeZ = "Sejf Z",
                side = "Strona rynku",
                spawns = "Spawny drużyny",
                successfulTrades = "Wyświetlane udane transakcje",
                title = "Tytuł oferty",
                unitPrice = "Cena jednostkowa",
                verified = "Zweryfikowany handlarz",
                w = "Kierunek",
                x = "X",
                y = "Y",
                z = "Z",
                shopClerkPosition = "Pozycja pracownika",
                shopRegisterPosition = "Pozycja kasy",
                shopSafePosition = "Pozycja sejfu",
                registerId = "ID kasy",
                registerX = "Współrzędna X kasy",
                registerY = "Współrzędna Y kasy",
                registerZ = "Współrzędna Z kasy",
                heading = "Kierunek",
                captureLocation = "Zapisz pozycję",
            },
            crimeDashboard = {
                jobs = "Zarządzaj frakcjami, członkami, uprawnieniami i lokalizacjami.",
                jobCreator = "Wybierz frakcję, aby edytować jej lokalizacje i obszary.",
                jobsQuestion = "Gdzie edytować frakcje i lokalizacje?",
                jobsAnswer = "Otwórz {path}, wybierz frakcję i kliknij Edytuj. Tam skonfigurujesz jej ustawienia i lokalizacje.",
                creatorsAnswer = "Kreatory znajdziesz w {path}. Te odnośniki otwierają edytor; narzędzia frakcji zaczynają od wyboru frakcji.",
                missingAnswer = "Dostępne kreatory zależą od wybranego zasobu i jego ustawień. Narzędzia frakcji zaczynają od odpowiedniej frakcji.",
                creators = {
                    mainbaseZones = "Wybierz frakcję i skonfiguruj obszar jej bazy.",
                    presetTerritories = "Przejrzyj gotowe dzielnice i wybierz, które są aktywne.",
                    objectsSection = "Zarządzaj stałymi krzesłami do przesłuchań i wózkami z narzędziami.",
                    blockedZonesSection = "Wyznacz obszary, na których nie można umieszczać obiektów do przesłuchań.",
                    toolsSection = "Skonfiguruj narzędzia dostępne podczas przesłuchań.",
                    sessionsSection = "Przeglądaj aktywne przesłuchania i w razie potrzeby kończ sesje.",
                    orphansSection = "Sprawdź i usuń porzucone obiekty do przesłuchań.",
                },
            },
            crimeGroupDescriptions = {
                general = {
                    crimeMembership = "Wybierz, w jaki sposób organizacje przestępcze przechowują i zarządzają swoimi członkami.",
                },
                territories = {
                    zones = "Dostosuj ustawienia „Strefy terytorialne” w sekcji „Terytoria”.",
                    ownership = "Dostosuj ustawienia „Własność” w sekcji „Terytoria”.",
                    decay = "Dostosuj ustawienia „Degradacja” w sekcji „Terytoria”.",
                    presence = "Dostosuj ustawienia „Obecność” w sekcji „Terytoria”.",
                    activity = "Dostosuj ustawienia „Punktacja aktywności” w sekcji „Terytoria”.",
                    ownershipBenefits = "Dostosuj ustawienia „Bonusy za posiadanie” w sekcji „Terytoria”.",
                },
                graffiti = {
                    general = "Dostosuj ustawienia „Ogólne” w sekcji „Graffiti”.",
                    streaming = "Dostosuj ustawienia „Renderowanie” w sekcji „Graffiti”.",
                    moderation = "Dostosuj ustawienia „Moderacja” w sekcji „Graffiti”.",
                },
                pvpEvents = {
                    pvpAvailability = "Kontroluj, czy aplikacja wydarzeń PvP jest dostępna i gdzie się pojawia.",
                    pvpAutomation = "Konfiguruj powtarzalne zdarzenia i automatyczne procesy rozpoczynania.",
                    pvpRuntime = "Dostosuj obsługę żądań, zgony i odrodzenia podczas trwających meczów.",
                    pvpModes = "Skonfiguruj tryb gry wstępnie wybrany w tablecie PvP.",
                    pvpArenas = "Tworzy okrągłą strefę, punkt obserwacyjny i punkty odrodzenia drużyn używane podczas wydarzeń PvP.",
                    pvpLimits = "Ustaw limity nagród i historii w tablecie.",
                    pvpPermissions = "Przypisuje zarządzanie wydarzeniami i finanse do uprawnień ACE i ról.",
                    pvpTakeoverRules = "Kontroluje dostępność i wymagania uczestnictwa przy przejmowaniu laboratoriów i kamperów.",
                    pvpTakeoverZones = "Skonfiguruj obszary interakcji, alarmów i przejęcia wraz z ich czasem trwania.",
                    pvpTakeoverMethods = "Skonfiguruj, jak długo każda metoda zajmuje na sforsowanie wejścia.",
                },
                drugs = {
                    creator = "Otwiera edytor narkotyków Sky Crime i zamyka konfigurator pracy.",
                    creatorSettings = "Dostosuj ustawienia „Ustawienia edytora” w sekcji „System narkotyków”.",
                    interfaceHud = "Dostosuj ustawienia „Pozycje interfejsu” w sekcji „System narkotyków”.",
                    drugsGeneral = "Dostosuj ustawienia „Ogólne” w sekcji „System narkotyków”.",
                    runtimeAccess = "Dostosuj ustawienia „Dostęp i własność” w sekcji „System narkotyków”.",
                    runtimePayouts = "Dostosuj ustawienia „Wypłaty” w sekcji „System narkotyków”.",
                    runtimeDispatch = "Dostosuj ustawienia „Dyspozytornia i policja” w sekcji „System narkotyków”.",
                    performanceInactiveControlIntervalMs = "Ustawienie działania dla: Osiągi / Nieaktywne / Sterowanie / Interwał / ms.",
                    performanceInteractionIdleScanIntervalMs = "Ustawienie działania dla: Osiągi / Interakcja / Bezczynny / Interwał skanowania / ms.",
                    performanceInteractionPromptIntervalMs = "Ustawienie działania dla: Osiągi / Interakcja / Komunikat interakcji / Interwał / ms.",
                    performanceInteractionScanIntervalMs = "Ustawienie działania dla: Osiągi / Interakcja / Interwał skanowania / ms.",
                    performanceMinimumScanIntervalMs = "Ustawienie działania dla: Osiągi / Minimum / Interwał skanowania / ms.",
                    performanceStreetPedActivationDistance = "Ustawienie działania dla: Osiągi / Ulica / Ped / Aktywacja / Odległość.",
                    performanceStreetPedIdleScanIntervalMs = "Ustawienie działania dla: Osiągi / Ulica / Ped / Bezczynny / Interwał skanowania / ms.",
                    performanceStreetPedScanIntervalMs = "Ustawienie działania dla: Osiągi / Ulica / Ped / Interwał skanowania / ms.",
                    performanceWorldCachePadding = "Ustawienie działania dla: Osiągi / Świat / Pamięć podręczna / Dodatkowy margines.",
                    performanceWorldCacheRefreshIntervalMs = "Ustawienie działania dla: Osiągi / Świat / Pamięć podręczna / Odświeżanie / Interwał / ms.",
                    performanceWorldIdleIntervalMs = "Ustawienie działania dla: Osiągi / Świat / Bezczynny / Interwał / ms.",
                },
                drugProduction = {
                    qualityWeights = "Dostosuj ustawienia „Jakość / Wagi” w sekcji „Produkcja narkotyków”.",
                    qualityTiers = "Dostosuj ustawienia „Jakość / Poziomy jakości” w sekcji „Produkcja narkotyków”.",
                    packagingGeneral = "Dostosuj ustawienia „Ogólne” w sekcji „Produkcja narkotyków”.",
                    processingFlow = "Dostosuj ustawienia „Przebieg przetwarzania” w sekcji „Produkcja narkotyków”.",
                    processingGeneral = "Dostosuj ustawienia „Ogólne” w sekcji „Produkcja narkotyków”.",
                },
                drugOperations = {
                    growingGeneral = "Dostosuj ustawienia „Ogólne” w sekcji „Działalność narkotykowa”.",
                    plantDefaults = "Dostosuj ustawienia „Roślina / Wartości domyślne” w sekcji „Działalność narkotykowa”.",
                    harvestWindow = "Dostosuj ustawienia „Zbiory / Okno czasowe” w sekcji „Działalność narkotykowa”.",
                    labsGeneral = "Włącza: laboratoria i kampery w grze.",
                    labRent = "Dostosuj ustawienia „Najem i cykl życia” w sekcji „Działalność narkotykowa”.",
                    camperDefaults = "Dostosuj ustawienia „Kamper” w sekcji „Działalność narkotykowa”.",
                    labUpgrades = "Mnożnik: Laboratorium / Poziom / Ulepszenie / Ceny.",
                    labDefaults = "Dostosuj ustawienia „Laboratorium / Wartości domyślne” w sekcji „Działalność narkotykowa”.",
                    powerGeneral = "Dostosuj ustawienia „Ogólne” w sekcji „Działalność narkotykowa”.",
                    generators = "Dostosuj ustawienia „Generatory” w sekcji „Działalność narkotykowa”.",
                    equipmentWear = "Globalny mnożnik: Zużycie sprzętu / Przetwarzanie.",
                    workersGeneral = "Dostosuj ustawienia „Ogólne” w sekcji „Działalność narkotykowa”.",
                    cultivationGeneral = "Dostosuj ustawienia „Ogólne” w sekcji „Działalność narkotykowa”.",
                    cultivationCurve = "Ustaw nazwę i wymagane łączne XP dla każdego poziomu uprawy.",
                    cultivationExperience = "Ustaw liczbę XP uprawy przyznawaną za każdą akcję.",
                    cultivationUnlocks = "Ustaw wymagany poziom dla pojemników, podłoży, sprzętu, odmian i poziomów skanera.",
                    powerRuntime = "Interwał w sekundach: aktualizacje zużycia generatorów i sygnatur energetycznych.",
                    powerHeat = "Dostosuj ustawienia „Zainteresowanie policji i sygnatura energetyczna” w sekcji „Działalność narkotykowa”.",
                    powerModes = "Dostosuj ustawienia „Zarządzanie / Tryby” w sekcji „Działalność narkotykowa”.",
                    powerPriorities = "Dostosuj ustawienia „Obciążenie / Priorytety” w sekcji „Działalność narkotykowa”.",
                },
                drugMarketRisk = {
                    marketGeneral = "Dostosuj ustawienia „Ogólne” w sekcji „Rynek i ryzyko”.",
                    marketPrices = "Dostosuj ustawienia „Ceny” w sekcji „Rynek i ryzyko”.",
                    distribution = "Dostosuj ustawienia „Dystrybucja” w sekcji „Rynek i ryzyko”.",
                    threatsGeneral = "Dostosuj ustawienia „Ogólne” w sekcji „Rynek i ryzyko”.",
                    threatHeat = "Dostosuj ustawienia „Presja policji” w sekcji „Rynek i ryzyko”.",
                    threatChances = "Dostosuj ustawienia „Prawdopodobieństwa” w sekcji „Rynek i ryzyko”.",
                    consumptionGeneral = "Dostosuj ustawienia „Ogólne” w sekcji „Rynek i ryzyko”.",
                    consumerDecay = "Dostosuj ustawienia „Spadek tolerancji i uzależnienia” w sekcji „Rynek i ryzyko”.",
                    consumerEffects = "Dostosuj ustawienia „Efekty i ryzyko” w sekcji „Rynek i ryzyko”.",
                },
                drugNetworks = {
                    dynamicMarketActionCooldownSeconds = "Ustawienie działania dla: Dynamiczny Rynek / Czas odnowienia akcji / sekundy.",
                    dynamicMarketActionHistoryLimit = "Ustawienie działania dla: Dynamiczny Rynek / Działanie / Limit historii.",
                    dynamicMarketAmountSaturationWeight = "Ustawienie działania dla: Dynamiczny Rynek / Ilość / Nasycenie / Waga.",
                    dynamicMarketBaseIntelAccuracy = "Ustawienie działania dla: Dynamiczny Rynek / Wartość bazowa / Dokładność danych.",
                    dynamicMarketDefaultAverageQuality = "Ustawienie działania dla: Dynamiczny Rynek / Wartość domyślna / Średnia / Jakość.",
                    dynamicMarketDefaultResourceElasticity = "Ustawienie działania dla: Dynamiczny Rynek / Wartość domyślna / Surowiec / Elastyczność.",
                    dynamicMarketDemandCenter = "Ustawienie działania dla: Dynamiczny Rynek / Popyt / Wartość środkowa.",
                    dynamicMarketDemandPriceImpact = "Ustawienie działania dla: Dynamiczny Rynek / Popyt / Cena / Wpływ.",
                    dynamicMarketDirectionThreshold = "Ustawienie działania dla: Dynamiczny Rynek / Kierunek / Próg.",
                    dynamicMarketEnabled = "Ustawienie działania dla: Dynamiczny Rynek / Włączone.",
                    dynamicMarketEventChance = "Ustawienie działania dla: Dynamiczny Rynek / Zdarzenie / Szansa.",
                    dynamicMarketEventDurationMinutes = "Ustawienie działania dla: Dynamiczny Rynek / Zdarzenie / Czas trwania / Minuty.",
                    dynamicMarketEventMinimumDurationMinutes = "Ustawienie działania dla: Dynamiczny Rynek / Zdarzenie / Minimum / Czas trwania / Minuty.",
                    dynamicMarketEventStrengthMaximum = "Ustawienie działania dla: Dynamiczny Rynek / Zdarzenie / Siła / Maksimum.",
                    dynamicMarketEventStrengthMinimum = "Ustawienie działania dla: Dynamiczny Rynek / Zdarzenie / Siła / Minimum.",
                    dynamicMarketEvents = "Dostosuj ustawienia „Wydarzenia” w sekcji „Sieci narkotykowe”.",
                    dynamicMarketExactIntelReputation = "Ustawienie działania dla: Dynamiczny Rynek / Dokładne informacje / Reputacja.",
                    dynamicMarketExactIntelTrust = "Ustawienie działania dla: Dynamiczny Rynek / Dokładne informacje / Zaufanie.",
                    dynamicMarketGlobalZoneLabel = "Ustawienie działania dla: Dynamiczny Rynek / Global / Strefa / Etykieta.",
                    dynamicMarketHistoryLimit = "Ustawienie działania dla: Dynamiczny Rynek / Limit historii.",
                    dynamicMarketInitialDemand = "Ustawienie działania dla: Dynamiczny Rynek / Wartość początkowa / Popyt.",
                    dynamicMarketInitialPriceMultiplier = "Ustawienie działania dla: Dynamiczny Rynek / Wartość początkowa / Mnożnik ceny.",
                    dynamicMarketIntelDemandError = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Popyt / Błąd.",
                    dynamicMarketIntelMaximumAccuracy = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Maksimum / Dokładność.",
                    dynamicMarketIntelMinimumAccuracy = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Minimum / Dokładność.",
                    dynamicMarketIntelPoliceError = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Policja / Błąd.",
                    dynamicMarketIntelPriceError = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Cena / Błąd.",
                    dynamicMarketIntelPriceMaximum = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Cena / Maksimum.",
                    dynamicMarketIntelPriceMinimum = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Cena / Minimum.",
                    dynamicMarketIntelReputationWeight = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Reputacja / Waga.",
                    dynamicMarketIntelResourcePriceError = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Surowiec / Cena / Błąd.",
                    dynamicMarketIntelSaturationError = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Nasycenie / Błąd.",
                    dynamicMarketIntelSeedBucketSeconds = "Ustawienie działania dla: Dynamiczny Rynek / Okno ziarna informacji / sekundy.",
                    dynamicMarketIntelStatusAccuracyThreshold = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Status / Dokładność / Próg.",
                    dynamicMarketIntelStatusErrorThreshold = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Status / Błąd / Próg.",
                    dynamicMarketIntelSupplyError = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Dostawa / Błąd.",
                    dynamicMarketIntelTrustWeight = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Zaufanie / Waga.",
                    dynamicMarketManipulationCooldownMinutes = "Ustawienie działania dla: Dynamiczny Rynek / Manipulacja / Minuty odnowienia.",
                    dynamicMarketManipulationDemandShift = "Ustawienie działania dla: Dynamiczny Rynek / Manipulacja / Popyt / Zmiana.",
                    dynamicMarketManipulationDurationMinutes = "Ustawienie działania dla: Dynamiczny Rynek / Manipulacja / Czas trwania / Minuty.",
                    dynamicMarketManipulationHeat = "Ustawienie działania dla: Dynamiczny Rynek / Manipulacja / Presja policji.",
                    dynamicMarketManipulationMinimumBatchAmount = "Ustawienie działania dla: Dynamiczny Rynek / Manipulacja / Minimum / Partia / Ilość.",
                    dynamicMarketManipulationPaymentAccount = "Ustawienie działania dla: Dynamiczny Rynek / Manipulacja / Konto płatnicze.",
                    dynamicMarketManipulationPrice = "Ustawienie działania dla: Dynamiczny Rynek / Manipulacja / Cena.",
                    dynamicMarketManipulationZoneHeatMultiplier = "Ustawienie działania dla: Dynamiczny Rynek / Manipulacja / Strefa / Presja policji / Mnożnik.",
                    dynamicMarketMaximumIntelAgeMinutes = "Ustawienie działania dla: Dynamiczny Rynek / Maksimum / Wiek danych / Minuty.",
                    dynamicMarketMaximumPriceMultiplier = "Ustawienie działania dla: Dynamiczny Rynek / Maksimum / Mnożnik ceny.",
                    dynamicMarketMinimumIntelAgeMinutes = "Ustawienie działania dla: Dynamiczny Rynek / Minimum / Wiek danych / Minuty.",
                    dynamicMarketMinimumMetricWindowMinutes = "Ustawienie działania dla: Dynamiczny Rynek / Minimum / Metryka / Okno czasowe / Minuty.",
                    dynamicMarketMinimumPriceMultiplier = "Ustawienie działania dla: Dynamiczny Rynek / Cena minimalna / Mnożnik.",
                    dynamicMarketMinimumUpdateMinutes = "Ustawienie działania dla: Dynamiczny Rynek / Minimum / Aktualizacja / Minuty.",
                    dynamicMarketPoliceDemandWeight = "Ustawienie działania dla: Dynamiczny Rynek / Policja / Popyt / Waga.",
                    dynamicMarketPolicePriceImpact = "Ustawienie działania dla: Dynamiczny Rynek / Policja / Cena / Wpływ.",
                    dynamicMarketPoorQualityDemandPenalty = "Ustawienie działania dla: Dynamiczny Rynek / Niska jakość / Popyt / Kara.",
                    dynamicMarketPoorQualityThreshold = "Ustawienie działania dla: Dynamiczny Rynek / Niska jakość / Próg.",
                    dynamicMarketPremiumQualityDemandBonus = "Ustawienie działania dla: Dynamiczny Rynek / Jakość premium / Bonus do popytu.",
                    dynamicMarketPremiumQualityThreshold = "Ustawienie działania dla: Dynamiczny Rynek / Jakość premium / Próg.",
                    dynamicMarketProductionSupplyWeight = "Ustawienie działania dla: Dynamiczny Rynek / Produkcja / Dostawa / Waga.",
                    dynamicMarketProductionWindowMinutes = "Ustawienie działania dla: Dynamiczny Rynek / Produkcja / Okno czasowe / Minuty.",
                    dynamicMarketQualityCenter = "Ustawienie działania dla: Dynamiczny Rynek / Jakość / Wartość środkowa.",
                    dynamicMarketQualityConfidenceImpact = "Ustawienie działania dla: Dynamiczny Rynek / Jakość / Pewność / Wpływ.",
                    dynamicMarketQualityRange = "Ustawienie działania dla: Dynamiczny Rynek / Jakość / Zakres wartości.",
                    dynamicMarketRarityBonusMaximum = "Ustawienie działania dla: Dynamiczny Rynek / Rzadkość / Premia / Maksimum.",
                    dynamicMarketRegionalGlobalWeight = "Ustawienie działania dla: Dynamiczny Rynek / Regionalne / Global / Waga.",
                    dynamicMarketRegionalLocalWeight = "Ustawienie działania dla: Dynamiczny Rynek / Regionalne / Lokalne / Waga.",
                    dynamicMarketResourceAliases = "Dostosuj ustawienia „Surowiec / Aliasy” w sekcji „Sieci narkotykowe”.",
                    dynamicMarketResourceDirectionFallThreshold = "Ustawienie działania dla: Dynamiczny Rynek / Surowiec / Kierunek / Spadek / Próg.",
                    dynamicMarketResourceDirectionRiseThreshold = "Ustawienie działania dla: Dynamiczny Rynek / Surowiec / Kierunek / Wzrost / Próg.",
                    dynamicMarketResources = "Dostosuj ustawienia „Zasoby” w sekcji „Sieci narkotykowe”.",
                    dynamicMarketSalesWindowMinutes = "Ustawienie działania dla: Dynamiczny Rynek / Sprzedaż / Okno czasowe / Minuty.",
                    dynamicMarketSaturationDemandWeight = "Ustawienie działania dla: Dynamiczny Rynek / Nasycenie / Popyt / Waga.",
                    dynamicMarketSaturationPriceImpact = "Ustawienie działania dla: Dynamiczny Rynek / Nasycenie / Cena / Wpływ.",
                    dynamicMarketScarcityDemandWeight = "Ustawienie działania dla: Dynamiczny Rynek / Niedobór / Popyt / Waga.",
                    dynamicMarketScarcityPriceImpact = "Ustawienie działania dla: Dynamiczny Rynek / Niedobór / Cena / Wpływ.",
                    dynamicMarketSeasonEndMonths = "Dostosuj ustawienia „Pora roku / Koniec / Miesiące” w sekcji „Sieci narkotykowe”.",
                    dynamicMarketSeasonMultipliers = "Dostosuj ustawienia „Pora roku / Mnożniki” w sekcji „Sieci narkotykowe”.",
                    dynamicMarketShortageRumorThreshold = "Ustawienie działania dla: Dynamiczny Rynek / Niedobór / Plotka / Próg.",
                    dynamicMarketStatusThresholds = "Dostosuj ustawienia „Status / Progi” w sekcji „Sieci narkotykowe”.",
                    dynamicMarketTargetSupply = "Ustawienie działania dla: Dynamiczny Rynek / Cel / Dostawa.",
                    dynamicMarketTrendChance = "Ustawienie działania dla: Dynamiczny Rynek / Trend / Szansa.",
                    dynamicMarketTrendDurationMinutes = "Ustawienie działania dla: Dynamiczny Rynek / Trend / Czas trwania / Minuty.",
                    dynamicMarketTrendMaximumStrength = "Ustawienie działania dla: Dynamiczny Rynek / Trend / Maksimum / Siła.",
                    dynamicMarketTrendMinimumStrength = "Ustawienie działania dla: Dynamiczny Rynek / Trend / Minimum / Siła.",
                    dynamicMarketUpdateMinutes = "Ustawienie działania dla: Dynamiczny Rynek / Aktualizacja / Minuty.",
                    dynamicMarketVolatilityMaximum = "Ustawienie działania dla: Dynamiczny Rynek / Zmienność cen / Maksimum.",
                    dynamicMarketVolatilityMinimum = "Ustawienie działania dla: Dynamiczny Rynek / Zmienność cen / Minimum.",
                    dynamicMarketWeatherMultipliers = "Dostosuj ustawienia „Pogoda / Mnożniki” w sekcji „Sieci narkotykowe”.",
                    dynamicMarketWeatherState = "Ustawienie działania dla: Dynamiczny Rynek / Pogoda / Status.",
                    heatActionCooldownSeconds = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Czas odnowienia akcji / sekundy.",
                    heatActivityRiskWeights = "Dostosuj ustawienia „Aktywność / Ryzyko / Wagi” w sekcji „Sieci narkotykowe”.",
                    heatAggressiveHeatMultiplier = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Tryb agresywny / Presja policji / Mnożnik.",
                    heatBurnerBurnThreshold = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Telefon jednorazowy / Zdemaskowanie / Próg.",
                    heatBurnerHeatPerWholesale = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Telefon jednorazowy / Presja policji / Na transakcję hurtową.",
                    heatBurnerPhoneItem = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Telefon jednorazowy / Przedmiot.",
                    heatCamperOperationalHeatMultiplier = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Kamper w działaniu / Presja policji / Mnożnik.",
                    heatCamperOperationalHeatThreshold = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Kamper w działaniu / Presja policji / Próg.",
                    heatCamperParkedHeat = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Zaparkowany kamper / Presja policji.",
                    heatContaminatedHeatMultiplier = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Zanieczyszczenie / Presja policji / Mnożnik.",
                    heatContaminatedThreshold = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Zanieczyszczenie / Próg.",
                    heatCultivationFreePlants = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Uprawa / Rośliny bez dodatkowego ryzyka.",
                    heatCultivationHeatPerPlant = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Uprawa / Presja policji / Na roślinę.",
                    heatDealerHiddenMinutes = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Dystrybutor / ukryte / Minuty.",
                    heatDecayPerTick = "Dostosuj ustawienia „Degradacja / Na cykl aktualizacji” w sekcji „Sieci narkotykowe”.",
                    heatEnabled = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Włączone.",
                    heatEnforcementHeat = "Dostosuj ustawienia „Obecność policji / Presja policji” w sekcji „Sieci narkotykowe”.",
                    heatEnforcementMultipliers = "Dostosuj ustawienia „Obecność policji / Mnożniki” w sekcji „Sieci narkotykowe”.",
                    heatEntityTypes = "Dostosuj ustawienia „Obiekt gry / Typy” w sekcji „Sieci narkotykowe”.",
                    heatEventCooldownMinutes = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Zdarzenie / Minuty odnowienia.",
                    heatEventHistoryLimit = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Zdarzenie / Limit historii.",
                    heatLabHeatSyncThreshold = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Laboratorium / Presja policji / Synchronizacja / Próg.",
                    heatLayLowCooldownMinutes = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Ukrywanie się / Minuty odnowienia.",
                    heatLayLowIdleMinutes = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Ukrywanie się / Bezczynny / Minuty.",
                    heatLayLowReduction = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Ukrywanie się / Redukcja.",
                    heatLockdownMinutes = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Blokada / Minuty.",
                    heatMinimumDurationMinutes = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Minimum / Czas trwania / Minuty.",
                    heatMinimumEventCooldownSeconds = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Minimum / Zdarzenie / Czas odnowienia (sekundy).",
                    heatMinimumIdleSeconds = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Minimum / Bezczynny / sekundy.",
                    heatProcessingHeatMultiplier = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Przetwarzanie / Presja policji / Mnożnik.",
                    heatRiskWeights = "Dostosuj ustawienia „Ryzyko / Wagi” w sekcji „Sieci narkotykowe”.",
                    heatRotateBurnerReduction = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Zmień telefon jednorazowy / Redukcja.",
                    heatRouteControlMinutes = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Trasa / Sterowanie / Minuty.",
                    heatSaleHeat = "Dostosuj ustawienia „Sprzedaż / Presja policji” w sekcji „Sieci narkotykowe”.",
                    heatThresholds = "Dostosuj ustawienia „Progi” w sekcji „Sieci narkotykowe”.",
                    heatTickMinutes = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Cykl aktualizacji / Minuty.",
                    heatWholesaleHeatMultiplier = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Hurtownia / Presja policji / Mnożnik.",
                    heatWorkerLeakAlertRadius = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Promień alarmu.",
                    heatWorkerLeakBaseChance = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Wartość bazowa / Szansa.",
                    heatWorkerLeakFactionMultiplier = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Frakcja / Mnożnik.",
                    heatWorkerLeakHighSeverityThreshold = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Wysoki / Dotkliwość / Próg.",
                    heatWorkerLeakLoyaltyChanceMultiplier = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Lojalność / Szansa / Mnożnik.",
                    heatWorkerLeakLoyaltyThreshold = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Lojalność / Próg.",
                    heatWorkerLeakMaximumChance = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Maksimum / Szansa.",
                    heatWorkerLeakMinimumCooldownSeconds = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Minimum / Czas odnowienia (sekundy).",
                    heatWorkerLeakRouteMultiplier = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Trasa / Mnożnik.",
                    heatWorkerLeakStrengthMaximum = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Siła / Maksimum.",
                    heatWorkerLeakStrengthMinimum = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Siła / Minimum.",
                    heatWorkerLeakStrengthMultiplier = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Siła / Mnożnik.",
                    heatWorkerLeakStressChanceMultiplier = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Stres / Szansa / Mnożnik.",
                    heatWorkerLeakStressThreshold = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Stres / Próg.",
                    contactsActionCooldownSeconds = "Ustawienie działania dla: Sieć kontaktów / Czas odnowienia akcji / sekundy.",
                    contactsActiveHotspotCount = "Ustawienie działania dla: Sieć kontaktów / Liczba aktywnych punktów.",
                    contactsBurnerHintTrust = "Ustawienie działania dla: Sieć kontaktów / Wskazówka dotycząca burner'a / Zaufanie.",
                    contactsBurnerOfferMaximumMultiplier = "Ustawienie działania dla: Sieć kontaktów / Telefon jednorazowy / Oferta / Maksimum / Mnożnik.",
                    contactsBurnerOfferMinimumMultiplier = "Ustawienie działania dla: Sieć kontaktów / Telefon jednorazowy / Oferta / Minimum / Mnożnik.",
                    contactsBuyerCooldownMinutes = "Ustawienie działania dla: Sieć kontaktów / Kupiec / Minuty odnowienia.",
                    contactsBuyerDeliveryDistance = "Ustawienie działania dla: Sieć kontaktów / Kupiec / Odległość dostawy.",
                    contactsBuyerPremiumSuccessScore = "Ustawienie działania dla: Sieć kontaktów / Kupiec / Premium / Sukces / Wynik.",
                    contactsBuyerPremiumTrustGain = "Ustawienie działania dla: Sieć kontaktów / Kupiec / Premium / Zaufanie / zysk.",
                    contactsBuyerRequestHeatRiskWeight = "Ustawienie działania dla: Sieć kontaktów / Kupiec / Żądanie / Poziom poszukiwań i ryzyko / Waga.",
                    contactsBuyerStandardTrustGain = "Ustawienie działania dla: Sieć kontaktów / Kupiec / Standardowy / Zaufanie / zysk.",
                    contactsContactActiveDelaySeconds = "Dostosuj ustawienia „Opóźnienie aktywacji kontaktu / sekundy” w sekcji „Sieci narkotykowe”.",
                    contactsContactDemandRange = "Dostosuj ustawienia „Kontakt / Popyt / Zakres wartości” w sekcji „Sieci narkotykowe”.",
                    contactsContactLossTrust = "Ustawienie działania dla: Sieć kontaktów / Kontakt / Strata / Zaufanie.",
                    contactsDarknetExactIntelMinutes = "Ustawienie działania dla: Sieć kontaktów / Darknet / Dokładne informacje / Minuty.",
                    contactsDarknetHotspotIntelPrice = "Ustawienie działania dla: Sieć kontaktów / Darknet / Punkt aktywności / Informacje / Cena.",
                    contactsDarknetIntelPrice = "Ustawienie działania dla: Sieć kontaktów / Darknet / Informacje / Cena.",
                    contactsDealerBasePrice = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Cena bazowa.",
                    contactsDealerHireCapacity = "Dostosuj ustawienia „Dystrybutor / Zatrudnienie / pojemność” w sekcji „Sieci narkotykowe”.",
                    contactsDealerHireRisk = "Dostosuj ustawienia „Dystrybutor / Zatrudnienie / Ryzyko” w sekcji „Sieci narkotykowe”.",
                    contactsDealerHireSkill = "Dostosuj ustawienia „Dystrybutor / Zatrudnienie / Umiejętność” w sekcji „Sieci narkotykowe”.",
                    contactsDealerOffers = "Dostosuj ustawienia „Oferty dealerów” w sekcji „Sieci narkotykowe”.",
                    contactsDealerProtectionHours = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Ochrona / Godziny.",
                    contactsDealerProtectionPrice = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Ochrona / Cena.",
                    contactsDealerSaleMax = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Sprzedaż / Maksimum.",
                    contactsDealerSaleMin = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Sprzedaż / Minimum.",
                    contactsDealerSimulation = "Dostosuj ustawienia „Dystrybutor / Symulacja” w sekcji „Sieci narkotykowe”.",
                    contactsDealerTickMinutes = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Cykl aktualizacji / Minuty.",
                    contactsDealerWage = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Stawka.",
                    contactsDealerWageDecay = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Stawka / Degradacja.",
                    contactsDealerWageLoyaltyGain = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Stawka / Lojalność / zysk.",
                    contactsDealerWeaknesses = "Dostosuj ustawienia „Dystrybutor / Słabości” w sekcji „Sieci narkotykowe”.",
                    contactsDefaultContactDemand = "Ustawienie działania dla: Sieć kontaktów / Wartość domyślna / Kontakt / Popyt.",
                    contactsDefaultContactRisk = "Ustawienie działania dla: Sieć kontaktów / Wartość domyślna / Kontakt / Ryzyko.",
                    contactsDefaultDealerCapacity = "Ustawienie działania dla: Sieć kontaktów / Domyślny diler / pojemność.",
                    contactsDefaultDealerRisk = "Ustawienie działania dla: Sieć kontaktów / Domyślny diler / Ryzyko.",
                    contactsDefaultDealerSkill = "Ustawienie działania dla: Sieć kontaktów / Domyślny diler / Umiejętność.",
                    contactsDefaultHotspotRadius = "Ustawienie działania dla: Sieć kontaktów / Wartość domyślna / Punkt aktywności / Promień.",
                    contactsDemandResetMinutes = "Ustawienie działania dla: Sieć kontaktów / Resetowanie popytu (minuty).",
                    contactsEnabled = "Ustawienie działania dla: Sieć kontaktów / Włączone.",
                    contactsExactLocationTrust = "Ustawienie działania dla: Sieć kontaktów / Dokładna lokalizacja / Zaufanie.",
                    contactsFactionDiscoveryReputation = "Ustawienie działania dla: Sieć kontaktów / Frakcja / Odkrycie / Reputacja.",
                    contactsFactionHintTrust = "Ustawienie działania dla: Sieć kontaktów / Frakcja / Wskazówka / Zaufanie.",
                    contactsFailedDeliveryCooldownMinutes = "Ustawienie działania dla: Sieć kontaktów / Nieudana dostawa / Minuty odnowienia.",
                    contactsFakeDealEncounter = "Dostosuj ustawienia „Fałszywa transakcja / Spotkanie” w sekcji „Sieci narkotykowe”.",
                    contactsFallbackPreferredDrug = "Ustawienie działania dla: Sieć kontaktów / Wartość zastępcza / Preferowana droga.",
                    contactsFallbackProductLabel = "Ustawienie działania dla: Sieć kontaktów / Wartość zastępcza / Nazwa produktu.",
                    contactsGuideBookItem = "Ustawienie działania dla: Sieć kontaktów / Poradnik / Książka / Przedmiot.",
                    contactsGuideBookTrust = "Ustawienie działania dla: Sieć kontaktów / Poradnik / Książka / Zaufanie.",
                    contactsHireDealerPrice = "Ustawienie działania dla: Sieć kontaktów / Zatrudnij dealera / Cena.",
                    contactsHistoryLimit = "Ustawienie działania dla: Sieć kontaktów / Limit historii.",
                    contactsHotspotIntelMinutes = "Ustawienie działania dla: Sieć kontaktów / Punkt aktywności / Informacje / Minuty.",
                    contactsHotspotRotationMinutes = "Ustawienie działania dla: Sieć kontaktów / Punkt aktywności / Rotacja / Minuty.",
                    contactsListingDurationMinutes = "Ustawienie działania dla: Sieć kontaktów / Ogłoszenie / Czas trwania / Minuty.",
                    contactsMaxOwnedDealers = "Ustawienie działania dla: Sieć kontaktów / Maksimum / Własność / Dilerzy.",
                    contactsMinimumBuyerDeliveryDistance = "Ustawienie działania dla: Sieć kontaktów / Minimum / Kupiec / Odległość dostawy.",
                    contactsMinimumContactRotationMinutes = "Ustawienie działania dla: Sieć kontaktów / Minimum / Rotacja kontaktów (minuty).",
                    contactsMinimumDemandResetMinutes = "Ustawienie działania dla: Sieć kontaktów / Minimum / Resetowanie popytu (minuty).",
                    contactsMinimumHeatMultiplier = "Ustawienie działania dla: Sieć kontaktów / Minimum / Presja policji / Mnożnik.",
                    contactsMinimumHotspotIntelMinutes = "Ustawienie działania dla: Sieć kontaktów / Minimum / Punkt aktywności / Informacje / Minuty.",
                    contactsMinimumHotspotRadius = "Ustawienie działania dla: Sieć kontaktów / Minimum / Punkt aktywności / Promień.",
                    contactsMinimumHotspotRotationMinutes = "Ustawienie działania dla: Sieć kontaktów / Minimum / Punkt aktywności / Rotacja / Minuty.",
                    contactsMinimumListingDurationMinutes = "Ustawienie działania dla: Sieć kontaktów / Minimum / Ogłoszenie / Czas trwania / Minuty.",
                    contactsMinimumRewardMultiplier = "Ustawienie działania dla: Sieć kontaktów / Minimalna nagroda / Mnożnik.",
                    contactsMinimumRobberyMultiplier = "Ustawienie działania dla: Sieć kontaktów / Minimum / Napady / Mnożnik.",
                    contactsMinimumSpotPriceMultiplier = "Ustawienie działania dla: Sieć kontaktów / Minimum / Lokalizacja / Mnożnik ceny.",
                    contactsOtherDrugPriceMultiplier = "Ustawienie działania dla: Sieć kontaktów / Inne / Narkotyk / Mnożnik ceny.",
                    contactsPaymentAccount = "Ustawienie działania dla: Sieć kontaktów / Konto płatnicze.",
                    contactsPostDeliveryDemandResetSeconds = "Ustawienie działania dla: Sieć kontaktów / Po dostawie / Popyt / Reset / sekundy.",
                    contactsPreferredDrugPriceMultiplier = "Ustawienie działania dla: Sieć kontaktów / Preferowana droga / Mnożnik ceny.",
                    contactsRegionLocationTrust = "Ustawienie działania dla: Sieć kontaktów / Region / Lokalizacja / Zaufanie.",
                    contactsRequestAmounts = "Dostosuj ustawienia „Żądanie / Ilości” w sekcji „Sieci narkotykowe”.",
                    contactsRotationMinutes = "Ustawienie działania dla: Sieć kontaktów / Rotacja / Minuty.",
                    contactsSpotPools = "Dostosuj ustawienia „Lokalizacja / Pule wyboru” w sekcji „Sieci narkotykowe”.",
                    contactsStreetHotspots = "Dostosuj ustawienia „Ulica / Punkty aktywności” w sekcji „Sieci narkotykowe”.",
                    contactsTrustLevels = "Dostosuj ustawienia „Zaufanie / Poziomy” w sekcji „Sieci narkotykowe”.",
                    businessActionCooldownSeconds = "Ustawienie działania dla: Sieć firm / Czas odnowienia akcji / sekundy.",
                    businessBalance = "Dostosuj ustawienia „Saldo” w sekcji „Sieci narkotykowe”.",
                    businessContracts = "Dostosuj ustawienia „Kontrakty” w sekcji „Sieci narkotykowe”.",
                    businessDefaultBusinessName = "Ustawienie działania dla: Sieć firm / Wartość domyślna / Nazwa firmy.",
                    businessDefaultRankId = "Ustawienie działania dla: Sieć firm / Wartość domyślna / Stopień / ID.",
                    businessDefaultStaffStyle = "Ustawienie działania dla: Sieć firm / Wartość domyślna / Personel / Styl pracy.",
                    businessDefaultTransport = "Ustawienie działania dla: Sieć firm / Wartość domyślna / Transport.",
                    businessEnabled = "Ustawienie działania dla: Sieć firm / Włączone.",
                    businessHubs = "Dostosuj ustawienia „Centra dystrybucji” w sekcji „Sieci narkotykowe”.",
                    businessLimits = "Dostosuj ustawienia „Limity” w sekcji „Sieci narkotykowe”.",
                    businessPayments = "Wybierz saldo, które opłaca zakupy i koszty operacyjne w Sieci Biznesowej.",
                    businessPayoutAccount = "Ustawienie działania dla: Sieć firm / Wypłata / Konto.",
                    businessRanks = "Dostosuj ustawienia „Rangi” w sekcji „Sieci narkotykowe”.",
                    businessReportDays = "Ustawienie działania dla: Sieć firm / Okres raportu / dni.",
                    businessRouteEndpointTypes = "Dostosuj ustawienia „Trasa / Punkt końcowy / Typy” w sekcji „Sieci narkotykowe”.",
                    businessRuntime = "Dostosuj ustawienia „Działanie w grze” w sekcji „Sieci narkotykowe”.",
                    businessSocietyPermission = "Ustawienie działania dla: Sieć firm / Organizacja / Uprawnienie.",
                    businessStaff = "Dostosuj ustawienia „Personel” w sekcji „Sieci narkotykowe”.",
                    businessTickMinutes = "Ustawienie działania dla: Sieć firm / Cykl aktualizacji / Minuty.",
                    businessTransports = "Dostosuj ustawienia „Transporty” w sekcji „Sieci narkotykowe”.",
                },
                robbery = {
                    atmAvailability = "Włącz lub wyłącz samodzielny system napadów na bankomaty.",
                    atmLocations = "Zarządza autoryzowanymi przez serwer pozycjami bankomatów dostępnymi do napadów.",
                    atmPolice = "Skonfiguruj wymagany poziom liczby policjantów na służbie do rozpoczęcia napadu.",
                    atmItems = "Ustaw wymagane przedmioty wiertarki, pasa holowniczego i ładunku wybuchowego.",
                    atmActionTimes = "Ustaw czas trwania czynności montowania, podkładania, detonacji i grabieży.",
                    atmTimeouts = "Określ, jak długo sforsowany bankomat pozostaje dostępny do okradnięcia.",
                    atmPayout = "Skonfiguruj konto docelowe i losowy zakres nagród.",
                    atmDistances = "Ustaw zasięgi dla gracza i pojazdów używane podczas interakcji z bankomatem.",
                    atmExplosionEffects = "Konfiguruje natywne parametry eksplozji używane podczas detonacji.",
                    atmDispatchAlert = "Skonfiguruj promień, czas trwania i priorytet alarmu policyjnego.",
                    atmDispatchRecipients = "Wybierz nazwy prac, które otrzymują powiadomienia o napadzie na bankomat.",
                    shopAvailability = "Włącz napady i skonfiguruj wymagania dotyczące policji.",
                    shopTiming = "Skonfiguruj zastraszanie, akcje, czas wygaśnięcia i czas odnowienia.",
                    shopSafe = "Skonfiguruj liczbę prób wpisania kodu oraz przedmiot wiertarki.",
                    shopRegisterReward = "Skonfiguruj losową nagrodę dla każdej kasy.",
                    shopSafeReward = "Skonfiguruj losową nagrodę z sejfu.",
                    shopDispatchSettings = "Skonfiguruj odbiorców i właściwości alarmu.",
                    shopLocationTable = "Zarządzaj obsługiwanymi sklepami detalicznymi i sejfami.",
                    pickpocketAvailability = "Włącz tę funkcję i opcjonalnie ogranicz ją do skonfigurowanych prac przestępczych.",
                    pickpocketGameplay = "Wybierz poziom trudności oraz niezależne prawdopodobieństwo ucieczki, wezwania służb i kontrataku.",
                    pickpocketItemRewards = "Kontroluj zawartość pustych kieszeni oraz widoczne przedmioty z dokładnością do 0.0001 procent.",
                    pickpocketMoney = "Skonfiguruj serwerowy zakres losowej kwoty gotówki.",
                    pickpocketDistances = "Ustaw zasięg NPC używany przez wspólny system menu kołowego i celu.",
                    pickpocketRateLimits = "Kontroluj ograniczanie żądań, czas odnowienia dla każdego NPC oraz wygasanie sesji.",
                    pickpocketDispatchSettings = "Konfiguruje alert wysyłany, gdy NPC dzwoni po służby ratunkowe.",
                    heistCrafting = "Wybierz poziom trudności wytwarzania sprzętu do napadu. Dotyczy nowych prób w całym systemie przestępczym.",
                    heistCreatorMenu = "Twórz, edytuj i publikuj modułowe napady w dedykowanym Kreatorze Napadów.",
                    heistExecution = "Okno startowe, nieaktywność i czas odnowienia dla prób napadu.",
                    npcPoliceSupport = "Uzbrojeni oficerowie NPC reagują pieszo na alarmy napadu i wspierają policję, angażując się w walkę z rabusiami.",
                },
                baseRaids = {
                    baseRaids = "Dostęp do napadu, wymagania i indywidualnie wybieralne kategorie łupów. Otwarte napady nie mają limitu czasu transportu.",
                },
                weapons = {
                    weaponCreatorMenu = "Zarządzaj trasami broni i praniem pieniędzy w jednym edytorze.",
                    weaponRuntime = "Zarządzaj dostępnością tras broni i uprawnieniami dostępu.",
                    weaponDefaultsgeneral = "Dostosuj ustawienia „Ogólne wartości domyślne” w sekcji „Trasy broni”.",
                    weaponDefaultsaccess = "Dostosuj ustawienia „Domyślny dostęp” w sekcji „Trasy broni”.",
                    weaponDefaultscollection = "Dostosuj ustawienia „Domyślne zbieranie” w sekcji „Trasy broni”.",
                    weaponDefaultsproduction = "Dostosuj ustawienia „Domyślna produkcja” w sekcji „Trasy broni”.",
                    weaponDefaultsmarket = "Dostosuj ustawienia „Domyślny rynek” w sekcji „Trasy broni”.",
                    weaponDefaultsdelivery = "Dostosuj ustawienia „Domyślne zlecenia” w sekcji „Trasy broni”.",
                    weaponStreet = "Dostosuj ustawienia „Uliczna sprzedaż broni” w sekcji „Trasy broni”.",
                },
                darknetMarket = {
                    darknetAvailability = "Kontroluje aplikację na tablet i jej rozmieszczenie.",
                    darknetEconomy = "Konfiguruje salda portfeli, wymianę monet i stawki płatności.",
                    darknetListings = "Kontroluje limity ofert, ceny i automatyczne wygasanie.",
                    darknetChat = "Ogranicza zaszyfrowane wiadomości na rynku.",
                    darknetIdentity = "Konfiguruje rotację tożsamości, weryfikację i ostrzeżenia przed oszustwem.",
                    darknetDelivery = "Konfiguruje spotkania osobiste i kradzieżowe skrzynie w świecie gry.",
                    darknetDeliveryLocations = "Konfiguruje pule lokalizacji losowo przydzielane do transakcji NPC w BlackBay.",
                    darknetPolice = "Grupy zawodowe uprawnione do wystawiania pułapek i przeglądania dochodzeń.",
                    darknetNpcTraders = "Trwali kupujący i sprzedawcy NPC z konfigurowalnym ryzykiem.",
                },
                interrogation = {
                    general = "Dostosuj ustawienia „Ogólne” w sekcji „Przesłuchanie”.",
                    consent = "Dostosuj ustawienia „Ochrona gracza” w sekcji „Przesłuchanie”.",
                    objects = "Dostosuj ustawienia „Obiekty” w sekcji „Przesłuchanie”.",
                    grab = "Dostosuj ustawienia „Chwytanie” w sekcji „Przesłuchanie”.",
                    session = "Dostosuj ustawienia „Sesja” w sekcji „Przesłuchanie”.",
                    dispatch = "Dostosuj ustawienia „Alerty policji” w sekcji „Przesłuchanie”.",
                    logging = "Dostosuj ustawienia „Logowanie” w sekcji „Przesłuchanie”.",
                    security = "Dostosuj ustawienia „Bezpieczeństwo” w sekcji „Przesłuchanie”.",
                    presentation = "Dostosuj ustawienia „Prezentacja” w sekcji „Przesłuchanie”.",
                },
                reputation = {
                    crimeReputation = "Dostosuj ustawienia „Reputacja” w sekcji „Reputacja”.",
                },
            },
            settingGroups = {
                weaponRuntime = { label = "Ogólne", description = "Zarządzaj dostępnością tras broni i uprawnieniami dostępu." },
                weaponCreatorMenu = { label = "Nielegalny stwórca biznesu", description = "Zarządzaj trasami broni i praniem pieniędzy w jednym edytorze." },
                atmActionTimes = {
                    description = "Ustaw czas trwania czynności montowania, podkładania, detonacji i grabieży.",
                    label = "Czas trwania akcji",
                },
                atmAvailability = {
                    description = "Włącz lub wyłącz samodzielny system napadów na bankomaty.",
                    label = "Dostępność",
                },
                atmDispatchAlert = {
                    description = "Skonfiguruj promień, czas trwania i priorytet alarmu policyjnego.",
                    label = "Właściwości alarmu",
                },
                atmDispatchRecipients = {
                    description = "Wybierz nazwy prac, które otrzymują powiadomienia o napadzie na bankomat.",
                    label = "Odbiorcy",
                },
                atmDistances = {
                    description = "Ustaw zasięgi dla gracza i pojazdów używane podczas interakcji z bankomatem.",
                    label = "Dystanse interakcji",
                },
                atmExplosionEffects = {
                    description = "Konfiguruje natywne parametry eksplozji używane podczas detonacji.",
                    label = "Efekty eksplozji",
                },
                atmItems = {
                    description = "Ustaw wymagane przedmioty wiertarki, pasa holowniczego i ładunku wybuchowego.",
                    label = "Wymagane przedmioty",
                },
                atmLocations = {
                    description = "Zarządza autoryzowanymi przez serwer pozycjami bankomatów dostępnymi do napadów.",
                    label = "Lokalizacje bankomatów",
                },
                atmPayout = {
                    description = "Skonfiguruj konto docelowe i losowy zakres nagród.",
                    label = "Wypłata",
                },
                atmPolice = {
                    description = "Skonfiguruj wymagany poziom liczby policjantów na służbie do rozpoczęcia napadu.",
                    label = "Wymóg obecności policji",
                },
                atmPulling = {
                    description = "Skonfiguruj ruch wymagany do wyrwania bankomatu ze ściany.",
                    label = "Wykrywanie szarpania",
                },
                atmTimeouts = {
                    description = "Określ, jak długo sforsowany bankomat pozostaje dostępny do okradnięcia.",
                    label = "Czas na łup",
                },
                baseRaids = {
                    description = "Dostęp do napadu, wymagania i indywidualnie wybieralne kategorie łupów. Otwarte napady nie mają limitu czasu transportu.",
                    label = "Napad na bazę",
                },
                businessPayments = {
                    description = "Wybierz saldo, które opłaca zakupy i koszty operacyjne w Sieci Biznesowej.",
                    label = "Płatności",
                },
                crimeMembership = {
                    description = "Wybierz, w jaki sposób organizacje przestępcze przechowują i zarządzają swoimi członkami.",
                    label = "Model członkostwa",
                },
                darknetAvailability = {
                    description = "Kontroluje aplikację na tablet i jej rozmieszczenie.",
                    label = "Dostępność",
                },
                darknetChat = {
                    description = "Ogranicza zaszyfrowane wiadomości na rynku.",
                    label = "Czat prywatny",
                },
                darknetDelivery = {
                    description = "Konfiguruje spotkania osobiste i kradzieżowe skrzynie w świecie gry.",
                    label = "Przekazanie i dead dropy",
                },
                darknetDeliveryLocations = {
                    description = "Konfiguruje pule lokalizacji losowo przydzielane do transakcji NPC w BlackBay.",
                    label = "Miejsca przekazania",
                },
                darknetEconomy = {
                    description = "Konfiguruje salda portfeli, wymianę monet i stawki płatności.",
                    label = "Kryptowaluta",
                },
                darknetIdentity = {
                    description = "Konfiguruje rotację tożsamości, weryfikację i ostrzeżenia przed oszustwem.",
                    label = "Aliasy i reputacja",
                },
                darknetListings = {
                    description = "Kontroluje limity ofert, ceny i automatyczne wygasanie.",
                    label = "Oferty i wygaśnięcie",
                },
                darknetNpcTraders = {
                    description = "Trwali kupujący i sprzedawcy NPC z konfigurowalnym ryzykiem.",
                    label = "Handlarze NPC",
                },
                darknetPolice = {
                    description = "Grupy zawodowe uprawnione do wystawiania pułapek i przeglądania dochodzeń.",
                    label = "Dostęp policji",
                },
                heistCrafting = {
                    description = "Wybierz poziom trudności wytwarzania sprzętu do napadu. Dotyczy nowych prób w całym systemie przestępczym.",
                    label = "Warsztat napadu",
                },
                heistCreatorMenu = {
                    description = "Twórz, edytuj i publikuj modułowe napady w dedykowanym Kreatorze Napadów.",
                    label = "Menu twórcy",
                },
                heistExecution = {
                    description = "Okno startowe, nieaktywność i czas odnowienia dla prób napadu.",
                    label = "Czas trwania napadu",
                },
                moneywashEconomy = {
                    description = "Włącz biznesy i skonfiguruj konto depozytowe, opłatę serwisową oraz dystanse interakcji.",
                    label = "Ogólne",
                },
                npcPoliceSupport = {
                    description = "Uzbrojeni oficerowie NPC reagują pieszo na alarmy napadu i wspierają policję, angażując się w walkę z rabusiami.",
                    label = "Wsparcie policji NPC",
                },
                pickpocketAvailability = {
                    description = "Włącz tę funkcję i opcjonalnie ogranicz ją do skonfigurowanych prac przestępczych.",
                    label = "Dostępność",
                },
                pickpocketDispatchSettings = {
                    description = "Konfiguruje alert wysyłany, gdy NPC dzwoni po służby ratunkowe.",
                    label = "Dyspozytor służb ratunkowych",
                },
                pickpocketDistances = {
                    description = "Ustaw zasięg NPC używany przez wspólny system menu kołowego i celu.",
                    label = "Dystanse interakcji",
                },
                pickpocketGameplay = {
                    description = "Wybierz poziom trudności oraz niezależne prawdopodobieństwo ucieczki, wezwania służb i kontrataku.",
                    label = "Ryzyko i minigra",
                },
                pickpocketItemRewards = {
                    description = "Kontroluj zawartość pustych kieszeni oraz widoczne przedmioty z dokładnością do 0.0001 procent.",
                    label = "Widoczny łup z kieszeni",
                },
                pickpocketMoney = {
                    description = "Skonfiguruj serwerowy zakres losowej kwoty gotówki.",
                    label = "Nagroda w gotówce",
                },
                pickpocketRateLimits = {
                    description = "Kontroluj ograniczanie żądań, czas odnowienia dla każdego NPC oraz wygasanie sesji.",
                    label = "Zabezpieczenia serwera",
                },
                pvpArenas = {
                    description = "Tworzy okrągłą strefę, punkt obserwacyjny i punkty odrodzenia drużyn używane podczas wydarzeń PvP.",
                    label = "Areny i strefy walki",
                },
                pvpAutomation = {
                    description = "Konfiguruj powtarzalne zdarzenia i automatyczne procesy rozpoczynania.",
                    label = "Automatyzacja",
                },
                pvpAvailability = {
                    description = "Kontroluj, czy aplikacja wydarzeń PvP jest dostępna i gdzie się pojawia.",
                    label = "Dostępność",
                },
                pvpLimits = {
                    description = "Ustaw limity nagród i historii w tablecie.",
                    label = "Limity i historia",
                },
                pvpModes = {
                    description = "Skonfiguruj tryb gry wstępnie wybrany w tablecie PvP.",
                    label = "Tryby gry",
                },
                pvpPermissions = {
                    description = "Przypisuje zarządzanie wydarzeniami i finanse do uprawnień ACE i ról.",
                    label = "Uprawnienia",
                },
                pvpRuntime = {
                    description = "Dostosuj obsługę żądań, zgony i odrodzenia podczas trwających meczów.",
                    label = "Czas trwania meczu",
                },
                pvpTakeoverMethods = {
                    description = "Skonfiguruj, jak długo każda metoda zajmuje na sforsowanie wejścia.",
                    label = "Metody włamania",
                },
                pvpTakeoverRules = {
                    description = "Kontroluje dostępność i wymagania uczestnictwa przy przejmowaniu laboratoriów i kamperów.",
                    label = "Zasady przejęcia",
                },
                pvpTakeoverZones = {
                    description = "Skonfiguruj obszary interakcji, alarmów i przejęcia wraz z ich czasem trwania.",
                    label = "Strefy i czas trwania",
                },
                shopAvailability = {
                    description = "Włącz napady i skonfiguruj wymagania dotyczące policji.",
                    label = "Dostępność",
                },
                shopDispatchSettings = {
                    description = "Skonfiguruj odbiorców i właściwości alarmu.",
                    label = "Alarm policyjny",
                },
                shopLocationTable = {
                    description = "Zarządzaj obsługiwanymi sklepami detalicznymi i sejfami.",
                    label = "Lokalizacje sklepów",
                },
                shopRegisterReward = {
                    description = "Skonfiguruj losową nagrodę dla każdej kasy.",
                    label = "Nagroda z kasy",
                },
                shopRegisterTable = {
                    description = "Przypisz poszczególne kasy do sklepów.",
                    label = "Kasy rejestrujące",
                },
                shopSafe = {
                    description = "Skonfiguruj liczbę prób wpisania kodu oraz przedmiot wiertarki.",
                    label = "Sejf",
                },
                shopSafeReward = {
                    description = "Skonfiguruj losową nagrodę z sejfu.",
                    label = "Nagroda z sejfu",
                },
                shopTiming = {
                    description = "Skonfiguruj zastraszanie, akcje, czas wygaśnięcia i czas odnowienia.",
                    label = "Czas trwania",
                },
            },
            settingSections = {
                weapons = "Trasy broni",
                drugs = "System narkotyków",
                drugProduction = "Produkcja narkotyków",
                drugOperations = "Działalność narkotykowa",
                drugMarketRisk = "Rynek i ryzyko",
                drugNetworks = "Sieci narkotykowe",
                atmRobbery = "Napad na bankomat",
                baseRaids = "Napad na bazę",
                crimeOrganizations = "Organizacje",
                darknetMarket = "Rynek Darknet",
                moneywash = "Pranie pieniędzy",
                pvpEvents = "PvP frakcji",
                robbery = "Napady",
                territories = "Terytoria",
                graffiti = "Graffiti",
                interrogation = "Przesłuchanie",
            },
            settingSubsections = {
                baseRaidEquipment = "Wymagany sprzęt",
                baseRaidBreach = "Włamanie",
                baseRaidLoot = "Łupy i pojazdy",
                graffitiLimits = "Limity i moderacja",
                interrogationTechnical = "Dzienniki i bezpieczeństwo",
                atmDispatch = "Dyspozytornia policji",
                atmEquipment = "Sprzęt",
                atmExplosion = "Eksplozja",
                atmOverview = "Przegląd i lokalizacje",
                atmRewards = "Nagrody",
                atmTiming = "Czas trwania",
                atmVehicle = "Pojazd i wyciąganie",
                baseRaids = "Napad na bazę",
                crimeMembership = "Członkostwo",
                heistCreator = "Twórca napadów",
                npcPoliceSupport = "Wsparcie policji NPC",
                pickpocket = "Kieszonkowanie NPC",
                pvpArenas = "Areny",
                pvpEquipment = "Tryby gry",
                pvpOverview = "Przegląd",
                pvpRuntime = "Czas trwania meczu",
                pvpTakeovers = "Przejęcia laboratoriów",
                shopRobbery = "Napady na sklepy",
                atmRobbery = "Napad na bankomat",
            },
            settings = {
                weaponDefaultGeneralInteractionDistance = { label = "Odległość interakcji" },
                weaponDefaultGeneralPedModel = { label = "Domyślny model NPC" },
                weaponDefaultAccessActiveHourStart = { label = "Godzina otwarcia (UTC)" },
                weaponDefaultAccessActiveHourEnd = { label = "Godzina zamknięcia (UTC)" },
                weaponDefaultAccessPoliceRequired = { label = "Wymagana liczba policjantów na służbie" },
                weaponDefaultAccessPoliceJobs = { label = "Prace policyjne" },
                weaponDefaultCollectionDurationSeconds = { label = "Czas w sekundach" },
                weaponDefaultCollectionCooldownSeconds = { label = "Przerwa w sekundach" },
                weaponDefaultCollectionCooldownScope = { label = "Zakres przerwy" },
                weaponDefaultCollectionUseMinigame = { label = "Użyj minigry" },
                weaponDefaultCollectionMinigame = { label = "Minigra" },
                weaponDefaultCollectionMinigameRounds = { label = "Rundy minigry" },
                weaponDefaultProductionDurationSeconds = { label = "Czas w sekundach" },
                weaponDefaultProductionSuccessChance = { label = "Szansa powodzenia (%)" },
                weaponDefaultProductionFailureConsumesInputs = { label = "Zużyj składniki przy niepowodzeniu" },
                weaponDefaultProductionUseMinigame = { label = "Użyj minigry" },
                weaponDefaultProductionMinigame = { label = "Minigra" },
                weaponDefaultProductionMinigameRounds = { label = "Rundy minigry" },
                weaponDefaultProductionQualityMin = { label = "Minimalna jakość" },
                weaponDefaultProductionQualityMax = { label = "Maksymalna jakość" },
                weaponDefaultProductionCooldownSeconds = { label = "Przerwa w sekundach" },
                weaponDefaultProductionCooldownScope = { label = "Zakres przerwy" },
                weaponDefaultMarketPayoutAccount = { label = "Konto wypłaty" },
                weaponDefaultMarketPriceMultiplierMin = { label = "Minimalny mnożnik ceny (%)" },
                weaponDefaultMarketPriceMultiplierMax = { label = "Maksymalny mnożnik ceny (%)" },
                weaponDefaultMarketRestockSeconds = { label = "Odstęp uzupełnienia w sekundach" },
                weaponDefaultMarketCooldownSeconds = { label = "Przerwa w sekundach" },
                weaponDefaultMarketCooldownScope = { label = "Zakres przerwy" },
                weaponDefaultDeliveryContractDurationMinutes = { label = "Termin zlecenia w minutach" },
                weaponDefaultDeliveryContractBonusPercent = { label = "Premia za zlecenie (%)" },
                weaponStreetEnabled = { label = "Rzadkie sprzedaże broni ulicznym kupcom" },
                weaponStreetChance = { label = "Szansa oferty broni (%)" },
                weaponStreetCooldown = { label = "Przerwa w sekundach" },
                weaponStreetAmount = { label = "Maksymalna ilość" },
                weaponStreetPriceMin = { label = "Minimalny mnożnik ceny (%)" },
                weaponStreetPriceMax = { label = "Maksymalny mnożnik ceny (%)" },
                weaponStreetAccount = { label = "Konto wypłaty" },
                weaponStreetDirect = { label = "Sprzedaż bezpośrednia" },
                weaponStreetBulk = { label = "Sprzedaż zbiorcza" },
                weaponStreetContract = { label = "Zlecenie kartelu" },
                weaponSystemEnabled = { label = "System tras broni", description = "Włącz zbieranie i przetwarzanie broni oraz sprzedaż kartelom." },
                weaponRuntimeEnabled = { label = "Akcje tras broni", description = "Zezwól na korzystanie ze skonfigurowanych tras broni w świecie gry." },
                weaponCreatorAccess = { label = "Dostęp do kreatora broni", description = "Wybierz, kto może otwierać kreator broni.", options = { permission = "Tylko z uprawnieniem", jobManagement = "Zarządzanie pracą", ownerOnly = "Tylko właściciel" } },
                openWeaponCreator = { label = "Nielegalny stwórca biznesu", description = "Zarządzaj trasami broni i praniem pieniędzy w jednym edytorze.", buttonLabel = "Nielegalny stwórca biznesu", unsavedTooltip = "Najpierw zapisz" },

                drugCultivationProgressionEnabled = { label = "Włącz poziomy uprawy", description = "Włącza XP uprawy, poziomy i odblokowania zależne od poziomu." },
                drugCultivationMaxLevel = { label = "Maksymalny poziom uprawy", description = "Najwyższy osiągalny poziom uprawy. Wyższe poziomy pozostają niedostępne." },
                drugCultivationLevels = { label = "Krzywa poziomów", description = "Ustaw nazwę i wymagane łączne XP dla każdego poziomu uprawy." },
                drugCultivationActionXp = { label = "Nagrody XP", description = "Ustaw liczbę XP uprawy przyznawaną za każdą akcję." },
                drugCultivationUnlocks = { label = "Odblokowania poziomów", description = "Ustaw wymagany poziom dla pojemników, podłoży, sprzętu, odmian i poziomów skanera." },
                reputationRewards = { label = "Akcje reputacji", description = "Dodawaj akcje, zmieniaj punkty oraz wyłączaj lub usuwaj wpisy. Tylko aktywne wpisy przyznają punkty." },
                reputationEnabled = { label = "Włącz reputację przestępczą", description = "Przyznawaj reputację osobistą." },
                reputationPointsPerLevel = { label = "Punkty na poziom", description = "Każdy poziom wymaga tylu dodatkowych punktów." },
                reputationMinimumJoinPoints = { label = "Minimalna reputacja do dołączenia", description = "Łączna liczba punktów wymagana do dołączenia do frakcji przestępczej. 0 wyłącza wymóg. Obecni członkowie zachowują dostęp." },
                reputation_atm = { label = "Napad na bankomat", description = "Punkty za pomyślne ukończenie akcji. 0 wyłącza tę nagrodę." },
                reputation_shop_register = { label = "Kasa sklepowa", description = "Punkty za pomyślne ukończenie akcji. 0 wyłącza tę nagrodę." },
                reputation_shop_safe = { label = "Sejf sklepowy", description = "Punkty za pomyślne ukończenie akcji. 0 wyłącza tę nagrodę." },
                reputation_pickpocket = { label = "Kradzież kieszonkowa", description = "Punkty za pomyślne ukończenie akcji. 0 wyłącza tę nagrodę." },
                reputation_heist = { label = "Ukończenie napadu", description = "Punkty za pomyślne ukończenie akcji. 0 wyłącza tę nagrodę." },
                reputation_drug_harvest = { label = "Zbiór narkotyków", description = "Punkty za pomyślne ukończenie akcji. 0 wyłącza tę nagrodę." },
                reputation_drug_processing = { label = "Przetwarzanie narkotyków", description = "Punkty za pomyślne ukończenie akcji. 0 wyłącza tę nagrodę." },
                reputation_drug_sale = { label = "Sprzedaż narkotyków", description = "Punkty za pomyślne ukończenie akcji. 0 wyłącza tę nagrodę." },
                reputation_drug_delivery = { label = "Dostawa narkotyków", description = "Punkty za pomyślne ukończenie akcji. 0 wyłącza tę nagrodę." },
                reputation_drug_contract = { label = "Kontrakt dystrybucyjny", description = "Punkty za pomyślne ukończenie akcji. 0 wyłącza tę nagrodę." },
                reputation_drug_raid = { label = "Napad na narkotyki", description = "Punkty za pomyślne ukończenie akcji. 0 wyłącza tę nagrodę." },
                reputation_graffiti = { label = "Graffiti", description = "Punkty za pomyślne ukończenie akcji. 0 wyłącza tę nagrodę." },
                reputation_moneywash = { label = "Pranie pieniędzy", description = "Punkty za pomyślne ukończenie akcji. 0 wyłącza tę nagrodę." },
                reputation_base_raid = { label = "Napad na bazę", description = "Punkty za pomyślne ukończenie akcji. 0 wyłącza tę nagrodę." },
                reputation_pvp_win = { label = "Zwycięstwo PvP", description = "Punkty za pomyślne ukończenie akcji. 0 wyłącza tę nagrodę." },
                atmChargeProp = {
                    description = "Model obiektu wyświetlany na bankomacie podczas podkładania ładunku wybuchowego.",
                    label = "Model ładunku",
                },
                atmConsumeDrill = {
                    description = "Zużywa ustawioną liczbę po pomyślnym ukończeniu każdego punktu wiercenia w bankomacie.",
                    label = "Zużywaj wiertarkę",
                },
                atmDrillItem = {
                    description = "Identyfikator przedmiotu w ekwipunku potrzebnego do wiercenia w wyrwanym bankomacie. Ustawienie niezależne od wiertarki do sejfów sklepowych.",
                    label = "Przedmiot wiertarki",
                },
                atmDrillItemAmount = {
                    description = "Liczba przedmiotów wiertarki potrzebnych do każdego punktu wiercenia w bankomacie.",
                    label = "Wymagana liczba wiertarek",
                },
                atmDebug = {
                    description = "Zapisuje szczegółowe diagnostyki napadu na ATM w konsoli serwera i konsoli klienta F8.",
                    label = "Logi debugowania ATM",
                },
                atmDispatchDurationSeconds = {
                    description = "Liczba sekund, przez które alert bankomatu pozostaje istotny dla odbiorców w dyspozytorni.",
                    label = "Czas dyspozytorni",
                },
                atmDispatchEnabled = {
                    description = "Tworzy incydent Jobs Base po włamaniu do ATM.",
                    label = "Włącz dyspozytornię policji",
                },
                atmDispatchJobs = {
                    description = "Nazwy prac oddzielone przecinkami, które otrzymują alert o napadzie na bankomat.",
                    label = "Prace dyspozytorni",
                },
                atmDispatchPriority = {
                    description = "Wartość priorytetu przekazywana bez zmian do integracji dyspozytorni.",
                    label = "Priorytet dyspozycji",
                },
                atmDispatchRadius = {
                    description = "Przybliżony promień alarmu wysyłanego do integracji dyspozytorni.",
                    label = "Promień dyspozycji",
                },
                atmEnabled = {
                    description = "Umożliwia dostęp do skonfigurowanych bankomatów dla napadów na sznury i materiały wybuchowe.",
                    label = "Włącz napady na bankomaty",
                },
                atmExplosionCameraShake = {
                    description = "Intensywność wstrząsu kamery dla klienta wywołującego wybuch.",
                    label = "Wstrząs kamery przy wybuchu",
                },
                atmExplosionDamageScale = {
                    description = "Siła obrażeń i impulsu przekazywana do natywnej funkcji wybuchu.",
                    label = "Skala obrażeń od wybuchu",
                },
                atmExplosionType = {
                    description = "Typ wybuchu GTA używany podczas detonacji. Zachowaj domyślny, chyba że przetestowano inny typ.",
                    label = "Typ wybuchu",
                },
                atmDrillDurationSeconds = {
                    label = "Minimalny czas wiercenia na śrubę (s)",
                    description = "Minimalny czas w sekundach dla każdej z czterech śrub. Przerwy na chłodzenie wydłużają próbę. Dotyczy prób wiercenia rozpoczętych po zapisaniu ustawień.",
                },
                atmExplosiveDurationSeconds = {
                    description = "Liczba sekund wymagana do podłożenia ładunku wybuchowego.",
                    label = "Czas podkładania ładunku",
                },
                atmExplosiveItem = {
                    description = "Przedmiot z ekwipunku zużywany po podłożeniu ładunku.",
                    label = "Przedmiot wybuchowy",
                },
                atmExplosiveItemAmount = {
                    description = "Liczba zużytych materiałów wybuchowych na jedną podłożoną ładunek.",
                    label = "Zużyta ilość materiału wybuchowego",
                },
                atmFuseSeconds = {
                    description = "Liczba sekund między podłożeniem a detonacją.",
                    label = "Czas zapłonu",
                },
                atmInteractionDistance = {
                    description = "Maksymalny zasięg interakcji klienta; walidacja serwera dodaje margines bezpieczeństwa.",
                    label = "Dystans interakcji",
                },
                atmLocations = {
                    description = "Oficjalne lokalizacje produkcyjne. Lokalizacje utworzone za pomocą /atmtest pozostają tymczasowe.",
                    itemLabel = "Lokalizacja bankomatu",
                    label = "Lokalizacje bankomatów",
                },
                atmLootDurationSeconds = {
                    description = "Liczba sekund wymagana do otwarcia sforsowanego bankomatu.",
                    label = "Czas trwania łupu",
                },
                atmLootReservationTimeoutSeconds = {
                    description = "Maksymalna liczba sekund, przez które gracz może rezerwować bankomat podczas jego otwierania; automatycznie utrzymywana powyżej czasu opróżniania łupu.",
                    label = "Czas wygaśnięcia rezerwacji łupu",
                },
                atmLootWindowMinutes = {
                    description = "Liczba minut, przez które włamanie do bankomatu pozostaje możliwe do ograbienia przed opróżnieniem.",
                    label = "Czas na łup",
                },
                atmMinimumPolice = {
                    description = "Liczba członków skonfigurowanej grupy policyjnej będących na służbie, wymagana do rozpoczęcia napadu.",
                    label = "Minimalna liczba policji",
                },
                atmPoliceGroup = {
                    description = "Grupa prac sky_jobs_base liczona do wymogu obecności policji.",
                    label = "Grupa zawodowa policji",
                },
                atmPullDistance = {
                    description = "Przesunięcie pojazdu od pozycji bankomatu wymagane do sfinalizowania włamania.",
                    label = "Wymagany dystans ciągnięcia",
                },
                atmPullMinimumSpeed = {
                    description = "Minimalna prędkość pojazdu w metrach na sekundę po osiągnięciu dystansu ciągnięcia.",
                    label = "Minimalna prędkość ciągnięcia",
                },
                atmReservationTimeoutSeconds = {
                    description = "Maksymalna liczba sekund rezerwowanych podczas mocowania pętli lub podkładania ładunku; automatycznie utrzymywana powyżej czasu trwania akcji.",
                    label = "Timeout rezerwacji przygotowań",
                },
                atmRewardAccount = {
                    description = "Wybierz gotówkę lub przedmiot black_money.",
                    label = "Typ wypłaty z bankomatu",
                },
                atmRewardMaximum = {
                    description = "Najwyższa wypłata gotówki z jednego bankomatu; nigdy niższa niż minimum.",
                    label = "Maksymalna nagroda",
                },
                atmRewardMinimum = {
                    description = "Najniższa wypłata gotówkowa z jednego bankomatu.",
                    label = "Minimalna nagroda",
                },
                atmSlingDurationSeconds = {
                    description = "Liczba sekund wymagana do założenia zawijki.",
                    label = "Czas zakładania zawijki",
                },
                atmSlingItem = {
                    description = "Wymagany przedmiot z ekwipunku wielokrotnego użytku dla metody z użyciem pojazdu.",
                    label = "Przedmiot do przeciągnięcia",
                },
                atmSlingItemAmount = {
                    description = "Liczba wymaganych zawijek. Nie są one zużywane.",
                    label = "Wymagana liczba zawijek",
                },
                atmTestScanDistance = {
                    description = "Maksymalny dystans używany przez /atmtest podczas szukania wspieranego modelu ATM.",
                    label = "Dystans skanowania testu ATM",
                },
                atmVehicleMaxDistance = {
                    description = "Maksymalna odległość między bankomatem a kwalifikowanym pojazdem podczas montażu liny.",
                    label = "Dystans montażu pojazdu",
                },
                baseRaid_breachTimeoutSeconds = {
                    description = "Limit czasu każdej próby wyłamania zamka magazynu (sekundy).",
                    label = "Czas na szturm (sekundy)",
                },
                baseRaid_command = {
                    description = "Nazwa komendy bez ukośnika. Po zmianie zrestartuj zasób crime.",
                    label = "Komenda szturmu",
                },
                baseRaid_crimeItem = {
                    description = "Przedmiot do włamania do bazy gangu.",
                    label = "Przedmiot do włamania do bazy gangu",
                },
                baseRaid_crimeVehicles = {
                    description = "Dostęp do pojazdów gangu.",
                    label = "Dostęp do pojazdów gangu",
                },
                baseRaid_difficulty = {
                    description = "Trudność skillchecku.",
                    label = "Trudność skillchecku",
                    options = {
                        easy = "Łatwy",
                        expert = "Ekspert",
                        hard = "Trudny",
                        normal = "Normalna",
                    },
                },
                baseRaid_enabled = {
                    description = "Włącz szturmy na bazy.",
                    label = "Włącz szturmy na bazy",
                },
                baseRaid_failedCooldownMinutes = {
                    description = "Czas oczekiwania po nalocie zakończonym bez otwarcia żadnego magazynu (minuty).",
                    label = "Czas oczekiwania po niepowodzeniu (minuty)",
                },
                baseRaid_interactionDistance = {
                    description = "Dystans interakcji ze schowkiem.",
                    label = "Dystans interakcji ze schowkiem",
                },
                baseRaid_lootHeistStorage = {
                    description = "Pozwala na całkowite opróżnienie tej kategorii ekwipunku podczas aktywnego napadu.",
                    label = "Magazyn łupu z napadu",
                },
                baseRaid_lootLaboratories = {
                    description = "Pozwala na całkowite opróżnienie tej kategorii ekwipunku podczas aktywnego napadu.",
                    label = "Łup z laboratorium",
                },
                baseRaid_lootPersonalLockers = {
                    description = "Pozwala na całkowite opróżnienie tej kategorii ekwipunku podczas aktywnego napadu.",
                    label = "Plądrowanie prywatnych szafek",
                },
                baseRaid_lootStorage = {
                    description = "Pozwala na całkowite opróżnienie tej kategorii ekwipunku podczas aktywnego napadu.",
                    label = "Łup ze schowka",
                },
                baseRaid_lootVehicleGloveboxes = {
                    description = "Pozwala na całkowite opróżnienie tej kategorii ekwipunku podczas aktywnego napadu.",
                    label = "Plądrowanie schowków w pojazdach",
                },
                baseRaid_lootVehicleTrunks = {
                    description = "Pozwala na całkowite opróżnienie tej kategorii ekwipunku podczas aktywnego napadu.",
                    label = "Plądrowanie schowków w pojazdach",
                },
                baseRaid_minimumDefenders = {
                    description = "Minimalna liczba obrońców online.",
                    label = "Minimalna liczba obrońców online",
                },
                baseRaid_policeItem = {
                    description = "Przedmiot szturmu policji.",
                    label = "Przedmiot do włamania policji",
                },
                baseRaid_policeRequireDuty = {
                    description = "Policja musi być w służbie.",
                    label = "Policja musi być w służbie",
                },
                baseRaid_policeVehicles = {
                    description = "Dostęp do pojazdów policji.",
                    label = "Dostęp do pojazdów policji",
                },
                baseRaid_protectionHours = {
                    description = "Ochrona po sukcesie (godziny).",
                    label = "Ochrona po sukcesie (godziny)",
                },
                baseRaid_requiredHits = {
                    description = "Wymagana liczba trafień skillchecku.",
                    label = "Wymagana liczba trafień skillchecku",
                },
                baseRaid_warrantItem = {
                    description = "Jeden z tych przedmiotów zostaje zużyty przy każdym poprawnym rozpoczęciu szturmu policji.",
                    label = "Przedmiot: nakaz przeszukania",
                },
                crimeMembershipMode = {
                    description = "Tryb framework zachowuje istniejącą pracę lub natywną integrację gangu. Tryb niezależny prowadzi organizację przestępczą w tle obok normalnej pracy gracza i automatycznie przenosi istniejące członkostwa.",
                    label = "Model członkostwa w organizacji",
                    options = {
                        framework = "Praca w frameworku / gang",
                        independent = "Niezależna organizacja",
                    },
                },
                darknetAliasChangeCooldownHours = {
                    description = "Minimalny wiek tożsamości przed ponownym jej wycofaniem.",
                    label = "Czas oczekiwania na zmianę aliasu (godziny)",
                },
                darknetCurrencyCode = {
                    description = "Krótki skrót dla wewnętrznego rejestru kryptowalut.",
                    label = "Kod waluty",
                },
                darknetDeadDropInteractionDistance = {
                    description = "Dystans wymagany do przeszukania i odebrania skrzyni.",
                    label = "Dystans interakcji Dead-drop",
                },
                darknetDeadDropLifetimeHours = {
                    description = "Czas, po którym nieodebrana skrzynia wygasa.",
                    label = "Czas trwania Dead-drop (godziny)",
                },
                darknetDeadDropModel = {
                    description = "Model obiektu GTA generowany lokalnie dla dostępnych skrzyń Dead-drop.",
                    label = "Model skrzyni Dead-drop",
                },
                darknetDeadDropPollIntervalMs = {
                    description = "Interwał używany do odświeżania pobliskich skrzyń i spotkań NPC.",
                    label = "Interwał odświeżania świata (ms)",
                },
                darknetDeadDropStreamDistance = {
                    description = "Dystans, przy którym skrzynie i kontakty NPC są renderowane.",
                    label = "Dystans renderowania Dead-drop",
                },
                darknetDropLocations = {
                    description = "Lokalizacje losowo przypisywane do handlu z NPC w ramach martwych skrzynek. Skonfiguruj co najmniej dwie.",
                    itemLabel = "Lokalizacja martwej skrzynki",
                    label = "Lokalizacje martwych skrzynek",
                },
                darknetEnabled = {
                    description = "Umożliwia dostęp do aplikacji tabletu czarnego rynku oraz jej logiki działania.",
                    label = "Włącz Rynek Darknet",
                },
                darknetExchangeBuyPrice = {
                    description = "Kwota pobrana z konta płatniczego za jedną monetę.",
                    label = "Cena zakupu za monetę",
                },
                darknetExchangeEnabled = {
                    description = "Pozwala uwierzytelnionym użytkownikom BlackBay kupować i sprzedawać monety na swojej stronie konta.",
                    label = "Włącz wymianę monet",
                },
                darknetExchangeMaximumAmount = {
                    description = "Największa pełna liczba monet akceptowana w jednej wymianie.",
                    label = "Maksymalna liczba monet w wymianie",
                },
                darknetExchangeMinimumAmount = {
                    description = "Najmniejsza pełna liczba monet akceptowana w jednej wymianie.",
                    label = "Minimalna liczba monet w wymianie",
                },
                darknetExchangePaymentAccount = {
                    description = "Konto frameworkowe używane do zakupów monet i wypłat ze sprzedaży monet.",
                    label = "Konto płatnicze wymiany",
                    options = {
                        bank = "Bank",
                        black_money = "Brudna kasa",
                        money = "Gotówka",
                    },
                },
                darknetExchangeSellPrice = {
                    description = "Kwota wypłacona na konto płatnicze za jedną monetę.",
                    label = "Cena sprzedaży za monetę",
                },
                darknetFaceToFaceDistance = {
                    description = "Maksymalna odległość między oboma graczami lub od skonfigurowanego punktu NPC.",
                    label = "Dystans przekazania",
                },
                darknetKnownScammerReports = {
                    description = "Liczba unikalnych zgłoszeń transakcji wymagana do otrzymania odznaki znanego oszusta.",
                    label = "Zgłoszenia w celu ostrzeżenia oszusta",
                },
                darknetListingExpiryHours = {
                    description = "Aktywne oferty wygasają automatycznie po tej liczbie godzin.",
                    label = "Czas trwania oferty (godziny)",
                },
                darknetMaximumListingQuantity = {
                    description = "Górny limit ilościowy dla pojedynczej oferty.",
                    label = "Maksymalna ilość towaru",
                },
                darknetMaximumListings = {
                    description = "Maksymalna liczba ofert na jeden aktywny alias.",
                    label = "Maksymalna liczba aktywnych ofert",
                },
                darknetMaximumMessageLength = {
                    description = "Maksymalna liczba znaków w zaszyfrowanej wiadomości na czacie.",
                    label = "Maksymalna długość wiadomości",
                },
                darknetMaximumUnitPrice = {
                    description = "Maksymalna cena krypto za jedną jednostkę.",
                    label = "Maksymalna cena jednostkowa",
                },
                darknetMeetingLocations = {
                    description = "Miejsca losowane do bezpośrednich transakcji z NPC. Skonfiguruj co najmniej dwa.",
                    itemLabel = "Miejsce spotkania",
                    label = "Miejsca spotkań",
                },
                darknetNpcBuyerAliases = {
                    description = "Fikcyjne nazwy losowo przypisywane nowym ofertom zakupu NPC. Skonfiguruj co najmniej dwa unikalne pseudonimy.",
                    label = "Pseudonimy kupujących NPC",
                },
                darknetNpcMaximumBuyListings = {
                    description = "Górny limit używany przy losowaniu liczby aktywnych ofert zakupu NPC.",
                    label = "Maksymalna liczba ofert zakupu NPC",
                },
                darknetNpcMaximumSellListings = {
                    description = "Górny limit używany przy losowaniu liczby aktywnych ofert sprzedaży NPC.",
                    label = "Maksymalna liczba ofert sprzedaży NPC",
                },
                darknetNpcMinimumBuyListings = {
                    description = "Po odnowieniu rynku NPC, co najmniej tyle losowo wybranych ofert zakupu pozostanie aktywnych.",
                    label = "Minimalna liczba ofert zakupu od NPC",
                },
                darknetNpcMinimumSellListings = {
                    description = "Gdy rynek NPC zostaje uzupełniony, co najmniej tyle losowo wybranych ofert sprzedaży pozostaje aktywnych.",
                    label = "Minimalna liczba ofert sprzedaży NPC",
                },
                darknetNpcSellerAliases = {
                    description = "Fikcyjne nazwy losowo przypisywane nowym ofertom sprzedaży NPC. Skonfiguruj co najmniej dwa unikalne pseudonimy.",
                    label = "Pseudonimy sprzedawców NPC",
                },
                darknetNpcTraders = {
                    description = "Konfiguracja ofert syntetycznych, metody dostawy, reputacji i prawdopodobieństwa oszustwa.",
                    label = "Kupujący i sprzedający NPC",
                },
                darknetPoliceGroups = {
                    description = "Klucze grupowe umożliwiające publikowanie ofert przynęty i przeglądanie dochodzeń.",
                    label = "Uprawnione grupy zawodowe policji",
                },
                darknetRenewalHours = {
                    description = "Liczba godzin dodawanych, gdy właściciel odnawia ofertę.",
                    label = "Czas odnowienia (godziny)",
                },
                darknetScamChance = {
                    description = "Minimalna szansa, że NPC podczas transakcji zabierze płatność lub towar bez przekazania zapłaty. Wyższa szansa specyficzna dla handlarza nadal obowiązuje.",
                    label = "Globalna szansa na oszustwo NPC (%)",
                },
                darknetStarterBalance = {
                    description = "Kryptowaluta przyznawana tylko wtedy, gdy gracz po raz pierwszy otwiera rynek.",
                    label = "Saldo nowego portfela",
                },
                darknetTabletOrder = {
                    description = "Kontroluje pozycję Rynku Darknet na tablecie.",
                    label = "Kolejność aplikacji na tablecie",
                },
                darknetVerifiedMinimumRating = {
                    description = "Minimalna średnia ocena dla zweryfikowanego sprzedawcy.",
                    label = "Wymagana ocena do weryfikacji",
                },
                darknetVerifiedMinimumSales = {
                    description = "Liczba udanych sprzedaży wymagana, aby sprzedawca mógł zostać zweryfikowany.",
                    label = "Wymagana liczba sprzedaży do weryfikacji",
                },
                drugAdvancedBusinessNetworkPaymentAccount = {
                    description = "Konto używane, gdy źródło płatności jest ustawione na konto gracza. Płatności organizacji zawsze korzystają z konta w Menu Szefa.",
                    label = "Konto płatnicze gracza",
                    options = {
                        bank = "Bank",
                        black_money = "Brudna kasa",
                        money = "Gotówka",
                    },
                    requiresWarning = "Używane wyłącznie ze źródłem płatności konta gracza.",
                },
                drugAdvancedBusinessNetworkPaymentSource = {
                    description = "Użyj salda kupującego gracza lub konta organizacji w Menu Szefa.",
                    label = "Źródło płatności",
                    options = {
                        player = "Konto gracza",
                        society = "Konto organizacji",
                    },
                },
                drugCamperLockKey = {
                    description = "Ustawia domyślny klawisz blokowania i odblokowywania własnych lub współdzielonych przez frakcję kamperów. Gracze mogą go zmienić w ustawieniach klawiszy FiveM.",
                    label = "Domyślny klawisz blokady kampera",
                    options = {
                        L = "L",
                        U = "U",
                        K = "K",
                        J = "J",
                        G = "G",
                        H = "H",
                        X = "X",
                        Y = "Y",
                        F6 = "F6",
                        F7 = "F7",
                    },
                },
                drugCollectorInventoryMetadata = {
                    description = "Domyślnie dodaje dane o jakości i partii do produktów kolekcjonerskich. Wyłącz to, aby surowce układały się w stosy normalnie.",
                    label = "Metadane przedmiotów kolekcjonerskich",
                },
                drugLabAssaultAlertDuration = {
                    description = "Liczba sekund, przez które promień alarmu obrońców pozostaje widoczny na mapie.",
                    label = "Czas trwania alarmu obrońców",
                },
                drugLabAssaultAlertRadius = {
                    description = "Promień strefy ataku wyświetlanej obronnej frakcji na mapie.",
                    label = "Promień alertu obrońców",
                },
                drugLabAssaultBreachRadius = {
                    description = "Promień, w którym napastnik musi pozostać podczas otwierania wejścia.",
                    label = "Promień utrzymania przy szturmie",
                },
                drugLabAssaultCaptureDuration = {
                    description = "Liczba sekund, przez które napastnicy muszą bez przeszkód kontrolować wejście, aby przejąć laboratorium lub kampera.",
                    label = "Czas przejęcia",
                },
                drugLabAssaultCaptureRadius = {
                    description = "Obszar wejścia służący do liczenia napastników i broniących się obrońców.",
                    label = "Promień przejęcia",
                },
                drugLabAssaultElectronicDuration = {
                    description = "Liczba sekund wymagana do zhakowania systemu wejściowego.",
                    label = "Czas trwania włamania elektronicznego",
                },
                drugLabAssaultEnabled = {
                    description = "Pozwala frakcjom na włamanie się i przejęcie wrogich laboratoriów oraz kamperów współdzielonych przez frakcje.",
                    label = "Włącz przejmowanie laboratoriów i kamperów",
                },
                drugLabAssaultExplosiveDuration = {
                    description = "Liczba sekund wymagana do wyważenia wejścia przy użyciu ładunku wybuchowego.",
                    label = "Czas wyważania materiałem wybuchowym",
                },
                drugLabAssaultInteractionDistance = {
                    description = "Maksymalna odległość od wejścia do laboratorium lub kampera podczas rozpoczynania ataku.",
                    label = "Dystans interakcji przy wejściu",
                },
                drugLabAssaultMechanicalDuration = {
                    description = "Liczba sekund wymagana do wywiercenia zamka wejściowego.",
                    label = "Czas trwania włamania mechanicznego",
                },
                drugLabAssaultMinimumDefenders = {
                    description = "Liczba członków broniącej się frakcji, którzy muszą być online, zanim atak może zostać rozpoczęty.",
                    label = "Minimalna liczba obrońców",
                },
                drugLabAssaultRequireDuty = {
                    description = "Uwzględnia tylko członków broniącej frakcji, którzy są aktualnie na służbie.",
                    label = "Licz tylko obrońców na służbie",
                },
                drugProcessingInventoryMetadata = {
                    description = "Domyślnie dodaje dane o jakości i partii do produktów przetwarzania. Pojedyncze receptury mogą nadpisać to ustawienie.",
                    label = "Metadane przedmiotów do przetwarzania",
                },
                graffitiItemName = {
                    description = "Przedmiot z ekwipunku wymagany do rozpoczęcia malowania, gdy opcja wymaga przedmiotu jest włączona. Przedmiot musi znajdować się w aktywnym ekwipunku.",
                    label = "Wymagany przedmiot graffiti",
                },
                heistCooldownMinutes = {
                    description = "Blokuje ten sam napad po zakończeniu i wyczyszczeniu przebiegu z rzeczywistymi interakcjami. Wartość zero wyłącza czas oczekiwania. Nieużyte okno startowe nie aktywuje blokady.",
                    label = "Czas oczekiwania na napad (minuty)",
                },
                heistCraftingMode = {
                    optionDescriptions = {
                        simple = "Pięciosekundowy pasek postępu. Wymagane składniki są zużywane po udanym wytworzeniu.",
                        medium = "Wybierz składniki w podanej kolejności i zalicz jeden test wyczucia czasu na składnik.",
                        advanced = "Pełny montaż urządzenia dla receptur z profilem urządzenia; w pozostałych dwa precyzyjne testy wyczucia czasu na składnik.",
                    },
                    description = "Prosty: pięciosekundowy pasek postępu. Średni: wybór składników i sprawdzanie czasu. Maksymalny: pełny montaż urządzenia; przepisy bez profilu urządzenia wymagają dwóch precyzyjnych prób czasowych na każdy składnik.",
                    label = "Złożoność tworzenia",
                    options = {
                        advanced = "Maksymalny stopień trudności",
                        medium = "Średny stopień trudności",
                        simple = "Prosty",
                    },
                },
                heistInactivityTimeoutMinutes = {
                    description = "Po pierwszej interakcji każda kolejna akcja napadu resetuje ten licznik. Wygaśnięcie kończy próbę i usuwa jej obiekty ze świata. Dotyczy nowych prób.",
                    label = "Limit nieaktywności napadu (minuty)",
                },
                heistStartTimeoutMinutes = {
                    description = "Czas po naciśnięciu Start do podjęcia interakcji w celu.",
                    label = "Minuty do pierwszej interakcji podczas napadu",
                },
                moneywashAccount = {
                    options = {
                        bank = "Bank",
                        black_money = "Brudna kasa",
                        money = "Gotówka",
                    },
                },
                moneywashDirtyAccount = {
                    description = "Konto, z którego pobierane są brudne pieniądze gracza po rozpoczęciu cyklu prania.",
                    label = "Konto depozytowe",
                },
                moneywashDrawDistance = {
                    description = "Maksymalna odległość w metrach, przy której wyświetlane są wejścia do firm i sklepy.",
                    label = "Dystans wyświetlania",
                },
                moneywashEnabled = {
                    description = "Umożliwia dostęp do biznesów zajmujących się praniem pieniędzy należących do organizacji.",
                    label = "Włącz pranie pieniędzy",
                },
                moneywashFeePercent = {
                    description = "Procent odliczany od każdej partii przed wypłatą do organizacji.",
                    label = "Opłata serwisowa (%)",
                },
                moneywashInteractionDistance = {
                    description = "Maksymalna odległość w metrach do korzystania z wejść do biznesów i sklepów.",
                    label = "Dystans interakcji",
                },
                npcPoliceAccuracy = {
                    description = "Celność oficerów NPC od 0 do 100.",
                    label = "Celność strzelania",
                },
                npcPoliceArmour = {
                    description = "Wartość pancerza każdego funkcjonariusza NPC od 0 do 100.",
                    label = "Kamizelka kuloodporna",
                },
                npcPoliceAtms = {
                    description = "Wysyła wsparcie policyjne NPC, gdy zostanie uruchomiony alarm napadu na bankomat.",
                    label = "Wsparcie podczas napadów na bankomaty",
                },
                npcPoliceDurationSeconds = {
                    description = "Maksymalny czas, przez który funkcjonariusze NPC pozostają na miejscu po pojawieniu się (30–900 sekund).",
                    label = "Czas trwania rozmieszczenia (sekundy)",
                },
                npcPoliceEnabled = {
                    description = "Wysyła uzbrojonych funkcjonariuszy NPC, gdy zostanie wywołany alarm napadu. Domyślnie wyłączone.",
                    label = "Włącz wsparcie policji NPC",
                },
                npcPoliceHeists = {
                    description = "Wysyła wsparcie policji NPC po uruchomieniu alarmu podczas napadu.",
                    label = "Wsparcie podczas napadów",
                },
                npcPoliceOfficerCount = {
                    description = "Liczba uzbrojonych funkcjonariuszy NPC wysyłanych na jeden alarm o napadzie (1–8).",
                    label = "Liczba funkcjonariuszy na interwencję",
                },
                npcPoliceResponseDelaySeconds = {
                    description = "Czas między alarmem z napadu a przybyciem funkcjonariuszy NPC (0–300 sekund).",
                    label = "Opóźnienie reakcji (sekundy)",
                },
                npcPoliceShops = {
                    description = "Wysyła wsparcie policyjne NPC, gdy zostanie uruchomiony alarm podczas napadu na sklep.",
                    label = "Wsparcie podczas napadów na sklepy",
                },
                npcPoliceSpawnDistance = {
                    description = "Docelowa odległość od miejsca napadu, na której pojawiają się oficerowie NPC (15–150 metrów).",
                    label = "Dystans spawnu (metry)",
                },
                npcPoliceWeapon = {
                    description = "Broń używana przez każdego wysłanego funkcjonariusza NPC. Domyślnie jest to pistolet.",
                    label = "Broń służbowa",
                    options = {
                        WEAPON_CARBINERIFLE = "Karabin",
                        WEAPON_PISTOL = "Pistolet",
                        WEAPON_PUMPSHOTGUN = "Strzelba pump-action",
                    },
                },
                openHeistCreator = {
                    buttonLabel = "Otwórz Twórcę napadów",
                    description = "Otwórz Heist Creator i zamknij Job Configurator.",
                    label = "Twórca napadów",
                    unsavedTooltip = "Najpierw zapisz zmiany",
                },
                pickpocketAggressionChance = {
                    description = "Niezależna szansa na to, że NPC zaatakuje po nieudanej, anulowanej lub wygasłej próbie.",
                    label = "Szansa na kontratak (%)",
                },
                pickpocketAlertChance = {
                    description = "Niezależna szansa na to, że NPC zgłosi nieudaną, anulowaną lub wygasłą próbę.",
                    label = "Szansa na wezwanie alarmowe (%)",
                },
                pickpocketDifficulty = {
                    description = "Kontroluje prędkość kursora, szybkość zmniejsania się celu, długość sekwencji i tolerowane błędy.",
                    label = "Trudności",
                    options = {
                        easy = "Łatwy",
                        expert = "Ekspert",
                        hard = "Trudny",
                        normal = "Normalna",
                    },
                },
                pickpocketDispatchAlways = {
                    description = "Zgłaszaj każdą rozpoczętą próbę kradzieży kieszonkowej raz, także udaną, niezależnie od szansy na telefon alarmowy.",
                    label = "Zawsze wysyłaj zgłoszenie",
                },
                pickpocketDispatchDurationSeconds = {
                    description = "Liczba sekund, przez które zgłoszenie jest istotne dla odbiorców w dyspozytorni.",
                    label = "Czas trwania dyspozytorni",
                },
                pickpocketDispatchJobs = {
                    description = "Nazwy zawodów oddzielone przecinkami, które otrzymują wezwania alarmowe.",
                    label = "Zlecenia dyspozytorskie",
                },
                pickpocketDispatchPriority = {
                    description = "Priorytet przekazywany bez zmian do integracji dyspozytorskiej.",
                    label = "Priorytet dyspozytorni",
                },
                pickpocketDispatchRadius = {
                    description = "Przybliżony promień alarmu wysyłany do integracji dyspozytorskiej.",
                    label = "Promień dyspozytorni",
                },
                pickpocketEmptyChance = {
                    description = "Szansa na to, że NPC nie posiada żadnego wybranego łupu.",
                    label = "Szansa na puste kieszenie (%)",
                },
                pickpocketEnabled = {
                    description = "Pozwala graczom próbować kieszonkować kwalifikujących się, losowych NPC w sieci.",
                    label = "Włącz kieszonkowstwo NPC",
                },
                pickpocketFleeChance = {
                    description = "Niezależna szansa na to, że NPC ucieknie po nieudanej, anulowanej lub wygasłej próbie.",
                    label = "Szansa na ucieczkę NPC (%)",
                },
                pickpocketInteractionDistance = {
                    description = "Maksymalny zasięg klienta; serwer weryfikuje z niewielzym marginesem synchronizacji.",
                    label = "Dystans interakcji",
                },
                pickpocketItems = {
                    description = "Każdy wiersz kontroluje szansę na jego pojawienie się. Cztery miejsca po przecinku obsługują 0.0001 procent.",
                    itemLabel = "Szansa na przedmiot",
                    label = "Łup z przedmiotu",
                },
                pickpocketItemsEnabled = {
                    description = "Rzuca również skonfigurowane przedmioty do widocznej zawartości kieszeni.",
                    label = "Włącz łupienie przedmiotów",
                },
                pickpocketMaximumLootChoices = {
                    description = "Maksymalna liczba generowanych przez serwer slotów gotówki lub przedmiotów wyświetlanych dla jednego NPC.",
                    label = "Maksymalna widoczna ilość łupu",
                },
                pickpocketMinigame = {
                    description = "Wybierz jedno wyzwanie lub losuj między wszystkimi trzema.",
                    label = "Minigra",
                    options = {
                        pulse = "Impuls ciśnienia",
                        random = "Losowa rotacja",
                        sequence = "Sekwencja kierunków",
                        timing = "Pasek czasu",
                    },
                },
                pickpocketMoneyMaximum = {
                    description = "Najwyższa widoczna kwota gotówki; automatycznie utrzymywana na poziomie równym lub wyższym od minimum.",
                    label = "Maksymalna gotówka",
                },
                pickpocketMoneyMinimum = {
                    description = "Najniższa generowana przez serwer kwota dla widocznego slotu gotówki.",
                    label = "Minimalna gotówka",
                },
                pickpocketRequestCooldownSeconds = {
                    description = "Minimalna liczba sekund między prośbami o rozpoczęcie od jednego gracza.",
                    label = "Czas odnowienia prośby",
                },
                pickpocketRequireCrimeJob = {
                    description = "Włączone: dodaje akcję tylko do zarejestrowanych prac w systemie Crime. Wyłączone: usuwa wbudowaną akcję z menu kołowego i wymaga eksportu serwera.",
                    label = "Użyj menu kołowego Crime-job",
                },
                pickpocketRequiredHits = {
                    description = "Wartość bazowa dla każdej minigry. Cenne gotówkę zwiększa ją stopniowo; ekstremalnie rzadkie przedmioty wymagają co najmniej ośmiu trafień.",
                    label = "Minimalna liczba trafień",
                },
                pickpocketSessionTimeoutSeconds = {
                    description = "Liczba sekund przed wygaśnięciem nieukończonego wyzwania serwerowego.",
                    label = "Timeout sesji",
                },
                pickpocketTargetCooldownMinutes = {
                    description = "Blokada po anulowanych lub nieudanych próbach; skutecznie opróżnieni NPC pozostają niedostępni.",
                    label = "Czas odnowienia NPC",
                },
                pvpAdminAce = {
                    description = "Obiekt ACE przyznający dostęp do globalnego zarządzania wydarzeniami PvP.",
                    label = "Uprawnienie ACE administratora",
                },
                pvpArenaReturnSeconds = {
                    description = "Domyślny czas powrotu dla nowych wydarzeń. Liderzy wydarzeń mogą go nadpisać w tablecie.",
                    label = "Czas powrotu do areny",
                },
                pvpArenaWarningPosition = {
                    description = "Określa, gdzie pojawia się ostrzeżenie o powrocie do areny.",
                    label = "Pozycja ostrzeżenia areny",
                    options = {
                        bottom_center = "Dół, środek",
                        bottom_left = "Dół, lewa strona",
                        bottom_right = "Dół, prawa strona",
                        middle_center = "Środek ekranu",
                        middle_left = "Środek, lewa strona",
                        middle_right = "Środek, prawa strona",
                        top_center = "Góra, środek",
                        top_left = "Góra, lewa strona",
                        top_right = "Góra, prawa strona",
                    },
                },
                pvpArenas = {
                    description = "Tworzy koliste strefy walki z punktem obserwacyjnym i co najmniej dwoma punktami odrodzenia drużyn.",
                    itemLabel = "Arena",
                    label = "Areny PvP",
                },
                pvpCountdownPosition = {
                    description = "Określa, gdzie wyświetlane jest odliczanie do rozpoczęcia meczu.",
                    label = "Pozycja odliczania",
                    options = {
                        bottom_center = "Dół, środek",
                        bottom_left = "Dół, lewa strona",
                        bottom_right = "Dół, prawa strona",
                        middle_center = "Środek ekranu",
                        middle_left = "Środek, lewa strona",
                        middle_right = "Środek, prawa strona",
                        top_center = "Góra, środek",
                        top_left = "Góra, lewa strona",
                        top_right = "Góra, prawa strona",
                    },
                },
                pvpDefaultMode = {
                    description = "Tryb gry wstępnie wybrany dla nowych wydarzeń.",
                    label = "Domyślny tryb gry",
                    options = {
                        free_for_all = "Każdy na każdego",
                        last_man_standing = "Ostatni żyjący",
                        team_deathmatch = "Zespół Deathmatch",
                    },
                },
                pvpDefaultScoreLimit = {
                    description = "Domyślna liczba zabójstw wymagana do wygrania Team Deathmatch lub Free For All.",
                    label = "Domyślny cel zabójstwa",
                },
                pvpEventsEnabled = {
                    description = "Udostępnia aplikację tabletu PvP frakcji oraz czas trwania wydarzenia.",
                    label = "Włącz wydarzenia PvP frakcji",
                },
                pvpKillfeedPosition = {
                    description = "Określa, gdzie wyświetlane są ostatnie eliminacje.",
                    label = "Pozycja Killfeedu",
                    options = {
                        bottom_center = "Dół, środek",
                        bottom_left = "Dół, lewa strona",
                        bottom_right = "Dół, prawa strona",
                        middle_center = "Środek ekranu",
                        middle_left = "Środek, lewa strona",
                        middle_right = "Środek, prawa strona",
                        top_center = "Góra, środek",
                        top_left = "Góra, lewa strona",
                        top_right = "Góra, prawa strona",
                    },
                },
                pvpLeaderPermission = {
                    description = "Wymagane uprawnienia pracy do tworzenia, rejestrowania, rozpoczynania i zarządzania wydarzeniami frakcji.",
                    label = "Uprawnienia lidera frakcji",
                },
                pvpMatchDurationMinutes = {
                    description = "Domyślny czas trwania w minutach dla nowych wydarzeń. Wartość zero wyłącza limit czasu.",
                    label = "Czas trwania meczu",
                },
                pvpMaxHistory = {
                    description = "Maksymalna liczba zakończonych lub anulowanych zdarzeń przesyłanych do tabletu.",
                    label = "Widoczna historia zdarzeń",
                },
                pvpMaxRewards = {
                    description = "Maksymalna liczba połączonych nagród w postaci przedmiotów, broni, pojazdów lub pieniędzy na jedno wydarzenie.",
                    label = "Maksymalna liczba dodatkowych nagród",
                },
                pvpMoneyPermission = {
                    description = "Wymagane uprawnienia pracy dla opłat wstępnych i nagród pieniężnych.",
                    label = "Uprawnienia finansowe frakcji",
                },
                pvpRequestCooldownMs = {
                    description = "Minimalna liczba milisekund między kolejnymi prośbami PvP od jednego gracza.",
                    label = "Czas odnowienia akcji",
                },
                pvpRespawnDelaySeconds = {
                    description = "Sekundy przed odrodzeniem gracza lub przeniesieniem do strefy obserwatora po śmierci.",
                    label = "Opóźnienie odrodzenia",
                },
                pvpSchedulePollSeconds = {
                    description = "Liczba sekund między sprawdzaniem powtarzalnych szablonów a automatycznym startem.",
                    label = "Interwał sprawdzania harmonogramu",
                },
                pvpScoreboardPosition = {
                    description = "Określa, gdzie podczas meczów frakcyjnych wyświetlana jest kompaktowa tablica wyników na żywo.",
                    label = "Pozycja na tablicy wyników",
                    options = {
                        bottom_center = "Dół, środek",
                        bottom_left = "Dół, lewa strona",
                        bottom_right = "Dół, prawa strona",
                        middle_center = "Środek ekranu",
                        middle_left = "Środek, lewa strona",
                        middle_right = "Środek, prawa strona",
                        top_center = "Góra, środek",
                        top_left = "Góra, lewa strona",
                        top_right = "Góra, prawa strona",
                    },
                },
                pvpSoloTestingEnabled = {
                    description = "Pozwala administratorom PvP na rejestrację i ręczne rozpoczęcie z jednym członkiem frakcji. Wyłącz to na serwerach produkcyjnych.",
                    label = "Włącz testy solo dla administratorów",
                },
                pvpStartCountdownSeconds = {
                    description = "Domyślne odliczanie dla nowo utworzonych zdarzeń. Liderzy zdarzeń mogą je nadpisać w tablecie.",
                    label = "Start odliczania",
                },
                pvpTabletOrder = {
                    description = "Określa, gdzie na tablecie wyświetla się aplikacja PvP frakcji.",
                    label = "Kolejność aplikacji na tablecie",
                },
                shopActiveTimeoutMinutes = {
                    description = "Minuty, po których porzucony napad kończy się niepowodzeniem.",
                    label = "Limit czasu aktywności",
                },
                shopConsumeDrill = {
                    description = "Zużyj wiertarkę po skutecznym otwarciu.",
                    label = "Zużyj wiertarkę",
                },
                shopConsumeHackItem = {
                    description = "Zużyj przedmiot do hakowania po skutecznym otwarciu sejfu.",
                    label = "Zużyj przedmiot do hakowania",
                },
                shopCooldownMinutes = {
                    description = "Liczba minut czasu pracy przed resetem sklepu.",
                    label = "Czas odnowienia sklepu",
                },
                shopDispatchAlways = {
                    description = "Zgłaszaj każdy napad na sklep raz przy rozpoczęciu, także przy nieprzerwanym zastraszaniu i w sklepach bez wymaganego sprzedawcy.",
                    label = "Zawsze wysyłaj zgłoszenie",
                },
                shopDispatchDurationSeconds = {
                    description = "Liczba sekund, przez które alarm pozostaje istotny.",
                    label = "Czas trwania dyspozytorni",
                },
                shopDispatchJobs = {
                    description = "Prace (joby) odbiorców alertów, oddzielone przecinkami.",
                    label = "Zlecenia dyspozytorskie",
                },
                shopDispatchPriority = {
                    description = "Priorytet przekazywany dyspozytorowi.",
                    label = "Priorytet dyspozytorni",
                },
                shopDispatchRadius = {
                    description = "Przybliżony promień alarmu policji.",
                    label = "Promień dyspozytorni",
                },
                shopDrillDurationSeconds = {
                    description = "Liczba sekund wymagana do wywiercenia sejfu.",
                    label = "Czas wiercenia sejfu",
                },
                shopDrillItem = {
                    description = "Identyfikator przedmiotu w ekwipunku potrzebnego do wiercenia w sejfach sklepowych. Ustawienie niezależne od wiertarki do bankomatów.",
                    label = "Przedmiot: wiertarka",
                },
                shopDrillItemAmount = {
                    description = "Liczba wymaganych przedmiotów wiertarek.",
                    label = "Wymagana ilość wiertarek",
                },
                shopEnabled = {
                    description = "Włącza napady w skonfigurowanych sklepach z obsługą.",
                    label = "Włącz napady na sklepy",
                },
                shopHackItem = {
                    description = "Przedmiot wymagany do minigry hakowania sejfu. Metodę otwierania należy włączyć oddzielnie dla każdego sklepu.",
                    label = "Przedmiot do hackowania",
                },
                shopHackItemAmount = {
                    description = "Wymagana ilość przedmiotu do hakowania.",
                    label = "Ilość przedmiotu do hakowania",
                },
                shopIntimidationSeconds = {
                    description = "Liczba sekund, przez które sprzedawca musi znajdować się pod bronią.",
                    label = "Czas trwania zastraszania",
                },
                shopLocations = {
                    description = "Jeden pracownik, jedna kasa i opcjonalny sejf w każdym sklepie.",
                    itemLabel = "Sklep",
                    label = "Lokalizacje sklepów",
                },
                shopMinimumPolice = {
                    description = "Liczba członków grupy policyjnej na służbie wymagana do rozpoczęcia.",
                    label = "Minimalna liczba policji",
                },
                shopPoliceGroup = {
                    description = "Grupa zawodowa liczona dla wymogów policji.",
                    label = "Grupa zawodowa policji",
                },
                shopRegisterDurationSeconds = {
                    description = "Liczba sekund wymagana do opróżnienia kasy.",
                    label = "Czas opróżniania kasy",
                },
                shopRegisterRewardMaximum = {
                    description = "Najwyższa wypłata z kasy.",
                    label = "Maksymalna nagroda z kasy",
                },
                shopRegisterRewardMinimum = {
                    description = "Najniższa wypłata z kasy.",
                    label = "Minimalna nagroda z kasy",
                },
                shopRegisterRewardName = {
                    description = "Opcjonalna nazwa przedmiotu lub konta.",
                    label = "Nazwa nagrody z kasy",
                },
                shopRegisterRewardSort = {
                    description = "Wybierz gotówkę lub przedmiot black_money.",
                    label = "Typ wypłaty z kasy",
                },
                shopRegisters = {
                    description = "Pozycje kas przypisane według ID sklepu.",
                    itemLabel = "Kasa",
                    label = "Kasy rejestrujące",
                },
                shopSafeLootDurationSeconds = {
                    description = "Liczba sekund wymagana na zabranie gotówki po wpisaniu poprawnego kodu sejfu.",
                    label = "Czas trwania łupienia sejfu",
                },
                shopSafeRewardMaximum = {
                    description = "Najwyższa wypłata z sejfu.",
                    label = "Maksymalna bezpieczna nagroda",
                },
                shopSafeRewardMinimum = {
                    description = "Najniższa wypłata z sejfu.",
                    label = "Minimalna bezpieczna nagroda",
                },
                shopSafeRewardName = {
                    description = "Opcjonalna nazwa przedmiotu lub konta.",
                    label = "Nazwa nagrody z sejfu",
                },
                shopSafeRewardSort = {
                    description = "Wybierz gotówkę lub przedmiot black_money.",
                    label = "Typ wypłaty z sejfu",
                },
                shopThreatGraceSeconds = {
                    description = "Dozwolone przerwanie przed alarmem.",
                    label = "Czas tolerancji celowania",
                },
                territoryDrugSalesEnabled = {
                    description = "Udane sprzedaże uliczne dla NPC przyznają wpływy gangowi sprzedawcy w aktualnym terytorium ulicznym.",
                    label = "Sprzedaż NPC daje wpływy terytorialne",
                },
                atmLocationMode = {
                    label = "Tryb lokalizacji bankomatów",
                    description = "Automatycznie wykrywa obsługiwane obiekty świata lub używa wyłącznie ręcznie skonfigurowanych lokalizacji.",
                    options = {
                        automatic = "Automatyczny",
                        manual = "Ręczny",
                    },
                },
                atmPoliceRequirementEnabled = {
                    label = "Wymagaj policjantów na służbie",
                    description = "Wymaga ustawionej liczby policjantów na służbie przed rozpoczęciem napadu na bankomat.",
                },
                openDrugCreator = {
                    label = "Edytor narkotyków",
                    description = "Otwiera edytor narkotyków Sky Crime i zamyka konfigurator pracy.",
                    buttonLabel = "Otwórz edytor narkotyków",
                    unsavedTooltip = "Najpierw zapisz",
                },
                drugCreatorRuntimeDensity = {
                    label = "Gęstość panelu działania",
                    description = "Określa zwartość panelu działania w edytorze narkotyków.",
                    options = {
                        comfortable = "Wygodny",
                        compact = "Kompaktowy",
                    },
                },
                drugCreatorListDensity = {
                    label = "Gęstość listy",
                    description = "Określa zwartość listy wpisów w edytorze.",
                    options = {
                        comfortable = "Wygodny",
                        compact = "Kompaktowy",
                    },
                },
                drugCreatorShowEmptyRuntimeLists = {
                    label = "Pokazuj puste listy działania",
                    description = "Pokazuje sekcje panelu działania nawet bez wpisów.",
                },
                drugCreatorHideDisabledEntries = {
                    label = "Ukrywaj wyłączone wpisy",
                    description = "Ukrywa wyłączone wpisy modułów na liście edytora narkotyków.",
                },
                drugCreatorAutoGenerateId = {
                    label = "Automatycznie generuj ID",
                    description = "Generuje identyfikatory z nazw podczas tworzenia wpisów w edytorze narkotyków.",
                },
                drugCreatorOpenEditorOnModuleChange = {
                    label = "Otwieraj edytor przy zmianie modułu",
                    description = "Automatycznie otwiera edytor po zmianie aktywnego modułu.",
                },
                drugCreatorSmartDuplicateSuffix = {
                    label = "Automatyczny przyrostek kopii",
                    description = "Dodaje automatyczny przyrostek podczas powielania wpisów w edytorze narkotyków.",
                },
                drugCreatorAutoSelectRuntimeTargets = {
                    label = "Automatycznie wybieraj cele w grze",
                    description = "Automatycznie wybiera wstępnie dostępne laboratoria i partie.",
                },
                drugCreatorAttentionOnOpen = {
                    label = "Skup się na problemach przy otwarciu",
                    description = "Otwiera panel działania z naciskiem na wpisy wymagające uwagi.",
                },
                drugActivityHudPosition = {
                    label = "Pozycja HUD aktywności",
                    description = "Przeciągnij HUD rozmieszczania i zbioru w wybrane miejsce ekranu.",
                },
                drugInteractionHudPosition = {
                    label = "Pozycja HUD interakcji",
                    description = "Przeciągnij HUD interakcji z roślinami, laboratoriami i kamperami w wybrane miejsce.",
                },
                drugPlantStatusHudPosition = {
                    label = "Pozycja HUD stanu rośliny",
                    description = "Przeciągnij szczegółowy HUD stanu rośliny w wybrane miejsce ekranu.",
                },
                drugSystemEnabled = {
                    label = "System narkotyków",
                    description = "Włącza: produkcja narkotyków, dane edytora i interfejsy gry dla tej pracy przestępczej.",
                },
                drugCreatorAccess = {
                    label = "Dostęp do edytora narkotyków",
                    description = "Określa, kto może otworzyć zaawansowany edytor narkotyków.",
                    options = {
                        permission = "Tylko z uprawnieniem",
                        job_management = "Zarządzanie pracą",
                        owner_only = "Tylko właściciel",
                    },
                },
                drugRuntimeEnabled = {
                    label = "Interfejsy działania",
                    description = "Pozwala graczom korzystać w grze z działań laboratoriów, roślin, przetwarzania i rynku.",
                },
                drugRuntimePlayerCreateLabs = {
                    label = "Tworzenie laboratoriów przez graczy",
                    description = "Pozwala graczom z dostępem do systemu tworzyć laboratoria z szablonów edytora bez uprawnień administratora.",
                },
                drugRuntimeOutdoorPlanting = {
                    label = "Uprawa na zewnątrz",
                    description = "Pozwala graczom uprawiać własne rośliny na zewnątrz skonfigurowanych laboratoriów.",
                },
                drugRuntimePublicOutdoorHarvest = {
                    label = "Zbiory plenerowe przez innych graczy",
                    description = "Pozwala innym graczom zbierać rośliny na zewnątrz, których sami nie posadzili.",
                },
                drugRuntimeChargeLabPurchase = {
                    label = "Pobieraj opłatę za zakup laboratorium",
                    description = "Pobiera od graczy skonfigurowaną cenę przy tworzeniu laboratorium.",
                },
                drugRuntimeStrictInventory = {
                    label = "Ściśle sprawdzaj operacje ekwipunku",
                    description = "Akcje są kontynuowane tylko po pomyślnym wykonaniu skonfigurowanych operacji na przedmiotach, narzędziach i pieniądzach.",
                },
                drugRuntimeSalePayouts = {
                    label = "Sprzedaż / Wypłaty",
                    description = "Wypłaca graczom pieniądze za partie lub trasy sprzedane przez system rynku.",
                },
                drugRuntimeSalePayoutAccount = {
                    label = "Wypłata / Konto",
                    description = "Konto wypłat ze sprzedaży narkotyków, np. black_money.",
                },
                drugRuntimeDispatchEnabled = {
                    label = "Załatwić / Alarmy",
                    description = "Przekazuje zdarzenia ryzyka narkotykowego do dyspozytorni i skonfigurowanych służb policji.",
                },
                drugRuntimeNotifyPoliceJobs = {
                    label = "Policja / Powiadomienia",
                    description = "Powiadamia skonfigurowane służby policji, gdy zdarzenie ryzyka narkotykowego wywoła alarm.",
                },
                drugBatchPrefix = {
                    label = "Partia / Prefiks",
                    description = "Prefiks identyfikatorów nowo tworzonych partii narkotyków.",
                },
                drugTestingKitAccuracy = {
                    label = "Zestaw do testowania / Dokładność",
                    description = "Dopuszczalna odchyłka ukrytych wartości w podstawowym zestawie testowym.",
                },
                drugDecayIntervalMinutes = {
                    label = "Degradacja / Interwał",
                    description = "Interwał w minutach: kontrole spadku świeżości i zanieczyszczenia.",
                },
                drugDefaultPackaging = {
                    label = "Wartość domyślna / Opakowanie",
                    description = "Opakowanie surowych lub przetworzonych partii tworzonych bez określonego typu opakowania.",
                    options = {
                        loose = "Luzem",
                        baggy = "Woreczek",
                        jar = "Słoik",
                        vacuum = "Worek próżniowy",
                        brick = "Opakowanie bloku",
                        premium_seal = "Plomba premium",
                    },
                },
                drugQualityWeightQuality = {
                    label = "Jakość / Waga",
                    description = "Wpływ na jakość końcową: Jakość bazowa.",
                },
                drugQualityWeightPurity = {
                    label = "Czystość / Waga",
                    description = "Wpływ na jakość końcową: Czystość.",
                },
                drugQualityWeightFreshness = {
                    label = "Świeżość / Waga",
                    description = "Wpływ na jakość końcową: Świeżość.",
                },
                drugQualityWeightPotency = {
                    label = "Moc / Waga",
                    description = "Wpływ na jakość końcową: Moc.",
                },
                drugQualityWeightStability = {
                    label = "Stabilność / Waga",
                    description = "Wpływ na jakość końcową: Stabilność.",
                },
                drugQualityWeightContamination = {
                    label = "Zanieczyszczenie / Kara",
                    description = "Kara do oceny jakości zanieczyszczonych produktów.",
                },
                drugTierGoodMin = {
                    label = "Dobre / Poziom / Minimum",
                    description = "Minimalny wynik dla poziomu jakości: Dobre.",
                },
                drugTierPremiumMin = {
                    label = "Premium / Poziom / Minimum",
                    description = "Minimalny wynik dla poziomu jakości: Premium.",
                },
                drugTierTopShelfMin = {
                    label = "Najwyższa jakość / Poziom / Minimum",
                    description = "Minimalny wynik dla poziomu jakości: Najwyższa jakość.",
                },
                drugTierLabGradeMin = {
                    label = "Jakość laboratoryjna / Poziom / Minimum",
                    description = "Minimalny wynik dla poziomu jakości: Jakość laboratoryjna.",
                },
                drugBaggyDecayMultiplier = {
                    label = "Woreczek / Degradacja",
                    description = "Mnożnik: utrata świeżości / Woreczki.",
                },
                drugJarDecayMultiplier = {
                    label = "Słoik / Degradacja",
                    description = "Mnożnik: utrata świeżości / Słoiki.",
                },
                drugVacuumDecayMultiplier = {
                    label = "Próżnia / Degradacja",
                    description = "Mnożnik: utrata świeżości / Worki próżniowe.",
                },
                drugPremiumSealPriceMultiplier = {
                    label = "Plomba premium / Cena",
                    description = "Mnożnik: Premium / Zaplombowany produkt / Cena.",
                },
                drugGrowingEnabled = {
                    label = "Uprawa / Włączone",
                    description = "Włącza: wzrost roślin i zbiory.",
                },
                drugEnvironmentSurveyEnabled = {
                    label = "Kontrola miejsca uprawy",
                    description = "Po włączeniu swobodnie posadzone rośliny czekają na automatyczną kontrolę miejsca przez administratora. Wyłącz, aby umożliwić wzrost bez zgody administratora.",
                },
                drugGrowthTickMinutes = {
                    label = "Wzrost / Cykl aktualizacji / Minuty",
                    description = "Interwał w minutach: aktualizacje wzrostu roślin.",
                },
                drugBaseGrowthPerTick = {
                    label = "Wartość bazowa / Wzrost / Na cykl aktualizacji",
                    description = "Bazowy wzrost przed modyfikatorami odmiany, sprzętu i pielęgnacji.",
                },
                drugWildPlantRespawnMinutes = {
                    label = "Roślina dzika / Odrodzenie",
                    description = "Czas oczekiwania w minutach na: Roślina dzika / Odrodzenie.",
                },
                drugWildPlantHighlightEnabled = {
                    label = "Wyróżniaj dzikie rośliny",
                    description = "Wyświetla obrys wygenerowanych dzikich roślin, gdy gracz znajduje się w promieniu wyróżnienia.",
                },
                drugWildPlantHighlightDistance = {
                    label = "Promień wyróżnienia dzikich roślin",
                    description = "Odległość w metrach wokół każdej wygenerowanej dzikiej rośliny, w której jej obrys staje się widoczny.",
                },
                drugDefaultPlantWater = {
                    label = "Wartość domyślna / Woda",
                    description = "Wartość początkowa przy tworzeniu rośliny: Woda.",
                },
                drugDefaultPlantFertilizer = {
                    label = "Wartość domyślna / Nawóz",
                    description = "Wartość początkowa przy tworzeniu rośliny: Nawóz.",
                },
                drugDefaultPlantHealth = {
                    label = "Wartość domyślna / Zdrowie",
                    description = "Wartość początkowa przy tworzeniu rośliny: Zdrowie.",
                },
                drugDefaultPlantMutationChance = {
                    label = "Wartość domyślna / Szansa na mutację",
                    description = "Bazowe prawdopodobieństwo mutacji, gdy odmiana nie określa własnej wartości.",
                },
                drugHarvestPerfectStart = {
                    label = "Początek optymalnego zbioru",
                    description = "Procent wzrostu dla optymalnego okna zbiorów: Początek.",
                },
                drugHarvestPerfectEnd = {
                    label = "Koniec optymalnego zbioru",
                    description = "Procent wzrostu dla optymalnego okna zbiorów: Koniec.",
                },
                drugLabsEnabled = {
                    label = "Laboratoria / Włączone",
                    description = "Włącza: laboratoria i kampery w grze.",
                },
                drugMaxLaboratoriesPerCharacter = {
                    label = "Laboratoria na postać",
                    description = "Maksymalna liczba kupionych lub wynajętych stałych laboratoriów na właściciela. 0 oznacza brak limitu; kampery i współdzielony dostęp nie są liczone.",
                },
                drugMaxLaboratoriesPerFaction = {
                    label = "Laboratoria na frakcję",
                    description = "Maksymalna liczba kupionych lub wynajętych stałych laboratoriów na właściciela. 0 oznacza brak limitu; kampery i współdzielony dostęp nie są liczone.",
                },
                drugDefaultRentDays = {
                    label = "Wartość domyślna / Dni najmu",
                    description = "Wartość domyślna: Laboratorium / Czynsz / Czas trwania.",
                },
                drugCamperHotVehicleMinutes = {
                    label = "Skradziony kamper / Minuty",
                    description = "Czas podwyższonego ryzyka dla skradzionych kamperów.",
                },
                drugLabRentWarningHours = {
                    label = "Czynsz / Ostrzeżenie / Godziny",
                    description = "Liczba godzin przed wygaśnięciem najmu laboratorium, od której wyświetlane jest ostrzeżenie.",
                },
                drugLabRentExpiredHeatGain = {
                    label = "Wygasły najem / Presja policji",
                    description = "Dodatkowe zainteresowanie policji po wygaśnięciu najmu laboratorium.",
                },
                drugCamperMoveCooldownMinutes = {
                    label = "Kamper / Przenieś / Czas odnowienia",
                    description = "Czas oczekiwania w minutach na: Kamper / Laboratorium / Ponowne przeniesienie.",
                },
                drugLabUpgradeCostMultiplier = {
                    label = "Ulepszenie / Koszt / Mnożnik",
                    description = "Mnożnik: Laboratorium / Poziom / Ulepszenie / Ceny.",
                },
                drugCamperBaseSlots = {
                    label = "Kamper / Sloty",
                    description = "Wartość domyślna: laboratoria w kamperach / miejsca na wyposażenie.",
                },
                drugCamperBaseStorage = {
                    label = "Kamper / Magazyn",
                    description = "Wartość domyślna: laboratoria w kamperach / Pojemność magazynu.",
                },
                drugCamperBasePower = {
                    label = "Kamper / Energia",
                    description = "Wartość domyślna: laboratoria w kamperach / Wbudowane zasilanie.",
                },
                drugBasementBaseSlots = {
                    label = "Piwnica / Sloty",
                    description = "Wartość domyślna: laboratoria piwniczne / miejsca na wyposażenie.",
                },
                drugBasementBaseStorage = {
                    label = "Piwnica / Magazyn",
                    description = "Wartość domyślna: laboratoria piwniczne / Pojemność magazynu.",
                },
                drugWarehouseBasePower = {
                    label = "Magazyn / Energia",
                    description = "Wartość domyślna: laboratoria magazynowe / Wbudowane zasilanie.",
                },
                drugPowerEnabled = {
                    label = "Energia / System",
                    description = "Włącza: wytwarzanie energii, zużycie prądu i kontrole przeciążenia laboratorium.",
                },
                drugOverloadGraceSeconds = {
                    label = "Przeciążenie / Okres karencji",
                    description = "Liczba sekund, po której przeciążenie zasilania staje się niebezpieczne.",
                },
                drugHeatPerKilowatt = {
                    label = "Presja policji / Na kilowat",
                    description = "Zainteresowanie policji laboratorium wywołane zużyciem energii.",
                },
                drugGeneratorT1Watts = {
                    label = "Generator T1 / Waty",
                    description = "Moc generatorów poziomu T1 w watach.",
                },
                drugGeneratorT2Watts = {
                    label = "Generator T2 / Waty",
                    description = "Moc generatorów poziomu T2 w watach.",
                },
                drugGeneratorT3Watts = {
                    label = "Generator T3 / Waty",
                    description = "Moc generatorów poziomu T3 w watach.",
                },
                drugEquipmentConditionWearMultiplier = {
                    label = "Zużycie / Mnożnik",
                    description = "Globalny mnożnik: Zużycie sprzętu / Przetwarzanie.",
                },
                drugWorkersEnabled = {
                    label = "Pracownicy / Włączone",
                    description = "Włącza: chemicy, hodowcy, pakowacze i ochrona w laboratoriach narkotyków.",
                },
                drugMaxWorkersPerLab = {
                    label = "Maksimum / Pracownicy / Laboratorium",
                    description = "Maksymalna liczba pracowników na laboratorium.",
                },
                drugWorkerFatiguePerProcessStep = {
                    label = "Zmęczenie przetwarzaniem",
                    description = "Dodatkowe zmęczenie dla: Pracownicy, po pracy: Etap przetwarzania.",
                },
                drugWorkerFatiguePerGrowAction = {
                    label = "Uprawa / Zmęczenie",
                    description = "Dodatkowe zmęczenie dla: Hodowcy, po pracy: Zbiory lub uprawa.",
                },
                drugWorkerRecoveryPerTick = {
                    label = "Pracownik / Regeneracja",
                    description = "Regeneracja — Zmęczenie, przy każdym kroku: Aktualizacja wzrostu.",
                },
                drugMarketEnabled = {
                    label = "Rynek / Włączone",
                    description = "Włącza: kupcy, dilerzy i sprzedaż partii.",
                },
                drugMarketBasePriceFallback = {
                    label = "Wartość zastępcza / Cena bazowa",
                    description = "Cena bazowa narkotyków bez osobno skonfigurowanej ceny.",
                },
                drugMarketStreetMultiplier = {
                    label = "Ulica / Mnożnik",
                    description = "Globalny mnożnik: Cena / Sprzedaż uliczna.",
                },
                drugMarketWholesaleMultiplier = {
                    label = "Hurtownia / Mnożnik",
                    description = "Globalny mnożnik: Cena / Hurtownia / Transakcje.",
                },
                drugMarketPremiumMultiplier = {
                    label = "Premium / Mnożnik",
                    description = "Globalny mnożnik: Cena / Premium / Kupujący.",
                },
                drugMarketHeatPerSale = {
                    label = "Presja policji / Sprzedaż",
                    description = "Bazowa presja policji dodawana do laboratorium przy sprzedaży partii.",
                },
                drugDistributionTickMinutes = {
                    label = "Dystrybucja / Cykl aktualizacji",
                    description = "Interwał w minutach: aktualizacje dystrybucji dilerów.",
                },
                drugDistributionIntervalMinutes = {
                    label = "Dystrybucja / Interwał",
                    description = "Wartość domyślna: Dystrybutor / Czas oczekiwania przed sprzedażą / Minuty.",
                },
                drugDistributionMaxPerDealer = {
                    label = "Maksimum / Dystrybutor / Zlecenia",
                    description = "Wartość domyślna: Dystrybutor / maksymalna liczba aktywnych zleceń dystrybucji.",
                },
                drugThreatsEnabled = {
                    label = "Groźby / Włączone",
                    description = "Włącza: spadek zainteresowania policji, naloty i sabotaż w laboratoriach.",
                },
                drugThreatTickMinutes = {
                    label = "Zagrożenie / Cykl aktualizacji",
                    description = "Interwał w minutach: spadek zainteresowania policji i kontrole nalotów oraz sabotażu.",
                },
                drugRaidHeatThreshold = {
                    label = "Próg zainteresowania policji dla nalotów",
                    description = "Wymagana presja policji w laboratorium, zanim możliwe będzie: Naloty.",
                },
                drugSabotageHeatThreshold = {
                    label = "Próg zainteresowania policji dla sabotażu",
                    description = "Wymagana presja policji w laboratorium, zanim możliwe będzie: Sabotaż.",
                },
                drugThreatHeatDecay = {
                    label = "Presja policji / Degradacja",
                    description = "Zmniejsza zainteresowanie policji laboratorium o tę wartość przy każdej aktualizacji zagrożeń.",
                },
                drugRaidChanceAtThreshold = {
                    label = "Szansa nalotu",
                    description = "Bazowe prawdopodobieństwo zdarzenia Napad po osiągnięciu odpowiedniego progu presji policji.",
                },
                drugSabotageChanceAtThreshold = {
                    label = "Sabotaż / Szansa",
                    description = "Bazowe prawdopodobieństwo zdarzenia Sabotaż po osiągnięciu odpowiedniego progu presji policji.",
                },
                drugConsumptionEnabled = {
                    label = "Spożycie aktywne",
                    description = "Włącza: efekty narkotyków oraz śledzenie tolerancji i uzależnienia.",
                },
                drugDoseConsumesBatch = {
                    label = "Zużywaj partię przy konsumpcji",
                    description = "Usuwa zużytą partię z aktywnych zapasów.",
                },
                drugToleranceDecayMinutes = {
                    label = "Tolerancja / Degradacja",
                    description = "Interwał w minutach: aktualizacje spadku tolerancji.",
                },
                drugAddictionDecayMinutes = {
                    label = "Uzależnienie / Degradacja",
                    description = "Interwał w minutach: aktualizacje spadku uzależnienia.",
                },
                drugPotencyEffectMultiplier = {
                    label = "Moc / Mnożnik",
                    description = "Określa, jak mocno siła substancji zwiększa intensywność efektów.",
                },
                drugOverdosePotencyThreshold = {
                    label = "Przedawkowanie / Próg",
                    description = "Wymagane obciążenie substancją, zanim system zacznie losować przedawkowanie.",
                },
                drugBaseAddictionGain = {
                    label = "Wartość bazowa / Uzależnienie / zysk",
                    description = "Bazowy przyrost uzależnienia na dawkę.",
                },
                drugProcessingEnabled = {
                    label = "Przetwarzanie / Włączone",
                    description = "Włącza: zlecenia przetwarzania, pakowanie i zestawy testowe.",
                },
                drugBatchMetadataItemKey = {
                    label = "Partia / Metadane / Klucz",
                    description = "Klucz metadanych ekwipunku używany przez integracje do danych partii.",
                },
                drugDefaultProcessDuration = {
                    label = "Domyślny czas przetwarzania",
                    description = "Wartość domyślna: Przetwarzanie / Czas trwania / sekundy / Bez własnej wartości receptury.",
                },
                drugDefaultFailureRisk = {
                    label = "Wartość domyślna / Ryzyko niepowodzenia",
                    description = "Wartość domyślna: Przetwarzanie / Ryzyko niepowodzenia / Bez własnej wartości receptury.",
                },
                drugPackagingDuration = {
                    label = "Czas pakowania",
                    description = "Wartość domyślna: Opakowanie / Czas trwania / sekundy.",
                },
                drugPowerTickSeconds = {
                    label = "Energia / Cykl aktualizacji / sekundy",
                    description = "Interwał w sekundach: aktualizacje zużycia generatorów i sygnatur energetycznych.",
                },
                drugPowerSignatureHeatPerHour = {
                    label = "Sygnatura energetyczna / Presja policji / Godzina",
                    description = "Zainteresowanie policji generowane na godzinę przez sygnaturę energetyczną laboratorium.",
                },
                drugPowerOverloadHeatPerHour = {
                    label = "Przeciążenie / Presja policji / Godzina",
                    description = "Dodatkowa presja policji na godzinę podczas przeciążenia laboratorium.",
                },
                drugPowerIdleHeatDecayPerHour = {
                    label = "Bezczynny / Presja policji / Degradacja / Godzina",
                    description = "Spadek zainteresowania policji na godzinę, gdy laboratorium nie ma aktywnej sygnatury energetycznej.",
                },
                drugPowerModeManualMaxLoadPercent = {
                    label = "Ręczne / Maksimum / Obciążenie",
                    description = "Wartość dla trybu zasilania Ręczne: Maksimum / Obciążenie.",
                },
                drugPowerModeManualHeatMultiplier = {
                    label = "Ręczne / Presja policji / Mnożnik",
                    description = "Wartość dla trybu zasilania Ręczne: Presja policji / Mnożnik.",
                },
                drugPowerModeManualNoiseMultiplier = {
                    label = "Ręczne / Hałas / Mnożnik",
                    description = "Wartość dla trybu zasilania Ręczne: Hałas / Mnożnik.",
                },
                drugPowerModeBalancedMaxLoadPercent = {
                    label = "Zrównoważone / Maksimum / Obciążenie",
                    description = "Wartość dla trybu zasilania Zrównoważone: Maksimum / Obciążenie.",
                },
                drugPowerModeBalancedHeatMultiplier = {
                    label = "Zrównoważone / Presja policji / Mnożnik",
                    description = "Wartość dla trybu zasilania Zrównoważone: Presja policji / Mnożnik.",
                },
                drugPowerModeBalancedNoiseMultiplier = {
                    label = "Zrównoważone / Hałas / Mnożnik",
                    description = "Wartość dla trybu zasilania Zrównoważone: Hałas / Mnożnik.",
                },
                drugPowerModeStealthMaxLoadPercent = {
                    label = "Skradanie / Maksimum / Obciążenie",
                    description = "Wartość dla trybu zasilania Skradanie: Maksimum / Obciążenie.",
                },
                drugPowerModeStealthHeatMultiplier = {
                    label = "Skradanie / Presja policji / Mnożnik",
                    description = "Wartość dla trybu zasilania Skradanie: Presja policji / Mnożnik.",
                },
                drugPowerModeStealthNoiseMultiplier = {
                    label = "Skradanie / Hałas / Mnożnik",
                    description = "Wartość dla trybu zasilania Skradanie: Hałas / Mnożnik.",
                },
                drugPowerPrioritySmellControl = {
                    label = "Kontrola zapachu / Priorytet",
                    description = "Priorytet automatycznego odłączania obciążeń: Kontrola zapachu / Wyposażenie.",
                },
                drugPowerPriorityAirflow = {
                    label = "Wentylacja / Priorytet",
                    description = "Priorytet automatycznego odłączania obciążeń: Wentylacja / Wyposażenie.",
                },
                drugPowerPrioritySecurity = {
                    label = "Bezpieczeństwo / Priorytet",
                    description = "Priorytet automatycznego odłączania obciążeń: Sprzęt zabezpieczający.",
                },
                drugPowerPriorityGrowing = {
                    label = "Uprawa / Priorytet",
                    description = "Priorytet automatycznego odłączania obciążeń: Uprawa / Wyposażenie.",
                },
                drugPowerPriorityLight = {
                    label = "Oświetlenie / Priorytet",
                    description = "Priorytet automatycznego odłączania obciążeń: Oświetlenie / Wyposażenie.",
                },
                drugPowerPriorityTesting = {
                    label = "Badanie / Priorytet",
                    description = "Priorytet automatycznego odłączania obciążeń: Badanie / Wyposażenie.",
                },
                drugPowerPriorityPackaging = {
                    label = "Opakowanie / Priorytet",
                    description = "Priorytet automatycznego odłączania obciążeń: Opakowanie / Wyposażenie.",
                },
                drugPowerPriorityChemistry = {
                    label = "Chemia / Priorytet",
                    description = "Priorytet automatycznego odłączania obciążeń: Chemia / Wyposażenie.",
                },
                drugPowerPriorityHeating = {
                    label = "Ogrzewanie / Priorytet",
                    description = "Priorytet automatycznego odłączania obciążeń: Ogrzewanie / Wyposażenie.",
                },
                drugPowerPriorityPressing = {
                    label = "Prasowanie / Priorytet",
                    description = "Priorytet automatycznego odłączania obciążeń: Prasowanie / Wyposażenie.",
                },
                drugPowerPriorityGeneral = {
                    label = "Ogólne / Priorytet",
                    description = "Priorytet automatycznego odłączania obciążeń: Sprzęt ogólny.",
                },
                drugAdvancedPerformanceInactiveControlIntervalMs = {
                    label = "Osiągi / Nieaktywne / Sterowanie / Interwał / ms",
                    description = "Ustawienie działania dla: Osiągi / Nieaktywne / Sterowanie / Interwał / ms.",
                },
                drugAdvancedPerformanceInteractionIdleScanIntervalMs = {
                    label = "Osiągi / Interakcja / Bezczynny / Interwał skanowania / ms",
                    description = "Ustawienie działania dla: Osiągi / Interakcja / Bezczynny / Interwał skanowania / ms.",
                },
                drugAdvancedPerformanceInteractionPromptIntervalMs = {
                    label = "Osiągi / Interakcja / Komunikat interakcji / Interwał / ms",
                    description = "Ustawienie działania dla: Osiągi / Interakcja / Komunikat interakcji / Interwał / ms.",
                },
                drugAdvancedPerformanceInteractionScanIntervalMs = {
                    label = "Osiągi / Interakcja / Interwał skanowania / ms",
                    description = "Ustawienie działania dla: Osiągi / Interakcja / Interwał skanowania / ms.",
                },
                drugAdvancedPerformanceMinimumScanIntervalMs = {
                    label = "Osiągi / Minimum / Interwał skanowania / ms",
                    description = "Ustawienie działania dla: Osiągi / Minimum / Interwał skanowania / ms.",
                },
                drugAdvancedPerformanceStreetPedActivationDistance = {
                    label = "Osiągi / Ulica / Ped / Aktywacja / Odległość",
                    description = "Ustawienie działania dla: Osiągi / Ulica / Ped / Aktywacja / Odległość.",
                },
                drugAdvancedPerformanceStreetPedIdleScanIntervalMs = {
                    label = "Osiągi / Ulica / Ped / Bezczynny / Interwał skanowania / ms",
                    description = "Ustawienie działania dla: Osiągi / Ulica / Ped / Bezczynny / Interwał skanowania / ms.",
                },
                drugAdvancedPerformanceStreetPedScanIntervalMs = {
                    label = "Osiągi / Ulica / Ped / Interwał skanowania / ms",
                    description = "Ustawienie działania dla: Osiągi / Ulica / Ped / Interwał skanowania / ms.",
                },
                drugAdvancedPerformanceWorldCachePadding = {
                    label = "Osiągi / Świat / Pamięć podręczna / Dodatkowy margines",
                    description = "Ustawienie działania dla: Osiągi / Świat / Pamięć podręczna / Dodatkowy margines.",
                },
                drugAdvancedPerformanceWorldCacheRefreshIntervalMs = {
                    label = "Osiągi / Świat / Pamięć podręczna / Odświeżanie / Interwał / ms",
                    description = "Ustawienie działania dla: Osiągi / Świat / Pamięć podręczna / Odświeżanie / Interwał / ms.",
                },
                drugAdvancedPerformanceWorldIdleIntervalMs = {
                    label = "Osiągi / Świat / Bezczynny / Interwał / ms",
                    description = "Ustawienie działania dla: Osiągi / Świat / Bezczynny / Interwał / ms.",
                },
                drugAdvancedDynamicMarketActionCooldownSeconds = {
                    label = "Dynamiczny Rynek / Czas odnowienia akcji / sekundy",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Czas odnowienia akcji / sekundy.",
                },
                drugAdvancedDynamicMarketActionHistoryLimit = {
                    label = "Dynamiczny Rynek / Działanie / Limit historii",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Działanie / Limit historii.",
                },
                drugAdvancedDynamicMarketAmountSaturationWeight = {
                    label = "Dynamiczny Rynek / Ilość / Nasycenie / Waga",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Ilość / Nasycenie / Waga.",
                },
                drugAdvancedDynamicMarketBaseIntelAccuracy = {
                    label = "Dynamiczny Rynek / Wartość bazowa / Dokładność danych",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wartość bazowa / Dokładność danych.",
                },
                drugAdvancedDynamicMarketDefaultAverageQuality = {
                    label = "Dynamiczny Rynek / Wartość domyślna / Średnia / Jakość",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wartość domyślna / Średnia / Jakość.",
                },
                drugAdvancedDynamicMarketDefaultResourceElasticity = {
                    label = "Dynamiczny Rynek / Wartość domyślna / Surowiec / Elastyczność",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wartość domyślna / Surowiec / Elastyczność.",
                },
                drugAdvancedDynamicMarketDemandCenter = {
                    label = "Dynamiczny Rynek / Popyt / Wartość środkowa",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Popyt / Wartość środkowa.",
                },
                drugAdvancedDynamicMarketDemandPriceImpact = {
                    label = "Dynamiczny Rynek / Popyt / Cena / Wpływ",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Popyt / Cena / Wpływ.",
                },
                drugAdvancedDynamicMarketDirectionThreshold = {
                    label = "Dynamiczny Rynek / Kierunek / Próg",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Kierunek / Próg.",
                },
                drugAdvancedDynamicMarketEnabled = {
                    label = "Dynamiczny Rynek / Włączone",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Włączone.",
                },
                drugAdvancedDynamicMarketEventChance = {
                    label = "Dynamiczny Rynek / Zdarzenie / Szansa",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zdarzenie / Szansa.",
                },
                drugAdvancedDynamicMarketEventDurationMinutes = {
                    label = "Dynamiczny Rynek / Zdarzenie / Czas trwania / Minuty",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zdarzenie / Czas trwania / Minuty.",
                },
                drugAdvancedDynamicMarketEventMinimumDurationMinutes = {
                    label = "Dynamiczny Rynek / Zdarzenie / Minimum / Czas trwania / Minuty",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zdarzenie / Minimum / Czas trwania / Minuty.",
                },
                drugAdvancedDynamicMarketEventStrengthMaximum = {
                    label = "Dynamiczny Rynek / Zdarzenie / Siła / Maksimum",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zdarzenie / Siła / Maksimum.",
                },
                drugAdvancedDynamicMarketEventStrengthMinimum = {
                    label = "Dynamiczny Rynek / Zdarzenie / Siła / Minimum",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zdarzenie / Siła / Minimum.",
                },
                drugAdvancedDynamicMarketEventsCrackdownDemand = {
                    label = "Dynamiczny Rynek / Wydarzenia / Operacja policyjna / Popyt",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Operacja policyjna / Popyt.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPolice = {
                    label = "Dynamiczny Rynek / Wydarzenia / Operacja policyjna / Policja",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Operacja policyjna / Policja.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPrice = {
                    label = "Dynamiczny Rynek / Wydarzenia / Operacja policyjna / Cena",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Operacja policyjna / Cena.",
                },
                drugAdvancedDynamicMarketEventsFestivalDemand = {
                    label = "Dynamiczny Rynek / Wydarzenia / Festiwal / Popyt",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Festiwal / Popyt.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem1 = {
                    label = "Dynamiczny Rynek / Wydarzenia / Festiwal / Efekty / 1",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Festiwal / Efekty / 1.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem2 = {
                    label = "Dynamiczny Rynek / Wydarzenia / Festiwal / Efekty / 2",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Festiwal / Efekty / 2.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem3 = {
                    label = "Dynamiczny Rynek / Wydarzenia / Festiwal / Efekty / 3",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Festiwal / Efekty / 3.",
                },
                drugAdvancedDynamicMarketEventsFestivalPrice = {
                    label = "Dynamiczny Rynek / Wydarzenia / Festiwal / Cena",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Festiwal / Cena.",
                },
                drugAdvancedDynamicMarketEventsFestivalProfilesItem1 = {
                    label = "Dynamiczny Rynek / Wydarzenia / Festiwal / Profile / 1",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Festiwal / Profile / 1.",
                },
                drugAdvancedDynamicMarketEventsGangconflictDemand = {
                    label = "Dynamiczny Rynek / Wydarzenia / Konflikt gangów / Popyt",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Konflikt gangów / Popyt.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPolice = {
                    label = "Dynamiczny Rynek / Wydarzenia / Konflikt gangów / Policja",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Konflikt gangów / Policja.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPrice = {
                    label = "Dynamiczny Rynek / Wydarzenia / Konflikt gangów / Cena",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Konflikt gangów / Cena.",
                },
                drugAdvancedDynamicMarketEventsGangconflictProfilesItem1 = {
                    label = "Dynamiczny Rynek / Wydarzenia / Konflikt gangów / Profile / 1",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Konflikt gangów / Profile / 1.",
                },
                drugAdvancedDynamicMarketEventsLabbustDemand = {
                    label = "Dynamiczny Rynek / Wydarzenia / Nalot na laboratorium / Popyt",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Nalot na laboratorium / Popyt.",
                },
                drugAdvancedDynamicMarketEventsLabbustPolice = {
                    label = "Dynamiczny Rynek / Wydarzenia / Nalot na laboratorium / Policja",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Nalot na laboratorium / Policja.",
                },
                drugAdvancedDynamicMarketEventsLabbustPrice = {
                    label = "Dynamiczny Rynek / Wydarzenia / Nalot na laboratorium / Cena",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Nalot na laboratorium / Cena.",
                },
                drugAdvancedDynamicMarketEventsLabbustSupply = {
                    label = "Dynamiczny Rynek / Wydarzenia / Nalot na laboratorium / Dostawa",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Nalot na laboratorium / Dostawa.",
                },
                drugAdvancedDynamicMarketEventsPartyDemand = {
                    label = "Dynamiczny Rynek / Wydarzenia / Impreza / Popyt",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Impreza / Popyt.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem1 = {
                    label = "Dynamiczny Rynek / Wydarzenia / Impreza / Efekty / 1",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Impreza / Efekty / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem2 = {
                    label = "Dynamiczny Rynek / Wydarzenia / Impreza / Efekty / 2",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Impreza / Efekty / 2.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem3 = {
                    label = "Dynamiczny Rynek / Wydarzenia / Impreza / Efekty / 3",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Impreza / Efekty / 3.",
                },
                drugAdvancedDynamicMarketEventsPartyPrice = {
                    label = "Dynamiczny Rynek / Wydarzenia / Impreza / Cena",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Impreza / Cena.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem1 = {
                    label = "Dynamiczny Rynek / Wydarzenia / Impreza / Profile / 1",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Impreza / Profile / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem2 = {
                    label = "Dynamiczny Rynek / Wydarzenia / Impreza / Profile / 2",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Impreza / Profile / 2.",
                },
                drugAdvancedDynamicMarketEventsShortageDemand = {
                    label = "Dynamiczny Rynek / Wydarzenia / Niedobór / Popyt",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Niedobór / Popyt.",
                },
                drugAdvancedDynamicMarketEventsShortagePrice = {
                    label = "Dynamiczny Rynek / Wydarzenia / Niedobór / Cena",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Niedobór / Cena.",
                },
                drugAdvancedDynamicMarketEventsShortageSupply = {
                    label = "Dynamiczny Rynek / Wydarzenia / Niedobór / Dostawa",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wydarzenia / Niedobór / Dostawa.",
                },
                drugAdvancedDynamicMarketExactIntelReputation = {
                    label = "Dynamiczny Rynek / Dokładne informacje / Reputacja",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Dokładne informacje / Reputacja.",
                },
                drugAdvancedDynamicMarketExactIntelTrust = {
                    label = "Dynamiczny Rynek / Dokładne informacje / Zaufanie",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Dokładne informacje / Zaufanie.",
                },
                drugAdvancedDynamicMarketGlobalZoneLabel = {
                    label = "Dynamiczny Rynek / Global / Strefa / Etykieta",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Global / Strefa / Etykieta.",
                },
                drugAdvancedDynamicMarketHistoryLimit = {
                    label = "Dynamiczny Rynek / Limit historii",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Limit historii.",
                },
                drugAdvancedDynamicMarketInitialDemand = {
                    label = "Dynamiczny Rynek / Wartość początkowa / Popyt",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wartość początkowa / Popyt.",
                },
                drugAdvancedDynamicMarketInitialPriceMultiplier = {
                    label = "Dynamiczny Rynek / Wartość początkowa / Mnożnik ceny",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Wartość początkowa / Mnożnik ceny.",
                },
                drugAdvancedDynamicMarketIntelDemandError = {
                    label = "Dynamiczny Rynek / Informacje / Popyt / Błąd",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Popyt / Błąd.",
                },
                drugAdvancedDynamicMarketIntelMaximumAccuracy = {
                    label = "Dynamiczny Rynek / Informacje / Maksimum / Dokładność",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Maksimum / Dokładność.",
                },
                drugAdvancedDynamicMarketIntelMinimumAccuracy = {
                    label = "Dynamiczny Rynek / Informacje / Minimum / Dokładność",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Minimum / Dokładność.",
                },
                drugAdvancedDynamicMarketIntelPoliceError = {
                    label = "Dynamiczny Rynek / Informacje / Policja / Błąd",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Policja / Błąd.",
                },
                drugAdvancedDynamicMarketIntelPriceError = {
                    label = "Dynamiczny Rynek / Informacje / Cena / Błąd",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Cena / Błąd.",
                },
                drugAdvancedDynamicMarketIntelPriceMaximum = {
                    label = "Dynamiczny Rynek / Informacje / Cena / Maksimum",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Cena / Maksimum.",
                },
                drugAdvancedDynamicMarketIntelPriceMinimum = {
                    label = "Dynamiczny Rynek / Informacje / Cena / Minimum",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Cena / Minimum.",
                },
                drugAdvancedDynamicMarketIntelReputationWeight = {
                    label = "Dynamiczny Rynek / Informacje / Reputacja / Waga",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Reputacja / Waga.",
                },
                drugAdvancedDynamicMarketIntelResourcePriceError = {
                    label = "Dynamiczny Rynek / Informacje / Surowiec / Cena / Błąd",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Surowiec / Cena / Błąd.",
                },
                drugAdvancedDynamicMarketIntelSaturationError = {
                    label = "Dynamiczny Rynek / Informacje / Nasycenie / Błąd",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Nasycenie / Błąd.",
                },
                drugAdvancedDynamicMarketIntelSeedBucketSeconds = {
                    label = "Dynamiczny Rynek / Okno ziarna informacji / sekundy",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Okno ziarna informacji / sekundy.",
                },
                drugAdvancedDynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Dynamiczny Rynek / Informacje / Status / Dokładność / Próg",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Status / Dokładność / Próg.",
                },
                drugAdvancedDynamicMarketIntelStatusErrorThreshold = {
                    label = "Dynamiczny Rynek / Informacje / Status / Błąd / Próg",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Status / Błąd / Próg.",
                },
                drugAdvancedDynamicMarketIntelSupplyError = {
                    label = "Dynamiczny Rynek / Informacje / Dostawa / Błąd",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Dostawa / Błąd.",
                },
                drugAdvancedDynamicMarketIntelTrustWeight = {
                    label = "Dynamiczny Rynek / Informacje / Zaufanie / Waga",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Informacje / Zaufanie / Waga.",
                },
                drugAdvancedDynamicMarketManipulationCooldownMinutes = {
                    label = "Dynamiczny Rynek / Manipulacja / Minuty odnowienia",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Manipulacja / Minuty odnowienia.",
                },
                drugAdvancedDynamicMarketManipulationDemandShift = {
                    label = "Dynamiczny Rynek / Manipulacja / Popyt / Zmiana",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Manipulacja / Popyt / Zmiana.",
                },
                drugAdvancedDynamicMarketManipulationDurationMinutes = {
                    label = "Dynamiczny Rynek / Manipulacja / Czas trwania / Minuty",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Manipulacja / Czas trwania / Minuty.",
                },
                drugAdvancedDynamicMarketManipulationHeat = {
                    label = "Dynamiczny Rynek / Manipulacja / Presja policji",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Manipulacja / Presja policji.",
                },
                drugAdvancedDynamicMarketManipulationMinimumBatchAmount = {
                    label = "Dynamiczny Rynek / Manipulacja / Minimum / Partia / Ilość",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Manipulacja / Minimum / Partia / Ilość.",
                },
                drugAdvancedDynamicMarketManipulationPaymentAccount = {
                    label = "Dynamiczny Rynek / Manipulacja / Konto płatnicze",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Manipulacja / Konto płatnicze.",
                },
                drugAdvancedDynamicMarketManipulationPrice = {
                    label = "Dynamiczny Rynek / Manipulacja / Cena",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Manipulacja / Cena.",
                },
                drugAdvancedDynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Dynamiczny Rynek / Manipulacja / Strefa / Presja policji / Mnożnik",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Manipulacja / Strefa / Presja policji / Mnożnik.",
                },
                drugAdvancedDynamicMarketMaximumIntelAgeMinutes = {
                    label = "Dynamiczny Rynek / Maksimum / Wiek danych / Minuty",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Maksimum / Wiek danych / Minuty.",
                },
                drugAdvancedDynamicMarketMaximumPriceMultiplier = {
                    label = "Dynamiczny Rynek / Maksimum / Mnożnik ceny",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Maksimum / Mnożnik ceny.",
                },
                drugAdvancedDynamicMarketMinimumIntelAgeMinutes = {
                    label = "Dynamiczny Rynek / Minimum / Wiek danych / Minuty",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Minimum / Wiek danych / Minuty.",
                },
                drugAdvancedDynamicMarketMinimumMetricWindowMinutes = {
                    label = "Dynamiczny Rynek / Minimum / Metryka / Okno czasowe / Minuty",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Minimum / Metryka / Okno czasowe / Minuty.",
                },
                drugAdvancedDynamicMarketMinimumPriceMultiplier = {
                    label = "Dynamiczny Rynek / Cena minimalna / Mnożnik",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Cena minimalna / Mnożnik.",
                },
                drugAdvancedDynamicMarketMinimumUpdateMinutes = {
                    label = "Dynamiczny Rynek / Minimum / Aktualizacja / Minuty",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Minimum / Aktualizacja / Minuty.",
                },
                drugAdvancedDynamicMarketPoliceDemandWeight = {
                    label = "Dynamiczny Rynek / Policja / Popyt / Waga",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Policja / Popyt / Waga.",
                },
                drugAdvancedDynamicMarketPolicePriceImpact = {
                    label = "Dynamiczny Rynek / Policja / Cena / Wpływ",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Policja / Cena / Wpływ.",
                },
                drugAdvancedDynamicMarketPoorQualityDemandPenalty = {
                    label = "Dynamiczny Rynek / Niska jakość / Popyt / Kara",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Niska jakość / Popyt / Kara.",
                },
                drugAdvancedDynamicMarketPoorQualityThreshold = {
                    label = "Dynamiczny Rynek / Niska jakość / Próg",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Niska jakość / Próg.",
                },
                drugAdvancedDynamicMarketPremiumQualityDemandBonus = {
                    label = "Dynamiczny Rynek / Jakość premium / Bonus do popytu",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Jakość premium / Bonus do popytu.",
                },
                drugAdvancedDynamicMarketPremiumQualityThreshold = {
                    label = "Dynamiczny Rynek / Jakość premium / Próg",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Jakość premium / Próg.",
                },
                drugAdvancedDynamicMarketProductionSupplyWeight = {
                    label = "Dynamiczny Rynek / Produkcja / Dostawa / Waga",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Produkcja / Dostawa / Waga.",
                },
                drugAdvancedDynamicMarketProductionWindowMinutes = {
                    label = "Dynamiczny Rynek / Produkcja / Okno czasowe / Minuty",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Produkcja / Okno czasowe / Minuty.",
                },
                drugAdvancedDynamicMarketQualityCenter = {
                    label = "Dynamiczny Rynek / Jakość / Wartość środkowa",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Jakość / Wartość środkowa.",
                },
                drugAdvancedDynamicMarketQualityConfidenceImpact = {
                    label = "Dynamiczny Rynek / Jakość / Pewność / Wpływ",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Jakość / Pewność / Wpływ.",
                },
                drugAdvancedDynamicMarketQualityRange = {
                    label = "Dynamiczny Rynek / Jakość / Zakres wartości",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Jakość / Zakres wartości.",
                },
                drugAdvancedDynamicMarketRarityBonusMaximum = {
                    label = "Dynamiczny Rynek / Rzadkość / Premia / Maksimum",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Rzadkość / Premia / Maksimum.",
                },
                drugAdvancedDynamicMarketRegionalGlobalWeight = {
                    label = "Dynamiczny Rynek / Regionalne / Global / Waga",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Regionalne / Global / Waga.",
                },
                drugAdvancedDynamicMarketRegionalLocalWeight = {
                    label = "Dynamiczny Rynek / Regionalne / Lokalne / Waga",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Regionalne / Lokalne / Waga.",
                },
                drugAdvancedDynamicMarketResourceAliasesDrugpackaging = {
                    label = "Dynamiczny Rynek / Surowiec / Aliasy / Narkotyk / Opakowanie",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Surowiec / Aliasy / Narkotyk / Opakowanie.",
                },
                drugAdvancedDynamicMarketResourceAliasesFuelcan = {
                    label = "Dynamiczny Rynek / Surowiec / Aliasy / Kanister paliwa",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Surowiec / Aliasy / Kanister paliwa.",
                },
                drugAdvancedDynamicMarketResourceAliasesMachineoil = {
                    label = "Dynamiczny Rynek / Surowiec / Aliasy / Olej maszynowy",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Surowiec / Aliasy / Olej maszynowy.",
                },
                drugAdvancedDynamicMarketResourceAliasesPlantnutrients = {
                    label = "Dynamiczny Rynek / Surowiec / Aliasy / Odżywki dla roślin",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Surowiec / Aliasy / Odżywki dla roślin.",
                },
                drugAdvancedDynamicMarketResourceAliasesRepairkit = {
                    label = "Dynamiczny Rynek / Surowiec / Aliasy / Zestaw naprawczy",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Surowiec / Aliasy / Zestaw naprawczy.",
                },
                drugAdvancedDynamicMarketResourceDirectionFallThreshold = {
                    label = "Dynamiczny Rynek / Surowiec / Kierunek / Spadek / Próg",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Surowiec / Kierunek / Spadek / Próg.",
                },
                drugAdvancedDynamicMarketResourceDirectionRiseThreshold = {
                    label = "Dynamiczny Rynek / Surowiec / Kierunek / Wzrost / Próg",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Surowiec / Kierunek / Wzrost / Próg.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterBasePrice = {
                    label = "Dynamiczny Rynek / Zasoby / Filtr węglowy / Cena bazowa",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Filtr węglowy / Cena bazowa.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterElasticity = {
                    label = "Dynamiczny Rynek / Zasoby / Filtr węglowy / Elastyczność",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Filtr węglowy / Elastyczność.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLabel = {
                    label = "Dynamiczny Rynek / Zasoby / Filtr węglowy / Etykieta",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Filtr węglowy / Etykieta.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem1 = {
                    label = "Dynamiczny Rynek / Zasoby / Filtr węglowy / Powiązane narkotyki / 1",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Filtr węglowy / Powiązane narkotyki / 1.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem2 = {
                    label = "Dynamiczny Rynek / Zasoby / Filtr węglowy / Powiązane narkotyki / 2",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Filtr węglowy / Powiązane narkotyki / 2.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem3 = {
                    label = "Dynamiczny Rynek / Zasoby / Filtr węglowy / Powiązane narkotyki / 3",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Filtr węglowy / Powiązane narkotyki / 3.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorBasePrice = {
                    label = "Dynamiczny Rynek / Zasoby / Prekursor chemiczny / Cena bazowa",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Prekursor chemiczny / Cena bazowa.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorElasticity = {
                    label = "Dynamiczny Rynek / Zasoby / Prekursor chemiczny / Elastyczność",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Prekursor chemiczny / Elastyczność.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLabel = {
                    label = "Dynamiczny Rynek / Zasoby / Prekursor chemiczny / Etykieta",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Prekursor chemiczny / Etykieta.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem1 = {
                    label = "Dynamiczny Rynek / Zasoby / Prekursor chemiczny / Powiązane narkotyki / 1",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Prekursor chemiczny / Powiązane narkotyki / 1.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem2 = {
                    label = "Dynamiczny Rynek / Zasoby / Prekursor chemiczny / Powiązane narkotyki / 2",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Prekursor chemiczny / Powiązane narkotyki / 2.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsBasePrice = {
                    label = "Dynamiczny Rynek / Zasoby / Części sprzętu / Cena bazowa",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Części sprzętu / Cena bazowa.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsElasticity = {
                    label = "Dynamiczny Rynek / Zasoby / Części sprzętu / Elastyczność",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Części sprzętu / Elastyczność.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsLabel = {
                    label = "Dynamiczny Rynek / Zasoby / Części sprzętu / Etykieta",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Części sprzętu / Etykieta.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerBasePrice = {
                    label = "Dynamiczny Rynek / Zasoby / Nawóz / Cena bazowa",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Nawóz / Cena bazowa.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerElasticity = {
                    label = "Dynamiczny Rynek / Zasoby / Nawóz / Elastyczność",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Nawóz / Elastyczność.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLabel = {
                    label = "Dynamiczny Rynek / Zasoby / Nawóz / Etykieta",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Nawóz / Etykieta.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLinkedDrugsItem1 = {
                    label = "Dynamiczny Rynek / Zasoby / Nawóz / Powiązane narkotyki / 1",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Nawóz / Powiązane narkotyki / 1.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelBasePrice = {
                    label = "Dynamiczny Rynek / Zasoby / Paliwo laboratoryjne / Cena bazowa",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Paliwo laboratoryjne / Cena bazowa.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelElasticity = {
                    label = "Dynamiczny Rynek / Zasoby / Paliwo laboratoryjne / Elastyczność",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Paliwo laboratoryjne / Elastyczność.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelLabel = {
                    label = "Dynamiczny Rynek / Zasoby / Paliwo laboratoryjne / Etykieta",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Paliwo laboratoryjne / Etykieta.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagBasePrice = {
                    label = "Dynamiczny Rynek / Zasoby / Worek opakowaniowy / Cena bazowa",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Worek opakowaniowy / Cena bazowa.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagElasticity = {
                    label = "Dynamiczny Rynek / Zasoby / Worek opakowaniowy / Elastyczność",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Worek opakowaniowy / Elastyczność.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagLabel = {
                    label = "Dynamiczny Rynek / Zasoby / Worek opakowaniowy / Etykieta",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Worek opakowaniowy / Etykieta.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotBasePrice = {
                    label = "Dynamiczny Rynek / Zasoby / Doniczka / Cena bazowa",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Doniczka / Cena bazowa.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotElasticity = {
                    label = "Dynamiczny Rynek / Zasoby / Doniczka / Elastyczność",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Doniczka / Elastyczność.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLabel = {
                    label = "Dynamiczny Rynek / Zasoby / Doniczka / Etykieta",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Doniczka / Etykieta.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLinkedDrugsItem1 = {
                    label = "Dynamiczny Rynek / Zasoby / Doniczka / Powiązane narkotyki / 1",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Doniczka / Powiązane narkotyki / 1.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedBasePrice = {
                    label = "Dynamiczny Rynek / Zasoby / Nasiono konopi / Cena bazowa",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Nasiono konopi / Cena bazowa.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedElasticity = {
                    label = "Dynamiczny Rynek / Zasoby / Nasiono konopi / Elastyczność",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Nasiono konopi / Elastyczność.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLabel = {
                    label = "Dynamiczny Rynek / Zasoby / Nasiono konopi / Etykieta",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Nasiono konopi / Etykieta.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLinkedDrugsItem1 = {
                    label = "Dynamiczny Rynek / Zasoby / Nasiono konopi / Powiązane narkotyki / 1",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zasoby / Nasiono konopi / Powiązane narkotyki / 1.",
                },
                drugAdvancedDynamicMarketSalesWindowMinutes = {
                    label = "Dynamiczny Rynek / Sprzedaż / Okno czasowe / Minuty",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Sprzedaż / Okno czasowe / Minuty.",
                },
                drugAdvancedDynamicMarketSaturationDemandWeight = {
                    label = "Dynamiczny Rynek / Nasycenie / Popyt / Waga",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Nasycenie / Popyt / Waga.",
                },
                drugAdvancedDynamicMarketSaturationPriceImpact = {
                    label = "Dynamiczny Rynek / Nasycenie / Cena / Wpływ",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Nasycenie / Cena / Wpływ.",
                },
                drugAdvancedDynamicMarketScarcityDemandWeight = {
                    label = "Dynamiczny Rynek / Niedobór / Popyt / Waga",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Niedobór / Popyt / Waga.",
                },
                drugAdvancedDynamicMarketScarcityPriceImpact = {
                    label = "Dynamiczny Rynek / Niedobór / Cena / Wpływ",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Niedobór / Cena / Wpływ.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsDecember = {
                    label = "Dynamiczny Rynek / Pora roku / Koniec / Miesiące / Grudzień",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Pora roku / Koniec / Miesiące / Grudzień.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSpring = {
                    label = "Dynamiczny Rynek / Pora roku / Koniec / Miesiące / Wiosna",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Pora roku / Koniec / Miesiące / Wiosna.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSummer = {
                    label = "Dynamiczny Rynek / Pora roku / Koniec / Miesiące / Lato",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Pora roku / Koniec / Miesiące / Lato.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsWinter = {
                    label = "Dynamiczny Rynek / Pora roku / Koniec / Miesiące / Zima",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Pora roku / Koniec / Miesiące / Zima.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersAutumn = {
                    label = "Dynamiczny Rynek / Pora roku / Mnożniki / Jesień",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Pora roku / Mnożniki / Jesień.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSpring = {
                    label = "Dynamiczny Rynek / Pora roku / Mnożniki / Wiosna",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Pora roku / Mnożniki / Wiosna.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSummer = {
                    label = "Dynamiczny Rynek / Pora roku / Mnożniki / Lato",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Pora roku / Mnożniki / Lato.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersWinter = {
                    label = "Dynamiczny Rynek / Pora roku / Mnożniki / Zima",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Pora roku / Mnożniki / Zima.",
                },
                drugAdvancedDynamicMarketShortageRumorThreshold = {
                    label = "Dynamiczny Rynek / Niedobór / Plotka / Próg",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Niedobór / Plotka / Próg.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHighDemand = {
                    label = "Dynamiczny Rynek / Status / Progi / Wysoki popyt",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Status / Progi / Wysoki popyt.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHot = {
                    label = "Dynamiczny Rynek / Status / Progi / Poszukiwany",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Status / Progi / Poszukiwany.",
                },
                drugAdvancedDynamicMarketStatusThresholdsLowDemand = {
                    label = "Dynamiczny Rynek / Status / Progi / Niski popyt",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Status / Progi / Niski popyt.",
                },
                drugAdvancedDynamicMarketStatusThresholdsSaturated = {
                    label = "Dynamiczny Rynek / Status / Progi / Nasycony",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Status / Progi / Nasycony.",
                },
                drugAdvancedDynamicMarketTargetSupply = {
                    label = "Dynamiczny Rynek / Cel / Dostawa",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Cel / Dostawa.",
                },
                drugAdvancedDynamicMarketTrendChance = {
                    label = "Dynamiczny Rynek / Trend / Szansa",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Trend / Szansa.",
                },
                drugAdvancedDynamicMarketTrendDurationMinutes = {
                    label = "Dynamiczny Rynek / Trend / Czas trwania / Minuty",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Trend / Czas trwania / Minuty.",
                },
                drugAdvancedDynamicMarketTrendMaximumStrength = {
                    label = "Dynamiczny Rynek / Trend / Maksimum / Siła",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Trend / Maksimum / Siła.",
                },
                drugAdvancedDynamicMarketTrendMinimumStrength = {
                    label = "Dynamiczny Rynek / Trend / Minimum / Siła",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Trend / Minimum / Siła.",
                },
                drugAdvancedDynamicMarketUpdateMinutes = {
                    label = "Dynamiczny Rynek / Aktualizacja / Minuty",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Aktualizacja / Minuty.",
                },
                drugAdvancedDynamicMarketVolatilityMaximum = {
                    label = "Dynamiczny Rynek / Zmienność cen / Maksimum",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zmienność cen / Maksimum.",
                },
                drugAdvancedDynamicMarketVolatilityMinimum = {
                    label = "Dynamiczny Rynek / Zmienność cen / Minimum",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Zmienność cen / Minimum.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersCold = {
                    label = "Dynamiczny Rynek / Pogoda / Mnożniki / Zimno",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Pogoda / Mnożniki / Zimno.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersHeatwave = {
                    label = "Dynamiczny Rynek / Pogoda / Mnożniki / Fala upałów",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Pogoda / Mnożniki / Fala upałów.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersNormal = {
                    label = "Dynamiczny Rynek / Pogoda / Mnożniki / Normalna",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Pogoda / Mnożniki / Normalna.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersRain = {
                    label = "Dynamiczny Rynek / Pogoda / Mnożniki / Deszcz",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Pogoda / Mnożniki / Deszcz.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersStorm = {
                    label = "Dynamiczny Rynek / Pogoda / Mnożniki / Burza",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Pogoda / Mnożniki / Burza.",
                },
                drugAdvancedDynamicMarketWeatherState = {
                    label = "Dynamiczny Rynek / Pogoda / Status",
                    description = "Ustawienie działania dla: Dynamiczny Rynek / Pogoda / Status.",
                },
                drugAdvancedHeatActionCooldownSeconds = {
                    label = "Zainteresowanie policji i ryzyko / Czas odnowienia akcji / sekundy",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Czas odnowienia akcji / sekundy.",
                },
                drugAdvancedHeatActivityRiskWeightsAmount = {
                    label = "Zainteresowanie policji i ryzyko / Aktywność / Ryzyko / Wagi / Ilość",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Aktywność / Ryzyko / Wagi / Ilość.",
                },
                drugAdvancedHeatActivityRiskWeightsDurationMinutes = {
                    label = "Zainteresowanie policji i ryzyko / Aktywność / Ryzyko / Wagi / Czas trwania / Minuty",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Aktywność / Ryzyko / Wagi / Czas trwania / Minuty.",
                },
                drugAdvancedHeatActivityRiskWeightsPolicePressure = {
                    label = "Zainteresowanie policji i ryzyko / Aktywność / Ryzyko / Wagi / Presja policji",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Aktywność / Ryzyko / Wagi / Presja policji.",
                },
                drugAdvancedHeatActivityRiskWeightsReputation = {
                    label = "Zainteresowanie policji i ryzyko / Aktywność / Ryzyko / Wagi / Reputacja",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Aktywność / Ryzyko / Wagi / Reputacja.",
                },
                drugAdvancedHeatActivityRiskWeightsSecurity = {
                    label = "Zainteresowanie policji i ryzyko / Aktywność / Ryzyko / Wagi / Bezpieczeństwo",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Aktywność / Ryzyko / Wagi / Bezpieczeństwo.",
                },
                drugAdvancedHeatAggressiveHeatMultiplier = {
                    label = "Zainteresowanie policji i ryzyko / Tryb agresywny / Presja policji / Mnożnik",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Tryb agresywny / Presja policji / Mnożnik.",
                },
                drugAdvancedHeatBurnerBurnThreshold = {
                    label = "Zainteresowanie policji i ryzyko / Telefon jednorazowy / Zdemaskowanie / Próg",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Telefon jednorazowy / Zdemaskowanie / Próg.",
                },
                drugAdvancedHeatBurnerHeatPerWholesale = {
                    label = "Zainteresowanie policji i ryzyko / Telefon jednorazowy / Presja policji / Na transakcję hurtową",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Telefon jednorazowy / Presja policji / Na transakcję hurtową.",
                },
                drugAdvancedHeatBurnerPhoneItem = {
                    label = "Zainteresowanie policji i ryzyko / Telefon jednorazowy / Przedmiot",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Telefon jednorazowy / Przedmiot.",
                },
                drugAdvancedHeatCamperOperationalHeatMultiplier = {
                    label = "Zainteresowanie policji i ryzyko / Kamper w działaniu / Presja policji / Mnożnik",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Kamper w działaniu / Presja policji / Mnożnik.",
                },
                drugAdvancedHeatCamperOperationalHeatThreshold = {
                    label = "Zainteresowanie policji i ryzyko / Kamper w działaniu / Presja policji / Próg",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Kamper w działaniu / Presja policji / Próg.",
                },
                drugAdvancedHeatCamperParkedHeat = {
                    label = "Zainteresowanie policji i ryzyko / Zaparkowany kamper / Presja policji",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Zaparkowany kamper / Presja policji.",
                },
                drugAdvancedHeatContaminatedHeatMultiplier = {
                    label = "Zainteresowanie policji i ryzyko / Zanieczyszczenie / Presja policji / Mnożnik",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Zanieczyszczenie / Presja policji / Mnożnik.",
                },
                drugAdvancedHeatContaminatedThreshold = {
                    label = "Zainteresowanie policji i ryzyko / Zanieczyszczenie / Próg",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Zanieczyszczenie / Próg.",
                },
                drugAdvancedHeatCultivationFreePlants = {
                    label = "Zainteresowanie policji i ryzyko / Uprawa / Rośliny bez dodatkowego ryzyka",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Uprawa / Rośliny bez dodatkowego ryzyka.",
                },
                drugAdvancedHeatCultivationHeatPerPlant = {
                    label = "Zainteresowanie policji i ryzyko / Uprawa / Presja policji / Na roślinę",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Uprawa / Presja policji / Na roślinę.",
                },
                drugAdvancedHeatDealerHiddenMinutes = {
                    label = "Zainteresowanie policji i ryzyko / Dystrybutor / ukryte / Minuty",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Dystrybutor / ukryte / Minuty.",
                },
                drugAdvancedHeatDecayPerTickBatch = {
                    label = "Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Partia",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Partia.",
                },
                drugAdvancedHeatDecayPerTickCamper = {
                    label = "Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Kamper",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Kamper.",
                },
                drugAdvancedHeatDecayPerTickDealer = {
                    label = "Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Dystrybutor",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Dystrybutor.",
                },
                drugAdvancedHeatDecayPerTickFaction = {
                    label = "Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Frakcja",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Frakcja.",
                },
                drugAdvancedHeatDecayPerTickHub = {
                    label = "Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Centrum dystrybucji",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Centrum dystrybucji.",
                },
                drugAdvancedHeatDecayPerTickLab = {
                    label = "Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Laboratorium",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Laboratorium.",
                },
                drugAdvancedHeatDecayPerTickPlayer = {
                    label = "Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Gracz",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Gracz.",
                },
                drugAdvancedHeatDecayPerTickRoute = {
                    label = "Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Trasa",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Trasa.",
                },
                drugAdvancedHeatDecayPerTickZone = {
                    label = "Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Strefa",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Degradacja / Na cykl aktualizacji / Strefa.",
                },
                drugAdvancedHeatEnabled = {
                    label = "Zainteresowanie policji i ryzyko / Włączone",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Włączone.",
                },
                drugAdvancedHeatEnforcementHeatCritical = {
                    label = "Zainteresowanie policji i ryzyko / Obecność policji / Presja policji / Krytyczny",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Obecność policji / Presja policji / Krytyczny.",
                },
                drugAdvancedHeatEnforcementHeatHigh = {
                    label = "Zainteresowanie policji i ryzyko / Obecność policji / Presja policji / Wysoki",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Obecność policji / Presja policji / Wysoki.",
                },
                drugAdvancedHeatEnforcementHeatLow = {
                    label = "Zainteresowanie policji i ryzyko / Obecność policji / Presja policji / Niski",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Obecność policji / Presja policji / Niski.",
                },
                drugAdvancedHeatEnforcementHeatMedium = {
                    label = "Zainteresowanie policji i ryzyko / Obecność policji / Presja policji / Średni",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Obecność policji / Presja policji / Średni.",
                },
                drugAdvancedHeatEnforcementMultipliersBatch = {
                    label = "Zainteresowanie policji i ryzyko / Obecność policji / Mnożniki / Partia",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Obecność policji / Mnożniki / Partia.",
                },
                drugAdvancedHeatEnforcementMultipliersFaction = {
                    label = "Zainteresowanie policji i ryzyko / Obecność policji / Mnożniki / Frakcja",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Obecność policji / Mnożniki / Frakcja.",
                },
                drugAdvancedHeatEnforcementMultipliersZone = {
                    label = "Zainteresowanie policji i ryzyko / Obecność policji / Mnożniki / Strefa",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Obecność policji / Mnożniki / Strefa.",
                },
                drugAdvancedHeatEntityTypesBatch = {
                    label = "Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Partia",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Partia.",
                },
                drugAdvancedHeatEntityTypesCamper = {
                    label = "Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Kamper",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Kamper.",
                },
                drugAdvancedHeatEntityTypesDealer = {
                    label = "Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Dystrybutor",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Dystrybutor.",
                },
                drugAdvancedHeatEntityTypesFaction = {
                    label = "Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Frakcja",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Frakcja.",
                },
                drugAdvancedHeatEntityTypesHub = {
                    label = "Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Centrum dystrybucji",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Centrum dystrybucji.",
                },
                drugAdvancedHeatEntityTypesLab = {
                    label = "Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Laboratorium",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Laboratorium.",
                },
                drugAdvancedHeatEntityTypesPlayer = {
                    label = "Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Gracz",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Gracz.",
                },
                drugAdvancedHeatEntityTypesRoute = {
                    label = "Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Trasa",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Trasa.",
                },
                drugAdvancedHeatEntityTypesZone = {
                    label = "Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Strefa",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Obiekt gry / Typy / Strefa.",
                },
                drugAdvancedHeatEventCooldownMinutes = {
                    label = "Zainteresowanie policji i ryzyko / Zdarzenie / Minuty odnowienia",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Zdarzenie / Minuty odnowienia.",
                },
                drugAdvancedHeatEventHistoryLimit = {
                    label = "Zainteresowanie policji i ryzyko / Zdarzenie / Limit historii",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Zdarzenie / Limit historii.",
                },
                drugAdvancedHeatLabHeatSyncThreshold = {
                    label = "Zainteresowanie policji i ryzyko / Laboratorium / Presja policji / Synchronizacja / Próg",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Laboratorium / Presja policji / Synchronizacja / Próg.",
                },
                drugAdvancedHeatLayLowCooldownMinutes = {
                    label = "Zainteresowanie policji i ryzyko / Ukrywanie się / Minuty odnowienia",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Ukrywanie się / Minuty odnowienia.",
                },
                drugAdvancedHeatLayLowIdleMinutes = {
                    label = "Zainteresowanie policji i ryzyko / Ukrywanie się / Bezczynny / Minuty",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Ukrywanie się / Bezczynny / Minuty.",
                },
                drugAdvancedHeatLayLowReduction = {
                    label = "Zainteresowanie policji i ryzyko / Ukrywanie się / Redukcja",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Ukrywanie się / Redukcja.",
                },
                drugAdvancedHeatLockdownMinutes = {
                    label = "Zainteresowanie policji i ryzyko / Blokada / Minuty",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Blokada / Minuty.",
                },
                drugAdvancedHeatMinimumDurationMinutes = {
                    label = "Zainteresowanie policji i ryzyko / Minimum / Czas trwania / Minuty",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Minimum / Czas trwania / Minuty.",
                },
                drugAdvancedHeatMinimumEventCooldownSeconds = {
                    label = "Zainteresowanie policji i ryzyko / Minimum / Zdarzenie / Czas odnowienia (sekundy)",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Minimum / Zdarzenie / Czas odnowienia (sekundy).",
                },
                drugAdvancedHeatMinimumIdleSeconds = {
                    label = "Zainteresowanie policji i ryzyko / Minimum / Bezczynny / sekundy",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Minimum / Bezczynny / sekundy.",
                },
                drugAdvancedHeatProcessingHeatMultiplier = {
                    label = "Zainteresowanie policji i ryzyko / Przetwarzanie / Presja policji / Mnożnik",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Przetwarzanie / Presja policji / Mnożnik.",
                },
                drugAdvancedHeatRiskWeightsBatch = {
                    label = "Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Partia",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Partia.",
                },
                drugAdvancedHeatRiskWeightsCamper = {
                    label = "Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Kamper",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Kamper.",
                },
                drugAdvancedHeatRiskWeightsDealer = {
                    label = "Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Dystrybutor",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Dystrybutor.",
                },
                drugAdvancedHeatRiskWeightsFaction = {
                    label = "Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Frakcja",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Frakcja.",
                },
                drugAdvancedHeatRiskWeightsHub = {
                    label = "Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Centrum dystrybucji",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Centrum dystrybucji.",
                },
                drugAdvancedHeatRiskWeightsLab = {
                    label = "Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Laboratorium",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Laboratorium.",
                },
                drugAdvancedHeatRiskWeightsPlayer = {
                    label = "Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Gracz",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Gracz.",
                },
                drugAdvancedHeatRiskWeightsRoute = {
                    label = "Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Trasa",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Trasa.",
                },
                drugAdvancedHeatRiskWeightsZone = {
                    label = "Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Strefa",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Ryzyko / Wagi / Strefa.",
                },
                drugAdvancedHeatRotateBurnerReduction = {
                    label = "Zainteresowanie policji i ryzyko / Zmień telefon jednorazowy / Redukcja",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Zmień telefon jednorazowy / Redukcja.",
                },
                drugAdvancedHeatRouteControlMinutes = {
                    label = "Zainteresowanie policji i ryzyko / Trasa / Sterowanie / Minuty",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Trasa / Sterowanie / Minuty.",
                },
                drugAdvancedHeatSaleHeatBatch = {
                    label = "Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Partia",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Partia.",
                },
                drugAdvancedHeatSaleHeatCamper = {
                    label = "Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Kamper",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Kamper.",
                },
                drugAdvancedHeatSaleHeatDealer = {
                    label = "Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Dystrybutor",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Dystrybutor.",
                },
                drugAdvancedHeatSaleHeatFaction = {
                    label = "Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Frakcja",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Frakcja.",
                },
                drugAdvancedHeatSaleHeatHub = {
                    label = "Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Centrum dystrybucji",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Centrum dystrybucji.",
                },
                drugAdvancedHeatSaleHeatLab = {
                    label = "Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Laboratorium",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Laboratorium.",
                },
                drugAdvancedHeatSaleHeatPlayer = {
                    label = "Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Gracz",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Gracz.",
                },
                drugAdvancedHeatSaleHeatRoute = {
                    label = "Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Trasa",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Trasa.",
                },
                drugAdvancedHeatSaleHeatZone = {
                    label = "Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Strefa",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Sprzedaż / Presja policji / Strefa.",
                },
                drugAdvancedHeatThresholdsCritical = {
                    label = "Zainteresowanie policji i ryzyko / Progi / Krytyczny",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Progi / Krytyczny.",
                },
                drugAdvancedHeatThresholdsHigh = {
                    label = "Zainteresowanie policji i ryzyko / Progi / Wysoki",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Progi / Wysoki.",
                },
                drugAdvancedHeatThresholdsLockdown = {
                    label = "Zainteresowanie policji i ryzyko / Progi / Blokada",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Progi / Blokada.",
                },
                drugAdvancedHeatThresholdsLow = {
                    label = "Zainteresowanie policji i ryzyko / Progi / Niski",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Progi / Niski.",
                },
                drugAdvancedHeatThresholdsMedium = {
                    label = "Zainteresowanie policji i ryzyko / Progi / Średni",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Progi / Średni.",
                },
                drugAdvancedHeatTickMinutes = {
                    label = "Zainteresowanie policji i ryzyko / Cykl aktualizacji / Minuty",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Cykl aktualizacji / Minuty.",
                },
                drugAdvancedHeatWholesaleHeatMultiplier = {
                    label = "Zainteresowanie policji i ryzyko / Hurtownia / Presja policji / Mnożnik",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Hurtownia / Presja policji / Mnożnik.",
                },
                drugAdvancedHeatWorkerLeakAlertRadius = {
                    label = "Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Promień alarmu",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Promień alarmu.",
                },
                drugAdvancedHeatWorkerLeakBaseChance = {
                    label = "Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Wartość bazowa / Szansa",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Wartość bazowa / Szansa.",
                },
                drugAdvancedHeatWorkerLeakFactionMultiplier = {
                    label = "Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Frakcja / Mnożnik",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Frakcja / Mnożnik.",
                },
                drugAdvancedHeatWorkerLeakHighSeverityThreshold = {
                    label = "Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Wysoki / Dotkliwość / Próg",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Wysoki / Dotkliwość / Próg.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Lojalność / Szansa / Mnożnik",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Lojalność / Szansa / Mnożnik.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyThreshold = {
                    label = "Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Lojalność / Próg",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Lojalność / Próg.",
                },
                drugAdvancedHeatWorkerLeakMaximumChance = {
                    label = "Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Maksimum / Szansa",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Maksimum / Szansa.",
                },
                drugAdvancedHeatWorkerLeakMinimumCooldownSeconds = {
                    label = "Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Minimum / Czas odnowienia (sekundy)",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Minimum / Czas odnowienia (sekundy).",
                },
                drugAdvancedHeatWorkerLeakRouteMultiplier = {
                    label = "Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Trasa / Mnożnik",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Trasa / Mnożnik.",
                },
                drugAdvancedHeatWorkerLeakStrengthMaximum = {
                    label = "Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Siła / Maksimum",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Siła / Maksimum.",
                },
                drugAdvancedHeatWorkerLeakStrengthMinimum = {
                    label = "Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Siła / Minimum",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Siła / Minimum.",
                },
                drugAdvancedHeatWorkerLeakStrengthMultiplier = {
                    label = "Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Siła / Mnożnik",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Siła / Mnożnik.",
                },
                drugAdvancedHeatWorkerLeakStressChanceMultiplier = {
                    label = "Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Stres / Szansa / Mnożnik",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Stres / Szansa / Mnożnik.",
                },
                drugAdvancedHeatWorkerLeakStressThreshold = {
                    label = "Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Stres / Próg",
                    description = "Ustawienie działania dla: Zainteresowanie policji i ryzyko / Pracownik / Wyciek informacji / Stres / Próg.",
                },
                drugAdvancedContactNetworkActionCooldownSeconds = {
                    label = "Sieć kontaktów / Czas odnowienia akcji / sekundy",
                    description = "Ustawienie działania dla: Sieć kontaktów / Czas odnowienia akcji / sekundy.",
                },
                drugAdvancedContactNetworkActiveHotspotCount = {
                    label = "Sieć kontaktów / Liczba aktywnych punktów",
                    description = "Ustawienie działania dla: Sieć kontaktów / Liczba aktywnych punktów.",
                },
                drugAdvancedContactNetworkBurnerHintTrust = {
                    label = "Sieć kontaktów / Wskazówka dotycząca burner'a / Zaufanie",
                    description = "Ustawienie działania dla: Sieć kontaktów / Wskazówka dotycząca burner'a / Zaufanie.",
                },
                drugAdvancedContactNetworkBurnerOfferMaximumMultiplier = {
                    label = "Sieć kontaktów / Telefon jednorazowy / Oferta / Maksimum / Mnożnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Telefon jednorazowy / Oferta / Maksimum / Mnożnik.",
                },
                drugAdvancedContactNetworkBurnerOfferMinimumMultiplier = {
                    label = "Sieć kontaktów / Telefon jednorazowy / Oferta / Minimum / Mnożnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Telefon jednorazowy / Oferta / Minimum / Mnożnik.",
                },
                drugAdvancedContactNetworkBuyerCooldownMinutes = {
                    label = "Sieć kontaktów / Kupiec / Minuty odnowienia",
                    description = "Ustawienie działania dla: Sieć kontaktów / Kupiec / Minuty odnowienia.",
                },
                drugAdvancedContactNetworkBuyerDeliveryDistance = {
                    label = "Sieć kontaktów / Kupiec / Odległość dostawy",
                    description = "Ustawienie działania dla: Sieć kontaktów / Kupiec / Odległość dostawy.",
                },
                drugAdvancedContactNetworkBuyerPremiumSuccessScore = {
                    label = "Sieć kontaktów / Kupiec / Premium / Sukces / Wynik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Kupiec / Premium / Sukces / Wynik.",
                },
                drugAdvancedContactNetworkBuyerPremiumTrustGain = {
                    label = "Sieć kontaktów / Kupiec / Premium / Zaufanie / zysk",
                    description = "Ustawienie działania dla: Sieć kontaktów / Kupiec / Premium / Zaufanie / zysk.",
                },
                drugAdvancedContactNetworkBuyerRequestHeatRiskWeight = {
                    label = "Sieć kontaktów / Kupiec / Żądanie / Poziom poszukiwań i ryzyko / Waga",
                    description = "Ustawienie działania dla: Sieć kontaktów / Kupiec / Żądanie / Poziom poszukiwań i ryzyko / Waga.",
                },
                drugAdvancedContactNetworkBuyerStandardTrustGain = {
                    label = "Sieć kontaktów / Kupiec / Standardowy / Zaufanie / zysk",
                    description = "Ustawienie działania dla: Sieć kontaktów / Kupiec / Standardowy / Zaufanie / zysk.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMax = {
                    label = "Sieć kontaktów / Opóźnienie aktywacji kontaktu / sekundy / Maksimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Opóźnienie aktywacji kontaktu / sekundy / Maksimum.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMin = {
                    label = "Sieć kontaktów / Opóźnienie aktywacji kontaktu / sekundy / Minimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Opóźnienie aktywacji kontaktu / sekundy / Minimum.",
                },
                drugAdvancedContactNetworkContactDemandRangeMax = {
                    label = "Sieć kontaktów / Kontakt / Popyt / Zakres wartości / Maksimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Kontakt / Popyt / Zakres wartości / Maksimum.",
                },
                drugAdvancedContactNetworkContactDemandRangeMin = {
                    label = "Sieć kontaktów / Kontakt / Popyt / Zakres wartości / Minimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Kontakt / Popyt / Zakres wartości / Minimum.",
                },
                drugAdvancedContactNetworkContactLossTrust = {
                    label = "Sieć kontaktów / Kontakt / Strata / Zaufanie",
                    description = "Ustawienie działania dla: Sieć kontaktów / Kontakt / Strata / Zaufanie.",
                },
                drugAdvancedContactNetworkDarknetExactIntelMinutes = {
                    label = "Sieć kontaktów / Darknet / Dokładne informacje / Minuty",
                    description = "Ustawienie działania dla: Sieć kontaktów / Darknet / Dokładne informacje / Minuty.",
                },
                drugAdvancedContactNetworkDarknetHotspotIntelPrice = {
                    label = "Sieć kontaktów / Darknet / Punkt aktywności / Informacje / Cena",
                    description = "Ustawienie działania dla: Sieć kontaktów / Darknet / Punkt aktywności / Informacje / Cena.",
                },
                drugAdvancedContactNetworkDarknetIntelPrice = {
                    label = "Sieć kontaktów / Darknet / Informacje / Cena",
                    description = "Ustawienie działania dla: Sieć kontaktów / Darknet / Informacje / Cena.",
                },
                drugAdvancedContactNetworkDealerBasePrice = {
                    label = "Sieć kontaktów / Dystrybutor / Cena bazowa",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Cena bazowa.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMax = {
                    label = "Sieć kontaktów / Dystrybutor / Zatrudnienie / pojemność / Maksimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Zatrudnienie / pojemność / Maksimum.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMin = {
                    label = "Sieć kontaktów / Dystrybutor / Zatrudnienie / pojemność / Minimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Zatrudnienie / pojemność / Minimum.",
                },
                drugAdvancedContactNetworkDealerHireRiskMax = {
                    label = "Sieć kontaktów / Dystrybutor / Zatrudnienie / Ryzyko / Maksimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Zatrudnienie / Ryzyko / Maksimum.",
                },
                drugAdvancedContactNetworkDealerHireRiskMin = {
                    label = "Sieć kontaktów / Dystrybutor / Zatrudnienie / Ryzyko / Minimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Zatrudnienie / Ryzyko / Minimum.",
                },
                drugAdvancedContactNetworkDealerHireSkillMax = {
                    label = "Sieć kontaktów / Dystrybutor / Zatrudnienie / Umiejętność / Maksimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Zatrudnienie / Umiejętność / Maksimum.",
                },
                drugAdvancedContactNetworkDealerHireSkillMin = {
                    label = "Sieć kontaktów / Dystrybutor / Zatrudnienie / Umiejętność / Minimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Zatrudnienie / Umiejętność / Minimum.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Id = {
                    label = "Sieć kontaktów / Oferty dealerów / 1 / ID",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 1 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Item = {
                    label = "Sieć kontaktów / Oferty dealerów / 1 / Przedmiot",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 1 / Przedmiot.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Label = {
                    label = "Sieć kontaktów / Oferty dealerów / 1 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 1 / Etykieta.",
                },
                drugAdvancedContactNetworkDealerOffersItem1MinTrust = {
                    label = "Sieć kontaktów / Oferty dealerów / 1 / Minimalne zaufanie",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 1 / Minimalne zaufanie.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Price = {
                    label = "Sieć kontaktów / Oferty dealerów / 1 / Cena",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 1 / Cena.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Id = {
                    label = "Sieć kontaktów / Oferty dealerów / 2 / ID",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 2 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Item = {
                    label = "Sieć kontaktów / Oferty dealerów / 2 / Przedmiot",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 2 / Przedmiot.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Label = {
                    label = "Sieć kontaktów / Oferty dealerów / 2 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 2 / Etykieta.",
                },
                drugAdvancedContactNetworkDealerOffersItem2MinTrust = {
                    label = "Sieć kontaktów / Oferty dealerów / 2 / Minimalne zaufanie",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 2 / Minimalne zaufanie.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Price = {
                    label = "Sieć kontaktów / Oferty dealerów / 2 / Cena",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 2 / Cena.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Id = {
                    label = "Sieć kontaktów / Oferty dealerów / 3 / ID",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 3 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Item = {
                    label = "Sieć kontaktów / Oferty dealerów / 3 / Przedmiot",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 3 / Przedmiot.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Label = {
                    label = "Sieć kontaktów / Oferty dealerów / 3 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 3 / Etykieta.",
                },
                drugAdvancedContactNetworkDealerOffersItem3MinTrust = {
                    label = "Sieć kontaktów / Oferty dealerów / 3 / Minimalne zaufanie",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 3 / Minimalne zaufanie.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Price = {
                    label = "Sieć kontaktów / Oferty dealerów / 3 / Cena",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 3 / Cena.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Id = {
                    label = "Sieć kontaktów / Oferty dealerów / 4 / ID",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 4 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Item = {
                    label = "Sieć kontaktów / Oferty dealerów / 4 / Przedmiot",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 4 / Przedmiot.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Label = {
                    label = "Sieć kontaktów / Oferty dealerów / 4 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 4 / Etykieta.",
                },
                drugAdvancedContactNetworkDealerOffersItem4MinTrust = {
                    label = "Sieć kontaktów / Oferty dealerów / 4 / Minimalne zaufanie",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 4 / Minimalne zaufanie.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Price = {
                    label = "Sieć kontaktów / Oferty dealerów / 4 / Cena",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 4 / Cena.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Id = {
                    label = "Sieć kontaktów / Oferty dealerów / 5 / ID",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 5 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Item = {
                    label = "Sieć kontaktów / Oferty dealerów / 5 / Przedmiot",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 5 / Przedmiot.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Label = {
                    label = "Sieć kontaktów / Oferty dealerów / 5 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 5 / Etykieta.",
                },
                drugAdvancedContactNetworkDealerOffersItem5MinTrust = {
                    label = "Sieć kontaktów / Oferty dealerów / 5 / Minimalne zaufanie",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 5 / Minimalne zaufanie.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Price = {
                    label = "Sieć kontaktów / Oferty dealerów / 5 / Cena",
                    description = "Ustawienie działania dla: Sieć kontaktów / Oferty dealerów / 5 / Cena.",
                },
                drugAdvancedContactNetworkDealerProtectionHours = {
                    label = "Sieć kontaktów / Dystrybutor / Ochrona / Godziny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Ochrona / Godziny.",
                },
                drugAdvancedContactNetworkDealerProtectionPrice = {
                    label = "Sieć kontaktów / Dystrybutor / Ochrona / Cena",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Ochrona / Cena.",
                },
                drugAdvancedContactNetworkDealerSaleMax = {
                    label = "Sieć kontaktów / Dystrybutor / Sprzedaż / Maksimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Sprzedaż / Maksimum.",
                },
                drugAdvancedContactNetworkDealerSaleMin = {
                    label = "Sieć kontaktów / Dystrybutor / Sprzedaż / Minimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Sprzedaż / Minimum.",
                },
                drugAdvancedContactNetworkDealerSimulationAggressivePriceMultiplier = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Tryb agresywny / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Tryb agresywny / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkDealerSimulationBaseQualityPriceFactor = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Jakość bazowa / Współczynnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Jakość bazowa / Współczynnik ceny.",
                },
                drugAdvancedContactNetworkDealerSimulationBulkPriceMultiplier = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Hurtowa / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Hurtowa / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkDealerSimulationCheapPriceMultiplier = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Tanie sprzedaże / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Tanie sprzedaże / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkDealerSimulationDefaultQuality = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Wartość domyślna / Jakość",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Wartość domyślna / Jakość.",
                },
                drugAdvancedContactNetworkDealerSimulationDisloyalThreshold = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Próg nielojalności",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Próg nielojalności.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerLevel = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Doświadczenie / Na poziom",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Doświadczenie / Na poziom.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerUnit = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Doświadczenie / Na jednostkę",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Doświadczenie / Na jednostkę.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentLoyaltyLoss = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Incydent / Lojalność / Strata",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Incydent / Lojalność / Strata.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentRollMaximum = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Incydent / Losowanie / Maksimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Incydent / Losowanie / Maksimum.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelPriceBonus = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Poziom / Cena / Premia",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Poziom / Cena / Premia.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelSaleDivisor = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Poziom / Sprzedaż / Dzielnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Poziom / Sprzedaż / Dzielnik.",
                },
                drugAdvancedContactNetworkDealerSimulationLoyaltyRiskWeight = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Lojalność / Ryzyko / Waga",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Lojalność / Ryzyko / Waga.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumIncidentChance = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Maksimum / Incydent / Szansa",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Maksimum / Incydent / Szansa.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumLevel = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Maksimum / Poziom",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Maksimum / Poziom.",
                },
                drugAdvancedContactNetworkDealerSimulationPremiumPriceMultiplier = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Premium / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Premium / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkDealerSimulationProfileRiskWeight = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Profil / Ryzyko / Waga",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Profil / Ryzyko / Waga.",
                },
                drugAdvancedContactNetworkDealerSimulationProtectionRiskReduction = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Ochrona / Ryzyko / Redukcja",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Ochrona / Ryzyko / Redukcja.",
                },
                drugAdvancedContactNetworkDealerSimulationQualityPriceDivisor = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Jakość / Cena / Dzielnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Jakość / Cena / Dzielnik.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryBaseChance = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Regeneracja / Wartość bazowa / Szansa",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Regeneracja / Wartość bazowa / Szansa.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryLoyaltyWeight = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Regeneracja / Lojalność / Waga",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Regeneracja / Lojalność / Waga.",
                },
                drugAdvancedContactNetworkDealerSimulationRobbedStockLoss = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Utrata zapasów przez napad",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Utrata zapasów przez napad.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillRiskReduction = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Umiejętność / Ryzyko / Redukcja",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Umiejętność / Ryzyko / Redukcja.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillSaleDivisor = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Umiejętność / Sprzedaż / Dzielnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Umiejętność / Sprzedaż / Dzielnik.",
                },
                drugAdvancedContactNetworkDealerSimulationStableLoyaltyThreshold = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Próg stabilnej lojalności",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Próg stabilnej lojalności.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryPriceMultiplier = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Terytorium / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Terytorium / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryRiskReduction = {
                    label = "Sieć kontaktów / Dystrybutor / Symulacja / Terytorium / Ryzyko / Redukcja",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Symulacja / Terytorium / Ryzyko / Redukcja.",
                },
                drugAdvancedContactNetworkDealerTickMinutes = {
                    label = "Sieć kontaktów / Dystrybutor / Cykl aktualizacji / Minuty",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Cykl aktualizacji / Minuty.",
                },
                drugAdvancedContactNetworkDealerWage = {
                    label = "Sieć kontaktów / Dystrybutor / Stawka",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Stawka.",
                },
                drugAdvancedContactNetworkDealerWageDecay = {
                    label = "Sieć kontaktów / Dystrybutor / Stawka / Degradacja",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Stawka / Degradacja.",
                },
                drugAdvancedContactNetworkDealerWageLoyaltyGain = {
                    label = "Sieć kontaktów / Dystrybutor / Stawka / Lojalność / zysk",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Stawka / Lojalność / zysk.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem1 = {
                    label = "Sieć kontaktów / Dystrybutor / Słabości / 1",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Słabości / 1.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem2 = {
                    label = "Sieć kontaktów / Dystrybutor / Słabości / 2",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Słabości / 2.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem3 = {
                    label = "Sieć kontaktów / Dystrybutor / Słabości / 3",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Słabości / 3.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem4 = {
                    label = "Sieć kontaktów / Dystrybutor / Słabości / 4",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Słabości / 4.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem5 = {
                    label = "Sieć kontaktów / Dystrybutor / Słabości / 5",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dystrybutor / Słabości / 5.",
                },
                drugAdvancedContactNetworkDefaultContactDemand = {
                    label = "Sieć kontaktów / Wartość domyślna / Kontakt / Popyt",
                    description = "Ustawienie działania dla: Sieć kontaktów / Wartość domyślna / Kontakt / Popyt.",
                },
                drugAdvancedContactNetworkDefaultContactRisk = {
                    label = "Sieć kontaktów / Wartość domyślna / Kontakt / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Wartość domyślna / Kontakt / Ryzyko.",
                },
                drugAdvancedContactNetworkDefaultDealerCapacity = {
                    label = "Sieć kontaktów / Domyślny diler / pojemność",
                    description = "Ustawienie działania dla: Sieć kontaktów / Domyślny diler / pojemność.",
                },
                drugAdvancedContactNetworkDefaultDealerRisk = {
                    label = "Sieć kontaktów / Domyślny diler / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Domyślny diler / Ryzyko.",
                },
                drugAdvancedContactNetworkDefaultDealerSkill = {
                    label = "Sieć kontaktów / Domyślny diler / Umiejętność",
                    description = "Ustawienie działania dla: Sieć kontaktów / Domyślny diler / Umiejętność.",
                },
                drugAdvancedContactNetworkDefaultHotspotRadius = {
                    label = "Sieć kontaktów / Wartość domyślna / Punkt aktywności / Promień",
                    description = "Ustawienie działania dla: Sieć kontaktów / Wartość domyślna / Punkt aktywności / Promień.",
                },
                drugAdvancedContactNetworkDemandResetMinutes = {
                    label = "Sieć kontaktów / Resetowanie popytu (minuty)",
                    description = "Ustawienie działania dla: Sieć kontaktów / Resetowanie popytu (minuty).",
                },
                drugAdvancedContactNetworkEnabled = {
                    label = "Sieć kontaktów / Włączone",
                    description = "Ustawienie działania dla: Sieć kontaktów / Włączone.",
                },
                drugAdvancedContactNetworkExactLocationTrust = {
                    label = "Sieć kontaktów / Dokładna lokalizacja / Zaufanie",
                    description = "Ustawienie działania dla: Sieć kontaktów / Dokładna lokalizacja / Zaufanie.",
                },
                drugAdvancedContactNetworkFactionDiscoveryReputation = {
                    label = "Sieć kontaktów / Frakcja / Odkrycie / Reputacja",
                    description = "Ustawienie działania dla: Sieć kontaktów / Frakcja / Odkrycie / Reputacja.",
                },
                drugAdvancedContactNetworkFactionHintTrust = {
                    label = "Sieć kontaktów / Frakcja / Wskazówka / Zaufanie",
                    description = "Ustawienie działania dla: Sieć kontaktów / Frakcja / Wskazówka / Zaufanie.",
                },
                drugAdvancedContactNetworkFailedDeliveryCooldownMinutes = {
                    label = "Sieć kontaktów / Nieudana dostawa / Minuty odnowienia",
                    description = "Ustawienie działania dla: Sieć kontaktów / Nieudana dostawa / Minuty odnowienia.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerCount = {
                    label = "Sieć kontaktów / Fałszywa transakcja / Spotkanie / Napastnik / Liczba",
                    description = "Ustawienie działania dla: Sieć kontaktów / Fałszywa transakcja / Spotkanie / Napastnik / Liczba.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem1 = {
                    label = "Sieć kontaktów / Fałszywa transakcja / Spotkanie / Napastnik / Modele / 1",
                    description = "Ustawienie działania dla: Sieć kontaktów / Fałszywa transakcja / Spotkanie / Napastnik / Modele / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem2 = {
                    label = "Sieć kontaktów / Fałszywa transakcja / Spotkanie / Napastnik / Modele / 2",
                    description = "Ustawienie działania dla: Sieć kontaktów / Fałszywa transakcja / Spotkanie / Napastnik / Modele / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem3 = {
                    label = "Sieć kontaktów / Fałszywa transakcja / Spotkanie / Napastnik / Modele / 3",
                    description = "Ustawienie działania dla: Sieć kontaktów / Fałszywa transakcja / Spotkanie / Napastnik / Modele / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterDurationSeconds = {
                    label = "Sieć kontaktów / Fałszywa transakcja / Spotkanie / Czas trwania (sekundy)",
                    description = "Ustawienie działania dla: Sieć kontaktów / Fałszywa transakcja / Spotkanie / Czas trwania (sekundy).",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem1 = {
                    label = "Sieć kontaktów / Fałszywa transakcja / Spotkanie / Policja / Modele / 1",
                    description = "Ustawienie działania dla: Sieć kontaktów / Fałszywa transakcja / Spotkanie / Policja / Modele / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem2 = {
                    label = "Sieć kontaktów / Fałszywa transakcja / Spotkanie / Policja / Modele / 2",
                    description = "Ustawienie działania dla: Sieć kontaktów / Fałszywa transakcja / Spotkanie / Policja / Modele / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem3 = {
                    label = "Sieć kontaktów / Fałszywa transakcja / Spotkanie / Policja / Modele / 3",
                    description = "Ustawienie działania dla: Sieć kontaktów / Fałszywa transakcja / Spotkanie / Policja / Modele / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterSpawnRadius = {
                    label = "Sieć kontaktów / Fałszywa transakcja / Spotkanie / Promień spawnu",
                    description = "Ustawienie działania dla: Sieć kontaktów / Fałszywa transakcja / Spotkanie / Promień spawnu.",
                },
                drugAdvancedContactNetworkFallbackPreferredDrug = {
                    label = "Sieć kontaktów / Wartość zastępcza / Preferowana droga",
                    description = "Ustawienie działania dla: Sieć kontaktów / Wartość zastępcza / Preferowana droga.",
                },
                drugAdvancedContactNetworkFallbackProductLabel = {
                    label = "Sieć kontaktów / Wartość zastępcza / Nazwa produktu",
                    description = "Ustawienie działania dla: Sieć kontaktów / Wartość zastępcza / Nazwa produktu.",
                },
                drugAdvancedContactNetworkGuideBookItem = {
                    label = "Sieć kontaktów / Poradnik / Książka / Przedmiot",
                    description = "Ustawienie działania dla: Sieć kontaktów / Poradnik / Książka / Przedmiot.",
                },
                drugAdvancedContactNetworkGuideBookTrust = {
                    label = "Sieć kontaktów / Poradnik / Książka / Zaufanie",
                    description = "Ustawienie działania dla: Sieć kontaktów / Poradnik / Książka / Zaufanie.",
                },
                drugAdvancedContactNetworkHireDealerPrice = {
                    label = "Sieć kontaktów / Zatrudnij dealera / Cena",
                    description = "Ustawienie działania dla: Sieć kontaktów / Zatrudnij dealera / Cena.",
                },
                drugAdvancedContactNetworkHistoryLimit = {
                    label = "Sieć kontaktów / Limit historii",
                    description = "Ustawienie działania dla: Sieć kontaktów / Limit historii.",
                },
                drugAdvancedContactNetworkHotspotIntelMinutes = {
                    label = "Sieć kontaktów / Punkt aktywności / Informacje / Minuty",
                    description = "Ustawienie działania dla: Sieć kontaktów / Punkt aktywności / Informacje / Minuty.",
                },
                drugAdvancedContactNetworkHotspotRotationMinutes = {
                    label = "Sieć kontaktów / Punkt aktywności / Rotacja / Minuty",
                    description = "Ustawienie działania dla: Sieć kontaktów / Punkt aktywności / Rotacja / Minuty.",
                },
                drugAdvancedContactNetworkListingDurationMinutes = {
                    label = "Sieć kontaktów / Ogłoszenie / Czas trwania / Minuty",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ogłoszenie / Czas trwania / Minuty.",
                },
                drugAdvancedContactNetworkMaxOwnedDealers = {
                    label = "Sieć kontaktów / Maksimum / Własność / Dilerzy",
                    description = "Ustawienie działania dla: Sieć kontaktów / Maksimum / Własność / Dilerzy.",
                },
                drugAdvancedContactNetworkMinimumBuyerDeliveryDistance = {
                    label = "Sieć kontaktów / Minimum / Kupiec / Odległość dostawy",
                    description = "Ustawienie działania dla: Sieć kontaktów / Minimum / Kupiec / Odległość dostawy.",
                },
                drugAdvancedContactNetworkMinimumContactRotationMinutes = {
                    label = "Sieć kontaktów / Minimum / Rotacja kontaktów (minuty)",
                    description = "Ustawienie działania dla: Sieć kontaktów / Minimum / Rotacja kontaktów (minuty).",
                },
                drugAdvancedContactNetworkMinimumDemandResetMinutes = {
                    label = "Sieć kontaktów / Minimum / Resetowanie popytu (minuty)",
                    description = "Ustawienie działania dla: Sieć kontaktów / Minimum / Resetowanie popytu (minuty).",
                },
                drugAdvancedContactNetworkMinimumHeatMultiplier = {
                    label = "Sieć kontaktów / Minimum / Presja policji / Mnożnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Minimum / Presja policji / Mnożnik.",
                },
                drugAdvancedContactNetworkMinimumHotspotIntelMinutes = {
                    label = "Sieć kontaktów / Minimum / Punkt aktywności / Informacje / Minuty",
                    description = "Ustawienie działania dla: Sieć kontaktów / Minimum / Punkt aktywności / Informacje / Minuty.",
                },
                drugAdvancedContactNetworkMinimumHotspotRadius = {
                    label = "Sieć kontaktów / Minimum / Punkt aktywności / Promień",
                    description = "Ustawienie działania dla: Sieć kontaktów / Minimum / Punkt aktywności / Promień.",
                },
                drugAdvancedContactNetworkMinimumHotspotRotationMinutes = {
                    label = "Sieć kontaktów / Minimum / Punkt aktywności / Rotacja / Minuty",
                    description = "Ustawienie działania dla: Sieć kontaktów / Minimum / Punkt aktywności / Rotacja / Minuty.",
                },
                drugAdvancedContactNetworkMinimumListingDurationMinutes = {
                    label = "Sieć kontaktów / Minimum / Ogłoszenie / Czas trwania / Minuty",
                    description = "Ustawienie działania dla: Sieć kontaktów / Minimum / Ogłoszenie / Czas trwania / Minuty.",
                },
                drugAdvancedContactNetworkMinimumRewardMultiplier = {
                    label = "Sieć kontaktów / Minimalna nagroda / Mnożnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Minimalna nagroda / Mnożnik.",
                },
                drugAdvancedContactNetworkMinimumRobberyMultiplier = {
                    label = "Sieć kontaktów / Minimum / Napady / Mnożnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Minimum / Napady / Mnożnik.",
                },
                drugAdvancedContactNetworkMinimumSpotPriceMultiplier = {
                    label = "Sieć kontaktów / Minimum / Lokalizacja / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Minimum / Lokalizacja / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkOtherDrugPriceMultiplier = {
                    label = "Sieć kontaktów / Inne / Narkotyk / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Inne / Narkotyk / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkPaymentAccount = {
                    label = "Sieć kontaktów / Konto płatnicze",
                    description = "Ustawienie działania dla: Sieć kontaktów / Konto płatnicze.",
                },
                drugAdvancedContactNetworkPostDeliveryDemandResetSeconds = {
                    label = "Sieć kontaktów / Po dostawie / Popyt / Reset / sekundy",
                    description = "Ustawienie działania dla: Sieć kontaktów / Po dostawie / Popyt / Reset / sekundy.",
                },
                drugAdvancedContactNetworkPreferredDrugPriceMultiplier = {
                    label = "Sieć kontaktów / Preferowana droga / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Preferowana droga / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkRegionLocationTrust = {
                    label = "Sieć kontaktów / Region / Lokalizacja / Zaufanie",
                    description = "Ustawienie działania dla: Sieć kontaktów / Region / Lokalizacja / Zaufanie.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMax = {
                    label = "Sieć kontaktów / Żądanie / Ilości / Hurtowa / Maksimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Żądanie / Ilości / Hurtowa / Maksimum.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMin = {
                    label = "Sieć kontaktów / Żądanie / Ilości / Hurtowa / Minimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Żądanie / Ilości / Hurtowa / Minimum.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMax = {
                    label = "Sieć kontaktów / Żądanie / Ilości / Premium / Maksimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Żądanie / Ilości / Premium / Maksimum.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMin = {
                    label = "Sieć kontaktów / Żądanie / Ilości / Premium / Minimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Żądanie / Ilości / Premium / Minimum.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMax = {
                    label = "Sieć kontaktów / Żądanie / Ilości / Standardowy / Maksimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Żądanie / Ilości / Standardowy / Maksimum.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMin = {
                    label = "Sieć kontaktów / Żądanie / Ilości / Standardowy / Minimum",
                    description = "Ustawienie działania dla: Sieć kontaktów / Żądanie / Ilości / Standardowy / Minimum.",
                },
                drugAdvancedContactNetworkRotationMinutes = {
                    label = "Sieć kontaktów / Rotacja / Minuty",
                    description = "Ustawienie działania dla: Sieć kontaktów / Rotacja / Minuty.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 1 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 1 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 1 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 1 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 1 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 1 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 1 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 1 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 1 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 1 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 1 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 1 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 1 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 1 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 1 / Ryzyko.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 2 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 2 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 2 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 2 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 2 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 2 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 2 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 2 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 2 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 2 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 2 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 2 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 2 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 2 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 2 / Ryzyko.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 3 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 3 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 3 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 3 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 3 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 3 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 3 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 3 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 3 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 3 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 3 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 3 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 3 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 3 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler uliczny / 3 / Ryzyko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 1 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 1 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 1 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 1 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 1 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 1 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 1 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 1 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 1 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 1 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 1 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 1 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 1 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 1 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 1 / Ryzyko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 2 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 2 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 2 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 2 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 2 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 2 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 2 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 2 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 2 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 2 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 2 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 2 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 2 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 2 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 2 / Ryzyko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 3 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 3 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 3 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 3 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 3 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 3 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 3 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 3 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 3 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 3 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 3 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 3 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 3 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 3 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny kupiec / 3 / Ryzyko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 1 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 1 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 1 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 1 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 1 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 1 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 1 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 1 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 1 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 1 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 1 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 1 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 1 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 1 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 1 / Ryzyko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 2 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 2 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 2 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 2 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 2 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 2 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 2 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 2 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 2 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 2 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 2 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 2 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 2 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 2 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 2 / Ryzyko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 3 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 3 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 3 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 3 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 3 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 3 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 3 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 3 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 3 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 3 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 3 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 3 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 3 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 3 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Domyślny diler / 3 / Ryzyko.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 1 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 1 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 1 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 1 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 1 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 1 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 1 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 1 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 1 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 1 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 1 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 1 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 1 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 1 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 1 / Ryzyko.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 2 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 2 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 2 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 2 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 2 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 2 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 2 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 2 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 2 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 2 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 2 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 2 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 2 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 2 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 2 / Ryzyko.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 3 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 3 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 3 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 3 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 3 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 3 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 3 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 3 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 3 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 3 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 3 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 3 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 3 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 3 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Diler sieci / 3 / Ryzyko.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 1 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 1 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 1 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 1 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 1 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 1 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 1 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 1 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 1 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 1 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 1 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 1 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 1 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 1 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 1 / Ryzyko.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 2 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 2 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 2 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 2 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 2 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 2 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 2 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 2 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 2 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 2 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 2 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 2 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 2 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 2 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 2 / Ryzyko.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 3 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 3 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 3 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 3 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 3 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 3 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 3 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 3 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 3 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 3 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 3 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 3 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 3 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 3 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Pośrednik premium / 3 / Ryzyko.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 1 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 1 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 1 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 1 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 1 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 1 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 1 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 1 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 1 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 1 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 1 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 1 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 1 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 1 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 1 / Ryzyko.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 2 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 2 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 2 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 2 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 2 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 2 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 2 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 2 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 2 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 2 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 2 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 2 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 2 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 2 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 2 / Ryzyko.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsX = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 3 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 3 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsY = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 3 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 3 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsZ = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 3 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 3 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsW = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 3 / Współrzędne / W",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 3 / Współrzędne / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Label = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 3 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 3 / Etykieta.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3PriceMultiplier = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 3 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 3 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Region = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 3 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Risk = {
                    label = "Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 3 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć kontaktów / Lokalizacja / Pule wyboru / Kontakt hurtowy / 3 / Ryzyko.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1AcceptBonus = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 1 / Premia za akceptację",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 1 / Premia za akceptację.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Archetype = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 1 / Archetyp",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 1 / Archetyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsX = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 1 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 1 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsY = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 1 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 1 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsZ = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 1 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 1 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1DemandBonus = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 1 / Bonus do popytu",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 1 / Bonus do popytu.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1HeatMultiplier = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 1 / Presja policji / Mnożnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 1 / Presja policji / Mnożnik.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Id = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 1 / ID",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 1 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Label = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 1 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 1 / Etykieta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem1 = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 1 / Preferowane narkotyki / 1",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 1 / Preferowane narkotyki / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem2 = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 1 / Preferowane narkotyki / 2",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 1 / Preferowane narkotyki / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem3 = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 1 / Preferowane narkotyki / 3",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 1 / Preferowane narkotyki / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem4 = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 1 / Preferowane narkotyki / 4",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 1 / Preferowane narkotyki / 4.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PriceMultiplier = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 1 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 1 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Radius = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 1 / Promień",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 1 / Promień.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Region = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 1 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 1 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1RobberyMultiplier = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 1 / Napady / Mnożnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 1 / Napady / Mnożnik.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2AcceptBonus = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 2 / Premia za akceptację",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 2 / Premia za akceptację.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Archetype = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 2 / Archetyp",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 2 / Archetyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsX = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 2 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 2 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsY = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 2 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 2 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsZ = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 2 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 2 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2DemandBonus = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 2 / Bonus do popytu",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 2 / Bonus do popytu.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2HeatMultiplier = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 2 / Presja policji / Mnożnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 2 / Presja policji / Mnożnik.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Id = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 2 / ID",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 2 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Label = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 2 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 2 / Etykieta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2MinimumQuality = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 2 / Minimalna jakość",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 2 / Minimalna jakość.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem1 = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 2 / Preferowane narkotyki / 1",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 2 / Preferowane narkotyki / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem2 = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 2 / Preferowane narkotyki / 2",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 2 / Preferowane narkotyki / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PriceMultiplier = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 2 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 2 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Radius = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 2 / Promień",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 2 / Promień.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Region = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 2 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 2 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2RobberyMultiplier = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 2 / Napady / Mnożnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 2 / Napady / Mnożnik.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3AcceptBonus = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 3 / Premia za akceptację",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 3 / Premia za akceptację.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Archetype = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 3 / Archetyp",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 3 / Archetyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsX = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 3 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 3 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsY = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 3 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 3 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsZ = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 3 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 3 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3DemandBonus = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 3 / Bonus do popytu",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 3 / Bonus do popytu.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3HeatMultiplier = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 3 / Presja policji / Mnożnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 3 / Presja policji / Mnożnik.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Id = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 3 / ID",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 3 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Label = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 3 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 3 / Etykieta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem1 = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 3 / Preferowane narkotyki / 1",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 3 / Preferowane narkotyki / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem2 = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 3 / Preferowane narkotyki / 2",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 3 / Preferowane narkotyki / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem3 = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 3 / Preferowane narkotyki / 3",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 3 / Preferowane narkotyki / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PriceMultiplier = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 3 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 3 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Radius = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 3 / Promień",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 3 / Promień.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Region = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 3 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 3 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3RobberyMultiplier = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 3 / Napady / Mnożnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 3 / Napady / Mnożnik.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4AcceptBonus = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 4 / Premia za akceptację",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 4 / Premia za akceptację.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Archetype = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 4 / Archetyp",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 4 / Archetyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsX = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 4 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 4 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsY = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 4 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 4 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsZ = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 4 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 4 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4DemandBonus = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 4 / Bonus do popytu",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 4 / Bonus do popytu.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4HeatMultiplier = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 4 / Presja policji / Mnożnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 4 / Presja policji / Mnożnik.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Id = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 4 / ID",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 4 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Label = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 4 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 4 / Etykieta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem1 = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 4 / Preferowane narkotyki / 1",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 4 / Preferowane narkotyki / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem2 = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 4 / Preferowane narkotyki / 2",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 4 / Preferowane narkotyki / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem3 = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 4 / Preferowane narkotyki / 3",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 4 / Preferowane narkotyki / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PriceMultiplier = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 4 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 4 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Radius = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 4 / Promień",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 4 / Promień.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Region = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 4 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 4 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4RobberyMultiplier = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 4 / Napady / Mnożnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 4 / Napady / Mnożnik.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5AcceptBonus = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 5 / Premia za akceptację",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 5 / Premia za akceptację.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Archetype = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 5 / Archetyp",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 5 / Archetyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsX = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 5 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 5 / Współrzędne / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsY = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 5 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 5 / Współrzędne / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsZ = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 5 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 5 / Współrzędne / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5DemandBonus = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 5 / Bonus do popytu",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 5 / Bonus do popytu.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5HeatMultiplier = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 5 / Presja policji / Mnożnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 5 / Presja policji / Mnożnik.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Id = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 5 / ID",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 5 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Label = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 5 / Etykieta",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 5 / Etykieta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem1 = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 5 / Preferowane narkotyki / 1",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 5 / Preferowane narkotyki / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem2 = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 5 / Preferowane narkotyki / 2",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 5 / Preferowane narkotyki / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PriceMultiplier = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 5 / Mnożnik ceny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 5 / Mnożnik ceny.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Radius = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 5 / Promień",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 5 / Promień.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Region = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 5 / Region",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 5 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5RobberyMultiplier = {
                    label = "Sieć kontaktów / Ulica / Punkty aktywności / 5 / Napady / Mnożnik",
                    description = "Ustawienie działania dla: Sieć kontaktów / Ulica / Punkty aktywności / 5 / Napady / Mnożnik.",
                },
                drugAdvancedContactNetworkTrustLevelsKnown = {
                    label = "Sieć kontaktów / Zaufanie / Poziomy / Znany",
                    description = "Ustawienie działania dla: Sieć kontaktów / Zaufanie / Poziomy / Znany.",
                },
                drugAdvancedContactNetworkTrustLevelsReliable = {
                    label = "Sieć kontaktów / Zaufanie / Poziomy / Niezawodny",
                    description = "Ustawienie działania dla: Sieć kontaktów / Zaufanie / Poziomy / Niezawodny.",
                },
                drugAdvancedContactNetworkTrustLevelsTrusted = {
                    label = "Sieć kontaktów / Zaufanie / Poziomy / Zaufany",
                    description = "Ustawienie działania dla: Sieć kontaktów / Zaufanie / Poziomy / Zaufany.",
                },
                drugAdvancedBusinessNetworkActionCooldownSeconds = {
                    label = "Sieć firm / Czas odnowienia akcji / sekundy",
                    description = "Ustawienie działania dla: Sieć firm / Czas odnowienia akcji / sekundy.",
                },
                drugAdvancedBusinessNetworkBalanceBaseUnitPrice = {
                    label = "Sieć firm / Saldo / Wartość bazowa / Cena jednostkowa",
                    description = "Ustawienie działania dla: Sieć firm / Saldo / Wartość bazowa / Cena jednostkowa.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerDealer = {
                    label = "Sieć firm / Saldo / Poziom zagrożenia sieci / Na dilera",
                    description = "Ustawienie działania dla: Sieć firm / Saldo / Poziom zagrożenia sieci / Na dilera.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerHub = {
                    label = "Sieć firm / Saldo / Poziom zagrożenia sieci / Na centrum dystrybucji",
                    description = "Ustawienie działania dla: Sieć firm / Saldo / Poziom zagrożenia sieci / Na centrum dystrybucji.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerRoute = {
                    label = "Sieć firm / Saldo / Poziom zagrożenia sieci / Na trasę",
                    description = "Ustawienie działania dla: Sieć firm / Saldo / Poziom zagrożenia sieci / Na trasę.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerStaff = {
                    label = "Sieć firm / Saldo / Poziom zagrożenia sieci / Na pracownika",
                    description = "Ustawienie działania dla: Sieć firm / Saldo / Poziom zagrożenia sieci / Na pracownika.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityGain = {
                    label = "Sieć firm / Saldo / Niezawodność / zysk",
                    description = "Ustawienie działania dla: Sieć firm / Saldo / Niezawodność / zysk.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityLoss = {
                    label = "Sieć firm / Saldo / Niezawodność / Strata",
                    description = "Ustawienie działania dla: Sieć firm / Saldo / Niezawodność / Strata.",
                },
                drugAdvancedBusinessNetworkBalanceRouteHeatDecay = {
                    label = "Sieć firm / Saldo / Trasa / Presja policji / Degradacja",
                    description = "Ustawienie działania dla: Sieć firm / Saldo / Trasa / Presja policji / Degradacja.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / gang / Ilość / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / gang / Ilość / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / gang / Ilość / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / gang / Ilość / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangMinRank = {
                    label = "Sieć firm / Kontrakty / Kategorie / gang / Minimum / Stopień",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / gang / Minimum / Stopień.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / gang / Jakość / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / gang / Jakość / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / gang / Jakość / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / gang / Jakość / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / gang / Nagroda / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / gang / Nagroda / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / gang / Nagroda / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / gang / Nagroda / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / gang / Ryzyko / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / gang / Ryzyko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / gang / Ryzyko / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / gang / Ryzyko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Sieć NPC / Ilość / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Sieć NPC / Ilość / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Sieć NPC / Ilość / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Sieć NPC / Ilość / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkMinRank = {
                    label = "Sieć firm / Kontrakty / Kategorie / Sieć NPC / Minimum / Stopień",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Sieć NPC / Minimum / Stopień.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Sieć NPC / Jakość / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Sieć NPC / Jakość / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Sieć NPC / Jakość / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Sieć NPC / Jakość / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Sieć NPC / Nagroda / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Sieć NPC / Nagroda / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Sieć NPC / Nagroda / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Sieć NPC / Nagroda / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Sieć NPC / Ryzyko / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Sieć NPC / Ryzyko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Sieć NPC / Ryzyko / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Sieć NPC / Ryzyko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Organizacja / Ilość / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Organizacja / Ilość / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Organizacja / Ilość / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Organizacja / Ilość / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationMinRank = {
                    label = "Sieć firm / Kontrakty / Kategorie / Organizacja / Minimum / Stopień",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Organizacja / Minimum / Stopień.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Organizacja / Jakość / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Organizacja / Jakość / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Organizacja / Jakość / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Organizacja / Jakość / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Organizacja / Nagroda / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Organizacja / Nagroda / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Organizacja / Nagroda / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Organizacja / Nagroda / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Organizacja / Ryzyko / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Organizacja / Ryzyko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Organizacja / Ryzyko / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Organizacja / Ryzyko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Premium / Ilość / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Premium / Ilość / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Premium / Ilość / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Premium / Ilość / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumMinRank = {
                    label = "Sieć firm / Kontrakty / Kategorie / Premium / Minimum / Stopień",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Premium / Minimum / Stopień.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Premium / Jakość / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Premium / Jakość / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Premium / Jakość / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Premium / Jakość / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Premium / Nagroda / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Premium / Nagroda / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Premium / Nagroda / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Premium / Nagroda / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Premium / Ryzyko / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Premium / Ryzyko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Premium / Ryzyko / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Premium / Ryzyko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Handlarz / Ilość / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Handlarz / Ilość / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Handlarz / Ilość / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Handlarz / Ilość / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherMinRank = {
                    label = "Sieć firm / Kontrakty / Kategorie / Handlarz / Minimum / Stopień",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Handlarz / Minimum / Stopień.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Handlarz / Jakość / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Handlarz / Jakość / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Handlarz / Jakość / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Handlarz / Jakość / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Handlarz / Nagroda / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Handlarz / Nagroda / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Handlarz / Nagroda / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Handlarz / Nagroda / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Handlarz / Ryzyko / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Handlarz / Ryzyko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Handlarz / Ryzyko / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Handlarz / Ryzyko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Specjalne / Ilość / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Specjalne / Ilość / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Specjalne / Ilość / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Specjalne / Ilość / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialMinRank = {
                    label = "Sieć firm / Kontrakty / Kategorie / Specjalne / Minimum / Stopień",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Specjalne / Minimum / Stopień.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Specjalne / Jakość / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Specjalne / Jakość / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Specjalne / Jakość / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Specjalne / Jakość / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Specjalne / Nagroda / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Specjalne / Nagroda / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Specjalne / Nagroda / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Specjalne / Nagroda / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Specjalne / Ryzyko / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Specjalne / Ryzyko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Specjalne / Ryzyko / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Specjalne / Ryzyko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Hurtownia / Ilość / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Hurtownia / Ilość / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Hurtownia / Ilość / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Hurtownia / Ilość / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleMinRank = {
                    label = "Sieć firm / Kontrakty / Kategorie / Hurtownia / Minimum / Stopień",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Hurtownia / Minimum / Stopień.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Hurtownia / Jakość / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Hurtownia / Jakość / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Hurtownia / Jakość / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Hurtownia / Jakość / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Hurtownia / Nagroda / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Hurtownia / Nagroda / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Hurtownia / Nagroda / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Hurtownia / Nagroda / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem1 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Hurtownia / Ryzyko / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Hurtownia / Ryzyko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem2 = {
                    label = "Sieć firm / Kontrakty / Kategorie / Hurtownia / Ryzyko / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Kategorie / Hurtownia / Ryzyko / 2.",
                },
                drugAdvancedBusinessNetworkContractsDeliveryDistance = {
                    label = "Sieć firm / Kontrakty / Odległość dostawy",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Odległość dostawy.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMax = {
                    label = "Sieć firm / Kontrakty / Czas trwania / Minuty / Maksimum",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Czas trwania / Minuty / Maksimum.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMin = {
                    label = "Sieć firm / Kontrakty / Czas trwania / Minuty / Minimum",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Czas trwania / Minuty / Minimum.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsX = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 1 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 1 / Współrzędne / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsY = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 1 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 1 / Współrzędne / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsZ = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 1 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 1 / Współrzędne / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Id = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 1 / ID",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 1 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Label = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 1 / Etykieta",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 1 / Etykieta.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Region = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 1 / Region",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 1 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1RewardMultiplier = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 1 / Nagroda / Mnożnik",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 1 / Nagroda / Mnożnik.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Risk = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 1 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 1 / Ryzyko.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsX = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 2 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 2 / Współrzędne / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsY = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 2 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 2 / Współrzędne / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsZ = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 2 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 2 / Współrzędne / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Id = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 2 / ID",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 2 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Label = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 2 / Etykieta",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 2 / Etykieta.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Region = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 2 / Region",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 2 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2RewardMultiplier = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 2 / Nagroda / Mnożnik",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 2 / Nagroda / Mnożnik.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Risk = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 2 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 2 / Ryzyko.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsX = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 3 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 3 / Współrzędne / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsY = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 3 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 3 / Współrzędne / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsZ = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 3 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 3 / Współrzędne / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Id = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 3 / ID",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 3 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Label = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 3 / Etykieta",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 3 / Etykieta.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Region = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 3 / Region",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 3 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3RewardMultiplier = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 3 / Nagroda / Mnożnik",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 3 / Nagroda / Mnożnik.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Risk = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 3 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 3 / Ryzyko.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsX = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 4 / Współrzędne / X",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 4 / Współrzędne / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsY = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 4 / Współrzędne / Y",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 4 / Współrzędne / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsZ = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 4 / Współrzędne / Z",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 4 / Współrzędne / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Id = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 4 / ID",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 4 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Label = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 4 / Etykieta",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 4 / Etykieta.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Region = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 4 / Region",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 4 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4RewardMultiplier = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 4 / Nagroda / Mnożnik",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 4 / Nagroda / Mnożnik.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Risk = {
                    label = "Sieć firm / Kontrakty / Spotkanie / Punkty / 4 / Ryzyko",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Spotkanie / Punkty / 4 / Ryzyko.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem1 = {
                    label = "Sieć firm / Kontrakty / Negocjacja / Zaliczka / Opcje / 1",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Negocjacja / Zaliczka / Opcje / 1.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem2 = {
                    label = "Sieć firm / Kontrakty / Negocjacja / Zaliczka / Opcje / 2",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Negocjacja / Zaliczka / Opcje / 2.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem3 = {
                    label = "Sieć firm / Kontrakty / Negocjacja / Zaliczka / Opcje / 3",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Negocjacja / Zaliczka / Opcje / 3.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAmountFlexPercent = {
                    label = "Sieć firm / Kontrakty / Negocjacja / Ilość / Margines negocjacji / Procent",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Negocjacja / Ilość / Margines negocjacji / Procent.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationBaseAcceptance = {
                    label = "Sieć firm / Kontrakty / Negocjacja / Wartość bazowa / Akceptacja",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Negocjacja / Wartość bazowa / Akceptacja.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationDeadlineFlexPercent = {
                    label = "Sieć firm / Kontrakty / Negocjacja / Termin / Margines negocjacji / Procent",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Negocjacja / Termin / Margines negocjacji / Procent.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationMaxRounds = {
                    label = "Sieć firm / Kontrakty / Negocjacja / Maksimum / Rundy",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Negocjacja / Maksimum / Rundy.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationQualityFlex = {
                    label = "Sieć firm / Kontrakty / Negocjacja / Jakość / Margines negocjacji",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Negocjacja / Jakość / Margines negocjacji.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRejectionCooldownMinutes = {
                    label = "Sieć firm / Kontrakty / Negocjacja / Odrzucenie / Minuty odnowienia",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Negocjacja / Odrzucenie / Minuty odnowienia.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRoundPressure = {
                    label = "Sieć firm / Kontrakty / Negocjacja / Runda / Ciśnienie",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Negocjacja / Runda / Ciśnienie.",
                },
                drugAdvancedBusinessNetworkContractsOfferCount = {
                    label = "Sieć firm / Kontrakty / Oferta / Liczba",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Oferta / Liczba.",
                },
                drugAdvancedBusinessNetworkContractsRefreshMinutes = {
                    label = "Sieć firm / Kontrakty / Odświeżanie / Minuty",
                    description = "Ustawienie działania dla: Sieć firm / Kontrakty / Odświeżanie / Minuty.",
                },
                drugAdvancedBusinessNetworkDefaultBusinessName = {
                    label = "Sieć firm / Wartość domyślna / Nazwa firmy",
                    description = "Ustawienie działania dla: Sieć firm / Wartość domyślna / Nazwa firmy.",
                },
                drugAdvancedBusinessNetworkDefaultRankId = {
                    label = "Sieć firm / Wartość domyślna / Stopień / ID",
                    description = "Ustawienie działania dla: Sieć firm / Wartość domyślna / Stopień / ID.",
                },
                drugAdvancedBusinessNetworkDefaultStaffStyle = {
                    label = "Sieć firm / Wartość domyślna / Personel / Styl pracy",
                    description = "Ustawienie działania dla: Sieć firm / Wartość domyślna / Personel / Styl pracy.",
                },
                drugAdvancedBusinessNetworkDefaultTransport = {
                    label = "Sieć firm / Wartość domyślna / Transport",
                    description = "Ustawienie działania dla: Sieć firm / Wartość domyślna / Transport.",
                },
                drugAdvancedBusinessNetworkEnabled = {
                    label = "Sieć firm / Włączone",
                    description = "Ustawienie działania dla: Sieć firm / Włączone.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterCapacity = {
                    label = "Sieć firm / Centra dystrybucji / Centrum dystrybucji / pojemność",
                    description = "Ustawienie działania dla: Sieć firm / Centra dystrybucji / Centrum dystrybucji / pojemność.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterPurchasePrice = {
                    label = "Sieć firm / Centra dystrybucji / Centrum dystrybucji / Cena zakupu",
                    description = "Ustawienie działania dla: Sieć firm / Centra dystrybucji / Centrum dystrybucji / Cena zakupu.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterSecurity = {
                    label = "Sieć firm / Centra dystrybucji / Centrum dystrybucji / Bezpieczeństwo",
                    description = "Ustawienie działania dla: Sieć firm / Centra dystrybucji / Centrum dystrybucji / Bezpieczeństwo.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterUpkeep = {
                    label = "Sieć firm / Centra dystrybucji / Centrum dystrybucji / Utrzymanie",
                    description = "Ustawienie działania dla: Sieć firm / Centra dystrybucji / Centrum dystrybucji / Utrzymanie.",
                },
                drugAdvancedBusinessNetworkHubsStashCapacity = {
                    label = "Sieć firm / Centra dystrybucji / Skrytka / pojemność",
                    description = "Ustawienie działania dla: Sieć firm / Centra dystrybucji / Skrytka / pojemność.",
                },
                drugAdvancedBusinessNetworkHubsStashPurchasePrice = {
                    label = "Sieć firm / Centra dystrybucji / Skrytka / Cena zakupu",
                    description = "Ustawienie działania dla: Sieć firm / Centra dystrybucji / Skrytka / Cena zakupu.",
                },
                drugAdvancedBusinessNetworkHubsStashSecurity = {
                    label = "Sieć firm / Centra dystrybucji / Skrytka / Bezpieczeństwo",
                    description = "Ustawienie działania dla: Sieć firm / Centra dystrybucji / Skrytka / Bezpieczeństwo.",
                },
                drugAdvancedBusinessNetworkHubsStashUpkeep = {
                    label = "Sieć firm / Centra dystrybucji / Skrytka / Utrzymanie",
                    description = "Ustawienie działania dla: Sieć firm / Centra dystrybucji / Skrytka / Utrzymanie.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseCapacity = {
                    label = "Sieć firm / Centra dystrybucji / Magazyn / pojemność",
                    description = "Ustawienie działania dla: Sieć firm / Centra dystrybucji / Magazyn / pojemność.",
                },
                drugAdvancedBusinessNetworkHubsWarehousePurchasePrice = {
                    label = "Sieć firm / Centra dystrybucji / Magazyn / Cena zakupu",
                    description = "Ustawienie działania dla: Sieć firm / Centra dystrybucji / Magazyn / Cena zakupu.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseSecurity = {
                    label = "Sieć firm / Centra dystrybucji / Magazyn / Bezpieczeństwo",
                    description = "Ustawienie działania dla: Sieć firm / Centra dystrybucji / Magazyn / Bezpieczeństwo.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseUpkeep = {
                    label = "Sieć firm / Centra dystrybucji / Magazyn / Utrzymanie",
                    description = "Ustawienie działania dla: Sieć firm / Centra dystrybucji / Magazyn / Utrzymanie.",
                },
                drugAdvancedBusinessNetworkLimitsActiveContracts = {
                    label = "Sieć firm / Limity / Aktywne kontrakty",
                    description = "Ustawienie działania dla: Sieć firm / Limity / Aktywne kontrakty.",
                },
                drugAdvancedBusinessNetworkLimitsHubs = {
                    label = "Sieć firm / Limity / Centra dystrybucji",
                    description = "Ustawienie działania dla: Sieć firm / Limity / Centra dystrybucji.",
                },
                drugAdvancedBusinessNetworkLimitsLedgerRows = {
                    label = "Sieć firm / Limity / Księga rachunkowa / Wiersze",
                    description = "Ustawienie działania dla: Sieć firm / Limity / Księga rachunkowa / Wiersze.",
                },
                drugAdvancedBusinessNetworkLimitsRoutes = {
                    label = "Sieć firm / Limity / Trasy",
                    description = "Ustawienie działania dla: Sieć firm / Limity / Trasy.",
                },
                drugAdvancedBusinessNetworkLimitsStaff = {
                    label = "Sieć firm / Limity / Personel",
                    description = "Ustawienie działania dla: Sieć firm / Limity / Personel.",
                },
                drugAdvancedBusinessNetworkPayoutAccount = {
                    label = "Sieć firm / Wypłata / Konto",
                    description = "Ustawienie działania dla: Sieć firm / Wypłata / Konto.",
                },
                drugAdvancedBusinessNetworkRanksItem1Contracts = {
                    label = "Sieć firm / Rangi / 1 / Kontrakty",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 1 / Kontrakty.",
                },
                drugAdvancedBusinessNetworkRanksItem1Dealers = {
                    label = "Sieć firm / Rangi / 1 / Dilerzy",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 1 / Dilerzy.",
                },
                drugAdvancedBusinessNetworkRanksItem1Hubs = {
                    label = "Sieć firm / Rangi / 1 / Centra dystrybucji",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 1 / Centra dystrybucji.",
                },
                drugAdvancedBusinessNetworkRanksItem1Id = {
                    label = "Sieć firm / Rangi / 1 / ID",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 1 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem1Label = {
                    label = "Sieć firm / Rangi / 1 / Etykieta",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 1 / Etykieta.",
                },
                drugAdvancedBusinessNetworkRanksItem1Routes = {
                    label = "Sieć firm / Rangi / 1 / Trasy",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 1 / Trasy.",
                },
                drugAdvancedBusinessNetworkRanksItem1Score = {
                    label = "Sieć firm / Rangi / 1 / Wynik",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 1 / Wynik.",
                },
                drugAdvancedBusinessNetworkRanksItem1Staff = {
                    label = "Sieć firm / Rangi / 1 / Personel",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 1 / Personel.",
                },
                drugAdvancedBusinessNetworkRanksItem2Contracts = {
                    label = "Sieć firm / Rangi / 2 / Kontrakty",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 2 / Kontrakty.",
                },
                drugAdvancedBusinessNetworkRanksItem2Dealers = {
                    label = "Sieć firm / Rangi / 2 / Dilerzy",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 2 / Dilerzy.",
                },
                drugAdvancedBusinessNetworkRanksItem2Hubs = {
                    label = "Sieć firm / Rangi / 2 / Centra dystrybucji",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 2 / Centra dystrybucji.",
                },
                drugAdvancedBusinessNetworkRanksItem2Id = {
                    label = "Sieć firm / Rangi / 2 / ID",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 2 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem2Label = {
                    label = "Sieć firm / Rangi / 2 / Etykieta",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 2 / Etykieta.",
                },
                drugAdvancedBusinessNetworkRanksItem2Routes = {
                    label = "Sieć firm / Rangi / 2 / Trasy",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 2 / Trasy.",
                },
                drugAdvancedBusinessNetworkRanksItem2Score = {
                    label = "Sieć firm / Rangi / 2 / Wynik",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 2 / Wynik.",
                },
                drugAdvancedBusinessNetworkRanksItem2Staff = {
                    label = "Sieć firm / Rangi / 2 / Personel",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 2 / Personel.",
                },
                drugAdvancedBusinessNetworkRanksItem3Contracts = {
                    label = "Sieć firm / Rangi / 3 / Kontrakty",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 3 / Kontrakty.",
                },
                drugAdvancedBusinessNetworkRanksItem3Dealers = {
                    label = "Sieć firm / Rangi / 3 / Dilerzy",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 3 / Dilerzy.",
                },
                drugAdvancedBusinessNetworkRanksItem3Hubs = {
                    label = "Sieć firm / Rangi / 3 / Centra dystrybucji",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 3 / Centra dystrybucji.",
                },
                drugAdvancedBusinessNetworkRanksItem3Id = {
                    label = "Sieć firm / Rangi / 3 / ID",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 3 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem3Label = {
                    label = "Sieć firm / Rangi / 3 / Etykieta",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 3 / Etykieta.",
                },
                drugAdvancedBusinessNetworkRanksItem3Routes = {
                    label = "Sieć firm / Rangi / 3 / Trasy",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 3 / Trasy.",
                },
                drugAdvancedBusinessNetworkRanksItem3Score = {
                    label = "Sieć firm / Rangi / 3 / Wynik",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 3 / Wynik.",
                },
                drugAdvancedBusinessNetworkRanksItem3Staff = {
                    label = "Sieć firm / Rangi / 3 / Personel",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 3 / Personel.",
                },
                drugAdvancedBusinessNetworkRanksItem4Contracts = {
                    label = "Sieć firm / Rangi / 4 / Kontrakty",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 4 / Kontrakty.",
                },
                drugAdvancedBusinessNetworkRanksItem4Dealers = {
                    label = "Sieć firm / Rangi / 4 / Dilerzy",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 4 / Dilerzy.",
                },
                drugAdvancedBusinessNetworkRanksItem4Hubs = {
                    label = "Sieć firm / Rangi / 4 / Centra dystrybucji",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 4 / Centra dystrybucji.",
                },
                drugAdvancedBusinessNetworkRanksItem4Id = {
                    label = "Sieć firm / Rangi / 4 / ID",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 4 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem4Label = {
                    label = "Sieć firm / Rangi / 4 / Etykieta",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 4 / Etykieta.",
                },
                drugAdvancedBusinessNetworkRanksItem4Routes = {
                    label = "Sieć firm / Rangi / 4 / Trasy",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 4 / Trasy.",
                },
                drugAdvancedBusinessNetworkRanksItem4Score = {
                    label = "Sieć firm / Rangi / 4 / Wynik",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 4 / Wynik.",
                },
                drugAdvancedBusinessNetworkRanksItem4Staff = {
                    label = "Sieć firm / Rangi / 4 / Personel",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 4 / Personel.",
                },
                drugAdvancedBusinessNetworkRanksItem5Contracts = {
                    label = "Sieć firm / Rangi / 5 / Kontrakty",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 5 / Kontrakty.",
                },
                drugAdvancedBusinessNetworkRanksItem5Dealers = {
                    label = "Sieć firm / Rangi / 5 / Dilerzy",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 5 / Dilerzy.",
                },
                drugAdvancedBusinessNetworkRanksItem5Hubs = {
                    label = "Sieć firm / Rangi / 5 / Centra dystrybucji",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 5 / Centra dystrybucji.",
                },
                drugAdvancedBusinessNetworkRanksItem5Id = {
                    label = "Sieć firm / Rangi / 5 / ID",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 5 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem5Label = {
                    label = "Sieć firm / Rangi / 5 / Etykieta",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 5 / Etykieta.",
                },
                drugAdvancedBusinessNetworkRanksItem5Routes = {
                    label = "Sieć firm / Rangi / 5 / Trasy",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 5 / Trasy.",
                },
                drugAdvancedBusinessNetworkRanksItem5Score = {
                    label = "Sieć firm / Rangi / 5 / Wynik",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 5 / Wynik.",
                },
                drugAdvancedBusinessNetworkRanksItem5Staff = {
                    label = "Sieć firm / Rangi / 5 / Personel",
                    description = "Ustawienie działania dla: Sieć firm / Rangi / 5 / Personel.",
                },
                drugAdvancedBusinessNetworkReportDays = {
                    label = "Sieć firm / Okres raportu / dni",
                    description = "Ustawienie działania dla: Sieć firm / Okres raportu / dni.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesBuyer = {
                    label = "Sieć firm / Trasa / Punkt końcowy / Typy / Kupiec",
                    description = "Ustawienie działania dla: Sieć firm / Trasa / Punkt końcowy / Typy / Kupiec.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesContract = {
                    label = "Sieć firm / Trasa / Punkt końcowy / Typy / Umowa",
                    description = "Ustawienie działania dla: Sieć firm / Trasa / Punkt końcowy / Typy / Umowa.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesDealer = {
                    label = "Sieć firm / Trasa / Punkt końcowy / Typy / Dystrybutor",
                    description = "Ustawienie działania dla: Sieć firm / Trasa / Punkt końcowy / Typy / Dystrybutor.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesGang = {
                    label = "Sieć firm / Trasa / Punkt końcowy / Typy / gang",
                    description = "Ustawienie działania dla: Sieć firm / Trasa / Punkt końcowy / Typy / gang.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesHub = {
                    label = "Sieć firm / Trasa / Punkt końcowy / Typy / Centrum dystrybucji",
                    description = "Ustawienie działania dla: Sieć firm / Trasa / Punkt końcowy / Typy / Centrum dystrybucji.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesLab = {
                    label = "Sieć firm / Trasa / Punkt końcowy / Typy / Laboratorium",
                    description = "Ustawienie działania dla: Sieć firm / Trasa / Punkt końcowy / Typy / Laboratorium.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesOrganization = {
                    label = "Sieć firm / Trasa / Punkt końcowy / Typy / Organizacja",
                    description = "Ustawienie działania dla: Sieć firm / Trasa / Punkt końcowy / Typy / Organizacja.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesPusher = {
                    label = "Sieć firm / Trasa / Punkt końcowy / Typy / Handlarz",
                    description = "Ustawienie działania dla: Sieć firm / Trasa / Punkt końcowy / Typy / Handlarz.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMax = {
                    label = "Sieć firm / Działanie w grze / Umowa / Częstotliwość / Minuty / Maksimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Umowa / Częstotliwość / Minuty / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMin = {
                    label = "Sieć firm / Działanie w grze / Umowa / Częstotliwość / Minuty / Minimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Umowa / Częstotliwość / Minuty / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCooldownMinimumMinutes = {
                    label = "Sieć firm / Działanie w grze / Umowa / Czas odnowienia / Minimum / Minuty",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Umowa / Czas odnowienia / Minimum / Minuty.",
                },
                drugAdvancedBusinessNetworkRuntimeContractFailureReliabilityLoss = {
                    label = "Sieć firm / Działanie w grze / Umowa / Niepowodzenie / Niezawodność / Strata",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Umowa / Niepowodzenie / Niezawodność / Strata.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumCadenceMinutes = {
                    label = "Sieć firm / Działanie w grze / Umowa / Minimum / Częstotliwość / Minuty",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Umowa / Minimum / Częstotliwość / Minuty.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumMeetingMultiplier = {
                    label = "Sieć firm / Działanie w grze / Umowa / Minimum / Spotkanie / Mnożnik",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Umowa / Minimum / Spotkanie / Mnożnik.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyGrowth = {
                    label = "Sieć firm / Działanie w grze / Kara umowna / Wzrost",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Kara umowna / Wzrost.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyMultiplier = {
                    label = "Sieć firm / Działanie w grze / Kara umowna / Mnożnik",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Kara umowna / Mnożnik.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityFailureCooldownMinutes = {
                    label = "Sieć firm / Działanie w grze / Umowa / Jakość / Niepowodzenie / Minuty odnowienia",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Umowa / Jakość / Niepowodzenie / Minuty odnowienia.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceBase = {
                    label = "Sieć firm / Działanie w grze / Umowa / Jakość / Cena / Wartość bazowa",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Umowa / Jakość / Cena / Wartość bazowa.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceDivisor = {
                    label = "Sieć firm / Działanie w grze / Umowa / Jakość / Cena / Dzielnik",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Umowa / Jakość / Cena / Dzielnik.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossBase = {
                    label = "Sieć firm / Działanie w grze / Umowa / Niezawodność / Strata / Wartość bazowa",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Umowa / Niezawodność / Strata / Wartość bazowa.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossMaximum = {
                    label = "Sieć firm / Działanie w grze / Umowa / Niezawodność / Strata / Maksimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Umowa / Niezawodność / Strata / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossQualityWeight = {
                    label = "Sieć firm / Działanie w grze / Umowa / Niezawodność / Strata / Jakość / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Umowa / Niezawodność / Strata / Jakość / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReputationQualityWeight = {
                    label = "Sieć firm / Działanie w grze / Umowa / Reputacja / Jakość / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Umowa / Reputacja / Jakość / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsCategory = {
                    label = "Sieć firm / Działanie w grze / Umowa / Ryzyko / Wagi / Kategoria",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Umowa / Ryzyko / Wagi / Kategoria.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsMeeting = {
                    label = "Sieć firm / Działanie w grze / Umowa / Ryzyko / Wagi / Spotkanie",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Umowa / Ryzyko / Wagi / Spotkanie.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubCapacity = {
                    label = "Sieć firm / Działanie w grze / Wartość domyślna / Centrum dystrybucji / pojemność",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Wartość domyślna / Centrum dystrybucji / pojemność.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubSecurity = {
                    label = "Sieć firm / Działanie w grze / Wartość domyślna / Centrum dystrybucji / Bezpieczeństwo",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Wartość domyślna / Centrum dystrybucji / Bezpieczeństwo.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultMeetingRisk = {
                    label = "Sieć firm / Działanie w grze / Wartość domyślna / Spotkanie / Ryzyko",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Wartość domyślna / Spotkanie / Ryzyko.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultQuality = {
                    label = "Sieć firm / Działanie w grze / Wartość domyślna / Jakość",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Wartość domyślna / Jakość.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteCapacity = {
                    label = "Sieć firm / Działanie w grze / Wartość domyślna / Pojemność trasy",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Wartość domyślna / Pojemność trasy.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteIntervalMinutes = {
                    label = "Sieć firm / Działanie w grze / Wartość domyślna / Trasa / Interwał / Minuty",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Wartość domyślna / Trasa / Interwał / Minuty.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteRisk = {
                    label = "Sieć firm / Działanie w grze / Wartość domyślna / Trasa / Ryzyko",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Wartość domyślna / Trasa / Ryzyko.",
                },
                drugAdvancedBusinessNetworkRuntimeHubHeatDecay = {
                    label = "Sieć firm / Działanie w grze / Centrum dystrybucji / Presja policji / Degradacja",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Centrum dystrybucji / Presja policji / Degradacja.",
                },
                drugAdvancedBusinessNetworkRuntimeHubLoadHeat = {
                    label = "Sieć firm / Działanie w grze / Centrum dystrybucji / Obciążenie / Presja policji",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Centrum dystrybucji / Obciążenie / Presja policji.",
                },
                drugAdvancedBusinessNetworkRuntimeHubRaidRecoveryMinutes = {
                    label = "Sieć firm / Działanie w grze / Centrum dystrybucji / Napad / Regeneracja / Minuty",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Centrum dystrybucji / Napad / Regeneracja / Minuty.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostBase = {
                    label = "Sieć firm / Działanie w grze / Centrum dystrybucji / Bezpieczeństwo / Koszt / Wartość bazowa",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Centrum dystrybucji / Bezpieczeństwo / Koszt / Wartość bazowa.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostPerLevel = {
                    label = "Sieć firm / Działanie w grze / Centrum dystrybucji / Bezpieczeństwo / Koszt / Na poziom",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Centrum dystrybucji / Bezpieczeństwo / Koszt / Na poziom.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityMaximum = {
                    label = "Sieć firm / Działanie w grze / Centrum dystrybucji / Bezpieczeństwo / Maksimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Centrum dystrybucji / Bezpieczeństwo / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityUpgrade = {
                    label = "Sieć firm / Działanie w grze / Centrum dystrybucji / Bezpieczeństwo / Ulepszenie",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Centrum dystrybucji / Bezpieczeństwo / Ulepszenie.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidHeat = {
                    label = "Sieć firm / Działanie w grze / Centrum dystrybucji / Brak płatności / Presja policji",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Centrum dystrybucji / Brak płatności / Presja policji.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidSecurityLoss = {
                    label = "Sieć firm / Działanie w grze / Centrum dystrybucji / Brak płatności / Bezpieczeństwo / Strata",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Centrum dystrybucji / Brak płatności / Bezpieczeństwo / Strata.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUpkeepIntervalHours = {
                    label = "Sieć firm / Działanie w grze / Centrum dystrybucji / Utrzymanie / Interwał / Godziny",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Centrum dystrybucji / Utrzymanie / Interwał / Godziny.",
                },
                drugAdvancedBusinessNetworkRuntimeInitialReliability = {
                    label = "Sieć firm / Działanie w grze / Wartość początkowa / Niezawodność",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Wartość początkowa / Niezawodność.",
                },
                drugAdvancedBusinessNetworkRuntimeMaximumBusinessNameLength = {
                    label = "Sieć firm / Działanie w grze / Maksimum / Nazwa firmy / Długość",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Maksimum / Nazwa firmy / Długość.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumContractDeliveryMinutes = {
                    label = "Sieć firm / Działanie w grze / Minimum / Umowa / Dostawa / Minuty",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Minimum / Umowa / Dostawa / Minuty.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumDeliveryDistance = {
                    label = "Sieć firm / Działanie w grze / Minimum / Odległość dostawy",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Minimum / Odległość dostawy.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumLedgerRows = {
                    label = "Sieć firm / Działanie w grze / Minimum / Księga rachunkowa / Wiersze",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Minimum / Księga rachunkowa / Wiersze.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumRouteIntervalMinutes = {
                    label = "Sieć firm / Działanie w grze / Minimum / Trasa / Interwał / Minuty",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Minimum / Trasa / Interwał / Minuty.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvanceCostWeight = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Zaliczka / Koszt / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Zaliczka / Koszt / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvancePriceWeight = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Zaliczka / Cena / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Zaliczka / Cena / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountCostWeight = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Ilość / Koszt / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Ilość / Koszt / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountFlexMaximum = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Ilość / Margines negocjacji / Maksimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Ilość / Margines negocjacji / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountRiskWeight = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Ilość / Ryzyko / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Ilość / Ryzyko / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationCounterOfferWeight = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Kontroferta / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Kontroferta / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationDeadlineFlexMaximum = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Termin / Margines negocjacji / Maksimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Termin / Margines negocjacji / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMaximumAcceptance = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Maksimum / Akceptacja",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Maksimum / Akceptacja.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMinimumAcceptance = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Minimum / Akceptacja",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Minimum / Akceptacja.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityBenefitWeight = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Jakość / Korzyść / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Jakość / Korzyść / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityCostWeight = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Jakość / Koszt / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Jakość / Koszt / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityFlexMaximum = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Jakość / Margines negocjacji / Maksimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Jakość / Margines negocjacji / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityRewardWeight = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Jakość / Nagroda / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Jakość / Nagroda / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReliabilityWeight = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Niezawodność / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Niezawodność / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReputationWeight = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Reputacja / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Reputacja / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMax = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Żądana nagroda / Maksimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Żądana nagroda / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMin = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Żądana nagroda / Minimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Żądana nagroda / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardCostWeight = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Nagroda / Koszt / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Nagroda / Koszt / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMax = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Nagroda / Maksimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Nagroda / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMin = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Nagroda / Minimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Nagroda / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBase = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Pilność / Wartość bazowa",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Pilność / Wartość bazowa.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBenefitWeight = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Pilność / Korzyść / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Pilność / Korzyść / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyRiskWeight = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Pilność / Ryzyko / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Pilność / Ryzyko / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyWeight = {
                    label = "Sieć firm / Działanie w grze / Negocjacja / Pilność / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Negocjacja / Pilność / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeOtherFailureHeat = {
                    label = "Sieć firm / Działanie w grze / Inne / Niepowodzenie / Presja policji",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Inne / Niepowodzenie / Presja policji.",
                },
                drugAdvancedBusinessNetworkRuntimePersonalHeatWeight = {
                    label = "Sieć firm / Działanie w grze / Osobiste zagrożenie / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Osobiste zagrożenie / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimePoliceFailureHeat = {
                    label = "Sieć firm / Działanie w grze / Policja / Niepowodzenie / Presja policji",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Policja / Niepowodzenie / Presja policji.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBaseUnits = {
                    label = "Sieć firm / Działanie w grze / Handlarz / Wartość bazowa / szt.",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Handlarz / Wartość bazowa / szt..",
                },
                drugAdvancedBusinessNetworkRuntimePusherBulkMultiplier = {
                    label = "Sieć firm / Działanie w grze / Handlarz / Hurtowa / Mnożnik",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Handlarz / Hurtowa / Mnożnik.",
                },
                drugAdvancedBusinessNetworkRuntimePusherCheapMultiplier = {
                    label = "Sieć firm / Działanie w grze / Handlarz / Tanie sprzedaże / Mnożnik",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Handlarz / Tanie sprzedaże / Mnożnik.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerLevel = {
                    label = "Sieć firm / Działanie w grze / Handlarz / Doświadczenie / Na poziom",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Handlarz / Doświadczenie / Na poziom.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerUnit = {
                    label = "Sieć firm / Działanie w grze / Handlarz / Doświadczenie / Na jednostkę",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Handlarz / Doświadczenie / Na jednostkę.",
                },
                drugAdvancedBusinessNetworkRuntimePusherHubHeatPerUnit = {
                    label = "Sieć firm / Działanie w grze / Handlarz / Centrum dystrybucji / Presja policji / Na jednostkę",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Handlarz / Centrum dystrybucji / Presja policji / Na jednostkę.",
                },
                drugAdvancedBusinessNetworkRuntimePusherPremiumMultiplier = {
                    label = "Sieć firm / Działanie w grze / Handlarz / Premium / Mnożnik",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Handlarz / Premium / Mnożnik.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillDivisor = {
                    label = "Sieć firm / Działanie w grze / Handlarz / Umiejętność / Dzielnik",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Handlarz / Umiejętność / Dzielnik.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillGain = {
                    label = "Sieć firm / Działanie w grze / Handlarz / Umiejętność / zysk",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Handlarz / Umiejętność / zysk.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationBaseSeconds = {
                    label = "Sieć firm / Działanie w grze / Trasa / Czas trwania / Wartość bazowa / sekundy",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Czas trwania / Wartość bazowa / sekundy.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationPerUnitSeconds = {
                    label = "Sieć firm / Działanie w grze / Trasa / Czas trwania / Na jednostkę / sekundy",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Czas trwania / Na jednostkę / sekundy.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem1 = {
                    label = "Sieć firm / Działanie w grze / Trasa / Niepowodzenie / Przyczyny / 1",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Niepowodzenie / Przyczyny / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem2 = {
                    label = "Sieć firm / Działanie w grze / Trasa / Niepowodzenie / Przyczyny / 2",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Niepowodzenie / Przyczyny / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem3 = {
                    label = "Sieć firm / Działanie w grze / Trasa / Niepowodzenie / Przyczyny / 3",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Niepowodzenie / Przyczyny / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem4 = {
                    label = "Sieć firm / Działanie w grze / Trasa / Niepowodzenie / Przyczyny / 4",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Niepowodzenie / Przyczyny / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureValueMultiplier = {
                    label = "Sieć firm / Działanie w grze / Trasa / Niepowodzenie / Wartość / Mnożnik",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Niepowodzenie / Wartość / Mnożnik.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatAmountDivisor = {
                    label = "Sieć firm / Działanie w grze / Trasa / Presja policji / Ilość / Dzielnik",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Presja policji / Ilość / Dzielnik.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostBase = {
                    label = "Sieć firm / Działanie w grze / Trasa / Redukcja poziomu poszukiwań / Koszt / Wartość bazowa",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Redukcja poziomu poszukiwań / Koszt / Wartość bazowa.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostPerHeat = {
                    label = "Sieć firm / Działanie w grze / Trasa / Redukcja poziomu poszukiwań / Koszt / Na punkt zainteresowania policji",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Redukcja poziomu poszukiwań / Koszt / Na punkt zainteresowania policji.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMaximum = {
                    label = "Sieć firm / Działanie w grze / Trasa / Ryzyko / Maksimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Ryzyko / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMinimum = {
                    label = "Sieć firm / Działanie w grze / Trasa / Ryzyko / Minimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Ryzyko / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsHeat = {
                    label = "Sieć firm / Działanie w grze / Trasa / Ryzyko / Wagi / Presja policji",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Ryzyko / Wagi / Presja policji.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsLoyalty = {
                    label = "Sieć firm / Działanie w grze / Trasa / Ryzyko / Wagi / Lojalność",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Ryzyko / Wagi / Lojalność.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsRunnerRisk = {
                    label = "Sieć firm / Działanie w grze / Trasa / Ryzyko / Wagi / Kurier / Ryzyko",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Ryzyko / Wagi / Kurier / Ryzyko.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsSkill = {
                    label = "Sieć firm / Działanie w grze / Trasa / Ryzyko / Wagi / Umiejętność",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Ryzyko / Wagi / Umiejętność.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationHeatReduction = {
                    label = "Sieć firm / Działanie w grze / Rotacja tras / Redukcja poziomu poszukiwań",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Rotacja tras / Redukcja poziomu poszukiwań.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationRiskReduction = {
                    label = "Sieć firm / Działanie w grze / Rotacja tras / Ryzyko / Redukcja",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Rotacja tras / Ryzyko / Redukcja.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityBase = {
                    label = "Sieć firm / Działanie w grze / Trasa / Sprzedaż / Jakość bazowa",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Sprzedaż / Jakość bazowa.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityDivisor = {
                    label = "Sieć firm / Działanie w grze / Trasa / Sprzedaż / Jakość / Dzielnik",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Sprzedaż / Jakość / Dzielnik.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleRiskDivisor = {
                    label = "Sieć firm / Działanie w grze / Trasa / Sprzedaż / Ryzyko / Dzielnik",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Sprzedaż / Ryzyko / Dzielnik.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteStartHeat = {
                    label = "Sieć firm / Działanie w grze / Trasa / Początek / Presja policji",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Trasa / Początek / Presja policji.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerLevel = {
                    label = "Sieć firm / Działanie w grze / Kurier / Doświadczenie / Na poziom",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Kurier / Doświadczenie / Na poziom.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerUnit = {
                    label = "Sieć firm / Działanie w grze / Kurier / Doświadczenie / Na jednostkę",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Kurier / Doświadczenie / Na jednostkę.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureLoyaltyLoss = {
                    label = "Sieć firm / Działanie w grze / Kurier / Niepowodzenie / Lojalność / Strata",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Kurier / Niepowodzenie / Lojalność / Strata.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureRiskGain = {
                    label = "Sieć firm / Działanie w grze / Kurier / Ryzyko niepowodzenia / zysk",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Kurier / Ryzyko niepowodzenia / zysk.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerSkillGain = {
                    label = "Sieć firm / Działanie w grze / Kurier / Umiejętność / zysk",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Kurier / Umiejętność / zysk.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsHeat = {
                    label = "Sieć firm / Działanie w grze / Wynik / Wagi / Presja policji",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Wynik / Wagi / Presja policji.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReliability = {
                    label = "Sieć firm / Działanie w grze / Wynik / Wagi / Niezawodność",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Wynik / Wagi / Niezawodność.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReputation = {
                    label = "Sieć firm / Działanie w grze / Wynik / Wagi / Reputacja",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Wynik / Wagi / Reputacja.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsStructure = {
                    label = "Sieć firm / Działanie w grze / Wynik / Wagi / Struktura",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Wynik / Wagi / Struktura.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffCapacityBaseMultiplier = {
                    label = "Sieć firm / Działanie w grze / Personel / pojemność / Wartość bazowa / Mnożnik",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / pojemność / Wartość bazowa / Mnożnik.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMax = {
                    label = "Sieć firm / Działanie w grze / Personel / Zatrudnienie / Lojalność / Maksimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Zatrudnienie / Lojalność / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMin = {
                    label = "Sieć firm / Działanie w grze / Personel / Zatrudnienie / Lojalność / Minimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Zatrudnienie / Lojalność / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMax = {
                    label = "Sieć firm / Działanie w grze / Personel / Zatrudnienie / Ryzyko / Maksimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Zatrudnienie / Ryzyko / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMin = {
                    label = "Sieć firm / Działanie w grze / Personel / Zatrudnienie / Ryzyko / Minimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Zatrudnienie / Ryzyko / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMax = {
                    label = "Sieć firm / Działanie w grze / Personel / Zatrudnienie / Umiejętność / Maksimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Zatrudnienie / Umiejętność / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMin = {
                    label = "Sieć firm / Działanie w grze / Personel / Zatrudnienie / Umiejętność / Minimum",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Zatrudnienie / Umiejętność / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentLoyaltyWeight = {
                    label = "Sieć firm / Działanie w grze / Personel / Incydent / Lojalność / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Incydent / Lojalność / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentMaximumChance = {
                    label = "Sieć firm / Działanie w grze / Personel / Incydent / Maksimum / Szansa",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Incydent / Maksimum / Szansa.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem1 = {
                    label = "Sieć firm / Działanie w grze / Personel / Incydent / Wyniki / 1",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Incydent / Wyniki / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem2 = {
                    label = "Sieć firm / Działanie w grze / Personel / Incydent / Wyniki / 2",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Incydent / Wyniki / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem3 = {
                    label = "Sieć firm / Działanie w grze / Personel / Incydent / Wyniki / 3",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Incydent / Wyniki / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem4 = {
                    label = "Sieć firm / Działanie w grze / Personel / Incydent / Wyniki / 4",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Incydent / Wyniki / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentRiskWeight = {
                    label = "Sieć firm / Działanie w grze / Personel / Incydent / Ryzyko / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Incydent / Ryzyko / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffLoyaltyDecay = {
                    label = "Sieć firm / Działanie w grze / Personel / Lojalność / Degradacja",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Lojalność / Degradacja.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffMaximumLevel = {
                    label = "Sieć firm / Działanie w grze / Personel / Maksimum / Poziom",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Maksimum / Poziom.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffPoachedLoyaltyLoss = {
                    label = "Sieć firm / Działanie w grze / Personel / Utrata lojalności przez podkupienie",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Utrata lojalności przez podkupienie.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionCostBase = {
                    label = "Sieć firm / Działanie w grze / Personel / Ochrona / Koszt / Wartość bazowa",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Ochrona / Koszt / Wartość bazowa.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionHours = {
                    label = "Sieć firm / Działanie w grze / Personel / Ochrona / Godziny",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Ochrona / Godziny.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionIncidentReduction = {
                    label = "Sieć firm / Działanie w grze / Personel / Ochrona / Incydent / Redukcja",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Ochrona / Incydent / Redukcja.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionRiskCost = {
                    label = "Sieć firm / Działanie w grze / Personel / Ochrona / Ryzyko / Koszt",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Ochrona / Ryzyko / Koszt.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryBaseChance = {
                    label = "Sieć firm / Działanie w grze / Personel / Regeneracja / Wartość bazowa / Szansa",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Regeneracja / Wartość bazowa / Szansa.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryLoyaltyWeight = {
                    label = "Sieć firm / Działanie w grze / Personel / Regeneracja / Lojalność / Waga",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Regeneracja / Lojalność / Waga.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageBaseMultiplier = {
                    label = "Sieć firm / Działanie w grze / Personel / Stawka / Wartość bazowa / Mnożnik",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Stawka / Wartość bazowa / Mnożnik.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageLoyaltyGain = {
                    label = "Sieć firm / Działanie w grze / Personel / Stawka / Lojalność / zysk",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Stawka / Lojalność / zysk.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageSkillDivisor = {
                    label = "Sieć firm / Działanie w grze / Personel / Stawka / Umiejętność / Dzielnik",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Stawka / Umiejętność / Dzielnik.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem1 = {
                    label = "Sieć firm / Działanie w grze / Personel / Słabości / 1",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Słabości / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem2 = {
                    label = "Sieć firm / Działanie w grze / Personel / Słabości / 2",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Słabości / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem3 = {
                    label = "Sieć firm / Działanie w grze / Personel / Słabości / 3",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Słabości / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem4 = {
                    label = "Sieć firm / Działanie w grze / Personel / Słabości / 4",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Słabości / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem5 = {
                    label = "Sieć firm / Działanie w grze / Personel / Słabości / 5",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Słabości / 5.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem6 = {
                    label = "Sieć firm / Działanie w grze / Personel / Słabości / 6",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Personel / Słabości / 6.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsContracts = {
                    label = "Sieć firm / Działanie w grze / Struktura / Wagi / Kontrakty",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Struktura / Wagi / Kontrakty.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsDealers = {
                    label = "Sieć firm / Działanie w grze / Struktura / Wagi / Dilerzy",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Struktura / Wagi / Dilerzy.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsHubs = {
                    label = "Sieć firm / Działanie w grze / Struktura / Wagi / Centra dystrybucji",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Struktura / Wagi / Centra dystrybucji.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsRoutes = {
                    label = "Sieć firm / Działanie w grze / Struktura / Wagi / Trasy",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Struktura / Wagi / Trasy.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsStaff = {
                    label = "Sieć firm / Działanie w grze / Struktura / Wagi / Personel",
                    description = "Ustawienie działania dla: Sieć firm / Działanie w grze / Struktura / Wagi / Personel.",
                },
                drugAdvancedBusinessNetworkSocietyPermission = {
                    label = "Sieć firm / Organizacja / Uprawnienie",
                    description = "Ustawienie działania dla: Sieć firm / Organizacja / Uprawnienie.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseCapacity = {
                    label = "Sieć firm / Personel / Handlarz / Wartość bazowa / pojemność",
                    description = "Ustawienie działania dla: Sieć firm / Personel / Handlarz / Wartość bazowa / pojemność.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseWage = {
                    label = "Sieć firm / Personel / Handlarz / Wartość bazowa / Stawka",
                    description = "Ustawienie działania dla: Sieć firm / Personel / Handlarz / Wartość bazowa / Stawka.",
                },
                drugAdvancedBusinessNetworkStaffPusherCommission = {
                    label = "Sieć firm / Personel / Handlarz / Prowizja",
                    description = "Ustawienie działania dla: Sieć firm / Personel / Handlarz / Prowizja.",
                },
                drugAdvancedBusinessNetworkStaffPusherHirePrice = {
                    label = "Sieć firm / Personel / Handlarz / Zatrudnienie / Cena",
                    description = "Ustawienie działania dla: Sieć firm / Personel / Handlarz / Zatrudnienie / Cena.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseCapacity = {
                    label = "Sieć firm / Personel / Kurier / Wartość bazowa / pojemność",
                    description = "Ustawienie działania dla: Sieć firm / Personel / Kurier / Wartość bazowa / pojemność.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseWage = {
                    label = "Sieć firm / Personel / Kurier / Wartość bazowa / Stawka",
                    description = "Ustawienie działania dla: Sieć firm / Personel / Kurier / Wartość bazowa / Stawka.",
                },
                drugAdvancedBusinessNetworkStaffRunnerCommission = {
                    label = "Sieć firm / Personel / Kurier / Prowizja",
                    description = "Ustawienie działania dla: Sieć firm / Personel / Kurier / Prowizja.",
                },
                drugAdvancedBusinessNetworkStaffRunnerHirePrice = {
                    label = "Sieć firm / Personel / Kurier / Zatrudnienie / Cena",
                    description = "Ustawienie działania dla: Sieć firm / Personel / Kurier / Zatrudnienie / Cena.",
                },
                drugAdvancedBusinessNetworkTickMinutes = {
                    label = "Sieć firm / Cykl aktualizacji / Minuty",
                    description = "Ustawienie działania dla: Sieć firm / Cykl aktualizacji / Minuty.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCapacity = {
                    label = "Sieć firm / Transporty / Samolot / pojemność",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Samolot / pojemność.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCost = {
                    label = "Sieć firm / Transporty / Samolot / Koszt",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Samolot / Koszt.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftDurationMultiplier = {
                    label = "Sieć firm / Transporty / Samolot / Mnożnik czasu trwania",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Samolot / Mnożnik czasu trwania.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftRisk = {
                    label = "Sieć firm / Transporty / Samolot / Ryzyko",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Samolot / Ryzyko.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCapacity = {
                    label = "Sieć firm / Transporty / Łodzie / pojemność",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Łodzie / pojemność.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCost = {
                    label = "Sieć firm / Transporty / Łodzie / Koszt",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Łodzie / Koszt.",
                },
                drugAdvancedBusinessNetworkTransportsBoatDurationMultiplier = {
                    label = "Sieć firm / Transporty / Łodzie / Mnożnik czasu trwania",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Łodzie / Mnożnik czasu trwania.",
                },
                drugAdvancedBusinessNetworkTransportsBoatRisk = {
                    label = "Sieć firm / Transporty / Łodzie / Ryzyko",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Łodzie / Ryzyko.",
                },
                drugAdvancedBusinessNetworkTransportsCarCapacity = {
                    label = "Sieć firm / Transporty / Samochód / pojemność",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Samochód / pojemność.",
                },
                drugAdvancedBusinessNetworkTransportsCarCost = {
                    label = "Sieć firm / Transporty / Samochód / Koszt",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Samochód / Koszt.",
                },
                drugAdvancedBusinessNetworkTransportsCarDurationMultiplier = {
                    label = "Sieć firm / Transporty / Samochód / Mnożnik czasu trwania",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Samochód / Mnożnik czasu trwania.",
                },
                drugAdvancedBusinessNetworkTransportsCarRisk = {
                    label = "Sieć firm / Transporty / Samochód / Ryzyko",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Samochód / Ryzyko.",
                },
                drugAdvancedBusinessNetworkTransportsFootCapacity = {
                    label = "Sieć firm / Transporty / Pieszo / pojemność",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Pieszo / pojemność.",
                },
                drugAdvancedBusinessNetworkTransportsFootCost = {
                    label = "Sieć firm / Transporty / Pieszo / Koszt",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Pieszo / Koszt.",
                },
                drugAdvancedBusinessNetworkTransportsFootDurationMultiplier = {
                    label = "Sieć firm / Transporty / Pieszo / Mnożnik czasu trwania",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Pieszo / Mnożnik czasu trwania.",
                },
                drugAdvancedBusinessNetworkTransportsFootRisk = {
                    label = "Sieć firm / Transporty / Pieszo / Ryzyko",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Pieszo / Ryzyko.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCapacity = {
                    label = "Sieć firm / Transporty / Ciężarówka / pojemność",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Ciężarówka / pojemność.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCost = {
                    label = "Sieć firm / Transporty / Ciężarówka / Koszt",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Ciężarówka / Koszt.",
                },
                drugAdvancedBusinessNetworkTransportsTruckDurationMultiplier = {
                    label = "Sieć firm / Transporty / Ciężarówka / Mnożnik czasu trwania",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Ciężarówka / Mnożnik czasu trwania.",
                },
                drugAdvancedBusinessNetworkTransportsTruckRisk = {
                    label = "Sieć firm / Transporty / Ciężarówka / Ryzyko",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Ciężarówka / Ryzyko.",
                },
                drugAdvancedBusinessNetworkTransportsVanCapacity = {
                    label = "Sieć firm / Transporty / Dostawczy / pojemność",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Dostawczy / pojemność.",
                },
                drugAdvancedBusinessNetworkTransportsVanCost = {
                    label = "Sieć firm / Transporty / Dostawczy / Koszt",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Dostawczy / Koszt.",
                },
                drugAdvancedBusinessNetworkTransportsVanDurationMultiplier = {
                    label = "Sieć firm / Transporty / Dostawczy / Mnożnik czasu trwania",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Dostawczy / Mnożnik czasu trwania.",
                },
                drugAdvancedBusinessNetworkTransportsVanRisk = {
                    label = "Sieć firm / Transporty / Dostawczy / Ryzyko",
                    description = "Ustawienie działania dla: Sieć firm / Transporty / Dostawczy / Ryzyko.",
                },
                interrogationDispatchAdapter = {
                    options = {
                        sky_jobs_base = "Sky Jobs Base",
                        generic = "Integracja ogólna",
                        custom = "Własna integracja",
                        none = "Wyłączone",
                    },
                },
                reputationRules = {
                    label = "Reguły reputacji",
                    description = "Ustaw nazwane reguły dla działań i opcjonalnych celów. Punkty przyznają tylko włączone reguły.",
                },
            },
            territoryMap = {
                addPoint = "Dodać punkt",
                clear = "Wyczyść",
                create = "Utwórz",
                custom = "Własne terytoria",
                deletePoint = "Usuń punkt",
                eyebrow = "Edytor terytoriów",
                minimum = "Minimalna 3",
                pointCount = "Punkty {count}",
                presets = "Szablony dzielnic",
                shown = "Pokazywane na mapie",
                street = "Ulica",
                supply = "Dostawa",
                territories = "Terytoria",
                type = "Typ terytorium",
                undo = "Cofnij",
            },
            shopPositionTools = {
                currentPosition = "Użyj bieżącej pozycji",
                selectEntity = "Wybierz obiekt",
                selectEntityHint = "Skieruj laser na kasę lub sejf. Enter: użyj pozycji i orientacji obramowanego obiektu. Backspace: anuluj.",
            },
            drugSettingSubsections = {
                cultivationLevels = "Poziomy uprawy",
                general = "Ogólne",
                runtime = "Dostęp do akcji w grze",
                quality = "Jakość",
                packaging = "Opakowanie",
                growing = "Uprawa",
                labs = "Laboratoria i kampery",
                power = "Zasilanie i wyposażenie",
                workers = "Pracownicy",
                market = "Rynek i dystrybucja",
                threats = "Naloty i sabotaż",
                pvpTakeovers = "Przejęcia laboratoriów",
                consumption = "Konsumpcja",
                processing = "Przetwarzanie",
                performance = "Osiągi",
                dynamicMarket = "Dynamiczny Rynek",
                heat = "Zainteresowanie policji i ryzyko",
                contacts = "Sieć kontaktów",
                business = "Sieć firm",
            },
            drugSettingGroups = {
                cultivationGeneral = { label = "Ogólne" },
                cultivationCurve = { label = "Krzywa poziomów" },
                cultivationExperience = { label = "Nagrody XP" },
                cultivationUnlocks = { label = "Odblokowania poziomów" },
                creator = {
                    label = "Otwórz edytor",
                },
                creatorSettings = {
                    label = "Ustawienia edytora",
                },
                interfaceHud = {
                    label = "Pozycje interfejsu",
                },
                drugsGeneral = {
                    label = "Ogólne",
                },
                runtimeAccess = {
                    label = "Dostęp i własność",
                },
                runtimePayouts = {
                    label = "Wypłaty",
                },
                runtimeDispatch = {
                    label = "Dyspozytornia i policja",
                },
                qualityWeights = {
                    label = "Jakość / Wagi",
                },
                qualityTiers = {
                    label = "Jakość / Poziomy jakości",
                },
                packagingGeneral = {
                    label = "Ogólne",
                },
                growingGeneral = {
                    label = "Ogólne",
                },
                plantDefaults = {
                    label = "Roślina / Wartości domyślne",
                },
                harvestWindow = {
                    label = "Zbiory / Okno czasowe",
                },
                labsGeneral = {
                    label = "Ogólne",
                },
                labRent = {
                    label = "Najem i cykl życia",
                },
                camperDefaults = {
                    label = "Kamper",
                },
                labUpgrades = {
                    label = "Ulepszenia",
                },
                labDefaults = {
                    label = "Laboratorium / Wartości domyślne",
                },
                powerGeneral = {
                    label = "Ogólne",
                },
                generators = {
                    label = "Generatory",
                },
                equipmentWear = {
                    label = "Wyposażenie",
                },
                workersGeneral = {
                    label = "Ogólne",
                },
                marketGeneral = {
                    label = "Ogólne",
                },
                marketPrices = {
                    label = "Ceny",
                },
                distribution = {
                    label = "Dystrybucja",
                },
                threatsGeneral = {
                    label = "Ogólne",
                },
                threatHeat = {
                    label = "Presja policji",
                },
                threatChances = {
                    label = "Prawdopodobieństwa",
                },
                pvpTakeoverRules = {
                    label = "Zasady przejęcia",
                },
                pvpTakeoverZones = {
                    label = "Strefy & Czas trwania",
                },
                pvpTakeoverMethods = {
                    label = "Metody włamania",
                },
                consumptionGeneral = {
                    label = "Ogólne",
                },
                consumerDecay = {
                    label = "Spadek tolerancji i uzależnienia",
                },
                consumerEffects = {
                    label = "Efekty i ryzyko",
                },
                processingFlow = {
                    label = "Przebieg przetwarzania",
                },
                processingGeneral = {
                    label = "Ogólne",
                },
                powerRuntime = {
                    label = "Działanie w grze",
                },
                powerHeat = {
                    label = "Zainteresowanie policji i sygnatura energetyczna",
                },
                powerModes = {
                    label = "Zarządzanie / Tryby",
                },
                powerPriorities = {
                    label = "Obciążenie / Priorytety",
                },
                performanceInactiveControlIntervalMs = {
                    label = "Nieaktywne / Sterowanie / Interwał / ms",
                },
                performanceInteractionIdleScanIntervalMs = {
                    label = "Interakcja / Bezczynny / Interwał skanowania / ms",
                },
                performanceInteractionPromptIntervalMs = {
                    label = "Interakcja / Komunikat interakcji / Interwał / ms",
                },
                performanceInteractionScanIntervalMs = {
                    label = "Interakcja / Interwał skanowania / ms",
                },
                performanceMinimumScanIntervalMs = {
                    label = "Minimum / Interwał skanowania / ms",
                },
                performanceStreetPedActivationDistance = {
                    label = "Ulica / Ped / Aktywacja / Odległość",
                },
                performanceStreetPedIdleScanIntervalMs = {
                    label = "Ulica / Ped / Bezczynny / Interwał skanowania / ms",
                },
                performanceStreetPedScanIntervalMs = {
                    label = "Ulica / Ped / Interwał skanowania / ms",
                },
                performanceWorldCachePadding = {
                    label = "Świat / Pamięć podręczna / Dodatkowy margines",
                },
                performanceWorldCacheRefreshIntervalMs = {
                    label = "Świat / Pamięć podręczna / Odświeżanie / Interwał / ms",
                },
                performanceWorldIdleIntervalMs = {
                    label = "Świat / Bezczynny / Interwał / ms",
                },
                dynamicMarketActionCooldownSeconds = {
                    label = "Czas odnowienia akcji / sekundy",
                },
                dynamicMarketActionHistoryLimit = {
                    label = "Działanie / Limit historii",
                },
                dynamicMarketAmountSaturationWeight = {
                    label = "Ilość / Nasycenie / Waga",
                },
                dynamicMarketBaseIntelAccuracy = {
                    label = "Wartość bazowa / Dokładność danych",
                },
                dynamicMarketDefaultAverageQuality = {
                    label = "Wartość domyślna / Średnia / Jakość",
                },
                dynamicMarketDefaultResourceElasticity = {
                    label = "Wartość domyślna / Surowiec / Elastyczność",
                },
                dynamicMarketDemandCenter = {
                    label = "Popyt / Wartość środkowa",
                },
                dynamicMarketDemandPriceImpact = {
                    label = "Popyt / Cena / Wpływ",
                },
                dynamicMarketDirectionThreshold = {
                    label = "Kierunek / Próg",
                },
                dynamicMarketEnabled = {
                    label = "Włączone",
                },
                dynamicMarketEventChance = {
                    label = "Zdarzenie / Szansa",
                },
                dynamicMarketEventDurationMinutes = {
                    label = "Zdarzenie / Czas trwania / Minuty",
                },
                dynamicMarketEventMinimumDurationMinutes = {
                    label = "Zdarzenie / Minimum / Czas trwania / Minuty",
                },
                dynamicMarketEventStrengthMaximum = {
                    label = "Zdarzenie / Siła / Maksimum",
                },
                dynamicMarketEventStrengthMinimum = {
                    label = "Zdarzenie / Siła / Minimum",
                },
                dynamicMarketEvents = {
                    label = "Wydarzenia",
                },
                dynamicMarketExactIntelReputation = {
                    label = "Dokładne informacje / Reputacja",
                },
                dynamicMarketExactIntelTrust = {
                    label = "Dokładne informacje / Zaufanie",
                },
                dynamicMarketGlobalZoneLabel = {
                    label = "Global / Strefa / Etykieta",
                },
                dynamicMarketHistoryLimit = {
                    label = "Limit historii",
                },
                dynamicMarketInitialDemand = {
                    label = "Wartość początkowa / Popyt",
                },
                dynamicMarketInitialPriceMultiplier = {
                    label = "Wartość początkowa / Mnożnik ceny",
                },
                dynamicMarketIntelDemandError = {
                    label = "Informacje / Popyt / Błąd",
                },
                dynamicMarketIntelMaximumAccuracy = {
                    label = "Informacje / Maksimum / Dokładność",
                },
                dynamicMarketIntelMinimumAccuracy = {
                    label = "Informacje / Minimum / Dokładność",
                },
                dynamicMarketIntelPoliceError = {
                    label = "Informacje / Policja / Błąd",
                },
                dynamicMarketIntelPriceError = {
                    label = "Informacje / Cena / Błąd",
                },
                dynamicMarketIntelPriceMaximum = {
                    label = "Informacje / Cena / Maksimum",
                },
                dynamicMarketIntelPriceMinimum = {
                    label = "Informacje / Cena / Minimum",
                },
                dynamicMarketIntelReputationWeight = {
                    label = "Informacje / Reputacja / Waga",
                },
                dynamicMarketIntelResourcePriceError = {
                    label = "Informacje / Surowiec / Cena / Błąd",
                },
                dynamicMarketIntelSaturationError = {
                    label = "Informacje / Nasycenie / Błąd",
                },
                dynamicMarketIntelSeedBucketSeconds = {
                    label = "Okno ziarna informacji / sekundy",
                },
                dynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Informacje / Status / Dokładność / Próg",
                },
                dynamicMarketIntelStatusErrorThreshold = {
                    label = "Informacje / Status / Błąd / Próg",
                },
                dynamicMarketIntelSupplyError = {
                    label = "Informacje / Dostawa / Błąd",
                },
                dynamicMarketIntelTrustWeight = {
                    label = "Informacje / Zaufanie / Waga",
                },
                dynamicMarketManipulationCooldownMinutes = {
                    label = "Manipulacja / Minuty odnowienia",
                },
                dynamicMarketManipulationDemandShift = {
                    label = "Manipulacja / Popyt / Zmiana",
                },
                dynamicMarketManipulationDurationMinutes = {
                    label = "Manipulacja / Czas trwania / Minuty",
                },
                dynamicMarketManipulationHeat = {
                    label = "Manipulacja / Presja policji",
                },
                dynamicMarketManipulationMinimumBatchAmount = {
                    label = "Manipulacja / Minimum / Partia / Ilość",
                },
                dynamicMarketManipulationPaymentAccount = {
                    label = "Manipulacja / Konto płatnicze",
                },
                dynamicMarketManipulationPrice = {
                    label = "Manipulacja / Cena",
                },
                dynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Manipulacja / Strefa / Presja policji / Mnożnik",
                },
                dynamicMarketMaximumIntelAgeMinutes = {
                    label = "Maksimum / Wiek danych / Minuty",
                },
                dynamicMarketMaximumPriceMultiplier = {
                    label = "Maksimum / Mnożnik ceny",
                },
                dynamicMarketMinimumIntelAgeMinutes = {
                    label = "Minimum / Wiek danych / Minuty",
                },
                dynamicMarketMinimumMetricWindowMinutes = {
                    label = "Minimum / Metryka / Okno czasowe / Minuty",
                },
                dynamicMarketMinimumPriceMultiplier = {
                    label = "Cena minimalna / Mnożnik",
                },
                dynamicMarketMinimumUpdateMinutes = {
                    label = "Minimum / Aktualizacja / Minuty",
                },
                dynamicMarketPoliceDemandWeight = {
                    label = "Policja / Popyt / Waga",
                },
                dynamicMarketPolicePriceImpact = {
                    label = "Policja / Cena / Wpływ",
                },
                dynamicMarketPoorQualityDemandPenalty = {
                    label = "Niska jakość / Popyt / Kara",
                },
                dynamicMarketPoorQualityThreshold = {
                    label = "Niska jakość / Próg",
                },
                dynamicMarketPremiumQualityDemandBonus = {
                    label = "Jakość premium / Bonus do popytu",
                },
                dynamicMarketPremiumQualityThreshold = {
                    label = "Jakość premium / Próg",
                },
                dynamicMarketProductionSupplyWeight = {
                    label = "Produkcja / Dostawa / Waga",
                },
                dynamicMarketProductionWindowMinutes = {
                    label = "Produkcja / Okno czasowe / Minuty",
                },
                dynamicMarketQualityCenter = {
                    label = "Jakość / Wartość środkowa",
                },
                dynamicMarketQualityConfidenceImpact = {
                    label = "Jakość / Pewność / Wpływ",
                },
                dynamicMarketQualityRange = {
                    label = "Jakość / Zakres wartości",
                },
                dynamicMarketRarityBonusMaximum = {
                    label = "Rzadkość / Premia / Maksimum",
                },
                dynamicMarketRegionalGlobalWeight = {
                    label = "Regionalne / Global / Waga",
                },
                dynamicMarketRegionalLocalWeight = {
                    label = "Regionalne / Lokalne / Waga",
                },
                dynamicMarketResourceAliases = {
                    label = "Surowiec / Aliasy",
                },
                dynamicMarketResourceDirectionFallThreshold = {
                    label = "Surowiec / Kierunek / Spadek / Próg",
                },
                dynamicMarketResourceDirectionRiseThreshold = {
                    label = "Surowiec / Kierunek / Wzrost / Próg",
                },
                dynamicMarketResources = {
                    label = "Zasoby",
                },
                dynamicMarketSalesWindowMinutes = {
                    label = "Sprzedaż / Okno czasowe / Minuty",
                },
                dynamicMarketSaturationDemandWeight = {
                    label = "Nasycenie / Popyt / Waga",
                },
                dynamicMarketSaturationPriceImpact = {
                    label = "Nasycenie / Cena / Wpływ",
                },
                dynamicMarketScarcityDemandWeight = {
                    label = "Niedobór / Popyt / Waga",
                },
                dynamicMarketScarcityPriceImpact = {
                    label = "Niedobór / Cena / Wpływ",
                },
                dynamicMarketSeasonEndMonths = {
                    label = "Pora roku / Koniec / Miesiące",
                },
                dynamicMarketSeasonMultipliers = {
                    label = "Pora roku / Mnożniki",
                },
                dynamicMarketShortageRumorThreshold = {
                    label = "Niedobór / Plotka / Próg",
                },
                dynamicMarketStatusThresholds = {
                    label = "Status / Progi",
                },
                dynamicMarketTargetSupply = {
                    label = "Cel / Dostawa",
                },
                dynamicMarketTrendChance = {
                    label = "Trend / Szansa",
                },
                dynamicMarketTrendDurationMinutes = {
                    label = "Trend / Czas trwania / Minuty",
                },
                dynamicMarketTrendMaximumStrength = {
                    label = "Trend / Maksimum / Siła",
                },
                dynamicMarketTrendMinimumStrength = {
                    label = "Trend / Minimum / Siła",
                },
                dynamicMarketUpdateMinutes = {
                    label = "Aktualizacja / Minuty",
                },
                dynamicMarketVolatilityMaximum = {
                    label = "Zmienność cen / Maksimum",
                },
                dynamicMarketVolatilityMinimum = {
                    label = "Zmienność cen / Minimum",
                },
                dynamicMarketWeatherMultipliers = {
                    label = "Pogoda / Mnożniki",
                },
                dynamicMarketWeatherState = {
                    label = "Pogoda / Status",
                },
                heatActionCooldownSeconds = {
                    label = "Czas odnowienia akcji / sekundy",
                },
                heatActivityRiskWeights = {
                    label = "Aktywność / Ryzyko / Wagi",
                },
                heatAggressiveHeatMultiplier = {
                    label = "Tryb agresywny / Presja policji / Mnożnik",
                },
                heatBurnerBurnThreshold = {
                    label = "Telefon jednorazowy / Zdemaskowanie / Próg",
                },
                heatBurnerHeatPerWholesale = {
                    label = "Telefon jednorazowy / Presja policji / Na transakcję hurtową",
                },
                heatBurnerPhoneItem = {
                    label = "Telefon jednorazowy / Przedmiot",
                },
                heatCamperOperationalHeatMultiplier = {
                    label = "Kamper w działaniu / Presja policji / Mnożnik",
                },
                heatCamperOperationalHeatThreshold = {
                    label = "Kamper w działaniu / Presja policji / Próg",
                },
                heatCamperParkedHeat = {
                    label = "Zaparkowany kamper / Presja policji",
                },
                heatContaminatedHeatMultiplier = {
                    label = "Zanieczyszczenie / Presja policji / Mnożnik",
                },
                heatContaminatedThreshold = {
                    label = "Zanieczyszczenie / Próg",
                },
                heatCultivationFreePlants = {
                    label = "Uprawa / Rośliny bez dodatkowego ryzyka",
                },
                heatCultivationHeatPerPlant = {
                    label = "Uprawa / Presja policji / Na roślinę",
                },
                heatDealerHiddenMinutes = {
                    label = "Dystrybutor / ukryte / Minuty",
                },
                heatDecayPerTick = {
                    label = "Degradacja / Na cykl aktualizacji",
                },
                heatEnabled = {
                    label = "Włączone",
                },
                heatEnforcementHeat = {
                    label = "Obecność policji / Presja policji",
                },
                heatEnforcementMultipliers = {
                    label = "Obecność policji / Mnożniki",
                },
                heatEntityTypes = {
                    label = "Obiekt gry / Typy",
                },
                heatEventCooldownMinutes = {
                    label = "Zdarzenie / Minuty odnowienia",
                },
                heatEventHistoryLimit = {
                    label = "Zdarzenie / Limit historii",
                },
                heatLabHeatSyncThreshold = {
                    label = "Laboratorium / Presja policji / Synchronizacja / Próg",
                },
                heatLayLowCooldownMinutes = {
                    label = "Ukrywanie się / Minuty odnowienia",
                },
                heatLayLowIdleMinutes = {
                    label = "Ukrywanie się / Bezczynny / Minuty",
                },
                heatLayLowReduction = {
                    label = "Ukrywanie się / Redukcja",
                },
                heatLockdownMinutes = {
                    label = "Blokada / Minuty",
                },
                heatMinimumDurationMinutes = {
                    label = "Minimum / Czas trwania / Minuty",
                },
                heatMinimumEventCooldownSeconds = {
                    label = "Minimum / Zdarzenie / Czas odnowienia (sekundy)",
                },
                heatMinimumIdleSeconds = {
                    label = "Minimum / Bezczynny / sekundy",
                },
                heatProcessingHeatMultiplier = {
                    label = "Przetwarzanie / Presja policji / Mnożnik",
                },
                heatRiskWeights = {
                    label = "Ryzyko / Wagi",
                },
                heatRotateBurnerReduction = {
                    label = "Zmień telefon jednorazowy / Redukcja",
                },
                heatRouteControlMinutes = {
                    label = "Trasa / Sterowanie / Minuty",
                },
                heatSaleHeat = {
                    label = "Sprzedaż / Presja policji",
                },
                heatThresholds = {
                    label = "Progi",
                },
                heatTickMinutes = {
                    label = "Cykl aktualizacji / Minuty",
                },
                heatWholesaleHeatMultiplier = {
                    label = "Hurtownia / Presja policji / Mnożnik",
                },
                heatWorkerLeakAlertRadius = {
                    label = "Pracownik / Wyciek informacji / Promień alarmu",
                },
                heatWorkerLeakBaseChance = {
                    label = "Pracownik / Wyciek informacji / Wartość bazowa / Szansa",
                },
                heatWorkerLeakFactionMultiplier = {
                    label = "Pracownik / Wyciek informacji / Frakcja / Mnożnik",
                },
                heatWorkerLeakHighSeverityThreshold = {
                    label = "Pracownik / Wyciek informacji / Wysoki / Dotkliwość / Próg",
                },
                heatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Pracownik / Wyciek informacji / Lojalność / Szansa / Mnożnik",
                },
                heatWorkerLeakLoyaltyThreshold = {
                    label = "Pracownik / Wyciek informacji / Lojalność / Próg",
                },
                heatWorkerLeakMaximumChance = {
                    label = "Pracownik / Wyciek informacji / Maksimum / Szansa",
                },
                heatWorkerLeakMinimumCooldownSeconds = {
                    label = "Pracownik / Wyciek informacji / Minimum / Czas odnowienia (sekundy)",
                },
                heatWorkerLeakRouteMultiplier = {
                    label = "Pracownik / Wyciek informacji / Trasa / Mnożnik",
                },
                heatWorkerLeakStrengthMaximum = {
                    label = "Pracownik / Wyciek informacji / Siła / Maksimum",
                },
                heatWorkerLeakStrengthMinimum = {
                    label = "Pracownik / Wyciek informacji / Siła / Minimum",
                },
                heatWorkerLeakStrengthMultiplier = {
                    label = "Pracownik / Wyciek informacji / Siła / Mnożnik",
                },
                heatWorkerLeakStressChanceMultiplier = {
                    label = "Pracownik / Wyciek informacji / Stres / Szansa / Mnożnik",
                },
                heatWorkerLeakStressThreshold = {
                    label = "Pracownik / Wyciek informacji / Stres / Próg",
                },
                contactsActionCooldownSeconds = {
                    label = "Czas odnowienia akcji / sekundy",
                },
                contactsActiveHotspotCount = {
                    label = "Liczba aktywnych punktów",
                },
                contactsBurnerHintTrust = {
                    label = "Wskazówka dotycząca burner'a / Zaufanie",
                },
                contactsBurnerOfferMaximumMultiplier = {
                    label = "Telefon jednorazowy / Oferta / Maksimum / Mnożnik",
                },
                contactsBurnerOfferMinimumMultiplier = {
                    label = "Telefon jednorazowy / Oferta / Minimum / Mnożnik",
                },
                contactsBuyerCooldownMinutes = {
                    label = "Kupiec / Minuty odnowienia",
                },
                contactsBuyerDeliveryDistance = {
                    label = "Kupiec / Odległość dostawy",
                },
                contactsBuyerPremiumSuccessScore = {
                    label = "Kupiec / Premium / Sukces / Wynik",
                },
                contactsBuyerPremiumTrustGain = {
                    label = "Kupiec / Premium / Zaufanie / zysk",
                },
                contactsBuyerRequestHeatRiskWeight = {
                    label = "Kupiec / Żądanie / Poziom poszukiwań i ryzyko / Waga",
                },
                contactsBuyerStandardTrustGain = {
                    label = "Kupiec / Standardowy / Zaufanie / zysk",
                },
                contactsContactActiveDelaySeconds = {
                    label = "Opóźnienie aktywacji kontaktu / sekundy",
                },
                contactsContactDemandRange = {
                    label = "Kontakt / Popyt / Zakres wartości",
                },
                contactsContactLossTrust = {
                    label = "Kontakt / Strata / Zaufanie",
                },
                contactsDarknetExactIntelMinutes = {
                    label = "Darknet / Dokładne informacje / Minuty",
                },
                contactsDarknetHotspotIntelPrice = {
                    label = "Darknet / Punkt aktywności / Informacje / Cena",
                },
                contactsDarknetIntelPrice = {
                    label = "Darknet / Informacje / Cena",
                },
                contactsDealerBasePrice = {
                    label = "Dystrybutor / Cena bazowa",
                },
                contactsDealerHireCapacity = {
                    label = "Dystrybutor / Zatrudnienie / pojemność",
                },
                contactsDealerHireRisk = {
                    label = "Dystrybutor / Zatrudnienie / Ryzyko",
                },
                contactsDealerHireSkill = {
                    label = "Dystrybutor / Zatrudnienie / Umiejętność",
                },
                contactsDealerOffers = {
                    label = "Oferty dealerów",
                },
                contactsDealerProtectionHours = {
                    label = "Dystrybutor / Ochrona / Godziny",
                },
                contactsDealerProtectionPrice = {
                    label = "Dystrybutor / Ochrona / Cena",
                },
                contactsDealerSaleMax = {
                    label = "Dystrybutor / Sprzedaż / Maksimum",
                },
                contactsDealerSaleMin = {
                    label = "Dystrybutor / Sprzedaż / Minimum",
                },
                contactsDealerSimulation = {
                    label = "Dystrybutor / Symulacja",
                },
                contactsDealerTickMinutes = {
                    label = "Dystrybutor / Cykl aktualizacji / Minuty",
                },
                contactsDealerWage = {
                    label = "Dystrybutor / Stawka",
                },
                contactsDealerWageDecay = {
                    label = "Dystrybutor / Stawka / Degradacja",
                },
                contactsDealerWageLoyaltyGain = {
                    label = "Dystrybutor / Stawka / Lojalność / zysk",
                },
                contactsDealerWeaknesses = {
                    label = "Dystrybutor / Słabości",
                },
                contactsDefaultContactDemand = {
                    label = "Wartość domyślna / Kontakt / Popyt",
                },
                contactsDefaultContactRisk = {
                    label = "Wartość domyślna / Kontakt / Ryzyko",
                },
                contactsDefaultDealerCapacity = {
                    label = "Domyślny diler / pojemność",
                },
                contactsDefaultDealerRisk = {
                    label = "Domyślny diler / Ryzyko",
                },
                contactsDefaultDealerSkill = {
                    label = "Domyślny diler / Umiejętność",
                },
                contactsDefaultHotspotRadius = {
                    label = "Wartość domyślna / Punkt aktywności / Promień",
                },
                contactsDemandResetMinutes = {
                    label = "Resetowanie popytu (minuty)",
                },
                contactsEnabled = {
                    label = "Włączone",
                },
                contactsExactLocationTrust = {
                    label = "Dokładna lokalizacja / Zaufanie",
                },
                contactsFactionDiscoveryReputation = {
                    label = "Frakcja / Odkrycie / Reputacja",
                },
                contactsFactionHintTrust = {
                    label = "Frakcja / Wskazówka / Zaufanie",
                },
                contactsFailedDeliveryCooldownMinutes = {
                    label = "Nieudana dostawa / Minuty odnowienia",
                },
                contactsFakeDealEncounter = {
                    label = "Fałszywa transakcja / Spotkanie",
                },
                contactsFallbackPreferredDrug = {
                    label = "Wartość zastępcza / Preferowana droga",
                },
                contactsFallbackProductLabel = {
                    label = "Wartość zastępcza / Nazwa produktu",
                },
                contactsGuideBookItem = {
                    label = "Poradnik / Książka / Przedmiot",
                },
                contactsGuideBookTrust = {
                    label = "Poradnik / Książka / Zaufanie",
                },
                contactsHireDealerPrice = {
                    label = "Zatrudnij dealera / Cena",
                },
                contactsHistoryLimit = {
                    label = "Limit historii",
                },
                contactsHotspotIntelMinutes = {
                    label = "Punkt aktywności / Informacje / Minuty",
                },
                contactsHotspotRotationMinutes = {
                    label = "Punkt aktywności / Rotacja / Minuty",
                },
                contactsListingDurationMinutes = {
                    label = "Ogłoszenie / Czas trwania / Minuty",
                },
                contactsMaxOwnedDealers = {
                    label = "Maksimum / Własność / Dilerzy",
                },
                contactsMinimumBuyerDeliveryDistance = {
                    label = "Minimum / Kupiec / Odległość dostawy",
                },
                contactsMinimumContactRotationMinutes = {
                    label = "Minimum / Rotacja kontaktów (minuty)",
                },
                contactsMinimumDemandResetMinutes = {
                    label = "Minimum / Resetowanie popytu (minuty)",
                },
                contactsMinimumHeatMultiplier = {
                    label = "Minimum / Presja policji / Mnożnik",
                },
                contactsMinimumHotspotIntelMinutes = {
                    label = "Minimum / Punkt aktywności / Informacje / Minuty",
                },
                contactsMinimumHotspotRadius = {
                    label = "Minimum / Punkt aktywności / Promień",
                },
                contactsMinimumHotspotRotationMinutes = {
                    label = "Minimum / Punkt aktywności / Rotacja / Minuty",
                },
                contactsMinimumListingDurationMinutes = {
                    label = "Minimum / Ogłoszenie / Czas trwania / Minuty",
                },
                contactsMinimumRewardMultiplier = {
                    label = "Minimalna nagroda / Mnożnik",
                },
                contactsMinimumRobberyMultiplier = {
                    label = "Minimum / Napady / Mnożnik",
                },
                contactsMinimumSpotPriceMultiplier = {
                    label = "Minimum / Lokalizacja / Mnożnik ceny",
                },
                contactsOtherDrugPriceMultiplier = {
                    label = "Inne / Narkotyk / Mnożnik ceny",
                },
                contactsPaymentAccount = {
                    label = "Konto płatnicze",
                },
                contactsPostDeliveryDemandResetSeconds = {
                    label = "Po dostawie / Popyt / Reset / sekundy",
                },
                contactsPreferredDrugPriceMultiplier = {
                    label = "Preferowana droga / Mnożnik ceny",
                },
                contactsRegionLocationTrust = {
                    label = "Region / Lokalizacja / Zaufanie",
                },
                contactsRequestAmounts = {
                    label = "Żądanie / Ilości",
                },
                contactsRotationMinutes = {
                    label = "Rotacja / Minuty",
                },
                contactsSpotPools = {
                    label = "Lokalizacja / Pule wyboru",
                },
                contactsStreetHotspots = {
                    label = "Ulica / Punkty aktywności",
                },
                contactsTrustLevels = {
                    label = "Zaufanie / Poziomy",
                },
                businessActionCooldownSeconds = {
                    label = "Czas odnowienia akcji / sekundy",
                },
                businessBalance = {
                    label = "Saldo",
                },
                businessContracts = {
                    label = "Kontrakty",
                },
                businessDefaultBusinessName = {
                    label = "Wartość domyślna / Nazwa firmy",
                },
                businessDefaultRankId = {
                    label = "Wartość domyślna / Stopień / ID",
                },
                businessDefaultStaffStyle = {
                    label = "Wartość domyślna / Personel / Styl pracy",
                },
                businessDefaultTransport = {
                    label = "Wartość domyślna / Transport",
                },
                businessEnabled = {
                    label = "Włączone",
                },
                businessHubs = {
                    label = "Centra dystrybucji",
                },
                businessLimits = {
                    label = "Limity",
                },
                businessPayments = {
                    label = "Płatności",
                },
                businessPayoutAccount = {
                    label = "Wypłata / Konto",
                },
                businessRanks = {
                    label = "Rangi",
                },
                businessReportDays = {
                    label = "Okres raportu / dni",
                },
                businessRouteEndpointTypes = {
                    label = "Trasa / Punkt końcowy / Typy",
                },
                businessRuntime = {
                    label = "Działanie w grze",
                },
                businessSocietyPermission = {
                    label = "Organizacja / Uprawnienie",
                },
                businessStaff = {
                    label = "Personel",
                },
                businessTickMinutes = {
                    label = "Cykl aktualizacji / Minuty",
                },
                businessTransports = {
                    label = "Transporty",
                },
            },
            territorySettings = {
                section = "Terytoria",
                zonesGroup = "Strefy terytorialne",
                sourceLabel = "Źródło strefy",
                sourceDescription = "Użyj chronionych szablonów dzielnic lub zdefiniuj własne poligony terytorialne.",
                sourcePreset = "Szablony dzielnic",
                sourceCustom = "Własne terytoria",
                editLabel = "Edytor terytoriów",
                editDescription = "Edytuj dzielnice używane przez wybrane źródło strefy.",
                editButton = "Edytuj terytoria",
                presetSection = "Szablony dzielnic",
                presetEntry = "Szablon dzielnicy",
                customSection = "Własne terytoria",
                customEntry = "Własne terytorium",
                typeLabel = "Typ terytorium",
                streetType = "Ulica",
                supplyType = "Dostawa",
                enabledLabel = "Wyświetlane na mapie",
                enabledDescription = "Dezaktywowane dzielnice zostają usunięte z mapy i nie można ich przejąć.",
                zoneLabel = "Granica terytorium",
                zoneDescription = "Dodaj co najmniej trzy punkty kolejno wzdłuż granicy terytorium.",
                ownershipGroup = "Własność",
                decayGroup = "Degradacja",
                presenceGroup = "Obecność",
                activityGroup = "Punktacja aktywności",
                ownershipBenefitsGroup = "Bonusy za posiadanie",
                ownershipThresholdLabel = "Próg posiadania",
                ownershipThresholdDescription = "Procent kontroli, który gang musi przekroczyć, aby oficjalnie posiadać terytorium.",
                activityFloorLabel = "Stały próg aktywności",
                activityFloorDescription = "Liczba punktów wpływów wymagana, gdy wyłączone są progi oparte na wielkości.",
                floorByZoneSizeLabel = "Skalowanie progu według wielkości strefy",
                floorByZoneSizeDescription = "Obliczanie progu aktywności każdego terytorium na podstawie pola jego poligonu zamiast stałego progu.",
                floorPointsPerSizeUnitLabel = "Punkty progu na km²",
                floorPointsPerSizeUnitDescription = "Punkty progu aktywności wymagane za każdy kilometr kwadratowy powierzchni terytorium.",
                fixedFloorRequirement = "Wyłącz progi oparte na wielkości, aby edytować stały próg aktywności.",
                sizeFloorRequirement = "Włącz progi oparte na wielkości, aby edytować punkty na kilometr kwadratowy.",
                dailyDecayLabel = "Dzienna degradacja wpływów",
                dailyDecayDescription = "Procentowy ubytek wpływów co 24 godzin.",
                presenceIntervalLabel = "Interwał obecności",
                presenceIntervalDescription = "Liczba minut między automatycznymi nagrodami za obecność.",
                presencePointsLabel = "Punkty obecności na członka",
                presencePointsDescription = "Punkty obecności przyznawane każdemu uprawnionemu członkowi gangu w każdym interwale.",
                drugSalesEnabledLabel = "Sprzedaż NPC daje wpływy terytorialne",
                drugSalesEnabledDescription = "Udane sprzedaże uliczne dla NPC przyznają wpływy gangowi sprzedawcy w aktualnym terytorium ulicznym.",
                drugSalePointsLabel = "Punkty za sprzedaną porcję narkotyku",
                drugSalePointsDescription = "Punkty wpływów przyznawane za każdą jednostkę narkotyku zgłoszoną jako sprzedana.",
                drugSalesRequirement = "Włącz wpływ ze sprzedaży NPC, aby skonfigurować punkty.",
                graffitiPointsLabel = "Punkty graffiti co 24 godzin",
                graffitiPointsDescription = "Punkty obecności przyznawane, gdy jedno graffiti istnieje łącznie przez 24 zgłoszonych godzin.",
                streetSellingPriceBonusLabel = "Bonus do ceny sprzedaży ulicznej",
                streetSellingPriceBonusDescription = "Procentowa nadwyżka dodawana do cen sprzedaży narkotyków dla oficjalnego właściciela terytorium ulicznego.",
                supplyProductionSpeedBonusLabel = "Bonus do prędkości produkcji zapasów",
                supplyProductionSpeedBonusDescription = "Procentowa nadwyżka dodawana do prędkości produkcji narkotyków dla oficjalnego właściciela terytorium zapasów.",
                pruneToleranceLabel = "Tolerancja przycinania wpływów",
                pruneToleranceDescription = "Efektywne wpływy poniżej tej wartości są traktowane jako zero.",
            },
            graffitiSettings = {
                section = "Graffiti",
                generalGroup = "Ogólne",
                streamingGroup = "Renderowanie",
                moderationGroup = "Moderacja",
                graffitiEnabledLabel = "Włącz graffiti",
                graffitiEnabledDescription = "Pozwala graczom malować i oglądać graffiti.",
                graffitiRequireItemLabel = "Wymagaj sprayu",
                graffitiRequireItemDescription = "Gracze potrzebują przedmiotu w postaci sprayu, aby malować. W przeciwnym razie używana jest komenda /graffiti.",
                graffitiChargesPerCanLabel = "Zastosowań na puszkę",
                graffitiChargesPerCanDescription = "Liczba graffiti, jakie można stworzyć jedną puszką sprayu.",
                graffitiCooldownSecondsLabel = "Czas odnowienia sprayu",
                graffitiCooldownSecondsDescription = "Liczba sekund, jaką gracz musi odczekać między malowaniem.",
                graffitiMaxPerPlayerLabel = "Max. graffiti na gracza",
                graffitiMaxPerPlayerDescription = "Maksymalna liczba aktywnych graffiti, jakie może posiadać jeden gracz. 0 oznacza brak limitu.",
                graffitiMaxDistanceLabel = "Max. dystans malowania",
                graffitiMaxDistanceDescription = "Maksymalna odległość od ściany, w jakiej można malować, w metrach.",
                graffitiSprayDurationLabel = "Czas malowania",
                graffitiSprayDurationDescription = "Czas trwania animacji malowania w milisekundach.",
                graffitiExpiryDaysLabel = "Czas wygaśnięcia",
                graffitiExpiryDaysDescription = "Liczba dni, po których graffiti znika automatycznie. 0 oznacza brak limitu.",
                graffitiTerritoryHoursLabel = "Godziny wpływów na terytorium na jedno użycie sprayu",
                graffitiTerritoryHoursDescription = "Liczba godzin obecności na terytorium, jakie świeże graffiti daje swojej grupie.",
                graffitiStreamRadiusLabel = "Promień renderowania",
                graffitiStreamRadiusDescription = "Odległość w metrach, przy której graffiti staje się widoczne dla graczy.",
                graffitiPoolSizeLabel = "Wielkość puli decalów",
                graffitiPoolSizeDescription = "Liczba graffiti renderowanych jednocześnie. Wyższe wartości obciążają wydajność.",
                graffitiReportsEnabledLabel = "Włącz zgłoszenia",
                graffitiReportsEnabledDescription = "Pozwala graczom zgłaszać obraźliwe graffiti.",
                graffitiAutoHideThresholdLabel = "Próg automatycznego ukrywania",
                graffitiAutoHideThresholdDescription = "Liczba zgłoszeń wymagana do automatycznego ukrycia graffiti. 0 wyłącza tę funkcję.",
            },
            darknetSettings = {
                section = "Rynek Darknet",
                availabilityGroup = "Dostępność",
                economyGroup = "Kryptowaluta",
                listingsGroup = "Oferty i wygaśnięcie",
                chatGroup = "Czat prywatny",
                identityGroup = "Aliasy i reputacja",
                deliveryGroup = "Przekazanie i dead dropy",
                policeGroup = "Dostęp policji",
                npcGroup = "Handlarze NPC",
                enabledLabel = "Włącz Rynek Darknet",
                enabledDescription = "Umożliwia dostęp do aplikacji tabletu czarnego rynku oraz jej logiki działania.",
                tabletOrderLabel = "Kolejność aplikacji na tablecie",
                tabletOrderDescription = "Kontroluje pozycję Rynku Darknet na tablecie.",
                currencyCodeLabel = "Kod waluty",
                currencyCodeDescription = "Krótki skrót dla wewnętrznego rejestru kryptowalut.",
                starterBalanceLabel = "Saldo nowego portfela",
                starterBalanceDescription = "Kryptowaluta przyznawana tylko wtedy, gdy gracz po raz pierwszy otwiera rynek.",
                exchangeEnabledLabel = "Włącz wymianę monet",
                exchangeEnabledDescription = "Pozwala uwierzytelnionym użytkownikom BlackBay kupować i sprzedawać monety na swojej stronie konta.",
                exchangeAccountLabel = "Konto płatnicze wymiany",
                exchangeAccountDescription = "Konto frameworkowe używane do zakupów monet i wypłat ze sprzedaży monet.",
                exchangeBuyPriceLabel = "Cena zakupu za monetę",
                exchangeBuyPriceDescription = "Kwota pobrana z konta płatniczego za jedną monetę.",
                exchangeSellPriceLabel = "Cena sprzedaży za monetę",
                exchangeSellPriceDescription = "Kwota wypłacona na konto płatnicze za jedną monetę.",
                exchangeMinimumLabel = "Minimalna liczba monet w wymianie",
                exchangeMinimumDescription = "Najmniejsza pełna liczba monet akceptowana w jednej wymianie.",
                exchangeMaximumLabel = "Maksymalna liczba monet w wymianie",
                exchangeMaximumDescription = "Największa pełna liczba monet akceptowana w jednej wymianie.",
                accountMoney = "Gotówka",
                accountBank = "Bank",
                accountBlackMoney = "Brudna kasa",
                scamChanceLabel = "Globalna szansa na oszustwo NPC (%)",
                scamChanceDescription = "Minimalna szansa, że NPC podczas transakcji zabierze płatność lub towar bez przekazania zapłaty. Wyższa szansa specyficzna dla handlarza nadal obowiązuje.",
                listingExpiryLabel = "Czas trwania oferty (godziny)",
                listingExpiryDescription = "Aktywne oferty wygasają automatycznie po tej liczbie godzin.",
                renewalHoursLabel = "Czas odnowienia (godziny)",
                renewalHoursDescription = "Liczba godzin dodawanych, gdy właściciel odnawia ofertę.",
                maximumListingsLabel = "Maksymalna liczba aktywnych ofert",
                maximumListingsDescription = "Maksymalna liczba ofert na jeden aktywny alias.",
                maximumQuantityLabel = "Maksymalna ilość towaru",
                maximumQuantityDescription = "Górny limit ilościowy dla pojedynczej oferty.",
                maximumPriceLabel = "Maksymalna cena jednostkowa",
                maximumPriceDescription = "Maksymalna cena krypto za jedną jednostkę.",
                maximumMessageLengthLabel = "Maksymalna długość wiadomości",
                maximumMessageLengthDescription = "Maksymalna liczba znaków w zaszyfrowanej wiadomości na czacie.",
                aliasCooldownLabel = "Czas oczekiwania na zmianę aliasu (godziny)",
                aliasCooldownDescription = "Minimalny wiek tożsamości przed ponownym jej wycofaniem.",
                verifiedSalesLabel = "Wymagana liczba sprzedaży do weryfikacji",
                verifiedSalesDescription = "Liczba udanych sprzedaży wymagana, aby sprzedawca mógł zostać zweryfikowany.",
                verifiedRatingLabel = "Wymagana ocena do weryfikacji",
                verifiedRatingDescription = "Minimalna średnia ocena dla zweryfikowanego sprzedawcy.",
                scammerReportsLabel = "Zgłoszenia w celu ostrzeżenia oszusta",
                scammerReportsDescription = "Liczba unikalnych zgłoszeń transakcji wymagana do otrzymania odznaki znanego oszusta.",
                meetingDistanceLabel = "Dystans przekazania",
                meetingDistanceDescription = "Maksymalna odległość między oboma graczami lub od skonfigurowanego punktu NPC.",
                dropModelLabel = "Model skrzyni Dead-drop",
                dropModelDescription = "Model obiektu GTA generowany lokalnie dla dostępnych skrzyń Dead-drop.",
                dropStreamLabel = "Dystans renderowania Dead-drop",
                dropStreamDescription = "Dystans, przy którym skrzynie i kontakty NPC są renderowane.",
                dropInteractionLabel = "Dystans interakcji Dead-drop",
                dropInteractionDescription = "Dystans wymagany do przeszukania i odebrania skrzyni.",
                dropLifetimeLabel = "Czas trwania Dead-drop (godziny)",
                dropLifetimeDescription = "Czas, po którym nieodebrana skrzynia wygasa.",
                dropPollLabel = "Interwał odświeżania świata (ms)",
                dropPollDescription = "Interwał używany do odświeżania pobliskich skrzyń i spotkań NPC.",
                policeGroupsLabel = "Uprawnione grupy zawodowe policji",
                policeGroupsDescription = "Klucze grup w Konfiguratorze pracy, które mogą publikować oferty przynęty i przeglądać dochodzenia.",
                policeGroupEntry = "Grupa policji",
                groupKeyLabel = "Klucz grupy",
                npcTradersLabel = "Kupujący i sprzedający NPC",
                npcTradersDescription = "Konfiguracja trwałych ofert syntetycznych, metody dostawy, reputacji i prawdopodobieństwa oszustwa.",
                npcTraderEntry = "Handlarz NPC",
                npcIdLabel = "ID",
                npcAliasLabel = "Alias",
                npcSideLabel = "Strona rynku",
                sideSell = "Sprzedaje graczom",
                sideBuy = "Kupuje od graczy",
                npcTitleLabel = "Tytuł oferty",
                npcDescriptionLabel = "Opis",
                npcItemNameLabel = "Nazwa przedmiotu ekwipunżu",
                npcItemLabelLabel = "Etykieta towaru",
                npcQuantityLabel = "Ilość",
                npcPriceLabel = "Cena jednostkowa",
                npcDeliveryLabel = "Metoda dostawy",
                deliveryBoth = "Spotkanie i Dead drop",
                deliveryMeeting = "Tylko bezpośrednio",
                deliveryDrop = "Tylko Dead drop",
                npcScamChanceLabel = "Szansa na oszustwo handlarza (%)",
                npcPedModelLabel = "Model postaci NPC",
                npcRatingLabel = "Wyświetlana ocena",
                npcRatingCountLabel = "Wyświetlana liczba ocen",
                npcTradesLabel = "Wyświetlona liczba udanych transakcji",
                npcVerifiedLabel = "Zweryfikowany handlarz",
                npcScammerLabel = "Znany oszust",
                npcEnabledLabel = "Włączone",
            },
            interrogationSettings = {
                section = "Przesłuchanie",
                generalGroup = "Ogólne",
                consentGroup = "Ochrona gracza",
                objectGroup = "Obiekty",
                grabGroup = "Chwytanie",
                sessionGroup = "Sesja",
                dispatchGroup = "Alerty policji",
                loggingGroup = "Logowanie",
                securityGroup = "Bezpieczeństwo",
                presentationGroup = "Prezentacja",
                enabledLabel = "Włącz przesłuchania",
                enabledDescription = "Pozwala graczom przywiązywać innych do krzeseł przesłuchań i używać na nich narzędzi.",
                consentRequiredLabel = "Wymagaj zgody",
                consentRequiredDescription = "Tylko gracze, którzy wyrazili zgodę, mogą stać się ofiarami. Nie ma już przycisku zgody, dlatego wymagane jest poniższe ustawienie.",
                consentDefaultLabel = "Zgoda domyślna",
                consentDefaultDescription = "Nowe postacie zaczynają z udzieloną zgodą zamiast odmowy.",
                globalIntensityLabel = "Intensywność efektów",
                globalIntensityDescription = "Skaluje efekty ekranu, cząsteczki i dźwięk. 0 całkowicie je wyłącza.",
                maxPerPlayerLabel = "Obiekty na gracza",
                maxPerPlayerDescription = "Liczba krzeseł i wózków, jakie może rozstawić jeden gracz. 0 oznacza brak limitu.",
                maxGlobalLabel = "Obiekty na cały serwer",
                maxGlobalDescription = "Maksymalna liczba obiektów, które mogą być rozstawione jednocześnie. 0 oznacza brak limitu.",
                placementDistanceLabel = "Dystans rozstawiania",
                placementDistanceDescription = "Jak daleko od gracza może znajdować się obiekt, w metrach.",
                interactDistanceLabel = "Dystans interakcji",
                interactDistanceDescription = "Dystans interakcji, w metrach, jaki musi zachować gracz, aby użyć krzesła lub wózka.",
                inactivityMinutesLabel = "Automatyczne usuwanie po",
                inactivityMinutesDescription = "Liczba minut bezczynności, po których rozstawiony obiekt znika. 0 sprawia, że zostaje na zawsze.",
                persistObjectsLabel = "Zachowaj obiekty po restarcie",
                persistObjectsDescription = "Rozstawione obiekty zostają przywrócone z bazy danych po ponownym uruchomieniu serwera.",
                grabEnabledLabel = "Włącz chwytanie",
                grabEnabledDescription = "Pozwala graczom obezwładnić i wynieść innego gracza.",
                grabItemLabel = "Wymagany przedmiot",
                grabItemDescription = "Przedmiot, którego napastnik potrzebuje, aby chwycić kogoś. Zostaw puste, aby nie wymagać żadnego.",
                grabAngleLabel = "Kąt podejścia",
                grabAngleDescription = "W stopniach, jak daleko od pozycji bezpośrednio za plecami napastnika może znajdować się postać.",
                grabHealthBelowLabel = "Próg zdrowia",
                grabHealthBelowDescription = "Ofiara poniżej tego poziomu zdrowia może zostać pochwycona bez bycia skrępowaną. 0 wyłącza tę funkcję.",
                grabCooldownLabel = "Czas odzyskiwania po niepowodzeniu",
                grabCooldownDescription = "Liczba sekund przed ponowną próbą nieudanego chwytania.",
                grabVehiclesLabel = "Dozwolone pojazdy",
                grabVehiclesDescription = "Modele pojazdów, do których można załadować pochwyconą ofiarę.",
                carryEnabledLabel = "Pozwól na niesienie",
                carryEnabledDescription = "Pozwala napastnikowi nieść ofiarę na ramieniu.",
                restrictVisionLabel = "Ogranicz widoczność ofiary",
                restrictVisionDescription = "Zasłania ekran ofiary podczas transportu.",
                escapeEnabledLabel = "Pozwól na próby ucieczki",
                escapeEnabledDescription = "Pozwala transportowanej ofierze na próbę wyrwania się.",
                escapeSecondsLabel = "Czas ucieczki",
                escapeSecondsDescription = "Liczba sekund, przez które ofiara musi przytrzymać klawisz, aby się uwolnić.",
                maxDurationLabel = "Maksymalny czas",
                maxDurationDescription = "Liczba minut, po których sesja kończy się automatycznie.",
                warnMinutesLabel = "Ostrzeżenie przed końcem",
                warnMinutesDescription = "Liczba minut przed limitem, po których obie strony otrzymują ostrzeżenie.",
                idleMinutesLabel = "Uwolnienie przy bezczynności",
                idleMinutesDescription = "Liczba minut bez żadnej interakcji, po których ofiara zostaje uwolniona.",
                selfReleaseMinutesLabel = "Samodzielne uwolnienie po",
                selfReleaseMinutesDescription = "Liczba minut bez interakcji ze strony napastnika, po których ofiara może sama się uwolnić.",
                graceSecondsLabel = "Czas karencji po rozłączeniu",
                graceSecondsDescription = "Liczba sekund, przez które ofiara pozostaje związana, gdy napastnik opuści serwer.",
                rescueEnabledLabel = "Pozwól na ratunek",
                rescueEnabledDescription = "Pozwala niezaangażowanym graczom uwolnić związaną ofiarę.",
                rescueSecondsLabel = "Czas ratunku",
                rescueSecondsDescription = "Liczba sekund, których ratownik potrzebuje, aby przeciąć więzy ofiary.",
                rescueItemLabel = "Przedmiot do ratunku",
                rescueItemDescription = "Przedmiot potrzebny ratownikowi. Zostaw puste, aby nie wymagać żadnego.",
                allowInventoryLabel = "Ofiara zachowuje ekwipunek",
                allowInventoryDescription = "Związana ofiara wciąż może otwierać swój ekwipunek.",
                dispatchEnabledLabel = "Włącz powiadomienia dla policji",
                dispatchEnabledDescription = "Zgłaszaj porwania i przesłuchania służbom ratunkowym.",
                dispatchAdapterLabel = "System powiadomień",
                dispatchAdapterDescription = "System dyspozytorski, który odbiera zgłoszenia.",
                dispatchJobsLabel = "Pracownicy przyjmujący zlecenia",
                dispatchJobsDescription = "Zlecenia, które otrzymują powiadomienie.",
                dispatchGrabChanceLabel = "Szansa na obezwładnienie",
                dispatchGrabChanceDescription = "Procentowa szansa na to, że obezwładnienie zostanie zgłoszone.",
                dispatchFixateChanceLabel = "Szansa na związanie",
                dispatchFixateChanceDescription = "Procentowa szansa na to, że związanie kogoś przy krześle zostanie zgłoszone.",
                dispatchToolChanceLabel = "Szansa na użycie narzędzia",
                dispatchToolChanceDescription = "Procentowa szansa na to, że użycie narzędzia zostanie zgłoszone.",
                dispatchWitnessLabel = "Wymagany świadek",
                dispatchWitnessDescription = "Zgłaszaj tylko wtedy, gdy inny gracz znajduje się wystarczająco blisko, aby to zauważyć.",
                dispatchWitnessRadiusLabel = "Promień świadka",
                dispatchWitnessRadiusDescription = "Jak blisko musi znajdować się świadek, w metrach.",
                dispatchCooldownLabel = "Czas odnowienia powiadomienia",
                dispatchCooldownDescription = "Sekundy między dwoma powiadomieniami z tej samej sesji.",
                dispatchInaccuracyLabel = "Nieścisłość pozycji",
                dispatchInaccuracyDescription = "Metry, o które losowo przesuwana jest zgłoszona pozycja. 0 podaje dokładny punkt.",
                loggingEnabledLabel = "Włącz logowanie",
                loggingEnabledDescription = "Rejestruje umieszczanie obiektów, obezwładnianie, użycie narzędzi, zwolnienia i działania administratora.",
                logDatabaseLabel = "Loguj do bazy danych",
                logDatabaseDescription = "Dodatkowo zapisuje każdy wpis w tabeli logów przesłuchań.",
                logRetentionLabel = "Zachowuj wpisy w logach",
                logRetentionDescription = "Liczba dni, po których wpisy w bazie danych są usuwane. 0 przechowuje je na zawsze.",
                pingToleranceLabel = "Tolerancja dystansu",
                pingToleranceDescription = "Metry dodawane do każdego serwerowego sprawdzania dystansu w celu niwelowania opóźnień (lagów).",
                violationThresholdLabel = "Próg naruszeń",
                violationThresholdDescription = "Liczba naruszeń bezpieczeństwa w oknie czasowym przed wyzwoleniem reakcji. 0 wyłącza to.",
                violationActionLabel = "Reakcja na naruszenia",
                violationActionDescription = "Co się dzieje, gdy gracz przekroczy próg naruszeń.",
                violationActionNone = "Nic nie rób",
                violationActionLog = "Tylko loguj",
                violationActionKick = "Wyrzuć (Kick)",
                violationActionCheating = "Zgłoś jako oszustwo",
                particlesLabel = "Efekty cząsteczkowe",
                particlesDescription = "Pokazuj krew, iskry i płomienie podczas używania narzędzi.",
                soundLabel = "Efekty dźwiękowe",
                soundDescription = "Odtwarzaj dźwięki narzędzi dla wszystkich w pobliżu.",
                cameraWorkLabel = "Praca kamery",
                cameraWorkDescription = "Ruszaj kamerą podczas wiązania kogoś i podczas używania narzędzi.",
                screenEffectsLabel = "Efekty ekranu",
                screenEffectsDescription = "Trzęsienie, błyski, rozmycie i filtry kolorów na ekranie ofiary.",
                objectsSection = "Obiekty przesłuchań",
                objectsEntry = "Obiekt",
                objectsEditLabel = "Obiekty przesłuchań",
                objectsEditDescription = "Umieszczaj stałe krzesła i wózki z narzędziami na mapie.",
                objectsEditButton = "Edytuj obiekty",
                objectsKindLabel = "Typ obiektu",
                objectsKindChair = "Krzesło",
                objectsKindCart = "Wózek z narzędziami",
                objectsModelLabel = "Model propu",
                objectsPositionLabel = "Pozycja",
                blockedZonesSection = "Strefy zablokowane",
                blockedZonesEntry = "Strefa",
                blockedZonesEditLabel = "Strefy zablokowane",
                blockedZonesEditDescription = "Obszary, w których nie można umieszczać obiektów przesłuchań.",
                blockedZonesEditButton = "Edytuj strefy",
                blockedZonesZoneLabel = "Zarys strefy",
                blockedZonesZoneDescription = "Przeciągnij rogi, aby wyznaczyć obszar, w którym umieszczanie obiektów jest zabronione.",
                toolsSection = "Narzędzia",
                toolsEntry = "Narzędzie",
                toolsEditLabel = "Narzędzia",
                toolsEditDescription = "Dodaj lub dostosuj narzędzia, które można wykorzystać na ofierze.",
                toolsEditButton = "Edytuj narzędzia",
                toolsItemLabel = "Wymagany przedmiot",
                toolsConsumeLabel = "Zużyj przedmiot",
                toolsDamageLabel = "Obrażenia przy użyciu",
                toolsHealthFloorLabel = "Próg zdrowia",
                toolsCooldownLabel = "Czas odnowienia (sekundy)",
                toolsProgressLabel = "Postęp przy użyciu",
                sessionsSection = "Trwające przesłuchania",
                sessionsEntry = "Przesłuchanie",
                sessionsEditLabel = "Trwające przesłuchania",
                sessionsEditDescription = "Zobacz, kto jest obecnie przesłuchiwany, i zakończ przesłuchanie w razie potrzeby.",
                sessionsEditButton = "Pokaż przesłuchania",
                sessionsStateLabel = "Status",
                sessionsProgressLabel = "Postęp",
                orphansSection = "Osierocone obiekty",
                orphansEntry = "Obiekt",
                orphansEditLabel = "Osierocone obiekty",
                orphansEditDescription = "Usuń obiekty, których właściciele nie byli widoczni od dłuższego czasu.",
                orphansEditButton = "Sprzątnij",
                sessionStates = {
                    binding = "Unieruchamianie",
                    active = "Aktywna",
                    ending = "Kończenie",
                },
            },
        },
    },
}
