JobConfigLocales["sky_dojjob:se"] = {
    Nui = {
        tablet = { apps = { doj_finance = "Ekonomi" ,
                doj_conditions = "Tillstånd",
                doj_elections = "Val",
                doj_files = "Fallfilutforskare",
                doj_hearings = "Förhör",
                doj_law = "Rättsregler",
                doj_offences = "Fin katalog",
                doj_shared_files = "Delade dokument",
            } },
        workshopConfig = {
            recordsAccessGuide = {
                title = "Ställ in åtkomst till ärendeakter",
                description = "Välj vilka som får åtkomst till register och inom vilket område de arbetar. Grader utan tilldelning har ingen åtkomst.",
                status = {
                    unpublished = "Tilldelningen är inte publicerad ännu",
                    conflict = "Lös dubbla tilldelningar",
                    disabled = "DOJ-surfplattan är inaktiverad",
                    incomplete = "Tilldela minst en grad",
                    ready = "Redo att spara",
                },
                steps = {
                    tabletTitle = "Aktivera DOJ-surfplattan",
                    tabletText = "Surfplattan måste vara aktiverad för att öppna apparna för ärendeakter.",
                    gradesTitle = "Tilldela DOJ-grader",
                    gradesText = "Välj exakt ett registerområde för varje grad som ska få åtkomst.",
                    publishTitle = "Publicera och spara",
                    publishText = "En ny tilldelningsversion förbereds automatiskt efter varje ändring av tilldelningarna.",
                },
                grades = {
                    title = "Gradtilldelningar",
                    description = "Välj ett område per grad. Välj Ingen åtkomst för grader som ska förbli spärrade.",
                    search = "Sök grader",
                    conflict = "En grad har flera tilldelningar. Välj ett område eller Ingen åtkomst för att lösa konflikten.",
                    notFound = "Finns inte längre i ramverket",
                    noResults = "Ingen matchande grad hittades.",
                    empty = "Inga grader hittades för det konfigurerade DOJ-jobbet.",
                    emptyHint = "Skapa först DOJ-graderna i ramverket och öppna sedan konfiguratorn igen.",
                    gradeColumn = "Grad",
                    domainColumn = "Registerområde",
                    noAccess = "Ingen åtkomst",
                    chooseDomain = "Lös tilldelningen",
                    assigned = "grader tilldelade",
                },
                publish = {
                    saveHint = "Klicka på Spara högst upp för att tillämpa ändringarna. Spelarna kan sedan kontrollera sin åtkomst igen.",
                },
            },
            registryFiles = { licenseType = "Licenstyp", licenseLabel = "Registernamn", marriages = "Äktenskapsregister" },
            features = {
                dojHandovers = {
                    label = "Överlämningar",
                    description = "Aktiverar överlämningar, domstolsbeslut och verkställighetsrapporter. Dokument och delning är fortsatt tillgängliga.",
                },
                dojBodycamRequests = {
                    label = "Begäran om kroppskamerainspelningar",
                    description = "Begär polisens inspelningar. Kräver Överlämningar; sparade inspelningar förblir tillgängliga separat.",
                },
                dojFinance = { label = "Ekonomi", description = "Fraktionssaldon, statliga överföringar och transaktionshistorik." },
                dojConditions = {
                    description = "Aktivera strukturerade villkor, bevis, deadlines och överträdelseuppföljning.",
                    label = "Tillstånd",
                },
                dojCourtroom = {
                    description = "Aktivera säkra levande rättssalssessioner, bevispresentation och rollbaserade rumsinteraktioner.",
                    label = "Levande rättssal",
                },
                dojElections = {
                    description = "Aktivera valadministrationen och säkra röstningen i registrerade röstbås.",
                    label = "Val",
                },
                dojHearings = {
                    description = "Aktivera rättssalens schemaläggning, incheckning och auktoritativa kontroll av hörselstatus.",
                    label = "Förhör",
                },
                dojLegalCodes = {
                    description = "Aktivera juridiska böcker, textredigering och versionshistorik.",
                    label = "Rättslig kod",
                },
                dojOffences = {
                    description = "Aktivera den kompakta brottskatalogen och miniräknaren förhandsgranskning.",
                    label = "Fin katalog",
                },
                dojPrinters = {
                    description = "Aktivera fysiska skrivare och deras runtime infrastruktur.",
                    label = "Skrivare",
                },
                dojPublicDisplays = {
                    description = "Aktivera sekretessfiltrerad live-data för visning i tingshuset.",
                    label = "Allmänna uppvisningar i rättssalen",
                },
                dojTablet = {
                    description = "Aktivera åtkomst till DOJ tablet-appar.",
                    label = "DOJ Oral användning",
                },
                dojTaxes = {
                    description = "Regelbundet samla in fordons- och husskatt från online-spelare.",
                    label = "Tillgångsskatter",
                },
            },
            settingSections = {
                finance = "Ekonomi",
                courtroom = "Förhörsrum",
                registries = "Register",
                courthouses = "Domstolar",
                general = "Allmän",
                legalCodes = "Rättslig kod",
                offences = "Fin katalog",
                recordsAccess = "Tillgång till ärendeakt",
                tablet = "Surfplatta",
                taxes = "Skatter",
            },
            settings = {
                dojRegistryLicenses = {
                    label = "Licensregister",
                    description = "Välj vilka licenser DOJ får utfärda. Varje post får ett eget register. Befintliga licenser behålls när en post tas bort.",
                },
                dojRegistryAccess = {
                    ["label"] = "Åtkomst till registerfiler",
                    ["description"] = "Anpassa åtkomst till register i config/registry. En tom lista använder filernas standardvärden. Fält och server-/klientfunktioner redigeras i Lua-filerna.",
                },
                dojTreasuryJob = { label = "Statskassans jobb", description = "Jobbet vars gemensamma konto tar emot indrivningar och betalar överföringar." },
                dojFinanceJobs = { label = "Synliga fraktioner", description = "Nycklar för registrerade jobb i kontoöversikten. Statskassan ingår alltid." },
                dojFinanceLimit = { label = "Transaktionsgräns", description = "Högsta belopp per överföring eller indrivning." },
                dojFinePaymentMode = { label = "Betalning av ålagda böter", description = "Direkt bankbetalning eller extern faktura. Att skapa en faktura bekräftar inte betalning.", options = { bank = "Bankbetalning", billing = "Faktura" } },
                dojFineSociety = { label = "Mottagare av böter", description = "Jobbet vars gemensamma konto tar emot ålagda böter." },
                dojCourtroomBoardMove = {
                    label = "Flytta rättssalens styrelse",
                    description = "Förvald nyckel för att ta eller släppa ett mobilkort (t.ex. F). Spelare kan överskrida den i fem M-tangentbindningar. Rörelsen är tillfällig och återställs efter omstart.",
                },
                dojCourtroomGavel = {
                    label = "Domare gavel",
                    description = "Gavelmodell, handfäste, animering, ljud- och strejkmönster. Ändringar gäller även utan omstart.",
                },
                dojHearingParticipantRoles = {
                    label = "Deltagares roller",
                    description = "Standardroller: svarande, vittne, jurymedlem, domare. Lägg till egna små bokstäver (upp till 24 tecken, understrykningar tillåtna). Håll domare. Anpassade roller ger inte domare eller jurybehörigheter.",
                },
                dojWarrantTemplateCodes = {
                    label = "Mall för teckningsoptioner",
                    description = "Mallkoder som visas under PD Teckningsoptioner efter juridisk underskrift och delning. Standarder: HB, DB, RB.",
                },
                dojRegistryCatalog = {
                    label = "DOJ register",
                    description = "Aktivera och namn DOJ register, sedan ställa yrket tillgång och klarering. Befintliga DOJ roll behörigheter fortfarande gäller. Anpassade RP register hanteras i yrken Bas.",
                },
                dojCourthouseBlipCategory = {
                    description = "Kategorietikett som används för kartlappar i tingshuset.",
                    label = "Blipkategori",
                },
                dojCourthouseBlipColor = {
                    description = "Kartfärg som används för tingshus.",
                    label = "Blixtfärg",
                },
                dojCourthouseBlipScale = {
                    description = "Kartskala som används för tingshusblixtar.",
                    label = "Halkskala",
                },
                dojCourthouseBlipShortRange = {
                    description = "Visa bara domedagsblips på kort avstånd.",
                    label = "Kort räckvidd",
                },
                dojCourthouseBlipSprite = {
                    description = "Karta sprite används för tingshus.",
                    label = "Blip sprite Ordförande",
                },
                dojLegalBookItem = {
                    description = "Inventeringsobjekt för en fast lagkodsutgåva. Första användningen sparar dess innehåll och datum; kräver enskilda objekt med metadata.",
                    label = "Poster med rättslig kod",
                },
                dojLegalCreateBookRateLimitMs = {
                    description = "Minsta millisekunder mellan laglig bok skapande förfrågningar.",
                    label = "Skapa boknedkylning",
                },
                dojLegalCreateRevisionRateLimitMs = {
                    description = "Minsta millisekunder mellan begäran om översyn av skapande.",
                    label = "Skapa nedkylning av revidering",
                },
                dojLegalDeleteBookRateLimitMs = {
                    description = "Minsta millisekunder mellan begäran om radering av juridiska böcker.",
                    label = "Ta bort boknedkylning",
                },
                dojLegalDeleteRevisionRateLimitMs = {
                    description = "Minsta millisekunder mellan begäran om radering av revidering.",
                    label = "Ta bort revideringsnedkylning",
                },
                dojLegalGetBookRateLimitMs = {
                    description = "Minsta millisekunder mellan förfrågningar om en juridisk bok.",
                    label = "Ladda boknedkylning",
                },
                dojLegalGetBooksRateLimitMs = {
                    description = "Minsta millisekunder mellan förfrågningar om den lagliga boklistan.",
                    label = "Ladda ner bibliotekets nedkylning",
                },
                dojLegalLargeRequestTimeoutMs = {
                    description = "Minimum timeout används för stora dokumentförfrågningar.",
                    label = "Stor begäran timeout i millisekunder",
                },
                dojLegalMaxAbbreviationLength = {
                    description = "Maximalt antal tecken som tillåts i en förkortning av juridiska böcker.",
                    label = "Maximal förkortningslängd",
                },
                dojLegalMaxBookTitleLength = {
                    description = "Maximalt antal tecken tillåtna i en lagbokstitel.",
                    label = "Maximal boktitellängd",
                },
                dojLegalMaxContentBytes = {
                    description = "Maximal seriestorlek av en fullständig juridisk-bok revidering.",
                    label = "Högsta halt i byte",
                },
                dojLegalMaxParagraphTitleLength = {
                    description = "Maximal titellängd godtas vid import av äldre strukturerade stycken.",
                    label = "Maximal längd på den tidigare punktens titel",
                },
                dojLegalMaxParagraphsPerBook = {
                    description = "Maximalt antal strukturerade punkter som godtagits under tidigare import.",
                    label = "Maximalt antal äldre stycken per bok",
                },
                dojLegalMaxRevisionSummaryLength = {
                    description = "Maximalt antal tecken som tillåts i en revisionsanteckning.",
                    label = "Maximal längd på revisionsnoten",
                },
                dojLegalMaxRichTextNodes = {
                    description = "Maximalt antal editornoder tillåts i en revision.",
                    label = "Maximala rich-text noder",
                },
                dojLegalPayloadBytesPerSecond = {
                    description = "bandbreddsgräns per spelare som används för att överföra stora juridiska dokument.",
                    label = "Överföringshastighet i byte per sekund",
                },
                dojLegalReorderBooksRateLimitMs = {
                    description = "Minimum millisekunder mellan lagboksbeställningar.",
                    label = "Ordna om böcker nedkylning",
                },
                dojLegalUpdateBookRateLimitMs = {
                    description = "Minsta millisekunder mellan juridiska-bok metadata uppdateringar.",
                    label = "Uppdatera boknedkylning",
                },
                dojLegalVisibleRevisionHistory = {
                    description = "Maximalt antal revideringar som laddats vid öppnandet av en juridisk bok.",
                    label = "Synlig revideringshistorik",
                },
                dojOffenceCalculateRateLimitMs = {
                    description = "Minsta millisekunder mellan förhandsgranskningar av serversidans miniräknare.",
                    label = "Kylning av räknemaskinen",
                },
                dojOffenceGetCatalogueRateLimitMs = {
                    description = "Minsta millisekunder mellan katalogförfrågningar.",
                    label = "Ladda katalognedkylning",
                },
                dojOffenceMaxSelection = {
                    description = "Maximalt antal brott som ingår i en miniräknares förhandsvisning.",
                    label = "Maximalt urval",
                },
                dojOffenceMutationRateLimitMs = {
                    description = "Minsta millisekunder mellan ändringar i brottskatalogen.",
                    label = "Nedkylning av katalogredigering",
                },
                dojOffenceMirandaWarning = {
                    description = "Egen varning visas i den fina katalogen. Lämna tom för att använda standardtexten på det valda språket.",
                    label = "Miranda varning",
                },
                dojPrimaryColor = {
                    description = "Huvudfärg som används av DOJ yrkesgrupp och tablett.",
                    label = "Grundfärg",
                },
                dojRecordsCourtAdministrationGradeKeys = {
                    description = "Dessa betyg arbetar med domstolsadministration och registerregister.",
                    label = "Domstolsförvaltning",
                },
                dojRecordsJudiciaryGradeKeys = {
                    description = "Dessa betyg arbetar med rättsliga handlingar och beslut.",
                    label = "Domstols behörighet",
                },
                dojRecordsMappingVersion = {
                    description = "Publicerad revidering av kartläggningen av kategori-till-rekord-domänen. Ett tomt värde håller register åtkomliga.",
                    label = "Offentliggörande",
                },
                dojRecordsProsecutionGradeKeys = {
                    description = "De här betygen jobbar med åtalsregistret.",
                    label = "Rättegång",
                },
                dojTabletRequireDuty = {
                    description = "Endast i tjänst DOJ anställda får öppna den juridiska kodappen.",
                    label = "Krav på plikt",
                },
                dojTaxCurrency = {
                    description = "Sky Base currency used only when the payment method is direct.",
                    label = "Direktvaluta",
                },
                dojTaxHouseAmount = {
                    description = "Belopp som debiteras för varje hus som ägs av en spelare.",
                    label = "Skatt per hus",
                },
                dojTaxInitialDelaySeconds = {
                    description = "Sekunder att vänta före den första insamlingen när ingen tidigare skattecykel lagras.",
                    label = "Ursprunglig försening",
                },
                dojTaxIntervalMinutes = {
                    description = "Minuter mellan automatisk insamling av tillgångar och skatter.",
                    label = "Insamlingsintervall",
                },
                dojTaxNotifyPlayer = {
                    description = "Meddela spelare efter en direkt insamling, en faktura inlämning, eller otillräckliga medel.",
                    label = "Meddela spelare",
                },
                dojTaxPaymentMode = {
                    description = "Använd den valda banken/pengarna direkt eller skicka in en Sky Base Society-räkning per beskattningsbar spelare och skattecykel.",
                    label = "Betalningsmetod",
                    options = {
                        bills = "Sky Base bills",
                        direct = "Bank/valutabalans",
                    },
                },
                dojTaxSocietyJob = {
                    description = "DOJ yrke vars konfigurerade samhällskonto får alla inbetalda skatteintäkter.",
                    label = "Mottagare DOJ yrke",
                },
                dojTaxVehicleAmount = {
                    description = "Belopp som debiteras för varje fordon som ägs av en spelare.",
                    label = "Skatter per fordon",
                },
            },
            printers = {
                groups = {
                    paper = "Papper",
                    ink = "Bläck",
                    general = "Skrivare",
                    printing = "Utskrift och åtkomst",
                    placement = "Modell och placering",
                },
                actions = {
                    selectExisting = "Välj befintlig skrivare",
                    selectExistingHint = "Sikta på skrivaren. Enter: välj · Esc: avbryt",
                    add = "Lägg till skrivare",
                    open = "Inspektera skrivare",
                    place = "Placera skrivare",
                    setPosition = "Använd aktuell plats",
                },
                classes = {
                    office = "Kontor",
                    professional = "Professionell",
                    standard = "Standardvärde",
                },
                description = "Konfigurera skrivare, förbrukningsmaterial, köer, åtkomst och placering för detta jobb.",
                fieldDescriptions = {
                    paperCapacity = "Maximalt papperslager för varje skrivare i det här jobbet.",
                    paperEnabled = "När detta är aktiverat börjar jobbets skrivare tomma och kräver det gemensamma påfyllningsföremålet.",
                    refillAmount = "Mängden papper som läggs till i en skrivare i det här jobbet när det gemensamma påfyllningsföremålet används.",
                    refillItem = "Internt namn på inventarieföremålet som förbrukas när en skrivare i det här jobbet fylls på.",
                },
                fields = {
                    active = "Aktiv",
                    class = "Klass",
                    heading = "Riktning",
                    id = "Beständigt ID",
                    label = "Namn",
                    maxQueue = "Kökapacitet",
                    minimumGrade = "Lägsta rang",
                    paperCapacity = "Papperskapacitet",
                    paperEnabled = "Kräv papperspåfyllning",
                    propModel = "Objektmodell",
                    refillAmount = "Papper per påfyllningsföremål",
                    refillItem = "Påfyllningsföremål",
                    deleteCopiesAfterRestart = "Radera kopior vid omstart",
                    deleteCopiesAfterRestartHint = "Radera utskrifter som inte hämtats när utskriftstjänsten startas om.",
                    spawnProp = "Skapa objekt",
                    speed = "Utskriftshastighet",
                    status = "Status",
                    x = "X",
                    y = "Y",
                    z = "Z",
                },
                info = {
                    class = "Klass: {class}",
                    paper = "Papper: {paper} / {capacity}",
                    queue = "Kö: {queue} / {maxQueue}",
                    status = "Status: {status}",
                    title = "Skrivare",
                },
                messages = {
                    grade_too_low = "Din rang är för låg för den här skrivaren.",
                    invalid_amount = "Påfyllningsmängden är ogiltig.",
                    missingModel = "Välj en giltig skrivarmodell innan du placerar den.",
                    missing_refill_item = "Du saknar det inställda påfyllningsföremålet.",
                    no_refill_printer = "Ingen tillgänglig skrivare med pappersförbrukning finns i närheten.",
                    paper_capacity_exceeded = "Papperskapaciteten skulle överskridas.",
                    paper_disabled = "Pappersförbrukning är avstängd för den här skrivaren.",
                    paper_full = "Den här skrivarens pappersfack är redan fullt.",
                    printer_inactive = "Den här skrivaren är inaktiverad.",
                    printer_not_found = "Skrivaren finns inte längre.",
                    refill_cooldown = "Vänta en stund innan du fyller på igen.",
                    refilled = "{amount} ark har lagts till. Lager: {paper} / {capacity}.",
                    too_far_away = "Gå närmare skrivaren.",
                    unavailable = "Skrivaren är inte tillgänglig.",
                    wrong_job = "Ditt jobb har inte åtkomst till den här skrivaren.",
                },
                settings = {
                    description = "De här inställningarna gäller alla skrivare som har konfigurerats för det här jobbet.",
                    title = "Gemensamma skrivarinställningar för jobbet",
                },
                statuses = {
                    maintenance = "Underhåll",
                    offline = "Frånkopplad",
                    online = "Ansluten",
                },
                title = "Skrivare",
                values = {
                    disabled = "Inaktiverad",
                    enabled = "Aktiverad",
                    selectItem = "Välj föremål",
                },
            },
            configs = {
                sky_dojjob = {
                    subtitle = "Konfigurera DOJ yrken, domstolslokaler och den juridiska kodappen.",
                    title = "Avdelningen för rättsliga yrken",
                },
            },
            creatorSections = {
                courthouses = {
                    entryLabel = "Domstolsbyggnaden",
                    entryPluralLabel = "Domstolar",
                    label = "Domstolar",
                },
            },
            extensions = {
                invalidSelection = "Ogiltigt val: {value}",
                trainingSettings = {
                    description = "Konfigurera utbildningsåtkomst, inskrivning, godkännanden och kursplanering för detta jobb.",
                    label = "Träningsinställningar",
                },
            },
            locations = {
                stationPosition = "Plats / kartmarkör",
                stationPositionHint = "Huvudpunkt för denna jobbplats. Om kartmarkören är aktiverad under Jobb → Blips, visas den här.",
                addCourtroom = "Lägg till sammanträdesrum",
                courtroom = "Förhörsrum",
                courtroom_display_desk_27 = "Bevisvisning – 27-tums skrivbordsmonitor",
                courtroom_display_wall_55 = "Rättssalens bevisvisning – 55-tums vägg TV",
                courtroom_display_wall_75 = "Rättssalens bevisvisning – 75-tums vägg TV",
                courtroom_display_wall_100 = "Rättssalens bevisvisning – 100-tums vägg TV",
                courtroom_display_wall_120 = "Rättssalens bevisvisning – 120-tums vägg TV",
                courtroom_display_wall_150 = "Rättssalens bevisvisning – 150-tums vägg TV",
                courtroom_display_board_93 = "Interaktivt bräde – 150-tums mobilstativ",
                courtroom_display_projection = "Bevisvisning – 4.5 m projektionsskärm",
                courtroom_judge_mic = "Domstolssal – domare mikrofon",
                courtroom_jury_room = "Domstolsrum – juryrum",
                courtroom_room = "Courtroom – publik/rumscenter",
                courtroom_witness = "Courtroom – vittnesstånd",
                electionBooth = "Röstning Booth",
                publicDisplayDesk27 = "Public Display – 27-tums skrivbordsskärm",
                publicDisplayTerminal43 = "Public Display – 43-tums golvterminal",
                publicDisplayWall55 = "Public Display – 55-tums vägg TV",
                publicDisplayWall75 = "Public Display – 75-tums vägg TV",
                publicDisplayWall100 = "Public Display – 100-tums vägg TV",
                publicDisplayWall120 = "Public Display – 120-tums vägg TV",
                publicDisplayWall150 = "Public Display – 150-tums vägg TV",
                publicDisplayProjection = "Public Display – 4.5 m Projektionsskärm",
                publicLegalCode = "Offentlig lag",
            },
            settingGroups = {
                dojWarrants = {
                    label = "Domstolens utfärdade teckningsoptioner",
                },
                dojAccess = {
                    label = "Åtkomst",
                },
                dojCourthouseBlip = {
                    label = "Kartklipp",
                },
                dojLegalBooks = {
                    label = "Böcker",
                },
                dojLegalContentLimits = {
                    label = "Innehållsgränser",
                },
                dojLegalItem = {
                    label = "Inventarieartikel",
                },
                dojLegalRateLimits = {
                    label = "Räntegränser",
                },
                dojLegalRevisions = {
                    label = "Översyn",
                },
                dojLegalTransfers = {
                    label = "Stora dokument",
                },
                dojOffenceCalculation = {
                    label = "Miniräknare",
                },
                dojOffenceRateLimits = {
                    label = "Räntegränser",
                },
                dojOffenceMiranda = {
                    label = "Katalogvägledning",
                },
                dojOffenceSource = {
                    label = "Katalogkälla",
                },
                dojRecordsGradeBindings = {
                    description = "Tilldela varje tillgänglig DOJ grad till exakt en post domän, sedan publicera kartläggningen.",
                    label = "Betyg och poster domäner",
                },
                dojTaxPayment = {
                    label = "Betalning",
                },
                dojTaxRates = {
                    label = "Procentsatser",
                },
                dojTaxSchedule = {
                    label = "Schema",
                },
            },
            registryCatalog = {
                names = {
                    notarial_contracts = "Notarieavtal",
                    powers_of_attorney = "Fullmakter",
                    name_changes = "Namnändringar",
                    company_registry = "Företagsregistret",
                    association_registry = "Föreningsregistret",
                    licensing = "Tillstånd",
                    administrative_decisions = "Administrativa beslut",
                    administrative_objections = "Administrativa invändningar",
                },
            },
            gavel = {
                enabled = "Aktiverad",
                cooldown = "Utlösande avkylning (ms)",
                defaultPreset = "Förvalt strejkmönster",
                prop = "Gavelprop",
                model = "Modellnamn",
                bone = "Handben ID",
                offset = "Förskjutning (meter)",
                rotation = "Rotation (grader)",
                presets = "Strejkmönster",
                single = "Engångsstrejk",
                double = "Dubbelslagning",
                strikes = "Antal strejker",
                interval = "Strejkintervall (ms)",
                impact = "Ljudfördröjning (ms)",
                audio = "Ljud",
                asset = "Ljudtillgång",
                volume = "Volym",
                animation = "Animering",
                dict = "Animation ordbok",
                clip = "Animationens namn",
                duration = "Rörelsens varaktighet (ms)",
                flag = "Animeringsflaggor",
                x = "X",
                y = "Y",
                z = "Z",
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "Tillåter anställda att anmäla sig till tillgängliga träningspass.",
                approvalRequired = "Håller självregistreringar i väntan tills en auktoriserad instruktör godkänner dem.",
                defaultCapacity = "Standard antal platser som används när en ny träningspass skapas.",
                enabled = "Gör träningsappen tillgänglig för detta jobb.",
                requireOnDuty = "Kräver att anställda är i tjänst innan de öppnar eller använder Training App.",
                upcomingDays = "Antal framtida dagar som visas i utbildningsprogrammets schema.",
            },
            trainingFields = {
                allowSelfEnrollment = "Tillåt självregistrering",
                approvalRequired = "Kräver inskrivningsgodkännande",
                defaultCapacity = "Standardkapacitet",
                enabled = "Möjlig utbildning",
                requireOnDuty = "Krav på plikt",
                upcomingDays = "Kommande period (dagar)",
            },
        },
    },
}
