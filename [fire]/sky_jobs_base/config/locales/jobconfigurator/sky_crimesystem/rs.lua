JobConfigLocales["sky_crimesystem:rs"] = {
    Nui = {
        workshopConfig = {
            creatorCommand = "Direktna komanda",
            roleDefaults = {
                title = "Uloge",
                description = "Izaberite minimalni čin za svaku podrazumevanu dozvolu. Dozvole činova sačuvane u meniju šefa imaju prednost.",
                bossHint = "Činovi šefa i zamenika uvek zadržavaju pun pristup.",
                empty = "Za ovaj posao još nema dostupnih činova.",
                gradesTitle = "Činovi posla",
                noDefault = "Bez podrazumevane dozvole",
                rankOption = "{grade} – {label}",
            },
            weaponDefaultsDescription = "Заједничке вредности важе за поља која их наслеђују. Измена на страници подешавања поставља сопствену вредност. Постојећи уноси задржавају своје вредности.",
            weaponStreetDescription = "Pri kontaktu za uličnu prodaju droge server ponekad može kupiti dozvoljeno oružje. Izbor, cenu i isplatu određuje server.",
            weaponGroups = {
                general = "Опште подразумеване вредности",
                access = "Подразумевани приступ",
                collection = "Подразумевано сакупљање",
                production = "Подразумевана производња",
                market = "Подразумевано тржиште",
                delivery = "Подразумевани налози",
                street = "Улична продаја оружја",
            },
            weaponOptions = {
                scrap_search = "Pretraži gomilu otpada",
                player = "Po igraču",
                global = "Globalno",
                money = "Кеш",
                bank = "Банкарски налог",
                black_money = "Црни новац.",
                timing = "Заустави показивач унутар оптималног опсега.",
                precision = "Временски одредите сваки рез унутар прозора прецизности.",
                pressure = "Зауставите пресу на његовом оптималном притиску.",
            },

            reputation = {
                remove = "Obriši",
                title = "Reputacija",
                action = "Radnja",
                points = "Poeni po završetku",
                enabled = "Aktivno",
                search = "Pretraži radnje",
                added = "Već dodato",
                noResults = "Nema odgovarajućih radnji.",
                empty = "Još nema radnji. Dodajte radnju dugmetom plus.",
                name = "Назив правила",
                target = "Циљ (необавезно)",
            },
            configs = {
                sky_crimesystem = {
                    entries = "Frakcije",
                    subtitle = "Конфигурирајте криминалне послове и њихове заједничке локације.",
                    title = "Систем кримина",
                },
            },
            creatorSections = {
                mainbaseZones = {
                    entryLabel = "Главна база",
                    entryPluralLabel = "Главне базе",
                    label = "Зона главне базе",
                },
                presetTerritories = {
                    label = "Предлошки округи",
                    entryLabel = "Предлошки округ",
                    entryPluralLabel = "Предлошки округи",
                },
                customTerritories = {
                    label = "Прилагођене територије",
                    entryLabel = "Прилагођена територија",
                    entryPluralLabel = "Прилагођене територије",
                },
                objectsSection = {
                    label = "Објекти испитивања",
                    entryLabel = "Објекат",
                    entryPluralLabel = "Објекти испитивања",
                },
                blockedZonesSection = {
                    label = "Блокиране зоне",
                    entryLabel = "Зона",
                    entryPluralLabel = "Блокиране зоне",
                },
                toolsSection = {
                    label = "Алат",
                    entryLabel = "Алат",
                    entryPluralLabel = "Алат",
                },
                sessionsSection = {
                    label = "Трајуће сесије",
                    entryLabel = "Сесија",
                    entryPluralLabel = "Трајуће сесије",
                },
                orphansSection = {
                    label = "Напуштени објекти",
                    entryLabel = "Објекат",
                    entryPluralLabel = "Напуштени објекти",
                },
            },
            darknetActions = {
                currentLocation = "Користи тренутну локацију",
            },
            drugSettings = {
                drugGrowthCurve = {
                    description = "Више вредности чине лошу негу много споријом, док се задржавају јаки бонуси за добру негу.",
                    label = "Крива одзива на негу",
                },
                drugGrowthMaxMultiplier = {
                    description = "Достигнут максимални множилац раста под одличним условима.",
                    label = "Множилац савршене неге",
                },
                drugGrowthMinMultiplier = {
                    description = "Множилац раста коришћен када су услови за раст критично лоши.",
                    label = "Множилац критичне неге",
                },
                drugGrowthQualityBonusMax = {
                    description = "Максимални додатни бонус за раст који даје квалитет биљака.",
                    label = "Бонус за раст квалитета",
                },
            },
            errors = {
                invalid_role_permission_defaults = "Izaberite važeće minimalne činove za dozvole uloga.",
                base_raid_locked = "База се напада. Локације за складиштење и конфигурација су блокиране.",
                base_storage_outside_zone = "Сви складишта, ормари и тачке за складиштење хеиста морају бити унутар зоне базе.",
                base_zone_invalid_polygon = "Поставите најмање три различите тачке без пресецања ивица, затим проверите висину (3–200 м) и кошу за рутингу.",
                base_zone_point_limit = "Зона главне базе подржава највише 64 граничних тачака.",
                base_zone_required = "Прво конфигуришите валидну зону главне базе за овај криминалски задатак.",
                crime_interrogation_invalid_model = "Unesite važeći model objekta.",
                crime_interrogation_invalid_coords = "Postavite objekat na važeću poziciju.",
                crime_interrogation_invalid_zone_points = "Postavite najmanje tri važeće granične tačke.",
                crime_interrogation_duplicate_id = "Objekat sa ovim ID-jem već postoji.",
                crime_interrogation_tool_invalid = "Proverite definiciju alata.",
                crime_interrogation_tool_id_invalid = "Unesite važeći ID alata.",
                crime_interrogation_tool_label_missing = "Unesite naziv alata.",
                crime_interrogation_effect_missing = "Podesite efekat alata.",
                crime_interrogation_effect_type_unknown = "Izaberite podržan tip efekta.",
                crime_interrogation_effect_status_missing = "Navedite stanje na koje ovaj alat utiče.",
                crime_interrogation_minigame_missing = "Podesite mini-igru za alat.",
                crime_interrogation_minigame_type_unknown = "Izaberite podržan tip mini-igre.",
                crime_interrogation_keys_missing = "Podesite kontrole alata.",
                crime_interrogation_keys_invalid = "Proverite podešene kontrole alata.",
                crime_interrogation_keys_duplicate = "Dodelite svaku radnju i kontrolu alata samo jednom.",
                crime_interrogation_anim_invalid = "Proverite rečnik i snimak animacije alata.",
                crime_interrogation_anim_missing = "Podesite animaciju korisnika alata.",
                crime_interrogation_occupied = "Неко је већ везан за овај објекат.",
                crime_interrogation_not_found = "То више не постоји.",
            },
            extensions = {
                baseZone = {
                    description = "Поставите од 3 до 64 граничне тачке у том редоследу. Најнижа постављена тачка одређује дно; висина се протеже одатле нагоре. Тачке се сачувају као нацрт; користите Сачувај да примените зону. Само складиште, ормари и складиште за пљачку унутар зоне су приступачни током упада. Тачке ван зоне не спречавају сачување ни почетак упада. Постојеће границе остају активне док не сачувате.",
                    fields = {
                        bucket = "Рутинг канта",
                        configured = "Конфигурисано",
                        height = "Висина (метри)",
                        radius = "Радијус (метри)",
                        x = "Центар X",
                        y = "Центар Y",
                        z = "Центар Z",
                    },
                    label = "Зона главне базе",
                },
                invalidSelection = "Неважећи избор: {value}",
            },
            locationDescriptions = {
                crimeStationPosition = "Главна тачка локације за овај посао. Ако је означена тачка на мапи омогућена под Посао → Ознаке, она ће се појавити овде.",
            },
            locationTypes = {
                crimeStationPosition = "Локација / маркер на мапи",
                heistCrafting = "Радионица за хек",
                heistStorage = "Складиште за хеист",
            },
            membershipMigration = {
                cancel = "Откажи",
                confirm = "Мигрирати и сачувати",
                message = "Постојећа чланства у организацијама ће бити мигрирана у изабрани модел. У независном режиму, обична запосленост остаје одвојена.",
                title = "Променити модел чланства?",
            },
            moneywashActions = {
                currentLocation = "Користи тренутну локацију",
                invalidLocations = "Проверите ID-је, имена, избор интеријера и координате. Свака локација треба јединствену ID.",
                position = "Положај",
            },
            moneywashBusiness = {
                moneywashBuildNodes = { label = "Građevinske tačke", description = "Postavi odgovarajuću opremu na ove tačke. Koordinate su u odnosu na izabrani enterijer." },
                mwBuildNodes = "Građevinske tačke",
                moneywashPublicEquipment = { label = "Javna oprema", description = "Dodeli veš-mašine, generatore i ventilatore javnim lokacijama i odgovarajućim tačkama." },
                mwPublicEquipment = "Javna oprema",
                moneywashMaterials = { label = "Materijali", description = "Koristi tačne nazive predmeta. Težina je u gramima; instaliraj nedostajuće predmete." },
                mwMaterials = "Materijali",
                moneywashMaterialRecipes = { label = "Recepti materijala", description = "Ulazi, izlazi i trajanje važe po jedinici. Prerađivači koriste ove recepte." },
                mwMaterialRecipes = "Recepti materijala",
                moneywashProductionRecipes = { label = "Recepti štampe", description = "Papir, boja i vreme važe po jedinici. Gotovina tek posle sušenja i provere kvaliteta." },
                mwProductionRecipes = "Recepti štampe",
                moneywashCollectors = { label = "Sakupljači", description = "Podesi prinos, alat, čekanje i položaj svakog sakupljača." },
                mwCollectors = "Sakupljači",
                moneywashProcessors = { label = "Prerađivači", description = "Izaberi recept materijala i položaj svakog prerađivača." },
                mwProcessors = "Prerađivači",

                control = "Контролна табла",
                editor = {
                    addBusiness = "Додај предузеће",
                    addInterior = "Додај унутрашњост",
                    advanced = "Технички детаљи",
                    asset_ipl = "IPL: Унесите тачан IPL назив и позицију унутрашњости.",
                    asset_mlo = "MLO: Користи позицију већ инсталиране унутрашњости. Приступ тренутно користи улаз предузећа.",
                    asset_shell = "Shell: Модел мора бити инсталиран и покренут на серверу.",
                    businessHelp = "Дадите предузећу име, изаберите унутрашњост и одредите куповну цену.",
                    businessListHelp = "Управљајте улазима и куповним ценама за своја предузећа.",
                    businesses = "Предузећа",
                    capture = "Постави у игри",
                    captureOrigin = "Поставите позицију унутрашњости",
                    chooseInterior = "Изаберите унутрашњост",
                    coordinates = "Измени координате",
                    editSections = "Подешавање",
                    emptyBusinessHelp = "Везујте улаз на мапи са унутрашњошћу. Ваше организације могу тада купити празно предузеће.",
                    emptyBusinesses = "Ваше прво предузеће",
                    emptyInteriorHelp = "Прикључите IPL, Shell или инсталиран MLO, затим поставите тачке које користи предузеће.",
                    emptyInteriors = "Ваш први унутрашњи простор",
                    entranceHelp = "Поставите улаз где играчи треба да купе и уђу у предузеће.",
                    freecamHelp = "Слободна камера: WASD за кретање, Q/E за горе/доле, Shift за брже, Ctrl за спорије. Десни миш: гледање. Драње гизма, R за ротацију/померање, Enter за постављање, Backspace за отказивање.",
                    general = "Опште",
                    heading = "Поларна оријентација",
                    interiorHelp = "Изаберите тип унутрашњости и његов актив.",
                    interiorListHelp = "Припремите празне просторије. Играчи постављају своје машине и опрему.",
                    interiors = "Унутрашњости",
                    listEmpty = "Још увек нема уноса.",
                    locationTypes = "Управљање локацијама",
                    newBusiness = "Ново предузеће",
                    newInterior = "Нови унутрашњи простор",
                    noResults = "Нема подударних уноса.",
                    notSet = "Није постављено",
                    offsetHelp = "Унесене вредности су офсети од почетне тачке. Светска позиција је приказана изнад.",
                    origin = "Почетна тачка",
                    originHelp = "Позиција унутрашњости. Све остале тачке су у односу на њу.",
                    originRequired = "Прво поставите позицију просторије под Опште.",
                    outsideRange = "Изван опсега од {range} метара",
                    point_control = "Померите и окрените зидни панел помоћу алатке до зида. Његова потврђена висина објекта се чува тачно. Укључите његову ознаку под Интеракције → Монеј Ваш: Панел контроле.",
                    point_entry = "Играчи овде стижу и напуштају. Напуштање их аутоматски враћа на улаз њиховог предузећа напољу.",
                    point_position = "Ова тачка је напољу од предузећа.",
                    point_storage = "Померите и окрените полицу помоћу алатке док не одмори на поду. Чланови овде приступају купљеној опреми. Укључите њену ознаку под Интеракције → Монеј Ваш: Складиште.",
                    points = "Поенти",
                    pointsHelp = "Изаберите тачку и поставите је директно у игри.",
                    rangeNote = "Валидан је {range}-метарски опсег око почетне тачке унутрашњости, без ограничења висине.",
                    remove = "Уклони",
                    repairRange = "Померите ове тачке ближе почетној тачки унутрашњости.",
                    saveHint = "Примени промене са Сачувај на врху.",
                    search = "Претражи...",
                    set = "Постави",
                    teleport = "Телепорт",
                    viewInteriors = "Погледајте интеријере",
                    visit = "Посетите",
                    visitHint = "Слободно се крећите. Притисните Backspace да се вратите у уредник.",
                    visitTitle = "Посета унутрашњости",
                },
                entry = "Улаз и излаз",
                fields = {
                    mode = "Vrsta pristupa",
                    ownerKind = "Vrsta vlasnika",
                    productionEnabled = "Proširenje za štampu dostupno",
                    feePercent = "Naknada (%) / -1 = opšta",
                    storageCapacity = "Kapacitet skladišta (predmeti)",
                    maximumOrders = "Istovremene narudžbine po igraču",
                    gridPower = "Snaga mreže / 0 = generator",
                    autoService = "Automatsko javno održavanje",
                    maximumPendingOutputs = "Najviše isplata na čekanju",
                    placementRange = "Poluprečnik postavljanja (m)",
                    placementHeight = "Visinski opseg postavljanja (m)",
                    interiorId = "ID enterijera",
                    equipmentId = "ID opreme",
                    nodeId = "ID građevinske tačke",
                    generatorNode = "ID tačke generatora",
                    maxOffset = "Najveće odstupanje od tačke (m)",
                    maxHeight = "Najveće visinsko odstupanje (m)",
                    weight = "Težina predmeta (g)",
                    inputItem = "Ulazni materijal",
                    secondItem = "Drugi ulazni materijal",
                    outputItem = "Izlazni materijal",
                    requiredTool = "Potreban alat",
                    baseQuality = "Početni kvalitet (%)",
                    minimumQuality = "Najmanji kvalitet (%)",
                    inspectionCards = "Kartice provere",
                    inspectionPenalty = "Gubitak kvaliteta po grešci (%)",
                    rejectPercent = "Odbačene novčanice (%)",
                    accessoryModel = "Dodatni model",
                    accessoryMaximum = "Najviše vidljivih dodataka",
                    accessoryActiveOnly = "Dodaci samo tokom obrade",
                    animDict = "Rečnik animacija",
                    animClip = "Animacioni snimak",
                    cooldown = "Čekanje (sekunde)",
                    minimum = "Najmanji prinos",
                    maximum = "Najveći prinos",
                    productionPrice = "Štampanje novca · Цена куповине",
                    recipeId = "Recept ID",
                    inputAmount = "Materijal / po jedinici",
                    secondAmount = "Materijal / po jedinici",
                    outputAmount = "Materijal / po jedinici",
                    paperItem = "Papir za štampu",
                    inkItem = "Štamparska boja",
                    paperAmount = "Papir za štampu / po jedinici",
                    inkAmount = "Štamparska boja / po jedinici",
                    notesPerUnit = "Novčanice / po jedinici",
                    valuePerNote = "Gotovina / Novčanice",
                    maximumUnits = "Jedinice (max.)",
                    printSeconds = "Štampanje / po jedinici (Sekunde)",
                    inspectionSeconds = "Provera / po jedinici (Sekunde)",
                    rinseSeconds = "Pranje / po jedinici (Sekunde)",
                    drySeconds = "Sušenje / po jedinici (Sekunde)",
                    accessoryUnit = "Novčanice / po jedinici",
                    accessoryX = "Dodatni model · X (m)",
                    accessoryY = "Dodatni model · Y (m)",
                    accessoryZ = "Dodatni model · Z (m)",
                    accessoryStep = "Dodatni model · Z (m)",

                    capacity = "Капацитет по циклусу",
                    controlHeading = "Смер контролне табле",
                    controlHeight = "Висина монтаже изнад тачке (м)",
                    controlModel = "Модел за панел на зиду",
                    controlX = "Контролна табла X",
                    controlY = "Контролна табла Y",
                    controlZ = "Панел за контролу Z",
                    disableSets = "Скривене сетове ентитета (раздвојени зарезом)",
                    enableSets = "Активирани скупови ентитета (раздвојени запетом)",
                    entryX = "Одступање улаза X",
                    entryY = "Одступање улаза Y",
                    entryZ = "Одступање улаза Z",
                    heading = "Смер",
                    id = "Уникални ID",
                    interior = "Унутрашњост",
                    ipl = "Име IPL",
                    kind = "Тип",
                    label = "Име",
                    model = "Име модела",
                    power = "Јединице снаге",
                    price = "Цена куповине",
                    radius = "Радијус постављања (м)",
                    repairPrice = "Цена за поправку (0 = бесплатно)",
                    seconds = "Трајање циклуса (секунде)",
                    storageHeading = "Смер тачке складиштења",
                    storageModel = "Модел полице",
                    storageX = "Тачка за складирање X",
                    storageY = "Тачка складиштења Y",
                    storageZ = "Тачка за складирање Z",
                    wear = "Истрошеност по циклусу (%)",
                    x = "Почетна тачка X",
                    y = "Почетна тачка Y",
                    z = "Почетна тачка Z",
                },
                interactions = {
                    control = "Money Wash: контролна табла",
                    storage = "Money Wash: складиште",
                },
                item = "Унос",
                moneywashBucketStart = {
                    description = "Овај опсег резервисати искључиво за прање новца. Промене се примењују при следећем уласку.",
                    label = "Почетни опсег инстанце",
                },
                moneywashEquipment = {
                    description = "Играчи купују и постављају уређаје. Капацитет, трајање и истрошеност важе за пералнице. Електрична енергија је снабдевање генератора или потреба уређаја. Промене важе за нова куповина.",
                    label = "Куповна опрема",
                },
                moneywashInteriors = {
                    description = "Конфигуришите празне IPL, shell или MLO интеријере. Улаз, контролна табла, складиште и границе изградње су у односу на почетну тачку. Приликом напуштања играчи се враћају на свој улаз у предузећу.",
                    label = "Интерери (IPL, shell или MLO)",
                },
                moneywashMaximumEquipment = {
                    description = "Максималан број купљених уређаја и сетова за поправку по предузећу.",
                    label = "Лимит опреме",
                },
                moneywashPreviewBucketStart = {
                    description = "Посета додаје ID играча на ову вредност за приватну административну инстанцу. Резервирајте је одвојено од предузећа и других ресурса. Промене важе за наредни преглед.",
                    label = "Почетак опсега за преглед инстанце",
                },
                moneywashProperties = {
                    description = "Постави улаз, изабери унутрашњост и одреди цену куповине. Купљени објекти задржавају своју сачувану унутрашњост и распоред.",
                    label = "Улази у објекте",
                },
                moneywashRepairShops = {
                    description = "Поставите сервисне продавнице, телепортирајте се до њих и одредите цену услуге. Продају сервисне сетове и одржавају улажене машине.",
                    label = "Локације продавница",
                },
                moneywashShops = {
                    description = "Поставите продавнице за пералнице, генераторе и вентилаторе. Наручбе се шаљу у предузеће које је изабрала организација.",
                    label = "Локације продавница",
                },
                mwEquipment = "Магазин опреме",
                mwInteriors = "Празни интеријери",
                mwProperties = "Локације",
                mwRepairShops = "Ремонтска радионица",
                mwSettings = "Подешавања предузећа",
                names = {
                    mwPublicLaundry = "Javna perionica",
                    mwPaperPulp = "Papirna masa",
                    mwPrintingPaper = "Papir za štampu",
                    mwPrintingInk = "Štamparska boja",
                    mwPaperRecipe = "Izrada papira za štampu",
                    mwPrintingRecipe = "Obične novčanice",
                    mwPaperCollector = "Sakupljač papira",
                    mwInkCollector = "Sakupljač boje",
                    mwPaperProcessor = "Prerađivač papira",
                    mwPrinter = "Štamparska mašina",
                    mwInspectionTable = "Sto za proveru",
                    mwDryingCabinet = "Orman za sušenje",
                    mwNode1 = "1 · Pranje",
                    mwNode2 = "2 · Pranje",
                    mwNode3 = "3 · Građevinske tačke",
                    mwNode4 = "4 · Štampanje",
                    mwNode5 = "5 · Provera",
                    mwNode6 = "6 · Sušenje",
                    mwNode7 = "7 · Građevinske tačke",

                    mwInteriorWarehouse = "Празна магацинска хала",
                },
                options = {
                    private = "Privatno",
                    public = "Javno",
                    faction = "Organizacija",
                    person = "Lik",
                    printer = "Štamparska mašina",
                    inspection = "Sto za proveru",
                    dryer = "Orman za sušenje",

                    fan = "Вентилатор",
                    generator = "Генератор",
                    ipl = "IPL",
                    mlo = "MLO",
                    repair = "Набор за поправку",
                    shell = "Shell модел",
                    washer = "Перача",
                },
                origin = "Почетна тачка",
                storage = "Тачка складиштења",
            },
            settingFields = {
                cultivationLevel = "Ниво узгоја",
                cultivationTitle = "Назив нивоа",
                cultivationRequiredXp = "Потребан укупан XP",
                cultivationAction = "Радња",
                cultivationXp = "XP",
                cultivationCategory = "Категорија",
                cultivationEntry = "Ставка",
                cultivationRequiredLevel = "Потребан ниво",
                alias = "Алијас",
                atmHeading = "Поларна оријентација",
                atmId = "ID",
                atmModel = "Модел банкомата",
                centerX = "Центар X",
                centerY = "Центар Y",
                centerZ = "Центар Z",
                deliveryMethod = "Начин испоруке",
                description = "Опис",
                enabled = "Укључено",
                groupKey = "Кључ групе",
                id = "ID",
                itemLabel = "Назив робе",
                itemName = "Назив предмета инвентара",
                knownScammer = "Познати преварант",
                locationName = "Назив локације",
                observerW = "Смер набљудовца",
                observerX = "Набљудовац X",
                observerY = "Набљудовац Y",
                observerZ = "Центар Y",
                pedModel = "Модел NPC педа",
                pickpocketItemChance = "Шанса (%)",
                pickpocketItemMaximum = "Максимална количина",
                pickpocketItemMinimum = "Минимална количина",
                pickpocketItemName = "Назив предмета инвентара",
                quantity = "Количина",
                radius = "Радијус",
                rating = "Приказана оцена",
                ratingCount = "Приказан број оцена",
                scamChance = "Вероватноћа за измаму трговца (%)",
                shopCategory = "Категорија",
                shopClerkHeading = "Смер службеника",
                shopClerkModel = "Модел службеника",
                shopClerkRequired = "Потребан службеник",
                shopClerkX = "Службеник X",
                shopClerkY = "Службеник Y",
                shopClerkZ = "Службеник Z",
                shopCodeEnabled = "Дозволи отварање кодом",
                shopDrillEnabled = "Омогући бушење",
                shopEnabled = "Омогућено",
                shopHackEnabled = "Дозволи хаковање",
                shopLocationId = "ID продавнице",
                shopLocationLabel = "Назив",
                shopRegisterId = "ID касе",
                shopSafeEnabled = "Омогућен сеф",
                shopSafeHeading = "Смер сефа",
                shopSafeX = "Сеф X",
                shopSafeY = "Сеф Y",
                shopSafeZ = "Сеф Z",
                side = "Страна тржишта",
                spawns = "Спавови екипе",
                successfulTrades = "Приказани успешни тргови",
                title = "Наслов понуде",
                unitPrice = "Цена по јединици",
                verified = "Верификовани трговац",
                w = "Поларна оријентација",
                x = "Кс",
                y = "И",
                z = "З",
                shopClerkPosition = "Позиција запосленог",
                shopRegisterPosition = "Позиција касе",
                shopSafePosition = "Позиција сефа",
                registerId = "ID касе",
                registerX = "X координата касе",
                registerY = "Y координата касе",
                registerZ = "Z координата касе",
                heading = "Оријентација",
                captureLocation = "Забележи положај",
            },
            crimeDashboard = {
                jobs = "Upravljajte frakcijama, članovima, dozvolama i lokacijama.",
                jobCreator = "Izaberite frakciju da biste uredili njene lokacije i oblasti.",
                jobsQuestion = "Gde uređujem frakcije i lokacije?",
                jobsAnswer = "Otvorite {path}, izaberite frakciju i zatim Uredi. Tamo možete podesiti njene postavke i lokacije.",
                creatorsAnswer = "Uređivače možete naći u {path}. Ove veze otvaraju uređivač; alati za frakcije počinju izborom frakcije.",
                missingAnswer = "Dostupni uređivači zavise od izabranog resursa i njegovih postavki. Alati za frakcije počinju od odgovarajuće frakcije.",
                creators = {
                    mainbaseZones = "Izaberite frakciju i podesite oblast njene baze.",
                    presetTerritories = "Pregledajte unapred određene oblasti i izaberite koje su aktivne.",
                    objectsSection = "Upravljajte trajnim stolicama za ispitivanje i kolicima sa alatom.",
                    blockedZonesSection = "Odredite oblasti u kojima se predmeti za ispitivanje ne mogu postavljati.",
                    toolsSection = "Podesite alate dostupne tokom ispitivanja.",
                    sessionsSection = "Pregledajte aktivna ispitivanja i po potrebi završite sesije.",
                    orphansSection = "Pregledajte i uklonite napuštene predmete za ispitivanje.",
                },
            },
            crimeGroupDescriptions = {
                general = {
                    crimeMembership = "Одредите како криминалне организације складиште и управљају својим члановима.",
                },
                territories = {
                    zones = "Podesite „Зоне територије” u odeljku „Територије”.",
                    ownership = "Podesite „Поседовање” u odeljku „Територије”.",
                    decay = "Podesite „Отуђење” u odeljku „Територије”.",
                    presence = "Podesite „Присутност” u odeljku „Територије”.",
                    activity = "Podesite „Оцена активности” u odeljku „Територије”.",
                    ownershipBenefits = "Podesite „Бенефиције власништва” u odeljku „Територије”.",
                },
                graffiti = {
                    general = "Podesite „Опште” u odeljku „Граффити”.",
                    streaming = "Podesite „Рендерирање” u odeljku „Граффити”.",
                    moderation = "Podesite „Модерација” u odeljku „Граффити”.",
                },
                pvpEvents = {
                    pvpAvailability = "Контролишите да ли је апликација за PvP догађаје доступна и где се приказује.",
                    pvpAutomation = "Конфигуришите понављајуће догађаје и аутоматски процес покретања.",
                    pvpRuntime = "Прилагодите обраду захтева, смрти и поновно појављивање током активних такмичења.",
                    pvpModes = "Конфигуришите режим игре који је преизабран у PvP таблету.",
                    pvpArenas = "Креирајте круглу зону борбе, тачку посматрача и тачке спавна за тимове које користе PvP догађаји.",
                    pvpLimits = "Поставите ограничења за награде и историју таблета.",
                    pvpPermissions = "Везујте управљање догађајима и финансије са овлашћењима ACE и запослења.",
                    pvpTakeoverRules = "Контролишите доступност и захтеве за учешће за преузимање лабораторије и кампера.",
                    pvpTakeoverZones = "Конфигуришите зоне за интеракцију, алармне зоне и зоне за заузимање заједно са њиховим трајањем.",
                    pvpTakeoverMethods = "Одредите колико времена свака метода треба за пробијање улаза.",
                },
                drugs = {
                    creator = "Otvara Sky Crime uređivač droge i zatvara konfigurator poslova.",
                    creatorSettings = "Podesite „Podešavanja uređivača” u odeljku „Sistem droge”.",
                    interfaceHud = "Podesite „Положаји интерфејса” u odeljku „Sistem droge”.",
                    drugsGeneral = "Podesite „Опште” u odeljku „Sistem droge”.",
                    runtimeAccess = "Podesite „Pristup i vlasništvo” u odeljku „Sistem droge”.",
                    runtimePayouts = "Podesite „Isplate” u odeljku „Sistem droge”.",
                    runtimeDispatch = "Podesite „Dispečer i policija” u odeljku „Sistem droge”.",
                    performanceInactiveControlIntervalMs = "Podešavanje rada za: Перформансе / Неактивно / Контрола / Interval / ms.",
                    performanceInteractionIdleScanIntervalMs = "Podešavanje rada za: Перформансе / Интеракција / Idle / Interval skeniranja / ms.",
                    performanceInteractionPromptIntervalMs = "Podešavanje rada za: Перформансе / Интеракција / Poziv za interakciju / Interval / ms.",
                    performanceInteractionScanIntervalMs = "Podešavanje rada za: Перформансе / Интеракција / Interval skeniranja / ms.",
                    performanceMinimumScanIntervalMs = "Podešavanje rada za: Перформансе / Minimum / Interval skeniranja / ms.",
                    performanceStreetPedActivationDistance = "Podešavanje rada za: Перформансе / Улица / Пед / Активација / Удаљеност.",
                    performanceStreetPedIdleScanIntervalMs = "Podešavanje rada za: Перформансе / Улица / Пед / Idle / Interval skeniranja / ms.",
                    performanceStreetPedScanIntervalMs = "Podešavanje rada za: Перформансе / Улица / Пед / Interval skeniranja / ms.",
                    performanceWorldCachePadding = "Podešavanje rada za: Перформансе / Свет / Keš / Dodatna margina.",
                    performanceWorldCacheRefreshIntervalMs = "Podešavanje rada za: Перформансе / Свет / Keš / Osvežavanje / Interval / ms.",
                    performanceWorldIdleIntervalMs = "Podešavanje rada za: Перформансе / Свет / Idle / Interval / ms.",
                },
                drugProduction = {
                    qualityWeights = "Podesite „Квалитет / Ponderi” u odeljku „Proizvodnja droge”.",
                    qualityTiers = "Podesite „Квалитет / Nivoi kvaliteta” u odeljku „Proizvodnja droge”.",
                    packagingGeneral = "Podesite „Опште” u odeljku „Proizvodnja droge”.",
                    processingFlow = "Podesite „Tok obrade” u odeljku „Proizvodnja droge”.",
                    processingGeneral = "Podesite „Опште” u odeljku „Proizvodnja droge”.",
                },
                drugOperations = {
                    growingGeneral = "Podesite „Опште” u odeljku „Poslovanje sa drogom”.",
                    plantDefaults = "Podesite „Биљка / Podrazumevane vrednosti” u odeljku „Poslovanje sa drogom”.",
                    harvestWindow = "Podesite „Жетва / Vremenski prozor” u odeljku „Poslovanje sa drogom”.",
                    labsGeneral = "Omogućava: laboratorije i kamperi u igri.",
                    labRent = "Podesite „Zakup i životni ciklus” u odeljku „Poslovanje sa drogom”.",
                    camperDefaults = "Podesite „Кампер” u odeljku „Poslovanje sa drogom”.",
                    labUpgrades = "Množilac za: Лабораторија / Ниво / Unapređenje / Cene.",
                    labDefaults = "Podesite „Лабораторија / Podrazumevane vrednosti” u odeljku „Poslovanje sa drogom”.",
                    powerGeneral = "Podesite „Опште” u odeljku „Poslovanje sa drogom”.",
                    generators = "Podesite „Generatori” u odeljku „Poslovanje sa drogom”.",
                    equipmentWear = "Globalni množilac za: Исушивање опреме / Обрада.",
                    workersGeneral = "Podesite „Опште” u odeljku „Poslovanje sa drogom”.",
                    cultivationGeneral = "Podesite „Опште” u odeljku „Poslovanje sa drogom”.",
                    cultivationCurve = "Подесите назив и укупан XP праг за сваки ниво узгоја.",
                    cultivationExperience = "Подесите колико XP узгоја даје свака радња.",
                    cultivationUnlocks = "Подесите потребан ниво за посуде, подлоге, опрему, сорте и нивое скенера.",
                    powerRuntime = "Interval u sekundama za: ažuriranje potrošnje generatora i energetskih tragova.",
                    powerHeat = "Podesite „Pažnja policije i energetski trag” u odeljku „Poslovanje sa drogom”.",
                    powerModes = "Podesite „Upravljanje / Režimi” u odeljku „Poslovanje sa drogom”.",
                    powerPriorities = "Podesite „Opterećenje / Prioriteti” u odeljku „Poslovanje sa drogom”.",
                },
                drugMarketRisk = {
                    marketGeneral = "Podesite „Опште” u odeljku „Tržište i rizik”.",
                    marketPrices = "Podesite „Cene” u odeljku „Tržište i rizik”.",
                    distribution = "Podesite „Дистрибуција” u odeljku „Tržište i rizik”.",
                    threatsGeneral = "Podesite „Опште” u odeljku „Tržište i rizik”.",
                    threatHeat = "Podesite „Policijski pritisak” u odeljku „Tržište i rizik”.",
                    threatChances = "Podesite „Verovatnoće” u odeljku „Tržište i rizik”.",
                    consumptionGeneral = "Podesite „Опште” u odeljku „Tržište i rizik”.",
                    consumerDecay = "Podesite „Smanjenje tolerancije i zavisnosti” u odeljku „Tržište i rizik”.",
                    consumerEffects = "Podesite „Efekti i rizici” u odeljku „Tržište i rizik”.",
                },
                drugNetworks = {
                    dynamicMarketActionCooldownSeconds = "Podešavanje rada za: Динамичко тржиште / Хладноће акције / секунд.",
                    dynamicMarketActionHistoryLimit = "Podešavanje rada za: Динамичко тржиште / Акција / Лимит историје.",
                    dynamicMarketAmountSaturationWeight = "Podešavanje rada za: Динамичко тржиште / Износ / Засићење / Тежина.",
                    dynamicMarketBaseIntelAccuracy = "Podešavanje rada za: Динамичко тржиште / Osnovna vrednost / Тачност обавештења.",
                    dynamicMarketDefaultAverageQuality = "Podešavanje rada za: Динамичко тржиште / Podrazumevana vrednost / Prosek / Квалитет.",
                    dynamicMarketDefaultResourceElasticity = "Podešavanje rada za: Динамичко тржиште / Podrazumevana vrednost / Ресурс / Elastičnost.",
                    dynamicMarketDemandCenter = "Podešavanje rada za: Динамичко тржиште / Захтев / Srednja vrednost.",
                    dynamicMarketDemandPriceImpact = "Podešavanje rada za: Динамичко тржиште / Захтев / Цена / Uticaj.",
                    dynamicMarketDirectionThreshold = "Podešavanje rada za: Динамичко тржиште / Правац / Prag.",
                    dynamicMarketEnabled = "Podešavanje rada za: Динамичко тржиште / Омогућено.",
                    dynamicMarketEventChance = "Podešavanje rada za: Динамичко тржиште / Događaj / Могућа.",
                    dynamicMarketEventDurationMinutes = "Podešavanje rada za: Динамичко тржиште / Događaj / Трајање / Minuti.",
                    dynamicMarketEventMinimumDurationMinutes = "Podešavanje rada za: Динамичко тржиште / Događaj / Minimum / Трајање / Minuti.",
                    dynamicMarketEventStrengthMaximum = "Podešavanje rada za: Динамичко тржиште / Događaj / Jačina / Maksimum.",
                    dynamicMarketEventStrengthMinimum = "Podešavanje rada za: Динамичко тржиште / Događaj / Jačina / Minimum.",
                    dynamicMarketEvents = "Podesite „Догађаји” u odeljku „Mreže droge”.",
                    dynamicMarketExactIntelReputation = "Podešavanje rada za: Динамичко тржиште / Tačne informacije / Репутација.",
                    dynamicMarketExactIntelTrust = "Podešavanje rada za: Динамичко тржиште / Tačne informacije / Повјерење.",
                    dynamicMarketGlobalZoneLabel = "Podešavanje rada za: Динамичко тржиште / Global / Зона / Назив.",
                    dynamicMarketHistoryLimit = "Podešavanje rada za: Динамичко тржиште / Лимит историје.",
                    dynamicMarketInitialDemand = "Podešavanje rada za: Динамичко тржиште / Početna vrednost / Захтев.",
                    dynamicMarketInitialPriceMultiplier = "Podešavanje rada za: Динамичко тржиште / Početna vrednost / Мноилац цене.",
                    dynamicMarketIntelDemandError = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Захтев / Грешка.",
                    dynamicMarketIntelMaximumAccuracy = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Maksimum / Тачност.",
                    dynamicMarketIntelMinimumAccuracy = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Minimum / Тачност.",
                    dynamicMarketIntelPoliceError = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Policija / Грешка.",
                    dynamicMarketIntelPriceError = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Цена / Грешка.",
                    dynamicMarketIntelPriceMaximum = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Цена / Maksimum.",
                    dynamicMarketIntelPriceMinimum = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Цена / Minimum.",
                    dynamicMarketIntelReputationWeight = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Репутација / Тежина.",
                    dynamicMarketIntelResourcePriceError = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Ресурс / Цена / Грешка.",
                    dynamicMarketIntelSaturationError = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Засићење / Грешка.",
                    dynamicMarketIntelSeedBucketSeconds = "Podešavanje rada za: Динамичко тржиште / Prozor semena informacija / секунд.",
                    dynamicMarketIntelStatusAccuracyThreshold = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Статус / Тачност / Prag.",
                    dynamicMarketIntelStatusErrorThreshold = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Статус / Грешка / Prag.",
                    dynamicMarketIntelSupplyError = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Снабдевање / Грешка.",
                    dynamicMarketIntelTrustWeight = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Повјерење / Тежина.",
                    dynamicMarketManipulationCooldownMinutes = "Podešavanje rada za: Динамичко тржиште / Manipulacija / Minuti pauze.",
                    dynamicMarketManipulationDemandShift = "Podešavanje rada za: Динамичко тржиште / Manipulacija / Захтев / Promena.",
                    dynamicMarketManipulationDurationMinutes = "Podešavanje rada za: Динамичко тржиште / Manipulacija / Трајање / Minuti.",
                    dynamicMarketManipulationHeat = "Podešavanje rada za: Динамичко тржиште / Manipulacija / Policijski pritisak.",
                    dynamicMarketManipulationMinimumBatchAmount = "Podešavanje rada za: Динамичко тржиште / Manipulacija / Minimum / Серија / Износ.",
                    dynamicMarketManipulationPaymentAccount = "Podešavanje rada za: Динамичко тржиште / Manipulacija / Начин за плаћање.",
                    dynamicMarketManipulationPrice = "Podešavanje rada za: Динамичко тржиште / Manipulacija / Цена.",
                    dynamicMarketManipulationZoneHeatMultiplier = "Podešavanje rada za: Динамичко тржиште / Manipulacija / Зона / Policijski pritisak / Množilac.",
                    dynamicMarketMaximumIntelAgeMinutes = "Podešavanje rada za: Динамичко тржиште / Maksimum / Старост обавештења / Minuti.",
                    dynamicMarketMaximumPriceMultiplier = "Podešavanje rada za: Динамичко тржиште / Maksimum / Мноилац цене.",
                    dynamicMarketMinimumIntelAgeMinutes = "Podešavanje rada za: Динамичко тржиште / Minimum / Старост обавештења / Minuti.",
                    dynamicMarketMinimumMetricWindowMinutes = "Podešavanje rada za: Динамичко тржиште / Minimum / Metrika / Vremenski prozor / Minuti.",
                    dynamicMarketMinimumPriceMultiplier = "Podešavanje rada za: Динамичко тржиште / Минимална цена / Množilac.",
                    dynamicMarketMinimumUpdateMinutes = "Podešavanje rada za: Динамичко тржиште / Minimum / Ažuriranje / Minuti.",
                    dynamicMarketPoliceDemandWeight = "Podešavanje rada za: Динамичко тржиште / Policija / Захтев / Тежина.",
                    dynamicMarketPolicePriceImpact = "Podešavanje rada za: Динамичко тржиште / Policija / Цена / Uticaj.",
                    dynamicMarketPoorQualityDemandPenalty = "Podešavanje rada za: Динамичко тржиште / Loš kvalitet / Захтев / Kazna.",
                    dynamicMarketPoorQualityThreshold = "Podešavanje rada za: Динамичко тржиште / Loš kvalitet / Prag.",
                    dynamicMarketPremiumQualityDemandBonus = "Podešavanje rada za: Динамичко тржиште / Vrhunski kvalitet / Бонус захтева.",
                    dynamicMarketPremiumQualityThreshold = "Podešavanje rada za: Динамичко тржиште / Vrhunski kvalitet / Prag.",
                    dynamicMarketProductionSupplyWeight = "Podešavanje rada za: Динамичко тржиште / Производња / Снабдевање / Тежина.",
                    dynamicMarketProductionWindowMinutes = "Podešavanje rada za: Динамичко тржиште / Производња / Vremenski prozor / Minuti.",
                    dynamicMarketQualityCenter = "Podešavanje rada za: Динамичко тржиште / Квалитет / Srednja vrednost.",
                    dynamicMarketQualityConfidenceImpact = "Podešavanje rada za: Динамичко тржиште / Квалитет / Постојаност / Uticaj.",
                    dynamicMarketQualityRange = "Podešavanje rada za: Динамичко тржиште / Квалитет / Raspon vrednosti.",
                    dynamicMarketRarityBonusMaximum = "Podešavanje rada za: Динамичко тржиште / Retkost / Бонус / Maksimum.",
                    dynamicMarketRegionalGlobalWeight = "Podešavanje rada za: Динамичко тржиште / Regionalno / Global / Тежина.",
                    dynamicMarketRegionalLocalWeight = "Podešavanje rada za: Динамичко тржиште / Regionalno / Lokalno / Тежина.",
                    dynamicMarketResourceAliases = "Podesite „Ресурс / Alternativni nazivi” u odeljku „Mreže droge”.",
                    dynamicMarketResourceDirectionFallThreshold = "Podešavanje rada za: Динамичко тржиште / Ресурс / Правац / Pad / Prag.",
                    dynamicMarketResourceDirectionRiseThreshold = "Podešavanje rada za: Динамичко тржиште / Ресурс / Правац / Rast / Prag.",
                    dynamicMarketResources = "Podesite „Ресурси” u odeljku „Mreže droge”.",
                    dynamicMarketSalesWindowMinutes = "Podešavanje rada za: Динамичко тржиште / Продаја / Vremenski prozor / Minuti.",
                    dynamicMarketSaturationDemandWeight = "Podešavanje rada za: Динамичко тржиште / Засићење / Захтев / Тежина.",
                    dynamicMarketSaturationPriceImpact = "Podešavanje rada za: Динамичко тржиште / Засићење / Цена / Uticaj.",
                    dynamicMarketScarcityDemandWeight = "Podešavanje rada za: Динамичко тржиште / Nestašica / Захтев / Тежина.",
                    dynamicMarketScarcityPriceImpact = "Podešavanje rada za: Динамичко тржиште / Nestašica / Цена / Uticaj.",
                    dynamicMarketSeasonEndMonths = "Podesite „Godišnje doba / Kraj / Meseci” u odeljku „Mreže droge”.",
                    dynamicMarketSeasonMultipliers = "Podesite „Godišnje doba / Množioci” u odeljku „Mreže droge”.",
                    dynamicMarketShortageRumorThreshold = "Podešavanje rada za: Динамичко тржиште / Nestašica / Glasina / Prag.",
                    dynamicMarketStatusThresholds = "Podesite „Статус / Pragovi” u odeljku „Mreže droge”.",
                    dynamicMarketTargetSupply = "Podešavanje rada za: Динамичко тржиште / Циљ / Снабдевање.",
                    dynamicMarketTrendChance = "Podešavanje rada za: Динамичко тржиште / Trend / Могућа.",
                    dynamicMarketTrendDurationMinutes = "Podešavanje rada za: Динамичко тржиште / Trend / Трајање / Minuti.",
                    dynamicMarketTrendMaximumStrength = "Podešavanje rada za: Динамичко тржиште / Trend / Maksimum / Jačina.",
                    dynamicMarketTrendMinimumStrength = "Podešavanje rada za: Динамичко тржиште / Trend / Minimum / Jačina.",
                    dynamicMarketUpdateMinutes = "Podešavanje rada za: Динамичко тржиште / Ažuriranje / Minuti.",
                    dynamicMarketVolatilityMaximum = "Podešavanje rada za: Динамичко тржиште / Promenljivost cena / Maksimum.",
                    dynamicMarketVolatilityMinimum = "Podešavanje rada za: Динамичко тржиште / Promenljivost cena / Minimum.",
                    dynamicMarketWeatherMultipliers = "Podesite „Vreme / Množioci” u odeljku „Mreže droge”.",
                    dynamicMarketWeatherState = "Podešavanje rada za: Динамичко тржиште / Vreme / Стање.",
                    heatActionCooldownSeconds = "Podešavanje rada za: Pažnja policije i rizik / Хладноће акције / секунд.",
                    heatActivityRiskWeights = "Podesite „Aktivnost / Ризик / Ponderi” u odeljku „Mreže droge”.",
                    heatAggressiveHeatMultiplier = "Podešavanje rada za: Pažnja policije i rizik / Agresivni režim / Policijski pritisak / Množilac.",
                    heatBurnerBurnThreshold = "Podešavanje rada za: Pažnja policije i rizik / Telefon za jednokratnu upotrebu / Razotkrivanje / Prag.",
                    heatBurnerHeatPerWholesale = "Podešavanje rada za: Pažnja policije i rizik / Telefon za jednokratnu upotrebu / Policijski pritisak / Po veleprodajnom poslu.",
                    heatBurnerPhoneItem = "Podešavanje rada za: Pažnja policije i rizik / Бернер телефон / Predmet.",
                    heatCamperOperationalHeatMultiplier = "Podešavanje rada za: Pažnja policije i rizik / Kamper u radu / Policijski pritisak / Množilac.",
                    heatCamperOperationalHeatThreshold = "Podešavanje rada za: Pažnja policije i rizik / Kamper u radu / Policijski pritisak / Prag.",
                    heatCamperParkedHeat = "Podešavanje rada za: Pažnja policije i rizik / Parkirani kamper / Policijski pritisak.",
                    heatContaminatedHeatMultiplier = "Podešavanje rada za: Pažnja policije i rizik / Kontaminacija / Policijski pritisak / Množilac.",
                    heatContaminatedThreshold = "Podešavanje rada za: Pažnja policije i rizik / Kontaminacija / Prag.",
                    heatCultivationFreePlants = "Podešavanje rada za: Pažnja policije i rizik / Култивација / Biljke bez dodatnog rizika.",
                    heatCultivationHeatPerPlant = "Podešavanje rada za: Pažnja policije i rizik / Култивација / Policijski pritisak / Po biljci.",
                    heatDealerHiddenMinutes = "Podešavanje rada za: Pažnja policije i rizik / Дилер / скривено / Minuti.",
                    heatDecayPerTick = "Podesite „Отуђење / Po ciklusu ažuriranja” u odeljku „Mreže droge”.",
                    heatEnabled = "Podešavanje rada za: Pažnja policije i rizik / Омогућено.",
                    heatEnforcementHeat = "Podesite „Prisustvo policije / Policijski pritisak” u odeljku „Mreže droge”.",
                    heatEnforcementMultipliers = "Podesite „Prisustvo policije / Množioci” u odeljku „Mreže droge”.",
                    heatEntityTypes = "Podesite „Objekat igre / Tipovi” u odeljku „Mreže droge”.",
                    heatEventCooldownMinutes = "Podešavanje rada za: Pažnja policije i rizik / Događaj / Minuti pauze.",
                    heatEventHistoryLimit = "Podešavanje rada za: Pažnja policije i rizik / Događaj / Лимит историје.",
                    heatLabHeatSyncThreshold = "Podešavanje rada za: Pažnja policije i rizik / Лабораторија / Policijski pritisak / Sinhronizacija / Prag.",
                    heatLayLowCooldownMinutes = "Podešavanje rada za: Pažnja policije i rizik / Povući se / Minuti pauze.",
                    heatLayLowIdleMinutes = "Podešavanje rada za: Pažnja policije i rizik / Povući se / Idle / Minuti.",
                    heatLayLowReduction = "Podešavanje rada za: Pažnja policije i rizik / Povući se / Smanjenje.",
                    heatLockdownMinutes = "Podešavanje rada za: Pažnja policije i rizik / Затворено / Minuti.",
                    heatMinimumDurationMinutes = "Podešavanje rada za: Pažnja policije i rizik / Minimum / Трајање / Minuti.",
                    heatMinimumEventCooldownSeconds = "Podešavanje rada za: Pažnja policije i rizik / Minimum / Događaj / Време паузе (секунде).",
                    heatMinimumIdleSeconds = "Podešavanje rada za: Pažnja policije i rizik / Minimum / Idle / секунд.",
                    heatProcessingHeatMultiplier = "Podešavanje rada za: Pažnja policije i rizik / Обрада / Policijski pritisak / Množilac.",
                    heatRiskWeights = "Podesite „Ризик / Ponderi” u odeljku „Mreže droge”.",
                    heatRotateBurnerReduction = "Podešavanje rada za: Pažnja policije i rizik / Promeni telefon za jednokratnu upotrebu / Smanjenje.",
                    heatRouteControlMinutes = "Podešavanje rada za: Pažnja policije i rizik / Рута / Контрола / Minuti.",
                    heatSaleHeat = "Podesite „Prodaja / Policijski pritisak” u odeljku „Mreže droge”.",
                    heatThresholds = "Podesite „Pragovi” u odeljku „Mreže droge”.",
                    heatTickMinutes = "Podešavanje rada za: Pažnja policije i rizik / Ciklus ažuriranja / Minuti.",
                    heatWholesaleHeatMultiplier = "Podešavanje rada za: Pažnja policije i rizik / Велико продавање / Policijski pritisak / Množilac.",
                    heatWorkerLeakAlertRadius = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Радијус аларма.",
                    heatWorkerLeakBaseChance = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Osnovna vrednost / Могућа.",
                    heatWorkerLeakFactionMultiplier = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Фракција / Množilac.",
                    heatWorkerLeakHighSeverityThreshold = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Висок / Ozbiljnost / Prag.",
                    heatWorkerLeakLoyaltyChanceMultiplier = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Лојалност / Могућа / Množilac.",
                    heatWorkerLeakLoyaltyThreshold = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Лојалност / Prag.",
                    heatWorkerLeakMaximumChance = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Maksimum / Могућа.",
                    heatWorkerLeakMinimumCooldownSeconds = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Minimum / Време паузе (секунде).",
                    heatWorkerLeakRouteMultiplier = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Рута / Množilac.",
                    heatWorkerLeakStrengthMaximum = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Jačina / Maksimum.",
                    heatWorkerLeakStrengthMinimum = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Jačina / Minimum.",
                    heatWorkerLeakStrengthMultiplier = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Jačina / Množilac.",
                    heatWorkerLeakStressChanceMultiplier = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Стрес / Могућа / Množilac.",
                    heatWorkerLeakStressThreshold = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Стрес / Prag.",
                    contactsActionCooldownSeconds = "Podešavanje rada za: Mreža kontakata / Хладноће акције / секунд.",
                    contactsActiveHotspotCount = "Podešavanje rada za: Mreža kontakata / Broj aktivnih žarišta.",
                    contactsBurnerHintTrust = "Podešavanje rada za: Mreža kontakata / Савет за једнократни телефон / Повјерење.",
                    contactsBurnerOfferMaximumMultiplier = "Podešavanje rada za: Mreža kontakata / Telefon za jednokratnu upotrebu / Ponuda / Maksimum / Množilac.",
                    contactsBurnerOfferMinimumMultiplier = "Podešavanje rada za: Mreža kontakata / Telefon za jednokratnu upotrebu / Ponuda / Minimum / Množilac.",
                    contactsBuyerCooldownMinutes = "Podešavanje rada za: Mreža kontakata / Купац / Minuti pauze.",
                    contactsBuyerDeliveryDistance = "Podešavanje rada za: Mreža kontakata / Купац / Udaljenost dostave.",
                    contactsBuyerPremiumSuccessScore = "Podešavanje rada za: Mreža kontakata / Купац / Премиум / Uspeh / Поени.",
                    contactsBuyerPremiumTrustGain = "Podešavanje rada za: Mreža kontakata / Купац / Премиум / Повјерење / принос.",
                    contactsBuyerRequestHeatRiskWeight = "Podešavanje rada za: Mreža kontakata / Купац / Zahtev / Притисак и ризик / Тежина.",
                    contactsBuyerStandardTrustGain = "Podešavanje rada za: Mreža kontakata / Купац / Стандард / Повјерење / принос.",
                    contactsContactActiveDelaySeconds = "Podesite „Čekanje na aktivaciju kontakta / секунд” u odeljku „Mreže droge”.",
                    contactsContactDemandRange = "Podesite „Контакт / Захтев / Raspon vrednosti” u odeljku „Mreže droge”.",
                    contactsContactLossTrust = "Podešavanje rada za: Mreža kontakata / Контакт / Губитак / Повјерење.",
                    contactsDarknetExactIntelMinutes = "Podešavanje rada za: Mreža kontakata / Darknet / Tačne informacije / Minuti.",
                    contactsDarknetHotspotIntelPrice = "Podešavanje rada za: Mreža kontakata / Darknet / Žarište / Obaveštajni podaci / Цена.",
                    contactsDarknetIntelPrice = "Podešavanje rada za: Mreža kontakata / Darknet / Obaveštajni podaci / Цена.",
                    contactsDealerBasePrice = "Podešavanje rada za: Mreža kontakata / Дилер / Базна цена.",
                    contactsDealerHireCapacity = "Podesite „Дилер / Zapošljavanje / Капацитет” u odeljku „Mreže droge”.",
                    contactsDealerHireRisk = "Podesite „Дилер / Zapošljavanje / Ризик” u odeljku „Mreže droge”.",
                    contactsDealerHireSkill = "Podesite „Дилер / Zapošljavanje / Вештина” u odeljku „Mreže droge”.",
                    contactsDealerOffers = "Podesite „Понуде дилера” u odeljku „Mreže droge”.",
                    contactsDealerProtectionHours = "Podešavanje rada za: Mreža kontakata / Дилер / Zaštita / Sati.",
                    contactsDealerProtectionPrice = "Podešavanje rada za: Mreža kontakata / Дилер / Zaštita / Цена.",
                    contactsDealerSaleMax = "Podešavanje rada za: Mreža kontakata / Дилер / Prodaja / Maksimum.",
                    contactsDealerSaleMin = "Podešavanje rada za: Mreža kontakata / Дилер / Prodaja / Minimum.",
                    contactsDealerSimulation = "Podesite „Дилер / Симулација” u odeljku „Mreže droge”.",
                    contactsDealerTickMinutes = "Podešavanje rada za: Mreža kontakata / Дилер / Ciklus ažuriranja / Minuti.",
                    contactsDealerWage = "Podešavanje rada za: Mreža kontakata / Дилер / Плат.",
                    contactsDealerWageDecay = "Podešavanje rada za: Mreža kontakata / Дилер / Плат / Отуђење.",
                    contactsDealerWageLoyaltyGain = "Podešavanje rada za: Mreža kontakata / Дилер / Плат / Лојалност / принос.",
                    contactsDealerWeaknesses = "Podesite „Дилер / Slabosti” u odeljku „Mreže droge”.",
                    contactsDefaultContactDemand = "Podešavanje rada za: Mreža kontakata / Podrazumevana vrednost / Контакт / Захтев.",
                    contactsDefaultContactRisk = "Podešavanje rada za: Mreža kontakata / Podrazumevana vrednost / Контакт / Ризик.",
                    contactsDefaultDealerCapacity = "Podešavanje rada za: Mreža kontakata / Podrazumevani diler / Капацитет.",
                    contactsDefaultDealerRisk = "Podešavanje rada za: Mreža kontakata / Podrazumevani diler / Ризик.",
                    contactsDefaultDealerSkill = "Podešavanje rada za: Mreža kontakata / Podrazumevani diler / Вештина.",
                    contactsDefaultHotspotRadius = "Podešavanje rada za: Mreža kontakata / Podrazumevana vrednost / Žarište / Радијус.",
                    contactsDemandResetMinutes = "Podešavanje rada za: Mreža kontakata / Ресет потражње (минута).",
                    contactsEnabled = "Podešavanje rada za: Mreža kontakata / Омогућено.",
                    contactsExactLocationTrust = "Podešavanje rada za: Mreža kontakata / Tačna lokacija / Повјерење.",
                    contactsFactionDiscoveryReputation = "Podešavanje rada za: Mreža kontakata / Фракција / Otkrivanje / Репутација.",
                    contactsFactionHintTrust = "Podešavanje rada za: Mreža kontakata / Фракција / Nagoveštaj / Повјерење.",
                    contactsFailedDeliveryCooldownMinutes = "Podešavanje rada za: Mreža kontakata / Neuspela dostava / Minuti pauze.",
                    contactsFakeDealEncounter = "Podesite „Lažni posao / Susret” u odeljku „Mreže droge”.",
                    contactsFallbackPreferredDrug = "Podešavanje rada za: Mreža kontakata / Zamenska vrednost / Препоручени лек.",
                    contactsFallbackProductLabel = "Podešavanje rada za: Mreža kontakata / Zamenska vrednost / Назив производа.",
                    contactsGuideBookItem = "Podešavanje rada za: Mreža kontakata / Vodič / Knjiga / Predmet.",
                    contactsGuideBookTrust = "Podešavanje rada za: Mreža kontakata / Vodič / Knjiga / Повјерење.",
                    contactsHireDealerPrice = "Podešavanje rada za: Mreža kontakata / Ангажуј дилера / Цена.",
                    contactsHistoryLimit = "Podešavanje rada za: Mreža kontakata / Лимит историје.",
                    contactsHotspotIntelMinutes = "Podešavanje rada za: Mreža kontakata / Žarište / Obaveštajni podaci / Minuti.",
                    contactsHotspotRotationMinutes = "Podešavanje rada za: Mreža kontakata / Žarište / Rotacija / Minuti.",
                    contactsListingDurationMinutes = "Podešavanje rada za: Mreža kontakata / Oglas / Трајање / Minuti.",
                    contactsMaxOwnedDealers = "Podešavanje rada za: Mreža kontakata / Maksimum / У власништву / Дилери.",
                    contactsMinimumBuyerDeliveryDistance = "Podešavanje rada za: Mreža kontakata / Minimum / Купац / Udaljenost dostave.",
                    contactsMinimumContactRotationMinutes = "Podešavanje rada za: Mreža kontakata / Minimum / Ротација контаката (минута).",
                    contactsMinimumDemandResetMinutes = "Podešavanje rada za: Mreža kontakata / Minimum / Ресет потражње (минута).",
                    contactsMinimumHeatMultiplier = "Podešavanje rada za: Mreža kontakata / Minimum / Policijski pritisak / Množilac.",
                    contactsMinimumHotspotIntelMinutes = "Podešavanje rada za: Mreža kontakata / Minimum / Žarište / Obaveštajni podaci / Minuti.",
                    contactsMinimumHotspotRadius = "Podešavanje rada za: Mreža kontakata / Minimum / Žarište / Радијус.",
                    contactsMinimumHotspotRotationMinutes = "Podešavanje rada za: Mreža kontakata / Minimum / Žarište / Rotacija / Minuti.",
                    contactsMinimumListingDurationMinutes = "Podešavanje rada za: Mreža kontakata / Minimum / Oglas / Трајање / Minuti.",
                    contactsMinimumRewardMultiplier = "Podešavanje rada za: Mreža kontakata / Минимална награда / Množilac.",
                    contactsMinimumRobberyMultiplier = "Podešavanje rada za: Mreža kontakata / Minimum / Крађа / Množilac.",
                    contactsMinimumSpotPriceMultiplier = "Podešavanje rada za: Mreža kontakata / Minimum / Lokacija / Мноилац цене.",
                    contactsOtherDrugPriceMultiplier = "Podešavanje rada za: Mreža kontakata / Drugo / Дрога / Мноилац цене.",
                    contactsPaymentAccount = "Podešavanje rada za: Mreža kontakata / Начин за плаћање.",
                    contactsPostDeliveryDemandResetSeconds = "Podešavanje rada za: Mreža kontakata / Posle dostave / Захтев / Reset / секунд.",
                    contactsPreferredDrugPriceMultiplier = "Podešavanje rada za: Mreža kontakata / Препоручени лек / Мноилац цене.",
                    contactsRegionLocationTrust = "Podešavanje rada za: Mreža kontakata / Region / Локација / Повјерење.",
                    contactsRequestAmounts = "Podesite „Zahtev / Količine” u odeljku „Mreže droge”.",
                    contactsRotationMinutes = "Podešavanje rada za: Mreža kontakata / Rotacija / Minuti.",
                    contactsSpotPools = "Podesite „Lokacija / Grupe za izbor” u odeljku „Mreže droge”.",
                    contactsStreetHotspots = "Podesite „Улица / Žarišta” u odeljku „Mreže droge”.",
                    contactsTrustLevels = "Podesite „Повјерење / Nivoi” u odeljku „Mreže droge”.",
                    businessActionCooldownSeconds = "Podešavanje rada za: Poslovna mreža / Хладноће акције / секунд.",
                    businessBalance = "Podesite „Баланс” u odeljku „Mreže droge”.",
                    businessContracts = "Podesite „Уговори” u odeljku „Mreže droge”.",
                    businessDefaultBusinessName = "Podešavanje rada za: Poslovna mreža / Podrazumevana vrednost / Име бизниса.",
                    businessDefaultRankId = "Podešavanje rada za: Poslovna mreža / Podrazumevana vrednost / Ранг / ID.",
                    businessDefaultStaffStyle = "Podešavanje rada za: Poslovna mreža / Podrazumevana vrednost / Osoblje / Način rada.",
                    businessDefaultTransport = "Podešavanje rada za: Poslovna mreža / Podrazumevana vrednost / Транспорт.",
                    businessEnabled = "Podešavanje rada za: Poslovna mreža / Омогућено.",
                    businessHubs = "Podesite „Distributivni centri” u odeljku „Mreže droge”.",
                    businessLimits = "Podesite „Ograničenja” u odeljku „Mreže droge”.",
                    businessPayments = "Изаберите који баланс плаћа куповине у пословној мрежи и оперативне трошкове.",
                    businessPayoutAccount = "Podešavanje rada za: Poslovna mreža / Износ исплате / Налог.",
                    businessRanks = "Podesite „Činovi” u odeljku „Mreže droge”.",
                    businessReportDays = "Podešavanje rada za: Poslovna mreža / Period izveštaja / дана.",
                    businessRouteEndpointTypes = "Podesite „Рута / Krajnja tačka / Tipovi” u odeljku „Mreže droge”.",
                    businessRuntime = "Podesite „Rad u igri” u odeljku „Mreže droge”.",
                    businessSocietyPermission = "Podešavanje rada za: Poslovna mreža / Organizacija / Dozvola.",
                    businessStaff = "Podesite „Osoblje” u odeljku „Mreže droge”.",
                    businessTickMinutes = "Podešavanje rada za: Poslovna mreža / Ciklus ažuriranja / Minuti.",
                    businessTransports = "Podesite „Transporti” u odeljku „Mreže droge”.",
                },
                robbery = {
                    atmAvailability = "Омогући или онемогући систем за пљачку банкомата.",
                    atmLocations = "Управљајте положајима банкомата одобреним од стране сервера доступним за пљачке.",
                    atmPolice = "Конфигуришите захтев за полицију на дужности за почетак пљачке.",
                    atmItems = "Подесите потребне предмете бушилице, траке за вучу и експлозивног пуњења.",
                    atmActionTimes = "Поставите трајање прилепљивања, постављања, детонације и пљачкања акција.",
                    atmTimeouts = "Контролишите колико дуго пробијени банкомат остаје доступан за пљачку.",
                    atmPayout = "Конфигуришите циљни налог и опсег случајне награде.",
                    atmDistances = "Поставите опсеге за играча и возило које користе интеракције банкомата.",
                    atmExplosionEffects = "Конфигуришите нативне параметре експлозије коришћене током детонације.",
                    atmDispatchAlert = "Конфигуришите полупречник, трајање и приоритет за полицијски аларм.",
                    atmDispatchRecipients = "Изаберите која имена занимања добијају аларме за пљачку банкомата.",
                    shopAvailability = "Омогући крађе и конфигуришите захтев за полицију.",
                    shopTiming = "Конфигуришите уплашивање, акције, трајање и хлађење.",
                    shopSafe = "Конфигуришите покушаје на тастеру и предмет за бушење.",
                    shopRegisterReward = "Конфигуришите случајну награду за сваку касу.",
                    shopSafeReward = "Конфигуришите случајну награду из сефа.",
                    shopDispatchSettings = "Конфигуришите прималаце и својства аларма.",
                    shopLocationTable = "Управљајте продавницама са особљем и сефовима.",
                    pickpocketAvailability = "Омогући ову функцију и опционо је ограничи на конфигурисана криминална занимања.",
                    pickpocketGameplay = "Изаберите изазов и независне вероватноће за бег, позив за помоћ и контра-напад.",
                    pickpocketItemRewards = "Контролишите празне џепове и видљиве опције за предмете до 0.0001 процената.",
                    pickpocketMoney = "Конфигуришите опсег случајног новца генерисаног од стране сервера.",
                    pickpocketDistances = "Поставите опсег NPC-а који се користи за заједнички радијални и циљни систем.",
                    pickpocketRateLimits = "Контролишите ограничење захтева, време чекања по NPC-у и истецање сесије.",
                    pickpocketDispatchSettings = "Конфигурише аларм који се шаље када NPC позива службе ванредних ситуација.",
                    heistCrafting = "Одредите колико интеракције је потребно за израду опреме за хеист. Примењује се на нова покушаја у целом систему криминала.",
                    heistCreatorMenu = "Креирајте, уређујте и објавите модулне пљачке у посвећеном Креатору пљачки.",
                    heistExecution = "Прозор за почетак, неактивност и пауза за извођење пљачке.",
                    npcPoliceSupport = "Наоружани полицајци NPC-а реагују пешаком на аларме за пљачку и подржавају полицију борбом против пљачкаша.",
                },
                baseRaids = {
                    baseRaids = "Приступ нападима, захтеви и појединачно изабирљиве категорије награда. Отворени напади немају ограничење за транспорт.",
                },
                weapons = {
                    weaponCreatorMenu = "Управљај путевима оружја и прањем новца у једном уређивачу.",
                    weaponRuntime = "Подесите доступност и приступ рутама оружја.",
                    weaponDefaultsgeneral = "Podesite „Опште подразумеване вредности” u odeljku „Руте оружја”.",
                    weaponDefaultsaccess = "Podesite „Подразумевани приступ” u odeljku „Руте оружја”.",
                    weaponDefaultscollection = "Podesite „Подразумевано сакупљање” u odeljku „Руте оружја”.",
                    weaponDefaultsproduction = "Podesite „Подразумевана производња” u odeljku „Руте оружја”.",
                    weaponDefaultsmarket = "Podesite „Подразумевано тржиште” u odeljku „Руте оружја”.",
                    weaponDefaultsdelivery = "Podesite „Подразумевани налози” u odeljku „Руте оружја”.",
                    weaponStreet = "Podesite „Улична продаја оружја” u odeljku „Руте оружја”.",
                },
                darknetMarket = {
                    darknetAvailability = "Контролише таблет апликацију и њену поставку.",
                    darknetEconomy = "Конфигурише салдо новчаника, размену монети и курсеве плаћања.",
                    darknetListings = "Контролише ограничења понуда, цене и аутоматско истецање.",
                    darknetChat = "Ограничава поруке на шифрованом тржишту.",
                    darknetIdentity = "Конфигурише ротацију идентитета, верификацију и упозорења на преваре.",
                    darknetDelivery = "Конфигурише физичка састанка и крадиве кутије у свету.",
                    darknetDeliveryLocations = "Конфигурише листе локација које BlackBay случајно бира за трговину са NPC-има.",
                    darknetPolice = "Групе запослења дозвољене за објављивање замки и преглед истрага.",
                    darknetNpcTraders = "Трајни купци и продавци NPC-а са конфигурисаним ризиком.",
                },
                interrogation = {
                    general = "Podesite „Опште” u odeljku „Испитивање”.",
                    consent = "Podesite „Заштита играча” u odeljku „Испитивање”.",
                    objects = "Podesite „Објекти” u odeljku „Испитивање”.",
                    grab = "Podesite „Ухват” u odeljku „Испитивање”.",
                    session = "Podesite „Сесија” u odeljku „Испитивање”.",
                    dispatch = "Podesite „Полицијске пријаве” u odeljku „Испитивање”.",
                    logging = "Podesite „Логирање” u odeljku „Испитивање”.",
                    security = "Podesite „Безбедност” u odeljku „Испитивање”.",
                    presentation = "Podesite „Приказ” u odeljku „Испитивање”.",
                },
                reputation = {
                    crimeReputation = "Podesite „Reputacija” u odeljku „Reputacija”.",
                },
            },
            settingGroups = {
                weaponRuntime = { label = "Опште", description = "Подесите доступност и приступ рутама оружја." },
                weaponCreatorMenu = { label = "Илегални пословни креатор", description = "Управљај путевима оружја и прањем новца у једном уређивачу." },
                atmActionTimes = {
                    description = "Поставите трајање прилепљивања, постављања, детонације и пљачкања акција.",
                    label = "Дурације акција",
                },
                atmAvailability = {
                    description = "Омогући или онемогући систем за пљачку банкомата.",
                    label = "Доступност",
                },
                atmDispatchAlert = {
                    description = "Конфигуришите полупречник, трајање и приоритет за полицијски аларм.",
                    label = "Својства аларма",
                },
                atmDispatchRecipients = {
                    description = "Изаберите која имена занимања добијају аларме за пљачку банкомата.",
                    label = "Прималац",
                },
                atmDistances = {
                    description = "Поставите опсеге за играча и возило које користе интеракције банкомата.",
                    label = "Дистанце интеракције",
                },
                atmExplosionEffects = {
                    description = "Конфигуришите нативне параметре експлозије коришћене током детонације.",
                    label = "Ефекти експлозије",
                },
                atmItems = {
                    description = "Подесите потребне предмете бушилице, траке за вучу и експлозивног пуњења.",
                    label = "Потребни предмети",
                },
                atmLocations = {
                    description = "Управљајте положајима банкомата одобреним од стране сервера доступним за пљачке.",
                    label = "Локације банкомата",
                },
                atmPayout = {
                    description = "Конфигуришите циљни налог и опсег случајне награде.",
                    label = "Износ исплате",
                },
                atmPolice = {
                    description = "Конфигуришите захтев за полицију на дужности за почетак пљачке.",
                    label = "Захтев за полицију",
                },
                atmPulling = {
                    description = "Конфигуришите кретање потребно за одвајање банкомата од зида.",
                    label = "Детекција вађења",
                },
                atmTimeouts = {
                    description = "Контролишите колико дуго пробијени банкомат остаје доступан за пљачку.",
                    label = "Време за пљачку",
                },
                baseRaids = {
                    description = "Приступ нападима, захтеви и појединачно изабирљиве категорије награда. Отворени напади немају ограничење за транспорт.",
                    label = "Напади на базу",
                },
                businessPayments = {
                    description = "Изаберите који баланс плаћа куповине у пословној мрежи и оперативне трошкове.",
                    label = "Плаћања",
                },
                crimeMembership = {
                    description = "Одредите како криминалне организације складиште и управљају својим члановима.",
                    label = "Модел чланства",
                },
                darknetAvailability = {
                    description = "Контролише таблет апликацију и њену поставку.",
                    label = "Доступност",
                },
                darknetChat = {
                    description = "Ограничава поруке на шифрованом тржишту.",
                    label = "Приватни чат",
                },
                darknetDelivery = {
                    description = "Конфигурише физичка састанка и крадиве кутије у свету.",
                    label = "Предаје и мртви падови",
                },
                darknetDeliveryLocations = {
                    description = "Конфигурише листе локација које BlackBay случајно бира за трговину са NPC-има.",
                    label = "Локације предаје",
                },
                darknetEconomy = {
                    description = "Конфигурише салдо новчаника, размену монети и курсеве плаћања.",
                    label = "Криптовалута",
                },
                darknetIdentity = {
                    description = "Конфигурише ротацију идентитета, верификацију и упозорења на преваре.",
                    label = "Алијаси и репутација",
                },
                darknetListings = {
                    description = "Контролише ограничења понуда, цене и аутоматско истецање.",
                    label = "Понуде и истека",
                },
                darknetNpcTraders = {
                    description = "Трајни купци и продавци NPC-а са конфигурисаним ризиком.",
                    label = "NPC трговци",
                },
                darknetPolice = {
                    description = "Групе запослења дозвољене за објављивање замки и преглед истрага.",
                    label = "Приступ полиције",
                },
                heistCrafting = {
                    description = "Одредите колико интеракције је потребно за израду опреме за хеист. Примењује се на нова покушаја у целом систему криминала.",
                    label = "Радионица за хек",
                },
                heistCreatorMenu = {
                    description = "Креирајте, уређујте и објавите модулне пљачке у посвећеном Креатору пљачки.",
                    label = "Мени креатора",
                },
                heistExecution = {
                    description = "Прозор за почетак, неактивност и пауза за извођење пљачке.",
                    label = "Време извођења пљачке",
                },
                moneywashEconomy = {
                    description = "Активирајте објекте и подесите рачун за депозит, сервисну таксу и дистанце интеракције.",
                    label = "Опште",
                },
                npcPoliceSupport = {
                    description = "Наоружани полицајци NPC-а реагују пешаком на аларме за пљачку и подржавају полицију борбом против пљачкаша.",
                    label = "Наоружани полицајци NPC-а реагују пешаком на аларме за пљачку и подржавају полицију борбом против пљачкаша.",
                },
                pickpocketAvailability = {
                    description = "Омогући ову функцију и опционо је ограничи на конфигурисана криминална занимања.",
                    label = "Доступност",
                },
                pickpocketDispatchSettings = {
                    description = "Конфигурише аларм који се шаље када NPC позива службе ванредних ситуација.",
                    label = "Диспечер ванредних ситуација",
                },
                pickpocketDistances = {
                    description = "Поставите опсег NPC-а који се користи за заједнички радијални и циљни систем.",
                    label = "Дистанце интеракције",
                },
                pickpocketGameplay = {
                    description = "Изаберите изазов и независне вероватноће за бег, позив за помоћ и контра-напад.",
                    label = "Ризик и мини-игра",
                },
                pickpocketItemRewards = {
                    description = "Контролишите празне џепове и видљиве опције за предмете до 0.0001 процената.",
                    label = "Видљив садржај џепова",
                },
                pickpocketMoney = {
                    description = "Конфигуришите опсег случајног новца генерисаног од стране сервера.",
                    label = "Награда у новцу",
                },
                pickpocketRateLimits = {
                    description = "Контролишите ограничење захтева, време чекања по NPC-у и истецање сесије.",
                    label = "Мере безбедности сервера",
                },
                pvpArenas = {
                    description = "Креирајте круглу зону борбе, тачку посматрача и тачке спавна за тимове које користе PvP догађаји.",
                    label = "Арене и зоне борбе",
                },
                pvpAutomation = {
                    description = "Конфигуришите понављајуће догађаје и аутоматски процес покретања.",
                    label = "Аутоматизација",
                },
                pvpAvailability = {
                    description = "Контролишите да ли је апликација за PvP догађаје доступна и где се приказује.",
                    label = "Доступност",
                },
                pvpLimits = {
                    description = "Поставите ограничења за награде и историју таблета.",
                    label = "Ограничења и историја",
                },
                pvpModes = {
                    description = "Конфигуришите режим игре који је преизабран у PvP таблету.",
                    label = "Режим игре",
                },
                pvpPermissions = {
                    description = "Везујте управљање догађајима и финансије са овлашћењима ACE и запослења.",
                    label = "Дозволе",
                },
                pvpRuntime = {
                    description = "Прилагодите обраду захтева, смрти и поновно појављивање током активних такмичења.",
                    label = "Време трајања такмичења",
                },
                pvpTakeoverMethods = {
                    description = "Одредите колико времена свака метода треба за пробијање улаза.",
                    label = "Методи пробоја",
                },
                pvpTakeoverRules = {
                    description = "Контролишите доступност и захтеве за учешће за преузимање лабораторије и кампера.",
                    label = "Правила преузимања",
                },
                pvpTakeoverZones = {
                    description = "Конфигуришите зоне за интеракцију, алармне зоне и зоне за заузимање заједно са њиховим трајањем.",
                    label = "Зоне и времена",
                },
                shopAvailability = {
                    description = "Омогући крађе и конфигуришите захтев за полицију.",
                    label = "Доступност",
                },
                shopDispatchSettings = {
                    description = "Конфигуришите прималаце и својства аларма.",
                    label = "Полицијски аларм",
                },
                shopLocationTable = {
                    description = "Управљајте продавницама са особљем и сефовима.",
                    label = "Локације продавница",
                },
                shopRegisterReward = {
                    description = "Конфигуришите случајну награду за сваку касу.",
                    label = "Награда за касу",
                },
                shopRegisterTable = {
                    description = "Доделите појединачне касе продавницама.",
                    label = "Касне",
                },
                shopSafe = {
                    description = "Конфигуришите покушаје на тастеру и предмет за бушење.",
                    label = "Сигурно место",
                },
                shopSafeReward = {
                    description = "Конфигуришите случајну награду из сефа.",
                    label = "Награда из сефа",
                },
                shopTiming = {
                    description = "Конфигуришите уплашивање, акције, трајање и хлађење.",
                    label = "Време",
                },
            },
            settingSections = {
                weapons = "Руте оружја",
                drugs = "Sistem droge",
                drugProduction = "Proizvodnja droge",
                drugOperations = "Poslovanje sa drogom",
                drugMarketRisk = "Tržište i rizik",
                drugNetworks = "Mreže droge",
                atmRobbery = "Крађа са банкомата",
                baseRaids = "Напади на базу",
                crimeOrganizations = "Организације",
                darknetMarket = "Тамно тржиште",
                moneywash = "Прање новца",
                pvpEvents = "PvP фракција",
                robbery = "Крађа",
                territories = "Територије",
                graffiti = "Граффити",
                interrogation = "Испитивање",
            },
            settingSubsections = {
                baseRaidEquipment = "Potrebna oprema",
                baseRaidBreach = "Provala",
                baseRaidLoot = "Plen i vozila",
                graffitiLimits = "Ograničenja i moderacija",
                interrogationTechnical = "Evidencija i bezbednost",
                atmDispatch = "Позив полиције",
                atmEquipment = "Опрема",
                atmExplosion = "Експлозија",
                atmOverview = "Преглед и локације",
                atmRewards = "Награде",
                atmTiming = "Време",
                atmVehicle = "Возило и извлачење",
                baseRaids = "Напади на базу",
                crimeMembership = "Чланство",
                heistCreator = "Креатор хеиста",
                npcPoliceSupport = "Наоружани полицајци NPC-а реагују пешаком на аларме за пљачку и подржавају полицију борбом против пљачкаша.",
                pickpocket = "Крађа новчаника од NPC-а",
                pvpArenas = "Арене",
                pvpEquipment = "Режим игре",
                pvpOverview = "Преглед",
                pvpRuntime = "Време трајања такмичења",
                pvpTakeovers = "Преузимања лабораторија",
                shopRobbery = "Пљачке у продавницама",
                atmRobbery = "Крађа са банкомата",
            },
            settings = {
                weaponDefaultGeneralInteractionDistance = { label = "Удаљеност интеракције" },
                weaponDefaultGeneralPedModel = { label = "Подразумевани NPC модел" },
                weaponDefaultAccessActiveHourStart = { label = "Време отварања (UTC)" },
                weaponDefaultAccessActiveHourEnd = { label = "Време затварања (UTC)" },
                weaponDefaultAccessPoliceRequired = { label = "Потребни полицајци на дужности" },
                weaponDefaultAccessPoliceJobs = { label = "Полицијски послови" },
                weaponDefaultCollectionDurationSeconds = { label = "Трајање у секундама" },
                weaponDefaultCollectionCooldownSeconds = { label = "Пауза у секундама" },
                weaponDefaultCollectionCooldownScope = { label = "Опсег паузе" },
                weaponDefaultCollectionUseMinigame = { label = "Користи мини-игру" },
                weaponDefaultCollectionMinigame = { label = "Мини-игра" },
                weaponDefaultCollectionMinigameRounds = { label = "Рунде мини-игре" },
                weaponDefaultProductionDurationSeconds = { label = "Трајање у секундама" },
                weaponDefaultProductionSuccessChance = { label = "Шанса за успех (%)" },
                weaponDefaultProductionFailureConsumesInputs = { label = "Потроши састојке при неуспеху" },
                weaponDefaultProductionUseMinigame = { label = "Користи мини-игру" },
                weaponDefaultProductionMinigame = { label = "Мини-игра" },
                weaponDefaultProductionMinigameRounds = { label = "Рунде мини-игре" },
                weaponDefaultProductionQualityMin = { label = "Најмањи квалитет" },
                weaponDefaultProductionQualityMax = { label = "Највећи квалитет" },
                weaponDefaultProductionCooldownSeconds = { label = "Пауза у секундама" },
                weaponDefaultProductionCooldownScope = { label = "Опсег паузе" },
                weaponDefaultMarketPayoutAccount = { label = "Рачун за исплату" },
                weaponDefaultMarketPriceMultiplierMin = { label = "Најмањи фактор цене (%)" },
                weaponDefaultMarketPriceMultiplierMax = { label = "Највећи фактор цене (%)" },
                weaponDefaultMarketRestockSeconds = { label = "Интервал допуне у секундама" },
                weaponDefaultMarketCooldownSeconds = { label = "Пауза у секундама" },
                weaponDefaultMarketCooldownScope = { label = "Опсег паузе" },
                weaponDefaultDeliveryContractDurationMinutes = { label = "Рок налога у минутима" },
                weaponDefaultDeliveryContractBonusPercent = { label = "Бонус налога (%)" },
                weaponStreetEnabled = { label = "Ретке продаје оружја уличним купцима" },
                weaponStreetChance = { label = "Шанса понуде оружја (%)" },
                weaponStreetCooldown = { label = "Пауза у секундама" },
                weaponStreetAmount = { label = "Највећа количина" },
                weaponStreetPriceMin = { label = "Најмањи фактор цене (%)" },
                weaponStreetPriceMax = { label = "Највећи фактор цене (%)" },
                weaponStreetAccount = { label = "Рачун за исплату" },
                weaponStreetDirect = { label = "Директна продаја" },
                weaponStreetBulk = { label = "Продаја на велико" },
                weaponStreetContract = { label = "Налог картела" },
                weaponSystemEnabled = { label = "Систем рута оружја", description = "Омогућите прикупљање и обраду оружја и продају картелима." },
                weaponRuntimeEnabled = { label = "Радње рута оружја", description = "Дозволите коришћење подешених рута оружја у свету игре." },
                weaponCreatorAccess = { label = "Приступ уређивачу оружја", description = "Изаберите ко може да отвори уређивач оружја.", options = { permission = "Samo uz dozvolu", jobManagement = "Upravljanje poslom", ownerOnly = "Samo vlasnik" } },
                openWeaponCreator = { label = "Илегални пословни креатор", description = "Управљај путевима оружја и прањем новца у једном уређивачу.", buttonLabel = "Илегални пословни креатор", unsavedTooltip = "Прво сачувајте" },

                drugCultivationProgressionEnabled = { label = "Укључи нивое узгоја", description = "Укључује XP узгоја, нивое и откључавања по нивоу." },
                drugCultivationMaxLevel = { label = "Највиши ниво узгоја", description = "Највиши достижан ниво узгоја. Виши нивои остају недоступни." },
                drugCultivationLevels = { label = "Крива нивоа", description = "Подесите назив и укупан XP праг за сваки ниво узгоја." },
                drugCultivationActionXp = { label = "XP награде", description = "Подесите колико XP узгоја даје свака радња." },
                drugCultivationUnlocks = { label = "Откључавања нивоа", description = "Подесите потребан ниво за посуде, подлоге, опрему, сорте и нивое скенера." },
                reputationRewards = { label = "Radnje reputacije", description = "Dodajte radnje, menjajte poene i isključujte ili brišite stavke. Samo aktivne stavke dodeljuju poene." },
                reputationEnabled = { label = "Uključi kriminalnu reputaciju", description = "Dodeljuj ličnu reputaciju." },
                reputationPointsPerLevel = { label = "Poeni po nivou", description = "Svaki nivo zahteva ovoliko dodatnih poena." },
                reputationMinimumJoinPoints = { label = "Minimalna reputacija za ulazak", description = "Ukupni poeni potrebni za ulazak u kriminalnu frakciju. 0 isključuje uslov. Postojeći članovi zadržavaju pristup." },
                reputation_atm = { label = "Pljačka bankomata", description = "Poeni za uspešno završenu radnju. 0 isključuje ovu nagradu." },
                reputation_shop_register = { label = "Kasa prodavnice", description = "Poeni za uspešno završenu radnju. 0 isključuje ovu nagradu." },
                reputation_shop_safe = { label = "Sef prodavnice", description = "Poeni za uspešno završenu radnju. 0 isključuje ovu nagradu." },
                reputation_pickpocket = { label = "Džeparenje", description = "Poeni za uspešno završenu radnju. 0 isključuje ovu nagradu." },
                reputation_heist = { label = "Završena pljačka", description = "Poeni za uspešno završenu radnju. 0 isključuje ovu nagradu." },
                reputation_drug_harvest = { label = "Berba droge", description = "Poeni za uspešno završenu radnju. 0 isključuje ovu nagradu." },
                reputation_drug_processing = { label = "Prerada droge", description = "Poeni za uspešno završenu radnju. 0 isključuje ovu nagradu." },
                reputation_drug_sale = { label = "Prodaja droge", description = "Poeni za uspešno završenu radnju. 0 isključuje ovu nagradu." },
                reputation_drug_delivery = { label = "Dostava droge", description = "Poeni za uspešno završenu radnju. 0 isključuje ovu nagradu." },
                reputation_drug_contract = { label = "Ugovor o distribuciji", description = "Poeni za uspešno završenu radnju. 0 isključuje ovu nagradu." },
                reputation_drug_raid = { label = "Prepad zbog droge", description = "Poeni za uspešno završenu radnju. 0 isključuje ovu nagradu." },
                reputation_graffiti = { label = "Grafiti", description = "Poeni za uspešno završenu radnju. 0 isključuje ovu nagradu." },
                reputation_moneywash = { label = "Pranje novca", description = "Poeni za uspešno završenu radnju. 0 isključuje ovu nagradu." },
                reputation_base_raid = { label = "Prepad na bazu", description = "Poeni za uspešno završenu radnju. 0 isključuje ovu nagradu." },
                reputation_pvp_win = { label = "PvP pobeda", description = "Poeni za uspešno završenu radnju. 0 isključuje ovu nagradu." },
                atmChargeProp = {
                    description = "Модел објекта приказан на банкомату док се поставља експлозивни набој.",
                    label = "Предмет са експлозивом",
                },
                atmConsumeDrill = {
                    description = "Троши подешену количину после сваке успешно завршене тачке бушења банкомата.",
                    label = "Троши бушилицу",
                },
                atmDrillItem = {
                    description = "ID предмета у инвентару потребног за бушење ишчупаног банкомата. Подешава се одвојено од бушилице за сефове у продавницама.",
                    label = "Предмет бушилице",
                },
                atmDrillItemAmount = {
                    description = "Број предмета бушилице потребних за сваку тачку бушења банкомата.",
                    label = "Потребан број бушилица",
                },
                atmDebug = {
                    description = "Пише детаљне дијагностичке поруке о крађи из ATM-а у серверску конзолу и клијентску F8 конзолу.",
                    label = "ATM дег-лог записи",
                },
                atmDispatchDurationSeconds = {
                    description = "Секунде током којих аларм банкомата остаје релевантан за потрошаче диспача.",
                    label = "Трајање диспача",
                },
                atmDispatchEnabled = {
                    description = "Креира инцидент базе посао када се ATM пробије.",
                    label = "Омогући полицијски диспачинг",
                },
                atmDispatchJobs = {
                    description = "Имена послова раздвојена запетом која добијају аларм АТМ-а.",
                    label = "Послови диспачирања",
                },
                atmDispatchPriority = {
                    description = "Вредност приоритета која се преноси непромењено интеграцији диспачирања.",
                    label = "Приоритет диспачирања",
                },
                atmDispatchRadius = {
                    description = "Приближан радијус аларма који се шаље интеграцији диспачирања.",
                    label = "Радијус диспачирања",
                },
                atmEnabled = {
                    description = "Чини конфигурисане банкомате доступним за крађе ланцем и експлозивом.",
                    label = "Омогући крађе банкомата",
                },
                atmExplosionCameraShake = {
                    description = "Интензитет трескања камере за клијента који ствара експлозију.",
                    label = "Трескање камере при експлозији",
                },
                atmExplosionDamageScale = {
                    description = "Вредност оштећења и импулса пренета на функцију експлозије.",
                    label = "Меромер оштећења експлозије",
                },
                atmExplosionType = {
                    description = "Тип експлозије GTA коришћен при детонацији. Задржите подразумевани осим ако није тестиран други тип.",
                    label = "Тип експлозије",
                },
                atmDrillDurationSeconds = {
                    label = "Минимално време бушења по завртњу (с)",
                    description = "Минимално време у секундама за сваки од четири завртња. Паузе за хлађење продужавају покушај. Важи за покушаје бушења започете након чувања подешавања.",
                },
                atmExplosiveDurationSeconds = {
                    description = "Секунде потребне за постављање експлозивног набоја.",
                    label = "Трајање постављања набоја",
                },
                atmExplosiveItem = {
                    description = "Предмет из инвентара потрошен након постављања набоја.",
                    label = "Експлозивни предмет",
                },
                atmExplosiveItemAmount = {
                    description = "Број експлозивних ставки потрошених за једну постављену набој.",
                    label = "Користена количина експлозива",
                },
                atmFuseSeconds = {
                    description = "Секунде између постављања и експлозије.",
                    label = "Трајање запалке",
                },
                atmInteractionDistance = {
                    description = "Максимални опсег интеракције са клијентом; провера сервера додаје безбедносну маргину.",
                    label = "Дистанца интеракције",
                },
                atmLocations = {
                    description = "Ауторитативни банкомати у производњи. Локације створене са /atmtest остају привремене.",
                    itemLabel = "Локација банкомата",
                    label = "Локације банкомата",
                },
                atmLootDurationSeconds = {
                    description = "Секунде потребне за отварање пробијеног банкомата.",
                    label = "Трајање пљачке",
                },
                atmLootReservationTimeoutSeconds = {
                    description = "Максимални број секунди које један играч може да резервише банкомат док га отвара; аутоматски се одржава изнад трајања ограбљивања.",
                    label = "Трајање резервисања награде",
                },
                atmLootWindowMinutes = {
                    description = "Минута током којих пробијени банкомат остаје доступан за пљачку пре него што се исцрпи.",
                    label = "Прозор за пљачку",
                },
                atmMinimumPolice = {
                    description = "Број чланова конфигурисане полицијске групе који морају бити на дужности да би се започела крађа.",
                    label = "Минимална полиција",
                },
                atmPoliceGroup = {
                    description = "sky_jobs_base група запослених се броји за полицијски захтев.",
                    label = "Група послова полиције",
                },
                atmPullDistance = {
                    description = "Помак возила од положаја банкомата потребан за извршење пробоја.",
                    label = "Потребна удаљеност за повлачење",
                },
                atmPullMinimumSpeed = {
                    description = "Минимална брзина возила у метрима у секунди када се достигне дистанца одвлачења.",
                    label = "Минимална брзина одвлачења",
                },
                atmReservationTimeoutSeconds = {
                    description = "Максималне секунде резервисане док играч причврсти шлагер или постави набој; аутоматски се држи изнад трајања акције.",
                    label = "Временни лимит за резервацију припреме",
                },
                atmRewardAccount = {
                    description = "Изаберите готовину или предмет black_money.",
                    label = "Врста исплате банкомата",
                },
                atmRewardMaximum = {
                    description = "Највиши износ новца који се исплаћује са једног банкомата; никада нижи од минимума.",
                    label = "Максимална награда",
                },
                atmRewardMinimum = {
                    description = "Најнижи износ новца који се исплаћује са једног банкомата.",
                    label = "Минимална награда",
                },
                atmSlingDurationSeconds = {
                    description = "Неопходне секунде за причвршћивање шљинге.",
                    label = "Трајање причвршћивања шљинге",
                },
                atmSlingItem = {
                    description = "Потребан је поновљиви предмет из инвентара за метод возила.",
                    label = "Предмет за везање",
                },
                atmSlingItemAmount = {
                    description = "Број предмета шљинга који морају бити присутни. Они се не троше.",
                    label = "Неопходна количина шљинга",
                },
                atmTestScanDistance = {
                    description = "Максимална дистанца коју користи /atmtest при тражењу подржаног ATM-пропа.",
                    label = "Дистанца за тестни скенирање ATM-а",
                },
                atmVehicleMaxDistance = {
                    description = "Максимална удаљеност између банкомата и прикладног возила приликом прикретања.",
                    label = "Удаљеност прикретања возила",
                },
                baseRaid_breachTimeoutSeconds = {
                    description = "Vremensko ograničenje svakog pokušaja obijanja skladišta (sekunde).",
                    label = "Трајање прорива (секунде)",
                },
                baseRaid_command = {
                    description = "Име команде без наспреда. Поново покрените ресурс crime након измене.",
                    label = "Команда за напад",
                },
                baseRaid_crimeItem = {
                    description = "Предмет за пробој банде.",
                    label = "Предмет за пробој банде",
                },
                baseRaid_crimeVehicles = {
                    description = "Приступ возилима гетто групе.",
                    label = "Приступ возилима гетто групе",
                },
                baseRaid_difficulty = {
                    description = "Тешкоћа провере вештине.",
                    label = "Тешкоћа провере вештине",
                    options = {
                        easy = "Леско",
                        expert = "Експерт",
                        hard = "Сложно",
                        normal = "Нормално",
                    },
                },
                baseRaid_enabled = {
                    description = "Омогући нападе на базе.",
                    label = "Омогући нападе на базе",
                },
                baseRaid_failedCooldownMinutes = {
                    description = "Vreme čekanja kada se racija završi bez otvaranja skladišta (minuti).",
                    label = "Време паузе након неуспеха (минута)",
                },
                baseRaid_interactionDistance = {
                    description = "Дистанца интеракције са складиштем.",
                    label = "Дистанца интеракције са складиштем",
                },
                baseRaid_lootHeistStorage = {
                    description = "Омогући потпуно извлачење ове категорије инвентара током активног напада.",
                    label = "Пљачка складишта за хеист",
                },
                baseRaid_lootLaboratories = {
                    description = "Омогући потпуно извлачење ове категорије инвентара током активног напада.",
                    label = "Пљачка лабораторијског складишта",
                },
                baseRaid_lootPersonalLockers = {
                    description = "Омогући потпуно извлачење ове категорије инвентара током активног напада.",
                    label = "Плундирање личних спина",
                },
                baseRaid_lootStorage = {
                    description = "Омогући потпуно извлачење ове категорије инвентара током активног напада.",
                    label = "Пљачка складишта",
                },
                baseRaid_lootVehicleGloveboxes = {
                    description = "Омогући потпуно извлачење ове категорије инвентара током активног напада.",
                    label = "Плундирање фиока за рукавице у аутомобилима.",
                },
                baseRaid_lootVehicleTrunks = {
                    description = "Омогући потпуно извлачење ове категорије инвентара током активног напада.",
                    label = "Плундирање кофара возила",
                },
                baseRaid_minimumDefenders = {
                    description = "Минималан број онлајн бранилаца.",
                    label = "Минималан број онлајн бранилаца",
                },
                baseRaid_policeItem = {
                    description = "Предмет за прорив полиције.",
                    label = "Предмет за прорив полиције",
                },
                baseRaid_policeRequireDuty = {
                    description = "Полиција мора бити на дужности.",
                    label = "Полиција мора бити на дужности",
                },
                baseRaid_policeVehicles = {
                    description = "Приступ возилима полиције.",
                    label = "Приступ возилима полиције",
                },
                baseRaid_protectionHours = {
                    description = "Заштита након успеха (сати).",
                    label = "Заштита након успеха (сати)",
                },
                baseRaid_requiredHits = {
                    description = "Потребни покови провере вештине.",
                    label = "Потребни покови провере вештине",
                },
                baseRaid_warrantItem = {
                    description = "Један од ових предмета се троши за сваки важећи почетак полицијског напада.",
                    label = "Предмет за налог за претрагу",
                },
                crimeMembershipMode = {
                    description = "Режим фрејмворка чува постојећи посао или интеграцију са локалном бандом. Независни режим ради криминалне организације у позадини поред нормалног посла играча и аутоматски преноси постојећа чланства.",
                    label = "Модел чланства организације",
                    options = {
                        framework = "Посао / банда фрејмворка",
                        independent = "Независна организација",
                    },
                },
                darknetAliasChangeCooldownHours = {
                    description = "Минимална старост идентитета пре него што се може поново повући.",
                    label = "Време чекања за промену алијаса (сати)",
                },
                darknetCurrencyCode = {
                    description = "Кратка ознака која се приказује за интерну евиденцију криптовалуте.",
                    label = "Код валуте",
                },
                darknetDeadDropInteractionDistance = {
                    description = "Удаљеност потребна за претрагу и узимање кутије.",
                    label = "Удаљеност интеракције за Dead Drop",
                },
                darknetDeadDropLifetimeHours = {
                    description = "Време пре истека неузете кутије.",
                    label = "Трајање Dead Drop-а (сати)",
                },
                darknetDeadDropModel = {
                    description = "GTA модел објекта који се локално ствара за доступна места за тајну примопредају.",
                    label = "Модел кутије за Dead Drop",
                },
                darknetDeadDropPollIntervalMs = {
                    description = "Интервал коришћен за освежавање блиских кутија и састанака NPC-а.",
                    label = "Интервал освежавања света (мс)",
                },
                darknetDeadDropStreamDistance = {
                    description = "Удаљеност на којој се преносе кутије и контакти за састанак NPC-а.",
                    label = "Удаљеност за преношење за Dead Drop",
                },
                darknetDropLocations = {
                    description = "Ове локације се случајно додељују трговинама за скривено предавање са НЦП-има. Унесите најмање две.",
                    itemLabel = "Локација за скривено предавање",
                    label = "Локације за скривено предавање",
                },
                darknetEnabled = {
                    description = "Чини таблет апликацију црног тржишта и њену радну логику доступним.",
                    label = "Укључи Тамно тржиште",
                },
                darknetExchangeBuyPrice = {
                    description = "Износ наплаћен са рачуна за плаћање за један новац.",
                    label = "Цена куповине по новцу",
                },
                darknetExchangeEnabled = {
                    description = "Омогућава аутентификованим корисницима BlackBay-а да купују и продају новце на њиховој страници рачуна.",
                    label = "Укључи размену новца",
                },
                darknetExchangeMaximumAmount = {
                    description = "Највећи цели износ Coin-ова који се прихвата у једној размени.",
                    label = "Максимални новац по размени",
                },
                darknetExchangeMinimumAmount = {
                    description = "Најмањи цели износ Coin-ова који се прихвата у једној размени.",
                    label = "Минимални новац по размени",
                },
                darknetExchangePaymentAccount = {
                    description = "Фрајмворк рачун коришћен за куповину новца и исплате од продаје.",
                    label = "Рачун за плаћање за размену новца",
                    options = {
                        bank = "Банка",
                        black_money = "Неопран новац",
                        money = "Кеш",
                    },
                },
                darknetExchangeSellPrice = {
                    description = "Износ за један Coin на рачун за плаћање.",
                    label = "Цена продаје по новцу",
                },
                darknetFaceToFaceDistance = {
                    description = "Максимална удаљеност између оба играча или конфигурисане тачке NPC-а.",
                    label = "Удаљеност за предају",
                },
                darknetKnownScammerReports = {
                    description = "Уникалне пријаве трговине потребне за ознаку познатог измамљивача.",
                    label = "Пријаве за упозорење на измаму",
                },
                darknetListingExpiryHours = {
                    description = "Активне понуде истичу аутоматски након овог броја сати.",
                    label = "Трајање понуде (сати)",
                },
                darknetMaximumListingQuantity = {
                    description = "Горња граница количине за једну понуду.",
                    label = "Максимална количина робе",
                },
                darknetMaximumListings = {
                    description = "Максималан број понуда по активном алијасу.",
                    label = "Максималан број активних понуда",
                },
                darknetMaximumMessageLength = {
                    description = "Максималан број карактера по зашићеној чат поруци.",
                    label = "Максимална дужина поруке",
                },
                darknetMaximumUnitPrice = {
                    description = "Горња крипто цена за једну јединицу.",
                    label = "Максимална цена по јединици",
                },
                darknetMeetingLocations = {
                    description = "Ове локације се случајно додељују за трговину лице-у-лице са НПК-има. Унесите најмање две.",
                    itemLabel = "Локација састанка",
                    label = "Локације састанака",
                },
                darknetNpcBuyerAliases = {
                    description = "Фиктивна имена додељена случајно новим захтевима за куповину НЦП-а. Конфигуришите најмање два јединствена алијаса.",
                    label = "Алијаси купца НЦП-а",
                },
                darknetNpcMaximumBuyListings = {
                    description = "Горња граница која се користи при случајном избору колико захтева за куповину од НЦП-а постаје активно.",
                    label = "Максимални захтеви за куповину од НЦП-а",
                },
                darknetNpcMaximumSellListings = {
                    description = "Горња граница коришћена при случајном избору колико понуда продаје НПК-ја постаје активно.",
                    label = "Максималне понуде продаје НПК-ја",
                },
                darknetNpcMinimumBuyListings = {
                    description = "Када се тржиште NPC-а попуни, остаће активним најмање овај број случајно изабраних захтева за куповину.",
                    label = "Минимални захтеви за куповину од NPC-а",
                },
                darknetNpcMinimumSellListings = {
                    description = "Када се тржиште НПК-а попуни, остаје активан најмање овај број случајно изабраних понуда за продају.",
                    label = "Минимални број НПК понуда за продају",
                },
                darknetNpcSellerAliases = {
                    description = "Фиктивна имена случајно додељена новим понудама продаје NPC-ја. Конфигуришите најмање два јединствена алијаса.",
                    label = "Алијаси продавца NPC-ја",
                },
                darknetNpcTraders = {
                    description = "Конфигурирајте синтетичке понуде, метод испоруке, репутацију и вероватноћу преваре.",
                    label = "NPC купци и продавци",
                },
                darknetPoliceGroups = {
                    description = "Кључеви групе који могу да објављују понуде за примамницу и прате истраге.",
                    label = "Одобрене групе полицијских послова",
                },
                darknetRenewalHours = {
                    description = "Сати који се додају када власник продужи понуду.",
                    label = "Трајање продужетка (сати)",
                },
                darknetScamChance = {
                    description = "Минимална вероватноћа да NPC узме плаћање или робу без испоруке повратне вредности. Већа вероватноћа за одређеног трговца и даље важи.",
                    label = "Глобална вероватноћа за измаму од NPC-а (%)",
                },
                darknetStarterBalance = {
                    description = "Крипто додељено само када играч први пут отвори тржиште.",
                    label = "Нови баланс новчаника",
                },
                darknetTabletOrder = {
                    description = "Контролише позицију Тамног тржишта на таблету.",
                    label = "Редослед таблет апликације",
                },
                darknetVerifiedMinimumRating = {
                    description = "Минимална просечна оцена за верификованог продавца.",
                    label = "Оцена потребна за верификацију",
                },
                darknetVerifiedMinimumSales = {
                    description = "Неопходне успешне продаје пре него што се продавац може верификовати.",
                    label = "Продаје потребне за верификацију",
                },
                drugAdvancedBusinessNetworkPaymentAccount = {
                    description = "Налог који се користи када је извор плаћања постављен на играчки налог. Плаћања организације увек користе налог из менија за шефа.",
                    label = "Играчки налог за плаћање",
                    options = {
                        bank = "Банка",
                        black_money = "Неопран новац",
                        money = "Кеш",
                    },
                    requiresWarning = "Користи се само са извором плаћања играчког налога.",
                },
                drugAdvancedBusinessNetworkPaymentSource = {
                    description = "Користи или баланс купујућег играча или организациони налог из менија за шефа.",
                    label = "Извор плаћања",
                    options = {
                        player = "Играчки налог",
                        society = "Организацијски налог",
                    },
                },
                drugCamperLockKey = {
                    description = "Поставља подразумевани тастер за закључавање и откључавање сопствених или фракцијски дељених кампера. Играчи могу да га пребришу у својим FiveM везама тастатура.",
                    label = "Кључ по подразумевано за закључавање кампера",
                    options = {
                        L = "L",
                        U = "U",
                        K = "K",
                        J = "J",
                        G = "G",
                        H = "H",
                        X = "Кс",
                        Y = "И",
                        F6 = "F6",
                        F7 = "F7",
                    },
                },
                drugCollectorInventoryMetadata = {
                    description = "Прикључи податке о квалитету и серији за излазе сакупљача по подразумевано. Онемогући ово да би се сирове материје нормално спаковале.",
                    label = "Метаподаци за предмете за сакупљање",
                },
                drugLabAssaultAlertDuration = {
                    description = "Секунде током којих је радиус аларма за одбрамбеника видљив на мапи.",
                    label = "Трајање аларма за одбрамбеника",
                },
                drugLabAssaultAlertRadius = {
                    description = "Радијус зоне напада приказане одбрамбеној фракцији на мапи.",
                    label = "Радијус аларма за одбрамбеника",
                },
                drugLabAssaultBreachRadius = {
                    description = "Радијус у којем нападач мора остати док се отвара улаз.",
                    label = "Радијус држања при пробијању",
                },
                drugLabAssaultCaptureDuration = {
                    description = "Секунде које нападачи морају да држе улаз без сукоба да би преузели лабораторију или кампер.",
                    label = "Трајање преузимања",
                },
                drugLabAssaultCaptureRadius = {
                    description = "Улазни простор који се користи за бројање нападача и бранилаца који се такмиче.",
                    label = "Радијус заузимања",
                },
                drugLabAssaultElectronicDuration = {
                    description = "Секунде потребне за хаковање улазног система.",
                    label = "Трајање електронског пробоја",
                },
                drugLabAssaultEnabled = {
                    description = "Омогућава фракцијама да пробију и преузму противничке лабораторије и кампере подељене са фракцијама.",
                    label = "Омогући преузимање лабораторије и кампера",
                },
                drugLabAssaultExplosiveDuration = {
                    description = "Секунде потребне за пробој улаза експлозивним набојем.",
                    label = "Трајање експлозивног пробоја",
                },
                drugLabAssaultInteractionDistance = {
                    description = "Максимална удаљеност од лабораторије или улаза у кампер када се покрене напад.",
                    label = "Удаљеност интеракције на улазу",
                },
                drugLabAssaultMechanicalDuration = {
                    description = "Секунде потребне за бушење улазног кључа.",
                    label = "Трајање механичког пробоја",
                },
                drugLabAssaultMinimumDefenders = {
                    description = "Онлајн чланови одбрамбене фракције потребни пре него што може да почне напад.",
                    label = "Минимални бранитељи",
                },
                drugLabAssaultRequireDuty = {
                    description = "Броји само чланове заштитничке фракције који су тренутно на служби.",
                    label = "Број само дежурних одбрамбеника",
                },
                drugProcessingInventoryMetadata = {
                    description = "Прикључује податке о квалитету и серији подразумевано на излазе обраде. Појединачне рецептуре могу да преисправе ову поставку.",
                    label = "Метаподаци предмета за обраду",
                },
                graffitiItemName = {
                    description = "Ставка из инвентара потребна за почетак прскања када је захтев за ставку омогућен. Ставка мора постојати у активном инвентару.",
                    label = "Потребна графити ставка",
                },
                heistCooldownMinutes = {
                    description = "Блокира исту пљачку након завршетка и чишћења покретања са стварним интеракцијама. Нула онемогућава време чекања. Непотрошен прозор за старт не покреће га.",
                    label = "Време чекања за пљачку (минута)",
                },
                heistCraftingMode = {
                    optionDescriptions = {
                        simple = "Traka napretka od pet sekundi. Potrebni sastojci se troše nakon uspešne izrade.",
                        medium = "Izaberi sastojke prikazanim redosledom i prođi jednu proveru tajminga po sastojku.",
                        advanced = "Potpuno sklapanje uređaja za recepte sa profilom uređaja; inače dve precizne provere tajminga po sastojku.",
                    },
                    description = "Једноставно: трака напредовања од пет секунди. Средње: избор састојака и провере времена. Максимално: пуна саставка уређаја; рецепти без профила уређаја користе две прецизне провере времена по састојаку.",
                    label = "Сложеност креирања",
                    options = {
                        advanced = "Максимална сложеност",
                        medium = "Средња сложеност",
                        simple = "Једноставно",
                    },
                },
                heistInactivityTimeoutMinutes = {
                    description = "Након прве интеракције, свака нова акција хеиста поново поставља овај тајмер. Истек завршава пролаз и брише његове објекте у свету. Примењује се на нове пролазе.",
                    label = "Лимит неактивности хеиста (минута)",
                },
                heistStartTimeoutMinutes = {
                    description = "Време након притискања на Почни за интеракцију на циљу. Без интеракције, покретање се поново поставља и може се покренути поново. Примењује се на нова покретања.",
                    label = "Минуте до прве интеракције са пљачком",
                },
                moneywashAccount = {
                    options = {
                        bank = "Банка",
                        black_money = "Неопран новац",
                        money = "Кеш",
                    },
                },
                moneywashDirtyAccount = {
                    description = "Налог из кога се одузима црни новац играча када почиње циклус прања.",
                    label = "Налог за депозит",
                },
                moneywashDrawDistance = {
                    description = "Максимална дистанца у метрима на којој се приказују улази у пословне објекте и продавнице.",
                    label = "Дистанција приказивања",
                },
                moneywashEnabled = {
                    description = "Чини пословнице за прање новца које поседују организације доступним.",
                    label = "Омогући прање новца",
                },
                moneywashFeePercent = {
                    description = "Проценат који се одузима од сваке партије пре исплате организацији.",
                    label = "Такса за услугу (%)",
                },
                moneywashInteractionDistance = {
                    description = "Максимална удаљеност у метрима за коришћење улаза у пословнице и продавница.",
                    label = "Дистанца интеракције",
                },
                npcPoliceAccuracy = {
                    description = "Тачност NPC официра од 0 до 100.",
                    label = "Тачност пуцања",
                },
                npcPoliceArmour = {
                    description = "Вредност оклопа сваког НПК полицајца од 0 до 100.",
                    label = "Телесни оклоп",
                },
                npcPoliceAtms = {
                    description = "Пошаљи помоћ NPC полиције када се активира аларм крађе банкомата.",
                    label = "Помоћ током крађе банкомата",
                },
                npcPoliceDurationSeconds = {
                    description = "Максимално време које NPC-ови полицајци проводе у распоређивању након спавна (30–900 секунди).",
                    label = "Трајање распоређивања (секунде)",
                },
                npcPoliceEnabled = {
                    description = "Диспачује наоружане НЦП полицијске службенике када се активира аларм о крађи. Дефолтно искључено.",
                    label = "Омогући подршку НЦП полиције",
                },
                npcPoliceHeists = {
                    description = "Пошаљи помоћ NPC полиције када се активира аларм за хеист.",
                    label = "Помоћ током хеистова",
                },
                npcPoliceOfficerCount = {
                    description = "Број наоружаних НПК полицајаца који се шаље по аларму о разбоју (1–8).",
                    label = "Број полицајаца по интервенцији",
                },
                npcPoliceResponseDelaySeconds = {
                    description = "Време између аларма о крађи и доласка НЦП-а полицијских службеника (0–300 секунди).",
                    label = "Касни одговор (секунде)",
                },
                npcPoliceShops = {
                    description = "Пошаљи НЦП полицијску помоћ када се активира аларм пљачке продавнице.",
                    label = "Помоћ током пљачки продавница",
                },
                npcPoliceSpawnDistance = {
                    description = "Циљана дистанца од локације крађе на којој се појављују NPC полицајци (15–150 метара).",
                    label = "Дистанца спавна (метри)",
                },
                npcPoliceWeapon = {
                    description = "Оружје којим је опремљен сваки НПК полицајац који реагује. Подразумевано је пиштољ.",
                    label = "Службено оружје",
                    options = {
                        WEAPON_CARBINERIFLE = "Карбински пушкарац",
                        WEAPON_PISTOL = "Пиштољ",
                        WEAPON_PUMPSHOTGUN = "Пумпна пушка",
                    },
                },
                openHeistCreator = {
                    buttonLabel = "Отвори Креатор хеиста",
                    description = "Отвори Креатора пљачке и затвори Конфигуратор посла.",
                    label = "Креатор хеиста",
                    unsavedTooltip = "Прво сачувај промене",
                },
                pickpocketAggressionChance = {
                    description = "Независна шанса да НПК нападне након неуспешног, отказаног или истеклог покушаја.",
                    label = "Шанса за контранапад (%)",
                },
                pickpocketAlertChance = {
                    description = "Независна шанса да НЦП пријави неуспешан, прекинут или истекли покушај.",
                    label = "Шанса за позив у помоћ (%)",
                },
                pickpocketDifficulty = {
                    description = "Контролише брзину курсора, брзину сужења циља, дужину секвенце и толерисане грешке.",
                    label = "Тешкоћа",
                    options = {
                        easy = "Леско",
                        expert = "Експерт",
                        hard = "Сложно",
                        normal = "Нормално",
                    },
                },
                pickpocketDispatchAlways = {
                    description = "Prijavi jednom svaki započeti pokušaj džeparenja, čak i uspešan, bez obzira na verovatnoću hitnog poziva.",
                    label = "Uvek pošalji dojavu",
                },
                pickpocketDispatchDurationSeconds = {
                    description = "Број секунди које извештај остаје релевантан за диспач потрошаче.",
                    label = "Трајање диспачинга",
                },
                pickpocketDispatchJobs = {
                    description = "Имења послова раздвојених запетом која примљују хитне позиве.",
                    label = "Послови диспачинга",
                },
                pickpocketDispatchPriority = {
                    description = "Приоритет који се преноси непромењено у диспачинг интеграцију.",
                    label = "Приоритет диспачинга",
                },
                pickpocketDispatchRadius = {
                    description = "Приближан радијус аларма послатог у диспачинг интеграцију.",
                    label = "Радијус диспачинг",
                },
                pickpocketEmptyChance = {
                    description = "Шанса да NPC носи уопште ниједан изабирив плен.",
                    label = "Шанса за празне џепове (%)",
                },
                pickpocketEnabled = {
                    description = "Омогућава играчима покушај пљачке џепова код квалификованих амбијенталних мрежних NPC-ја.",
                    label = "Омогући NPC пљачку џепова",
                },
                pickpocketFleeChance = {
                    description = "Независна шанса да НПК побегне након неуспешног, отказаног или истеклог покушаја.",
                    label = "Шанса за бежање НПК-а (%)",
                },
                pickpocketInteractionDistance = {
                    description = "Максимални опсег клијента; сервер валидира са малом маржином синхронизације.",
                    label = "Дистанца интеракције",
                },
                pickpocketItems = {
                    description = "Сваки ред контролише шансу да се појави. Поддржава се четири децимале за 0.0001 процената.",
                    itemLabel = "Шанса за предмет",
                    label = "Плен предмета",
                },
                pickpocketItemsEnabled = {
                    description = "Такође баца конфигурисане предмете у видљив садржај џепова.",
                    label = "Омогући пљачку предмета",
                },
                pickpocketMaximumLootChoices = {
                    description = "Највиши број серверски генерисаних слотова за новчаник или предмете приказаних за једног НПК-а.",
                    label = "Максимално видљива пљачка",
                },
                pickpocketMinigame = {
                    description = "Изабери један изазов или ротирај случајно између свих три.",
                    label = "Мини-игра",
                    options = {
                        pulse = "Импулс притиска",
                        random = "Случајна ротација",
                        sequence = "Секвенција правца",
                        timing = "Трака за време",
                    },
                },
                pickpocketMoneyMaximum = {
                    description = "Највиши видљиви износ готовине; аутоматски се држи на или изнад минимума.",
                    label = "Максимални износ готовине",
                },
                pickpocketMoneyMinimum = {
                    description = "Најнижа серверски генерисана износ за видљиви слот за новчаник.",
                    label = "Минималан новац",
                },
                pickpocketRequestCooldownSeconds = {
                    description = "Минимални број секунди између почетних захтева од једног играча.",
                    label = "Време чекања захтева",
                },
                pickpocketRequireCrimeJob = {
                    description = "Омогућено: додаје акцију само регистрованим пословима система криминал. Онемогућено: уклада уграђену радијалну акцију и захтева извоз сервера.",
                    label = "Користи радијал за криминалне послове",
                },
                pickpocketRequiredHits = {
                    description = "Базна вредност за све минигеме. Вредно новчано богатство га повећава корак по корак; екстремно ретке предмете захтевају најмање осам погодака.",
                    label = "Минималан број погодака",
                },
                pickpocketSessionTimeoutSeconds = {
                    description = "Секунде пре истека непотпуног серверског изазова.",
                    label = "Трајање сесије",
                },
                pickpocketTargetCooldownMinutes = {
                    description = "Блокирање након отказаних или неуспешних покушаја; успешно празњени НПК-и остају блокирани.",
                    label = "Време чекања НПК-а",
                },
                pvpAdminAce = {
                    description = "ACE објекат који омогућава приступ управљању глобалним PvP догађајима.",
                    label = "ACE администратора",
                },
                pvpArenaReturnSeconds = {
                    description = "Стандардно време повратка за нова догађања. Вође догађаја могу то преписати у таблети.",
                    label = "Време повратка у арену",
                },
                pvpArenaWarningPosition = {
                    description = "Контролише где се појављује упозорење за повратак у арену.",
                    label = "Позиција упозорења арене",
                    options = {
                        bottom_center = "Доле центар",
                        bottom_left = "Доле лево",
                        bottom_right = "Доле десно",
                        middle_center = "Центар екрана",
                        middle_left = "Средина лево",
                        middle_right = "Средина десно",
                        top_center = "Горе центар",
                        top_left = "Горе лево",
                        top_right = "Горе десно",
                    },
                },
                pvpArenas = {
                    description = "Створи кругле зоне за борбу са тачком за посматрање и најмање две тачке за појаву екипа.",
                    itemLabel = "Арена",
                    label = "PvP арене",
                },
                pvpCountdownPosition = {
                    description = "Контролише где се приказује обрат бројања почетка.",
                    label = "Позиција обрат бројања",
                    options = {
                        bottom_center = "Доле центар",
                        bottom_left = "Доле лево",
                        bottom_right = "Доле десно",
                        middle_center = "Центар екрана",
                        middle_left = "Средина лево",
                        middle_right = "Средина десно",
                        top_center = "Горе центар",
                        top_left = "Горе лево",
                        top_right = "Горе десно",
                    },
                },
                pvpDefaultMode = {
                    description = "Режим игре преизабран за нова догађања.",
                    label = "Подразумевани режим игре",
                    options = {
                        free_for_all = "Свако против свакога",
                        last_man_standing = "Последњи човек у стајању",
                        team_deathmatch = "Тимска смртна борба",
                    },
                },
                pvpDefaultScoreLimit = {
                    description = "Подразумеван број убистава потребан за победу у Team Deathmatch или Free For All.",
                    label = "Подразумеван лимит убистава",
                },
                pvpEventsEnabled = {
                    description = "Чини апликацију за таблет за PvP фракција и време рада догађаја доступним.",
                    label = "Омогући догађаје PvP фракција",
                },
                pvpKillfeedPosition = {
                    description = "Контролише где се приказују недавне елиминације.",
                    label = "Позиција килфид-а",
                    options = {
                        bottom_center = "Доле центар",
                        bottom_left = "Доле лево",
                        bottom_right = "Доле десно",
                        middle_center = "Центар екрана",
                        middle_left = "Средина лево",
                        middle_right = "Средина десно",
                        top_center = "Горе центар",
                        top_left = "Горе лево",
                        top_right = "Горе десно",
                    },
                },
                pvpLeaderPermission = {
                    description = "Потребно овлашћење за посао за креирање, регистрацију, покретање и управљање догађајима фракције.",
                    label = "Овлашћење вође фракције",
                },
                pvpMatchDurationMinutes = {
                    description = "Подразумевано трајање у минутима за нова догађања. Нула деактивира временски лимит.",
                    label = "Трајање меча",
                },
                pvpMaxHistory = {
                    description = "Максималан број завршених или отказаних догађаја враћених на таблет.",
                    label = "Видљива историја догађаја",
                },
                pvpMaxRewards = {
                    description = "Максималан број комбинација предмета, наоружања, возила или новчаних награда по догађају.",
                    label = "Максималне додатне награде",
                },
                pvpMoneyPermission = {
                    description = "Одобравање за посао потребно за улазне трошкове и наградни новац.",
                    label = "Одобравање за финансије фракције",
                },
                pvpRequestCooldownMs = {
                    description = "Минимални милисекунди између мутације PvP захтева од једног играча.",
                    label = "Хладноће акције",
                },
                pvpRespawnDelaySeconds = {
                    description = "Секунда пре него што играч поново постане активан или се пресели у подручје посматрача након смрти.",
                    label = "Касније појављивање",
                },
                pvpSchedulePollSeconds = {
                    description = "Секунде између понављајућих шаблони и аутоматских провера покретања.",
                    label = "Интервал провере распореда",
                },
                pvpScoreboardPosition = {
                    description = "Контролише где се приказује компактна жива табла резултата током такмичења фракција.",
                    label = "Позиција табле резултата",
                    options = {
                        bottom_center = "Доле центар",
                        bottom_left = "Доле лево",
                        bottom_right = "Доле десно",
                        middle_center = "Центар екрана",
                        middle_left = "Средина лево",
                        middle_right = "Средина десно",
                        top_center = "Горе центар",
                        top_left = "Горе лево",
                        top_right = "Горе десно",
                    },
                },
                pvpSoloTestingEnabled = {
                    description = "Омогућава PvP администраторима регистрацију и ручни почетак са једним чланом фракције. Искључите ово на продуктивним серверима.",
                    label = "Омогући соло тестирање администратора",
                },
                pvpStartCountdownSeconds = {
                    description = "Стандартни обратни бројач за ново креиране догађаје. Вођа догађаја може да га преисправи у таблети.",
                    label = "Покрени обратни бројач",
                },
                pvpTabletOrder = {
                    description = "Контролише где се приказује апликација фракције PvP на таблету.",
                    label = "Редослед таблет апликације",
                },
                shopActiveTimeoutMinutes = {
                    description = "Минута пре него што напуштени пљачкашки напад пропасте.",
                    label = "Активно време за истек",
                },
                shopConsumeDrill = {
                    description = "Потроши бушилицу након успешног отварања.",
                    label = "Потроши бушилицу",
                },
                shopConsumeHackItem = {
                    description = "Потроши хакерски предмет након успешног отварања сефа.",
                    label = "Потроши хакерски предмет",
                },
                shopCooldownMinutes = {
                    description = "Минуте у времену рада пре поновног постављања продавнице.",
                    label = "Време чекања продавнице",
                },
                shopDispatchAlways = {
                    description = "Prijavi jednom svaku pljačku prodavnice na početku, uključujući neprekidno zastrašivanje i prodavnice bez obaveznog prodavca.",
                    label = "Uvek pošalji dojavu",
                },
                shopDispatchDurationSeconds = {
                    description = "Секунде током којих аларм остаје релевантан.",
                    label = "Трајање диспачинга",
                },
                shopDispatchJobs = {
                    description = "Пословне улоге прималаца аларма, раздвојене запетом.",
                    label = "Послови диспачинга",
                },
                shopDispatchPriority = {
                    description = "Приоритет пренет диспачу.",
                    label = "Приоритет диспачинга",
                },
                shopDispatchRadius = {
                    description = "Приближан радијус полицијског аларма.",
                    label = "Радијус диспачинг",
                },
                shopDrillDurationSeconds = {
                    description = "Секунде потребне за бушење сефа.",
                    label = "Трајање бушења сефа",
                },
                shopDrillItem = {
                    description = "ID предмета у инвентару потребног за бушење сефова у продавницама. Подешава се одвојено од бушилице за банкомате.",
                    label = "Предмет за бушење",
                },
                shopDrillItemAmount = {
                    description = "Број ставки бушилица потребних.",
                    label = "Потребан износ бушења",
                },
                shopEnabled = {
                    description = "Омогућава крађе у продавницама које су конфигурисане као оне са особљем.",
                    label = "Омогући крађе у продавницама",
                },
                shopHackItem = {
                    description = "Предмет потребан за минигему за хаковање касета. Омогућите метод отварања посебно за сваку продавницу.",
                    label = "Предмет за хаковање",
                },
                shopHackItemAmount = {
                    description = "Потребна количина хакерског предмета.",
                    label = "Количина хакерског предмета",
                },
                shopIntimidationSeconds = {
                    description = "Број секунди које продавац мора да проведе под претњом.",
                    label = "Трајање уплашивања",
                },
                shopLocations = {
                    description = "Један запослени, једна каса и опциони сеф по продавници.",
                    itemLabel = "Трговина",
                    label = "Локације продавница",
                },
                shopMinimumPolice = {
                    description = "Потребни чланови полицијске групе који су на служби.",
                    label = "Минимална полиција",
                },
                shopPoliceGroup = {
                    description = "Група послова која се броји за захтев полиције.",
                    label = "Група послова полиције",
                },
                shopRegisterDurationSeconds = {
                    description = "Секунде потребне за празњење касе.",
                    label = "Трајање ограбљивања касе",
                },
                shopRegisterRewardMaximum = {
                    description = "Највиши износ исплате из касе.",
                    label = "Максимална награда касе",
                },
                shopRegisterRewardMinimum = {
                    description = "Најнижа исплата за касу.",
                    label = "Минимална награда за касу",
                },
                shopRegisterRewardName = {
                    description = "Опционо име предмета или рачуна.",
                    label = "Име награде за касу",
                },
                shopRegisterRewardSort = {
                    description = "Изаберите готовину или предмет black_money.",
                    label = "Врста исплате регистра",
                },
                shopRegisters = {
                    description = "Позиције касе додељене према ИД продавнице.",
                    itemLabel = "Каса",
                    label = "Касне",
                },
                shopSafeLootDurationSeconds = {
                    description = "Секунде потребне за узимање новца након уноса ваљаног кода за безбедносни шкаф.",
                    label = "Трајање пљачке безбедносног шкафа",
                },
                shopSafeRewardMaximum = {
                    description = "Највећа исплата из сефа.",
                    label = "Максимална награда из сефа",
                },
                shopSafeRewardMinimum = {
                    description = "Најнижа исплата из сефа.",
                    label = "Минимална награда из сефа",
                },
                shopSafeRewardName = {
                    description = "Опционо име предмета или рачуна.",
                    label = "Име награде за сеф",
                },
                shopSafeRewardSort = {
                    description = "Изаберите готовину или предмет black_money.",
                    label = "Врста исплате сефа",
                },
                shopThreatGraceSeconds = {
                    description = "Дозвољено прекидање пре аларма.",
                    label = "Период толеранције за циљање",
                },
                territoryDrugSalesEnabled = {
                    description = "Успешне продаје на улици од стране NPC-ја додељују утицај групи продавца у тренутној територији улице.",
                    label = "Продаја од стране NPC-ја додељује утицај територије",
                },
                atmLocationMode = {
                    label = "Režim lokacija bankomata",
                    description = "Automatski otkriva podržane objekte u svetu ili koristi samo ručno podešene lokacije.",
                    options = {
                        automatic = "Automatski",
                        manual = "Ručno",
                    },
                },
                atmPoliceRequirementEnabled = {
                    label = "Zahtevaj policajce na dužnosti",
                    description = "Zahteva podešen broj policajaca na dužnosti pre početka pljačke bankomata.",
                },
                openDrugCreator = {
                    label = "Uređivač droge",
                    description = "Otvara Sky Crime uređivač droge i zatvara konfigurator poslova.",
                    buttonLabel = "Otvori uređivač droge",
                    unsavedTooltip = "Prvo sačuvaj",
                },
                drugCreatorRuntimeDensity = {
                    label = "Gustina operativnog panela",
                    description = "Određuje zbijenost operativnog panela u uređivaču droge.",
                    options = {
                        comfortable = "Удобан",
                        compact = "Цомпацт",
                    },
                },
                drugCreatorListDensity = {
                    label = "Gustina liste",
                    description = "Određuje zbijenost liste unosa u uređivaču.",
                    options = {
                        comfortable = "Удобан",
                        compact = "Цомпацт",
                    },
                },
                drugCreatorShowEmptyRuntimeLists = {
                    label = "Prikaži prazne operativne liste",
                    description = "Prikazuje odeljke operativnog panela čak i bez unosa.",
                },
                drugCreatorHideDisabledEntries = {
                    label = "Sakrij isključene unose",
                    description = "Sakriva isključene unose modula na listi uređivača droge.",
                },
                drugCreatorAutoGenerateId = {
                    label = "Automatski generiši ID",
                    description = "Generiše ID oznake iz naziva pri kreiranju novih unosa u uređivaču droge.",
                },
                drugCreatorOpenEditorOnModuleChange = {
                    label = "Otvori uređivač pri promeni modula",
                    description = "Automatski otvara uređivač pri promeni aktivnog modula.",
                },
                drugCreatorSmartDuplicateSuffix = {
                    label = "Automatski sufiks kopija",
                    description = "Dodaje automatski sufiks pri dupliranju unosa u uređivaču droge.",
                },
                drugCreatorAutoSelectRuntimeTargets = {
                    label = "Automatski izaberi ciljeve u igri",
                    description = "Automatski unapred bira dostupne laboratorije i serije.",
                },
                drugCreatorAttentionOnOpen = {
                    label = "Prikaži probleme pri otvaranju",
                    description = "Otvara operativni panel sa fokusom na unose kojima je potrebna pažnja.",
                },
                drugActivityHudPosition = {
                    label = "Положај HUD-а активности",
                    description = "Превуците HUD за постављање и бербу на жељени положај екрана.",
                },
                drugInteractionHudPosition = {
                    label = "Положај HUD-а интеракције",
                    description = "Превуците HUD за интеракцију са биљкама, лабораторијама и камперима на жељени положај.",
                },
                drugPlantStatusHudPosition = {
                    label = "Положај HUD-а стања биљке",
                    description = "Превуците детаљни HUD стања биљке на жељени положај екрана.",
                },
                drugSystemEnabled = {
                    label = "Sistem droge",
                    description = "Omogućava: proizvodnja droge, podaci uređivača i interfejsi igre za ovaj kriminalni posao.",
                },
                drugCreatorAccess = {
                    label = "Pristup uređivaču droge",
                    description = "Određuje ko sme otvoriti napredni uređivač droge.",
                    options = {
                        permission = "Samo uz dozvolu",
                        job_management = "Upravljanje poslom",
                        owner_only = "Samo vlasnik",
                    },
                },
                drugRuntimeEnabled = {
                    label = "Operativni interfejsi",
                    description = "Dozvoljava igračima korišćenje akcija laboratorije, biljaka, prerade i tržišta u igri.",
                },
                drugRuntimePlayerCreateLabs = {
                    label = "Kreiranje laboratorija od strane igrača",
                    description = "Dozvoljava igračima sa pristupom sistemu da prave laboratorije iz šablona uređivača bez administratorskih prava.",
                },
                drugRuntimeOutdoorPlanting = {
                    label = "Uzgoj na otvorenom",
                    description = "Dozvoljava igračima sopstveni uzgoj napolju van podešenih laboratorija.",
                },
                drugRuntimePublicOutdoorHarvest = {
                    label = "Žetva na otvorenom od strane drugih igrača",
                    description = "Dozvoljava drugim igračima da beru biljke napolju koje nisu sami posadili.",
                },
                drugRuntimeChargeLabPurchase = {
                    label = "Naplati kupovinu laboratorije",
                    description = "Naplaćuje igračima podešenu cenu pri kreiranju laboratorije.",
                },
                drugRuntimeStrictInventory = {
                    label = "Strogo proveravaj inventar",
                    description = "Radnje se nastavljaju samo ako podešene operacije sa predmetima, alatima i novcem uspeju.",
                },
                drugRuntimeSalePayouts = {
                    label = "Prodaja / Isplate",
                    description = "Isplaćuje igrače kada se serije ili rute prodaju preko tržišnog sistema.",
                },
                drugRuntimeSalePayoutAccount = {
                    label = "Износ исплате / Налог",
                    description = "Račun za isplate od prodaje droge, na primer black_money.",
                },
                drugRuntimeDispatchEnabled = {
                    label = "Отпремање / Uzbune",
                    description = "Prosleđuje događaje rizika od droge dispečeru i podešenim policijskim poslovima.",
                },
                drugRuntimeNotifyPoliceJobs = {
                    label = "Policija / Обавештења",
                    description = "Obaveštava podešene policijske poslove kada događaj rizika od droge izazove uzbunu.",
                },
                drugBatchPrefix = {
                    label = "Серија / Prefiks",
                    description = "Prefiks ID oznaka novih serija droge.",
                },
                drugTestingKitAccuracy = {
                    label = "Тестирачки сет / Тачност",
                    description = "Dozvoljeno odstupanje skrivenih vrednosti osnovnog kompleta za testiranje.",
                },
                drugDecayIntervalMinutes = {
                    label = "Отуђење / Interval",
                    description = "Interval u minutima za: provere opadanja svežine i kontaminacije.",
                },
                drugDefaultPackaging = {
                    label = "Podrazumevana vrednost / Упаковка",
                    description = "Pakovanje sirovih ili obrađenih serija napravljenih bez izričitog tipa pakovanja.",
                    options = {
                        loose = "Слабо спаковано",
                        baggy = "Kesica",
                        jar = "Tegla",
                        vacuum = "Vakuumska kesa",
                        brick = "Omot bloka",
                        premium_seal = "Vrhunsko zaptivanje",
                    },
                },
                drugQualityWeightQuality = {
                    label = "Квалитет / Тежина",
                    description = "Uticaj na konačni kvalitet: Osnovni kvalitet.",
                },
                drugQualityWeightPurity = {
                    label = "Чистота / Тежина",
                    description = "Uticaj na konačni kvalitet: Чистота.",
                },
                drugQualityWeightFreshness = {
                    label = "Свежина / Тежина",
                    description = "Uticaj na konačni kvalitet: Свежина.",
                },
                drugQualityWeightPotency = {
                    label = "Ефикасност / Тежина",
                    description = "Uticaj na konačni kvalitet: Ефикасност.",
                },
                drugQualityWeightStability = {
                    label = "Стабилност / Тежина",
                    description = "Uticaj na konačni kvalitet: Стабилност.",
                },
                drugQualityWeightContamination = {
                    label = "Контаминација / Kazna",
                    description = "Umanjenje ocene kvaliteta kontaminiranih proizvoda.",
                },
                drugTierGoodMin = {
                    label = "Добро / Ниво / Minimum",
                    description = "Minimalni rezultat za nivo kvaliteta: Добро.",
                },
                drugTierPremiumMin = {
                    label = "Премиум / Ниво / Minimum",
                    description = "Minimalni rezultat za nivo kvaliteta: Премиум.",
                },
                drugTierTopShelfMin = {
                    label = "Najviši kvalitet / Ниво / Minimum",
                    description = "Minimalni rezultat za nivo kvaliteta: Najviši kvalitet.",
                },
                drugTierLabGradeMin = {
                    label = "Laboratorijski kvalitet / Ниво / Minimum",
                    description = "Minimalni rezultat za nivo kvaliteta: Laboratorijski kvalitet.",
                },
                drugBaggyDecayMultiplier = {
                    label = "Kesica / Отуђење",
                    description = "Množilac za: gubitak svežine / Kesice.",
                },
                drugJarDecayMultiplier = {
                    label = "Tegla / Отуђење",
                    description = "Množilac za: gubitak svežine / Tegle.",
                },
                drugVacuumDecayMultiplier = {
                    label = "Vakuum / Отуђење",
                    description = "Množilac za: gubitak svežine / Vakuumske kese.",
                },
                drugPremiumSealPriceMultiplier = {
                    label = "Vrhunsko zaptivanje / Цена",
                    description = "Množilac za: Премиум / Zapečaćen proizvod / Цена.",
                },
                drugGrowingEnabled = {
                    label = "Uzgoj / Омогућено",
                    description = "Omogućava: rast biljaka i žetva.",
                },
                drugEnvironmentSurveyEnabled = {
                    label = "Провера места садње",
                    description = "Када је укључена, слободно посађене биљке чекају аутоматску проверу места од стране администратора. Искључите за раст без одобрења администратора.",
                },
                drugGrowthTickMinutes = {
                    label = "Раст / Ciklus ažuriranja / Minuti",
                    description = "Interval u minutima za: ažuriranja rasta biljaka.",
                },
                drugBaseGrowthPerTick = {
                    label = "Osnovna vrednost / Раст / Po ciklusu ažuriranja",
                    description = "Osnovni rast pre uticaja sorte, opreme i nege.",
                },
                drugWildPlantRespawnMinutes = {
                    label = "Дивља биљка / Ponovno pojavljivanje",
                    description = "Čekanje u minutima do: Дивља биљка / Ponovno pojavljivanje.",
                },
                drugWildPlantHighlightEnabled = {
                    label = "Istakni divlje biljke",
                    description = "Prikazuje obris stvorenih divljih biljaka kada igrač uđe u poluprečnik isticanja.",
                },
                drugWildPlantHighlightDistance = {
                    label = "Poluprečnik isticanja divljih biljaka",
                    description = "Udaljenost u metrima oko svake stvorene divlje biljke unutar koje njen obris postaje vidljiv.",
                },
                drugDefaultPlantWater = {
                    label = "Podrazumevana vrednost / Вода",
                    description = "Početna vrednost pri stvaranju biljke: Вода.",
                },
                drugDefaultPlantFertilizer = {
                    label = "Podrazumevana vrednost / Угњетило",
                    description = "Početna vrednost pri stvaranju biljke: Угњетило.",
                },
                drugDefaultPlantHealth = {
                    label = "Podrazumevana vrednost / Здравље",
                    description = "Početna vrednost pri stvaranju biljke: Здравље.",
                },
                drugDefaultPlantMutationChance = {
                    label = "Podrazumevana vrednost / Шанса за мутацију",
                    description = "Osnovna verovatnoća mutacije ako sorta nema sopstvenu vrednost.",
                },
                drugHarvestPerfectStart = {
                    label = "Početak optimalne žetve",
                    description = "Procenat rasta za optimalni period žetve: Početak.",
                },
                drugHarvestPerfectEnd = {
                    label = "Kraj optimalne žetve",
                    description = "Procenat rasta za optimalni period žetve: Kraj.",
                },
                drugLabsEnabled = {
                    label = "Лабораторије / Омогућено",
                    description = "Omogućava: laboratorije i kamperi u igri.",
                },
                drugMaxLaboratoriesPerCharacter = {
                    label = "Laboratorije po liku",
                    description = "Maksimalan broj kupljenih ili iznajmljenih stalnih laboratorija po vlasniku. 0 znači neograničeno; kamperi i zajednički pristup se ne računaju.",
                },
                drugMaxLaboratoriesPerFaction = {
                    label = "Laboratorije po frakciji",
                    description = "Maksimalan broj kupljenih ili iznajmljenih stalnih laboratorija po vlasniku. 0 znači neograničeno; kamperi i zajednički pristup se ne računaju.",
                },
                drugDefaultRentDays = {
                    label = "Podrazumevana vrednost / Дневи закупштине",
                    description = "Podrazumevana vrednost za: Лабораторија / Камија / Трајање.",
                },
                drugCamperHotVehicleMinutes = {
                    label = "Ukradeni kamper / Minuti",
                    description = "Vreme tokom kog ukradeni kamperi imaju povećan rizik.",
                },
                drugLabRentWarningHours = {
                    label = "Камија / Упозорење / Sati",
                    description = "Broj sati pre isteka zakupa laboratorije kada se prikazuje upozorenje.",
                },
                drugLabRentExpiredHeatGain = {
                    label = "Istekao zakup / Policijski pritisak",
                    description = "Dodatna pažnja policije kada istekne zakup laboratorije.",
                },
                drugCamperMoveCooldownMinutes = {
                    label = "Кампер / Премести / Време чекања",
                    description = "Čekanje u minutima do: Кампер / Лабораторија / Ponovno premeštanje.",
                },
                drugLabUpgradeCostMultiplier = {
                    label = "Unapređenje / Cena / Množilac",
                    description = "Množilac za: Лабораторија / Ниво / Unapređenje / Cene.",
                },
                drugCamperBaseSlots = {
                    label = "Кампер / Слотови",
                    description = "Podrazumevana vrednost za: laboratorije u kamperima / mesta za opremu.",
                },
                drugCamperBaseStorage = {
                    label = "Кампер / Складиште",
                    description = "Podrazumevana vrednost za: laboratorije u kamperima / Капацитет складишта.",
                },
                drugCamperBasePower = {
                    label = "Кампер / Електрична енергија",
                    description = "Podrazumevana vrednost za: laboratorije u kamperima / Ugrađeno napajanje.",
                },
                drugBasementBaseSlots = {
                    label = "Подземна лабораторија / Слотови",
                    description = "Podrazumevana vrednost za: podrumske laboratorije / mesta za opremu.",
                },
                drugBasementBaseStorage = {
                    label = "Подземна лабораторија / Складиште",
                    description = "Podrazumevana vrednost za: podrumske laboratorije / Капацитет складишта.",
                },
                drugWarehouseBasePower = {
                    label = "Складиште / Електрична енергија",
                    description = "Podrazumevana vrednost za: magacinske laboratorije / Ugrađeno napajanje.",
                },
                drugPowerEnabled = {
                    label = "Електрична енергија / Систем",
                    description = "Omogućava: proizvodnja struje, potrošnja i provere preopterećenja laboratorije.",
                },
                drugOverloadGraceSeconds = {
                    label = "Preopterećenje / Period tolerancije",
                    description = "Broj sekundi pre nego što preopterećenje struje postane opasno.",
                },
                drugHeatPerKilowatt = {
                    label = "Policijski pritisak / Po kilovatu",
                    description = "Pažnja policije prema laboratoriji zbog potrošnje struje.",
                },
                drugGeneratorT1Watts = {
                    label = "Генератор T1 / Ват",
                    description = "Snaga generatora nivoa T1 u vatima.",
                },
                drugGeneratorT2Watts = {
                    label = "Генератор T2 / Ват",
                    description = "Snaga generatora nivoa T2 u vatima.",
                },
                drugGeneratorT3Watts = {
                    label = "Генератор T3 / Ват",
                    description = "Snaga generatora nivoa T3 u vatima.",
                },
                drugEquipmentConditionWearMultiplier = {
                    label = "Истрошеност / Množilac",
                    description = "Globalni množilac za: Исушивање опреме / Обрада.",
                },
                drugWorkersEnabled = {
                    label = "Запослени / Омогућено",
                    description = "Omogućava: hemičari, uzgajivači, pakovači i obezbeđenje u laboratorijama droge.",
                },
                drugMaxWorkersPerLab = {
                    label = "Maksimum / Запослени / Лабораторија",
                    description = "Najveći broj radnika po laboratoriji.",
                },
                drugWorkerFatiguePerProcessStep = {
                    label = "Umor od obrade",
                    description = "Dodatni umor za: Запослени, nakon rada: Korak obrade.",
                },
                drugWorkerFatiguePerGrowAction = {
                    label = "Uzgoj / Исцрпљеност",
                    description = "Dodatni umor za: Uzgajivači, nakon rada: Žetva ili uzgoj.",
                },
                drugWorkerRecoveryPerTick = {
                    label = "Запослени / Oporavak",
                    description = "Oporavak — Исцрпљеност, pri svakom koraku: Ažuriranje rasta.",
                },
                drugMarketEnabled = {
                    label = "Tržište / Омогућено",
                    description = "Omogućava: kupci, dileri i prodaja serija.",
                },
                drugMarketBasePriceFallback = {
                    label = "Zamenska vrednost / Базна цена",
                    description = "Osnovna cena droge bez posebno podešene cene.",
                },
                drugMarketStreetMultiplier = {
                    label = "Улица / Množilac",
                    description = "Globalni množilac za: Цена / Улична продаја.",
                },
                drugMarketWholesaleMultiplier = {
                    label = "Велико продавање / Množilac",
                    description = "Globalni množilac za: Цена / Велико продавање / Poslovi.",
                },
                drugMarketPremiumMultiplier = {
                    label = "Премиум / Množilac",
                    description = "Globalni množilac za: Цена / Премиум / Купци.",
                },
                drugMarketHeatPerSale = {
                    label = "Policijski pritisak / Prodaja",
                    description = "Osnovni policijski pritisak dodat laboratoriji pri prodaji serije.",
                },
                drugDistributionTickMinutes = {
                    label = "Дистрибуција / Ciklus ažuriranja",
                    description = "Interval u minutima za: ažuriranja distribucije dilera.",
                },
                drugDistributionIntervalMinutes = {
                    label = "Дистрибуција / Interval",
                    description = "Podrazumevana vrednost za: Дилер / Čekanje pre prodaje / Minuti.",
                },
                drugDistributionMaxPerDealer = {
                    label = "Maksimum / Дилер / Наручбе",
                    description = "Podrazumevana vrednost za: Дилер / najveći broj aktivnih naloga distribucije.",
                },
                drugThreatsEnabled = {
                    label = "Претње / Омогућено",
                    description = "Omogućava: smanjenje pažnje policije, racije i sabotaže u laboratorijama.",
                },
                drugThreatTickMinutes = {
                    label = "Pretnja / Ciklus ažuriranja",
                    description = "Interval u minutima za: smanjenje pažnje policije i provere racija i sabotaža.",
                },
                drugRaidHeatThreshold = {
                    label = "Prag pažnje policije za racije",
                    description = "Potreban policijski pritisak u laboratoriji pre pokretanja: Насилни упади.",
                },
                drugSabotageHeatThreshold = {
                    label = "Prag pažnje policije za sabotažu",
                    description = "Potreban policijski pritisak u laboratoriji pre pokretanja: Sabotaža.",
                },
                drugThreatHeatDecay = {
                    label = "Policijski pritisak / Отуђење",
                    description = "Smanjuje pažnju policije prema laboratoriji za ovu vrednost pri svakom ažuriranju pretnji.",
                },
                drugRaidChanceAtThreshold = {
                    label = "Šansa racije",
                    description = "Osnovna verovatnoća za Napad nakon dostizanja odgovarajućeg praga policijskog pritiska.",
                },
                drugSabotageChanceAtThreshold = {
                    label = "Sabotaža / Могућа",
                    description = "Osnovna verovatnoća za Sabotaža nakon dostizanja odgovarajućeg praga policijskog pritiska.",
                },
                drugConsumptionEnabled = {
                    label = "Конзумирање омогућено",
                    description = "Omogućava: efekti droge i praćenje tolerancije i zavisnosti.",
                },
                drugDoseConsumesBatch = {
                    label = "Potroši seriju pri konzumaciji",
                    description = "Uklanja potrošenu seriju iz aktivnih zaliha.",
                },
                drugToleranceDecayMinutes = {
                    label = "Толеранција / Отуђење",
                    description = "Interval u minutima za: ažuriranja smanjenja tolerancije.",
                },
                drugAddictionDecayMinutes = {
                    label = "Зависност / Отуђење",
                    description = "Interval u minutima za: ažuriranja smanjenja zavisnosti.",
                },
                drugPotencyEffectMultiplier = {
                    label = "Ефикасност / Množilac",
                    description = "Određuje koliko potentnost povećava intenzitet efekata.",
                },
                drugOverdosePotencyThreshold = {
                    label = "Predoziranje / Prag",
                    description = "Potrebno opterećenje supstancom pre provere mogućnosti predoziranja.",
                },
                drugBaseAddictionGain = {
                    label = "Osnovna vrednost / Зависност / принос",
                    description = "Osnovni porast zavisnosti po dozi.",
                },
                drugProcessingEnabled = {
                    label = "Обрада / Омогућено",
                    description = "Omogućava: poslovi obrade, pakovanje i kompleti za testiranje.",
                },
                drugBatchMetadataItemKey = {
                    label = "Серија / Metapodaci / Кључ",
                    description = "Ključ metapodataka inventara koji integracije koriste za podatke o serijama.",
                },
                drugDefaultProcessDuration = {
                    label = "Podrazumevano vreme obrade",
                    description = "Podrazumevana vrednost za: Обрада / Трајање / секунд / Bez posebne vrednosti recepta.",
                },
                drugDefaultFailureRisk = {
                    label = "Podrazumevana vrednost / Ризик од неуспеха",
                    description = "Podrazumevana vrednost za: Обрада / Ризик од неуспеха / Bez posebne vrednosti recepta.",
                },
                drugPackagingDuration = {
                    label = "Vreme pakovanja",
                    description = "Podrazumevana vrednost za: Упаковка / Трајање / секунд.",
                },
                drugPowerTickSeconds = {
                    label = "Електрична енергија / Ciklus ažuriranja / секунд",
                    description = "Interval u sekundama za: ažuriranje potrošnje generatora i energetskih tragova.",
                },
                drugPowerSignatureHeatPerHour = {
                    label = "Energetski trag / Policijski pritisak / Sat",
                    description = "Pažnja policije po satu zbog energetskog traga laboratorije.",
                },
                drugPowerOverloadHeatPerHour = {
                    label = "Preopterećenje / Policijski pritisak / Sat",
                    description = "Dodatni policijski pritisak po satu dok je laboratorija preopterećena.",
                },
                drugPowerIdleHeatDecayPerHour = {
                    label = "Idle / Policijski pritisak / Отуђење / Sat",
                    description = "Smanjenje pažnje policije po satu dok laboratorija nema aktivan energetski trag.",
                },
                drugPowerModeManualMaxLoadPercent = {
                    label = "Ручно / Maksimum / Opterećenje",
                    description = "Vrednost za energetski režim Ручно: Maksimum / Opterećenje.",
                },
                drugPowerModeManualHeatMultiplier = {
                    label = "Ручно / Policijski pritisak / Množilac",
                    description = "Vrednost za energetski režim Ручно: Policijski pritisak / Množilac.",
                },
                drugPowerModeManualNoiseMultiplier = {
                    label = "Ручно / Бука / Množilac",
                    description = "Vrednost za energetski režim Ручно: Бука / Množilac.",
                },
                drugPowerModeBalancedMaxLoadPercent = {
                    label = "Избалансирано / Maksimum / Opterećenje",
                    description = "Vrednost za energetski režim Избалансирано: Maksimum / Opterećenje.",
                },
                drugPowerModeBalancedHeatMultiplier = {
                    label = "Избалансирано / Policijski pritisak / Množilac",
                    description = "Vrednost za energetski režim Избалансирано: Policijski pritisak / Množilac.",
                },
                drugPowerModeBalancedNoiseMultiplier = {
                    label = "Избалансирано / Бука / Množilac",
                    description = "Vrednost za energetski režim Избалансирано: Бука / Množilac.",
                },
                drugPowerModeStealthMaxLoadPercent = {
                    label = "Скривено / Maksimum / Opterećenje",
                    description = "Vrednost za energetski režim Скривено: Maksimum / Opterećenje.",
                },
                drugPowerModeStealthHeatMultiplier = {
                    label = "Скривено / Policijski pritisak / Množilac",
                    description = "Vrednost za energetski režim Скривено: Policijski pritisak / Množilac.",
                },
                drugPowerModeStealthNoiseMultiplier = {
                    label = "Скривено / Бука / Množilac",
                    description = "Vrednost za energetski režim Скривено: Бука / Množilac.",
                },
                drugPowerPrioritySmellControl = {
                    label = "Kontrola mirisa / Приоритет",
                    description = "Prioritet automatskog isključivanja opterećenja: Kontrola mirisa / Опрема.",
                },
                drugPowerPriorityAirflow = {
                    label = "Ventilacija / Приоритет",
                    description = "Prioritet automatskog isključivanja opterećenja: Ventilacija / Опрема.",
                },
                drugPowerPrioritySecurity = {
                    label = "Безбедност / Приоритет",
                    description = "Prioritet automatskog isključivanja opterećenja: Безбедносна опрема.",
                },
                drugPowerPriorityGrowing = {
                    label = "Uzgoj / Приоритет",
                    description = "Prioritet automatskog isključivanja opterećenja: Uzgoj / Опрема.",
                },
                drugPowerPriorityLight = {
                    label = "Osvetljenje / Приоритет",
                    description = "Prioritet automatskog isključivanja opterećenja: Osvetljenje / Опрема.",
                },
                drugPowerPriorityTesting = {
                    label = "Testiranje / Приоритет",
                    description = "Prioritet automatskog isključivanja opterećenja: Testiranje / Опрема.",
                },
                drugPowerPriorityPackaging = {
                    label = "Упаковка / Приоритет",
                    description = "Prioritet automatskog isključivanja opterećenja: Упаковка / Опрема.",
                },
                drugPowerPriorityChemistry = {
                    label = "Хемија / Приоритет",
                    description = "Prioritet automatskog isključivanja opterećenja: Хемија / Опрема.",
                },
                drugPowerPriorityHeating = {
                    label = "Grejanje / Приоритет",
                    description = "Prioritet automatskog isključivanja opterećenja: Grejanje / Опрема.",
                },
                drugPowerPriorityPressing = {
                    label = "Presovanje / Приоритет",
                    description = "Prioritet automatskog isključivanja opterećenja: Presovanje / Опрема.",
                },
                drugPowerPriorityGeneral = {
                    label = "Опште / Приоритет",
                    description = "Prioritet automatskog isključivanja opterećenja: Општа опрема.",
                },
                drugAdvancedPerformanceInactiveControlIntervalMs = {
                    label = "Перформансе / Неактивно / Контрола / Interval / ms",
                    description = "Podešavanje rada za: Перформансе / Неактивно / Контрола / Interval / ms.",
                },
                drugAdvancedPerformanceInteractionIdleScanIntervalMs = {
                    label = "Перформансе / Интеракција / Idle / Interval skeniranja / ms",
                    description = "Podešavanje rada za: Перформансе / Интеракција / Idle / Interval skeniranja / ms.",
                },
                drugAdvancedPerformanceInteractionPromptIntervalMs = {
                    label = "Перформансе / Интеракција / Poziv za interakciju / Interval / ms",
                    description = "Podešavanje rada za: Перформансе / Интеракција / Poziv za interakciju / Interval / ms.",
                },
                drugAdvancedPerformanceInteractionScanIntervalMs = {
                    label = "Перформансе / Интеракција / Interval skeniranja / ms",
                    description = "Podešavanje rada za: Перформансе / Интеракција / Interval skeniranja / ms.",
                },
                drugAdvancedPerformanceMinimumScanIntervalMs = {
                    label = "Перформансе / Minimum / Interval skeniranja / ms",
                    description = "Podešavanje rada za: Перформансе / Minimum / Interval skeniranja / ms.",
                },
                drugAdvancedPerformanceStreetPedActivationDistance = {
                    label = "Перформансе / Улица / Пед / Активација / Удаљеност",
                    description = "Podešavanje rada za: Перформансе / Улица / Пед / Активација / Удаљеност.",
                },
                drugAdvancedPerformanceStreetPedIdleScanIntervalMs = {
                    label = "Перформансе / Улица / Пед / Idle / Interval skeniranja / ms",
                    description = "Podešavanje rada za: Перформансе / Улица / Пед / Idle / Interval skeniranja / ms.",
                },
                drugAdvancedPerformanceStreetPedScanIntervalMs = {
                    label = "Перформансе / Улица / Пед / Interval skeniranja / ms",
                    description = "Podešavanje rada za: Перформансе / Улица / Пед / Interval skeniranja / ms.",
                },
                drugAdvancedPerformanceWorldCachePadding = {
                    label = "Перформансе / Свет / Keš / Dodatna margina",
                    description = "Podešavanje rada za: Перформансе / Свет / Keš / Dodatna margina.",
                },
                drugAdvancedPerformanceWorldCacheRefreshIntervalMs = {
                    label = "Перформансе / Свет / Keš / Osvežavanje / Interval / ms",
                    description = "Podešavanje rada za: Перформансе / Свет / Keš / Osvežavanje / Interval / ms.",
                },
                drugAdvancedPerformanceWorldIdleIntervalMs = {
                    label = "Перформансе / Свет / Idle / Interval / ms",
                    description = "Podešavanje rada za: Перформансе / Свет / Idle / Interval / ms.",
                },
                drugAdvancedDynamicMarketActionCooldownSeconds = {
                    label = "Динамичко тржиште / Хладноће акције / секунд",
                    description = "Podešavanje rada za: Динамичко тржиште / Хладноће акције / секунд.",
                },
                drugAdvancedDynamicMarketActionHistoryLimit = {
                    label = "Динамичко тржиште / Акција / Лимит историје",
                    description = "Podešavanje rada za: Динамичко тржиште / Акција / Лимит историје.",
                },
                drugAdvancedDynamicMarketAmountSaturationWeight = {
                    label = "Динамичко тржиште / Износ / Засићење / Тежина",
                    description = "Podešavanje rada za: Динамичко тржиште / Износ / Засићење / Тежина.",
                },
                drugAdvancedDynamicMarketBaseIntelAccuracy = {
                    label = "Динамичко тржиште / Osnovna vrednost / Тачност обавештења",
                    description = "Podešavanje rada za: Динамичко тржиште / Osnovna vrednost / Тачност обавештења.",
                },
                drugAdvancedDynamicMarketDefaultAverageQuality = {
                    label = "Динамичко тржиште / Podrazumevana vrednost / Prosek / Квалитет",
                    description = "Podešavanje rada za: Динамичко тржиште / Podrazumevana vrednost / Prosek / Квалитет.",
                },
                drugAdvancedDynamicMarketDefaultResourceElasticity = {
                    label = "Динамичко тржиште / Podrazumevana vrednost / Ресурс / Elastičnost",
                    description = "Podešavanje rada za: Динамичко тржиште / Podrazumevana vrednost / Ресурс / Elastičnost.",
                },
                drugAdvancedDynamicMarketDemandCenter = {
                    label = "Динамичко тржиште / Захтев / Srednja vrednost",
                    description = "Podešavanje rada za: Динамичко тржиште / Захтев / Srednja vrednost.",
                },
                drugAdvancedDynamicMarketDemandPriceImpact = {
                    label = "Динамичко тржиште / Захтев / Цена / Uticaj",
                    description = "Podešavanje rada za: Динамичко тржиште / Захтев / Цена / Uticaj.",
                },
                drugAdvancedDynamicMarketDirectionThreshold = {
                    label = "Динамичко тржиште / Правац / Prag",
                    description = "Podešavanje rada za: Динамичко тржиште / Правац / Prag.",
                },
                drugAdvancedDynamicMarketEnabled = {
                    label = "Динамичко тржиште / Омогућено",
                    description = "Podešavanje rada za: Динамичко тржиште / Омогућено.",
                },
                drugAdvancedDynamicMarketEventChance = {
                    label = "Динамичко тржиште / Događaj / Могућа",
                    description = "Podešavanje rada za: Динамичко тржиште / Događaj / Могућа.",
                },
                drugAdvancedDynamicMarketEventDurationMinutes = {
                    label = "Динамичко тржиште / Događaj / Трајање / Minuti",
                    description = "Podešavanje rada za: Динамичко тржиште / Događaj / Трајање / Minuti.",
                },
                drugAdvancedDynamicMarketEventMinimumDurationMinutes = {
                    label = "Динамичко тржиште / Događaj / Minimum / Трајање / Minuti",
                    description = "Podešavanje rada za: Динамичко тржиште / Događaj / Minimum / Трајање / Minuti.",
                },
                drugAdvancedDynamicMarketEventStrengthMaximum = {
                    label = "Динамичко тржиште / Događaj / Jačina / Maksimum",
                    description = "Podešavanje rada za: Динамичко тржиште / Događaj / Jačina / Maksimum.",
                },
                drugAdvancedDynamicMarketEventStrengthMinimum = {
                    label = "Динамичко тржиште / Događaj / Jačina / Minimum",
                    description = "Podešavanje rada za: Динамичко тржиште / Događaj / Jačina / Minimum.",
                },
                drugAdvancedDynamicMarketEventsCrackdownDemand = {
                    label = "Динамичко тржиште / Догађаји / Policijska akcija / Захтев",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Policijska akcija / Захтев.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPolice = {
                    label = "Динамичко тржиште / Догађаји / Policijska akcija / Policija",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Policijska akcija / Policija.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPrice = {
                    label = "Динамичко тржиште / Догађаји / Policijska akcija / Цена",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Policijska akcija / Цена.",
                },
                drugAdvancedDynamicMarketEventsFestivalDemand = {
                    label = "Динамичко тржиште / Догађаји / Festival / Захтев",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Festival / Захтев.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem1 = {
                    label = "Динамичко тржиште / Догађаји / Festival / Efekti / 1",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Festival / Efekti / 1.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem2 = {
                    label = "Динамичко тржиште / Догађаји / Festival / Efekti / 2",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Festival / Efekti / 2.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem3 = {
                    label = "Динамичко тржиште / Догађаји / Festival / Efekti / 3",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Festival / Efekti / 3.",
                },
                drugAdvancedDynamicMarketEventsFestivalPrice = {
                    label = "Динамичко тржиште / Догађаји / Festival / Цена",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Festival / Цена.",
                },
                drugAdvancedDynamicMarketEventsFestivalProfilesItem1 = {
                    label = "Динамичко тржиште / Догађаји / Festival / Profili / 1",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Festival / Profili / 1.",
                },
                drugAdvancedDynamicMarketEventsGangconflictDemand = {
                    label = "Динамичко тржиште / Догађаји / Ганг сукоб / Захтев",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Ганг сукоб / Захтев.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPolice = {
                    label = "Динамичко тржиште / Догађаји / Ганг сукоб / Policija",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Ганг сукоб / Policija.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPrice = {
                    label = "Динамичко тржиште / Догађаји / Ганг сукоб / Цена",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Ганг сукоб / Цена.",
                },
                drugAdvancedDynamicMarketEventsGangconflictProfilesItem1 = {
                    label = "Динамичко тржиште / Догађаји / Ганг сукоб / Profili / 1",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Ганг сукоб / Profili / 1.",
                },
                drugAdvancedDynamicMarketEventsLabbustDemand = {
                    label = "Динамичко тржиште / Догађаји / Racija u laboratoriji / Захтев",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Racija u laboratoriji / Захтев.",
                },
                drugAdvancedDynamicMarketEventsLabbustPolice = {
                    label = "Динамичко тржиште / Догађаји / Racija u laboratoriji / Policija",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Racija u laboratoriji / Policija.",
                },
                drugAdvancedDynamicMarketEventsLabbustPrice = {
                    label = "Динамичко тржиште / Догађаји / Racija u laboratoriji / Цена",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Racija u laboratoriji / Цена.",
                },
                drugAdvancedDynamicMarketEventsLabbustSupply = {
                    label = "Динамичко тржиште / Догађаји / Racija u laboratoriji / Снабдевање",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Racija u laboratoriji / Снабдевање.",
                },
                drugAdvancedDynamicMarketEventsPartyDemand = {
                    label = "Динамичко тржиште / Догађаји / Zabava / Захтев",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Zabava / Захтев.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem1 = {
                    label = "Динамичко тржиште / Догађаји / Zabava / Efekti / 1",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Zabava / Efekti / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem2 = {
                    label = "Динамичко тржиште / Догађаји / Zabava / Efekti / 2",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Zabava / Efekti / 2.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem3 = {
                    label = "Динамичко тржиште / Догађаји / Zabava / Efekti / 3",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Zabava / Efekti / 3.",
                },
                drugAdvancedDynamicMarketEventsPartyPrice = {
                    label = "Динамичко тржиште / Догађаји / Zabava / Цена",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Zabava / Цена.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem1 = {
                    label = "Динамичко тржиште / Догађаји / Zabava / Profili / 1",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Zabava / Profili / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem2 = {
                    label = "Динамичко тржиште / Догађаји / Zabava / Profili / 2",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Zabava / Profili / 2.",
                },
                drugAdvancedDynamicMarketEventsShortageDemand = {
                    label = "Динамичко тржиште / Догађаји / Nestašica / Захтев",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Nestašica / Захтев.",
                },
                drugAdvancedDynamicMarketEventsShortagePrice = {
                    label = "Динамичко тржиште / Догађаји / Nestašica / Цена",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Nestašica / Цена.",
                },
                drugAdvancedDynamicMarketEventsShortageSupply = {
                    label = "Динамичко тржиште / Догађаји / Nestašica / Снабдевање",
                    description = "Podešavanje rada za: Динамичко тржиште / Догађаји / Nestašica / Снабдевање.",
                },
                drugAdvancedDynamicMarketExactIntelReputation = {
                    label = "Динамичко тржиште / Tačne informacije / Репутација",
                    description = "Podešavanje rada za: Динамичко тржиште / Tačne informacije / Репутација.",
                },
                drugAdvancedDynamicMarketExactIntelTrust = {
                    label = "Динамичко тржиште / Tačne informacije / Повјерење",
                    description = "Podešavanje rada za: Динамичко тржиште / Tačne informacije / Повјерење.",
                },
                drugAdvancedDynamicMarketGlobalZoneLabel = {
                    label = "Динамичко тржиште / Global / Зона / Назив",
                    description = "Podešavanje rada za: Динамичко тржиште / Global / Зона / Назив.",
                },
                drugAdvancedDynamicMarketHistoryLimit = {
                    label = "Динамичко тржиште / Лимит историје",
                    description = "Podešavanje rada za: Динамичко тржиште / Лимит историје.",
                },
                drugAdvancedDynamicMarketInitialDemand = {
                    label = "Динамичко тржиште / Početna vrednost / Захтев",
                    description = "Podešavanje rada za: Динамичко тржиште / Početna vrednost / Захтев.",
                },
                drugAdvancedDynamicMarketInitialPriceMultiplier = {
                    label = "Динамичко тржиште / Početna vrednost / Мноилац цене",
                    description = "Podešavanje rada za: Динамичко тржиште / Početna vrednost / Мноилац цене.",
                },
                drugAdvancedDynamicMarketIntelDemandError = {
                    label = "Динамичко тржиште / Obaveštajni podaci / Захтев / Грешка",
                    description = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Захтев / Грешка.",
                },
                drugAdvancedDynamicMarketIntelMaximumAccuracy = {
                    label = "Динамичко тржиште / Obaveštajni podaci / Maksimum / Тачност",
                    description = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Maksimum / Тачност.",
                },
                drugAdvancedDynamicMarketIntelMinimumAccuracy = {
                    label = "Динамичко тржиште / Obaveštajni podaci / Minimum / Тачност",
                    description = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Minimum / Тачност.",
                },
                drugAdvancedDynamicMarketIntelPoliceError = {
                    label = "Динамичко тржиште / Obaveštajni podaci / Policija / Грешка",
                    description = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Policija / Грешка.",
                },
                drugAdvancedDynamicMarketIntelPriceError = {
                    label = "Динамичко тржиште / Obaveštajni podaci / Цена / Грешка",
                    description = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Цена / Грешка.",
                },
                drugAdvancedDynamicMarketIntelPriceMaximum = {
                    label = "Динамичко тржиште / Obaveštajni podaci / Цена / Maksimum",
                    description = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Цена / Maksimum.",
                },
                drugAdvancedDynamicMarketIntelPriceMinimum = {
                    label = "Динамичко тржиште / Obaveštajni podaci / Цена / Minimum",
                    description = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Цена / Minimum.",
                },
                drugAdvancedDynamicMarketIntelReputationWeight = {
                    label = "Динамичко тржиште / Obaveštajni podaci / Репутација / Тежина",
                    description = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Репутација / Тежина.",
                },
                drugAdvancedDynamicMarketIntelResourcePriceError = {
                    label = "Динамичко тржиште / Obaveštajni podaci / Ресурс / Цена / Грешка",
                    description = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Ресурс / Цена / Грешка.",
                },
                drugAdvancedDynamicMarketIntelSaturationError = {
                    label = "Динамичко тржиште / Obaveštajni podaci / Засићење / Грешка",
                    description = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Засићење / Грешка.",
                },
                drugAdvancedDynamicMarketIntelSeedBucketSeconds = {
                    label = "Динамичко тржиште / Prozor semena informacija / секунд",
                    description = "Podešavanje rada za: Динамичко тржиште / Prozor semena informacija / секунд.",
                },
                drugAdvancedDynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Динамичко тржиште / Obaveštajni podaci / Статус / Тачност / Prag",
                    description = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Статус / Тачност / Prag.",
                },
                drugAdvancedDynamicMarketIntelStatusErrorThreshold = {
                    label = "Динамичко тржиште / Obaveštajni podaci / Статус / Грешка / Prag",
                    description = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Статус / Грешка / Prag.",
                },
                drugAdvancedDynamicMarketIntelSupplyError = {
                    label = "Динамичко тржиште / Obaveštajni podaci / Снабдевање / Грешка",
                    description = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Снабдевање / Грешка.",
                },
                drugAdvancedDynamicMarketIntelTrustWeight = {
                    label = "Динамичко тржиште / Obaveštajni podaci / Повјерење / Тежина",
                    description = "Podešavanje rada za: Динамичко тржиште / Obaveštajni podaci / Повјерење / Тежина.",
                },
                drugAdvancedDynamicMarketManipulationCooldownMinutes = {
                    label = "Динамичко тржиште / Manipulacija / Minuti pauze",
                    description = "Podešavanje rada za: Динамичко тржиште / Manipulacija / Minuti pauze.",
                },
                drugAdvancedDynamicMarketManipulationDemandShift = {
                    label = "Динамичко тржиште / Manipulacija / Захтев / Promena",
                    description = "Podešavanje rada za: Динамичко тржиште / Manipulacija / Захтев / Promena.",
                },
                drugAdvancedDynamicMarketManipulationDurationMinutes = {
                    label = "Динамичко тржиште / Manipulacija / Трајање / Minuti",
                    description = "Podešavanje rada za: Динамичко тржиште / Manipulacija / Трајање / Minuti.",
                },
                drugAdvancedDynamicMarketManipulationHeat = {
                    label = "Динамичко тржиште / Manipulacija / Policijski pritisak",
                    description = "Podešavanje rada za: Динамичко тржиште / Manipulacija / Policijski pritisak.",
                },
                drugAdvancedDynamicMarketManipulationMinimumBatchAmount = {
                    label = "Динамичко тржиште / Manipulacija / Minimum / Серија / Износ",
                    description = "Podešavanje rada za: Динамичко тржиште / Manipulacija / Minimum / Серија / Износ.",
                },
                drugAdvancedDynamicMarketManipulationPaymentAccount = {
                    label = "Динамичко тржиште / Manipulacija / Начин за плаћање",
                    description = "Podešavanje rada za: Динамичко тржиште / Manipulacija / Начин за плаћање.",
                },
                drugAdvancedDynamicMarketManipulationPrice = {
                    label = "Динамичко тржиште / Manipulacija / Цена",
                    description = "Podešavanje rada za: Динамичко тржиште / Manipulacija / Цена.",
                },
                drugAdvancedDynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Динамичко тржиште / Manipulacija / Зона / Policijski pritisak / Množilac",
                    description = "Podešavanje rada za: Динамичко тржиште / Manipulacija / Зона / Policijski pritisak / Množilac.",
                },
                drugAdvancedDynamicMarketMaximumIntelAgeMinutes = {
                    label = "Динамичко тржиште / Maksimum / Старост обавештења / Minuti",
                    description = "Podešavanje rada za: Динамичко тржиште / Maksimum / Старост обавештења / Minuti.",
                },
                drugAdvancedDynamicMarketMaximumPriceMultiplier = {
                    label = "Динамичко тржиште / Maksimum / Мноилац цене",
                    description = "Podešavanje rada za: Динамичко тржиште / Maksimum / Мноилац цене.",
                },
                drugAdvancedDynamicMarketMinimumIntelAgeMinutes = {
                    label = "Динамичко тржиште / Minimum / Старост обавештења / Minuti",
                    description = "Podešavanje rada za: Динамичко тржиште / Minimum / Старост обавештења / Minuti.",
                },
                drugAdvancedDynamicMarketMinimumMetricWindowMinutes = {
                    label = "Динамичко тржиште / Minimum / Metrika / Vremenski prozor / Minuti",
                    description = "Podešavanje rada za: Динамичко тржиште / Minimum / Metrika / Vremenski prozor / Minuti.",
                },
                drugAdvancedDynamicMarketMinimumPriceMultiplier = {
                    label = "Динамичко тржиште / Минимална цена / Množilac",
                    description = "Podešavanje rada za: Динамичко тржиште / Минимална цена / Množilac.",
                },
                drugAdvancedDynamicMarketMinimumUpdateMinutes = {
                    label = "Динамичко тржиште / Minimum / Ažuriranje / Minuti",
                    description = "Podešavanje rada za: Динамичко тржиште / Minimum / Ažuriranje / Minuti.",
                },
                drugAdvancedDynamicMarketPoliceDemandWeight = {
                    label = "Динамичко тржиште / Policija / Захтев / Тежина",
                    description = "Podešavanje rada za: Динамичко тржиште / Policija / Захтев / Тежина.",
                },
                drugAdvancedDynamicMarketPolicePriceImpact = {
                    label = "Динамичко тржиште / Policija / Цена / Uticaj",
                    description = "Podešavanje rada za: Динамичко тржиште / Policija / Цена / Uticaj.",
                },
                drugAdvancedDynamicMarketPoorQualityDemandPenalty = {
                    label = "Динамичко тржиште / Loš kvalitet / Захтев / Kazna",
                    description = "Podešavanje rada za: Динамичко тржиште / Loš kvalitet / Захтев / Kazna.",
                },
                drugAdvancedDynamicMarketPoorQualityThreshold = {
                    label = "Динамичко тржиште / Loš kvalitet / Prag",
                    description = "Podešavanje rada za: Динамичко тржиште / Loš kvalitet / Prag.",
                },
                drugAdvancedDynamicMarketPremiumQualityDemandBonus = {
                    label = "Динамичко тржиште / Vrhunski kvalitet / Бонус захтева",
                    description = "Podešavanje rada za: Динамичко тржиште / Vrhunski kvalitet / Бонус захтева.",
                },
                drugAdvancedDynamicMarketPremiumQualityThreshold = {
                    label = "Динамичко тржиште / Vrhunski kvalitet / Prag",
                    description = "Podešavanje rada za: Динамичко тржиште / Vrhunski kvalitet / Prag.",
                },
                drugAdvancedDynamicMarketProductionSupplyWeight = {
                    label = "Динамичко тржиште / Производња / Снабдевање / Тежина",
                    description = "Podešavanje rada za: Динамичко тржиште / Производња / Снабдевање / Тежина.",
                },
                drugAdvancedDynamicMarketProductionWindowMinutes = {
                    label = "Динамичко тржиште / Производња / Vremenski prozor / Minuti",
                    description = "Podešavanje rada za: Динамичко тржиште / Производња / Vremenski prozor / Minuti.",
                },
                drugAdvancedDynamicMarketQualityCenter = {
                    label = "Динамичко тржиште / Квалитет / Srednja vrednost",
                    description = "Podešavanje rada za: Динамичко тржиште / Квалитет / Srednja vrednost.",
                },
                drugAdvancedDynamicMarketQualityConfidenceImpact = {
                    label = "Динамичко тржиште / Квалитет / Постојаност / Uticaj",
                    description = "Podešavanje rada za: Динамичко тржиште / Квалитет / Постојаност / Uticaj.",
                },
                drugAdvancedDynamicMarketQualityRange = {
                    label = "Динамичко тржиште / Квалитет / Raspon vrednosti",
                    description = "Podešavanje rada za: Динамичко тржиште / Квалитет / Raspon vrednosti.",
                },
                drugAdvancedDynamicMarketRarityBonusMaximum = {
                    label = "Динамичко тржиште / Retkost / Бонус / Maksimum",
                    description = "Podešavanje rada za: Динамичко тржиште / Retkost / Бонус / Maksimum.",
                },
                drugAdvancedDynamicMarketRegionalGlobalWeight = {
                    label = "Динамичко тржиште / Regionalno / Global / Тежина",
                    description = "Podešavanje rada za: Динамичко тржиште / Regionalno / Global / Тежина.",
                },
                drugAdvancedDynamicMarketRegionalLocalWeight = {
                    label = "Динамичко тржиште / Regionalno / Lokalno / Тежина",
                    description = "Podešavanje rada za: Динамичко тржиште / Regionalno / Lokalno / Тежина.",
                },
                drugAdvancedDynamicMarketResourceAliasesDrugpackaging = {
                    label = "Динамичко тржиште / Ресурс / Alternativni nazivi / Дрога / Упаковка",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурс / Alternativni nazivi / Дрога / Упаковка.",
                },
                drugAdvancedDynamicMarketResourceAliasesFuelcan = {
                    label = "Динамичко тржиште / Ресурс / Alternativni nazivi / Kanister goriva",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурс / Alternativni nazivi / Kanister goriva.",
                },
                drugAdvancedDynamicMarketResourceAliasesMachineoil = {
                    label = "Динамичко тржиште / Ресурс / Alternativni nazivi / Машинско уље",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурс / Alternativni nazivi / Машинско уље.",
                },
                drugAdvancedDynamicMarketResourceAliasesPlantnutrients = {
                    label = "Динамичко тржиште / Ресурс / Alternativni nazivi / Уноси за биљке",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурс / Alternativni nazivi / Уноси за биљке.",
                },
                drugAdvancedDynamicMarketResourceAliasesRepairkit = {
                    label = "Динамичко тржиште / Ресурс / Alternativni nazivi / Набор за поправку",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурс / Alternativni nazivi / Набор за поправку.",
                },
                drugAdvancedDynamicMarketResourceDirectionFallThreshold = {
                    label = "Динамичко тржиште / Ресурс / Правац / Pad / Prag",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурс / Правац / Pad / Prag.",
                },
                drugAdvancedDynamicMarketResourceDirectionRiseThreshold = {
                    label = "Динамичко тржиште / Ресурс / Правац / Rast / Prag",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурс / Правац / Rast / Prag.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterBasePrice = {
                    label = "Динамичко тржиште / Ресурси / Угљеники филтер / Базна цена",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Угљеники филтер / Базна цена.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterElasticity = {
                    label = "Динамичко тржиште / Ресурси / Угљеники филтер / Elastičnost",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Угљеники филтер / Elastičnost.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLabel = {
                    label = "Динамичко тржиште / Ресурси / Угљеники филтер / Назив",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Угљеники филтер / Назив.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem1 = {
                    label = "Динамичко тржиште / Ресурси / Угљеники филтер / Povezane droge / 1",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Угљеники филтер / Povezane droge / 1.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem2 = {
                    label = "Динамичко тржиште / Ресурси / Угљеники филтер / Povezane droge / 2",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Угљеники филтер / Povezane droge / 2.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem3 = {
                    label = "Динамичко тржиште / Ресурси / Угљеники филтер / Povezane droge / 3",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Угљеники филтер / Povezane droge / 3.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorBasePrice = {
                    label = "Динамичко тржиште / Ресурси / Hemijski prekursor / Базна цена",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Hemijski prekursor / Базна цена.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorElasticity = {
                    label = "Динамичко тржиште / Ресурси / Hemijski prekursor / Elastičnost",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Hemijski prekursor / Elastičnost.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLabel = {
                    label = "Динамичко тржиште / Ресурси / Hemijski prekursor / Назив",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Hemijski prekursor / Назив.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem1 = {
                    label = "Динамичко тржиште / Ресурси / Hemijski prekursor / Povezane droge / 1",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Hemijski prekursor / Povezane droge / 1.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem2 = {
                    label = "Динамичко тржиште / Ресурси / Hemijski prekursor / Povezane droge / 2",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Hemijski prekursor / Povezane droge / 2.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsBasePrice = {
                    label = "Динамичко тржиште / Ресурси / Делови опреме / Базна цена",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Делови опреме / Базна цена.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsElasticity = {
                    label = "Динамичко тржиште / Ресурси / Делови опреме / Elastičnost",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Делови опреме / Elastičnost.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsLabel = {
                    label = "Динамичко тржиште / Ресурси / Делови опреме / Назив",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Делови опреме / Назив.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerBasePrice = {
                    label = "Динамичко тржиште / Ресурси / Угњетило / Базна цена",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Угњетило / Базна цена.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerElasticity = {
                    label = "Динамичко тржиште / Ресурси / Угњетило / Elastičnost",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Угњетило / Elastičnost.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLabel = {
                    label = "Динамичко тржиште / Ресурси / Угњетило / Назив",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Угњетило / Назив.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLinkedDrugsItem1 = {
                    label = "Динамичко тржиште / Ресурси / Угњетило / Povezane droge / 1",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Угњетило / Povezane droge / 1.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelBasePrice = {
                    label = "Динамичко тржиште / Ресурси / Гориво за лабораторију / Базна цена",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Гориво за лабораторију / Базна цена.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelElasticity = {
                    label = "Динамичко тржиште / Ресурси / Гориво за лабораторију / Elastičnost",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Гориво за лабораторију / Elastičnost.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelLabel = {
                    label = "Динамичко тржиште / Ресурси / Гориво за лабораторију / Назив",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Гориво за лабораторију / Назив.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagBasePrice = {
                    label = "Динамичко тржиште / Ресурси / Kesa za pakovanje / Базна цена",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Kesa za pakovanje / Базна цена.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagElasticity = {
                    label = "Динамичко тржиште / Ресурси / Kesa za pakovanje / Elastičnost",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Kesa za pakovanje / Elastičnost.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagLabel = {
                    label = "Динамичко тржиште / Ресурси / Kesa za pakovanje / Назив",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Kesa za pakovanje / Назив.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotBasePrice = {
                    label = "Динамичко тржиште / Ресурси / Садница / Базна цена",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Садница / Базна цена.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotElasticity = {
                    label = "Динамичко тржиште / Ресурси / Садница / Elastičnost",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Садница / Elastičnost.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLabel = {
                    label = "Динамичко тржиште / Ресурси / Садница / Назив",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Садница / Назив.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLinkedDrugsItem1 = {
                    label = "Динамичко тржиште / Ресурси / Садница / Povezane droge / 1",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Садница / Povezane droge / 1.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedBasePrice = {
                    label = "Динамичко тржиште / Ресурси / Seme kanabisa / Базна цена",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Seme kanabisa / Базна цена.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedElasticity = {
                    label = "Динамичко тржиште / Ресурси / Seme kanabisa / Elastičnost",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Seme kanabisa / Elastičnost.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLabel = {
                    label = "Динамичко тржиште / Ресурси / Seme kanabisa / Назив",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Seme kanabisa / Назив.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLinkedDrugsItem1 = {
                    label = "Динамичко тржиште / Ресурси / Seme kanabisa / Povezane droge / 1",
                    description = "Podešavanje rada za: Динамичко тржиште / Ресурси / Seme kanabisa / Povezane droge / 1.",
                },
                drugAdvancedDynamicMarketSalesWindowMinutes = {
                    label = "Динамичко тржиште / Продаја / Vremenski prozor / Minuti",
                    description = "Podešavanje rada za: Динамичко тржиште / Продаја / Vremenski prozor / Minuti.",
                },
                drugAdvancedDynamicMarketSaturationDemandWeight = {
                    label = "Динамичко тржиште / Засићење / Захтев / Тежина",
                    description = "Podešavanje rada za: Динамичко тржиште / Засићење / Захтев / Тежина.",
                },
                drugAdvancedDynamicMarketSaturationPriceImpact = {
                    label = "Динамичко тржиште / Засићење / Цена / Uticaj",
                    description = "Podešavanje rada za: Динамичко тржиште / Засићење / Цена / Uticaj.",
                },
                drugAdvancedDynamicMarketScarcityDemandWeight = {
                    label = "Динамичко тржиште / Nestašica / Захтев / Тежина",
                    description = "Podešavanje rada za: Динамичко тржиште / Nestašica / Захтев / Тежина.",
                },
                drugAdvancedDynamicMarketScarcityPriceImpact = {
                    label = "Динамичко тржиште / Nestašica / Цена / Uticaj",
                    description = "Podešavanje rada za: Динамичко тржиште / Nestašica / Цена / Uticaj.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsDecember = {
                    label = "Динамичко тржиште / Godišnje doba / Kraj / Meseci / Decembar",
                    description = "Podešavanje rada za: Динамичко тржиште / Godišnje doba / Kraj / Meseci / Decembar.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSpring = {
                    label = "Динамичко тржиште / Godišnje doba / Kraj / Meseci / Proleće",
                    description = "Podešavanje rada za: Динамичко тржиште / Godišnje doba / Kraj / Meseci / Proleće.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSummer = {
                    label = "Динамичко тржиште / Godišnje doba / Kraj / Meseci / Leto",
                    description = "Podešavanje rada za: Динамичко тржиште / Godišnje doba / Kraj / Meseci / Leto.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsWinter = {
                    label = "Динамичко тржиште / Godišnje doba / Kraj / Meseci / Zima",
                    description = "Podešavanje rada za: Динамичко тржиште / Godišnje doba / Kraj / Meseci / Zima.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersAutumn = {
                    label = "Динамичко тржиште / Godišnje doba / Množioci / Jesen",
                    description = "Podešavanje rada za: Динамичко тржиште / Godišnje doba / Množioci / Jesen.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSpring = {
                    label = "Динамичко тржиште / Godišnje doba / Množioci / Proleće",
                    description = "Podešavanje rada za: Динамичко тржиште / Godišnje doba / Množioci / Proleće.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSummer = {
                    label = "Динамичко тржиште / Godišnje doba / Množioci / Leto",
                    description = "Podešavanje rada za: Динамичко тржиште / Godišnje doba / Množioci / Leto.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersWinter = {
                    label = "Динамичко тржиште / Godišnje doba / Množioci / Zima",
                    description = "Podešavanje rada za: Динамичко тржиште / Godišnje doba / Množioci / Zima.",
                },
                drugAdvancedDynamicMarketShortageRumorThreshold = {
                    label = "Динамичко тржиште / Nestašica / Glasina / Prag",
                    description = "Podešavanje rada za: Динамичко тржиште / Nestašica / Glasina / Prag.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHighDemand = {
                    label = "Динамичко тржиште / Статус / Pragovi / Висока потражња",
                    description = "Podešavanje rada za: Динамичко тржиште / Статус / Pragovi / Висока потражња.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHot = {
                    label = "Динамичко тржиште / Статус / Pragovi / Топ",
                    description = "Podešavanje rada za: Динамичко тржиште / Статус / Pragovi / Топ.",
                },
                drugAdvancedDynamicMarketStatusThresholdsLowDemand = {
                    label = "Динамичко тржиште / Статус / Pragovi / Ниска потражња",
                    description = "Podešavanje rada za: Динамичко тржиште / Статус / Pragovi / Ниска потражња.",
                },
                drugAdvancedDynamicMarketStatusThresholdsSaturated = {
                    label = "Динамичко тржиште / Статус / Pragovi / Засићено",
                    description = "Podešavanje rada za: Динамичко тржиште / Статус / Pragovi / Засићено.",
                },
                drugAdvancedDynamicMarketTargetSupply = {
                    label = "Динамичко тржиште / Циљ / Снабдевање",
                    description = "Podešavanje rada za: Динамичко тржиште / Циљ / Снабдевање.",
                },
                drugAdvancedDynamicMarketTrendChance = {
                    label = "Динамичко тржиште / Trend / Могућа",
                    description = "Podešavanje rada za: Динамичко тржиште / Trend / Могућа.",
                },
                drugAdvancedDynamicMarketTrendDurationMinutes = {
                    label = "Динамичко тржиште / Trend / Трајање / Minuti",
                    description = "Podešavanje rada za: Динамичко тржиште / Trend / Трајање / Minuti.",
                },
                drugAdvancedDynamicMarketTrendMaximumStrength = {
                    label = "Динамичко тржиште / Trend / Maksimum / Jačina",
                    description = "Podešavanje rada za: Динамичко тржиште / Trend / Maksimum / Jačina.",
                },
                drugAdvancedDynamicMarketTrendMinimumStrength = {
                    label = "Динамичко тржиште / Trend / Minimum / Jačina",
                    description = "Podešavanje rada za: Динамичко тржиште / Trend / Minimum / Jačina.",
                },
                drugAdvancedDynamicMarketUpdateMinutes = {
                    label = "Динамичко тржиште / Ažuriranje / Minuti",
                    description = "Podešavanje rada za: Динамичко тржиште / Ažuriranje / Minuti.",
                },
                drugAdvancedDynamicMarketVolatilityMaximum = {
                    label = "Динамичко тржиште / Promenljivost cena / Maksimum",
                    description = "Podešavanje rada za: Динамичко тржиште / Promenljivost cena / Maksimum.",
                },
                drugAdvancedDynamicMarketVolatilityMinimum = {
                    label = "Динамичко тржиште / Promenljivost cena / Minimum",
                    description = "Podešavanje rada za: Динамичко тржиште / Promenljivost cena / Minimum.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersCold = {
                    label = "Динамичко тржиште / Vreme / Množioci / Hladnoća",
                    description = "Podešavanje rada za: Динамичко тржиште / Vreme / Množioci / Hladnoća.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersHeatwave = {
                    label = "Динамичко тржиште / Vreme / Množioci / Toplotni talas",
                    description = "Podešavanje rada za: Динамичко тржиште / Vreme / Množioci / Toplotni talas.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersNormal = {
                    label = "Динамичко тржиште / Vreme / Množioci / Нормално",
                    description = "Podešavanje rada za: Динамичко тржиште / Vreme / Množioci / Нормално.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersRain = {
                    label = "Динамичко тржиште / Vreme / Množioci / Kiša",
                    description = "Podešavanje rada za: Динамичко тржиште / Vreme / Množioci / Kiša.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersStorm = {
                    label = "Динамичко тржиште / Vreme / Množioci / Oluja",
                    description = "Podešavanje rada za: Динамичко тржиште / Vreme / Množioci / Oluja.",
                },
                drugAdvancedDynamicMarketWeatherState = {
                    label = "Динамичко тржиште / Vreme / Стање",
                    description = "Podešavanje rada za: Динамичко тржиште / Vreme / Стање.",
                },
                drugAdvancedHeatActionCooldownSeconds = {
                    label = "Pažnja policije i rizik / Хладноће акције / секунд",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Хладноће акције / секунд.",
                },
                drugAdvancedHeatActivityRiskWeightsAmount = {
                    label = "Pažnja policije i rizik / Aktivnost / Ризик / Ponderi / Износ",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Aktivnost / Ризик / Ponderi / Износ.",
                },
                drugAdvancedHeatActivityRiskWeightsDurationMinutes = {
                    label = "Pažnja policije i rizik / Aktivnost / Ризик / Ponderi / Трајање / Minuti",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Aktivnost / Ризик / Ponderi / Трајање / Minuti.",
                },
                drugAdvancedHeatActivityRiskWeightsPolicePressure = {
                    label = "Pažnja policije i rizik / Aktivnost / Ризик / Ponderi / Притисак полиције",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Aktivnost / Ризик / Ponderi / Притисак полиције.",
                },
                drugAdvancedHeatActivityRiskWeightsReputation = {
                    label = "Pažnja policije i rizik / Aktivnost / Ризик / Ponderi / Репутација",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Aktivnost / Ризик / Ponderi / Репутација.",
                },
                drugAdvancedHeatActivityRiskWeightsSecurity = {
                    label = "Pažnja policije i rizik / Aktivnost / Ризик / Ponderi / Безбедност",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Aktivnost / Ризик / Ponderi / Безбедност.",
                },
                drugAdvancedHeatAggressiveHeatMultiplier = {
                    label = "Pažnja policije i rizik / Agresivni režim / Policijski pritisak / Množilac",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Agresivni režim / Policijski pritisak / Množilac.",
                },
                drugAdvancedHeatBurnerBurnThreshold = {
                    label = "Pažnja policije i rizik / Telefon za jednokratnu upotrebu / Razotkrivanje / Prag",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Telefon za jednokratnu upotrebu / Razotkrivanje / Prag.",
                },
                drugAdvancedHeatBurnerHeatPerWholesale = {
                    label = "Pažnja policije i rizik / Telefon za jednokratnu upotrebu / Policijski pritisak / Po veleprodajnom poslu",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Telefon za jednokratnu upotrebu / Policijski pritisak / Po veleprodajnom poslu.",
                },
                drugAdvancedHeatBurnerPhoneItem = {
                    label = "Pažnja policije i rizik / Бернер телефон / Predmet",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Бернер телефон / Predmet.",
                },
                drugAdvancedHeatCamperOperationalHeatMultiplier = {
                    label = "Pažnja policije i rizik / Kamper u radu / Policijski pritisak / Množilac",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Kamper u radu / Policijski pritisak / Množilac.",
                },
                drugAdvancedHeatCamperOperationalHeatThreshold = {
                    label = "Pažnja policije i rizik / Kamper u radu / Policijski pritisak / Prag",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Kamper u radu / Policijski pritisak / Prag.",
                },
                drugAdvancedHeatCamperParkedHeat = {
                    label = "Pažnja policije i rizik / Parkirani kamper / Policijski pritisak",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Parkirani kamper / Policijski pritisak.",
                },
                drugAdvancedHeatContaminatedHeatMultiplier = {
                    label = "Pažnja policije i rizik / Kontaminacija / Policijski pritisak / Množilac",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Kontaminacija / Policijski pritisak / Množilac.",
                },
                drugAdvancedHeatContaminatedThreshold = {
                    label = "Pažnja policije i rizik / Kontaminacija / Prag",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Kontaminacija / Prag.",
                },
                drugAdvancedHeatCultivationFreePlants = {
                    label = "Pažnja policije i rizik / Култивација / Biljke bez dodatnog rizika",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Култивација / Biljke bez dodatnog rizika.",
                },
                drugAdvancedHeatCultivationHeatPerPlant = {
                    label = "Pažnja policije i rizik / Култивација / Policijski pritisak / Po biljci",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Култивација / Policijski pritisak / Po biljci.",
                },
                drugAdvancedHeatDealerHiddenMinutes = {
                    label = "Pažnja policije i rizik / Дилер / скривено / Minuti",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Дилер / скривено / Minuti.",
                },
                drugAdvancedHeatDecayPerTickBatch = {
                    label = "Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Серија",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Серија.",
                },
                drugAdvancedHeatDecayPerTickCamper = {
                    label = "Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Кампер",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Кампер.",
                },
                drugAdvancedHeatDecayPerTickDealer = {
                    label = "Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Дилер",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Дилер.",
                },
                drugAdvancedHeatDecayPerTickFaction = {
                    label = "Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Фракција",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Фракција.",
                },
                drugAdvancedHeatDecayPerTickHub = {
                    label = "Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Distributivni centar",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Distributivni centar.",
                },
                drugAdvancedHeatDecayPerTickLab = {
                    label = "Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Лабораторија",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Лабораторија.",
                },
                drugAdvancedHeatDecayPerTickPlayer = {
                    label = "Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Играч",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Играч.",
                },
                drugAdvancedHeatDecayPerTickRoute = {
                    label = "Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Рута",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Рута.",
                },
                drugAdvancedHeatDecayPerTickZone = {
                    label = "Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Зона",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Отуђење / Po ciklusu ažuriranja / Зона.",
                },
                drugAdvancedHeatEnabled = {
                    label = "Pažnja policije i rizik / Омогућено",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Омогућено.",
                },
                drugAdvancedHeatEnforcementHeatCritical = {
                    label = "Pažnja policije i rizik / Prisustvo policije / Policijski pritisak / Критично",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Prisustvo policije / Policijski pritisak / Критично.",
                },
                drugAdvancedHeatEnforcementHeatHigh = {
                    label = "Pažnja policije i rizik / Prisustvo policije / Policijski pritisak / Висок",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Prisustvo policije / Policijski pritisak / Висок.",
                },
                drugAdvancedHeatEnforcementHeatLow = {
                    label = "Pažnja policije i rizik / Prisustvo policije / Policijski pritisak / Низак",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Prisustvo policije / Policijski pritisak / Низак.",
                },
                drugAdvancedHeatEnforcementHeatMedium = {
                    label = "Pažnja policije i rizik / Prisustvo policije / Policijski pritisak / Средњи",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Prisustvo policije / Policijski pritisak / Средњи.",
                },
                drugAdvancedHeatEnforcementMultipliersBatch = {
                    label = "Pažnja policije i rizik / Prisustvo policije / Množioci / Серија",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Prisustvo policije / Množioci / Серија.",
                },
                drugAdvancedHeatEnforcementMultipliersFaction = {
                    label = "Pažnja policije i rizik / Prisustvo policije / Množioci / Фракција",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Prisustvo policije / Množioci / Фракција.",
                },
                drugAdvancedHeatEnforcementMultipliersZone = {
                    label = "Pažnja policije i rizik / Prisustvo policije / Množioci / Зона",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Prisustvo policije / Množioci / Зона.",
                },
                drugAdvancedHeatEntityTypesBatch = {
                    label = "Pažnja policije i rizik / Objekat igre / Tipovi / Серија",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Objekat igre / Tipovi / Серија.",
                },
                drugAdvancedHeatEntityTypesCamper = {
                    label = "Pažnja policije i rizik / Objekat igre / Tipovi / Кампер",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Objekat igre / Tipovi / Кампер.",
                },
                drugAdvancedHeatEntityTypesDealer = {
                    label = "Pažnja policije i rizik / Objekat igre / Tipovi / Дилер",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Objekat igre / Tipovi / Дилер.",
                },
                drugAdvancedHeatEntityTypesFaction = {
                    label = "Pažnja policije i rizik / Objekat igre / Tipovi / Фракција",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Objekat igre / Tipovi / Фракција.",
                },
                drugAdvancedHeatEntityTypesHub = {
                    label = "Pažnja policije i rizik / Objekat igre / Tipovi / Distributivni centar",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Objekat igre / Tipovi / Distributivni centar.",
                },
                drugAdvancedHeatEntityTypesLab = {
                    label = "Pažnja policije i rizik / Objekat igre / Tipovi / Лабораторија",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Objekat igre / Tipovi / Лабораторија.",
                },
                drugAdvancedHeatEntityTypesPlayer = {
                    label = "Pažnja policije i rizik / Objekat igre / Tipovi / Играч",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Objekat igre / Tipovi / Играч.",
                },
                drugAdvancedHeatEntityTypesRoute = {
                    label = "Pažnja policije i rizik / Objekat igre / Tipovi / Рута",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Objekat igre / Tipovi / Рута.",
                },
                drugAdvancedHeatEntityTypesZone = {
                    label = "Pažnja policije i rizik / Objekat igre / Tipovi / Зона",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Objekat igre / Tipovi / Зона.",
                },
                drugAdvancedHeatEventCooldownMinutes = {
                    label = "Pažnja policije i rizik / Događaj / Minuti pauze",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Događaj / Minuti pauze.",
                },
                drugAdvancedHeatEventHistoryLimit = {
                    label = "Pažnja policije i rizik / Događaj / Лимит историје",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Događaj / Лимит историје.",
                },
                drugAdvancedHeatLabHeatSyncThreshold = {
                    label = "Pažnja policije i rizik / Лабораторија / Policijski pritisak / Sinhronizacija / Prag",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Лабораторија / Policijski pritisak / Sinhronizacija / Prag.",
                },
                drugAdvancedHeatLayLowCooldownMinutes = {
                    label = "Pažnja policije i rizik / Povući se / Minuti pauze",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Povući se / Minuti pauze.",
                },
                drugAdvancedHeatLayLowIdleMinutes = {
                    label = "Pažnja policije i rizik / Povući se / Idle / Minuti",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Povući se / Idle / Minuti.",
                },
                drugAdvancedHeatLayLowReduction = {
                    label = "Pažnja policije i rizik / Povući se / Smanjenje",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Povući se / Smanjenje.",
                },
                drugAdvancedHeatLockdownMinutes = {
                    label = "Pažnja policije i rizik / Затворено / Minuti",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Затворено / Minuti.",
                },
                drugAdvancedHeatMinimumDurationMinutes = {
                    label = "Pažnja policije i rizik / Minimum / Трајање / Minuti",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Minimum / Трајање / Minuti.",
                },
                drugAdvancedHeatMinimumEventCooldownSeconds = {
                    label = "Pažnja policije i rizik / Minimum / Događaj / Време паузе (секунде)",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Minimum / Događaj / Време паузе (секунде).",
                },
                drugAdvancedHeatMinimumIdleSeconds = {
                    label = "Pažnja policije i rizik / Minimum / Idle / секунд",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Minimum / Idle / секунд.",
                },
                drugAdvancedHeatProcessingHeatMultiplier = {
                    label = "Pažnja policije i rizik / Обрада / Policijski pritisak / Množilac",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Обрада / Policijski pritisak / Množilac.",
                },
                drugAdvancedHeatRiskWeightsBatch = {
                    label = "Pažnja policije i rizik / Ризик / Ponderi / Серија",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Ризик / Ponderi / Серија.",
                },
                drugAdvancedHeatRiskWeightsCamper = {
                    label = "Pažnja policije i rizik / Ризик / Ponderi / Кампер",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Ризик / Ponderi / Кампер.",
                },
                drugAdvancedHeatRiskWeightsDealer = {
                    label = "Pažnja policije i rizik / Ризик / Ponderi / Дилер",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Ризик / Ponderi / Дилер.",
                },
                drugAdvancedHeatRiskWeightsFaction = {
                    label = "Pažnja policije i rizik / Ризик / Ponderi / Фракција",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Ризик / Ponderi / Фракција.",
                },
                drugAdvancedHeatRiskWeightsHub = {
                    label = "Pažnja policije i rizik / Ризик / Ponderi / Distributivni centar",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Ризик / Ponderi / Distributivni centar.",
                },
                drugAdvancedHeatRiskWeightsLab = {
                    label = "Pažnja policije i rizik / Ризик / Ponderi / Лабораторија",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Ризик / Ponderi / Лабораторија.",
                },
                drugAdvancedHeatRiskWeightsPlayer = {
                    label = "Pažnja policije i rizik / Ризик / Ponderi / Играч",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Ризик / Ponderi / Играч.",
                },
                drugAdvancedHeatRiskWeightsRoute = {
                    label = "Pažnja policije i rizik / Ризик / Ponderi / Рута",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Ризик / Ponderi / Рута.",
                },
                drugAdvancedHeatRiskWeightsZone = {
                    label = "Pažnja policije i rizik / Ризик / Ponderi / Зона",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Ризик / Ponderi / Зона.",
                },
                drugAdvancedHeatRotateBurnerReduction = {
                    label = "Pažnja policije i rizik / Promeni telefon za jednokratnu upotrebu / Smanjenje",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Promeni telefon za jednokratnu upotrebu / Smanjenje.",
                },
                drugAdvancedHeatRouteControlMinutes = {
                    label = "Pažnja policije i rizik / Рута / Контрола / Minuti",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Рута / Контрола / Minuti.",
                },
                drugAdvancedHeatSaleHeatBatch = {
                    label = "Pažnja policije i rizik / Prodaja / Policijski pritisak / Серија",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Prodaja / Policijski pritisak / Серија.",
                },
                drugAdvancedHeatSaleHeatCamper = {
                    label = "Pažnja policije i rizik / Prodaja / Policijski pritisak / Кампер",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Prodaja / Policijski pritisak / Кампер.",
                },
                drugAdvancedHeatSaleHeatDealer = {
                    label = "Pažnja policije i rizik / Prodaja / Policijski pritisak / Дилер",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Prodaja / Policijski pritisak / Дилер.",
                },
                drugAdvancedHeatSaleHeatFaction = {
                    label = "Pažnja policije i rizik / Prodaja / Policijski pritisak / Фракција",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Prodaja / Policijski pritisak / Фракција.",
                },
                drugAdvancedHeatSaleHeatHub = {
                    label = "Pažnja policije i rizik / Prodaja / Policijski pritisak / Distributivni centar",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Prodaja / Policijski pritisak / Distributivni centar.",
                },
                drugAdvancedHeatSaleHeatLab = {
                    label = "Pažnja policije i rizik / Prodaja / Policijski pritisak / Лабораторија",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Prodaja / Policijski pritisak / Лабораторија.",
                },
                drugAdvancedHeatSaleHeatPlayer = {
                    label = "Pažnja policije i rizik / Prodaja / Policijski pritisak / Играч",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Prodaja / Policijski pritisak / Играч.",
                },
                drugAdvancedHeatSaleHeatRoute = {
                    label = "Pažnja policije i rizik / Prodaja / Policijski pritisak / Рута",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Prodaja / Policijski pritisak / Рута.",
                },
                drugAdvancedHeatSaleHeatZone = {
                    label = "Pažnja policije i rizik / Prodaja / Policijski pritisak / Зона",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Prodaja / Policijski pritisak / Зона.",
                },
                drugAdvancedHeatThresholdsCritical = {
                    label = "Pažnja policije i rizik / Pragovi / Критично",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Pragovi / Критично.",
                },
                drugAdvancedHeatThresholdsHigh = {
                    label = "Pažnja policije i rizik / Pragovi / Висок",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Pragovi / Висок.",
                },
                drugAdvancedHeatThresholdsLockdown = {
                    label = "Pažnja policije i rizik / Pragovi / Затворено",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Pragovi / Затворено.",
                },
                drugAdvancedHeatThresholdsLow = {
                    label = "Pažnja policije i rizik / Pragovi / Низак",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Pragovi / Низак.",
                },
                drugAdvancedHeatThresholdsMedium = {
                    label = "Pažnja policije i rizik / Pragovi / Средњи",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Pragovi / Средњи.",
                },
                drugAdvancedHeatTickMinutes = {
                    label = "Pažnja policije i rizik / Ciklus ažuriranja / Minuti",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Ciklus ažuriranja / Minuti.",
                },
                drugAdvancedHeatWholesaleHeatMultiplier = {
                    label = "Pažnja policije i rizik / Велико продавање / Policijski pritisak / Množilac",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Велико продавање / Policijski pritisak / Množilac.",
                },
                drugAdvancedHeatWorkerLeakAlertRadius = {
                    label = "Pažnja policije i rizik / Запослени / Curenje informacija / Радијус аларма",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Радијус аларма.",
                },
                drugAdvancedHeatWorkerLeakBaseChance = {
                    label = "Pažnja policije i rizik / Запослени / Curenje informacija / Osnovna vrednost / Могућа",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Osnovna vrednost / Могућа.",
                },
                drugAdvancedHeatWorkerLeakFactionMultiplier = {
                    label = "Pažnja policije i rizik / Запослени / Curenje informacija / Фракција / Množilac",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Фракција / Množilac.",
                },
                drugAdvancedHeatWorkerLeakHighSeverityThreshold = {
                    label = "Pažnja policije i rizik / Запослени / Curenje informacija / Висок / Ozbiljnost / Prag",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Висок / Ozbiljnost / Prag.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Pažnja policije i rizik / Запослени / Curenje informacija / Лојалност / Могућа / Množilac",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Лојалност / Могућа / Množilac.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyThreshold = {
                    label = "Pažnja policije i rizik / Запослени / Curenje informacija / Лојалност / Prag",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Лојалност / Prag.",
                },
                drugAdvancedHeatWorkerLeakMaximumChance = {
                    label = "Pažnja policije i rizik / Запослени / Curenje informacija / Maksimum / Могућа",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Maksimum / Могућа.",
                },
                drugAdvancedHeatWorkerLeakMinimumCooldownSeconds = {
                    label = "Pažnja policije i rizik / Запослени / Curenje informacija / Minimum / Време паузе (секунде)",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Minimum / Време паузе (секунде).",
                },
                drugAdvancedHeatWorkerLeakRouteMultiplier = {
                    label = "Pažnja policije i rizik / Запослени / Curenje informacija / Рута / Množilac",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Рута / Množilac.",
                },
                drugAdvancedHeatWorkerLeakStrengthMaximum = {
                    label = "Pažnja policije i rizik / Запослени / Curenje informacija / Jačina / Maksimum",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Jačina / Maksimum.",
                },
                drugAdvancedHeatWorkerLeakStrengthMinimum = {
                    label = "Pažnja policije i rizik / Запослени / Curenje informacija / Jačina / Minimum",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Jačina / Minimum.",
                },
                drugAdvancedHeatWorkerLeakStrengthMultiplier = {
                    label = "Pažnja policije i rizik / Запослени / Curenje informacija / Jačina / Množilac",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Jačina / Množilac.",
                },
                drugAdvancedHeatWorkerLeakStressChanceMultiplier = {
                    label = "Pažnja policije i rizik / Запослени / Curenje informacija / Стрес / Могућа / Množilac",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Стрес / Могућа / Množilac.",
                },
                drugAdvancedHeatWorkerLeakStressThreshold = {
                    label = "Pažnja policije i rizik / Запослени / Curenje informacija / Стрес / Prag",
                    description = "Podešavanje rada za: Pažnja policije i rizik / Запослени / Curenje informacija / Стрес / Prag.",
                },
                drugAdvancedContactNetworkActionCooldownSeconds = {
                    label = "Mreža kontakata / Хладноће акције / секунд",
                    description = "Podešavanje rada za: Mreža kontakata / Хладноће акције / секунд.",
                },
                drugAdvancedContactNetworkActiveHotspotCount = {
                    label = "Mreža kontakata / Broj aktivnih žarišta",
                    description = "Podešavanje rada za: Mreža kontakata / Broj aktivnih žarišta.",
                },
                drugAdvancedContactNetworkBurnerHintTrust = {
                    label = "Mreža kontakata / Савет за једнократни телефон / Повјерење",
                    description = "Podešavanje rada za: Mreža kontakata / Савет за једнократни телефон / Повјерење.",
                },
                drugAdvancedContactNetworkBurnerOfferMaximumMultiplier = {
                    label = "Mreža kontakata / Telefon za jednokratnu upotrebu / Ponuda / Maksimum / Množilac",
                    description = "Podešavanje rada za: Mreža kontakata / Telefon za jednokratnu upotrebu / Ponuda / Maksimum / Množilac.",
                },
                drugAdvancedContactNetworkBurnerOfferMinimumMultiplier = {
                    label = "Mreža kontakata / Telefon za jednokratnu upotrebu / Ponuda / Minimum / Množilac",
                    description = "Podešavanje rada za: Mreža kontakata / Telefon za jednokratnu upotrebu / Ponuda / Minimum / Množilac.",
                },
                drugAdvancedContactNetworkBuyerCooldownMinutes = {
                    label = "Mreža kontakata / Купац / Minuti pauze",
                    description = "Podešavanje rada za: Mreža kontakata / Купац / Minuti pauze.",
                },
                drugAdvancedContactNetworkBuyerDeliveryDistance = {
                    label = "Mreža kontakata / Купац / Udaljenost dostave",
                    description = "Podešavanje rada za: Mreža kontakata / Купац / Udaljenost dostave.",
                },
                drugAdvancedContactNetworkBuyerPremiumSuccessScore = {
                    label = "Mreža kontakata / Купац / Премиум / Uspeh / Поени",
                    description = "Podešavanje rada za: Mreža kontakata / Купац / Премиум / Uspeh / Поени.",
                },
                drugAdvancedContactNetworkBuyerPremiumTrustGain = {
                    label = "Mreža kontakata / Купац / Премиум / Повјерење / принос",
                    description = "Podešavanje rada za: Mreža kontakata / Купац / Премиум / Повјерење / принос.",
                },
                drugAdvancedContactNetworkBuyerRequestHeatRiskWeight = {
                    label = "Mreža kontakata / Купац / Zahtev / Притисак и ризик / Тежина",
                    description = "Podešavanje rada za: Mreža kontakata / Купац / Zahtev / Притисак и ризик / Тежина.",
                },
                drugAdvancedContactNetworkBuyerStandardTrustGain = {
                    label = "Mreža kontakata / Купац / Стандард / Повјерење / принос",
                    description = "Podešavanje rada za: Mreža kontakata / Купац / Стандард / Повјерење / принос.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMax = {
                    label = "Mreža kontakata / Čekanje na aktivaciju kontakta / секунд / Maksimum",
                    description = "Podešavanje rada za: Mreža kontakata / Čekanje na aktivaciju kontakta / секунд / Maksimum.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMin = {
                    label = "Mreža kontakata / Čekanje na aktivaciju kontakta / секунд / Minimum",
                    description = "Podešavanje rada za: Mreža kontakata / Čekanje na aktivaciju kontakta / секунд / Minimum.",
                },
                drugAdvancedContactNetworkContactDemandRangeMax = {
                    label = "Mreža kontakata / Контакт / Захтев / Raspon vrednosti / Maksimum",
                    description = "Podešavanje rada za: Mreža kontakata / Контакт / Захтев / Raspon vrednosti / Maksimum.",
                },
                drugAdvancedContactNetworkContactDemandRangeMin = {
                    label = "Mreža kontakata / Контакт / Захтев / Raspon vrednosti / Minimum",
                    description = "Podešavanje rada za: Mreža kontakata / Контакт / Захтев / Raspon vrednosti / Minimum.",
                },
                drugAdvancedContactNetworkContactLossTrust = {
                    label = "Mreža kontakata / Контакт / Губитак / Повјерење",
                    description = "Podešavanje rada za: Mreža kontakata / Контакт / Губитак / Повјерење.",
                },
                drugAdvancedContactNetworkDarknetExactIntelMinutes = {
                    label = "Mreža kontakata / Darknet / Tačne informacije / Minuti",
                    description = "Podešavanje rada za: Mreža kontakata / Darknet / Tačne informacije / Minuti.",
                },
                drugAdvancedContactNetworkDarknetHotspotIntelPrice = {
                    label = "Mreža kontakata / Darknet / Žarište / Obaveštajni podaci / Цена",
                    description = "Podešavanje rada za: Mreža kontakata / Darknet / Žarište / Obaveštajni podaci / Цена.",
                },
                drugAdvancedContactNetworkDarknetIntelPrice = {
                    label = "Mreža kontakata / Darknet / Obaveštajni podaci / Цена",
                    description = "Podešavanje rada za: Mreža kontakata / Darknet / Obaveštajni podaci / Цена.",
                },
                drugAdvancedContactNetworkDealerBasePrice = {
                    label = "Mreža kontakata / Дилер / Базна цена",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Базна цена.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMax = {
                    label = "Mreža kontakata / Дилер / Zapošljavanje / Капацитет / Maksimum",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Zapošljavanje / Капацитет / Maksimum.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMin = {
                    label = "Mreža kontakata / Дилер / Zapošljavanje / Капацитет / Minimum",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Zapošljavanje / Капацитет / Minimum.",
                },
                drugAdvancedContactNetworkDealerHireRiskMax = {
                    label = "Mreža kontakata / Дилер / Zapošljavanje / Ризик / Maksimum",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Zapošljavanje / Ризик / Maksimum.",
                },
                drugAdvancedContactNetworkDealerHireRiskMin = {
                    label = "Mreža kontakata / Дилер / Zapošljavanje / Ризик / Minimum",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Zapošljavanje / Ризик / Minimum.",
                },
                drugAdvancedContactNetworkDealerHireSkillMax = {
                    label = "Mreža kontakata / Дилер / Zapošljavanje / Вештина / Maksimum",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Zapošljavanje / Вештина / Maksimum.",
                },
                drugAdvancedContactNetworkDealerHireSkillMin = {
                    label = "Mreža kontakata / Дилер / Zapošljavanje / Вештина / Minimum",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Zapošljavanje / Вештина / Minimum.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Id = {
                    label = "Mreža kontakata / Понуде дилера / 1 / ID",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 1 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Item = {
                    label = "Mreža kontakata / Понуде дилера / 1 / Predmet",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 1 / Predmet.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Label = {
                    label = "Mreža kontakata / Понуде дилера / 1 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 1 / Назив.",
                },
                drugAdvancedContactNetworkDealerOffersItem1MinTrust = {
                    label = "Mreža kontakata / Понуде дилера / 1 / Минимално поверење",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 1 / Минимално поверење.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Price = {
                    label = "Mreža kontakata / Понуде дилера / 1 / Цена",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 1 / Цена.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Id = {
                    label = "Mreža kontakata / Понуде дилера / 2 / ID",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 2 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Item = {
                    label = "Mreža kontakata / Понуде дилера / 2 / Predmet",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 2 / Predmet.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Label = {
                    label = "Mreža kontakata / Понуде дилера / 2 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 2 / Назив.",
                },
                drugAdvancedContactNetworkDealerOffersItem2MinTrust = {
                    label = "Mreža kontakata / Понуде дилера / 2 / Минимално поверење",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 2 / Минимално поверење.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Price = {
                    label = "Mreža kontakata / Понуде дилера / 2 / Цена",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 2 / Цена.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Id = {
                    label = "Mreža kontakata / Понуде дилера / 3 / ID",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 3 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Item = {
                    label = "Mreža kontakata / Понуде дилера / 3 / Predmet",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 3 / Predmet.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Label = {
                    label = "Mreža kontakata / Понуде дилера / 3 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 3 / Назив.",
                },
                drugAdvancedContactNetworkDealerOffersItem3MinTrust = {
                    label = "Mreža kontakata / Понуде дилера / 3 / Минимално поверење",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 3 / Минимално поверење.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Price = {
                    label = "Mreža kontakata / Понуде дилера / 3 / Цена",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 3 / Цена.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Id = {
                    label = "Mreža kontakata / Понуде дилера / 4 / ID",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 4 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Item = {
                    label = "Mreža kontakata / Понуде дилера / 4 / Predmet",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 4 / Predmet.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Label = {
                    label = "Mreža kontakata / Понуде дилера / 4 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 4 / Назив.",
                },
                drugAdvancedContactNetworkDealerOffersItem4MinTrust = {
                    label = "Mreža kontakata / Понуде дилера / 4 / Минимално поверење",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 4 / Минимално поверење.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Price = {
                    label = "Mreža kontakata / Понуде дилера / 4 / Цена",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 4 / Цена.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Id = {
                    label = "Mreža kontakata / Понуде дилера / 5 / ID",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 5 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Item = {
                    label = "Mreža kontakata / Понуде дилера / 5 / Predmet",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 5 / Predmet.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Label = {
                    label = "Mreža kontakata / Понуде дилера / 5 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 5 / Назив.",
                },
                drugAdvancedContactNetworkDealerOffersItem5MinTrust = {
                    label = "Mreža kontakata / Понуде дилера / 5 / Минимално поверење",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 5 / Минимално поверење.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Price = {
                    label = "Mreža kontakata / Понуде дилера / 5 / Цена",
                    description = "Podešavanje rada za: Mreža kontakata / Понуде дилера / 5 / Цена.",
                },
                drugAdvancedContactNetworkDealerProtectionHours = {
                    label = "Mreža kontakata / Дилер / Zaštita / Sati",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Zaštita / Sati.",
                },
                drugAdvancedContactNetworkDealerProtectionPrice = {
                    label = "Mreža kontakata / Дилер / Zaštita / Цена",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Zaštita / Цена.",
                },
                drugAdvancedContactNetworkDealerSaleMax = {
                    label = "Mreža kontakata / Дилер / Prodaja / Maksimum",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Prodaja / Maksimum.",
                },
                drugAdvancedContactNetworkDealerSaleMin = {
                    label = "Mreža kontakata / Дилер / Prodaja / Minimum",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Prodaja / Minimum.",
                },
                drugAdvancedContactNetworkDealerSimulationAggressivePriceMultiplier = {
                    label = "Mreža kontakata / Дилер / Симулација / Agresivni režim / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Agresivni režim / Мноилац цене.",
                },
                drugAdvancedContactNetworkDealerSimulationBaseQualityPriceFactor = {
                    label = "Mreža kontakata / Дилер / Симулација / Osnovni kvalitet / Фактор цене",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Osnovni kvalitet / Фактор цене.",
                },
                drugAdvancedContactNetworkDealerSimulationBulkPriceMultiplier = {
                    label = "Mreža kontakata / Дилер / Симулација / Велика количина / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Велика количина / Мноилац цене.",
                },
                drugAdvancedContactNetworkDealerSimulationCheapPriceMultiplier = {
                    label = "Mreža kontakata / Дилер / Симулација / Jeftine prodaje / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Jeftine prodaje / Мноилац цене.",
                },
                drugAdvancedContactNetworkDealerSimulationDefaultQuality = {
                    label = "Mreža kontakata / Дилер / Симулација / Podrazumevana vrednost / Квалитет",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Podrazumevana vrednost / Квалитет.",
                },
                drugAdvancedContactNetworkDealerSimulationDisloyalThreshold = {
                    label = "Mreža kontakata / Дилер / Симулација / Prag nelojalnosti",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Prag nelojalnosti.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerLevel = {
                    label = "Mreža kontakata / Дилер / Симулација / Iskustvo / Po nivou",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Iskustvo / Po nivou.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerUnit = {
                    label = "Mreža kontakata / Дилер / Симулација / Iskustvo / Po jedinici",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Iskustvo / Po jedinici.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentLoyaltyLoss = {
                    label = "Mreža kontakata / Дилер / Симулација / Incident / Лојалност / Губитак",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Incident / Лојалност / Губитак.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentRollMaximum = {
                    label = "Mreža kontakata / Дилер / Симулација / Incident / Nasumična provera / Maksimum",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Incident / Nasumična provera / Maksimum.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelPriceBonus = {
                    label = "Mreža kontakata / Дилер / Симулација / Ниво / Цена / Бонус",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Ниво / Цена / Бонус.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelSaleDivisor = {
                    label = "Mreža kontakata / Дилер / Симулација / Ниво / Prodaja / Delilac",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Ниво / Prodaja / Delilac.",
                },
                drugAdvancedContactNetworkDealerSimulationLoyaltyRiskWeight = {
                    label = "Mreža kontakata / Дилер / Симулација / Лојалност / Ризик / Тежина",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Лојалност / Ризик / Тежина.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumIncidentChance = {
                    label = "Mreža kontakata / Дилер / Симулација / Maksimum / Incident / Могућа",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Maksimum / Incident / Могућа.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumLevel = {
                    label = "Mreža kontakata / Дилер / Симулација / Maksimum / Ниво",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Maksimum / Ниво.",
                },
                drugAdvancedContactNetworkDealerSimulationPremiumPriceMultiplier = {
                    label = "Mreža kontakata / Дилер / Симулација / Премиум / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Премиум / Мноилац цене.",
                },
                drugAdvancedContactNetworkDealerSimulationProfileRiskWeight = {
                    label = "Mreža kontakata / Дилер / Симулација / Профил / Ризик / Тежина",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Профил / Ризик / Тежина.",
                },
                drugAdvancedContactNetworkDealerSimulationProtectionRiskReduction = {
                    label = "Mreža kontakata / Дилер / Симулација / Zaštita / Ризик / Smanjenje",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Zaštita / Ризик / Smanjenje.",
                },
                drugAdvancedContactNetworkDealerSimulationQualityPriceDivisor = {
                    label = "Mreža kontakata / Дилер / Симулација / Квалитет / Цена / Delilac",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Квалитет / Цена / Delilac.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryBaseChance = {
                    label = "Mreža kontakata / Дилер / Симулација / Oporavak / Osnovna vrednost / Могућа",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Oporavak / Osnovna vrednost / Могућа.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryLoyaltyWeight = {
                    label = "Mreža kontakata / Дилер / Симулација / Oporavak / Лојалност / Тежина",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Oporavak / Лојалност / Тежина.",
                },
                drugAdvancedContactNetworkDealerSimulationRobbedStockLoss = {
                    label = "Mreža kontakata / Дилер / Симулација / Gubitak zaliha zbog pljačke",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Gubitak zaliha zbog pljačke.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillRiskReduction = {
                    label = "Mreža kontakata / Дилер / Симулација / Вештина / Ризик / Smanjenje",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Вештина / Ризик / Smanjenje.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillSaleDivisor = {
                    label = "Mreža kontakata / Дилер / Симулација / Вештина / Prodaja / Delilac",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Вештина / Prodaja / Delilac.",
                },
                drugAdvancedContactNetworkDealerSimulationStableLoyaltyThreshold = {
                    label = "Mreža kontakata / Дилер / Симулација / Prag stabilne lojalnosti",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Prag stabilne lojalnosti.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryPriceMultiplier = {
                    label = "Mreža kontakata / Дилер / Симулација / Teritorija / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Teritorija / Мноилац цене.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryRiskReduction = {
                    label = "Mreža kontakata / Дилер / Симулација / Teritorija / Ризик / Smanjenje",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Симулација / Teritorija / Ризик / Smanjenje.",
                },
                drugAdvancedContactNetworkDealerTickMinutes = {
                    label = "Mreža kontakata / Дилер / Ciklus ažuriranja / Minuti",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Ciklus ažuriranja / Minuti.",
                },
                drugAdvancedContactNetworkDealerWage = {
                    label = "Mreža kontakata / Дилер / Плат",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Плат.",
                },
                drugAdvancedContactNetworkDealerWageDecay = {
                    label = "Mreža kontakata / Дилер / Плат / Отуђење",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Плат / Отуђење.",
                },
                drugAdvancedContactNetworkDealerWageLoyaltyGain = {
                    label = "Mreža kontakata / Дилер / Плат / Лојалност / принос",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Плат / Лојалност / принос.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem1 = {
                    label = "Mreža kontakata / Дилер / Slabosti / 1",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Slabosti / 1.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem2 = {
                    label = "Mreža kontakata / Дилер / Slabosti / 2",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Slabosti / 2.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem3 = {
                    label = "Mreža kontakata / Дилер / Slabosti / 3",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Slabosti / 3.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem4 = {
                    label = "Mreža kontakata / Дилер / Slabosti / 4",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Slabosti / 4.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem5 = {
                    label = "Mreža kontakata / Дилер / Slabosti / 5",
                    description = "Podešavanje rada za: Mreža kontakata / Дилер / Slabosti / 5.",
                },
                drugAdvancedContactNetworkDefaultContactDemand = {
                    label = "Mreža kontakata / Podrazumevana vrednost / Контакт / Захтев",
                    description = "Podešavanje rada za: Mreža kontakata / Podrazumevana vrednost / Контакт / Захтев.",
                },
                drugAdvancedContactNetworkDefaultContactRisk = {
                    label = "Mreža kontakata / Podrazumevana vrednost / Контакт / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Podrazumevana vrednost / Контакт / Ризик.",
                },
                drugAdvancedContactNetworkDefaultDealerCapacity = {
                    label = "Mreža kontakata / Podrazumevani diler / Капацитет",
                    description = "Podešavanje rada za: Mreža kontakata / Podrazumevani diler / Капацитет.",
                },
                drugAdvancedContactNetworkDefaultDealerRisk = {
                    label = "Mreža kontakata / Podrazumevani diler / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Podrazumevani diler / Ризик.",
                },
                drugAdvancedContactNetworkDefaultDealerSkill = {
                    label = "Mreža kontakata / Podrazumevani diler / Вештина",
                    description = "Podešavanje rada za: Mreža kontakata / Podrazumevani diler / Вештина.",
                },
                drugAdvancedContactNetworkDefaultHotspotRadius = {
                    label = "Mreža kontakata / Podrazumevana vrednost / Žarište / Радијус",
                    description = "Podešavanje rada za: Mreža kontakata / Podrazumevana vrednost / Žarište / Радијус.",
                },
                drugAdvancedContactNetworkDemandResetMinutes = {
                    label = "Mreža kontakata / Ресет потражње (минута)",
                    description = "Podešavanje rada za: Mreža kontakata / Ресет потражње (минута).",
                },
                drugAdvancedContactNetworkEnabled = {
                    label = "Mreža kontakata / Омогућено",
                    description = "Podešavanje rada za: Mreža kontakata / Омогућено.",
                },
                drugAdvancedContactNetworkExactLocationTrust = {
                    label = "Mreža kontakata / Tačna lokacija / Повјерење",
                    description = "Podešavanje rada za: Mreža kontakata / Tačna lokacija / Повјерење.",
                },
                drugAdvancedContactNetworkFactionDiscoveryReputation = {
                    label = "Mreža kontakata / Фракција / Otkrivanje / Репутација",
                    description = "Podešavanje rada za: Mreža kontakata / Фракција / Otkrivanje / Репутација.",
                },
                drugAdvancedContactNetworkFactionHintTrust = {
                    label = "Mreža kontakata / Фракција / Nagoveštaj / Повјерење",
                    description = "Podešavanje rada za: Mreža kontakata / Фракција / Nagoveštaj / Повјерење.",
                },
                drugAdvancedContactNetworkFailedDeliveryCooldownMinutes = {
                    label = "Mreža kontakata / Neuspela dostava / Minuti pauze",
                    description = "Podešavanje rada za: Mreža kontakata / Neuspela dostava / Minuti pauze.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerCount = {
                    label = "Mreža kontakata / Lažni posao / Susret / Napadač / Broj",
                    description = "Podešavanje rada za: Mreža kontakata / Lažni posao / Susret / Napadač / Broj.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem1 = {
                    label = "Mreža kontakata / Lažni posao / Susret / Napadač / Modeli / 1",
                    description = "Podešavanje rada za: Mreža kontakata / Lažni posao / Susret / Napadač / Modeli / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem2 = {
                    label = "Mreža kontakata / Lažni posao / Susret / Napadač / Modeli / 2",
                    description = "Podešavanje rada za: Mreža kontakata / Lažni posao / Susret / Napadač / Modeli / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem3 = {
                    label = "Mreža kontakata / Lažni posao / Susret / Napadač / Modeli / 3",
                    description = "Podešavanje rada za: Mreža kontakata / Lažni posao / Susret / Napadač / Modeli / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterDurationSeconds = {
                    label = "Mreža kontakata / Lažni posao / Susret / Трајање (секунде)",
                    description = "Podešavanje rada za: Mreža kontakata / Lažni posao / Susret / Трајање (секунде).",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem1 = {
                    label = "Mreža kontakata / Lažni posao / Susret / Policija / Modeli / 1",
                    description = "Podešavanje rada za: Mreža kontakata / Lažni posao / Susret / Policija / Modeli / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem2 = {
                    label = "Mreža kontakata / Lažni posao / Susret / Policija / Modeli / 2",
                    description = "Podešavanje rada za: Mreža kontakata / Lažni posao / Susret / Policija / Modeli / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem3 = {
                    label = "Mreža kontakata / Lažni posao / Susret / Policija / Modeli / 3",
                    description = "Podešavanje rada za: Mreža kontakata / Lažni posao / Susret / Policija / Modeli / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterSpawnRadius = {
                    label = "Mreža kontakata / Lažni posao / Susret / Радијус појављивања",
                    description = "Podešavanje rada za: Mreža kontakata / Lažni posao / Susret / Радијус појављивања.",
                },
                drugAdvancedContactNetworkFallbackPreferredDrug = {
                    label = "Mreža kontakata / Zamenska vrednost / Препоручени лек",
                    description = "Podešavanje rada za: Mreža kontakata / Zamenska vrednost / Препоручени лек.",
                },
                drugAdvancedContactNetworkFallbackProductLabel = {
                    label = "Mreža kontakata / Zamenska vrednost / Назив производа",
                    description = "Podešavanje rada za: Mreža kontakata / Zamenska vrednost / Назив производа.",
                },
                drugAdvancedContactNetworkGuideBookItem = {
                    label = "Mreža kontakata / Vodič / Knjiga / Predmet",
                    description = "Podešavanje rada za: Mreža kontakata / Vodič / Knjiga / Predmet.",
                },
                drugAdvancedContactNetworkGuideBookTrust = {
                    label = "Mreža kontakata / Vodič / Knjiga / Повјерење",
                    description = "Podešavanje rada za: Mreža kontakata / Vodič / Knjiga / Повјерење.",
                },
                drugAdvancedContactNetworkHireDealerPrice = {
                    label = "Mreža kontakata / Ангажуј дилера / Цена",
                    description = "Podešavanje rada za: Mreža kontakata / Ангажуј дилера / Цена.",
                },
                drugAdvancedContactNetworkHistoryLimit = {
                    label = "Mreža kontakata / Лимит историје",
                    description = "Podešavanje rada za: Mreža kontakata / Лимит историје.",
                },
                drugAdvancedContactNetworkHotspotIntelMinutes = {
                    label = "Mreža kontakata / Žarište / Obaveštajni podaci / Minuti",
                    description = "Podešavanje rada za: Mreža kontakata / Žarište / Obaveštajni podaci / Minuti.",
                },
                drugAdvancedContactNetworkHotspotRotationMinutes = {
                    label = "Mreža kontakata / Žarište / Rotacija / Minuti",
                    description = "Podešavanje rada za: Mreža kontakata / Žarište / Rotacija / Minuti.",
                },
                drugAdvancedContactNetworkListingDurationMinutes = {
                    label = "Mreža kontakata / Oglas / Трајање / Minuti",
                    description = "Podešavanje rada za: Mreža kontakata / Oglas / Трајање / Minuti.",
                },
                drugAdvancedContactNetworkMaxOwnedDealers = {
                    label = "Mreža kontakata / Maksimum / У власништву / Дилери",
                    description = "Podešavanje rada za: Mreža kontakata / Maksimum / У власништву / Дилери.",
                },
                drugAdvancedContactNetworkMinimumBuyerDeliveryDistance = {
                    label = "Mreža kontakata / Minimum / Купац / Udaljenost dostave",
                    description = "Podešavanje rada za: Mreža kontakata / Minimum / Купац / Udaljenost dostave.",
                },
                drugAdvancedContactNetworkMinimumContactRotationMinutes = {
                    label = "Mreža kontakata / Minimum / Ротација контаката (минута)",
                    description = "Podešavanje rada za: Mreža kontakata / Minimum / Ротација контаката (минута).",
                },
                drugAdvancedContactNetworkMinimumDemandResetMinutes = {
                    label = "Mreža kontakata / Minimum / Ресет потражње (минута)",
                    description = "Podešavanje rada za: Mreža kontakata / Minimum / Ресет потражње (минута).",
                },
                drugAdvancedContactNetworkMinimumHeatMultiplier = {
                    label = "Mreža kontakata / Minimum / Policijski pritisak / Množilac",
                    description = "Podešavanje rada za: Mreža kontakata / Minimum / Policijski pritisak / Množilac.",
                },
                drugAdvancedContactNetworkMinimumHotspotIntelMinutes = {
                    label = "Mreža kontakata / Minimum / Žarište / Obaveštajni podaci / Minuti",
                    description = "Podešavanje rada za: Mreža kontakata / Minimum / Žarište / Obaveštajni podaci / Minuti.",
                },
                drugAdvancedContactNetworkMinimumHotspotRadius = {
                    label = "Mreža kontakata / Minimum / Žarište / Радијус",
                    description = "Podešavanje rada za: Mreža kontakata / Minimum / Žarište / Радијус.",
                },
                drugAdvancedContactNetworkMinimumHotspotRotationMinutes = {
                    label = "Mreža kontakata / Minimum / Žarište / Rotacija / Minuti",
                    description = "Podešavanje rada za: Mreža kontakata / Minimum / Žarište / Rotacija / Minuti.",
                },
                drugAdvancedContactNetworkMinimumListingDurationMinutes = {
                    label = "Mreža kontakata / Minimum / Oglas / Трајање / Minuti",
                    description = "Podešavanje rada za: Mreža kontakata / Minimum / Oglas / Трајање / Minuti.",
                },
                drugAdvancedContactNetworkMinimumRewardMultiplier = {
                    label = "Mreža kontakata / Минимална награда / Množilac",
                    description = "Podešavanje rada za: Mreža kontakata / Минимална награда / Množilac.",
                },
                drugAdvancedContactNetworkMinimumRobberyMultiplier = {
                    label = "Mreža kontakata / Minimum / Крађа / Množilac",
                    description = "Podešavanje rada za: Mreža kontakata / Minimum / Крађа / Množilac.",
                },
                drugAdvancedContactNetworkMinimumSpotPriceMultiplier = {
                    label = "Mreža kontakata / Minimum / Lokacija / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Minimum / Lokacija / Мноилац цене.",
                },
                drugAdvancedContactNetworkOtherDrugPriceMultiplier = {
                    label = "Mreža kontakata / Drugo / Дрога / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Drugo / Дрога / Мноилац цене.",
                },
                drugAdvancedContactNetworkPaymentAccount = {
                    label = "Mreža kontakata / Начин за плаћање",
                    description = "Podešavanje rada za: Mreža kontakata / Начин за плаћање.",
                },
                drugAdvancedContactNetworkPostDeliveryDemandResetSeconds = {
                    label = "Mreža kontakata / Posle dostave / Захтев / Reset / секунд",
                    description = "Podešavanje rada za: Mreža kontakata / Posle dostave / Захтев / Reset / секунд.",
                },
                drugAdvancedContactNetworkPreferredDrugPriceMultiplier = {
                    label = "Mreža kontakata / Препоручени лек / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Препоручени лек / Мноилац цене.",
                },
                drugAdvancedContactNetworkRegionLocationTrust = {
                    label = "Mreža kontakata / Region / Локација / Повјерење",
                    description = "Podešavanje rada za: Mreža kontakata / Region / Локација / Повјерење.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMax = {
                    label = "Mreža kontakata / Zahtev / Količine / Велика количина / Maksimum",
                    description = "Podešavanje rada za: Mreža kontakata / Zahtev / Količine / Велика количина / Maksimum.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMin = {
                    label = "Mreža kontakata / Zahtev / Količine / Велика количина / Minimum",
                    description = "Podešavanje rada za: Mreža kontakata / Zahtev / Količine / Велика количина / Minimum.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMax = {
                    label = "Mreža kontakata / Zahtev / Količine / Премиум / Maksimum",
                    description = "Podešavanje rada za: Mreža kontakata / Zahtev / Količine / Премиум / Maksimum.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMin = {
                    label = "Mreža kontakata / Zahtev / Količine / Премиум / Minimum",
                    description = "Podešavanje rada za: Mreža kontakata / Zahtev / Količine / Премиум / Minimum.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMax = {
                    label = "Mreža kontakata / Zahtev / Količine / Стандард / Maksimum",
                    description = "Podešavanje rada za: Mreža kontakata / Zahtev / Količine / Стандард / Maksimum.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMin = {
                    label = "Mreža kontakata / Zahtev / Količine / Стандард / Minimum",
                    description = "Podešavanje rada za: Mreža kontakata / Zahtev / Količine / Стандард / Minimum.",
                },
                drugAdvancedContactNetworkRotationMinutes = {
                    label = "Mreža kontakata / Rotacija / Minuti",
                    description = "Podešavanje rada za: Mreža kontakata / Rotacija / Minuti.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 1 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 1 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 1 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 1 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 1 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 1 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 1 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 1 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 1 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 1 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 1 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 1 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 1 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 1 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 1 / Ризик.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 2 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 2 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 2 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 2 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 2 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 2 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 2 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 2 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 2 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 2 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 2 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 2 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 2 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 2 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 2 / Ризик.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 3 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 3 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 3 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 3 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 3 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 3 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 3 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 3 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 3 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 3 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 3 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 3 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 3 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 3 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Ulični diler / 3 / Ризик.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 1 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 1 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 1 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 1 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 1 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 1 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 1 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 1 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 1 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 1 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 1 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 1 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 1 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 1 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 1 / Ризик.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 2 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 2 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 2 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 2 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 2 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 2 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 2 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 2 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 2 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 2 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 2 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 2 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 2 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 2 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 2 / Ризик.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 3 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 3 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 3 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 3 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 3 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 3 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 3 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 3 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 3 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 3 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 3 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 3 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 3 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 3 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani kupac / 3 / Ризик.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 1 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 1 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 1 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 1 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 1 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 1 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 1 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 1 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 1 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 1 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 1 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 1 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 1 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 1 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 1 / Ризик.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 2 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 2 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 2 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 2 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 2 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 2 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 2 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 2 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 2 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 2 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 2 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 2 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 2 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 2 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 2 / Ризик.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 3 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 3 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 3 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 3 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 3 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 3 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 3 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 3 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 3 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 3 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 3 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 3 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 3 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 3 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Podrazumevani diler / 3 / Ризик.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 1 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 1 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 1 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 1 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 1 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 1 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 1 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 1 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 1 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 1 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 1 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 1 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 1 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 1 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 1 / Ризик.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 2 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 2 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 2 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 2 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 2 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 2 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 2 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 2 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 2 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 2 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 2 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 2 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 2 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 2 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 2 / Ризик.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 3 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 3 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 3 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 3 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 3 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 3 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 3 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 3 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 3 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 3 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 3 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 3 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 3 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 3 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Mrežni diler / 3 / Ризик.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 1 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 1 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 1 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 1 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 1 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 1 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 1 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 1 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 1 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 1 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 1 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 1 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 1 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 1 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 1 / Ризик.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 2 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 2 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 2 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 2 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 2 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 2 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 2 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 2 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 2 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 2 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 2 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 2 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 2 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 2 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 2 / Ризик.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 3 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 3 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 3 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 3 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 3 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 3 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 3 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 3 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 3 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 3 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 3 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 3 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 3 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 3 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Vrhunski posrednik / 3 / Ризик.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 1 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 1 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 1 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 1 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 1 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 1 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 1 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 1 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 1 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 1 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 1 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 1 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 1 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 1 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 1 / Ризик.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 2 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 2 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 2 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 2 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 2 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 2 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 2 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 2 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 2 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 2 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 2 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 2 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 2 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 2 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 2 / Ризик.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsX = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 3 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 3 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsY = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 3 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 3 / Koordinate / И.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsZ = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 3 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 3 / Koordinate / З.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsW = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 3 / Koordinate / W",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 3 / Koordinate / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Label = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 3 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 3 / Назив.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3PriceMultiplier = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 3 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 3 / Мноилац цене.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Region = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 3 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Risk = {
                    label = "Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 3 / Ризик",
                    description = "Podešavanje rada za: Mreža kontakata / Lokacija / Grupe za izbor / Veleprodajni kontakt / 3 / Ризик.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1AcceptBonus = {
                    label = "Mreža kontakata / Улица / Žarišta / 1 / Bonus za prihvatanje",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 1 / Bonus za prihvatanje.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Archetype = {
                    label = "Mreža kontakata / Улица / Žarišta / 1 / Arhetip",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 1 / Arhetip.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsX = {
                    label = "Mreža kontakata / Улица / Žarišta / 1 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 1 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsY = {
                    label = "Mreža kontakata / Улица / Žarišta / 1 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 1 / Koordinate / И.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsZ = {
                    label = "Mreža kontakata / Улица / Žarišta / 1 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 1 / Koordinate / З.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1DemandBonus = {
                    label = "Mreža kontakata / Улица / Žarišta / 1 / Бонус захтева",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 1 / Бонус захтева.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1HeatMultiplier = {
                    label = "Mreža kontakata / Улица / Žarišta / 1 / Policijski pritisak / Množilac",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 1 / Policijski pritisak / Množilac.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Id = {
                    label = "Mreža kontakata / Улица / Žarišta / 1 / ID",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 1 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Label = {
                    label = "Mreža kontakata / Улица / Žarišta / 1 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 1 / Назив.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem1 = {
                    label = "Mreža kontakata / Улица / Žarišta / 1 / Poželjne droge / 1",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 1 / Poželjne droge / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem2 = {
                    label = "Mreža kontakata / Улица / Žarišta / 1 / Poželjne droge / 2",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 1 / Poželjne droge / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem3 = {
                    label = "Mreža kontakata / Улица / Žarišta / 1 / Poželjne droge / 3",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 1 / Poželjne droge / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem4 = {
                    label = "Mreža kontakata / Улица / Žarišta / 1 / Poželjne droge / 4",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 1 / Poželjne droge / 4.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PriceMultiplier = {
                    label = "Mreža kontakata / Улица / Žarišta / 1 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 1 / Мноилац цене.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Radius = {
                    label = "Mreža kontakata / Улица / Žarišta / 1 / Радијус",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 1 / Радијус.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Region = {
                    label = "Mreža kontakata / Улица / Žarišta / 1 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 1 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1RobberyMultiplier = {
                    label = "Mreža kontakata / Улица / Žarišta / 1 / Крађа / Množilac",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 1 / Крађа / Množilac.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2AcceptBonus = {
                    label = "Mreža kontakata / Улица / Žarišta / 2 / Bonus za prihvatanje",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 2 / Bonus za prihvatanje.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Archetype = {
                    label = "Mreža kontakata / Улица / Žarišta / 2 / Arhetip",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 2 / Arhetip.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsX = {
                    label = "Mreža kontakata / Улица / Žarišta / 2 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 2 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsY = {
                    label = "Mreža kontakata / Улица / Žarišta / 2 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 2 / Koordinate / И.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsZ = {
                    label = "Mreža kontakata / Улица / Žarišta / 2 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 2 / Koordinate / З.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2DemandBonus = {
                    label = "Mreža kontakata / Улица / Žarišta / 2 / Бонус захтева",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 2 / Бонус захтева.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2HeatMultiplier = {
                    label = "Mreža kontakata / Улица / Žarišta / 2 / Policijski pritisak / Množilac",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 2 / Policijski pritisak / Množilac.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Id = {
                    label = "Mreža kontakata / Улица / Žarišta / 2 / ID",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 2 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Label = {
                    label = "Mreža kontakata / Улица / Žarišta / 2 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 2 / Назив.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2MinimumQuality = {
                    label = "Mreža kontakata / Улица / Žarišta / 2 / Минимални квалитет",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 2 / Минимални квалитет.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem1 = {
                    label = "Mreža kontakata / Улица / Žarišta / 2 / Poželjne droge / 1",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 2 / Poželjne droge / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem2 = {
                    label = "Mreža kontakata / Улица / Žarišta / 2 / Poželjne droge / 2",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 2 / Poželjne droge / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PriceMultiplier = {
                    label = "Mreža kontakata / Улица / Žarišta / 2 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 2 / Мноилац цене.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Radius = {
                    label = "Mreža kontakata / Улица / Žarišta / 2 / Радијус",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 2 / Радијус.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Region = {
                    label = "Mreža kontakata / Улица / Žarišta / 2 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 2 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2RobberyMultiplier = {
                    label = "Mreža kontakata / Улица / Žarišta / 2 / Крађа / Množilac",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 2 / Крађа / Množilac.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3AcceptBonus = {
                    label = "Mreža kontakata / Улица / Žarišta / 3 / Bonus za prihvatanje",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 3 / Bonus za prihvatanje.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Archetype = {
                    label = "Mreža kontakata / Улица / Žarišta / 3 / Arhetip",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 3 / Arhetip.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsX = {
                    label = "Mreža kontakata / Улица / Žarišta / 3 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 3 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsY = {
                    label = "Mreža kontakata / Улица / Žarišta / 3 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 3 / Koordinate / И.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsZ = {
                    label = "Mreža kontakata / Улица / Žarišta / 3 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 3 / Koordinate / З.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3DemandBonus = {
                    label = "Mreža kontakata / Улица / Žarišta / 3 / Бонус захтева",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 3 / Бонус захтева.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3HeatMultiplier = {
                    label = "Mreža kontakata / Улица / Žarišta / 3 / Policijski pritisak / Množilac",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 3 / Policijski pritisak / Množilac.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Id = {
                    label = "Mreža kontakata / Улица / Žarišta / 3 / ID",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 3 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Label = {
                    label = "Mreža kontakata / Улица / Žarišta / 3 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 3 / Назив.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem1 = {
                    label = "Mreža kontakata / Улица / Žarišta / 3 / Poželjne droge / 1",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 3 / Poželjne droge / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem2 = {
                    label = "Mreža kontakata / Улица / Žarišta / 3 / Poželjne droge / 2",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 3 / Poželjne droge / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem3 = {
                    label = "Mreža kontakata / Улица / Žarišta / 3 / Poželjne droge / 3",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 3 / Poželjne droge / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PriceMultiplier = {
                    label = "Mreža kontakata / Улица / Žarišta / 3 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 3 / Мноилац цене.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Radius = {
                    label = "Mreža kontakata / Улица / Žarišta / 3 / Радијус",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 3 / Радијус.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Region = {
                    label = "Mreža kontakata / Улица / Žarišta / 3 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 3 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3RobberyMultiplier = {
                    label = "Mreža kontakata / Улица / Žarišta / 3 / Крађа / Množilac",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 3 / Крађа / Množilac.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4AcceptBonus = {
                    label = "Mreža kontakata / Улица / Žarišta / 4 / Bonus za prihvatanje",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 4 / Bonus za prihvatanje.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Archetype = {
                    label = "Mreža kontakata / Улица / Žarišta / 4 / Arhetip",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 4 / Arhetip.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsX = {
                    label = "Mreža kontakata / Улица / Žarišta / 4 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 4 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsY = {
                    label = "Mreža kontakata / Улица / Žarišta / 4 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 4 / Koordinate / И.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsZ = {
                    label = "Mreža kontakata / Улица / Žarišta / 4 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 4 / Koordinate / З.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4DemandBonus = {
                    label = "Mreža kontakata / Улица / Žarišta / 4 / Бонус захтева",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 4 / Бонус захтева.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4HeatMultiplier = {
                    label = "Mreža kontakata / Улица / Žarišta / 4 / Policijski pritisak / Množilac",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 4 / Policijski pritisak / Množilac.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Id = {
                    label = "Mreža kontakata / Улица / Žarišta / 4 / ID",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 4 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Label = {
                    label = "Mreža kontakata / Улица / Žarišta / 4 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 4 / Назив.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem1 = {
                    label = "Mreža kontakata / Улица / Žarišta / 4 / Poželjne droge / 1",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 4 / Poželjne droge / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem2 = {
                    label = "Mreža kontakata / Улица / Žarišta / 4 / Poželjne droge / 2",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 4 / Poželjne droge / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem3 = {
                    label = "Mreža kontakata / Улица / Žarišta / 4 / Poželjne droge / 3",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 4 / Poželjne droge / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PriceMultiplier = {
                    label = "Mreža kontakata / Улица / Žarišta / 4 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 4 / Мноилац цене.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Radius = {
                    label = "Mreža kontakata / Улица / Žarišta / 4 / Радијус",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 4 / Радијус.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Region = {
                    label = "Mreža kontakata / Улица / Žarišta / 4 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 4 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4RobberyMultiplier = {
                    label = "Mreža kontakata / Улица / Žarišta / 4 / Крађа / Množilac",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 4 / Крађа / Množilac.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5AcceptBonus = {
                    label = "Mreža kontakata / Улица / Žarišta / 5 / Bonus za prihvatanje",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 5 / Bonus za prihvatanje.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Archetype = {
                    label = "Mreža kontakata / Улица / Žarišta / 5 / Arhetip",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 5 / Arhetip.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsX = {
                    label = "Mreža kontakata / Улица / Žarišta / 5 / Koordinate / Кс",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 5 / Koordinate / Кс.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsY = {
                    label = "Mreža kontakata / Улица / Žarišta / 5 / Koordinate / И",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 5 / Koordinate / И.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsZ = {
                    label = "Mreža kontakata / Улица / Žarišta / 5 / Koordinate / З",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 5 / Koordinate / З.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5DemandBonus = {
                    label = "Mreža kontakata / Улица / Žarišta / 5 / Бонус захтева",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 5 / Бонус захтева.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5HeatMultiplier = {
                    label = "Mreža kontakata / Улица / Žarišta / 5 / Policijski pritisak / Množilac",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 5 / Policijski pritisak / Množilac.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Id = {
                    label = "Mreža kontakata / Улица / Žarišta / 5 / ID",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 5 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Label = {
                    label = "Mreža kontakata / Улица / Žarišta / 5 / Назив",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 5 / Назив.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem1 = {
                    label = "Mreža kontakata / Улица / Žarišta / 5 / Poželjne droge / 1",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 5 / Poželjne droge / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem2 = {
                    label = "Mreža kontakata / Улица / Žarišta / 5 / Poželjne droge / 2",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 5 / Poželjne droge / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PriceMultiplier = {
                    label = "Mreža kontakata / Улица / Žarišta / 5 / Мноилац цене",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 5 / Мноилац цене.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Radius = {
                    label = "Mreža kontakata / Улица / Žarišta / 5 / Радијус",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 5 / Радијус.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Region = {
                    label = "Mreža kontakata / Улица / Žarišta / 5 / Region",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 5 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5RobberyMultiplier = {
                    label = "Mreža kontakata / Улица / Žarišta / 5 / Крађа / Množilac",
                    description = "Podešavanje rada za: Mreža kontakata / Улица / Žarišta / 5 / Крађа / Množilac.",
                },
                drugAdvancedContactNetworkTrustLevelsKnown = {
                    label = "Mreža kontakata / Повјерење / Nivoi / Poznato",
                    description = "Podešavanje rada za: Mreža kontakata / Повјерење / Nivoi / Poznato.",
                },
                drugAdvancedContactNetworkTrustLevelsReliable = {
                    label = "Mreža kontakata / Повјерење / Nivoi / Pouzdano",
                    description = "Podešavanje rada za: Mreža kontakata / Повјерење / Nivoi / Pouzdano.",
                },
                drugAdvancedContactNetworkTrustLevelsTrusted = {
                    label = "Mreža kontakata / Повјерење / Nivoi / Od poverenja",
                    description = "Podešavanje rada za: Mreža kontakata / Повјерење / Nivoi / Od poverenja.",
                },
                drugAdvancedBusinessNetworkActionCooldownSeconds = {
                    label = "Poslovna mreža / Хладноће акције / секунд",
                    description = "Podešavanje rada za: Poslovna mreža / Хладноће акције / секунд.",
                },
                drugAdvancedBusinessNetworkBalanceBaseUnitPrice = {
                    label = "Poslovna mreža / Баланс / Osnovna vrednost / Цена по јединици",
                    description = "Podešavanje rada za: Poslovna mreža / Баланс / Osnovna vrednost / Цена по јединици.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerDealer = {
                    label = "Poslovna mreža / Баланс / Топлина мреже / Po dileru",
                    description = "Podešavanje rada za: Poslovna mreža / Баланс / Топлина мреже / Po dileru.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerHub = {
                    label = "Poslovna mreža / Баланс / Топлина мреже / Po distributivnom centru",
                    description = "Podešavanje rada za: Poslovna mreža / Баланс / Топлина мреже / Po distributivnom centru.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerRoute = {
                    label = "Poslovna mreža / Баланс / Топлина мреже / Po ruti",
                    description = "Podešavanje rada za: Poslovna mreža / Баланс / Топлина мреже / Po ruti.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerStaff = {
                    label = "Poslovna mreža / Баланс / Топлина мреже / Po radniku",
                    description = "Podešavanje rada za: Poslovna mreža / Баланс / Топлина мреже / Po radniku.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityGain = {
                    label = "Poslovna mreža / Баланс / Поузданост / принос",
                    description = "Podešavanje rada za: Poslovna mreža / Баланс / Поузданост / принос.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityLoss = {
                    label = "Poslovna mreža / Баланс / Поузданост / Губитак",
                    description = "Podešavanje rada za: Poslovna mreža / Баланс / Поузданост / Губитак.",
                },
                drugAdvancedBusinessNetworkBalanceRouteHeatDecay = {
                    label = "Poslovna mreža / Баланс / Рута / Policijski pritisak / Отуђење",
                    description = "Podešavanje rada za: Poslovna mreža / Баланс / Рута / Policijski pritisak / Отуђење.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / банда / Износ / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / банда / Износ / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / банда / Износ / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / банда / Износ / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangMinRank = {
                    label = "Poslovna mreža / Уговори / Kategorije / банда / Minimum / Ранг",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / банда / Minimum / Ранг.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / банда / Квалитет / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / банда / Квалитет / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / банда / Квалитет / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / банда / Квалитет / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / банда / Награда / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / банда / Награда / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / банда / Награда / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / банда / Награда / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / банда / Ризик / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / банда / Ризик / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / банда / Ризик / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / банда / Ризик / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Износ / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Износ / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Износ / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Износ / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkMinRank = {
                    label = "Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Minimum / Ранг",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Minimum / Ранг.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Квалитет / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Квалитет / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Квалитет / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Квалитет / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Награда / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Награда / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Награда / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Награда / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Ризик / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Ризик / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Ризик / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / НПЦ мрежа / Ризик / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Organizacija / Износ / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Organizacija / Износ / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Organizacija / Износ / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Organizacija / Износ / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationMinRank = {
                    label = "Poslovna mreža / Уговори / Kategorije / Organizacija / Minimum / Ранг",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Organizacija / Minimum / Ранг.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Organizacija / Квалитет / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Organizacija / Квалитет / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Organizacija / Квалитет / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Organizacija / Квалитет / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Organizacija / Награда / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Organizacija / Награда / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Organizacija / Награда / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Organizacija / Награда / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Organizacija / Ризик / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Organizacija / Ризик / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Organizacija / Ризик / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Organizacija / Ризик / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Премиум / Износ / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Премиум / Износ / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Премиум / Износ / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Премиум / Износ / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumMinRank = {
                    label = "Poslovna mreža / Уговори / Kategorije / Премиум / Minimum / Ранг",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Премиум / Minimum / Ранг.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Премиум / Квалитет / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Премиум / Квалитет / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Премиум / Квалитет / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Премиум / Квалитет / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Премиум / Награда / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Премиум / Награда / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Премиум / Награда / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Премиум / Награда / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Премиум / Ризик / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Премиум / Ризик / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Премиум / Ризик / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Премиум / Ризик / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Пушер / Износ / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Пушер / Износ / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Пушер / Износ / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Пушер / Износ / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherMinRank = {
                    label = "Poslovna mreža / Уговори / Kategorije / Пушер / Minimum / Ранг",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Пушер / Minimum / Ранг.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Пушер / Квалитет / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Пушер / Квалитет / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Пушер / Квалитет / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Пушер / Квалитет / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Пушер / Награда / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Пушер / Награда / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Пушер / Награда / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Пушер / Награда / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Пушер / Ризик / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Пушер / Ризик / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Пушер / Ризик / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Пушер / Ризик / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Posebno / Износ / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Posebno / Износ / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Posebno / Износ / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Posebno / Износ / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialMinRank = {
                    label = "Poslovna mreža / Уговори / Kategorije / Posebno / Minimum / Ранг",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Posebno / Minimum / Ранг.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Posebno / Квалитет / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Posebno / Квалитет / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Posebno / Квалитет / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Posebno / Квалитет / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Posebno / Награда / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Posebno / Награда / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Posebno / Награда / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Posebno / Награда / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Posebno / Ризик / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Posebno / Ризик / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Posebno / Ризик / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Posebno / Ризик / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Велико продавање / Износ / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Велико продавање / Износ / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Велико продавање / Износ / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Велико продавање / Износ / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleMinRank = {
                    label = "Poslovna mreža / Уговори / Kategorije / Велико продавање / Minimum / Ранг",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Велико продавање / Minimum / Ранг.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Велико продавање / Квалитет / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Велико продавање / Квалитет / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Велико продавање / Квалитет / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Велико продавање / Квалитет / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Велико продавање / Награда / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Велико продавање / Награда / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Велико продавање / Награда / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Велико продавање / Награда / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem1 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Велико продавање / Ризик / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Велико продавање / Ризик / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem2 = {
                    label = "Poslovna mreža / Уговори / Kategorije / Велико продавање / Ризик / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Kategorije / Велико продавање / Ризик / 2.",
                },
                drugAdvancedBusinessNetworkContractsDeliveryDistance = {
                    label = "Poslovna mreža / Уговори / Udaljenost dostave",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Udaljenost dostave.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMax = {
                    label = "Poslovna mreža / Уговори / Трајање / Minuti / Maksimum",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Трајање / Minuti / Maksimum.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMin = {
                    label = "Poslovna mreža / Уговори / Трајање / Minuti / Minimum",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Трајање / Minuti / Minimum.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsX = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 1 / Koordinate / Кс",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 1 / Koordinate / Кс.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsY = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 1 / Koordinate / И",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 1 / Koordinate / И.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsZ = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 1 / Koordinate / З",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 1 / Koordinate / З.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Id = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 1 / ID",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 1 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Label = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 1 / Назив",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 1 / Назив.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Region = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 1 / Region",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 1 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1RewardMultiplier = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 1 / Награда / Množilac",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 1 / Награда / Množilac.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Risk = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 1 / Ризик",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 1 / Ризик.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsX = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 2 / Koordinate / Кс",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 2 / Koordinate / Кс.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsY = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 2 / Koordinate / И",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 2 / Koordinate / И.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsZ = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 2 / Koordinate / З",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 2 / Koordinate / З.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Id = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 2 / ID",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 2 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Label = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 2 / Назив",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 2 / Назив.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Region = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 2 / Region",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 2 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2RewardMultiplier = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 2 / Награда / Množilac",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 2 / Награда / Množilac.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Risk = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 2 / Ризик",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 2 / Ризик.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsX = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 3 / Koordinate / Кс",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 3 / Koordinate / Кс.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsY = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 3 / Koordinate / И",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 3 / Koordinate / И.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsZ = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 3 / Koordinate / З",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 3 / Koordinate / З.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Id = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 3 / ID",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 3 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Label = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 3 / Назив",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 3 / Назив.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Region = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 3 / Region",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 3 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3RewardMultiplier = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 3 / Награда / Množilac",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 3 / Награда / Množilac.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Risk = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 3 / Ризик",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 3 / Ризик.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsX = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 4 / Koordinate / Кс",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 4 / Koordinate / Кс.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsY = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 4 / Koordinate / И",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 4 / Koordinate / И.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsZ = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 4 / Koordinate / З",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 4 / Koordinate / З.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Id = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 4 / ID",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 4 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Label = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 4 / Назив",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 4 / Назив.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Region = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 4 / Region",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 4 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4RewardMultiplier = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 4 / Награда / Množilac",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 4 / Награда / Množilac.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Risk = {
                    label = "Poslovna mreža / Уговори / Sastanak / Поенти / 4 / Ризик",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Sastanak / Поенти / 4 / Ризик.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem1 = {
                    label = "Poslovna mreža / Уговори / Pregovaranje / Avans / Opcije / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Pregovaranje / Avans / Opcije / 1.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem2 = {
                    label = "Poslovna mreža / Уговори / Pregovaranje / Avans / Opcije / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Pregovaranje / Avans / Opcije / 2.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem3 = {
                    label = "Poslovna mreža / Уговори / Pregovaranje / Avans / Opcije / 3",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Pregovaranje / Avans / Opcije / 3.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAmountFlexPercent = {
                    label = "Poslovna mreža / Уговори / Pregovaranje / Износ / Prostor za pregovore / Procenat",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Pregovaranje / Износ / Prostor za pregovore / Procenat.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationBaseAcceptance = {
                    label = "Poslovna mreža / Уговори / Pregovaranje / Osnovna vrednost / Prihvatanje",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Pregovaranje / Osnovna vrednost / Prihvatanje.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationDeadlineFlexPercent = {
                    label = "Poslovna mreža / Уговори / Pregovaranje / Рок / Prostor za pregovore / Procenat",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Pregovaranje / Рок / Prostor za pregovore / Procenat.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationMaxRounds = {
                    label = "Poslovna mreža / Уговори / Pregovaranje / Maksimum / Runde",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Pregovaranje / Maksimum / Runde.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationQualityFlex = {
                    label = "Poslovna mreža / Уговори / Pregovaranje / Квалитет / Prostor za pregovore",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Pregovaranje / Квалитет / Prostor za pregovore.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRejectionCooldownMinutes = {
                    label = "Poslovna mreža / Уговори / Pregovaranje / Odbijanje / Minuti pauze",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Pregovaranje / Odbijanje / Minuti pauze.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRoundPressure = {
                    label = "Poslovna mreža / Уговори / Pregovaranje / Рунда / Притисак",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Pregovaranje / Рунда / Притисак.",
                },
                drugAdvancedBusinessNetworkContractsOfferCount = {
                    label = "Poslovna mreža / Уговори / Ponuda / Broj",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Ponuda / Broj.",
                },
                drugAdvancedBusinessNetworkContractsRefreshMinutes = {
                    label = "Poslovna mreža / Уговори / Osvežavanje / Minuti",
                    description = "Podešavanje rada za: Poslovna mreža / Уговори / Osvežavanje / Minuti.",
                },
                drugAdvancedBusinessNetworkDefaultBusinessName = {
                    label = "Poslovna mreža / Podrazumevana vrednost / Име бизниса",
                    description = "Podešavanje rada za: Poslovna mreža / Podrazumevana vrednost / Име бизниса.",
                },
                drugAdvancedBusinessNetworkDefaultRankId = {
                    label = "Poslovna mreža / Podrazumevana vrednost / Ранг / ID",
                    description = "Podešavanje rada za: Poslovna mreža / Podrazumevana vrednost / Ранг / ID.",
                },
                drugAdvancedBusinessNetworkDefaultStaffStyle = {
                    label = "Poslovna mreža / Podrazumevana vrednost / Osoblje / Način rada",
                    description = "Podešavanje rada za: Poslovna mreža / Podrazumevana vrednost / Osoblje / Način rada.",
                },
                drugAdvancedBusinessNetworkDefaultTransport = {
                    label = "Poslovna mreža / Podrazumevana vrednost / Транспорт",
                    description = "Podešavanje rada za: Poslovna mreža / Podrazumevana vrednost / Транспорт.",
                },
                drugAdvancedBusinessNetworkEnabled = {
                    label = "Poslovna mreža / Омогућено",
                    description = "Podešavanje rada za: Poslovna mreža / Омогућено.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterCapacity = {
                    label = "Poslovna mreža / Distributivni centri / Distributivni centar / Капацитет",
                    description = "Podešavanje rada za: Poslovna mreža / Distributivni centri / Distributivni centar / Капацитет.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterPurchasePrice = {
                    label = "Poslovna mreža / Distributivni centri / Distributivni centar / Цена куповине",
                    description = "Podešavanje rada za: Poslovna mreža / Distributivni centri / Distributivni centar / Цена куповине.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterSecurity = {
                    label = "Poslovna mreža / Distributivni centri / Distributivni centar / Безбедност",
                    description = "Podešavanje rada za: Poslovna mreža / Distributivni centri / Distributivni centar / Безбедност.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterUpkeep = {
                    label = "Poslovna mreža / Distributivni centri / Distributivni centar / Održavanje",
                    description = "Podešavanje rada za: Poslovna mreža / Distributivni centri / Distributivni centar / Održavanje.",
                },
                drugAdvancedBusinessNetworkHubsStashCapacity = {
                    label = "Poslovna mreža / Distributivni centri / Skrovište / Капацитет",
                    description = "Podešavanje rada za: Poslovna mreža / Distributivni centri / Skrovište / Капацитет.",
                },
                drugAdvancedBusinessNetworkHubsStashPurchasePrice = {
                    label = "Poslovna mreža / Distributivni centri / Skrovište / Цена куповине",
                    description = "Podešavanje rada za: Poslovna mreža / Distributivni centri / Skrovište / Цена куповине.",
                },
                drugAdvancedBusinessNetworkHubsStashSecurity = {
                    label = "Poslovna mreža / Distributivni centri / Skrovište / Безбедност",
                    description = "Podešavanje rada za: Poslovna mreža / Distributivni centri / Skrovište / Безбедност.",
                },
                drugAdvancedBusinessNetworkHubsStashUpkeep = {
                    label = "Poslovna mreža / Distributivni centri / Skrovište / Održavanje",
                    description = "Podešavanje rada za: Poslovna mreža / Distributivni centri / Skrovište / Održavanje.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseCapacity = {
                    label = "Poslovna mreža / Distributivni centri / Складиште / Капацитет",
                    description = "Podešavanje rada za: Poslovna mreža / Distributivni centri / Складиште / Капацитет.",
                },
                drugAdvancedBusinessNetworkHubsWarehousePurchasePrice = {
                    label = "Poslovna mreža / Distributivni centri / Складиште / Цена куповине",
                    description = "Podešavanje rada za: Poslovna mreža / Distributivni centri / Складиште / Цена куповине.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseSecurity = {
                    label = "Poslovna mreža / Distributivni centri / Складиште / Безбедност",
                    description = "Podešavanje rada za: Poslovna mreža / Distributivni centri / Складиште / Безбедност.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseUpkeep = {
                    label = "Poslovna mreža / Distributivni centri / Складиште / Održavanje",
                    description = "Podešavanje rada za: Poslovna mreža / Distributivni centri / Складиште / Održavanje.",
                },
                drugAdvancedBusinessNetworkLimitsActiveContracts = {
                    label = "Poslovna mreža / Ograničenja / Aktivni ugovori",
                    description = "Podešavanje rada za: Poslovna mreža / Ograničenja / Aktivni ugovori.",
                },
                drugAdvancedBusinessNetworkLimitsHubs = {
                    label = "Poslovna mreža / Ograničenja / Distributivni centri",
                    description = "Podešavanje rada za: Poslovna mreža / Ograničenja / Distributivni centri.",
                },
                drugAdvancedBusinessNetworkLimitsLedgerRows = {
                    label = "Poslovna mreža / Ograničenja / Poslovna knjiga / Redovi",
                    description = "Podešavanje rada za: Poslovna mreža / Ograničenja / Poslovna knjiga / Redovi.",
                },
                drugAdvancedBusinessNetworkLimitsRoutes = {
                    label = "Poslovna mreža / Ograničenja / Руте",
                    description = "Podešavanje rada za: Poslovna mreža / Ograničenja / Руте.",
                },
                drugAdvancedBusinessNetworkLimitsStaff = {
                    label = "Poslovna mreža / Ograničenja / Osoblje",
                    description = "Podešavanje rada za: Poslovna mreža / Ograničenja / Osoblje.",
                },
                drugAdvancedBusinessNetworkPayoutAccount = {
                    label = "Poslovna mreža / Износ исплате / Налог",
                    description = "Podešavanje rada za: Poslovna mreža / Износ исплате / Налог.",
                },
                drugAdvancedBusinessNetworkRanksItem1Contracts = {
                    label = "Poslovna mreža / Činovi / 1 / Уговори",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 1 / Уговори.",
                },
                drugAdvancedBusinessNetworkRanksItem1Dealers = {
                    label = "Poslovna mreža / Činovi / 1 / Дилери",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 1 / Дилери.",
                },
                drugAdvancedBusinessNetworkRanksItem1Hubs = {
                    label = "Poslovna mreža / Činovi / 1 / Distributivni centri",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 1 / Distributivni centri.",
                },
                drugAdvancedBusinessNetworkRanksItem1Id = {
                    label = "Poslovna mreža / Činovi / 1 / ID",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 1 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem1Label = {
                    label = "Poslovna mreža / Činovi / 1 / Назив",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 1 / Назив.",
                },
                drugAdvancedBusinessNetworkRanksItem1Routes = {
                    label = "Poslovna mreža / Činovi / 1 / Руте",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 1 / Руте.",
                },
                drugAdvancedBusinessNetworkRanksItem1Score = {
                    label = "Poslovna mreža / Činovi / 1 / Поени",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 1 / Поени.",
                },
                drugAdvancedBusinessNetworkRanksItem1Staff = {
                    label = "Poslovna mreža / Činovi / 1 / Osoblje",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 1 / Osoblje.",
                },
                drugAdvancedBusinessNetworkRanksItem2Contracts = {
                    label = "Poslovna mreža / Činovi / 2 / Уговори",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 2 / Уговори.",
                },
                drugAdvancedBusinessNetworkRanksItem2Dealers = {
                    label = "Poslovna mreža / Činovi / 2 / Дилери",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 2 / Дилери.",
                },
                drugAdvancedBusinessNetworkRanksItem2Hubs = {
                    label = "Poslovna mreža / Činovi / 2 / Distributivni centri",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 2 / Distributivni centri.",
                },
                drugAdvancedBusinessNetworkRanksItem2Id = {
                    label = "Poslovna mreža / Činovi / 2 / ID",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 2 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem2Label = {
                    label = "Poslovna mreža / Činovi / 2 / Назив",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 2 / Назив.",
                },
                drugAdvancedBusinessNetworkRanksItem2Routes = {
                    label = "Poslovna mreža / Činovi / 2 / Руте",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 2 / Руте.",
                },
                drugAdvancedBusinessNetworkRanksItem2Score = {
                    label = "Poslovna mreža / Činovi / 2 / Поени",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 2 / Поени.",
                },
                drugAdvancedBusinessNetworkRanksItem2Staff = {
                    label = "Poslovna mreža / Činovi / 2 / Osoblje",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 2 / Osoblje.",
                },
                drugAdvancedBusinessNetworkRanksItem3Contracts = {
                    label = "Poslovna mreža / Činovi / 3 / Уговори",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 3 / Уговори.",
                },
                drugAdvancedBusinessNetworkRanksItem3Dealers = {
                    label = "Poslovna mreža / Činovi / 3 / Дилери",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 3 / Дилери.",
                },
                drugAdvancedBusinessNetworkRanksItem3Hubs = {
                    label = "Poslovna mreža / Činovi / 3 / Distributivni centri",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 3 / Distributivni centri.",
                },
                drugAdvancedBusinessNetworkRanksItem3Id = {
                    label = "Poslovna mreža / Činovi / 3 / ID",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 3 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem3Label = {
                    label = "Poslovna mreža / Činovi / 3 / Назив",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 3 / Назив.",
                },
                drugAdvancedBusinessNetworkRanksItem3Routes = {
                    label = "Poslovna mreža / Činovi / 3 / Руте",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 3 / Руте.",
                },
                drugAdvancedBusinessNetworkRanksItem3Score = {
                    label = "Poslovna mreža / Činovi / 3 / Поени",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 3 / Поени.",
                },
                drugAdvancedBusinessNetworkRanksItem3Staff = {
                    label = "Poslovna mreža / Činovi / 3 / Osoblje",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 3 / Osoblje.",
                },
                drugAdvancedBusinessNetworkRanksItem4Contracts = {
                    label = "Poslovna mreža / Činovi / 4 / Уговори",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 4 / Уговори.",
                },
                drugAdvancedBusinessNetworkRanksItem4Dealers = {
                    label = "Poslovna mreža / Činovi / 4 / Дилери",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 4 / Дилери.",
                },
                drugAdvancedBusinessNetworkRanksItem4Hubs = {
                    label = "Poslovna mreža / Činovi / 4 / Distributivni centri",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 4 / Distributivni centri.",
                },
                drugAdvancedBusinessNetworkRanksItem4Id = {
                    label = "Poslovna mreža / Činovi / 4 / ID",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 4 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem4Label = {
                    label = "Poslovna mreža / Činovi / 4 / Назив",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 4 / Назив.",
                },
                drugAdvancedBusinessNetworkRanksItem4Routes = {
                    label = "Poslovna mreža / Činovi / 4 / Руте",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 4 / Руте.",
                },
                drugAdvancedBusinessNetworkRanksItem4Score = {
                    label = "Poslovna mreža / Činovi / 4 / Поени",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 4 / Поени.",
                },
                drugAdvancedBusinessNetworkRanksItem4Staff = {
                    label = "Poslovna mreža / Činovi / 4 / Osoblje",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 4 / Osoblje.",
                },
                drugAdvancedBusinessNetworkRanksItem5Contracts = {
                    label = "Poslovna mreža / Činovi / 5 / Уговори",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 5 / Уговори.",
                },
                drugAdvancedBusinessNetworkRanksItem5Dealers = {
                    label = "Poslovna mreža / Činovi / 5 / Дилери",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 5 / Дилери.",
                },
                drugAdvancedBusinessNetworkRanksItem5Hubs = {
                    label = "Poslovna mreža / Činovi / 5 / Distributivni centri",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 5 / Distributivni centri.",
                },
                drugAdvancedBusinessNetworkRanksItem5Id = {
                    label = "Poslovna mreža / Činovi / 5 / ID",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 5 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem5Label = {
                    label = "Poslovna mreža / Činovi / 5 / Назив",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 5 / Назив.",
                },
                drugAdvancedBusinessNetworkRanksItem5Routes = {
                    label = "Poslovna mreža / Činovi / 5 / Руте",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 5 / Руте.",
                },
                drugAdvancedBusinessNetworkRanksItem5Score = {
                    label = "Poslovna mreža / Činovi / 5 / Поени",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 5 / Поени.",
                },
                drugAdvancedBusinessNetworkRanksItem5Staff = {
                    label = "Poslovna mreža / Činovi / 5 / Osoblje",
                    description = "Podešavanje rada za: Poslovna mreža / Činovi / 5 / Osoblje.",
                },
                drugAdvancedBusinessNetworkReportDays = {
                    label = "Poslovna mreža / Period izveštaja / дана",
                    description = "Podešavanje rada za: Poslovna mreža / Period izveštaja / дана.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesBuyer = {
                    label = "Poslovna mreža / Рута / Krajnja tačka / Tipovi / Купац",
                    description = "Podešavanje rada za: Poslovna mreža / Рута / Krajnja tačka / Tipovi / Купац.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesContract = {
                    label = "Poslovna mreža / Рута / Krajnja tačka / Tipovi / Уговор",
                    description = "Podešavanje rada za: Poslovna mreža / Рута / Krajnja tačka / Tipovi / Уговор.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesDealer = {
                    label = "Poslovna mreža / Рута / Krajnja tačka / Tipovi / Дилер",
                    description = "Podešavanje rada za: Poslovna mreža / Рута / Krajnja tačka / Tipovi / Дилер.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesGang = {
                    label = "Poslovna mreža / Рута / Krajnja tačka / Tipovi / банда",
                    description = "Podešavanje rada za: Poslovna mreža / Рута / Krajnja tačka / Tipovi / банда.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesHub = {
                    label = "Poslovna mreža / Рута / Krajnja tačka / Tipovi / Distributivni centar",
                    description = "Podešavanje rada za: Poslovna mreža / Рута / Krajnja tačka / Tipovi / Distributivni centar.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesLab = {
                    label = "Poslovna mreža / Рута / Krajnja tačka / Tipovi / Лабораторија",
                    description = "Podešavanje rada za: Poslovna mreža / Рута / Krajnja tačka / Tipovi / Лабораторија.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesOrganization = {
                    label = "Poslovna mreža / Рута / Krajnja tačka / Tipovi / Organizacija",
                    description = "Podešavanje rada za: Poslovna mreža / Рута / Krajnja tačka / Tipovi / Organizacija.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesPusher = {
                    label = "Poslovna mreža / Рута / Krajnja tačka / Tipovi / Пушер",
                    description = "Podešavanje rada za: Poslovna mreža / Рута / Krajnja tačka / Tipovi / Пушер.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMax = {
                    label = "Poslovna mreža / Rad u igri / Уговор / Učestalost / Minuti / Maksimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Уговор / Učestalost / Minuti / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMin = {
                    label = "Poslovna mreža / Rad u igri / Уговор / Učestalost / Minuti / Minimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Уговор / Učestalost / Minuti / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCooldownMinimumMinutes = {
                    label = "Poslovna mreža / Rad u igri / Уговор / Време чекања / Minimum / Minuti",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Уговор / Време чекања / Minimum / Minuti.",
                },
                drugAdvancedBusinessNetworkRuntimeContractFailureReliabilityLoss = {
                    label = "Poslovna mreža / Rad u igri / Уговор / Neuspeh / Поузданост / Губитак",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Уговор / Neuspeh / Поузданост / Губитак.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumCadenceMinutes = {
                    label = "Poslovna mreža / Rad u igri / Уговор / Minimum / Učestalost / Minuti",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Уговор / Minimum / Učestalost / Minuti.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumMeetingMultiplier = {
                    label = "Poslovna mreža / Rad u igri / Уговор / Minimum / Sastanak / Množilac",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Уговор / Minimum / Sastanak / Množilac.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyGrowth = {
                    label = "Poslovna mreža / Rad u igri / Казна уговора / Раст",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Казна уговора / Раст.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyMultiplier = {
                    label = "Poslovna mreža / Rad u igri / Казна уговора / Množilac",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Казна уговора / Množilac.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityFailureCooldownMinutes = {
                    label = "Poslovna mreža / Rad u igri / Уговор / Квалитет / Neuspeh / Minuti pauze",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Уговор / Квалитет / Neuspeh / Minuti pauze.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceBase = {
                    label = "Poslovna mreža / Rad u igri / Уговор / Квалитет / Цена / Osnovna vrednost",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Уговор / Квалитет / Цена / Osnovna vrednost.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceDivisor = {
                    label = "Poslovna mreža / Rad u igri / Уговор / Квалитет / Цена / Delilac",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Уговор / Квалитет / Цена / Delilac.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossBase = {
                    label = "Poslovna mreža / Rad u igri / Уговор / Поузданост / Губитак / Osnovna vrednost",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Уговор / Поузданост / Губитак / Osnovna vrednost.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossMaximum = {
                    label = "Poslovna mreža / Rad u igri / Уговор / Поузданост / Губитак / Maksimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Уговор / Поузданост / Губитак / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossQualityWeight = {
                    label = "Poslovna mreža / Rad u igri / Уговор / Поузданост / Губитак / Квалитет / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Уговор / Поузданост / Губитак / Квалитет / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReputationQualityWeight = {
                    label = "Poslovna mreža / Rad u igri / Уговор / Репутација / Квалитет / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Уговор / Репутација / Квалитет / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsCategory = {
                    label = "Poslovna mreža / Rad u igri / Уговор / Ризик / Ponderi / Категорија",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Уговор / Ризик / Ponderi / Категорија.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsMeeting = {
                    label = "Poslovna mreža / Rad u igri / Уговор / Ризик / Ponderi / Sastanak",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Уговор / Ризик / Ponderi / Sastanak.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubCapacity = {
                    label = "Poslovna mreža / Rad u igri / Podrazumevana vrednost / Distributivni centar / Капацитет",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Podrazumevana vrednost / Distributivni centar / Капацитет.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubSecurity = {
                    label = "Poslovna mreža / Rad u igri / Podrazumevana vrednost / Distributivni centar / Безбедност",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Podrazumevana vrednost / Distributivni centar / Безбедност.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultMeetingRisk = {
                    label = "Poslovna mreža / Rad u igri / Podrazumevana vrednost / Sastanak / Ризик",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Podrazumevana vrednost / Sastanak / Ризик.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultQuality = {
                    label = "Poslovna mreža / Rad u igri / Podrazumevana vrednost / Квалитет",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Podrazumevana vrednost / Квалитет.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteCapacity = {
                    label = "Poslovna mreža / Rad u igri / Podrazumevana vrednost / Капацитет руте",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Podrazumevana vrednost / Капацитет руте.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteIntervalMinutes = {
                    label = "Poslovna mreža / Rad u igri / Podrazumevana vrednost / Рута / Interval / Minuti",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Podrazumevana vrednost / Рута / Interval / Minuti.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteRisk = {
                    label = "Poslovna mreža / Rad u igri / Podrazumevana vrednost / Рута / Ризик",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Podrazumevana vrednost / Рута / Ризик.",
                },
                drugAdvancedBusinessNetworkRuntimeHubHeatDecay = {
                    label = "Poslovna mreža / Rad u igri / Distributivni centar / Policijski pritisak / Отуђење",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Distributivni centar / Policijski pritisak / Отуђење.",
                },
                drugAdvancedBusinessNetworkRuntimeHubLoadHeat = {
                    label = "Poslovna mreža / Rad u igri / Distributivni centar / Opterećenje / Policijski pritisak",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Distributivni centar / Opterećenje / Policijski pritisak.",
                },
                drugAdvancedBusinessNetworkRuntimeHubRaidRecoveryMinutes = {
                    label = "Poslovna mreža / Rad u igri / Distributivni centar / Napad / Oporavak / Minuti",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Distributivni centar / Napad / Oporavak / Minuti.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostBase = {
                    label = "Poslovna mreža / Rad u igri / Distributivni centar / Безбедност / Cena / Osnovna vrednost",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Distributivni centar / Безбедност / Cena / Osnovna vrednost.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostPerLevel = {
                    label = "Poslovna mreža / Rad u igri / Distributivni centar / Безбедност / Cena / Po nivou",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Distributivni centar / Безбедност / Cena / Po nivou.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityMaximum = {
                    label = "Poslovna mreža / Rad u igri / Distributivni centar / Безбедност / Maksimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Distributivni centar / Безбедност / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityUpgrade = {
                    label = "Poslovna mreža / Rad u igri / Distributivni centar / Безбедност / Unapređenje",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Distributivni centar / Безбедност / Unapređenje.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidHeat = {
                    label = "Poslovna mreža / Rad u igri / Distributivni centar / Neplaćanje / Policijski pritisak",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Distributivni centar / Neplaćanje / Policijski pritisak.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidSecurityLoss = {
                    label = "Poslovna mreža / Rad u igri / Distributivni centar / Neplaćanje / Безбедност / Губитак",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Distributivni centar / Neplaćanje / Безбедност / Губитак.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUpkeepIntervalHours = {
                    label = "Poslovna mreža / Rad u igri / Distributivni centar / Održavanje / Interval / Sati",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Distributivni centar / Održavanje / Interval / Sati.",
                },
                drugAdvancedBusinessNetworkRuntimeInitialReliability = {
                    label = "Poslovna mreža / Rad u igri / Početna vrednost / Поузданост",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Početna vrednost / Поузданост.",
                },
                drugAdvancedBusinessNetworkRuntimeMaximumBusinessNameLength = {
                    label = "Poslovna mreža / Rad u igri / Maksimum / Име бизниса / Dužina",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Maksimum / Име бизниса / Dužina.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumContractDeliveryMinutes = {
                    label = "Poslovna mreža / Rad u igri / Minimum / Уговор / Dostava / Minuti",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Minimum / Уговор / Dostava / Minuti.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumDeliveryDistance = {
                    label = "Poslovna mreža / Rad u igri / Minimum / Udaljenost dostave",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Minimum / Udaljenost dostave.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumLedgerRows = {
                    label = "Poslovna mreža / Rad u igri / Minimum / Poslovna knjiga / Redovi",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Minimum / Poslovna knjiga / Redovi.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumRouteIntervalMinutes = {
                    label = "Poslovna mreža / Rad u igri / Minimum / Рута / Interval / Minuti",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Minimum / Рута / Interval / Minuti.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvanceCostWeight = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Avans / Cena / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Avans / Cena / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvancePriceWeight = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Avans / Цена / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Avans / Цена / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountCostWeight = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Износ / Cena / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Износ / Cena / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountFlexMaximum = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Износ / Prostor za pregovore / Maksimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Износ / Prostor za pregovore / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountRiskWeight = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Износ / Ризик / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Износ / Ризик / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationCounterOfferWeight = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Контрапонуда / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Контрапонуда / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationDeadlineFlexMaximum = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Рок / Prostor za pregovore / Maksimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Рок / Prostor za pregovore / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMaximumAcceptance = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Maksimum / Prihvatanje",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Maksimum / Prihvatanje.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMinimumAcceptance = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Minimum / Prihvatanje",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Minimum / Prihvatanje.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityBenefitWeight = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Квалитет / Korist / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Квалитет / Korist / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityCostWeight = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Квалитет / Cena / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Квалитет / Cena / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityFlexMaximum = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Квалитет / Prostor za pregovore / Maksimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Квалитет / Prostor za pregovore / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityRewardWeight = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Квалитет / Награда / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Квалитет / Награда / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReliabilityWeight = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Поузданост / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Поузданост / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReputationWeight = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Репутација / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Репутација / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMax = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Tražena nagrada / Maksimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Tražena nagrada / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMin = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Tražena nagrada / Minimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Tražena nagrada / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardCostWeight = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Награда / Cena / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Награда / Cena / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMax = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Награда / Maksimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Награда / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMin = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Награда / Minimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Награда / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBase = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Hitnost / Osnovna vrednost",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Hitnost / Osnovna vrednost.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBenefitWeight = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Hitnost / Korist / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Hitnost / Korist / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyRiskWeight = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Hitnost / Ризик / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Hitnost / Ризик / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyWeight = {
                    label = "Poslovna mreža / Rad u igri / Pregovaranje / Hitnost / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Pregovaranje / Hitnost / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeOtherFailureHeat = {
                    label = "Poslovna mreža / Rad u igri / Drugo / Neuspeh / Policijski pritisak",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Drugo / Neuspeh / Policijski pritisak.",
                },
                drugAdvancedBusinessNetworkRuntimePersonalHeatWeight = {
                    label = "Poslovna mreža / Rad u igri / Лична топлота / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Лична топлота / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimePoliceFailureHeat = {
                    label = "Poslovna mreža / Rad u igri / Policija / Neuspeh / Policijski pritisak",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Policija / Neuspeh / Policijski pritisak.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBaseUnits = {
                    label = "Poslovna mreža / Rad u igri / Пушер / Osnovna vrednost / јединице",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Пушер / Osnovna vrednost / јединице.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBulkMultiplier = {
                    label = "Poslovna mreža / Rad u igri / Пушер / Велика количина / Množilac",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Пушер / Велика количина / Množilac.",
                },
                drugAdvancedBusinessNetworkRuntimePusherCheapMultiplier = {
                    label = "Poslovna mreža / Rad u igri / Пушер / Jeftine prodaje / Množilac",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Пушер / Jeftine prodaje / Množilac.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerLevel = {
                    label = "Poslovna mreža / Rad u igri / Пушер / Iskustvo / Po nivou",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Пушер / Iskustvo / Po nivou.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerUnit = {
                    label = "Poslovna mreža / Rad u igri / Пушер / Iskustvo / Po jedinici",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Пушер / Iskustvo / Po jedinici.",
                },
                drugAdvancedBusinessNetworkRuntimePusherHubHeatPerUnit = {
                    label = "Poslovna mreža / Rad u igri / Пушер / Distributivni centar / Policijski pritisak / Po jedinici",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Пушер / Distributivni centar / Policijski pritisak / Po jedinici.",
                },
                drugAdvancedBusinessNetworkRuntimePusherPremiumMultiplier = {
                    label = "Poslovna mreža / Rad u igri / Пушер / Премиум / Množilac",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Пушер / Премиум / Množilac.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillDivisor = {
                    label = "Poslovna mreža / Rad u igri / Пушер / Вештина / Delilac",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Пушер / Вештина / Delilac.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillGain = {
                    label = "Poslovna mreža / Rad u igri / Пушер / Вештина / принос",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Пушер / Вештина / принос.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationBaseSeconds = {
                    label = "Poslovna mreža / Rad u igri / Рута / Трајање / Osnovna vrednost / секунд",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Трајање / Osnovna vrednost / секунд.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationPerUnitSeconds = {
                    label = "Poslovna mreža / Rad u igri / Рута / Трајање / Po jedinici / секунд",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Трајање / Po jedinici / секунд.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem1 = {
                    label = "Poslovna mreža / Rad u igri / Рута / Neuspeh / Узроци / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Neuspeh / Узроци / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem2 = {
                    label = "Poslovna mreža / Rad u igri / Рута / Neuspeh / Узроци / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Neuspeh / Узроци / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem3 = {
                    label = "Poslovna mreža / Rad u igri / Рута / Neuspeh / Узроци / 3",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Neuspeh / Узроци / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem4 = {
                    label = "Poslovna mreža / Rad u igri / Рута / Neuspeh / Узроци / 4",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Neuspeh / Узроци / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureValueMultiplier = {
                    label = "Poslovna mreža / Rad u igri / Рута / Neuspeh / Вредност / Množilac",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Neuspeh / Вредност / Množilac.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatAmountDivisor = {
                    label = "Poslovna mreža / Rad u igri / Рута / Policijski pritisak / Износ / Delilac",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Policijski pritisak / Износ / Delilac.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostBase = {
                    label = "Poslovna mreža / Rad u igri / Рута / Смањење притиска / Cena / Osnovna vrednost",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Смањење притиска / Cena / Osnovna vrednost.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostPerHeat = {
                    label = "Poslovna mreža / Rad u igri / Рута / Смањење притиска / Cena / Po poenu pažnje policije",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Смањење притиска / Cena / Po poenu pažnje policije.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMaximum = {
                    label = "Poslovna mreža / Rad u igri / Рута / Ризик / Maksimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Ризик / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMinimum = {
                    label = "Poslovna mreža / Rad u igri / Рута / Ризик / Minimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Ризик / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsHeat = {
                    label = "Poslovna mreža / Rad u igri / Рута / Ризик / Ponderi / Policijski pritisak",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Ризик / Ponderi / Policijski pritisak.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsLoyalty = {
                    label = "Poslovna mreža / Rad u igri / Рута / Ризик / Ponderi / Лојалност",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Ризик / Ponderi / Лојалност.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsRunnerRisk = {
                    label = "Poslovna mreža / Rad u igri / Рута / Ризик / Ponderi / Курир / Ризик",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Ризик / Ponderi / Курир / Ризик.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsSkill = {
                    label = "Poslovna mreža / Rad u igri / Рута / Ризик / Ponderi / Вештина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Ризик / Ponderi / Вештина.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationHeatReduction = {
                    label = "Poslovna mreža / Rad u igri / Ротација руте / Смањење притиска",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Ротација руте / Смањење притиска.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationRiskReduction = {
                    label = "Poslovna mreža / Rad u igri / Ротација руте / Ризик / Smanjenje",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Ротација руте / Ризик / Smanjenje.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityBase = {
                    label = "Poslovna mreža / Rad u igri / Рута / Prodaja / Основни квалитет",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Prodaja / Основни квалитет.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityDivisor = {
                    label = "Poslovna mreža / Rad u igri / Рута / Prodaja / Квалитет / Delilac",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Prodaja / Квалитет / Delilac.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleRiskDivisor = {
                    label = "Poslovna mreža / Rad u igri / Рута / Prodaja / Ризик / Delilac",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Prodaja / Ризик / Delilac.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteStartHeat = {
                    label = "Poslovna mreža / Rad u igri / Рута / Početak / Policijski pritisak",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Рута / Početak / Policijski pritisak.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerLevel = {
                    label = "Poslovna mreža / Rad u igri / Курир / Iskustvo / Po nivou",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Курир / Iskustvo / Po nivou.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerUnit = {
                    label = "Poslovna mreža / Rad u igri / Курир / Iskustvo / Po jedinici",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Курир / Iskustvo / Po jedinici.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureLoyaltyLoss = {
                    label = "Poslovna mreža / Rad u igri / Курир / Neuspeh / Лојалност / Губитак",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Курир / Neuspeh / Лојалност / Губитак.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureRiskGain = {
                    label = "Poslovna mreža / Rad u igri / Курир / Ризик од неуспеха / принос",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Курир / Ризик од неуспеха / принос.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerSkillGain = {
                    label = "Poslovna mreža / Rad u igri / Курир / Вештина / принос",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Курир / Вештина / принос.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsHeat = {
                    label = "Poslovna mreža / Rad u igri / Поени / Ponderi / Policijski pritisak",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Поени / Ponderi / Policijski pritisak.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReliability = {
                    label = "Poslovna mreža / Rad u igri / Поени / Ponderi / Поузданост",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Поени / Ponderi / Поузданост.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReputation = {
                    label = "Poslovna mreža / Rad u igri / Поени / Ponderi / Репутација",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Поени / Ponderi / Репутација.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsStructure = {
                    label = "Poslovna mreža / Rad u igri / Поени / Ponderi / Struktura",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Поени / Ponderi / Struktura.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffCapacityBaseMultiplier = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Капацитет / Osnovna vrednost / Množilac",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Капацитет / Osnovna vrednost / Množilac.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMax = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Zapošljavanje / Лојалност / Maksimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Zapošljavanje / Лојалност / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMin = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Zapošljavanje / Лојалност / Minimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Zapošljavanje / Лојалност / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMax = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Zapošljavanje / Ризик / Maksimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Zapošljavanje / Ризик / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMin = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Zapošljavanje / Ризик / Minimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Zapošljavanje / Ризик / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMax = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Zapošljavanje / Вештина / Maksimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Zapošljavanje / Вештина / Maksimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMin = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Zapošljavanje / Вештина / Minimum",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Zapošljavanje / Вештина / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentLoyaltyWeight = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Incident / Лојалност / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Incident / Лојалност / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentMaximumChance = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Incident / Maksimum / Могућа",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Incident / Maksimum / Могућа.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem1 = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Incident / Ishodi / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Incident / Ishodi / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem2 = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Incident / Ishodi / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Incident / Ishodi / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem3 = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Incident / Ishodi / 3",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Incident / Ishodi / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem4 = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Incident / Ishodi / 4",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Incident / Ishodi / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentRiskWeight = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Incident / Ризик / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Incident / Ризик / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffLoyaltyDecay = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Лојалност / Отуђење",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Лојалност / Отуђење.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffMaximumLevel = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Maksimum / Ниво",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Maksimum / Ниво.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffPoachedLoyaltyLoss = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Gubitak lojalnosti zbog vrbovanja",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Gubitak lojalnosti zbog vrbovanja.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionCostBase = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Zaštita / Cena / Osnovna vrednost",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Zaštita / Cena / Osnovna vrednost.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionHours = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Zaštita / Sati",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Zaštita / Sati.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionIncidentReduction = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Zaštita / Incident / Smanjenje",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Zaštita / Incident / Smanjenje.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionRiskCost = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Zaštita / Ризик / Cena",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Zaštita / Ризик / Cena.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryBaseChance = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Oporavak / Osnovna vrednost / Могућа",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Oporavak / Osnovna vrednost / Могућа.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryLoyaltyWeight = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Oporavak / Лојалност / Тежина",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Oporavak / Лојалност / Тежина.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageBaseMultiplier = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Плат / Osnovna vrednost / Množilac",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Плат / Osnovna vrednost / Množilac.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageLoyaltyGain = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Плат / Лојалност / принос",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Плат / Лојалност / принос.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageSkillDivisor = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Плат / Вештина / Delilac",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Плат / Вештина / Delilac.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem1 = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Slabosti / 1",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Slabosti / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem2 = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Slabosti / 2",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Slabosti / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem3 = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Slabosti / 3",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Slabosti / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem4 = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Slabosti / 4",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Slabosti / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem5 = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Slabosti / 5",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Slabosti / 5.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem6 = {
                    label = "Poslovna mreža / Rad u igri / Osoblje / Slabosti / 6",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Osoblje / Slabosti / 6.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsContracts = {
                    label = "Poslovna mreža / Rad u igri / Struktura / Ponderi / Уговори",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Struktura / Ponderi / Уговори.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsDealers = {
                    label = "Poslovna mreža / Rad u igri / Struktura / Ponderi / Дилери",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Struktura / Ponderi / Дилери.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsHubs = {
                    label = "Poslovna mreža / Rad u igri / Struktura / Ponderi / Distributivni centri",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Struktura / Ponderi / Distributivni centri.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsRoutes = {
                    label = "Poslovna mreža / Rad u igri / Struktura / Ponderi / Руте",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Struktura / Ponderi / Руте.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsStaff = {
                    label = "Poslovna mreža / Rad u igri / Struktura / Ponderi / Osoblje",
                    description = "Podešavanje rada za: Poslovna mreža / Rad u igri / Struktura / Ponderi / Osoblje.",
                },
                drugAdvancedBusinessNetworkSocietyPermission = {
                    label = "Poslovna mreža / Organizacija / Dozvola",
                    description = "Podešavanje rada za: Poslovna mreža / Organizacija / Dozvola.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseCapacity = {
                    label = "Poslovna mreža / Osoblje / Пушер / Osnovna vrednost / Капацитет",
                    description = "Podešavanje rada za: Poslovna mreža / Osoblje / Пушер / Osnovna vrednost / Капацитет.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseWage = {
                    label = "Poslovna mreža / Osoblje / Пушер / Osnovna vrednost / Плат",
                    description = "Podešavanje rada za: Poslovna mreža / Osoblje / Пушер / Osnovna vrednost / Плат.",
                },
                drugAdvancedBusinessNetworkStaffPusherCommission = {
                    label = "Poslovna mreža / Osoblje / Пушер / Комисија",
                    description = "Podešavanje rada za: Poslovna mreža / Osoblje / Пушер / Комисија.",
                },
                drugAdvancedBusinessNetworkStaffPusherHirePrice = {
                    label = "Poslovna mreža / Osoblje / Пушер / Zapošljavanje / Цена",
                    description = "Podešavanje rada za: Poslovna mreža / Osoblje / Пушер / Zapošljavanje / Цена.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseCapacity = {
                    label = "Poslovna mreža / Osoblje / Курир / Osnovna vrednost / Капацитет",
                    description = "Podešavanje rada za: Poslovna mreža / Osoblje / Курир / Osnovna vrednost / Капацитет.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseWage = {
                    label = "Poslovna mreža / Osoblje / Курир / Osnovna vrednost / Плат",
                    description = "Podešavanje rada za: Poslovna mreža / Osoblje / Курир / Osnovna vrednost / Плат.",
                },
                drugAdvancedBusinessNetworkStaffRunnerCommission = {
                    label = "Poslovna mreža / Osoblje / Курир / Комисија",
                    description = "Podešavanje rada za: Poslovna mreža / Osoblje / Курир / Комисија.",
                },
                drugAdvancedBusinessNetworkStaffRunnerHirePrice = {
                    label = "Poslovna mreža / Osoblje / Курир / Zapošljavanje / Цена",
                    description = "Podešavanje rada za: Poslovna mreža / Osoblje / Курир / Zapošljavanje / Цена.",
                },
                drugAdvancedBusinessNetworkTickMinutes = {
                    label = "Poslovna mreža / Ciklus ažuriranja / Minuti",
                    description = "Podešavanje rada za: Poslovna mreža / Ciklus ažuriranja / Minuti.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCapacity = {
                    label = "Poslovna mreža / Transporti / Ваздухоплов / Капацитет",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Ваздухоплов / Капацитет.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCost = {
                    label = "Poslovna mreža / Transporti / Ваздухоплов / Cena",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Ваздухоплов / Cena.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftDurationMultiplier = {
                    label = "Poslovna mreža / Transporti / Ваздухоплов / Множитељ трајања",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Ваздухоплов / Множитељ трајања.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftRisk = {
                    label = "Poslovna mreža / Transporti / Ваздухоплов / Ризик",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Ваздухоплов / Ризик.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCapacity = {
                    label = "Poslovna mreža / Transporti / Чамец / Капацитет",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Чамец / Капацитет.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCost = {
                    label = "Poslovna mreža / Transporti / Чамец / Cena",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Чамец / Cena.",
                },
                drugAdvancedBusinessNetworkTransportsBoatDurationMultiplier = {
                    label = "Poslovna mreža / Transporti / Чамец / Множитељ трајања",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Чамец / Множитељ трајања.",
                },
                drugAdvancedBusinessNetworkTransportsBoatRisk = {
                    label = "Poslovna mreža / Transporti / Чамец / Ризик",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Чамец / Ризик.",
                },
                drugAdvancedBusinessNetworkTransportsCarCapacity = {
                    label = "Poslovna mreža / Transporti / Аутомобил / Капацитет",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Аутомобил / Капацитет.",
                },
                drugAdvancedBusinessNetworkTransportsCarCost = {
                    label = "Poslovna mreža / Transporti / Аутомобил / Cena",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Аутомобил / Cena.",
                },
                drugAdvancedBusinessNetworkTransportsCarDurationMultiplier = {
                    label = "Poslovna mreža / Transporti / Аутомобил / Множитељ трајања",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Аутомобил / Множитељ трајања.",
                },
                drugAdvancedBusinessNetworkTransportsCarRisk = {
                    label = "Poslovna mreža / Transporti / Аутомобил / Ризик",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Аутомобил / Ризик.",
                },
                drugAdvancedBusinessNetworkTransportsFootCapacity = {
                    label = "Poslovna mreža / Transporti / Peške / Капацитет",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Peške / Капацитет.",
                },
                drugAdvancedBusinessNetworkTransportsFootCost = {
                    label = "Poslovna mreža / Transporti / Peške / Cena",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Peške / Cena.",
                },
                drugAdvancedBusinessNetworkTransportsFootDurationMultiplier = {
                    label = "Poslovna mreža / Transporti / Peške / Множитељ трајања",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Peške / Множитељ трајања.",
                },
                drugAdvancedBusinessNetworkTransportsFootRisk = {
                    label = "Poslovna mreža / Transporti / Peške / Ризик",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Peške / Ризик.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCapacity = {
                    label = "Poslovna mreža / Transporti / Теретно возило / Капацитет",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Теретно возило / Капацитет.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCost = {
                    label = "Poslovna mreža / Transporti / Теретно возило / Cena",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Теретно возило / Cena.",
                },
                drugAdvancedBusinessNetworkTransportsTruckDurationMultiplier = {
                    label = "Poslovna mreža / Transporti / Теретно возило / Множитељ трајања",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Теретно возило / Множитељ трајања.",
                },
                drugAdvancedBusinessNetworkTransportsTruckRisk = {
                    label = "Poslovna mreža / Transporti / Теретно возило / Ризик",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Теретно возило / Ризик.",
                },
                drugAdvancedBusinessNetworkTransportsVanCapacity = {
                    label = "Poslovna mreža / Transporti / Фургон / Капацитет",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Фургон / Капацитет.",
                },
                drugAdvancedBusinessNetworkTransportsVanCost = {
                    label = "Poslovna mreža / Transporti / Фургон / Cena",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Фургон / Cena.",
                },
                drugAdvancedBusinessNetworkTransportsVanDurationMultiplier = {
                    label = "Poslovna mreža / Transporti / Фургон / Множитељ трајања",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Фургон / Множитељ трајања.",
                },
                drugAdvancedBusinessNetworkTransportsVanRisk = {
                    label = "Poslovna mreža / Transporti / Фургон / Ризик",
                    description = "Podešavanje rada za: Poslovna mreža / Transporti / Фургон / Ризик.",
                },
                interrogationDispatchAdapter = {
                    options = {
                        sky_jobs_base = "Sky Jobs Base",
                        generic = "Opšta integracija",
                        custom = "Prilagođena integracija",
                        none = "Isključeno",
                    },
                },
                reputationRules = {
                    label = "Правила репутације",
                    description = "Подеси именована правила за радње и необавезне циљеве. Само омогућена правила додељују поене.",
                },
            },
            territoryMap = {
                addPoint = "Додај тачку",
                clear = "Очисти",
                create = "Креирај",
                custom = "Прилагођене територије",
                deletePoint = "Обриши тачку",
                eyebrow = "Уредник територије",
                minimum = "Минимум 3",
                pointCount = "{count} тачака",
                presets = "Предлошки округи",
                shown = "Приказано на мапи",
                street = "Улица",
                supply = "Снабдевање",
                territories = "Територије",
                type = "Територијски тип",
                undo = "Опозови",
            },
            shopPositionTools = {
                currentPosition = "Користи тренутну позицију",
                selectEntity = "Изабери објекат",
                selectEntityHint = "Целите ласером у касу или сеф. Enter: прихвати позицију и оријентацију обележеног објекта. Backspace: откажи.",
            },
            drugSettingSubsections = {
                cultivationLevels = "Нивои узгоја",
                general = "Опште",
                runtime = "Pristup radnjama u igri",
                quality = "Квалитет",
                packaging = "Упаковка",
                growing = "Uzgoj",
                labs = "Laboratorije i kamperi",
                power = "Napajanje i oprema",
                workers = "Запослени",
                market = "Tržište i distribucija",
                threats = "Racije i sabotaža",
                pvpTakeovers = "Преузимања лабораторија",
                consumption = "Konzumacija",
                processing = "Обрада",
                performance = "Перформансе",
                dynamicMarket = "Динамичко тржиште",
                heat = "Pažnja policije i rizik",
                contacts = "Mreža kontakata",
                business = "Poslovna mreža",
            },
            drugSettingGroups = {
                cultivationGeneral = { label = "Опште" },
                cultivationCurve = { label = "Крива нивоа" },
                cultivationExperience = { label = "XP награде" },
                cultivationUnlocks = { label = "Откључавања нивоа" },
                creator = {
                    label = "Otvori uređivač",
                },
                creatorSettings = {
                    label = "Podešavanja uređivača",
                },
                interfaceHud = {
                    label = "Положаји интерфејса",
                },
                drugsGeneral = {
                    label = "Опште",
                },
                runtimeAccess = {
                    label = "Pristup i vlasništvo",
                },
                runtimePayouts = {
                    label = "Isplate",
                },
                runtimeDispatch = {
                    label = "Dispečer i policija",
                },
                qualityWeights = {
                    label = "Квалитет / Ponderi",
                },
                qualityTiers = {
                    label = "Квалитет / Nivoi kvaliteta",
                },
                packagingGeneral = {
                    label = "Опште",
                },
                growingGeneral = {
                    label = "Опште",
                },
                plantDefaults = {
                    label = "Биљка / Podrazumevane vrednosti",
                },
                harvestWindow = {
                    label = "Жетва / Vremenski prozor",
                },
                labsGeneral = {
                    label = "Опште",
                },
                labRent = {
                    label = "Zakup i životni ciklus",
                },
                camperDefaults = {
                    label = "Кампер",
                },
                labUpgrades = {
                    label = "Unapređenja",
                },
                labDefaults = {
                    label = "Лабораторија / Podrazumevane vrednosti",
                },
                powerGeneral = {
                    label = "Опште",
                },
                generators = {
                    label = "Generatori",
                },
                equipmentWear = {
                    label = "Опрема",
                },
                workersGeneral = {
                    label = "Опште",
                },
                marketGeneral = {
                    label = "Опште",
                },
                marketPrices = {
                    label = "Cene",
                },
                distribution = {
                    label = "Дистрибуција",
                },
                threatsGeneral = {
                    label = "Опште",
                },
                threatHeat = {
                    label = "Policijski pritisak",
                },
                threatChances = {
                    label = "Verovatnoće",
                },
                pvpTakeoverRules = {
                    label = "Правила преузимања",
                },
                pvpTakeoverZones = {
                    label = "Зоне & Време",
                },
                pvpTakeoverMethods = {
                    label = "Методи пробоја",
                },
                consumptionGeneral = {
                    label = "Опште",
                },
                consumerDecay = {
                    label = "Smanjenje tolerancije i zavisnosti",
                },
                consumerEffects = {
                    label = "Efekti i rizici",
                },
                processingFlow = {
                    label = "Tok obrade",
                },
                processingGeneral = {
                    label = "Опште",
                },
                powerRuntime = {
                    label = "Rad u igri",
                },
                powerHeat = {
                    label = "Pažnja policije i energetski trag",
                },
                powerModes = {
                    label = "Upravljanje / Režimi",
                },
                powerPriorities = {
                    label = "Opterećenje / Prioriteti",
                },
                performanceInactiveControlIntervalMs = {
                    label = "Неактивно / Контрола / Interval / ms",
                },
                performanceInteractionIdleScanIntervalMs = {
                    label = "Интеракција / Idle / Interval skeniranja / ms",
                },
                performanceInteractionPromptIntervalMs = {
                    label = "Интеракција / Poziv za interakciju / Interval / ms",
                },
                performanceInteractionScanIntervalMs = {
                    label = "Интеракција / Interval skeniranja / ms",
                },
                performanceMinimumScanIntervalMs = {
                    label = "Minimum / Interval skeniranja / ms",
                },
                performanceStreetPedActivationDistance = {
                    label = "Улица / Пед / Активација / Удаљеност",
                },
                performanceStreetPedIdleScanIntervalMs = {
                    label = "Улица / Пед / Idle / Interval skeniranja / ms",
                },
                performanceStreetPedScanIntervalMs = {
                    label = "Улица / Пед / Interval skeniranja / ms",
                },
                performanceWorldCachePadding = {
                    label = "Свет / Keš / Dodatna margina",
                },
                performanceWorldCacheRefreshIntervalMs = {
                    label = "Свет / Keš / Osvežavanje / Interval / ms",
                },
                performanceWorldIdleIntervalMs = {
                    label = "Свет / Idle / Interval / ms",
                },
                dynamicMarketActionCooldownSeconds = {
                    label = "Хладноће акције / секунд",
                },
                dynamicMarketActionHistoryLimit = {
                    label = "Акција / Лимит историје",
                },
                dynamicMarketAmountSaturationWeight = {
                    label = "Износ / Засићење / Тежина",
                },
                dynamicMarketBaseIntelAccuracy = {
                    label = "Osnovna vrednost / Тачност обавештења",
                },
                dynamicMarketDefaultAverageQuality = {
                    label = "Podrazumevana vrednost / Prosek / Квалитет",
                },
                dynamicMarketDefaultResourceElasticity = {
                    label = "Podrazumevana vrednost / Ресурс / Elastičnost",
                },
                dynamicMarketDemandCenter = {
                    label = "Захтев / Srednja vrednost",
                },
                dynamicMarketDemandPriceImpact = {
                    label = "Захтев / Цена / Uticaj",
                },
                dynamicMarketDirectionThreshold = {
                    label = "Правац / Prag",
                },
                dynamicMarketEnabled = {
                    label = "Омогућено",
                },
                dynamicMarketEventChance = {
                    label = "Događaj / Могућа",
                },
                dynamicMarketEventDurationMinutes = {
                    label = "Događaj / Трајање / Minuti",
                },
                dynamicMarketEventMinimumDurationMinutes = {
                    label = "Događaj / Minimum / Трајање / Minuti",
                },
                dynamicMarketEventStrengthMaximum = {
                    label = "Događaj / Jačina / Maksimum",
                },
                dynamicMarketEventStrengthMinimum = {
                    label = "Događaj / Jačina / Minimum",
                },
                dynamicMarketEvents = {
                    label = "Догађаји",
                },
                dynamicMarketExactIntelReputation = {
                    label = "Tačne informacije / Репутација",
                },
                dynamicMarketExactIntelTrust = {
                    label = "Tačne informacije / Повјерење",
                },
                dynamicMarketGlobalZoneLabel = {
                    label = "Global / Зона / Назив",
                },
                dynamicMarketHistoryLimit = {
                    label = "Лимит историје",
                },
                dynamicMarketInitialDemand = {
                    label = "Početna vrednost / Захтев",
                },
                dynamicMarketInitialPriceMultiplier = {
                    label = "Početna vrednost / Мноилац цене",
                },
                dynamicMarketIntelDemandError = {
                    label = "Obaveštajni podaci / Захтев / Грешка",
                },
                dynamicMarketIntelMaximumAccuracy = {
                    label = "Obaveštajni podaci / Maksimum / Тачност",
                },
                dynamicMarketIntelMinimumAccuracy = {
                    label = "Obaveštajni podaci / Minimum / Тачност",
                },
                dynamicMarketIntelPoliceError = {
                    label = "Obaveštajni podaci / Policija / Грешка",
                },
                dynamicMarketIntelPriceError = {
                    label = "Obaveštajni podaci / Цена / Грешка",
                },
                dynamicMarketIntelPriceMaximum = {
                    label = "Obaveštajni podaci / Цена / Maksimum",
                },
                dynamicMarketIntelPriceMinimum = {
                    label = "Obaveštajni podaci / Цена / Minimum",
                },
                dynamicMarketIntelReputationWeight = {
                    label = "Obaveštajni podaci / Репутација / Тежина",
                },
                dynamicMarketIntelResourcePriceError = {
                    label = "Obaveštajni podaci / Ресурс / Цена / Грешка",
                },
                dynamicMarketIntelSaturationError = {
                    label = "Obaveštajni podaci / Засићење / Грешка",
                },
                dynamicMarketIntelSeedBucketSeconds = {
                    label = "Prozor semena informacija / секунд",
                },
                dynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Obaveštajni podaci / Статус / Тачност / Prag",
                },
                dynamicMarketIntelStatusErrorThreshold = {
                    label = "Obaveštajni podaci / Статус / Грешка / Prag",
                },
                dynamicMarketIntelSupplyError = {
                    label = "Obaveštajni podaci / Снабдевање / Грешка",
                },
                dynamicMarketIntelTrustWeight = {
                    label = "Obaveštajni podaci / Повјерење / Тежина",
                },
                dynamicMarketManipulationCooldownMinutes = {
                    label = "Manipulacija / Minuti pauze",
                },
                dynamicMarketManipulationDemandShift = {
                    label = "Manipulacija / Захтев / Promena",
                },
                dynamicMarketManipulationDurationMinutes = {
                    label = "Manipulacija / Трајање / Minuti",
                },
                dynamicMarketManipulationHeat = {
                    label = "Manipulacija / Policijski pritisak",
                },
                dynamicMarketManipulationMinimumBatchAmount = {
                    label = "Manipulacija / Minimum / Серија / Износ",
                },
                dynamicMarketManipulationPaymentAccount = {
                    label = "Manipulacija / Начин за плаћање",
                },
                dynamicMarketManipulationPrice = {
                    label = "Manipulacija / Цена",
                },
                dynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Manipulacija / Зона / Policijski pritisak / Množilac",
                },
                dynamicMarketMaximumIntelAgeMinutes = {
                    label = "Maksimum / Старост обавештења / Minuti",
                },
                dynamicMarketMaximumPriceMultiplier = {
                    label = "Maksimum / Мноилац цене",
                },
                dynamicMarketMinimumIntelAgeMinutes = {
                    label = "Minimum / Старост обавештења / Minuti",
                },
                dynamicMarketMinimumMetricWindowMinutes = {
                    label = "Minimum / Metrika / Vremenski prozor / Minuti",
                },
                dynamicMarketMinimumPriceMultiplier = {
                    label = "Минимална цена / Množilac",
                },
                dynamicMarketMinimumUpdateMinutes = {
                    label = "Minimum / Ažuriranje / Minuti",
                },
                dynamicMarketPoliceDemandWeight = {
                    label = "Policija / Захтев / Тежина",
                },
                dynamicMarketPolicePriceImpact = {
                    label = "Policija / Цена / Uticaj",
                },
                dynamicMarketPoorQualityDemandPenalty = {
                    label = "Loš kvalitet / Захтев / Kazna",
                },
                dynamicMarketPoorQualityThreshold = {
                    label = "Loš kvalitet / Prag",
                },
                dynamicMarketPremiumQualityDemandBonus = {
                    label = "Vrhunski kvalitet / Бонус захтева",
                },
                dynamicMarketPremiumQualityThreshold = {
                    label = "Vrhunski kvalitet / Prag",
                },
                dynamicMarketProductionSupplyWeight = {
                    label = "Производња / Снабдевање / Тежина",
                },
                dynamicMarketProductionWindowMinutes = {
                    label = "Производња / Vremenski prozor / Minuti",
                },
                dynamicMarketQualityCenter = {
                    label = "Квалитет / Srednja vrednost",
                },
                dynamicMarketQualityConfidenceImpact = {
                    label = "Квалитет / Постојаност / Uticaj",
                },
                dynamicMarketQualityRange = {
                    label = "Квалитет / Raspon vrednosti",
                },
                dynamicMarketRarityBonusMaximum = {
                    label = "Retkost / Бонус / Maksimum",
                },
                dynamicMarketRegionalGlobalWeight = {
                    label = "Regionalno / Global / Тежина",
                },
                dynamicMarketRegionalLocalWeight = {
                    label = "Regionalno / Lokalno / Тежина",
                },
                dynamicMarketResourceAliases = {
                    label = "Ресурс / Alternativni nazivi",
                },
                dynamicMarketResourceDirectionFallThreshold = {
                    label = "Ресурс / Правац / Pad / Prag",
                },
                dynamicMarketResourceDirectionRiseThreshold = {
                    label = "Ресурс / Правац / Rast / Prag",
                },
                dynamicMarketResources = {
                    label = "Ресурси",
                },
                dynamicMarketSalesWindowMinutes = {
                    label = "Продаја / Vremenski prozor / Minuti",
                },
                dynamicMarketSaturationDemandWeight = {
                    label = "Засићење / Захтев / Тежина",
                },
                dynamicMarketSaturationPriceImpact = {
                    label = "Засићење / Цена / Uticaj",
                },
                dynamicMarketScarcityDemandWeight = {
                    label = "Nestašica / Захтев / Тежина",
                },
                dynamicMarketScarcityPriceImpact = {
                    label = "Nestašica / Цена / Uticaj",
                },
                dynamicMarketSeasonEndMonths = {
                    label = "Godišnje doba / Kraj / Meseci",
                },
                dynamicMarketSeasonMultipliers = {
                    label = "Godišnje doba / Množioci",
                },
                dynamicMarketShortageRumorThreshold = {
                    label = "Nestašica / Glasina / Prag",
                },
                dynamicMarketStatusThresholds = {
                    label = "Статус / Pragovi",
                },
                dynamicMarketTargetSupply = {
                    label = "Циљ / Снабдевање",
                },
                dynamicMarketTrendChance = {
                    label = "Trend / Могућа",
                },
                dynamicMarketTrendDurationMinutes = {
                    label = "Trend / Трајање / Minuti",
                },
                dynamicMarketTrendMaximumStrength = {
                    label = "Trend / Maksimum / Jačina",
                },
                dynamicMarketTrendMinimumStrength = {
                    label = "Trend / Minimum / Jačina",
                },
                dynamicMarketUpdateMinutes = {
                    label = "Ažuriranje / Minuti",
                },
                dynamicMarketVolatilityMaximum = {
                    label = "Promenljivost cena / Maksimum",
                },
                dynamicMarketVolatilityMinimum = {
                    label = "Promenljivost cena / Minimum",
                },
                dynamicMarketWeatherMultipliers = {
                    label = "Vreme / Množioci",
                },
                dynamicMarketWeatherState = {
                    label = "Vreme / Стање",
                },
                heatActionCooldownSeconds = {
                    label = "Хладноће акције / секунд",
                },
                heatActivityRiskWeights = {
                    label = "Aktivnost / Ризик / Ponderi",
                },
                heatAggressiveHeatMultiplier = {
                    label = "Agresivni režim / Policijski pritisak / Množilac",
                },
                heatBurnerBurnThreshold = {
                    label = "Telefon za jednokratnu upotrebu / Razotkrivanje / Prag",
                },
                heatBurnerHeatPerWholesale = {
                    label = "Telefon za jednokratnu upotrebu / Policijski pritisak / Po veleprodajnom poslu",
                },
                heatBurnerPhoneItem = {
                    label = "Бернер телефон / Predmet",
                },
                heatCamperOperationalHeatMultiplier = {
                    label = "Kamper u radu / Policijski pritisak / Množilac",
                },
                heatCamperOperationalHeatThreshold = {
                    label = "Kamper u radu / Policijski pritisak / Prag",
                },
                heatCamperParkedHeat = {
                    label = "Parkirani kamper / Policijski pritisak",
                },
                heatContaminatedHeatMultiplier = {
                    label = "Kontaminacija / Policijski pritisak / Množilac",
                },
                heatContaminatedThreshold = {
                    label = "Kontaminacija / Prag",
                },
                heatCultivationFreePlants = {
                    label = "Култивација / Biljke bez dodatnog rizika",
                },
                heatCultivationHeatPerPlant = {
                    label = "Култивација / Policijski pritisak / Po biljci",
                },
                heatDealerHiddenMinutes = {
                    label = "Дилер / скривено / Minuti",
                },
                heatDecayPerTick = {
                    label = "Отуђење / Po ciklusu ažuriranja",
                },
                heatEnabled = {
                    label = "Омогућено",
                },
                heatEnforcementHeat = {
                    label = "Prisustvo policije / Policijski pritisak",
                },
                heatEnforcementMultipliers = {
                    label = "Prisustvo policije / Množioci",
                },
                heatEntityTypes = {
                    label = "Objekat igre / Tipovi",
                },
                heatEventCooldownMinutes = {
                    label = "Događaj / Minuti pauze",
                },
                heatEventHistoryLimit = {
                    label = "Događaj / Лимит историје",
                },
                heatLabHeatSyncThreshold = {
                    label = "Лабораторија / Policijski pritisak / Sinhronizacija / Prag",
                },
                heatLayLowCooldownMinutes = {
                    label = "Povući se / Minuti pauze",
                },
                heatLayLowIdleMinutes = {
                    label = "Povući se / Idle / Minuti",
                },
                heatLayLowReduction = {
                    label = "Povući se / Smanjenje",
                },
                heatLockdownMinutes = {
                    label = "Затворено / Minuti",
                },
                heatMinimumDurationMinutes = {
                    label = "Minimum / Трајање / Minuti",
                },
                heatMinimumEventCooldownSeconds = {
                    label = "Minimum / Događaj / Време паузе (секунде)",
                },
                heatMinimumIdleSeconds = {
                    label = "Minimum / Idle / секунд",
                },
                heatProcessingHeatMultiplier = {
                    label = "Обрада / Policijski pritisak / Množilac",
                },
                heatRiskWeights = {
                    label = "Ризик / Ponderi",
                },
                heatRotateBurnerReduction = {
                    label = "Promeni telefon za jednokratnu upotrebu / Smanjenje",
                },
                heatRouteControlMinutes = {
                    label = "Рута / Контрола / Minuti",
                },
                heatSaleHeat = {
                    label = "Prodaja / Policijski pritisak",
                },
                heatThresholds = {
                    label = "Pragovi",
                },
                heatTickMinutes = {
                    label = "Ciklus ažuriranja / Minuti",
                },
                heatWholesaleHeatMultiplier = {
                    label = "Велико продавање / Policijski pritisak / Množilac",
                },
                heatWorkerLeakAlertRadius = {
                    label = "Запослени / Curenje informacija / Радијус аларма",
                },
                heatWorkerLeakBaseChance = {
                    label = "Запослени / Curenje informacija / Osnovna vrednost / Могућа",
                },
                heatWorkerLeakFactionMultiplier = {
                    label = "Запослени / Curenje informacija / Фракција / Množilac",
                },
                heatWorkerLeakHighSeverityThreshold = {
                    label = "Запослени / Curenje informacija / Висок / Ozbiljnost / Prag",
                },
                heatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Запослени / Curenje informacija / Лојалност / Могућа / Množilac",
                },
                heatWorkerLeakLoyaltyThreshold = {
                    label = "Запослени / Curenje informacija / Лојалност / Prag",
                },
                heatWorkerLeakMaximumChance = {
                    label = "Запослени / Curenje informacija / Maksimum / Могућа",
                },
                heatWorkerLeakMinimumCooldownSeconds = {
                    label = "Запослени / Curenje informacija / Minimum / Време паузе (секунде)",
                },
                heatWorkerLeakRouteMultiplier = {
                    label = "Запослени / Curenje informacija / Рута / Množilac",
                },
                heatWorkerLeakStrengthMaximum = {
                    label = "Запослени / Curenje informacija / Jačina / Maksimum",
                },
                heatWorkerLeakStrengthMinimum = {
                    label = "Запослени / Curenje informacija / Jačina / Minimum",
                },
                heatWorkerLeakStrengthMultiplier = {
                    label = "Запослени / Curenje informacija / Jačina / Množilac",
                },
                heatWorkerLeakStressChanceMultiplier = {
                    label = "Запослени / Curenje informacija / Стрес / Могућа / Množilac",
                },
                heatWorkerLeakStressThreshold = {
                    label = "Запослени / Curenje informacija / Стрес / Prag",
                },
                contactsActionCooldownSeconds = {
                    label = "Хладноће акције / секунд",
                },
                contactsActiveHotspotCount = {
                    label = "Broj aktivnih žarišta",
                },
                contactsBurnerHintTrust = {
                    label = "Савет за једнократни телефон / Повјерење",
                },
                contactsBurnerOfferMaximumMultiplier = {
                    label = "Telefon za jednokratnu upotrebu / Ponuda / Maksimum / Množilac",
                },
                contactsBurnerOfferMinimumMultiplier = {
                    label = "Telefon za jednokratnu upotrebu / Ponuda / Minimum / Množilac",
                },
                contactsBuyerCooldownMinutes = {
                    label = "Купац / Minuti pauze",
                },
                contactsBuyerDeliveryDistance = {
                    label = "Купац / Udaljenost dostave",
                },
                contactsBuyerPremiumSuccessScore = {
                    label = "Купац / Премиум / Uspeh / Поени",
                },
                contactsBuyerPremiumTrustGain = {
                    label = "Купац / Премиум / Повјерење / принос",
                },
                contactsBuyerRequestHeatRiskWeight = {
                    label = "Купац / Zahtev / Притисак и ризик / Тежина",
                },
                contactsBuyerStandardTrustGain = {
                    label = "Купац / Стандард / Повјерење / принос",
                },
                contactsContactActiveDelaySeconds = {
                    label = "Čekanje na aktivaciju kontakta / секунд",
                },
                contactsContactDemandRange = {
                    label = "Контакт / Захтев / Raspon vrednosti",
                },
                contactsContactLossTrust = {
                    label = "Контакт / Губитак / Повјерење",
                },
                contactsDarknetExactIntelMinutes = {
                    label = "Darknet / Tačne informacije / Minuti",
                },
                contactsDarknetHotspotIntelPrice = {
                    label = "Darknet / Žarište / Obaveštajni podaci / Цена",
                },
                contactsDarknetIntelPrice = {
                    label = "Darknet / Obaveštajni podaci / Цена",
                },
                contactsDealerBasePrice = {
                    label = "Дилер / Базна цена",
                },
                contactsDealerHireCapacity = {
                    label = "Дилер / Zapošljavanje / Капацитет",
                },
                contactsDealerHireRisk = {
                    label = "Дилер / Zapošljavanje / Ризик",
                },
                contactsDealerHireSkill = {
                    label = "Дилер / Zapošljavanje / Вештина",
                },
                contactsDealerOffers = {
                    label = "Понуде дилера",
                },
                contactsDealerProtectionHours = {
                    label = "Дилер / Zaštita / Sati",
                },
                contactsDealerProtectionPrice = {
                    label = "Дилер / Zaštita / Цена",
                },
                contactsDealerSaleMax = {
                    label = "Дилер / Prodaja / Maksimum",
                },
                contactsDealerSaleMin = {
                    label = "Дилер / Prodaja / Minimum",
                },
                contactsDealerSimulation = {
                    label = "Дилер / Симулација",
                },
                contactsDealerTickMinutes = {
                    label = "Дилер / Ciklus ažuriranja / Minuti",
                },
                contactsDealerWage = {
                    label = "Дилер / Плат",
                },
                contactsDealerWageDecay = {
                    label = "Дилер / Плат / Отуђење",
                },
                contactsDealerWageLoyaltyGain = {
                    label = "Дилер / Плат / Лојалност / принос",
                },
                contactsDealerWeaknesses = {
                    label = "Дилер / Slabosti",
                },
                contactsDefaultContactDemand = {
                    label = "Podrazumevana vrednost / Контакт / Захтев",
                },
                contactsDefaultContactRisk = {
                    label = "Podrazumevana vrednost / Контакт / Ризик",
                },
                contactsDefaultDealerCapacity = {
                    label = "Podrazumevani diler / Капацитет",
                },
                contactsDefaultDealerRisk = {
                    label = "Podrazumevani diler / Ризик",
                },
                contactsDefaultDealerSkill = {
                    label = "Podrazumevani diler / Вештина",
                },
                contactsDefaultHotspotRadius = {
                    label = "Podrazumevana vrednost / Žarište / Радијус",
                },
                contactsDemandResetMinutes = {
                    label = "Ресет потражње (минута)",
                },
                contactsEnabled = {
                    label = "Омогућено",
                },
                contactsExactLocationTrust = {
                    label = "Tačna lokacija / Повјерење",
                },
                contactsFactionDiscoveryReputation = {
                    label = "Фракција / Otkrivanje / Репутација",
                },
                contactsFactionHintTrust = {
                    label = "Фракција / Nagoveštaj / Повјерење",
                },
                contactsFailedDeliveryCooldownMinutes = {
                    label = "Neuspela dostava / Minuti pauze",
                },
                contactsFakeDealEncounter = {
                    label = "Lažni posao / Susret",
                },
                contactsFallbackPreferredDrug = {
                    label = "Zamenska vrednost / Препоручени лек",
                },
                contactsFallbackProductLabel = {
                    label = "Zamenska vrednost / Назив производа",
                },
                contactsGuideBookItem = {
                    label = "Vodič / Knjiga / Predmet",
                },
                contactsGuideBookTrust = {
                    label = "Vodič / Knjiga / Повјерење",
                },
                contactsHireDealerPrice = {
                    label = "Ангажуј дилера / Цена",
                },
                contactsHistoryLimit = {
                    label = "Лимит историје",
                },
                contactsHotspotIntelMinutes = {
                    label = "Žarište / Obaveštajni podaci / Minuti",
                },
                contactsHotspotRotationMinutes = {
                    label = "Žarište / Rotacija / Minuti",
                },
                contactsListingDurationMinutes = {
                    label = "Oglas / Трајање / Minuti",
                },
                contactsMaxOwnedDealers = {
                    label = "Maksimum / У власништву / Дилери",
                },
                contactsMinimumBuyerDeliveryDistance = {
                    label = "Minimum / Купац / Udaljenost dostave",
                },
                contactsMinimumContactRotationMinutes = {
                    label = "Minimum / Ротација контаката (минута)",
                },
                contactsMinimumDemandResetMinutes = {
                    label = "Minimum / Ресет потражње (минута)",
                },
                contactsMinimumHeatMultiplier = {
                    label = "Minimum / Policijski pritisak / Množilac",
                },
                contactsMinimumHotspotIntelMinutes = {
                    label = "Minimum / Žarište / Obaveštajni podaci / Minuti",
                },
                contactsMinimumHotspotRadius = {
                    label = "Minimum / Žarište / Радијус",
                },
                contactsMinimumHotspotRotationMinutes = {
                    label = "Minimum / Žarište / Rotacija / Minuti",
                },
                contactsMinimumListingDurationMinutes = {
                    label = "Minimum / Oglas / Трајање / Minuti",
                },
                contactsMinimumRewardMultiplier = {
                    label = "Минимална награда / Množilac",
                },
                contactsMinimumRobberyMultiplier = {
                    label = "Minimum / Крађа / Množilac",
                },
                contactsMinimumSpotPriceMultiplier = {
                    label = "Minimum / Lokacija / Мноилац цене",
                },
                contactsOtherDrugPriceMultiplier = {
                    label = "Drugo / Дрога / Мноилац цене",
                },
                contactsPaymentAccount = {
                    label = "Начин за плаћање",
                },
                contactsPostDeliveryDemandResetSeconds = {
                    label = "Posle dostave / Захтев / Reset / секунд",
                },
                contactsPreferredDrugPriceMultiplier = {
                    label = "Препоручени лек / Мноилац цене",
                },
                contactsRegionLocationTrust = {
                    label = "Region / Локација / Повјерење",
                },
                contactsRequestAmounts = {
                    label = "Zahtev / Količine",
                },
                contactsRotationMinutes = {
                    label = "Rotacija / Minuti",
                },
                contactsSpotPools = {
                    label = "Lokacija / Grupe za izbor",
                },
                contactsStreetHotspots = {
                    label = "Улица / Žarišta",
                },
                contactsTrustLevels = {
                    label = "Повјерење / Nivoi",
                },
                businessActionCooldownSeconds = {
                    label = "Хладноће акције / секунд",
                },
                businessBalance = {
                    label = "Баланс",
                },
                businessContracts = {
                    label = "Уговори",
                },
                businessDefaultBusinessName = {
                    label = "Podrazumevana vrednost / Име бизниса",
                },
                businessDefaultRankId = {
                    label = "Podrazumevana vrednost / Ранг / ID",
                },
                businessDefaultStaffStyle = {
                    label = "Podrazumevana vrednost / Osoblje / Način rada",
                },
                businessDefaultTransport = {
                    label = "Podrazumevana vrednost / Транспорт",
                },
                businessEnabled = {
                    label = "Омогућено",
                },
                businessHubs = {
                    label = "Distributivni centri",
                },
                businessLimits = {
                    label = "Ograničenja",
                },
                businessPayments = {
                    label = "Плаћања",
                },
                businessPayoutAccount = {
                    label = "Износ исплате / Налог",
                },
                businessRanks = {
                    label = "Činovi",
                },
                businessReportDays = {
                    label = "Period izveštaja / дана",
                },
                businessRouteEndpointTypes = {
                    label = "Рута / Krajnja tačka / Tipovi",
                },
                businessRuntime = {
                    label = "Rad u igri",
                },
                businessSocietyPermission = {
                    label = "Organizacija / Dozvola",
                },
                businessStaff = {
                    label = "Osoblje",
                },
                businessTickMinutes = {
                    label = "Ciklus ažuriranja / Minuti",
                },
                businessTransports = {
                    label = "Transporti",
                },
            },
            territorySettings = {
                section = "Територије",
                zonesGroup = "Зоне територије",
                sourceLabel = "Извор зоне",
                sourceDescription = "Користи заштићене предлошке округе или дефиниши сопствене полигоне територије.",
                sourcePreset = "Предлошки округи",
                sourceCustom = "Прилагођене територије",
                editLabel = "Уредник територије",
                editDescription = "Уреди округе које користи изабрани извор зоне.",
                editButton = "Уреди територије",
                presetSection = "Предлошки округи",
                presetEntry = "Предлошки округ",
                customSection = "Прилагођене територије",
                customEntry = "Прилагођена територија",
                typeLabel = "Тип територије",
                streetType = "Улица",
                supplyType = "Снабдевање",
                enabledLabel = "Приказано на мапи",
                enabledDescription = "Неактивни предлошки округи се уклањају са мапе и не могу се присвојити.",
                zoneLabel = "Граница територије",
                zoneDescription = "Постави најмање три тачке узастопно уз границу територије.",
                ownershipGroup = "Поседовање",
                decayGroup = "Отуђење",
                presenceGroup = "Присутност",
                activityGroup = "Оцена активности",
                ownershipBenefitsGroup = "Бенефиције власништва",
                ownershipThresholdLabel = "Праг власништва",
                ownershipThresholdDescription = "Процент контроле који група мора да превазиђе да би званично владала територијом.",
                activityFloorLabel = "Фиксни подлога активности",
                activityFloorDescription = "Број потребних тачака утицаја када су подлоге засноване на величини онемогућене.",
                floorByZoneSizeLabel = "Скалирај подлогу према величини зоне",
                floorByZoneSizeDescription = "За сваку територију израчунајте активност на основу површине полигона, а не користећи фиксну границу.",
                floorPointsPerSizeUnitLabel = "Тачака подлоге по km²",
                floorPointsPerSizeUnitDescription = "Тачака активности потребних за сваки квадратни километар површине територије.",
                fixedFloorRequirement = "Онемогући подлоге засноване на величини да би се уредила фиксна подлога активности.",
                sizeFloorRequirement = "Укључи подлоге засноване на величини да би се уредиле тачке по квадратном километру.",
                dailyDecayLabel = "Дневно отуђење утицаја",
                dailyDecayDescription = "Проценат утицаја који се уклања сваких 24 сати.",
                presenceIntervalLabel = "Интервал присуства",
                presenceIntervalDescription = "Минута између аутоматских награда за присуство територије.",
                presencePointsLabel = "Тачака присуства по члану",
                presencePointsDescription = "Тачке присуства додељене сваком овлашћеном члану групе по интервалу.",
                drugSalesEnabledLabel = "Продаја од стране NPC-ја додељује утицај територије",
                drugSalesEnabledDescription = "Успешне продаје на улици од стране NPC-ја додељују утицај групи продавца у тренутној територији улице.",
                drugSalePointsLabel = "Тачака по продатој дроги",
                drugSalePointsDescription = "Тачке утицаја додељене за сваку јединицу дроге пријављену као продату.",
                drugSalesRequirement = "Укључи утицај продаје од стране NPC-ја да би се конфигурисале његове тачке.",
                graffitiPointsLabel = "Тачке графитија по 24 сати",
                graffitiPointsDescription = "Тачке присуства додељене када је један графити постојао укупно 24 пријављених сати.",
                streetSellingPriceBonusLabel = "Бонус цене продаје на улици",
                streetSellingPriceBonusDescription = "Проценат додат на цене продаје дроге за званичног власника територије улице.",
                supplyProductionSpeedBonusLabel = "Бонус брзине производње снабдевања",
                supplyProductionSpeedBonusDescription = "Проценат додат на брзину производње дроге за званичног власника територије снабдевања.",
                pruneToleranceLabel = "Толеранција за чишћење утицаја",
                pruneToleranceDescription = "Ефективни утицај испод ове вредности се третира као нула.",
            },
            graffitiSettings = {
                section = "Граффити",
                generalGroup = "Опште",
                streamingGroup = "Рендерирање",
                moderationGroup = "Модерација",
                graffitiEnabledLabel = "Омогући графити",
                graffitiEnabledDescription = "Омогући играчима да распрскају и виде графити.",
                graffitiRequireItemLabel = "Требна спреј боца",
                graffitiRequireItemDescription = "Играчима је потребна спреј боца за распрскавање. У супротном се користи команда /graffiti.",
                graffitiChargesPerCanLabel = "Набоји по боци",
                graffitiChargesPerCanDescription = "Колико графити једна спреј боца може да створи.",
                graffitiCooldownSecondsLabel = "Хлађење спреја",
                graffitiCooldownSecondsDescription = "Секунде које играч мора да чека између два распрскавања.",
                graffitiMaxPerPlayerLabel = "Макс. графити по играчу",
                graffitiMaxPerPlayerDescription = "Максималан број активних графити које један играч може да поседује. 0 значи неограничено.",
                graffitiMaxDistanceLabel = "Макс. дистанца спреја",
                graffitiMaxDistanceDescription = "Колико далеко зид може бити да би се и даље на њега распрскало, у метрима.",
                graffitiSprayDurationLabel = "Трајање спреја",
                graffitiSprayDurationDescription = "Трајање анимације прскања, у милисекундама.",
                graffitiExpiryDaysLabel = "Време истека",
                graffitiExpiryDaysDescription = "Данова док графити не нестане аутоматски. 0 значи никада.",
                graffitiTerritoryHoursLabel = "Сати територије по спреју",
                graffitiTerritoryHoursDescription = "Сати територијског присуства које свежа графити даје својој банди.",
                graffitiStreamRadiusLabel = "Радијус стрима",
                graffitiStreamRadiusDescription = "Дистанца у метрима на којој графити постају видљиви играчима.",
                graffitiPoolSizeLabel = "Величина декал пула",
                graffitiPoolSizeDescription = "Колико графити се истовремено рендерира. Више вредности коштају више перформанси.",
                graffitiReportsEnabledLabel = "Омогући пријаве",
                graffitiReportsEnabledDescription = "Омогући играчима да пријаве увредљиве графити.",
                graffitiAutoHideThresholdLabel = "Праг аутоматског сакривања",
                graffitiAutoHideThresholdDescription = "Број пријава које аутоматски сакрију графити. 0 онемогућава ово.",
            },
            darknetSettings = {
                section = "Тамно тржиште",
                availabilityGroup = "Доступност",
                economyGroup = "Криптовалута",
                listingsGroup = "Понуде и истека",
                chatGroup = "Приватни чат",
                identityGroup = "Алијаси и репутација",
                deliveryGroup = "Предаје и мртви падови",
                policeGroup = "Приступ полиције",
                npcGroup = "NPC трговци",
                enabledLabel = "Укључи Тамно тржиште",
                enabledDescription = "Чини таблет апликацију црног тржишта и њену радну логику доступним.",
                tabletOrderLabel = "Редослед таблет апликације",
                tabletOrderDescription = "Контролише позицију Тамног тржишта на таблету.",
                currencyCodeLabel = "Код валуте",
                currencyCodeDescription = "Кратка ознака која се приказује за интерну евиденцију криптовалуте.",
                starterBalanceLabel = "Нови баланс новчаника",
                starterBalanceDescription = "Крипто додељен само када играч први пут отвори тржиште.",
                exchangeEnabledLabel = "Укључи размену новца",
                exchangeEnabledDescription = "Омогућава аутентификованим корисницима BlackBay-а да купују и продају новце на њиховој страници рачуна.",
                exchangeAccountLabel = "Рачун за плаћање за размену новца",
                exchangeAccountDescription = "Фрајмворк рачун коришћен за куповину новца и исплате од продаје.",
                exchangeBuyPriceLabel = "Цена куповине по новцу",
                exchangeBuyPriceDescription = "Износ наплаћен са рачуна за плаћање за један новац.",
                exchangeSellPriceLabel = "Цена продаје по новцу",
                exchangeSellPriceDescription = "Износ за један Coin на рачун за плаћање.",
                exchangeMinimumLabel = "Минимални новац по размени",
                exchangeMinimumDescription = "Најмањи цели износ Coin-ова који се прихвата у једној размени.",
                exchangeMaximumLabel = "Максимални новац по размени",
                exchangeMaximumDescription = "Највећи цели износ Coin-ова који се прихвата у једној размени.",
                accountMoney = "Кеш",
                accountBank = "Банка",
                accountBlackMoney = "Неопран новац",
                scamChanceLabel = "Глобална вероватноћа за измаму од NPC-а (%)",
                scamChanceDescription = "Минимална вероватноћа да NPC узме плаћање или робу без испоруке повратне вредности. Већа вероватноћа за одређеног трговца и даље важи.",
                listingExpiryLabel = "Трајање понуде (сати)",
                listingExpiryDescription = "Активне понуде истичу аутоматски након овог броја сати.",
                renewalHoursLabel = "Трајање продужетка (сати)",
                renewalHoursDescription = "Сати који се додају када власник продужи понуду.",
                maximumListingsLabel = "Максималан број активних понуда",
                maximumListingsDescription = "Максималан број понуда по активном алијасу.",
                maximumQuantityLabel = "Максимална количина робе",
                maximumQuantityDescription = "Горња граница количине за једну понуду.",
                maximumPriceLabel = "Максимална цена по јединици",
                maximumPriceDescription = "Горња крипто цена за једну јединицу.",
                maximumMessageLengthLabel = "Максимална дужина поруке",
                maximumMessageLengthDescription = "Максималан број карактера по зашићеној чат поруци.",
                aliasCooldownLabel = "Време чекања за промену алијаса (сати)",
                aliasCooldownDescription = "Минимална старост идентитета пре него што се може поново повући.",
                verifiedSalesLabel = "Продаје потребне за верификацију",
                verifiedSalesDescription = "Неопходне успешне продаје пре него што се продавац може верификовати.",
                verifiedRatingLabel = "Оцена потребна за верификацију",
                verifiedRatingDescription = "Минимална просечна оцена за верификованог продавца.",
                scammerReportsLabel = "Пријаве за упозорење на измаму",
                scammerReportsDescription = "Уникалне пријаве трговине потребне за ознаку познатог измамљивача.",
                meetingDistanceLabel = "Удаљеност за предају",
                meetingDistanceDescription = "Максимална удаљеност између оба играча или конфигурисане тачке NPC-а.",
                dropModelLabel = "Модел кутије за Dead Drop",
                dropModelDescription = "GTA модел објекта који се локално ствара за доступна места за тајну примопредају.",
                dropStreamLabel = "Удаљеност за преношење за Dead Drop",
                dropStreamDescription = "Удаљеност на којој се преносе кутије и контакти за састанак NPC-а.",
                dropInteractionLabel = "Удаљеност интеракције за Dead Drop",
                dropInteractionDescription = "Удаљеност потребна за претрагу и узимање кутије.",
                dropLifetimeLabel = "Трајање Dead Drop-а (сати)",
                dropLifetimeDescription = "Време пре истека неузете кутије.",
                dropPollLabel = "Интервал освежавања света (мс)",
                dropPollDescription = "Интервал коришћен за освежавање блиских кутија и састанака NPC-а.",
                policeGroupsLabel = "Одобрене групе полицијских послова",
                policeGroupsDescription = "Кључеви група Конфигуратора послова који могу објавити понуде примамке и прегледати истраге.",
                policeGroupEntry = "Група полиције",
                groupKeyLabel = "Кључ групе",
                npcTradersLabel = "NPC купци и продавци",
                npcTradersDescription = "Конфигурација трајних NPC понуда, начина испоруке, репутације и вероватноће измаме.",
                npcTraderEntry = "NPC трговац",
                npcIdLabel = "ID",
                npcAliasLabel = "Алијас",
                npcSideLabel = "Страна тржишта",
                sideSell = "Продаје играчима",
                sideBuy = "Купује од играча",
                npcTitleLabel = "Наслов понуде",
                npcDescriptionLabel = "Опис",
                npcItemNameLabel = "Назив предмета инвентара",
                npcItemLabelLabel = "Назив робе",
                npcQuantityLabel = "Количина",
                npcPriceLabel = "Цена по јединици",
                npcDeliveryLabel = "Начин испоруке",
                deliveryBoth = "Састанак и Dead Drop",
                deliveryMeeting = "Само лице у лице",
                deliveryDrop = "Само Dead Drop",
                npcScamChanceLabel = "Вероватноћа за измаму трговца (%)",
                npcPedModelLabel = "Модел NPC педа",
                npcRatingLabel = "Приказана оцена",
                npcRatingCountLabel = "Приказан број оцена",
                npcTradesLabel = "Приказани успешни послови",
                npcVerifiedLabel = "Верификовани трговац",
                npcScammerLabel = "Познати преварант",
                npcEnabledLabel = "Укључено",
            },
            interrogationSettings = {
                section = "Испитивање",
                generalGroup = "Опште",
                consentGroup = "Заштита играча",
                objectGroup = "Објекти",
                grabGroup = "Ухват",
                sessionGroup = "Сесија",
                dispatchGroup = "Полицијске пријаве",
                loggingGroup = "Логирање",
                securityGroup = "Безбедност",
                presentationGroup = "Приказ",
                enabledLabel = "Омогући испитување",
                enabledDescription = "Омогући играчима да везују друге за столице за испитување и да користе алате на њима.",
                consentRequiredLabel = "Потребна сагласност",
                consentRequiredDescription = "Само играчи који су дали сагласност могу бити жртве. Ништа више не даје сагласност, па је потребна поставка испод.",
                consentDefaultLabel = "Подразумевана сагласност",
                consentDefaultDescription = "Нови карактери почињу са додељеном, а не одбијеном сагласношћу.",
                globalIntensityLabel = "Јачина ефекта",
                globalIntensityDescription = "Скалира ефекте на екрану, честице и звук. 0 их у потпуности искључује.",
                maxPerPlayerLabel = "Објекти по играчу",
                maxPerPlayerDescription = "Број столица и колица које један играч може поставити. 0 значи неограничено.",
                maxGlobalLabel = "Објекти на серверу",
                maxGlobalDescription = "Укупан број постављених објеката дозвољених истовремено. 0 значи неограничено.",
                placementDistanceLabel = "Удаљеност постављања",
                placementDistanceDescription = "Удаљеност од играча до постављеног објекта, у метрима.",
                interactDistanceLabel = "Дистанца интеракције",
                interactDistanceDescription = "Удаљеност коју играч мора бити од столице или колица да би их користио, у метрима.",
                inactivityMinutesLabel = "Аутоматско уклањање након",
                inactivityMinutesDescription = "Минута без употребе пре него што постављени објекат нестане. 0 га чува заувек.",
                persistObjectsLabel = "Зачувај објекте по рестарту",
                persistObjectsDescription = "Постављени објекти се враћају из базе података када сервер поново покрене.",
                grabEnabledLabel = "Омогући хватање",
                grabEnabledDescription = "Омогући играчима да превазиђу и однесу друге играче.",
                grabItemLabel = "Потребан предмет",
                grabItemDescription = "Предмет који нападач мора да има да бихватио некога. Оставите празно да не захтева ништа.",
                grabAngleLabel = "Угао приступања",
                grabAngleDescription = "Угао, у степенима, у којем жртва може стајати са стране или иза нападача.",
                grabHealthBelowLabel = "Порог здравља",
                grabHealthBelowDescription = "Жртва испод овог здравља може бити превазиђена без везивања. 0 га онемогућава.",
                grabCooldownLabel = "Време чекања након неуспеха",
                grabCooldownDescription = "Секунде пре него што се може поновити покушај након неуспешног хватања.",
                grabVehiclesLabel = "Дозвољена возила",
                grabVehiclesDescription = "Модел возила у које се може учитати превазиђена жртва.",
                carryEnabledLabel = "Омогући ношење",
                carryEnabledDescription = "Омогући нападачу да носи жртву преко рамена.",
                restrictVisionLabel = "Ограничи поглед жртве",
                restrictVisionDescription = "Затемни екран жртве док се транспортује.",
                escapeEnabledLabel = "Омогући покушаје бега",
                escapeEnabledDescription = "Омогући транспортованој жртви да покуша да се ослободи.",
                escapeSecondsLabel = "Трајање бегства",
                escapeSecondsDescription = "Секунде које жртва мора да држи тастер да би се ослободила.",
                maxDurationLabel = "Максимално трајање",
                maxDurationDescription = "Минута након којих се сесија сама завршава.",
                warnMinutesLabel = "Упозорење пре краја",
                warnMinutesDescription = "Минута пре ограничења када обе стране добијају упозорење.",
                idleMinutesLabel = "Ослобођење при неактивности",
                idleMinutesDescription = "Минута без било какве интеракције пре ослобађања жртве.",
                selfReleaseMinutesLabel = "Самослобођење након",
                selfReleaseMinutesDescription = "Минута без интеракције нападача пре него што се жртва може сама ослободити.",
                graceSecondsLabel = "Толеранција након прекида везе",
                graceSecondsDescription = "Секунде које жртва остаје везана када нападач напусти сервер.",
                rescueEnabledLabel = "Омогући спасавање",
                rescueEnabledDescription = "Омогући неучесницима да ослободе везану жртву.",
                rescueSecondsLabel = "Трајање спасавања",
                rescueSecondsDescription = "Секунде које спасилац треба да потроши да би резао везе жртве.",
                rescueItemLabel = "Предмет за спасавање",
                rescueItemDescription = "Предмет који спасилац треба да има. Оставите празно да не захтева ништа.",
                allowInventoryLabel = "Жртва чува инвентар",
                allowInventoryDescription = "Повезана жртва и даље може отворити свој инвентар.",
                dispatchEnabledLabel = "Укључи полицијске аларме",
                dispatchEnabledDescription = "Пријавите отмице и испитивања хитним службама.",
                dispatchAdapterLabel = "Систем пријаве",
                dispatchAdapterDescription = "Који систем пријаве прима пријаве.",
                dispatchJobsLabel = "Пријемни послови",
                dispatchJobsDescription = "Послови који добијају аларм.",
                dispatchGrabChanceLabel = "Шанса за хватање",
                dispatchGrabChanceDescription = "Процентуална шанса да се пријави хватање.",
                dispatchFixateChanceLabel = "Шанса за везивање",
                dispatchFixateChanceDescription = "Процентуална шанса да се пријави везивање некога за столицу.",
                dispatchToolChanceLabel = "Шанса за коришћење алата",
                dispatchToolChanceDescription = "Процентуална шанса да се пријави коришћење алата.",
                dispatchWitnessLabel = "Потребан сведок",
                dispatchWitnessDescription = "Пријављујте само када је други играч довољно близу да то примети.",
                dispatchWitnessRadiusLabel = "Радиус сведока",
                dispatchWitnessRadiusDescription = "Како близу сведок мора бити, у метрима.",
                dispatchCooldownLabel = "Време хлађења аларма",
                dispatchCooldownDescription = "Секунде између два аларма из истог испитивања.",
                dispatchInaccuracyLabel = "Непрецизност позиције",
                dispatchInaccuracyDescription = "Метри за које се пријављена позиција случајно помера. 0 пријављује тачну тачку.",
                loggingEnabledLabel = "Укључи евиденцију",
                loggingEnabledDescription = "Записујте постављања, хватања, коришћење алата, ослобађања и административне радње.",
                logDatabaseLabel = "Евиденција у базу података",
                logDatabaseDescription = "Додатно запишите сваки унос у табелу евиденције испитивања.",
                logRetentionLabel = "Чувајте уносе евиденције",
                logRetentionDescription = "Данова пре него што се уноси евиденције базе података обришу. 0 их чува заувек.",
                pingToleranceLabel = "Толеранција удаљености",
                pingToleranceDescription = "Метри додати свакој провери удаљености на серверској страни да би се апсорбовао лаг.",
                violationThresholdLabel = "Праг прекршаја",
                violationThresholdDescription = "Сигурносни прекршаји у временском прозору пре него што реакција делује. 0 их онемогућава.",
                violationActionLabel = "Реакција на прекршаје",
                violationActionDescription = "Шта се дешава када играч прелази праг прекршаја.",
                violationActionNone = "Не ради ништа",
                violationActionLog = "Само евиденција",
                violationActionKick = "Искочи",
                violationActionCheating = "Пријави као превару",
                particlesLabel = "Ефекти честица",
                particlesDescription = "Прикажи крв, искре и пламен током коришћења алата.",
                soundLabel = "Звучни ефекти",
                soundDescription = "Пуштајте звукове алата за све у близини.",
                cameraWorkLabel = "Ради са камером",
                cameraWorkDescription = "Померите камеру при везивању некога и током коришћења алата.",
                screenEffectsLabel = "Ефекти екрана",
                screenEffectsDescription = "Тресење, блесак, замућење и бојни филтери на екрану жртве.",
                objectsSection = "Објекти испитивања",
                objectsEntry = "Објекат",
                objectsEditLabel = "Објекти испитивања",
                objectsEditDescription = "Поставите сталне столице и колице за алате на мапу.",
                objectsEditButton = "Уредите објекте",
                objectsKindLabel = "Врста објекта",
                objectsKindChair = "Столица",
                objectsKindCart = "Колица за алате",
                objectsModelLabel = "Модел пропса",
                objectsPositionLabel = "Положај",
                blockedZonesSection = "Блокиране зоне",
                blockedZonesEntry = "Зона",
                blockedZonesEditLabel = "Блокиране зоне",
                blockedZonesEditDescription = "Површине где се не сме поставити објекат за испитивање.",
                blockedZonesEditButton = "Уреди зоне",
                blockedZonesZoneLabel = "Обрис зоне",
                blockedZonesZoneDescription = "Повукајте углове да обликујете област где је постављање забрањено.",
                toolsSection = "Алат",
                toolsEntry = "Алат",
                toolsEditLabel = "Алат",
                toolsEditDescription = "Додај или прилагоди алате који се могу користити на жртви.",
                toolsEditButton = "Уреди алате",
                toolsItemLabel = "Потребан предмет",
                toolsConsumeLabel = "Потроши предмет",
                toolsDamageLabel = "Штета по употребу",
                toolsHealthFloorLabel = "Минимално здравље",
                toolsCooldownLabel = "Време паузе у секундама",
                toolsProgressLabel = "Напредак по употребу",
                sessionsSection = "Трајуће сесије",
                sessionsEntry = "Сесија",
                sessionsEditLabel = "Трајуће сесије",
                sessionsEditDescription = "Прикажи ко се тренутно испитује и заврши сесију ако је потребно.",
                sessionsEditButton = "Прикажи сесије",
                sessionsStateLabel = "Стање",
                sessionsProgressLabel = "Напредак",
                orphansSection = "Напуштени објекти",
                orphansEntry = "Објекат",
                orphansEditLabel = "Напуштени објекти",
                orphansEditDescription = "Уклони објекте чији власник није био на линији дуго времена.",
                orphansEditButton = "Очисти",
                sessionStates = {
                    binding = "Vezivanje",
                    active = "Aktivna",
                    ending = "Završavanje",
                },
            },
        },
    },
}
