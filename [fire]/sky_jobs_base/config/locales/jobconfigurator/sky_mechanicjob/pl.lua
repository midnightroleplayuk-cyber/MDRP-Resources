JobConfigLocales["sky_mechanicjob:pl"] = {
    Nui = {
        workshopConfig = {
            creatorSections = {
                mobileDyno = {
                    entryLabel = "Instalacja mobilnej hamowni",
                    entryPluralLabel = "Instalacje mobilnej hamowni",
                    label = "Instalacje mobilnej hamowni",
                },
                workshops = {
                    entryLabel = "Warsztaty",
                    entryPluralLabel = "Warsztaty",
                    label = "Warsztaty",
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
                crewCapacity = "Maksymalna liczba osób w jednostce. Wartość 0 oznacza nieograniczoną załogę.",
                joinLocked = "Uniemożliwia kolejnym osobom dołączenie po obsadzeniu jednostki.",
                minimumCrew = "Minimalna liczba osób w jednostkach wybranych dla tego planu reagowania.",
                poiId = "Stały identyfikator techniczny dostępny dla profili dyspozytorni także po zmianie nazwy punktu.",
                readyStatusCode = "Status FMS ustawiany, gdy zasób staje się gotowy do zadysponowania.",
                resourceType = "Klasyfikuje zasób operacyjny na potrzeby filtrów i koordynacji dyspozytorni.",
                respondingStatusCode = "Status FMS ustawiany, gdy zasób wyjeżdża do zdarzenia.",
                shortLabel = "Opcjonalna krótka etykieta na sześciu przyciskach pamięci kanałów radiowych.",
                stationId = "Przypisuje jednostkę do stacji skonfigurowanej w profilu dyspozytorni.",
                unitId = "Stały identyfikator techniczny zachowujący jednostkę po zmianie jej kryptonimu.",
                autoAlarm = "Natychmiast przydziela dopasowanie dostępnych jednostek, gdy powstanie incydent.",
                available = "Jednostki w tym stanie mogą być sugerowane i przypisane do nowego incydentu.",
                averageResponseSpeedKmh = "Oblicza wyświetlane szacunki przybycia z odległości prostej.",
                callsign = "Unikalny radiowy sygnał wywoławczy pokazany, gdy gracze pracownicy tej wirtualnej jednostki.",
                centerEnabled = "Umożliwia upoważnionym członkom służby obsługę centrali.",
                channelId = "Identyfikator kanału radiowego dla PMA Voice, SaltyChat i Yaca. Numeryczne identyfikatory takie jak 2500 pozostają niezmienione; PMA Voice mapuje identyfikatory tekstu do stabilnej liczby.",
                channelLabel = "Czytelna nazwa kanału pokazywana dyspozytorom i jednostkom.",
                defaultChannel = "Dyspozytorzy dołączają do tego kanału, rozpoczynając swoją zmianę. Jednostki łączą się ręcznie z zakładki Radio. Wybierz None, aby użyć domyślnej grupy job-.",
                emergencyAppEnabled = "Sprawia, że to zadanie jest wybieralne jako usługa publiczna w aplikacji telefonu awaryjnego.",
                enabled = "Udostępnia to zadanie aplikacji wysyłkowej i incydentów związanych z pracą krzyżową.",
                icon = "Wybierz ikonę dla tej kategorii jednostek w aplikacji Dispatch.",
                incidentAssessmentEnabled = "Pokazuje pytania medyczne i niebezpieczeństwa w pełnym spożyciu incydentu.",
                jobs = "Dodatkowe nazwy zadań, które otrzymują incydenty używając tego słowa kluczowego.",
                noUnitFallback = "Bez centrum lub zespołu, wysyła powiadomienie Sky do wszystkich członków na służbie.",
                radius = "Maksymalna odległość w metrach, na której można usłyszeć ogłoszenie stacji.",
                requirements = "Zapotrzebowanie na odpowiedź jako typ: pary COUNT, na przykład PATROL: 2, CRIME: 1.",
                statusCode = "Numeryczny status FMS pokazany na palmtopie.",
                statusLabel = "Znaczenie statusu FMS dla dyspozytorów i jednostek.",
                vehicleType = "Musi pasować do kodu typu pojazdu skonfigurowanego w poprzedniej podsekcji.",
                vehicleTypeCode = "Krótki kod jednostki stosowany w wymogach dotyczących odpowiedzi, na przykład PATROL, CRIME, EMS lub RESCUE.",
                vehicleTypeLabel = "Czytelna nazwa tej kategorii jednostek.",
            },
            dispatchFields = {
                crewCapacity = "Pojemność załogi",
                joinLocked = "Zablokuj dołączanie załogi",
                minimumCrew = "Minimalna załoga",
                poiId = "Stały identyfikator punktu POI",
                readyStatusCode = "Kod statusu gotowości",
                resourceType = "Typ zasobu",
                respondingStatusCode = "Kod statusu wyjazdu",
                shortLabel = "Etykieta pamięci radia",
                stationId = "Identyfikator stacji",
                unitId = "Stały identyfikator jednostki",
                address = "Adres",
                autoAlarm = "Automatyczny alarm",
                available = "Dostępne do wysyłki",
                averageResponseSpeedKmh = "Szacowana prędkość reakcji (km / h)",
                callsign = "Znak wywoławczy",
                category = "Kategoria",
                centerEnabled = "Włącz centrum wysyłki",
                channelId = "Identyfikator kanału",
                code = "Kod",
                defaultChannel = "Domyślny kanał radiowy",
                emergencyAppEnabled = "Pokaż w aplikacji awaryjnej",
                enabled = "Włącz wysyłkę",
                icon = "Ikona",
                incidentAssessmentEnabled = "Włącz ocenę sytuacji wyjątkowej",
                jobs = "Miejsca pracy docelowe (oddzielone przecinkami)",
                keywordCode = "Kod słów kluczowych",
                label = "Etykieta",
                name = "Nazwa",
                noUnitFallback = "Informuj pracowników na służbie bez jednostek",
                noneChannel = "Domyślny brak / grupa",
                note = "Uwaga",
                phone = "Telefon",
                radius = "Promień ogłoszenia",
                requirements = "Wymagane jednostki (na przykład PATROL: 2, CRIME: 1)",
                type = "Typ",
                vehicleType = "Typ jednostki odpowiedzi",
            },
            dispatchNavigation = {
                summary = {
                    reporters = "Znani zgłaszający",
                    channels = "Kanały radiowe",
                    plans = "Plany reagowania",
                    statuses = "Dostępne statusy FMS",
                    units = "Jednostki wirtualne",
                },
                active = "Dyspozytornia aktywna",
                description = "Skonfiguruj przyjmowanie zgłoszeń alarmowych, łączność radiową, jednostki, plany reagowania, lokalizacje i dane zgłaszających dla tej pracy.",
                inactive = "Dyspozytornia wyłączona",
                steps = {
                    accessText = "Włącz dyspozytornię i zdecyduj, czy pracownicy tej pracy mogą pełnić w niej dyżur.",
                    accessTitle = "Dostęp i przyjmowanie zgłoszeń",
                    fleetText = "Skonfiguruj kanały, kody statusu FMS, typy pojazdów i kryptonimy.",
                    fleetTitle = "Łączność i flota",
                    responseText = "Dokończ konfigurację słowami kluczowymi, wymaganiami reagowania i punktami zainteresowania.",
                    responseTitle = "Plany reagowania",
                },
                title = "Dyspozytornia",
                warnings = {
                    channels = "Nie skonfigurowano własnych kanałów radiowych; zostanie użyty kanał zapasowy grupy prac.",
                    defaultChannel = "Wybrany kanał domyślny już nie istnieje.",
                    disabled = "Dyspozytornia jest wyłączona dla tej pracy.",
                    statuses = "Co najmniej jeden status FMS musi być dostępny, aby można było alarmować jednostki.",
                },
            },
            extensionDescriptions = {
                dispatchReporters = "Zarządza nazwami zgłaszających, numerami zwrotnymi i notatkami dyspozytorni dla tej pracy.",
                dispatchChannels = "Określa kanały radiowe, do których mogą dołączyć jednostki i centra wysyłkowe.",
                dispatchKeywords = "Określa słowa kluczowe zdarzeń, wymagane numery pojazdów, miejsca pracy i opcjonalne automatyczne alarmowanie.",
                dispatchPois = "Stacje magazynowe i wspólne lokalizacje dla formularzy zdarzeń i ogłoszeń stacji opartych na pozycji.",
                dispatchStatusCodes = "Konfiguruje etykiety statusu FMS i które statusy liczą się jako dostępne dla nowych incydentów.",
                dispatchVehicleTypes = "Określa kategorie jednostek stosowane w planach reagowania, takie jak Patrol, Wydział Przestępczości, EMS lub Rescue.",
                dispatchVehicles = "Określa wirtualne pojazdy wysyłające, które mogą być obsługiwane z dowolnego miejsca bez konieczności posiadania pojazdu tarłowego.",
            },
            diagnosticsSettings = {
                enabledLabel = "Włącz diagnostykę pojazdów",
                enabledDescription = "Pozwala tej pracy otwierać diagnostykę pojazdów i naprawiać w niej części.",
            },
            extensions = {
                diagnosticsSettings = {
                    label = "Diagnostyka pojazdów",
                    description = "Skonfiguruj dostęp tej pracy do diagnostyki pojazdów.",
                },
                dispatchReporters = "Znani zgłaszający",
                invalidSelection = "Nieprawidłowy wybór: {value}",
                billingPrices = {
                    description = "Konfiguracja cen faktury dla wpisów historii konserwacji i naprawy. Klucz działania jest dopasowany do action_key, action_type, lub etykieta robocza.",
                    label = "Powody rozliczeń",
                },
                billingSettings = {
                    description = "Konfiguracja mechanicznego zachowania rachunków dla tego zawodu.",
                    label = "Faktury",
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
                partsDeliveryShop = "Sklep dostawy czesci",
                trainingSettings = {
                    description = "Konfiguracja dostępu do szkoleń, rejestracji, zatwierdzeń i planowania kursu dla tej pracy.",
                    label = "Ustawienia treningu",
                },
                tuningCostProfile = {
                    description = "Skonfiguruj koszty osiagow, wygladu, kol i opcji specjalnych dla tej pracy.",
                    label = "Ceny tuningu",
                },
            },
            features = {
                tuningFreeCamera = {
                    label = "Swobodna kamera w menu tuningu",
                    description = "Pozwala ukryć kursor spacją, aby swobodnie poruszać kamerą. Escape nadal zamyka menu.",
                },
                tuningCamera = {
                    description = "Automatycznie kieruje kamerę na wybraną część. Po wyłączeniu pozostaje zwykła kamera gry.",
                    label = "Automatyczna kamera tuningu",
                },
                jgMileage = {
                    description = "Używaj JG Vehicle Mileage, gdy jego zasób działa. W przeciwnym razie używaj przebiegu Sky. JG HUD konfiguruje się osobno.",
                    label = "JG Mileage",
                },
                jgHud = {
                    description = "Wyświetlaj wybrany przebieg w JG HUD. Działa bez JG Vehicle Mileage; zainstaluj adapter HUD zgodnie z README.",
                    label = "JG HUD",
                },
                handlingEditor = {
                    description = "Włącza edytor administratora oraz automatyczne reguły dla tablic rejestracyjnych i modeli. Po wyłączeniu ponownie wyprowadź pojazdy z garażu, aby przywrócić wcześniej zastosowane wartości.",
                    label = "Edytor prowadzenia",
                },
                kuv = {
                    description = "Rozpocznij badanie techniczne",
                    label = "Badanie techniczne pojazdu",
                },
                mobileDyno = {
                    description = "Włącza mobilną hamownię, ekrany sterowania i wyników, sterownik wentylatorów oraz tablet.",
                    label = "Mobilna hamownia",
                },
                vehicleRegistration = {
                    description = "Zarejestruj / przerejestruj",
                    label = "Rejestracja pojazdu",
                },
                antiLag = {
                    description = "Aktywacja instalacji antylagowej i efektów wydechowych.",
                    label = "Anty- Lag",
                },
                brakeOverheating = {
                    description = "Aktywacja ustawionego ciepła hamulcowego, świecących dysków, krytycznych iskr i krótkiego hamulca.",
                    label = "Przegrzewanie hamulca",
                },
                carryItems = {
                    description = "Wymaga przenoszenia dostarczonych czesci przez warsztat.",
                    label = "Fizyczna obsluga czesci",
                },
                customHandling = {
                    description = "Aktywuj własny pojazd napędowy i regulacja.",
                    label = "Właściwe obsługiwanie",
                },
                electronicTuning = {
                    description = "Aktywuj trwałe ECU, opcje regulacji oświetlenia i pomocy kierowcy.",
                    label = "Elektroniczne dopasowanie",
                },
                instantTuning = {
                    description = "Pozwól na bezpośrednie tuningowanie w skonfigurowanych lokalizacjach publicznych.",
                    label = "Niezwłoczne dopasowanie",
                },
                mileageHud = {
                    description = "Pokazuje przebieg pojazdu podczas jazdy.",
                    label = "HUD przebiegu",
                },
                nitro = {
                    description = "Aktywuj instalację nitro i wykorzystanie pojazdu.",
                    label = "Nitro",
                },
                partsDelivery = {
                    description = "Wlacza zamowienia czesci warsztatowych i strefy dostaw.",
                    label = "Dostawa czesci",
                },
                selfServiceOrderNotifications = {
                    description = "Powiadomienie pracowników służbowych o stworzeniu nakazu samoobsługi.",
                    label = "Powiadomienia o zamówieniach na usługi pośrednictwa",
                },
                stance = {
                    description = "Pokaż modyfikacje Stance we wszystkich menuch dostosowywania i włącz element Stance Kit.",
                    label = "Ustawienie zawieszenia",
                },
                stanceWheelSize = {
                    description = "Pokaż, zapisz i zastosowaj regulacje rozmiaru koła w Stance.",
                    label = "Rozmiar koła stunkowego",
                },
                stanceWheelWidth = {
                    description = "Pokaż, zapisz i zastosowaj ustawienia szerokości koła w Stance.",
                    label = "Szerokość koła stunkowego",
                },
                subscriptions = {
                    description = "Aktywuj terminale abonamentowe warsztatów, zarządzanie i rabaty klientów.",
                    label = "Subskrypcje warsztatów",
                },
                twoStep = {
                    description = "Aktywacja dwustopniowej kontroli wyrzutów i efektów wydechowych.",
                    label = "Dwa kroki",
                },
                vehicleMaintenanceNotifications = {
                    description = "Powiadom właścicieli o osiągnięciu skonfigurowanego progu konserwacji.",
                    label = "Powiadomienia o utrzymaniu pojazdu",
                },
                wheelDamage = {
                    description = "Wlacza realistyczne uszkodzenia kol i naprawy.",
                    label = "Uszkodzenia kol",
                },
                workshopLift = {
                    description = "Wlacza uzywalne punkty podnosnika w warsztatach.",
                    label = "Podnosnik warsztatowy",
                },
            },
            locationDescriptions = {
                vehicle_registry = "Ustaw punkt na stanowisku kontrolnym warsztatu. Pojazd musi znajdować się w ustawionym zasięgu, aby przeprowadzić badanie techniczne i rejestrację.",
            },
            locationTypes = {
                mobile_dyno_monitor = {
                    description = "Pozycja monitora wyników.",
                    label = "Monitor wyników",
                },
                mobile_dyno_station = {
                    description = "Pozycja mobilnej hamowni.",
                    label = "Stanowisko mobilnej hamowni",
                },
                vehicle_registry = "Punkt badań technicznych i rejestracji",
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
            settingGroups = {
                diagnostics = {
                    label = "Diagnostyka",
                },
                keybinds = {
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                    label = "Klawisze",
                },
                safety = {
                    label = "Walidacja i bezpieczeństwo",
                },
                antiExploit = {
                    label = "Przeciwdziałanie eksploatacji",
                },
                coach = {
                    label = "Trener telemetrii",
                },
                cooldownMultipliers = {
                    label = "Mnożniki chłodzenia",
                },
                crashFalloff = {
                    label = "Padanie krachów",
                },
                criticalEngine = {
                    label = "Złamany silnik",
                },
                deformation = {
                    label = "Deformacja",
                },
                fade = {
                    label = "Spadek skuteczności hamulców",
                },
                features = {
                    label = "Funkcje",
                },
                format = {
                    label = "Format",
                },
                frontalImpact = {
                    label = "Ciężkie uderzenie z przodu",
                },
                general = {
                    label = "Ogólne",
                },
                heatMultipliers = {
                    label = "Mnożniki nagrzewania",
                },
                illegalMarket = {
                    label = "Nielegalny rynek",
                },
                integration = {
                    label = "Integracja",
                },
                items = {
                    label = "Przedmioty",
                },
                lifetime = {
                    label = "Życie",
                },
                limits = {
                    label = "Ograniczenia przechowywania",
                },
                repairRestore = {
                    label = "Naprawa przywrócenia",
                },
                risk = {
                    label = "Ryzyko",
                },
                rules = {
                    label = "Zasady",
                },
                stages = {
                    label = "Etapy przegrzania",
                },
                tyreRepair = {
                    label = "Naprawa opony",
                },
                visuals = {
                    label = "Efekty wizualne",
                },
            },
            settingSections = {
                electronicTuning = "Oprogramowanie silnika ECU",
                handlingEditor = "Edytor prowadzenia",
                mobileDyno = "Mobilna hamownia",
                vehicleRegistry = "Dokumenty pojazdu",
                advancedPricing = "Zaawansowane ceny",
                brakeOverheating = "Przegrzewanie hamulca",
                carryItems = "Przenieś elementy",
                fakePlates = "Płyty fałszywe",
                firejobVehicleFires = "Ognia pojazdu",
                general = "Ogólny",
                instantTuning = "Niezwłoczne dopasowanie",
                maintenanceNotifications = "Powiadomienia konserwacyjne",
                mileageHud = "HUD przebiegu",
                oilLeaks = "Wycieczki pojazdowe",
                partsTheft = "Części kradzież",
                subscriptions = "Subskrypcje",
                tuning = "Dostosowanie",
                vehicleCare = "Opieka nad pojazdem",
                wear = "Zużycie",
                wheelDamage = "Uszkodzenia kol",
            },
            settingSubsectionGroups = {
                handlingAdditional = "Dodatkowe",
                handlingAir = "Powietrze",
                handlingGeneral = "Ogólne",
                handlingRoad = "Droga",
                handlingWater = "Woda",
            },
            settingSubsections = {
                mechanicHotkeys = "Klawisze",
                database = "Baza danych",
                handlingEditorGeneral = "Ustawienia edytora",
                handlingMaximumCBikeHandlingData = "Motocykl",
                handlingMaximumCBoatHandlingData = "Łódź",
                handlingMaximumCCarHandlingData = "Samochód",
                handlingMaximumCFlyingHandlingData = "Samolot",
                handlingMaximumCHandlingData = "Baza pojazdu",
                handlingMaximumCSeaPlaneHandlingData = "Wodnosamolot",
                handlingMaximumCSpecialFlightHandlingData = "Lot specjalny",
                handlingMaximumCSubmarineHandlingData = "Okręt podwodny",
                handlingMaximumCTrailerHandlingData = "Przyczepa",
                handlingMaximumCVehicleWeaponHandlingData = "Broń pojazdu",
                keybinds = "Klawisze",
                operation = "Obsługa",
                placementRules = "Zasady rozmieszczenia",
                testFlow = "Przebieg testu",
                tuning = "Opcje natychmiastowego tuningu",
            },
            settings = {
                instantTuningRepairEnabled = {
                    label = "Naprawa pojazdu",
                    description = "Udostępnij naprawę pojazdów w punktach natychmiastowego tuningu.",
                },
                instantTuningRepairPrice = {
                    label = "Cena naprawy",
                    description = "Stała cena naprawy bez mnożnika cen tuningu.",
                },
                instantTuningWashEnabled = {
                    label = "Mycie pojazdu",
                    description = "Udostępnij mycie pojazdów w punktach natychmiastowego tuningu.",
                },
                instantTuningWashPrice = {
                    label = "Cena mycia",
                    description = "Stała cena mycia bez mnożnika cen tuningu.",
                },
                vehiclePriceSource = {
                    label = "Źródło cen pojazdów",
                    description = "Automatycznie: SQL w ESX; katalog pojazdów w QBCore/Qbox. Baza danych: skonfigurowana tabela SQL w każdym frameworku.",
                    options = {
                        auto = "Automatycznie (framework)",
                        database = "Baza danych",
                    },
                },
                vehiclePriceTable = {
                    label = "Tabela cen pojazdów",
                    description = "Tabela z cenami zakupu, np. dealership_vehicles (JG).",
                },
                vehiclePriceModelColumn = {
                    label = "Kolumna nazwy spawnu",
                    description = "Kolumna nazw spawnu, np. spawn_code (JG), a nie nazwy wyświetlanej.",
                },
                vehiclePricePriceColumn = {
                    label = "Kolumna ceny",
                    description = "Kolumna liczbowych cen zakupu, np. price.",
                },
                vehiclePriceHashColumn = {
                    label = "Kolumna hasha modelu (opcjonalna)",
                    description = "Opcjonalna kolumna liczbowych hashy, np. hashkey (JG). Pozostaw pustą, aby obliczać hashe z nazw spawnu.",
                },
                handlingEditorFieldMaximum = {
                    description = "Nieprzekraczalna wartość maksymalna akceptowana przez edytor dla tego pola prowadzenia.",
                },
                handlingEditorFocusKey = {
                    label = "Powrót do edytora prowadzenia",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                handlingEditorPayloadWarningBytes = {
                    description = "Liczba zakodowanych bajtów, po której żądanie, odpowiedź lub migawka edytora jest zgłaszana jako duża.",
                    label = "Próg dużych danych",
                },
                handlingEditorPerformanceChecksEnabled = {
                    description = "Mierzy operacje edytora i ostrzega przez Sky.Debug po przekroczeniu skonfigurowanych limitów.",
                    label = "Kontrole wydajności",
                },
                handlingEditorPerformanceSummaryIntervalMs = {
                    description = "Liczba milisekund między zbiorczymi podsumowaniami wydajności przy włączonym szczegółowym logowaniu.",
                    label = "Interwał podsumowania",
                },
                handlingEditorPerformanceWarningMs = {
                    description = "Liczba milisekund, po której operacja edytora jest zgłaszana jako wolna.",
                    label = "Próg wolnej operacji",
                },
                handlingEditorSliderMaximumDeviationPercent = {
                    description = "Maksymalny procent, o jaki suwak liczbowy może przesunąć się powyżej lub poniżej odczytanej wartości bazowej pojazdu. Bezpośrednie wpisywanie i import XML pozostają bezstratne. Maksimum pola inne niż domyślne zastępuje górną granicę suwaka.",
                    label = "Maksymalne odchylenie suwaka",
                },
                mechanicCatalyticConverterCATALYTICACTIONCONTROL = {
                    label = "Kradzież katalizatora · Sterowanie 38",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicCatalyticConverterCATALYTICCANCELCONTROL = {
                    label = "Kradzież katalizatora · Sterowanie 73",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicDynoControl172 = {
                    label = "Hamownia · Sterowanie 172",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicDynoControl173 = {
                    label = "Hamownia · Sterowanie 173",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicDynoControl174 = {
                    label = "Hamownia · Sterowanie 174",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicDynoControl175 = {
                    label = "Hamownia · Sterowanie 175",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicDynoControl177 = {
                    label = "Hamownia · Sterowanie 177",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicDynoControl38 = {
                    label = "Hamownia · Sterowanie 38",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicDynoControl45 = {
                    label = "Hamownia · Sterowanie 45",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicDynoControl47 = {
                    label = "Hamownia · Sterowanie 47",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicSprayPaintControl200 = {
                    label = "Lakierowanie · Sterowanie 200",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicSprayPaintControl202 = {
                    label = "Lakierowanie · Sterowanie 202",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicVehicleCareControl200 = {
                    label = "Pielęgnacja pojazdu · Sterowanie 200",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicVehicleCareControl202 = {
                    label = "Pielęgnacja pojazdu · Sterowanie 202",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicVehiclePushINPUTCONTEXT = {
                    label = "Pchanie pojazdu · Sterowanie 38",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicVehiclePushINPUTMOVEDOWN = {
                    label = "Pchanie pojazdu · Sterowanie 33",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicVehiclePushINPUTMOVELEFT = {
                    label = "Pchanie pojazdu · Sterowanie 34",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicVehiclePushINPUTMOVERIGHT = {
                    label = "Pchanie pojazdu · Sterowanie 35",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicVehiclePushINPUTMOVEUP = {
                    label = "Pchanie pojazdu · Sterowanie 32",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicVehiclePushINPUTSPRINT = {
                    label = "Pchanie pojazdu · Sterowanie 21",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicWheelChangeControl200 = {
                    label = "Wymiana koła · Sterowanie 200",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicWheelChangeControl202 = {
                    label = "Wymiana koła · Sterowanie 202",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicWheelChangeControl22 = {
                    label = "Wymiana koła · Sterowanie 22",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicWheelTheftWHEELTHEFTACTIONCONTROL = {
                    label = "Kradzież koła · Sterowanie 38",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mechanicWheelTheftWHEELTHEFTCANCELCONTROL = {
                    label = "Kradzież koła · Sterowanie 73",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                mobileDynoConsumeItem = {
                    description = "Usuń jeden przedmiot po pomyślnym ustawieniu.",
                    label = "Zużyj przedmiot",
                },
                mobileDynoCooldownMs = {
                    label = "Czas chłodzenia",
                },
                mobileDynoCountdownMs = {
                    label = "Odliczanie startu",
                },
                mobileDynoDuiDistance = {
                    label = "Odległość renderowania panelu",
                },
                mobileDynoFanInteractionDistance = {
                    label = "Zasięg sterownika wentylatorów",
                    description = "Odległość w metrach do użytku fizycznego przełącznika między wentylatorami chłodzącymi.",
                },
                mobileDynoFullLoadDurationMs = {
                    label = "Czas pełnego obciążenia",
                    description = "Milisekundy spędzone na stałym pełnym obciążeniu w profilach obejmujących fazę pełnego obciążenia.",
                },
                mobileDynoHistoryLimit = {
                    label = "Limit historii",
                },
                mobileDynoInteractionDistance = {
                    label = "Odległość interakcji",
                },
                mobileDynoItemUseEnabled = {
                    description = "Zezwalaj na ustawianie hamowni i monitora przy użyciu przedmiotów.",
                    label = "Ustawianie przedmiotem",
                },
                mobileDynoMaxActiveSessions = {
                    label = "Limit aktywnych sesji",
                },
                mobileDynoMaxVehicleDistance = {
                    label = "Odległość wykrywania pojazdu",
                },
                mobileDynoMonitorItem = {
                    description = "Przedmiot ekwipunku do ustawiania monitora wyników.",
                    label = "Przedmiot monitora",
                },
                mobileDynoPersistItems = {
                    description = "Zachowaj nowo ustawiony sprzęt po ponownym uruchomieniu serwera.",
                    label = "Zapisuj ustawienia sprzętu",
                },
                mobileDynoPickupDistance = {
                    description = "Maksymalna odległość w metrach do zbierania sprzętu.",
                    label = "Odległość zbierania",
                },
                mobileDynoPlacementMaxHeightSpread = {
                    label = "Maksymalna różnica wysokości",
                    description = "Maksymalna odmiana wysokości naziemnej w metrach przyjęta na wszystkich sondach śladowych dyno.",
                },
                mobileDynoPlacementMaxSlopeDegrees = {
                    label = "Maksymalne nachylenie",
                    description = "Maksymalny nachylenie naziemne w stopniach przyjętych przez ślad dyno.",
                },
                mobileDynoRequireOnDuty = {
                    description = "Mechanik musi być na służbie, aby ustawiać i obsługiwać sprzęt.",
                    label = "Wymagana służba",
                },
                mobileDynoResultDuiDistance = {
                    label = "Zasięg ekranu wyników",
                    description = "Maksymalna odległość w metrach, na których odtwarzany jest oddzielny monitor wyników.",
                },
                mobileDynoReturnItem = {
                    description = "Zwróć zużyty przedmiot podczas zbierania sprzętu.",
                    label = "Zwróć przedmiot",
                },
                mobileDynoStationItem = {
                    description = "Przedmiot ekwipunku do ustawiania hamowni.",
                    label = "Przedmiot hamowni",
                },
                mobileDynoTabletDistance = {
                    description = "Maksymalna odległość od hamowni w metrach do sterowania tabletem i prowadzenia testów.",
                    label = "Zasięg tabletu",
                },
                nitroActivationKey = {
                    label = "Przytrzymaj nitro",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                registryBikeChecks = {
                    description = "Punkty kontroli motocykli",
                    label = "Punkty kontroli motocykli",
                },
                registryCarChecks = {
                    description = "Punkty kontroli samochodów",
                    label = "Punkty kontroli samochodów",
                },
                registryDistance = {
                    description = "Odległość serwisu (metry)",
                    label = "Odległość serwisu (metry)",
                },
                registryKuvFee = {
                    description = "Opłata Badanie techniczne pojazdu",
                    label = "Opłata Badanie techniczne pojazdu",
                },
                registryKuvValidityDays = {
                    description = "Ważność nowych badań w czasie rzeczywistym. Domyślnie: 30 dni. Obecne terminy pozostają bez zmian.",
                    label = "Ważność badania (rzeczywiste dni)",
                },
                registryKuvWarningDays = {
                    description = "Okres ostrzeżenia (dni)",
                    label = "Okres ostrzeżenia (dni)",
                },
                registryRegistrationFee = {
                    description = "Opłata rejestracyjna",
                    label = "Opłata rejestracyjna",
                },
                registryReinspectionFee = {
                    description = "Opłata za ponowny przegląd",
                    label = "Opłata za ponowny przegląd",
                },
                registryRequireKuv = {
                    description = "Wymagaj ważnego Badanie techniczne pojazdu do rejestracji",
                    label = "Wymagaj ważnego Badanie techniczne pojazdu do rejestracji",
                },
                registrySessionSeconds = {
                    description = "Czas potwierdzenia (sekundy)",
                    label = "Czas potwierdzenia (sekundy)",
                },
                registryTransferFee = {
                    description = "Opłata za przerejestrowanie",
                    label = "Opłata za przerejestrowanie",
                },
                registryVehicleTypes = {
                    description = "Dozwolone typy pojazdów",
                    label = "Dozwolone typy pojazdów",
                },
                tuningFocusKey = {
                    label = "Obsługa myszy w tuningu",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                addRevenueToSociety = {
                    description = "Depozyt zapłacił zamówienie tuningowe na konto zawodu tuningowe społeczeństwo.",
                    label = "Dochody z depozytów dla społeczeństwa",
                },
                advancedPricingAlwaysAvailableItemCategories = {
                    description = "Częściowe kategorie sklepów dostawczych, które pozostają swobodnie przydatne, a zaawansowane ceny są włączone. Dopasowywanie ignoruje osłony i spacje.",
                    itemLabel = "Kategoria",
                    label = "Zawsze dostępne kategorie",
                },
                advancedPricingAlwaysAvailableItemsEnabled = {
                    description = "Zachować skonfigurowane elementy sklepowe z wybranych kategorii dostępne bez porządku tuningu i ceny ich przez dynamiczny system dostawców.",
                    label = "Zawsze dostępne elementy sklepowe",
                },
                advancedPricingAnalyticsPeriodDays = {
                    description = "Liczba dni wykazana w analizie zysków tabletki.",
                    label = "Okres analizy",
                },
                advancedPricingCategoryRules = {
                    description = "Udział dostawców, margines, granice pracy i cen według kategorii regulacji.",
                    label = "Zasady kategorii",
                },
                advancedPricingDefaultMarginPercent = {
                    description = "Domyślny margines mechaniczny przed klasą i dostosowanie klasy.",
                    label = "Domyślny margines",
                },
                advancedPricingDifficultyRules = {
                    description = "Dodatkowe koszty pracy dla każdej trudności regulacyjnej.",
                    label = "Przepisy dotyczące trudności",
                },
                advancedPricingEnabled = {
                    description = "Ponowne obliczenie cen tuningowych na serwerze i, gdy doręczenie części jest włączone, wymaga zakupu części dynastii dla ich specjalnego zamówienia.",
                    label = "Aktywacja zaawansowanych cen",
                },
                advancedPricingInventoryBaseStock = {
                    description = "Normalne wirtualne zapasy dla każdego dostawcy.",
                    label = "Zapasy podstawowe",
                },
                advancedPricingInventoryDemandDecayPerDay = {
                    description = "Punkty popytu usunięte w ciągu upływu dnia.",
                    label = "Codzienne rozpady popytu",
                },
                advancedPricingInventoryDemandMarkupPerUnitPercent = {
                    description = "Oznaczenie dostawców dodano dla każdego punktu popytu.",
                    label = "Oznaczenie popytu na jednostkę",
                },
                advancedPricingInventoryEnabled = {
                    description = "Podnieś ceny dostawców, gdy zapasy wirtualne są niskie lub popyt jest wysoki.",
                    label = "Dynamiczny zapas dostawców",
                },
                advancedPricingInventoryLowStockMarkupPercent = {
                    description = "Maksymalna obniżka dostawców spowodowana niskim zapasem.",
                    label = "Oznaczenie o niskich zapasach",
                },
                advancedPricingInventoryLowStockThreshold = {
                    description = "Poziom zapasów poniżej poziomu, w którym zaczyna się niedobory cen.",
                    label = "Prog niskiego zapasu",
                },
                advancedPricingInventoryMaximumDemandMarkupPercent = {
                    description = "Górna granica popytu.",
                    label = "Maksymalne oznaczenie popytu",
                },
                advancedPricingInventoryRestockPerDay = {
                    description = "Jednostki wirtualne wypełnione w ciągu dnia, który upłynął.",
                    label = "Codzienne ponowne zapasy",
                },
                advancedPricingMaximumDiscountPercent = {
                    description = "Globalny pułap zniżkowy dla faktur mechanicznych.",
                    label = "Maksymalna zniżka",
                },
                advancedPricingMaximumMarginPercent = {
                    description = "Najwyższy dozwolony margines mechaniczny.",
                    label = "Maksymalny margines",
                },
                advancedPricingMaximumRetailPrice = {
                    description = "Globalna granica górnej ceny dla części regulacyjnej.",
                    label = "Maksymalna cena detaliczna",
                },
                advancedPricingMechanicGradeRules = {
                    description = "Oznaczenie, praca i granice zniżki według klasy mechanicznej.",
                    label = "Zasady klasy mechanicznej",
                },
                advancedPricingMinimumMarginPercent = {
                    description = "Najniższy dozwolony margines mechaniczny.",
                    label = "Minimalny margines",
                },
                advancedPricingMinimumRetailPrice = {
                    description = "Globalna granica niższej ceny dla części regulacyjnej.",
                    label = "Minimalna cena detaliczna",
                },
                advancedPricingPreviewCompactValue = {
                    description = "Wartość pojazdu użyta dla przykładu kompaktowego.",
                    label = "Wartość kompaktowego podglądu",
                },
                advancedPricingPreviewCostPercent = {
                    description = "Przykładowy odsetek kosztów tuningu używany w podglądie na żywo.",
                    label = "Wskaźnik regulacji podglądu",
                },
                advancedPricingPreviewSportsValue = {
                    description = "Wartość pojazdu używana dla przykładu sportowego.",
                    label = "Wartość podglądu sportowego",
                },
                advancedPricingPreviewSuperValue = {
                    description = "Wartość pojazdu używana dla przykładu supersamochodów.",
                    label = "Wartość podglądu super",
                },
                advancedPricingQuoteLifetimeMinutes = {
                    description = "Minuty przed ponownym obliczeniem niezapłaconej ceny.",
                    label = "Cytowanie dożywocia",
                },
                advancedPricingReturnRefundPercent = {
                    description = "Odsetek zwrotu dla części zamówionej zleceniem.",
                    label = "Refundacja zwrotu",
                },
                advancedPricingRoundingStep = {
                    description = "Zaokrągnij każdą linię zamówień dynastii na ten krok pieniężny.",
                    label = "Stopień zaokrąglania dostawców",
                },
                advancedPricingSupplierSharePercent = {
                    description = "Odsetek ceny części klienta pobierane przez Dynastia Auto Supply.",
                    label = "Udział dostawców",
                },
                advancedPricingTaxPercent = {
                    description = "Odsetek podatków przechowywany odrębnie w rachunku cenowym.",
                    label = "Podatek",
                },
                advancedPricingVehicleClassRules = {
                    description = "Dostosowanie marginesu i pracy o GTA klasie pojazdów.",
                    label = "Zasady klasy pojazdu",
                },
                brakeOverheatingCooldownBrakeUpgradeMultipliers = {
                    label = "Mnożniki upgradacji hamulca",
                },
                brakeOverheatingCooldownClassMultipliers = {
                    label = "Mnożniki klasy pojazdów",
                },
                brakeOverheatingCoolingDelayMs = {
                    description = "Opóźnienie w milisekundach po hamowaniu przed rozpoczęciem aktywnego chłodzenia.",
                    label = "Opóźnienie chłodzenia",
                },
                brakeOverheatingCoolingPerSecond = {
                    description = "Ciepło usuwane na sekundę podczas nieużycia hamulca.",
                    label = "Tempo chłodzenia",
                },
                brakeOverheatingCriticalThreshold = {
                    description = "Poziom ciepła, na którym mogą się rozpocząć iskry i krótkie hamulce.",
                    label = "Próg krytyczny",
                },
                brakeOverheatingFadeChancePerSecond = {
                    description = "Szansa od 0 do 1 w przypadku krótkiego odcięcia hamulcowego podczas hamowania przy gorącu krytycznym.",
                    label = "Szansa zniknięcia na sekundę",
                },
                brakeOverheatingFadeCooldownMs = {
                    label = "Zmniejszanie",
                },
                brakeOverheatingFadeMaximumDurationMs = {
                    label = "Maksymalny czas trwania znikania",
                },
                brakeOverheatingFadeMinimumDurationMs = {
                    label = "Minimalny czas trwania wycięcia",
                },
                brakeOverheatingHeatBrakeUpgradeMultipliers = {
                    label = "Mnożniki ciepła hamulca",
                },
                brakeOverheatingHeatClassMultipliers = {
                    label = "Mnożniki ciepła klasy pojazdu",
                },
                brakeOverheatingHeatGainPerSecond = {
                    description = "Ciepło bazowe uzyskane na sekundę podczas hamowania przy prędkości odniesienia.",
                    label = "Zyski z ciepła",
                },
                brakeOverheatingHotThreshold = {
                    label = "Próg gorący",
                },
                brakeOverheatingMinimumSpeedKmh = {
                    description = "Minimalna prędkość pojazdu w km/h przed hamowaniem tworzy ciepło.",
                    label = "Minimalna prędkość hamowania",
                },
                brakeOverheatingReferenceSpeedKmh = {
                    description = "Prędkość w km/h, przy której stosuje się skonfigurowane zyski ciepła podstawowego.",
                    label = "Prędkość odniesienia",
                },
                brakeOverheatingSparkMaximumIntervalMs = {
                    label = "Maksymalny odstęp iskrowy",
                },
                brakeOverheatingSparkMinimumIntervalMs = {
                    label = "Minimalny odstęp iskrowy",
                },
                brakeOverheatingVisualDistance = {
                    description = "Maksymalna odległość w metrach do świecenia i iskry.",
                    label = "Odległość wzrokowa",
                },
                brakeOverheatingWarmThreshold = {
                    label = "Ciepły próg",
                },
                carryItems = {
                    description = "Części dostarczone, które powinny stać się fizycznie przenoszone rekwizyty.",
                    fields = {
                        transport = {
                            options = {
                                engine_lift = "Podnoszenie silnika",
                                forklift = "Wózek wózkowy",
                                hand = "Ręka",
                            },
                        },
                    },
                    itemLabel = "Przenoś element",
                    label = "Przenoś przedmioty",
                },
                ecuEngineTorqueStage1 = {
                    description = "1,00 nie dodaje mocy; 1,10 zwiększa moment obrotowy o 10%. Dotyczy pojazdów z tym etapem ECU.",
                    label = "Mnożnik momentu obrotowego etapu 1",
                },
                ecuEngineTorqueStage2 = {
                    description = "1,00 nie dodaje mocy; 1,10 zwiększa moment obrotowy o 10%. Dotyczy pojazdów z tym etapem ECU.",
                    label = "Mnożnik momentu obrotowego etapu 2",
                },
                ecuEngineTorqueStage3 = {
                    description = "1,00 nie dodaje mocy; 1,10 zwiększa moment obrotowy o 10%. Dotyczy pojazdów z tym etapem ECU.",
                    label = "Mnożnik momentu obrotowego etapu 3",
                },
                ecuEngineTorqueStage4 = {
                    description = "1,00 nie dodaje mocy; 1,10 zwiększa moment obrotowy o 10%. Dotyczy pojazdów z tym etapem ECU.",
                    label = "Mnożnik momentu obrotowego etapu 4",
                },
                fakePlatesAudit = {
                    label = "Dziennik audytu",
                },
                fakePlatesBlacklist = {
                    description = "Blokowane słowa lub fragmenty, które nie mogą pojawić się w fałszywych tablicach.",
                    label = "Czarna lista",
                },
                fakePlatesBlankPlateItem = {
                    description = "Materiał rzemieślniczy/sprzedawca używany do fałszywych pętli płytek.",
                    label = "Pozycja pustej płyty",
                },
                fakePlatesCooldownMinutes = {
                    label = "Minuty odnowienia",
                },
                fakePlatesCrashFalloffChance = {
                    label = "Szansa upadku",
                },
                fakePlatesCrashFalloffEnabled = {
                    label = "Włączony wypadek wypadków",
                },
                fakePlatesCrashFalloffMinSpeedKmh = {
                    label = "Minimalna prędkość awarii",
                },
                fakePlatesEnabled = {
                    description = "Pozwól graczom użyć fałszywych zestawów płytek na pojazdach.",
                    label = "Aktywuj fałszywe tablice",
                },
                fakePlatesExpireMinutes = {
                    description = "0 utrzymuje fałszywe płyty aktywne do czasu resetowania lub restartowania obsługi ich usuwa.",
                    label = "Wygaśnięcie minut",
                },
                fakePlatesExpireOnRestart = {
                    label = "Wystarczy przy ponownym uruchomieniu",
                },
                fakePlatesIllegalMarketAccount = {
                    label = "Konto płatnicze",
                },
                fakePlatesIllegalMarketEnabled = {
                    label = "Umożliwiony nielegalny rynek",
                },
                fakePlatesIllegalMarketPrice = {
                    label = "Nielegalna cena rynkowa",
                },
                fakePlatesIllegalMarketRiskMultiplier = {
                    label = "Mnożnik ryzyka",
                },
                fakePlatesInstallDurationMs = {
                    label = "Zainstaluj czas trwania ms",
                },
                fakePlatesItem = {
                    description = "Jednouużyteczny element, który rozpoczyna fałszywy przepływ instalacji płyt.",
                    label = "Zestaw fałszywej płyty",
                },
                fakePlatesMaxLength = {
                    label = "Maksymalna długość",
                },
                fakePlatesMaxVehicleDistance = {
                    label = "Odległość do pojazdu",
                },
                fakePlatesMinLength = {
                    label = "Minimalna długość",
                },
                fakePlatesPattern = {
                    description = "Wzór lua używany do weryfikacji fałszywego tekstu płyty, na przykład ^[A-Z0-9]+$.",
                    label = "Wzór lua",
                },
                fakePlatesPlateInstallDistance = {
                    label = "Odległość położenia płyty",
                },
                fakePlatesPreventDuplicateDisplayPlates = {
                    label = "Blokuj podwójne aktywne fałszywe płyty",
                },
                fakePlatesPrinterItem = {
                    description = "Narzędzie rzemieślnicze / sklepowe wykorzystywane do fałszywych pętli płytek.",
                    label = "Pozycja drukarki płytowej",
                },
                fakePlatesRequireEngineOff = {
                    label = "Silnik musi być wyłączony",
                },
                fakePlatesRequireOwnerOrKeys = {
                    description = "Przed montażem należy użyć Config.Functions.CanApplyFakePlate.",
                    label = "Wymagaj właściciela lub kluczy",
                },
                fakePlatesRequireStopped = {
                    label = "Pojazd musi zostać zatrzymany",
                },
                fakePlatesResetOnGarageStore = {
                    description = "Zarezerwowany do integracji garażowych, które nazywają zdarzenie reset/eksport.",
                    label = "Resetuj sklep garażowy",
                },
                fakePlatesRiskCharacters = {
                    label = "Znaki Typo",
                },
                fakePlatesRiskEnabled = {
                    label = "Uaktywnione typy ryzyka",
                },
                fakePlatesRiskTypoChance = {
                    label = "Szansa na typo",
                },
                fallbackVehicleValue = {
                    description = "Wartość użyta w przypadku, gdy nie można ustalić ceny pojazdu.",
                    label = "Wartość zapasowa pojazdu",
                },
                firejobVehicleFiresCriticalChance = {
                    description = "Szansa 0 do 1 po tym jak silnik pozostaje krytyczny.",
                    label = "Krytyczna szansa na ogień silnika",
                },
                firejobVehicleFiresCriticalCooldownSeconds = {
                    description = "W sekundach przed kolejnym złamanym silnikiem ogień może wywołać.",
                    label = "Krytyczne ochłodzenie silnika",
                },
                firejobVehicleFiresCriticalDelayMs = {
                    description = "Opóźnienie w milisekundach zanim złamany silnik może się rozpalić.",
                    label = "Krytyczne opóźnienie silnika ms",
                },
                firejobVehicleFiresCriticalEnabled = {
                    description = "Zezwolić na uruchomienie po opóźnienia pojazdu pożarowego po skrupulatnie uszkodzonych silnikach.",
                    label = "Silniki ignitu złamane",
                },
                firejobVehicleFiresCriticalSmokeDensity = {
                    description = "Gęstość dymu używana do zapytania o pożar złamanych silników.",
                    label = "Krytyczna gęstość dymu silnika",
                },
                firejobVehicleFiresEnabled = {
                    description = "Zezwolić systemom uszkodzeń mechanicznych, aby zażądały pożaru od ognia.",
                    label = "Aktywacja pojazdu ognia",
                },
                firejobVehicleFiresForwardMotionRatio = {
                    description = "Wymagany współczynnik przemieszczania się z 0 do 1.",
                    label = "Współczynnik ruchu w przód",
                },
                firejobVehicleFiresImpactChance = {
                    description = "Szansa 0 do 1 że kwalifikacyjny wpływ wywoła pożar.",
                    label = "Możliwość uderzenia w ogień",
                },
                firejobVehicleFiresImpactCooldownSeconds = {
                    description = "W sekundy przed kolejnym uderzeniem ogień może wywołać.",
                    label = "Zmrożenie ognia uderzenia",
                },
                firejobVehicleFiresImpactEnabled = {
                    description = "Zezwolić na silne wypadki frontowe na żądanie ognia pojazdu ogniowego.",
                    label = "Ignit po ciężkich awariach",
                },
                firejobVehicleFiresImpactSmokeDensity = {
                    description = "Gęstość dymu używana do zapytania o pożar.",
                    label = "Skuteczna gęstość dymu",
                },
                firejobVehicleFiresIntegrationMode = {
                    description = "Automatycznie wykorzystuje skonfigurowane zasoby Firejob; niepełnosprawne zapobiegają powstawaniu pożarów mechanicznych.",
                    label = "Tryb integracji",
                    options = {
                        automatic = "Automatyczna",
                        disabled = "Wyłączone",
                    },
                },
                firejobVehicleFiresMinBodyHealthLoss = {
                    description = "Minimalne zdrowie ciała utracone podczas uderzenia.",
                    label = "Minimalne uszkodzenie ciała",
                },
                firejobVehicleFiresMinEngineHealthLoss = {
                    description = "Minimalne zdrowie silnika utracone podczas uderzenia.",
                    label = "Minimalne uszkodzenie silnika",
                },
                firejobVehicleFiresMinFrontDeformation = {
                    description = "Użyj 0, aby wyłączyć kontrolę deformacji.",
                    label = "Minimalna deformacja frontowa",
                },
                firejobVehicleFiresMinImpactSpeedKmh = {
                    description = "Minimalna prędkość przeddziału w km/h.",
                    label = "Minimalna prędkość uderzenia",
                },
                firejobVehicleFiresMinSpeedDropKmh = {
                    description = "Wymagana utrata prędkości w km/h podczas uderzenia.",
                    label = "Minimalna utrata prędkości",
                },
                firejobVehicleFiresResource = {
                    description = "Zasoby, które otrzymują prośby o ogień.",
                    label = "Zasoby ognia",
                },
                firejobVehicleFiresServerEvent = {
                    description = "Wydarzenie wewnętrzne serwera używane przez klienta mechanicznego, aby zażądać ognia pojazdu Firejob.",
                    label = "Wydarzenie serwera mechanicznego",
                },
                freeVehicles = {
                    description = "Modele samochodów, które otrzymują bezpłatne zamówienia regulacyjne.",
                    itemLabel = "Model pojazdu",
                    label = "Bezpłatne pojazdy regulacyjne",
                },
                handlingEditorBlockCriticalValidation = {
                    description = "Zapobiegać Stosowaniu podczas wystąpienia krytycznego konfliktu.",
                    label = "Blokowanie krytycznych ustaleń",
                },
                handlingEditorCoachMinimumBrakeDeceleration = {
                    description = "Oczekiwane maksymalne opóźnienie w m/s2 w przypadku zakończonej próby hamowania.",
                    label = "Minimalne opóźnienie hamulca",
                },
                handlingEditorCoachMinimumSamples = {
                    description = "Zmierzone próbki wymagane przed oceną trenera Telemetrii.",
                    label = "Minimalne próbki",
                },
                handlingEditorCoachWheelSlipWarningKmh = {
                    description = "Zmierzona prędkość skrzyżowania koła w km/h, przy której zgłaszane są straty trakcyjne.",
                    label = "Ostrzeżenie o przesuwaniu koła",
                },
                handlingEditorDefaultTab = {
                    description = "Strona wybrana przy otwarciu samodzielnego Edytora Handlinga.",
                    label = "Strona początkowa",
                    options = {
                        advanced = "Zaawansowany",
                        export = "Eksport",
                        flags = "Flaga",
                        fleet = "Flota",
                        inspector = "Warstwy",
                        profiles = "Profile",
                        simple = "Prosty",
                        telemetry = "Telemetria",
                    },
                },
                handlingEditorFieldDocumentationEnabled = {
                    description = "Zapewnienie efektu, zakresu odniesienia, objawów, pokrewnych polach i żywego wsparcia dla każdej wartości manipulacyjnej.",
                    label = "Dokumentacja terenowa",
                },
                handlingEditorFlagSearchEnabled = {
                    description = "Szukaj i filtruj nazwy flag, efekty, pozycje bitowe i maski szesnastkowe.",
                    label = "Wyszukiwanie flagi",
                },
                handlingEditorFleetManagerEnabled = {
                    description = "Przeszukiwanie, inspekcja, promowanie i przywrócenie przepisów dotyczących obsługi modeli i płyt.",
                    label = "Zarządca floty",
                },
                handlingEditorLayerInspectorEnabled = {
                    description = "Pokaż bazę pojazdu, zainstalowane własne ustawienie, reguła modelu, zasada tablicy i bieżący edytor projekt dla każdego pola.",
                    label = "Inspektor warstwy",
                },
                handlingEditorMaxFleetResults = {
                    description = "Maksymalne zasady modelu i tablicy załadowane do Fleet Manager.",
                    label = "Ograniczenie wyników floty",
                },
                handlingEditorMaxProfileRevisions = {
                    description = "Maksymalna liczba zmian zatrzymanych dla każdego profilu.",
                    label = "Modyfikacje profilu",
                },
                handlingEditorMaxWorkspacesPerAdmin = {
                    description = "Maksymalna nazwa prac roboczych zatrzymanych dla każdego administratora.",
                    label = "Osobiste prace robocze",
                },
                handlingEditorProfileVersioningEnabled = {
                    description = "Stwórz rewizję, którą można audytować, gdy wspólny profil zostanie zaktualizowany lub przywrócony.",
                    label = "Wersja profilu",
                },
                handlingEditorTelemetryCoachEnabled = {
                    description = "Tworzenie przejrzystych zaleceń oparte na zasadach zmierzonych danych badania drogowego.",
                    label = "Trener telemetrii",
                },
                handlingEditorValidatorEnabled = {
                    description = "Przed zastosowaniem należy wykryć niebezpieczne lub sprzeczne kombinacje.",
                    label = "Obsługa sprawdzacza",
                },
                handlingEditorWorkspacesEnabled = {
                    description = "Pozwól administratorom przechowywać projekty prywatnego edytora.",
                    label = "Osobiste prace robocze",
                },
                instantTuningAllowedJobs = {
                    description = "Opcjonalna globalna lista zezwoleń. Pozostaw pusty, aby pozwolić każdemu, chyba że jest włączony tylko mechanik.",
                    itemLabel = "Nazwa pracy",
                    label = "Dozwolone prace",
                },
                instantTuningBlipColor = {
                    description = "GTA blip kolor id.",
                    label = "Kolor ciśnienia",
                },
                instantTuningBlipEnabled = {
                    description = "Pokaż blipsy mapy w miejscach automatycznego tuningu.",
                    label = "Blip włączony",
                },
                instantTuningBlipName = {
                    description = "Nazwisko mapy.",
                    label = "Nazwisko blipa",
                },
                instantTuningBlipSprite = {
                    description = "GTA blip spryt identyfikator.",
                    label = "Spryt błyszczący",
                },
                instantTuningForceMarkerInteraction = {
                    description = "Użyj interakcji w stylu markerowym E, nawet gdy wsparcie docelowe jest włączone.",
                    label = "Wymusić interakcję markerową",
                },
                instantTuningInteractionDistance = {
                    description = "Domyślna odległość przy użyciu punktów automatycznych.",
                    label = "Dystans interakcji",
                },
                instantTuningLabel = {
                    description = "Domyślny tekst wyświetlany w punktach automatycznych.",
                    label = "Domyślna etykieta",
                },
                instantTuningLocations = {
                    description = "Użyj 0 dystansu, aby odziedziczyć domyślną odległość interakcji.",
                    itemLabel = "Lokalizacje",
                    label = "Lokalizacje",
                },
                instantTuningMarkerEnabled = {
                    description = "Narysuj marker świata w miejscach niezwłocznego tuningu.",
                    label = "Oznakowanie włączone",
                },
                instantTuningMarkerType = {
                    description = "GTA typ markeru używany do lokalizacji automatycznej.",
                    label = "Typ znacznika",
                },
                instantTuningMechanicOnly = {
                    description = "Ograniczyć wszystkie miejsca automatycznego tuningu do skonfigurowanych zawodów mechanicznych.",
                    label = "Wyłącznie mechaniczne",
                },
                instantTuningPriceMultiplier = {
                    description = "Mnożnik stosowany w cenach automatycznych.",
                    label = "Mnożnik ceny",
                },
                instantTuningProfile = {
                    description = "Konfiguracja, które opcje regulacji są dostępne w punktach automatycznych.",
                    label = "Opcje natychmiastowego dostosowania",
                },
                maintenanceNotificationsCooldownMinutes = {
                    description = "Minimalne minuty przed tym samym pojazdem mogą uruchomić kolejne przypomnienie o konserwacji.",
                    label = "Usuwanie powiadomień",
                },
                maintenanceNotificationsEnabled = {
                    description = "Poinformuj właścicieli pojazdu o osiągnięciu progu konserwacji części zużycia.",
                    label = "Włączone",
                },
                maintenanceNotificationsThreshold = {
                    description = "Odsetek noszący należność konserwacji lub poniżej.",
                    label = "Próg zaległości",
                },
                mileageHudDigits = {
                    description = "Liczba cyfr wyświetlonych w przedziale HUD.",
                    label = "Cyfry",
                },
                mileageHudPosition = {
                    description = "Przeciągnij podgląd HUD do pożądanej pozycji ekranu.",
                    label = "Pozycja",
                },
                oilLeaksCooldownSeconds = {
                    description = "W sekundach przed kolejnym przeciekiem uderzenia może wywołać.",
                    label = "Zmniejszanie wpływu",
                },
                oilLeaksEnabled = {
                    description = "Zezwolić uszkodzonym pojazdom spalania na pozostawienie płynu podczas jazdy.",
                    label = "Aktywacja przecieków płynów",
                },
                oilLeaksEngineOilChance = {
                    description = "Zwykła szansa na przeciek 0 do 1. .",
                    label = "Szansa na olej silnikowy",
                },
                oilLeaksEngineOilCriticalChance = {
                    description = "Szansa przecieku krytycznego z 0 do 1.",
                    label = "Krytyczna szansa na olej silnikowy",
                },
                oilLeaksEngineOilCriticalThreshold = {
                    description = "Stabilność oleju silnikowego w miejscu lub poniżej, w którym stosuje się krytyczną szansę.",
                    label = "Próg krytyczny oleju silnikowego",
                },
                oilLeaksEngineOilThreshold = {
                    description = "Stan oleju silnikowego, w którym może się rozpocząć przeciek.",
                    label = "Prog oleju silnika",
                },
                oilLeaksForwardMotionRatio = {
                    description = "Wymagany współczynnik przemieszczania się z 0 do 1.",
                    label = "Współczynnik ruchu w przód",
                },
                oilLeaksFrontalImpactEnabled = {
                    description = "Pozwolić na uruchomienie tymczasowego przecieku płynu silnika na poważne uderzenia frontalne.",
                    label = "Przecieki uderzenia przedniego",
                },
                oilLeaksImpactChance = {
                    description = "Szansa 0 do 1 że kwalifikacyjny wpływ zaczyna przeciekać.",
                    label = "Szansa przecieku uderzenia",
                },
                oilLeaksImpactRadius = {
                    description = "Promień początkowego punktu płynu utworzonego przez uderzenie.",
                    label = "Promień wycieku uderzenia",
                },
                oilLeaksIntervalSeconds = {
                    description = "Minimalne sekundy między punktami trasy.",
                    label = "Odstęp ścieżki",
                },
                oilLeaksLeakDurationSeconds = {
                    description = "W sekundach przeciek trwa po kwalifikacyjnym skutku.",
                    label = "Czas trwania przecieku uderzeń",
                },
                oilLeaksMinBodyHealthLoss = {
                    description = "Minimalne zdrowie ciała utracone podczas uderzenia.",
                    label = "Minimalne uszkodzenie ciała",
                },
                oilLeaksMinDistance = {
                    description = "Minimalna odległość między punktami trasy.",
                    label = "Odległość ścieżki",
                },
                oilLeaksMinEngineHealthLoss = {
                    description = "Minimalne zdrowie silnika utracone podczas uderzenia.",
                    label = "Minimalne uszkodzenie silnika",
                },
                oilLeaksMinFrontDeformation = {
                    description = "Wymagana przednia deformacja. Użyj 0, aby wyłączyć tę kontrolę.",
                    label = "Minimalna deformacja frontowa",
                },
                oilLeaksMinImpactSpeedKmh = {
                    description = "Minimalna prędkość przeddziału w km/h.",
                    label = "Minimalna prędkość uderzenia",
                },
                oilLeaksMinSpeedDropKmh = {
                    description = "Wymagana utrata prędkości w km/h podczas uderzenia.",
                    label = "Minimalna utrata prędkości",
                },
                oilLeaksMinSpeedKmh = {
                    description = "Minimalna prędkość pojazdu w km/h przed przeciekiem płynu może tworzyć ścieżkę.",
                    label = "Minimalna prędkość",
                },
                oilLeaksRadius = {
                    description = "Promień radiusowy zwykłych punktów ścieżki płynów pojazdu.",
                    label = "Promień ścieżki",
                },
                oilLeaksTransmissionFluidChance = {
                    description = "Zwykła szansa na przeciek 0 do 1. .",
                    label = "Szansa płynu transmisyjnego",
                },
                oilLeaksTransmissionFluidCriticalChance = {
                    description = "Szansa przecieku krytycznego z 0 do 1.",
                    label = "Krytyczna szansa transmisji",
                },
                oilLeaksTransmissionFluidCriticalThreshold = {
                    description = "Stan płynu transmisyjnego w momencie lub poniżej, w którym stosuje się szansę krytyczną.",
                    label = "Prog krytyczny przesyłowy",
                },
                oilLeaksTransmissionFluidThreshold = {
                    description = "Stan płynu przesyłowego, w którym może się rozpocząć przeciek.",
                    label = "Prog płynów przesyłowych",
                },
                orderInstallLiftBypassVehicleClasses = {
                    description = "Klasyfikacje pojazdów, które mogą zakończyć pracę niezależną od windy, bez windy warsztatowej.",
                    itemLabel = "Dodaj klasę pojazdu",
                    label = "Klasyfikacje podnośnika",
                    options = {
                        ["0"] = "Kompakty",
                        ["1"] = "Sedani",
                        ["10"] = "Przemysłowe",
                        ["11"] = "Instalacje",
                        ["12"] = "Vany",
                        ["13"] = "Cykle",
                        ["14"] = "Łodzie",
                        ["15"] = "Helikoptery",
                        ["16"] = "Samoloty",
                        ["17"] = "Serwis",
                        ["18"] = "Nagły wypadek",
                        ["19"] = "Wojskowy",
                        ["2"] = "SUVS",
                        ["20"] = "Komercyjne",
                        ["21"] = "Pociągi",
                        ["22"] = "Otwarte koło",
                        ["3"] = "Coupes",
                        ["4"] = "Mięso",
                        ["5"] = "Klasyka sportowa",
                        ["6"] = "Sport",
                        ["7"] = "Super",
                        ["8"] = "Motocykle",
                        ["9"] = "Poza drogą drogową",
                    },
                },
                orderInstallLiftBypassVehicleModels = {
                    description = "Modele tarczy pojazdów, które mogą zakończyć niezależną od windy pracę zamówienia bez windy warsztatowej.",
                    itemLabel = "Model pojazdu",
                    label = "Modele obwodów podnośnych",
                },
                orderInstallNonMinigameDurationMs = {
                    description = "Milisekundy używane do instalacji zamówienia kroki, które nie uruchamiają minigry.",
                    label = "Prosta długość instalacji",
                },
                orderInstallNonMinigameVehicleClasses = {
                    description = "Klasa pojazdu IDs, które zawsze używają normalnej instalacji mechanicznej bez specjalnych windy lub minigame przepływów.",
                    label = "Klasyfikacje pojazdów nieminimalnych",
                },
                orderInstallNonMinigameVehicleModels = {
                    description = "Modele samochodowe, które zawsze używają normalnej instalacji mechanicznej bez specjalnego windy lub minigame przepływu.",
                    label = "Modele pojazdów nieminimalnych",
                },
                partsDeliveryCompanyCard = {
                    description = "Zezwolić na dostawę części na wykorzystanie funduszy firmy.",
                    label = "Płatność karty firmy",
                },
                partsDeliveryMode = {
                    description = "Zachować standardowy fizyczny przepływ dostawy lub dodać pełną dostawę bezpośrednio do inwentarza gracza zbierającego.",
                    label = "Wysyłka",
                    options = {
                        player_inventory = "Lista graczy",
                        standard = "Standardowy przepływ dostawy",
                    },
                },
                partsDeliveryOpenDurationMs = {
                    description = "Milisekundy potrzebne do rozpakowania gotowych części.",
                    label = "Czas trwania otwartego",
                },
                partsDeliveryOwnCard = {
                    description = "Pozwól graczom wypłacać części zlecenia dostawy własnymi pieniędzmi.",
                    label = "Płatność własnej karty",
                },
                partsDeliveryTimeSeconds = {
                    description = "Między zamówieniem części a dostawą jest gotowa.",
                    label = "Czas dostawy",
                },
                partsTheftCatalyticConverterItem = {
                    description = "Pozycja inwentaryczna przyznana, gdy skradziony jest przetwornik katalizacyjny.",
                    label = "Pozycja przetwornika katalizacyjnego",
                },
                partsTheftDealerAccount = {
                    description = "Rachunek wykorzystywany do skradzionych części sprzedawców wypłat, takich jak pieniądze lub bank.",
                    label = "Rachunek wypłaty rozdawcy",
                },
                partsTheftDealerItems = {
                    description = "Ukradzione przedmioty, które sprzedawca kupi i ich wartości wypłaty.",
                    itemLabel = "Pozycja rozdawacza",
                    label = "Pozycje rozdawacza",
                },
                partsTheftDealerPayoutItem = {
                    description = "Pozycja inwentaryczna podana w przypadku, gdy dealer typu wypłaty jest Pozycją. Sprzedażowa cena jest używana jako kwota pozycji.",
                    label = "Pozycja wypłaty rozdawcy",
                },
                partsTheftDealerPayoutType = {
                    description = "Wybierz, czy dealer płaci na rachunek ramowy, czy przedstawia pozycję inwentarza.",
                    label = "Rodzaj wypłaty rozdawcy",
                    options = {
                        account = "Konto",
                        item = "Przedmiot",
                    },
                },
                partsTheftDealerSellDistance = {
                    description = "Maksymalna odległość od sprzedawcy do sprzedaży skradzionych części.",
                    label = "Sprzedawca sprzedaje odległość",
                },
                partsTheftDispatchCooldownSeconds = {
                    description = "Wstępne sekundy przed tym samym pojazdem mogą stworzyć kolejną wysyłkę.",
                    label = "Czas odnowienia dispatchu",
                },
                partsTheftDispatchEnabled = {
                    description = "Utworzyć wysyłkę policji, gdy skradziony jest koło lub przetwornik katalizacyjny.",
                    label = "Wyślij wysyłkę policji",
                },
                partsTheftDispatchJobs = {
                    description = "nazwy zawodów, które otrzymują części wysyłki kradzieżowe.",
                    itemLabel = "Nazwa pracy",
                    label = "Zlecenia dyspozytorskie",
                },
                partsTheftDispatchMessage = {
                    description = "Wiadomość przedstawiona w alarmie wysyłki. Wsparcie {plate}, {part} i {type}.",
                    label = "Wiadomość rozesłania",
                },
                partsTheftDispatchTitle = {
                    description = "Tytuł wskazany na wpisie wysyłki. Wsparcie {plate}, {part} i {type}.",
                    label = "Nazwa wysyłki",
                },
                partsTheftItem = {
                    description = "Pozycja inwentaryczna używana do kradzieży koła i przetworników katalizacyjnych.",
                    label = "Pozycja kradzieżowa",
                },
                partsTheftRemoveItemAfterUse = {
                    description = "Usuń element kradzieży narzędzia po udanej akcji kradzieży.",
                    label = "Narzędzie do kradzieży konsumpcji",
                },
                partsTheftStolenWheelItem = {
                    description = "Pozycja inwentaryczna przyznana podczas kradzieży koła.",
                    label = "Pozycja skradziona koła",
                },
                priceType = {
                    description = "Odsetek oblicza koszty na podstawie ceny pojazdu. Fiksowane wykorzystanie wartości pieniężnych. Klasa pojazdu wykorzystuje tabelę cen klasy.",
                    label = "Typ ceny",
                    options = {
                        class = "Klasa pojazdu",
                        fixed = "Ustawione",
                        percentage = "Odsetek",
                    },
                },
                primaryColor = {
                    description = "Domyślny kolor dla grupy zawodów mechanicznych i nowych zawodów. Użyj wartości hex, takiej jak #EDC001.",
                    label = "Kolor podstawowy",
                },
                publicUsersSeePrices = {
                    description = "Jeśli jest włączony, publiczni klienci płacą podczas zamówienia. Wyłącz to, aby tworzyć niezapłacone zamówienie na rachunki mechaniczne.",
                    label = "Opłata za samoobsługę publiczną",
                },
                subscriptionsAllowJobSubscriptions = {
                    description = "Pozwolić autoryzowanym szefom na zakup subskrypcji dla całego zawodu za pomocą funduszy spółek.",
                    label = "Subskrypcje przedsiębiorstwa",
                },
                subscriptionsCurrency = {
                    description = "sky_base currency used to purchase subscriptions, for example bank.",
                    label = "Waluta płatności",
                },
                subscriptionsEnabled = {
                    description = "Aktywuj abonamenty warsztatów, terminale klienta i zniżki subskrypcyjne.",
                    label = "Włączone",
                },
                subscriptionsMaximumDurations = {
                    description = "Maksymalny czas trwania i opcje ceny na model subskrypcji.",
                    label = "Maksymalny czas trwania",
                },
                subscriptionsMaximumModels = {
                    description = "Maksymalne modele subskrypcji warsztaty mogą skonfigurować w tabletach.",
                    label = "Maksymalna liczba modeli",
                },
                subscriptionsNpcEmoteClip = {
                    description = "Opcjonalny klip animacji pętli używany przy pustym scenariuszu.",
                    label = "NPC klip emotyczny",
                },
                subscriptionsNpcEmoteDict = {
                    description = "Opcjonalny słownik animacji używany przy pustym scenariuszu.",
                    label = "NPC Emote słownik",
                },
                subscriptionsNpcPedModel = {
                    description = "Model Ped nurtowany w terminalu subskrypcji, na przykład s_m_m_autoshop_01.",
                    label = "Domyślny model NPC",
                },
                subscriptionsNpcScenario = {
                    description = "Opcjonalny scenariusz GTA, taki jak World_HUMAN_CLIPBOARD. Pozostaw pusty, aby użyć emotowej animacji.",
                    label = "NPC Scenariusz",
                },
                tuningBlockedPlates = {
                    description = "Pojazdy z jedną z tych płyt nie mogą być ustawione, zainstalowane lub usunięte. Dopasowywanie ignoruje osłonę i przesłony.",
                    itemLabel = "Tablica rejestracyjna",
                    label = "Blokowane tablice regulacyjne",
                },
                tuningWorkshopDistance = {
                    description = "Maksymalna odległość od samoobsługowego punktu regulacyjnego dla wymaganych działań instalacyjnych lub usuwających.",
                    label = "Odległość wymagana przez warsztaty",
                },
                tuningWorkshopRequireForInstall = {
                    description = "Wymaga instalacji zamówienia regulacyjnego, aby rozpocząć i zakończyć w pobliżu punktu samoobsługi.",
                    label = "Wymagać warsztatów dla instalacji",
                },
                tuningWorkshopRequireForRemoval = {
                    description = "Wymaga usuwania regulacji, aby rozpocząć i zakończyć w pobliżu punktu samoobsługi.",
                    label = "Wymaganie warsztatu do usuwania",
                },
                vehicleCareRepairDurationMs = {
                    description = "Czas trwania postępu w milisekundach.",
                    label = "Czas trwania naprawy",
                },
                vehicleCareRepairFixRealisticWheelDamage = {
                    description = "Resetuj również realistyczne uszkodzenie koła przy zastosowaniu działania naprawczego.",
                    label = "Realistyczne uszkodzenie koła",
                },
                vehicleCareRepairItem = {
                    description = "Pozycja inwentarza użyta w działaniu naprawczym pojazdu.",
                    label = "Przedmiot naprawy",
                },
                vehicleCareRepairMaxDistance = {
                    description = "Maksymalna odległość od pojazdu podczas naprawy.",
                    label = "Naprawa maksymalna odległość",
                },
                vehicleCareRepairRemoveAfterUse = {
                    description = "Usunąć element naprawy po użyciu.",
                    label = "Pozycja naprawy konsumpcji",
                },
                vehicleCareRepairVehicleDamage = {
                    description = "Naprawa normalnego uszkodzenia pojazdu GTA przy zastosowaniu działania naprawczego.",
                    label = "Uszkodzenie pojazdu",
                },
                vehicleCareRepairWearParts = {
                    description = "Wybierz, które zużycie i obsługa części elementu naprawy przywraca. Wyłącz tutaj płyny, jeśli olej, chłodzenie, płyn hamulcowy, lub płyn przesyłowy wymaga przepływu diagnostyki naprawy.",
                    itemLabel = "Część noszenia",
                    label = "Zestaw naprawczy restaurowany",
                },
                vehicleCareWashItem = {
                    description = "Pozycja wykazu używana do mycia pojazdu.",
                    label = "Pozycja mycia",
                },
                vehicleCareWashRemoveAfterUse = {
                    description = "Po użyciu należy usunąć element mycia.",
                    label = "Pozycja mycia konsumowanego",
                },
                vehicleCareWaxCleanKilometers = {
                    description = "Odległość woskowany pojazd pozostaje czysty.",
                    label = "Czyste kilometry woskowe",
                },
                vehicleCareWaxItem = {
                    description = "Inwentarz używany do woskowania pojazdu.",
                    label = "Pozycja waksa",
                },
                vehicleCareWaxRemoveAfterUse = {
                    description = "Po użyciu należy usunąć pojemnik wosku.",
                    label = "Pozycja wosku konsumpcyjna",
                },
                vehicleClassPricing = {
                    description = "Przesunąć rodzaj ceny i mnożnik kosztów dla każdej klasy pojazdu GTA.",
                    label = "Ceny klasy pojazdów",
                },
                wearParts = {
                    description = "Części zużycia pojazdu, odległość do życia, wymagany element naprawy, zużycie przedmiotu i przepływ instalacji.",
                    fields = {
                        flow = {
                            options = {
                                catalytic_converter = "Konwerter katalityczny",
                                fluid_refill = "Napełnianie płynu",
                                hood_install = "Instalacja Hood",
                                oil_change = "Zmiana oleju",
                                performance = "Osiągi",
                                underbody_neon = "Podcięcie / podniesienie",
                                wheel = "Koło",
                            },
                        },
                    },
                    itemLabel = "Część noszenia",
                    label = "Części noszone",
                },
                wheelDamageDefaultMultiplier = {
                    description = "Mnożnik uszkodzenia koła podstawowego.",
                    label = "Domyślny mnożnik",
                },
                wheelDamageDeformationAngleThreshold = {
                    description = "Filtry sondy deformacyjnej, które nie wskazują na ciało pojazdu.",
                    label = "Prog kąta sodu",
                },
                wheelDamageDeformationDamageIncrement = {
                    description = "Dodatkowa siła dodała każdą iterację.",
                    label = "Zwiększenie uszkodzeń deformacji",
                },
                wheelDamageDeformationEnabled = {
                    description = "Przechwytywanie i przywracanie wgłębień ciała podczas naprawy opony odbudowuje.",
                    label = "Odwróć deformację",
                },
                wheelDamageDeformationInitialDamage = {
                    description = "Siła startowa używana przy przywracaniu wgłębień.",
                    label = "Początkowe uszkodzenie deformacji",
                },
                wheelDamageDeformationMaxIterations = {
                    description = "Maksymalne przepustki na setVozikleDamage wykorzystywane do odbudowywania włókna.",
                    label = "Iteracje deformacji",
                },
                wheelDamageDeformationThreshold = {
                    description = "Minimalna wykryta wielkość deformacji do przechowywania.",
                    label = "Próg deformacji",
                },
                wheelDamageOffroadWheelsMultiplier = {
                    description = "Wielośrodek używany w przypadku, gdy pojazd ma koła poza drogą.",
                    label = "Mnożnik koła pozadrożowego",
                },
                wheelDamageRepairInstantDamageReapplyPasses = {
                    description = "Dodatkowe uszkodzenie niekoła przywraca przejść po przebudowie geometrii koła.",
                    label = "Uszkodzenie ponowne zastosowanie przepustów",
                },
                wheelDamageRepairInstantWheelStateReapplyPasses = {
                    description = "Dodatkowe natychmiastowe przepusty dla nieustannych lub nieuchronnych opon po naprawie koła.",
                    label = "Statystyka koła ponowne nakładanie przepustek",
                },
                wheelDamageRepairPreserveNonWheelDamage = {
                    description = "Trzymać ciało, silnik, okna, drzwi, brud i uszkodzenia wzrokowe, gdy naprawa opon odbudowuje geometrię koła.",
                    label = "Zachować uszkodzenie pojazdu",
                },
                wheelDamageRepairQuietWindowRemoval = {
                    description = "Odwróć rozbite okna bez efektu głośnego rozbijania, jeśli to możliwe.",
                    label = "Ciche połamane okna",
                },
                wheelDamageRepairSilentPoppedReapply = {
                    description = "Ponowne napędowanie opon nieruchomych, bez uruchomienia nowego dźwięku lub efektu popu.",
                    label = "Cicha płaska opona ponownie nakłada się",
                },
                wheelDamageTyreRepairAttachDistance = {
                    description = "Maksymalna odległość od uszkodzonej lub brakującej opony do działania montażowego.",
                    label = "Odległość przyłączania opony",
                },
                wheelDamageTyreRepairCarJackRemoveDistance = {
                    description = "Maksymalna odległość od umieszczonego waleta samochodowego do usuwania działania.",
                    label = "Jack samochodowy usunąć odległość",
                },
                wheelDamageVehicleClassMultipliers = {
                    description = "Mnożnik szkody dla klasy pojazdu GTA.",
                    itemLabel = "Klasa pojazdu",
                    label = "Mnożniki klasy pojazdu",
                },
                vehicleCareRepairBlockForNonMechanicsWhenMechanicsOnDuty = {
                    label = "Blokuj inne zawody, gdy mechanicy są na służbie",
                },
                allowsprint = {
                    label = "Zezwalaj na sprint z paczkami dostawczymi",
                },
            },
            tuningCategories = {
                bodywork = "Nadwozie",
                electronics = "ECU i elektronika pojazdu",
                engineSounds = "Dźwięki silnika",
                handling = "Prowadzenie",
                lights = "Oświetlenie",
                other = "Inne",
                paint = "Lakier",
                performance = "Osiągi",
                stance = "Ustawienie zawieszenia",
                wheels = "Koła",
            },
            advancedPricingPreview = {
                compact = "Honda / Kompakt",
                customer = "Cena dla klienta",
                description = "Przykład obliczeń kosmetycznych przy użyciu obecnych zasad.",
                labor = "Pracy",
                live = "Podgląd na żywo",
                margin = "Margines",
                sports = "Samochód sportowy",
                super = "Supersamochód",
                supplier = "Dostawca",
                title = "Podgląd cen",
            },
            configs = {
                sky_mechanicjob = {
                    subtitle = "Skonfiguruj prace mechanika, sklepy, pojazdy i lokalizacje warsztatu.",
                    title = "Prace mechanika",
                },
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
            fields = {
                quantity = "Ilość",
            },
            settingFieldDescriptions = {
                radialEnabled = "Otwarte rachunki mechaniczne z menu promieniowego.",
                allowTuningInvoices = "Wyślij koszyk tuningowy do najbliższego klienta. Instalacja odblokuje po pełnej płatności.",
                customerRange = "Maksymalna odległość w metrach dla wydawania faktur dla pobliskich klientów.",
                allowAnalytics = "Pozwolić na rachunkowanie analityki, chyba, że zasada klasy ją przeważy.",
                allowCustomPrices = "Pozwól mechanikom edytować ceny pozycji faktury przed wydaniem.",
                allowEstimates = "Umożliwić szacunki, które klienci muszą przyjąć przed zapłatą.",
                allowImmediatePayment = "Pozwolić na bezpośrednie wypłaty faktur z tego zawodu.",
                allowManualItems = "Pozwolić mechanikom na stworzenie arbitralnej pozycji na fakturze.",
                allowPartialPayments = "Zezwolić na depozyty i wiele płatności na jedną fakturę.",
                analyticsPeriodDays = "Dni włączone do analizy rachunkowej.",
                defaultDueDays = "Dni, aż faktura zostanie spóźniona.",
                depositPercent = "Wymagany procent depozytu po wydaniu faktury lub przyjęciu szacunkowego.",
                enabled = "Pozwól temu zawodowi skorzystać z rachunków mechanicznych.",
                estimateLifetimeHours = "Godziny przed wygaśnięciem nieodpowiedzianych oszacowań.",
                gradeRules = "Ograniczenia faktury i działania dostępne dla każdej klasy mechanicznej.",
                maxDiscountPercent = "Największe zniżki faktury mogą otrzymywać.",
                maximumInvoiceAmount = "Globalna maksymalna suma przed limitami klasy.",
                maximumManualItems = "Maksymalne wolne pozycje w dokumencie.",
                maximumReminders = "Maksymalne dozwolone przypomnienia na fakturze.",
                minimumInvoiceAmount = "Minimalna suma dla szacunków i faktur.",
                minimumPartialPayment = "Najmniejsza płatność częściowa, z wyłączeniem mniejszego pozostałego salda lub depozytu.",
                reminderFee = "Opłata dodana przez każde ważne przypomnienie.",
                reminderGraceDays = "Dni opóźnione przed pierwszym przypomnieniem.",
                taxPercent = "Podatek dodany po zniżkach.",
            },
            settingFields = {
                radialEnabled = "Działanie promieniowe faktury",
                allowTuningInvoices = "Klienci regulujący faktury",
                customerRange = "Odległość klienta",
                allowAnalytics = "Analiza rachunkowości",
                allowCancellation = "Anulowanie",
                allowCustomPrices = "Pozwól na ceny celne",
                allowEstimates = "Zezwolić na oszacowania",
                allowImmediatePayment = "Pozwól na natychmiastową zapłatę",
                allowManualItems = "Pozwól na własne pozycje",
                allowPartialPayments = "Zezwolić na częściowe płatności",
                allowReminders = "Przypomnienia",
                amount = "Kwota",
                analyticsPeriodDays = "Okres analizy",
                bone = "Kości",
                category = "Kategoria",
                classId = "Klasa ID",
                defaultDueDays = "Termin płatności (dni)",
                depositPercent = "Odsetek depozytów",
                difficulty = "Trudności",
                enabled = "Włączone",
                estimateLifetimeHours = "Szacunkowy okres trwałości (godzin)",
                flow = "Zainstaluj przepływ",
                grade = "Stopień",
                gradeRules = "Zasady stopnia",
                item = "Przedmiot",
                key = "Klucz",
                kilometersToZero = "Kilometry do zera",
                label = "Etykieta",
                laborFee = "Koszt pracy",
                laborMultiplier = "Mnożnik pracy",
                marginAdjustmentPercent = "Korekta marginesu",
                marginPercent = "Margines%",
                maxDiscountPercent = "Maksymalna zniżka",
                maximumInvoiceAmount = "Maksymalna faktura",
                maximumManualItems = "Maksymalne własne pozycje",
                maximumPrice = "Maksimum",
                maximumReminders = "Maksymalna liczba przypomnień",
                minimumInvoiceAmount = "Minimalna faktura",
                minimumPartialPayment = "Minimalna płatność częściowa",
                minimumPrice = "Minimalny",
                multiplier = "Mnożnik",
                name = "Nazwa przedmiotu",
                partKey = "Klucz części",
                price = "Cena",
                priceType = "Typ ceny",
                prop = "Obiekt",
                reason = "Powód",
                reminderFee = "Opłata za przypomnienie",
                reminderGraceDays = "Okres łaski przypomnienia",
                removeAfterUse = "Zużyj przedmiot",
                repair = "Naprawa z zestawem",
                repairItem = "Przedmiot naprawy",
                rx = "Rot X",
                ry = "Rot Y",
                rz = "Rot Z",
                supplierSharePercent = "Dostawca %",
                taxPercent = "Podatek od faktury",
                transport = "Transport",
                x = "X",
                y = "Y",
                z = "Z",
                upgrade = "Ulepszenie",
                maximumDiscountPercent = "Maksymalny rabat",
            },
            settingValues = {
                air_filter = "Filtr powietrza",
                brake_fluid = "Fluid hamulcowy",
                brake_pads = "Paski hamulcowe",
                catalytic_converter = "Konwerter katalityczny",
                clutch = "Głucho",
                coolant = "Ochłodzacz",
                engine_oil = "Olej silnikowy",
                inverter = "Inwertator mocy",
                spark_plugs = "Wtyczki iskrowe",
                suspension = "Zawiesina",
                traction_battery = "Bateria trakcji",
                transmission_fluid = "Fluid transmisji",
                tyres = "Opony",
                vehicleClass_0 = "Kompakty",
                vehicleClass_1 = "Sedani",
                vehicleClass_10 = "Przemysłowe",
                vehicleClass_11 = "Instalacje",
                vehicleClass_12 = "Vany",
                vehicleClass_13 = "Cykle",
                vehicleClass_14 = "Łodzie",
                vehicleClass_15 = "Helikoptery",
                vehicleClass_16 = "Samoloty",
                vehicleClass_17 = "Serwis",
                vehicleClass_18 = "Nagły wypadek",
                vehicleClass_19 = "Wojskowy",
                vehicleClass_2 = "SUVS",
                vehicleClass_20 = "Komercyjne",
                vehicleClass_21 = "Pociągi",
                vehicleClass_22 = "Otwarte koło",
                vehicleClass_3 = "Coupes",
                vehicleClass_4 = "Mięso",
                vehicleClass_5 = "Klasyka sportowa",
                vehicleClass_6 = "Sport",
                vehicleClass_7 = "Super",
                vehicleClass_8 = "Motocykle",
                vehicleClass_9 = "Poza drogą drogową",
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
            tuningOptions = {
                antilag_enabled = {
                    label = "antiLag",
                    values = {
                        [0] = "Wyłączone",
                        [1] = "GTA Standardowe",
                        [2] = "Pops Street",
                        [3] = "Wyścig przeciw Lagu",
                        [4] = "Rally Anti- Lag",
                    },
                },
                electronic_automatic_hazards = {
                    label = "Automatyczne zagrożenia",
                    values = {
                        [0] = "Wył.",
                        [1] = "Wł.",
                    },
                },
                electronic_brake_lights = {
                    label = "Światła hamulce",
                    values = {
                        [0] = "Normalna",
                        [1] = "Błysk awaryjny",
                        [2] = "Wył.",
                    },
                },
                electronic_engine_tune = {
                    label = "Oprogramowanie silnika",
                    values = {
                        [0] = "Zapas",
                        [1] = "Etap 1",
                        [2] = "Etap 2",
                        [3] = "Etap 3",
                        [4] = "Etap 4",
                    },
                },
                electronic_headlight_brightness = {
                    label = "Jasność światła przedniego",
                    values = {
                        [0] = "25%",
                        [1] = "50%",
                        [2] = "75%",
                        [3] = "100%",
                        [4] = "125%",
                        [5] = "150%",
                    },
                },
                electronic_highbeams_on_horn = {
                    label = "Wysokie bąki na rogu",
                    values = {
                        [0] = "Wył.",
                        [1] = "Wł.",
                    },
                },
                electronic_idle_rpm = {
                    label = "Bezczynny RPM",
                    values = {
                        [0] = "Zapas",
                        [1] = "20%",
                        [2] = "30%",
                        [3] = "40%",
                        [4] = "50%",
                    },
                },
                electronic_interior_light = {
                    label = "Światło wewnętrzne",
                    values = {
                        [0] = "Normalna",
                        [1] = "Czerwony",
                    },
                },
                electronic_mood_color = {
                    label = "Kolor światła",
                    values = {
                        [0] = "Wył.",
                        [1] = "Czerwony",
                        [10] = "Lipa",
                        [11] = "Turkusowy",
                        [12] = "Indygo",
                        [13] = "Białe",
                        [14] = "Ciepły biały",
                        [15] = "Zimna biała",
                        [16] = "Amber",
                        [2] = "Niebieski",
                        [3] = "Zielony",
                        [4] = "Cyanowy",
                        [5] = "Purpurowy",
                        [6] = "Żółty",
                        [7] = "Pomarańczowy",
                        [8] = "Fioletowy",
                        [9] = "Różowy",
                    },
                },
                electronic_mood_intensity = {
                    label = "Intensywność światła",
                    values = {
                        [0] = "Ciemne",
                        [1] = "Normalna",
                        [2] = "Jasny",
                    },
                },
                electronic_radio_power = {
                    label = "Zasilanie radiowe",
                    values = {
                        [0] = "Wył.",
                        [1] = "Wł.",
                    },
                },
                electronic_throttle_response = {
                    label = "Odpowiedź na trąd",
                    values = {
                        [0] = "Więcej trakcji",
                        [1] = "Agresywny",
                    },
                },
                electronic_wheelie_tune = {
                    label = "Tune Wheelie",
                    values = {
                        [0] = "Wył.",
                        [1] = "Miękki",
                        [2] = "Intensywny",
                    },
                },
            },
            vehicleClassLabel = "Klasa {id} ({name})",
        },
    },
}
