JobConfigLocales["sky_crimesystem:se"] = {
    Nui = {
        workshopConfig = {
            creatorCommand = "Direktkommando",
            roleDefaults = {
                title = "Roller",
                description = "Välj lägsta rang för varje standardbehörighet. Rangbehörigheter som sparats i chefsmenyn har företräde.",
                bossHint = "Chefens och vicechefens ranger behåller alltid full åtkomst.",
                empty = "Det finns ännu inga ranger för det här jobbet.",
                gradesTitle = "Jobbranger",
                noDefault = "Ingen standardbehörighet",
                rankOption = "{grade} – {label}",
            },
            weaponDefaultsDescription = "Gemensamma värden gäller för ärvda fält. En ändring på inställningssidan växlar fältet till ett eget värde. Befintliga poster behåller sina värden.",
            weaponStreetDescription = "När en gatukontakt för droger används kan servern ibland köpa ett godkänt vapen. Val, pris och utbetalning bestäms av servern.",
            weaponGroups = {
                general = "Allmänna standardvärden",
                access = "Standardåtkomst",
                collection = "Standardinsamling",
                production = "Standardproduktion",
                market = "Standardmarknad",
                delivery = "Standardorder",
                street = "Vapenförsäljning på gatan",
            },
            weaponOptions = {
                scrap_search = "Sök i skrothögen",
                player = "Per spelare",
                global = "Allmänt",
                money = "Kontanter",
                bank = "Bankkonto",
                black_money = "Svarta pengar",
                timing = "Stoppa indikatorn inom det optimala intervallet.",
                precision = "Tidlägg varje klipp inom precisionsfönstret.",
                pressure = "Stoppa pressen vid dess optimala tryck.",
            },

            reputation = {
                remove = "Ta bort",
                title = "Rykte",
                action = "Handling",
                points = "Poäng per slutförande",
                enabled = "Aktiv",
                search = "Sök handlingar",
                added = "Redan tillagd",
                noResults = "Inga matchande handlingar hittades.",
                empty = "Inga handlingar ännu. Lägg till en handling med plusknappen.",
                name = "Regelnamn",
                target = "Mål (valfritt)",
            },
            configs = {
                sky_crimesystem = {
                    entries = "Fraktioner",
                    subtitle = "Konfigurera brottsliga jobb och deras gemensamma platser.",
                    title = "Brottssystem",
                },
            },
            creatorSections = {
                mainbaseZones = {
                    entryLabel = "Huvudbas",
                    entryPluralLabel = "Huvudbaser",
                    label = "Huvudbaszon",
                },
                presetTerritories = {
                    label = "Förinställda distrikt",
                    entryLabel = "Förinställt distrikt",
                    entryPluralLabel = "Förinställda distrikt",
                },
                customTerritories = {
                    label = "Anpassade territorier",
                    entryLabel = "Eget territorium",
                    entryPluralLabel = "Anpassade territorier",
                },
                objectsSection = {
                    label = "Förhörsobjekt",
                    entryLabel = "Objekt",
                    entryPluralLabel = "Förhörsobjekt",
                },
                blockedZonesSection = {
                    label = "Spärrzoner",
                    entryLabel = "Zon",
                    entryPluralLabel = "Spärrzoner",
                },
                toolsSection = {
                    label = "Verktyg",
                    entryLabel = "Verktyg",
                    entryPluralLabel = "Verktyg",
                },
                sessionsSection = {
                    label = "Pågående förhör",
                    entryLabel = "Förhör",
                    entryPluralLabel = "Pågående förhör",
                },
                orphansSection = {
                    label = "Övergivna objekt",
                    entryLabel = "Objekt",
                    entryPluralLabel = "Övergivna objekt",
                },
            },
            darknetActions = {
                currentLocation = "Använd nuvarande position",
            },
            drugSettings = {
                drugGrowthCurve = {
                    description = "Högre värden gör dålig skötsel mycket långsammare, samtidigt som starka bonusar bibehålls vid god skötsel.",
                    label = "Skötselrespons-kurva",
                },
                drugGrowthMaxMultiplier = {
                    description = "Maximal tillväxtmultiplikator uppnådd under utmärkta förhållanden.",
                    label = "Multiplikator vid perfekt skötsel",
                },
                drugGrowthMinMultiplier = {
                    description = "Tillväxtmultiplikator som används när plantans förhållanden är kritiskt dåliga.",
                    label = "Multiplikator vid kritisk skötsel",
                },
                drugGrowthQualityBonusMax = {
                    description = "Maximal extra tillväxtbonus som ges av plantans kvalitet.",
                    label = "Kvalitetsbonus för tillväxt",
                },
            },
            errors = {
                invalid_role_permission_defaults = "Välj giltiga lägsta ranger för rollbehörigheterna.",
                base_raid_locked = "Basen blir rånad. Dess förvaringsplatser och konfiguration är låsta.",
                base_storage_outside_zone = "Alla stash-, locker- och heist-förvaringspunkter måste ligga inom baszonen.",
                base_zone_invalid_polygon = "Placera minst tre distinkta punkter utan att linjerna korsas, kontrollera sedan höjden (3–200 m) och routing-bucket.",
                base_zone_point_limit = "En mainbase-zon stöder högst 64 gränspunkter.",
                base_zone_required = "Konfigurera först en giltig mainbase-zon för detta crime-job.",
                crime_interrogation_invalid_model = "Ange en giltig objektmodell.",
                crime_interrogation_invalid_coords = "Placera objektet på en giltig position.",
                crime_interrogation_invalid_zone_points = "Placera minst tre giltiga gränspunkter.",
                crime_interrogation_duplicate_id = "Ett objekt med detta ID finns redan.",
                crime_interrogation_tool_invalid = "Kontrollera verktygets definition.",
                crime_interrogation_tool_id_invalid = "Ange ett giltigt verktygs-ID.",
                crime_interrogation_tool_label_missing = "Ange ett namn för verktyget.",
                crime_interrogation_effect_missing = "Ställ in en effekt för verktyget.",
                crime_interrogation_effect_type_unknown = "Välj en effekttyp som stöds.",
                crime_interrogation_effect_status_missing = "Ange vilket tillstånd verktyget påverkar.",
                crime_interrogation_minigame_missing = "Ställ in ett minispel för verktyget.",
                crime_interrogation_minigame_type_unknown = "Välj en minispelstyp som stöds.",
                crime_interrogation_keys_missing = "Ställ in verktygets kontroller.",
                crime_interrogation_keys_invalid = "Kontrollera verktygets inställda kontroller.",
                crime_interrogation_keys_duplicate = "Tilldela varje verktygsåtgärd och kontroll endast en gång.",
                crime_interrogation_anim_invalid = "Kontrollera verktygets animationsordbok och klipp.",
                crime_interrogation_anim_missing = "Ställ in en animation för verktygets användare.",
                crime_interrogation_occupied = "Någon är redan fastbunden vid detta föremål.",
                crime_interrogation_not_found = "Det finns inte kvar längre.",
            },
            extensions = {
                baseZone = {
                    description = "Placera 3 till 64 gränspunkter i ordning. Den lägsta placerade punkten sätter botten; höjden sträcker sig uppåt därifrån. Punkter sparas som ett utkast; använd Spara för att tillämpa zonen. Endast förvaring, skåp och heist-förvaring inom zonen är tillgängliga under räder. Punkter utanför förhindrar inte sparande eller start av en raid. Befintliga gränser förblir aktiva tills du sparar.",
                    fields = {
                        bucket = "Routing-bucket",
                        configured = "Konfigurerad",
                        height = "Höjd (meter)",
                        radius = "Radie (meter)",
                        x = "Mittpunkt X",
                        y = "Mittpunkt Y",
                        z = "Mittpunkt Z",
                    },
                    label = "Huvudbaszon",
                },
                invalidSelection = "Ogiltigt val: {value}",
            },
            locationDescriptions = {
                crimeStationPosition = "Huvudpunkt för denna jobbplats. Om kartmarkören är aktiverad under Jobb → Blips, visas den här.",
            },
            locationTypes = {
                crimeStationPosition = "Plats / kartmarkör",
                heistCrafting = "Heist-verkstad",
                heistStorage = "Rånlager",
            },
            membershipMigration = {
                cancel = "Avbryt",
                confirm = "Migrera och spara",
                message = "Befintliga organisationsmedlemskap kommer att migreras till den valda modellen. Normal anställning förblir separat i oberoende läge.",
                title = "Ändra medlemskapsmodell?",
            },
            moneywashActions = {
                currentLocation = "Använd nuvarande position",
                invalidLocations = "Kontrollera ID:n, namn, interiörval och koordinater. Varje plats behöver ett unikt ID.",
                position = "Placera",
            },
            moneywashBusiness = {
                moneywashBuildNodes = { label = "Byggpunkter", description = "Placera passande utrustning på punkterna. Koordinaterna är relativa till vald interiör." },
                mwBuildNodes = "Byggpunkter",
                moneywashPublicEquipment = { label = "Offentlig utrustning", description = "Tilldela tvättmaskiner, generatorer och fläktar till offentliga platser och passande punkter." },
                mwPublicEquipment = "Offentlig utrustning",
                moneywashMaterials = { label = "Material", description = "Använd exakta inventarienamn. Vikt i gram; installera saknade föremål i inventariet." },
                mwMaterials = "Material",
                moneywashMaterialRecipes = { label = "Materialrecept", description = "Ingångar, utgångar och tid gäller per enhet. Bearbetare använder dessa recept." },
                mwMaterialRecipes = "Materialrecept",
                moneywashProductionRecipes = { label = "Tryckrecept", description = "Papper, färg och tider gäller per enhet. Kontanter efter torkning och kvalitetskontroll." },
                mwProductionRecipes = "Tryckrecept",
                moneywashCollectors = { label = "Insamlare", description = "Konfigurera avkastning, verktyg, väntetid och plats för varje insamlare." },
                mwCollectors = "Insamlare",
                moneywashProcessors = { label = "Bearbetare", description = "Välj materialrecept och plats för varje bearbetare." },
                mwProcessors = "Bearbetare",

                control = "Kontrollpanel",
                editor = {
                    addBusiness = "Lägg till verksamhet",
                    addInterior = "Lägg till interiör",
                    advanced = "Tekniska detaljer",
                    asset_ipl = "IPL: Ange exakt IPL-namn och interiörposition.",
                    asset_mlo = "MLO: Använder positionen för en installerad interiör. Tillgång sker för närvarande via verksamhetens ingång.",
                    asset_shell = "Shell: Dess modellresurs måste vara installerad och köras på servern.",
                    businessHelp = "Namnge verksamheten, välj dess interiör och fastställ inköpspriset.",
                    businessListHelp = "Hantera ingångar och inköpspriser för dina verksamheter.",
                    businesses = "Verksamheter",
                    capture = "Sätt i spelet",
                    captureOrigin = "Sätt interiörposition",
                    chooseInterior = "Välj en interiör",
                    coordinates = "Redigera koordinater",
                    editSections = "Inställningar",
                    emptyBusinessHelp = "Länka en kartingång till en interiör. Era organisationer kan därefter köpa den tomma verksamheten.",
                    emptyBusinesses = "Din första verksamhet",
                    emptyInteriorHelp = "Anslut en IPL, en shell eller en installerad MLO, och ställ sedan in punkterna som används av verksamheten.",
                    emptyInteriors = "Din första interiör",
                    entranceHelp = "Ställ in ingången där spelare ska köpa och gå in i verksamheten.",
                    freecamHelp = "Freecam: WASD för att flytta, Q/E upp/ner, Shift snabbare, Ctrl långsammare. Höger mus: titta runt. Dra gizmo, R rotera/flytta, Enter placera, Backspace avbryt.",
                    general = "Allmänt",
                    heading = "Riktning",
                    interiorHelp = "Välj interiörtyp och dess tillgång.",
                    interiorListHelp = "Förbered tomma utrymmen. Spelare placerar sina egna maskiner och utrustning.",
                    interiors = "Interiörer",
                    listEmpty = "Inga poster ännu.",
                    locationTypes = "Platsadministration",
                    newBusiness = "Ny verksamhet",
                    newInterior = "Ny interiör",
                    noResults = "Inga matchande poster.",
                    notSet = "Ej satt",
                    offsetHelp = "Inmatade värden är förskjutningar från ursprunget. Världspositionen visas ovanför.",
                    origin = "Ursprung",
                    originHelp = "Interiörposition. Alla andra punkter är relativa till denna.",
                    originRequired = "Ställ in interiörpositionen under Allmänt först.",
                    outsideRange = "Utanför {range}-meters radie",
                    point_control = "Flytta och rotera väggpanelen på plats med gizmon. Den bekräftade objektshöjden bibehålls exakt. Växla dess markör under Interaktioner → Money Wash: kontrollpanel.",
                    point_entry = "Spelare anländer och lämnar här. Att lämna transporterar dem automatiskt tillbaka till sin verksamhets ingång utanför.",
                    point_position = "Denna punkt ligger utanför verksamheten.",
                    point_storage = "Flytta och rotera hyllan med gizmon tills den vilar på golvet. Medlemmar får tillgång till köpt utrustning här. Växla dess markör under Interaktioner → Money Wash: förråd.",
                    points = "Poäng",
                    pointsHelp = "Välj en punkt och placera den direkt i spelet.",
                    rangeNote = "En radie på {range} meter runt interiörens ursprung gäller, utan höjdrestriktioner.",
                    remove = "Ta bort",
                    repairRange = "Flytta dessa punkter närmare interiörens ursprung.",
                    saveHint = "Spara ändringar genom att klicka på Spara högst upp.",
                    search = "Sök …",
                    set = "Satt",
                    teleport = "Teleportera",
                    viewInteriors = "Visa interiörer",
                    visit = "Visa",
                    visitHint = "Rör dig fritt. Tryck på Backspace för att återgå till redigeraren.",
                    visitTitle = "Besök interiör",
                },
                entry = "Ingång och utgång",
                fields = {
                    mode = "Åtkomstläge",
                    ownerKind = "Ägartyp",
                    productionEnabled = "Tryckutbyggnad tillgänglig",
                    feePercent = "Avgift (%) / -1 = global",
                    storageCapacity = "Lagerkapacitet (föremål)",
                    maximumOrders = "Samtidiga order per spelare",
                    gridPower = "Nätström / 0 = generator",
                    autoService = "Automatiskt offentligt underhåll",
                    maximumPendingOutputs = "Maximalt väntande utbetalningar",
                    placementRange = "Placeringsradie (m)",
                    placementHeight = "Höjdintervall för placering (m)",
                    interiorId = "Interiör-ID",
                    equipmentId = "Utrustnings-ID",
                    nodeId = "Byggpunkt-ID",
                    generatorNode = "Generatorpunkt-ID",
                    maxOffset = "Största avvikelse från punkt (m)",
                    maxHeight = "Största höjdavvikelse (m)",
                    weight = "Föremålsvikt (g)",
                    inputItem = "Ingående material",
                    secondItem = "Andra ingående materialet",
                    outputItem = "Utgående material",
                    requiredTool = "Nödvändigt verktyg",
                    baseQuality = "Startkvalitet (%)",
                    minimumQuality = "Minsta kvalitet (%)",
                    inspectionCards = "Kontrollkort",
                    inspectionPenalty = "Kvalitetsförlust per fel (%)",
                    rejectPercent = "Kasserade sedlar (%)",
                    accessoryModel = "Tillbehörsmodell",
                    accessoryMaximum = "Maximalt synliga tillbehör",
                    accessoryActiveOnly = "Tillbehör endast vid bearbetning",
                    animDict = "Animationsordlista",
                    animClip = "Animationssekvens",
                    cooldown = "Väntetid (sekunder)",
                    minimum = "Minsta avkastning",
                    maximum = "Största avkastning",
                    productionPrice = "Trycka pengar · Inköpspris",
                    recipeId = "Recept ID",
                    inputAmount = "Material / per enhet",
                    secondAmount = "Material / per enhet",
                    outputAmount = "Material / per enhet",
                    paperItem = "Tryckpapper",
                    inkItem = "Tryckfärg",
                    paperAmount = "Tryckpapper / per enhet",
                    inkAmount = "Tryckfärg / per enhet",
                    notesPerUnit = "Sedlar / per enhet",
                    valuePerNote = "Kontanter / Sedlar",
                    maximumUnits = "Enheter (max.)",
                    printSeconds = "Tryckning / per enhet (Sekunder)",
                    inspectionSeconds = "Kontroll / per enhet (Sekunder)",
                    rinseSeconds = "Tvättning / per enhet (Sekunder)",
                    drySeconds = "Torkning / per enhet (Sekunder)",
                    accessoryUnit = "Sedlar / per enhet",
                    accessoryX = "Tillbehörsmodell · X (m)",
                    accessoryY = "Tillbehörsmodell · Y (m)",
                    accessoryZ = "Tillbehörsmodell · Z (m)",
                    accessoryStep = "Tillbehörsmodell · Z (m)",

                    capacity = "Kapacitet per cykel",
                    controlHeading = "Kontrollpanelens riktning",
                    controlHeight = "Monteringshöjd över punkt (m)",
                    controlModel = "Väggpanelmodell",
                    controlX = "Kontrollpanel X",
                    controlY = "Kontrollpanel Y",
                    controlZ = "Kontrollpanel Z",
                    disableSets = "Dolda entitetsset (komma separerade)",
                    enableSets = "Aktiverade enhetsset (komma separerade)",
                    entryX = "Ingångsförskjutning X",
                    entryY = "Ingångsförskjutning Y",
                    entryZ = "Ingångsförskjutning Z",
                    heading = "Riktning",
                    id = "Unik ID",
                    interior = "Interiör",
                    ipl = "IPL-namn",
                    kind = "Typ",
                    label = "Namn",
                    model = "Modellnamn",
                    power = "Strömenheter",
                    price = "Inköpspris",
                    radius = "Placeringsradie (m)",
                    repairPrice = "Reparationspris (0 = gratis)",
                    seconds = "Cykelvaraktighet (sekunder)",
                    storageHeading = "Förrådspunktens riktning",
                    storageModel = "Hyllmodell",
                    storageX = "Förrådspunkt X",
                    storageY = "Förrådspunkt Y",
                    storageZ = "Förrådspunkt Z",
                    wear = "Slitage per cykel (%)",
                    x = "Ursprung X",
                    y = "Ursprung Y",
                    z = "Ursprung Z",
                },
                interactions = {
                    control = "Money Wash: kontrollpanel",
                    storage = "Money Wash: förråd",
                },
                item = "Notering",
                moneywashBucketStart = {
                    description = "Reservera detta område exklusivt för Money Wash. Ändringar träder i kraft vid nästa inträde.",
                    label = "Start för instansområde",
                },
                moneywashEquipment = {
                    description = "Spelare köper och placerar ut enheter. Kapacitet, varaktighet och slitage gäller för tvättmaskiner. Ström är generatorleverans eller enhetsbehov. Ändringar påverkar nya inköp.",
                    label = "Utrustning som kan köpas",
                },
                moneywashInteriors = {
                    description = "Konfigurera tomma IPL-, shell- eller MLO-interiörer. Ingångspunkt, kontrollpanel, förråd och bygggränser är relativa till ursprunget. Att lämna återför spelaren till deras verksamhetsingång.",
                    label = "Interiörer (IPL, shell eller MLO)",
                },
                moneywashMaximumEquipment = {
                    description = "Maximalt antal köpta enheter och reparationssatser per verksamhet.",
                    label = "Utrustningsgräns",
                },
                moneywashPreviewBucketStart = {
                    description = "Besök lägger till spelarens ID till detta värde för en privat admin-instans. Reservera det separat från verksamheter och andra resurser. Ändringar gäller vid nästa förhandsvisning.",
                    label = "Start för förhandsvisningsinstansens område",
                },
                moneywashProperties = {
                    description = "Ange en ingång, välj en interiör och ange inköpspriset. Inköpta företag behåller sin sparade interiör och layout.",
                    label = "Företagsingångar",
                },
                moneywashRepairShops = {
                    description = "Ställ in reparationsbutiker, teleportera till dem och ställ in servicepriset. De säljer reparationskit och servar inlagrade maskiner.",
                    label = "Butiksplatser",
                },
                moneywashShops = {
                    description = "Placera butiker för tvättmaskiner, generatorer och fläktar. Beställningar går till organisationens valda verksamhet.",
                    label = "Butiksplatser",
                },
                mwEquipment = "Utrustningsbutik",
                mwInteriors = "Tomma interiörer",
                mwProperties = "Platser",
                mwRepairShops = "Verkstad",
                mwSettings = "Verksamhetsinställningar",
                names = {
                    mwPublicLaundry = "Offentlig tvättstuga",
                    mwPaperPulp = "Pappersmassa",
                    mwPrintingPaper = "Tryckpapper",
                    mwPrintingInk = "Tryckfärg",
                    mwPaperRecipe = "Tillverka tryckpapper",
                    mwPrintingRecipe = "Vanliga sedlar",
                    mwPaperCollector = "Pappersinsamling",
                    mwInkCollector = "Färginsamling",
                    mwPaperProcessor = "Pappersbearbetning",
                    mwPrinter = "Tryckpress",
                    mwInspectionTable = "Kontrollbord",
                    mwDryingCabinet = "Torkskåp",
                    mwNode1 = "1 · Tvättning",
                    mwNode2 = "2 · Tvättning",
                    mwNode3 = "3 · Byggpunkter",
                    mwNode4 = "4 · Tryckning",
                    mwNode5 = "5 · Kontroll",
                    mwNode6 = "6 · Torkning",
                    mwNode7 = "7 · Byggpunkter",

                    mwInteriorWarehouse = "Tomt lager",
                },
                options = {
                    private = "Privat",
                    public = "Offentlig",
                    faction = "Organisation",
                    person = "Karaktär",
                    printer = "Tryckpress",
                    inspection = "Kontrollbord",
                    dryer = "Torkskåp",

                    fan = "Fläkt",
                    generator = "Generator",
                    ipl = "IPL",
                    mlo = "MLO",
                    repair = "Reparationskit",
                    shell = "Shell-modell",
                    washer = "Tvättmaskin",
                },
                origin = "Ursprung",
                storage = "Förrådspunkt",
            },
            settingFields = {
                cultivationLevel = "Odlingsnivå",
                cultivationTitle = "Nivånamn",
                cultivationRequiredXp = "Krävd total XP",
                cultivationAction = "Åtgärd",
                cultivationXp = "XP",
                cultivationCategory = "Kategori",
                cultivationEntry = "Post",
                cultivationRequiredLevel = "Krävd nivå",
                alias = "Ordförande",
                atmHeading = "Riktning",
                atmId = "ID",
                atmModel = "ATM-modell",
                centerX = "Mittpunkt X",
                centerY = "Mittpunkt Y",
                centerZ = "Mittpunkt Z",
                deliveryMethod = "Leveransmetod",
                description = "Beskrivning",
                enabled = "Aktiverad",
                groupKey = "Gruppnyckel",
                id = "ID",
                itemLabel = "Varumärke för vara",
                itemName = "Namn på inventarieartikel",
                knownScammer = "Känd bedragare",
                locationName = "Platsnamn",
                observerW = "Åskådarens riktning",
                observerX = "Åskådare X",
                observerY = "Åskådare Y",
                observerZ = "Åskådare Z",
                pedModel = "NPC-pedmodell",
                pickpocketItemChance = "Chans (%)",
                pickpocketItemMaximum = "Maximalt belopp",
                pickpocketItemMinimum = "Minimalt belopp",
                pickpocketItemName = "Namn på inventarieartikel",
                quantity = "Antal",
                radius = "Radie",
                rating = "Visat betyg",
                ratingCount = "Antal visade betyg",
                scamChance = "Chans för bedrägeri av handlare (%)",
                shopCategory = "Kategori",
                shopClerkHeading = "Kassör heading",
                shopClerkModel = "Kassör-modell",
                shopClerkRequired = "Kassör krävs",
                shopClerkX = "Kassör X",
                shopClerkY = "Kassör Y",
                shopClerkZ = "Kassör Z",
                shopCodeEnabled = "Tillåt öppning med kod",
                shopDrillEnabled = "Tillåt borrning",
                shopEnabled = "Aktiverad",
                shopHackEnabled = "Tillåt hackning",
                shopLocationId = "Butiks-ID",
                shopLocationLabel = "Etikett",
                shopRegisterId = "Kassans ID",
                shopSafeEnabled = "Safe aktiverad",
                shopSafeHeading = "Kassaskåpets riktning",
                shopSafeX = "Kassaskåp X",
                shopSafeY = "Kassaskåp Y",
                shopSafeZ = "Kassaskåp Z",
                side = "Marknadssida",
                spawns = "Lagets startpunkter",
                successfulTrades = "Visade lyckade affärer",
                title = "Erbjudandets titel",
                unitPrice = "Enhetspris",
                verified = "Verifierad handlare",
                w = "Riktning",
                x = "X",
                y = "YTTERLIGARE",
                z = "Z",
                shopClerkPosition = "Personalens position",
                shopRegisterPosition = "Kassaposition",
                shopSafePosition = "Kassaskåpsposition",
                registerId = "Kassans ID",
                registerX = "Kassans X-koordinat",
                registerY = "Kassans Y-koordinat",
                registerZ = "Kassans Z-koordinat",
                heading = "Riktning",
                captureLocation = "Registrera position",
            },
            crimeDashboard = {
                jobs = "Hantera fraktioner, medlemmar, behörigheter och platser.",
                jobCreator = "Välj en fraktion för att redigera dess platser och områden.",
                jobsQuestion = "Var redigerar jag fraktioner och platser?",
                jobsAnswer = "Öppna {path}, välj en fraktion och sedan Redigera. Där kan du ändra dess inställningar och platser.",
                creatorsAnswer = "Du hittar redigerarna under {path}. Länkarna öppnar redigeraren; fraktionsverktyg börjar med att välja en fraktion.",
                missingAnswer = "Tillgängliga redigerare beror på vald resurs och dess inställningar. Fraktionsverktyg börjar vid den aktuella fraktionen.",
                creators = {
                    mainbaseZones = "Välj en fraktion och konfigurera dess basområde.",
                    presetTerritories = "Granska förinställda distrikt och välj vilka som ska vara aktiva.",
                    objectsSection = "Hantera permanenta förhörsstolar och verktygsvagnar.",
                    blockedZonesSection = "Ange områden där förhörsobjekt inte får placeras.",
                    toolsSection = "Konfigurera verktygen som är tillgängliga under förhör.",
                    sessionsSection = "Visa pågående förhör och avsluta sessioner vid behov.",
                    orphansSection = "Granska och ta bort övergivna förhörsobjekt.",
                },
            },
            crimeGroupDescriptions = {
                general = {
                    crimeMembership = "Välj hur kriminella organisationer lagrar och hanterar sina medlemmar.",
                },
                territories = {
                    zones = "Anpassa inställningarna för ”Territoriezoner” i avsnittet ”Territorier”.",
                    ownership = "Anpassa inställningarna för ”Ägarskap” i avsnittet ”Territorier”.",
                    decay = "Anpassa inställningarna för ”Förfall” i avsnittet ”Territorier”.",
                    presence = "Anpassa inställningarna för ”Närvaro” i avsnittet ”Territorier”.",
                    activity = "Anpassa inställningarna för ”Aktivitetspoäng” i avsnittet ”Territorier”.",
                    ownershipBenefits = "Anpassa inställningarna för ”Ägarförmåner” i avsnittet ”Territorier”.",
                },
                graffiti = {
                    general = "Anpassa inställningarna för ”Allmänt” i avsnittet ”Graffiti Ordförande”.",
                    streaming = "Anpassa inställningarna för ”Visning” i avsnittet ”Graffiti Ordförande”.",
                    moderation = "Anpassa inställningarna för ”Moderering” i avsnittet ”Graffiti Ordförande”.",
                },
                pvpEvents = {
                    pvpAvailability = "Styr om PvP-event-appen är tillgänglig och var den visas.",
                    pvpAutomation = "Konfigurera återkommande händelser och automatisk startprocess.",
                    pvpRuntime = "Justera hantering av begärningar, dödsfall och respawns under pågående matcher.",
                    pvpModes = "Konfigurera det förinställda spelläget i PvP-surfplattan.",
                    pvpArenas = "Skapa den cirkulära zonen, observatörspunkten och team-spawnpunkterna som används av PvP-events.",
                    pvpLimits = "Ställ in gränser för belöningar och surfplattans historik.",
                    pvpPermissions = "Koppla eventhantering och ekonomi till ACE- och jobbtillstånd.",
                    pvpTakeoverRules = "Styr tillgänglighet och deltagarkrav för övertagande av laboratorier och campers.",
                    pvpTakeoverZones = "Konfigurera interaktions-, larm- och erövringsområden tillsammans med deras varaktighet.",
                    pvpTakeoverMethods = "Konfigurera hur lång tid varje metod tar för att bryta upp en ingång.",
                },
                drugs = {
                    creator = "Öppnar Sky Crimes drogredigerare och stänger jobbkonfiguratorn.",
                    creatorSettings = "Anpassa inställningarna för ”Redigerarinställningar” i avsnittet ”Drogsystem”.",
                    interfaceHud = "Anpassa inställningarna för ”Gränssnittspositioner” i avsnittet ”Drogsystem”.",
                    drugsGeneral = "Anpassa inställningarna för ”Allmänt” i avsnittet ”Drogsystem”.",
                    runtimeAccess = "Anpassa inställningarna för ”Åtkomst och ägande” i avsnittet ”Drogsystem”.",
                    runtimePayouts = "Anpassa inställningarna för ”Utbetalningar” i avsnittet ”Drogsystem”.",
                    runtimeDispatch = "Anpassa inställningarna för ”Ledningscentral och polis” i avsnittet ”Drogsystem”.",
                    performanceInactiveControlIntervalMs = "Driftinställning för Prestanda / Inaktiv / Kontroll / Intervall / ms.",
                    performanceInteractionIdleScanIntervalMs = "Driftinställning för Prestanda / Interaktion / Idle / Skanningsintervall / ms.",
                    performanceInteractionPromptIntervalMs = "Driftinställning för Prestanda / Interaktion / Interaktionsmeddelande / Intervall / ms.",
                    performanceInteractionScanIntervalMs = "Driftinställning för Prestanda / Interaktion / Skanningsintervall / ms.",
                    performanceMinimumScanIntervalMs = "Driftinställning för Prestanda / Minimum / Skanningsintervall / ms.",
                    performanceStreetPedActivationDistance = "Driftinställning för Prestanda / Gata / Ped / Aktivering / Avstånd.",
                    performanceStreetPedIdleScanIntervalMs = "Driftinställning för Prestanda / Gata / Ped / Idle / Skanningsintervall / ms.",
                    performanceStreetPedScanIntervalMs = "Driftinställning för Prestanda / Gata / Ped / Skanningsintervall / ms.",
                    performanceWorldCachePadding = "Driftinställning för Prestanda / Värld / Cache / Extra marginal.",
                    performanceWorldCacheRefreshIntervalMs = "Driftinställning för Prestanda / Värld / Cache / Uppdatering / Intervall / ms.",
                    performanceWorldIdleIntervalMs = "Driftinställning för Prestanda / Värld / Idle / Intervall / ms.",
                },
                drugProduction = {
                    qualityWeights = "Anpassa inställningarna för ”Kvalitet / Viktningar” i avsnittet ”Drogproduktion”.",
                    qualityTiers = "Anpassa inställningarna för ”Kvalitet / Kvalitetsnivåer” i avsnittet ”Drogproduktion”.",
                    packagingGeneral = "Anpassa inställningarna för ”Allmänt” i avsnittet ”Drogproduktion”.",
                    processingFlow = "Anpassa inställningarna för ”Bearbetningsflöde” i avsnittet ”Drogproduktion”.",
                    processingGeneral = "Anpassa inställningarna för ”Allmänt” i avsnittet ”Drogproduktion”.",
                },
                drugOperations = {
                    growingGeneral = "Anpassa inställningarna för ”Allmänt” i avsnittet ”Drogverksamhet”.",
                    plantDefaults = "Anpassa inställningarna för ”Växt / Standardvärden” i avsnittet ”Drogverksamhet”.",
                    harvestWindow = "Anpassa inställningarna för ”Skörd / Tidsfönster” i avsnittet ”Drogverksamhet”.",
                    labsGeneral = "Aktiverar: laboratorier och husbilar i spelet.",
                    labRent = "Anpassa inställningarna för ”Hyra och livscykel” i avsnittet ”Drogverksamhet”.",
                    camperDefaults = "Anpassa inställningarna för ”Husvagn” i avsnittet ”Drogverksamhet”.",
                    labUpgrades = "Multiplikator för Lab / Nivå / Uppgradering / Priser.",
                    labDefaults = "Anpassa inställningarna för ”Lab / Standardvärden” i avsnittet ”Drogverksamhet”.",
                    powerGeneral = "Anpassa inställningarna för ”Allmänt” i avsnittet ”Drogverksamhet”.",
                    generators = "Anpassa inställningarna för ”Generatorer” i avsnittet ”Drogverksamhet”.",
                    equipmentWear = "Global multiplikator för Utrustningsslitage / Bearbetning.",
                    workersGeneral = "Anpassa inställningarna för ”Allmänt” i avsnittet ”Drogverksamhet”.",
                    cultivationGeneral = "Anpassa inställningarna för ”Allmänt” i avsnittet ”Drogverksamhet”.",
                    cultivationCurve = "Ställ in namn och total XP-gräns för varje odlingsnivå.",
                    cultivationExperience = "Ställ in hur mycket odlings-XP varje åtgärd ger.",
                    cultivationUnlocks = "Ställ in krävda nivåer för behållare, substrat, utrustning, sorter och skannernivåer.",
                    powerRuntime = "Intervall i sekunder för uppdatering av generatorförbrukning och elmönster.",
                    powerHeat = "Anpassa inställningarna för ”Polisuppmärksamhet och elmönster” i avsnittet ”Drogverksamhet”.",
                    powerModes = "Anpassa inställningarna för ”Hantering / Lägen” i avsnittet ”Drogverksamhet”.",
                    powerPriorities = "Anpassa inställningarna för ”Belastning / Prioriteringar” i avsnittet ”Drogverksamhet”.",
                },
                drugMarketRisk = {
                    marketGeneral = "Anpassa inställningarna för ”Allmänt” i avsnittet ”Marknad och risk”.",
                    marketPrices = "Anpassa inställningarna för ”Priser” i avsnittet ”Marknad och risk”.",
                    distribution = "Anpassa inställningarna för ”Fördelning” i avsnittet ”Marknad och risk”.",
                    threatsGeneral = "Anpassa inställningarna för ”Allmänt” i avsnittet ”Marknad och risk”.",
                    threatHeat = "Anpassa inställningarna för ”Polistryck” i avsnittet ”Marknad och risk”.",
                    threatChances = "Anpassa inställningarna för ”Sannolikheter” i avsnittet ”Marknad och risk”.",
                    consumptionGeneral = "Anpassa inställningarna för ”Allmänt” i avsnittet ”Marknad och risk”.",
                    consumerDecay = "Anpassa inställningarna för ”Minskning av tolerans och beroende” i avsnittet ”Marknad och risk”.",
                    consumerEffects = "Anpassa inställningarna för ”Effekter och risker” i avsnittet ”Marknad och risk”.",
                },
                drugNetworks = {
                    dynamicMarketActionCooldownSeconds = "Driftinställning för Dynamisk marknad / Återhämtningstid för handlingar / sekunder.",
                    dynamicMarketActionHistoryLimit = "Driftinställning för Dynamisk marknad / Handling / Historikgräns.",
                    dynamicMarketAmountSaturationWeight = "Driftinställning för Dynamisk marknad / Mängd / Mättnad / Vikt.",
                    dynamicMarketBaseIntelAccuracy = "Driftinställning för Dynamisk marknad / Grundvärde / Informationens noggrannhet.",
                    dynamicMarketDefaultAverageQuality = "Driftinställning för Dynamisk marknad / Standardvärde / Genomsnitt / Kvalitet.",
                    dynamicMarketDefaultResourceElasticity = "Driftinställning för Dynamisk marknad / Standardvärde / Resurs / Elasticitet.",
                    dynamicMarketDemandCenter = "Driftinställning för Dynamisk marknad / Efterfrågan / Mittvärde.",
                    dynamicMarketDemandPriceImpact = "Driftinställning för Dynamisk marknad / Efterfrågan / Pris / Påverkan.",
                    dynamicMarketDirectionThreshold = "Driftinställning för Dynamisk marknad / Riktning / Tröskelvärde.",
                    dynamicMarketEnabled = "Driftinställning för Dynamisk marknad / Aktiverad.",
                    dynamicMarketEventChance = "Driftinställning för Dynamisk marknad / Händelse / Chans.",
                    dynamicMarketEventDurationMinutes = "Driftinställning för Dynamisk marknad / Händelse / Varaktighet / Minuter.",
                    dynamicMarketEventMinimumDurationMinutes = "Driftinställning för Dynamisk marknad / Händelse / Minimum / Varaktighet / Minuter.",
                    dynamicMarketEventStrengthMaximum = "Driftinställning för Dynamisk marknad / Händelse / Styrka / Maximum.",
                    dynamicMarketEventStrengthMinimum = "Driftinställning för Dynamisk marknad / Händelse / Styrka / Minimum.",
                    dynamicMarketEvents = "Anpassa inställningarna för ”Händelser” i avsnittet ”Drognätverk”.",
                    dynamicMarketExactIntelReputation = "Driftinställning för Dynamisk marknad / Exakt information / Rykte.",
                    dynamicMarketExactIntelTrust = "Driftinställning för Dynamisk marknad / Exakt information / Förtroende.",
                    dynamicMarketGlobalZoneLabel = "Driftinställning för Dynamisk marknad / Global / Zon / Etikett.",
                    dynamicMarketHistoryLimit = "Driftinställning för Dynamisk marknad / Historikgräns.",
                    dynamicMarketInitialDemand = "Driftinställning för Dynamisk marknad / Startvärde / Efterfrågan.",
                    dynamicMarketInitialPriceMultiplier = "Driftinställning för Dynamisk marknad / Startvärde / Prismultiplikator.",
                    dynamicMarketIntelDemandError = "Driftinställning för Dynamisk marknad / Underrättelser / Efterfrågan / Fel.",
                    dynamicMarketIntelMaximumAccuracy = "Driftinställning för Dynamisk marknad / Underrättelser / Maximum / Precision.",
                    dynamicMarketIntelMinimumAccuracy = "Driftinställning för Dynamisk marknad / Underrättelser / Minimum / Precision.",
                    dynamicMarketIntelPoliceError = "Driftinställning för Dynamisk marknad / Underrättelser / Polis / Fel.",
                    dynamicMarketIntelPriceError = "Driftinställning för Dynamisk marknad / Underrättelser / Pris / Fel.",
                    dynamicMarketIntelPriceMaximum = "Driftinställning för Dynamisk marknad / Underrättelser / Pris / Maximum.",
                    dynamicMarketIntelPriceMinimum = "Driftinställning för Dynamisk marknad / Underrättelser / Pris / Minimum.",
                    dynamicMarketIntelReputationWeight = "Driftinställning för Dynamisk marknad / Underrättelser / Rykte / Vikt.",
                    dynamicMarketIntelResourcePriceError = "Driftinställning för Dynamisk marknad / Underrättelser / Resurs / Pris / Fel.",
                    dynamicMarketIntelSaturationError = "Driftinställning för Dynamisk marknad / Underrättelser / Mättnad / Fel.",
                    dynamicMarketIntelSeedBucketSeconds = "Driftinställning för Dynamisk marknad / Tidsfönster för informationens slumpfrö / sekunder.",
                    dynamicMarketIntelStatusAccuracyThreshold = "Driftinställning för Dynamisk marknad / Underrättelser / Status / Precision / Tröskelvärde.",
                    dynamicMarketIntelStatusErrorThreshold = "Driftinställning för Dynamisk marknad / Underrättelser / Status / Fel / Tröskelvärde.",
                    dynamicMarketIntelSupplyError = "Driftinställning för Dynamisk marknad / Underrättelser / Leverans / Fel.",
                    dynamicMarketIntelTrustWeight = "Driftinställning för Dynamisk marknad / Underrättelser / Förtroende / Vikt.",
                    dynamicMarketManipulationCooldownMinutes = "Driftinställning för Dynamisk marknad / Manipulation / Nedkylningsminuter.",
                    dynamicMarketManipulationDemandShift = "Driftinställning för Dynamisk marknad / Manipulation / Efterfrågan / Förskjutning.",
                    dynamicMarketManipulationDurationMinutes = "Driftinställning för Dynamisk marknad / Manipulation / Varaktighet / Minuter.",
                    dynamicMarketManipulationHeat = "Driftinställning för Dynamisk marknad / Manipulation / Polistryck.",
                    dynamicMarketManipulationMinimumBatchAmount = "Driftinställning för Dynamisk marknad / Manipulation / Minimum / Parti / Mängd.",
                    dynamicMarketManipulationPaymentAccount = "Driftinställning för Dynamisk marknad / Manipulation / Betalkonto.",
                    dynamicMarketManipulationPrice = "Driftinställning för Dynamisk marknad / Manipulation / Pris.",
                    dynamicMarketManipulationZoneHeatMultiplier = "Driftinställning för Dynamisk marknad / Manipulation / Zon / Polistryck / Multiplikator.",
                    dynamicMarketMaximumIntelAgeMinutes = "Driftinställning för Dynamisk marknad / Maximum / Informationens ålder / Minuter.",
                    dynamicMarketMaximumPriceMultiplier = "Driftinställning för Dynamisk marknad / Maximum / Prismultiplikator.",
                    dynamicMarketMinimumIntelAgeMinutes = "Driftinställning för Dynamisk marknad / Minimum / Informationens ålder / Minuter.",
                    dynamicMarketMinimumMetricWindowMinutes = "Driftinställning för Dynamisk marknad / Minimum / Mätvärde / Tidsfönster / Minuter.",
                    dynamicMarketMinimumPriceMultiplier = "Driftinställning för Dynamisk marknad / Minsta pris / Multiplikator.",
                    dynamicMarketMinimumUpdateMinutes = "Driftinställning för Dynamisk marknad / Minimum / Uppdatering / Minuter.",
                    dynamicMarketPoliceDemandWeight = "Driftinställning för Dynamisk marknad / Polis / Efterfrågan / Vikt.",
                    dynamicMarketPolicePriceImpact = "Driftinställning för Dynamisk marknad / Polis / Pris / Påverkan.",
                    dynamicMarketPoorQualityDemandPenalty = "Driftinställning för Dynamisk marknad / Dålig kvalitet / Efterfrågan / Avdrag.",
                    dynamicMarketPoorQualityThreshold = "Driftinställning för Dynamisk marknad / Dålig kvalitet / Tröskelvärde.",
                    dynamicMarketPremiumQualityDemandBonus = "Driftinställning för Dynamisk marknad / Premiumkvalitet / Efterfrågebonus.",
                    dynamicMarketPremiumQualityThreshold = "Driftinställning för Dynamisk marknad / Premiumkvalitet / Tröskelvärde.",
                    dynamicMarketProductionSupplyWeight = "Driftinställning för Dynamisk marknad / Produktion / Leverans / Vikt.",
                    dynamicMarketProductionWindowMinutes = "Driftinställning för Dynamisk marknad / Produktion / Tidsfönster / Minuter.",
                    dynamicMarketQualityCenter = "Driftinställning för Dynamisk marknad / Kvalitet / Mittvärde.",
                    dynamicMarketQualityConfidenceImpact = "Driftinställning för Dynamisk marknad / Kvalitet / Förtroende / Påverkan.",
                    dynamicMarketQualityRange = "Driftinställning för Dynamisk marknad / Kvalitet / Värdeintervall.",
                    dynamicMarketRarityBonusMaximum = "Driftinställning för Dynamisk marknad / Sällsynthet / Bonus / Maximum.",
                    dynamicMarketRegionalGlobalWeight = "Driftinställning för Dynamisk marknad / Regional / Global / Vikt.",
                    dynamicMarketRegionalLocalWeight = "Driftinställning för Dynamisk marknad / Regional / Lokal / Vikt.",
                    dynamicMarketResourceAliases = "Anpassa inställningarna för ”Resurs / Alternativa namn” i avsnittet ”Drognätverk”.",
                    dynamicMarketResourceDirectionFallThreshold = "Driftinställning för Dynamisk marknad / Resurs / Riktning / Nedgång / Tröskelvärde.",
                    dynamicMarketResourceDirectionRiseThreshold = "Driftinställning för Dynamisk marknad / Resurs / Riktning / Ökning / Tröskelvärde.",
                    dynamicMarketResources = "Anpassa inställningarna för ”Resurser” i avsnittet ”Drognätverk”.",
                    dynamicMarketSalesWindowMinutes = "Driftinställning för Dynamisk marknad / Försäljning / Tidsfönster / Minuter.",
                    dynamicMarketSaturationDemandWeight = "Driftinställning för Dynamisk marknad / Mättnad / Efterfrågan / Vikt.",
                    dynamicMarketSaturationPriceImpact = "Driftinställning för Dynamisk marknad / Mättnad / Pris / Påverkan.",
                    dynamicMarketScarcityDemandWeight = "Driftinställning för Dynamisk marknad / Brist / Efterfrågan / Vikt.",
                    dynamicMarketScarcityPriceImpact = "Driftinställning för Dynamisk marknad / Brist / Pris / Påverkan.",
                    dynamicMarketSeasonEndMonths = "Anpassa inställningarna för ”Årstid / Slut / Månader” i avsnittet ”Drognätverk”.",
                    dynamicMarketSeasonMultipliers = "Anpassa inställningarna för ”Årstid / Multiplikatorer” i avsnittet ”Drognätverk”.",
                    dynamicMarketShortageRumorThreshold = "Driftinställning för Dynamisk marknad / Brist / Rykte / Tröskelvärde.",
                    dynamicMarketStatusThresholds = "Anpassa inställningarna för ”Status / Tröskelvärden” i avsnittet ”Drognätverk”.",
                    dynamicMarketTargetSupply = "Driftinställning för Dynamisk marknad / Mål / Leverans.",
                    dynamicMarketTrendChance = "Driftinställning för Dynamisk marknad / Trend / Chans.",
                    dynamicMarketTrendDurationMinutes = "Driftinställning för Dynamisk marknad / Trend / Varaktighet / Minuter.",
                    dynamicMarketTrendMaximumStrength = "Driftinställning för Dynamisk marknad / Trend / Maximum / Styrka.",
                    dynamicMarketTrendMinimumStrength = "Driftinställning för Dynamisk marknad / Trend / Minimum / Styrka.",
                    dynamicMarketUpdateMinutes = "Driftinställning för Dynamisk marknad / Uppdatering / Minuter.",
                    dynamicMarketVolatilityMaximum = "Driftinställning för Dynamisk marknad / Prisvolatilitet / Maximum.",
                    dynamicMarketVolatilityMinimum = "Driftinställning för Dynamisk marknad / Prisvolatilitet / Minimum.",
                    dynamicMarketWeatherMultipliers = "Anpassa inställningarna för ”Väder / Multiplikatorer” i avsnittet ”Drognätverk”.",
                    dynamicMarketWeatherState = "Driftinställning för Dynamisk marknad / Väder / Status.",
                    heatActionCooldownSeconds = "Driftinställning för Polisuppmärksamhet och risk / Återhämtningstid för handlingar / sekunder.",
                    heatActivityRiskWeights = "Anpassa inställningarna för ”Aktivitet / Risk / Viktningar” i avsnittet ”Drognätverk”.",
                    heatAggressiveHeatMultiplier = "Driftinställning för Polisuppmärksamhet och risk / Aggressivt arbetssätt / Polistryck / Multiplikator.",
                    heatBurnerBurnThreshold = "Driftinställning för Polisuppmärksamhet och risk / Engångstelefon / Avslöjande / Tröskelvärde.",
                    heatBurnerHeatPerWholesale = "Driftinställning för Polisuppmärksamhet och risk / Engångstelefon / Polistryck / Per grossistaffär.",
                    heatBurnerPhoneItem = "Driftinställning för Polisuppmärksamhet och risk / Engångsmobil / Föremål.",
                    heatCamperOperationalHeatMultiplier = "Driftinställning för Polisuppmärksamhet och risk / Husbil i drift / Polistryck / Multiplikator.",
                    heatCamperOperationalHeatThreshold = "Driftinställning för Polisuppmärksamhet och risk / Husbil i drift / Polistryck / Tröskelvärde.",
                    heatCamperParkedHeat = "Driftinställning för Polisuppmärksamhet och risk / Parkerad husbil / Polistryck.",
                    heatContaminatedHeatMultiplier = "Driftinställning för Polisuppmärksamhet och risk / Förorening / Polistryck / Multiplikator.",
                    heatContaminatedThreshold = "Driftinställning för Polisuppmärksamhet och risk / Förorening / Tröskelvärde.",
                    heatCultivationFreePlants = "Driftinställning för Polisuppmärksamhet och risk / Odling / Plantor utan extra risk.",
                    heatCultivationHeatPerPlant = "Driftinställning för Polisuppmärksamhet och risk / Odling / Polistryck / Per planta.",
                    heatDealerHiddenMinutes = "Driftinställning för Polisuppmärksamhet och risk / Återförsäljare / dolt / Minuter.",
                    heatDecayPerTick = "Anpassa inställningarna för ”Förfall / Per uppdateringscykel” i avsnittet ”Drognätverk”.",
                    heatEnabled = "Driftinställning för Polisuppmärksamhet och risk / Aktiverad.",
                    heatEnforcementHeat = "Anpassa inställningarna för ”Polisnärvaro / Polistryck” i avsnittet ”Drognätverk”.",
                    heatEnforcementMultipliers = "Anpassa inställningarna för ”Polisnärvaro / Multiplikatorer” i avsnittet ”Drognätverk”.",
                    heatEntityTypes = "Anpassa inställningarna för ”Spelobjekt / Typer” i avsnittet ”Drognätverk”.",
                    heatEventCooldownMinutes = "Driftinställning för Polisuppmärksamhet och risk / Händelse / Nedkylningsminuter.",
                    heatEventHistoryLimit = "Driftinställning för Polisuppmärksamhet och risk / Händelse / Historikgräns.",
                    heatLabHeatSyncThreshold = "Driftinställning för Polisuppmärksamhet och risk / Lab / Polistryck / Synkronisering / Tröskelvärde.",
                    heatLayLowCooldownMinutes = "Driftinställning för Polisuppmärksamhet och risk / Ligga lågt / Nedkylningsminuter.",
                    heatLayLowIdleMinutes = "Driftinställning för Polisuppmärksamhet och risk / Ligga lågt / Idle / Minuter.",
                    heatLayLowReduction = "Driftinställning för Polisuppmärksamhet och risk / Ligga lågt / Minskning.",
                    heatLockdownMinutes = "Driftinställning för Polisuppmärksamhet och risk / Nedstängning / Minuter.",
                    heatMinimumDurationMinutes = "Driftinställning för Polisuppmärksamhet och risk / Minimum / Varaktighet / Minuter.",
                    heatMinimumEventCooldownSeconds = "Driftinställning för Polisuppmärksamhet och risk / Minimum / Händelse / Nedkylning (sekunder).",
                    heatMinimumIdleSeconds = "Driftinställning för Polisuppmärksamhet och risk / Minimum / Idle / sekunder.",
                    heatProcessingHeatMultiplier = "Driftinställning för Polisuppmärksamhet och risk / Bearbetning / Polistryck / Multiplikator.",
                    heatRiskWeights = "Anpassa inställningarna för ”Risk / Viktningar” i avsnittet ”Drognätverk”.",
                    heatRotateBurnerReduction = "Driftinställning för Polisuppmärksamhet och risk / Byt engångstelefon / Minskning.",
                    heatRouteControlMinutes = "Driftinställning för Polisuppmärksamhet och risk / Rutt / Kontroll / Minuter.",
                    heatSaleHeat = "Anpassa inställningarna för ”Försäljning / Polistryck” i avsnittet ”Drognätverk”.",
                    heatThresholds = "Anpassa inställningarna för ”Tröskelvärden” i avsnittet ”Drognätverk”.",
                    heatTickMinutes = "Driftinställning för Polisuppmärksamhet och risk / Uppdateringscykel / Minuter.",
                    heatWholesaleHeatMultiplier = "Driftinställning för Polisuppmärksamhet och risk / Grossist / Polistryck / Multiplikator.",
                    heatWorkerLeakAlertRadius = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Larmradie.",
                    heatWorkerLeakBaseChance = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Grundvärde / Chans.",
                    heatWorkerLeakFactionMultiplier = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Fraktion / Multiplikator.",
                    heatWorkerLeakHighSeverityThreshold = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Hög / Allvarlighetsgrad / Tröskelvärde.",
                    heatWorkerLeakLoyaltyChanceMultiplier = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Lojalitet / Chans / Multiplikator.",
                    heatWorkerLeakLoyaltyThreshold = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Lojalitet / Tröskelvärde.",
                    heatWorkerLeakMaximumChance = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Maximum / Chans.",
                    heatWorkerLeakMinimumCooldownSeconds = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Minimum / Nedkylning (sekunder).",
                    heatWorkerLeakRouteMultiplier = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Rutt / Multiplikator.",
                    heatWorkerLeakStrengthMaximum = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Styrka / Maximum.",
                    heatWorkerLeakStrengthMinimum = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Styrka / Minimum.",
                    heatWorkerLeakStrengthMultiplier = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Styrka / Multiplikator.",
                    heatWorkerLeakStressChanceMultiplier = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Stress / Chans / Multiplikator.",
                    heatWorkerLeakStressThreshold = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Stress / Tröskelvärde.",
                    contactsActionCooldownSeconds = "Driftinställning för Kontaktnätverk / Återhämtningstid för handlingar / sekunder.",
                    contactsActiveHotspotCount = "Driftinställning för Kontaktnätverk / Antal aktiva platser.",
                    contactsBurnerHintTrust = "Driftinställning för Kontaktnätverk / Burner-tips / Förtroende.",
                    contactsBurnerOfferMaximumMultiplier = "Driftinställning för Kontaktnätverk / Engångstelefon / Erbjudande / Maximum / Multiplikator.",
                    contactsBurnerOfferMinimumMultiplier = "Driftinställning för Kontaktnätverk / Engångstelefon / Erbjudande / Minimum / Multiplikator.",
                    contactsBuyerCooldownMinutes = "Driftinställning för Kontaktnätverk / Köpare / Nedkylningsminuter.",
                    contactsBuyerDeliveryDistance = "Driftinställning för Kontaktnätverk / Köpare / Inlämningsavstånd.",
                    contactsBuyerPremiumSuccessScore = "Driftinställning för Kontaktnätverk / Köpare / Premium / Framgång / Poäng.",
                    contactsBuyerPremiumTrustGain = "Driftinställning för Kontaktnätverk / Köpare / Premium / Förtroende / vinst.",
                    contactsBuyerRequestHeatRiskWeight = "Driftinställning för Kontaktnätverk / Köpare / Begäran / Efterlysning & Risk / Vikt.",
                    contactsBuyerStandardTrustGain = "Driftinställning för Kontaktnätverk / Köpare / Standard / Förtroende / vinst.",
                    contactsContactActiveDelaySeconds = "Anpassa inställningarna för ”Fördröjning för kontaktaktivering / sekunder” i avsnittet ”Drognätverk”.",
                    contactsContactDemandRange = "Anpassa inställningarna för ”Kontakt / Efterfrågan / Värdeintervall” i avsnittet ”Drognätverk”.",
                    contactsContactLossTrust = "Driftinställning för Kontaktnätverk / Kontakt / Förlust / Förtroende.",
                    contactsDarknetExactIntelMinutes = "Driftinställning för Kontaktnätverk / Darknet / Exakt information / Minuter.",
                    contactsDarknetHotspotIntelPrice = "Driftinställning för Kontaktnätverk / Darknet / Aktivt område / Underrättelser / Pris.",
                    contactsDarknetIntelPrice = "Driftinställning för Kontaktnätverk / Darknet / Underrättelser / Pris.",
                    contactsDealerBasePrice = "Driftinställning för Kontaktnätverk / Återförsäljare / Baspris.",
                    contactsDealerHireCapacity = "Anpassa inställningarna för ”Återförsäljare / Anställning / kapacitet” i avsnittet ”Drognätverk”.",
                    contactsDealerHireRisk = "Anpassa inställningarna för ”Återförsäljare / Anställning / Risk” i avsnittet ”Drognätverk”.",
                    contactsDealerHireSkill = "Anpassa inställningarna för ”Återförsäljare / Anställning / Färdighet” i avsnittet ”Drognätverk”.",
                    contactsDealerOffers = "Anpassa inställningarna för ”Dealer-erbjudanden” i avsnittet ”Drognätverk”.",
                    contactsDealerProtectionHours = "Driftinställning för Kontaktnätverk / Återförsäljare / Skydd / Timmar.",
                    contactsDealerProtectionPrice = "Driftinställning för Kontaktnätverk / Återförsäljare / Skydd / Pris.",
                    contactsDealerSaleMax = "Driftinställning för Kontaktnätverk / Återförsäljare / Försäljning / Maximum.",
                    contactsDealerSaleMin = "Driftinställning för Kontaktnätverk / Återförsäljare / Försäljning / Minimum.",
                    contactsDealerSimulation = "Anpassa inställningarna för ”Återförsäljare / Simulering” i avsnittet ”Drognätverk”.",
                    contactsDealerTickMinutes = "Driftinställning för Kontaktnätverk / Återförsäljare / Uppdateringscykel / Minuter.",
                    contactsDealerWage = "Driftinställning för Kontaktnätverk / Återförsäljare / Lön.",
                    contactsDealerWageDecay = "Driftinställning för Kontaktnätverk / Återförsäljare / Lön / Förfall.",
                    contactsDealerWageLoyaltyGain = "Driftinställning för Kontaktnätverk / Återförsäljare / Lön / Lojalitet / vinst.",
                    contactsDealerWeaknesses = "Anpassa inställningarna för ”Återförsäljare / Svagheter” i avsnittet ”Drognätverk”.",
                    contactsDefaultContactDemand = "Driftinställning för Kontaktnätverk / Standardvärde / Kontakt / Efterfrågan.",
                    contactsDefaultContactRisk = "Driftinställning för Kontaktnätverk / Standardvärde / Kontakt / Risk.",
                    contactsDefaultDealerCapacity = "Driftinställning för Kontaktnätverk / Standardlangare / kapacitet.",
                    contactsDefaultDealerRisk = "Driftinställning för Kontaktnätverk / Standardlangare / Risk.",
                    contactsDefaultDealerSkill = "Driftinställning för Kontaktnätverk / Standardlangare / Färdighet.",
                    contactsDefaultHotspotRadius = "Driftinställning för Kontaktnätverk / Standardvärde / Aktivt område / Radie.",
                    contactsDemandResetMinutes = "Driftinställning för Kontaktnätverk / Återställning av efterfrågan (minuter).",
                    contactsEnabled = "Driftinställning för Kontaktnätverk / Aktiverad.",
                    contactsExactLocationTrust = "Driftinställning för Kontaktnätverk / Exakt plats / Förtroende.",
                    contactsFactionDiscoveryReputation = "Driftinställning för Kontaktnätverk / Fraktion / Upptäckt / Rykte.",
                    contactsFactionHintTrust = "Driftinställning för Kontaktnätverk / Fraktion / Ledtråd / Förtroende.",
                    contactsFailedDeliveryCooldownMinutes = "Driftinställning för Kontaktnätverk / Misslyckad leverans / Nedkylningsminuter.",
                    contactsFakeDealEncounter = "Anpassa inställningarna för ”Falsk affär / Möte” i avsnittet ”Drognätverk”.",
                    contactsFallbackPreferredDrug = "Driftinställning för Kontaktnätverk / Reservvärde / Föredragen drog.",
                    contactsFallbackProductLabel = "Driftinställning för Kontaktnätverk / Reservvärde / Produktnamn.",
                    contactsGuideBookItem = "Driftinställning för Kontaktnätverk / Guide / Bok / Föremål.",
                    contactsGuideBookTrust = "Driftinställning för Kontaktnätverk / Guide / Bok / Förtroende.",
                    contactsHireDealerPrice = "Driftinställning för Kontaktnätverk / Anställ dealer / Pris.",
                    contactsHistoryLimit = "Driftinställning för Kontaktnätverk / Historikgräns.",
                    contactsHotspotIntelMinutes = "Driftinställning för Kontaktnätverk / Aktivt område / Underrättelser / Minuter.",
                    contactsHotspotRotationMinutes = "Driftinställning för Kontaktnätverk / Aktivt område / Byte / Minuter.",
                    contactsListingDurationMinutes = "Driftinställning för Kontaktnätverk / Annons / Varaktighet / Minuter.",
                    contactsMaxOwnedDealers = "Driftinställning för Kontaktnätverk / Maximum / Ägd / Langare.",
                    contactsMinimumBuyerDeliveryDistance = "Driftinställning för Kontaktnätverk / Minimum / Köpare / Inlämningsavstånd.",
                    contactsMinimumContactRotationMinutes = "Driftinställning för Kontaktnätverk / Minimum / Kontaktrotation (minuter).",
                    contactsMinimumDemandResetMinutes = "Driftinställning för Kontaktnätverk / Minimum / Återställning av efterfrågan (minuter).",
                    contactsMinimumHeatMultiplier = "Driftinställning för Kontaktnätverk / Minimum / Polistryck / Multiplikator.",
                    contactsMinimumHotspotIntelMinutes = "Driftinställning för Kontaktnätverk / Minimum / Aktivt område / Underrättelser / Minuter.",
                    contactsMinimumHotspotRadius = "Driftinställning för Kontaktnätverk / Minimum / Aktivt område / Radie.",
                    contactsMinimumHotspotRotationMinutes = "Driftinställning för Kontaktnätverk / Minimum / Aktivt område / Byte / Minuter.",
                    contactsMinimumListingDurationMinutes = "Driftinställning för Kontaktnätverk / Minimum / Annons / Varaktighet / Minuter.",
                    contactsMinimumRewardMultiplier = "Driftinställning för Kontaktnätverk / Minsta belöning / Multiplikator.",
                    contactsMinimumRobberyMultiplier = "Driftinställning för Kontaktnätverk / Minimum / Rån / Multiplikator.",
                    contactsMinimumSpotPriceMultiplier = "Driftinställning för Kontaktnätverk / Minimum / Plats / Prismultiplikator.",
                    contactsOtherDrugPriceMultiplier = "Driftinställning för Kontaktnätverk / Övrigt / Droger / Prismultiplikator.",
                    contactsPaymentAccount = "Driftinställning för Kontaktnätverk / Betalkonto.",
                    contactsPostDeliveryDemandResetSeconds = "Driftinställning för Kontaktnätverk / Efter leverans / Efterfrågan / Reset / sekunder.",
                    contactsPreferredDrugPriceMultiplier = "Driftinställning för Kontaktnätverk / Föredragen drog / Prismultiplikator.",
                    contactsRegionLocationTrust = "Driftinställning för Kontaktnätverk / Region / Plats / Förtroende.",
                    contactsRequestAmounts = "Anpassa inställningarna för ”Begäran / Mängder” i avsnittet ”Drognätverk”.",
                    contactsRotationMinutes = "Driftinställning för Kontaktnätverk / Byte / Minuter.",
                    contactsSpotPools = "Anpassa inställningarna för ”Plats / Urvalsgrupper” i avsnittet ”Drognätverk”.",
                    contactsStreetHotspots = "Anpassa inställningarna för ”Gata / Aktiva områden” i avsnittet ”Drognätverk”.",
                    contactsTrustLevels = "Anpassa inställningarna för ”Förtroende / Nivåer” i avsnittet ”Drognätverk”.",
                    businessActionCooldownSeconds = "Driftinställning för Företagsnätverk / Återhämtningstid för handlingar / sekunder.",
                    businessBalance = "Anpassa inställningarna för ”Saldo” i avsnittet ”Drognätverk”.",
                    businessContracts = "Anpassa inställningarna för ”Kontrakt” i avsnittet ”Drognätverk”.",
                    businessDefaultBusinessName = "Driftinställning för Företagsnätverk / Standardvärde / Företagsnamn.",
                    businessDefaultRankId = "Driftinställning för Företagsnätverk / Standardvärde / Rang / ID.",
                    businessDefaultStaffStyle = "Driftinställning för Företagsnätverk / Standardvärde / Personal / Arbetssätt.",
                    businessDefaultTransport = "Driftinställning för Företagsnätverk / Standardvärde / Transporter.",
                    businessEnabled = "Driftinställning för Företagsnätverk / Aktiverad.",
                    businessHubs = "Anpassa inställningarna för ”Distributionscentraler” i avsnittet ”Drognätverk”.",
                    businessLimits = "Anpassa inställningarna för ”Gränser” i avsnittet ”Drognätverk”.",
                    businessPayments = "Välj vilken balans som ska betala för inköp och driftskostnader i Business Network.",
                    businessPayoutAccount = "Driftinställning för Företagsnätverk / Utbetalning / Konto.",
                    businessRanks = "Anpassa inställningarna för ”Grader” i avsnittet ”Drognätverk”.",
                    businessReportDays = "Driftinställning för Företagsnätverk / Rapportperiod / dagar.",
                    businessRouteEndpointTypes = "Anpassa inställningarna för ”Rutt / Slutpunkt / Typer” i avsnittet ”Drognätverk”.",
                    businessRuntime = "Anpassa inställningarna för ”Drift i spelet” i avsnittet ”Drognätverk”.",
                    businessSocietyPermission = "Driftinställning för Företagsnätverk / Organisation / Behörighet.",
                    businessStaff = "Anpassa inställningarna för ”Personal” i avsnittet ”Drognätverk”.",
                    businessTickMinutes = "Driftinställning för Företagsnätverk / Uppdateringscykel / Minuter.",
                    businessTransports = "Anpassa inställningarna för ”Transporter” i avsnittet ”Drognätverk”.",
                },
                robbery = {
                    atmAvailability = "Aktivera eller inaktivera det fristående bankomat-rånssystemet.",
                    atmLocations = "Hantera de serverauktoriserade ATM-positionerna som är tillgängliga för rån.",
                    atmPolice = "Konfigurera kravet på poliser i tjänst för att starta ett rån.",
                    atmItems = "Ställ in de föremål som krävs för borr, bogseringsband och sprängladdning.",
                    atmActionTimes = "Ange varaktighet för att fästa, placera, detonera och plundra.",
                    atmTimeouts = "Styr hur länge en uppbruten bankomat förblir tillgänglig för loot.",
                    atmPayout = "Konfigurera målkontot och det slumpmässiga belöningsintervallet.",
                    atmDistances = "Ange avstånd för spelar- och fordonsinteraktioner vid ATM-användning.",
                    atmExplosionEffects = "Konfigurerar de nativa parametrarna för explosioner som används vid detonation.",
                    atmDispatchAlert = "Konfigurera radie, livslängd och prioritet för polislarmet.",
                    atmDispatchRecipients = "Välj vilka jobbnamn som ska få larm vid bankomatrån.",
                    shopAvailability = "Aktivera rån och konfigurera polis-kravet.",
                    shopTiming = "Konfigurera intimidering, handlingar, timeout och cooldown.",
                    shopSafe = "Konfigurera knappslå-försök och borrinventariet.",
                    shopRegisterReward = "Konfigurera slumpmässig belöning för varje kassa.",
                    shopSafeReward = "Konfigurera den slumpmässiga safebelöningen.",
                    shopDispatchSettings = "Konfigurera mottagare och larmegenskaper.",
                    shopLocationTable = "Hantera bemannade butiksplatser och kassaskåp.",
                    pickpocketAvailability = "Aktivera funktionen och begränsa den valfritt till konfigurerade crime-jobs.",
                    pickpocketGameplay = "Välj utmaning samt de oberoende sannolikheterna för flykt, nödanrop och motattack.",
                    pickpocketItemRewards = "Styr val av tomma fickor och synliga föremål ner till 0.0001 procent.",
                    pickpocketMoney = "Konfigurera det servergenererade slumpmässiga kontantintervallet.",
                    pickpocketDistances = "Ställ in NPC-radien som används av det delade radial- och målsystemet.",
                    pickpocketRateLimits = "Styr begärningsbegränsning (throttling), cooldown per NPC och sessionstidsgräns.",
                    pickpocketDispatchSettings = "Konfigurera larmet som skickas när en NPC ringer nödnumret.",
                    heistCrafting = "Välj hur mycket interaktion som krävs vid tillverkning av heist-utrustning. Gäller för nya försök i hela Crime-systemet.",
                    heistCreatorMenu = "Skapa, redigera och publicera modulära heists i den dedikerade Heist Creator.",
                    heistExecution = "Startfönster, inaktivitet och cooldown för heist-runs.",
                    npcPoliceSupport = "Beväpnade NPC-poliser svarar till fots på rån larm och stöttar polisen genom att engagera rånarna.",
                },
                baseRaids = {
                    baseRaids = "Raid-åtkomst, krav och individuellt valbara loot-kategorier. Öppna raids har ingen transporttidsgräns.",
                },
                weapons = {
                    weaponCreatorMenu = "Hantera vapenrutter och penningtvätt i en gemensam skapare.",
                    weaponRuntime = "Styr vapenrutternas tillgänglighet och åtkomst.",
                    weaponDefaultsgeneral = "Anpassa inställningarna för ”Allmänna standardvärden” i avsnittet ”Vapenrutter”.",
                    weaponDefaultsaccess = "Anpassa inställningarna för ”Standardåtkomst” i avsnittet ”Vapenrutter”.",
                    weaponDefaultscollection = "Anpassa inställningarna för ”Standardinsamling” i avsnittet ”Vapenrutter”.",
                    weaponDefaultsproduction = "Anpassa inställningarna för ”Standardproduktion” i avsnittet ”Vapenrutter”.",
                    weaponDefaultsmarket = "Anpassa inställningarna för ”Standardmarknad” i avsnittet ”Vapenrutter”.",
                    weaponDefaultsdelivery = "Anpassa inställningarna för ”Standardorder” i avsnittet ”Vapenrutter”.",
                    weaponStreet = "Anpassa inställningarna för ”Vapenförsäljning på gatan” i avsnittet ”Vapenrutter”.",
                },
                darknetMarket = {
                    darknetAvailability = "Styr surfplappsappen och dess placering.",
                    darknetEconomy = "Konfigurerar plånbalsaldon, myntväxling och betalningssatser.",
                    darknetListings = "Styr annonsgränser, priser och automatisk utgångstid.",
                    darknetChat = "Begränsar krypterade marknadsplatsmeddelanden.",
                    darknetIdentity = "Konfigurerar identitetsrotation, verifiering och bedrägerivarningar.",
                    darknetDelivery = "Konfigurerar fysiska möten och ställbara världslådor.",
                    darknetDeliveryLocations = "Konfigurerar de platspooler som slumpmässigt tilldelas BlackBay NPC-affärer.",
                    darknetPolice = "Jobbgrupper som får publicera fällor och se utredningar.",
                    darknetNpcTraders = "Beständiga NPC-köpare och säljare med konfigurerbar risk.",
                },
                interrogation = {
                    general = "Anpassa inställningarna för ”Allmänt” i avsnittet ”Förhör”.",
                    consent = "Anpassa inställningarna för ”Spelarskydd” i avsnittet ”Förhör”.",
                    objects = "Anpassa inställningarna för ”Objekt” i avsnittet ”Förhör”.",
                    grab = "Anpassa inställningarna för ”Gripande” i avsnittet ”Förhör”.",
                    session = "Anpassa inställningarna för ”Förhör” i avsnittet ”Förhör”.",
                    dispatch = "Anpassa inställningarna för ”Polisvarningar” i avsnittet ”Förhör”.",
                    logging = "Anpassa inställningarna för ”Loggning” i avsnittet ”Förhör”.",
                    security = "Anpassa inställningarna för ”Säkerhet” i avsnittet ”Förhör”.",
                    presentation = "Anpassa inställningarna för ”Visning” i avsnittet ”Förhör”.",
                },
                reputation = {
                    crimeReputation = "Anpassa inställningarna för ”Rykte” i avsnittet ”Rykte”.",
                },
            },
            settingGroups = {
                weaponRuntime = { label = "Allmänt", description = "Styr vapenrutternas tillgänglighet och åtkomst." },
                weaponCreatorMenu = { label = "Olaglig affärsskapare", description = "Hantera vapenrutter och penningtvätt i en gemensam skapare." },
                atmActionTimes = {
                    description = "Ange varaktighet för att fästa, placera, detonera och plundra.",
                    label = "Aktionsvaraktighet",
                },
                atmAvailability = {
                    description = "Aktivera eller inaktivera det fristående bankomat-rånssystemet.",
                    label = "Tillgänglighet",
                },
                atmDispatchAlert = {
                    description = "Konfigurera radie, livslängd och prioritet för polislarmet.",
                    label = "Larmegenskaper",
                },
                atmDispatchRecipients = {
                    description = "Välj vilka jobbnamn som ska få larm vid bankomatrån.",
                    label = "Mottagare",
                },
                atmDistances = {
                    description = "Ange avstånd för spelar- och fordonsinteraktioner vid ATM-användning.",
                    label = "Interaktionsavstånd",
                },
                atmExplosionEffects = {
                    description = "Konfigurerar de nativa parametrarna för explosioner som används vid detonation.",
                    label = "Explosionseffekter",
                },
                atmItems = {
                    description = "Ställ in de föremål som krävs för borr, bogseringsband och sprängladdning.",
                    label = "Nödvändiga föremål",
                },
                atmLocations = {
                    description = "Hantera de serverauktoriserade ATM-positionerna som är tillgängliga för rån.",
                    label = "ATM-platser",
                },
                atmPayout = {
                    description = "Konfigurera målkontot och det slumpmässiga belöningsintervallet.",
                    label = "Utbetalning",
                },
                atmPolice = {
                    description = "Konfigurera kravet på poliser i tjänst för att starta ett rån.",
                    label = "Poliskrav",
                },
                atmPulling = {
                    description = "Konfigurera den rörelse som krävs för att slita loss en bankomat från väggen.",
                    label = "Upptäckt av utdragning",
                },
                atmTimeouts = {
                    description = "Styr hur länge en uppbruten bankomat förblir tillgänglig för loot.",
                    label = "Loot-timeout",
                },
                baseRaids = {
                    description = "Raid-åtkomst, krav och individuellt valbara loot-kategorier. Öppna raids har ingen transporttidsgräns.",
                    label = "Base-raids",
                },
                businessPayments = {
                    description = "Välj vilken balans som ska betala för inköp och driftskostnader i Business Network.",
                    label = "Betalningar",
                },
                crimeMembership = {
                    description = "Välj hur kriminella organisationer lagrar och hanterar sina medlemmar.",
                    label = "Medlemskapsmodell",
                },
                darknetAvailability = {
                    description = "Styr surfplappsappen och dess placering.",
                    label = "Tillgänglighet",
                },
                darknetChat = {
                    description = "Begränsar krypterade marknadsplatsmeddelanden.",
                    label = "Privat chatt",
                },
                darknetDelivery = {
                    description = "Konfigurerar fysiska möten och ställbara världslådor.",
                    label = "Överlämningar och dead drops",
                },
                darknetDeliveryLocations = {
                    description = "Konfigurerar de platspooler som slumpmässigt tilldelas BlackBay NPC-affärer.",
                    label = "Överlämningsplatser",
                },
                darknetEconomy = {
                    description = "Konfigurerar plånbalsaldon, myntväxling och betalningssatser.",
                    label = "Kryptovaluta",
                },
                darknetIdentity = {
                    description = "Konfigurerar identitetsrotation, verifiering och bedrägerivarningar.",
                    label = "Alias och rykte",
                },
                darknetListings = {
                    description = "Styr annonsgränser, priser och automatisk utgångstid.",
                    label = "Erbjudanden och utgångstid",
                },
                darknetNpcTraders = {
                    description = "Beständiga NPC-köpare och säljare med konfigurerbar risk.",
                    label = "NPC-handlare",
                },
                darknetPolice = {
                    description = "Jobbgrupper som får publicera fällor och se utredningar.",
                    label = "Polisåtkomst",
                },
                heistCrafting = {
                    description = "Välj hur mycket interaktion som krävs vid tillverkning av heist-utrustning. Gäller för nya försök i hela Crime-systemet.",
                    label = "Heist-verkstad",
                },
                heistCreatorMenu = {
                    description = "Skapa, redigera och publicera modulära heists i den dedikerade Heist Creator.",
                    label = "Creator-meny",
                },
                heistExecution = {
                    description = "Startfönster, inaktivitet och cooldown för heist-runs.",
                    label = "Heist-tidsfönster",
                },
                moneywashEconomy = {
                    description = "Aktivera företag och konfigurera depositionskonto, serviceavgift och interaktionsavstånd.",
                    label = "Allmänt",
                },
                npcPoliceSupport = {
                    description = "Beväpnade NPC-poliser svarar till fots på rån larm och stöttar polisen genom att engagera rånarna.",
                    label = "NPC-polisstöd",
                },
                pickpocketAvailability = {
                    description = "Aktivera funktionen och begränsa den valfritt till konfigurerade crime-jobs.",
                    label = "Tillgänglighet",
                },
                pickpocketDispatchSettings = {
                    description = "Konfigurera larmet som skickas när en NPC ringer nödnumret.",
                    label = "Nödupprop",
                },
                pickpocketDistances = {
                    description = "Ställ in NPC-radien som används av det delade radial- och målsystemet.",
                    label = "Interaktionsavstånd",
                },
                pickpocketGameplay = {
                    description = "Välj utmaning samt de oberoende sannolikheterna för flykt, nödanrop och motattack.",
                    label = "Risk och minispel",
                },
                pickpocketItemRewards = {
                    description = "Styr val av tomma fickor och synliga föremål ner till 0.0001 procent.",
                    label = "Synlig fick-loot",
                },
                pickpocketMoney = {
                    description = "Konfigurera det servergenererade slumpmässiga kontantintervallet.",
                    label = "Kontantbelöning",
                },
                pickpocketRateLimits = {
                    description = "Styr begärningsbegränsning (throttling), cooldown per NPC och sessionstidsgräns.",
                    label = "Serverskydd",
                },
                pvpArenas = {
                    description = "Skapa den cirkulära zonen, observatörspunkten och team-spawnpunkterna som används av PvP-events.",
                    label = "Arenor och stridszoner",
                },
                pvpAutomation = {
                    description = "Konfigurera återkommande händelser och automatisk startprocess.",
                    label = "Automatisering",
                },
                pvpAvailability = {
                    description = "Styr om PvP-event-appen är tillgänglig och var den visas.",
                    label = "Tillgänglighet",
                },
                pvpLimits = {
                    description = "Ställ in gränser för belöningar och surfplattans historik.",
                    label = "Gränser och historik",
                },
                pvpModes = {
                    description = "Konfigurera det förinställda spelläget i PvP-surfplattan.",
                    label = "Spellägen",
                },
                pvpPermissions = {
                    description = "Koppla eventhantering och ekonomi till ACE- och jobbtillstånd.",
                    label = "Behörigheter",
                },
                pvpRuntime = {
                    description = "Justera hantering av begärningar, dödsfall och respawns under pågående matcher.",
                    label = "Event-tid",
                },
                pvpTakeoverMethods = {
                    description = "Konfigurera hur lång tid varje metod tar för att bryta upp en ingång.",
                    label = "Inbrottsmetoder",
                },
                pvpTakeoverRules = {
                    description = "Styr tillgänglighet och deltagarkrav för övertagande av laboratorier och campers.",
                    label = "Övertagningsregler",
                },
                pvpTakeoverZones = {
                    description = "Konfigurera interaktions-, larm- och erövringsområden tillsammans med deras varaktighet.",
                    label = "Zoner och tid",
                },
                shopAvailability = {
                    description = "Aktivera rån och konfigurera polis-kravet.",
                    label = "Tillgänglighet",
                },
                shopDispatchSettings = {
                    description = "Konfigurera mottagare och larmegenskaper.",
                    label = "Polislarm",
                },
                shopLocationTable = {
                    description = "Hantera bemannade butiksplatser och kassaskåp.",
                    label = "Butiksplatser",
                },
                shopRegisterReward = {
                    description = "Konfigurera slumpmässig belöning för varje kassa.",
                    label = "Belöning för kassan",
                },
                shopRegisterTable = {
                    description = "Tilldela enskilda kassor till butiker.",
                    label = "Kassor",
                },
                shopSafe = {
                    description = "Konfigurera knappslå-försök och borrinventariet.",
                    label = "Kassaskåp",
                },
                shopSafeReward = {
                    description = "Konfigurera den slumpmässiga safebelöningen.",
                    label = "Safebelöning",
                },
                shopTiming = {
                    description = "Konfigurera intimidering, handlingar, timeout och cooldown.",
                    label = "Tidsschema",
                },
            },
            settingSections = {
                weapons = "Vapenrutter",
                drugs = "Drogsystem",
                drugProduction = "Drogproduktion",
                drugOperations = "Drogverksamhet",
                drugMarketRisk = "Marknad och risk",
                drugNetworks = "Drognätverk",
                atmRobbery = "Bankomatrån",
                baseRaids = "Base-raids",
                crimeOrganizations = "Organisationer",
                darknetMarket = "Darknet-marknad",
                moneywash = "Penntvätt",
                pvpEvents = "Fraktions-PvP",
                robbery = "Rån",
                territories = "Territorier",
                graffiti = "Graffiti Ordförande",
                interrogation = "Förhör",
            },
            settingSubsections = {
                baseRaidEquipment = "Nödvändig utrustning",
                baseRaidBreach = "Inbrytning",
                baseRaidLoot = "Byte och fordon",
                graffitiLimits = "Gränser och moderering",
                interrogationTechnical = "Loggning och säkerhet",
                atmDispatch = "Polisutryckning",
                atmEquipment = "Utrustning",
                atmExplosion = "Explosion",
                atmOverview = "Översikt & platser",
                atmRewards = "Belöningar",
                atmTiming = "Tidsschema",
                atmVehicle = "Fordon & bortdragning",
                baseRaids = "Base-raids",
                crimeMembership = "Medlemskap",
                heistCreator = "Rånskapare",
                npcPoliceSupport = "NPC-polisstöd",
                pickpocket = "NPC-fickstöld",
                pvpArenas = "Arenor",
                pvpEquipment = "Spellägen",
                pvpOverview = "Översikt",
                pvpRuntime = "Event-tid",
                pvpTakeovers = "Laboratorieövertaganden",
                shopRobbery = "Butiksrån",
                atmRobbery = "Bankomatrån",
            },
            settings = {
                weaponDefaultGeneralInteractionDistance = { label = "Interaktionsavstånd" },
                weaponDefaultGeneralPedModel = { label = "Standardmodell för NPC" },
                weaponDefaultAccessActiveHourStart = { label = "Öppningstid (UTC)" },
                weaponDefaultAccessActiveHourEnd = { label = "Stängningstid (UTC)" },
                weaponDefaultAccessPoliceRequired = { label = "Poliser i tjänst som krävs" },
                weaponDefaultAccessPoliceJobs = { label = "Polisjobb" },
                weaponDefaultCollectionDurationSeconds = { label = "Tid i sekunder" },
                weaponDefaultCollectionCooldownSeconds = { label = "Väntetid i sekunder" },
                weaponDefaultCollectionCooldownScope = { label = "Väntetidens omfattning" },
                weaponDefaultCollectionUseMinigame = { label = "Använd minispel" },
                weaponDefaultCollectionMinigame = { label = "Minispel" },
                weaponDefaultCollectionMinigameRounds = { label = "Minispelsrundor" },
                weaponDefaultProductionDurationSeconds = { label = "Tid i sekunder" },
                weaponDefaultProductionSuccessChance = { label = "Chans att lyckas (%)" },
                weaponDefaultProductionFailureConsumesInputs = { label = "Förbruka ingredienser vid misslyckande" },
                weaponDefaultProductionUseMinigame = { label = "Använd minispel" },
                weaponDefaultProductionMinigame = { label = "Minispel" },
                weaponDefaultProductionMinigameRounds = { label = "Minispelsrundor" },
                weaponDefaultProductionQualityMin = { label = "Lägsta kvalitet" },
                weaponDefaultProductionQualityMax = { label = "Högsta kvalitet" },
                weaponDefaultProductionCooldownSeconds = { label = "Väntetid i sekunder" },
                weaponDefaultProductionCooldownScope = { label = "Väntetidens omfattning" },
                weaponDefaultMarketPayoutAccount = { label = "Utbetalningskonto" },
                weaponDefaultMarketPriceMultiplierMin = { label = "Lägsta prisfaktor (%)" },
                weaponDefaultMarketPriceMultiplierMax = { label = "Högsta prisfaktor (%)" },
                weaponDefaultMarketRestockSeconds = { label = "Påfyllningsintervall i sekunder" },
                weaponDefaultMarketCooldownSeconds = { label = "Väntetid i sekunder" },
                weaponDefaultMarketCooldownScope = { label = "Väntetidens omfattning" },
                weaponDefaultDeliveryContractDurationMinutes = { label = "Orderfrist i minuter" },
                weaponDefaultDeliveryContractBonusPercent = { label = "Orderbonus (%)" },
                weaponStreetEnabled = { label = "Sällsynta vapenförsäljningar till gatuköpare" },
                weaponStreetChance = { label = "Chans till vapenerbjudande (%)" },
                weaponStreetCooldown = { label = "Väntetid i sekunder" },
                weaponStreetAmount = { label = "Största mängd" },
                weaponStreetPriceMin = { label = "Lägsta prisfaktor (%)" },
                weaponStreetPriceMax = { label = "Högsta prisfaktor (%)" },
                weaponStreetAccount = { label = "Utbetalningskonto" },
                weaponStreetDirect = { label = "Direktförsäljning" },
                weaponStreetBulk = { label = "Partiförsäljning" },
                weaponStreetContract = { label = "Kartellorder" },
                weaponSystemEnabled = { label = "System för vapenrutter", description = "Aktivera vapensamling, bearbetning och försäljning till karteller." },
                weaponRuntimeEnabled = { label = "Åtgärder för vapenrutter", description = "Tillåt att konfigurerade vapenrutter används i spelvärlden." },
                weaponCreatorAccess = { label = "Tillgång till vapeneditorn", description = "Välj vem som får öppna vapenredigeraren.", options = { permission = "Endast med behörighet", jobManagement = "Jobbhantering", ownerOnly = "Endast ägare" } },
                openWeaponCreator = { label = "Olaglig affärsskapare", description = "Hantera vapenrutter och penningtvätt i en gemensam skapare.", buttonLabel = "Olaglig affärsskapare", unsavedTooltip = "Spara först" },

                drugCultivationProgressionEnabled = { label = "Aktivera odlingsnivåer", description = "Aktiverar odlings-XP, nivåer och nivåbaserade upplåsningar." },
                drugCultivationMaxLevel = { label = "Högsta odlingsnivå", description = "Högsta nåbara odlingsnivå. Högre nivåer förblir onåbara." },
                drugCultivationLevels = { label = "Nivåkurva", description = "Ställ in namn och total XP-gräns för varje odlingsnivå." },
                drugCultivationActionXp = { label = "XP-belöningar", description = "Ställ in hur mycket odlings-XP varje åtgärd ger." },
                drugCultivationUnlocks = { label = "Nivåupplåsningar", description = "Ställ in krävda nivåer för behållare, substrat, utrustning, sorter och skannernivåer." },
                reputationRewards = { label = "Rykteshandlingar", description = "Lägg till handlingar, ändra poäng och inaktivera eller ta bort poster. Endast aktiva poster ger poäng." },
                reputationEnabled = { label = "Aktivera kriminellt rykte", description = "Tilldela personligt rykte." },
                reputationPointsPerLevel = { label = "Poäng per nivå", description = "Varje nivå kräver så här många ytterligare poäng." },
                reputationMinimumJoinPoints = { label = "Minsta rykte för inträde", description = "Totala poäng som krävs för att gå med i en kriminell fraktion. 0 stänger av kravet. Befintliga medlemmar behåller tillgången." },
                reputation_atm = { label = "Bankomatrån", description = "Poäng per slutförd handling. 0 stänger av denna belöning." },
                reputation_shop_register = { label = "Butikskassa", description = "Poäng per slutförd handling. 0 stänger av denna belöning." },
                reputation_shop_safe = { label = "Butikskassaskåp", description = "Poäng per slutförd handling. 0 stänger av denna belöning." },
                reputation_pickpocket = { label = "Ficktjuveri", description = "Poäng per slutförd handling. 0 stänger av denna belöning." },
                reputation_heist = { label = "Slutfört rån", description = "Poäng per slutförd handling. 0 stänger av denna belöning." },
                reputation_drug_harvest = { label = "Drogskörd", description = "Poäng per slutförd handling. 0 stänger av denna belöning." },
                reputation_drug_processing = { label = "Drogberedning", description = "Poäng per slutförd handling. 0 stänger av denna belöning." },
                reputation_drug_sale = { label = "Drogförsäljning", description = "Poäng per slutförd handling. 0 stänger av denna belöning." },
                reputation_drug_delivery = { label = "Drogleverans", description = "Poäng per slutförd handling. 0 stänger av denna belöning." },
                reputation_drug_contract = { label = "Distributionsavtal", description = "Poäng per slutförd handling. 0 stänger av denna belöning." },
                reputation_drug_raid = { label = "Drogräd", description = "Poäng per slutförd handling. 0 stänger av denna belöning." },
                reputation_graffiti = { label = "Graffiti Ordförande", description = "Poäng per slutförd handling. 0 stänger av denna belöning." },
                reputation_moneywash = { label = "Penningtvätt", description = "Poäng per slutförd handling. 0 stänger av denna belöning." },
                reputation_base_raid = { label = "Basräd", description = "Poäng per slutförd handling. 0 stänger av denna belöning." },
                reputation_pvp_win = { label = "PvP-seger", description = "Poäng per slutförd handling. 0 stänger av denna belöning." },
                atmChargeProp = {
                    description = "Objektmodell som visas på ATM:en medan sprängladdningen placeras.",
                    label = "Sprängladdningsobjekt",
                },
                atmConsumeDrill = {
                    description = "Förbrukar det inställda antalet efter varje borrpunkt på bankomaten som har slutförts utan fel.",
                    label = "Förbruka borr",
                },
                atmDrillItem = {
                    description = "Inventarieföremålets ID som krävs för att borra upp en lossryckt bankomat. Ställs in separat från borren för butikernas kassaskåp.",
                    label = "Borrföremål",
                },
                atmDrillItemAmount = {
                    description = "Antal borrföremål som krävs för varje borrpunkt på bankomaten.",
                    label = "Antal borrar som krävs",
                },
                atmDebug = {
                    description = "Skriver detaljerad diagnostik för bankomatrån till serverkonsolen och klientens F8-konsol.",
                    label = "Debug-loggar för bankomat",
                },
                atmDispatchDurationSeconds = {
                    description = "Antal sekunder som ATM-larmet är relevant för larmmottagare.",
                    label = "Larmets varaktighet",
                },
                atmDispatchEnabled = {
                    description = "Skapar en incident för Jobs Base när en bankomat har brutits upp.",
                    label = "Aktivera polisinsats",
                },
                atmDispatchJobs = {
                    description = "Kommaseparerade jobbnamn som får ATM-varningen.",
                    label = "Utryckningsjobb",
                },
                atmDispatchPriority = {
                    description = "Prioritetsvärde som skickas oförändrat till utryckningsintegrationen.",
                    label = "Utryckningsprioritet",
                },
                atmDispatchRadius = {
                    description = "Ungefärlig varlingsradie som skickas till utryckningsintegrationen.",
                    label = "Utryckningsradie",
                },
                atmEnabled = {
                    description = "Gör konfigurerade uttagsautomater tillgängliga för snara- och sprängrån.",
                    label = "Aktivera ATM-rån",
                },
                atmExplosionCameraShake = {
                    description = "Intensitet på kameraskak för klienten som skapar explosionen.",
                    label = "Kameraskak vid explosion",
                },
                atmExplosionDamageScale = {
                    description = "Skade- och impulsstyrka som skickas till explosions-nativet.",
                    label = "Skadefaktor för explosioner",
                },
                atmExplosionType = {
                    description = "GTA-explosionstyp som används vid detonation. Behåll standardinställningen om inte en annan typ har testats.",
                    label = "Explosionstyp",
                },
                atmDrillDurationSeconds = {
                    label = "Minsta borrtid per skruv (s)",
                    description = "Minsta tid i sekunder för var och en av de fyra skruvarna. Kylpauser förlänger försöket. Gäller borrförsök som påbörjas efter att inställningarna sparats.",
                },
                atmExplosiveDurationSeconds = {
                    description = "Antal sekunder som krävs för att placera sprängladdningen.",
                    label = "Tid för att placera sprängladdning",
                },
                atmExplosiveItem = {
                    description = "Föremål i inventariet som förbrukas efter att laddningen har placerats.",
                    label = "Sprängämne",
                },
                atmExplosiveItemAmount = {
                    description = "Antal sprängämnesföremål som förbrukas för en placerad laddning.",
                    label = "Förbrukad mängd sprängämne",
                },
                atmFuseSeconds = {
                    description = "Sekunder mellan placering och detonation.",
                    label = "Tändtid",
                },
                atmInteractionDistance = {
                    description = "Maximal klient-interaktionsradie; servervalidering lägger till en säkerhetsmarginal.",
                    label = "Interaktionsavstånd",
                },
                atmLocations = {
                    description = "Officiella produktions-ATM:er. Platser som skapats med /atmtest är tillfälliga.",
                    itemLabel = "ATM-plats",
                    label = "ATM-platser",
                },
                atmLootDurationSeconds = {
                    description = "Sekunder som krävs för att bryta upp en sprängd uttagsautomat.",
                    label = "Loot-varaktighet",
                },
                atmLootReservationTimeoutSeconds = {
                    description = "Maximalt antal sekunder en spelare får reservera en bankomat medan den öppnas; hålls automatiskt över loot-varaktigheten.",
                    label = "Timeout för loot-reservation",
                },
                atmLootWindowMinutes = {
                    description = "Minuter som en inbruten bankomat förblir lootbar innan den är tömd.",
                    label = "Loot-fönster",
                },
                atmMinimumPolice = {
                    description = "Antal polismedlemmar i den konfigurerade polismiljön som är i tjänst och krävs för att påbörja ett rån.",
                    label = "Minsta antal poliser",
                },
                atmPoliceGroup = {
                    description = "sky_jobs_base jobgrupp räknad för polisens krav.",
                    label = "Polisjobbgrupp",
                },
                atmPullDistance = {
                    description = "Fordonets förflyttning från bankomatens position som krävs för att slutföra inbrottet.",
                    label = "Nödvändigt dragavstånd",
                },
                atmPullMinimumSpeed = {
                    description = "Minsta bilhastighet i meter per sekund när avståndet för draget har uppnåtts.",
                    label = "Minsta draghastighet",
                },
                atmReservationTimeoutSeconds = {
                    description = "Maximala sekunder som reserveras medan en spelare monterar en snara eller placerar en laddning; hålls automatiskt över aktionens varaktighet.",
                    label = "Timeout för förberedelsebokning",
                },
                atmRewardAccount = {
                    description = "Välj mellan kontanter och föremålet black_money.",
                    label = "Utbetalningstyp för bankomat",
                },
                atmRewardMaximum = {
                    description = "Högsta kontantutbetalning från en uttagsautomat; aldrig lägre än minimivärdet.",
                    label = "Maximal belöning",
                },
                atmRewardMinimum = {
                    description = "Lägsta kontantutbetalning från en bankomat.",
                    label = "Minsta belöning",
                },
                atmSlingDurationSeconds = {
                    description = "Antal sekunder som krävs för att fästa slyngan.",
                    label = "Tid för att fästa slynga",
                },
                atmSlingItem = {
                    description = "Återanvändbart inventarieföremål som krävs för fordonsmetoden.",
                    label = "Sling-föremål",
                },
                atmSlingItemAmount = {
                    description = "Antal slingor som måste finnas närvarande. De förbrukas inte.",
                    label = "Nödvändig mängd slingor",
                },
                atmTestScanDistance = {
                    description = "Maximalt avstånd som används av /atmtest när den letar efter en kompatibel ATM-prop.",
                    label = "ATM-test skanningsavstånd",
                },
                atmVehicleMaxDistance = {
                    description = "Maximalt avstånd mellan bankomaten och ett lämpligt fordon vid montering av slingan.",
                    label = "Avstånd för fordon vid montering",
                },
                baseRaid_breachTimeoutSeconds = {
                    description = "Tidsgräns för varje försök att bryta upp ett förråd (sekunder).",
                    label = "Inbrottstidsgräns (sekunder)",
                },
                baseRaid_command = {
                    description = "Kommandot utan snedstreck. Starta om crime-resursen efter att du ändrat det.",
                    label = "Raid-kommando",
                },
                baseRaid_crimeItem = {
                    description = "Gäng-intrångsföremål.",
                    label = "Gäng-intrångsföremål",
                },
                baseRaid_crimeVehicles = {
                    description = "Gängfordonstillgång.",
                    label = "Gängfordonstillgång",
                },
                baseRaid_difficulty = {
                    description = "Svårighetsgrad för skillcheck.",
                    label = "Svårighetsgrad för skillcheck",
                    options = {
                        easy = "Enkel",
                        expert = "Experter",
                        hard = "Svår",
                        normal = "Normalt",
                    },
                },
                baseRaid_enabled = {
                    description = "Aktivera bas-räder.",
                    label = "Aktivera bas-räder",
                },
                baseRaid_failedCooldownMinutes = {
                    description = "Väntetid när en räd avslutas utan att något förråd öppnats (minuter).",
                    label = "Cooldown efter misslyckande (minuter)",
                },
                baseRaid_interactionDistance = {
                    description = "Interaktionsavstånd för förvaring.",
                    label = "Interaktionsavstånd för förvaring",
                },
                baseRaid_lootHeistStorage = {
                    description = "Tillåt fullständig tömning av denna inventarietyp under ett pågående rån.",
                    label = "Loot-förvaring för rån",
                },
                baseRaid_lootLaboratories = {
                    description = "Tillåt fullständig tömning av denna inventarietyp under ett pågående rån.",
                    label = "Plundra laboratorielager",
                },
                baseRaid_lootPersonalLockers = {
                    description = "Tillåt fullständig tömning av denna inventarietyp under ett pågående rån.",
                    label = "Plundra personliga skåp",
                },
                baseRaid_lootStorage = {
                    description = "Tillåt fullständig tömning av denna inventarietyp under ett pågående rån.",
                    label = "Plundra lager",
                },
                baseRaid_lootVehicleGloveboxes = {
                    description = "Tillåt fullständig tömning av denna inventarietyp under ett pågående rån.",
                    label = "Plundra handskfack",
                },
                baseRaid_lootVehicleTrunks = {
                    description = "Tillåt fullständig tömning av denna inventarietyp under ett pågående rån.",
                    label = "Plundra bilens bagageutrymmen",
                },
                baseRaid_minimumDefenders = {
                    description = "Minsta antal försvarare online.",
                    label = "Minsta antal försvarare online",
                },
                baseRaid_policeItem = {
                    description = "Polisens brytföremål.",
                    label = "Polisens brytföremål",
                },
                baseRaid_policeRequireDuty = {
                    description = "Polisen måste vara i tjänst.",
                    label = "Polisen måste vara i tjänst",
                },
                baseRaid_policeVehicles = {
                    description = "Polisfordonran för fordon.",
                    label = "Polisfordonstillgång",
                },
                baseRaid_protectionHours = {
                    description = "Skydd efter framgång (timmar).",
                    label = "Skydd efter framgång (timmar)",
                },
                baseRaid_requiredHits = {
                    description = "Nödvändiga skillcheck-träffar.",
                    label = "Nödvändiga skillcheck-träffar",
                },
                baseRaid_warrantItem = {
                    description = "Ett av dessa items förbrukas vid varje giltig start av en polisinsats.",
                    label = "Husrannsakan-item",
                },
                crimeMembershipMode = {
                    description = "Framework-läget behåller befintlig jobb- eller gängintegration. Oberoende läge kör brottsorganisationen i bakgrunden parallellt med spelarens vanliga jobb och migrerar befintliga medlemskap automatiskt.",
                    label = "Organisationsmodell för medlemskap",
                    options = {
                        framework = "Framework-jobb / gäng",
                        independent = "Oberoende organisation",
                    },
                },
                darknetAliasChangeCooldownHours = {
                    description = "Minsta ålder för en identitet innan den kan pensioneras igen.",
                    label = "Cooldown för aliasbyte (timmar)",
                },
                darknetCurrencyCode = {
                    description = "Kort etikett som visas för den interna kryptovalutaledern.",
                    label = "Valutakod",
                },
                darknetDeadDropInteractionDistance = {
                    description = "Nödvändigt avstånd för att söka igenom och göra anspråk på en låda.",
                    label = "Interaktionsavstånd för dead-drop",
                },
                darknetDeadDropLifetimeHours = {
                    description = "Tid innan en omarkerad låda löper ut.",
                    label = "Dead-drop livslängd (timmar)",
                },
                darknetDeadDropModel = {
                    description = "GTA-propmodell som spawnas lokalt för tillgängliga dead drops.",
                    label = "Dead-drop lådkonfiguration",
                },
                darknetDeadDropPollIntervalMs = {
                    description = "Intervall som används för att uppdatera närliggande lådor och NPC-möten.",
                    label = "Världens uppdateringsintervall (ms)",
                },
                darknetDeadDropStreamDistance = {
                    description = "Avstånd där lådor och NPC-möteskontakter streamas.",
                    label = "Dead-drop stream-avstånd",
                },
                darknetDropLocations = {
                    description = "Platser som slumpmässigt tilldelas dead-drop-affärer med NPC:er. Konfigurera minst två.",
                    itemLabel = "Dead-drop-plats",
                    label = "Dead-drop-platser",
                },
                darknetEnabled = {
                    description = "Gör svartmarknadens tablet-app och dess runtime tillgänglig.",
                    label = "Aktivera Darknet Market",
                },
                darknetExchangeBuyPrice = {
                    description = "Belopp som debiteras från betalkontot för en coin.",
                    label = "Inköpspris per coin",
                },
                darknetExchangeEnabled = {
                    description = "Tillåter autentiserade BlackBay-användare att köpa och sälja coins på sin kontosida.",
                    label = "Aktivera coin-växling",
                },
                darknetExchangeMaximumAmount = {
                    description = "Största hela coin-belopp som accepteras i en växling.",
                    label = "Maximalt antal coins per växling",
                },
                darknetExchangeMinimumAmount = {
                    description = "Minsta hela coin-belopp som accepteras i en växling.",
                    label = "Minsta antal coins per växling",
                },
                darknetExchangePaymentAccount = {
                    description = "Framework-konto som används för coin-köp och utbetalningar från försäljning.",
                    label = "Betalkonto för coin-växling",
                    options = {
                        bank = "Banken",
                        black_money = "Smutsiga pengar",
                        money = "Kontanter",
                    },
                },
                darknetExchangeSellPrice = {
                    description = "Belopp som betalas ut till betalkontot för en coin.",
                    label = "Försäljningspris per coin",
                },
                darknetFaceToFaceDistance = {
                    description = "Maximalt avstånd mellan båda spelarna eller till den konfigurerade NPC-punkten.",
                    label = "Överlämningsavstånd",
                },
                darknetKnownScammerReports = {
                    description = "Unika handelsrapporter som krävs för märket",
                    label = "Rapporter för bedragarvarning",
                },
                darknetListingExpiryHours = {
                    description = "Aktiva erbjudanden löper ut automatiskt efter detta antal timmar.",
                    label = "Erbjudandets livslängd (timmar)",
                },
                darknetMaximumListingQuantity = {
                    description = "Övre mängdgräns för ett erbjudande.",
                    label = "Maximal mängd varor",
                },
                darknetMaximumListings = {
                    description = "Maximalt antal erbjudanden per aktiv alias.",
                    label = "Maximalt antal aktiva erbjudanden",
                },
                darknetMaximumMessageLength = {
                    description = "Maximalt antal tecken per krypterat chattmeddelande.",
                    label = "Maximal meddelandelängd",
                },
                darknetMaximumUnitPrice = {
                    description = "Övre kryptopris för en enhet.",
                    label = "Maximalt styckpris",
                },
                darknetMeetingLocations = {
                    description = "Platser som slumpmässigt tilldelas för personliga affärer med NPC:er. Konfigurera minst två.",
                    itemLabel = "Mötesplats",
                    label = "Mötesplatser",
                },
                darknetNpcBuyerAliases = {
                    description = "Fiktiva namn som tilldelas nya NPC-köpförfrågningar slumpmässigt. Konfigurera minst två unika alias.",
                    label = "NPC-köpares alias",
                },
                darknetNpcMaximumBuyListings = {
                    description = "Övre gräns för slumpmässigt val av hur många NPC-köpförfrågningar som blir aktiva.",
                    label = "Max antal NPC-köpförfrågningar",
                },
                darknetNpcMaximumSellListings = {
                    description = "Övre gräns som används när man slumpmässigt väljer hur många NPC-försäljningserbjudanden som ska vara aktiva.",
                    label = "Max antal NPC-försäljningserbjudanden",
                },
                darknetNpcMinimumBuyListings = {
                    description = "När NPC-marknaden fylls på förblir minst detta antal slumpmässigt utvalda köpförfrågningar aktiva.",
                    label = "Minsta antal NPC-köpförfrågningar",
                },
                darknetNpcMinimumSellListings = {
                    description = "När NPC-marknaden fylls på, förblir minst detta antal slumpmässigt utvalda försäljningserbjudanden aktiva.",
                    label = "Minsta antal NPC-försäljningserbjudanden",
                },
                darknetNpcSellerAliases = {
                    description = "Fiktiva namn som tilldelas nya NPC-försäljningserbjudanden slumpmässigt. Konfigurera minst två unika aliaser.",
                    label = "NPC-säljarealiaser",
                },
                darknetNpcTraders = {
                    description = "Konfigurera syntetiska erbjudanden, leveransmetod, rykte och bedrägerisannolikhet.",
                    label = "NPC-köpare och -säljare",
                },
                darknetPoliceGroups = {
                    description = "Gruppnycklar som kan publicera lockbeten och se utredningar.",
                    label = "Auktoriserade polisingrupper",
                },
                darknetRenewalHours = {
                    description = "Timmar som läggs till när en ägare förlänger ett erbjudande.",
                    label = "Förlängningsperiod (timmar)",
                },
                darknetScamChance = {
                    description = "Minsta chans att en NPC-handel tar betalningen eller varorna utan att leverera motprestationen. En högre handlar-specifik chans gäller fortfarande.",
                    label = "Global NPC-bedrägerichans (%)",
                },
                darknetStarterBalance = {
                    description = "Krypto tilldelas endast när en spelare öppnar marknaden för första gången.",
                    label = "Startsaldo för nya wallets",
                },
                darknetTabletOrder = {
                    description = "Styr Darknet Markets position på tableten.",
                    label = "Ordning för tablet-appen",
                },
                darknetVerifiedMinimumRating = {
                    description = "Minsta genomsnittliga betyg för en verifierad säljare.",
                    label = "Betyg som krävs för verifiering",
                },
                darknetVerifiedMinimumSales = {
                    description = "Antal lyckade försäljningar som krävs innan en säljare kan bli verifierad.",
                    label = "Försäljningar som krävs för verifiering",
                },
                drugAdvancedBusinessNetworkPaymentAccount = {
                    description = "Används när betalningskällan är inställd på spelarkontot. Organisationsbetalningar använder alltid kontot i Boss-menyn.",
                    label = "Spelarkonto",
                    options = {
                        bank = "Banken",
                        black_money = "Smutsiga pengar",
                        money = "Kontanter",
                    },
                    requiresWarning = "Används endast med spelarkontot som betalningskälla.",
                },
                drugAdvancedBusinessNetworkPaymentSource = {
                    description = "Använd antingen den köpande spelarens saldo eller organisationens konto i Boss-menyn.",
                    label = "Betalningskälla",
                    options = {
                        player = "Spelarkonto",
                        society = "Organisationens konto",
                    },
                },
                drugCamperLockKey = {
                    description = "Ställer in standardtangenten för att låsa och låsa upp egna eller fraktionsdelade campers. Spelare kan ändra detta i sina FiveM-tangentinställningar.",
                    label = "Standardtangent för camper-lås",
                    options = {
                        L = "L",
                        U = "U",
                        K = "K",
                        J = "J",
                        G = "G",
                        H = "H",
                        X = "X",
                        Y = "YTTERLIGARE",
                        F6 = "F6",
                        F7 = "F7",
                    },
                },
                drugCollectorInventoryMetadata = {
                    description = "Lägg till kvalitets- och batchdata till samlarresultat som standard. Inaktivera detta för att råmaterial ska staplas normalt.",
                    label = "Metadata för samlarföremål",
                },
                drugLabAssaultAlertDuration = {
                    description = "Antal sekunder som vaktens larmradie förblir synlig på kartan.",
                    label = "Vaktens larmduration",
                },
                drugLabAssaultAlertRadius = {
                    description = "Radie för attackzonen som visas för den försvarande fraktionen på kartan.",
                    label = "Larmradie för försvarare",
                },
                drugLabAssaultBreachRadius = {
                    description = "Radien som en angripare måste hålla sig inom medan ingången bryts upp.",
                    label = "Radius för intrångsförsök",
                },
                drugLabAssaultCaptureDuration = {
                    description = "Antal sekunder som angripare måste hålla entrén oemotsagda för att ta över laboratoriet eller campern.",
                    label = "Övertagande-duration",
                },
                drugLabAssaultCaptureRadius = {
                    description = "Ingångsområde som används för att räkna angripare och motståndande försvarare.",
                    label = "Erobringsradie",
                },
                drugLabAssaultElectronicDuration = {
                    description = "Antal sekunder som krävs för att hacka ingångssystemet.",
                    label = "Varaktighet för elektroniskt intrång",
                },
                drugLabAssaultEnabled = {
                    description = "Tillåter fraktioner att bryta sig in i och ta över rivaliserande laboratorier och fraktionsdelade husvagnar.",
                    label = "Aktivera övertagande av labb och husvagnar",
                },
                drugLabAssaultExplosiveDuration = {
                    description = "Sekunder som krävs för att spränga ingången med en sprängladdning.",
                    label = "Varaktighet för sprängning",
                },
                drugLabAssaultInteractionDistance = {
                    description = "Maximalt avstånd från laboratoriet eller camp-ingången när ett anfall startas.",
                    label = "Interaktionsavstånd vid ingången",
                },
                drugLabAssaultMechanicalDuration = {
                    description = "Antal sekunder som krävs för att borra upp låset vid ingången.",
                    label = "Varaktighet för mekaniskt intrång",
                },
                drugLabAssaultMinimumDefenders = {
                    description = "Antal online-medlemmar i den försvarande fraktionen som krävs innan en attack får startas.",
                    label = "Minsta antal försvarare",
                },
                drugLabAssaultRequireDuty = {
                    description = "Räknar endast medlemmar i den försvarande fraktionen som för närvarande är i tjänst.",
                    label = "Räkna endast försvarare i tjänst",
                },
                drugProcessingInventoryMetadata = {
                    description = "Lägg till kvalitets- och batchdata till bearbetningsresultat som standard. Enskilda recept kan åsidosätta denna inställning.",
                    label = "Metadata för bearbetningsföremål",
                },
                graffitiItemName = {
                    description = "Föremål i inventariet som krävs för att börja spraya när föremålskravet är aktiverat. Föremålet måste finnas i den aktiva inventariet.",
                    label = "Nödvändigt graffiti-föremål",
                },
                heistCooldownMinutes = {
                    description = "Blockerar samma heist efter att en run med faktiska interaktioner har avslutats och städats upp. Noll avaktiverar cooldownen. Ett oanvänt startfönster utlöser den inte.",
                    label = "Återhämtningstid för rån (minuter)",
                },
                heistCraftingMode = {
                    optionDescriptions = {
                        simple = "Förloppsindikator i fem sekunder. Nödvändiga ingredienser förbrukas vid lyckat resultat.",
                        medium = "Välj ingredienserna i angiven ordning och klara ett tajmningstest per ingrediens.",
                        advanced = "Fullständig montering för recept med en enhetsprofil; annars två precisa tajmningstest per ingrediens.",
                    },
                    description = "Enkel: fem sekunders framstegsmätare. Medium: ingrediensval och timing-kontroller. Maximal: fullständig monteringsprocess; recept utan enhetsprofil använder två exakta timing-kontroller per ingrediens.",
                    label = "Crafting-komplexitet",
                    options = {
                        advanced = "Maximal komplexitet",
                        medium = "Medelhög komplexitet",
                        simple = "Enkel",
                    },
                },
                heistInactivityTimeoutMinutes = {
                    description = "Efter den första interaktionen nollställs denna timer vid varje ny rån-handling. När tiden går ut avslutas rundan och dess världsobjekt rensas. Gäller för nya rundor.",
                    label = "Inaktivitetsgräns för rån (minuter)",
                },
                heistStartTimeoutMinutes = {
                    description = "Tid efter att Start har tryckts in innan interaktion sker vid målet. Utan interaktion återställs runen och kan startas igen. Gäller för nya runs.",
                    label = "Minuter till första heist-interaktion",
                },
                moneywashAccount = {
                    options = {
                        bank = "Banken",
                        black_money = "Smutsiga pengar",
                        money = "Kontanter",
                    },
                },
                moneywashDirtyAccount = {
                    description = "Konto från vilket en spelares svarta pengar dras när en tvättcykel startar.",
                    label = "Insättningskonto",
                },
                moneywashDrawDistance = {
                    description = "Maximalt avstånd i meter där företagsingångar och butiker visas.",
                    label = "Visningsavstånd",
                },
                moneywashEnabled = {
                    description = "Gör organisationens penningtvättsföretag tillgängliga.",
                    label = "Aktivera penningtvätt",
                },
                moneywashFeePercent = {
                    description = "Procentandel som dras av från varje parti innan utbetalning till organisationen.",
                    label = "Serviceavgift (%)",
                },
                moneywashInteractionDistance = {
                    description = "Maximalt avstånd i meter för att använda företagsingångar och butiker.",
                    label = "Interaktionsavstånd",
                },
                npcPoliceAccuracy = {
                    description = "Precision för NPC-poliser från 0 till 100.",
                    label = "Skottprecision",
                },
                npcPoliceArmour = {
                    description = "Skyddsvärde för varje NPC-polis från 0 till 100.",
                    label = "Skyddsväst",
                },
                npcPoliceAtms = {
                    description = "Skicka NPC-polisstöd när ett larm för ATM-rån utlöses.",
                    label = "Stöd under ATM-rån",
                },
                npcPoliceDurationSeconds = {
                    description = "Maximal tid som NPC-poliser förblir utplacerade efter att de spawnats (30–900 sekunder).",
                    label = "Insatsens varaktighet (sekunder)",
                },
                npcPoliceEnabled = {
                    description = "Skicka beväpnade NPC-poliser när ett rån-larm utlöses. Avaktiverat som standard.",
                    label = "Aktivera NPC-polisstöd",
                },
                npcPoliceHeists = {
                    description = "Skicka NPC-polisförstärkning när ett heist-larm utlöses.",
                    label = "Stöd under heists",
                },
                npcPoliceOfficerCount = {
                    description = "Antal beväpnade NPC-poliser som skickas ut per rånvarning (1–8).",
                    label = "Poliser per utryckning",
                },
                npcPoliceResponseDelaySeconds = {
                    description = "Tid mellan rån-larmet och ankomsten av NPC-poliser (0–300 sekunder).",
                    label = "Responstidsfördröjning (sekunder)",
                },
                npcPoliceShops = {
                    description = "Skicka NPC-polisstöd när ett larm för butiksrån utlöses.",
                    label = "Stöd vid butiksrån",
                },
                npcPoliceSpawnDistance = {
                    description = "Målavstånd från rånplatsen där NPC-poliser spawnar (15–150 meter).",
                    label = "Spawn-avstånd (meter)",
                },
                npcPoliceWeapon = {
                    description = "Vapen som varje utryckande NPC-polis är utrustad med. Standard är en pistol.",
                    label = "Tjänstevapen",
                    options = {
                        WEAPON_CARBINERIFLE = "Karbingevär",
                        WEAPON_PISTOL = "Pistoler och pistiller",
                        WEAPON_PUMPSHOTGUN = "Pumpactionhagelgevär",
                    },
                },
                openHeistCreator = {
                    buttonLabel = "Öppna Heist Creator",
                    description = "Öppna Heist Creator och stäng Job Configurator.",
                    label = "Rånskapare",
                    unsavedTooltip = "Spara ändringar först",
                },
                pickpocketAggressionChance = {
                    description = "Oberoende chans att NPC:n attackerar efter ett misslyckat, avbrutet eller utgånget försök.",
                    label = "Motattackschans (%)",
                },
                pickpocketAlertChance = {
                    description = "Oberoende chans att NPC:n rapporterar ett misslyckat, avbrutet eller utgånget försök.",
                    label = "Chans för larm vid fickstöld (%)",
                },
                pickpocketDifficulty = {
                    description = "Styr markörhastighet, hur snabbt målet krymper, sekvenslängd och tillåtna misstag.",
                    label = "Svårighet",
                    options = {
                        easy = "Enkel",
                        expert = "Experter",
                        hard = "Svår",
                        normal = "Normalt",
                    },
                },
                pickpocketDispatchAlways = {
                    description = "Rapportera varje påbörjat fickstöldsförsök en gång, även vid framgång och oavsett sannolikheten för nödsamtal.",
                    label = "Skicka alltid larm",
                },
                pickpocketDispatchDurationSeconds = {
                    description = "Sekunder som rapporten är relevant för dispatch-mottagare.",
                    label = "Dispatch-varaktighet",
                },
                pickpocketDispatchJobs = {
                    description = "Komma-separerade jobbnamn som tar emot nödanrop.",
                    label = "Dispatch-jobb",
                },
                pickpocketDispatchPriority = {
                    description = "Prioritet som skickas oförändrad till dispatch-integrationen.",
                    label = "Dispatch-prioritet",
                },
                pickpocketDispatchRadius = {
                    description = "Ungefärlig larmradie som skickas till dispatch-integrationen.",
                    label = "Dispatch-radie",
                },
                pickpocketEmptyChance = {
                    description = "Chans att NPC:n inte bär på något valbart loot alls.",
                    label = "Chans för tomma fickor (%)",
                },
                pickpocketEnabled = {
                    description = "Låter spelare försöka stjäla från lämpliga, slumpmässiga och nätverksbaserade NPC:er.",
                    label = "Aktivera fickstöld på NPC",
                },
                pickpocketFleeChance = {
                    description = "Oberoende chans att NPC:n springer iväg efter ett misslyckat, avbrutet eller utgånget försök.",
                    label = "NPC flyktchans (%)",
                },
                pickpocketInteractionDistance = {
                    description = "Maximal klienträckvidd; servern validerar med en liten synkroniseringsmarginal.",
                    label = "Interaktionsavstånd",
                },
                pickpocketItems = {
                    description = "Varje rad styr dess chans att dyka upp. Fyra decimaler stöder 0.0001 procent.",
                    itemLabel = "Föremål-chans",
                    label = "Item-loot",
                },
                pickpocketItemsEnabled = {
                    description = "Slår även konfigurerade föremål till det synliga innehållet i fickorna.",
                    label = "Aktivera föremålsstöld",
                },
                pickpocketMaximumLootChoices = {
                    description = "Maximalt antal servergenererade kontant- eller föremålplatser som visas för en NPC.",
                    label = "Maximal synlig loot",
                },
                pickpocketMinigame = {
                    description = "Välj en utmaning eller rotera slumpmässigt mellan alla tre.",
                    label = "Minispel",
                    options = {
                        pulse = "Tryckpuls",
                        random = "Slumpmässig rotation",
                        sequence = "Sekvens av riktningar",
                        timing = "Timing-mätare",
                    },
                },
                pickpocketMoneyMaximum = {
                    description = "Högsta synliga kontantbelopp; hålls automatiskt på eller över miniminivån.",
                    label = "Maximalt kontantbelopp",
                },
                pickpocketMoneyMinimum = {
                    description = "Lägsta servergenererade belopp för en synlig kontantplats.",
                    label = "Minsta kontanter",
                },
                pickpocketRequestCooldownSeconds = {
                    description = "Minsta antal sekunder mellan förfrågningar från en spelare.",
                    label = "Begränsning mellan förfrågningar",
                },
                pickpocketRequireCrimeJob = {
                    description = "Aktiverad: lägger till handlingen endast för registrerade Crime System-roller. Inaktiverad: tar bort den inbyggda radialmenyn och kräver server-export.",
                    label = "Använd Crime-jobb-radialmeny",
                },
                pickpocketRequiredHits = {
                    description = "Basvärde för varje minispel. Värdefull kontanter höjer det stegvis; extremt sällsynta föremål kräver minst åtta träffar.",
                    label = "Minsta antal träffar",
                },
                pickpocketSessionTimeoutSeconds = {
                    description = "Sekunder innan en oavslutad serverutmaning löper ut.",
                    label = "Session-timeout",
                },
                pickpocketTargetCooldownMinutes = {
                    description = "Utlåsning efter avbrutna eller misslyckade försök; framgångsrikt tömda NPC:er förblir otillgängliga.",
                    label = "NPC-nedkylning",
                },
                pvpAdminAce = {
                    description = "ACE-objekt som ger åtkomst till global hantering av PvP-events.",
                    label = "ACE för administratörer",
                },
                pvpArenaReturnSeconds = {
                    description = "Standardåterkomsttid för nya events. Eventledare kan ändra den i surfplattan.",
                    label = "Återkomsttid till arenan",
                },
                pvpArenaWarningPosition = {
                    description = "Ställer in var varningen för att återvända till arenan visas.",
                    label = "Position för arenavarning",
                    options = {
                        bottom_center = "Nere i mitten",
                        bottom_left = "Nere till vänster",
                        bottom_right = "Nere till höger",
                        middle_center = "Skärmens mitt",
                        middle_left = "Mitten till vänster",
                        middle_right = "Mitten till höger",
                        top_center = "Uppe i mitten",
                        top_left = "Uppe till vänster",
                        top_right = "Uppe till höger",
                    },
                },
                pvpArenas = {
                    description = "Skapar cirkulära stridszoner med en observatörspunkt och minst två spawn-punkter för lag.",
                    itemLabel = "Arena",
                    label = "PvP-arenor",
                },
                pvpCountdownPosition = {
                    description = "Styr var nedräkningen för matchstart visas.",
                    label = "Nedräkningsposition",
                    options = {
                        bottom_center = "Nere i mitten",
                        bottom_left = "Nere till vänster",
                        bottom_right = "Nere till höger",
                        middle_center = "Skärmens mitt",
                        middle_left = "Mitten till vänster",
                        middle_right = "Mitten till höger",
                        top_center = "Uppe i mitten",
                        top_left = "Uppe till vänster",
                        top_right = "Uppe till höger",
                    },
                },
                pvpDefaultMode = {
                    description = "Standard spelläge för nya events.",
                    label = "Standard spelläge",
                    options = {
                        free_for_all = "Alla mot alla",
                        last_man_standing = "Siste man stående",
                        team_deathmatch = "Team Deathmatch",
                    },
                },
                pvpDefaultScoreLimit = {
                    description = "Standardantal kills som krävs för att vinna Team Deathmatch eller Free For All.",
                    label = "Standardmål för kills",
                },
                pvpEventsEnabled = {
                    description = "Gör fraktions-PvP-appen och event-runtime tillgänglig.",
                    label = "Aktivera fraktions-PvP-events",
                },
                pvpKillfeedPosition = {
                    description = "Ställer in var de senaste elimineringarna visas.",
                    label = "Killfeed-position",
                    options = {
                        bottom_center = "Nere i mitten",
                        bottom_left = "Nere till vänster",
                        bottom_right = "Nere till höger",
                        middle_center = "Skärmens mitt",
                        middle_left = "Mitten till vänster",
                        middle_right = "Mitten till höger",
                        top_center = "Uppe i mitten",
                        top_left = "Uppe till vänster",
                        top_right = "Uppe till höger",
                    },
                },
                pvpLeaderPermission = {
                    description = "Krav på yrkesbehörighet för att skapa, registrera, starta och hantera fraktionsevenemang.",
                    label = "Behörighet för fraktionsledare",
                },
                pvpMatchDurationMinutes = {
                    description = "Standardlängd i minuter för nya events. Noll inaktiverar tidsgränsen.",
                    label = "Matchens längd",
                },
                pvpMaxHistory = {
                    description = "Maximalt antal avslutade eller avbrutna händelser som visas på surfplattan.",
                    label = "Synlig händelsehistorik",
                },
                pvpMaxRewards = {
                    description = "Maximalt antal kombinerade föremåls-, vapen-, fordon- eller penningbelöningar per event.",
                    label = "Max antal extra belöningar",
                },
                pvpMoneyPermission = {
                    description = "Rollbehörighet krävs för inträdesavgifter och prispengar.",
                    label = "Faktionens finansrättigheter",
                },
                pvpRequestCooldownMs = {
                    description = "Minsta antal millisekunder mellan ändringar av PvP-förfrågningar från en spelare.",
                    label = "Återhämtningstid för handlingar",
                },
                pvpRespawnDelaySeconds = {
                    description = "Sekunder innan en spelare respawnar eller flyttas till observatörsområdet efter död.",
                    label = "Respawn-fördröjning",
                },
                pvpSchedulePollSeconds = {
                    description = "Sekunder mellan upprepande mallar och automatiska startkontroller.",
                    label = "Intervall för schemakontroll",
                },
                pvpScoreboardPosition = {
                    description = "Styr var den kompakta live-resultattavlan visas under fraktionsmatcher.",
                    label = "Position på resultattavla",
                    options = {
                        bottom_center = "Nere i mitten",
                        bottom_left = "Nere till vänster",
                        bottom_right = "Nere till höger",
                        middle_center = "Skärmens mitt",
                        middle_left = "Mitten till vänster",
                        middle_right = "Mitten till höger",
                        top_center = "Uppe i mitten",
                        top_left = "Uppe till vänster",
                        top_right = "Uppe till höger",
                    },
                },
                pvpSoloTestingEnabled = {
                    description = "Låter PvP-administratörer registrera sig och starta manuellt med ett fraktionsmedlem.",
                    label = "Aktivera administratörstester i solo",
                },
                pvpStartCountdownSeconds = {
                    description = "Standardnedräkning för nyskapade händelser. Eventledare kan ändra den på surfplattan.",
                    label = "Starta nedräkning",
                },
                pvpTabletOrder = {
                    description = "Styr var fraktions-PvP-appen visas på surfplattan.",
                    label = "Ordning för tablet-appen",
                },
                shopActiveTimeoutMinutes = {
                    description = "Minuter innan ett övergivet rån misslyckas.",
                    label = "Aktiv tidsgräns",
                },
                shopConsumeDrill = {
                    description = "Förbruka borren efter lyckat öppnande.",
                    label = "Förbruka borr",
                },
                shopConsumeHackItem = {
                    description = "Förbruka hackningsföremålet efter att kassaskåpet har öppnats framgångsrikt.",
                    label = "Förbruka hackningsföremål",
                },
                shopCooldownMinutes = {
                    description = "Minuter i drifttid innan butiken återställs.",
                    label = "Butikens nedkylningstid",
                },
                shopDispatchAlways = {
                    description = "Rapportera varje butiksrån en gång när det börjar, även vid oavbrutna hot och i butiker utan krav på kassör.",
                    label = "Skicka alltid larm",
                },
                shopDispatchDurationSeconds = {
                    description = "Antal sekunder som larmet förblir relevant.",
                    label = "Dispatch-varaktighet",
                },
                shopDispatchJobs = {
                    description = "Komma-separerade mottagar-jobb.",
                    label = "Dispatch-jobb",
                },
                shopDispatchPriority = {
                    description = "Prioritet som skickas till larmcentralen.",
                    label = "Dispatch-prioritet",
                },
                shopDispatchRadius = {
                    description = "Ungefärlig radie för polisvarning.",
                    label = "Dispatch-radie",
                },
                shopDrillDurationSeconds = {
                    description = "Antal sekunder som krävs för att borra upp kassaskåpet.",
                    label = "Tid för kassaskåpborrning",
                },
                shopDrillItem = {
                    description = "Inventarieföremålets ID som krävs för att borra upp butikernas kassaskåp. Ställs in separat från borren för bankomater.",
                    label = "Borrmaskin-item",
                },
                shopDrillItemAmount = {
                    description = "Antal borr-föremål som krävs.",
                    label = "Nödvändig mängd borr",
                },
                shopEnabled = {
                    description = "Aktiverar rån i konfigurerade butiker med personal.",
                    label = "Aktivera butiksrån",
                },
                shopHackItem = {
                    description = "Föremål som krävs för minispelet för att hacka kassaskåp. Aktivera öppningsmetoden separat för varje butik.",
                    label = "Hackningsföremål",
                },
                shopHackItemAmount = {
                    description = "Nödvändig mängd av hackningsföremålet.",
                    label = "Antal hackningsföremål",
                },
                shopIntimidationSeconds = {
                    description = "Antal sekunder som expeditören måste hållas under pistolhot.",
                    label = "Intimideringens varaktighet",
                },
                shopLocations = {
                    description = "En anställd, en kassa och ett valfritt kassaskåp per butik.",
                    itemLabel = "Butik",
                    label = "Butiksplatser",
                },
                shopMinimumPolice = {
                    description = "Antal polismedlemmar i tjänst som krävs för att starta.",
                    label = "Minsta antal polis",
                },
                shopPoliceGroup = {
                    description = "Jobbgrupp som räknas för polis-kravet.",
                    label = "Polisjobbgrupp",
                },
                shopRegisterDurationSeconds = {
                    description = "Antal sekunder som krävs för att tömma en kassa.",
                    label = "Varaktighet för kassa-loot",
                },
                shopRegisterRewardMaximum = {
                    description = "Högsta kassautbetalning.",
                    label = "Maximal kassarbelöning",
                },
                shopRegisterRewardMinimum = {
                    description = "Lägsta kassautbetalning.",
                    label = "Minsta kassa-belöning",
                },
                shopRegisterRewardName = {
                    description = "Valfritt föremål eller kontonamn.",
                    label = "Namn på kassa-belöning",
                },
                shopRegisterRewardSort = {
                    description = "Välj mellan kontanter och föremålet black_money.",
                    label = "Utbetalningstyp för kassa",
                },
                shopRegisters = {
                    description = "Kassapositioner tilldelade via butiks-ID.",
                    itemLabel = "Kassa",
                    label = "Kassor",
                },
                shopSafeLootDurationSeconds = {
                    description = "Antal sekunder som krävs för att ta kontanterna efter att en giltig kod har matats in.",
                    label = "Varaktighet för plundring av kassaskåp",
                },
                shopSafeRewardMaximum = {
                    description = "Högsta säkra utbetalning.",
                    label = "Maximal säker belöning",
                },
                shopSafeRewardMinimum = {
                    description = "Lägsta utbetalning från kassaskåp.",
                    label = "Minsta säkra belöning",
                },
                shopSafeRewardName = {
                    description = "Valfritt föremål eller kontonamn.",
                    label = "Namn på kassabelöning",
                },
                shopSafeRewardSort = {
                    description = "Välj mellan kontanter och föremålet black_money.",
                    label = "Utbetalningstyp för kassaskåp",
                },
                shopThreatGraceSeconds = {
                    description = "Tillåten avbrottstid innan larmet går.",
                    label = "Måltolerans",
                },
                territoryDrugSalesEnabled = {
                    description = "Lyckad gatuförsäljning till NPC:er ger inflytelse till säljarens gäng i det aktuella gatuterritoriet.",
                    label = "NPC-försäljning ger territorieinflytelse",
                },
                atmLocationMode = {
                    label = "Platsläge för bankomater",
                    description = "Hittar världens stödda objekt automatiskt eller använder endast manuellt konfigurerade platser.",
                    options = {
                        automatic = "Automatiskt",
                        manual = "Manuellt",
                    },
                },
                atmPoliceRequirementEnabled = {
                    label = "Kräv poliser i tjänst",
                    description = "Kräver inställt antal poliser i tjänst innan ett bankomatrån kan börja.",
                },
                openDrugCreator = {
                    label = "Drogredigerare",
                    description = "Öppnar Sky Crimes drogredigerare och stänger jobbkonfiguratorn.",
                    buttonLabel = "Öppna drogredigeraren",
                    unsavedTooltip = "Spara först",
                },
                drugCreatorRuntimeDensity = {
                    label = "Driftpanelens täthet",
                    description = "Bestämmer hur kompakt driftpanelen visas i drogredigeraren.",
                    options = {
                        comfortable = "Bekväm",
                        compact = "Kompakt",
                    },
                },
                drugCreatorListDensity = {
                    label = "Listans täthet",
                    description = "Bestämmer hur kompakt redigerarens postlista visas.",
                    options = {
                        comfortable = "Bekväm",
                        compact = "Kompakt",
                    },
                },
                drugCreatorShowEmptyRuntimeLists = {
                    label = "Visa tomma driftlistor",
                    description = "Visar driftpanelens avsnitt även utan poster.",
                },
                drugCreatorHideDisabledEntries = {
                    label = "Dölj inaktiverade poster",
                    description = "Döljer inaktiverade modulposter i drogredigerarens lista.",
                },
                drugCreatorAutoGenerateId = {
                    label = "Skapa ID automatiskt",
                    description = "Skapar ID:n från namn när nya poster läggs till i drogredigeraren.",
                },
                drugCreatorOpenEditorOnModuleChange = {
                    label = "Öppna redigeraren vid modulbyte",
                    description = "Öppnar redigeraren automatiskt när den aktiva modulen byts.",
                },
                drugCreatorSmartDuplicateSuffix = {
                    label = "Automatiskt suffix för kopior",
                    description = "Lägger till ett automatiskt suffix när poster dupliceras i drogredigeraren.",
                },
                drugCreatorAutoSelectRuntimeTargets = {
                    label = "Förvälj spelmål automatiskt",
                    description = "Förväljer tillgängliga laboratorier och partier automatiskt.",
                },
                drugCreatorAttentionOnOpen = {
                    label = "Fokusera på problem vid öppning",
                    description = "Öppnar driftpanelen med fokus på poster som kräver uppmärksamhet.",
                },
                drugActivityHudPosition = {
                    label = "Position för aktivitets-HUD",
                    description = "Dra HUD:en för placering och skörd till önskad position på skärmen.",
                },
                drugInteractionHudPosition = {
                    label = "Position för interaktions-HUD",
                    description = "Dra interaktions-HUD:en för växter, laboratorier och husbilar till önskad position.",
                },
                drugPlantStatusHudPosition = {
                    label = "Position för växtstatus-HUD",
                    description = "Dra den detaljerade växtstatus-HUD:en till önskad position på skärmen.",
                },
                drugSystemEnabled = {
                    label = "Drogsystem",
                    description = "Aktiverar: drogproduktion, redigerardata och spelgränssnitt för detta brottsjobb.",
                },
                drugCreatorAccess = {
                    label = "Åtkomst till drogredigeraren",
                    description = "Bestämmer vem som får öppna den avancerade drogredigeraren.",
                    options = {
                        permission = "Endast med behörighet",
                        job_management = "Jobbhantering",
                        owner_only = "Endast ägare",
                    },
                },
                drugRuntimeEnabled = {
                    label = "Gränssnitt för spelåtgärder",
                    description = "Låter spelare använda laboratorie-, växt-, bearbetnings- och marknadsåtgärder i spelet.",
                },
                drugRuntimePlayerCreateLabs = {
                    label = "Spelares skapande av laboratorier",
                    description = "Låter spelare med systemåtkomst skapa laboratorier från redigerarens mallar utan administratörsrättigheter.",
                },
                drugRuntimeOutdoorPlanting = {
                    label = "Utomhusodling",
                    description = "Tillåter spelares egna utomhusodlingar utanför konfigurerade laboratorier.",
                },
                drugRuntimePublicOutdoorHarvest = {
                    label = "Utomhusskörd av andra spelare",
                    description = "Låter andra spelare skörda utomhusplantor som de inte själva har planterat.",
                },
                drugRuntimeChargeLabPurchase = {
                    label = "Ta betalt för laboratorieköp",
                    description = "Debiterar spelarna det konfigurerade inköpspriset när ett laboratorium skapas.",
                },
                drugRuntimeStrictInventory = {
                    label = "Kontrollera inventariet strikt",
                    description = "Spelåtgärder fortsätter bara om inställda åtgärder för föremål, verktyg och pengar lyckas.",
                },
                drugRuntimeSalePayouts = {
                    label = "Försäljning / Utbetalningar",
                    description = "Betalar spelare när partier eller rutter säljs via marknadssystemet.",
                },
                drugRuntimeSalePayoutAccount = {
                    label = "Utbetalning / Konto",
                    description = "Konto för utbetalningar från drogförsäljning, till exempel black_money.",
                },
                drugRuntimeDispatchEnabled = {
                    label = "Avsändande / Larm",
                    description = "Skickar drogrelaterade riskhändelser till ledningscentralen och inställda polisjobb.",
                },
                drugRuntimeNotifyPoliceJobs = {
                    label = "Polis / Notiser",
                    description = "Meddelar inställda polisjobb när en drogrelaterad riskhändelse utlöser ett polislarm.",
                },
                drugBatchPrefix = {
                    label = "Parti / Prefix",
                    description = "Prefix för ID:n för nya drogpartier.",
                },
                drugTestingKitAccuracy = {
                    label = "Testkit / Precision",
                    description = "Tillåten avvikelse i dolda värden för ett enkelt testkit.",
                },
                drugDecayIntervalMinutes = {
                    label = "Förfall / Intervall",
                    description = "Intervall i minuter för kontroller av minskad färskhet och förorening.",
                },
                drugDefaultPackaging = {
                    label = "Standardvärde / Förpackning",
                    description = "Förpackning för råa eller bearbetade partier som skapas utan angiven förpackningstyp.",
                    options = {
                        loose = "Löst",
                        baggy = "Småpåse",
                        jar = "Burk",
                        vacuum = "Vakuumpåse",
                        brick = "Blockomslag",
                        premium_seal = "Premiumförsegling",
                    },
                },
                drugQualityWeightQuality = {
                    label = "Kvalitet / Vikt",
                    description = "Påverkan på slutlig kvalitet: Grundkvalitet.",
                },
                drugQualityWeightPurity = {
                    label = "Renhet / Vikt",
                    description = "Påverkan på slutlig kvalitet: Renhet.",
                },
                drugQualityWeightFreshness = {
                    label = "Färskhet / Vikt",
                    description = "Påverkan på slutlig kvalitet: Färskhet.",
                },
                drugQualityWeightPotency = {
                    label = "Potens / Vikt",
                    description = "Påverkan på slutlig kvalitet: Potens.",
                },
                drugQualityWeightStability = {
                    label = "Stabilitet / Vikt",
                    description = "Påverkan på slutlig kvalitet: Stabilitet.",
                },
                drugQualityWeightContamination = {
                    label = "Kontaminering / Avdrag",
                    description = "Avdrag från kvalitetsvärdet för förorenade produkter.",
                },
                drugTierGoodMin = {
                    label = "Bra / Nivå / Minimum",
                    description = "Minimipoäng för kvalitetsnivån Bra.",
                },
                drugTierPremiumMin = {
                    label = "Premium / Nivå / Minimum",
                    description = "Minimipoäng för kvalitetsnivån Premium.",
                },
                drugTierTopShelfMin = {
                    label = "Toppkvalitet / Nivå / Minimum",
                    description = "Minimipoäng för kvalitetsnivån Toppkvalitet.",
                },
                drugTierLabGradeMin = {
                    label = "Laboratoriekvalitet / Nivå / Minimum",
                    description = "Minimipoäng för kvalitetsnivån Laboratoriekvalitet.",
                },
                drugBaggyDecayMultiplier = {
                    label = "Småpåse / Förfall",
                    description = "Multiplikator för minskad färskhet / Småpåsar.",
                },
                drugJarDecayMultiplier = {
                    label = "Burk / Förfall",
                    description = "Multiplikator för minskad färskhet / Burkar.",
                },
                drugVacuumDecayMultiplier = {
                    label = "Vakuum / Förfall",
                    description = "Multiplikator för minskad färskhet / Vakuumpåsar.",
                },
                drugPremiumSealPriceMultiplier = {
                    label = "Premiumförsegling / Pris",
                    description = "Multiplikator för Premium / Förseglad produkt / Pris.",
                },
                drugGrowingEnabled = {
                    label = "Odling / Aktiverad",
                    description = "Aktiverar: växttillväxt och skörd.",
                },
                drugEnvironmentSurveyEnabled = {
                    label = "Kontroll av växtplats",
                    description = "När detta är aktiverat väntar fritt planterade växter på en automatisk platskontroll av en administratör. Stäng av för att tillåta tillväxt utan administratörens godkännande.",
                },
                drugGrowthTickMinutes = {
                    label = "Tillväxt / Uppdateringscykel / Minuter",
                    description = "Intervall i minuter för uppdateringar av växttillväxt.",
                },
                drugBaseGrowthPerTick = {
                    label = "Grundvärde / Tillväxt / Per uppdateringscykel",
                    description = "Grundtillväxt före påverkan av sort, utrustning och skötsel.",
                },
                drugWildPlantRespawnMinutes = {
                    label = "Vildväxt / Återkomst",
                    description = "Väntetid i minuter till: Vildväxt / Återkomst.",
                },
                drugWildPlantHighlightEnabled = {
                    label = "Markera vilda växter",
                    description = "Visar konturen på skapade vilda växter när en spelare befinner sig inom markeringsradien.",
                },
                drugWildPlantHighlightDistance = {
                    label = "Markeringsradie för vilda växter",
                    description = "Avstånd i meter runt varje skapad vild växt där dess kontur blir synlig.",
                },
                drugDefaultPlantWater = {
                    label = "Standardvärde / Vatten",
                    description = "Startvärde när en planta skapas: Vatten.",
                },
                drugDefaultPlantFertilizer = {
                    label = "Standardvärde / Gödsel",
                    description = "Startvärde när en planta skapas: Gödsel.",
                },
                drugDefaultPlantHealth = {
                    label = "Standardvärde / Hälsa",
                    description = "Startvärde när en planta skapas: Hälsa.",
                },
                drugDefaultPlantMutationChance = {
                    label = "Standardvärde / Mutationschans",
                    description = "Grundsannolikhet för mutation om sorten inte har ett eget värde.",
                },
                drugHarvestPerfectStart = {
                    label = "Början av optimalt skördefönster",
                    description = "Tillväxtprocent för det optimala skördefönstret: Start.",
                },
                drugHarvestPerfectEnd = {
                    label = "Slutet av optimalt skördefönster",
                    description = "Tillväxtprocent för det optimala skördefönstret: Slut.",
                },
                drugLabsEnabled = {
                    label = "Lab / Aktiverad",
                    description = "Aktiverar: laboratorier och husbilar i spelet.",
                },
                drugMaxLaboratoriesPerCharacter = {
                    label = "Laboratorier per karaktär",
                    description = "Högsta antal köpta eller hyrda fasta laboratorier per ägare. 0 betyder obegränsat; husbilar och delad åtkomst räknas inte.",
                },
                drugMaxLaboratoriesPerFaction = {
                    label = "Laboratorier per fraktion",
                    description = "Högsta antal köpta eller hyrda fasta laboratorier per ägare. 0 betyder obegränsat; husbilar och delad åtkomst räknas inte.",
                },
                drugDefaultRentDays = {
                    label = "Standardvärde / Hyresdagar",
                    description = "Standardvärde för Lab / Hyra / Varaktighet.",
                },
                drugCamperHotVehicleMinutes = {
                    label = "Stulen husbil / Minuter",
                    description = "Hur länge stulna husbilar har förhöjd risk.",
                },
                drugLabRentWarningHours = {
                    label = "Hyra / Varning / Timmar",
                    description = "Antal timmar före laboratoriets hyresförfall då en varning visas.",
                },
                drugLabRentExpiredHeatGain = {
                    label = "Utgången hyra / Polistryck",
                    description = "Ökad polisuppmärksamhet när laboratoriets hyra löper ut.",
                },
                drugCamperMoveCooldownMinutes = {
                    label = "Husvagn / Flytta / Nedkylning",
                    description = "Väntetid i minuter till: Husvagn / Lab / Ny förflyttning.",
                },
                drugLabUpgradeCostMultiplier = {
                    label = "Uppgradering / Kostnad / Multiplikator",
                    description = "Multiplikator för Lab / Nivå / Uppgradering / Priser.",
                },
                drugCamperBaseSlots = {
                    label = "Husvagn / Platser",
                    description = "Standardvärde för husbilslaboratorier / utrustningsplatser.",
                },
                drugCamperBaseStorage = {
                    label = "Husvagn / Förråd",
                    description = "Standardvärde för husbilslaboratorier / Lagringskapacitet.",
                },
                drugCamperBasePower = {
                    label = "Husvagn / Ström",
                    description = "Standardvärde för husbilslaboratorier / Inbyggd strömförsörjning.",
                },
                drugBasementBaseSlots = {
                    label = "Källarlaboratorium / Platser",
                    description = "Standardvärde för källarlaboratorier / utrustningsplatser.",
                },
                drugBasementBaseStorage = {
                    label = "Källarlaboratorium / Förråd",
                    description = "Standardvärde för källarlaboratorier / Lagringskapacitet.",
                },
                drugWarehouseBasePower = {
                    label = "Lager / Ström",
                    description = "Standardvärde för lagerlaboratorier / Inbyggd strömförsörjning.",
                },
                drugPowerEnabled = {
                    label = "Ström / System",
                    description = "Aktiverar: laboratoriets elproduktion, elförbrukning och överbelastningskontroller.",
                },
                drugOverloadGraceSeconds = {
                    label = "Överbelastning / Anståndstid",
                    description = "Sekunder innan en elöverbelastning blir farlig.",
                },
                drugHeatPerKilowatt = {
                    label = "Polistryck / Per kilowatt",
                    description = "Polisuppmärksamhet för laboratoriet från elförbrukningen.",
                },
                drugGeneratorT1Watts = {
                    label = "Generator T1 / Watt",
                    description = "Effekt för generatornivå T1 i watt.",
                },
                drugGeneratorT2Watts = {
                    label = "Generator T2 / Watt",
                    description = "Effekt för generatornivå T2 i watt.",
                },
                drugGeneratorT3Watts = {
                    label = "Generator T3 / Watt",
                    description = "Effekt för generatornivå T3 i watt.",
                },
                drugEquipmentConditionWearMultiplier = {
                    label = "Slitage / Multiplikator",
                    description = "Global multiplikator för Utrustningsslitage / Bearbetning.",
                },
                drugWorkersEnabled = {
                    label = "Arbetare / Aktiverad",
                    description = "Aktiverar: kemister, odlare, förpackare och säkerhetspersonal i droglaboratorier.",
                },
                drugMaxWorkersPerLab = {
                    label = "Maximum / Arbetare / Lab",
                    description = "Maximalt antal arbetare per laboratorium.",
                },
                drugWorkerFatiguePerProcessStep = {
                    label = "Trötthet från bearbetning",
                    description = "Ökad trötthet för Arbetare efter detta arbete: Bearbetningssteg.",
                },
                drugWorkerFatiguePerGrowAction = {
                    label = "Odling / Trötthet",
                    description = "Ökad trötthet för Odlare efter detta arbete: Skörd eller odlingsarbete.",
                },
                drugWorkerRecoveryPerTick = {
                    label = "Arbetare / Återhämtning",
                    description = "Återhämtning av Trötthet vid varje steg: Tillväxtuppdatering.",
                },
                drugMarketEnabled = {
                    label = "Marknad / Aktiverad",
                    description = "Aktiverar: köpare, langare och partiförsäljning.",
                },
                drugMarketBasePriceFallback = {
                    label = "Reservvärde / Baspris",
                    description = "Grundpris för droger utan särskilt konfigurerat pris.",
                },
                drugMarketStreetMultiplier = {
                    label = "Gata / Multiplikator",
                    description = "Global multiplikator för Pris / Gatuförsäljning.",
                },
                drugMarketWholesaleMultiplier = {
                    label = "Grossist / Multiplikator",
                    description = "Global multiplikator för Pris / Grossist / Affärer.",
                },
                drugMarketPremiumMultiplier = {
                    label = "Premium / Multiplikator",
                    description = "Global multiplikator för Pris / Premium / Köpare.",
                },
                drugMarketHeatPerSale = {
                    label = "Polistryck / Försäljning",
                    description = "Grundpolistryck som läggs till laboratoriet när ett parti säljs.",
                },
                drugDistributionTickMinutes = {
                    label = "Distribution / Uppdateringscykel",
                    description = "Intervall i minuter för uppdateringar av langarnas distribution.",
                },
                drugDistributionIntervalMinutes = {
                    label = "Distribution / Intervall",
                    description = "Standardvärde för Återförsäljare / Väntetid före försäljning / Minuter.",
                },
                drugDistributionMaxPerDealer = {
                    label = "Maximum / Återförsäljare / Order",
                    description = "Standardvärde för Återförsäljare / maximalt antal aktiva distributionsuppdrag.",
                },
                drugThreatsEnabled = {
                    label = "Hot / Aktiverad",
                    description = "Aktiverar: minskad polisuppmärksamhet, räder och sabotage i laboratorier.",
                },
                drugThreatTickMinutes = {
                    label = "Hot / Uppdateringscykel",
                    description = "Intervall i minuter för minskad polisuppmärksamhet samt kontroller av räder och sabotage.",
                },
                drugRaidHeatThreshold = {
                    label = "Tröskel för polisuppmärksamhet vid räder",
                    description = "Nödvändigt polistryck i laboratoriet innan detta kan utlösas: Räder.",
                },
                drugSabotageHeatThreshold = {
                    label = "Tröskel för polisuppmärksamhet vid sabotage",
                    description = "Nödvändigt polistryck i laboratoriet innan detta kan utlösas: Sabotage.",
                },
                drugThreatHeatDecay = {
                    label = "Polistryck / Förfall",
                    description = "Minskar polisuppmärksamheten för laboratoriet med detta värde vid varje hotuppdatering.",
                },
                drugRaidChanceAtThreshold = {
                    label = "Sannolikhet för räd",
                    description = "Grundsannolikhet för Räd när motsvarande polistrycksgräns har nåtts.",
                },
                drugSabotageChanceAtThreshold = {
                    label = "Sabotage / Chans",
                    description = "Grundsannolikhet för Sabotage när motsvarande polistrycksgräns har nåtts.",
                },
                drugConsumptionEnabled = {
                    label = "Konsumtion aktiverad",
                    description = "Aktiverar: drogeffekter samt spårning av tolerans och beroende.",
                },
                drugDoseConsumesBatch = {
                    label = "Förbruka partiet vid användning",
                    description = "Tar bort ett förbrukat parti från det aktiva lagret.",
                },
                drugToleranceDecayMinutes = {
                    label = "Tolerans / Förfall",
                    description = "Intervall i minuter för uppdateringar av minskad tolerans.",
                },
                drugAddictionDecayMinutes = {
                    label = "Beroende / Förfall",
                    description = "Intervall i minuter för uppdateringar av minskat beroende.",
                },
                drugPotencyEffectMultiplier = {
                    label = "Potens / Multiplikator",
                    description = "Anger hur mycket potensen ökar effekternas intensitet.",
                },
                drugOverdosePotencyThreshold = {
                    label = "Överdos / Tröskelvärde",
                    description = "Nödvändig substansbelastning innan överdos kan slumpas fram.",
                },
                drugBaseAddictionGain = {
                    label = "Grundvärde / Beroende / vinst",
                    description = "Grundökning av beroende per dos.",
                },
                drugProcessingEnabled = {
                    label = "Bearbetning / Aktiverad",
                    description = "Aktiverar: bearbetningsuppdrag, förpackning och testkit.",
                },
                drugBatchMetadataItemKey = {
                    label = "Parti / Metadata / Nyckel",
                    description = "Metadatanyckel i inventariet som integrationer använder för partidata.",
                },
                drugDefaultProcessDuration = {
                    label = "Standardtid för bearbetning",
                    description = "Standardvärde för Bearbetning / Varaktighet / sekunder / Utan receptets eget värde.",
                },
                drugDefaultFailureRisk = {
                    label = "Standardvärde / Misslyckanderisk",
                    description = "Standardvärde för Bearbetning / Misslyckanderisk / Utan receptets eget värde.",
                },
                drugPackagingDuration = {
                    label = "Förpackningstid",
                    description = "Standardvärde för Förpackning / Varaktighet / sekunder.",
                },
                drugPowerTickSeconds = {
                    label = "Ström / Uppdateringscykel / sekunder",
                    description = "Intervall i sekunder för uppdatering av generatorförbrukning och elmönster.",
                },
                drugPowerSignatureHeatPerHour = {
                    label = "Elförbrukningsmönster / Polistryck / Timme",
                    description = "Polisuppmärksamhet per timme från laboratoriets elförbrukningsmönster.",
                },
                drugPowerOverloadHeatPerHour = {
                    label = "Överbelastning / Polistryck / Timme",
                    description = "Extra polistryck per timme när laboratoriet är överbelastat.",
                },
                drugPowerIdleHeatDecayPerHour = {
                    label = "Idle / Polistryck / Förfall / Timme",
                    description = "Minskad polisuppmärksamhet per timme när laboratoriet saknar aktivt elförbrukningsmönster.",
                },
                drugPowerModeManualMaxLoadPercent = {
                    label = "Manuell / Maximum / Belastning",
                    description = "Värde för energiläget Manuell: Maximum / Belastning.",
                },
                drugPowerModeManualHeatMultiplier = {
                    label = "Manuell / Polistryck / Multiplikator",
                    description = "Värde för energiläget Manuell: Polistryck / Multiplikator.",
                },
                drugPowerModeManualNoiseMultiplier = {
                    label = "Manuell / Buller / Multiplikator",
                    description = "Värde för energiläget Manuell: Buller / Multiplikator.",
                },
                drugPowerModeBalancedMaxLoadPercent = {
                    label = "Balanserad / Maximum / Belastning",
                    description = "Värde för energiläget Balanserad: Maximum / Belastning.",
                },
                drugPowerModeBalancedHeatMultiplier = {
                    label = "Balanserad / Polistryck / Multiplikator",
                    description = "Värde för energiläget Balanserad: Polistryck / Multiplikator.",
                },
                drugPowerModeBalancedNoiseMultiplier = {
                    label = "Balanserad / Buller / Multiplikator",
                    description = "Värde för energiläget Balanserad: Buller / Multiplikator.",
                },
                drugPowerModeStealthMaxLoadPercent = {
                    label = "Smyg / Maximum / Belastning",
                    description = "Värde för energiläget Smyg: Maximum / Belastning.",
                },
                drugPowerModeStealthHeatMultiplier = {
                    label = "Smyg / Polistryck / Multiplikator",
                    description = "Värde för energiläget Smyg: Polistryck / Multiplikator.",
                },
                drugPowerModeStealthNoiseMultiplier = {
                    label = "Smyg / Buller / Multiplikator",
                    description = "Värde för energiläget Smyg: Buller / Multiplikator.",
                },
                drugPowerPrioritySmellControl = {
                    label = "Luktkontroll / Prioritet",
                    description = "Prioritet vid automatisk lastfrånkoppling: Luktkontroll / Utrustning.",
                },
                drugPowerPriorityAirflow = {
                    label = "Ventilation / Prioritet",
                    description = "Prioritet vid automatisk lastfrånkoppling: Ventilation / Utrustning.",
                },
                drugPowerPrioritySecurity = {
                    label = "Säkerhet / Prioritet",
                    description = "Prioritet vid automatisk lastfrånkoppling: Säkerhetsutrustning.",
                },
                drugPowerPriorityGrowing = {
                    label = "Odling / Prioritet",
                    description = "Prioritet vid automatisk lastfrånkoppling: Odling / Utrustning.",
                },
                drugPowerPriorityLight = {
                    label = "Belysning / Prioritet",
                    description = "Prioritet vid automatisk lastfrånkoppling: Belysning / Utrustning.",
                },
                drugPowerPriorityTesting = {
                    label = "Testning / Prioritet",
                    description = "Prioritet vid automatisk lastfrånkoppling: Testning / Utrustning.",
                },
                drugPowerPriorityPackaging = {
                    label = "Förpackning / Prioritet",
                    description = "Prioritet vid automatisk lastfrånkoppling: Förpackning / Utrustning.",
                },
                drugPowerPriorityChemistry = {
                    label = "Kemi / Prioritet",
                    description = "Prioritet vid automatisk lastfrånkoppling: Kemi / Utrustning.",
                },
                drugPowerPriorityHeating = {
                    label = "Uppvärmning / Prioritet",
                    description = "Prioritet vid automatisk lastfrånkoppling: Uppvärmning / Utrustning.",
                },
                drugPowerPriorityPressing = {
                    label = "Pressning / Prioritet",
                    description = "Prioritet vid automatisk lastfrånkoppling: Pressning / Utrustning.",
                },
                drugPowerPriorityGeneral = {
                    label = "Allmänt / Prioritet",
                    description = "Prioritet vid automatisk lastfrånkoppling: Allmän utrustning.",
                },
                drugAdvancedPerformanceInactiveControlIntervalMs = {
                    label = "Prestanda / Inaktiv / Kontroll / Intervall / ms",
                    description = "Driftinställning för Prestanda / Inaktiv / Kontroll / Intervall / ms.",
                },
                drugAdvancedPerformanceInteractionIdleScanIntervalMs = {
                    label = "Prestanda / Interaktion / Idle / Skanningsintervall / ms",
                    description = "Driftinställning för Prestanda / Interaktion / Idle / Skanningsintervall / ms.",
                },
                drugAdvancedPerformanceInteractionPromptIntervalMs = {
                    label = "Prestanda / Interaktion / Interaktionsmeddelande / Intervall / ms",
                    description = "Driftinställning för Prestanda / Interaktion / Interaktionsmeddelande / Intervall / ms.",
                },
                drugAdvancedPerformanceInteractionScanIntervalMs = {
                    label = "Prestanda / Interaktion / Skanningsintervall / ms",
                    description = "Driftinställning för Prestanda / Interaktion / Skanningsintervall / ms.",
                },
                drugAdvancedPerformanceMinimumScanIntervalMs = {
                    label = "Prestanda / Minimum / Skanningsintervall / ms",
                    description = "Driftinställning för Prestanda / Minimum / Skanningsintervall / ms.",
                },
                drugAdvancedPerformanceStreetPedActivationDistance = {
                    label = "Prestanda / Gata / Ped / Aktivering / Avstånd",
                    description = "Driftinställning för Prestanda / Gata / Ped / Aktivering / Avstånd.",
                },
                drugAdvancedPerformanceStreetPedIdleScanIntervalMs = {
                    label = "Prestanda / Gata / Ped / Idle / Skanningsintervall / ms",
                    description = "Driftinställning för Prestanda / Gata / Ped / Idle / Skanningsintervall / ms.",
                },
                drugAdvancedPerformanceStreetPedScanIntervalMs = {
                    label = "Prestanda / Gata / Ped / Skanningsintervall / ms",
                    description = "Driftinställning för Prestanda / Gata / Ped / Skanningsintervall / ms.",
                },
                drugAdvancedPerformanceWorldCachePadding = {
                    label = "Prestanda / Värld / Cache / Extra marginal",
                    description = "Driftinställning för Prestanda / Värld / Cache / Extra marginal.",
                },
                drugAdvancedPerformanceWorldCacheRefreshIntervalMs = {
                    label = "Prestanda / Värld / Cache / Uppdatering / Intervall / ms",
                    description = "Driftinställning för Prestanda / Värld / Cache / Uppdatering / Intervall / ms.",
                },
                drugAdvancedPerformanceWorldIdleIntervalMs = {
                    label = "Prestanda / Värld / Idle / Intervall / ms",
                    description = "Driftinställning för Prestanda / Värld / Idle / Intervall / ms.",
                },
                drugAdvancedDynamicMarketActionCooldownSeconds = {
                    label = "Dynamisk marknad / Återhämtningstid för handlingar / sekunder",
                    description = "Driftinställning för Dynamisk marknad / Återhämtningstid för handlingar / sekunder.",
                },
                drugAdvancedDynamicMarketActionHistoryLimit = {
                    label = "Dynamisk marknad / Handling / Historikgräns",
                    description = "Driftinställning för Dynamisk marknad / Handling / Historikgräns.",
                },
                drugAdvancedDynamicMarketAmountSaturationWeight = {
                    label = "Dynamisk marknad / Mängd / Mättnad / Vikt",
                    description = "Driftinställning för Dynamisk marknad / Mängd / Mättnad / Vikt.",
                },
                drugAdvancedDynamicMarketBaseIntelAccuracy = {
                    label = "Dynamisk marknad / Grundvärde / Informationens noggrannhet",
                    description = "Driftinställning för Dynamisk marknad / Grundvärde / Informationens noggrannhet.",
                },
                drugAdvancedDynamicMarketDefaultAverageQuality = {
                    label = "Dynamisk marknad / Standardvärde / Genomsnitt / Kvalitet",
                    description = "Driftinställning för Dynamisk marknad / Standardvärde / Genomsnitt / Kvalitet.",
                },
                drugAdvancedDynamicMarketDefaultResourceElasticity = {
                    label = "Dynamisk marknad / Standardvärde / Resurs / Elasticitet",
                    description = "Driftinställning för Dynamisk marknad / Standardvärde / Resurs / Elasticitet.",
                },
                drugAdvancedDynamicMarketDemandCenter = {
                    label = "Dynamisk marknad / Efterfrågan / Mittvärde",
                    description = "Driftinställning för Dynamisk marknad / Efterfrågan / Mittvärde.",
                },
                drugAdvancedDynamicMarketDemandPriceImpact = {
                    label = "Dynamisk marknad / Efterfrågan / Pris / Påverkan",
                    description = "Driftinställning för Dynamisk marknad / Efterfrågan / Pris / Påverkan.",
                },
                drugAdvancedDynamicMarketDirectionThreshold = {
                    label = "Dynamisk marknad / Riktning / Tröskelvärde",
                    description = "Driftinställning för Dynamisk marknad / Riktning / Tröskelvärde.",
                },
                drugAdvancedDynamicMarketEnabled = {
                    label = "Dynamisk marknad / Aktiverad",
                    description = "Driftinställning för Dynamisk marknad / Aktiverad.",
                },
                drugAdvancedDynamicMarketEventChance = {
                    label = "Dynamisk marknad / Händelse / Chans",
                    description = "Driftinställning för Dynamisk marknad / Händelse / Chans.",
                },
                drugAdvancedDynamicMarketEventDurationMinutes = {
                    label = "Dynamisk marknad / Händelse / Varaktighet / Minuter",
                    description = "Driftinställning för Dynamisk marknad / Händelse / Varaktighet / Minuter.",
                },
                drugAdvancedDynamicMarketEventMinimumDurationMinutes = {
                    label = "Dynamisk marknad / Händelse / Minimum / Varaktighet / Minuter",
                    description = "Driftinställning för Dynamisk marknad / Händelse / Minimum / Varaktighet / Minuter.",
                },
                drugAdvancedDynamicMarketEventStrengthMaximum = {
                    label = "Dynamisk marknad / Händelse / Styrka / Maximum",
                    description = "Driftinställning för Dynamisk marknad / Händelse / Styrka / Maximum.",
                },
                drugAdvancedDynamicMarketEventStrengthMinimum = {
                    label = "Dynamisk marknad / Händelse / Styrka / Minimum",
                    description = "Driftinställning för Dynamisk marknad / Händelse / Styrka / Minimum.",
                },
                drugAdvancedDynamicMarketEventsCrackdownDemand = {
                    label = "Dynamisk marknad / Händelser / Polisinsats / Efterfrågan",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Polisinsats / Efterfrågan.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPolice = {
                    label = "Dynamisk marknad / Händelser / Polisinsats / Polis",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Polisinsats / Polis.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPrice = {
                    label = "Dynamisk marknad / Händelser / Polisinsats / Pris",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Polisinsats / Pris.",
                },
                drugAdvancedDynamicMarketEventsFestivalDemand = {
                    label = "Dynamisk marknad / Händelser / Festival / Efterfrågan",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Festival / Efterfrågan.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem1 = {
                    label = "Dynamisk marknad / Händelser / Festival / Effekter / 1",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Festival / Effekter / 1.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem2 = {
                    label = "Dynamisk marknad / Händelser / Festival / Effekter / 2",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Festival / Effekter / 2.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem3 = {
                    label = "Dynamisk marknad / Händelser / Festival / Effekter / 3",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Festival / Effekter / 3.",
                },
                drugAdvancedDynamicMarketEventsFestivalPrice = {
                    label = "Dynamisk marknad / Händelser / Festival / Pris",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Festival / Pris.",
                },
                drugAdvancedDynamicMarketEventsFestivalProfilesItem1 = {
                    label = "Dynamisk marknad / Händelser / Festival / Profiler / 1",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Festival / Profiler / 1.",
                },
                drugAdvancedDynamicMarketEventsGangconflictDemand = {
                    label = "Dynamisk marknad / Händelser / Gängkonflikt / Efterfrågan",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Gängkonflikt / Efterfrågan.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPolice = {
                    label = "Dynamisk marknad / Händelser / Gängkonflikt / Polis",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Gängkonflikt / Polis.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPrice = {
                    label = "Dynamisk marknad / Händelser / Gängkonflikt / Pris",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Gängkonflikt / Pris.",
                },
                drugAdvancedDynamicMarketEventsGangconflictProfilesItem1 = {
                    label = "Dynamisk marknad / Händelser / Gängkonflikt / Profiler / 1",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Gängkonflikt / Profiler / 1.",
                },
                drugAdvancedDynamicMarketEventsLabbustDemand = {
                    label = "Dynamisk marknad / Händelser / Laboratorieräd / Efterfrågan",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Laboratorieräd / Efterfrågan.",
                },
                drugAdvancedDynamicMarketEventsLabbustPolice = {
                    label = "Dynamisk marknad / Händelser / Laboratorieräd / Polis",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Laboratorieräd / Polis.",
                },
                drugAdvancedDynamicMarketEventsLabbustPrice = {
                    label = "Dynamisk marknad / Händelser / Laboratorieräd / Pris",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Laboratorieräd / Pris.",
                },
                drugAdvancedDynamicMarketEventsLabbustSupply = {
                    label = "Dynamisk marknad / Händelser / Laboratorieräd / Leverans",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Laboratorieräd / Leverans.",
                },
                drugAdvancedDynamicMarketEventsPartyDemand = {
                    label = "Dynamisk marknad / Händelser / Fest / Efterfrågan",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Fest / Efterfrågan.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem1 = {
                    label = "Dynamisk marknad / Händelser / Fest / Effekter / 1",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Fest / Effekter / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem2 = {
                    label = "Dynamisk marknad / Händelser / Fest / Effekter / 2",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Fest / Effekter / 2.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem3 = {
                    label = "Dynamisk marknad / Händelser / Fest / Effekter / 3",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Fest / Effekter / 3.",
                },
                drugAdvancedDynamicMarketEventsPartyPrice = {
                    label = "Dynamisk marknad / Händelser / Fest / Pris",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Fest / Pris.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem1 = {
                    label = "Dynamisk marknad / Händelser / Fest / Profiler / 1",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Fest / Profiler / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem2 = {
                    label = "Dynamisk marknad / Händelser / Fest / Profiler / 2",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Fest / Profiler / 2.",
                },
                drugAdvancedDynamicMarketEventsShortageDemand = {
                    label = "Dynamisk marknad / Händelser / Brist / Efterfrågan",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Brist / Efterfrågan.",
                },
                drugAdvancedDynamicMarketEventsShortagePrice = {
                    label = "Dynamisk marknad / Händelser / Brist / Pris",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Brist / Pris.",
                },
                drugAdvancedDynamicMarketEventsShortageSupply = {
                    label = "Dynamisk marknad / Händelser / Brist / Leverans",
                    description = "Driftinställning för Dynamisk marknad / Händelser / Brist / Leverans.",
                },
                drugAdvancedDynamicMarketExactIntelReputation = {
                    label = "Dynamisk marknad / Exakt information / Rykte",
                    description = "Driftinställning för Dynamisk marknad / Exakt information / Rykte.",
                },
                drugAdvancedDynamicMarketExactIntelTrust = {
                    label = "Dynamisk marknad / Exakt information / Förtroende",
                    description = "Driftinställning för Dynamisk marknad / Exakt information / Förtroende.",
                },
                drugAdvancedDynamicMarketGlobalZoneLabel = {
                    label = "Dynamisk marknad / Global / Zon / Etikett",
                    description = "Driftinställning för Dynamisk marknad / Global / Zon / Etikett.",
                },
                drugAdvancedDynamicMarketHistoryLimit = {
                    label = "Dynamisk marknad / Historikgräns",
                    description = "Driftinställning för Dynamisk marknad / Historikgräns.",
                },
                drugAdvancedDynamicMarketInitialDemand = {
                    label = "Dynamisk marknad / Startvärde / Efterfrågan",
                    description = "Driftinställning för Dynamisk marknad / Startvärde / Efterfrågan.",
                },
                drugAdvancedDynamicMarketInitialPriceMultiplier = {
                    label = "Dynamisk marknad / Startvärde / Prismultiplikator",
                    description = "Driftinställning för Dynamisk marknad / Startvärde / Prismultiplikator.",
                },
                drugAdvancedDynamicMarketIntelDemandError = {
                    label = "Dynamisk marknad / Underrättelser / Efterfrågan / Fel",
                    description = "Driftinställning för Dynamisk marknad / Underrättelser / Efterfrågan / Fel.",
                },
                drugAdvancedDynamicMarketIntelMaximumAccuracy = {
                    label = "Dynamisk marknad / Underrättelser / Maximum / Precision",
                    description = "Driftinställning för Dynamisk marknad / Underrättelser / Maximum / Precision.",
                },
                drugAdvancedDynamicMarketIntelMinimumAccuracy = {
                    label = "Dynamisk marknad / Underrättelser / Minimum / Precision",
                    description = "Driftinställning för Dynamisk marknad / Underrättelser / Minimum / Precision.",
                },
                drugAdvancedDynamicMarketIntelPoliceError = {
                    label = "Dynamisk marknad / Underrättelser / Polis / Fel",
                    description = "Driftinställning för Dynamisk marknad / Underrättelser / Polis / Fel.",
                },
                drugAdvancedDynamicMarketIntelPriceError = {
                    label = "Dynamisk marknad / Underrättelser / Pris / Fel",
                    description = "Driftinställning för Dynamisk marknad / Underrättelser / Pris / Fel.",
                },
                drugAdvancedDynamicMarketIntelPriceMaximum = {
                    label = "Dynamisk marknad / Underrättelser / Pris / Maximum",
                    description = "Driftinställning för Dynamisk marknad / Underrättelser / Pris / Maximum.",
                },
                drugAdvancedDynamicMarketIntelPriceMinimum = {
                    label = "Dynamisk marknad / Underrättelser / Pris / Minimum",
                    description = "Driftinställning för Dynamisk marknad / Underrättelser / Pris / Minimum.",
                },
                drugAdvancedDynamicMarketIntelReputationWeight = {
                    label = "Dynamisk marknad / Underrättelser / Rykte / Vikt",
                    description = "Driftinställning för Dynamisk marknad / Underrättelser / Rykte / Vikt.",
                },
                drugAdvancedDynamicMarketIntelResourcePriceError = {
                    label = "Dynamisk marknad / Underrättelser / Resurs / Pris / Fel",
                    description = "Driftinställning för Dynamisk marknad / Underrättelser / Resurs / Pris / Fel.",
                },
                drugAdvancedDynamicMarketIntelSaturationError = {
                    label = "Dynamisk marknad / Underrättelser / Mättnad / Fel",
                    description = "Driftinställning för Dynamisk marknad / Underrättelser / Mättnad / Fel.",
                },
                drugAdvancedDynamicMarketIntelSeedBucketSeconds = {
                    label = "Dynamisk marknad / Tidsfönster för informationens slumpfrö / sekunder",
                    description = "Driftinställning för Dynamisk marknad / Tidsfönster för informationens slumpfrö / sekunder.",
                },
                drugAdvancedDynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Dynamisk marknad / Underrättelser / Status / Precision / Tröskelvärde",
                    description = "Driftinställning för Dynamisk marknad / Underrättelser / Status / Precision / Tröskelvärde.",
                },
                drugAdvancedDynamicMarketIntelStatusErrorThreshold = {
                    label = "Dynamisk marknad / Underrättelser / Status / Fel / Tröskelvärde",
                    description = "Driftinställning för Dynamisk marknad / Underrättelser / Status / Fel / Tröskelvärde.",
                },
                drugAdvancedDynamicMarketIntelSupplyError = {
                    label = "Dynamisk marknad / Underrättelser / Leverans / Fel",
                    description = "Driftinställning för Dynamisk marknad / Underrättelser / Leverans / Fel.",
                },
                drugAdvancedDynamicMarketIntelTrustWeight = {
                    label = "Dynamisk marknad / Underrättelser / Förtroende / Vikt",
                    description = "Driftinställning för Dynamisk marknad / Underrättelser / Förtroende / Vikt.",
                },
                drugAdvancedDynamicMarketManipulationCooldownMinutes = {
                    label = "Dynamisk marknad / Manipulation / Nedkylningsminuter",
                    description = "Driftinställning för Dynamisk marknad / Manipulation / Nedkylningsminuter.",
                },
                drugAdvancedDynamicMarketManipulationDemandShift = {
                    label = "Dynamisk marknad / Manipulation / Efterfrågan / Förskjutning",
                    description = "Driftinställning för Dynamisk marknad / Manipulation / Efterfrågan / Förskjutning.",
                },
                drugAdvancedDynamicMarketManipulationDurationMinutes = {
                    label = "Dynamisk marknad / Manipulation / Varaktighet / Minuter",
                    description = "Driftinställning för Dynamisk marknad / Manipulation / Varaktighet / Minuter.",
                },
                drugAdvancedDynamicMarketManipulationHeat = {
                    label = "Dynamisk marknad / Manipulation / Polistryck",
                    description = "Driftinställning för Dynamisk marknad / Manipulation / Polistryck.",
                },
                drugAdvancedDynamicMarketManipulationMinimumBatchAmount = {
                    label = "Dynamisk marknad / Manipulation / Minimum / Parti / Mängd",
                    description = "Driftinställning för Dynamisk marknad / Manipulation / Minimum / Parti / Mängd.",
                },
                drugAdvancedDynamicMarketManipulationPaymentAccount = {
                    label = "Dynamisk marknad / Manipulation / Betalkonto",
                    description = "Driftinställning för Dynamisk marknad / Manipulation / Betalkonto.",
                },
                drugAdvancedDynamicMarketManipulationPrice = {
                    label = "Dynamisk marknad / Manipulation / Pris",
                    description = "Driftinställning för Dynamisk marknad / Manipulation / Pris.",
                },
                drugAdvancedDynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Dynamisk marknad / Manipulation / Zon / Polistryck / Multiplikator",
                    description = "Driftinställning för Dynamisk marknad / Manipulation / Zon / Polistryck / Multiplikator.",
                },
                drugAdvancedDynamicMarketMaximumIntelAgeMinutes = {
                    label = "Dynamisk marknad / Maximum / Informationens ålder / Minuter",
                    description = "Driftinställning för Dynamisk marknad / Maximum / Informationens ålder / Minuter.",
                },
                drugAdvancedDynamicMarketMaximumPriceMultiplier = {
                    label = "Dynamisk marknad / Maximum / Prismultiplikator",
                    description = "Driftinställning för Dynamisk marknad / Maximum / Prismultiplikator.",
                },
                drugAdvancedDynamicMarketMinimumIntelAgeMinutes = {
                    label = "Dynamisk marknad / Minimum / Informationens ålder / Minuter",
                    description = "Driftinställning för Dynamisk marknad / Minimum / Informationens ålder / Minuter.",
                },
                drugAdvancedDynamicMarketMinimumMetricWindowMinutes = {
                    label = "Dynamisk marknad / Minimum / Mätvärde / Tidsfönster / Minuter",
                    description = "Driftinställning för Dynamisk marknad / Minimum / Mätvärde / Tidsfönster / Minuter.",
                },
                drugAdvancedDynamicMarketMinimumPriceMultiplier = {
                    label = "Dynamisk marknad / Minsta pris / Multiplikator",
                    description = "Driftinställning för Dynamisk marknad / Minsta pris / Multiplikator.",
                },
                drugAdvancedDynamicMarketMinimumUpdateMinutes = {
                    label = "Dynamisk marknad / Minimum / Uppdatering / Minuter",
                    description = "Driftinställning för Dynamisk marknad / Minimum / Uppdatering / Minuter.",
                },
                drugAdvancedDynamicMarketPoliceDemandWeight = {
                    label = "Dynamisk marknad / Polis / Efterfrågan / Vikt",
                    description = "Driftinställning för Dynamisk marknad / Polis / Efterfrågan / Vikt.",
                },
                drugAdvancedDynamicMarketPolicePriceImpact = {
                    label = "Dynamisk marknad / Polis / Pris / Påverkan",
                    description = "Driftinställning för Dynamisk marknad / Polis / Pris / Påverkan.",
                },
                drugAdvancedDynamicMarketPoorQualityDemandPenalty = {
                    label = "Dynamisk marknad / Dålig kvalitet / Efterfrågan / Avdrag",
                    description = "Driftinställning för Dynamisk marknad / Dålig kvalitet / Efterfrågan / Avdrag.",
                },
                drugAdvancedDynamicMarketPoorQualityThreshold = {
                    label = "Dynamisk marknad / Dålig kvalitet / Tröskelvärde",
                    description = "Driftinställning för Dynamisk marknad / Dålig kvalitet / Tröskelvärde.",
                },
                drugAdvancedDynamicMarketPremiumQualityDemandBonus = {
                    label = "Dynamisk marknad / Premiumkvalitet / Efterfrågebonus",
                    description = "Driftinställning för Dynamisk marknad / Premiumkvalitet / Efterfrågebonus.",
                },
                drugAdvancedDynamicMarketPremiumQualityThreshold = {
                    label = "Dynamisk marknad / Premiumkvalitet / Tröskelvärde",
                    description = "Driftinställning för Dynamisk marknad / Premiumkvalitet / Tröskelvärde.",
                },
                drugAdvancedDynamicMarketProductionSupplyWeight = {
                    label = "Dynamisk marknad / Produktion / Leverans / Vikt",
                    description = "Driftinställning för Dynamisk marknad / Produktion / Leverans / Vikt.",
                },
                drugAdvancedDynamicMarketProductionWindowMinutes = {
                    label = "Dynamisk marknad / Produktion / Tidsfönster / Minuter",
                    description = "Driftinställning för Dynamisk marknad / Produktion / Tidsfönster / Minuter.",
                },
                drugAdvancedDynamicMarketQualityCenter = {
                    label = "Dynamisk marknad / Kvalitet / Mittvärde",
                    description = "Driftinställning för Dynamisk marknad / Kvalitet / Mittvärde.",
                },
                drugAdvancedDynamicMarketQualityConfidenceImpact = {
                    label = "Dynamisk marknad / Kvalitet / Förtroende / Påverkan",
                    description = "Driftinställning för Dynamisk marknad / Kvalitet / Förtroende / Påverkan.",
                },
                drugAdvancedDynamicMarketQualityRange = {
                    label = "Dynamisk marknad / Kvalitet / Värdeintervall",
                    description = "Driftinställning för Dynamisk marknad / Kvalitet / Värdeintervall.",
                },
                drugAdvancedDynamicMarketRarityBonusMaximum = {
                    label = "Dynamisk marknad / Sällsynthet / Bonus / Maximum",
                    description = "Driftinställning för Dynamisk marknad / Sällsynthet / Bonus / Maximum.",
                },
                drugAdvancedDynamicMarketRegionalGlobalWeight = {
                    label = "Dynamisk marknad / Regional / Global / Vikt",
                    description = "Driftinställning för Dynamisk marknad / Regional / Global / Vikt.",
                },
                drugAdvancedDynamicMarketRegionalLocalWeight = {
                    label = "Dynamisk marknad / Regional / Lokal / Vikt",
                    description = "Driftinställning för Dynamisk marknad / Regional / Lokal / Vikt.",
                },
                drugAdvancedDynamicMarketResourceAliasesDrugpackaging = {
                    label = "Dynamisk marknad / Resurs / Alternativa namn / Droger / Förpackning",
                    description = "Driftinställning för Dynamisk marknad / Resurs / Alternativa namn / Droger / Förpackning.",
                },
                drugAdvancedDynamicMarketResourceAliasesFuelcan = {
                    label = "Dynamisk marknad / Resurs / Alternativa namn / Bränsledunk",
                    description = "Driftinställning för Dynamisk marknad / Resurs / Alternativa namn / Bränsledunk.",
                },
                drugAdvancedDynamicMarketResourceAliasesMachineoil = {
                    label = "Dynamisk marknad / Resurs / Alternativa namn / Maskinolja",
                    description = "Driftinställning för Dynamisk marknad / Resurs / Alternativa namn / Maskinolja.",
                },
                drugAdvancedDynamicMarketResourceAliasesPlantnutrients = {
                    label = "Dynamisk marknad / Resurs / Alternativa namn / Växtnäring",
                    description = "Driftinställning för Dynamisk marknad / Resurs / Alternativa namn / Växtnäring.",
                },
                drugAdvancedDynamicMarketResourceAliasesRepairkit = {
                    label = "Dynamisk marknad / Resurs / Alternativa namn / Reparationskit",
                    description = "Driftinställning för Dynamisk marknad / Resurs / Alternativa namn / Reparationskit.",
                },
                drugAdvancedDynamicMarketResourceDirectionFallThreshold = {
                    label = "Dynamisk marknad / Resurs / Riktning / Nedgång / Tröskelvärde",
                    description = "Driftinställning för Dynamisk marknad / Resurs / Riktning / Nedgång / Tröskelvärde.",
                },
                drugAdvancedDynamicMarketResourceDirectionRiseThreshold = {
                    label = "Dynamisk marknad / Resurs / Riktning / Ökning / Tröskelvärde",
                    description = "Driftinställning för Dynamisk marknad / Resurs / Riktning / Ökning / Tröskelvärde.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterBasePrice = {
                    label = "Dynamisk marknad / Resurser / Kolfilter / Baspris",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Kolfilter / Baspris.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterElasticity = {
                    label = "Dynamisk marknad / Resurser / Kolfilter / Elasticitet",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Kolfilter / Elasticitet.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLabel = {
                    label = "Dynamisk marknad / Resurser / Kolfilter / Etikett",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Kolfilter / Etikett.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem1 = {
                    label = "Dynamisk marknad / Resurser / Kolfilter / Länkade droger / 1",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Kolfilter / Länkade droger / 1.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem2 = {
                    label = "Dynamisk marknad / Resurser / Kolfilter / Länkade droger / 2",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Kolfilter / Länkade droger / 2.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem3 = {
                    label = "Dynamisk marknad / Resurser / Kolfilter / Länkade droger / 3",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Kolfilter / Länkade droger / 3.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorBasePrice = {
                    label = "Dynamisk marknad / Resurser / Kemisk prekursor / Baspris",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Kemisk prekursor / Baspris.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorElasticity = {
                    label = "Dynamisk marknad / Resurser / Kemisk prekursor / Elasticitet",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Kemisk prekursor / Elasticitet.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLabel = {
                    label = "Dynamisk marknad / Resurser / Kemisk prekursor / Etikett",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Kemisk prekursor / Etikett.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem1 = {
                    label = "Dynamisk marknad / Resurser / Kemisk prekursor / Länkade droger / 1",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Kemisk prekursor / Länkade droger / 1.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem2 = {
                    label = "Dynamisk marknad / Resurser / Kemisk prekursor / Länkade droger / 2",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Kemisk prekursor / Länkade droger / 2.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsBasePrice = {
                    label = "Dynamisk marknad / Resurser / Utrustningsdelar / Baspris",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Utrustningsdelar / Baspris.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsElasticity = {
                    label = "Dynamisk marknad / Resurser / Utrustningsdelar / Elasticitet",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Utrustningsdelar / Elasticitet.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsLabel = {
                    label = "Dynamisk marknad / Resurser / Utrustningsdelar / Etikett",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Utrustningsdelar / Etikett.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerBasePrice = {
                    label = "Dynamisk marknad / Resurser / Gödsel / Baspris",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Gödsel / Baspris.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerElasticity = {
                    label = "Dynamisk marknad / Resurser / Gödsel / Elasticitet",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Gödsel / Elasticitet.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLabel = {
                    label = "Dynamisk marknad / Resurser / Gödsel / Etikett",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Gödsel / Etikett.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLinkedDrugsItem1 = {
                    label = "Dynamisk marknad / Resurser / Gödsel / Länkade droger / 1",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Gödsel / Länkade droger / 1.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelBasePrice = {
                    label = "Dynamisk marknad / Resurser / Laboratoriedrivmedel / Baspris",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Laboratoriedrivmedel / Baspris.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelElasticity = {
                    label = "Dynamisk marknad / Resurser / Laboratoriedrivmedel / Elasticitet",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Laboratoriedrivmedel / Elasticitet.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelLabel = {
                    label = "Dynamisk marknad / Resurser / Laboratoriedrivmedel / Etikett",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Laboratoriedrivmedel / Etikett.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagBasePrice = {
                    label = "Dynamisk marknad / Resurser / Förpackningspåse / Baspris",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Förpackningspåse / Baspris.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagElasticity = {
                    label = "Dynamisk marknad / Resurser / Förpackningspåse / Elasticitet",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Förpackningspåse / Elasticitet.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagLabel = {
                    label = "Dynamisk marknad / Resurser / Förpackningspåse / Etikett",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Förpackningspåse / Etikett.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotBasePrice = {
                    label = "Dynamisk marknad / Resurser / Plantkruka / Baspris",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Plantkruka / Baspris.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotElasticity = {
                    label = "Dynamisk marknad / Resurser / Plantkruka / Elasticitet",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Plantkruka / Elasticitet.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLabel = {
                    label = "Dynamisk marknad / Resurser / Plantkruka / Etikett",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Plantkruka / Etikett.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLinkedDrugsItem1 = {
                    label = "Dynamisk marknad / Resurser / Plantkruka / Länkade droger / 1",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Plantkruka / Länkade droger / 1.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedBasePrice = {
                    label = "Dynamisk marknad / Resurser / Cannabisfrö / Baspris",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Cannabisfrö / Baspris.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedElasticity = {
                    label = "Dynamisk marknad / Resurser / Cannabisfrö / Elasticitet",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Cannabisfrö / Elasticitet.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLabel = {
                    label = "Dynamisk marknad / Resurser / Cannabisfrö / Etikett",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Cannabisfrö / Etikett.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLinkedDrugsItem1 = {
                    label = "Dynamisk marknad / Resurser / Cannabisfrö / Länkade droger / 1",
                    description = "Driftinställning för Dynamisk marknad / Resurser / Cannabisfrö / Länkade droger / 1.",
                },
                drugAdvancedDynamicMarketSalesWindowMinutes = {
                    label = "Dynamisk marknad / Försäljning / Tidsfönster / Minuter",
                    description = "Driftinställning för Dynamisk marknad / Försäljning / Tidsfönster / Minuter.",
                },
                drugAdvancedDynamicMarketSaturationDemandWeight = {
                    label = "Dynamisk marknad / Mättnad / Efterfrågan / Vikt",
                    description = "Driftinställning för Dynamisk marknad / Mättnad / Efterfrågan / Vikt.",
                },
                drugAdvancedDynamicMarketSaturationPriceImpact = {
                    label = "Dynamisk marknad / Mättnad / Pris / Påverkan",
                    description = "Driftinställning för Dynamisk marknad / Mättnad / Pris / Påverkan.",
                },
                drugAdvancedDynamicMarketScarcityDemandWeight = {
                    label = "Dynamisk marknad / Brist / Efterfrågan / Vikt",
                    description = "Driftinställning för Dynamisk marknad / Brist / Efterfrågan / Vikt.",
                },
                drugAdvancedDynamicMarketScarcityPriceImpact = {
                    label = "Dynamisk marknad / Brist / Pris / Påverkan",
                    description = "Driftinställning för Dynamisk marknad / Brist / Pris / Påverkan.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsDecember = {
                    label = "Dynamisk marknad / Årstid / Slut / Månader / December",
                    description = "Driftinställning för Dynamisk marknad / Årstid / Slut / Månader / December.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSpring = {
                    label = "Dynamisk marknad / Årstid / Slut / Månader / Vår",
                    description = "Driftinställning för Dynamisk marknad / Årstid / Slut / Månader / Vår.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSummer = {
                    label = "Dynamisk marknad / Årstid / Slut / Månader / Sommar",
                    description = "Driftinställning för Dynamisk marknad / Årstid / Slut / Månader / Sommar.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsWinter = {
                    label = "Dynamisk marknad / Årstid / Slut / Månader / Vinter",
                    description = "Driftinställning för Dynamisk marknad / Årstid / Slut / Månader / Vinter.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersAutumn = {
                    label = "Dynamisk marknad / Årstid / Multiplikatorer / Höst",
                    description = "Driftinställning för Dynamisk marknad / Årstid / Multiplikatorer / Höst.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSpring = {
                    label = "Dynamisk marknad / Årstid / Multiplikatorer / Vår",
                    description = "Driftinställning för Dynamisk marknad / Årstid / Multiplikatorer / Vår.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSummer = {
                    label = "Dynamisk marknad / Årstid / Multiplikatorer / Sommar",
                    description = "Driftinställning för Dynamisk marknad / Årstid / Multiplikatorer / Sommar.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersWinter = {
                    label = "Dynamisk marknad / Årstid / Multiplikatorer / Vinter",
                    description = "Driftinställning för Dynamisk marknad / Årstid / Multiplikatorer / Vinter.",
                },
                drugAdvancedDynamicMarketShortageRumorThreshold = {
                    label = "Dynamisk marknad / Brist / Rykte / Tröskelvärde",
                    description = "Driftinställning för Dynamisk marknad / Brist / Rykte / Tröskelvärde.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHighDemand = {
                    label = "Dynamisk marknad / Status / Tröskelvärden / Hög efterfrågan",
                    description = "Driftinställning för Dynamisk marknad / Status / Tröskelvärden / Hög efterfrågan.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHot = {
                    label = "Dynamisk marknad / Status / Tröskelvärden / Efterlyst",
                    description = "Driftinställning för Dynamisk marknad / Status / Tröskelvärden / Efterlyst.",
                },
                drugAdvancedDynamicMarketStatusThresholdsLowDemand = {
                    label = "Dynamisk marknad / Status / Tröskelvärden / Låg efterfrågan",
                    description = "Driftinställning för Dynamisk marknad / Status / Tröskelvärden / Låg efterfrågan.",
                },
                drugAdvancedDynamicMarketStatusThresholdsSaturated = {
                    label = "Dynamisk marknad / Status / Tröskelvärden / Mättad",
                    description = "Driftinställning för Dynamisk marknad / Status / Tröskelvärden / Mättad.",
                },
                drugAdvancedDynamicMarketTargetSupply = {
                    label = "Dynamisk marknad / Mål / Leverans",
                    description = "Driftinställning för Dynamisk marknad / Mål / Leverans.",
                },
                drugAdvancedDynamicMarketTrendChance = {
                    label = "Dynamisk marknad / Trend / Chans",
                    description = "Driftinställning för Dynamisk marknad / Trend / Chans.",
                },
                drugAdvancedDynamicMarketTrendDurationMinutes = {
                    label = "Dynamisk marknad / Trend / Varaktighet / Minuter",
                    description = "Driftinställning för Dynamisk marknad / Trend / Varaktighet / Minuter.",
                },
                drugAdvancedDynamicMarketTrendMaximumStrength = {
                    label = "Dynamisk marknad / Trend / Maximum / Styrka",
                    description = "Driftinställning för Dynamisk marknad / Trend / Maximum / Styrka.",
                },
                drugAdvancedDynamicMarketTrendMinimumStrength = {
                    label = "Dynamisk marknad / Trend / Minimum / Styrka",
                    description = "Driftinställning för Dynamisk marknad / Trend / Minimum / Styrka.",
                },
                drugAdvancedDynamicMarketUpdateMinutes = {
                    label = "Dynamisk marknad / Uppdatering / Minuter",
                    description = "Driftinställning för Dynamisk marknad / Uppdatering / Minuter.",
                },
                drugAdvancedDynamicMarketVolatilityMaximum = {
                    label = "Dynamisk marknad / Prisvolatilitet / Maximum",
                    description = "Driftinställning för Dynamisk marknad / Prisvolatilitet / Maximum.",
                },
                drugAdvancedDynamicMarketVolatilityMinimum = {
                    label = "Dynamisk marknad / Prisvolatilitet / Minimum",
                    description = "Driftinställning för Dynamisk marknad / Prisvolatilitet / Minimum.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersCold = {
                    label = "Dynamisk marknad / Väder / Multiplikatorer / Kyla",
                    description = "Driftinställning för Dynamisk marknad / Väder / Multiplikatorer / Kyla.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersHeatwave = {
                    label = "Dynamisk marknad / Väder / Multiplikatorer / Värmebölja",
                    description = "Driftinställning för Dynamisk marknad / Väder / Multiplikatorer / Värmebölja.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersNormal = {
                    label = "Dynamisk marknad / Väder / Multiplikatorer / Normal",
                    description = "Driftinställning för Dynamisk marknad / Väder / Multiplikatorer / Normal.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersRain = {
                    label = "Dynamisk marknad / Väder / Multiplikatorer / Regn",
                    description = "Driftinställning för Dynamisk marknad / Väder / Multiplikatorer / Regn.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersStorm = {
                    label = "Dynamisk marknad / Väder / Multiplikatorer / Storm",
                    description = "Driftinställning för Dynamisk marknad / Väder / Multiplikatorer / Storm.",
                },
                drugAdvancedDynamicMarketWeatherState = {
                    label = "Dynamisk marknad / Väder / Status",
                    description = "Driftinställning för Dynamisk marknad / Väder / Status.",
                },
                drugAdvancedHeatActionCooldownSeconds = {
                    label = "Polisuppmärksamhet och risk / Återhämtningstid för handlingar / sekunder",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Återhämtningstid för handlingar / sekunder.",
                },
                drugAdvancedHeatActivityRiskWeightsAmount = {
                    label = "Polisuppmärksamhet och risk / Aktivitet / Risk / Viktningar / Mängd",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Aktivitet / Risk / Viktningar / Mängd.",
                },
                drugAdvancedHeatActivityRiskWeightsDurationMinutes = {
                    label = "Polisuppmärksamhet och risk / Aktivitet / Risk / Viktningar / Varaktighet / Minuter",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Aktivitet / Risk / Viktningar / Varaktighet / Minuter.",
                },
                drugAdvancedHeatActivityRiskWeightsPolicePressure = {
                    label = "Polisuppmärksamhet och risk / Aktivitet / Risk / Viktningar / Polistryck",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Aktivitet / Risk / Viktningar / Polistryck.",
                },
                drugAdvancedHeatActivityRiskWeightsReputation = {
                    label = "Polisuppmärksamhet och risk / Aktivitet / Risk / Viktningar / Rykte",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Aktivitet / Risk / Viktningar / Rykte.",
                },
                drugAdvancedHeatActivityRiskWeightsSecurity = {
                    label = "Polisuppmärksamhet och risk / Aktivitet / Risk / Viktningar / Säkerhet",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Aktivitet / Risk / Viktningar / Säkerhet.",
                },
                drugAdvancedHeatAggressiveHeatMultiplier = {
                    label = "Polisuppmärksamhet och risk / Aggressivt arbetssätt / Polistryck / Multiplikator",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Aggressivt arbetssätt / Polistryck / Multiplikator.",
                },
                drugAdvancedHeatBurnerBurnThreshold = {
                    label = "Polisuppmärksamhet och risk / Engångstelefon / Avslöjande / Tröskelvärde",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Engångstelefon / Avslöjande / Tröskelvärde.",
                },
                drugAdvancedHeatBurnerHeatPerWholesale = {
                    label = "Polisuppmärksamhet och risk / Engångstelefon / Polistryck / Per grossistaffär",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Engångstelefon / Polistryck / Per grossistaffär.",
                },
                drugAdvancedHeatBurnerPhoneItem = {
                    label = "Polisuppmärksamhet och risk / Engångsmobil / Föremål",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Engångsmobil / Föremål.",
                },
                drugAdvancedHeatCamperOperationalHeatMultiplier = {
                    label = "Polisuppmärksamhet och risk / Husbil i drift / Polistryck / Multiplikator",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Husbil i drift / Polistryck / Multiplikator.",
                },
                drugAdvancedHeatCamperOperationalHeatThreshold = {
                    label = "Polisuppmärksamhet och risk / Husbil i drift / Polistryck / Tröskelvärde",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Husbil i drift / Polistryck / Tröskelvärde.",
                },
                drugAdvancedHeatCamperParkedHeat = {
                    label = "Polisuppmärksamhet och risk / Parkerad husbil / Polistryck",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Parkerad husbil / Polistryck.",
                },
                drugAdvancedHeatContaminatedHeatMultiplier = {
                    label = "Polisuppmärksamhet och risk / Förorening / Polistryck / Multiplikator",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Förorening / Polistryck / Multiplikator.",
                },
                drugAdvancedHeatContaminatedThreshold = {
                    label = "Polisuppmärksamhet och risk / Förorening / Tröskelvärde",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Förorening / Tröskelvärde.",
                },
                drugAdvancedHeatCultivationFreePlants = {
                    label = "Polisuppmärksamhet och risk / Odling / Plantor utan extra risk",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Odling / Plantor utan extra risk.",
                },
                drugAdvancedHeatCultivationHeatPerPlant = {
                    label = "Polisuppmärksamhet och risk / Odling / Polistryck / Per planta",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Odling / Polistryck / Per planta.",
                },
                drugAdvancedHeatDealerHiddenMinutes = {
                    label = "Polisuppmärksamhet och risk / Återförsäljare / dolt / Minuter",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Återförsäljare / dolt / Minuter.",
                },
                drugAdvancedHeatDecayPerTickBatch = {
                    label = "Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Parti",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Parti.",
                },
                drugAdvancedHeatDecayPerTickCamper = {
                    label = "Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Husvagn",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Husvagn.",
                },
                drugAdvancedHeatDecayPerTickDealer = {
                    label = "Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Återförsäljare",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Återförsäljare.",
                },
                drugAdvancedHeatDecayPerTickFaction = {
                    label = "Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Fraktion",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Fraktion.",
                },
                drugAdvancedHeatDecayPerTickHub = {
                    label = "Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Distributionscentral",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Distributionscentral.",
                },
                drugAdvancedHeatDecayPerTickLab = {
                    label = "Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Lab",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Lab.",
                },
                drugAdvancedHeatDecayPerTickPlayer = {
                    label = "Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Spelare",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Spelare.",
                },
                drugAdvancedHeatDecayPerTickRoute = {
                    label = "Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Rutt",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Rutt.",
                },
                drugAdvancedHeatDecayPerTickZone = {
                    label = "Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Zon",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Förfall / Per uppdateringscykel / Zon.",
                },
                drugAdvancedHeatEnabled = {
                    label = "Polisuppmärksamhet och risk / Aktiverad",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Aktiverad.",
                },
                drugAdvancedHeatEnforcementHeatCritical = {
                    label = "Polisuppmärksamhet och risk / Polisnärvaro / Polistryck / Kritisk",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Polisnärvaro / Polistryck / Kritisk.",
                },
                drugAdvancedHeatEnforcementHeatHigh = {
                    label = "Polisuppmärksamhet och risk / Polisnärvaro / Polistryck / Hög",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Polisnärvaro / Polistryck / Hög.",
                },
                drugAdvancedHeatEnforcementHeatLow = {
                    label = "Polisuppmärksamhet och risk / Polisnärvaro / Polistryck / Låg",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Polisnärvaro / Polistryck / Låg.",
                },
                drugAdvancedHeatEnforcementHeatMedium = {
                    label = "Polisuppmärksamhet och risk / Polisnärvaro / Polistryck / Medium",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Polisnärvaro / Polistryck / Medium.",
                },
                drugAdvancedHeatEnforcementMultipliersBatch = {
                    label = "Polisuppmärksamhet och risk / Polisnärvaro / Multiplikatorer / Parti",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Polisnärvaro / Multiplikatorer / Parti.",
                },
                drugAdvancedHeatEnforcementMultipliersFaction = {
                    label = "Polisuppmärksamhet och risk / Polisnärvaro / Multiplikatorer / Fraktion",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Polisnärvaro / Multiplikatorer / Fraktion.",
                },
                drugAdvancedHeatEnforcementMultipliersZone = {
                    label = "Polisuppmärksamhet och risk / Polisnärvaro / Multiplikatorer / Zon",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Polisnärvaro / Multiplikatorer / Zon.",
                },
                drugAdvancedHeatEntityTypesBatch = {
                    label = "Polisuppmärksamhet och risk / Spelobjekt / Typer / Parti",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Spelobjekt / Typer / Parti.",
                },
                drugAdvancedHeatEntityTypesCamper = {
                    label = "Polisuppmärksamhet och risk / Spelobjekt / Typer / Husvagn",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Spelobjekt / Typer / Husvagn.",
                },
                drugAdvancedHeatEntityTypesDealer = {
                    label = "Polisuppmärksamhet och risk / Spelobjekt / Typer / Återförsäljare",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Spelobjekt / Typer / Återförsäljare.",
                },
                drugAdvancedHeatEntityTypesFaction = {
                    label = "Polisuppmärksamhet och risk / Spelobjekt / Typer / Fraktion",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Spelobjekt / Typer / Fraktion.",
                },
                drugAdvancedHeatEntityTypesHub = {
                    label = "Polisuppmärksamhet och risk / Spelobjekt / Typer / Distributionscentral",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Spelobjekt / Typer / Distributionscentral.",
                },
                drugAdvancedHeatEntityTypesLab = {
                    label = "Polisuppmärksamhet och risk / Spelobjekt / Typer / Lab",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Spelobjekt / Typer / Lab.",
                },
                drugAdvancedHeatEntityTypesPlayer = {
                    label = "Polisuppmärksamhet och risk / Spelobjekt / Typer / Spelare",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Spelobjekt / Typer / Spelare.",
                },
                drugAdvancedHeatEntityTypesRoute = {
                    label = "Polisuppmärksamhet och risk / Spelobjekt / Typer / Rutt",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Spelobjekt / Typer / Rutt.",
                },
                drugAdvancedHeatEntityTypesZone = {
                    label = "Polisuppmärksamhet och risk / Spelobjekt / Typer / Zon",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Spelobjekt / Typer / Zon.",
                },
                drugAdvancedHeatEventCooldownMinutes = {
                    label = "Polisuppmärksamhet och risk / Händelse / Nedkylningsminuter",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Händelse / Nedkylningsminuter.",
                },
                drugAdvancedHeatEventHistoryLimit = {
                    label = "Polisuppmärksamhet och risk / Händelse / Historikgräns",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Händelse / Historikgräns.",
                },
                drugAdvancedHeatLabHeatSyncThreshold = {
                    label = "Polisuppmärksamhet och risk / Lab / Polistryck / Synkronisering / Tröskelvärde",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Lab / Polistryck / Synkronisering / Tröskelvärde.",
                },
                drugAdvancedHeatLayLowCooldownMinutes = {
                    label = "Polisuppmärksamhet och risk / Ligga lågt / Nedkylningsminuter",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Ligga lågt / Nedkylningsminuter.",
                },
                drugAdvancedHeatLayLowIdleMinutes = {
                    label = "Polisuppmärksamhet och risk / Ligga lågt / Idle / Minuter",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Ligga lågt / Idle / Minuter.",
                },
                drugAdvancedHeatLayLowReduction = {
                    label = "Polisuppmärksamhet och risk / Ligga lågt / Minskning",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Ligga lågt / Minskning.",
                },
                drugAdvancedHeatLockdownMinutes = {
                    label = "Polisuppmärksamhet och risk / Nedstängning / Minuter",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Nedstängning / Minuter.",
                },
                drugAdvancedHeatMinimumDurationMinutes = {
                    label = "Polisuppmärksamhet och risk / Minimum / Varaktighet / Minuter",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Minimum / Varaktighet / Minuter.",
                },
                drugAdvancedHeatMinimumEventCooldownSeconds = {
                    label = "Polisuppmärksamhet och risk / Minimum / Händelse / Nedkylning (sekunder)",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Minimum / Händelse / Nedkylning (sekunder).",
                },
                drugAdvancedHeatMinimumIdleSeconds = {
                    label = "Polisuppmärksamhet och risk / Minimum / Idle / sekunder",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Minimum / Idle / sekunder.",
                },
                drugAdvancedHeatProcessingHeatMultiplier = {
                    label = "Polisuppmärksamhet och risk / Bearbetning / Polistryck / Multiplikator",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Bearbetning / Polistryck / Multiplikator.",
                },
                drugAdvancedHeatRiskWeightsBatch = {
                    label = "Polisuppmärksamhet och risk / Risk / Viktningar / Parti",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Risk / Viktningar / Parti.",
                },
                drugAdvancedHeatRiskWeightsCamper = {
                    label = "Polisuppmärksamhet och risk / Risk / Viktningar / Husvagn",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Risk / Viktningar / Husvagn.",
                },
                drugAdvancedHeatRiskWeightsDealer = {
                    label = "Polisuppmärksamhet och risk / Risk / Viktningar / Återförsäljare",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Risk / Viktningar / Återförsäljare.",
                },
                drugAdvancedHeatRiskWeightsFaction = {
                    label = "Polisuppmärksamhet och risk / Risk / Viktningar / Fraktion",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Risk / Viktningar / Fraktion.",
                },
                drugAdvancedHeatRiskWeightsHub = {
                    label = "Polisuppmärksamhet och risk / Risk / Viktningar / Distributionscentral",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Risk / Viktningar / Distributionscentral.",
                },
                drugAdvancedHeatRiskWeightsLab = {
                    label = "Polisuppmärksamhet och risk / Risk / Viktningar / Lab",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Risk / Viktningar / Lab.",
                },
                drugAdvancedHeatRiskWeightsPlayer = {
                    label = "Polisuppmärksamhet och risk / Risk / Viktningar / Spelare",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Risk / Viktningar / Spelare.",
                },
                drugAdvancedHeatRiskWeightsRoute = {
                    label = "Polisuppmärksamhet och risk / Risk / Viktningar / Rutt",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Risk / Viktningar / Rutt.",
                },
                drugAdvancedHeatRiskWeightsZone = {
                    label = "Polisuppmärksamhet och risk / Risk / Viktningar / Zon",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Risk / Viktningar / Zon.",
                },
                drugAdvancedHeatRotateBurnerReduction = {
                    label = "Polisuppmärksamhet och risk / Byt engångstelefon / Minskning",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Byt engångstelefon / Minskning.",
                },
                drugAdvancedHeatRouteControlMinutes = {
                    label = "Polisuppmärksamhet och risk / Rutt / Kontroll / Minuter",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Rutt / Kontroll / Minuter.",
                },
                drugAdvancedHeatSaleHeatBatch = {
                    label = "Polisuppmärksamhet och risk / Försäljning / Polistryck / Parti",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Försäljning / Polistryck / Parti.",
                },
                drugAdvancedHeatSaleHeatCamper = {
                    label = "Polisuppmärksamhet och risk / Försäljning / Polistryck / Husvagn",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Försäljning / Polistryck / Husvagn.",
                },
                drugAdvancedHeatSaleHeatDealer = {
                    label = "Polisuppmärksamhet och risk / Försäljning / Polistryck / Återförsäljare",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Försäljning / Polistryck / Återförsäljare.",
                },
                drugAdvancedHeatSaleHeatFaction = {
                    label = "Polisuppmärksamhet och risk / Försäljning / Polistryck / Fraktion",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Försäljning / Polistryck / Fraktion.",
                },
                drugAdvancedHeatSaleHeatHub = {
                    label = "Polisuppmärksamhet och risk / Försäljning / Polistryck / Distributionscentral",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Försäljning / Polistryck / Distributionscentral.",
                },
                drugAdvancedHeatSaleHeatLab = {
                    label = "Polisuppmärksamhet och risk / Försäljning / Polistryck / Lab",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Försäljning / Polistryck / Lab.",
                },
                drugAdvancedHeatSaleHeatPlayer = {
                    label = "Polisuppmärksamhet och risk / Försäljning / Polistryck / Spelare",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Försäljning / Polistryck / Spelare.",
                },
                drugAdvancedHeatSaleHeatRoute = {
                    label = "Polisuppmärksamhet och risk / Försäljning / Polistryck / Rutt",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Försäljning / Polistryck / Rutt.",
                },
                drugAdvancedHeatSaleHeatZone = {
                    label = "Polisuppmärksamhet och risk / Försäljning / Polistryck / Zon",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Försäljning / Polistryck / Zon.",
                },
                drugAdvancedHeatThresholdsCritical = {
                    label = "Polisuppmärksamhet och risk / Tröskelvärden / Kritisk",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Tröskelvärden / Kritisk.",
                },
                drugAdvancedHeatThresholdsHigh = {
                    label = "Polisuppmärksamhet och risk / Tröskelvärden / Hög",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Tröskelvärden / Hög.",
                },
                drugAdvancedHeatThresholdsLockdown = {
                    label = "Polisuppmärksamhet och risk / Tröskelvärden / Nedstängning",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Tröskelvärden / Nedstängning.",
                },
                drugAdvancedHeatThresholdsLow = {
                    label = "Polisuppmärksamhet och risk / Tröskelvärden / Låg",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Tröskelvärden / Låg.",
                },
                drugAdvancedHeatThresholdsMedium = {
                    label = "Polisuppmärksamhet och risk / Tröskelvärden / Medium",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Tröskelvärden / Medium.",
                },
                drugAdvancedHeatTickMinutes = {
                    label = "Polisuppmärksamhet och risk / Uppdateringscykel / Minuter",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Uppdateringscykel / Minuter.",
                },
                drugAdvancedHeatWholesaleHeatMultiplier = {
                    label = "Polisuppmärksamhet och risk / Grossist / Polistryck / Multiplikator",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Grossist / Polistryck / Multiplikator.",
                },
                drugAdvancedHeatWorkerLeakAlertRadius = {
                    label = "Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Larmradie",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Larmradie.",
                },
                drugAdvancedHeatWorkerLeakBaseChance = {
                    label = "Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Grundvärde / Chans",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Grundvärde / Chans.",
                },
                drugAdvancedHeatWorkerLeakFactionMultiplier = {
                    label = "Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Fraktion / Multiplikator",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Fraktion / Multiplikator.",
                },
                drugAdvancedHeatWorkerLeakHighSeverityThreshold = {
                    label = "Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Hög / Allvarlighetsgrad / Tröskelvärde",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Hög / Allvarlighetsgrad / Tröskelvärde.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Lojalitet / Chans / Multiplikator",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Lojalitet / Chans / Multiplikator.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyThreshold = {
                    label = "Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Lojalitet / Tröskelvärde",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Lojalitet / Tröskelvärde.",
                },
                drugAdvancedHeatWorkerLeakMaximumChance = {
                    label = "Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Maximum / Chans",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Maximum / Chans.",
                },
                drugAdvancedHeatWorkerLeakMinimumCooldownSeconds = {
                    label = "Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Minimum / Nedkylning (sekunder)",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Minimum / Nedkylning (sekunder).",
                },
                drugAdvancedHeatWorkerLeakRouteMultiplier = {
                    label = "Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Rutt / Multiplikator",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Rutt / Multiplikator.",
                },
                drugAdvancedHeatWorkerLeakStrengthMaximum = {
                    label = "Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Styrka / Maximum",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Styrka / Maximum.",
                },
                drugAdvancedHeatWorkerLeakStrengthMinimum = {
                    label = "Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Styrka / Minimum",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Styrka / Minimum.",
                },
                drugAdvancedHeatWorkerLeakStrengthMultiplier = {
                    label = "Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Styrka / Multiplikator",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Styrka / Multiplikator.",
                },
                drugAdvancedHeatWorkerLeakStressChanceMultiplier = {
                    label = "Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Stress / Chans / Multiplikator",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Stress / Chans / Multiplikator.",
                },
                drugAdvancedHeatWorkerLeakStressThreshold = {
                    label = "Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Stress / Tröskelvärde",
                    description = "Driftinställning för Polisuppmärksamhet och risk / Arbetare / Informationsläcka / Stress / Tröskelvärde.",
                },
                drugAdvancedContactNetworkActionCooldownSeconds = {
                    label = "Kontaktnätverk / Återhämtningstid för handlingar / sekunder",
                    description = "Driftinställning för Kontaktnätverk / Återhämtningstid för handlingar / sekunder.",
                },
                drugAdvancedContactNetworkActiveHotspotCount = {
                    label = "Kontaktnätverk / Antal aktiva platser",
                    description = "Driftinställning för Kontaktnätverk / Antal aktiva platser.",
                },
                drugAdvancedContactNetworkBurnerHintTrust = {
                    label = "Kontaktnätverk / Burner-tips / Förtroende",
                    description = "Driftinställning för Kontaktnätverk / Burner-tips / Förtroende.",
                },
                drugAdvancedContactNetworkBurnerOfferMaximumMultiplier = {
                    label = "Kontaktnätverk / Engångstelefon / Erbjudande / Maximum / Multiplikator",
                    description = "Driftinställning för Kontaktnätverk / Engångstelefon / Erbjudande / Maximum / Multiplikator.",
                },
                drugAdvancedContactNetworkBurnerOfferMinimumMultiplier = {
                    label = "Kontaktnätverk / Engångstelefon / Erbjudande / Minimum / Multiplikator",
                    description = "Driftinställning för Kontaktnätverk / Engångstelefon / Erbjudande / Minimum / Multiplikator.",
                },
                drugAdvancedContactNetworkBuyerCooldownMinutes = {
                    label = "Kontaktnätverk / Köpare / Nedkylningsminuter",
                    description = "Driftinställning för Kontaktnätverk / Köpare / Nedkylningsminuter.",
                },
                drugAdvancedContactNetworkBuyerDeliveryDistance = {
                    label = "Kontaktnätverk / Köpare / Inlämningsavstånd",
                    description = "Driftinställning för Kontaktnätverk / Köpare / Inlämningsavstånd.",
                },
                drugAdvancedContactNetworkBuyerPremiumSuccessScore = {
                    label = "Kontaktnätverk / Köpare / Premium / Framgång / Poäng",
                    description = "Driftinställning för Kontaktnätverk / Köpare / Premium / Framgång / Poäng.",
                },
                drugAdvancedContactNetworkBuyerPremiumTrustGain = {
                    label = "Kontaktnätverk / Köpare / Premium / Förtroende / vinst",
                    description = "Driftinställning för Kontaktnätverk / Köpare / Premium / Förtroende / vinst.",
                },
                drugAdvancedContactNetworkBuyerRequestHeatRiskWeight = {
                    label = "Kontaktnätverk / Köpare / Begäran / Efterlysning & Risk / Vikt",
                    description = "Driftinställning för Kontaktnätverk / Köpare / Begäran / Efterlysning & Risk / Vikt.",
                },
                drugAdvancedContactNetworkBuyerStandardTrustGain = {
                    label = "Kontaktnätverk / Köpare / Standard / Förtroende / vinst",
                    description = "Driftinställning för Kontaktnätverk / Köpare / Standard / Förtroende / vinst.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMax = {
                    label = "Kontaktnätverk / Fördröjning för kontaktaktivering / sekunder / Maximum",
                    description = "Driftinställning för Kontaktnätverk / Fördröjning för kontaktaktivering / sekunder / Maximum.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMin = {
                    label = "Kontaktnätverk / Fördröjning för kontaktaktivering / sekunder / Minimum",
                    description = "Driftinställning för Kontaktnätverk / Fördröjning för kontaktaktivering / sekunder / Minimum.",
                },
                drugAdvancedContactNetworkContactDemandRangeMax = {
                    label = "Kontaktnätverk / Kontakt / Efterfrågan / Värdeintervall / Maximum",
                    description = "Driftinställning för Kontaktnätverk / Kontakt / Efterfrågan / Värdeintervall / Maximum.",
                },
                drugAdvancedContactNetworkContactDemandRangeMin = {
                    label = "Kontaktnätverk / Kontakt / Efterfrågan / Värdeintervall / Minimum",
                    description = "Driftinställning för Kontaktnätverk / Kontakt / Efterfrågan / Värdeintervall / Minimum.",
                },
                drugAdvancedContactNetworkContactLossTrust = {
                    label = "Kontaktnätverk / Kontakt / Förlust / Förtroende",
                    description = "Driftinställning för Kontaktnätverk / Kontakt / Förlust / Förtroende.",
                },
                drugAdvancedContactNetworkDarknetExactIntelMinutes = {
                    label = "Kontaktnätverk / Darknet / Exakt information / Minuter",
                    description = "Driftinställning för Kontaktnätverk / Darknet / Exakt information / Minuter.",
                },
                drugAdvancedContactNetworkDarknetHotspotIntelPrice = {
                    label = "Kontaktnätverk / Darknet / Aktivt område / Underrättelser / Pris",
                    description = "Driftinställning för Kontaktnätverk / Darknet / Aktivt område / Underrättelser / Pris.",
                },
                drugAdvancedContactNetworkDarknetIntelPrice = {
                    label = "Kontaktnätverk / Darknet / Underrättelser / Pris",
                    description = "Driftinställning för Kontaktnätverk / Darknet / Underrättelser / Pris.",
                },
                drugAdvancedContactNetworkDealerBasePrice = {
                    label = "Kontaktnätverk / Återförsäljare / Baspris",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Baspris.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMax = {
                    label = "Kontaktnätverk / Återförsäljare / Anställning / kapacitet / Maximum",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Anställning / kapacitet / Maximum.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMin = {
                    label = "Kontaktnätverk / Återförsäljare / Anställning / kapacitet / Minimum",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Anställning / kapacitet / Minimum.",
                },
                drugAdvancedContactNetworkDealerHireRiskMax = {
                    label = "Kontaktnätverk / Återförsäljare / Anställning / Risk / Maximum",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Anställning / Risk / Maximum.",
                },
                drugAdvancedContactNetworkDealerHireRiskMin = {
                    label = "Kontaktnätverk / Återförsäljare / Anställning / Risk / Minimum",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Anställning / Risk / Minimum.",
                },
                drugAdvancedContactNetworkDealerHireSkillMax = {
                    label = "Kontaktnätverk / Återförsäljare / Anställning / Färdighet / Maximum",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Anställning / Färdighet / Maximum.",
                },
                drugAdvancedContactNetworkDealerHireSkillMin = {
                    label = "Kontaktnätverk / Återförsäljare / Anställning / Färdighet / Minimum",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Anställning / Färdighet / Minimum.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Id = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 1 / ID",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 1 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Item = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 1 / Föremål",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 1 / Föremål.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Label = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 1 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 1 / Etikett.",
                },
                drugAdvancedContactNetworkDealerOffersItem1MinTrust = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 1 / Minsta förtroende",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 1 / Minsta förtroende.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Price = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 1 / Pris",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 1 / Pris.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Id = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 2 / ID",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 2 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Item = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 2 / Föremål",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 2 / Föremål.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Label = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 2 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 2 / Etikett.",
                },
                drugAdvancedContactNetworkDealerOffersItem2MinTrust = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 2 / Minsta förtroende",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 2 / Minsta förtroende.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Price = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 2 / Pris",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 2 / Pris.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Id = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 3 / ID",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 3 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Item = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 3 / Föremål",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 3 / Föremål.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Label = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 3 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 3 / Etikett.",
                },
                drugAdvancedContactNetworkDealerOffersItem3MinTrust = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 3 / Minsta förtroende",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 3 / Minsta förtroende.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Price = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 3 / Pris",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 3 / Pris.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Id = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 4 / ID",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 4 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Item = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 4 / Föremål",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 4 / Föremål.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Label = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 4 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 4 / Etikett.",
                },
                drugAdvancedContactNetworkDealerOffersItem4MinTrust = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 4 / Minsta förtroende",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 4 / Minsta förtroende.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Price = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 4 / Pris",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 4 / Pris.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Id = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 5 / ID",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 5 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Item = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 5 / Föremål",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 5 / Föremål.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Label = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 5 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 5 / Etikett.",
                },
                drugAdvancedContactNetworkDealerOffersItem5MinTrust = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 5 / Minsta förtroende",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 5 / Minsta förtroende.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Price = {
                    label = "Kontaktnätverk / Dealer-erbjudanden / 5 / Pris",
                    description = "Driftinställning för Kontaktnätverk / Dealer-erbjudanden / 5 / Pris.",
                },
                drugAdvancedContactNetworkDealerProtectionHours = {
                    label = "Kontaktnätverk / Återförsäljare / Skydd / Timmar",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Skydd / Timmar.",
                },
                drugAdvancedContactNetworkDealerProtectionPrice = {
                    label = "Kontaktnätverk / Återförsäljare / Skydd / Pris",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Skydd / Pris.",
                },
                drugAdvancedContactNetworkDealerSaleMax = {
                    label = "Kontaktnätverk / Återförsäljare / Försäljning / Maximum",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Försäljning / Maximum.",
                },
                drugAdvancedContactNetworkDealerSaleMin = {
                    label = "Kontaktnätverk / Återförsäljare / Försäljning / Minimum",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Försäljning / Minimum.",
                },
                drugAdvancedContactNetworkDealerSimulationAggressivePriceMultiplier = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Aggressivt arbetssätt / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Aggressivt arbetssätt / Prismultiplikator.",
                },
                drugAdvancedContactNetworkDealerSimulationBaseQualityPriceFactor = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Grundkvalitet / Prisfaktor",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Grundkvalitet / Prisfaktor.",
                },
                drugAdvancedContactNetworkDealerSimulationBulkPriceMultiplier = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Bulk / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Bulk / Prismultiplikator.",
                },
                drugAdvancedContactNetworkDealerSimulationCheapPriceMultiplier = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Billig försäljning / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Billig försäljning / Prismultiplikator.",
                },
                drugAdvancedContactNetworkDealerSimulationDefaultQuality = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Standardvärde / Kvalitet",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Standardvärde / Kvalitet.",
                },
                drugAdvancedContactNetworkDealerSimulationDisloyalThreshold = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Tröskel för illojalitet",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Tröskel för illojalitet.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerLevel = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Erfarenhet / Per nivå",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Erfarenhet / Per nivå.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerUnit = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Erfarenhet / Per enhet",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Erfarenhet / Per enhet.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentLoyaltyLoss = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Incident / Lojalitet / Förlust",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Incident / Lojalitet / Förlust.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentRollMaximum = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Incident / Slumpkontroll / Maximum",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Incident / Slumpkontroll / Maximum.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelPriceBonus = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Nivå / Pris / Bonus",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Nivå / Pris / Bonus.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelSaleDivisor = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Nivå / Försäljning / Divisor",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Nivå / Försäljning / Divisor.",
                },
                drugAdvancedContactNetworkDealerSimulationLoyaltyRiskWeight = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Lojalitet / Risk / Vikt",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Lojalitet / Risk / Vikt.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumIncidentChance = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Maximum / Incident / Chans",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Maximum / Incident / Chans.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumLevel = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Maximum / Nivå",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Maximum / Nivå.",
                },
                drugAdvancedContactNetworkDealerSimulationPremiumPriceMultiplier = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Premium / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Premium / Prismultiplikator.",
                },
                drugAdvancedContactNetworkDealerSimulationProfileRiskWeight = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Profil / Risk / Vikt",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Profil / Risk / Vikt.",
                },
                drugAdvancedContactNetworkDealerSimulationProtectionRiskReduction = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Skydd / Risk / Minskning",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Skydd / Risk / Minskning.",
                },
                drugAdvancedContactNetworkDealerSimulationQualityPriceDivisor = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Kvalitet / Pris / Divisor",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Kvalitet / Pris / Divisor.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryBaseChance = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Återhämtning / Grundvärde / Chans",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Återhämtning / Grundvärde / Chans.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryLoyaltyWeight = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Återhämtning / Lojalitet / Vikt",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Återhämtning / Lojalitet / Vikt.",
                },
                drugAdvancedContactNetworkDealerSimulationRobbedStockLoss = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Lagerförlust vid rån",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Lagerförlust vid rån.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillRiskReduction = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Färdighet / Risk / Minskning",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Färdighet / Risk / Minskning.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillSaleDivisor = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Färdighet / Försäljning / Divisor",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Färdighet / Försäljning / Divisor.",
                },
                drugAdvancedContactNetworkDealerSimulationStableLoyaltyThreshold = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Tröskel för stabil lojalitet",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Tröskel för stabil lojalitet.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryPriceMultiplier = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Territorium / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Territorium / Prismultiplikator.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryRiskReduction = {
                    label = "Kontaktnätverk / Återförsäljare / Simulering / Territorium / Risk / Minskning",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Simulering / Territorium / Risk / Minskning.",
                },
                drugAdvancedContactNetworkDealerTickMinutes = {
                    label = "Kontaktnätverk / Återförsäljare / Uppdateringscykel / Minuter",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Uppdateringscykel / Minuter.",
                },
                drugAdvancedContactNetworkDealerWage = {
                    label = "Kontaktnätverk / Återförsäljare / Lön",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Lön.",
                },
                drugAdvancedContactNetworkDealerWageDecay = {
                    label = "Kontaktnätverk / Återförsäljare / Lön / Förfall",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Lön / Förfall.",
                },
                drugAdvancedContactNetworkDealerWageLoyaltyGain = {
                    label = "Kontaktnätverk / Återförsäljare / Lön / Lojalitet / vinst",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Lön / Lojalitet / vinst.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem1 = {
                    label = "Kontaktnätverk / Återförsäljare / Svagheter / 1",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Svagheter / 1.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem2 = {
                    label = "Kontaktnätverk / Återförsäljare / Svagheter / 2",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Svagheter / 2.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem3 = {
                    label = "Kontaktnätverk / Återförsäljare / Svagheter / 3",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Svagheter / 3.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem4 = {
                    label = "Kontaktnätverk / Återförsäljare / Svagheter / 4",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Svagheter / 4.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem5 = {
                    label = "Kontaktnätverk / Återförsäljare / Svagheter / 5",
                    description = "Driftinställning för Kontaktnätverk / Återförsäljare / Svagheter / 5.",
                },
                drugAdvancedContactNetworkDefaultContactDemand = {
                    label = "Kontaktnätverk / Standardvärde / Kontakt / Efterfrågan",
                    description = "Driftinställning för Kontaktnätverk / Standardvärde / Kontakt / Efterfrågan.",
                },
                drugAdvancedContactNetworkDefaultContactRisk = {
                    label = "Kontaktnätverk / Standardvärde / Kontakt / Risk",
                    description = "Driftinställning för Kontaktnätverk / Standardvärde / Kontakt / Risk.",
                },
                drugAdvancedContactNetworkDefaultDealerCapacity = {
                    label = "Kontaktnätverk / Standardlangare / kapacitet",
                    description = "Driftinställning för Kontaktnätverk / Standardlangare / kapacitet.",
                },
                drugAdvancedContactNetworkDefaultDealerRisk = {
                    label = "Kontaktnätverk / Standardlangare / Risk",
                    description = "Driftinställning för Kontaktnätverk / Standardlangare / Risk.",
                },
                drugAdvancedContactNetworkDefaultDealerSkill = {
                    label = "Kontaktnätverk / Standardlangare / Färdighet",
                    description = "Driftinställning för Kontaktnätverk / Standardlangare / Färdighet.",
                },
                drugAdvancedContactNetworkDefaultHotspotRadius = {
                    label = "Kontaktnätverk / Standardvärde / Aktivt område / Radie",
                    description = "Driftinställning för Kontaktnätverk / Standardvärde / Aktivt område / Radie.",
                },
                drugAdvancedContactNetworkDemandResetMinutes = {
                    label = "Kontaktnätverk / Återställning av efterfrågan (minuter)",
                    description = "Driftinställning för Kontaktnätverk / Återställning av efterfrågan (minuter).",
                },
                drugAdvancedContactNetworkEnabled = {
                    label = "Kontaktnätverk / Aktiverad",
                    description = "Driftinställning för Kontaktnätverk / Aktiverad.",
                },
                drugAdvancedContactNetworkExactLocationTrust = {
                    label = "Kontaktnätverk / Exakt plats / Förtroende",
                    description = "Driftinställning för Kontaktnätverk / Exakt plats / Förtroende.",
                },
                drugAdvancedContactNetworkFactionDiscoveryReputation = {
                    label = "Kontaktnätverk / Fraktion / Upptäckt / Rykte",
                    description = "Driftinställning för Kontaktnätverk / Fraktion / Upptäckt / Rykte.",
                },
                drugAdvancedContactNetworkFactionHintTrust = {
                    label = "Kontaktnätverk / Fraktion / Ledtråd / Förtroende",
                    description = "Driftinställning för Kontaktnätverk / Fraktion / Ledtråd / Förtroende.",
                },
                drugAdvancedContactNetworkFailedDeliveryCooldownMinutes = {
                    label = "Kontaktnätverk / Misslyckad leverans / Nedkylningsminuter",
                    description = "Driftinställning för Kontaktnätverk / Misslyckad leverans / Nedkylningsminuter.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerCount = {
                    label = "Kontaktnätverk / Falsk affär / Möte / Angripare / Antal",
                    description = "Driftinställning för Kontaktnätverk / Falsk affär / Möte / Angripare / Antal.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem1 = {
                    label = "Kontaktnätverk / Falsk affär / Möte / Angripare / Modeller / 1",
                    description = "Driftinställning för Kontaktnätverk / Falsk affär / Möte / Angripare / Modeller / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem2 = {
                    label = "Kontaktnätverk / Falsk affär / Möte / Angripare / Modeller / 2",
                    description = "Driftinställning för Kontaktnätverk / Falsk affär / Möte / Angripare / Modeller / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem3 = {
                    label = "Kontaktnätverk / Falsk affär / Möte / Angripare / Modeller / 3",
                    description = "Driftinställning för Kontaktnätverk / Falsk affär / Möte / Angripare / Modeller / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterDurationSeconds = {
                    label = "Kontaktnätverk / Falsk affär / Möte / Varaktighet (sekunder)",
                    description = "Driftinställning för Kontaktnätverk / Falsk affär / Möte / Varaktighet (sekunder).",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem1 = {
                    label = "Kontaktnätverk / Falsk affär / Möte / Polis / Modeller / 1",
                    description = "Driftinställning för Kontaktnätverk / Falsk affär / Möte / Polis / Modeller / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem2 = {
                    label = "Kontaktnätverk / Falsk affär / Möte / Polis / Modeller / 2",
                    description = "Driftinställning för Kontaktnätverk / Falsk affär / Möte / Polis / Modeller / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem3 = {
                    label = "Kontaktnätverk / Falsk affär / Möte / Polis / Modeller / 3",
                    description = "Driftinställning för Kontaktnätverk / Falsk affär / Möte / Polis / Modeller / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterSpawnRadius = {
                    label = "Kontaktnätverk / Falsk affär / Möte / Spawn-radie",
                    description = "Driftinställning för Kontaktnätverk / Falsk affär / Möte / Spawn-radie.",
                },
                drugAdvancedContactNetworkFallbackPreferredDrug = {
                    label = "Kontaktnätverk / Reservvärde / Föredragen drog",
                    description = "Driftinställning för Kontaktnätverk / Reservvärde / Föredragen drog.",
                },
                drugAdvancedContactNetworkFallbackProductLabel = {
                    label = "Kontaktnätverk / Reservvärde / Produktnamn",
                    description = "Driftinställning för Kontaktnätverk / Reservvärde / Produktnamn.",
                },
                drugAdvancedContactNetworkGuideBookItem = {
                    label = "Kontaktnätverk / Guide / Bok / Föremål",
                    description = "Driftinställning för Kontaktnätverk / Guide / Bok / Föremål.",
                },
                drugAdvancedContactNetworkGuideBookTrust = {
                    label = "Kontaktnätverk / Guide / Bok / Förtroende",
                    description = "Driftinställning för Kontaktnätverk / Guide / Bok / Förtroende.",
                },
                drugAdvancedContactNetworkHireDealerPrice = {
                    label = "Kontaktnätverk / Anställ dealer / Pris",
                    description = "Driftinställning för Kontaktnätverk / Anställ dealer / Pris.",
                },
                drugAdvancedContactNetworkHistoryLimit = {
                    label = "Kontaktnätverk / Historikgräns",
                    description = "Driftinställning för Kontaktnätverk / Historikgräns.",
                },
                drugAdvancedContactNetworkHotspotIntelMinutes = {
                    label = "Kontaktnätverk / Aktivt område / Underrättelser / Minuter",
                    description = "Driftinställning för Kontaktnätverk / Aktivt område / Underrättelser / Minuter.",
                },
                drugAdvancedContactNetworkHotspotRotationMinutes = {
                    label = "Kontaktnätverk / Aktivt område / Byte / Minuter",
                    description = "Driftinställning för Kontaktnätverk / Aktivt område / Byte / Minuter.",
                },
                drugAdvancedContactNetworkListingDurationMinutes = {
                    label = "Kontaktnätverk / Annons / Varaktighet / Minuter",
                    description = "Driftinställning för Kontaktnätverk / Annons / Varaktighet / Minuter.",
                },
                drugAdvancedContactNetworkMaxOwnedDealers = {
                    label = "Kontaktnätverk / Maximum / Ägd / Langare",
                    description = "Driftinställning för Kontaktnätverk / Maximum / Ägd / Langare.",
                },
                drugAdvancedContactNetworkMinimumBuyerDeliveryDistance = {
                    label = "Kontaktnätverk / Minimum / Köpare / Inlämningsavstånd",
                    description = "Driftinställning för Kontaktnätverk / Minimum / Köpare / Inlämningsavstånd.",
                },
                drugAdvancedContactNetworkMinimumContactRotationMinutes = {
                    label = "Kontaktnätverk / Minimum / Kontaktrotation (minuter)",
                    description = "Driftinställning för Kontaktnätverk / Minimum / Kontaktrotation (minuter).",
                },
                drugAdvancedContactNetworkMinimumDemandResetMinutes = {
                    label = "Kontaktnätverk / Minimum / Återställning av efterfrågan (minuter)",
                    description = "Driftinställning för Kontaktnätverk / Minimum / Återställning av efterfrågan (minuter).",
                },
                drugAdvancedContactNetworkMinimumHeatMultiplier = {
                    label = "Kontaktnätverk / Minimum / Polistryck / Multiplikator",
                    description = "Driftinställning för Kontaktnätverk / Minimum / Polistryck / Multiplikator.",
                },
                drugAdvancedContactNetworkMinimumHotspotIntelMinutes = {
                    label = "Kontaktnätverk / Minimum / Aktivt område / Underrättelser / Minuter",
                    description = "Driftinställning för Kontaktnätverk / Minimum / Aktivt område / Underrättelser / Minuter.",
                },
                drugAdvancedContactNetworkMinimumHotspotRadius = {
                    label = "Kontaktnätverk / Minimum / Aktivt område / Radie",
                    description = "Driftinställning för Kontaktnätverk / Minimum / Aktivt område / Radie.",
                },
                drugAdvancedContactNetworkMinimumHotspotRotationMinutes = {
                    label = "Kontaktnätverk / Minimum / Aktivt område / Byte / Minuter",
                    description = "Driftinställning för Kontaktnätverk / Minimum / Aktivt område / Byte / Minuter.",
                },
                drugAdvancedContactNetworkMinimumListingDurationMinutes = {
                    label = "Kontaktnätverk / Minimum / Annons / Varaktighet / Minuter",
                    description = "Driftinställning för Kontaktnätverk / Minimum / Annons / Varaktighet / Minuter.",
                },
                drugAdvancedContactNetworkMinimumRewardMultiplier = {
                    label = "Kontaktnätverk / Minsta belöning / Multiplikator",
                    description = "Driftinställning för Kontaktnätverk / Minsta belöning / Multiplikator.",
                },
                drugAdvancedContactNetworkMinimumRobberyMultiplier = {
                    label = "Kontaktnätverk / Minimum / Rån / Multiplikator",
                    description = "Driftinställning för Kontaktnätverk / Minimum / Rån / Multiplikator.",
                },
                drugAdvancedContactNetworkMinimumSpotPriceMultiplier = {
                    label = "Kontaktnätverk / Minimum / Plats / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Minimum / Plats / Prismultiplikator.",
                },
                drugAdvancedContactNetworkOtherDrugPriceMultiplier = {
                    label = "Kontaktnätverk / Övrigt / Droger / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Övrigt / Droger / Prismultiplikator.",
                },
                drugAdvancedContactNetworkPaymentAccount = {
                    label = "Kontaktnätverk / Betalkonto",
                    description = "Driftinställning för Kontaktnätverk / Betalkonto.",
                },
                drugAdvancedContactNetworkPostDeliveryDemandResetSeconds = {
                    label = "Kontaktnätverk / Efter leverans / Efterfrågan / Reset / sekunder",
                    description = "Driftinställning för Kontaktnätverk / Efter leverans / Efterfrågan / Reset / sekunder.",
                },
                drugAdvancedContactNetworkPreferredDrugPriceMultiplier = {
                    label = "Kontaktnätverk / Föredragen drog / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Föredragen drog / Prismultiplikator.",
                },
                drugAdvancedContactNetworkRegionLocationTrust = {
                    label = "Kontaktnätverk / Region / Plats / Förtroende",
                    description = "Driftinställning för Kontaktnätverk / Region / Plats / Förtroende.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMax = {
                    label = "Kontaktnätverk / Begäran / Mängder / Bulk / Maximum",
                    description = "Driftinställning för Kontaktnätverk / Begäran / Mängder / Bulk / Maximum.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMin = {
                    label = "Kontaktnätverk / Begäran / Mängder / Bulk / Minimum",
                    description = "Driftinställning för Kontaktnätverk / Begäran / Mängder / Bulk / Minimum.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMax = {
                    label = "Kontaktnätverk / Begäran / Mängder / Premium / Maximum",
                    description = "Driftinställning för Kontaktnätverk / Begäran / Mängder / Premium / Maximum.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMin = {
                    label = "Kontaktnätverk / Begäran / Mängder / Premium / Minimum",
                    description = "Driftinställning för Kontaktnätverk / Begäran / Mängder / Premium / Minimum.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMax = {
                    label = "Kontaktnätverk / Begäran / Mängder / Standard / Maximum",
                    description = "Driftinställning för Kontaktnätverk / Begäran / Mängder / Standard / Maximum.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMin = {
                    label = "Kontaktnätverk / Begäran / Mängder / Standard / Minimum",
                    description = "Driftinställning för Kontaktnätverk / Begäran / Mängder / Standard / Minimum.",
                },
                drugAdvancedContactNetworkRotationMinutes = {
                    label = "Kontaktnätverk / Byte / Minuter",
                    description = "Driftinställning för Kontaktnätverk / Byte / Minuter.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 1 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 1 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 1 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 1 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 1 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 1 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 1 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 1 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 1 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 1 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 1 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 1 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 1 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 1 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 1 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 2 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 2 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 2 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 2 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 2 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 2 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 2 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 2 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 2 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 2 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 2 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 2 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 2 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 2 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 2 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 3 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 3 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 3 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 3 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 3 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 3 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 3 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 3 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 3 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 3 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 3 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 3 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 3 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 3 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Gatulangare / 3 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 1 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 1 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 1 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 1 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 1 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 1 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 1 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 1 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 1 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 1 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 1 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 1 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 1 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 1 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 1 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 2 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 2 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 2 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 2 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 2 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 2 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 2 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 2 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 2 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 2 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 2 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 2 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 2 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 2 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 2 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 3 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 3 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 3 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 3 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 3 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 3 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 3 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 3 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 3 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 3 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 3 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 3 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 3 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 3 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardköpare / 3 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 1 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 1 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 1 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 1 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 1 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 1 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 1 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 1 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 1 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 1 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 1 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 1 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 1 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 1 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 1 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 2 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 2 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 2 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 2 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 2 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 2 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 2 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 2 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 2 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 2 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 2 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 2 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 2 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 2 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 2 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 3 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 3 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 3 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 3 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 3 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 3 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 3 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 3 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 3 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 3 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 3 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 3 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 3 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 3 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Standardlangare / 3 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 1 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 1 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 1 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 1 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 1 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 1 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 1 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 1 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 1 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 1 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 1 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 1 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 1 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 1 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 1 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 2 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 2 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 2 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 2 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 2 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 2 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 2 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 2 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 2 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 2 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 2 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 2 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 2 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 2 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 2 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 3 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 3 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 3 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 3 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 3 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 3 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 3 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 3 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 3 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 3 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 3 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 3 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 3 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 3 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Nätverkslangare / 3 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 1 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 1 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 1 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 1 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 1 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 1 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 1 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 1 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 1 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 1 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 1 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 1 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 1 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 1 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 1 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 2 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 2 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 2 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 2 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 2 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 2 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 2 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 2 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 2 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 2 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 2 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 2 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 2 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 2 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 2 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 3 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 3 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 3 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 3 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 3 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 3 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 3 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 3 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 3 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 3 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 3 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 3 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 3 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 3 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Premiumförmedlare / 3 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 1 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 1 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 1 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 1 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 1 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 1 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 1 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 1 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 1 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 1 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 1 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 1 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 1 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 1 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 1 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 2 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 2 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 2 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 2 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 2 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 2 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 2 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 2 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 2 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 2 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 2 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 2 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 2 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 2 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 2 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsX = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 3 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 3 / Koordinater / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsY = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 3 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 3 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsZ = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 3 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 3 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsW = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 3 / Koordinater / W",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 3 / Koordinater / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Label = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 3 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 3 / Etikett.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3PriceMultiplier = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 3 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 3 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Region = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 3 / Region",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Risk = {
                    label = "Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 3 / Risk",
                    description = "Driftinställning för Kontaktnätverk / Plats / Urvalsgrupper / Grossistkontakt / 3 / Risk.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1AcceptBonus = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 1 / Acceptansbonus",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 1 / Acceptansbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Archetype = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 1 / Grundtyp",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 1 / Grundtyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsX = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 1 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 1 / Koordinater / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsY = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 1 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 1 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsZ = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 1 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 1 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1DemandBonus = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 1 / Efterfrågebonus",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 1 / Efterfrågebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1HeatMultiplier = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 1 / Polistryck / Multiplikator",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 1 / Polistryck / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Id = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 1 / ID",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 1 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Label = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 1 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 1 / Etikett.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem1 = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 1 / Föredragna droger / 1",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 1 / Föredragna droger / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem2 = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 1 / Föredragna droger / 2",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 1 / Föredragna droger / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem3 = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 1 / Föredragna droger / 3",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 1 / Föredragna droger / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem4 = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 1 / Föredragna droger / 4",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 1 / Föredragna droger / 4.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PriceMultiplier = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 1 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 1 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Radius = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 1 / Radie",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 1 / Radie.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Region = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 1 / Region",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 1 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1RobberyMultiplier = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 1 / Rån / Multiplikator",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 1 / Rån / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2AcceptBonus = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 2 / Acceptansbonus",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 2 / Acceptansbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Archetype = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 2 / Grundtyp",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 2 / Grundtyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsX = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 2 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 2 / Koordinater / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsY = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 2 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 2 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsZ = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 2 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 2 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2DemandBonus = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 2 / Efterfrågebonus",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 2 / Efterfrågebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2HeatMultiplier = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 2 / Polistryck / Multiplikator",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 2 / Polistryck / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Id = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 2 / ID",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 2 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Label = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 2 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 2 / Etikett.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2MinimumQuality = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 2 / Minsta kvalitet",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 2 / Minsta kvalitet.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem1 = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 2 / Föredragna droger / 1",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 2 / Föredragna droger / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem2 = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 2 / Föredragna droger / 2",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 2 / Föredragna droger / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PriceMultiplier = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 2 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 2 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Radius = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 2 / Radie",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 2 / Radie.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Region = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 2 / Region",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 2 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2RobberyMultiplier = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 2 / Rån / Multiplikator",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 2 / Rån / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3AcceptBonus = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 3 / Acceptansbonus",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 3 / Acceptansbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Archetype = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 3 / Grundtyp",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 3 / Grundtyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsX = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 3 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 3 / Koordinater / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsY = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 3 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 3 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsZ = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 3 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 3 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3DemandBonus = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 3 / Efterfrågebonus",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 3 / Efterfrågebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3HeatMultiplier = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 3 / Polistryck / Multiplikator",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 3 / Polistryck / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Id = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 3 / ID",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 3 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Label = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 3 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 3 / Etikett.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem1 = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 3 / Föredragna droger / 1",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 3 / Föredragna droger / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem2 = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 3 / Föredragna droger / 2",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 3 / Föredragna droger / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem3 = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 3 / Föredragna droger / 3",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 3 / Föredragna droger / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PriceMultiplier = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 3 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 3 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Radius = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 3 / Radie",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 3 / Radie.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Region = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 3 / Region",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 3 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3RobberyMultiplier = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 3 / Rån / Multiplikator",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 3 / Rån / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4AcceptBonus = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 4 / Acceptansbonus",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 4 / Acceptansbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Archetype = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 4 / Grundtyp",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 4 / Grundtyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsX = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 4 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 4 / Koordinater / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsY = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 4 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 4 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsZ = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 4 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 4 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4DemandBonus = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 4 / Efterfrågebonus",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 4 / Efterfrågebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4HeatMultiplier = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 4 / Polistryck / Multiplikator",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 4 / Polistryck / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Id = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 4 / ID",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 4 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Label = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 4 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 4 / Etikett.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem1 = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 4 / Föredragna droger / 1",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 4 / Föredragna droger / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem2 = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 4 / Föredragna droger / 2",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 4 / Föredragna droger / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem3 = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 4 / Föredragna droger / 3",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 4 / Föredragna droger / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PriceMultiplier = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 4 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 4 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Radius = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 4 / Radie",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 4 / Radie.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Region = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 4 / Region",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 4 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4RobberyMultiplier = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 4 / Rån / Multiplikator",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 4 / Rån / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5AcceptBonus = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 5 / Acceptansbonus",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 5 / Acceptansbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Archetype = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 5 / Grundtyp",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 5 / Grundtyp.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsX = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 5 / Koordinater / X",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 5 / Koordinater / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsY = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 5 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 5 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsZ = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 5 / Koordinater / Z",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 5 / Koordinater / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5DemandBonus = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 5 / Efterfrågebonus",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 5 / Efterfrågebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5HeatMultiplier = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 5 / Polistryck / Multiplikator",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 5 / Polistryck / Multiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Id = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 5 / ID",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 5 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Label = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 5 / Etikett",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 5 / Etikett.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem1 = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 5 / Föredragna droger / 1",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 5 / Föredragna droger / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem2 = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 5 / Föredragna droger / 2",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 5 / Föredragna droger / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PriceMultiplier = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 5 / Prismultiplikator",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 5 / Prismultiplikator.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Radius = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 5 / Radie",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 5 / Radie.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Region = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 5 / Region",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 5 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5RobberyMultiplier = {
                    label = "Kontaktnätverk / Gata / Aktiva områden / 5 / Rån / Multiplikator",
                    description = "Driftinställning för Kontaktnätverk / Gata / Aktiva områden / 5 / Rån / Multiplikator.",
                },
                drugAdvancedContactNetworkTrustLevelsKnown = {
                    label = "Kontaktnätverk / Förtroende / Nivåer / Känd",
                    description = "Driftinställning för Kontaktnätverk / Förtroende / Nivåer / Känd.",
                },
                drugAdvancedContactNetworkTrustLevelsReliable = {
                    label = "Kontaktnätverk / Förtroende / Nivåer / Pålitlig",
                    description = "Driftinställning för Kontaktnätverk / Förtroende / Nivåer / Pålitlig.",
                },
                drugAdvancedContactNetworkTrustLevelsTrusted = {
                    label = "Kontaktnätverk / Förtroende / Nivåer / Betrodd",
                    description = "Driftinställning för Kontaktnätverk / Förtroende / Nivåer / Betrodd.",
                },
                drugAdvancedBusinessNetworkActionCooldownSeconds = {
                    label = "Företagsnätverk / Återhämtningstid för handlingar / sekunder",
                    description = "Driftinställning för Företagsnätverk / Återhämtningstid för handlingar / sekunder.",
                },
                drugAdvancedBusinessNetworkBalanceBaseUnitPrice = {
                    label = "Företagsnätverk / Saldo / Grundvärde / Enhetspris",
                    description = "Driftinställning för Företagsnätverk / Saldo / Grundvärde / Enhetspris.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerDealer = {
                    label = "Företagsnätverk / Saldo / Nätverkets hetta / Per langare",
                    description = "Driftinställning för Företagsnätverk / Saldo / Nätverkets hetta / Per langare.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerHub = {
                    label = "Företagsnätverk / Saldo / Nätverkets hetta / Per distributionscentral",
                    description = "Driftinställning för Företagsnätverk / Saldo / Nätverkets hetta / Per distributionscentral.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerRoute = {
                    label = "Företagsnätverk / Saldo / Nätverkets hetta / Per rutt",
                    description = "Driftinställning för Företagsnätverk / Saldo / Nätverkets hetta / Per rutt.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerStaff = {
                    label = "Företagsnätverk / Saldo / Nätverkets hetta / Per anställd",
                    description = "Driftinställning för Företagsnätverk / Saldo / Nätverkets hetta / Per anställd.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityGain = {
                    label = "Företagsnätverk / Saldo / Tillförlitlighet / vinst",
                    description = "Driftinställning för Företagsnätverk / Saldo / Tillförlitlighet / vinst.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityLoss = {
                    label = "Företagsnätverk / Saldo / Tillförlitlighet / Förlust",
                    description = "Driftinställning för Företagsnätverk / Saldo / Tillförlitlighet / Förlust.",
                },
                drugAdvancedBusinessNetworkBalanceRouteHeatDecay = {
                    label = "Företagsnätverk / Saldo / Rutt / Polistryck / Förfall",
                    description = "Driftinställning för Företagsnätverk / Saldo / Rutt / Polistryck / Förfall.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / gäng / Mängd / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / gäng / Mängd / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / gäng / Mängd / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / gäng / Mängd / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangMinRank = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / gäng / Minimum / Rang",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / gäng / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / gäng / Kvalitet / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / gäng / Kvalitet / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / gäng / Kvalitet / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / gäng / Kvalitet / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / gäng / Belöning / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / gäng / Belöning / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / gäng / Belöning / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / gäng / Belöning / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / gäng / Risk / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / gäng / Risk / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / gäng / Risk / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / gäng / Risk / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Mängd / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Mängd / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Mängd / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Mängd / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkMinRank = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Minimum / Rang",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Kvalitet / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Kvalitet / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Kvalitet / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Kvalitet / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Belöning / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Belöning / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Belöning / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Belöning / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Risk / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Risk / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Risk / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / NPC-nätverk / Risk / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Organisation / Mängd / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Organisation / Mängd / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Organisation / Mängd / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Organisation / Mängd / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationMinRank = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Organisation / Minimum / Rang",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Organisation / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Organisation / Kvalitet / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Organisation / Kvalitet / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Organisation / Kvalitet / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Organisation / Kvalitet / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Organisation / Belöning / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Organisation / Belöning / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Organisation / Belöning / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Organisation / Belöning / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Organisation / Risk / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Organisation / Risk / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Organisation / Risk / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Organisation / Risk / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Premium / Mängd / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Premium / Mängd / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Premium / Mängd / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Premium / Mängd / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumMinRank = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Premium / Minimum / Rang",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Premium / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Premium / Kvalitet / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Premium / Kvalitet / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Premium / Kvalitet / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Premium / Kvalitet / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Premium / Belöning / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Premium / Belöning / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Premium / Belöning / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Premium / Belöning / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Premium / Risk / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Premium / Risk / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Premium / Risk / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Premium / Risk / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Mängd / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Mängd / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Mängd / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Mängd / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherMinRank = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Minimum / Rang",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Kvalitet / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Kvalitet / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Kvalitet / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Kvalitet / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Belöning / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Belöning / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Belöning / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Belöning / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Risk / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Risk / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Risk / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Gatuförsäljare / Risk / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Särskild / Mängd / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Särskild / Mängd / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Särskild / Mängd / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Särskild / Mängd / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialMinRank = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Särskild / Minimum / Rang",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Särskild / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Särskild / Kvalitet / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Särskild / Kvalitet / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Särskild / Kvalitet / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Särskild / Kvalitet / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Särskild / Belöning / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Särskild / Belöning / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Särskild / Belöning / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Särskild / Belöning / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Särskild / Risk / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Särskild / Risk / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Särskild / Risk / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Särskild / Risk / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Grossist / Mängd / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Grossist / Mängd / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Grossist / Mängd / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Grossist / Mängd / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleMinRank = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Grossist / Minimum / Rang",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Grossist / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Grossist / Kvalitet / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Grossist / Kvalitet / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Grossist / Kvalitet / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Grossist / Kvalitet / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Grossist / Belöning / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Grossist / Belöning / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Grossist / Belöning / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Grossist / Belöning / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem1 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Grossist / Risk / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Grossist / Risk / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem2 = {
                    label = "Företagsnätverk / Kontrakt / Kategorier / Grossist / Risk / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Kategorier / Grossist / Risk / 2.",
                },
                drugAdvancedBusinessNetworkContractsDeliveryDistance = {
                    label = "Företagsnätverk / Kontrakt / Inlämningsavstånd",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Inlämningsavstånd.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMax = {
                    label = "Företagsnätverk / Kontrakt / Varaktighet / Minuter / Maximum",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Varaktighet / Minuter / Maximum.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMin = {
                    label = "Företagsnätverk / Kontrakt / Varaktighet / Minuter / Minimum",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Varaktighet / Minuter / Minimum.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsX = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 1 / Koordinater / X",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 1 / Koordinater / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsY = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 1 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 1 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsZ = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 1 / Koordinater / Z",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 1 / Koordinater / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Id = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 1 / ID",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 1 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Label = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 1 / Etikett",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 1 / Etikett.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Region = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 1 / Region",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 1 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1RewardMultiplier = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 1 / Belöning / Multiplikator",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 1 / Belöning / Multiplikator.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Risk = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 1 / Risk",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 1 / Risk.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsX = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 2 / Koordinater / X",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 2 / Koordinater / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsY = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 2 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 2 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsZ = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 2 / Koordinater / Z",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 2 / Koordinater / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Id = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 2 / ID",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 2 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Label = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 2 / Etikett",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 2 / Etikett.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Region = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 2 / Region",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 2 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2RewardMultiplier = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 2 / Belöning / Multiplikator",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 2 / Belöning / Multiplikator.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Risk = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 2 / Risk",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 2 / Risk.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsX = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 3 / Koordinater / X",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 3 / Koordinater / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsY = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 3 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 3 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsZ = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 3 / Koordinater / Z",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 3 / Koordinater / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Id = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 3 / ID",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 3 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Label = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 3 / Etikett",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 3 / Etikett.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Region = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 3 / Region",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 3 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3RewardMultiplier = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 3 / Belöning / Multiplikator",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 3 / Belöning / Multiplikator.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Risk = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 3 / Risk",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 3 / Risk.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsX = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 4 / Koordinater / X",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 4 / Koordinater / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsY = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 4 / Koordinater / YTTERLIGARE",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 4 / Koordinater / YTTERLIGARE.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsZ = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 4 / Koordinater / Z",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 4 / Koordinater / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Id = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 4 / ID",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 4 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Label = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 4 / Etikett",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 4 / Etikett.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Region = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 4 / Region",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 4 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4RewardMultiplier = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 4 / Belöning / Multiplikator",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 4 / Belöning / Multiplikator.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Risk = {
                    label = "Företagsnätverk / Kontrakt / Möte / Poäng / 4 / Risk",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Möte / Poäng / 4 / Risk.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem1 = {
                    label = "Företagsnätverk / Kontrakt / Förhandling / Förskott / Alternativ / 1",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Förhandling / Förskott / Alternativ / 1.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem2 = {
                    label = "Företagsnätverk / Kontrakt / Förhandling / Förskott / Alternativ / 2",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Förhandling / Förskott / Alternativ / 2.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem3 = {
                    label = "Företagsnätverk / Kontrakt / Förhandling / Förskott / Alternativ / 3",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Förhandling / Förskott / Alternativ / 3.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAmountFlexPercent = {
                    label = "Företagsnätverk / Kontrakt / Förhandling / Mängd / Förhandlingsutrymme / Procent",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Förhandling / Mängd / Förhandlingsutrymme / Procent.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationBaseAcceptance = {
                    label = "Företagsnätverk / Kontrakt / Förhandling / Grundvärde / Godkännande",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Förhandling / Grundvärde / Godkännande.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationDeadlineFlexPercent = {
                    label = "Företagsnätverk / Kontrakt / Förhandling / Deadline / Förhandlingsutrymme / Procent",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Förhandling / Deadline / Förhandlingsutrymme / Procent.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationMaxRounds = {
                    label = "Företagsnätverk / Kontrakt / Förhandling / Maximum / Omgångar",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Förhandling / Maximum / Omgångar.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationQualityFlex = {
                    label = "Företagsnätverk / Kontrakt / Förhandling / Kvalitet / Förhandlingsutrymme",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Förhandling / Kvalitet / Förhandlingsutrymme.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRejectionCooldownMinutes = {
                    label = "Företagsnätverk / Kontrakt / Förhandling / Avslag / Nedkylningsminuter",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Förhandling / Avslag / Nedkylningsminuter.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRoundPressure = {
                    label = "Företagsnätverk / Kontrakt / Förhandling / Runda / Tryck",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Förhandling / Runda / Tryck.",
                },
                drugAdvancedBusinessNetworkContractsOfferCount = {
                    label = "Företagsnätverk / Kontrakt / Erbjudande / Antal",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Erbjudande / Antal.",
                },
                drugAdvancedBusinessNetworkContractsRefreshMinutes = {
                    label = "Företagsnätverk / Kontrakt / Uppdatering / Minuter",
                    description = "Driftinställning för Företagsnätverk / Kontrakt / Uppdatering / Minuter.",
                },
                drugAdvancedBusinessNetworkDefaultBusinessName = {
                    label = "Företagsnätverk / Standardvärde / Företagsnamn",
                    description = "Driftinställning för Företagsnätverk / Standardvärde / Företagsnamn.",
                },
                drugAdvancedBusinessNetworkDefaultRankId = {
                    label = "Företagsnätverk / Standardvärde / Rang / ID",
                    description = "Driftinställning för Företagsnätverk / Standardvärde / Rang / ID.",
                },
                drugAdvancedBusinessNetworkDefaultStaffStyle = {
                    label = "Företagsnätverk / Standardvärde / Personal / Arbetssätt",
                    description = "Driftinställning för Företagsnätverk / Standardvärde / Personal / Arbetssätt.",
                },
                drugAdvancedBusinessNetworkDefaultTransport = {
                    label = "Företagsnätverk / Standardvärde / Transporter",
                    description = "Driftinställning för Företagsnätverk / Standardvärde / Transporter.",
                },
                drugAdvancedBusinessNetworkEnabled = {
                    label = "Företagsnätverk / Aktiverad",
                    description = "Driftinställning för Företagsnätverk / Aktiverad.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterCapacity = {
                    label = "Företagsnätverk / Distributionscentraler / Distributionscentral / kapacitet",
                    description = "Driftinställning för Företagsnätverk / Distributionscentraler / Distributionscentral / kapacitet.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterPurchasePrice = {
                    label = "Företagsnätverk / Distributionscentraler / Distributionscentral / Inköpspris",
                    description = "Driftinställning för Företagsnätverk / Distributionscentraler / Distributionscentral / Inköpspris.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterSecurity = {
                    label = "Företagsnätverk / Distributionscentraler / Distributionscentral / Säkerhet",
                    description = "Driftinställning för Företagsnätverk / Distributionscentraler / Distributionscentral / Säkerhet.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterUpkeep = {
                    label = "Företagsnätverk / Distributionscentraler / Distributionscentral / Underhåll",
                    description = "Driftinställning för Företagsnätverk / Distributionscentraler / Distributionscentral / Underhåll.",
                },
                drugAdvancedBusinessNetworkHubsStashCapacity = {
                    label = "Företagsnätverk / Distributionscentraler / Gömställe / kapacitet",
                    description = "Driftinställning för Företagsnätverk / Distributionscentraler / Gömställe / kapacitet.",
                },
                drugAdvancedBusinessNetworkHubsStashPurchasePrice = {
                    label = "Företagsnätverk / Distributionscentraler / Gömställe / Inköpspris",
                    description = "Driftinställning för Företagsnätverk / Distributionscentraler / Gömställe / Inköpspris.",
                },
                drugAdvancedBusinessNetworkHubsStashSecurity = {
                    label = "Företagsnätverk / Distributionscentraler / Gömställe / Säkerhet",
                    description = "Driftinställning för Företagsnätverk / Distributionscentraler / Gömställe / Säkerhet.",
                },
                drugAdvancedBusinessNetworkHubsStashUpkeep = {
                    label = "Företagsnätverk / Distributionscentraler / Gömställe / Underhåll",
                    description = "Driftinställning för Företagsnätverk / Distributionscentraler / Gömställe / Underhåll.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseCapacity = {
                    label = "Företagsnätverk / Distributionscentraler / Lager / kapacitet",
                    description = "Driftinställning för Företagsnätverk / Distributionscentraler / Lager / kapacitet.",
                },
                drugAdvancedBusinessNetworkHubsWarehousePurchasePrice = {
                    label = "Företagsnätverk / Distributionscentraler / Lager / Inköpspris",
                    description = "Driftinställning för Företagsnätverk / Distributionscentraler / Lager / Inköpspris.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseSecurity = {
                    label = "Företagsnätverk / Distributionscentraler / Lager / Säkerhet",
                    description = "Driftinställning för Företagsnätverk / Distributionscentraler / Lager / Säkerhet.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseUpkeep = {
                    label = "Företagsnätverk / Distributionscentraler / Lager / Underhåll",
                    description = "Driftinställning för Företagsnätverk / Distributionscentraler / Lager / Underhåll.",
                },
                drugAdvancedBusinessNetworkLimitsActiveContracts = {
                    label = "Företagsnätverk / Gränser / Aktiva kontrakt",
                    description = "Driftinställning för Företagsnätverk / Gränser / Aktiva kontrakt.",
                },
                drugAdvancedBusinessNetworkLimitsHubs = {
                    label = "Företagsnätverk / Gränser / Distributionscentraler",
                    description = "Driftinställning för Företagsnätverk / Gränser / Distributionscentraler.",
                },
                drugAdvancedBusinessNetworkLimitsLedgerRows = {
                    label = "Företagsnätverk / Gränser / Bokföring / Rader",
                    description = "Driftinställning för Företagsnätverk / Gränser / Bokföring / Rader.",
                },
                drugAdvancedBusinessNetworkLimitsRoutes = {
                    label = "Företagsnätverk / Gränser / Rutter",
                    description = "Driftinställning för Företagsnätverk / Gränser / Rutter.",
                },
                drugAdvancedBusinessNetworkLimitsStaff = {
                    label = "Företagsnätverk / Gränser / Personal",
                    description = "Driftinställning för Företagsnätverk / Gränser / Personal.",
                },
                drugAdvancedBusinessNetworkPayoutAccount = {
                    label = "Företagsnätverk / Utbetalning / Konto",
                    description = "Driftinställning för Företagsnätverk / Utbetalning / Konto.",
                },
                drugAdvancedBusinessNetworkRanksItem1Contracts = {
                    label = "Företagsnätverk / Grader / 1 / Kontrakt",
                    description = "Driftinställning för Företagsnätverk / Grader / 1 / Kontrakt.",
                },
                drugAdvancedBusinessNetworkRanksItem1Dealers = {
                    label = "Företagsnätverk / Grader / 1 / Langare",
                    description = "Driftinställning för Företagsnätverk / Grader / 1 / Langare.",
                },
                drugAdvancedBusinessNetworkRanksItem1Hubs = {
                    label = "Företagsnätverk / Grader / 1 / Distributionscentraler",
                    description = "Driftinställning för Företagsnätverk / Grader / 1 / Distributionscentraler.",
                },
                drugAdvancedBusinessNetworkRanksItem1Id = {
                    label = "Företagsnätverk / Grader / 1 / ID",
                    description = "Driftinställning för Företagsnätverk / Grader / 1 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem1Label = {
                    label = "Företagsnätverk / Grader / 1 / Etikett",
                    description = "Driftinställning för Företagsnätverk / Grader / 1 / Etikett.",
                },
                drugAdvancedBusinessNetworkRanksItem1Routes = {
                    label = "Företagsnätverk / Grader / 1 / Rutter",
                    description = "Driftinställning för Företagsnätverk / Grader / 1 / Rutter.",
                },
                drugAdvancedBusinessNetworkRanksItem1Score = {
                    label = "Företagsnätverk / Grader / 1 / Poäng",
                    description = "Driftinställning för Företagsnätverk / Grader / 1 / Poäng.",
                },
                drugAdvancedBusinessNetworkRanksItem1Staff = {
                    label = "Företagsnätverk / Grader / 1 / Personal",
                    description = "Driftinställning för Företagsnätverk / Grader / 1 / Personal.",
                },
                drugAdvancedBusinessNetworkRanksItem2Contracts = {
                    label = "Företagsnätverk / Grader / 2 / Kontrakt",
                    description = "Driftinställning för Företagsnätverk / Grader / 2 / Kontrakt.",
                },
                drugAdvancedBusinessNetworkRanksItem2Dealers = {
                    label = "Företagsnätverk / Grader / 2 / Langare",
                    description = "Driftinställning för Företagsnätverk / Grader / 2 / Langare.",
                },
                drugAdvancedBusinessNetworkRanksItem2Hubs = {
                    label = "Företagsnätverk / Grader / 2 / Distributionscentraler",
                    description = "Driftinställning för Företagsnätverk / Grader / 2 / Distributionscentraler.",
                },
                drugAdvancedBusinessNetworkRanksItem2Id = {
                    label = "Företagsnätverk / Grader / 2 / ID",
                    description = "Driftinställning för Företagsnätverk / Grader / 2 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem2Label = {
                    label = "Företagsnätverk / Grader / 2 / Etikett",
                    description = "Driftinställning för Företagsnätverk / Grader / 2 / Etikett.",
                },
                drugAdvancedBusinessNetworkRanksItem2Routes = {
                    label = "Företagsnätverk / Grader / 2 / Rutter",
                    description = "Driftinställning för Företagsnätverk / Grader / 2 / Rutter.",
                },
                drugAdvancedBusinessNetworkRanksItem2Score = {
                    label = "Företagsnätverk / Grader / 2 / Poäng",
                    description = "Driftinställning för Företagsnätverk / Grader / 2 / Poäng.",
                },
                drugAdvancedBusinessNetworkRanksItem2Staff = {
                    label = "Företagsnätverk / Grader / 2 / Personal",
                    description = "Driftinställning för Företagsnätverk / Grader / 2 / Personal.",
                },
                drugAdvancedBusinessNetworkRanksItem3Contracts = {
                    label = "Företagsnätverk / Grader / 3 / Kontrakt",
                    description = "Driftinställning för Företagsnätverk / Grader / 3 / Kontrakt.",
                },
                drugAdvancedBusinessNetworkRanksItem3Dealers = {
                    label = "Företagsnätverk / Grader / 3 / Langare",
                    description = "Driftinställning för Företagsnätverk / Grader / 3 / Langare.",
                },
                drugAdvancedBusinessNetworkRanksItem3Hubs = {
                    label = "Företagsnätverk / Grader / 3 / Distributionscentraler",
                    description = "Driftinställning för Företagsnätverk / Grader / 3 / Distributionscentraler.",
                },
                drugAdvancedBusinessNetworkRanksItem3Id = {
                    label = "Företagsnätverk / Grader / 3 / ID",
                    description = "Driftinställning för Företagsnätverk / Grader / 3 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem3Label = {
                    label = "Företagsnätverk / Grader / 3 / Etikett",
                    description = "Driftinställning för Företagsnätverk / Grader / 3 / Etikett.",
                },
                drugAdvancedBusinessNetworkRanksItem3Routes = {
                    label = "Företagsnätverk / Grader / 3 / Rutter",
                    description = "Driftinställning för Företagsnätverk / Grader / 3 / Rutter.",
                },
                drugAdvancedBusinessNetworkRanksItem3Score = {
                    label = "Företagsnätverk / Grader / 3 / Poäng",
                    description = "Driftinställning för Företagsnätverk / Grader / 3 / Poäng.",
                },
                drugAdvancedBusinessNetworkRanksItem3Staff = {
                    label = "Företagsnätverk / Grader / 3 / Personal",
                    description = "Driftinställning för Företagsnätverk / Grader / 3 / Personal.",
                },
                drugAdvancedBusinessNetworkRanksItem4Contracts = {
                    label = "Företagsnätverk / Grader / 4 / Kontrakt",
                    description = "Driftinställning för Företagsnätverk / Grader / 4 / Kontrakt.",
                },
                drugAdvancedBusinessNetworkRanksItem4Dealers = {
                    label = "Företagsnätverk / Grader / 4 / Langare",
                    description = "Driftinställning för Företagsnätverk / Grader / 4 / Langare.",
                },
                drugAdvancedBusinessNetworkRanksItem4Hubs = {
                    label = "Företagsnätverk / Grader / 4 / Distributionscentraler",
                    description = "Driftinställning för Företagsnätverk / Grader / 4 / Distributionscentraler.",
                },
                drugAdvancedBusinessNetworkRanksItem4Id = {
                    label = "Företagsnätverk / Grader / 4 / ID",
                    description = "Driftinställning för Företagsnätverk / Grader / 4 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem4Label = {
                    label = "Företagsnätverk / Grader / 4 / Etikett",
                    description = "Driftinställning för Företagsnätverk / Grader / 4 / Etikett.",
                },
                drugAdvancedBusinessNetworkRanksItem4Routes = {
                    label = "Företagsnätverk / Grader / 4 / Rutter",
                    description = "Driftinställning för Företagsnätverk / Grader / 4 / Rutter.",
                },
                drugAdvancedBusinessNetworkRanksItem4Score = {
                    label = "Företagsnätverk / Grader / 4 / Poäng",
                    description = "Driftinställning för Företagsnätverk / Grader / 4 / Poäng.",
                },
                drugAdvancedBusinessNetworkRanksItem4Staff = {
                    label = "Företagsnätverk / Grader / 4 / Personal",
                    description = "Driftinställning för Företagsnätverk / Grader / 4 / Personal.",
                },
                drugAdvancedBusinessNetworkRanksItem5Contracts = {
                    label = "Företagsnätverk / Grader / 5 / Kontrakt",
                    description = "Driftinställning för Företagsnätverk / Grader / 5 / Kontrakt.",
                },
                drugAdvancedBusinessNetworkRanksItem5Dealers = {
                    label = "Företagsnätverk / Grader / 5 / Langare",
                    description = "Driftinställning för Företagsnätverk / Grader / 5 / Langare.",
                },
                drugAdvancedBusinessNetworkRanksItem5Hubs = {
                    label = "Företagsnätverk / Grader / 5 / Distributionscentraler",
                    description = "Driftinställning för Företagsnätverk / Grader / 5 / Distributionscentraler.",
                },
                drugAdvancedBusinessNetworkRanksItem5Id = {
                    label = "Företagsnätverk / Grader / 5 / ID",
                    description = "Driftinställning för Företagsnätverk / Grader / 5 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem5Label = {
                    label = "Företagsnätverk / Grader / 5 / Etikett",
                    description = "Driftinställning för Företagsnätverk / Grader / 5 / Etikett.",
                },
                drugAdvancedBusinessNetworkRanksItem5Routes = {
                    label = "Företagsnätverk / Grader / 5 / Rutter",
                    description = "Driftinställning för Företagsnätverk / Grader / 5 / Rutter.",
                },
                drugAdvancedBusinessNetworkRanksItem5Score = {
                    label = "Företagsnätverk / Grader / 5 / Poäng",
                    description = "Driftinställning för Företagsnätverk / Grader / 5 / Poäng.",
                },
                drugAdvancedBusinessNetworkRanksItem5Staff = {
                    label = "Företagsnätverk / Grader / 5 / Personal",
                    description = "Driftinställning för Företagsnätverk / Grader / 5 / Personal.",
                },
                drugAdvancedBusinessNetworkReportDays = {
                    label = "Företagsnätverk / Rapportperiod / dagar",
                    description = "Driftinställning för Företagsnätverk / Rapportperiod / dagar.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesBuyer = {
                    label = "Företagsnätverk / Rutt / Slutpunkt / Typer / Köpare",
                    description = "Driftinställning för Företagsnätverk / Rutt / Slutpunkt / Typer / Köpare.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesContract = {
                    label = "Företagsnätverk / Rutt / Slutpunkt / Typer / Kontrakt",
                    description = "Driftinställning för Företagsnätverk / Rutt / Slutpunkt / Typer / Kontrakt.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesDealer = {
                    label = "Företagsnätverk / Rutt / Slutpunkt / Typer / Återförsäljare",
                    description = "Driftinställning för Företagsnätverk / Rutt / Slutpunkt / Typer / Återförsäljare.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesGang = {
                    label = "Företagsnätverk / Rutt / Slutpunkt / Typer / gäng",
                    description = "Driftinställning för Företagsnätverk / Rutt / Slutpunkt / Typer / gäng.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesHub = {
                    label = "Företagsnätverk / Rutt / Slutpunkt / Typer / Distributionscentral",
                    description = "Driftinställning för Företagsnätverk / Rutt / Slutpunkt / Typer / Distributionscentral.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesLab = {
                    label = "Företagsnätverk / Rutt / Slutpunkt / Typer / Lab",
                    description = "Driftinställning för Företagsnätverk / Rutt / Slutpunkt / Typer / Lab.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesOrganization = {
                    label = "Företagsnätverk / Rutt / Slutpunkt / Typer / Organisation",
                    description = "Driftinställning för Företagsnätverk / Rutt / Slutpunkt / Typer / Organisation.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesPusher = {
                    label = "Företagsnätverk / Rutt / Slutpunkt / Typer / Gatuförsäljare",
                    description = "Driftinställning för Företagsnätverk / Rutt / Slutpunkt / Typer / Gatuförsäljare.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMax = {
                    label = "Företagsnätverk / Drift i spelet / Kontrakt / Frekvens / Minuter / Maximum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kontrakt / Frekvens / Minuter / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMin = {
                    label = "Företagsnätverk / Drift i spelet / Kontrakt / Frekvens / Minuter / Minimum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kontrakt / Frekvens / Minuter / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCooldownMinimumMinutes = {
                    label = "Företagsnätverk / Drift i spelet / Kontrakt / Nedkylning / Minimum / Minuter",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kontrakt / Nedkylning / Minimum / Minuter.",
                },
                drugAdvancedBusinessNetworkRuntimeContractFailureReliabilityLoss = {
                    label = "Företagsnätverk / Drift i spelet / Kontrakt / Misslyckande / Tillförlitlighet / Förlust",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kontrakt / Misslyckande / Tillförlitlighet / Förlust.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumCadenceMinutes = {
                    label = "Företagsnätverk / Drift i spelet / Kontrakt / Minimum / Frekvens / Minuter",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kontrakt / Minimum / Frekvens / Minuter.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumMeetingMultiplier = {
                    label = "Företagsnätverk / Drift i spelet / Kontrakt / Minimum / Möte / Multiplikator",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kontrakt / Minimum / Möte / Multiplikator.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyGrowth = {
                    label = "Företagsnätverk / Drift i spelet / Kontraktsböter / Tillväxt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kontraktsböter / Tillväxt.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyMultiplier = {
                    label = "Företagsnätverk / Drift i spelet / Kontraktsböter / Multiplikator",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kontraktsböter / Multiplikator.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityFailureCooldownMinutes = {
                    label = "Företagsnätverk / Drift i spelet / Kontrakt / Kvalitet / Misslyckande / Nedkylningsminuter",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kontrakt / Kvalitet / Misslyckande / Nedkylningsminuter.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceBase = {
                    label = "Företagsnätverk / Drift i spelet / Kontrakt / Kvalitet / Pris / Grundvärde",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kontrakt / Kvalitet / Pris / Grundvärde.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceDivisor = {
                    label = "Företagsnätverk / Drift i spelet / Kontrakt / Kvalitet / Pris / Divisor",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kontrakt / Kvalitet / Pris / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossBase = {
                    label = "Företagsnätverk / Drift i spelet / Kontrakt / Tillförlitlighet / Förlust / Grundvärde",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kontrakt / Tillförlitlighet / Förlust / Grundvärde.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossMaximum = {
                    label = "Företagsnätverk / Drift i spelet / Kontrakt / Tillförlitlighet / Förlust / Maximum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kontrakt / Tillförlitlighet / Förlust / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossQualityWeight = {
                    label = "Företagsnätverk / Drift i spelet / Kontrakt / Tillförlitlighet / Förlust / Kvalitet / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kontrakt / Tillförlitlighet / Förlust / Kvalitet / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReputationQualityWeight = {
                    label = "Företagsnätverk / Drift i spelet / Kontrakt / Rykte / Kvalitet / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kontrakt / Rykte / Kvalitet / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsCategory = {
                    label = "Företagsnätverk / Drift i spelet / Kontrakt / Risk / Viktningar / Kategori",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kontrakt / Risk / Viktningar / Kategori.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsMeeting = {
                    label = "Företagsnätverk / Drift i spelet / Kontrakt / Risk / Viktningar / Möte",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kontrakt / Risk / Viktningar / Möte.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubCapacity = {
                    label = "Företagsnätverk / Drift i spelet / Standardvärde / Distributionscentral / kapacitet",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Standardvärde / Distributionscentral / kapacitet.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubSecurity = {
                    label = "Företagsnätverk / Drift i spelet / Standardvärde / Distributionscentral / Säkerhet",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Standardvärde / Distributionscentral / Säkerhet.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultMeetingRisk = {
                    label = "Företagsnätverk / Drift i spelet / Standardvärde / Möte / Risk",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Standardvärde / Möte / Risk.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultQuality = {
                    label = "Företagsnätverk / Drift i spelet / Standardvärde / Kvalitet",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Standardvärde / Kvalitet.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteCapacity = {
                    label = "Företagsnätverk / Drift i spelet / Standardvärde / Ruttkapacitet",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Standardvärde / Ruttkapacitet.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteIntervalMinutes = {
                    label = "Företagsnätverk / Drift i spelet / Standardvärde / Rutt / Intervall / Minuter",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Standardvärde / Rutt / Intervall / Minuter.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteRisk = {
                    label = "Företagsnätverk / Drift i spelet / Standardvärde / Rutt / Risk",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Standardvärde / Rutt / Risk.",
                },
                drugAdvancedBusinessNetworkRuntimeHubHeatDecay = {
                    label = "Företagsnätverk / Drift i spelet / Distributionscentral / Polistryck / Förfall",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Distributionscentral / Polistryck / Förfall.",
                },
                drugAdvancedBusinessNetworkRuntimeHubLoadHeat = {
                    label = "Företagsnätverk / Drift i spelet / Distributionscentral / Belastning / Polistryck",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Distributionscentral / Belastning / Polistryck.",
                },
                drugAdvancedBusinessNetworkRuntimeHubRaidRecoveryMinutes = {
                    label = "Företagsnätverk / Drift i spelet / Distributionscentral / Räd / Återhämtning / Minuter",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Distributionscentral / Räd / Återhämtning / Minuter.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostBase = {
                    label = "Företagsnätverk / Drift i spelet / Distributionscentral / Säkerhet / Kostnad / Grundvärde",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Distributionscentral / Säkerhet / Kostnad / Grundvärde.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostPerLevel = {
                    label = "Företagsnätverk / Drift i spelet / Distributionscentral / Säkerhet / Kostnad / Per nivå",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Distributionscentral / Säkerhet / Kostnad / Per nivå.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityMaximum = {
                    label = "Företagsnätverk / Drift i spelet / Distributionscentral / Säkerhet / Maximum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Distributionscentral / Säkerhet / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityUpgrade = {
                    label = "Företagsnätverk / Drift i spelet / Distributionscentral / Säkerhet / Uppgradering",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Distributionscentral / Säkerhet / Uppgradering.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidHeat = {
                    label = "Företagsnätverk / Drift i spelet / Distributionscentral / Utebliven betalning / Polistryck",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Distributionscentral / Utebliven betalning / Polistryck.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidSecurityLoss = {
                    label = "Företagsnätverk / Drift i spelet / Distributionscentral / Utebliven betalning / Säkerhet / Förlust",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Distributionscentral / Utebliven betalning / Säkerhet / Förlust.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUpkeepIntervalHours = {
                    label = "Företagsnätverk / Drift i spelet / Distributionscentral / Underhåll / Intervall / Timmar",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Distributionscentral / Underhåll / Intervall / Timmar.",
                },
                drugAdvancedBusinessNetworkRuntimeInitialReliability = {
                    label = "Företagsnätverk / Drift i spelet / Startvärde / Tillförlitlighet",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Startvärde / Tillförlitlighet.",
                },
                drugAdvancedBusinessNetworkRuntimeMaximumBusinessNameLength = {
                    label = "Företagsnätverk / Drift i spelet / Maximum / Företagsnamn / Längd",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Maximum / Företagsnamn / Längd.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumContractDeliveryMinutes = {
                    label = "Företagsnätverk / Drift i spelet / Minimum / Kontrakt / Leverans / Minuter",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Minimum / Kontrakt / Leverans / Minuter.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumDeliveryDistance = {
                    label = "Företagsnätverk / Drift i spelet / Minimum / Inlämningsavstånd",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Minimum / Inlämningsavstånd.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumLedgerRows = {
                    label = "Företagsnätverk / Drift i spelet / Minimum / Bokföring / Rader",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Minimum / Bokföring / Rader.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumRouteIntervalMinutes = {
                    label = "Företagsnätverk / Drift i spelet / Minimum / Rutt / Intervall / Minuter",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Minimum / Rutt / Intervall / Minuter.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvanceCostWeight = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Förskott / Kostnad / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Förskott / Kostnad / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvancePriceWeight = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Förskott / Pris / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Förskott / Pris / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountCostWeight = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Mängd / Kostnad / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Mängd / Kostnad / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountFlexMaximum = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Mängd / Förhandlingsutrymme / Maximum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Mängd / Förhandlingsutrymme / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountRiskWeight = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Mängd / Risk / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Mängd / Risk / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationCounterOfferWeight = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Motbud / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Motbud / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationDeadlineFlexMaximum = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Deadline / Förhandlingsutrymme / Maximum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Deadline / Förhandlingsutrymme / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMaximumAcceptance = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Maximum / Godkännande",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Maximum / Godkännande.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMinimumAcceptance = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Minimum / Godkännande",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Minimum / Godkännande.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityBenefitWeight = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Kvalitet / Nytta / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Kvalitet / Nytta / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityCostWeight = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Kvalitet / Kostnad / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Kvalitet / Kostnad / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityFlexMaximum = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Kvalitet / Förhandlingsutrymme / Maximum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Kvalitet / Förhandlingsutrymme / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityRewardWeight = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Kvalitet / Belöning / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Kvalitet / Belöning / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReliabilityWeight = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Tillförlitlighet / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Tillförlitlighet / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReputationWeight = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Rykte / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Rykte / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMax = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Begärd belöning / Maximum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Begärd belöning / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMin = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Begärd belöning / Minimum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Begärd belöning / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardCostWeight = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Belöning / Kostnad / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Belöning / Kostnad / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMax = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Belöning / Maximum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Belöning / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMin = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Belöning / Minimum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Belöning / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBase = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Brådska / Grundvärde",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Brådska / Grundvärde.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBenefitWeight = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Brådska / Nytta / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Brådska / Nytta / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyRiskWeight = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Brådska / Risk / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Brådska / Risk / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyWeight = {
                    label = "Företagsnätverk / Drift i spelet / Förhandling / Brådska / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Förhandling / Brådska / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeOtherFailureHeat = {
                    label = "Företagsnätverk / Drift i spelet / Övrigt / Misslyckande / Polistryck",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Övrigt / Misslyckande / Polistryck.",
                },
                drugAdvancedBusinessNetworkRuntimePersonalHeatWeight = {
                    label = "Företagsnätverk / Drift i spelet / Personlig uppmärksamhet / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personlig uppmärksamhet / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimePoliceFailureHeat = {
                    label = "Företagsnätverk / Drift i spelet / Polis / Misslyckande / Polistryck",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Polis / Misslyckande / Polistryck.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBaseUnits = {
                    label = "Företagsnätverk / Drift i spelet / Gatuförsäljare / Grundvärde / enheter",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Gatuförsäljare / Grundvärde / enheter.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBulkMultiplier = {
                    label = "Företagsnätverk / Drift i spelet / Gatuförsäljare / Bulk / Multiplikator",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Gatuförsäljare / Bulk / Multiplikator.",
                },
                drugAdvancedBusinessNetworkRuntimePusherCheapMultiplier = {
                    label = "Företagsnätverk / Drift i spelet / Gatuförsäljare / Billig försäljning / Multiplikator",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Gatuförsäljare / Billig försäljning / Multiplikator.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerLevel = {
                    label = "Företagsnätverk / Drift i spelet / Gatuförsäljare / Erfarenhet / Per nivå",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Gatuförsäljare / Erfarenhet / Per nivå.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerUnit = {
                    label = "Företagsnätverk / Drift i spelet / Gatuförsäljare / Erfarenhet / Per enhet",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Gatuförsäljare / Erfarenhet / Per enhet.",
                },
                drugAdvancedBusinessNetworkRuntimePusherHubHeatPerUnit = {
                    label = "Företagsnätverk / Drift i spelet / Gatuförsäljare / Distributionscentral / Polistryck / Per enhet",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Gatuförsäljare / Distributionscentral / Polistryck / Per enhet.",
                },
                drugAdvancedBusinessNetworkRuntimePusherPremiumMultiplier = {
                    label = "Företagsnätverk / Drift i spelet / Gatuförsäljare / Premium / Multiplikator",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Gatuförsäljare / Premium / Multiplikator.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillDivisor = {
                    label = "Företagsnätverk / Drift i spelet / Gatuförsäljare / Färdighet / Divisor",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Gatuförsäljare / Färdighet / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillGain = {
                    label = "Företagsnätverk / Drift i spelet / Gatuförsäljare / Färdighet / vinst",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Gatuförsäljare / Färdighet / vinst.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationBaseSeconds = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Varaktighet / Grundvärde / sekunder",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Varaktighet / Grundvärde / sekunder.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationPerUnitSeconds = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Varaktighet / Per enhet / sekunder",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Varaktighet / Per enhet / sekunder.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem1 = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Misslyckande / Orsaker / 1",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Misslyckande / Orsaker / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem2 = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Misslyckande / Orsaker / 2",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Misslyckande / Orsaker / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem3 = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Misslyckande / Orsaker / 3",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Misslyckande / Orsaker / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem4 = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Misslyckande / Orsaker / 4",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Misslyckande / Orsaker / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureValueMultiplier = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Misslyckande / Värde / Multiplikator",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Misslyckande / Värde / Multiplikator.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatAmountDivisor = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Polistryck / Mängd / Divisor",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Polistryck / Mängd / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostBase = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Minskad efterlysning / Kostnad / Grundvärde",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Minskad efterlysning / Kostnad / Grundvärde.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostPerHeat = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Minskad efterlysning / Kostnad / Per poäng polisuppmärksamhet",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Minskad efterlysning / Kostnad / Per poäng polisuppmärksamhet.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMaximum = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Risk / Maximum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Risk / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMinimum = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Risk / Minimum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Risk / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsHeat = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Risk / Viktningar / Polistryck",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Risk / Viktningar / Polistryck.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsLoyalty = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Risk / Viktningar / Lojalitet",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Risk / Viktningar / Lojalitet.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsRunnerRisk = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Risk / Viktningar / Kurir / Risk",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Risk / Viktningar / Kurir / Risk.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsSkill = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Risk / Viktningar / Färdighet",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Risk / Viktningar / Färdighet.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationHeatReduction = {
                    label = "Företagsnätverk / Drift i spelet / Routrotation / Minskad efterlysning",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Routrotation / Minskad efterlysning.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationRiskReduction = {
                    label = "Företagsnätverk / Drift i spelet / Routrotation / Risk / Minskning",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Routrotation / Risk / Minskning.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityBase = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Försäljning / Bas-kvalitet",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Försäljning / Bas-kvalitet.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityDivisor = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Försäljning / Kvalitet / Divisor",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Försäljning / Kvalitet / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleRiskDivisor = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Försäljning / Risk / Divisor",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Försäljning / Risk / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteStartHeat = {
                    label = "Företagsnätverk / Drift i spelet / Rutt / Start / Polistryck",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Rutt / Start / Polistryck.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerLevel = {
                    label = "Företagsnätverk / Drift i spelet / Kurir / Erfarenhet / Per nivå",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kurir / Erfarenhet / Per nivå.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerUnit = {
                    label = "Företagsnätverk / Drift i spelet / Kurir / Erfarenhet / Per enhet",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kurir / Erfarenhet / Per enhet.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureLoyaltyLoss = {
                    label = "Företagsnätverk / Drift i spelet / Kurir / Misslyckande / Lojalitet / Förlust",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kurir / Misslyckande / Lojalitet / Förlust.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureRiskGain = {
                    label = "Företagsnätverk / Drift i spelet / Kurir / Misslyckanderisk / vinst",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kurir / Misslyckanderisk / vinst.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerSkillGain = {
                    label = "Företagsnätverk / Drift i spelet / Kurir / Färdighet / vinst",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Kurir / Färdighet / vinst.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsHeat = {
                    label = "Företagsnätverk / Drift i spelet / Poäng / Viktningar / Polistryck",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Poäng / Viktningar / Polistryck.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReliability = {
                    label = "Företagsnätverk / Drift i spelet / Poäng / Viktningar / Tillförlitlighet",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Poäng / Viktningar / Tillförlitlighet.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReputation = {
                    label = "Företagsnätverk / Drift i spelet / Poäng / Viktningar / Rykte",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Poäng / Viktningar / Rykte.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsStructure = {
                    label = "Företagsnätverk / Drift i spelet / Poäng / Viktningar / Struktur",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Poäng / Viktningar / Struktur.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffCapacityBaseMultiplier = {
                    label = "Företagsnätverk / Drift i spelet / Personal / kapacitet / Grundvärde / Multiplikator",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / kapacitet / Grundvärde / Multiplikator.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMax = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Anställning / Lojalitet / Maximum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Anställning / Lojalitet / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMin = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Anställning / Lojalitet / Minimum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Anställning / Lojalitet / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMax = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Anställning / Risk / Maximum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Anställning / Risk / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMin = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Anställning / Risk / Minimum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Anställning / Risk / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMax = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Anställning / Färdighet / Maximum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Anställning / Färdighet / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMin = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Anställning / Färdighet / Minimum",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Anställning / Färdighet / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentLoyaltyWeight = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Incident / Lojalitet / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Incident / Lojalitet / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentMaximumChance = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Incident / Maximum / Chans",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Incident / Maximum / Chans.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem1 = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Incident / Resultat / 1",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Incident / Resultat / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem2 = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Incident / Resultat / 2",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Incident / Resultat / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem3 = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Incident / Resultat / 3",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Incident / Resultat / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem4 = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Incident / Resultat / 4",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Incident / Resultat / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentRiskWeight = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Incident / Risk / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Incident / Risk / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffLoyaltyDecay = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Lojalitet / Förfall",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Lojalitet / Förfall.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffMaximumLevel = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Maximum / Nivå",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Maximum / Nivå.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffPoachedLoyaltyLoss = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Lojalitetsförlust vid värvning",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Lojalitetsförlust vid värvning.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionCostBase = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Skydd / Kostnad / Grundvärde",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Skydd / Kostnad / Grundvärde.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionHours = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Skydd / Timmar",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Skydd / Timmar.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionIncidentReduction = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Skydd / Incident / Minskning",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Skydd / Incident / Minskning.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionRiskCost = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Skydd / Risk / Kostnad",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Skydd / Risk / Kostnad.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryBaseChance = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Återhämtning / Grundvärde / Chans",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Återhämtning / Grundvärde / Chans.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryLoyaltyWeight = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Återhämtning / Lojalitet / Vikt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Återhämtning / Lojalitet / Vikt.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageBaseMultiplier = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Lön / Grundvärde / Multiplikator",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Lön / Grundvärde / Multiplikator.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageLoyaltyGain = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Lön / Lojalitet / vinst",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Lön / Lojalitet / vinst.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageSkillDivisor = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Lön / Färdighet / Divisor",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Lön / Färdighet / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem1 = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Svagheter / 1",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Svagheter / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem2 = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Svagheter / 2",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Svagheter / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem3 = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Svagheter / 3",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Svagheter / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem4 = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Svagheter / 4",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Svagheter / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem5 = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Svagheter / 5",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Svagheter / 5.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem6 = {
                    label = "Företagsnätverk / Drift i spelet / Personal / Svagheter / 6",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Personal / Svagheter / 6.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsContracts = {
                    label = "Företagsnätverk / Drift i spelet / Struktur / Viktningar / Kontrakt",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Struktur / Viktningar / Kontrakt.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsDealers = {
                    label = "Företagsnätverk / Drift i spelet / Struktur / Viktningar / Langare",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Struktur / Viktningar / Langare.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsHubs = {
                    label = "Företagsnätverk / Drift i spelet / Struktur / Viktningar / Distributionscentraler",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Struktur / Viktningar / Distributionscentraler.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsRoutes = {
                    label = "Företagsnätverk / Drift i spelet / Struktur / Viktningar / Rutter",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Struktur / Viktningar / Rutter.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsStaff = {
                    label = "Företagsnätverk / Drift i spelet / Struktur / Viktningar / Personal",
                    description = "Driftinställning för Företagsnätverk / Drift i spelet / Struktur / Viktningar / Personal.",
                },
                drugAdvancedBusinessNetworkSocietyPermission = {
                    label = "Företagsnätverk / Organisation / Behörighet",
                    description = "Driftinställning för Företagsnätverk / Organisation / Behörighet.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseCapacity = {
                    label = "Företagsnätverk / Personal / Gatuförsäljare / Grundvärde / kapacitet",
                    description = "Driftinställning för Företagsnätverk / Personal / Gatuförsäljare / Grundvärde / kapacitet.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseWage = {
                    label = "Företagsnätverk / Personal / Gatuförsäljare / Grundvärde / Lön",
                    description = "Driftinställning för Företagsnätverk / Personal / Gatuförsäljare / Grundvärde / Lön.",
                },
                drugAdvancedBusinessNetworkStaffPusherCommission = {
                    label = "Företagsnätverk / Personal / Gatuförsäljare / Provision",
                    description = "Driftinställning för Företagsnätverk / Personal / Gatuförsäljare / Provision.",
                },
                drugAdvancedBusinessNetworkStaffPusherHirePrice = {
                    label = "Företagsnätverk / Personal / Gatuförsäljare / Anställning / Pris",
                    description = "Driftinställning för Företagsnätverk / Personal / Gatuförsäljare / Anställning / Pris.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseCapacity = {
                    label = "Företagsnätverk / Personal / Kurir / Grundvärde / kapacitet",
                    description = "Driftinställning för Företagsnätverk / Personal / Kurir / Grundvärde / kapacitet.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseWage = {
                    label = "Företagsnätverk / Personal / Kurir / Grundvärde / Lön",
                    description = "Driftinställning för Företagsnätverk / Personal / Kurir / Grundvärde / Lön.",
                },
                drugAdvancedBusinessNetworkStaffRunnerCommission = {
                    label = "Företagsnätverk / Personal / Kurir / Provision",
                    description = "Driftinställning för Företagsnätverk / Personal / Kurir / Provision.",
                },
                drugAdvancedBusinessNetworkStaffRunnerHirePrice = {
                    label = "Företagsnätverk / Personal / Kurir / Anställning / Pris",
                    description = "Driftinställning för Företagsnätverk / Personal / Kurir / Anställning / Pris.",
                },
                drugAdvancedBusinessNetworkTickMinutes = {
                    label = "Företagsnätverk / Uppdateringscykel / Minuter",
                    description = "Driftinställning för Företagsnätverk / Uppdateringscykel / Minuter.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCapacity = {
                    label = "Företagsnätverk / Transporter / Flygplan / kapacitet",
                    description = "Driftinställning för Företagsnätverk / Transporter / Flygplan / kapacitet.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCost = {
                    label = "Företagsnätverk / Transporter / Flygplan / Kostnad",
                    description = "Driftinställning för Företagsnätverk / Transporter / Flygplan / Kostnad.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftDurationMultiplier = {
                    label = "Företagsnätverk / Transporter / Flygplan / Varaktighetsmultiplikator",
                    description = "Driftinställning för Företagsnätverk / Transporter / Flygplan / Varaktighetsmultiplikator.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftRisk = {
                    label = "Företagsnätverk / Transporter / Flygplan / Risk",
                    description = "Driftinställning för Företagsnätverk / Transporter / Flygplan / Risk.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCapacity = {
                    label = "Företagsnätverk / Transporter / Båt / kapacitet",
                    description = "Driftinställning för Företagsnätverk / Transporter / Båt / kapacitet.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCost = {
                    label = "Företagsnätverk / Transporter / Båt / Kostnad",
                    description = "Driftinställning för Företagsnätverk / Transporter / Båt / Kostnad.",
                },
                drugAdvancedBusinessNetworkTransportsBoatDurationMultiplier = {
                    label = "Företagsnätverk / Transporter / Båt / Varaktighetsmultiplikator",
                    description = "Driftinställning för Företagsnätverk / Transporter / Båt / Varaktighetsmultiplikator.",
                },
                drugAdvancedBusinessNetworkTransportsBoatRisk = {
                    label = "Företagsnätverk / Transporter / Båt / Risk",
                    description = "Driftinställning för Företagsnätverk / Transporter / Båt / Risk.",
                },
                drugAdvancedBusinessNetworkTransportsCarCapacity = {
                    label = "Företagsnätverk / Transporter / Bil / kapacitet",
                    description = "Driftinställning för Företagsnätverk / Transporter / Bil / kapacitet.",
                },
                drugAdvancedBusinessNetworkTransportsCarCost = {
                    label = "Företagsnätverk / Transporter / Bil / Kostnad",
                    description = "Driftinställning för Företagsnätverk / Transporter / Bil / Kostnad.",
                },
                drugAdvancedBusinessNetworkTransportsCarDurationMultiplier = {
                    label = "Företagsnätverk / Transporter / Bil / Varaktighetsmultiplikator",
                    description = "Driftinställning för Företagsnätverk / Transporter / Bil / Varaktighetsmultiplikator.",
                },
                drugAdvancedBusinessNetworkTransportsCarRisk = {
                    label = "Företagsnätverk / Transporter / Bil / Risk",
                    description = "Driftinställning för Företagsnätverk / Transporter / Bil / Risk.",
                },
                drugAdvancedBusinessNetworkTransportsFootCapacity = {
                    label = "Företagsnätverk / Transporter / Till fots / kapacitet",
                    description = "Driftinställning för Företagsnätverk / Transporter / Till fots / kapacitet.",
                },
                drugAdvancedBusinessNetworkTransportsFootCost = {
                    label = "Företagsnätverk / Transporter / Till fots / Kostnad",
                    description = "Driftinställning för Företagsnätverk / Transporter / Till fots / Kostnad.",
                },
                drugAdvancedBusinessNetworkTransportsFootDurationMultiplier = {
                    label = "Företagsnätverk / Transporter / Till fots / Varaktighetsmultiplikator",
                    description = "Driftinställning för Företagsnätverk / Transporter / Till fots / Varaktighetsmultiplikator.",
                },
                drugAdvancedBusinessNetworkTransportsFootRisk = {
                    label = "Företagsnätverk / Transporter / Till fots / Risk",
                    description = "Driftinställning för Företagsnätverk / Transporter / Till fots / Risk.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCapacity = {
                    label = "Företagsnätverk / Transporter / Lastbil / kapacitet",
                    description = "Driftinställning för Företagsnätverk / Transporter / Lastbil / kapacitet.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCost = {
                    label = "Företagsnätverk / Transporter / Lastbil / Kostnad",
                    description = "Driftinställning för Företagsnätverk / Transporter / Lastbil / Kostnad.",
                },
                drugAdvancedBusinessNetworkTransportsTruckDurationMultiplier = {
                    label = "Företagsnätverk / Transporter / Lastbil / Varaktighetsmultiplikator",
                    description = "Driftinställning för Företagsnätverk / Transporter / Lastbil / Varaktighetsmultiplikator.",
                },
                drugAdvancedBusinessNetworkTransportsTruckRisk = {
                    label = "Företagsnätverk / Transporter / Lastbil / Risk",
                    description = "Driftinställning för Företagsnätverk / Transporter / Lastbil / Risk.",
                },
                drugAdvancedBusinessNetworkTransportsVanCapacity = {
                    label = "Företagsnätverk / Transporter / Skåpbil / kapacitet",
                    description = "Driftinställning för Företagsnätverk / Transporter / Skåpbil / kapacitet.",
                },
                drugAdvancedBusinessNetworkTransportsVanCost = {
                    label = "Företagsnätverk / Transporter / Skåpbil / Kostnad",
                    description = "Driftinställning för Företagsnätverk / Transporter / Skåpbil / Kostnad.",
                },
                drugAdvancedBusinessNetworkTransportsVanDurationMultiplier = {
                    label = "Företagsnätverk / Transporter / Skåpbil / Varaktighetsmultiplikator",
                    description = "Driftinställning för Företagsnätverk / Transporter / Skåpbil / Varaktighetsmultiplikator.",
                },
                drugAdvancedBusinessNetworkTransportsVanRisk = {
                    label = "Företagsnätverk / Transporter / Skåpbil / Risk",
                    description = "Driftinställning för Företagsnätverk / Transporter / Skåpbil / Risk.",
                },
                interrogationDispatchAdapter = {
                    options = {
                        sky_jobs_base = "Sky Jobs Base",
                        generic = "Generell integration",
                        custom = "Egen integration",
                        none = "Inaktiverad",
                    },
                },
                reputationRules = {
                    label = "Ryktesregler",
                    description = "Ställ in namngivna regler för handlingar och valfria mål. Endast aktiverade regler ger poäng.",
                },
            },
            territoryMap = {
                addPoint = "Lägg till punkt",
                clear = "Rensa",
                create = "Skapa",
                custom = "Anpassade territorier",
                deletePoint = "Ta bort punkt",
                eyebrow = "Territorie-editor",
                minimum = "Minst 3",
                pointCount = "{count} punkter",
                presets = "Förinställda distrikt",
                shown = "Visas på kartan",
                street = "Gata",
                supply = "Leverans",
                territories = "Territorier",
                type = "Territoriell typ",
                undo = "Ångra",
            },
            shopPositionTools = {
                currentPosition = "Använd nuvarande position",
                selectEntity = "Välj objekt",
                selectEntityHint = "Sikta lasern på en kassa eller ett kassaskåp. Enter: använd det markerade objektets position och riktning. Backspace: avbryt.",
            },
            drugSettingSubsections = {
                cultivationLevels = "Odlingsnivåer",
                general = "Allmänt",
                runtime = "Åtkomst till spelåtgärder",
                quality = "Kvalitet",
                packaging = "Förpackning",
                growing = "Odling",
                labs = "Laboratorier och husbilar",
                power = "Ström och utrustning",
                workers = "Arbetare",
                market = "Marknad och distribution",
                threats = "Räder och sabotage",
                pvpTakeovers = "Laboratorieövertaganden",
                consumption = "Konsumtion",
                processing = "Bearbetning",
                performance = "Prestanda",
                dynamicMarket = "Dynamisk marknad",
                heat = "Polisuppmärksamhet och risk",
                contacts = "Kontaktnätverk",
                business = "Företagsnätverk",
            },
            drugSettingGroups = {
                cultivationGeneral = { label = "Allmänt" },
                cultivationCurve = { label = "Nivåkurva" },
                cultivationExperience = { label = "XP-belöningar" },
                cultivationUnlocks = { label = "Nivåupplåsningar" },
                creator = {
                    label = "Öppna redigeraren",
                },
                creatorSettings = {
                    label = "Redigerarinställningar",
                },
                interfaceHud = {
                    label = "Gränssnittspositioner",
                },
                drugsGeneral = {
                    label = "Allmänt",
                },
                runtimeAccess = {
                    label = "Åtkomst och ägande",
                },
                runtimePayouts = {
                    label = "Utbetalningar",
                },
                runtimeDispatch = {
                    label = "Ledningscentral och polis",
                },
                qualityWeights = {
                    label = "Kvalitet / Viktningar",
                },
                qualityTiers = {
                    label = "Kvalitet / Kvalitetsnivåer",
                },
                packagingGeneral = {
                    label = "Allmänt",
                },
                growingGeneral = {
                    label = "Allmänt",
                },
                plantDefaults = {
                    label = "Växt / Standardvärden",
                },
                harvestWindow = {
                    label = "Skörd / Tidsfönster",
                },
                labsGeneral = {
                    label = "Allmänt",
                },
                labRent = {
                    label = "Hyra och livscykel",
                },
                camperDefaults = {
                    label = "Husvagn",
                },
                labUpgrades = {
                    label = "Uppgraderingar",
                },
                labDefaults = {
                    label = "Lab / Standardvärden",
                },
                powerGeneral = {
                    label = "Allmänt",
                },
                generators = {
                    label = "Generatorer",
                },
                equipmentWear = {
                    label = "Utrustning",
                },
                workersGeneral = {
                    label = "Allmänt",
                },
                marketGeneral = {
                    label = "Allmänt",
                },
                marketPrices = {
                    label = "Priser",
                },
                distribution = {
                    label = "Fördelning",
                },
                threatsGeneral = {
                    label = "Allmänt",
                },
                threatHeat = {
                    label = "Polistryck",
                },
                threatChances = {
                    label = "Sannolikheter",
                },
                pvpTakeoverRules = {
                    label = "Övertagningsregler",
                },
                pvpTakeoverZones = {
                    label = "Zoner & Tidsschema",
                },
                pvpTakeoverMethods = {
                    label = "Inbrottsmetoder",
                },
                consumptionGeneral = {
                    label = "Allmänt",
                },
                consumerDecay = {
                    label = "Minskning av tolerans och beroende",
                },
                consumerEffects = {
                    label = "Effekter och risker",
                },
                processingFlow = {
                    label = "Bearbetningsflöde",
                },
                processingGeneral = {
                    label = "Allmänt",
                },
                powerRuntime = {
                    label = "Drift i spelet",
                },
                powerHeat = {
                    label = "Polisuppmärksamhet och elmönster",
                },
                powerModes = {
                    label = "Hantering / Lägen",
                },
                powerPriorities = {
                    label = "Belastning / Prioriteringar",
                },
                performanceInactiveControlIntervalMs = {
                    label = "Inaktiv / Kontroll / Intervall / ms",
                },
                performanceInteractionIdleScanIntervalMs = {
                    label = "Interaktion / Idle / Skanningsintervall / ms",
                },
                performanceInteractionPromptIntervalMs = {
                    label = "Interaktion / Interaktionsmeddelande / Intervall / ms",
                },
                performanceInteractionScanIntervalMs = {
                    label = "Interaktion / Skanningsintervall / ms",
                },
                performanceMinimumScanIntervalMs = {
                    label = "Minimum / Skanningsintervall / ms",
                },
                performanceStreetPedActivationDistance = {
                    label = "Gata / Ped / Aktivering / Avstånd",
                },
                performanceStreetPedIdleScanIntervalMs = {
                    label = "Gata / Ped / Idle / Skanningsintervall / ms",
                },
                performanceStreetPedScanIntervalMs = {
                    label = "Gata / Ped / Skanningsintervall / ms",
                },
                performanceWorldCachePadding = {
                    label = "Värld / Cache / Extra marginal",
                },
                performanceWorldCacheRefreshIntervalMs = {
                    label = "Värld / Cache / Uppdatering / Intervall / ms",
                },
                performanceWorldIdleIntervalMs = {
                    label = "Värld / Idle / Intervall / ms",
                },
                dynamicMarketActionCooldownSeconds = {
                    label = "Återhämtningstid för handlingar / sekunder",
                },
                dynamicMarketActionHistoryLimit = {
                    label = "Handling / Historikgräns",
                },
                dynamicMarketAmountSaturationWeight = {
                    label = "Mängd / Mättnad / Vikt",
                },
                dynamicMarketBaseIntelAccuracy = {
                    label = "Grundvärde / Informationens noggrannhet",
                },
                dynamicMarketDefaultAverageQuality = {
                    label = "Standardvärde / Genomsnitt / Kvalitet",
                },
                dynamicMarketDefaultResourceElasticity = {
                    label = "Standardvärde / Resurs / Elasticitet",
                },
                dynamicMarketDemandCenter = {
                    label = "Efterfrågan / Mittvärde",
                },
                dynamicMarketDemandPriceImpact = {
                    label = "Efterfrågan / Pris / Påverkan",
                },
                dynamicMarketDirectionThreshold = {
                    label = "Riktning / Tröskelvärde",
                },
                dynamicMarketEnabled = {
                    label = "Aktiverad",
                },
                dynamicMarketEventChance = {
                    label = "Händelse / Chans",
                },
                dynamicMarketEventDurationMinutes = {
                    label = "Händelse / Varaktighet / Minuter",
                },
                dynamicMarketEventMinimumDurationMinutes = {
                    label = "Händelse / Minimum / Varaktighet / Minuter",
                },
                dynamicMarketEventStrengthMaximum = {
                    label = "Händelse / Styrka / Maximum",
                },
                dynamicMarketEventStrengthMinimum = {
                    label = "Händelse / Styrka / Minimum",
                },
                dynamicMarketEvents = {
                    label = "Händelser",
                },
                dynamicMarketExactIntelReputation = {
                    label = "Exakt information / Rykte",
                },
                dynamicMarketExactIntelTrust = {
                    label = "Exakt information / Förtroende",
                },
                dynamicMarketGlobalZoneLabel = {
                    label = "Global / Zon / Etikett",
                },
                dynamicMarketHistoryLimit = {
                    label = "Historikgräns",
                },
                dynamicMarketInitialDemand = {
                    label = "Startvärde / Efterfrågan",
                },
                dynamicMarketInitialPriceMultiplier = {
                    label = "Startvärde / Prismultiplikator",
                },
                dynamicMarketIntelDemandError = {
                    label = "Underrättelser / Efterfrågan / Fel",
                },
                dynamicMarketIntelMaximumAccuracy = {
                    label = "Underrättelser / Maximum / Precision",
                },
                dynamicMarketIntelMinimumAccuracy = {
                    label = "Underrättelser / Minimum / Precision",
                },
                dynamicMarketIntelPoliceError = {
                    label = "Underrättelser / Polis / Fel",
                },
                dynamicMarketIntelPriceError = {
                    label = "Underrättelser / Pris / Fel",
                },
                dynamicMarketIntelPriceMaximum = {
                    label = "Underrättelser / Pris / Maximum",
                },
                dynamicMarketIntelPriceMinimum = {
                    label = "Underrättelser / Pris / Minimum",
                },
                dynamicMarketIntelReputationWeight = {
                    label = "Underrättelser / Rykte / Vikt",
                },
                dynamicMarketIntelResourcePriceError = {
                    label = "Underrättelser / Resurs / Pris / Fel",
                },
                dynamicMarketIntelSaturationError = {
                    label = "Underrättelser / Mättnad / Fel",
                },
                dynamicMarketIntelSeedBucketSeconds = {
                    label = "Tidsfönster för informationens slumpfrö / sekunder",
                },
                dynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Underrättelser / Status / Precision / Tröskelvärde",
                },
                dynamicMarketIntelStatusErrorThreshold = {
                    label = "Underrättelser / Status / Fel / Tröskelvärde",
                },
                dynamicMarketIntelSupplyError = {
                    label = "Underrättelser / Leverans / Fel",
                },
                dynamicMarketIntelTrustWeight = {
                    label = "Underrättelser / Förtroende / Vikt",
                },
                dynamicMarketManipulationCooldownMinutes = {
                    label = "Manipulation / Nedkylningsminuter",
                },
                dynamicMarketManipulationDemandShift = {
                    label = "Manipulation / Efterfrågan / Förskjutning",
                },
                dynamicMarketManipulationDurationMinutes = {
                    label = "Manipulation / Varaktighet / Minuter",
                },
                dynamicMarketManipulationHeat = {
                    label = "Manipulation / Polistryck",
                },
                dynamicMarketManipulationMinimumBatchAmount = {
                    label = "Manipulation / Minimum / Parti / Mängd",
                },
                dynamicMarketManipulationPaymentAccount = {
                    label = "Manipulation / Betalkonto",
                },
                dynamicMarketManipulationPrice = {
                    label = "Manipulation / Pris",
                },
                dynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Manipulation / Zon / Polistryck / Multiplikator",
                },
                dynamicMarketMaximumIntelAgeMinutes = {
                    label = "Maximum / Informationens ålder / Minuter",
                },
                dynamicMarketMaximumPriceMultiplier = {
                    label = "Maximum / Prismultiplikator",
                },
                dynamicMarketMinimumIntelAgeMinutes = {
                    label = "Minimum / Informationens ålder / Minuter",
                },
                dynamicMarketMinimumMetricWindowMinutes = {
                    label = "Minimum / Mätvärde / Tidsfönster / Minuter",
                },
                dynamicMarketMinimumPriceMultiplier = {
                    label = "Minsta pris / Multiplikator",
                },
                dynamicMarketMinimumUpdateMinutes = {
                    label = "Minimum / Uppdatering / Minuter",
                },
                dynamicMarketPoliceDemandWeight = {
                    label = "Polis / Efterfrågan / Vikt",
                },
                dynamicMarketPolicePriceImpact = {
                    label = "Polis / Pris / Påverkan",
                },
                dynamicMarketPoorQualityDemandPenalty = {
                    label = "Dålig kvalitet / Efterfrågan / Avdrag",
                },
                dynamicMarketPoorQualityThreshold = {
                    label = "Dålig kvalitet / Tröskelvärde",
                },
                dynamicMarketPremiumQualityDemandBonus = {
                    label = "Premiumkvalitet / Efterfrågebonus",
                },
                dynamicMarketPremiumQualityThreshold = {
                    label = "Premiumkvalitet / Tröskelvärde",
                },
                dynamicMarketProductionSupplyWeight = {
                    label = "Produktion / Leverans / Vikt",
                },
                dynamicMarketProductionWindowMinutes = {
                    label = "Produktion / Tidsfönster / Minuter",
                },
                dynamicMarketQualityCenter = {
                    label = "Kvalitet / Mittvärde",
                },
                dynamicMarketQualityConfidenceImpact = {
                    label = "Kvalitet / Förtroende / Påverkan",
                },
                dynamicMarketQualityRange = {
                    label = "Kvalitet / Värdeintervall",
                },
                dynamicMarketRarityBonusMaximum = {
                    label = "Sällsynthet / Bonus / Maximum",
                },
                dynamicMarketRegionalGlobalWeight = {
                    label = "Regional / Global / Vikt",
                },
                dynamicMarketRegionalLocalWeight = {
                    label = "Regional / Lokal / Vikt",
                },
                dynamicMarketResourceAliases = {
                    label = "Resurs / Alternativa namn",
                },
                dynamicMarketResourceDirectionFallThreshold = {
                    label = "Resurs / Riktning / Nedgång / Tröskelvärde",
                },
                dynamicMarketResourceDirectionRiseThreshold = {
                    label = "Resurs / Riktning / Ökning / Tröskelvärde",
                },
                dynamicMarketResources = {
                    label = "Resurser",
                },
                dynamicMarketSalesWindowMinutes = {
                    label = "Försäljning / Tidsfönster / Minuter",
                },
                dynamicMarketSaturationDemandWeight = {
                    label = "Mättnad / Efterfrågan / Vikt",
                },
                dynamicMarketSaturationPriceImpact = {
                    label = "Mättnad / Pris / Påverkan",
                },
                dynamicMarketScarcityDemandWeight = {
                    label = "Brist / Efterfrågan / Vikt",
                },
                dynamicMarketScarcityPriceImpact = {
                    label = "Brist / Pris / Påverkan",
                },
                dynamicMarketSeasonEndMonths = {
                    label = "Årstid / Slut / Månader",
                },
                dynamicMarketSeasonMultipliers = {
                    label = "Årstid / Multiplikatorer",
                },
                dynamicMarketShortageRumorThreshold = {
                    label = "Brist / Rykte / Tröskelvärde",
                },
                dynamicMarketStatusThresholds = {
                    label = "Status / Tröskelvärden",
                },
                dynamicMarketTargetSupply = {
                    label = "Mål / Leverans",
                },
                dynamicMarketTrendChance = {
                    label = "Trend / Chans",
                },
                dynamicMarketTrendDurationMinutes = {
                    label = "Trend / Varaktighet / Minuter",
                },
                dynamicMarketTrendMaximumStrength = {
                    label = "Trend / Maximum / Styrka",
                },
                dynamicMarketTrendMinimumStrength = {
                    label = "Trend / Minimum / Styrka",
                },
                dynamicMarketUpdateMinutes = {
                    label = "Uppdatering / Minuter",
                },
                dynamicMarketVolatilityMaximum = {
                    label = "Prisvolatilitet / Maximum",
                },
                dynamicMarketVolatilityMinimum = {
                    label = "Prisvolatilitet / Minimum",
                },
                dynamicMarketWeatherMultipliers = {
                    label = "Väder / Multiplikatorer",
                },
                dynamicMarketWeatherState = {
                    label = "Väder / Status",
                },
                heatActionCooldownSeconds = {
                    label = "Återhämtningstid för handlingar / sekunder",
                },
                heatActivityRiskWeights = {
                    label = "Aktivitet / Risk / Viktningar",
                },
                heatAggressiveHeatMultiplier = {
                    label = "Aggressivt arbetssätt / Polistryck / Multiplikator",
                },
                heatBurnerBurnThreshold = {
                    label = "Engångstelefon / Avslöjande / Tröskelvärde",
                },
                heatBurnerHeatPerWholesale = {
                    label = "Engångstelefon / Polistryck / Per grossistaffär",
                },
                heatBurnerPhoneItem = {
                    label = "Engångsmobil / Föremål",
                },
                heatCamperOperationalHeatMultiplier = {
                    label = "Husbil i drift / Polistryck / Multiplikator",
                },
                heatCamperOperationalHeatThreshold = {
                    label = "Husbil i drift / Polistryck / Tröskelvärde",
                },
                heatCamperParkedHeat = {
                    label = "Parkerad husbil / Polistryck",
                },
                heatContaminatedHeatMultiplier = {
                    label = "Förorening / Polistryck / Multiplikator",
                },
                heatContaminatedThreshold = {
                    label = "Förorening / Tröskelvärde",
                },
                heatCultivationFreePlants = {
                    label = "Odling / Plantor utan extra risk",
                },
                heatCultivationHeatPerPlant = {
                    label = "Odling / Polistryck / Per planta",
                },
                heatDealerHiddenMinutes = {
                    label = "Återförsäljare / dolt / Minuter",
                },
                heatDecayPerTick = {
                    label = "Förfall / Per uppdateringscykel",
                },
                heatEnabled = {
                    label = "Aktiverad",
                },
                heatEnforcementHeat = {
                    label = "Polisnärvaro / Polistryck",
                },
                heatEnforcementMultipliers = {
                    label = "Polisnärvaro / Multiplikatorer",
                },
                heatEntityTypes = {
                    label = "Spelobjekt / Typer",
                },
                heatEventCooldownMinutes = {
                    label = "Händelse / Nedkylningsminuter",
                },
                heatEventHistoryLimit = {
                    label = "Händelse / Historikgräns",
                },
                heatLabHeatSyncThreshold = {
                    label = "Lab / Polistryck / Synkronisering / Tröskelvärde",
                },
                heatLayLowCooldownMinutes = {
                    label = "Ligga lågt / Nedkylningsminuter",
                },
                heatLayLowIdleMinutes = {
                    label = "Ligga lågt / Idle / Minuter",
                },
                heatLayLowReduction = {
                    label = "Ligga lågt / Minskning",
                },
                heatLockdownMinutes = {
                    label = "Nedstängning / Minuter",
                },
                heatMinimumDurationMinutes = {
                    label = "Minimum / Varaktighet / Minuter",
                },
                heatMinimumEventCooldownSeconds = {
                    label = "Minimum / Händelse / Nedkylning (sekunder)",
                },
                heatMinimumIdleSeconds = {
                    label = "Minimum / Idle / sekunder",
                },
                heatProcessingHeatMultiplier = {
                    label = "Bearbetning / Polistryck / Multiplikator",
                },
                heatRiskWeights = {
                    label = "Risk / Viktningar",
                },
                heatRotateBurnerReduction = {
                    label = "Byt engångstelefon / Minskning",
                },
                heatRouteControlMinutes = {
                    label = "Rutt / Kontroll / Minuter",
                },
                heatSaleHeat = {
                    label = "Försäljning / Polistryck",
                },
                heatThresholds = {
                    label = "Tröskelvärden",
                },
                heatTickMinutes = {
                    label = "Uppdateringscykel / Minuter",
                },
                heatWholesaleHeatMultiplier = {
                    label = "Grossist / Polistryck / Multiplikator",
                },
                heatWorkerLeakAlertRadius = {
                    label = "Arbetare / Informationsläcka / Larmradie",
                },
                heatWorkerLeakBaseChance = {
                    label = "Arbetare / Informationsläcka / Grundvärde / Chans",
                },
                heatWorkerLeakFactionMultiplier = {
                    label = "Arbetare / Informationsläcka / Fraktion / Multiplikator",
                },
                heatWorkerLeakHighSeverityThreshold = {
                    label = "Arbetare / Informationsläcka / Hög / Allvarlighetsgrad / Tröskelvärde",
                },
                heatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Arbetare / Informationsläcka / Lojalitet / Chans / Multiplikator",
                },
                heatWorkerLeakLoyaltyThreshold = {
                    label = "Arbetare / Informationsläcka / Lojalitet / Tröskelvärde",
                },
                heatWorkerLeakMaximumChance = {
                    label = "Arbetare / Informationsläcka / Maximum / Chans",
                },
                heatWorkerLeakMinimumCooldownSeconds = {
                    label = "Arbetare / Informationsläcka / Minimum / Nedkylning (sekunder)",
                },
                heatWorkerLeakRouteMultiplier = {
                    label = "Arbetare / Informationsläcka / Rutt / Multiplikator",
                },
                heatWorkerLeakStrengthMaximum = {
                    label = "Arbetare / Informationsläcka / Styrka / Maximum",
                },
                heatWorkerLeakStrengthMinimum = {
                    label = "Arbetare / Informationsläcka / Styrka / Minimum",
                },
                heatWorkerLeakStrengthMultiplier = {
                    label = "Arbetare / Informationsläcka / Styrka / Multiplikator",
                },
                heatWorkerLeakStressChanceMultiplier = {
                    label = "Arbetare / Informationsläcka / Stress / Chans / Multiplikator",
                },
                heatWorkerLeakStressThreshold = {
                    label = "Arbetare / Informationsläcka / Stress / Tröskelvärde",
                },
                contactsActionCooldownSeconds = {
                    label = "Återhämtningstid för handlingar / sekunder",
                },
                contactsActiveHotspotCount = {
                    label = "Antal aktiva platser",
                },
                contactsBurnerHintTrust = {
                    label = "Burner-tips / Förtroende",
                },
                contactsBurnerOfferMaximumMultiplier = {
                    label = "Engångstelefon / Erbjudande / Maximum / Multiplikator",
                },
                contactsBurnerOfferMinimumMultiplier = {
                    label = "Engångstelefon / Erbjudande / Minimum / Multiplikator",
                },
                contactsBuyerCooldownMinutes = {
                    label = "Köpare / Nedkylningsminuter",
                },
                contactsBuyerDeliveryDistance = {
                    label = "Köpare / Inlämningsavstånd",
                },
                contactsBuyerPremiumSuccessScore = {
                    label = "Köpare / Premium / Framgång / Poäng",
                },
                contactsBuyerPremiumTrustGain = {
                    label = "Köpare / Premium / Förtroende / vinst",
                },
                contactsBuyerRequestHeatRiskWeight = {
                    label = "Köpare / Begäran / Efterlysning & Risk / Vikt",
                },
                contactsBuyerStandardTrustGain = {
                    label = "Köpare / Standard / Förtroende / vinst",
                },
                contactsContactActiveDelaySeconds = {
                    label = "Fördröjning för kontaktaktivering / sekunder",
                },
                contactsContactDemandRange = {
                    label = "Kontakt / Efterfrågan / Värdeintervall",
                },
                contactsContactLossTrust = {
                    label = "Kontakt / Förlust / Förtroende",
                },
                contactsDarknetExactIntelMinutes = {
                    label = "Darknet / Exakt information / Minuter",
                },
                contactsDarknetHotspotIntelPrice = {
                    label = "Darknet / Aktivt område / Underrättelser / Pris",
                },
                contactsDarknetIntelPrice = {
                    label = "Darknet / Underrättelser / Pris",
                },
                contactsDealerBasePrice = {
                    label = "Återförsäljare / Baspris",
                },
                contactsDealerHireCapacity = {
                    label = "Återförsäljare / Anställning / kapacitet",
                },
                contactsDealerHireRisk = {
                    label = "Återförsäljare / Anställning / Risk",
                },
                contactsDealerHireSkill = {
                    label = "Återförsäljare / Anställning / Färdighet",
                },
                contactsDealerOffers = {
                    label = "Dealer-erbjudanden",
                },
                contactsDealerProtectionHours = {
                    label = "Återförsäljare / Skydd / Timmar",
                },
                contactsDealerProtectionPrice = {
                    label = "Återförsäljare / Skydd / Pris",
                },
                contactsDealerSaleMax = {
                    label = "Återförsäljare / Försäljning / Maximum",
                },
                contactsDealerSaleMin = {
                    label = "Återförsäljare / Försäljning / Minimum",
                },
                contactsDealerSimulation = {
                    label = "Återförsäljare / Simulering",
                },
                contactsDealerTickMinutes = {
                    label = "Återförsäljare / Uppdateringscykel / Minuter",
                },
                contactsDealerWage = {
                    label = "Återförsäljare / Lön",
                },
                contactsDealerWageDecay = {
                    label = "Återförsäljare / Lön / Förfall",
                },
                contactsDealerWageLoyaltyGain = {
                    label = "Återförsäljare / Lön / Lojalitet / vinst",
                },
                contactsDealerWeaknesses = {
                    label = "Återförsäljare / Svagheter",
                },
                contactsDefaultContactDemand = {
                    label = "Standardvärde / Kontakt / Efterfrågan",
                },
                contactsDefaultContactRisk = {
                    label = "Standardvärde / Kontakt / Risk",
                },
                contactsDefaultDealerCapacity = {
                    label = "Standardlangare / kapacitet",
                },
                contactsDefaultDealerRisk = {
                    label = "Standardlangare / Risk",
                },
                contactsDefaultDealerSkill = {
                    label = "Standardlangare / Färdighet",
                },
                contactsDefaultHotspotRadius = {
                    label = "Standardvärde / Aktivt område / Radie",
                },
                contactsDemandResetMinutes = {
                    label = "Återställning av efterfrågan (minuter)",
                },
                contactsEnabled = {
                    label = "Aktiverad",
                },
                contactsExactLocationTrust = {
                    label = "Exakt plats / Förtroende",
                },
                contactsFactionDiscoveryReputation = {
                    label = "Fraktion / Upptäckt / Rykte",
                },
                contactsFactionHintTrust = {
                    label = "Fraktion / Ledtråd / Förtroende",
                },
                contactsFailedDeliveryCooldownMinutes = {
                    label = "Misslyckad leverans / Nedkylningsminuter",
                },
                contactsFakeDealEncounter = {
                    label = "Falsk affär / Möte",
                },
                contactsFallbackPreferredDrug = {
                    label = "Reservvärde / Föredragen drog",
                },
                contactsFallbackProductLabel = {
                    label = "Reservvärde / Produktnamn",
                },
                contactsGuideBookItem = {
                    label = "Guide / Bok / Föremål",
                },
                contactsGuideBookTrust = {
                    label = "Guide / Bok / Förtroende",
                },
                contactsHireDealerPrice = {
                    label = "Anställ dealer / Pris",
                },
                contactsHistoryLimit = {
                    label = "Historikgräns",
                },
                contactsHotspotIntelMinutes = {
                    label = "Aktivt område / Underrättelser / Minuter",
                },
                contactsHotspotRotationMinutes = {
                    label = "Aktivt område / Byte / Minuter",
                },
                contactsListingDurationMinutes = {
                    label = "Annons / Varaktighet / Minuter",
                },
                contactsMaxOwnedDealers = {
                    label = "Maximum / Ägd / Langare",
                },
                contactsMinimumBuyerDeliveryDistance = {
                    label = "Minimum / Köpare / Inlämningsavstånd",
                },
                contactsMinimumContactRotationMinutes = {
                    label = "Minimum / Kontaktrotation (minuter)",
                },
                contactsMinimumDemandResetMinutes = {
                    label = "Minimum / Återställning av efterfrågan (minuter)",
                },
                contactsMinimumHeatMultiplier = {
                    label = "Minimum / Polistryck / Multiplikator",
                },
                contactsMinimumHotspotIntelMinutes = {
                    label = "Minimum / Aktivt område / Underrättelser / Minuter",
                },
                contactsMinimumHotspotRadius = {
                    label = "Minimum / Aktivt område / Radie",
                },
                contactsMinimumHotspotRotationMinutes = {
                    label = "Minimum / Aktivt område / Byte / Minuter",
                },
                contactsMinimumListingDurationMinutes = {
                    label = "Minimum / Annons / Varaktighet / Minuter",
                },
                contactsMinimumRewardMultiplier = {
                    label = "Minsta belöning / Multiplikator",
                },
                contactsMinimumRobberyMultiplier = {
                    label = "Minimum / Rån / Multiplikator",
                },
                contactsMinimumSpotPriceMultiplier = {
                    label = "Minimum / Plats / Prismultiplikator",
                },
                contactsOtherDrugPriceMultiplier = {
                    label = "Övrigt / Droger / Prismultiplikator",
                },
                contactsPaymentAccount = {
                    label = "Betalkonto",
                },
                contactsPostDeliveryDemandResetSeconds = {
                    label = "Efter leverans / Efterfrågan / Reset / sekunder",
                },
                contactsPreferredDrugPriceMultiplier = {
                    label = "Föredragen drog / Prismultiplikator",
                },
                contactsRegionLocationTrust = {
                    label = "Region / Plats / Förtroende",
                },
                contactsRequestAmounts = {
                    label = "Begäran / Mängder",
                },
                contactsRotationMinutes = {
                    label = "Byte / Minuter",
                },
                contactsSpotPools = {
                    label = "Plats / Urvalsgrupper",
                },
                contactsStreetHotspots = {
                    label = "Gata / Aktiva områden",
                },
                contactsTrustLevels = {
                    label = "Förtroende / Nivåer",
                },
                businessActionCooldownSeconds = {
                    label = "Återhämtningstid för handlingar / sekunder",
                },
                businessBalance = {
                    label = "Saldo",
                },
                businessContracts = {
                    label = "Kontrakt",
                },
                businessDefaultBusinessName = {
                    label = "Standardvärde / Företagsnamn",
                },
                businessDefaultRankId = {
                    label = "Standardvärde / Rang / ID",
                },
                businessDefaultStaffStyle = {
                    label = "Standardvärde / Personal / Arbetssätt",
                },
                businessDefaultTransport = {
                    label = "Standardvärde / Transporter",
                },
                businessEnabled = {
                    label = "Aktiverad",
                },
                businessHubs = {
                    label = "Distributionscentraler",
                },
                businessLimits = {
                    label = "Gränser",
                },
                businessPayments = {
                    label = "Betalningar",
                },
                businessPayoutAccount = {
                    label = "Utbetalning / Konto",
                },
                businessRanks = {
                    label = "Grader",
                },
                businessReportDays = {
                    label = "Rapportperiod / dagar",
                },
                businessRouteEndpointTypes = {
                    label = "Rutt / Slutpunkt / Typer",
                },
                businessRuntime = {
                    label = "Drift i spelet",
                },
                businessSocietyPermission = {
                    label = "Organisation / Behörighet",
                },
                businessStaff = {
                    label = "Personal",
                },
                businessTickMinutes = {
                    label = "Uppdateringscykel / Minuter",
                },
                businessTransports = {
                    label = "Transporter",
                },
            },
            territorySettings = {
                section = "Territorier",
                zonesGroup = "Territoriezoner",
                sourceLabel = "Zonkälla",
                sourceDescription = "Använd de skyddade förinställda distrikten eller definiera dina egna territoriepolygon.",
                sourcePreset = "Förinställda distrikt",
                sourceCustom = "Anpassade territorier",
                editLabel = "Territorie-editor",
                editDescription = "Redigera distrikten som används av den valda zonkällan.",
                editButton = "Redigera territorier",
                presetSection = "Förinställda distrikt",
                presetEntry = "Förinställt distrikt",
                customSection = "Anpassade territorier",
                customEntry = "Eget territorium",
                typeLabel = "Territorietyp",
                streetType = "Gata",
                supplyType = "Leverans",
                enabledLabel = "Visa på karta",
                enabledDescription = "Inaktiverade förinställda distrikt tas bort från kartan och kan inte göras anspråk på.",
                zoneLabel = "Territoriegräns",
                zoneDescription = "Lägg till minst tre punkter i ordning runt territoriegränsen.",
                ownershipGroup = "Ägarskap",
                decayGroup = "Förfall",
                presenceGroup = "Närvaro",
                activityGroup = "Aktivitetspoäng",
                ownershipBenefitsGroup = "Ägarförmåner",
                ownershipThresholdLabel = "Ägarskapströskel",
                ownershipThresholdDescription = "Kontrollprocent som ett gäng måste överskrida för att officiellt äga ett territorium.",
                activityFloorLabel = "Fast aktivitetsgolv",
                activityFloorDescription = "Nödvändiga inflyteljepoäng när storleksbaserade golv är inaktiverade.",
                floorByZoneSizeLabel = "Skala golv efter zonstorlek",
                floorByZoneSizeDescription = "Beräknar varje territoriums aktivitetsgolv från dess polygonarea istället för att använda det fasta golvet.",
                floorPointsPerSizeUnitLabel = "Golvpoäng per km²",
                floorPointsPerSizeUnitDescription = "Nödvändiga aktivitetsgolvpoäng för varje kvadratkilometer av territoriearea.",
                fixedFloorRequirement = "Inaktivera storleksbaserade golv för att redigera det fasta aktivitetsgolvet.",
                sizeFloorRequirement = "Aktivera storleksbaserade golv för att redigera poäng per kvadratkilometer.",
                dailyDecayLabel = "Dagligt inflytelseförfall",
                dailyDecayDescription = "Procentuell inflytelse som tas bort var 24:e timme.",
                presenceIntervalLabel = "Närvarointervall",
                presenceIntervalDescription = "Minuter mellan automatiska utdelningar av närvaropoäng.",
                presencePointsLabel = "Närvaropoäng per medlem",
                presencePointsDescription = "Närvaropoäng som delas ut till varje kvalificerad gängmedlem per intervall.",
                drugSalesEnabledLabel = "NPC-försäljning ger territorieinflytelse",
                drugSalesEnabledDescription = "Lyckad gatuförsäljning till NPC:er ger inflytelse till säljarens gäng i det aktuella gatuterritoriet.",
                drugSalePointsLabel = "Poäng per såld drog",
                drugSalePointsDescription = "Inflyteljepoäng som delas ut för varje drogenhet som rapporteras som såld.",
                drugSalesRequirement = "Aktivera NPC-försäljningsinflytelse för att konfigurera dess poäng.",
                graffitiPointsLabel = "Graffitipoäng per 24 timmar",
                graffitiPointsDescription = "Närvaropoäng som delas ut när en graffiti har existerat i totalt 24 rapporterade timmar.",
                streetSellingPriceBonusLabel = "Bonus för gatuförsäljningspris",
                streetSellingPriceBonusDescription = "Procentuell bonus på drogförsäljningspriser för den officiella ägaren av ett gatuterritorium.",
                supplyProductionSpeedBonusLabel = "Bonus för produktionshastighet av förnödenheter",
                supplyProductionSpeedBonusDescription = "Procentuell bonus på drogproduktionens hastighet för den officiella ägaren av ett förnödenhetsterritorium.",
                pruneToleranceLabel = "Tolerans för inflytelsejustering",
                pruneToleranceDescription = "Effektivt inflytelse under detta värde behandlas som noll.",
            },
            graffitiSettings = {
                section = "Graffiti Ordförande",
                generalGroup = "Allmänt",
                streamingGroup = "Visning",
                moderationGroup = "Moderering",
                graffitiEnabledLabel = "Aktivera graffiti",
                graffitiEnabledDescription = "Tillåt spelare att spraya och se graffiti.",
                graffitiRequireItemLabel = "Kräver sprayburk",
                graffitiRequireItemDescription = "Spelare behöver föremålet sprayburk för att spraya. Annars används kommandot /graffiti.",
                graffitiChargesPerCanLabel = "Antal laddningar per burk",
                graffitiChargesPerCanDescription = "Hur många graffitier en enskild sprayburk kan skapa.",
                graffitiCooldownSecondsLabel = "Spray-cooldown",
                graffitiCooldownSecondsDescription = "Sekunder en spelare måste vänta mellan sprayningar.",
                graffitiMaxPerPlayerLabel = "Max graffiti per spelare",
                graffitiMaxPerPlayerDescription = "Maximalt antal aktiva graffitier en spelare kan äga. 0 betyder obegränsat.",
                graffitiMaxDistanceLabel = "Max sprayavstånd",
                graffitiMaxDistanceDescription = "Hur långt bort en vägg kan vara för att man fortfarande ska kunna spraya på den, i meter.",
                graffitiSprayDurationLabel = "Sprayduration",
                graffitiSprayDurationDescription = "Hur länge spray-animationen varar, i millisekunder.",
                graffitiExpiryDaysLabel = "Utgångstid",
                graffitiExpiryDaysDescription = "Dagar tills en graffiti försvinner automatiskt. 0 betyder aldrig.",
                graffitiTerritoryHoursLabel = "Territorietimmar per spray",
                graffitiTerritoryHoursDescription = "Territorietimmar i närvaro som en ny graffiti ger sin gäng.",
                graffitiStreamRadiusLabel = "Stream-radie",
                graffitiStreamRadiusDescription = "Avstånd i meter där graffiti blir synlig för spelare.",
                graffitiPoolSizeLabel = "Decal-poolstorlek",
                graffitiPoolSizeDescription = "Hur många graffitier som renderas samtidigt. Högre värden kostar mer prestanda.",
                graffitiReportsEnabledLabel = "Aktivera rapporter",
                graffitiReportsEnabledDescription = "Låt spelare rapportera stötande graffiti.",
                graffitiAutoHideThresholdLabel = "Tröskel för automatisk döljning",
                graffitiAutoHideThresholdDescription = "Antal rapporter som automatiskt döljer en graffiti. 0 inaktiverar detta.",
            },
            darknetSettings = {
                section = "Darknet-marknad",
                availabilityGroup = "Tillgänglighet",
                economyGroup = "Kryptovaluta",
                listingsGroup = "Erbjudanden och utgångstid",
                chatGroup = "Privat chatt",
                identityGroup = "Alias och rykte",
                deliveryGroup = "Överlämningar och dead drops",
                policeGroup = "Polisåtkomst",
                npcGroup = "NPC-handlare",
                enabledLabel = "Aktivera Darknet Market",
                enabledDescription = "Gör svartmarknadens tablet-app och dess runtime tillgänglig.",
                tabletOrderLabel = "Ordning för tablet-appen",
                tabletOrderDescription = "Styr Darknet Markets position på tableten.",
                currencyCodeLabel = "Valutakod",
                currencyCodeDescription = "Kort etikett som visas för den interna kryptovalutaledern.",
                starterBalanceLabel = "Startsaldo för nya wallets",
                starterBalanceDescription = "Krypto tilldelas endast när en spelare öppnar marknaden för första gången.",
                exchangeEnabledLabel = "Aktivera coin-växling",
                exchangeEnabledDescription = "Tillåter autentiserade BlackBay-användare att köpa och sälja coins på sin kontosida.",
                exchangeAccountLabel = "Betalkonto för coin-växling",
                exchangeAccountDescription = "Framework-konto som används för coin-köp och utbetalningar från försäljning.",
                exchangeBuyPriceLabel = "Inköpspris per coin",
                exchangeBuyPriceDescription = "Belopp som debiteras från betalkontot för en coin.",
                exchangeSellPriceLabel = "Försäljningspris per coin",
                exchangeSellPriceDescription = "Belopp som betalas ut till betalkontot för en coin.",
                exchangeMinimumLabel = "Minsta antal coins per växling",
                exchangeMinimumDescription = "Minsta hela coin-belopp som accepteras i en växling.",
                exchangeMaximumLabel = "Maximalt antal coins per växling",
                exchangeMaximumDescription = "Största hela coin-belopp som accepteras i en växling.",
                accountMoney = "Kontanter",
                accountBank = "Banken",
                accountBlackMoney = "Smutsiga pengar",
                scamChanceLabel = "Global NPC-bedrägerichans (%)",
                scamChanceDescription = "Minsta chans att en NPC-handel tar betalningen eller varorna utan att leverera motprestationen. En högre handlar-specifik chans gäller fortfarande.",
                listingExpiryLabel = "Erbjudandets livslängd (timmar)",
                listingExpiryDescription = "Aktiva erbjudanden löper ut automatiskt efter detta antal timmar.",
                renewalHoursLabel = "Förlängningsperiod (timmar)",
                renewalHoursDescription = "Timmar som läggs till när en ägare förlänger ett erbjudande.",
                maximumListingsLabel = "Maximalt antal aktiva erbjudanden",
                maximumListingsDescription = "Maximalt antal erbjudanden per aktiv alias.",
                maximumQuantityLabel = "Maximal mängd varor",
                maximumQuantityDescription = "Övre mängdgräns för ett erbjudande.",
                maximumPriceLabel = "Maximalt styckpris",
                maximumPriceDescription = "Övre kryptopris för en enhet.",
                maximumMessageLengthLabel = "Maximal meddelandelängd",
                maximumMessageLengthDescription = "Maximalt antal tecken per krypterat chattmeddelande.",
                aliasCooldownLabel = "Cooldown för aliasbyte (timmar)",
                aliasCooldownDescription = "Minsta ålder för en identitet innan den kan pensioneras igen.",
                verifiedSalesLabel = "Försäljningar som krävs för verifiering",
                verifiedSalesDescription = "Antal lyckade försäljningar som krävs innan en säljare kan bli verifierad.",
                verifiedRatingLabel = "Betyg som krävs för verifiering",
                verifiedRatingDescription = "Minsta genomsnittliga betyg för en verifierad säljare.",
                scammerReportsLabel = "Rapporter för bedragarvarning",
                scammerReportsDescription = "Unika handelsrapporter som krävs för märket",
                meetingDistanceLabel = "Överlämningsavstånd",
                meetingDistanceDescription = "Maximalt avstånd mellan båda spelarna eller till den konfigurerade NPC-punkten.",
                dropModelLabel = "Dead-drop lådkonfiguration",
                dropModelDescription = "GTA-propmodell som spawnas lokalt för tillgängliga dead drops.",
                dropStreamLabel = "Dead-drop stream-avstånd",
                dropStreamDescription = "Avstånd där lådor och NPC-möteskontakter streamas.",
                dropInteractionLabel = "Interaktionsavstånd för dead-drop",
                dropInteractionDescription = "Nödvändigt avstånd för att söka igenom och göra anspråk på en låda.",
                dropLifetimeLabel = "Dead-drop livslängd (timmar)",
                dropLifetimeDescription = "Tid innan en omarkerad låda löper ut.",
                dropPollLabel = "Världens uppdateringsintervall (ms)",
                dropPollDescription = "Intervall som används för att uppdatera närliggande lådor och NPC-möten.",
                policeGroupsLabel = "Auktoriserade polisingrupper",
                policeGroupsDescription = "Job Configurator-gruppnycklar som kan publicera lockbeten och se utredningar.",
                policeGroupEntry = "Polisgrupp",
                groupKeyLabel = "Gruppnyckel",
                npcTradersLabel = "NPC-köpare och -säljare",
                npcTradersDescription = "Konfigurera persistenta syntetiska erbjudanden, leveransmetod, rykte och bedrägerisannolikhet.",
                npcTraderEntry = "NPC-handlare",
                npcIdLabel = "ID",
                npcAliasLabel = "Ordförande",
                npcSideLabel = "Marknadssida",
                sideSell = "Säljer till spelare",
                sideBuy = "Köper från spelare",
                npcTitleLabel = "Erbjudandets titel",
                npcDescriptionLabel = "Beskrivning",
                npcItemNameLabel = "Namn på inventarieartikel",
                npcItemLabelLabel = "Varumärke för vara",
                npcQuantityLabel = "Antal",
                npcPriceLabel = "Enhetspris",
                npcDeliveryLabel = "Leveransmetod",
                deliveryBoth = "Möte och dead drop",
                deliveryMeeting = "Endast ansikte mot ansikte",
                deliveryDrop = "Endast dead drop",
                npcScamChanceLabel = "Chans för bedrägeri av handlare (%)",
                npcPedModelLabel = "NPC-pedmodell",
                npcRatingLabel = "Visat betyg",
                npcRatingCountLabel = "Antal visade betyg",
                npcTradesLabel = "Visade lyckade affärer",
                npcVerifiedLabel = "Verifierad handlare",
                npcScammerLabel = "Känd bedragare",
                npcEnabledLabel = "Aktiverad",
            },
            interrogationSettings = {
                section = "Förhör",
                generalGroup = "Allmänt",
                consentGroup = "Spelarskydd",
                objectGroup = "Objekt",
                grabGroup = "Gripande",
                sessionGroup = "Förhör",
                dispatchGroup = "Polisvarningar",
                loggingGroup = "Loggning",
                securityGroup = "Säkerhet",
                presentationGroup = "Visning",
                enabledLabel = "Aktivera förhör",
                enabledDescription = "Tillåt spelare att binda andra i förhörsstolar och använda verktyg på dem.",
                consentRequiredLabel = "Kräv samtycke",
                consentRequiredDescription = "Endast spelare som har gett sitt samtycke kan bli offer. Ingenting ger längre samtycke automatiskt, så detta kräver inställningen nedan.",
                consentDefaultLabel = "Samtycke som standard",
                consentDefaultDescription = "Nya karaktärer startar med samtycke beviljat istället för nekat.",
                globalIntensityLabel = "Effektintensitet",
                globalIntensityDescription = "Skalar skärmeffekter, partiklar och ljud. 0 stänger av dem helt.",
                maxPerPlayerLabel = "Objekt per spelare",
                maxPerPlayerDescription = "Hur många stolar och vagnar en spelare får ha placerade. 0 betyder obegränsat.",
                maxGlobalLabel = "Objekt serverövergripande",
                maxGlobalDescription = "Totalt antal tillåtna placerade objekt samtidigt. 0 betyder obegränsat.",
                placementDistanceLabel = "Placeringsavstånd",
                placementDistanceDescription = "Hur långt från spelaren ett objekt får placeras, i meter.",
                interactDistanceLabel = "Interaktionsavstånd",
                interactDistanceDescription = "Hur nära en spelare måste vara för att använda en stol eller vagn, i meter.",
                inactivityMinutesLabel = "Automatisk borttagning efter",
                inactivityMinutesDescription = "Minuter av inaktivitet innan ett placerat objekt försvinner. 0 behåller det för alltid.",
                persistObjectsLabel = "Behåll objekt efter omstart",
                persistObjectsDescription = "Placerade objekt återställs från databasen när servern startar om.",
                grabEnabledLabel = "Aktivera grepp",
                grabEnabledDescription = "Tillåt spelare att övermanna och bära bort en annan spelare.",
                grabItemLabel = "Nödvändigt föremål",
                grabItemDescription = "Föremålet som angriparen behöver för att greppa någon. Lämna tomt för att inget krävs.",
                grabAngleLabel = "Närmningsvinkel",
                grabAngleDescription = "Hur många grader åt sidan från direkt bakom angriparen som man får stå.",
                grabHealthBelowLabel = "Hälsogräns",
                grabHealthBelowDescription = "Ett offer under denna hälsogräns kan övermannas utan att vara fastbunden. 0 inaktiverar detta.",
                grabCooldownLabel = "Väntetid efter misslyckande",
                grabCooldownDescription = "Sekunder innan ett misslyckat grepp får försökas igen.",
                grabVehiclesLabel = "Tillåtna fordon",
                grabVehiclesDescription = "Fordonsmodeller som ett övermannat offer kan lastas in i.",
                carryEnabledLabel = "Tillåt bärning",
                carryEnabledDescription = "Låt angriparen bära offret över axeln.",
                restrictVisionLabel = "Begränsa offrets sikt",
                restrictVisionDescription = "Gör offrets skärm svart under transporten.",
                escapeEnabledLabel = "Tillåt flyktförsök",
                escapeEnabledDescription = "Låt ett transporterat offer försöka bryta sig loss.",
                escapeSecondsLabel = "Flyktens varaktighet",
                escapeSecondsDescription = "Antal sekunder som offret måste hålla inne tangenten för att bryta sig loss.",
                maxDurationLabel = "Maximal varaktighet",
                maxDurationDescription = "Minuter efter vilka en session avslutas automatiskt.",
                warnMinutesLabel = "Varning före slut",
                warnMinutesDescription = "Minuter före gränsen då båda parter varnas.",
                idleMinutesLabel = "Frigör vid inaktivitet",
                idleMinutesDescription = "Minuter utan någon interaktion innan offret frigörs.",
                selfReleaseMinutesLabel = "Självfrigörelse efter",
                selfReleaseMinutesDescription = "Minuter utan interaktion från angriparen innan offret kan befria sig själv.",
                graceSecondsLabel = "Tid efter bortkoppling",
                graceSecondsDescription = "Antal sekunder som offret förblir fastbundet när angriparen lämnar servern.",
                rescueEnabledLabel = "Tillåt räddningar",
                rescueEnabledDescription = "Låt oinblandade spelare befria ett fastbundet offer.",
                rescueSecondsLabel = "Räddningstid",
                rescueSecondsDescription = "Sekunder som en räddare behöver för att befria offret.",
                rescueItemLabel = "Räddningsföremål",
                rescueItemDescription = "Föremålet som en räddare behöver. Lämna tomt för att inget krävs.",
                allowInventoryLabel = "Offret behåller sitt inventory",
                allowInventoryDescription = "Ett fastbundet offer kan fortfarande öppna sitt inventory.",
                dispatchEnabledLabel = "Aktivera polismeldinger",
                dispatchEnabledDescription = "Rapportera kidnappningar och förhör till räddningstjänsten.",
                dispatchAdapterLabel = "Larmsystem",
                dispatchAdapterDescription = "Vilket larmsystem som tar emot rapporterna.",
                dispatchJobsLabel = "Mottagande jobb",
                dispatchJobsDescription = "Jobb som får larmet.",
                dispatchGrabChanceLabel = "Chans vid grepp",
                dispatchGrabChanceDescription = "Procentuell chans att ett grepp rapporteras.",
                dispatchFixateChanceLabel = "Chans vid fastbindning",
                dispatchFixateChanceDescription = "Procentuell chans att någon som binds fast i en stol rapporteras.",
                dispatchToolChanceLabel = "Chans vid verktygsanvändning",
                dispatchToolChanceDescription = "Procentuell chans att användning av verktyg rapporteras.",
                dispatchWitnessLabel = "Kräv vittne",
                dispatchWitnessDescription = "Rapportera endast när en annan spelare är tillräckligt nära för att märka det.",
                dispatchWitnessRadiusLabel = "Vittnesradie",
                dispatchWitnessRadiusDescription = "Hur nära ett vittne måste vara, i meter.",
                dispatchCooldownLabel = "Nedkylning av larm",
                dispatchCooldownDescription = "Sekunder mellan två larm från samma session.",
                dispatchInaccuracyLabel = "Positionsosäkerhet",
                dispatchInaccuracyDescription = "Meter som den rapporterade positionen slumpmässigt förskjuts med. 0 rapporterar den exakta platsen.",
                loggingEnabledLabel = "Aktivera loggning",
                loggingEnabledDescription = "Registrerar placeringar, grepp, verktygsanvändning, frigivningar och adminåtgärder.",
                logDatabaseLabel = "Logga till databas",
                logDatabaseDescription = "Skriver även varje post i förhörsloggtabellen.",
                logRetentionLabel = "Spara loggposter",
                logRetentionDescription = "Dagar innan loggposter i databasen rensas. 0 sparar dem för alltid.",
                pingToleranceLabel = "Avståndstolerans",
                pingToleranceDescription = "Meter som läggs till vid varje avståndscheck på serversidan för att hantera lagg.",
                violationThresholdLabel = "Tröskel för överträdelser",
                violationThresholdDescription = "Säkerhetsöverträdelser inom tidsfönstret innan reaktionen utlöses. 0 inaktiverar den.",
                violationActionLabel = "Reaktion på överträdelser",
                violationActionDescription = "Vad som händer när en spelare passerar tröskeln för överträdelser.",
                violationActionNone = "Gör ingenting",
                violationActionLog = "Endast logga",
                violationActionKick = "Kicka",
                violationActionCheating = "Rapportera som fusk",
                particlesLabel = "Partikeleffekter",
                particlesDescription = "Visa blod, gnistor och flammor vid verktygsanvändning.",
                soundLabel = "Ljudeffekter",
                soundDescription = "Spela upp verktygsljud för alla i närheten.",
                cameraWorkLabel = "Kamerarörelser",
                cameraWorkDescription = "Flytta kameran vid fastbindning och under verktygsanvändning.",
                screenEffectsLabel = "Skärmeffekter",
                screenEffectsDescription = "Skakningar, blixtar, oskärpa och färgfilter på offrets skärm.",
                objectsSection = "Förhörsobjekt",
                objectsEntry = "Objekt",
                objectsEditLabel = "Förhörsobjekt",
                objectsEditDescription = "Placera permanenta stolar och verktygsvagnar på kartan.",
                objectsEditButton = "Redigera objekt",
                objectsKindLabel = "Objekttyp",
                objectsKindChair = "Stol",
                objectsKindCart = "Verktygsvagn",
                objectsModelLabel = "Prop-modell",
                objectsPositionLabel = "Placera",
                blockedZonesSection = "Spärrzoner",
                blockedZonesEntry = "Zon",
                blockedZonesEditLabel = "Spärrzoner",
                blockedZonesEditDescription = "Områden där inget förhörsobjekt får placeras.",
                blockedZonesEditButton = "Redigera zoner",
                blockedZonesZoneLabel = "Zonens kontur",
                blockedZonesZoneDescription = "Dra det i hörnen för att definiera området där placering är förbjuden.",
                toolsSection = "Verktyg",
                toolsEntry = "Verktyg",
                toolsEditLabel = "Verktyg",
                toolsEditDescription = "Lägg till eller justera verktygen som kan användas på ett offer.",
                toolsEditButton = "Redigera verktyg",
                toolsItemLabel = "Nödvändigt föremål",
                toolsConsumeLabel = "Förbruka föremål",
                toolsDamageLabel = "Skada per användning",
                toolsHealthFloorLabel = "Hälsogräns",
                toolsCooldownLabel = "Nedkylning i sekunder",
                toolsProgressLabel = "Framsteg per användning",
                sessionsSection = "Pågående förhör",
                sessionsEntry = "Förhör",
                sessionsEditLabel = "Pågående förhör",
                sessionsEditDescription = "Se vem som förhörs just nu och avsluta om det behövs.",
                sessionsEditButton = "Visa förhör",
                sessionsStateLabel = "Status",
                sessionsProgressLabel = "Framsteg",
                orphansSection = "Övergivna objekt",
                orphansEntry = "Objekt",
                orphansEditLabel = "Övergivna objekt",
                orphansEditDescription = "Ta bort objekt vars ägare inte har setts på länge.",
                orphansEditButton = "Städa upp",
                sessionStates = {
                    binding = "Blir fastbunden",
                    active = "Aktiv",
                    ending = "Avslutas",
                },
            },
        },
    },
}
