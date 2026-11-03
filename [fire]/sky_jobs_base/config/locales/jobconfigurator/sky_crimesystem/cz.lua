JobConfigLocales["sky_crimesystem:cz"] = {
    Nui = {
        workshopConfig = {
            creatorCommand = "Přímý příkaz",
            roleDefaults = {
                title = "Role",
                description = "Zvolte minimální hodnost pro každé výchozí oprávnění. Přednost mají oprávnění hodností uložená v nabídce vedení.",
                bossHint = "Hodnosti šéfa a zástupce mají vždy plný přístup.",
                empty = "Pro tuto práci zatím nejsou dostupné žádné hodnosti.",
                gradesTitle = "Pracovní hodnosti",
                noDefault = "Bez výchozího oprávnění",
                rankOption = "{grade} – {label}",
            },
            weaponDefaultsDescription = "Společné hodnoty platí pro přebíraná pole. Změna na stránce nastavení přepne pole na vlastní hodnotu. Stávající záznamy si ponechají své hodnoty.",
            weaponStreetDescription = "Při pouličním kontaktu pro prodej drog může server občas koupit vhodnou zbraň. Výběr, cenu i výplatu určuje server.",
            weaponGroups = {
                general = "Obecné výchozí hodnoty",
                access = "Výchozí přístup",
                collection = "Výchozí sběr",
                production = "Výchozí výroba",
                market = "Výchozí trh",
                delivery = "Výchozí zakázky",
                street = "Pouliční prodej zbraní",
            },
            weaponOptions = {
                scrap_search = "Prohledat hromadu šrotu",
                player = "Na hráče",
                global = "Globální",
                money = "Hotovost",
                bank = "Bankovní účet",
                black_money = "Černé peníze",
                timing = "Zastavte ukazatel v optimálním rozsahu.",
                precision = "Provádějte každý řez v rámci přesnostního okna.",
                pressure = "Zastavte lis při jeho optimálním tlaku.",
            },

            reputation = {
                remove = "Smazat",
                title = "Reputace",
                action = "Akce",
                points = "Body za dokončení",
                enabled = "Aktivní",
                search = "Hledat akce",
                added = "Již přidáno",
                noResults = "Nenalezeny žádné odpovídající akce.",
                empty = "Zatím žádné akce. Přidejte akci tlačítkem plus.",
                name = "Název pravidla",
                target = "Cíl (volitelný)",
            },
            configs = {
                sky_crimesystem = {
                    entries = "Frakce",
                    subtitle = "Konfigurujte kriminální práce a jejich společné lokality.",
                    title = "Systém trestné činnosti",
                },
            },
            creatorSections = {
                mainbaseZones = {
                    entryLabel = "Hlavní základna",
                    entryPluralLabel = "Hlavní základny",
                    label = "Zóna hlavní základny",
                },
                presetTerritories = {
                    label = "Přednastavené obvody",
                    entryLabel = "Přednastavený obvod",
                    entryPluralLabel = "Přednastavené obvody",
                },
                customTerritories = {
                    label = "Vlastní území",
                    entryLabel = "Vlastní území",
                    entryPluralLabel = "Vlastní území",
                },
                objectsSection = {
                    label = "Objekty výslechu",
                    entryLabel = "Objekt",
                    entryPluralLabel = "Objekty výslechu",
                },
                blockedZonesSection = {
                    label = "Blokované zóny",
                    entryLabel = "Zóna",
                    entryPluralLabel = "Blokované zóny",
                },
                toolsSection = {
                    label = "Nářadí",
                    entryLabel = "Nástroj",
                    entryPluralLabel = "Nářadí",
                },
                sessionsSection = {
                    label = "Probíhající výslechy",
                    entryLabel = "Výslech",
                    entryPluralLabel = "Probíhající výslechy",
                },
                orphansSection = {
                    label = "Osamocené objekty",
                    entryLabel = "Objekt",
                    entryPluralLabel = "Osamocené objekty",
                },
            },
            darknetActions = {
                currentLocation = "Použít aktuální polohu",
            },
            drugSettings = {
                drugGrowthCurve = {
                    description = "Vyšší hodnoty výrazně zpomalí růst při špatné péči, ale zachovají silné bonusy při dobré péči.",
                    label = "Křivka reakce na péči",
                },
                drugGrowthMaxMultiplier = {
                    description = "Maximální násobitel růstu dosažen za vynikajících podmínek.",
                    label = "Násobitel perfektní péče",
                },
                drugGrowthMinMultiplier = {
                    description = "Násobitel růstu použit, pokud jsou podmínky pro rostlinu kriticky špatné.",
                    label = "Násobitel kritické péče",
                },
                drugGrowthQualityBonusMax = {
                    description = "Maximální dodatečný bonus růstu udělený kvalitou rostliny.",
                    label = "Bonus za kvalitu růstu",
                },
            },
            errors = {
                invalid_role_permission_defaults = "Zvolte platné minimální hodnosti pro oprávnění rolí.",
                base_raid_locked = "Základna je napadena. Její skladovací místa a konfigurace jsou uzamčeny.",
                base_storage_outside_zone = "Všechna místa pro skladování, skříňky i skladování přepadení musí být uvnitř zóny základny.",
                base_zone_invalid_polygon = "Umístěte alespoň tři odlišné body bez křížení hran, poté zkontrolujte výšku (3–200 m) a vyrovnávací bucket.",
                base_zone_point_limit = "Zóna hlavní základny podporuje maximálně 64 hraničních bodů.",
                base_zone_required = "Nejdříve nastavte platnou zónu hlavní základny pro tuto kriminální práci.",
                crime_interrogation_invalid_model = "Zadejte platný model objektu.",
                crime_interrogation_invalid_coords = "Umístěte objekt na platnou pozici.",
                crime_interrogation_invalid_zone_points = "Umístěte alespoň tři platné hraniční body.",
                crime_interrogation_duplicate_id = "Objekt s tímto ID již existuje.",
                crime_interrogation_tool_invalid = "Zkontrolujte definici nástroje.",
                crime_interrogation_tool_id_invalid = "Zadejte platné ID nástroje.",
                crime_interrogation_tool_label_missing = "Zadejte název nástroje.",
                crime_interrogation_effect_missing = "Nastavte účinek nástroje.",
                crime_interrogation_effect_type_unknown = "Vyberte podporovaný typ účinku.",
                crime_interrogation_effect_status_missing = "Určete stav ovlivněný tímto nástrojem.",
                crime_interrogation_minigame_missing = "Nastavte minihru pro nástroj.",
                crime_interrogation_minigame_type_unknown = "Vyberte podporovaný typ minihry.",
                crime_interrogation_keys_missing = "Nastavte ovládání nástroje.",
                crime_interrogation_keys_invalid = "Zkontrolujte nastavené ovládací klávesy nástroje.",
                crime_interrogation_keys_duplicate = "Přiřaďte každou akci a ovládací klávesu nástroje pouze jednou.",
                crime_interrogation_anim_invalid = "Zkontrolujte slovník a klip animace nástroje.",
                crime_interrogation_anim_missing = "Nastavte animaci uživatele nástroje.",
                crime_interrogation_occupied = "Na tomto objektu je již někdo připoután.",
                crime_interrogation_not_found = "To už neexistuje.",
            },
            extensions = {
                baseZone = {
                    description = "Umístěte 3 až 64 hraničních bodů v pořadí. Nejnižší umístěný bod určuje dno; výška se od něj táhne nahoru. Body jsou uloženy jako koncept; použijte Uložit pro aplikaci zóny. Během nájezdů jsou v rámci zóny dostupné pouze sklady, skříňky a přepadené sklady. Body mimo zónu nebrání uložení ani zahájení nájezdu. Stávající hranice zůstávají aktivní, dokud neuložíte.",
                    fields = {
                        bucket = "Routingový bucket",
                        configured = "Nakonfigurováno",
                        height = "Výška (metrů)",
                        radius = "Poloměr (metrů)",
                        x = "Střed X",
                        y = "Střed Y",
                        z = "Střed Z",
                    },
                    label = "Zóna hlavní základny",
                },
                invalidSelection = "Neplatná volba: {value}",
            },
            locationDescriptions = {
                crimeStationPosition = "Hlavní bod této pracovní lokace. Pokud je blip na mapě povolen v Job → Blips, zobrazí se zde.",
            },
            locationTypes = {
                crimeStationPosition = "Lokalita / blip na mapě",
                heistCrafting = "Dílna pro heisty",
                heistStorage = "Sklad loupeží",
            },
            membershipMigration = {
                cancel = "Zrušit",
                confirm = "Migrovat a uložit",
                message = "Stávající členství v organizacích budou migrována do vybraného modelu. V nezávislém režimu zůstává běžné zaměstnání oddělené.",
                title = "Změnit model členství?",
            },
            moneywashActions = {
                currentLocation = "Použít aktuální polohu",
                invalidLocations = "Zkontrolujte ID, názvy, výběr interiérů a souřadnice. Každá lokalita musí mít unikátní ID.",
                position = "Pozice",
            },
            moneywashBusiness = {
                moneywashBuildNodes = { label = "Stavební body", description = "Umístěte kompatibilní zařízení na tyto body. Souřadnice jsou relativní k interiéru." },
                mwBuildNodes = "Stavební body",
                moneywashPublicEquipment = { label = "Veřejné vybavení", description = "Přiřaďte pračky, generátory a ventilátory veřejným podnikům a vhodným bodům." },
                mwPublicEquipment = "Veřejné vybavení",
                moneywashMaterials = { label = "Materiály", description = "Použijte přesné názvy inventářových předmětů. Hmotnost je v gramech; chybějící předměty nainstalujte." },
                mwMaterials = "Materiály",
                moneywashMaterialRecipes = { label = "Recepty materiálů", description = "Vstupy, výstupy a trvání platí na jednotku. Zpracovatelé používají tyto recepty." },
                mwMaterialRecipes = "Recepty materiálů",
                moneywashProductionRecipes = { label = "Tiskové recepty", description = "Papír, barva a časy platí na jednotku. Hotovost až po sušení a kontrole kvality." },
                mwProductionRecipes = "Tiskové recepty",
                moneywashCollectors = { label = "Sběrači", description = "Nastavte výnos, nástroje, čekání a světovou polohu každého sběrače." },
                mwCollectors = "Sběrači",
                moneywashProcessors = { label = "Zpracovatelé", description = "Vyberte recept materiálu a světovou polohu každého zpracovatele." },
                mwProcessors = "Zpracovatelé",

                control = "Ovládací panel",
                editor = {
                    addBusiness = "Přidat podnik",
                    addInterior = "Přidat interiér",
                    advanced = "Technické údaje",
                    asset_ipl = "IPL: Zadejte přesný název IPL a pozici interiéru.",
                    asset_mlo = "MLO: Používá se pozice již nainstalovaného interiéru. Aktuálně se vstupem je vstup do podniku.",
                    asset_shell = "Shell: Modelová resource musí být na serveru nainstalovaná a spuštěná.",
                    businessHelp = "Název podniku, výběr interiéru a stanovení nákupní ceny.",
                    businessListHelp = "Spravujte vstupy a nákupní ceny svých podniků.",
                    businesses = "Podniky",
                    capture = "Nastavit ve hře",
                    captureOrigin = "Nastavit pozici interiéru",
                    chooseInterior = "Vybrat interiér",
                    coordinates = "Upravit souřadnice",
                    editSections = "Nastavení",
                    emptyBusinessHelp = "Propojte vstup na mapě s interiérem. Vaše organizace si následně mohou zakoupit prázdný podnik.",
                    emptyBusinesses = "Váš první podnik",
                    emptyInteriorHelp = "Připojte IPL, shell nebo nainstalované MLO, poté nastavte body používané podnikem.",
                    emptyInteriors = "Váš první interiér",
                    entranceHelp = "Nastavte vstup tam, kde mají hráči podnik zakoupit a vstoupit do něj.",
                    freecamHelp = "Freecam: WASD pohyb, Q/E nahoru/dolů, Shift rychleji, Ctrl pomaleji. Pravé tlačítko myši: pohled. Přetáhněte gizmo, R otáčení/pohyb, Enter umístit, Backspace zrušit.",
                    general = "Obecné",
                    heading = "Směr",
                    interiorHelp = "Vyberte typ interiéru a jeho asset.",
                    interiorListHelp = "Připravte prázdné prostory. Hráči si sami umístí své stroje a vybavení.",
                    interiors = "Interiéry",
                    listEmpty = "Zatím žádné záznamy.",
                    locationTypes = "Správa lokalit",
                    newBusiness = "Nový podnik",
                    newInterior = "Nový interiér",
                    noResults = "Žádné odpovídající záznamy.",
                    notSet = "Není nastaveno",
                    offsetHelp = "Vstupní hodnoty jsou posuny od počátku. Světová pozice je zobrazena výše.",
                    origin = "Původní bod",
                    originHelp = "Pozice interiéru. Všechny ostatní body jsou vůči ní relativní.",
                    originRequired = "Nejdříve nastavte polohu interiéru v sekci Obecné.",
                    outsideRange = "Mimo dosah {range} metrů",
                    point_control = "Pomocí gizma přesuňte a otočte nástěnný panel na místo. Potvrzená výška objektu bude zachována přesně. Marker přepnete v Interactions → Money Wash: control panel.",
                    point_entry = "Zde hráči přicházejí a odcházejí. Odchod je automaticky přesměrován k vchodu do jejich podniku venku.",
                    point_position = "Tento bod je mimo podnik.",
                    point_storage = "Pomocí gizma přesuňte a otočte regál, dokud nebude ležet na podlaze. Členové zde přistupují k zakoupenému vybavení. Marker přepnete v Interactions → Money Wash: storage.",
                    points = "Body",
                    pointsHelp = "Vyberte bod a nastavte jej přímo ve hře.",
                    rangeNote = "Platí dosah {range} metrů kolem původního bodu interiéru bez omezení výšky.",
                    remove = "Odebrat",
                    repairRange = "Posuňte tyto body blíže k původnímu bodu interiéru.",
                    saveHint = "Změny potvrďte tlačítkem Uložit v horní části.",
                    search = "Hledat …",
                    set = "Nastavit",
                    teleport = "Teleportovat",
                    viewInteriors = "Zobrazit interiéry",
                    visit = "Navštívit",
                    visitHint = "Pohybujte se volně. Stisknutím Backspace se vrátíte do editoru.",
                    visitTitle = "Prohlídka interiéru",
                },
                entry = "Vstup a výstup",
                fields = {
                    mode = "Režim přístupu",
                    ownerKind = "Typ vlastníka",
                    productionEnabled = "Dostupná tisková část",
                    feePercent = "Poplatek (%) / -1 = globální",
                    storageCapacity = "Kapacita skladu (předměty)",
                    maximumOrders = "Souběžné objednávky na hráče",
                    gridPower = "Síťové napájení / 0 = generátor",
                    autoService = "Automatická veřejná údržba",
                    maximumPendingOutputs = "Maximum čekajících výplat",
                    placementRange = "Poloměr umístění (m)",
                    placementHeight = "Výškový rozsah umístění (m)",
                    interiorId = "ID interiéru",
                    equipmentId = "ID zařízení",
                    nodeId = "ID stavebního bodu",
                    generatorNode = "ID bodu generátoru",
                    maxOffset = "Maximální odchylka od bodu (m)",
                    maxHeight = "Maximální výšková odchylka (m)",
                    weight = "Hmotnost předmětu (g)",
                    inputItem = "Vstupní materiál",
                    secondItem = "Druhý vstupní materiál",
                    outputItem = "Výstupní materiál",
                    requiredTool = "Požadovaný nástroj",
                    baseQuality = "Počáteční kvalita (%)",
                    minimumQuality = "Minimální kvalita (%)",
                    inspectionCards = "Kontrolní karty",
                    inspectionPenalty = "Ztráta kvality za chybu (%)",
                    rejectPercent = "Vyřazené bankovky (%)",
                    accessoryModel = "Model příslušenství",
                    accessoryMaximum = "Maximum viditelného příslušenství",
                    accessoryActiveOnly = "Příslušenství pouze při zpracování",
                    animDict = "Slovník animace",
                    animClip = "Animační klip",
                    cooldown = "Čekací doba (sekundy)",
                    minimum = "Minimální výnos",
                    maximum = "Maximální výnos",
                    productionPrice = "Tisk peněz · Nákupní cena",
                    recipeId = "Recept ID",
                    inputAmount = "Materiál / na jednotku",
                    secondAmount = "Materiál / na jednotku",
                    outputAmount = "Materiál / na jednotku",
                    paperItem = "Tiskový papír",
                    inkItem = "Tisková barva",
                    paperAmount = "Tiskový papír / na jednotku",
                    inkAmount = "Tisková barva / na jednotku",
                    notesPerUnit = "Bankovky / na jednotku",
                    valuePerNote = "Hotovost / Bankovky",
                    maximumUnits = "Jednotky (max.)",
                    printSeconds = "Tisk / na jednotku (Sekundy)",
                    inspectionSeconds = "Kontrola / na jednotku (Sekundy)",
                    rinseSeconds = "Praní / na jednotku (Sekundy)",
                    drySeconds = "Sušení / na jednotku (Sekundy)",
                    accessoryUnit = "Bankovky / na jednotku",
                    accessoryX = "Model příslušenství · X (m)",
                    accessoryY = "Model příslušenství · Y (m)",
                    accessoryZ = "Model příslušenství · Z (m)",
                    accessoryStep = "Model příslušenství · Z (m)",

                    capacity = "Kapacita na cyklus",
                    controlHeading = "Směr ovládacího panelu",
                    controlHeight = "Výška montáže nad bodem (m)",
                    controlModel = "Model nástěnných panelů",
                    controlX = "Ovládací panel X",
                    controlY = "Ovládací panel Y",
                    controlZ = "Ovládací panel Z",
                    disableSets = "Skryté sady entit (oddělené čárkou)",
                    enableSets = "Aktivované sady entit (oddělené čárkou)",
                    entryX = "Posun vstupu X",
                    entryY = "Odsaz Y vstupu",
                    entryZ = "Posun vstupu Z",
                    heading = "Směr pohledu",
                    id = "Unikátní ID",
                    interior = "Interiér",
                    ipl = "Název IPL",
                    kind = "Typ",
                    label = "Jméno",
                    model = "Název modelu",
                    power = "Jednotky energie",
                    price = "Nákupní cena",
                    radius = "Poloměr umístění (m)",
                    repairPrice = "Cena opravy (0 = zdarma)",
                    seconds = "Doba cyklu (sekundy)",
                    storageHeading = "Směr bodu skladu",
                    storageModel = "Model regálu",
                    storageX = "Bod úložiště X",
                    storageY = "Bod skladu Y",
                    storageZ = "Bod úložiště Z",
                    wear = "Opotřebení na cyklus (%)",
                    x = "Původní bod X",
                    y = "Původní bod Y",
                    z = "Původní bod Z",
                },
                interactions = {
                    control = "Praní peněz: ovládací panel",
                    storage = "Praní peněz: sklad",
                },
                item = "Záznam",
                moneywashBucketStart = {
                    description = "Rezervovat tento rozsah výhradně pro praní peněz. Změny se projeví při příštím vstupu.",
                    label = "Začátek rozsahu instance",
                },
                moneywashEquipment = {
                    description = "Hráči kupují a rozmísťují zařízení. Na pračky se vztahují kapacita, doba trvání a opotřebení. Energie je dodávána generátorem nebo je vyžadována zařízeními. Změny se týkají nových nákupů.",
                    label = "Vybavení na koupení",
                },
                moneywashInteriors = {
                    description = "Konfigurace prázdných interiérů IPL, shell nebo MLO. Vstup, ovládací panel, sklad a hranice výstavby jsou relativní k původnímu bodu. Odchod hráče vrátí zpět k vstupu jeho podniku.",
                    label = "Interiéry (IPL, shell nebo MLO)",
                },
                moneywashMaximumEquipment = {
                    description = "Maximální počet zakoupených zařízení a opravných sad na jeden podnik.",
                    label = "Limit vybavení",
                },
                moneywashPreviewBucketStart = {
                    description = "Návštěva přidá ID hráče k této hodnotě pro soukromou admin instanci. Rezervujte ji odděleně od podniků a ostatních zdrojů. Změny se projeví v dalším náhledu.",
                    label = "Začátek rozsahu náhledu instance",
                },
                moneywashProperties = {
                    description = "Nastavte vstup, vyberte interiér a stanovte nákupní cenu. Zakoupené podniky si zachovají svůj uložený interiér a rozvržení.",
                    label = "Vstupy do podniků",
                },
                moneywashRepairShops = {
                    description = "Nastavte opravny, teleportujte se do nich a stanovte cenu služby. Prodávají opravné sady a servisují uložené stroje.",
                    label = "Lokality obchodů",
                },
                moneywashShops = {
                    description = "Umístěte obchody pro pračky, generátory a ventilátory. Objednávky odcházejí do vybraného podniku organizace.",
                    label = "Lokality obchodů",
                },
                mwEquipment = "Obchod s vybavením",
                mwInteriors = "Prázdné interiéry",
                mwProperties = "Lokality",
                mwRepairShops = "Opravna",
                mwSettings = "Nastavení podniku",
                names = {
                    mwPublicLaundry = "Veřejná prádelna",
                    mwPaperPulp = "Papírová buničina",
                    mwPrintingPaper = "Tiskový papír",
                    mwPrintingInk = "Tisková barva",
                    mwPaperRecipe = "Výroba tiskového papíru",
                    mwPrintingRecipe = "Běžné bankovky",
                    mwPaperCollector = "Sběrač papíru",
                    mwInkCollector = "Sběrač barvy",
                    mwPaperProcessor = "Zpracovatel papíru",
                    mwPrinter = "Tiskařský stroj",
                    mwInspectionTable = "Kontrolní stůl",
                    mwDryingCabinet = "Sušicí skříň",
                    mwNode1 = "1 · Praní",
                    mwNode2 = "2 · Praní",
                    mwNode3 = "3 · Stavební body",
                    mwNode4 = "4 · Tisk",
                    mwNode5 = "5 · Kontrola",
                    mwNode6 = "6 · Sušení",
                    mwNode7 = "7 · Stavební body",

                    mwInteriorWarehouse = "Prázdný sklad",
                },
                options = {
                    private = "Soukromé",
                    public = "Veřejné",
                    faction = "Organizace",
                    person = "Postava",
                    printer = "Tiskařský stroj",
                    inspection = "Kontrolní stůl",
                    dryer = "Sušicí skříň",

                    fan = "Ventilátor",
                    generator = "Generátor",
                    ipl = "IPL",
                    mlo = "MLO",
                    repair = "Sada na opravu",
                    shell = "Model Shell",
                    washer = "Práčka",
                },
                origin = "Původní bod",
                storage = "Bod skladu",
            },
            settingFields = {
                cultivationLevel = "Úroveň pěstování",
                cultivationTitle = "Název úrovně",
                cultivationRequiredXp = "Požadované celkové XP",
                cultivationAction = "Akce",
                cultivationXp = "XP",
                cultivationCategory = "Kategorie",
                cultivationEntry = "Položka",
                cultivationRequiredLevel = "Požadovaná úroveň",
                alias = "Alias",
                atmHeading = "Směr",
                atmId = "ID",
                atmModel = "Model bankomatu",
                centerX = "Střed X",
                centerY = "Střed Y",
                centerZ = "Střed Z",
                deliveryMethod = "Způsob doručení",
                description = "Popis",
                enabled = "Aktivováno",
                groupKey = "Klíč skupiny",
                id = "ID",
                itemLabel = "Název zboží",
                itemName = "Název položky v inventáři",
                knownScammer = "Známý podvodník",
                locationName = "Název lokality",
                observerW = "Směr pozorovatele",
                observerX = "Pozorovatel X",
                observerY = "Pozorovatel Y",
                observerZ = "Pozorovatel Z",
                pedModel = "Model NPC pedia",
                pickpocketItemChance = "Šance (%)",
                pickpocketItemMaximum = "Maximální množství",
                pickpocketItemMinimum = "Minimální množství",
                pickpocketItemName = "Název položky v inventáři",
                quantity = "Množství",
                radius = "Poloměr",
                rating = "Zobrazené hodnocení",
                ratingCount = "Počet zobrazených hodnocení",
                scamChance = "Šance na podvod obchodníka (%)",
                shopCategory = "Kategorie",
                shopClerkHeading = "Směr prodavače",
                shopClerkModel = "Model prodavače",
                shopClerkRequired = "Vyžadován prodavač",
                shopClerkX = "Prodavač X",
                shopClerkY = "Prodavač Y",
                shopClerkZ = "Prodavač Z",
                shopCodeEnabled = "Povolit otevírání kódem",
                shopDrillEnabled = "Povolit vrtání",
                shopEnabled = "Aktivováno",
                shopHackEnabled = "Povolit hacking",
                shopLocationId = "ID obchodu",
                shopLocationLabel = "Štítek",
                shopRegisterId = "ID pokladny",
                shopSafeEnabled = "Trezor aktivní",
                shopSafeHeading = "Směr trezoru",
                shopSafeX = "Trezor X",
                shopSafeY = "Trezor Y",
                shopSafeZ = "Trezor Z",
                side = "Strana trhu",
                spawns = "Spawnování týmu",
                successfulTrades = "Zobrazené úspěšné obchody",
                title = "Název nabídky",
                unitPrice = "Cena za jednotku",
                verified = "Ověřený obchodník",
                w = "Směr",
                x = "X",
                y = "Y",
                z = "Z",
                shopClerkPosition = "Pozice prodavače",
                shopRegisterPosition = "Pozice pokladny",
                shopSafePosition = "Pozice trezoru",
                registerId = "ID pokladny",
                registerX = "Souřadnice X pokladny",
                registerY = "Souřadnice Y pokladny",
                registerZ = "Souřadnice Z pokladny",
                heading = "Směr",
                captureLocation = "Zaznamenat polohu",
            },
            crimeDashboard = {
                jobs = "Spravujte frakce, členy, oprávnění a umístění.",
                jobCreator = "Vyberte frakci a upravte její umístění a oblasti.",
                jobsQuestion = "Kde upravím frakce a umístění?",
                jobsAnswer = "Otevřete {path}, vyberte frakci a zvolte Upravit. Zde nastavíte její možnosti a umístění.",
                creatorsAnswer = "Editory najdete v {path}. Tyto odkazy otevřou editor; nástroje frakcí začínají výběrem frakce.",
                missingAnswer = "Dostupné editory závisejí na vybraném prostředku a jeho nastavení. Nástroje frakcí začínají u příslušné frakce.",
                creators = {
                    mainbaseZones = "Vyberte frakci a nastavte oblast její základny.",
                    presetTerritories = "Prohlédněte přednastavené čtvrti a vyberte, které budou aktivní.",
                    objectsSection = "Spravujte trvalé výslechové židle a vozíky s nástroji.",
                    blockedZonesSection = "Určete oblasti, kde nelze umisťovat výslechové objekty.",
                    toolsSection = "Nastavte nástroje dostupné během výslechů.",
                    sessionsSection = "Zobrazte probíhající výslechy a podle potřeby je ukončete.",
                    orphansSection = "Zkontrolujte a odstraňte opuštěné výslechové objekty.",
                },
            },
            crimeGroupDescriptions = {
                general = {
                    crimeMembership = "Zvolte, jakým způsobem kriminální organizace ukládají a spravují své členy.",
                },
                territories = {
                    zones = "Nastavte možnosti „Zóny území“ v sekci „Teritoria“.",
                    ownership = "Nastavte možnosti „Vlastnictví“ v sekci „Teritoria“.",
                    decay = "Nastavte možnosti „Degradace“ v sekci „Teritoria“.",
                    presence = "Nastavte možnosti „Přítomnost“ v sekci „Teritoria“.",
                    activity = "Nastavte možnosti „Skóre aktivity“ v sekci „Teritoria“.",
                    ownershipBenefits = "Nastavte možnosti „Výhody vlastníku“ v sekci „Teritoria“.",
                },
                graffiti = {
                    general = "Nastavte možnosti „Obecné“ v sekci „Graffiti“.",
                    streaming = "Nastavte možnosti „Renderování“ v sekci „Graffiti“.",
                    moderation = "Nastavte možnosti „Moderace“ v sekci „Graffiti“.",
                },
                pvpEvents = {
                    pvpAvailability = "Ovládá, zda je aplikace pro PvP události dostupná a kde se zobrazuje.",
                    pvpAutomation = "Konfiguruje opakované události a automatické zpracování spuštění.",
                    pvpRuntime = "Upravte zpracování požadavků, úmrtí a respawny během probíhajících zápasů.",
                    pvpModes = "Konfigurujte režim hry předvolený v PvP tabletu.",
                    pvpArenas = "Vytvoří kruhovou zónu, pozorovací bod a body spawnu týmů používané v PvP akcích.",
                    pvpLimits = "Nastavte limity odměn a historie na tabletu.",
                    pvpPermissions = "Přiřadí správu událostí a finance k ACE a povolením prací.",
                    pvpTakeoverRules = "Ovládá dostupnost a požadavky na účast při převzetí laboratoří a kempů.",
                    pvpTakeoverZones = "Nastavte oblasti interakce, poplachu a obsazování společně s jejich dobou trvání.",
                    pvpTakeoverMethods = "Konfigurujte, jak dlouho trvá každá metoda vlámování do vstupu.",
                },
                drugs = {
                    creator = "Otevře editor drog Sky Crime a zavře konfigurátor povolání.",
                    creatorSettings = "Nastavte možnosti „Nastavení editoru“ v sekci „Drogový systém“.",
                    interfaceHud = "Nastavte možnosti „Pozice rozhraní“ v sekci „Drogový systém“.",
                    drugsGeneral = "Nastavte možnosti „Obecné“ v sekci „Drogový systém“.",
                    runtimeAccess = "Nastavte možnosti „Přístup a vlastnictví“ v sekci „Drogový systém“.",
                    runtimePayouts = "Nastavte možnosti „Výplaty“ v sekci „Drogový systém“.",
                    runtimeDispatch = "Nastavte možnosti „Dispečink a policie“ v sekci „Drogový systém“.",
                    performanceInactiveControlIntervalMs = "Provozní nastavení pro: Výkon / Neaktivní / Ovládání / Interval / ms.",
                    performanceInteractionIdleScanIntervalMs = "Provozní nastavení pro: Výkon / Interakce / Nečinný / Interval skenování / ms.",
                    performanceInteractionPromptIntervalMs = "Provozní nastavení pro: Výkon / Interakce / Výzva k interakci / Interval / ms.",
                    performanceInteractionScanIntervalMs = "Provozní nastavení pro: Výkon / Interakce / Interval skenování / ms.",
                    performanceMinimumScanIntervalMs = "Provozní nastavení pro: Výkon / Minimum / Interval skenování / ms.",
                    performanceStreetPedActivationDistance = "Provozní nastavení pro: Výkon / Ulice / Ped / Aktivace / Vzdálenost.",
                    performanceStreetPedIdleScanIntervalMs = "Provozní nastavení pro: Výkon / Ulice / Ped / Nečinný / Interval skenování / ms.",
                    performanceStreetPedScanIntervalMs = "Provozní nastavení pro: Výkon / Ulice / Ped / Interval skenování / ms.",
                    performanceWorldCachePadding = "Provozní nastavení pro: Výkon / Svět / Mezipaměť / Dodatečná rezerva.",
                    performanceWorldCacheRefreshIntervalMs = "Provozní nastavení pro: Výkon / Svět / Mezipaměť / Obnovení / Interval / ms.",
                    performanceWorldIdleIntervalMs = "Provozní nastavení pro: Výkon / Svět / Nečinný / Interval / ms.",
                },
                drugProduction = {
                    qualityWeights = "Nastavte možnosti „Kvalita / Váhy“ v sekci „Výroba drog“.",
                    qualityTiers = "Nastavte možnosti „Kvalita / Úrovně kvality“ v sekci „Výroba drog“.",
                    packagingGeneral = "Nastavte možnosti „Obecné“ v sekci „Výroba drog“.",
                    processingFlow = "Nastavte možnosti „Průběh zpracování“ v sekci „Výroba drog“.",
                    processingGeneral = "Nastavte možnosti „Obecné“ v sekci „Výroba drog“.",
                },
                drugOperations = {
                    growingGeneral = "Nastavte možnosti „Obecné“ v sekci „Drogové provozy“.",
                    plantDefaults = "Nastavte možnosti „Rostlina / Výchozí hodnoty“ v sekci „Drogové provozy“.",
                    harvestWindow = "Nastavte možnosti „Sklizeň / Časové okno“ v sekci „Drogové provozy“.",
                    labsGeneral = "Zapne: laboratoře a obytné vozy ve hře.",
                    labRent = "Nastavte možnosti „Nájem a životní cyklus“ v sekci „Drogové provozy“.",
                    camperDefaults = "Nastavte možnosti „Kemp“ v sekci „Drogové provozy“.",
                    labUpgrades = "Násobitel pro: Laboratoř / Úroveň / Vylepšení / Ceny.",
                    labDefaults = "Nastavte možnosti „Laboratoř / Výchozí hodnoty“ v sekci „Drogové provozy“.",
                    powerGeneral = "Nastavte možnosti „Obecné“ v sekci „Drogové provozy“.",
                    generators = "Nastavte možnosti „Generátory“ v sekci „Drogové provozy“.",
                    equipmentWear = "Globální násobitel pro: Opotřebení vybavení / Zpracování.",
                    workersGeneral = "Nastavte možnosti „Obecné“ v sekci „Drogové provozy“.",
                    cultivationGeneral = "Nastavte možnosti „Obecné“ v sekci „Drogové provozy“.",
                    cultivationCurve = "Nastavte název a celkový práh XP pro každou úroveň pěstování.",
                    cultivationExperience = "Nastavte množství XP pěstování za jednotlivé akce.",
                    cultivationUnlocks = "Nastavte požadované úrovně pro nádoby, substráty, vybavení, odrůdy a úrovně skeneru.",
                    powerRuntime = "Interval v sekundách pro: aktualizace spotřeby generátorů a energetických stop.",
                    powerHeat = "Nastavte možnosti „Pozornost policie a energetická stopa“ v sekci „Drogové provozy“.",
                    powerModes = "Nastavte možnosti „Management / Režimy“ v sekci „Drogové provozy“.",
                    powerPriorities = "Nastavte možnosti „Zatížení / Priority“ v sekci „Drogové provozy“.",
                },
                drugMarketRisk = {
                    marketGeneral = "Nastavte možnosti „Obecné“ v sekci „Trh a rizika“.",
                    marketPrices = "Nastavte možnosti „Ceny“ v sekci „Trh a rizika“.",
                    distribution = "Nastavte možnosti „Distribuce“ v sekci „Trh a rizika“.",
                    threatsGeneral = "Nastavte možnosti „Obecné“ v sekci „Trh a rizika“.",
                    threatHeat = "Nastavte možnosti „Policejní tlak“ v sekci „Trh a rizika“.",
                    threatChances = "Nastavte možnosti „Pravděpodobnosti“ v sekci „Trh a rizika“.",
                    consumptionGeneral = "Nastavte možnosti „Obecné“ v sekci „Trh a rizika“.",
                    consumerDecay = "Nastavte možnosti „Pokles tolerance a závislosti“ v sekci „Trh a rizika“.",
                    consumerEffects = "Nastavte možnosti „Účinky a rizika“ v sekci „Trh a rizika“.",
                },
                drugNetworks = {
                    dynamicMarketActionCooldownSeconds = "Provozní nastavení pro: Dynamický trh / Cooldown akce / sekundů.",
                    dynamicMarketActionHistoryLimit = "Provozní nastavení pro: Dynamický trh / Akce / Limit historie.",
                    dynamicMarketAmountSaturationWeight = "Provozní nastavení pro: Dynamický trh / Množství / Nasycení / Hmotnost.",
                    dynamicMarketBaseIntelAccuracy = "Provozní nastavení pro: Dynamický trh / Základní hodnota / Přesnost informací.",
                    dynamicMarketDefaultAverageQuality = "Provozní nastavení pro: Dynamický trh / Výchozí hodnota / Průměr / Kvalita.",
                    dynamicMarketDefaultResourceElasticity = "Provozní nastavení pro: Dynamický trh / Výchozí hodnota / Surovina / Elasticita.",
                    dynamicMarketDemandCenter = "Provozní nastavení pro: Dynamický trh / Poptávka / Střední hodnota.",
                    dynamicMarketDemandPriceImpact = "Provozní nastavení pro: Dynamický trh / Poptávka / Cena / Dopad.",
                    dynamicMarketDirectionThreshold = "Provozní nastavení pro: Dynamický trh / Směr / Práh.",
                    dynamicMarketEnabled = "Provozní nastavení pro: Dynamický trh / Aktivováno.",
                    dynamicMarketEventChance = "Provozní nastavení pro: Dynamický trh / Událost / Šance.",
                    dynamicMarketEventDurationMinutes = "Provozní nastavení pro: Dynamický trh / Událost / Doba trvání / Minuty.",
                    dynamicMarketEventMinimumDurationMinutes = "Provozní nastavení pro: Dynamický trh / Událost / Minimum / Doba trvání / Minuty.",
                    dynamicMarketEventStrengthMaximum = "Provozní nastavení pro: Dynamický trh / Událost / Síla / Maximum.",
                    dynamicMarketEventStrengthMinimum = "Provozní nastavení pro: Dynamický trh / Událost / Síla / Minimum.",
                    dynamicMarketEvents = "Nastavte možnosti „Události“ v sekci „Drogové sítě“.",
                    dynamicMarketExactIntelReputation = "Provozní nastavení pro: Dynamický trh / Přesné informace / Reputace.",
                    dynamicMarketExactIntelTrust = "Provozní nastavení pro: Dynamický trh / Přesné informace / Důvěra.",
                    dynamicMarketGlobalZoneLabel = "Provozní nastavení pro: Dynamický trh / Global / Zóna / Štítek.",
                    dynamicMarketHistoryLimit = "Provozní nastavení pro: Dynamický trh / Limit historie.",
                    dynamicMarketInitialDemand = "Provozní nastavení pro: Dynamický trh / Počáteční hodnota / Poptávka.",
                    dynamicMarketInitialPriceMultiplier = "Provozní nastavení pro: Dynamický trh / Počáteční hodnota / Násobitel ceny.",
                    dynamicMarketIntelDemandError = "Provozní nastavení pro: Dynamický trh / Informace / Poptávka / Error.",
                    dynamicMarketIntelMaximumAccuracy = "Provozní nastavení pro: Dynamický trh / Informace / Maximum / Přesnost.",
                    dynamicMarketIntelMinimumAccuracy = "Provozní nastavení pro: Dynamický trh / Informace / Minimum / Přesnost.",
                    dynamicMarketIntelPoliceError = "Provozní nastavení pro: Dynamický trh / Informace / Policie / Error.",
                    dynamicMarketIntelPriceError = "Provozní nastavení pro: Dynamický trh / Informace / Cena / Error.",
                    dynamicMarketIntelPriceMaximum = "Provozní nastavení pro: Dynamický trh / Informace / Cena / Maximum.",
                    dynamicMarketIntelPriceMinimum = "Provozní nastavení pro: Dynamický trh / Informace / Cena / Minimum.",
                    dynamicMarketIntelReputationWeight = "Provozní nastavení pro: Dynamický trh / Informace / Reputace / Hmotnost.",
                    dynamicMarketIntelResourcePriceError = "Provozní nastavení pro: Dynamický trh / Informace / Surovina / Cena / Error.",
                    dynamicMarketIntelSaturationError = "Provozní nastavení pro: Dynamický trh / Informace / Nasycení / Error.",
                    dynamicMarketIntelSeedBucketSeconds = "Provozní nastavení pro: Dynamický trh / Okno semene informací / sekundů.",
                    dynamicMarketIntelStatusAccuracyThreshold = "Provozní nastavení pro: Dynamický trh / Informace / Stav / Přesnost / Práh.",
                    dynamicMarketIntelStatusErrorThreshold = "Provozní nastavení pro: Dynamický trh / Informace / Stav / Error / Práh.",
                    dynamicMarketIntelSupplyError = "Provozní nastavení pro: Dynamický trh / Informace / Zásobování / Error.",
                    dynamicMarketIntelTrustWeight = "Provozní nastavení pro: Dynamický trh / Informace / Důvěra / Hmotnost.",
                    dynamicMarketManipulationCooldownMinutes = "Provozní nastavení pro: Dynamický trh / Manipulace / Minuty prodlevy.",
                    dynamicMarketManipulationDemandShift = "Provozní nastavení pro: Dynamický trh / Manipulace / Poptávka / Posun.",
                    dynamicMarketManipulationDurationMinutes = "Provozní nastavení pro: Dynamický trh / Manipulace / Doba trvání / Minuty.",
                    dynamicMarketManipulationHeat = "Provozní nastavení pro: Dynamický trh / Manipulace / Policejní tlak.",
                    dynamicMarketManipulationMinimumBatchAmount = "Provozní nastavení pro: Dynamický trh / Manipulace / Minimum / Šarže / Množství.",
                    dynamicMarketManipulationPaymentAccount = "Provozní nastavení pro: Dynamický trh / Manipulace / Platební účet.",
                    dynamicMarketManipulationPrice = "Provozní nastavení pro: Dynamický trh / Manipulace / Cena.",
                    dynamicMarketManipulationZoneHeatMultiplier = "Provozní nastavení pro: Dynamický trh / Manipulace / Zóna / Policejní tlak / Násobitel.",
                    dynamicMarketMaximumIntelAgeMinutes = "Provozní nastavení pro: Dynamický trh / Maximum / Stáří informací / Minuty.",
                    dynamicMarketMaximumPriceMultiplier = "Provozní nastavení pro: Dynamický trh / Maximum / Násobitel ceny.",
                    dynamicMarketMinimumIntelAgeMinutes = "Provozní nastavení pro: Dynamický trh / Minimum / Stáří informací / Minuty.",
                    dynamicMarketMinimumMetricWindowMinutes = "Provozní nastavení pro: Dynamický trh / Minimum / Metrika / Časové okno / Minuty.",
                    dynamicMarketMinimumPriceMultiplier = "Provozní nastavení pro: Dynamický trh / Minimální cena / Násobitel.",
                    dynamicMarketMinimumUpdateMinutes = "Provozní nastavení pro: Dynamický trh / Minimum / Aktualizace / Minuty.",
                    dynamicMarketPoliceDemandWeight = "Provozní nastavení pro: Dynamický trh / Policie / Poptávka / Hmotnost.",
                    dynamicMarketPolicePriceImpact = "Provozní nastavení pro: Dynamický trh / Policie / Cena / Dopad.",
                    dynamicMarketPoorQualityDemandPenalty = "Provozní nastavení pro: Dynamický trh / Nízká kvalita / Poptávka / Postih.",
                    dynamicMarketPoorQualityThreshold = "Provozní nastavení pro: Dynamický trh / Nízká kvalita / Práh.",
                    dynamicMarketPremiumQualityDemandBonus = "Provozní nastavení pro: Dynamický trh / Prémiová kvalita / Bonus poptávky.",
                    dynamicMarketPremiumQualityThreshold = "Provozní nastavení pro: Dynamický trh / Prémiová kvalita / Práh.",
                    dynamicMarketProductionSupplyWeight = "Provozní nastavení pro: Dynamický trh / Produkce / Zásobování / Hmotnost.",
                    dynamicMarketProductionWindowMinutes = "Provozní nastavení pro: Dynamický trh / Produkce / Časové okno / Minuty.",
                    dynamicMarketQualityCenter = "Provozní nastavení pro: Dynamický trh / Kvalita / Střední hodnota.",
                    dynamicMarketQualityConfidenceImpact = "Provozní nastavení pro: Dynamický trh / Kvalita / Spolehlivost / Dopad.",
                    dynamicMarketQualityRange = "Provozní nastavení pro: Dynamický trh / Kvalita / Rozsah hodnot.",
                    dynamicMarketRarityBonusMaximum = "Provozní nastavení pro: Dynamický trh / Vzácnost / Bonus / Maximum.",
                    dynamicMarketRegionalGlobalWeight = "Provozní nastavení pro: Dynamický trh / Regionální / Global / Hmotnost.",
                    dynamicMarketRegionalLocalWeight = "Provozní nastavení pro: Dynamický trh / Regionální / Místní / Hmotnost.",
                    dynamicMarketResourceAliases = "Nastavte možnosti „Surovina / Alternativní názvy“ v sekci „Drogové sítě“.",
                    dynamicMarketResourceDirectionFallThreshold = "Provozní nastavení pro: Dynamický trh / Surovina / Směr / Pokles / Práh.",
                    dynamicMarketResourceDirectionRiseThreshold = "Provozní nastavení pro: Dynamický trh / Surovina / Směr / Růst / Práh.",
                    dynamicMarketResources = "Nastavte možnosti „Zdroje“ v sekci „Drogové sítě“.",
                    dynamicMarketSalesWindowMinutes = "Provozní nastavení pro: Dynamický trh / Prodeje / Časové okno / Minuty.",
                    dynamicMarketSaturationDemandWeight = "Provozní nastavení pro: Dynamický trh / Nasycení / Poptávka / Hmotnost.",
                    dynamicMarketSaturationPriceImpact = "Provozní nastavení pro: Dynamický trh / Nasycení / Cena / Dopad.",
                    dynamicMarketScarcityDemandWeight = "Provozní nastavení pro: Dynamický trh / Nedostatek / Poptávka / Hmotnost.",
                    dynamicMarketScarcityPriceImpact = "Provozní nastavení pro: Dynamický trh / Nedostatek / Cena / Dopad.",
                    dynamicMarketSeasonEndMonths = "Nastavte možnosti „Roční období / Konec / Měsíce“ v sekci „Drogové sítě“.",
                    dynamicMarketSeasonMultipliers = "Nastavte možnosti „Roční období / Násobitele“ v sekci „Drogové sítě“.",
                    dynamicMarketShortageRumorThreshold = "Provozní nastavení pro: Dynamický trh / Nedostatek / Fáma / Práh.",
                    dynamicMarketStatusThresholds = "Nastavte možnosti „Stav / Prahy“ v sekci „Drogové sítě“.",
                    dynamicMarketTargetSupply = "Provozní nastavení pro: Dynamický trh / Cíl / Zásobování.",
                    dynamicMarketTrendChance = "Provozní nastavení pro: Dynamický trh / Trend / Šance.",
                    dynamicMarketTrendDurationMinutes = "Provozní nastavení pro: Dynamický trh / Trend / Doba trvání / Minuty.",
                    dynamicMarketTrendMaximumStrength = "Provozní nastavení pro: Dynamický trh / Trend / Maximum / Síla.",
                    dynamicMarketTrendMinimumStrength = "Provozní nastavení pro: Dynamický trh / Trend / Minimum / Síla.",
                    dynamicMarketUpdateMinutes = "Provozní nastavení pro: Dynamický trh / Aktualizace / Minuty.",
                    dynamicMarketVolatilityMaximum = "Provozní nastavení pro: Dynamický trh / Kolísání cen / Maximum.",
                    dynamicMarketVolatilityMinimum = "Provozní nastavení pro: Dynamický trh / Kolísání cen / Minimum.",
                    dynamicMarketWeatherMultipliers = "Nastavte možnosti „Počasí / Násobitele“ v sekci „Drogové sítě“.",
                    dynamicMarketWeatherState = "Provozní nastavení pro: Dynamický trh / Počasí / Stav.",
                    heatActionCooldownSeconds = "Provozní nastavení pro: Pozornost policie a riziko / Cooldown akce / sekundů.",
                    heatActivityRiskWeights = "Nastavte možnosti „Aktivita / Riziko / Váhy“ v sekci „Drogové sítě“.",
                    heatAggressiveHeatMultiplier = "Provozní nastavení pro: Pozornost policie a riziko / Agresivní režim / Policejní tlak / Násobitel.",
                    heatBurnerBurnThreshold = "Provozní nastavení pro: Pozornost policie a riziko / Jednorázový telefon / Prozrazení / Práh.",
                    heatBurnerHeatPerWholesale = "Provozní nastavení pro: Pozornost policie a riziko / Jednorázový telefon / Policejní tlak / Za velkoobchodní prodej.",
                    heatBurnerPhoneItem = "Provozní nastavení pro: Pozornost policie a riziko / Burner phone / Předmět.",
                    heatCamperOperationalHeatMultiplier = "Provozní nastavení pro: Pozornost policie a riziko / Obytný vůz v provozu / Policejní tlak / Násobitel.",
                    heatCamperOperationalHeatThreshold = "Provozní nastavení pro: Pozornost policie a riziko / Obytný vůz v provozu / Policejní tlak / Práh.",
                    heatCamperParkedHeat = "Provozní nastavení pro: Pozornost policie a riziko / Zaparkovaný obytný vůz / Policejní tlak.",
                    heatContaminatedHeatMultiplier = "Provozní nastavení pro: Pozornost policie a riziko / Kontaminace / Policejní tlak / Násobitel.",
                    heatContaminatedThreshold = "Provozní nastavení pro: Pozornost policie a riziko / Kontaminace / Práh.",
                    heatCultivationFreePlants = "Provozní nastavení pro: Pozornost policie a riziko / Pěstování / Rostliny bez dodatečného rizika.",
                    heatCultivationHeatPerPlant = "Provozní nastavení pro: Pozornost policie a riziko / Pěstování / Policejní tlak / Za rostlinu.",
                    heatDealerHiddenMinutes = "Provozní nastavení pro: Pozornost policie a riziko / Dealer / skryté / Minuty.",
                    heatDecayPerTick = "Nastavte možnosti „Degradace / Za aktualizační cyklus“ v sekci „Drogové sítě“.",
                    heatEnabled = "Provozní nastavení pro: Pozornost policie a riziko / Aktivováno.",
                    heatEnforcementHeat = "Nastavte možnosti „Přítomnost policie / Policejní tlak“ v sekci „Drogové sítě“.",
                    heatEnforcementMultipliers = "Nastavte možnosti „Přítomnost policie / Násobitele“ v sekci „Drogové sítě“.",
                    heatEntityTypes = "Nastavte možnosti „Herní objekt / Typy“ v sekci „Drogové sítě“.",
                    heatEventCooldownMinutes = "Provozní nastavení pro: Pozornost policie a riziko / Událost / Minuty prodlevy.",
                    heatEventHistoryLimit = "Provozní nastavení pro: Pozornost policie a riziko / Událost / Limit historie.",
                    heatLabHeatSyncThreshold = "Provozní nastavení pro: Pozornost policie a riziko / Laboratoř / Policejní tlak / Synchronizace / Práh.",
                    heatLayLowCooldownMinutes = "Provozní nastavení pro: Pozornost policie a riziko / Držet se v ústraní / Minuty prodlevy.",
                    heatLayLowIdleMinutes = "Provozní nastavení pro: Pozornost policie a riziko / Držet se v ústraní / Nečinný / Minuty.",
                    heatLayLowReduction = "Provozní nastavení pro: Pozornost policie a riziko / Držet se v ústraní / Snížení.",
                    heatLockdownMinutes = "Provozní nastavení pro: Pozornost policie a riziko / Uzavření / Minuty.",
                    heatMinimumDurationMinutes = "Provozní nastavení pro: Pozornost policie a riziko / Minimum / Doba trvání / Minuty.",
                    heatMinimumEventCooldownSeconds = "Provozní nastavení pro: Pozornost policie a riziko / Minimum / Událost / Dočasné omezení (sekundy).",
                    heatMinimumIdleSeconds = "Provozní nastavení pro: Pozornost policie a riziko / Minimum / Nečinný / sekundů.",
                    heatProcessingHeatMultiplier = "Provozní nastavení pro: Pozornost policie a riziko / Zpracování / Policejní tlak / Násobitel.",
                    heatRiskWeights = "Nastavte možnosti „Riziko / Váhy“ v sekci „Drogové sítě“.",
                    heatRotateBurnerReduction = "Provozní nastavení pro: Pozornost policie a riziko / Vyměnit jednorázový telefon / Snížení.",
                    heatRouteControlMinutes = "Provozní nastavení pro: Pozornost policie a riziko / Trasa / Ovládání / Minuty.",
                    heatSaleHeat = "Nastavte možnosti „Prodej / Policejní tlak“ v sekci „Drogové sítě“.",
                    heatThresholds = "Nastavte možnosti „Prahy“ v sekci „Drogové sítě“.",
                    heatTickMinutes = "Provozní nastavení pro: Pozornost policie a riziko / Aktualizační cyklus / Minuty.",
                    heatWholesaleHeatMultiplier = "Provozní nastavení pro: Pozornost policie a riziko / Velkoobchod / Policejní tlak / Násobitel.",
                    heatWorkerLeakAlertRadius = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Radius poplachu.",
                    heatWorkerLeakBaseChance = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Základní hodnota / Šance.",
                    heatWorkerLeakFactionMultiplier = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Frakce / Násobitel.",
                    heatWorkerLeakHighSeverityThreshold = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Vysoká / Závažnost / Práh.",
                    heatWorkerLeakLoyaltyChanceMultiplier = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Lojalita / Šance / Násobitel.",
                    heatWorkerLeakLoyaltyThreshold = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Lojalita / Práh.",
                    heatWorkerLeakMaximumChance = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Maximum / Šance.",
                    heatWorkerLeakMinimumCooldownSeconds = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Minimum / Dočasné omezení (sekundy).",
                    heatWorkerLeakRouteMultiplier = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Trasa / Násobitel.",
                    heatWorkerLeakStrengthMaximum = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Síla / Maximum.",
                    heatWorkerLeakStrengthMinimum = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Síla / Minimum.",
                    heatWorkerLeakStrengthMultiplier = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Síla / Násobitel.",
                    heatWorkerLeakStressChanceMultiplier = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Stres / Šance / Násobitel.",
                    heatWorkerLeakStressThreshold = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Stres / Práh.",
                    contactsActionCooldownSeconds = "Provozní nastavení pro: Síť kontaktů / Cooldown akce / sekundů.",
                    contactsActiveHotspotCount = "Provozní nastavení pro: Síť kontaktů / Počet aktivních ohnisek.",
                    contactsBurnerHintTrust = "Provozní nastavení pro: Síť kontaktů / Tip pro burner / Důvěra.",
                    contactsBurnerOfferMaximumMultiplier = "Provozní nastavení pro: Síť kontaktů / Jednorázový telefon / Nabídka / Maximum / Násobitel.",
                    contactsBurnerOfferMinimumMultiplier = "Provozní nastavení pro: Síť kontaktů / Jednorázový telefon / Nabídka / Minimum / Násobitel.",
                    contactsBuyerCooldownMinutes = "Provozní nastavení pro: Síť kontaktů / Kupec / Minuty prodlevy.",
                    contactsBuyerDeliveryDistance = "Provozní nastavení pro: Síť kontaktů / Kupec / Vzdálenost doručení.",
                    contactsBuyerPremiumSuccessScore = "Provozní nastavení pro: Síť kontaktů / Kupec / Prémiové / Úspěch / Skóre.",
                    contactsBuyerPremiumTrustGain = "Provozní nastavení pro: Síť kontaktů / Kupec / Prémiové / Důvěra / zisk.",
                    contactsBuyerRequestHeatRiskWeight = "Provozní nastavení pro: Síť kontaktů / Kupec / Požadavek / Hledanost a riziko / Hmotnost.",
                    contactsBuyerStandardTrustGain = "Provozní nastavení pro: Síť kontaktů / Kupec / Standardní / Důvěra / zisk.",
                    contactsContactActiveDelaySeconds = "Nastavte možnosti „Prodleva aktivace kontaktu / sekundů“ v sekci „Drogové sítě“.",
                    contactsContactDemandRange = "Nastavte možnosti „Contact / Poptávka / Rozsah hodnot“ v sekci „Drogové sítě“.",
                    contactsContactLossTrust = "Provozní nastavení pro: Síť kontaktů / Contact / Ztráta / Důvěra.",
                    contactsDarknetExactIntelMinutes = "Provozní nastavení pro: Síť kontaktů / Darknet / Přesné informace / Minuty.",
                    contactsDarknetHotspotIntelPrice = "Provozní nastavení pro: Síť kontaktů / Darknet / Aktivní oblast / Informace / Cena.",
                    contactsDarknetIntelPrice = "Provozní nastavení pro: Síť kontaktů / Darknet / Informace / Cena.",
                    contactsDealerBasePrice = "Provozní nastavení pro: Síť kontaktů / Dealer / Základní cena.",
                    contactsDealerHireCapacity = "Nastavte možnosti „Dealer / Najmutí / kapacita“ v sekci „Drogové sítě“.",
                    contactsDealerHireRisk = "Nastavte možnosti „Dealer / Najmutí / Riziko“ v sekci „Drogové sítě“.",
                    contactsDealerHireSkill = "Nastavte možnosti „Dealer / Najmutí / Dovednost“ v sekci „Drogové sítě“.",
                    contactsDealerOffers = "Nastavte možnosti „Nabídky dealerů“ v sekci „Drogové sítě“.",
                    contactsDealerProtectionHours = "Provozní nastavení pro: Síť kontaktů / Dealer / Ochrana / Hodiny.",
                    contactsDealerProtectionPrice = "Provozní nastavení pro: Síť kontaktů / Dealer / Ochrana / Cena.",
                    contactsDealerSaleMax = "Provozní nastavení pro: Síť kontaktů / Dealer / Prodej / Maximum.",
                    contactsDealerSaleMin = "Provozní nastavení pro: Síť kontaktů / Dealer / Prodej / Minimum.",
                    contactsDealerSimulation = "Nastavte možnosti „Dealer / Simulace“ v sekci „Drogové sítě“.",
                    contactsDealerTickMinutes = "Provozní nastavení pro: Síť kontaktů / Dealer / Aktualizační cyklus / Minuty.",
                    contactsDealerWage = "Provozní nastavení pro: Síť kontaktů / Dealer / Mzdové platy.",
                    contactsDealerWageDecay = "Provozní nastavení pro: Síť kontaktů / Dealer / Mzdové platy / Degradace.",
                    contactsDealerWageLoyaltyGain = "Provozní nastavení pro: Síť kontaktů / Dealer / Mzdové platy / Lojalita / zisk.",
                    contactsDealerWeaknesses = "Nastavte možnosti „Dealer / Slabiny“ v sekci „Drogové sítě“.",
                    contactsDefaultContactDemand = "Provozní nastavení pro: Síť kontaktů / Výchozí hodnota / Contact / Poptávka.",
                    contactsDefaultContactRisk = "Provozní nastavení pro: Síť kontaktů / Výchozí hodnota / Contact / Riziko.",
                    contactsDefaultDealerCapacity = "Provozní nastavení pro: Síť kontaktů / Výchozí dealer / kapacita.",
                    contactsDefaultDealerRisk = "Provozní nastavení pro: Síť kontaktů / Výchozí dealer / Riziko.",
                    contactsDefaultDealerSkill = "Provozní nastavení pro: Síť kontaktů / Výchozí dealer / Dovednost.",
                    contactsDefaultHotspotRadius = "Provozní nastavení pro: Síť kontaktů / Výchozí hodnota / Aktivní oblast / Poloměr.",
                    contactsDemandResetMinutes = "Provozní nastavení pro: Síť kontaktů / Reset poptávky (minuty).",
                    contactsEnabled = "Provozní nastavení pro: Síť kontaktů / Aktivováno.",
                    contactsExactLocationTrust = "Provozní nastavení pro: Síť kontaktů / Přesná poloha / Důvěra.",
                    contactsFactionDiscoveryReputation = "Provozní nastavení pro: Síť kontaktů / Frakce / Objevení / Reputace.",
                    contactsFactionHintTrust = "Provozní nastavení pro: Síť kontaktů / Frakce / Nápověda / Důvěra.",
                    contactsFailedDeliveryCooldownMinutes = "Provozní nastavení pro: Síť kontaktů / Neúspěšná dodávka / Minuty prodlevy.",
                    contactsFakeDealEncounter = "Nastavte možnosti „Falešný obchod / Setkání“ v sekci „Drogové sítě“.",
                    contactsFallbackPreferredDrug = "Provozní nastavení pro: Síť kontaktů / Náhradní hodnota / Preferovaná droga.",
                    contactsFallbackProductLabel = "Provozní nastavení pro: Síť kontaktů / Náhradní hodnota / Název produktu.",
                    contactsGuideBookItem = "Provozní nastavení pro: Síť kontaktů / Průvodce / Kniha / Předmět.",
                    contactsGuideBookTrust = "Provozní nastavení pro: Síť kontaktů / Průvodce / Kniha / Důvěra.",
                    contactsHireDealerPrice = "Provozní nastavení pro: Síť kontaktů / Najmout dealera / Cena.",
                    contactsHistoryLimit = "Provozní nastavení pro: Síť kontaktů / Limit historie.",
                    contactsHotspotIntelMinutes = "Provozní nastavení pro: Síť kontaktů / Aktivní oblast / Informace / Minuty.",
                    contactsHotspotRotationMinutes = "Provozní nastavení pro: Síť kontaktů / Aktivní oblast / Střídání / Minuty.",
                    contactsListingDurationMinutes = "Provozní nastavení pro: Síť kontaktů / Nabídka / Doba trvání / Minuty.",
                    contactsMaxOwnedDealers = "Provozní nastavení pro: Síť kontaktů / Maximum / Vlastní / Dealerové.",
                    contactsMinimumBuyerDeliveryDistance = "Provozní nastavení pro: Síť kontaktů / Minimum / Kupec / Vzdálenost doručení.",
                    contactsMinimumContactRotationMinutes = "Provozní nastavení pro: Síť kontaktů / Minimum / Rotace kontaktů (minuty).",
                    contactsMinimumDemandResetMinutes = "Provozní nastavení pro: Síť kontaktů / Minimum / Reset poptávky (minuty).",
                    contactsMinimumHeatMultiplier = "Provozní nastavení pro: Síť kontaktů / Minimum / Policejní tlak / Násobitel.",
                    contactsMinimumHotspotIntelMinutes = "Provozní nastavení pro: Síť kontaktů / Minimum / Aktivní oblast / Informace / Minuty.",
                    contactsMinimumHotspotRadius = "Provozní nastavení pro: Síť kontaktů / Minimum / Aktivní oblast / Poloměr.",
                    contactsMinimumHotspotRotationMinutes = "Provozní nastavení pro: Síť kontaktů / Minimum / Aktivní oblast / Střídání / Minuty.",
                    contactsMinimumListingDurationMinutes = "Provozní nastavení pro: Síť kontaktů / Minimum / Nabídka / Doba trvání / Minuty.",
                    contactsMinimumRewardMultiplier = "Provozní nastavení pro: Síť kontaktů / Minimální odměna / Násobitel.",
                    contactsMinimumRobberyMultiplier = "Provozní nastavení pro: Síť kontaktů / Minimum / Přepadení / Násobitel.",
                    contactsMinimumSpotPriceMultiplier = "Provozní nastavení pro: Síť kontaktů / Minimum / Místo / Násobitel ceny.",
                    contactsOtherDrugPriceMultiplier = "Provozní nastavení pro: Síť kontaktů / Jiný zdroj / Droga / Násobitel ceny.",
                    contactsPaymentAccount = "Provozní nastavení pro: Síť kontaktů / Platební účet.",
                    contactsPostDeliveryDemandResetSeconds = "Provozní nastavení pro: Síť kontaktů / Po dodávce / Poptávka / Reset / sekundů.",
                    contactsPreferredDrugPriceMultiplier = "Provozní nastavení pro: Síť kontaktů / Preferovaná droga / Násobitel ceny.",
                    contactsRegionLocationTrust = "Provozní nastavení pro: Síť kontaktů / Region / Poloha / Důvěra.",
                    contactsRequestAmounts = "Nastavte možnosti „Požadavek / Množství“ v sekci „Drogové sítě“.",
                    contactsRotationMinutes = "Provozní nastavení pro: Síť kontaktů / Střídání / Minuty.",
                    contactsSpotPools = "Nastavte možnosti „Místo / Výběrové skupiny“ v sekci „Drogové sítě“.",
                    contactsStreetHotspots = "Nastavte možnosti „Ulice / Aktivní oblasti“ v sekci „Drogové sítě“.",
                    contactsTrustLevels = "Nastavte možnosti „Důvěra / Úrovně“ v sekci „Drogové sítě“.",
                    businessActionCooldownSeconds = "Provozní nastavení pro: Síť podniků / Cooldown akce / sekundů.",
                    businessBalance = "Nastavte možnosti „Zůstatek“ v sekci „Drogové sítě“.",
                    businessContracts = "Nastavte možnosti „Kontrakty“ v sekci „Drogové sítě“.",
                    businessDefaultBusinessName = "Provozní nastavení pro: Síť podniků / Výchozí hodnota / Název firmy.",
                    businessDefaultRankId = "Provozní nastavení pro: Síť podniků / Výchozí hodnota / Rank / ID.",
                    businessDefaultStaffStyle = "Provozní nastavení pro: Síť podniků / Výchozí hodnota / Staff / Styl práce.",
                    businessDefaultTransport = "Provozní nastavení pro: Síť podniků / Výchozí hodnota / Doprava.",
                    businessEnabled = "Provozní nastavení pro: Síť podniků / Aktivováno.",
                    businessHubs = "Nastavte možnosti „Distribuční centra“ v sekci „Drogové sítě“.",
                    businessLimits = "Nastavte možnosti „Limity“ v sekci „Drogové sítě“.",
                    businessPayments = "Zvolte, který zůstatek platí nákupy v síti podniků a provozní náklady.",
                    businessPayoutAccount = "Provozní nastavení pro: Síť podniků / Výplata / Účet.",
                    businessRanks = "Nastavte možnosti „Hodnosti“ v sekci „Drogové sítě“.",
                    businessReportDays = "Provozní nastavení pro: Síť podniků / Období přehledu / dní.",
                    businessRouteEndpointTypes = "Nastavte možnosti „Trasa / Koncový bod / Typy“ v sekci „Drogové sítě“.",
                    businessRuntime = "Nastavte možnosti „Provoz ve hře“ v sekci „Drogové sítě“.",
                    businessSocietyPermission = "Provozní nastavení pro: Síť podniků / Organizace / Oprávnění.",
                    businessStaff = "Nastavte možnosti „Zaměstnanci“ v sekci „Drogové sítě“.",
                    businessTickMinutes = "Provozní nastavení pro: Síť podniků / Aktualizační cyklus / Minuty.",
                    businessTransports = "Nastavte možnosti „Přepravy“ v sekci „Drogové sítě“.",
                },
                robbery = {
                    atmAvailability = "Aktivujte nebo deaktivujte samostatný systém přepadení bankomatů.",
                    atmLocations = "Spravuje serverem povolené polohy bankomatů dostupné pro přepadení.",
                    atmPolice = "Konfigurujte požadavek na počet policistů v službě pro zahájení přepadení.",
                    atmItems = "Nastavte požadované předměty vrtačky, tažného popruhu a výbušné nálože.",
                    atmActionTimes = "Nastavte trvání akcí připevňování, rozmístění, detonace a loupání.",
                    atmTimeouts = "Určuje, jak dlouho zůstane vyvrácený bankomat dostupný k přepadení.",
                    atmPayout = "Konfigurujte cílový účet a náhodný rozsah odměny.",
                    atmDistances = "Nastavte dosah pro interakce hráčů a vozidel používaný u bankomatů.",
                    atmExplosionEffects = "Konfiguruje nativní parametry výbuchu používané při detonaci.",
                    atmDispatchAlert = "Konfigurujte poloměr, dobu trvání a prioritu policejního varování.",
                    atmDispatchRecipients = "Zvolte názvy prací, které budou dostávat upozornění na přepadení ATM.",
                    shopAvailability = "Povolit přepadení a nakonfigurovat požadavky na policii.",
                    shopTiming = "Konfigurujte zastrašování, akce, časový limit a dobu čekání.",
                    shopSafe = "Konfigurujte pokusy na klávesové položení a předmět vrtáku.",
                    shopRegisterReward = "Konfigurujte náhodnou odměnu pro každou pokladnu.",
                    shopSafeReward = "Konfigurujte náhodnou odměnu ze trezoru.",
                    shopDispatchSettings = "Konfigurujte adresáty a vlastnosti varování.",
                    shopLocationTable = "Spravovat obchodní lokality s obsluhou a trezory.",
                    pickpocketAvailability = "Aktivujte tuto funkci a volitelně ji omezte na nakonfigurované kriminální práce.",
                    pickpocketGameplay = "Zvolte výzvu a nezávislé pravděpodobnosti útěku, volání složek a protiútoku.",
                    pickpocketItemRewards = "Ovládá prázdné kapsy a výběr viditelných předmětů až na 0.0001 procent.",
                    pickpocketMoney = "Konfiguruje serverem generovaný náhodný rozsah hotovosti.",
                    pickpocketDistances = "Nastavte dosah NPC používaný společným radikálním a cílovým systémem.",
                    pickpocketRateLimits = "Ovládá omezení požadavků, vázání na jednoho NPC a vypršení relace.",
                    pickpocketDispatchSettings = "Konfiguruje poploh zaslaný, když NPC zavolá na nouzové složky.",
                    heistCrafting = "Zvolte, kolik interakcí je vyžadováno při výrobě vybavení pro přepadení. Platí pro nové pokusy v celém systému kriminality.",
                    heistCreatorMenu = "Vytvářejte, upravujte a publikujte modulární přepadení v dedikovaném editoru přepadení.",
                    heistExecution = "Okno startu, nečinnost a odstup časový pro průběhy přepadení.",
                    npcPoliceSupport = "Zbrojení důstojníci NPC reagují pěšky na popluhy z přepadení a podporují policii tím, že útočí na přepadené.",
                },
                baseRaids = {
                    baseRaids = "Přístup k raidu, požadavky a individuálně volitelné kategorie kořistí. Otevřené raidy nemají časový limit pro přepravu.",
                },
                weapons = {
                    weaponCreatorMenu = "Spravujte trasy zbraní a praní peněz v jednom editoru.",
                    weaponRuntime = "Nastavte dostupnost tras zbraní a přístup k nim.",
                    weaponDefaultsgeneral = "Nastavte možnosti „Obecné výchozí hodnoty“ v sekci „Trasy zbraní“.",
                    weaponDefaultsaccess = "Nastavte možnosti „Výchozí přístup“ v sekci „Trasy zbraní“.",
                    weaponDefaultscollection = "Nastavte možnosti „Výchozí sběr“ v sekci „Trasy zbraní“.",
                    weaponDefaultsproduction = "Nastavte možnosti „Výchozí výroba“ v sekci „Trasy zbraní“.",
                    weaponDefaultsmarket = "Nastavte možnosti „Výchozí trh“ v sekci „Trasy zbraní“.",
                    weaponDefaultsdelivery = "Nastavte možnosti „Výchozí zakázky“ v sekci „Trasy zbraní“.",
                    weaponStreet = "Nastavte možnosti „Pouliční prodej zbraní“ v sekci „Trasy zbraní“.",
                },
                darknetMarket = {
                    darknetAvailability = "Ovládá aplikaci v tabletu a její umístění.",
                    darknetEconomy = "Konfiguruje zůstatky v peněženkách, výměnu mincí a míry plateb.",
                    darknetListings = "Ovládá limity nabídek, ceny a automatické vypršení.",
                    darknetChat = "Omezuje šifrované zprávy na tržišti.",
                    darknetIdentity = "Konfiguruje rotaci identity, ověřování a varování před podvody.",
                    darknetDelivery = "Konfiguruje osobní schůzky a kraditelné světské bedny.",
                    darknetDeliveryLocations = "Konfiguruje seznam míst náhodně přiřazených k obchodům BlackBay NPC.",
                    darknetPolice = "Skupiny prací povolené k publikování pastí a prohlížení vyšetřování.",
                    darknetNpcTraders = "Trvalí kupující a prodávající NPC s konfigurovatelným rizikem.",
                },
                interrogation = {
                    general = "Nastavte možnosti „Obecné“ v sekci „Výslech“.",
                    consent = "Nastavte možnosti „Ochrana hráčů“ v sekci „Výslech“.",
                    objects = "Nastavte možnosti „Objekty“ v sekci „Výslech“.",
                    grab = "Nastavte možnosti „Převzímání“ v sekci „Výslech“.",
                    session = "Nastavte možnosti „Výslech“ v sekci „Výslech“.",
                    dispatch = "Nastavte možnosti „Policijní poplachy“ v sekci „Výslech“.",
                    logging = "Nastavte možnosti „Záznamy“ v sekci „Výslech“.",
                    security = "Nastavte možnosti „Zabezpečení“ v sekci „Výslech“.",
                    presentation = "Nastavte možnosti „Prezentace“ v sekci „Výslech“.",
                },
                reputation = {
                    crimeReputation = "Nastavte možnosti „Reputace“ v sekci „Reputace“.",
                },
            },
            settingGroups = {
                weaponRuntime = { label = "Obecné", description = "Nastavte dostupnost tras zbraní a přístup k nim." },
                weaponCreatorMenu = { label = "Nelegální obchodní tvůrce", description = "Spravujte trasy zbraní a praní peněz v jednom editoru." },
                atmActionTimes = {
                    description = "Nastavte trvání akcí připevňování, rozmístění, detonace a loupání.",
                    label = "Doba trvání akcí",
                },
                atmAvailability = {
                    description = "Aktivujte nebo deaktivujte samostatný systém přepadení bankomatů.",
                    label = "Dostupnost",
                },
                atmDispatchAlert = {
                    description = "Konfigurujte poloměr, dobu trvání a prioritu policejního varování.",
                    label = "Vlastnosti varování",
                },
                atmDispatchRecipients = {
                    description = "Zvolte názvy prací, které budou dostávat upozornění na přepadení ATM.",
                    label = "Adresáti",
                },
                atmDistances = {
                    description = "Nastavte dosah pro interakce hráčů a vozidel používaný u bankomatů.",
                    label = "Vzdálenosti interakce",
                },
                atmExplosionEffects = {
                    description = "Konfiguruje nativní parametry výbuchu používané při detonaci.",
                    label = "Efekty výbuchů",
                },
                atmItems = {
                    description = "Nastavte požadované předměty vrtačky, tažného popruhu a výbušné nálože.",
                    label = "Vyžadované předměty",
                },
                atmLocations = {
                    description = "Spravuje serverem povolené polohy bankomatů dostupné pro přepadení.",
                    label = "Lokality bankomatů",
                },
                atmPayout = {
                    description = "Konfigurujte cílový účet a náhodný rozsah odměny.",
                    label = "Výplata",
                },
                atmPolice = {
                    description = "Konfigurujte požadavek na počet policistů v službě pro zahájení přepadení.",
                    label = "Požadavek na policii",
                },
                atmPulling = {
                    description = "Konfigurujte pohyb vyžadovaný k vytržení bankomatu ze zdi.",
                    label = "Detekce vytržení",
                },
                atmTimeouts = {
                    description = "Určuje, jak dlouho zůstane vyvrácený bankomat dostupný k přepadení.",
                    label = "Časový limit lupu",
                },
                baseRaids = {
                    description = "Přístup k raidu, požadavky a individuálně volitelné kategorie kořistí. Otevřené raidy nemají časový limit pro přepravu.",
                    label = "Raidy na základny",
                },
                businessPayments = {
                    description = "Zvolte, který zůstatek platí nákupy v síti podniků a provozní náklady.",
                    label = "Platby",
                },
                crimeMembership = {
                    description = "Zvolte, jakým způsobem kriminální organizace ukládají a spravují své členy.",
                    label = "Model členství",
                },
                darknetAvailability = {
                    description = "Ovládá aplikaci v tabletu a její umístění.",
                    label = "Dostupnost",
                },
                darknetChat = {
                    description = "Omezuje šifrované zprávy na tržišti.",
                    label = "Soukromý chat",
                },
                darknetDelivery = {
                    description = "Konfiguruje osobní schůzky a kraditelné světské bedny.",
                    label = "Předání a dead dropy",
                },
                darknetDeliveryLocations = {
                    description = "Konfiguruje seznam míst náhodně přiřazených k obchodům BlackBay NPC.",
                    label = "Místa předání",
                },
                darknetEconomy = {
                    description = "Konfiguruje zůstatky v peněženkách, výměnu mincí a míry plateb.",
                    label = "Kryptoměna",
                },
                darknetIdentity = {
                    description = "Konfiguruje rotaci identity, ověřování a varování před podvody.",
                    label = "Aliasy a reputace",
                },
                darknetListings = {
                    description = "Ovládá limity nabídek, ceny a automatické vypršení.",
                    label = "Nabídky a expirace",
                },
                darknetNpcTraders = {
                    description = "Trvalí kupující a prodávající NPC s konfigurovatelným rizikem.",
                    label = "NPC obchodníci",
                },
                darknetPolice = {
                    description = "Skupiny prací povolené k publikování pastí a prohlížení vyšetřování.",
                    label = "Přístup policie",
                },
                heistCrafting = {
                    description = "Zvolte, kolik interakcí je vyžadováno při výrobě vybavení pro přepadení. Platí pro nové pokusy v celém systému kriminality.",
                    label = "Dílna pro heisty",
                },
                heistCreatorMenu = {
                    description = "Vytvářejte, upravujte a publikujte modulární přepadení v dedikovaném editoru přepadení.",
                    label = "Menu tvůrce",
                },
                heistExecution = {
                    description = "Okno startu, nečinnost a odstup časový pro průběhy přepadení.",
                    label = "Časování přepadení",
                },
                moneywashEconomy = {
                    description = "Aktivovat podniky a nakonfigurovat účet pro vklady, servisní poplatky a vzdálenosti interakce.",
                    label = "Obecné",
                },
                npcPoliceSupport = {
                    description = "Zbrojení důstojníci NPC reagují pěšky na popluhy z přepadení a podporují policii tím, že útočí na přepadené.",
                    label = "Podpora policie NPC",
                },
                pickpocketAvailability = {
                    description = "Aktivujte tuto funkci a volitelně ji omezte na nakonfigurované kriminální práce.",
                    label = "Dostupnost",
                },
                pickpocketDispatchSettings = {
                    description = "Konfiguruje poploh zaslaný, když NPC zavolá na nouzové složky.",
                    label = "Nouzové výjezdy",
                },
                pickpocketDistances = {
                    description = "Nastavte dosah NPC používaný společným radikálním a cílovým systémem.",
                    label = "Vzdálenosti interakce",
                },
                pickpocketGameplay = {
                    description = "Zvolte výzvu a nezávislé pravděpodobnosti útěku, volání složek a protiútoku.",
                    label = "Riziko a minihra",
                },
                pickpocketItemRewards = {
                    description = "Ovládá prázdné kapsy a výběr viditelných předmětů až na 0.0001 procent.",
                    label = "Viditelný obsah kapes",
                },
                pickpocketMoney = {
                    description = "Konfiguruje serverem generovaný náhodný rozsah hotovosti.",
                    label = "Hotovostní odměna",
                },
                pickpocketRateLimits = {
                    description = "Ovládá omezení požadavků, vázání na jednoho NPC a vypršení relace.",
                    label = "Zabezpečení serveru",
                },
                pvpArenas = {
                    description = "Vytvoří kruhovou zónu, pozorovací bod a body spawnu týmů používané v PvP akcích.",
                    label = "Arény a zóny boje",
                },
                pvpAutomation = {
                    description = "Konfiguruje opakované události a automatické zpracování spuštění.",
                    label = "Automatizace",
                },
                pvpAvailability = {
                    description = "Ovládá, zda je aplikace pro PvP události dostupná a kde se zobrazuje.",
                    label = "Dostupnost",
                },
                pvpLimits = {
                    description = "Nastavte limity odměn a historie na tabletu.",
                    label = "Limity a historie",
                },
                pvpModes = {
                    description = "Konfigurujte režim hry předvolený v PvP tabletu.",
                    label = "Režimy hry",
                },
                pvpPermissions = {
                    description = "Přiřadí správu událostí a finance k ACE a povolením prací.",
                    label = "Oprávnění",
                },
                pvpRuntime = {
                    description = "Upravte zpracování požadavků, úmrtí a respawny během probíhajících zápasů.",
                    label = "Doba trvání události",
                },
                pvpTakeoverMethods = {
                    description = "Konfigurujte, jak dlouho trvá každá metoda vlámování do vstupu.",
                    label = "Metody vlámování",
                },
                pvpTakeoverRules = {
                    description = "Ovládá dostupnost a požadavky na účast při převzetí laboratoří a kempů.",
                    label = "Pravidla převzetí",
                },
                pvpTakeoverZones = {
                    description = "Nastavte oblasti interakce, poplachu a obsazování společně s jejich dobou trvání.",
                    label = "Zóny a časování",
                },
                shopAvailability = {
                    description = "Povolit přepadení a nakonfigurovat požadavky na policii.",
                    label = "Dostupnost",
                },
                shopDispatchSettings = {
                    description = "Konfigurujte adresáty a vlastnosti varování.",
                    label = "Varování policii",
                },
                shopLocationTable = {
                    description = "Spravovat obchodní lokality s obsluhou a trezory.",
                    label = "Lokality obchodů",
                },
                shopRegisterReward = {
                    description = "Konfigurujte náhodnou odměnu pro každou pokladnu.",
                    label = "Odměna pokladny",
                },
                shopRegisterTable = {
                    description = "Přiřaďte jednotlivé pokladny obchodům.",
                    label = "Pokladny",
                },
                shopSafe = {
                    description = "Konfigurujte pokusy na klávesové položení a předmět vrtáku.",
                    label = "Trezor",
                },
                shopSafeReward = {
                    description = "Konfigurujte náhodnou odměnu ze trezoru.",
                    label = "Odměna ze trezoru",
                },
                shopTiming = {
                    description = "Konfigurujte zastrašování, akce, časový limit a dobu čekání.",
                    label = "Časování",
                },
            },
            settingSections = {
                weapons = "Trasy zbraní",
                drugs = "Drogový systém",
                drugProduction = "Výroba drog",
                drugOperations = "Drogové provozy",
                drugMarketRisk = "Trh a rizika",
                drugNetworks = "Drogové sítě",
                atmRobbery = "Přepadení bankomatu",
                baseRaids = "Raidy na základny",
                crimeOrganizations = "Organizace",
                darknetMarket = "Darknetový trh",
                moneywash = "Praní peněz",
                pvpEvents = "Frakční PvP",
                robbery = "Přepadení",
                territories = "Teritoria",
                graffiti = "Graffiti",
                interrogation = "Výslech",
            },
            settingSubsections = {
                baseRaidEquipment = "Potřebné vybavení",
                baseRaidBreach = "Vniknutí",
                baseRaidLoot = "Kořist a vozidla",
                graffitiLimits = "Limity a moderování",
                interrogationTechnical = "Záznamy a zabezpečení",
                atmDispatch = "Policejní výjezd",
                atmEquipment = "Vybavení",
                atmExplosion = "Výbuch",
                atmOverview = "Přehled a lokality",
                atmRewards = "Odměny",
                atmTiming = "Časování",
                atmVehicle = "Vozidlo a tažení",
                baseRaids = "Raidy na základny",
                crimeMembership = "Členství",
                heistCreator = "Vytvářed robíčeků",
                npcPoliceSupport = "Podpora policie NPC",
                pickpocket = "Kapesnictví NPC",
                pvpArenas = "Arény",
                pvpEquipment = "Režimy hry",
                pvpOverview = "Přehled",
                pvpRuntime = "Doba trvání události",
                pvpTakeovers = "Převzemy laboratoří",
                shopRobbery = "Loupežnosti v obchodech",
                atmRobbery = "Přepadení bankomatu",
            },
            settings = {
                weaponDefaultGeneralInteractionDistance = { label = "Vzdálenost interakce" },
                weaponDefaultGeneralPedModel = { label = "Výchozí model NPC" },
                weaponDefaultAccessActiveHourStart = { label = "Otevírací hodina (UTC)" },
                weaponDefaultAccessActiveHourEnd = { label = "Zavírací hodina (UTC)" },
                weaponDefaultAccessPoliceRequired = { label = "Požadovaní policisté ve službě" },
                weaponDefaultAccessPoliceJobs = { label = "Policejní povolání" },
                weaponDefaultCollectionDurationSeconds = { label = "Doba v sekundách" },
                weaponDefaultCollectionCooldownSeconds = { label = "Prodleva v sekundách" },
                weaponDefaultCollectionCooldownScope = { label = "Rozsah prodlevy" },
                weaponDefaultCollectionUseMinigame = { label = "Použít minihru" },
                weaponDefaultCollectionMinigame = { label = "Minihra" },
                weaponDefaultCollectionMinigameRounds = { label = "Počet kol minihry" },
                weaponDefaultProductionDurationSeconds = { label = "Doba v sekundách" },
                weaponDefaultProductionSuccessChance = { label = "Šance na úspěch (%)" },
                weaponDefaultProductionFailureConsumesInputs = { label = "Spotřebovat suroviny při neúspěchu" },
                weaponDefaultProductionUseMinigame = { label = "Použít minihru" },
                weaponDefaultProductionMinigame = { label = "Minihra" },
                weaponDefaultProductionMinigameRounds = { label = "Počet kol minihry" },
                weaponDefaultProductionQualityMin = { label = "Minimální kvalita" },
                weaponDefaultProductionQualityMax = { label = "Maximální kvalita" },
                weaponDefaultProductionCooldownSeconds = { label = "Prodleva v sekundách" },
                weaponDefaultProductionCooldownScope = { label = "Rozsah prodlevy" },
                weaponDefaultMarketPayoutAccount = { label = "Účet pro výplatu" },
                weaponDefaultMarketPriceMultiplierMin = { label = "Minimální cenový faktor (%)" },
                weaponDefaultMarketPriceMultiplierMax = { label = "Maximální cenový faktor (%)" },
                weaponDefaultMarketRestockSeconds = { label = "Interval doplnění v sekundách" },
                weaponDefaultMarketCooldownSeconds = { label = "Prodleva v sekundách" },
                weaponDefaultMarketCooldownScope = { label = "Rozsah prodlevy" },
                weaponDefaultDeliveryContractDurationMinutes = { label = "Lhůta zakázky v minutách" },
                weaponDefaultDeliveryContractBonusPercent = { label = "Bonus zakázky (%)" },
                weaponStreetEnabled = { label = "Vzácné prodeje zbraní pouličním kupcům" },
                weaponStreetChance = { label = "Šance na nabídku zbraně (%)" },
                weaponStreetCooldown = { label = "Prodleva v sekundách" },
                weaponStreetAmount = { label = "Maximální množství" },
                weaponStreetPriceMin = { label = "Minimální cenový faktor (%)" },
                weaponStreetPriceMax = { label = "Maximální cenový faktor (%)" },
                weaponStreetAccount = { label = "Účet pro výplatu" },
                weaponStreetDirect = { label = "Přímý prodej" },
                weaponStreetBulk = { label = "Hromadný prodej" },
                weaponStreetContract = { label = "Kartelová zakázka" },
                weaponSystemEnabled = { label = "Systém tras zbraní", description = "Zapněte sběr, zpracování a prodej zbraní kartelům." },
                weaponRuntimeEnabled = { label = "Akce tras zbraní", description = "Povolte používání nastavených tras zbraní v herním světě." },
                weaponCreatorAccess = { label = "Přístup k editoru zbraní", description = "Vyberte, kdo smí otevřít editor zbraní.", options = { permission = "Pouze s oprávněním", jobManagement = "Správa povolání", ownerOnly = "Pouze vlastník" } },
                openWeaponCreator = { label = "Nelegální obchodní tvůrce", description = "Spravujte trasy zbraní a praní peněz v jednom editoru.", buttonLabel = "Nelegální obchodní tvůrce", unsavedTooltip = "Nejprve uložit" },

                drugCultivationProgressionEnabled = { label = "Povolit úrovně pěstování", description = "Povolí XP pěstování, úrovně a odemykání podle úrovně." },
                drugCultivationMaxLevel = { label = "Maximální úroveň pěstování", description = "Nejvyšší dosažitelná úroveň pěstování. Vyšší úrovně zůstanou nedostupné." },
                drugCultivationLevels = { label = "Křivka úrovní", description = "Nastavte název a celkový práh XP pro každou úroveň pěstování." },
                drugCultivationActionXp = { label = "Odměny XP", description = "Nastavte množství XP pěstování za jednotlivé akce." },
                drugCultivationUnlocks = { label = "Odemykání úrovní", description = "Nastavte požadované úrovně pro nádoby, substráty, vybavení, odrůdy a úrovně skeneru." },
                reputationRewards = { label = "Akce reputace", description = "Přidávejte akce, měňte body a vypínejte nebo mažte záznamy. Body udělují pouze aktivní záznamy." },
                reputationEnabled = { label = "Zapnout kriminální reputaci", description = "Přidělovat osobní reputaci." },
                reputationPointsPerLevel = { label = "Body za úroveň", description = "Každá úroveň vyžaduje tento počet dalších bodů." },
                reputationMinimumJoinPoints = { label = "Minimální reputace pro vstup", description = "Celkový počet bodů potřebný pro vstup do kriminální frakce. 0 požadavek vypne. Stávající členové si zachovají přístup." },
                reputation_atm = { label = "Loupež bankomatu", description = "Body za úspěšné dokončení akce. 0 tuto odměnu vypne." },
                reputation_shop_register = { label = "Pokladna obchodu", description = "Body za úspěšné dokončení akce. 0 tuto odměnu vypne." },
                reputation_shop_safe = { label = "Trezor obchodu", description = "Body za úspěšné dokončení akce. 0 tuto odměnu vypne." },
                reputation_pickpocket = { label = "Kapesní krádež", description = "Body za úspěšné dokončení akce. 0 tuto odměnu vypne." },
                reputation_heist = { label = "Dokončení loupeže", description = "Body za úspěšné dokončení akce. 0 tuto odměnu vypne." },
                reputation_drug_harvest = { label = "Sklizeň drog", description = "Body za úspěšné dokončení akce. 0 tuto odměnu vypne." },
                reputation_drug_processing = { label = "Zpracování drog", description = "Body za úspěšné dokončení akce. 0 tuto odměnu vypne." },
                reputation_drug_sale = { label = "Prodej drog", description = "Body za úspěšné dokončení akce. 0 tuto odměnu vypne." },
                reputation_drug_delivery = { label = "Doručení drog", description = "Body za úspěšné dokončení akce. 0 tuto odměnu vypne." },
                reputation_drug_contract = { label = "Distribuční smlouva", description = "Body za úspěšné dokončení akce. 0 tuto odměnu vypne." },
                reputation_drug_raid = { label = "Drogový přepad", description = "Body za úspěšné dokončení akce. 0 tuto odměnu vypne." },
                reputation_graffiti = { label = "Graffiti", description = "Body za úspěšné dokončení akce. 0 tuto odměnu vypne." },
                reputation_moneywash = { label = "Praní peněz", description = "Body za úspěšné dokončení akce. 0 tuto odměnu vypne." },
                reputation_base_raid = { label = "Přepad základny", description = "Body za úspěšné dokončení akce. 0 tuto odměnu vypne." },
                reputation_pvp_win = { label = "Vítězství PvP", description = "Body za úspěšné dokončení akce. 0 tuto odměnu vypne." },
                atmChargeProp = {
                    description = "Model objektu zobrazený u ATM během instalace výbušné nálože.",
                    label = "Nálož",
                },
                atmConsumeDrill = {
                    description = "Spotřebuje nastavený počet po každém úspěšně dokončeném bodu vrtání bankomatu.",
                    label = "Spotřebovat vrtačku",
                },
                atmDrillItem = {
                    description = "ID předmětu v inventáři potřebného k odvrtání vytrženého bankomatu. Nastavuje se odděleně od vrtačky na trezory obchodů.",
                    label = "Předmět vrtačky",
                },
                atmDrillItemAmount = {
                    description = "Počet předmětů vrtačky potřebných pro každý bod vrtání bankomatu.",
                    label = "Požadovaný počet vrtaček",
                },
                atmDebug = {
                    description = "Zapisuje podrobné diagnostické údaje o přepadení ATM do serverové konzole a do klientové konzole F8.",
                    label = "Debug logy ATM",
                },
                atmDispatchDurationSeconds = {
                    description = "Počet sekund, po dobu kterých je poplach ATM relevantní pro příjemce výjezdů.",
                    label = "Doba výjezdů",
                },
                atmDispatchEnabled = {
                    description = "Vytvoří incident typu Jobs Base, pokud dojde k násilnému vniknutí do ATM.",
                    label = "Povolit policejní dispečink",
                },
                atmDispatchJobs = {
                    description = "Názvy pracovních rolí oddělené čárkou, které obdrží poplach ATM.",
                    label = "Pracovní role výjce",
                },
                atmDispatchPriority = {
                    description = "Hodnota priority předaná bez změny do integrace výjce.",
                    label = "Priorita výjce",
                },
                atmDispatchRadius = {
                    description = "Přibližný radius poplachu zasílaný do integrace dispečera.",
                    label = "Radius dispečera",
                },
                atmEnabled = {
                    description = "Zpřístupní nakonfigurované bankomaty pro přepadení pomocí lana nebo výbušnin.",
                    label = "Aktivovat přepadení bankomatů",
                },
                atmExplosionCameraShake = {
                    description = "Intenzita zátrhu kamerou pro klienta, který výbuch způsobí.",
                    label = "Zátrh kamerou při výbuchu",
                },
                atmExplosionDamageScale = {
                    description = "Síla poškození a impulsu předaná nativní funkci výbuchu.",
                    label = "Množitel poškození výbuchem",
                },
                atmExplosionType = {
                    description = "Typ výbuchu GTA použitý při detonaci. Zachovejte výchozí, pokud jste nenavrhli jiný typ.",
                    label = "Typ výbuchu",
                },
                atmDrillDurationSeconds = {
                    label = "Minimální doba vrtání na šroub (s)",
                    description = "Minimální doba v sekundách pro každý ze čtyř šroubů. Přestávky na chlazení pokus prodlužují. Platí pro nově zahájené pokusy o vrtání.",
                },
                atmExplosiveDurationSeconds = {
                    description = "Počet sekund potřebných k instalaci výbušné nálože.",
                    label = "Doba instalace nálože",
                },
                atmExplosiveItem = {
                    description = "Inventární předmět spotřebovaný po umístění nálože.",
                    label = "Výbušný předmět",
                },
                atmExplosiveItemAmount = {
                    description = "Počet spotřebovaných výbušných předmětů pro jednu umístěnou nálož.",
                    label = "Počet spotřebovaných výbušnin",
                },
                atmFuseSeconds = {
                    description = "Počet sekund mezi umístěním a detonací.",
                    label = "Doba zápalu",
                },
                atmInteractionDistance = {
                    description = "Maximální dosah interakce klienta; serverová validace přidává bezpečnostní rezervu.",
                    label = "Interakční vzdálenost",
                },
                atmLocations = {
                    description = "Oficiální produkční ATM. Lokality vytvořené pomocí /atmtest zůstávají dočasné.",
                    itemLabel = "Lokalita ATM",
                    label = "Lokality bankomatů",
                },
                atmLootDurationSeconds = {
                    description = "Počet sekund potřebných k otevření prolomeného bankomatu.",
                    label = "Doba lootování",
                },
                atmLootReservationTimeoutSeconds = {
                    description = "Maximální počet sekund, po dobu kterých si hráč může bankomat rezervovat při jeho otevírání; automaticky udržováno nad délkou lupu.",
                    label = "Časový limit rezervace lupu",
                },
                atmLootWindowMinutes = {
                    description = "Počet minut, po dobu kterých zůstává nabourkaný bankomat dostupný pro lupu, než je vyčerpán.",
                    label = "Doba lupu",
                },
                atmMinimumPolice = {
                    description = "Počet členů nastavené policejní skupiny, kteří musí být ve službě, aby mohlo dojít k přepadamu.",
                    label = "Minimální počet policie",
                },
                atmPoliceGroup = {
                    description = "sky_jobs_base skupina prací se počítá pro policejské požadavky.",
                    label = "Skupina policejních rolí",
                },
                atmPullDistance = {
                    description = "Vzdálenost vozidla od bankomatu vyžadovaná k dokončení násileného otevření.",
                    label = "Požadovaná vzdálenost tažení",
                },
                atmPullMinimumSpeed = {
                    description = "Minimální rychlost vozidla v metrech za sekundu při dosažení vzdálenosti tažení.",
                    label = "Minimální rychlost tažení",
                },
                atmReservationTimeoutSeconds = {
                    description = "Maximální počet sekund rezervovaných, zatímco hráč připevňuje svěsák nebo nálož; automaticky udržováno nad délkou akce.",
                    label = "Časový limit rezervace přípravy",
                },
                atmRewardAccount = {
                    description = "Zvolte hotovost nebo předmět black_money.",
                    label = "Typ výplaty z bankomatu",
                },
                atmRewardMaximum = {
                    description = "Nejvyšší hotovostní výplata z jednoho bankomatu; nikdy ne nižší než minimum.",
                    label = "Maximální odměna",
                },
                atmRewardMinimum = {
                    description = "Nejnižší hotovostní výplata z jednoho bankomatu.",
                    label = "Minimální odměna",
                },
                atmSlingDurationSeconds = {
                    description = "Počet sekund potřebných k nasazení závitku.",
                    label = "Doba nasazení závitku",
                },
                atmSlingItem = {
                    description = "Opakný inventární předmět vyžadovaný pro metodu s vozidlem.",
                    label = "Předmět Sling",
                },
                atmSlingItemAmount = {
                    description = "Počet závitků, které musí být přítomny. Nejsou spotřebovávány.",
                    label = "Požadované množství závitků",
                },
                atmTestScanDistance = {
                    description = "Maximální vzdálenost, kterou používá /atmtest při hledání podporovaného objektu ATM.",
                    label = "Vzdálenost skenu testu ATM",
                },
                atmVehicleMaxDistance = {
                    description = "Maximální vzdálenost mezi bankomatem a způsobilým vozidlem při připevňování lana.",
                    label = "Vzdálenost pro připevnění vozidla",
                },
                baseRaid_breachTimeoutSeconds = {
                    description = "Časový limit každého pokusu o vypáčení skladu (sekundy).",
                    label = "Časový limit průniku (sekundy)",
                },
                baseRaid_command = {
                    description = "Název příkazu bez lomítka. Po změně restartujte crime resource.",
                    label = "Příkaz pro nájezd",
                },
                baseRaid_crimeItem = {
                    description = "Předmět pro průraz gangu.",
                    label = "Předmět pro průraz gangu",
                },
                baseRaid_crimeVehicles = {
                    description = "Přístup k vozidlům gangu.",
                    label = "Přístup k vozidlům gangu",
                },
                baseRaid_difficulty = {
                    description = "Obtížnost skillchecku.",
                    label = "Obtížnost skillchecku",
                    options = {
                        easy = "Snadná",
                        expert = "Odborník",
                        hard = "Tvrdé",
                        normal = "Normálně",
                    },
                },
                baseRaid_enabled = {
                    description = "Povolit nájezdy na základny.",
                    label = "Povolit nájezdy na základny",
                },
                baseRaid_failedCooldownMinutes = {
                    description = "Čekací doba po razii bez otevření jediného skladu (minuty).",
                    label = "Zábrana po neúspěchu (minuty)",
                },
                baseRaid_interactionDistance = {
                    description = "Vzdálenost pro interakci se skladem.",
                    label = "Vzdálenost pro interakci se skladem",
                },
                baseRaid_lootHeistStorage = {
                    description = "Umožnit úplné vyprázdnění této kategorie inventáře během probíhajícího nájezdu.",
                    label = "Sklad pro kořist z nájezdu",
                },
                baseRaid_lootLaboratories = {
                    description = "Umožnit úplné vyprázdnění této kategorie inventáře během probíhajícího nájezdu.",
                    label = "Úloži laboratorního kořistu",
                },
                baseRaid_lootPersonalLockers = {
                    description = "Umožnit úplné vyprázdnění této kategorie inventáře během probíhajícího nájezdu.",
                    label = "Plenit osobní skříňky",
                },
                baseRaid_lootStorage = {
                    description = "Umožnit úplné vyprázdnění této kategorie inventáře během probíhajícího nájezdu.",
                    label = "Úloži kořisti",
                },
                baseRaid_lootVehicleGloveboxes = {
                    description = "Umožnit úplné vyprázdnění této kategorie inventáře během probíhajícího nájezdu.",
                    label = "Plenit schránky v přihrádkách",
                },
                baseRaid_lootVehicleTrunks = {
                    description = "Umožnit úplné vyprázdnění této kategorie inventáře během probíhajícího nájezdu.",
                    label = "Plenit kufry vozidel",
                },
                baseRaid_minimumDefenders = {
                    description = "Minimální počet online obránců.",
                    label = "Minimální počet online obránců",
                },
                baseRaid_policeItem = {
                    description = "Předmět pro policejní průnik.",
                    label = "Předmět pro policejní průnik",
                },
                baseRaid_policeRequireDuty = {
                    description = "Policie musí být v službě.",
                    label = "Policie musí být v službě",
                },
                baseRaid_policeVehicles = {
                    description = "Přístup policejních vozidel.",
                    label = "Přístup policejních vozidel",
                },
                baseRaid_protectionHours = {
                    description = "Ochrana po úspěchu (hodiny).",
                    label = "Ochrana po úspěchu (hodiny)",
                },
                baseRaid_requiredHits = {
                    description = "Počet vyžadovaných zásahů skillchecku.",
                    label = "Počet vyžadovaných zásahů skillchecku",
                },
                baseRaid_warrantItem = {
                    description = "Jeden z těchto předmětů se spotřebuje při každém platném zahájení policejního nájezdu.",
                    label = "Předmět vyšetřovacího příkazu",
                },
                crimeMembershipMode = {
                    description = "Režim Framework zachovává stávající pracovní roli nebo nativní integraci gangu. Režim nezávislý provozuje kriminální organizaci na pozadí vedle běžné práce hráče a automaticky převádí stávající členství.",
                    label = "Model členství v organizaci",
                    options = {
                        framework = "Framework práce / gang",
                        independent = "Nezávislá organizace",
                    },
                },
                darknetAliasChangeCooldownHours = {
                    description = "Minimální věk identity předtím, než může být znovu ukončena.",
                    label = "Doba čekání na změnu aliasu (hodiny)",
                },
                darknetCurrencyCode = {
                    description = "Krátký název pro interní kryptoměnový účet.",
                    label = "Kód měny",
                },
                darknetDeadDropInteractionDistance = {
                    description = "Vzdálenost vyžadovaná k prohledání a vyzvednutí krabice.",
                    label = "Vzdálenost interakce s dead-dropem",
                },
                darknetDeadDropLifetimeHours = {
                    description = "Čas, po kterém nevyzvedená krabice vyprší.",
                    label = "Doba trvání dead-dropu (hodiny)",
                },
                darknetDeadDropModel = {
                    description = "Model GTA objektu spawlovaný lokálně pro dostupné dead-dropy.",
                    label = "Model krabice pro dead-drop",
                },
                darknetDeadDropPollIntervalMs = {
                    description = "Interval používaný k obnovení blízkých krabic a setkání s NPC.",
                    label = "Interval obnovy světa (ms)",
                },
                darknetDeadDropStreamDistance = {
                    description = "Vzdálenost, při které se streamují krabice a kontakty pro setkání s NPC.",
                    label = "Vzdálenost streamování dead-dropu",
                },
                darknetDropLocations = {
                    description = "Místa náhodně přiřazená pro dead-dropové obchody s NPC. Nastavte alespoň dvě.",
                    itemLabel = "Místo dead-dropu",
                    label = "Místa dead-dropů",
                },
                darknetEnabled = {
                    description = "Aktivuje aplikaci černobazarového tabletu a její běh.",
                    label = "Aktivovat Darknetový trh",
                },
                darknetExchangeBuyPrice = {
                    description = "Částka strávená z platebního účtu za jednu minci.",
                    label = "Kupní cena za minci",
                },
                darknetExchangeEnabled = {
                    description = "Umožňuje autentifikovaným uživatelům BlackBay kupovat a prodávat mince na jejich stránce účtu.",
                    label = "Aktivovat výměnu mincí",
                },
                darknetExchangeMaximumAmount = {
                    description = "Největší celé množství mincí přijímané při jedné výměně.",
                    label = "Maximální počet mincí na výměnu",
                },
                darknetExchangeMinimumAmount = {
                    description = "Nejmenší celé množství mincí přijímané při jedné výměně.",
                    label = "Minimální počet mincí na výměnu",
                },
                darknetExchangePaymentAccount = {
                    description = "Frameworkový účet používaný pro nákupy mincí a výplaty z prodeje mincí.",
                    label = "Platební účet pro výměnu",
                    options = {
                        bank = "Banka",
                        black_money = "Špinavé peníze",
                        money = "Hotovost",
                    },
                },
                darknetExchangeSellPrice = {
                    description = "Částka vyplacená na platební účet za jednu minci.",
                    label = "Prodejní cena za minci",
                },
                darknetFaceToFaceDistance = {
                    description = "Maximální vzdálenost mezi oběma hráči nebo mezi hráčem a konfigurovaným bodem NPC.",
                    label = "Vzdálenost předání",
                },
                darknetKnownScammerReports = {
                    description = "Počet unikátních hlášení o obchodu vyžadovaný pro odznám známého podvodníka.",
                    label = "Hlášení pro varování před podvodníkem",
                },
                darknetListingExpiryHours = {
                    description = "Aktivní nabídky vyprší samy po tomto počtu hodin.",
                    label = "Doba trvání nabídky (hodiny)",
                },
                darknetMaximumListingQuantity = {
                    description = "Horní limit množství pro jednu nabídku.",
                    label = "Maximální množství zboží",
                },
                darknetMaximumListings = {
                    description = "Maximální počet nabídek na jeden aktivní alias.",
                    label = "Maximální počet aktivních nabídek",
                },
                darknetMaximumMessageLength = {
                    description = "Maximální počet znaků v šifrované chatovací zprávě.",
                    label = "Maximální délka zprávy",
                },
                darknetMaximumUnitPrice = {
                    description = "Horní cena v kryptoměnách za jednu jednotku.",
                    label = "Maximální jednotková cena",
                },
                darknetMeetingLocations = {
                    description = "Místa náhodně přiřazená pro osobní obchody s NPC. Nastavte alespoň dvě.",
                    itemLabel = "Místo setkání",
                    label = "Místa setkání",
                },
                darknetNpcBuyerAliases = {
                    description = "Fiktivní jména náhodně přiřazená novým nákupním poptávkám NPC. Nastavte alespoň dva unikátní aliasy.",
                    label = "Aliasy kupujících NPC",
                },
                darknetNpcMaximumBuyListings = {
                    description = "Horní limit používaný při náhodném výběru počtu aktivních nákupních požadavků NPC.",
                    label = "Maximální počet nákupních požadavků NPC",
                },
                darknetNpcMaximumSellListings = {
                    description = "Horní limit používaný při náhodném výběru počtu aktivních nabídek prodejů NPC.",
                    label = "Maximální počet nabídek prodejů NPC",
                },
                darknetNpcMinimumBuyListings = {
                    description = "Při doplnění trhu NPC zůstane aktivních minimálně tolik náhodně vybraných nákupních poptávek.",
                    label = "Minimální počet nákupních poptávek NPC",
                },
                darknetNpcMinimumSellListings = {
                    description = "Při doplnění trhu NPC zůstane aktivních alespoň tolik náhodně vybraných nabídek prodejů.",
                    label = "Minimální nabídky prodejů NPC",
                },
                darknetNpcSellerAliases = {
                    description = "Fiktivní jména náhodně přidělená novým nabídkám prodejů NPC. Nastavte alespoň dva unikátní aliasy.",
                    label = "Aliasy prodejů NPC",
                },
                darknetNpcTraders = {
                    description = "Konfigurace syntetických nabídek, metody doručení, reputace a pravděpodobnosti podvodu.",
                    label = "NPC kupující a prodávající",
                },
                darknetPoliceGroups = {
                    description = "Skupinové klíče, které mohou zveřejňovat lákavé nabídky a sledovat vyšetřování.",
                    label = "Autorizované policejní pracovní skupiny",
                },
                darknetRenewalHours = {
                    description = "Počet hodin přičtených při obnovení nabídky vlastníkem.",
                    label = "Doba obnovení (hodiny)",
                },
                darknetScamChance = {
                    description = "Minimální šance, že NPC při obchodu vezme platbu nebo zboží, aniž by dodal protihodnotu. Vyšší šance specifická pro obchodníka bude stále platit.",
                    label = "Globální šance na podvod NPC (%)",
                },
                darknetStarterBalance = {
                    description = "Krypto je přiděleno pouze tehdy, když hráč poprvé otevře trh.",
                    label = "Počáteční zůstatek peněženky",
                },
                darknetTabletOrder = {
                    description = "Určuje polohu Darknetového trhu na tabletu.",
                    label = "Pořadí aplikací na tabletu",
                },
                darknetVerifiedMinimumRating = {
                    description = "Minimální průměrné hodnocení pro ověřeného prodejce.",
                    label = "Hodnocení vyžadované pro ověření",
                },
                darknetVerifiedMinimumSales = {
                    description = "Počet úspěšných prodejů vyžadovaný k tomu, aby se prodejce stal ověřeným.",
                    label = "Počet prodejů pro ověření",
                },
                drugAdvancedBusinessNetworkPaymentAccount = {
                    description = "Používá se, pokud je jako platební metoda nastaven hráčský účet. Platby organizace se vždy odečítají z účtu v Boss Menu.",
                    label = "Platební účet hráče",
                    options = {
                        bank = "Banka",
                        black_money = "Špinavé peníze",
                        money = "Hotovost",
                    },
                    requiresWarning = "Používá se pouze s platební metodou hráčského účtu.",
                },
                drugAdvancedBusinessNetworkPaymentSource = {
                    description = "Použij buď zůstatek kupujícího hráče, nebo účet organizace v Boss Menu.",
                    label = "Platební metoda",
                    options = {
                        player = "Hráčský účet",
                        society = "Účet organizace",
                    },
                },
                drugCamperLockKey = {
                    description = "Nastavuje výchozí klávesu pro uzamčení a odemčení vlastních nebo frakčních camperů. Hráči ji mohou přepsat ve svých klávesových zkratkách ve FiveM.",
                    label = "Výchozí klávesa zámku camperu",
                    options = {
                        L = "L",
                        U = "U",
                        K = "K",
                        J = "J",
                        G = "G",
                        H = "H",
                        X = "X",
                        Y = "Y",
                        F6 = "F6",
                        F7 = "F7",
                    },
                },
                drugCollectorInventoryMetadata = {
                    description = "Standardně přidává kvalitu a údaje o šarži k výsledkům sběrače. Vypněte, aby se suroviny běžně skládaly.",
                    label = "Metadata sběratelských předmětů",
                },
                drugLabAssaultAlertDuration = {
                    description = "Počet sekund, po dobu kterých zůstává polokruh poplachu obránců viditelný na mapě.",
                    label = "Doba trvání poplachu obránců",
                },
                drugLabAssaultAlertRadius = {
                    description = "Poloměr zóny útoku zobrazený obranné frakci na mapě.",
                    label = "Radius varování obránců",
                },
                drugLabAssaultBreachRadius = {
                    description = "Radius, ve kterém musí útočník zůstat během vyvracení vchodu.",
                    label = "Radius při nájezdu",
                },
                drugLabAssaultCaptureDuration = {
                    description = "Počet sekund, které musí útočníci držet vchod bez odporu, aby převzali laboratoř nebo camper.",
                    label = "Doba převzmutí",
                },
                drugLabAssaultCaptureRadius = {
                    description = "Vstupní oblast používaná ke zjištění počtu útočníků a soupeřících obránců.",
                    label = "Radius obsazení",
                },
                drugLabAssaultElectronicDuration = {
                    description = "Počet sekund potřebných k hacknutí vstupního systému.",
                    label = "Doba elektronického vniknutí",
                },
                drugLabAssaultEnabled = {
                    description = "Umožňuje frakcím násilně vniknout a převzít nepřátelské laboratoře a kempy sdílené frakcemi.",
                    label = "Povolit převzmutí laboratoře a kempu",
                },
                drugLabAssaultExplosiveDuration = {
                    description = "Počet sekund potřebných k výbuchnému průlzu vchodu.",
                    label = "Doba výbušného průlazu",
                },
                drugLabAssaultInteractionDistance = {
                    description = "Maximální vzdálenost od vchodu do laboratoře nebo kempu při zahájení útoku.",
                    label = "Vzdálenost pro interakci u vchodu",
                },
                drugLabAssaultMechanicalDuration = {
                    description = "Počet sekund potřebných k vyvrtání vstupního zámku.",
                    label = "Doba mechanického vniknutí",
                },
                drugLabAssaultMinimumDefenders = {
                    description = "Počet členů obráněné frakce, kteří musí být online, než může být útok zahájen.",
                    label = "Minimální počet obránců",
                },
                drugLabAssaultRequireDuty = {
                    description = "Počítá pouze členy obranné frakce, kteří jsou aktuálně v službě.",
                    label = "Počítat pouze obranné členy v službě",
                },
                drugProcessingInventoryMetadata = {
                    description = "Standardně přidává údaje o kvalitě a šarži k výsledkům zpracování. Individuální recepty mohou toto nastavení přepsat.",
                    label = "Zpracování metadat předmětů",
                },
                graffitiItemName = {
                    description = "Předmět v inventáři vyžadovaný pro zahájení stříkání, pokud je tato možnost zapnutá. Předmět musí být v aktivním inventáři.",
                    label = "Vyžadovaný předmět graffiti",
                },
                heistCooldownMinutes = {
                    description = "Blokuje stejné přepadení po skončení a vyčištění průběhu s reálnými interakcemi. Nula deaktivuje omezení. Nepoužitá vstupní okna jej nespouštějí.",
                    label = "Cooldown přepadu (minuty)",
                },
                heistCraftingMode = {
                    optionDescriptions = {
                        simple = "Pětisekundový ukazatel průběhu. Potřebné suroviny se spotřebují při úspěchu.",
                        medium = "Vyber suroviny v zobrazeném pořadí a u každé splň jednu časovací zkoušku.",
                        advanced = "Úplná montáž zařízení u receptů s profilem zařízení; jinak dvě přesné časovací zkoušky na surovinu.",
                    },
                    description = "Jednoduché: pětisekundový váček postupu. Střední: výběr ingrediencí a kontroly načasování. Maximální: plná montáž zařízení; recepty bez profilu zařízení využívají dvě přesná kontroly načasování na každou ingredienci.",
                    label = "Náročnost výroby",
                    options = {
                        advanced = "Maximální složitost",
                        medium = "Střední složitost",
                        simple = "Jednoduché",
                    },
                },
                heistInactivityTimeoutMinutes = {
                    description = "Po první interakci každá nová akce přepadu resetuje tento časovač. Vypršení času ukončí run a vymaže jeho světové objekty. Platí pro nové runy.",
                    label = "Limit nečinnosti přepadu (minuty)",
                },
                heistStartTimeoutMinutes = {
                    description = "Čas po stisknutí Startu pro interakci u cíle. Bez interakce se průběh resetuje a lze jej spustit znovu. Platí pro nové průběhy.",
                    label = "Minuty do první interakce s přepadením",
                },
                moneywashAccount = {
                    options = {
                        bank = "Banka",
                        black_money = "Špinavé peníze",
                        money = "Hotovost",
                    },
                },
                moneywashDirtyAccount = {
                    description = "Účet, ze kterého se při zahájení cyklu praní odečtou špinavé peníze hráče.",
                    label = "Účet pro vklad",
                },
                moneywashDrawDistance = {
                    description = "Maximální vzdálenost v metrech, na které jsou zobrazeny vchody do podniků a obchody.",
                    label = "Vzdálenost zobrazení",
                },
                moneywashEnabled = {
                    description = "Zpřístupní podniky pro praní peněz vlastněné organizací.",
                    label = "Aktivovat praní peněz",
                },
                moneywashFeePercent = {
                    description = "Procento odečtené od každé dávky před výplatou organizaci.",
                    label = "Služební poplatek (%)",
                },
                moneywashInteractionDistance = {
                    description = "Maximální vzdálenost v metrech pro použití vchodů do podniků a obchodů.",
                    label = "Interakční vzdálenost",
                },
                npcPoliceAccuracy = {
                    description = "Přesnost důstojníků NPC od 0 do 100.",
                    label = "Přesnost střelby",
                },
                npcPoliceArmour = {
                    description = "Hodnota brnění každého policisty NPC od 0 do 100.",
                    label = "Tělesná zbroj",
                },
                npcPoliceAtms = {
                    description = "Odeslat podporu NPC policie, když je vyvolán poplach při přepadu ATM.",
                    label = "Podpora při přepadech ATM",
                },
                npcPoliceDurationSeconds = {
                    description = "Maximální doba, po kterou zůstávají NPC policisté nasazeni po spawnu (30–900 sekund).",
                    label = "Doba nasazení (sekundy)",
                },
                npcPoliceEnabled = {
                    description = "Po vyvolání poplachu z přepadení vyslat ozbrojené policisty NPC. Ve výchozím nastavení je vypnuto.",
                    label = "Aktivovat podporu policie NPC",
                },
                npcPoliceHeists = {
                    description = "Při vyvolání poplachu během přepadu se vysleje podpora NPC policie.",
                    label = "Podpora během přepadů",
                },
                npcPoliceOfficerCount = {
                    description = "Počet ozbrojených policistů NPC vyslaných při každém poplachu z přepadení (1–8).",
                    label = "Počet policistů na zásah",
                },
                npcPoliceResponseDelaySeconds = {
                    description = "Čas mezi poplachem z přepadení a příjezdem policistů NPC (0–300 sekund).",
                    label = "Zpoždění reakce (sekundy)",
                },
                npcPoliceShops = {
                    description = "Zaslat podporu NPC policie, když je vyvolán poplach z přepadení obchodu.",
                    label = "Podpora při přepadeních obchodů",
                },
                npcPoliceSpawnDistance = {
                    description = "Vzdálenost od místa přepadu, ve které se spawnují policisté NPC (15–150 metrů).",
                    label = "Vzdálenost spawnu (metry)",
                },
                npcPoliceWeapon = {
                    description = "Zbraň vybavená každým reagujícím policistou NPC. Výchozí je pistole.",
                    label = "Služební zbraň",
                    options = {
                        WEAPON_CARBINERIFLE = "Karabina",
                        WEAPON_PISTOL = "Pistole",
                        WEAPON_PUMPSHOTGUN = "Pumpa",
                    },
                },
                openHeistCreator = {
                    buttonLabel = "Otevřít tvůrce přepadení",
                    description = "Otevřete Heist Creator a zavřete Job Configurator.",
                    label = "Vytvářed robíčeků",
                    unsavedTooltip = "Nejdříve uložte změny",
                },
                pickpocketAggressionChance = {
                    description = "Nezávislá šance, že NPC zaútočí po neúspěšném, zrušeném nebo vypršeném pokusu.",
                    label = "Šance na protiútak (%)",
                },
                pickpocketAlertChance = {
                    description = "Nezávislá šance, že NPC nahlásí neúspěšný, zrušený nebo vypršený pokus.",
                    label = "Šance na nouzový hovor (%)",
                },
                pickpocketDifficulty = {
                    description = "Ovládá rychlost kurzoru, jak rychle se zmenšuje cíl, délku sekvence a tolerované chyby.",
                    label = "Obtížnost",
                    options = {
                        easy = "Snadná",
                        expert = "Odborník",
                        hard = "Tvrdé",
                        normal = "Normálně",
                    },
                },
                pickpocketDispatchAlways = {
                    description = "Každý zahájený pokus o kapesní krádež nahlásit jednou, i při úspěchu a bez ohledu na šanci na tísňové volání.",
                    label = "Vždy odeslat hlášení",
                },
                pickpocketDispatchDurationSeconds = {
                    description = "Počet sekund, po dobu kterých je hlášení relevantní pro dispečery.",
                    label = "Doba dispečinku",
                },
                pickpocketDispatchJobs = {
                    description = "Názvy pracovních úkolů oddělené čárkou, které obdrží mimořádné výzvy.",
                    label = "Pracovní úkoly dispečinku",
                },
                pickpocketDispatchPriority = {
                    description = "Priorita předána bez změny do integrace dispečinku.",
                    label = "Priorita dispečinku",
                },
                pickpocketDispatchRadius = {
                    description = "Přibližný dosah poplachu odeslaný do integrace dispečinku.",
                    label = "Dosah dispečinku",
                },
                pickpocketEmptyChance = {
                    description = "Šance, že NPC nebude mít žádnou vybranou kořist.",
                    label = "Šance na prázdné kapsy (%)",
                },
                pickpocketEnabled = {
                    description = "Umožňuje hráčům pokusit se o kapesní krádeže u způsobilých ambientních síťovaných NPC.",
                    label = "Povolit kapesní krádeže NPC",
                },
                pickpocketFleeChance = {
                    description = "Nezávislá šance, že NPC uteče po neúspěšném, zrušeném nebo vypršeném pokusu.",
                    label = "Šance na útěk NPC (%)",
                },
                pickpocketInteractionDistance = {
                    description = "Maximální dosah klienta; server ověřuje s malou synchronizační rezervou.",
                    label = "Interakční vzdálenost",
                },
                pickpocketItems = {
                    description = "Každý řádek určuje jeho šanci na výskyt. Čtyři desetinná místa podporují 0.0001 procent.",
                    itemLabel = "Šance na předmět",
                    label = "Loot předmětů",
                },
                pickpocketItemsEnabled = {
                    description = "Také náhodně přidává nakonfigurované předměty do viditelného obsahu kapes.",
                    label = "Povolit kořist z předmětů",
                },
                pickpocketMaximumLootChoices = {
                    description = "Maximální počet serverem generovaných slotů hotovosti nebo předmětů zobrazených u jednoho NPC.",
                    label = "Maximální viditelná kořist",
                },
                pickpocketMinigame = {
                    description = "Vyberte jednu výzvu nebo náhodně rotujte mezi všemi třemi.",
                    label = "Minihra",
                    options = {
                        pulse = "Tlakový puls",
                        random = "Náhodná rotace",
                        sequence = "Sekvence směrů",
                        timing = "Časová lišta",
                    },
                },
                pickpocketMoneyMaximum = {
                    description = "Nejvyšší viditelná částka hotovosti; automaticky udržována na úrovni nebo nad minimem.",
                    label = "Maximální hotovost",
                },
                pickpocketMoneyMinimum = {
                    description = "Nejnižší serverem generovaná částka pro viditelný slot hotovosti.",
                    label = "Minimální hotovost",
                },
                pickpocketRequestCooldownSeconds = {
                    description = "Minimální počet sekund mezi požadavky na začátek od jednoho hráče.",
                    label = "Doba chladu požadavku",
                },
                pickpocketRequireCrimeJob = {
                    description = "Aktivní: přidává akci pouze registrovaným Crime System jobům. Neaktivní: odstraní vestavěnou radikální akci a vyžaduje serverový export.",
                    label = "Použít radikální menu pro Crime-job",
                },
                pickpocketRequiredHits = {
                    description = "Základní hodnota pro každou minihru. Hodnotné hotovost ji postupně zvyšuje; extrémně vzácné předměty vyžadují alespoň osm zásahů.",
                    label = "Minimální počet zásahů",
                },
                pickpocketSessionTimeoutSeconds = {
                    description = "Počet sekund, než vyprší neúplná serverová výzva.",
                    label = "Časový limit relace",
                },
                pickpocketTargetCooldownMinutes = {
                    description = "Uzamčení po zrušených nebo neúspěšných pokusech; úspěšně vyprázdnění NPC zůstane nedostupné.",
                    label = "Doba chladu NPC",
                },
                pvpAdminAce = {
                    description = "ACE objekt poskytující přístup k globální správě PvP událostí.",
                    label = "Správce ACE",
                },
                pvpArenaReturnSeconds = {
                    description = "Výchozí čas návratu pro nové akce. Vedoucí akce jej mohou přepsat v tabletu.",
                    label = "Čas návratu do areny",
                },
                pvpArenaWarningPosition = {
                    description = "Určuje, kde se zobrazuje varování o návratu do arény.",
                    label = "Pozice varování arény",
                    options = {
                        bottom_center = "Dolní střed",
                        bottom_left = "Levý dolní roh",
                        bottom_right = "Pravý dolní roh",
                        middle_center = "Střed obrazovky",
                        middle_left = "Levý střed",
                        middle_right = "Pravý střed",
                        top_center = "Horní střed",
                        top_left = "Levý horní roh",
                        top_right = "Pravý horní roh",
                    },
                },
                pvpArenas = {
                    description = "Vytvoří kruhové bojové zóny s místem pro pozorovatele a minimálně dvěma místy pro spawnování týmů.",
                    itemLabel = "Aréna",
                    label = "PvP arény",
                },
                pvpCountdownPosition = {
                    description = "Určuje, kde se zobrazuje odpočítávání začátku zápasu.",
                    label = "Pozice odpočítávání",
                    options = {
                        bottom_center = "Dolní střed",
                        bottom_left = "Levý dolní roh",
                        bottom_right = "Pravý dolní roh",
                        middle_center = "Střed obrazovky",
                        middle_left = "Levý střed",
                        middle_right = "Pravý střed",
                        top_center = "Horní střed",
                        top_left = "Levý horní roh",
                        top_right = "Pravý horní roh",
                    },
                },
                pvpDefaultMode = {
                    description = "Herní režim předvybraný pro nové události.",
                    label = "Výchozí herní režim",
                    options = {
                        free_for_all = "Každý proti každému",
                        last_man_standing = "Poslední přeživší",
                        team_deathmatch = "Tým Deathmatch",
                    },
                },
                pvpDefaultScoreLimit = {
                    description = "Výchozí počet zabití potřebný k vítězství v Team Deathmatchu nebo Free For All.",
                    label = "Výchozí cíl pro zabití",
                },
                pvpEventsEnabled = {
                    description = "Zpřístupní aplikaci frakčního PvP tabletu a běh událostí.",
                    label = "Povolit frakční PvP události",
                },
                pvpKillfeedPosition = {
                    description = "Určuje, kde se zobrazují nedávné eliminace.",
                    label = "Pozice Killfeedu",
                    options = {
                        bottom_center = "Dolní střed",
                        bottom_left = "Levý dolní roh",
                        bottom_right = "Pravý dolní roh",
                        middle_center = "Střed obrazovky",
                        middle_left = "Levý střed",
                        middle_right = "Pravý střed",
                        top_center = "Horní střed",
                        top_left = "Levý horní roh",
                        top_right = "Pravý horní roh",
                    },
                },
                pvpLeaderPermission = {
                    description = "Dovolená role pro vytváření, registraci, spouštění a správu akcí frakcí.",
                    label = "Pohybování lídra frakce",
                },
                pvpMatchDurationMinutes = {
                    description = "Výchozí délka v minutách pro nové události. Nula vypne časový limit.",
                    label = "Délka zápasu",
                },
                pvpMaxHistory = {
                    description = "Maximální počet dokončených nebo zrušených událostí zobrazených na tabletu.",
                    label = "Zobrazit historii událostí",
                },
                pvpMaxRewards = {
                    description = "Maximální počet kombinovaných odměn (předmět, zbraň, vozidlo nebo peníze) na jednu událost.",
                    label = "Maximální počet dodatečných odměn",
                },
                pvpMoneyPermission = {
                    description = "Příkaz k roli vyžadovaný pro vstupní poplatky a prize money.",
                    label = "Příkaz k financování frakce",
                },
                pvpRequestCooldownMs = {
                    description = "Minimální počet milisekund mezi opakujícími se PvP požadavky od jednolehlého hráče.",
                    label = "Cooldown akce",
                },
                pvpRespawnDelaySeconds = {
                    description = "Počet sekund předtím, než se hráč respawnuje nebo se po smrti přesune do oblasti pozorovatele.",
                    label = "Zpoždění respawnu",
                },
                pvpSchedulePollSeconds = {
                    description = "Počet sekund mezi kontrolami opakujících se šablon a automatických startů.",
                    label = "Interval kontroly plánu",
                },
                pvpScoreboardPosition = {
                    description = "Určuje, kde se zobrazuje kompaktní živý žebříček během zápasů frakcí.",
                    label = "Pozice na žebříčku",
                    options = {
                        bottom_center = "Dolní střed",
                        bottom_left = "Levý dolní roh",
                        bottom_right = "Pravý dolní roh",
                        middle_center = "Střed obrazovky",
                        middle_left = "Levý střed",
                        middle_right = "Pravý střed",
                        top_center = "Horní střed",
                        top_left = "Levý horní roh",
                        top_right = "Pravý horní roh",
                    },
                },
                pvpSoloTestingEnabled = {
                    description = "Umožňuje PvP administrátorům přihlášení a manuální start s jedním členem frakce. Na produkčních serverech vypněte.",
                    label = "Povolit sólo testování administrátorem",
                },
                pvpStartCountdownSeconds = {
                    description = "Výchozí odpočet pro nově vytvořené akce. Vedoucí akce jej mohou v tabletu upravit.",
                    label = "Spustit odpočet",
                },
                pvpTabletOrder = {
                    description = "Určuje, kde se na tabletu zobrazí aplikace frakčního PvP.",
                    label = "Pořadí aplikací na tabletu",
                },
                shopActiveTimeoutMinutes = {
                    description = "Počet minut do selhání opuštěného přepadení.",
                    label = "Časový limit aktivity",
                },
                shopConsumeDrill = {
                    description = "Spotřebovat vrták po úspěšném otevření.",
                    label = "Spotřebovat vrták",
                },
                shopConsumeHackItem = {
                    description = "Použít hackingový předmět po úspěšném otevření trezoru.",
                    label = "Použít hackingový předmět",
                },
                shopCooldownMinutes = {
                    description = "Počet minut běhu serveru před resetem obchodu.",
                    label = "Dočasné omezení obchodu",
                },
                shopDispatchAlways = {
                    description = "Každé přepadení obchodu nahlásit jednou při zahájení, i při nepřerušeném zastrašování a v obchodech bez povinného prodavače.",
                    label = "Vždy odeslat hlášení",
                },
                shopDispatchDurationSeconds = {
                    description = "Počet sekund, po dobu kterých je poplach relevantní.",
                    label = "Doba dispečinku",
                },
                shopDispatchJobs = {
                    description = "Pracovní postavy příjemců poplachu oddělené čárkou.",
                    label = "Pracovní úkoly dispečinku",
                },
                shopDispatchPriority = {
                    description = "Priorita předaná dispečinku.",
                    label = "Priorita dispečinku",
                },
                shopDispatchRadius = {
                    description = "Přibližný radius policejního poplachu.",
                    label = "Dosah dispečinku",
                },
                shopDrillDurationSeconds = {
                    description = "Počet sekund potřebných k vyvrtání trezoru.",
                    label = "Doba vrtání trezoru",
                },
                shopDrillItem = {
                    description = "ID předmětu v inventáři potřebného k odvrtání trezorů obchodů. Nastavuje se odděleně od vrtačky na bankomaty.",
                    label = "Předmět vrták",
                },
                shopDrillItemAmount = {
                    description = "Počet vyžadovaných předmětů vrtacího stroje.",
                    label = "Vyžadovaný počet vrtáků",
                },
                shopEnabled = {
                    description = "Povoluje přepadení v konfigurovaných obchodech s obsluhou.",
                    label = "Povolit přepadení obchodů",
                },
                shopHackItem = {
                    description = "Předmět vyžadovaný pro minihru hackování trezoru. Metodu otevření lze povolit zvlášť pro každý obchod.",
                    label = "Předmět pro hacking",
                },
                shopHackItemAmount = {
                    description = "Požadované množství hacking itemu.",
                    label = "Počet hacking itemů",
                },
                shopIntimidationSeconds = {
                    description = "Počet sekund, po dobu kterých musí být prodavač pod pohrůžkou.",
                    label = "Doba zastrašování",
                },
                shopLocations = {
                    description = "Jeden prodavač, jedna pokladna a volitelný trezor v každém obchodě.",
                    itemLabel = "Obchod",
                    label = "Lokality obchodů",
                },
                shopMinimumPolice = {
                    description = "Počet členů policejní skupiny v pracovní službě potřebný ke spuštění.",
                    label = "Minimální počet policie",
                },
                shopPoliceGroup = {
                    description = "Skupina rolí započítávaná pro policejní požadavky.",
                    label = "Skupina policejních rolí",
                },
                shopRegisterDurationSeconds = {
                    description = "Počet sekund potřebných k vyprázdnění pokladny.",
                    label = "Doba lupu pokladny",
                },
                shopRegisterRewardMaximum = {
                    description = "Nejvyšší výplata z pokladny.",
                    label = "Maximální odměna z pokladny",
                },
                shopRegisterRewardMinimum = {
                    description = "Nejnižší výplata z pokladny.",
                    label = "Minimální odměna z pokladny",
                },
                shopRegisterRewardName = {
                    description = "Volitelný název předmětu nebo účtu.",
                    label = "Název odměny pokladny",
                },
                shopRegisterRewardSort = {
                    description = "Zvolte hotovost nebo předmět black_money.",
                    label = "Typ výplaty z pokladny",
                },
                shopRegisters = {
                    description = "Pozice pokladen přiřazené podle ID obchodu.",
                    itemLabel = "Pokladna",
                    label = "Pokladny",
                },
                shopSafeLootDurationSeconds = {
                    description = "Počet sekund potřebných k převzetí hotovosti po zadání platného kódu trezoru.",
                    label = "Doba trvání luku trezoru",
                },
                shopSafeRewardMaximum = {
                    description = "Nejvyšší výplata trezoru.",
                    label = "Maximální bezpečná odměna",
                },
                shopSafeRewardMinimum = {
                    description = "Nejnižší výplata trezoru.",
                    label = "Minimální bezpečná odměna",
                },
                shopSafeRewardName = {
                    description = "Volitelný název předmětu nebo účtu.",
                    label = "Název odměny ze trezoru",
                },
                shopSafeRewardSort = {
                    description = "Zvolte hotovost nebo předmět black_money.",
                    label = "Typ výplaty z trezoru",
                },
                shopThreatGraceSeconds = {
                    description = "Povolené přerušení před vyvoláním poplachu.",
                    label = "Tolerance míření",
                },
                territoryDrugSalesEnabled = {
                    description = "Úspěšné pouliční prodeje NPC přinášejí vliv gangu prodejce v aktuálním pouličním území.",
                    label = "Prodej NPC poskytuje vliv na území",
                },
                atmLocationMode = {
                    label = "Režim umístění bankomatů",
                    description = "Automaticky rozpozná podporované objekty světa nebo použije pouze ručně nastavená místa.",
                    options = {
                        automatic = "Automaticky",
                        manual = "Ručně",
                    },
                },
                atmPoliceRequirementEnabled = {
                    label = "Vyžadovat policisty ve službě",
                    description = "Před zahájením loupeže bankomatu vyžaduje nastavený počet policistů ve službě.",
                },
                openDrugCreator = {
                    label = "Editor drog",
                    description = "Otevře editor drog Sky Crime a zavře konfigurátor povolání.",
                    buttonLabel = "Otevřít editor drog",
                    unsavedTooltip = "Nejprve uložit",
                },
                drugCreatorRuntimeDensity = {
                    label = "Hustota provozního panelu",
                    description = "Určuje kompaktnost provozního panelu v editoru drog.",
                    options = {
                        comfortable = "Pohodlné",
                        compact = "Kompaktní",
                    },
                },
                drugCreatorListDensity = {
                    label = "Hustota seznamu",
                    description = "Určuje kompaktnost seznamu záznamů v editoru.",
                    options = {
                        comfortable = "Pohodlné",
                        compact = "Kompaktní",
                    },
                },
                drugCreatorShowEmptyRuntimeLists = {
                    label = "Zobrazit prázdné provozní seznamy",
                    description = "Zobrazí sekce provozního panelu i bez záznamů.",
                },
                drugCreatorHideDisabledEntries = {
                    label = "Skrýt vypnuté záznamy",
                    description = "Skryje vypnuté záznamy modulů v seznamu editoru drog.",
                },
                drugCreatorAutoGenerateId = {
                    label = "Automaticky generovat ID",
                    description = "Při vytváření záznamů v editoru drog generuje ID z jejich názvů.",
                },
                drugCreatorOpenEditorOnModuleChange = {
                    label = "Otevřít editor při změně modulu",
                    description = "Automaticky otevře editor při změně aktivního modulu.",
                },
                drugCreatorSmartDuplicateSuffix = {
                    label = "Automatická přípona kopií",
                    description = "Při duplikování záznamů v editoru drog přidá automatickou příponu.",
                },
                drugCreatorAutoSelectRuntimeTargets = {
                    label = "Automaticky předvybrat herní cíle",
                    description = "Automaticky předvybere dostupné laboratoře a šarže.",
                },
                drugCreatorAttentionOnOpen = {
                    label = "Při otevření zaměřit na problémy",
                    description = "Otevře provozní panel se zaměřením na záznamy vyžadující pozornost.",
                },
                drugActivityHudPosition = {
                    label = "Pozice HUD činností",
                    description = "Přetáhněte HUD umisťování a sklizně na požadované místo obrazovky.",
                },
                drugInteractionHudPosition = {
                    label = "Pozice HUD interakcí",
                    description = "Přetáhněte HUD interakcí s rostlinami, laboratořemi a karavany na požadované místo obrazovky.",
                },
                drugPlantStatusHudPosition = {
                    label = "Pozice HUD stavu rostliny",
                    description = "Přetáhněte podrobný HUD stavu rostliny na požadované místo obrazovky.",
                },
                drugSystemEnabled = {
                    label = "Drogový systém",
                    description = "Zapne: výroba drog, data editoru a herní rozhraní pro toto zločinecké povolání.",
                },
                drugCreatorAccess = {
                    label = "Přístup k editoru drog",
                    description = "Určuje, kdo smí otevřít pokročilý editor drog.",
                    options = {
                        permission = "Pouze s oprávněním",
                        job_management = "Správa povolání",
                        owner_only = "Pouze vlastník",
                    },
                },
                drugRuntimeEnabled = {
                    label = "Provozní rozhraní",
                    description = "Umožní hráčům používat herní akce laboratoří, rostlin, zpracování a trhu.",
                },
                drugRuntimePlayerCreateLabs = {
                    label = "Vytváření laboratoří hráči",
                    description = "Umožní hráčům s přístupem k systému vytvářet laboratoře ze šablon editoru i bez práv správce.",
                },
                drugRuntimeOutdoorPlanting = {
                    label = "Venkovní pěstování",
                    description = "Povolí vlastní venkovní pěstování hráčů mimo nastavené laboratoře.",
                },
                drugRuntimePublicOutdoorHarvest = {
                    label = "Venkovní sklizeň ostatními hráči",
                    description = "Umožní ostatním hráčům sklízet venkovní rostliny, které sami nezasadili.",
                },
                drugRuntimeChargeLabPurchase = {
                    label = "Účtovat nákup laboratoře",
                    description = "Při vytvoření laboratoře účtuje hráčům nastavenou kupní cenu.",
                },
                drugRuntimeStrictInventory = {
                    label = "Přísně kontrolovat inventář",
                    description = "Herní akce pokračují pouze po úspěšném provedení nastavených operací s předměty, nástroji a penězi.",
                },
                drugRuntimeSalePayouts = {
                    label = "Prodej / Výplaty",
                    description = "Vyplácí hráčům peníze při prodeji šarží nebo tras prostřednictvím tržního systému.",
                },
                drugRuntimeSalePayoutAccount = {
                    label = "Výplata / Účet",
                    description = "Účet pro výplaty z prodeje drog, například black_money.",
                },
                drugRuntimeDispatchEnabled = {
                    label = "Odeslat / Poplachy",
                    description = "Předává rizikové události spojené s drogami dispečinku a nastaveným policejním povoláním.",
                },
                drugRuntimeNotifyPoliceJobs = {
                    label = "Policie / Oznámení",
                    description = "Upozorní nastavená policejní povolání, když riziková událost spojená s drogami vyvolá poplach.",
                },
                drugBatchPrefix = {
                    label = "Šarže / Předpona",
                    description = "Předpona ID nově vytvářených šarží drog.",
                },
                drugTestingKitAccuracy = {
                    label = "Testovací sada / Přesnost",
                    description = "Povolená odchylka skrytých hodnot u základní testovací sady.",
                },
                drugDecayIntervalMinutes = {
                    label = "Degradace / Interval",
                    description = "Interval v minutách pro: kontroly poklesu čerstvosti a kontaminace.",
                },
                drugDefaultPackaging = {
                    label = "Výchozí hodnota / Balení",
                    description = "Balení surových nebo zpracovaných šarží vytvořených bez určeného typu balení.",
                    options = {
                        loose = "Na volné ruce",
                        baggy = "Sáček",
                        jar = "Sklenice",
                        vacuum = "Vakuový sáček",
                        brick = "Obal bloku",
                        premium_seal = "Prémiové zapečetění",
                    },
                },
                drugQualityWeightQuality = {
                    label = "Kvalita / Hmotnost",
                    description = "Vliv na výslednou kvalitu: Základní kvalita.",
                },
                drugQualityWeightPurity = {
                    label = "Čistota / Hmotnost",
                    description = "Vliv na výslednou kvalitu: Čistota.",
                },
                drugQualityWeightFreshness = {
                    label = "Čerstvost / Hmotnost",
                    description = "Vliv na výslednou kvalitu: Čerstvost.",
                },
                drugQualityWeightPotency = {
                    label = "Síla / Hmotnost",
                    description = "Vliv na výslednou kvalitu: Síla.",
                },
                drugQualityWeightStability = {
                    label = "Stabilita / Hmotnost",
                    description = "Vliv na výslednou kvalitu: Stabilita.",
                },
                drugQualityWeightContamination = {
                    label = "Kontaminace / Postih",
                    description = "Postih hodnocení kvality kontaminovaných produktů.",
                },
                drugTierGoodMin = {
                    label = "Dobré / Úroveň / Minimum",
                    description = "Minimální skóre pro úroveň kvality: Dobré.",
                },
                drugTierPremiumMin = {
                    label = "Prémiové / Úroveň / Minimum",
                    description = "Minimální skóre pro úroveň kvality: Prémiové.",
                },
                drugTierTopShelfMin = {
                    label = "Špičková kvalita / Úroveň / Minimum",
                    description = "Minimální skóre pro úroveň kvality: Špičková kvalita.",
                },
                drugTierLabGradeMin = {
                    label = "Laboratorní kvalita / Úroveň / Minimum",
                    description = "Minimální skóre pro úroveň kvality: Laboratorní kvalita.",
                },
                drugBaggyDecayMultiplier = {
                    label = "Sáček / Degradace",
                    description = "Násobitel pro: ztráta čerstvosti / Sáčky.",
                },
                drugJarDecayMultiplier = {
                    label = "Sklenice / Degradace",
                    description = "Násobitel pro: ztráta čerstvosti / Sklenice.",
                },
                drugVacuumDecayMultiplier = {
                    label = "Vakuum / Degradace",
                    description = "Násobitel pro: ztráta čerstvosti / Vakuové sáčky.",
                },
                drugPremiumSealPriceMultiplier = {
                    label = "Prémiové zapečetění / Cena",
                    description = "Násobitel pro: Prémiové / Zapečetěný produkt / Cena.",
                },
                drugGrowingEnabled = {
                    label = "Pěstování / Aktivováno",
                    description = "Zapne: růst rostlin a sklizeň.",
                },
                drugEnvironmentSurveyEnabled = {
                    label = "Kontrola místa pěstování",
                    description = "Při zapnutí volně zasazené rostliny čekají na automatickou kontrolu místa správcem. Vypnutím povolíte růst bez schválení správce.",
                },
                drugGrowthTickMinutes = {
                    label = "Růst / Aktualizační cyklus / Minuty",
                    description = "Interval v minutách pro: aktualizace růstu rostlin.",
                },
                drugBaseGrowthPerTick = {
                    label = "Základní hodnota / Růst / Za aktualizační cyklus",
                    description = "Základní růst před vlivem odrůdy, vybavení a péče.",
                },
                drugWildPlantRespawnMinutes = {
                    label = "Divoká rostlina / Znovuobjevení",
                    description = "Čekací doba v minutách do: Divoká rostlina / Znovuobjevení.",
                },
                drugWildPlantHighlightEnabled = {
                    label = "Zvýraznit divoké rostliny",
                    description = "Zobrazí obrys vytvořených divokých rostlin, když hráč vstoupí do dosahu zvýraznění.",
                },
                drugWildPlantHighlightDistance = {
                    label = "Poloměr zvýraznění divokých rostlin",
                    description = "Vzdálenost v metrech kolem každé vytvořené divoké rostliny, ve které je její obrys viditelný.",
                },
                drugDefaultPlantWater = {
                    label = "Výchozí hodnota / Voda",
                    description = "Počáteční hodnota při vytvoření rostliny: Voda.",
                },
                drugDefaultPlantFertilizer = {
                    label = "Výchozí hodnota / Hnojivo",
                    description = "Počáteční hodnota při vytvoření rostliny: Hnojivo.",
                },
                drugDefaultPlantHealth = {
                    label = "Výchozí hodnota / Zdraví",
                    description = "Počáteční hodnota při vytvoření rostliny: Zdraví.",
                },
                drugDefaultPlantMutationChance = {
                    label = "Výchozí hodnota / Šance na mutaci",
                    description = "Základní pravděpodobnost mutace, pokud odrůda nemá vlastní hodnotu.",
                },
                drugHarvestPerfectStart = {
                    label = "Začátek optimální sklizně",
                    description = "Procento růstu pro optimální sklizňové okno: Začátek.",
                },
                drugHarvestPerfectEnd = {
                    label = "Konec optimální sklizně",
                    description = "Procento růstu pro optimální sklizňové okno: Konec.",
                },
                drugLabsEnabled = {
                    label = "Laboratoře / Aktivováno",
                    description = "Zapne: laboratoře a obytné vozy ve hře.",
                },
                drugMaxLaboratoriesPerCharacter = {
                    label = "Laboratoře na postavu",
                    description = "Maximální počet koupených nebo pronajatých stálých laboratoří na vlastníka. 0 znamená neomezeně; obytné vozy a sdílený přístup se nepočítají.",
                },
                drugMaxLaboratoriesPerFaction = {
                    label = "Laboratoře na frakci",
                    description = "Maximální počet koupených nebo pronajatých stálých laboratoří na vlastníka. 0 znamená neomezeně; obytné vozy a sdílený přístup se nepočítají.",
                },
                drugDefaultRentDays = {
                    label = "Výchozí hodnota / Počet dní nájmu",
                    description = "Výchozí hodnota pro: Laboratoř / Nájem / Doba trvání.",
                },
                drugCamperHotVehicleMinutes = {
                    label = "Ukradený obytný vůz / Minuty",
                    description = "Doba zvýšeného rizika u ukradených obytných vozů.",
                },
                drugLabRentWarningHours = {
                    label = "Nájem / Výstraha / Hodiny",
                    description = "Počet hodin před vypršením nájmu laboratoře, kdy se zobrazí varování.",
                },
                drugLabRentExpiredHeatGain = {
                    label = "Vypršelý nájem / Policejní tlak",
                    description = "Zvýšení pozornosti policie při vypršení nájmu laboratoře.",
                },
                drugCamperMoveCooldownMinutes = {
                    label = "Kemp / Přesunout / Dočasné omezení",
                    description = "Čekací doba v minutách do: Kemp / Laboratoř / Opětovné přesunutí.",
                },
                drugLabUpgradeCostMultiplier = {
                    label = "Vylepšení / Cost / Násobitel",
                    description = "Násobitel pro: Laboratoř / Úroveň / Vylepšení / Ceny.",
                },
                drugCamperBaseSlots = {
                    label = "Kemp / Sloty",
                    description = "Výchozí hodnota pro: laboratoře v obytných vozech / sloty pro vybavení.",
                },
                drugCamperBaseStorage = {
                    label = "Kemp / Sklad",
                    description = "Výchozí hodnota pro: laboratoře v obytných vozech / Kapacita skladu.",
                },
                drugCamperBasePower = {
                    label = "Kemp / Energie",
                    description = "Výchozí hodnota pro: laboratoře v obytných vozech / Vestavěné napájení.",
                },
                drugBasementBaseSlots = {
                    label = "Sklep / Sloty",
                    description = "Výchozí hodnota pro: sklepní laboratoře / sloty pro vybavení.",
                },
                drugBasementBaseStorage = {
                    label = "Sklep / Sklad",
                    description = "Výchozí hodnota pro: sklepní laboratoře / Kapacita skladu.",
                },
                drugWarehouseBasePower = {
                    label = "Sklad / Energie",
                    description = "Výchozí hodnota pro: skladové laboratoře / Vestavěné napájení.",
                },
                drugPowerEnabled = {
                    label = "Energie / Systém",
                    description = "Zapne: výroba elektřiny, spotřeba a kontroly přetížení laboratoře.",
                },
                drugOverloadGraceSeconds = {
                    label = "Přetížení / Ochranná lhůta",
                    description = "Počet sekund, po kterých se přetížení napájení stane nebezpečným.",
                },
                drugHeatPerKilowatt = {
                    label = "Policejní tlak / Za kilowatt",
                    description = "Pozornost policie vůči laboratoři vyvolaná spotřebou elektřiny.",
                },
                drugGeneratorT1Watts = {
                    label = "Generátor T1 / Wattů",
                    description = "Výkon generátorů úrovně T1 ve wattech.",
                },
                drugGeneratorT2Watts = {
                    label = "Generátor T2 / Wattů",
                    description = "Výkon generátorů úrovně T2 ve wattech.",
                },
                drugGeneratorT3Watts = {
                    label = "Generátor T3 / Wattů",
                    description = "Výkon generátorů úrovně T3 ve wattech.",
                },
                drugEquipmentConditionWearMultiplier = {
                    label = "Opotřebení / Násobitel",
                    description = "Globální násobitel pro: Opotřebení vybavení / Zpracování.",
                },
                drugWorkersEnabled = {
                    label = "Pracovníci / Aktivováno",
                    description = "Zapne: chemici, pěstitelé, baliči a ostraha v drogových laboratořích.",
                },
                drugMaxWorkersPerLab = {
                    label = "Maximum / Pracovníci / Laboratoř",
                    description = "Maximální počet pracovníků na laboratoř.",
                },
                drugWorkerFatiguePerProcessStep = {
                    label = "Únava ze zpracování",
                    description = "Přidaná únava pro: Pracovníci, po práci: Krok zpracování.",
                },
                drugWorkerFatiguePerGrowAction = {
                    label = "Pěstování / Únava",
                    description = "Přidaná únava pro: Pěstitelé, po práci: Sklizeň nebo pěstování.",
                },
                drugWorkerRecoveryPerTick = {
                    label = "Pracovník / Zotavení",
                    description = "Obnova — Únava, při každém kroku: Aktualizace růstu.",
                },
                drugMarketEnabled = {
                    label = "Trh / Aktivováno",
                    description = "Zapne: kupující, dealeři a prodej šarží.",
                },
                drugMarketBasePriceFallback = {
                    label = "Náhradní hodnota / Základní cena",
                    description = "Základní cena drog bez vlastní nastavené ceny.",
                },
                drugMarketStreetMultiplier = {
                    label = "Ulice / Násobitel",
                    description = "Globální násobitel pro: Cena / Pouliční prodej.",
                },
                drugMarketWholesaleMultiplier = {
                    label = "Velkoobchod / Násobitel",
                    description = "Globální násobitel pro: Cena / Velkoobchod / Obchody.",
                },
                drugMarketPremiumMultiplier = {
                    label = "Prémiové / Násobitel",
                    description = "Globální násobitel pro: Cena / Prémiové / Kupující.",
                },
                drugMarketHeatPerSale = {
                    label = "Policejní tlak / Prodej",
                    description = "Základní policejní tlak přidaný laboratoři při prodeji šarže.",
                },
                drugDistributionTickMinutes = {
                    label = "Distribuce / Aktualizační cyklus",
                    description = "Interval v minutách pro: aktualizace distribuce dealerů.",
                },
                drugDistributionIntervalMinutes = {
                    label = "Distribuce / Interval",
                    description = "Výchozí hodnota pro: Dealer / Čekání před prodejem / Minuty.",
                },
                drugDistributionMaxPerDealer = {
                    label = "Maximum / Dealer / Zadání",
                    description = "Výchozí hodnota pro: Dealer / maximální počet aktivních distribučních zakázek.",
                },
                drugThreatsEnabled = {
                    label = "Hrozby / Aktivováno",
                    description = "Zapne: pokles pozornosti policie, razie a sabotáže v laboratořích.",
                },
                drugThreatTickMinutes = {
                    label = "Hrozba / Aktualizační cyklus",
                    description = "Interval v minutách pro: pokles pozornosti policie a kontroly razií a sabotáží.",
                },
                drugRaidHeatThreshold = {
                    label = "Práh pozornosti policie pro razie",
                    description = "Požadovaný policejní tlak v laboratoři před spuštěním: Razie.",
                },
                drugSabotageHeatThreshold = {
                    label = "Práh pozornosti policie pro sabotáž",
                    description = "Požadovaný policejní tlak v laboratoři před spuštěním: Sabotáž.",
                },
                drugThreatHeatDecay = {
                    label = "Policejní tlak / Degradace",
                    description = "Při každé aktualizaci hrozeb sníží pozornost policie vůči laboratoři o tuto hodnotu.",
                },
                drugRaidChanceAtThreshold = {
                    label = "Šance na razii",
                    description = "Základní pravděpodobnost události Přepadení po dosažení příslušného prahu policejního tlaku.",
                },
                drugSabotageChanceAtThreshold = {
                    label = "Sabotáž / Šance",
                    description = "Základní pravděpodobnost události Sabotáž po dosažení příslušného prahu policejního tlaku.",
                },
                drugConsumptionEnabled = {
                    label = "Konzumace povolena",
                    description = "Zapne: účinky drog a sledování tolerance a závislosti.",
                },
                drugDoseConsumesBatch = {
                    label = "Spotřebovat šarži při užití",
                    description = "Odebere spotřebovanou šarži z aktivních zásob.",
                },
                drugToleranceDecayMinutes = {
                    label = "Tolerance / Degradace",
                    description = "Interval v minutách pro: aktualizace poklesu tolerance.",
                },
                drugAddictionDecayMinutes = {
                    label = "Závislost / Degradace",
                    description = "Interval v minutách pro: aktualizace poklesu závislosti.",
                },
                drugPotencyEffectMultiplier = {
                    label = "Síla / Násobitel",
                    description = "Určuje, jak silně potence zvyšuje intenzitu účinků.",
                },
                drugOverdosePotencyThreshold = {
                    label = "Předávkování / Práh",
                    description = "Požadovaná zátěž účinnou látkou, než může být vyhodnoceno předávkování.",
                },
                drugBaseAddictionGain = {
                    label = "Základní hodnota / Závislost / zisk",
                    description = "Základní nárůst závislosti na dávku.",
                },
                drugProcessingEnabled = {
                    label = "Zpracování / Aktivováno",
                    description = "Zapne: zpracovatelské úkoly, balení a testovací sady.",
                },
                drugBatchMetadataItemKey = {
                    label = "Šarže / Metadata / Klíč",
                    description = "Klíč metadat inventáře používaný integracemi pro údaje o šaržích.",
                },
                drugDefaultProcessDuration = {
                    label = "Výchozí doba zpracování",
                    description = "Výchozí hodnota pro: Zpracování / Doba trvání / sekundů / Bez vlastní hodnoty receptu.",
                },
                drugDefaultFailureRisk = {
                    label = "Výchozí hodnota / Riziko chyby",
                    description = "Výchozí hodnota pro: Zpracování / Riziko chyby / Bez vlastní hodnoty receptu.",
                },
                drugPackagingDuration = {
                    label = "Doba balení",
                    description = "Výchozí hodnota pro: Balení / Doba trvání / sekundů.",
                },
                drugPowerTickSeconds = {
                    label = "Energie / Aktualizační cyklus / sekundů",
                    description = "Interval v sekundách pro: aktualizace spotřeby generátorů a energetických stop.",
                },
                drugPowerSignatureHeatPerHour = {
                    label = "Energetická stopa / Policejní tlak / Hodina",
                    description = "Pozornost policie vyvolaná za hodinu energetickou stopou laboratoře.",
                },
                drugPowerOverloadHeatPerHour = {
                    label = "Přetížení / Policejní tlak / Hodina",
                    description = "Dodatečný policejní tlak za hodinu při přetížení laboratoře.",
                },
                drugPowerIdleHeatDecayPerHour = {
                    label = "Nečinný / Policejní tlak / Degradace / Hodina",
                    description = "Pokles pozornosti policie za hodinu, když laboratoř nemá aktivní energetickou stopu.",
                },
                drugPowerModeManualMaxLoadPercent = {
                    label = "Manuální / Maximum / Zatížení",
                    description = "Hodnota pro energetický režim Manuální: Maximum / Zatížení.",
                },
                drugPowerModeManualHeatMultiplier = {
                    label = "Manuální / Policejní tlak / Násobitel",
                    description = "Hodnota pro energetický režim Manuální: Policejní tlak / Násobitel.",
                },
                drugPowerModeManualNoiseMultiplier = {
                    label = "Manuální / Hluk / Násobitel",
                    description = "Hodnota pro energetický režim Manuální: Hluk / Násobitel.",
                },
                drugPowerModeBalancedMaxLoadPercent = {
                    label = "Vyvážené / Maximum / Zatížení",
                    description = "Hodnota pro energetický režim Vyvážené: Maximum / Zatížení.",
                },
                drugPowerModeBalancedHeatMultiplier = {
                    label = "Vyvážené / Policejní tlak / Násobitel",
                    description = "Hodnota pro energetický režim Vyvážené: Policejní tlak / Násobitel.",
                },
                drugPowerModeBalancedNoiseMultiplier = {
                    label = "Vyvážené / Hluk / Násobitel",
                    description = "Hodnota pro energetický režim Vyvážené: Hluk / Násobitel.",
                },
                drugPowerModeStealthMaxLoadPercent = {
                    label = "Skrytý režim / Maximum / Zatížení",
                    description = "Hodnota pro energetický režim Skrytý režim: Maximum / Zatížení.",
                },
                drugPowerModeStealthHeatMultiplier = {
                    label = "Skrytý režim / Policejní tlak / Násobitel",
                    description = "Hodnota pro energetický režim Skrytý režim: Policejní tlak / Násobitel.",
                },
                drugPowerModeStealthNoiseMultiplier = {
                    label = "Skrytý režim / Hluk / Násobitel",
                    description = "Hodnota pro energetický režim Skrytý režim: Hluk / Násobitel.",
                },
                drugPowerPrioritySmellControl = {
                    label = "Kontrola zápachu / Priorita",
                    description = "Priorita automatického odpojování zátěže: Kontrola zápachu / Vybavení.",
                },
                drugPowerPriorityAirflow = {
                    label = "Větrání / Priorita",
                    description = "Priorita automatického odpojování zátěže: Větrání / Vybavení.",
                },
                drugPowerPrioritySecurity = {
                    label = "Zabezpečení / Priorita",
                    description = "Priorita automatického odpojování zátěže: Bezpečnostní vybavení.",
                },
                drugPowerPriorityGrowing = {
                    label = "Pěstování / Priorita",
                    description = "Priorita automatického odpojování zátěže: Pěstování / Vybavení.",
                },
                drugPowerPriorityLight = {
                    label = "Osvětlení / Priorita",
                    description = "Priorita automatického odpojování zátěže: Osvětlení / Vybavení.",
                },
                drugPowerPriorityTesting = {
                    label = "Testování / Priorita",
                    description = "Priorita automatického odpojování zátěže: Testování / Vybavení.",
                },
                drugPowerPriorityPackaging = {
                    label = "Balení / Priorita",
                    description = "Priorita automatického odpojování zátěže: Balení / Vybavení.",
                },
                drugPowerPriorityChemistry = {
                    label = "Chemie / Priorita",
                    description = "Priorita automatického odpojování zátěže: Chemie / Vybavení.",
                },
                drugPowerPriorityHeating = {
                    label = "Vytápění / Priorita",
                    description = "Priorita automatického odpojování zátěže: Vytápění / Vybavení.",
                },
                drugPowerPriorityPressing = {
                    label = "Lisování / Priorita",
                    description = "Priorita automatického odpojování zátěže: Lisování / Vybavení.",
                },
                drugPowerPriorityGeneral = {
                    label = "Obecné / Priorita",
                    description = "Priorita automatického odpojování zátěže: Obecné vybavení.",
                },
                drugAdvancedPerformanceInactiveControlIntervalMs = {
                    label = "Výkon / Neaktivní / Ovládání / Interval / ms",
                    description = "Provozní nastavení pro: Výkon / Neaktivní / Ovládání / Interval / ms.",
                },
                drugAdvancedPerformanceInteractionIdleScanIntervalMs = {
                    label = "Výkon / Interakce / Nečinný / Interval skenování / ms",
                    description = "Provozní nastavení pro: Výkon / Interakce / Nečinný / Interval skenování / ms.",
                },
                drugAdvancedPerformanceInteractionPromptIntervalMs = {
                    label = "Výkon / Interakce / Výzva k interakci / Interval / ms",
                    description = "Provozní nastavení pro: Výkon / Interakce / Výzva k interakci / Interval / ms.",
                },
                drugAdvancedPerformanceInteractionScanIntervalMs = {
                    label = "Výkon / Interakce / Interval skenování / ms",
                    description = "Provozní nastavení pro: Výkon / Interakce / Interval skenování / ms.",
                },
                drugAdvancedPerformanceMinimumScanIntervalMs = {
                    label = "Výkon / Minimum / Interval skenování / ms",
                    description = "Provozní nastavení pro: Výkon / Minimum / Interval skenování / ms.",
                },
                drugAdvancedPerformanceStreetPedActivationDistance = {
                    label = "Výkon / Ulice / Ped / Aktivace / Vzdálenost",
                    description = "Provozní nastavení pro: Výkon / Ulice / Ped / Aktivace / Vzdálenost.",
                },
                drugAdvancedPerformanceStreetPedIdleScanIntervalMs = {
                    label = "Výkon / Ulice / Ped / Nečinný / Interval skenování / ms",
                    description = "Provozní nastavení pro: Výkon / Ulice / Ped / Nečinný / Interval skenování / ms.",
                },
                drugAdvancedPerformanceStreetPedScanIntervalMs = {
                    label = "Výkon / Ulice / Ped / Interval skenování / ms",
                    description = "Provozní nastavení pro: Výkon / Ulice / Ped / Interval skenování / ms.",
                },
                drugAdvancedPerformanceWorldCachePadding = {
                    label = "Výkon / Svět / Mezipaměť / Dodatečná rezerva",
                    description = "Provozní nastavení pro: Výkon / Svět / Mezipaměť / Dodatečná rezerva.",
                },
                drugAdvancedPerformanceWorldCacheRefreshIntervalMs = {
                    label = "Výkon / Svět / Mezipaměť / Obnovení / Interval / ms",
                    description = "Provozní nastavení pro: Výkon / Svět / Mezipaměť / Obnovení / Interval / ms.",
                },
                drugAdvancedPerformanceWorldIdleIntervalMs = {
                    label = "Výkon / Svět / Nečinný / Interval / ms",
                    description = "Provozní nastavení pro: Výkon / Svět / Nečinný / Interval / ms.",
                },
                drugAdvancedDynamicMarketActionCooldownSeconds = {
                    label = "Dynamický trh / Cooldown akce / sekundů",
                    description = "Provozní nastavení pro: Dynamický trh / Cooldown akce / sekundů.",
                },
                drugAdvancedDynamicMarketActionHistoryLimit = {
                    label = "Dynamický trh / Akce / Limit historie",
                    description = "Provozní nastavení pro: Dynamický trh / Akce / Limit historie.",
                },
                drugAdvancedDynamicMarketAmountSaturationWeight = {
                    label = "Dynamický trh / Množství / Nasycení / Hmotnost",
                    description = "Provozní nastavení pro: Dynamický trh / Množství / Nasycení / Hmotnost.",
                },
                drugAdvancedDynamicMarketBaseIntelAccuracy = {
                    label = "Dynamický trh / Základní hodnota / Přesnost informací",
                    description = "Provozní nastavení pro: Dynamický trh / Základní hodnota / Přesnost informací.",
                },
                drugAdvancedDynamicMarketDefaultAverageQuality = {
                    label = "Dynamický trh / Výchozí hodnota / Průměr / Kvalita",
                    description = "Provozní nastavení pro: Dynamický trh / Výchozí hodnota / Průměr / Kvalita.",
                },
                drugAdvancedDynamicMarketDefaultResourceElasticity = {
                    label = "Dynamický trh / Výchozí hodnota / Surovina / Elasticita",
                    description = "Provozní nastavení pro: Dynamický trh / Výchozí hodnota / Surovina / Elasticita.",
                },
                drugAdvancedDynamicMarketDemandCenter = {
                    label = "Dynamický trh / Poptávka / Střední hodnota",
                    description = "Provozní nastavení pro: Dynamický trh / Poptávka / Střední hodnota.",
                },
                drugAdvancedDynamicMarketDemandPriceImpact = {
                    label = "Dynamický trh / Poptávka / Cena / Dopad",
                    description = "Provozní nastavení pro: Dynamický trh / Poptávka / Cena / Dopad.",
                },
                drugAdvancedDynamicMarketDirectionThreshold = {
                    label = "Dynamický trh / Směr / Práh",
                    description = "Provozní nastavení pro: Dynamický trh / Směr / Práh.",
                },
                drugAdvancedDynamicMarketEnabled = {
                    label = "Dynamický trh / Aktivováno",
                    description = "Provozní nastavení pro: Dynamický trh / Aktivováno.",
                },
                drugAdvancedDynamicMarketEventChance = {
                    label = "Dynamický trh / Událost / Šance",
                    description = "Provozní nastavení pro: Dynamický trh / Událost / Šance.",
                },
                drugAdvancedDynamicMarketEventDurationMinutes = {
                    label = "Dynamický trh / Událost / Doba trvání / Minuty",
                    description = "Provozní nastavení pro: Dynamický trh / Událost / Doba trvání / Minuty.",
                },
                drugAdvancedDynamicMarketEventMinimumDurationMinutes = {
                    label = "Dynamický trh / Událost / Minimum / Doba trvání / Minuty",
                    description = "Provozní nastavení pro: Dynamický trh / Událost / Minimum / Doba trvání / Minuty.",
                },
                drugAdvancedDynamicMarketEventStrengthMaximum = {
                    label = "Dynamický trh / Událost / Síla / Maximum",
                    description = "Provozní nastavení pro: Dynamický trh / Událost / Síla / Maximum.",
                },
                drugAdvancedDynamicMarketEventStrengthMinimum = {
                    label = "Dynamický trh / Událost / Síla / Minimum",
                    description = "Provozní nastavení pro: Dynamický trh / Událost / Síla / Minimum.",
                },
                drugAdvancedDynamicMarketEventsCrackdownDemand = {
                    label = "Dynamický trh / Události / Policejní zásah / Poptávka",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Policejní zásah / Poptávka.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPolice = {
                    label = "Dynamický trh / Události / Policejní zásah / Policie",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Policejní zásah / Policie.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPrice = {
                    label = "Dynamický trh / Události / Policejní zásah / Cena",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Policejní zásah / Cena.",
                },
                drugAdvancedDynamicMarketEventsFestivalDemand = {
                    label = "Dynamický trh / Události / Festival / Poptávka",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Festival / Poptávka.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem1 = {
                    label = "Dynamický trh / Události / Festival / Účinky / 1",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Festival / Účinky / 1.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem2 = {
                    label = "Dynamický trh / Události / Festival / Účinky / 2",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Festival / Účinky / 2.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem3 = {
                    label = "Dynamický trh / Události / Festival / Účinky / 3",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Festival / Účinky / 3.",
                },
                drugAdvancedDynamicMarketEventsFestivalPrice = {
                    label = "Dynamický trh / Události / Festival / Cena",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Festival / Cena.",
                },
                drugAdvancedDynamicMarketEventsFestivalProfilesItem1 = {
                    label = "Dynamický trh / Události / Festival / Profily / 1",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Festival / Profily / 1.",
                },
                drugAdvancedDynamicMarketEventsGangconflictDemand = {
                    label = "Dynamický trh / Události / Gangové konflikty / Poptávka",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Gangové konflikty / Poptávka.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPolice = {
                    label = "Dynamický trh / Události / Gangové konflikty / Policie",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Gangové konflikty / Policie.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPrice = {
                    label = "Dynamický trh / Události / Gangové konflikty / Cena",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Gangové konflikty / Cena.",
                },
                drugAdvancedDynamicMarketEventsGangconflictProfilesItem1 = {
                    label = "Dynamický trh / Události / Gangové konflikty / Profily / 1",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Gangové konflikty / Profily / 1.",
                },
                drugAdvancedDynamicMarketEventsLabbustDemand = {
                    label = "Dynamický trh / Události / Razie v laboratoři / Poptávka",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Razie v laboratoři / Poptávka.",
                },
                drugAdvancedDynamicMarketEventsLabbustPolice = {
                    label = "Dynamický trh / Události / Razie v laboratoři / Policie",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Razie v laboratoři / Policie.",
                },
                drugAdvancedDynamicMarketEventsLabbustPrice = {
                    label = "Dynamický trh / Události / Razie v laboratoři / Cena",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Razie v laboratoři / Cena.",
                },
                drugAdvancedDynamicMarketEventsLabbustSupply = {
                    label = "Dynamický trh / Události / Razie v laboratoři / Zásobování",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Razie v laboratoři / Zásobování.",
                },
                drugAdvancedDynamicMarketEventsPartyDemand = {
                    label = "Dynamický trh / Události / Večírek / Poptávka",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Večírek / Poptávka.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem1 = {
                    label = "Dynamický trh / Události / Večírek / Účinky / 1",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Večírek / Účinky / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem2 = {
                    label = "Dynamický trh / Události / Večírek / Účinky / 2",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Večírek / Účinky / 2.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem3 = {
                    label = "Dynamický trh / Události / Večírek / Účinky / 3",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Večírek / Účinky / 3.",
                },
                drugAdvancedDynamicMarketEventsPartyPrice = {
                    label = "Dynamický trh / Události / Večírek / Cena",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Večírek / Cena.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem1 = {
                    label = "Dynamický trh / Události / Večírek / Profily / 1",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Večírek / Profily / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem2 = {
                    label = "Dynamický trh / Události / Večírek / Profily / 2",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Večírek / Profily / 2.",
                },
                drugAdvancedDynamicMarketEventsShortageDemand = {
                    label = "Dynamický trh / Události / Nedostatek / Poptávka",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Nedostatek / Poptávka.",
                },
                drugAdvancedDynamicMarketEventsShortagePrice = {
                    label = "Dynamický trh / Události / Nedostatek / Cena",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Nedostatek / Cena.",
                },
                drugAdvancedDynamicMarketEventsShortageSupply = {
                    label = "Dynamický trh / Události / Nedostatek / Zásobování",
                    description = "Provozní nastavení pro: Dynamický trh / Události / Nedostatek / Zásobování.",
                },
                drugAdvancedDynamicMarketExactIntelReputation = {
                    label = "Dynamický trh / Přesné informace / Reputace",
                    description = "Provozní nastavení pro: Dynamický trh / Přesné informace / Reputace.",
                },
                drugAdvancedDynamicMarketExactIntelTrust = {
                    label = "Dynamický trh / Přesné informace / Důvěra",
                    description = "Provozní nastavení pro: Dynamický trh / Přesné informace / Důvěra.",
                },
                drugAdvancedDynamicMarketGlobalZoneLabel = {
                    label = "Dynamický trh / Global / Zóna / Štítek",
                    description = "Provozní nastavení pro: Dynamický trh / Global / Zóna / Štítek.",
                },
                drugAdvancedDynamicMarketHistoryLimit = {
                    label = "Dynamický trh / Limit historie",
                    description = "Provozní nastavení pro: Dynamický trh / Limit historie.",
                },
                drugAdvancedDynamicMarketInitialDemand = {
                    label = "Dynamický trh / Počáteční hodnota / Poptávka",
                    description = "Provozní nastavení pro: Dynamický trh / Počáteční hodnota / Poptávka.",
                },
                drugAdvancedDynamicMarketInitialPriceMultiplier = {
                    label = "Dynamický trh / Počáteční hodnota / Násobitel ceny",
                    description = "Provozní nastavení pro: Dynamický trh / Počáteční hodnota / Násobitel ceny.",
                },
                drugAdvancedDynamicMarketIntelDemandError = {
                    label = "Dynamický trh / Informace / Poptávka / Error",
                    description = "Provozní nastavení pro: Dynamický trh / Informace / Poptávka / Error.",
                },
                drugAdvancedDynamicMarketIntelMaximumAccuracy = {
                    label = "Dynamický trh / Informace / Maximum / Přesnost",
                    description = "Provozní nastavení pro: Dynamický trh / Informace / Maximum / Přesnost.",
                },
                drugAdvancedDynamicMarketIntelMinimumAccuracy = {
                    label = "Dynamický trh / Informace / Minimum / Přesnost",
                    description = "Provozní nastavení pro: Dynamický trh / Informace / Minimum / Přesnost.",
                },
                drugAdvancedDynamicMarketIntelPoliceError = {
                    label = "Dynamický trh / Informace / Policie / Error",
                    description = "Provozní nastavení pro: Dynamický trh / Informace / Policie / Error.",
                },
                drugAdvancedDynamicMarketIntelPriceError = {
                    label = "Dynamický trh / Informace / Cena / Error",
                    description = "Provozní nastavení pro: Dynamický trh / Informace / Cena / Error.",
                },
                drugAdvancedDynamicMarketIntelPriceMaximum = {
                    label = "Dynamický trh / Informace / Cena / Maximum",
                    description = "Provozní nastavení pro: Dynamický trh / Informace / Cena / Maximum.",
                },
                drugAdvancedDynamicMarketIntelPriceMinimum = {
                    label = "Dynamický trh / Informace / Cena / Minimum",
                    description = "Provozní nastavení pro: Dynamický trh / Informace / Cena / Minimum.",
                },
                drugAdvancedDynamicMarketIntelReputationWeight = {
                    label = "Dynamický trh / Informace / Reputace / Hmotnost",
                    description = "Provozní nastavení pro: Dynamický trh / Informace / Reputace / Hmotnost.",
                },
                drugAdvancedDynamicMarketIntelResourcePriceError = {
                    label = "Dynamický trh / Informace / Surovina / Cena / Error",
                    description = "Provozní nastavení pro: Dynamický trh / Informace / Surovina / Cena / Error.",
                },
                drugAdvancedDynamicMarketIntelSaturationError = {
                    label = "Dynamický trh / Informace / Nasycení / Error",
                    description = "Provozní nastavení pro: Dynamický trh / Informace / Nasycení / Error.",
                },
                drugAdvancedDynamicMarketIntelSeedBucketSeconds = {
                    label = "Dynamický trh / Okno semene informací / sekundů",
                    description = "Provozní nastavení pro: Dynamický trh / Okno semene informací / sekundů.",
                },
                drugAdvancedDynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Dynamický trh / Informace / Stav / Přesnost / Práh",
                    description = "Provozní nastavení pro: Dynamický trh / Informace / Stav / Přesnost / Práh.",
                },
                drugAdvancedDynamicMarketIntelStatusErrorThreshold = {
                    label = "Dynamický trh / Informace / Stav / Error / Práh",
                    description = "Provozní nastavení pro: Dynamický trh / Informace / Stav / Error / Práh.",
                },
                drugAdvancedDynamicMarketIntelSupplyError = {
                    label = "Dynamický trh / Informace / Zásobování / Error",
                    description = "Provozní nastavení pro: Dynamický trh / Informace / Zásobování / Error.",
                },
                drugAdvancedDynamicMarketIntelTrustWeight = {
                    label = "Dynamický trh / Informace / Důvěra / Hmotnost",
                    description = "Provozní nastavení pro: Dynamický trh / Informace / Důvěra / Hmotnost.",
                },
                drugAdvancedDynamicMarketManipulationCooldownMinutes = {
                    label = "Dynamický trh / Manipulace / Minuty prodlevy",
                    description = "Provozní nastavení pro: Dynamický trh / Manipulace / Minuty prodlevy.",
                },
                drugAdvancedDynamicMarketManipulationDemandShift = {
                    label = "Dynamický trh / Manipulace / Poptávka / Posun",
                    description = "Provozní nastavení pro: Dynamický trh / Manipulace / Poptávka / Posun.",
                },
                drugAdvancedDynamicMarketManipulationDurationMinutes = {
                    label = "Dynamický trh / Manipulace / Doba trvání / Minuty",
                    description = "Provozní nastavení pro: Dynamický trh / Manipulace / Doba trvání / Minuty.",
                },
                drugAdvancedDynamicMarketManipulationHeat = {
                    label = "Dynamický trh / Manipulace / Policejní tlak",
                    description = "Provozní nastavení pro: Dynamický trh / Manipulace / Policejní tlak.",
                },
                drugAdvancedDynamicMarketManipulationMinimumBatchAmount = {
                    label = "Dynamický trh / Manipulace / Minimum / Šarže / Množství",
                    description = "Provozní nastavení pro: Dynamický trh / Manipulace / Minimum / Šarže / Množství.",
                },
                drugAdvancedDynamicMarketManipulationPaymentAccount = {
                    label = "Dynamický trh / Manipulace / Platební účet",
                    description = "Provozní nastavení pro: Dynamický trh / Manipulace / Platební účet.",
                },
                drugAdvancedDynamicMarketManipulationPrice = {
                    label = "Dynamický trh / Manipulace / Cena",
                    description = "Provozní nastavení pro: Dynamický trh / Manipulace / Cena.",
                },
                drugAdvancedDynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Dynamický trh / Manipulace / Zóna / Policejní tlak / Násobitel",
                    description = "Provozní nastavení pro: Dynamický trh / Manipulace / Zóna / Policejní tlak / Násobitel.",
                },
                drugAdvancedDynamicMarketMaximumIntelAgeMinutes = {
                    label = "Dynamický trh / Maximum / Stáří informací / Minuty",
                    description = "Provozní nastavení pro: Dynamický trh / Maximum / Stáří informací / Minuty.",
                },
                drugAdvancedDynamicMarketMaximumPriceMultiplier = {
                    label = "Dynamický trh / Maximum / Násobitel ceny",
                    description = "Provozní nastavení pro: Dynamický trh / Maximum / Násobitel ceny.",
                },
                drugAdvancedDynamicMarketMinimumIntelAgeMinutes = {
                    label = "Dynamický trh / Minimum / Stáří informací / Minuty",
                    description = "Provozní nastavení pro: Dynamický trh / Minimum / Stáří informací / Minuty.",
                },
                drugAdvancedDynamicMarketMinimumMetricWindowMinutes = {
                    label = "Dynamický trh / Minimum / Metrika / Časové okno / Minuty",
                    description = "Provozní nastavení pro: Dynamický trh / Minimum / Metrika / Časové okno / Minuty.",
                },
                drugAdvancedDynamicMarketMinimumPriceMultiplier = {
                    label = "Dynamický trh / Minimální cena / Násobitel",
                    description = "Provozní nastavení pro: Dynamický trh / Minimální cena / Násobitel.",
                },
                drugAdvancedDynamicMarketMinimumUpdateMinutes = {
                    label = "Dynamický trh / Minimum / Aktualizace / Minuty",
                    description = "Provozní nastavení pro: Dynamický trh / Minimum / Aktualizace / Minuty.",
                },
                drugAdvancedDynamicMarketPoliceDemandWeight = {
                    label = "Dynamický trh / Policie / Poptávka / Hmotnost",
                    description = "Provozní nastavení pro: Dynamický trh / Policie / Poptávka / Hmotnost.",
                },
                drugAdvancedDynamicMarketPolicePriceImpact = {
                    label = "Dynamický trh / Policie / Cena / Dopad",
                    description = "Provozní nastavení pro: Dynamický trh / Policie / Cena / Dopad.",
                },
                drugAdvancedDynamicMarketPoorQualityDemandPenalty = {
                    label = "Dynamický trh / Nízká kvalita / Poptávka / Postih",
                    description = "Provozní nastavení pro: Dynamický trh / Nízká kvalita / Poptávka / Postih.",
                },
                drugAdvancedDynamicMarketPoorQualityThreshold = {
                    label = "Dynamický trh / Nízká kvalita / Práh",
                    description = "Provozní nastavení pro: Dynamický trh / Nízká kvalita / Práh.",
                },
                drugAdvancedDynamicMarketPremiumQualityDemandBonus = {
                    label = "Dynamický trh / Prémiová kvalita / Bonus poptávky",
                    description = "Provozní nastavení pro: Dynamický trh / Prémiová kvalita / Bonus poptávky.",
                },
                drugAdvancedDynamicMarketPremiumQualityThreshold = {
                    label = "Dynamický trh / Prémiová kvalita / Práh",
                    description = "Provozní nastavení pro: Dynamický trh / Prémiová kvalita / Práh.",
                },
                drugAdvancedDynamicMarketProductionSupplyWeight = {
                    label = "Dynamický trh / Produkce / Zásobování / Hmotnost",
                    description = "Provozní nastavení pro: Dynamický trh / Produkce / Zásobování / Hmotnost.",
                },
                drugAdvancedDynamicMarketProductionWindowMinutes = {
                    label = "Dynamický trh / Produkce / Časové okno / Minuty",
                    description = "Provozní nastavení pro: Dynamický trh / Produkce / Časové okno / Minuty.",
                },
                drugAdvancedDynamicMarketQualityCenter = {
                    label = "Dynamický trh / Kvalita / Střední hodnota",
                    description = "Provozní nastavení pro: Dynamický trh / Kvalita / Střední hodnota.",
                },
                drugAdvancedDynamicMarketQualityConfidenceImpact = {
                    label = "Dynamický trh / Kvalita / Spolehlivost / Dopad",
                    description = "Provozní nastavení pro: Dynamický trh / Kvalita / Spolehlivost / Dopad.",
                },
                drugAdvancedDynamicMarketQualityRange = {
                    label = "Dynamický trh / Kvalita / Rozsah hodnot",
                    description = "Provozní nastavení pro: Dynamický trh / Kvalita / Rozsah hodnot.",
                },
                drugAdvancedDynamicMarketRarityBonusMaximum = {
                    label = "Dynamický trh / Vzácnost / Bonus / Maximum",
                    description = "Provozní nastavení pro: Dynamický trh / Vzácnost / Bonus / Maximum.",
                },
                drugAdvancedDynamicMarketRegionalGlobalWeight = {
                    label = "Dynamický trh / Regionální / Global / Hmotnost",
                    description = "Provozní nastavení pro: Dynamický trh / Regionální / Global / Hmotnost.",
                },
                drugAdvancedDynamicMarketRegionalLocalWeight = {
                    label = "Dynamický trh / Regionální / Místní / Hmotnost",
                    description = "Provozní nastavení pro: Dynamický trh / Regionální / Místní / Hmotnost.",
                },
                drugAdvancedDynamicMarketResourceAliasesDrugpackaging = {
                    label = "Dynamický trh / Surovina / Alternativní názvy / Droga / Balení",
                    description = "Provozní nastavení pro: Dynamický trh / Surovina / Alternativní názvy / Droga / Balení.",
                },
                drugAdvancedDynamicMarketResourceAliasesFuelcan = {
                    label = "Dynamický trh / Surovina / Alternativní názvy / Kanystr paliva",
                    description = "Provozní nastavení pro: Dynamický trh / Surovina / Alternativní názvy / Kanystr paliva.",
                },
                drugAdvancedDynamicMarketResourceAliasesMachineoil = {
                    label = "Dynamický trh / Surovina / Alternativní názvy / Strojový olej",
                    description = "Provozní nastavení pro: Dynamický trh / Surovina / Alternativní názvy / Strojový olej.",
                },
                drugAdvancedDynamicMarketResourceAliasesPlantnutrients = {
                    label = "Dynamický trh / Surovina / Alternativní názvy / Výživa pro rostliny",
                    description = "Provozní nastavení pro: Dynamický trh / Surovina / Alternativní názvy / Výživa pro rostliny.",
                },
                drugAdvancedDynamicMarketResourceAliasesRepairkit = {
                    label = "Dynamický trh / Surovina / Alternativní názvy / Sada na opravu",
                    description = "Provozní nastavení pro: Dynamický trh / Surovina / Alternativní názvy / Sada na opravu.",
                },
                drugAdvancedDynamicMarketResourceDirectionFallThreshold = {
                    label = "Dynamický trh / Surovina / Směr / Pokles / Práh",
                    description = "Provozní nastavení pro: Dynamický trh / Surovina / Směr / Pokles / Práh.",
                },
                drugAdvancedDynamicMarketResourceDirectionRiseThreshold = {
                    label = "Dynamický trh / Surovina / Směr / Růst / Práh",
                    description = "Provozní nastavení pro: Dynamický trh / Surovina / Směr / Růst / Práh.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterBasePrice = {
                    label = "Dynamický trh / Zdroje / Uhlíkový filtr / Základní cena",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Uhlíkový filtr / Základní cena.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterElasticity = {
                    label = "Dynamický trh / Zdroje / Uhlíkový filtr / Elasticita",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Uhlíkový filtr / Elasticita.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLabel = {
                    label = "Dynamický trh / Zdroje / Uhlíkový filtr / Štítek",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Uhlíkový filtr / Štítek.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem1 = {
                    label = "Dynamický trh / Zdroje / Uhlíkový filtr / Propojené drogy / 1",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Uhlíkový filtr / Propojené drogy / 1.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem2 = {
                    label = "Dynamický trh / Zdroje / Uhlíkový filtr / Propojené drogy / 2",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Uhlíkový filtr / Propojené drogy / 2.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem3 = {
                    label = "Dynamický trh / Zdroje / Uhlíkový filtr / Propojené drogy / 3",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Uhlíkový filtr / Propojené drogy / 3.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorBasePrice = {
                    label = "Dynamický trh / Zdroje / Chemický prekurzor / Základní cena",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Chemický prekurzor / Základní cena.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorElasticity = {
                    label = "Dynamický trh / Zdroje / Chemický prekurzor / Elasticita",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Chemický prekurzor / Elasticita.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLabel = {
                    label = "Dynamický trh / Zdroje / Chemický prekurzor / Štítek",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Chemický prekurzor / Štítek.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem1 = {
                    label = "Dynamický trh / Zdroje / Chemický prekurzor / Propojené drogy / 1",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Chemický prekurzor / Propojené drogy / 1.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem2 = {
                    label = "Dynamický trh / Zdroje / Chemický prekurzor / Propojené drogy / 2",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Chemický prekurzor / Propojené drogy / 2.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsBasePrice = {
                    label = "Dynamický trh / Zdroje / Součásti vybavení / Základní cena",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Součásti vybavení / Základní cena.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsElasticity = {
                    label = "Dynamický trh / Zdroje / Součásti vybavení / Elasticita",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Součásti vybavení / Elasticita.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsLabel = {
                    label = "Dynamický trh / Zdroje / Součásti vybavení / Štítek",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Součásti vybavení / Štítek.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerBasePrice = {
                    label = "Dynamický trh / Zdroje / Hnojivo / Základní cena",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Hnojivo / Základní cena.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerElasticity = {
                    label = "Dynamický trh / Zdroje / Hnojivo / Elasticita",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Hnojivo / Elasticita.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLabel = {
                    label = "Dynamický trh / Zdroje / Hnojivo / Štítek",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Hnojivo / Štítek.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLinkedDrugsItem1 = {
                    label = "Dynamický trh / Zdroje / Hnojivo / Propojené drogy / 1",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Hnojivo / Propojené drogy / 1.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelBasePrice = {
                    label = "Dynamický trh / Zdroje / Palivo do laboratoře / Základní cena",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Palivo do laboratoře / Základní cena.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelElasticity = {
                    label = "Dynamický trh / Zdroje / Palivo do laboratoře / Elasticita",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Palivo do laboratoře / Elasticita.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelLabel = {
                    label = "Dynamický trh / Zdroje / Palivo do laboratoře / Štítek",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Palivo do laboratoře / Štítek.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagBasePrice = {
                    label = "Dynamický trh / Zdroje / Balicí sáček / Základní cena",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Balicí sáček / Základní cena.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagElasticity = {
                    label = "Dynamický trh / Zdroje / Balicí sáček / Elasticita",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Balicí sáček / Elasticita.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagLabel = {
                    label = "Dynamický trh / Zdroje / Balicí sáček / Štítek",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Balicí sáček / Štítek.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotBasePrice = {
                    label = "Dynamický trh / Zdroje / Pěstební květináč / Základní cena",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Pěstební květináč / Základní cena.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotElasticity = {
                    label = "Dynamický trh / Zdroje / Pěstební květináč / Elasticita",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Pěstební květináč / Elasticita.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLabel = {
                    label = "Dynamický trh / Zdroje / Pěstební květináč / Štítek",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Pěstební květináč / Štítek.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLinkedDrugsItem1 = {
                    label = "Dynamický trh / Zdroje / Pěstební květináč / Propojené drogy / 1",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Pěstební květináč / Propojené drogy / 1.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedBasePrice = {
                    label = "Dynamický trh / Zdroje / Semeno konopí / Základní cena",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Semeno konopí / Základní cena.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedElasticity = {
                    label = "Dynamický trh / Zdroje / Semeno konopí / Elasticita",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Semeno konopí / Elasticita.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLabel = {
                    label = "Dynamický trh / Zdroje / Semeno konopí / Štítek",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Semeno konopí / Štítek.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLinkedDrugsItem1 = {
                    label = "Dynamický trh / Zdroje / Semeno konopí / Propojené drogy / 1",
                    description = "Provozní nastavení pro: Dynamický trh / Zdroje / Semeno konopí / Propojené drogy / 1.",
                },
                drugAdvancedDynamicMarketSalesWindowMinutes = {
                    label = "Dynamický trh / Prodeje / Časové okno / Minuty",
                    description = "Provozní nastavení pro: Dynamický trh / Prodeje / Časové okno / Minuty.",
                },
                drugAdvancedDynamicMarketSaturationDemandWeight = {
                    label = "Dynamický trh / Nasycení / Poptávka / Hmotnost",
                    description = "Provozní nastavení pro: Dynamický trh / Nasycení / Poptávka / Hmotnost.",
                },
                drugAdvancedDynamicMarketSaturationPriceImpact = {
                    label = "Dynamický trh / Nasycení / Cena / Dopad",
                    description = "Provozní nastavení pro: Dynamický trh / Nasycení / Cena / Dopad.",
                },
                drugAdvancedDynamicMarketScarcityDemandWeight = {
                    label = "Dynamický trh / Nedostatek / Poptávka / Hmotnost",
                    description = "Provozní nastavení pro: Dynamický trh / Nedostatek / Poptávka / Hmotnost.",
                },
                drugAdvancedDynamicMarketScarcityPriceImpact = {
                    label = "Dynamický trh / Nedostatek / Cena / Dopad",
                    description = "Provozní nastavení pro: Dynamický trh / Nedostatek / Cena / Dopad.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsDecember = {
                    label = "Dynamický trh / Roční období / Konec / Měsíce / Prosinec",
                    description = "Provozní nastavení pro: Dynamický trh / Roční období / Konec / Měsíce / Prosinec.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSpring = {
                    label = "Dynamický trh / Roční období / Konec / Měsíce / Jaro",
                    description = "Provozní nastavení pro: Dynamický trh / Roční období / Konec / Měsíce / Jaro.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSummer = {
                    label = "Dynamický trh / Roční období / Konec / Měsíce / Léto",
                    description = "Provozní nastavení pro: Dynamický trh / Roční období / Konec / Měsíce / Léto.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsWinter = {
                    label = "Dynamický trh / Roční období / Konec / Měsíce / Zima",
                    description = "Provozní nastavení pro: Dynamický trh / Roční období / Konec / Měsíce / Zima.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersAutumn = {
                    label = "Dynamický trh / Roční období / Násobitele / Podzim",
                    description = "Provozní nastavení pro: Dynamický trh / Roční období / Násobitele / Podzim.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSpring = {
                    label = "Dynamický trh / Roční období / Násobitele / Jaro",
                    description = "Provozní nastavení pro: Dynamický trh / Roční období / Násobitele / Jaro.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSummer = {
                    label = "Dynamický trh / Roční období / Násobitele / Léto",
                    description = "Provozní nastavení pro: Dynamický trh / Roční období / Násobitele / Léto.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersWinter = {
                    label = "Dynamický trh / Roční období / Násobitele / Zima",
                    description = "Provozní nastavení pro: Dynamický trh / Roční období / Násobitele / Zima.",
                },
                drugAdvancedDynamicMarketShortageRumorThreshold = {
                    label = "Dynamický trh / Nedostatek / Fáma / Práh",
                    description = "Provozní nastavení pro: Dynamický trh / Nedostatek / Fáma / Práh.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHighDemand = {
                    label = "Dynamický trh / Stav / Prahy / Vysoká poptávka",
                    description = "Provozní nastavení pro: Dynamický trh / Stav / Prahy / Vysoká poptávka.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHot = {
                    label = "Dynamický trh / Stav / Prahy / Hledaný",
                    description = "Provozní nastavení pro: Dynamický trh / Stav / Prahy / Hledaný.",
                },
                drugAdvancedDynamicMarketStatusThresholdsLowDemand = {
                    label = "Dynamický trh / Stav / Prahy / Nízká poptávka",
                    description = "Provozní nastavení pro: Dynamický trh / Stav / Prahy / Nízká poptávka.",
                },
                drugAdvancedDynamicMarketStatusThresholdsSaturated = {
                    label = "Dynamický trh / Stav / Prahy / Nasyceno",
                    description = "Provozní nastavení pro: Dynamický trh / Stav / Prahy / Nasyceno.",
                },
                drugAdvancedDynamicMarketTargetSupply = {
                    label = "Dynamický trh / Cíl / Zásobování",
                    description = "Provozní nastavení pro: Dynamický trh / Cíl / Zásobování.",
                },
                drugAdvancedDynamicMarketTrendChance = {
                    label = "Dynamický trh / Trend / Šance",
                    description = "Provozní nastavení pro: Dynamický trh / Trend / Šance.",
                },
                drugAdvancedDynamicMarketTrendDurationMinutes = {
                    label = "Dynamický trh / Trend / Doba trvání / Minuty",
                    description = "Provozní nastavení pro: Dynamický trh / Trend / Doba trvání / Minuty.",
                },
                drugAdvancedDynamicMarketTrendMaximumStrength = {
                    label = "Dynamický trh / Trend / Maximum / Síla",
                    description = "Provozní nastavení pro: Dynamický trh / Trend / Maximum / Síla.",
                },
                drugAdvancedDynamicMarketTrendMinimumStrength = {
                    label = "Dynamický trh / Trend / Minimum / Síla",
                    description = "Provozní nastavení pro: Dynamický trh / Trend / Minimum / Síla.",
                },
                drugAdvancedDynamicMarketUpdateMinutes = {
                    label = "Dynamický trh / Aktualizace / Minuty",
                    description = "Provozní nastavení pro: Dynamický trh / Aktualizace / Minuty.",
                },
                drugAdvancedDynamicMarketVolatilityMaximum = {
                    label = "Dynamický trh / Kolísání cen / Maximum",
                    description = "Provozní nastavení pro: Dynamický trh / Kolísání cen / Maximum.",
                },
                drugAdvancedDynamicMarketVolatilityMinimum = {
                    label = "Dynamický trh / Kolísání cen / Minimum",
                    description = "Provozní nastavení pro: Dynamický trh / Kolísání cen / Minimum.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersCold = {
                    label = "Dynamický trh / Počasí / Násobitele / Chlad",
                    description = "Provozní nastavení pro: Dynamický trh / Počasí / Násobitele / Chlad.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersHeatwave = {
                    label = "Dynamický trh / Počasí / Násobitele / Vlna veder",
                    description = "Provozní nastavení pro: Dynamický trh / Počasí / Násobitele / Vlna veder.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersNormal = {
                    label = "Dynamický trh / Počasí / Násobitele / Normálně",
                    description = "Provozní nastavení pro: Dynamický trh / Počasí / Násobitele / Normálně.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersRain = {
                    label = "Dynamický trh / Počasí / Násobitele / Déšť",
                    description = "Provozní nastavení pro: Dynamický trh / Počasí / Násobitele / Déšť.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersStorm = {
                    label = "Dynamický trh / Počasí / Násobitele / Bouře",
                    description = "Provozní nastavení pro: Dynamický trh / Počasí / Násobitele / Bouře.",
                },
                drugAdvancedDynamicMarketWeatherState = {
                    label = "Dynamický trh / Počasí / Stav",
                    description = "Provozní nastavení pro: Dynamický trh / Počasí / Stav.",
                },
                drugAdvancedHeatActionCooldownSeconds = {
                    label = "Pozornost policie a riziko / Cooldown akce / sekundů",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Cooldown akce / sekundů.",
                },
                drugAdvancedHeatActivityRiskWeightsAmount = {
                    label = "Pozornost policie a riziko / Aktivita / Riziko / Váhy / Množství",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Aktivita / Riziko / Váhy / Množství.",
                },
                drugAdvancedHeatActivityRiskWeightsDurationMinutes = {
                    label = "Pozornost policie a riziko / Aktivita / Riziko / Váhy / Doba trvání / Minuty",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Aktivita / Riziko / Váhy / Doba trvání / Minuty.",
                },
                drugAdvancedHeatActivityRiskWeightsPolicePressure = {
                    label = "Pozornost policie a riziko / Aktivita / Riziko / Váhy / Tlak policie",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Aktivita / Riziko / Váhy / Tlak policie.",
                },
                drugAdvancedHeatActivityRiskWeightsReputation = {
                    label = "Pozornost policie a riziko / Aktivita / Riziko / Váhy / Reputace",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Aktivita / Riziko / Váhy / Reputace.",
                },
                drugAdvancedHeatActivityRiskWeightsSecurity = {
                    label = "Pozornost policie a riziko / Aktivita / Riziko / Váhy / Zabezpečení",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Aktivita / Riziko / Váhy / Zabezpečení.",
                },
                drugAdvancedHeatAggressiveHeatMultiplier = {
                    label = "Pozornost policie a riziko / Agresivní režim / Policejní tlak / Násobitel",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Agresivní režim / Policejní tlak / Násobitel.",
                },
                drugAdvancedHeatBurnerBurnThreshold = {
                    label = "Pozornost policie a riziko / Jednorázový telefon / Prozrazení / Práh",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Jednorázový telefon / Prozrazení / Práh.",
                },
                drugAdvancedHeatBurnerHeatPerWholesale = {
                    label = "Pozornost policie a riziko / Jednorázový telefon / Policejní tlak / Za velkoobchodní prodej",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Jednorázový telefon / Policejní tlak / Za velkoobchodní prodej.",
                },
                drugAdvancedHeatBurnerPhoneItem = {
                    label = "Pozornost policie a riziko / Burner phone / Předmět",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Burner phone / Předmět.",
                },
                drugAdvancedHeatCamperOperationalHeatMultiplier = {
                    label = "Pozornost policie a riziko / Obytný vůz v provozu / Policejní tlak / Násobitel",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Obytný vůz v provozu / Policejní tlak / Násobitel.",
                },
                drugAdvancedHeatCamperOperationalHeatThreshold = {
                    label = "Pozornost policie a riziko / Obytný vůz v provozu / Policejní tlak / Práh",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Obytný vůz v provozu / Policejní tlak / Práh.",
                },
                drugAdvancedHeatCamperParkedHeat = {
                    label = "Pozornost policie a riziko / Zaparkovaný obytný vůz / Policejní tlak",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Zaparkovaný obytný vůz / Policejní tlak.",
                },
                drugAdvancedHeatContaminatedHeatMultiplier = {
                    label = "Pozornost policie a riziko / Kontaminace / Policejní tlak / Násobitel",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Kontaminace / Policejní tlak / Násobitel.",
                },
                drugAdvancedHeatContaminatedThreshold = {
                    label = "Pozornost policie a riziko / Kontaminace / Práh",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Kontaminace / Práh.",
                },
                drugAdvancedHeatCultivationFreePlants = {
                    label = "Pozornost policie a riziko / Pěstování / Rostliny bez dodatečného rizika",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Pěstování / Rostliny bez dodatečného rizika.",
                },
                drugAdvancedHeatCultivationHeatPerPlant = {
                    label = "Pozornost policie a riziko / Pěstování / Policejní tlak / Za rostlinu",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Pěstování / Policejní tlak / Za rostlinu.",
                },
                drugAdvancedHeatDealerHiddenMinutes = {
                    label = "Pozornost policie a riziko / Dealer / skryté / Minuty",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Dealer / skryté / Minuty.",
                },
                drugAdvancedHeatDecayPerTickBatch = {
                    label = "Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Šarže",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Šarže.",
                },
                drugAdvancedHeatDecayPerTickCamper = {
                    label = "Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Kemp",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Kemp.",
                },
                drugAdvancedHeatDecayPerTickDealer = {
                    label = "Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Dealer",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Dealer.",
                },
                drugAdvancedHeatDecayPerTickFaction = {
                    label = "Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Frakce",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Frakce.",
                },
                drugAdvancedHeatDecayPerTickHub = {
                    label = "Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Distribuční centrum",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Distribuční centrum.",
                },
                drugAdvancedHeatDecayPerTickLab = {
                    label = "Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Laboratoř",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Laboratoř.",
                },
                drugAdvancedHeatDecayPerTickPlayer = {
                    label = "Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Hráč",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Hráč.",
                },
                drugAdvancedHeatDecayPerTickRoute = {
                    label = "Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Trasa",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Trasa.",
                },
                drugAdvancedHeatDecayPerTickZone = {
                    label = "Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Zóna",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Degradace / Za aktualizační cyklus / Zóna.",
                },
                drugAdvancedHeatEnabled = {
                    label = "Pozornost policie a riziko / Aktivováno",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Aktivováno.",
                },
                drugAdvancedHeatEnforcementHeatCritical = {
                    label = "Pozornost policie a riziko / Přítomnost policie / Policejní tlak / Kritické",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Přítomnost policie / Policejní tlak / Kritické.",
                },
                drugAdvancedHeatEnforcementHeatHigh = {
                    label = "Pozornost policie a riziko / Přítomnost policie / Policejní tlak / Vysoká",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Přítomnost policie / Policejní tlak / Vysoká.",
                },
                drugAdvancedHeatEnforcementHeatLow = {
                    label = "Pozornost policie a riziko / Přítomnost policie / Policejní tlak / Nízká",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Přítomnost policie / Policejní tlak / Nízká.",
                },
                drugAdvancedHeatEnforcementHeatMedium = {
                    label = "Pozornost policie a riziko / Přítomnost policie / Policejní tlak / Střední",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Přítomnost policie / Policejní tlak / Střední.",
                },
                drugAdvancedHeatEnforcementMultipliersBatch = {
                    label = "Pozornost policie a riziko / Přítomnost policie / Násobitele / Šarže",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Přítomnost policie / Násobitele / Šarže.",
                },
                drugAdvancedHeatEnforcementMultipliersFaction = {
                    label = "Pozornost policie a riziko / Přítomnost policie / Násobitele / Frakce",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Přítomnost policie / Násobitele / Frakce.",
                },
                drugAdvancedHeatEnforcementMultipliersZone = {
                    label = "Pozornost policie a riziko / Přítomnost policie / Násobitele / Zóna",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Přítomnost policie / Násobitele / Zóna.",
                },
                drugAdvancedHeatEntityTypesBatch = {
                    label = "Pozornost policie a riziko / Herní objekt / Typy / Šarže",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Herní objekt / Typy / Šarže.",
                },
                drugAdvancedHeatEntityTypesCamper = {
                    label = "Pozornost policie a riziko / Herní objekt / Typy / Kemp",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Herní objekt / Typy / Kemp.",
                },
                drugAdvancedHeatEntityTypesDealer = {
                    label = "Pozornost policie a riziko / Herní objekt / Typy / Dealer",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Herní objekt / Typy / Dealer.",
                },
                drugAdvancedHeatEntityTypesFaction = {
                    label = "Pozornost policie a riziko / Herní objekt / Typy / Frakce",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Herní objekt / Typy / Frakce.",
                },
                drugAdvancedHeatEntityTypesHub = {
                    label = "Pozornost policie a riziko / Herní objekt / Typy / Distribuční centrum",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Herní objekt / Typy / Distribuční centrum.",
                },
                drugAdvancedHeatEntityTypesLab = {
                    label = "Pozornost policie a riziko / Herní objekt / Typy / Laboratoř",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Herní objekt / Typy / Laboratoř.",
                },
                drugAdvancedHeatEntityTypesPlayer = {
                    label = "Pozornost policie a riziko / Herní objekt / Typy / Hráč",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Herní objekt / Typy / Hráč.",
                },
                drugAdvancedHeatEntityTypesRoute = {
                    label = "Pozornost policie a riziko / Herní objekt / Typy / Trasa",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Herní objekt / Typy / Trasa.",
                },
                drugAdvancedHeatEntityTypesZone = {
                    label = "Pozornost policie a riziko / Herní objekt / Typy / Zóna",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Herní objekt / Typy / Zóna.",
                },
                drugAdvancedHeatEventCooldownMinutes = {
                    label = "Pozornost policie a riziko / Událost / Minuty prodlevy",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Událost / Minuty prodlevy.",
                },
                drugAdvancedHeatEventHistoryLimit = {
                    label = "Pozornost policie a riziko / Událost / Limit historie",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Událost / Limit historie.",
                },
                drugAdvancedHeatLabHeatSyncThreshold = {
                    label = "Pozornost policie a riziko / Laboratoř / Policejní tlak / Synchronizace / Práh",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Laboratoř / Policejní tlak / Synchronizace / Práh.",
                },
                drugAdvancedHeatLayLowCooldownMinutes = {
                    label = "Pozornost policie a riziko / Držet se v ústraní / Minuty prodlevy",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Držet se v ústraní / Minuty prodlevy.",
                },
                drugAdvancedHeatLayLowIdleMinutes = {
                    label = "Pozornost policie a riziko / Držet se v ústraní / Nečinný / Minuty",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Držet se v ústraní / Nečinný / Minuty.",
                },
                drugAdvancedHeatLayLowReduction = {
                    label = "Pozornost policie a riziko / Držet se v ústraní / Snížení",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Držet se v ústraní / Snížení.",
                },
                drugAdvancedHeatLockdownMinutes = {
                    label = "Pozornost policie a riziko / Uzavření / Minuty",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Uzavření / Minuty.",
                },
                drugAdvancedHeatMinimumDurationMinutes = {
                    label = "Pozornost policie a riziko / Minimum / Doba trvání / Minuty",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Minimum / Doba trvání / Minuty.",
                },
                drugAdvancedHeatMinimumEventCooldownSeconds = {
                    label = "Pozornost policie a riziko / Minimum / Událost / Dočasné omezení (sekundy)",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Minimum / Událost / Dočasné omezení (sekundy).",
                },
                drugAdvancedHeatMinimumIdleSeconds = {
                    label = "Pozornost policie a riziko / Minimum / Nečinný / sekundů",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Minimum / Nečinný / sekundů.",
                },
                drugAdvancedHeatProcessingHeatMultiplier = {
                    label = "Pozornost policie a riziko / Zpracování / Policejní tlak / Násobitel",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Zpracování / Policejní tlak / Násobitel.",
                },
                drugAdvancedHeatRiskWeightsBatch = {
                    label = "Pozornost policie a riziko / Riziko / Váhy / Šarže",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Riziko / Váhy / Šarže.",
                },
                drugAdvancedHeatRiskWeightsCamper = {
                    label = "Pozornost policie a riziko / Riziko / Váhy / Kemp",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Riziko / Váhy / Kemp.",
                },
                drugAdvancedHeatRiskWeightsDealer = {
                    label = "Pozornost policie a riziko / Riziko / Váhy / Dealer",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Riziko / Váhy / Dealer.",
                },
                drugAdvancedHeatRiskWeightsFaction = {
                    label = "Pozornost policie a riziko / Riziko / Váhy / Frakce",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Riziko / Váhy / Frakce.",
                },
                drugAdvancedHeatRiskWeightsHub = {
                    label = "Pozornost policie a riziko / Riziko / Váhy / Distribuční centrum",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Riziko / Váhy / Distribuční centrum.",
                },
                drugAdvancedHeatRiskWeightsLab = {
                    label = "Pozornost policie a riziko / Riziko / Váhy / Laboratoř",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Riziko / Váhy / Laboratoř.",
                },
                drugAdvancedHeatRiskWeightsPlayer = {
                    label = "Pozornost policie a riziko / Riziko / Váhy / Hráč",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Riziko / Váhy / Hráč.",
                },
                drugAdvancedHeatRiskWeightsRoute = {
                    label = "Pozornost policie a riziko / Riziko / Váhy / Trasa",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Riziko / Váhy / Trasa.",
                },
                drugAdvancedHeatRiskWeightsZone = {
                    label = "Pozornost policie a riziko / Riziko / Váhy / Zóna",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Riziko / Váhy / Zóna.",
                },
                drugAdvancedHeatRotateBurnerReduction = {
                    label = "Pozornost policie a riziko / Vyměnit jednorázový telefon / Snížení",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Vyměnit jednorázový telefon / Snížení.",
                },
                drugAdvancedHeatRouteControlMinutes = {
                    label = "Pozornost policie a riziko / Trasa / Ovládání / Minuty",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Trasa / Ovládání / Minuty.",
                },
                drugAdvancedHeatSaleHeatBatch = {
                    label = "Pozornost policie a riziko / Prodej / Policejní tlak / Šarže",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Prodej / Policejní tlak / Šarže.",
                },
                drugAdvancedHeatSaleHeatCamper = {
                    label = "Pozornost policie a riziko / Prodej / Policejní tlak / Kemp",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Prodej / Policejní tlak / Kemp.",
                },
                drugAdvancedHeatSaleHeatDealer = {
                    label = "Pozornost policie a riziko / Prodej / Policejní tlak / Dealer",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Prodej / Policejní tlak / Dealer.",
                },
                drugAdvancedHeatSaleHeatFaction = {
                    label = "Pozornost policie a riziko / Prodej / Policejní tlak / Frakce",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Prodej / Policejní tlak / Frakce.",
                },
                drugAdvancedHeatSaleHeatHub = {
                    label = "Pozornost policie a riziko / Prodej / Policejní tlak / Distribuční centrum",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Prodej / Policejní tlak / Distribuční centrum.",
                },
                drugAdvancedHeatSaleHeatLab = {
                    label = "Pozornost policie a riziko / Prodej / Policejní tlak / Laboratoř",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Prodej / Policejní tlak / Laboratoř.",
                },
                drugAdvancedHeatSaleHeatPlayer = {
                    label = "Pozornost policie a riziko / Prodej / Policejní tlak / Hráč",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Prodej / Policejní tlak / Hráč.",
                },
                drugAdvancedHeatSaleHeatRoute = {
                    label = "Pozornost policie a riziko / Prodej / Policejní tlak / Trasa",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Prodej / Policejní tlak / Trasa.",
                },
                drugAdvancedHeatSaleHeatZone = {
                    label = "Pozornost policie a riziko / Prodej / Policejní tlak / Zóna",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Prodej / Policejní tlak / Zóna.",
                },
                drugAdvancedHeatThresholdsCritical = {
                    label = "Pozornost policie a riziko / Prahy / Kritické",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Prahy / Kritické.",
                },
                drugAdvancedHeatThresholdsHigh = {
                    label = "Pozornost policie a riziko / Prahy / Vysoká",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Prahy / Vysoká.",
                },
                drugAdvancedHeatThresholdsLockdown = {
                    label = "Pozornost policie a riziko / Prahy / Uzavření",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Prahy / Uzavření.",
                },
                drugAdvancedHeatThresholdsLow = {
                    label = "Pozornost policie a riziko / Prahy / Nízká",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Prahy / Nízká.",
                },
                drugAdvancedHeatThresholdsMedium = {
                    label = "Pozornost policie a riziko / Prahy / Střední",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Prahy / Střední.",
                },
                drugAdvancedHeatTickMinutes = {
                    label = "Pozornost policie a riziko / Aktualizační cyklus / Minuty",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Aktualizační cyklus / Minuty.",
                },
                drugAdvancedHeatWholesaleHeatMultiplier = {
                    label = "Pozornost policie a riziko / Velkoobchod / Policejní tlak / Násobitel",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Velkoobchod / Policejní tlak / Násobitel.",
                },
                drugAdvancedHeatWorkerLeakAlertRadius = {
                    label = "Pozornost policie a riziko / Pracovník / Únik informací / Radius poplachu",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Radius poplachu.",
                },
                drugAdvancedHeatWorkerLeakBaseChance = {
                    label = "Pozornost policie a riziko / Pracovník / Únik informací / Základní hodnota / Šance",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Základní hodnota / Šance.",
                },
                drugAdvancedHeatWorkerLeakFactionMultiplier = {
                    label = "Pozornost policie a riziko / Pracovník / Únik informací / Frakce / Násobitel",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Frakce / Násobitel.",
                },
                drugAdvancedHeatWorkerLeakHighSeverityThreshold = {
                    label = "Pozornost policie a riziko / Pracovník / Únik informací / Vysoká / Závažnost / Práh",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Vysoká / Závažnost / Práh.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Pozornost policie a riziko / Pracovník / Únik informací / Lojalita / Šance / Násobitel",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Lojalita / Šance / Násobitel.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyThreshold = {
                    label = "Pozornost policie a riziko / Pracovník / Únik informací / Lojalita / Práh",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Lojalita / Práh.",
                },
                drugAdvancedHeatWorkerLeakMaximumChance = {
                    label = "Pozornost policie a riziko / Pracovník / Únik informací / Maximum / Šance",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Maximum / Šance.",
                },
                drugAdvancedHeatWorkerLeakMinimumCooldownSeconds = {
                    label = "Pozornost policie a riziko / Pracovník / Únik informací / Minimum / Dočasné omezení (sekundy)",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Minimum / Dočasné omezení (sekundy).",
                },
                drugAdvancedHeatWorkerLeakRouteMultiplier = {
                    label = "Pozornost policie a riziko / Pracovník / Únik informací / Trasa / Násobitel",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Trasa / Násobitel.",
                },
                drugAdvancedHeatWorkerLeakStrengthMaximum = {
                    label = "Pozornost policie a riziko / Pracovník / Únik informací / Síla / Maximum",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Síla / Maximum.",
                },
                drugAdvancedHeatWorkerLeakStrengthMinimum = {
                    label = "Pozornost policie a riziko / Pracovník / Únik informací / Síla / Minimum",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Síla / Minimum.",
                },
                drugAdvancedHeatWorkerLeakStrengthMultiplier = {
                    label = "Pozornost policie a riziko / Pracovník / Únik informací / Síla / Násobitel",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Síla / Násobitel.",
                },
                drugAdvancedHeatWorkerLeakStressChanceMultiplier = {
                    label = "Pozornost policie a riziko / Pracovník / Únik informací / Stres / Šance / Násobitel",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Stres / Šance / Násobitel.",
                },
                drugAdvancedHeatWorkerLeakStressThreshold = {
                    label = "Pozornost policie a riziko / Pracovník / Únik informací / Stres / Práh",
                    description = "Provozní nastavení pro: Pozornost policie a riziko / Pracovník / Únik informací / Stres / Práh.",
                },
                drugAdvancedContactNetworkActionCooldownSeconds = {
                    label = "Síť kontaktů / Cooldown akce / sekundů",
                    description = "Provozní nastavení pro: Síť kontaktů / Cooldown akce / sekundů.",
                },
                drugAdvancedContactNetworkActiveHotspotCount = {
                    label = "Síť kontaktů / Počet aktivních ohnisek",
                    description = "Provozní nastavení pro: Síť kontaktů / Počet aktivních ohnisek.",
                },
                drugAdvancedContactNetworkBurnerHintTrust = {
                    label = "Síť kontaktů / Tip pro burner / Důvěra",
                    description = "Provozní nastavení pro: Síť kontaktů / Tip pro burner / Důvěra.",
                },
                drugAdvancedContactNetworkBurnerOfferMaximumMultiplier = {
                    label = "Síť kontaktů / Jednorázový telefon / Nabídka / Maximum / Násobitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Jednorázový telefon / Nabídka / Maximum / Násobitel.",
                },
                drugAdvancedContactNetworkBurnerOfferMinimumMultiplier = {
                    label = "Síť kontaktů / Jednorázový telefon / Nabídka / Minimum / Násobitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Jednorázový telefon / Nabídka / Minimum / Násobitel.",
                },
                drugAdvancedContactNetworkBuyerCooldownMinutes = {
                    label = "Síť kontaktů / Kupec / Minuty prodlevy",
                    description = "Provozní nastavení pro: Síť kontaktů / Kupec / Minuty prodlevy.",
                },
                drugAdvancedContactNetworkBuyerDeliveryDistance = {
                    label = "Síť kontaktů / Kupec / Vzdálenost doručení",
                    description = "Provozní nastavení pro: Síť kontaktů / Kupec / Vzdálenost doručení.",
                },
                drugAdvancedContactNetworkBuyerPremiumSuccessScore = {
                    label = "Síť kontaktů / Kupec / Prémiové / Úspěch / Skóre",
                    description = "Provozní nastavení pro: Síť kontaktů / Kupec / Prémiové / Úspěch / Skóre.",
                },
                drugAdvancedContactNetworkBuyerPremiumTrustGain = {
                    label = "Síť kontaktů / Kupec / Prémiové / Důvěra / zisk",
                    description = "Provozní nastavení pro: Síť kontaktů / Kupec / Prémiové / Důvěra / zisk.",
                },
                drugAdvancedContactNetworkBuyerRequestHeatRiskWeight = {
                    label = "Síť kontaktů / Kupec / Požadavek / Hledanost a riziko / Hmotnost",
                    description = "Provozní nastavení pro: Síť kontaktů / Kupec / Požadavek / Hledanost a riziko / Hmotnost.",
                },
                drugAdvancedContactNetworkBuyerStandardTrustGain = {
                    label = "Síť kontaktů / Kupec / Standardní / Důvěra / zisk",
                    description = "Provozní nastavení pro: Síť kontaktů / Kupec / Standardní / Důvěra / zisk.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMax = {
                    label = "Síť kontaktů / Prodleva aktivace kontaktu / sekundů / Maximum",
                    description = "Provozní nastavení pro: Síť kontaktů / Prodleva aktivace kontaktu / sekundů / Maximum.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMin = {
                    label = "Síť kontaktů / Prodleva aktivace kontaktu / sekundů / Minimum",
                    description = "Provozní nastavení pro: Síť kontaktů / Prodleva aktivace kontaktu / sekundů / Minimum.",
                },
                drugAdvancedContactNetworkContactDemandRangeMax = {
                    label = "Síť kontaktů / Contact / Poptávka / Rozsah hodnot / Maximum",
                    description = "Provozní nastavení pro: Síť kontaktů / Contact / Poptávka / Rozsah hodnot / Maximum.",
                },
                drugAdvancedContactNetworkContactDemandRangeMin = {
                    label = "Síť kontaktů / Contact / Poptávka / Rozsah hodnot / Minimum",
                    description = "Provozní nastavení pro: Síť kontaktů / Contact / Poptávka / Rozsah hodnot / Minimum.",
                },
                drugAdvancedContactNetworkContactLossTrust = {
                    label = "Síť kontaktů / Contact / Ztráta / Důvěra",
                    description = "Provozní nastavení pro: Síť kontaktů / Contact / Ztráta / Důvěra.",
                },
                drugAdvancedContactNetworkDarknetExactIntelMinutes = {
                    label = "Síť kontaktů / Darknet / Přesné informace / Minuty",
                    description = "Provozní nastavení pro: Síť kontaktů / Darknet / Přesné informace / Minuty.",
                },
                drugAdvancedContactNetworkDarknetHotspotIntelPrice = {
                    label = "Síť kontaktů / Darknet / Aktivní oblast / Informace / Cena",
                    description = "Provozní nastavení pro: Síť kontaktů / Darknet / Aktivní oblast / Informace / Cena.",
                },
                drugAdvancedContactNetworkDarknetIntelPrice = {
                    label = "Síť kontaktů / Darknet / Informace / Cena",
                    description = "Provozní nastavení pro: Síť kontaktů / Darknet / Informace / Cena.",
                },
                drugAdvancedContactNetworkDealerBasePrice = {
                    label = "Síť kontaktů / Dealer / Základní cena",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Základní cena.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMax = {
                    label = "Síť kontaktů / Dealer / Najmutí / kapacita / Maximum",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Najmutí / kapacita / Maximum.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMin = {
                    label = "Síť kontaktů / Dealer / Najmutí / kapacita / Minimum",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Najmutí / kapacita / Minimum.",
                },
                drugAdvancedContactNetworkDealerHireRiskMax = {
                    label = "Síť kontaktů / Dealer / Najmutí / Riziko / Maximum",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Najmutí / Riziko / Maximum.",
                },
                drugAdvancedContactNetworkDealerHireRiskMin = {
                    label = "Síť kontaktů / Dealer / Najmutí / Riziko / Minimum",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Najmutí / Riziko / Minimum.",
                },
                drugAdvancedContactNetworkDealerHireSkillMax = {
                    label = "Síť kontaktů / Dealer / Najmutí / Dovednost / Maximum",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Najmutí / Dovednost / Maximum.",
                },
                drugAdvancedContactNetworkDealerHireSkillMin = {
                    label = "Síť kontaktů / Dealer / Najmutí / Dovednost / Minimum",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Najmutí / Dovednost / Minimum.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Id = {
                    label = "Síť kontaktů / Nabídky dealerů / 1 / ID",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 1 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Item = {
                    label = "Síť kontaktů / Nabídky dealerů / 1 / Předmět",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 1 / Předmět.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Label = {
                    label = "Síť kontaktů / Nabídky dealerů / 1 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 1 / Štítek.",
                },
                drugAdvancedContactNetworkDealerOffersItem1MinTrust = {
                    label = "Síť kontaktů / Nabídky dealerů / 1 / Minimální důvěra",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 1 / Minimální důvěra.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Price = {
                    label = "Síť kontaktů / Nabídky dealerů / 1 / Cena",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 1 / Cena.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Id = {
                    label = "Síť kontaktů / Nabídky dealerů / 2 / ID",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 2 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Item = {
                    label = "Síť kontaktů / Nabídky dealerů / 2 / Předmět",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 2 / Předmět.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Label = {
                    label = "Síť kontaktů / Nabídky dealerů / 2 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 2 / Štítek.",
                },
                drugAdvancedContactNetworkDealerOffersItem2MinTrust = {
                    label = "Síť kontaktů / Nabídky dealerů / 2 / Minimální důvěra",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 2 / Minimální důvěra.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Price = {
                    label = "Síť kontaktů / Nabídky dealerů / 2 / Cena",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 2 / Cena.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Id = {
                    label = "Síť kontaktů / Nabídky dealerů / 3 / ID",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 3 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Item = {
                    label = "Síť kontaktů / Nabídky dealerů / 3 / Předmět",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 3 / Předmět.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Label = {
                    label = "Síť kontaktů / Nabídky dealerů / 3 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 3 / Štítek.",
                },
                drugAdvancedContactNetworkDealerOffersItem3MinTrust = {
                    label = "Síť kontaktů / Nabídky dealerů / 3 / Minimální důvěra",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 3 / Minimální důvěra.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Price = {
                    label = "Síť kontaktů / Nabídky dealerů / 3 / Cena",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 3 / Cena.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Id = {
                    label = "Síť kontaktů / Nabídky dealerů / 4 / ID",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 4 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Item = {
                    label = "Síť kontaktů / Nabídky dealerů / 4 / Předmět",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 4 / Předmět.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Label = {
                    label = "Síť kontaktů / Nabídky dealerů / 4 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 4 / Štítek.",
                },
                drugAdvancedContactNetworkDealerOffersItem4MinTrust = {
                    label = "Síť kontaktů / Nabídky dealerů / 4 / Minimální důvěra",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 4 / Minimální důvěra.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Price = {
                    label = "Síť kontaktů / Nabídky dealerů / 4 / Cena",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 4 / Cena.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Id = {
                    label = "Síť kontaktů / Nabídky dealerů / 5 / ID",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 5 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Item = {
                    label = "Síť kontaktů / Nabídky dealerů / 5 / Předmět",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 5 / Předmět.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Label = {
                    label = "Síť kontaktů / Nabídky dealerů / 5 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 5 / Štítek.",
                },
                drugAdvancedContactNetworkDealerOffersItem5MinTrust = {
                    label = "Síť kontaktů / Nabídky dealerů / 5 / Minimální důvěra",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 5 / Minimální důvěra.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Price = {
                    label = "Síť kontaktů / Nabídky dealerů / 5 / Cena",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídky dealerů / 5 / Cena.",
                },
                drugAdvancedContactNetworkDealerProtectionHours = {
                    label = "Síť kontaktů / Dealer / Ochrana / Hodiny",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Ochrana / Hodiny.",
                },
                drugAdvancedContactNetworkDealerProtectionPrice = {
                    label = "Síť kontaktů / Dealer / Ochrana / Cena",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Ochrana / Cena.",
                },
                drugAdvancedContactNetworkDealerSaleMax = {
                    label = "Síť kontaktů / Dealer / Prodej / Maximum",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Prodej / Maximum.",
                },
                drugAdvancedContactNetworkDealerSaleMin = {
                    label = "Síť kontaktů / Dealer / Prodej / Minimum",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Prodej / Minimum.",
                },
                drugAdvancedContactNetworkDealerSimulationAggressivePriceMultiplier = {
                    label = "Síť kontaktů / Dealer / Simulace / Agresivní režim / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Agresivní režim / Násobitel ceny.",
                },
                drugAdvancedContactNetworkDealerSimulationBaseQualityPriceFactor = {
                    label = "Síť kontaktů / Dealer / Simulace / Základní kvalita / Cenový faktor",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Základní kvalita / Cenový faktor.",
                },
                drugAdvancedContactNetworkDealerSimulationBulkPriceMultiplier = {
                    label = "Síť kontaktů / Dealer / Simulace / Velké množství / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Velké množství / Násobitel ceny.",
                },
                drugAdvancedContactNetworkDealerSimulationCheapPriceMultiplier = {
                    label = "Síť kontaktů / Dealer / Simulace / Levný prodej / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Levný prodej / Násobitel ceny.",
                },
                drugAdvancedContactNetworkDealerSimulationDefaultQuality = {
                    label = "Síť kontaktů / Dealer / Simulace / Výchozí hodnota / Kvalita",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Výchozí hodnota / Kvalita.",
                },
                drugAdvancedContactNetworkDealerSimulationDisloyalThreshold = {
                    label = "Síť kontaktů / Dealer / Simulace / Práh neloajality",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Práh neloajality.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerLevel = {
                    label = "Síť kontaktů / Dealer / Simulace / Zkušenosti / Za úroveň",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Zkušenosti / Za úroveň.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerUnit = {
                    label = "Síť kontaktů / Dealer / Simulace / Zkušenosti / Za jednotku",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Zkušenosti / Za jednotku.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentLoyaltyLoss = {
                    label = "Síť kontaktů / Dealer / Simulace / Incident / Lojalita / Ztráta",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Incident / Lojalita / Ztráta.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentRollMaximum = {
                    label = "Síť kontaktů / Dealer / Simulace / Incident / Náhodná kontrola / Maximum",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Incident / Náhodná kontrola / Maximum.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelPriceBonus = {
                    label = "Síť kontaktů / Dealer / Simulace / Úroveň / Cena / Bonus",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Úroveň / Cena / Bonus.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelSaleDivisor = {
                    label = "Síť kontaktů / Dealer / Simulace / Úroveň / Prodej / Dělitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Úroveň / Prodej / Dělitel.",
                },
                drugAdvancedContactNetworkDealerSimulationLoyaltyRiskWeight = {
                    label = "Síť kontaktů / Dealer / Simulace / Lojalita / Riziko / Hmotnost",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Lojalita / Riziko / Hmotnost.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumIncidentChance = {
                    label = "Síť kontaktů / Dealer / Simulace / Maximum / Incident / Šance",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Maximum / Incident / Šance.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumLevel = {
                    label = "Síť kontaktů / Dealer / Simulace / Maximum / Úroveň",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Maximum / Úroveň.",
                },
                drugAdvancedContactNetworkDealerSimulationPremiumPriceMultiplier = {
                    label = "Síť kontaktů / Dealer / Simulace / Prémiové / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Prémiové / Násobitel ceny.",
                },
                drugAdvancedContactNetworkDealerSimulationProfileRiskWeight = {
                    label = "Síť kontaktů / Dealer / Simulace / Profil / Riziko / Hmotnost",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Profil / Riziko / Hmotnost.",
                },
                drugAdvancedContactNetworkDealerSimulationProtectionRiskReduction = {
                    label = "Síť kontaktů / Dealer / Simulace / Ochrana / Riziko / Snížení",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Ochrana / Riziko / Snížení.",
                },
                drugAdvancedContactNetworkDealerSimulationQualityPriceDivisor = {
                    label = "Síť kontaktů / Dealer / Simulace / Kvalita / Cena / Dělitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Kvalita / Cena / Dělitel.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryBaseChance = {
                    label = "Síť kontaktů / Dealer / Simulace / Zotavení / Základní hodnota / Šance",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Zotavení / Základní hodnota / Šance.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryLoyaltyWeight = {
                    label = "Síť kontaktů / Dealer / Simulace / Zotavení / Lojalita / Hmotnost",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Zotavení / Lojalita / Hmotnost.",
                },
                drugAdvancedContactNetworkDealerSimulationRobbedStockLoss = {
                    label = "Síť kontaktů / Dealer / Simulace / Ztráta zásob při loupeži",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Ztráta zásob při loupeži.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillRiskReduction = {
                    label = "Síť kontaktů / Dealer / Simulace / Dovednost / Riziko / Snížení",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Dovednost / Riziko / Snížení.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillSaleDivisor = {
                    label = "Síť kontaktů / Dealer / Simulace / Dovednost / Prodej / Dělitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Dovednost / Prodej / Dělitel.",
                },
                drugAdvancedContactNetworkDealerSimulationStableLoyaltyThreshold = {
                    label = "Síť kontaktů / Dealer / Simulace / Práh stabilní loajality",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Práh stabilní loajality.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryPriceMultiplier = {
                    label = "Síť kontaktů / Dealer / Simulace / Území / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Území / Násobitel ceny.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryRiskReduction = {
                    label = "Síť kontaktů / Dealer / Simulace / Území / Riziko / Snížení",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Simulace / Území / Riziko / Snížení.",
                },
                drugAdvancedContactNetworkDealerTickMinutes = {
                    label = "Síť kontaktů / Dealer / Aktualizační cyklus / Minuty",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Aktualizační cyklus / Minuty.",
                },
                drugAdvancedContactNetworkDealerWage = {
                    label = "Síť kontaktů / Dealer / Mzdové platy",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Mzdové platy.",
                },
                drugAdvancedContactNetworkDealerWageDecay = {
                    label = "Síť kontaktů / Dealer / Mzdové platy / Degradace",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Mzdové platy / Degradace.",
                },
                drugAdvancedContactNetworkDealerWageLoyaltyGain = {
                    label = "Síť kontaktů / Dealer / Mzdové platy / Lojalita / zisk",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Mzdové platy / Lojalita / zisk.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem1 = {
                    label = "Síť kontaktů / Dealer / Slabiny / 1",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Slabiny / 1.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem2 = {
                    label = "Síť kontaktů / Dealer / Slabiny / 2",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Slabiny / 2.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem3 = {
                    label = "Síť kontaktů / Dealer / Slabiny / 3",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Slabiny / 3.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem4 = {
                    label = "Síť kontaktů / Dealer / Slabiny / 4",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Slabiny / 4.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem5 = {
                    label = "Síť kontaktů / Dealer / Slabiny / 5",
                    description = "Provozní nastavení pro: Síť kontaktů / Dealer / Slabiny / 5.",
                },
                drugAdvancedContactNetworkDefaultContactDemand = {
                    label = "Síť kontaktů / Výchozí hodnota / Contact / Poptávka",
                    description = "Provozní nastavení pro: Síť kontaktů / Výchozí hodnota / Contact / Poptávka.",
                },
                drugAdvancedContactNetworkDefaultContactRisk = {
                    label = "Síť kontaktů / Výchozí hodnota / Contact / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Výchozí hodnota / Contact / Riziko.",
                },
                drugAdvancedContactNetworkDefaultDealerCapacity = {
                    label = "Síť kontaktů / Výchozí dealer / kapacita",
                    description = "Provozní nastavení pro: Síť kontaktů / Výchozí dealer / kapacita.",
                },
                drugAdvancedContactNetworkDefaultDealerRisk = {
                    label = "Síť kontaktů / Výchozí dealer / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Výchozí dealer / Riziko.",
                },
                drugAdvancedContactNetworkDefaultDealerSkill = {
                    label = "Síť kontaktů / Výchozí dealer / Dovednost",
                    description = "Provozní nastavení pro: Síť kontaktů / Výchozí dealer / Dovednost.",
                },
                drugAdvancedContactNetworkDefaultHotspotRadius = {
                    label = "Síť kontaktů / Výchozí hodnota / Aktivní oblast / Poloměr",
                    description = "Provozní nastavení pro: Síť kontaktů / Výchozí hodnota / Aktivní oblast / Poloměr.",
                },
                drugAdvancedContactNetworkDemandResetMinutes = {
                    label = "Síť kontaktů / Reset poptávky (minuty)",
                    description = "Provozní nastavení pro: Síť kontaktů / Reset poptávky (minuty).",
                },
                drugAdvancedContactNetworkEnabled = {
                    label = "Síť kontaktů / Aktivováno",
                    description = "Provozní nastavení pro: Síť kontaktů / Aktivováno.",
                },
                drugAdvancedContactNetworkExactLocationTrust = {
                    label = "Síť kontaktů / Přesná poloha / Důvěra",
                    description = "Provozní nastavení pro: Síť kontaktů / Přesná poloha / Důvěra.",
                },
                drugAdvancedContactNetworkFactionDiscoveryReputation = {
                    label = "Síť kontaktů / Frakce / Objevení / Reputace",
                    description = "Provozní nastavení pro: Síť kontaktů / Frakce / Objevení / Reputace.",
                },
                drugAdvancedContactNetworkFactionHintTrust = {
                    label = "Síť kontaktů / Frakce / Nápověda / Důvěra",
                    description = "Provozní nastavení pro: Síť kontaktů / Frakce / Nápověda / Důvěra.",
                },
                drugAdvancedContactNetworkFailedDeliveryCooldownMinutes = {
                    label = "Síť kontaktů / Neúspěšná dodávka / Minuty prodlevy",
                    description = "Provozní nastavení pro: Síť kontaktů / Neúspěšná dodávka / Minuty prodlevy.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerCount = {
                    label = "Síť kontaktů / Falešný obchod / Setkání / Útočník / Počet",
                    description = "Provozní nastavení pro: Síť kontaktů / Falešný obchod / Setkání / Útočník / Počet.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem1 = {
                    label = "Síť kontaktů / Falešný obchod / Setkání / Útočník / Modely / 1",
                    description = "Provozní nastavení pro: Síť kontaktů / Falešný obchod / Setkání / Útočník / Modely / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem2 = {
                    label = "Síť kontaktů / Falešný obchod / Setkání / Útočník / Modely / 2",
                    description = "Provozní nastavení pro: Síť kontaktů / Falešný obchod / Setkání / Útočník / Modely / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem3 = {
                    label = "Síť kontaktů / Falešný obchod / Setkání / Útočník / Modely / 3",
                    description = "Provozní nastavení pro: Síť kontaktů / Falešný obchod / Setkání / Útočník / Modely / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterDurationSeconds = {
                    label = "Síť kontaktů / Falešný obchod / Setkání / Doba trvání (sekundy)",
                    description = "Provozní nastavení pro: Síť kontaktů / Falešný obchod / Setkání / Doba trvání (sekundy).",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem1 = {
                    label = "Síť kontaktů / Falešný obchod / Setkání / Policie / Modely / 1",
                    description = "Provozní nastavení pro: Síť kontaktů / Falešný obchod / Setkání / Policie / Modely / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem2 = {
                    label = "Síť kontaktů / Falešný obchod / Setkání / Policie / Modely / 2",
                    description = "Provozní nastavení pro: Síť kontaktů / Falešný obchod / Setkání / Policie / Modely / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem3 = {
                    label = "Síť kontaktů / Falešný obchod / Setkání / Policie / Modely / 3",
                    description = "Provozní nastavení pro: Síť kontaktů / Falešný obchod / Setkání / Policie / Modely / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterSpawnRadius = {
                    label = "Síť kontaktů / Falešný obchod / Setkání / Radius spawnu",
                    description = "Provozní nastavení pro: Síť kontaktů / Falešný obchod / Setkání / Radius spawnu.",
                },
                drugAdvancedContactNetworkFallbackPreferredDrug = {
                    label = "Síť kontaktů / Náhradní hodnota / Preferovaná droga",
                    description = "Provozní nastavení pro: Síť kontaktů / Náhradní hodnota / Preferovaná droga.",
                },
                drugAdvancedContactNetworkFallbackProductLabel = {
                    label = "Síť kontaktů / Náhradní hodnota / Název produktu",
                    description = "Provozní nastavení pro: Síť kontaktů / Náhradní hodnota / Název produktu.",
                },
                drugAdvancedContactNetworkGuideBookItem = {
                    label = "Síť kontaktů / Průvodce / Kniha / Předmět",
                    description = "Provozní nastavení pro: Síť kontaktů / Průvodce / Kniha / Předmět.",
                },
                drugAdvancedContactNetworkGuideBookTrust = {
                    label = "Síť kontaktů / Průvodce / Kniha / Důvěra",
                    description = "Provozní nastavení pro: Síť kontaktů / Průvodce / Kniha / Důvěra.",
                },
                drugAdvancedContactNetworkHireDealerPrice = {
                    label = "Síť kontaktů / Najmout dealera / Cena",
                    description = "Provozní nastavení pro: Síť kontaktů / Najmout dealera / Cena.",
                },
                drugAdvancedContactNetworkHistoryLimit = {
                    label = "Síť kontaktů / Limit historie",
                    description = "Provozní nastavení pro: Síť kontaktů / Limit historie.",
                },
                drugAdvancedContactNetworkHotspotIntelMinutes = {
                    label = "Síť kontaktů / Aktivní oblast / Informace / Minuty",
                    description = "Provozní nastavení pro: Síť kontaktů / Aktivní oblast / Informace / Minuty.",
                },
                drugAdvancedContactNetworkHotspotRotationMinutes = {
                    label = "Síť kontaktů / Aktivní oblast / Střídání / Minuty",
                    description = "Provozní nastavení pro: Síť kontaktů / Aktivní oblast / Střídání / Minuty.",
                },
                drugAdvancedContactNetworkListingDurationMinutes = {
                    label = "Síť kontaktů / Nabídka / Doba trvání / Minuty",
                    description = "Provozní nastavení pro: Síť kontaktů / Nabídka / Doba trvání / Minuty.",
                },
                drugAdvancedContactNetworkMaxOwnedDealers = {
                    label = "Síť kontaktů / Maximum / Vlastní / Dealerové",
                    description = "Provozní nastavení pro: Síť kontaktů / Maximum / Vlastní / Dealerové.",
                },
                drugAdvancedContactNetworkMinimumBuyerDeliveryDistance = {
                    label = "Síť kontaktů / Minimum / Kupec / Vzdálenost doručení",
                    description = "Provozní nastavení pro: Síť kontaktů / Minimum / Kupec / Vzdálenost doručení.",
                },
                drugAdvancedContactNetworkMinimumContactRotationMinutes = {
                    label = "Síť kontaktů / Minimum / Rotace kontaktů (minuty)",
                    description = "Provozní nastavení pro: Síť kontaktů / Minimum / Rotace kontaktů (minuty).",
                },
                drugAdvancedContactNetworkMinimumDemandResetMinutes = {
                    label = "Síť kontaktů / Minimum / Reset poptávky (minuty)",
                    description = "Provozní nastavení pro: Síť kontaktů / Minimum / Reset poptávky (minuty).",
                },
                drugAdvancedContactNetworkMinimumHeatMultiplier = {
                    label = "Síť kontaktů / Minimum / Policejní tlak / Násobitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Minimum / Policejní tlak / Násobitel.",
                },
                drugAdvancedContactNetworkMinimumHotspotIntelMinutes = {
                    label = "Síť kontaktů / Minimum / Aktivní oblast / Informace / Minuty",
                    description = "Provozní nastavení pro: Síť kontaktů / Minimum / Aktivní oblast / Informace / Minuty.",
                },
                drugAdvancedContactNetworkMinimumHotspotRadius = {
                    label = "Síť kontaktů / Minimum / Aktivní oblast / Poloměr",
                    description = "Provozní nastavení pro: Síť kontaktů / Minimum / Aktivní oblast / Poloměr.",
                },
                drugAdvancedContactNetworkMinimumHotspotRotationMinutes = {
                    label = "Síť kontaktů / Minimum / Aktivní oblast / Střídání / Minuty",
                    description = "Provozní nastavení pro: Síť kontaktů / Minimum / Aktivní oblast / Střídání / Minuty.",
                },
                drugAdvancedContactNetworkMinimumListingDurationMinutes = {
                    label = "Síť kontaktů / Minimum / Nabídka / Doba trvání / Minuty",
                    description = "Provozní nastavení pro: Síť kontaktů / Minimum / Nabídka / Doba trvání / Minuty.",
                },
                drugAdvancedContactNetworkMinimumRewardMultiplier = {
                    label = "Síť kontaktů / Minimální odměna / Násobitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Minimální odměna / Násobitel.",
                },
                drugAdvancedContactNetworkMinimumRobberyMultiplier = {
                    label = "Síť kontaktů / Minimum / Přepadení / Násobitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Minimum / Přepadení / Násobitel.",
                },
                drugAdvancedContactNetworkMinimumSpotPriceMultiplier = {
                    label = "Síť kontaktů / Minimum / Místo / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Minimum / Místo / Násobitel ceny.",
                },
                drugAdvancedContactNetworkOtherDrugPriceMultiplier = {
                    label = "Síť kontaktů / Jiný zdroj / Droga / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Jiný zdroj / Droga / Násobitel ceny.",
                },
                drugAdvancedContactNetworkPaymentAccount = {
                    label = "Síť kontaktů / Platební účet",
                    description = "Provozní nastavení pro: Síť kontaktů / Platební účet.",
                },
                drugAdvancedContactNetworkPostDeliveryDemandResetSeconds = {
                    label = "Síť kontaktů / Po dodávce / Poptávka / Reset / sekundů",
                    description = "Provozní nastavení pro: Síť kontaktů / Po dodávce / Poptávka / Reset / sekundů.",
                },
                drugAdvancedContactNetworkPreferredDrugPriceMultiplier = {
                    label = "Síť kontaktů / Preferovaná droga / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Preferovaná droga / Násobitel ceny.",
                },
                drugAdvancedContactNetworkRegionLocationTrust = {
                    label = "Síť kontaktů / Region / Poloha / Důvěra",
                    description = "Provozní nastavení pro: Síť kontaktů / Region / Poloha / Důvěra.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMax = {
                    label = "Síť kontaktů / Požadavek / Množství / Velké množství / Maximum",
                    description = "Provozní nastavení pro: Síť kontaktů / Požadavek / Množství / Velké množství / Maximum.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMin = {
                    label = "Síť kontaktů / Požadavek / Množství / Velké množství / Minimum",
                    description = "Provozní nastavení pro: Síť kontaktů / Požadavek / Množství / Velké množství / Minimum.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMax = {
                    label = "Síť kontaktů / Požadavek / Množství / Prémiové / Maximum",
                    description = "Provozní nastavení pro: Síť kontaktů / Požadavek / Množství / Prémiové / Maximum.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMin = {
                    label = "Síť kontaktů / Požadavek / Množství / Prémiové / Minimum",
                    description = "Provozní nastavení pro: Síť kontaktů / Požadavek / Množství / Prémiové / Minimum.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMax = {
                    label = "Síť kontaktů / Požadavek / Množství / Standardní / Maximum",
                    description = "Provozní nastavení pro: Síť kontaktů / Požadavek / Množství / Standardní / Maximum.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMin = {
                    label = "Síť kontaktů / Požadavek / Množství / Standardní / Minimum",
                    description = "Provozní nastavení pro: Síť kontaktů / Požadavek / Množství / Standardní / Minimum.",
                },
                drugAdvancedContactNetworkRotationMinutes = {
                    label = "Síť kontaktů / Střídání / Minuty",
                    description = "Provozní nastavení pro: Síť kontaktů / Střídání / Minuty.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 1 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 1 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 1 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 1 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 1 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 1 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 1 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 1 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 1 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 1 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 1 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 1 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 1 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 1 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 1 / Riziko.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 2 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 2 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 2 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 2 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 2 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 2 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 2 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 2 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 2 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 2 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 2 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 2 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 2 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 2 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 2 / Riziko.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 3 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 3 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 3 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 3 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 3 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 3 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 3 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 3 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 3 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 3 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 3 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 3 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 3 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 3 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Pouliční dealer / 3 / Riziko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 1 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 1 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 1 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 1 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 1 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 1 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 1 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 1 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 1 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 1 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 1 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 1 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 1 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 1 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 1 / Riziko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 2 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 2 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 2 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 2 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 2 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 2 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 2 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 2 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 2 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 2 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 2 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 2 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 2 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 2 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 2 / Riziko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 3 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 3 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 3 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 3 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 3 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 3 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 3 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 3 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 3 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 3 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 3 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 3 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 3 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 3 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí kupující / 3 / Riziko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 1 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 1 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 1 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 1 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 1 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 1 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 1 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 1 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 1 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 1 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 1 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 1 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 1 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 1 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 1 / Riziko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 2 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 2 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 2 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 2 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 2 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 2 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 2 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 2 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 2 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 2 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 2 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 2 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 2 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 2 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 2 / Riziko.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 3 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 3 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 3 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 3 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 3 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 3 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 3 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 3 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 3 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 3 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 3 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 3 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 3 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 3 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Výchozí dealer / 3 / Riziko.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 1 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 1 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 1 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 1 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 1 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 1 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 1 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 1 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 1 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 1 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 1 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 1 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 1 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 1 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 1 / Riziko.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 2 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 2 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 2 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 2 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 2 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 2 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 2 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 2 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 2 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 2 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 2 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 2 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 2 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 2 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 2 / Riziko.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 3 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 3 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 3 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 3 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 3 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 3 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 3 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 3 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 3 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 3 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 3 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 3 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 3 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 3 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Dealer sítě / 3 / Riziko.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 1 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 1 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 1 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 1 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 1 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 1 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 1 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 1 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 1 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 1 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 1 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 1 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 1 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 1 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 1 / Riziko.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 2 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 2 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 2 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 2 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 2 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 2 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 2 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 2 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 2 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 2 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 2 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 2 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 2 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 2 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 2 / Riziko.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 3 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 3 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 3 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 3 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 3 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 3 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 3 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 3 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 3 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 3 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 3 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 3 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 3 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 3 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Prémiový zprostředkovatel / 3 / Riziko.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 1 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 1 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 1 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 1 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 1 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 1 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 1 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 1 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 1 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 1 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 1 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 1 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 1 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 1 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 1 / Riziko.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 2 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 2 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 2 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 2 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 2 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 2 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 2 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 2 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 2 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 2 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 2 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 2 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 2 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 2 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 2 / Riziko.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsX = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 3 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 3 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsY = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 3 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 3 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsZ = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 3 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 3 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsW = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 3 / Souřadnice / W",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 3 / Souřadnice / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Label = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 3 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 3 / Štítek.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3PriceMultiplier = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 3 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 3 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Region = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 3 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Risk = {
                    label = "Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 3 / Riziko",
                    description = "Provozní nastavení pro: Síť kontaktů / Místo / Výběrové skupiny / Velkoobchodní kontakt / 3 / Riziko.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1AcceptBonus = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 1 / Bonus za přijetí",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 1 / Bonus za přijetí.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Archetype = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 1 / Archetyp",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 1 / Archetyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsX = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 1 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 1 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsY = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 1 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 1 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsZ = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 1 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 1 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1DemandBonus = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 1 / Bonus poptávky",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 1 / Bonus poptávky.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1HeatMultiplier = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 1 / Policejní tlak / Násobitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 1 / Policejní tlak / Násobitel.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Id = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 1 / ID",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 1 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Label = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 1 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 1 / Štítek.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem1 = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 1 / Preferované drogy / 1",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 1 / Preferované drogy / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem2 = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 1 / Preferované drogy / 2",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 1 / Preferované drogy / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem3 = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 1 / Preferované drogy / 3",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 1 / Preferované drogy / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem4 = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 1 / Preferované drogy / 4",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 1 / Preferované drogy / 4.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PriceMultiplier = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 1 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 1 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Radius = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 1 / Poloměr",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 1 / Poloměr.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Region = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 1 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 1 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1RobberyMultiplier = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 1 / Přepadení / Násobitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 1 / Přepadení / Násobitel.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2AcceptBonus = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 2 / Bonus za přijetí",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 2 / Bonus za přijetí.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Archetype = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 2 / Archetyp",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 2 / Archetyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsX = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 2 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 2 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsY = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 2 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 2 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsZ = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 2 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 2 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2DemandBonus = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 2 / Bonus poptávky",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 2 / Bonus poptávky.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2HeatMultiplier = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 2 / Policejní tlak / Násobitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 2 / Policejní tlak / Násobitel.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Id = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 2 / ID",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 2 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Label = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 2 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 2 / Štítek.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2MinimumQuality = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 2 / Minimální kvalita",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 2 / Minimální kvalita.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem1 = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 2 / Preferované drogy / 1",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 2 / Preferované drogy / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem2 = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 2 / Preferované drogy / 2",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 2 / Preferované drogy / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PriceMultiplier = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 2 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 2 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Radius = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 2 / Poloměr",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 2 / Poloměr.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Region = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 2 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 2 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2RobberyMultiplier = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 2 / Přepadení / Násobitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 2 / Přepadení / Násobitel.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3AcceptBonus = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 3 / Bonus za přijetí",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 3 / Bonus za přijetí.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Archetype = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 3 / Archetyp",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 3 / Archetyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsX = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 3 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 3 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsY = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 3 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 3 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsZ = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 3 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 3 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3DemandBonus = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 3 / Bonus poptávky",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 3 / Bonus poptávky.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3HeatMultiplier = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 3 / Policejní tlak / Násobitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 3 / Policejní tlak / Násobitel.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Id = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 3 / ID",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 3 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Label = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 3 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 3 / Štítek.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem1 = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 3 / Preferované drogy / 1",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 3 / Preferované drogy / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem2 = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 3 / Preferované drogy / 2",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 3 / Preferované drogy / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem3 = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 3 / Preferované drogy / 3",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 3 / Preferované drogy / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PriceMultiplier = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 3 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 3 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Radius = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 3 / Poloměr",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 3 / Poloměr.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Region = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 3 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 3 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3RobberyMultiplier = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 3 / Přepadení / Násobitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 3 / Přepadení / Násobitel.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4AcceptBonus = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 4 / Bonus za přijetí",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 4 / Bonus za přijetí.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Archetype = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 4 / Archetyp",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 4 / Archetyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsX = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 4 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 4 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsY = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 4 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 4 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsZ = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 4 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 4 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4DemandBonus = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 4 / Bonus poptávky",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 4 / Bonus poptávky.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4HeatMultiplier = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 4 / Policejní tlak / Násobitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 4 / Policejní tlak / Násobitel.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Id = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 4 / ID",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 4 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Label = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 4 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 4 / Štítek.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem1 = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 4 / Preferované drogy / 1",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 4 / Preferované drogy / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem2 = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 4 / Preferované drogy / 2",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 4 / Preferované drogy / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem3 = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 4 / Preferované drogy / 3",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 4 / Preferované drogy / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PriceMultiplier = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 4 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 4 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Radius = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 4 / Poloměr",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 4 / Poloměr.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Region = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 4 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 4 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4RobberyMultiplier = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 4 / Přepadení / Násobitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 4 / Přepadení / Násobitel.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5AcceptBonus = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 5 / Bonus za přijetí",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 5 / Bonus za přijetí.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Archetype = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 5 / Archetyp",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 5 / Archetyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsX = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 5 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 5 / Souřadnice / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsY = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 5 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 5 / Souřadnice / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsZ = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 5 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 5 / Souřadnice / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5DemandBonus = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 5 / Bonus poptávky",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 5 / Bonus poptávky.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5HeatMultiplier = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 5 / Policejní tlak / Násobitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 5 / Policejní tlak / Násobitel.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Id = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 5 / ID",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 5 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Label = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 5 / Štítek",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 5 / Štítek.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem1 = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 5 / Preferované drogy / 1",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 5 / Preferované drogy / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem2 = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 5 / Preferované drogy / 2",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 5 / Preferované drogy / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PriceMultiplier = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 5 / Násobitel ceny",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 5 / Násobitel ceny.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Radius = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 5 / Poloměr",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 5 / Poloměr.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Region = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 5 / Region",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 5 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5RobberyMultiplier = {
                    label = "Síť kontaktů / Ulice / Aktivní oblasti / 5 / Přepadení / Násobitel",
                    description = "Provozní nastavení pro: Síť kontaktů / Ulice / Aktivní oblasti / 5 / Přepadení / Násobitel.",
                },
                drugAdvancedContactNetworkTrustLevelsKnown = {
                    label = "Síť kontaktů / Důvěra / Úrovně / Známé",
                    description = "Provozní nastavení pro: Síť kontaktů / Důvěra / Úrovně / Známé.",
                },
                drugAdvancedContactNetworkTrustLevelsReliable = {
                    label = "Síť kontaktů / Důvěra / Úrovně / Spolehlivé",
                    description = "Provozní nastavení pro: Síť kontaktů / Důvěra / Úrovně / Spolehlivé.",
                },
                drugAdvancedContactNetworkTrustLevelsTrusted = {
                    label = "Síť kontaktů / Důvěra / Úrovně / Důvěryhodné",
                    description = "Provozní nastavení pro: Síť kontaktů / Důvěra / Úrovně / Důvěryhodné.",
                },
                drugAdvancedBusinessNetworkActionCooldownSeconds = {
                    label = "Síť podniků / Cooldown akce / sekundů",
                    description = "Provozní nastavení pro: Síť podniků / Cooldown akce / sekundů.",
                },
                drugAdvancedBusinessNetworkBalanceBaseUnitPrice = {
                    label = "Síť podniků / Zůstatek / Základní hodnota / Cena za jednotku",
                    description = "Provozní nastavení pro: Síť podniků / Zůstatek / Základní hodnota / Cena za jednotku.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerDealer = {
                    label = "Síť podniků / Zůstatek / Horkost sítě / Za dealera",
                    description = "Provozní nastavení pro: Síť podniků / Zůstatek / Horkost sítě / Za dealera.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerHub = {
                    label = "Síť podniků / Zůstatek / Horkost sítě / Za distribuční centrum",
                    description = "Provozní nastavení pro: Síť podniků / Zůstatek / Horkost sítě / Za distribuční centrum.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerRoute = {
                    label = "Síť podniků / Zůstatek / Horkost sítě / Za trasu",
                    description = "Provozní nastavení pro: Síť podniků / Zůstatek / Horkost sítě / Za trasu.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerStaff = {
                    label = "Síť podniků / Zůstatek / Horkost sítě / Za pracovníka",
                    description = "Provozní nastavení pro: Síť podniků / Zůstatek / Horkost sítě / Za pracovníka.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityGain = {
                    label = "Síť podniků / Zůstatek / Spolehlivost / zisk",
                    description = "Provozní nastavení pro: Síť podniků / Zůstatek / Spolehlivost / zisk.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityLoss = {
                    label = "Síť podniků / Zůstatek / Spolehlivost / Ztráta",
                    description = "Provozní nastavení pro: Síť podniků / Zůstatek / Spolehlivost / Ztráta.",
                },
                drugAdvancedBusinessNetworkBalanceRouteHeatDecay = {
                    label = "Síť podniků / Zůstatek / Trasa / Policejní tlak / Degradace",
                    description = "Provozní nastavení pro: Síť podniků / Zůstatek / Trasa / Policejní tlak / Degradace.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / gang / Množství / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / gang / Množství / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / gang / Množství / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / gang / Množství / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangMinRank = {
                    label = "Síť podniků / Kontrakty / Kategorie / gang / Minimum / Rank",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / gang / Minimum / Rank.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / gang / Kvalita / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / gang / Kvalita / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / gang / Kvalita / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / gang / Kvalita / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / gang / Odměna / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / gang / Odměna / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / gang / Odměna / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / gang / Odměna / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / gang / Riziko / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / gang / Riziko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / gang / Riziko / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / gang / Riziko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Síť NPC / Množství / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Síť NPC / Množství / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Síť NPC / Množství / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Síť NPC / Množství / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkMinRank = {
                    label = "Síť podniků / Kontrakty / Kategorie / Síť NPC / Minimum / Rank",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Síť NPC / Minimum / Rank.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Síť NPC / Kvalita / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Síť NPC / Kvalita / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Síť NPC / Kvalita / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Síť NPC / Kvalita / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Síť NPC / Odměna / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Síť NPC / Odměna / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Síť NPC / Odměna / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Síť NPC / Odměna / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Síť NPC / Riziko / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Síť NPC / Riziko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Síť NPC / Riziko / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Síť NPC / Riziko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Organizace / Množství / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Organizace / Množství / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Organizace / Množství / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Organizace / Množství / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationMinRank = {
                    label = "Síť podniků / Kontrakty / Kategorie / Organizace / Minimum / Rank",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Organizace / Minimum / Rank.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Organizace / Kvalita / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Organizace / Kvalita / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Organizace / Kvalita / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Organizace / Kvalita / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Organizace / Odměna / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Organizace / Odměna / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Organizace / Odměna / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Organizace / Odměna / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Organizace / Riziko / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Organizace / Riziko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Organizace / Riziko / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Organizace / Riziko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Prémiové / Množství / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Prémiové / Množství / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Prémiové / Množství / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Prémiové / Množství / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumMinRank = {
                    label = "Síť podniků / Kontrakty / Kategorie / Prémiové / Minimum / Rank",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Prémiové / Minimum / Rank.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Prémiové / Kvalita / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Prémiové / Kvalita / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Prémiové / Kvalita / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Prémiové / Kvalita / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Prémiové / Odměna / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Prémiové / Odměna / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Prémiové / Odměna / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Prémiové / Odměna / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Prémiové / Riziko / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Prémiové / Riziko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Prémiové / Riziko / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Prémiové / Riziko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Distributor / Množství / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Distributor / Množství / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Distributor / Množství / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Distributor / Množství / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherMinRank = {
                    label = "Síť podniků / Kontrakty / Kategorie / Distributor / Minimum / Rank",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Distributor / Minimum / Rank.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Distributor / Kvalita / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Distributor / Kvalita / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Distributor / Kvalita / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Distributor / Kvalita / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Distributor / Odměna / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Distributor / Odměna / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Distributor / Odměna / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Distributor / Odměna / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Distributor / Riziko / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Distributor / Riziko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Distributor / Riziko / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Distributor / Riziko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Zvláštní / Množství / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Zvláštní / Množství / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Zvláštní / Množství / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Zvláštní / Množství / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialMinRank = {
                    label = "Síť podniků / Kontrakty / Kategorie / Zvláštní / Minimum / Rank",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Zvláštní / Minimum / Rank.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Zvláštní / Kvalita / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Zvláštní / Kvalita / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Zvláštní / Kvalita / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Zvláštní / Kvalita / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Zvláštní / Odměna / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Zvláštní / Odměna / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Zvláštní / Odměna / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Zvláštní / Odměna / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Zvláštní / Riziko / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Zvláštní / Riziko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Zvláštní / Riziko / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Zvláštní / Riziko / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Velkoobchod / Množství / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Velkoobchod / Množství / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Velkoobchod / Množství / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Velkoobchod / Množství / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleMinRank = {
                    label = "Síť podniků / Kontrakty / Kategorie / Velkoobchod / Minimum / Rank",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Velkoobchod / Minimum / Rank.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Velkoobchod / Kvalita / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Velkoobchod / Kvalita / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Velkoobchod / Kvalita / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Velkoobchod / Kvalita / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Velkoobchod / Odměna / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Velkoobchod / Odměna / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Velkoobchod / Odměna / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Velkoobchod / Odměna / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem1 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Velkoobchod / Riziko / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Velkoobchod / Riziko / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem2 = {
                    label = "Síť podniků / Kontrakty / Kategorie / Velkoobchod / Riziko / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Kategorie / Velkoobchod / Riziko / 2.",
                },
                drugAdvancedBusinessNetworkContractsDeliveryDistance = {
                    label = "Síť podniků / Kontrakty / Vzdálenost doručení",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Vzdálenost doručení.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMax = {
                    label = "Síť podniků / Kontrakty / Doba trvání / Minuty / Maximum",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Doba trvání / Minuty / Maximum.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMin = {
                    label = "Síť podniků / Kontrakty / Doba trvání / Minuty / Minimum",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Doba trvání / Minuty / Minimum.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsX = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 1 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 1 / Souřadnice / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsY = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 1 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 1 / Souřadnice / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsZ = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 1 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 1 / Souřadnice / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Id = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 1 / ID",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 1 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Label = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 1 / Štítek",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 1 / Štítek.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Region = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 1 / Region",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 1 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1RewardMultiplier = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 1 / Odměna / Násobitel",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 1 / Odměna / Násobitel.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Risk = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 1 / Riziko",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 1 / Riziko.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsX = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 2 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 2 / Souřadnice / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsY = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 2 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 2 / Souřadnice / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsZ = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 2 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 2 / Souřadnice / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Id = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 2 / ID",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 2 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Label = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 2 / Štítek",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 2 / Štítek.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Region = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 2 / Region",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 2 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2RewardMultiplier = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 2 / Odměna / Násobitel",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 2 / Odměna / Násobitel.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Risk = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 2 / Riziko",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 2 / Riziko.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsX = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 3 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 3 / Souřadnice / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsY = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 3 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 3 / Souřadnice / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsZ = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 3 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 3 / Souřadnice / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Id = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 3 / ID",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 3 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Label = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 3 / Štítek",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 3 / Štítek.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Region = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 3 / Region",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 3 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3RewardMultiplier = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 3 / Odměna / Násobitel",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 3 / Odměna / Násobitel.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Risk = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 3 / Riziko",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 3 / Riziko.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsX = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 4 / Souřadnice / X",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 4 / Souřadnice / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsY = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 4 / Souřadnice / Y",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 4 / Souřadnice / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsZ = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 4 / Souřadnice / Z",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 4 / Souřadnice / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Id = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 4 / ID",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 4 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Label = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 4 / Štítek",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 4 / Štítek.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Region = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 4 / Region",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 4 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4RewardMultiplier = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 4 / Odměna / Násobitel",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 4 / Odměna / Násobitel.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Risk = {
                    label = "Síť podniků / Kontrakty / Setkání / Body / 4 / Riziko",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Setkání / Body / 4 / Riziko.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem1 = {
                    label = "Síť podniků / Kontrakty / Vyjednávání / Záloha / Možnosti / 1",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Vyjednávání / Záloha / Možnosti / 1.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem2 = {
                    label = "Síť podniků / Kontrakty / Vyjednávání / Záloha / Možnosti / 2",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Vyjednávání / Záloha / Možnosti / 2.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem3 = {
                    label = "Síť podniků / Kontrakty / Vyjednávání / Záloha / Možnosti / 3",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Vyjednávání / Záloha / Možnosti / 3.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAmountFlexPercent = {
                    label = "Síť podniků / Kontrakty / Vyjednávání / Množství / Prostor pro vyjednávání / Procenta",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Vyjednávání / Množství / Prostor pro vyjednávání / Procenta.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationBaseAcceptance = {
                    label = "Síť podniků / Kontrakty / Vyjednávání / Základní hodnota / Přijetí",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Vyjednávání / Základní hodnota / Přijetí.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationDeadlineFlexPercent = {
                    label = "Síť podniků / Kontrakty / Vyjednávání / Termín / Prostor pro vyjednávání / Procenta",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Vyjednávání / Termín / Prostor pro vyjednávání / Procenta.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationMaxRounds = {
                    label = "Síť podniků / Kontrakty / Vyjednávání / Maximum / Kola",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Vyjednávání / Maximum / Kola.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationQualityFlex = {
                    label = "Síť podniků / Kontrakty / Vyjednávání / Kvalita / Prostor pro vyjednávání",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Vyjednávání / Kvalita / Prostor pro vyjednávání.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRejectionCooldownMinutes = {
                    label = "Síť podniků / Kontrakty / Vyjednávání / Odmítnutí / Minuty prodlevy",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Vyjednávání / Odmítnutí / Minuty prodlevy.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRoundPressure = {
                    label = "Síť podniků / Kontrakty / Vyjednávání / Kolo / Tlak",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Vyjednávání / Kolo / Tlak.",
                },
                drugAdvancedBusinessNetworkContractsOfferCount = {
                    label = "Síť podniků / Kontrakty / Nabídka / Počet",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Nabídka / Počet.",
                },
                drugAdvancedBusinessNetworkContractsRefreshMinutes = {
                    label = "Síť podniků / Kontrakty / Obnovení / Minuty",
                    description = "Provozní nastavení pro: Síť podniků / Kontrakty / Obnovení / Minuty.",
                },
                drugAdvancedBusinessNetworkDefaultBusinessName = {
                    label = "Síť podniků / Výchozí hodnota / Název firmy",
                    description = "Provozní nastavení pro: Síť podniků / Výchozí hodnota / Název firmy.",
                },
                drugAdvancedBusinessNetworkDefaultRankId = {
                    label = "Síť podniků / Výchozí hodnota / Rank / ID",
                    description = "Provozní nastavení pro: Síť podniků / Výchozí hodnota / Rank / ID.",
                },
                drugAdvancedBusinessNetworkDefaultStaffStyle = {
                    label = "Síť podniků / Výchozí hodnota / Staff / Styl práce",
                    description = "Provozní nastavení pro: Síť podniků / Výchozí hodnota / Staff / Styl práce.",
                },
                drugAdvancedBusinessNetworkDefaultTransport = {
                    label = "Síť podniků / Výchozí hodnota / Doprava",
                    description = "Provozní nastavení pro: Síť podniků / Výchozí hodnota / Doprava.",
                },
                drugAdvancedBusinessNetworkEnabled = {
                    label = "Síť podniků / Aktivováno",
                    description = "Provozní nastavení pro: Síť podniků / Aktivováno.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterCapacity = {
                    label = "Síť podniků / Distribuční centra / Distribuční centrum / kapacita",
                    description = "Provozní nastavení pro: Síť podniků / Distribuční centra / Distribuční centrum / kapacita.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterPurchasePrice = {
                    label = "Síť podniků / Distribuční centra / Distribuční centrum / Nákupní cena",
                    description = "Provozní nastavení pro: Síť podniků / Distribuční centra / Distribuční centrum / Nákupní cena.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterSecurity = {
                    label = "Síť podniků / Distribuční centra / Distribuční centrum / Zabezpečení",
                    description = "Provozní nastavení pro: Síť podniků / Distribuční centra / Distribuční centrum / Zabezpečení.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterUpkeep = {
                    label = "Síť podniků / Distribuční centra / Distribuční centrum / Údržba",
                    description = "Provozní nastavení pro: Síť podniků / Distribuční centra / Distribuční centrum / Údržba.",
                },
                drugAdvancedBusinessNetworkHubsStashCapacity = {
                    label = "Síť podniků / Distribuční centra / Skrýš / kapacita",
                    description = "Provozní nastavení pro: Síť podniků / Distribuční centra / Skrýš / kapacita.",
                },
                drugAdvancedBusinessNetworkHubsStashPurchasePrice = {
                    label = "Síť podniků / Distribuční centra / Skrýš / Nákupní cena",
                    description = "Provozní nastavení pro: Síť podniků / Distribuční centra / Skrýš / Nákupní cena.",
                },
                drugAdvancedBusinessNetworkHubsStashSecurity = {
                    label = "Síť podniků / Distribuční centra / Skrýš / Zabezpečení",
                    description = "Provozní nastavení pro: Síť podniků / Distribuční centra / Skrýš / Zabezpečení.",
                },
                drugAdvancedBusinessNetworkHubsStashUpkeep = {
                    label = "Síť podniků / Distribuční centra / Skrýš / Údržba",
                    description = "Provozní nastavení pro: Síť podniků / Distribuční centra / Skrýš / Údržba.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseCapacity = {
                    label = "Síť podniků / Distribuční centra / Sklad / kapacita",
                    description = "Provozní nastavení pro: Síť podniků / Distribuční centra / Sklad / kapacita.",
                },
                drugAdvancedBusinessNetworkHubsWarehousePurchasePrice = {
                    label = "Síť podniků / Distribuční centra / Sklad / Nákupní cena",
                    description = "Provozní nastavení pro: Síť podniků / Distribuční centra / Sklad / Nákupní cena.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseSecurity = {
                    label = "Síť podniků / Distribuční centra / Sklad / Zabezpečení",
                    description = "Provozní nastavení pro: Síť podniků / Distribuční centra / Sklad / Zabezpečení.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseUpkeep = {
                    label = "Síť podniků / Distribuční centra / Sklad / Údržba",
                    description = "Provozní nastavení pro: Síť podniků / Distribuční centra / Sklad / Údržba.",
                },
                drugAdvancedBusinessNetworkLimitsActiveContracts = {
                    label = "Síť podniků / Limity / Aktivní smlouvy",
                    description = "Provozní nastavení pro: Síť podniků / Limity / Aktivní smlouvy.",
                },
                drugAdvancedBusinessNetworkLimitsHubs = {
                    label = "Síť podniků / Limity / Distribuční centra",
                    description = "Provozní nastavení pro: Síť podniků / Limity / Distribuční centra.",
                },
                drugAdvancedBusinessNetworkLimitsLedgerRows = {
                    label = "Síť podniků / Limity / Účetní kniha / Řádky",
                    description = "Provozní nastavení pro: Síť podniků / Limity / Účetní kniha / Řádky.",
                },
                drugAdvancedBusinessNetworkLimitsRoutes = {
                    label = "Síť podniků / Limity / Trasy",
                    description = "Provozní nastavení pro: Síť podniků / Limity / Trasy.",
                },
                drugAdvancedBusinessNetworkLimitsStaff = {
                    label = "Síť podniků / Limity / Staff",
                    description = "Provozní nastavení pro: Síť podniků / Limity / Staff.",
                },
                drugAdvancedBusinessNetworkPayoutAccount = {
                    label = "Síť podniků / Výplata / Účet",
                    description = "Provozní nastavení pro: Síť podniků / Výplata / Účet.",
                },
                drugAdvancedBusinessNetworkRanksItem1Contracts = {
                    label = "Síť podniků / Hodnosti / 1 / Kontrakty",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 1 / Kontrakty.",
                },
                drugAdvancedBusinessNetworkRanksItem1Dealers = {
                    label = "Síť podniků / Hodnosti / 1 / Dealerové",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 1 / Dealerové.",
                },
                drugAdvancedBusinessNetworkRanksItem1Hubs = {
                    label = "Síť podniků / Hodnosti / 1 / Distribuční centra",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 1 / Distribuční centra.",
                },
                drugAdvancedBusinessNetworkRanksItem1Id = {
                    label = "Síť podniků / Hodnosti / 1 / ID",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 1 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem1Label = {
                    label = "Síť podniků / Hodnosti / 1 / Štítek",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 1 / Štítek.",
                },
                drugAdvancedBusinessNetworkRanksItem1Routes = {
                    label = "Síť podniků / Hodnosti / 1 / Trasy",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 1 / Trasy.",
                },
                drugAdvancedBusinessNetworkRanksItem1Score = {
                    label = "Síť podniků / Hodnosti / 1 / Skóre",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 1 / Skóre.",
                },
                drugAdvancedBusinessNetworkRanksItem1Staff = {
                    label = "Síť podniků / Hodnosti / 1 / Staff",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 1 / Staff.",
                },
                drugAdvancedBusinessNetworkRanksItem2Contracts = {
                    label = "Síť podniků / Hodnosti / 2 / Kontrakty",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 2 / Kontrakty.",
                },
                drugAdvancedBusinessNetworkRanksItem2Dealers = {
                    label = "Síť podniků / Hodnosti / 2 / Dealerové",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 2 / Dealerové.",
                },
                drugAdvancedBusinessNetworkRanksItem2Hubs = {
                    label = "Síť podniků / Hodnosti / 2 / Distribuční centra",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 2 / Distribuční centra.",
                },
                drugAdvancedBusinessNetworkRanksItem2Id = {
                    label = "Síť podniků / Hodnosti / 2 / ID",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 2 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem2Label = {
                    label = "Síť podniků / Hodnosti / 2 / Štítek",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 2 / Štítek.",
                },
                drugAdvancedBusinessNetworkRanksItem2Routes = {
                    label = "Síť podniků / Hodnosti / 2 / Trasy",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 2 / Trasy.",
                },
                drugAdvancedBusinessNetworkRanksItem2Score = {
                    label = "Síť podniků / Hodnosti / 2 / Skóre",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 2 / Skóre.",
                },
                drugAdvancedBusinessNetworkRanksItem2Staff = {
                    label = "Síť podniků / Hodnosti / 2 / Staff",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 2 / Staff.",
                },
                drugAdvancedBusinessNetworkRanksItem3Contracts = {
                    label = "Síť podniků / Hodnosti / 3 / Kontrakty",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 3 / Kontrakty.",
                },
                drugAdvancedBusinessNetworkRanksItem3Dealers = {
                    label = "Síť podniků / Hodnosti / 3 / Dealerové",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 3 / Dealerové.",
                },
                drugAdvancedBusinessNetworkRanksItem3Hubs = {
                    label = "Síť podniků / Hodnosti / 3 / Distribuční centra",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 3 / Distribuční centra.",
                },
                drugAdvancedBusinessNetworkRanksItem3Id = {
                    label = "Síť podniků / Hodnosti / 3 / ID",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 3 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem3Label = {
                    label = "Síť podniků / Hodnosti / 3 / Štítek",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 3 / Štítek.",
                },
                drugAdvancedBusinessNetworkRanksItem3Routes = {
                    label = "Síť podniků / Hodnosti / 3 / Trasy",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 3 / Trasy.",
                },
                drugAdvancedBusinessNetworkRanksItem3Score = {
                    label = "Síť podniků / Hodnosti / 3 / Skóre",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 3 / Skóre.",
                },
                drugAdvancedBusinessNetworkRanksItem3Staff = {
                    label = "Síť podniků / Hodnosti / 3 / Staff",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 3 / Staff.",
                },
                drugAdvancedBusinessNetworkRanksItem4Contracts = {
                    label = "Síť podniků / Hodnosti / 4 / Kontrakty",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 4 / Kontrakty.",
                },
                drugAdvancedBusinessNetworkRanksItem4Dealers = {
                    label = "Síť podniků / Hodnosti / 4 / Dealerové",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 4 / Dealerové.",
                },
                drugAdvancedBusinessNetworkRanksItem4Hubs = {
                    label = "Síť podniků / Hodnosti / 4 / Distribuční centra",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 4 / Distribuční centra.",
                },
                drugAdvancedBusinessNetworkRanksItem4Id = {
                    label = "Síť podniků / Hodnosti / 4 / ID",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 4 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem4Label = {
                    label = "Síť podniků / Hodnosti / 4 / Štítek",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 4 / Štítek.",
                },
                drugAdvancedBusinessNetworkRanksItem4Routes = {
                    label = "Síť podniků / Hodnosti / 4 / Trasy",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 4 / Trasy.",
                },
                drugAdvancedBusinessNetworkRanksItem4Score = {
                    label = "Síť podniků / Hodnosti / 4 / Skóre",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 4 / Skóre.",
                },
                drugAdvancedBusinessNetworkRanksItem4Staff = {
                    label = "Síť podniků / Hodnosti / 4 / Staff",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 4 / Staff.",
                },
                drugAdvancedBusinessNetworkRanksItem5Contracts = {
                    label = "Síť podniků / Hodnosti / 5 / Kontrakty",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 5 / Kontrakty.",
                },
                drugAdvancedBusinessNetworkRanksItem5Dealers = {
                    label = "Síť podniků / Hodnosti / 5 / Dealerové",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 5 / Dealerové.",
                },
                drugAdvancedBusinessNetworkRanksItem5Hubs = {
                    label = "Síť podniků / Hodnosti / 5 / Distribuční centra",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 5 / Distribuční centra.",
                },
                drugAdvancedBusinessNetworkRanksItem5Id = {
                    label = "Síť podniků / Hodnosti / 5 / ID",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 5 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem5Label = {
                    label = "Síť podniků / Hodnosti / 5 / Štítek",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 5 / Štítek.",
                },
                drugAdvancedBusinessNetworkRanksItem5Routes = {
                    label = "Síť podniků / Hodnosti / 5 / Trasy",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 5 / Trasy.",
                },
                drugAdvancedBusinessNetworkRanksItem5Score = {
                    label = "Síť podniků / Hodnosti / 5 / Skóre",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 5 / Skóre.",
                },
                drugAdvancedBusinessNetworkRanksItem5Staff = {
                    label = "Síť podniků / Hodnosti / 5 / Staff",
                    description = "Provozní nastavení pro: Síť podniků / Hodnosti / 5 / Staff.",
                },
                drugAdvancedBusinessNetworkReportDays = {
                    label = "Síť podniků / Období přehledu / dní",
                    description = "Provozní nastavení pro: Síť podniků / Období přehledu / dní.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesBuyer = {
                    label = "Síť podniků / Trasa / Koncový bod / Typy / Kupec",
                    description = "Provozní nastavení pro: Síť podniků / Trasa / Koncový bod / Typy / Kupec.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesContract = {
                    label = "Síť podniků / Trasa / Koncový bod / Typy / Smlouva",
                    description = "Provozní nastavení pro: Síť podniků / Trasa / Koncový bod / Typy / Smlouva.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesDealer = {
                    label = "Síť podniků / Trasa / Koncový bod / Typy / Dealer",
                    description = "Provozní nastavení pro: Síť podniků / Trasa / Koncový bod / Typy / Dealer.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesGang = {
                    label = "Síť podniků / Trasa / Koncový bod / Typy / gang",
                    description = "Provozní nastavení pro: Síť podniků / Trasa / Koncový bod / Typy / gang.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesHub = {
                    label = "Síť podniků / Trasa / Koncový bod / Typy / Distribuční centrum",
                    description = "Provozní nastavení pro: Síť podniků / Trasa / Koncový bod / Typy / Distribuční centrum.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesLab = {
                    label = "Síť podniků / Trasa / Koncový bod / Typy / Laboratoř",
                    description = "Provozní nastavení pro: Síť podniků / Trasa / Koncový bod / Typy / Laboratoř.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesOrganization = {
                    label = "Síť podniků / Trasa / Koncový bod / Typy / Organizace",
                    description = "Provozní nastavení pro: Síť podniků / Trasa / Koncový bod / Typy / Organizace.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesPusher = {
                    label = "Síť podniků / Trasa / Koncový bod / Typy / Distributor",
                    description = "Provozní nastavení pro: Síť podniků / Trasa / Koncový bod / Typy / Distributor.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMax = {
                    label = "Síť podniků / Provoz ve hře / Smlouva / Četnost / Minuty / Maximum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Smlouva / Četnost / Minuty / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMin = {
                    label = "Síť podniků / Provoz ve hře / Smlouva / Četnost / Minuty / Minimum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Smlouva / Četnost / Minuty / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCooldownMinimumMinutes = {
                    label = "Síť podniků / Provoz ve hře / Smlouva / Dočasné omezení / Minimum / Minuty",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Smlouva / Dočasné omezení / Minimum / Minuty.",
                },
                drugAdvancedBusinessNetworkRuntimeContractFailureReliabilityLoss = {
                    label = "Síť podniků / Provoz ve hře / Smlouva / Neúspěch / Spolehlivost / Ztráta",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Smlouva / Neúspěch / Spolehlivost / Ztráta.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumCadenceMinutes = {
                    label = "Síť podniků / Provoz ve hře / Smlouva / Minimum / Četnost / Minuty",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Smlouva / Minimum / Četnost / Minuty.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumMeetingMultiplier = {
                    label = "Síť podniků / Provoz ve hře / Smlouva / Minimum / Setkání / Násobitel",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Smlouva / Minimum / Setkání / Násobitel.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyGrowth = {
                    label = "Síť podniků / Provoz ve hře / Smluvní pokuta / Růst",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Smluvní pokuta / Růst.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyMultiplier = {
                    label = "Síť podniků / Provoz ve hře / Smluvní pokuta / Násobitel",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Smluvní pokuta / Násobitel.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityFailureCooldownMinutes = {
                    label = "Síť podniků / Provoz ve hře / Smlouva / Kvalita / Neúspěch / Minuty prodlevy",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Smlouva / Kvalita / Neúspěch / Minuty prodlevy.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceBase = {
                    label = "Síť podniků / Provoz ve hře / Smlouva / Kvalita / Cena / Základní hodnota",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Smlouva / Kvalita / Cena / Základní hodnota.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceDivisor = {
                    label = "Síť podniků / Provoz ve hře / Smlouva / Kvalita / Cena / Dělitel",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Smlouva / Kvalita / Cena / Dělitel.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossBase = {
                    label = "Síť podniků / Provoz ve hře / Smlouva / Spolehlivost / Ztráta / Základní hodnota",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Smlouva / Spolehlivost / Ztráta / Základní hodnota.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossMaximum = {
                    label = "Síť podniků / Provoz ve hře / Smlouva / Spolehlivost / Ztráta / Maximum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Smlouva / Spolehlivost / Ztráta / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossQualityWeight = {
                    label = "Síť podniků / Provoz ve hře / Smlouva / Spolehlivost / Ztráta / Kvalita / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Smlouva / Spolehlivost / Ztráta / Kvalita / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReputationQualityWeight = {
                    label = "Síť podniků / Provoz ve hře / Smlouva / Reputace / Kvalita / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Smlouva / Reputace / Kvalita / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsCategory = {
                    label = "Síť podniků / Provoz ve hře / Smlouva / Riziko / Váhy / Kategorie",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Smlouva / Riziko / Váhy / Kategorie.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsMeeting = {
                    label = "Síť podniků / Provoz ve hře / Smlouva / Riziko / Váhy / Setkání",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Smlouva / Riziko / Váhy / Setkání.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubCapacity = {
                    label = "Síť podniků / Provoz ve hře / Výchozí hodnota / Distribuční centrum / kapacita",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Výchozí hodnota / Distribuční centrum / kapacita.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubSecurity = {
                    label = "Síť podniků / Provoz ve hře / Výchozí hodnota / Distribuční centrum / Zabezpečení",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Výchozí hodnota / Distribuční centrum / Zabezpečení.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultMeetingRisk = {
                    label = "Síť podniků / Provoz ve hře / Výchozí hodnota / Setkání / Riziko",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Výchozí hodnota / Setkání / Riziko.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultQuality = {
                    label = "Síť podniků / Provoz ve hře / Výchozí hodnota / Kvalita",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Výchozí hodnota / Kvalita.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteCapacity = {
                    label = "Síť podniků / Provoz ve hře / Výchozí hodnota / Kapacita trasy",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Výchozí hodnota / Kapacita trasy.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteIntervalMinutes = {
                    label = "Síť podniků / Provoz ve hře / Výchozí hodnota / Trasa / Interval / Minuty",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Výchozí hodnota / Trasa / Interval / Minuty.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteRisk = {
                    label = "Síť podniků / Provoz ve hře / Výchozí hodnota / Trasa / Riziko",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Výchozí hodnota / Trasa / Riziko.",
                },
                drugAdvancedBusinessNetworkRuntimeHubHeatDecay = {
                    label = "Síť podniků / Provoz ve hře / Distribuční centrum / Policejní tlak / Degradace",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distribuční centrum / Policejní tlak / Degradace.",
                },
                drugAdvancedBusinessNetworkRuntimeHubLoadHeat = {
                    label = "Síť podniků / Provoz ve hře / Distribuční centrum / Zatížení / Policejní tlak",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distribuční centrum / Zatížení / Policejní tlak.",
                },
                drugAdvancedBusinessNetworkRuntimeHubRaidRecoveryMinutes = {
                    label = "Síť podniků / Provoz ve hře / Distribuční centrum / Přepadení / Zotavení / Minuty",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distribuční centrum / Přepadení / Zotavení / Minuty.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostBase = {
                    label = "Síť podniků / Provoz ve hře / Distribuční centrum / Zabezpečení / Cost / Základní hodnota",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distribuční centrum / Zabezpečení / Cost / Základní hodnota.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostPerLevel = {
                    label = "Síť podniků / Provoz ve hře / Distribuční centrum / Zabezpečení / Cost / Za úroveň",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distribuční centrum / Zabezpečení / Cost / Za úroveň.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityMaximum = {
                    label = "Síť podniků / Provoz ve hře / Distribuční centrum / Zabezpečení / Maximum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distribuční centrum / Zabezpečení / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityUpgrade = {
                    label = "Síť podniků / Provoz ve hře / Distribuční centrum / Zabezpečení / Vylepšení",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distribuční centrum / Zabezpečení / Vylepšení.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidHeat = {
                    label = "Síť podniků / Provoz ve hře / Distribuční centrum / Nezaplacení / Policejní tlak",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distribuční centrum / Nezaplacení / Policejní tlak.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidSecurityLoss = {
                    label = "Síť podniků / Provoz ve hře / Distribuční centrum / Nezaplacení / Zabezpečení / Ztráta",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distribuční centrum / Nezaplacení / Zabezpečení / Ztráta.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUpkeepIntervalHours = {
                    label = "Síť podniků / Provoz ve hře / Distribuční centrum / Údržba / Interval / Hodiny",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distribuční centrum / Údržba / Interval / Hodiny.",
                },
                drugAdvancedBusinessNetworkRuntimeInitialReliability = {
                    label = "Síť podniků / Provoz ve hře / Počáteční hodnota / Spolehlivost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Počáteční hodnota / Spolehlivost.",
                },
                drugAdvancedBusinessNetworkRuntimeMaximumBusinessNameLength = {
                    label = "Síť podniků / Provoz ve hře / Maximum / Název firmy / Délka",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Maximum / Název firmy / Délka.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumContractDeliveryMinutes = {
                    label = "Síť podniků / Provoz ve hře / Minimum / Smlouva / Doručení / Minuty",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Minimum / Smlouva / Doručení / Minuty.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumDeliveryDistance = {
                    label = "Síť podniků / Provoz ve hře / Minimum / Vzdálenost doručení",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Minimum / Vzdálenost doručení.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumLedgerRows = {
                    label = "Síť podniků / Provoz ve hře / Minimum / Účetní kniha / Řádky",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Minimum / Účetní kniha / Řádky.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumRouteIntervalMinutes = {
                    label = "Síť podniků / Provoz ve hře / Minimum / Trasa / Interval / Minuty",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Minimum / Trasa / Interval / Minuty.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvanceCostWeight = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Záloha / Cost / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Záloha / Cost / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvancePriceWeight = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Záloha / Cena / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Záloha / Cena / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountCostWeight = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Množství / Cost / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Množství / Cost / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountFlexMaximum = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Množství / Prostor pro vyjednávání / Maximum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Množství / Prostor pro vyjednávání / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountRiskWeight = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Množství / Riziko / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Množství / Riziko / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationCounterOfferWeight = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Protioferta / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Protioferta / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationDeadlineFlexMaximum = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Termín / Prostor pro vyjednávání / Maximum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Termín / Prostor pro vyjednávání / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMaximumAcceptance = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Maximum / Přijetí",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Maximum / Přijetí.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMinimumAcceptance = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Minimum / Přijetí",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Minimum / Přijetí.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityBenefitWeight = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Kvalita / Přínos / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Kvalita / Přínos / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityCostWeight = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Kvalita / Cost / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Kvalita / Cost / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityFlexMaximum = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Kvalita / Prostor pro vyjednávání / Maximum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Kvalita / Prostor pro vyjednávání / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityRewardWeight = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Kvalita / Odměna / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Kvalita / Odměna / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReliabilityWeight = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Spolehlivost / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Spolehlivost / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReputationWeight = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Reputace / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Reputace / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMax = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Požadovaná odměna / Maximum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Požadovaná odměna / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMin = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Požadovaná odměna / Minimum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Požadovaná odměna / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardCostWeight = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Odměna / Cost / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Odměna / Cost / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMax = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Odměna / Maximum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Odměna / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMin = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Odměna / Minimum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Odměna / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBase = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Naléhavost / Základní hodnota",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Naléhavost / Základní hodnota.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBenefitWeight = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Naléhavost / Přínos / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Naléhavost / Přínos / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyRiskWeight = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Naléhavost / Riziko / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Naléhavost / Riziko / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyWeight = {
                    label = "Síť podniků / Provoz ve hře / Vyjednávání / Naléhavost / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Vyjednávání / Naléhavost / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeOtherFailureHeat = {
                    label = "Síť podniků / Provoz ve hře / Jiný zdroj / Neúspěch / Policejní tlak",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Jiný zdroj / Neúspěch / Policejní tlak.",
                },
                drugAdvancedBusinessNetworkRuntimePersonalHeatWeight = {
                    label = "Síť podniků / Provoz ve hře / Osobní pozornost / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Osobní pozornost / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimePoliceFailureHeat = {
                    label = "Síť podniků / Provoz ve hře / Policie / Neúspěch / Policejní tlak",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Policie / Neúspěch / Policejní tlak.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBaseUnits = {
                    label = "Síť podniků / Provoz ve hře / Distributor / Základní hodnota / jednotek",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distributor / Základní hodnota / jednotek.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBulkMultiplier = {
                    label = "Síť podniků / Provoz ve hře / Distributor / Velké množství / Násobitel",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distributor / Velké množství / Násobitel.",
                },
                drugAdvancedBusinessNetworkRuntimePusherCheapMultiplier = {
                    label = "Síť podniků / Provoz ve hře / Distributor / Levný prodej / Násobitel",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distributor / Levný prodej / Násobitel.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerLevel = {
                    label = "Síť podniků / Provoz ve hře / Distributor / Zkušenosti / Za úroveň",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distributor / Zkušenosti / Za úroveň.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerUnit = {
                    label = "Síť podniků / Provoz ve hře / Distributor / Zkušenosti / Za jednotku",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distributor / Zkušenosti / Za jednotku.",
                },
                drugAdvancedBusinessNetworkRuntimePusherHubHeatPerUnit = {
                    label = "Síť podniků / Provoz ve hře / Distributor / Distribuční centrum / Policejní tlak / Za jednotku",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distributor / Distribuční centrum / Policejní tlak / Za jednotku.",
                },
                drugAdvancedBusinessNetworkRuntimePusherPremiumMultiplier = {
                    label = "Síť podniků / Provoz ve hře / Distributor / Prémiové / Násobitel",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distributor / Prémiové / Násobitel.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillDivisor = {
                    label = "Síť podniků / Provoz ve hře / Distributor / Dovednost / Dělitel",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distributor / Dovednost / Dělitel.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillGain = {
                    label = "Síť podniků / Provoz ve hře / Distributor / Dovednost / zisk",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Distributor / Dovednost / zisk.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationBaseSeconds = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Doba trvání / Základní hodnota / sekundů",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Doba trvání / Základní hodnota / sekundů.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationPerUnitSeconds = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Doba trvání / Za jednotku / sekundů",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Doba trvání / Za jednotku / sekundů.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem1 = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Neúspěch / Příčiny / 1",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Neúspěch / Příčiny / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem2 = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Neúspěch / Příčiny / 2",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Neúspěch / Příčiny / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem3 = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Neúspěch / Příčiny / 3",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Neúspěch / Příčiny / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem4 = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Neúspěch / Příčiny / 4",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Neúspěch / Příčiny / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureValueMultiplier = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Neúspěch / Value / Násobitel",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Neúspěch / Value / Násobitel.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatAmountDivisor = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Policejní tlak / Množství / Dělitel",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Policejní tlak / Množství / Dělitel.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostBase = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Snížení poptávky / Cost / Základní hodnota",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Snížení poptávky / Cost / Základní hodnota.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostPerHeat = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Snížení poptávky / Cost / Za bod pozornosti policie",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Snížení poptávky / Cost / Za bod pozornosti policie.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMaximum = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Riziko / Maximum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Riziko / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMinimum = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Riziko / Minimum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Riziko / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsHeat = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Riziko / Váhy / Policejní tlak",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Riziko / Váhy / Policejní tlak.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsLoyalty = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Riziko / Váhy / Lojalita",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Riziko / Váhy / Lojalita.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsRunnerRisk = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Riziko / Váhy / Běžec / Riziko",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Riziko / Váhy / Běžec / Riziko.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsSkill = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Riziko / Váhy / Dovednost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Riziko / Váhy / Dovednost.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationHeatReduction = {
                    label = "Síť podniků / Provoz ve hře / Rotace trasy / Snížení poptávky",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Rotace trasy / Snížení poptávky.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationRiskReduction = {
                    label = "Síť podniků / Provoz ve hře / Rotace trasy / Riziko / Snížení",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Rotace trasy / Riziko / Snížení.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityBase = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Prodej / Základní kvalita",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Prodej / Základní kvalita.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityDivisor = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Prodej / Kvalita / Dělitel",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Prodej / Kvalita / Dělitel.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleRiskDivisor = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Prodej / Riziko / Dělitel",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Prodej / Riziko / Dělitel.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteStartHeat = {
                    label = "Síť podniků / Provoz ve hře / Trasa / Začátek / Policejní tlak",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Trasa / Začátek / Policejní tlak.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerLevel = {
                    label = "Síť podniků / Provoz ve hře / Běžec / Zkušenosti / Za úroveň",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Běžec / Zkušenosti / Za úroveň.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerUnit = {
                    label = "Síť podniků / Provoz ve hře / Běžec / Zkušenosti / Za jednotku",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Běžec / Zkušenosti / Za jednotku.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureLoyaltyLoss = {
                    label = "Síť podniků / Provoz ve hře / Běžec / Neúspěch / Lojalita / Ztráta",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Běžec / Neúspěch / Lojalita / Ztráta.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureRiskGain = {
                    label = "Síť podniků / Provoz ve hře / Běžec / Riziko chyby / zisk",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Běžec / Riziko chyby / zisk.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerSkillGain = {
                    label = "Síť podniků / Provoz ve hře / Běžec / Dovednost / zisk",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Běžec / Dovednost / zisk.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsHeat = {
                    label = "Síť podniků / Provoz ve hře / Skóre / Váhy / Policejní tlak",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Skóre / Váhy / Policejní tlak.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReliability = {
                    label = "Síť podniků / Provoz ve hře / Skóre / Váhy / Spolehlivost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Skóre / Váhy / Spolehlivost.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReputation = {
                    label = "Síť podniků / Provoz ve hře / Skóre / Váhy / Reputace",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Skóre / Váhy / Reputace.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsStructure = {
                    label = "Síť podniků / Provoz ve hře / Skóre / Váhy / Struktura",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Skóre / Váhy / Struktura.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffCapacityBaseMultiplier = {
                    label = "Síť podniků / Provoz ve hře / Staff / kapacita / Základní hodnota / Násobitel",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / kapacita / Základní hodnota / Násobitel.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMax = {
                    label = "Síť podniků / Provoz ve hře / Staff / Najmutí / Lojalita / Maximum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Najmutí / Lojalita / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMin = {
                    label = "Síť podniků / Provoz ve hře / Staff / Najmutí / Lojalita / Minimum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Najmutí / Lojalita / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMax = {
                    label = "Síť podniků / Provoz ve hře / Staff / Najmutí / Riziko / Maximum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Najmutí / Riziko / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMin = {
                    label = "Síť podniků / Provoz ve hře / Staff / Najmutí / Riziko / Minimum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Najmutí / Riziko / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMax = {
                    label = "Síť podniků / Provoz ve hře / Staff / Najmutí / Dovednost / Maximum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Najmutí / Dovednost / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMin = {
                    label = "Síť podniků / Provoz ve hře / Staff / Najmutí / Dovednost / Minimum",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Najmutí / Dovednost / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentLoyaltyWeight = {
                    label = "Síť podniků / Provoz ve hře / Staff / Incident / Lojalita / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Incident / Lojalita / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentMaximumChance = {
                    label = "Síť podniků / Provoz ve hře / Staff / Incident / Maximum / Šance",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Incident / Maximum / Šance.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem1 = {
                    label = "Síť podniků / Provoz ve hře / Staff / Incident / Výsledky / 1",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Incident / Výsledky / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem2 = {
                    label = "Síť podniků / Provoz ve hře / Staff / Incident / Výsledky / 2",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Incident / Výsledky / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem3 = {
                    label = "Síť podniků / Provoz ve hře / Staff / Incident / Výsledky / 3",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Incident / Výsledky / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem4 = {
                    label = "Síť podniků / Provoz ve hře / Staff / Incident / Výsledky / 4",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Incident / Výsledky / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentRiskWeight = {
                    label = "Síť podniků / Provoz ve hře / Staff / Incident / Riziko / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Incident / Riziko / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffLoyaltyDecay = {
                    label = "Síť podniků / Provoz ve hře / Staff / Lojalita / Degradace",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Lojalita / Degradace.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffMaximumLevel = {
                    label = "Síť podniků / Provoz ve hře / Staff / Maximum / Úroveň",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Maximum / Úroveň.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffPoachedLoyaltyLoss = {
                    label = "Síť podniků / Provoz ve hře / Staff / Ztráta loajality při přetažení",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Ztráta loajality při přetažení.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionCostBase = {
                    label = "Síť podniků / Provoz ve hře / Staff / Ochrana / Cost / Základní hodnota",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Ochrana / Cost / Základní hodnota.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionHours = {
                    label = "Síť podniků / Provoz ve hře / Staff / Ochrana / Hodiny",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Ochrana / Hodiny.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionIncidentReduction = {
                    label = "Síť podniků / Provoz ve hře / Staff / Ochrana / Incident / Snížení",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Ochrana / Incident / Snížení.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionRiskCost = {
                    label = "Síť podniků / Provoz ve hře / Staff / Ochrana / Riziko / Cost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Ochrana / Riziko / Cost.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryBaseChance = {
                    label = "Síť podniků / Provoz ve hře / Staff / Zotavení / Základní hodnota / Šance",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Zotavení / Základní hodnota / Šance.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryLoyaltyWeight = {
                    label = "Síť podniků / Provoz ve hře / Staff / Zotavení / Lojalita / Hmotnost",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Zotavení / Lojalita / Hmotnost.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageBaseMultiplier = {
                    label = "Síť podniků / Provoz ve hře / Staff / Mzdové platy / Základní hodnota / Násobitel",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Mzdové platy / Základní hodnota / Násobitel.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageLoyaltyGain = {
                    label = "Síť podniků / Provoz ve hře / Staff / Mzdové platy / Lojalita / zisk",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Mzdové platy / Lojalita / zisk.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageSkillDivisor = {
                    label = "Síť podniků / Provoz ve hře / Staff / Mzdové platy / Dovednost / Dělitel",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Mzdové platy / Dovednost / Dělitel.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem1 = {
                    label = "Síť podniků / Provoz ve hře / Staff / Slabiny / 1",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Slabiny / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem2 = {
                    label = "Síť podniků / Provoz ve hře / Staff / Slabiny / 2",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Slabiny / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem3 = {
                    label = "Síť podniků / Provoz ve hře / Staff / Slabiny / 3",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Slabiny / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem4 = {
                    label = "Síť podniků / Provoz ve hře / Staff / Slabiny / 4",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Slabiny / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem5 = {
                    label = "Síť podniků / Provoz ve hře / Staff / Slabiny / 5",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Slabiny / 5.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem6 = {
                    label = "Síť podniků / Provoz ve hře / Staff / Slabiny / 6",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Staff / Slabiny / 6.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsContracts = {
                    label = "Síť podniků / Provoz ve hře / Struktura / Váhy / Kontrakty",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Struktura / Váhy / Kontrakty.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsDealers = {
                    label = "Síť podniků / Provoz ve hře / Struktura / Váhy / Dealerové",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Struktura / Váhy / Dealerové.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsHubs = {
                    label = "Síť podniků / Provoz ve hře / Struktura / Váhy / Distribuční centra",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Struktura / Váhy / Distribuční centra.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsRoutes = {
                    label = "Síť podniků / Provoz ve hře / Struktura / Váhy / Trasy",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Struktura / Váhy / Trasy.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsStaff = {
                    label = "Síť podniků / Provoz ve hře / Struktura / Váhy / Staff",
                    description = "Provozní nastavení pro: Síť podniků / Provoz ve hře / Struktura / Váhy / Staff.",
                },
                drugAdvancedBusinessNetworkSocietyPermission = {
                    label = "Síť podniků / Organizace / Oprávnění",
                    description = "Provozní nastavení pro: Síť podniků / Organizace / Oprávnění.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseCapacity = {
                    label = "Síť podniků / Staff / Distributor / Základní hodnota / kapacita",
                    description = "Provozní nastavení pro: Síť podniků / Staff / Distributor / Základní hodnota / kapacita.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseWage = {
                    label = "Síť podniků / Staff / Distributor / Základní hodnota / Mzdové platy",
                    description = "Provozní nastavení pro: Síť podniků / Staff / Distributor / Základní hodnota / Mzdové platy.",
                },
                drugAdvancedBusinessNetworkStaffPusherCommission = {
                    label = "Síť podniků / Staff / Distributor / Provize",
                    description = "Provozní nastavení pro: Síť podniků / Staff / Distributor / Provize.",
                },
                drugAdvancedBusinessNetworkStaffPusherHirePrice = {
                    label = "Síť podniků / Staff / Distributor / Najmutí / Cena",
                    description = "Provozní nastavení pro: Síť podniků / Staff / Distributor / Najmutí / Cena.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseCapacity = {
                    label = "Síť podniků / Staff / Běžec / Základní hodnota / kapacita",
                    description = "Provozní nastavení pro: Síť podniků / Staff / Běžec / Základní hodnota / kapacita.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseWage = {
                    label = "Síť podniků / Staff / Běžec / Základní hodnota / Mzdové platy",
                    description = "Provozní nastavení pro: Síť podniků / Staff / Běžec / Základní hodnota / Mzdové platy.",
                },
                drugAdvancedBusinessNetworkStaffRunnerCommission = {
                    label = "Síť podniků / Staff / Běžec / Provize",
                    description = "Provozní nastavení pro: Síť podniků / Staff / Běžec / Provize.",
                },
                drugAdvancedBusinessNetworkStaffRunnerHirePrice = {
                    label = "Síť podniků / Staff / Běžec / Najmutí / Cena",
                    description = "Provozní nastavení pro: Síť podniků / Staff / Běžec / Najmutí / Cena.",
                },
                drugAdvancedBusinessNetworkTickMinutes = {
                    label = "Síť podniků / Aktualizační cyklus / Minuty",
                    description = "Provozní nastavení pro: Síť podniků / Aktualizační cyklus / Minuty.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCapacity = {
                    label = "Síť podniků / Přepravy / Letadlo / kapacita",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Letadlo / kapacita.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCost = {
                    label = "Síť podniků / Přepravy / Letadlo / Cost",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Letadlo / Cost.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftDurationMultiplier = {
                    label = "Síť podniků / Přepravy / Letadlo / Násobitel trvání",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Letadlo / Násobitel trvání.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftRisk = {
                    label = "Síť podniků / Přepravy / Letadlo / Riziko",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Letadlo / Riziko.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCapacity = {
                    label = "Síť podniků / Přepravy / Loď / kapacita",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Loď / kapacita.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCost = {
                    label = "Síť podniků / Přepravy / Loď / Cost",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Loď / Cost.",
                },
                drugAdvancedBusinessNetworkTransportsBoatDurationMultiplier = {
                    label = "Síť podniků / Přepravy / Loď / Násobitel trvání",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Loď / Násobitel trvání.",
                },
                drugAdvancedBusinessNetworkTransportsBoatRisk = {
                    label = "Síť podniků / Přepravy / Loď / Riziko",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Loď / Riziko.",
                },
                drugAdvancedBusinessNetworkTransportsCarCapacity = {
                    label = "Síť podniků / Přepravy / Auto / kapacita",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Auto / kapacita.",
                },
                drugAdvancedBusinessNetworkTransportsCarCost = {
                    label = "Síť podniků / Přepravy / Auto / Cost",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Auto / Cost.",
                },
                drugAdvancedBusinessNetworkTransportsCarDurationMultiplier = {
                    label = "Síť podniků / Přepravy / Auto / Násobitel trvání",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Auto / Násobitel trvání.",
                },
                drugAdvancedBusinessNetworkTransportsCarRisk = {
                    label = "Síť podniků / Přepravy / Auto / Riziko",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Auto / Riziko.",
                },
                drugAdvancedBusinessNetworkTransportsFootCapacity = {
                    label = "Síť podniků / Přepravy / Pěšky / kapacita",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Pěšky / kapacita.",
                },
                drugAdvancedBusinessNetworkTransportsFootCost = {
                    label = "Síť podniků / Přepravy / Pěšky / Cost",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Pěšky / Cost.",
                },
                drugAdvancedBusinessNetworkTransportsFootDurationMultiplier = {
                    label = "Síť podniků / Přepravy / Pěšky / Násobitel trvání",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Pěšky / Násobitel trvání.",
                },
                drugAdvancedBusinessNetworkTransportsFootRisk = {
                    label = "Síť podniků / Přepravy / Pěšky / Riziko",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Pěšky / Riziko.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCapacity = {
                    label = "Síť podniků / Přepravy / Nákladní auto / kapacita",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Nákladní auto / kapacita.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCost = {
                    label = "Síť podniků / Přepravy / Nákladní auto / Cost",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Nákladní auto / Cost.",
                },
                drugAdvancedBusinessNetworkTransportsTruckDurationMultiplier = {
                    label = "Síť podniků / Přepravy / Nákladní auto / Násobitel trvání",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Nákladní auto / Násobitel trvání.",
                },
                drugAdvancedBusinessNetworkTransportsTruckRisk = {
                    label = "Síť podniků / Přepravy / Nákladní auto / Riziko",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Nákladní auto / Riziko.",
                },
                drugAdvancedBusinessNetworkTransportsVanCapacity = {
                    label = "Síť podniků / Přepravy / Dodávka / kapacita",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Dodávka / kapacita.",
                },
                drugAdvancedBusinessNetworkTransportsVanCost = {
                    label = "Síť podniků / Přepravy / Dodávka / Cost",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Dodávka / Cost.",
                },
                drugAdvancedBusinessNetworkTransportsVanDurationMultiplier = {
                    label = "Síť podniků / Přepravy / Dodávka / Násobitel trvání",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Dodávka / Násobitel trvání.",
                },
                drugAdvancedBusinessNetworkTransportsVanRisk = {
                    label = "Síť podniků / Přepravy / Dodávka / Riziko",
                    description = "Provozní nastavení pro: Síť podniků / Přepravy / Dodávka / Riziko.",
                },
                interrogationDispatchAdapter = {
                    options = {
                        sky_jobs_base = "Sky Jobs Base",
                        generic = "Obecné napojení",
                        custom = "Vlastní napojení",
                        none = "Vypnuto",
                    },
                },
                reputationRules = {
                    label = "Pravidla reputace",
                    description = "Nastavte pojmenovaná pravidla pro akce a volitelné cíle. Body přidělují pouze zapnutá pravidla.",
                },
            },
            territoryMap = {
                addPoint = "Přidejte bod",
                clear = "Vymazat",
                create = "Vytvořit",
                custom = "Vlastní území",
                deletePoint = "Smazat bod",
                eyebrow = "Editor území",
                minimum = "Minimálně 3",
                pointCount = "{count} bodů",
                presets = "Přednastavené obvody",
                shown = "Zobrazit na mapě",
                street = "Ulice",
                supply = "Zásobování",
                territories = "Území",
                type = "Typ území",
                undo = "Zpět",
            },
            shopPositionTools = {
                currentPosition = "Použít aktuální pozici",
                selectEntity = "Vybrat objekt",
                selectEntityHint = "Namiřte laser na pokladnu nebo trezor. Enter: použít pozici a směr obrysu objektu. Backspace: zrušit.",
            },
            drugSettingSubsections = {
                cultivationLevels = "Úrovně pěstování",
                general = "Obecné",
                runtime = "Přístup k herním akcím",
                quality = "Kvalita",
                packaging = "Balení",
                growing = "Pěstování",
                labs = "Laboratoře a obytné vozy",
                power = "Napájení a vybavení",
                workers = "Pracovníci",
                market = "Trh a distribuce",
                threats = "Razie a sabotáž",
                pvpTakeovers = "Převzemy laboratoří",
                consumption = "Konzumace",
                processing = "Zpracování",
                performance = "Výkon",
                dynamicMarket = "Dynamický trh",
                heat = "Pozornost policie a riziko",
                contacts = "Síť kontaktů",
                business = "Síť podniků",
            },
            drugSettingGroups = {
                cultivationGeneral = { label = "Obecné" },
                cultivationCurve = { label = "Křivka úrovní" },
                cultivationExperience = { label = "Odměny XP" },
                cultivationUnlocks = { label = "Odemykání úrovní" },
                creator = {
                    label = "Otevřít editor",
                },
                creatorSettings = {
                    label = "Nastavení editoru",
                },
                interfaceHud = {
                    label = "Pozice rozhraní",
                },
                drugsGeneral = {
                    label = "Obecné",
                },
                runtimeAccess = {
                    label = "Přístup a vlastnictví",
                },
                runtimePayouts = {
                    label = "Výplaty",
                },
                runtimeDispatch = {
                    label = "Dispečink a policie",
                },
                qualityWeights = {
                    label = "Kvalita / Váhy",
                },
                qualityTiers = {
                    label = "Kvalita / Úrovně kvality",
                },
                packagingGeneral = {
                    label = "Obecné",
                },
                growingGeneral = {
                    label = "Obecné",
                },
                plantDefaults = {
                    label = "Rostlina / Výchozí hodnoty",
                },
                harvestWindow = {
                    label = "Sklizeň / Časové okno",
                },
                labsGeneral = {
                    label = "Obecné",
                },
                labRent = {
                    label = "Nájem a životní cyklus",
                },
                camperDefaults = {
                    label = "Kemp",
                },
                labUpgrades = {
                    label = "Vylepšení",
                },
                labDefaults = {
                    label = "Laboratoř / Výchozí hodnoty",
                },
                powerGeneral = {
                    label = "Obecné",
                },
                generators = {
                    label = "Generátory",
                },
                equipmentWear = {
                    label = "Vybavení",
                },
                workersGeneral = {
                    label = "Obecné",
                },
                marketGeneral = {
                    label = "Obecné",
                },
                marketPrices = {
                    label = "Ceny",
                },
                distribution = {
                    label = "Distribuce",
                },
                threatsGeneral = {
                    label = "Obecné",
                },
                threatHeat = {
                    label = "Policejní tlak",
                },
                threatChances = {
                    label = "Pravděpodobnosti",
                },
                pvpTakeoverRules = {
                    label = "Pravidla převzetí",
                },
                pvpTakeoverZones = {
                    label = "Zóny & Časování",
                },
                pvpTakeoverMethods = {
                    label = "Metody vlámování",
                },
                consumptionGeneral = {
                    label = "Obecné",
                },
                consumerDecay = {
                    label = "Pokles tolerance a závislosti",
                },
                consumerEffects = {
                    label = "Účinky a rizika",
                },
                processingFlow = {
                    label = "Průběh zpracování",
                },
                processingGeneral = {
                    label = "Obecné",
                },
                powerRuntime = {
                    label = "Provoz ve hře",
                },
                powerHeat = {
                    label = "Pozornost policie a energetická stopa",
                },
                powerModes = {
                    label = "Management / Režimy",
                },
                powerPriorities = {
                    label = "Zatížení / Priority",
                },
                performanceInactiveControlIntervalMs = {
                    label = "Neaktivní / Ovládání / Interval / ms",
                },
                performanceInteractionIdleScanIntervalMs = {
                    label = "Interakce / Nečinný / Interval skenování / ms",
                },
                performanceInteractionPromptIntervalMs = {
                    label = "Interakce / Výzva k interakci / Interval / ms",
                },
                performanceInteractionScanIntervalMs = {
                    label = "Interakce / Interval skenování / ms",
                },
                performanceMinimumScanIntervalMs = {
                    label = "Minimum / Interval skenování / ms",
                },
                performanceStreetPedActivationDistance = {
                    label = "Ulice / Ped / Aktivace / Vzdálenost",
                },
                performanceStreetPedIdleScanIntervalMs = {
                    label = "Ulice / Ped / Nečinný / Interval skenování / ms",
                },
                performanceStreetPedScanIntervalMs = {
                    label = "Ulice / Ped / Interval skenování / ms",
                },
                performanceWorldCachePadding = {
                    label = "Svět / Mezipaměť / Dodatečná rezerva",
                },
                performanceWorldCacheRefreshIntervalMs = {
                    label = "Svět / Mezipaměť / Obnovení / Interval / ms",
                },
                performanceWorldIdleIntervalMs = {
                    label = "Svět / Nečinný / Interval / ms",
                },
                dynamicMarketActionCooldownSeconds = {
                    label = "Cooldown akce / sekundů",
                },
                dynamicMarketActionHistoryLimit = {
                    label = "Akce / Limit historie",
                },
                dynamicMarketAmountSaturationWeight = {
                    label = "Množství / Nasycení / Hmotnost",
                },
                dynamicMarketBaseIntelAccuracy = {
                    label = "Základní hodnota / Přesnost informací",
                },
                dynamicMarketDefaultAverageQuality = {
                    label = "Výchozí hodnota / Průměr / Kvalita",
                },
                dynamicMarketDefaultResourceElasticity = {
                    label = "Výchozí hodnota / Surovina / Elasticita",
                },
                dynamicMarketDemandCenter = {
                    label = "Poptávka / Střední hodnota",
                },
                dynamicMarketDemandPriceImpact = {
                    label = "Poptávka / Cena / Dopad",
                },
                dynamicMarketDirectionThreshold = {
                    label = "Směr / Práh",
                },
                dynamicMarketEnabled = {
                    label = "Aktivováno",
                },
                dynamicMarketEventChance = {
                    label = "Událost / Šance",
                },
                dynamicMarketEventDurationMinutes = {
                    label = "Událost / Doba trvání / Minuty",
                },
                dynamicMarketEventMinimumDurationMinutes = {
                    label = "Událost / Minimum / Doba trvání / Minuty",
                },
                dynamicMarketEventStrengthMaximum = {
                    label = "Událost / Síla / Maximum",
                },
                dynamicMarketEventStrengthMinimum = {
                    label = "Událost / Síla / Minimum",
                },
                dynamicMarketEvents = {
                    label = "Události",
                },
                dynamicMarketExactIntelReputation = {
                    label = "Přesné informace / Reputace",
                },
                dynamicMarketExactIntelTrust = {
                    label = "Přesné informace / Důvěra",
                },
                dynamicMarketGlobalZoneLabel = {
                    label = "Global / Zóna / Štítek",
                },
                dynamicMarketHistoryLimit = {
                    label = "Limit historie",
                },
                dynamicMarketInitialDemand = {
                    label = "Počáteční hodnota / Poptávka",
                },
                dynamicMarketInitialPriceMultiplier = {
                    label = "Počáteční hodnota / Násobitel ceny",
                },
                dynamicMarketIntelDemandError = {
                    label = "Informace / Poptávka / Error",
                },
                dynamicMarketIntelMaximumAccuracy = {
                    label = "Informace / Maximum / Přesnost",
                },
                dynamicMarketIntelMinimumAccuracy = {
                    label = "Informace / Minimum / Přesnost",
                },
                dynamicMarketIntelPoliceError = {
                    label = "Informace / Policie / Error",
                },
                dynamicMarketIntelPriceError = {
                    label = "Informace / Cena / Error",
                },
                dynamicMarketIntelPriceMaximum = {
                    label = "Informace / Cena / Maximum",
                },
                dynamicMarketIntelPriceMinimum = {
                    label = "Informace / Cena / Minimum",
                },
                dynamicMarketIntelReputationWeight = {
                    label = "Informace / Reputace / Hmotnost",
                },
                dynamicMarketIntelResourcePriceError = {
                    label = "Informace / Surovina / Cena / Error",
                },
                dynamicMarketIntelSaturationError = {
                    label = "Informace / Nasycení / Error",
                },
                dynamicMarketIntelSeedBucketSeconds = {
                    label = "Okno semene informací / sekundů",
                },
                dynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Informace / Stav / Přesnost / Práh",
                },
                dynamicMarketIntelStatusErrorThreshold = {
                    label = "Informace / Stav / Error / Práh",
                },
                dynamicMarketIntelSupplyError = {
                    label = "Informace / Zásobování / Error",
                },
                dynamicMarketIntelTrustWeight = {
                    label = "Informace / Důvěra / Hmotnost",
                },
                dynamicMarketManipulationCooldownMinutes = {
                    label = "Manipulace / Minuty prodlevy",
                },
                dynamicMarketManipulationDemandShift = {
                    label = "Manipulace / Poptávka / Posun",
                },
                dynamicMarketManipulationDurationMinutes = {
                    label = "Manipulace / Doba trvání / Minuty",
                },
                dynamicMarketManipulationHeat = {
                    label = "Manipulace / Policejní tlak",
                },
                dynamicMarketManipulationMinimumBatchAmount = {
                    label = "Manipulace / Minimum / Šarže / Množství",
                },
                dynamicMarketManipulationPaymentAccount = {
                    label = "Manipulace / Platební účet",
                },
                dynamicMarketManipulationPrice = {
                    label = "Manipulace / Cena",
                },
                dynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Manipulace / Zóna / Policejní tlak / Násobitel",
                },
                dynamicMarketMaximumIntelAgeMinutes = {
                    label = "Maximum / Stáří informací / Minuty",
                },
                dynamicMarketMaximumPriceMultiplier = {
                    label = "Maximum / Násobitel ceny",
                },
                dynamicMarketMinimumIntelAgeMinutes = {
                    label = "Minimum / Stáří informací / Minuty",
                },
                dynamicMarketMinimumMetricWindowMinutes = {
                    label = "Minimum / Metrika / Časové okno / Minuty",
                },
                dynamicMarketMinimumPriceMultiplier = {
                    label = "Minimální cena / Násobitel",
                },
                dynamicMarketMinimumUpdateMinutes = {
                    label = "Minimum / Aktualizace / Minuty",
                },
                dynamicMarketPoliceDemandWeight = {
                    label = "Policie / Poptávka / Hmotnost",
                },
                dynamicMarketPolicePriceImpact = {
                    label = "Policie / Cena / Dopad",
                },
                dynamicMarketPoorQualityDemandPenalty = {
                    label = "Nízká kvalita / Poptávka / Postih",
                },
                dynamicMarketPoorQualityThreshold = {
                    label = "Nízká kvalita / Práh",
                },
                dynamicMarketPremiumQualityDemandBonus = {
                    label = "Prémiová kvalita / Bonus poptávky",
                },
                dynamicMarketPremiumQualityThreshold = {
                    label = "Prémiová kvalita / Práh",
                },
                dynamicMarketProductionSupplyWeight = {
                    label = "Produkce / Zásobování / Hmotnost",
                },
                dynamicMarketProductionWindowMinutes = {
                    label = "Produkce / Časové okno / Minuty",
                },
                dynamicMarketQualityCenter = {
                    label = "Kvalita / Střední hodnota",
                },
                dynamicMarketQualityConfidenceImpact = {
                    label = "Kvalita / Spolehlivost / Dopad",
                },
                dynamicMarketQualityRange = {
                    label = "Kvalita / Rozsah hodnot",
                },
                dynamicMarketRarityBonusMaximum = {
                    label = "Vzácnost / Bonus / Maximum",
                },
                dynamicMarketRegionalGlobalWeight = {
                    label = "Regionální / Global / Hmotnost",
                },
                dynamicMarketRegionalLocalWeight = {
                    label = "Regionální / Místní / Hmotnost",
                },
                dynamicMarketResourceAliases = {
                    label = "Surovina / Alternativní názvy",
                },
                dynamicMarketResourceDirectionFallThreshold = {
                    label = "Surovina / Směr / Pokles / Práh",
                },
                dynamicMarketResourceDirectionRiseThreshold = {
                    label = "Surovina / Směr / Růst / Práh",
                },
                dynamicMarketResources = {
                    label = "Zdroje",
                },
                dynamicMarketSalesWindowMinutes = {
                    label = "Prodeje / Časové okno / Minuty",
                },
                dynamicMarketSaturationDemandWeight = {
                    label = "Nasycení / Poptávka / Hmotnost",
                },
                dynamicMarketSaturationPriceImpact = {
                    label = "Nasycení / Cena / Dopad",
                },
                dynamicMarketScarcityDemandWeight = {
                    label = "Nedostatek / Poptávka / Hmotnost",
                },
                dynamicMarketScarcityPriceImpact = {
                    label = "Nedostatek / Cena / Dopad",
                },
                dynamicMarketSeasonEndMonths = {
                    label = "Roční období / Konec / Měsíce",
                },
                dynamicMarketSeasonMultipliers = {
                    label = "Roční období / Násobitele",
                },
                dynamicMarketShortageRumorThreshold = {
                    label = "Nedostatek / Fáma / Práh",
                },
                dynamicMarketStatusThresholds = {
                    label = "Stav / Prahy",
                },
                dynamicMarketTargetSupply = {
                    label = "Cíl / Zásobování",
                },
                dynamicMarketTrendChance = {
                    label = "Trend / Šance",
                },
                dynamicMarketTrendDurationMinutes = {
                    label = "Trend / Doba trvání / Minuty",
                },
                dynamicMarketTrendMaximumStrength = {
                    label = "Trend / Maximum / Síla",
                },
                dynamicMarketTrendMinimumStrength = {
                    label = "Trend / Minimum / Síla",
                },
                dynamicMarketUpdateMinutes = {
                    label = "Aktualizace / Minuty",
                },
                dynamicMarketVolatilityMaximum = {
                    label = "Kolísání cen / Maximum",
                },
                dynamicMarketVolatilityMinimum = {
                    label = "Kolísání cen / Minimum",
                },
                dynamicMarketWeatherMultipliers = {
                    label = "Počasí / Násobitele",
                },
                dynamicMarketWeatherState = {
                    label = "Počasí / Stav",
                },
                heatActionCooldownSeconds = {
                    label = "Cooldown akce / sekundů",
                },
                heatActivityRiskWeights = {
                    label = "Aktivita / Riziko / Váhy",
                },
                heatAggressiveHeatMultiplier = {
                    label = "Agresivní režim / Policejní tlak / Násobitel",
                },
                heatBurnerBurnThreshold = {
                    label = "Jednorázový telefon / Prozrazení / Práh",
                },
                heatBurnerHeatPerWholesale = {
                    label = "Jednorázový telefon / Policejní tlak / Za velkoobchodní prodej",
                },
                heatBurnerPhoneItem = {
                    label = "Burner phone / Předmět",
                },
                heatCamperOperationalHeatMultiplier = {
                    label = "Obytný vůz v provozu / Policejní tlak / Násobitel",
                },
                heatCamperOperationalHeatThreshold = {
                    label = "Obytný vůz v provozu / Policejní tlak / Práh",
                },
                heatCamperParkedHeat = {
                    label = "Zaparkovaný obytný vůz / Policejní tlak",
                },
                heatContaminatedHeatMultiplier = {
                    label = "Kontaminace / Policejní tlak / Násobitel",
                },
                heatContaminatedThreshold = {
                    label = "Kontaminace / Práh",
                },
                heatCultivationFreePlants = {
                    label = "Pěstování / Rostliny bez dodatečného rizika",
                },
                heatCultivationHeatPerPlant = {
                    label = "Pěstování / Policejní tlak / Za rostlinu",
                },
                heatDealerHiddenMinutes = {
                    label = "Dealer / skryté / Minuty",
                },
                heatDecayPerTick = {
                    label = "Degradace / Za aktualizační cyklus",
                },
                heatEnabled = {
                    label = "Aktivováno",
                },
                heatEnforcementHeat = {
                    label = "Přítomnost policie / Policejní tlak",
                },
                heatEnforcementMultipliers = {
                    label = "Přítomnost policie / Násobitele",
                },
                heatEntityTypes = {
                    label = "Herní objekt / Typy",
                },
                heatEventCooldownMinutes = {
                    label = "Událost / Minuty prodlevy",
                },
                heatEventHistoryLimit = {
                    label = "Událost / Limit historie",
                },
                heatLabHeatSyncThreshold = {
                    label = "Laboratoř / Policejní tlak / Synchronizace / Práh",
                },
                heatLayLowCooldownMinutes = {
                    label = "Držet se v ústraní / Minuty prodlevy",
                },
                heatLayLowIdleMinutes = {
                    label = "Držet se v ústraní / Nečinný / Minuty",
                },
                heatLayLowReduction = {
                    label = "Držet se v ústraní / Snížení",
                },
                heatLockdownMinutes = {
                    label = "Uzavření / Minuty",
                },
                heatMinimumDurationMinutes = {
                    label = "Minimum / Doba trvání / Minuty",
                },
                heatMinimumEventCooldownSeconds = {
                    label = "Minimum / Událost / Dočasné omezení (sekundy)",
                },
                heatMinimumIdleSeconds = {
                    label = "Minimum / Nečinný / sekundů",
                },
                heatProcessingHeatMultiplier = {
                    label = "Zpracování / Policejní tlak / Násobitel",
                },
                heatRiskWeights = {
                    label = "Riziko / Váhy",
                },
                heatRotateBurnerReduction = {
                    label = "Vyměnit jednorázový telefon / Snížení",
                },
                heatRouteControlMinutes = {
                    label = "Trasa / Ovládání / Minuty",
                },
                heatSaleHeat = {
                    label = "Prodej / Policejní tlak",
                },
                heatThresholds = {
                    label = "Prahy",
                },
                heatTickMinutes = {
                    label = "Aktualizační cyklus / Minuty",
                },
                heatWholesaleHeatMultiplier = {
                    label = "Velkoobchod / Policejní tlak / Násobitel",
                },
                heatWorkerLeakAlertRadius = {
                    label = "Pracovník / Únik informací / Radius poplachu",
                },
                heatWorkerLeakBaseChance = {
                    label = "Pracovník / Únik informací / Základní hodnota / Šance",
                },
                heatWorkerLeakFactionMultiplier = {
                    label = "Pracovník / Únik informací / Frakce / Násobitel",
                },
                heatWorkerLeakHighSeverityThreshold = {
                    label = "Pracovník / Únik informací / Vysoká / Závažnost / Práh",
                },
                heatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Pracovník / Únik informací / Lojalita / Šance / Násobitel",
                },
                heatWorkerLeakLoyaltyThreshold = {
                    label = "Pracovník / Únik informací / Lojalita / Práh",
                },
                heatWorkerLeakMaximumChance = {
                    label = "Pracovník / Únik informací / Maximum / Šance",
                },
                heatWorkerLeakMinimumCooldownSeconds = {
                    label = "Pracovník / Únik informací / Minimum / Dočasné omezení (sekundy)",
                },
                heatWorkerLeakRouteMultiplier = {
                    label = "Pracovník / Únik informací / Trasa / Násobitel",
                },
                heatWorkerLeakStrengthMaximum = {
                    label = "Pracovník / Únik informací / Síla / Maximum",
                },
                heatWorkerLeakStrengthMinimum = {
                    label = "Pracovník / Únik informací / Síla / Minimum",
                },
                heatWorkerLeakStrengthMultiplier = {
                    label = "Pracovník / Únik informací / Síla / Násobitel",
                },
                heatWorkerLeakStressChanceMultiplier = {
                    label = "Pracovník / Únik informací / Stres / Šance / Násobitel",
                },
                heatWorkerLeakStressThreshold = {
                    label = "Pracovník / Únik informací / Stres / Práh",
                },
                contactsActionCooldownSeconds = {
                    label = "Cooldown akce / sekundů",
                },
                contactsActiveHotspotCount = {
                    label = "Počet aktivních ohnisek",
                },
                contactsBurnerHintTrust = {
                    label = "Tip pro burner / Důvěra",
                },
                contactsBurnerOfferMaximumMultiplier = {
                    label = "Jednorázový telefon / Nabídka / Maximum / Násobitel",
                },
                contactsBurnerOfferMinimumMultiplier = {
                    label = "Jednorázový telefon / Nabídka / Minimum / Násobitel",
                },
                contactsBuyerCooldownMinutes = {
                    label = "Kupec / Minuty prodlevy",
                },
                contactsBuyerDeliveryDistance = {
                    label = "Kupec / Vzdálenost doručení",
                },
                contactsBuyerPremiumSuccessScore = {
                    label = "Kupec / Prémiové / Úspěch / Skóre",
                },
                contactsBuyerPremiumTrustGain = {
                    label = "Kupec / Prémiové / Důvěra / zisk",
                },
                contactsBuyerRequestHeatRiskWeight = {
                    label = "Kupec / Požadavek / Hledanost a riziko / Hmotnost",
                },
                contactsBuyerStandardTrustGain = {
                    label = "Kupec / Standardní / Důvěra / zisk",
                },
                contactsContactActiveDelaySeconds = {
                    label = "Prodleva aktivace kontaktu / sekundů",
                },
                contactsContactDemandRange = {
                    label = "Contact / Poptávka / Rozsah hodnot",
                },
                contactsContactLossTrust = {
                    label = "Contact / Ztráta / Důvěra",
                },
                contactsDarknetExactIntelMinutes = {
                    label = "Darknet / Přesné informace / Minuty",
                },
                contactsDarknetHotspotIntelPrice = {
                    label = "Darknet / Aktivní oblast / Informace / Cena",
                },
                contactsDarknetIntelPrice = {
                    label = "Darknet / Informace / Cena",
                },
                contactsDealerBasePrice = {
                    label = "Dealer / Základní cena",
                },
                contactsDealerHireCapacity = {
                    label = "Dealer / Najmutí / kapacita",
                },
                contactsDealerHireRisk = {
                    label = "Dealer / Najmutí / Riziko",
                },
                contactsDealerHireSkill = {
                    label = "Dealer / Najmutí / Dovednost",
                },
                contactsDealerOffers = {
                    label = "Nabídky dealerů",
                },
                contactsDealerProtectionHours = {
                    label = "Dealer / Ochrana / Hodiny",
                },
                contactsDealerProtectionPrice = {
                    label = "Dealer / Ochrana / Cena",
                },
                contactsDealerSaleMax = {
                    label = "Dealer / Prodej / Maximum",
                },
                contactsDealerSaleMin = {
                    label = "Dealer / Prodej / Minimum",
                },
                contactsDealerSimulation = {
                    label = "Dealer / Simulace",
                },
                contactsDealerTickMinutes = {
                    label = "Dealer / Aktualizační cyklus / Minuty",
                },
                contactsDealerWage = {
                    label = "Dealer / Mzdové platy",
                },
                contactsDealerWageDecay = {
                    label = "Dealer / Mzdové platy / Degradace",
                },
                contactsDealerWageLoyaltyGain = {
                    label = "Dealer / Mzdové platy / Lojalita / zisk",
                },
                contactsDealerWeaknesses = {
                    label = "Dealer / Slabiny",
                },
                contactsDefaultContactDemand = {
                    label = "Výchozí hodnota / Contact / Poptávka",
                },
                contactsDefaultContactRisk = {
                    label = "Výchozí hodnota / Contact / Riziko",
                },
                contactsDefaultDealerCapacity = {
                    label = "Výchozí dealer / kapacita",
                },
                contactsDefaultDealerRisk = {
                    label = "Výchozí dealer / Riziko",
                },
                contactsDefaultDealerSkill = {
                    label = "Výchozí dealer / Dovednost",
                },
                contactsDefaultHotspotRadius = {
                    label = "Výchozí hodnota / Aktivní oblast / Poloměr",
                },
                contactsDemandResetMinutes = {
                    label = "Reset poptávky (minuty)",
                },
                contactsEnabled = {
                    label = "Aktivováno",
                },
                contactsExactLocationTrust = {
                    label = "Přesná poloha / Důvěra",
                },
                contactsFactionDiscoveryReputation = {
                    label = "Frakce / Objevení / Reputace",
                },
                contactsFactionHintTrust = {
                    label = "Frakce / Nápověda / Důvěra",
                },
                contactsFailedDeliveryCooldownMinutes = {
                    label = "Neúspěšná dodávka / Minuty prodlevy",
                },
                contactsFakeDealEncounter = {
                    label = "Falešný obchod / Setkání",
                },
                contactsFallbackPreferredDrug = {
                    label = "Náhradní hodnota / Preferovaná droga",
                },
                contactsFallbackProductLabel = {
                    label = "Náhradní hodnota / Název produktu",
                },
                contactsGuideBookItem = {
                    label = "Průvodce / Kniha / Předmět",
                },
                contactsGuideBookTrust = {
                    label = "Průvodce / Kniha / Důvěra",
                },
                contactsHireDealerPrice = {
                    label = "Najmout dealera / Cena",
                },
                contactsHistoryLimit = {
                    label = "Limit historie",
                },
                contactsHotspotIntelMinutes = {
                    label = "Aktivní oblast / Informace / Minuty",
                },
                contactsHotspotRotationMinutes = {
                    label = "Aktivní oblast / Střídání / Minuty",
                },
                contactsListingDurationMinutes = {
                    label = "Nabídka / Doba trvání / Minuty",
                },
                contactsMaxOwnedDealers = {
                    label = "Maximum / Vlastní / Dealerové",
                },
                contactsMinimumBuyerDeliveryDistance = {
                    label = "Minimum / Kupec / Vzdálenost doručení",
                },
                contactsMinimumContactRotationMinutes = {
                    label = "Minimum / Rotace kontaktů (minuty)",
                },
                contactsMinimumDemandResetMinutes = {
                    label = "Minimum / Reset poptávky (minuty)",
                },
                contactsMinimumHeatMultiplier = {
                    label = "Minimum / Policejní tlak / Násobitel",
                },
                contactsMinimumHotspotIntelMinutes = {
                    label = "Minimum / Aktivní oblast / Informace / Minuty",
                },
                contactsMinimumHotspotRadius = {
                    label = "Minimum / Aktivní oblast / Poloměr",
                },
                contactsMinimumHotspotRotationMinutes = {
                    label = "Minimum / Aktivní oblast / Střídání / Minuty",
                },
                contactsMinimumListingDurationMinutes = {
                    label = "Minimum / Nabídka / Doba trvání / Minuty",
                },
                contactsMinimumRewardMultiplier = {
                    label = "Minimální odměna / Násobitel",
                },
                contactsMinimumRobberyMultiplier = {
                    label = "Minimum / Přepadení / Násobitel",
                },
                contactsMinimumSpotPriceMultiplier = {
                    label = "Minimum / Místo / Násobitel ceny",
                },
                contactsOtherDrugPriceMultiplier = {
                    label = "Jiný zdroj / Droga / Násobitel ceny",
                },
                contactsPaymentAccount = {
                    label = "Platební účet",
                },
                contactsPostDeliveryDemandResetSeconds = {
                    label = "Po dodávce / Poptávka / Reset / sekundů",
                },
                contactsPreferredDrugPriceMultiplier = {
                    label = "Preferovaná droga / Násobitel ceny",
                },
                contactsRegionLocationTrust = {
                    label = "Region / Poloha / Důvěra",
                },
                contactsRequestAmounts = {
                    label = "Požadavek / Množství",
                },
                contactsRotationMinutes = {
                    label = "Střídání / Minuty",
                },
                contactsSpotPools = {
                    label = "Místo / Výběrové skupiny",
                },
                contactsStreetHotspots = {
                    label = "Ulice / Aktivní oblasti",
                },
                contactsTrustLevels = {
                    label = "Důvěra / Úrovně",
                },
                businessActionCooldownSeconds = {
                    label = "Cooldown akce / sekundů",
                },
                businessBalance = {
                    label = "Zůstatek",
                },
                businessContracts = {
                    label = "Kontrakty",
                },
                businessDefaultBusinessName = {
                    label = "Výchozí hodnota / Název firmy",
                },
                businessDefaultRankId = {
                    label = "Výchozí hodnota / Rank / ID",
                },
                businessDefaultStaffStyle = {
                    label = "Výchozí hodnota / Staff / Styl práce",
                },
                businessDefaultTransport = {
                    label = "Výchozí hodnota / Doprava",
                },
                businessEnabled = {
                    label = "Aktivováno",
                },
                businessHubs = {
                    label = "Distribuční centra",
                },
                businessLimits = {
                    label = "Limity",
                },
                businessPayments = {
                    label = "Platby",
                },
                businessPayoutAccount = {
                    label = "Výplata / Účet",
                },
                businessRanks = {
                    label = "Hodnosti",
                },
                businessReportDays = {
                    label = "Období přehledu / dní",
                },
                businessRouteEndpointTypes = {
                    label = "Trasa / Koncový bod / Typy",
                },
                businessRuntime = {
                    label = "Provoz ve hře",
                },
                businessSocietyPermission = {
                    label = "Organizace / Oprávnění",
                },
                businessStaff = {
                    label = "Zaměstnanci",
                },
                businessTickMinutes = {
                    label = "Aktualizační cyklus / Minuty",
                },
                businessTransports = {
                    label = "Přepravy",
                },
            },
            territorySettings = {
                section = "Teritoria",
                zonesGroup = "Zóny území",
                sourceLabel = "Zdroj zóny",
                sourceDescription = "Použijte chráněné přednastavené obvody nebo definujte vlastní polygony území.",
                sourcePreset = "Přednastavené obvody",
                sourceCustom = "Vlastní území",
                editLabel = "Editor území",
                editDescription = "Upravte obvody používané vybraným zdrojem zóny.",
                editButton = "Upravit území",
                presetSection = "Přednastavené obvody",
                presetEntry = "Přednastavený obvod",
                customSection = "Vlastní území",
                customEntry = "Vlastní území",
                typeLabel = "Typ území",
                streetType = "Ulice",
                supplyType = "Zásobování",
                enabledLabel = "Zobrazit na mapě",
                enabledDescription = "Deaktivované přednastavené obvody jsou odstraněny z mapy a nelze si je nárokovat.",
                zoneLabel = "Hranice území",
                zoneDescription = "Vytvořte alespoň tři body postupně kolem hranice území.",
                ownershipGroup = "Vlastnictví",
                decayGroup = "Degradace",
                presenceGroup = "Přítomnost",
                activityGroup = "Skóre aktivity",
                ownershipBenefitsGroup = "Výhody vlastníku",
                ownershipThresholdLabel = "Práh vlastníku",
                ownershipThresholdDescription = "Procento kontroly, které musí gang překročit, aby oficiálně vlastnil území.",
                activityFloorLabel = "Fixní základní aktivita",
                activityFloorDescription = "Počet bodů vlivu vyžadovaný, pokud jsou deaktivovány základy založené na velikosti.",
                floorByZoneSizeLabel = "Škálovat základnu podle velikosti zóny",
                floorByZoneSizeDescription = "Vypočítá základní aktivitu každého území z plochy polygonu namísto použití fixní základy.",
                floorPointsPerSizeUnitLabel = "Bodů za km²",
                floorPointsPerSizeUnitDescription = "Počet bodů aktivity vyžadovaný pro každý čtvereční kilometr plochy území.",
                fixedFloorRequirement = "Deaktivujte základy založené na velikosti pro úpravu fixní základní aktivity.",
                sizeFloorRequirement = "Aktivujte základy založené na velikosti pro úpravu bodů na čtvereční kilometr.",
                dailyDecayLabel = "Denní degradace vlivu",
                dailyDecayDescription = "Procento vlivu odstraněného každých 24 hodin.",
                presenceIntervalLabel = "Interval přítomnosti",
                presenceIntervalDescription = "Minuty mezi automatickým přidělováním bodů za přítomnost.",
                presencePointsLabel = "Body přítomnosti na člena",
                presencePointsDescription = "Body přítomnosti přidělené každému způsobilému členu gangu za jeden interval.",
                drugSalesEnabledLabel = "Prodej NPC poskytuje vliv na území",
                drugSalesEnabledDescription = "Úspěšné pouliční prodeje NPC přinášejí vliv gangu prodejce v aktuálním pouličním území.",
                drugSalePointsLabel = "Body za prodané drogy",
                drugSalePointsDescription = "Body vlivu přidělené za každou jednotku drogy nahlásenou jako prodaná.",
                drugSalesRequirement = "Aktivujte vliv z prodeje NPC pro konfiguraci bodů.",
                graffitiPointsLabel = "Body za graffiti za 24 hodin",
                graffitiPointsDescription = "Body přítomnosti přidělené, pokud graffiti existuje celkem 24 nahlášených hodin.",
                streetSellingPriceBonusLabel = "Bonus k ceně pouličního prodeje",
                streetSellingPriceBonusDescription = "Procentuální bonus k cenám prodeje drog pro oficiálního vlastníka pouličního území.",
                supplyProductionSpeedBonusLabel = "Bonus k rychlosti výroby zásob",
                supplyProductionSpeedBonusDescription = "Procentuální bonus k rychlosti výroby drog pro oficiálního vlastníka zásobního území.",
                pruneToleranceLabel = "Tolerance pro ořezávání vlivu",
                pruneToleranceDescription = "Efektivní vliv pod touto hodnotou se považuje za nulu.",
            },
            graffitiSettings = {
                section = "Graffiti",
                generalGroup = "Obecné",
                streamingGroup = "Renderování",
                moderationGroup = "Moderace",
                graffitiEnabledLabel = "Aktivovat graffiti",
                graffitiEnabledDescription = "Umožuje hráčům stříkat a prohlížet graffiti.",
                graffitiRequireItemLabel = "Vyžadovat sprej",
                graffitiRequireItemDescription = "Pro stříkání potřebují hráči předmět sprej. V opačném případě se používá příkaz /graffiti.",
                graffitiChargesPerCanLabel = "Náplň na jednu nádobku",
                graffitiChargesPerCanDescription = "Kolik graffiti lze vytvořit jednou nádobkou.",
                graffitiCooldownSecondsLabel = "Doba čekání na sprej",
                graffitiCooldownSecondsDescription = "Počet sekund, které musí hráč počkat mezi jednotlivými spreji.",
                graffitiMaxPerPlayerLabel = "Max. graffiti na hráče",
                graffitiMaxPerPlayerDescription = "Maximální počet aktivních graffiti, které může hráč vlastnit. 0 znamená neomezeně.",
                graffitiMaxDistanceLabel = "Max. vzdálenost spreje",
                graffitiMaxDistanceDescription = "V metrech, jak daleko může být zeď, aby bylo možné na ni stále stříkat.",
                graffitiSprayDurationLabel = "Doba stříkání",
                graffitiSprayDurationDescription = "Délka animace stříkání v milisekundách.",
                graffitiExpiryDaysLabel = "Doba vypršení",
                graffitiExpiryDaysDescription = "Počet dní, než graffiti automaticky zmizí. 0 znamená nikdy.",
                graffitiTerritoryHoursLabel = "Hodiny teritoriální přítomnosti na jeden sprej",
                graffitiTerritoryHoursDescription = "Počet hodin teritoriální přítomnosti, které čerstvé graffiti poskytne jeho gangu.",
                graffitiStreamRadiusLabel = "Radius streamování",
                graffitiStreamRadiusDescription = "Vzdálenost v metrech, od které je graffiti pro hráče viditelné.",
                graffitiPoolSizeLabel = "Velikost poolu nálepek",
                graffitiPoolSizeDescription = "Kolik graffiti se vykresluje najednou. Vyšší hodnoty nároky na výkon.",
                graffitiReportsEnabledLabel = "Aktivovat hlášení",
                graffitiReportsEnabledDescription = "Umožuje hráčům hlásit urážlivá graffiti.",
                graffitiAutoHideThresholdLabel = "Práh automatického skrytí",
                graffitiAutoHideThresholdDescription = "Počet hlášení, které graffiti automaticky skryje. 0 toto vypne.",
            },
            darknetSettings = {
                section = "Darknetový trh",
                availabilityGroup = "Dostupnost",
                economyGroup = "Kryptoměna",
                listingsGroup = "Nabídky a expirace",
                chatGroup = "Soukromý chat",
                identityGroup = "Aliasy a reputace",
                deliveryGroup = "Předání a dead dropy",
                policeGroup = "Přístup policie",
                npcGroup = "NPC obchodníci",
                enabledLabel = "Aktivovat Darknetový trh",
                enabledDescription = "Aktivuje aplikaci černobazarového tabletu a její běh.",
                tabletOrderLabel = "Pořadí aplikací na tabletu",
                tabletOrderDescription = "Určuje polohu Darknetového trhu na tabletu.",
                currencyCodeLabel = "Kód měny",
                currencyCodeDescription = "Krátký název pro interní kryptoměnový účet.",
                starterBalanceLabel = "Počáteční zůstatek peněženky",
                starterBalanceDescription = "Kryptoměna je přidělena pouze tehdy, když hráč otevře trh poprvé.",
                exchangeEnabledLabel = "Aktivovat výměnu mincí",
                exchangeEnabledDescription = "Umožňuje autentifikovaným uživatelům BlackBay kupovat a prodávat mince na jejich stránce účtu.",
                exchangeAccountLabel = "Platební účet pro výměnu",
                exchangeAccountDescription = "Frameworkový účet používaný pro nákupy mincí a výplaty z prodeje mincí.",
                exchangeBuyPriceLabel = "Kupní cena za minci",
                exchangeBuyPriceDescription = "Částka strávená z platebního účtu za jednu minci.",
                exchangeSellPriceLabel = "Prodejní cena za minci",
                exchangeSellPriceDescription = "Částka vyplacená na platební účet za jednu minci.",
                exchangeMinimumLabel = "Minimální počet mincí na výměnu",
                exchangeMinimumDescription = "Nejmenší celé množství mincí přijímané při jedné výměně.",
                exchangeMaximumLabel = "Maximální počet mincí na výměnu",
                exchangeMaximumDescription = "Největší celé množství mincí přijímané při jedné výměně.",
                accountMoney = "Hotovost",
                accountBank = "Banka",
                accountBlackMoney = "Špinavé peníze",
                scamChanceLabel = "Globální šance na podvod NPC (%)",
                scamChanceDescription = "Minimální šance, že NPC při obchodu vezme platbu nebo zboží, aniž by dodal protihodnotu. Vyšší šance specifická pro obchodníka bude stále platit.",
                listingExpiryLabel = "Doba trvání nabídky (hodiny)",
                listingExpiryDescription = "Aktivní nabídky vyprší samy po tomto počtu hodin.",
                renewalHoursLabel = "Doba obnovení (hodiny)",
                renewalHoursDescription = "Počet hodin přičtených při obnovení nabídky vlastníkem.",
                maximumListingsLabel = "Maximální počet aktivních nabídek",
                maximumListingsDescription = "Maximální počet nabídek na jeden aktivní alias.",
                maximumQuantityLabel = "Maximální množství zboží",
                maximumQuantityDescription = "Horní limit množství pro jednu nabídku.",
                maximumPriceLabel = "Maximální jednotková cena",
                maximumPriceDescription = "Horní cena v kryptoměnách za jednu jednotku.",
                maximumMessageLengthLabel = "Maximální délka zprávy",
                maximumMessageLengthDescription = "Maximální počet znaků v šifrované chatovací zprávě.",
                aliasCooldownLabel = "Doba čekání na změnu aliasu (hodiny)",
                aliasCooldownDescription = "Minimální věk identity předtím, než může být znovu ukončena.",
                verifiedSalesLabel = "Počet prodejů pro ověření",
                verifiedSalesDescription = "Počet úspěšných prodejů vyžadovaný k tomu, aby se prodejce stal ověřeným.",
                verifiedRatingLabel = "Hodnocení vyžadované pro ověření",
                verifiedRatingDescription = "Minimální průměrné hodnocení pro ověřeného prodejce.",
                scammerReportsLabel = "Hlášení pro varování před podvodníkem",
                scammerReportsDescription = "Počet unikátních hlášení o obchodu vyžadovaný pro odznám známého podvodníka.",
                meetingDistanceLabel = "Vzdálenost předání",
                meetingDistanceDescription = "Maximální vzdálenost mezi oběma hráči nebo mezi hráčem a konfigurovaným bodem NPC.",
                dropModelLabel = "Model krabice pro dead-drop",
                dropModelDescription = "Model GTA objektu spawlovaný lokálně pro dostupné dead-dropy.",
                dropStreamLabel = "Vzdálenost streamování dead-dropu",
                dropStreamDescription = "Vzdálenost, při které se streamují krabice a kontakty pro setkání s NPC.",
                dropInteractionLabel = "Vzdálenost interakce s dead-dropem",
                dropInteractionDescription = "Vzdálenost vyžadovaná k prohledání a vyzvednutí krabice.",
                dropLifetimeLabel = "Doba trvání dead-dropu (hodiny)",
                dropLifetimeDescription = "Čas, po kterém nevyzvedená krabice vyprší.",
                dropPollLabel = "Interval obnovy světa (ms)",
                dropPollDescription = "Interval používaný k obnovení blízkých krabic a setkání s NPC.",
                policeGroupsLabel = "Autorizované policejní pracovní skupiny",
                policeGroupsDescription = "Klíče skupin v konfigurátoru práce, které mohou zveřejňovat lákavé nabídky a sledovat vyšetřování.",
                policeGroupEntry = "Policejní skupina",
                groupKeyLabel = "Klíč skupiny",
                npcTradersLabel = "NPC kupující a prodávající",
                npcTradersDescription = "Konfigurace trvalých syntetických nabídek, metody doručení, reputace a pravděpodobnosti podvodu.",
                npcTraderEntry = "NPC obchodník",
                npcIdLabel = "ID",
                npcAliasLabel = "Alias",
                npcSideLabel = "Strana trhu",
                sideSell = "Prodává hráčům",
                sideBuy = "Kupuje od hráčů",
                npcTitleLabel = "Název nabídky",
                npcDescriptionLabel = "Popis",
                npcItemNameLabel = "Název položky v inventáři",
                npcItemLabelLabel = "Název zboží",
                npcQuantityLabel = "Množství",
                npcPriceLabel = "Cena za jednotku",
                npcDeliveryLabel = "Způsob doručení",
                deliveryBoth = "Schůzka a dead drop",
                deliveryMeeting = "Pouze osobně",
                deliveryDrop = "Pouze dead drop",
                npcScamChanceLabel = "Šance na podvod obchodníka (%)",
                npcPedModelLabel = "Model NPC pedia",
                npcRatingLabel = "Zobrazené hodnocení",
                npcRatingCountLabel = "Počet zobrazených hodnocení",
                npcTradesLabel = "Zobrazené úspěšné obchody",
                npcVerifiedLabel = "Ověřený obchodník",
                npcScammerLabel = "Známý podvodník",
                npcEnabledLabel = "Aktivováno",
            },
            interrogationSettings = {
                section = "Výslech",
                generalGroup = "Obecné",
                consentGroup = "Ochrana hráčů",
                objectGroup = "Objekty",
                grabGroup = "Převzímání",
                sessionGroup = "Výslech",
                dispatchGroup = "Policijní poplachy",
                loggingGroup = "Záznamy",
                securityGroup = "Zabezpečení",
                presentationGroup = "Prezentace",
                enabledLabel = "Aktivovat vyšetřování",
                enabledDescription = "Umožňuje hráčům poutat ostatní k vyšetřovacím židlím a používat na ně nástroje.",
                consentRequiredLabel = "Vyžadovat souhlas",
                consentRequiredDescription = "Oběťmi mohou být pouze hráči, kteří udělili souhlas. Souhlas se již neuděluje žádným způsobem, proto je nutné nastavit položku níže.",
                consentDefaultLabel = "Výchozí souhlas",
                consentDefaultDescription = "Nové postavy začínají s uděleným souhlasem namísto odmítnutí.",
                globalIntensityLabel = "Intenzita efektů",
                globalIntensityDescription = "Škáluje obrazové efekty, částice a zvuk. 0 je zcela vypne.",
                maxPerPlayerLabel = "Objektů na hráče",
                maxPerPlayerDescription = "Kolik židlí a vozíků může jeden hráč umístit. 0 znamená neomezeně.",
                maxGlobalLabel = "Objektů na celý server",
                maxGlobalDescription = "Celkový počet umístěných objektů najednou. 0 znamená neomezeně.",
                placementDistanceLabel = "Vzdálenost umístění",
                placementDistanceDescription = "Jak daleko od hráče může být objekt umístěn, v metrech.",
                interactDistanceLabel = "Interakční vzdálenost",
                interactDistanceDescription = "Jak blízko musí být hráč u židle nebo vozíku, v metrech.",
                inactivityMinutesLabel = "Automatické odstranění po",
                inactivityMinutesDescription = "Minut nečinnosti, než umístěný objekt zmizí. 0 jej ponechá navždy.",
                persistObjectsLabel = "Ponechat objekty po restartu",
                persistObjectsDescription = "Umístěné objekty jsou po obnovení serveru obnoveny z databáze.",
                grabEnabledLabel = "Aktivovat převzímání",
                grabEnabledDescription = "Umožňuje hráčům převzít kontrolu nad jiným hráčem a odnést ho.",
                grabItemLabel = "Vyžadovaný předmět",
                grabItemDescription = "Předmět, který útočník potřebuje k převzetí kontroly nad někým. Nechte prázdné, pokud žádný není vyžadován.",
                grabAngleLabel = "Úhel přiblížení",
                grabAngleDescription = "Jak daleko od přímého zadního pozice útočníka může oběť stát, v stupních.",
                grabHealthBelowLabel = "Práh zdraví",
                grabHealthBelowDescription = "Oběť s tímto zdravím níže může být převzímána bez poutání. 0 tuto funkci vypne.",
                grabCooldownLabel = "Dočasné omezení po neúspěchu",
                grabCooldownDescription = "Počet sekund předtím, než lze znovu pokusit o neúspěšné převzímání.",
                grabVehiclesLabel = "Povolená vozidla",
                grabVehiclesDescription = "Modely vozidel, do kterých lze převzímánou oběť nalodit.",
                carryEnabledLabel = "Umožnit přenášení",
                carryEnabledDescription = "Umožňuje útočníkovi nést oběť přes rameno.",
                restrictVisionLabel = "Omezit vidění oběti",
                restrictVisionDescription = "Zatemní obraz oběti během jejího transportu.",
                escapeEnabledLabel = "Umožnit pokusy o útěk",
                escapeEnabledDescription = "Umožňuje transportované oběti pokusit se vyvázat.",
                escapeSecondsLabel = "Doba útěku",
                escapeSecondsDescription = "Počet sekund, které musí oběť držet klávesu, aby se osvobodila.",
                maxDurationLabel = "Maximální doba",
                maxDurationDescription = "Počet minut, po nichž relace sama skončí.",
                warnMinutesLabel = "Varování před koncem",
                warnMinutesDescription = "Počet minut před limitem, kdy jsou obě strany varovány.",
                idleMinutesLabel = "Uvolnění při nečinnosti",
                idleMinutesDescription = "Počet minut bez jakékoli interakce, než je oběť zwolněna.",
                selfReleaseMinutesLabel = "Samovolné osvobození po",
                selfReleaseMinutesDescription = "Počet minut bez interakce útočníka, než se oběť může sama osvobodit.",
                graceSecondsLabel = "Grace period po odpojení",
                graceSecondsDescription = "Počet sekund, po dobu kterých zůstane oběť svázána, když útočník opustí server.",
                rescueEnabledLabel = "Umožnit záchranu",
                rescueEnabledDescription = "Umožňuje nezúčastněným hráčům osvobodit svázanou oběť.",
                rescueSecondsLabel = "Doba záchrany",
                rescueSecondsDescription = "Počet sekund, které zachránce potřebuje k odříznutí oběti.",
                rescueItemLabel = "Předmět pro záchranu",
                rescueItemDescription = "Předmět, který zachránce potřebuje. Pokud necháte prázdné, nebude potřeba žádný.",
                allowInventoryLabel = "Oběť si ponechává inventář",
                allowInventoryDescription = "Vázaná oběť si stále může otevřít svůj inventář.",
                dispatchEnabledLabel = "Aktivovat policejní poplachy",
                dispatchEnabledDescription = "Reportovat kidnappings a výslechy složkám mimořádných událostí.",
                dispatchAdapterLabel = "Systém poplachů",
                dispatchAdapterDescription = "Který dispečerský systém přijímá hlášení.",
                dispatchJobsLabel = "Příjemné pracovní pozice",
                dispatchJobsDescription = "Pracovní pozice, které obdrží poplach.",
                dispatchGrabChanceLabel = "Šance na přemáhnutí",
                dispatchGrabChanceDescription = "Procentuální šance, že bude přemáhnutí nahlášeno.",
                dispatchFixateChanceLabel = "Šance na svázání",
                dispatchFixateChanceDescription = "Procentuální šance, že bude svázání na židli nahlášeno.",
                dispatchToolChanceLabel = "Šance na použití nástroje",
                dispatchToolChanceDescription = "Procentuální šance, že použití nástroje bude nahlášeno.",
                dispatchWitnessLabel = "Vyžadovat svědka",
                dispatchWitnessDescription = "Nahlásit pouze v případě, že je jiný hráč dostatečně blízko, aby si toho všiml.",
                dispatchWitnessRadiusLabel = "Poloměr svědka",
                dispatchWitnessRadiusDescription = "Jak blízko musí být svědek, v metrech.",
                dispatchCooldownLabel = "Dočasné omezení poplachů",
                dispatchCooldownDescription = "Počet sekund mezi dvěma poplachy ze stejné relace.",
                dispatchInaccuracyLabel = "Nepřesnost polohy",
                dispatchInaccuracyDescription = "Počet metrů, o které bude nahlášená poloha náhodně posunuta. 0 reportuje přesné místo.",
                loggingEnabledLabel = "Aktivovat logování",
                loggingEnabledDescription = "Záznam umístění, přemáhnutí, použití nástrojů, propuštění a administrátorských akcí.",
                logDatabaseLabel = "Záznam do databáze",
                logDatabaseDescription = "Kromě toho zapíše každý záznam do tabulky logů výslechu.",
                logRetentionLabel = "Ponechat záznamy v logu",
                logRetentionDescription = "Počet dní, než jsou záznamy v databázi odstraněny. 0 je uchovává navždy.",
                pingToleranceLabel = "Tolerance vzdálenosti",
                pingToleranceDescription = "Metry přičtené ke každému kontrole vzdálenosti na straně serveru pro eliminaci lagů.",
                violationThresholdLabel = "Práh porušení pravidel",
                violationThresholdDescription = "Počet porušení bezpečnosti v rámci časového okna před spuštěním reakce. 0 tuto funkci vypne.",
                violationActionLabel = "Reakce na porušení pravidel",
                violationActionDescription = "Co se stane, jakmile hráč překročí práh porušení pravidel.",
                violationActionNone = "Nedělat nic",
                violationActionLog = "Pouze logovat",
                violationActionKick = "Vyloučit",
                violationActionCheating = "Nahlásit jako podvádění",
                particlesLabel = "Částicové efekty",
                particlesDescription = "Zobrazit krev, jiskry a plameny při použití nástroje.",
                soundLabel = "Zvukové efekty",
                soundDescription = "Přehrát zvuky nástroje pro všechny v blízkosti.",
                cameraWorkLabel = "Práce s kamerou",
                cameraWorkDescription = "Pohyb kamery při svazování někoho a při použití nástroje.",
                screenEffectsLabel = "Obrazové efekty",
                screenEffectsDescription = "Třes, záblesky, rozmazání a barevné filtry na obrazovce oběti.",
                objectsSection = "Objekty výslechu",
                objectsEntry = "Objekt",
                objectsEditLabel = "Objekty výslechu",
                objectsEditDescription = "Umístit trvalé židle a vozíky s nářadím na mapu.",
                objectsEditButton = "Upravit objekty",
                objectsKindLabel = "Typ objektu",
                objectsKindChair = "Židle",
                objectsKindCart = "Vozík s nářadím",
                objectsModelLabel = "Model objektu",
                objectsPositionLabel = "Pozice",
                blockedZonesSection = "Blokované zóny",
                blockedZonesEntry = "Zóna",
                blockedZonesEditLabel = "Blokované zóny",
                blockedZonesEditDescription = "Oblasti, kam nelze umístit žádný objekt pro výslech.",
                blockedZonesEditButton = "Upravit zóny",
                blockedZonesZoneLabel = "Obrys zóny",
                blockedZonesZoneDescription = "Přetáhněte rohy a vytvořte oblast, kde není povoleno umisťování.",
                toolsSection = "Nářadí",
                toolsEntry = "Nástroj",
                toolsEditLabel = "Nářadí",
                toolsEditDescription = "Přidejte nebo upravte nástroje, které lze použít na oběti.",
                toolsEditButton = "Upravit nástroje",
                toolsItemLabel = "Vyžadovaný předmět",
                toolsConsumeLabel = "Spotřebovat předmět",
                toolsDamageLabel = "Poškození při použití",
                toolsHealthFloorLabel = "Minimální zdraví",
                toolsCooldownLabel = "Dočasné omezení (sekundy)",
                toolsProgressLabel = "Pokrok při použití",
                sessionsSection = "Probíhající výslechy",
                sessionsEntry = "Výslech",
                sessionsEditLabel = "Probíhající výslechy",
                sessionsEditDescription = "Zde uvidíte, kdo je aktuálně vysluchován, a v případě potřeby výslech ukončíte.",
                sessionsEditButton = "Zobrazit výslechy",
                sessionsStateLabel = "Stav",
                sessionsProgressLabel = "Pokrok",
                orphansSection = "Osamocené objekty",
                orphansEntry = "Objekt",
                orphansEditLabel = "Osamocené objekty",
                orphansEditDescription = "Odstranit objekty, jejichž majitel nebyl dlouho vidět.",
                orphansEditButton = "Vyčistit",
                sessionStates = {
                    binding = "Spoutávání",
                    active = "Aktivní",
                    ending = "Ukončování",
                },
            },
        },
    },
}
