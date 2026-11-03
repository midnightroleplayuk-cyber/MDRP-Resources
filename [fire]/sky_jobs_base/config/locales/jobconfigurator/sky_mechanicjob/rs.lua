JobConfigLocales["sky_mechanicjob:rs"] = {
    Nui = {
        workshopConfig = {
            settingFieldDescriptions = {
                radialEnabled = "Otvori naplatu radionice iz radijalnog menija.",
                allowTuningInvoices = "Pošalji račun za tuning korpu najbližoj mušteriji. Ugradnja je dostupna nakon pune uplate.",
                customerRange = "Maksimalna udaljenost u metrima za izdavanje računa mušterijama u blizini.",
                allowAnalytics = "Дозволи рачунање аналитике осим ако правило оцењивања га надмашује.",
                allowCustomPrices = "Дозволи механичарима да уређују цене позиције рачуна пре издавања.",
                allowEstimates = "Дозволи процену да муштерије морају да прихвате пре исплате.",
                allowImmediatePayment = "Дозволи да се рачуни из ове професије плаћају директно.",
                allowManualItems = "Дозволи механичарима да стварају произвољне положаје рачуна.",
                allowPartialPayments = "Дозволи депозите и вишеструке уплате за једну фактуру.",
                analyticsPeriodDays = "Дани су укључени у рачунање аналитике.",
                defaultDueDays = "Дани док фактура не закасни.",
                depositPercent = "Неопходан проценат депозита након издавања рачуна или прихватања процене.",
                enabled = "Дозволи овој професији да користи рачуне за механичаре.",
                estimateLifetimeHours = "Сати пре него што неодговорена процена истече.",
                gradeRules = "Ограничења рачуна и акције доступне сваком механичком разреду.",
                maxDiscountPercent = "Највећи попуст који рачун може да прими.",
                maximumInvoiceAmount = "Глобални максимум пре ограничења разреда.",
                maximumManualItems = "Највећа произвољна позиција по документу.",
                maximumReminders = "Највећи дозвољени подсетник по фактури.",
                minimumInvoiceAmount = "Минималан укупно за процене и рачуне.",
                minimumPartialPayment = "Најмања делимична исплата, искључујући мањи преостали баланс или депозит.",
                reminderFee = "Накнада додаје сваки исправан подсетник.",
                reminderGraceDays = "Дани су закаснили пре дозвољеног првог подсетника.",
                taxPercent = "Порез је додао после попуста.",
            },
            advancedPricingPreview = {
                compact = "Хонда / компактна",
                customer = "Цена муштерије",
                description = "Primer kozmetièkih proraèuna koristeæi trenutna pravila.",
                labor = "Рад",
                live = "Преглед уживо",
                margin = "Маргин",
                sports = "Sportski auto",
                super = "SUPERCAR",
                supplier = "Добављач",
                title = "Преглед цене",
            },
            configs = {
                sky_mechanicjob = {
                    subtitle = "Конфигуришите послове механичара, радње, возила и позиције у радионици.",
                    title = "Послови механичара",
                },
            },
            creatorSections = {
                mobileDyno = {
                    entryLabel = "Мобилна dyno инсталација",
                    entryPluralLabel = "Мобилне dyno инсталације",
                    label = "Мобилне dyno инсталације",
                },
                workshops = {
                    entryLabel = "Радионица",
                    entryPluralLabel = "Радионице",
                    label = "Радионице",
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
                minimumCrew = "Најмањи број особа у јединицама изабраним за овај план одзива.",
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
                minimumCrew = "Најмањи број посаде",
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
            diagnosticsSettings = {
                enabledLabel = "Омогући дијагностику возила",
                enabledDescription = "Дозвољава овој служби да отвори дијагностику возила и преко ње поправља делове.",
            },
            extensions = {
                diagnosticsSettings = {
                    label = "Дијагностика возила",
                    description = "Подесите приступ ове службе дијагностици возила.",
                },
                invalidSelection = "Nevažeći izbor: {value}",
                trainingSettings = {
                    description = "Подеси приступ тренингу, упис, дозволе, и планирање курса за овај посао.",
                    label = "Поставке тренинга",
                },
                billingPrices = {
                    description = "Конфигуришите цене фактура за уносе историје одржавања и поправки. Акциони кључ се пореди са ацтион_кеи, ацтион_типе или насловом рада.",
                    label = "Цене за фактурисање",
                },
                billingSettings = {
                    description = "Конфигуришите механичко понашање наплате за овај посао.",
                    label = "Наплата",
                },
                dispatchReporters = "Познати пријавиоци",
                partsDeliveryShop = "Продавница за испоруку делова",
                tuningCostProfile = {
                    description = "Конфигуришите перформансе, оптику, точак и посебне трошкове за овај посао. Трошкови подржавају потребне низове ставки и објекте степенасте надоградње.",
                    label = "Цене подешавања",
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
            },
            features = {
                tuningFreeCamera = {
                    label = "Slobodna kamera u meniju za tuning",
                    description = "Dozvoli skrivanje kursora tasterom za razmak radi slobodnog pomeranja kamere. Escape i dalje zatvara meni.",
                },
                tuningCamera = {
                    description = "Аутоматски усмерава камеру на изабрани део. Када је искључена, остаје уобичајена камера игре.",
                    label = "Аутоматска камера за тунинг",
                },
                jgMileage = {
                    description = "Koristi JG Vehicle Mileage dok je njegov resurs pokrenut. U suprotnom koristi Sky kilometražu. JG HUD se podešava odvojeno.",
                    label = "JG Mileage",
                },
                jgHud = {
                    description = "Prikaži izabranu kilometražu u JG HUD-u. Radi bez JG Vehicle Mileage; instaliraj HUD adapter prema README uputstvu.",
                    label = "JG HUD",
                },
                antiLag = {
                    description = "Омогућава инсталацију против кашњења и ефекте издувних гасова.",
                    label = "Анти-лаг",
                },
                brakeOverheating = {
                    description = "Омогућава постепено загревање, ужарене дискове, варнице и кратак губитак кочења.",
                    label = "Прегревање кочница",
                },
                carryItems = {
                    description = "Испоручени делови се морају транспортовати кроз радионицу.",
                    label = "Транспорт физичких делова",
                },
                customHandling = {
                    description = "Омогућава прилагођено подешавање погона и руковања.",
                    label = "Цустом Хандлинг",
                },
                electronicTuning = {
                    description = "Омогућава трајне ECU, светлосне и помоћне опције подешавања.",
                    label = "Електронско подешавање",
                },
                handlingEditor = {
                    description = "Омогућава администраторски уређивач и аутоматска правила за таблице и моделе возила. Након искључивања поново изведите погођена возила из гараже да бисте вратили већ примењене вредности.",
                    label = "Уређивач управљања",
                },
                instantTuning = {
                    description = "Омогућава директно подешавање конфигурисаних јавних тачака подешавања.",
                    label = "Инстант Тунинг",
                },
                kuv = {
                    description = "Pokreni tehnički pregled",
                    label = "Tehnički pregled vozila",
                },
                mileageHud = {
                    description = "Приказује километре возила током вожње.",
                    label = "Километража ХУД",
                },
                mobileDyno = {
                    description = "Омогућава мобилни динамометар, контролни и резултатни екран, контролер вентилатора и таблет.",
                    label = "Мобилни динамометар",
                },
                nitro = {
                    description = "Омогућава нитро инсталацију и појачање возила.",
                    label = "Нитро",
                },
                partsDelivery = {
                    description = "Омогућава поруџбине делова у радионици и зоне испоруке.",
                    label = "Испорука делова",
                },
                selfServiceOrderNotifications = {
                    description = "Обавештава дежурне запослене када се креира самоуслужни налог за подешавање.",
                    label = "Обавештења о самоуслужним поруџбинама",
                },
                stance = {
                    description = "Приказује Stance подешавања у свим менијима за тунинг и омогућава Stance Kit предмет.",
                    label = "Стенс",
                },
                stanceWheelSize = {
                    description = "Приказује, чува и примењује подешавања величине точкова у Станце-у.",
                    label = "Величина точка",
                },
                stanceWheelWidth = {
                    description = "Приказује, чува и примењује подешавања ширине точка у Станце.",
                    label = "Ширина точка",
                },
                subscriptions = {
                    description = "Омогућава терминале за претплату, управљање и попусте за клијенте радионице.",
                    label = "Претплате радионице",
                },
                twoStep = {
                    description = "Активира контролу лансирања у два корака и ефекте издувних гасова.",
                    label = "Два корака",
                },
                vehicleMaintenanceNotifications = {
                    description = "Обавештава власнике када њихово возило достигне подешени праг за одржавање.",
                    label = "Обавештења о одржавању возила",
                },
                vehicleRegistration = {
                    description = "Registruj / prenesi vozilo",
                    label = "Registracija vozila",
                },
                wheelDamage = {
                    description = "Омогућава реалистична оштећења и поправке точкова.",
                    label = "Оштећење точкова",
                },
                workshopLift = {
                    description = "Активира употребљиве тачке подизања у радионицама.",
                    label = "Радионички лифт",
                },
            },
            fields = {
                quantity = "Количина",
            },
            locationDescriptions = {
                vehicle_registry = "Postavite tačku na mesto za pregled u radionici. Vozilo mora biti unutar podešene udaljenosti za tehnički pregled i registraciju.",
            },
            locationTypes = {
                mobile_dyno_monitor = {
                    description = "Положај монитора dyno резултата.",
                    label = "Монитор dyno резултата",
                },
                mobile_dyno_station = {
                    description = "Положај мобилне dyno станице.",
                    label = "Мобилна dyno станица",
                },
                vehicle_registry = "Mesto za tehnički pregled i registraciju",
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
                radialEnabled = "Račun u radijalnom meniju",
                allowTuningInvoices = "Računi za tuning",
                customerRange = "Udaljenost mušterije",
                allowCustomPrices = "Дозволи сопствене цене",
                allowImmediatePayment = "Дозволи тренутно плаћање",
                amount = "Количина",
                bone = "Боне",
                category = "Категорија",
                classId = "ИД класе",
                enabled = "Омогућено",
                flow = "Процес инсталације",
                item = "Ставка",
                key = "Кључ",
                kilometersToZero = "Километара до 0",
                label = "Етикета",
                maxDiscountPercent = "Максимални попуст",
                multiplier = "Множилац",
                name = "Назив артикла",
                partKey = "Кључ дела",
                price = "Цена",
                priceType = "Тип цене",
                prop = "Проп",
                reason = "Разлог",
                removeAfterUse = "Потроши предмет",
                repair = "Поправка са комплетом",
                repairItem = "Ставка за поправку",
                rx = "Црвени Кс",
                ry = "Црвена И",
                rz = "Црвени З",
                transport = "Транспорт",
                x = "Кс",
                y = "И",
                z = "З",
                allowAnalytics = "Рачунска аналитика",
                allowCancellation = "Отказивање",
                allowEstimates = "Дозволи процене",
                allowManualItems = "Дозволи сопствене позиције",
                allowPartialPayments = "Дозволи делумне исплате",
                allowReminders = "Подсетници",
                analyticsPeriodDays = "Период аналитике",
                defaultDueDays = "Период плаћања (дани)",
                depositPercent = "проценат депозита",
                difficulty = "Тешкоћа",
                estimateLifetimeHours = "Процена живота (часова)",
                grade = "Оцена",
                gradeRules = "Правила степена",
                laborFee = "Цена рада",
                laborMultiplier = "Множење рада",
                marginAdjustmentPercent = "Подешавање маргине",
                marginPercent = "Маргина%",
                maximumInvoiceAmount = "Највећа фактура",
                maximumManualItems = "Највећа положај",
                maximumPrice = "Максимум",
                maximumReminders = "Највећи подсетник",
                minimumInvoiceAmount = "Најмања фактура",
                minimumPartialPayment = "Најмања делимична уплата",
                minimumPrice = "Минимум",
                reminderFee = "Подсетник",
                reminderGraceDays = "Период поздрава подсетника",
                supplierSharePercent = "Добављач% 1",
                taxPercent = "Порез на рачун",
                upgrade = "Надоградња",
                maximumDiscountPercent = "Максимални попуст",
            },
            settingGroups = {
                antiExploit = {
                    label = "Заштита од злоупотребе",
                },
                cooldownMultipliers = {
                    label = "Множиоци хлађења",
                },
                crashFalloff = {
                    label = "Отпадање при судару",
                },
                criticalEngine = {
                    label = "Неисправан мотор",
                },
                deformation = {
                    label = "Деформација",
                },
                diagnostics = {
                    label = "Дијагностика",
                },
                fade = {
                    label = "Слабљење кочница услед загревања",
                },
                format = {
                    label = "Формат",
                },
                frontalImpact = {
                    label = "Тешки фронтални судар",
                },
                heatMultipliers = {
                    label = "Множиоци загревања",
                },
                illegalMarket = {
                    label = "Илегално тржиште",
                },
                integration = {
                    label = "Интеграција",
                },
                items = {
                    label = "Предмети",
                },
                keybinds = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Prečice",
                },
                lifetime = {
                    label = "Трајање",
                },
                repairRestore = {
                    label = "Ресетовање поправке",
                },
                risk = {
                    label = "Ризик",
                },
                rules = {
                    label = "Правила",
                },
                safety = {
                    label = "Провера и безбедност",
                },
                stages = {
                    label = "Фазе прегревања",
                },
                tyreRepair = {
                    label = "Поправка гума",
                },
                visuals = {
                    label = "Визуелни ефекти",
                },
                coach = {
                    label = "Тренер телеметрије",
                },
                features = {
                    label = "Funkcije",
                },
                general = {
                    label = "Генерал",
                },
                limits = {
                    label = "ограничења складиштања",
                },
            },
            settingSections = {
                electronicTuning = "ECU софтвер мотора",
                advancedPricing = "Напредне цене",
                brakeOverheating = "Прегревање кочница",
                carryItems = "Преносиви делови",
                fakePlates = "Лажне регистарске таблице",
                firejobVehicleFires = "Пожари возила",
                general = "Генерал",
                handlingEditor = "Уређивач управљања",
                instantTuning = "Инстант Тунинг",
                maintenanceNotifications = "Обавештења о одржавању",
                mileageHud = "Километража ХУД",
                mobileDyno = "Мобилни динамометар",
                oilLeaks = "Цурење течности из возила",
                partsTheft = "Крађа делова",
                subscriptions = "Претплате",
                tuning = "Тунинг",
                vehicleCare = "Нега возила",
                vehicleRegistry = "Dokumenti vozila",
                wear = "Ношење",
                wheelDamage = "Оштећење точкова",
            },
            settingSubsectionGroups = {
                handlingAdditional = "Dodatno",
                handlingAir = "Vazduh",
                handlingGeneral = "Opšte",
                handlingRoad = "Drum",
                handlingWater = "Voda",
            },
            settingSubsections = {
                mechanicHotkeys = "Prečice",
                database = "Baza podataka",
                handlingEditorGeneral = "Подешавања уређивача",
                handlingMaximumCBikeHandlingData = "Motocikl",
                handlingMaximumCBoatHandlingData = "Čamac",
                handlingMaximumCCarHandlingData = "Automobil",
                handlingMaximumCFlyingHandlingData = "Avion",
                handlingMaximumCHandlingData = "Osnova vozila",
                handlingMaximumCSeaPlaneHandlingData = "Hidroavion",
                handlingMaximumCSpecialFlightHandlingData = "Specijalni let",
                handlingMaximumCSubmarineHandlingData = "Podmornica",
                handlingMaximumCTrailerHandlingData = "Prikolica",
                handlingMaximumCVehicleWeaponHandlingData = "Oružje vozila",
                keybinds = "Prečice",
                operation = "Рад",
                placementRules = "Правила постављања",
                testFlow = "Ток теста",
                tuning = "Опције тренутног тјунинга",
            },
            settingValues = {
                air_filter = "Ваздушни филтер",
                brake_fluid = "Кочиона течност",
                brake_pads = "Кочионе плочице",
                catalytic_converter = "Цаталист",
                clutch = "Спојница",
                coolant = "Расхладна течност",
                engine_oil = "Моторно уље",
                inverter = "Инвертер",
                spark_plugs = "Свјећице",
                suspension = "Шасија",
                traction_battery = "Тракциона батерија",
                transmission_fluid = "Течност за пренос",
                tyres = "Гуме",
                vehicleClass_0 = "Компактни аутомобил",
                vehicleClass_1 = "Лимузине",
                vehicleClass_10 = "Индустрија",
                vehicleClass_11 = "Комерцијална возила",
                vehicleClass_12 = "Комби",
                vehicleClass_13 = "Бицикли",
                vehicleClass_14 = "Чамци",
                vehicleClass_15 = "Хеликоптер",
                vehicleClass_16 = "Авиони",
                vehicleClass_17 = "Услуга",
                vehicleClass_18 = "Возила хитне помоћи",
                vehicleClass_19 = "Војска",
                vehicleClass_2 = "СУВ возила",
                vehicleClass_20 = "Комерцијални",
                vehicleClass_21 = "Возови",
                vehicleClass_22 = "Опен Вхеел",
                vehicleClass_3 = "Купе",
                vehicleClass_4 = "Мусцле Царс",
                vehicleClass_5 = "Спортс Цлассиц",
                vehicleClass_6 = "Спортски аутомобил",
                vehicleClass_7 = "Суперауто",
                vehicleClass_8 = "Мотоцикли",
                vehicleClass_9 = "Оффроад",
            },
            settings = {
                instantTuningRepairEnabled = {
                    label = "Popravka vozila",
                    description = "Ponudi popravku vozila na lokacijama za instant tuning.",
                },
                instantTuningRepairPrice = {
                    label = "Cena popravke",
                    description = "Fiksna cena popravke bez množitelja cene tuninga.",
                },
                instantTuningWashEnabled = {
                    label = "Pranje vozila",
                    description = "Ponudi pranje vozila na lokacijama za instant tuning.",
                },
                instantTuningWashPrice = {
                    label = "Cena pranja",
                    description = "Fiksna cena pranja bez množitelja cene tuninga.",
                },
                vehiclePriceSource = {
                    label = "Izvor cena vozila",
                    description = "Automatski: SQL na ESX; katalog vozila na QBCore/Qbox. Baza podataka: podešena SQL tabela na svakom frameworku.",
                    options = {
                        auto = "Automatski (framework)",
                        database = "Baza podataka",
                    },
                },
                vehiclePriceTable = {
                    label = "Tabela cena vozila",
                    description = "Tabela sa kupovnim cenama, npr. dealership_vehicles (JG).",
                },
                vehiclePriceModelColumn = {
                    label = "Kolona spawn naziva",
                    description = "Kolona spawn naziva, npr. spawn_code (JG), a ne prikazanog naziva.",
                },
                vehiclePricePriceColumn = {
                    label = "Kolona cene",
                    description = "Kolona numeričkih kupovnih cena, npr. price.",
                },
                vehiclePriceHashColumn = {
                    label = "Kolona hash vrednosti modela (opciono)",
                    description = "Opciona numerička hash kolona, npr. hashkey (JG). Ostavite prazno za računanje hash vrednosti iz spawn naziva.",
                },
                addRevenueToSociety = {
                    description = "Плаћени послови подешавања се уплаћују на рачун компаније за подешавање.",
                    label = "Приход од депозита",
                },
                advancedPricingAlwaysAvailableItemCategories = {
                    description = "Категорије продавнице делова које остају слободно доступне када су напредне цене активне. Велика и мала слова и размаци се занемарују.",
                    itemLabel = "Категорија",
                    label = "Увек доступне категорије",
                },
                advancedPricingAlwaysAvailableItemsEnabled = {
                    description = "Оставља конфигурисане артикле из изабраних категорија доступним без налога за подешавање и обрачунава их преко динамичког система добављача.",
                    label = "Увек доступни артикли продавнице",
                },
                advancedPricingEnabled = {
                    description = "Поново израчунава цене подешавања на серверу и, када је достава делова омогућена, захтева куповину Dynasty делова за одређени налог за подешавање.",
                    label = "Омогући напредне цене",
                },
                brakeOverheatingCooldownBrakeUpgradeMultipliers = {
                    label = "Хлађење по надоградњи кочница",
                },
                brakeOverheatingCooldownClassMultipliers = {
                    label = "Хлађење по класи возила",
                },
                brakeOverheatingCoolingDelayMs = {
                    description = "Одлагање у милисекундама након кочења пре почетка активног хлађења.",
                    label = "Одлагање хлађења",
                },
                brakeOverheatingCoolingPerSecond = {
                    label = "Брзина хлађења",
                    description = "Топлота уклоњена у секунди док кочница није коришћена.",
                },
                brakeOverheatingCriticalThreshold = {
                    label = "Критични праг",
                    description = "Ниво топлине на коме искри и кратке кочнице могу да почну.",
                },
                brakeOverheatingFadeChancePerSecond = {
                    label = "Шанса слабљења у секунди",
                    description = "Шанса од 0 до 1 за кратак прекид кочница док кочи на критичној врућини.",
                },
                brakeOverheatingFadeCooldownMs = {
                    label = "Пауза слабљења",
                },
                brakeOverheatingFadeMaximumDurationMs = {
                    label = "Максимално трајање слабљења",
                },
                brakeOverheatingFadeMinimumDurationMs = {
                    label = "Минимално трајање слабљења",
                },
                brakeOverheatingHeatBrakeUpgradeMultipliers = {
                    label = "Загревање по надоградњи кочница",
                },
                brakeOverheatingHeatClassMultipliers = {
                    label = "Загревање по класи возила",
                },
                brakeOverheatingHeatGainPerSecond = {
                    label = "Брзина загревања",
                    description = "База топлота је добила по секунди док се кочи при референтној брзини.",
                },
                brakeOverheatingHotThreshold = {
                    label = "Праг високе температуре",
                },
                brakeOverheatingMinimumSpeedKmh = {
                    label = "Минимална брзина кочења",
                    description = "Најмања брзина возила у км/ч пре кочења ствара топлоту.",
                },
                brakeOverheatingReferenceSpeedKmh = {
                    label = "Референтна брзина",
                    description = "Брзина у km/h на којој се прим› јењује подешени основни добитак топлоте.",
                },
                brakeOverheatingSparkMaximumIntervalMs = {
                    label = "Максимални интервал варница",
                },
                brakeOverheatingSparkMinimumIntervalMs = {
                    label = "Минимални интервал варница",
                },
                brakeOverheatingVisualDistance = {
                    label = "Домет ефеката",
                    description = "Максимална удаљеност у метрима за сјај и искрицу.",
                },
                brakeOverheatingWarmThreshold = {
                    label = "Праг загревања",
                },
                carryItems = {
                    description = "Испоручени делови за транспорт као физички истрошени реквизити.",
                    fields = {
                        transport = {
                            options = {
                                engine_lift = "Дизач мотора",
                                forklift = "Виљушкар",
                                hand = "рука",
                            },
                        },
                    },
                    itemLabel = "Носиви део",
                    label = "Преносиви делови",
                },
                ecuEngineTorqueStage1 = {
                    description = "1,00 не додаје снагу; 1,10 повећава обртни момент за 10%. Важи за возила са овим ECU степеном.",
                    label = "Множилац обртног момента за степен 1",
                },
                ecuEngineTorqueStage2 = {
                    description = "1,00 не додаје снагу; 1,10 повећава обртни момент за 10%. Важи за возила са овим ECU степеном.",
                    label = "Множилац обртног момента за степен 2",
                },
                ecuEngineTorqueStage3 = {
                    description = "1,00 не додаје снагу; 1,10 повећава обртни момент за 10%. Важи за возила са овим ECU степеном.",
                    label = "Множилац обртног момента за степен 3",
                },
                ecuEngineTorqueStage4 = {
                    description = "1,00 не додаје снагу; 1,10 повећава обртни момент за 10%. Важи за возила са овим ECU степеном.",
                    label = "Множилац обртног момента за степен 4",
                },
                fakePlatesAudit = {
                    label = "Евиденција провере",
                },
                fakePlatesBlacklist = {
                    description = "Забрањене речи или делови текста који не смеју да се појаве на лажним таблицама.",
                    label = "Црна листа",
                },
                fakePlatesBlankPlateItem = {
                    description = "Материјал за израду или продавницу у економском систему лажних таблица.",
                    label = "Предмет празне таблице",
                },
                fakePlatesCooldownMinutes = {
                    label = "Период чекања (минути)",
                },
                fakePlatesCrashFalloffChance = {
                    label = "Шанса за отпадање",
                },
                fakePlatesCrashFalloffEnabled = {
                    label = "Омогући отпадање при судару",
                },
                fakePlatesCrashFalloffMinSpeedKmh = {
                    label = "Минимална брзина судара",
                },
                fakePlatesEnabled = {
                    description = "Омогућава играчима да користе комплете лажних таблица на возилима.",
                    label = "Омогући лажне таблице",
                },
                fakePlatesExpireMinutes = {
                    description = "0 оставља лажне таблице активним док се не ресетују или док их обрада рестарта не уклони.",
                    label = "Истек (минути)",
                },
                fakePlatesExpireOnRestart = {
                    label = "Истек при рестарту",
                },
                fakePlatesIllegalMarketAccount = {
                    label = "Рачун за плаћање",
                },
                fakePlatesIllegalMarketEnabled = {
                    label = "Омогући илегално тржиште",
                },
                fakePlatesIllegalMarketPrice = {
                    label = "Цена на илегалном тржишту",
                },
                fakePlatesIllegalMarketRiskMultiplier = {
                    label = "Множилац ризика",
                },
                fakePlatesInstallDurationMs = {
                    label = "Трајање постављања (ms)",
                },
                fakePlatesItem = {
                    description = "Предмет за једнократну употребу који покреће постављање лажне таблице.",
                    label = "Предмет комплета лажних таблица",
                },
                fakePlatesMaxLength = {
                    label = "Максимална дужина",
                },
                fakePlatesMaxVehicleDistance = {
                    label = "Удаљеност од возила",
                },
                fakePlatesMinLength = {
                    label = "Минимална дужина",
                },
                fakePlatesPattern = {
                    description = "Lua образац за проверу текста лажне таблице, на пример ^[A-Z0-9]+$.",
                    label = "Lua образац",
                },
                fakePlatesPlateInstallDistance = {
                    label = "Удаљеност од места таблице",
                },
                fakePlatesPreventDuplicateDisplayPlates = {
                    label = "Блокирај дупликате активних лажних таблица",
                },
                fakePlatesPrinterItem = {
                    description = "Алат за израду или продавницу у економском систему лажних таблица.",
                    label = "Предмет штампача таблица",
                },
                fakePlatesRequireEngineOff = {
                    label = "Мотор мора бити искључен",
                },
                fakePlatesRequireOwnerOrKeys = {
                    description = "Користи Config.Functions.CanApplyFakePlate пре него што дозволи постављање.",
                    label = "Захтевај власника или кључеве",
                },
                fakePlatesRequireStopped = {
                    label = "Возило мора бити заустављено",
                },
                fakePlatesResetOnGarageStore = {
                    description = "Резервисано за интеграције гараже које позивају догађај или export за ресетовање.",
                    label = "Ресетуј при смештању у гаражу",
                },
                fakePlatesRiskCharacters = {
                    label = "Знакови за грешку",
                },
                fakePlatesRiskEnabled = {
                    label = "Омогући грешке због ризика",
                },
                fakePlatesRiskTypoChance = {
                    label = "Шанса за грешку",
                },
                fallbackVehicleValue = {
                    description = "Вредност која се користи када се не може одредити цена возила.",
                    label = "Вредност резервног возила",
                },
                firejobVehicleFiresCriticalChance = {
                    description = "Шанса од 0 до 1 након што мотор остане критичан.",
                    label = "Могућност пожара мотора у квару",
                },
                firejobVehicleFiresCriticalCooldownSeconds = {
                    description = "секунди пре него што пожар неисправног мотора може поново да почне.",
                    label = "Неисправно хлађење мотора",
                },
                firejobVehicleFiresCriticalDelayMs = {
                    description = "Кашњење у милисекундама пре него што се неисправни мотор може запалити.",
                    label = "Кашњење мотора у квару мс",
                },
                firejobVehicleFiresCriticalEnabled = {
                    description = "Омогућава критично оштећеним моторима да покрену пожар Фирејоб возила након одлагања.",
                    label = "Неисправни мотори се пале",
                },
                firejobVehicleFiresCriticalSmokeDensity = {
                    description = "Густина дима за упите о пожару поквареног мотора.",
                    label = "Густина дима мотора неисправан",
                },
                firejobVehicleFiresEnabled = {
                    description = "Дозвољава Мецханицјоб системима за оштећење да захтевају паљење возила од Фирејоба.",
                    label = "Омогући паљење возила Фирејоб",
                },
                firejobVehicleFiresForwardMotionRatio = {
                    description = "Неопходан однос кретања унапред од 0 до 1.",
                    label = "Однос кретања унапред",
                },
                firejobVehicleFiresImpactChance = {
                    description = "Шанса од 0 до 1 да ће ваљан удар изазвати пожар.",
                    label = "Шанса сагоревања",
                },
                firejobVehicleFiresImpactCooldownSeconds = {
                    description = "секунди пре него што ударни пожар може поново да почне.",
                    label = "Импацт Бурн Цоолдовн",
                },
                firejobVehicleFiresImpactEnabled = {
                    description = "Омогућава снажни фронтални удари да захтевају паљење Фирејоб возила.",
                    label = "Запалити се након тешких несрећа",
                },
                firejobVehicleFiresImpactSmokeDensity = {
                    description = "Густина дима за упите изазване пожаром након несреће.",
                    label = "Густина удара дима",
                },
                firejobVehicleFiresIntegrationMode = {
                    description = "Аутоматски користи конфигурисани Фирејоб ресурс. Онемогућено спречава Мецханицјоб да изазове пожар.",
                    label = "Режим интеграције",
                    options = {
                        automatic = "Аутоматски",
                        disabled = "Онемогућено",
                    },
                },
                firejobVehicleFiresMinBodyHealthLoss = {
                    description = "Минимално здравље тела изгубљено током удара.",
                    label = "Минимално оштећење тела",
                },
                firejobVehicleFiresMinEngineHealthLoss = {
                    description = "Минимално здравље мотора изгубљено током удара.",
                    label = "Минимална оштећења мотора",
                },
                firejobVehicleFiresMinFrontDeformation = {
                    description = "Користите 0 да бисте онемогућили ову проверу деформације.",
                    label = "Минимална предња деформација",
                },
                firejobVehicleFiresMinImpactSpeedKmh = {
                    description = "Минимална брзина пре удара у км/h.",
                    label = "Минимална брзина удара",
                },
                firejobVehicleFiresMinSpeedDropKmh = {
                    description = "Неопходан губитак брзине у км/h током удара.",
                    label = "Минимални губитак брзине",
                },
                firejobVehicleFiresResource = {
                    description = "Ресурс који прима захтеве за паљење возила.",
                    label = "Фирејоб ресурс",
                },
                firejobVehicleFiresServerEvent = {
                    description = "Интерни догађај сервера који клијент Мецханиц користи да захтева пожар Фирејоб возила.",
                    label = "Мецханиц сервер догађај",
                },
                freeVehicles = {
                    description = "Спавн модели добијају бесплатне послове подешавања.",
                    itemLabel = "Модел возила",
                    label = "Бесплатно подешавање возила",
                },
                handlingEditorFieldMaximum = {
                    description = "Строга највећа вредност коју уређивач прихвата за ово поље управљања.",
                },
                handlingEditorFocusKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Povratak u handling uređivač",
                },
                handlingEditorPayloadWarningBytes = {
                    description = "Број кодираних бајтова после којег се захтев, одговор или снимак уређивача пријављује као велики.",
                    label = "Праг великог пакета",
                },
                handlingEditorPerformanceChecksEnabled = {
                    description = "Мери операције уређивача и упозорава преко Sky.Debug када се прекораче подешене границе.",
                    label = "Провере перформанси",
                },
                handlingEditorPerformanceSummaryIntervalMs = {
                    description = "Број милисекунди између збирних прегледа перформанси док је детаљно евидентирање укључено.",
                    label = "Интервал сажетка",
                },
                handlingEditorPerformanceWarningMs = {
                    description = "Број милисекунди после којег се операција уређивача пријављује као спора.",
                    label = "Праг споре операције",
                },
                handlingEditorSliderMaximumDeviationPercent = {
                    description = "Највећи проценат за који нумерички клизач може да се помери изнад или испод учитане основне вредности возила. Директан унос и XML увоз остају без губитака. Максимум поља који се разликује од подразумеваног замењује горњу границу клизача.",
                    label = "Максимално одступање клизача",
                },
                instantTuningAllowedJobs = {
                    description = "Опциона глобална листа дозвољених. Оставите празно да бисте дозволили све док год је онемогућено само механичар.",
                    itemLabel = "Назив посла",
                    label = "Дозвољени послови",
                },
                instantTuningBlipColor = {
                    description = "ГТА Блип ИД боје.",
                    label = "Блип Цолор",
                },
                instantTuningBlipEnabled = {
                    description = "Приказује слике мапе за тренутне позиције подешавања.",
                    label = "Блип омогућен",
                },
                instantTuningBlipName = {
                    description = "Име слике на мапи.",
                    label = "Блип Наме",
                },
                instantTuningBlipSprite = {
                    description = "ГТА Блип Сприте ИД.",
                    label = "Блип Сприте",
                },
                instantTuningForceMarkerInteraction = {
                    description = "Користите е-интеракцију маркера чак и када је циљна подршка активна.",
                    label = "Интеракција маркера силе",
                },
                instantTuningInteractionDistance = {
                    description = "Подразумевана удаљеност за коришћење тачака тренутног подешавања.",
                    label = "Интеракциона удаљеност",
                },
                instantTuningLabel = {
                    description = "Подразумевани текст у тренутним тачкама подешавања.",
                    label = "Подразумевана ознака",
                },
                instantTuningLocations = {
                    description = "Тренутне тачке подешавања. Удаљеност 0 усваја подразумевану удаљеност интеракције.",
                    itemLabel = "позиција",
                    label = "позиција",
                },
                instantTuningMarkerEnabled = {
                    description = "Црта светски маркер на позицијама тренутног подешавања.",
                    label = "Маркер активиран",
                },
                instantTuningMarkerType = {
                    description = "Тип ГТА маркера за тренутне позиције подешавања.",
                    label = "Тип маркера",
                },
                instantTuningMechanicOnly = {
                    description = "Ограничава све позиције Инстант Туне на конфигурисане послове механичара.",
                    label = "Само механичар",
                },
                instantTuningPriceMultiplier = {
                    description = "Множилац за инстант награде за подешавање.",
                    label = "Множилац цене",
                },
                instantTuningProfile = {
                    description = "Конфигуришите које опције подешавања су доступне у тренутним тачкама подешавања.",
                    label = "Опције тренутног подешавања",
                },
                maintenanceNotificationsCooldownMinutes = {
                    description = "Минималан број минута пре него што исто возило може да покрене нови подсетник за одржавање.",
                    label = "Размак између обавештења",
                },
                maintenanceNotificationsEnabled = {
                    description = "Обавештава власнике возила када потрошни део достигне праг за одржавање.",
                    label = "Омогућено",
                },
                maintenanceNotificationsThreshold = {
                    description = "Проценат истрошености на или испод којег се одржавање сматра потребним.",
                    label = "Праг за одржавање",
                },
                mechanicCatalyticConverterCATALYTICACTIONCONTROL = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Krađa katalizatora · Kontrola 38",
                },
                mechanicCatalyticConverterCATALYTICCANCELCONTROL = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Krađa katalizatora · Kontrola 73",
                },
                mechanicDynoControl172 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Dinamometar · Kontrola 172",
                },
                mechanicDynoControl173 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Dinamometar · Kontrola 173",
                },
                mechanicDynoControl174 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Dinamometar · Kontrola 174",
                },
                mechanicDynoControl175 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Dinamometar · Kontrola 175",
                },
                mechanicDynoControl177 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Dinamometar · Kontrola 177",
                },
                mechanicDynoControl38 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Dinamometar · Kontrola 38",
                },
                mechanicDynoControl45 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Dinamometar · Kontrola 45",
                },
                mechanicDynoControl47 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Dinamometar · Kontrola 47",
                },
                mechanicSprayPaintControl200 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Farbanje · Kontrola 200",
                },
                mechanicSprayPaintControl202 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Farbanje · Kontrola 202",
                },
                mechanicVehicleCareControl200 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Nega vozila · Kontrola 200",
                },
                mechanicVehicleCareControl202 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Nega vozila · Kontrola 202",
                },
                mechanicVehiclePushINPUTCONTEXT = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Guranje vozila · Kontrola 38",
                },
                mechanicVehiclePushINPUTMOVEDOWN = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Guranje vozila · Kontrola 33",
                },
                mechanicVehiclePushINPUTMOVELEFT = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Guranje vozila · Kontrola 34",
                },
                mechanicVehiclePushINPUTMOVERIGHT = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Guranje vozila · Kontrola 35",
                },
                mechanicVehiclePushINPUTMOVEUP = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Guranje vozila · Kontrola 32",
                },
                mechanicVehiclePushINPUTSPRINT = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Guranje vozila · Kontrola 21",
                },
                mechanicWheelChangeControl200 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Zamena točka · Kontrola 200",
                },
                mechanicWheelChangeControl202 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Zamena točka · Kontrola 202",
                },
                mechanicWheelChangeControl22 = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Zamena točka · Kontrola 22",
                },
                mechanicWheelTheftWHEELTHEFTACTIONCONTROL = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Krađa točka · Kontrola 38",
                },
                mechanicWheelTheftWHEELTHEFTCANCELCONTROL = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Krađa točka · Kontrola 73",
                },
                mileageHudDigits = {
                    description = "Број цифара приказаних у ХУД-у километраже.",
                    label = "цифре",
                },
                mileageHudPosition = {
                    description = "Превуците ХУД преглед километраже на жељену позицију на екрану.",
                    label = "Положај",
                },
                mobileDynoConsumeItem = {
                    description = "Уклони један предмет након успешног постављања.",
                    label = "Потроши предмет",
                },
                mobileDynoCooldownMs = {
                    label = "Трајање хлађења",
                },
                mobileDynoCountdownMs = {
                    label = "Одбројавање старта",
                },
                mobileDynoDuiDistance = {
                    label = "Удаљеност приказа панела",
                },
                mobileDynoFanInteractionDistance = {
                    label = "Удаљеност контролера вентилатора",
                    description = "Удаљеност у метрима за коришћење физичког прекидача између навијача за хлађење.",
                },
                mobileDynoFullLoadDurationMs = {
                    label = "Трајање пуног оптерећења",
                    description = "Милисекунди провео на трајном пуном оптерећењу у профилима који укључују пуну фазу.",
                },
                mobileDynoHistoryLimit = {
                    label = "Лимит историје",
                },
                mobileDynoInteractionDistance = {
                    label = "Удаљеност интеракције",
                },
                mobileDynoItemUseEnabled = {
                    description = "Дозволи постављање динамометра и монитора коришћењем предмета.",
                    label = "Постављање предметом",
                },
                mobileDynoMaxActiveSessions = {
                    label = "Лимит активних сесија",
                },
                mobileDynoMaxVehicleDistance = {
                    label = "Удаљеност возила",
                },
                mobileDynoMonitorItem = {
                    description = "Предмет за постављање монитора резултата.",
                    label = "Предмет монитора",
                },
                mobileDynoPersistItems = {
                    description = "Сачувај нова постављања након поновног покретања сервера.",
                    label = "Сачувај постављања",
                },
                mobileDynoPickupDistance = {
                    description = "Највећа удаљеност у метрима за подизање опреме.",
                    label = "Удаљеност подизања",
                },
                mobileDynoPlacementMaxHeightSpread = {
                    label = "Максимална разлика висине",
                    description = "Највећа варијација висине у метрима прихваћена у свим динским сондама.",
                },
                mobileDynoPlacementMaxSlopeDegrees = {
                    label = "Максимални нагиб постављања",
                    description = "Максимални нагиб на земљи у степенима прихваћен преко дино отисака.",
                },
                mobileDynoRequireOnDuty = {
                    description = "Механичари морају бити на дужности за постављање и коришћење.",
                    label = "Обавезна дужност",
                },
                mobileDynoResultDuiDistance = {
                    label = "Удаљеност екрана резултата",
                    description = "Највећа растојање у метрима на којима је исцртан одвојени монитор резултата.",
                },
                mobileDynoReturnItem = {
                    description = "Врати потрошени предмет приликом подизања опреме.",
                    label = "Врати предмет",
                },
                mobileDynoStationItem = {
                    description = "Предмет за постављање динамометра.",
                    label = "Предмет динамометра",
                },
                mobileDynoTabletDistance = {
                    description = "Највећа удаљеност од динамометра у метрима за управљање таблетом и активне тестове.",
                    label = "Домет таблета",
                },
                nitroActivationKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Drži nitro",
                },
                oilLeaksCooldownSeconds = {
                    description = "секунди пре него што се ударно цурење може поново покренути.",
                    label = "Импацт Цоолдовн",
                },
                oilLeaksEnabled = {
                    description = "Омогућава оштећеним возилима са унутрашњим сагоревањем да пропуштају течност током вожње.",
                    label = "Омогући цурење течности",
                },
                oilLeaksEngineOilChance = {
                    description = "Нормална шанса цурења од 0 до 1.",
                    label = "Могућност моторног уља",
                },
                oilLeaksEngineOilCriticalChance = {
                    description = "Шанса критичног цурења од 0 до 1.",
                    label = "Критична прилика за моторно уље",
                },
                oilLeaksEngineOilCriticalThreshold = {
                    description = "Стање моторног уља из којег се користи критична прилика.",
                    label = "Критични праг моторног уља",
                },
                oilLeaksEngineOilThreshold = {
                    description = "Стање моторног уља у којем може да почне цурење.",
                    label = "Праг моторног уља",
                },
                oilLeaksForwardMotionRatio = {
                    description = "Неопходан однос кретања унапред од 0 до 1.",
                    label = "Однос кретања унапред",
                },
                oilLeaksFrontalImpactEnabled = {
                    description = "Омогућава јаким фронталним ударима да изазову привремено цурење течности мотора.",
                    label = "Предњи удар цурења",
                },
                oilLeaksImpactChance = {
                    description = "Шанса од 0 до 1 да ће валидан удар изазвати цурење.",
                    label = "Могућност цурења утицаја",
                },
                oilLeaksImpactRadius = {
                    description = "Радијус прве течне тачке створене ударом.",
                    label = "Радијус ударне тачке",
                },
                oilLeaksIntervalSeconds = {
                    description = "Минимум секунди између тачака стаза.",
                    label = "Интервал праћења",
                },
                oilLeaksLeakDurationSeconds = {
                    description = "Секунди колико цурење траје након ваљаног удара.",
                    label = "Трајање цурења удара",
                },
                oilLeaksMinBodyHealthLoss = {
                    description = "Минимално здравље тела изгубљено током удара.",
                    label = "Минимално оштећење тела",
                },
                oilLeaksMinDistance = {
                    description = "Минимална пређена удаљеност између тачака стазе.",
                    label = "Удаљеност стазе",
                },
                oilLeaksMinEngineHealthLoss = {
                    description = "Минимално здравље мотора изгубљено током удара.",
                    label = "Минимална оштећења мотора",
                },
                oilLeaksMinFrontDeformation = {
                    description = "Неопходна предња деформација. Користите 0 да бисте онемогућили ову проверу.",
                    label = "Минимална предња деформација",
                },
                oilLeaksMinImpactSpeedKmh = {
                    description = "Минимална брзина пре удара у км/h.",
                    label = "Минимална брзина удара",
                },
                oilLeaksMinSpeedDropKmh = {
                    description = "Неопходан губитак брзине у км/h током удара.",
                    label = "Минимални губитак брзине",
                },
                oilLeaksMinSpeedKmh = {
                    description = "Минимална брзина возила у км/h пре него што цурење течности може да створи траг.",
                    label = "Минимална брзина",
                },
                oilLeaksRadius = {
                    description = "Радијус уобичајених трагова течности возила.",
                    label = "Радијус стазе",
                },
                oilLeaksTransmissionFluidChance = {
                    description = "Нормална шанса цурења од 0 до 1.",
                    label = "Шанса за трансмисијску течност",
                },
                oilLeaksTransmissionFluidCriticalChance = {
                    description = "Шанса критичног цурења од 0 до 1.",
                    label = "Цритицал Геар Оппортунити",
                },
                oilLeaksTransmissionFluidCriticalThreshold = {
                    description = "Стање течности за пренос у коме се користи критична прилика.",
                    label = "Критични праг преноса",
                },
                oilLeaksTransmissionFluidThreshold = {
                    description = "Стање течности за мењач у коме може да почне цурење.",
                    label = "Праг течности за пренос",
                },
                orderInstallLiftBypassVehicleClasses = {
                    description = "Класе возила које могу да обављају послове по уговору који захтевају лифт без лифта за радионицу.",
                    itemLabel = "Додај класу возила",
                    label = "Часови заобилазнице",
                    options = {
                        ["0"] = "Компактни аутомобил",
                        ["1"] = "Лимузине",
                        ["10"] = "Индустријска возила",
                        ["11"] = "Комерцијална возила",
                        ["12"] = "Комби",
                        ["13"] = "Бицикли",
                        ["14"] = "Чамци",
                        ["15"] = "Хеликоптер",
                        ["16"] = "Авиони",
                        ["17"] = "Сервисна возила",
                        ["18"] = "Возила хитне помоћи",
                        ["19"] = "Војна возила",
                        ["2"] = "СУВ возила",
                        ["20"] = "Комерцијална возила",
                        ["21"] = "Возови",
                        ["22"] = "Отворени точак",
                        ["3"] = "Купе",
                        ["4"] = "Мусцле Царс",
                        ["5"] = "Спортс Цлассиц",
                        ["6"] = "Спортски аутомобил",
                        ["7"] = "Суперауто",
                        ["8"] = "Мотоцикли",
                        ["9"] = "СУВ",
                    },
                },
                orderInstallLiftBypassVehicleModels = {
                    description = "Модели покретања возила који могу да обављају уговорне послове који захтевају лифт без лифта у радионици.",
                    itemLabel = "Модел возила",
                    label = "Лифт Бипасс модели",
                },
                orderInstallNonMinigameDurationMs = {
                    description = "Милисекунди за кораке инсталације налога без мини игре.",
                    label = "Лако време инсталације",
                },
                partsDeliveryCompanyCard = {
                    description = "Испоруке делова могу користити средства са рачуна компаније.",
                    label = "Картица компаније",
                },
                partsDeliveryMode = {
                    description = "Задржава стандардни физички ток или додаје целу испоруку директно у инвентар играча који је преузима.",
                    label = "Обрада испоруке",
                    options = {
                        player_inventory = "Инвентар играча",
                        standard = "Стандардни ток испоруке",
                    },
                },
                partsDeliveryOpenDurationMs = {
                    description = "Милисекунди за распакивање готове испоруке делова.",
                    label = "Време распакивања",
                },
                partsDeliveryOwnCard = {
                    description = "Играчима је дозвољено да својим новцем плаћају испоруке делова.",
                    label = "Сопствена мапа",
                },
                partsDeliveryTimeSeconds = {
                    description = "Секунди између наручивања делова и испоруке.",
                    label = "Време испоруке",
                },
                partsTheftCatalyticConverterItem = {
                    description = "Ставка инвентара додељена након крађе катализатора.",
                    label = "Артикал катализатора",
                },
                partsTheftDealerAccount = {
                    description = "Рачун за исплате са ограде, нпр. Б. новац или банка.",
                    label = "Рачун за исплату трговца",
                },
                partsTheftDealerItems = {
                    description = "Украдени предмети које дилер купује, укључујући исплату.",
                    itemLabel = "Предмет дилера",
                    label = "Предмети дилера",
                },
                partsTheftDealerPayoutItem = {
                    description = "Ставка инвентара се додељује када је тип исплате Ставка. Продајна цена се користи као количина артикла.",
                    label = "Ставка исплате трговцу",
                },
                partsTheftDealerPayoutType = {
                    description = "Одаберите да ли трговац плаћа на оквирни рачун или даје ставку инвентара.",
                    label = "Тип исплате трговцу",
                    options = {
                        account = "Налог",
                        item = "Ставка",
                    },
                },
                partsTheftDealerSellDistance = {
                    description = "Максимална удаљеност до дилера за продају украдених делова.",
                    label = "Удаљеност продаје",
                },
                partsTheftDispatchCooldownSeconds = {
                    description = "секунди док исти део возила не може поново да покрене отпрему.",
                    label = "Диспатцх Цоолдовн",
                },
                partsTheftDispatchEnabled = {
                    description = "Креира полицијску депешу ако је точак или катализатор украден.",
                    label = "Пошаљите полицијску депешу",
                },
                partsTheftDispatchJobs = {
                    description = "Називи послова који примају пошиљке о крађи делова.",
                    itemLabel = "Назив посла",
                    label = "Послови отпреме",
                },
                partsTheftDispatchMessage = {
                    description = "Отпремање алармне поруке. Подржава {plate}, {part} и {type}.",
                    label = "Отпремна порука",
                },
                partsTheftDispatchTitle = {
                    description = "Наслов упозорења о отпреми. Подржава {plate}, {part} и {type}.",
                    label = "Наслов отпреме",
                },
                partsTheftItem = {
                    description = "Инвентар за крађу точкова и катализатора.",
                    label = "Алат за крађу",
                },
                partsTheftRemoveItemAfterUse = {
                    description = "Уклоните алат за крађу након успешне крађе.",
                    label = "Алат за конзумирање",
                },
                partsTheftStolenWheelItem = {
                    description = "Предмет инвентара који се додељује када је бицикл украден.",
                    label = "Украдени точак",
                },
                priceType = {
                    description = "Проценат користи цену возила, фиксно користи новчане износе, а класа возила користи табелу класа.",
                    label = "Тип цене",
                    options = {
                        class = "Класа возила",
                        fixed = "Фиксно",
                        percentage = "Проценат",
                    },
                },
                primaryColor = {
                    description = "Подразумевана боја за групу механичарских послова и нове послове. Користите хексадецималну вредност као што је #EDC001.",
                    label = "Примарна боја",
                },
                publicUsersSeePrices = {
                    description = "Омогућено: Купци плаћају приликом наручивања. Деактивирано: неплаћена поруџбина за каснији обрачун механичара.",
                    label = "Израчунајте јавне самоуслужне поруџбине",
                },
                registryBikeChecks = {
                    description = "Kontrolne stavke za motocikle",
                    label = "Kontrolne stavke za motocikle",
                },
                registryCarChecks = {
                    description = "Kontrolne stavke za automobile",
                    label = "Kontrolne stavke za automobile",
                },
                registryDistance = {
                    description = "Servisna udaljenost (metri)",
                    label = "Servisna udaljenost (metri)",
                },
                registryKuvFee = {
                    description = "Tehnički pregled vozila naknada",
                    label = "Tehnički pregled vozila naknada",
                },
                registryKuvValidityDays = {
                    description = "Važenje novih pregleda u stvarnom vremenu. Podrazumevano: 30 dana. Postojeći rokovi ostaju isti.",
                    label = "Važenje pregleda (stvarni dani)",
                },
                registryKuvWarningDays = {
                    description = "Period upozorenja (dani)",
                    label = "Period upozorenja (dani)",
                },
                registryRegistrationFee = {
                    description = "Naknada za registraciju",
                    label = "Naknada za registraciju",
                },
                registryReinspectionFee = {
                    description = "Naknada za ponovni pregled",
                    label = "Naknada za ponovni pregled",
                },
                registryRequireKuv = {
                    description = "Zahtevaj važeći Tehnički pregled vozila za registraciju",
                    label = "Zahtevaj važeći Tehnički pregled vozila za registraciju",
                },
                registrySessionSeconds = {
                    description = "Vreme potvrde (sekunde)",
                    label = "Vreme potvrde (sekunde)",
                },
                registryTransferFee = {
                    description = "Naknada za prenos",
                    label = "Naknada za prenos",
                },
                registryVehicleTypes = {
                    description = "Dozvoljeni tipovi vozila",
                    label = "Dozvoljeni tipovi vozila",
                },
                subscriptionsAllowJobSubscriptions = {
                    description = "Омогућава овлашћеним шефовима да средствима компаније купе претплату за цео посао.",
                    label = "Претплате за компаније",
                },
                subscriptionsCurrency = {
                    description = "sky_base валута која се користи за куповину претплата, на пример bank.",
                    label = "Валута плаћања",
                },
                subscriptionsEnabled = {
                    description = "Омогућава претплате радионице, корисничке терминале и попусте на претплате.",
                    label = "Омогућено",
                },
                subscriptionsMaximumDurations = {
                    description = "Максималан број опција трајања и цене за сваки модел претплате.",
                    label = "Максималан број трајања",
                },
                subscriptionsMaximumModels = {
                    description = "Максималан број модела претплате које радионица може да подеси у таблету.",
                    label = "Максималан број модела",
                },
                subscriptionsNpcEmoteClip = {
                    description = "Опциони понављајући анимациони клип који се користи када је сценарио празан.",
                    label = "НПЦ клип емота",
                },
                subscriptionsNpcEmoteDict = {
                    description = "Опциони речник анимације који се користи када је сценарио празан.",
                    label = "НПЦ речник емота",
                },
                subscriptionsNpcPedModel = {
                    description = "Пед модел који се појављује на терминалима за претплату, на пример s_m_m_autoshop_01.",
                    label = "НПЦ пед модел",
                },
                subscriptionsNpcScenario = {
                    description = "Опциони GTA сценарио као што је WORLD_HUMAN_CLIPBOARD. Оставите празно да бисте користили емот анимацију.",
                    label = "НПЦ сценарио",
                },
                tuningFocusKey = {
                    description = "Podrazumevana FiveM prečica, npr. E, F6 ili MOUSE_BUTTON:MOUSE_RIGHT. Prazno znači da nema podrazumevanog tastera. Igrači menjaju svoje prečice u FiveM podešavanjima; sačuvane prečice ostaju nepromenjene.",
                    label = "Tuning: interakcija mišem",
                },
                tuningWorkshopDistance = {
                    description = "Максимално растојање до тачке самоуслужног подешавања за уградњу или уклањање.",
                    label = "Удаљеност радионице",
                },
                tuningWorkshopRequireForInstall = {
                    description = "Инсталације за подешавање морају почети и завршити близу места за самоуслужно подешавање.",
                    label = "Потребна радионица за инсталацију",
                },
                tuningWorkshopRequireForRemoval = {
                    description = "Проширење подешавања мора почети и завршити близу тачке за самоуслужно подешавање.",
                    label = "Радионица потребна за проширење",
                },
                vehicleCareRepairDurationMs = {
                    description = "Трајање напредовања поправке у милисекундама.",
                    label = "Трајање поправке",
                },
                vehicleCareRepairFixRealisticWheelDamage = {
                    description = "Такође ресетује реално оштећење точкова приликом поправке.",
                    label = "Реалистична поправка оштећења точкова",
                },
                vehicleCareRepairItem = {
                    description = "Ставка инвентара за кампању поправке возила.",
                    label = "Ставка за поправку",
                },
                vehicleCareRepairMaxDistance = {
                    description = "Максимално растојање до возила током поправке.",
                    label = "Макс. удаљеност поправке",
                },
                vehicleCareRepairRemoveAfterUse = {
                    description = "Уклоните поправку након употребе.",
                    label = "Потрошите предмет за поправку",
                },
                vehicleCareRepairVehicleDamage = {
                    description = "Поправи уобичајена оштећења ГТА возила током кампање поправке.",
                    label = "Поправите штету на возилу",
                },
                vehicleCareRepairWearParts = {
                    description = "Одаберите које истрошене и сервисне делове враћа ставка за поправку. Онемогућите течности овде ако уље, расхладна течност, кочиона течност или течност за мењач захтевају дијагностичку поправку.",
                    itemLabel = "Носиви део",
                    label = "Делови поправљени комплетом за поправку",
                },
                vehicleCareWashItem = {
                    description = "Инвентар за прање возила.",
                    label = "Предмет за прање",
                },
                vehicleCareWashRemoveAfterUse = {
                    description = "Уклоните предмет за прање након употребе.",
                    label = "Цонсуме Васх Итем",
                },
                vehicleCareWaxCleanKilometers = {
                    description = "Раздаљина на којој воском возило остаје чисто.",
                    label = "километара чистих од воска",
                },
                vehicleCareWaxItem = {
                    description = "Инвентар за узгој возила.",
                    label = "Артикал од воска",
                },
                vehicleCareWaxRemoveAfterUse = {
                    description = "Уклоните воштани предмет након употребе.",
                    label = "Конзумирајте восак",
                },
                vehicleClassPricing = {
                    description = "Замени тип цене и множилац трошкова за сваку GTA класу возила.",
                    label = "Цене по класи возила",
                },
                wearParts = {
                    description = "Делови возила који се троше, километража, потребна поправка, потрошња предмета и процес уградње.",
                    fields = {
                        flow = {
                            options = {
                                catalytic_converter = "Цаталист",
                                fluid_refill = "Течност за допуну",
                                hood_install = "Инсталирање хаубе",
                                oil_change = "Замена уља",
                                performance = "Перформансе",
                                underbody_neon = "Подвозје / платформа за подизање",
                                wheel = "Точак",
                            },
                        },
                    },
                    itemLabel = "Носиви део",
                    label = "Делови који се хабају",
                },
                wheelDamageDefaultMultiplier = {
                    description = "Множитељ оштећења основног точка.",
                    label = "Стандардни множилац",
                },
                wheelDamageDeformationAngleThreshold = {
                    description = "Филтрира тачке сонде деформације које нису усмерене ка каросерији возила.",
                    label = "Праг угла узорка",
                },
                wheelDamageDeformationDamageIncrement = {
                    description = "Додатна снага по покретању опоравка.",
                    label = "Повећање штете од деформације",
                },
                wheelDamageDeformationEnabled = {
                    description = "Открива и обнавља удубљења каросерије када поправка гума обнавља геометрију точкова.",
                    label = "Врати деформацију",
                },
                wheelDamageDeformationInitialDamage = {
                    description = "Почетна снага за опоравак удубљења.",
                    label = "Почетно оштећење деформације",
                },
                wheelDamageDeformationMaxIterations = {
                    description = "Максималан број покретања СетВехицлеДамаге да би се поправили удубљења.",
                    label = "Итерације деформације",
                },
                wheelDamageDeformationThreshold = {
                    description = "Минимална откривена чврстоћа деформације која се чува.",
                    label = "Праг деформације",
                },
                wheelDamageOffroadWheelsMultiplier = {
                    description = "Мултипликатор ако возило има теренске точкове.",
                    label = "Множилац Оффроад бицикла",
                },
                wheelDamageRepairInstantDamageReapplyPasses = {
                    description = "Додатни тренутни опоравак за оштећење гуме након реконструкције геометрије точка.",
                    label = "Поновна примена штете",
                },
                wheelDamageRepairInstantWheelStateReapplyPasses = {
                    description = "Додатне тренутне вожње за континуирано нестајање или пробушене гуме након поправке пнеуматика.",
                    label = "Поновна пријава статуса точка",
                },
                wheelDamageRepairPreserveNonWheelDamage = {
                    description = "Чува каросерију, мотор, прозор, врата, прљавштину и оштећење видљивости када поправка гума обнавља геометрију точкова.",
                    label = "Примљена штета на возилу",
                },
                wheelDamageRepairQuietWindowRemoval = {
                    description = "Враћа разбијене прозоре што је више могуће без гласног ефекта уништавања.",
                    label = "Тихи разбијени прозори",
                },
                wheelDamageRepairSilentPoppedReapply = {
                    description = "Наставља да поново поставља пробушене гуме без изазивања новог звука или ефекта пуцања гуме.",
                    label = "Тиха поновна употреба пробушене гуме",
                },
                wheelDamageTyreRepairAttachDistance = {
                    description = "Максимално растојање до оштећене или недостајуће гуме за акцију уградње.",
                    label = "Растојање за уградњу пнеуматика",
                },
                wheelDamageTyreRepairCarJackRemoveDistance = {
                    description = "Максимална удаљеност до постављеног џека за акцију уклањања.",
                    label = "Раздаљина уклањања Јацка",
                },
                wheelDamageVehicleClassMultipliers = {
                    description = "Множиоци штете по ГТА класи возила.",
                    itemLabel = "Класа возила",
                    label = "Множитељи класа возила",
                },
                advancedPricingAnalyticsPeriodDays = {
                    description = "Број дана приказаних у таблет анализи профита.",
                    label = "Период аналитике",
                },
                advancedPricingCategoryRules = {
                    description = "Добављач дељења, маргине, рад и границе цене према категорији подешавања.",
                    label = "Категорија правила",
                },
                advancedPricingDefaultMarginPercent = {
                    description = "Подразумевана маргина механичара пре класе и прилагођавања разреда.",
                    label = "Подразумевана маргина",
                },
                advancedPricingDifficultyRules = {
                    description = "Додатни трошкови рада за сваку тежину прилагођавања.",
                    label = "Тешкоће правила",
                },
                advancedPricingInventoryBaseStock = {
                    description = "Нормална виртуелна залиха за сваки добављач.",
                    label = "Основна залиха",
                },
                advancedPricingInventoryDemandDecayPerDay = {
                    description = "Тачке захт› јева уклоњене по протеклим дану.",
                    label = "Дневна потражња пропада",
                },
                advancedPricingInventoryDemandMarkupPerUnitPercent = {
                    description = "Добављач маркер додао за сваку тачку захтева.",
                    label = "Означавање захт› јева по јединици",
                },
                advancedPricingInventoryEnabled = {
                    description = "Повиши цене добављача када је виртуелна залиха ниска или је потражња висока.",
                    label = "Динамички добављач",
                },
                advancedPricingInventoryLowStockMarkupPercent = {
                    description = "Највећа ознака добављача изазвана ниским залихама.",
                    label = "нискосточно означавање",
                },
                advancedPricingInventoryLowStockThreshold = {
                    description = "Ниво деоница испод којег почетак несташке цене.",
                    label = "праг ниског залиха",
                },
                advancedPricingInventoryMaximumDemandMarkupPercent = {
                    description = "Горња граница за потражњу.",
                    label = "Највећа ознака потражње",
                },
                advancedPricingInventoryRestockPerDay = {
                    description = "Виртуелне јединице попуњене у протекли дан.",
                    label = "Дневна поновна залиха",
                },
                advancedPricingMaximumDiscountPercent = {
                    description = "Глобални попуст плафон за рачуне механичара.",
                    label = "Максимални попуст",
                },
                advancedPricingMaximumMarginPercent = {
                    description = "Највише дозвољена механичка маргина.",
                    label = "Највећа маргина",
                },
                advancedPricingMaximumRetailPrice = {
                    description = "Глобална граница горње цене за део за подешавање.",
                    label = "Највећа малопродатна цена",
                },
                advancedPricingMechanicGradeRules = {
                    description = "Означавање, рад и попуст границе по механичком разреду.",
                    label = "Механичка правила",
                },
                advancedPricingMinimumMarginPercent = {
                    description = "Најнижа дозвољена механичка маргина.",
                    label = "Најмања маргина",
                },
                advancedPricingMinimumRetailPrice = {
                    description = "Глобална нижа граница цене за део за подешавање.",
                    label = "Најмања малопродајна цена",
                },
                advancedPricingPreviewCompactValue = {
                    description = "Вредност возила за компактан пример.",
                    label = "Компактна вредност прегледа",
                },
                advancedPricingPreviewCostPercent = {
                    description = "Прим› јер проценат трошкова који користи преглед уживо.",
                    label = "Учестаност подешавања прегледа",
                },
                advancedPricingPreviewSportsValue = {
                    description = "Вредност возила за спортски пример.",
                    label = "Вр› иједност спортског прегледа",
                },
                advancedPricingPreviewSuperValue = {
                    description = "Вредност возила за пример супераута.",
                    label = "Вр› иједност супер прегледа",
                },
                advancedPricingQuoteLifetimeMinutes = {
                    description = "Минуте пре него што се израчуна неплаћена цена.",
                    label = "Цитирам живот",
                },
                advancedPricingReturnRefundPercent = {
                    description = "Проценат повраћен за део набављене наредбе.",
                    label = "Враћање повраћања",
                },
                advancedPricingRoundingStep = {
                    description = "Заокружи сваку династију линију набавке до овог корака новца.",
                    label = "корак заокружења добављача",
                },
                advancedPricingSupplierSharePercent = {
                    description = "Проценат део купца наплаћује династију Ауто снабдевање.",
                    label = "добављач дељења",
                },
                advancedPricingTaxPercent = {
                    description = "Проценат пореза складиштен одвојено у рачунању цена.",
                    label = "Порез",
                },
                advancedPricingVehicleClassRules = {
                    description = "Подешавање маргина и рада за GTA класу возила.",
                    label = "Правила класе возила",
                },
                handlingEditorBlockCriticalValidation = {
                    description = "Спречи прим› јену док постоји критичан сукоб са руковањем.",
                    label = "Блокирај критичне налажења",
                },
                handlingEditorCoachMinimumBrakeDeceleration = {
                    description = "Очекивано је максимално успорење у m/s2 за завршени кочни тест.",
                    label = "Најмање успоравање кочница",
                },
                handlingEditorCoachMinimumSamples = {
                    description = "Измерени узорци неопходни пре Телеметрија тренер процењује трчање.",
                    label = "Најмањи узорци",
                },
                handlingEditorCoachWheelSlipWarningKmh = {
                    description = "Измерена брзина спуцања точкова у км/ч на којој се пријављује губитак вучења.",
                    label = "Упозорење точкова",
                },
                handlingEditorDefaultTab = {
                    description = "Страница је изабрана кад се отвори самостојни уређивач руковања.",
                    label = "Почетна страница",
                    options = {
                        advanced = "Напредно",
                        export = "Извоз",
                        flags = "Заставице",
                        fleet = "Флота",
                        inspector = "Слојеви",
                        profiles = "Профили",
                        simple = "Једноставно",
                        telemetry = "Телеметрија",
                    },
                },
                handlingEditorFieldDocumentationEnabled = {
                    description = "Осигурајте ефекат, референтни опсег, симптоме, сродна поља и подршку за сваку вредност руковања.",
                    label = "Документација поља",
                },
                handlingEditorFlagSearchEnabled = {
                    description = "Претрага и филтрирање имена застава, ефеката, битних положаја и хексадецималне маске.",
                    label = "Претрага заставе",
                },
                handlingEditorFleetManagerEnabled = {
                    description = "Претражите, прегледајте, промовирајте и повратите правила за руковање моделом и плочама.",
                    label = "Управник флоте",
                },
                handlingEditorLayerInspectorEnabled = {
                    description = "Прикажи базу возила, инсталирано посебно подешавање, правило модела, правило плоче и тренутни нацрт уређивача за свако поље.",
                    label = "Инспектор слоја",
                },
                handlingEditorMaxFleetResults = {
                    description = "Максимални модел и таблица правила упућена у Флит Менаџер.",
                    label = "Ограничење резултата флоте",
                },
                handlingEditorMaxProfileRevisions = {
                    description = "Највећи број ревизија задржаних за сваки профил.",
                    label = "Ревизија профила",
                },
                handlingEditorMaxWorkspacesPerAdmin = {
                    description = "Највише назване радне површи за сваког администратора.",
                    label = "Личне радне површине",
                },
                handlingEditorProfileVersioningEnabled = {
                    description = "Направи ревизију коју се може ревидирати сваки пут када се ажурира или обнови заједнички профил.",
                    label = "Верзија профила",
                },
                handlingEditorTelemetryCoachEnabled = {
                    description = "Направите провидне препоруке на основу правила из мерених података о тесту на путу.",
                    label = "Тренер телеметрије",
                },
                handlingEditorValidatorEnabled = {
                    description = "Откријте небезбедне или контрадикторне комбинације пре прим› јене.",
                    label = "Рашчлањивање в› јеровача",
                },
                handlingEditorWorkspacesEnabled = {
                    description = "Дозволи администраторима да задржавају приватне нацрте уређивача.",
                    label = "Личне радне површине",
                },
                orderInstallNonMinigameVehicleClasses = {
                    description = "Идентификатори класе возила који увек користе нормалну механичку инсталацију без специјализованог тока лифта или мини игре.",
                    label = "класе возила без минигаме",
                },
                orderInstallNonMinigameVehicleModels = {
                    description = "Модели за мрештење возила који увек користе нормалну механичку инсталацију без специјализованог тока лифта или минигаме.",
                    label = "модели возила без минигаме",
                },
                tuningBlockedPlates = {
                    description = "Возила са једним од ових плоча не могу се подесити, инсталирати или уклонити. Поклапање игнорише чаура и празнине.",
                    itemLabel = "регистарске таблице",
                    label = "Блокиране таблице",
                },
                vehicleCareRepairBlockForNonMechanicsWhenMechanicsOnDuty = {
                    label = "Блокирај друге послове када су механичари на дужности",
                },
                allowsprint = {
                    label = "Дозволи спринт са кутијама за доставу",
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
            tuningCategories = {
                bodywork = "Каросерија и изглед",
                electronics = "ECU и електроника возила",
                engineSounds = "Звукови мотора",
                handling = "Управљање",
                lights = "Светла",
                other = "Остало",
                paint = "Фарбање",
                performance = "Перформансе",
                stance = "Стенс",
                wheels = "Точкови",
            },
            tuningOptions = {
                antilag_enabled = {
                    label = "Анти-лаг",
                    values = {
                        [0] = "Искључено",
                        [1] = "GTA стандард",
                        [2] = "Улично пуцкетање",
                        [3] = "Тркачки Anti-Lag",
                        [4] = "Рели Anti-Lag",
                    },
                },
                electronic_automatic_hazards = {
                    label = "Automatska sva četiri",
                    values = {
                        [0] = "Isključeno",
                        [1] = "Uključeno",
                    },
                },
                electronic_brake_lights = {
                    label = "Stop svetla",
                    values = {
                        [0] = "Normalno",
                        [1] = "Hitno treptanje",
                        [2] = "Isključeno",
                    },
                },
                electronic_engine_tune = {
                    label = "Softver motora",
                    values = {
                        [0] = "Fabrički",
                        [1] = "Nivo 1",
                        [2] = "Nivo 2",
                        [3] = "Nivo 3",
                        [4] = "Nivo 4",
                    },
                },
                electronic_headlight_brightness = {
                    label = "Jačina farova",
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
                    label = "Duga svetla uz sirenu",
                    values = {
                        [0] = "Isključeno",
                        [1] = "Uključeno",
                    },
                },
                electronic_idle_rpm = {
                    label = "Obrtaji u leru",
                    values = {
                        [0] = "Fabrički",
                        [1] = "20%",
                        [2] = "30%",
                        [3] = "40%",
                        [4] = "50%",
                    },
                },
                electronic_interior_light = {
                    label = "Unutrašnje svetlo",
                    values = {
                        [0] = "Normalno",
                        [1] = "Crveno",
                    },
                },
                electronic_mood_color = {
                    label = "Boja ambijentalnog svetla",
                    values = {
                        [0] = "Isključeno",
                        [1] = "Crveno",
                        [10] = "Lajm",
                        [11] = "Tirkizno",
                        [12] = "Индиго",
                        [13] = "Belo",
                        [14] = "Toplo belo",
                        [15] = "Hladno belo",
                        [16] = "Ćilibar",
                        [2] = "Plavo",
                        [3] = "Zeleno",
                        [4] = "Cijan",
                        [5] = "Магента",
                        [6] = "Žuto",
                        [7] = "Narandžasto",
                        [8] = "Ljubičasto",
                        [9] = "Roze",
                    },
                },
                electronic_mood_intensity = {
                    label = "Jačina ambijentalnog svetla",
                    values = {
                        [0] = "Prigušeno",
                        [1] = "Normalno",
                        [2] = "Jako",
                    },
                },
                electronic_radio_power = {
                    label = "Napajanje radija",
                    values = {
                        [0] = "Isključeno",
                        [1] = "Uključeno",
                    },
                },
                electronic_throttle_response = {
                    label = "Odziv gasa",
                    values = {
                        [0] = "Više trakcije",
                        [1] = "Agresivno",
                    },
                },
                electronic_wheelie_tune = {
                    label = "Wheelie podešavanje",
                    values = {
                        [0] = "Isključeno",
                        [1] = "Blago",
                        [2] = "Intenzivno",
                    },
                },
            },
            vehicleClassLabel = "Класа {id} ({name})",
        },
    },
}
