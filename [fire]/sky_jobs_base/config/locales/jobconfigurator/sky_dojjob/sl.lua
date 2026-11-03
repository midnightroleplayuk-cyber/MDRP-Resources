JobConfigLocales["sky_dojjob:sl"] = {
    Nui = {
        tablet = { apps = { doj_finance = "Financiranje" ,
                doj_conditions = "Zdravstvena stanja",
                doj_elections = "Volitve",
                doj_files = "Raziskovalnik datotek",
                doj_hearings = "Zaslišanja",
                doj_law = "Pravni zakonik",
                doj_offences = "Fini katalog",
                doj_shared_files = "Deljeni dokumenti",
            } },
        workshopConfig = {
            recordsAccessGuide = {
                title = "Nastavitev dostopa do spisov",
                description = "Izberite, kdo ima dostop do zapisov in na katerem področju dela. Čini brez dodelitve nimajo dostopa.",
                status = {
                    unpublished = "Dodelitev še ni objavljena",
                    conflict = "Odpravite podvojene dodelitve",
                    disabled = "Tablica DOJ je izklopljena",
                    incomplete = "Dodelite vsaj en čin",
                    ready = "Pripravljeno za shranjevanje",
                },
                steps = {
                    tabletTitle = "Omogočite tablico DOJ",
                    tabletText = "Za odpiranje aplikacij s spisi mora biti tablica omogočena.",
                    gradesTitle = "Dodelite čine DOJ",
                    gradesText = "Za vsak čin, ki naj dobi dostop, izberite natanko eno področje zapisov.",
                    publishTitle = "Objavite in shranite",
                    publishText = "Po vsaki spremembi dodelitev se samodejno pripravi nova različica.",
                },
                grades = {
                    title = "Dodelitve činov",
                    description = "Za vsak čin izberite eno področje. Za čine, ki ne smejo imeti dostopa, izberite Brez dostopa.",
                    search = "Išči čine",
                    conflict = "Čin ima več dodelitev. Izberite eno področje ali Brez dostopa, da odpravite spor.",
                    notFound = "V ogrodju ne obstaja več",
                    noResults = "Ustreznega čina ni mogoče najti.",
                    empty = "Za nastavljeno službo DOJ ni bilo mogoče najti činov.",
                    emptyHint = "Najprej ustvarite čine DOJ v ogrodju, nato znova odprite konfigurator.",
                    gradeColumn = "Čin",
                    domainColumn = "Področje zapisov",
                    noAccess = "Brez dostopa",
                    chooseDomain = "Odpravite spor dodelitev",
                    assigned = "dodeljenih činov",
                },
                publish = {
                    saveHint = "Zgornji gumb Shrani uporabi spremembe. Igralci lahko nato znova preverijo svoj dostop.",
                },
            },
            registryFiles = { licenseType = "Vrsta licence", licenseLabel = "Ime registra", marriages = "Poročni register" },
            features = {
                dojHandovers = {
                    label = "Predaje",
                    description = "Omogoči predaje, sodne odločbe in poročila o izvršitvi. Dokumenti in skupna raba ostanejo na voljo.",
                },
                dojBodycamRequests = {
                    label = "Zahteve za posnetke telesne kamere",
                    description = "Zahtevajte policijske posnetke. Zahteva Predaje; shranjeni posnetki ostanejo na voljo neodvisno.",
                },
                dojFinance = { label = "Financiranje", description = "Stanja frakcij, prenosi državne blagajne in zgodovina transakcij." },
                dojConditions = {
                    description = "Aktiviraj strukturirane pogoje, dokaze, roke in spremljanje kršitev.",
                    label = "Zdravstvena stanja",
                },
                dojCourtroom = {
                    description = "Aktiviraj varne sestanke v sodišču v živo, predstavitev dokazov in sobne interakcije, ki temeljijo na vlogah.",
                    label = "Živo sodno sodišče",
                },
                dojElections = {
                    description = "Aktivirajte volilno upravo in varno glasujte na registriranih volilnih kabinah.",
                    label = "Volitve",
                },
                dojHearings = {
                    description = "Aktivirajte urnik sodnega dvorana, check-in in avtoritetni nadzor stanja sluha.",
                    label = "Zaslišanja",
                },
                dojLegalCodes = {
                    description = "Aktiviraj pravne knjige, ureditev bogatega besedila in revizijsko zgodovino.",
                    label = "Pravni kodeksi",
                },
                dojOffences = {
                    description = "Aktivirajte kompaktni katalog kaznivih dejanj in ogled kalkulatorja.",
                    label = "Fini katalog",
                },
                dojPrinters = {
                    description = "Aktiviraj fizične tiskalnike in njihovo infrastrukturo.",
                    label = "Tiskalniki",
                },
                dojPublicDisplays = {
                    description = "Aktiviraj podatke o zasebnosti, filtrirane v živo za zaslone sodišča.",
                    label = "Javni prikazi sodnega sodišča",
                },
                dojTablet = {
                    description = "Aktivirajte dostop do DOJ tabletnih aplikacij.",
                    label = "DOJ tableta",
                },
                dojTaxes = {
                    description = "Periodično zbiranje davkov vozil in hiš od spletnih igralcev.",
                    label = "Davki na premoženje",
                },
            },
            settingSections = {
                finance = "Financiranje",
                courtroom = "Sodišče",
                registries = "Register",
                courthouses = "Sodišča",
                general = "Splošno",
                legalCodes = "Pravni kodeksi",
                offences = "Fini katalog",
                recordsAccess = "Dostop do datoteke s primerom",
                tablet = "Tablica",
                taxes = "Davki",
            },
            settings = {
                dojRegistryLicenses = {
                    label = "Registri licenc",
                    description = "Izberite licence, ki jih sme DOJ izdajati. Vsak vnos ima svoj register. Odstranitev vnosa ne odvzame obstoječih licenc.",
                },
                dojRegistryAccess = {
                    ["label"] = "Dostop do registrov iz datotek",
                    ["description"] = "Prilagodite dostop do registrov v config/registry. Prazen seznam uporabi privzete vrednosti datotek. Polja in strežniške/odjemalske funkcije urejate v datotekah Lua.",
                },
                dojTreasuryJob = { label = "Služba državne blagajne", description = "Služba, katere skupni račun prejema izterjave in plačuje prenose." },
                dojFinanceJobs = { label = "Vidne frakcije", description = "Ključi registriranih služb v pregledu računov. Državna blagajna je vedno vključena." },
                dojFinanceLimit = { label = "Omejitev transakcije", description = "Najvišji znesek posameznega prenosa ali izterjave." },
                dojFinePaymentMode = { label = "Plačilo naloženih glob", description = "Neposredno bančno plačilo ali zunanji račun. Izdaja računa ne potrjuje plačila.", options = { bank = "Bančno plačilo", billing = "Račun" } },
                dojFineSociety = { label = "Prejemnik glob", description = "Služba, katere skupni račun prejema naložene globe." },
                dojCourtroomBoardMove = {
                    label = "Premaknite sodno sodišče",
                    description = "Privzeta tipka za ugrabitev ali sprostitev mobilne plošče (npr. F). Igralci jo lahko premaknejo v povezavi s tipko FiveM. Premik je začasen in se po ponovnem ponovnem zagonu.",
                },
                dojCourtroomGavel = {
                    label = "Sodnik Hall.",
                    description = "Model, ročna pritrditev, animacija, zvok in udarec vzorci. Spremembe se uporabljajo tudi brez ponovnega zagona.",
                },
                dojHearingParticipantRoles = {
                    label = "Sodelujoče vloge",
                    description = "Privzete vloge: tožena, priča, porotnik, sodnik. Dodajte tu ključe iz navadne majhne vloge (do 24 znakov, dovoljena poudarek). Držite sodnika. Prilagojene vloge ne odobrijo sodniku ali poroti dovoljenj.",
                },
                dojWarrantTemplateCodes = {
                    label = "Oznake predloge naloga",
                    description = "Kode predlog, prikazane pod PD Nalogi po sodnem podpisu in delitvi. Privzeto: HB, DB, RB.",
                },
                dojRegistryCatalog = {
                    label = "DOJ registri",
                    description = "Aktivirajte in ime DOJ registrov, nato nastavite poklicni dostop in klirens. Obstoječa DOJ dovoljenja za vloge še vedno velja. Posebnost RP registrov se upravljajo v poklicih Base.",
                },
                dojCourthouseBlipCategory = {
                    description = "Nalepka kategorije, ki se uporablja za karte sodnega sodišča.",
                    label = "Kategorija blipsa",
                },
                dojCourthouseBlipColor = {
                    description = "Barva zemljevida, ki se uporablja za sodišče.",
                    label = "Barva trepalnice",
                },
                dojCourthouseBlipScale = {
                    description = "Zemljevidna lestvica, ki se uporablja za sodne mišice.",
                    label = "Lestvica potisnjenega tlaka",
                },
                dojCourthouseBlipShortRange = {
                    description = "Prikaži samo blips na sodišču v kratkem dosegu.",
                    label = "Kratek doseg",
                },
                dojCourthouseBlipSprite = {
                    description = "Sprite iz zemljevida, ki se uporablja za sodišče.",
                    label = "Ikona oznake na zemljevidu",
                },
                dojLegalBookItem = {
                    description = "Inventarna postavka za fiksno pravno kodo izdajo. Prva uporaba prihrani njeno vsebino in datum; zahteva posamezno postavko z metapodatki.",
                    label = "Postavka pravne kode",
                },
                dojLegalCreateBookRateLimitMs = {
                    description = "Minimalne milisekunde med zahtevami za ustvarjanje pravnih knjig.",
                    label = "Ustvari hlajenje knjige",
                },
                dojLegalCreateRevisionRateLimitMs = {
                    description = "Minimalne milisekunde med zahtevami za revizijo.",
                    label = "Ustvari hlajenje revizije",
                },
                dojLegalDeleteBookRateLimitMs = {
                    description = "Minimalne milisekunde med zahtevami za izbris pravne knjige.",
                    label = "Zbriši shlajanje knjige",
                },
                dojLegalDeleteRevisionRateLimitMs = {
                    description = "Minimalne milisekunde med zahtevami za brisanje revizije.",
                    label = "Zbriši hlajenje revizije",
                },
                dojLegalGetBookRateLimitMs = {
                    description = "Minimalne milisekunde med zahtevami za pravno knjigo.",
                    label = "Naloži ohlajanje knjige",
                },
                dojLegalGetBooksRateLimitMs = {
                    description = "Minimalne milisekunde med zahtevami za seznam pravnih knjig.",
                    label = "Naloži sproščanje knjižnice",
                },
                dojLegalLargeRequestTimeoutMs = {
                    description = "Najmanjši čas, ki se uporablja za velike zahteve po dokumentih.",
                    label = "Zakasnitev velike zahteve v milisekundah",
                },
                dojLegalMaxAbbreviationLength = {
                    description = "Največje število znakov, dovoljenih v skrajšanju pravne knjige.",
                    label = "Največja dolžina kratice",
                },
                dojLegalMaxBookTitleLength = {
                    description = "Največje število znakov, dovoljenih v naslovu pravne knjige.",
                    label = "Največja dolžina naslova knjige",
                },
                dojLegalMaxContentBytes = {
                    description = "Največja serijezirana velikost ene popolne revizije pravne knjige.",
                    label = "Največja vsebnost v bajtih",
                },
                dojLegalMaxParagraphTitleLength = {
                    description = "Največja dolžina naslova, sprejeta med uvozom zastarelih strukturiranih odstavkov.",
                    label = "Največja dolžina naslova zastarelega odstavka",
                },
                dojLegalMaxParagraphsPerBook = {
                    description = "Največje število strukturiranih odstavkov, sprejetih med zapuščenim uvozom.",
                    label = "Največji zapuščinski odstavki na knjigo",
                },
                dojLegalMaxRevisionSummaryLength = {
                    description = "Največje število znakov, dovoljenih v revizijskem sporočilu.",
                    label = "Največja dolžina revizijske opombe",
                },
                dojLegalMaxRichTextNodes = {
                    description = "Največje število urejevalnih vozlišč dovoljeno v eni reviziji.",
                    label = "Največja vozlišča z bogatim besedilom",
                },
                dojLegalPayloadBytesPerSecond = {
                    description = "Omejitev pasovne širine na igralca, ki se uporablja za prenos velikih pravnih dokumentov.",
                    label = "Stopnja prenosa v bajtih na sekundo",
                },
                dojLegalReorderBooksRateLimitMs = {
                    description = "Minimalne milisekunde med zahtevami za preurejanje pravne knjige.",
                    label = "Popravek hlajenja knjig",
                },
                dojLegalUpdateBookRateLimitMs = {
                    description = "Najmanjša milisekunda med posodobitvami pravnih knjig.",
                    label = "Posodobi sprostitev knjige",
                },
                dojLegalVisibleRevisionHistory = {
                    description = "Največje število naloženih revizij pri odpiranju pravne knjige.",
                    label = "Zgodovina vidnih revizij",
                },
                dojOffenceCalculateRateLimitMs = {
                    description = "Najmanjše milisekunde med pregledi kalkulatorja na strani strežnika.",
                    label = "Ohlajanje kalkulatorja",
                },
                dojOffenceGetCatalogueRateLimitMs = {
                    description = "Minimalne milisekunde med zahtevami za katalog.",
                    label = "Ohlajanje kataloga nalaganja",
                },
                dojOffenceMaxSelection = {
                    description = "Največje število kaznivih dejanj, vključenih v ogled kalkulatorja.",
                    label = "Največja izbira",
                },
                dojOffenceMutationRateLimitMs = {
                    description = "Najmanj milisekund med spremembami v katalogu kaznivih dejanj.",
                    label = "Uredi hlajenje kataloga",
                },
                dojOffenceMirandaWarning = {
                    description = "Posebno opozorilo, prikazano v fine katalogu. Pustite prazno za uporabo standardnega besedila v izbranem jeziku.",
                    label = "Opozorilo Mirande",
                },
                dojPrimaryColor = {
                    description = "Glavna barva, ki jo uporabljata skupina poslov in tableta DOJ.",
                    label = "Primarna barva",
                },
                dojRecordsCourtAdministrationGradeKeys = {
                    description = "Te ocene delujejo s sodno upravo in registrskimi zapisi.",
                    label = "Uprava sodišča",
                },
                dojRecordsJudiciaryGradeKeys = {
                    description = "Te ocene delujejo s pravosodnimi zapisi in odločitvami.",
                    label = "Sodstvo",
                },
                dojRecordsMappingVersion = {
                    description = "Objavljena revizija mape razredov-to-rekordov-domain. Prazna vrednost vodi evidence dostopa onemogočen.",
                    label = "Različica objave",
                },
                dojRecordsProsecutionGradeKeys = {
                    description = "Te ocene delujejo s tožilskimi zapisi.",
                    label = "Tožilstvo",
                },
                dojTabletRequireDuty = {
                    description = "Samo na delovnem mestu DOJ zaposleni lahko odprejo pravno kodno aplikacijo.",
                    label = "Zahteva dolžnost",
                },
                dojTaxCurrency = {
                    description = "Sky Base currency used only when the payment method is direct.",
                    label = "Neposredna valuta",
                },
                dojTaxHouseAmount = {
                    description = "Znesek, ki ga zaračunava vsaka hiša v lasti igralca.",
                    label = "Davek na hišo",
                },
                dojTaxInitialDelaySeconds = {
                    description = "Sekunde, ki čakajo pred prvo zbirko, ko predhodni davčni ciklus ni shranjen.",
                    label = "Začetna zamuda",
                },
                dojTaxIntervalMinutes = {
                    description = "zapisnik med cikli avtomatskega zbiranja sredstev in davkov.",
                    label = "Interval zbiranja",
                },
                dojTaxNotifyPlayer = {
                    description = "Obvestite igralce po neposredni zbirki, predložitvi zakona ali nezadostnih sredstev.",
                    label = "Obvesti igralce",
                },
                dojTaxPaymentMode = {
                    description = "Uporabite izbrano bančno stanje / denar neposredno ali predložite en račun družbe Sky Base na obdavčljivega igralca in davčni ciklus.",
                    label = "Način plačila",
                    options = {
                        bills = "Sky Base bills",
                        direct = "Banka / denarna bilanca",
                    },
                },
                dojTaxSocietyJob = {
                    description = "DOJ poklic, katerega nastavljeni račun družbe prejme vse zbrane davčne prihodke.",
                    label = "Prejemnik DOJ poklic",
                },
                dojTaxVehicleAmount = {
                    description = "Znesek, zaračunan za vsako vozilo v lasti igralca.",
                    label = "Davek na vozilo",
                },
            },
            printers = {
                groups = {
                    paper = "Papir",
                    ink = "Črnilo",
                    general = "Tiskalnik",
                    printing = "Tiskanje in dostop",
                    placement = "Model in postavitev",
                },
                actions = {
                    selectExisting = "Izberi obstoječi tiskalnik",
                    selectExistingHint = "Nameri v tiskalnik. Enter: izberi · Esc: prekliči",
                    add = "Dodaj tiskalnik",
                    open = "Preglej tiskalnik",
                    place = "Postavi tiskalnik",
                    setPosition = "Uporabi trenutni položaj",
                },
                classes = {
                    office = "Pisarniški",
                    professional = "Profesionalni",
                    standard = "Standardni",
                },
                description = "Nastavi tiskalnike, potrošni material, čakalne vrste, dostop in postavitev za to službo.",
                fieldDescriptions = {
                    paperCapacity = "Največja zaloga papirja v vsakem tiskalniku te službe.",
                    paperEnabled = "Ko je možnost omogočena, so tiskalniki te službe sprva prazni in potrebujejo skupni predmet za polnjenje.",
                    refillAmount = "Količina papirja, dodana tiskalniku te službe ob uporabi skupnega predmeta za polnjenje.",
                    refillItem = "Interno ime predmeta v inventarju, ki se porabi ob polnjenju tiskalnika te službe.",
                },
                fields = {
                    active = "Aktiven",
                    class = "Razred",
                    heading = "Smer",
                    id = "Stalni ID",
                    label = "Ime",
                    maxQueue = "Velikost čakalne vrste",
                    minimumGrade = "Najnižji čin",
                    paperCapacity = "Zmogljivost za papir",
                    paperEnabled = "Zahtevaj dodajanje papirja",
                    propModel = "Model objekta",
                    refillAmount = "Papir na predmet za polnjenje",
                    refillItem = "Predmet za polnjenje",
                    deleteCopiesAfterRestart = "Izbriši kopije ob ponovnem zagonu",
                    deleteCopiesAfterRestartHint = "Ob ponovnem zagonu tiskalne storitve izbriši neprevzete izpise.",
                    spawnProp = "Ustvari objekt",
                    speed = "Hitrost tiskanja",
                    status = "Stanje",
                    x = "X",
                    y = "Y",
                    z = "Z",
                },
                info = {
                    class = "Razred: {class}",
                    paper = "Papir: {paper} / {capacity}",
                    queue = "Čakalna vrsta: {queue} / {maxQueue}",
                    status = "Stanje: {status}",
                    title = "Tiskalnik",
                },
                messages = {
                    grade_too_low = "Vaš čin je prenizek za ta tiskalnik.",
                    invalid_amount = "Količina za polnjenje ni veljavna.",
                    missingModel = "Pred postavitvijo izberite veljaven model tiskalnika.",
                    missing_refill_item = "Nimate nastavljenega predmeta za polnjenje.",
                    no_refill_printer = "V bližini ni dostopnega tiskalnika z omogočeno porabo papirja.",
                    paper_capacity_exceeded = "Največja zaloga papirja bi bila presežena.",
                    paper_disabled = "Poraba papirja je za ta tiskalnik izklopljena.",
                    paper_full = "Predal za papir tega tiskalnika je že poln.",
                    printer_inactive = "Ta tiskalnik je izklopljen.",
                    printer_not_found = "Tiskalnik ne obstaja več.",
                    refill_cooldown = "Pred ponovnim polnjenjem malo počakajte.",
                    refilled = "Dodanih je {amount} listov. Zaloga: {paper} / {capacity}.",
                    too_far_away = "Približajte se tiskalniku.",
                    unavailable = "Tiskalnik ni na voljo.",
                    wrong_job = "Vaša služba nima dostopa do tega tiskalnika.",
                },
                settings = {
                    description = "Te nastavitve veljajo za vse tiskalnike, nastavljene za to službo.",
                    title = "Skupne nastavitve tiskalnikov službe",
                },
                statuses = {
                    maintenance = "Vzdrževanje",
                    offline = "Brez povezave",
                    online = "Povezan",
                },
                title = "Tiskalniki",
                values = {
                    disabled = "Onemogočeno",
                    enabled = "Omogočeno",
                    selectItem = "Izberi predmet",
                },
            },
            configs = {
                sky_dojjob = {
                    subtitle = "Nastavite DOJ poklicev, lokacije sodišča, in pravno kodo aplikacijo.",
                    title = "Poklic Ministrstva za pravosodje",
                },
            },
            creatorSections = {
                courthouses = {
                    entryLabel = "Sodišče",
                    entryPluralLabel = "Sodišča",
                    label = "Sodišča",
                },
            },
            extensions = {
                invalidSelection = "Neveljaven izbor: {value}",
                trainingSettings = {
                    description = "Nastavite dostop do usposabljanja, vpis, odobritve in načrtovanje tečaja za ta poklic.",
                    label = "Nastavitve usposabljanja",
                },
            },
            locations = {
                stationPosition = "Lokacija / zemljevid blip",
                stationPositionHint = "Glavna točka tega poklica lokacije. Če je zemljevid blip omogočen pod poklicem → Blips, se pojavi tukaj.",
                addCourtroom = "Dodajte dvorano",
                courtroom = "Sodišče",
                courtroom_display_desk_27 = "Prikaz dokazov v dvorišču – 27-inčni nadzornik mize",
                courtroom_display_wall_55 = "Prikaz dokazov v dvorišču – 55-inčni zid TV",
                courtroom_display_wall_75 = "Prikaz dokazov v dvorišču – 75-inčni zid TV",
                courtroom_display_wall_100 = "Prikaz dokazov v dvorišču – 100-inčni zid TV",
                courtroom_display_wall_120 = "Prikaz dokazov v dvorišču – 120-inčni zid TV",
                courtroom_display_wall_150 = "Prikaz dokazov v dvorišču – 150-inčni zid TV",
                courtroom_display_board_93 = "Interaktivni odbor v dvorani – 150-inčni mobilni stojnik",
                courtroom_display_projection = "Zaslon dokazov v dvorani – 4.5 m projekcijski zaslon",
                courtroom_judge_mic = "Sodniška dvorana – sodni mikrofon",
                courtroom_jury_room = "Sodni prostor – dvorana porote",
                courtroom_room = "dvorana – občinstvo / sobni center",
                courtroom_witness = "Sodni prostor – pričo",
                electionBooth = "Glasovanje Booth",
                publicDisplayDesk27 = "Javni prikaz – 27-inčni desk monitor",
                publicDisplayTerminal43 = "Javni prikaz – 43- inčni tla terminal",
                publicDisplayWall55 = "Javni prikaz – 55-Inčni zid TV",
                publicDisplayWall75 = "Javni prikaz – 75-Inčni zid TV",
                publicDisplayWall100 = "Javni prikaz – 100-Inčni zid TV",
                publicDisplayWall120 = "Javni prikaz – 120-Inčni zid TV",
                publicDisplayWall150 = "Javni prikaz – 150-Inčni zid TV",
                publicDisplayProjection = "Javni zaslon – 4.5 m Projektijski zaslon",
                publicLegalCode = "Javni pravni zakonik",
            },
            settingGroups = {
                dojWarrants = {
                    label = "Izdani sodni nalogi",
                },
                dojAccess = {
                    label = "Dostop",
                },
                dojCourthouseBlip = {
                    label = "Potisni karto",
                },
                dojLegalBooks = {
                    label = "Knjige",
                },
                dojLegalContentLimits = {
                    label = "Mejne vrednosti vsebnosti",
                },
                dojLegalItem = {
                    label = "Predmet v inventarju",
                },
                dojLegalRateLimits = {
                    label = "Mejne vrednosti",
                },
                dojLegalRevisions = {
                    label = "Revizije",
                },
                dojLegalTransfers = {
                    label = "Veliki dokumenti",
                },
                dojOffenceCalculation = {
                    label = "Kalkulator",
                },
                dojOffenceRateLimits = {
                    label = "Mejne vrednosti",
                },
                dojOffenceMiranda = {
                    label = "Navodila za katalog",
                },
                dojOffenceSource = {
                    label = "Izvirnik kataloga",
                },
                dojRecordsGradeBindings = {
                    description = "Vsako razpoložljivo DOJ razred natančno eno področje zapisov, nato objavite kartiranje.",
                    label = "Področja razredov in zapisov",
                },
                dojTaxPayment = {
                    label = "Plačilo",
                },
                dojTaxRates = {
                    label = "Stopnje",
                },
                dojTaxSchedule = {
                    label = "Urnik",
                },
            },
            registryCatalog = {
                names = {
                    notarial_contracts = "Notarske pogodbe",
                    powers_of_attorney = "Odvetniška pooblastila",
                    name_changes = "Spremembe imena",
                    company_registry = "Register družbe",
                    association_registry = "Register združenja",
                    licensing = "Licenciranje",
                    administrative_decisions = "Upravne odločitve",
                    administrative_objections = "Upravni ugovori",
                },
            },
            gavel = {
                enabled = "Omogočeno",
                cooldown = "Sprožilo ohlajanje (ms)",
                defaultPreset = "Privzet vzorec udarca",
                prop = "Prop za gobenje",
                model = "Ime vzorca",
                bone = "Ručna kost ID",
                offset = "Odmik (metri)",
                rotation = "Rotacija (stopnje)",
                presets = "Vzorci preboja",
                single = "Enkratni udarec",
                double = "Dvojni udarec",
                strikes = "Število udarcev",
                interval = "Interval preloma (ms)",
                impact = "Zamuda zvoka (ms)",
                audio = "Zvok",
                asset = "Zvočno sredstvo",
                volume = "Glasnost",
                animation = "Animacija",
                dict = "Slovar animacije",
                clip = "Ime animacije",
                duration = "Trajanje gibanja (ms)",
                flag = "Zastavice animacije",
                x = "X",
                y = "Y",
                z = "Z",
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "zaposlenim omogoča, da se vključijo v razpoložljive usposabljanja.",
                approvalRequired = "Obdrži samo-priključek, dokler jih ne odobri pooblaščeni inštruktor.",
                defaultCapacity = "Privzeto število sedežev, ki se uporabljajo pri oblikovanju novega usposabljanja.",
                enabled = "Tomu poklicu omogoča aplikacijo usposabljanja.",
                requireOnDuty = "Zahteva, da so zaposleni na delovnem mestu pred odpiranjem ali uporabo aplikacije za usposabljanje.",
                upcomingDays = "Število prihodnjih dni, prikazanih v urniku aplikacij za usposabljanje.",
            },
            trainingFields = {
                allowSelfEnrollment = "Dovoli samopriključitev",
                approvalRequired = "Zahtevati odobritev vpisa",
                defaultCapacity = "Privzeta zmogljivost",
                enabled = "Aktiviraj usposabljanje",
                requireOnDuty = "Zahteva dolžnost",
                upcomingDays = "Predhodno obdobje (dnevi)",
            },
        },
    },
}
