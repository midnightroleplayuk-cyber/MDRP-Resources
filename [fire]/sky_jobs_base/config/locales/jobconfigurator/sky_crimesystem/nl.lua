JobConfigLocales["sky_crimesystem:nl"] = {
    Nui = {
        workshopConfig = {
            creatorCommand = "Direct commando",
            roleDefaults = {
                title = "Rollen",
                description = "Kies de minimale rang voor elk standaardrecht. Rangrechten die in het baasmenu zijn opgeslagen hebben voorrang.",
                bossHint = "De baas- en plaatsvervangerrangen behouden altijd volledige toegang.",
                empty = "Voor dit beroep zijn nog geen rangen beschikbaar.",
                gradesTitle = "Beroepsrangen",
                noDefault = "Geen standaardrecht",
                rankOption = "{grade} – {label}",
            },
            weaponDefaultsDescription = "Gedeelde waarden gelden voor overnemende velden. Een wijziging op de instellingenpagina schakelt het veld naar een eigen waarde. Bestaande vermeldingen behouden hun waarden.",
            weaponStreetDescription = "Bij een straatcontact voor drugs kan de server soms een toegestaan wapen kopen. Selectie, prijs en uitbetaling worden volledig door de server bepaald.",
            weaponGroups = {
                general = "Algemene standaardwaarden",
                access = "Standaardtoegang",
                collection = "Standaardverzameling",
                production = "Standaardproductie",
                market = "Standaardmarkt",
                delivery = "Standaardopdrachten",
                street = "Wapenverkoop op straat",
            },
            weaponOptions = {
                scrap_search = "Doorzoek de schroothoop",
                player = "Per speler",
                global = "Globaal",
                money = "Contant",
                bank = "Bankrekening",
                black_money = "Zwart geld",
                timing = "Stop de indicator binnen het optimale bereik.",
                precision = "Voer elke snede uit binnen het precisievenster.",
                pressure = "Stop de pers bij de optimale druk.",
            },

            reputation = {
                remove = "Verwijderen",
                title = "Reputatie",
                action = "Actie",
                points = "Punten per voltooiing",
                enabled = "Actief",
                search = "Acties zoeken",
                added = "Al toegevoegd",
                noResults = "Geen overeenkomende acties gevonden.",
                empty = "Nog geen acties. Voeg een actie toe met de plusknop.",
                name = "Regelnaam",
                target = "Doel (optioneel)",
            },
            configs = {
                sky_crimesystem = {
                    entries = "Facties",
                    subtitle = "Configureer crime jobs en hun gedeelde locaties.",
                    title = "Misdaad-systeem",
                },
            },
            creatorSections = {
                mainbaseZones = {
                    entryLabel = "Hoofdbasis",
                    entryPluralLabel = "Hoofdbases",
                    label = "Mainbase-zone",
                },
                presetTerritories = {
                    label = "Standaarddistricten",
                    entryLabel = "Standaarddistrict",
                    entryPluralLabel = "Standaarddistricten",
                },
                customTerritories = {
                    label = "Aangepaste territoria",
                    entryLabel = "Aangepast territorium",
                    entryPluralLabel = "Aangepaste territoria",
                },
                objectsSection = {
                    label = "Verhoorobjecten",
                    entryLabel = "Voorwerp",
                    entryPluralLabel = "Verhoorobjecten",
                },
                blockedZonesSection = {
                    label = "Sperrzones",
                    entryLabel = "Gebied",
                    entryPluralLabel = "Sperrzones",
                },
                toolsSection = {
                    label = "Gereedschap",
                    entryLabel = "Gereedschap",
                    entryPluralLabel = "Gereedschap",
                },
                sessionsSection = {
                    label = "Lopende sessies",
                    entryLabel = "Verhoor",
                    entryPluralLabel = "Lopende sessies",
                },
                orphansSection = {
                    label = "Verwaarloosde objecten",
                    entryLabel = "Voorwerp",
                    entryPluralLabel = "Verwaarloosde objecten",
                },
            },
            darknetActions = {
                currentLocation = "Huidige locatie gebruiken",
            },
            drugSettings = {
                drugGrowthCurve = {
                    description = "Hogere waarden maken slechte zorg veel langzamer, terwijl sterke bonussen voor goede zorg behouden blijven.",
                    label = "Zorg-reactiecurve",
                },
                drugGrowthMaxMultiplier = {
                    description = "Maximale groeimultiplier bereikt onder uitstekende omstandigheden.",
                    label = "Multiplier voor perfecte zorg",
                },
                drugGrowthMinMultiplier = {
                    description = "Groeimultiplier gebruikt wanneer de plantomstandigheden kritiek slecht zijn.",
                    label = "Multiplier voor kritieke zorg",
                },
                drugGrowthQualityBonusMax = {
                    description = "Maximale extra groeibonus verleend door plantkwaliteit.",
                    label = "Kwaliteitsgroeibonus",
                },
            },
            errors = {
                invalid_role_permission_defaults = "Kies geldige minimumrangen voor de rolrechten.",
                base_raid_locked = "De base wordt overvallen. De opslaglocaties en configuratie zijn vergrendeld.",
                base_storage_outside_zone = "Alle opslag-, kluis- en heist-opslagpunten moeten zich binnen de base-zone bevinden.",
                base_zone_invalid_polygon = "Plaats minstens drie verschillende punten zonder de randen te kruisen, en controleer vervolgens de hoogte (3–200 m) en de routing bucket.",
                base_zone_point_limit = "Een mainbase-zone ondersteunt maximaal 64 hoekpunten.",
                base_zone_required = "Configureer eerst een geldige mainbase-zone voor deze crime job.",
                crime_interrogation_invalid_model = "Voer een geldig objectmodel in.",
                crime_interrogation_invalid_coords = "Plaats het object op een geldige positie.",
                crime_interrogation_invalid_zone_points = "Plaats minstens drie geldige grenspunten.",
                crime_interrogation_duplicate_id = "Er bestaat al een object met dit ID.",
                crime_interrogation_tool_invalid = "Controleer de gereedschapsdefinitie.",
                crime_interrogation_tool_id_invalid = "Voer een geldig gereedschaps-ID in.",
                crime_interrogation_tool_label_missing = "Voer een naam voor het gereedschap in.",
                crime_interrogation_effect_missing = "Stel een effect voor het gereedschap in.",
                crime_interrogation_effect_type_unknown = "Selecteer een ondersteund effecttype.",
                crime_interrogation_effect_status_missing = "Geef aan welke status dit gereedschap beïnvloedt.",
                crime_interrogation_minigame_missing = "Stel een minigame voor het gereedschap in.",
                crime_interrogation_minigame_type_unknown = "Selecteer een ondersteund minigametype.",
                crime_interrogation_keys_missing = "Stel de bediening van het gereedschap in.",
                crime_interrogation_keys_invalid = "Controleer de ingestelde bedieningstoetsen.",
                crime_interrogation_keys_duplicate = "Wijs elke gereedschapsactie en toets slechts één keer toe.",
                crime_interrogation_anim_invalid = "Controleer het animatiewoordenboek en de clip van het gereedschap.",
                crime_interrogation_anim_missing = "Stel een animatie in voor de gereedschapsgebruiker.",
                crime_interrogation_occupied = "Er is al iemand vastgebonden aan dit object.",
                crime_interrogation_not_found = "Dit is er niet meer.",
            },
            extensions = {
                baseZone = {
                    description = "Plaats 3 tot 64 grenspunten in volgorde. Het laagst geplaatste punt bepaalt de onderkant; de hoogte strekt zich van daaruit naar boven uit. Punten worden als concept opgeslagen; gebruik Opslaan om de zone toe te passen. Alleen opslag, kluisjes en heist-opslag binnen de zone zijn toegankelijk tijdens raids. Punten buiten de zone voorkomen het opslaan of starten van een raid niet. Bestaande grenzen blijven actief totdat je opslaat.",
                    fields = {
                        bucket = "Routingemmer",
                        configured = "Geconfigureerd",
                        height = "Hoogte (meters)",
                        radius = "Straal (meter)",
                        x = "Middelpunt X",
                        y = "Middelpunt Y",
                        z = "Middelpunt Z",
                    },
                    label = "Mainbase-zone",
                },
                invalidSelection = "Ongeldige selectie: {value}",
            },
            locationDescriptions = {
                crimeStationPosition = "Hoofdpunt van deze joblocatie. Als de map blip is ingeschakeld onder Job → Blips, verschijnt deze hier.",
            },
            locationTypes = {
                crimeStationPosition = "Locatie / map blip",
                heistCrafting = "Heist-werkplaats",
                heistStorage = "Overvalopslag",
            },
            membershipMigration = {
                cancel = "Annuleren",
                confirm = "Migreren en opslaan",
                message = "Bestaande organisatie-lidmaatschappen worden gemigreerd naar het geselecteerde model. Normaal dienstverband blijft gescheiden in de onafhankelijke modus.",
                title = "Lidmaatschapmodel wijzigen?",
            },
            moneywashActions = {
                currentLocation = "Huidige locatie gebruiken",
                invalidLocations = "Controleer ID's, namen, interieurselecties en coördinaten. Elke locatie heeft een unieke ID nodig.",
                position = "Positie",
            },
            moneywashBusiness = {
                moneywashBuildNodes = { label = "Bouwpunten", description = "Plaats passende apparaten op deze punten. Coördinaten zijn relatief aan het gekozen interieur." },
                mwBuildNodes = "Bouwpunten",
                moneywashPublicEquipment = { label = "Openbare apparatuur", description = "Wijs wasmachines, generators en ventilators toe aan openbare locaties en passende punten." },
                mwPublicEquipment = "Openbare apparatuur",
                moneywashMaterials = { label = "Materialen", description = "Gebruik exacte inventarisnamen. Gewicht in gram; installeer ontbrekende voorwerpen." },
                mwMaterials = "Materialen",
                moneywashMaterialRecipes = { label = "Materiaalrecepten", description = "Invoer, uitvoer en duur gelden per eenheid. Verwerkers gebruiken deze recepten." },
                mwMaterialRecipes = "Materiaalrecepten",
                moneywashProductionRecipes = { label = "Drukrecepten", description = "Papier, inkt en tijden gelden per eenheid. Contant geld na drogen en kwaliteitscontrole." },
                mwProductionRecipes = "Drukrecepten",
                moneywashCollectors = { label = "Verzamelaars", description = "Configureer opbrengst, gereedschap, wachttijd en locatie van elke verzamelaar." },
                mwCollectors = "Verzamelaars",
                moneywashProcessors = { label = "Verwerkers", description = "Kies een materiaalrecept en locatie voor elke verwerker." },
                mwProcessors = "Verwerkers",

                control = "Bedieningspaneel",
                editor = {
                    addBusiness = "Business toevoegen",
                    addInterior = "Interieur toevoegen",
                    advanced = "Technische details",
                    asset_ipl = "IPL: Voer de exacte IPL-naam en de interieurpositie in.",
                    asset_mlo = "MLO: Gebruik de positie van een geïnstalleerd interieur. De toegang gebruikt momenteel de ingang van het bedrijf.",
                    asset_shell = "Shell: Het model-resource moet op de server geïnstalleerd zijn en draaien.",
                    businessHelp = "Geef de business een naam, kies het interieur en stel de aankoopprijs in.",
                    businessListHelp = "Beheer ingangen en aankoopprijzen voor je businesses.",
                    businesses = "Bedrijven",
                    capture = "Instellen in het spel",
                    captureOrigin = "Interieurpositie instellen",
                    chooseInterior = "Kies een interieur",
                    coordinates = "Coördinaten bewerken",
                    editSections = "Instellingen",
                    emptyBusinessHelp = "Koppel een ingang op de kaart aan een interieur. Je organisaties kunnen vervolgens het lege bedrijf kopen.",
                    emptyBusinesses = "Je eerste bedrijf",
                    emptyInteriorHelp = "Verbind een IPL, een shell of een geïnstalleerde MLO, en stel vervolgens de punten in die door de business worden gebruikt.",
                    emptyInteriors = "Je eerste interieur",
                    entranceHelp = "Stel de ingang in waar spelers de business moeten kopen en betreden.",
                    freecamHelp = "Freecam: WASD bewegen, Q/E omhoog/omlaag, Shift sneller, Ctrl langzamer. Rechtermuis: rondkijken. Gizmo slepen, R draaien/verschuiven, Enter plaatsen, Backspace annuleren.",
                    general = "Algemeen",
                    heading = "Koers",
                    interiorHelp = "Kies het type interieur en het bijbehorende asset.",
                    interiorListHelp = "Bereid lege ruimtes voor. Spelers plaatsen hun eigen machines en apparatuur.",
                    interiors = "Interieurs",
                    listEmpty = "Nog geen registraties.",
                    locationTypes = "Locatiebeheer",
                    newBusiness = "Nieuwe business",
                    newInterior = "Nieuw interieur",
                    noResults = "Geen overeenkomstige resultaten.",
                    notSet = "Niet ingesteld",
                    offsetHelp = "Invoerwaarden zijn offsets vanaf de oorsprong. De wereldpositie wordt hierboven weergegeven.",
                    origin = "Oorsprong",
                    originHelp = "Interieurpositie. Alle andere punten zijn relatief aan deze positie.",
                    originRequired = "Stel eerst de interieurpositie in onder Algemeen.",
                    outsideRange = "Buiten het bereik van {range} meter",
                    point_control = "Beweeg en roteer het wandpaneel op zijn plaats met de gizmo. De bevestigde objecthoogte wordt exact aangehouden. Schakel de marker in via Interacties → Money Wash: control panel.",
                    point_entry = "Spelers komen hier aan en verlaten de ruimte. Het verlaten van de ruimte brengt hen automatisch terug naar de ingang van hun bedrijf buiten.",
                    point_position = "Dit punt bevindt zich buiten het bedrijf.",
                    point_storage = "Beweeg en roteer de plank met de gizmo totdat deze op de vloer rust. Leden hebben hier toegang tot gekochte apparatuur. Schakel de marker in via Interacties → Money Wash: opslag.",
                    points = "Punten",
                    pointsHelp = "Selecteer een punt en plaats het direct in het spel.",
                    rangeNote = "Een straal van {range} meter rond de interieur-oorsprong is van toepassing, zonder hoogtebeperking.",
                    remove = "Verwijderen",
                    repairRange = "Beweeg deze punten dichter naar de interieur-oorsprong.",
                    saveHint = "Pas wijzigingen toe met Opslaan bovenaan.",
                    search = "Zoeken …",
                    set = "Instellen",
                    teleport = "Teleporteren",
                    viewInteriors = "Interieurs bekijken",
                    visit = "Bekijken",
                    visitHint = "Beweeg vrij. Druk op Backspace om terug te keren naar de editor.",
                    visitTitle = "Interieur bekijken",
                },
                entry = "In- en uitgang",
                fields = {
                    mode = "Toegangsmodus",
                    ownerKind = "Type eigenaar",
                    productionEnabled = "Drukuitbreiding beschikbaar",
                    feePercent = "Kosten (%) / -1 = algemeen",
                    storageCapacity = "Voorraadcapaciteit (voorwerpen)",
                    maximumOrders = "Gelijktijdige orders per speler",
                    gridPower = "Netstroom / 0 = generator",
                    autoService = "Automatisch openbaar onderhoud",
                    maximumPendingOutputs = "Maximum openstaande uitbetalingen",
                    placementRange = "Plaatsingsstraal (m)",
                    placementHeight = "Hoogtebereik plaatsing (m)",
                    interiorId = "Interieur-ID",
                    equipmentId = "Apparaat-ID",
                    nodeId = "Bouwpunt-ID",
                    generatorNode = "Generatorpunt-ID",
                    maxOffset = "Maximale afwijking van punt (m)",
                    maxHeight = "Maximaal hoogteverschil (m)",
                    weight = "Voorwerpgewicht (g)",
                    inputItem = "Invoermateriaal",
                    secondItem = "Tweede invoermateriaal",
                    outputItem = "Uitvoermateriaal",
                    requiredTool = "Vereist gereedschap",
                    baseQuality = "Beginkwaliteit (%)",
                    minimumQuality = "Minimumkwaliteit (%)",
                    inspectionCards = "Controlekaarten",
                    inspectionPenalty = "Kwaliteitsverlies per fout (%)",
                    rejectPercent = "Afgekeurde biljetten (%)",
                    accessoryModel = "Accessoiremodel",
                    accessoryMaximum = "Maximum zichtbare accessoires",
                    accessoryActiveOnly = "Accessoires alleen tijdens verwerking",
                    animDict = "Animatiewoordenboek",
                    animClip = "Animatiefragment",
                    cooldown = "Wachttijd (seconden)",
                    minimum = "Minimumopbrengst",
                    maximum = "Maximumopbrengst",
                    productionPrice = "Geld drukken · Aankoopprijs",
                    recipeId = "Recept ID",
                    inputAmount = "Materiaal / per eenheid",
                    secondAmount = "Materiaal / per eenheid",
                    outputAmount = "Materiaal / per eenheid",
                    paperItem = "Drukpapier",
                    inkItem = "Drukinkt",
                    paperAmount = "Drukpapier / per eenheid",
                    inkAmount = "Drukinkt / per eenheid",
                    notesPerUnit = "Bankbiljetten / per eenheid",
                    valuePerNote = "Contant geld / Bankbiljetten",
                    maximumUnits = "Eenheden (max.)",
                    printSeconds = "Drukken / per eenheid (Seconden)",
                    inspectionSeconds = "Controleren / per eenheid (Seconden)",
                    rinseSeconds = "Wassen / per eenheid (Seconden)",
                    drySeconds = "Drogen / per eenheid (Seconden)",
                    accessoryUnit = "Bankbiljetten / per eenheid",
                    accessoryX = "Accessoiremodel · X (m)",
                    accessoryY = "Accessoiremodel · Y (m)",
                    accessoryZ = "Accessoiremodel · Z (m)",
                    accessoryStep = "Accessoiremodel · Z (m)",

                    capacity = "Capaciteit per cyclus",
                    controlHeading = "Richting bedieningspaneel",
                    controlHeight = "Montagehoogte boven punt (m)",
                    controlModel = "Wandpaneel model",
                    controlX = "Bedieningspaneel X",
                    controlY = "Controlepaneel Y",
                    controlZ = "Controlepaneel Z",
                    disableSets = "Verborgen entity-sets (gescheiden door komma's)",
                    enableSets = "Ingeschakelde entiteitensets (gescheiden door komma's)",
                    entryX = "Ingang offset X",
                    entryY = "Ingang-offset Y",
                    entryZ = "Ingang offset Z",
                    heading = "Richting",
                    id = "Unieke ID",
                    interior = "Interieur",
                    ipl = "IPL-naam",
                    kind = "Soort",
                    label = "Naam",
                    model = "Modelnaam",
                    power = "Stroomeenheden",
                    price = "Aankoopprijs",
                    radius = "Plaatsingsstraal (m)",
                    repairPrice = "Reparatieprijs (0 = gratis)",
                    seconds = "Cyclusduur (seconden)",
                    storageHeading = "Richting opslagpunt",
                    storageModel = "Plankmodel",
                    storageX = "Opslagpunt X",
                    storageY = "Opslagpunt Y",
                    storageZ = "Opslagpunt Z",
                    wear = "Slijtage per cyclus (%)",
                    x = "Oorsprong X",
                    y = "Oorsprong Y",
                    z = "Oorsprong Z",
                },
                interactions = {
                    control = "Money Wash: bedieningspaneel",
                    storage = "Money Wash: opslag",
                },
                item = "Registratie",
                moneywashBucketStart = {
                    description = "Reserveer dit bereik uitsluitend voor Money Wash. Wijzigingen worden bij de volgende ingang toegepast.",
                    label = "Start van instantiëringsbereik",
                },
                moneywashEquipment = {
                    description = "Spelers kopen en plaatsen apparaten. Capaciteit, duur en slijtage zijn van toepassing op wasmachines. Stroom is de levering van de generator of de vraag van het apparaat. Wijzigingen hebben betrekking op nieuwe aankopen.",
                    label = "Koopbare apparatuur",
                },
                moneywashInteriors = {
                    description = "Configureer lege IPL-, shell- of MLO-interieurs. Ingang, bedieningspaneel, opslag en bouwlimieten zijn relatief aan de oorsprong. Het verlaten van de locatie brengt spelers terug naar de ingang van hun business.",
                    label = "Interieurs (IPL, shell of MLO)",
                },
                moneywashMaximumEquipment = {
                    description = "Maximaal aantal gekochte apparaten en reparatiesets per bedrijf.",
                    label = "Equipment-limiet",
                },
                moneywashPreviewBucketStart = {
                    description = "Visit gebruikt deze waarde plus de spelers-ID voor een privé-admin-instantie. Reserveer dit apart van bedrijven en andere resources. Wijzigingen zijn van toepassing op de volgende preview.",
                    label = "Begin van het preview-instantiebereik",
                },
                moneywashProperties = {
                    description = "Stel een ingang in, kies een interieur en stel de aankoopprijs in. Gekochte bedrijven behouden hun opgeslagen interieur en indeling.",
                    label = "Bedrijfsingangen",
                },
                moneywashRepairShops = {
                    description = "Stel reparatiewinkels in, teleporteer naar deze locaties en stel de servicetarieven in. Ze verkopen reparatiesets en onderhouden opgeslagen machines.",
                    label = "Winkellocaties",
                },
                moneywashShops = {
                    description = "Plaats winkels voor wasmachines, generatoren en ventilatoren. Bestellingen gaan naar de geselecteerde business van de organisatie.",
                    label = "Winkellocaties",
                },
                mwEquipment = "Apparatuurwinkel",
                mwInteriors = "Lege interieurs",
                mwProperties = "Locaties",
                mwRepairShops = "Reparatiebedrijf",
                mwSettings = "Business-instellingen",
                names = {
                    mwPublicLaundry = "Openbare wasserij",
                    mwPaperPulp = "Papierpulp",
                    mwPrintingPaper = "Drukpapier",
                    mwPrintingInk = "Drukinkt",
                    mwPaperRecipe = "Drukpapier maken",
                    mwPrintingRecipe = "Standaardbankbiljetten",
                    mwPaperCollector = "Papierverzamelaar",
                    mwInkCollector = "Inktverzamelaar",
                    mwPaperProcessor = "Papierverwerker",
                    mwPrinter = "Drukpers",
                    mwInspectionTable = "Controletafel",
                    mwDryingCabinet = "Droogkast",
                    mwNode1 = "1 · Wassen",
                    mwNode2 = "2 · Wassen",
                    mwNode3 = "3 · Bouwpunten",
                    mwNode4 = "4 · Drukken",
                    mwNode5 = "5 · Controleren",
                    mwNode6 = "6 · Drogen",
                    mwNode7 = "7 · Bouwpunten",

                    mwInteriorWarehouse = "Lege loods",
                },
                options = {
                    private = "Privé",
                    public = "Openbaar",
                    faction = "Organisatie",
                    person = "Personage",
                    printer = "Drukpers",
                    inspection = "Controletafel",
                    dryer = "Droogkast",

                    fan = "Ventilator",
                    generator = "Generator",
                    ipl = "IPL",
                    mlo = "MLO",
                    repair = "Reparatieset",
                    shell = "Shell-model",
                    washer = "Wasmachine",
                },
                origin = "Oorsprong",
                storage = "Opslagpunt",
            },
            settingFields = {
                cultivationLevel = "Kweekniveau",
                cultivationTitle = "Niveaunaam",
                cultivationRequiredXp = "Vereiste totale XP",
                cultivationAction = "Actie",
                cultivationXp = "XP",
                cultivationCategory = "Categorie",
                cultivationEntry = "Item",
                cultivationRequiredLevel = "Vereist niveau",
                alias = "Alias",
                atmHeading = "Koers",
                atmId = "ID",
                atmModel = "ATM-model",
                centerX = "Centrum X",
                centerY = "Centrum Y",
                centerZ = "Centrum Z",
                deliveryMethod = "Leveringsmethode",
                description = "Beschrijving",
                enabled = "Ingeschakeld",
                groupKey = "Groepssleutel",
                id = "ID",
                itemLabel = "Goederenlabel",
                itemName = "Inventarisitemnaam",
                knownScammer = "Bekende oplichter",
                locationName = "Locatienaam",
                observerW = "Observer-richting",
                observerX = "Waarnemer X",
                observerY = "Waarnemer Y",
                observerZ = "Waarnemer Z",
                pedModel = "NPC ped-model",
                pickpocketItemChance = "Kans (%)",
                pickpocketItemMaximum = "Maximaal bedrag",
                pickpocketItemMinimum = "Minimaal bedrag",
                pickpocketItemName = "Inventarisitemnaam",
                quantity = "Aantal",
                radius = "Straal",
                rating = "Getoonde beoordeling",
                ratingCount = "Aantal getoonde beoordelingen",
                scamChance = "Kans op handelaar-scam (%)",
                shopCategory = "Categorie",
                shopClerkHeading = "Verkoper-richting",
                shopClerkModel = "Verkoper-model",
                shopClerkRequired = "Verkoper vereist",
                shopClerkX = "Verkoper X",
                shopClerkY = "Verkoper Y",
                shopClerkZ = "Verkoper Z",
                shopCodeEnabled = "Openen met code toestaan",
                shopDrillEnabled = "Boren toestaan",
                shopEnabled = "Ingeschakeld",
                shopHackEnabled = "Hacken toestaan",
                shopLocationId = "Winkel-ID",
                shopLocationLabel = "Naam",
                shopRegisterId = "Kassa-ID",
                shopSafeEnabled = "Kluis ingeschakeld",
                shopSafeHeading = "Kluis-richting",
                shopSafeX = "Kluis X",
                shopSafeY = "Kluis Y",
                shopSafeZ = "Kluis Z",
                side = "Marktzijde",
                spawns = "Team-spawns",
                successfulTrades = "Getoonde succesvolle transacties",
                title = "Aanbiedingstitel",
                unitPrice = "Eenheidsprijs",
                verified = "Geverifieerde handelaar",
                w = "Koers",
                x = "X",
                y = "Y",
                z = "Z",
                shopClerkPosition = "Verkoperspositie",
                shopRegisterPosition = "Kassapositie",
                shopSafePosition = "Kluispositie",
                registerId = "Kassa-ID",
                registerX = "X-coördinaat van de kassa",
                registerY = "Y-coördinaat van de kassa",
                registerZ = "Z-coördinaat van de kassa",
                heading = "Richting",
                captureLocation = "Locatie vastleggen",
            },
            crimeDashboard = {
                jobs = "Beheer facties, leden, rechten en locaties.",
                jobCreator = "Selecteer een factie om de locaties en gebieden te bewerken.",
                jobsQuestion = "Waar bewerk ik facties en locaties?",
                jobsAnswer = "Open {path}, selecteer een factie en kies Bewerken. Daar pas je de instellingen en locaties aan.",
                creatorsAnswer = "De creators staan onder {path}. Deze links openen de editor; factietools beginnen met het selecteren van een factie.",
                missingAnswer = "De beschikbare creators hangen af van de geselecteerde resource en de instellingen. Factietools beginnen bij de betreffende factie.",
                creators = {
                    mainbaseZones = "Selecteer een factie en stel het basisgebied in.",
                    presetTerritories = "Bekijk de vooraf ingestelde districten en kies welke actief zijn.",
                    objectsSection = "Beheer permanente verhoorstoelen en gereedschapswagens.",
                    blockedZonesSection = "Bepaal gebieden waar geen verhoorobjecten geplaatst mogen worden.",
                    toolsSection = "Stel de beschikbare gereedschappen voor verhoren in.",
                    sessionsSection = "Bekijk actieve verhoren en beëindig sessies wanneer dat nodig is.",
                    orphansSection = "Controleer en verwijder achtergelaten verhoorobjecten.",
                },
            },
            crimeGroupDescriptions = {
                general = {
                    crimeMembership = "Bepaal hoe criminele organisaties hun leden opslaan en beheren.",
                },
                territories = {
                    zones = "Pas de instellingen voor ‘Territoriumzones’ in het onderdeel ‘Territoria’ aan.",
                    ownership = "Pas de instellingen voor ‘Eigendom’ in het onderdeel ‘Territoria’ aan.",
                    decay = "Pas de instellingen voor ‘Verval’ in het onderdeel ‘Territoria’ aan.",
                    presence = "Pas de instellingen voor ‘Aanwezigheid’ in het onderdeel ‘Territoria’ aan.",
                    activity = "Pas de instellingen voor ‘Activiteitsscore’ in het onderdeel ‘Territoria’ aan.",
                    ownershipBenefits = "Pas de instellingen voor ‘Eigendomsvoordelen’ in het onderdeel ‘Territoria’ aan.",
                },
                graffiti = {
                    general = "Pas de instellingen voor ‘Algemeen’ in het onderdeel ‘Graffiti’ aan.",
                    streaming = "Pas de instellingen voor ‘Renderen’ in het onderdeel ‘Graffiti’ aan.",
                    moderation = "Pas de instellingen voor ‘Moderatie’ in het onderdeel ‘Graffiti’ aan.",
                },
                pvpEvents = {
                    pvpAvailability = "Controleer of de PvP-event app beschikbaar is en waar deze verschijnt.",
                    pvpAutomation = "Configureer terugkerende evenementen en automatische startverwerking.",
                    pvpRuntime = "Stel request-afhandeling, sterfgevallen en respawns in tijdens live matches.",
                    pvpModes = "Configureer de spelmodus die vooraf is geselecteerd op de PvP-tablet.",
                    pvpArenas = "Maak de cirkelvormige zone, het observatiepunt en de team-spawnpunten aan die worden gebruikt voor PvP-events.",
                    pvpLimits = "Stel limieten in voor beloningen en de tablet-geschiedenis.",
                    pvpPermissions = "Koppel eventbeheer en financiën aan ACE- en job-rechten.",
                    pvpTakeoverRules = "Regelt de beschikbaarheid en deelnamevereisten voor laboratorium- en camperovernames.",
                    pvpTakeoverZones = "Configureer interactie-, melding- en veroveringsgebieden samen met hun duur.",
                    pvpTakeoverMethods = "Configureer hoe lang elke methode nodig heeft om een ingang te forceren.",
                },
                drugs = {
                    creator = "Opent de Sky Crime-drugseditor en sluit de jobconfigurator.",
                    creatorSettings = "Pas de instellingen voor ‘Editorinstellingen’ in het onderdeel ‘Drugssysteem’ aan.",
                    interfaceHud = "Pas de instellingen voor ‘Interfaceposities’ in het onderdeel ‘Drugssysteem’ aan.",
                    drugsGeneral = "Pas de instellingen voor ‘Algemeen’ in het onderdeel ‘Drugssysteem’ aan.",
                    runtimeAccess = "Pas de instellingen voor ‘Toegang en eigendom’ in het onderdeel ‘Drugssysteem’ aan.",
                    runtimePayouts = "Pas de instellingen voor ‘Uitbetalingen’ in het onderdeel ‘Drugssysteem’ aan.",
                    runtimeDispatch = "Pas de instellingen voor ‘Meldkamer en politie’ in het onderdeel ‘Drugssysteem’ aan.",
                    performanceInactiveControlIntervalMs = "Instelling voor Prestaties / Inactief / Bediening / Interval / ms.",
                    performanceInteractionIdleScanIntervalMs = "Instelling voor Prestaties / Interactie / Inactief / Scaninterval / ms.",
                    performanceInteractionPromptIntervalMs = "Instelling voor Prestaties / Interactie / Interactieaanwijzing / Interval / ms.",
                    performanceInteractionScanIntervalMs = "Instelling voor Prestaties / Interactie / Scaninterval / ms.",
                    performanceMinimumScanIntervalMs = "Instelling voor Prestaties / Minimum / Scaninterval / ms.",
                    performanceStreetPedActivationDistance = "Instelling voor Prestaties / Straat / Ped / Activatie / Afstand.",
                    performanceStreetPedIdleScanIntervalMs = "Instelling voor Prestaties / Straat / Ped / Inactief / Scaninterval / ms.",
                    performanceStreetPedScanIntervalMs = "Instelling voor Prestaties / Straat / Ped / Scaninterval / ms.",
                    performanceWorldCachePadding = "Instelling voor Prestaties / Wereld / Cache / Extra marge.",
                    performanceWorldCacheRefreshIntervalMs = "Instelling voor Prestaties / Wereld / Cache / Verversing / Interval / ms.",
                    performanceWorldIdleIntervalMs = "Instelling voor Prestaties / Wereld / Inactief / Interval / ms.",
                },
                drugProduction = {
                    qualityWeights = "Pas de instellingen voor ‘Kwaliteit / Wegingen’ in het onderdeel ‘Drugsproductie’ aan.",
                    qualityTiers = "Pas de instellingen voor ‘Kwaliteit / Kwaliteitsniveaus’ in het onderdeel ‘Drugsproductie’ aan.",
                    packagingGeneral = "Pas de instellingen voor ‘Algemeen’ in het onderdeel ‘Drugsproductie’ aan.",
                    processingFlow = "Pas de instellingen voor ‘Verwerkingsproces’ in het onderdeel ‘Drugsproductie’ aan.",
                    processingGeneral = "Pas de instellingen voor ‘Algemeen’ in het onderdeel ‘Drugsproductie’ aan.",
                },
                drugOperations = {
                    growingGeneral = "Pas de instellingen voor ‘Algemeen’ in het onderdeel ‘Drugsbedrijven’ aan.",
                    plantDefaults = "Pas de instellingen voor ‘Plant / Standaardwaarden’ in het onderdeel ‘Drugsbedrijven’ aan.",
                    harvestWindow = "Pas de instellingen voor ‘Oogsten / Tijdvenster’ in het onderdeel ‘Drugsbedrijven’ aan.",
                    labsGeneral = "Activeert: labs en campers in het spel.",
                    labRent = "Pas de instellingen voor ‘Huur en levenscyclus’ in het onderdeel ‘Drugsbedrijven’ aan.",
                    camperDefaults = "Pas de instellingen voor ‘Camper’ in het onderdeel ‘Drugsbedrijven’ aan.",
                    labUpgrades = "Vermenigvuldiger voor Lab / Niveau / Verbetering / Prijzen.",
                    labDefaults = "Pas de instellingen voor ‘Lab / Standaardwaarden’ in het onderdeel ‘Drugsbedrijven’ aan.",
                    powerGeneral = "Pas de instellingen voor ‘Algemeen’ in het onderdeel ‘Drugsbedrijven’ aan.",
                    generators = "Pas de instellingen voor ‘Generatoren’ in het onderdeel ‘Drugsbedrijven’ aan.",
                    equipmentWear = "Algemene vermenigvuldiger voor Slijtage van uitrusting / Verwerking.",
                    workersGeneral = "Pas de instellingen voor ‘Algemeen’ in het onderdeel ‘Drugsbedrijven’ aan.",
                    cultivationGeneral = "Pas de instellingen voor ‘Algemeen’ in het onderdeel ‘Drugsbedrijven’ aan.",
                    cultivationCurve = "Stel de naam en totale XP-drempel voor elk kweekniveau in.",
                    cultivationExperience = "Stel in hoeveel kweek-XP elke actie oplevert.",
                    cultivationUnlocks = "Stel het vereiste niveau in voor containers, substraten, apparatuur, soorten en scannerniveaus.",
                    powerRuntime = "Interval in seconden voor bijwerken van generatorverbruik en stroomverbruikspatronen.",
                    powerHeat = "Pas de instellingen voor ‘Politieaandacht en stroomverbruik’ in het onderdeel ‘Drugsbedrijven’ aan.",
                    powerModes = "Pas de instellingen voor ‘Beheer / Modi’ in het onderdeel ‘Drugsbedrijven’ aan.",
                    powerPriorities = "Pas de instellingen voor ‘Belasting / Prioriteiten’ in het onderdeel ‘Drugsbedrijven’ aan.",
                },
                drugMarketRisk = {
                    marketGeneral = "Pas de instellingen voor ‘Algemeen’ in het onderdeel ‘Markt en risico’ aan.",
                    marketPrices = "Pas de instellingen voor ‘Prijzen’ in het onderdeel ‘Markt en risico’ aan.",
                    distribution = "Pas de instellingen voor ‘Distributie’ in het onderdeel ‘Markt en risico’ aan.",
                    threatsGeneral = "Pas de instellingen voor ‘Algemeen’ in het onderdeel ‘Markt en risico’ aan.",
                    threatHeat = "Pas de instellingen voor ‘Politiedruk’ in het onderdeel ‘Markt en risico’ aan.",
                    threatChances = "Pas de instellingen voor ‘Kansen’ in het onderdeel ‘Markt en risico’ aan.",
                    consumptionGeneral = "Pas de instellingen voor ‘Algemeen’ in het onderdeel ‘Markt en risico’ aan.",
                    consumerDecay = "Pas de instellingen voor ‘Afname van tolerantie en verslaving’ in het onderdeel ‘Markt en risico’ aan.",
                    consumerEffects = "Pas de instellingen voor ‘Effecten en risico's’ in het onderdeel ‘Markt en risico’ aan.",
                },
                drugNetworks = {
                    dynamicMarketActionCooldownSeconds = "Instelling voor Dynamische Markt / Actie-cooldown / seconden.",
                    dynamicMarketActionHistoryLimit = "Instelling voor Dynamische Markt / Actie / Geschiedenislimiet.",
                    dynamicMarketAmountSaturationWeight = "Instelling voor Dynamische Markt / Hoeveelheid / Verzadiging / Gewicht.",
                    dynamicMarketBaseIntelAccuracy = "Instelling voor Dynamische Markt / Basiswaarde / Nauwkeurigheid van de info.",
                    dynamicMarketDefaultAverageQuality = "Instelling voor Dynamische Markt / Standaardwaarde / Gemiddelde / Kwaliteit.",
                    dynamicMarketDefaultResourceElasticity = "Instelling voor Dynamische Markt / Standaardwaarde / Grondstof / Elasticiteit.",
                    dynamicMarketDemandCenter = "Instelling voor Dynamische Markt / Vraag / Middenwaarde.",
                    dynamicMarketDemandPriceImpact = "Instelling voor Dynamische Markt / Vraag / Prijs / Invloed.",
                    dynamicMarketDirectionThreshold = "Instelling voor Dynamische Markt / Richting / Drempel.",
                    dynamicMarketEnabled = "Instelling voor Dynamische Markt / Ingeschakeld.",
                    dynamicMarketEventChance = "Instelling voor Dynamische Markt / Gebeurtenis / Kans.",
                    dynamicMarketEventDurationMinutes = "Instelling voor Dynamische Markt / Gebeurtenis / Duur / Minuten.",
                    dynamicMarketEventMinimumDurationMinutes = "Instelling voor Dynamische Markt / Gebeurtenis / Minimum / Duur / Minuten.",
                    dynamicMarketEventStrengthMaximum = "Instelling voor Dynamische Markt / Gebeurtenis / Sterkte / Maximum.",
                    dynamicMarketEventStrengthMinimum = "Instelling voor Dynamische Markt / Gebeurtenis / Sterkte / Minimum.",
                    dynamicMarketEvents = "Pas de instellingen voor ‘Evenementen’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    dynamicMarketExactIntelReputation = "Instelling voor Dynamische Markt / Exacte informatie / Reputatie.",
                    dynamicMarketExactIntelTrust = "Instelling voor Dynamische Markt / Exacte informatie / Vertrouwen.",
                    dynamicMarketGlobalZoneLabel = "Instelling voor Dynamische Markt / Global / Zone / Naam.",
                    dynamicMarketHistoryLimit = "Instelling voor Dynamische Markt / Geschiedenislimiet.",
                    dynamicMarketInitialDemand = "Instelling voor Dynamische Markt / Beginwaarde / Vraag.",
                    dynamicMarketInitialPriceMultiplier = "Instelling voor Dynamische Markt / Beginwaarde / Prijsvermenigvuldiger.",
                    dynamicMarketIntelDemandError = "Instelling voor Dynamische Markt / Informatie / Vraag / Fout.",
                    dynamicMarketIntelMaximumAccuracy = "Instelling voor Dynamische Markt / Informatie / Maximum / Nauwkeurigheid.",
                    dynamicMarketIntelMinimumAccuracy = "Instelling voor Dynamische Markt / Informatie / Minimum / Nauwkeurigheid.",
                    dynamicMarketIntelPoliceError = "Instelling voor Dynamische Markt / Informatie / Politie / Fout.",
                    dynamicMarketIntelPriceError = "Instelling voor Dynamische Markt / Informatie / Prijs / Fout.",
                    dynamicMarketIntelPriceMaximum = "Instelling voor Dynamische Markt / Informatie / Prijs / Maximum.",
                    dynamicMarketIntelPriceMinimum = "Instelling voor Dynamische Markt / Informatie / Prijs / Minimum.",
                    dynamicMarketIntelReputationWeight = "Instelling voor Dynamische Markt / Informatie / Reputatie / Gewicht.",
                    dynamicMarketIntelResourcePriceError = "Instelling voor Dynamische Markt / Informatie / Grondstof / Prijs / Fout.",
                    dynamicMarketIntelSaturationError = "Instelling voor Dynamische Markt / Informatie / Verzadiging / Fout.",
                    dynamicMarketIntelSeedBucketSeconds = "Instelling voor Dynamische Markt / Tijdvak voor willekeurige informatiewaarde / seconden.",
                    dynamicMarketIntelStatusAccuracyThreshold = "Instelling voor Dynamische Markt / Informatie / Status / Nauwkeurigheid / Drempel.",
                    dynamicMarketIntelStatusErrorThreshold = "Instelling voor Dynamische Markt / Informatie / Status / Fout / Drempel.",
                    dynamicMarketIntelSupplyError = "Instelling voor Dynamische Markt / Informatie / Levering / Fout.",
                    dynamicMarketIntelTrustWeight = "Instelling voor Dynamische Markt / Informatie / Vertrouwen / Gewicht.",
                    dynamicMarketManipulationCooldownMinutes = "Instelling voor Dynamische Markt / Manipulatie / Afkoeltijd (minuten).",
                    dynamicMarketManipulationDemandShift = "Instelling voor Dynamische Markt / Manipulatie / Vraag / Verschuiving.",
                    dynamicMarketManipulationDurationMinutes = "Instelling voor Dynamische Markt / Manipulatie / Duur / Minuten.",
                    dynamicMarketManipulationHeat = "Instelling voor Dynamische Markt / Manipulatie / Politiedruk.",
                    dynamicMarketManipulationMinimumBatchAmount = "Instelling voor Dynamische Markt / Manipulatie / Minimum / Batch / Hoeveelheid.",
                    dynamicMarketManipulationPaymentAccount = "Instelling voor Dynamische Markt / Manipulatie / Betaalrekening.",
                    dynamicMarketManipulationPrice = "Instelling voor Dynamische Markt / Manipulatie / Prijs.",
                    dynamicMarketManipulationZoneHeatMultiplier = "Instelling voor Dynamische Markt / Manipulatie / Zone / Politiedruk / Vermenigvuldiger.",
                    dynamicMarketMaximumIntelAgeMinutes = "Instelling voor Dynamische Markt / Maximum / Leeftijd van de info / Minuten.",
                    dynamicMarketMaximumPriceMultiplier = "Instelling voor Dynamische Markt / Maximum / Prijsvermenigvuldiger.",
                    dynamicMarketMinimumIntelAgeMinutes = "Instelling voor Dynamische Markt / Minimum / Leeftijd van de info / Minuten.",
                    dynamicMarketMinimumMetricWindowMinutes = "Instelling voor Dynamische Markt / Minimum / Meetwaarde / Tijdvenster / Minuten.",
                    dynamicMarketMinimumPriceMultiplier = "Instelling voor Dynamische Markt / Minimale prijs / Vermenigvuldiger.",
                    dynamicMarketMinimumUpdateMinutes = "Instelling voor Dynamische Markt / Minimum / Bijwerking / Minuten.",
                    dynamicMarketPoliceDemandWeight = "Instelling voor Dynamische Markt / Politie / Vraag / Gewicht.",
                    dynamicMarketPolicePriceImpact = "Instelling voor Dynamische Markt / Politie / Prijs / Invloed.",
                    dynamicMarketPoorQualityDemandPenalty = "Instelling voor Dynamische Markt / Slechte kwaliteit / Vraag / Aftrek.",
                    dynamicMarketPoorQualityThreshold = "Instelling voor Dynamische Markt / Slechte kwaliteit / Drempel.",
                    dynamicMarketPremiumQualityDemandBonus = "Instelling voor Dynamische Markt / Topkwaliteit / Vraagbonus.",
                    dynamicMarketPremiumQualityThreshold = "Instelling voor Dynamische Markt / Topkwaliteit / Drempel.",
                    dynamicMarketProductionSupplyWeight = "Instelling voor Dynamische Markt / Productie / Levering / Gewicht.",
                    dynamicMarketProductionWindowMinutes = "Instelling voor Dynamische Markt / Productie / Tijdvenster / Minuten.",
                    dynamicMarketQualityCenter = "Instelling voor Dynamische Markt / Kwaliteit / Middenwaarde.",
                    dynamicMarketQualityConfidenceImpact = "Instelling voor Dynamische Markt / Kwaliteit / Zekerheid / Invloed.",
                    dynamicMarketQualityRange = "Instelling voor Dynamische Markt / Kwaliteit / Waardenbereik.",
                    dynamicMarketRarityBonusMaximum = "Instelling voor Dynamische Markt / Zeldzaamheid / Bonus / Maximum.",
                    dynamicMarketRegionalGlobalWeight = "Instelling voor Dynamische Markt / Regionaal / Global / Gewicht.",
                    dynamicMarketRegionalLocalWeight = "Instelling voor Dynamische Markt / Regionaal / Lokaal / Gewicht.",
                    dynamicMarketResourceAliases = "Pas de instellingen voor ‘Grondstof / Alternatieve namen’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    dynamicMarketResourceDirectionFallThreshold = "Instelling voor Dynamische Markt / Grondstof / Richting / Daling / Drempel.",
                    dynamicMarketResourceDirectionRiseThreshold = "Instelling voor Dynamische Markt / Grondstof / Richting / Stijging / Drempel.",
                    dynamicMarketResources = "Pas de instellingen voor ‘Grondstoffen’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    dynamicMarketSalesWindowMinutes = "Instelling voor Dynamische Markt / Verkopen / Tijdvenster / Minuten.",
                    dynamicMarketSaturationDemandWeight = "Instelling voor Dynamische Markt / Verzadiging / Vraag / Gewicht.",
                    dynamicMarketSaturationPriceImpact = "Instelling voor Dynamische Markt / Verzadiging / Prijs / Invloed.",
                    dynamicMarketScarcityDemandWeight = "Instelling voor Dynamische Markt / Schaarste / Vraag / Gewicht.",
                    dynamicMarketScarcityPriceImpact = "Instelling voor Dynamische Markt / Schaarste / Prijs / Invloed.",
                    dynamicMarketSeasonEndMonths = "Pas de instellingen voor ‘Seizoen / Einde / Maanden’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    dynamicMarketSeasonMultipliers = "Pas de instellingen voor ‘Seizoen / Vermenigvuldigers’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    dynamicMarketShortageRumorThreshold = "Instelling voor Dynamische Markt / Tekort / Gerucht / Drempel.",
                    dynamicMarketStatusThresholds = "Pas de instellingen voor ‘Status / Drempels’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    dynamicMarketTargetSupply = "Instelling voor Dynamische Markt / Doelwit / Levering.",
                    dynamicMarketTrendChance = "Instelling voor Dynamische Markt / Trend / Kans.",
                    dynamicMarketTrendDurationMinutes = "Instelling voor Dynamische Markt / Trend / Duur / Minuten.",
                    dynamicMarketTrendMaximumStrength = "Instelling voor Dynamische Markt / Trend / Maximum / Sterkte.",
                    dynamicMarketTrendMinimumStrength = "Instelling voor Dynamische Markt / Trend / Minimum / Sterkte.",
                    dynamicMarketUpdateMinutes = "Instelling voor Dynamische Markt / Bijwerking / Minuten.",
                    dynamicMarketVolatilityMaximum = "Instelling voor Dynamische Markt / Prijsvolatiliteit / Maximum.",
                    dynamicMarketVolatilityMinimum = "Instelling voor Dynamische Markt / Prijsvolatiliteit / Minimum.",
                    dynamicMarketWeatherMultipliers = "Pas de instellingen voor ‘Weer / Vermenigvuldigers’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    dynamicMarketWeatherState = "Instelling voor Dynamische Markt / Weer / Status.",
                    heatActionCooldownSeconds = "Instelling voor Politieaandacht en risico / Actie-cooldown / seconden.",
                    heatActivityRiskWeights = "Pas de instellingen voor ‘Activiteit / Risico / Wegingen’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    heatAggressiveHeatMultiplier = "Instelling voor Politieaandacht en risico / Agressieve werkwijze / Politiedruk / Vermenigvuldiger.",
                    heatBurnerBurnThreshold = "Instelling voor Politieaandacht en risico / Wegwerptelefoon / Ontmaskering / Drempel.",
                    heatBurnerHeatPerWholesale = "Instelling voor Politieaandacht en risico / Wegwerptelefoon / Politiedruk / Per groothandelsdeal.",
                    heatBurnerPhoneItem = "Instelling voor Politieaandacht en risico / Burner phone / Voorwerp.",
                    heatCamperOperationalHeatMultiplier = "Instelling voor Politieaandacht en risico / Camper in bedrijf / Politiedruk / Vermenigvuldiger.",
                    heatCamperOperationalHeatThreshold = "Instelling voor Politieaandacht en risico / Camper in bedrijf / Politiedruk / Drempel.",
                    heatCamperParkedHeat = "Instelling voor Politieaandacht en risico / Geparkeerde camper / Politiedruk.",
                    heatContaminatedHeatMultiplier = "Instelling voor Politieaandacht en risico / Verontreiniging / Politiedruk / Vermenigvuldiger.",
                    heatContaminatedThreshold = "Instelling voor Politieaandacht en risico / Verontreiniging / Drempel.",
                    heatCultivationFreePlants = "Instelling voor Politieaandacht en risico / Teelt / Planten zonder extra risico.",
                    heatCultivationHeatPerPlant = "Instelling voor Politieaandacht en risico / Teelt / Politiedruk / Per plant.",
                    heatDealerHiddenMinutes = "Instelling voor Politieaandacht en risico / Handelaar / verborgen / Minuten.",
                    heatDecayPerTick = "Pas de instellingen voor ‘Verval / Per updatestap’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    heatEnabled = "Instelling voor Politieaandacht en risico / Ingeschakeld.",
                    heatEnforcementHeat = "Pas de instellingen voor ‘Politieaanwezigheid / Politiedruk’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    heatEnforcementMultipliers = "Pas de instellingen voor ‘Politieaanwezigheid / Vermenigvuldigers’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    heatEntityTypes = "Pas de instellingen voor ‘Spelobject / Typen’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    heatEventCooldownMinutes = "Instelling voor Politieaandacht en risico / Gebeurtenis / Afkoeltijd (minuten).",
                    heatEventHistoryLimit = "Instelling voor Politieaandacht en risico / Gebeurtenis / Geschiedenislimiet.",
                    heatLabHeatSyncThreshold = "Instelling voor Politieaandacht en risico / Lab / Politiedruk / Synchronisatie / Drempel.",
                    heatLayLowCooldownMinutes = "Instelling voor Politieaandacht en risico / Onderduiken / Afkoeltijd (minuten).",
                    heatLayLowIdleMinutes = "Instelling voor Politieaandacht en risico / Onderduiken / Inactief / Minuten.",
                    heatLayLowReduction = "Instelling voor Politieaandacht en risico / Onderduiken / Vermindering.",
                    heatLockdownMinutes = "Instelling voor Politieaandacht en risico / Lockdown / Minuten.",
                    heatMinimumDurationMinutes = "Instelling voor Politieaandacht en risico / Minimum / Duur / Minuten.",
                    heatMinimumEventCooldownSeconds = "Instelling voor Politieaandacht en risico / Minimum / Gebeurtenis / Cooldown (seconden).",
                    heatMinimumIdleSeconds = "Instelling voor Politieaandacht en risico / Minimum / Inactief / seconden.",
                    heatProcessingHeatMultiplier = "Instelling voor Politieaandacht en risico / Verwerking / Politiedruk / Vermenigvuldiger.",
                    heatRiskWeights = "Pas de instellingen voor ‘Risico / Wegingen’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    heatRotateBurnerReduction = "Instelling voor Politieaandacht en risico / Wegwerptelefoon wisselen / Vermindering.",
                    heatRouteControlMinutes = "Instelling voor Politieaandacht en risico / Route / Bediening / Minuten.",
                    heatSaleHeat = "Pas de instellingen voor ‘Verkoop / Politiedruk’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    heatThresholds = "Pas de instellingen voor ‘Drempels’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    heatTickMinutes = "Instelling voor Politieaandacht en risico / Updatecyclus / Minuten.",
                    heatWholesaleHeatMultiplier = "Instelling voor Politieaandacht en risico / Groothandel / Politiedruk / Vermenigvuldiger.",
                    heatWorkerLeakAlertRadius = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Alertradius.",
                    heatWorkerLeakBaseChance = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Basiswaarde / Kans.",
                    heatWorkerLeakFactionMultiplier = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Factie / Vermenigvuldiger.",
                    heatWorkerLeakHighSeverityThreshold = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Hoog / Ernst / Drempel.",
                    heatWorkerLeakLoyaltyChanceMultiplier = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Loyaliteit / Kans / Vermenigvuldiger.",
                    heatWorkerLeakLoyaltyThreshold = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Loyaliteit / Drempel.",
                    heatWorkerLeakMaximumChance = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Maximum / Kans.",
                    heatWorkerLeakMinimumCooldownSeconds = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Minimum / Cooldown (seconden).",
                    heatWorkerLeakRouteMultiplier = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Route / Vermenigvuldiger.",
                    heatWorkerLeakStrengthMaximum = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Sterkte / Maximum.",
                    heatWorkerLeakStrengthMinimum = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Sterkte / Minimum.",
                    heatWorkerLeakStrengthMultiplier = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Sterkte / Vermenigvuldiger.",
                    heatWorkerLeakStressChanceMultiplier = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Stress / Kans / Vermenigvuldiger.",
                    heatWorkerLeakStressThreshold = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Stress / Drempel.",
                    contactsActionCooldownSeconds = "Instelling voor Contactnetwerk / Actie-cooldown / seconden.",
                    contactsActiveHotspotCount = "Instelling voor Contactnetwerk / Aantal actieve hotspots.",
                    contactsBurnerHintTrust = "Instelling voor Contactnetwerk / Burner-hint / Vertrouwen.",
                    contactsBurnerOfferMaximumMultiplier = "Instelling voor Contactnetwerk / Wegwerptelefoon / Aanbod / Maximum / Vermenigvuldiger.",
                    contactsBurnerOfferMinimumMultiplier = "Instelling voor Contactnetwerk / Wegwerptelefoon / Aanbod / Minimum / Vermenigvuldiger.",
                    contactsBuyerCooldownMinutes = "Instelling voor Contactnetwerk / Koper / Afkoeltijd (minuten).",
                    contactsBuyerDeliveryDistance = "Instelling voor Contactnetwerk / Koper / Afleverafstand.",
                    contactsBuyerPremiumSuccessScore = "Instelling voor Contactnetwerk / Koper / Premium / Succes / Score.",
                    contactsBuyerPremiumTrustGain = "Instelling voor Contactnetwerk / Koper / Premium / Vertrouwen / winst.",
                    contactsBuyerRequestHeatRiskWeight = "Instelling voor Contactnetwerk / Koper / Aanvraag / Heat & Risico / Gewicht.",
                    contactsBuyerStandardTrustGain = "Instelling voor Contactnetwerk / Koper / Standaard / Vertrouwen / winst.",
                    contactsContactActiveDelaySeconds = "Pas de instellingen voor ‘Wachttijd voor contactactivering / seconden’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    contactsContactDemandRange = "Pas de instellingen voor ‘Contact / Vraag / Waardenbereik’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    contactsContactLossTrust = "Instelling voor Contactnetwerk / Contact / Verlies / Vertrouwen.",
                    contactsDarknetExactIntelMinutes = "Instelling voor Contactnetwerk / Darknet / Exacte informatie / Minuten.",
                    contactsDarknetHotspotIntelPrice = "Instelling voor Contactnetwerk / Darknet / Hotspot / Informatie / Prijs.",
                    contactsDarknetIntelPrice = "Instelling voor Contactnetwerk / Darknet / Informatie / Prijs.",
                    contactsDealerBasePrice = "Instelling voor Contactnetwerk / Handelaar / Basisprijs.",
                    contactsDealerHireCapacity = "Pas de instellingen voor ‘Handelaar / Aanwerving / capaciteit’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    contactsDealerHireRisk = "Pas de instellingen voor ‘Handelaar / Aanwerving / Risico’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    contactsDealerHireSkill = "Pas de instellingen voor ‘Handelaar / Aanwerving / Vaardigheid’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    contactsDealerOffers = "Pas de instellingen voor ‘Dealer-aanbiedingen’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    contactsDealerProtectionHours = "Instelling voor Contactnetwerk / Handelaar / Bescherming / Uren.",
                    contactsDealerProtectionPrice = "Instelling voor Contactnetwerk / Handelaar / Bescherming / Prijs.",
                    contactsDealerSaleMax = "Instelling voor Contactnetwerk / Handelaar / Verkoop / Maximum.",
                    contactsDealerSaleMin = "Instelling voor Contactnetwerk / Handelaar / Verkoop / Minimum.",
                    contactsDealerSimulation = "Pas de instellingen voor ‘Handelaar / Simulatie’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    contactsDealerTickMinutes = "Instelling voor Contactnetwerk / Handelaar / Updatecyclus / Minuten.",
                    contactsDealerWage = "Instelling voor Contactnetwerk / Handelaar / Loon.",
                    contactsDealerWageDecay = "Instelling voor Contactnetwerk / Handelaar / Loon / Verval.",
                    contactsDealerWageLoyaltyGain = "Instelling voor Contactnetwerk / Handelaar / Loon / Loyaliteit / winst.",
                    contactsDealerWeaknesses = "Pas de instellingen voor ‘Handelaar / Zwakke punten’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    contactsDefaultContactDemand = "Instelling voor Contactnetwerk / Standaardwaarde / Contact / Vraag.",
                    contactsDefaultContactRisk = "Instelling voor Contactnetwerk / Standaardwaarde / Contact / Risico.",
                    contactsDefaultDealerCapacity = "Instelling voor Contactnetwerk / Standaarddealer / capaciteit.",
                    contactsDefaultDealerRisk = "Instelling voor Contactnetwerk / Standaarddealer / Risico.",
                    contactsDefaultDealerSkill = "Instelling voor Contactnetwerk / Standaarddealer / Vaardigheid.",
                    contactsDefaultHotspotRadius = "Instelling voor Contactnetwerk / Standaardwaarde / Hotspot / Straal.",
                    contactsDemandResetMinutes = "Instelling voor Contactnetwerk / Vraagreset (minuten).",
                    contactsEnabled = "Instelling voor Contactnetwerk / Ingeschakeld.",
                    contactsExactLocationTrust = "Instelling voor Contactnetwerk / Exacte locatie / Vertrouwen.",
                    contactsFactionDiscoveryReputation = "Instelling voor Contactnetwerk / Factie / Ontdekking / Reputatie.",
                    contactsFactionHintTrust = "Instelling voor Contactnetwerk / Factie / Aanwijzing / Vertrouwen.",
                    contactsFailedDeliveryCooldownMinutes = "Instelling voor Contactnetwerk / Mislukte levering / Afkoeltijd (minuten).",
                    contactsFakeDealEncounter = "Pas de instellingen voor ‘Nepdeal / Ontmoeting’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    contactsFallbackPreferredDrug = "Instelling voor Contactnetwerk / Vervangende waarde / Voorkeursdrug.",
                    contactsFallbackProductLabel = "Instelling voor Contactnetwerk / Vervangende waarde / Productlabel.",
                    contactsGuideBookItem = "Instelling voor Contactnetwerk / Handleiding / Boek / Voorwerp.",
                    contactsGuideBookTrust = "Instelling voor Contactnetwerk / Handleiding / Boek / Vertrouwen.",
                    contactsHireDealerPrice = "Instelling voor Contactnetwerk / Dealer inhuren / Prijs.",
                    contactsHistoryLimit = "Instelling voor Contactnetwerk / Geschiedenislimiet.",
                    contactsHotspotIntelMinutes = "Instelling voor Contactnetwerk / Hotspot / Informatie / Minuten.",
                    contactsHotspotRotationMinutes = "Instelling voor Contactnetwerk / Hotspot / Wisseling / Minuten.",
                    contactsListingDurationMinutes = "Instelling voor Contactnetwerk / Advertentie / Duur / Minuten.",
                    contactsMaxOwnedDealers = "Instelling voor Contactnetwerk / Maximum / In bezit / Dealers.",
                    contactsMinimumBuyerDeliveryDistance = "Instelling voor Contactnetwerk / Minimum / Koper / Afleverafstand.",
                    contactsMinimumContactRotationMinutes = "Instelling voor Contactnetwerk / Minimum / Contactrotatie (minuten).",
                    contactsMinimumDemandResetMinutes = "Instelling voor Contactnetwerk / Minimum / Vraagreset (minuten).",
                    contactsMinimumHeatMultiplier = "Instelling voor Contactnetwerk / Minimum / Politiedruk / Vermenigvuldiger.",
                    contactsMinimumHotspotIntelMinutes = "Instelling voor Contactnetwerk / Minimum / Hotspot / Informatie / Minuten.",
                    contactsMinimumHotspotRadius = "Instelling voor Contactnetwerk / Minimum / Hotspot / Straal.",
                    contactsMinimumHotspotRotationMinutes = "Instelling voor Contactnetwerk / Minimum / Hotspot / Wisseling / Minuten.",
                    contactsMinimumListingDurationMinutes = "Instelling voor Contactnetwerk / Minimum / Advertentie / Duur / Minuten.",
                    contactsMinimumRewardMultiplier = "Instelling voor Contactnetwerk / Minimale beloning / Vermenigvuldiger.",
                    contactsMinimumRobberyMultiplier = "Instelling voor Contactnetwerk / Minimum / Overval / Vermenigvuldiger.",
                    contactsMinimumSpotPriceMultiplier = "Instelling voor Contactnetwerk / Minimum / Locatie / Prijsvermenigvuldiger.",
                    contactsOtherDrugPriceMultiplier = "Instelling voor Contactnetwerk / Andere / Drug / Prijsvermenigvuldiger.",
                    contactsPaymentAccount = "Instelling voor Contactnetwerk / Betaalrekening.",
                    contactsPostDeliveryDemandResetSeconds = "Instelling voor Contactnetwerk / Na levering / Vraag / Reset / seconden.",
                    contactsPreferredDrugPriceMultiplier = "Instelling voor Contactnetwerk / Voorkeursdrug / Prijsvermenigvuldiger.",
                    contactsRegionLocationTrust = "Instelling voor Contactnetwerk / Regio / Locatie / Vertrouwen.",
                    contactsRequestAmounts = "Pas de instellingen voor ‘Aanvraag / Hoeveelheden’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    contactsRotationMinutes = "Instelling voor Contactnetwerk / Wisseling / Minuten.",
                    contactsSpotPools = "Pas de instellingen voor ‘Locatie / Selectiegroepen’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    contactsStreetHotspots = "Pas de instellingen voor ‘Straat / Hotspots’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    contactsTrustLevels = "Pas de instellingen voor ‘Vertrouwen / Niveaus’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    businessActionCooldownSeconds = "Instelling voor Bedrijfsnetwerk / Actie-cooldown / seconden.",
                    businessBalance = "Pas de instellingen voor ‘Balans’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    businessContracts = "Pas de instellingen voor ‘Contracten’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    businessDefaultBusinessName = "Instelling voor Bedrijfsnetwerk / Standaardwaarde / Bedrijfsnaam.",
                    businessDefaultRankId = "Instelling voor Bedrijfsnetwerk / Standaardwaarde / Rang / ID.",
                    businessDefaultStaffStyle = "Instelling voor Bedrijfsnetwerk / Standaardwaarde / Personeel / Werkwijze.",
                    businessDefaultTransport = "Instelling voor Bedrijfsnetwerk / Standaardwaarde / Transport.",
                    businessEnabled = "Instelling voor Bedrijfsnetwerk / Ingeschakeld.",
                    businessHubs = "Pas de instellingen voor ‘Distributiecentra’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    businessLimits = "Pas de instellingen voor ‘Limieten’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    businessPayments = "Kies welk saldo wordt gebruikt voor aankopen en operationele kosten van het Business Network.",
                    businessPayoutAccount = "Instelling voor Bedrijfsnetwerk / Uitbetaling / Rekening.",
                    businessRanks = "Pas de instellingen voor ‘Rangen’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    businessReportDays = "Instelling voor Bedrijfsnetwerk / Rapportperiode / dagen.",
                    businessRouteEndpointTypes = "Pas de instellingen voor ‘Route / Eindpunt / Typen’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    businessRuntime = "Pas de instellingen voor ‘Spelwerking’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    businessSocietyPermission = "Instelling voor Bedrijfsnetwerk / Organisatie / Toestemming.",
                    businessStaff = "Pas de instellingen voor ‘Personeel’ in het onderdeel ‘Drugsnetwerken’ aan.",
                    businessTickMinutes = "Instelling voor Bedrijfsnetwerk / Updatecyclus / Minuten.",
                    businessTransports = "Pas de instellingen voor ‘Transporten’ in het onderdeel ‘Drugsnetwerken’ aan.",
                },
                robbery = {
                    atmAvailability = "Schakel het standalone ATM-overvallsysteem in of uit.",
                    atmLocations = "Beheer de door de server geautoriseerde ATM-posities die beschikbaar zijn voor overvallen.",
                    atmPolice = "Configureer het vereiste aantal agenten in dienst om een overval te starten.",
                    atmItems = "Stel de benodigde boor-, sleepband- en explosieve-ladingitems in.",
                    atmActionTimes = "Stel de duur in van het bevestigen, plaatsen, detoneren en plunderen van acties.",
                    atmTimeouts = "Controleer hoe lang een geforceerde ATM beschikbaar blijft om te plunderen.",
                    atmPayout = "Configureer de doelrekening en het willekeurige beloningsbereik.",
                    atmDistances = "Stel de spelers- en voertuigbereiken in die worden gebruikt bij ATM-interacties.",
                    atmExplosionEffects = "Configureert de native-parameters voor explosies die tijdens de detonatie worden gebruikt.",
                    atmDispatchAlert = "Configureer de straal, levensduur en prioriteit voor het politie-alarm.",
                    atmDispatchRecipients = "Kies welke jobnamen meldingen van ATM-overvallen ontvangen.",
                    shopAvailability = "Schakel overvallen in en configureer de politie-eis.",
                    shopTiming = "Configureer intimidatie, acties, tijdlimiet en cooldown.",
                    shopSafe = "Configureer toetsenbordpogingen en het boormiddel.",
                    shopRegisterReward = "Configureer de willekeurige beloning voor elke kassa.",
                    shopSafeReward = "Configureer de willekeurige kluisbeloning.",
                    shopDispatchSettings = "Configureer ontvangers en alarmeigenschappen.",
                    shopLocationTable = "Beheer bemande winkellocaties en kluizen.",
                    pickpocketAvailability = "Schakel de functie in en beperk deze optioneel tot geconfigureerde misdaad-jobs.",
                    pickpocketGameplay = "Kies de uitdaging en de onafhankelijke kansen op vluchten, noodoproepen en tegenaanvallen.",
                    pickpocketItemRewards = "Controleer lege zakken en zichtbare itemkeuzes tot op 0,0001 procent.",
                    pickpocketMoney = "Configureer het door de server gegenereerde willekeurige contante bedrag.",
                    pickpocketDistances = "Stel de NPC-range in die wordt gebruikt door het gedeelde radiale en target-systeem.",
                    pickpocketRateLimits = "Regelt request throttling, cooldown per NPC en sessie-verloop.",
                    pickpocketDispatchSettings = "Configureer het alarm dat wordt verzonden wanneer een NPC de hulpdiensten belt.",
                    heistCrafting = "Kies hoeveel interactie vereist is bij het maken van heist-uitrusting. Geldt voor nieuwe pogingen binnen het hele Crime System.",
                    heistCreatorMenu = "Maak, bewerk en publiceer modulaire heists in de speciale Heist Creator.",
                    heistExecution = "Startvenster, inactiviteit en cooldown voor heist-runs.",
                    npcPoliceSupport = "Gewapende NPC-agenten reageren te voet op overvalalarmen en ondersteunen de politie door de overvallers aan te vallen.",
                },
                baseRaids = {
                    baseRaids = "Raid-toegang, vereisten en individueel selecteerbare loot-categorieën. Open raids hebben geen transporttijdlimiet.",
                },
                weapons = {
                    weaponCreatorMenu = "Beheer wapenroutes en witwassen in één editor.",
                    weaponRuntime = "Beheer de beschikbaarheid en toegang tot wapenroutes.",
                    weaponDefaultsgeneral = "Pas de instellingen voor ‘Algemene standaardwaarden’ in het onderdeel ‘Wapenroutes’ aan.",
                    weaponDefaultsaccess = "Pas de instellingen voor ‘Standaardtoegang’ in het onderdeel ‘Wapenroutes’ aan.",
                    weaponDefaultscollection = "Pas de instellingen voor ‘Standaardverzameling’ in het onderdeel ‘Wapenroutes’ aan.",
                    weaponDefaultsproduction = "Pas de instellingen voor ‘Standaardproductie’ in het onderdeel ‘Wapenroutes’ aan.",
                    weaponDefaultsmarket = "Pas de instellingen voor ‘Standaardmarkt’ in het onderdeel ‘Wapenroutes’ aan.",
                    weaponDefaultsdelivery = "Pas de instellingen voor ‘Standaardopdrachten’ in het onderdeel ‘Wapenroutes’ aan.",
                    weaponStreet = "Pas de instellingen voor ‘Wapenverkoop op straat’ in het onderdeel ‘Wapenroutes’ aan.",
                },
                darknetMarket = {
                    darknetAvailability = "Regelt de tablet-app en de plaatsing ervan.",
                    darknetEconomy = "Configureert wallet-saldi, muntwissel en betalingspercentages.",
                    darknetListings = "Regelt limieten voor advertenties, prijzen en automatisch verlopen.",
                    darknetChat = "Beperkt versleutelde berichten op de marktplaats.",
                    darknetIdentity = "Configureert identiteitsrotatie, verificatie en scam-waarschuwingen.",
                    darknetDelivery = "Configureert fysieke ontmoetingen en steelbare wereldkisten.",
                    darknetDeliveryLocations = "Configureert de locatielijsten die willekeurig worden toegewezen aan BlackBay NPC-handel.",
                    darknetPolice = "Jobgroepen die aangestaan zijn om vallen te plaatsen en onderzoeken te bekijken.",
                    darknetNpcTraders = "Permanente NPC-kopers en -verkopers met configureerbaar risico.",
                },
                interrogation = {
                    general = "Pas de instellingen voor ‘Algemeen’ in het onderdeel ‘Verhoor’ aan.",
                    consent = "Pas de instellingen voor ‘Spelerbescherming’ in het onderdeel ‘Verhoor’ aan.",
                    objects = "Pas de instellingen voor ‘Objecten’ in het onderdeel ‘Verhoor’ aan.",
                    grab = "Pas de instellingen voor ‘Overweldigen’ in het onderdeel ‘Verhoor’ aan.",
                    session = "Pas de instellingen voor ‘Sessie’ in het onderdeel ‘Verhoor’ aan.",
                    dispatch = "Pas de instellingen voor ‘Politie-meldingen’ in het onderdeel ‘Verhoor’ aan.",
                    logging = "Pas de instellingen voor ‘Loggen’ in het onderdeel ‘Verhoor’ aan.",
                    security = "Pas de instellingen voor ‘Beveiliging’ in het onderdeel ‘Verhoor’ aan.",
                    presentation = "Pas de instellingen voor ‘Presentatie’ in het onderdeel ‘Verhoor’ aan.",
                },
                reputation = {
                    crimeReputation = "Pas de instellingen voor ‘Reputatie’ in het onderdeel ‘Reputatie’ aan.",
                },
            },
            settingGroups = {
                weaponRuntime = { label = "Algemeen", description = "Beheer de beschikbaarheid en toegang tot wapenroutes." },
                weaponCreatorMenu = { label = "Illegale ondernemer", description = "Beheer wapenroutes en witwassen in één editor." },
                atmActionTimes = {
                    description = "Stel de duur in van het bevestigen, plaatsen, detoneren en plunderen van acties.",
                    label = "Actieduur",
                },
                atmAvailability = {
                    description = "Schakel het standalone ATM-overvallsysteem in of uit.",
                    label = "Beschikbaarheid",
                },
                atmDispatchAlert = {
                    description = "Configureer de straal, levensduur en prioriteit voor het politie-alarm.",
                    label = "Alarmeigenschappen",
                },
                atmDispatchRecipients = {
                    description = "Kies welke jobnamen meldingen van ATM-overvallen ontvangen.",
                    label = "Ontvangers",
                },
                atmDistances = {
                    description = "Stel de spelers- en voertuigbereiken in die worden gebruikt bij ATM-interacties.",
                    label = "Interactieafstanden",
                },
                atmExplosionEffects = {
                    description = "Configureert de native-parameters voor explosies die tijdens de detonatie worden gebruikt.",
                    label = "Explosie-effecten",
                },
                atmItems = {
                    description = "Stel de benodigde boor-, sleepband- en explosieve-ladingitems in.",
                    label = "Benodigde items",
                },
                atmLocations = {
                    description = "Beheer de door de server geautoriseerde ATM-posities die beschikbaar zijn voor overvallen.",
                    label = "ATM-locaties",
                },
                atmPayout = {
                    description = "Configureer de doelrekening en het willekeurige beloningsbereik.",
                    label = "Uitbetaling",
                },
                atmPolice = {
                    description = "Configureer het vereiste aantal agenten in dienst om een overval te starten.",
                    label = "Politie-eis",
                },
                atmPulling = {
                    description = "Configureer de beweging die nodig is om een ATM van de muur te trekken.",
                    label = "Trekken detectie",
                },
                atmTimeouts = {
                    description = "Controleer hoe lang een geforceerde ATM beschikbaar blijft om te plunderen.",
                    label = "Loot-tijdlimiet",
                },
                baseRaids = {
                    description = "Raid-toegang, vereisten en individueel selecteerbare loot-categorieën. Open raids hebben geen transporttijdlimiet.",
                    label = "Base-raids",
                },
                businessPayments = {
                    description = "Kies welk saldo wordt gebruikt voor aankopen en operationele kosten van het Business Network.",
                    label = "Betalingen",
                },
                crimeMembership = {
                    description = "Bepaal hoe criminele organisaties hun leden opslaan en beheren.",
                    label = "Lidmaatschapsmodel",
                },
                darknetAvailability = {
                    description = "Regelt de tablet-app en de plaatsing ervan.",
                    label = "Beschikbaarheid",
                },
                darknetChat = {
                    description = "Beperkt versleutelde berichten op de marktplaats.",
                    label = "Privéchat",
                },
                darknetDelivery = {
                    description = "Configureert fysieke ontmoetingen en steelbare wereldkisten.",
                    label = "Overdracht en dead drops",
                },
                darknetDeliveryLocations = {
                    description = "Configureert de locatielijsten die willekeurig worden toegewezen aan BlackBay NPC-handel.",
                    label = "Overdrachtslocaties",
                },
                darknetEconomy = {
                    description = "Configureert wallet-saldi, muntwissel en betalingspercentages.",
                    label = "Cryptovaluta",
                },
                darknetIdentity = {
                    description = "Configureert identiteitsrotatie, verificatie en scam-waarschuwingen.",
                    label = "Aliases en reputatie",
                },
                darknetListings = {
                    description = "Regelt limieten voor advertenties, prijzen en automatisch verlopen.",
                    label = "Aanbiedingen en verval",
                },
                darknetNpcTraders = {
                    description = "Permanente NPC-kopers en -verkopers met configureerbaar risico.",
                    label = "NPC-handelaars",
                },
                darknetPolice = {
                    description = "Jobgroepen die aangestaan zijn om vallen te plaatsen en onderzoeken te bekijken.",
                    label = "Politie-toegang",
                },
                heistCrafting = {
                    description = "Kies hoeveel interactie vereist is bij het maken van heist-uitrusting. Geldt voor nieuwe pogingen binnen het hele Crime System.",
                    label = "Heist-werkplaats",
                },
                heistCreatorMenu = {
                    description = "Maak, bewerk en publiceer modulaire heists in de speciale Heist Creator.",
                    label = "Creator-menu",
                },
                heistExecution = {
                    description = "Startvenster, inactiviteit en cooldown voor heist-runs.",
                    label = "Heist-timing",
                },
                moneywashEconomy = {
                    description = "Schakel bedrijven in en configureer de stortingsrekening, servicekosten en interactieafstanden.",
                    label = "Algemeen",
                },
                npcPoliceSupport = {
                    description = "Gewapende NPC-agenten reageren te voet op overvalalarmen en ondersteunen de politie door de overvallers aan te vallen.",
                    label = "NPC-politieondersteuning",
                },
                pickpocketAvailability = {
                    description = "Schakel de functie in en beperk deze optioneel tot geconfigureerde misdaad-jobs.",
                    label = "Beschikbaarheid",
                },
                pickpocketDispatchSettings = {
                    description = "Configureer het alarm dat wordt verzonden wanneer een NPC de hulpdiensten belt.",
                    label = "Noodoproep-dispatch",
                },
                pickpocketDistances = {
                    description = "Stel de NPC-range in die wordt gebruikt door het gedeelde radiale en target-systeem.",
                    label = "Interactieafstanden",
                },
                pickpocketGameplay = {
                    description = "Kies de uitdaging en de onafhankelijke kansen op vluchten, noodoproepen en tegenaanvallen.",
                    label = "Risico en minigame",
                },
                pickpocketItemRewards = {
                    description = "Controleer lege zakken en zichtbare itemkeuzes tot op 0,0001 procent.",
                    label = "Zichtbare zakinhoud",
                },
                pickpocketMoney = {
                    description = "Configureer het door de server gegenereerde willekeurige contante bedrag.",
                    label = "Contant geld beloning",
                },
                pickpocketRateLimits = {
                    description = "Regelt request throttling, cooldown per NPC en sessie-verloop.",
                    label = "Serverbeveiliging",
                },
                pvpArenas = {
                    description = "Maak de cirkelvormige zone, het observatiepunt en de team-spawnpunten aan die worden gebruikt voor PvP-events.",
                    label = "Arena's en gevechtszones",
                },
                pvpAutomation = {
                    description = "Configureer terugkerende evenementen en automatische startverwerking.",
                    label = "Automatisering",
                },
                pvpAvailability = {
                    description = "Controleer of de PvP-event app beschikbaar is en waar deze verschijnt.",
                    label = "Beschikbaarheid",
                },
                pvpLimits = {
                    description = "Stel limieten in voor beloningen en de tablet-geschiedenis.",
                    label = "Limieten en geschiedenis",
                },
                pvpModes = {
                    description = "Configureer de spelmodus die vooraf is geselecteerd op de PvP-tablet.",
                    label = "Spelmodi",
                },
                pvpPermissions = {
                    description = "Koppel eventbeheer en financiën aan ACE- en job-rechten.",
                    label = "Machtigingen",
                },
                pvpRuntime = {
                    description = "Stel request-afhandeling, sterfgevallen en respawns in tijdens live matches.",
                    label = "Event-duur",
                },
                pvpTakeoverMethods = {
                    description = "Configureer hoe lang elke methode nodig heeft om een ingang te forceren.",
                    label = "Inbraakmethoden",
                },
                pvpTakeoverRules = {
                    description = "Regelt de beschikbaarheid en deelnamevereisten voor laboratorium- en camperovernames.",
                    label = "Overnameregels",
                },
                pvpTakeoverZones = {
                    description = "Configureer interactie-, melding- en veroveringsgebieden samen met hun duur.",
                    label = "Zones en timing",
                },
                shopAvailability = {
                    description = "Schakel overvallen in en configureer de politie-eis.",
                    label = "Beschikbaarheid",
                },
                shopDispatchSettings = {
                    description = "Configureer ontvangers en alarmeigenschappen.",
                    label = "Politie-alarm",
                },
                shopLocationTable = {
                    description = "Beheer bemande winkellocaties en kluizen.",
                    label = "Winkellocaties",
                },
                shopRegisterReward = {
                    description = "Configureer de willekeurige beloning voor elke kassa.",
                    label = "Kassa-beloning",
                },
                shopRegisterTable = {
                    description = "Wijs individuele kassa's toe aan winkels.",
                    label = "Kassa's",
                },
                shopSafe = {
                    description = "Configureer toetsenbordpogingen en het boormiddel.",
                    label = "Kluis",
                },
                shopSafeReward = {
                    description = "Configureer de willekeurige kluisbeloning.",
                    label = "Kluisbeloning",
                },
                shopTiming = {
                    description = "Configureer intimidatie, acties, tijdlimiet en cooldown.",
                    label = "Tijden",
                },
            },
            settingSections = {
                weapons = "Wapenroutes",
                drugs = "Drugssysteem",
                drugProduction = "Drugsproductie",
                drugOperations = "Drugsbedrijven",
                drugMarketRisk = "Markt en risico",
                drugNetworks = "Drugsnetwerken",
                atmRobbery = "Geldautomaatoverval",
                baseRaids = "Base-raids",
                crimeOrganizations = "Organisaties",
                darknetMarket = "Darknet Markt",
                moneywash = "Geldwassen",
                pvpEvents = "Factie PvP",
                robbery = "Overval",
                territories = "Territoria",
                graffiti = "Graffiti",
                interrogation = "Verhoor",
            },
            settingSubsections = {
                baseRaidEquipment = "Vereiste uitrusting",
                baseRaidBreach = "Binnendringen",
                baseRaidLoot = "Buit en voertuigen",
                graffitiLimits = "Limieten en moderatie",
                interrogationTechnical = "Logboek en beveiliging",
                atmDispatch = "Politie-dispatch",
                atmEquipment = "Uitrusting",
                atmExplosion = "Explosie",
                atmOverview = "Overzicht & locaties",
                atmRewards = "Beloningen",
                atmTiming = "Tijden",
                atmVehicle = "Voertuig & uittrekken",
                baseRaids = "Base-raids",
                crimeMembership = "Lidmaatschap",
                heistCreator = "Overvalmaker",
                npcPoliceSupport = "NPC-politieondersteuning",
                pickpocket = "NPC zakkenrollen",
                pvpArenas = "Arena's",
                pvpEquipment = "Spelmodi",
                pvpOverview = "Overzicht",
                pvpRuntime = "Event-duur",
                pvpTakeovers = "Laboratoriumovernames",
                shopRobbery = "Winkelovervallen",
                atmRobbery = "Geldautomaatoverval",
            },
            settings = {
                weaponDefaultGeneralInteractionDistance = { label = "Interactieafstand" },
                weaponDefaultGeneralPedModel = { label = "Standaard NPC-model" },
                weaponDefaultAccessActiveHourStart = { label = "Openingstijd (UTC)" },
                weaponDefaultAccessActiveHourEnd = { label = "Sluitingstijd (UTC)" },
                weaponDefaultAccessPoliceRequired = { label = "Benodigde agenten in dienst" },
                weaponDefaultAccessPoliceJobs = { label = "Politiefuncties" },
                weaponDefaultCollectionDurationSeconds = { label = "Duur in seconden" },
                weaponDefaultCollectionCooldownSeconds = { label = "Wachttijd in seconden" },
                weaponDefaultCollectionCooldownScope = { label = "Bereik van wachttijd" },
                weaponDefaultCollectionUseMinigame = { label = "Minispel gebruiken" },
                weaponDefaultCollectionMinigame = { label = "Minispel" },
                weaponDefaultCollectionMinigameRounds = { label = "Minispelrondes" },
                weaponDefaultProductionDurationSeconds = { label = "Duur in seconden" },
                weaponDefaultProductionSuccessChance = { label = "Slagingskans (%)" },
                weaponDefaultProductionFailureConsumesInputs = { label = "Materialen verbruiken bij mislukking" },
                weaponDefaultProductionUseMinigame = { label = "Minispel gebruiken" },
                weaponDefaultProductionMinigame = { label = "Minispel" },
                weaponDefaultProductionMinigameRounds = { label = "Minispelrondes" },
                weaponDefaultProductionQualityMin = { label = "Minimale kwaliteit" },
                weaponDefaultProductionQualityMax = { label = "Maximale kwaliteit" },
                weaponDefaultProductionCooldownSeconds = { label = "Wachttijd in seconden" },
                weaponDefaultProductionCooldownScope = { label = "Bereik van wachttijd" },
                weaponDefaultMarketPayoutAccount = { label = "Uitbetalingsrekening" },
                weaponDefaultMarketPriceMultiplierMin = { label = "Minimale prijsfactor (%)" },
                weaponDefaultMarketPriceMultiplierMax = { label = "Maximale prijsfactor (%)" },
                weaponDefaultMarketRestockSeconds = { label = "Aanvulinterval in seconden" },
                weaponDefaultMarketCooldownSeconds = { label = "Wachttijd in seconden" },
                weaponDefaultMarketCooldownScope = { label = "Bereik van wachttijd" },
                weaponDefaultDeliveryContractDurationMinutes = { label = "Opdrachttermijn in minuten" },
                weaponDefaultDeliveryContractBonusPercent = { label = "Opdrachtbonus (%)" },
                weaponStreetEnabled = { label = "Zeldzame wapenverkopen aan straatkopers" },
                weaponStreetChance = { label = "Kans op wapenaanbod (%)" },
                weaponStreetCooldown = { label = "Wachttijd in seconden" },
                weaponStreetAmount = { label = "Maximale hoeveelheid" },
                weaponStreetPriceMin = { label = "Minimale prijsfactor (%)" },
                weaponStreetPriceMax = { label = "Maximale prijsfactor (%)" },
                weaponStreetAccount = { label = "Uitbetalingsrekening" },
                weaponStreetDirect = { label = "Directe verkoop" },
                weaponStreetBulk = { label = "Partijverkoop" },
                weaponStreetContract = { label = "Kartelopdracht" },
                weaponSystemEnabled = { label = "Wapenroutesysteem", description = "Schakel het verzamelen, verwerken en verkopen van wapens aan kartels in." },
                weaponRuntimeEnabled = { label = "Acties van wapenroutes", description = "Sta het gebruik van ingestelde wapenroutes in de spelwereld toe." },
                weaponCreatorAccess = { label = "Toegang tot wapeneditor", description = "Kies wie de wapeneditor mag openen.", options = { permission = "Alleen met toestemming", jobManagement = "Jobbeheer", ownerOnly = "Alleen eigenaar" } },
                openWeaponCreator = { label = "Illegale ondernemer", description = "Beheer wapenroutes en witwassen in één editor.", buttonLabel = "Illegale ondernemer", unsavedTooltip = "Eerst opslaan" },

                drugCultivationProgressionEnabled = { label = "Kweekniveaus inschakelen", description = "Schakelt kweek-XP, niveaus en niveaugebonden ontgrendelingen in." },
                drugCultivationMaxLevel = { label = "Maximaal kweekniveau", description = "Hoogst bereikbare kweekniveau. Hogere niveaus blijven onbereikbaar." },
                drugCultivationLevels = { label = "Niveaucurve", description = "Stel de naam en totale XP-drempel voor elk kweekniveau in." },
                drugCultivationActionXp = { label = "XP-beloningen", description = "Stel in hoeveel kweek-XP elke actie oplevert." },
                drugCultivationUnlocks = { label = "Niveau-ontgrendelingen", description = "Stel het vereiste niveau in voor containers, substraten, apparatuur, soorten en scannerniveaus." },
                reputationRewards = { label = "Reputatieacties", description = "Voeg acties toe, wijzig punten en schakel vermeldingen uit of verwijder ze. Alleen actieve vermeldingen geven punten." },
                reputationEnabled = { label = "Criminelereputatie inschakelen", description = "Persoonlijke reputatie toekennen." },
                reputationPointsPerLevel = { label = "Punten per niveau", description = "Elk niveau vereist dit aantal extra punten." },
                reputationMinimumJoinPoints = { label = "Minimale reputatie voor toetreding", description = "Vereist puntentotaal om lid te worden van een criminele factie. 0 schakelt de eis uit. Bestaande leden behouden toegang." },
                reputation_atm = { label = "Geldautomaatroof", description = "Punten per succesvol voltooide actie. 0 schakelt deze beloning uit." },
                reputation_shop_register = { label = "Winkelkassa", description = "Punten per succesvol voltooide actie. 0 schakelt deze beloning uit." },
                reputation_shop_safe = { label = "Winkelkluis", description = "Punten per succesvol voltooide actie. 0 schakelt deze beloning uit." },
                reputation_pickpocket = { label = "Zakkenrollen", description = "Punten per succesvol voltooide actie. 0 schakelt deze beloning uit." },
                reputation_heist = { label = "Voltooide overval", description = "Punten per succesvol voltooide actie. 0 schakelt deze beloning uit." },
                reputation_drug_harvest = { label = "Drugsoogst", description = "Punten per succesvol voltooide actie. 0 schakelt deze beloning uit." },
                reputation_drug_processing = { label = "Drugsverwerking", description = "Punten per succesvol voltooide actie. 0 schakelt deze beloning uit." },
                reputation_drug_sale = { label = "Drugsverkoop", description = "Punten per succesvol voltooide actie. 0 schakelt deze beloning uit." },
                reputation_drug_delivery = { label = "Drugslevering", description = "Punten per succesvol voltooide actie. 0 schakelt deze beloning uit." },
                reputation_drug_contract = { label = "Distributiecontract", description = "Punten per succesvol voltooide actie. 0 schakelt deze beloning uit." },
                reputation_drug_raid = { label = "Drugsroof", description = "Punten per succesvol voltooide actie. 0 schakelt deze beloning uit." },
                reputation_graffiti = { label = "Graffiti", description = "Punten per succesvol voltooide actie. 0 schakelt deze beloning uit." },
                reputation_moneywash = { label = "Witwassen", description = "Punten per succesvol voltooide actie. 0 schakelt deze beloning uit." },
                reputation_base_raid = { label = "Basisoverval", description = "Punten per succesvol voltooide actie. 0 schakelt deze beloning uit." },
                reputation_pvp_win = { label = "PvP-overwinning", description = "Punten per succesvol voltooide actie. 0 schakelt deze beloning uit." },
                atmChargeProp = {
                    description = "Objectmodel dat op de ATM wordt getoond terwijl de explosieve lading is geplaatst.",
                    label = "Explosief object",
                },
                atmConsumeDrill = {
                    description = "Verbruikt het ingestelde aantal na elk succesvol voltooid boorpunt van de geldautomaat.",
                    label = "Boor verbruiken",
                },
                atmDrillItem = {
                    description = "Inventaris-ID van het item dat nodig is om een losgetrokken geldautomaat open te boren. Staat los van de boor voor winkelkluizen.",
                    label = "Booritem",
                },
                atmDrillItemAmount = {
                    description = "Aantal booritems dat voor elk boorpunt van de geldautomaat nodig is.",
                    label = "Vereist aantal boren",
                },
                atmDebug = {
                    description = "Schrijft gedetailleerde diagnostiek van ATM-overvallen naar de serverconsole en de client F8-console.",
                    label = "ATM debug-logs",
                },
                atmDispatchDurationSeconds = {
                    description = "Aantal seconden dat de ATM-melding relevant blijft voor dispatch-ontvangers.",
                    label = "Dispatch-duur",
                },
                atmDispatchEnabled = {
                    description = "Maakt een Jobs Base-incident aan wanneer een ATM wordt geforceerd.",
                    label = "Politie-dispatch inschakelen",
                },
                atmDispatchJobs = {
                    description = "Door komma's gescheiden jobnamen die de ATM-waarschuwing ontvangen.",
                    label = "Dispatch-jobs",
                },
                atmDispatchPriority = {
                    description = "Prioriteitswaarde die ongewijzigd naar de dispatch-integratie wordt doorgegeven.",
                    label = "Dispatch-prioriteit",
                },
                atmDispatchRadius = {
                    description = "Ongeveer de alarmradius die naar de dispatch-integratie wordt gestuurd.",
                    label = "Alarmradius",
                },
                atmEnabled = {
                    description = "Maakt geconfigureerde geldautomaten beschikbaar voor slingers- en explosieve overvallen.",
                    label = "Geldautomaten-overvallen inschakelen",
                },
                atmExplosionCameraShake = {
                    description = "Intensiteit van de camerashake voor de client die de explosie veroorzaakt.",
                    label = "Explosie camerashake",
                },
                atmExplosionDamageScale = {
                    description = "Schade- en impulssterkte doorgegeven aan de explosie-native.",
                    label = "Explosieschaal",
                },
                atmExplosionType = {
                    description = "GTA-explosietype dat wordt gebruikt bij de detonatie. Behoud de standaard, tenzij een ander type is getest.",
                    label = "Explosietype",
                },
                atmDrillDurationSeconds = {
                    label = "Minimale boortijd per schroef (s)",
                    description = "Minimale tijd in seconden voor elk van de vier schroeven. Afkoelpauzes verlengen de poging. Geldt voor boorpogingen die na het opslaan beginnen.",
                },
                atmExplosiveDurationSeconds = {
                    description = "Aantal seconden dat nodig is om de explosieve lading te plaatsen.",
                    label = "Duur van het plaatsen van de lading",
                },
                atmExplosiveItem = {
                    description = "Inventarisitem dat wordt verbruikt nadat de lading is geplaatst.",
                    label = "Explosief item",
                },
                atmExplosiveItemAmount = {
                    description = "Aantal verbruikte explosieve items voor één geplaatste lading.",
                    label = "Verbruikte hoeveelheid explosieven",
                },
                atmFuseSeconds = {
                    description = "Aantal seconden tussen het plaatsen en de detonatie.",
                    label = "Brandduur",
                },
                atmInteractionDistance = {
                    description = "Maximale client-actieradius; servervalidatie voegt een veiligheidsmarge toe.",
                    label = "Interactieafstand",
                },
                atmLocations = {
                    description = "Officiële productielocaties. Locaties aangemaakt met /atmtest blijven tijdelijk.",
                    itemLabel = "ATM-locatie",
                    label = "ATM-locaties",
                },
                atmLootDurationSeconds = {
                    description = "Seconden die nodig zijn om een geforceerde geldautomaat te kraken.",
                    label = "Buit-duur",
                },
                atmLootReservationTimeoutSeconds = {
                    description = "Maximale seconden dat een speler een geldautomaat mag reserveren tijdens het openen; wordt automatisch boven de loot-duur gehouden.",
                    label = "Loot-reservering timeout",
                },
                atmLootWindowMinutes = {
                    description = "Minuten dat een geforceerde geldautomaat lootbaar blijft voordat deze leeg is.",
                    label = "Loot-venster",
                },
                atmMinimumPolice = {
                    description = "Aantal leden van de geconfigureerde politie-job die in dienst moeten zijn om een overval te starten.",
                    label = "Minimaal aantal politieagenten",
                },
                atmPoliceGroup = {
                    description = "sky_jobs_base jobgroep telt mee voor de politie-eis.",
                    label = "Politie-jobgroep",
                },
                atmPullDistance = {
                    description = "Voertuigverplaatsing vanaf de positie van de geldautomaat die vereist is om de braak te voltooien.",
                    label = "Vereiste trekafstand",
                },
                atmPullMinimumSpeed = {
                    description = "Minimale voertuigsnelheid in meter per seconde wanneer de trekkersafstand is bereikt.",
                    label = "Minimale treksnelheid",
                },
                atmReservationTimeoutSeconds = {
                    description = "Maximaal aantal seconden gereserveerd terwijl een speler een sling plaatst of een explosief; wordt automatisch boven de actieduur gehouden.",
                    label = "Time-out voor de reservering van de voorbereiding",
                },
                atmRewardAccount = {
                    description = "Kies tussen contant geld en het item black_money.",
                    label = "Uitbetalingstype geldautomaat",
                },
                atmRewardMaximum = {
                    description = "Hoogste contante uitbetaling van één geldautomaat; nooit lager dan het minimum.",
                    label = "Maximale beloning",
                },
                atmRewardMinimum = {
                    description = "Laagste contante uitbetaling van één geldautomaat.",
                    label = "Minimale beloning",
                },
                atmSlingDurationSeconds = {
                    description = "Aantal seconden vereist om de sling aan te brengen.",
                    label = "Duur sling aanbrengen",
                },
                atmSlingItem = {
                    description = "Herbruikbaar inventarisitem vereist voor de voertuigmethode.",
                    label = "Sling-item",
                },
                atmSlingItemAmount = {
                    description = "Aantal sling-items dat aanwezig moet zijn. Deze worden niet verbruikt.",
                    label = "Vereist aantal sling-items",
                },
                atmTestScanDistance = {
                    description = "Maximale afstand die wordt gebruikt door /atmtest bij het zoeken naar een ondersteund ATM-object.",
                    label = "ATM-test scanafstand",
                },
                atmVehicleMaxDistance = {
                    description = "Maximale afstand tussen de geldautomaat en een geschikt voertuig bij het bevestigen van de sjorband.",
                    label = "Afstand voertuig bij bevestigen",
                },
                baseRaid_breachTimeoutSeconds = {
                    description = "Tijdslimiet per poging om een opslagpunt open te breken (seconden).",
                    label = "Inbraak-tijdslimiet (seconden)",
                },
                baseRaid_command = {
                    description = "Commando zonder slash. Herstart de crime-resource na wijziging.",
                    label = "Raid-commando",
                },
                baseRaid_crimeItem = {
                    description = "Inbraakitem voor bende.",
                    label = "Inbraakitem voor bende",
                },
                baseRaid_crimeVehicles = {
                    description = "Toegang tot bende-voertuigen.",
                    label = "Toegang tot bende-voertuigen",
                },
                baseRaid_difficulty = {
                    description = "Moeilijkheidsgraad skillcheck.",
                    label = "Moeilijkheidsgraad skillcheck",
                    options = {
                        easy = "Makkelijk",
                        expert = "Deskundige",
                        hard = "Moeilijk",
                        normal = "Normaal",
                    },
                },
                baseRaid_enabled = {
                    description = "Base raids inschakelen.",
                    label = "Base raids inschakelen",
                },
                baseRaid_failedCooldownMinutes = {
                    description = "Wachttijd wanneer een inval eindigt zonder een opslagpunt te openen (minuten).",
                    label = "Cooldown na mislukking (minuten)",
                },
                baseRaid_interactionDistance = {
                    description = "Interactieafstand opslag.",
                    label = "Interactieafstand opslag",
                },
                baseRaid_lootHeistStorage = {
                    description = "Sta volledige opname toe van deze inventariscategorie tijdens een actieve raid.",
                    label = "Loot heist-opslag",
                },
                baseRaid_lootLaboratories = {
                    description = "Sta volledige opname toe van deze inventariscategorie tijdens een actieve raid.",
                    label = "Loot laboratory opslag",
                },
                baseRaid_lootPersonalLockers = {
                    description = "Sta volledige opname toe van deze inventariscategorie tijdens een actieve raid.",
                    label = "Persoonlijke kluisjes plunderen",
                },
                baseRaid_lootStorage = {
                    description = "Sta volledige opname toe van deze inventariscategorie tijdens een actieve raid.",
                    label = "Loot opslag",
                },
                baseRaid_lootVehicleGloveboxes = {
                    description = "Sta volledige opname toe van deze inventariscategorie tijdens een actieve raid.",
                    label = "Handschuhkastjes plunderen",
                },
                baseRaid_lootVehicleTrunks = {
                    description = "Sta volledige opname toe van deze inventariscategorie tijdens een actieve raid.",
                    label = "Kofferbakken plunderen",
                },
                baseRaid_minimumDefenders = {
                    description = "Minimaal aantal online verdedigers.",
                    label = "Minimaal aantal online verdedigers",
                },
                baseRaid_policeItem = {
                    description = "Item voor politie-inbraak.",
                    label = "Item voor politie-inbraak",
                },
                baseRaid_policeRequireDuty = {
                    description = "Politie moet dienst hebben.",
                    label = "Politie moet dienst hebben",
                },
                baseRaid_policeVehicles = {
                    description = "Toegang tot politievoertuigen.",
                    label = "Toegang tot politievoertuigen",
                },
                baseRaid_protectionHours = {
                    description = "Bescherming na succes (uren).",
                    label = "Bescherming na succes (uren)",
                },
                baseRaid_requiredHits = {
                    description = "Vereist aantal skillcheck-treffers.",
                    label = "Vereist aantal skillcheck-treffers",
                },
                baseRaid_warrantItem = {
                    description = "Eén van deze items wordt verbruikt bij elke geldige start van een politie-raid.",
                    label = "Huiszoekingsbevel-item",
                },
                crimeMembershipMode = {
                    description = "De Framework-modus behoudt de bestaande job- of native gang-integratie. De onafhankelijke modus voert de misdaadorganisatie op de achtergrond uit naast de normale job van de speler en migreert bestaande lidmaatschappen automatisch.",
                    label = "Organisatiemodus voor lidmaatschap",
                    options = {
                        framework = "Framework-job / Gang",
                        independent = "Onafhankelijke organisatie",
                    },
                },
                darknetAliasChangeCooldownHours = {
                    description = "Minimale leeftijd van een identiteit voordat deze opnieuw kan worden ingetrokken.",
                    label = "Wachttijd aliaswijziging (uren)",
                },
                darknetCurrencyCode = {
                    description = "Korte label die wordt getoond voor het interne cryptovaluta-grootboek.",
                    label = "Valuta-code",
                },
                darknetDeadDropInteractionDistance = {
                    description = "Vereiste afstand om een kist te doorzoeken en op te eisen.",
                    label = "Dead-drop interactie-afstand",
                },
                darknetDeadDropLifetimeHours = {
                    description = "Tijd voordat een niet-opgeëiste kist verloopt.",
                    label = "Dead-drop levensduur (uren)",
                },
                darknetDeadDropModel = {
                    description = "GTA-propmodel dat lokaal wordt gespawned voor beschikbare dead drops.",
                    label = "Dead-drop kistmodel",
                },
                darknetDeadDropPollIntervalMs = {
                    description = "Interval dat wordt gebruikt om nabijgelegen kisten en NPC-ontmoetingen te verversen.",
                    label = "Wereld-verversingsinterval (ms)",
                },
                darknetDeadDropStreamDistance = {
                    description = "Afstand waarbij kisten en NPC-ontmoetingscontacten worden gestreamd.",
                    label = "Dead-drop stream-afstand",
                },
                darknetDropLocations = {
                    description = "Locaties die willekeurig worden toegewezen aan dead-drop transacties met NPC's. Configureer er minstens twee.",
                    itemLabel = "Dead-drop locatie",
                    label = "Dead-drop locaties",
                },
                darknetEnabled = {
                    description = "Maakt de zwartmarkt-tablet-app en de runtime beschikbaar.",
                    label = "Darknet Markt inschakelen",
                },
                darknetExchangeBuyPrice = {
                    description = "Bedrag dat voor één munt van het betalingsaccount wordt afgeschreven.",
                    label = "Koopprijs per munt",
                },
                darknetExchangeEnabled = {
                    description = "Stelt geauthenticeerde BlackBay-gebruikers in staat om munten te kopen en verkopen op hun accountpagina.",
                    label = "Muntwissel inschakelen",
                },
                darknetExchangeMaximumAmount = {
                    description = "Grootste ronde munthoeveelheid die in één wissel wordt geaccepteerd.",
                    label = "Maximaal aantal munten per wissel",
                },
                darknetExchangeMinimumAmount = {
                    description = "Kleinste ronde munthoeveelheid die in één wissel wordt geaccepteerd.",
                    label = "Minimaal aantal munten per wissel",
                },
                darknetExchangePaymentAccount = {
                    description = "Framework-account dat wordt gebruikt voor aankopen van munten en uitbetalingen van verkopen.",
                    label = "Betalingsaccount voor wissel",
                    options = {
                        bank = "Bank",
                        black_money = "Vies geld",
                        money = "Contant",
                    },
                },
                darknetExchangeSellPrice = {
                    description = "Bedrag dat voor één munt aan het betalingsaccount wordt uitgekeerd.",
                    label = "Verkoopprijs per munt",
                },
                darknetFaceToFaceDistance = {
                    description = "Maximale afstand tussen beide spelers of de geconfigureerde NPC-locatie.",
                    label = "Overdrachtsafstand",
                },
                darknetKnownScammerReports = {
                    description = "Unieke handelsmeldingen vereist voor het 'bekende oplichter'-badge.",
                    label = "Meldingen voor oplichter-waarschuwing",
                },
                darknetListingExpiryHours = {
                    description = "Actieve aanbiedingen verlopen automatisch na dit aantal uren.",
                    label = "Aanbiedingsduur (uren)",
                },
                darknetMaximumListingQuantity = {
                    description = "Bovengrens voor de hoeveelheid goederen in één aanbieding.",
                    label = "Maximale hoeveelheid goederen",
                },
                darknetMaximumListings = {
                    description = "Maximale aanbiedingen per actieve alias.",
                    label = "Maximale actieve aanbiedingen",
                },
                darknetMaximumMessageLength = {
                    description = "Maximaal aantal tekens per versleuteld chatbericht.",
                    label = "Maximale berichtlengte",
                },
                darknetMaximumUnitPrice = {
                    description = "Maximale cryptoprijs voor een enkele eenheid.",
                    label = "Maximale eenheidsprijs",
                },
                darknetMeetingLocations = {
                    description = "Locaties die willekeurig worden toegewezen voor fysieke handel met NPC's. Configureer er minstens twee.",
                    itemLabel = "Ontmoetingslocatie",
                    label = "Ontmoetingslocaties",
                },
                darknetNpcBuyerAliases = {
                    description = "Fictieve namen die willekeurig worden toegewezen aan nieuwe NPC-koopverzoeken. Configureer minstens twee unieke aliassen.",
                    label = "NPC-koper aliassen",
                },
                darknetNpcMaximumBuyListings = {
                    description = "Bovengrens die wordt gebruikt bij het willekeurig kiezen van het aantal actieve NPC-koopverzoeken.",
                    label = "Maximale NPC-koopverzoeken",
                },
                darknetNpcMaximumSellListings = {
                    description = "Bovengrens die wordt gebruikt bij het willekeurig kiezen hoeveel NPC-verkoopaanbiedingen actief worden.",
                    label = "Maximaal aantal NPC-verkoopaanbiedingen",
                },
                darknetNpcMinimumBuyListings = {
                    description = "Wanneer de NPC-markt wordt aangevuld, blijven er minstens dit aantal willekeurig geselecteerde koopverzoeken actief.",
                    label = "Minimaal aantal NPC-koopverzoeken",
                },
                darknetNpcMinimumSellListings = {
                    description = "Wanneer de NPC-markt wordt aangevuld, blijven er minstens dit aantal willekeurig geselecteerde verkoopaanbiedingen actief.",
                    label = "Minimaal aantal NPC-verkoopaanbiedingen",
                },
                darknetNpcSellerAliases = {
                    description = "Fictieve namen die willekeurig worden toegewezen aan nieuwe NPC-verkoopaanbiedingen. Configureer ten minste twee unieke aliassen.",
                    label = "NPC-verkoper aliassen",
                },
                darknetNpcTraders = {
                    description = "Configureer synthetische aanbiedingen, leveringsmethode, reputatie en oplichtingskans.",
                    label = "NPC-kopers en -verkopers",
                },
                darknetPoliceGroups = {
                    description = "Groeps-keys die lokprikkelingen kunnen publiceren en onderzoeken kunnen bekijken.",
                    label = "Geautoriseerde politie-jobgroepen",
                },
                darknetRenewalHours = {
                    description = "Aantal uren dat wordt toegevoegd wanneer een eigenaar een aanbieding verlengt.",
                    label = "Verlengingsduur (uren)",
                },
                darknetScamChance = {
                    description = "Minimale kans dat een NPC-handel de betaling of goederen inneemt zonder de tegenprestatie te leveren. Een hogere handelaar-specifieke kans blijft van kracht.",
                    label = "Globale NPC-oplichterkans (%)",
                },
                darknetStarterBalance = {
                    description = "Crypto wordt alleen toegewezen wanneer een speler de markt voor de eerste keer opent.",
                    label = "Nieuw wallet-saldo",
                },
                darknetTabletOrder = {
                    description = "Regelt de positie van de Darknet Markt op de tablet.",
                    label = "Tablet-app volgorde",
                },
                darknetVerifiedMinimumRating = {
                    description = "Minimale gemiddelde beoordeling voor een geverifieerde verkoper.",
                    label = "Benodigde beoordeling voor verificatie",
                },
                darknetVerifiedMinimumSales = {
                    description = "Aantal succesvolle verkopen vereist voordat een verkoper geverifieerd kan worden.",
                    label = "Aantal benodigde verkopen voor verificatie",
                },
                drugAdvancedBusinessNetworkPaymentAccount = {
                    description = "Wordt gebruikt wanneer de betaalbron is ingesteld op het spelersaccount. Betalingen van de organisatie verlopen altijd via het Boss Menu-account.",
                    label = "Spelersbetaalrekening",
                    options = {
                        bank = "Bank",
                        black_money = "Vies geld",
                        money = "Contant",
                    },
                    requiresWarning = "Wordt alleen gebruikt met de betaalbron van het spelersaccount.",
                },
                drugAdvancedBusinessNetworkPaymentSource = {
                    description = "Gebruik ofwel het saldo van de betalende speler, ofwel het Boss Menu-account van de organisatie.",
                    label = "Betaalbron",
                    options = {
                        player = "Spelersaccount",
                        society = "Organisatie-account",
                    },
                },
                drugCamperLockKey = {
                    description = "Stelt de standaardtoets in voor het vergrendelen en ontgrendelen van eigen of door de factie gedeelde campers. Spelers kunnen dit wijzigen in hun FiveM-toetsinstellingen.",
                    label = "Standaardtoets camper-slot",
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
                    description = "Voeg standaard kwaliteit- en batchgegevens toe aan de verzamelaar-outputs. Schakel dit uit om grondstoffen normaal te laten stapelen.",
                    label = "Metadata verzamelaar-item",
                },
                drugLabAssaultAlertDuration = {
                    description = "Aantal seconden dat de alarmradius voor verdedigers zichtbaar blijft op de kaart.",
                    label = "Duur van verdediger-alarm",
                },
                drugLabAssaultAlertRadius = {
                    description = "Radius van de aanvalszone die op de kaart wordt getoond aan de verdedigende faction.",
                    label = "Alertradius verdediger",
                },
                drugLabAssaultBreachRadius = {
                    description = "Straal waarbinnen een aanvaller moet blijven terwijl de ingang wordt geforceerd.",
                    label = "Actieradius bij het openbreken",
                },
                drugLabAssaultCaptureDuration = {
                    description = "Aantal seconden dat aanvallers de ingang ongestoord moeten vasthouden om het laboratorium of de camper over te nemen.",
                    label = "Duur van overname",
                },
                drugLabAssaultCaptureRadius = {
                    description = "Ingangszone die wordt gebruikt om aanvallers en strijdende verdedigers te tellen.",
                    label = "Veroveringsradius",
                },
                drugLabAssaultElectronicDuration = {
                    description = "Aantal seconden dat nodig is om het toegangssysteem te hacken.",
                    label = "Duur elektronische inbraak",
                },
                drugLabAssaultEnabled = {
                    description = "Stelt facties in staat om rivaliserende laboratoria en door facties gedeelde campers te forceren en over te nemen.",
                    label = "Laboratorium- en camperovernames inschakelen",
                },
                drugLabAssaultExplosiveDuration = {
                    description = "Seconden die nodig zijn om de ingang te forceren met een explosief.",
                    label = "Duur explosieve doorbraak",
                },
                drugLabAssaultInteractionDistance = {
                    description = "Maximale afstand tot de ingang van het laboratorium of de camper wanneer een aanval wordt gestart.",
                    label = "Interactieafstand bij de ingang",
                },
                drugLabAssaultMechanicalDuration = {
                    description = "Aantal seconden dat nodig is om het slot van de ingang te boren.",
                    label = "Duur mechanische inbraak",
                },
                drugLabAssaultMinimumDefenders = {
                    description = "Aantal online leden van de verdedigende factie dat vereist is voordat een aanval mag beginnen.",
                    label = "Minimaal aantal verdedigers",
                },
                drugLabAssaultRequireDuty = {
                    description = "Telt alleen leden van de verdedigende factie die momenteel dienst hebben.",
                    label = "Alleen diensthabende verdedigers tellen",
                },
                drugProcessingInventoryMetadata = {
                    description = "Voeg standaard kwaliteit- en batchgegevens toe aan verwerkingsresultaten. Individuele recepten kunnen deze instelling overschrijven.",
                    label = "Metagegevens verwerkingsitem",
                },
                graffitiItemName = {
                    description = "Inventarisitem dat vereist is om te gaan spuiten wanneer de itemvereiste is ingeschakeld. Het item moet in de actieve inventaris aanwezig zijn.",
                    label = "Benodigd graffiti-item",
                },
                heistCooldownMinutes = {
                    description = "Blokkeert dezelfde heist na een run met daadwerkelijke interacties die is beëindigd en opgeruimd. Nul schakelt de cooldown uit. Een ongebruikt startvenster activeert deze niet.",
                    label = "Heist-cooldown (minuten)",
                },
                heistCraftingMode = {
                    optionDescriptions = {
                        simple = "Voortgangsbalk van vijf seconden. Benodigde ingrediënten worden bij succes verbruikt.",
                        medium = "Selecteer ingrediënten in de getoonde volgorde en slaag voor één timingtest per ingrediënt.",
                        advanced = "Volledige apparaatmontage voor recepten met een apparaatprofiel; anders twee nauwkeurige timingtests per ingrediënt.",
                    },
                    description = "Simpel: vijfseconden voortgangsbalk. Medium: selectie van ingrediënten en timing-checks. Maximaal: volledige apparaatmontage; recepten zonder apparaatprofiel gebruiken twee nauwkeurige timing-checks per ingrediënt.",
                    label = "Crafting-complexiteit",
                    options = {
                        advanced = "Maximale complexiteit",
                        medium = "Gemiddelde complexiteit",
                        simple = "Simpel",
                    },
                },
                heistInactivityTimeoutMinutes = {
                    description = "Na de eerste interactie reset elke nieuwe heist-actie deze timer. Bij het verstrijken eindigt de run en worden de wereldobjecten verwijderd. Geldt voor nieuwe runs.",
                    label = "Inactiviteitslimiet heist (minuten)",
                },
                heistStartTimeoutMinutes = {
                    description = "Tijd na het drukken op Start om te interageren bij het doelwit. Zonder interactie wordt de run gereset en kan deze opnieuw worden gestart. Geldt voor nieuwe runs.",
                    label = "Minuten tot eerste heist-interactie",
                },
                moneywashAccount = {
                    options = {
                        bank = "Bank",
                        black_money = "Vies geld",
                        money = "Contant",
                    },
                },
                moneywashDirtyAccount = {
                    description = "Rekening waarvan het zwarte geld van een speler wordt afgeschreven wanneer een wascyclus start.",
                    label = "Stortingsrekening",
                },
                moneywashDrawDistance = {
                    description = "Maximale afstand in meters waarbinnen ingangen van bedrijven en winkels worden weergegeven.",
                    label = "Weergaveafstand",
                },
                moneywashEnabled = {
                    description = "Maakt geldwasbedrijven van de organisatie beschikbaar.",
                    label = "Geldwassen inschakelen",
                },
                moneywashFeePercent = {
                    description = "Percentage dat van elke batch wordt ingehouden voordat deze aan de organisatie wordt uitgekeerd.",
                    label = "Servicekosten (%)",
                },
                moneywashInteractionDistance = {
                    description = "Maximale afstand in meters voor het gebruiken van ingangen van bedrijven en winkels.",
                    label = "Interactieafstand",
                },
                npcPoliceAccuracy = {
                    description = "Nauwkeurigheid van NPC-agenten van 0 tot 100.",
                    label = "Schietnauwkeurigheid",
                },
                npcPoliceArmour = {
                    description = "Pantserwaarde van elke NPC-agent van 0 tot 100.",
                    label = "Lichaamsbeplating",
                },
                npcPoliceAtms = {
                    description = "Stuur NPC-politieondersteuning wanneer een alarm voor een ATM-overval wordt geactiveerd.",
                    label = "Ondersteuning tijdens ATM-overvallen",
                },
                npcPoliceDurationSeconds = {
                    description = "Maximale tijd dat NPC-agenten actief blijven na het spawnen (30–900 seconden).",
                    label = "Inzetduur (seconden)",
                },
                npcPoliceEnabled = {
                    description = "Stuur gewapende NPC-agenten wanneer een overvalalarm wordt geactiveerd. Standaard uitgeschakeld.",
                    label = "NPC-politieondersteuning inschakelen",
                },
                npcPoliceHeists = {
                    description = "Stuur NPC-politieondersteuning wanneer een heist-alarm wordt geactiveerd.",
                    label = "Ondersteuning tijdens heists",
                },
                npcPoliceOfficerCount = {
                    description = "Aantal gewapende NPC-agenten dat per overvalalarm wordt gestuurd (1–8).",
                    label = "Agenten per inzet",
                },
                npcPoliceResponseDelaySeconds = {
                    description = "Tijd tussen het overvalalarm en de aankomst van NPC-agenten (0–300 seconden).",
                    label = "Reactievertraging (seconden)",
                },
                npcPoliceShops = {
                    description = "Stuur NPC-politieondersteuning wanneer een alarm voor een winkeloverval wordt geactiveerd.",
                    label = "Ondersteuning tijdens winkelovervallen",
                },
                npcPoliceSpawnDistance = {
                    description = "Doelafstand vanaf de locatie van de overval waarbij NPC-agenten spawnen (15–150 meter).",
                    label = "Spawn-afstand (meters)",
                },
                npcPoliceWeapon = {
                    description = "Wapen dat elke reagerende NPC-agent draagt. De standaard is een pistool.",
                    label = "Dienstwapen",
                    options = {
                        WEAPON_CARBINERIFLE = "Carbinegeweer",
                        WEAPON_PISTOL = "Pistool",
                        WEAPON_PUMPSHOTGUN = "Hagelgeweer met pompactie",
                    },
                },
                openHeistCreator = {
                    buttonLabel = "Heist Creator openen",
                    description = "Open de Heist Creator en sluit de Job Configurator.",
                    label = "Overvalmaker",
                    unsavedTooltip = "Sla eerst wijzigingen op",
                },
                pickpocketAggressionChance = {
                    description = "Onafhankelijke kans dat de NPC aanvalt na een mislukte, geannuleerde of verlopen poging.",
                    label = "Tegenaanval kans (%)",
                },
                pickpocketAlertChance = {
                    description = "Onafhankelijke kans dat de NPC een mislukte, geannuleerde of verlopen poging meldt.",
                    label = "Noodoproep-kans (%)",
                },
                pickpocketDifficulty = {
                    description = "Regelt de cursorsnelheid, hoe snel het doel krimpt, de sequentielengte en de toegestane fouten.",
                    label = "Moeilijkheidsgraad",
                    options = {
                        easy = "Makkelijk",
                        expert = "Deskundige",
                        hard = "Moeilijk",
                        normal = "Normaal",
                    },
                },
                pickpocketDispatchAlways = {
                    description = "Meld elke gestarte poging tot zakkenrollen één keer, ook bij succes en ongeacht de kans op een noodoproep.",
                    label = "Altijd een melding versturen",
                },
                pickpocketDispatchDurationSeconds = {
                    description = "Aantal seconden dat de melding relevant blijft voor de dispatch-ontvangers.",
                    label = "Dispatch-duur",
                },
                pickpocketDispatchJobs = {
                    description = "Met komma's gescheiden jobnamen die noodoproepen ontvangen.",
                    label = "Dispatch-jobs",
                },
                pickpocketDispatchPriority = {
                    description = "Prioriteit wordt ongewijzigd doorgegeven aan de dispatch-integratie.",
                    label = "Dispatch-prioriteit",
                },
                pickpocketDispatchRadius = {
                    description = "Benaderde alarmeringsradius die naar de dispatch-integratie wordt gestuurd.",
                    label = "Dispatch-radius",
                },
                pickpocketEmptyChance = {
                    description = "Kans dat de NPC helemaal geen selecteerbare buit bij zich heeft.",
                    label = "Kans op lege zakken (%)",
                },
                pickpocketEnabled = {
                    description = "Stelt spelers in staat om relevante, willekeurige netwerk-NPC's te bestelen.",
                    label = "NPC zakkenrollen inschakelen",
                },
                pickpocketFleeChance = {
                    description = "Onafhankelijke kans dat de NPC wegrent na een mislukte, geannuleerde of verlopen poging.",
                    label = "NPC vluchtkans (%)",
                },
                pickpocketInteractionDistance = {
                    description = "Maximale client-afstand; de server valideert met een kleine synchronisatie-marge.",
                    label = "Interactieafstand",
                },
                pickpocketItems = {
                    description = "Elke rij bepaalt de kans op verschijnen. Vier decimalen ondersteunen 0.0001 procent.",
                    itemLabel = "Item-kans",
                    label = "Item-buit",
                },
                pickpocketItemsEnabled = {
                    description = "Rolt ook geconfigureerde items in de zichtbare inhoud van de zakken.",
                    label = "Item loot inschakelen",
                },
                pickpocketMaximumLootChoices = {
                    description = "Maximaal aantal door de server gegenereerde cash- of item-slots dat wordt getoond voor één NPC.",
                    label = "Maximaal zichtbare buit",
                },
                pickpocketMinigame = {
                    description = "Kies één uitdaging of roteer willekeurig tussen alle drie.",
                    label = "Minispel",
                    options = {
                        pulse = "Drukimpuls",
                        random = "Willekeurige rotatie",
                        sequence = "Richtingvolgorde",
                        timing = "Timing-balken",
                    },
                },
                pickpocketMoneyMaximum = {
                    description = "Hoogste zichtbare contante hoeveelheid; wordt automatisch op of boven het minimum gehouden.",
                    label = "Maximaal contant geld",
                },
                pickpocketMoneyMinimum = {
                    description = "Laagste door de server gegenereerde bedrag voor een zichtbare cash-slot.",
                    label = "Minimaal contant geld",
                },
                pickpocketRequestCooldownSeconds = {
                    description = "Minimaal aantal seconden tussen aanvragen van één speler.",
                    label = "Aanvraag-cooldown",
                },
                pickpocketRequireCrimeJob = {
                    description = "Ingeschakeld: voegt de actie alleen toe aan geregistreerde Crime System-jobs. Uitgeschakeld: verwijdert de ingebouwde radial-actie en vereist de server-export.",
                    label = "Gebruik Crime-job radial",
                },
                pickpocketRequiredHits = {
                    description = "Basiswaarde voor elk minigame. Waardevol contant geld verhoogt deze stapsgewijs; extreem zeldzame items vereisen minstens acht treffers.",
                    label = "Minimaal aantal treffers",
                },
                pickpocketSessionTimeoutSeconds = {
                    description = "Aantal seconden voordat een onvoltooide server-challenge verloopt.",
                    label = "Sessie-time-out",
                },
                pickpocketTargetCooldownMinutes = {
                    description = "Lockout na geannuleerde of mislukte pogingen; succesvol geleegde NPC's blijven niet beschikbaar.",
                    label = "NPC-cooldown",
                },
                pvpAdminAce = {
                    description = "ACE-object dat toegang verleent tot wereldwijd beheer van PvP-events.",
                    label = "ACE-beheerdersrecht",
                },
                pvpArenaReturnSeconds = {
                    description = "Standaard terugkeertijd voor nieuwe events. Event-leiders kunnen dit aanpassen via de tablet.",
                    label = "Arena terugkeertijd",
                },
                pvpArenaWarningPosition = {
                    description = "Bepaalt waar de waarschuwing om terug te keren naar de arena verschijnt.",
                    label = "Arena waarschuwingspositie",
                    options = {
                        bottom_center = "Ondermidden",
                        bottom_left = "Linksonder",
                        bottom_right = "Rechtsonder",
                        middle_center = "Midden scherm",
                        middle_left = "Links midden",
                        middle_right = "Rechtsmidden",
                        top_center = "Boven midden",
                        top_left = "Links boven",
                        top_right = "Rechtsboven",
                    },
                },
                pvpArenas = {
                    description = "Creëert cirkelvormige gevechtszones met een toeschouwerspunt en minstens twee spawn-punten voor teams.",
                    itemLabel = "Arena",
                    label = "PvP-arena's",
                },
                pvpCountdownPosition = {
                    description = "Bepaalt waar de countdown voor de start van de wedstrijd verschijnt.",
                    label = "Countdown-positie",
                    options = {
                        bottom_center = "Ondermidden",
                        bottom_left = "Linksonder",
                        bottom_right = "Rechtsonder",
                        middle_center = "Midden scherm",
                        middle_left = "Links midden",
                        middle_right = "Rechtsmidden",
                        top_center = "Boven midden",
                        top_left = "Links boven",
                        top_right = "Rechtsboven",
                    },
                },
                pvpDefaultMode = {
                    description = "Vooraf geselecteerde spelmodus voor nieuwe events.",
                    label = "Standaard spelmodus",
                    options = {
                        free_for_all = "Iedereen tegen iedereen",
                        last_man_standing = "Last Man Standing",
                        team_deathmatch = "Team Deathmatch",
                    },
                },
                pvpDefaultScoreLimit = {
                    description = "Standaard aantal kills dat vereist is om Team Deathmatch of Free For All te winnen.",
                    label = "Standaard kill-doel",
                },
                pvpEventsEnabled = {
                    description = "Maakt de faction PvP-tablet-app en event-runtime beschikbaar.",
                    label = "Faction PvP-events inschakelen",
                },
                pvpKillfeedPosition = {
                    description = "Bepaalt waar recente eliminaties worden getoond.",
                    label = "Killfeed-positie",
                    options = {
                        bottom_center = "Ondermidden",
                        bottom_left = "Linksonder",
                        bottom_right = "Rechtsonder",
                        middle_center = "Midden scherm",
                        middle_left = "Links midden",
                        middle_right = "Rechtsmidden",
                        top_center = "Boven midden",
                        top_left = "Links boven",
                        top_right = "Rechtsboven",
                    },
                },
                pvpLeaderPermission = {
                    description = "Benodigde job-toestemming om factie-events te creëren, te registreren, te starten en te beheren.",
                    label = "Toestemming factieleider",
                },
                pvpMatchDurationMinutes = {
                    description = "Standaardduur in minuten voor nieuwe events. Nul schakelt de tijdslimiet uit.",
                    label = "Matchduur",
                },
                pvpMaxHistory = {
                    description = "Maximaal aantal voltooide of geannuleerde events dat wordt teruggestuurd naar de tablet.",
                    label = "Zichtbare eventgeschiedenis",
                },
                pvpMaxRewards = {
                    description = "Maximaal aantal gecombineerde item-, wapen-, voertuig- of geldbeloningen per event.",
                    label = "Maximale extra beloningen",
                },
                pvpMoneyPermission = {
                    description = "Job-permissie vereist voor entreegelden en prijzengeld.",
                    label = "Faction-financiële permissie",
                },
                pvpRequestCooldownMs = {
                    description = "Minimaal aantal milliseconden tussen muterende PvP-verzoeken van één speler.",
                    label = "Actie-cooldown",
                },
                pvpRespawnDelaySeconds = {
                    description = "Seconden voordat een speler respawnt of na overlijden naar het toeschouwersgebied wordt verplaatst.",
                    label = "Respawn-vertraging",
                },
                pvpSchedulePollSeconds = {
                    description = "Aantal seconden tussen de controles van terugkerende sjablonen en automatische starts.",
                    label = "Interval voor planning-controle",
                },
                pvpScoreboardPosition = {
                    description = "Bepaalt waar het compacte live-scorebord verschijnt tijdens factie-matches.",
                    label = "Scorebord positie",
                    options = {
                        bottom_center = "Ondermidden",
                        bottom_left = "Linksonder",
                        bottom_right = "Rechtsonder",
                        middle_center = "Midden scherm",
                        middle_left = "Links midden",
                        middle_right = "Rechtsmidden",
                        top_center = "Boven midden",
                        top_left = "Links boven",
                        top_right = "Rechtsboven",
                    },
                },
                pvpSoloTestingEnabled = {
                    description = "Hiermee kunnen PvP-administrateurs zich registreren en handmatig starten met één factiemedewerker. Schakel dit uit op productieservers.",
                    label = "Administrator solo-test inschakelen",
                },
                pvpStartCountdownSeconds = {
                    description = "Standaard countdown voor nieuw aangemaakte events. Eventleiders kunnen dit aanpassen in de tablet.",
                    label = "Start-countdown",
                },
                pvpTabletOrder = {
                    description = "Bepaalt waar de faction PvP-app op de tablet verschijnt.",
                    label = "Tablet-app volgorde",
                },
                shopActiveTimeoutMinutes = {
                    description = "Minuten voordat een verlaten overval mislukt.",
                    label = "Actieve tijdlimiet",
                },
                shopConsumeDrill = {
                    description = "Verbruik de boormachine na succesvolle opening.",
                    label = "Boormachine verbruiken",
                },
                shopConsumeHackItem = {
                    description = "Verbruik het hacking-item nadat de kluis succesvol is geopend.",
                    label = "Hacking-item verbruiken",
                },
                shopCooldownMinutes = {
                    description = "Aantal minuten runtime voordat de winkel wordt gereset.",
                    label = "Winkel cooldown",
                },
                shopDispatchAlways = {
                    description = "Meld elke winkeloverval één keer bij de start, ook bij ononderbroken bedreiging en in winkels zonder verplichte verkoper.",
                    label = "Altijd een melding versturen",
                },
                shopDispatchDurationSeconds = {
                    description = "Aantal seconden dat de melding relevant blijft.",
                    label = "Dispatch-duur",
                },
                shopDispatchJobs = {
                    description = "Door komma's gescheiden jobs voor alarmontvangers.",
                    label = "Dispatch-jobs",
                },
                shopDispatchPriority = {
                    description = "Prioriteit doorgegeven aan dispatch.",
                    label = "Dispatch-prioriteit",
                },
                shopDispatchRadius = {
                    description = "Ongeveer politie-alarmradius.",
                    label = "Dispatch-radius",
                },
                shopDrillDurationSeconds = {
                    description = "Aantal seconden dat nodig is om de kluis te boren.",
                    label = "Duur van het boren van de kluis",
                },
                shopDrillItem = {
                    description = "Inventaris-ID van het item dat nodig is om winkelkluizen open te boren. Staat los van de boor voor geldautomaten.",
                    label = "Boormachine-item",
                },
                shopDrillItemAmount = {
                    description = "Aantal vereiste boor-items.",
                    label = "Benodigd aantal boren",
                },
                shopEnabled = {
                    description = "Schakelt overvallen in geconfigureerde winkels met personeel in.",
                    label = "Winkelovervallen inschakelen",
                },
                shopHackItem = {
                    description = "Item vereist voor de kluis-hackminigame. Schakel de openingsmethode afzonderlijk in voor elke winkel.",
                    label = "Hacking-item",
                },
                shopHackItemAmount = {
                    description = "Vereiste hoeveelheid van het hacking-item.",
                    label = "Hacking item hoeveelheid",
                },
                shopIntimidationSeconds = {
                    description = "Aantal seconden dat de winkelier onder pistoolpunt moet blijven.",
                    label = "Duur van intimidatie",
                },
                shopLocations = {
                    description = "Eén medewerker, één kassa en een optionele kluis per winkel.",
                    itemLabel = "Winkel",
                    label = "Winkellocaties",
                },
                shopMinimumPolice = {
                    description = "Aantal diensthabende politieleden dat vereist is om te starten.",
                    label = "Minimaal aantal politie",
                },
                shopPoliceGroup = {
                    description = "Jobgroep die wordt meegeteld voor de politie-eis.",
                    label = "Politie-jobgroep",
                },
                shopRegisterDurationSeconds = {
                    description = "Seconden die nodig zijn om een kassa leeg te maken.",
                    label = "Duur kassa-loot",
                },
                shopRegisterRewardMaximum = {
                    description = "Hoogste kassa-uitbetaling.",
                    label = "Maximale kassa-beloning",
                },
                shopRegisterRewardMinimum = {
                    description = "Laagste kassa-uitbetaling.",
                    label = "Minimale kassa-beloning",
                },
                shopRegisterRewardName = {
                    description = "Optionele item- of accountnaam.",
                    label = "Naam van de kassa-beloning",
                },
                shopRegisterRewardSort = {
                    description = "Kies tussen contant geld en het item black_money.",
                    label = "Uitbetalingstype kassa",
                },
                shopRegisters = {
                    description = "Kassaposities toegewezen via winkel-ID.",
                    itemLabel = "Kassa",
                    label = "Kassa's",
                },
                shopSafeLootDurationSeconds = {
                    description = "Aantal seconden dat nodig is om het geld te pakken na het invoeren van een geldige kluiscode.",
                    label = "Duur kluisplundering",
                },
                shopSafeRewardMaximum = {
                    description = "Hoogste veilige uitbetaling.",
                    label = "Maximale veilige beloning",
                },
                shopSafeRewardMinimum = {
                    description = "Laagste veilige uitbetaling.",
                    label = "Minimale veilige beloning",
                },
                shopSafeRewardName = {
                    description = "Optionele item- of accountnaam.",
                    label = "Naam kluisbeloning",
                },
                shopSafeRewardSort = {
                    description = "Kies tussen contant geld en het item black_money.",
                    label = "Uitbetalingstype kluis",
                },
                shopThreatGraceSeconds = {
                    description = "Toegestane onderbreking voor het alarm.",
                    label = "Doelwit-tolerantie",
                },
                territoryDrugSalesEnabled = {
                    description = "Succesvolle straatverkopen aan NPC's geven invloed aan de gang van de verkoper in het huidige straatterritorium.",
                    label = "NPC-verkopen geven territoriuminvloed",
                },
                atmLocationMode = {
                    label = "Locatiemodus voor pinautomaten",
                    description = "Detecteert ondersteunde wereldobjecten automatisch of gebruikt alleen handmatig ingestelde locaties.",
                    options = {
                        automatic = "Automatisch",
                        manual = "Handmatig",
                    },
                },
                atmPoliceRequirementEnabled = {
                    label = "Agenten in dienst vereisen",
                    description = "Vereist het ingestelde aantal agenten in dienst voordat een pinautomaatroof kan beginnen.",
                },
                openDrugCreator = {
                    label = "Drugseditor",
                    description = "Opent de Sky Crime-drugseditor en sluit de jobconfigurator.",
                    buttonLabel = "Drugseditor openen",
                    unsavedTooltip = "Eerst opslaan",
                },
                drugCreatorRuntimeDensity = {
                    label = "Dichtheid van het bedrijfsoverzicht",
                    description = "Bepaalt hoe compact het bedrijfspaneel in de drugseditor wordt weergegeven.",
                    options = {
                        comfortable = "Comfortabel",
                        compact = "Compact",
                    },
                },
                drugCreatorListDensity = {
                    label = "Lijstdichtheid",
                    description = "Bepaalt hoe compact de lijst met items in de editor wordt weergegeven.",
                    options = {
                        comfortable = "Comfortabel",
                        compact = "Compact",
                    },
                },
                drugCreatorShowEmptyRuntimeLists = {
                    label = "Lege bedrijfslijsten tonen",
                    description = "Toont onderdelen van het bedrijfsoverzicht ook als ze leeg zijn.",
                },
                drugCreatorHideDisabledEntries = {
                    label = "Uitgeschakelde items verbergen",
                    description = "Verbergt uitgeschakelde module-items in de lijst van de drugseditor.",
                },
                drugCreatorAutoGenerateId = {
                    label = "ID's automatisch genereren",
                    description = "Maakt ID's van namen bij het aanmaken van nieuwe items in de drugseditor.",
                },
                drugCreatorOpenEditorOnModuleChange = {
                    label = "Editor openen bij modulewissel",
                    description = "Opent de editor automatisch bij het wisselen van de actieve module.",
                },
                drugCreatorSmartDuplicateSuffix = {
                    label = "Automatisch achtervoegsel voor kopieën",
                    description = "Voegt automatisch een achtervoegsel toe bij het dupliceren van items in de drugseditor.",
                },
                drugCreatorAutoSelectRuntimeTargets = {
                    label = "Speldoelen automatisch selecteren",
                    description = "Selecteert beschikbare labs en partijen automatisch vooraf.",
                },
                drugCreatorAttentionOnOpen = {
                    label = "Problemen tonen bij openen",
                    description = "Opent het bedrijfsoverzicht met nadruk op items die aandacht nodig hebben.",
                },
                drugActivityHudPosition = {
                    label = "Positie activiteit-HUD",
                    description = "Sleep de HUD voor plaatsen en oogsten naar de gewenste schermpositie.",
                },
                drugInteractionHudPosition = {
                    label = "Positie interactie-HUD",
                    description = "Sleep de interactie-HUD voor planten, laboratoria en campers naar de gewenste schermpositie.",
                },
                drugPlantStatusHudPosition = {
                    label = "Positie plantenstatus-HUD",
                    description = "Sleep de gedetailleerde plantenstatus-HUD naar de gewenste schermpositie.",
                },
                drugSystemEnabled = {
                    label = "Drugssysteem",
                    description = "Activeert: drugsproductie, editorgegevens en spelinterfaces voor deze misdaadjob.",
                },
                drugCreatorAccess = {
                    label = "Toegang tot de drugseditor",
                    description = "Bepaalt wie de geavanceerde drugseditor mag openen.",
                    options = {
                        permission = "Alleen met toestemming",
                        job_management = "Jobbeheer",
                        owner_only = "Alleen eigenaar",
                    },
                },
                drugRuntimeEnabled = {
                    label = "Interfaces voor spelacties",
                    description = "Staat spelers toe de lab-, plant-, verwerkings- en marktacties in het spel te gebruiken.",
                },
                drugRuntimePlayerCreateLabs = {
                    label = "Labs aanmaken door spelers",
                    description = "Staat spelers met systeemtoegang toe labs uit editorsjablonen te maken, ook zonder beheerdersrechten.",
                },
                drugRuntimeOutdoorPlanting = {
                    label = "Buitenteelt",
                    description = "Staat eigen buitenplantages van spelers buiten ingestelde labs toe.",
                },
                drugRuntimePublicOutdoorHarvest = {
                    label = "Buitenoogst door andere spelers",
                    description = "Staat andere spelers toe buitenplanten te oogsten die zij niet zelf hebben geplant.",
                },
                drugRuntimeChargeLabPurchase = {
                    label = "Labkoop in rekening brengen",
                    description = "Brengt spelers bij het aanmaken van een lab de ingestelde koopprijs in rekening.",
                },
                drugRuntimeStrictInventory = {
                    label = "Inventarishandelingen strikt controleren",
                    description = "Spelacties gaan alleen verder als de ingestelde handelingen voor items, gereedschap en geld slagen.",
                },
                drugRuntimeSalePayouts = {
                    label = "Verkoop / Uitbetalingen",
                    description = "Betaalt spelers wanneer partijen of routes via het marktsysteem worden verkocht.",
                },
                drugRuntimeSalePayoutAccount = {
                    label = "Uitbetaling / Rekening",
                    description = "Rekening voor uitbetalingen uit drugsverkopen, bijvoorbeeld black_money.",
                },
                drugRuntimeDispatchEnabled = {
                    label = "Verzenden / Alarmen",
                    description = "Stuurt drugsrisicogebeurtenissen naar de meldkamer en de ingestelde politiejobs.",
                },
                drugRuntimeNotifyPoliceJobs = {
                    label = "Politie / Meldingen",
                    description = "Meldt een politiealarm uit een drugsrisicogebeurtenis aan de ingestelde politiejobs.",
                },
                drugBatchPrefix = {
                    label = "Batch / Voorvoegsel",
                    description = "Voorvoegsel voor ID's van nieuwe drugspartijen.",
                },
                drugTestingKitAccuracy = {
                    label = "Testset / Nauwkeurigheid",
                    description = "Toegestane afwijking van verborgen waarden bij een eenvoudige testkit.",
                },
                drugDecayIntervalMinutes = {
                    label = "Verval / Interval",
                    description = "Interval in minuten voor controles op afname van versheid en verontreiniging.",
                },
                drugDefaultPackaging = {
                    label = "Standaardwaarde / Verpakking",
                    description = "Verpakking voor ruwe of verwerkte partijen zonder opgegeven verpakkingstype.",
                    options = {
                        loose = "Losse waren",
                        baggy = "Zakje",
                        jar = "Pot",
                        vacuum = "Vacuümzak",
                        brick = "Blokverpakking",
                        premium_seal = "Premium verzegeling",
                    },
                },
                drugQualityWeightQuality = {
                    label = "Kwaliteit / Gewicht",
                    description = "Invloed op de eindkwaliteit: Basiskwaliteit.",
                },
                drugQualityWeightPurity = {
                    label = "Zuiverheid / Gewicht",
                    description = "Invloed op de eindkwaliteit: Zuiverheid.",
                },
                drugQualityWeightFreshness = {
                    label = "Versheid / Gewicht",
                    description = "Invloed op de eindkwaliteit: Versheid.",
                },
                drugQualityWeightPotency = {
                    label = "Potentie / Gewicht",
                    description = "Invloed op de eindkwaliteit: Potentie.",
                },
                drugQualityWeightStability = {
                    label = "Stabiliteit / Gewicht",
                    description = "Invloed op de eindkwaliteit: Stabiliteit.",
                },
                drugQualityWeightContamination = {
                    label = "Contaminatie / Aftrek",
                    description = "Kwaliteitsaftrek voor verontreinigde producten.",
                },
                drugTierGoodMin = {
                    label = "Goed / Niveau / Minimum",
                    description = "Minimumscore voor kwaliteitsniveau Goed.",
                },
                drugTierPremiumMin = {
                    label = "Premium / Niveau / Minimum",
                    description = "Minimumscore voor kwaliteitsniveau Premium.",
                },
                drugTierTopShelfMin = {
                    label = "Uitzonderlijke kwaliteit / Niveau / Minimum",
                    description = "Minimumscore voor kwaliteitsniveau Uitzonderlijke kwaliteit.",
                },
                drugTierLabGradeMin = {
                    label = "Laboratoriumkwaliteit / Niveau / Minimum",
                    description = "Minimumscore voor kwaliteitsniveau Laboratoriumkwaliteit.",
                },
                drugBaggyDecayMultiplier = {
                    label = "Zakje / Verval",
                    description = "Vermenigvuldiger voor versheidsverlies / Zakjes.",
                },
                drugJarDecayMultiplier = {
                    label = "Pot / Verval",
                    description = "Vermenigvuldiger voor versheidsverlies / Potten.",
                },
                drugVacuumDecayMultiplier = {
                    label = "Vacuüm / Verval",
                    description = "Vermenigvuldiger voor versheidsverlies / Vacuümzakken.",
                },
                drugPremiumSealPriceMultiplier = {
                    label = "Premium verzegeling / Prijs",
                    description = "Vermenigvuldiger voor Premium / Verzegeld product / Prijs.",
                },
                drugGrowingEnabled = {
                    label = "Teelt / Ingeschakeld",
                    description = "Activeert: plantengroei en oogsten.",
                },
                drugEnvironmentSurveyEnabled = {
                    label = "Controle van de plantlocatie",
                    description = "Indien ingeschakeld wachten vrij geplaatste planten op een automatische locatiecontrole door een beheerder. Schakel dit uit om groei zonder goedkeuring van een beheerder toe te staan.",
                },
                drugGrowthTickMinutes = {
                    label = "Groei / Updatecyclus / Minuten",
                    description = "Interval in minuten voor updates van plantengroei.",
                },
                drugBaseGrowthPerTick = {
                    label = "Basiswaarde / Groei / Per updatestap",
                    description = "Basisgroei vóór de invloed van soort, uitrusting en verzorging.",
                },
                drugWildPlantRespawnMinutes = {
                    label = "Wilde plant / Opnieuw verschijnen",
                    description = "Wachttijd in minuten tot: Wilde plant / Opnieuw verschijnen.",
                },
                drugWildPlantHighlightEnabled = {
                    label = "Wilde planten markeren",
                    description = "Toont een omtrek rond gespawnde wilde planten zodra een speler binnen de markeringsstraal komt.",
                },
                drugWildPlantHighlightDistance = {
                    label = "Markeringsstraal voor wilde planten",
                    description = "Afstand in meters rond elke gespawnde wilde plant waarbinnen de omtrek zichtbaar wordt.",
                },
                drugDefaultPlantWater = {
                    label = "Standaardwaarde / Water",
                    description = "Beginwaarde bij het aanmaken van een plant: Water.",
                },
                drugDefaultPlantFertilizer = {
                    label = "Standaardwaarde / Meststof",
                    description = "Beginwaarde bij het aanmaken van een plant: Meststof.",
                },
                drugDefaultPlantHealth = {
                    label = "Standaardwaarde / Gezondheid",
                    description = "Beginwaarde bij het aanmaken van een plant: Gezondheid.",
                },
                drugDefaultPlantMutationChance = {
                    label = "Standaardwaarde / Mutatiekans",
                    description = "Basiskans op mutatie als de plantensoort geen eigen waarde opgeeft.",
                },
                drugHarvestPerfectStart = {
                    label = "Begin van optimale oogstperiode",
                    description = "Groeipercentage voor het optimale oogstmoment: Begin.",
                },
                drugHarvestPerfectEnd = {
                    label = "Einde van optimale oogstperiode",
                    description = "Groeipercentage voor het optimale oogstmoment: Einde.",
                },
                drugLabsEnabled = {
                    label = "Labs / Ingeschakeld",
                    description = "Activeert: labs en campers in het spel.",
                },
                drugMaxLaboratoriesPerCharacter = {
                    label = "Laboratoria per personage",
                    description = "Maximum aantal gekochte of gehuurde vaste laboratoria per eigenaar. 0 betekent onbeperkt; campers en gedeelde toegang tellen niet mee.",
                },
                drugMaxLaboratoriesPerFaction = {
                    label = "Laboratoria per factie",
                    description = "Maximum aantal gekochte of gehuurde vaste laboratoria per eigenaar. 0 betekent onbeperkt; campers en gedeelde toegang tellen niet mee.",
                },
                drugDefaultRentDays = {
                    label = "Standaardwaarde / Huurdagen",
                    description = "Standaardwaarde voor Lab / Huur / Duur.",
                },
                drugCamperHotVehicleMinutes = {
                    label = "Gestolen camper / Minuten",
                    description = "Hoelang gestolen campers een verhoogd risico houden.",
                },
                drugLabRentWarningHours = {
                    label = "Huur / Waarschuwing / Uren",
                    description = "Aantal uren vóór het verlopen van de labhuur waarop een waarschuwing verschijnt.",
                },
                drugLabRentExpiredHeatGain = {
                    label = "Verlopen huur / Politiedruk",
                    description = "Extra politieaandacht wanneer de huur van het lab verloopt.",
                },
                drugCamperMoveCooldownMinutes = {
                    label = "Camper / Verplaatsen / Wachttijd",
                    description = "Wachttijd in minuten tot: Camper / Lab / Opnieuw verplaatsen.",
                },
                drugLabUpgradeCostMultiplier = {
                    label = "Verbetering / Kosten / Vermenigvuldiger",
                    description = "Vermenigvuldiger voor Lab / Niveau / Verbetering / Prijzen.",
                },
                drugCamperBaseSlots = {
                    label = "Camper / Plaatsen",
                    description = "Standaardwaarde voor camperlabs / apparatuurslots.",
                },
                drugCamperBaseStorage = {
                    label = "Camper / Opslag",
                    description = "Standaardwaarde voor camperlabs / Opslagcapaciteit.",
                },
                drugCamperBasePower = {
                    label = "Camper / Energie",
                    description = "Standaardwaarde voor camperlabs / Ingebouwde stroomvoorziening.",
                },
                drugBasementBaseSlots = {
                    label = "Kelder / Plaatsen",
                    description = "Standaardwaarde voor kelderlabs / apparatuurslots.",
                },
                drugBasementBaseStorage = {
                    label = "Kelder / Opslag",
                    description = "Standaardwaarde voor kelderlabs / Opslagcapaciteit.",
                },
                drugWarehouseBasePower = {
                    label = "Pakhuis / Energie",
                    description = "Standaardwaarde voor loodslabs / Ingebouwde stroomvoorziening.",
                },
                drugPowerEnabled = {
                    label = "Energie / Systeem",
                    description = "Activeert: stroomopwekking, stroomverbruik en overbelastingscontroles in het lab.",
                },
                drugOverloadGraceSeconds = {
                    label = "Overbelasting / Respijtperiode",
                    description = "Seconden voordat een stroomoverbelasting gevaarlijk wordt.",
                },
                drugHeatPerKilowatt = {
                    label = "Politiedruk / Per kilowatt",
                    description = "Politieaandacht voor het lab door stroomverbruik.",
                },
                drugGeneratorT1Watts = {
                    label = "Generator T1 / Watt",
                    description = "Vermogen van generatorniveau T1 in watt.",
                },
                drugGeneratorT2Watts = {
                    label = "Generator T2 / Watt",
                    description = "Vermogen van generatorniveau T2 in watt.",
                },
                drugGeneratorT3Watts = {
                    label = "Generator T3 / Watt",
                    description = "Vermogen van generatorniveau T3 in watt.",
                },
                drugEquipmentConditionWearMultiplier = {
                    label = "Slijtage / Vermenigvuldiger",
                    description = "Algemene vermenigvuldiger voor Slijtage van uitrusting / Verwerking.",
                },
                drugWorkersEnabled = {
                    label = "Medewerkers / Ingeschakeld",
                    description = "Activeert: chemici, telers, verpakkers en beveiligers in drugslabs.",
                },
                drugMaxWorkersPerLab = {
                    label = "Maximum / Medewerkers / Lab",
                    description = "Maximaal aantal werknemers per lab.",
                },
                drugWorkerFatiguePerProcessStep = {
                    label = "Vermoeidheid door verwerking",
                    description = "Extra vermoeidheid voor Medewerkers na deze taak: Verwerkingsstap.",
                },
                drugWorkerFatiguePerGrowAction = {
                    label = "Teelt / Vermoeidheid",
                    description = "Extra vermoeidheid voor Telers na deze taak: Oogst- of teeltwerk.",
                },
                drugWorkerRecoveryPerTick = {
                    label = "Medewerker / Herstel",
                    description = "Herstel van Vermoeidheid bij elke stap: Groei-update.",
                },
                drugMarketEnabled = {
                    label = "Markt / Ingeschakeld",
                    description = "Activeert: kopers, dealers en partijverkoop.",
                },
                drugMarketBasePriceFallback = {
                    label = "Vervangende waarde / Basisprijs",
                    description = "Basisprijs voor drugs zonder afzonderlijk ingestelde prijs.",
                },
                drugMarketStreetMultiplier = {
                    label = "Straat / Vermenigvuldiger",
                    description = "Algemene vermenigvuldiger voor Prijs / Straatverkoop.",
                },
                drugMarketWholesaleMultiplier = {
                    label = "Groothandel / Vermenigvuldiger",
                    description = "Algemene vermenigvuldiger voor Prijs / Groothandel / Deals.",
                },
                drugMarketPremiumMultiplier = {
                    label = "Premium / Vermenigvuldiger",
                    description = "Algemene vermenigvuldiger voor Prijs / Premium / Kopers.",
                },
                drugMarketHeatPerSale = {
                    label = "Politiedruk / Verkoop",
                    description = "Basispolitiedruk die bij verkoop van een partij aan het lab wordt toegevoegd.",
                },
                drugDistributionTickMinutes = {
                    label = "Distributie / Updatecyclus",
                    description = "Interval in minuten voor updates van dealerdistributie.",
                },
                drugDistributionIntervalMinutes = {
                    label = "Distributie / Interval",
                    description = "Standaardwaarde voor Handelaar / Wachttijd vóór verkoop / Minuten.",
                },
                drugDistributionMaxPerDealer = {
                    label = "Maximum / Handelaar / Opdrachten",
                    description = "Standaardwaarde voor Handelaar / maximaal aantal actieve distributieopdrachten.",
                },
                drugThreatsEnabled = {
                    label = "Bedreigingen / Ingeschakeld",
                    description = "Activeert: afname van politieaandacht, invallen en sabotage in labs.",
                },
                drugThreatTickMinutes = {
                    label = "Dreiging / Updatecyclus",
                    description = "Interval in minuten voor afname van politieaandacht en controles op invallen en sabotage.",
                },
                drugRaidHeatThreshold = {
                    label = "Aandachtsdrempel voor invallen",
                    description = "Vereiste politiedruk in het lab voordat dit kan optreden: Razzia's.",
                },
                drugSabotageHeatThreshold = {
                    label = "Aandachtsdrempel voor sabotage",
                    description = "Vereiste politiedruk in het lab voordat dit kan optreden: Sabotage.",
                },
                drugThreatHeatDecay = {
                    label = "Politiedruk / Verval",
                    description = "Verlaagt de politieaandacht voor het lab bij elke dreigingsupdate met deze waarde.",
                },
                drugRaidChanceAtThreshold = {
                    label = "Kans op inval",
                    description = "Basiskans op Overval zodra de bijbehorende politiedrukdrempel is bereikt.",
                },
                drugSabotageChanceAtThreshold = {
                    label = "Sabotage / Kans",
                    description = "Basiskans op Sabotage zodra de bijbehorende politiedrukdrempel is bereikt.",
                },
                drugConsumptionEnabled = {
                    label = "Consumptie ingeschakeld",
                    description = "Activeert: drugseffecten en het bijhouden van tolerantie en verslaving.",
                },
                drugDoseConsumesBatch = {
                    label = "Partij verbruiken bij gebruik",
                    description = "Verwijdert een geconsumeerde partij uit de actieve voorraad.",
                },
                drugToleranceDecayMinutes = {
                    label = "Tolerantie / Verval",
                    description = "Interval in minuten voor updates van tolerantieafname.",
                },
                drugAddictionDecayMinutes = {
                    label = "Verslaving / Verval",
                    description = "Interval in minuten voor updates van verslavingsafname.",
                },
                drugPotencyEffectMultiplier = {
                    label = "Potentie / Vermenigvuldiger",
                    description = "Bepaalt hoeveel de potentie de intensiteit van effecten verhoogt.",
                },
                drugOverdosePotencyThreshold = {
                    label = "Overdosis / Drempel",
                    description = "Vereiste werkzame belasting voordat een overdosis mogelijk wordt.",
                },
                drugBaseAddictionGain = {
                    label = "Basiswaarde / Verslaving / winst",
                    description = "Basistoename van verslaving per dosis.",
                },
                drugProcessingEnabled = {
                    label = "Verwerking / Ingeschakeld",
                    description = "Activeert: verwerkingsopdrachten, verpakking en testkits.",
                },
                drugBatchMetadataItemKey = {
                    label = "Batch / Metagegevens / Sleutel",
                    description = "Metadatasleutel in de inventaris die integraties voor partijgegevens gebruiken.",
                },
                drugDefaultProcessDuration = {
                    label = "Standaard verwerkingstijd",
                    description = "Standaardwaarde voor Verwerking / Duur / seconden / Zonder eigen receptwaarde.",
                },
                drugDefaultFailureRisk = {
                    label = "Standaardwaarde / Faalrisico",
                    description = "Standaardwaarde voor Verwerking / Faalrisico / Zonder eigen receptwaarde.",
                },
                drugPackagingDuration = {
                    label = "Verpakkingstijd",
                    description = "Standaardwaarde voor Verpakking / Duur / seconden.",
                },
                drugPowerTickSeconds = {
                    label = "Energie / Updatecyclus / seconden",
                    description = "Interval in seconden voor bijwerken van generatorverbruik en stroomverbruikspatronen.",
                },
                drugPowerSignatureHeatPerHour = {
                    label = "Stroomverbruikspatroon / Politiedruk / Uur",
                    description = "Politieaandacht per uur door het herkenbare stroomverbruik van het lab.",
                },
                drugPowerOverloadHeatPerHour = {
                    label = "Overbelasting / Politiedruk / Uur",
                    description = "Extra politiedruk per uur bij overbelasting van het lab.",
                },
                drugPowerIdleHeatDecayPerHour = {
                    label = "Inactief / Politiedruk / Verval / Uur",
                    description = "Afname van politieaandacht per uur zolang het lab geen herkenbaar stroomverbruik heeft.",
                },
                drugPowerModeManualMaxLoadPercent = {
                    label = "Manueel / Maximum / Belasting",
                    description = "Waarde voor energiemodus Manueel: Maximum / Belasting.",
                },
                drugPowerModeManualHeatMultiplier = {
                    label = "Manueel / Politiedruk / Vermenigvuldiger",
                    description = "Waarde voor energiemodus Manueel: Politiedruk / Vermenigvuldiger.",
                },
                drugPowerModeManualNoiseMultiplier = {
                    label = "Manueel / Lawaai / Vermenigvuldiger",
                    description = "Waarde voor energiemodus Manueel: Lawaai / Vermenigvuldiger.",
                },
                drugPowerModeBalancedMaxLoadPercent = {
                    label = "Gebalanceerd / Maximum / Belasting",
                    description = "Waarde voor energiemodus Gebalanceerd: Maximum / Belasting.",
                },
                drugPowerModeBalancedHeatMultiplier = {
                    label = "Gebalanceerd / Politiedruk / Vermenigvuldiger",
                    description = "Waarde voor energiemodus Gebalanceerd: Politiedruk / Vermenigvuldiger.",
                },
                drugPowerModeBalancedNoiseMultiplier = {
                    label = "Gebalanceerd / Lawaai / Vermenigvuldiger",
                    description = "Waarde voor energiemodus Gebalanceerd: Lawaai / Vermenigvuldiger.",
                },
                drugPowerModeStealthMaxLoadPercent = {
                    label = "Onopvallend / Maximum / Belasting",
                    description = "Waarde voor energiemodus Onopvallend: Maximum / Belasting.",
                },
                drugPowerModeStealthHeatMultiplier = {
                    label = "Onopvallend / Politiedruk / Vermenigvuldiger",
                    description = "Waarde voor energiemodus Onopvallend: Politiedruk / Vermenigvuldiger.",
                },
                drugPowerModeStealthNoiseMultiplier = {
                    label = "Onopvallend / Lawaai / Vermenigvuldiger",
                    description = "Waarde voor energiemodus Onopvallend: Lawaai / Vermenigvuldiger.",
                },
                drugPowerPrioritySmellControl = {
                    label = "Geurbeheersing / Prioriteit",
                    description = "Prioriteit bij automatische lastafschakeling: Geurbeheersing / Apparatuur.",
                },
                drugPowerPriorityAirflow = {
                    label = "Ventilatie / Prioriteit",
                    description = "Prioriteit bij automatische lastafschakeling: Ventilatie / Apparatuur.",
                },
                drugPowerPrioritySecurity = {
                    label = "Beveiliging / Prioriteit",
                    description = "Prioriteit bij automatische lastafschakeling: Beveiligingsapparatuur.",
                },
                drugPowerPriorityGrowing = {
                    label = "Teelt / Prioriteit",
                    description = "Prioriteit bij automatische lastafschakeling: Teelt / Apparatuur.",
                },
                drugPowerPriorityLight = {
                    label = "Verlichting / Prioriteit",
                    description = "Prioriteit bij automatische lastafschakeling: Verlichting / Apparatuur.",
                },
                drugPowerPriorityTesting = {
                    label = "Testen / Prioriteit",
                    description = "Prioriteit bij automatische lastafschakeling: Testen / Apparatuur.",
                },
                drugPowerPriorityPackaging = {
                    label = "Verpakking / Prioriteit",
                    description = "Prioriteit bij automatische lastafschakeling: Verpakking / Apparatuur.",
                },
                drugPowerPriorityChemistry = {
                    label = "Chemie / Prioriteit",
                    description = "Prioriteit bij automatische lastafschakeling: Chemie / Apparatuur.",
                },
                drugPowerPriorityHeating = {
                    label = "Verwarming / Prioriteit",
                    description = "Prioriteit bij automatische lastafschakeling: Verwarming / Apparatuur.",
                },
                drugPowerPriorityPressing = {
                    label = "Persen / Prioriteit",
                    description = "Prioriteit bij automatische lastafschakeling: Persen / Apparatuur.",
                },
                drugPowerPriorityGeneral = {
                    label = "Algemeen / Prioriteit",
                    description = "Prioriteit bij automatische lastafschakeling: Algemene apparatuur.",
                },
                drugAdvancedPerformanceInactiveControlIntervalMs = {
                    label = "Prestaties / Inactief / Bediening / Interval / ms",
                    description = "Instelling voor Prestaties / Inactief / Bediening / Interval / ms.",
                },
                drugAdvancedPerformanceInteractionIdleScanIntervalMs = {
                    label = "Prestaties / Interactie / Inactief / Scaninterval / ms",
                    description = "Instelling voor Prestaties / Interactie / Inactief / Scaninterval / ms.",
                },
                drugAdvancedPerformanceInteractionPromptIntervalMs = {
                    label = "Prestaties / Interactie / Interactieaanwijzing / Interval / ms",
                    description = "Instelling voor Prestaties / Interactie / Interactieaanwijzing / Interval / ms.",
                },
                drugAdvancedPerformanceInteractionScanIntervalMs = {
                    label = "Prestaties / Interactie / Scaninterval / ms",
                    description = "Instelling voor Prestaties / Interactie / Scaninterval / ms.",
                },
                drugAdvancedPerformanceMinimumScanIntervalMs = {
                    label = "Prestaties / Minimum / Scaninterval / ms",
                    description = "Instelling voor Prestaties / Minimum / Scaninterval / ms.",
                },
                drugAdvancedPerformanceStreetPedActivationDistance = {
                    label = "Prestaties / Straat / Ped / Activatie / Afstand",
                    description = "Instelling voor Prestaties / Straat / Ped / Activatie / Afstand.",
                },
                drugAdvancedPerformanceStreetPedIdleScanIntervalMs = {
                    label = "Prestaties / Straat / Ped / Inactief / Scaninterval / ms",
                    description = "Instelling voor Prestaties / Straat / Ped / Inactief / Scaninterval / ms.",
                },
                drugAdvancedPerformanceStreetPedScanIntervalMs = {
                    label = "Prestaties / Straat / Ped / Scaninterval / ms",
                    description = "Instelling voor Prestaties / Straat / Ped / Scaninterval / ms.",
                },
                drugAdvancedPerformanceWorldCachePadding = {
                    label = "Prestaties / Wereld / Cache / Extra marge",
                    description = "Instelling voor Prestaties / Wereld / Cache / Extra marge.",
                },
                drugAdvancedPerformanceWorldCacheRefreshIntervalMs = {
                    label = "Prestaties / Wereld / Cache / Verversing / Interval / ms",
                    description = "Instelling voor Prestaties / Wereld / Cache / Verversing / Interval / ms.",
                },
                drugAdvancedPerformanceWorldIdleIntervalMs = {
                    label = "Prestaties / Wereld / Inactief / Interval / ms",
                    description = "Instelling voor Prestaties / Wereld / Inactief / Interval / ms.",
                },
                drugAdvancedDynamicMarketActionCooldownSeconds = {
                    label = "Dynamische Markt / Actie-cooldown / seconden",
                    description = "Instelling voor Dynamische Markt / Actie-cooldown / seconden.",
                },
                drugAdvancedDynamicMarketActionHistoryLimit = {
                    label = "Dynamische Markt / Actie / Geschiedenislimiet",
                    description = "Instelling voor Dynamische Markt / Actie / Geschiedenislimiet.",
                },
                drugAdvancedDynamicMarketAmountSaturationWeight = {
                    label = "Dynamische Markt / Hoeveelheid / Verzadiging / Gewicht",
                    description = "Instelling voor Dynamische Markt / Hoeveelheid / Verzadiging / Gewicht.",
                },
                drugAdvancedDynamicMarketBaseIntelAccuracy = {
                    label = "Dynamische Markt / Basiswaarde / Nauwkeurigheid van de info",
                    description = "Instelling voor Dynamische Markt / Basiswaarde / Nauwkeurigheid van de info.",
                },
                drugAdvancedDynamicMarketDefaultAverageQuality = {
                    label = "Dynamische Markt / Standaardwaarde / Gemiddelde / Kwaliteit",
                    description = "Instelling voor Dynamische Markt / Standaardwaarde / Gemiddelde / Kwaliteit.",
                },
                drugAdvancedDynamicMarketDefaultResourceElasticity = {
                    label = "Dynamische Markt / Standaardwaarde / Grondstof / Elasticiteit",
                    description = "Instelling voor Dynamische Markt / Standaardwaarde / Grondstof / Elasticiteit.",
                },
                drugAdvancedDynamicMarketDemandCenter = {
                    label = "Dynamische Markt / Vraag / Middenwaarde",
                    description = "Instelling voor Dynamische Markt / Vraag / Middenwaarde.",
                },
                drugAdvancedDynamicMarketDemandPriceImpact = {
                    label = "Dynamische Markt / Vraag / Prijs / Invloed",
                    description = "Instelling voor Dynamische Markt / Vraag / Prijs / Invloed.",
                },
                drugAdvancedDynamicMarketDirectionThreshold = {
                    label = "Dynamische Markt / Richting / Drempel",
                    description = "Instelling voor Dynamische Markt / Richting / Drempel.",
                },
                drugAdvancedDynamicMarketEnabled = {
                    label = "Dynamische Markt / Ingeschakeld",
                    description = "Instelling voor Dynamische Markt / Ingeschakeld.",
                },
                drugAdvancedDynamicMarketEventChance = {
                    label = "Dynamische Markt / Gebeurtenis / Kans",
                    description = "Instelling voor Dynamische Markt / Gebeurtenis / Kans.",
                },
                drugAdvancedDynamicMarketEventDurationMinutes = {
                    label = "Dynamische Markt / Gebeurtenis / Duur / Minuten",
                    description = "Instelling voor Dynamische Markt / Gebeurtenis / Duur / Minuten.",
                },
                drugAdvancedDynamicMarketEventMinimumDurationMinutes = {
                    label = "Dynamische Markt / Gebeurtenis / Minimum / Duur / Minuten",
                    description = "Instelling voor Dynamische Markt / Gebeurtenis / Minimum / Duur / Minuten.",
                },
                drugAdvancedDynamicMarketEventStrengthMaximum = {
                    label = "Dynamische Markt / Gebeurtenis / Sterkte / Maximum",
                    description = "Instelling voor Dynamische Markt / Gebeurtenis / Sterkte / Maximum.",
                },
                drugAdvancedDynamicMarketEventStrengthMinimum = {
                    label = "Dynamische Markt / Gebeurtenis / Sterkte / Minimum",
                    description = "Instelling voor Dynamische Markt / Gebeurtenis / Sterkte / Minimum.",
                },
                drugAdvancedDynamicMarketEventsCrackdownDemand = {
                    label = "Dynamische Markt / Evenementen / Politieoffensief / Vraag",
                    description = "Instelling voor Dynamische Markt / Evenementen / Politieoffensief / Vraag.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPolice = {
                    label = "Dynamische Markt / Evenementen / Politieoffensief / Politie",
                    description = "Instelling voor Dynamische Markt / Evenementen / Politieoffensief / Politie.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPrice = {
                    label = "Dynamische Markt / Evenementen / Politieoffensief / Prijs",
                    description = "Instelling voor Dynamische Markt / Evenementen / Politieoffensief / Prijs.",
                },
                drugAdvancedDynamicMarketEventsFestivalDemand = {
                    label = "Dynamische Markt / Evenementen / Festival / Vraag",
                    description = "Instelling voor Dynamische Markt / Evenementen / Festival / Vraag.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem1 = {
                    label = "Dynamische Markt / Evenementen / Festival / Effecten / 1",
                    description = "Instelling voor Dynamische Markt / Evenementen / Festival / Effecten / 1.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem2 = {
                    label = "Dynamische Markt / Evenementen / Festival / Effecten / 2",
                    description = "Instelling voor Dynamische Markt / Evenementen / Festival / Effecten / 2.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem3 = {
                    label = "Dynamische Markt / Evenementen / Festival / Effecten / 3",
                    description = "Instelling voor Dynamische Markt / Evenementen / Festival / Effecten / 3.",
                },
                drugAdvancedDynamicMarketEventsFestivalPrice = {
                    label = "Dynamische Markt / Evenementen / Festival / Prijs",
                    description = "Instelling voor Dynamische Markt / Evenementen / Festival / Prijs.",
                },
                drugAdvancedDynamicMarketEventsFestivalProfilesItem1 = {
                    label = "Dynamische Markt / Evenementen / Festival / Profielen / 1",
                    description = "Instelling voor Dynamische Markt / Evenementen / Festival / Profielen / 1.",
                },
                drugAdvancedDynamicMarketEventsGangconflictDemand = {
                    label = "Dynamische Markt / Evenementen / Bendeconflict / Vraag",
                    description = "Instelling voor Dynamische Markt / Evenementen / Bendeconflict / Vraag.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPolice = {
                    label = "Dynamische Markt / Evenementen / Bendeconflict / Politie",
                    description = "Instelling voor Dynamische Markt / Evenementen / Bendeconflict / Politie.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPrice = {
                    label = "Dynamische Markt / Evenementen / Bendeconflict / Prijs",
                    description = "Instelling voor Dynamische Markt / Evenementen / Bendeconflict / Prijs.",
                },
                drugAdvancedDynamicMarketEventsGangconflictProfilesItem1 = {
                    label = "Dynamische Markt / Evenementen / Bendeconflict / Profielen / 1",
                    description = "Instelling voor Dynamische Markt / Evenementen / Bendeconflict / Profielen / 1.",
                },
                drugAdvancedDynamicMarketEventsLabbustDemand = {
                    label = "Dynamische Markt / Evenementen / Labinval / Vraag",
                    description = "Instelling voor Dynamische Markt / Evenementen / Labinval / Vraag.",
                },
                drugAdvancedDynamicMarketEventsLabbustPolice = {
                    label = "Dynamische Markt / Evenementen / Labinval / Politie",
                    description = "Instelling voor Dynamische Markt / Evenementen / Labinval / Politie.",
                },
                drugAdvancedDynamicMarketEventsLabbustPrice = {
                    label = "Dynamische Markt / Evenementen / Labinval / Prijs",
                    description = "Instelling voor Dynamische Markt / Evenementen / Labinval / Prijs.",
                },
                drugAdvancedDynamicMarketEventsLabbustSupply = {
                    label = "Dynamische Markt / Evenementen / Labinval / Levering",
                    description = "Instelling voor Dynamische Markt / Evenementen / Labinval / Levering.",
                },
                drugAdvancedDynamicMarketEventsPartyDemand = {
                    label = "Dynamische Markt / Evenementen / Feest / Vraag",
                    description = "Instelling voor Dynamische Markt / Evenementen / Feest / Vraag.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem1 = {
                    label = "Dynamische Markt / Evenementen / Feest / Effecten / 1",
                    description = "Instelling voor Dynamische Markt / Evenementen / Feest / Effecten / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem2 = {
                    label = "Dynamische Markt / Evenementen / Feest / Effecten / 2",
                    description = "Instelling voor Dynamische Markt / Evenementen / Feest / Effecten / 2.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem3 = {
                    label = "Dynamische Markt / Evenementen / Feest / Effecten / 3",
                    description = "Instelling voor Dynamische Markt / Evenementen / Feest / Effecten / 3.",
                },
                drugAdvancedDynamicMarketEventsPartyPrice = {
                    label = "Dynamische Markt / Evenementen / Feest / Prijs",
                    description = "Instelling voor Dynamische Markt / Evenementen / Feest / Prijs.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem1 = {
                    label = "Dynamische Markt / Evenementen / Feest / Profielen / 1",
                    description = "Instelling voor Dynamische Markt / Evenementen / Feest / Profielen / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem2 = {
                    label = "Dynamische Markt / Evenementen / Feest / Profielen / 2",
                    description = "Instelling voor Dynamische Markt / Evenementen / Feest / Profielen / 2.",
                },
                drugAdvancedDynamicMarketEventsShortageDemand = {
                    label = "Dynamische Markt / Evenementen / Tekort / Vraag",
                    description = "Instelling voor Dynamische Markt / Evenementen / Tekort / Vraag.",
                },
                drugAdvancedDynamicMarketEventsShortagePrice = {
                    label = "Dynamische Markt / Evenementen / Tekort / Prijs",
                    description = "Instelling voor Dynamische Markt / Evenementen / Tekort / Prijs.",
                },
                drugAdvancedDynamicMarketEventsShortageSupply = {
                    label = "Dynamische Markt / Evenementen / Tekort / Levering",
                    description = "Instelling voor Dynamische Markt / Evenementen / Tekort / Levering.",
                },
                drugAdvancedDynamicMarketExactIntelReputation = {
                    label = "Dynamische Markt / Exacte informatie / Reputatie",
                    description = "Instelling voor Dynamische Markt / Exacte informatie / Reputatie.",
                },
                drugAdvancedDynamicMarketExactIntelTrust = {
                    label = "Dynamische Markt / Exacte informatie / Vertrouwen",
                    description = "Instelling voor Dynamische Markt / Exacte informatie / Vertrouwen.",
                },
                drugAdvancedDynamicMarketGlobalZoneLabel = {
                    label = "Dynamische Markt / Global / Zone / Naam",
                    description = "Instelling voor Dynamische Markt / Global / Zone / Naam.",
                },
                drugAdvancedDynamicMarketHistoryLimit = {
                    label = "Dynamische Markt / Geschiedenislimiet",
                    description = "Instelling voor Dynamische Markt / Geschiedenislimiet.",
                },
                drugAdvancedDynamicMarketInitialDemand = {
                    label = "Dynamische Markt / Beginwaarde / Vraag",
                    description = "Instelling voor Dynamische Markt / Beginwaarde / Vraag.",
                },
                drugAdvancedDynamicMarketInitialPriceMultiplier = {
                    label = "Dynamische Markt / Beginwaarde / Prijsvermenigvuldiger",
                    description = "Instelling voor Dynamische Markt / Beginwaarde / Prijsvermenigvuldiger.",
                },
                drugAdvancedDynamicMarketIntelDemandError = {
                    label = "Dynamische Markt / Informatie / Vraag / Fout",
                    description = "Instelling voor Dynamische Markt / Informatie / Vraag / Fout.",
                },
                drugAdvancedDynamicMarketIntelMaximumAccuracy = {
                    label = "Dynamische Markt / Informatie / Maximum / Nauwkeurigheid",
                    description = "Instelling voor Dynamische Markt / Informatie / Maximum / Nauwkeurigheid.",
                },
                drugAdvancedDynamicMarketIntelMinimumAccuracy = {
                    label = "Dynamische Markt / Informatie / Minimum / Nauwkeurigheid",
                    description = "Instelling voor Dynamische Markt / Informatie / Minimum / Nauwkeurigheid.",
                },
                drugAdvancedDynamicMarketIntelPoliceError = {
                    label = "Dynamische Markt / Informatie / Politie / Fout",
                    description = "Instelling voor Dynamische Markt / Informatie / Politie / Fout.",
                },
                drugAdvancedDynamicMarketIntelPriceError = {
                    label = "Dynamische Markt / Informatie / Prijs / Fout",
                    description = "Instelling voor Dynamische Markt / Informatie / Prijs / Fout.",
                },
                drugAdvancedDynamicMarketIntelPriceMaximum = {
                    label = "Dynamische Markt / Informatie / Prijs / Maximum",
                    description = "Instelling voor Dynamische Markt / Informatie / Prijs / Maximum.",
                },
                drugAdvancedDynamicMarketIntelPriceMinimum = {
                    label = "Dynamische Markt / Informatie / Prijs / Minimum",
                    description = "Instelling voor Dynamische Markt / Informatie / Prijs / Minimum.",
                },
                drugAdvancedDynamicMarketIntelReputationWeight = {
                    label = "Dynamische Markt / Informatie / Reputatie / Gewicht",
                    description = "Instelling voor Dynamische Markt / Informatie / Reputatie / Gewicht.",
                },
                drugAdvancedDynamicMarketIntelResourcePriceError = {
                    label = "Dynamische Markt / Informatie / Grondstof / Prijs / Fout",
                    description = "Instelling voor Dynamische Markt / Informatie / Grondstof / Prijs / Fout.",
                },
                drugAdvancedDynamicMarketIntelSaturationError = {
                    label = "Dynamische Markt / Informatie / Verzadiging / Fout",
                    description = "Instelling voor Dynamische Markt / Informatie / Verzadiging / Fout.",
                },
                drugAdvancedDynamicMarketIntelSeedBucketSeconds = {
                    label = "Dynamische Markt / Tijdvak voor willekeurige informatiewaarde / seconden",
                    description = "Instelling voor Dynamische Markt / Tijdvak voor willekeurige informatiewaarde / seconden.",
                },
                drugAdvancedDynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Dynamische Markt / Informatie / Status / Nauwkeurigheid / Drempel",
                    description = "Instelling voor Dynamische Markt / Informatie / Status / Nauwkeurigheid / Drempel.",
                },
                drugAdvancedDynamicMarketIntelStatusErrorThreshold = {
                    label = "Dynamische Markt / Informatie / Status / Fout / Drempel",
                    description = "Instelling voor Dynamische Markt / Informatie / Status / Fout / Drempel.",
                },
                drugAdvancedDynamicMarketIntelSupplyError = {
                    label = "Dynamische Markt / Informatie / Levering / Fout",
                    description = "Instelling voor Dynamische Markt / Informatie / Levering / Fout.",
                },
                drugAdvancedDynamicMarketIntelTrustWeight = {
                    label = "Dynamische Markt / Informatie / Vertrouwen / Gewicht",
                    description = "Instelling voor Dynamische Markt / Informatie / Vertrouwen / Gewicht.",
                },
                drugAdvancedDynamicMarketManipulationCooldownMinutes = {
                    label = "Dynamische Markt / Manipulatie / Afkoeltijd (minuten)",
                    description = "Instelling voor Dynamische Markt / Manipulatie / Afkoeltijd (minuten).",
                },
                drugAdvancedDynamicMarketManipulationDemandShift = {
                    label = "Dynamische Markt / Manipulatie / Vraag / Verschuiving",
                    description = "Instelling voor Dynamische Markt / Manipulatie / Vraag / Verschuiving.",
                },
                drugAdvancedDynamicMarketManipulationDurationMinutes = {
                    label = "Dynamische Markt / Manipulatie / Duur / Minuten",
                    description = "Instelling voor Dynamische Markt / Manipulatie / Duur / Minuten.",
                },
                drugAdvancedDynamicMarketManipulationHeat = {
                    label = "Dynamische Markt / Manipulatie / Politiedruk",
                    description = "Instelling voor Dynamische Markt / Manipulatie / Politiedruk.",
                },
                drugAdvancedDynamicMarketManipulationMinimumBatchAmount = {
                    label = "Dynamische Markt / Manipulatie / Minimum / Batch / Hoeveelheid",
                    description = "Instelling voor Dynamische Markt / Manipulatie / Minimum / Batch / Hoeveelheid.",
                },
                drugAdvancedDynamicMarketManipulationPaymentAccount = {
                    label = "Dynamische Markt / Manipulatie / Betaalrekening",
                    description = "Instelling voor Dynamische Markt / Manipulatie / Betaalrekening.",
                },
                drugAdvancedDynamicMarketManipulationPrice = {
                    label = "Dynamische Markt / Manipulatie / Prijs",
                    description = "Instelling voor Dynamische Markt / Manipulatie / Prijs.",
                },
                drugAdvancedDynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Dynamische Markt / Manipulatie / Zone / Politiedruk / Vermenigvuldiger",
                    description = "Instelling voor Dynamische Markt / Manipulatie / Zone / Politiedruk / Vermenigvuldiger.",
                },
                drugAdvancedDynamicMarketMaximumIntelAgeMinutes = {
                    label = "Dynamische Markt / Maximum / Leeftijd van de info / Minuten",
                    description = "Instelling voor Dynamische Markt / Maximum / Leeftijd van de info / Minuten.",
                },
                drugAdvancedDynamicMarketMaximumPriceMultiplier = {
                    label = "Dynamische Markt / Maximum / Prijsvermenigvuldiger",
                    description = "Instelling voor Dynamische Markt / Maximum / Prijsvermenigvuldiger.",
                },
                drugAdvancedDynamicMarketMinimumIntelAgeMinutes = {
                    label = "Dynamische Markt / Minimum / Leeftijd van de info / Minuten",
                    description = "Instelling voor Dynamische Markt / Minimum / Leeftijd van de info / Minuten.",
                },
                drugAdvancedDynamicMarketMinimumMetricWindowMinutes = {
                    label = "Dynamische Markt / Minimum / Meetwaarde / Tijdvenster / Minuten",
                    description = "Instelling voor Dynamische Markt / Minimum / Meetwaarde / Tijdvenster / Minuten.",
                },
                drugAdvancedDynamicMarketMinimumPriceMultiplier = {
                    label = "Dynamische Markt / Minimale prijs / Vermenigvuldiger",
                    description = "Instelling voor Dynamische Markt / Minimale prijs / Vermenigvuldiger.",
                },
                drugAdvancedDynamicMarketMinimumUpdateMinutes = {
                    label = "Dynamische Markt / Minimum / Bijwerking / Minuten",
                    description = "Instelling voor Dynamische Markt / Minimum / Bijwerking / Minuten.",
                },
                drugAdvancedDynamicMarketPoliceDemandWeight = {
                    label = "Dynamische Markt / Politie / Vraag / Gewicht",
                    description = "Instelling voor Dynamische Markt / Politie / Vraag / Gewicht.",
                },
                drugAdvancedDynamicMarketPolicePriceImpact = {
                    label = "Dynamische Markt / Politie / Prijs / Invloed",
                    description = "Instelling voor Dynamische Markt / Politie / Prijs / Invloed.",
                },
                drugAdvancedDynamicMarketPoorQualityDemandPenalty = {
                    label = "Dynamische Markt / Slechte kwaliteit / Vraag / Aftrek",
                    description = "Instelling voor Dynamische Markt / Slechte kwaliteit / Vraag / Aftrek.",
                },
                drugAdvancedDynamicMarketPoorQualityThreshold = {
                    label = "Dynamische Markt / Slechte kwaliteit / Drempel",
                    description = "Instelling voor Dynamische Markt / Slechte kwaliteit / Drempel.",
                },
                drugAdvancedDynamicMarketPremiumQualityDemandBonus = {
                    label = "Dynamische Markt / Topkwaliteit / Vraagbonus",
                    description = "Instelling voor Dynamische Markt / Topkwaliteit / Vraagbonus.",
                },
                drugAdvancedDynamicMarketPremiumQualityThreshold = {
                    label = "Dynamische Markt / Topkwaliteit / Drempel",
                    description = "Instelling voor Dynamische Markt / Topkwaliteit / Drempel.",
                },
                drugAdvancedDynamicMarketProductionSupplyWeight = {
                    label = "Dynamische Markt / Productie / Levering / Gewicht",
                    description = "Instelling voor Dynamische Markt / Productie / Levering / Gewicht.",
                },
                drugAdvancedDynamicMarketProductionWindowMinutes = {
                    label = "Dynamische Markt / Productie / Tijdvenster / Minuten",
                    description = "Instelling voor Dynamische Markt / Productie / Tijdvenster / Minuten.",
                },
                drugAdvancedDynamicMarketQualityCenter = {
                    label = "Dynamische Markt / Kwaliteit / Middenwaarde",
                    description = "Instelling voor Dynamische Markt / Kwaliteit / Middenwaarde.",
                },
                drugAdvancedDynamicMarketQualityConfidenceImpact = {
                    label = "Dynamische Markt / Kwaliteit / Zekerheid / Invloed",
                    description = "Instelling voor Dynamische Markt / Kwaliteit / Zekerheid / Invloed.",
                },
                drugAdvancedDynamicMarketQualityRange = {
                    label = "Dynamische Markt / Kwaliteit / Waardenbereik",
                    description = "Instelling voor Dynamische Markt / Kwaliteit / Waardenbereik.",
                },
                drugAdvancedDynamicMarketRarityBonusMaximum = {
                    label = "Dynamische Markt / Zeldzaamheid / Bonus / Maximum",
                    description = "Instelling voor Dynamische Markt / Zeldzaamheid / Bonus / Maximum.",
                },
                drugAdvancedDynamicMarketRegionalGlobalWeight = {
                    label = "Dynamische Markt / Regionaal / Global / Gewicht",
                    description = "Instelling voor Dynamische Markt / Regionaal / Global / Gewicht.",
                },
                drugAdvancedDynamicMarketRegionalLocalWeight = {
                    label = "Dynamische Markt / Regionaal / Lokaal / Gewicht",
                    description = "Instelling voor Dynamische Markt / Regionaal / Lokaal / Gewicht.",
                },
                drugAdvancedDynamicMarketResourceAliasesDrugpackaging = {
                    label = "Dynamische Markt / Grondstof / Alternatieve namen / Drug / Verpakking",
                    description = "Instelling voor Dynamische Markt / Grondstof / Alternatieve namen / Drug / Verpakking.",
                },
                drugAdvancedDynamicMarketResourceAliasesFuelcan = {
                    label = "Dynamische Markt / Grondstof / Alternatieve namen / Brandstofkan",
                    description = "Instelling voor Dynamische Markt / Grondstof / Alternatieve namen / Brandstofkan.",
                },
                drugAdvancedDynamicMarketResourceAliasesMachineoil = {
                    label = "Dynamische Markt / Grondstof / Alternatieve namen / Machineolie",
                    description = "Instelling voor Dynamische Markt / Grondstof / Alternatieve namen / Machineolie.",
                },
                drugAdvancedDynamicMarketResourceAliasesPlantnutrients = {
                    label = "Dynamische Markt / Grondstof / Alternatieve namen / Plantenvoeding",
                    description = "Instelling voor Dynamische Markt / Grondstof / Alternatieve namen / Plantenvoeding.",
                },
                drugAdvancedDynamicMarketResourceAliasesRepairkit = {
                    label = "Dynamische Markt / Grondstof / Alternatieve namen / Reparatieset",
                    description = "Instelling voor Dynamische Markt / Grondstof / Alternatieve namen / Reparatieset.",
                },
                drugAdvancedDynamicMarketResourceDirectionFallThreshold = {
                    label = "Dynamische Markt / Grondstof / Richting / Daling / Drempel",
                    description = "Instelling voor Dynamische Markt / Grondstof / Richting / Daling / Drempel.",
                },
                drugAdvancedDynamicMarketResourceDirectionRiseThreshold = {
                    label = "Dynamische Markt / Grondstof / Richting / Stijging / Drempel",
                    description = "Instelling voor Dynamische Markt / Grondstof / Richting / Stijging / Drempel.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterBasePrice = {
                    label = "Dynamische Markt / Grondstoffen / Koolstoffilter / Basisprijs",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Koolstoffilter / Basisprijs.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterElasticity = {
                    label = "Dynamische Markt / Grondstoffen / Koolstoffilter / Elasticiteit",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Koolstoffilter / Elasticiteit.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLabel = {
                    label = "Dynamische Markt / Grondstoffen / Koolstoffilter / Naam",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Koolstoffilter / Naam.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem1 = {
                    label = "Dynamische Markt / Grondstoffen / Koolstoffilter / Gekoppelde drugs / 1",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Koolstoffilter / Gekoppelde drugs / 1.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem2 = {
                    label = "Dynamische Markt / Grondstoffen / Koolstoffilter / Gekoppelde drugs / 2",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Koolstoffilter / Gekoppelde drugs / 2.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem3 = {
                    label = "Dynamische Markt / Grondstoffen / Koolstoffilter / Gekoppelde drugs / 3",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Koolstoffilter / Gekoppelde drugs / 3.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorBasePrice = {
                    label = "Dynamische Markt / Grondstoffen / Chemische grondstof / Basisprijs",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Chemische grondstof / Basisprijs.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorElasticity = {
                    label = "Dynamische Markt / Grondstoffen / Chemische grondstof / Elasticiteit",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Chemische grondstof / Elasticiteit.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLabel = {
                    label = "Dynamische Markt / Grondstoffen / Chemische grondstof / Naam",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Chemische grondstof / Naam.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem1 = {
                    label = "Dynamische Markt / Grondstoffen / Chemische grondstof / Gekoppelde drugs / 1",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Chemische grondstof / Gekoppelde drugs / 1.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem2 = {
                    label = "Dynamische Markt / Grondstoffen / Chemische grondstof / Gekoppelde drugs / 2",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Chemische grondstof / Gekoppelde drugs / 2.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsBasePrice = {
                    label = "Dynamische Markt / Grondstoffen / Onderdelen / Basisprijs",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Onderdelen / Basisprijs.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsElasticity = {
                    label = "Dynamische Markt / Grondstoffen / Onderdelen / Elasticiteit",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Onderdelen / Elasticiteit.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsLabel = {
                    label = "Dynamische Markt / Grondstoffen / Onderdelen / Naam",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Onderdelen / Naam.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerBasePrice = {
                    label = "Dynamische Markt / Grondstoffen / Meststof / Basisprijs",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Meststof / Basisprijs.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerElasticity = {
                    label = "Dynamische Markt / Grondstoffen / Meststof / Elasticiteit",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Meststof / Elasticiteit.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLabel = {
                    label = "Dynamische Markt / Grondstoffen / Meststof / Naam",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Meststof / Naam.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLinkedDrugsItem1 = {
                    label = "Dynamische Markt / Grondstoffen / Meststof / Gekoppelde drugs / 1",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Meststof / Gekoppelde drugs / 1.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelBasePrice = {
                    label = "Dynamische Markt / Grondstoffen / Laboratoriumbrandstof / Basisprijs",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Laboratoriumbrandstof / Basisprijs.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelElasticity = {
                    label = "Dynamische Markt / Grondstoffen / Laboratoriumbrandstof / Elasticiteit",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Laboratoriumbrandstof / Elasticiteit.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelLabel = {
                    label = "Dynamische Markt / Grondstoffen / Laboratoriumbrandstof / Naam",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Laboratoriumbrandstof / Naam.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagBasePrice = {
                    label = "Dynamische Markt / Grondstoffen / Verpakkingszak / Basisprijs",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Verpakkingszak / Basisprijs.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagElasticity = {
                    label = "Dynamische Markt / Grondstoffen / Verpakkingszak / Elasticiteit",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Verpakkingszak / Elasticiteit.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagLabel = {
                    label = "Dynamische Markt / Grondstoffen / Verpakkingszak / Naam",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Verpakkingszak / Naam.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotBasePrice = {
                    label = "Dynamische Markt / Grondstoffen / Plantenpot / Basisprijs",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Plantenpot / Basisprijs.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotElasticity = {
                    label = "Dynamische Markt / Grondstoffen / Plantenpot / Elasticiteit",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Plantenpot / Elasticiteit.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLabel = {
                    label = "Dynamische Markt / Grondstoffen / Plantenpot / Naam",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Plantenpot / Naam.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLinkedDrugsItem1 = {
                    label = "Dynamische Markt / Grondstoffen / Plantenpot / Gekoppelde drugs / 1",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Plantenpot / Gekoppelde drugs / 1.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedBasePrice = {
                    label = "Dynamische Markt / Grondstoffen / Cannabiszaad / Basisprijs",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Cannabiszaad / Basisprijs.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedElasticity = {
                    label = "Dynamische Markt / Grondstoffen / Cannabiszaad / Elasticiteit",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Cannabiszaad / Elasticiteit.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLabel = {
                    label = "Dynamische Markt / Grondstoffen / Cannabiszaad / Naam",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Cannabiszaad / Naam.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLinkedDrugsItem1 = {
                    label = "Dynamische Markt / Grondstoffen / Cannabiszaad / Gekoppelde drugs / 1",
                    description = "Instelling voor Dynamische Markt / Grondstoffen / Cannabiszaad / Gekoppelde drugs / 1.",
                },
                drugAdvancedDynamicMarketSalesWindowMinutes = {
                    label = "Dynamische Markt / Verkopen / Tijdvenster / Minuten",
                    description = "Instelling voor Dynamische Markt / Verkopen / Tijdvenster / Minuten.",
                },
                drugAdvancedDynamicMarketSaturationDemandWeight = {
                    label = "Dynamische Markt / Verzadiging / Vraag / Gewicht",
                    description = "Instelling voor Dynamische Markt / Verzadiging / Vraag / Gewicht.",
                },
                drugAdvancedDynamicMarketSaturationPriceImpact = {
                    label = "Dynamische Markt / Verzadiging / Prijs / Invloed",
                    description = "Instelling voor Dynamische Markt / Verzadiging / Prijs / Invloed.",
                },
                drugAdvancedDynamicMarketScarcityDemandWeight = {
                    label = "Dynamische Markt / Schaarste / Vraag / Gewicht",
                    description = "Instelling voor Dynamische Markt / Schaarste / Vraag / Gewicht.",
                },
                drugAdvancedDynamicMarketScarcityPriceImpact = {
                    label = "Dynamische Markt / Schaarste / Prijs / Invloed",
                    description = "Instelling voor Dynamische Markt / Schaarste / Prijs / Invloed.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsDecember = {
                    label = "Dynamische Markt / Seizoen / Einde / Maanden / December",
                    description = "Instelling voor Dynamische Markt / Seizoen / Einde / Maanden / December.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSpring = {
                    label = "Dynamische Markt / Seizoen / Einde / Maanden / Lente",
                    description = "Instelling voor Dynamische Markt / Seizoen / Einde / Maanden / Lente.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSummer = {
                    label = "Dynamische Markt / Seizoen / Einde / Maanden / Zomer",
                    description = "Instelling voor Dynamische Markt / Seizoen / Einde / Maanden / Zomer.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsWinter = {
                    label = "Dynamische Markt / Seizoen / Einde / Maanden / Winter",
                    description = "Instelling voor Dynamische Markt / Seizoen / Einde / Maanden / Winter.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersAutumn = {
                    label = "Dynamische Markt / Seizoen / Vermenigvuldigers / Herfst",
                    description = "Instelling voor Dynamische Markt / Seizoen / Vermenigvuldigers / Herfst.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSpring = {
                    label = "Dynamische Markt / Seizoen / Vermenigvuldigers / Lente",
                    description = "Instelling voor Dynamische Markt / Seizoen / Vermenigvuldigers / Lente.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSummer = {
                    label = "Dynamische Markt / Seizoen / Vermenigvuldigers / Zomer",
                    description = "Instelling voor Dynamische Markt / Seizoen / Vermenigvuldigers / Zomer.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersWinter = {
                    label = "Dynamische Markt / Seizoen / Vermenigvuldigers / Winter",
                    description = "Instelling voor Dynamische Markt / Seizoen / Vermenigvuldigers / Winter.",
                },
                drugAdvancedDynamicMarketShortageRumorThreshold = {
                    label = "Dynamische Markt / Tekort / Gerucht / Drempel",
                    description = "Instelling voor Dynamische Markt / Tekort / Gerucht / Drempel.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHighDemand = {
                    label = "Dynamische Markt / Status / Drempels / Hoge vraag",
                    description = "Instelling voor Dynamische Markt / Status / Drempels / Hoge vraag.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHot = {
                    label = "Dynamische Markt / Status / Drempels / Gezocht",
                    description = "Instelling voor Dynamische Markt / Status / Drempels / Gezocht.",
                },
                drugAdvancedDynamicMarketStatusThresholdsLowDemand = {
                    label = "Dynamische Markt / Status / Drempels / Lage vraag",
                    description = "Instelling voor Dynamische Markt / Status / Drempels / Lage vraag.",
                },
                drugAdvancedDynamicMarketStatusThresholdsSaturated = {
                    label = "Dynamische Markt / Status / Drempels / Verzadigd",
                    description = "Instelling voor Dynamische Markt / Status / Drempels / Verzadigd.",
                },
                drugAdvancedDynamicMarketTargetSupply = {
                    label = "Dynamische Markt / Doelwit / Levering",
                    description = "Instelling voor Dynamische Markt / Doelwit / Levering.",
                },
                drugAdvancedDynamicMarketTrendChance = {
                    label = "Dynamische Markt / Trend / Kans",
                    description = "Instelling voor Dynamische Markt / Trend / Kans.",
                },
                drugAdvancedDynamicMarketTrendDurationMinutes = {
                    label = "Dynamische Markt / Trend / Duur / Minuten",
                    description = "Instelling voor Dynamische Markt / Trend / Duur / Minuten.",
                },
                drugAdvancedDynamicMarketTrendMaximumStrength = {
                    label = "Dynamische Markt / Trend / Maximum / Sterkte",
                    description = "Instelling voor Dynamische Markt / Trend / Maximum / Sterkte.",
                },
                drugAdvancedDynamicMarketTrendMinimumStrength = {
                    label = "Dynamische Markt / Trend / Minimum / Sterkte",
                    description = "Instelling voor Dynamische Markt / Trend / Minimum / Sterkte.",
                },
                drugAdvancedDynamicMarketUpdateMinutes = {
                    label = "Dynamische Markt / Bijwerking / Minuten",
                    description = "Instelling voor Dynamische Markt / Bijwerking / Minuten.",
                },
                drugAdvancedDynamicMarketVolatilityMaximum = {
                    label = "Dynamische Markt / Prijsvolatiliteit / Maximum",
                    description = "Instelling voor Dynamische Markt / Prijsvolatiliteit / Maximum.",
                },
                drugAdvancedDynamicMarketVolatilityMinimum = {
                    label = "Dynamische Markt / Prijsvolatiliteit / Minimum",
                    description = "Instelling voor Dynamische Markt / Prijsvolatiliteit / Minimum.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersCold = {
                    label = "Dynamische Markt / Weer / Vermenigvuldigers / Kou",
                    description = "Instelling voor Dynamische Markt / Weer / Vermenigvuldigers / Kou.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersHeatwave = {
                    label = "Dynamische Markt / Weer / Vermenigvuldigers / Hittegolf",
                    description = "Instelling voor Dynamische Markt / Weer / Vermenigvuldigers / Hittegolf.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersNormal = {
                    label = "Dynamische Markt / Weer / Vermenigvuldigers / Normaal",
                    description = "Instelling voor Dynamische Markt / Weer / Vermenigvuldigers / Normaal.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersRain = {
                    label = "Dynamische Markt / Weer / Vermenigvuldigers / Regen",
                    description = "Instelling voor Dynamische Markt / Weer / Vermenigvuldigers / Regen.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersStorm = {
                    label = "Dynamische Markt / Weer / Vermenigvuldigers / Storm",
                    description = "Instelling voor Dynamische Markt / Weer / Vermenigvuldigers / Storm.",
                },
                drugAdvancedDynamicMarketWeatherState = {
                    label = "Dynamische Markt / Weer / Status",
                    description = "Instelling voor Dynamische Markt / Weer / Status.",
                },
                drugAdvancedHeatActionCooldownSeconds = {
                    label = "Politieaandacht en risico / Actie-cooldown / seconden",
                    description = "Instelling voor Politieaandacht en risico / Actie-cooldown / seconden.",
                },
                drugAdvancedHeatActivityRiskWeightsAmount = {
                    label = "Politieaandacht en risico / Activiteit / Risico / Wegingen / Hoeveelheid",
                    description = "Instelling voor Politieaandacht en risico / Activiteit / Risico / Wegingen / Hoeveelheid.",
                },
                drugAdvancedHeatActivityRiskWeightsDurationMinutes = {
                    label = "Politieaandacht en risico / Activiteit / Risico / Wegingen / Duur / Minuten",
                    description = "Instelling voor Politieaandacht en risico / Activiteit / Risico / Wegingen / Duur / Minuten.",
                },
                drugAdvancedHeatActivityRiskWeightsPolicePressure = {
                    label = "Politieaandacht en risico / Activiteit / Risico / Wegingen / Politiedruk",
                    description = "Instelling voor Politieaandacht en risico / Activiteit / Risico / Wegingen / Politiedruk.",
                },
                drugAdvancedHeatActivityRiskWeightsReputation = {
                    label = "Politieaandacht en risico / Activiteit / Risico / Wegingen / Reputatie",
                    description = "Instelling voor Politieaandacht en risico / Activiteit / Risico / Wegingen / Reputatie.",
                },
                drugAdvancedHeatActivityRiskWeightsSecurity = {
                    label = "Politieaandacht en risico / Activiteit / Risico / Wegingen / Beveiliging",
                    description = "Instelling voor Politieaandacht en risico / Activiteit / Risico / Wegingen / Beveiliging.",
                },
                drugAdvancedHeatAggressiveHeatMultiplier = {
                    label = "Politieaandacht en risico / Agressieve werkwijze / Politiedruk / Vermenigvuldiger",
                    description = "Instelling voor Politieaandacht en risico / Agressieve werkwijze / Politiedruk / Vermenigvuldiger.",
                },
                drugAdvancedHeatBurnerBurnThreshold = {
                    label = "Politieaandacht en risico / Wegwerptelefoon / Ontmaskering / Drempel",
                    description = "Instelling voor Politieaandacht en risico / Wegwerptelefoon / Ontmaskering / Drempel.",
                },
                drugAdvancedHeatBurnerHeatPerWholesale = {
                    label = "Politieaandacht en risico / Wegwerptelefoon / Politiedruk / Per groothandelsdeal",
                    description = "Instelling voor Politieaandacht en risico / Wegwerptelefoon / Politiedruk / Per groothandelsdeal.",
                },
                drugAdvancedHeatBurnerPhoneItem = {
                    label = "Politieaandacht en risico / Burner phone / Voorwerp",
                    description = "Instelling voor Politieaandacht en risico / Burner phone / Voorwerp.",
                },
                drugAdvancedHeatCamperOperationalHeatMultiplier = {
                    label = "Politieaandacht en risico / Camper in bedrijf / Politiedruk / Vermenigvuldiger",
                    description = "Instelling voor Politieaandacht en risico / Camper in bedrijf / Politiedruk / Vermenigvuldiger.",
                },
                drugAdvancedHeatCamperOperationalHeatThreshold = {
                    label = "Politieaandacht en risico / Camper in bedrijf / Politiedruk / Drempel",
                    description = "Instelling voor Politieaandacht en risico / Camper in bedrijf / Politiedruk / Drempel.",
                },
                drugAdvancedHeatCamperParkedHeat = {
                    label = "Politieaandacht en risico / Geparkeerde camper / Politiedruk",
                    description = "Instelling voor Politieaandacht en risico / Geparkeerde camper / Politiedruk.",
                },
                drugAdvancedHeatContaminatedHeatMultiplier = {
                    label = "Politieaandacht en risico / Verontreiniging / Politiedruk / Vermenigvuldiger",
                    description = "Instelling voor Politieaandacht en risico / Verontreiniging / Politiedruk / Vermenigvuldiger.",
                },
                drugAdvancedHeatContaminatedThreshold = {
                    label = "Politieaandacht en risico / Verontreiniging / Drempel",
                    description = "Instelling voor Politieaandacht en risico / Verontreiniging / Drempel.",
                },
                drugAdvancedHeatCultivationFreePlants = {
                    label = "Politieaandacht en risico / Teelt / Planten zonder extra risico",
                    description = "Instelling voor Politieaandacht en risico / Teelt / Planten zonder extra risico.",
                },
                drugAdvancedHeatCultivationHeatPerPlant = {
                    label = "Politieaandacht en risico / Teelt / Politiedruk / Per plant",
                    description = "Instelling voor Politieaandacht en risico / Teelt / Politiedruk / Per plant.",
                },
                drugAdvancedHeatDealerHiddenMinutes = {
                    label = "Politieaandacht en risico / Handelaar / verborgen / Minuten",
                    description = "Instelling voor Politieaandacht en risico / Handelaar / verborgen / Minuten.",
                },
                drugAdvancedHeatDecayPerTickBatch = {
                    label = "Politieaandacht en risico / Verval / Per updatestap / Batch",
                    description = "Instelling voor Politieaandacht en risico / Verval / Per updatestap / Batch.",
                },
                drugAdvancedHeatDecayPerTickCamper = {
                    label = "Politieaandacht en risico / Verval / Per updatestap / Camper",
                    description = "Instelling voor Politieaandacht en risico / Verval / Per updatestap / Camper.",
                },
                drugAdvancedHeatDecayPerTickDealer = {
                    label = "Politieaandacht en risico / Verval / Per updatestap / Handelaar",
                    description = "Instelling voor Politieaandacht en risico / Verval / Per updatestap / Handelaar.",
                },
                drugAdvancedHeatDecayPerTickFaction = {
                    label = "Politieaandacht en risico / Verval / Per updatestap / Factie",
                    description = "Instelling voor Politieaandacht en risico / Verval / Per updatestap / Factie.",
                },
                drugAdvancedHeatDecayPerTickHub = {
                    label = "Politieaandacht en risico / Verval / Per updatestap / Distributiecentrum",
                    description = "Instelling voor Politieaandacht en risico / Verval / Per updatestap / Distributiecentrum.",
                },
                drugAdvancedHeatDecayPerTickLab = {
                    label = "Politieaandacht en risico / Verval / Per updatestap / Lab",
                    description = "Instelling voor Politieaandacht en risico / Verval / Per updatestap / Lab.",
                },
                drugAdvancedHeatDecayPerTickPlayer = {
                    label = "Politieaandacht en risico / Verval / Per updatestap / Speler",
                    description = "Instelling voor Politieaandacht en risico / Verval / Per updatestap / Speler.",
                },
                drugAdvancedHeatDecayPerTickRoute = {
                    label = "Politieaandacht en risico / Verval / Per updatestap / Route",
                    description = "Instelling voor Politieaandacht en risico / Verval / Per updatestap / Route.",
                },
                drugAdvancedHeatDecayPerTickZone = {
                    label = "Politieaandacht en risico / Verval / Per updatestap / Zone",
                    description = "Instelling voor Politieaandacht en risico / Verval / Per updatestap / Zone.",
                },
                drugAdvancedHeatEnabled = {
                    label = "Politieaandacht en risico / Ingeschakeld",
                    description = "Instelling voor Politieaandacht en risico / Ingeschakeld.",
                },
                drugAdvancedHeatEnforcementHeatCritical = {
                    label = "Politieaandacht en risico / Politieaanwezigheid / Politiedruk / Kritiek",
                    description = "Instelling voor Politieaandacht en risico / Politieaanwezigheid / Politiedruk / Kritiek.",
                },
                drugAdvancedHeatEnforcementHeatHigh = {
                    label = "Politieaandacht en risico / Politieaanwezigheid / Politiedruk / Hoog",
                    description = "Instelling voor Politieaandacht en risico / Politieaanwezigheid / Politiedruk / Hoog.",
                },
                drugAdvancedHeatEnforcementHeatLow = {
                    label = "Politieaandacht en risico / Politieaanwezigheid / Politiedruk / Laag",
                    description = "Instelling voor Politieaandacht en risico / Politieaanwezigheid / Politiedruk / Laag.",
                },
                drugAdvancedHeatEnforcementHeatMedium = {
                    label = "Politieaandacht en risico / Politieaanwezigheid / Politiedruk / Gemiddeld",
                    description = "Instelling voor Politieaandacht en risico / Politieaanwezigheid / Politiedruk / Gemiddeld.",
                },
                drugAdvancedHeatEnforcementMultipliersBatch = {
                    label = "Politieaandacht en risico / Politieaanwezigheid / Vermenigvuldigers / Batch",
                    description = "Instelling voor Politieaandacht en risico / Politieaanwezigheid / Vermenigvuldigers / Batch.",
                },
                drugAdvancedHeatEnforcementMultipliersFaction = {
                    label = "Politieaandacht en risico / Politieaanwezigheid / Vermenigvuldigers / Factie",
                    description = "Instelling voor Politieaandacht en risico / Politieaanwezigheid / Vermenigvuldigers / Factie.",
                },
                drugAdvancedHeatEnforcementMultipliersZone = {
                    label = "Politieaandacht en risico / Politieaanwezigheid / Vermenigvuldigers / Zone",
                    description = "Instelling voor Politieaandacht en risico / Politieaanwezigheid / Vermenigvuldigers / Zone.",
                },
                drugAdvancedHeatEntityTypesBatch = {
                    label = "Politieaandacht en risico / Spelobject / Typen / Batch",
                    description = "Instelling voor Politieaandacht en risico / Spelobject / Typen / Batch.",
                },
                drugAdvancedHeatEntityTypesCamper = {
                    label = "Politieaandacht en risico / Spelobject / Typen / Camper",
                    description = "Instelling voor Politieaandacht en risico / Spelobject / Typen / Camper.",
                },
                drugAdvancedHeatEntityTypesDealer = {
                    label = "Politieaandacht en risico / Spelobject / Typen / Handelaar",
                    description = "Instelling voor Politieaandacht en risico / Spelobject / Typen / Handelaar.",
                },
                drugAdvancedHeatEntityTypesFaction = {
                    label = "Politieaandacht en risico / Spelobject / Typen / Factie",
                    description = "Instelling voor Politieaandacht en risico / Spelobject / Typen / Factie.",
                },
                drugAdvancedHeatEntityTypesHub = {
                    label = "Politieaandacht en risico / Spelobject / Typen / Distributiecentrum",
                    description = "Instelling voor Politieaandacht en risico / Spelobject / Typen / Distributiecentrum.",
                },
                drugAdvancedHeatEntityTypesLab = {
                    label = "Politieaandacht en risico / Spelobject / Typen / Lab",
                    description = "Instelling voor Politieaandacht en risico / Spelobject / Typen / Lab.",
                },
                drugAdvancedHeatEntityTypesPlayer = {
                    label = "Politieaandacht en risico / Spelobject / Typen / Speler",
                    description = "Instelling voor Politieaandacht en risico / Spelobject / Typen / Speler.",
                },
                drugAdvancedHeatEntityTypesRoute = {
                    label = "Politieaandacht en risico / Spelobject / Typen / Route",
                    description = "Instelling voor Politieaandacht en risico / Spelobject / Typen / Route.",
                },
                drugAdvancedHeatEntityTypesZone = {
                    label = "Politieaandacht en risico / Spelobject / Typen / Zone",
                    description = "Instelling voor Politieaandacht en risico / Spelobject / Typen / Zone.",
                },
                drugAdvancedHeatEventCooldownMinutes = {
                    label = "Politieaandacht en risico / Gebeurtenis / Afkoeltijd (minuten)",
                    description = "Instelling voor Politieaandacht en risico / Gebeurtenis / Afkoeltijd (minuten).",
                },
                drugAdvancedHeatEventHistoryLimit = {
                    label = "Politieaandacht en risico / Gebeurtenis / Geschiedenislimiet",
                    description = "Instelling voor Politieaandacht en risico / Gebeurtenis / Geschiedenislimiet.",
                },
                drugAdvancedHeatLabHeatSyncThreshold = {
                    label = "Politieaandacht en risico / Lab / Politiedruk / Synchronisatie / Drempel",
                    description = "Instelling voor Politieaandacht en risico / Lab / Politiedruk / Synchronisatie / Drempel.",
                },
                drugAdvancedHeatLayLowCooldownMinutes = {
                    label = "Politieaandacht en risico / Onderduiken / Afkoeltijd (minuten)",
                    description = "Instelling voor Politieaandacht en risico / Onderduiken / Afkoeltijd (minuten).",
                },
                drugAdvancedHeatLayLowIdleMinutes = {
                    label = "Politieaandacht en risico / Onderduiken / Inactief / Minuten",
                    description = "Instelling voor Politieaandacht en risico / Onderduiken / Inactief / Minuten.",
                },
                drugAdvancedHeatLayLowReduction = {
                    label = "Politieaandacht en risico / Onderduiken / Vermindering",
                    description = "Instelling voor Politieaandacht en risico / Onderduiken / Vermindering.",
                },
                drugAdvancedHeatLockdownMinutes = {
                    label = "Politieaandacht en risico / Lockdown / Minuten",
                    description = "Instelling voor Politieaandacht en risico / Lockdown / Minuten.",
                },
                drugAdvancedHeatMinimumDurationMinutes = {
                    label = "Politieaandacht en risico / Minimum / Duur / Minuten",
                    description = "Instelling voor Politieaandacht en risico / Minimum / Duur / Minuten.",
                },
                drugAdvancedHeatMinimumEventCooldownSeconds = {
                    label = "Politieaandacht en risico / Minimum / Gebeurtenis / Cooldown (seconden)",
                    description = "Instelling voor Politieaandacht en risico / Minimum / Gebeurtenis / Cooldown (seconden).",
                },
                drugAdvancedHeatMinimumIdleSeconds = {
                    label = "Politieaandacht en risico / Minimum / Inactief / seconden",
                    description = "Instelling voor Politieaandacht en risico / Minimum / Inactief / seconden.",
                },
                drugAdvancedHeatProcessingHeatMultiplier = {
                    label = "Politieaandacht en risico / Verwerking / Politiedruk / Vermenigvuldiger",
                    description = "Instelling voor Politieaandacht en risico / Verwerking / Politiedruk / Vermenigvuldiger.",
                },
                drugAdvancedHeatRiskWeightsBatch = {
                    label = "Politieaandacht en risico / Risico / Wegingen / Batch",
                    description = "Instelling voor Politieaandacht en risico / Risico / Wegingen / Batch.",
                },
                drugAdvancedHeatRiskWeightsCamper = {
                    label = "Politieaandacht en risico / Risico / Wegingen / Camper",
                    description = "Instelling voor Politieaandacht en risico / Risico / Wegingen / Camper.",
                },
                drugAdvancedHeatRiskWeightsDealer = {
                    label = "Politieaandacht en risico / Risico / Wegingen / Handelaar",
                    description = "Instelling voor Politieaandacht en risico / Risico / Wegingen / Handelaar.",
                },
                drugAdvancedHeatRiskWeightsFaction = {
                    label = "Politieaandacht en risico / Risico / Wegingen / Factie",
                    description = "Instelling voor Politieaandacht en risico / Risico / Wegingen / Factie.",
                },
                drugAdvancedHeatRiskWeightsHub = {
                    label = "Politieaandacht en risico / Risico / Wegingen / Distributiecentrum",
                    description = "Instelling voor Politieaandacht en risico / Risico / Wegingen / Distributiecentrum.",
                },
                drugAdvancedHeatRiskWeightsLab = {
                    label = "Politieaandacht en risico / Risico / Wegingen / Lab",
                    description = "Instelling voor Politieaandacht en risico / Risico / Wegingen / Lab.",
                },
                drugAdvancedHeatRiskWeightsPlayer = {
                    label = "Politieaandacht en risico / Risico / Wegingen / Speler",
                    description = "Instelling voor Politieaandacht en risico / Risico / Wegingen / Speler.",
                },
                drugAdvancedHeatRiskWeightsRoute = {
                    label = "Politieaandacht en risico / Risico / Wegingen / Route",
                    description = "Instelling voor Politieaandacht en risico / Risico / Wegingen / Route.",
                },
                drugAdvancedHeatRiskWeightsZone = {
                    label = "Politieaandacht en risico / Risico / Wegingen / Zone",
                    description = "Instelling voor Politieaandacht en risico / Risico / Wegingen / Zone.",
                },
                drugAdvancedHeatRotateBurnerReduction = {
                    label = "Politieaandacht en risico / Wegwerptelefoon wisselen / Vermindering",
                    description = "Instelling voor Politieaandacht en risico / Wegwerptelefoon wisselen / Vermindering.",
                },
                drugAdvancedHeatRouteControlMinutes = {
                    label = "Politieaandacht en risico / Route / Bediening / Minuten",
                    description = "Instelling voor Politieaandacht en risico / Route / Bediening / Minuten.",
                },
                drugAdvancedHeatSaleHeatBatch = {
                    label = "Politieaandacht en risico / Verkoop / Politiedruk / Batch",
                    description = "Instelling voor Politieaandacht en risico / Verkoop / Politiedruk / Batch.",
                },
                drugAdvancedHeatSaleHeatCamper = {
                    label = "Politieaandacht en risico / Verkoop / Politiedruk / Camper",
                    description = "Instelling voor Politieaandacht en risico / Verkoop / Politiedruk / Camper.",
                },
                drugAdvancedHeatSaleHeatDealer = {
                    label = "Politieaandacht en risico / Verkoop / Politiedruk / Handelaar",
                    description = "Instelling voor Politieaandacht en risico / Verkoop / Politiedruk / Handelaar.",
                },
                drugAdvancedHeatSaleHeatFaction = {
                    label = "Politieaandacht en risico / Verkoop / Politiedruk / Factie",
                    description = "Instelling voor Politieaandacht en risico / Verkoop / Politiedruk / Factie.",
                },
                drugAdvancedHeatSaleHeatHub = {
                    label = "Politieaandacht en risico / Verkoop / Politiedruk / Distributiecentrum",
                    description = "Instelling voor Politieaandacht en risico / Verkoop / Politiedruk / Distributiecentrum.",
                },
                drugAdvancedHeatSaleHeatLab = {
                    label = "Politieaandacht en risico / Verkoop / Politiedruk / Lab",
                    description = "Instelling voor Politieaandacht en risico / Verkoop / Politiedruk / Lab.",
                },
                drugAdvancedHeatSaleHeatPlayer = {
                    label = "Politieaandacht en risico / Verkoop / Politiedruk / Speler",
                    description = "Instelling voor Politieaandacht en risico / Verkoop / Politiedruk / Speler.",
                },
                drugAdvancedHeatSaleHeatRoute = {
                    label = "Politieaandacht en risico / Verkoop / Politiedruk / Route",
                    description = "Instelling voor Politieaandacht en risico / Verkoop / Politiedruk / Route.",
                },
                drugAdvancedHeatSaleHeatZone = {
                    label = "Politieaandacht en risico / Verkoop / Politiedruk / Zone",
                    description = "Instelling voor Politieaandacht en risico / Verkoop / Politiedruk / Zone.",
                },
                drugAdvancedHeatThresholdsCritical = {
                    label = "Politieaandacht en risico / Drempels / Kritiek",
                    description = "Instelling voor Politieaandacht en risico / Drempels / Kritiek.",
                },
                drugAdvancedHeatThresholdsHigh = {
                    label = "Politieaandacht en risico / Drempels / Hoog",
                    description = "Instelling voor Politieaandacht en risico / Drempels / Hoog.",
                },
                drugAdvancedHeatThresholdsLockdown = {
                    label = "Politieaandacht en risico / Drempels / Lockdown",
                    description = "Instelling voor Politieaandacht en risico / Drempels / Lockdown.",
                },
                drugAdvancedHeatThresholdsLow = {
                    label = "Politieaandacht en risico / Drempels / Laag",
                    description = "Instelling voor Politieaandacht en risico / Drempels / Laag.",
                },
                drugAdvancedHeatThresholdsMedium = {
                    label = "Politieaandacht en risico / Drempels / Gemiddeld",
                    description = "Instelling voor Politieaandacht en risico / Drempels / Gemiddeld.",
                },
                drugAdvancedHeatTickMinutes = {
                    label = "Politieaandacht en risico / Updatecyclus / Minuten",
                    description = "Instelling voor Politieaandacht en risico / Updatecyclus / Minuten.",
                },
                drugAdvancedHeatWholesaleHeatMultiplier = {
                    label = "Politieaandacht en risico / Groothandel / Politiedruk / Vermenigvuldiger",
                    description = "Instelling voor Politieaandacht en risico / Groothandel / Politiedruk / Vermenigvuldiger.",
                },
                drugAdvancedHeatWorkerLeakAlertRadius = {
                    label = "Politieaandacht en risico / Medewerker / Informatielek / Alertradius",
                    description = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Alertradius.",
                },
                drugAdvancedHeatWorkerLeakBaseChance = {
                    label = "Politieaandacht en risico / Medewerker / Informatielek / Basiswaarde / Kans",
                    description = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Basiswaarde / Kans.",
                },
                drugAdvancedHeatWorkerLeakFactionMultiplier = {
                    label = "Politieaandacht en risico / Medewerker / Informatielek / Factie / Vermenigvuldiger",
                    description = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Factie / Vermenigvuldiger.",
                },
                drugAdvancedHeatWorkerLeakHighSeverityThreshold = {
                    label = "Politieaandacht en risico / Medewerker / Informatielek / Hoog / Ernst / Drempel",
                    description = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Hoog / Ernst / Drempel.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Politieaandacht en risico / Medewerker / Informatielek / Loyaliteit / Kans / Vermenigvuldiger",
                    description = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Loyaliteit / Kans / Vermenigvuldiger.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyThreshold = {
                    label = "Politieaandacht en risico / Medewerker / Informatielek / Loyaliteit / Drempel",
                    description = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Loyaliteit / Drempel.",
                },
                drugAdvancedHeatWorkerLeakMaximumChance = {
                    label = "Politieaandacht en risico / Medewerker / Informatielek / Maximum / Kans",
                    description = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Maximum / Kans.",
                },
                drugAdvancedHeatWorkerLeakMinimumCooldownSeconds = {
                    label = "Politieaandacht en risico / Medewerker / Informatielek / Minimum / Cooldown (seconden)",
                    description = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Minimum / Cooldown (seconden).",
                },
                drugAdvancedHeatWorkerLeakRouteMultiplier = {
                    label = "Politieaandacht en risico / Medewerker / Informatielek / Route / Vermenigvuldiger",
                    description = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Route / Vermenigvuldiger.",
                },
                drugAdvancedHeatWorkerLeakStrengthMaximum = {
                    label = "Politieaandacht en risico / Medewerker / Informatielek / Sterkte / Maximum",
                    description = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Sterkte / Maximum.",
                },
                drugAdvancedHeatWorkerLeakStrengthMinimum = {
                    label = "Politieaandacht en risico / Medewerker / Informatielek / Sterkte / Minimum",
                    description = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Sterkte / Minimum.",
                },
                drugAdvancedHeatWorkerLeakStrengthMultiplier = {
                    label = "Politieaandacht en risico / Medewerker / Informatielek / Sterkte / Vermenigvuldiger",
                    description = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Sterkte / Vermenigvuldiger.",
                },
                drugAdvancedHeatWorkerLeakStressChanceMultiplier = {
                    label = "Politieaandacht en risico / Medewerker / Informatielek / Stress / Kans / Vermenigvuldiger",
                    description = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Stress / Kans / Vermenigvuldiger.",
                },
                drugAdvancedHeatWorkerLeakStressThreshold = {
                    label = "Politieaandacht en risico / Medewerker / Informatielek / Stress / Drempel",
                    description = "Instelling voor Politieaandacht en risico / Medewerker / Informatielek / Stress / Drempel.",
                },
                drugAdvancedContactNetworkActionCooldownSeconds = {
                    label = "Contactnetwerk / Actie-cooldown / seconden",
                    description = "Instelling voor Contactnetwerk / Actie-cooldown / seconden.",
                },
                drugAdvancedContactNetworkActiveHotspotCount = {
                    label = "Contactnetwerk / Aantal actieve hotspots",
                    description = "Instelling voor Contactnetwerk / Aantal actieve hotspots.",
                },
                drugAdvancedContactNetworkBurnerHintTrust = {
                    label = "Contactnetwerk / Burner-hint / Vertrouwen",
                    description = "Instelling voor Contactnetwerk / Burner-hint / Vertrouwen.",
                },
                drugAdvancedContactNetworkBurnerOfferMaximumMultiplier = {
                    label = "Contactnetwerk / Wegwerptelefoon / Aanbod / Maximum / Vermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Wegwerptelefoon / Aanbod / Maximum / Vermenigvuldiger.",
                },
                drugAdvancedContactNetworkBurnerOfferMinimumMultiplier = {
                    label = "Contactnetwerk / Wegwerptelefoon / Aanbod / Minimum / Vermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Wegwerptelefoon / Aanbod / Minimum / Vermenigvuldiger.",
                },
                drugAdvancedContactNetworkBuyerCooldownMinutes = {
                    label = "Contactnetwerk / Koper / Afkoeltijd (minuten)",
                    description = "Instelling voor Contactnetwerk / Koper / Afkoeltijd (minuten).",
                },
                drugAdvancedContactNetworkBuyerDeliveryDistance = {
                    label = "Contactnetwerk / Koper / Afleverafstand",
                    description = "Instelling voor Contactnetwerk / Koper / Afleverafstand.",
                },
                drugAdvancedContactNetworkBuyerPremiumSuccessScore = {
                    label = "Contactnetwerk / Koper / Premium / Succes / Score",
                    description = "Instelling voor Contactnetwerk / Koper / Premium / Succes / Score.",
                },
                drugAdvancedContactNetworkBuyerPremiumTrustGain = {
                    label = "Contactnetwerk / Koper / Premium / Vertrouwen / winst",
                    description = "Instelling voor Contactnetwerk / Koper / Premium / Vertrouwen / winst.",
                },
                drugAdvancedContactNetworkBuyerRequestHeatRiskWeight = {
                    label = "Contactnetwerk / Koper / Aanvraag / Heat & Risico / Gewicht",
                    description = "Instelling voor Contactnetwerk / Koper / Aanvraag / Heat & Risico / Gewicht.",
                },
                drugAdvancedContactNetworkBuyerStandardTrustGain = {
                    label = "Contactnetwerk / Koper / Standaard / Vertrouwen / winst",
                    description = "Instelling voor Contactnetwerk / Koper / Standaard / Vertrouwen / winst.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMax = {
                    label = "Contactnetwerk / Wachttijd voor contactactivering / seconden / Maximum",
                    description = "Instelling voor Contactnetwerk / Wachttijd voor contactactivering / seconden / Maximum.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMin = {
                    label = "Contactnetwerk / Wachttijd voor contactactivering / seconden / Minimum",
                    description = "Instelling voor Contactnetwerk / Wachttijd voor contactactivering / seconden / Minimum.",
                },
                drugAdvancedContactNetworkContactDemandRangeMax = {
                    label = "Contactnetwerk / Contact / Vraag / Waardenbereik / Maximum",
                    description = "Instelling voor Contactnetwerk / Contact / Vraag / Waardenbereik / Maximum.",
                },
                drugAdvancedContactNetworkContactDemandRangeMin = {
                    label = "Contactnetwerk / Contact / Vraag / Waardenbereik / Minimum",
                    description = "Instelling voor Contactnetwerk / Contact / Vraag / Waardenbereik / Minimum.",
                },
                drugAdvancedContactNetworkContactLossTrust = {
                    label = "Contactnetwerk / Contact / Verlies / Vertrouwen",
                    description = "Instelling voor Contactnetwerk / Contact / Verlies / Vertrouwen.",
                },
                drugAdvancedContactNetworkDarknetExactIntelMinutes = {
                    label = "Contactnetwerk / Darknet / Exacte informatie / Minuten",
                    description = "Instelling voor Contactnetwerk / Darknet / Exacte informatie / Minuten.",
                },
                drugAdvancedContactNetworkDarknetHotspotIntelPrice = {
                    label = "Contactnetwerk / Darknet / Hotspot / Informatie / Prijs",
                    description = "Instelling voor Contactnetwerk / Darknet / Hotspot / Informatie / Prijs.",
                },
                drugAdvancedContactNetworkDarknetIntelPrice = {
                    label = "Contactnetwerk / Darknet / Informatie / Prijs",
                    description = "Instelling voor Contactnetwerk / Darknet / Informatie / Prijs.",
                },
                drugAdvancedContactNetworkDealerBasePrice = {
                    label = "Contactnetwerk / Handelaar / Basisprijs",
                    description = "Instelling voor Contactnetwerk / Handelaar / Basisprijs.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMax = {
                    label = "Contactnetwerk / Handelaar / Aanwerving / capaciteit / Maximum",
                    description = "Instelling voor Contactnetwerk / Handelaar / Aanwerving / capaciteit / Maximum.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMin = {
                    label = "Contactnetwerk / Handelaar / Aanwerving / capaciteit / Minimum",
                    description = "Instelling voor Contactnetwerk / Handelaar / Aanwerving / capaciteit / Minimum.",
                },
                drugAdvancedContactNetworkDealerHireRiskMax = {
                    label = "Contactnetwerk / Handelaar / Aanwerving / Risico / Maximum",
                    description = "Instelling voor Contactnetwerk / Handelaar / Aanwerving / Risico / Maximum.",
                },
                drugAdvancedContactNetworkDealerHireRiskMin = {
                    label = "Contactnetwerk / Handelaar / Aanwerving / Risico / Minimum",
                    description = "Instelling voor Contactnetwerk / Handelaar / Aanwerving / Risico / Minimum.",
                },
                drugAdvancedContactNetworkDealerHireSkillMax = {
                    label = "Contactnetwerk / Handelaar / Aanwerving / Vaardigheid / Maximum",
                    description = "Instelling voor Contactnetwerk / Handelaar / Aanwerving / Vaardigheid / Maximum.",
                },
                drugAdvancedContactNetworkDealerHireSkillMin = {
                    label = "Contactnetwerk / Handelaar / Aanwerving / Vaardigheid / Minimum",
                    description = "Instelling voor Contactnetwerk / Handelaar / Aanwerving / Vaardigheid / Minimum.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Id = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 1 / ID",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 1 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Item = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 1 / Voorwerp",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 1 / Voorwerp.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Label = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 1 / Naam",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 1 / Naam.",
                },
                drugAdvancedContactNetworkDealerOffersItem1MinTrust = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 1 / Minimaal vertrouwen",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 1 / Minimaal vertrouwen.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Price = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 1 / Prijs",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 1 / Prijs.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Id = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 2 / ID",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 2 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Item = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 2 / Voorwerp",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 2 / Voorwerp.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Label = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 2 / Naam",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 2 / Naam.",
                },
                drugAdvancedContactNetworkDealerOffersItem2MinTrust = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 2 / Minimaal vertrouwen",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 2 / Minimaal vertrouwen.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Price = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 2 / Prijs",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 2 / Prijs.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Id = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 3 / ID",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 3 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Item = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 3 / Voorwerp",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 3 / Voorwerp.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Label = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 3 / Naam",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 3 / Naam.",
                },
                drugAdvancedContactNetworkDealerOffersItem3MinTrust = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 3 / Minimaal vertrouwen",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 3 / Minimaal vertrouwen.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Price = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 3 / Prijs",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 3 / Prijs.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Id = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 4 / ID",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 4 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Item = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 4 / Voorwerp",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 4 / Voorwerp.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Label = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 4 / Naam",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 4 / Naam.",
                },
                drugAdvancedContactNetworkDealerOffersItem4MinTrust = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 4 / Minimaal vertrouwen",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 4 / Minimaal vertrouwen.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Price = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 4 / Prijs",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 4 / Prijs.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Id = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 5 / ID",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 5 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Item = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 5 / Voorwerp",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 5 / Voorwerp.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Label = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 5 / Naam",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 5 / Naam.",
                },
                drugAdvancedContactNetworkDealerOffersItem5MinTrust = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 5 / Minimaal vertrouwen",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 5 / Minimaal vertrouwen.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Price = {
                    label = "Contactnetwerk / Dealer-aanbiedingen / 5 / Prijs",
                    description = "Instelling voor Contactnetwerk / Dealer-aanbiedingen / 5 / Prijs.",
                },
                drugAdvancedContactNetworkDealerProtectionHours = {
                    label = "Contactnetwerk / Handelaar / Bescherming / Uren",
                    description = "Instelling voor Contactnetwerk / Handelaar / Bescherming / Uren.",
                },
                drugAdvancedContactNetworkDealerProtectionPrice = {
                    label = "Contactnetwerk / Handelaar / Bescherming / Prijs",
                    description = "Instelling voor Contactnetwerk / Handelaar / Bescherming / Prijs.",
                },
                drugAdvancedContactNetworkDealerSaleMax = {
                    label = "Contactnetwerk / Handelaar / Verkoop / Maximum",
                    description = "Instelling voor Contactnetwerk / Handelaar / Verkoop / Maximum.",
                },
                drugAdvancedContactNetworkDealerSaleMin = {
                    label = "Contactnetwerk / Handelaar / Verkoop / Minimum",
                    description = "Instelling voor Contactnetwerk / Handelaar / Verkoop / Minimum.",
                },
                drugAdvancedContactNetworkDealerSimulationAggressivePriceMultiplier = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Agressieve werkwijze / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Agressieve werkwijze / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkDealerSimulationBaseQualityPriceFactor = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Basiskwaliteit / Prijsfactor",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Basiskwaliteit / Prijsfactor.",
                },
                drugAdvancedContactNetworkDealerSimulationBulkPriceMultiplier = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Grote hoeveelheid / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Grote hoeveelheid / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkDealerSimulationCheapPriceMultiplier = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Goedkope verkopen / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Goedkope verkopen / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkDealerSimulationDefaultQuality = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Standaardwaarde / Kwaliteit",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Standaardwaarde / Kwaliteit.",
                },
                drugAdvancedContactNetworkDealerSimulationDisloyalThreshold = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Drempel voor ontrouw",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Drempel voor ontrouw.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerLevel = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Ervaring / Per niveau",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Ervaring / Per niveau.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerUnit = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Ervaring / Per eenheid",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Ervaring / Per eenheid.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentLoyaltyLoss = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Incident / Loyaliteit / Verlies",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Incident / Loyaliteit / Verlies.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentRollMaximum = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Incident / Willekeurige controle / Maximum",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Incident / Willekeurige controle / Maximum.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelPriceBonus = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Niveau / Prijs / Bonus",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Niveau / Prijs / Bonus.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelSaleDivisor = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Niveau / Verkoop / Deler",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Niveau / Verkoop / Deler.",
                },
                drugAdvancedContactNetworkDealerSimulationLoyaltyRiskWeight = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Loyaliteit / Risico / Gewicht",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Loyaliteit / Risico / Gewicht.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumIncidentChance = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Maximum / Incident / Kans",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Maximum / Incident / Kans.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumLevel = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Maximum / Niveau",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Maximum / Niveau.",
                },
                drugAdvancedContactNetworkDealerSimulationPremiumPriceMultiplier = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Premium / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Premium / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkDealerSimulationProfileRiskWeight = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Profiel / Risico / Gewicht",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Profiel / Risico / Gewicht.",
                },
                drugAdvancedContactNetworkDealerSimulationProtectionRiskReduction = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Bescherming / Risico / Vermindering",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Bescherming / Risico / Vermindering.",
                },
                drugAdvancedContactNetworkDealerSimulationQualityPriceDivisor = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Kwaliteit / Prijs / Deler",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Kwaliteit / Prijs / Deler.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryBaseChance = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Herstel / Basiswaarde / Kans",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Herstel / Basiswaarde / Kans.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryLoyaltyWeight = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Herstel / Loyaliteit / Gewicht",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Herstel / Loyaliteit / Gewicht.",
                },
                drugAdvancedContactNetworkDealerSimulationRobbedStockLoss = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Voorraadverlies door roof",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Voorraadverlies door roof.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillRiskReduction = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Vaardigheid / Risico / Vermindering",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Vaardigheid / Risico / Vermindering.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillSaleDivisor = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Vaardigheid / Verkoop / Deler",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Vaardigheid / Verkoop / Deler.",
                },
                drugAdvancedContactNetworkDealerSimulationStableLoyaltyThreshold = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Drempel voor stabiele loyaliteit",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Drempel voor stabiele loyaliteit.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryPriceMultiplier = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Territorium / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Territorium / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryRiskReduction = {
                    label = "Contactnetwerk / Handelaar / Simulatie / Territorium / Risico / Vermindering",
                    description = "Instelling voor Contactnetwerk / Handelaar / Simulatie / Territorium / Risico / Vermindering.",
                },
                drugAdvancedContactNetworkDealerTickMinutes = {
                    label = "Contactnetwerk / Handelaar / Updatecyclus / Minuten",
                    description = "Instelling voor Contactnetwerk / Handelaar / Updatecyclus / Minuten.",
                },
                drugAdvancedContactNetworkDealerWage = {
                    label = "Contactnetwerk / Handelaar / Loon",
                    description = "Instelling voor Contactnetwerk / Handelaar / Loon.",
                },
                drugAdvancedContactNetworkDealerWageDecay = {
                    label = "Contactnetwerk / Handelaar / Loon / Verval",
                    description = "Instelling voor Contactnetwerk / Handelaar / Loon / Verval.",
                },
                drugAdvancedContactNetworkDealerWageLoyaltyGain = {
                    label = "Contactnetwerk / Handelaar / Loon / Loyaliteit / winst",
                    description = "Instelling voor Contactnetwerk / Handelaar / Loon / Loyaliteit / winst.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem1 = {
                    label = "Contactnetwerk / Handelaar / Zwakke punten / 1",
                    description = "Instelling voor Contactnetwerk / Handelaar / Zwakke punten / 1.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem2 = {
                    label = "Contactnetwerk / Handelaar / Zwakke punten / 2",
                    description = "Instelling voor Contactnetwerk / Handelaar / Zwakke punten / 2.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem3 = {
                    label = "Contactnetwerk / Handelaar / Zwakke punten / 3",
                    description = "Instelling voor Contactnetwerk / Handelaar / Zwakke punten / 3.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem4 = {
                    label = "Contactnetwerk / Handelaar / Zwakke punten / 4",
                    description = "Instelling voor Contactnetwerk / Handelaar / Zwakke punten / 4.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem5 = {
                    label = "Contactnetwerk / Handelaar / Zwakke punten / 5",
                    description = "Instelling voor Contactnetwerk / Handelaar / Zwakke punten / 5.",
                },
                drugAdvancedContactNetworkDefaultContactDemand = {
                    label = "Contactnetwerk / Standaardwaarde / Contact / Vraag",
                    description = "Instelling voor Contactnetwerk / Standaardwaarde / Contact / Vraag.",
                },
                drugAdvancedContactNetworkDefaultContactRisk = {
                    label = "Contactnetwerk / Standaardwaarde / Contact / Risico",
                    description = "Instelling voor Contactnetwerk / Standaardwaarde / Contact / Risico.",
                },
                drugAdvancedContactNetworkDefaultDealerCapacity = {
                    label = "Contactnetwerk / Standaarddealer / capaciteit",
                    description = "Instelling voor Contactnetwerk / Standaarddealer / capaciteit.",
                },
                drugAdvancedContactNetworkDefaultDealerRisk = {
                    label = "Contactnetwerk / Standaarddealer / Risico",
                    description = "Instelling voor Contactnetwerk / Standaarddealer / Risico.",
                },
                drugAdvancedContactNetworkDefaultDealerSkill = {
                    label = "Contactnetwerk / Standaarddealer / Vaardigheid",
                    description = "Instelling voor Contactnetwerk / Standaarddealer / Vaardigheid.",
                },
                drugAdvancedContactNetworkDefaultHotspotRadius = {
                    label = "Contactnetwerk / Standaardwaarde / Hotspot / Straal",
                    description = "Instelling voor Contactnetwerk / Standaardwaarde / Hotspot / Straal.",
                },
                drugAdvancedContactNetworkDemandResetMinutes = {
                    label = "Contactnetwerk / Vraagreset (minuten)",
                    description = "Instelling voor Contactnetwerk / Vraagreset (minuten).",
                },
                drugAdvancedContactNetworkEnabled = {
                    label = "Contactnetwerk / Ingeschakeld",
                    description = "Instelling voor Contactnetwerk / Ingeschakeld.",
                },
                drugAdvancedContactNetworkExactLocationTrust = {
                    label = "Contactnetwerk / Exacte locatie / Vertrouwen",
                    description = "Instelling voor Contactnetwerk / Exacte locatie / Vertrouwen.",
                },
                drugAdvancedContactNetworkFactionDiscoveryReputation = {
                    label = "Contactnetwerk / Factie / Ontdekking / Reputatie",
                    description = "Instelling voor Contactnetwerk / Factie / Ontdekking / Reputatie.",
                },
                drugAdvancedContactNetworkFactionHintTrust = {
                    label = "Contactnetwerk / Factie / Aanwijzing / Vertrouwen",
                    description = "Instelling voor Contactnetwerk / Factie / Aanwijzing / Vertrouwen.",
                },
                drugAdvancedContactNetworkFailedDeliveryCooldownMinutes = {
                    label = "Contactnetwerk / Mislukte levering / Afkoeltijd (minuten)",
                    description = "Instelling voor Contactnetwerk / Mislukte levering / Afkoeltijd (minuten).",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerCount = {
                    label = "Contactnetwerk / Nepdeal / Ontmoeting / Aanvaller / Aantal",
                    description = "Instelling voor Contactnetwerk / Nepdeal / Ontmoeting / Aanvaller / Aantal.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem1 = {
                    label = "Contactnetwerk / Nepdeal / Ontmoeting / Aanvaller / Modellen / 1",
                    description = "Instelling voor Contactnetwerk / Nepdeal / Ontmoeting / Aanvaller / Modellen / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem2 = {
                    label = "Contactnetwerk / Nepdeal / Ontmoeting / Aanvaller / Modellen / 2",
                    description = "Instelling voor Contactnetwerk / Nepdeal / Ontmoeting / Aanvaller / Modellen / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem3 = {
                    label = "Contactnetwerk / Nepdeal / Ontmoeting / Aanvaller / Modellen / 3",
                    description = "Instelling voor Contactnetwerk / Nepdeal / Ontmoeting / Aanvaller / Modellen / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterDurationSeconds = {
                    label = "Contactnetwerk / Nepdeal / Ontmoeting / Duur (seconden)",
                    description = "Instelling voor Contactnetwerk / Nepdeal / Ontmoeting / Duur (seconden).",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem1 = {
                    label = "Contactnetwerk / Nepdeal / Ontmoeting / Politie / Modellen / 1",
                    description = "Instelling voor Contactnetwerk / Nepdeal / Ontmoeting / Politie / Modellen / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem2 = {
                    label = "Contactnetwerk / Nepdeal / Ontmoeting / Politie / Modellen / 2",
                    description = "Instelling voor Contactnetwerk / Nepdeal / Ontmoeting / Politie / Modellen / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem3 = {
                    label = "Contactnetwerk / Nepdeal / Ontmoeting / Politie / Modellen / 3",
                    description = "Instelling voor Contactnetwerk / Nepdeal / Ontmoeting / Politie / Modellen / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterSpawnRadius = {
                    label = "Contactnetwerk / Nepdeal / Ontmoeting / Spawn-radius",
                    description = "Instelling voor Contactnetwerk / Nepdeal / Ontmoeting / Spawn-radius.",
                },
                drugAdvancedContactNetworkFallbackPreferredDrug = {
                    label = "Contactnetwerk / Vervangende waarde / Voorkeursdrug",
                    description = "Instelling voor Contactnetwerk / Vervangende waarde / Voorkeursdrug.",
                },
                drugAdvancedContactNetworkFallbackProductLabel = {
                    label = "Contactnetwerk / Vervangende waarde / Productlabel",
                    description = "Instelling voor Contactnetwerk / Vervangende waarde / Productlabel.",
                },
                drugAdvancedContactNetworkGuideBookItem = {
                    label = "Contactnetwerk / Handleiding / Boek / Voorwerp",
                    description = "Instelling voor Contactnetwerk / Handleiding / Boek / Voorwerp.",
                },
                drugAdvancedContactNetworkGuideBookTrust = {
                    label = "Contactnetwerk / Handleiding / Boek / Vertrouwen",
                    description = "Instelling voor Contactnetwerk / Handleiding / Boek / Vertrouwen.",
                },
                drugAdvancedContactNetworkHireDealerPrice = {
                    label = "Contactnetwerk / Dealer inhuren / Prijs",
                    description = "Instelling voor Contactnetwerk / Dealer inhuren / Prijs.",
                },
                drugAdvancedContactNetworkHistoryLimit = {
                    label = "Contactnetwerk / Geschiedenislimiet",
                    description = "Instelling voor Contactnetwerk / Geschiedenislimiet.",
                },
                drugAdvancedContactNetworkHotspotIntelMinutes = {
                    label = "Contactnetwerk / Hotspot / Informatie / Minuten",
                    description = "Instelling voor Contactnetwerk / Hotspot / Informatie / Minuten.",
                },
                drugAdvancedContactNetworkHotspotRotationMinutes = {
                    label = "Contactnetwerk / Hotspot / Wisseling / Minuten",
                    description = "Instelling voor Contactnetwerk / Hotspot / Wisseling / Minuten.",
                },
                drugAdvancedContactNetworkListingDurationMinutes = {
                    label = "Contactnetwerk / Advertentie / Duur / Minuten",
                    description = "Instelling voor Contactnetwerk / Advertentie / Duur / Minuten.",
                },
                drugAdvancedContactNetworkMaxOwnedDealers = {
                    label = "Contactnetwerk / Maximum / In bezit / Dealers",
                    description = "Instelling voor Contactnetwerk / Maximum / In bezit / Dealers.",
                },
                drugAdvancedContactNetworkMinimumBuyerDeliveryDistance = {
                    label = "Contactnetwerk / Minimum / Koper / Afleverafstand",
                    description = "Instelling voor Contactnetwerk / Minimum / Koper / Afleverafstand.",
                },
                drugAdvancedContactNetworkMinimumContactRotationMinutes = {
                    label = "Contactnetwerk / Minimum / Contactrotatie (minuten)",
                    description = "Instelling voor Contactnetwerk / Minimum / Contactrotatie (minuten).",
                },
                drugAdvancedContactNetworkMinimumDemandResetMinutes = {
                    label = "Contactnetwerk / Minimum / Vraagreset (minuten)",
                    description = "Instelling voor Contactnetwerk / Minimum / Vraagreset (minuten).",
                },
                drugAdvancedContactNetworkMinimumHeatMultiplier = {
                    label = "Contactnetwerk / Minimum / Politiedruk / Vermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Minimum / Politiedruk / Vermenigvuldiger.",
                },
                drugAdvancedContactNetworkMinimumHotspotIntelMinutes = {
                    label = "Contactnetwerk / Minimum / Hotspot / Informatie / Minuten",
                    description = "Instelling voor Contactnetwerk / Minimum / Hotspot / Informatie / Minuten.",
                },
                drugAdvancedContactNetworkMinimumHotspotRadius = {
                    label = "Contactnetwerk / Minimum / Hotspot / Straal",
                    description = "Instelling voor Contactnetwerk / Minimum / Hotspot / Straal.",
                },
                drugAdvancedContactNetworkMinimumHotspotRotationMinutes = {
                    label = "Contactnetwerk / Minimum / Hotspot / Wisseling / Minuten",
                    description = "Instelling voor Contactnetwerk / Minimum / Hotspot / Wisseling / Minuten.",
                },
                drugAdvancedContactNetworkMinimumListingDurationMinutes = {
                    label = "Contactnetwerk / Minimum / Advertentie / Duur / Minuten",
                    description = "Instelling voor Contactnetwerk / Minimum / Advertentie / Duur / Minuten.",
                },
                drugAdvancedContactNetworkMinimumRewardMultiplier = {
                    label = "Contactnetwerk / Minimale beloning / Vermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Minimale beloning / Vermenigvuldiger.",
                },
                drugAdvancedContactNetworkMinimumRobberyMultiplier = {
                    label = "Contactnetwerk / Minimum / Overval / Vermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Minimum / Overval / Vermenigvuldiger.",
                },
                drugAdvancedContactNetworkMinimumSpotPriceMultiplier = {
                    label = "Contactnetwerk / Minimum / Locatie / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Minimum / Locatie / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkOtherDrugPriceMultiplier = {
                    label = "Contactnetwerk / Andere / Drug / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Andere / Drug / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkPaymentAccount = {
                    label = "Contactnetwerk / Betaalrekening",
                    description = "Instelling voor Contactnetwerk / Betaalrekening.",
                },
                drugAdvancedContactNetworkPostDeliveryDemandResetSeconds = {
                    label = "Contactnetwerk / Na levering / Vraag / Reset / seconden",
                    description = "Instelling voor Contactnetwerk / Na levering / Vraag / Reset / seconden.",
                },
                drugAdvancedContactNetworkPreferredDrugPriceMultiplier = {
                    label = "Contactnetwerk / Voorkeursdrug / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Voorkeursdrug / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkRegionLocationTrust = {
                    label = "Contactnetwerk / Regio / Locatie / Vertrouwen",
                    description = "Instelling voor Contactnetwerk / Regio / Locatie / Vertrouwen.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMax = {
                    label = "Contactnetwerk / Aanvraag / Hoeveelheden / Grote hoeveelheid / Maximum",
                    description = "Instelling voor Contactnetwerk / Aanvraag / Hoeveelheden / Grote hoeveelheid / Maximum.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMin = {
                    label = "Contactnetwerk / Aanvraag / Hoeveelheden / Grote hoeveelheid / Minimum",
                    description = "Instelling voor Contactnetwerk / Aanvraag / Hoeveelheden / Grote hoeveelheid / Minimum.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMax = {
                    label = "Contactnetwerk / Aanvraag / Hoeveelheden / Premium / Maximum",
                    description = "Instelling voor Contactnetwerk / Aanvraag / Hoeveelheden / Premium / Maximum.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMin = {
                    label = "Contactnetwerk / Aanvraag / Hoeveelheden / Premium / Minimum",
                    description = "Instelling voor Contactnetwerk / Aanvraag / Hoeveelheden / Premium / Minimum.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMax = {
                    label = "Contactnetwerk / Aanvraag / Hoeveelheden / Standaard / Maximum",
                    description = "Instelling voor Contactnetwerk / Aanvraag / Hoeveelheden / Standaard / Maximum.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMin = {
                    label = "Contactnetwerk / Aanvraag / Hoeveelheden / Standaard / Minimum",
                    description = "Instelling voor Contactnetwerk / Aanvraag / Hoeveelheden / Standaard / Minimum.",
                },
                drugAdvancedContactNetworkRotationMinutes = {
                    label = "Contactnetwerk / Wisseling / Minuten",
                    description = "Instelling voor Contactnetwerk / Wisseling / Minuten.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 1 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 1 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 1 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 1 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 1 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 1 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 1 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 1 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 1 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 1 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 1 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 1 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 1 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 1 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 1 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 1 / Risico.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 2 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 2 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 2 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 2 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 2 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 2 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 2 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 2 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 2 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 2 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 2 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 2 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 2 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 2 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 2 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 2 / Risico.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 3 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 3 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 3 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 3 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 3 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 3 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 3 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 3 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 3 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 3 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 3 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 3 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 3 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 3 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 3 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Straatdealer / 3 / Risico.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 1 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 1 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 1 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 1 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 1 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 1 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 1 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 1 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 1 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 1 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 1 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 1 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 1 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 1 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 1 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 1 / Risico.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 2 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 2 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 2 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 2 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 2 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 2 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 2 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 2 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 2 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 2 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 2 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 2 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 2 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 2 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 2 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 2 / Risico.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 3 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 3 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 3 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 3 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 3 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 3 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 3 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 3 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 3 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 3 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 3 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 3 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 3 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 3 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 3 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaardkoper / 3 / Risico.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 1 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 1 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 1 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 1 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 1 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 1 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 1 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 1 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 1 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 1 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 1 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 1 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 1 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 1 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 1 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 1 / Risico.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 2 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 2 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 2 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 2 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 2 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 2 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 2 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 2 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 2 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 2 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 2 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 2 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 2 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 2 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 2 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 2 / Risico.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 3 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 3 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 3 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 3 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 3 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 3 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 3 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 3 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 3 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 3 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 3 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 3 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 3 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 3 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 3 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Standaarddealer / 3 / Risico.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 1 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 1 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 1 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 1 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 1 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 1 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 1 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 1 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 1 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 1 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 1 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 1 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 1 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 1 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 1 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 1 / Risico.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 2 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 2 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 2 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 2 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 2 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 2 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 2 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 2 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 2 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 2 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 2 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 2 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 2 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 2 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 2 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 2 / Risico.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 3 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 3 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 3 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 3 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 3 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 3 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 3 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 3 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 3 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 3 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 3 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 3 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 3 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 3 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 3 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Netwerkdealer / 3 / Risico.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 1 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 1 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 1 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 1 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 1 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 1 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 1 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 1 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 1 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 1 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 1 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 1 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 1 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 1 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 1 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 1 / Risico.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 2 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 2 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 2 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 2 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 2 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 2 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 2 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 2 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 2 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 2 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 2 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 2 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 2 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 2 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 2 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 2 / Risico.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 3 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 3 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 3 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 3 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 3 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 3 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 3 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 3 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 3 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 3 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 3 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 3 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 3 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 3 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 3 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Premium bemiddelaar / 3 / Risico.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 1 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 1 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 1 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 1 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 1 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 1 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 1 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 1 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 1 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 1 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 1 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 1 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 1 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 1 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 1 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 1 / Risico.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 2 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 2 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 2 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 2 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 2 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 2 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 2 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 2 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 2 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 2 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 2 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 2 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 2 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 2 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 2 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 2 / Risico.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsX = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 3 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 3 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsY = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 3 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 3 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsZ = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 3 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 3 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsW = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 3 / Coördinaten / W",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 3 / Coördinaten / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Label = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 3 / Naam",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 3 / Naam.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3PriceMultiplier = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 3 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 3 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Region = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 3 / Regio",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 3 / Regio.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Risk = {
                    label = "Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 3 / Risico",
                    description = "Instelling voor Contactnetwerk / Locatie / Selectiegroepen / Groothandelscontact / 3 / Risico.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1AcceptBonus = {
                    label = "Contactnetwerk / Straat / Hotspots / 1 / Acceptatiebonus",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 1 / Acceptatiebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Archetype = {
                    label = "Contactnetwerk / Straat / Hotspots / 1 / Basistype",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 1 / Basistype.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsX = {
                    label = "Contactnetwerk / Straat / Hotspots / 1 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 1 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsY = {
                    label = "Contactnetwerk / Straat / Hotspots / 1 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 1 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsZ = {
                    label = "Contactnetwerk / Straat / Hotspots / 1 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 1 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1DemandBonus = {
                    label = "Contactnetwerk / Straat / Hotspots / 1 / Vraagbonus",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 1 / Vraagbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1HeatMultiplier = {
                    label = "Contactnetwerk / Straat / Hotspots / 1 / Politiedruk / Vermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 1 / Politiedruk / Vermenigvuldiger.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Id = {
                    label = "Contactnetwerk / Straat / Hotspots / 1 / ID",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 1 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Label = {
                    label = "Contactnetwerk / Straat / Hotspots / 1 / Naam",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 1 / Naam.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem1 = {
                    label = "Contactnetwerk / Straat / Hotspots / 1 / Voorkeursdrugs / 1",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 1 / Voorkeursdrugs / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem2 = {
                    label = "Contactnetwerk / Straat / Hotspots / 1 / Voorkeursdrugs / 2",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 1 / Voorkeursdrugs / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem3 = {
                    label = "Contactnetwerk / Straat / Hotspots / 1 / Voorkeursdrugs / 3",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 1 / Voorkeursdrugs / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem4 = {
                    label = "Contactnetwerk / Straat / Hotspots / 1 / Voorkeursdrugs / 4",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 1 / Voorkeursdrugs / 4.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PriceMultiplier = {
                    label = "Contactnetwerk / Straat / Hotspots / 1 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 1 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Radius = {
                    label = "Contactnetwerk / Straat / Hotspots / 1 / Straal",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 1 / Straal.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Region = {
                    label = "Contactnetwerk / Straat / Hotspots / 1 / Regio",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 1 / Regio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1RobberyMultiplier = {
                    label = "Contactnetwerk / Straat / Hotspots / 1 / Overval / Vermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 1 / Overval / Vermenigvuldiger.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2AcceptBonus = {
                    label = "Contactnetwerk / Straat / Hotspots / 2 / Acceptatiebonus",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 2 / Acceptatiebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Archetype = {
                    label = "Contactnetwerk / Straat / Hotspots / 2 / Basistype",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 2 / Basistype.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsX = {
                    label = "Contactnetwerk / Straat / Hotspots / 2 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 2 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsY = {
                    label = "Contactnetwerk / Straat / Hotspots / 2 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 2 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsZ = {
                    label = "Contactnetwerk / Straat / Hotspots / 2 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 2 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2DemandBonus = {
                    label = "Contactnetwerk / Straat / Hotspots / 2 / Vraagbonus",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 2 / Vraagbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2HeatMultiplier = {
                    label = "Contactnetwerk / Straat / Hotspots / 2 / Politiedruk / Vermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 2 / Politiedruk / Vermenigvuldiger.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Id = {
                    label = "Contactnetwerk / Straat / Hotspots / 2 / ID",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 2 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Label = {
                    label = "Contactnetwerk / Straat / Hotspots / 2 / Naam",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 2 / Naam.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2MinimumQuality = {
                    label = "Contactnetwerk / Straat / Hotspots / 2 / Minimale kwaliteit",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 2 / Minimale kwaliteit.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem1 = {
                    label = "Contactnetwerk / Straat / Hotspots / 2 / Voorkeursdrugs / 1",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 2 / Voorkeursdrugs / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem2 = {
                    label = "Contactnetwerk / Straat / Hotspots / 2 / Voorkeursdrugs / 2",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 2 / Voorkeursdrugs / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PriceMultiplier = {
                    label = "Contactnetwerk / Straat / Hotspots / 2 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 2 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Radius = {
                    label = "Contactnetwerk / Straat / Hotspots / 2 / Straal",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 2 / Straal.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Region = {
                    label = "Contactnetwerk / Straat / Hotspots / 2 / Regio",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 2 / Regio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2RobberyMultiplier = {
                    label = "Contactnetwerk / Straat / Hotspots / 2 / Overval / Vermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 2 / Overval / Vermenigvuldiger.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3AcceptBonus = {
                    label = "Contactnetwerk / Straat / Hotspots / 3 / Acceptatiebonus",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 3 / Acceptatiebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Archetype = {
                    label = "Contactnetwerk / Straat / Hotspots / 3 / Basistype",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 3 / Basistype.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsX = {
                    label = "Contactnetwerk / Straat / Hotspots / 3 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 3 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsY = {
                    label = "Contactnetwerk / Straat / Hotspots / 3 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 3 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsZ = {
                    label = "Contactnetwerk / Straat / Hotspots / 3 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 3 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3DemandBonus = {
                    label = "Contactnetwerk / Straat / Hotspots / 3 / Vraagbonus",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 3 / Vraagbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3HeatMultiplier = {
                    label = "Contactnetwerk / Straat / Hotspots / 3 / Politiedruk / Vermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 3 / Politiedruk / Vermenigvuldiger.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Id = {
                    label = "Contactnetwerk / Straat / Hotspots / 3 / ID",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 3 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Label = {
                    label = "Contactnetwerk / Straat / Hotspots / 3 / Naam",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 3 / Naam.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem1 = {
                    label = "Contactnetwerk / Straat / Hotspots / 3 / Voorkeursdrugs / 1",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 3 / Voorkeursdrugs / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem2 = {
                    label = "Contactnetwerk / Straat / Hotspots / 3 / Voorkeursdrugs / 2",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 3 / Voorkeursdrugs / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem3 = {
                    label = "Contactnetwerk / Straat / Hotspots / 3 / Voorkeursdrugs / 3",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 3 / Voorkeursdrugs / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PriceMultiplier = {
                    label = "Contactnetwerk / Straat / Hotspots / 3 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 3 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Radius = {
                    label = "Contactnetwerk / Straat / Hotspots / 3 / Straal",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 3 / Straal.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Region = {
                    label = "Contactnetwerk / Straat / Hotspots / 3 / Regio",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 3 / Regio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3RobberyMultiplier = {
                    label = "Contactnetwerk / Straat / Hotspots / 3 / Overval / Vermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 3 / Overval / Vermenigvuldiger.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4AcceptBonus = {
                    label = "Contactnetwerk / Straat / Hotspots / 4 / Acceptatiebonus",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 4 / Acceptatiebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Archetype = {
                    label = "Contactnetwerk / Straat / Hotspots / 4 / Basistype",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 4 / Basistype.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsX = {
                    label = "Contactnetwerk / Straat / Hotspots / 4 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 4 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsY = {
                    label = "Contactnetwerk / Straat / Hotspots / 4 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 4 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsZ = {
                    label = "Contactnetwerk / Straat / Hotspots / 4 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 4 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4DemandBonus = {
                    label = "Contactnetwerk / Straat / Hotspots / 4 / Vraagbonus",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 4 / Vraagbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4HeatMultiplier = {
                    label = "Contactnetwerk / Straat / Hotspots / 4 / Politiedruk / Vermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 4 / Politiedruk / Vermenigvuldiger.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Id = {
                    label = "Contactnetwerk / Straat / Hotspots / 4 / ID",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 4 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Label = {
                    label = "Contactnetwerk / Straat / Hotspots / 4 / Naam",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 4 / Naam.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem1 = {
                    label = "Contactnetwerk / Straat / Hotspots / 4 / Voorkeursdrugs / 1",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 4 / Voorkeursdrugs / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem2 = {
                    label = "Contactnetwerk / Straat / Hotspots / 4 / Voorkeursdrugs / 2",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 4 / Voorkeursdrugs / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem3 = {
                    label = "Contactnetwerk / Straat / Hotspots / 4 / Voorkeursdrugs / 3",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 4 / Voorkeursdrugs / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PriceMultiplier = {
                    label = "Contactnetwerk / Straat / Hotspots / 4 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 4 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Radius = {
                    label = "Contactnetwerk / Straat / Hotspots / 4 / Straal",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 4 / Straal.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Region = {
                    label = "Contactnetwerk / Straat / Hotspots / 4 / Regio",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 4 / Regio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4RobberyMultiplier = {
                    label = "Contactnetwerk / Straat / Hotspots / 4 / Overval / Vermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 4 / Overval / Vermenigvuldiger.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5AcceptBonus = {
                    label = "Contactnetwerk / Straat / Hotspots / 5 / Acceptatiebonus",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 5 / Acceptatiebonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Archetype = {
                    label = "Contactnetwerk / Straat / Hotspots / 5 / Basistype",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 5 / Basistype.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsX = {
                    label = "Contactnetwerk / Straat / Hotspots / 5 / Coördinaten / X",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 5 / Coördinaten / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsY = {
                    label = "Contactnetwerk / Straat / Hotspots / 5 / Coördinaten / Y",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 5 / Coördinaten / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsZ = {
                    label = "Contactnetwerk / Straat / Hotspots / 5 / Coördinaten / Z",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 5 / Coördinaten / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5DemandBonus = {
                    label = "Contactnetwerk / Straat / Hotspots / 5 / Vraagbonus",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 5 / Vraagbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5HeatMultiplier = {
                    label = "Contactnetwerk / Straat / Hotspots / 5 / Politiedruk / Vermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 5 / Politiedruk / Vermenigvuldiger.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Id = {
                    label = "Contactnetwerk / Straat / Hotspots / 5 / ID",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 5 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Label = {
                    label = "Contactnetwerk / Straat / Hotspots / 5 / Naam",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 5 / Naam.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem1 = {
                    label = "Contactnetwerk / Straat / Hotspots / 5 / Voorkeursdrugs / 1",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 5 / Voorkeursdrugs / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem2 = {
                    label = "Contactnetwerk / Straat / Hotspots / 5 / Voorkeursdrugs / 2",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 5 / Voorkeursdrugs / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PriceMultiplier = {
                    label = "Contactnetwerk / Straat / Hotspots / 5 / Prijsvermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 5 / Prijsvermenigvuldiger.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Radius = {
                    label = "Contactnetwerk / Straat / Hotspots / 5 / Straal",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 5 / Straal.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Region = {
                    label = "Contactnetwerk / Straat / Hotspots / 5 / Regio",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 5 / Regio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5RobberyMultiplier = {
                    label = "Contactnetwerk / Straat / Hotspots / 5 / Overval / Vermenigvuldiger",
                    description = "Instelling voor Contactnetwerk / Straat / Hotspots / 5 / Overval / Vermenigvuldiger.",
                },
                drugAdvancedContactNetworkTrustLevelsKnown = {
                    label = "Contactnetwerk / Vertrouwen / Niveaus / Bekend",
                    description = "Instelling voor Contactnetwerk / Vertrouwen / Niveaus / Bekend.",
                },
                drugAdvancedContactNetworkTrustLevelsReliable = {
                    label = "Contactnetwerk / Vertrouwen / Niveaus / Betrouwbaar",
                    description = "Instelling voor Contactnetwerk / Vertrouwen / Niveaus / Betrouwbaar.",
                },
                drugAdvancedContactNetworkTrustLevelsTrusted = {
                    label = "Contactnetwerk / Vertrouwen / Niveaus / Vertrouwd",
                    description = "Instelling voor Contactnetwerk / Vertrouwen / Niveaus / Vertrouwd.",
                },
                drugAdvancedBusinessNetworkActionCooldownSeconds = {
                    label = "Bedrijfsnetwerk / Actie-cooldown / seconden",
                    description = "Instelling voor Bedrijfsnetwerk / Actie-cooldown / seconden.",
                },
                drugAdvancedBusinessNetworkBalanceBaseUnitPrice = {
                    label = "Bedrijfsnetwerk / Balans / Basiswaarde / Eenheidsprijs",
                    description = "Instelling voor Bedrijfsnetwerk / Balans / Basiswaarde / Eenheidsprijs.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerDealer = {
                    label = "Bedrijfsnetwerk / Balans / Netwerkhitte / Per dealer",
                    description = "Instelling voor Bedrijfsnetwerk / Balans / Netwerkhitte / Per dealer.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerHub = {
                    label = "Bedrijfsnetwerk / Balans / Netwerkhitte / Per distributiecentrum",
                    description = "Instelling voor Bedrijfsnetwerk / Balans / Netwerkhitte / Per distributiecentrum.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerRoute = {
                    label = "Bedrijfsnetwerk / Balans / Netwerkhitte / Per route",
                    description = "Instelling voor Bedrijfsnetwerk / Balans / Netwerkhitte / Per route.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerStaff = {
                    label = "Bedrijfsnetwerk / Balans / Netwerkhitte / Per werknemer",
                    description = "Instelling voor Bedrijfsnetwerk / Balans / Netwerkhitte / Per werknemer.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityGain = {
                    label = "Bedrijfsnetwerk / Balans / Betrouwbaarheid / winst",
                    description = "Instelling voor Bedrijfsnetwerk / Balans / Betrouwbaarheid / winst.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityLoss = {
                    label = "Bedrijfsnetwerk / Balans / Betrouwbaarheid / Verlies",
                    description = "Instelling voor Bedrijfsnetwerk / Balans / Betrouwbaarheid / Verlies.",
                },
                drugAdvancedBusinessNetworkBalanceRouteHeatDecay = {
                    label = "Bedrijfsnetwerk / Balans / Route / Politiedruk / Verval",
                    description = "Instelling voor Bedrijfsnetwerk / Balans / Route / Politiedruk / Verval.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / bende / Hoeveelheid / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / bende / Hoeveelheid / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / bende / Hoeveelheid / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / bende / Hoeveelheid / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangMinRank = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / bende / Minimum / Rang",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / bende / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / bende / Kwaliteit / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / bende / Kwaliteit / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / bende / Kwaliteit / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / bende / Kwaliteit / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / bende / Beloning / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / bende / Beloning / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / bende / Beloning / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / bende / Beloning / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / bende / Risico / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / bende / Risico / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / bende / Risico / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / bende / Risico / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Hoeveelheid / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Hoeveelheid / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Hoeveelheid / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Hoeveelheid / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkMinRank = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Minimum / Rang",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Kwaliteit / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Kwaliteit / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Kwaliteit / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Kwaliteit / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Beloning / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Beloning / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Beloning / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Beloning / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Risico / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Risico / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Risico / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / NPC-netwerk / Risico / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Hoeveelheid / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Hoeveelheid / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Hoeveelheid / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Hoeveelheid / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationMinRank = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Minimum / Rang",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Kwaliteit / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Kwaliteit / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Kwaliteit / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Kwaliteit / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Beloning / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Beloning / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Beloning / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Beloning / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Risico / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Risico / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Risico / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Organisatie / Risico / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Premium / Hoeveelheid / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Premium / Hoeveelheid / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Premium / Hoeveelheid / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Premium / Hoeveelheid / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumMinRank = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Premium / Minimum / Rang",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Premium / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Premium / Kwaliteit / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Premium / Kwaliteit / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Premium / Kwaliteit / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Premium / Kwaliteit / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Premium / Beloning / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Premium / Beloning / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Premium / Beloning / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Premium / Beloning / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Premium / Risico / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Premium / Risico / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Premium / Risico / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Premium / Risico / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Hoeveelheid / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Hoeveelheid / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Hoeveelheid / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Hoeveelheid / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherMinRank = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Minimum / Rang",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Kwaliteit / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Kwaliteit / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Kwaliteit / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Kwaliteit / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Beloning / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Beloning / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Beloning / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Beloning / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Risico / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Risico / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Risico / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Straatverkoper / Risico / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Hoeveelheid / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Hoeveelheid / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Hoeveelheid / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Hoeveelheid / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialMinRank = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Minimum / Rang",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Kwaliteit / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Kwaliteit / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Kwaliteit / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Kwaliteit / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Beloning / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Beloning / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Beloning / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Beloning / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Risico / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Risico / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Risico / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Speciaal / Risico / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Hoeveelheid / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Hoeveelheid / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Hoeveelheid / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Hoeveelheid / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleMinRank = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Minimum / Rang",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Minimum / Rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Kwaliteit / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Kwaliteit / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Kwaliteit / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Kwaliteit / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Beloning / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Beloning / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Beloning / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Beloning / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Risico / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Risico / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Risico / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Categorieën / Groothandel / Risico / 2.",
                },
                drugAdvancedBusinessNetworkContractsDeliveryDistance = {
                    label = "Bedrijfsnetwerk / Contracten / Afleverafstand",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Afleverafstand.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMax = {
                    label = "Bedrijfsnetwerk / Contracten / Duur / Minuten / Maximum",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Duur / Minuten / Maximum.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMin = {
                    label = "Bedrijfsnetwerk / Contracten / Duur / Minuten / Minimum",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Duur / Minuten / Minimum.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsX = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 1 / Coördinaten / X",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 1 / Coördinaten / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsY = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 1 / Coördinaten / Y",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 1 / Coördinaten / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsZ = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 1 / Coördinaten / Z",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 1 / Coördinaten / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Id = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 1 / ID",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 1 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Label = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 1 / Naam",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 1 / Naam.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Region = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 1 / Regio",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 1 / Regio.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1RewardMultiplier = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 1 / Beloning / Vermenigvuldiger",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 1 / Beloning / Vermenigvuldiger.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Risk = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 1 / Risico",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 1 / Risico.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsX = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 2 / Coördinaten / X",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 2 / Coördinaten / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsY = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 2 / Coördinaten / Y",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 2 / Coördinaten / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsZ = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 2 / Coördinaten / Z",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 2 / Coördinaten / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Id = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 2 / ID",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 2 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Label = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 2 / Naam",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 2 / Naam.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Region = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 2 / Regio",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 2 / Regio.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2RewardMultiplier = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 2 / Beloning / Vermenigvuldiger",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 2 / Beloning / Vermenigvuldiger.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Risk = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 2 / Risico",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 2 / Risico.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsX = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 3 / Coördinaten / X",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 3 / Coördinaten / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsY = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 3 / Coördinaten / Y",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 3 / Coördinaten / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsZ = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 3 / Coördinaten / Z",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 3 / Coördinaten / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Id = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 3 / ID",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 3 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Label = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 3 / Naam",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 3 / Naam.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Region = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 3 / Regio",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 3 / Regio.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3RewardMultiplier = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 3 / Beloning / Vermenigvuldiger",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 3 / Beloning / Vermenigvuldiger.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Risk = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 3 / Risico",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 3 / Risico.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsX = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 4 / Coördinaten / X",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 4 / Coördinaten / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsY = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 4 / Coördinaten / Y",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 4 / Coördinaten / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsZ = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 4 / Coördinaten / Z",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 4 / Coördinaten / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Id = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 4 / ID",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 4 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Label = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 4 / Naam",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 4 / Naam.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Region = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 4 / Regio",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 4 / Regio.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4RewardMultiplier = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 4 / Beloning / Vermenigvuldiger",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 4 / Beloning / Vermenigvuldiger.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Risk = {
                    label = "Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 4 / Risico",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Ontmoeting / Punten / 4 / Risico.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem1 = {
                    label = "Bedrijfsnetwerk / Contracten / Onderhandeling / Voorschot / Opties / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Onderhandeling / Voorschot / Opties / 1.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem2 = {
                    label = "Bedrijfsnetwerk / Contracten / Onderhandeling / Voorschot / Opties / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Onderhandeling / Voorschot / Opties / 2.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem3 = {
                    label = "Bedrijfsnetwerk / Contracten / Onderhandeling / Voorschot / Opties / 3",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Onderhandeling / Voorschot / Opties / 3.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAmountFlexPercent = {
                    label = "Bedrijfsnetwerk / Contracten / Onderhandeling / Hoeveelheid / Onderhandelingsruimte / Procent",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Onderhandeling / Hoeveelheid / Onderhandelingsruimte / Procent.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationBaseAcceptance = {
                    label = "Bedrijfsnetwerk / Contracten / Onderhandeling / Basiswaarde / Acceptatie",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Onderhandeling / Basiswaarde / Acceptatie.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationDeadlineFlexPercent = {
                    label = "Bedrijfsnetwerk / Contracten / Onderhandeling / Deadline / Onderhandelingsruimte / Procent",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Onderhandeling / Deadline / Onderhandelingsruimte / Procent.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationMaxRounds = {
                    label = "Bedrijfsnetwerk / Contracten / Onderhandeling / Maximum / Rondes",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Onderhandeling / Maximum / Rondes.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationQualityFlex = {
                    label = "Bedrijfsnetwerk / Contracten / Onderhandeling / Kwaliteit / Onderhandelingsruimte",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Onderhandeling / Kwaliteit / Onderhandelingsruimte.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRejectionCooldownMinutes = {
                    label = "Bedrijfsnetwerk / Contracten / Onderhandeling / Afwijzing / Afkoeltijd (minuten)",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Onderhandeling / Afwijzing / Afkoeltijd (minuten).",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRoundPressure = {
                    label = "Bedrijfsnetwerk / Contracten / Onderhandeling / Ronde / Druk",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Onderhandeling / Ronde / Druk.",
                },
                drugAdvancedBusinessNetworkContractsOfferCount = {
                    label = "Bedrijfsnetwerk / Contracten / Aanbod / Aantal",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Aanbod / Aantal.",
                },
                drugAdvancedBusinessNetworkContractsRefreshMinutes = {
                    label = "Bedrijfsnetwerk / Contracten / Verversing / Minuten",
                    description = "Instelling voor Bedrijfsnetwerk / Contracten / Verversing / Minuten.",
                },
                drugAdvancedBusinessNetworkDefaultBusinessName = {
                    label = "Bedrijfsnetwerk / Standaardwaarde / Bedrijfsnaam",
                    description = "Instelling voor Bedrijfsnetwerk / Standaardwaarde / Bedrijfsnaam.",
                },
                drugAdvancedBusinessNetworkDefaultRankId = {
                    label = "Bedrijfsnetwerk / Standaardwaarde / Rang / ID",
                    description = "Instelling voor Bedrijfsnetwerk / Standaardwaarde / Rang / ID.",
                },
                drugAdvancedBusinessNetworkDefaultStaffStyle = {
                    label = "Bedrijfsnetwerk / Standaardwaarde / Personeel / Werkwijze",
                    description = "Instelling voor Bedrijfsnetwerk / Standaardwaarde / Personeel / Werkwijze.",
                },
                drugAdvancedBusinessNetworkDefaultTransport = {
                    label = "Bedrijfsnetwerk / Standaardwaarde / Transport",
                    description = "Instelling voor Bedrijfsnetwerk / Standaardwaarde / Transport.",
                },
                drugAdvancedBusinessNetworkEnabled = {
                    label = "Bedrijfsnetwerk / Ingeschakeld",
                    description = "Instelling voor Bedrijfsnetwerk / Ingeschakeld.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterCapacity = {
                    label = "Bedrijfsnetwerk / Distributiecentra / Distributiecentrum / capaciteit",
                    description = "Instelling voor Bedrijfsnetwerk / Distributiecentra / Distributiecentrum / capaciteit.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterPurchasePrice = {
                    label = "Bedrijfsnetwerk / Distributiecentra / Distributiecentrum / Aankoopprijs",
                    description = "Instelling voor Bedrijfsnetwerk / Distributiecentra / Distributiecentrum / Aankoopprijs.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterSecurity = {
                    label = "Bedrijfsnetwerk / Distributiecentra / Distributiecentrum / Beveiliging",
                    description = "Instelling voor Bedrijfsnetwerk / Distributiecentra / Distributiecentrum / Beveiliging.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterUpkeep = {
                    label = "Bedrijfsnetwerk / Distributiecentra / Distributiecentrum / Onderhoud",
                    description = "Instelling voor Bedrijfsnetwerk / Distributiecentra / Distributiecentrum / Onderhoud.",
                },
                drugAdvancedBusinessNetworkHubsStashCapacity = {
                    label = "Bedrijfsnetwerk / Distributiecentra / Bergplaats / capaciteit",
                    description = "Instelling voor Bedrijfsnetwerk / Distributiecentra / Bergplaats / capaciteit.",
                },
                drugAdvancedBusinessNetworkHubsStashPurchasePrice = {
                    label = "Bedrijfsnetwerk / Distributiecentra / Bergplaats / Aankoopprijs",
                    description = "Instelling voor Bedrijfsnetwerk / Distributiecentra / Bergplaats / Aankoopprijs.",
                },
                drugAdvancedBusinessNetworkHubsStashSecurity = {
                    label = "Bedrijfsnetwerk / Distributiecentra / Bergplaats / Beveiliging",
                    description = "Instelling voor Bedrijfsnetwerk / Distributiecentra / Bergplaats / Beveiliging.",
                },
                drugAdvancedBusinessNetworkHubsStashUpkeep = {
                    label = "Bedrijfsnetwerk / Distributiecentra / Bergplaats / Onderhoud",
                    description = "Instelling voor Bedrijfsnetwerk / Distributiecentra / Bergplaats / Onderhoud.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseCapacity = {
                    label = "Bedrijfsnetwerk / Distributiecentra / Pakhuis / capaciteit",
                    description = "Instelling voor Bedrijfsnetwerk / Distributiecentra / Pakhuis / capaciteit.",
                },
                drugAdvancedBusinessNetworkHubsWarehousePurchasePrice = {
                    label = "Bedrijfsnetwerk / Distributiecentra / Pakhuis / Aankoopprijs",
                    description = "Instelling voor Bedrijfsnetwerk / Distributiecentra / Pakhuis / Aankoopprijs.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseSecurity = {
                    label = "Bedrijfsnetwerk / Distributiecentra / Pakhuis / Beveiliging",
                    description = "Instelling voor Bedrijfsnetwerk / Distributiecentra / Pakhuis / Beveiliging.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseUpkeep = {
                    label = "Bedrijfsnetwerk / Distributiecentra / Pakhuis / Onderhoud",
                    description = "Instelling voor Bedrijfsnetwerk / Distributiecentra / Pakhuis / Onderhoud.",
                },
                drugAdvancedBusinessNetworkLimitsActiveContracts = {
                    label = "Bedrijfsnetwerk / Limieten / Actieve contracten",
                    description = "Instelling voor Bedrijfsnetwerk / Limieten / Actieve contracten.",
                },
                drugAdvancedBusinessNetworkLimitsHubs = {
                    label = "Bedrijfsnetwerk / Limieten / Distributiecentra",
                    description = "Instelling voor Bedrijfsnetwerk / Limieten / Distributiecentra.",
                },
                drugAdvancedBusinessNetworkLimitsLedgerRows = {
                    label = "Bedrijfsnetwerk / Limieten / Grootboek / Rijen",
                    description = "Instelling voor Bedrijfsnetwerk / Limieten / Grootboek / Rijen.",
                },
                drugAdvancedBusinessNetworkLimitsRoutes = {
                    label = "Bedrijfsnetwerk / Limieten / Routes",
                    description = "Instelling voor Bedrijfsnetwerk / Limieten / Routes.",
                },
                drugAdvancedBusinessNetworkLimitsStaff = {
                    label = "Bedrijfsnetwerk / Limieten / Personeel",
                    description = "Instelling voor Bedrijfsnetwerk / Limieten / Personeel.",
                },
                drugAdvancedBusinessNetworkPayoutAccount = {
                    label = "Bedrijfsnetwerk / Uitbetaling / Rekening",
                    description = "Instelling voor Bedrijfsnetwerk / Uitbetaling / Rekening.",
                },
                drugAdvancedBusinessNetworkRanksItem1Contracts = {
                    label = "Bedrijfsnetwerk / Rangen / 1 / Contracten",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 1 / Contracten.",
                },
                drugAdvancedBusinessNetworkRanksItem1Dealers = {
                    label = "Bedrijfsnetwerk / Rangen / 1 / Dealers",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 1 / Dealers.",
                },
                drugAdvancedBusinessNetworkRanksItem1Hubs = {
                    label = "Bedrijfsnetwerk / Rangen / 1 / Distributiecentra",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 1 / Distributiecentra.",
                },
                drugAdvancedBusinessNetworkRanksItem1Id = {
                    label = "Bedrijfsnetwerk / Rangen / 1 / ID",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 1 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem1Label = {
                    label = "Bedrijfsnetwerk / Rangen / 1 / Naam",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 1 / Naam.",
                },
                drugAdvancedBusinessNetworkRanksItem1Routes = {
                    label = "Bedrijfsnetwerk / Rangen / 1 / Routes",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 1 / Routes.",
                },
                drugAdvancedBusinessNetworkRanksItem1Score = {
                    label = "Bedrijfsnetwerk / Rangen / 1 / Score",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 1 / Score.",
                },
                drugAdvancedBusinessNetworkRanksItem1Staff = {
                    label = "Bedrijfsnetwerk / Rangen / 1 / Personeel",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 1 / Personeel.",
                },
                drugAdvancedBusinessNetworkRanksItem2Contracts = {
                    label = "Bedrijfsnetwerk / Rangen / 2 / Contracten",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 2 / Contracten.",
                },
                drugAdvancedBusinessNetworkRanksItem2Dealers = {
                    label = "Bedrijfsnetwerk / Rangen / 2 / Dealers",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 2 / Dealers.",
                },
                drugAdvancedBusinessNetworkRanksItem2Hubs = {
                    label = "Bedrijfsnetwerk / Rangen / 2 / Distributiecentra",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 2 / Distributiecentra.",
                },
                drugAdvancedBusinessNetworkRanksItem2Id = {
                    label = "Bedrijfsnetwerk / Rangen / 2 / ID",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 2 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem2Label = {
                    label = "Bedrijfsnetwerk / Rangen / 2 / Naam",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 2 / Naam.",
                },
                drugAdvancedBusinessNetworkRanksItem2Routes = {
                    label = "Bedrijfsnetwerk / Rangen / 2 / Routes",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 2 / Routes.",
                },
                drugAdvancedBusinessNetworkRanksItem2Score = {
                    label = "Bedrijfsnetwerk / Rangen / 2 / Score",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 2 / Score.",
                },
                drugAdvancedBusinessNetworkRanksItem2Staff = {
                    label = "Bedrijfsnetwerk / Rangen / 2 / Personeel",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 2 / Personeel.",
                },
                drugAdvancedBusinessNetworkRanksItem3Contracts = {
                    label = "Bedrijfsnetwerk / Rangen / 3 / Contracten",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 3 / Contracten.",
                },
                drugAdvancedBusinessNetworkRanksItem3Dealers = {
                    label = "Bedrijfsnetwerk / Rangen / 3 / Dealers",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 3 / Dealers.",
                },
                drugAdvancedBusinessNetworkRanksItem3Hubs = {
                    label = "Bedrijfsnetwerk / Rangen / 3 / Distributiecentra",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 3 / Distributiecentra.",
                },
                drugAdvancedBusinessNetworkRanksItem3Id = {
                    label = "Bedrijfsnetwerk / Rangen / 3 / ID",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 3 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem3Label = {
                    label = "Bedrijfsnetwerk / Rangen / 3 / Naam",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 3 / Naam.",
                },
                drugAdvancedBusinessNetworkRanksItem3Routes = {
                    label = "Bedrijfsnetwerk / Rangen / 3 / Routes",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 3 / Routes.",
                },
                drugAdvancedBusinessNetworkRanksItem3Score = {
                    label = "Bedrijfsnetwerk / Rangen / 3 / Score",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 3 / Score.",
                },
                drugAdvancedBusinessNetworkRanksItem3Staff = {
                    label = "Bedrijfsnetwerk / Rangen / 3 / Personeel",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 3 / Personeel.",
                },
                drugAdvancedBusinessNetworkRanksItem4Contracts = {
                    label = "Bedrijfsnetwerk / Rangen / 4 / Contracten",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 4 / Contracten.",
                },
                drugAdvancedBusinessNetworkRanksItem4Dealers = {
                    label = "Bedrijfsnetwerk / Rangen / 4 / Dealers",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 4 / Dealers.",
                },
                drugAdvancedBusinessNetworkRanksItem4Hubs = {
                    label = "Bedrijfsnetwerk / Rangen / 4 / Distributiecentra",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 4 / Distributiecentra.",
                },
                drugAdvancedBusinessNetworkRanksItem4Id = {
                    label = "Bedrijfsnetwerk / Rangen / 4 / ID",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 4 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem4Label = {
                    label = "Bedrijfsnetwerk / Rangen / 4 / Naam",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 4 / Naam.",
                },
                drugAdvancedBusinessNetworkRanksItem4Routes = {
                    label = "Bedrijfsnetwerk / Rangen / 4 / Routes",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 4 / Routes.",
                },
                drugAdvancedBusinessNetworkRanksItem4Score = {
                    label = "Bedrijfsnetwerk / Rangen / 4 / Score",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 4 / Score.",
                },
                drugAdvancedBusinessNetworkRanksItem4Staff = {
                    label = "Bedrijfsnetwerk / Rangen / 4 / Personeel",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 4 / Personeel.",
                },
                drugAdvancedBusinessNetworkRanksItem5Contracts = {
                    label = "Bedrijfsnetwerk / Rangen / 5 / Contracten",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 5 / Contracten.",
                },
                drugAdvancedBusinessNetworkRanksItem5Dealers = {
                    label = "Bedrijfsnetwerk / Rangen / 5 / Dealers",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 5 / Dealers.",
                },
                drugAdvancedBusinessNetworkRanksItem5Hubs = {
                    label = "Bedrijfsnetwerk / Rangen / 5 / Distributiecentra",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 5 / Distributiecentra.",
                },
                drugAdvancedBusinessNetworkRanksItem5Id = {
                    label = "Bedrijfsnetwerk / Rangen / 5 / ID",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 5 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem5Label = {
                    label = "Bedrijfsnetwerk / Rangen / 5 / Naam",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 5 / Naam.",
                },
                drugAdvancedBusinessNetworkRanksItem5Routes = {
                    label = "Bedrijfsnetwerk / Rangen / 5 / Routes",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 5 / Routes.",
                },
                drugAdvancedBusinessNetworkRanksItem5Score = {
                    label = "Bedrijfsnetwerk / Rangen / 5 / Score",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 5 / Score.",
                },
                drugAdvancedBusinessNetworkRanksItem5Staff = {
                    label = "Bedrijfsnetwerk / Rangen / 5 / Personeel",
                    description = "Instelling voor Bedrijfsnetwerk / Rangen / 5 / Personeel.",
                },
                drugAdvancedBusinessNetworkReportDays = {
                    label = "Bedrijfsnetwerk / Rapportperiode / dagen",
                    description = "Instelling voor Bedrijfsnetwerk / Rapportperiode / dagen.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesBuyer = {
                    label = "Bedrijfsnetwerk / Route / Eindpunt / Typen / Koper",
                    description = "Instelling voor Bedrijfsnetwerk / Route / Eindpunt / Typen / Koper.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesContract = {
                    label = "Bedrijfsnetwerk / Route / Eindpunt / Typen / Contract",
                    description = "Instelling voor Bedrijfsnetwerk / Route / Eindpunt / Typen / Contract.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesDealer = {
                    label = "Bedrijfsnetwerk / Route / Eindpunt / Typen / Handelaar",
                    description = "Instelling voor Bedrijfsnetwerk / Route / Eindpunt / Typen / Handelaar.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesGang = {
                    label = "Bedrijfsnetwerk / Route / Eindpunt / Typen / bende",
                    description = "Instelling voor Bedrijfsnetwerk / Route / Eindpunt / Typen / bende.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesHub = {
                    label = "Bedrijfsnetwerk / Route / Eindpunt / Typen / Distributiecentrum",
                    description = "Instelling voor Bedrijfsnetwerk / Route / Eindpunt / Typen / Distributiecentrum.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesLab = {
                    label = "Bedrijfsnetwerk / Route / Eindpunt / Typen / Lab",
                    description = "Instelling voor Bedrijfsnetwerk / Route / Eindpunt / Typen / Lab.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesOrganization = {
                    label = "Bedrijfsnetwerk / Route / Eindpunt / Typen / Organisatie",
                    description = "Instelling voor Bedrijfsnetwerk / Route / Eindpunt / Typen / Organisatie.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesPusher = {
                    label = "Bedrijfsnetwerk / Route / Eindpunt / Typen / Straatverkoper",
                    description = "Instelling voor Bedrijfsnetwerk / Route / Eindpunt / Typen / Straatverkoper.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMax = {
                    label = "Bedrijfsnetwerk / Spelwerking / Contract / Frequentie / Minuten / Maximum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Contract / Frequentie / Minuten / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMin = {
                    label = "Bedrijfsnetwerk / Spelwerking / Contract / Frequentie / Minuten / Minimum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Contract / Frequentie / Minuten / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCooldownMinimumMinutes = {
                    label = "Bedrijfsnetwerk / Spelwerking / Contract / Wachttijd / Minimum / Minuten",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Contract / Wachttijd / Minimum / Minuten.",
                },
                drugAdvancedBusinessNetworkRuntimeContractFailureReliabilityLoss = {
                    label = "Bedrijfsnetwerk / Spelwerking / Contract / Mislukking / Betrouwbaarheid / Verlies",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Contract / Mislukking / Betrouwbaarheid / Verlies.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumCadenceMinutes = {
                    label = "Bedrijfsnetwerk / Spelwerking / Contract / Minimum / Frequentie / Minuten",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Contract / Minimum / Frequentie / Minuten.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumMeetingMultiplier = {
                    label = "Bedrijfsnetwerk / Spelwerking / Contract / Minimum / Ontmoeting / Vermenigvuldiger",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Contract / Minimum / Ontmoeting / Vermenigvuldiger.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyGrowth = {
                    label = "Bedrijfsnetwerk / Spelwerking / Contractboete / Groei",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Contractboete / Groei.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyMultiplier = {
                    label = "Bedrijfsnetwerk / Spelwerking / Contractboete / Vermenigvuldiger",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Contractboete / Vermenigvuldiger.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityFailureCooldownMinutes = {
                    label = "Bedrijfsnetwerk / Spelwerking / Contract / Kwaliteit / Mislukking / Afkoeltijd (minuten)",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Contract / Kwaliteit / Mislukking / Afkoeltijd (minuten).",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceBase = {
                    label = "Bedrijfsnetwerk / Spelwerking / Contract / Kwaliteit / Prijs / Basiswaarde",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Contract / Kwaliteit / Prijs / Basiswaarde.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceDivisor = {
                    label = "Bedrijfsnetwerk / Spelwerking / Contract / Kwaliteit / Prijs / Deler",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Contract / Kwaliteit / Prijs / Deler.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossBase = {
                    label = "Bedrijfsnetwerk / Spelwerking / Contract / Betrouwbaarheid / Verlies / Basiswaarde",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Contract / Betrouwbaarheid / Verlies / Basiswaarde.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossMaximum = {
                    label = "Bedrijfsnetwerk / Spelwerking / Contract / Betrouwbaarheid / Verlies / Maximum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Contract / Betrouwbaarheid / Verlies / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossQualityWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Contract / Betrouwbaarheid / Verlies / Kwaliteit / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Contract / Betrouwbaarheid / Verlies / Kwaliteit / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReputationQualityWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Contract / Reputatie / Kwaliteit / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Contract / Reputatie / Kwaliteit / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsCategory = {
                    label = "Bedrijfsnetwerk / Spelwerking / Contract / Risico / Wegingen / Categorie",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Contract / Risico / Wegingen / Categorie.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsMeeting = {
                    label = "Bedrijfsnetwerk / Spelwerking / Contract / Risico / Wegingen / Ontmoeting",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Contract / Risico / Wegingen / Ontmoeting.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubCapacity = {
                    label = "Bedrijfsnetwerk / Spelwerking / Standaardwaarde / Distributiecentrum / capaciteit",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Standaardwaarde / Distributiecentrum / capaciteit.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubSecurity = {
                    label = "Bedrijfsnetwerk / Spelwerking / Standaardwaarde / Distributiecentrum / Beveiliging",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Standaardwaarde / Distributiecentrum / Beveiliging.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultMeetingRisk = {
                    label = "Bedrijfsnetwerk / Spelwerking / Standaardwaarde / Ontmoeting / Risico",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Standaardwaarde / Ontmoeting / Risico.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultQuality = {
                    label = "Bedrijfsnetwerk / Spelwerking / Standaardwaarde / Kwaliteit",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Standaardwaarde / Kwaliteit.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteCapacity = {
                    label = "Bedrijfsnetwerk / Spelwerking / Standaardwaarde / Routecapaciteit",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Standaardwaarde / Routecapaciteit.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteIntervalMinutes = {
                    label = "Bedrijfsnetwerk / Spelwerking / Standaardwaarde / Route / Interval / Minuten",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Standaardwaarde / Route / Interval / Minuten.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteRisk = {
                    label = "Bedrijfsnetwerk / Spelwerking / Standaardwaarde / Route / Risico",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Standaardwaarde / Route / Risico.",
                },
                drugAdvancedBusinessNetworkRuntimeHubHeatDecay = {
                    label = "Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Politiedruk / Verval",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Politiedruk / Verval.",
                },
                drugAdvancedBusinessNetworkRuntimeHubLoadHeat = {
                    label = "Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Belasting / Politiedruk",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Belasting / Politiedruk.",
                },
                drugAdvancedBusinessNetworkRuntimeHubRaidRecoveryMinutes = {
                    label = "Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Overval / Herstel / Minuten",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Overval / Herstel / Minuten.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostBase = {
                    label = "Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Beveiliging / Kosten / Basiswaarde",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Beveiliging / Kosten / Basiswaarde.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostPerLevel = {
                    label = "Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Beveiliging / Kosten / Per niveau",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Beveiliging / Kosten / Per niveau.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityMaximum = {
                    label = "Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Beveiliging / Maximum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Beveiliging / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityUpgrade = {
                    label = "Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Beveiliging / Verbetering",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Beveiliging / Verbetering.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidHeat = {
                    label = "Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Wanbetaling / Politiedruk",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Wanbetaling / Politiedruk.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidSecurityLoss = {
                    label = "Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Wanbetaling / Beveiliging / Verlies",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Wanbetaling / Beveiliging / Verlies.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUpkeepIntervalHours = {
                    label = "Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Onderhoud / Interval / Uren",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Distributiecentrum / Onderhoud / Interval / Uren.",
                },
                drugAdvancedBusinessNetworkRuntimeInitialReliability = {
                    label = "Bedrijfsnetwerk / Spelwerking / Beginwaarde / Betrouwbaarheid",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Beginwaarde / Betrouwbaarheid.",
                },
                drugAdvancedBusinessNetworkRuntimeMaximumBusinessNameLength = {
                    label = "Bedrijfsnetwerk / Spelwerking / Maximum / Bedrijfsnaam / Lengte",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Maximum / Bedrijfsnaam / Lengte.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumContractDeliveryMinutes = {
                    label = "Bedrijfsnetwerk / Spelwerking / Minimum / Contract / Aflevering / Minuten",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Minimum / Contract / Aflevering / Minuten.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumDeliveryDistance = {
                    label = "Bedrijfsnetwerk / Spelwerking / Minimum / Afleverafstand",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Minimum / Afleverafstand.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumLedgerRows = {
                    label = "Bedrijfsnetwerk / Spelwerking / Minimum / Grootboek / Rijen",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Minimum / Grootboek / Rijen.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumRouteIntervalMinutes = {
                    label = "Bedrijfsnetwerk / Spelwerking / Minimum / Route / Interval / Minuten",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Minimum / Route / Interval / Minuten.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvanceCostWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Voorschot / Kosten / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Voorschot / Kosten / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvancePriceWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Voorschot / Prijs / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Voorschot / Prijs / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountCostWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Hoeveelheid / Kosten / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Hoeveelheid / Kosten / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountFlexMaximum = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Hoeveelheid / Onderhandelingsruimte / Maximum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Hoeveelheid / Onderhandelingsruimte / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountRiskWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Hoeveelheid / Risico / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Hoeveelheid / Risico / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationCounterOfferWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Tegenbod / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Tegenbod / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationDeadlineFlexMaximum = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Deadline / Onderhandelingsruimte / Maximum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Deadline / Onderhandelingsruimte / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMaximumAcceptance = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Maximum / Acceptatie",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Maximum / Acceptatie.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMinimumAcceptance = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Minimum / Acceptatie",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Minimum / Acceptatie.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityBenefitWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Kwaliteit / Voordeel / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Kwaliteit / Voordeel / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityCostWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Kwaliteit / Kosten / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Kwaliteit / Kosten / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityFlexMaximum = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Kwaliteit / Onderhandelingsruimte / Maximum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Kwaliteit / Onderhandelingsruimte / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityRewardWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Kwaliteit / Beloning / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Kwaliteit / Beloning / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReliabilityWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Betrouwbaarheid / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Betrouwbaarheid / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReputationWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Reputatie / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Reputatie / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMax = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Gevraagde beloning / Maximum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Gevraagde beloning / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMin = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Gevraagde beloning / Minimum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Gevraagde beloning / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardCostWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Beloning / Kosten / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Beloning / Kosten / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMax = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Beloning / Maximum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Beloning / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMin = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Beloning / Minimum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Beloning / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBase = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Urgentie / Basiswaarde",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Urgentie / Basiswaarde.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBenefitWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Urgentie / Voordeel / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Urgentie / Voordeel / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyRiskWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Urgentie / Risico / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Urgentie / Risico / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Onderhandeling / Urgentie / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Onderhandeling / Urgentie / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeOtherFailureHeat = {
                    label = "Bedrijfsnetwerk / Spelwerking / Andere / Mislukking / Politiedruk",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Andere / Mislukking / Politiedruk.",
                },
                drugAdvancedBusinessNetworkRuntimePersonalHeatWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Persoonlijke heat / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Persoonlijke heat / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimePoliceFailureHeat = {
                    label = "Bedrijfsnetwerk / Spelwerking / Politie / Mislukking / Politiedruk",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Politie / Mislukking / Politiedruk.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBaseUnits = {
                    label = "Bedrijfsnetwerk / Spelwerking / Straatverkoper / Basiswaarde / eenheden",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Straatverkoper / Basiswaarde / eenheden.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBulkMultiplier = {
                    label = "Bedrijfsnetwerk / Spelwerking / Straatverkoper / Grote hoeveelheid / Vermenigvuldiger",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Straatverkoper / Grote hoeveelheid / Vermenigvuldiger.",
                },
                drugAdvancedBusinessNetworkRuntimePusherCheapMultiplier = {
                    label = "Bedrijfsnetwerk / Spelwerking / Straatverkoper / Goedkope verkopen / Vermenigvuldiger",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Straatverkoper / Goedkope verkopen / Vermenigvuldiger.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerLevel = {
                    label = "Bedrijfsnetwerk / Spelwerking / Straatverkoper / Ervaring / Per niveau",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Straatverkoper / Ervaring / Per niveau.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerUnit = {
                    label = "Bedrijfsnetwerk / Spelwerking / Straatverkoper / Ervaring / Per eenheid",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Straatverkoper / Ervaring / Per eenheid.",
                },
                drugAdvancedBusinessNetworkRuntimePusherHubHeatPerUnit = {
                    label = "Bedrijfsnetwerk / Spelwerking / Straatverkoper / Distributiecentrum / Politiedruk / Per eenheid",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Straatverkoper / Distributiecentrum / Politiedruk / Per eenheid.",
                },
                drugAdvancedBusinessNetworkRuntimePusherPremiumMultiplier = {
                    label = "Bedrijfsnetwerk / Spelwerking / Straatverkoper / Premium / Vermenigvuldiger",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Straatverkoper / Premium / Vermenigvuldiger.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillDivisor = {
                    label = "Bedrijfsnetwerk / Spelwerking / Straatverkoper / Vaardigheid / Deler",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Straatverkoper / Vaardigheid / Deler.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillGain = {
                    label = "Bedrijfsnetwerk / Spelwerking / Straatverkoper / Vaardigheid / winst",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Straatverkoper / Vaardigheid / winst.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationBaseSeconds = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Duur / Basiswaarde / seconden",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Duur / Basiswaarde / seconden.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationPerUnitSeconds = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Duur / Per eenheid / seconden",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Duur / Per eenheid / seconden.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem1 = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Mislukking / Oorzaken / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Mislukking / Oorzaken / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem2 = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Mislukking / Oorzaken / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Mislukking / Oorzaken / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem3 = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Mislukking / Oorzaken / 3",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Mislukking / Oorzaken / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem4 = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Mislukking / Oorzaken / 4",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Mislukking / Oorzaken / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureValueMultiplier = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Mislukking / Value / Vermenigvuldiger",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Mislukking / Value / Vermenigvuldiger.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatAmountDivisor = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Politiedruk / Hoeveelheid / Deler",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Politiedruk / Hoeveelheid / Deler.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostBase = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Heat-reductie / Kosten / Basiswaarde",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Heat-reductie / Kosten / Basiswaarde.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostPerHeat = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Heat-reductie / Kosten / Per aandachtspunt",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Heat-reductie / Kosten / Per aandachtspunt.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMaximum = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Risico / Maximum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Risico / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMinimum = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Risico / Minimum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Risico / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsHeat = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Risico / Wegingen / Politiedruk",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Risico / Wegingen / Politiedruk.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsLoyalty = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Risico / Wegingen / Loyaliteit",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Risico / Wegingen / Loyaliteit.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsRunnerRisk = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Risico / Wegingen / Koerier / Risico",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Risico / Wegingen / Koerier / Risico.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsSkill = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Risico / Wegingen / Vaardigheid",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Risico / Wegingen / Vaardigheid.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationHeatReduction = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route rotatie / Heat-reductie",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route rotatie / Heat-reductie.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationRiskReduction = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route rotatie / Risico / Vermindering",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route rotatie / Risico / Vermindering.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityBase = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Verkoop / Basiskwaliteit",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Verkoop / Basiskwaliteit.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityDivisor = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Verkoop / Kwaliteit / Deler",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Verkoop / Kwaliteit / Deler.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleRiskDivisor = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Verkoop / Risico / Deler",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Verkoop / Risico / Deler.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteStartHeat = {
                    label = "Bedrijfsnetwerk / Spelwerking / Route / Begin / Politiedruk",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Route / Begin / Politiedruk.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerLevel = {
                    label = "Bedrijfsnetwerk / Spelwerking / Koerier / Ervaring / Per niveau",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Koerier / Ervaring / Per niveau.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerUnit = {
                    label = "Bedrijfsnetwerk / Spelwerking / Koerier / Ervaring / Per eenheid",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Koerier / Ervaring / Per eenheid.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureLoyaltyLoss = {
                    label = "Bedrijfsnetwerk / Spelwerking / Koerier / Mislukking / Loyaliteit / Verlies",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Koerier / Mislukking / Loyaliteit / Verlies.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureRiskGain = {
                    label = "Bedrijfsnetwerk / Spelwerking / Koerier / Faalrisico / winst",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Koerier / Faalrisico / winst.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerSkillGain = {
                    label = "Bedrijfsnetwerk / Spelwerking / Koerier / Vaardigheid / winst",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Koerier / Vaardigheid / winst.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsHeat = {
                    label = "Bedrijfsnetwerk / Spelwerking / Score / Wegingen / Politiedruk",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Score / Wegingen / Politiedruk.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReliability = {
                    label = "Bedrijfsnetwerk / Spelwerking / Score / Wegingen / Betrouwbaarheid",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Score / Wegingen / Betrouwbaarheid.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReputation = {
                    label = "Bedrijfsnetwerk / Spelwerking / Score / Wegingen / Reputatie",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Score / Wegingen / Reputatie.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsStructure = {
                    label = "Bedrijfsnetwerk / Spelwerking / Score / Wegingen / Structuur",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Score / Wegingen / Structuur.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffCapacityBaseMultiplier = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / capaciteit / Basiswaarde / Vermenigvuldiger",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / capaciteit / Basiswaarde / Vermenigvuldiger.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMax = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Aanwerving / Loyaliteit / Maximum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Aanwerving / Loyaliteit / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMin = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Aanwerving / Loyaliteit / Minimum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Aanwerving / Loyaliteit / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMax = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Aanwerving / Risico / Maximum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Aanwerving / Risico / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMin = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Aanwerving / Risico / Minimum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Aanwerving / Risico / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMax = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Aanwerving / Vaardigheid / Maximum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Aanwerving / Vaardigheid / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMin = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Aanwerving / Vaardigheid / Minimum",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Aanwerving / Vaardigheid / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentLoyaltyWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Incident / Loyaliteit / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Incident / Loyaliteit / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentMaximumChance = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Incident / Maximum / Kans",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Incident / Maximum / Kans.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem1 = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Incident / Uitkomsten / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Incident / Uitkomsten / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem2 = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Incident / Uitkomsten / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Incident / Uitkomsten / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem3 = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Incident / Uitkomsten / 3",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Incident / Uitkomsten / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem4 = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Incident / Uitkomsten / 4",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Incident / Uitkomsten / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentRiskWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Incident / Risico / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Incident / Risico / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffLoyaltyDecay = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Loyaliteit / Verval",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Loyaliteit / Verval.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffMaximumLevel = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Maximum / Niveau",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Maximum / Niveau.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffPoachedLoyaltyLoss = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Loyaliteitsverlies door wegkapen",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Loyaliteitsverlies door wegkapen.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionCostBase = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Bescherming / Kosten / Basiswaarde",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Bescherming / Kosten / Basiswaarde.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionHours = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Bescherming / Uren",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Bescherming / Uren.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionIncidentReduction = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Bescherming / Incident / Vermindering",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Bescherming / Incident / Vermindering.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionRiskCost = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Bescherming / Risico / Kosten",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Bescherming / Risico / Kosten.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryBaseChance = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Herstel / Basiswaarde / Kans",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Herstel / Basiswaarde / Kans.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryLoyaltyWeight = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Herstel / Loyaliteit / Gewicht",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Herstel / Loyaliteit / Gewicht.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageBaseMultiplier = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Loon / Basiswaarde / Vermenigvuldiger",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Loon / Basiswaarde / Vermenigvuldiger.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageLoyaltyGain = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Loon / Loyaliteit / winst",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Loon / Loyaliteit / winst.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageSkillDivisor = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Loon / Vaardigheid / Deler",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Loon / Vaardigheid / Deler.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem1 = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Zwakke punten / 1",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Zwakke punten / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem2 = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Zwakke punten / 2",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Zwakke punten / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem3 = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Zwakke punten / 3",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Zwakke punten / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem4 = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Zwakke punten / 4",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Zwakke punten / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem5 = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Zwakke punten / 5",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Zwakke punten / 5.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem6 = {
                    label = "Bedrijfsnetwerk / Spelwerking / Personeel / Zwakke punten / 6",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Personeel / Zwakke punten / 6.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsContracts = {
                    label = "Bedrijfsnetwerk / Spelwerking / Structuur / Wegingen / Contracten",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Structuur / Wegingen / Contracten.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsDealers = {
                    label = "Bedrijfsnetwerk / Spelwerking / Structuur / Wegingen / Dealers",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Structuur / Wegingen / Dealers.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsHubs = {
                    label = "Bedrijfsnetwerk / Spelwerking / Structuur / Wegingen / Distributiecentra",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Structuur / Wegingen / Distributiecentra.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsRoutes = {
                    label = "Bedrijfsnetwerk / Spelwerking / Structuur / Wegingen / Routes",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Structuur / Wegingen / Routes.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsStaff = {
                    label = "Bedrijfsnetwerk / Spelwerking / Structuur / Wegingen / Personeel",
                    description = "Instelling voor Bedrijfsnetwerk / Spelwerking / Structuur / Wegingen / Personeel.",
                },
                drugAdvancedBusinessNetworkSocietyPermission = {
                    label = "Bedrijfsnetwerk / Organisatie / Toestemming",
                    description = "Instelling voor Bedrijfsnetwerk / Organisatie / Toestemming.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseCapacity = {
                    label = "Bedrijfsnetwerk / Personeel / Straatverkoper / Basiswaarde / capaciteit",
                    description = "Instelling voor Bedrijfsnetwerk / Personeel / Straatverkoper / Basiswaarde / capaciteit.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseWage = {
                    label = "Bedrijfsnetwerk / Personeel / Straatverkoper / Basiswaarde / Loon",
                    description = "Instelling voor Bedrijfsnetwerk / Personeel / Straatverkoper / Basiswaarde / Loon.",
                },
                drugAdvancedBusinessNetworkStaffPusherCommission = {
                    label = "Bedrijfsnetwerk / Personeel / Straatverkoper / Commissie",
                    description = "Instelling voor Bedrijfsnetwerk / Personeel / Straatverkoper / Commissie.",
                },
                drugAdvancedBusinessNetworkStaffPusherHirePrice = {
                    label = "Bedrijfsnetwerk / Personeel / Straatverkoper / Aanwerving / Prijs",
                    description = "Instelling voor Bedrijfsnetwerk / Personeel / Straatverkoper / Aanwerving / Prijs.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseCapacity = {
                    label = "Bedrijfsnetwerk / Personeel / Koerier / Basiswaarde / capaciteit",
                    description = "Instelling voor Bedrijfsnetwerk / Personeel / Koerier / Basiswaarde / capaciteit.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseWage = {
                    label = "Bedrijfsnetwerk / Personeel / Koerier / Basiswaarde / Loon",
                    description = "Instelling voor Bedrijfsnetwerk / Personeel / Koerier / Basiswaarde / Loon.",
                },
                drugAdvancedBusinessNetworkStaffRunnerCommission = {
                    label = "Bedrijfsnetwerk / Personeel / Koerier / Commissie",
                    description = "Instelling voor Bedrijfsnetwerk / Personeel / Koerier / Commissie.",
                },
                drugAdvancedBusinessNetworkStaffRunnerHirePrice = {
                    label = "Bedrijfsnetwerk / Personeel / Koerier / Aanwerving / Prijs",
                    description = "Instelling voor Bedrijfsnetwerk / Personeel / Koerier / Aanwerving / Prijs.",
                },
                drugAdvancedBusinessNetworkTickMinutes = {
                    label = "Bedrijfsnetwerk / Updatecyclus / Minuten",
                    description = "Instelling voor Bedrijfsnetwerk / Updatecyclus / Minuten.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCapacity = {
                    label = "Bedrijfsnetwerk / Transporten / Vliegtuig / capaciteit",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Vliegtuig / capaciteit.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCost = {
                    label = "Bedrijfsnetwerk / Transporten / Vliegtuig / Kosten",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Vliegtuig / Kosten.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftDurationMultiplier = {
                    label = "Bedrijfsnetwerk / Transporten / Vliegtuig / Duur-multiplier",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Vliegtuig / Duur-multiplier.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftRisk = {
                    label = "Bedrijfsnetwerk / Transporten / Vliegtuig / Risico",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Vliegtuig / Risico.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCapacity = {
                    label = "Bedrijfsnetwerk / Transporten / Boot / capaciteit",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Boot / capaciteit.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCost = {
                    label = "Bedrijfsnetwerk / Transporten / Boot / Kosten",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Boot / Kosten.",
                },
                drugAdvancedBusinessNetworkTransportsBoatDurationMultiplier = {
                    label = "Bedrijfsnetwerk / Transporten / Boot / Duur-multiplier",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Boot / Duur-multiplier.",
                },
                drugAdvancedBusinessNetworkTransportsBoatRisk = {
                    label = "Bedrijfsnetwerk / Transporten / Boot / Risico",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Boot / Risico.",
                },
                drugAdvancedBusinessNetworkTransportsCarCapacity = {
                    label = "Bedrijfsnetwerk / Transporten / Auto / capaciteit",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Auto / capaciteit.",
                },
                drugAdvancedBusinessNetworkTransportsCarCost = {
                    label = "Bedrijfsnetwerk / Transporten / Auto / Kosten",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Auto / Kosten.",
                },
                drugAdvancedBusinessNetworkTransportsCarDurationMultiplier = {
                    label = "Bedrijfsnetwerk / Transporten / Auto / Duur-multiplier",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Auto / Duur-multiplier.",
                },
                drugAdvancedBusinessNetworkTransportsCarRisk = {
                    label = "Bedrijfsnetwerk / Transporten / Auto / Risico",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Auto / Risico.",
                },
                drugAdvancedBusinessNetworkTransportsFootCapacity = {
                    label = "Bedrijfsnetwerk / Transporten / Te voet / capaciteit",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Te voet / capaciteit.",
                },
                drugAdvancedBusinessNetworkTransportsFootCost = {
                    label = "Bedrijfsnetwerk / Transporten / Te voet / Kosten",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Te voet / Kosten.",
                },
                drugAdvancedBusinessNetworkTransportsFootDurationMultiplier = {
                    label = "Bedrijfsnetwerk / Transporten / Te voet / Duur-multiplier",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Te voet / Duur-multiplier.",
                },
                drugAdvancedBusinessNetworkTransportsFootRisk = {
                    label = "Bedrijfsnetwerk / Transporten / Te voet / Risico",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Te voet / Risico.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCapacity = {
                    label = "Bedrijfsnetwerk / Transporten / Vrachtwagen / capaciteit",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Vrachtwagen / capaciteit.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCost = {
                    label = "Bedrijfsnetwerk / Transporten / Vrachtwagen / Kosten",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Vrachtwagen / Kosten.",
                },
                drugAdvancedBusinessNetworkTransportsTruckDurationMultiplier = {
                    label = "Bedrijfsnetwerk / Transporten / Vrachtwagen / Duur-multiplier",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Vrachtwagen / Duur-multiplier.",
                },
                drugAdvancedBusinessNetworkTransportsTruckRisk = {
                    label = "Bedrijfsnetwerk / Transporten / Vrachtwagen / Risico",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Vrachtwagen / Risico.",
                },
                drugAdvancedBusinessNetworkTransportsVanCapacity = {
                    label = "Bedrijfsnetwerk / Transporten / Bestelwagen / capaciteit",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Bestelwagen / capaciteit.",
                },
                drugAdvancedBusinessNetworkTransportsVanCost = {
                    label = "Bedrijfsnetwerk / Transporten / Bestelwagen / Kosten",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Bestelwagen / Kosten.",
                },
                drugAdvancedBusinessNetworkTransportsVanDurationMultiplier = {
                    label = "Bedrijfsnetwerk / Transporten / Bestelwagen / Duur-multiplier",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Bestelwagen / Duur-multiplier.",
                },
                drugAdvancedBusinessNetworkTransportsVanRisk = {
                    label = "Bedrijfsnetwerk / Transporten / Bestelwagen / Risico",
                    description = "Instelling voor Bedrijfsnetwerk / Transporten / Bestelwagen / Risico.",
                },
                interrogationDispatchAdapter = {
                    options = {
                        sky_jobs_base = "Sky Jobs Base",
                        generic = "Algemene integratie",
                        custom = "Eigen integratie",
                        none = "Uitgeschakeld",
                    },
                },
                reputationRules = {
                    label = "Reputatieregels",
                    description = "Stel benoemde regels in voor acties en optionele doelen. Alleen ingeschakelde regels geven punten.",
                },
            },
            territoryMap = {
                addPoint = "Punt toevoegen",
                clear = "Wissen",
                create = "Maak aan",
                custom = "Eigen territoria",
                deletePoint = "Punt verwijderen",
                eyebrow = "Territorium-editor",
                minimum = "Minimaal 3",
                pointCount = "{count} punten",
                presets = "Standaarddistricten",
                shown = "Tonen op kaart",
                street = "Straat",
                supply = "Levering",
                territories = "Gebieden",
                type = "Territoriumtype",
                undo = "Ongedaan maken",
            },
            shopPositionTools = {
                currentPosition = "Huidige positie gebruiken",
                selectEntity = "Object selecteren",
                selectEntityHint = "Richt de laser op een kassa of kluis. Enter: gebruik de positie en koers van het omlijnde object. Backspace: annuleren.",
            },
            drugSettingSubsections = {
                cultivationLevels = "Kweekniveaus",
                general = "Algemeen",
                runtime = "Toegang tot spelacties",
                quality = "Kwaliteit",
                packaging = "Verpakking",
                growing = "Teelt",
                labs = "Labs en campers",
                power = "Stroom en apparatuur",
                workers = "Medewerkers",
                market = "Markt en distributie",
                threats = "Invallen en sabotage",
                pvpTakeovers = "Laboratoriumovernames",
                consumption = "Gebruik",
                processing = "Verwerking",
                performance = "Prestaties",
                dynamicMarket = "Dynamische Markt",
                heat = "Politieaandacht en risico",
                contacts = "Contactnetwerk",
                business = "Bedrijfsnetwerk",
            },
            drugSettingGroups = {
                cultivationGeneral = { label = "Algemeen" },
                cultivationCurve = { label = "Niveaucurve" },
                cultivationExperience = { label = "XP-beloningen" },
                cultivationUnlocks = { label = "Niveau-ontgrendelingen" },
                creator = {
                    label = "Editor openen",
                },
                creatorSettings = {
                    label = "Editorinstellingen",
                },
                interfaceHud = {
                    label = "Interfaceposities",
                },
                drugsGeneral = {
                    label = "Algemeen",
                },
                runtimeAccess = {
                    label = "Toegang en eigendom",
                },
                runtimePayouts = {
                    label = "Uitbetalingen",
                },
                runtimeDispatch = {
                    label = "Meldkamer en politie",
                },
                qualityWeights = {
                    label = "Kwaliteit / Wegingen",
                },
                qualityTiers = {
                    label = "Kwaliteit / Kwaliteitsniveaus",
                },
                packagingGeneral = {
                    label = "Algemeen",
                },
                growingGeneral = {
                    label = "Algemeen",
                },
                plantDefaults = {
                    label = "Plant / Standaardwaarden",
                },
                harvestWindow = {
                    label = "Oogsten / Tijdvenster",
                },
                labsGeneral = {
                    label = "Algemeen",
                },
                labRent = {
                    label = "Huur en levenscyclus",
                },
                camperDefaults = {
                    label = "Camper",
                },
                labUpgrades = {
                    label = "Verbeteringen",
                },
                labDefaults = {
                    label = "Lab / Standaardwaarden",
                },
                powerGeneral = {
                    label = "Algemeen",
                },
                generators = {
                    label = "Generatoren",
                },
                equipmentWear = {
                    label = "Apparatuur",
                },
                workersGeneral = {
                    label = "Algemeen",
                },
                marketGeneral = {
                    label = "Algemeen",
                },
                marketPrices = {
                    label = "Prijzen",
                },
                distribution = {
                    label = "Distributie",
                },
                threatsGeneral = {
                    label = "Algemeen",
                },
                threatHeat = {
                    label = "Politiedruk",
                },
                threatChances = {
                    label = "Kansen",
                },
                pvpTakeoverRules = {
                    label = "Overnameregels",
                },
                pvpTakeoverZones = {
                    label = "Gebieden & Tijden",
                },
                pvpTakeoverMethods = {
                    label = "Inbraakmethoden",
                },
                consumptionGeneral = {
                    label = "Algemeen",
                },
                consumerDecay = {
                    label = "Afname van tolerantie en verslaving",
                },
                consumerEffects = {
                    label = "Effecten en risico's",
                },
                processingFlow = {
                    label = "Verwerkingsproces",
                },
                processingGeneral = {
                    label = "Algemeen",
                },
                powerRuntime = {
                    label = "Spelwerking",
                },
                powerHeat = {
                    label = "Politieaandacht en stroomverbruik",
                },
                powerModes = {
                    label = "Beheer / Modi",
                },
                powerPriorities = {
                    label = "Belasting / Prioriteiten",
                },
                performanceInactiveControlIntervalMs = {
                    label = "Inactief / Bediening / Interval / ms",
                },
                performanceInteractionIdleScanIntervalMs = {
                    label = "Interactie / Inactief / Scaninterval / ms",
                },
                performanceInteractionPromptIntervalMs = {
                    label = "Interactie / Interactieaanwijzing / Interval / ms",
                },
                performanceInteractionScanIntervalMs = {
                    label = "Interactie / Scaninterval / ms",
                },
                performanceMinimumScanIntervalMs = {
                    label = "Minimum / Scaninterval / ms",
                },
                performanceStreetPedActivationDistance = {
                    label = "Straat / Ped / Activatie / Afstand",
                },
                performanceStreetPedIdleScanIntervalMs = {
                    label = "Straat / Ped / Inactief / Scaninterval / ms",
                },
                performanceStreetPedScanIntervalMs = {
                    label = "Straat / Ped / Scaninterval / ms",
                },
                performanceWorldCachePadding = {
                    label = "Wereld / Cache / Extra marge",
                },
                performanceWorldCacheRefreshIntervalMs = {
                    label = "Wereld / Cache / Verversing / Interval / ms",
                },
                performanceWorldIdleIntervalMs = {
                    label = "Wereld / Inactief / Interval / ms",
                },
                dynamicMarketActionCooldownSeconds = {
                    label = "Actie-cooldown / seconden",
                },
                dynamicMarketActionHistoryLimit = {
                    label = "Actie / Geschiedenislimiet",
                },
                dynamicMarketAmountSaturationWeight = {
                    label = "Hoeveelheid / Verzadiging / Gewicht",
                },
                dynamicMarketBaseIntelAccuracy = {
                    label = "Basiswaarde / Nauwkeurigheid van de info",
                },
                dynamicMarketDefaultAverageQuality = {
                    label = "Standaardwaarde / Gemiddelde / Kwaliteit",
                },
                dynamicMarketDefaultResourceElasticity = {
                    label = "Standaardwaarde / Grondstof / Elasticiteit",
                },
                dynamicMarketDemandCenter = {
                    label = "Vraag / Middenwaarde",
                },
                dynamicMarketDemandPriceImpact = {
                    label = "Vraag / Prijs / Invloed",
                },
                dynamicMarketDirectionThreshold = {
                    label = "Richting / Drempel",
                },
                dynamicMarketEnabled = {
                    label = "Ingeschakeld",
                },
                dynamicMarketEventChance = {
                    label = "Gebeurtenis / Kans",
                },
                dynamicMarketEventDurationMinutes = {
                    label = "Gebeurtenis / Duur / Minuten",
                },
                dynamicMarketEventMinimumDurationMinutes = {
                    label = "Gebeurtenis / Minimum / Duur / Minuten",
                },
                dynamicMarketEventStrengthMaximum = {
                    label = "Gebeurtenis / Sterkte / Maximum",
                },
                dynamicMarketEventStrengthMinimum = {
                    label = "Gebeurtenis / Sterkte / Minimum",
                },
                dynamicMarketEvents = {
                    label = "Evenementen",
                },
                dynamicMarketExactIntelReputation = {
                    label = "Exacte informatie / Reputatie",
                },
                dynamicMarketExactIntelTrust = {
                    label = "Exacte informatie / Vertrouwen",
                },
                dynamicMarketGlobalZoneLabel = {
                    label = "Global / Zone / Naam",
                },
                dynamicMarketHistoryLimit = {
                    label = "Geschiedenislimiet",
                },
                dynamicMarketInitialDemand = {
                    label = "Beginwaarde / Vraag",
                },
                dynamicMarketInitialPriceMultiplier = {
                    label = "Beginwaarde / Prijsvermenigvuldiger",
                },
                dynamicMarketIntelDemandError = {
                    label = "Informatie / Vraag / Fout",
                },
                dynamicMarketIntelMaximumAccuracy = {
                    label = "Informatie / Maximum / Nauwkeurigheid",
                },
                dynamicMarketIntelMinimumAccuracy = {
                    label = "Informatie / Minimum / Nauwkeurigheid",
                },
                dynamicMarketIntelPoliceError = {
                    label = "Informatie / Politie / Fout",
                },
                dynamicMarketIntelPriceError = {
                    label = "Informatie / Prijs / Fout",
                },
                dynamicMarketIntelPriceMaximum = {
                    label = "Informatie / Prijs / Maximum",
                },
                dynamicMarketIntelPriceMinimum = {
                    label = "Informatie / Prijs / Minimum",
                },
                dynamicMarketIntelReputationWeight = {
                    label = "Informatie / Reputatie / Gewicht",
                },
                dynamicMarketIntelResourcePriceError = {
                    label = "Informatie / Grondstof / Prijs / Fout",
                },
                dynamicMarketIntelSaturationError = {
                    label = "Informatie / Verzadiging / Fout",
                },
                dynamicMarketIntelSeedBucketSeconds = {
                    label = "Tijdvak voor willekeurige informatiewaarde / seconden",
                },
                dynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Informatie / Status / Nauwkeurigheid / Drempel",
                },
                dynamicMarketIntelStatusErrorThreshold = {
                    label = "Informatie / Status / Fout / Drempel",
                },
                dynamicMarketIntelSupplyError = {
                    label = "Informatie / Levering / Fout",
                },
                dynamicMarketIntelTrustWeight = {
                    label = "Informatie / Vertrouwen / Gewicht",
                },
                dynamicMarketManipulationCooldownMinutes = {
                    label = "Manipulatie / Afkoeltijd (minuten)",
                },
                dynamicMarketManipulationDemandShift = {
                    label = "Manipulatie / Vraag / Verschuiving",
                },
                dynamicMarketManipulationDurationMinutes = {
                    label = "Manipulatie / Duur / Minuten",
                },
                dynamicMarketManipulationHeat = {
                    label = "Manipulatie / Politiedruk",
                },
                dynamicMarketManipulationMinimumBatchAmount = {
                    label = "Manipulatie / Minimum / Batch / Hoeveelheid",
                },
                dynamicMarketManipulationPaymentAccount = {
                    label = "Manipulatie / Betaalrekening",
                },
                dynamicMarketManipulationPrice = {
                    label = "Manipulatie / Prijs",
                },
                dynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Manipulatie / Zone / Politiedruk / Vermenigvuldiger",
                },
                dynamicMarketMaximumIntelAgeMinutes = {
                    label = "Maximum / Leeftijd van de info / Minuten",
                },
                dynamicMarketMaximumPriceMultiplier = {
                    label = "Maximum / Prijsvermenigvuldiger",
                },
                dynamicMarketMinimumIntelAgeMinutes = {
                    label = "Minimum / Leeftijd van de info / Minuten",
                },
                dynamicMarketMinimumMetricWindowMinutes = {
                    label = "Minimum / Meetwaarde / Tijdvenster / Minuten",
                },
                dynamicMarketMinimumPriceMultiplier = {
                    label = "Minimale prijs / Vermenigvuldiger",
                },
                dynamicMarketMinimumUpdateMinutes = {
                    label = "Minimum / Bijwerking / Minuten",
                },
                dynamicMarketPoliceDemandWeight = {
                    label = "Politie / Vraag / Gewicht",
                },
                dynamicMarketPolicePriceImpact = {
                    label = "Politie / Prijs / Invloed",
                },
                dynamicMarketPoorQualityDemandPenalty = {
                    label = "Slechte kwaliteit / Vraag / Aftrek",
                },
                dynamicMarketPoorQualityThreshold = {
                    label = "Slechte kwaliteit / Drempel",
                },
                dynamicMarketPremiumQualityDemandBonus = {
                    label = "Topkwaliteit / Vraagbonus",
                },
                dynamicMarketPremiumQualityThreshold = {
                    label = "Topkwaliteit / Drempel",
                },
                dynamicMarketProductionSupplyWeight = {
                    label = "Productie / Levering / Gewicht",
                },
                dynamicMarketProductionWindowMinutes = {
                    label = "Productie / Tijdvenster / Minuten",
                },
                dynamicMarketQualityCenter = {
                    label = "Kwaliteit / Middenwaarde",
                },
                dynamicMarketQualityConfidenceImpact = {
                    label = "Kwaliteit / Zekerheid / Invloed",
                },
                dynamicMarketQualityRange = {
                    label = "Kwaliteit / Waardenbereik",
                },
                dynamicMarketRarityBonusMaximum = {
                    label = "Zeldzaamheid / Bonus / Maximum",
                },
                dynamicMarketRegionalGlobalWeight = {
                    label = "Regionaal / Global / Gewicht",
                },
                dynamicMarketRegionalLocalWeight = {
                    label = "Regionaal / Lokaal / Gewicht",
                },
                dynamicMarketResourceAliases = {
                    label = "Grondstof / Alternatieve namen",
                },
                dynamicMarketResourceDirectionFallThreshold = {
                    label = "Grondstof / Richting / Daling / Drempel",
                },
                dynamicMarketResourceDirectionRiseThreshold = {
                    label = "Grondstof / Richting / Stijging / Drempel",
                },
                dynamicMarketResources = {
                    label = "Grondstoffen",
                },
                dynamicMarketSalesWindowMinutes = {
                    label = "Verkopen / Tijdvenster / Minuten",
                },
                dynamicMarketSaturationDemandWeight = {
                    label = "Verzadiging / Vraag / Gewicht",
                },
                dynamicMarketSaturationPriceImpact = {
                    label = "Verzadiging / Prijs / Invloed",
                },
                dynamicMarketScarcityDemandWeight = {
                    label = "Schaarste / Vraag / Gewicht",
                },
                dynamicMarketScarcityPriceImpact = {
                    label = "Schaarste / Prijs / Invloed",
                },
                dynamicMarketSeasonEndMonths = {
                    label = "Seizoen / Einde / Maanden",
                },
                dynamicMarketSeasonMultipliers = {
                    label = "Seizoen / Vermenigvuldigers",
                },
                dynamicMarketShortageRumorThreshold = {
                    label = "Tekort / Gerucht / Drempel",
                },
                dynamicMarketStatusThresholds = {
                    label = "Status / Drempels",
                },
                dynamicMarketTargetSupply = {
                    label = "Doelwit / Levering",
                },
                dynamicMarketTrendChance = {
                    label = "Trend / Kans",
                },
                dynamicMarketTrendDurationMinutes = {
                    label = "Trend / Duur / Minuten",
                },
                dynamicMarketTrendMaximumStrength = {
                    label = "Trend / Maximum / Sterkte",
                },
                dynamicMarketTrendMinimumStrength = {
                    label = "Trend / Minimum / Sterkte",
                },
                dynamicMarketUpdateMinutes = {
                    label = "Bijwerking / Minuten",
                },
                dynamicMarketVolatilityMaximum = {
                    label = "Prijsvolatiliteit / Maximum",
                },
                dynamicMarketVolatilityMinimum = {
                    label = "Prijsvolatiliteit / Minimum",
                },
                dynamicMarketWeatherMultipliers = {
                    label = "Weer / Vermenigvuldigers",
                },
                dynamicMarketWeatherState = {
                    label = "Weer / Status",
                },
                heatActionCooldownSeconds = {
                    label = "Actie-cooldown / seconden",
                },
                heatActivityRiskWeights = {
                    label = "Activiteit / Risico / Wegingen",
                },
                heatAggressiveHeatMultiplier = {
                    label = "Agressieve werkwijze / Politiedruk / Vermenigvuldiger",
                },
                heatBurnerBurnThreshold = {
                    label = "Wegwerptelefoon / Ontmaskering / Drempel",
                },
                heatBurnerHeatPerWholesale = {
                    label = "Wegwerptelefoon / Politiedruk / Per groothandelsdeal",
                },
                heatBurnerPhoneItem = {
                    label = "Burner phone / Voorwerp",
                },
                heatCamperOperationalHeatMultiplier = {
                    label = "Camper in bedrijf / Politiedruk / Vermenigvuldiger",
                },
                heatCamperOperationalHeatThreshold = {
                    label = "Camper in bedrijf / Politiedruk / Drempel",
                },
                heatCamperParkedHeat = {
                    label = "Geparkeerde camper / Politiedruk",
                },
                heatContaminatedHeatMultiplier = {
                    label = "Verontreiniging / Politiedruk / Vermenigvuldiger",
                },
                heatContaminatedThreshold = {
                    label = "Verontreiniging / Drempel",
                },
                heatCultivationFreePlants = {
                    label = "Teelt / Planten zonder extra risico",
                },
                heatCultivationHeatPerPlant = {
                    label = "Teelt / Politiedruk / Per plant",
                },
                heatDealerHiddenMinutes = {
                    label = "Handelaar / verborgen / Minuten",
                },
                heatDecayPerTick = {
                    label = "Verval / Per updatestap",
                },
                heatEnabled = {
                    label = "Ingeschakeld",
                },
                heatEnforcementHeat = {
                    label = "Politieaanwezigheid / Politiedruk",
                },
                heatEnforcementMultipliers = {
                    label = "Politieaanwezigheid / Vermenigvuldigers",
                },
                heatEntityTypes = {
                    label = "Spelobject / Typen",
                },
                heatEventCooldownMinutes = {
                    label = "Gebeurtenis / Afkoeltijd (minuten)",
                },
                heatEventHistoryLimit = {
                    label = "Gebeurtenis / Geschiedenislimiet",
                },
                heatLabHeatSyncThreshold = {
                    label = "Lab / Politiedruk / Synchronisatie / Drempel",
                },
                heatLayLowCooldownMinutes = {
                    label = "Onderduiken / Afkoeltijd (minuten)",
                },
                heatLayLowIdleMinutes = {
                    label = "Onderduiken / Inactief / Minuten",
                },
                heatLayLowReduction = {
                    label = "Onderduiken / Vermindering",
                },
                heatLockdownMinutes = {
                    label = "Lockdown / Minuten",
                },
                heatMinimumDurationMinutes = {
                    label = "Minimum / Duur / Minuten",
                },
                heatMinimumEventCooldownSeconds = {
                    label = "Minimum / Gebeurtenis / Cooldown (seconden)",
                },
                heatMinimumIdleSeconds = {
                    label = "Minimum / Inactief / seconden",
                },
                heatProcessingHeatMultiplier = {
                    label = "Verwerking / Politiedruk / Vermenigvuldiger",
                },
                heatRiskWeights = {
                    label = "Risico / Wegingen",
                },
                heatRotateBurnerReduction = {
                    label = "Wegwerptelefoon wisselen / Vermindering",
                },
                heatRouteControlMinutes = {
                    label = "Route / Bediening / Minuten",
                },
                heatSaleHeat = {
                    label = "Verkoop / Politiedruk",
                },
                heatThresholds = {
                    label = "Drempels",
                },
                heatTickMinutes = {
                    label = "Updatecyclus / Minuten",
                },
                heatWholesaleHeatMultiplier = {
                    label = "Groothandel / Politiedruk / Vermenigvuldiger",
                },
                heatWorkerLeakAlertRadius = {
                    label = "Medewerker / Informatielek / Alertradius",
                },
                heatWorkerLeakBaseChance = {
                    label = "Medewerker / Informatielek / Basiswaarde / Kans",
                },
                heatWorkerLeakFactionMultiplier = {
                    label = "Medewerker / Informatielek / Factie / Vermenigvuldiger",
                },
                heatWorkerLeakHighSeverityThreshold = {
                    label = "Medewerker / Informatielek / Hoog / Ernst / Drempel",
                },
                heatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Medewerker / Informatielek / Loyaliteit / Kans / Vermenigvuldiger",
                },
                heatWorkerLeakLoyaltyThreshold = {
                    label = "Medewerker / Informatielek / Loyaliteit / Drempel",
                },
                heatWorkerLeakMaximumChance = {
                    label = "Medewerker / Informatielek / Maximum / Kans",
                },
                heatWorkerLeakMinimumCooldownSeconds = {
                    label = "Medewerker / Informatielek / Minimum / Cooldown (seconden)",
                },
                heatWorkerLeakRouteMultiplier = {
                    label = "Medewerker / Informatielek / Route / Vermenigvuldiger",
                },
                heatWorkerLeakStrengthMaximum = {
                    label = "Medewerker / Informatielek / Sterkte / Maximum",
                },
                heatWorkerLeakStrengthMinimum = {
                    label = "Medewerker / Informatielek / Sterkte / Minimum",
                },
                heatWorkerLeakStrengthMultiplier = {
                    label = "Medewerker / Informatielek / Sterkte / Vermenigvuldiger",
                },
                heatWorkerLeakStressChanceMultiplier = {
                    label = "Medewerker / Informatielek / Stress / Kans / Vermenigvuldiger",
                },
                heatWorkerLeakStressThreshold = {
                    label = "Medewerker / Informatielek / Stress / Drempel",
                },
                contactsActionCooldownSeconds = {
                    label = "Actie-cooldown / seconden",
                },
                contactsActiveHotspotCount = {
                    label = "Aantal actieve hotspots",
                },
                contactsBurnerHintTrust = {
                    label = "Burner-hint / Vertrouwen",
                },
                contactsBurnerOfferMaximumMultiplier = {
                    label = "Wegwerptelefoon / Aanbod / Maximum / Vermenigvuldiger",
                },
                contactsBurnerOfferMinimumMultiplier = {
                    label = "Wegwerptelefoon / Aanbod / Minimum / Vermenigvuldiger",
                },
                contactsBuyerCooldownMinutes = {
                    label = "Koper / Afkoeltijd (minuten)",
                },
                contactsBuyerDeliveryDistance = {
                    label = "Koper / Afleverafstand",
                },
                contactsBuyerPremiumSuccessScore = {
                    label = "Koper / Premium / Succes / Score",
                },
                contactsBuyerPremiumTrustGain = {
                    label = "Koper / Premium / Vertrouwen / winst",
                },
                contactsBuyerRequestHeatRiskWeight = {
                    label = "Koper / Aanvraag / Heat & Risico / Gewicht",
                },
                contactsBuyerStandardTrustGain = {
                    label = "Koper / Standaard / Vertrouwen / winst",
                },
                contactsContactActiveDelaySeconds = {
                    label = "Wachttijd voor contactactivering / seconden",
                },
                contactsContactDemandRange = {
                    label = "Contact / Vraag / Waardenbereik",
                },
                contactsContactLossTrust = {
                    label = "Contact / Verlies / Vertrouwen",
                },
                contactsDarknetExactIntelMinutes = {
                    label = "Darknet / Exacte informatie / Minuten",
                },
                contactsDarknetHotspotIntelPrice = {
                    label = "Darknet / Hotspot / Informatie / Prijs",
                },
                contactsDarknetIntelPrice = {
                    label = "Darknet / Informatie / Prijs",
                },
                contactsDealerBasePrice = {
                    label = "Handelaar / Basisprijs",
                },
                contactsDealerHireCapacity = {
                    label = "Handelaar / Aanwerving / capaciteit",
                },
                contactsDealerHireRisk = {
                    label = "Handelaar / Aanwerving / Risico",
                },
                contactsDealerHireSkill = {
                    label = "Handelaar / Aanwerving / Vaardigheid",
                },
                contactsDealerOffers = {
                    label = "Dealer-aanbiedingen",
                },
                contactsDealerProtectionHours = {
                    label = "Handelaar / Bescherming / Uren",
                },
                contactsDealerProtectionPrice = {
                    label = "Handelaar / Bescherming / Prijs",
                },
                contactsDealerSaleMax = {
                    label = "Handelaar / Verkoop / Maximum",
                },
                contactsDealerSaleMin = {
                    label = "Handelaar / Verkoop / Minimum",
                },
                contactsDealerSimulation = {
                    label = "Handelaar / Simulatie",
                },
                contactsDealerTickMinutes = {
                    label = "Handelaar / Updatecyclus / Minuten",
                },
                contactsDealerWage = {
                    label = "Handelaar / Loon",
                },
                contactsDealerWageDecay = {
                    label = "Handelaar / Loon / Verval",
                },
                contactsDealerWageLoyaltyGain = {
                    label = "Handelaar / Loon / Loyaliteit / winst",
                },
                contactsDealerWeaknesses = {
                    label = "Handelaar / Zwakke punten",
                },
                contactsDefaultContactDemand = {
                    label = "Standaardwaarde / Contact / Vraag",
                },
                contactsDefaultContactRisk = {
                    label = "Standaardwaarde / Contact / Risico",
                },
                contactsDefaultDealerCapacity = {
                    label = "Standaarddealer / capaciteit",
                },
                contactsDefaultDealerRisk = {
                    label = "Standaarddealer / Risico",
                },
                contactsDefaultDealerSkill = {
                    label = "Standaarddealer / Vaardigheid",
                },
                contactsDefaultHotspotRadius = {
                    label = "Standaardwaarde / Hotspot / Straal",
                },
                contactsDemandResetMinutes = {
                    label = "Vraagreset (minuten)",
                },
                contactsEnabled = {
                    label = "Ingeschakeld",
                },
                contactsExactLocationTrust = {
                    label = "Exacte locatie / Vertrouwen",
                },
                contactsFactionDiscoveryReputation = {
                    label = "Factie / Ontdekking / Reputatie",
                },
                contactsFactionHintTrust = {
                    label = "Factie / Aanwijzing / Vertrouwen",
                },
                contactsFailedDeliveryCooldownMinutes = {
                    label = "Mislukte levering / Afkoeltijd (minuten)",
                },
                contactsFakeDealEncounter = {
                    label = "Nepdeal / Ontmoeting",
                },
                contactsFallbackPreferredDrug = {
                    label = "Vervangende waarde / Voorkeursdrug",
                },
                contactsFallbackProductLabel = {
                    label = "Vervangende waarde / Productlabel",
                },
                contactsGuideBookItem = {
                    label = "Handleiding / Boek / Voorwerp",
                },
                contactsGuideBookTrust = {
                    label = "Handleiding / Boek / Vertrouwen",
                },
                contactsHireDealerPrice = {
                    label = "Dealer inhuren / Prijs",
                },
                contactsHistoryLimit = {
                    label = "Geschiedenislimiet",
                },
                contactsHotspotIntelMinutes = {
                    label = "Hotspot / Informatie / Minuten",
                },
                contactsHotspotRotationMinutes = {
                    label = "Hotspot / Wisseling / Minuten",
                },
                contactsListingDurationMinutes = {
                    label = "Advertentie / Duur / Minuten",
                },
                contactsMaxOwnedDealers = {
                    label = "Maximum / In bezit / Dealers",
                },
                contactsMinimumBuyerDeliveryDistance = {
                    label = "Minimum / Koper / Afleverafstand",
                },
                contactsMinimumContactRotationMinutes = {
                    label = "Minimum / Contactrotatie (minuten)",
                },
                contactsMinimumDemandResetMinutes = {
                    label = "Minimum / Vraagreset (minuten)",
                },
                contactsMinimumHeatMultiplier = {
                    label = "Minimum / Politiedruk / Vermenigvuldiger",
                },
                contactsMinimumHotspotIntelMinutes = {
                    label = "Minimum / Hotspot / Informatie / Minuten",
                },
                contactsMinimumHotspotRadius = {
                    label = "Minimum / Hotspot / Straal",
                },
                contactsMinimumHotspotRotationMinutes = {
                    label = "Minimum / Hotspot / Wisseling / Minuten",
                },
                contactsMinimumListingDurationMinutes = {
                    label = "Minimum / Advertentie / Duur / Minuten",
                },
                contactsMinimumRewardMultiplier = {
                    label = "Minimale beloning / Vermenigvuldiger",
                },
                contactsMinimumRobberyMultiplier = {
                    label = "Minimum / Overval / Vermenigvuldiger",
                },
                contactsMinimumSpotPriceMultiplier = {
                    label = "Minimum / Locatie / Prijsvermenigvuldiger",
                },
                contactsOtherDrugPriceMultiplier = {
                    label = "Andere / Drug / Prijsvermenigvuldiger",
                },
                contactsPaymentAccount = {
                    label = "Betaalrekening",
                },
                contactsPostDeliveryDemandResetSeconds = {
                    label = "Na levering / Vraag / Reset / seconden",
                },
                contactsPreferredDrugPriceMultiplier = {
                    label = "Voorkeursdrug / Prijsvermenigvuldiger",
                },
                contactsRegionLocationTrust = {
                    label = "Regio / Locatie / Vertrouwen",
                },
                contactsRequestAmounts = {
                    label = "Aanvraag / Hoeveelheden",
                },
                contactsRotationMinutes = {
                    label = "Wisseling / Minuten",
                },
                contactsSpotPools = {
                    label = "Locatie / Selectiegroepen",
                },
                contactsStreetHotspots = {
                    label = "Straat / Hotspots",
                },
                contactsTrustLevels = {
                    label = "Vertrouwen / Niveaus",
                },
                businessActionCooldownSeconds = {
                    label = "Actie-cooldown / seconden",
                },
                businessBalance = {
                    label = "Balans",
                },
                businessContracts = {
                    label = "Contracten",
                },
                businessDefaultBusinessName = {
                    label = "Standaardwaarde / Bedrijfsnaam",
                },
                businessDefaultRankId = {
                    label = "Standaardwaarde / Rang / ID",
                },
                businessDefaultStaffStyle = {
                    label = "Standaardwaarde / Personeel / Werkwijze",
                },
                businessDefaultTransport = {
                    label = "Standaardwaarde / Transport",
                },
                businessEnabled = {
                    label = "Ingeschakeld",
                },
                businessHubs = {
                    label = "Distributiecentra",
                },
                businessLimits = {
                    label = "Limieten",
                },
                businessPayments = {
                    label = "Betalingen",
                },
                businessPayoutAccount = {
                    label = "Uitbetaling / Rekening",
                },
                businessRanks = {
                    label = "Rangen",
                },
                businessReportDays = {
                    label = "Rapportperiode / dagen",
                },
                businessRouteEndpointTypes = {
                    label = "Route / Eindpunt / Typen",
                },
                businessRuntime = {
                    label = "Spelwerking",
                },
                businessSocietyPermission = {
                    label = "Organisatie / Toestemming",
                },
                businessStaff = {
                    label = "Personeel",
                },
                businessTickMinutes = {
                    label = "Updatecyclus / Minuten",
                },
                businessTransports = {
                    label = "Transporten",
                },
            },
            territorySettings = {
                section = "Territoria",
                zonesGroup = "Territoriumzones",
                sourceLabel = "Zonebron",
                sourceDescription = "Gebruik de beschermde standaarddistricten of definieer je eigen territoriumpolygonen.",
                sourcePreset = "Standaarddistricten",
                sourceCustom = "Aangepaste territoria",
                editLabel = "Territorium-editor",
                editDescription = "Bewerk de districten die worden gebruikt door de geselecteerde zonebron.",
                editButton = "Territoria bewerken",
                presetSection = "Standaarddistricten",
                presetEntry = "Standaarddistrict",
                customSection = "Aangepaste territoria",
                customEntry = "Aangepast territorium",
                typeLabel = "Territoriumtype",
                streetType = "Straat",
                supplyType = "Levering",
                enabledLabel = "Op kaart tonen",
                enabledDescription = "Uitgeschakelde standaarddistricten worden van de kaart verwijderd en kunnen niet worden geclaimd.",
                zoneLabel = "Territoriumgrens",
                zoneDescription = "Plaats minstens drie opeenvolgende punten langs de grens van het territorium.",
                ownershipGroup = "Eigendom",
                decayGroup = "Verval",
                presenceGroup = "Aanwezigheid",
                activityGroup = "Activiteitsscore",
                ownershipBenefitsGroup = "Eigendomsvoordelen",
                ownershipThresholdLabel = "Eigendomsdrempel",
                ownershipThresholdDescription = "Controlepercentage dat een gang moet overschrijden om officieel eigenaar te zijn van een territorium.",
                activityFloorLabel = "Vaste activiteitsgrens",
                activityFloorDescription = "Benodigde invloedspunten wanneer de op grootte gebaseerde grenzen zijn uitgeschakeld.",
                floorByZoneSizeLabel = "Grens schalen op basis van zoogrootte",
                floorByZoneSizeDescription = "Bereken de activiteitsgrens van elk territorium op basis van de polygoonoppervlakte in plaats van de vaste grens te gebruiken.",
                floorPointsPerSizeUnitLabel = "Grenspunten per km²",
                floorPointsPerSizeUnitDescription = "Benodigde activiteitspunten per vierkante kilometer territoriumoppervlakte.",
                fixedFloorRequirement = "Schakel de op grootte gebaseerde grenzen uit om de vaste activiteitsgrens te bewerken.",
                sizeFloorRequirement = "Schakel de op grootte gebaseerde grenzen in om punten per vierkante kilometer te bewerken.",
                dailyDecayLabel = "Dagelijks invloedverval",
                dailyDecayDescription = "Percentage invloed dat elke 24 uur wordt verwijderd.",
                presenceIntervalLabel = "Presentie-interval",
                presenceIntervalDescription = "Minuten tussen automatische toekenning van territorium-presentie.",
                presencePointsLabel = "Presentiepunten per lid",
                presencePointsDescription = "Presentiepunten die aan elk in aanmerking komend ganglid per interval worden toegekend.",
                drugSalesEnabledLabel = "NPC-verkopen geven territoriuminvloed",
                drugSalesEnabledDescription = "Succesvolle straatverkopen aan NPC's geven invloed aan de gang van de verkoper in het huidige straatterritorium.",
                drugSalePointsLabel = "Punten per verkocht middel",
                drugSalePointsDescription = "Invloedspunten die worden toegekend voor elke eenheid middel die als verkocht is gerapporteerd.",
                drugSalesRequirement = "Schakel NPC-verkoopinvloed in om de punten te configureren.",
                graffitiPointsLabel = "Graffiti-punten per 24 uur",
                graffitiPointsDescription = "Presentiepunten die worden toegekend wanneer één graffiti in totaal 24 gerapporteerde uren heeft bestaan.",
                streetSellingPriceBonusLabel = "Bonus op straatverkoopprijs",
                streetSellingPriceBonusDescription = "Percentage toegevoegd aan de verkoopprijzen van drugs voor de officiële eigenaar van een Street-territorium.",
                supplyProductionSpeedBonusLabel = "Bonus voor de productiesnelheid van voorraden",
                supplyProductionSpeedBonusDescription = "Percentage toegevoegd aan de productiesnelheid van drugs voor de officiële eigenaar van een Supply-territorium.",
                pruneToleranceLabel = "Tolerantie voor invloed-schoonmaak",
                pruneToleranceDescription = "Effectieve invloed onder deze waarde wordt als nul beschouwd.",
            },
            graffitiSettings = {
                section = "Graffiti",
                generalGroup = "Algemeen",
                streamingGroup = "Renderen",
                moderationGroup = "Moderatie",
                graffitiEnabledLabel = "Graffiti inschakelen",
                graffitiEnabledDescription = "Stel spelers in staat om graffiti te spuiten en te bekijken.",
                graffitiRequireItemLabel = "Spuitbus vereist",
                graffitiRequireItemDescription = "Spelers hebben een spuitbus nodig om te spuiten. Anders wordt het /graffiti commando gebruikt.",
                graffitiChargesPerCanLabel = "Aantal ladingen per bus",
                graffitiChargesPerCanDescription = "Hoeveel graffiti er met één spuitbus gemaakt kan worden.",
                graffitiCooldownSecondsLabel = "Spuit-cooldown",
                graffitiCooldownSecondsDescription = "Aantal seconden dat een speler moet wachten tussen het spuiten.",
                graffitiMaxPerPlayerLabel = "Max. graffiti per speler",
                graffitiMaxPerPlayerDescription = "Maximaal aantal actieve graffiti dat een speler kan bezitten. 0 betekent onbeperkt.",
                graffitiMaxDistanceLabel = "Max. spuitafstand",
                graffitiMaxDistanceDescription = "Hoe ver een muur weg mag zijn om er nog op te kunnen spuiten, in meters.",
                graffitiSprayDurationLabel = "Spuurtijd",
                graffitiSprayDurationDescription = "Hoe lang de spuitanimatie duurt, in milliseconden.",
                graffitiExpiryDaysLabel = "Vervaltijd",
                graffitiExpiryDaysDescription = "Aantal dagen totdat een graffiti automatisch verdwijnt. 0 betekent nooit.",
                graffitiTerritoryHoursLabel = "Territorium-uren per spuitbeurt",
                graffitiTerritoryHoursDescription = "Aantal uren territorium-aanwezigheid die een nieuwe graffiti aan zijn gang geeft.",
                graffitiStreamRadiusLabel = "Stream-radius",
                graffitiStreamRadiusDescription = "Afstand in meters waarbij graffiti zichtbaar wordt voor spelers.",
                graffitiPoolSizeLabel = "Decal pool grootte",
                graffitiPoolSizeDescription = "Hoeveel graffiti er tegelijkertijd gerenderd worden. Hogere waarden kosten meer prestaties.",
                graffitiReportsEnabledLabel = "Meldingen inschakelen",
                graffitiReportsEnabledDescription = "Laat spelers beledigende graffiti melden.",
                graffitiAutoHideThresholdLabel = "Drempelwaarde voor automatisch verbergen",
                graffitiAutoHideThresholdDescription = "Aantal meldingen dat een graffiti automatisch verbergt. 0 schakelt dit uit.",
            },
            darknetSettings = {
                section = "Darknet Markt",
                availabilityGroup = "Beschikbaarheid",
                economyGroup = "Cryptovaluta",
                listingsGroup = "Aanbiedingen en verval",
                chatGroup = "Privéchat",
                identityGroup = "Aliases en reputatie",
                deliveryGroup = "Overdracht en dead drops",
                policeGroup = "Politie-toegang",
                npcGroup = "NPC-handelaars",
                enabledLabel = "Darknet Markt inschakelen",
                enabledDescription = "Maakt de zwartmarkt-tablet-app en de runtime beschikbaar.",
                tabletOrderLabel = "Tablet-app volgorde",
                tabletOrderDescription = "Regelt de positie van de Darknet Markt op de tablet.",
                currencyCodeLabel = "Valuta-code",
                currencyCodeDescription = "Korte label die wordt getoond voor het interne cryptovaluta-grootboek.",
                starterBalanceLabel = "Nieuw wallet-saldo",
                starterBalanceDescription = "Crypto wordt alleen toegewezen wanneer een speler de markt voor de eerste keer opent.",
                exchangeEnabledLabel = "Muntwissel inschakelen",
                exchangeEnabledDescription = "Stelt geauthenticeerde BlackBay-gebruikers in staat om munten te kopen en verkopen op hun accountpagina.",
                exchangeAccountLabel = "Betalingsaccount voor wissel",
                exchangeAccountDescription = "Framework-account dat wordt gebruikt voor aankopen van munten en uitbetalingen van verkopen.",
                exchangeBuyPriceLabel = "Koopprijs per munt",
                exchangeBuyPriceDescription = "Bedrag dat voor één munt van het betalingsaccount wordt afgeschreven.",
                exchangeSellPriceLabel = "Verkoopprijs per munt",
                exchangeSellPriceDescription = "Bedrag dat voor één munt aan het betalingsaccount wordt uitgekeerd.",
                exchangeMinimumLabel = "Minimaal aantal munten per wissel",
                exchangeMinimumDescription = "Kleinste ronde munthoeveelheid die in één wissel wordt geaccepteerd.",
                exchangeMaximumLabel = "Maximaal aantal munten per wissel",
                exchangeMaximumDescription = "Grootste ronde munthoeveelheid die in één wissel wordt geaccepteerd.",
                accountMoney = "Contant",
                accountBank = "Bank",
                accountBlackMoney = "Vies geld",
                scamChanceLabel = "Globale NPC-oplichterkans (%)",
                scamChanceDescription = "Minimale kans dat een NPC-handel de betaling of goederen inneemt zonder de tegenprestatie te leveren. Een hogere handelaar-specifieke kans blijft van kracht.",
                listingExpiryLabel = "Aanbiedingsduur (uren)",
                listingExpiryDescription = "Actieve aanbiedingen verlopen automatisch na dit aantal uren.",
                renewalHoursLabel = "Verlengingsduur (uren)",
                renewalHoursDescription = "Aantal uren dat wordt toegevoegd wanneer een eigenaar een aanbieding verlengt.",
                maximumListingsLabel = "Maximale actieve aanbiedingen",
                maximumListingsDescription = "Maximale aanbiedingen per actieve alias.",
                maximumQuantityLabel = "Maximale hoeveelheid goederen",
                maximumQuantityDescription = "Bovengrens voor de hoeveelheid goederen in één aanbieding.",
                maximumPriceLabel = "Maximale eenheidsprijs",
                maximumPriceDescription = "Maximale cryptoprijs voor een enkele eenheid.",
                maximumMessageLengthLabel = "Maximale berichtlengte",
                maximumMessageLengthDescription = "Maximaal aantal tekens per versleuteld chatbericht.",
                aliasCooldownLabel = "Wachttijd aliaswijziging (uren)",
                aliasCooldownDescription = "Minimale leeftijd van een identiteit voordat deze opnieuw kan worden ingetrokken.",
                verifiedSalesLabel = "Aantal benodigde verkopen voor verificatie",
                verifiedSalesDescription = "Aantal succesvolle verkopen vereist voordat een verkoper geverifieerd kan worden.",
                verifiedRatingLabel = "Benodigde beoordeling voor verificatie",
                verifiedRatingDescription = "Minimale gemiddelde beoordeling voor een geverifieerde verkoper.",
                scammerReportsLabel = "Meldingen voor oplichter-waarschuwing",
                scammerReportsDescription = "Unieke handelsmeldingen vereist voor het 'bekende oplichter'-badge.",
                meetingDistanceLabel = "Overdrachtsafstand",
                meetingDistanceDescription = "Maximale afstand tussen beide spelers of de geconfigureerde NPC-locatie.",
                dropModelLabel = "Dead-drop kistmodel",
                dropModelDescription = "GTA-propmodel dat lokaal wordt gespawned voor beschikbare dead drops.",
                dropStreamLabel = "Dead-drop stream-afstand",
                dropStreamDescription = "Afstand waarbij kisten en NPC-ontmoetingscontacten worden gestreamd.",
                dropInteractionLabel = "Dead-drop interactie-afstand",
                dropInteractionDescription = "Vereiste afstand om een kist te doorzoeken en op te eisen.",
                dropLifetimeLabel = "Dead-drop levensduur (uren)",
                dropLifetimeDescription = "Tijd voordat een niet-opgeëiste kist verloopt.",
                dropPollLabel = "Wereld-verversingsinterval (ms)",
                dropPollDescription = "Interval dat wordt gebruikt om nabijgelegen kisten en NPC-ontmoetingen te verversen.",
                policeGroupsLabel = "Geautoriseerde politie-jobgroepen",
                policeGroupsDescription = "Job Configurator-groepssleutels die lok-aanbiedingen kunnen publiceren en onderzoeken kunnen bekijken.",
                policeGroupEntry = "Politegroep",
                groupKeyLabel = "Groepssleutel",
                npcTradersLabel = "NPC-kopers en -verkopers",
                npcTradersDescription = "Configureer persistente synthetische aanbiedingen, leveringsmethode, reputatie en oplichtingskans.",
                npcTraderEntry = "NPC-handelaar",
                npcIdLabel = "ID",
                npcAliasLabel = "Alias",
                npcSideLabel = "Marktzijde",
                sideSell = "Verkoopt aan spelers",
                sideBuy = "Koopt van spelers",
                npcTitleLabel = "Aanbiedingstitel",
                npcDescriptionLabel = "Beschrijving",
                npcItemNameLabel = "Inventarisitemnaam",
                npcItemLabelLabel = "Goederenlabel",
                npcQuantityLabel = "Aantal",
                npcPriceLabel = "Eenheidsprijs",
                npcDeliveryLabel = "Leveringsmethode",
                deliveryBoth = "Ontmoeting en dead drop",
                deliveryMeeting = "Alleen persoonlijk",
                deliveryDrop = "Alleen dead drop",
                npcScamChanceLabel = "Kans op handelaar-scam (%)",
                npcPedModelLabel = "NPC ped-model",
                npcRatingLabel = "Getoonde beoordeling",
                npcRatingCountLabel = "Aantal getoonde beoordelingen",
                npcTradesLabel = "Getoonde succesvolle transacties",
                npcVerifiedLabel = "Geverifieerde handelaar",
                npcScammerLabel = "Bekende oplichter",
                npcEnabledLabel = "Ingeschakeld",
            },
            interrogationSettings = {
                section = "Verhoor",
                generalGroup = "Algemeen",
                consentGroup = "Spelerbescherming",
                objectGroup = "Objecten",
                grabGroup = "Overweldigen",
                sessionGroup = "Sessie",
                dispatchGroup = "Politie-meldingen",
                loggingGroup = "Loggen",
                securityGroup = "Beveiliging",
                presentationGroup = "Presentatie",
                enabledLabel = "Verhoor inschakelen",
                enabledDescription = "Stelt spelers in staat om anderen aan verhoorstoelen te binden en gereedschap op hen te gebruiken.",
                consentRequiredLabel = "Toestemming vereisen",
                consentRequiredDescription = "Alleen spelers die hebben ingestemd kunnen slachtoffer worden. Er is geen aparte functie voor toestemming; hiervoor moet de onderstaande instelling worden gebruikt.",
                consentDefaultLabel = "Standaard ingestemd",
                consentDefaultDescription = "Nieuwe personages starten met toestemming in plaats van weigering.",
                globalIntensityLabel = "Effectintensiteit",
                globalIntensityDescription = "Schalert schermeffecten, deeltjes en geluid. 0 schakelt deze volledig uit.",
                maxPerPlayerLabel = "Objecten per speler",
                maxPerPlayerDescription = "Hoeveel stoelen en karren een speler mag plaatsen. 0 betekent onbeperkt.",
                maxGlobalLabel = "Objecten serverbreed",
                maxGlobalDescription = "Totaal aantal geplaatste objecten dat tegelijkertijd is toegestaan. 0 betekent onbeperkt.",
                placementDistanceLabel = "Plaatsingsafstand",
                placementDistanceDescription = "Hoe ver een object van de speler verwijderd mag zijn, in meters.",
                interactDistanceLabel = "Interactieafstand",
                interactDistanceDescription = "Hoe dicht een speler bij een stoel of kar moet staan om deze te gebruiken, in meters.",
                inactivityMinutesLabel = "Automatisch verwijderen na",
                inactivityMinutesDescription = "Minuten inactiviteit voordat een geplaatst object verdwijnt. 0 houdt het voor altijd vast.",
                persistObjectsLabel = "Objecten behouden na herstart",
                persistObjectsDescription = "Geplaatste objecten worden uit de database hersteld wanneer de server weer online komt.",
                grabEnabledLabel = "Overweldigen inschakelen",
                grabEnabledDescription = "Stelt spelers in staat om een andere speler te overweldigen en weg te dragen.",
                grabItemLabel = "Vereist item",
                grabItemDescription = "Item dat de aanvaller nodig heeft om iemand te grijpen. Leeg laten als er niets nodig is.",
                grabAngleLabel = "Benaderingshoek",
                grabAngleDescription = "Hoe ver men zijdelings van direct achter de aanvaller mag staan, in graden.",
                grabHealthBelowLabel = "Gezondheidsdrempel",
                grabHealthBelowDescription = "Een slachtoffer onder deze gezondheid kan worden gegrepen zonder te worden vastgebonden. 0 schakelt dit uit.",
                grabCooldownLabel = "Cooldown na mislukking",
                grabCooldownDescription = "Seconden voordat een mislukte poging tot grijpen opnieuw mag worden geprobeerd.",
                grabVehiclesLabel = "Toegestane voertuigen",
                grabVehiclesDescription = "Voertuigmodellen waarin een gegrepen slachtoffer kan worden geladen.",
                carryEnabledLabel = "Dragen toestaan",
                carryEnabledDescription = "Laat de aanvaller het slachtoffer over de schouder dragen.",
                restrictVisionLabel = "Zicht van slachtoffer beperken",
                restrictVisionDescription = "Maak het scherm van het slachtoffer zwart terwijl deze wordt getransporteerd.",
                escapeEnabledLabel = "Ontsnappingspogingen toestaan",
                escapeEnabledDescription = "Laat een getransporteerd slachtoffer proberen zich los te maken.",
                escapeSecondsLabel = "Ontsnappingsduur",
                escapeSecondsDescription = "Seconden dat het slachtoffer de toets moet ingedrukt houden om zich te bevrijden.",
                maxDurationLabel = "Maximale duur",
                maxDurationDescription = "Minuten waarna een sessie vanzelf eindigt.",
                warnMinutesLabel = "Waarschuwing voor het einde",
                warnMinutesDescription = "Minuten voor de limiet waarbij beide partijen worden gewaarschuwd.",
                idleMinutesLabel = "Vrijgeven bij inactiviteit",
                idleMinutesDescription = "Minuten zonder enige interactie voordat het slachtoffer wordt vrijgegeven.",
                selfReleaseMinutesLabel = "Zelfbevrijding na",
                selfReleaseMinutesDescription = "Minuten zonder interactie van de aanvaller voordat het slachtoffer zichzelf kan bevrijden.",
                graceSecondsLabel = "Niet-verbindingsperiode na verbreking van de verbinding",
                graceSecondsDescription = "Seconden dat het slachtoffer vastgebonden blijft wanneer de aanvaller de server verlaat.",
                rescueEnabledLabel = "Reddingsacties toestaan",
                rescueEnabledDescription = "Laat onschuldige spelers een vastgebonden slachtoffer bevrijden.",
                rescueSecondsLabel = "Reddingsduur",
                rescueSecondsDescription = "Aantal seconden dat een redder nodig heeft om het slachtoffer los te maken.",
                rescueItemLabel = "Reddingsitem",
                rescueItemDescription = "Item dat een redder nodig heeft. Leeg laten om niets te vereisen.",
                allowInventoryLabel = "Slachtoffer behoudt inventaris",
                allowInventoryDescription = "Een vastgebonden slachtoffer kan nog steeds zijn inventaris openen.",
                dispatchEnabledLabel = "Politie-meldingen inschakelen",
                dispatchEnabledDescription = "Meld ontvoeringen en verhoren bij de hulpdiensten.",
                dispatchAdapterLabel = "Meldingssysteem",
                dispatchAdapterDescription = "Welk dispatch-systeem de meldingen ontvangt.",
                dispatchJobsLabel = "Ontvangende jobs",
                dispatchJobsDescription = "Jobs die de melding ontvangen.",
                dispatchGrabChanceLabel = "Kans bij overmeesteren",
                dispatchGrabChanceDescription = "Percentage kans dat een overmeestering wordt gemeld.",
                dispatchFixateChanceLabel = "Kans bij vastbinden",
                dispatchFixateChanceDescription = "Percentage kans dat het vastbinden van iemand aan een stoel wordt gemeld.",
                dispatchToolChanceLabel = "Kans bij gebruik gereedschap",
                dispatchToolChanceDescription = "Percentage kans dat het gebruik van gereedschap wordt gemeld.",
                dispatchWitnessLabel = "Getuige vereist",
                dispatchWitnessDescription = "Alleen melden wanneer een andere speler dichtbij genoeg is om het op te merken.",
                dispatchWitnessRadiusLabel = "Getuigenradius",
                dispatchWitnessRadiusDescription = "Hoe dicht een getuige moet zijn, in meters.",
                dispatchCooldownLabel = "Cooldown meldingen",
                dispatchCooldownDescription = "Seconden tussen twee meldingen uit dezelfde sessie.",
                dispatchInaccuracyLabel = "Positienauwkeurigheid",
                dispatchInaccuracyDescription = "Aantal meters waarmee de gemelde positie willekeurig wordt verschoven. 0 rapporteert de exacte locatie.",
                loggingEnabledLabel = "Logging inschakelen",
                loggingEnabledDescription = "Registreert plaatsingen, overmeesteringen, gebruik van gereedschap, vrijlatingen en admin-acties.",
                logDatabaseLabel = "Loggen in database",
                logDatabaseDescription = "Schrijft elke invoer aanvullend naar de verhoor-logtabel.",
                logRetentionLabel = "Log-invoer bewaren",
                logRetentionDescription = "Aantal dagen voordat database-logs worden verwijderd. 0 bewaart ze voor altijd.",
                pingToleranceLabel = "Afstandstolerantie",
                pingToleranceDescription = "Aantal meters dat wordt toegevoegd aan elke server-side afstandcontrole om lag op te vangen.",
                violationThresholdLabel = "Drempelwaarde overtredingen",
                violationThresholdDescription = "Aantal beveiligingsovertredingen binnen het tijdsbestek voordat de reactie wordt uitgevoerd. 0 schakelt dit uit.",
                violationActionLabel = "Reactie op overtredingen",
                violationActionDescription = "Wat er gebeurt zodra een speler de drempelwaarde voor overtredingen overschrijdt.",
                violationActionNone = "Niets doen",
                violationActionLog = "Alleen loggen",
                violationActionKick = "Kicken",
                violationActionCheating = "Rapporteren als cheaten",
                particlesLabel = "Partikeleffecten",
                particlesDescription = "Toon bloed, vonken en vlammen tijdens het gebruik van gereedschap.",
                soundLabel = "Geluidseffecten",
                soundDescription = "Speel gereedschapsgeluiden af voor iedereen in de buurt.",
                cameraWorkLabel = "Camerawerk",
                cameraWorkDescription = "Beweeg de camera bij het vastbinden van iemand en tijdens het gebruik van gereedschap.",
                screenEffectsLabel = "Schermeffecten",
                screenEffectsDescription = "Schudden, flitsen, vervagen en kleureffecten op het scherm van het slachtoffer.",
                objectsSection = "Verhoorobjecten",
                objectsEntry = "Voorwerp",
                objectsEditLabel = "Verhoorobjecten",
                objectsEditDescription = "Plaats permanente stoelen en gereedschapswagens op de kaart.",
                objectsEditButton = "Objecten bewerken",
                objectsKindLabel = "Objecttype",
                objectsKindChair = "Stoel",
                objectsKindCart = "Werkstattwagen",
                objectsModelLabel = "Prop-model",
                objectsPositionLabel = "Positie",
                blockedZonesSection = "Sperrzones",
                blockedZonesEntry = "Gebied",
                blockedZonesEditLabel = "Sperrzones",
                blockedZonesEditDescription = "Gebieden waar geen verhorobject geplaatst mag worden.",
                blockedZonesEditButton = "Zones bewerken",
                blockedZonesZoneLabel = "Zone-omtrek",
                blockedZonesZoneDescription = "Sleep de hoeken om het gebied te vormen waar plaatsing is geweigerd.",
                toolsSection = "Gereedschap",
                toolsEntry = "Gereedschap",
                toolsEditLabel = "Gereedschap",
                toolsEditDescription = "Voeg gereedschappen toe of pas ze aan die op een slachtoffer gebruikt kunnen worden.",
                toolsEditButton = "Gereedschappen bewerken",
                toolsItemLabel = "Vereist item",
                toolsConsumeLabel = "Item gebruiken",
                toolsDamageLabel = "Schade per gebruik",
                toolsHealthFloorLabel = "Gezondheidsminimum",
                toolsCooldownLabel = "Cooldown in seconden",
                toolsProgressLabel = "Voortgang per gebruik",
                sessionsSection = "Lopende sessies",
                sessionsEntry = "Verhoor",
                sessionsEditLabel = "Lopende sessies",
                sessionsEditDescription = "Bekijk wie er momenteel wordt verhoord en beëindig de sessie indien nodig.",
                sessionsEditButton = "Sessies tonen",
                sessionsStateLabel = "Status",
                sessionsProgressLabel = "Voortgang",
                orphansSection = "Verwaarloosde objecten",
                orphansEntry = "Voorwerp",
                orphansEditLabel = "Verwaarloosde objecten",
                orphansEditDescription = "Verwijder objecten waarvan de eigenaar al lange tijd niet meer gezien is.",
                orphansEditButton = "Opruimen",
                sessionStates = {
                    binding = "Wordt vastgebonden",
                    active = "Actief",
                    ending = "Wordt beëindigd",
                },
            },
        },
    },
}
