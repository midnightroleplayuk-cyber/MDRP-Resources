JobConfigLocales["sky_ambulancejob:rs"] = {
    Nui = {
        tablet = {
            apps = {
                medicalEvaluations = "Medicinske procene",
                sharedMedicalEvaluations = "Deljene medicinske procene",
            },
        },
        workshopConfig = {
            creatorFields = {
                hospitalBeds = {
                    allowRespawn = {
                        label = "Dozvoli respawn",
                        description = "Kontrolise da li ovaj krevet moze da se koristi za respawn igraca.",
                    },
                },
            },
            configs = {
                sky_ambulancejob = {
                    subtitle = "Конфигуришите послове хитне помоћи, болничке кревете, системе смрти, интеракције и подешавања основних функција.",
                    title = "Амбуланце Јобс",
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
            features = {
                bleeding = {
                    description = "Омогућите систем за крварење.",
                    label = "крварење",
                },
                bodybags = {
                    description = "Омогућите токове испоруке врећа за тело и врећа за тело.",
                    label = "Торбе за тело",
                },
                consciousScenarioBloodPressure = {
                    description = "Дозволите мерење крвног притиска док је пацијент при свести.",
                    label = "Свесни крвни притисак",
                },
                deathTimeout = {
                    description = "Омогућите ток временског ограничења смрти.",
                    label = "Деатх Тимеоут",
                },
                fractures = {
                    description = "Омогућите руковање и лечење прелома.",
                    label = "Преломи",
                },
                knockout = {
                    description = "Омогућите нокаут систем.",
                    label = "Кноцкоут",
                },
                legShotRagdoll = {
                    description = "Играч пада при поготку у подешене зоне ногу или стопала.",
                    label = "Пад након поготка у ногу",
                },
                pain = {
                    description = "Омогућите систем против болова.",
                    label = "Бол",
                },
                respawnInBed = {
                    description = "Респавн је оживео играче у болничком кревету када су доступни.",
                    label = "Респавн Ин Бед",
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
                gang = "Banda",
                allowInVehicle = "Дозволи у возилу",
                allowMovement = "Дозволи кретање",
                animDict = "Речник анимације",
                animFlag = "Ознака анимације",
                animName = "Назив анимације",
                bleeding = "Крварење",
                cause = "Узрок",
                chance = "Шанса",
                class = "Класа",
                companyPrice = "Цена за компанију",
                companyPricePerEmployee = "Цена по запосленом",
                copayPercent = "Цопаи %",
                description = "Опис",
                dictionary = "Речник анимације",
                duration = "Трајање",
                durationMs = "Трајање (ms)",
                effect = "Ефекат",
                effectDurationMs = "Трајање ефекта (ms)",
                effectDurationSeconds = "Трајање ефекта (секунде)",
                enabled = "Укључено",
                extractionType = "Тип уклањања",
                foreignObject = "Страно тело",
                heal = "Лечење",
                id = "ID",
                itemName = "Назив ставке",
                key = "Кључ",
                label = "Лабел",
                lang = "Језик",
                limit = "Ограничење",
                lossPerSecond = "Губитак у секунди",
                max = "Максимум",
                min = "Минимум",
                minGrade = "Мин оцена",
                minigame = "Мини-игра",
                model = "Проп модел",
                name = "Назив посла",
                options = "Опције (изборни типови)",
                pain = "Бол",
                pauseBleedingSeconds = "Паузирај крварење (секунде)",
                price = "Цена",
                progressbarAllowInVehicle = "Напредак: дозволи у возилу",
                progressbarAllowMovement = "Напредак: дозволи кретање",
                progressbarCanCancel = "Напредак се може отказати",
                progressbarDisableCarMovement = "Напредак: забрани кретање возила",
                progressbarDisableCombat = "Напредак: забрани борбу",
                progressbarDisableMouse = "Напредак: забрани миш",
                progressbarDisableMovement = "Напредак: забрани кретање",
                progressbarDisableSprint = "Напредак: забрани трчање",
                progressbarDuration = "Трајање напретка",
                progressbarEnabled = "Трака напретка укључена",
                progressbarLabel = "Текст напретка",
                progressbarUseWhileDead = "Доступно након смрти",
                questions = "Питања",
                requireItems = "Захтевати ставке",
                required = "Неопходно",
                requiresExtraction = "Захтева уклањање",
                requiresOpenWound = "Захтева отворену рану",
                sort = "Редослед",
                state = "Стање",
                stopBleeding = "Заустави крварење",
                threshold = "Праг",
                time = "Време",
                type = "Тип",
                useAnimation = "Користите анимацију",
                value = "Вредност",
                zone = "Зона",
                zones = "Зоне",
                systolic = "Систолни притисак",
                diastolic = "Дијастолни притисак",
                cardiacArrest = "Срчани застој",
            },
            settingGroups = {
                billingGeneral = {
                    label = "генерал",
                },
                billingRange = {
                    label = "Домет",
                },
                billingReasons = {
                    label = "Реасон Пресетс",
                },
                billingUi = {
                    label = "UI",
                },
                bodyBagAnimation = {
                    label = "Анимација",
                },
                bodyBagAttachGeneral = {
                    label = "Приложити",
                },
                bodyBagAttachOffsets = {
                    label = "Оффсетс",
                },
                bodyBagAttachRotation = {
                    label = "Ротација",
                },
                bodyBagDeliveryGeneral = {
                    label = "генерал",
                },
                bodyBagDeliveryRewardGeneral = {
                    label = "генерал",
                },
                bodyBagDeliveryRewardPayment = {
                    label = "Плаћање",
                },
                bodyBagDeliveryUi = {
                    label = "UI",
                },
                bodyBagGeneral = {
                    label = "генерал",
                },
                crutchAssign = {
                    label = "Задатак",
                },
                crutchDuration = {
                    label = "Трајање",
                },
                crutchGeneral = {
                    label = "генерал",
                },
                crutchItems = {
                    label = "Ставка",
                },
                crutchRestrictions = {
                    label = "Ограничења",
                },
                damageHandlingBladeWeapons = {
                    label = "Бладе Веапонс",
                },
                damageHandlingBleedingBlacklist = {
                    label = "Блеединг Блацклист",
                },
                damageHandlingBleedingClasses = {
                    label = "Часови крварења",
                },
                damageHandlingBloodSystem = {
                    label = "Крвни систем",
                },
                damageHandlingDeathInjuries = {
                    label = "Смртне повреде",
                },
                damageHandlingInjuryEffects = {
                    label = "Ефекти повреда",
                },
                damageHandlingInjuryThresholds = {
                    label = "Прагови повреда",
                },
                damageHandlingLegShotRagdoll = {
                    label = "Ragdoll pogodak noge",
                },
                damageHandlingLegShotRagdollZones = {
                    label = "Zone pogodaka noge",
                },
                damageHandlingLiveDamageFractures = {
                    label = "Преломи оштећења на живом",
                },
                damageHandlingLiveDamageFracturesZones = {
                    label = "Зоне Цханцес",
                },
                damageHandlingLiveOpenWoundStacks = {
                    label = "Stekovi otvorenih rana",
                },
                damageHandlingLiveOpenWoundStacksZones = {
                    label = "Ogranicenja zona",
                },
                damageHandlingLiveWoundBleedingClass = {
                    label = "Ливе Воунд Цлассес",
                },
                damageHandlingMedications = {
                    label = "Лекови",
                },
                damageHandlingPainClasses = {
                    label = "Часови бола",
                },
                damageHandlingPainEffects = {
                    label = "Паин Еффецтс",
                },
                damageHandlingStatusEffects = {
                    label = "Статус Еффецтс",
                },
                damageHandlingVehicleDamage = {
                    label = "Оштећење возила",
                },
                damageHandlingVehicleImpactCauses = {
                    label = "Узроци оштећења",
                },
                damageHandlingVehicleImpactInjuries = {
                    label = "Повреде",
                },
                damageHandlingVehicleImpactProtection = {
                    label = "Заштита од удара возила",
                },
                deathAnimal = {
                    label = "Анимал Фаллбацк",
                },
                deathAnimalAnimation = {
                    label = "Анимал Аниматион",
                },
                deathAnimation = {
                    label = "Анимација",
                },
                deathGeneral = {
                    label = "генерал",
                },
                deathModels = {
                    label = "Замена по моделу",
                },
                deathScreenAiMedic = {
                    label = "генерал",
                },
                deathScreenAiMedicAvailability = {
                    label = "Доступност",
                },
                deathScreenAiMedicBehaviour = {
                    label = "Понашање",
                },
                deathScreenAiMedicForceRevive = {
                    label = "Форце Ревиве",
                },
                deathScreenAiMedicPayment = {
                    label = "Плаћање",
                },
                deathScreenAiMedicReviveInBed = {
                    label = "Ревиве Ин Бед",
                },
                deathScreenAiMedicSpawn = {
                    label = "Спавн",
                },
                deathScreenAiMedicTiming = {
                    label = "Тајминг",
                },
                deathScreenControls = {
                    label = "Контроле",
                },
                deathScreenDamageLogs = {
                    label = "Evidencija štete",
                },
                deathScreenDimensions = {
                    label = "Димензије",
                },
                deathScreenDispatch = {
                    label = "Отпремање",
                },
                deathScreenEarlyRespawn = {
                    label = "генерал",
                },
                deathScreenEarlyRespawnAvailability = {
                    label = "Доступност",
                },
                deathScreenEarlyRespawnPayment = {
                    label = "Плаћање",
                },
                deathScreenGeneral = {
                    label = "генерал",
                },
                deathScreenHospitalSelection = {
                    label = "Одабир болнице",
                },
                deathScreenHospitalSelectionCamera = {
                    label = "Селецтион Цамера",
                },
                deathScreenInformation = {
                    label = "генерал",
                },
                deathScreenIntegration = {
                    label = "Интеграција",
                },
                deathScreenLogs = {
                    label = "Evidencija smrti",
                },
                deathScreenMinigame = {
                    label = "Минигаме",
                },
                deathScreenRespawn = {
                    label = "генерал",
                },
                deathScreenRespawnAccounts = {
                    label = "Рачуни",
                },
                deathScreenRespawnFallback = {
                    label = "Фаллбацк Цоордс",
                },
                deathScreenRespawnItems = {
                    label = "Предмети",
                },
                deathScreenRespawnWeapons = {
                    label = "Оружје",
                },
                deathScreenStyle = {
                    label = "Стил екрана смрти",
                },
                deathScreenVoice = {
                    label = "Глас",
                },
                deathTimeoutGeneral = {
                    label = "генерал",
                },
                deathTimeoutWhitelist = {
                    label = "Послови на белој листи",
                },
                diagnoseAnim = {
                    label = "Анимација",
                },
                diagnoseCpr = {
                    label = "CPR",
                },
                diagnoseFullHeal = {
                    label = "Потпуно лечење",
                },
                diagnoseGeneral = {
                    label = "генерал",
                },
                doctorNpcAvailability = {
                    label = "Доступност",
                },
                doctorNpcGeneral = {
                    label = "генерал",
                },
                doctorNpcHealOther = {
                    label = "Хеал Отхер",
                },
                doctorNpcHealSelf = {
                    label = "Хеал Селф",
                },
                doctorNpcRanges = {
                    description = "Ови распони не контролишу колико близу играч мора бити да би отворио интеракцију НПЦ доктора. Примењују се тек након што се отвори мени доктора.",
                    label = "Распони",
                },
                doctorNpcRevive = {
                    label = "Ревиве",
                },
                doctorNpcReviveInBed = {
                    label = "Ревиве Ин Бед",
                },
                firstAidAnimation = {
                    label = "Анимација",
                },
                firstAidGeneral = {
                    label = "генерал",
                },
                firstAidLicenseAdd = {
                    label = "Лиценца Адд",
                },
                firstAidLicenseRemove = {
                    label = "Уклони лиценцу",
                },
                firstAidPosition = {
                    label = "Положај",
                },
                healthInsuranceExpiration = {
                    label = "Истек",
                },
                healthInsuranceGeneral = {
                    label = "генерал",
                },
                healthInsurancePayment = {
                    label = "Плаћање",
                },
                healthInsuranceProviders = {
                    label = "Провајдери",
                },
                hospitalBedsBedAnimation = {
                    label = "Бед Аниматион",
                },
                hospitalBedsCreator = {
                    label = "Креатор",
                },
                hospitalBedsDistances = {
                    label = "Удаљености",
                },
                hospitalBedsGeneral = {
                    label = "генерал",
                },
                hospitalBedsGetupAnimation = {
                    label = "Гетуп Аниматион",
                },
                hospitalBedsModels = {
                    label = "Модели",
                },
                hospitalBedsOffsets = {
                    label = "Оффсетс",
                },
                hospitalBlip = {
                    label = "Хоспитал Блип",
                },
                imagingGeneral = {
                    label = "генерал",
                },
                imagingRanges = {
                    label = "Распони",
                },
                keybinds = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Prečice",
                },
                knockoutGeneral = {
                    label = "генерал",
                },
                knockoutWeapons = {
                    label = "Оружје",
                },
                medicCarryAttach = {
                    label = "Приложити",
                },
                medicCarryAttachOffsets = {
                    label = "Оффсетс",
                },
                medicCarryAttachRotation = {
                    label = "Ротација",
                },
                medicCarryCarrierAnimation = {
                    label = "Царриер Аниматион",
                },
                medicCarryGeneral = {
                    label = "генерал",
                },
                medicCarryPassengerAnimation = {
                    label = "Пассенгер Аниматион",
                },
                medicCarryRestrictions = {
                    label = "Ограничења",
                },
                medicRevivePersistence = {
                    label = "генерал",
                },
                medicalEvaluationRecipients = {
                    label = "Професије примаоца",
                },
                medicalEvaluationSharing = {
                    label = "Д› ијељена поља",
                },
                medicalEvaluationTypes = {
                    label = "Типови процењивања",
                },
                medicalEvaluationsGeneral = {
                    label = "генерал",
                },
                medicalWearablesArmRestrictions = {
                    label = "Ogranicenja gipsa na ruci",
                },
                medicalWearablesCasts = {
                    label = "Gipsevi",
                },
                medicalWearablesDuration = {
                    label = "Trajanje nosenja",
                },
                medicalWearablesGeneral = {
                    label = "Opste",
                },
                medicalWearablesHeadBandage = {
                    label = "Zavoj za glavu",
                },
                medicalWearablesLegRestrictions = {
                    label = "Ogranicenja gipsa na nozi",
                },
                medicalWearablesNeckBrace = {
                    label = "Vratna kragna",
                },
                medicalWearablesOxygenMask = {
                    label = "Maska sa kiseonikom",
                },
                medicalWearablesPatientHud = {
                    label = "HUD pacijenta",
                },
                medicalWearablesRemoval = {
                    label = "Uklanjanje",
                },
                medicalWearablesSplints = {
                    label = "Udlage",
                },
                medicalWearablesTorsoBandage = {
                    label = "Zavoj za torzo",
                },
                minigamesCprGeneral = {
                    label = "генерал",
                },
                minigamesEnabled = {
                    label = "Омогућено",
                },
                minigamesVentilationGeneral = {
                    label = "генерал",
                },
                operationsAnesthesia = {
                    label = "Anestezija",
                },
                operationsDistances = {
                    label = "Udaljenosti",
                },
                operationsDoctorAnimation = {
                    label = "Animacija hirurga",
                },
                operationsGeneral = {
                    label = "Opšte",
                },
                operationsPatientAnimation = {
                    label = "Animacija pacijenta",
                },
                operationsTrainingAnimation = {
                    label = "Animacija obuke",
                },
                propPlacement = {
                    label = "Проп Плацемент",
                },
                propPlacementItems = {
                    label = "Проп Итемс",
                },
                publicTreatmentGeneral = {
                    label = "генерал",
                },
                publicTreatmentJobs = {
                    label = "Дозвољени послови",
                },
                publicTreatmentRequirements = {
                    label = "Захтеви",
                },
                reviveRewardGeneral = {
                    label = "генерал",
                },
                reviveRewardPayment = {
                    label = "Плаћање",
                },
                selfDiagnoseGeneral = {
                    label = "генерал",
                },
                stretcherAnimation = {
                    label = "Анимација",
                },
                stretcherCarryAttach = {
                    label = "Царри Аттацх",
                },
                stretcherFolded = {
                    label = "Преклопљена варијанта",
                },
                stretcherFoldedPatientAttach = {
                    label = "Преклопљени додатак за пацијенте",
                },
                stretcherGeneral = {
                    label = "генерал",
                },
                stretcherHelicopter = {
                    label = "Хеликоптер",
                },
                stretcherPatientAttach = {
                    label = "Патиент Аттацх",
                },
                stretcherTreatmentAnim = {
                    label = "Анимација",
                },
                stretcherVehicleAttach = {
                    label = "Вехицле Аттацх",
                },
                stretcherVehicleLists = {
                    label = "Модели возила",
                },
                treatmentAnim = {
                    label = "Анимација",
                },
                treatmentEnable = {
                    label = "Омогући",
                },
                trunk = {
                    label = "Трунк",
                },
                vehiclePullGeneral = {
                    label = "генерал",
                },
                wheelchairAssign = {
                    label = "Задатак",
                },
                wheelchairDuration = {
                    label = "Трајање",
                },
                wheelchairGeneral = {
                    label = "генерал",
                },
                wheelchairItems = {
                    label = "Ставка",
                },
                wheelchairRestrictions = {
                    label = "Ограничења",
                },
                xrayGeneral = {
                    label = "генерал",
                },
                xrayRanges = {
                    label = "Распони",
                },
                appointmentsGeneral = {
                    label = "генерал",
                },
                appointmentsLimits = {
                    label = "Ograničenja",
                },
                appointmentsNotifications = {
                    label = "Обавештења",
                },
                appointmentsScheduling = {
                    label = "Распоред",
                },
                healthCompatibility = {
                    label = "здравствена компатибилност",
                },
                minigamesBloodTransfusionGeneral = {
                    label = "генерал",
                },
                minigamesRandomization = {
                    label = "Рандомизација",
                },
            },
            settingSections = {
                billing = "Наплата",
                bodyBag = "Боди Баг",
                damageHandling = "Управљање оштећењем",
                death = "Деатх",
                deathScreen = "Деатх Сцреен",
                diagnose = "Дијагноза",
                doctorNpc = "Доцтор НПЦ",
                general = "генерал",
                healthInsurance = "Здравствено осигурање",
                hospitalBeds = "Болнички кревети",
                knockout = "Кноцкоут",
                medicCarry = "Медиц Царри",
                minigames = "Мини игре",
                mobilityAid = "Мобилити Аидс",
                operations = "Operacije",
                organization = "Организација",
                rewards = "Награде",
                treatment = "Третман",
                vehiclePull = "Вехицле Пулл",
            },
            settingSubsections = {
                aiMedic = "АИ Медиц",
                anesthesia = "Anestezija",
                animation = "Анимација",
                animations = "Animacije",
                attach = "Приложити",
                bedAnimation = "Бед Аниматион",
                blood = "Крв",
                bodyBagDeliveryReward = "Награда за испоруку торбе за тело",
                carrierAnimation = "Царриер Аниматион",
                classification = "Класификација",
                cpr = "CPR",
                crutch = "Штака",
                deathInjuries = "Смртне повреде",
                deathScreenStyle = "Стил екрана смрти",
                deathTimeout = "Деатх Тимеоут",
                delivery = "Испорука",
                diagnoseAnim = "Дијагностицирајте анимацију",
                dispatch = "Отпремање",
                earlyRespawn = "Еарли Респавн",
                effects = "Ефекти",
                firstAid = "Прва помоћ",
                general = "генерал",
                getupAnimation = "Гетуп Аниматион",
                imaging = "Имагинг",
                information = "Информације",
                keybinds = "Prečice",
                liveDamage = "Ливе Дамаге",
                logs = "Evidencija",
                medicRevivePersistence = "Медиц Ревиве Персистенце",
                medicalEvaluations = "Medicinske procene",
                medicalWearables = "Medicinska pomagala",
                medications = "Лекови",
                minigame = "Минигаме",
                passengerAnimation = "Пассенгер Аниматион",
                pricing = "Прицинг",
                propPlacement = "Проп Плацемент",
                publicTreatment = "Јавни третман",
                respawn = "Респавн",
                reviveInBed = "Ревиве Ин Бед",
                reviveReward = "Ревиве Ревард",
                selfDiagnose = "Селф Диагносе",
                stretcher = "Носила",
                stretcherTreatmentAnim = "Анимација лечења носилима",
                thresholds = "Прагови",
                treatmentAnim = "Треатмент Аниматион",
                trunk = "Трунк",
                vehicleImpact = "Вехицле Импацт",
                ventilation = "Вентилација",
                wheelchair = "инвалидска колица",
                xray = "Икс‐ зрак",
                appointments = "Поставке",
                bloodTransfusion = "Трансфузија крви",
            },
            settings = {
                ambulanceEditorControl172 = {
                    label = "Uređivač: Pomeri gore",
                    description = "Konfiguriert: Uređivač: Pomeri gore.",
                },
                ambulanceEditorControl173 = {
                    label = "Uređivač: Pomeri dole",
                    description = "Konfiguriert: Uređivač: Pomeri dole.",
                },
                ambulanceEditorControl174 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 174",
                },
                ambulanceEditorControl175 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 175",
                },
                ambulanceEditorControl177 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 177",
                },
                ambulanceEditorControl201 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 201",
                },
                ambulanceEditorControl202 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 202",
                },
                ambulanceEditorControl21 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 21",
                },
                ambulanceEditorControl32 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 32",
                },
                ambulanceEditorControl33 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 33",
                },
                ambulanceEditorControl34 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 34",
                },
                ambulanceEditorControl35 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 35",
                },
                ambulanceEditorControl36 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 36",
                },
                ambulanceEditorControl37 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 37",
                },
                ambulanceEditorControl38 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 38",
                },
                ambulanceEditorControl44 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Uređivač · Kontrola 44",
                },
                ambulanceFirstAidControl38 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Prva pomoć · Kontrola 38",
                },
                ambulanceStretcherEditorControl177 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Interakcija · Kontrola 177",
                },
                ambulanceStretcherEditorControl201 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Interakcija · Kontrola 201",
                },
                ambulanceStretcherEditorControl202 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Interakcija · Kontrola 202",
                },
                ambulanceStretcherEditorControl21 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Interakcija · Kontrola 21",
                },
                ambulanceStretcherEditorControl241 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Interakcija · Kontrola 241",
                },
                ambulanceStretcherEditorControl242 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Interakcija · Kontrola 242",
                },
                ambulanceStretcherEditorControl25 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Interakcija · Kontrola 25",
                },
                ambulanceStretcherEditorControl32 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Interakcija · Kontrola 32",
                },
                ambulanceStretcherEditorControl33 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Interakcija · Kontrola 33",
                },
                ambulanceStretcherEditorControl34 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Interakcija · Kontrola 34",
                },
                ambulanceStretcherEditorControl35 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Interakcija · Kontrola 35",
                },
                ambulanceStretcherEditorControl36 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Interakcija · Kontrola 36",
                },
                ambulanceStretcherEditorControl38 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Interakcija · Kontrola 38",
                },
                ambulanceStretcherEditorControl44 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Interakcija · Kontrola 44",
                },
                billingAccount = {
                    description = "Застарели резервни друштвени налог који се користи за обрачун.",
                    label = "Рачун",
                },
                billingCloseOnSuccess = {
                    description = "Аутоматски затворите кориснички интерфејс за обрачун након успешног обрачуна.",
                    label = "Близу успеха",
                },
                billingCurrency = {
                    description = "Опциони кључ валуте који се користи за плаћања.",
                    label = "Валута",
                },
                billingCustomBillingReasons = {
                    description = "Дозволите лекарима да унесу прилагођене разлоге за обрачун.",
                    label = "Прилагођени разлози",
                },
                billingDepositToSociety = {
                    description = "Уплатите приход од наплате на рачун друштва.",
                    label = "Депозит друштву",
                },
                billingEnabled = {
                    description = "Омогућите медицински систем наплате.",
                    label = "Омогућено",
                },
                billingMaxReasonLength = {
                    description = "Максимална дужина прилагођених разлога за обрачун.",
                    label = "Максимална дужина разлога",
                },
                billingMode = {
                    description = "Одаберите да ли се медицински рачуни наплаћују одмах, да ли је потребна потврда или да ли користите оквирни систем наплате.",
                    label = "Режим наплате",
                    options = {
                        consent = "Плати или одбиј",
                        framework = "Оквирни закон",
                        instant = "Тренутна наплата",
                    },
                },
                billingRange = {
                    description = "Максимални домет за проналажење наплативих пацијената.",
                    label = "Домет",
                },
                billingReasonPresets = {
                    description = "Унапред подешени разлози за обрачун приказани у корисничком интерфејсу за обрачун.",
                    itemLabel = "Разлог",
                    label = "Подешавање разлога",
                },
                billingRefreshSeconds = {
                    description = "Секунде између освежавања наплативог играча.",
                    label = "Освежите секунде",
                },
                bladeWeapons = {
                    description = "Називи оружја или хешеви које треба класификовати као оштећење ножем уместо као тупо.",
                    itemLabel = "Оружје",
                    label = "Оружје са оштрицама",
                },
                bleedingBlacklist = {
                    description = "Оружје које никада не би требало да изазове живо крварење или отворене ране.",
                    itemLabel = "Оружје",
                    label = "Црна листа за крварење",
                },
                bleedingClassesProfiles = {
                    description = "Профили тежине крварења и њихова стопа губитка крви.",
                    label = "Часови крварења",
                },
                bloodSystemDebugLogInterval = {
                    description = "Секунде између порука дневника отклањања грешака у систему крви.",
                    label = "Интервал дневника отклањања грешака",
                },
                bloodSystemMaxVolume = {
                    description = "Максимална вредност запремине крви коју користи систем стања пацијента.",
                    label = "Мак волуме",
                },
                bloodSystemRegenPerSecond = {
                    description = "Пасивна регенерација крви се примењује када пацијент не крвари активно.",
                    label = "Реген у секунди",
                },
                bloodSystemTickIntervalMs = {
                    description = "Серверски интервал који се користи за ажурирање губитка крви и опоравка.",
                    label = "Тицк интервал мс",
                },
                bloodSystemUnconsciousThreshold = {
                    description = "Праг запремине крви испод којег пацијент губи свест.",
                    label = "Несвесни праг",
                },
                bodyBagAnimationDict = {
                    description = "Речник анимације који се користи за ношење торбе за тело.",
                    label = "Речник анимације",
                },
                bodyBagAnimationEnabled = {
                    description = "Користите наменску анимацију за ношење док носите торбу за тело.",
                    label = "Омогућено",
                },
                bodyBagAnimationFlag = {
                    description = "ТаскПлаиАним заставица која се користи за анимацију ношења.",
                    label = "Застава анимације",
                },
                bodyBagAnimationName = {
                    description = "Анимирани клип који се користи за ношење торбе за тело.",
                    label = "Назив анимације",
                },
                bodyBagAttachBone = {
                    description = "Назив Пед кости или ИД кости који се користи за причвршћивање вреће за тело.",
                    label = "Боне",
                },
                bodyBagAttachRx = {
                    description = "Торба за тело причвршћује Кс ротацију.",
                    label = "Приложите РКС",
                },
                bodyBagAttachRy = {
                    description = "Торба за тело се причвршћује И ротацијом.",
                    label = "Приложите РИ",
                },
                bodyBagAttachRz = {
                    description = "Торба за тело се причвршћује З ротацијом.",
                    label = "Приложите РЗ",
                },
                bodyBagAttachX = {
                    description = "Торба за тело се причвршћује Кс оффсет.",
                    label = "Приложите Кс",
                },
                bodyBagAttachY = {
                    description = "Торба за тело се причвршћује И оффсет.",
                    label = "Приложите И",
                },
                bodyBagAttachZ = {
                    description = "Торба за тело се причвршћује З оффсет.",
                    label = "Приложити З",
                },
                bodyBagDeliveryHelpLabelKey = {
                    description = "Локални кључ који се користи за упит за помоћ при одласку торбе за тело.",
                    label = "Кључ ознаке помоћи",
                },
                bodyBagDeliveryInteractDistance = {
                    description = "Раздаљина која се користи за валидацију одлагања вреће за тело.",
                    label = "Удаљеност интеракције",
                },
                bodyBagDeliveryInteractKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Predaja vreće za telo",
                },
                bodyBagDeliveryInteraction = {
                    description = "Кључ шаблона за интеракцију који се користи за одлагање врећа за тело.",
                    label = "Шаблон за интеракцију",
                },
                bodyBagDeliveryRequireDropOff = {
                    description = "Захтевајте од лекара да предају кесе са лешевима на конфигурисаним местима за предају.",
                    label = "Захтевати одлазак",
                },
                bodyBagDeliveryRequireOnDuty = {
                    description = "Захтевати да лекари буду на дужности пре испоруке торбе за тело.",
                    label = "Захтевати на дужности",
                },
                bodyBagDeliveryRewardAccount = {
                    description = "Примарни кључ налога који се користи за награде за испоруку торбе за тело.",
                    label = "Рачун",
                },
                bodyBagDeliveryRewardAccountType = {
                    description = "Примарни тип налога који се користи за награде за испоруку торбе за тело.",
                    label = "Тип налога",
                },
                bodyBagDeliveryRewardAmount = {
                    description = "Износ награде плаћен за испоруку торбе за тело.",
                    label = "Износ",
                },
                bodyBagDeliveryRewardCurrency = {
                    description = "Опциони прилагођени кључ валуте који се користи за награде за испоруку торбе за тело.",
                    label = "Валута",
                },
                bodyBagDeliveryRewardEnabled = {
                    description = "Платите конфигурисану награду након што се достава торбе за тело заврши.",
                    label = "Омогућено",
                },
                bodyBagDeliveryRewardPayFromSociety = {
                    description = "Пре него што платите лекару, одузмите награде за испоруку торбе за тело од заједничког посла.",
                    label = "Плати од друштва",
                },
                bodyBagEnabled = {
                    description = "Омогућите систем врећа за тело.",
                    label = "Омогућено",
                },
                bodyBagHidePatient = {
                    description = "Сакријте пацијента док је торба за тело причвршћена.",
                    label = "Сакриј пацијента",
                },
                bodyBagModel = {
                    description = "Модел реквизита који се користи за торбе за тело.",
                    label = "Модел",
                },
                bodyBagPatientAlpha = {
                    description = "Алфа се примењује на пацијента док је у врећи са телом.",
                    label = "Пацијент алфа",
                },
                crutchAssignMaxDistance = {
                    description = "Максимална удаљеност за додељивање штаке другом играчу.",
                    label = "Додели максималну удаљеност",
                },
                crutchAutoUnequipOnExpire = {
                    description = "Аутоматски искључите штаку када задатак истекне.",
                    label = "Ауто деекуип он екпире",
                },
                crutchClipset = {
                    description = "Клипсет за кретање се примењује док користите штаку.",
                    label = "Цлипсет",
                },
                crutchDefaultDurationMinutes = {
                    description = "Подразумевано додељено трајање штаке у минутима.",
                    label = "Подразумевано трајање",
                },
                crutchDisableSprint = {
                    description = "Блок спринт док је опремљена штака.",
                    label = "Онемогући спринт",
                },
                crutchDisableWeapons = {
                    description = "Блокирајте употребу оружја док је опремљена штака.",
                    label = "Онемогућите оружје",
                },
                crutchItemName = {
                    description = "Инвентар који се користи за штаку.",
                    label = "Назив ставке",
                },
                crutchMaxDurationMinutes = {
                    description = "Максимално дозвољено трајање задатка штака у минутима.",
                    label = "Максимално трајање",
                },
                crutchMinDurationMinutes = {
                    description = "Минимално дозвољено трајање задатка штака у минутима.",
                    label = "Мин. трајање",
                },
                crutchProp = {
                    description = "Модел подупирача који се користи за штаку.",
                    label = "Проп",
                },
                damageLogBatchIntervalSeconds = {
                    description = "Sekunde tokom kojih se pojedinačni pogoci skupljaju u jednu poruku.",
                    label = "Interval grupisanja",
                },
                damageLogMaxEntriesPerMessage = {
                    description = "Maksimalan broj pojedinačnih pogodaka u Discord poruci.",
                    label = "Pogodaka po poruci",
                },
                damageLogsEnabled = {
                    description = "Pošalji na Discord serverom potvrđene nesmrtonosne pogotke.",
                    label = "Evidencija štete",
                },
                deathAnimalAnimationDictionary = {
                    description = "Речник анимације који се користи за резервну анимацију смрти животиње.",
                    label = "Речник животиња",
                },
                deathAnimalAnimationName = {
                    description = "Анимирани клип који се користи за анимацију смрти животиње.",
                    label = "Назив анимације животиње",
                },
                deathAnimalUseAnimation = {
                    description = "Дозволите конфигурисаној резервној животињи да користи скриптовану анимацију смрти.",
                    label = "Аниматион Анимал",
                },
                deathAnimationDictionary = {
                    description = "Речник анимације који се користи за подразумевану анимацију смрти.",
                    label = "Речник анимације",
                },
                deathAnimationName = {
                    description = "Клип анимације који се користи за подразумевану анимацију смрти.",
                    label = "Назив анимације",
                },
                deathInjuriesProfiles = {
                    description = "Профили повреда се примењују када играч умре од одређеног узрока.",
                    itemLabel = "Повреда",
                    label = "Смртоносне повреде",
                },
                deathModels = {
                    description = "Замени понашање анимације смрти по моделу пед или хеш модела.",
                    label = "Модел надјачава",
                },
                deathScreenAiMedicAccount = {
                    description = "Примарни рачун наплаћен за АИ медицинара.",
                    label = "Рачун",
                },
                deathScreenAiMedicAddDeathTimerSeconds = {
                    description = "Секунде се додају у тајмер за испуштање када се затражи АИ медицинар.",
                    label = "Додајте тајмер смрти",
                },
                deathScreenAiMedicAllowFatalWounds = {
                    description = "Дозволите АИ медицинару да оживи смртоносне ране.",
                    label = "Дозволите смртоносне ране",
                },
                deathScreenAiMedicApproachDistance = {
                    description = "Удаљеност на којој АИ медицинар стаје и прилази пешке.",
                    label = "Прилазно растојање",
                },
                deathScreenAiMedicCooldownSeconds = {
                    description = "Хлађење пре него што АИ медицинар поново буде позван.",
                    label = "Хлађење секунди",
                },
                deathScreenAiMedicCurrency = {
                    description = "Опциони кључ валуте који се користи за плаћања АИ лекарима.",
                    label = "Валута",
                },
                deathScreenAiMedicCurrencyFormatter = {
                    description = "Форматер валуте који се користи за плаћања лекарима АИ.",
                    label = "Форматер валуте",
                },
                deathScreenAiMedicDespawnDelaySeconds = {
                    description = "Секунде пре него што АИ медицинар нестане након што заврши.",
                    label = "Деспавн кашњење",
                },
                deathScreenAiMedicDispatchDelaySeconds = {
                    description = "Кашњење пре него што почне слање АИ лекара.",
                    label = "Одлагање отпреме",
                },
                deathScreenAiMedicDriveSpeed = {
                    description = "Брзина вожње коју користи АИ медицинско возило.",
                    label = "Брзина вожње",
                },
                deathScreenAiMedicDriveTimeoutSeconds = {
                    description = "Максимално време вожње пре активирања оживљавања силе.",
                    label = "Време истека диска",
                },
                deathScreenAiMedicEnabled = {
                    description = "Омогућите ток спасавања АИ медицинара.",
                    label = "Омогућено",
                },
                deathScreenAiMedicFallbackAccount = {
                    description = "Резервни налог се користи када примарни АИ медицински рачун нема довољно средстава.",
                    label = "Резервни налог",
                },
                deathScreenAiMedicForceReviveEnabled = {
                    description = "Присилите оживљавање ако АИ медицинар не може доћи до играча.",
                    label = "Присилно оживљавање је омогућено",
                },
                deathScreenAiMedicMaxMedicsOnline = {
                    description = "АИ медицинар ради само док су дежурни медицинари на или испод овог броја.",
                    label = "Мак медицс онлине",
                },
                deathScreenAiMedicMissionTimeoutSeconds = {
                    description = "Максимално трајање мисије пре активирања оживљавања силе.",
                    label = "Истекање мисије",
                },
                deathScreenAiMedicPedModel = {
                    description = "Пед модел који се користи за АИ медицинара.",
                    label = "Пед модел",
                },
                deathScreenAiMedicPlayerRequestMode = {
                    description = "Одредиште када оборени играч сам позове АИ медицинара.",
                    label = "Одредиште захтева играча",
                    options = {
                        hospital = "Болница",
                        location = "Тренутна локација",
                    },
                },
                deathScreenAiMedicPrice = {
                    description = "Цена се наплаћује за позивање АИ медицинара.",
                    label = "Цена",
                },
                deathScreenAiMedicRemoteDispatchDelaySeconds = {
                    description = "Секунде од смрти играча пре него што медицинар може да понуди удаљеног АИ медицинара.",
                    label = "Чекање на даљинско слање",
                },
                deathScreenAiMedicRemoteDispatchEnabled = {
                    description = "Дозволите медицинарима да пошаљу АИ медицинара обореном играчу са мапе отпреме и команде /аимедиц.",
                    label = "Даљинско отпремање",
                },
                deathScreenAiMedicRemoteDispatchMaxMedicsOnline = {
                    description = "Даљинско слање АИ медицинара функционише само док су дежурни медицинари на или испод овог броја.",
                    label = "Даљинско слање мак медицс онлине",
                },
                deathScreenAiMedicRemoteDispatchMode = {
                    description = "Одредиште када је удаљени АИ медицинар послат и прихваћен.",
                    label = "Одредиште даљинског слања",
                    options = {
                        hospital = "Болница",
                        location = "Тренутна локација",
                    },
                },
                deathScreenAiMedicRemoteOfferTimeoutSeconds = {
                    description = "Секунде током којих играч може да прихвати понуду удаљеног АИ медицинара.",
                    label = "Истек удаљене понуде",
                },
                deathScreenAiMedicReviveDistance = {
                    description = "Потребно је растојање пре него што АИ медицинар почне да се оживљава.",
                    label = "Оживите дистанцу",
                },
                deathScreenAiMedicReviveDurationSeconds = {
                    description = "Секунде утрошене на оживљавање играча.",
                    label = "Трајање оживљавања",
                },
                deathScreenAiMedicReviveInBedEnabled = {
                    description = "Телепортујте играча у болнички кревет уместо да се оживљавате на лицу места.",
                    label = "Оживите у кревету",
                },
                deathScreenAiMedicReviveInBedSearchRadius = {
                    description = "Радијус претраге се користи за проналажење кревета за оживљавање.",
                    label = "Радијус претраге кревета",
                },
                deathScreenAiMedicSecondsTillAvailable = {
                    description = "Неколико секунди након смрти пре него што АИ медицинар постане доступан.",
                    label = "Неколико секунди до доступности",
                },
                deathScreenAiMedicSpawnRadiusMax = {
                    description = "Максимални радијус покретања АИ медицинара.",
                    label = "Радијус мријеста мак",
                },
                deathScreenAiMedicSpawnRadiusMin = {
                    description = "Минимални радијус покретања АИ медицинара.",
                    label = "Радијус мријеста мин",
                },
                deathScreenAiMedicVehicleModel = {
                    description = "Модел возила који користи АИ медицинар.",
                    label = "Модел возила",
                },
                deathScreenAllowVoiceWhileUnconscious = {
                    description = "Режим гласа у несвести: нема, слушај или пун.",
                    label = "Режим гласа",
                    options = {
                        full = "пуна",
                        listen = "слушај",
                        none = "ниједан",
                    },
                },
                deathScreenAllowedControls = {
                    description = "Контролни ИД-ови који остају укључени док су несвесни.",
                    label = "Дозвољене контроле",
                },
                deathScreenAutoRespawnOnExpiredReconnect = {
                    description = "Аутоматски поново покрећу играче ако је тајмер за испуштање већ истекао док је искључен.",
                    label = "Аутоматско поновно појављивање је истекло поновно повезивање",
                },
                deathScreenBackgroundEnd = {
                    description = "Крајња боја позадине екрана смрти.",
                    label = "Крај позадине",
                },
                deathScreenBackgroundStart = {
                    description = "Почетна боја позадине екрана смрти.",
                    label = "Почетак у позадини",
                },
                deathScreenBleedOutTimerSeconds = {
                    description = "Неколико секунди пре истека тајмера за испуштање.",
                    label = "Тајмер за испуштање",
                },
                deathScreenBlockedDimensions = {
                    description = "Димензије у којима је ток поновног покретања екрана смрти блокиран.",
                    label = "Блокиране димензије",
                },
                deathScreenBorderColor = {
                    description = "Боја ивице коју користи екран смрти.",
                    label = "Боја ивице",
                },
                deathScreenDispatchEnabled = {
                    description = "Пошаљите догађаје отпреме из тока екрана смрти.",
                    label = "Отпремање омогућено",
                },
                deathScreenDispatchFallbackJobs = {
                    description = "Zamenski primaoci kada nijedan primarni primalac nije živ i na dužnosti. Ostavite prazno da se uvek obaveštavaju primarni poslovi.",
                    itemLabel = "Posao",
                    label = "Rezervni poslovi",
                },
                deathScreenDispatchJobs = {
                    description = "Послови који се алармирају када онеспособљени играч затражи помоћ.",
                    itemLabel = "Посао",
                    label = "Алармирани послови",
                },
                deathScreenEarlyRespawnAccount = {
                    description = "Примарни налог је наплаћен за рано поновно покретање.",
                    label = "Рачун",
                },
                deathScreenEarlyRespawnAllowFatalWounds = {
                    description = "Нека рано оживљавање буде доступно чак и за смртоносне ране.",
                    label = "Дозволите смртоносне ране",
                },
                deathScreenEarlyRespawnCurrency = {
                    description = "Опциони кључ валуте који се користи за раније исплате.",
                    label = "Валута",
                },
                deathScreenEarlyRespawnCurrencyFormatter = {
                    description = "Форматер валуте који се користи за рано поновно покретање плаћања.",
                    label = "Форматер валуте",
                },
                deathScreenEarlyRespawnEnabled = {
                    description = "Омогући плаћено рано поновно појављивање.",
                    label = "Омогућено",
                },
                deathScreenEarlyRespawnFallbackAccount = {
                    description = "Резервни налог се користи када примарни налог нема довољно средстава.",
                    label = "Резервни налог",
                },
                deathScreenEarlyRespawnPaymentLabel = {
                    description = "Опциона ознака је приказана за плаћање ранијег поновног покретања.",
                    label = "Ознака плаћања",
                },
                deathScreenEarlyRespawnPrice = {
                    description = "Цена се наплаћује за рано поновно појављивање.",
                    label = "Цена",
                },
                deathScreenEarlyRespawnRequireNoMedics = {
                    description = "Дозволите рано поновно појављивање само када лекари нису на дужности.",
                    label = "Не захтевају лекаре",
                },
                deathScreenEarlyRespawnSecondsTillAvailable = {
                    description = "Неколико секунди након смрти пре него што постане доступно рано поновно појављивање.",
                    label = "Неколико секунди до доступности",
                },
                deathScreenEnableKeyboard = {
                    description = "Дозволите коришћење тастатуре на екрану смрти.",
                    label = "Омогући тастатуру",
                },
                deathScreenExternalVoiceSystem = {
                    description = "Спољни гласовни позадински уређај за искључивање звука када је омогућен.",
                    label = "Екстерни гласовни систем",
                    options = {
                        saltychat = "салтицхат",
                        yaca = "иаца",
                    },
                },
                deathScreenFocusKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Ekran smrti: interakcija mišem",
                },
                deathScreenHandlingMode = {
                    description = "Користи статичну анимацију смрти или задржава природну ragdoll физику док се тело не стабилизује.",
                    label = "Обрада смрти",
                    options = {
                        natural = "Природно",
                        static = "Статично",
                    },
                },
                deathScreenHideOverlayWithoutFocus = {
                    description = "Сакрива екран смрти када SPACE пребаци на контроле игре; онемогућите ову опцију да задржите претходни видљиви приказ.",
                    label = "Сакриј приказ при контролама игре",
                },
                deathScreenHospitalSelectionCameraFocusHeight = {
                    description = "Помак висине примењен на циљ фокуса камере.",
                    label = "Висина фокуса",
                },
                deathScreenHospitalSelectionCameraFov = {
                    description = "Преглед видног поља камере.",
                    label = "Видно поље",
                },
                deathScreenHospitalSelectionCameraHeadingOffset = {
                    description = "Помак смера који се користи приликом постављања камере за преглед.",
                    label = "Одступање курса",
                },
                deathScreenHospitalSelectionCameraHeight = {
                    description = "Померање висине примењено на камеру за преглед.",
                    label = "Висина камере",
                },
                deathScreenHospitalSelectionCameraPitch = {
                    description = "Висина примењена на камеру за преглед.",
                    label = "Питцх",
                },
                deathScreenHospitalSelectionCameraRadius = {
                    description = "Удаљеност од камере за преглед до тачке појављивања.",
                    label = "Радијус камере",
                },
                deathScreenHospitalSelectionCameraTransition = {
                    description = "Користите глатки прелаз када отварате камеру за избор болнице.",
                    label = "Глатка транзиција",
                },
                deathScreenHospitalSelectionEnabled = {
                    description = "Дозволите играчима да изаберу болницу пре него што се поново покрену.",
                    label = "Избор болнице",
                },
                deathScreenHospitalSelectionRequireMultipleHospitals = {
                    description = "Прикажи избор болнице само када постоји више од једне болнице.",
                    label = "Захтева више болница",
                },
                deathScreenInformationEnabled = {
                    description = "Прикажи блок информација на екрану смрти.",
                    label = "Омогућено",
                },
                deathScreenInformationShowDeathCause = {
                    description = "Прикажи узрок смрти у информационом блоку екрана смрти.",
                    label = "Покажи узрок смрти",
                },
                deathScreenInformationShowInjuries = {
                    description = "Прикажите повреде у блоку информација на екрану смрти.",
                    label = "Покажите повреде",
                },
                deathScreenInformationShowKiller = {
                    description = "Прикажи име убице у информационом блоку екрана смрти.",
                    label = "Покажи убицу",
                },
                deathScreenInformationShowWeapon = {
                    description = "Покажите оружје у информационом блоку екрана смрти.",
                    label = "Покажи оружје",
                },
                deathScreenInformationWhitelistedGangs = {
                    label = "Bande na beloj listi",
                    description = "Izaberi interne nazive bandi ili nezavisnih organizacija. Odgovarajući posao ili banda daje dozvolu ili izuzetak. Dužnost je obavezna samo za poslove.",
                    itemLabel = "Banda",
                },
                deathScreenInformationWhitelistedJobs = {
                    description = "Пословима је дозвољено да виде проширене информације на екрану о смрти.",
                    itemLabel = "Јоб",
                    label = "Послови на белој листи",
                },
                deathScreenLogScreenshotTimeoutSeconds = {
                    description = "Maksimalan broj sekundi za otpremanje svakog snimka smrti.",
                    label = "Vreme za snimak",
                },
                deathScreenLogScreenshots = {
                    description = "Otpremi pogled žrtve i potvrđenog ubice nakon tekstualnog zapisa.",
                    label = "Snimci ekrana",
                },
                deathScreenLogsEnabled = {
                    description = "Pošalji Discord zapis svaki put kada igrač umre.",
                    label = "Evidencija smrti",
                },
                deathScreenMedicNearbyRadius = {
                    description = "Раздаљина у метрима која се користи за рачунање лекара у близини.",
                    label = "Медиц у близини радијуса",
                },
                deathScreenMinigameEnabled = {
                    description = "Омогућите мини игру екрана смрти.",
                    label = "Омогућено",
                },
                deathScreenMinigameUrl = {
                    description = "УРЛ је отворен за мини игру екрана смрти.",
                    label = "УРЛ мини игре",
                },
                deathScreenMode = {
                    description = "Користи уграђени екран смрти или спољну интеграцију.",
                    label = "Режим екрана",
                    options = {
                        external = "Спољни",
                        internal = "Интерни",
                    },
                },
                deathScreenMuteExternalVoiceOnDeath = {
                    description = "Искључите звук спољашњих гласовних система док је плејер мртав.",
                    label = "Искључите спољни глас",
                },
                deathScreenMutedTextColor = {
                    description = "Искључена боја текста коју користи екран смрти.",
                    label = "Пригушена боја текста",
                },
                deathScreenNaturalRagdollDebug = {
                    description = "Исписује детаљне разлоге клијента и сервера док тело остаје у ragdoll стању.",
                    label = "Отклањање грешака природног ragdoll-а",
                },
                deathScreenNaturalStabilizationMode = {
                    description = "Аутоматски стабилизује тело које мирује или захтева да медицинар на дужности постави пацијента у стабилан бочни положај.",
                    label = "Природна стабилизација",
                    options = {
                        automatic = "Аутоматски",
                        medic = "Медицинар је обавезан",
                    },
                },
                deathScreenPanelBackground = {
                    description = "Боја позадине панела коју користи екран смрти.",
                    label = "Панел бацкгроунд",
                },
                deathScreenPreventAutoRespawn = {
                    description = "Блокирајте аутоматско поновно појављивање након крварења.",
                    label = "Спречите аутоматско поновно појављивање",
                },
                deathScreenPreventAutoRespawnIfMedicNearby = {
                    description = "Блокирајте аутоматско поновно појављивање док је лекар у близини.",
                    label = "Блокирајте када је лекар у близини",
                },
                deathScreenPreventReviveOnExpiry = {
                    description = "Блок се оживљава након што истекне тајмер за испуштање.",
                    label = "Спречите оживљавање по истеку",
                },
                deathScreenPrimaryColor = {
                    description = "Основна ЦСС боја која се користи за тему екрана смрти.",
                    label = "Примарна боја",
                },
                deathScreenPrimaryDark = {
                    description = "Опциона тамнија акцентна боја за екран смрти.",
                    label = "Примарно тамно",
                },
                deathScreenPrimaryStrong = {
                    description = "Опционо јачи акцент боје за екран смрти.",
                    label = "Примарно јак",
                },
                deathScreenRespawnDefaultHeading = {
                    description = "Курс се користи када станица нема дефинисан курс.",
                    label = "Подразумевани наслов",
                },
                deathScreenRespawnFallbackCoordsHeading = {
                    description = "Резервни наслов поновног појављивања се користи када не постоје болничке позиције.",
                    label = "Резервни наслов",
                },
                deathScreenRespawnFallbackCoordsX = {
                    description = "Координата Кс резервног поновног покретања која се користи када не постоје болничке позиције.",
                    label = "Резервни Кс",
                },
                deathScreenRespawnFallbackCoordsY = {
                    description = "И координата резервног поновног покретања која се користи када не постоје болничке позиције.",
                    label = "Резервни И",
                },
                deathScreenRespawnFallbackCoordsZ = {
                    description = "З координата резервног поновног покретања се користи када не постоје болничке позиције.",
                    label = "Фаллбацк З",
                },
                deathScreenRespawnHospitalId = {
                    description = "Изаберите фиксну болницу за поновно појављивање. Оставите га празним да бисте користили најближу болницу.",
                    label = "Респавн хоспитал",
                },
                deathScreenRespawnRemoveAccountsEnabled = {
                    description = "Уклоните стање на рачуну приликом поновног покретања.",
                    label = "Уклоните налоге",
                },
                deathScreenRespawnRemoveAccountsNames = {
                    description = "Имена налога су уклоњена при поновном отварању.",
                    itemLabel = "Рачун",
                    label = "Називи налога",
                },
                deathScreenRespawnRemoveItemsEnabled = {
                    description = "Уклоните ставке инвентара при поновном појављивању.",
                    label = "Уклоните ставке",
                },
                deathScreenRespawnRemoveItemsIgnore = {
                    description = "Ставке инвентара се чувају при поновном појављивању.",
                    itemLabel = "Ставка",
                    label = "Игнорисани предмети",
                },
                deathScreenRespawnRemoveWeaponsEnabled = {
                    description = "Уклоните оружје на точковима приликом поновног појављивања.",
                    label = "Уклоните оружје",
                },
                deathScreenRespawnRemoveWeaponsIgnore = {
                    description = "Оружје које се поново покреће.",
                    itemLabel = "Оружје",
                    label = "Игнорирано оружје",
                },
                deathScreenRespawnTeleportToHospital = {
                    description = "Телепортујте играча у болницу када се поново појави.",
                    label = "Телепортујте се у болницу",
                },
                deathScreenResumeBleedOutOnReconnect = {
                    description = "Наставите тајмер за испуштање након поновног повезивања уместо да га ресетујете.",
                    label = "Наставите при поновном повезивању",
                },
                deathScreenShadowLight = {
                    description = "Мека боја сенке коју користи екран смрти.",
                    label = "Светлост сенке",
                },
                deathScreenShadowMid = {
                    description = "Боја средње сенке коју користи екран смрти.",
                    label = "Схадов мид",
                },
                deathScreenShowNearestMedic = {
                    description = "Покажите најближег лекара на екрану смрти.",
                    label = "Покажите најближем лекару",
                },
                deathScreenTextColor = {
                    description = "Примарна боја текста коју користи екран смрти.",
                    label = "Боја текста",
                },
                deathScreenTextShadow = {
                    description = "Боја сенке текста коју користи екран смрти.",
                    label = "Сенка текста",
                },
                deathTimeoutApplyOnKnockout = {
                    description = "Примените и временско ограничење смрти након оживљавања нокаута.",
                    label = "Нанесите на нокаут",
                },
                deathTimeoutSeconds = {
                    description = "Неколико секунди након оживљавања та борба остаје онемогућена.",
                    label = "Секунде",
                },
                deathTimeoutShowUi = {
                    description = "Прикажи банер са одбројавањем времена за смрт док је активан.",
                    label = "Прикажи кориснички интерфејс",
                },
                deathTimeoutWhitelistedGangs = {
                    label = "Bande na beloj listi",
                    description = "Izaberi interne nazive bandi ili nezavisnih organizacija. Odgovarajući posao ili banda daje dozvolu ili izuzetak. Dužnost je obavezna samo za poslove.",
                    itemLabel = "Banda",
                },
                deathTimeoutWhitelistedJobs = {
                    description = "Послови изузети од ограничења временског ограничења смрти.",
                    itemLabel = "Јоб",
                    label = "Послови на белој листи",
                },
                deathUseAnimation = {
                    description = "Пустите конфигурисану анимацију смрти за подржане педове.",
                    label = "Користите анимацију",
                },
                diagnoseAnimClip = {
                    description = "Анимирани снимак који се користи приликом отварања дијагнозе. Оставите празно да бисте уместо тога користили сценарио.",
                    label = "Назив анимације",
                },
                diagnoseAnimDict = {
                    description = "Речник анимације који се користи приликом отварања дијагнозе. Оставите празно да бисте уместо тога користили сценарио.",
                    label = "Речник анимације",
                },
                diagnoseAnimScenario = {
                    description = "Сценарио коришћен приликом отварања дијагнозе. Оставите празно да бисте уместо тога користили дицт + цлип.",
                    label = "Сценарио",
                },
                diagnoseCprAnimDict = {
                    description = "Речник анимације који се користи за ЦПР.",
                    label = "Речник анимације",
                },
                diagnoseCprAnimName = {
                    description = "Анимирани снимак који се користи за ЦПР.",
                    label = "Назив анимације",
                },
                diagnoseFullHealDelaySeconds = {
                    description = "Потребно време непрекидне дијагностике пре приказа потпуног лечења.",
                    label = "Кашњење у секундама",
                },
                diagnoseRequireRescueBackpack = {
                    label = "Zahtevaj spasilački ranac",
                    description = "Zahtevaj rescue_backpack za prikaz leve trake sa alatima za pregled. Isključi da bi traka uvek bila vidljiva; zahtevi za predmetima pojedinačnih alata i dalje važe.",
                },
                diagnoseFullHealEnabled = {
                    description = "Омогућава потпуно лечење након непрекидне дијагностичке сесије.",
                    label = "Омогућено",
                },
                diagnoseInteractDistance = {
                    description = "Максимална удаљеност потребна за дијагнозу или ношење пацијента.",
                    label = "Удаљеност интеракције",
                },
                diagnosePatientMovementMode = {
                    label = "Kretanje pacijenta",
                    description = "Onemogućite kretanje pacijenta dok drugi igrač drži meni za lečenje otvorenim, ili dozvolite kretanje i zatvorite meni kada se prekorači udaljenost lečenja. Samodijagnoza se podešava odvojeno.",
                    options = {
                        freeze = "Onemogući kretanje pacijenta",
                        distance = "Zatvori pri prekoračenju udaljenosti",
                    },
                },
                diagnoseMaxTreatmentDistance = {
                    label = "Udaljenost lečenja (m)",
                    description = "Maksimalna udaljenost između igrača koji leči i pacijenta pre zatvaranja menija u režimu udaljenosti. Udaljenost za otvaranje podešava se odvojeno.",
                },
                diagnoseKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Interakcija dijagnoze",
                },
                diagnoseOpenDelayMs = {
                    description = "Одлагање пре отварања корисничког интерфејса за дијагнозу.",
                    label = "Кашњење отварања мс",
                },
                diagnosePromptDistance = {
                    description = "Удаљеност која се користи за приказивање упита за дијагнозу.",
                    label = "Промпт дистанце",
                },
                diagnoseTreatmentDurationMs = {
                    description = "Трајање коришћено за анимације третмана.",
                    label = "Трајање третмана мс",
                },
                doctorNpcAddRevenueToSociety = {
                    description = "Уплатите лекарске уплате на заједнички рачун друштва када директно наплаћујете.",
                    label = "Додајте приход друштву",
                },
                doctorNpcEnabled = {
                    description = "Омогућите услугу доктора НПЦ.",
                    label = "Омогућено",
                },
                doctorNpcHealOtherAccount = {
                    description = "Примарни кључ налога који се користи за наплату лечења другог играча.",
                    label = "Рачун",
                },
                doctorNpcHealOtherAccountType = {
                    description = "Тип примарног налога који се користи за наплату лечења другог играча.",
                    label = "Тип налога",
                },
                doctorNpcHealOtherCurrency = {
                    description = "Опциони прилагођени кључ валуте који се користи за наплату лечења другог играча.",
                    label = "Валута",
                },
                doctorNpcHealOtherPrice = {
                    description = "Цена за лечење другог играча код НПЦ доктора.",
                    label = "Цена",
                },
                doctorNpcHealSelfAccount = {
                    description = "Примарни кључ налога који се користи за самооздрављење.",
                    label = "Рачун",
                },
                doctorNpcHealSelfAccountType = {
                    description = "Примарни тип налога који се користи за наплату самоизлечења.",
                    label = "Тип налога",
                },
                doctorNpcHealSelfCurrency = {
                    description = "Опциони кључ прилагођене валуте који се користи за самооздрављење наплате.",
                    label = "Валута",
                },
                doctorNpcHealSelfPrice = {
                    description = "Цена да се излечите код доктора НПЦ.",
                    label = "Цена",
                },
                doctorNpcInteractionRange = {
                    description = "Колико корисник мора да остане близу НПЦ доктора док користи отворени мени доктора. Ово не мења почетну удаљеност НПЦ промпта.",
                    label = "Опсег интеракције",
                },
                doctorNpcMaxMedicsOnline = {
                    description = "Доктор НПЦ ради само док су дежурни медицинари испод ове границе.",
                    label = "Мак медицс онлине",
                },
                doctorNpcPatientRange = {
                    description = "Колико пацијент мора бити близак лекару НПЦ да би излечио друге или оживео да ради након одабира акције.",
                    label = "Опсег пацијената",
                },
                doctorNpcPaymentMode = {
                    description = "Одмах наплатите играче или пошаљите фактуру.",
                    label = "Начин плаћања",
                    options = {
                        bill = "рачун",
                        remove = "уклонити",
                    },
                },
                doctorNpcPlayerScanRange = {
                    description = "Користи се само за попис играча у близини у корисничком интерфејсу доктора НПЦ. Не дозвољава лечење сам по себи.",
                    label = "Опсег скенирања плејера",
                },
                doctorNpcReviveAccount = {
                    description = "Примарни кључ налога који се користи за наплату оживљавања доктора.",
                    label = "Рачун",
                },
                doctorNpcReviveAccountType = {
                    description = "Тип примарног рачуна који се користи за наплату оживљавања доктора.",
                    label = "Тип налога",
                },
                doctorNpcReviveAllowFatalWounds = {
                    description = "Омогућава NPC лекару да оживи смртоносне или неповратне повреде. Истекло време искрварења и даље блокира оживљавање.",
                    label = "Дозволи смртоносне повреде",
                },
                doctorNpcReviveCurrency = {
                    description = "Опциони прилагођени кључ валуте који се користи за наплату оживљавања доктора.",
                    label = "Валута",
                },
                doctorNpcReviveInBedEnabled = {
                    description = "Ставите оживљене играче у најближи болнички кревет након што лекар оживи.",
                    label = "Омогућено",
                },
                doctorNpcReviveInBedSearchRadius = {
                    description = "Максимална удаљеност коришћена за проналажење оближњег болничког кревета за оживљавање лекара.",
                    label = "Радијус претраге",
                },
                doctorNpcRevivePrice = {
                    description = "Цена за оживљавање играча код НПЦ доктора.",
                    label = "Цена",
                },
                enforceMaxHealth = {
                    description = "Одржава максимално здравље играча на 200. Искључите ово када други ресурс управља максималним здрављем.",
                    label = "Ограничи максимално здравље на 200",
                },
                firstAidActionDurationMs = {
                    description = "Колико дуго траје акција прве помоћи.",
                    label = "Трајање акције мс",
                },
                firstAidAnimationDict = {
                    description = "Речник анимације који се користи током акције прве помоћи.",
                    label = "Речник анимације",
                },
                firstAidAnimationFlag = {
                    description = "ТаскПлаиАним ознака која се користи током акције прве помоћи.",
                    label = "Застава анимације",
                },
                firstAidAnimationName = {
                    description = "Анимирани снимак који се користи током акције прве помоћи.",
                    label = "Назив анимације",
                },
                firstAidBleedoutExtensionSeconds = {
                    description = "Секунде се додају пацијентовом тајмеру за испуштање крви након прве помоћи.",
                    label = "Продужетак за испуштање секунда",
                },
                firstAidEnabled = {
                    description = "Омогућите функцију прве помоћи за лиценциране играче.",
                    label = "Прва помоћ је омогућена",
                },
                firstAidLicense = {
                    description = "Назив оквирне лиценце који се користи за валидацију приступа прве помоћи.",
                    label = "Назив лиценце",
                },
                firstAidLicenseManagementAddEnabled = {
                    description = "Дозволите особљу хитне помоћи да да дозволу за прву помоћ.",
                    label = "Омогућено додавање лиценце",
                },
                firstAidLicenseManagementAddRadial = {
                    description = "Прикажи радњу додавања лиценце у радијалном менију.",
                    label = "Додајте радијалну лиценцу",
                },
                firstAidLicenseManagementAddRequireDuty = {
                    description = "Захтевајте ЕМС дужност пре него што се може користити акција додавања лиценце.",
                    label = "Додати лиценцу захтевају обавезу",
                },
                firstAidLicenseManagementAdditionalLicenses = {
                    description = "Додатне лиценце оквира које особље хитне помоћи може да изда или уклони у картону пацијента. Подешена лиценца прве помоћи је увек укључена.",
                    itemLabel = "Лиценца",
                    label = "Додатне лиценце пацијента",
                },
                firstAidLicenseManagementRemoveEnabled = {
                    description = "Дозволите особљу хитне помоћи да уклони дозволу за прву помоћ.",
                    label = "Уклањање лиценце је омогућено",
                },
                firstAidLicenseManagementRemoveRadial = {
                    description = "Прикажи акцију уклањања лиценце у радијалном менију.",
                    label = "Уклоните лиценцу радијалну",
                },
                firstAidLicenseManagementRemoveRequireDuty = {
                    description = "Захтевајте ЕМС дужност пре него што се може користити акција уклањања лиценце.",
                    label = "Уклањање лиценце захтева дужност",
                },
                firstAidPositionChestOffset = {
                    description = "Оффсет грудног коша који се користи приликом поравнања за прву помоћ.",
                    label = "Оффсет грудног коша",
                },
                firstAidPositionSideOffset = {
                    description = "Бочни помак који се користи приликом поравнања за прву помоћ.",
                    label = "Сиде оффсет",
                },
                firstAidPositionZOffset = {
                    description = "Вертикални помак који се користи приликом поравнања за прву помоћ.",
                    label = "З оффсет",
                },
                firstAidRequireLicense = {
                    description = "Захтевајте конфигурисану лиценцу за прву помоћ пре него што играч може да користи прву помоћ.",
                    label = "Захтевати лиценцу",
                },
                firstAidTargetDistance = {
                    description = "Максимална дозвољена удаљеност за употребу прве помоћи.",
                    label = "Циљна удаљеност",
                },
                healthInsuranceAccount = {
                    description = "Резервни кључ налога који се користи за плаћања осигурања.",
                    label = "Рачун",
                },
                healthInsuranceAccountType = {
                    description = "Примарни тип рачуна који се користи за плаћања осигурања.",
                    label = "Тип налога",
                },
                healthInsuranceAvailableDays = {
                    description = "Доступна трајања осигурања у данима.",
                    label = "Доступни дани",
                },
                healthInsuranceCommand = {
                    description = "Команда за ћаскање која се користи за отварање корисничког интерфејса здравственог осигурања.",
                    label = "Цомманд",
                },
                healthInsuranceCurrency = {
                    description = "Опциони прилагођени кључ валуте који се користи за плаћања осигурања.",
                    label = "Валута",
                },
                healthInsuranceEnabled = {
                    description = "Омогућите систем здравственог осигурања.",
                    label = "Омогућено",
                },
                healthInsurancePricesManagedInTablet = {
                    description = "Омогућава овлашћеним запосленима да мењају цене осигурања на таблету. Искључите да би се примењивале цене из табеле провајдера испод.",
                    label = "Управљање ценама на таблету",
                },
                healthInsuranceProviders = {
                    description = "Провајдери осигурања нуде играчима.",
                    itemLabel = "Провајдер",
                    label = "Провајдери",
                },
                healthInsuranceSharedAcrossJobs = {
                    description = "Користи исте добављаче и полисе за све послове регистроване у овом ресурсу хитне помоћи.",
                    label = "Дели између послова хитне помоћи",
                },
                hospitalBedsBedAnimationDict = {
                    description = "Речник анимације се вртио док играч лежи на кревету. Оставите празно да бисте користили подразумевану резервну анимацију смрти.",
                    label = "Речник анимације",
                },
                hospitalBedsBedAnimationDurationMs = {
                    description = "Опционо ручно трајање за анимацију кревета у облику петље. Користи се само када је конфигурисана прилагођена анимација кревета.",
                    label = "Трајање мс",
                },
                hospitalBedsBedAnimationFlag = {
                    description = "ТаскПлаиАним заставица која се користи за анимацију кревета у облику петље. Користи се само када је конфигурисана прилагођена анимација кревета.",
                    label = "Застава анимације",
                },
                hospitalBedsBedAnimationName = {
                    description = "Анимирани снимак је покренут док плејер лежи на кревету. Оставите празно да бисте користили подразумевану резервну анимацију смрти.",
                    label = "Назив анимације",
                },
                hospitalBedsBreakDistance = {
                    description = "Растојање након које је играч присиљен да изађе из кревета.",
                    label = "Бреак дистанце",
                },
                hospitalBedsCreatorPedModel = {
                    description = "Прегледајте пед модел који се користи у уређивачу положаја болничког кревета.",
                    label = "Креатор пед модела",
                },
                hospitalBedsEnabled = {
                    description = "Омогућите конфигурисане интеракције болничког кревета.",
                    label = "Омогућено",
                },
                hospitalBedsGetupAnimationDict = {
                    description = "Речник анимације који се репродукује када играч устане из кревета. Оставите празно да бисте користили подразумевано станд-уп понашање.",
                    label = "Речник анимације",
                },
                hospitalBedsGetupAnimationDurationMs = {
                    description = "Опционо ручно трајање за анимацију устајања. Користи се само када је конфигурисана прилагођена анимација устајања.",
                    label = "Трајање мс",
                },
                hospitalBedsGetupAnimationFlag = {
                    description = "ТаскПлаиАним заставица која се користи за анимацију подизања. Користи се само када је конфигурисана прилагођена анимација устајања.",
                    label = "Застава анимације",
                },
                hospitalBedsGetupAnimationName = {
                    description = "Анимирани снимак се репродукује када играч устане из кревета. Оставите празно да бисте користили подразумевано станд-уп понашање.",
                    label = "Назив анимације",
                },
                hospitalBedsHeadingOffset = {
                    description = "Померање главе се примењује приликом постављања играча на кревет.",
                    label = "Одступање курса",
                },
                hospitalBedsHeightOffset = {
                    description = "Вертикални помак се примењује приликом постављања плејера на кревет.",
                    label = "Помак висине",
                },
                hospitalBedsInteractDistance = {
                    description = "Максимална удаљеност потребна за коришћење болничког кревета.",
                    label = "Удаљеност интеракције",
                },
                hospitalBedsInteractKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Interakcija sa bolničkim krevetom",
                },
                hospitalBedsModels = {
                    description = "Светски модели објеката третирани као употребљиви болнички кревети.",
                    itemLabel = "Модел",
                    label = "Модели кревета",
                },
                hospitalBedsSearchRadius = {
                    description = "Радијус се користи за проналажење реквизита за кревет у близини или конфигурисаних кревета.",
                    label = "Радијус претраге",
                },
                hospitalBlipColor = {
                    description = "ИД боје Блип-а који се користи за блипове болничке карте.",
                    label = "Боја",
                },
                hospitalBlipEnabled = {
                    description = "Прикажите слике болничке мапе за конфигурисане болничке позиције.",
                    label = "Омогућено",
                },
                hospitalBlipName = {
                    description = "Назив резервног болничког записа који се користи када назив станице није доступан.",
                    label = "Име",
                },
                hospitalBlipScale = {
                    description = "Блип скала која се користи за слике болничке карте.",
                    label = "Сцале",
                },
                hospitalBlipSprite = {
                    description = "Блип сприте ИД који се користи за слике болничке мапе.",
                    label = "Сприте",
                },
                imagingInteractionRange = {
                    description = "Максимална удаљеност од станице за снимање за оператера.",
                    label = "Опсег интеракције",
                },
                imagingPatientRange = {
                    description = "Максимална удаљеност од станице за снимање за пацијента.",
                    label = "Опсег пацијената",
                },
                imagingScanDurationSeconds = {
                    description = "Трајање у секундама за резултате ЦТ и МРИ скенирања.",
                    label = "Трајање скенирања",
                },
                injuryEffectsBleedingOverlayIntensity = {
                    description = "Само визуелни множилац за ефекте прекривања крварења.",
                    label = "Интензитет прекривања крварења",
                },
                injuryEffectsPainScreenIntensity = {
                    description = "Само визуелни мултипликатор за ефекте екрана против болова.",
                    label = "Интензитет екрана бола",
                },
                injuryThresholdBleedingPainMinPercent = {
                    description = "Минимални проценат максималног здравља изгубљеног у једном поготку пре него што се примени крварење и бол.",
                    label = "Крварење/бол мин проценат",
                },
                injuryThresholdRespectArmor = {
                    description = "Прескочите крварење и бол када је погодак апсорбовао оклоп.",
                    label = "Поштујте оклоп",
                },
                knockoutRegenerateDamage = {
                    description = "Регенеришите штету нокаутом након што истекне тајмер за поновно појављивање.",
                    label = "Регенеришите штету",
                },
                knockoutRegenerateDurationSeconds = {
                    description = "Секунде током којих се оштећење нокаутом враћа.",
                    label = "Трајање регенерације",
                },
                knockoutRespawnSeconds = {
                    description = "Секунде пре аутоматског поновног појављивања када је играч нокаутиран.",
                    label = "Респавн сецондс",
                },
                knockoutWeapons = {
                    description = "Називи оружја или хешеви који би требало да изазову нокаут уместо целог екрана смрти.",
                    itemLabel = "Оружје",
                    label = "Оружје",
                },
                legShotRagdollChance = {
                    description = "Procenat sanse da odgovarajuci pogodak aktivira ragdoll.",
                    label = "Sansa",
                },
                legShotRagdollCooldownMs = {
                    description = "Minimalno kasnjenje izmedju ragdolla nakon pogotka u nogu.",
                    label = "Охлађење гђице",
                },
                legShotRagdollDebug = {
                    description = "Belezi odluke ragdolla radi testiranja.",
                    label = "Исправљање",
                },
                legShotRagdollDurationMs = {
                    description = "Koliko dugo ragdoll traje.",
                    label = "Trajanje ms",
                },
                legShotRagdollFeet = {
                    description = "Dozvoli da pogoci u stopala aktiviraju ragdoll.",
                    label = "Stopala",
                },
                legShotRagdollIgnoreArmorHits = {
                    description = "Preskace ragdoll ako je oklop upio pogodak.",
                    label = "Ignorisi pogotke u oklop",
                },
                legShotRagdollLeftLowerLeg = {
                    description = "Dozvoli pogotke u levu potkolenicu.",
                    label = "Leva potkolenica",
                },
                legShotRagdollLeftUpperLeg = {
                    description = "Dozvoli pogotke u levu natkolenicu.",
                    label = "Leva natkolenica",
                },
                legShotRagdollOnlyGunshots = {
                    description = "Samo pucnji mogu da aktiviraju ragdoll.",
                    label = "Samo pucnji",
                },
                legShotRagdollRightLowerLeg = {
                    description = "Dozvoli pogotke u desnu potkolenicu.",
                    label = "Desna potkolenica",
                },
                legShotRagdollRightUpperLeg = {
                    description = "Dozvoli pogotke u desnu natkolenicu.",
                    label = "Desna natkolenica",
                },
                liveDamageFracturesChance = {
                    description = "Основна шанса да је свесно оштећено погодило прелом.",
                    label = "Шанса",
                },
                liveDamageFracturesEnabled = {
                    description = "Дозволите свесним ударцима оштећења да се преломи котрљају.",
                    label = "Омогућено",
                },
                liveDamageFracturesMinDamagePercent = {
                    description = "Минимални проценат максималног здравља изгубљен једним ударцем пре него што може настати прелом.",
                    label = "Минимални проценат оштећења",
                },
                liveDamageFracturesZones = {
                    description = "Шансе прелома по зонама за оштећење уживо.",
                    label = "Зоне шансе",
                },
                liveOpenWoundStacksDefault = {
                    description = "Maksimalan broj stekova otvorenih rana po zoni bez posebnog override-a.",
                    label = "Podrazumevani limit",
                },
                liveOpenWoundStacksZones = {
                    description = "Opciona ogranicenja stekova otvorenih rana po zoni.",
                    itemLabel = "Зона",
                    label = "Ogranicenja zona",
                },
                liveWoundBleedingClassProfiles = {
                    description = "Иницијална класа крварења примењена по узроку оштећења уживо.",
                    label = "Час крварења живих рана",
                },
                medicCarryAllowCarrierInVehicle = {
                    description = "Дозволите носиоцу да уђе и вози возило без спуштања пацијента.",
                    label = "Дозволи носиоцу возило",
                },
                medicCarryAllowConsciousTargets = {
                    description = "Дозволите ношење свесних играча.",
                    label = "Дозволите свесне мете",
                },
                medicCarryAllowSprint = {
                    description = "Дозволите спринт док носите пацијента.",
                    label = "Дозволи спринт",
                },
                medicCarryAttachBone = {
                    description = "Коштани индекс који се користи за причвршћивање играча који се носи.",
                    label = "Причврстите кост",
                },
                medicCarryAttachOffsetsPitch = {
                    description = "Носите ротацију корака причвршћивања.",
                    label = "Питцх",
                },
                medicCarryAttachOffsetsRoll = {
                    description = "Ротација ролне за ношење.",
                    label = "Ролл",
                },
                medicCarryAttachOffsetsX = {
                    description = "Носите причвршћивање Кс помака.",
                    label = "Оффсет Кс",
                },
                medicCarryAttachOffsetsY = {
                    description = "Носите И помак.",
                    label = "Оффсет И",
                },
                medicCarryAttachOffsetsYaw = {
                    description = "Носите причврсну ротацију.",
                    label = "Јав",
                },
                medicCarryAttachOffsetsZ = {
                    description = "Носите причвршћивање З оффсет.",
                    label = "Офсет З",
                },
                medicCarryCarrierAnimationDict = {
                    description = "Речник анимације који користи лекар док носи пацијента.",
                    label = "Речник анимације",
                },
                medicCarryCarrierAnimationFlag = {
                    description = "ТаскПлаиАним заставица коју користи медицинар носи анимацију.",
                    label = "Застава анимације",
                },
                medicCarryCarrierAnimationName = {
                    description = "Анимирани снимак који користи лекар док носи пацијента.",
                    label = "Назив анимације",
                },
                medicCarryEnabled = {
                    description = "Омогућите медицински систем за ношење.",
                    label = "Омогућено",
                },
                medicCarryMaxDistance = {
                    description = "Максимална удаљеност потребна за преузимање пацијента.",
                    label = "Мак дистанце",
                },
                medicCarryPassengerAnimationDict = {
                    description = "Речник анимације који користи пацијент који се носи.",
                    label = "Речник анимације",
                },
                medicCarryPassengerAnimationFlag = {
                    description = "ТаскПлаиАним заставица коју користи анимација пацијента.",
                    label = "Застава анимације",
                },
                medicCarryPassengerAnimationName = {
                    description = "Анимирани снимак који користи пацијент који се носи.",
                    label = "Назив анимације",
                },
                medicCarryReapplyDeathAnimation = {
                    description = "Поново примените анимацију смрти након испуштања онесвешћеног пацијента.",
                    label = "Поново примените анимацију смрти",
                },
                medicCarryRequireOnDuty = {
                    description = "Само дежурни лекари могу да започну ношење.",
                    label = "Захтевати на дужности",
                },
                medicReviveAllowFatalWounds = {
                    description = "Омогућава дежурним медицинарима да лече и оживе смртоносне или неповратне повреде. Истекло време искрварења и даље блокира оживљавање.",
                    label = "Дозволи смртоносне повреде",
                },
                medicRevivePersistenceKeepInjuries = {
                    description = "Чувајте нерешене повреде након третмана или контролне листе оживе.",
                    label = "Чувајте повреде",
                },
                medicRevivePersistenceKeepPain = {
                    description = "Задржите вредности бола након третмана или контролне листе оживе када се повреде сачувају.",
                    label = "Задржи бол",
                },
                medicalEvaluationPatientSelectionRange = {
                    description = "Највеће растојање за списак играча у близини при прављењу медицинске процене.",
                    label = "Опсег пацијената у близини",
                },
                medicalEvaluationRecipientJobs = {
                    description = "Професије за које медицинске процене могу бити издате и деле.",
                    label = "Poslovi primalaca",
                },
                medicalEvaluationShareBirthDate = {
                    description = "Дозволи професији примаоца да види датум рођења пацијента.",
                    label = "Д› ијељење датума рођења",
                },
                medicalEvaluationShareConclusion = {
                    description = "Дозволи професији примаоца да види медицински закључак.",
                    label = "Закључак д› ијељења",
                },
                medicalEvaluationShareEvaluationTypes = {
                    description = "Дозволи професији примаоца да виде који су извршени типови процена.",
                    label = "Типови д› ијељења",
                },
                medicalEvaluationShareFullName = {
                    description = "Дозволи примаоцима да виде пуно име пацијента.",
                    label = "Д› ијели пуно име",
                },
                medicalEvaluationShareGender = {
                    description = "Дозволи професији примаоца да види пола пацијента.",
                    label = "Д› ијели пола",
                },
                medicalEvaluationShareHeight = {
                    description = "Дозволи професији примаоца да види висину пацијента.",
                    label = "Висина д› ијељења",
                },
                medicalEvaluationShareHobbies = {
                    description = "Дозволи професији примаоца да види радне активности пацијента и хобија.",
                    label = "Дељење слободног времена и хобија",
                },
                medicalEvaluationShareIssuer = {
                    description = "Prikaži ime autora. Posao izdavaoca ostaje vidljiv kao fascikla u deljenim dokumentima.",
                    label = "Deli podatke autora",
                },
                medicalEvaluationSharePersonalId = {
                    description = "Дозволите прималац професије да види личног пацијента ID.",
                    label = "Поделите лично ID",
                },
                medicalEvaluationShareProfession = {
                    description = "Дозволите примаоца професије да види професију пацијента.",
                    label = "Д› ијели професију",
                },
                medicalEvaluationShareQuestionnaireAnswers = {
                    description = "Дозволи професији примаоца да види питања упитаника и записане одговоре.",
                    label = "Дељење питања и одговора",
                },
                medicalEvaluationShareResult = {
                    description = "Дозволи професији примаоца да види да ли процена чека, пролази или није успела.",
                    label = "Резултат д› ијељења",
                },
                medicalEvaluationShareWeight = {
                    description = "Дозволи професији примаоца да види тежину пацијента.",
                    label = "Подели тежину",
                },
                medicalEvaluationTypes = {
                    description = "Подешавање типова процене, питања, типова одговора и да ли је свако питање активно.",
                    label = "Типови и упитници за процену",
                    options = {
                        boolean = "Da / Ne",
                        boolean_text = "Да / Не са детаљима",
                        date = "Датум",
                        multi_select = "Вишеструки избор",
                        number = "Број",
                        rating = "Оцењивање",
                        select = "Појединачни избор",
                        text = "Текст",
                        textarea = "Област текста",
                        time = "Време",
                    },
                },
                medicalEvaluationsEnabled = {
                    description = "Активирајте медицинску процену у таблети хитне помоћи.",
                    label = "Омогућено",
                },
                medicalWearablesAllowUntilRemoved = {
                    description = "Nudi trajno vreme koje ostaje aktivno dok medicinar ne ukloni pomagalo.",
                    label = "Do uklanjanja",
                },
                medicalWearablesArmCastsDisableMelee = {
                    description = "Sprecava napade u bliskoj borbi dok je gips na ruci postavljen.",
                    label = "Onemoguci blisku borbu",
                },
                medicalWearablesArmCastsDisableWeapons = {
                    description = "Namece borbu bez oruzja i sprecava promenu oruzja dok je gips na ruci postavljen.",
                    label = "Onemoguci oruzje",
                },
                medicalWearablesArmCastsRestrictionsEnabled = {
                    description = "Primenjuje ogranicenja borbe dok je gips na ruci postavljen.",
                    label = "Omoguceno",
                },
                medicalWearablesAutoFromFractures = {
                    description = "Tretira odgovarajuci prelom kada se postavi gips ili udlaga.",
                    label = "Povezivanje sa prelomima",
                },
                medicalWearablesCastsEnabled = {
                    description = "Omogucava gipseve na levoj i desnoj ruci i nozi.",
                    label = "Omoguceno",
                },
                medicalWearablesCastsItem = {
                    description = "Predmet iz inventara koji se trosi pri postavljanju gipsa.",
                    label = "Predmet",
                },
                medicalWearablesCastsMinigame = {
                    description = "Postojeca mini-igra tretmana koja se koristi za gipseve.",
                    label = "Mini-igra",
                },
                medicalWearablesDefaultDurationMinutes = {
                    description = "Podrazumevano trajanje medicinskog pomagala u minutima. Postavi 0 za trajanje do uklanjanja.",
                    label = "Podrazumevani minuti",
                },
                medicalWearablesDurationOptionsMinutes = {
                    description = "Trajanja medicinskih pomagala prikazana medicinarima, u minutima.",
                    label = "Opcije trajanja",
                },
                medicalWearablesEnabled = {
                    description = "Omogucava modele gipsa, udlage, zavoja, kragne i maske sa kiseonikom u interfejsu tretmana.",
                    label = "Omoguceno",
                },
                medicalWearablesExpiryCheckSeconds = {
                    description = "Koliko cesto se uklanjaju istekla vremenski ogranicena medicinska pomagala.",
                    label = "Provera isteka (sekunde)",
                },
                medicalWearablesHeadBandageEnabled = {
                    description = "Omogucava model zavoja za glavu.",
                    label = "Omoguceno",
                },
                medicalWearablesHeadBandageItem = {
                    description = "Predmet iz inventara koji se trosi za zavoj za glavu.",
                    label = "Predmet",
                },
                medicalWearablesHeadBandageMinigame = {
                    description = "Postojeca mini-igra tretmana koja se koristi za zavoj za glavu.",
                    label = "Mini-igra",
                },
                medicalWearablesLegCastsDisableJump = {
                    description = "Sprecava skakanje dok je gips na nozi postavljen.",
                    label = "Onemoguci skok",
                },
                medicalWearablesLegCastsDisableSprint = {
                    description = "Sprecava sprint dok je gips na nozi postavljen.",
                    label = "Onemoguci sprint",
                },
                medicalWearablesLegCastsForceInjuredWalk = {
                    description = "Namece skup animacija povredjenog kretanja dok je gips na nozi postavljen.",
                    label = "Nametni povredjeni hod",
                },
                medicalWearablesLegCastsMoveRate = {
                    description = "Menja brzinu kretanja dok je gips na nozi postavljen.",
                    label = "Brzina kretanja",
                },
                medicalWearablesLegCastsRestrictionsEnabled = {
                    description = "Primenjuje ogranicenja kretanja dok je gips na nozi postavljen.",
                    label = "Omoguceno",
                },
                medicalWearablesNeckBraceEnabled = {
                    description = "Omogucava model vratne kragne.",
                    label = "Omoguceno",
                },
                medicalWearablesNeckBraceItem = {
                    description = "Predmet iz inventara koji se trosi za vratnu kragnu.",
                    label = "Predmet",
                },
                medicalWearablesNeckBraceMinigame = {
                    description = "Postojeca mini-igra tretmana koja se koristi za vratnu kragnu.",
                    label = "Mini-igra",
                },
                medicalWearablesOxygenMaskEnabled = {
                    description = "Omogucava model maske sa kiseonikom.",
                    label = "Omoguceno",
                },
                medicalWearablesOxygenMaskItem = {
                    description = "Predmet iz inventara koji se trosi za masku sa kiseonikom.",
                    label = "Predmet",
                },
                medicalWearablesOxygenMaskMinigame = {
                    description = "Postojeca mini-igra tretmana koja se koristi za masku sa kiseonikom.",
                    label = "Mini-igra",
                },
                medicalWearablesPatientHudEnabled = {
                    description = "Prikazuje pacijentu aktivna medicinska pomagala i preostalo vreme nosenja.",
                    label = "Omoguceno",
                },
                medicalWearablesPatientHudPosition = {
                    description = "Bira gde se prikazuje HUD medicinskih pomagala pacijenta.",
                    label = "Pozicija",
                    options = {
                        ["bottom-center"] = "Dole u sredini",
                        ["bottom-left"] = "Dole levo",
                        ["bottom-right"] = "Dole desno",
                        center = "Sredina",
                        ["center-left"] = "Sredina levo",
                        ["center-right"] = "Sredina desno",
                        ["top-center"] = "Gore u sredini",
                        ["top-left"] = "Gore levo",
                        ["top-right"] = "Gore desno",
                    },
                },
                medicalWearablesPersistence = {
                    description = "Vraca vremenski ogranicene gipseve, udlage, vratne kragne i zavoje za torzo posle ponovnog povezivanja i restartovanja resursa.",
                    label = "Trajnost medicinskih pomagala",
                },
                medicalWearablesRemoval = {
                    description = "Omogucava medicinarima da uklone aktivne gipseve, udlage, vratne kragne i zavoje za torzo iz interfejsa tretmana.",
                    label = "Uklanjanje od strane medicinara",
                },
                medicalWearablesRemovalTreatmentEnabled = {
                    description = "Prikazuje uklanjanje medicinskog pomagala podesenim alatom u interfejsu tretmana.",
                    label = "Uklanjanje u tretmanu omoguceno",
                },
                medicalWearablesRemovalTreatmentItem = {
                    description = "Alat iz inventara za visekratnu upotrebu potreban za uklanjanje medicinskog pomagala.",
                    label = "Predmet",
                },
                medicalWearablesRemovalTreatmentMinigame = {
                    description = "Mini-igra za uklanjanje medicinskih pomagala (podrazumevano cast_saw).",
                    label = "Mini-igra",
                },
                medicalWearablesSplintsEnabled = {
                    description = "Omogucava udlage sa remenom na levoj i desnoj ruci.",
                    label = "Omoguceno",
                },
                medicalWearablesSplintsItem = {
                    description = "Predmet iz inventara koji se trosi pri postavljanju udlage.",
                    label = "Predmet",
                },
                medicalWearablesSplintsMinigame = {
                    description = "Postojeca mini-igra tretmana koja se koristi za udlage.",
                    label = "Mini-igra",
                },
                medicalWearablesTorsoBandageEnabled = {
                    description = "Omogucava model zavoja za torzo.",
                    label = "Omoguceno",
                },
                medicalWearablesTorsoBandageItem = {
                    description = "Predmet iz inventara koji se trosi za zavoj za torzo.",
                    label = "Predmet",
                },
                medicalWearablesTorsoBandageMinigame = {
                    description = "Postojeca mini-igra tretmana koja se koristi za zavoj za torzo.",
                    label = "Mini-igra",
                },
                medicationsProfiles = {
                    description = "Декларативни уноси лекова који се користе за лечење и самолечење.",
                    itemLabel = "Лекови",
                    label = "Лекови",
                },
                minigamesBagValveMaskEnabled = {
                    description = "Омогућите мини игру маске вентила вреће.",
                    label = "Маска вентила за врећу",
                },
                minigamesCastSawEnabled = {
                    description = "Uključuje mini-igru sa testerom za uklanjanje medicinskih pomagala.",
                    label = "Testera za gips",
                },
                minigamesBandageWrapEnabled = {
                    description = "Омогућите мини-игру завоја завоја.",
                    label = "Бандаге Врап",
                },
                minigamesBloodPressureEnabled = {
                    description = "Омогућите мини игру крвног притиска.",
                    label = "Крвни притисак",
                },
                minigamesBloodTransfusionEnabled = {
                    description = "Омогућите мини-игру трансфузије крви.",
                    label = "Трансфузија крви",
                },
                minigamesBulletExtractionEnabled = {
                    description = "Омогућите мини игру извлачења метака.",
                    label = "Буллет Ектрацтион",
                },
                minigamesCprBreathsPerCycle = {
                    description = "Потребни удисаји током сваке фазе вентилације.",
                    label = "Удаха по циклусу",
                },
                minigamesCprCompressionDurationPerSet = {
                    description = "Секунде за завршетак једног сета компресије.",
                    label = "Трајање компресије по сету",
                },
                minigamesCprCompressionWindow = {
                    description = "Дозвољено померање при удару компресије.",
                    label = "Прозор компресије",
                },
                minigamesCprCompressionsEnabled = {
                    description = "Омогућите фазу мини игре ЦПР компресије.",
                    label = "ЦПР Цомпрессионс",
                },
                minigamesCprCompressionsPerSet = {
                    description = "Број компресија по сету.",
                    label = "Компресије по сету",
                },
                minigamesCprCycles = {
                    description = "Колико ЦПР циклуса је потребно да се заврши мини игра.",
                    label = "Циклуси",
                },
                minigamesCprEnabled = {
                    description = "Омогућите мини-игру ЦПР.",
                    label = "CPR",
                },
                minigamesCprIntroDelaySeconds = {
                    description = "Одбројавање пре почетка ЦПР компресије.",
                    label = "Уводно кашњење у секундама",
                },
                minigamesCprMaxMisses = {
                    description = "Дозвољени промашаји пре неуспеха у мини игрици ЦПР.",
                    label = "Макс промашује",
                },
                minigamesCprSetsPerCycle = {
                    description = "Колико сетова компресије ради пре фазе даха.",
                    label = "Сетови по циклусу",
                },
                minigamesCprVentilationEnabled = {
                    description = "Омогућите фазу мини игре ЦПР вентилације.",
                    label = "ЦПР вентилација",
                },
                minigamesGlucoseMeterEnabled = {
                    description = "Омогућите мини-игру мерача глукозе.",
                    label = "Глуцосе Метер",
                },
                minigamesPulseMeasurementEnabled = {
                    description = "Омогућите мини-игру мерења пулса.",
                    label = "Пулсе Меасуремент",
                },
                minigamesPulseOximeterEnabled = {
                    description = "Омогућите мини-игру пулсног оксиметра.",
                    label = "Пулсни оксиметар",
                },
                minigamesSalineInfusionEnabled = {
                    description = "Омогућите мини-игру инфузије физиолошког раствора.",
                    label = "Салине Инфусион",
                },
                minigamesVentilationBreathTimeoutSeconds = {
                    description = "Неколико секунди пре истека покушаја вентилације. Поставите 0 да бисте онемогућили.",
                    label = "Временско ограничење даха секунде",
                },
                minigamesVentilationEnabled = {
                    description = "Омогућите мини-игру вентилације.",
                    label = "Вентилација",
                },
                minigamesVentilationTolerance = {
                    description = "Толеранција удаљености пиксела при праћењу таласа протока ваздуха.",
                    label = "Толеранција",
                },
                operationsBreakDistance = {
                    description = "Najveća udaljenost učesnika od sale pre prekida zahvata.",
                    label = "Udaljenost prekida",
                },
                operationsDoctorAnimationDict = {
                    description = "GTA rečnik animacija za hirurga tokom pravog zahvata.",
                    label = "Rečnik animacije hirurga",
                },
                operationsDoctorAnimationFlag = {
                    description = "GTA oznaka animacije hirurga tokom pravog zahvata.",
                    label = "Oznaka animacije hirurga",
                },
                operationsDoctorAnimationName = {
                    description = "Animacioni klip za hirurga tokom pravog zahvata.",
                    label = "Naziv animacije hirurga",
                },
                operationsEnabled = {
                    description = "Omogućava operacione sale i hirurške zahvate.",
                    label = "Omogućeno",
                },
                operationsFadeInMs = {
                    description = "Trajanje pojavljivanja ekrana pacijenta tokom buđenja u milisekundama.",
                    label = "Pojavljivanje pri buđenju (ms)",
                },
                operationsFadeOutMs = {
                    description = "Trajanje zatamnjenja ekrana pacijenta tokom anestezije u milisekundama.",
                    label = "Zatamnjenje pri anesteziji (ms)",
                },
                operationsIdleTimeoutSeconds = {
                    description = "Najduže vreme bez važeće akcije u mini-igri pre prekida sesije.",
                    label = "Vreme neaktivnosti (s)",
                },
                operationsInteractDistance = {
                    description = "Najveća udaljenost za prikaz i korišćenje interakcija operacione sale.",
                    label = "Udaljenost interakcije",
                },
                operationsInteractKey = {
                    description = "ID kontrole za interakciju sa operacionim stolom i pozicijom hirurga.",
                    label = "Taster za interakciju",
                },
                operationsPatientAnimationDict = {
                    description = "GTA rečnik animacija za pacijenta koji leži pod punom anestezijom.",
                    label = "Rečnik animacije pacijenta",
                },
                operationsPatientAnimationFlag = {
                    description = "GTA oznaka animacije za ležeću animaciju pacijenta.",
                    label = "Oznaka animacije pacijenta",
                },
                operationsPatientAnimationName = {
                    description = "Animacioni klip za pacijenta koji leži pod punom anestezijom.",
                    label = "Naziv animacije pacijenta",
                },
                operationsPatientRange = {
                    description = "Najveći domet za pronalaženje pacijenta koji leži na operacionom stolu.",
                    label = "Domet pacijenta",
                },
                operationsRequireOnDuty = {
                    description = "Zahteva da hirurzi budu na dužnosti pre korišćenja operacione sale.",
                    label = "Zahtevaj dužnost",
                },
                operationsSelectionTimeoutSeconds = {
                    description = "Najduže vreme koje hirurg može provesti u izboru operacije pre prekida sesije.",
                    label = "Vreme za izbor (s)",
                },
                operationsTrainingAnimationDict = {
                    description = "GTA rečnik animacija za hiruršku obuku bez pacijenta.",
                    label = "Rečnik animacije obuke",
                },
                operationsTrainingAnimationFlag = {
                    description = "GTA oznaka animacije za hiruršku obuku.",
                    label = "Oznaka animacije obuke",
                },
                operationsTrainingAnimationName = {
                    description = "Animacioni klip za hiruršku obuku bez pacijenta.",
                    label = "Naziv animacije obuke",
                },
                painClassesProfiles = {
                    description = "Прагови бола, ознаке и ефекти накнадне обраде.",
                    label = "Часови бола",
                },
                painEffectsMinPainLevel = {
                    description = "Минимални ниво бола пре него што почну ефекти екрана против болова.",
                    label = "Минимални ниво бола",
                },
                primaryColor = {
                    description = "Главна боја за EMS интерфејс и групу послова хитне помоћи.",
                    label = "Примарна боја",
                },
                propPlacementConsumeItem = {
                    description = "Потрошите одговарајућу ставку инвентара када је реквизит постављен.",
                    label = "Потрошите ставку",
                },
                propPlacementEnabled = {
                    description = "Дозволите да се конфигурисани ЕМС реквизити постављају из употребљивих ставки инвентара.",
                    label = "Омогућено",
                },
                propPlacementItemNames = {
                    description = "Мапирајте ЕМС моделе реквизита у инвентар назива артикала за постављање на основу ставки.",
                    label = "Називи реквизита",
                },
                propPlacementRequireOnDuty = {
                    description = "Захтевајте од играча да буде на дужности пре постављања ЕМС реквизита.",
                    label = "Захтевати на дужности",
                },
                propPlacementReturnItem = {
                    description = "Вратите потрошени предмет када се уклони постављени реквизит.",
                    label = "Вратите ставку након уклањања",
                },
                propPlacementVehicleAccess = {
                    description = "Дозволите реквизитима за пртљажник да отворе ток пласмана уместо употребе само за ставке.",
                    label = "Приступ возилима",
                },
                publicTreatmentAllowConsciousPatients = {
                    description = "Дозволите јавни третман свесних играча.",
                    label = "Дозволите свесним пацијентима",
                },
                publicTreatmentAllowedGangs = {
                    label = "Dozvoljene bande",
                    description = "Izaberi interne nazive bandi ili nezavisnih organizacija. Odgovarajući posao ili banda daje dozvolu ili izuzetak. Dužnost je obavezna samo za poslove. Opcioni minimalni činovi bandi. Prazna lista dozvoljava sve činove. Zahtevi za predmetima i dalje važe.",
                },
                publicTreatmentAllowedJobs = {
                    description = "Послови који могу користити јавни третман без хитне помоћи.",
                    label = "Дозвољени послови",
                },
                publicTreatmentEnabled = {
                    description = "Омогућите јавни третман за особе које не одговарају ЕМС-у са важећим приступом.",
                    label = "Јавни третман омогућен",
                },
                publicTreatmentInteractDistance = {
                    description = "Максимална удаљеност потребна за почетак јавног третмана.",
                    label = "Удаљеност интеракције",
                },
                publicTreatmentKeybind = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Pruži prvu pomoć",
                },
                publicTreatmentInteractionEnabled = {
                    description = "Приказује обавештење за лечење и омогућава одговарајући тастер. Искључите ако користите export функције или сопствени радијални мени.",
                    label = "Интеракција тастером омогућена",
                },
                publicTreatmentPromptDistance = {
                    description = "Удаљеност која се користи за приказ јавног позива за третман.",
                    label = "Промпт дистанце",
                },
                publicTreatmentRequireAllItems = {
                    description = "Захтевајте сваки наведени медицински предмет уместо само једног.",
                    label = "Захтевајте све ставке",
                },
                publicTreatmentRequiredItems = {
                    description = "Ставке инвентара које се сматрају важећом јавном опремом за третман.",
                    itemLabel = "Ставка",
                    label = "Обавезне ставке",
                },
                reviveRewardAccount = {
                    description = "Примарни кључ налога који се користи за оживљавање исплата награда.",
                    label = "Рачун",
                },
                reviveRewardAccountType = {
                    description = "Тип примарног налога који се користи за оживљавање исплата награда.",
                    label = "Тип налога",
                },
                reviveRewardAmount = {
                    description = "Износ награде исплаћен лекару за оживљавање.",
                    label = "Износ",
                },
                reviveRewardCurrency = {
                    description = "Опциони кључ прилагођене валуте који се користи за оживљавање исплата награда.",
                    label = "Валута",
                },
                reviveRewardEnabled = {
                    description = "Платите конфигурисану награду након успешног оживљавања лекара.",
                    label = "Омогућено",
                },
                reviveRewardPayFromSociety = {
                    description = "Одузмите награде за оживљавање од заједничког рада пре него што платите лекару.",
                    label = "Плати од друштва",
                },
                selfDiagnoseCommand = {
                    description = "Команда за ћаскање се користи за отварање самодијагнозе.",
                    label = "Цомманд",
                },
                selfDiagnoseEnabled = {
                    description = "Дозволите играчима да сами отворе кориснички интерфејс за дијагнозу.",
                    label = "Самодијагностика је омогућена",
                },
                selfDiagnoseKeybind = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Samopregled",
                },
                selfDiagnoseOpenDelayMs = {
                    description = "Кашњење пре отварања корисничког интерфејса самодијагнозе.",
                    label = "Кашњење отварања мс",
                },
                selfDiagnoseRequireMedicJob = {
                    description = "Ограничите самодијагнозу само на послове лекара.",
                    label = "Захтева лекарски посао",
                },
                selfDiagnoseSkipFreezeOnSelf = {
                    description = "Не замрзавајте плејер док се самодијагностикује.",
                    label = "Прескочите замрзавање на себи",
                },
                statusEffectsProfiles = {
                    description = "Конфигурисани ефекти екрана и прагови за крварење, низак ниво крви, глад и жеђ.",
                    label = "Ефекти статуса",
                },
                stretcherAnimDict = {
                    description = "Речник анимације који се користи док носите носила.",
                    label = "Аниматион дицт",
                },
                stretcherAnimName = {
                    description = "Назив анимације који се користи док носите носила.",
                    label = "Назив анимације",
                },
                stretcherAttachRx = {
                    description = "Носите Кс ротацију за носила.",
                    label = "Приложите РКС",
                },
                stretcherAttachRy = {
                    description = "Носите И ротацију за носила.",
                    label = "Приложите РИ",
                },
                stretcherAttachRz = {
                    description = "З ротација за ношење за носила.",
                    label = "Приложите РЗ",
                },
                stretcherAttachX = {
                    description = "Носите Кс помак за носила.",
                    label = "Приложите Кс",
                },
                stretcherAttachY = {
                    description = "Носите И оффсет за носила.",
                    label = "Приложите И",
                },
                stretcherAttachZ = {
                    description = "Носите причврсни З оффсет за носила.",
                    label = "Приложити З",
                },
                stretcherFoldedEnabled = {
                    description = "Омогућите опциону варијанту преклопљених носила у возилима.",
                    label = "Преклопљено је омогућено",
                },
                stretcherFoldedModel = {
                    description = "Модел подупирача који се користи за варијанту склопљених носила.",
                    label = "Склопљени модел",
                },
                stretcherFoldedPatientAttachHeading = {
                    description = "Наслов пацијента који се користи за варијанту савијених носила.",
                    label = "Преклопљени наслов пацијента",
                },
                stretcherFoldedPatientAttachX = {
                    description = "Пацијент причвршћује Кс помак за пресавијена носила.",
                    label = "Преклопљени пацијент Кс",
                },
                stretcherFoldedPatientAttachY = {
                    description = "Пацијент причвршћује И помак за пресавијена носила.",
                    label = "Преклопљени пацијент И",
                },
                stretcherFoldedPatientAttachZ = {
                    description = "Пацијент причвршћује З оффсет за пресавијена носила.",
                    label = "Преклопљени пацијент З",
                },
                stretcherHelicopterInteractDistance = {
                    description = "Прекорачење удаљености интеракције које се користи за хеликоптере.",
                    label = "Удаљеност између хеликоптера",
                },
                stretcherHelicopterModels = {
                    description = "Модели возила третирани као хеликоптери са носилима.",
                    itemLabel = "Модел",
                    label = "Модели хеликоптера",
                },
                stretcherHelicopterPickupDistance = {
                    description = "Прекорачење удаљености дохвата који се користи за хеликоптере.",
                    label = "Удаљеност хеликоптера",
                },
                stretcherInteractDistance = {
                    description = "Максимална удаљеност за информације о интеракцији са носилима.",
                    label = "Удаљеност интеракције",
                },
                stretcherItemEnabled = {
                    description = "Омогућава предмет носила у инвентару, укључујући куповину у продавници и употребу.",
                    label = "Предмет носила",
                },
                stretcherItemPickupEnabled = {
                    description = "Дозволи враћање носила постављених из предмета у инвентару назад у инвентар.",
                    label = "Преузимање предмета",
                },
                stretcherModel = {
                    description = "Модел примарне носиљке коју користи ЕМС систем носила.",
                    label = "Модел",
                },
                stretcherPatientAnimationDict = {
                    description = "Rečnik animacije za pacijente na nosilima i NPC u pregledu.",
                    label = "Rečnik animacije pacijenta",
                },
                stretcherPatientAnimationName = {
                    description = "Animacioni klip za pacijente na nosilima i NPC u pregledu.",
                    label = "Naziv animacije pacijenta",
                },
                stretcherPatientAttachHeading = {
                    description = "Глава пацијента се користи док лежи на носилима.",
                    label = "Заглавље пацијента",
                },
                stretcherPatientAttachX = {
                    description = "Пацијент причвршћује Кс помак на носилима.",
                    label = "Пацијент Кс",
                },
                stretcherPatientAttachY = {
                    description = "Пацијент причвршћује И помак на носилима.",
                    label = "Пацијент И",
                },
                stretcherPatientAttachZ = {
                    description = "Пацијент причвршћује З оффсет на носилима.",
                    label = "Пацијент З",
                },
                stretcherPickupDistance = {
                    description = "Удаљеност потребна за подизање и интеракцију са носилима.",
                    label = "Удаљеност преузимања",
                },
                stretcherTreatmentAnimClip = {
                    description = "Анимирани снимак који се користи током лечења пацијента на носилима. Оставите празно да бисте користили сценарио или резервну анимацију третмана.",
                    label = "Назив анимације",
                },
                stretcherTreatmentAnimDict = {
                    description = "Речник анимације који се користи током лечења пацијента на носилима. Оставите празно да бисте користили сценарио или резервну анимацију третмана.",
                    label = "Речник анимације",
                },
                stretcherTreatmentAnimScenario = {
                    description = "Опциони сценарио који се користи током лечења пацијента на носилима. Оставите празно да бисте користили дицт + цлип или резервну анимацију третмана.",
                    label = "Сценарио",
                },
                stretcherVehicleAttachRx = {
                    description = "Кс ротација за причвршћивање возила за пуњење носила.",
                    label = "Вехицле РКС",
                },
                stretcherVehicleAttachRy = {
                    description = "И ротација прикључка за возило за пуњење носила.",
                    label = "Возило РИ",
                },
                stretcherVehicleAttachRz = {
                    description = "З ротација прикључка за возило за пуњење носила.",
                    label = "Возило РЗ",
                },
                stretcherVehicleAttachX = {
                    description = "Кс помак за причвршћивање возила за утовар носила.",
                    label = "Возило Кс",
                },
                stretcherVehicleAttachY = {
                    description = "И помак за причвршћивање возила за утовар носила.",
                    label = "Возило И",
                },
                stretcherVehicleAttachZ = {
                    description = "З оффсет прикључка за возило за пуњење носила.",
                    label = "Возило З",
                },
                stretcherVehicleModels = {
                    description = "Моделима возила је дозвољено да утоваре носила.",
                    itemLabel = "Модел",
                    label = "Модели возила",
                },
                treatmentAnimClip = {
                    description = "Анимирани снимак који се користи током лечења пацијента. Оставите празно да бисте уместо тога користили сценарио.",
                    label = "Назив анимације",
                },
                treatmentAnimDict = {
                    description = "Речник анимације који се користи током лечења пацијента. Оставите празно да бисте уместо тога користили сценарио.",
                    label = "Речник анимације",
                },
                treatmentAnimScenario = {
                    description = "Сценарио који се користи током лечења пацијента. Оставите празно да бисте уместо тога користили дицт + цлип.",
                    label = "Сценарио",
                },
                trunkPropsEnabled = {
                    label = "Predmeti vozila",
                    description = "Izaberi predmete kod obližnjeg službenog vozila.",
                },
                trunkEnabled = {
                    description = "Омогућите функцију пртљажника возила за возила хитне помоћи.",
                    label = "Омогућено",
                },
                vehicleDamageModifier = {
                    description = "Множилац штете се примењује док је играч у возилу.",
                    label = "Модификатор оштећења возила",
                },
                vehicleImpactProtectionCauses = {
                    description = "Узроци смрти који би се требали рачунати као заштићени удари возила.",
                    itemLabel = "Узрок",
                    label = "Узроци оштећења",
                },
                vehicleImpactProtectionEnabled = {
                    description = "Спречите да ударци возила при малим брзинама убију играча.",
                    label = "Омогућено",
                },
                vehicleImpactProtectionFatalSpeedKmh = {
                    description = "Ударци возила испод ове брзине не могу убити играча.",
                    label = "Фатална брзина км/х",
                },
                vehicleImpactProtectionFullDamageSpeedKmh = {
                    description = "Ударци возила при или изнад ове брзине користе нормалну конфигурацију смртоносне повреде.",
                    label = "Брзина пуне штете км/х",
                },
                vehicleImpactProtectionInjuries = {
                    description = "Повреде нанете када заштита од удара возила блокира фатални ударац.",
                    itemLabel = "Повреда",
                    label = "Повреде",
                },
                vehicleImpactProtectionSurvivalHealthPercent = {
                    description = "Проценат максималног очувања здравља када би заштићени удар убио играча.",
                    label = "Проценат здравља преживљавања",
                },
                vehiclePullEnabled = {
                    description = "Омогућите извлачење пацијената из возила.",
                    label = "Омогућено",
                },
                vehiclePullMaxDistance = {
                    description = "Максимално растојање потребно за извлачење пацијента из возила.",
                    label = "Мак дистанце",
                },
                wheelchairAssignMaxDistance = {
                    description = "Максимална удаљеност за додељивање инвалидских колица другом играчу.",
                    label = "Додели максималну удаљеност",
                },
                wheelchairAutoUnequipOnExpire = {
                    description = "Аутоматски искључите инвалидска колица када истекне задатак.",
                    label = "Ауто деекуип он екпире",
                },
                wheelchairDefaultDurationMinutes = {
                    description = "Подразумевано додељено трајање инвалидских колица у минутима.",
                    label = "Подразумевано трајање",
                },
                wheelchairDisableSprint = {
                    description = "Блокирајте спринт док су инвалидска колица опремљена.",
                    label = "Онемогући спринт",
                },
                wheelchairDisableWeapons = {
                    description = "Блокирајте употребу оружја док су инвалидска колица опремљена.",
                    label = "Онемогућите оружје",
                },
                wheelchairExitControl = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Napusti invalidska kolica",
                },
                wheelchairItemName = {
                    description = "Инвентар који се користи за инвалидска колица.",
                    label = "Назив ставке",
                },
                wheelchairMaxDurationMinutes = {
                    description = "Максимално дозвољено трајање доделе инвалидских колица у минутима.",
                    label = "Максимално трајање",
                },
                wheelchairMinDurationMinutes = {
                    description = "Минимално дозвољено трајање доделе инвалидских колица у минутима.",
                    label = "Мин. трајање",
                },
                wheelchairVehicle = {
                    description = "Модел возила који се користи за инвалидска колица.",
                    label = "Модел возила",
                },
                xrayInteractionRange = {
                    description = "Максимална удаљеност од рендгенске станице за оператера.",
                    label = "Опсег интеракције",
                },
                xrayPatientRange = {
                    description = "Максимална удаљеност од рендгенске станице за пацијента.",
                    label = "Опсег пацијената",
                },
                xrayScanDurationSeconds = {
                    description = "Трајање у секундама за резултат рендгенског скенирања.",
                    label = "Трајање скенирања",
                },
                appointmentsBookingCooldownSeconds = {
                    description = "Ухлађење у секунди између покушаја резервације пацијента.",
                    label = "Резервација охлађења",
                },
                appointmentsEnabled = {
                    description = "Активирајте резервацију за састанке пацијената и лични медицински календар.",
                    label = "Омогућено",
                },
                appointmentsMaxAdvanceDays = {
                    description = "Највећи број дана у будућности који пацијенти могу књигу.",
                    label = "Највећа унапредња резервација",
                },
                appointmentsMaxAppointmentsPerPlayer = {
                    description = "Највећи број активних будућих састанка који пацијент може одржати.",
                    label = "Највећи састанци по пацијенту",
                },
                appointmentsMinLeadMinutes = {
                    description = "Најмањи број минута између резервације и састанка.",
                    label = "Најмање вр› ијеме воде",
                },
                appointmentsNotificationApp = {
                    description = "Идентификатор телефонског програма за обавештења о састанку.",
                    label = "Обавештење о програму",
                },
                appointmentsNotificationsEnabled = {
                    description = "Обавестите пацијенте на свом телефону када су састанци резервисани или отказани.",
                    label = "Обав› јештења о телефону",
                },
                appointmentsReasonMaxLength = {
                    description = "Највећи број знакова прихваћен из разлога за састанак.",
                    label = "Ограничење знака разлога",
                },
                appointmentsSlotDurationMinutes = {
                    description = "Трајање и мрежни интервал слота за заказано у минутима.",
                    label = "трајање слота",
                },
                minigamesBandageWrapRandomization = {
                    description = "Насумично смер газе путање, облик и пропорције.",
                    label = "варијација прелама завоја",
                },
                minigamesBloodTransfusionAccessRandomization = {
                    description = "Случајно прошири венозни приступ за трансфузију крви.",
                    label = "Варијација приступа трансфузији",
                },
                minigamesBloodTransfusionVenousAccess = {
                    description = "Захт› ијевај вишеступну процедуру приступа пре контроле тока. Искључи за стару једноставну верзију.",
                    label = "Веновита фаза приступа",
                },
                minigamesBulletExtractionRandomization = {
                    description = "Насумично поправи облик канала, ширину и опструкције.",
                    label = "варијација извлачења метка",
                },
                stretcherVehicleAttachEditor = {
                    description = "Положај и ротирај носила унутар подешене хитне помоћи.",
                    label = "Приказ возила",
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
                firstAidPublicTreatmentConflict = "Прва помоћ и јавни третман не могу се омогућити истовремено. Чување онемогућава и једно и друго.",
            },
            actions = {
                actionFailed = "Unable to save changes.",
                hideDetails = "Close",
                editPosition = "Edit",
                delete = "Delete",
                editDetails = "Edit",
                remove = "Delete",
            },
        },
    },
}
