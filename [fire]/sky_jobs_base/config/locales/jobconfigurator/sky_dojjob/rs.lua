JobConfigLocales["sky_dojjob:rs"] = {
    Nui = {
        tablet = {
            apps = {
                doj_finance = "Финансије",
                doj_conditions = "Услови",
                doj_elections = "Избори",
                doj_files = "Истраживач предмета",
                doj_hearings = "Рочишта",
                doj_law = "Закони",
                doj_offences = "Каталог новчаних казни",
                doj_shared_files = "Дељени документи",
            },
        },
        workshopConfig = {
            registryFiles = { licenseType = "Vrsta licence", licenseLabel = "Naziv registra", marriages = "Matična knjiga venčanih" },
            configs = {
                sky_dojjob = {
                    subtitle = "Конфигуришите послове Министарства правде, судове и апликацију Лав Боок.",
                    title = "Службе правосуђа",
                },
            },
            creatorSections = {
                courthouses = {
                    entryLabel = "Зграда суда",
                    entryPluralLabel = "Зграда суда",
                    label = "Зграда суда",
                },
            },
            extensions = {
                invalidSelection = "Неважећи избор: {value}",
                trainingSettings = {
                    description = "Подеси приступ тренингу, упис, дозволе, и планирање курса за овај посао.",
                    label = "Поставке тренинга",
                },
            },
            features = {
                dojHandovers = {
                    label = "Predaje",
                    description = "Omogućava predaje, sudske odluke i izveštaje o izvršenju. Dokumenti i deljenje ostaju dostupni.",
                },
                dojBodycamRequests = {
                    label = "Zahtevi za snimke telesne kamere",
                    description = "Zatražite policijske snimke. Zahteva Predaje; sačuvani snimci ostaju dostupni nezavisno.",
                },
                dojFinance = { label = "Финансије", description = "Стања фракција, државни преноси и историја трансакција." },
                dojConditions = {
                    description = "Омогућава структуриране услове, доказе, рокове и обраду прекршаја.",
                    label = "Услови",
                },
                dojCourtroom = {
                    description = "Омогућава безбедне седнице, приказ доказа и интеракције у судници засноване на улогама.",
                    label = "Судница уживо",
                },
                dojElections = {
                    description = "Омогућава управљање изборима и безбедно гласање у регистрованим бирачким кабинама.",
                    label = "Избори",
                },
                dojHearings = {
                    description = "Омогућава заказивање судница, пријаву и званично управљање статусом рочишта.",
                    label = "Рочишта",
                },
                dojLegalCodes = {
                    description = "Омогућава правне књиге, уређивач богатог текста и историју ревизија.",
                    label = "Закони",
                },
                dojOffences = {
                    description = "Активира компактни каталог прекршаја и преглед калкулатора.",
                    label = "Каталог казни и казни",
                },
                dojPrinters = {
                    description = "Омогућава физичке штампаче и њихову инфраструктуру током рада.",
                    label = "Штампачи",
                },
                dojPublicDisplays = {
                    description = "Омогућава филтриране податке уживо за јавне екране у згради суда.",
                    label = "Јавни екрани судница",
                },
                dojTablet = {
                    description = "Омогућава приступ апликацијама за таблете Министарства правде.",
                    label = "ДОЈ Таблет",
                },
                dojTaxes = {
                    description = "Периодично наплаћује порез на возила и куће од играча који су на мрежи.",
                    label = "Порези на имовину",
                },
            },
            locations = {
                stationPosition = "Локација / маркер на мапи",
                stationPositionHint = "Главна тачка локације за овај посао. Ако је означена тачка на мапи омогућена под Посао → Ознаке, она ће се појавити овде.",
                addCourtroom = "Додај судницу",
                courtroom = "Судница",
                courtroom_display_desk_27 = "Приказ доказа – стони монитор од 27 инча",
                courtroom_display_wall_55 = "Приказ доказа – зидни телевизор од 55 инча",
                courtroom_display_wall_75 = "Приказ доказа – зидни телевизор од 75 инча",
                courtroom_display_wall_100 = "Приказ доказа – зидни телевизор од 100 инча",
                courtroom_display_wall_120 = "Приказ доказа – зидни телевизор од 120 инча",
                courtroom_display_wall_150 = "Приказ доказа – зидни телевизор од 150 инча",
                courtroom_display_board_93 = "Интерактивна табла – 150 инча са покретним постољем",
                courtroom_display_projection = "Екран за доказе – пројекционо платно од 4,5 m",
                courtroom_judge_mic = "Судница – судијски микрофон",
                courtroom_jury_room = "Судница – соба пороте",
                courtroom_room = "Судница – средиште публике / суднице",
                courtroom_witness = "Судница – место за сведока",
                electionBooth = "Бирачка кабина",
                publicDisplayDesk27 = "Јавни екран – стони монитор од 27 инча",
                publicDisplayTerminal43 = "Јавни екран – подни терминал од 43 инча",
                publicDisplayWall55 = "Јавни екран – зидни телевизор од 55 инча",
                publicDisplayWall75 = "Јавни екран – зидни телевизор од 75 инча",
                publicDisplayWall100 = "Јавни екран – зидни телевизор од 100 инча",
                publicDisplayWall120 = "Јавни екран – зидни телевизор од 120 инча",
                publicDisplayWall150 = "Јавни екран – зидни телевизор од 150 инча",
                publicDisplayProjection = "Јавни екран – пројекционо платно од 4,5 m",
                publicLegalCode = "Јавни законик",
            },
            printers = {
                groups = {
                    paper = "Papir",
                    ink = "Mastilo",
                    general = "Štampač",
                    printing = "Štampanje i pristup",
                    placement = "Model i položaj",
                },
                actions = {
                    selectExisting = "Изабери постојећи штампач",
                    selectExistingHint = "Нишани у штампач. Enter: изабери · Esc: откажи",
                    add = "Додај штампач",
                    open = "Прегледај штампач",
                    place = "Постави штампач",
                    setPosition = "Користи тренутну локацију",
                },
                classes = {
                    office = "Канцеларијски",
                    professional = "Професионални",
                    standard = "Стандардни",
                },
                description = "Подеси штампаче, потрошни материјал, редове, приступ и постављање за овај посао.",
                fieldDescriptions = {
                    paperCapacity = "Највећа количина папира за сваки штампач овог посла.",
                    paperEnabled = "Када је омогућено, сви штампачи овог посла почињу празни и захтевају заједнички предмет за допуну.",
                    refillAmount = "Количина папира која се додаје било ком штампачу овог посла заједничким предметом за допуну.",
                    refillItem = "Интерни назив предмета из инвентара који се троши приликом допуњавања било ког штампача овог посла.",
                },
                fields = {
                    active = "Активан",
                    class = "Класа",
                    heading = "Смер",
                    id = "Стабилни ID",
                    label = "Назив",
                    maxQueue = "Капацитет реда",
                    minimumGrade = "Минимални чин",
                    paperCapacity = "Капацитет папира",
                    paperEnabled = "Захтевај допуњавање папира",
                    propModel = "Модел објекта",
                    refillAmount = "Папир по предмету за допуну",
                    refillItem = "Предмет за допуну",
                    deleteCopiesAfterRestart = "Обриши копије после поновног покретања",
                    deleteCopiesAfterRestartHint = "Обриши непреузете отиске при поновном покретању сервиса за штампање.",
                    spawnProp = "Створи објекат",
                    speed = "Брзина штампања",
                    status = "Статус",
                    x = "X",
                    y = "Y",
                    z = "Z",
                },
                info = {
                    class = "Класа: {class}",
                    paper = "Папир: {paper} / {capacity}",
                    queue = "Ред: {queue} / {maxQueue}",
                    status = "Статус: {status}",
                    title = "Штампач",
                },
                messages = {
                    grade_too_low = "Твој чин је пренизак за овај штампач.",
                    invalid_amount = "Количина допуне није важећа.",
                    missingModel = "Изабери важећи модел објекта пре постављања.",
                    missing_refill_item = "Немаш подешени предмет за допуну.",
                    no_refill_printer = "У близини нема доступног штампача са укљученом залихом папира.",
                    paper_capacity_exceeded = "Капацитет папира би био прекорачен.",
                    paper_disabled = "Залиха папира је искључена за овај штампач.",
                    paper_full = "Залиха папира у овом штампачу је већ пуна.",
                    printer_inactive = "Овај штампач није активан.",
                    printer_not_found = "Штампач више не постоји.",
                    refill_cooldown = "Сачекај кратко пре следећег допуњавања.",
                    refilled = "Додато је {amount} папира. Стање: {paper} / {capacity}.",
                    too_far_away = "Приђи ближе штампачу.",
                    unavailable = "Штампач није доступан.",
                    wrong_job = "Не припадаш послу овог штампача.",
                },
                settings = {
                    description = "Ова подешавања важе за све штампаче подешене за овај посао.",
                    title = "Подешавања штампача за посао",
                },
                statuses = {
                    maintenance = "Одржавање",
                    offline = "Ван мреже",
                    online = "На мрежи",
                },
                title = "Штампачи",
                values = {
                    disabled = "Онемогућено",
                    enabled = "Омогућено",
                    selectItem = "Изабери предмет",
                },
            },
            recordsAccessGuide = {
                description = "Одредите ко може да приступа предметима и у којој области ради. Чинови без доделе немају приступ.",
                grades = {
                    assigned = "додељених чинова",
                    chooseDomain = "Реши доделу",
                    conflict = "Један чин има више додела. Изаберите једну област или Без приступа да бисте решили сукоб.",
                    description = "Изаберите једну област за сваки чин. Изаберите Без приступа за чинове који треба да остану закључани.",
                    domainColumn = "Област предмета",
                    empty = "Нису пронађени чинови за подешени DOJ посао.",
                    emptyHint = "Прво направите DOJ чинове у framework-у, а затим поново отворите конфигуратор.",
                    gradeColumn = "Чин",
                    noAccess = "Без приступа",
                    noResults = "Није пронађен одговарајући чин.",
                    notFound = "Више не постоји у framework-у",
                    search = "Претражи чинове",
                    title = "Чинови и области",
                },
                publish = {
                    saveHint = "Кликните на Сачувај на врху да примените измене. Играчи затим могу поново да провере свој приступ.",
                },
                status = {
                    conflict = "Решите дупле доделе",
                    disabled = "DOJ таблет је искључен",
                    incomplete = "Доделите најмање један чин",
                    ready = "Спремно за чување",
                    unpublished = "Мапирање још није објављено",
                },
                steps = {
                    gradesText = "Изаберите тачно једну област предмета за сваки чин који треба да има приступ.",
                    gradesTitle = "Доделите DOJ чинове",
                    publishText = "После сваке измене аутоматски се припрема нова верзија мапирања.",
                    publishTitle = "Објавите и сачувајте",
                    tabletText = "Таблет мора бити укључен да би се отвориле апликације за предмете.",
                    tabletTitle = "Укључите DOJ таблет",
                },
                title = "Подешавање приступа предметима",
            },
            settingGroups = {
                dojWarrants = { label = "Sudski nalozi" },
                dojAccess = {
                    label = "Приступ",
                },
                dojCourthouseBlip = {
                    label = "Означивач на мапи",
                },
                dojLegalBooks = {
                    label = "Књиге",
                },
                dojLegalContentLimits = {
                    label = "Ограничења садржаја",
                },
                dojLegalItem = {
                    label = "Предмет инвентара",
                },
                dojLegalRateLimits = {
                    label = "Ограничења стопе",
                },
                dojLegalRevisions = {
                    label = "Ревизије",
                },
                dojLegalTransfers = {
                    label = "Велики документи",
                },
                dojOffenceCalculation = {
                    label = "Калкулатор",
                },
                dojOffenceRateLimits = {
                    label = "Ограничења стопе",
                },
                dojOffenceMiranda = {
                    label = "Напомене уз каталог",
                },
                dojOffenceSource = {
                    label = "Извор каталога",
                },
                dojRecordsGradeBindings = {
                    description = "Доделите сваки доступан DOJ чин тачно једној области предмета, а затим објавите мапирање.",
                    label = "Чинови и области предмета",
                },
                dojTaxPayment = {
                    label = "Плаћање",
                },
                dojTaxRates = {
                    label = "Пореске стопе",
                },
                dojTaxSchedule = {
                    label = "Распоред",
                },
            },
            registryCatalog = {
                names = {
                    notarial_contracts = "Јавнобележнички уговори",
                    powers_of_attorney = "Пуномоћја",
                    name_changes = "Промене имена",
                    company_registry = "Регистар привредних друштава",
                    association_registry = "Регистар удружења",
                    licensing = "Лиценцирање",
                    administrative_decisions = "Управне одлуке",
                    administrative_objections = "Управни приговори",
                },
            },
            settingSections = {
                finance = "Финансије",
                courtroom = "Sudnica",
                registries = "Регистри",
                courthouses = "Зграда суда",
                general = "Генерал",
                legalCodes = "Закони",
                offences = "Каталог новчаних казни",
                recordsAccess = "Приступ предметима",
                tablet = "Таблет",
                taxes = "Порези",
            },
            gavel = {
                enabled = "Omogućeno",
                cooldown = "Pauza između pokretanja (ms)",
                defaultPreset = "Podrazumevani udarci",
                prop = "Model čekića",
                model = "Naziv modela",
                bone = "ID kosti šake",
                offset = "Pomeraj (metri)",
                rotation = "Rotacija (stepeni)",
                presets = "Redosledi udaraca",
                single = "Jedan udarac",
                double = "Dvostruki udarac",
                strikes = "Broj udaraca",
                interval = "Razmak udaraca (ms)",
                impact = "Kašnjenje zvuka (ms)",
                audio = "Zvuk",
                asset = "Audio datoteka",
                volume = "Jačina zvuka",
                animation = "Animacija",
                dict = "Direktorijum animacije",
                clip = "Naziv animacije",
                duration = "Trajanje pokreta (ms)",
                flag = "Zastavice animacije",
                x = "X",
                y = "Y",
                z = "Z",
            },
            settings = {
                dojRegistryLicenses = {
                    label = "Registri licenci",
                    description = "Izaberite licence koje DOJ sme da izdaje. Svaki unos je zaseban registar. Uklanjanje unosa ne oduzima postojeće licence.",
                },
                dojRegistryAccess = {
                    ["label"] = "Pristup registrima iz datoteka",
                    ["description"] = "Podesite pristup registrima iz config/registry. Prazna lista koristi podrazumevane vrednosti datoteka. Polja i serverske/klijentske funkcije menjaju se u Lua datotekama.",
                },
                dojTreasuryJob = { label = "Посао државног рачуна", description = "Посао чији заједнички рачун прима наплате и плаћа преносе." },
                dojFinanceJobs = { label = "Видљиве фракције", description = "Кључеви регистрованих послова у прегледу. Државни рачун је увек укључен." },
                dojFinanceLimit = { label = "Лимит трансакције", description = "Највећи износ по преносу или наплати." },
                dojFinePaymentMode = { label = "Наплата новчаних казни", description = "Директна банковна наплата или спољна фактура. Издавање фактуре не потврђује плаћање.", options = { bank = "Банковна наплата", billing = "Фактура" } },
                dojFineSociety = { label = "Прималац казни", description = "Посао чији заједнички рачун прима новчане казне." },
                dojCourtroomGavel = {
                    label = "Sudijski čekić",
                    description = "Model čekića, položaj u šaci, animacija, zvuk i redosled udaraca. Promene važe bez ponovnog pokretanja.",
                },
                dojHearingParticipantRoles = {
                    label = "Улоге учесника",
                    description = "Подразумевано: defendant (оптужени), witness (сведок), juror (поротник), judge (судија). Додајте кључеве малим латиничним словима (до 24 знака, дозвољена доња црта). Задржите judge. Прилагођене улоге не дају овлашћења судије или пороте.",
                },
                dojWarrantTemplateCodes = {
                    label = "Šifre šablona naloga",
                    description = "Šifre šablona prikazanih u policijskim nalozima nakon potpisa sudije i deljenja. Podrazumevano: HB, DB, RB.",
                },
                dojCourtroomBoardMove = { label = "Померање табле у судници", description = "Подразумевани тастер за преузимање или спуштање табле (нпр. F). Играчи га могу променити у FiveM подешавањима. Позиција се враћа након поновног покретања." },
                dojRegistryCatalog = {
                    label = "DOJ регистри",
                    description = "Укључите и именујте DOJ регистре, затим подесите приступ пословима и нивое овлашћења. Постојећа права DOJ улога и даље важе. Прилагођени RP регистри се подешавају у Jobs Base.",
                },
                dojCourthouseBlipCategory = {
                    description = "Назив категорије за ознаке на мапи суда.",
                    label = "Блип категорија",
                },
                dojCourthouseBlipColor = {
                    description = "Тужба за карту суда.",
                    label = "Блип Цолор",
                },
                dojCourthouseBlipScale = {
                    description = "Величина карте у згради суда.",
                    label = "Величина слике",
                },
                dojCourthouseBlipShortRange = {
                    description = "Приказујте сигнале суда само на кратким удаљеностима.",
                    label = "Кратки домет",
                },
                dojCourthouseBlipSprite = {
                    description = "Икона мапе суда.",
                    label = "Блип Сприте",
                },
                dojLegalBookItem = {
                    description = "Предмет за сачувано издање закона. Прва употреба чува садржај и датум; потребни су појединачни предмети са метаподацима.",
                    label = "Предмет књиге закона",
                },
                dojLegalCreateBookRateLimitMs = {
                    description = "Минимални интервал у милисекундама између захтева за креирање.",
                    label = "Цоолдовн Креирај код",
                },
                dojLegalCreateRevisionRateLimitMs = {
                    description = "Минимални интервал у милисекундама између нових ревизија.",
                    label = "Цоолдовн Креирај ревизију",
                },
                dojLegalDeleteBookRateLimitMs = {
                    description = "Минимална удаљеност у милисекундама између брисања кода.",
                    label = "Цоолдовн Цлеар Цоде",
                },
                dojLegalDeleteRevisionRateLimitMs = {
                    description = "Минимални интервал у милисекундама између брисања ревизија.",
                    label = "Цлеар Ревисион",
                },
                dojLegalGetBookRateLimitMs = {
                    description = "Минимални интервал у милисекундама између упита у књизи закона.",
                    label = "Цоолдовн Лоад Цоде",
                },
                dojLegalGetBooksRateLimitMs = {
                    description = "Минимални интервал у милисекундама између захтева са листе закона.",
                    label = "Цоолдовн Лоад Либрари",
                },
                dojLegalLargeRequestTimeoutMs = {
                    description = "Минимално временско ограничење за захтеве са великим садржајем документа.",
                    label = "Велико временско ограничење захтева у милисекундама",
                },
                dojLegalMaxAbbreviationLength = {
                    description = "Максималан број знакова за скраћеницу правног кода.",
                    label = "Максимална дужина скраћенице",
                },
                dojLegalMaxBookTitleLength = {
                    description = "Максималан број знакова за наслов правне књиге.",
                    label = "Максимална дужина наслова књиге",
                },
                dojLegalMaxContentBytes = {
                    description = "Максимална серијализована величина пуне ревизије кода.",
                    label = "Максимална величина садржаја у бајтовима",
                },
                dojLegalMaxParagraphTitleLength = {
                    description = "Максимална дужина наслова при увозу старих структурираних пасуса.",
                    label = "Максимална дужина старих наслова пасуса",
                },
                dojLegalMaxParagraphsPerBook = {
                    description = "Максималан број структурираних пасуса за старије формате увоза.",
                    label = "Максималан број старих пасуса по књизи",
                },
                dojLegalMaxRevisionSummaryLength = {
                    description = "Максималан број знакова за описивање промене.",
                    label = "Максимална дужина белешке о ревизији",
                },
                dojLegalMaxRichTextNodes = {
                    description = "Максималан број уређивачких чворова унутар ревизије.",
                    label = "Максимални чворови богатог текста",
                },
                dojLegalPayloadBytesPerSecond = {
                    description = "Ограничење пропусног опсега по играчу за пренос великих правних докумената.",
                    label = "Брзина преноса у бајтовима у секунди",
                },
                dojLegalReorderBooksRateLimitMs = {
                    description = "Минимални интервал у милисекундама између захтева за сортирање.",
                    label = "Цоолдовн Сорт Боокс",
                },
                dojLegalUpdateBookRateLimitMs = {
                    description = "Минимални интервал у милисекундама између промена метаподатака.",
                    label = "Цоолдовн Едит Цоде",
                },
                dojLegalVisibleRevisionHistory = {
                    description = "Максималан број ревизија учитаних приликом отварања правне књиге.",
                    label = "Видљива историја ревизија",
                },
                dojOffenceCalculateRateLimitMs = {
                    description = "Минимална удаљеност у милисекундама између прегледа калкулатора на страни сервера.",
                    label = "Калкулатор хлађења",
                },
                dojOffenceGetCatalogueRateLimitMs = {
                    description = "Минимални интервал у милисекундама између захтева за каталог.",
                    label = "Цоолдовн Лоад Цаталог",
                },
                dojOffenceMaxSelection = {
                    description = "Максималан број прекршаја у прегледу калкулатора.",
                    label = "Максимални избор",
                },
                dojOffenceMutationRateLimitMs = {
                    description = "Минимални интервал у милисекундама између промена у каталогу казни.",
                    label = "Цоолдовн Каталог Уреди",
                },
                dojOffenceMirandaWarning = {
                    description = "Прилагођено упозорење приказано у каталогу казни. Оставите празно да бисте користили подразумевани текст на изабраном језику.",
                    label = "Мирандино упозорење",
                },
                dojPrimaryColor = {
                    description = "Главна боја групе послова ДОЈ-а и таблета.",
                    label = "Примарна боја",
                },
                dojRecordsCourtAdministrationGradeKeys = {
                    description = "Ови чинови раде са управним и регистарским предметима суда.",
                    label = "Судска управа",
                },
                dojRecordsJudiciaryGradeKeys = {
                    description = "Ови чинови раде са судским предметима и одлукама.",
                    label = "Судство",
                },
                dojRecordsMappingVersion = {
                    description = "Објављена ревизија мапирања чинова на области предмета. Празна вредност задржава приступ закључаним.",
                    label = "Верзија објаве",
                },
                dojRecordsProsecutionGradeKeys = {
                    description = "Ови чинови раде са тужилачким предметима.",
                    label = "Тужилаштво",
                },
                dojTabletRequireDuty = {
                    description = "Само запосленима у ДОЈ-у на дужности је дозвољено да отворе апликацију Цоде.",
                    label = "Потребна услуга",
                },
                dojTaxCurrency = {
                    description = "Sky Base валута која се користи само када је начин плаћања директан.",
                    label = "Валута за директну наплату",
                },
                dojTaxHouseAmount = {
                    description = "Износ који се наплаћује за сваку кућу у власништву играча.",
                    label = "Порез по кући",
                },
                dojTaxInitialDelaySeconds = {
                    description = "Број секунди до прве наплате када није сачуван претходни порески циклус.",
                    label = "Почетно одлагање",
                },
                dojTaxIntervalMinutes = {
                    description = "Број минута између аутоматских циклуса наплате пореза на имовину.",
                    label = "Интервал наплате",
                },
                dojTaxNotifyPlayer = {
                    description = "Обавештава играче након директне наплате, слања рачуна или када немају довољно средстава.",
                    label = "Обавести играче",
                },
                dojTaxPaymentMode = {
                    description = "Директно користи изабрани bank/money салдо или шаље један Sky Base рачун друштва за сваког опорезивог играча у сваком пореском циклусу.",
                    label = "Начин плаћања",
                    options = {
                        bills = "Sky Base рачуни",
                        direct = "Bank/money салдо",
                    },
                },
                dojTaxSocietyJob = {
                    description = "ДОЈ посао чији конфигурисани рачун друштва прима сав порески приход.",
                    label = "ДОЈ посао прималац",
                },
                dojTaxVehicleAmount = {
                    description = "Износ који се наплаћује за свако возило у власништву играча.",
                    label = "Порез по возилу",
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
