JobConfigLocales["sky_policejob:pl"] = {
    JobConfiguratorComingSoon = "Ten konfigurator zadania będzie dostępny wkrótce.",
    JobConfiguratorNoPermission = "Nie masz uprawnień do używania tej komendy.",
    Nui = {
        workshopConfig = {
            configs = {
                sky_policejob = {
                    subtitle = "Konfiguruj posterunki policji, sklepy, rekwizyty, pojazdy, stacje oraz ustawienia funkcji podstawowych.",
                    title = "Zadanie policyjne",
                },
            },
            dispatchActions = {
                addChannel = "Dodaj kanał radiowy",
                addKeyword = "Dodaj słowo kluczowe",
                addPoi = "Dodaj punkt POI",
                addReporter = "Dodaj zgłaszającego",
                addStatus = "Dodaj status FMS",
                addVehicle = "Dodaj jednostkę wirtualną",
                addVehicleType = "Dodaj typ jednostki",
                currentLocation = "Użyj bieżącej lokalizacji",
            },
            dispatchFieldDescriptions = {
                autoAlarm = "Natychmiast przydziela dopasowanie dostępnych jednostek, gdy powstanie incydent.",
                available = "Jednostki w tym stanie mogą być sugerowane i przypisane do nowego incydentu.",
                averageResponseSpeedKmh = "Oblicza wyświetlane szacunki przybycia z odległości prostej.",
                callsign = "Unikalny radiowy sygnał wywoławczy pokazany, gdy gracze pracownicy tej wirtualnej jednostki.",
                centerEnabled = "Umożliwia upoważnionym członkom służby obsługę centrali.",
                channelId = "Identyfikator kanału radiowego dla PMA Voice, SaltyChat i Yaca. Numeryczne identyfikatory takie jak 2500 pozostają niezmienione; PMA Voice mapuje identyfikatory tekstu do stabilnej liczby.",
                channelLabel = "Czytelna nazwa kanału pokazywana dyspozytorom i jednostkom.",
                crewCapacity = "Maksymalna liczba osób w jednostce. Wartość 0 oznacza nieograniczoną załogę.",
                defaultChannel = "Dyspozytorzy dołączają do tego kanału, rozpoczynając swoją zmianę. Jednostki łączą się ręcznie z zakładki Radio. Wybierz None, aby użyć domyślnej grupy job-.",
                emergencyAppEnabled = "Sprawia, że to zadanie jest wybieralne jako usługa publiczna w aplikacji telefonu awaryjnego.",
                enabled = "Udostępnia to zadanie aplikacji wysyłkowej i incydentów związanych z pracą krzyżową.",
                icon = "Wybierz ikonę dla tej kategorii jednostek w aplikacji Dispatch.",
                incidentAssessmentEnabled = "Pokazuje pytania medyczne i niebezpieczeństwa w pełnym spożyciu incydentu.",
                jobs = "Dodatkowe nazwy zadań, które otrzymują incydenty używając tego słowa kluczowego.",
                joinLocked = "Uniemożliwia kolejnym osobom dołączenie po obsadzeniu jednostki.",
                minimumCrew = "Minimalna liczba osób w jednostkach wybranych dla tego planu reagowania.",
                noUnitFallback = "Bez centrum lub zespołu, wysyła powiadomienie Sky do wszystkich członków na służbie.",
                poiId = "Stały identyfikator techniczny dostępny dla profili dyspozytorni także po zmianie nazwy punktu.",
                radius = "Maksymalna odległość w metrach, na której można usłyszeć ogłoszenie stacji.",
                readyStatusCode = "Status FMS ustawiany, gdy zasób staje się gotowy do zadysponowania.",
                requirements = "Zapotrzebowanie na odpowiedź jako typ: pary COUNT, na przykład PATROL: 2, CRIME: 1.",
                resourceType = "Klasyfikuje zasób operacyjny na potrzeby filtrów i koordynacji dyspozytorni.",
                respondingStatusCode = "Status FMS ustawiany, gdy zasób wyjeżdża do zdarzenia.",
                shortLabel = "Opcjonalna krótka etykieta na sześciu przyciskach pamięci kanałów radiowych.",
                stationId = "Przypisuje jednostkę do stacji skonfigurowanej w profilu dyspozytorni.",
                statusCode = "Numeryczny status FMS pokazany na palmtopie.",
                statusLabel = "Znaczenie statusu FMS dla dyspozytorów i jednostek.",
                unitId = "Stały identyfikator techniczny zachowujący jednostkę po zmianie jej kryptonimu.",
                vehicleType = "Musi pasować do kodu typu pojazdu skonfigurowanego w poprzedniej podsekcji.",
                vehicleTypeCode = "Krótki kod jednostki stosowany w wymogach dotyczących odpowiedzi, na przykład PATROL, CRIME, EMS lub RESCUE.",
                vehicleTypeLabel = "Czytelna nazwa tej kategorii jednostek.",
            },
            dispatchFields = {
                address = "Adres",
                autoAlarm = "Automatyczny alarm",
                available = "Dostępne do wysyłki",
                averageResponseSpeedKmh = "Szacowana prędkość reakcji (km / h)",
                callsign = "Znak wywoławczy",
                category = "Kategoria",
                centerEnabled = "Włącz centrum wysyłki",
                channelId = "Identyfikator kanału",
                code = "Kod",
                crewCapacity = "Pojemność załogi",
                defaultChannel = "Domyślny kanał radiowy",
                emergencyAppEnabled = "Pokaż w aplikacji awaryjnej",
                enabled = "Włącz wysyłkę",
                icon = "Ikona",
                incidentAssessmentEnabled = "Włącz ocenę sytuacji wyjątkowej",
                jobs = "Miejsca pracy docelowe (oddzielone przecinkami)",
                joinLocked = "Zablokuj dołączanie załogi",
                keywordCode = "Kod słów kluczowych",
                label = "Etykieta",
                minimumCrew = "Minimalna załoga",
                name = "Nazwa",
                noUnitFallback = "Informuj pracowników na służbie bez jednostek",
                noneChannel = "Domyślny brak / grupa",
                note = "Uwaga",
                phone = "Telefon",
                poiId = "Stały identyfikator punktu POI",
                radius = "Promień ogłoszenia",
                readyStatusCode = "Kod statusu gotowości",
                requirements = "Wymagane jednostki (na przykład PATROL: 2, CRIME: 1)",
                resourceType = "Typ zasobu",
                respondingStatusCode = "Kod statusu wyjazdu",
                shortLabel = "Etykieta pamięci radia",
                stationId = "Identyfikator stacji",
                type = "Typ",
                unitId = "Stały identyfikator jednostki",
                vehicleType = "Typ jednostki odpowiedzi",
                radioButton = "Przycisk",
                radioButtonAction = "Działanie przycisku",
                radioButtonStatus = "Status FMS",
            },
            dispatchIconOptions = {
                crime = "Wydział Kryminalny",
                emergency = "Jednostka ratunkowa",
                ems = "Jednostka EMS",
                fire = "Jednostka pożarowa",
                heavy = "Jednostka ciężka",
                k9 = "Jednostka K- 9",
                medical = "Jednostka medyczna",
                patrol = "Patrol",
                rescue = "Jednostka ratownicza",
                service = "Jednostka usługowa",
                supervisor = "Inspektor",
                tactical = "Jednostka taktyczna",
            },
            dispatchNavigation = {
                active = "Wysyłka aktywna",
                description = "Skonfiguruj dane do tego zadania.",
                inactive = "Centrala wyłączona",
                steps = {
                    accessText = "Włącz wysyłkę i zdecyduj, czy ta praca może obsługiwać centrum wysyłkowe.",
                    accessTitle = "Dostęp i wejście awaryjne",
                    fleetText = "Konfiguracja kanałów, kodów statusu FMS, typów pojazdów i znaków wywoławczych.",
                    fleetTitle = "Radio i flota",
                    responseText = "Zakończ słowami kluczowymi, wymogami odpowiedzi i POI.",
                    responseTitle = "Plany odpowiedzi",
                },
                summary = {
                    channels = "Kanały radiowe",
                    plans = "Plany odpowiedzi",
                    reporters = "Znani zgłaszający",
                    statuses = "Dostępne FMS",
                    units = "Jednostki wirtualne",
                },
                title = "Wysyłka",
                warnings = {
                    channels = "Nie istnieją wyraźne kanały radiowe; zostanie użyty kanał awaryjny dla grup roboczych.",
                    defaultChannel = "Wybrany domyślny kanał już nie istnieje.",
                    disabled = "Centrala jest wyłączona.",
                    statuses = "Co najmniej jeden status FMS musi być dostępny, aby jednostki mogły być alarmowane.",
                },
            },
            extensionDescriptions = {
                dispatchChannels = "Określa kanały radiowe, do których mogą dołączyć jednostki i centra wysyłkowe.",
                dispatchKeywords = "Określa słowa kluczowe zdarzeń, wymagane numery pojazdów, miejsca pracy i opcjonalne automatyczne alarmowanie.",
                dispatchPois = "Stacje magazynowe i wspólne lokalizacje dla formularzy zdarzeń i ogłoszeń stacji opartych na pozycji.",
                dispatchReporters = "Zarządza nazwami zgłaszających, numerami zwrotnymi i notatkami dyspozytorni dla tej pracy.",
                dispatchStatusCodes = "Konfiguruje etykiety statusu FMS i które statusy liczą się jako dostępne dla nowych incydentów.",
                dispatchVehicleTypes = "Określa kategorie jednostek stosowane w planach reagowania, takie jak Patrol, Wydział Przestępczości, EMS lub Rescue.",
                dispatchVehicles = "Określa wirtualne pojazdy wysyłające, które mogą być obsługiwane z dowolnego miejsca bez konieczności posiadania pojazdu tarłowego.",
                dispatchRadioButtons = "Ustawia centralnie zdefiniowane działanie dla każdego przycisku funkcji fizycznej.",
                dispatchRadioFmsKeys = "Przypisuje status FMS do fizycznych kluczy numerów. Klawiatura wykonuje tylko FMS zmiany.",
            },
            extensions = {
                caseNumbering = {
                    label = "Numery spraw",
                    description = "Skonfiguruj automatyczne numery spraw dla tej pracy.",
                    fields = {
                        prefix = {
                            label = "Prefiks sprawy",
                            description = "Prefiks nowych spraw, np. LSPD lub LSCSD. Do 16 znaków, zamienianych na wielkie litery; puste pole oznacza CASE. Istniejące i ręcznie nadane numery pozostają bez zmian.",
                        },
                    },
                },
                dispatchReporters = "Znani zgłaszający",
                invalidSelection = "Nieprawidłowy wybór: {value}",
                trainingSettings = {
                    description = "Konfiguracja dostępu do szkoleń, rejestracji, zatwierdzeń i planowania kursu dla tej pracy.",
                    label = "Ustawienia treningu",
                },
                dispatchChannels = "Kanały radiowe",
                dispatchKeywords = "Słowa kluczowe i plany odpowiedzi",
                dispatchPois = "Wysyłka POI",
                dispatchSettings = {
                    description = "Konfiguracja dostępu do wysyłki, awaryjnego podania i domyślnego kanału radiowego.",
                    label = "Ustawienia dyspozycji",
                },
                dispatchStatusCodes = "Kody stanu",
                dispatchVehicleTypes = "Typy pojazdów dystrybucyjnych",
                dispatchVehicles = "Wysyłka danych floty",
                emptyDescription = "Użyj przycisku dodawania powyżej, aby utworzyć pierwszy wpis.",
                emptyTitle = "Jeszcze nic skonfigurowanego",
                dispatchRadioButtons = "Przyciski funkcji radiowej",
                dispatchRadioFmsKeys = "FMS Przypisanie kluczy",
            },
            features = {
                billing = {
                    description = "Włącz procesy rozliczeń policyjnych.",
                    label = "Rozliczenia",
                },
                devices = {
                    description = "Włącz rozmieszczalne urządzenia egzekwowania prawa.",
                    label = "CCTV i fotoradary",
                },
                evidence = {
                    description = "Włącz magazyn dowodów, dowody terenowe i procesy skanera.",
                    label = "Dowody",
                },
                impound = {
                    description = "Włącz procesy parkingu strzeżonego.",
                    label = "Parking strzeżony",
                },
                jail = {
                    description = "Włącz przydzielanie wyroków więzienia i aktywności więźniów.",
                    label = "Więzienie",
                },
                propPlacement = {
                    description = "Włącz konfigurowalne rekwizyty policyjne i wyposażenie w rekwizyty pojazdów.",
                    label = "Rozmieszczanie rekwizytów",
                },
                radial = {
                    description = "Włącz policyjne akcje radialne, takie jak zajęcie pojazdu i blokada koła.",
                    label = "Akcje radialne",
                },
                restraints = {
                    description = "Włącz kajdanki, taśmy ZIP, kraty na nogi i worki na głowę.",
                    label = "Środki obezwładniające",
                },
                socialWork = {
                    description = "Włącz przydzielanie pracy socjalnej i aktywności zadaniowe.",
                    label = "Praca socjalna",
                },
                tablet = {
                    description = "Włącz aplikacje tabletu policyjnego skonfigurowane przez ten zasób.",
                    label = "Tablet policyjny",
                },
                tracking = {
                    description = "Włącz lokalizatory GPS i monitory kostne.",
                    label = "Śledzenie",
                },
                vehicleRadar = {
                    description = "Włącz radar pojazdu patrolowego.",
                    label = "Radar pojazdu",
                },
            },
            messages = {
                dispatchEmergencyRequiresDispatch = "Wyświetlanie tej pracy w aplikacji alarmowej wymaga włączonej dyspozytorni. Włącz dyspozytornię lub wyłącz wyświetlanie w aplikacji alarmowej w ustawieniach dyspozytorni.",
                dispatchJobNotCovered = "Żadna aktywna dyspozytornia nie obsługuje pracy „{job}”. W sky_jobs_base/config/config.lua dodaj „{job}” do coveredJobs w odpowiednim profilu Config.Dispatch.centers, a następnie uruchom ponownie sky_jobs_base. Resetowanie ustawień nie zmienia tego przypisania.",
                invalidDispatchChannels = "Identyfikatory kanałów radiowych muszą być unikalne, a każdy kanał wymaga prawidłowej etykiety.",
                invalidDispatchDefaultChannel = "Domyślny kanał radiowy nie istnieje. W ustawieniach dyspozytorni wybierz istniejący kanał lub „Brak”.",
                invalidDispatchKeywords = "Plany reagowania muszą mieć unikalne kody i prawidłowe wymagania TYP:LICZBA.",
                invalidDispatchPois = "Identyfikatory, nazwy i współrzędne punktów POI muszą być prawidłowe i unikalne.",
                invalidDispatchRadioButtons = "Sprawdź przyciski funkcyjne radia: użyj każdego obsługiwanego przycisku tylko raz i wybierz działanie z jego listy.",
                invalidDispatchRadioFmsKeys = "Sprawdź klawisze FMS radia: użyj każdego klawisza (0-9, * lub #) tylko raz i przypisz istniejący kod statusu albo pozostaw go bez przypisania.",
                invalidDispatchReadyStatus = "W ustawieniach dyspozytorni wybierz kod gotowości oznaczony jako dostępny na liście kodów statusu.",
                invalidDispatchReporters = "Dane znanych zgłaszających przekraczają dozwoloną liczbę wpisów lub długość pól.",
                invalidDispatchRespondingStatus = "W ustawieniach dyspozytorni wybierz kod wyjazdu do zdarzenia oznaczony jako niedostępny na liście kodów statusu.",
                invalidDispatchSettings = "Wybierz istniejący dostępny status gotowości, niedostępny status wyjazdu i prawidłowy kanał domyślny.",
                invalidDispatchStatusCodes = "Kody FMS muszą być unikalne, a co najmniej jeden status musi być dostępny.",
                invalidDispatchVehicleTypes = "Kody typów jednostek reagowania muszą być unikalne i kompletne.",
                invalidDispatchVehicles = "Identyfikatory i kryptonimy jednostek muszą być unikalne, a wszystkie typy i stacje muszą istnieć.",
            },
            settingFields = {
                gangMinimumGrade = "Minimalna ranga",
                gang = "GANG",
                component = "Komponent",
                description = "Opis",
                fineAmount = "Kwota grzywny",
                itemName = "Nazwa przedmiotu",
                length = "Długość",
                max = "Maks",
                maxOverKmh = "Maks. przekroczenie",
                min = "Min",
                minOverKmh = "Min. przekroczenie",
                model = "Model rekwizytu",
                propModel = "Model rekwizytu",
                reason = "Powód",
                vehicleClass = "Klasa",
            },
            settingGroups = {
                access = {
                    label = "Dostęp",
                },
                animation = {
                    label = "Animacja",
                },
                ankleMonitor = {
                    label = "Monitor kostny",
                },
                ankleMonitorAccess = {
                    label = "Dostęp do monitora kostnego",
                },
                ankleMonitorPlacement = {
                    label = "Zakładanie monitora kostnego",
                },
                ankleMonitorZone = {
                    label = "Strefa monitora kostnego",
                },
                ankleMonitorZoneVisual = {
                    label = "Wygląd strefy monitora kostnego",
                },
                assignment = {
                    label = "Przydział",
                },
                blip = {
                    label = "Ikona stacji",
                },
                carry = {
                    label = "Przenoszenie",
                },
                cctv = {
                    label = "CCTV",
                },
                cctvDurability = {
                    label = "Trwałość CCTV",
                },
                cctvPlacement = {
                    label = "Rozmieszczenie CCTV",
                },
                cctvRepair = {
                    label = "Naprawa CCTV",
                },
                cctvRepairAnimation = {
                    label = "Animacja naprawy CCTV",
                },
                clamp = {
                    label = "Blokada koła",
                },
                clampWeld = {
                    label = "Spawanie blokady koła",
                },
                cleanup = {
                    label = "Czyszczenie",
                },
                collection = {
                    label = "Zbieranie",
                },
                controls = {
                    label = "Sterowanie",
                },
                creator = {
                    label = "Kreator",
                },
                crimeSceneTape = {
                    label = "Taśma miejsca zbrodni",
                },
                crimeSceneTapeAccess = {
                    label = "Dostęp do taśmy",
                },
                crimeSceneTapeInventory = {
                    label = "Ekwipunek taśmy",
                },
                crimeSceneTapeLength = {
                    label = "Długość taśmy",
                },
                crimeSceneTapePlacement = {
                    label = "Rozstawianie taśmy",
                },
                database = {
                    label = "Baza danych",
                },
                delivery = {
                    label = "Dostawa",
                },
                detection = {
                    label = "Wykrywanie",
                },
                dispatch = {
                    label = "Dyspozytornia",
                },
                escape = {
                    label = "Wyrwanie się",
                },
                escort = {
                    label = "Eskorta",
                },
                evidenceStorage = {
                    label = "Magazyn dowodów",
                },
                fastLock = {
                    label = "Automatyczna szybka blokada",
                },
                general = {
                    label = "Ogólne",
                },
                gpsTracker = {
                    label = "Lokalizator GPS",
                },
                gpsTrackerAccess = {
                    label = "Dostęp do lokalizatora GPS",
                },
                gpsTrackerPlacement = {
                    label = "Umieszczanie lokalizatora GPS",
                },
                gpsTrackerTiming = {
                    label = "Czasy lokalizatora GPS",
                },
                handcuffs = {
                    label = "Kajdanki",
                },
                handsUp = {
                    label = "Ręce do góry",
                },
                header = {
                    label = "Nagłówek",
                },
                impound = {
                    label = "Parking strzeżony",
                },
                imprisonment = {
                    label = "Uwięzienie",
                },
                jailCanteenGeneral = {
                    label = "Kantyna więzienna",
                },
                jailCanteenPackage = {
                    label = "Paczka z kantyny",
                },
                jailCarry = {
                    label = "Praca transportowa",
                },
                jailCarryInspection = {
                    label = "Inspekcja przenoszenia",
                },
                jailCleaning = {
                    label = "Praca sprzątająca",
                },
                jailCleaningIllegalFinds = {
                    label = "Znaleziska nielegalnych przedmiotów",
                },
                jailCleaningOutline = {
                    label = "Obrys śmieci",
                },
                jailDoctor = {
                    label = "Lekarz więzienny",
                },
                jailElectricalCodes = {
                    label = "Kody elektryczne",
                },
                jailElectricalGeneral = {
                    label = "Instalacja elektryczna więzienia",
                },
                jailElectricalPenalties = {
                    label = "Kary elektryczne",
                },
                jailElectricalRewards = {
                    label = "Nagrody elektryczne",
                },
                jailInmatesAlcoholic = {
                    label = "Więzień: Alkoholik",
                },
                jailInmatesCodeList = {
                    label = "Więzień: Informator",
                },
                jailInmatesDrugDealer = {
                    label = "Więzień: Diler narkotyków",
                },
                jailInmatesWireCutter = {
                    label = "Więzień: Dostawca narzędzi",
                },
                jailJobs = {
                    label = "Prace więzienne",
                },
                jailOutfitFemale = {
                    label = "Strój żeński",
                },
                jailOutfitMale = {
                    label = "Strój męski",
                },
                keybinds = {
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                    label = "Klawisze",
                },
                keybindsHandcuff = {
                    label = "Skrót zakładania kajdanek",
                },
                keybindsUnhandcuff = {
                    label = "Skrót zdejmowania kajdanek",
                },
                marker = {
                    label = "Znacznik",
                },
                markerColor = {
                    label = "Kolor znacznika",
                },
                mugshotAnimation = {
                    label = "Animacja zdjęcia aresztowego",
                },
                mugshotBoard = {
                    label = "Tablica zdjęcia aresztowego",
                },
                mugshotCameraCoords = {
                    label = "Pozycja kamery zdjęcia aresztowego",
                },
                mugshotCameraRotation = {
                    label = "Obrót kamery zdjęcia aresztowego",
                },
                mugshotGeneral = {
                    label = "Zdjęcie aresztowe",
                },
                mugshotMetadata = {
                    label = "Metadane zdjęcia aresztowego",
                },
                mugshotPosition = {
                    label = "Pozycja zdjęcia aresztowego",
                },
                mugshotTiming = {
                    label = "Czasy zdjęcia aresztowego",
                },
                officerDown = {
                    label = "Funkcjonariusz ranny",
                },
                outfit = {
                    label = "Strój",
                },
                overlay = {
                    label = "Nakładka tablicy rejestracyjnej",
                },
                payment = {
                    label = "Płatność",
                },
                paymentFlow = {
                    label = "Proces płatności",
                },
                penalties = {
                    label = "Kary",
                },
                playerSearch = {
                    label = "Przeszukanie gracza",
                },
                playerSearchAnimation = {
                    label = "Animacja przeszukania gracza",
                },
                props = {
                    label = "Rekwizyty",
                },
                reasons = {
                    label = "Powody",
                },
                release = {
                    label = "Wydanie pojazdu",
                },
                restore = {
                    label = "Przywracanie",
                },
                rules = {
                    label = "Zasady",
                },
                scan = {
                    label = "Skanowanie",
                },
                scanner = {
                    label = "Skaner",
                },
                sentence = {
                    label = "Wyrok",
                },
                shotsFired = {
                    label = "Strzały oddane",
                },
                sound = {
                    label = "Dźwięk",
                },
                speedcam = {
                    label = "Fotoradary",
                },
                speedcamBilling = {
                    label = "Rozliczenia fotoradaru",
                },
                speedcamDispatch = {
                    label = "Dyspozytornia fotoradaru",
                },
                speedcamDurability = {
                    label = "Trwałość fotoradaru",
                },
                speedcamPlacement = {
                    label = "Rozmieszczenie fotoradaru",
                },
                speedcamRepair = {
                    label = "Naprawa fotoradaru",
                },
                speedcamRepairAnimation = {
                    label = "Animacja naprawy fotoradaru",
                },
                speedcamTiming = {
                    label = "Czasy fotoradaru",
                },
                speedcamVisual = {
                    label = "Wygląd fotoradaru",
                },
                speedcams = {
                    label = "Fotoradary",
                },
                storage = {
                    label = "Magazyn",
                },
                subscription = {
                    label = "Subskrypcja aplikacji",
                },
                tasks = {
                    label = "Zadania",
                },
                theme = {
                    label = "Motyw",
                },
                timing = {
                    label = "Czasy",
                },
                warningUi = {
                    label = "Interfejs ostrzeżenia",
                },
                world = {
                    label = "Świat",
                },
                zipties = {
                    label = "Taśmy ZIP",
                },
                ziptiesCutter = {
                    label = "Przecinak do taśm ZIP",
                },
                cctvMotionDetection = {
                    label = "Wykrywanie ruchu",
                },
                cctvMotionDispatch = {
                    label = "Wysyłacz wykrywania ruchu",
                },
                cctvMotionTiming = {
                    label = "Czas wykrywania ruchu",
                },
                display = {
                    label = "Wyświetl",
                },
                gsr = {
                    label = "GSR",
                },
                reports = {
                    label = "Raporty",
                },
                speedcamAdvanced = {
                    label = "Zaawansowany aparat prędkości",
                },
                tackle = {
                    label = "Powalenie",
                },
                vin = {
                    label = "VIN Sprawdź",
                },
            },
            settingSections = {
                radarGun = "Pistolet radarowy",
                billing = "Rozliczenia",
                cctv = "CCTV",
                dispatch = "Dyspozytornia",
                equipment = "Wyposażenie",
                evidence = "Dowody",
                impound = "Parking strzeżony",
                jail = "Więzienie",
                radar = "Radar pojazdu",
                radial = "Akcje radialne",
                restraints = "Środki obezwładniające",
                socialWork = "Praca socjalna",
                speedCamera = "Fotoradar",
                spikeStrips = "Kolczatki",
                stations = "Stacje",
                tablet = "Aplikacje tabletu",
                tracking = "Śledzenie",
                fakePlates = "Płyty fałszywe",
                general = "Ogólny",
            },
            settingSubsections = {
                app = "Aplikacja fotoradaru",
                apps = "Aplikacje",
                billing = "Rozliczenia",
                canteen = "Kantyna więzienna",
                dispatch = "Dyspozytornia",
                durability = "Trwałość",
                electrical = "Instalacja elektryczna więzienia",
                general = "Ogólne",
                handcuffs = "Kajdanki i opaski zaciskowe",
                inmates = "Więźniowie",
                jobs = "Prace więzienne",
                keybinds = "Klawisze",
                motionDetection = "Wykrywanie ruchu",
                mugshot = "Zdjęcie aresztowe",
                placement = "Rozmieszczenie",
                repair = "Naprawa",
                timing = "Czasy",
                visuals = "Wygląd",
            },
            settings = {
                radarGunClearKey = { label = "Pistolet radarowy: Wyczyść pomiar" },
                radarGunToggleUiKey = { label = "Pistolet radarowy: Przełącz interfejs" },
                radarGunNoTargetHoldMs = { label = "Czas zachowania celu (ms)" },
                radarGunMinimumReading = { label = "Najniższa wyświetlana prędkość" },
                radarGunSpeedSmoothing = { label = "Wygładzanie prędkości (0–1)" },
                radarGunBeamRadius = { label = "Promień wiązki (m)" },
                radarGunRefreshRateMs = { label = "Odstęp pomiarów (ms)" },
                radarGunUseMph = { label = "Używaj MPH", description = "Wyświetla pomiary w milach na godzinę zamiast kilometrów na godzinę." },
                radarGunRange = { label = "Zasięg pomiaru", description = "Maksymalna odległość w metrach, z której pistolet radarowy wykrywa pojazdy." },
                radarGunRequireOnDuty = { label = "Wymagaj służby", description = "Wymaga, aby funkcjonariusz był na służbie przed pomiarem pojazdów pistoletem radarowym." },
                radarGunAllowedJobs = { label = "Dozwolone prace lub grupy", description = "police obejmuje wszystkie skonfigurowane prace policyjne; można też podać nazwy bezpośrednio. Pusta lista wyłącza ograniczenia pracy.", itemLabel = "Praca lub grupa" },
                radarGunEnabled = { label = "Pistolet radarowy", description = "Włącza ręczny pistolet radarowy SKY SR-2." },
                fakePlateVinAllowedGangs = {
                    label = "Dozwolone gangi",
                    description = "Wybierz wewnętrzne nazwy gangów lub niezależnych organizacji. Zgodny zawód lub gang przyznaje uprawnienie lub wyjątek. Służba jest wymagana tylko dla zawodów.",
                    itemLabel = "GANG",
                },
                fakePlateVinAllowedGangGrades = {
                    label = "Minimalne rangi gangów",
                    description = "Opcjonalne minimalne rangi gangów. Pusta lista pozwala na wszystkie rangi. Wymagania przedmiotów nadal obowiązują.",
                },

                speedCamProcessingMode = {
                    description = "Wybierz natychmiastowe pobranie, płatność w ustawionym terminie lub tylko kontrolę funkcjonariusza.",
                    label = "Tryb obsługi",
                    options = {
                        instant = "Pobierz od razu",
                        later = "Zapłać później (domyślnie)",
                        review = "Tylko kontrola funkcjonariusza",
                    },
                },
                tabletRegistry = { label = "Rejestr", description = "Włącz własne rejestry RP w File Explorer. Akta obywateli i pojazdów pozostają dostępne osobno." },
                tabletFiles = { label = "Eksplorator plików", description = "Grupuje akta policyjne w eksploratorze plików. Dokumenty DOJ są widoczne tylko przy aktywnym DOJ." },
                ankleMonitorAnimDurationMs = {
                    description = "Liczba milisekund poświęcona na zakładanie monitora kostnego.",
                    label = "Czas zakładania",
                },
                ankleMonitorAnimScenario = {
                    description = "Scenariusz odtwarzany podczas zakładania monitora kostnego.",
                    label = "Scenariusz zakładania",
                },
                ankleMonitorAttachBone = {
                    description = "Kość peda używana do przymocowania rekwizytu monitora kostnego.",
                    label = "Kość mocowania",
                },
                ankleMonitorConsumeOnPlace = {
                    description = "Usuń przedmiot monitora kostnego po założeniu.",
                    label = "Zużyj monitor kostny",
                },
                ankleMonitorCutItem = {
                    description = "Przedmiot z ekwipunku używany do usuwania monitorów kostnych.",
                    label = "Przedmiot do przecinania",
                },
                ankleMonitorEnabled = {
                    description = "Włącz zakładanie monitora kostnego.",
                    label = "Monitor kostny",
                },
                ankleMonitorItem = {
                    description = "Przedmiot z ekwipunku używany do zakładania monitorów kostnych.",
                    label = "Przedmiot monitora kostnego",
                },
                ankleMonitorMapUpdateIntervalMs = {
                    description = "Liczba milisekund między aktualizacjami monitora kostnego na mapie.",
                    label = "Interwał aktualizacji mapy",
                },
                ankleMonitorPersistOnDisconnect = {
                    description = "Zachowuje monitory kostne w bazie danych po rozłączeniu monitorowanych graczy, aby przywrócić je po ponownym połączeniu i restarcie serwera.",
                    label = "Zachowaj po rozłączeniu",
                },
                ankleMonitorPlaceDistance = {
                    description = "Maksymalna odległość do założenia monitora kostnego.",
                    label = "Odległość zakładania",
                },
                ankleMonitorPropModel = {
                    description = "Model rekwizytu używany dla wyglądu monitora kostnego.",
                    label = "Model rekwizytu",
                },
                ankleMonitorRequireOnDuty = {
                    description = "Wymagaj stanu służby przed użyciem monitorów kostnych.",
                    label = "Monitor kostny wymaga służby",
                },
                ankleMonitorRequirePoliceJob = {
                    description = "Wymagaj, aby gracz należał do grupy policyjnej przed użyciem monitorów kostnych.",
                    label = "Monitor kostny wymaga pracy w policji",
                },
                ankleMonitorReturnOnRemove = {
                    description = "Zwróć przedmiot monitora kostnego po jego usunięciu.",
                    label = "Zwróć monitor kostny przy usunięciu",
                },
                ankleMonitorWarningSeconds = {
                    description = "Czas ostrzeżenia przed zgłoszeniem naruszenia strefy monitora kostnego.",
                    label = "Sekundy ostrzeżenia strefy",
                },
                ankleMonitorZoneBeepIntervalMs = {
                    description = "Liczba milisekund między sygnałami ostrzegawczymi strefy monitora kostnego.",
                    label = "Interwał sygnału strefy",
                },
                ankleMonitorZoneBeepSound = {
                    description = "Nazwa dźwięku używanego dla ostrzeżeń strefy monitora kostnego.",
                    label = "Dźwięk sygnału",
                },
                ankleMonitorZoneBeepSoundSet = {
                    description = "Zestaw dźwiękowy używany dla ostrzeżeń strefy monitora kostnego.",
                    label = "Zestaw dźwięku sygnału",
                },
                ankleMonitorZoneBlipAlpha = {
                    description = "Wartość przezroczystości używana dla ikon strefy monitora kostnego.",
                    label = "Przezroczystość ikony",
                },
                ankleMonitorZoneBlipColorAllowed = {
                    description = "Kolor ikony używany, gdy cel znajduje się w dozwolonym obszarze.",
                    label = "Kolor ikony dozwolonej strefy",
                },
                ankleMonitorZoneBlipColorExcluded = {
                    description = "Kolor ikony używany, gdy cel opuści dozwolony obszar.",
                    label = "Kolor ikony przekroczenia strefy",
                },
                ankleMonitorZoneCheckIntervalMs = {
                    description = "Liczba milisekund między sprawdzeniami strefy monitora kostnego.",
                    label = "Interwał sprawdzania strefy",
                },
                ankleMonitorZoneDispatchCooldownSeconds = {
                    description = "Liczba sekund przed możliwością wysłania kolejnego zgłoszenia strefy monitora kostnego.",
                    label = "Odnowienie zgłoszenia strefy",
                },
                ankleMonitorZoneEnabled = {
                    description = "Włącz sprawdzanie stref monitora kostnego.",
                    label = "Strefy monitora kostnego",
                },
                ankleMonitorZoneLabelSprite = {
                    description = "Sprite ikony mapy używany dla znaczników strefy monitora kostnego.",
                    label = "Sprite etykiety strefy",
                },
                ankleMonitorZoneOutlineRadius = {
                    description = "Promień używany dla obrysów strefy monitora kostnego.",
                    label = "Promień obrysu",
                },
                ankleMonitorZoneOutlineStep = {
                    description = "Rozmiar kroku używany dla obrysów strefy monitora kostnego.",
                    label = "Krok obrysu",
                },
                billingAccount = {
                    description = "Zapasowe konto używane, gdy zadanie nie ma skonfigurowanego konta społeczności.",
                    label = "Zapasowe konto społeczności",
                },
                billingCloseOnSuccess = {
                    description = "Zamknij interfejs rozliczeń po wystawieniu rachunku.",
                    label = "Zamknij po sukcesie",
                },
                billingCurrency = {
                    description = "Klucz waluty używany do rozliczeń. Pozostaw puste, aby użyć domyślnej waluty.",
                    label = "Waluta",
                },
                billingCustomReasons = {
                    description = "Zezwól na niestandardowe powody rozliczeń zamiast tylko gotowych szablonów.",
                    label = "Niestandardowe powody",
                },
                billingDepositToSociety = {
                    description = "Wpłacaj przychody z rozliczeń na konto społeczności zadania.",
                    label = "Wpłać do społeczności",
                },
                billingMaxReasonLength = {
                    description = "Maksymalna liczba znaków dla niestandardowych powodów rozliczeń.",
                    label = "Długość powodu",
                },
                billingMode = {
                    description = "Wybierz, czy rachunki policyjne obciążają natychmiast, wymagają potwierdzenia obywatela, czy korzystają z systemu rozliczeń frameworka.",
                    label = "Tryb rozliczenia",
                    options = {
                        consent = "Zapłać lub odrzuć",
                        framework = "Rachunek frameworka",
                        instant = "Natychmiastowe obciążenie",
                    },
                },
                billingRange = {
                    description = "Maksymalna odległość do celu przy wystawianiu rachunków policyjnych.",
                    label = "Zasięg rozliczenia",
                },
                billingReasonPresets = {
                    description = "Gotowe powody rozliczeń wyświetlane w interfejsie rozliczeń.",
                    itemLabel = "Powód",
                    label = "Gotowe powody",
                },
                billingRefreshSeconds = {
                    description = "Interwał odświeżania celu podczas otwartego interfejsu rozliczeń.",
                    label = "Sekundy odświeżania",
                },
                billingShowRecipientName = {
                    description = "Pokaż nazwę obywatela na podglądach mandatów i potwierdzeniach.",
                    label = "Pokaż nazwę odbiorcy",
                },
                carryAllowCarrierInVehicle = {
                    description = "Pozwala niosącemu wejść do pojazdu i prowadzić bez odkładania gracza.",
                    label = "Zezwól niosącemu na pojazd",
                },
                carryAllowConscious = {
                    description = "Zezwól na przenoszenie przytomnych celów.",
                    label = "Przenoszenie przytomnych celów",
                },
                carryAllowSprint = {
                    description = "Zezwól na bieganie podczas przenoszenia innego gracza.",
                    label = "Zezwól na bieg podczas przenoszenia",
                },
                carryEnabled = {
                    description = "Włącz przenoszenie graczy.",
                    label = "Przenoszenie",
                },
                carryMaxDistance = {
                    description = "Maksymalna odległość do rozpoczęcia przenoszenia gracza.",
                    label = "Odległość przenoszenia",
                },
                carryRequireOnDuty = {
                    description = "Wymagaj stanu służby przed rozpoczęciem przenoszenia.",
                    label = "Przenoszenie wymaga służby",
                },
                cctvDamageCooldownMs = {
                    description = "Liczba milisekund przed ponownym zadaniem obrażeń CCTV.",
                    label = "Odnowienie obrażeń",
                },
                cctvDamagePerHit = {
                    description = "Obrażenia trwałości zadawane kamerom CCTV przy każdym trafieniu.",
                    label = "Obrażenia na trafienie",
                },
                cctvDefaultName = {
                    description = "Domyślna nazwa wyświetlana dla rozmieszczonych kamer CCTV.",
                    label = "Domyślna nazwa CCTV",
                },
                cctvDefaultPitch = {
                    description = "Domyślne pochylenie kamery przy rozmieszczaniu CCTV.",
                    label = "Domyślne pochylenie",
                },
                cctvDisassembleDistance = {
                    description = "Odległość używana do demontażu kamer CCTV.",
                    label = "Odległość demontażu",
                },
                cctvEnabled = {
                    description = "Włącz rozmieszczanie i streamowanie kamer CCTV.",
                    label = "Kamery CCTV",
                },
                cctvHealthDisplayDistance = {
                    description = "Odległość, przy której wyświetlana jest trwałość CCTV.",
                    label = "Odległość wyświetlania trwałości",
                },
                cctvHealthDisplayDurationMs = {
                    description = "Liczba milisekund, przez jaką trwałość CCTV pozostaje widoczna.",
                    label = "Czas wyświetlania trwałości",
                },
                cctvHealthTextOffset = {
                    description = "Pionowe przesunięcie używane dla tekstu trwałości CCTV.",
                    label = "Przesunięcie tekstu trwałości",
                },
                cctvHeightStep = {
                    description = "Krok wysokości używany podczas pozycjonowania kamer CCTV.",
                    label = "Krok wysokości",
                },
                cctvItem = {
                    description = "Przedmiot z ekwipunku używany do rozmieszczania kamer CCTV.",
                    label = "Przedmiot CCTV",
                },
                cctvMaintenanceThreshold = {
                    description = "Próg trwałości, przy którym zalecana jest konserwacja CCTV.",
                    label = "Próg konserwacji",
                },
                cctvMaxDurability = {
                    description = "Maksymalna trwałość kamery CCTV.",
                    label = "Trwałość CCTV",
                },
                cctvMotionAlertCooldownSeconds = {
                    description = "Liczba sekund, zanim kamera może utworzyć kolejny dispatch ruchu.",
                    label = "Czas odnowienia dispatchu",
                },
                cctvMotionCheckIntervalMs = {
                    description = "Liczba milisekund między skanami ruchu po stronie klienta.",
                    label = "Interwał skanowania",
                },
                cctvMotionClientCooldownMs = {
                    description = "Liczba milisekund, zanim klient może ponownie zgłosić tę samą kamerę.",
                    label = "Czas odnowienia zgłoszenia klienta",
                },
                cctvMotionDefaultCameraEnabled = {
                    description = "Automatycznie włącz alerty ruchu dla nowo umieszczonych kamer CCTV.",
                    label = "Nowe kamery domyślnie aktywne",
                },
                cctvMotionDetectionEnabled = {
                    description = "Włącz alerty dyspozytorskie wykrycia ruchu dla każdej kamery CCTV.",
                    label = "Alerty ruchu",
                },
                cctvMotionDetectionRadius = {
                    description = "Maksymalna odległość wykrywania ruchu w metrach.",
                    label = "Promień wykrywania",
                },
                cctvMotionFieldOfView = {
                    description = "Kąt stożka wykrywania ruchu w stopniach.",
                    label = "Pole widzenia",
                },
                cctvMotionJobs = {
                    description = "Nazwy jobów lub grup odbierających dispatch ruchu CCTV.",
                    itemLabel = "Job lub grupa",
                    label = "Joby dispatchu",
                },
                cctvMotionMinimumSpeed = {
                    description = "Minimalna prędkość obiektu w metrach na sekundę uznawana za ruch.",
                    label = "Minimalna prędkość ruchu",
                },
                cctvMoveStep = {
                    description = "Krok przesunięcia używany podczas pozycjonowania kamer CCTV.",
                    label = "Krok przesunięcia",
                },
                cctvPropModel = {
                    description = "Model rekwizytu używany dla rozmieszczonych kamer CCTV.",
                    label = "Model rekwizytu CCTV",
                },
                cctvRepairAnimDict = {
                    description = "Słownik animacji używany podczas naprawy kamer CCTV.",
                    label = "Słownik animacji naprawy",
                },
                cctvRepairAnimFlag = {
                    description = "Flaga animacji używana podczas naprawy kamer CCTV.",
                    label = "Flaga animacji naprawy",
                },
                cctvRepairAnimName = {
                    description = "Nazwa animacji używana podczas naprawy kamer CCTV.",
                    label = "Nazwa animacji naprawy",
                },
                cctvRepairCancelDelayMs = {
                    description = "Liczba milisekund przed możliwością anulowania naprawy CCTV.",
                    label = "Opóźnienie anulowania naprawy",
                },
                cctvRepairDistance = {
                    description = "Odległość używana do naprawy kamer CCTV.",
                    label = "Odległość naprawy",
                },
                cctvRepairItem = {
                    description = "Przedmiot z ekwipunku używany do naprawy kamer CCTV.",
                    label = "Przedmiot naprawy",
                },
                cctvRepairPerTick = {
                    description = "Trwałość przywracana przy każdym takcie naprawy CCTV.",
                    label = "Naprawa na takt",
                },
                cctvRepairTickMs = {
                    description = "Liczba milisekund między taktami naprawy CCTV.",
                    label = "Takt naprawy",
                },
                cctvRotateStep = {
                    description = "Krok obrotu używany podczas pozycjonowania kamer CCTV.",
                    label = "Krok obrotu",
                },
                cctvStreamDistance = {
                    description = "Odległość używana do streamowania kamer CCTV.",
                    label = "Odległość streamingu",
                },
                cctvViewOffset = {
                    description = "Przesunięcie widoku używane do renderowania obrazu na żywo z CCTV.",
                    label = "Przesunięcie widoku",
                },
                crimeSceneTapeCollisionEnabled = {
                    description = "Tworzy wzdłuż taśmy barierę kolizyjną, przez którą gracze nie mogą przejść.",
                    label = "Blokująca kolizja taśmy",
                },
                crimeSceneTapeConsumeItem = {
                    description = "Po udanym rozstawieniu usuń jeden przedmiot taśmy z ekwipunku.",
                    label = "Zużyj przedmiot taśmy",
                },
                crimeSceneTapeDynamic = {
                    description = "Pozwól taśmie reagować na fizykę i grawitację zamiast unieruchamiać ją w miejscu.",
                    label = "Dynamiczna fizyka",
                },
                crimeSceneTapeEnabled = {
                    description = "Zezwól na rozstawianie taśmy miejsca zbrodni za pomocą przedmiotu z ekwipunku.",
                    label = "Taśma miejsca zbrodni",
                },
                crimeSceneTapeEnforceRemovalAccess = {
                    description = "Taśmę mogą usuwać tylko dozwolone zawody, a jeśli jest to wymagane, ich członkowie muszą być na służbie.",
                    label = "Ogranicz usuwanie",
                },
                crimeSceneTapeItem = {
                    description = "Nazwa przedmiotu w ekwipunku, który rozpoczyna rozstawianie taśmy miejsca zbrodni.",
                    label = "Przedmiot taśmy",
                },
                crimeSceneTapeJobs = {
                    description = "Nazwy zawodów uprawnionych do używania taśmy miejsca zbrodni.",
                    itemLabel = "Zawód",
                    label = "Dozwolone zawody",
                },
                crimeSceneTapeLabel = {
                    description = "Nazwa taśmy miejsca zbrodni wyświetlana podczas jej rozstawiania.",
                    label = "Etykieta taśmy",
                },
                crimeSceneTapeLengthStep = {
                    description = "Przyrost w metrach, do którego zaokrąglana jest wybrana długość taśmy.",
                    label = "Krok długości",
                },
                crimeSceneTapeMaxLength = {
                    description = "Największa dozwolona odległość między dwoma słupkami taśmy, w metrach.",
                    label = "Maksymalna długość taśmy",
                },
                crimeSceneTapeMaxPlacementDistance = {
                    description = "Maksymalna odległość dowolnego punktu końcowego od funkcjonariusza rozstawiającego taśmę.",
                    label = "Maksymalna odległość rozstawiania",
                },
                crimeSceneTapeMinLength = {
                    description = "Najmniejsza dozwolona odległość między dwoma słupkami taśmy, w metrach.",
                    label = "Minimalna długość taśmy",
                },
                crimeSceneTapeModel = {
                    description = "Nazwa modelu rekwizytu używanego dla rozstawionej taśmy miejsca zbrodni.",
                    label = "Model taśmy",
                },
                crimeSceneTapePostModel = {
                    description = "Model rekwizytu używany dla obu słupków taśmy.",
                    label = "Model słupka",
                },
                crimeSceneTapeRemoveDistance = {
                    description = "Maksymalna odległość, z której można usunąć rozstawioną taśmę miejsca zbrodni.",
                    label = "Odległość usuwania",
                },
                crimeSceneTapeRequireOnDuty = {
                    description = "Taśmę mogą rozstawiać tylko będący na służbie członkowie dozwolonych zawodów.",
                    label = "Wymagaj służby",
                },
                crimeSceneTapeReturnItemOnRemove = {
                    description = "Zwróć zużyty przedmiot po usunięciu rozstawionej taśmy.",
                    label = "Zwróć przedmiot po usunięciu",
                },
                crimeSceneTapeSag = {
                    description = "Maksymalny zwis taśmy w dół między słupkami, w metrach.",
                    label = "Zwis taśmy",
                },
                crimeSceneTapeSections = {
                    description = "Natywne modele segmentów taśmy używane do złożenia wybranej długości.",
                    itemLabel = "Segment taśmy",
                    label = "Segmenty taśmy",
                },
                crimeSceneTapeShowPosts = {
                    description = "Tworzy widoczne słupki podtrzymujące na obu końcach taśmy miejsca zbrodni o zmiennej długości.",
                    label = "Pokaż słupki taśmy",
                },
                crimeSceneTapeStreamDistance = {
                    description = "Odległość, w której rozstawiona taśma miejsca zbrodni jest wczytywana.",
                    label = "Odległość wczytywania",
                },
                crimeSceneTapeTapeHeight = {
                    description = "Wysokość taśmy nad wybranymi punktami podłoża.",
                    label = "Wysokość taśmy",
                },
                crimeSceneTapeVariableLength = {
                    description = "Pozwala funkcjonariuszom wyznaczyć punkt początkowy i końcowy oraz rozstawić taśmę o regulowanej długości.",
                    label = "Zmienna długość taśmy",
                },
                crimeSceneTapeZOffset = {
                    description = "Pionowe przesunięcie stosowane podczas umieszczania modelu taśmy.",
                    label = "Przesunięcie wysokości",
                },
                cuffsAnimDict = {
                    description = "Słownik animacji używany dla unieruchomionych graczy.",
                    label = "Słownik animacji",
                },
                cuffsAnimFlag = {
                    description = "Flaga animacji używana dla unieruchomionych graczy.",
                    label = "Flaga animacji",
                },
                cuffsAnimName = {
                    description = "Nazwa animacji używana dla unieruchomionych graczy.",
                    label = "Nazwa animacji",
                },
                cuffsConsumeItem = {
                    description = "Usuń przedmiot kajdanek po założeniu.",
                    label = "Zużyj kajdanki",
                },
                cuffsEnabled = {
                    description = "Włącz akcje kajdanek.",
                    label = "Kajdanki",
                },
                cuffsEscapeEnabled = {
                    description = "Włącz minigrę wyrywania się z kajdanek.",
                    label = "Wyrwanie się z kajdanek",
                },
                cuffsEscapeKeyPool = {
                    description = "Klawisze, które mogą pojawić się w minigrze wyrywania się z kajdanek.",
                    itemLabel = "Klawisz",
                    label = "Pula klawiszy wyrwania się",
                },
                cuffsEscapeRounds = {
                    description = "Liczba rund wymaganych w minigrze wyrywania się z kajdanek.",
                    label = "Rundy wyrwania się",
                },
                cuffsEscapeWindowMs = {
                    description = "Liczba milisekund dozwolona na każde okno wprowadzania w minigrze wyrywania się.",
                    label = "Okno wyrwania się",
                },
                cuffsHandsUpEnabled = {
                    description = "Włącz stan rąk do góry używany przez kajdanki i taśmy ZIP.",
                    label = "Ręce do góry",
                },
                cuffsHandsUpHoldSeconds = {
                    description = "Liczba sekund przytrzymania klawisza rąk do góry przed aktywacją.",
                    label = "Sekundy przytrzymania rąk do góry",
                },
                cuffsHandsUpKey = {
                    description = "Klawisz klawiatury używany do podniesienia rąk.",
                    label = "Klawisz rąk do góry",
                },
                cuffsItem = {
                    description = "Przedmiot z ekwipunku używany do akcji kajdanek.",
                    label = "Przedmiot kajdanek",
                },
                cuffsMaxDistance = {
                    description = "Maksymalna odległość do celu dla akcji kajdanek.",
                    label = "Odległość zakładania kajdanek",
                },
                cuffsRequireItem = {
                    description = "Wymagaj skonfigurowanego przedmiotu kajdanek.",
                    label = "Kajdanki wymagają przedmiotu",
                },
                cuffsRequireOnDuty = {
                    description = "Wymagaj stanu służby przed założeniem kajdanek.",
                    label = "Kajdanki wymagają służby",
                },
                cuffsReturnOnRemove = {
                    description = "Zwróć przedmiot kajdanek po zdjęciu.",
                    label = "Zwróć kajdanki",
                },
                dispatchOfficerDownEnabled = {
                    description = "Wyślij zgłoszenie, gdy funkcjonariusz na służbie zostanie ranny.",
                    label = "Powiadomienia o rannym funkcjonariuszu",
                },
                dispatchOfficerDownJobs = {
                    description = "Zadania, które powinny otrzymywać zgłoszenia o rannym funkcjonariuszu.",
                    itemLabel = "Zadanie",
                    label = "Zadania powiadomień o rannym funkcjonariuszu",
                },
                dispatchOfficerDownRequireDuty = {
                    description = "Powiadamiaj tylko graczy aktualnie na służbie.",
                    label = "Ranny funkcjonariusz wymaga służby",
                },
                dispatchShotsFiredChance = {
                    description = "Szansa od 0.0 do 1.0, że wykryty strzał utworzy zgłoszenie.",
                    label = "Szansa na zgłoszenie",
                },
                dispatchShotsFiredCooldownSeconds = {
                    description = "Liczba sekund przed możliwością wywołania przez tego samego gracza kolejnego alarmu o strzałach.",
                    label = "Odnowienie zgłoszenia o strzałach",
                },
                dispatchShotsFiredEnabled = {
                    description = "Włącz zgłoszenia o oddanych strzałach.",
                    label = "Powiadomienia o strzałach",
                },
                dispatchShotsFiredIgnoredWeapons = {
                    description = "Broń, która nie powinna wywoływać alarmów o strzałach.",
                    itemLabel = "Broń",
                    label = "Ignorowana broń",
                },
                dispatchShotsFiredJobs = {
                    description = "Zadania, które powinny otrzymywać zgłoszenia o strzałach.",
                    itemLabel = "Zadanie",
                    label = "Zadania powiadomień o strzałach",
                },
                dispatchShotsFiredRequireDuty = {
                    description = "Powiadamiaj tylko graczy aktualnie na służbie.",
                    label = "Strzały wymagają służby",
                },
                dispatchShotsFiredSendDispatch = {
                    description = "Twórz wpisy zgłoszeń po wykryciu strzałów.",
                    label = "Wyślij zgłoszenie o strzałach",
                },
                dispatchShotsFiredSuppressedChance = {
                    description = "Szansa od 0.0 do 1.0, że wykryty strzał z tłumikiem utworzy zgłoszenie.",
                    label = "Szansa na zgłoszenie strzału z tłumikiem",
                },
                escortEnabled = {
                    description = "Włącz eskortowanie graczy.",
                    label = "Eskorta",
                },
                escortMaxDistance = {
                    description = "Maksymalna odległość do rozpoczęcia eskortowania gracza.",
                    label = "Odległość eskorty",
                },
                escortRequireOnDuty = {
                    description = "Wymagaj stanu służby przed eskortowaniem graczy.",
                    label = "Eskorta wymaga służby",
                },
                escortVehicleDistance = {
                    description = "Maksymalna odległość do umieszczenia eskortowanego gracza w pojeździe.",
                    label = "Odległość eskorty do pojazdu",
                },
                evidenceBloodDamageThreshold = {
                    description = "Minimalny próg obrażeń przed utworzeniem dowodu krwi.",
                    label = "Próg obrażeń dla krwi",
                },
                evidenceCasingCreateCooldownMs = {
                    description = "Liczba milisekund przed możliwością utworzenia kolejnej łuski.",
                    label = "Odnowienie łuski",
                },
                evidenceCasingMergeRadius = {
                    description = "Promień używany do łączenia pobliskich łusek.",
                    label = "Promień łączenia łusek",
                },
                evidenceCleanupIntervalMs = {
                    description = "Liczba milisekund między cyklami czyszczenia dowodów.",
                    label = "Interwał czyszczenia",
                },
                evidenceCleanupTtlSeconds = {
                    description = "Liczba sekund przed automatycznym wygaśnięciem dowodów terenowych.",
                    label = "Czas życia przed czyszczeniem",
                },
                evidenceCleanerAllowEveryone = {
                    label = "Środek czyszczący dla wszystkich",
                    description = "Pozwól wszystkim usuwać ślady nadtlenkiem wodoru. Wyłącz, aby używać list zawodów i gangów.",
                },
                evidenceCleanerJobs = {
                    label = "Zawody dla środka czyszczącego",
                    description = "Dozwolone nazwy wewnętrzne bez dostępu publicznego. Zgodny zawód lub gang zezwala na dostęp; puste listy go blokują.",
                    itemLabel = "Zawód",
                },
                evidenceCleanerGangs = {
                    label = "Gangi dla środka czyszczącego",
                    description = "Dozwolone nazwy wewnętrzne bez dostępu publicznego. Zgodny zawód lub gang zezwala na dostęp; puste listy go blokują.",
                    itemLabel = "GANG",
                },
                evidenceCollectDistance = {
                    description = "Odległość używana do zbierania dowodów terenowych.",
                    label = "Odległość zbierania",
                },
                evidenceDiscoverDistance = {
                    description = "Odległość używana do wykrywania pobliskich znaczników dowodów.",
                    label = "Odległość wykrywania",
                },
                evidenceFieldEnabled = {
                    description = "Włącz tworzenie i zbieranie dowodów w terenie.",
                    label = "Dowody terenowe",
                },
                evidenceFieldFlashlightWeapon = {
                    description = "Broń używana do sprawdzania i ujawniania dowodów w terenie.",
                    label = "Broń latarki",
                },
                evidenceGloveFreeHands = {
                    description = "ID komponentów dłoni traktowane jako brak rękawiczek.",
                    label = "Komponenty gołych rąk",
                },
                evidenceMarkerColor = {
                    description = "Kolor RGBA używany dla znaczników dowodów terenowych.",
                    label = "Kolor znacznika",
                },
                evidenceMarkerDrawDistance = {
                    description = "Odległość renderowania używana dla znaczników dowodów terenowych.",
                    label = "Odległość renderowania",
                },
                evidenceMarkerOffset = {
                    description = "Pionowe przesunięcie znacznika używane dla dowodów terenowych.",
                    label = "Przesunięcie",
                },
                evidenceMarkerScaleX = {
                    description = "Skala X znacznika używana dla dowodów terenowych.",
                    label = "Skala X",
                },
                evidenceMarkerScaleY = {
                    description = "Skala Y znacznika używana dla dowodów terenowych.",
                    label = "Skala Y",
                },
                evidenceMarkerScaleZ = {
                    description = "Skala Z znacznika używana dla dowodów terenowych.",
                    label = "Skala Z",
                },
                evidenceMarkerType = {
                    description = "Typ znacznika używany dla dowodów terenowych.",
                    label = "Typ znacznika",
                },
                evidenceMaxCreateDistance = {
                    description = "Maksymalna odległość do tworzenia rekordów dowodowych.",
                    label = "Odległość tworzenia",
                },
                evidenceSalivaConsentTimeoutMs = {
                    description = "Liczba milisekund dozwolona na zgodę na pobranie próbki śliny.",
                    label = "Limit czasu zgody na próbkę śliny",
                },
                evidenceScannerDistance = {
                    description = "Odległość używana dla interakcji ze skanerem dowodów.",
                    label = "Odległość skanera",
                },
                evidenceScannerDurationMs = {
                    description = "Czas trwania akcji odcisku palca/skanera w milisekundach.",
                    label = "Czas skanera",
                },
                evidenceStorageMaxCompartments = {
                    description = "Maksymalna liczba przegródek magazynu dowodów.",
                    label = "Przegródki magazynu",
                },
                gpsTrackerBeepDistance = {
                    description = "Odległość, przy której informacja zwrotna sygnału dźwiękowego lokalizatora GPS staje się istotna.",
                    label = "Odległość sygnału dźwiękowego",
                },
                gpsTrackerBeepIntervalFarMs = {
                    description = "Liczba milisekund między sygnałami dźwiękowymi przy dużej odległości od lokalizatora.",
                    label = "Interwał sygnału z daleka",
                },
                gpsTrackerBeepIntervalNearMs = {
                    description = "Liczba milisekund między sygnałami dźwiękowymi przy bliskiej odległości od lokalizatora.",
                    label = "Interwał sygnału z bliska",
                },
                gpsTrackerConsumeOnPlace = {
                    description = "Usuń przedmiot lokalizatora po założeniu.",
                    label = "Zużyj lokalizator GPS",
                },
                gpsTrackerEnabled = {
                    description = "Włącz zakładanie i skanowanie lokalizatorów GPS pojazdów.",
                    label = "Lokalizator GPS",
                },
                gpsTrackerItem = {
                    description = "Przedmiot z ekwipunku używany do zakładania lokalizatorów GPS.",
                    label = "Przedmiot lokalizatora",
                },
                gpsTrackerMapUpdateIntervalMs = {
                    description = "Liczba milisekund między aktualizacjami lokalizatora na mapie.",
                    label = "Interwał aktualizacji mapy",
                },
                gpsTrackerPlaceDistance = {
                    description = "Maksymalna odległość do założenia lokalizatora GPS na pojeździe.",
                    label = "Odległość zakładania",
                },
                gpsTrackerRemoveDistance = {
                    description = "Maksymalna odległość do usunięcia założonego lokalizatora GPS.",
                    label = "Odległość usuwania",
                },
                gpsTrackerRemoveKey = {
                    description = "Kod sterowania używany do usunięcia założonego lokalizatora GPS.",
                    label = "Klawisz usuwania",
                },
                gpsTrackerRequireOnDuty = {
                    description = "Wymagaj stanu służby przed użyciem lokalizatorów GPS.",
                    label = "GPS wymaga służby",
                },
                gpsTrackerRequirePoliceJob = {
                    description = "Wymagaj, aby gracz należał do grupy policyjnej przed użyciem lokalizatorów GPS.",
                    label = "GPS wymaga pracy w policji",
                },
                gpsTrackerReturnOnRemove = {
                    description = "Zwróć przedmiot lokalizatora po jego usunięciu.",
                    label = "Zwróć lokalizator przy usunięciu",
                },
                gpsTrackerScanDistance = {
                    description = "Maksymalna odległość do skanowania w poszukiwaniu lokalizatorów.",
                    label = "Odległość skanowania GPS",
                },
                gpsTrackerScanDurationMs = {
                    description = "Liczba milisekund poświęcona na skanowanie lokalizatora GPS.",
                    label = "Czas skanowania",
                },
                gpsTrackerScannerWeapon = {
                    description = "Broń lub narzędzie używane do skanowania lokalizatorów GPS.",
                    label = "Broń skanera",
                },
                impoundAccount = {
                    description = "Konto używane do pobierania opłat za wydanie zajętych pojazdów.",
                    label = "Konto płatnicze",
                },
                impoundCreatorVehicleModel = {
                    description = "Model pojazdu wyświetlany w podglądzie kreatora parkingu strzeżonego.",
                    label = "Model pojazdu kreatora",
                },
                impoundCustomGarageEnabled = {
                    description = "Użyj niestandardowego interfejsu zajęcia garażu, jeśli jest dostępny.",
                    label = "Niestandardowe zajęcie z garażu",
                },
                impoundDefaultPrice = {
                    description = "Domyślna cena wydania z parkingu strzeżonego.",
                    label = "Cena domyślna",
                },
                impoundDeliveryDistance = {
                    description = "Odległość używana dla interakcji dostawy na parking strzeżony.",
                    label = "Odległość dostawy",
                },
                impoundDeliveryMarker = {
                    description = "Konfiguracja znacznika używana dla dostaw na parking strzeżony.",
                    label = "Znacznik dostawy",
                },
                impoundEnabled = {
                    description = "Włącz procesy zajęcia pojazdu.",
                    label = "Parking strzeżony",
                },
                impoundMarker = {
                    description = "Konfiguracja znacznika używana dla interakcji z parkingiem strzeżonym.",
                    label = "Znacznik parkingu",
                },
                impoundRadialEnabled = {
                    description = "Włącz radialne akcje zajęcia pojazdu.",
                    label = "Akcja zajęcia pojazdu",
                },
                impoundRadialRequireOnDuty = {
                    description = "Wymagaj stanu służby przed użyciem radialnej akcji zajęcia pojazdu.",
                    label = "Zajęcie wymaga służby",
                },
                impoundRadialVehicleDistance = {
                    description = "Maksymalna odległość do docelowego pojazdu dla radialnych akcji zajęcia.",
                    label = "Odległość zajęcia pojazdu",
                },
                impoundReleaseDistance = {
                    description = "Odległość używana dla interakcji wydania z parkingu strzeżonego.",
                    label = "Odległość wydania",
                },
                impoundReleaseKey = {
                    description = "Kod sterowania używany do wydawania zajętych pojazdów.",
                    label = "Klawisz wydania",
                },
                impoundRequireDelivery = {
                    description = "Wymagaj dostarczenia pojazdu na skonfigurowany parking strzeżony.",
                    label = "Wymagaj dostawy",
                },
                impoundStorageBasePrice = {
                    description = "Bazowa cena wydania dla pojazdów przechowywanych w magazynie.",
                    label = "Cena bazowa magazynu",
                },
                impoundStorageDailyFee = {
                    description = "Dodatkowa opłata magazynowa za każdy skonfigurowany dzień.",
                    label = "Dzienna opłata magazynowa",
                },
                impoundStorageDaySeconds = {
                    description = "Ile sekund liczy się jako jeden dzień rozliczeniowy magazynu.",
                    label = "Sekundy dnia magazynowego",
                },
                impoundStorageEnabled = {
                    description = "Włącz płatną obsługę magazynu parkingu strzeżonego.",
                    label = "Magazyn parkingu strzeżonego",
                },
                jailAssignRange = {
                    description = "Maksymalna odległość do przydzielenia celu do więzienia.",
                    label = "Zasięg przydziału",
                },
                jailCanteenCooldownMinutes = {
                    description = "Liczba minut, jaką więzień musi odczekać przed odebraniem kolejnej paczki z kantyny.",
                    label = "Minuty odnowienia",
                },
                jailCanteenPackage = {
                    description = "Przedmioty przyznawane przez paczkę z więziennej kantyny.",
                    label = "Paczka z kantyny",
                },
                jailCellStreamDistance = {
                    description = "Odległość używana do streamingu rekwizytów celi izolacyjnej.",
                    label = "Odległość streamingu celi",
                },
                jailClearInventory = {
                    description = "Wyczyść ekwipunek gracza podczas wysyłania go do więzienia.",
                    label = "Wyczyść ekwipunek",
                },
                jailDefaultMonths = {
                    description = "Domyślny czas trwania wyroku więzienia przy otwieraniu interfejsu przydziału.",
                    label = "Domyślna liczba miesięcy",
                },
                jailDispatchJobs = {
                    description = "Zadania, które powinny otrzymywać zgłoszenia więzienne.",
                    itemLabel = "Zadanie",
                    label = "Zadania zgłoszenia",
                },
                jailDoctorHealEvent = {
                    description = "Zdarzenie serwera lub klienta wyzwalane, gdy lekarz więzienny leczy więźnia.",
                    label = "Zdarzenie leczenia",
                },
                jailElectricalCodeListItem = {
                    description = "Przedmiot z ekwipunku wymagany do ujawnienia wygenerowanych kodów elektrycznych.",
                    label = "Przedmiot listy kodów",
                },
                jailElectricalCodeMax = {
                    description = "Najwyższa losowa wartość kodu dla skrzynki elektrycznej.",
                    label = "Maksymalny kod",
                },
                jailElectricalCodeMin = {
                    description = "Najniższa losowa wartość kodu dla skrzynki elektrycznej.",
                    label = "Minimalny kod",
                },
                jailElectricalCodesCount = {
                    description = "Ile kandydujących kodów jest generowanych dla skrzynki elektrycznej.",
                    label = "Liczba kodów",
                },
                jailElectricalEnabled = {
                    description = "Włącz minigrę ucieczki ze skrzynki elektrycznej.",
                    label = "Skrzynka elektryczna",
                },
                jailElectricalPinLength = {
                    description = "Liczba cyfr używana dla kodów PIN skrzynki elektrycznej.",
                    label = "Długość kodu PIN",
                },
                jailElectricalPropModel = {
                    description = "Model rekwizytu świata używany dla więziennej skrzynki elektrycznej.",
                    label = "Model rekwizytu",
                },
                jailElectricalShockDamage = {
                    description = "Obrażenia zadawane, gdy więzień nie zdoła wykonać sekwencji elektrycznej.",
                    label = "Obrażenia porażenia",
                },
                jailElectricalShockRagdollMs = {
                    description = "Liczba milisekund ragdolla po porażeniu prądem.",
                    label = "Ragdoll po porażeniu",
                },
                jailElectricalSuccessReduceMinutes = {
                    description = "Liczba minut wyroku odjęta po udanej próbie ucieczki elektrycznej.",
                    label = "Minuty skrócenia za sukces",
                },
                jailInmateAlcoholicRequiredAmount = {
                    description = "Ilość wymagana do wymiany z więźniem alkoholikiem.",
                    label = "Wymagana ilość",
                },
                jailInmateAlcoholicRequiredItem = {
                    description = "Przedmiot wymagany do wymiany z więźniem alkoholikiem.",
                    label = "Wymagany przedmiot",
                },
                jailInmateAlcoholicRewardAmount = {
                    description = "Ilość nagrody za wymianę z więźniem alkoholikiem.",
                    label = "Ilość nagrody",
                },
                jailInmateAlcoholicRewardItem = {
                    description = "Przedmiot nagrody za wymianę z więźniem alkoholikiem.",
                    label = "Przedmiot nagrody",
                },
                jailInmateAlcoholicRewardLabel = {
                    description = "Etykieta nagrody wyświetlana dla wymiany z więźniem alkoholikiem.",
                    label = "Etykieta nagrody",
                },
                jailInmateCodeListRequiredAmount = {
                    description = "Ilość wymagana do wymiany z więźniem informatorem.",
                    label = "Wymagana ilość",
                },
                jailInmateCodeListRequiredItem = {
                    description = "Przedmiot wymagany do wymiany z więźniem informatorem.",
                    label = "Wymagany przedmiot",
                },
                jailInmateCodeListRewardAmount = {
                    description = "Ilość nagrody za wymianę z więźniem informatorem.",
                    label = "Ilość nagrody",
                },
                jailInmateCodeListRewardItem = {
                    description = "Przedmiot nagrody za wymianę z więźniem informatorem.",
                    label = "Przedmiot nagrody",
                },
                jailInmateCodeListRewardLabel = {
                    description = "Etykieta nagrody wyświetlana dla wymiany z więźniem informatorem.",
                    label = "Etykieta nagrody",
                },
                jailInmateDrugDealerAcceptedItems = {
                    description = "Przedmioty akceptowane w wymianie z więźniem dilerem narkotyków.",
                    label = "Akceptowane przedmioty",
                },
                jailInmateDrugDealerRequiredAmount = {
                    description = "Ilość wymagana do wymiany z więźniem dilerem narkotyków.",
                    label = "Wymagana ilość",
                },
                jailInmateDrugDealerRewardAmount = {
                    description = "Ilość nagrody za wymianę z więźniem dilerem narkotyków.",
                    label = "Ilość nagrody",
                },
                jailInmateDrugDealerRewardItem = {
                    description = "Przedmiot nagrody za wymianę z więźniem dilerem narkotyków.",
                    label = "Przedmiot nagrody",
                },
                jailInmateDrugDealerRewardLabel = {
                    description = "Etykieta nagrody wyświetlana dla wymiany z więźniem dilerem narkotyków.",
                    label = "Etykieta nagrody",
                },
                jailInmateDrugDealerUseCleaningContraband = {
                    description = "Zezwól, aby kontrabanda znaleziona podczas sprzątania więziennego liczyła się do wymiany z więźniem dilerem narkotyków.",
                    label = "Użyj kontrabandy ze sprzątania",
                },
                jailInmateWireCutterRequiredAmount = {
                    description = "Ilość wymagana do wymiany z więźniem dostawcą narzędzi.",
                    label = "Wymagana ilość",
                },
                jailInmateWireCutterRequiredItem = {
                    description = "Przedmiot wymagany do wymiany z więźniem dostawcą narzędzi.",
                    label = "Wymagany przedmiot",
                },
                jailInmateWireCutterRewardAmount = {
                    description = "Ilość nagrody za wymianę z więźniem dostawcą narzędzi.",
                    label = "Ilość nagrody",
                },
                jailInmateWireCutterRewardItem = {
                    description = "Przedmiot nagrody za wymianę z więźniem dostawcą narzędzi.",
                    label = "Przedmiot nagrody",
                },
                jailInmateWireCutterRewardLabel = {
                    description = "Etykieta nagrody wyświetlana dla wymiany z więźniem dostawcą narzędzi.",
                    label = "Etykieta nagrody",
                },
                jailJobsCarryBoxModel = {
                    description = "Model rekwizytu używany dla pudełka więziennej pracy transportowej.",
                    label = "Model pudełka",
                },
                jailJobsCarryDropoffKey = {
                    description = "Kod sterowania używany do odkładania pudełek pracy transportowej.",
                    label = "Klawisz odkładania",
                },
                jailJobsCarryDropoffRadius = {
                    description = "Promień odkładania dla więziennej pracy transportowej.",
                    label = "Promień odkładania",
                },
                jailJobsCarryInspectKey = {
                    description = "Kod sterowania używany do inspekcji pudełek pracy transportowej.",
                    label = "Klawisz inspekcji",
                },
                jailJobsCarryInspectionJunkItems = {
                    description = "Bezużyteczne przedmioty, które można znaleźć podczas inspekcji pudełek pracy transportowej.",
                    label = "Bezużyteczne przedmioty inspekcji",
                },
                jailJobsCarryInspectionUsableChance = {
                    description = "Szansa na użyteczną nagrodę przy inspekcji pudełek.",
                    label = "Szansa na użyteczny łup",
                },
                jailJobsCarryInspectionUsableItems = {
                    description = "Użyteczne przedmioty, które można znaleźć podczas inspekcji pudełek pracy transportowej.",
                    label = "Użyteczne przedmioty inspekcji",
                },
                jailJobsCarryInteractDistance = {
                    description = "Odległość interakcji dla więziennej pracy transportowej.",
                    label = "Odległość interakcji przenoszenia",
                },
                jailJobsCarryMaxDistance = {
                    description = "Maksymalna dozwolona odległość dla postępu więziennej pracy transportowej.",
                    label = "Maksymalna odległość przenoszenia",
                },
                jailJobsCarryPickupKey = {
                    description = "Kod sterowania używany do podnoszenia pudełek pracy transportowej.",
                    label = "Klawisz podnoszenia",
                },
                jailJobsCarryPickupOffset = {
                    description = "Obiekt przesunięcia używany dla lokalizacji podnoszenia pracy transportowej.",
                    label = "Przesunięcie podnoszenia",
                },
                jailJobsCarryTimeReduction = {
                    description = "Skrócenie wyroku za ukończenie więziennej pracy transportowej.",
                    label = "Skrócenie wyroku za przenoszenie",
                },
                jailJobsCleaningDumpsterKey = {
                    description = "Kod sterowania używany przy kontenerze więziennym.",
                    label = "Klawisz kontenera",
                },
                jailJobsCleaningDumpsterModel = {
                    description = "Model używany dla rekwizytu kontenera przy sprzątaniu więziennym.",
                    label = "Model kontenera",
                },
                jailJobsCleaningIllegalFindChance = {
                    description = "Szansa na znalezienie kontrabandy podczas sprzątania.",
                    label = "Szansa znalezienia przemytu",
                },
                jailJobsCleaningIllegalFindItems = {
                    description = "Przedmioty, które można znaleźć podczas sprzątania w więzieniu.",
                    label = "Przedmioty znalezisk",
                },
                jailJobsCleaningIllegalFindPromptTimeoutMs = {
                    description = "Limit czasu dla okien znalezisk nielegalnych przedmiotów w milisekundach.",
                    label = "Limit czasu okna znaleziska",
                },
                jailJobsCleaningInteractDistance = {
                    description = "Odległość używana do interakcji ze śmieciami przy sprzątaniu.",
                    label = "Odległość interakcji sprzątania",
                },
                jailJobsCleaningMaxDistance = {
                    description = "Maksymalna odległość przed zresetowaniem lub zniknięciem rekwizytów sprzątania.",
                    label = "Maksymalna odległość sprzątania",
                },
                jailJobsCleaningMaxTrashProps = {
                    description = "Maksymalna liczba jednoczesnych rekwizytów śmieci przy sprzątaniu więziennym.",
                    label = "Maksymalna liczba rekwizytów śmieci",
                },
                jailJobsCleaningMinSpawnRadius = {
                    description = "Minimalna odległość od środka dla pojawiania się śmieci przy sprzątaniu.",
                    label = "Minimalny promień pojawiania się",
                },
                jailJobsCleaningPickupKey = {
                    description = "Kod sterowania używany do podnoszenia śmieci przy sprzątaniu więziennym.",
                    label = "Klawisz podnoszenia śmieci",
                },
                jailJobsCleaningSpawnIntervalMs = {
                    description = "Liczba milisekund między próbami pojawienia się śmieci przy sprzątaniu.",
                    label = "Interwał pojawiania się śmieci",
                },
                jailJobsCleaningSpawnRadius = {
                    description = "Promień używany do pojawiania się rekwizytów śmieci przy sprzątaniu.",
                    label = "Promień pojawiania się śmieci",
                },
                jailJobsCleaningTrashModels = {
                    description = "Modele rekwizytów śmieci używane dla więziennej pracy sprzątającej.",
                    itemLabel = "Wzór",
                    label = "Modele śmieci",
                },
                jailJobsCleaningTrashOutlineColor = {
                    description = "Kolor RGBA obrysu używany dla rekwizytów śmieci przy sprzątaniu więziennym.",
                    label = "Kolor obrysu",
                },
                jailJobsCleaningTrashOutlineEnabled = {
                    description = "Włącz obrysy na rekwizytach śmieci przy sprzątaniu więziennym.",
                    label = "Obrys śmieci",
                },
                jailJobsCleaningTrashOutlineShader = {
                    description = "ID shadera używanego dla obrysów śmieci przy sprzątaniu więziennym.",
                    label = "Shader obrysu",
                },
                jailJobsTimeReduction = {
                    description = "Skrócenie wyroku za ukończenie więziennej pracy sprzątającej.",
                    label = "Skrócenie wyroku za sprzątanie",
                },
                jailJobsTrashGoal = {
                    description = "Liczba śmieci potrzebna do ukończenia więziennej pracy sprzątającej.",
                    label = "Cel śmieci przy sprzątaniu",
                },
                jailMaxMonths = {
                    description = "Maksymalny wybieralny czas trwania wyroku więzienia.",
                    label = "Maksymalna liczba miesięcy",
                },
                jailMinMonths = {
                    description = "Minimalny wybieralny czas trwania wyroku więzienia.",
                    label = "Minimalna liczba miesięcy",
                },
                jailMonthMinutes = {
                    description = "Liczba minut w czasie rzeczywistym reprezentowana przez jeden miesiąc więzienia.",
                    label = "Minuty na miesiąc",
                },
                jailObjectStreamDistance = {
                    description = "Odległość używana do streamingu trwałych obiektów świata więzienia.",
                    label = "Odległość streamingu obiektów",
                },
                jailOutfitApplyDelayMs = {
                    description = "Opóźnienie po dołączeniu, zanim zostanie zastosowany strój więzienny.",
                    label = "Opóźnienie zastosowania stroju",
                },
                jailOutfitEnabled = {
                    description = "Włącz stroje więzienne.",
                    label = "Strój więzienny",
                },
                jailOutfitFemaleArms = {
                    description = "Komponent rąk żeńskiego stroju więziennego.",
                    label = "Ręce",
                },
                jailOutfitFemaleChain1 = {
                    description = "Model łańcuszka żeńskiego stroju więziennego.",
                    label = "Łańcuszek 1",
                },
                jailOutfitFemaleChain2 = {
                    description = "Tekstura łańcuszka żeńskiego stroju więziennego.",
                    label = "Łańcuszek 2",
                },
                jailOutfitFemaleDecals1 = {
                    description = "Model naklejek żeńskiego stroju więziennego.",
                    label = "Naklejki 1",
                },
                jailOutfitFemaleDecals2 = {
                    description = "Tekstura naklejek żeńskiego stroju więziennego.",
                    label = "Naklejki 2",
                },
                jailOutfitFemaleGlasses1 = {
                    description = "Model okularów żeńskiego stroju więziennego (-1 usuwa okulary).",
                    label = "Okulary 1",
                },
                jailOutfitFemaleGlasses2 = {
                    description = "Tekstura okularów żeńskiego stroju więziennego.",
                    label = "Okulary 2",
                },
                jailOutfitFemaleHelmet1 = {
                    description = "Model kasku żeńskiego stroju więziennego.",
                    label = "Kask 1",
                },
                jailOutfitFemaleHelmet2 = {
                    description = "Tekstura kasku żeńskiego stroju więziennego.",
                    label = "Kask 2",
                },
                jailOutfitFemalePants1 = {
                    description = "Model spodni żeńskiego stroju więziennego.",
                    label = "Spodnie 1",
                },
                jailOutfitFemalePants2 = {
                    description = "Tekstura spodni żeńskiego stroju więziennego.",
                    label = "Spodnie 2",
                },
                jailOutfitFemaleShoes1 = {
                    description = "Model butów żeńskiego stroju więziennego.",
                    label = "Buty 1",
                },
                jailOutfitFemaleShoes2 = {
                    description = "Tekstura butów żeńskiego stroju więziennego.",
                    label = "Buty 2",
                },
                jailOutfitFemaleTorso1 = {
                    description = "Model torsu żeńskiego stroju więziennego.",
                    label = "Tors 1",
                },
                jailOutfitFemaleTorso2 = {
                    description = "Tekstura torsu żeńskiego stroju więziennego.",
                    label = "Tors 2",
                },
                jailOutfitFemaleTshirt1 = {
                    description = "Model koszulki żeńskiego stroju więziennego.",
                    label = "Koszulka 1",
                },
                jailOutfitFemaleTshirt2 = {
                    description = "Tekstura koszulki żeńskiego stroju więziennego.",
                    label = "Koszulka 2",
                },
                jailOutfitMaleArms = {
                    description = "Komponent rąk męskiego stroju więziennego.",
                    label = "Ręce",
                },
                jailOutfitMaleChain1 = {
                    description = "Model łańcuszka męskiego stroju więziennego.",
                    label = "Łańcuszek 1",
                },
                jailOutfitMaleChain2 = {
                    description = "Tekstura łańcuszka męskiego stroju więziennego.",
                    label = "Łańcuszek 2",
                },
                jailOutfitMaleDecals1 = {
                    description = "Model naklejek męskiego stroju więziennego.",
                    label = "Naklejki 1",
                },
                jailOutfitMaleDecals2 = {
                    description = "Tekstura naklejek męskiego stroju więziennego.",
                    label = "Naklejki 2",
                },
                jailOutfitMaleGlasses1 = {
                    description = "Model okularów męskiego stroju więziennego (-1 usuwa okulary).",
                    label = "Okulary 1",
                },
                jailOutfitMaleGlasses2 = {
                    description = "Tekstura okularów męskiego stroju więziennego.",
                    label = "Okulary 2",
                },
                jailOutfitMaleHelmet1 = {
                    description = "Model kasku męskiego stroju więziennego.",
                    label = "Kask 1",
                },
                jailOutfitMaleHelmet2 = {
                    description = "Tekstura kasku męskiego stroju więziennego.",
                    label = "Kask 2",
                },
                jailOutfitMalePants1 = {
                    description = "Model spodni męskiego stroju więziennego.",
                    label = "Spodnie 1",
                },
                jailOutfitMalePants2 = {
                    description = "Tekstura spodni męskiego stroju więziennego.",
                    label = "Spodnie 2",
                },
                jailOutfitMaleShoes1 = {
                    description = "Model butów męskiego stroju więziennego.",
                    label = "Buty 1",
                },
                jailOutfitMaleShoes2 = {
                    description = "Tekstura butów męskiego stroju więziennego.",
                    label = "Buty 2",
                },
                jailOutfitMaleTorso1 = {
                    description = "Model torsu męskiego stroju więziennego.",
                    label = "Tors 1",
                },
                jailOutfitMaleTorso2 = {
                    description = "Tekstura torsu męskiego stroju więziennego.",
                    label = "Tors 2",
                },
                jailOutfitMaleTshirt1 = {
                    description = "Model koszulki męskiego stroju więziennego.",
                    label = "Koszulka 1",
                },
                jailOutfitMaleTshirt2 = {
                    description = "Tekstura koszulki męskiego stroju więziennego.",
                    label = "Koszulka 2",
                },
                jailRequireJailTerminal = {
                    description = "Zezwalaj funkcjonariuszom na wykonywanie kary więzienia tylko przy terminalu wybranego więzienia.",
                    label = "Wymagaj terminala więzienia",
                },
                jailRestoreOutfitOnBreakout = {
                    description = "Przywróć zapisany strój cywilny, gdy więzień ucieknie.",
                    label = "Przywróć strój przy ucieczce",
                },
                jailRestoreSpawnCorrectionMs = {
                    description = "Okno łaskawości po przywróceniu, zanim korekta punktu odrodzenia przestanie działać.",
                    label = "Okno korekty przywrócenia",
                },
                jailTeleportRestoreOutsideZone = {
                    description = "Teleportuj przywróconych więźniów z powrotem do punktu odrodzenia więzienia, jeśli wczytają się poza strefą więzienia.",
                    label = "Teleportuj przywróconych więźniów",
                },
                jailTerminalRange = {
                    description = "Maksymalna odległość funkcjonariusza od terminala wybranego więzienia.",
                    label = "Zasięg terminala więzienia",
                },
                jailZoneExitGraceMs = {
                    description = "Okno łaskawości przed uznaniem wyjścia ze strefy więzienia za ucieczkę.",
                    label = "Okno łaskawości wyjścia ze strefy",
                },
                mugshotAnimDict = {
                    description = "Słownik animacji używany podczas wykonywania zdjęcia aresztowego.",
                    label = "Słownik animacji",
                },
                mugshotAnimFlag = {
                    description = "Flaga animacji używana podczas wykonywania zdjęcia aresztowego.",
                    label = "Flaga animacji",
                },
                mugshotAnimName = {
                    description = "Nazwa animacji używana podczas wykonywania zdjęcia aresztowego.",
                    label = "Nazwa animacji",
                },
                mugshotBoardHeader = {
                    description = "Główny nagłówek wyświetlany na tablicy zdjęcia aresztowego.",
                    label = "Nagłówek tablicy",
                },
                mugshotBoardSubheader = {
                    description = "Zapasowy podtytuł wyświetlany na tablicy zdjęcia aresztowego.",
                    label = "Podtytuł tablicy",
                },
                mugshotCameraCoordsX = {
                    description = "Współrzędna X świata kamery używana dla zdjęć aresztowych.",
                    label = "Kamera X",
                },
                mugshotCameraCoordsY = {
                    description = "Współrzędna Y świata kamery używana dla zdjęć aresztowych.",
                    label = "Kamera Y",
                },
                mugshotCameraCoordsZ = {
                    description = "Współrzędna Z świata kamery używana dla zdjęć aresztowych.",
                    label = "Kamera Z",
                },
                mugshotCameraFov = {
                    description = "Pole widzenia używane do wykonywania zdjęć aresztowych.",
                    label = "Pole widzenia kamery",
                },
                mugshotCameraRotX = {
                    description = "Obrót X kamery używany dla zdjęć aresztowych.",
                    label = "Obrót X",
                },
                mugshotCameraRotY = {
                    description = "Obrót Y kamery używany dla zdjęć aresztowych.",
                    label = "Obrót Y",
                },
                mugshotCameraRotZ = {
                    description = "Obrót Z kamery używany dla zdjęć aresztowych.",
                    label = "Obrót Z",
                },
                mugshotCaptureTimeout = {
                    description = "Maksymalna liczba milisekund dozwolona dla wywołań zwrotnych wykonania zdjęcia aresztowego.",
                    label = "Limit czasu wykonania zdjęcia",
                },
                mugshotEnabled = {
                    description = "Włącz wykonywanie zdjęcia aresztowego podczas przyjęcia do więzienia.",
                    label = "Zdjęcie aresztowe",
                },
                mugshotHeading = {
                    description = "Kierunek stosowany podczas wykonywania zdjęcia aresztowego.",
                    label = "Kierunek",
                },
                mugshotLocationX = {
                    description = "Współrzędna X świata używana do wykonania zdjęcia aresztowego.",
                    label = "Lokalizacja X",
                },
                mugshotLocationY = {
                    description = "Współrzędna Y świata używana do wykonania zdjęcia aresztowego.",
                    label = "Lokalizacja Y",
                },
                mugshotLocationZ = {
                    description = "Współrzędna Z świata używana do wykonania zdjęcia aresztowego.",
                    label = "Lokalizacja Z",
                },
                mugshotMetadataDescriptionFormat = {
                    description = "Format opisu używany dla zapisanych metadanych zdjęcia aresztowego.",
                    label = "Opis metadanych",
                },
                mugshotMetadataName = {
                    description = "Nazwa metadanych ekwipunku używana dla zapisanego zdjęcia aresztowego.",
                    label = "Nazwa metadanych",
                },
                mugshotWaitMs = {
                    description = "Liczba milisekund oczekiwania przed wykonaniem zdjęcia aresztowego.",
                    label = "Milisekundy oczekiwania",
                },
                playerSearchAnimDict = {
                    description = "Słownik animacji używany podczas przeszukania gracza.",
                    label = "Słownik animacji",
                },
                playerSearchAnimFlag = {
                    description = "Flaga animacji używana podczas przeszukania gracza.",
                    label = "Flaga animacji",
                },
                playerSearchAnimName = {
                    description = "Nazwa animacji używana podczas przeszukania gracza.",
                    label = "Nazwa animacji",
                },
                playerSearchDurationMs = {
                    description = "Czas trwania podglądu przeszukania gracza w milisekundach.",
                    label = "Czas przeszukania",
                },
                playerSearchEnabled = {
                    description = "Włącz proces podglądu przeszukania gracza.",
                    label = "Przeszukanie gracza",
                },
                playerSearchRange = {
                    description = "Maksymalna odległość do rozpoczęcia przeszukania gracza.",
                    label = "Zasięg przeszukania",
                },
                playerSearchScenario = {
                    description = "Scenariusz używany, gdy nie jest odtwarzana jawna animacja przeszukania.",
                    label = "Scenariusz przeszukania",
                },
                policeBillingControl200 = {
                    label = "Rachunki · Sterowanie 200",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeBillingControl322 = {
                    label = "Rachunki · Sterowanie 322",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl10 = {
                    label = "Edytor · Sterowanie 10",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl11 = {
                    label = "Edytor · Sterowanie 11",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl172 = {
                    label = "Edytor · Sterowanie 172",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl173 = {
                    label = "Edytor · Sterowanie 173",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl174 = {
                    label = "Edytor · Sterowanie 174",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl175 = {
                    label = "Edytor · Sterowanie 175",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl177 = {
                    label = "Edytor · Sterowanie 177",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl191 = {
                    label = "Edytor · Sterowanie 191",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl201 = {
                    label = "Edytor · Sterowanie 201",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl202 = {
                    label = "Edytor · Sterowanie 202",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl21 = {
                    label = "Edytor · Sterowanie 21",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl32 = {
                    label = "Edytor · Sterowanie 32",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl322 = {
                    label = "Edytor · Sterowanie 322",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl33 = {
                    label = "Edytor · Sterowanie 33",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl34 = {
                    label = "Edytor · Sterowanie 34",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl35 = {
                    label = "Edytor · Sterowanie 35",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl36 = {
                    label = "Edytor · Sterowanie 36",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl37 = {
                    label = "Edytor · Sterowanie 37",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl38 = {
                    label = "Edytor · Sterowanie 38",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl44 = {
                    label = "Edytor · Sterowanie 44",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policeEditorControl73 = {
                    label = "Edytor · Sterowanie 73",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                policePrimaryColor = {
                    description = "Domyślny kolor grupy prac policyjnych.",
                    label = "Kolor główny",
                },
                propPlacementConsumeItem = {
                    description = "Usuń jeden przedmiot z ekwipunku przy rozmieszczeniu rekwizytu.",
                    label = "Zużyj przedmiot rekwizytu",
                },
                propPlacementEnabled = {
                    description = "Zezwól na rozmieszczanie skonfigurowanych rekwizytów policyjnych z przedmiotów lub pojazdów.",
                    label = "Rozmieszczanie rekwizytów",
                },
                propPlacementItemNames = {
                    description = "Zmapuj modele rekwizytów na nazwy przedmiotów w ekwipunku do rozmieszczania rekwizytów na podstawie przedmiotów.",
                    label = "Nazwy przedmiotów rekwizytów",
                },
                propPlacementRequireOnDuty = {
                    description = "Tylko funkcjonariusze na służbie mogą rozmieszczać skonfigurowane rekwizyty.",
                    label = "Rekwizyty wymagają służby",
                },
                propPlacementReturnItem = {
                    description = "Zwróć zużyty przedmiot po usunięciu rozmieszczonego rekwizytu.",
                    label = "Zwróć przedmiot rekwizytu",
                },
                propPlacementVehicleAccess = {
                    description = "Zezwól pojazdom służbowym na udostępnianie skonfigurowanego wyposażenia w rekwizyty.",
                    label = "Dostęp do rekwizytów pojazdu",
                },
                radialEnabled = {
                    description = "Włącz akcje radialne policji.",
                    label = "Menu radialne policji",
                },
                radialHandcuffKeybindCommand = {
                    description = "Nazwa komendy zarejestrowanej dla skrótu zakładania kajdanek.",
                    label = "Komenda zakładania kajdanek",
                },
                radialHandcuffKeybindDescription = {
                    description = "Opis wyświetlany dla skrótu zakładania kajdanek.",
                    label = "Opis zakładania kajdanek",
                },
                radialHandcuffKeybindEnabled = {
                    description = "Włącz bezpośredni skrót do zakładania kajdanek.",
                    label = "Skrót zakładania kajdanek",
                },
                radialHandcuffKeybindKey = {
                    description = "Klawisz klawiatury używany do bezpośredniej akcji zakładania kajdanek.",
                    label = "Klawisz zakładania kajdanek",
                },
                radialKeybindsEnabled = {
                    description = "Włącz bezpośrednie skróty klawiszowe dla wybranych akcji radialnych.",
                    label = "Bezpośrednie skróty klawiszowe",
                },
                radialUnhandcuffKeybindCommand = {
                    description = "Nazwa komendy zarejestrowanej dla skrótu zdejmowania kajdanek.",
                    label = "Komenda zdejmowania kajdanek",
                },
                radialUnhandcuffKeybindDescription = {
                    description = "Opis wyświetlany dla skrótu zdejmowania kajdanek.",
                    label = "Opis zdejmowania kajdanek",
                },
                radialUnhandcuffKeybindEnabled = {
                    description = "Włącz bezpośredni skrót do zdejmowania kajdanek.",
                    label = "Skrót zdejmowania kajdanek",
                },
                radialUnhandcuffKeybindKey = {
                    description = "Klawisz klawiatury używany do bezpośredniej akcji zdejmowania kajdanek.",
                    label = "Klawisz zdejmowania kajdanek",
                },
                socialWorkAssignRange = {
                    description = "Maksymalna odległość do przydzielenia zadań pracy socjalnej.",
                    label = "Zasięg przydziału",
                },
                socialWorkDeadlineDefault = {
                    description = "Domyślny termin pracy socjalnej w minutach. Zero wyłącza terminy.",
                    label = "Domyślny termin",
                },
                socialWorkDeadlineMax = {
                    description = "Maksymalny termin pracy socjalnej w minutach. Zero wyłącza limit.",
                    label = "Maksymalny termin",
                },
                socialWorkDeadlineMin = {
                    description = "Minimalny termin pracy socjalnej w minutach.",
                    label = "Minimalny termin",
                },
                socialWorkDefaultTasks = {
                    description = "Domyślna liczba zadań przy otwieraniu przydziału pracy socjalnej.",
                    label = "Domyślna liczba zadań",
                },
                socialWorkEnabled = {
                    description = "Włącz przydział i procesy zadań pracy socjalnej.",
                    label = "Praca socjalna",
                },
                socialWorkImprisonmentJailId = {
                    description = "ID więzienia używane, gdy naruszenia pracy socjalnej prowadzą do uwięzienia.",
                    label = "Zapasowe ID więzienia",
                },
                socialWorkImprisonmentMonths = {
                    description = "Liczba miesięcy przydzielana, gdy naruszenia pracy socjalnej skutkują więzieniem.",
                    label = "Miesiące uwięzienia",
                },
                socialWorkImprisonmentOfficerName = {
                    description = "Nazwa funkcjonariusza używana dla rekordów uwięzienia z pracy socjalnej.",
                    label = "Nazwa funkcjonariusza uwięzienia",
                },
                socialWorkImprisonmentSolitary = {
                    description = "Wysyłaj naruszających do celi izolacyjnej, gdy nastąpi uwięzienie.",
                    label = "Użyj celi izolacyjnej",
                },
                socialWorkInactivityMinutes = {
                    description = "Liczba minut przed zastosowaniem kar za nieaktywność w pracy socjalnej.",
                    label = "Minuty nieaktywności",
                },
                socialWorkInactivityTaskPenalty = {
                    description = "Kara zadań stosowana, gdy gracz pracy socjalnej pozostaje zbyt długo nieaktywny.",
                    label = "Kara zadań za nieaktywność",
                },
                socialWorkMaxTasks = {
                    description = "Maksymalna wybieralna liczba zadań pracy socjalnej.",
                    label = "Maksymalna liczba zadań",
                },
                socialWorkMinTasks = {
                    description = "Minimalna wybieralna liczba zadań pracy socjalnej.",
                    label = "Minimalna liczba zadań",
                },
                speedCamBillingEnabled = {
                    description = "Wystawiaj automatyczne rachunki, gdy fotoradar zarejestruje pasujące wykroczenie. Wymaga włączenia globalnej funkcji Rozliczenia.",
                    label = "Automatyczne mandaty",
                },
                speedCamBillingExcludedJobs = {
                    description = "Prace, które nigdy nie otrzymują automatycznych rachunków z fotoradarów.",
                    itemLabel = "Praca",
                    label = "Wykluczone prace",
                },
                speedCamBillingExcludedModels = {
                    description = "Nazwy spawn pojazdów, które nigdy nie otrzymują automatycznych rachunków z fotoradarów.",
                    itemLabel = "Wzór",
                    label = "Wykluczone modele pojazdów",
                },
                speedCamBillingRules = {
                    description = "Zasady mandatów używane przez fotoradary. Najściślej pasujący zakres przekroczenia jest rozliczany jako pierwszy; jeśli żadna zasada nie pasuje, jako zapasowe używane są wykroczenia SpeedViolation.",
                    label = "Zasady mandatów",
                },
                speedCamCameraEaseMs = {
                    description = "Jak długo trwa przejście widoku do kąta fotoradaru. Niższa wartość = krótszy ruch; zbyt niska może zniekształcić zdjęcie.",
                    label = "Przejście kamery (ms)",
                },
                speedCamCameraFov = {
                    description = "Pole widzenia używane do zdjęć fotoradaru.",
                    label = "Pole widzenia kamery",
                },
                speedCamCheckIntervalMs = {
                    description = "Liczba milisekund między skanowaniami fotoradaru.",
                    label = "Interwał sprawdzania",
                },
                speedCamCooldownMs = {
                    description = "Liczba milisekund przed ponownym wyzwoleniem tego samego fotoradaru.",
                    label = "Odnowienie wyzwolenia",
                },
                speedCamDamageCooldownMs = {
                    description = "Liczba milisekund przed ponownym zadaniem obrażeń fotoradarowi.",
                    label = "Odnowienie obrażeń",
                },
                speedCamDamagePerHit = {
                    description = "Obrażenia trwałości zadawane fotoradarom przy każdym trafieniu.",
                    label = "Obrażenia na trafienie",
                },
                speedCamDamagedModelThreshold = {
                    description = "Procent maksymalnej wytrzymałości, przy którym lub poniżej którego wyświetlany jest uszkodzony model. Przykład: 50 przy maksymalnej wytrzymałości 200 zmienia model przy wytrzymałości 100.",
                    label = "Próg uszkodzonego modelu (%)",
                },
                speedCamDefaultLimit = {
                    description = "Domyślny limit fotoradaru.",
                    label = "Domyślny limit prędkości",
                },
                speedCamDefaultName = {
                    description = "Sugerowana nazwa wyświetlana przy ustawianiu fotoradaru. Można ją przetłumaczyć bez zmiany przedmiotu w ekwipunku ani modelu obiektu.",
                    label = "Domyślna nazwa",
                },
                speedCamDefaultTolerance = {
                    description = "Domyślna tolerancja fotoradaru.",
                    label = "Domyślna tolerancja",
                },
                speedCamDisassembleDistance = {
                    description = "Odległość używana do demontażu fotoradarów.",
                    label = "Odległość demontażu",
                },
                speedCamEnabled = {
                    description = "Włącz przenośne fotoradary.",
                    label = "Fotoradary",
                },
                speedCamFlashColor = {
                    description = "Kolor RGBA błysku używany przez fotoradary.",
                    label = "Kolor błysku",
                },
                speedCamFlashDurationMs = {
                    description = "Czas zanikania czerwonego błysku fotoradaru. Nie ustawiaj zbyt niskiej wartości, inaczej ruch kamery stanie się widoczny.",
                    label = "Czas błysku (ms)",
                },
                speedCamHealthDisplayDistance = {
                    description = "Odległość, przy której wyświetlana jest trwałość fotoradaru.",
                    label = "Odległość wyświetlania trwałości",
                },
                speedCamHealthDisplayDurationMs = {
                    description = "Liczba milisekund, przez jaką trwałość fotoradaru pozostaje widoczna.",
                    label = "Czas wyświetlania trwałości",
                },
                speedCamHealthTextOffset = {
                    description = "Pionowe przesunięcie używane dla tekstu trwałości fotoradaru.",
                    label = "Przesunięcie tekstu trwałości",
                },
                speedCamItem = {
                    description = "Dokładna wewnętrzna nazwa przedmiotu w ekwipunku, np. speedcam. Wpisz klucz przedmiotu, nie nazwę wyświetlaną; sklep pracy musi wydawać ten sam przedmiot.",
                    label = "Nazwa przedmiotu fotoradaru",
                },
                speedCamMaintenanceThreshold = {
                    description = "Próg trwałości, przy którym zalecana jest konserwacja fotoradaru.",
                    label = "Próg konserwacji",
                },
                speedCamMaxDurability = {
                    description = "Maksymalna trwałość rozmieszczonych fotoradarów.",
                    label = "Maksymalna trwałość",
                },
                speedCamMaxLimit = {
                    description = "Maksymalny konfigurowalny limit fotoradaru.",
                    label = "Maksymalny limit prędkości",
                },
                speedCamMaxTolerance = {
                    description = "Maksymalna konfigurowalna tolerancja fotoradaru.",
                    label = "Maksymalna tolerancja",
                },
                speedCamPhotoLocale = {
                    description = "Opcjonalne ustawienia regionalne używane dla znacznika czasu na zdjęciach fotoradaru. Pozostaw puste, aby użyć lokalnych ustawień gracza, który został sfotografowany.",
                    label = "Ustawienia regionalne zdjęcia",
                },
                speedCamPhotoTimeZone = {
                    description = "Opcjonalna strefa czasowa używana dla znacznika czasu na zdjęciach fotoradaru. Pozostaw puste, aby użyć lokalnej strefy czasowej gracza, który został sfotografowany.",
                    label = "Strefa czasowa zdjęcia",
                },
                speedCamPoliceNotification = {
                    description = "Wyślij powiadomienie zgłoszenia, gdy fotoradar zarejestruje naruszenia.",
                    label = "Alarm policyjny fotoradaru",
                },
                speedCamPoliceNotificationGroup = {
                    description = "Traktuj cel zgłoszenia fotoradaru jako grupę zadaniową.",
                    label = "Cel zgłoszenia jako grupa",
                },
                speedCamPoliceNotificationJob = {
                    description = "Klucz zadania lub grupy używany dla powiadomień zgłoszeniowych fotoradaru.",
                    label = "Cel zgłoszenia",
                },
                speedCamPoliceNotificationRequireDuty = {
                    description = "Powiadamiaj tylko cele zgłoszenia fotoradaru będące na służbie.",
                    label = "Zgłoszenie wymaga służby",
                },
                speedCamPoliceNotificationType = {
                    description = "Typ/waga zgłoszenia używana dla alarmów fotoradaru.",
                    label = "Typ zgłoszenia",
                },
                speedCamPropModel = {
                    description = "Nazwa tworzenia nieuszkodzonego modelu fotoradaru, np. sky_speedcam. Wariant gotowy ustawia również modele uszkodzony i zniszczony. Własne modele muszą być dostępne w grze.",
                    label = "Model rekwizytu fotoradaru",
                    custom = "Własny model",
                    choose = "Wybierz model",
                    preview = "Podgląd 3D",
                    customPlaceholder = "Nazwa spawnu obiektu",
                    previewDescription = "Pokaż wybrany obiekt w grze. Podgląd nie zapisuje zmian.",
                    invalidModel = "Najpierw wpisz poprawną nazwę obiektu.",
                    modelMissing = "Ten model obiektu nie jest dostępny w grze.",
                    previewFailed = "Nie udało się otworzyć podglądu modelu.",
                    intact = "Nieuszkodzony model",
                    previewRequiresGame = "Otwórz /jobconfig w FiveM, aby zobaczyć obiekt na żywo.",
                    previewHelp = "Strzałki: ruch; PageUp/PageDown: wysokość; kółko: obrót; Enter: zamknij; Backspace: anuluj.",
                    options = {
                        sky_speedcam = "Standardowy fotoradar",
                        sky_germ_speedcam = "Niemiecki fotoradar",
                    },
                },
                speedCamPropModelDamaged = {
                    description = "Nazwa tworzenia uszkodzonego modelu fotoradaru, np. sky_speedcam2. Wybierz wariant pasujący do nieuszkodzonego modelu.",
                    label = "Model uszkodzonego rekwizytu",
                },
                speedCamPropModelDestroyed = {
                    description = "Nazwa modelu wyświetlanego przy wytrzymałości 0, np. sky_speedcam1. Wybierz wariant pasujący do nieuszkodzonego modelu.",
                    label = "Model zniszczonego rekwizytu",
                },
                speedCamRepairAnimDict = {
                    description = "Słownik animacji używany podczas naprawy fotoradarów.",
                    label = "Słownik animacji naprawy",
                },
                speedCamRepairAnimFlag = {
                    description = "Flaga animacji używana podczas naprawy fotoradarów.",
                    label = "Flaga animacji naprawy",
                },
                speedCamRepairAnimName = {
                    description = "Nazwa animacji używana podczas naprawy fotoradarów.",
                    label = "Nazwa animacji naprawy",
                },
                speedCamRepairCancelDelayMs = {
                    description = "Liczba milisekund przed możliwością anulowania naprawy fotoradaru.",
                    label = "Opóźnienie anulowania naprawy",
                },
                speedCamRepairDistance = {
                    description = "Odległość używana do naprawy fotoradarów.",
                    label = "Odległość naprawy",
                },
                speedCamRepairItem = {
                    description = "Dokładna wewnętrzna nazwa przedmiotu do naprawy, np. fixtool. Wpisz klucz przedmiotu, nie nazwę wyświetlaną.",
                    label = "Nazwa przedmiotu do naprawy",
                },
                speedCamRepairPerTick = {
                    description = "Trwałość przywracana przy każdym takcie naprawy fotoradaru.",
                    label = "Naprawa na takt",
                },
                speedCamRepairTickMs = {
                    description = "Liczba milisekund między taktami naprawy fotoradaru.",
                    label = "Takt naprawy",
                },
                speedCamStreamDistance = {
                    description = "Odległość od gracza w metrach, w której ładowane są modele fotoradarów. Poza nią modele są usuwane z widoku; zapisane fotoradary pozostają ustawione.",
                    label = "Odległość streamingu",
                },
                speedCamTriggerRadius = {
                    description = "Promień wykrywania pojazdów przekraczających prędkość wokół fotoradaru w metrach.",
                    label = "Promień wyzwolenia",
                },
                speedCamUseMph = {
                    description = "Wyświetlaj i przetwarzaj limity fotoradaru w MPH.",
                    label = "Użyj MPH",
                },
                speedCamWeaponDamageRestrictionAllowedWeapons = {
                    description = "Broń, która może uszkadzać fotoradary, gdy ograniczenie jest włączone.",
                    itemLabel = "Broń",
                    label = "Dozwolona broń",
                },
                speedCamWeaponDamageRestrictionEnabled = {
                    description = "Tylko wymieniona broń może uszkadzać fotoradary, gdy ta opcja jest włączona.",
                    label = "Ograniczenie włączone",
                },
                speedCameraAppClearDistanceMeters = {
                    description = "Odległość w metrach przed usunięciem ostrzeżeń o fotoradarze.",
                    label = "Odległość usunięcia ostrzeżenia",
                },
                speedCameraAppDefaultApp = {
                    description = "Pokaż aplikację fotoradaru jako domyślną aplikację tabletu.",
                    label = "Domyślna aplikacja",
                },
                speedCameraAppDescription = {
                    description = "Opis wyświetlany dla aplikacji fotoradaru na tablecie.",
                    label = "Opis",
                },
                speedCameraAppDeveloper = {
                    description = "Etykieta dewelopera wyświetlana dla aplikacji fotoradaru na tablecie.",
                    label = "Deweloper",
                },
                speedCameraAppEnabled = {
                    description = "Włącz aplikację fotoradaru na tablecie policyjnym.",
                    label = "Aplikacja fotoradaru na tablecie",
                },
                speedCameraAppHeaderEyebrow = {
                    description = "Nadtytuł nagłówka wyświetlany w aplikacji fotoradaru.",
                    label = "Nadtytuł nagłówka",
                },
                speedCameraAppHeaderTitle = {
                    description = "Tytuł nagłówka wyświetlany w aplikacji fotoradaru.",
                    label = "Tytuł nagłówka",
                },
                speedCameraAppIcon = {
                    description = "Ścieżka ikony używana dla aplikacji fotoradaru na tablecie.",
                    label = "Ścieżka ikony",
                },
                speedCameraAppIdentifier = {
                    description = "Wewnętrzny identyfikator aplikacji fotoradaru na tablecie.",
                    label = "Identyfikator",
                },
                speedCameraAppInFrontDot = {
                    description = "Próg iloczynu skalarnego używany do określenia, czy fotoradar znajduje się przed graczem.",
                    label = "Próg iloczynu skalarnego z przodu",
                },
                speedCameraAppMinimumVehicleSpeedKmh = {
                    description = "Minimalna prędkość pojazdu przed wyświetleniem ostrzeżeń.",
                    label = "Minimalna prędkość pojazdu",
                },
                speedCameraAppName = {
                    description = "Nazwa wyświetlana aplikacji fotoradaru na tablecie.",
                    label = "Nazwa aplikacji",
                },
                speedCameraAppNotifyDistanceMeters = {
                    description = "Odległość w metrach przed powiadomieniem o pobliskich fotoradarach.",
                    label = "Odległość powiadomienia",
                },
                speedCameraAppOnlyInVehicle = {
                    description = "Ostrzegaj o fotoradarach tylko wtedy, gdy gracz znajduje się w pojeździe.",
                    label = "Tylko w pojeździe",
                },
                speedCameraAppOverlayBackground = {
                    description = "Kolor tła używany dla nakładki obrazu tablicy rejestracyjnej.",
                    label = "Tło nakładki",
                },
                speedCameraAppOverlayBorder = {
                    description = "Kolor ramki używany dla nakładki obrazu tablicy rejestracyjnej.",
                    label = "Ramka nakładki",
                },
                speedCameraAppOverlayColor = {
                    description = "Kolor tekstu używany dla nakładki obrazu tablicy rejestracyjnej.",
                    label = "Kolor nakładki",
                },
                speedCameraAppOverlayEnabled = {
                    description = "Włącz nakładki obrazu tablicy rejestracyjnej na przechwyconych zdjęciach fotoradaru.",
                    label = "Nakładka włączona",
                },
                speedCameraAppOverlayFontScale = {
                    description = "Skala czcionki używana dla nakładki obrazu tablicy rejestracyjnej.",
                    label = "Skala czcionki nakładki",
                },
                speedCameraAppOverlayX = {
                    description = "Znormalizowana pozycja X nakładki od lewej do prawej.",
                    label = "Nakładka X",
                },
                speedCameraAppOverlayY = {
                    description = "Znormalizowana pozycja Y nakładki od góry do dołu.",
                    label = "Nakładka Y",
                },
                speedCameraAppRequireInFront = {
                    description = "Ostrzegaj tylko o fotoradarach znajdujących się przed graczem.",
                    label = "Wymagaj z przodu",
                },
                speedCameraAppRoute = {
                    description = "Ścieżka routera otwierana przez aplikację fotoradaru na tablecie.",
                    label = "Trasa",
                },
                speedCameraAppSize = {
                    description = "Zgłaszany rozmiar magazynowy aplikacji fotoradaru na tablecie.",
                    label = "Rozmiar aplikacji",
                },
                speedCameraAppSoundCoord = {
                    description = "Odtwarzaj dźwięki ostrzeżeń fotoradaru we współrzędnych świata.",
                    label = "Dźwięk współrzędnych",
                },
                speedCameraAppSoundEnabled = {
                    description = "Włącz dźwięki ostrzeżeń dla aplikacji fotoradaru.",
                    label = "Dźwięk włączony",
                },
                speedCameraAppSoundFrontend = {
                    description = "Odtwarzaj dźwięki ostrzeżeń fotoradaru na kanale audio frontend.",
                    label = "Dźwięk frontend",
                },
                speedCameraAppSoundLayers = {
                    description = "Liczba nakładających się dźwięków ostrzeżeń odtwarzanych przez aplikację fotoradaru.",
                    label = "Warstwy dźwięku",
                },
                speedCameraAppSoundName = {
                    description = "Nazwa dźwięku używana dla ostrzeżeń aplikacji fotoradaru.",
                    label = "Nazwa dźwięku",
                },
                speedCameraAppSoundRange = {
                    description = "Zasięg używany dla dźwięków ostrzeżeń aplikacji fotoradaru.",
                    label = "Zasięg dźwięku",
                },
                speedCameraAppSoundRepeatCount = {
                    description = "Liczba powtórzeń dźwięku ostrzeżenia fotoradaru.",
                    label = "Liczba powtórzeń",
                },
                speedCameraAppSoundRepeatDelayMs = {
                    description = "Liczba milisekund między powtórzeniami dźwięku ostrzeżenia fotoradaru.",
                    label = "Opóźnienie powtórzenia",
                },
                speedCameraAppSoundSet = {
                    description = "Zestaw dźwiękowy używany dla ostrzeżeń aplikacji fotoradaru.",
                    label = "Zestaw dźwięku",
                },
                speedCameraAppSubscriptionAccount = {
                    description = "Konto używane do płatności za subskrypcję aplikacji fotoradaru na tablecie.",
                    label = "Konto",
                },
                speedCameraAppSubscriptionEnabled = {
                    description = "Włącz płatne subskrypcje dla aplikacji fotoradaru na tablecie.",
                    label = "Subskrypcja włączona",
                },
                speedCameraAppSubscriptionIntervalDays = {
                    description = "Liczba dni między odnowieniami subskrypcji aplikacji fotoradaru na tablecie.",
                    label = "Dni interwału",
                },
                speedCameraAppSubscriptionPrice = {
                    description = "Cena pobierana za subskrypcję aplikacji fotoradaru na tablecie.",
                    label = "Cena subskrypcji",
                },
                speedCameraAppThemeAccent = {
                    description = "Kolor akcentu używany przez aplikację fotoradaru.",
                    label = "Akcent",
                },
                speedCameraAppThemeBackground = {
                    description = "Tło z gradientem liniowym używane przez aplikację fotoradaru.",
                    label = "Tło",
                },
                speedCameraAppThemeBorder = {
                    description = "Kolor ramki używany przez aplikację fotoradaru.",
                    label = "Ramka",
                },
                speedCameraAppThemeButtonText = {
                    description = "Kolor tekstu przycisku używany przez aplikację fotoradaru.",
                    label = "Tekst przycisku",
                },
                speedCameraAppThemeDanger = {
                    description = "Kolor zagrożenia używany przez aplikację fotoradaru.",
                    label = "Zagrożenie",
                },
                speedCameraAppThemeGhost = {
                    description = "Kolor przycisku ghost używany przez aplikację fotoradaru.",
                    label = "Przycisk ghost",
                },
                speedCameraAppThemeGhostText = {
                    description = "Kolor tekstu ghost używany przez aplikację fotoradaru.",
                    label = "Tekst ghost",
                },
                speedCameraAppThemeGradientSoft = {
                    description = "Kolor miękkiego gradientu używany przez aplikację fotoradaru.",
                    label = "Miękki gradient",
                },
                speedCameraAppThemeInactiveBorder = {
                    description = "Kolor nieaktywnej ramki używany przez aplikację fotoradaru.",
                    label = "Nieaktywna ramka",
                },
                speedCameraAppThemeModal = {
                    description = "Kolor tła okna modalnego używany przez aplikację fotoradaru.",
                    label = "Okno modalne",
                },
                speedCameraAppThemeMutedText = {
                    description = "Kolor przygaszonego tekstu używany przez aplikację fotoradaru.",
                    label = "Przygaszony tekst",
                },
                speedCameraAppThemeOverlay = {
                    description = "Kolor nakładki używany przez aplikację fotoradaru.",
                    label = "Nakładka",
                },
                speedCameraAppThemePillText = {
                    description = "Kolor tekstu pigułki używany przez aplikację fotoradaru.",
                    label = "Tekst pigułki",
                },
                speedCameraAppThemePrimaryFrom = {
                    description = "Kolor początkowy głównego gradientu używany przez aplikację fotoradaru.",
                    label = "Gradient główny - początek",
                },
                speedCameraAppThemePrimaryTo = {
                    description = "Kolor końcowy głównego gradientu używany przez aplikację fotoradaru.",
                    label = "Gradient główny - koniec",
                },
                speedCameraAppThemeShadow = {
                    description = "Kolor cienia używany przez aplikację fotoradaru.",
                    label = "Cień",
                },
                speedCameraAppThemeSpotlight = {
                    description = "Kolor akcentu podświetlenia używany przez aplikację fotoradaru.",
                    label = "Podświetlenie",
                },
                speedCameraAppThemeSubtleText = {
                    description = "Kolor subtelnego tekstu używany przez aplikację fotoradaru.",
                    label = "Subtelny tekst",
                },
                speedCameraAppThemeSuccess = {
                    description = "Kolor sukcesu używany przez aplikację fotoradaru.",
                    label = "Sukces",
                },
                speedCameraAppThemeSurface = {
                    description = "Kolor powierzchni używany przez aplikację fotoradaru.",
                    label = "Powierzchnia",
                },
                speedCameraAppThemeSurfaceSoft = {
                    description = "Kolor miękkiej powierzchni używany przez aplikację fotoradaru.",
                    label = "Miękka powierzchnia",
                },
                speedCameraAppThemeText = {
                    description = "Główny kolor tekstu używany przez aplikację fotoradaru.",
                    label = "Tekst",
                },
                speedCameraAppWarningUiAccent = {
                    description = "Kolor akcentu RGBA używany dla interfejsu ostrzeżenia fotoradaru.",
                    label = "Akcent RGBA",
                },
                speedCameraAppWarningUiBackground = {
                    description = "Kolor RGBA używany dla tła interfejsu ostrzeżenia fotoradaru.",
                    label = "Tło RGBA",
                },
                speedCameraAppWarningUiIcon = {
                    description = "Kolor ikony RGBA używany dla interfejsu ostrzeżenia fotoradaru.",
                    label = "Ikona RGBA",
                },
                speedCameraAppWarningUiIconText = {
                    description = "Kolor tekstu ikony RGBA używany dla interfejsu ostrzeżenia fotoradaru.",
                    label = "Tekst ikony RGBA",
                },
                speedCameraAppWarningUiSeconds = {
                    description = "Liczba sekund, przez jaką interfejs ostrzeżenia pozostaje widoczny.",
                    label = "Sekundy interfejsu ostrzeżenia",
                },
                speedCameraAppWarningUiSubText = {
                    description = "Kolor podtekstu RGBA używany dla interfejsu ostrzeżenia fotoradaru.",
                    label = "Podtekst RGBA",
                },
                speedCameraAppWarningUiText = {
                    description = "Kolor tekstu RGBA używany dla interfejsu ostrzeżenia fotoradaru.",
                    label = "Tekst RGBA",
                },
                speedCameraAppWarningUiTitle = {
                    description = "Kolor tytułu RGBA używany dla interfejsu ostrzeżenia fotoradaru.",
                    label = "Tytuł RGBA",
                },
                spikeStripsCheckIntervalMs = {
                    description = "Liczba milisekund między sprawdzeniami odległości kolczatki.",
                    label = "Interwał sprawdzania",
                },
                spikeStripsEnabled = {
                    description = "Włącz rozłożone kolczatki.",
                    label = "Kolczatki",
                },
                spikeStripsModels = {
                    description = "Modele rekwizytów traktowane jako aktywne kolczatki.",
                    itemLabel = "Wzór",
                    label = "Modele",
                },
                spikeStripsRetryIntervalMs = {
                    description = "Liczba milisekund przed ponowieniem skanowania kolczatek po braku dopasowania.",
                    label = "Interwał ponawiania",
                },
                spikeStripsScanDistance = {
                    description = "Odległość używana do skanowania pobliskich kolczatek.",
                    label = "Odległość skanowania",
                },
                spikeStripsTriggerDistance = {
                    description = "Odległość, przy której opony są przebijane przez kolczatkę.",
                    label = "Odległość wyzwolenia",
                },
                stationCreatorBlipCategoryLabel = {
                    description = "Etykieta kategorii używana dla ikon kreatora stacji na mapie.",
                    label = "Kategoria ikony stacji",
                },
                stationCreatorBlipColor = {
                    description = "Kolor ikony mapy używany dla posterunków policji.",
                    label = "Kolor ikony stacji",
                },
                stationCreatorBlipScale = {
                    description = "Skala używana dla ikon posterunków policji.",
                    label = "Skala ikony stacji",
                },
                stationCreatorBlipShortRange = {
                    description = "Pokazuj ikony stacji na mapie tylko z bliskiej odległości.",
                    label = "Krótki zasięg ikony stacji",
                },
                stationCreatorBlipSprite = {
                    description = "Sprite ikony mapy używany dla posterunków policji.",
                    label = "Sprite ikony stacji",
                },
                stationCreatorBlipUseStationName = {
                    description = "Użyj skonfigurowanej nazwy stacji jako etykiety ikony na mapie.",
                    label = "Użyj nazwy stacji",
                },
                tabletAutoFillCitizens = {
                    description = "Wstępnie wypełnij rejestr obywateli z bazy danych frameworka.",
                    label = "Automatyczne uzupełnianie obywateli",
                },
                tabletAutoFillVehicles = {
                    description = "Wstępnie wypełnij rejestr pojazdów z bazy danych frameworka.",
                    label = "Automatyczne uzupełnianie pojazdów",
                },
                tabletBolos = {
                    description = "Pokaż aplikację list poszukiwawczych (BOLO).",
                    label = "Listy poszukiwawcze",
                },
                tabletCases = {
                    description = "Pokaż aplikację spraw.",
                    label = "Sprawy",
                },
                tabletCitizens = {
                    description = "Pokaż aplikację rejestru obywateli.",
                    label = "Obywatele",
                },
                tabletConfiscations = {
                    description = "Pokaż rejestr przedmiotów skonfiskowanych podczas przeszukań.",
                    label = "Konfiskaty",
                },
                tabletOffences = {
                    description = "Pokaż aplikację wykroczeń.",
                    label = "Wykroczenia",
                },
                tabletPrison = {
                    description = "Pokaż aplikację więzienia.",
                    label = "Więzienie",
                },
                tabletReportEnforcement = {
                    description = "Pozwala przypisywać wykroczenia oraz wystawiać grzywny lub kary więzienia z zapisanych raportów.",
                    label = "Egzekwowanie raportów",
                },
                tabletReports = {
                    description = "Pokaż aplikację raportów.",
                    label = "Raporty",
                },
                tabletSocialWork = {
                    description = "Pokaż aplikację pracy socjalnej.",
                    label = "Praca socjalna",
                },
                tabletVehicles = {
                    description = "Pokaż aplikację rejestru pojazdów.",
                    label = "Pojazdy",
                },
                tabletWarrants = {
                    description = "Pokaż aplikację nakazów.",
                    label = "Nakazy",
                },
                tabletWeapons = {
                    description = "Pokaż aplikację rejestru broni.",
                    label = "Broń",
                },
                tackleCuffKey = {
                    label = "Skucie powalonej osoby",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                tackleKey = {
                    label = "Powalenie",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                tackleReleaseKey = {
                    label = "Puszczenie powalonej osoby",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                vehicleRadarAlertCooldownMs = {
                    description = "Liczba milisekund przed możliwością wywołania kolejnego alarmu radaru.",
                    label = "Odnowienie alarmu",
                },
                vehicleRadarAllowedVehicleClasses = {
                    description = "Klasy pojazdów, którym wolno używać radaru.",
                    label = "Dozwolone klasy pojazdów",
                },
                vehicleRadarAutoFastLock = {
                    description = "Automatycznie oznaczaj bardzo szybkie cele w radarze.",
                    label = "Automatyczna szybka blokada",
                },
                vehicleRadarAutoFastLockThreshold = {
                    description = "Próg prędkości używany dla automatycznej szybkiej blokady.",
                    label = "Próg szybkiej blokady",
                },
                vehicleRadarDecreaseLimitKey = {
                    description = "Mapowanie klawisza używane do zmniejszania limitu prędkości radaru.",
                    label = "Klawisz zmniejszania limitu",
                },
                vehicleRadarDefaultLimit = {
                    description = "Domyślny limit prędkości używany przez radar pojazdu.",
                    label = "Domyślny limit radaru",
                },
                vehicleRadarEnabled = {
                    description = "Włącz radar pojazdu patrolowego.",
                    label = "Radar pojazdu",
                },
                vehicleRadarIncreaseLimitKey = {
                    description = "Mapowanie klawisza używane do zwiększania limitu prędkości radaru.",
                    label = "Klawisz zwiększania limitu",
                },
                vehicleRadarLimitStep = {
                    description = "Wartość zmieniana przy każdej regulacji limitu radaru.",
                    label = "Krok limitu",
                },
                vehicleRadarLockFrontKey = {
                    description = "Mapowanie klawisza używane do blokowania przedniego celu radaru.",
                    label = "Klawisz blokady przedniej",
                },
                vehicleRadarLockRearKey = {
                    description = "Mapowanie klawisza używane do blokowania tylnego celu radaru.",
                    label = "Klawisz blokady tylnej",
                },
                vehicleRadarMaxLimit = {
                    description = "Maksymalny limit prędkości dozwolony w radarze pojazdu.",
                    label = "Maksymalny limit radaru",
                },
                vehicleRadarMaxPitchDeg = {
                    description = "Maksymalne pochylenie dozwolone dla namierzania radarem.",
                    label = "Maksymalne stopnie pochylenia",
                },
                vehicleRadarMinLimit = {
                    description = "Minimalny limit prędkości dozwolony w radarze pojazdu.",
                    label = "Minimalny limit radaru",
                },
                vehicleRadarMinTargetSpeed = {
                    description = "Minimalna prędkość, zanim radar uzna cel za ważny.",
                    label = "Minimalna prędkość celu",
                },
                vehicleRadarModeFrontKey = {
                    description = "Mapowanie klawisza używane do przełączania przedniego trybu radaru.",
                    label = "Klawisz trybu przedniego",
                },
                vehicleRadarModeRearKey = {
                    description = "Mapowanie klawisza używane do przełączania tylnego trybu radaru.",
                    label = "Klawisz trybu tylnego",
                },
                vehicleRadarMovingScanIntervalMs = {
                    description = "Liczba milisekund między skanowaniami radaru, gdy pojazd patrolowy jest w ruchu.",
                    label = "Interwał skanowania w ruchu",
                },
                vehicleRadarPassengerControl = {
                    description = "Zezwól pasażerom na sterowanie radarem pojazdu.",
                    label = "Kontrola pasażera",
                },
                vehicleRadarPassengerEnabled = {
                    description = "Zezwól pasażerom na przeglądanie lustrzanych danych radaru.",
                    label = "Lustro dla pasażera",
                },
                vehicleRadarPassengerSyncIntervalMs = {
                    description = "Liczba milisekund między aktualizacjami synchronizacji radaru dla pasażerów.",
                    label = "Interwał synchronizacji pasażera",
                },
                vehicleRadarProjectionThreshold = {
                    description = "Próg projekcji używany podczas oceny celów radaru.",
                    label = "Próg projekcji",
                },
                vehicleRadarRequireLineOfSight = {
                    description = "Wymagaj czystej linii wzroku przed zablokowaniem celu przez radar.",
                    label = "Wymagaj linii wzroku",
                },
                vehicleRadarRequireOnDuty = {
                    description = "Wymagaj stanu służby przed użyciem radaru pojazdu.",
                    label = "Radar wymaga służby",
                },
                vehicleRadarScanIntervalMs = {
                    description = "Liczba milisekund między skanowaniami radaru w stanie stacjonarnym.",
                    label = "Interwał skanowania",
                },
                vehicleRadarScanRadius = {
                    description = "Promień skanowania radaru pojazdu.",
                    label = "Promień skanowania",
                },
                vehicleRadarToggleKey = {
                    description = "Mapowanie klawisza używane do włączania/wyłączania radaru pojazdu.",
                    label = "Klawisz przełączania",
                },
                vehicleRadarUseMph = {
                    description = "Wyświetlaj wartości prędkości radaru w MPH.",
                    label = "Radar używa MPH",
                },
                vehicleRadarVehiclePoolRefreshMs = {
                    description = "Liczba milisekund między odświeżeniami puli pobliskich pojazdów.",
                    label = "Odświeżanie puli pojazdów",
                },
                vehicleRadarXmitFrontKey = {
                    description = "Mapowanie klawisza używane dla przedniego XMIT/HOLD radaru.",
                    label = "Klawisz XMIT przedni",
                },
                vehicleRadarXmitRearKey = {
                    description = "Mapowanie klawisza używane dla tylnego XMIT/HOLD radaru.",
                    label = "Klawisz XMIT tylny",
                },
                wheelClampConsumeItem = {
                    description = "Usuń przedmiot blokady koła po założeniu.",
                    label = "Zużyj przedmiot blokady",
                },
                wheelClampEnabled = {
                    description = "Włącz akcję blokady koła.",
                    label = "Blokada koła",
                },
                wheelClampItem = {
                    description = "Przedmiot z ekwipunku używany do zakładania blokady koła.",
                    label = "Przedmiot blokady",
                },
                wheelClampPropModel = {
                    description = "Model rekwizytu używany dla założonej blokady koła.",
                    label = "Model rekwizytu blokady",
                },
                wheelClampRequireItem = {
                    description = "Wymagaj skonfigurowanego przedmiotu blokady koła. Zachowaj włączone, gdy tryb użycia blokady jest ustawiony na Ekwipunek lub Oba.",
                    label = "Blokada wymaga przedmiotu",
                },
                wheelClampRequireOnDuty = {
                    description = "Wymagaj stanu służby przed założeniem blokady koła.",
                    label = "Blokada wymaga służby",
                },
                wheelClampTyreDistance = {
                    description = "Maksymalna odległość do opony przy zakładaniu lub spawaniu blokady.",
                    label = "Odległość do opony",
                },
                wheelClampUseItem = {
                    description = "Użyj menu radialnego, ekwipunku lub obu do zakładania blokady koła. Ekwipunek lub Oba powinny być połączone z opcją Blokada wymaga przedmiotu.",
                    label = "Tryb użycia blokady",
                    options = {
                        both = "Oba",
                        inventory = "Ekwipunek",
                        radial = "Menu radialne",
                    },
                },
                wheelClampVehicleDistance = {
                    description = "Maksymalna odległość do docelowego pojazdu przy zakładaniu blokady.",
                    label = "Odległość do pojazdu",
                },
                wheelClampWeldBurstTyre = {
                    description = "Przebij oponę po zespawaniu blokady.",
                    label = "Przebij oponę",
                },
                wheelClampWeldDurationMs = {
                    description = "Liczba milisekund wymagana do usunięcia blokady przez spawanie.",
                    label = "Czas spawania",
                },
                wheelClampWeldEnabled = {
                    description = "Zezwól na usuwanie blokad koła za pomocą spawarki.",
                    label = "Spawanie blokady",
                },
                wheelClampWeldItem = {
                    description = "Przedmiot z ekwipunku wymagany do spawania blokady.",
                    label = "Przedmiot spawarki",
                },
                wheelClampWeldMinigame = {
                    description = "Wymagaj minigry spawania blokady przed zakończeniem usuwania.",
                    label = "Minigra spawania",
                },
                ziptiesConsumeItem = {
                    description = "Usuń przedmiot taśmy ZIP po założeniu.",
                    label = "Zużyj taśmy ZIP",
                },
                ziptiesCutterConsumeItem = {
                    description = "Usuń przedmiot przecinaka po przecięciu taśm ZIP.",
                    label = "Zużyj przecinak",
                },
                ziptiesCutterEnabled = {
                    description = "Zezwól na usuwanie taśm ZIP za pomocą przecinaka do drutu.",
                    label = "Przecinak do taśm ZIP",
                },
                ziptiesCutterItem = {
                    description = "Przedmiot z ekwipunku używany do przecinania taśm ZIP.",
                    label = "Przedmiot przecinaka",
                },
                ziptiesEnabled = {
                    description = "Włącz akcje taśm ZIP.",
                    label = "Taśmy ZIP",
                },
                ziptiesItem = {
                    description = "Przedmiot z ekwipunku używany do akcji taśm ZIP.",
                    label = "Przedmiot taśmy ZIP",
                },
                ziptiesRequireHandsUp = {
                    description = "Wymagaj stanu rąk do góry przed założeniem taśm ZIP.",
                    label = "Taśmy ZIP wymagają rąk do góry",
                },
                ziptiesRequireItem = {
                    description = "Wymagaj skonfigurowanego przedmiotu taśmy ZIP.",
                    label = "Taśmy ZIP wymagają przedmiotu",
                },
                ziptiesReturnOnRemove = {
                    description = "Zwróć przedmiot taśmy ZIP po zdjęciu.",
                    label = "Zwróć taśmy ZIP",
                },
                evidenceGsrDurationSeconds = {
                    description = "Pozostałości wystrzału w sekundach pozostają na rękach gracza.",
                    label = "Czas trwania GSR",
                },
                evidenceGsrGlovesProtectHands = {
                    description = "Zapobiegnij GSR przed zastosowaniem kiedy strzelec nosi rękawice.",
                    label = "Rękawiczki chronią ręce",
                },
                evidenceGsrIgnoredWeapons = {
                    description = "Broń, która nie stosuje pozostałości postrzału.",
                    label = "Ignorowana broń",
                },
                evidenceGsrWashCheckIntervalMs = {
                    description = "Milisekundy pomiędzy kontrolami czystości wody/wioru, podczas gdy jest aktywny GSR.",
                    label = "Odstęp kontroli mycia",
                },
                evidenceGsrWashInRain = {
                    description = "Pozwól deszczowi usunąć pozostałości postrzałowe.",
                    label = "Myć w deszczu",
                },
                evidenceGsrWashInWater = {
                    description = "Pozwólcie wodzie usunąć pozostałości postrzałowe.",
                    label = "Myć się w wodzie",
                },
                fakePlateHeliDisplay = {
                    label = "Helikam pokazuje fałszywy talerz.",
                    description = "Wyświetla fałszywe tablice w kamerie helikoptera.",
                },
                fakePlateNormalToolsDisplay = {
                    label = "Normalne narzędzia pokazują fałszywe płyty",
                    description = "Wyświetla fałszywe tablice w standardowych narzędziach policji.",
                },
                fakePlateRadarDisplay = {
                    label = "Radar pokazuje fałszywą tablicę.",
                    description = "Wyświetla fałszywą tablicę na radarze.",
                },
                fakePlateRecognitionEnabled = {
                    description = "Pozwól policji przeczytać wspólną fałszywą torbę.",
                    label = "Poznaj fałszywe tablice",
                },
                fakePlateRecognitionStateBagKey = {
                    description = "Klucz podmiotu pojazdu statebag opublikowany przez Mechanicjob.",
                    label = "Klucz Statebag",
                },
                fakePlateSpeedCamDisplay = {
                    label = "Speedcam pokazuje fałszywy talerz",
                    description = "Wyświetla fałszywą tablicę w raporcie radarowym.",
                },
                fakePlateVinAllowedGrades = {
                    description = "Zawód opcjonalny / lista dozwoleń klasy. Pozostaw pusty, aby umożliwić wszystkie stopnie dozwolonych zawodów.",
                    label = "VIN klasa",
                },
                fakePlateVinAllowedJobs = {
                    label = "VIN zawody",
                    description = "zawody dopuszczone do stosowania weryfikacji VIN.",
                },
                fakePlateVinAudit = {
                    label = "Kontrola VIN",
                    description = "Oszczędza VIN czeków do dziennika audytu.",
                },
                fakePlateVinCheckEnabled = {
                    label = "VIN sprawdzanie włączone",
                    description = "Włącza pojazd polecenie weryfikacyjne VIN.",
                },
                fakePlateVinCommand = {
                    label = "Polecenie VIN",
                    description = "Dowództwo używane do weryfikacji pojazdu VIN.",
                },
                fakePlateVinCooldown = {
                    label = "VIN chłodzenie",
                    description = "Opóźnienie między dwoma kontrolami VIN.",
                },
                fakePlateVinDistance = {
                    label = "VIN maksymalna odległość",
                    description = "Maksymalna odległość między urzędnikiem a pojazdem w celu sprawdzenia jego VIN.",
                },
                fakePlateVinIndicator = {
                    label = "Pokaż fałszywy wskaźnik",
                    description = "Wyświetla wskaźnik, gdy sprawa wykrywa fałszywą tablicę.",
                },
                fakePlateVinRequireDuty = {
                    label = "Wymagane cło",
                    description = "Wymaga, by oficer był na służbie, aby zweryfikował VIN.",
                },
                fakePlateVinRequireScanner = {
                    label = "Wymagaj elementu skanera",
                    description = "Wymaga skonfigurowanego obiektu skanerowego, aby zweryfikować VIN.",
                },
                fakePlateVinScannerItem = {
                    label = "Pozycja skanerowa",
                    description = "Pozycja inwentarza wymagana do weryfikacji VIN.",
                },
                jailRemoveJobOnJail = {
                    description = "Ustawić więźnia na bezrobotny, kiedy są w więzieniu.",
                    label = "Usunięcie zawodu w więzieniu",
                },
                jailRestoreOriginalJobOnRelease = {
                    description = "Przywrócić oryginalny zawód więźnia po zwolnieniu. Wyłącz, aby utrzymać ich bezrobotny.",
                    label = "Odwróć pierwotny zawód",
                },
                primaryColor = {
                    description = "Domyślny kolor grupy prac policyjnych.",
                    label = "Kolor podstawowy",
                },
                speedCamAdvancedAllowFakePlateApproval = {
                    description = "Pozwolić recenzentom na rachunek zarejestrowanego właściciela, nawet gdy złapana płyta jest oznakowana jako fałszywa lub klonowana.",
                    label = "Pozwól podejrzewać fałszywe tablice",
                },
                speedCamAdvancedPageSize = {
                    description = "Maksymalne przechwytywanie zwrócone na stronę tabletki.",
                    label = "Recenzja rozmiaru strony",
                },
                speedCamAdvancedRecognizedSides = {
                    description = "Boki pojazdu, których zdjęcia mogą być używane do rozpoznawania płyty. Użyj przedniej i/lub tylnej.",
                    itemLabel = "Bok",
                    label = "Uznane strony",
                },
                speedCamAdvancedRequireEvidence = {
                    description = "Pozwolić na homologację tylko po zakończeniu przesyłania zdjęć z kamery prędkości.",
                    label = "Wymagaj dowodów zdjęć",
                },
                speedCamAdvancedReviewPermission = {
                    description = "Bossmenu pozwolenie wymagane do zatwierdzenia lub odrzucenia przechwytywania. 18 jest Manage Billing.",
                    label = "Pozwolenie na przegląd ID",
                },
                speedCamAdvancedStoreUnregistered = {
                    description = "Zachować zachowanie, którego tablica nie jest obecna w zarejestrowanej bazie danych o pojazdach.",
                    label = "Przechowywać nierejestrowane pojazdy",
                },
                tabletSpeedcamReviews = {
                    description = "Pokaż aplikację recenzji zaawansowanej kamery prędkości przy włączeniu zaawansowanego trybu.",
                    label = "Szybkie przeglądy kamer",
                },
                tackleCommand = {
                    description = "Polecenie zarejestrowane do zwalczania najbliższej osoby. Wpisz nazwę polecenia bez skrzyżowania.",
                    label = "Polecenie Tackle",
                },
                tackleCuffCommand = {
                    description = "Polecenie zarejestrowane dla przyklejenia osoby aktualnie trzymanej po przyczepie. Wpisz nazwę polecenia bez skrzyżowania.",
                    label = "Polecenie mankietowe",
                },
                tackleCuffDescription = {
                    description = "Opis wyświetlany dla wiązań przyczepnych w menu FiveM.",
                    label = "Opis klawiatury tackle mankiety",
                },
                tackleDescription = {
                    description = "Opis wyświetlany dla wiążących narzędzi w menu przyłączeń klawiszowych FiveM.",
                    label = "Opis klucza Tackle",
                },
                tackleEnabled = {
                    description = "Aktywuj walkę z najbliższą osobą i trzymając ją na ziemi.",
                    label = "Powalenie",
                },
                tackleMaxDistance = {
                    description = "Maksymalna odległość do celu podczas uruchamiania tarczy.",
                    label = "Odległość do kąpieli",
                },
                tackleNeedsSprint = {
                    description = "Wymów, by oficer sprintował przed zwalczaniem osoby.",
                    label = "Tackle wymaga sprinting",
                },
                tackleReleaseCommand = {
                    description = "Polecenie zarejestrowane dla uwolnienia osoby aktualnie przechowywanej po obejściu. Wprowadź nazwę polecenia bez skrzyżowania.",
                    label = "Polecenie wydania Tackle",
                },
                tackleReleaseDescription = {
                    description = "Opis wyświetlany dla wiązania zwolnienia śrubowego w menu przyłączeń klawiszowych FiveM.",
                    label = "Opis klucza do uwolnienia Tackle",
                },
                tackleRequireOnDuty = {
                    description = "Wymagaj obowiązku, zanim oficer może zmierzyć z osobą.",
                    label = "Takkle wymaga obowiązku",
                },
                vehicleRadarCustomizeCommand = {
                    description = "Polecenie używane do otwierania lub zamykania edytora układu radarowego. Wprowadź nazwę polecenia bez skrzyżowania.",
                    label = "Polecenie układu radarowego",
                },
                vehicleRadarResetLayoutCommand = {
                    description = "Polecenie używane do przywrócenia domyślnego układu radarowego. Wprowadź nazwę polecenia bez skrzyżowania.",
                    label = "Przywróć polecenie układu radarowego",
                },
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
            locationDescriptions = {
                jail_public_blip = "Pozycja jest pobierana automatycznie z punktu odrodzenia w więzieniu, a jeśli go nie ustawiono, z pierwszego terminala więziennego.",
            },
            warnings = {
                cuffsConsumeRequiresItem = "Konsumpcyjne kajdanki nie mają wpływu, podczas gdy wymóg składki kajdanki jest wyłączony.",
                wheelClampUseItemRequiresItem = "Tryb użytkowania campu Inventoria lub Oba wymaga, aby Clamp pozostał włączony.",
                ziptiesConsumeRequiresItem = "Zębki konsumpcyjne nie mają wpływu, podczas gdy wymaganie zippie element jest wyłączone.",
            },
        },
    },
    JobConfiguratorImportFailed = "Nie udało się zaimportować wartości konfiguracyjnych.lua dla '%s': %s. .",
    JobConfiguratorImportHistoryFailed = "Importowi udało się, ale jego wpis do historii nie został zapisany.",
    JobConfiguratorImportNoData = "'%s' nie zawiera danych konfiguracji.lua importu.",
    JobConfiguratorImportSuccess = "Importowane wartości konfiguracyjne.lua dla '%s': %d prace, %d ustawienie, %d funkcja, oraz %d zastosowane odchylenia interakcyjne.",
    JobConfiguratorTitle = "konfigurator zawodów",
    JobConfiguratorUnknown = "Nieznany konfigurator zawodu.",
}
