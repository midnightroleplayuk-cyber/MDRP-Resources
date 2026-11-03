JobConfigLocales["sky_dojjob:cz"] = {
    Nui = {
        tablet = { apps = { doj_finance = "Financování" ,
                doj_conditions = "Podmínky",
                doj_elections = "Volby",
                doj_files = "Průzkumník případů",
                doj_hearings = "Slyšení",
                doj_law = "Právní předpisy",
                doj_offences = "Jemný katalog",
                doj_shared_files = "Sdílené dokumenty",
            } },
        workshopConfig = {
            recordsAccessGuide = {
                title = "Nastavení přístupu ke spisům",
                description = "Vyberte, kdo má přístup k záznamům a v jaké oblasti pracuje. Hodnosti bez přiřazení nemají přístup.",
                status = {
                    unpublished = "Přiřazení ještě není zveřejněno",
                    conflict = "Vyřešte duplicitní přiřazení",
                    disabled = "Tablet DOJ je vypnutý",
                    incomplete = "Přiřaďte alespoň jednu hodnost",
                    ready = "Připraveno k uložení",
                },
                steps = {
                    tabletTitle = "Zapnout tablet DOJ",
                    tabletText = "Pro otevření aplikací se spisy musí být tablet zapnutý.",
                    gradesTitle = "Přiřadit hodnosti DOJ",
                    gradesText = "Každé hodnosti, která má získat přístup, vyberte právě jednu oblast záznamů.",
                    publishTitle = "Zveřejnit a uložit",
                    publishText = "Po každé změně přiřazení se automaticky připraví nová verze.",
                },
                grades = {
                    title = "Přiřazení hodností",
                    description = "Pro každou hodnost vyberte jednu oblast. Hodnostem, které mají zůstat bez přístupu, nastavte Bez přístupu.",
                    search = "Hledat hodnosti",
                    conflict = "Hodnost má více přiřazení. Vyberte jednu oblast nebo Bez přístupu a konflikt vyřešte.",
                    notFound = "V frameworku už neexistuje",
                    noResults = "Nenalezena žádná odpovídající hodnost.",
                    empty = "Pro nastavené zaměstnání DOJ nebyly nalezeny žádné hodnosti.",
                    emptyHint = "Nejprve vytvořte hodnosti DOJ ve frameworku a potom znovu otevřete konfigurátor.",
                    gradeColumn = "Hodnost",
                    domainColumn = "Oblast záznamů",
                    noAccess = "Bez přístupu",
                    chooseDomain = "Vyřešit přiřazení",
                    assigned = "přiřazených hodností",
                },
                publish = {
                    saveHint = "Kliknutím na Uložit nahoře použijete změny. Hráči potom mohou znovu ověřit svůj přístup.",
                },
            },
            registryFiles = { licenseType = "Typ licence", licenseLabel = "Název registru", marriages = "Kniha manželství" },
            features = {
                dojHandovers = {
                    label = "Předání",
                    description = "Povoluje předání, soudní rozhodnutí a zprávy o výkonu. Dokumenty a sdílení zůstávají dostupné.",
                },
                dojBodycamRequests = {
                    label = "Žádosti o záznamy z osobní kamery",
                    description = "Vyžádejte si policejní záznamy. Vyžaduje Předání; uložené záznamy zůstávají dostupné samostatně.",
                },
                dojFinance = { label = "Financování", description = "Zůstatky frakcí, převody státní pokladny a historie transakcí." },
                dojConditions = {
                    description = "Aktivovat strukturované podmínky, důkazy, termíny a následné porušení předpisů.",
                    label = "Podmínky",
                },
                dojCourtroom = {
                    description = "Aktivujte bezpečné sezení v soudní síni, prezentaci důkazů a interakce na rolích.",
                    label = "Živá soudní síň",
                },
                dojElections = {
                    description = "Aktivujte volební správu a zajistěte hlasování u registrovaných volebních stánků.",
                    label = "Volby",
                },
                dojHearings = {
                    description = "Aktivujte plánování soudní síně, check-in a autoritativní kontroly stavu slyšení.",
                    label = "Slyšení",
                },
                dojLegalCodes = {
                    description = "Aktivujte právní knihy, editaci bohatého textu a historii revize.",
                    label = "Právní předpisy",
                },
                dojOffences = {
                    description = "Aktivujte katalog kompaktních trestných činů a náhled kalkulačky.",
                    label = "Jemný katalog",
                },
                dojPrinters = {
                    description = "Aktivujte fyzické tiskárny a jejich runtime infrastrukturu.",
                    label = "Tiskárny",
                },
                dojPublicDisplays = {
                    description = "Aktivujte data filtrovaná v soukromí pro zobrazení v soudní budově.",
                    label = "Obrazy veřejné soudní síně",
                },
                dojTablet = {
                    description = "Aktivujte přístup k aplikacím DOJ tablet.",
                    label = "DOJ tableta",
                },
                dojTaxes = {
                    description = "Pravidelně sbírat vozidla a dům daně od online hráčů.",
                    label = "Daně z aktiv",
                },
            },
            settingSections = {
                finance = "Financování",
                courtroom = "Soud",
                registries = "Registr",
                courthouses = "Soudy",
                general = "Generál",
                legalCodes = "Právní předpisy",
                offences = "Jemný katalog",
                recordsAccess = "Přístup do souboru případů",
                tablet = "Tableta",
                taxes = "Daně",
            },
            settings = {
                dojRegistryLicenses = {
                    label = "Registry licencí",
                    description = "Vyberte licence, které smí DOJ vydávat. Každá položka má vlastní registr. Odstranění položky neodebere stávající licence.",
                },
                dojRegistryAccess = {
                    ["label"] = "Přístup k registrům v souborech",
                    ["description"] = "Upravte přístup k registrům z config/registry. Prázdný seznam používá výchozí nastavení souborů. Pole a funkce serveru/klienta upravujte v souborech Lua.",
                },
                dojTreasuryJob = { label = "Práce státní pokladny", description = "Práce, jejíž společný účet přijímá inkasa a hradí převody." },
                dojFinanceJobs = { label = "Viditelné frakce", description = "Klíče registrovaných prací v přehledu účtů. Pokladna je vždy zahrnuta." },
                dojFinanceLimit = { label = "Limit transakce", description = "Nejvyšší částka jednoho převodu nebo inkasa." },
                dojFinePaymentMode = { label = "Úhrada podmíněných pokut", description = "Přímá bankovní platba nebo externí faktura. Vystavení faktury nepotvrzuje platbu.", options = { bank = "Bankovní platba", billing = "Faktura" } },
                dojFineSociety = { label = "Příjemce pokut", description = "Práce, jejíž společný účet přijímá podmíněné pokuty." },
                dojCourtroomBoardMove = {
                    label = "Přesunout soudní síň",
                    description = "Výchozí klíč k uchopení nebo uvolnění mobilní desky (např. F). Hráči jej mohou přeřadit do vázání klíčů FiveM. Pohyb je dočasný a resetuje po restartu.",
                },
                dojCourtroomGavel = {
                    label = "Soudce kladko!",
                    description = "Model Gavel, ruční upevnění, animace, zvuk a úder. Změny platí i bez restartu.",
                },
                dojHearingParticipantRoles = {
                    label = "Úlohy účastníků",
                    description = "Výchozí role: obžalovaný, svědek, porotce, soudce. Přidat vlastní klíče od role (až 24 znaků, podtržení povoleny). Udržujte soudce. Vlastní role neudělují soudce nebo porota oprávnění.",
                },
                dojWarrantTemplateCodes = {
                    label = "Kódy vzoru záruky",
                    description = "Kódy šablon uvedené v položce PD Záruka po soudním podpisu a sdílení. Výchozí hodnoty: HB, DB, RB.",
                },
                dojRegistryCatalog = {
                    label = "DOJ registry",
                    description = "Aktivovat a jmenovat DOJ registry, pak nastavit profesí přístup a oprávnění. Stávající DOJ oprávnění rolí stále platí. Vlastní RP registry jsou spravovány v profesích Base.",
                },
                dojCourthouseBlipCategory = {
                    description = "Štítek kategorie používaný pro blipy map soudní budovy.",
                    label = "Kategorie skluzu",
                },
                dojCourthouseBlipColor = {
                    description = "Barva mapy používaná pro soudní budovy.",
                    label = "Barva skluzu",
                },
                dojCourthouseBlipScale = {
                    description = "Stupnice mapy používaná pro výpadky soudní budovy.",
                    label = "Stupnice pro skluz",
                },
                dojCourthouseBlipShortRange = {
                    description = "Ukaž, že soudní skluzavka je na krátké vzdálenosti.",
                    label = "Krátký dosah",
                },
                dojCourthouseBlipSprite = {
                    description = "Mapa sprite používané pro soudní budovy.",
                    label = "Ikona značky na mapě",
                },
                dojLegalBookItem = {
                    description = "Inventární položka pro fixní vydání právního kódu. První použití uloží obsah a datum; vyžaduje jednotlivé položky s metadaty.",
                    label = "Položka knihy právních kódů",
                },
                dojLegalCreateBookRateLimitMs = {
                    description = "Minimální milisekundy mezi žádostmi o vytvoření právní knihy.",
                    label = "Vytvořit ochlazování knihy",
                },
                dojLegalCreateRevisionRateLimitMs = {
                    description = "Minimální milisekundy mezi žádostmi o vytvoření revize.",
                    label = "Vytvořit ochlazování revize",
                },
                dojLegalDeleteBookRateLimitMs = {
                    description = "Minimální milisekundy mezi žádostmi o výmaz z právní knihy.",
                    label = "Smazat ochlazování knihy",
                },
                dojLegalDeleteRevisionRateLimitMs = {
                    description = "Minimální milisekundy mezi žádostmi o vymazání revize.",
                    label = "Odstranit ochlazování revize",
                },
                dojLegalGetBookRateLimitMs = {
                    description = "Minimální milisekundy mezi žádostmi o právní knihu.",
                    label = "Načíst knihu chlazení",
                },
                dojLegalGetBooksRateLimitMs = {
                    description = "Minimální milisekundy mezi žádostmi o seznam právních knih.",
                    label = "Načíst ochlazování knihovny",
                },
                dojLegalLargeRequestTimeoutMs = {
                    description = "Minimální timeout použitý pro velké žádosti o dokumenty.",
                    label = "Velký timeout požadavku v milisekundách",
                },
                dojLegalMaxAbbreviationLength = {
                    description = "Maximální počet znaků povolených ve zkratce právnické knihy.",
                    label = "Maximální délka zkratky",
                },
                dojLegalMaxBookTitleLength = {
                    description = "Maximální počet znaků povolených v názvu právnické knihy.",
                    label = "Maximální délka názvu knihy",
                },
                dojLegalMaxContentBytes = {
                    description = "Maximum serializované velikosti jedné kompletní revize právní knihy.",
                    label = "Maximální velikost obsahu v bajtech",
                },
                dojLegalMaxParagraphTitleLength = {
                    description = "Maximální délka názvu akceptována při dovozu dědictví strukturovaných odstavců.",
                    label = "Maximální délka názvu staršího odstavce",
                },
                dojLegalMaxParagraphsPerBook = {
                    description = "Maximální počet strukturovaných odstavců přijatých během současného dovozu.",
                    label = "Maximální původní odstavce na knihu",
                },
                dojLegalMaxRevisionSummaryLength = {
                    description = "Maximální počet znaků povolených v poznámce k revizi.",
                    label = "Maximální délka poznámky k revizi",
                },
                dojLegalMaxRichTextNodes = {
                    description = "Maximální počet editorových uzlů povolených v jedné revizi.",
                    label = "Maximální bohaté textové uzly",
                },
                dojLegalPayloadBytesPerSecond = {
                    description = "Limit šířky pásma per-playeru používaný k přenosu velkých právních dokumentů.",
                    label = "Přenosová rychlost v bytech za sekundu",
                },
                dojLegalReorderBooksRateLimitMs = {
                    description = "Minimálně milisekundy mezi žádostmi o přeobjednání právní knihy.",
                    label = "Přeobjednat knihy ochladit",
                },
                dojLegalUpdateBookRateLimitMs = {
                    description = "Minimální milisekundy mezi aktualizacemi metadat právní knihy.",
                    label = "Aktualizovat ochlazování knihy",
                },
                dojLegalVisibleRevisionHistory = {
                    description = "Maximální počet revizí načtených při otevření právní knihy.",
                    label = "Viditelná historie revizí",
                },
                dojOffenceCalculateRateLimitMs = {
                    description = "Minimální milisekundy mezi náhledy kalkulačky na straně serveru.",
                    label = "Ochlazování kalkulačky",
                },
                dojOffenceGetCatalogueRateLimitMs = {
                    description = "Minimální milisekundy mezi požadavky katalogu.",
                    label = "Ochlazování katalogu zatížení",
                },
                dojOffenceMaxSelection = {
                    description = "Maximální počet trestných činů zahrnutých v jednom náhledu kalkulačky.",
                    label = "Maximální výběr",
                },
                dojOffenceMutationRateLimitMs = {
                    description = "Minimální milisekundy mezi změnami v katalogu trestných činů.",
                    label = "Katalogové úpravy chlazení",
                },
                dojOffenceMirandaWarning = {
                    description = "Vlastní varování uvedené ve vybraném jazyce. Zanechte prázdné pro použití standardního textu.",
                    label = "Varování Mirandy.",
                },
                dojPrimaryColor = {
                    description = "Hlavní barva používaná profesní skupinou DOJ a tabletem.",
                    label = "Základní barva",
                },
                dojRecordsCourtAdministrationGradeKeys = {
                    description = "Tyhle známky fungují s soudní správou a rejstříkovými záznamy.",
                    label = "Soudní správa",
                },
                dojRecordsJudiciaryGradeKeys = {
                    description = "Tyto známky pracují s soudními záznamy a rozhodnutími.",
                    label = "Soudce",
                },
                dojRecordsMappingVersion = {
                    description = "Publikovaná revize mapování třídy-to-records-domain. Prázdná hodnota udržuje záznamový přístup zakázán.",
                    label = "Verze publikace",
                },
                dojRecordsProsecutionGradeKeys = {
                    description = "Tyhle známky fungují s trestními záznamy.",
                    label = "Obžaloba",
                },
                dojTabletRequireDuty = {
                    description = "Pouze zaměstnanci ve službě DOJ mohou otevřít aplikaci s právním kódem.",
                    label = "Vyžadovat povinnost",
                },
                dojTaxCurrency = {
                    description = "Sky Base currency used only when the payment method is direct.",
                    label = "Přímá měna",
                },
                dojTaxHouseAmount = {
                    description = "Částka účtována za každý dům vlastněný hráčem.",
                    label = "Daň za dům",
                },
                dojTaxInitialDelaySeconds = {
                    description = "Sekundy čekat před první kolekcí, kdy není uložen žádný předchozí daňový cyklus.",
                    label = "Počáteční zpoždění",
                },
                dojTaxIntervalMinutes = {
                    description = "Zápisy mezi cykly automatického výběru aktiv a daní.",
                    label = "Interval sběru",
                },
                dojTaxNotifyPlayer = {
                    description = "Informujte hráče po přímé sbírce, předložení návrhu zákona nebo nedostatečné finanční prostředky.",
                    label = "Upozorňovat hráče",
                },
                dojTaxPaymentMode = {
                    description = "Použijte přímo zvolený zůstatek banky/peníze nebo předložte jeden účet společnosti Sky Base na jednoho hráče daně a daňový cyklus.",
                    label = "Způsob platby",
                    options = {
                        bills = "Sky Base bills",
                        direct = "Bank / peněžní bilance",
                    },
                },
                dojTaxSocietyJob = {
                    description = "DOJ profese, jejíž konfigurovaný účet společnosti obdrží všechny vybrané daňové příjmy.",
                    label = "Příjemce povolání DOJ",
                },
                dojTaxVehicleAmount = {
                    description = "Částka účtována za každé vozidlo ve vlastnictví hráče.",
                    label = "Daň za vozidlo",
                },
            },
            printers = {
                groups = {
                    paper = "Papír",
                    ink = "Inkoust",
                    general = "Tiskárna",
                    printing = "Tisk a přístup",
                    placement = "Model a umístění",
                },
                actions = {
                    selectExisting = "Vybrat existující tiskárnu",
                    selectExistingHint = "Zamiř na tiskárnu. Enter: vybrat · Esc: zrušit",
                    add = "Přidat tiskárnu",
                    open = "Prohlédnout tiskárnu",
                    place = "Umístit tiskárnu",
                    setPosition = "Použít aktuální polohu",
                },
                classes = {
                    office = "Kancelářská",
                    professional = "Profesionální",
                    standard = "Standardní",
                },
                description = "Nastav tiskárny, spotřební materiál, fronty, přístup a umístění pro tuto práci.",
                fieldDescriptions = {
                    paperCapacity = "Maximální zásoba papíru pro každou tiskárnu tohoto zaměstnání.",
                    paperEnabled = "Po zapnutí začínají tiskárny tohoto zaměstnání prázdné a vyžadují společný doplňovací předmět.",
                    refillAmount = "Množství papíru přidané do tiskárny tohoto zaměstnání při použití společného doplňovacího předmětu.",
                    refillItem = "Interní název předmětu v inventáři, který se spotřebuje při doplnění tiskárny tohoto zaměstnání.",
                },
                fields = {
                    active = "Aktivní",
                    class = "Třída",
                    heading = "Směr",
                    id = "Stálé ID",
                    label = "Název",
                    maxQueue = "Kapacita fronty",
                    minimumGrade = "Minimální hodnost",
                    paperCapacity = "Kapacita papíru",
                    paperEnabled = "Vyžadovat doplňování papíru",
                    propModel = "Model objektu",
                    refillAmount = "Papír za doplňovací předmět",
                    refillItem = "Doplňovací předmět",
                    deleteCopiesAfterRestart = "Smazat kopie po restartu",
                    deleteCopiesAfterRestartHint = "Po restartu tiskové služby smazat nevyzvednuté výtisky.",
                    spawnProp = "Vytvořit objekt",
                    speed = "Rychlost tisku",
                    status = "Stav",
                    x = "X",
                    y = "Y",
                    z = "Z",
                },
                info = {
                    class = "Třída: {class}",
                    paper = "Papír: {paper} / {capacity}",
                    queue = "Fronta: {queue} / {maxQueue}",
                    status = "Stav: {status}",
                    title = "Tiskárna",
                },
                messages = {
                    grade_too_low = "Pro tuto tiskárnu máte příliš nízkou hodnost.",
                    invalid_amount = "Množství pro doplnění není platné.",
                    missingModel = "Před umístěním vyberte platný model tiskárny.",
                    missing_refill_item = "Nemáte nastavený doplňovací předmět.",
                    no_refill_printer = "V okolí není dostupná tiskárna se zapnutou spotřebou papíru.",
                    paper_capacity_exceeded = "Byla by překročena kapacita papíru.",
                    paper_disabled = "Spotřeba papíru je u této tiskárny vypnutá.",
                    paper_full = "Zásobník papíru této tiskárny je již plný.",
                    printer_inactive = "Tato tiskárna je deaktivovaná.",
                    printer_not_found = "Tiskárna již neexistuje.",
                    refill_cooldown = "Před dalším doplněním chvíli počkejte.",
                    refilled = "Přidáno {amount} listů. Zásoba: {paper} / {capacity}.",
                    too_far_away = "Přibližte se k tiskárně.",
                    unavailable = "Tiskárna není dostupná.",
                    wrong_job = "Vaše zaměstnání nemá k této tiskárně přístup.",
                },
                settings = {
                    description = "Tato nastavení platí pro všechny tiskárny nastavené pro toto zaměstnání.",
                    title = "Společná nastavení tiskáren zaměstnání",
                },
                statuses = {
                    maintenance = "Údržba",
                    offline = "Odpojena",
                    online = "Připojena",
                },
                title = "Tiskárny",
                values = {
                    disabled = "Vypnuto",
                    enabled = "Zapnuto",
                    selectItem = "Vybrat předmět",
                },
            },
            configs = {
                sky_dojjob = {
                    subtitle = "Nastavte DOJ profesí, umístění soudní budovy a aplikaci s právním kódem.",
                    title = "Profesí ministerstva spravedlnosti",
                },
            },
            creatorSections = {
                courthouses = {
                    entryLabel = "Soud",
                    entryPluralLabel = "Soudy",
                    label = "Soudy",
                },
            },
            extensions = {
                invalidSelection = "Neplatná volba: {value}",
                trainingSettings = {
                    description = "Nakonfigurujte přístup ke školení, registraci, schválení a plánování kurzu pro tuto úlohu.",
                    label = "Nastavení tréninku",
                },
            },
            locations = {
                stationPosition = "Lokalita / blip na mapě",
                stationPositionHint = "Hlavní bod této pracovní lokace. Pokud je blip na mapě povolen v Job → Blips, zobrazí se zde.",
                addCourtroom = "Přidat síň",
                courtroom = "Soud",
                courtroom_display_desk_27 = "Důkazy ze soudní síně ukazují 27-palcový monitor.",
                courtroom_display_wall_55 = "Důkazy ze soudní síně ukazují 55-palcovou zeď TV",
                courtroom_display_wall_75 = "Důkazy ze soudní síně ukazují 75-palcovou zeď TV",
                courtroom_display_wall_100 = "Důkazy ze soudní síně ukazují 100-palcovou zeď TV",
                courtroom_display_wall_120 = "Důkazy ze soudní síně ukazují 120-palcovou zeď TV",
                courtroom_display_wall_150 = "Důkazy ze soudní síně ukazují 150-palcovou zeď TV",
                courtroom_display_board_93 = "Síň interaktivní tabule 150-palcový mobilní stojan",
                courtroom_display_projection = "Důkazy ze soudní síně zobrazují promítací plátno 4.5 m",
                courtroom_judge_mic = "Síň rozhodčího mikrofonu",
                courtroom_jury_room = "Soudní síň, soudní síň",
                courtroom_room = "Courtroom - publikum / pokojové centrum",
                courtroom_witness = "Soudní síň - Svědectví",
                electionBooth = "Hlasování s Boothem",
                publicDisplayDesk27 = "Public Display 27-palcový monitor stolů",
                publicDisplayTerminal43 = "Veřejné displeje 43-palcový podlahový terminál",
                publicDisplayWall55 = "Public Display 55-palcová stěna TV",
                publicDisplayWall75 = "Public Display 75-palcová stěna TV",
                publicDisplayWall100 = "Public Display 100-palcová stěna TV",
                publicDisplayWall120 = "Public Display 120-palcová stěna TV",
                publicDisplayWall150 = "Public Display 150-palcová stěna TV",
                publicDisplayProjection = "Public Display 4.5 m Promítací plátno",
                publicLegalCode = "Veřejné právní předpisy",
            },
            settingGroups = {
                dojWarrants = {
                    label = "Soudní příkazy",
                },
                dojAccess = {
                    label = "Přístup",
                },
                dojCourthouseBlip = {
                    label = "Mapa blip",
                },
                dojLegalBooks = {
                    label = "Kniha",
                },
                dojLegalContentLimits = {
                    label = "Omezení obsahu",
                },
                dojLegalItem = {
                    label = "Předmět v inventáři",
                },
                dojLegalRateLimits = {
                    label = "Limity sazeb",
                },
                dojLegalRevisions = {
                    label = "Revize",
                },
                dojLegalTransfers = {
                    label = "Velké dokumenty",
                },
                dojOffenceCalculation = {
                    label = "Kalkulačka",
                },
                dojOffenceRateLimits = {
                    label = "Limity sazeb",
                },
                dojOffenceMiranda = {
                    label = "Katalogové pokyny",
                },
                dojOffenceSource = {
                    label = "Katalogový zdroj",
                },
                dojRecordsGradeBindings = {
                    description = "Přiřadit každý dostupný DOJ stupeň přesně do jednoho záznamu domény, pak zveřejnit mapování.",
                    label = "Stupně a domény záznamů",
                },
                dojTaxPayment = {
                    label = "Platba",
                },
                dojTaxRates = {
                    label = "Sazby",
                },
                dojTaxSchedule = {
                    label = "Rozvrh",
                },
            },
            registryCatalog = {
                names = {
                    notarial_contracts = "Notářské smlouvy",
                    powers_of_attorney = "Pravomoci advokáta",
                    name_changes = "Změny názvu",
                    company_registry = "Registr společností",
                    association_registry = "Registr sdružení",
                    licensing = "Licence",
                    administrative_decisions = "Správní rozhodnutí",
                    administrative_objections = "Správní námitky",
                },
            },
            gavel = {
                enabled = "Povoleno",
                cooldown = "Spouštěcí chlazení (ms)",
                defaultPreset = "Výchozí vzorec úderu",
                prop = "Gavelová rekvizita",
                model = "Název modelu",
                bone = "Ruční kost ID",
                offset = "Offset (metry)",
                rotation = "Rotace (stupně)",
                presets = "Vzory úderu",
                single = "Jediný úder",
                double = "Dvojitý úder.",
                strikes = "Počet stávk",
                interval = "Interval úderu (ms)",
                impact = "Zvukové zpoždění (ms)",
                audio = "Zvuk",
                asset = "Zvukové aktivum",
                volume = "Objem",
                animation = "Animace",
                dict = "Animační slovník",
                clip = "Název animace",
                duration = "Doba trvání pohybu (ms)",
                flag = "Vlajky animace",
                x = "X",
                y = "Y",
                z = "Z",
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "Umožňuje zaměstnancům přihlásit se na dostupná školení.",
                approvalRequired = "Ponechává nevyřízené vlastní registrace, dokud je neschválí autorizovaný instruktor.",
                defaultCapacity = "Výchozí počet sedadel použitých při vytvoření nového tréninku.",
                enabled = "Zpřístupní aplikaci Training pro tuto úlohu.",
                requireOnDuty = "Vyžaduje, aby zaměstnanci měli službu před otevřením nebo použitím aplikace Training.",
                upcomingDays = "Počet budoucích dnů zobrazených v plánu aplikace Training.",
            },
            trainingFields = {
                allowSelfEnrollment = "Povolit samoregistraci",
                approvalRequired = "Vyžadovat schválení registrace",
                defaultCapacity = "Výchozí kapacita",
                enabled = "Povolit školení",
                requireOnDuty = "Vyžadovat povinnost",
                upcomingDays = "Nadcházející období (dny)",
            },
        },
    },
}
