JobConfigLocales["sky_ambulancejob:pl"] = {
    Nui = {
        tablet = {
            apps = {
                medicalEvaluations = "Orzeczenia medyczne",
                sharedMedicalEvaluations = "Udostępnione orzeczenia medyczne",
            },
        },
        workshopConfig = {
            creatorFields = {
                hospitalBeds = {
                    allowRespawn = {
                        label = "Pozwol na respawn",
                        description = "Okresla, czy to lozko moze byc uzywane do odradzania graczy.",
                    },
                },
            },
            configs = {
                sky_ambulancejob = {
                    subtitle = "Skonfiguruj zadania ambulansów, łóżka szpitalne, systemy śmierci, interakcje i podstawowe ustawienia funkcji.",
                    title = "Praca w ambulansie",
                },
            },
            dispatchActions = {
                currentLocation = "Użyj bieżącej lokalizacji",
                addChannel = "Dodaj kanał radiowy",
                addKeyword = "Dodaj słowo kluczowe",
                addPoi = "Dodaj punkt POI",
                addReporter = "Dodaj zgłaszającego",
                addStatus = "Dodaj status FMS",
                addVehicle = "Dodaj jednostkę wirtualną",
                addVehicleType = "Dodaj typ jednostki",
            },
            dispatchFieldDescriptions = {
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
                minimumCrew = "Minimalna liczba personelu w jednostkach wybranych do tego planu reagowania.",
                noUnitFallback = "Bez centrum lub zespołu, wysyła powiadomienie Sky do wszystkich członków na służbie.",
                radius = "Maksymalna odległość w metrach, na której można usłyszeć ogłoszenie stacji.",
                requirements = "Zapotrzebowanie na odpowiedź jako typ: pary COUNT, na przykład PATROL: 2, CRIME: 1.",
                statusCode = "Numeryczny status FMS pokazany na palmtopie.",
                statusLabel = "Znaczenie statusu FMS dla dyspozytorów i jednostek.",
                vehicleType = "Musi pasować do kodu typu pojazdu skonfigurowanego w poprzedniej podsekcji.",
                vehicleTypeCode = "Krótki kod jednostki stosowany w wymogach dotyczących odpowiedzi, na przykład PATROL, CRIME, EMS lub RESCUE.",
                vehicleTypeLabel = "Czytelna nazwa tej kategorii jednostek.",
                crewCapacity = "Maksymalna liczba osób w jednostce. Wartość 0 oznacza nieograniczoną załogę.",
                joinLocked = "Uniemożliwia kolejnym osobom dołączenie po obsadzeniu jednostki.",
                poiId = "Stały identyfikator techniczny dostępny dla profili dyspozytorni także po zmianie nazwy punktu.",
                readyStatusCode = "Status FMS ustawiany, gdy zasób staje się gotowy do zadysponowania.",
                resourceType = "Klasyfikuje zasób operacyjny na potrzeby filtrów i koordynacji dyspozytorni.",
                respondingStatusCode = "Status FMS ustawiany, gdy zasób wyjeżdża do zdarzenia.",
                shortLabel = "Opcjonalna krótka etykieta na sześciu przyciskach pamięci kanałów radiowych.",
                stationId = "Przypisuje jednostkę do stacji skonfigurowanej w profilu dyspozytorni.",
                unitId = "Stały identyfikator techniczny zachowujący jednostkę po zmianie jej kryptonimu.",
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
                defaultChannel = "Domyślny kanał radiowy",
                emergencyAppEnabled = "Pokaż w aplikacji awaryjnej",
                enabled = "Włącz wysyłkę",
                icon = "Ikona",
                incidentAssessmentEnabled = "Włącz ocenę sytuacji wyjątkowej",
                jobs = "Miejsca pracy docelowe (oddzielone przecinkami)",
                keywordCode = "Kod słów kluczowych",
                label = "Etykieta",
                minimumCrew = "Minimalna załoga",
                name = "Nazwa",
                noUnitFallback = "Informuj pracowników na służbie bez jednostek",
                noneChannel = "Domyślny brak / grupa",
                note = "Uwaga",
                phone = "Telefon",
                radius = "Promień ogłoszenia",
                requirements = "Wymagane jednostki (na przykład PATROL: 2, CRIME: 1)",
                type = "Typ",
                vehicleType = "Typ jednostki odpowiedzi",
                crewCapacity = "Pojemność załogi",
                joinLocked = "Zablokuj dołączanie załogi",
                poiId = "Stały identyfikator punktu POI",
                readyStatusCode = "Kod statusu gotowości",
                resourceType = "Typ zasobu",
                respondingStatusCode = "Kod statusu wyjazdu",
                shortLabel = "Etykieta pamięci radia",
                stationId = "Identyfikator stacji",
                unitId = "Stały identyfikator jednostki",
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
                    statuses = "Dostępne FMS",
                    units = "Jednostki wirtualne",
                    reporters = "Znani zgłaszający",
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
                dispatchStatusCodes = "Konfiguruje etykiety statusu FMS i które statusy liczą się jako dostępne dla nowych incydentów.",
                dispatchVehicleTypes = "Określa kategorie jednostek stosowane w planach reagowania, takie jak Patrol, Wydział Przestępczości, EMS lub Rescue.",
                dispatchVehicles = "Określa wirtualne pojazdy wysyłające, które mogą być obsługiwane z dowolnego miejsca bez konieczności posiadania pojazdu tarłowego.",
                dispatchReporters = "Zarządza nazwami zgłaszających, numerami zwrotnymi i notatkami dyspozytorni dla tej pracy.",
            },
            extensions = {
                invalidSelection = "Nieprawidłowy wybór: {value}",
                trainingSettings = {
                    description = "Konfiguracja dostępu do szkoleń, rejestracji, zatwierdzeń i planowania kursu dla tej pracy.",
                    label = "Ustawienia treningu",
                },
                dispatchReporters = "Znani zgłaszający",
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
            },
            features = {
                bleeding = {
                    description = "Włącz układ odpowietrzający.",
                    label = "Krwawienie",
                },
                bodybags = {
                    description = "Włącz worki na zwłoki i przepływ dostaw worków na zwłoki.",
                    label = "Torby na ciało",
                },
                consciousScenarioBloodPressure = {
                    description = "Pozwól na kontrolę ciśnienia krwi, gdy pacjent jest przytomny.",
                    label = "Świadome ciśnienie krwi",
                },
                deathTimeout = {
                    description = "Włącz przepływ limitu czasu śmierci.",
                    label = "Limit czasu śmierci",
                },
                fractures = {
                    description = "Umożliwia opatrzenie i leczenie złamań.",
                    label = "Złamania",
                },
                knockout = {
                    description = "Włącz system pucharowy.",
                    label = "Nokaut",
                },
                legShotRagdoll = {
                    description = "Powoduje upadek po trafieniu w ustawione strefy nóg lub stóp.",
                    label = "Upadek po postrzale nogi",
                },
                pain = {
                    description = "Włącz system przeciwbólowy.",
                    label = "Ból",
                },
                respawnInBed = {
                    description = "Respawn ożywiał graczy w szpitalnym łóżku, jeśli było to możliwe.",
                    label = "Odrodzenie w łóżku",
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
                gang = "GANG",
                allowInVehicle = "Zezwól w pojeździe",
                allowMovement = "Zezwól na ruch",
                animDict = "Słownik animacji",
                animFlag = "Flaga animacji",
                animName = "Nazwa animacji",
                bleeding = "Krwawienie",
                cause = "Przyczyna",
                chance = "Szansa",
                class = "Klasa",
                companyPrice = "Cena firmowa",
                companyPricePerEmployee = "Cena za pracownika",
                copayPercent = "Kopiuj%",
                description = "Opis",
                dictionary = "Słownik animacji",
                duration = "Czas trwania",
                durationMs = "Czas trwania (ms)",
                effect = "Efekt",
                effectDurationMs = "Czas efektu (ms)",
                effectDurationSeconds = "Czas efektu (sekundy)",
                enabled = "Włączone",
                extractionType = "Typ usunięcia",
                foreignObject = "Ciało obce",
                heal = "Leczenie",
                id = "ID",
                itemName = "Nazwa przedmiotu",
                key = "Klucz",
                label = "Etykieta",
                lang = "Język",
                limit = "Limit",
                lossPerSecond = "Utrata na sekundę",
                max = "Maksimum",
                min = "Minimalny",
                minGrade = "Ocena minimalna",
                minigame = "Minigra",
                model = "Model rekwizytu",
                name = "Nazwa stanowiska",
                options = "Opcje (typy wyboru)",
                pain = "Ból",
                pauseBleedingSeconds = "Wstrzymaj krwawienie (sekundy)",
                price = "Cena",
                progressbarAllowInVehicle = "Postęp: zezwól w pojeździe",
                progressbarAllowMovement = "Postęp: zezwól na ruch",
                progressbarCanCancel = "Postęp można anulować",
                progressbarDisableCarMovement = "Postęp: zablokuj ruch pojazdu",
                progressbarDisableCombat = "Postęp: zablokuj walkę",
                progressbarDisableMouse = "Postęp: zablokuj mysz",
                progressbarDisableMovement = "Postęp: zablokuj ruch",
                progressbarDisableSprint = "Postęp: zablokuj sprint",
                progressbarDuration = "Czas postępu",
                progressbarEnabled = "Pasek postępu włączony",
                progressbarLabel = "Tekst postępu",
                progressbarUseWhileDead = "Dostępne po śmierci",
                questions = "Pytania",
                requireItems = "Wymagaj przedmiotów",
                required = "Wymagane",
                requiresExtraction = "Wymaga usunięcia",
                requiresOpenWound = "Wymaga otwartej rany",
                sort = "Kolejność",
                state = "Stan",
                stopBleeding = "Zatrzymaj krwawienie",
                threshold = "Próg",
                time = "Czas",
                type = "Typ",
                useAnimation = "Użyj animacji",
                value = "Wartość",
                zone = "Strefa",
                zones = "Strefy",
                systolic = "Ciśnienie skurczowe",
                diastolic = "Ciśnienie rozkurczowe",
                cardiacArrest = "Zatrzymanie akcji serca",
            },
            settingGroups = {
                billingGeneral = {
                    label = "Ogólny",
                },
                billingRange = {
                    label = "Zakres",
                },
                billingReasons = {
                    label = "Wstępne ustawienia powodów",
                },
                billingUi = {
                    label = "UI",
                },
                bodyBagAnimation = {
                    label = "Ożywienie",
                },
                bodyBagAttachGeneral = {
                    label = "Przytwierdzać",
                },
                bodyBagAttachOffsets = {
                    label = "Przesunięcia",
                },
                bodyBagAttachRotation = {
                    label = "Obrót",
                },
                bodyBagDeliveryGeneral = {
                    label = "Ogólny",
                },
                bodyBagDeliveryRewardGeneral = {
                    label = "Ogólny",
                },
                bodyBagDeliveryRewardPayment = {
                    label = "Zapłata",
                },
                bodyBagDeliveryUi = {
                    label = "UI",
                },
                bodyBagGeneral = {
                    label = "Ogólny",
                },
                crutchAssign = {
                    label = "Zadanie",
                },
                crutchDuration = {
                    label = "Czas trwania",
                },
                crutchGeneral = {
                    label = "Ogólny",
                },
                crutchItems = {
                    label = "Przedmiot",
                },
                crutchRestrictions = {
                    label = "Ograniczenia",
                },
                damageHandlingBladeWeapons = {
                    label = "Broń Ostrza",
                },
                damageHandlingBleedingBlacklist = {
                    label = "Krwawiąca czarna lista",
                },
                damageHandlingBleedingClasses = {
                    label = "Zajęcia dotyczące krwawienia",
                },
                damageHandlingBloodSystem = {
                    label = "Układ Krwi",
                },
                damageHandlingDeathInjuries = {
                    label = "Urazy śmiertelne",
                },
                damageHandlingInjuryEffects = {
                    label = "Skutki kontuzji",
                },
                damageHandlingInjuryThresholds = {
                    label = "Progi urazów",
                },
                damageHandlingLegShotRagdoll = {
                    label = "Ragdoll po strzale w noge",
                },
                damageHandlingLegShotRagdollZones = {
                    label = "Strefy strzalu w noge",
                },
                damageHandlingLiveDamageFractures = {
                    label = "Złamania na żywo",
                },
                damageHandlingLiveDamageFracturesZones = {
                    label = "Szanse Strefy",
                },
                damageHandlingLiveOpenWoundStacks = {
                    label = "Stosy otwartych ran",
                },
                damageHandlingLiveOpenWoundStacksZones = {
                    label = "Limity stref",
                },
                damageHandlingLiveWoundBleedingClass = {
                    label = "Zajęcia z ranami na żywo",
                },
                damageHandlingMedications = {
                    label = "Leki",
                },
                damageHandlingPainClasses = {
                    label = "Zajęcia dotyczące bólu",
                },
                damageHandlingPainEffects = {
                    label = "Skutki bólowe",
                },
                damageHandlingStatusEffects = {
                    label = "Efekty stanu",
                },
                damageHandlingVehicleDamage = {
                    label = "Uszkodzenie pojazdu",
                },
                damageHandlingVehicleImpactCauses = {
                    label = "Przyczyny uszkodzeń",
                },
                damageHandlingVehicleImpactInjuries = {
                    label = "Kontuzje",
                },
                damageHandlingVehicleImpactProtection = {
                    label = "Ochrona przed uderzeniami pojazdu",
                },
                deathAnimal = {
                    label = "Powrót zwierząt",
                },
                deathAnimalAnimation = {
                    label = "Animacja zwierząt",
                },
                deathAnimation = {
                    label = "Ożywienie",
                },
                deathGeneral = {
                    label = "Ogólny",
                },
                deathModels = {
                    label = "Na zastąpienie modelu",
                },
                deathScreenAiMedic = {
                    label = "Ogólny",
                },
                deathScreenAiMedicAvailability = {
                    label = "Dostępność",
                },
                deathScreenAiMedicBehaviour = {
                    label = "Zachowanie",
                },
                deathScreenAiMedicForceRevive = {
                    label = "Wymuś ożywienie",
                },
                deathScreenAiMedicPayment = {
                    label = "Zapłata",
                },
                deathScreenAiMedicReviveInBed = {
                    label = "Ożywienie w łóżku",
                },
                deathScreenAiMedicSpawn = {
                    label = "Ikra",
                },
                deathScreenAiMedicTiming = {
                    label = "Chronometraż",
                },
                deathScreenControls = {
                    label = "Sterownica",
                },
                deathScreenDamageLogs = {
                    label = "Logi obrażeń",
                },
                deathScreenDimensions = {
                    label = "Wymiary",
                },
                deathScreenDispatch = {
                    label = "Załatwić",
                },
                deathScreenEarlyRespawn = {
                    label = "Ogólny",
                },
                deathScreenEarlyRespawnAvailability = {
                    label = "Dostępność",
                },
                deathScreenEarlyRespawnPayment = {
                    label = "Zapłata",
                },
                deathScreenGeneral = {
                    label = "Ogólny",
                },
                deathScreenHospitalSelection = {
                    label = "Wybór szpitala",
                },
                deathScreenHospitalSelectionCamera = {
                    label = "Kamera Wyborowa",
                },
                deathScreenInformation = {
                    label = "Ogólny",
                },
                deathScreenIntegration = {
                    label = "Integracja",
                },
                deathScreenLogs = {
                    label = "Logi śmierci",
                },
                deathScreenMinigame = {
                    label = "Minigra",
                },
                deathScreenRespawn = {
                    label = "Ogólny",
                },
                deathScreenRespawnAccounts = {
                    label = "Konta",
                },
                deathScreenRespawnFallback = {
                    label = "Współrzędne zastępcze",
                },
                deathScreenRespawnItems = {
                    label = "Rzeczy",
                },
                deathScreenRespawnWeapons = {
                    label = "Broń",
                },
                deathScreenStyle = {
                    label = "Styl ekranu śmierci",
                },
                deathScreenVoice = {
                    label = "Głos",
                },
                deathTimeoutGeneral = {
                    label = "Ogólny",
                },
                deathTimeoutWhitelist = {
                    label = "Oferty pracy na białej liście",
                },
                diagnoseAnim = {
                    label = "Ożywienie",
                },
                diagnoseCpr = {
                    label = "CPR",
                },
                diagnoseFullHeal = {
                    label = "Pełne leczenie",
                },
                diagnoseGeneral = {
                    label = "Ogólny",
                },
                doctorNpcAvailability = {
                    label = "Dostępność",
                },
                doctorNpcGeneral = {
                    label = "Ogólny",
                },
                doctorNpcHealOther = {
                    label = "Uzdrów Innego",
                },
                doctorNpcHealSelf = {
                    label = "Uzdrów siebie",
                },
                doctorNpcRanges = {
                    description = "Zasięgi te nie wpływają na to, jak blisko musi znajdować się gracz, aby otworzyć interakcję z lekarzem NPC. Obowiązują one dopiero po otwarciu menu lekarza.",
                    label = "Zakresy",
                },
                doctorNpcRevive = {
                    label = "Wskrzesić",
                },
                doctorNpcReviveInBed = {
                    label = "Ożywienie w łóżku",
                },
                firstAidAnimation = {
                    label = "Ożywienie",
                },
                firstAidGeneral = {
                    label = "Ogólny",
                },
                firstAidLicenseAdd = {
                    label = "Dodaj licencję",
                },
                firstAidLicenseRemove = {
                    label = "Usuń licencję",
                },
                firstAidPosition = {
                    label = "Pozycja",
                },
                healthInsuranceExpiration = {
                    label = "Wygaśnięcie",
                },
                healthInsuranceGeneral = {
                    label = "Ogólny",
                },
                healthInsurancePayment = {
                    label = "Zapłata",
                },
                healthInsuranceProviders = {
                    label = "Dostawcy",
                },
                hospitalBedsBedAnimation = {
                    label = "Animacja łóżka",
                },
                hospitalBedsCreator = {
                    label = "Twórca",
                },
                hospitalBedsDistances = {
                    label = "Odległości",
                },
                hospitalBedsGeneral = {
                    label = "Ogólny",
                },
                hospitalBedsGetupAnimation = {
                    label = "Animacja wstawania",
                },
                hospitalBedsModels = {
                    label = "Modele",
                },
                hospitalBedsOffsets = {
                    label = "Przesunięcia",
                },
                hospitalBlip = {
                    label = "Szpitalny Blip",
                },
                imagingGeneral = {
                    label = "Ogólny",
                },
                imagingRanges = {
                    label = "Zakresy",
                },
                keybinds = {
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                    label = "Klawisze",
                },
                knockoutGeneral = {
                    label = "Ogólny",
                },
                knockoutWeapons = {
                    label = "Broń",
                },
                medicCarryAttach = {
                    label = "Przytwierdzać",
                },
                medicCarryAttachOffsets = {
                    label = "Przesunięcia",
                },
                medicCarryAttachRotation = {
                    label = "Obrót",
                },
                medicCarryCarrierAnimation = {
                    label = "Animacja przewoźnika",
                },
                medicCarryGeneral = {
                    label = "Ogólny",
                },
                medicCarryPassengerAnimation = {
                    label = "Animacja pasażerska",
                },
                medicCarryRestrictions = {
                    label = "Ograniczenia",
                },
                medicRevivePersistence = {
                    label = "Ogólny",
                },
                medicalEvaluationRecipients = {
                    label = "Zawódy odbiorcy",
                },
                medicalEvaluationSharing = {
                    label = "Pola wspólne",
                },
                medicalEvaluationTypes = {
                    label = "Typy oceny",
                },
                medicalEvaluationsGeneral = {
                    label = "Ogólny",
                },
                medicalWearablesArmRestrictions = {
                    label = "Ograniczenia gipsu na ramieniu",
                },
                medicalWearablesCasts = {
                    label = "Gipsy",
                },
                medicalWearablesDuration = {
                    label = "Czas noszenia",
                },
                medicalWearablesGeneral = {
                    label = "Ogólne",
                },
                medicalWearablesHeadBandage = {
                    label = "Bandaż głowy",
                },
                medicalWearablesLegRestrictions = {
                    label = "Ograniczenia gipsu na nodze",
                },
                medicalWearablesNeckBrace = {
                    label = "Kołnierz ortopedyczny",
                },
                medicalWearablesOxygenMask = {
                    label = "Maska tlenowa",
                },
                medicalWearablesPatientHud = {
                    label = "HUD pacjenta",
                },
                medicalWearablesRemoval = {
                    label = "Usuwanie",
                },
                medicalWearablesSplints = {
                    label = "Szyny",
                },
                medicalWearablesTorsoBandage = {
                    label = "Bandaż tułowia",
                },
                minigamesCprGeneral = {
                    label = "Ogólny",
                },
                minigamesEnabled = {
                    label = "Włączony",
                },
                minigamesVentilationGeneral = {
                    label = "Ogólny",
                },
                operationsAnesthesia = {
                    label = "Znieczulenie",
                },
                operationsDistances = {
                    label = "Odległości",
                },
                operationsDoctorAnimation = {
                    label = "Animacja chirurga",
                },
                operationsGeneral = {
                    label = "Ogólne",
                },
                operationsPatientAnimation = {
                    label = "Animacja pacjenta",
                },
                operationsTrainingAnimation = {
                    label = "Animacja treningowa",
                },
                propPlacement = {
                    label = "Umiejscowienie rekwizytów",
                },
                propPlacementItems = {
                    label = "Przedmioty rekwizytów",
                },
                publicTreatmentGeneral = {
                    label = "Ogólny",
                },
                publicTreatmentJobs = {
                    label = "Dozwolone prace",
                },
                publicTreatmentRequirements = {
                    label = "Wymagania",
                },
                reviveRewardGeneral = {
                    label = "Ogólny",
                },
                reviveRewardPayment = {
                    label = "Zapłata",
                },
                selfDiagnoseGeneral = {
                    label = "Ogólny",
                },
                stretcherAnimation = {
                    label = "Ożywienie",
                },
                stretcherCarryAttach = {
                    label = "Noś Dołącz",
                },
                stretcherFolded = {
                    label = "Wariant składany",
                },
                stretcherFoldedPatientAttach = {
                    label = "Złożony element mocujący pacjenta",
                },
                stretcherGeneral = {
                    label = "Ogólny",
                },
                stretcherHelicopter = {
                    label = "Śmigłowiec",
                },
                stretcherPatientAttach = {
                    label = "Dołącz pacjenta",
                },
                stretcherTreatmentAnim = {
                    label = "Ożywienie",
                },
                stretcherVehicleAttach = {
                    label = "Załącznik pojazdu",
                },
                stretcherVehicleLists = {
                    label = "Modele pojazdów",
                },
                treatmentAnim = {
                    label = "Ożywienie",
                },
                treatmentEnable = {
                    label = "Włączać",
                },
                trunk = {
                    label = "Pień",
                },
                vehiclePullGeneral = {
                    label = "Ogólny",
                },
                wheelchairAssign = {
                    label = "Zadanie",
                },
                wheelchairDuration = {
                    label = "Czas trwania",
                },
                wheelchairGeneral = {
                    label = "Ogólny",
                },
                wheelchairItems = {
                    label = "Przedmiot",
                },
                wheelchairRestrictions = {
                    label = "Ograniczenia",
                },
                xrayGeneral = {
                    label = "Ogólny",
                },
                xrayRanges = {
                    label = "Zakresy",
                },
                appointmentsGeneral = {
                    label = "Ogólny",
                },
                appointmentsLimits = {
                    label = "Limity",
                },
                appointmentsNotifications = {
                    label = "Powiadomienia",
                },
                appointmentsScheduling = {
                    label = "Planowanie",
                },
                healthCompatibility = {
                    label = "Zgodność zdrowotna",
                },
                minigamesBloodTransfusionGeneral = {
                    label = "Ogólny",
                },
                minigamesRandomization = {
                    label = "Randomizacja",
                },
            },
            settingSections = {
                billing = "Rozliczenia",
                bodyBag = "Torba na ciało",
                damageHandling = "Obsługa szkód",
                death = "Śmierć",
                deathScreen = "Ekran Śmierci",
                diagnose = "Rozpoznać chorobę",
                doctorNpc = "Lekarz NPC",
                general = "Ogólny",
                healthInsurance = "Ubezpieczenie zdrowotne",
                hospitalBeds = "Łóżka szpitalne",
                knockout = "Nokaut",
                medicCarry = "Noszenie Medyka",
                minigames = "Minigry",
                mobilityAid = "Pomoce w poruszaniu się",
                operations = "Operacje",
                organization = "Organizacja",
                rewards = "Nagrody",
                treatment = "Leczenie",
                vehiclePull = "Ciągnięcie pojazdu",
            },
            settingSubsections = {
                aiMedic = "Medyk AI",
                anesthesia = "Znieczulenie",
                animation = "Ożywienie",
                animations = "Animacje",
                attach = "Przytwierdzać",
                bedAnimation = "Animacja łóżka",
                blood = "Krew",
                bodyBagDeliveryReward = "Nagroda za dostawę worka na zwłoki",
                carrierAnimation = "Animacja przewoźnika",
                classification = "Klasyfikacja",
                cpr = "CPR",
                crutch = "Krocze",
                deathInjuries = "Urazy śmiertelne",
                deathScreenStyle = "Styl ekranu śmierci",
                deathTimeout = "Limit czasu śmierci",
                delivery = "Dostawa",
                diagnoseAnim = "Diagnozuj animację",
                dispatch = "Załatwić",
                earlyRespawn = "Wczesne odrodzenie",
                effects = "Ruchomości",
                firstAid = "Pierwsza pomoc",
                general = "Ogólny",
                getupAnimation = "Animacja wstawania",
                imaging = "Obrazowanie",
                information = "Informacja",
                keybinds = "Klawisze",
                liveDamage = "Uszkodzenia na żywo",
                logs = "Logi",
                medicRevivePersistence = "Trwałość Ożywienia Medyka",
                medicalEvaluations = "Orzeczenia medyczne",
                medicalWearables = "Pomoce medyczne",
                medications = "Leki",
                minigame = "Minigra",
                passengerAnimation = "Animacja pasażerska",
                pricing = "Wycena",
                propPlacement = "Umiejscowienie rekwizytów",
                publicTreatment = "Traktowanie publiczne",
                respawn = "Odrodzenie",
                reviveInBed = "Ożywienie w łóżku",
                reviveReward = "Nagroda za ożywienie",
                selfDiagnose = "Samodiagnoza",
                stretcher = "Nosze",
                stretcherTreatmentAnim = "Animacja leczenia noszami",
                thresholds = "Progi",
                treatmentAnim = "Animacja leczenia",
                trunk = "Pień",
                vehicleImpact = "Uderzenie pojazdu",
                ventilation = "Wentylacja",
                wheelchair = "Wózek inwalidzki",
                xray = "X- Ray",
                appointments = "Wizyty",
                bloodTransfusion = "Transfuzja krwi",
            },
            settings = {
                ambulanceEditorControl172 = {
                    label = "Edytor · Sterowanie 172",
                    description = "Konfiguracje: Edytor: Przesuń się.",
                },
                ambulanceEditorControl173 = {
                    label = "Edytor · Sterowanie 173",
                    description = "Konfiguracje: Edytor: Przesuń się w dół.",
                },
                ambulanceEditorControl174 = {
                    label = "Edytor · Sterowanie 174",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceEditorControl175 = {
                    label = "Edytor · Sterowanie 175",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceEditorControl177 = {
                    label = "Edytor · Sterowanie 177",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceEditorControl201 = {
                    label = "Edytor · Sterowanie 201",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceEditorControl202 = {
                    label = "Edytor · Sterowanie 202",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceEditorControl21 = {
                    label = "Edytor · Sterowanie 21",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceEditorControl32 = {
                    label = "Edytor · Sterowanie 32",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceEditorControl33 = {
                    label = "Edytor · Sterowanie 33",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceEditorControl34 = {
                    label = "Edytor · Sterowanie 34",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceEditorControl35 = {
                    label = "Edytor · Sterowanie 35",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceEditorControl36 = {
                    label = "Edytor · Sterowanie 36",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceEditorControl37 = {
                    label = "Edytor · Sterowanie 37",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceEditorControl38 = {
                    label = "Edytor · Sterowanie 38",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceEditorControl44 = {
                    label = "Edytor · Sterowanie 44",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceFirstAidControl38 = {
                    label = "Pierwsza pomoc · Sterowanie 38",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceStretcherEditorControl177 = {
                    label = "Interakcja · Sterowanie 177",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceStretcherEditorControl201 = {
                    label = "Interakcja · Sterowanie 201",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceStretcherEditorControl202 = {
                    label = "Interakcja · Sterowanie 202",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceStretcherEditorControl21 = {
                    label = "Interakcja · Sterowanie 21",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceStretcherEditorControl241 = {
                    label = "Interakcja · Sterowanie 241",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceStretcherEditorControl242 = {
                    label = "Interakcja · Sterowanie 242",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceStretcherEditorControl25 = {
                    label = "Interakcja · Sterowanie 25",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceStretcherEditorControl32 = {
                    label = "Interakcja · Sterowanie 32",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceStretcherEditorControl33 = {
                    label = "Interakcja · Sterowanie 33",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceStretcherEditorControl34 = {
                    label = "Interakcja · Sterowanie 34",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceStretcherEditorControl35 = {
                    label = "Interakcja · Sterowanie 35",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceStretcherEditorControl36 = {
                    label = "Interakcja · Sterowanie 36",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceStretcherEditorControl38 = {
                    label = "Interakcja · Sterowanie 38",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                ambulanceStretcherEditorControl44 = {
                    label = "Interakcja · Sterowanie 44",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                billingAccount = {
                    description = "Starsze konto zastępcze używane do rozliczeń.",
                    label = "Konto",
                },
                billingCloseOnSuccess = {
                    description = "Zamknij interfejs rozliczeniowy automatycznie po pomyślnym wystawieniu rachunku.",
                    label = "Blisko sukcesu",
                },
                billingCurrency = {
                    description = "Opcjonalny klucz walutowy używany do płatności rozliczeniowych.",
                    label = "Waluta",
                },
                billingCustomBillingReasons = {
                    description = "Zezwalaj lekarzom na wprowadzanie niestandardowych powodów rozliczeń.",
                    label = "Niestandardowe powody",
                },
                billingDepositToSociety = {
                    description = "Wpłacaj przychody z rozliczeń na konto towarzystwa.",
                    label = "Depozyt na rzecz społeczeństwa",
                },
                billingEnabled = {
                    description = "Włącz system rozliczeń medycznych.",
                    label = "Włączony",
                },
                billingMaxReasonLength = {
                    description = "Maksymalna długość niestandardowych powodów rozliczeń.",
                    label = "Maksymalna długość powodu",
                },
                billingMode = {
                    description = "Wybierz, czy rachunki medyczne mają być naliczane natychmiast, wymagają potwierdzenia, czy też skorzystaj z ramowego systemu rozliczeniowego.",
                    label = "Tryb rozliczeniowy",
                    options = {
                        consent = "Zapłać lub odrzuć",
                        framework = "Projekt ustawy ramowej",
                        instant = "Natychmiastowe ładowanie",
                    },
                },
                billingRange = {
                    description = "Maksymalny zakres wyszukiwania płatnych pacjentów.",
                    label = "Zakres",
                },
                billingReasonPresets = {
                    description = "Wstępnie ustawione powody rozliczeń wyświetlane w interfejsie rozliczeniowym.",
                    itemLabel = "Powód",
                    label = "Wstępne ustawienia powodów",
                },
                billingRefreshSeconds = {
                    description = "Sekundy pomiędzy odświeżeniami rozliczanych graczy.",
                    label = "Odśwież sekundy",
                },
                bladeWeapons = {
                    description = "Nazwy broni lub skróty, które należy klasyfikować jako obrażenia od noża, a nie tępe.",
                    itemLabel = "Broń",
                    label = "Broń ostrzowa",
                },
                bleedingBlacklist = {
                    description = "Broń, która nigdy nie powinna powodować żywego krwawienia ani otwartych ran.",
                    itemLabel = "Broń",
                    label = "Krwawiąca czarna lista",
                },
                bleedingClassesProfiles = {
                    description = "Profile ciężkości krwawień i tempo utraty krwi.",
                    label = "Zajęcia z krwawienia",
                },
                bloodSystemDebugLogInterval = {
                    description = "Sekundy pomiędzy komunikatami dziennika debugowania układu krwi.",
                    label = "Interwał dziennika debugowania",
                },
                bloodSystemMaxVolume = {
                    description = "Maksymalna wartość objętości krwi używana przez system stanu pacjenta.",
                    label = "Maksymalna głośność",
                },
                bloodSystemRegenPerSecond = {
                    description = "Pasywna regeneracja krwi stosowana, gdy pacjent nie aktywnie krwawi.",
                    label = "Regeneracja na sekundę",
                },
                bloodSystemTickIntervalMs = {
                    description = "Interwał czasowy serwera używany do aktualizacji utraty krwi i odzyskiwania.",
                    label = "Zaznacz interwał ms",
                },
                bloodSystemUnconsciousThreshold = {
                    description = "Próg objętości krwi, poniżej którego pacjent traci przytomność.",
                    label = "Nieświadomy próg",
                },
                bodyBagAnimationDict = {
                    description = "Słownik animacji służący do noszenia worka na zwłoki.",
                    label = "Słownik animacji",
                },
                bodyBagAnimationEnabled = {
                    description = "Użyj dedykowanej animacji przenoszenia podczas noszenia worka na ciało.",
                    label = "Włączony",
                },
                bodyBagAnimationFlag = {
                    description = "Flaga TaskPlayAnim używana do animacji przenoszenia.",
                    label = "Flaga animacji",
                },
                bodyBagAnimationName = {
                    description = "Klip animacyjny przedstawiający noszenie worka na zwłoki.",
                    label = "Nazwa animacji",
                },
                bodyBagAttachBone = {
                    description = "Nazwa kości stopy lub identyfikator kości używany do mocowania worka na ciało.",
                    label = "Kość",
                },
                bodyBagAttachRx = {
                    description = "Torba na ciało mocuje obrót X.",
                    label = "Dołącz RX",
                },
                bodyBagAttachRy = {
                    description = "Torba na ciało mocuje obrót Y.",
                    label = "Dołącz RY",
                },
                bodyBagAttachRz = {
                    description = "Torba na ciało mocuje obrót Z.",
                    label = "Dołącz RZ",
                },
                bodyBagAttachX = {
                    description = "Torba na ciało mocowana z przesunięciem X.",
                    label = "Dołącz X",
                },
                bodyBagAttachY = {
                    description = "Torba na ciało mocowana z przesunięciem Y.",
                    label = "Dołącz Y",
                },
                bodyBagAttachZ = {
                    description = "Torba na ciało mocowana z przesunięciem Z.",
                    label = "Dołącz Z",
                },
                bodyBagDeliveryHelpLabelKey = {
                    description = "Klucz ustawień regionalnych używany do wyświetlania monitu o pomoc przy zrzuceniu worka na ciało.",
                    label = "Klucz etykiety pomocy",
                },
                bodyBagDeliveryInteractDistance = {
                    description = "Odległość stosowana do sprawdzania zrzutu worka na ciało.",
                    label = "Odległość interakcji",
                },
                bodyBagDeliveryInteractKey = {
                    description = "Identyfikator kontrolny używany do interakcji przy zrzucaniu worków na zwłoki.",
                    label = "Klucz interakcji",
                },
                bodyBagDeliveryInteraction = {
                    description = "Klucz szablonu interakcji używany do podrzucania worków na zwłoki.",
                    label = "Szablon interakcji",
                },
                bodyBagDeliveryRequireDropOff = {
                    description = "Wymagaj od lekarzy przekazywania worków na zwłoki w skonfigurowanych punktach zrzutu.",
                    label = "Wymagaj zrzutu",
                },
                bodyBagDeliveryRequireOnDuty = {
                    description = "Wymagaj, aby lekarze byli na służbie przed dostarczeniem worka na zwłoki.",
                    label = "Wymagaj na służbie",
                },
                bodyBagDeliveryRewardAccount = {
                    description = "Główny klucz konta używany do nagród za dostawę worków na zwłoki.",
                    label = "Konto",
                },
                bodyBagDeliveryRewardAccountType = {
                    description = "Podstawowy typ konta używany do nagród za dostawę worków na zwłoki.",
                    label = "Typ konta",
                },
                bodyBagDeliveryRewardAmount = {
                    description = "Kwota nagrody zapłacona za dostawę worka na zwłoki.",
                    label = "Kwota",
                },
                bodyBagDeliveryRewardCurrency = {
                    description = "Opcjonalny niestandardowy klucz walutowy używany do nagród za dostawę worków na zwłoki.",
                    label = "Waluta",
                },
                bodyBagDeliveryRewardEnabled = {
                    description = "Zapłać skonfigurowaną nagrodę po zakończeniu dostawy worka na zwłoki.",
                    label = "Włączony",
                },
                bodyBagDeliveryRewardPayFromSociety = {
                    description = "Przed zapłaceniem medykowi odlicz nagrody za dostawę worków na zwłoki ze wspólnego stowarzyszenia zawodowego.",
                    label = "Zapłać od społeczeństwa",
                },
                bodyBagEnabled = {
                    description = "Włącz system worków na zwłoki.",
                    label = "Włączony",
                },
                bodyBagHidePatient = {
                    description = "Ukryj łóżko pacjenta, gdy torba na ciało jest przymocowana.",
                    label = "Ukryj pacjenta",
                },
                bodyBagModel = {
                    description = "Model rekwizytu używany do worków na zwłoki.",
                    label = "Wzór",
                },
                bodyBagPatientAlpha = {
                    description = "Alfa zaaplikowana pacjentowi w worku na ciało.",
                    label = "Pacjent alfa",
                },
                crutchAssignMaxDistance = {
                    description = "Maksymalna odległość przydzielenia kuli innemu graczowi.",
                    label = "Przypisz maksymalną odległość",
                },
                crutchAutoUnequipOnExpire = {
                    description = "Automatycznie zdejmij kulę, gdy zadanie wygaśnie.",
                    label = "Automatyczne zdejmowanie po wygaśnięciu",
                },
                crutchClipset = {
                    description = "Zestaw klipów ruchu zastosowany podczas korzystania z kuli.",
                    label = "Zestaw klipów",
                },
                crutchDefaultDurationMinutes = {
                    description = "Domyślnie przypisany czas trwania kuli w minutach.",
                    label = "Domyślny czas trwania",
                },
                crutchDisableSprint = {
                    description = "Blokuj sprint, mając na wyposażeniu kulę.",
                    label = "Wyłącz sprint",
                },
                crutchDisableWeapons = {
                    description = "Blokuj użycie broni, gdy używasz kuli.",
                    label = "Wyłącz broń",
                },
                crutchItemName = {
                    description = "Przedmiot wyposażenia używany do kuli.",
                    label = "Nazwa przedmiotu",
                },
                crutchMaxDurationMinutes = {
                    description = "Maksymalny dozwolony czas przypisania kuli w minutach.",
                    label = "Maksymalny czas trwania",
                },
                crutchMinDurationMinutes = {
                    description = "Minimalny dozwolony czas przypisania kuli w minutach.",
                    label = "Minimalny czas trwania",
                },
                crutchProp = {
                    description = "Model rekwizytu używany do kuli.",
                    label = "Rekwizyt",
                },
                damageLogBatchIntervalSeconds = {
                    description = "Sekundy, przez które pojedyncze trafienia są zbierane w jedną wiadomość.",
                    label = "Interwał grupowania",
                },
                damageLogMaxEntriesPerMessage = {
                    description = "Maksymalna liczba pojedynczych trafień w wiadomości Discord.",
                    label = "Trafienia na wiadomość",
                },
                damageLogsEnabled = {
                    description = "Wysyłaj na Discord potwierdzone przez serwer nieśmiertelne trafienia.",
                    label = "Logi obrażeń",
                },
                deathAnimalAnimationDictionary = {
                    description = "Słownik animacji używany do animacji śmierci zwierzęcia.",
                    label = "Słownik zwierząt",
                },
                deathAnimalAnimationName = {
                    description = "Klip animacyjny wykorzystany w animacji śmierci zwierzęcia.",
                    label = "Nazwa animacji zwierząt",
                },
                deathAnimalUseAnimation = {
                    description = "Zezwalaj skonfigurowanemu rezerwowemu zwierzęciu na używanie scenariuszowej animacji śmierci.",
                    label = "Animacja zwierząt",
                },
                deathAnimationDictionary = {
                    description = "Słownik animacji używany do domyślnej animacji śmierci.",
                    label = "Słownik animacji",
                },
                deathAnimationName = {
                    description = "Klip animacyjny używany w domyślnej animacji śmierci.",
                    label = "Nazwa animacji",
                },
                deathInjuriesProfiles = {
                    description = "Profile kontuzji stosowane, gdy gracz umiera z określonej przyczyny.",
                    itemLabel = "Obrażenia",
                    label = "Obrażenia śmierci",
                },
                deathModels = {
                    description = "Zastąp zachowanie animacji śmierci według modelu ped lub skrótu modelu.",
                    label = "Przesłonięcia modelu",
                },
                deathScreenAiMedicAccount = {
                    description = "Konto główne obciążane za medyka AI.",
                    label = "Konto",
                },
                deathScreenAiMedicAddDeathTimerSeconds = {
                    description = "Sekundy dodawane do licznika wykrwawienia, gdy wezwany jest medyk AI.",
                    label = "Dodaj licznik czasu śmierci",
                },
                deathScreenAiMedicAllowFatalWounds = {
                    description = "Pozwól medykowi AI ożywić śmiertelne rany.",
                    label = "Pozwól na śmiertelne rany",
                },
                deathScreenAiMedicApproachDistance = {
                    description = "Odległość, na której medyk AI zatrzymuje się i podchodzi pieszo.",
                    label = "Odległość podejścia",
                },
                deathScreenAiMedicCooldownSeconds = {
                    description = "Czas odnowienia, zanim będzie można ponownie wezwać medyka AI.",
                    label = "Sekundy odnowienia",
                },
                deathScreenAiMedicCurrency = {
                    description = "Opcjonalny klucz walutowy używany do płatności dla lekarzy AI.",
                    label = "Waluta",
                },
                deathScreenAiMedicCurrencyFormatter = {
                    description = "Formater waluty używany do płatności dla lekarzy AI.",
                    label = "Formater waluty",
                },
                deathScreenAiMedicDespawnDelaySeconds = {
                    description = "Kilka sekund przed zniknięciem medyka AI po ukończeniu.",
                    label = "Opóźnienie odrodzenia",
                },
                deathScreenAiMedicDispatchDelaySeconds = {
                    description = "Opóźnienie przed rozpoczęciem wysyłki medyka AI.",
                    label = "Opóźnienie wysyłki",
                },
                deathScreenAiMedicDriveSpeed = {
                    description = "Prędkość jazdy używana przez pojazd medyczny AI.",
                    label = "Prędkość jazdy",
                },
                deathScreenAiMedicDriveTimeoutSeconds = {
                    description = "Maksymalny czas jazdy przed aktywacją siły ożywienia.",
                    label = "Przekroczono limit czasu jazdy",
                },
                deathScreenAiMedicEnabled = {
                    description = "Włącz przepływ ratownictwa medycznego AI.",
                    label = "Włączony",
                },
                deathScreenAiMedicFallbackAccount = {
                    description = "Konto rezerwowe używane, gdy główne konto lekarza AI nie ma wystarczających środków.",
                    label = "Konto zastępcze",
                },
                deathScreenAiMedicForceReviveEnabled = {
                    description = "Wymuś wskrzeszenie, jeśli medyk AI nie może dotrzeć do gracza.",
                    label = "Wymuś ożywienie włączone",
                },
                deathScreenAiMedicMaxMedicsOnline = {
                    description = "Medyk AI działa tylko wtedy, gdy liczba lekarzy na służbie jest równa lub niższa od tej liczby.",
                    label = "Max medyków online",
                },
                deathScreenAiMedicMissionTimeoutSeconds = {
                    description = "Maksymalny czas trwania misji przed aktywacją ożywienia siłą.",
                    label = "Limit czasu misji",
                },
                deathScreenAiMedicPedModel = {
                    description = "Model Ped używany dla medyka AI.",
                    label = "Model Peda",
                },
                deathScreenAiMedicPlayerRequestMode = {
                    description = "Cel używany, gdy powalony gracz sam wzywa medyka AI.",
                    label = "Cel żądania gracza",
                    options = {
                        hospital = "Szpital",
                        location = "Bieżąca lokalizacja",
                    },
                },
                deathScreenAiMedicPrice = {
                    description = "Cena pobierana za wezwanie lekarza AI.",
                    label = "Cena",
                },
                deathScreenAiMedicRemoteDispatchDelaySeconds = {
                    description = "Sekundy od śmierci gracza, zanim medyk może zaoferować zdalnego medyka AI.",
                    label = "Oczekiwanie na zdalne wysłanie",
                },
                deathScreenAiMedicRemoteDispatchEnabled = {
                    description = "Zezwalaj medykom na wysyłanie medyka AI do powalonego gracza z poziomu mapy wysłania i polecenia /aimedic.",
                    label = "Zdalna wysyłka",
                },
                deathScreenAiMedicRemoteDispatchMaxMedicsOnline = {
                    description = "Zdalna wysyłka medyków AI działa tylko wtedy, gdy liczba lekarzy na służbie jest równa lub niższa od tej liczby.",
                    label = "Zdalna wysyłka max medics online",
                },
                deathScreenAiMedicRemoteDispatchMode = {
                    description = "Cel używany po wysłaniu i zaakceptowaniu zdalnego medyka AI.",
                    label = "Cel zdalnego wysłania",
                    options = {
                        hospital = "Szpital",
                        location = "Bieżąca lokalizacja",
                    },
                },
                deathScreenAiMedicRemoteOfferTimeoutSeconds = {
                    description = "Sekundy, w których gracz może zaakceptować ofertę zdalnego medyka AI.",
                    label = "Limit czasu zdalnej oferty",
                },
                deathScreenAiMedicReviveDistance = {
                    description = "Odległość wymagana, zanim medyk AI zacznie się odradzać.",
                    label = "Odśwież dystans",
                },
                deathScreenAiMedicReviveDurationSeconds = {
                    description = "Sekundy spędzone na ożywieniu gracza.",
                    label = "Czas trwania ożywienia",
                },
                deathScreenAiMedicReviveInBedEnabled = {
                    description = "Teleportuj gracza do łóżka szpitalnego, zamiast reanimować go na miejscu.",
                    label = "Ożyw się w łóżku",
                },
                deathScreenAiMedicReviveInBedSearchRadius = {
                    description = "Promień wyszukiwania używany do znalezienia łóżka ożywiającego.",
                    label = "Promień wyszukiwania łóżka",
                },
                deathScreenAiMedicSecondsTillAvailable = {
                    description = "Kilka sekund po śmierci, zanim medyk AI stanie się dostępny.",
                    label = "Kilka sekund do dostępności",
                },
                deathScreenAiMedicSpawnRadiusMax = {
                    description = "Maksymalny promień odrodzenia medyka AI.",
                    label = "Maksymalny promień spawnu",
                },
                deathScreenAiMedicSpawnRadiusMin = {
                    description = "Minimalny promień odrodzenia medyka AI.",
                    label = "Promień spawnu min",
                },
                deathScreenAiMedicVehicleModel = {
                    description = "Model pojazdu używany przez medyka AI.",
                    label = "Model pojazdu",
                },
                deathScreenAllowVoiceWhileUnconscious = {
                    description = "Tryb głosowy w stanie nieprzytomności: brak, słuchanie lub pełny.",
                    label = "Tryb głosowy",
                    options = {
                        full = "pełny",
                        listen = "Słuchać",
                        none = "nic",
                    },
                },
                deathScreenAllowedControls = {
                    description = "Kontroluj identyfikatory, które pozostają włączone, gdy jesteś nieprzytomny.",
                    label = "Dozwolone kontrole",
                },
                deathScreenAutoRespawnOnExpiredReconnect = {
                    description = "Automatycznie odradzaj graczy, jeśli czas wykrwawienia już minął po rozłączeniu.",
                    label = "Automatyczne odrodzenie wygasło. Połącz ponownie",
                },
                deathScreenBackgroundEnd = {
                    description = "Kolor końcowy tła ekranu śmierci.",
                    label = "Koniec tła",
                },
                deathScreenBackgroundStart = {
                    description = "Kolor początkowy tła ekranu śmierci.",
                    label = "Początek w tle",
                },
                deathScreenBleedOutTimerSeconds = {
                    description = "Sekundy przed upływem czasu wykrwawiania.",
                    label = "Zegar wykrwawienia",
                },
                deathScreenBlockedDimensions = {
                    description = "Wymiary, w których przepływ odradzania się na ekranie śmierci jest zablokowany.",
                    label = "Zablokowane wymiary",
                },
                deathScreenBorderColor = {
                    description = "Kolor obramowania używany na ekranie śmierci.",
                    label = "Kolor obramowania",
                },
                deathScreenDispatchEnabled = {
                    description = "Wysyłaj zdarzenia wysłania z ekranu śmierci.",
                    label = "Wysyłka włączona",
                },
                deathScreenDispatchFallbackJobs = {
                    description = "Zastępczy odbiorcy, gdy żaden główny odbiorca nie żyje i nie jest na służbie. Pozostaw puste, aby zawsze powiadamiać główne zawody.",
                    itemLabel = "Zawód",
                    label = "Zawody zastępcze",
                },
                deathScreenDispatchJobs = {
                    description = "Prace alarmowane, gdy obezwładniony gracz prosi o pomoc.",
                    itemLabel = "Praca",
                    label = "Alarmowane prace",
                },
                deathScreenEarlyRespawnAccount = {
                    description = "Konto główne obciążone opłatą za wcześniejsze odrodzenie.",
                    label = "Konto",
                },
                deathScreenEarlyRespawnAllowFatalWounds = {
                    description = "Zapewnij możliwość wczesnego odrodzenia nawet w przypadku śmiertelnych ran.",
                    label = "Pozwól na śmiertelne rany",
                },
                deathScreenEarlyRespawnCurrency = {
                    description = "Opcjonalny klucz walutowy używany do płatności za wcześniejsze odrodzenie.",
                    label = "Waluta",
                },
                deathScreenEarlyRespawnCurrencyFormatter = {
                    description = "Formater waluty używany do płatności za wcześniejsze odrodzenie.",
                    label = "Formater waluty",
                },
                deathScreenEarlyRespawnEnabled = {
                    description = "Włącz płatne wcześniejsze odrodzenie.",
                    label = "Włączony",
                },
                deathScreenEarlyRespawnFallbackAccount = {
                    description = "Konto rezerwowe używane, gdy na koncie głównym nie ma wystarczających środków.",
                    label = "Konto zastępcze",
                },
                deathScreenEarlyRespawnPaymentLabel = {
                    description = "Opcjonalna etykieta wyświetlana w przypadku płatności za wcześniejsze odrodzenie.",
                    label = "Etykieta płatności",
                },
                deathScreenEarlyRespawnPrice = {
                    description = "Cena pobierana za wcześniejsze odrodzenie.",
                    label = "Cena",
                },
                deathScreenEarlyRespawnRequireNoMedics = {
                    description = "Zezwalaj na wczesne odrodzenie tylko wtedy, gdy żaden medyk nie jest na służbie.",
                    label = "Nie potrzeba medyków",
                },
                deathScreenEarlyRespawnSecondsTillAvailable = {
                    description = "Kilka sekund po śmierci, zanim możliwe będzie wczesne odrodzenie.",
                    label = "Kilka sekund do dostępności",
                },
                deathScreenEnableKeyboard = {
                    description = "Zezwalaj na używanie klawiatury na ekranie śmierci.",
                    label = "Włącz klawiaturę",
                },
                deathScreenExternalVoiceSystem = {
                    description = "Zewnętrzny backend głosowy do wyciszenia, gdy jest włączony.",
                    label = "Zewnętrzny system głosowy",
                    options = {
                        saltychat = "słonychat",
                        yaca = "tak",
                    },
                },
                deathScreenFocusKey = {
                    label = "Obsługa myszy na ekranie śmierci",
                    description = "Domyślny klawisz FiveM, np. E, F6 lub MOUSE_BUTTON:MOUSE_RIGHT. Puste pole oznacza brak domyślnego klawisza. Gracze mogą zmieniać przypisania w ustawieniach FiveM; zapisane przypisania graczy zostają zachowane.",
                },
                deathScreenHandlingMode = {
                    description = "Używa statycznej animacji śmierci lub zachowuje naturalną fizykę ragdoll do ustabilizowania ciała.",
                    label = "Obsługa śmierci",
                    options = {
                        natural = "Naturalna",
                        static = "Statyczna",
                    },
                },
                deathScreenHideOverlayWithoutFocus = {
                    description = "Ukrywa ekran śmierci, gdy SPACJA przełącza na sterowanie grą; wyłącz tę opcję, aby zachować poprzednią widoczną nakładkę.",
                    label = "Ukryj nakładkę przy sterowaniu grą",
                },
                deathScreenHospitalSelectionCameraFocusHeight = {
                    description = "Przesunięcie wysokości zastosowane do celu ostrości kamery.",
                    label = "Wysokość ostrości",
                },
                deathScreenHospitalSelectionCameraFov = {
                    description = "Podgląd pola widzenia kamery.",
                    label = "Pole widzenia",
                },
                deathScreenHospitalSelectionCameraHeadingOffset = {
                    description = "Przesunięcie kursu używane podczas umieszczania kamery podglądowej.",
                    label = "Przesunięcie kursu",
                },
                deathScreenHospitalSelectionCameraHeight = {
                    description = "Przesunięcie wysokości zastosowane do kamery podglądu.",
                    label = "Wysokość aparatu",
                },
                deathScreenHospitalSelectionCameraPitch = {
                    description = "Skok zastosowany do kamery podglądu.",
                    label = "Poziom",
                },
                deathScreenHospitalSelectionCameraRadius = {
                    description = "Odległość od kamery podglądu do punktu odrodzenia.",
                    label = "Promień kamery",
                },
                deathScreenHospitalSelectionCameraTransition = {
                    description = "Użyj płynnego przejścia podczas otwierania kamery wyboru szpitala.",
                    label = "Płynne przejście",
                },
                deathScreenHospitalSelectionEnabled = {
                    description = "Pozwól graczom wybrać szpital przed odrodzeniem.",
                    label = "Wybór szpitala",
                },
                deathScreenHospitalSelectionRequireMultipleHospitals = {
                    description = "Wyświetl wybór szpitala tylko wtedy, gdy istnieje więcej niż jeden szpital.",
                    label = "Wymagają wielu szpitali",
                },
                deathScreenInformationEnabled = {
                    description = "Pokaż blok informacyjny na ekranie śmierci.",
                    label = "Włączony",
                },
                deathScreenInformationShowDeathCause = {
                    description = "Pokaż przyczynę śmierci w bloku informacyjnym na ekranie śmierci.",
                    label = "Pokaż przyczynę śmierci",
                },
                deathScreenInformationShowInjuries = {
                    description = "Pokaż obrażenia w bloku informacyjnym na ekranie śmierci.",
                    label = "Pokaż kontuzje",
                },
                deathScreenInformationShowKiller = {
                    description = "Pokaż nazwisko zabójcy w bloku informacyjnym na ekranie śmierci.",
                    label = "Pokaż zabójcę",
                },
                deathScreenInformationShowWeapon = {
                    description = "Pokaż broń w bloku informacyjnym na ekranie śmierci.",
                    label = "Pokaż broń",
                },
                deathScreenInformationWhitelistedGangs = {
                    label = "Gangi na białej liście",
                    description = "Wybierz wewnętrzne nazwy gangów lub niezależnych organizacji. Zgodny zawód lub gang przyznaje uprawnienie lub wyjątek. Służba jest wymagana tylko dla zawodów.",
                    itemLabel = "GANG",
                },
                deathScreenInformationWhitelistedJobs = {
                    description = "Jobs może zobaczyć rozszerzone informacje o ekranie śmierci.",
                    itemLabel = "Stanowisko",
                    label = "Oferty pracy na białej liście",
                },
                deathScreenLogScreenshotTimeoutSeconds = {
                    description = "Maksymalna liczba sekund na przesłanie każdego zrzutu śmierci.",
                    label = "Limit czasu zrzutu",
                },
                deathScreenLogScreenshots = {
                    description = "Po logu tekstowym prześlij widok ofiary i potwierdzonego zabójcy.",
                    label = "Zrzuty ekranu",
                },
                deathScreenLogsEnabled = {
                    description = "Wysyłaj log Discord przy każdej śmierci gracza.",
                    label = "Logi śmierci",
                },
                deathScreenMedicNearbyRadius = {
                    description = "Odległość w metrach używana do liczenia medyka jako znajdującego się w pobliżu.",
                    label = "Lekarz w pobliżu promienia",
                },
                deathScreenMinigameEnabled = {
                    description = "Włącz minigrę na ekranie śmierci.",
                    label = "Włączony",
                },
                deathScreenMinigameUrl = {
                    description = "Otwarto adres URL minigry na ekranie śmierci.",
                    label = "Adres URL minigry",
                },
                deathScreenMode = {
                    description = "Używa wbudowanego ekranu śmierci lub integracji zewnętrznej.",
                    label = "Tryb ekranu",
                    options = {
                        external = "Zewnętrzny",
                        internal = "Wewnętrzny",
                    },
                },
                deathScreenMuteExternalVoiceOnDeath = {
                    description = "Wycisz zewnętrzne systemy głosowe, gdy gracz nie żyje.",
                    label = "Wycisz głos zewnętrzny",
                },
                deathScreenMutedTextColor = {
                    description = "Wyciszony kolor tekstu używany na ekranie śmierci.",
                    label = "Stłumiony kolor tekstu",
                },
                deathScreenNaturalRagdollDebug = {
                    description = "Wyświetla szczegółowe powody po stronie klienta i serwera, gdy ciało pozostaje w ragdollu.",
                    label = "Debug naturalnego ragdollu",
                },
                deathScreenNaturalStabilizationMode = {
                    description = "Automatycznie stabilizuje nieruchome ciało albo wymaga ratownika na służbie, który ułoży pacjenta w pozycji bocznej ustalonej.",
                    label = "Naturalna stabilizacja",
                    options = {
                        automatic = "Automatyczna",
                        medic = "Ratownik wymagany",
                    },
                },
                deathScreenPanelBackground = {
                    description = "Kolor tła panelu używany przez ekran śmierci.",
                    label = "Tło panelu",
                },
                deathScreenPreventAutoRespawn = {
                    description = "Blokuj automatyczne odradzanie się po wykrwawieniu.",
                    label = "Zapobiegaj automatycznemu odradzaniu się",
                },
                deathScreenPreventAutoRespawnIfMedicNearby = {
                    description = "Blokuj automatyczne odradzanie się, gdy w pobliżu znajduje się medyk.",
                    label = "Blokuj, gdy medyk jest w pobliżu",
                },
                deathScreenPreventReviveOnExpiry = {
                    description = "Blok odradza się po upływie czasu wykrwawiania.",
                    label = "Zapobiegaj ożywieniu po wygaśnięciu",
                },
                deathScreenPrimaryColor = {
                    description = "Podstawowy kolor CSS używany w motywie ekranu śmierci.",
                    label = "Kolor podstawowy",
                },
                deathScreenPrimaryDark = {
                    description = "Opcjonalny ciemniejszy kolor akcentujący ekran śmierci.",
                    label = "Pierwotna ciemność",
                },
                deathScreenPrimaryStrong = {
                    description = "Opcjonalny silniejszy kolor akcentujący ekran śmierci.",
                    label = "Pierwotnie silny",
                },
                deathScreenRespawnDefaultHeading = {
                    description = "Kurs używany, gdy stacja nie ma zdefiniowanego kursu.",
                    label = "Domyślny nagłówek",
                },
                deathScreenRespawnFallbackCoordsHeading = {
                    description = "Pozycja odrodzenia awaryjnego używana, gdy nie ma żadnych pozycji w szpitalu.",
                    label = "Nagłówek zastępczy",
                },
                deathScreenRespawnFallbackCoordsX = {
                    description = "Współrzędna X odrodzenia awaryjnego używana, gdy nie ma żadnych pozycji w szpitalu.",
                    label = "Powrót X",
                },
                deathScreenRespawnFallbackCoordsY = {
                    description = "Współrzędna Y odrodzenia awaryjnego używana, gdy nie ma żadnych pozycji szpitalnych.",
                    label = "Rezerwowy Y",
                },
                deathScreenRespawnFallbackCoordsZ = {
                    description = "Współrzędna Z odrodzenia awaryjnego używana, gdy nie ma żadnych pozycji szpitalnych.",
                    label = "Rezerwowy Z",
                },
                deathScreenRespawnHospitalId = {
                    description = "Wybierz stały szpital do odradzania się. Zostaw to pole puste, aby skorzystać z najbliższego szpitala.",
                    label = "Szpital odrodzenia",
                },
                deathScreenRespawnRemoveAccountsEnabled = {
                    description = "Usuń saldo konta po odrodzeniu.",
                    label = "Usuń konta",
                },
                deathScreenRespawnRemoveAccountsNames = {
                    description = "Nazwy kont usunięte podczas odrodzenia.",
                    itemLabel = "Konto",
                    label = "Nazwy kont",
                },
                deathScreenRespawnRemoveItemsEnabled = {
                    description = "Usuń przedmioty z ekwipunku podczas odrodzenia.",
                    label = "Usuń elementy",
                },
                deathScreenRespawnRemoveItemsIgnore = {
                    description = "Przedmioty z ekwipunku przechowywane podczas odrodzenia.",
                    itemLabel = "Przedmiot",
                    label = "Ignorowane elementy",
                },
                deathScreenRespawnRemoveWeaponsEnabled = {
                    description = "Usuń broń z koła broni podczas odrodzenia.",
                    label = "Usuń broń",
                },
                deathScreenRespawnRemoveWeaponsIgnore = {
                    description = "Broń ciągle się odradza.",
                    itemLabel = "Broń",
                    label = "Ignorowana broń",
                },
                deathScreenRespawnTeleportToHospital = {
                    description = "Teleportuj gracza do szpitala po odrodzeniu.",
                    label = "Teleportacja do szpitala",
                },
                deathScreenResumeBleedOutOnReconnect = {
                    description = "Wznów licznik czasu upustu po ponownym podłączeniu, zamiast go resetować.",
                    label = "Wznów po ponownym połączeniu",
                },
                deathScreenShadowLight = {
                    description = "Miękki kolor cienia używany przez ekran śmierci.",
                    label = "Światło cienia",
                },
                deathScreenShadowMid = {
                    description = "Średni kolor cienia używany przez ekran śmierci.",
                    label = "Cień w środku",
                },
                deathScreenShowNearestMedic = {
                    description = "Pokaż najbliższego medyka na ekranie śmierci.",
                    label = "Pokaż najbliższego medyka",
                },
                deathScreenTextColor = {
                    description = "Podstawowy kolor tekstu używany na ekranie śmierci.",
                    label = "Kolor tekstu",
                },
                deathScreenTextShadow = {
                    description = "Kolor cienia tekstu używany przez ekran śmierci.",
                    label = "Cień tekstu",
                },
                deathTimeoutApplyOnKnockout = {
                    description = "Zastosuj limit czasu śmierci po odrodzeniu przez nokaut.",
                    label = "Aplikuj po nokaucie",
                },
                deathTimeoutSeconds = {
                    description = "Kilka sekund po odrodzeniu walka pozostaje wyłączona.",
                    label = "Towary drugiej jakości",
                },
                deathTimeoutShowUi = {
                    description = "Wyświetlaj baner odliczający limit czasu śmierci, gdy jest aktywny.",
                    label = "Pokaż interfejs użytkownika",
                },
                deathTimeoutWhitelistedGangs = {
                    label = "Gangi na białej liście",
                    description = "Wybierz wewnętrzne nazwy gangów lub niezależnych organizacji. Zgodny zawód lub gang przyznaje uprawnienie lub wyjątek. Służba jest wymagana tylko dla zawodów.",
                    itemLabel = "GANG",
                },
                deathTimeoutWhitelistedJobs = {
                    description = "Zadania zwolnione z ograniczeń związanych z przekroczeniem limitu czasu śmierci.",
                    itemLabel = "Stanowisko",
                    label = "Oferty pracy na białej liście",
                },
                deathUseAnimation = {
                    description = "Odtwórz skonfigurowaną animację śmierci dla obsługiwanych pediatrów.",
                    label = "Użyj animacji",
                },
                diagnoseAnimClip = {
                    description = "Klip animacyjny używany podczas otwierania diagnostyki. Pozostaw puste, aby zamiast tego użyć scenariusza.",
                    label = "Nazwa animacji",
                },
                diagnoseAnimDict = {
                    description = "Słownik animacji używany podczas otwierania diagnozy. Pozostaw puste, aby zamiast tego użyć scenariusza.",
                    label = "Słownik animacji",
                },
                diagnoseAnimScenario = {
                    description = "Scenariusz zastosowany podczas otwierania diagnostyki. Pozostaw puste, aby zamiast tego użyć dyktowania i klipu.",
                    label = "Scenariusz",
                },
                diagnoseCprAnimDict = {
                    description = "Słownik animacji używany do resuscytacji krążeniowo-oddechowej.",
                    label = "Słownik animacji",
                },
                diagnoseCprAnimName = {
                    description = "Klip animacyjny używany podczas resuscytacji krążeniowo-oddechowej.",
                    label = "Nazwa animacji",
                },
                diagnoseFullHealDelaySeconds = {
                    description = "Wymagany czas nieprzerwanej diagnozy przed pokazaniem pełnego leczenia.",
                    label = "Opóźnienie w sekundach",
                },
                diagnoseRequireRescueBackpack = {
                    label = "Wymagaj plecaka ratowniczego",
                    description = "Wymagaj rescue_backpack do wyświetlania lewego paska narzędzi badania. Wyłącz, aby pasek był zawsze widoczny; wymagania przedmiotów dla poszczególnych narzędzi nadal obowiązują.",
                },
                diagnoseFullHealEnabled = {
                    description = "Pozwala na pełne leczenie po nieprzerwanej sesji diagnozy.",
                    label = "Włączone",
                },
                diagnoseInteractDistance = {
                    description = "Maksymalna odległość wymagana do zdiagnozowania lub założenia worka na ciało pacjenta.",
                    label = "Odległość interakcji",
                },
                diagnosePatientMovementMode = {
                    label = "Ruch pacjenta",
                    description = "Unieruchom pacjenta, gdy inny gracz ma otwarte menu leczenia, lub pozwól na ruch i zamknij menu po przekroczeniu odległości leczenia. Autodiagnozę ustawia się osobno.",
                    options = {
                        freeze = "Unieruchom pacjenta",
                        distance = "Zamknij po przekroczeniu odległości",
                    },
                },
                diagnoseMaxTreatmentDistance = {
                    label = "Odległość leczenia (m)",
                    description = "Maksymalna odległość między leczącym graczem a pacjentem, po której przekroczeniu menu w trybie odległości zostanie zamknięte. Odległość otwarcia ustawia się osobno.",
                },
                diagnoseKey = {
                    description = "Identyfikator kontrolny używany do diagnozowania interakcji.",
                    label = "Klucz interakcji",
                },
                diagnoseOpenDelayMs = {
                    description = "Opóźnienie przed otwarciem interfejsu diagnostycznego.",
                    label = "Opóźnienie otwarcia ms",
                },
                diagnosePromptDistance = {
                    description = "Odległość używana do wyświetlania monitu diagnostycznego.",
                    label = "Natychmiastowa odległość",
                },
                diagnoseTreatmentDurationMs = {
                    description = "Czas trwania animacji leczenia.",
                    label = "Czas trwania leczenia ms",
                },
                doctorNpcAddRevenueToSociety = {
                    description = "Wpłacaj płatności lekarskie na wspólne konto społecznościowe w przypadku bezpośredniego pobierania opłat.",
                    label = "Dodaj dochody społeczeństwu",
                },
                doctorNpcEnabled = {
                    description = "Włącz usługę lekarza NPC.",
                    label = "Włączony",
                },
                doctorNpcHealOtherAccount = {
                    description = "Główny klucz konta używany do ładowania leczenia innego gracza.",
                    label = "Konto",
                },
                doctorNpcHealOtherAccountType = {
                    description = "Podstawowy typ konta używany do ładowania leczenia innego gracza.",
                    label = "Typ konta",
                },
                doctorNpcHealOtherCurrency = {
                    description = "Opcjonalny niestandardowy klucz walutowy używany do ładowania leczenia innego gracza.",
                    label = "Waluta",
                },
                doctorNpcHealOtherPrice = {
                    description = "Cena za wyleczenie innego gracza u lekarza NPC.",
                    label = "Cena",
                },
                doctorNpcHealSelfAccount = {
                    description = "Podstawowy klucz konta używany do ładowania samoleczenia.",
                    label = "Konto",
                },
                doctorNpcHealSelfAccountType = {
                    description = "Podstawowy typ konta używany do pobierania opłat za samoleczenie.",
                    label = "Typ konta",
                },
                doctorNpcHealSelfCurrency = {
                    description = "Opcjonalny niestandardowy klucz walutowy używany do pobierania opłat za samoleczenie.",
                    label = "Waluta",
                },
                doctorNpcHealSelfPrice = {
                    description = "Cena za wyleczenie się u lekarza NPC.",
                    label = "Cena",
                },
                doctorNpcInteractionRange = {
                    description = "Jak blisko użytkownika musi znajdować się lekarz NPC podczas korzystania z otwartego menu lekarza. Nie zmienia to początkowej odległości podpowiedzi NPC.",
                    label = "Zakres interakcji",
                },
                doctorNpcMaxMedicsOnline = {
                    description = "Lekarz NPC działa tylko wtedy, gdy liczba medyków na służbie jest poniżej tego limitu.",
                    label = "Max medyków online",
                },
                doctorNpcPatientRange = {
                    description = "Jak blisko pacjenta musi znajdować się lekarz NPC, aby leczyć innych lub wskrzesić, aby móc działać po wybraniu akcji.",
                    label = "Zakres pacjentów",
                },
                doctorNpcPaymentMode = {
                    description = "Natychmiast obciążaj graczy lub wyślij fakturę.",
                    label = "Tryb płatności",
                    options = {
                        bill = "rachunek",
                        remove = "usunąć",
                    },
                },
                doctorNpcPlayerScanRange = {
                    description = "Używane tylko do wyświetlania listy pobliskich graczy w interfejsie lekarza NPC. Nie pozwala na samodzielne leczenie.",
                    label = "Zasięg skanowania gracza",
                },
                doctorNpcReviveAccount = {
                    description = "Główny klucz konta używany do pobierania opłat za ożywienie lekarza.",
                    label = "Konto",
                },
                doctorNpcReviveAccountType = {
                    description = "Podstawowy typ konta używany do naliczania opłat za ożywienie lekarza.",
                    label = "Typ konta",
                },
                doctorNpcReviveAllowFatalWounds = {
                    description = "Pozwala lekarzowi NPC reanimować śmiertelne lub nieodwracalne obrażenia. Upływ czasu wykrwawienia nadal blokuje reanimację.",
                    label = "Zezwól na śmiertelne obrażenia",
                },
                doctorNpcReviveCurrency = {
                    description = "Opcjonalny niestandardowy klucz walutowy używany do naliczania opłat za ożywienie lekarza.",
                    label = "Waluta",
                },
                doctorNpcReviveInBedEnabled = {
                    description = "Po ożywieniu przez lekarza umieść ożywionych graczy na najbliższym łóżku szpitalnym.",
                    label = "Włączony",
                },
                doctorNpcReviveInBedSearchRadius = {
                    description = "Maksymalna odległość używana do znalezienia pobliskiego łóżka szpitalnego dla lekarza.",
                    label = "Promień wyszukiwania",
                },
                doctorNpcRevivePrice = {
                    description = "Cena za wskrzeszenie gracza u lekarza NPC.",
                    label = "Cena",
                },
                firstAidActionDurationMs = {
                    description = "Jak długo trwa akcja pierwszej pomocy.",
                    label = "Czas trwania akcji ms",
                },
                firstAidAnimationDict = {
                    description = "Słownik animacji używany podczas akcji pierwszej pomocy.",
                    label = "Słownik animacji",
                },
                firstAidAnimationFlag = {
                    description = "Flaga TaskPlayAnim używana podczas akcji pierwszej pomocy.",
                    label = "Flaga animacji",
                },
                firstAidAnimationName = {
                    description = "Klip animacyjny wykorzystany podczas udzielania pierwszej pomocy.",
                    label = "Nazwa animacji",
                },
                firstAidBleedoutExtensionSeconds = {
                    description = "Sekundy dodawane do licznika czasu krwawienia pacjenta po udzieleniu pierwszej pomocy.",
                    label = "Wydłużenie krwawienia w sekundach",
                },
                firstAidEnabled = {
                    description = "Włącz funkcję pierwszej pomocy dla licencjonowanych graczy.",
                    label = "Pierwsza pomoc włączona",
                },
                firstAidLicense = {
                    description = "Nazwa licencji ramowej używanej do sprawdzania dostępu do pierwszej pomocy.",
                    label = "Nazwa licencji",
                },
                firstAidLicenseManagementAddEnabled = {
                    description = "Zezwalaj personelowi ambulansu na wydanie licencji na udzielanie pierwszej pomocy.",
                    label = "Dodaj licencję włączoną",
                },
                firstAidLicenseManagementAddRadial = {
                    description = "Pokaż akcję dodawania licencji w menu promieniowym.",
                    label = "Dodaj licencję radialną",
                },
                firstAidLicenseManagementAddRequireDuty = {
                    description = "Wymagaj obowiązku EMS przed użyciem akcji dodawania licencji.",
                    label = "Dodaj licencję wymagającą cła",
                },
                firstAidLicenseManagementRemoveEnabled = {
                    description = "Zezwalaj personelowi ambulansu na odebranie licencji na udzielanie pierwszej pomocy.",
                    label = "Usuń licencję włączoną",
                },
                firstAidLicenseManagementRemoveRadial = {
                    description = "Pokaż akcję usunięcia licencji w menu promieniowym.",
                    label = "Usuń licencję promieniową",
                },
                firstAidLicenseManagementRemoveRequireDuty = {
                    description = "Wymagaj służby EMS przed wykonaniem akcji usunięcia licencji.",
                    label = "Usuń licencję wymagającą cła",
                },
                firstAidPositionChestOffset = {
                    description = "Przesunięcie klatki piersiowej stosowane podczas ustawiania w celu udzielenia pierwszej pomocy.",
                    label = "Przesunięcie klatki piersiowej",
                },
                firstAidPositionSideOffset = {
                    description = "Przesunięcie boczne używane podczas ustawiania w celu uzyskania pierwszej pomocy.",
                    label = "Przesunięcie boczne",
                },
                firstAidPositionZOffset = {
                    description = "Przesunięcie pionowe stosowane podczas ustawiania w celu uzyskania pierwszej pomocy.",
                    label = "Przesunięcie Z",
                },
                firstAidRequireLicense = {
                    description = "Wymagaj skonfigurowanej licencji pierwszej pomocy, zanim gracz będzie mógł skorzystać z pierwszej pomocy.",
                    label = "Wymagaj licencji",
                },
                firstAidTargetDistance = {
                    description = "Maksymalna odległość dozwolona przy udzielaniu pierwszej pomocy.",
                    label = "Odległość docelowa",
                },
                healthInsuranceAccount = {
                    description = "Klucz konta zastępczego używany do płatności ubezpieczeniowych.",
                    label = "Konto",
                },
                healthInsuranceAccountType = {
                    description = "Podstawowy typ konta używany do płatności ubezpieczeniowych.",
                    label = "Typ konta",
                },
                healthInsuranceAvailableDays = {
                    description = "Dostępne okresy ubezpieczenia w dniach.",
                    label = "Dostępne dni",
                },
                healthInsuranceCommand = {
                    description = "Polecenie czatu używane do otwierania interfejsu ubezpieczenia zdrowotnego.",
                    label = "Rozkaz",
                },
                healthInsuranceCurrency = {
                    description = "Opcjonalny niestandardowy klucz walutowy używany do płatności ubezpieczeniowych.",
                    label = "Waluta",
                },
                healthInsuranceEnabled = {
                    description = "Włącz system ubezpieczenia zdrowotnego.",
                    label = "Włączony",
                },
                healthInsurancePricesManagedInTablet = {
                    description = "Pozwala uprawnionym pracownikom zmieniać ceny ubezpieczeń w tablecie. Wyłącz, aby wymusić ceny z poniższej tabeli dostawców.",
                    label = "Zarządzanie cenami w tablecie",
                },
                healthInsuranceProviders = {
                    description = "Ubezpieczyciele oferowani graczom.",
                    itemLabel = "Dostawca",
                    label = "Dostawcy",
                },
                healthInsuranceSharedAcrossJobs = {
                    description = "Używa tych samych ubezpieczycieli i polis dla wszystkich zawodów zarejestrowanych w tym zasobie pogotowia.",
                    label = "Współdziel między zawodami pogotowia",
                },
                hospitalBedsBedAnimationDict = {
                    description = "Słownik animacji zapętlony, gdy gracz leży na łóżku. Pozostaw puste, aby użyć domyślnej animacji śmierci.",
                    label = "Słownik animacji",
                },
                hospitalBedsBedAnimationDurationMs = {
                    description = "Opcjonalny ręczny czas trwania animacji zapętlonego łóżka. Używane tylko wtedy, gdy skonfigurowano niestandardową animację łóżka.",
                    label = "Czas trwania ms",
                },
                hospitalBedsBedAnimationFlag = {
                    description = "Flaga TaskPlayAnim używana do animacji zapętlonego łóżka. Używane tylko wtedy, gdy skonfigurowano niestandardową animację łóżka.",
                    label = "Flaga animacji",
                },
                hospitalBedsBedAnimationName = {
                    description = "Klip animacyjny zapętlony, gdy gracz leży na łóżku. Pozostaw puste, aby użyć domyślnej animacji śmierci.",
                    label = "Nazwa animacji",
                },
                hospitalBedsBreakDistance = {
                    description = "Odległość, po której gracz zostaje zrzucony z łóżka.",
                    label = "Odległość przerwy",
                },
                hospitalBedsCreatorPedModel = {
                    description = "Podgląd modelu łóżka używanego w edytorze pozycji łóżka szpitalnego.",
                    label = "Model peda twórcy",
                },
                hospitalBedsEnabled = {
                    description = "Włącz skonfigurowane interakcje z łóżkiem szpitalnym.",
                    label = "Włączony",
                },
                hospitalBedsGetupAnimationDict = {
                    description = "Słownik animacji odtwarzany, gdy gracz wstaje z łóżka. Pozostaw puste, aby użyć domyślnego zachowania podczas wstawania.",
                    label = "Słownik animacji",
                },
                hospitalBedsGetupAnimationDurationMs = {
                    description = "Opcjonalny ręczny czas trwania animacji wstawania. Używane tylko wtedy, gdy skonfigurowano niestandardową animację wstawania.",
                    label = "Czas trwania ms",
                },
                hospitalBedsGetupAnimationFlag = {
                    description = "Flaga TaskPlayAnim używana w animacji wstawania. Używane tylko wtedy, gdy skonfigurowano niestandardową animację wstawania.",
                    label = "Flaga animacji",
                },
                hospitalBedsGetupAnimationName = {
                    description = "Klip animacyjny odtwarzany, gdy gracz wstaje z łóżka. Pozostaw puste, aby użyć domyślnego zachowania podczas wstawania.",
                    label = "Nazwa animacji",
                },
                hospitalBedsHeadingOffset = {
                    description = "Przesunięcie kursu zastosowane podczas umieszczania gracza na łóżku.",
                    label = "Przesunięcie kursu",
                },
                hospitalBedsHeightOffset = {
                    description = "Przesunięcie pionowe zastosowane podczas umieszczania odtwarzacza na łóżku.",
                    label = "Przesunięcie wysokości",
                },
                hospitalBedsInteractDistance = {
                    description = "Maksymalna odległość wymagana do korzystania z łóżka szpitalnego.",
                    label = "Odległość interakcji",
                },
                hospitalBedsInteractKey = {
                    description = "Identyfikator kontrolny używany przy wejściu lub wyjściu z łóżka szpitalnego.",
                    label = "Klucz interakcji",
                },
                hospitalBedsModels = {
                    description = "Modele obiektów świata traktowane jako użytkowe łóżka szpitalne.",
                    itemLabel = "Wzór",
                    label = "Modele łóżek",
                },
                hospitalBedsSearchRadius = {
                    description = "Promień używany do znajdowania pobliskich podpórek do łóżek lub skonfigurowanych łóżek.",
                    label = "Promień wyszukiwania",
                },
                hospitalBlipColor = {
                    description = "Identyfikator koloru znacznika używany do znaczników na mapie szpitala.",
                    label = "Kolor",
                },
                hospitalBlipEnabled = {
                    description = "Pokaż znaczniki mapy szpitala dla skonfigurowanych pozycji szpitala.",
                    label = "Włączony",
                },
                hospitalBlipName = {
                    description = "Zastępcza nazwa szpitala, używana, gdy nie jest dostępna żadna nazwa stacji.",
                    label = "Nazwa",
                },
                hospitalBlipScale = {
                    description = "Skala znaczników używana do oznaczania znaczników na mapie szpitala.",
                    label = "Skala",
                },
                hospitalBlipSprite = {
                    description = "Identyfikator duszka Blip używany do znaczników na mapie szpitala.",
                    label = "Krasnoludek",
                },
                imagingInteractionRange = {
                    description = "Maksymalna odległość operatora od stacji obrazowania.",
                    label = "Zakres interakcji",
                },
                imagingPatientRange = {
                    description = "Maksymalna odległość pacjenta od stacji obrazowania.",
                    label = "Zakres pacjentów",
                },
                imagingScanDurationSeconds = {
                    description = "Czas trwania wyników tomografii komputerowej i rezonansu magnetycznego w sekundach.",
                    label = "Czas trwania skanowania",
                },
                injuryEffectsBleedingOverlayIntensity = {
                    description = "Tylko wizualny mnożnik dla efektów krwawiącej nakładki.",
                    label = "Intensywność nakładki krwawienia",
                },
                injuryEffectsPainScreenIntensity = {
                    description = "Tylko wizualny mnożnik efektów ekranu bólu.",
                    label = "Intensywność ekranu bólu",
                },
                injuryThresholdBleedingPainMinPercent = {
                    description = "Minimalny procent maksymalnego zdrowia utraconego jednym uderzeniem, zanim wystąpi krwawienie i ból.",
                    label = "Krwawienie/ból min.procent",
                },
                injuryThresholdRespectArmor = {
                    description = "Pomiń krwawienie i ból, gdy trafienie zostało wchłonięte przez zbroję.",
                    label = "Szanuj zbroję",
                },
                knockoutRegenerateDamage = {
                    description = "Regeneruje obrażenia od nokautu po upływie czasu odrodzenia.",
                    label = "Regeneruj obrażenia",
                },
                knockoutRegenerateDurationSeconds = {
                    description = "Sekundy, w ciągu których obrażenia od nokautu są ponownie leczone.",
                    label = "Czas trwania regeneracji",
                },
                knockoutRespawnSeconds = {
                    description = "Sekundy przed automatycznym odrodzeniem, gdy gracz zostaje znokautowany.",
                    label = "Sekundy odrodzenia",
                },
                knockoutWeapons = {
                    description = "Nazwy broni lub skróty, które powinny wywołać nokaut zamiast pełnego ekranu śmierci.",
                    itemLabel = "Broń",
                    label = "Broń",
                },
                legShotRagdollChance = {
                    description = "Procentowa szansa, ze pasujace trafienie uruchomi ragdoll.",
                    label = "Szansa",
                },
                legShotRagdollCooldownMs = {
                    description = "Minimalne opoznienie miedzy ragdollami po strzale w noge.",
                    label = "Ms chłodzenie",
                },
                legShotRagdollDebug = {
                    description = "Zapisuje decyzje ragdoll do testow.",
                    label = "Debugowanie",
                },
                legShotRagdollDurationMs = {
                    description = "Jak dlugo trwa ragdoll.",
                    label = "Czas trwania ms",
                },
                legShotRagdollFeet = {
                    description = "Pozwala, aby trafienia w stopy uruchamialy ragdoll.",
                    label = "Stopy",
                },
                legShotRagdollIgnoreArmorHits = {
                    description = "Pomija ragdoll, gdy pancerz pochlonal trafienie.",
                    label = "Ignoruj trafienia w pancerz",
                },
                legShotRagdollLeftLowerLeg = {
                    description = "Pozwala na trafienia w lewe podudzie.",
                    label = "Lewe podudzie",
                },
                legShotRagdollLeftUpperLeg = {
                    description = "Pozwala na trafienia w lewe udo.",
                    label = "Lewe udo",
                },
                legShotRagdollOnlyGunshots = {
                    description = "Tylko strzaly moga uruchomic ragdoll.",
                    label = "Tylko strzaly",
                },
                legShotRagdollRightLowerLeg = {
                    description = "Pozwala na trafienia w prawe podudzie.",
                    label = "Prawe podudzie",
                },
                legShotRagdollRightUpperLeg = {
                    description = "Pozwala na trafienia w prawe udo.",
                    label = "Prawe udo",
                },
                liveDamageFracturesChance = {
                    description = "Podstawowa szansa, że ​​świadome trafienie spowoduje złamanie.",
                    label = "Szansa",
                },
                liveDamageFracturesEnabled = {
                    description = "Pozwól, aby świadome obrażenia powodowały złamania.",
                    label = "Włączony",
                },
                liveDamageFracturesMinDamagePercent = {
                    description = "Minimalny procent maksymalnego zdrowia utracony jednym trafieniem, zanim może wystąpić złamanie.",
                    label = "Minimalny procent obrażeń",
                },
                liveDamageFracturesZones = {
                    description = "Szansa na pęknięcie w poszczególnych strefach zadając obrażenia na żywo.",
                    label = "Szanse strefowe",
                },
                liveOpenWoundStacksDefault = {
                    description = "Maksymalna liczba stosow otwartych ran na strefe bez nadpisania.",
                    label = "Domyslny limit",
                },
                liveOpenWoundStacksZones = {
                    description = "Opcjonalne limity stosow otwartych ran dla stref.",
                    itemLabel = "Strefa",
                    label = "Limity stref",
                },
                liveWoundBleedingClassProfiles = {
                    description = "Początkowa klasa krwawienia stosowana w zależności od przyczyny obrażeń na żywo.",
                    label = "Zajęcia dotyczące krwawienia z żywych ran",
                },
                medicCarryAllowCarrierInVehicle = {
                    description = "Pozwala niosącemu wejść do pojazdu i prowadzić bez odkładania pacjenta.",
                    label = "Zezwól niosącemu na pojazd",
                },
                medicCarryAllowConsciousTargets = {
                    description = "Pozwól na przewożenie świadomych graczy.",
                    label = "Zezwalaj na świadome cele",
                },
                medicCarryAllowSprint = {
                    description = "Pozwól na bieganie podczas niesienia pacjenta.",
                    label = "Zezwalaj na sprint",
                },
                medicCarryAttachBone = {
                    description = "Indeks kostny służący do mocowania noszonego odtwarzacza.",
                    label = "Przymocuj kość",
                },
                medicCarryAttachOffsetsPitch = {
                    description = "Przenoś, dołącz rotację skoku.",
                    label = "Poziom",
                },
                medicCarryAttachOffsetsRoll = {
                    description = "Przenoś, mocuj obrót rolki.",
                    label = "Rolka",
                },
                medicCarryAttachOffsetsX = {
                    description = "Noś mocowanie X z przesunięciem.",
                    label = "Przesunięcie X",
                },
                medicCarryAttachOffsetsY = {
                    description = "Noś mocowanie z przesunięciem Y.",
                    label = "Przesunięcie Y",
                },
                medicCarryAttachOffsetsYaw = {
                    description = "Przenoszenie i obracanie odchylenia.",
                    label = "Myszkować",
                },
                medicCarryAttachOffsetsZ = {
                    description = "Noś mocowanie Z przesunięciem.",
                    label = "Przesunięcie Z",
                },
                medicCarryCarrierAnimationDict = {
                    description = "Słownik animacji używany przez medyka podczas noszenia pacjenta.",
                    label = "Słownik animacji",
                },
                medicCarryCarrierAnimationFlag = {
                    description = "Flaga TaskPlayAnim używana przez animację noszenia medyka.",
                    label = "Flaga animacji",
                },
                medicCarryCarrierAnimationName = {
                    description = "Klip animacyjny używany przez medyka podczas noszenia pacjenta.",
                    label = "Nazwa animacji",
                },
                medicCarryEnabled = {
                    description = "Włącz system przenoszenia medyka.",
                    label = "Włączony",
                },
                medicCarryMaxDistance = {
                    description = "Maksymalna odległość wymagana do odebrania pacjenta.",
                    label = "Maksymalna odległość",
                },
                medicCarryPassengerAnimationDict = {
                    description = "Słownik animacji używany przez niesionego pacjenta.",
                    label = "Słownik animacji",
                },
                medicCarryPassengerAnimationFlag = {
                    description = "Flaga TaskPlayAnim używana przez animację niesionego pacjenta.",
                    label = "Flaga animacji",
                },
                medicCarryPassengerAnimationName = {
                    description = "Klip animacyjny używany przez niesionego pacjenta.",
                    label = "Nazwa animacji",
                },
                medicCarryReapplyDeathAnimation = {
                    description = "Zastosuj ponownie animację śmierci po upuszczeniu nieprzytomnego pacjenta.",
                    label = "Zastosuj ponownie animację śmierci",
                },
                medicCarryRequireOnDuty = {
                    description = "Noszenie mogą rozpocząć tylko medycy na służbie.",
                    label = "Wymagaj na służbie",
                },
                medicReviveAllowFatalWounds = {
                    description = "Pozwala medykom na służbie leczyć i reanimować śmiertelne lub nieodwracalne obrażenia. Upływ czasu wykrwawienia nadal blokuje reanimację.",
                    label = "Zezwól na śmiertelne obrażenia",
                },
                medicRevivePersistenceKeepInjuries = {
                    description = "Zachowaj nierozwiązane urazy po leczeniu lub ożywieniu listy kontrolnej.",
                    label = "Zachowaj kontuzje",
                },
                medicRevivePersistenceKeepPain = {
                    description = "Zachowaj wartości bólu po leczeniu lub lista kontrolna ożywia się, gdy urazy są zachowane.",
                    label = "Zachowaj ból",
                },
                medicalEvaluationPatientSelectionRange = {
                    description = "Maksymalna odległość używana do wykazywania pobliskich graczy podczas tworzenia oceny medycznej.",
                    label = "Obok zakresu pacjentów",
                },
                medicalEvaluationRecipientJobs = {
                    description = "zawody, w odniesieniu do których można wydawać i udostępniać oceny medyczne.",
                    label = "Prace odbiorców",
                },
                medicalEvaluationShareBirthDate = {
                    description = "Zezwolić pracodawcom na obserwację daty urodzenia pacjenta.",
                    label = "Data urodzenia",
                },
                medicalEvaluationShareConclusion = {
                    description = "Zezwolić zawodom beneficjentom zobaczyć wnioski medyczne.",
                    label = "Wnioski dotyczące udziału",
                },
                medicalEvaluationShareEvaluationTypes = {
                    description = "Zezwolić zawodom odbiorcom na sprawdzenie, jakie typy oceny zostały przeprowadzone.",
                    label = "Rodzaje oceny udziałów",
                },
                medicalEvaluationShareFullName = {
                    description = "Zezwolić pracownikom, by zobaczyli pełne imię pacjenta.",
                    label = "Udostępnij pełną nazwę",
                },
                medicalEvaluationShareGender = {
                    description = "Zezwolić pracownikom na obserwację płci pacjenta.",
                    label = "Podział płci",
                },
                medicalEvaluationShareHeight = {
                    description = "Pozwolić pracownikom, by zobaczyli wysokość pacjenta.",
                    label = "Wysokość udziału",
                },
                medicalEvaluationShareHobbies = {
                    description = "Pozwolić pracownikom odbiorcom zobaczyć zajęcia i hobby pacjenta.",
                    label = "Wypożyczalnie i hobby",
                },
                medicalEvaluationShareIssuer = {
                    description = "Pokaż nazwisko autora. Wystawiająca jednostka pozostaje widoczna jako folder udostępnionych dokumentów.",
                    label = "Udostępnij dane autora",
                },
                medicalEvaluationSharePersonalId = {
                    description = "Zezwolić pracownikom na wizytę w osobistym ID pacjenta.",
                    label = "Udostępnij osobiście ID",
                },
                medicalEvaluationShareProfession = {
                    description = "Zezwolić pracownikom na obserwację zawodu pacjenta.",
                    label = "Udział w zawodach",
                },
                medicalEvaluationShareQuestionnaireAnswers = {
                    description = "Pozwolić zawodom beneficjentom zobaczyć pytania zawarte w kwestionariuszu i zarejestrować odpowiedzi.",
                    label = "Podziel się pytaniami i odpowiedziami",
                },
                medicalEvaluationShareResult = {
                    description = "Zezwolić zawodom beneficjentom na sprawdzenie, czy ocena jest w oczekiwaniu, wydana czy nie.",
                    label = "Wynik udziału",
                },
                medicalEvaluationShareWeight = {
                    description = "Zezwolić pracownikom na obserwację masy ciała pacjenta.",
                    label = "Waga udziału",
                },
                medicalEvaluationTypes = {
                    description = "Konfiguracja typów oceny, pytań, typów odpowiedzi i czy każde pytanie jest aktywne.",
                    label = "Rodzaje oceny i kwestionariusze",
                    options = {
                        boolean = "Tak / Nie",
                        boolean_text = "Tak / Nie z szczegółami",
                        date = "Data",
                        multi_select = "Wielokrotny wybór",
                        number = "Numer",
                        rating = "Ocena",
                        select = "Pojedynczy wybór",
                        text = "Tekst",
                        textarea = "Obszar tekstu",
                        time = "Czas",
                    },
                },
                medicalEvaluationsEnabled = {
                    description = "Aktywuj ocenę medyczną w tabletce karetki.",
                    label = "Włączone",
                },
                medicalWearablesAllowUntilRemoved = {
                    description = "Oferuje stały czas, który pozostaje aktywny do zdjęcia pomocy przez medyka.",
                    label = "Zezwól do zdjęcia",
                },
                medicalWearablesArmCastsDisableMelee = {
                    description = "Uniemożliwia ataki wręcz podczas noszenia gipsu na ramieniu.",
                    label = "Wyłącz walkę wręcz",
                },
                medicalWearablesArmCastsDisableWeapons = {
                    description = "Wymusza brak broni i uniemożliwia jej zmianę podczas noszenia gipsu na ramieniu.",
                    label = "Wyłącz broń",
                },
                medicalWearablesArmCastsRestrictionsEnabled = {
                    description = "Nakłada ograniczenia walki podczas noszenia gipsu na ramieniu.",
                    label = "Włączone",
                },
                medicalWearablesAutoFromFractures = {
                    description = "Leczy pasujące złamanie podczas zakładania gipsu lub szyny.",
                    label = "Integracja złamań",
                },
                medicalWearablesCastsEnabled = {
                    description = "Pozwala zakładać gipsy na lewe i prawe ramiona oraz nogi.",
                    label = "Włączone",
                },
                medicalWearablesCastsItem = {
                    description = "Przedmiot z ekwipunku zużywany podczas zakładania gipsu.",
                    label = "Przedmiot",
                },
                medicalWearablesCastsMinigame = {
                    description = "Istniejąca minigra leczenia używana dla gipsów.",
                    label = "Minigra",
                },
                medicalWearablesDefaultDurationMinutes = {
                    description = "Domyślny czas pomocy medycznej w minutach. Ustaw 0, aby działała do zdjęcia.",
                    label = "Domyślne minuty",
                },
                medicalWearablesDurationOptionsMinutes = {
                    description = "Czasy pomocy medycznych wyświetlane medykom w minutach.",
                    label = "Opcje czasu",
                },
                medicalWearablesEnabled = {
                    description = "Włącza modele gipsów, szyn, bandaży, kołnierzy i masek tlenowych w interfejsie leczenia.",
                    label = "Włączone",
                },
                medicalWearablesExpiryCheckSeconds = {
                    description = "Częstotliwość usuwania wygasłych czasowych pomocy medycznych.",
                    label = "Kontrola wygaśnięcia (sekundy)",
                },
                medicalWearablesHeadBandageEnabled = {
                    description = "Pozwala używać modelu bandaża głowy.",
                    label = "Włączone",
                },
                medicalWearablesHeadBandageItem = {
                    description = "Przedmiot z ekwipunku zużywany do bandaża głowy.",
                    label = "Przedmiot",
                },
                medicalWearablesHeadBandageMinigame = {
                    description = "Istniejąca minigra leczenia używana dla bandaża głowy.",
                    label = "Minigra",
                },
                medicalWearablesLegCastsDisableJump = {
                    description = "Uniemożliwia skakanie podczas noszenia gipsu na nodze.",
                    label = "Wyłącz skok",
                },
                medicalWearablesLegCastsDisableSprint = {
                    description = "Uniemożliwia sprint podczas noszenia gipsu na nodze.",
                    label = "Wyłącz sprint",
                },
                medicalWearablesLegCastsForceInjuredWalk = {
                    description = "Wymusza zestaw animacji rannego podczas noszenia gipsu na nodze.",
                    label = "Wymuś chód rannego",
                },
                medicalWearablesLegCastsMoveRate = {
                    description = "Nadpisuje prędkość ruchu podczas noszenia gipsu na nodze.",
                    label = "Prędkość ruchu",
                },
                medicalWearablesLegCastsRestrictionsEnabled = {
                    description = "Nakłada ograniczenia ruchu podczas noszenia gipsu na nodze.",
                    label = "Włączone",
                },
                medicalWearablesNeckBraceEnabled = {
                    description = "Pozwala używać modelu kołnierza ortopedycznego.",
                    label = "Włączone",
                },
                medicalWearablesNeckBraceItem = {
                    description = "Przedmiot z ekwipunku zużywany do kołnierza ortopedycznego.",
                    label = "Przedmiot",
                },
                medicalWearablesNeckBraceMinigame = {
                    description = "Istniejąca minigra leczenia używana dla kołnierza ortopedycznego.",
                    label = "Minigra",
                },
                medicalWearablesOxygenMaskEnabled = {
                    description = "Pozwala używać modelu maski tlenowej.",
                    label = "Włączone",
                },
                medicalWearablesOxygenMaskItem = {
                    description = "Przedmiot z ekwipunku zużywany do maski tlenowej.",
                    label = "Przedmiot",
                },
                medicalWearablesOxygenMaskMinigame = {
                    description = "Istniejąca minigra leczenia używana dla maski tlenowej.",
                    label = "Minigra",
                },
                medicalWearablesPatientHudEnabled = {
                    description = "Pokazuje pacjentom aktywne pomoce medyczne i pozostały czas ich noszenia.",
                    label = "Włączony",
                },
                medicalWearablesPatientHudPosition = {
                    description = "Wybiera położenie HUD-u pomocy medycznych pacjenta.",
                    label = "Pozycja",
                    options = {
                        ["bottom-center"] = "Dół środek",
                        ["bottom-left"] = "Dół lewa",
                        ["bottom-right"] = "Dół prawa",
                        center = "Środek",
                        ["center-left"] = "Środek lewa",
                        ["center-right"] = "Środek prawa",
                        ["top-center"] = "Góra środek",
                        ["top-left"] = "Góra lewa",
                        ["top-right"] = "Góra prawa",
                    },
                },
                medicalWearablesPersistence = {
                    description = "Przywraca czasowe gipsy, szyny, kołnierze ortopedyczne i bandaże tułowia po ponownym połączeniu lub restarcie zasobu.",
                    label = "Trwałość pomocy medycznych",
                },
                medicalWearablesRemoval = {
                    description = "Pozwala medykom usuwać aktywne gipsy, szyny, kołnierze i bandaże tułowia z interfejsu leczenia.",
                    label = "Usuwanie przez medyka",
                },
                medicalWearablesRemovalTreatmentEnabled = {
                    description = "Pokazuje usuwanie pomocy medycznych skonfigurowanym narzędziem w interfejsie leczenia.",
                    label = "Usuwanie w leczeniu włączone",
                },
                medicalWearablesRemovalTreatmentItem = {
                    description = "Narzędzie wielokrotnego użytku z ekwipunku wymagane do usunięcia pomocy medycznej.",
                    label = "Przedmiot",
                },
                medicalWearablesRemovalTreatmentMinigame = {
                    description = "Minigra przy usuwaniu pomocy medycznych (domyślnie cast_saw).",
                    label = "Minigra",
                },
                medicalWearablesSplintsEnabled = {
                    description = "Pozwala zakładać szyny podwieszane na lewe i prawe ramię.",
                    label = "Włączone",
                },
                medicalWearablesSplintsItem = {
                    description = "Przedmiot z ekwipunku zużywany podczas zakładania szyny.",
                    label = "Przedmiot",
                },
                medicalWearablesSplintsMinigame = {
                    description = "Istniejąca minigra leczenia używana dla szyn.",
                    label = "Minigra",
                },
                medicalWearablesTorsoBandageEnabled = {
                    description = "Pozwala używać modelu bandaża tułowia.",
                    label = "Włączone",
                },
                medicalWearablesTorsoBandageItem = {
                    description = "Przedmiot z ekwipunku zużywany do bandaża tułowia.",
                    label = "Przedmiot",
                },
                medicalWearablesTorsoBandageMinigame = {
                    description = "Istniejąca minigra leczenia używana dla bandaża tułowia.",
                    label = "Minigra",
                },
                medicationsProfiles = {
                    description = "Deklaracyjne wpisy leków stosowanych w leczeniu i samoleczeniu.",
                    itemLabel = "Lek",
                    label = "Leki",
                },
                minigamesBagValveMaskEnabled = {
                    description = "Włącz minigrę z maską zaworu worka.",
                    label = "Maska z zaworem workowym",
                },
                minigamesCastSawEnabled = {
                    description = "Włącza minigrę z piłą przy usuwaniu pomocy medycznych.",
                    label = "Piła do gipsu",
                },
                minigamesBandageWrapEnabled = {
                    description = "Włącz minigrę polegającą na owijaniu bandażem.",
                    label = "Okład bandażowy",
                },
                minigamesBloodPressureEnabled = {
                    description = "Włącz minigrę dotyczącą pomiaru ciśnienia krwi.",
                    label = "Ciśnienie krwi",
                },
                minigamesBloodTransfusionEnabled = {
                    description = "Włącz minigrę dotyczącą transfuzji krwi.",
                    label = "Transfuzja krwi",
                },
                minigamesBulletExtractionEnabled = {
                    description = "Włącz minigrę polegającą na wydobywaniu pocisków.",
                    label = "Ekstrakcja pocisku",
                },
                minigamesCprBreathsPerCycle = {
                    description = "Oddechy wymagane podczas każdej fazy wentylacji.",
                    label = "Oddechy na cykl",
                },
                minigamesCprCompressionDurationPerSet = {
                    description = "Wykonanie jednej serii ucisków w sekundach.",
                    label = "Czas trwania kompresji na serię",
                },
                minigamesCprCompressionWindow = {
                    description = "Dozwolone przesunięcie przy uderzeniu w rytm kompresji.",
                    label = "Okno kompresji",
                },
                minigamesCprCompressionsEnabled = {
                    description = "Włącz etap minigry polegającej na uciskaniu klatki piersiowej.",
                    label = "Uciski resuscytacyjne",
                },
                minigamesCprCompressionsPerSet = {
                    description = "Liczba uciśnięć na serię.",
                    label = "Uciski na serię",
                },
                minigamesCprCycles = {
                    description = "Ile cykli reanimacji potrzeba, aby ukończyć minigrę.",
                    label = "Cykle",
                },
                minigamesCprEnabled = {
                    description = "Włącz minigrę RKO.",
                    label = "CPR",
                },
                minigamesCprIntroDelaySeconds = {
                    description = "Odliczanie do rozpoczęcia uciskania klatki piersiowej.",
                    label = "Wstępne opóźnienie w sekundach",
                },
                minigamesCprMaxMisses = {
                    description = "Dopuszczalne jest spudłowanie przed niepowodzeniem minigry w zakresie resuscytacji krążeniowo-oddechowej.",
                    label = "Maks tęskni",
                },
                minigamesCprSetsPerCycle = {
                    description = "Ile serii ucisków wykonuje się przed etapem oddechu.",
                    label = "Zestawów na cykl",
                },
                minigamesCprVentilationEnabled = {
                    description = "Włącz etap minigry polegającej na wentylacji resuscytacyjnej.",
                    label = "Wentylacja resuscytacyjna",
                },
                minigamesGlucoseMeterEnabled = {
                    description = "Włącz minigrę z glukometrem.",
                    label = "Miernik glukozy",
                },
                minigamesPulseMeasurementEnabled = {
                    description = "Włącz minigrę dotyczącą pomiaru tętna.",
                    label = "Pomiar pulsu",
                },
                minigamesPulseOximeterEnabled = {
                    description = "Włącz minigrę z pulsoksymetrem.",
                    label = "Pulsoksymetr",
                },
                minigamesSalineInfusionEnabled = {
                    description = "Włącz minigrę z naparem soli fizjologicznej.",
                    label = "Napar solankowy",
                },
                minigamesVentilationBreathTimeoutSeconds = {
                    description = "Sekundy przed upływem limitu czasu próby wentylacji. Ustaw 0, aby wyłączyć.",
                    label = "Sekundy limitu czasu oddechu",
                },
                minigamesVentilationEnabled = {
                    description = "Włącz minigrę wentylacyjną.",
                    label = "Wentylacja",
                },
                minigamesVentilationTolerance = {
                    description = "Tolerancja odległości pikseli podczas śledzenia fali przepływu powietrza.",
                    label = "Tolerancja",
                },
                operationsBreakDistance = {
                    description = "Maksymalna odległość uczestników od sali przed przerwaniem zabiegu.",
                    label = "Odległość przerwania",
                },
                operationsDoctorAnimationDict = {
                    description = "Słownik animacji GTA dla chirurga podczas prawdziwego zabiegu.",
                    label = "Słownik animacji chirurga",
                },
                operationsDoctorAnimationFlag = {
                    description = "Flaga animacji GTA dla chirurga podczas prawdziwego zabiegu.",
                    label = "Flaga animacji chirurga",
                },
                operationsDoctorAnimationName = {
                    description = "Klip animacji chirurga podczas prawdziwego zabiegu.",
                    label = "Nazwa animacji chirurga",
                },
                operationsEnabled = {
                    description = "Włącza sale operacyjne i zabiegi chirurgiczne.",
                    label = "Włączone",
                },
                operationsFadeInMs = {
                    description = "Czas rozjaśniania ekranu pacjenta podczas wybudzania w milisekundach.",
                    label = "Rozjaśnianie podczas wybudzania (ms)",
                },
                operationsFadeOutMs = {
                    description = "Czas wygaszania ekranu pacjenta podczas znieczulenia w milisekundach.",
                    label = "Wygaszanie podczas znieczulenia (ms)",
                },
                operationsIdleTimeoutSeconds = {
                    description = "Maksymalny czas bez prawidłowej akcji w minigrze, po którym sesja zostanie przerwana.",
                    label = "Limit bezczynności (s)",
                },
                operationsInteractDistance = {
                    description = "Maksymalna odległość wyświetlania i używania interakcji w sali operacyjnej.",
                    label = "Odległość interakcji",
                },
                operationsInteractKey = {
                    description = "ID sterowania używane do interakcji ze stołem operacyjnym i pozycją chirurga.",
                    label = "Klawisz interakcji",
                },
                operationsPatientAnimationDict = {
                    description = "Słownik animacji GTA dla pacjenta leżącego w pełnym znieczuleniu.",
                    label = "Słownik animacji pacjenta",
                },
                operationsPatientAnimationFlag = {
                    description = "Flaga animacji GTA dla animacji leżącego pacjenta.",
                    label = "Flaga animacji pacjenta",
                },
                operationsPatientAnimationName = {
                    description = "Klip animacji dla pacjenta leżącego w pełnym znieczuleniu.",
                    label = "Nazwa animacji pacjenta",
                },
                operationsPatientRange = {
                    description = "Maksymalny zasięg wykrywania pacjenta leżącego na stole operacyjnym.",
                    label = "Zasięg pacjenta",
                },
                operationsRequireOnDuty = {
                    description = "Wymaga, aby chirurdzy byli na służbie przed użyciem sali operacyjnej.",
                    label = "Wymagaj służby",
                },
                operationsSelectionTimeoutSeconds = {
                    description = "Maksymalny czas, przez który chirurg może pozostać na ekranie wyboru operacji, zanim sesja zostanie przerwana.",
                    label = "Limit wyboru (s)",
                },
                operationsTrainingAnimationDict = {
                    description = "Słownik animacji GTA dla treningu chirurgicznego bez pacjenta.",
                    label = "Słownik animacji treningowej",
                },
                operationsTrainingAnimationFlag = {
                    description = "Flaga animacji GTA dla animacji treningu chirurgicznego.",
                    label = "Flaga animacji treningowej",
                },
                operationsTrainingAnimationName = {
                    description = "Klip animacji dla treningu chirurgicznego bez pacjenta.",
                    label = "Nazwa animacji treningowej",
                },
                painClassesProfiles = {
                    description = "Progi bólu, etykiety i efekty przetwarzania końcowego.",
                    label = "Zajęcia bólowe",
                },
                painEffectsMinPainLevel = {
                    description = "Minimalny poziom bólu przed rozpoczęciem efektów ekranu bólu.",
                    label = "Minimalny poziom bólu",
                },
                primaryColor = {
                    description = "Główny kolor interfejsu EMS i grupy prac ratownictwa medycznego.",
                    label = "Kolor podstawowy",
                },
                propPlacementConsumeItem = {
                    description = "Zużyj pasujący przedmiot z ekwipunku, gdy rekwizyt zostanie umieszczony.",
                    label = "Zużyj przedmiot",
                },
                propPlacementEnabled = {
                    description = "Zezwalaj na umieszczanie skonfigurowanych rekwizytów EMS z możliwych do wykorzystania przedmiotów z ekwipunku.",
                    label = "Włączony",
                },
                propPlacementItemNames = {
                    description = "Mapuj modele rekwizytów EMS na nazwy pozycji w ekwipunku w celu rozmieszczenia opartego na przedmiotach.",
                    label = "Nazwy elementów rekwizytów",
                },
                propPlacementRequireOnDuty = {
                    description = "Wymagaj, aby gracz był na służbie przed umieszczeniem rekwizytów EMS.",
                    label = "Wymagaj na służbie",
                },
                propPlacementReturnItem = {
                    description = "Oddaj zużyty przedmiot, gdy umieszczony rekwizyt zostanie usunięty.",
                    label = "Zwróć przedmiot po usunięciu",
                },
                propPlacementVehicleAccess = {
                    description = "Pozwól rekwizytom pnia otwierać proces umieszczania zamiast używać tylko przedmiotów.",
                    label = "Dostęp pojazdu",
                },
                publicTreatmentAllowConsciousPatients = {
                    description = "Zezwalaj na publiczne traktowanie świadomych graczy.",
                    label = "Pozwól świadomym pacjentom",
                },
                publicTreatmentAllowedGangs = {
                    label = "Dozwolone gangi",
                    description = "Wybierz wewnętrzne nazwy gangów lub niezależnych organizacji. Zgodny zawód lub gang przyznaje uprawnienie lub wyjątek. Służba jest wymagana tylko dla zawodów. Opcjonalne minimalne rangi gangów. Pusta lista pozwala na wszystkie rangi. Wymagania przedmiotów nadal obowiązują.",
                },
                publicTreatmentAllowedJobs = {
                    description = "Zawody, które mogą wymagać publicznego traktowania bez bycia EMS.",
                    label = "Dozwolone prace",
                },
                publicTreatmentEnabled = {
                    description = "Włącz publiczne traktowanie ratowników niebędących służbami ratunkowymi z ważnym dostępem.",
                    label = "Włączono leczenie publiczne",
                },
                publicTreatmentInteractDistance = {
                    description = "Maksymalna odległość wymagana do rozpoczęcia leczenia publicznego.",
                    label = "Odległość interakcji",
                },
                publicTreatmentKeybind = {
                    description = "Domyślny skrót klawiaturowy interakcji używany do traktowania publicznego.",
                    label = "Klawisz",
                },
                publicTreatmentInteractionEnabled = {
                    description = "Wyświetla komunikat o leczeniu i włącza przypisany klawisz. Wyłącz tę opcję, jeśli korzystasz z eksportów lub własnego menu kołowego.",
                    label = "Interakcja klawiszem włączona",
                },
                publicTreatmentPromptDistance = {
                    description = "Odległość używana do wyświetlania monitu o leczenie publiczne.",
                    label = "Natychmiastowa odległość",
                },
                publicTreatmentRequireAllItems = {
                    description = "Wymagaj każdego wymienionego przedmiotu medycznego, a nie tylko jednego.",
                    label = "Wymagaj wszystkich przedmiotów",
                },
                publicTreatmentRequiredItems = {
                    description = "Przedmioty z ekwipunku, które liczą się jako ważny sprzęt do leczenia publicznego.",
                    itemLabel = "Przedmiot",
                    label = "Wymagane przedmioty",
                },
                reviveRewardAccount = {
                    description = "Klucz konta głównego używany do ożywiania płatności nagród.",
                    label = "Konto",
                },
                reviveRewardAccountType = {
                    description = "Podstawowy typ konta używany do płatności nagród w ramach ożywienia.",
                    label = "Typ konta",
                },
                reviveRewardAmount = {
                    description = "Kwota nagrody wypłacana medykowi za ożywienie.",
                    label = "Kwota",
                },
                reviveRewardCurrency = {
                    description = "Opcjonalny niestandardowy klucz walutowy używany do przywracania płatności nagród.",
                    label = "Waluta",
                },
                reviveRewardEnabled = {
                    description = "Zapłać skonfigurowaną nagrodę po udanym ożywieniu medyka.",
                    label = "Włączony",
                },
                reviveRewardPayFromSociety = {
                    description = "Odejmij nagrody za ożywienie ze wspólnego stowarzyszenia zawodowego przed zapłaceniem medykowi.",
                    label = "Zapłać od społeczeństwa",
                },
                selfDiagnoseCommand = {
                    description = "Polecenie czatu używane do otwierania autodiagnostyki.",
                    label = "Rozkaz",
                },
                selfDiagnoseEnabled = {
                    description = "Zezwalaj graczom na samodzielne otwieranie interfejsu diagnozowania.",
                    label = "Włączono autodiagnostykę",
                },
                selfDiagnoseKeybind = {
                    description = "Domyślny skrót klawiszowy używany do otwierania autodiagnostyki.",
                    label = "Klawisz",
                },
                selfDiagnoseOpenDelayMs = {
                    description = "Opóźnienie przed otwarciem interfejsu autodiagnostyki.",
                    label = "Opóźnienie otwarcia ms",
                },
                selfDiagnoseRequireMedicJob = {
                    description = "Ogranicz samodiagnostykę wyłącznie do zawodów medycznych.",
                    label = "Wymagaj pracy lekarza",
                },
                selfDiagnoseSkipFreezeOnSelf = {
                    description = "Nie zamrażaj odtwarzacza podczas autodiagnostyki.",
                    label = "Pomiń zamrożenie siebie",
                },
                statusEffectsProfiles = {
                    description = "Skonfigurowane efekty ekranowe i progi krwawienia, niskiego poziomu krwi, głodu i pragnienia.",
                    label = "Efekty stanu",
                },
                stretcherAnimDict = {
                    description = "Słownik animacji używany podczas noszenia noszy.",
                    label = "Animacja dykt",
                },
                stretcherAnimName = {
                    description = "Nazwa animacji używana podczas noszenia noszy.",
                    label = "Nazwa animacji",
                },
                stretcherAttachRx = {
                    description = "Przenoś uchwyt obrotowy w kształcie X dla noszy.",
                    label = "Dołącz RX",
                },
                stretcherAttachRy = {
                    description = "Przenoś uchwyt obrotowy w kształcie litery Y do noszy.",
                    label = "Dołącz RY",
                },
                stretcherAttachRz = {
                    description = "Przenoś uchwyt obrotowy w kształcie Z do noszy.",
                    label = "Dołącz RZ",
                },
                stretcherAttachX = {
                    description = "Noś przystawkę X z przesunięciem do noszy.",
                    label = "Dołącz X",
                },
                stretcherAttachY = {
                    description = "Noś przystawkę Y z przesunięciem do noszy.",
                    label = "Dołącz Y",
                },
                stretcherAttachZ = {
                    description = "Noś przystawkę z przesunięciem Z do noszy.",
                    label = "Dołącz Z",
                },
                stretcherFoldedEnabled = {
                    description = "Włącz opcjonalny wariant składanych noszy wewnątrz pojazdów.",
                    label = "Możliwość składania",
                },
                stretcherFoldedModel = {
                    description = "Model rekwizytu stosowany w wariancie składanych noszy.",
                    label = "Składany model",
                },
                stretcherFoldedPatientAttachHeading = {
                    description = "Nagłówek pacjenta używany w wariancie złożonych noszy.",
                    label = "Złożony nagłówek pacjenta",
                },
                stretcherFoldedPatientAttachX = {
                    description = "Pacjent dołącza przesunięcie X do złożonych noszy.",
                    label = "Złożony pacjent X",
                },
                stretcherFoldedPatientAttachY = {
                    description = "Pacjent dołącza przesunięcie Y do złożonych noszy.",
                    label = "Złożony pacjent Y",
                },
                stretcherFoldedPatientAttachZ = {
                    description = "Pacjent dołącza przesunięcie Z do złożonych noszy.",
                    label = "Złożony pacjent Z",
                },
                stretcherHelicopterInteractDistance = {
                    description = "Zastąpienie odległości interakcji stosowane w przypadku helikopterów.",
                    label = "Odległość interakcji helikoptera",
                },
                stretcherHelicopterModels = {
                    description = "Modele pojazdów traktowane jak helikoptery na noszach.",
                    itemLabel = "Wzór",
                    label = "Modele helikopterów",
                },
                stretcherHelicopterPickupDistance = {
                    description = "Zastąpienie odległości odbioru stosowane w przypadku helikopterów.",
                    label = "Odległość odbioru helikoptera",
                },
                stretcherInteractDistance = {
                    description = "Maksymalna odległość dla monitów o interakcję z noszami.",
                    label = "Odległość interakcji",
                },
                stretcherItemEnabled = {
                    description = "Włącza przedmiot noszy w ekwipunku, w tym zakup w sklepie i używanie.",
                    label = "Przedmiot noszy",
                },
                stretcherItemPickupEnabled = {
                    description = "Zezwala na zwracanie do ekwipunku noszy rozstawionych z przedmiotu w ekwipunku.",
                    label = "Podnoszenie przedmiotu",
                },
                stretcherModel = {
                    description = "Podstawowy model podpory noszy używany w systemie noszy EMS.",
                    label = "Wzór",
                },
                stretcherPatientAnimationDict = {
                    description = "Słownik animacji pacjentów na noszach i postaci podglądu.",
                    label = "Słownik animacji pacjenta",
                },
                stretcherPatientAnimationName = {
                    description = "Klip animacji pacjentów na noszach i postaci podglądu.",
                    label = "Nazwa animacji pacjenta",
                },
                stretcherPatientAttachHeading = {
                    description = "Pozycja pacjenta używana podczas leżenia na noszach.",
                    label = "Nagłówek pacjenta",
                },
                stretcherPatientAttachX = {
                    description = "Pacjent przymocowuje przesunięcie X na noszach.",
                    label = "Pacjent X",
                },
                stretcherPatientAttachY = {
                    description = "Pacjent przymocowuje przesunięcie Y na noszach.",
                    label = "Pacjent Y",
                },
                stretcherPatientAttachZ = {
                    description = "Pacjent dołącza przesunięcie Z na noszach.",
                    label = "Pacjent Z",
                },
                stretcherPickupDistance = {
                    description = "Odległość wymagana do podniesienia noszy i interakcji z nimi.",
                    label = "Odległość odbioru",
                },
                stretcherTreatmentAnimClip = {
                    description = "Klip animacyjny wykorzystany podczas leczenia pacjenta na noszach. Pozostaw puste, aby użyć scenariusza lub animacji zastępczej leczenia.",
                    label = "Nazwa animacji",
                },
                stretcherTreatmentAnimDict = {
                    description = "Słownik animacji stosowany podczas leczenia pacjenta na noszach. Pozostaw puste, aby użyć scenariusza lub animacji zastępczej leczenia.",
                    label = "Słownik animacji",
                },
                stretcherTreatmentAnimScenario = {
                    description = "Scenariusz opcjonalny stosowany podczas leczenia pacjenta na noszach. Pozostaw puste, aby użyć dyktowania i klipu lub zastępczej animacji leczenia.",
                    label = "Scenariusz",
                },
                stretcherVehicleAttachRx = {
                    description = "Przymocowanie pojazdu Obrót w osi X w celu załadunku noszy.",
                    label = "Pojazd RX",
                },
                stretcherVehicleAttachRy = {
                    description = "Zaczep do pojazdu, obrót Y w celu załadunku noszy.",
                    label = "Pojazd RY",
                },
                stretcherVehicleAttachRz = {
                    description = "Zaczep do pojazdu Obrót w kierunku Z w celu załadunku noszy.",
                    label = "Pojazd RZ",
                },
                stretcherVehicleAttachX = {
                    description = "Zaczep pojazdu z przesunięciem X w celu załadunku noszy.",
                    label = "Pojazd X",
                },
                stretcherVehicleAttachY = {
                    description = "Zamocowanie pojazdu z przesunięciem Y w celu załadunku noszy.",
                    label = "Pojazd Y",
                },
                stretcherVehicleAttachZ = {
                    description = "Zamocowanie pojazdu w przesunięciu Z do załadunku noszy.",
                    label = "Pojazd Z",
                },
                stretcherVehicleModels = {
                    description = "Modele pojazdów mogły załadować nosze.",
                    itemLabel = "Wzór",
                    label = "Modele pojazdów",
                },
                treatmentAnimClip = {
                    description = "Klip animacyjny wykorzystany podczas leczenia pacjenta. Pozostaw puste, aby zamiast tego użyć scenariusza.",
                    label = "Nazwa animacji",
                },
                treatmentAnimDict = {
                    description = "Słownik animacji stosowany podczas leczenia pacjenta. Pozostaw puste, aby zamiast tego użyć scenariusza.",
                    label = "Słownik animacji",
                },
                treatmentAnimScenario = {
                    description = "Scenariusz stosowany podczas leczenia pacjenta. Pozostaw puste, aby zamiast tego użyć dyktowania i klipu.",
                    label = "Scenariusz",
                },
                trunkPropsEnabled = {
                    label = "Obiekty pojazdu",
                    description = "Wybierz obiekty przy pobliskim pojeździe służbowym.",
                },
                trunkEnabled = {
                    description = "Włącz funkcję bagażnika pojazdu dla pojazdów pogotowia ratunkowego.",
                    label = "Włączony",
                },
                vehicleDamageModifier = {
                    description = "Mnożnik obrażeń stosowany, gdy gracz znajduje się w pojeździe.",
                    label = "Modyfikator uszkodzeń pojazdu",
                },
                vehicleImpactProtectionCauses = {
                    description = "Przyczyny śmierci, które należy liczyć jako chronione uderzenia pojazdu.",
                    itemLabel = "Przyczyna",
                    label = "Przyczyny uszkodzeń",
                },
                vehicleImpactProtectionEnabled = {
                    description = "Zapobiegaj zabiciu gracza przez uderzenia pojazdów przy niskiej prędkości.",
                    label = "Włączony",
                },
                vehicleImpactProtectionFatalSpeedKmh = {
                    description = "Uderzenia pojazdu poniżej tej prędkości nie mogą zabić gracza.",
                    label = "Fatalna prędkość km/h",
                },
                vehicleImpactProtectionFullDamageSpeedKmh = {
                    description = "Uderzenia pojazdu z tą prędkością lub powyżej są traktowane jako normalna konfiguracja powodująca śmierć.",
                    label = "Pełna prędkość niszczenia km/h",
                },
                vehicleImpactProtectionInjuries = {
                    description = "Urazy powstają, gdy zabezpieczenie przed uderzeniem pojazdu blokuje śmiertelne uderzenie.",
                    itemLabel = "Obrażenia",
                    label = "Kontuzje",
                },
                vehicleImpactProtectionSurvivalHealthPercent = {
                    description = "Procent maksymalnego zdrowia zachowanego, gdy chronione uderzenie spowodowałoby śmierć gracza.",
                    label = "Procent zdrowia przetrwania",
                },
                vehiclePullEnabled = {
                    description = "Umożliwia wyciąganie pacjentów z pojazdów.",
                    label = "Włączony",
                },
                vehiclePullMaxDistance = {
                    description = "Maksymalna odległość wymagana do wyciągnięcia pacjenta z pojazdu.",
                    label = "Maksymalna odległość",
                },
                wheelchairAssignMaxDistance = {
                    description = "Maksymalna odległość przydzielenia wózka inwalidzkiego innemu graczowi.",
                    label = "Przypisz maksymalną odległość",
                },
                wheelchairAutoUnequipOnExpire = {
                    description = "Automatycznie zdejmij wózek inwalidzki po wygaśnięciu przydziału.",
                    label = "Automatyczne zdejmowanie po wygaśnięciu",
                },
                wheelchairDefaultDurationMinutes = {
                    description = "Domyślny czas trwania przypisanego wózka inwalidzkiego w minutach.",
                    label = "Domyślny czas trwania",
                },
                wheelchairDisableSprint = {
                    description = "Blokuj sprint, gdy wózek inwalidzki jest na wyposażeniu.",
                    label = "Wyłącz sprint",
                },
                wheelchairDisableWeapons = {
                    description = "Blokuj użycie broni, gdy wózek inwalidzki jest na wyposażeniu.",
                    label = "Wyłącz broń",
                },
                wheelchairExitControl = {
                    description = "Identyfikator kontrolny użyty do opuszczenia wózka inwalidzkiego.",
                    label = "Wyjdź z kontroli",
                },
                wheelchairItemName = {
                    description = "Element wyposażenia używany w wózku inwalidzkim.",
                    label = "Nazwa przedmiotu",
                },
                wheelchairMaxDurationMinutes = {
                    description = "Maksymalny dozwolony czas przydzielenia wózka inwalidzkiego w minutach.",
                    label = "Maksymalny czas trwania",
                },
                wheelchairMinDurationMinutes = {
                    description = "Minimalny dozwolony czas przydzielenia wózka inwalidzkiego w minutach.",
                    label = "Minimalny czas trwania",
                },
                wheelchairVehicle = {
                    description = "Model pojazdu używany dla wózka inwalidzkiego.",
                    label = "Model pojazdu",
                },
                xrayInteractionRange = {
                    description = "Maksymalna odległość operatora od stacji rentgenowskiej.",
                    label = "Zakres interakcji",
                },
                xrayPatientRange = {
                    description = "Maksymalna odległość pacjenta od stacji rentgenowskiej.",
                    label = "Zakres pacjentów",
                },
                xrayScanDurationSeconds = {
                    description = "Czas trwania wyniku skanowania rentgenowskiego w sekundach.",
                    label = "Czas trwania skanowania",
                },
                appointmentsBookingCooldownSeconds = {
                    description = "Zimno w sekundach pomiędzy próbami rezerwacji pacjenta.",
                    label = "Rezerwacja chłodzenia",
                },
                appointmentsEnabled = {
                    description = "Aktywuj rezerwację spotkania pacjenta i osobisty kalendarz medycyny.",
                    label = "Włączone",
                },
                appointmentsMaxAdvanceDays = {
                    description = "Maksymalna liczba dni w przyszłości, które pacjent może zarezerwować.",
                    label = "Maksymalna wcześniejsza rezerwacja",
                },
                appointmentsMaxAppointmentsPerPlayer = {
                    description = "Maksymalna liczba aktywnych terminów przyszłego pobytu pacjenta.",
                    label = "Maksymalna liczba terminów na pacjenta",
                },
                appointmentsMinLeadMinutes = {
                    description = "Minimalna liczba minut między rezerwacją a spotkaniem.",
                    label = "Minimalny czas ołowiu",
                },
                appointmentsNotificationApp = {
                    description = "Identyfikator aplikacji telefonicznej używany do powiadomień o spotkaniu.",
                    label = "Aplikacja do powiadomienia",
                },
                appointmentsNotificationsEnabled = {
                    description = "Powiadomienie pacjentów na telefonie o zarezerwowaniu lub anulowaniu wizyt.",
                    label = "Informacja telefoniczna",
                },
                appointmentsReasonMaxLength = {
                    description = "Maksymalna liczba znaków akceptowanych z powodu spotkania.",
                    label = "Uzasadnienie ograniczenia charakteru",
                },
                appointmentsSlotDurationMinutes = {
                    description = "Czas trwania i odstęp siatki miejsca spotkania w minutach.",
                    label = "Czas trwania ścieżki",
                },
                enforceMaxHealth = {
                    description = "Zachowywać maksymalne zdrowie gracza przy 200. Wyłącz to, gdy inny zasób zarządza maksymalnym zdrowiem.",
                    label = "Wykonanie 200 max zdrowie",
                },
                firstAidLicenseManagementAdditionalLicenses = {
                    description = "Dodatkowe licencje ramowe personel karetki może przekazywać lub usunąć w rejestrach pacjentów. Skonfigurowana licencja pomocy pierwszej jest zawsze włączona.",
                    itemLabel = "Licencja",
                    label = "Dodatkowe licencje pacjenta",
                },
                minigamesBandageWrapRandomization = {
                    description = "Randomizuj kierunek ścieżki gazy, kształt i proporcje.",
                    label = "Wariancja zawijania pasma",
                },
                minigamesBloodTransfusionAccessRandomization = {
                    description = "Zdecydować drogę dostępu do żylnej transfuzji krwi.",
                    label = "Zmiana dostępu do transfuzji",
                },
                minigamesBloodTransfusionVenousAccess = {
                    description = "Przed kontrolą przepływu wymagaj wielostopniowej procedury dostępu do żylnej. Wyłącz dla starej prostej wersji.",
                    label = "Szybki etap dostępu",
                },
                minigamesBulletExtractionRandomization = {
                    description = "Przypadkowo zredukować kształt kanału, szerokość i niedrożność.",
                    label = "Wariant ekstrakcji kulek",
                },
                stretcherVehicleAttachEditor = {
                    description = "Położenie i obracanie nośników w skonfigurowanej karetce.",
                    label = "Zamocowanie pojazdu",
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
            warnings = {
                firstAidPublicTreatmentConflict = "Nie można jednocześnie włączyć funkcji Pierwsza pomoc i Leczenie publiczne. Zapisywanie wyłącza oba.",
            },
            actions = {
                hideDetails = "Close",
                editPosition = "Edit",
                actionFailed = "Unable to save changes.",
                editDetails = "Edit",
                delete = "Delete",
                remove = "Delete",
            },
        },
    },
}
