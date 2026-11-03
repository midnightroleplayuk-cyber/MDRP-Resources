JobConfigLocales["sky_policejob:rs"] = {
    JobConfiguratorComingSoon = "Ovaj konfigurator posla uskoro stiže.",
    JobConfiguratorImportFailed = "Uvoz vrednosti iz config.lua za '%s' nije uspeo: %s.",
    JobConfiguratorImportHistoryFailed = "Uvoz je uspeo, ali zapis istorije nije mogao biti sačuvan.",
    JobConfiguratorImportNoData = "'%s' ne sadrži podatke za uvoz iz config.lua.",
    JobConfiguratorImportSuccess = "Uvezene su vrednosti iz config.lua za '%s': primenjeno je %d odstupanja poslova, %d podešavanja, %d funkcija i %d interakcija.",
    JobConfiguratorNoPermission = "Nemate dozvolu za korišćenje ove komande.",
    Nui = {
        workshopConfig = {
            configs = {
                sky_policejob = {
                    subtitle = "Konfigurišite policijska odeljenja, prodavnice, rekvizite, vozila, stanice i osnovna podešavanja funkcija.",
                    title = "Policijski poslovi",
                },
            },
            dispatchActions = {
                addChannel = "Додај радио-канал",
                addKeyword = "Додај кључну реч",
                addPoi = "Додај тачку интереса",
                addReporter = "Додај пријавиоца",
                addStatus = "Додај FMS статус",
                addVehicle = "Додај виртуелну јединицу",
                addVehicleType = "Додај врсту јединице",
                currentLocation = "Користи текућу локацију",
            },
            dispatchFieldDescriptions = {
                autoAlarm = "Одмах додељује поклапање доступних јединица када се направи инцидент.",
                available = "Jedinice u ovom statusu mogu biti predložene i dodeljene novom incidentu.",
                averageResponseSpeedKmh = "Израчунава приказану процену доласка са десне линије.",
                callsign = "Jedinstveni radio signal prikazan kada igraèi zauzimaju ovu virtuelnu jedinicu.",
                centerEnabled = "Omoguæava èlanovima dežurstva da osnuju dispeèerski centar.",
                channelId = "Radio-kanal ID za PMA glas, Saltièat i JACA. Бројне идентификације као што је 2500 остају непромењене; ПМА Глас мапира текстуалне идентификације на стабилан број.",
                channelLabel = "Читаво име канала приказано диспечерима и јединицама.",
                crewCapacity = "Највећи број особа у јединици. Вредност 0 дозвољава неограничену посаду.",
                defaultChannel = "Dispeèeri se pridružuju ovom kanalu kada poènu svoju smenu. Jedinice se ruèno pridružuju sa radija. Изаберите ниједну за подразум › ијевану радну групу.",
                emergencyAppEnabled = "Ovaj posao èini odabranim za javnu službu u aplikaciji za hitne sluèajeve.",
                enabled = "Tako je ovaj posao dostupan za Dispeèer App i incidente sa unakrsnim poslovima.",
                icon = "Изаберите икону приказану у овој категорији јединице у диспечерском аппу.",
                incidentAssessmentEnabled = "Показује медицинску и опасну процену питања у пуном уносу инцидената.",
                jobs = "Dodatna radna imena koja primaju incidente koristeæi ovu kljuènu reè.",
                joinLocked = "Спречава придруживање додатних особа након што је јединица попуњена.",
                minimumCrew = "Најмањи број особа у јединицама изабраним за овај план одзива.",
                noUnitFallback = "Без центра или особља јединице, шаље небо обавештење свим члановима на дужности.",
                poiId = "Стабилна техничка ознака на коју профили центра упућују и после промене назива места.",
                radius = "Maksimalna udaljenost u metrima na kojoj se može èuti saopštenje stanice.",
                readyStatusCode = "FMS статус који се поставља када ресурс постане спреман за слање.",
                requirements = "Broj parova, na primer PATROL: 2, CRIME: 1.",
                resourceType = "Разврстава оперативни ресурс за филтере и координацију диспечерског центра.",
                respondingStatusCode = "FMS статус који се поставља када ресурс одговори на интервенцију.",
                shortLabel = "Необавезна кратка ознака на шест тастера меморије радио-канала.",
                stationId = "Повезује јединицу са станицом подешеном у профилу диспечерског центра.",
                statusCode = "Numeric FMS status prikazan na ruènom radiju.",
                statusLabel = "Što znaèi status FMS-a za dispeèere i jedinice.",
                unitId = "Стабилна техничка ознака која чува јединицу и после промене позивног знака.",
                vehicleType = "Mora da se podudara sa kodom tipa vozila koji je podešen u prethodnoj podsekciji.",
                vehicleTypeCode = "Kratki kod za reagovanje, na primer PATROL, CRIME, EMS, ili Spasenje.",
                vehicleTypeLabel = "Poznato ime ove jedinice.",
            },
            dispatchFields = {
                address = "Адреса",
                autoAlarm = "Аутоматски аларм",
                available = "Доступан за диспечерName",
                averageResponseSpeedKmh = "Процењена брзина одзива (km / h)",
                callsign = "Позив",
                category = "Категорија",
                centerEnabled = "Укључи центар за диспечере",
                channelId = "ИД канала",
                code = "Šifra",
                crewCapacity = "Капацитет посаде",
                defaultChannel = "Подразум › ијевани радио канал",
                emergencyAppEnabled = "Прикажи у хитној апликацији",
                enabled = "Укључи диспечер",
                icon = "Икона",
                incidentAssessmentEnabled = "Укључи хитну процену",
                jobs = "Мета послова (зарез раздвојен)",
                joinLocked = "Закључај придруживање посади",
                keywordCode = "Шифра кључне речи",
                label = "Ознака",
                minimumCrew = "Најмањи број посаде",
                name = "Име",
                noUnitFallback = "Obavestite osoblje na dužnosti bez jedinica",
                noneChannel = "Ниједна група подразумевана",
                note = "Напомена",
                phone = "Telefon",
                poiId = "Стабилни ID тачке интереса",
                radius = "Радијум најаве",
                readyStatusCode = "Код статуса спремности",
                requirements = "Тражене јединице (на пример патрол: 2, злочин: 1)",
                resourceType = "Врста ресурса",
                respondingStatusCode = "Код статуса одзива",
                shortLabel = "Ознака радио-меморије",
                stationId = "ID станице",
                type = "Тип",
                unitId = "Стабилни ID јединице",
                vehicleType = "Тип одзивне јединице",
                radioButton = "Дугме",
                radioButtonAction = "Радња дугмади",
                radioButtonStatus = "FMS стање",
            },
            dispatchIconOptions = {
                crime = "Jedinica za kriminal",
                emergency = "Jedinica za hitne sluèajeve",
                ems = "ЕМС јединица",
                fire = "Ватрена јединица",
                heavy = "Тешка јединица",
                k9 = "К ‑ 9 јединица",
                medical = "Medicinska jedinica",
                patrol = "Patrola",
                rescue = "Spasilaèka jedinica",
                service = "Службена јединица",
                supervisor = "Supervizor",
                tactical = "Тактичка јединица",
            },
            dispatchNavigation = {
                active = "Dispeèer aktivan",
                description = "Подесите унос за хитне случајеве, радио, јединице, планове одговора, локације и податке новинара за овај посао.",
                inactive = "Centrala onesposobljena",
                steps = {
                    accessText = "Укључите диспечера и одлучите да ли овај посао може да запошљава центар за диспечере.",
                    accessTitle = "Приступ и хитан унос",
                    fleetText = "Подешавање канала, ФМС статус кодове, типове возила, и знаке позива.",
                    fleetTitle = "Radio i flota",
                    responseText = "Završite sa kljuènim reèima, zahtevima za odgovorima, i POI.",
                    responseTitle = "Планови одговора",
                },
                summary = {
                    channels = "Радио канали",
                    plans = "Планови одговора",
                    reporters = "Познати пријавиоци",
                    statuses = "Доступни ФМС",
                    units = "Виртуелне јединице",
                },
                title = "Dispeèer",
                warnings = {
                    channels = "Не постоје експлицитни радио канали; канал за спадање групе ће бити коришћен.",
                    defaultChannel = "Изабрани подразумевани канал више не постоји.",
                    disabled = "Dispeèer je onemoguæen za ovaj posao.",
                    statuses = "Bar jedan FMS status mora biti dostupan da bi jedinice bile alarmirane.",
                },
            },
            extensionDescriptions = {
                dispatchChannels = "Definiši radio kanale kojima se mogu pridružiti jedinice i dispeèerski centri.",
                dispatchKeywords = "Definiše kljuène reèi, potrebne troškove vozila, posao uèesnika, i moguænost automatskog alarma.",
                dispatchPois = "Stanice i zajednièke lokacije za incidente i objave postaja.",
                dispatchReporters = "Управља именима пријавилаца, бројевима за повратни позив и белешкама диспечера за овај посао.",
                dispatchStatusCodes = "Подешавање ФМС етикета стања и који статус се рачуна као доступан за нове инциденте.",
                dispatchVehicleTypes = "Definiše kategorije jedinica koje koriste planovi za reagovanje, kao što su Patrola, Jedinica za kriminal, EMS, ili Spasioci.",
                dispatchVehicles = "Definiše virtuelna vozila za dostavu koja mogu da se prebace sa bilo kog mesta, a da im ne treba vozilo za razmnožavanje.",
                dispatchRadioButtons = "Поставља централно дефинисану радњу за свако дугме физичке функције.",
                dispatchRadioFmsKeys = "Додељује FMS стање физичким кључевима бројева. Тастери извршавају само FMS измене.",
            },
            extensions = {
                caseNumbering = {
                    label = "Brojevi predmeta",
                    description = "Podesite automatske brojeve predmeta za ovaj posao.",
                    fields = {
                        prefix = {
                            label = "Prefiks predmeta",
                            description = "Prefiks novih predmeta, npr. LSPD ili LSCSD. Najviše 16 znakova, pretvorenih u velika slova; prazno polje koristi CASE. Postojeći i ručno dodeljeni brojevi ostaju nepromenjeni.",
                        },
                    },
                },
                dispatchReporters = "Познати пријавиоци",
                invalidSelection = "Nevažeći izbor: {value}",
                trainingSettings = {
                    description = "Подеси приступ тренингу, упис, дозволе, и планирање курса за овај посао.",
                    label = "Поставке тренинга",
                },
                dispatchChannels = "Радио канали",
                dispatchKeywords = "Кључне речи и планови одговора",
                dispatchPois = "Диспечерски ПУИ",
                dispatchSettings = {
                    description = "Подешавање приступа диспечеру, хитног прихватања и подразумеваног радио канала.",
                    label = "Поставке диспечера",
                },
                dispatchStatusCodes = "Кодови стања",
                dispatchVehicleTypes = "Распореди типове возила",
                dispatchVehicles = "Пошаљи податке флоте",
                emptyDescription = "Користите дугме за додавање изнад да направите први унос.",
                emptyTitle = "Ništa nije konfigurisano",
                dispatchRadioButtons = "Радио функција дугмад",
                dispatchRadioFmsKeys = "FMS додељење тастера",
            },
            features = {
                billing = {
                    description = "Omogućite tokove fakturisanja policije.",
                    label = "Fakturisanje",
                },
                devices = {
                    description = "Omogućite raspoređive uređaje za sprovođenje zakona.",
                    label = "CCTV i kamere za brzinu",
                },
                evidence = {
                    description = "Omogućite skladištenje dokaza, terenske dokaze i tokove skenera.",
                    label = "Dokazi",
                },
                impound = {
                    description = "Omogućite tokove oduzetišta vozila.",
                    label = "Oduzimanje vozila",
                },
                jail = {
                    description = "Omogućite dodelu zatvorske kazne i aktivnosti zatvorenika.",
                    label = "Zatvor",
                },
                propPlacement = {
                    description = "Omogućite konfigurabilne policijske rekvizite i opremu rekvizita za vozila.",
                    label = "Postavljanje rekvizita",
                },
                radial = {
                    description = "Omogućite policijske radijalne radnje poput oduzimanja vozila i blokade točka.",
                    label = "Radijalne radnje",
                },
                restraints = {
                    description = "Omogućite lisice, vezice, sponice za noge i vreće za glavu.",
                    label = "Sredstva vezivanja",
                },
                socialWork = {
                    description = "Omogućite dodelu društveno korisnog rada i aktivnosti zadataka.",
                    label = "Društveno koristan rad",
                },
                tablet = {
                    description = "Omogućite aplikacije policijskog tableta konfigurisane ovim resursom.",
                    label = "Policijski tablet",
                },
                tracking = {
                    description = "Omogućite GPS tragače i monitore za gležanj.",
                    label = "Praćenje",
                },
                vehicleRadar = {
                    description = "Omogućite radar patrolnog vozila.",
                    label = "Radar vozila",
                },
            },
            messages = {
                dispatchEmergencyRequiresDispatch = "За приказ овог посла у апликацији за хитне позиве диспечерски систем мора бити укључен. Укључите га или искључите приказ у апликацији за хитне позиве у подешавањима диспечерског система.",
                dispatchJobNotCovered = "Ниједан активни диспечерски центар не покрива посао „{job}“. У sky_jobs_base/config/config.lua додајте „{job}“ у coveredJobs одговарајућег профила Config.Dispatch.centers, па поново покрените sky_jobs_base. Ресетовање подешавања не мења ову доделу.",
                invalidDispatchChannels = "ID-ови радио-канала морају бити јединствени и сваки канал мора имати важећу ознаку.",
                invalidDispatchDefaultChannel = "Подразумевани радио-канал не постоји. У подешавањима диспечерског система изаберите постојећи канал или „Ниједан“.",
                invalidDispatchKeywords = "Планови одзива морају имати јединствене кодове и важеће захтеве ВРСТА:БРОЈ.",
                invalidDispatchPois = "ID-ови, називи и координате тачака интереса морају бити важећи и јединствени.",
                invalidDispatchRadioButtons = "Проверите функцијске тастере радија: сваки подржани тастер користите само једном и изаберите радњу из његове листе.",
                invalidDispatchRadioFmsKeys = "Проверите FMS тастере радија: сваки тастер (0-9, * или #) користите само једном и доделите постојећи статусни код или га оставите без доделе.",
                invalidDispatchReadyStatus = "У подешавањима диспечерског система изаберите код спремности који је у листи статусних кодова означен као доступан.",
                invalidDispatchReporters = "Подаци познатих пријавилаца премашују дозвољени број уноса или дужину поља.",
                invalidDispatchRespondingStatus = "У подешавањима диспечерског система изаберите код изласка на интервенцију који је у листи статусних кодова означен као недоступан.",
                invalidDispatchSettings = "Изаберите постојећи доступни статус спремности, недоступни статус одзива и важећи подразумевани канал.",
                invalidDispatchStatusCodes = "FMS кодови морају бити јединствени и најмање један статус мора бити доступан.",
                invalidDispatchVehicleTypes = "Кодови врста јединица за одзив морају бити јединствени и потпуни.",
                invalidDispatchVehicles = "ID-ови и позивни знаци јединица морају бити јединствени, а све врсте и станице морају постојати.",
            },
            settingFields = {
                gangMinimumGrade = "Minimalni čin",
                gang = "Banda",
                component = "Komponenta",
                description = "Opis",
                fineAmount = "Iznos kazne",
                itemName = "Naziv predmeta",
                length = "Dužina",
                max = "Maks",
                maxOverKmh = "Maks prekoračenje",
                min = "мин.",
                minOverKmh = "Min prekoračenje",
                model = "Model rekvizita",
                propModel = "Model rekvizita",
                reason = "Razlog",
                vehicleClass = "Klasa",
            },
            settingGroups = {
                access = {
                    label = "Pristup",
                },
                animation = {
                    label = "Animacija",
                },
                ankleMonitor = {
                    label = "Monitor za gležanj",
                },
                ankleMonitorAccess = {
                    label = "Pristup monitoru za gležanj",
                },
                ankleMonitorPlacement = {
                    label = "Postavljanje monitora za gležanj",
                },
                ankleMonitorZone = {
                    label = "Zona monitora za gležanj",
                },
                ankleMonitorZoneVisual = {
                    label = "Vizuelni prikaz zone monitora za gležanj",
                },
                assignment = {
                    label = "Dodela",
                },
                blip = {
                    label = "Oznaka stanice na mapi",
                },
                carry = {
                    label = "Nošenje",
                },
                cctv = {
                    label = "CCTV",
                },
                cctvDurability = {
                    label = "Izdržljivost CCTV-a",
                },
                cctvPlacement = {
                    label = "Postavljanje CCTV-a",
                },
                cctvRepair = {
                    label = "Popravka CCTV-a",
                },
                cctvRepairAnimation = {
                    label = "Animacija popravke CCTV-a",
                },
                clamp = {
                    label = "Blokada točka",
                },
                clampWeld = {
                    label = "Zavarivanje blokade",
                },
                cleanup = {
                    label = "Čišćenje",
                },
                collection = {
                    label = "Prikupljanje",
                },
                controls = {
                    label = "Kontrole",
                },
                creator = {
                    label = "Kreator",
                },
                crimeSceneTape = {
                    label = "Traka za mesto zločina",
                },
                crimeSceneTapeAccess = {
                    label = "Pristup traci",
                },
                crimeSceneTapeInventory = {
                    label = "Inventar trake",
                },
                crimeSceneTapeLength = {
                    label = "Dužina trake",
                },
                crimeSceneTapePlacement = {
                    label = "Postavljanje trake",
                },
                database = {
                    label = "Baza podataka",
                },
                delivery = {
                    label = "Dostava",
                },
                detection = {
                    label = "Detekcija",
                },
                dispatch = {
                    label = "Dispečing",
                },
                escape = {
                    label = "Bekstvo",
                },
                escort = {
                    label = "Praćenje",
                },
                evidenceStorage = {
                    label = "Skladište dokaza",
                },
                fastLock = {
                    label = "Automatsko brzo zaključavanje",
                },
                general = {
                    label = "Opšte",
                },
                gpsTracker = {
                    label = "GPS tragač",
                },
                gpsTrackerAccess = {
                    label = "Pristup GPS tragaču",
                },
                gpsTrackerPlacement = {
                    label = "Postavljanje GPS tragača",
                },
                gpsTrackerTiming = {
                    label = "Vremenska podešavanja GPS tragača",
                },
                handcuffs = {
                    label = "Lisice",
                },
                handsUp = {
                    label = "Ruke uvis",
                },
                header = {
                    label = "Zaglavlje",
                },
                impound = {
                    label = "Oduzimanje vozila",
                },
                imprisonment = {
                    label = "Zatvaranje",
                },
                jailCanteenGeneral = {
                    label = "Zatvorska kantina",
                },
                jailCanteenPackage = {
                    label = "Paket zatvorske kantine",
                },
                jailCarry = {
                    label = "Posao nošenja",
                },
                jailCarryInspection = {
                    label = "Provera pri nošenju",
                },
                jailCleaning = {
                    label = "Posao čišćenja",
                },
                jailCleaningIllegalFinds = {
                    label = "Zabranjeni pronalasci",
                },
                jailCleaningOutline = {
                    label = "Kontura za čišćenje",
                },
                jailDoctor = {
                    label = "Zatvorski lekar",
                },
                jailElectricalCodes = {
                    label = "Šifre elektrike",
                },
                jailElectricalGeneral = {
                    label = "Zatvorska elektrika",
                },
                jailElectricalPenalties = {
                    label = "Kazne elektrike",
                },
                jailElectricalRewards = {
                    label = "Nagrade elektrike",
                },
                jailInmatesAlcoholic = {
                    label = "Zatvorenik alkoholičar",
                },
                jailInmatesCodeList = {
                    label = "Zatvorenik informator",
                },
                jailInmatesDrugDealer = {
                    label = "Zatvorenik diler droge",
                },
                jailInmatesWireCutter = {
                    label = "Zatvorenik dostavljač alata",
                },
                jailJobs = {
                    label = "Zatvorski poslovi",
                },
                jailOutfitFemale = {
                    label = "Ženska odeća",
                },
                jailOutfitMale = {
                    label = "Muška odeća",
                },
                keybinds = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Prečice",
                },
                keybindsHandcuff = {
                    label = "Prečica za lisice",
                },
                keybindsUnhandcuff = {
                    label = "Prečica za skidanje lisica",
                },
                marker = {
                    label = "Маркер",
                },
                markerColor = {
                    label = "Boja markera",
                },
                mugshotAnimation = {
                    label = "Animacija fotografije za dosije",
                },
                mugshotBoard = {
                    label = "Tabla za fotografiju",
                },
                mugshotCameraCoords = {
                    label = "Pozicija kamere za fotografiju",
                },
                mugshotCameraRotation = {
                    label = "Rotacija kamere za fotografiju",
                },
                mugshotGeneral = {
                    label = "Fotografija za dosije",
                },
                mugshotMetadata = {
                    label = "Metapodaci fotografije",
                },
                mugshotPosition = {
                    label = "Pozicija fotografije za dosije",
                },
                mugshotTiming = {
                    label = "Vremenska podešavanja fotografije za dosije",
                },
                officerDown = {
                    label = "Policajac ranjen",
                },
                outfit = {
                    label = "Odeća",
                },
                overlay = {
                    label = "Preklop tablice",
                },
                payment = {
                    label = "Plaćanje",
                },
                paymentFlow = {
                    label = "Tok plaćanja",
                },
                penalties = {
                    label = "Kazne",
                },
                playerSearch = {
                    label = "Pretres igrača",
                },
                playerSearchAnimation = {
                    label = "Animacija pretresa igrača",
                },
                props = {
                    label = "Predmeti rekvizita",
                },
                reasons = {
                    label = "Razlozi",
                },
                release = {
                    label = "Preuzimanje vozila",
                },
                restore = {
                    label = "Vraćanje",
                },
                rules = {
                    label = "Pravila",
                },
                scan = {
                    label = "Skeniranje",
                },
                scanner = {
                    label = "Skener",
                },
                sentence = {
                    label = "Kazna",
                },
                shotsFired = {
                    label = "Pucnjava",
                },
                sound = {
                    label = "Zvuk",
                },
                speedcam = {
                    label = "Kamere za brzinu",
                },
                speedcamBilling = {
                    label = "Fakturisanje kamere za brzinu",
                },
                speedcamDispatch = {
                    label = "Dispečing kamere za brzinu",
                },
                speedcamDurability = {
                    label = "Izdržljivost kamere za brzinu",
                },
                speedcamPlacement = {
                    label = "Postavljanje kamere za brzinu",
                },
                speedcamRepair = {
                    label = "Popravka kamere za brzinu",
                },
                speedcamRepairAnimation = {
                    label = "Animacija popravke kamere za brzinu",
                },
                speedcamTiming = {
                    label = "Vremenska podešavanja kamere za brzinu",
                },
                speedcamVisual = {
                    label = "Vizuelni prikaz kamere za brzinu",
                },
                speedcams = {
                    label = "Kamere za brzinu",
                },
                storage = {
                    label = "Skladištenje",
                },
                subscription = {
                    label = "Pretplata na aplikaciju",
                },
                tasks = {
                    label = "Zadaci",
                },
                theme = {
                    label = "Tema",
                },
                timing = {
                    label = "Vremenska podešavanja",
                },
                warningUi = {
                    label = "Interfejs upozorenja",
                },
                world = {
                    label = "Svet",
                },
                zipties = {
                    label = "Vezice",
                },
                ziptiesCutter = {
                    label = "Sekač vezica",
                },
                cctvMotionDetection = {
                    label = "Detekcija pokreta",
                },
                cctvMotionDispatch = {
                    label = "Диспечер за откривање кретања",
                },
                cctvMotionTiming = {
                    label = "Тајминг откривања покрета",
                },
                display = {
                    label = "Приказ",
                },
                gsr = {
                    label = "GSR",
                },
                reports = {
                    label = "Извештаји",
                },
                speedcamAdvanced = {
                    label = "Напредна камера брзине",
                },
                tackle = {
                    label = "Тацклес",
                },
                vin = {
                    label = "VIN пров› јера",
                },
            },
            settingSections = {
                radarGun = "Radarski pištolj",
                billing = "Fakturisanje",
                cctv = "CCTV",
                dispatch = "Dispečing",
                equipment = "Oprema",
                evidence = "Dokazi",
                impound = "Oduzimanje vozila",
                jail = "Zatvor",
                radar = "Radar vozila",
                radial = "Radijalne radnje",
                restraints = "Sredstva vezivanja",
                socialWork = "Društveno koristan rad",
                speedCamera = "Kamera za brzinu",
                spikeStrips = "Trake sa šiljcima",
                stations = "Stanice",
                tablet = "Aplikacije tableta",
                tracking = "Praćenje",
                fakePlates = "Лажне регистарске таблице",
                general = "Генерал",
            },
            settingSubsections = {
                app = "Aplikacija kamere za brzinu",
                apps = "Aplikacije",
                billing = "Fakturisanje",
                canteen = "Zatvorska kantina",
                dispatch = "Dispečing",
                durability = "Izdržljivost",
                electrical = "Zatvorska elektrika",
                general = "Opšte",
                handcuffs = "Lisice i vezice",
                inmates = "Zatvorenici",
                jobs = "Zatvorski poslovi",
                keybinds = "Prečice",
                motionDetection = "Detekcija pokreta",
                mugshot = "Fotografija za dosije",
                placement = "Postavljanje",
                repair = "Popravka",
                timing = "Vremenska podešavanja",
                visuals = "Vizuelni prikaz",
            },
            settings = {
                radarGunClearKey = { label = "Radar pištolj: Obriši merenje" },
                radarGunToggleUiKey = { label = "Radar pištolj: Promeni prikaz" },
                radarGunNoTargetHoldMs = { label = "Vreme zadržavanja mete (ms)" },
                radarGunMinimumReading = { label = "Najniža prikazana brzina" },
                radarGunSpeedSmoothing = { label = "Ujednačavanje brzine (0–1)" },
                radarGunBeamRadius = { label = "Poluprečnik snopa (m)" },
                radarGunRefreshRateMs = { label = "Interval merenja (ms)" },
                radarGunUseMph = { label = "Koristi MPH", description = "Prikazuje merenja u miljama na sat umesto kilometrima na sat." },
                radarGunRange = { label = "Domet merenja", description = "Najveća udaljenost u metrima na kojoj radarski pištolj prepoznaje vozila." },
                radarGunRequireOnDuty = { label = "Zahtevaj dužnost", description = "Zahteva da policajac bude na dužnosti pre merenja vozila radarskim pištoljem." },
                radarGunAllowedJobs = { label = "Dozvoljeni poslovi ili grupe", description = "police obuhvata sve podešene policijske poslove; mogu i direktni nazivi. Prazna lista uklanja ograničenja posla.", itemLabel = "Posao ili grupa" },
                radarGunEnabled = { label = "Radarski pištolj", description = "Omogućava ručni radarski pištolj SKY SR-2." },
                fakePlateVinAllowedGangs = {
                    label = "Dozvoljene bande",
                    description = "Izaberi interne nazive bandi ili nezavisnih organizacija. Odgovarajući posao ili banda daje dozvolu ili izuzetak. Dužnost je obavezna samo za poslove.",
                    itemLabel = "Banda",
                },
                fakePlateVinAllowedGangGrades = {
                    label = "Minimalni činovi bandi",
                    description = "Opcioni minimalni činovi bandi. Prazna lista dozvoljava sve činove. Zahtevi za predmetima i dalje važe.",
                },

                speedCamProcessingMode = {
                    description = "Izaberite trenutnu naplatu, plaćanje u podešenom roku ili samo pregled policajca.",
                    label = "Način obrade",
                    options = {
                        instant = "Naplati odmah",
                        later = "Plati kasnije (podrazumevano)",
                        review = "Samo pregled policajca",
                    },
                },
                tabletRegistry = { label = "Регистар", description = "Омогући прилагођене RP регистре у File Explorer-у. Досијеи грађана и возила остају доступни засебно." },
                tabletFiles = { label = "Pregledač datoteka", description = "Objedinjuje policijske spise u pregledaču datoteka. DOJ dokumenti se prikazuju samo dok je DOJ aktivan." },
                ankleMonitorAnimDurationMs = {
                    description = "Milisekunde utrošene na stavljanje monitora za gležanj.",
                    label = "Trajanje stavljanja",
                },
                ankleMonitorAnimScenario = {
                    description = "Scenario koji se pušta prilikom stavljanja monitora za gležanj.",
                    label = "Scenario stavljanja",
                },
                ankleMonitorAttachBone = {
                    description = "Kost peda koja se koristi za pričvršćivanje rekvizita monitora za gležanj.",
                    label = "Kost za pričvršćivanje",
                },
                ankleMonitorConsumeOnPlace = {
                    description = "Uklonite predmet monitora za gležanj nakon postavljanja.",
                    label = "Potroši monitor za gležanj",
                },
                ankleMonitorCutItem = {
                    description = "Predmet iz inventara koji se koristi za uklanjanje monitora za gležanj.",
                    label = "Predmet za sečenje",
                },
                ankleMonitorEnabled = {
                    description = "Omogućite postavljanje monitora za gležanj.",
                    label = "Monitor za gležanj",
                },
                ankleMonitorItem = {
                    description = "Predmet iz inventara koji se koristi za postavljanje monitora za gležanj.",
                    label = "Predmet monitora za gležanj",
                },
                ankleMonitorMapUpdateIntervalMs = {
                    description = "Milisekunde između ažuriranja mape monitora za gležanj.",
                    label = "Interval ažuriranja mape",
                },
                ankleMonitorPersistOnDisconnect = {
                    description = "Čuva monitore za gležanj u bazi kada se praćeni igrači odjave, kako bi se vratili nakon ponovnog povezivanja i restarta servera.",
                    label = "Zadrži nakon prekida veze",
                },
                ankleMonitorPlaceDistance = {
                    description = "Maksimalna udaljenost za postavljanje monitora za gležanj.",
                    label = "Udaljenost postavljanja",
                },
                ankleMonitorPropModel = {
                    description = "Model rekvizita koji se koristi za vizuelni prikaz monitora za gležanj.",
                    label = "Model rekvizita",
                },
                ankleMonitorRequireOnDuty = {
                    description = "Zahtevajte dežurno stanje pre korišćenja monitora za gležanj.",
                    label = "Monitor za gležanj zahteva dežurstvo",
                },
                ankleMonitorRequirePoliceJob = {
                    description = "Zahtevajte da igrač bude u policijskoj grupi pre korišćenja monitora za gležanj.",
                    label = "Monitor za gležanj zahteva policijski posao",
                },
                ankleMonitorReturnOnRemove = {
                    description = "Vratite predmet monitora za gležanj kada se ukloni.",
                    label = "Vrati monitor za gležanj pri uklanjanju",
                },
                ankleMonitorWarningSeconds = {
                    description = "Vreme upozorenja pre nego što se prekršaj zone monitora za gležanj prijavi dispečingu.",
                    label = "Sekunde upozorenja zone",
                },
                ankleMonitorZoneBeepIntervalMs = {
                    description = "Milisekunde između zvučnih signala upozorenja zone monitora za gležanj.",
                    label = "Interval zvučnog signala zone",
                },
                ankleMonitorZoneBeepSound = {
                    description = "Naziv zvuka koji se koristi za upozorenja zone monitora za gležanj.",
                    label = "Zvuk signala",
                },
                ankleMonitorZoneBeepSoundSet = {
                    description = "Skup zvukova koji se koristi za upozorenja zone monitora za gležanj.",
                    label = "Skup zvukova signala",
                },
                ankleMonitorZoneBlipAlpha = {
                    description = "Vrednost providnosti koja se koristi za oznake zone monitora za gležanj.",
                    label = "Providnost oznake",
                },
                ankleMonitorZoneBlipColorAllowed = {
                    description = "Boja oznake koja se koristi kada je meta unutar dozvoljene oblasti.",
                    label = "Boja oznake za dozvoljeno",
                },
                ankleMonitorZoneBlipColorExcluded = {
                    description = "Boja oznake koja se koristi kada meta napusti dozvoljenu oblast.",
                    label = "Boja oznake za izuzeto",
                },
                ankleMonitorZoneCheckIntervalMs = {
                    description = "Milisekunde između provera zone monitora za gležanj.",
                    label = "Interval provere zone",
                },
                ankleMonitorZoneDispatchCooldownSeconds = {
                    description = "Sekunde pre nego što se može poslati novi dispečing zone monitora za gležanj.",
                    label = "Pauza dispečinga zone",
                },
                ankleMonitorZoneEnabled = {
                    description = "Omogućite proveru zona monitora za gležanj.",
                    label = "Zone monitora za gležanj",
                },
                ankleMonitorZoneLabelSprite = {
                    description = "Sprajt oznake koji se koristi za markere zone monitora za gležanj.",
                    label = "Sprajt oznake zone",
                },
                ankleMonitorZoneOutlineRadius = {
                    description = "Poluprečnik koji se koristi za konture zone monitora za gležanj.",
                    label = "Poluprečnik konture",
                },
                ankleMonitorZoneOutlineStep = {
                    description = "Veličina koraka koja se koristi za konture zone monitora za gležanj.",
                    label = "Korak konture",
                },
                billingAccount = {
                    description = "Rezervni račun koji se koristi kada posao nema konfigurisan račun organizacije.",
                    label = "Rezervni račun organizacije",
                },
                billingCloseOnSuccess = {
                    description = "Zatvorite interfejs fakturisanja nakon što je račun izdat.",
                    label = "Zatvori nakon uspeha",
                },
                billingCurrency = {
                    description = "Ključ valute koji se koristi za fakturisanje. Ostavite prazno da biste koristili podrazumevanu valutu.",
                    label = "Valuta",
                },
                billingCustomReasons = {
                    description = "Dozvolite prilagođene razloge fakturisanja umesto samo unapred definisanih.",
                    label = "Prilagođeni razlozi",
                },
                billingDepositToSociety = {
                    description = "Uplatite prihod od fakturisanja na račun organizacije posla.",
                    label = "Uplati na račun organizacije",
                },
                billingMaxReasonLength = {
                    description = "Maksimalan broj karaktera za prilagođene razloge fakturisanja.",
                    label = "Dužina razloga",
                },
                billingMode = {
                    description = "Izaberite da li se policijski računi naplaćuju odmah, zahtevaju potvrdu građanina, ili koriste sistem fakturisanja frejmvorka.",
                    label = "Način fakturisanja",
                    options = {
                        consent = "Plati ili odbij",
                        framework = "Račun frejmvorka",
                        instant = "Trenutna naplata",
                    },
                },
                billingRange = {
                    description = "Maksimalna udaljenost mete za izdavanje policijskih računa.",
                    label = "Domet fakturisanja",
                },
                billingReasonPresets = {
                    description = "Unapred definisani razlozi fakturisanja prikazani u interfejsu fakturisanja.",
                    itemLabel = "Razlog",
                    label = "Unapred definisani razlozi",
                },
                billingRefreshSeconds = {
                    description = "Interval osvežavanja mete dok je interfejs fakturisanja otvoren.",
                    label = "Sekunde osvežavanja",
                },
                billingShowRecipientName = {
                    description = "Prikažite ime građanina u pregledima kazni i na računima.",
                    label = "Prikaži ime primaoca",
                },
                carryAllowCarrierInVehicle = {
                    description = "Dozvolite nosiocu da uđe i vozi vozilo bez spuštanja igrača.",
                    label = "Dozvoli nosiocu vozilo",
                },
                carryAllowConscious = {
                    description = "Dozvolite nošenje svesnih meta.",
                    label = "Nošenje svesnih meta",
                },
                carryAllowSprint = {
                    description = "Dozvolite trčanje dok se nosi drugi igrač.",
                    label = "Dozvoli trčanje prilikom nošenja",
                },
                carryEnabled = {
                    description = "Omogućite nošenje igrača.",
                    label = "Nošenje",
                },
                carryMaxDistance = {
                    description = "Maksimalna udaljenost za početak nošenja igrača.",
                    label = "Udaljenost nošenja",
                },
                carryRequireOnDuty = {
                    description = "Zahtevajte dežurno stanje pre početka nošenja.",
                    label = "Nošenje zahteva dežurstvo",
                },
                cctvDamageCooldownMs = {
                    description = "Milisekunde pre nego što se CCTV može ponovo oštetiti.",
                    label = "Pauza oštećenja",
                },
                cctvDamagePerHit = {
                    description = "Oštećenje izdržljivosti CCTV kamere po pogotku.",
                    label = "Šteta po pogotku",
                },
                cctvDefaultName = {
                    description = "Podrazumevani naziv za prikaz postavljenih CCTV kamera.",
                    label = "Podrazumevani naziv CCTV-a",
                },
                cctvDefaultPitch = {
                    description = "Podrazumevani nagib kamere za postavljanje CCTV-a.",
                    label = "Podrazumevani nagib",
                },
                cctvDisassembleDistance = {
                    description = "Udaljenost koja se koristi za rastavljanje CCTV kamera.",
                    label = "Udaljenost rastavljanja",
                },
                cctvEnabled = {
                    description = "Omogućite postavljanje i strimovanje CCTV kamera.",
                    label = "CCTV kamere",
                },
                cctvHealthDisplayDistance = {
                    description = "Udaljenost na kojoj se prikazuje izdržljivost CCTV-a.",
                    label = "Udaljenost prikaza izdržljivosti",
                },
                cctvHealthDisplayDurationMs = {
                    description = "Milisekunde koliko izdržljivost CCTV-a ostaje vidljiva.",
                    label = "Trajanje prikaza izdržljivosti",
                },
                cctvHealthTextOffset = {
                    description = "Vertikalni pomeraj koji se koristi za tekst izdržljivosti CCTV-a.",
                    label = "Pomeraj teksta izdržljivosti",
                },
                cctvHeightStep = {
                    description = "Korak visine koji se koristi prilikom postavljanja CCTV kamera.",
                    label = "Korak visine",
                },
                cctvItem = {
                    description = "Predmet iz inventara koji se koristi za postavljanje CCTV kamera.",
                    label = "Predmet CCTV-a",
                },
                cctvMaintenanceThreshold = {
                    description = "Prag izdržljivosti pri kojem se preporučuje održavanje CCTV-a.",
                    label = "Prag održavanja",
                },
                cctvMaxDurability = {
                    description = "Maksimalna izdržljivost CCTV kamere.",
                    label = "Izdržljivost CCTV-a",
                },
                cctvMotionAlertCooldownSeconds = {
                    description = "Broj sekundi pre nego što kamera napravi novu prijavu pokreta.",
                    label = "Pauza dispečera",
                },
                cctvMotionCheckIntervalMs = {
                    description = "Broj milisekundi između klijentskih skeniranja pokreta.",
                    label = "Interval skeniranja",
                },
                cctvMotionClientCooldownMs = {
                    description = "Broj milisekundi pre nego što klijent ponovo prijavi istu kameru.",
                    label = "Pauza klijentske prijave",
                },
                cctvMotionDefaultCameraEnabled = {
                    description = "Automatski uključite upozorenja na pokret za novo postavljene CCTV kamere.",
                    label = "Nove kamere podrazumevano aktivne",
                },
                cctvMotionDetectionEnabled = {
                    description = "Omogućite dispečerska upozorenja na pokret za svaku CCTV kameru.",
                    label = "Upozorenja na pokret",
                },
                cctvMotionDetectionRadius = {
                    description = "Maksimalna udaljenost detekcije pokreta u metrima.",
                    label = "Poluprečnik detekcije",
                },
                cctvMotionFieldOfView = {
                    description = "Ugao konusa detekcije pokreta u stepenima.",
                    label = "Vidno polje",
                },
                cctvMotionJobs = {
                    description = "Nazivi poslova ili grupa koje primaju CCTV prijave pokreta.",
                    itemLabel = "Posao ili grupa",
                    label = "Dispečerski poslovi",
                },
                cctvMotionMinimumSpeed = {
                    description = "Minimalna brzina objekta u metrima u sekundi koja se računa kao pokret.",
                    label = "Minimalna brzina kretanja",
                },
                cctvMoveStep = {
                    description = "Korak pomeranja koji se koristi prilikom postavljanja CCTV kamera.",
                    label = "Korak pomeranja",
                },
                cctvPropModel = {
                    description = "Model rekvizita koji se koristi za postavljene CCTV kamere.",
                    label = "Model rekvizita CCTV-a",
                },
                cctvRepairAnimDict = {
                    description = "Rečnik animacije koji se koristi prilikom popravke CCTV kamera.",
                    label = "Rečnik animacije popravke",
                },
                cctvRepairAnimFlag = {
                    description = "Oznaka animacije koja se koristi prilikom popravke CCTV kamera.",
                    label = "Oznaka animacije popravke",
                },
                cctvRepairAnimName = {
                    description = "Naziv animacije koji se koristi prilikom popravke CCTV kamera.",
                    label = "Naziv animacije popravke",
                },
                cctvRepairCancelDelayMs = {
                    description = "Milisekunde pre nego što se popravka CCTV-a može otkazati.",
                    label = "Odlaganje otkazivanja popravke",
                },
                cctvRepairDistance = {
                    description = "Udaljenost koja se koristi za popravku CCTV kamera.",
                    label = "Udaljenost popravke",
                },
                cctvRepairItem = {
                    description = "Predmet iz inventara koji se koristi za popravku CCTV kamera.",
                    label = "Predmet za popravku",
                },
                cctvRepairPerTick = {
                    description = "Izdržljivost koja se vraća po koraku popravke CCTV-a.",
                    label = "Popravka po koraku",
                },
                cctvRepairTickMs = {
                    description = "Milisekunde između koraka popravke CCTV-a.",
                    label = "Interval popravke",
                },
                cctvRotateStep = {
                    description = "Korak rotacije koji se koristi prilikom postavljanja CCTV kamera.",
                    label = "Korak rotacije",
                },
                cctvStreamDistance = {
                    description = "Udaljenost koja se koristi za učitavanje CCTV kamera.",
                    label = "Udaljenost učitavanja",
                },
                cctvViewOffset = {
                    description = "Pomeraj pogleda koji se koristi za prikaz uživo CCTV kamere.",
                    label = "Pomeraj pogleda",
                },
                crimeSceneTapeCollisionEnabled = {
                    description = "Postavlja kolizionu prepreku duž trake kako igrači ne bi mogli da prođu kroz nju.",
                    label = "Blokirajuća kolizija trake",
                },
                crimeSceneTapeConsumeItem = {
                    description = "Uklonite jedan predmet trake iz inventara nakon uspešnog postavljanja.",
                    label = "Potroši predmet trake",
                },
                crimeSceneTapeDynamic = {
                    description = "Omogućite da traka reaguje na fiziku i gravitaciju umesto da ostane nepomična.",
                    label = "Dinamička fizika",
                },
                crimeSceneTapeEnabled = {
                    description = "Omogućite postavljanje trake za mesto zločina pomoću predmeta iz inventara.",
                    label = "Traka za mesto zločina",
                },
                crimeSceneTapeEnforceRemovalAccess = {
                    description = "Traku mogu ukloniti samo dozvoljeni poslovi, a kada je zahtevano, njihovi članovi moraju biti na dužnosti.",
                    label = "Ograniči uklanjanje",
                },
                crimeSceneTapeItem = {
                    description = "Naziv predmeta u inventaru koji pokreće postavljanje trake za mesto zločina.",
                    label = "Predmet trake",
                },
                crimeSceneTapeJobs = {
                    description = "Nazivi poslova kojima je dozvoljeno korišćenje trake za mesto zločina.",
                    itemLabel = "Posao",
                    label = "Dozvoljeni poslovi",
                },
                crimeSceneTapeLabel = {
                    description = "Naziv trake za mesto zločina prikazan tokom postavljanja.",
                    label = "Naziv trake",
                },
                crimeSceneTapeLengthStep = {
                    description = "Korak u metrima na koji se zaokružuje izabrana dužina trake.",
                    label = "Korak dužine",
                },
                crimeSceneTapeMaxLength = {
                    description = "Najveća dozvoljena udaljenost između dva stuba trake, u metrima.",
                    label = "Maksimalna dužina trake",
                },
                crimeSceneTapeMaxPlacementDistance = {
                    description = "Najveća udaljenost bilo koje krajnje tačke od službenika koji postavlja traku.",
                    label = "Maksimalna udaljenost postavljanja",
                },
                crimeSceneTapeMinLength = {
                    description = "Najmanja dozvoljena udaljenost između dva stuba trake, u metrima.",
                    label = "Minimalna dužina trake",
                },
                crimeSceneTapeModel = {
                    description = "Naziv modela rekvizita koji se koristi za postavljenu traku za mesto zločina.",
                    label = "Model trake",
                },
                crimeSceneTapePostModel = {
                    description = "Model rekvizita koji se koristi za oba stuba trake.",
                    label = "Model stuba",
                },
                crimeSceneTapeRemoveDistance = {
                    description = "Najveća udaljenost sa koje se postavljena traka za mesto zločina može ukloniti.",
                    label = "Udaljenost uklanjanja",
                },
                crimeSceneTapeRequireOnDuty = {
                    description = "Traku mogu postavljati samo članovi dozvoljenih poslova koji su na dužnosti.",
                    label = "Zahtevaj dužnost",
                },
                crimeSceneTapeReturnItemOnRemove = {
                    description = "Vratite potrošeni predmet kada se postavljena traka ukloni.",
                    label = "Vrati predmet pri uklanjanju",
                },
                crimeSceneTapeSag = {
                    description = "Najveći ugib trake nadole između stubova, u metrima.",
                    label = "Ugib trake",
                },
                crimeSceneTapeSections = {
                    description = "Izvorni modeli segmenata trake koji se koriste za sastavljanje izabrane dužine.",
                    itemLabel = "Segment trake",
                    label = "Segmenti trake",
                },
                crimeSceneTapeShowPosts = {
                    description = "Postavlja vidljive potporne stubove na oba kraja trake za mesto zločina promenljive dužine.",
                    label = "Prikaži stubove trake",
                },
                crimeSceneTapeStreamDistance = {
                    description = "Udaljenost unutar koje se postavljena traka za mesto zločina učitava.",
                    label = "Udaljenost učitavanja",
                },
                crimeSceneTapeTapeHeight = {
                    description = "Visina trake iznad izabranih tačaka na tlu.",
                    label = "Visina trake",
                },
                crimeSceneTapeVariableLength = {
                    description = "Omogućava službenicima da odrede početnu i krajnju tačku i postave traku podesive dužine.",
                    label = "Promenljiva dužina trake",
                },
                crimeSceneTapeZOffset = {
                    description = "Vertikalni pomak koji se primenjuje pri postavljanju modela trake.",
                    label = "Vertikalni pomak",
                },
                cuffsAnimDict = {
                    description = "Rečnik animacije koji se koristi za vezane igrače.",
                    label = "Rečnik animacije",
                },
                cuffsAnimFlag = {
                    description = "Oznaka animacije koja se koristi za vezane igrače.",
                    label = "Oznaka animacije",
                },
                cuffsAnimName = {
                    description = "Naziv animacije koji se koristi za vezane igrače.",
                    label = "Naziv animacije",
                },
                cuffsConsumeItem = {
                    description = "Uklonite predmet lisica kada se lisice stave.",
                    label = "Potroši lisice",
                },
                cuffsEnabled = {
                    description = "Omogućite radnje sa lisicama.",
                    label = "Lisice",
                },
                cuffsEscapeEnabled = {
                    description = "Omogućite mini-igru bekstva iz lisica.",
                    label = "Bekstvo iz lisica",
                },
                cuffsEscapeKeyPool = {
                    description = "Tasteri koji se mogu pojaviti u mini-igri bekstva iz lisica.",
                    itemLabel = "Taster",
                    label = "Skup tastera za bekstvo",
                },
                cuffsEscapeRounds = {
                    description = "Broj rundi neophodnih u mini-igri bekstva iz lisica.",
                    label = "Rundi bekstva",
                },
                cuffsEscapeWindowMs = {
                    description = "Dozvoljene milisekunde po prozoru unosa u bekstvu iz lisica.",
                    label = "Vremenski prozor bekstva",
                },
                cuffsHandsUpEnabled = {
                    description = "Omogućite stanje ruku uvis koje koriste lisice i vezice.",
                    label = "Ruke uvis",
                },
                cuffsHandsUpHoldSeconds = {
                    description = "Broj sekundi koliko taster za ruke uvis mora biti pritisnut pre aktivacije.",
                    label = "Sekunde držanja tastera",
                },
                cuffsHandsUpKey = {
                    description = "Taster na tastaturi koji se koristi za podizanje ruku.",
                    label = "Taster za ruke uvis",
                },
                cuffsItem = {
                    description = "Predmet iz inventara koji se koristi za radnje sa lisicama.",
                    label = "Predmet lisica",
                },
                cuffsMaxDistance = {
                    description = "Maksimalna udaljenost mete za radnje sa lisicama.",
                    label = "Udaljenost za lisice",
                },
                cuffsRequireItem = {
                    description = "Zahtevajte konfigurisani predmet lisica.",
                    label = "Lisice zahtevaju predmet",
                },
                cuffsRequireOnDuty = {
                    description = "Zahtevajte dežurno stanje pre stavljanja lisica.",
                    label = "Lisice zahtevaju dežurstvo",
                },
                cuffsReturnOnRemove = {
                    description = "Vratite predmet lisica kada se lisice skinu.",
                    label = "Vrati lisice",
                },
                dispatchOfficerDownEnabled = {
                    description = "Pošaljite dispečing upozorenje kada dežurni policajac padne.",
                    label = "Upozorenja o ranjenom policajcu",
                },
                dispatchOfficerDownJobs = {
                    description = "Poslovi koji treba da prime dispečing o ranjenom policajcu.",
                    itemLabel = "Posao",
                    label = "Poslovi za ranjenog policajca",
                },
                dispatchOfficerDownRequireDuty = {
                    description = "Obaveštavajte samo igrače koji su trenutno na dužnosti.",
                    label = "Ranjeni policajac zahteva dežurstvo",
                },
                dispatchShotsFiredChance = {
                    description = "Verovatnoća od 0.0 do 1.0 da detektovani pucanj aktivira upozorenje.",
                    label = "Verovatnoća upozorenja",
                },
                dispatchShotsFiredCooldownSeconds = {
                    description = "Sekunde pre nego što isti igrač može ponovo pokrenuti upozorenje o pucnjavi.",
                    label = "Pauza za pucnjavu",
                },
                dispatchShotsFiredEnabled = {
                    description = "Omogućite dispečing upozorenja o pucnjavi.",
                    label = "Upozorenja o pucnjavi",
                },
                dispatchShotsFiredIgnoredWeapons = {
                    description = "Oružje koje ne treba da pokrene upozorenje o pucnjavi.",
                    itemLabel = "Oružje",
                    label = "Ignorisano oružje",
                },
                dispatchShotsFiredJobs = {
                    description = "Poslovi koji treba da prime dispečing o pucnjavi.",
                    itemLabel = "Posao",
                    label = "Poslovi za pucnjavu",
                },
                dispatchShotsFiredRequireDuty = {
                    description = "Obaveštavajte samo igrače koji su trenutno na dužnosti.",
                    label = "Pucnjava zahteva dežurstvo",
                },
                dispatchShotsFiredSendDispatch = {
                    description = "Kreirajte unos u dispečingu kada se detektuje pucnjava.",
                    label = "Pošalji dispečing pucnjave",
                },
                dispatchShotsFiredSuppressedChance = {
                    description = "Verovatnoća od 0.0 do 1.0 da detektovani prigušeni pucanj aktivira upozorenje.",
                    label = "Verovatnoća upozorenja za prigušeni pucanj",
                },
                escortEnabled = {
                    description = "Omogućite praćenje igrača.",
                    label = "Praćenje",
                },
                escortMaxDistance = {
                    description = "Maksimalna udaljenost za početak praćenja igrača.",
                    label = "Udaljenost praćenja",
                },
                escortRequireOnDuty = {
                    description = "Zahtevajte dežurno stanje pre praćenja igrača.",
                    label = "Praćenje zahteva dežurstvo",
                },
                escortVehicleDistance = {
                    description = "Maksimalna udaljenost za smeštanje praćenog igrača u vozilo.",
                    label = "Udaljenost praćenja u vozilu",
                },
                evidenceBloodDamageThreshold = {
                    description = "Minimalni prag oštećenja pre nego što se kreira dokaz o krvi.",
                    label = "Prag oštećenja za krv",
                },
                evidenceCasingCreateCooldownMs = {
                    description = "Milisekunde pre nego što se može kreirati nova čaura.",
                    label = "Pauza za čauru",
                },
                evidenceCasingMergeRadius = {
                    description = "Poluprečnik koji se koristi za spajanje obližnjih čaura.",
                    label = "Poluprečnik spajanja čaura",
                },
                evidenceCleanupIntervalMs = {
                    description = "Milisekunde između prolaza čišćenja dokaza.",
                    label = "Interval čišćenja",
                },
                evidenceCleanupTtlSeconds = {
                    description = "Sekunde pre nego što terenski dokazi automatski isteknu.",
                    label = "Vreme trajanja pre čišćenja",
                },
                evidenceCleanerAllowEveryone = {
                    label = "Sredstvo za čišćenje za sve",
                    description = "Dozvoli svima uklanjanje tragova hidrogen-peroksidom. Isključi za korišćenje lista poslova i bandi.",
                },
                evidenceCleanerJobs = {
                    label = "Poslovi za sredstvo za čišćenje",
                    description = "Dozvoljeni interni nazivi bez javnog pristupa. Odgovarajući posao ili banda dozvoljava pristup; prazne liste ga zabranjuju.",
                    itemLabel = "Posao",
                },
                evidenceCleanerGangs = {
                    label = "Bande za sredstvo za čišćenje",
                    description = "Dozvoljeni interni nazivi bez javnog pristupa. Odgovarajući posao ili banda dozvoljava pristup; prazne liste ga zabranjuju.",
                    itemLabel = "Banda",
                },
                evidenceCollectDistance = {
                    description = "Udaljenost koja se koristi za prikupljanje terenskih dokaza.",
                    label = "Udaljenost prikupljanja",
                },
                evidenceDiscoverDistance = {
                    description = "Udaljenost koja se koristi za otkrivanje obližnjih markera dokaza.",
                    label = "Udaljenost otkrivanja",
                },
                evidenceFieldEnabled = {
                    description = "Omogućite kreiranje i prikupljanje dokaza na terenu.",
                    label = "Terenski dokazi",
                },
                evidenceFieldFlashlightWeapon = {
                    description = "Oružje koje se koristi za pregled i otkrivanje dokaza na terenu.",
                    label = "Oružje-baterijska lampa",
                },
                evidenceGloveFreeHands = {
                    description = "ID-jevi komponenti ruku koji se tretiraju kao da ne nose rukavice.",
                    label = "Ruke bez rukavica",
                },
                evidenceMarkerColor = {
                    description = "RGBA boja koja se koristi za markere terenskih dokaza.",
                    label = "Boja markera",
                },
                evidenceMarkerDrawDistance = {
                    description = "Udaljenost iscrtavanja koja se koristi za markere terenskih dokaza.",
                    label = "Udaljenost iscrtavanja",
                },
                evidenceMarkerOffset = {
                    description = "Vertikalni pomeraj markera koji se koristi za terenske dokaze.",
                    label = "Pomeraj",
                },
                evidenceMarkerScaleX = {
                    description = "X skala markera koja se koristi za terenske dokaze.",
                    label = "Skala X",
                },
                evidenceMarkerScaleY = {
                    description = "Y skala markera koja se koristi za terenske dokaze.",
                    label = "Skala Y",
                },
                evidenceMarkerScaleZ = {
                    description = "Z skala markera koja se koristi za terenske dokaze.",
                    label = "Skala Z",
                },
                evidenceMarkerType = {
                    description = "Tip markera koji se koristi za terenske dokaze.",
                    label = "Tip markera",
                },
                evidenceMaxCreateDistance = {
                    description = "Maksimalna udaljenost za kreiranje zapisa dokaza.",
                    label = "Udaljenost kreiranja",
                },
                evidenceSalivaConsentTimeoutMs = {
                    description = "Dozvoljene milisekunde za pristanak na uzimanje uzorka pljuvačke.",
                    label = "Vreme za pristanak na uzorak pljuvačke",
                },
                evidenceScannerDistance = {
                    description = "Udaljenost koja se koristi za interakcije sa skenerom dokaza.",
                    label = "Udaljenost skenera",
                },
                evidenceScannerDurationMs = {
                    description = "Trajanje radnje otiska prsta/skenera u milisekundama.",
                    label = "Trajanje skenera",
                },
                evidenceStorageMaxCompartments = {
                    description = "Maksimalan broj odeljaka skladišta dokaza.",
                    label = "Odeljci skladišta",
                },
                gpsTrackerBeepDistance = {
                    description = "Udaljenost na kojoj zvučni signal GPS tragača postaje relevantan.",
                    label = "Udaljenost zvučnog signala",
                },
                gpsTrackerBeepIntervalFarMs = {
                    description = "Milisekunde između zvučnih signala kada ste daleko od tragača.",
                    label = "Interval signala izdaleka",
                },
                gpsTrackerBeepIntervalNearMs = {
                    description = "Milisekunde između zvučnih signala kada ste blizu tragača.",
                    label = "Interval signala izbliza",
                },
                gpsTrackerConsumeOnPlace = {
                    description = "Uklonite predmet tragača nakon postavljanja.",
                    label = "Potroši GPS tragač",
                },
                gpsTrackerEnabled = {
                    description = "Omogućite postavljanje i skeniranje GPS tragača na vozilima.",
                    label = "GPS tragač",
                },
                gpsTrackerItem = {
                    description = "Predmet iz inventara koji se koristi za postavljanje GPS tragača.",
                    label = "Predmet tragača",
                },
                gpsTrackerMapUpdateIntervalMs = {
                    description = "Milisekunde između ažuriranja mape tragača.",
                    label = "Interval ažuriranja mape",
                },
                gpsTrackerPlaceDistance = {
                    description = "Maksimalna udaljenost za postavljanje GPS tragača na vozilo.",
                    label = "Udaljenost postavljanja",
                },
                gpsTrackerRemoveDistance = {
                    description = "Maksimalna udaljenost za uklanjanje postavljenog GPS tragača.",
                    label = "Udaljenost uklanjanja",
                },
                gpsTrackerRemoveKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Ukloni GPS lokator",
                },
                gpsTrackerRequireOnDuty = {
                    description = "Zahtevajte dežurno stanje pre korišćenja GPS tragača.",
                    label = "GPS zahteva dežurstvo",
                },
                gpsTrackerRequirePoliceJob = {
                    description = "Zahtevajte da igrač bude u policijskoj grupi pre korišćenja GPS tragača.",
                    label = "GPS zahteva policijski posao",
                },
                gpsTrackerReturnOnRemove = {
                    description = "Vratite predmet tragača kada se ukloni.",
                    label = "Vrati tragač pri uklanjanju",
                },
                gpsTrackerScanDistance = {
                    description = "Maksimalna udaljenost za skeniranje tragača.",
                    label = "Udaljenost skeniranja GPS-a",
                },
                gpsTrackerScanDurationMs = {
                    description = "Milisekunde utrošene na skeniranje GPS tragača.",
                    label = "Trajanje skeniranja",
                },
                gpsTrackerScannerWeapon = {
                    description = "Oružje ili alat koji se koristi za skeniranje GPS tragača.",
                    label = "Oružje skenera",
                },
                impoundAccount = {
                    description = "Račun koji se koristi za naplatu preuzimanja oduzetih vozila.",
                    label = "Račun za plaćanje",
                },
                impoundCreatorVehicleModel = {
                    description = "Model vozila prikazan u pregledu kreatora oduzetišta.",
                    label = "Model vozila u kreatoru",
                },
                impoundCustomGarageEnabled = {
                    description = "Koristite prilagođeni interfejs garaže za oduzeta vozila kada je dostupan.",
                    label = "Prilagođena garaža za oduzeta vozila",
                },
                impoundDefaultPrice = {
                    description = "Podrazumevana cena preuzimanja oduzetog vozila.",
                    label = "Podrazumevana cena",
                },
                impoundDeliveryDistance = {
                    description = "Udaljenost koja se koristi za interakcije dostave oduzetih vozila.",
                    label = "Udaljenost dostave",
                },
                impoundDeliveryMarker = {
                    description = "Konfiguracija markera koja se koristi za dostavu oduzetih vozila.",
                    label = "Marker dostave",
                },
                impoundEnabled = {
                    description = "Omogućite tokove oduzimanja vozila.",
                    label = "Oduzimanje vozila",
                },
                impoundMarker = {
                    description = "Konfiguracija markera koja se koristi za interakcije oduzimanja.",
                    label = "Marker oduzetišta",
                },
                impoundRadialEnabled = {
                    description = "Omogućite radijalne radnje oduzimanja vozila.",
                    label = "Radnja oduzimanja",
                },
                impoundRadialRequireOnDuty = {
                    description = "Zahtevajte dežurno stanje pre korišćenja radijalne radnje oduzimanja.",
                    label = "Oduzimanje zahteva dežurstvo",
                },
                impoundRadialVehicleDistance = {
                    description = "Maksimalna udaljenost do ciljanog vozila za radijalne radnje oduzimanja.",
                    label = "Udaljenost vozila za oduzimanje",
                },
                impoundReleaseDistance = {
                    description = "Udaljenost koja se koristi za interakcije preuzimanja oduzetih vozila.",
                    label = "Udaljenost preuzimanja",
                },
                impoundReleaseKey = {
                    description = "Kontrolni kod koji se koristi za preuzimanje oduzetih vozila.",
                    label = "Taster za preuzimanje",
                },
                impoundRequireDelivery = {
                    description = "Zahtevajte dostavu do konfigurisanog oduzetišta.",
                    label = "Zahtevaj dostavu",
                },
                impoundStorageBasePrice = {
                    description = "Osnovna cena preuzimanja uskladištenih oduzetih vozila.",
                    label = "Osnovna cena skladištenja",
                },
                impoundStorageDailyFee = {
                    description = "Dodatna naknada skladištenja oduzetih vozila po konfigurisanom danu.",
                    label = "Dnevna naknada skladištenja",
                },
                impoundStorageDaySeconds = {
                    description = "Koliko sekundi se računa kao jedan dan naplate skladištenja.",
                    label = "Sekunde po danu skladištenja",
                },
                impoundStorageEnabled = {
                    description = "Omogućite obradu plaćenog skladištenja oduzetih vozila.",
                    label = "Skladištenje oduzetih vozila",
                },
                jailAssignRange = {
                    description = "Maksimalna udaljenost za slanje mete u zatvor.",
                    label = "Domet dodele",
                },
                jailCanteenCooldownMinutes = {
                    description = "Minuti koje zatvorenik mora sačekati pre preuzimanja novog paketa iz kantine.",
                    label = "Minuti pauze",
                },
                jailCanteenPackage = {
                    description = "Predmeti koji se dobijaju paketom zatvorske kantine.",
                    label = "Paket kantine",
                },
                jailCellStreamDistance = {
                    description = "Udaljenost koja se koristi za učitavanje rekvizita samica.",
                    label = "Udaljenost učitavanja ćelije",
                },
                jailClearInventory = {
                    description = "Ispraznite inventar igrača prilikom slanja u zatvor.",
                    label = "Isprazni inventar",
                },
                jailDefaultMonths = {
                    description = "Podrazumevano trajanje zatvorske kazne prilikom otvaranja interfejsa dodele.",
                    label = "Podrazumevano meseci",
                },
                jailDispatchJobs = {
                    description = "Poslovi koji treba da prime dispečing zatvora.",
                    itemLabel = "Posao",
                    label = "Poslovi za dispečing",
                },
                jailDoctorHealEvent = {
                    description = "Server ili klijentski događaj koji se pokreće kada zatvorski lekar izleči zatvorenika.",
                    label = "Događaj lečenja",
                },
                jailElectricalCodeListItem = {
                    description = "Predmet iz inventara neophodan za otkrivanje generisanih elektro šifri.",
                    label = "Predmet liste šifri",
                },
                jailElectricalCodeMax = {
                    description = "Najviša nasumična vrednost šifre za elektro ormar.",
                    label = "Maksimalna šifra",
                },
                jailElectricalCodeMin = {
                    description = "Najniža nasumična vrednost šifre za elektro ormar.",
                    label = "Minimalna šifra",
                },
                jailElectricalCodesCount = {
                    description = "Koliko se kandidata za šifru generiše za elektro ormar.",
                    label = "Broj šifri",
                },
                jailElectricalEnabled = {
                    description = "Omogućite mini-igru bekstva putem elektro ormara u zatvoru.",
                    label = "Elektro ormar",
                },
                jailElectricalPinLength = {
                    description = "Broj cifara koji se koristi za PIN kodove elektro ormara.",
                    label = "Dužina PIN koda",
                },
                jailElectricalPropModel = {
                    description = "Model rekvizita sveta koji se koristi za elektro ormar u zatvoru.",
                    label = "Model rekvizita",
                },
                jailElectricalShockDamage = {
                    description = "Šteta naneta kada zatvorenik ne uspe u sekvenci elektro ormara.",
                    label = "Šteta od strujnog udara",
                },
                jailElectricalShockRagdollMs = {
                    description = "Milisekunde padanja nakon strujnog udara.",
                    label = "Trajanje pada nakon udara",
                },
                jailElectricalSuccessReduceMinutes = {
                    description = "Minuti kazne koji se uklanjaju nakon uspešnog pokušaja bekstva putem elektro ormara.",
                    label = "Umanjenje pri uspehu (minuti)",
                },
                jailInmateAlcoholicRequiredAmount = {
                    description = "Količina neophodna za razmenu sa zatvorenikom alkoholičarem.",
                    label = "Neophodna količina",
                },
                jailInmateAlcoholicRequiredItem = {
                    description = "Predmet neophodan za razmenu sa zatvorenikom alkoholičarem.",
                    label = "Neophodan predmet",
                },
                jailInmateAlcoholicRewardAmount = {
                    description = "Količina nagrade za razmenu sa zatvorenikom alkoholičarem.",
                    label = "Količina nagrade",
                },
                jailInmateAlcoholicRewardItem = {
                    description = "Predmet nagrade za razmenu sa zatvorenikom alkoholičarem.",
                    label = "Predmet nagrade",
                },
                jailInmateAlcoholicRewardLabel = {
                    description = "Naziv nagrade prikazan za razmenu sa zatvorenikom alkoholičarem.",
                    label = "Naziv nagrade",
                },
                jailInmateCodeListRequiredAmount = {
                    description = "Količina neophodna za razmenu sa zatvorenikom informatorom.",
                    label = "Neophodna količina",
                },
                jailInmateCodeListRequiredItem = {
                    description = "Predmet neophodan za razmenu sa zatvorenikom informatorom.",
                    label = "Neophodan predmet",
                },
                jailInmateCodeListRewardAmount = {
                    description = "Količina nagrade za razmenu sa zatvorenikom informatorom.",
                    label = "Količina nagrade",
                },
                jailInmateCodeListRewardItem = {
                    description = "Predmet nagrade za razmenu sa zatvorenikom informatorom.",
                    label = "Predmet nagrade",
                },
                jailInmateCodeListRewardLabel = {
                    description = "Naziv nagrade prikazan za razmenu sa zatvorenikom informatorom.",
                    label = "Naziv nagrade",
                },
                jailInmateDrugDealerAcceptedItems = {
                    description = "Prihvaćeni predmeti za razmenu sa zatvorenikom dilerom droge.",
                    label = "Prihvaćeni predmeti",
                },
                jailInmateDrugDealerRequiredAmount = {
                    description = "Količina neophodna za razmenu sa zatvorenikom dilerom droge.",
                    label = "Neophodna količina",
                },
                jailInmateDrugDealerRewardAmount = {
                    description = "Količina nagrade za razmenu sa zatvorenikom dilerom droge.",
                    label = "Količina nagrade",
                },
                jailInmateDrugDealerRewardItem = {
                    description = "Predmet nagrade za razmenu sa zatvorenikom dilerom droge.",
                    label = "Predmet nagrade",
                },
                jailInmateDrugDealerRewardLabel = {
                    description = "Naziv nagrade prikazan za razmenu sa zatvorenikom dilerom droge.",
                    label = "Naziv nagrade",
                },
                jailInmateDrugDealerUseCleaningContraband = {
                    description = "Dozvolite da zabranjeni predmeti pronađeni tokom zatvorskog čišćenja važe za razmenu sa zatvorenikom dilerom droge.",
                    label = "Koristi zabranjeno iz čišćenja",
                },
                jailInmateWireCutterRequiredAmount = {
                    description = "Količina neophodna za razmenu sa zatvorenikom dostavljačem alata.",
                    label = "Neophodna količina",
                },
                jailInmateWireCutterRequiredItem = {
                    description = "Predmet neophodan za razmenu sa zatvorenikom dostavljačem alata.",
                    label = "Neophodan predmet",
                },
                jailInmateWireCutterRewardAmount = {
                    description = "Količina nagrade za razmenu sa zatvorenikom dostavljačem alata.",
                    label = "Količina nagrade",
                },
                jailInmateWireCutterRewardItem = {
                    description = "Predmet nagrade za razmenu sa zatvorenikom dostavljačem alata.",
                    label = "Predmet nagrade",
                },
                jailInmateWireCutterRewardLabel = {
                    description = "Naziv nagrade prikazan za razmenu sa zatvorenikom dostavljačem alata.",
                    label = "Naziv nagrade",
                },
                jailJobsCarryBoxModel = {
                    description = "Model rekvizita koji se koristi za kutiju zatvorskog posla nošenja.",
                    label = "Model kutije",
                },
                jailJobsCarryDropoffKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Zatvorski posao: predaj",
                },
                jailJobsCarryDropoffRadius = {
                    description = "Poluprečnik odlaganja za zatvorski posao nošenja.",
                    label = "Poluprečnik odlaganja",
                },
                jailJobsCarryInspectKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Zatvorski posao: pregledaj",
                },
                jailJobsCarryInspectionJunkItems = {
                    description = "Beskorisni predmeti koji se mogu naći prilikom pregleda kutija posla nošenja.",
                    label = "Beskorisni predmeti pregleda",
                },
                jailJobsCarryInspectionUsableChance = {
                    description = "Šansa za upotrebljivu nagradu prilikom pregleda kutija.",
                    label = "Šansa za upotrebljivi plen",
                },
                jailJobsCarryInspectionUsableItems = {
                    description = "Upotrebljivi predmeti koji se mogu naći prilikom pregleda kutija posla nošenja.",
                    label = "Upotrebljivi predmeti pregleda",
                },
                jailJobsCarryInteractDistance = {
                    description = "Udaljenost interakcije za zatvorski posao nošenja.",
                    label = "Udaljenost interakcije nošenja",
                },
                jailJobsCarryMaxDistance = {
                    description = "Maksimalna dozvoljena udaljenost za napredak zatvorskog posla nošenja.",
                    label = "Maksimalna udaljenost nošenja",
                },
                jailJobsCarryPickupKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Zatvorski posao: pokupi",
                },
                jailJobsCarryPickupOffset = {
                    description = "Objekat pomeraja koji se koristi za lokaciju pokupljanja posla nošenja.",
                    label = "Pomeraj pokupljanja",
                },
                jailJobsCarryTimeReduction = {
                    description = "Umanjenje kazne za završetak zatvorskog posla nošenja.",
                    label = "Umanjenje kazne za nošenje",
                },
                jailJobsCleaningDumpsterKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Čišćenje: odloži",
                },
                jailJobsCleaningDumpsterModel = {
                    description = "Model koji se koristi za rekvizit kontejnera zatvorskog čišćenja.",
                    label = "Model kontejnera",
                },
                jailJobsCleaningIllegalFindChance = {
                    description = "Šansa za pronalaženje zabranjenih predmeta prilikom čišćenja.",
                    label = "Šansa pronalaska zabranjenog",
                },
                jailJobsCleaningIllegalFindItems = {
                    description = "Predmeti koji se mogu pronaći prilikom čišćenja u zatvoru.",
                    label = "Zabranjeni predmeti",
                },
                jailJobsCleaningIllegalFindPromptTimeoutMs = {
                    description = "Vreme isteka za upite o pronalasku zabranjenih predmeta u milisekundama.",
                    label = "Vreme isteka upita",
                },
                jailJobsCleaningInteractDistance = {
                    description = "Udaljenost koja se koristi za interakciju sa smećem za čišćenje.",
                    label = "Udaljenost interakcije čišćenja",
                },
                jailJobsCleaningMaxDistance = {
                    description = "Maksimalna udaljenost pre nego što se rekviziti čišćenja resetuju ili nestanu.",
                    label = "Maksimalna udaljenost čišćenja",
                },
                jailJobsCleaningMaxTrashProps = {
                    description = "Maksimalan broj istovremenih rekvizita smeća za zatvorsko čišćenje.",
                    label = "Maksimalno rekvizita smeća",
                },
                jailJobsCleaningMinSpawnRadius = {
                    description = "Minimalna udaljenost od centra za pojavljivanje smeća za čišćenje.",
                    label = "Minimalni poluprečnik pojavljivanja",
                },
                jailJobsCleaningPickupKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Čišćenje: pokupi",
                },
                jailJobsCleaningSpawnIntervalMs = {
                    description = "Milisekunde između pokušaja pojavljivanja smeća za čišćenje.",
                    label = "Interval pojavljivanja smeća",
                },
                jailJobsCleaningSpawnRadius = {
                    description = "Poluprečnik koji se koristi za pojavljivanje rekvizita smeća za čišćenje.",
                    label = "Poluprečnik pojavljivanja smeća",
                },
                jailJobsCleaningTrashModels = {
                    description = "Modeli rekvizita smeća koji se koriste za zatvorski posao čišćenja.",
                    itemLabel = "Модел",
                    label = "Modeli smeća",
                },
                jailJobsCleaningTrashOutlineColor = {
                    description = "RGBA boja konture koja se koristi za rekvizite smeća zatvorskog čišćenja.",
                    label = "Boja konture",
                },
                jailJobsCleaningTrashOutlineEnabled = {
                    description = "Omogućite konture na rekvizitima smeća zatvorskog čišćenja.",
                    label = "Kontura smeća",
                },
                jailJobsCleaningTrashOutlineShader = {
                    description = "ID šejdera koji se koristi za konture smeća zatvorskog čišćenja.",
                    label = "Šejder konture",
                },
                jailJobsTimeReduction = {
                    description = "Umanjenje kazne za završetak zatvorskog posla čišćenja.",
                    label = "Umanjenje kazne za čišćenje",
                },
                jailJobsTrashGoal = {
                    description = "Broj predmeta smeća potrebnih za završetak zatvorskog posla čišćenja.",
                    label = "Cilj smeća za čišćenje",
                },
                jailMaxMonths = {
                    description = "Maksimalno trajanje zatvorske kazne koje se može izabrati.",
                    label = "Maksimalno meseci",
                },
                jailMinMonths = {
                    description = "Minimalno trajanje zatvorske kazne koje se može izabrati.",
                    label = "Minimalno meseci",
                },
                jailMonthMinutes = {
                    description = "Broj realnih minuta koje predstavlja jedan zatvorski mesec.",
                    label = "Minuti po mesecu",
                },
                jailObjectStreamDistance = {
                    description = "Udaljenost koja se koristi za učitavanje trajnih objekata sveta zatvora.",
                    label = "Udaljenost učitavanja objekata",
                },
                jailOutfitApplyDelayMs = {
                    description = "Odlaganje nakon priključivanja pre nego što se zatvorska odeća primeni.",
                    label = "Odlaganje primene odeće",
                },
                jailOutfitEnabled = {
                    description = "Omogućite zatvorsku odeću.",
                    label = "Zatvorska odeća",
                },
                jailOutfitFemaleArms = {
                    description = "Komponenta ruku ženske zatvorske odeće.",
                    label = "Ruke",
                },
                jailOutfitFemaleChain1 = {
                    description = "Model lančića ženske zatvorske odeće.",
                    label = "Lančić 1",
                },
                jailOutfitFemaleChain2 = {
                    description = "Tekstura lančića ženske zatvorske odeće.",
                    label = "Lančić 2",
                },
                jailOutfitFemaleDecals1 = {
                    description = "Model nalepnica ženske zatvorske odeće.",
                    label = "Nalepnice 1",
                },
                jailOutfitFemaleDecals2 = {
                    description = "Tekstura nalepnica ženske zatvorske odeće.",
                    label = "Nalepnice 2",
                },
                jailOutfitFemaleGlasses1 = {
                    description = "Model naočara ženske zatvorske odeće (-1 uklanja naočare).",
                    label = "Naočare 1",
                },
                jailOutfitFemaleGlasses2 = {
                    description = "Tekstura naočara ženske zatvorske odeće.",
                    label = "Naočare 2",
                },
                jailOutfitFemaleHelmet1 = {
                    description = "Model šlema ženske zatvorske odeće.",
                    label = "Šlem 1",
                },
                jailOutfitFemaleHelmet2 = {
                    description = "Tekstura šlema ženske zatvorske odeće.",
                    label = "Šlem 2",
                },
                jailOutfitFemalePants1 = {
                    description = "Model pantalona ženske zatvorske odeće.",
                    label = "Pantalone 1",
                },
                jailOutfitFemalePants2 = {
                    description = "Tekstura pantalona ženske zatvorske odeće.",
                    label = "Pantalone 2",
                },
                jailOutfitFemaleShoes1 = {
                    description = "Model cipela ženske zatvorske odeće.",
                    label = "Cipele 1",
                },
                jailOutfitFemaleShoes2 = {
                    description = "Tekstura cipela ženske zatvorske odeće.",
                    label = "Cipele 2",
                },
                jailOutfitFemaleTorso1 = {
                    description = "Model torza ženske zatvorske odeće.",
                    label = "Torzo 1",
                },
                jailOutfitFemaleTorso2 = {
                    description = "Tekstura torza ženske zatvorske odeće.",
                    label = "Torzo 2",
                },
                jailOutfitFemaleTshirt1 = {
                    description = "Model majice ženske zatvorske odeće.",
                    label = "Majica 1",
                },
                jailOutfitFemaleTshirt2 = {
                    description = "Tekstura majice ženske zatvorske odeće.",
                    label = "Majica 2",
                },
                jailOutfitMaleArms = {
                    description = "Komponenta ruku muške zatvorske odeće.",
                    label = "Ruke",
                },
                jailOutfitMaleChain1 = {
                    description = "Model lančića muške zatvorske odeće.",
                    label = "Lančić 1",
                },
                jailOutfitMaleChain2 = {
                    description = "Tekstura lančića muške zatvorske odeće.",
                    label = "Lančić 2",
                },
                jailOutfitMaleDecals1 = {
                    description = "Model nalepnica muške zatvorske odeće.",
                    label = "Nalepnice 1",
                },
                jailOutfitMaleDecals2 = {
                    description = "Tekstura nalepnica muške zatvorske odeće.",
                    label = "Nalepnice 2",
                },
                jailOutfitMaleGlasses1 = {
                    description = "Model naočara muške zatvorske odeće (-1 uklanja naočare).",
                    label = "Naočare 1",
                },
                jailOutfitMaleGlasses2 = {
                    description = "Tekstura naočara muške zatvorske odeće.",
                    label = "Naočare 2",
                },
                jailOutfitMaleHelmet1 = {
                    description = "Model šlema muške zatvorske odeće.",
                    label = "Šlem 1",
                },
                jailOutfitMaleHelmet2 = {
                    description = "Tekstura šlema muške zatvorske odeće.",
                    label = "Šlem 2",
                },
                jailOutfitMalePants1 = {
                    description = "Model pantalona muške zatvorske odeće.",
                    label = "Pantalone 1",
                },
                jailOutfitMalePants2 = {
                    description = "Tekstura pantalona muške zatvorske odeće.",
                    label = "Pantalone 2",
                },
                jailOutfitMaleShoes1 = {
                    description = "Model cipela muške zatvorske odeće.",
                    label = "Cipele 1",
                },
                jailOutfitMaleShoes2 = {
                    description = "Tekstura cipela muške zatvorske odeće.",
                    label = "Cipele 2",
                },
                jailOutfitMaleTorso1 = {
                    description = "Model torza muške zatvorske odeće.",
                    label = "Torzo 1",
                },
                jailOutfitMaleTorso2 = {
                    description = "Tekstura torza muške zatvorske odeće.",
                    label = "Torzo 2",
                },
                jailOutfitMaleTshirt1 = {
                    description = "Model majice muške zatvorske odeće.",
                    label = "Majica 1",
                },
                jailOutfitMaleTshirt2 = {
                    description = "Tekstura majice muške zatvorske odeće.",
                    label = "Majica 2",
                },
                jailRequireJailTerminal = {
                    description = "Dozvoli policajcima slanje u zatvor samo blizu terminala izabranog zatvora.",
                    label = "Zahtevaj zatvorski terminal",
                },
                jailRestoreOutfitOnBreakout = {
                    description = "Vratite sačuvanu civilnu odeću kada zatvorenik pobegne.",
                    label = "Vrati odeću pri bekstvu",
                },
                jailRestoreSpawnCorrectionMs = {
                    description = "Vreme milosti nakon vraćanja pre nego što korekcija spawna prestane da se primenjuje.",
                    label = "Prozor korekcije nakon vraćanja",
                },
                jailTeleportRestoreOutsideZone = {
                    description = "Teleportujte vraćene zatvorenike nazad na spawn zatvora ako se učitaju van zone zatvora.",
                    label = "Teleportuj vraćene zatvorenike",
                },
                jailTerminalRange = {
                    description = "Maksimalna udaljenost policajca od terminala izabranog zatvora.",
                    label = "Domet zatvorskog terminala",
                },
                jailZoneExitGraceMs = {
                    description = "Vreme milosti pre nego što se izlazak iz zone zatvora može računati kao bekstvo.",
                    label = "Milost pri izlasku iz zone",
                },
                mugshotAnimDict = {
                    description = "Rečnik animacije koji se koristi prilikom snimanja fotografije za dosije.",
                    label = "Rečnik animacije",
                },
                mugshotAnimFlag = {
                    description = "Oznaka animacije koja se koristi prilikom snimanja fotografije za dosije.",
                    label = "Oznaka animacije",
                },
                mugshotAnimName = {
                    description = "Naziv animacije koji se koristi prilikom snimanja fotografije za dosije.",
                    label = "Naziv animacije",
                },
                mugshotBoardHeader = {
                    description = "Glavni naslov prikazan na tabli za fotografiju za dosije.",
                    label = "Naslov table",
                },
                mugshotBoardSubheader = {
                    description = "Rezervni podnaslov prikazan na tabli za fotografiju za dosije.",
                    label = "Podnaslov table",
                },
                mugshotCameraCoordsX = {
                    description = "X koordinata sveta kamere koja se koristi za fotografije za dosije.",
                    label = "Kamera X",
                },
                mugshotCameraCoordsY = {
                    description = "Y koordinata sveta kamere koja se koristi za fotografije za dosije.",
                    label = "Kamera Y",
                },
                mugshotCameraCoordsZ = {
                    description = "Z koordinata sveta kamere koja se koristi za fotografije za dosije.",
                    label = "Kamera Z",
                },
                mugshotCameraFov = {
                    description = "Vidno polje koje se koristi za snimanje fotografija za dosije.",
                    label = "Vidno polje kamere",
                },
                mugshotCameraRotX = {
                    description = "X rotacija kamere koja se koristi za fotografije za dosije.",
                    label = "Rotacija X",
                },
                mugshotCameraRotY = {
                    description = "Y rotacija kamere koja se koristi za fotografije za dosije.",
                    label = "Rotacija Y",
                },
                mugshotCameraRotZ = {
                    description = "Z rotacija kamere koja se koristi za fotografije za dosije.",
                    label = "Rotacija Z",
                },
                mugshotCaptureTimeout = {
                    description = "Maksimalne dozvoljene milisekunde za povratne pozive snimanja fotografije za dosije.",
                    label = "Vreme isteka snimanja",
                },
                mugshotEnabled = {
                    description = "Omogućite snimanje fotografije za dosije prilikom prijema u zatvor.",
                    label = "Snimanje fotografije za dosije",
                },
                mugshotHeading = {
                    description = "Pravac primenjen prilikom snimanja fotografije za dosije.",
                    label = "Pravac",
                },
                mugshotLocationX = {
                    description = "X koordinata sveta koja se koristi za snimanje fotografije za dosije.",
                    label = "Lokacija X",
                },
                mugshotLocationY = {
                    description = "Y koordinata sveta koja se koristi za snimanje fotografije za dosije.",
                    label = "Lokacija Y",
                },
                mugshotLocationZ = {
                    description = "Z koordinata sveta koja se koristi za snimanje fotografije za dosije.",
                    label = "Lokacija Z",
                },
                mugshotMetadataDescriptionFormat = {
                    description = "Format opisa koji se koristi za sačuvane metapodatke fotografije za dosije.",
                    label = "Opis metapodataka",
                },
                mugshotMetadataName = {
                    description = "Naziv metapodataka iz inventara koji se koristi za sačuvanu fotografiju za dosije.",
                    label = "Naziv metapodataka",
                },
                mugshotWaitMs = {
                    description = "Milisekunde čekanja pre snimanja fotografije za dosije.",
                    label = "Milisekunde čekanja",
                },
                playerSearchAnimDict = {
                    description = "Rečnik animacije koji se koristi tokom pretresa igrača.",
                    label = "Rečnik animacije",
                },
                playerSearchAnimFlag = {
                    description = "Oznaka animacije koja se koristi tokom pretresa igrača.",
                    label = "Oznaka animacije",
                },
                playerSearchAnimName = {
                    description = "Naziv animacije koji se koristi tokom pretresa igrača.",
                    label = "Naziv animacije",
                },
                playerSearchDurationMs = {
                    description = "Trajanje pregleda pretresa igrača u milisekundama.",
                    label = "Trajanje pretresa",
                },
                playerSearchEnabled = {
                    description = "Omogućite tok pregleda pretresa igrača.",
                    label = "Pretres igrača",
                },
                playerSearchRange = {
                    description = "Maksimalna udaljenost za početak pretresa igrača.",
                    label = "Domet pretresa",
                },
                playerSearchScenario = {
                    description = "Scenario koji se koristi kada se ne pušta izričita animacija pretresa.",
                    label = "Scenario pretresa",
                },
                policeBillingControl200 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Računi · Kontrola 200",
                },
                policeBillingControl322 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Računi · Kontrola 322",
                },
                policeEditorControl10 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 10",
                },
                policeEditorControl11 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 11",
                },
                policeEditorControl172 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 172",
                },
                policeEditorControl173 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 173",
                },
                policeEditorControl174 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 174",
                },
                policeEditorControl175 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 175",
                },
                policeEditorControl177 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 177",
                },
                policeEditorControl191 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 191",
                },
                policeEditorControl201 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 201",
                },
                policeEditorControl202 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 202",
                },
                policeEditorControl21 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 21",
                },
                policeEditorControl32 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 32",
                },
                policeEditorControl322 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 322",
                },
                policeEditorControl33 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 33",
                },
                policeEditorControl34 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 34",
                },
                policeEditorControl35 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 35",
                },
                policeEditorControl36 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 36",
                },
                policeEditorControl37 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 37",
                },
                policeEditorControl38 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 38",
                },
                policeEditorControl44 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 44",
                },
                policeEditorControl73 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 73",
                },
                policePrimaryColor = {
                    description = "Подразумевана боја за групу полицијских послова.",
                    label = "Primarna boja",
                },
                propPlacementConsumeItem = {
                    description = "Uklonite jedan predmet iz inventara kada se rekvizit postavi iz inventara.",
                    label = "Potroši predmet rekvizita",
                },
                propPlacementEnabled = {
                    description = "Dozvolite postavljanje konfigurisanih policijskih rekvizita iz predmeta ili vozila.",
                    label = "Postavljanje rekvizita",
                },
                propPlacementItemNames = {
                    description = "Mapirajte modele rekvizita na nazive predmeta iz inventara za postavljanje rekvizita putem predmeta.",
                    label = "Nazivi predmeta rekvizita",
                },
                propPlacementRequireOnDuty = {
                    description = "Samo dežurni policajci mogu postaviti konfigurisane rekvizite.",
                    label = "Rekviziti zahtevaju dežurstvo",
                },
                propPlacementReturnItem = {
                    description = "Vratite potrošeni predmet kada se postavljeni rekvizit ukloni.",
                    label = "Vrati predmet rekvizita",
                },
                propPlacementVehicleAccess = {
                    description = "Dozvolite da vozila posla omoguće svoju konfigurisanu opremu rekvizita.",
                    label = "Pristup rekvizitima vozila",
                },
                radialEnabled = {
                    description = "Omogućite policijske radijalne radnje.",
                    label = "Policijski radijalni meni",
                },
                radialHandcuffKeybindCommand = {
                    description = "Naziv komande registrovane za prečicu za lisice.",
                    label = "Komanda za lisice",
                },
                radialHandcuffKeybindDescription = {
                    description = "Opis prikazan za prečicu za lisice.",
                    label = "Opis prečice za lisice",
                },
                radialHandcuffKeybindEnabled = {
                    description = "Omogućite direktnu prečicu za stavljanje lisica.",
                    label = "Prečica za lisice",
                },
                radialHandcuffKeybindKey = {
                    description = "Taster na tastaturi koji se koristi za direktnu radnju stavljanja lisica.",
                    label = "Taster za lisice",
                },
                radialKeybindsEnabled = {
                    description = "Omogućite direktne prečice na tastaturi za izabrane radijalne radnje.",
                    label = "Direktne prečice",
                },
                radialUnhandcuffKeybindCommand = {
                    description = "Naziv komande registrovane za prečicu za skidanje lisica.",
                    label = "Komanda za skidanje lisica",
                },
                radialUnhandcuffKeybindDescription = {
                    description = "Opis prikazan za prečicu za skidanje lisica.",
                    label = "Opis prečice za skidanje lisica",
                },
                radialUnhandcuffKeybindEnabled = {
                    description = "Omogućite direktnu prečicu za skidanje lisica.",
                    label = "Prečica za skidanje lisica",
                },
                radialUnhandcuffKeybindKey = {
                    description = "Taster na tastaturi koji se koristi za direktnu radnju skidanja lisica.",
                    label = "Taster za skidanje lisica",
                },
                socialWorkAssignRange = {
                    description = "Maksimalna udaljenost za dodelu zadataka društveno korisnog rada.",
                    label = "Domet dodele",
                },
                socialWorkDeadlineDefault = {
                    description = "Podrazumevani rok za društveno koristan rad u minutima. Nula onemogućava rokove.",
                    label = "Podrazumevani rok",
                },
                socialWorkDeadlineMax = {
                    description = "Maksimalni rok za društveno koristan rad u minutima. Nula onemogućava ograničenje.",
                    label = "Maksimalni rok",
                },
                socialWorkDeadlineMin = {
                    description = "Minimalni rok za društveno koristan rad u minutima.",
                    label = "Minimalni rok",
                },
                socialWorkDefaultTasks = {
                    description = "Podrazumevani broj zadataka prilikom otvaranja dodele društveno korisnog rada.",
                    label = "Podrazumevano zadataka",
                },
                socialWorkEnabled = {
                    description = "Omogućite dodelu društveno korisnog rada i tokove zadataka.",
                    label = "Društveno koristan rad",
                },
                socialWorkImprisonmentJailId = {
                    description = "ID zatvora koji se koristi kada prekršaji društveno korisnog rada dovedu do zatvaranja.",
                    label = "Rezervni ID zatvora",
                },
                socialWorkImprisonmentMonths = {
                    description = "Broj meseci koji se dodeljuje kada prekršaji društveno korisnog rada rezultiraju zatvorom.",
                    label = "Meseci zatvora",
                },
                socialWorkImprisonmentOfficerName = {
                    description = "Ime policajca koje se koristi za zapise zatvaranja iz društveno korisnog rada.",
                    label = "Ime policajca za zatvaranje",
                },
                socialWorkImprisonmentSolitary = {
                    description = "Pošaljite prekršioce u samicu kada se zatvaranje aktivira.",
                    label = "Koristi samicu",
                },
                socialWorkInactivityMinutes = {
                    description = "Minuti pre nego što se primene kazne za neaktivnost u društveno korisnom radu.",
                    label = "Minuti neaktivnosti",
                },
                socialWorkInactivityTaskPenalty = {
                    description = "Kazna u vidu zadataka koja se primenjuje kada igrač predugo ostane neaktivan tokom društveno korisnog rada.",
                    label = "Kazna zadataka za neaktivnost",
                },
                socialWorkMaxTasks = {
                    description = "Maksimalan broj zadataka društveno korisnog rada koji se može izabrati.",
                    label = "Maksimalno zadataka",
                },
                socialWorkMinTasks = {
                    description = "Minimalan broj zadataka društveno korisnog rada koji se može izabrati.",
                    label = "Minimalno zadataka",
                },
                speedCamBillingEnabled = {
                    description = "Izdajte automatske račune kada kamera za brzinu zabeleži odgovarajući prekršaj. Zahteva omogućenu globalnu funkciju fakturisanja.",
                    label = "Automatske kazne",
                },
                speedCamBillingExcludedJobs = {
                    description = "Poslovi koji nikada ne dobijaju automatske račune sa kamera za brzinu.",
                    itemLabel = "Posao",
                    label = "Izuzeti poslovi",
                },
                speedCamBillingExcludedModels = {
                    description = "Spawn nazivi vozila koja nikada ne dobijaju automatske račune sa kamera za brzinu.",
                    itemLabel = "Модел",
                    label = "Izuzeti modeli vozila",
                },
                speedCamBillingRules = {
                    description = "Pravila kazni koja koriste kamere za brzinu. Najuži odgovarajući opseg prekoračenja se naplaćuje prvi; ako nijedno pravilo ne odgovara, kao rezerva se koriste prekršaji prekoračenja brzine (SpeedViolation).",
                    label = "Pravila kazni",
                },
                speedCamCameraEaseMs = {
                    description = "Koliko dugo se pogled prebacuje na ugao kamere za brzinu. Niža vrednost = kraći zamah; prenisko može pomeriti fotografiju.",
                    label = "Prelaz kamere (ms)",
                },
                speedCamCameraFov = {
                    description = "Vidno polje koje se koristi za snimke kamere za brzinu.",
                    label = "Vidno polje kamere",
                },
                speedCamCheckIntervalMs = {
                    description = "Milisekunde između skeniranja kamere za brzinu.",
                    label = "Interval provere",
                },
                speedCamCooldownMs = {
                    description = "Milisekunde pre nego što ista kamera za brzinu može ponovo da okine.",
                    label = "Pauza okidanja",
                },
                speedCamDamageCooldownMs = {
                    description = "Milisekunde pre nego što se kamera za brzinu može ponovo oštetiti.",
                    label = "Pauza oštećenja",
                },
                speedCamDamagePerHit = {
                    description = "Oštećenje izdržljivosti kamere za brzinu po pogotku.",
                    label = "Šteta po pogotku",
                },
                speedCamDamagedModelThreshold = {
                    description = "Procenat maksimalne izdržljivosti na kojem ili ispod kojeg se prikazuje oštećeni model. Primer: 50 uz maksimalnu izdržljivost 200 menja model na 100 izdržljivosti.",
                    label = "Prag oštećenog modela (%)",
                },
                speedCamDefaultLimit = {
                    description = "Podrazumevano ograničenje brzine kamere za brzinu.",
                    label = "Podrazumevano ograničenje brzine",
                },
                speedCamDefaultName = {
                    description = "Predloženi prikazani naziv pri postavljanju kamere za brzinu. Naziv može da se prevede bez promene predmeta u inventaru ili modela objekta.",
                    label = "Podrazumevani naziv",
                },
                speedCamDefaultTolerance = {
                    description = "Podrazumevana tolerancija kamere za brzinu.",
                    label = "Podrazumevana tolerancija",
                },
                speedCamDisassembleDistance = {
                    description = "Udaljenost koja se koristi za rastavljanje kamera za brzinu.",
                    label = "Udaljenost rastavljanja",
                },
                speedCamEnabled = {
                    description = "Omogućite prenosive kamere za brzinu.",
                    label = "Kamere za brzinu",
                },
                speedCamFlashColor = {
                    description = "RGBA boja bljeska koju koriste kamere za brzinu.",
                    label = "Boja bljeska",
                },
                speedCamFlashDurationMs = {
                    description = "Vreme nestajanja crvenog bljeska kamere za brzinu. Ne podešavajte prenisko jer će zamah kamere postati vidljiv.",
                    label = "Trajanje bljeska (ms)",
                },
                speedCamHealthDisplayDistance = {
                    description = "Udaljenost na kojoj se prikazuje izdržljivost kamere za brzinu.",
                    label = "Udaljenost prikaza izdržljivosti",
                },
                speedCamHealthDisplayDurationMs = {
                    description = "Milisekunde koliko izdržljivost kamere za brzinu ostaje vidljiva.",
                    label = "Trajanje prikaza izdržljivosti",
                },
                speedCamHealthTextOffset = {
                    description = "Vertikalni pomeraj koji se koristi za tekst izdržljivosti kamere za brzinu.",
                    label = "Pomeraj teksta izdržljivosti",
                },
                speedCamItem = {
                    description = "Tačan interni naziv predmeta u inventaru, npr. speedcam. Unesite ključ predmeta, ne prikazani naziv; prodavnica posla mora da daje isti predmet.",
                    label = "Naziv predmeta kamere",
                },
                speedCamMaintenanceThreshold = {
                    description = "Prag izdržljivosti pri kojem se preporučuje održavanje kamere za brzinu.",
                    label = "Prag održavanja",
                },
                speedCamMaxDurability = {
                    description = "Maksimalna izdržljivost postavljenih kamera za brzinu.",
                    label = "Maksimalna izdržljivost",
                },
                speedCamMaxLimit = {
                    description = "Maksimalno podesivo ograničenje brzine kamere za brzinu.",
                    label = "Maksimalno ograničenje brzine",
                },
                speedCamMaxTolerance = {
                    description = "Maksimalna podesiva tolerancija kamere za brzinu.",
                    label = "Maksimalna tolerancija",
                },
                speedCamPhotoLocale = {
                    description = "Opciono regionalno podešavanje koje se koristi za vremensku oznaku na fotografijama kamere za brzinu. Ostavite prazno da biste koristili lokalno podešavanje uslikanog igrača.",
                    label = "Regionalno podešavanje fotografije",
                },
                speedCamPhotoTimeZone = {
                    description = "Opciona vremenska zona koja se koristi za vremensku oznaku na fotografijama kamere za brzinu. Ostavite prazno da biste koristili lokalnu vremensku zonu uslikanog igrača.",
                    label = "Vremenska zona fotografije",
                },
                speedCamPoliceNotification = {
                    description = "Pošaljite obaveštenje dispečingu kada kamera za brzinu zabeleži prekršaj.",
                    label = "Policijsko upozorenje kamere za brzinu",
                },
                speedCamPoliceNotificationGroup = {
                    description = "Tretirajte metu dispečinga kamere za brzinu kao grupu poslova.",
                    label = "Meta dispečinga je grupa",
                },
                speedCamPoliceNotificationJob = {
                    description = "Posao ili ključ grupe koji se koristi za obaveštenja dispečinga kamere za brzinu.",
                    label = "Meta dispečinga",
                },
                speedCamPoliceNotificationRequireDuty = {
                    description = "Obaveštavajte samo mete dispečinga kamere za brzinu koje su na dužnosti.",
                    label = "Dispečing zahteva dežurstvo",
                },
                speedCamPoliceNotificationType = {
                    description = "Ozbiljnost/tip dispečinga koji se koristi za upozorenja kamere za brzinu.",
                    label = "Tip dispečinga",
                },
                speedCamPropModel = {
                    description = "Naziv za stvaranje neoštećenog modela kamere, npr. sky_speedcam. Gotov izbor postavlja i oštećeni i uništeni model. Prilagođeni modeli moraju biti dostupni u igri.",
                    label = "Model rekvizita kamere za brzinu",
                    custom = "Prilagođeni model",
                    choose = "Izaberi model",
                    preview = "3D pregled",
                    customPlaceholder = "Naziv propa za spawn",
                    previewDescription = "Prikaži izabrani prop u igri. Pregled ne čuva izmene.",
                    invalidModel = "Prvo unesite važeći naziv propa.",
                    modelMissing = "Ovaj model propa nije dostupan u igri.",
                    previewFailed = "Nije moguće otvoriti pregled modela.",
                    intact = "Neoštećen model",
                    previewRequiresGame = "Otvori /jobconfig u FiveM-u za prikaz propa uživo.",
                    previewHelp = "Strelice: pomeranje; PageUp/PageDown: visina; točkić: rotacija; Enter: zatvori; Backspace: otkaži.",
                    options = {
                        sky_speedcam = "Standardni radar",
                        sky_germ_speedcam = "Nemački radar",
                    },
                },
                speedCamPropModelDamaged = {
                    description = "Naziv za stvaranje oštećenog modela kamere, npr. sky_speedcam2. Koristite varijantu koja odgovara neoštećenom modelu.",
                    label = "Model oštećenog rekvizita",
                },
                speedCamPropModelDestroyed = {
                    description = "Naziv modela koji se prikazuje kada izdržljivost kamere dostigne 0, npr. sky_speedcam1. Koristite varijantu koja odgovara neoštećenom modelu.",
                    label = "Model uništenog rekvizita",
                },
                speedCamRepairAnimDict = {
                    description = "Rečnik animacije koji se koristi prilikom popravke kamera za brzinu.",
                    label = "Rečnik animacije popravke",
                },
                speedCamRepairAnimFlag = {
                    description = "Oznaka animacije koja se koristi prilikom popravke kamera za brzinu.",
                    label = "Oznaka animacije popravke",
                },
                speedCamRepairAnimName = {
                    description = "Naziv animacije koji se koristi prilikom popravke kamera za brzinu.",
                    label = "Naziv animacije popravke",
                },
                speedCamRepairCancelDelayMs = {
                    description = "Milisekunde pre nego što se popravka kamere za brzinu može otkazati.",
                    label = "Odlaganje otkazivanja popravke",
                },
                speedCamRepairDistance = {
                    description = "Udaljenost koja se koristi za popravku kamera za brzinu.",
                    label = "Udaljenost popravke",
                },
                speedCamRepairItem = {
                    description = "Tačan interni naziv predmeta za popravku, npr. fixtool. Unesite ključ predmeta, ne prikazani naziv.",
                    label = "Naziv predmeta za popravku",
                },
                speedCamRepairPerTick = {
                    description = "Izdržljivost koja se vraća po koraku popravke kamere za brzinu.",
                    label = "Popravka po koraku",
                },
                speedCamRepairTickMs = {
                    description = "Milisekunde između koraka popravke kamere za brzinu.",
                    label = "Interval popravke",
                },
                speedCamStreamDistance = {
                    description = "Udaljenost od igrača u metrima unutar koje se učitavaju modeli kamera. Van te udaljenosti modeli se uklanjaju iz prikaza; sačuvane kamere ostaju postavljene.",
                    label = "Udaljenost učitavanja",
                },
                speedCamTriggerRadius = {
                    description = "Poluprečnik otkrivanja vozila koja prekoračuju brzinu oko kamere, u metrima.",
                    label = "Poluprečnik okidanja",
                },
                speedCamUseMph = {
                    description = "Prikazujte i obrađujte ograničenja kamere za brzinu u MPH.",
                    label = "Koristi MPH",
                },
                speedCamWeaponDamageRestrictionAllowedWeapons = {
                    description = "Oružje kojim je dozvoljeno oštetiti kamere za brzinu dok je ograničenje omogućeno.",
                    itemLabel = "Oružje",
                    label = "Dozvoljeno oružje",
                },
                speedCamWeaponDamageRestrictionEnabled = {
                    description = "Samo navedeno oružje može oštetiti kamere za brzinu dok je ovo omogućeno.",
                    label = "Ograničenje omogućeno",
                },
                speedCameraAppClearDistanceMeters = {
                    description = "Udaljenost u metrima pre uklanjanja upozorenja o kamerama za brzinu.",
                    label = "Udaljenost brisanja",
                },
                speedCameraAppDefaultApp = {
                    description = "Prikažite aplikaciju kamere za brzinu kao podrazumevanu aplikaciju tableta.",
                    label = "Podrazumevana aplikacija",
                },
                speedCameraAppDescription = {
                    description = "Opis prikazan za aplikaciju kamere za brzinu na tabletu.",
                    label = "Opis",
                },
                speedCameraAppDeveloper = {
                    description = "Oznaka programera prikazana za aplikaciju kamere za brzinu na tabletu.",
                    label = "Programer",
                },
                speedCameraAppEnabled = {
                    description = "Omogućite aplikaciju kamere za brzinu na policijskom tabletu.",
                    label = "Aplikacija kamere za brzinu",
                },
                speedCameraAppHeaderEyebrow = {
                    description = "Nadnaslov zaglavlja prikazan u aplikaciji kamere za brzinu.",
                    label = "Nadnaslov zaglavlja",
                },
                speedCameraAppHeaderTitle = {
                    description = "Naslov zaglavlja prikazan u aplikaciji kamere za brzinu.",
                    label = "Naslov zaglavlja",
                },
                speedCameraAppIcon = {
                    description = "Putanja ikonice koja se koristi za aplikaciju kamere za brzinu na tabletu.",
                    label = "Putanja ikonice",
                },
                speedCameraAppIdentifier = {
                    description = "Interni identifikator aplikacije kamere za brzinu na tabletu.",
                    label = "Identifikator",
                },
                speedCameraAppInFrontDot = {
                    description = "Prag skalarnog proizvoda koji se koristi za određivanje da li je kamera za brzinu ispred igrača.",
                    label = "Prag za ispred (dot)",
                },
                speedCameraAppMinimumVehicleSpeedKmh = {
                    description = "Minimalna brzina vozila u km/h pre prikazivanja upozorenja.",
                    label = "Minimalna brzina vozila",
                },
                speedCameraAppName = {
                    description = "Naziv za prikaz aplikacije kamere za brzinu na tabletu.",
                    label = "Naziv aplikacije",
                },
                speedCameraAppNotifyDistanceMeters = {
                    description = "Udaljenost u metrima pre obaveštavanja o obližnjim kamerama za brzinu.",
                    label = "Udaljenost obaveštenja",
                },
                speedCameraAppOnlyInVehicle = {
                    description = "Upozoravajte o kamerama za brzinu samo dok je igrač u vozilu.",
                    label = "Samo u vozilu",
                },
                speedCameraAppOverlayBackground = {
                    description = "Boja pozadine koja se koristi za preklop slike tablice.",
                    label = "Pozadina preklopa",
                },
                speedCameraAppOverlayBorder = {
                    description = "Boja ivice koja se koristi za preklop slike tablice.",
                    label = "Ivica preklopa",
                },
                speedCameraAppOverlayColor = {
                    description = "Boja teksta koja se koristi za preklop slike tablice.",
                    label = "Boja preklopa",
                },
                speedCameraAppOverlayEnabled = {
                    description = "Omogućite preklop slike tablice na snimljenim slikama kamere za brzinu.",
                    label = "Preklop omogućen",
                },
                speedCameraAppOverlayFontScale = {
                    description = "Skala fonta koja se koristi za preklop slike tablice.",
                    label = "Skala fonta preklopa",
                },
                speedCameraAppOverlayX = {
                    description = "Normalizovana X pozicija preklopa sleva nadesno.",
                    label = "Preklop X",
                },
                speedCameraAppOverlayY = {
                    description = "Normalizovana Y pozicija preklopa odozgo nadole.",
                    label = "Preklop Y",
                },
                speedCameraAppRequireInFront = {
                    description = "Upozoravajte samo za kamere za brzinu koje su ispred igrača.",
                    label = "Zahtevaj ispred",
                },
                speedCameraAppRoute = {
                    description = "Putanja rutera koju otvara aplikacija kamere za brzinu na tabletu.",
                    label = "Ruta",
                },
                speedCameraAppSize = {
                    description = "Prijavljena veličina skladišta za aplikaciju kamere za brzinu na tabletu.",
                    label = "Veličina aplikacije",
                },
                speedCameraAppSoundCoord = {
                    description = "Puštajte zvukove upozorenja kamere za brzinu na koordinatama sveta.",
                    label = "Zvuk na koordinatama",
                },
                speedCameraAppSoundEnabled = {
                    description = "Omogućite zvukove upozorenja za aplikaciju kamere za brzinu.",
                    label = "Zvuk omogućen",
                },
                speedCameraAppSoundFrontend = {
                    description = "Puštajte zvukove upozorenja kamere za brzinu na frontend audio kanalu.",
                    label = "Frontend zvuk",
                },
                speedCameraAppSoundLayers = {
                    description = "Broj slojevitih zvukova upozorenja koje pušta aplikacija kamere za brzinu.",
                    label = "Slojevi zvuka",
                },
                speedCameraAppSoundName = {
                    description = "Naziv zvuka koji se koristi za upozorenja aplikacije kamere za brzinu.",
                    label = "Naziv zvuka",
                },
                speedCameraAppSoundRange = {
                    description = "Domet koji se koristi za zvukove upozorenja aplikacije kamere za brzinu.",
                    label = "Domet zvuka",
                },
                speedCameraAppSoundRepeatCount = {
                    description = "Broj ponavljanja zvuka upozorenja kamere za brzinu.",
                    label = "Broj ponavljanja",
                },
                speedCameraAppSoundRepeatDelayMs = {
                    description = "Milisekunde između ponavljanja zvuka upozorenja kamere za brzinu.",
                    label = "Odlaganje ponavljanja",
                },
                speedCameraAppSoundSet = {
                    description = "Skup zvukova koji se koristi za upozorenja aplikacije kamere za brzinu.",
                    label = "Skup zvukova",
                },
                speedCameraAppSubscriptionAccount = {
                    description = "Račun koji se koristi za plaćanja pretplate na tablet aplikaciju kamere za brzinu.",
                    label = "Račun",
                },
                speedCameraAppSubscriptionEnabled = {
                    description = "Omogućite plaćenu pretplatu za tablet aplikaciju kamere za brzinu.",
                    label = "Pretplata omogućena",
                },
                speedCameraAppSubscriptionIntervalDays = {
                    description = "Broj dana između obnavljanja pretplate na tablet aplikaciju kamere za brzinu.",
                    label = "Dani intervala",
                },
                speedCameraAppSubscriptionPrice = {
                    description = "Cena koja se naplaćuje za pretplatu na tablet aplikaciju kamere za brzinu.",
                    label = "Cena pretplate",
                },
                speedCameraAppThemeAccent = {
                    description = "Boja akcenta koju koristi aplikacija kamere za brzinu.",
                    label = "Akcent",
                },
                speedCameraAppThemeBackground = {
                    description = "Linearni gradijent pozadine koji koristi aplikacija kamere za brzinu.",
                    label = "Pozadina",
                },
                speedCameraAppThemeBorder = {
                    description = "Boja ivice koju koristi aplikacija kamere za brzinu.",
                    label = "Ivica",
                },
                speedCameraAppThemeButtonText = {
                    description = "Boja teksta dugmeta koju koristi aplikacija kamere za brzinu.",
                    label = "Tekst dugmeta",
                },
                speedCameraAppThemeDanger = {
                    description = "Boja opasnosti koju koristi aplikacija kamere za brzinu.",
                    label = "Opasnost",
                },
                speedCameraAppThemeGhost = {
                    description = "Boja providnog dugmeta koju koristi aplikacija kamere za brzinu.",
                    label = "Providno dugme",
                },
                speedCameraAppThemeGhostText = {
                    description = "Boja teksta providnog dugmeta koju koristi aplikacija kamere za brzinu.",
                    label = "Tekst providnog dugmeta",
                },
                speedCameraAppThemeGradientSoft = {
                    description = "Boja mekanog gradijenta koju koristi aplikacija kamere za brzinu.",
                    label = "Mekani gradijent",
                },
                speedCameraAppThemeInactiveBorder = {
                    description = "Boja neaktivne ivice koju koristi aplikacija kamere za brzinu.",
                    label = "Neaktivna ivica",
                },
                speedCameraAppThemeModal = {
                    description = "Boja pozadine iskačućeg prozora koju koristi aplikacija kamere za brzinu.",
                    label = "Iskačući prozor",
                },
                speedCameraAppThemeMutedText = {
                    description = "Boja prigušenog teksta koju koristi aplikacija kamere za brzinu.",
                    label = "Prigušeni tekst",
                },
                speedCameraAppThemeOverlay = {
                    description = "Boja preklopa koju koristi aplikacija kamere za brzinu.",
                    label = "Preklop",
                },
                speedCameraAppThemePillText = {
                    description = "Boja teksta oznake koju koristi aplikacija kamere za brzinu.",
                    label = "Tekst oznake",
                },
                speedCameraAppThemePrimaryFrom = {
                    description = "Boja početka glavnog gradijenta koju koristi aplikacija kamere za brzinu.",
                    label = "Početak glavnog gradijenta",
                },
                speedCameraAppThemePrimaryTo = {
                    description = "Boja kraja glavnog gradijenta koju koristi aplikacija kamere za brzinu.",
                    label = "Kraj glavnog gradijenta",
                },
                speedCameraAppThemeShadow = {
                    description = "Boja senke koju koristi aplikacija kamere za brzinu.",
                    label = "Senka",
                },
                speedCameraAppThemeSpotlight = {
                    description = "Boja akcenta reflektora koju koristi aplikacija kamere za brzinu.",
                    label = "Reflektor",
                },
                speedCameraAppThemeSubtleText = {
                    description = "Boja suptilnog teksta koju koristi aplikacija kamere za brzinu.",
                    label = "Suptilni tekst",
                },
                speedCameraAppThemeSuccess = {
                    description = "Boja uspeha koju koristi aplikacija kamere za brzinu.",
                    label = "Uspeh",
                },
                speedCameraAppThemeSurface = {
                    description = "Boja površine koju koristi aplikacija kamere za brzinu.",
                    label = "Površina",
                },
                speedCameraAppThemeSurfaceSoft = {
                    description = "Boja mekane površine koju koristi aplikacija kamere za brzinu.",
                    label = "Mekana površina",
                },
                speedCameraAppThemeText = {
                    description = "Osnovna boja teksta koju koristi aplikacija kamere za brzinu.",
                    label = "Tekst",
                },
                speedCameraAppWarningUiAccent = {
                    description = "RGBA boja akcenta koja se koristi za interfejs upozorenja kamere za brzinu.",
                    label = "Akcent RGBA",
                },
                speedCameraAppWarningUiBackground = {
                    description = "RGBA boja koja se koristi za pozadinu interfejsa upozorenja kamere za brzinu.",
                    label = "Pozadina RGBA",
                },
                speedCameraAppWarningUiIcon = {
                    description = "RGBA boja ikonice koja se koristi za interfejs upozorenja kamere za brzinu.",
                    label = "Ikonica RGBA",
                },
                speedCameraAppWarningUiIconText = {
                    description = "RGBA boja teksta ikonice koja se koristi za interfejs upozorenja kamere za brzinu.",
                    label = "Tekst ikonice RGBA",
                },
                speedCameraAppWarningUiSeconds = {
                    description = "Sekunde koliko interfejs upozorenja ostaje vidljiv.",
                    label = "Sekunde interfejsa upozorenja",
                },
                speedCameraAppWarningUiSubText = {
                    description = "RGBA boja podteksta koja se koristi za interfejs upozorenja kamere za brzinu.",
                    label = "Podtekst RGBA",
                },
                speedCameraAppWarningUiText = {
                    description = "RGBA boja teksta koja se koristi za interfejs upozorenja kamere za brzinu.",
                    label = "Tekst RGBA",
                },
                speedCameraAppWarningUiTitle = {
                    description = "RGBA boja naslova koja se koristi za interfejs upozorenja kamere za brzinu.",
                    label = "Naslov RGBA",
                },
                spikeStripsCheckIntervalMs = {
                    description = "Milisekunde između provera blizine trake sa šiljcima.",
                    label = "Interval provere",
                },
                spikeStripsEnabled = {
                    description = "Omogućite postavljene trake sa šiljcima.",
                    label = "Trake sa šiljcima",
                },
                spikeStripsModels = {
                    description = "Modeli rekvizita koji se tretiraju kao aktivne trake sa šiljcima.",
                    itemLabel = "Модел",
                    label = "Modeli",
                },
                spikeStripsRetryIntervalMs = {
                    description = "Milisekunde pre ponovnog pokušaja skeniranja trake sa šiljcima nakon neuspešnog poklapanja.",
                    label = "Interval ponovnog pokušaja",
                },
                spikeStripsScanDistance = {
                    description = "Udaljenost koja se koristi za skeniranje obližnjih traka sa šiljcima.",
                    label = "Udaljenost skeniranja",
                },
                spikeStripsTriggerDistance = {
                    description = "Udaljenost na kojoj traka sa šiljcima probuši gume.",
                    label = "Udaljenost okidanja",
                },
                stationCreatorBlipCategoryLabel = {
                    description = "Oznaka kategorije koja se koristi za oznake stanica u kreatoru.",
                    label = "Kategorija oznake stanice",
                },
                stationCreatorBlipColor = {
                    description = "Boja mapne oznake koja se koristi za policijske stanice.",
                    label = "Boja oznake stanice",
                },
                stationCreatorBlipScale = {
                    description = "Veličina koja se koristi za oznake policijskih stanica.",
                    label = "Veličina oznake stanice",
                },
                stationCreatorBlipShortRange = {
                    description = "Prikažite oznake stanica samo na kratkom dometu.",
                    label = "Kratak domet oznake stanice",
                },
                stationCreatorBlipSprite = {
                    description = "Sprajt mapne oznake koji se koristi za policijske stanice.",
                    label = "Sprajt oznake stanice",
                },
                stationCreatorBlipUseStationName = {
                    description = "Koristite konfigurisani naziv stanice za oznaku na mapi.",
                    label = "Koristi naziv stanice",
                },
                tabletAutoFillCitizens = {
                    description = "Unapred popunite registar građana iz baze podataka frejmvorka.",
                    label = "Automatsko popunjavanje građana",
                },
                tabletAutoFillVehicles = {
                    description = "Unapred popunite registar vozila iz baze podataka frejmvorka.",
                    label = "Automatsko popunjavanje vozila",
                },
                tabletBolos = {
                    description = "Prikažite BOLO aplikaciju.",
                    label = "BOLO",
                },
                tabletCases = {
                    description = "Prikažite aplikaciju za slučajeve.",
                    label = "Slučajevi",
                },
                tabletCitizens = {
                    description = "Prikažite aplikaciju registra građana.",
                    label = "Građani",
                },
                tabletConfiscations = {
                    description = "Prikaži evidenciju predmeta zaplenjenih tokom pretresa.",
                    label = "Zaplene",
                },
                tabletOffences = {
                    description = "Prikažite aplikaciju za prekršaje.",
                    label = "Prekršaji",
                },
                tabletPrison = {
                    description = "Prikažite aplikaciju zatvora.",
                    label = "Zatvor",
                },
                tabletReportEnforcement = {
                    description = "Dozvoli povezivanje prekršaja i izdavanje kazni ili zatvora iz sačuvanih izveštaja.",
                    label = "Izvršenje iz izveštaja",
                },
                tabletReports = {
                    description = "Prikažite aplikaciju za izveštaje.",
                    label = "Izveštaji",
                },
                tabletSocialWork = {
                    description = "Prikažite aplikaciju za društveno koristan rad.",
                    label = "Društveno koristan rad",
                },
                tabletVehicles = {
                    description = "Prikažite aplikaciju registra vozila.",
                    label = "Vozila",
                },
                tabletWarrants = {
                    description = "Prikažite aplikaciju za naloge.",
                    label = "Nalozi",
                },
                tabletWeapons = {
                    description = "Prikažite aplikaciju registra oružja.",
                    label = "Oružje",
                },
                tackleCuffKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Veži oborenu osobu",
                },
                tackleKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Obaranje",
                },
                tackleReleaseKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Pusti oborenu osobu",
                },
                vehicleRadarAlertCooldownMs = {
                    description = "Milisekunde pre nego što se može podići novo upozorenje radara.",
                    label = "Pauza upozorenja",
                },
                vehicleRadarAllowedVehicleClasses = {
                    description = "Klase vozila kojima je dozvoljeno korišćenje radara.",
                    label = "Dozvoljene klase vozila",
                },
                vehicleRadarAutoFastLock = {
                    description = "Automatski označite izuzetno brze mete u radaru.",
                    label = "Automatsko brzo zaključavanje",
                },
                vehicleRadarAutoFastLockThreshold = {
                    description = "Prag brzine koji se koristi za automatsko brzo zaključavanje.",
                    label = "Prag brzog zaključavanja",
                },
                vehicleRadarDecreaseLimitKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Radar: Smanji ograničenje",
                },
                vehicleRadarDefaultLimit = {
                    description = "Podrazumevano ograničenje brzine koje koristi radar vozila.",
                    label = "Podrazumevano ograničenje radara",
                },
                vehicleRadarEnabled = {
                    description = "Omogućite radar patrolnog vozila.",
                    label = "Radar vozila",
                },
                vehicleRadarIncreaseLimitKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Radar: Povećaj ograničenje",
                },
                vehicleRadarLimitStep = {
                    description = "Iznos promene po podešavanju ograničenja radara.",
                    label = "Korak ograničenja",
                },
                vehicleRadarLockFrontKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Radar: Prednje zaključavanje",
                },
                vehicleRadarLockRearKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Radar: Zadnje zaključavanje",
                },
                vehicleRadarMaxLimit = {
                    description = "Maksimalno ograničenje brzine dozvoljeno u radaru vozila.",
                    label = "Maksimalno ograničenje radara",
                },
                vehicleRadarMaxPitchDeg = {
                    description = "Maksimalni nagib dozvoljen za ciljanje radarom.",
                    label = "Maksimalni stepen nagiba",
                },
                vehicleRadarMinLimit = {
                    description = "Minimalno ograničenje brzine dozvoljeno u radaru vozila.",
                    label = "Minimalno ograničenje radara",
                },
                vehicleRadarMinTargetSpeed = {
                    description = "Minimalna brzina pre nego što radar smatra metu validnom.",
                    label = "Minimalna brzina mete",
                },
                vehicleRadarModeFrontKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Radar: Prednji režim",
                },
                vehicleRadarModeRearKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Radar: Zadnji režim",
                },
                vehicleRadarMovingScanIntervalMs = {
                    description = "Milisekunde između skeniranja radara dok se patrolno vozilo kreće.",
                    label = "Interval skeniranja u pokretu",
                },
                vehicleRadarPassengerControl = {
                    description = "Dozvolite putnicima da upravljaju radarom vozila.",
                    label = "Kontrola putnika",
                },
                vehicleRadarPassengerEnabled = {
                    description = "Dozvolite putnicima da vide ogledalne podatke radara.",
                    label = "Ogledalo za putnika",
                },
                vehicleRadarPassengerSyncIntervalMs = {
                    description = "Milisekunde između ažuriranja sinhronizacije radara za putnike.",
                    label = "Interval sinhronizacije putnika",
                },
                vehicleRadarProjectionThreshold = {
                    description = "Prag projekcije koji se koristi prilikom procene meta radara.",
                    label = "Prag projekcije",
                },
                vehicleRadarRequireLineOfSight = {
                    description = "Zahtevajte jasno vidno polje pre nego što radar zaključa metu.",
                    label = "Zahtevaj vidno polje",
                },
                vehicleRadarRequireOnDuty = {
                    description = "Zahtevajte dežurno stanje pre korišćenja radara vozila.",
                    label = "Radar zahteva dežurstvo",
                },
                vehicleRadarScanIntervalMs = {
                    description = "Milisekunde između skeniranja radara u mirovanju.",
                    label = "Interval skeniranja",
                },
                vehicleRadarScanRadius = {
                    description = "Poluprečnik skeniranja radara vozila.",
                    label = "Poluprečnik skeniranja",
                },
                vehicleRadarToggleKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Radar: Uključi/isključi",
                },
                vehicleRadarUseMph = {
                    description = "Prikazujte vrednosti brzine radara u MPH.",
                    label = "Radar koristi MPH",
                },
                vehicleRadarVehiclePoolRefreshMs = {
                    description = "Milisekunde između osvežavanja skupa obližnjih vozila.",
                    label = "Osvežavanje skupa vozila",
                },
                vehicleRadarXmitFrontKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Radar: Prednje slanje/pauza",
                },
                vehicleRadarXmitRearKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Radar: Zadnje slanje/pauza",
                },
                wheelClampConsumeItem = {
                    description = "Uklonite predmet blokade točka nakon postavljanja.",
                    label = "Potroši predmet blokade",
                },
                wheelClampEnabled = {
                    description = "Omogućite radnju blokade točka.",
                    label = "Blokada točka",
                },
                wheelClampItem = {
                    description = "Predmet iz inventara koji se koristi za postavljanje blokade točka.",
                    label = "Predmet blokade",
                },
                wheelClampPropModel = {
                    description = "Model rekvizita koji se koristi za postavljenu blokadu točka.",
                    label = "Model rekvizita blokade",
                },
                wheelClampRequireItem = {
                    description = "Zahtevajte konfigurisani predmet blokade točka. Ostavite ovo omogućeno kada je način korišćenja blokade podešen na Inventar ili Oba.",
                    label = "Blokada zahteva predmet",
                },
                wheelClampRequireOnDuty = {
                    description = "Zahtevajte dežurno stanje pre postavljanja blokade točka.",
                    label = "Blokada zahteva dežurstvo",
                },
                wheelClampTyreDistance = {
                    description = "Maksimalna udaljenost do gume prilikom postavljanja ili zavarivanja blokade.",
                    label = "Udaljenost od gume",
                },
                wheelClampUseItem = {
                    description = "Koristite radijalni meni, inventar ili oba za postavljanje blokade točka. Inventar ili Oba treba kombinovati sa opcijom Blokada zahteva predmet.",
                    label = "Način korišćenja blokade",
                    options = {
                        both = "Oba",
                        inventory = "Inventar",
                        radial = "Radijalno",
                    },
                },
                wheelClampVehicleDistance = {
                    description = "Maksimalna udaljenost do ciljanog vozila prilikom postavljanja blokade.",
                    label = "Udaljenost od vozila",
                },
                wheelClampWeldBurstTyre = {
                    description = "Probušite gumu nakon što se blokada zavarivanjem ukloni.",
                    label = "Probuši gumu",
                },
                wheelClampWeldDurationMs = {
                    description = "Milisekunde potrebne za uklanjanje blokade zavarivanjem.",
                    label = "Trajanje zavarivanja",
                },
                wheelClampWeldEnabled = {
                    description = "Dozvolite uklanjanje blokade točka pomoću aparata za zavarivanje.",
                    label = "Zavarivanje blokade",
                },
                wheelClampWeldItem = {
                    description = "Predmet iz inventara neophodan za zavarivanje blokade.",
                    label = "Predmet aparata za zavarivanje",
                },
                wheelClampWeldMinigame = {
                    description = "Zahtevajte mini-igru zavarivanja blokade pre nego što se uklanjanje završi.",
                    label = "Mini-igra zavarivanja",
                },
                ziptiesConsumeItem = {
                    description = "Uklonite predmet vezice kada se ona stavi.",
                    label = "Potroši vezicu",
                },
                ziptiesCutterConsumeItem = {
                    description = "Uklonite predmet sekača nakon sečenja vezica.",
                    label = "Potroši predmet sekača",
                },
                ziptiesCutterEnabled = {
                    description = "Dozvolite uklanjanje vezica pomoću sekača žice.",
                    label = "Sekač vezica",
                },
                ziptiesCutterItem = {
                    description = "Predmet iz inventara koji se koristi za sečenje vezica.",
                    label = "Predmet sekača",
                },
                ziptiesEnabled = {
                    description = "Omogućite radnje sa vezicama.",
                    label = "Vezice",
                },
                ziptiesItem = {
                    description = "Predmet iz inventara koji se koristi za radnje sa vezicama.",
                    label = "Predmet vezice",
                },
                ziptiesRequireHandsUp = {
                    description = "Zahtevajte stanje ruku uvis pre stavljanja vezica.",
                    label = "Ruke uvis za vezice",
                },
                ziptiesRequireItem = {
                    description = "Zahtevajte konfigurisani predmet vezice.",
                    label = "Vezice zahtevaju predmet",
                },
                ziptiesReturnOnRemove = {
                    description = "Vratite predmet vezice kada se vezice skinu.",
                    label = "Vrati vezicu",
                },
                evidenceGsrDurationSeconds = {
                    description = "Остаци пуцња остају на рукама играча.",
                    label = "GSR трајање",
                },
                evidenceGsrGlovesProtectHands = {
                    description = "Спречи GSR да буде примењен када стрелац носи рукавице.",
                    label = "Рукавице штите руке",
                },
                evidenceGsrIgnoredWeapons = {
                    description = "Оружје које не примењује остатак пуцњаве.",
                    label = "Игнорирано оружје",
                },
                evidenceGsrWashCheckIntervalMs = {
                    description = "Милисекунди између провере воде и ограде док је GSR активан.",
                    label = "Период прања",
                },
                evidenceGsrWashInRain = {
                    description = "Дозволи киши да уклони остатке пуцњаве.",
                    label = "прање по киши",
                },
                evidenceGsrWashInWater = {
                    description = "Дозволи воду да уклони остатке пуцњаве.",
                    label = "Прање у води",
                },
                fakePlateHeliDisplay = {
                    label = "Хеликам показује лажни тањир",
                    description = "Приказује лажни тањир у хеликоптер камере.",
                },
                fakePlateNormalToolsDisplay = {
                    label = "Нормални алат показује лажну тањир",
                    description = "Приказује лажни тањир у стандардном полицијском алат.",
                },
                fakePlateRadarDisplay = {
                    label = "Радар показује лажни тањир",
                    description = "Приказује лажну плочу на радару на броду.",
                },
                fakePlateRecognitionEnabled = {
                    description = "Дозволи полицијски системи да прочитају заједнички лажни тањир.",
                    label = "Препознај лажне таблице",
                },
                fakePlateRecognitionStateBagKey = {
                    description = "Кључ ентитета возила објављен од стране Механика.",
                    label = "~@ ¦Стајтбаг¦statebag¦ кључ",
                },
                fakePlateSpeedCamDisplay = {
                    label = "Спеедкам приказује лажни тањир",
                    description = "Приказује лажни тањир у фиксни радар извештаја.",
                },
                fakePlateVinAllowedGrades = {
                    description = "Опциона професија/разред дозвољавајућа листа. Оставите празна да бисте дозволили све оцене дозвољених професија.",
                    label = "VIN разреда",
                },
                fakePlateVinAllowedJobs = {
                    label = "VIN професија",
                    description = "Професије су дозвољене да користе VIN проверу.",
                },
                fakePlateVinAudit = {
                    label = "Ревизија VIN провера",
                    description = "Сачува VIN чекове у ревизорски дневник.",
                },
                fakePlateVinCheckEnabled = {
                    label = "VIN пров› јера укључена",
                    description = "Укључује команду за проверу возила VIN.",
                },
                fakePlateVinCommand = {
                    label = "VIN наредба",
                    description = "Наредба која се користи за проверу возила VIN.",
                },
                fakePlateVinCooldown = {
                    label = "VIN охлађење",
                    description = "Одлагање између две провере VIN.",
                },
                fakePlateVinDistance = {
                    label = "VIN макс. растојање",
                    description = "Највећа растојање између официра и возила да потврди своје VIN.",
                },
                fakePlateVinIndicator = {
                    label = "Прикажи лажни индикатор",
                    description = "Приказује индикатор када провера детектира лажни тањир.",
                },
                fakePlateVinRequireDuty = {
                    label = "Захтевам дужност",
                    description = "Захтева да официр буде на дужности да потврди VIN.",
                },
                fakePlateVinRequireScanner = {
                    label = "Захт› ијевај ставку скенера",
                    description = "Захтева подешени скенер објекат да потврди VIN.",
                },
                fakePlateVinScannerItem = {
                    label = "Скенерска ставка",
                    description = "Записник захтеван да потврди VIN.",
                },
                jailRemoveJobOnJail = {
                    description = "Поставите затвореника на незапослен када су у затвору.",
                    label = "Уклони професију у затвору",
                },
                jailRestoreOriginalJobOnRelease = {
                    description = "Обнови првобитну професију затвореника после ослобађања, искључи да буду незапослени.",
                    label = "Обнови изворну професију",
                },
                primaryColor = {
                    description = "Подразумевана боја за групу полицијских послова.",
                    label = "Примарна боја",
                },
                speedCamAdvancedAllowFakePlateApproval = {
                    description = "Дозволите ревизорима да наплаћују регистрованом власнику чак и када је заробљена плоча означена као лажна или клонирана.",
                    label = "Дозволи осумњиченим лажним плочама",
                },
                speedCamAdvancedPageSize = {
                    description = "Највише снимања враћа по страници таблета.",
                    label = "Величина прегледа странице",
                },
                speedCamAdvancedRecognizedSides = {
                    description = "Странице возила чије се фотографије могу користити за препознавање плочица.",
                    itemLabel = "Страна",
                    label = "Препознате стране",
                },
                speedCamAdvancedRequireEvidence = {
                    description = "Дозвољава одобрење само након завршеног слања фотоапарата.",
                    label = "Захт› ијевај доказе за слику",
                },
                speedCamAdvancedReviewPermission = {
                    description = "Дозвола шефа за одобравање или одбацивање снимања. 18 је Менаџер Билинг.",
                    label = "Дозвола за преглед ID",
                },
                speedCamAdvancedStoreUnregistered = {
                    description = "Држите снимак чији тањир није присутан у регистровану базу возила.",
                    label = "Чувај нерегистрована возила",
                },
                tabletSpeedcamReviews = {
                    description = "Приказује напредну апликацију за преглед брзине када је укључен напредни режим.",
                    label = "Брзи прегледи камере",
                },
                tackleCommand = {
                    description = "Наредба регистрована за решавање најближе особе. Унесите име наредбе без црте.",
                    label = "Наредба за такловање",
                },
                tackleCuffCommand = {
                    description = "Наредба регистрована за лисице на лицу која је тренутно држана након обухватања. Унесите име команде без црте.",
                    label = "Наредба за лисице",
                },
                tackleCuffDescription = {
                    description = "Опис приказан за увезивање лисица у менију ПетМ.",
                    label = "Опис кључева за лисице",
                },
                tackleDescription = {
                    description = "Опис приказан за увезивање у ~@ ¦ПетМ¦FiveM¦ тастерима.",
                    label = "Опис ~@ ¦такл¦Takkle¦ кључа¦",
                },
                tackleEnabled = {
                    description = "Активирајте борбу против најближе особе и држите их на терену.",
                    label = "Тацклес",
                },
                tackleMaxDistance = {
                    description = "Највећа растојање до мете при покретању обарања.",
                    label = "Удаљеност од такела",
                },
                tackleNeedsSprint = {
                    description = "Захтевају официр да буде сprintинг пре него што се бори са особом.",
                    label = "Такл захт› ијева printing",
                },
                tackleReleaseCommand = {
                    description = "Наредба регистрована за ослобађање особе која је тренутно одржана после облачића. Унесите име наредбе без црте.",
                    label = "Наредба за ослобађање такла",
                },
                tackleReleaseDescription = {
                    description = "Опис приказан за увезивање ослобађања у менију ПетМ тастера.",
                    label = "Опис тастера за ослобађање такла",
                },
                tackleRequireOnDuty = {
                    description = "Захтевају дужност пре него што официр може да се суочи са особом.",
                    label = "Такл захтева дужност.",
                },
                vehicleRadarCustomizeCommand = {
                    description = "Наредба за отварање или затварање уређивача радара. Унесите име наредбе без црте.",
                    label = "Наредба распореда радара",
                },
                vehicleRadarResetLayoutCommand = {
                    description = "Наредба за повратак подразум› ијеваног радарског распореда. Унесите име наредбе без ручке.",
                    label = "Ресетуј наредбу распореда радара",
                },
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "Dozvoljava zaposlenima da se upišu na slobodne treninge.",
                approvalRequired = "Održava upise dok ih ovlašæeni instruktor ne odobri.",
                defaultCapacity = "Подразум › ијевани број места се користи када се формира нова тренинг сесија.",
                enabled = "Tako je aplikacija za obuku dostupna ovom poslu.",
                requireOnDuty = "Zahteva da zaposleni budu na dužnosti pre otvaranja ili korišćenja aplikacije za obuku.",
                upcomingDays = "Broj dana u buduænosti prikazan u rasporedu obuke.",
            },
            trainingFields = {
                allowSelfEnrollment = "Дозволи самоуписивање",
                approvalRequired = "Захтев за одобрење уношења",
                defaultCapacity = "Подразум › ијевани капацитет",
                enabled = "Укључи обуку",
                requireOnDuty = "Захтевам дужност",
                upcomingDays = "Долазни период (дани)",
            },
            warnings = {
                cuffsConsumeRequiresItem = "Trošenje lisica nema efekta dok je zahtev za predmet lisica isključen.",
                wheelClampUseItemRequiresItem = "Režim upotrebe blokade Inventar ili Oba zahteva da opcija Blokada zahteva predmet ostane uključena.",
                ziptiesConsumeRequiresItem = "Trošenje vezica nema efekta dok je zahtev za predmet vezica isključen.",
            },
            locationDescriptions = {
                jail_public_blip = "Позиција се аутоматски преузима из тачке појављивања у затвору или из првог затворског терминала ако тачка није подешена.",
            },
        },
    },
    JobConfiguratorTitle = "подешавање професије",
    JobConfiguratorUnknown = "Непознат конфигуратор професије.",
}
