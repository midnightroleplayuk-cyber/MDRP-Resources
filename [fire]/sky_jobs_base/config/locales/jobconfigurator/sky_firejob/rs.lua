JobConfigLocales["sky_firejob:rs"] = {
    Nui = {
        workshopConfig = {
            configs = {
                sky_firejob = {
                    subtitle = "Конфигуришите ватрогасне послове, паљење упаљача, пожаре возила, техничко спасавање, НПЦ процедуре спасавања, ватрогасне станице и подешавања уредника мисије.",
                    title = "Ватрогасне службе",
                },
            },
            creatorSections = {
                fireStations = {
                    entryLabel = "Ватрогасна станица",
                    entryPluralLabel = "Ватрогасне станице",
                    label = "Ватрогасне станице",
                },
            },
            dispatchActions = {
                currentLocation = "Користи текућу локацију",
                addChannel = "Додај радио-канал",
                addKeyword = "Додај кључну реч",
                addPoi = "Додај тачку интереса",
                addReporter = "Додај пријавиоца",
                addStatus = "Додај FMS статус",
                addVehicle = "Додај виртуелну јединицу",
                addVehicleType = "Додај врсту јединице",
            },
            dispatchFieldDescriptions = {
                autoAlarm = "Одмах додељује поклапање доступних јединица када се направи инцидент.",
                available = "Jedinice u ovom statusu mogu biti predložene i dodeljene novom incidentu.",
                averageResponseSpeedKmh = "Израчунава приказану процену доласка са десне линије.",
                callsign = "Jedinstveni radio signal prikazan kada igraèi zauzimaju ovu virtuelnu jedinicu.",
                centerEnabled = "Omoguæava èlanovima dežurstva da osnuju dispeèerski centar.",
                channelId = "Radio-kanal ID za PMA glas, Saltièat i JACA. Бројне идентификације као што је 2500 остају непромењене; ПМА Глас мапира текстуалне идентификације на стабилан број.",
                channelLabel = "Читаво име канала приказано диспечерима и јединицама.",
                defaultChannel = "Dispeèeri se pridružuju ovom kanalu kada poènu svoju smenu. Jedinice se ruèno pridružuju sa radija. Изаберите ниједну за подразум › ијевану радну групу.",
                emergencyAppEnabled = "Ovaj posao èini odabranim za javnu službu u aplikaciji za hitne sluèajeve.",
                enabled = "Tako je ovaj posao dostupan za Dispeèer App i incidente sa unakrsnim poslovima.",
                icon = "Изаберите икону приказану у овој категорији јединице у диспечерском аппу.",
                incidentAssessmentEnabled = "Показује медицинску и опасну процену питања у пуном уносу инцидената.",
                jobs = "Dodatna radna imena koja primaju incidente koristeæi ovu kljuènu reè.",
                minimumCrew = "Минималан број особља преко јединица изабраних за овај план одговора.",
                noUnitFallback = "Без центра или особља јединице, шаље небо обавештење свим члановима на дужности.",
                radius = "Maksimalna udaljenost u metrima na kojoj se može èuti saopštenje stanice.",
                requirements = "Broj parova, na primer PATROL: 2, CRIME: 1.",
                statusCode = "Numeric FMS status prikazan na ruènom radiju.",
                statusLabel = "Što znaèi status FMS-a za dispeèere i jedinice.",
                vehicleType = "Mora da se podudara sa kodom tipa vozila koji je podešen u prethodnoj podsekciji.",
                vehicleTypeCode = "Kratki kod za reagovanje, na primer PATROL, CRIME, EMS, ili Spasenje.",
                vehicleTypeLabel = "Poznato ime ove jedinice.",
                crewCapacity = "Највећи број особа у јединици. Вредност 0 дозвољава неограничену посаду.",
                joinLocked = "Спречава придруживање додатних особа након што је јединица попуњена.",
                poiId = "Стабилна техничка ознака на коју профили центра упућују и после промене назива места.",
                readyStatusCode = "FMS статус који се поставља када ресурс постане спреман за слање.",
                resourceType = "Разврстава оперативни ресурс за филтере и координацију диспечерског центра.",
                respondingStatusCode = "FMS статус који се поставља када ресурс одговори на интервенцију.",
                shortLabel = "Необавезна кратка ознака на шест тастера меморије радио-канала.",
                stationId = "Повезује јединицу са станицом подешеном у профилу диспечерског центра.",
                unitId = "Стабилна техничка ознака која чува јединицу и после промене позивног знака.",
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
                defaultChannel = "Подразум › ијевани радио канал",
                emergencyAppEnabled = "Прикажи у хитној апликацији",
                enabled = "Укључи диспечер",
                icon = "Икона",
                incidentAssessmentEnabled = "Укључи хитну процену",
                jobs = "Мета послова (зарез раздвојен)",
                keywordCode = "Шифра кључне речи",
                label = "Ознака",
                minimumCrew = "Минимална посада",
                name = "Име",
                noUnitFallback = "Obavestite osoblje na dužnosti bez jedinica",
                noneChannel = "Ниједна група подразумевана",
                note = "Напомена",
                phone = "Telefon",
                radius = "Радијум најаве",
                requirements = "Тражене јединице (на пример патрол: 2, злочин: 1)",
                type = "Тип",
                vehicleType = "Тип одзивне јединице",
                crewCapacity = "Капацитет посаде",
                joinLocked = "Закључај придруживање посади",
                poiId = "Стабилни ID тачке интереса",
                readyStatusCode = "Код статуса спремности",
                resourceType = "Врста ресурса",
                respondingStatusCode = "Код статуса одзива",
                shortLabel = "Ознака радио-меморије",
                stationId = "ID станице",
                unitId = "Стабилни ID јединице",
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
                    statuses = "Доступни ФМС",
                    units = "Виртуелне јединице",
                    reporters = "Познати пријавиоци",
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
                dispatchStatusCodes = "Подешавање ФМС етикета стања и који статус се рачуна као доступан за нове инциденте.",
                dispatchVehicleTypes = "Definiše kategorije jedinica koje koriste planovi za reagovanje, kao što su Patrola, Jedinica za kriminal, EMS, ili Spasioci.",
                dispatchVehicles = "Definiše virtuelna vozila za dostavu koja mogu da se prebace sa bilo kog mesta, a da im ne treba vozilo za razmnožavanje.",
                dispatchReporters = "Управља именима пријавилаца, бројевима за повратни позив и белешкама диспечера за овај посао.",
            },
            extensions = {
                invalidSelection = "Nevažeći izbor: {value}",
                trainingSettings = {
                    description = "Подеси приступ тренингу, упис, дозволе, и планирање курса за овај посао.",
                    label = "Поставке тренинга",
                },
                dispatchReporters = "Познати пријавиоци",
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
            },
            extinguisherMaintenanceStates = {
                checked = "Тестирано",
                damaged = "Оштећено",
                empty = "Празно",
                missing = "Без апарата за гашење пожара",
            },
            extinguisherMountStates = {
                empty = "Празан држач",
                mounted = "Коришћен апарат за гашење пожара",
            },
            features = {
                waterMonitor = {
                    description = "Гаси веће пожаре конзистентним воденим млазом и подесивим нагибом. Захтева довод до ватрогасног возила са резервоаром за воду, хидрантом или пумпом.",
                    label = "Водени топ",
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
            misc = {
                defaultFireTruckLabel = "Ватрогасна кола",
                fireStationCategoryLabel = "Ватрогасна станица",
                fireStationEntryLabel = "Ватрогасна станица",
                fireStationPosition = "Положај ватрогасне станице",
                fireStationsTitle = "Ватрогасне станице",
                hoseConnectionEditorTitle = "Уређивач прикључка црева",
                hydrantConnectionEditorTitle = "Уредник за повезивање црева хидранта",
                pumpIntakeEditorTitle = "Уређивач улаза за пумпу",
                pumpOutletEditorTitle = "Едитор излаза пумпе",
                pumpPanelAccessEditorTitle = "Уредник приступа контроле црева",
                scbaRefillBlipLabel = "Пуњење за заштиту органа за дисање",
                scbaRefillStationLabel = "Пунионица за заштиту органа за дисање",
            },
            settingFields = {
                cannonId = "ИД воденог топа",
                cannonLabel = "Назив воденог топа",
                reason = "Разлог",
                airBottleSlots = "Прорези за флаше са компримованим ваздухом",
                amount = "Износ",
                automatic = "Аутоматски",
                canSpread = "Може се ширити",
                component = "Компонента",
                connection = "веза",
                currentPosition = "Тренутна позиција",
                delete = "Избриши",
                description = "Опис",
                dispatchJobs = "Занимања за диспечерски позив",
                drawables = "Варијанте",
                enabled = "Активан",
                fillLevel = "Капацитет",
                fireType = "Врста пожара",
                foamTankEnabled = "Резервоар за пену",
                foamTankSize = "литара пене",
                gearKey = "Тип",
                hydrantConnection = "Прикључак хидранта",
                hydrantRx = "Хидрант црвени Кс",
                hydrantRy = "Хидрант црвени И",
                hydrantRz = "Хидрант Ред З",
                hydrantX = "Хидрант Кс",
                hydrantY = "Хидрант И",
                hydrantZ = "Хидрант З",
                id = "ИД",
                igniteDistance = "Удаљеност паљења",
                intensity = "Интензитет",
                job = "Занимање",
                jobs = "Дежурна занимања",
                key = "Кључ",
                label = "Назив",
                location = "Положај",
                maintenanceStatus = "Статус одржавања",
                minOnDuty = "Потребно у сервису",
                minimum = "Барем онлајн",
                mission = "Мисија",
                model = "Модел",
                name = "Име",
                prop = "Објекат",
                pumpConnections = "Прикључци пумпе",
                pumpDischargeCount = "Изласци пумпе",
                pumpIntake1Connection = "Улаз 1",
                pumpIntake1Label = "Улаз 1 – ознака",
                pumpIntake1Rx = "Улаз 1 – ротација X",
                pumpIntake1Ry = "Улаз 1 – ротација Y",
                pumpIntake1Rz = "Улаз 1 – ротација Z",
                pumpIntake1X = "Улаз 1 – X",
                pumpIntake1Y = "Улаз 1 – Y",
                pumpIntake1Z = "Улаз 1 – Z",
                pumpIntake2Connection = "Улаз 2",
                pumpIntake2Label = "Улаз 2 – ознака",
                pumpIntake2Rx = "Улаз 2 – ротација X",
                pumpIntake2Ry = "Улаз 2 – ротација Y",
                pumpIntake2Rz = "Улаз 2 – ротација Z",
                pumpIntake2X = "Улаз 2 – X",
                pumpIntake2Y = "Улаз 2 – Y",
                pumpIntake2Z = "Улаз 2 – Z",
                pumpIntakeCount = "Улази за пумпу",
                pumpOutlet1Connection = "Излаз 1",
                pumpOutlet1Label = "Излаз 1 – ознака",
                pumpOutlet1Rx = "Излаз 1 – ротација X",
                pumpOutlet1Ry = "Излаз 1 – ротација Y",
                pumpOutlet1Rz = "Излаз 1 – ротација Z",
                pumpOutlet1X = "Излаз 1 – X",
                pumpOutlet1Y = "Излаз 1 – Y",
                pumpOutlet1Z = "Излаз 1 – Z",
                pumpOutlet2Connection = "Излаз 2",
                pumpOutlet2Label = "Излаз 2 – ознака",
                pumpOutlet2Rx = "Излаз 2 – ротација X",
                pumpOutlet2Ry = "Излаз 2 – ротација Y",
                pumpOutlet2Rz = "Излаз 2 – ротација Z",
                pumpOutlet2X = "Излаз 2 – X",
                pumpOutlet2Y = "Излаз 2 – Y",
                pumpOutlet2Z = "Излаз 2 – Z",
                pumpOutlet3Connection = "Излаз 3",
                pumpOutlet3Label = "Излаз 3 – ознака",
                pumpOutlet3Rx = "Излаз 3 – ротација X",
                pumpOutlet3Ry = "Излаз 3 – ротација Y",
                pumpOutlet3Rz = "Излаз 3 – ротација Z",
                pumpOutlet3X = "Излаз 3 – X",
                pumpOutlet3Y = "Излаз 3 – Y",
                pumpOutlet3Z = "Излаз 3 – Z",
                pumpOutlet4Connection = "Излаз 4",
                pumpOutlet4Label = "Излаз 4 – ознака",
                pumpOutlet4Rx = "Излаз 4 – ротација X",
                pumpOutlet4Ry = "Излаз 4 – ротација Y",
                pumpOutlet4Rz = "Излаз 4 – ротација Z",
                pumpOutlet4X = "Излаз 4 – X",
                pumpOutlet4Y = "Излаз 4 – Y",
                pumpOutlet4Z = "Излаз 4 – Z",
                pumpPanelAccess = "Приступ контроли црева",
                pumpPanelConfigured = "Панел је подешен",
                pumpPanelSize = "Величина панела",
                pumpPanelX = "Панел X",
                pumpPanelY = "Панел Y",
                pumpPanelZ = "Панел Z",
                resource = "Ресурс",
                rx = "Црвени Кс",
                ry = "Црвена И",
                rz = "Црвени З",
                scenario = "Употреба",
                sourceScale = "Скалирање извора",
                state = "Статус заграде",
                teleport = "Телепорт",
                textures = "Текстуре",
                turretBone = "Кост топовске цеви",
                turretMuzzleOffsetX = "Помак њушке Кс",
                turretMuzzleOffsetY = "Померање њушке И",
                turretMuzzleOffsetZ = "Оффсет њушке З",
                turretOffsetX = "Гун Оффсет Кс",
                turretOffsetY = "Померање оружја И",
                turretOffsetZ = "офсет пиштоља З",
                turretTipOffset = "Удаљеност до врха цеви",
                waterGravityScale = "Гравитација воде",
                waterTankEnabled = "Резервоар за воду",
                waterTankSize = "литара воде",
                waterVelocity = "Брзина воде",
                weather = "Тип времена",
                x = "Кс",
                y = "И",
                z = "З",
                zOffset = "З оффсет",
            },
            settingGroups = {
                billing = { label = "Рачуни" },
                absorbentMinigame = {
                    description = "Контролише дистрибуцију везива у случају трагова уља.",
                    label = "Мини-игра Биндер",
                },
                access = {
                    label = "Приступ",
                },
                air = {
                    label = "Ваздух за дисање",
                },
                airItem = {
                    label = "Предмет боца ваздуха за дисање",
                },
                airRefill = {
                    label = "Напуните ваздух за дисање",
                },
                ambulance = {
                    label = "Служба спасавања",
                },
                animals = {
                    label = "Спасавање животиња",
                },
                attachment = {
                    label = "Причвршћивање",
                },
                automaticMissionDispatch = {
                    description = "Контролише упозорења за аутоматски и ручно покренуте мисије.",
                    label = "Упозорење",
                },
                automaticMissionJobs = {
                    description = "Ови послови се примењују ако за мисију није унет ниједан задатак.",
                    label = "Стандардни сервисни послови",
                },
                automaticMissionList = {
                    description = "Све мисије из уређивача мисија су аутоматски наведене.",
                    label = "Доступне мисије",
                },
                automaticMissionTiming = {
                    description = "Контролише када планер покушава да покрене аутоматску мисију.",
                    label = "Аутоматски окидач",
                },
                breathing = {
                    label = "Дисање",
                },
                breathingClothing = {
                    label = "Одећа за заштиту органа за дисање",
                },
                burnDamage = {
                    label = "Опекотине",
                },
                cleanup = {
                    description = "Контролише потребне ставке, потрошњу предмета и време напретка у резервном стању.",
                    label = "Процес чишћења",
                },
                consumption = {
                    label = "Потрошња",
                },
                creator = {
                    label = "Креатор",
                },
                detection = {
                    label = "Откривање",
                },
                dispatch = {
                    label = "Контролни центар",
                },
                distance = {
                    label = "Удаљености",
                },
                dump = {
                    label = "Ватер Дроп",
                },
                effects = {
                    label = "Ефекти",
                },
                engineBehavior = {
                    label = "Безбедност возила",
                },
                engineOutput = {
                    label = "Снага мотора",
                },
                engineRetention = {
                    label = "Прекорачење мотора",
                },
                enterAnimation = {
                    label = "Анимација за улазак",
                },
                exitAnimation = {
                    label = "Излазна анимација",
                },
                explosion = {
                    label = "Експлозија",
                },
                external = {
                    label = "Екстерни",
                },
                extinguish = {
                    label = "Избриши",
                },
                extinguisher = {
                    label = "Апарат за гашење пожара",
                },
                femaleBreathingClothing = {
                    label = "Одећа за заштиту органа за дисање",
                },
                femaleHeatClothing = {
                    label = "Одећа за заштиту од топлоте",
                },
                femaleProtectiveMaskClothing = {
                    label = "Одећа за заштитну маску",
                },
                fieldFlow = {
                    label = "Редослед мисије",
                },
                fireExtinguishFeedback = {
                    label = "Обавештење о брисању",
                },
                fireParticles = {
                    label = "Plamen i dim",
                },
                fireReward = {
                    description = "Контролише уплату на рачун компаније када је један пожар потпуно угашен.",
                    label = "Исплата бренда",
                },
                fireRewardJobs = {
                    description = "Друштва за запошљавање примају исплату бренда. Сваки посао користи свој конфигурисани налог компаније.",
                    label = "Послови у друштву брендова",
                },
                fireSoundAmbient = {
                    label = "Пожарна средина",
                },
                fireSoundChainsaw = {
                    label = "Моторна тестера",
                },
                fireSoundFlare = {
                    label = "Звук пламена",
                },
                fireThirst = {
                    label = "Жеђ у ватри",
                },
                flow = {
                    label = "Истек",
                },
                flowBehavior = {
                    label = "Понашање тока",
                },
                foamRefill = {
                    label = "Пуњење од пене",
                },
                foamRefillVisual = {
                    label = "Визуелно пуњење пеном",
                },
                fullFireStage = {
                    label = "фаза пуне ватре",
                },
                general = {
                    label = "Генерал",
                },
                glassMinigame = {
                    description = "Контролише мини-игру слабе тачке за прозоре возила.",
                    label = "Дисц мини-игра",
                },
                groundActionAnimation = {
                    label = "Испусти и узми анимацију",
                },
                hazard = {
                    description = "Контролише ризик од клизања, интензитет и прагове аутоматског уклањања изливања нафте.",
                    label = "Вредности опасности",
                },
                heat = {
                    label = "Врућина",
                },
                heatClothing = {
                    label = "Одећа за заштиту од топлоте",
                },
                heatStress = {
                    label = "Топлотни стрес",
                },
                helicopters = {
                    label = "Хеликоптер",
                },
                hoseGrounding = {
                    label = "Постављање пода",
                },
                hosePerformance = {
                    label = "Перформансе",
                },
                hoseProp = {
                    label = "Хосе Проп",
                },
                hosePropGeometry = {
                    label = "Проп Геометри",
                },
                hoseSimulation = {
                    label = "Симулација",
                },
                hydrantSupply = {
                    label = "Снабдевање хидрантима",
                },
                hydrants = {
                    label = "Хидранти",
                },
                idleAnimation = {
                    label = "Оперативна анимација",
                },
                ignition = {
                    label = "Novi požari iz menija",
                },
                interaction = {
                    label = "Интеракција",
                },
                item = {
                    label = "Ставка",
                },
                items = {
                    label = "Ставке",
                },
                keybinds = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Prečice",
                },
                landing = {
                    label = "Слетање",
                },
                limits = {
                    label = "Ограничења",
                },
                maintenance = {
                    label = "Статус",
                },
                maintenanceAccess = {
                    label = "Приступ",
                },
                manual = {
                    label = "Ручно паљење",
                },
                manualOnly = {
                    label = "Само ручно",
                },
                nozzle = {
                    label = "Радиант пипе",
                },
                nozzleAttachment = {
                    label = "Прикључак за црево",
                },
                nozzleBend = {
                    label = "Спојна кривина",
                },
                nozzleDirection = {
                    label = "смер излаза",
                },
                nozzlePlacement = {
                    label = "Постављање пода",
                },
                npcFireReactions = {
                    label = "НПЦ ватрене реакције",
                },
                npcFireReactionsModes = {
                    label = "НПЦ типови реакција",
                },
                offsets = {
                    label = "Помаци за причвршћивање",
                },
                oilReward = {
                    description = "Контролише депозит на рачун компаније када је изливање нафте очишћено.",
                    label = "Исплата нафте",
                },
                oilRewardJobs = {
                    description = "Друштва за запошљавање примају исплате за чишћење нафте. Сваки посао користи свој конфигурисани налог компаније.",
                    label = "Послови у нафтном друштву",
                },
                placement = {
                    label = "Пласман",
                },
                playerEntrapment = {
                    label = "Заробљавање играча",
                },
                portablePumpSupply = {
                    label = "Снабдевање преносивим пумпама",
                },
                pressureControl = {
                    label = "Контрола притиска",
                },
                pressureLimits = {
                    label = "Границе притиска",
                },
                progression = {
                    label = "Развој",
                },
                propGeneral = {
                    label = "Запаљиви предмети",
                },
                propLimits = {
                    label = "Ограничења извора ватре",
                },
                propList = {
                    label = "Могуће тачке паљења",
                },
                props = {
                    label = "Објекти",
                },
                protectiveMask = {
                    label = "Заштитна маска за шумске пожаре",
                },
                protectiveMaskClothing = {
                    label = "Одећа за заштитну маску",
                },
                protectiveMaskItem = {
                    label = "Предмет заштитне маске",
                },
                pump = {
                    label = "Пумпа",
                },
                pumpDamage = {
                    label = "Оштећење пумпе",
                },
                pumpIntakeHose = {
                    label = "Усисно црево",
                },
                pumpPanelGeneral = {
                    description = "Бирајте између основне аутоматске и напредне ручне контроле пумпе.",
                    label = "Режим панела",
                },
                pumpTargets = {
                    label = "Циљеви везе",
                },
                rainFire = {
                    label = "Понашање у пожару",
                },
                rainGeneral = {
                    label = "Генерал",
                },
                rainVisuals = {
                    label = "Репрезентација",
                },
                rainWeather = {
                    label = "Интензитет времена",
                },
                random = {
                    label = "Случајност",
                },
                randomJobs = {
                    label = "Случајни послови",
                },
                reignition = {
                    label = "Ресургенце",
                },
                release = {
                    label = "Издање",
                },
                render = {
                    label = "Видљивост",
                },
                requirements = {
                    label = "Минимални захтеви",
                },
                rescueReward = {
                    description = "Контролише депозит на рачун компаније када се заврши задатак спасавања.",
                    label = "Исплата за спасавање",
                },
                rescueRewardJobs = {
                    description = "Друштва за запошљавање примају исплате за спасавање. Сваки посао користи свој конфигурисани налог компаније.",
                    label = "Послови спасилачког друштва",
                },
                restock = {
                    label = "Рефилл",
                },
                rpmRange = {
                    label = "Опсег брзине",
                },
                seatbelt = {
                    description = "Контролише сечење појаса за заробљене пацијенте.",
                    label = "Мини-игра са сигурносним појасевима",
                },
                smallFireStage = {
                    label = "Фаза мале пожара",
                },
                smokeStage = {
                    label = "Фаза дима",
                },
                spreaderMinigame = {
                    description = "Контролише мини-игру притиска за расипач врата.",
                    label = "Мини-игра Доор Спреадер",
                },
                standaloneAccidents = {
                    label = "Независне несреће",
                },
                standaloneResult = {
                    label = "Самостални резултат",
                },
                standaloneThresholds = {
                    label = "Самостални лимити",
                },
                stream = {
                    label = "Млаз воде",
                },
                sweepMinigame = {
                    description = "Контролише чишћење изливене нафте.",
                    label = "Свеепинг Мини-игра",
                },
                tankFill = {
                    label = "Пуњење резервоара",
                },
                tankSupply = {
                    label = "Снабдевање цистерном возила",
                },
                targets = {
                    label = "Циљеви",
                },
                thermalWarnings = {
                    label = "Упозорења о температури",
                },
                timing = {
                    label = "Контрола времена",
                },
                treeBase = {
                    description = "Основна статистика за распоређивање стабла: активација, дужност, модел и распон покрета.",
                    label = "Употреба",
                },
                treeBlip = {
                    description = "Означивач на мапи за активно постављање стабла.",
                    label = "Означивач на мапи",
                },
                treeCarry = {
                    description = "Ношени дрвени модел, кости, помаци и покрети се мешају када се носе.",
                    label = "Ношење реквизита",
                },
                treeCarryAnimation = {
                    description = "Директоријум анимације, име и застава када носите дрвене комаде.",
                    label = "Ношење анимације",
                },
                treeDispatch = {
                    description = "Контролише да ли имплементације стабла шаљу отпрему и који послови је примају.",
                    label = "Контролни центар",
                },
                treeDropMarker = {
                    description = "Стил и боја маркера на дрвеној полици.",
                    label = "Одбаци маркер",
                },
                treeDropZone = {
                    description = "Локални помак, радијус и опсег чишћења за испуштене комаде дрвета.",
                    label = "Зона пада",
                },
                treeInteractionMarker = {
                    description = "Стил маркера и боја на интеракцији стабла.",
                    label = "Маркер тестере",
                },
                treeInteractionPoint = {
                    description = "Удаљеност интеракције и локална позиција на којој су играчи видели дрво.",
                    label = "Сав поинт",
                },
                treeLogSpawn = {
                    description = "Број, модел, размак и даљина снимања произведених комада дрвета.",
                    label = "Дрвени комади",
                },
                treeReward = {
                    description = "Контролише уплату на рачун компаније када је оборено дрво потпуно очишћено.",
                    label = "Трее Исплата",
                },
                treeRewardJobs = {
                    description = "Друштва за запошљавање примају исплате за дрво. Сваки посао користи свој конфигурисани налог компаније.",
                    label = "Послови за Трее Социети",
                },
                treeSawAnimation = {
                    description = "Директоријум анимације, име и застава током тестерисања.",
                    label = "Видео анимација",
                },
                treeSawAttach = {
                    description = "Фино подешавање положаја, ротације, судара и понашања моторне тестере.",
                    label = "Прикључак за моторну тестеру",
                },
                treeSawMinigame = {
                    description = "Колико секција за тестерисање мора бити завршено пре него што се комади дрвета могу очистити.",
                    label = "Мини-игрица Сав",
                },
                treeSawTool = {
                    description = "Модел и кост моторне тестере током тестерисања.",
                    label = "Проп за моторну тестеру",
                },
                types = {
                    label = "Типови",
                },
                usage = {
                    label = "Ставка и команда",
                },
                vehicle = {
                    label = "Паљење возила",
                },
                vehicleBend = {
                    label = "кривина прикључка возила",
                },
                vehicleEntrapment = {
                    label = "Заглављивање возила",
                },
                vehiclePumpBehavior = {
                    label = "Понашање пумпе и мотора",
                },
                vehicleSmokeClasses = {
                    label = "Заштићени типови возила",
                },
                vehicleSmokeProtection = {
                    label = "Заштита од дима возила",
                },
                vehicleState = {
                    label = "Стање возила",
                },
                vehicleTransfer = {
                    label = "Пренос воде возила",
                },
                vehicleTransferBehavior = {
                    label = "Трансфер понашања",
                },
                vehicleTransferSourceOffset = {
                    label = "Изворни порт",
                },
                vehicleTransferTargetOffset = {
                    label = "Одредишна веза",
                },
                vehicles = {
                    label = "Возила",
                },
                water = {
                    label = "Вода",
                },
                waterCannon = {
                    label = "Водени топ за возила",
                },
                waterReaction = {
                    label = "Реакција воде",
                },
            },
            settingSections = {
                billing = "Рачуни",
                activeOilSpills = "Активни трагови нафте",
                automaticMissions = "Аутоматске опкладе",
                consumption = "Потрошња",
                effects = "Ефекти",
                extinguishFeedback = "Одговор на брисање",
                extinguishing = "Избриши",
                fire = "Ватра",
                foamRefill = "Допуна средства за пену",
                foamRefillVisual = "Паддинг Визуелизација",
                general = "Генерал",
                heliBucket = "Ведро за гашење пожара",
                hose = "Црево",
                hydrants = "Хидранти",
                interiorExtinguishers = "Унутрашњи апарат за гашење пожара",
                lighter = "Упаљач",
                minigames = "Мини игре",
                npcRescue = "НПЦ Ресцуе",
                oilCleanup = "Чишћење",
                oilGeneral = "Генерал",
                oilHazard = "Опасност",
                oilSpills = "Трагови нафте",
                protectiveGear = "Заштитна одећа",
                pump = "Пумпа",
                pumpPanel = "Панел пумпе",
                rain = "Киша",
                reignition = "Ресургенце",
                rendering = "Репрезентација",
                rescueCushion = "Јумп Ресцуер",
                rewardFire = "Награда бренда",
                rewardOil = "Награда за уље",
                rewardRescue = "Награда за спасавање",
                rewardTree = "Трее Ревард",
                rewards = "Награде",
                scenarioCreator = "Уредник мисије",
                sounds = "Звукови",
                spread = "Ширење пожара",
                treeDispatch = "Контролни центар",
                treeDrop = "Фајл",
                treeGeneral = "Генерал",
                treeInteraction = "Интеракција",
                treeLogs = "Дрвени комади",
                treeSaw = "Тестере",
                trees = "Дрвеће",
                vehicleEntrapment = "Заглављивање возила",
                vehicleFires = "Пожари возила",
                vehicleRescue = "Спасавање возила",
                vehicles = "Возила",
                waterMonitor = "Водени топ",
            },
            settingSubsections = {
                weaponIgnition = "Požari od oružja",
                activeOilSpills = "Активни трагови нафте",
                consumption = "Потрошња",
                engineSafety = "Мотор и безбедност",
                extinguishFeedback = "Одговор на брисање",
                extinguisherCustomMounts = "Прилагођени носачи",
                extinguisherGeneral = "Генерал",
                extinguisherMaintenance = "Одржавање",
                extinguisherMounts = "Држач и ниво",
                extinguisherPlacement = "Пласман",
                extinguishing = "Избриши",
                femaleClothing = "Женска одећа",
                foamRefill = "Допуна средства за пену",
                foamRefillVisual = "Паддинг Визуелизација",
                general = "Генерал",
                hydrants = "Хидранти",
                hydraulics = "Хидраулика",
                keybinds = "Prečice",
                maleClothing = "Мушка одећа",
                minigameGlass = "Диск",
                minigameOilAbsorbent = "везујуће уље",
                minigameOilSweep = "Свеепинг оил",
                minigameSaw = "Тестере",
                minigameSeatbelt = "Сигурносни појас",
                minigameSpreader = "Раширена врата",
                nozzle = "Радиант пипе",
                oilCleanup = "Чишћење",
                oilGeneral = "Генерал",
                oilHazard = "Опасност",
                pressure = "Притисак и брзина",
                pump = "Пумпа",
                rain = "Киша",
                reignition = "Ресургенце",
                rendering = "Репрезентација",
                reward = "Награда",
                rewardFire = "Награда за пожар",
                rewardOil = "Награда за изливање уља",
                rewardRescue = "Награда за спасавање",
                rewardTree = "Награда за уклањање дрвета",
                simulation = "Симулација",
                sounds = "Звукови",
                spread = "Ширење пожара",
                treeDispatch = "Дојава",
                treeDrop = "Место предаје",
                treeGeneral = "Опште",
                treeInteraction = "Дрво и интеракција",
                treeLogs = "Комади трупца",
                vehicleFires = "Пожари возила",
                vehicleTransfer = "Трансфер возила",
                vehicles = "Возила",
                visuals = "Репрезентација",
            },
            settings = {
                fireWeaponIgnitionEnabled = {
                    label = "Omogući požare od oružja",
                    description = "Stvara Sky požare od navedenog oružja. Ostavite isključeno dok vatrogasci ne budu spremni. Postojeći požari i izvorni GTA plamen ostaju nepromenjeni.",
                },
                fireWeaponIgnitionWeapons = {
                    label = "Oružje koje može izazvati požar",
                    description = "Nazivi oružja, npr. WEAPON_MOLOTOV ili WEAPON_FLAREGUN. Prazna lista isključuje požare od oružja. Projektili ili pogoci moraju biti prepoznatljivi.",
                },
                hoseHollowNozzleGroundOffset = {
                    label = "Pomak mlaznice sa šupljim mlazom u odnosu na tlo",
                },
                hoseNozzleModel = {
                    label = "Model mlaznice",
                    choose = "Izaberite model",
                    intact = "Model mlaznice",
                    description = "Izaberite običnu ili EU mlaznicu. Promena modela vraća postavljena napadna creva.",
                    preview = "3D pregled",
                    previewDescription = "Pogledajte stvarni objekat u igri. Izbor sačuvajte zasebno.",
                    previewHelp = "Strelice pomeraju, Page Up/Down menja visinu, točkić rotira, Enter zatvara, Backspace otkazuje.",
                    invalidModel = "Nevažeći model objekta.",
                    modelMissing = "Ovaj objekat nije dostupan u igri.",
                    previewFailed = "Pregled nije mogao da se otvori.",
                    previewRequiresGame = "Otvorite /jobconfig u FiveM-u da vidite objekat.",
                    options = {
                        normal = "Obična mlaznica",
                        hohlstrahlrohr = "EU mlaznica",
                    },
                },
                fireBillingEnabled = {
                    label = "Омогући рачуне",
                    description = "Омогућава ватрогасцима на дужности да издају рачуне преко радијалног менија.",
                },
                fireBillingMode = {
                    label = "Систем рачуна",
                    description = "Koristi provajdera izabranog u Sky Base (podrazumevano Sky) ili lokalnu gotovinsku/kartičnu naplatu.",
                    options = {
                        consent = "Gotovina ili kartica",
                        framework = "Provajder naplate iz Sky Base",
                    },
                },
                fireBillingReasons = {
                    label = "Razlozi računa",
                    description = "Razlozi i cene za izbor. Moguće je kombinovati više razloga.",
                    itemLabel = "Разлог",
                },
                fireBillingRange = {
                    label = "Удаљеност примаоца",
                    description = "Највећа удаљеност у метрима између издаваоца и примаоца.",
                },
                fireBillingMaxAmount = {
                    label = "Највећи износ рачуна",
                    description = "Горња граница по рачуну за интерни и спољни систем.",
                },
                airBottleSlots = {
                    description = "Konfiguriert: Прорези за флаше са компримованим ваздухом.",
                    label = "Прорези за флаше са компримованим ваздухом",
                },
                canSpread = {
                    description = "Дозвољава пожару који је овде покренут да напредује преко Фирејоб система ширења.",
                    label = "Дозвољено ширење пожара",
                },
                connection = {
                    description = "Konfiguriert: веза.",
                    label = "веза",
                },
                customExtinguisherMounts = {
                    description = "Трајни прилагођени носачи са тренутним статусом апарата за гашење пожара и одржавањем.",
                    label = "Постављени држачи за апарате за гашење пожара",
                },
                deckGunSprayGamepadKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Krovni top: drži prskanje",
                },
                deckGunSprayKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Krovni top: drži prskanje",
                },
                drawables = {
                    description = "Konfiguriert: Варијанте.",
                    label = "Варијанте",
                },
                fireBreathingAirEnabled = {
                    description = "Ограничено троши ваздушни притисак док носи заштиту за дисање.",
                    label = "Користите флаширани ваздух",
                },
                fireBreathingCapacitySeconds = {
                    description = "Konfiguriert: Капацитет ваздуха секунди.",
                    label = "Капацитет ваздуха секунди",
                },
                fireBreathingComponents = {
                    description = "Правила компоненти за маску и боцу за ваздух. Варијанте прихватају било који, аниНонДефаулт, број или бројеве одвојене зарезима.",
                    itemLabel = "Компонента",
                    label = "Обавезне компоненте одеће",
                },
                fireBreathingCriticalPercent = {
                    description = "Konfiguriert: Критични проценат ваздуха.",
                    label = "Критични проценат ваздуха",
                },
                fireBreathingHeatConsumption = {
                    description = "Konfiguriert: Потрошња топлоте.",
                    label = "Потрошња топлоте",
                },
                fireBreathingHudUpdateInterval = {
                    description = "Konfiguriert: Интервал освежавања ХУД-а.",
                    label = "Интервал освежавања ХУД-а",
                },
                fireBreathingIdleConsumption = {
                    description = "Konfiguriert: Потрошња у мировању.",
                    label = "Потрошња у мировању",
                },
                fireBreathingItemEnabled = {
                    description = "Захтева конфигурисану ставку инвентара пре него што се може користити заштита за дисање.",
                    label = "Потребна је боца",
                },
                fireBreathingItemName = {
                    description = "Konfiguriert: Назив артикла боце.",
                    label = "Назив артикла боце",
                },
                fireBreathingItemSaveInterval = {
                    description = "Konfiguriert: Интервал складиштења штампе.",
                    label = "Интервал складиштења штампе",
                },
                fireBreathingItemSavePressure = {
                    description = "Konfiguriert: Сачувај метаподатке за штампање.",
                    label = "Сачувај метаподатке за штампање",
                },
                fireBreathingJumpingConsumption = {
                    description = "Konfiguriert: Скок потрошње.",
                    label = "Скок потрошње",
                },
                fireBreathingLowPercent = {
                    description = "Konfiguriert: Низак проценат ваздуха.",
                    label = "Низак проценат ваздуха",
                },
                fireBreathingMaskForceFirstPerson = {
                    description = "Форсира камеру из првог лица док је преклапање маске активно.",
                    label = "Форце фирст персон виев",
                },
                fireBreathingMaskOverlayEnabled = {
                    description = "Приказује преклоп Его маске док је заштита дисања активна.",
                    label = "Прекривање маске",
                },
                fireBreathingPressureBar = {
                    description = "Konfiguriert: Пун притисак бар.",
                    label = "Пун притисак бар",
                },
                fireBreathingProps = {
                    description = "Konfiguriert: Обавезни реквизити.",
                    itemLabel = "Објекат",
                    label = "Обавезни реквизити",
                },
                fireBreathingRefillEnabled = {
                    description = "Захтева ставку боце са метаподацима за штампање. Станице се постављају преко фире едитора.",
                    label = "Активирајте бензинске станице",
                },
                fireBreathingRefillRate = {
                    description = "Konfiguriert: Бар брзине попуњавања у секунди.",
                    label = "Бар брзине попуњавања у секунди",
                },
                fireBreathingRunningConsumption = {
                    description = "Konfiguriert: Текућа потрошња.",
                    label = "Текућа потрошња",
                },
                fireBreathingSmokeConsumption = {
                    description = "Konfiguriert: Потрошња дима.",
                    label = "Потрошња дима",
                },
                fireBreathingSmokeMultiplier = {
                    description = "Изложеност диму која и даље стиже до играча упркос активној респираторној заштити.",
                    label = "Множилац контакта са димом",
                },
                fireBreathingSprintingConsumption = {
                    description = "Konfiguriert: Спринт потрошња.",
                    label = "Спринт потрошња",
                },
                fireBreathingToxicConsumption = {
                    description = "Konfiguriert: Потрошња отрова.",
                    label = "Потрошња отрова",
                },
                fireBreathingToxicMultiplier = {
                    description = "Резервисан глас за излагање токсичности уз активну респираторну заштиту.",
                    label = "Множилац отровног дима",
                },
                fireEditorControl14 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 14",
                },
                fireEditorControl15 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 15",
                },
                fireEditorControl174 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 174",
                },
                fireEditorControl175 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 175",
                },
                fireEditorControl177 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 177",
                },
                fireEditorControl191 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 191",
                },
                fireEditorControl199 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 199",
                },
                fireEditorControl200 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 200",
                },
                fireEditorControl202 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 202",
                },
                fireEditorControl21 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 21",
                },
                fireEditorControl24 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 24",
                },
                fireEditorControl25 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 25",
                },
                fireEditorControl32 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 32",
                },
                fireEditorControl322 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 322",
                },
                fireEditorControl33 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 33",
                },
                fireEditorControl34 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 34",
                },
                fireEditorControl35 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 35",
                },
                fireEditorControl36 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 36",
                },
                fireEditorControl38 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 38",
                },
                fireEditorControl44 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 44",
                },
                fireEditorControl45 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 45",
                },
                fireExtinguishFeedbackAlpha = {
                    description = "Прозирност иконе од 0 до 255.",
                    label = "Јасна непрозирност приказа",
                },
                fireExtinguishFeedbackEnabled = {
                    description = "Приказује икону пламена изнад ватре док се гаси.",
                    label = "Активирај приказ брисања",
                },
                fireExtinguishFeedbackHeight = {
                    description = "Вертикални помак изнад ватре где је симбол нацртан.",
                    label = "Висина обавештења о брисању",
                },
                fireExtinguishFeedbackMaxScale = {
                    description = "Највећа величина иконе када је брисање тек почело.",
                    label = "Максимална величина приказа за брисање",
                },
                fireExtinguishFeedbackMinScale = {
                    description = "Најмања величина иконе када је брисање скоро завршено.",
                    label = "Минимална величина приказа за брисање",
                },
                fireExtinguisherEffectiveness = {
                    description = "Универзални множилац ефикасности апарата за гашење пожара.",
                    label = "Ефикасност апарата за гашење пожара",
                },
                fireExtinguisherEnabled = {
                    description = "Дозвољава ВЕАПОН_ФИРЕЕКСТИНГУИСХЕР-у да угаси било који тип пожара.",
                    label = "Активирајте апарат за гашење пожара",
                },
                fireExtinguisherHitRadius = {
                    description = "Konfiguriert: Радијус удара апарата за гашење пожара.",
                    label = "Радијус удара апарата за гашење пожара",
                },
                fireExtinguisherProgressPerSecond = {
                    description = "Konfiguriert: Брзина гашења ватрогасним апаратом.",
                    label = "Брзина гашења ватрогасним апаратом",
                },
                fireExtinguisherRange = {
                    description = "Konfiguriert: Асортиман апарата за гашење пожара.",
                    label = "Асортиман апарата за гашење пожара",
                },
                fireFemaleBreathingComponents = {
                    description = "Правила компоненти за женску маску и бочицу за ваздух.",
                    itemLabel = "Компонента",
                    label = "Обавезне компоненте одеће",
                },
                fireFemaleBreathingProps = {
                    description = "Konfiguriert: Обавезни реквизити.",
                    itemLabel = "Објекат",
                    label = "Обавезни реквизити",
                },
                fireFemaleHeatComponents = {
                    description = "Правила о компонентама женске одеће за заштиту од топлоте.",
                    itemLabel = "Компонента",
                    label = "Обавезне компоненте одеће",
                },
                fireFemaleHeatProps = {
                    description = "Konfiguriert: Обавезни реквизити.",
                    itemLabel = "Објекат",
                    label = "Обавезни реквизити",
                },
                fireFemaleProtectiveMaskComponents = {
                    description = "Женска правила компоненти која се примењују када је заштитна маска за шумске пожаре опремљена.",
                    itemLabel = "Компонента",
                    label = "Потребне компоненте одеће",
                },
                fireFemaleProtectiveMaskProps = {
                    description = "Konfiguriert: Потребни додаци.",
                    itemLabel = "Додатак",
                    label = "Потребни додаци",
                },
                fireFirstSpreadDelaySeconds = {
                    description = "Минимално време након паљења пре него што се дозволи ширење пожара.",
                    label = "Одлагање до првог ширења",
                },
                fireFlameScaleMultiplier = {
                    description = "Vizuelna veličina plamena. 1 je normalna veličina; važi za aktivne požare bez promene težine gašenja.",
                    label = "Množilac veličine plamena",
                },
                fireGearEnabled = {
                    description = "Укључује или искључује проверу одеће, заштите респираторних органа и топлотне заштите.",
                    label = "Активирајте заштитну одећу",
                },
                fireHeatBurnDurationMultiplier = {
                    description = "Konfiguriert: Множилац трајања снимања.",
                    label = "Множилац трајања снимања",
                },
                fireHeatComponents = {
                    description = "Правила о компонентама заштитне одеће. Варијанте прихватају било који, аниНонДефаулт, број или бројеве одвојене зарезима.",
                    itemLabel = "Компонента",
                    label = "Обавезне компоненте одеће",
                },
                fireHeatIgnite = {
                    description = "Konfiguriert: Може да се запали упркос заштити.",
                    label = "Може да се запали упркос заштити",
                },
                fireHeatProps = {
                    description = "Konfiguriert: Обавезни реквизити.",
                    itemLabel = "Објекат",
                    label = "Обавезни реквизити",
                },
                fireHeatResistancePercent = {
                    description = "Једноставна заштитна снага за комплетну ватрогасну одећу. 0 значи да нема смањења, 100 значи да нема директне штете од пожара.",
                    label = "Проценат отпорности на топлоту",
                },
                fireHeatStressBurnLevel = {
                    description = "Konfiguriert: Фаза сагоревања.",
                    label = "Фаза сагоревања",
                },
                fireHeatStressDamageInterval = {
                    description = "Konfiguriert: Интервал топлотних оштећења.",
                    label = "Интервал топлотних оштећења",
                },
                fireHeatStressDirectFlameDistance = {
                    description = "Konfiguriert: Директна удаљеност пламена.",
                    label = "Директна удаљеност пламена",
                },
                fireHeatStressEnabled = {
                    description = "Konfiguriert: Активирајте топлотни стрес.",
                    label = "Активирајте топлотни стрес",
                },
                fireHeatStressExposurePower = {
                    description = "Више вредности успоравају накупљање топлоте када је играч близу ватре, али не директно у њој.",
                    label = "Крива топлотне удаљености",
                },
                fireHeatStressFullHeatDistance = {
                    description = "Konfiguriert: Пуна топлотна удаљеност.",
                    label = "Пуна топлотна удаљеност",
                },
                fireHeatStressInitialGainMultiplier = {
                    description = "Множилац док је температура језгра још ниска.",
                    label = "Почетни множилац топлотног добитка",
                },
                fireHeatStressMaxDistance = {
                    description = "Konfiguriert: Максимална удаљеност топлотног стреса.",
                    label = "Максимална удаљеност топлотног стреса",
                },
                fireHeatStressProgressionPower = {
                    description = "Више вредности задржавају рани успон споријим и омогућавају му да јаче ескалира касније.",
                    label = "Крива топлоте",
                },
                fireHeatStressProtectedDamage = {
                    description = "Konfiguriert: Процењена штета.",
                    label = "Процењена штета",
                },
                fireHeatStressProtectedDamageLevel = {
                    description = "Konfiguriert: Процењени ниво штете.",
                    label = "Процењени ниво штете",
                },
                fireHeatStressProtectedDecay = {
                    description = "Konfiguriert: Процењено рударење.",
                    label = "Процењено рударење",
                },
                fireHeatStressProtectedDirectFlameDistance = {
                    description = "Konfiguriert: Процењена директна удаљеност пламена.",
                    label = "Процењена директна удаљеност пламена",
                },
                fireHeatStressProtectedGain = {
                    description = "Konfiguriert: Процењени добитак топлоте.",
                    label = "Процењени добитак топлоте",
                },
                fireHeatStressUnprotectedDamage = {
                    description = "Konfiguriert: Непроцењена штета.",
                    label = "Непроцењена штета",
                },
                fireHeatStressUnprotectedDamageLevel = {
                    description = "Konfiguriert: Непроцењени ниво штете.",
                    label = "Непроцењени ниво штете",
                },
                fireHeatStressUnprotectedDecay = {
                    description = "Konfiguriert: Непроцењено рударење.",
                    label = "Непроцењено рударење",
                },
                fireHeatStressUnprotectedDirectFlameDistance = {
                    description = "Konfiguriert: Непроцењена директна удаљеност пламена.",
                    label = "Непроцењена директна удаљеност пламена",
                },
                fireHeatStressUnprotectedGain = {
                    description = "Konfiguriert: Непроцењени добитак топлоте.",
                    label = "Непроцењени добитак топлоте",
                },
                fireIgnitionGrowthSeconds = {
                    description = "Sekunde potrebne novom požaru iz menija da dostigne punu veličinu. Važi za nove požare.",
                    label = "Trajanje početnog rasta",
                },
                fireIgnitionStartScale = {
                    description = "Početna veličina plamena u meniju. Vrednosti ispod 1 rastu do pune veličine profila.",
                    label = "Početna veličina u meniju",
                },
                fireInteriorExtinguishersControl38 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Zidni aparat za gašenje · Kontrola 38",
                },
                fireMaxFlameSources = {
                    description = "Zajedničko ograničenje svih požara po klijentu. Bliži plamen ima prednost; niža ograničenja ostavljaju više kapaciteta za čestice vodenih mlazeva.",
                    label = "Maksimalan broj vidljivih izvora plamena",
                },
                fireMaxFlamesPerFire = {
                    description = "Максималан број пламена који једна ватра може да садржи.",
                    label = "Максимални пламен по пожару",
                },
                fireMaxSmokeSources = {
                    description = "Zajedničko ograničenje stubova dima i čestica dima u enterijeru po klijentu. Bliži izvori imaju prednost.",
                    label = "Maksimalan broj vidljivih izvora dima",
                },
                fireMaxSpreadDistance = {
                    description = "Највећа удаљеност од постојећег пламена на којој се може појавити нови пламен.",
                    label = "Максимална удаљеност ширења",
                },
                fireMinSpreadDistance = {
                    description = "Најкраћа удаљеност до постојећег пламена на којој се може појавити нови пламен.",
                    label = "Минимална удаљеност ширења",
                },
                fireNozzleProgressPerSecond = {
                    description = "Напредак гашења који вода производи у секунди.",
                    label = "Брзина гашења млазне цеви",
                },
                fireNozzleRange = {
                    description = "Максимална удаљеност са које млазна цев може да погоди ватру.",
                    label = "Домет гашења млазне цеви",
                },
                firePropIgnitionControl177 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Paljenje predmeta · Kontrola 177",
                },
                firePropIgnitionControl38 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Paljenje predmeta · Kontrola 38",
                },
                fireProtectiveMaskComponents = {
                    description = "Правила компоненти која се примењују када је заштитна маска за шумске пожаре опремљена.",
                    itemLabel = "Компонента",
                    label = "Потребне компоненте одеће",
                },
                fireProtectiveMaskEnabled = {
                    description = "Омогућава вишекратну филтер маску за дим шумских пожара без боце са ваздухом.",
                    label = "Омогући заштитну маску",
                },
                fireProtectiveMaskForceFirstPerson = {
                    description = "Приморава камеру у прво лице док је приказ заштитне маске активан.",
                    label = "Принудно прво лице",
                },
                fireProtectiveMaskItemEnabled = {
                    description = "Захтева конфигурисани предмет инвентара пре употребе заштитне маске.",
                    label = "Захтевај предмет заштитне маске",
                },
                fireProtectiveMaskItemName = {
                    description = "Konfiguriert: Назив предмета заштитне маске.",
                    label = "Назив предмета заштитне маске",
                },
                fireProtectiveMaskOverlayEnabled = {
                    description = "Приказује маску у првом лицу док је заштитна маска активна.",
                    label = "Приказ маске",
                },
                fireProtectiveMaskProps = {
                    description = "Konfiguriert: Потребни додаци.",
                    itemLabel = "Додатак",
                    label = "Потребни додаци",
                },
                fireProtectiveMaskSmokeMultiplier = {
                    description = "Изложеност диму која и даље стиже до играча док је заштитна маска активна.",
                    label = "Множилац изложености диму",
                },
                fireProtectiveMaskToxicMultiplier = {
                    description = "Токсична изложеност која и даље стиже до играча. Веће вредности захтевају СЦБА за опасан дим.",
                    label = "Множилац изложености токсичном диму",
                },
                fireRainEnabled = {
                    description = "Дозвољава киши да утиче на пожаре на отвореном.",
                    label = "Омогући ефекте кише",
                },
                fireRainFlameScale = {
                    description = "Оптичка величина пламена при пуном интензитету кише.",
                    label = "Величина пламена на киши",
                },
                fireRainLargeFireSpreadMultiplier = {
                    description = "Ширење великих спољашњих пожара са пуним интензитетом кише.",
                    label = "Множилац ширења великих пожара",
                },
                fireRainMinimumIntensity = {
                    description = "Вредности кише испод овог прага немају ефекта.",
                    label = "Минимални интензитет кише",
                },
                fireRainSmallFireMaxFlames = {
                    description = "Ватре на отвореном са до овог броја пламена могу се угасити кишом.",
                    label = "Максимални пламен за мале пожаре",
                },
                fireRainSmallFireProgressPerSecond = {
                    description = "Напредак гашења због кише у секунди при пуном интензитету времена.",
                    label = "Брзина гашења малих пожара",
                },
                fireRainSmokeScale = {
                    description = "Оптичка величина дима при пуном интензитету кише.",
                    label = "Величина дима током кише",
                },
                fireRainWeatherIntensity = {
                    description = "Ефекат кише по типу времена ГТА од 0.0 до 1.0.",
                    itemLabel = "Време",
                    label = "Интензитет времена",
                },
                fireReignitionChancePercent = {
                    description = "Проценат шансе се окреће сваки пут када се запаљиви пламен угаси.",
                    label = "Проценат шансе за поновно оживљавање",
                },
                fireReignitionDelaySeconds = {
                    description = "секунди између гашења и повратка малог пламена.",
                    label = "Секунди кашњења поновног појављивања",
                },
                fireReignitionEnabled = {
                    description = "Омогућава да се угашени запаљиви пламенови поново запале након кратког одлагања.",
                    label = "Енабле Ресургенце",
                },
                fireReignitionExtinguishRequiredPercent = {
                    description = "Проценат нормалног напредовања гашења, након чега се поново запаљени пламен коначно гаси.",
                    label = "Коначно изашао након поновног појављивања",
                },
                fireReignitionFinalExtinguishHoldSeconds = {
                    description = "Секунди, које се морају даље угасити након што је гашење завршено пре него што се пламен који је поново распламсао коначно угаси.",
                    label = "Време чекања завршног прекида",
                },
                fireReignitionGrowthPerSecond = {
                    description = "Колико скалирања поново запаљени пламен добија у секунди док не достигне пуну величину.",
                    label = "Раст у секунди",
                },
                fireReignitionNearImpactAccuracy = {
                    description = "Прецизност гашења се користи када је само удар близу поново запаљеног мини-пламена.",
                    label = "Прецизност близу удара",
                },
                fireReignitionNearImpactTolerance = {
                    description = "Додатни метри око поново запаљеног мини-пламена, у којем се скоро исти ударац и даље рачуна као погодак.",
                    label = "Толеранција блиског удара",
                },
                fireReignitionStartScale = {
                    description = "Множитељ скалирања са којим се пламен поново покреће.",
                    label = "Почетна величина пламена",
                },
                fireRenderDistance = {
                    description = "Уобичајена максимална видљивост за пламен и дим.",
                    label = "Опсег видљивости ватре и дима",
                },
                fireSmokeDensityMultiplier = {
                    description = "Množi vidljivu neprozirnost dima: 0 skriva dim, 1 je normalno, a 2 povećava neprozirnost do dozvoljene granice. Šteta od dima ostaje ista.",
                    label = "Množilac gustine dima",
                },
                fireSmokeScaleMultiplier = {
                    description = "Vizuelna veličina stubova dima koji se podižu. 1 je normalna veličina; važi za aktivan dim.",
                    label = "Množilac veličine dima",
                },
                fireSmokeWindResponse = {
                    description = "Koliko snažno priloženi dim prati vremenski vetar. Promena profila ponovo stvara stubove dima.",
                    label = "Uticaj vetra na dim",
                    options = {
                        gentle = "Blag",
                        none = "Bez uticaja vetra",
                        normal = "Normalan",
                        strong = "Jak",
                    },
                },
                fireSoundChainsawEnabled = {
                    description = "Репродукује звук моторне тестере у 3Д док играч тестерише дрво.",
                    label = "Активирај моторну тестеру",
                },
                fireSoundChainsawRange = {
                    description = "Удаљеност у метрима на којој играчи могу да чују моторну тестеру.",
                    label = "Асортиман моторних тестера",
                },
                fireSoundChainsawVolume = {
                    description = "Максимална јачина звука 3Д моторне тестере.",
                    label = "Волумен моторне тестере",
                },
                fireSoundFireAmbientEnabled = {
                    description = "Reprodukuje prostorne zvuke vatre prema vrsti požara.",
                    label = "Омогући амбијентални звук ватре",
                },
                fireSoundFireAmbientRange = {
                    description = "Удаљеност у метрима на којој играчи могу чути активну ватру.",
                    label = "Опсег пожарног окружења",
                },
                fireSoundFireAmbientVolume = {
                    description = "Ukupna jačina prostornih zvukova vatre: 0 = bez zvuka, 1 = puna jačina. Izmene važe i za aktivne požare.",
                    label = "Обим заштите од пожара",
                },
                fireSoundFireFlareEnabled = {
                    description = "Репродуцира кратки звук за време реакције воде.",
                    label = "Омогући бљесак звук",
                },
                fireSoundFireFlareRange = {
                    description = "Удаљеност у метрима на којој играчи могу да чују звуке бакљи при реакцији воде.",
                    label = "Опсег бљештавог звука",
                },
                fireSoundFireFlareVolume = {
                    description = "Максимална јачина звука водене реакције.",
                    label = "Јачина звука фларе",
                },
                fireSpreadAttemptsPerTick = {
                    description = "Број могућих позиција пропагације проверених при сваком ажурирању.",
                    label = "покушаја ширења по ажурирању",
                },
                fireSpreadEnabled = {
                    description = "Дозвољава активној ватри да створи додатни пламен на запаљивим површинама.",
                    label = "Активирајте ширење ватре",
                },
                fireSpreadIntervalSeconds = {
                    description = "Основни интервал између тестова размножавања. Мање вредности чешће проверавају ширење.",
                    label = "Интервал пропагације секунди",
                },
                fireThirstEnabled = {
                    description = "Повећава потрошњу жеђи док је играч изложен топлоти ватре.",
                    label = "Активирајте повећану жеђ",
                },
                fireThirstMinimumBaseLossPerMinute = {
                    description = "Минимални губитак жеђи као основа за множење када је оквирна стопа премала да би се приметила.",
                    label = "Минимални основни губитак по минуту",
                },
                fireThirstMultiplier = {
                    description = "Умножава нормалан губитак жеђи у врелини ватре.",
                    label = "Множилац жеђи",
                },
                fireThirstUpdateInterval = {
                    description = "Време између упита о статусу оквира када се пожар наставља.",
                    label = "Интервал провере статуса мс",
                },
                fireType = {
                    description = "Одређује који Фирејоб профил пожара се користи на овој тачки паљења.",
                    label = "Врста извора пожара",
                },
                fireWaterMonitorControl172 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Vodeni top · Kontrola 172",
                },
                fireWaterMonitorControl173 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Vodeni top · Kontrola 173",
                },
                fireWaterMonitorControl174 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Vodeni top · Kontrola 174",
                },
                fireWaterMonitorControl175 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Vodeni top · Kontrola 175",
                },
                fireWaterMonitorControl177 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Vodeni top · Kontrola 177",
                },
                fireWaterMonitorControl202 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Vodeni top · Kontrola 202",
                },
                fireWaterMonitorControl24 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Vodeni top · Kontrola 24",
                },
                fireWaterMonitorControl241 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Vodeni top · Kontrola 241",
                },
                fireWaterMonitorControl242 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Vodeni top · Kontrola 242",
                },
                fireWaterMonitorControl25 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Vodeni top · Kontrola 25",
                },
                firetruckHudCursorKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "HUD vatrogasnog vozila: drži interakciju mišem",
                },
                firetruckHudToggleKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uključi/isključi HUD vatrogasnog vozila",
                },
                firetruckWaterCannonEnabled = {
                    description = "Омогућава уграђеним воденим топовима на подржаним возилима за гашење пожара.",
                    label = "Активирајте водени топ возила",
                },
                firetruckWaterCannonMinRange = {
                    description = "Најкраћа могућа удаљеност топа фиксног возила, јер не може да циља потпуно надоле.",
                    label = "Минимални домет водених топова",
                },
                firetruckWaterCannonModels = {
                    description = "Један ред по топу. Поновите модел за кровни и предњи топ, са јединственим ИД-ом за тај модел и одговарајућом кости цеви. Постојећи уноси користе deckGun. Сваки топ захтева јединствен ИД у оквиру модела (1-48 латиничних слова без дијакритика, цифара, доњих црта или цртица).",
                    itemLabel = "Водени топ",
                    label = "Водени топови возила",
                },
                firetruckWaterCannonProgressPerSecond = {
                    description = "Напредак у чишћењу водених топова возила у секунди.",
                    label = "Брзина чишћења водених топова",
                },
                foamTankEnabled = {
                    description = "Konfiguriert: Резервоар за пену.",
                    label = "Резервоар за пену",
                },
                foamTankSize = {
                    description = "Konfiguriert: литара пене.",
                    label = "литара пене",
                },
                gearKey = {
                    options = {
                        helmet = "Кацига",
                        mask = "Маска",
                        other = "Остало (без заштите)",
                        pants = "Панталоне",
                        shoes = "Ципеле",
                        top = "Топ",
                    },
                },
                heatLevelHudPosition = {
                    description = "Локација ХУД приказа топлотног стреса.",
                    label = "Локација индикатора топлотног стреса",
                },
                heliBucketAllowedJobs = {
                    description = "Оставите празно да бисте дозволили све послове конфигурисане у овом Фирејоб-у.",
                    itemLabel = "Посао",
                    label = "Дозвољени послови",
                },
                heliBucketAttachDistance = {
                    description = "Максимално растојање између тачке причвршћивања на хеликоптеру и контејнера.",
                    label = "Максимална монтажна удаљеност",
                },
                heliBucketAttachKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Zakači/otkači korpu helikoptera",
                },
                heliBucketAutoAttachOnGround = {
                    description = "Аутоматски причвршћује оближњи контејнер на земљу када је хеликоптер у домету.",
                    label = "Аутоматски причврсти конопац за земљу",
                },
                heliBucketBucketOffsetX = {
                    description = "Локални Кс положај где је конопац причвршћен за контејнер.",
                    label = "Помак ужета контејнера Кс",
                },
                heliBucketBucketOffsetY = {
                    description = "Локални И положај где је конопац причвршћен за контејнер.",
                    label = "Помак ужета контејнера И",
                },
                heliBucketBucketOffsetZ = {
                    description = "Локални З положај где је конопац причвршћен за контејнер.",
                    label = "Помак ужета контејнера З",
                },
                heliBucketCommand = {
                    description = "Име команде без косе црте, на пример ватербуцкет.",
                    label = "команда",
                },
                heliBucketCommandEnabled = {
                    description = "Омогућава постављање посуде са ватрогасном водом без предмета преко команде.",
                    label = "Омогући коришћење команди",
                },
                heliBucketConsumeItem = {
                    description = "Уклања конфигурисану ставку након успешног постављања.",
                    label = "Потроши предмет када се постави",
                },
                heliBucketDetachMaxGroundDistance = {
                    description = "Максимална висина контејнера изнад земље на којој је уклањање дозвољено.",
                    label = "Максимална висина прихвата",
                },
                heliBucketDumpEnabled = {
                    description = "Омогућава да се ускладиштена вода испразни из контејнера.",
                    label = "Активирајте испуштање воде",
                },
                heliBucketDumpHitRadius = {
                    description = "Радијус око падајућег воденог стуба у коме се могу погодити пожари.",
                    label = "Радијус удара",
                },
                heliBucketDumpJetScale = {
                    description = "Визуелна величина главног воденог млаза испод посуде.",
                    label = "Скалирање снопа",
                },
                heliBucketDumpKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Ispusti vodu iz korpe helikoptera",
                },
                heliBucketDumpLitersPerSecond = {
                    description = "Количина ускладиштене воде која се ослобађа у секунди када се испусти.",
                    label = "испуштање литара у секунди",
                },
                heliBucketDumpProgressPerSecond = {
                    description = "Основна снага при гашењу пожара унутар воденог стуба.",
                    label = "Напредак брисања у секунди",
                },
                heliBucketDumpRayLength = {
                    description = "Максимално растојање надоле за тражење пожара испод контејнера.",
                    label = "Дужина теста",
                },
                heliBucketDumpSprayScale = {
                    description = "Визуелна величина ефекта широког спреја испод контејнера.",
                    label = "Скалирање у спреју",
                },
                heliBucketEnabled = {
                    description = "Омогућава постављање, причвршћивање хеликоптера, пуњење и испуштање воде у контејнер.",
                    label = "Активирајте резервоар за воду за пожар",
                },
                heliBucketGroundAttachDistance = {
                    description = "Максимална висина контејнера изнад земље за аутоматско причвршћивање.",
                    label = "Размак од тла за причвршћивање",
                },
                heliBucketHelicopterOffsets = {
                    description = "Положај причвршћивања ужета по моделу хеликоптера; подразумевано се користи као подразумевано.",
                    itemLabel = "Оффсет",
                    label = "Оффсет хеликоптерског ужета",
                },
                heliBucketHelicopters = {
                    description = "Модели хеликоптера којима је дозвољено да причврсте резервоар за воду за пожар.",
                    itemLabel = "Хеликоптер",
                    label = "Дозвољени модели хеликоптера",
                },
                heliBucketItem = {
                    description = "Инвентар за постављање посуде са ватрогасном водом.",
                    label = "Назив артикла",
                },
                heliBucketItemEnabled = {
                    description = "Омогућава постављање посуде са ватрогасном водом са конфигурисаним предметом инвентара.",
                    label = "Омогући коришћење ставке",
                },
                heliBucketLabel = {
                    description = "Име које се појављује у интеракцијама и обавештењима.",
                    label = "Приказано име",
                },
                heliBucketModel = {
                    description = "Модел подупирача креиран за резервоар за воду за пожар.",
                    label = "Модел реквизита контејнера",
                },
                heliBucketMovingStreamDistance = {
                    description = "Максимална удаљеност синхронизације док је контејнер причвршћен и померен.",
                    label = "Стреаминг Дистанце ин Мотион",
                },
                heliBucketPickupDistance = {
                    description = "Максимално растојање са које се може подићи неповезани контејнер са ватрогасном водом.",
                    label = "Даљина гађања",
                },
                heliBucketRequireOnDuty = {
                    description = "Дозвољава коришћење само члановима дозвољеног посла који су на дужности.",
                    label = "Потребна услуга",
                },
                heliBucketRequirePilot = {
                    description = "Играч мора седети на пилотском седишту хеликоптера да би контролисао контејнер.",
                    label = "Потребно пилотско седиште",
                },
                heliBucketReturnItemOnRemove = {
                    description = "Враћа конфигурисану ставку када подигнете посуду за воду за гашење.",
                    label = "Вратите предмет приликом преузимања",
                },
                heliBucketRopeLength = {
                    description = "Дужина ужета између хеликоптера и резервоара за воду за пожар.",
                    label = "Дужина ужета",
                },
                heliBucketRopeType = {
                    description = "ИД типа ГТА ужета за повезивање контејнера.",
                    label = "Тип ужета",
                },
                heliBucketStreamDistance = {
                    description = "Максимално растојање синхронизације док резервоар за воду за пожар мирује.",
                    label = "Стреаминг Дистанце",
                },
                heliBucketWaterCapacityLiters = {
                    description = "Максимална количина воде коју контејнер може да задржи.",
                    label = "Капацитет у литрима",
                },
                heliBucketWaterCheckIntervalMs = {
                    description = "Интервал у милисекундама између провере да ли је контејнер потопљен.",
                    label = "Интервал испитивања воде мс",
                },
                heliBucketWaterEnabled = {
                    description = "Омогућава резервоару за воду да апсорбује воду када је потопљен.",
                    label = "Омогући апсорпцију воде",
                },
                heliBucketWaterFillRateLitersPerSecond = {
                    description = "Количина воде која се додаје у секунди док је контејнер потопљен.",
                    label = "Брзина пуњења литара у секунди",
                },
                heliBucketZOffset = {
                    description = "Вертикална корекција приликом постављања подупирача контејнера на тло.",
                    label = "Помак од земље З",
                },
                hoseAddPointDistance = {
                    description = "Удаљеност кретања након које се додаје још једна тачка црева.",
                    label = "Удаљеност за нове поене",
                },
                hoseDeployDistance = {
                    description = "Максимална удаљеност од возила на којој се црево може испуштати.",
                    label = "Излазна удаљеност",
                },
                hoseFoamLitersPerSecond = {
                    description = "Потрошња резервоара за пену приликом прскања пене.",
                    label = "литара пене у секунди",
                },
                hoseFoamRefillAnimDict = {
                    description = "Konfiguriert: Аним Дицт за пуњење пене.",
                    label = "Аним Дицт за пуњење пене",
                },
                hoseFoamRefillAnimFlag = {
                    description = "Konfiguriert: Анимска застава за пуњење пене.",
                    label = "Анимска застава за пуњење пене",
                },
                hoseFoamRefillAnimName = {
                    description = "Konfiguriert: Име Аним за пуњење пене.",
                    label = "Име Аним за пуњење пене",
                },
                hoseFoamRefillBone = {
                    description = "Konfiguriert: Пенаста кост за пуњење.",
                    label = "Пенаста кост за пуњење",
                },
                hoseFoamRefillDistance = {
                    description = "Максимално растојање до возила током пуњења.",
                    label = "Удаљеност пуњења пеном",
                },
                hoseFoamRefillDurationMs = {
                    description = "Трајање траке тока за операцију пуњења.",
                    label = "Трајање пуњења пеном мс",
                },
                hoseFoamRefillEnabled = {
                    description = "Омогућава пуњење резервоара за пену у возилу са предметом инвентара.",
                    label = "Активирајте пуњење пене",
                },
                hoseFoamRefillItem = {
                    description = "Ставка инвентара потребна за пуњење резервоара за пену.",
                    label = "Ставка за пуњење пене",
                },
                hoseFoamRefillLiters = {
                    description = "Колико литара пене канистер додаје у резервоар возила.",
                    label = "Литара за пуњење пене",
                },
                hoseFoamRefillOffsetRx = {
                    description = "Konfiguriert: Ротација пуњења пеном Кс.",
                    label = "Ротација пуњења пеном Кс",
                },
                hoseFoamRefillOffsetRy = {
                    description = "Konfiguriert: Ротација пуњења пеном И.",
                    label = "Ротација пуњења пеном И",
                },
                hoseFoamRefillOffsetRz = {
                    description = "Konfiguriert: Ротација пуњења пеном З.",
                    label = "Ротација пуњења пеном З",
                },
                hoseFoamRefillOffsetX = {
                    description = "Konfiguriert: Помак пуњења пене Кс.",
                    label = "Помак пуњења пене Кс",
                },
                hoseFoamRefillOffsetY = {
                    description = "Konfiguriert: Помак пуњења пене И.",
                    label = "Помак пуњења пене И",
                },
                hoseFoamRefillOffsetZ = {
                    description = "Konfiguriert: Помак пуњења пене З.",
                    label = "Помак пуњења пене З",
                },
                hoseFoamRefillProp = {
                    description = "Реквизит приказан у руци током пуњења.",
                    label = "Проп за пуњење пене",
                },
                hoseFoamRefillRequireOnDuty = {
                    description = "Konfiguriert: Потребна је услуга пуњења пеном.",
                    label = "Потребна је услуга пуњења пеном",
                },
                hoseFoamWaterLitersPerSecond = {
                    description = "Потрошња резервоара за воду при прскању пене без спољног довода.",
                    label = "Литара воде од пене у секунди",
                },
                hoseGroundActionAnimationDict = {
                    description = "Konfiguriert: Речник анимације.",
                    label = "Речник анимације",
                },
                hoseGroundActionAnimationDurationMs = {
                    description = "Укупно трајање анимације у милисекундама.",
                    label = "Трајање анимације",
                },
                hoseGroundActionAnimationEnabled = {
                    description = "Репродукује анимацију приликом постављања и подизања цеви за напад.",
                    label = "Омогући руковање анимацијом",
                },
                hoseGroundActionAnimationFlag = {
                    description = "Konfiguriert: Застава анимације.",
                    label = "Застава анимације",
                },
                hoseGroundActionAnimationLayDownName = {
                    description = "Konfiguriert: Одбаци анимацију.",
                    label = "Одбаци анимацију",
                },
                hoseGroundActionAnimationPickUpName = {
                    description = "Konfiguriert: Анимација преузимања.",
                    label = "Анимација преузимања",
                },
                hoseGroundActionAnimationTransitionMs = {
                    description = "Време у милисекундама у коме се млазница за прскање пребацује између руке и земље.",
                    label = "Време промене објекта",
                },
                hoseGroundOffset = {
                    description = "Вертикални помак за нове тачке црева на тлу.",
                    label = "Доњи помак црева",
                },
                hoseGroundedNozzleHeadingOffset = {
                    description = "Корекција угла скретања је додата у линију вида играча када се испусти.",
                    label = "Смерни помак млазне цеви",
                },
                hoseGroundedNozzleOffset = {
                    description = "Вертикална корекција испуштеног оружја након постављања на тло. Негативне вредности их снижавају.",
                    label = "Доњи помак млазне цеви",
                },
                hoseGroundedNozzlePitch = {
                    description = "Угао нагиба са којим се млазно копље поставља равно на под.",
                    label = "Нагиб депоноване млазне цеви",
                },
                hoseGroundedNozzleRoll = {
                    description = "Корекција котрљања за ускладиштени модел млазне цеви.",
                    label = "Угао котрљања депоноване млазне цеви",
                },
                hoseHydrantConnectDistance = {
                    description = "Максимално растојање до хидрантског објекта при повезивању доводне линије.",
                    label = "Удаљеност прикључка хидранта",
                },
                hoseHydrants = {
                    description = "Модели објеката који се препознају као хидранти за прикључке црева и на мапи.",
                    itemLabel = "Хидрант",
                    label = "Модели хидрантских објеката",
                },
                hoseMaxLength = {
                    description = "Максимална дужина црева у метрима пре одвајања млазне цеви.",
                    label = "Максимална дужина црева",
                },
                hoseNozzleBendDistance = {
                    description = "Растојање за формирање кривине црева иза млазног копља.",
                    label = "Растојање савијања блиставе цеви",
                },
                hoseNozzleExitDirectionX = {
                    description = "Локални Кс смер у коме црево напушта млазну цев.",
                    label = "излазни правац Кс",
                },
                hoseNozzleExitDirectionY = {
                    description = "Локални И смер у коме црево напушта млазну цев.",
                    label = "смер излаза И",
                },
                hoseNozzleExitDirectionZ = {
                    description = "Локални З правац у коме црево напушта млазну цев.",
                    label = "излазни правац З",
                },
                hoseNozzleExitLength = {
                    description = "Равна дужина црева на млазној цеви пре прве кривине.",
                    label = "Дужина излаза цеви за зрачење",
                },
                hoseNozzleOffsetX = {
                    description = "Кс помак прикључка црева на оружју млазне цеви.",
                    label = "Помак радијантне цеви Кс",
                },
                hoseNozzleOffsetY = {
                    description = "И помак прикључка црева на оружју млазне цеви.",
                    label = "Помак радијантне цеви И",
                },
                hoseNozzleOffsetZ = {
                    description = "З помак прикључка црева на оружју млазне цеви.",
                    label = "Радиант цеви оффсет З",
                },
                hoseDividing = {
                    description = "Uključuje prenosivi trokraki razdelnik sa zasebnim ventilima i protokom vode. Podrazumevano isključeno.",
                    label = "Razdelnik creva",
                },
                hosePerformanceMode = {
                    description = "Хигх Енд даје приоритет најглаткијем кретању црева. Перформансе смањују ажурирања и оптерећење клијента.",
                    label = "Режим перформанси црева",
                    options = {
                        high_end = "Хигх Енд",
                        performance = "Перформансе",
                    },
                },
                hosePropBaseLength = {
                    description = "Оригинална дужина модела сегмента црева пре скалирања.",
                    label = "Дужина основе подупирача",
                },
                hosePropBaseRadius = {
                    description = "Оригинални радијус модела сегмента цеви пре скалирања.",
                    label = "Радијус основе",
                },
                hosePropLengthRatio = {
                    description = "Корекција дужине приликом скалирања модела сегмента црева.",
                    label = "Проп однос ширина/висина",
                },
                hosePropRoll = {
                    description = "Корекција котрљања модела сегмента црева у степенима.",
                    label = "Угао котрљања подупирача",
                },
                hosePropsEnabled = {
                    description = "Појављује видљиве сегменте црева док је млазно копље у употреби. Водови хидранта остају видљиви чак и када су деактивирани.",
                    label = "Означите видљиве реквизите за црево",
                },
                hosePumpConnectDistance = {
                    description = "Растојање које се проверава када би пумпа требало да усисава воду из околине.",
                    label = "Удаљеност прикључка пумпе",
                },
                hosePumpControlIdlePressure = {
                    description = "Притисак са којим почиње нова контрола пумпе.",
                    label = "Почетни притисак",
                },
                hosePumpControlIdleRpm = {
                    description = "Приказана брзина мотора пумпе при најнижем притиску.",
                    label = "Број обртаја у празном ходу",
                },
                hosePumpControlMaxPressure = {
                    description = "Највећи притисак подесив на продуженом панелу пумпе.",
                    label = "Максимални притисак",
                },
                hosePumpControlMaxRpm = {
                    description = "Приказана брзина мотора пумпе при максималном притиску.",
                    label = "Максимална брзина",
                },
                hosePumpControlMinPressure = {
                    description = "Минимални притисак у ПСИ при којем излаз може да испоручи воду.",
                    label = "Минимални притисак",
                },
                hosePumpControlPresetPressure = {
                    description = "Унапред подешени притисак дугмета и нормална референца протока.",
                    label = "Унапред подешени притисак",
                },
                hosePumpControlPressureStep = {
                    description = "ПСИ који једним притиском на тастер додаје или уклања.",
                    label = "Корак штампања",
                },
                hosePumpControlTankFillLitersPerSecond = {
                    description = "Количина воде која тече у резервоар возила у секунди када се резервоар активно пуни.",
                    label = "Литара за пуњење резервоара/Sekunde",
                },
                hosePumpEnabled = {
                    description = "Омогућава усисавање из признатих природних извора воде.",
                    label = "Активирајте преносиву пумпу",
                },
                hosePumpIntakeExtraLength = {
                    description = "Додатна дужина усисног црева у детектовану површину воде.",
                    label = "Додатна дужина усисавања",
                },
                hosePumpIntakeSubmergeDepth = {
                    description = "Дубина крајње тачке усисног црева испод детектоване површине воде.",
                    label = "Дубина урањања усисног црева",
                },
                hosePumpItem = {
                    description = "Ставка инвентара која се користи за директно постављање преносиве пумпе.",
                    label = "Назив ставке пумпе",
                },
                hosePumpItemEnabled = {
                    description = "Региструје конфигурисану ставку пумпе тако да њено коришћење започне постављање.",
                    label = "Омогући коришћење ставке пумпе",
                },
                hosePumpItemRequired = {
                    description = "Играчи морају имати конфигурисану ставку пумпе пре него што започну снабдевање пумпом.",
                    label = "Потребан је ставка за пумпу",
                },
                hosePumpModel = {
                    description = "Предмет настао као преносива усисна пумпа.",
                    label = "Објектни модел пумпе",
                },
                hosePumpNaturalWaterEnabled = {
                    description = "Омогућава преносној пумпи да црпи воду из река, језера и других откривених водних тела.",
                    label = "Омогући екстракцију природне воде",
                },
                hosePumpPanelStyle = {
                    description = "Једноставно користи аутоматску контролу пумпе са једним улазом и једним излазом. Адванцед омогућава ручне контроле са до два улаза и четири излаза.",
                    label = "Панел пумпе",
                    options = {
                        enhanced = "Адванцед Панел",
                        simple = "Једноставан панел",
                    },
                },
                hosePumpTargetDistance = {
                    description = "Максимална удаљеност играча до конфигурисаног циља порта за пумпу.",
                    label = "Циљна удаљеност интеракције",
                },
                hosePumpTargetSize = {
                    description = "Радијус сваке циљне тачке на прикључку пумпе.",
                    label = "Радијус циљне тачке",
                },
                hosePumpWaterProbeDepth = {
                    description = "Колико далеко испод сваке контролне тачке треба тражити воду.",
                    label = "Дубина испитивања воде пумпе",
                },
                hosePumpWaterProbeDistance = {
                    description = "Колико далеко око тачке постављања пумпе за тражење воде.",
                    label = "Испитна удаљеност пумпе за воду",
                },
                hoseRadius = {
                    description = "Приказани полупречник сегмената црева.",
                    label = "Радијус црева",
                },
                hoseRelaxPasses = {
                    description = "Број пролаза ограничења за изглађивање цеви по ажурирању.",
                    label = "Углађивање пролази",
                },
                hoseSegmentLength = {
                    description = "Циљно растојање између симулираних тачака црева.",
                    label = "Дужина сегмента",
                },
                hoseSegmentOverlap = {
                    description = "Видљиво преклапање суседних подупирача црева да се сакрију празнине.",
                    label = "Преклапање сегмената",
                },
                hoseSegmentProp = {
                    description = "Модел који се користи за сваки видљиви сегмент црева.",
                    label = "Сегмент Проп",
                },
                hoseSegmentUpdateDistance = {
                    description = "Минимално кретање пре него што се видљиви сегменти црева поново направе.",
                    label = "Удаљеност ажурирања сегмента",
                },
                hoseUpdateInterval = {
                    description = "Основни интервал симулације црева у милисекундама.",
                    label = "Интервал ажурирања",
                },
                hoseVehicleBendDistance = {
                    description = "Растојање за формирање кривине црева на возилу.",
                    label = "Удаљеност савијања возила",
                },
                hoseVehicleExitLength = {
                    description = "Равна дужина црева на прикључку возила.",
                    label = "Дужина излаза возила",
                },
                hoseVehiclePumpBehaviorActiveRpm = {
                    description = "Вредност обртаја у минути која се поставља када је пумпа возила активна. Од 0,0 до 1,0.",
                    label = "Активни РПМ",
                },
                hoseVehiclePumpBehaviorAmbientTemperature = {
                    description = "Најнижа температура пумпе и циљ хлађења у степенима Целзијуса.",
                    label = "Температура околине",
                },
                hoseVehiclePumpBehaviorCavitationTemperatureGain = {
                    description = "Додатна циљна температура при пуној кавитацији.",
                    label = "Пораст температуре кавитације",
                },
                hoseVehiclePumpBehaviorCriticalTemperature = {
                    description = "Температура пумпе изнад које се појављује критично упозорење.",
                    label = "Критична температура",
                },
                hoseVehiclePumpBehaviorDamageTemperature = {
                    description = "Температура пумпе изнад које долази до оштећења мотора.",
                    label = "Температура оштећења",
                },
                hoseVehiclePumpBehaviorDryRunDamagePerSecond = {
                    description = "Оштећење мотора у секунди када ради на суво.",
                    label = "Штета при раду на суво/Sekunde",
                },
                hoseVehiclePumpBehaviorDryRunTemperature = {
                    description = "Циљна температура при пумпању без воде.",
                    label = "Температура рада на суво",
                },
                hoseVehiclePumpBehaviorEnabled = {
                    description = "Одржава рад мотора и контролише број обртаја пумпе док системи црева користе возило.",
                    label = "Активирај понашање пумпе",
                },
                hoseVehiclePumpBehaviorEngagementMaxSpeed = {
                    description = "Највећа брзина возила у метрима у секунди при којој се пумпа може укључити.",
                    label = "Максимална брзина активације",
                },
                hoseVehiclePumpBehaviorEngineDamageEnabled = {
                    description = "Дозвољава да прегревање и рад на суво оштете мотор возила. Подразумевано је искључено; упозорења пумпе остају активна.",
                    label = "Оштећење мотора услед рада пумпе",
                },
                hoseVehiclePumpBehaviorFuelPercentPerMinute = {
                    description = "Основна потрошња пумпе која ради у минути.",
                    label = "Проценат горива/Minute",
                },
                hoseVehiclePumpBehaviorImmobilizePumpVehicles = {
                    description = "Спречава вожњу све док је пумпа возила активна.",
                    label = "Закључајте возило током пумпања",
                },
                hoseVehiclePumpBehaviorImmobilizeTransferVehicles = {
                    description = "Спречава вожњу док је веза за пренос између возила и возила.",
                    label = "Блок трансфер возила",
                },
                hoseVehiclePumpBehaviorKeepEngineOnDuringPump = {
                    description = "Одржава изворни мотор возила да ради док ручно црево или водени топ прскају.",
                    label = "Мотор укључен током прскања",
                },
                hoseVehiclePumpBehaviorKeepEngineOnDuringTransfer = {
                    description = "Одржава моторе возила да раде све док је преносни вод повезан.",
                    label = "Мотор током трансфера у",
                },
                hoseVehiclePumpBehaviorKeepEngineOnWhenAbandoned = {
                    description = "Одржава конфигурисана возила са пумпом да раде након искрцавања.",
                    label = "Покрените мотор при изласку",
                },
                hoseVehiclePumpBehaviorMaxEngineDamagePerSecond = {
                    description = "Максимално оштећење мотора у секунди због оптерећења пумпе.",
                    label = "Максимална штета/Sekunde",
                },
                hoseVehiclePumpBehaviorOverloadWarningLoad = {
                    description = "Однос оптерећења мотора из којег се појављује упозорење о преоптерећењу.",
                    label = "Праг упозорења о преоптерећењу",
                },
                hoseVehiclePumpBehaviorRpmEnabled = {
                    description = "Подиже број обртаја возила док ручно црево или водени топ прскају из овог возила.",
                    label = "Повећај број обртаја пумпе",
                },
                hoseVehiclePumpBehaviorThermalResponse = {
                    description = "Колико брзо се пумпа приближава израчунатој циљној температури.",
                    label = "Температурни одговор",
                },
                hoseVehiclePumpBehaviorUpdateMs = {
                    description = "Колико често клијент ресетује понашање мотора, застоја и обртаја у милисекундама.",
                    label = "Интервал ажурирања",
                },
                hoseVehiclePumpBehaviorWarningTemperature = {
                    description = "Температура пумпе изнад које се појављује упозорење о прегревању.",
                    label = "Температура упозорења",
                },
                hoseVehiclePumpHydraulicsCavitationStartRatio = {
                    description = "Део капацитета извора на коме почиње кавитација.",
                    label = "Почетни однос кавитације",
                },
                hoseVehiclePumpHydraulicsFrictionLossPsiPerTenMeters = {
                    description = "Губитак притиска на десет метара активног црева.",
                    label = "Губитак трења ПСИ на 10 м",
                },
                hoseVehiclePumpHydraulicsHydrantIntakePressure = {
                    description = "Улазни притисак у ПСИ који обезбеђује хидрант.",
                    label = "Улазни притисак хидранта",
                },
                hoseVehiclePumpHydraulicsHydrantSupplyLitersPerSecond = {
                    description = "Максимални проток воде из хидранта у литрима у секунди.",
                    label = "Проток хидранта",
                },
                hoseVehiclePumpHydraulicsPumpIntakePressure = {
                    description = "Улазни притисак у ПСИ који обезбеђује преносива пумпа.",
                    label = "Улазни притисак пумпе",
                },
                hoseVehiclePumpHydraulicsPumpSupplyGpm = {
                    description = "Максимални проток воде из преносиве пумпе.",
                    label = "Напајање пумпе ГПМ",
                },
                hoseVehiclePumpHydraulicsTankIntakePressure = {
                    description = "Улазни притисак у ПСИ који обезбеђује резервоар возила.",
                    label = "Улазни притисак резервоара",
                },
                hoseVehiclePumpHydraulicsTankSupplyGpm = {
                    description = "Максимални проток воде из резервоара возила.",
                    label = "Снабдевање резервоара ГПМ",
                },
                hoseVehicleTransferAllowExternalSource = {
                    description = "Изворно возило са хидрантом или пумпом може да напуни одредиште без пражњења сопственог резервоара.",
                    label = "Дозволи спољни извор",
                },
                hoseVehicleTransferConnectDistance = {
                    description = "Максимална удаљеност играча за повезивање линије за пренос.",
                    label = "Удаљеност везе",
                },
                hoseVehicleTransferDisconnectWhenSourceEmpty = {
                    description = "Аутоматски прекида пренос када је изворни резервоар празан.",
                    label = "Заустави када је извор празан",
                },
                hoseVehicleTransferDisconnectWhenTargetFull = {
                    description = "Аутоматски прекида пренос када је одредишни резервоар пун.",
                    label = "Заустави када је циљ пун",
                },
                hoseVehicleTransferEnabled = {
                    description = "Дозвољава црево које преноси воду из једног резервоара ватрогасног возила у други.",
                    label = "Активирајте трансфер возила",
                },
                hoseVehicleTransferLitersPerSecond = {
                    description = "Количина воде која се помери од изворног возила до циљаног возила у секунди.",
                    label = "литара у секунди",
                },
                hoseVehicleTransferMaxLength = {
                    description = "Максимално растојање између два повезана возила.",
                    label = "Максимална дужина кабла",
                },
                hoseVehicleTransferRequireOnDuty = {
                    description = "Само дежурни ватрогасци могу да креирају пренос воде возила.",
                    label = "Потребна услуга",
                },
                hoseVehicleTransferSourceDirectionX = {
                    description = "Konfiguriert: Изворни правац Кс.",
                    label = "Изворни правац Кс",
                },
                hoseVehicleTransferSourceDirectionY = {
                    description = "Konfiguriert: Изворни правац И.",
                    label = "Изворни правац И",
                },
                hoseVehicleTransferSourceDirectionZ = {
                    description = "Konfiguriert: Изворни правац З.",
                    label = "Изворни правац З",
                },
                hoseVehicleTransferSourceOffsetX = {
                    description = "Konfiguriert: Извор Кс.",
                    label = "Извор Кс",
                },
                hoseVehicleTransferSourceOffsetY = {
                    description = "Konfiguriert: Извор И.",
                    label = "Извор И",
                },
                hoseVehicleTransferSourceOffsetZ = {
                    description = "Konfiguriert: Извор З.",
                    label = "Извор З",
                },
                hoseVehicleTransferTargetDirectionX = {
                    description = "Konfiguriert: Циљни правац Кс.",
                    label = "Циљни правац Кс",
                },
                hoseVehicleTransferTargetDirectionY = {
                    description = "Konfiguriert: Циљни правац И.",
                    label = "Циљни правац И",
                },
                hoseVehicleTransferTargetDirectionZ = {
                    description = "Konfiguriert: Циљни правац З.",
                    label = "Циљни правац З",
                },
                hoseVehicleTransferTargetOffsetX = {
                    description = "Konfiguriert: Циљ Кс.",
                    label = "Циљ Кс",
                },
                hoseVehicleTransferTargetOffsetY = {
                    description = "Konfiguriert: Циљ И.",
                    label = "Циљ И",
                },
                hoseVehicleTransferTargetOffsetZ = {
                    description = "Konfiguriert: Таргет З.",
                    label = "Таргет З",
                },
                hoseVehicleTransferTickMs = {
                    description = "Интервал ажурирања сервера за активне линије преноса.",
                    label = "Пренос тицк мс",
                },
                hoseVehicles = {
                    description = "Модели возила са плочом пумпе, резервоарима и индивидуално подесивим улазима и излазима.",
                    itemLabel = "Возило",
                    label = "Возила са пумпама",
                },
                hoseWaterLitersPerSecond = {
                    description = "Потрошња резервоара за воду при прскању воде без спољног довода.",
                    label = "литара воде у секунди",
                },
                hydrantConnection = {
                    description = "Konfiguriert: Прикључак хидранта.",
                    label = "Прикључак хидранта",
                },
                hydrantRx = {
                    description = "Konfiguriert: Хидрант РКС.",
                    label = "Хидрант РКС",
                },
                hydrantRy = {
                    description = "Konfiguriert: Хидрант РИ.",
                    label = "Хидрант РИ",
                },
                hydrantRz = {
                    description = "Konfiguriert: Хидрант РЗ.",
                    label = "Хидрант РЗ",
                },
                hydrantX = {
                    description = "Konfiguriert: Хидрант Кс.",
                    label = "Хидрант Кс",
                },
                hydrantY = {
                    description = "Konfiguriert: Хидрант И.",
                    label = "Хидрант И",
                },
                hydrantZ = {
                    description = "Konfiguriert: Хидрант З.",
                    label = "Хидрант З",
                },
                igniteDistance = {
                    description = "Колико се играч мора приближити овом извору ватре да би подесио паљење.",
                    label = "Растојање за подешавање паљења",
                },
                interiorExtinguishersAllowedJobs = {
                    description = "Оставите празно да дозволите све послове. Искључите обавезну дужност да би свако могао да узима и допуњава апарате за гашење пожара.",
                    itemLabel = "Посао",
                    label = "Дозвољени послови",
                },
                interiorExtinguishersEmptyMountHeadingOffset = {
                    description = "Корекција ротације за празан држач специфична за модел.",
                    label = "Оријентација носиоца",
                },
                interiorExtinguishersEmptyMountModel = {
                    description = "Прилагођени реквизит који се приказује у оригиналној позицији све док недостаје апарат за гашење пожара.",
                    label = "Модел празног држача",
                },
                interiorExtinguishersEmptyMountOffsetX = {
                    description = "Локално лево /Rechtsversatz након примене проп ротације. Негативне вредности се померају улево.",
                    label = "Помак држача Кс",
                },
                interiorExtinguishersEmptyMountOffsetY = {
                    description = "Локално померање унапред-/Rназад након примене проп ротације.",
                    label = "Помак држача И",
                },
                interiorExtinguishersEmptyMountOffsetZ = {
                    description = "Локално померање надморске висине након примене проп ротације.",
                    label = "Помак држача З",
                },
                interiorExtinguishersEmptyMountStreamDistance = {
                    description = "Растојање унутар које се пуни празни држачи апарата за гашење пожара.",
                    label = "Удаљеност стриминга држача",
                },
                interiorExtinguishersEmptyThresholdPercent = {
                    description = "Ниво на којем се апарат за гашење пожара сматра празним.",
                    label = "Празан праг у процентима",
                },
                interiorExtinguishersEnabled = {
                    description = "Омогућава ватрогасцима да узму конфигурисане реквизите за гашење пожара из ентеријера.",
                    label = "Омогући снимање",
                },
                interiorExtinguishersFullAmmo = {
                    description = "Вредност сирове муниције за оружје, која одговара нивоу попуњености од 100 процената за залихе без метаподатака о процентима.",
                    label = "Муниција са пуним апаратом за гашење пожара",
                },
                interiorExtinguishersInteractionDistance = {
                    description = "Максимална удаљеност са које се може притиснути подупирач за гашење пожара Е.",
                    label = "Даљина гађања",
                },
                interiorExtinguishersItem = {
                    description = "Предмет или оружје дато када се извуче и потроши приликом допуњавања држача.",
                    label = "Ставка инвентара",
                },
                interiorExtinguishersLabel = {
                    description = "Име приказано током интеракција уношења и допуњавања.",
                    label = "Приказано име",
                },
                interiorExtinguishersMaintenanceAllowedJobs = {
                    description = "Додатни послови за радијалне акције апарата за гашење пожара. Ватрогасни послови су увек укључени.",
                    itemLabel = "Посао",
                    label = "Радијални послови и послови одржавања",
                },
                interiorExtinguishersMaintenanceEnabled = {
                    description = "Управља празним и оштећеним апаратима за гашење пожара.",
                    label = "Омогући статус одржавања",
                },
                interiorExtinguishersMaintenanceRequireOnDuty = {
                    description = "Дозвољени послови одржавања морају бити на дужности.",
                    label = "Потребна услуга",
                },
                interiorExtinguishersModels = {
                    description = "Модели унутрашњих објеката који се могу уклонити.",
                    itemLabel = "Модел",
                    label = "Модели реквизита за гашење пожара",
                },
                interiorExtinguishersNoDutyJobs = {
                    description = "Пословима на овој листи је дозвољено уклањање и допуњавање апарата за гашење пожара без обавезе.",
                    itemLabel = "Посао",
                    label = "Неуслужни послови",
                },
                interiorExtinguishersPickupDurationMs = {
                    description = "Анимација и трајање напретка пре уклањања апарата за гашење пожара.",
                    label = "Време екстракције мс",
                },
                interiorExtinguishersPlacementAllowedJobs = {
                    description = "Оставите празно да бисте користили опште послове апарата за гашење пожара или све конфигурисане послове ватрогасне службе.",
                    itemLabel = "Посао",
                    label = "Послови за запошљавање",
                },
                interiorExtinguishersPlacementConsumeItem = {
                    description = "Уклања тачно један сет прилога само након успешног постављања.",
                    label = "Потроши предмет када се постави",
                },
                interiorExtinguishersPlacementDynamic = {
                    description = "Активира физику за постављени апарат за гашење пожара.",
                    label = "Динамиц Проп",
                },
                interiorExtinguishersPlacementEnabled = {
                    description = "Омогућава ватрогасцима који испуњавају услове да слободно постављају комплете за причвршћивање апарата за гашење пожара у свету игре.",
                    label = "Омогући пласман",
                },
                interiorExtinguishersPlacementItem = {
                    description = "Ставка инвентара која започиње постављање комплетног прибора за гашење пожара.",
                    label = "Ставка за пласман",
                },
                interiorExtinguishersPlacementModel = {
                    description = "Модел објекта слободно постављеног апарата за гашење пожара.",
                    label = "Постављен модел реквизита",
                },
                interiorExtinguishersPlacementPickupDistance = {
                    description = "Максимално растојање за уклањање постављеног апарата за гашење пожара.",
                    label = "Даљина гађања",
                },
                interiorExtinguishersPlacementRequireOnDuty = {
                    description = "Само дежурним ватрогасцима је дозвољено постављање и подизање апарата за гашење пожара.",
                    label = "Потребна услуга за пласман",
                },
                interiorExtinguishersPlacementReturnItem = {
                    description = "Враћа комплет за узгој приликом уклањања постављеног подупирача.",
                    label = "Вратите предмет приликом преузимања",
                },
                interiorExtinguishersPlacementStreamDistance = {
                    description = "Растојање унутар које ће постављени апарат за гашење пожара бити напуњен.",
                    label = "Стреаминг Дистанце",
                },
                interiorExtinguishersPlacementWallEnabled = {
                    description = "Усмерава апарат за гашење пожара ка вертикалним површинама које циља сноп за постављање.",
                    label = "Омогући постављање на зид",
                },
                interiorExtinguishersPlacementWallHeadingOffset = {
                    description = "Ротира апарат за гашење пожара око његове вертикалне осе након што га поравна са зидом.",
                    label = "Корекција ротације зида",
                },
                interiorExtinguishersPlacementWallOffset = {
                    description = "Помера апарат за гашење пожара ван зида дуж нормалне површине.",
                    label = "Удаљеност од зида",
                },
                interiorExtinguishersPlacementZOffset = {
                    description = "Вертикални помак постављеног апарата за гашење пожара.",
                    label = "Флоор З Оффсет",
                },
                interiorExtinguishersRequireOnDuty = {
                    description = "Само чланови дозвољених послова на дужности могу уклонити и допунити апарате за гашење пожара.",
                    label = "Потребна услуга",
                },
                interiorExtinguishersRestoreDistance = {
                    description = "Максимално растојање до празног држача када се притисне Е са предметом за гашење пожара.",
                    label = "Растојање између",
                },
                interiorExtinguishersRestoreDurationMs = {
                    description = "Трајање анимације и напредовања пре него што се потроши предмет за гашење пожара.",
                    label = "Време попуне мс",
                },
                interiorExtinguishersScanDistance = {
                    description = "Радијус скенирања објеката око плејера.",
                    label = "Удаљеност скенирања",
                },
                label = {
                    description = "Konfiguriert: Назив.",
                    label = "Назив",
                },
                lighterAnimationDict = {
                    description = "Аним Речник за подешавање паљења.",
                    label = "Аниматион Дицт",
                },
                lighterAnimationDurationMs = {
                    description = "Колико дуго траје анимација паљења и напредовање пре него што се паљење постави.",
                    label = "Трајање анимације мс",
                },
                lighterAnimationFlag = {
                    description = "ТаскПлаиАним заставица за покретање анимације.",
                    label = "Застава анимације",
                },
                lighterAnimationName = {
                    description = "Аним клип за подешавање паљења.",
                    label = "Назив анимације",
                },
                lighterConsumeItem = {
                    description = "Троши конфигурисани лакши предмет након успешног паљења.",
                    label = "Потроши лакши предмет",
                },
                lighterCooldownSeconds = {
                    description = "Заједничко хлађење између лакших употреба реквизита и возила.",
                    label = "секунди хлађења",
                },
                lighterIgniteDelaySeconds = {
                    description = "Кашњење између успешног паљења и стварне ватре да би се играчу дало времена да побегне.",
                    label = "Кашњење паљења секунди",
                },
                lighterItem = {
                    description = "Инвентар који се користи за постављање паљења на возилима и другим изворима пожара.",
                    label = "Лакши предмет",
                },
                lighterVehicleEnabled = {
                    description = "Дозвољава лакшем предмету да осветли оближња возила.",
                    label = "Активирајте паљење возила",
                },
                lighterVehicleMaxDistance = {
                    description = "Максимално растојање до возила за подешавање паљења.",
                    label = "Удаљеност паљења возила",
                },
                lighterVehicleOffsetX = {
                    description = "Локални Кс помак за постављену ватрену позицију возила.",
                    label = "Померање пожара возила Кс",
                },
                lighterVehicleOffsetY = {
                    description = "Локални И офсет за постављену ватрену позицију возила.",
                    label = "Померање пожара возила И",
                },
                lighterVehicleOffsetZ = {
                    description = "Локални З оффсет за постављену ватрену позицију возила.",
                    label = "Померање пожара возила З",
                },
                lighterVehicleRequireOnDuty = {
                    description = "Дозвољава паљење возила само ако је играч на дужности у конфигурисаном ватрогасном задатку.",
                    label = "Потребна ватрогасна служба",
                },
                lighterVehicleRequiredJobs = {
                    description = "Ако се попуни, паљење возила ће радити само за конфигурисани број одређених онлајн послова.",
                    itemLabel = "Посао",
                    label = "Потребни послови на мрежи",
                },
                lighterVehicleSourceScale = {
                    description = "Множилац скалирања за пожаре у возилу који су почели упаљачем.",
                    label = "Величина пожара возила",
                },
                npcFireReactionsCooldownMs = {
                    description = "Време чекања док истом НПЦ-у није дозвољено да поново одговори на ватру.",
                    label = "НПЦ реакција хлађења мс",
                },
                npcFireReactionsDurationMs = {
                    description = "Колико дуго активна НПЦ реакција траје пре истека.",
                    label = "НПЦ време реакције мс",
                },
                npcFireReactionsEnabled = {
                    description = "Проузрокује панику цивилних НПЦ-а или снимање мобилним телефонима у близини активних пожара.",
                    label = "Омогући НПЦ ватрене реакције",
                },
                npcFireReactionsFilmChance = {
                    description = "Шанса од 0,0 до 1,0 да ће одговарајући НПЦ снимити уместо да уопште не реагује.",
                    label = "Могућност филма за мобилни телефон",
                },
                npcFireReactionsFilmEnabled = {
                    description = "Омогућава одговарајућим цивилима да зауставе и снимају оближње пожаре својим мобилним телефоном.",
                    label = "Активирајте снимање мобилног телефона",
                },
                npcFireReactionsFilmRadius = {
                    description = "На овој удаљености, НПЦ могу да снимају ватру својим мобилним телефонима.",
                    label = "Радијус НПЦ филма",
                },
                npcFireReactionsFleeDistance = {
                    description = "Колико далеко успаничени НПЦ треба да беже од ватре.",
                    label = "НПЦ Есцапе Дистанце",
                },
                npcFireReactionsMaxTrackedPeds = {
                    description = "Ограничава колико Нпц-а може да контролише систем у исто време.",
                    label = "Максимални реагујући Нпцс",
                },
                npcFireReactionsPanicEnabled = {
                    description = "Изазива панику оближњих цивила и бекство ако се ватра превише приближи.",
                    label = "Активирајте реакције панике",
                },
                npcFireReactionsPanicRadius = {
                    description = "Унутар ове удаљености, Нпцс имају тенденцију да паниче и беже.",
                    label = "НПЦ радијус панике",
                },
                npcFireReactionsRadius = {
                    description = "Максимална удаљеност НПЦ-а до ватре да би уопште могао да реагује.",
                    label = "НПЦ Реакциони радијус",
                },
                npcFireReactionsUpdateInterval = {
                    description = "Колико често тражити одговарајуће НПЦ у близини активних пожара.",
                    label = "НПЦ интервал реакције мс",
                },
                npcRescueAnimalEntrapmentEnabled = {
                    description = "Konfiguriert: Замка животиња.",
                    label = "Замка животиња",
                },
                npcRescueAnimalEntrapmentPanicChance = {
                    description = "Konfiguriert: Шанса за панику заробљене животиње.",
                    label = "Шанса за панику заробљене животиње",
                },
                npcRescueAnimalTreeEnabled = {
                    description = "Konfiguriert: Животиња на дрвету / висина.",
                    label = "Животиња на дрвету / висина",
                },
                npcRescueAnimalTreePanicChance = {
                    description = "Konfiguriert: Паниц Цханце Трее Анимал.",
                    label = "Паниц Цханце Трее Анимал",
                },
                npcRescueAnimalWaterEnabled = {
                    description = "Konfiguriert: Спасавање животиња у води.",
                    label = "Спасавање животиња у води",
                },
                npcRescueAnimalWaterPanicChance = {
                    description = "Konfiguriert: Паниц Цханце Ватер Анимал.",
                    label = "Паниц Цханце Ватер Анимал",
                },
                npcRescueBicycleEnabled = {
                    description = "Konfiguriert: Несрећа на сеоском бициклу.",
                    label = "Несрећа на сеоском бициклу",
                },
                npcRescueDropoffRadius = {
                    description = "Раздаљина потребна за предају спашеног пацијента колима хитне помоћи.",
                    label = "Радијус преноса",
                },
                npcRescueEnabled = {
                    description = "Омогућава НПЦ спасилачке мисије и токове задатака.",
                    label = "Омогућено",
                },
                npcRescueFieldExtractionDurationMs = {
                    description = "Konfiguriert: Подразумевано спасавање /Bergungsdauer мс.",
                    label = "Подразумевано спасавање /Bergungsdauer мс",
                },
                npcRescueFieldStabilizationDurationMs = {
                    description = "Konfiguriert: Стандардно време стабилизације мс.",
                    label = "Стандардно време стабилизације мс",
                },
                npcRescueForestEnabled = {
                    description = "Konfiguriert: Повреде у шуми / спасавање шуме.",
                    label = "Повреде у шуми / спасавање шуме",
                },
                npcRescueRubbleEnabled = {
                    description = "Konfiguriert: Спашавање изливања/отпада.",
                    label = "Спашавање изливања/отпада",
                },
                npcRescueSearchRadius = {
                    description = "Радијус претраге за сцене спасавања не-возила.",
                    label = "Радијус претраге",
                },
                oilAbsorbentBrushRadius = {
                    description = "Радијус сваког потеза повезивача у мини игрици повезивача.",
                    label = "Радијус распршивања",
                },
                oilAbsorbentGranulesPerMove = {
                    description = "Колико честица гранула се генерише по важећем кораку кретања.",
                    label = "гранула по покрету",
                },
                oilAbsorbentMinigameEnabled = {
                    description = "Замењује основну радњу везивања са Сцаттер мини-игром.",
                    label = "Активирај мини-игру биндер",
                },
                oilAbsorbentRequiredCoverage = {
                    description = "Колики део стазе мора бити покривен да би фаза повезивања била успешна.",
                    label = "Потребна покривеност",
                },
                oilCleanupAbsorbentItem = {
                    description = "Ставка инвентара за фазу везива чишћења изливања нафте.",
                    label = "Биндер Итем",
                },
                oilCleanupAllowedJobs = {
                    description = "Послови на овој белој листи могу да чисте уље поред послова подешених у овом ватрогасном послу.",
                    label = "Додатно дозвољени послови",
                },
                oilCleanupBindDurationMs = {
                    description = "Трајање резервног напредовања када је мини-игра са везивом онемогућена.",
                    label = "Време резервног повезивања мс",
                },
                oilCleanupBroomItem = {
                    description = "Ставка инвентара потребна за уклањање везаног изливања нафте.",
                    label = "Предмет метле",
                },
                oilCleanupConsumeAbsorbent = {
                    description = "Троши везни предмет када се успешно користи.",
                    label = "Цонсуме биндерс",
                },
                oilCleanupConsumeBroom = {
                    description = "Троши конфигурисани предмет метле након успешног чишћења.",
                    label = "Цонсуме Броом Итем",
                },
                oilCleanupRequireOnDuty = {
                    description = "Чланови свих дозвољених послова чишћења морају бити на дужности.",
                    label = "Дужност је обавезна",
                },
                oilCleanupSweepDurationMs = {
                    description = "Трајање резервног напретка када је искључена мини-игра.",
                    label = "Време резервног прегледа мс",
                },
                oilSpillsActive = {
                    description = "Жива листа активних изливања нафте са акцијама телепортовања и брисања.",
                    label = "Активни трагови нафте",
                },
                oilSpillsDefaultIntensity = {
                    description = "Подразумевани интензитет опасности за новонастала изливања нафте.",
                    label = "Подразумевани интензитет",
                },
                oilSpillsDeleteOnRestart = {
                    description = "Брише сачуване трагове уља при покретању ресурса уместо да их враћа.",
                    label = "Избриши при поновном покретању",
                },
                oilSpillsEnabled = {
                    description = "Укључује локве уља, проклизавање и чишћење. Аутоматске уљне мрље после судара или услед хабања захтевају Sky Mechanic или други повезани ресурс.",
                    label = "Омогући систем уљних мрља",
                },
                oilSpillsInteractionDistance = {
                    description = "Удаљеност потребна за интеракцију и чишћење изливене нафте.",
                    label = "Интеракциона удаљеност",
                },
                oilSpillsLifetimeMinutes = {
                    description = "Колико дуго неуклоњени трагови нафте остају активни пре него што истекну.",
                    label = "Минута животног века",
                },
                oilSpillsMaxActive = {
                    description = "Максималан број синхронизованих трагова уља који могу постојати у исто време.",
                    label = "Максимални активни трагови уља",
                },
                oilSpillsObjectGroundOffset = {
                    description = "Помак тла за подупираче за уљне мрље да боље леже на путу.",
                    label = "Одступање спрата објекта",
                },
                oilSpillsRemoveBelow = {
                    description = "Трагови ће бити аутоматски уклоњени чим њихов интензитет падне испод ове вредности.",
                    label = "Уклони под Интензитет",
                },
                oilSpillsResetIds = {
                    buttonLabel = "Ресетујте ИД",
                    description = "Потпуно пренумерише све активне трагове уља почевши од 1 и синхронизује све играче.",
                    label = "Ресетуј ИД-ове трагова нафте",
                },
                oilSpillsSlipRadius = {
                    description = "Радијус у коме играчи и педагози могу да проклизају на стази.",
                    label = "Радијус клизања",
                },
                oilSweepBrushRadius = {
                    description = "Радијус око потеза метле, што доприноси напредовању.",
                    label = "Радијус чишћења",
                },
                oilSweepMaxSidewaysRatio = {
                    description = "Максимална дозвољена количина бочног померања пре померања се игнорише.",
                    label = "Бочна толеранција",
                },
                oilSweepMinStrokeDistance = {
                    description = "Минимална удаљеност курсора пре него што померање може да произведе напредак.",
                    label = "Минимална раздаљина чишћења",
                },
                oilSweepMinUpwardDelta = {
                    description = "Минимално кретање нагоре за исправан потез метлом.",
                    label = "Минимално кретање нагоре",
                },
                oilSweepMinigameEnabled = {
                    description = "Замењује основну траку напретка чишћења мини-игром метле.",
                    label = "Активирајте чисту мини-игру",
                },
                oilSweepRequiredProgress = {
                    description = "Напредак од 0,0 до 1,0 је потребан за уклањање везаног изливања нафте.",
                    label = "Неопходан свеобухватан напредак",
                },
                oilSweepToolWidth = {
                    description = "Приказана ширина слике метле у мини игрици.",
                    label = "Ширина слике метле",
                },
                playerEntrapmentAllowOffDuty = {
                    description = "Такође броји конфигурисани пандан посла ван радног времена приликом провере минималних захтева.",
                    label = "Бројите послове ван дужности",
                },
                playerEntrapmentAutoReleaseWhenRepaired = {
                    description = "Konfiguriert: Отпустити када се поправи.",
                    label = "Отпустити када се поправи",
                },
                playerEntrapmentBaseChance = {
                    description = "Konfiguriert: Основна шанса.",
                    label = "Основна шанса",
                },
                playerEntrapmentCooldownSeconds = {
                    description = "Konfiguriert: секунди хлађења.",
                    label = "секунди хлађења",
                },
                playerEntrapmentDoorOverviewEnabled = {
                    description = "Приказује мало возило са оштећеним, отвореним и употребљивим излазним вратима у заробљеном ХУД-у.",
                    label = "Прикажи преглед врата",
                },
                playerEntrapmentEnabled = {
                    description = "Играчи могу остати заробљени након довољног оштећења возила или превртања.",
                    label = "Омогући замку играча",
                },
                playerEntrapmentHudEnabled = {
                    description = "Konfiguriert: Прикажи хватање ХУД.",
                    label = "Прикажи хватање ХУД",
                },
                playerEntrapmentMinBodyHealthLoss = {
                    description = "Тачке оштећења тела које се морају најмање изгубити у судару. Мање вредности се лакше активирају.",
                    label = "Минимално оштећење тела",
                },
                playerEntrapmentMinEngineHealthLoss = {
                    description = "Тачке оштећења мотора које се морају изгубити барем у судару. Мање вредности се лакше активирају.",
                    label = "Минимална оштећења мотора",
                },
                playerEntrapmentPreventExit = {
                    description = "Konfiguriert: Напусти блок возила.",
                    label = "Напусти блок возила",
                },
                playerEntrapmentReleaseOnAnyDoor = {
                    description = "Konfiguriert: Отпуштање након било каквих отворених врата.",
                    label = "Отпуштање након било каквих отворених врата",
                },
                playerEntrapmentRepairedBodyHealthThreshold = {
                    description = "Konfiguriert: Поправка каросерије.",
                    label = "Поправка каросерије",
                },
                playerEntrapmentRepairedEngineHealthThreshold = {
                    description = "Konfiguriert: Поправите праг мотора.",
                    label = "Поправите праг мотора",
                },
                playerEntrapmentRepairedMaxRoll = {
                    description = "Konfiguriert: Поправка максималног угла котрљања.",
                    label = "Поправка максималног угла котрљања",
                },
                playerEntrapmentRequiredJobs = {
                    description = "Ако постоје уноси овде, ометање возила ће се покренути само ако је одређени број одређених професија онлајн.",
                    itemLabel = "Занимање",
                    label = "Неопходне каријере на мрежи",
                },
                playerEntrapmentRolloverBonusChance = {
                    description = "Konfiguriert: Шанса за бонус за преокрет.",
                    label = "Шанса за бонус за преокрет",
                },
                playerEntrapmentRolloverMinRoll = {
                    description = "Konfiguriert: Праг преокрета.",
                    label = "Праг преокрета",
                },
                propIgnitionDuplicateDistance = {
                    description = "Спречава да се друго паљење постави преблизу постојећег пожара.",
                    label = "Минимална удаљеност до постојећег пожара",
                },
                propIgnitionEnabled = {
                    description = "Омогућава вам да запалите одабране објекте и чврсте изворе ватре помоћу упаљача.",
                    label = "Омогући запаљиве објекте",
                },
                propIgnitionHighlightEnabled = {
                    description = "Означава погодне изворе ватре ивицом током претраге.",
                    label = "Означите тачке паљења",
                },
                propIgnitionMaxActiveFires = {
                    description = "Максималан број истовремено активних пожара покренутих преко таквих тачака паљења.",
                    label = "Максимални број активних пожара на имовини",
                },
                propIgnitionProps = {
                    description = "Модели објеката или фиксни извори ватре који се могу запалити упаљачем.",
                    itemLabel = "Извор ватре",
                    label = "Могуће тачке паљења",
                },
                propIgnitionRequireLineOfSight = {
                    description = "Само извори ватре са јасним погледом могу бити означени и коришћени.",
                    label = "Потребан је јасан преглед",
                },
                propIgnitionScanDistance = {
                    description = "Радијус у којем се детектују могуће тачке паљења у области.",
                    label = "Радијус претраге за тачке паљења",
                },
                propIgnitionScanDurationMs = {
                    description = "Колико дуго могуће тачке паљења остају видљиво означене пре него што се претрага заврши.",
                    label = "Трајање означавања мс",
                },
                pumpDischargeCount = {
                    description = "Konfiguriert: Изласци пумпе.",
                    label = "Изласци пумпе",
                },
                rescueCushionAllowedJobs = {
                    description = "Оставите празно тако да сви конфигурисани послови ватрогасне бригаде могу да поставе спасиоца у скоку.",
                    itemLabel = "Посао",
                    label = "Дозвољени послови",
                },
                rescueCushionConsumeItem = {
                    description = "Уклања ставку за чување скокова из инвентара када се постави.",
                    label = "Потроши предмет када се постави",
                },
                rescueCushionEnabled = {
                    description = "Потпуно укључује или искључује систем за спасавање при скоку.",
                    label = "Активирај чувар скокова",
                },
                rescueCushionItem = {
                    description = "Ставка инвентара за постављање чувара скока.",
                    label = "Назив артикла",
                },
                rescueCushionLabel = {
                    description = "Приказано име за постављеног спасиоца у скоку.",
                    label = "Назив",
                },
                rescueCushionLandingHeight = {
                    description = "Максимална висинска разлика изнад скока за спасавање при којој заштита од слетања и даље делује.",
                    label = "Висина слетања",
                },
                rescueCushionLandingRadius = {
                    description = "Хоризонтални радијус око чувара скока у којем су заштићени играчи који падају.",
                    label = "Радијус слетања",
                },
                rescueCushionModel = {
                    description = "Светски модел реквизита креиран приликом постављања чувара скокова.",
                    label = "Модел реквизита",
                },
                rescueCushionPickupDistance = {
                    description = "Удаљеност са које играч може да подигне постављени чувар скока.",
                    label = "Даљина гађања",
                },
                rescueCushionRequireOnDuty = {
                    description = "Само дежурни ватрогасци смеју да поставе спасилац у скоку.",
                    label = "Потребна услуга",
                },
                rescueCushionReturnItemOnRemove = {
                    description = "Враћа конфигурисану ставку играчу када подигне Спасилац за скок.",
                    label = "Вратите предмет приликом преузимања",
                },
                rescueCushionStreamDistance = {
                    description = "Удаљеност на којој ће постављени чувар скока бити стримован до оближњих играча.",
                    label = "Стреаминг Дистанце",
                },
                rescueCushionZOffset = {
                    description = "Вертикални помак за постављени подупирач за спасавање у скоку.",
                    label = "Одступање пласмана З",
                },
                rx = {
                    description = "Konfiguriert: РКС.",
                    label = "РКС",
                },
                ry = {
                    description = "Konfiguriert: РИ.",
                    label = "РИ",
                },
                rz = {
                    description = "Konfiguriert: РЗ.",
                    label = "РЗ",
                },
                scbaHudPosition = {
                    description = "Положај приказа манометра за заштиту органа за дисање.",
                    label = "Положај манометра",
                },
                scenarioAutomaticMissions = {
                    description = "Омогућите аутоматско покретање по мисији, подесите број потребних дежурних чланова, изаберите занимања која се рачунају и она која примају диспечерски позив. Празне листе користе глобална дежурна занимања или занимања за диспечерски позив.",
                    itemLabel = "Употреба",
                    label = "Доступни улози",
                },
                scenarioCreatorAllowRescue = {
                    description = "Омогућава уреднику мисије да поставља задатке спасавања пацијената и животиња.",
                    label = "Ресцуе Таб",
                },
                scenarioCreatorAllowVehicleFire = {
                    description = "Омогућава уређивачу мисије да постави конфигурисана запаљена возила.",
                    label = "Картица пожара возила",
                },
                scenarioCreatorEnabled = {
                    description = "Активира уредник ватрогасне мисије и алате чворишта.",
                    label = "Омогућено",
                },
                scenarioCreatorOpenMenu = {
                    buttonLabel = "Отворени уредник мисије",
                    description = "Отвара мени Ски Фире Миссион Едитор и затвара Конфигуратор задатака.",
                    label = "Мени уредника мисије",
                    unsavedTooltip = "Сачувај прво",
                },
                scenarioDispatchEnabled = {
                    description = "Креира слање ски_јобс_басе када се мисија покрене.",
                    label = "Пошаљите отпрему",
                },
                scenarioDispatchJobs = {
                    description = "Користе се када мисија нема посебно подешена занимања за диспечерски позив.",
                    itemLabel = "Занимање",
                    label = "Диспатцх Циљна занимања",
                },
                scenarioRandomChance = {
                    description = "Шанса по интервалу од 0,0 до 1,0.",
                    label = "Шанса окидања",
                },
                scenarioRandomEnabled = {
                    description = "Аутоматски покреће активирану мисију након конфигурисаног интервала.",
                    label = "Омогући аутоматске мисије",
                },
                scenarioRandomSelectionMode = {
                    description = "Насумична ротација покреће сваку тренутно доступну мисију једном пре понављања. Потпуно насумичан избор дозвољава понављања.",
                    label = "Избор мисија",
                    options = {
                        rotation = "Насумична ротација",
                        random = "Потпуно насумично",
                    },
                },
                scenarioRandomIntervalMax = {
                    description = "Konfiguriert: Максимални интервал минута.",
                    label = "Максимални интервал минута",
                },
                scenarioRandomIntervalMin = {
                    description = "Konfiguriert: Минимални интервал минута.",
                    label = "Минимални интервал минута",
                },
                scenarioRandomJobs = {
                    description = "Играчи ових послова рачунају се као дежурни ако нема сопствених оперативних послова унетих за изабрану мисију.",
                    itemLabel = "Посао",
                    label = "Стандардни сервисни послови",
                },
                scenarioRandomManualOnly = {
                    description = "Konfiguriert: Мисије које се покрећу само ручно.",
                    label = "Мисије које се покрећу само ручно",
                },
                smokePoisoningEnabled = {
                    description = "Укључује или искључује изложеност диму, удисање дима и повезане ефекте дима.",
                    label = "Активирајте удисање дима",
                },
                smokeVehicleClosedExposureMultiplier = {
                    description = "Множилац изложености диму све док су сва релевантна бочна стакла и даље нетакнута.",
                    label = "Мултипликатор дима када је возило затворено",
                },
                smokeVehicleExposureMultiplier = {
                    description = "Множилац изложености диму чим заштићено возило изгуби заштиту за прозор или тип возила није заштићен.",
                    label = "Мултипликатор дима за отворено или оштећено возило",
                },
                smokeVehicleProtectAutomobiles = {
                    description = "Konfiguriert: Протецт Царс.",
                    label = "Протецт Царс",
                },
                smokeVehicleProtectBoats = {
                    description = "Konfiguriert: Заштитите чамце.",
                    label = "Заштитите чамце",
                },
                smokeVehicleProtectCycles = {
                    description = "Konfiguriert: Заштита бицикала.",
                    label = "Заштита бицикала",
                },
                smokeVehicleProtectHelicopters = {
                    description = "Konfiguriert: Заштитите хеликоптере.",
                    label = "Заштитите хеликоптере",
                },
                smokeVehicleProtectMotorcycles = {
                    description = "Konfiguriert: Заштита мотоциклиста.",
                    label = "Заштита мотоциклиста",
                },
                smokeVehicleProtectPlanes = {
                    description = "Konfiguriert: Заштитите авионе.",
                    label = "Заштитите авионе",
                },
                smokeVehicleProtectionEnabled = {
                    description = "Омогућава конфигурисаним типовима возила да заштите своје путнике од дима све док је возило затворено.",
                    label = "Активирајте заштиту од дима возила",
                },
                smokeWarningHudPosition = {
                    description = "Локација ХУД индикатора удисања дима.",
                    label = "Положај индикатора удисања дима",
                },
                societyRewardFireEnabled = {
                    description = "Глобални прекидач за друштвене исплате након што је један пожар угашен.",
                    label = "Омогући исплате бренда",
                },
                societyRewardFireJobs = {
                    description = "Конфигуришите сваки посао појединачно са сопственим активним статусом и износом исплате. Унесите назив посла; чије конфигурисано друштво прима новац.",
                    itemLabel = "Посао",
                    label = "Посао за награђивање бренда",
                },
                societyRewardFireScenarioEnabled = {
                    description = "Исплаћује награду за пожар и када је угашени пожар део мисије из креатора мисија.",
                    label = "Исплати пожаре из мисија",
                },
                societyRewardOilEnabled = {
                    description = "Глобални прекидач за повлачење из друштва након чишћења изливене нафте.",
                    label = "Активирајте исплате нафте",
                },
                societyRewardOilJobs = {
                    description = "Конфигуришите сваки посао појединачно са сопственим активним статусом и износом исплате. Унесите назив посла; чије конфигурисано друштво прима новац.",
                    itemLabel = "Посао",
                    label = "Послови за награђивање нафте",
                },
                societyRewardOilScenarioEnabled = {
                    description = "Исплаћује награду за нафту и када је очишћена нафтна мрља део мисије из креатора мисија.",
                    label = "Исплати нафту из мисија",
                },
                societyRewardRescueEnabled = {
                    description = "Глобални прекидач за друштвене исплате након завршетка задатка спасавања.",
                    label = "Омогући исплате за спасавање",
                },
                societyRewardRescueJobs = {
                    description = "Конфигуришите сваки посао појединачно са сопственим активним статусом и износом исплате. Унесите назив посла; чије конфигурисано друштво прима новац.",
                    itemLabel = "Посао",
                    label = "Ресцуе Ревард Јобс",
                },
                societyRewardRescueScenarioEnabled = {
                    description = "Исплаћује награду за спасавање и када је завршени задатак део мисије из креатора мисија.",
                    label = "Исплати спасавања из мисија",
                },
                societyRewardTreeEnabled = {
                    description = "Глобални прекидач за друштвене исплате након чишћења обореног дрвета.",
                    label = "Омогући Трее исплате",
                },
                societyRewardTreeJobs = {
                    description = "Конфигуришите сваки посао појединачно са сопственим активним статусом и износом исплате. Унесите назив посла; чије конфигурисано друштво прима новац.",
                    itemLabel = "Посао",
                    label = "Трее Ревард послови",
                },
                societyRewardTreeScenarioEnabled = {
                    description = "Исплаћује награду за дрво и када је уклоњено дрво део мисије из креатора мисија.",
                    label = "Исплати дрвеће из мисија",
                },
                sourceScale = {
                    description = "Скалирање множитеља за пожар који се јавља на овој тачки паљења.",
                    label = "Величина настале ватре",
                },
                textures = {
                    description = "Konfiguriert: Текстуре.",
                    label = "Текстуре",
                },
                trappedRescueAllowAnyDoor = {
                    description = "Konfiguriert: Дозволи било која удаљена врата.",
                    label = "Дозволи било која удаљена врата",
                },
                trappedRescueAllowCarry = {
                    description = "Konfiguriert: Дозволите спасеној особи да носи.",
                    label = "Дозволите спасеној особи да носи",
                },
                trappedRescueAllowDrop = {
                    description = "Konfiguriert: Дозволите особи да оде.",
                    label = "Дозволите особи да оде",
                },
                trappedRescueAmbulanceFreeze = {
                    description = "Konfiguriert: Фреезе Амбуланце.",
                    label = "Фреезе Амбуланце",
                },
                trappedRescueAmbulanceInvincible = {
                    description = "Konfiguriert: Хитна помоћ неуништива.",
                    label = "Хитна помоћ неуништива",
                },
                trappedRescueAmbulanceLights = {
                    description = "Konfiguriert: Активирај плаво светло.",
                    label = "Активирај плаво светло",
                },
                trappedRescueAmbulanceOpenRearDoors = {
                    description = "Konfiguriert: Отворена задња врата.",
                    label = "Отворена задња врата",
                },
                trappedRescueDropoffRadius = {
                    description = "Konfiguriert: Радијус примопредаје хитне помоћи.",
                    label = "Радијус примопредаје хитне помоћи",
                },
                trappedRescueEnabled = {
                    description = "Омогућава задатке спасавања особа и животиња заснованих на сценарију.",
                    label = "Омогући НПЦ задатке спасавања",
                },
                trappedRescueExtractionDurationMs = {
                    description = "Konfiguriert: Време спасавања возила мс.",
                    label = "Време спасавања возила мс",
                },
                trappedRescueForceGain = {
                    description = "Konfiguriert: Добитак снаге у секунди.",
                    label = "Добитак снаге у секунди",
                },
                trappedRescueForceLoss = {
                    description = "Konfiguriert: Губитак силе у секунди.",
                    label = "Губитак силе у секунди",
                },
                trappedRescueForceMax = {
                    description = "Konfiguriert: Добар потез максимум.",
                    label = "Добар потез максимум",
                },
                trappedRescueForceMin = {
                    description = "Konfiguriert: Минимум доброг потеза.",
                    label = "Минимум доброг потеза",
                },
                trappedRescueInteractionDistance = {
                    description = "Konfiguriert: Удаљеност НПЦ интеракције.",
                    label = "Удаљеност НПЦ интеракције",
                },
                trappedRescueJamChance = {
                    description = "Konfiguriert: Могућност затезања појаса.",
                    label = "Могућност затезања појаса",
                },
                trappedRescueMaxMisses = {
                    description = "Konfiguriert: Дозвољени неуспели покушаји.",
                    label = "Дозвољени неуспели покушаји",
                },
                trappedRescuePullsRequired = {
                    description = "Konfiguriert: Неопходни снажни потези.",
                    label = "Неопходни снажни потези",
                },
                trappedRescueReliefHoldMs = {
                    description = "Konfiguriert: Напон задржавања мс.",
                    label = "Напон задржавања мс",
                },
                trappedRescueReliefZoneMax = {
                    description = "Konfiguriert: Максимална зона стреса.",
                    label = "Максимална зона стреса",
                },
                trappedRescueReliefZoneMin = {
                    description = "Konfiguriert: Минимална зона стреса.",
                    label = "Минимална зона стреса",
                },
                trappedRescueRequireDoor = {
                    description = "Konfiguriert: Потребна су уклоњена врата.",
                    label = "Потребна су уклоњена врата",
                },
                trappedRescueRequireGlass = {
                    description = "Konfiguriert: Потребан је разбијен прозор.",
                    label = "Потребан је разбијен прозор",
                },
                trappedRescueRequireMatchingSide = {
                    description = "Konfiguriert: Диск мора да стане на страну пацијента.",
                    label = "Диск мора да стане на страну пацијента",
                },
                trappedRescueRequireOnDuty = {
                    description = "Konfiguriert: Потребна услуга.",
                    label = "Потребна услуга",
                },
                trappedRescueSeatbeltDurationMs = {
                    description = "Konfiguriert: Временско ограничење мс.",
                    label = "Временско ограничење мс",
                },
                trappedRescueSeatbeltEnabled = {
                    description = "Konfiguriert: Активирајте мини-игру са сигурносним појасом.",
                    label = "Активирајте мини-игру са сигурносним појасом",
                },
                treeBlipColor = {
                    description = "Konfiguriert: Блип Цолор.",
                    label = "Блип Цолор",
                },
                treeBlipLabel = {
                    description = "Konfiguriert: Блип титл.",
                    label = "Блип титл",
                },
                treeBlipScale = {
                    description = "Konfiguriert: Величина слике.",
                    label = "Величина слике",
                },
                treeBlipSprite = {
                    description = "Konfiguriert: Блип Ицон.",
                    label = "Блип Ицон",
                },
                treeCarryAnimDict = {
                    description = "Konfiguriert: Царриинг Аниматион Дирецтори.",
                    label = "Царриинг Аниматион Дирецтори",
                },
                treeCarryAnimFlag = {
                    description = "Konfiguriert: Ношење заставе анимације.",
                    label = "Ношење заставе анимације",
                },
                treeCarryAnimName = {
                    description = "Konfiguriert: Носи име анимације.",
                    label = "Носи име анимације",
                },
                treeCarryMoveBlend = {
                    description = "Konfiguriert: Фактор кретања.",
                    label = "Фактор кретања",
                },
                treeCarryOffsetRx = {
                    description = "Konfiguriert: Ношење ротације Кс.",
                    label = "Ношење ротације Кс",
                },
                treeCarryOffsetRy = {
                    description = "Konfiguriert: Носећа ротација И.",
                    label = "Носећа ротација И",
                },
                treeCarryOffsetRz = {
                    description = "Konfiguriert: Носећа ротација З.",
                    label = "Носећа ротација З",
                },
                treeCarryOffsetX = {
                    description = "Konfiguriert: Преносни помак Кс.",
                    label = "Преносни помак Кс",
                },
                treeCarryOffsetY = {
                    description = "Konfiguriert: Преносни помак И.",
                    label = "Преносни помак И",
                },
                treeCarryOffsetZ = {
                    description = "Konfiguriert: Преносни офсет З.",
                    label = "Преносни офсет З",
                },
                treeCarryProp = {
                    description = "Konfiguriert: Ношени модел реквизита.",
                    label = "Ношени модел реквизита",
                },
                treeCarryPropBone = {
                    description = "Konfiguriert: Царриинг Боне.",
                    label = "Царриинг Боне",
                },
                treeDispatchEnabled = {
                    description = "Konfiguriert: Пошаљите отпрему дрвета.",
                    label = "Пошаљите отпрему дрвета",
                },
                treeDispatchJobs = {
                    description = "Konfiguriert: Диспатцх Таргет Јобс.",
                    itemLabel = "Посао",
                    label = "Диспатцх Таргет Јобс",
                },
                treeDropCleanupRadius = {
                    description = "Одбачени комади дрвета се уклањају када више нема играча у овој области.",
                    label = "Распон чишћења",
                },
                treeDropMarkerA = {
                    description = "Konfiguriert: Транспарентност маркера.",
                    label = "Транспарентност маркера",
                },
                treeDropMarkerB = {
                    description = "Konfiguriert: Маркер Блуе.",
                    label = "Маркер Блуе",
                },
                treeDropMarkerG = {
                    description = "Konfiguriert: Маркер Греен.",
                    label = "Маркер Греен",
                },
                treeDropMarkerHeight = {
                    description = "Konfiguriert: Висина маркера.",
                    label = "Висина маркера",
                },
                treeDropMarkerR = {
                    description = "Konfiguriert: Маркер Ред.",
                    label = "Маркер Ред",
                },
                treeDropMarkerType = {
                    description = "Konfiguriert: Тип маркера.",
                    label = "Тип маркера",
                },
                treeDropOffsetX = {
                    description = "Локални бочни помак од обореног дрвета.",
                    label = "Одступање складиштења Кс",
                },
                treeDropOffsetY = {
                    description = "Локални помак дуж правца стабла.",
                    label = "Одступање складиштења И",
                },
                treeDropOffsetZ = {
                    description = "Вертикални помак тацне.",
                    label = "Одступање складиштења З",
                },
                treeDropRadius = {
                    description = "Konfiguriert: Радијус депозиције.",
                    label = "Радијус депозиције",
                },
                treeEnabled = {
                    description = "Konfiguriert: Омогући мисије Фаллен Трее.",
                    label = "Омогући мисије Фаллен Трее",
                },
                treeInteractionDistance = {
                    description = "Konfiguriert: Интеракциона удаљеност.",
                    label = "Интеракциона удаљеност",
                },
                treeInteractionOffsetX = {
                    description = "Локални бочни помак од модела стабла.",
                    label = "Померање тачке тестере Кс",
                },
                treeInteractionOffsetY = {
                    description = "Локални уздужни помак од модела стабла.",
                    label = "Померање тачке тестере И",
                },
                treeInteractionOffsetZ = {
                    description = "Вертикални помак од модела стабла.",
                    label = "Помак тачке тестерисања З",
                },
                treeMarkerA = {
                    description = "Konfiguriert: Транспарентност маркера.",
                    label = "Транспарентност маркера",
                },
                treeMarkerB = {
                    description = "Konfiguriert: Маркер Блуе.",
                    label = "Маркер Блуе",
                },
                treeMarkerG = {
                    description = "Konfiguriert: Маркер Греен.",
                    label = "Маркер Греен",
                },
                treeMarkerHeight = {
                    description = "Konfiguriert: Висина маркера.",
                    label = "Висина маркера",
                },
                treeMarkerR = {
                    description = "Konfiguriert: Маркер Ред.",
                    label = "Маркер Ред",
                },
                treeMarkerSize = {
                    description = "Konfiguriert: Величина маркера.",
                    label = "Величина маркера",
                },
                treeMarkerType = {
                    description = "Konfiguriert: Тип маркера.",
                    label = "Тип маркера",
                },
                treePickupDistance = {
                    description = "Konfiguriert: Удаљеност за отказивање.",
                    label = "Удаљеност за отказивање",
                },
                treePieceCount = {
                    description = "Konfiguriert: Број комада дрвета.",
                    label = "Број комада дрвета",
                },
                treePieceModel = {
                    description = "Konfiguriert: Модел од дрвета.",
                    label = "Модел од дрвета",
                },
                treePieceSpacing = {
                    description = "Konfiguriert: Растојање између комада дрвета.",
                    label = "Растојање између комада дрвета",
                },
                treePropModel = {
                    description = "Модел објекта се појавио за пало дрво.",
                    label = "Модел дрвета",
                },
                treeRequireOnDuty = {
                    description = "Konfiguriert: Потребна услуга.",
                    label = "Потребна услуга",
                },
                treeSawAnimDict = {
                    description = "Konfiguriert: Именик анимација.",
                    label = "Именик анимација",
                },
                treeSawAnimFlag = {
                    description = "Konfiguriert: Застава анимације.",
                    label = "Застава анимације",
                },
                treeSawAnimName = {
                    description = "Konfiguriert: Назив анимације.",
                    label = "Назив анимације",
                },
                treeSawCollision = {
                    description = "Konfiguriert: Омогући судар реквизита.",
                    label = "Омогући судар реквизита",
                },
                treeSawIsPed = {
                    description = "Konfiguriert: Прикачи на Пед.",
                    label = "Прикачи на Пед",
                },
                treeSawOffsetRx = {
                    description = "Konfiguriert: Ротација моторне тестере Кс.",
                    label = "Ротација моторне тестере Кс",
                },
                treeSawOffsetRy = {
                    description = "Konfiguriert: Ротација моторне тестере И.",
                    label = "Ротација моторне тестере И",
                },
                treeSawOffsetRz = {
                    description = "Konfiguriert: Ротација моторне тестере З.",
                    label = "Ротација моторне тестере З",
                },
                treeSawOffsetX = {
                    description = "Konfiguriert: Оффсет моторне тестере Кс.",
                    label = "Оффсет моторне тестере Кс",
                },
                treeSawOffsetY = {
                    description = "Konfiguriert: Померање моторне тестере И.",
                    label = "Померање моторне тестере И",
                },
                treeSawOffsetZ = {
                    description = "Konfiguriert: Помак моторне тестере З.",
                    label = "Помак моторне тестере З",
                },
                treeSawProp = {
                    description = "Konfiguriert: Проп за моторну тестеру.",
                    label = "Проп за моторну тестеру",
                },
                treeSawPropBone = {
                    description = "Konfiguriert: Кост моторном тестером.",
                    label = "Кост моторном тестером",
                },
                treeSawRotationOrder = {
                    description = "Konfiguriert: Редослед ротације.",
                    label = "Редослед ротације",
                },
                treeSawSections = {
                    description = "Konfiguriert: Потребни делови тестере.",
                    label = "Потребни делови тестере",
                },
                treeSawSoftPinning = {
                    description = "Konfiguriert: Користите меко закачење.",
                    label = "Користите меко закачење",
                },
                treeSawSyncRotation = {
                    description = "Konfiguriert: Синхронизујте ротацију.",
                    label = "Синхронизујте ротацију",
                },
                treeSpawnRange = {
                    description = "Синхронизовано стабло ће се појавити када играч уђе у ову област.",
                    label = "Распон појављивања",
                },
                vehicleFiresBurnDamageBreakWindows = {
                    description = "Konfiguriert: Уништи прозоре у случају пуног пожара.",
                    label = "Уништи прозоре у случају пуног пожара",
                },
                vehicleFiresBurnDamageBurstTyres = {
                    description = "Konfiguriert: Гуме су пукле током пуног пожара.",
                    label = "Гуме су пукле током пуног пожара",
                },
                vehicleFiresBurnDamageDeformation = {
                    description = "Konfiguriert: Јачина оптичке деформације.",
                    label = "Јачина оптичке деформације",
                },
                vehicleFiresBurnDamageEnabled = {
                    description = "Оштећује и деформише запаљено возило постепено пре одложене експлозије.",
                    label = "Оштећење возила током пожара",
                },
                vehicleFiresBurnDamageFullBodyHealth = {
                    description = "Konfiguriert: Здравље тела током пуног пожара.",
                    label = "Здравље тела током пуног пожара",
                },
                vehicleFiresBurnDamageIntervalSeconds = {
                    description = "секунди између додатног оштећења у фази потпуног сагоревања.",
                    label = "Пуни интервал оштећења од пожара",
                },
                vehicleFiresBurnDamageMinimumBodyHealth = {
                    description = "Konfiguriert: Минимално здравље тела пре експлозије.",
                    label = "Минимално здравље тела пре експлозије",
                },
                vehicleFiresBurnDamagePerTick = {
                    description = "Konfiguriert: Оштећења тела по интервалу.",
                    label = "Оштећења тела по интервалу",
                },
                vehicleFiresBurnDamageSmallBodyHealth = {
                    description = "Konfiguriert: Здравље тела у малој ватри.",
                    label = "Здравље тела у малој ватри",
                },
                vehicleFiresCanExtinguishFoam = {
                    description = "Дозвољава пени из црева или довода возила да угаси овај материјал за пожар у возилу.",
                    label = "Избрисиво пеном",
                },
                vehicleFiresCanExtinguishWater = {
                    description = "Омогућава воду из црева, водене топове за возила и резервоаре за воду за пожар у хеликоптерима да угасе овај материјал за пожар у возилу.",
                    label = "Може се избрисати водом",
                },
                vehicleFiresCanExtinguishWaterMonitor = {
                    description = "Омогућава преносном воденом топу да угаси овај материјал за пожар у возилу.",
                    label = "Може се угасити воденим топовима",
                },
                vehicleFiresDuplicateDistance = {
                    description = "Спречава стварање другог пожара возила преблизу постојећег.",
                    label = "Дуплицирана удаљеност",
                },
                vehicleFiresEnabled = {
                    description = "Активира систем за ватру возила.",
                    label = "Омогућено",
                },
                vehicleFiresEngineHealth = {
                    description = "Останите на 300 или више да бисте спречили пожар и рану експлозију Гта-иног возила.",
                    label = "Стање мотора током пожара",
                },
                vehicleFiresEngineOff = {
                    description = "Konfiguriert: Искључите мотор.",
                    label = "Искључите мотор",
                },
                vehicleFiresExplosionCameraShake = {
                    description = "Konfiguriert: Цамера Схаке.",
                    label = "Цамера Схаке",
                },
                vehicleFiresExplosionDamageScale = {
                    description = "Konfiguriert: Скалирање штете од експлозије.",
                    label = "Скалирање штете од експлозије",
                },
                vehicleFiresExplosionDelaySeconds = {
                    description = "секунди док запаљено возило не експлодира.",
                    label = "Секунди одлагања експлозије",
                },
                vehicleFiresExplosionEnabled = {
                    description = "Возила не експлодирају одмах; ово контролише опциону одложену експлозију.",
                    label = "Омогући одложену експлозију",
                },
                vehicleFiresExplosionPostBurnSeconds = {
                    description = "Секунди да уништено возило наставља да гори након експлозије.",
                    label = "Трајање пожара након експлозије",
                },
                vehicleFiresExplosionRemoveFire = {
                    description = "Уклања ватру након конфигурисаног трајања накнадног сагоревања. Онемогући за неограничен пожар олупине.",
                    label = "Уклоните ватру након накнадног сагоревања",
                },
                vehicleFiresExplosionType = {
                    description = "Konfiguriert: Тип експлозије.",
                    label = "Тип експлозије",
                },
                vehicleFiresExternalAllowedResources = {
                    description = "Ресурси дозвољени за изазивање пожара возила преко спољне куке.",
                    itemLabel = "Ресурс",
                    label = "Дозвољени ресурси",
                },
                vehicleFiresExternalEnabled = {
                    description = "Омогућава механичарским пословима или заједничким скриптама за стварање пожара возила Фирејоб.",
                    label = "Омогући спољно креирање",
                },
                vehicleFiresExternalMaxSourceDistance = {
                    description = "Максимално растојање између спољних координата окидача и возила.",
                    label = "Максимална удаљеност извора",
                },
                vehicleFiresFireType = {
                    description = "Врста извора ватре који се користи при стварању пожара возила.",
                    label = "Врста пожара",
                },
                vehicleFiresFoamEffectiveness = {
                    description = "Више вредности омогућавају пени да брже угаси пожар возила.",
                    label = "Ефикасност пене",
                },
                vehicleFiresKeepUndriveable = {
                    description = "Konfiguriert: Држите возило непокретним.",
                    label = "Држите возило непокретним",
                },
                vehicleFiresManualConsumeItem = {
                    description = "Konfiguriert: Потроши лакши предмет.",
                    label = "Потроши лакши предмет",
                },
                vehicleFiresManualEnabled = {
                    description = "Омогућава играчима да ручно запале оближња возила.",
                    label = "Ручно паљење",
                },
                vehicleFiresManualItem = {
                    description = "Ставка инвентара потребна за ручно паљење.",
                    label = "Ставка за паљење",
                },
                vehicleFiresManualMaxDistance = {
                    description = "Konfiguriert: Максимална удаљеност паљења.",
                    label = "Максимална удаљеност паљења",
                },
                vehicleFiresManualSourceScale = {
                    description = "Konfiguriert: Ручно паљење против пожара.",
                    label = "Ручно паљење против пожара",
                },
                vehicleFiresMaterial = {
                    description = "Профил материјала понашања горива возила.",
                    label = "Запаљиви материјал",
                },
                vehicleFiresMaxActive = {
                    description = "Konfiguriert: Максимални број активних пожара возила.",
                    label = "Максимални број активних пожара возила",
                },
                vehicleFiresPetrolTankHealth = {
                    description = "Остаје на 1000 тако да само конфигурисана експлозија Фирејоб може уништити возило.",
                    label = "Статус тенка током пожара",
                },
                vehicleFiresProgressionEnabled = {
                    description = "Пожари на возилима почињу димом, прерастају у малу ватру и онда достижу пуни интензитет.",
                    label = "Активирајте постепену паљбу возила",
                },
                vehicleFiresProgressionExplosionAfterFullFire = {
                    description = "Додаје дим и мало трајање пожара пре него што почне конфигурисано одлагање експлозије.",
                    label = "Тајмер експлозије након пуног пожара",
                },
                vehicleFiresProgressionFullIntensity = {
                    description = "Konfiguriert: Пуни интензитет пожара.",
                    label = "Пуни интензитет пожара",
                },
                vehicleFiresProgressionFullSize = {
                    description = "Konfiguriert: Пуна величина ватре.",
                    label = "Пуна величина ватре",
                },
                vehicleFiresProgressionFullSmokeDensity = {
                    description = "Konfiguriert: Пуна густина дима ватре.",
                    label = "Пуна густина дима ватре",
                },
                vehicleFiresProgressionSmallDurationSeconds = {
                    description = "Konfiguriert: Мало трајање ватре у секунди.",
                    label = "Мало трајање ватре у секунди",
                },
                vehicleFiresProgressionSmallIntensity = {
                    description = "Konfiguriert: Мали интензитет пожара.",
                    label = "Мали интензитет пожара",
                },
                vehicleFiresProgressionSmallSize = {
                    description = "Konfiguriert: Мала величина бренда.",
                    label = "Мала величина бренда",
                },
                vehicleFiresProgressionSmallSmokeDensity = {
                    description = "Konfiguriert: Мала густина дима од пожара.",
                    label = "Мала густина дима од пожара",
                },
                vehicleFiresProgressionSmallSourceScale = {
                    description = "Konfiguriert: Мала пожарна размера.",
                    label = "Мала пожарна размера",
                },
                vehicleFiresProgressionSmokeDensity = {
                    description = "Konfiguriert: Густина нивоа дима.",
                    label = "Густина нивоа дима",
                },
                vehicleFiresProgressionSmokeDurationSeconds = {
                    description = "Konfiguriert: Трајање дима у секундама.",
                    label = "Трајање дима у секундама",
                },
                vehicleFiresProgressionSmokeIntensity = {
                    description = "Konfiguriert: Интензитет дима.",
                    label = "Интензитет дима",
                },
                vehicleFiresProgressionSmokeSize = {
                    description = "Konfiguriert: Величина нивоа дима.",
                    label = "Величина нивоа дима",
                },
                vehicleFiresProgressionSmokeSourceScale = {
                    description = "Држите га веома ниско ако желите углавном дим са једва видљивим пламеном.",
                    label = "Скалирање пламена нивоа дима",
                },
                vehicleFiresServerCooldownSeconds = {
                    description = "Глобално хлађење за ручно паљење упаљача.",
                    label = "Хлађење паљења на нивоу сервера",
                },
                vehicleFiresSourceScale = {
                    description = "Konfiguriert: Подразумевано скалирање пожара.",
                    label = "Подразумевано скалирање пожара",
                },
                vehicleFiresStandaloneAllowNpcVehicles = {
                    description = "Konfiguriert: Дозволи НПЦ возила.",
                    label = "Дозволи НПЦ возила",
                },
                vehicleFiresStandaloneChance = {
                    description = "Konfiguriert: Шанса од пожара.",
                    label = "Шанса од пожара",
                },
                vehicleFiresStandaloneCooldownSeconds = {
                    description = "Konfiguriert: Секунде хлађења у случају несреће.",
                    label = "Секунде хлађења у случају несреће",
                },
                vehicleFiresStandaloneEnabled = {
                    description = "Омогућава Фирејобу да изазове пожаре возила у озбиљним несрећама без потребе за механичарским послом.",
                    label = "Активирајте независне незгоде",
                },
                vehicleFiresStandaloneForwardMotionRatio = {
                    description = "Konfiguriert: Однос кретања унапред.",
                    label = "Однос кретања унапред",
                },
                vehicleFiresStandaloneIgnoreElectric = {
                    description = "Konfiguriert: Игноришите електрична возила.",
                    label = "Игноришите електрична возила",
                },
                vehicleFiresStandaloneMechanicResources = {
                    description = "Ресурси који онемогућавају резервно откривање незгода током рада.",
                    itemLabel = "Ресурс",
                    label = "Механички ресурси",
                },
                vehicleFiresStandaloneMinBodyHealthLoss = {
                    description = "Konfiguriert: Минимално оштећење тела.",
                    label = "Минимално оштећење тела",
                },
                vehicleFiresStandaloneMinEngineHealthLoss = {
                    description = "Konfiguriert: Минимална оштећења мотора.",
                    label = "Минимална оштећења мотора",
                },
                vehicleFiresStandaloneMinImpactSpeedKmh = {
                    description = "Konfiguriert: Минимална брзина удара.",
                    label = "Минимална брзина удара",
                },
                vehicleFiresStandaloneMinSpeedDropKmh = {
                    description = "Konfiguriert: Минимални губитак брзине.",
                    label = "Минимални губитак брзине",
                },
                vehicleFiresStandaloneMode = {
                    description = "Замена се покреће само када конфигурисани механички ресурси нису активни. Увек може да ради паралелно са Мецханицјоб. Дисаблед задржава само ручне, екстерне или механичке окидаче.",
                    label = "Самостални режим",
                    options = {
                        always = "Увек",
                        disabled = "Онемогућено",
                        fallback = "Резервни режим",
                    },
                },
                vehicleFiresStandaloneRequireDriver = {
                    description = "Konfiguriert: Потребан је возач играча.",
                    label = "Потребан је возач играча",
                },
                vehicleFiresStandaloneServerMaxDistance = {
                    description = "Максимална дозвољена удаљеност играча до координата несреће.",
                    label = "Максимална удаљеност сервера",
                },
                vehicleFiresStandaloneSmokeDensity = {
                    description = "Konfiguriert: Густина дима удеса.",
                    label = "Густина дима удеса",
                },
                vehicleFiresStandaloneSourceScale = {
                    description = "Konfiguriert: Скалирање пожара у несрећи.",
                    label = "Скалирање пожара у несрећи",
                },
                vehicleFiresWaterEffectiveness = {
                    description = "Користите 0 да спречите воду да угаси пожар горива у возилу.",
                    label = "Ефикасност воде",
                },
                vehicleFiresWaterReactionChance = {
                    description = "Konfiguriert: Шанса за одговор.",
                    label = "Шанса за одговор",
                },
                vehicleFiresWaterReactionEnabled = {
                    description = "Дозвољава да вода на гориву возила шири ватру, производи дим или изазива експлозије у зависности од вредности испод.",
                    label = "Вода погоршава",
                },
                vehicleFiresWaterReactionExplosionChance = {
                    description = "Konfiguriert: Шанса реакције експлозије.",
                    label = "Шанса реакције експлозије",
                },
                vehicleFiresWaterReactionInterval = {
                    description = "Konfiguriert: Интервал одговора мс.",
                    label = "Интервал одговора мс",
                },
                vehicleFiresWaterReactionSmokeIncrease = {
                    description = "Konfiguriert: Повећање дима.",
                    label = "Повећање дима",
                },
                vehicleFiresWaterReactionSpreadCount = {
                    description = "Konfiguriert: Дистрибутивни број.",
                    label = "Дистрибутивни број",
                },
                vehicleRescueAllowMissionCreatorVehicles = {
                    description = "Омогућава возилима постављеним преко Фире Миссион Едитор-а да постану мете за спасавање.",
                    label = "Возила за уређивање мисије",
                },
                vehicleRescueAllowStateBag = {
                    description = "Спољне скрипте могу означити возила са Ентити(вехицле).стате[цонфигуредКеи] = труе.",
                    label = "Дозволи ознаку државне торбе",
                },
                vehicleRescueAllowWorldVehicles = {
                    description = "Омогућава нормалним оштећеним возилима у свету да постану мете за спасавање.",
                    label = "Ворлд Вехицлес",
                },
                vehicleRescueBreakDoorOnComplete = {
                    description = "Konfiguriert: Разбијте ГТА врата на успех.",
                    label = "Разбијте ГТА врата на успех",
                },
                vehicleRescueBreakWindowOnComplete = {
                    description = "Konfiguriert: Разбијте ГТА диск на успех.",
                    label = "Разбијте ГТА диск на успех",
                },
                vehicleRescueDoorLabel = {
                    description = "Назив интеракције за ширење врата возила.",
                    label = "Ознака интеракције врата",
                },
                vehicleRescueDoorWheelLabel = {
                    description = "Користите %s као чувар места за препознату страну врата.",
                    label = "Радијална ознака врата",
                },
                vehicleRescueEnabled = {
                    description = "Омогућава техничке интеракције спашавања на возилима.",
                    label = "Омогућено",
                },
                vehicleRescueGlassDurationMs = {
                    description = "Konfiguriert: Трајање мс.",
                    label = "Трајање мс",
                },
                vehicleRescueGlassGoodZone = {
                    description = "Konfiguriert: Добар распон.",
                    label = "Добар распон",
                },
                vehicleRescueGlassHammerItem = {
                    description = "Инвентар потребан за разбијање прозора возила.",
                    label = "Стаклени чекић Артикал",
                },
                vehicleRescueGlassHammerProp = {
                    description = "Konfiguriert: Стаклени чекић Предмет.",
                    label = "Стаклени чекић Предмет",
                },
                vehicleRescueGlassHitPoints = {
                    description = "Konfiguriert: Слабе тачке.",
                    label = "Слабе тачке",
                },
                vehicleRescueGlassLabel = {
                    description = "Назив интеракције за разбијање прозора возила.",
                    label = "Ознака интеракције диска",
                },
                vehicleRescueGlassMaxMisses = {
                    description = "Konfiguriert: Дозвољени неуспели покушаји.",
                    label = "Дозвољени неуспели покушаји",
                },
                vehicleRescueGlassMinigameEnabled = {
                    description = "Konfiguriert: Активирај мини-игру стакла.",
                    label = "Активирај мини-игру стакла",
                },
                vehicleRescueGlassMistakePenalty = {
                    description = "Konfiguriert: Казнени поени за грешке.",
                    label = "Казнени поени за грешке",
                },
                vehicleRescueGlassPerfectZone = {
                    description = "Konfiguriert: Савршен опсег.",
                    label = "Савршен опсег",
                },
                vehicleRescueGlassRequiredHits = {
                    description = "Konfiguriert: Обавезни хитови.",
                    label = "Обавезни хитови",
                },
                vehicleRescueGlassWheelLabel = {
                    description = "Користите %s као чувар места за препознату страну врата.",
                    label = "Радијална ознака диска",
                },
                vehicleRescueInteractionDistance = {
                    description = "Konfiguriert: Интеракциона удаљеност.",
                    label = "Интеракциона удаљеност",
                },
                vehicleRescueMaxScanDistance = {
                    description = "Konfiguriert: Удаљеност скенирања возила.",
                    label = "Удаљеност скенирања возила",
                },
                vehicleRescuePatientAccessibleAfterAnyDoor = {
                    description = "Поставља статус спасавања на доступно када се било која врата уклоне.",
                    label = "Пацијент постигнут након врата",
                },
                vehicleRescuePlayerEntrapmentEnabled = {
                    description = "Заробљава играче у тешко оштећеним возилима док се не успостави приступ за спасавање.",
                    label = "Заробљавање играча",
                },
                vehicleRescueRequireMatchingGlassForDoor = {
                    description = "Тачка на вратима ће се појавити тек када се уклони окно на истој страни.",
                    label = "Врата захтевају одговарајуће окно",
                },
                vehicleRescueRequireOnDuty = {
                    description = "Само ватрогасци на дужности могу да униште прозоре и разбију врата.",
                    label = "Потребна услуга",
                },
                vehicleRescueSpreaderDecayPerTick = {
                    description = "Konfiguriert: Рударство по тику.",
                    label = "Рударство по тику",
                },
                vehicleRescueSpreaderDurationMs = {
                    description = "Konfiguriert: Трајање мс.",
                    label = "Трајање мс",
                },
                vehicleRescueSpreaderItem = {
                    description = "Ставка инвентара потребна за отварање врата возила.",
                    label = "Распршивач",
                },
                vehicleRescueSpreaderMaxPumpPower = {
                    description = "Konfiguriert: Добра снага пумпања Максимална.",
                    label = "Добра снага пумпања Максимална",
                },
                vehicleRescueSpreaderMinPumpPower = {
                    description = "Konfiguriert: Добра снага пумпања Минимум.",
                    label = "Добра снага пумпања Минимум",
                },
                vehicleRescueSpreaderMinigameEnabled = {
                    description = "Konfiguriert: Активирај мини-игру спреадер.",
                    label = "Активирај мини-игру спреадер",
                },
                vehicleRescueSpreaderOverPressurePenalty = {
                    description = "Konfiguriert: Казна за прекомерни притисак.",
                    label = "Казна за прекомерни притисак",
                },
                vehicleRescueSpreaderPressureGain = {
                    description = "Konfiguriert: Повећање притиска.",
                    label = "Повећање притиска",
                },
                vehicleRescueSpreaderPressureLoss = {
                    description = "Konfiguriert: Губитак притиска.",
                    label = "Губитак притиска",
                },
                vehicleRescueSpreaderProgressPerTick = {
                    description = "Konfiguriert: Напредак по тику.",
                    label = "Напредак по тику",
                },
                vehicleRescueSpreaderProp = {
                    description = "Konfiguriert: Спреадер Објекат.",
                    label = "Спреадер Објекат",
                },
                vehicleRescueSpreaderPumpsRequired = {
                    description = "Врата ће бити уклоњена након отприлике 3 до 5 добрих пумпи за посипање.",
                    label = "Неопходни циклуси пумпе",
                },
                vehicleRescueSpreaderRequiredProgress = {
                    description = "Konfiguriert: Неопходан напредак.",
                    label = "Неопходан напредак",
                },
                vehicleRescueSpreaderSweetSpotMax = {
                    description = "Konfiguriert: Притисак Свеет Спот Макимум.",
                    label = "Притисак Свеет Спот Макимум",
                },
                vehicleRescueSpreaderSweetSpotMin = {
                    description = "Konfiguriert: Притисак Свеет Спот Минимум.",
                    label = "Притисак Свеет Спот Минимум",
                },
                vehicleRescueStateBagKey = {
                    description = "Konfiguriert: Државни кључ од торбе.",
                    label = "Државни кључ од торбе",
                },
                vehicleRescueWorldBodyHealthThreshold = {
                    description = "Konfiguriert: Праг тела.",
                    label = "Праг тела",
                },
                vehicleRescueWorldEngineHealthThreshold = {
                    description = "Konfiguriert: Праг мотора.",
                    label = "Праг мотора",
                },
                vehicleRescueWorldRequiresDamage = {
                    description = "Када су активна, нормална светска возила морају бити оштећена испод конфигурисаних прагова.",
                    label = "Светским возилима је потребна штета",
                },
                waterMonitorAllowedJobs = {
                    description = "Оставите празно да бисте дозволили све послове конфигурисане у овом Фирејоб-у.",
                    itemLabel = "Посао",
                    label = "Дозвољени послови",
                },
                waterMonitorCommand = {
                    description = "Име команде без косе црте, на пример ватермонитор.",
                    label = "команда",
                },
                waterMonitorCommandEnabled = {
                    description = "Омогућава постављање воденог топа без предмета преко команде.",
                    label = "Омогући коришћење команди",
                },
                waterMonitorConsumeItem = {
                    description = "Уклања конфигурисану ставку након успешног постављања.",
                    label = "Потроши предмет када се постави",
                },
                waterMonitorEnabled = {
                    description = "Омогућава постављање и рад преносног воденог топа.",
                    label = "Активирај водени топ",
                },
                waterMonitorEnterAnimDict = {
                    description = "Директоријум анимације који се учитава приликом покретања операције воденог топа.",
                    label = "Именик анимација",
                },
                waterMonitorEnterAnimDurationMs = {
                    description = "Трајање анимације уноса у милисекундама; -1 онемогућава временско ограничење.",
                    label = "Трајање мс",
                },
                waterMonitorEnterAnimName = {
                    description = "Клип анимације при преузимању радног положаја.",
                    label = "Назив анимације",
                },
                waterMonitorExitAnimDict = {
                    description = "Директоријум анимације се учитава при изласку из операције водених топова.",
                    label = "Именик анимација",
                },
                waterMonitorExitAnimDurationMs = {
                    description = "Трајање излазне анимације у милисекундама; -1 онемогућава временско ограничење.",
                    label = "Трајање мс",
                },
                waterMonitorExitAnimName = {
                    description = "Анимирани клип при напуштању радног положаја.",
                    label = "Назив анимације",
                },
                waterMonitorIdleAnimDict = {
                    description = "Директоријум анимације током рада воденог топа.",
                    label = "Именик анимација",
                },
                waterMonitorIdleAnimDurationMs = {
                    description = "Трајање оперативне анимације у милисекундама; -1 оставља га трајно активним.",
                    label = "Трајање мс",
                },
                waterMonitorIdleAnimName = {
                    description = "Поновљени клип анимације током рада воденог топа.",
                    label = "Назив анимације",
                },
                waterMonitorInteractionDistance = {
                    description = "Максимална удаљеност са које се може управљати воденим топом.",
                    label = "Интеракциона удаљеност",
                },
                waterMonitorItem = {
                    description = "Инвентар за постављање воденог топа.",
                    label = "Назив артикла",
                },
                waterMonitorItemEnabled = {
                    description = "Омогућава вам да поставите водени топ са конфигурисаним предметом инвентара.",
                    label = "Омогући коришћење ставке",
                },
                waterMonitorLabel = {
                    description = "Име које се појављује у интеракцијама и обавештењима.",
                    label = "Приказано име",
                },
                waterMonitorModel = {
                    description = "Модел реквизита креиран за водени топ.",
                    label = "Модел реквизита",
                },
                waterMonitorPickupDistance = {
                    description = "Максимална удаљеност са које се може покупити постављени водени топ.",
                    label = "Даљина гађања",
                },
                waterMonitorRequireOnDuty = {
                    description = "Дозвољава коришћење само члановима дозвољеног посла који су на дужности.",
                    label = "Потребна услуга",
                },
                waterMonitorReturnItemOnRemove = {
                    description = "Враћа конфигурисану ставку када подигнете водени топ.",
                    label = "Вратите предмет приликом преузимања",
                },
                waterMonitorStreamDistance = {
                    description = "Максимална удаљеност на којој се постављени водени топови синхронизују и приказују.",
                    label = "Стреаминг Дистанце",
                },
                waterMonitorStreamHitRadius = {
                    description = "Радијус око путање воде у којој се може погодити пожар.",
                    label = "Радијус удара",
                },
                waterMonitorStreamMinRange = {
                    description = "Минимална удаљеност снопа када се нишани воденим топом.",
                    label = "Минимални домет",
                },
                waterMonitorStreamProgressPerSecond = {
                    description = "Основна снага при гашењу пожара погођених воденим млазом.",
                    label = "Напредак брисања у секунди",
                },
                waterMonitorStreamRange = {
                    description = "Максимална даљина лета воденог млаза у метрима.",
                    label = "Распон",
                },
                waterMonitorStreamTrajectorySegments = {
                    description = "Број сегмената за израчунавање закривљене путање воде.",
                    label = "Сегменти путање",
                },
                waterMonitorStreamWaterGravityScale = {
                    description = "Одређује колико гравитација савија путању воде наниже.",
                    label = "Гравитационо скалирање",
                },
                waterMonitorStreamWaterLitersPerSecond = {
                    description = "Потрошња воде из прикљученог довода током прскања.",
                    label = "Литара воде у секунди",
                },
                waterMonitorStreamWaterVelocity = {
                    description = "Почетна брзина за израчунавање путање воде.",
                    label = "Брзина воде",
                },
                waterMonitorZOffset = {
                    description = "Вертикална корекција приликом постављања подупирача на тло.",
                    label = "Помак од земље З",
                },
                waterTankEnabled = {
                    description = "Konfiguriert: Резервоар за воду.",
                    label = "Резервоар за воду",
                },
                waterTankSize = {
                    description = "Konfiguriert: литара воде.",
                    label = "литара воде",
                },
                x = {
                    description = "Konfiguriert: Кс.",
                    label = "Кс",
                },
                y = {
                    description = "Konfiguriert: И.",
                    label = "И",
                },
                z = {
                    description = "Konfiguriert: З.",
                    label = "З",
                },
                zOffset = {
                    description = "Вертикални помак тако да резултирајућа ватра уредно лежи на одабраном извору ватре.",
                    label = "Подешавање висине извора ватре",
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
        },
    },
}
