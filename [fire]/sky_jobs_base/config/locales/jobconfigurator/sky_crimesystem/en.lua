JobConfigLocales["sky_crimesystem:en"] = {
    Nui = {
        workshopConfig = {
            creatorCommand = "Direct command",
            roleDefaults = {
                title = "Roles",
                description = "Choose the minimum rank for each default permission. Rank permissions saved in the boss menu take precedence.",
                bossHint = "Boss and CoBoss ranks always retain full access.",
                empty = "No ranks are available for this job yet.",
                gradesTitle = "Job ranks",
                noDefault = "No default grant",
                rankOption = "{grade} – {label}",
            },
            weaponDefaultsDescription = "Shared defaults apply to inherited fields. Editing a value on its settings page switches that field to a custom value. Existing entries retain their values.",
            weaponStreetDescription = "When a drug street contact is used, the server can occasionally buy an eligible weapon instead. Selection, price, and payout remain server-authoritative.",
            weaponGroups = {
                general = "General defaults",
                access = "Access defaults",
                collection = "Collection defaults",
                production = "Production defaults",
                market = "Market defaults",
                delivery = "Contract defaults",
                street = "Street weapon sales",
            },
            weaponOptions = {
                scrap_search = "Search scrap heap",
                player = "Per player",
                global = "Global",
                money = "Cash",
                bank = "Bank account",
                black_money = "Black money",
                timing = "Stop the indicator inside the optimal range.",
                precision = "Time each cut inside the precision window.",
                pressure = "Stop the press at its optimal pressure.",
            },

            reputation = {
                remove = "Delete",
                title = "Reputation",
                action = "Action",
                points = "Points per completion",
                enabled = "Enabled",
                search = "Search actions",
                added = "Already added",
                noResults = "No matching actions found.",
                empty = "No actions yet. Use Plus to add an action.",
                name = "Rule name",
                target = "Target (optional)",
            },
            configs = {
                sky_crimesystem = {
                    entries = "Factions",
                    subtitle = "Configure crime jobs and their shared locations.",
                    title = "Crime System",
                },
            },
            creatorSections = {
                mainbaseZones = {
                    entryLabel = "Mainbase",
                    entryPluralLabel = "Mainbases",
                    label = "Mainbase zone",
                },
                presetTerritories = {
                    label = "Preset districts",
                    entryLabel = "Preset district",
                    entryPluralLabel = "Preset districts",
                },
                customTerritories = {
                    label = "Custom territories",
                    entryLabel = "Custom territory",
                    entryPluralLabel = "Custom territories",
                },
                objectsSection = {
                    label = "Interrogation objects",
                    entryLabel = "Object",
                    entryPluralLabel = "Interrogation objects",
                },
                blockedZonesSection = {
                    label = "Blocked zones",
                    entryLabel = "Zone",
                    entryPluralLabel = "Blocked zones",
                },
                toolsSection = {
                    label = "Tools",
                    entryLabel = "Tool",
                    entryPluralLabel = "Tools",
                },
                sessionsSection = {
                    label = "Running sessions",
                    entryLabel = "Session",
                    entryPluralLabel = "Running sessions",
                },
                orphansSection = {
                    label = "Orphaned objects",
                    entryLabel = "Object",
                    entryPluralLabel = "Orphaned objects",
                },
            },
            darknetActions = {
                currentLocation = "Use current location",
            },
            drugSettings = {
                drugGrowthCurve = {
                    description = "Higher values make poor care much slower while preserving strong bonuses for good care.",
                    label = "Care response curve",
                },
                drugGrowthMaxMultiplier = {
                    description = "Maximum growth multiplier reached under excellent conditions.",
                    label = "Perfect care multiplier",
                },
                drugGrowthMinMultiplier = {
                    description = "Growth multiplier used when plant conditions are critically bad.",
                    label = "Critical care multiplier",
                },
                drugGrowthQualityBonusMax = {
                    description = "Maximum additional growth bonus granted by plant quality.",
                    label = "Quality growth bonus",
                },
            },
            errors = {
                invalid_role_permission_defaults = "Choose valid minimum ranks for role permissions.",
                base_raid_locked = "The base is being raided. Its storage locations and configuration are locked.",
                base_storage_outside_zone = "All storage, locker and heist storage points must be inside the base zone.",
                base_zone_invalid_polygon = "Place at least three distinct points without crossing edges, then check the height (3–200 m) and routing bucket.",
                base_zone_point_limit = "A mainbase zone supports at most 64 boundary points.",
                base_zone_required = "Configure a valid mainbase zone for this crime job first.",
                crime_interrogation_invalid_model = "Enter a valid object model.",
                crime_interrogation_invalid_coords = "Place the object at a valid position.",
                crime_interrogation_invalid_zone_points = "Place at least three valid boundary points.",
                crime_interrogation_duplicate_id = "An object with this ID already exists.",
                crime_interrogation_tool_invalid = "Check the tool definition.",
                crime_interrogation_tool_id_invalid = "Enter a valid tool ID.",
                crime_interrogation_tool_label_missing = "Enter a name for the tool.",
                crime_interrogation_effect_missing = "Configure an effect for the tool.",
                crime_interrogation_effect_type_unknown = "Select a supported effect type.",
                crime_interrogation_effect_status_missing = "Specify the status affected by this tool.",
                crime_interrogation_minigame_missing = "Configure a minigame for the tool.",
                crime_interrogation_minigame_type_unknown = "Select a supported minigame type.",
                crime_interrogation_keys_missing = "Configure controls for the tool.",
                crime_interrogation_keys_invalid = "Check the tool's configured controls.",
                crime_interrogation_keys_duplicate = "Assign each tool action and control only once.",
                crime_interrogation_anim_invalid = "Check the tool's animation dictionary and clip.",
                crime_interrogation_anim_missing = "Configure an animation for the tool user.",
                crime_interrogation_occupied = "Someone is already tied to this object.",
                crime_interrogation_not_found = "That is no longer there.",
            },
            extensions = {
                baseZone = {
                    description = "Place 3 to 64 boundary points in order. The lowest placed point sets the bottom; the height extends upward from there. Points are saved as a draft; use Save to apply the zone. Only storage, lockers and heist storage inside the zone are accessible during raids. Points outside do not prevent saving or starting a raid. Existing boundaries remain active until you save.",
                    fields = {
                        bucket = "Routing bucket",
                        configured = "Configured",
                        height = "Height (meters)",
                        radius = "Radius (meters)",
                        x = "Center X",
                        y = "Center Y",
                        z = "Center Z",
                    },
                    label = "Mainbase zone",
                },
                invalidSelection = "Invalid selection: {value}",
            },
            locationDescriptions = {
                crimeStationPosition = "Main point of this job location. If the map blip is enabled under Job → Blips, it appears here.",
            },
            locationTypes = {
                crimeStationPosition = "Location / map blip",
                heistCrafting = "Heist workshop",
                heistStorage = "Heist storage",
            },
            membershipMigration = {
                cancel = "Cancel",
                confirm = "Migrate and save",
                message = "Existing organization memberships will be migrated to the selected model. Normal employment remains separate in independent mode.",
                title = "Change membership model?",
            },
            moneywashActions = {
                currentLocation = "Use current location",
                invalidLocations = "Check IDs, names, interior selections and coordinates. Each location needs a unique ID.",
                position = "Position",
            },
            moneywashBusiness = {
                moneywashBuildNodes = { label = "Build nodes", description = "Place compatible equipment on these nodes. Coordinates are offsets from the selected interior." },
                mwBuildNodes = "Build nodes",
                moneywashPublicEquipment = { label = "Public equipment", description = "Assign washers, generators and fans to public properties and compatible nodes." },
                mwPublicEquipment = "Public equipment",
                moneywashMaterials = { label = "Materials", description = "Use exact inventory item names. Weight is in grams; install missing items in your inventory." },
                mwMaterials = "Materials",
                moneywashMaterialRecipes = { label = "Material recipes", description = "Inputs, outputs and duration apply per unit. Processors reference these recipes." },
                mwMaterialRecipes = "Material recipes",
                moneywashProductionRecipes = { label = "Printing recipes", description = "Paper, ink and stage durations apply per unit. Cash is paid after drying and quality checks." },
                mwProductionRecipes = "Printing recipes",
                moneywashCollectors = { label = "Collectors", description = "Configure yield, tools, cooldown and world position for each collector." },
                mwCollectors = "Collectors",
                moneywashProcessors = { label = "Processors", description = "Choose a material recipe and world position for each processor." },
                mwProcessors = "Processors",

                control = "Control panel",
                editor = {
                    addBusiness = "Add business",
                    addInterior = "Add interior",
                    advanced = "Technical details",
                    asset_ipl = "IPL: Enter the exact IPL name and interior position.",
                    asset_mlo = "MLO: Use the position of an installed interior. Access currently uses the business entrance.",
                    asset_shell = "Shell: Its model resource must be installed and running on the server.",
                    businessHelp = "Name the business, choose its interior and set the purchase price.",
                    businessListHelp = "Manage entrances and purchase prices for your businesses.",
                    businesses = "Businesses",
                    capture = "Set in game",
                    captureOrigin = "Set interior position",
                    chooseInterior = "Choose an interior",
                    coordinates = "Edit coordinates",
                    editSections = "Setup",
                    emptyBusinessHelp = "Link a map entrance to an interior. Your organisations can then purchase the empty business.",
                    emptyBusinesses = "Your first business",
                    emptyInteriorHelp = "Connect an IPL, a shell or an installed MLO, then set the points used by the business.",
                    emptyInteriors = "Your first interior",
                    entranceHelp = "Set the entrance where players should purchase and enter the business.",
                    freecamHelp = "Freecam: WASD move, Q/E up/down, Shift faster, Ctrl slower. Right mouse: look. Drag gizmo, R rotate/move, Enter place, Backspace cancel.",
                    general = "General",
                    heading = "Heading",
                    interiorHelp = "Choose the interior type and its asset.",
                    interiorListHelp = "Prepare empty spaces. Players place their own machines and equipment.",
                    interiors = "Interiors",
                    listEmpty = "No entries yet.",
                    locationTypes = "Location management",
                    newBusiness = "New business",
                    newInterior = "New interior",
                    noResults = "No matching entries.",
                    notSet = "Not set",
                    offsetHelp = "Input values are offsets from the origin. The world position is shown above.",
                    origin = "Origin",
                    originHelp = "Interior position. All other points are relative to it.",
                    originRequired = "Set the interior position under General first.",
                    outsideRange = "Outside the {range}-metre range",
                    point_control = "Move and rotate the wall panel into place with the gizmo. Its confirmed object height is kept exactly. Toggle its marker under Interactions → Money Wash: control panel.",
                    point_entry = "Players arrive and leave here. Leaving automatically returns them to their business entrance outside.",
                    point_position = "This point is outside the business.",
                    point_storage = "Move and rotate the shelf with the gizmo until it rests on the floor. Members access purchased equipment here. Toggle its marker under Interactions → Money Wash: storage.",
                    points = "Points",
                    pointsHelp = "Select a point and set it directly in game.",
                    rangeNote = "A {range}-metre range around the interior origin applies, with no height restriction.",
                    remove = "Remove",
                    repairRange = "Move these points closer to the interior origin.",
                    saveHint = "Apply changes with Save at the top.",
                    search = "Search …",
                    set = "Set",
                    teleport = "Teleport",
                    viewInteriors = "View interiors",
                    visit = "Visit",
                    visitHint = "Move freely. Press Backspace to return to the editor.",
                    visitTitle = "Interior visit",
                },
                entry = "Entry and exit",
                fields = {
                    mode = "Access mode",
                    ownerKind = "Owner type",
                    productionEnabled = "Printing expansion available",
                    feePercent = "Fee (%) / -1 = global",
                    storageCapacity = "Stock capacity (items)",
                    maximumOrders = "Concurrent orders per player",
                    gridPower = "Grid power units / 0 = generator",
                    autoService = "Automatic public maintenance",
                    maximumPendingOutputs = "Maximum pending payouts",
                    placementRange = "Placement radius (m)",
                    placementHeight = "Placement height range (m)",
                    interiorId = "Interior ID",
                    equipmentId = "Equipment ID",
                    nodeId = "Build node ID",
                    generatorNode = "Generator node ID",
                    maxOffset = "Maximum node offset (m)",
                    maxHeight = "Maximum vertical offset (m)",
                    weight = "Item weight (g)",
                    inputItem = "Input material",
                    secondItem = "Second input material",
                    outputItem = "Output material",
                    requiredTool = "Required tool",
                    baseQuality = "Initial quality (%)",
                    minimumQuality = "Minimum quality (%)",
                    inspectionCards = "Inspection cards",
                    inspectionPenalty = "Quality loss per mistake (%)",
                    rejectPercent = "Rejected notes (%)",
                    accessoryModel = "Accessory model",
                    accessoryMaximum = "Maximum visible accessories",
                    accessoryActiveOnly = "Accessories only during processing",
                    animDict = "Animation dictionary",
                    animClip = "Animation clip",
                    cooldown = "Cooldown (seconds)",
                    minimum = "Minimum yield",
                    maximum = "Maximum yield",
                    productionPrice = "Money printing · Purchase price",
                    recipeId = "Recipe ID",
                    inputAmount = "Material / per unit",
                    secondAmount = "Material / per unit",
                    outputAmount = "Material / per unit",
                    paperItem = "Printing paper",
                    inkItem = "Printing ink",
                    paperAmount = "Printing paper / per unit",
                    inkAmount = "Printing ink / per unit",
                    notesPerUnit = "Banknotes / per unit",
                    valuePerNote = "Cash / Banknotes",
                    maximumUnits = "Units (max.)",
                    printSeconds = "Print / per unit (Seconds)",
                    inspectionSeconds = "Inspect / per unit (Seconds)",
                    rinseSeconds = "Rinse / per unit (Seconds)",
                    drySeconds = "Dry / per unit (Seconds)",
                    accessoryUnit = "Banknotes / per unit",
                    accessoryX = "Accessory model · X (m)",
                    accessoryY = "Accessory model · Y (m)",
                    accessoryZ = "Accessory model · Z (m)",
                    accessoryStep = "Accessory model · Z (m)",

                    capacity = "Capacity per cycle",
                    controlHeading = "Control panel heading",
                    controlHeight = "Mounting height above point (m)",
                    controlModel = "Wall panel model",
                    controlX = "Control panel X",
                    controlY = "Control panel Y",
                    controlZ = "Control panel Z",
                    disableSets = "Hidden entity sets (comma separated)",
                    enableSets = "Enabled entity sets (comma separated)",
                    entryX = "Entry offset X",
                    entryY = "Entry offset Y",
                    entryZ = "Entry offset Z",
                    heading = "Facing direction",
                    id = "Unique ID",
                    interior = "Interior",
                    ipl = "IPL name",
                    kind = "Type",
                    label = "Name",
                    model = "Model name",
                    power = "Power units",
                    price = "Purchase price",
                    radius = "Placement radius (m)",
                    repairPrice = "Repair price (0 = free)",
                    seconds = "Cycle duration (seconds)",
                    storageHeading = "Storage point heading",
                    storageModel = "Shelf model",
                    storageX = "Storage point X",
                    storageY = "Storage point Y",
                    storageZ = "Storage point Z",
                    wear = "Wear per cycle (%)",
                    x = "Origin X",
                    y = "Origin Y",
                    z = "Origin Z",
                },
                interactions = {
                    control = "Money Wash: control panel",
                    storage = "Money Wash: storage",
                },
                item = "Entry",
                moneywashBucketStart = {
                    description = "Reserve this range exclusively for Money Wash. Changes apply on the next entry.",
                    label = "Instance range start",
                },
                moneywashEquipment = {
                    description = "Players buy and place devices. Capacity, duration and wear apply to washers. Power is generator supply or device demand. Changes affect new purchases.",
                    label = "Purchasable equipment",
                },
                moneywashInteriors = {
                    description = "Configure empty IPL, shell or MLO interiors. Entry, control panel, storage and build bounds are relative to the origin. Leaving returns players to their business entrance.",
                    label = "Interiors (IPL, shell or MLO)",
                },
                moneywashMaximumEquipment = {
                    description = "Maximum purchased devices and repair kits per business.",
                    label = "Equipment limit",
                },
                moneywashPreviewBucketStart = {
                    description = "Visit adds the player ID to this value for a private admin instance. Reserve it separately from businesses and other resources. Changes apply to the next preview.",
                    label = "Preview instance range start",
                },
                moneywashProperties = {
                    description = "Set an entrance, choose an interior and set the purchase price. Purchased businesses retain their saved interior and layout.",
                    label = "Business entrances",
                },
                moneywashRepairShops = {
                    description = "Set repair shops, teleport to them and set the service price. They sell repair kits and service stored machines.",
                    label = "Shop locations",
                },
                moneywashShops = {
                    description = "Place shops for washers, generators and fans. Orders go to the organization’s selected business.",
                    label = "Shop locations",
                },
                mwEquipment = "Equipment shop",
                mwInteriors = "Empty interiors",
                mwProperties = "Locations",
                mwRepairShops = "Repair shop",
                mwSettings = "Business settings",
                names = {
                    mwPublicLaundry = "Public laundry",
                    mwPaperPulp = "Paper pulp",
                    mwPrintingPaper = "Printing paper",
                    mwPrintingInk = "Printing ink",
                    mwPaperRecipe = "Make printing paper",
                    mwPrintingRecipe = "Standard banknotes",
                    mwPaperCollector = "Paper collector",
                    mwInkCollector = "Ink collector",
                    mwPaperProcessor = "Paper processor",
                    mwPrinter = "Printing press",
                    mwInspectionTable = "Inspection table",
                    mwDryingCabinet = "Drying cabinet",
                    mwNode1 = "1 · Rinse",
                    mwNode2 = "2 · Rinse",
                    mwNode3 = "3 · generator",
                    mwNode4 = "4 · Print",
                    mwNode5 = "5 · Inspect",
                    mwNode6 = "6 · Dry",
                    mwNode7 = "7 · fan",

                    mwInteriorWarehouse = "Empty warehouse",
                },
                options = {
                    private = "Private",
                    public = "Public",
                    faction = "Organization",
                    person = "Character",
                    printer = "Printing press",
                    inspection = "Inspection table",
                    dryer = "Drying cabinet",

                    fan = "Fan",
                    generator = "Generator",
                    ipl = "IPL",
                    mlo = "MLO",
                    repair = "Repair kit",
                    shell = "Shell model",
                    washer = "Washing machine",
                },
                origin = "Origin",
                storage = "Storage point",
            },
            settingFields = {
                cultivationLevel = "Cultivation level",
                cultivationTitle = "Level title",
                cultivationRequiredXp = "Required total XP",
                cultivationAction = "Action",
                cultivationXp = "XP",
                cultivationCategory = "Category",
                cultivationEntry = "Entry",
                cultivationRequiredLevel = "Required level",
                alias = "Alias",
                atmHeading = "Heading",
                atmId = "ID",
                atmModel = "ATM model",
                centerX = "Center X",
                centerY = "Center Y",
                centerZ = "Center Z",
                deliveryMethod = "Delivery method",
                description = "Description",
                enabled = "Enabled",
                groupKey = "Group key",
                id = "ID",
                itemLabel = "Goods label",
                itemName = "Inventory item name",
                knownScammer = "Known scammer",
                locationName = "Location name",
                observerW = "Observer heading",
                observerX = "Observer X",
                observerY = "Observer Y",
                observerZ = "Observer Z",
                pedModel = "NPC ped model",
                pickpocketItemChance = "Chance (%)",
                pickpocketItemMaximum = "Maximum amount",
                pickpocketItemMinimum = "Minimum amount",
                pickpocketItemName = "Inventory item name",
                quantity = "Quantity",
                radius = "Radius",
                rating = "Displayed rating",
                ratingCount = "Displayed rating count",
                scamChance = "Trader scam chance (%)",
                shopCategory = "Category",
                shopClerkHeading = "Clerk heading",
                shopClerkModel = "Clerk model",
                shopClerkRequired = "Clerk required",
                shopClerkX = "Clerk X",
                shopClerkY = "Clerk Y",
                shopClerkZ = "Clerk Z",
                shopCodeEnabled = "Allow opening with code",
                shopDrillEnabled = "Allow drilling",
                shopEnabled = "Enabled",
                shopHackEnabled = "Allow hacking",
                shopLocationId = "Shop ID",
                shopLocationLabel = "Label",
                shopRegisterId = "Register ID",
                shopSafeEnabled = "Safe enabled",
                shopSafeHeading = "Safe heading",
                shopSafeX = "Safe X",
                shopSafeY = "Safe Y",
                shopSafeZ = "Safe Z",
                side = "Market side",
                spawns = "Team spawns",
                successfulTrades = "Displayed successful trades",
                title = "Offer title",
                unitPrice = "Unit price",
                verified = "Verified trader",
                w = "Heading",
                x = "X",
                y = "Y",
                z = "Z",
                shopClerkPosition = "Clerk position",
                shopRegisterPosition = "Register position",
                shopSafePosition = "Safe position",
                registerId = "Cash register ID",
                registerX = "Cash register X",
                registerY = "Cash register Y",
                registerZ = "Cash register Z",
                heading = "Heading",
                captureLocation = "Capture location",
            },
            crimeDashboard = {
                jobs = "Manage factions, members, permissions and locations.",
                jobCreator = "Select a faction to edit its locations and areas.",
                jobsQuestion = "Where do I edit factions and locations?",
                jobsAnswer = "Open {path}, select a faction and choose Edit. Configure its settings and locations there.",
                creatorsAnswer = "Find creators under {path}. These links open the editor; faction tools start with faction selection.",
                missingAnswer = "Creator availability follows the selected resource and its settings. Faction tools start with the relevant faction.",
                creators = {
                    mainbaseZones = "Select a faction and configure its base zone.",
                    presetTerritories = "Review preset districts and choose which are enabled.",
                    objectsSection = "Manage permanent interrogation chairs and tool carts.",
                    blockedZonesSection = "Define areas where interrogation objects cannot be placed.",
                    toolsSection = "Configure the tools available during interrogations.",
                    sessionsSection = "View active interrogations and end sessions when needed.",
                    orphansSection = "Review and remove abandoned interrogation objects.",
                },
            },
            crimeGroupDescriptions = {
                general = {
                    crimeMembership = "Choose how crime organizations store and manage their members.",
                },
                territories = {
                    zones = "Configure \"Territory zones\" in the \"Territories\" section.",
                    ownership = "Configure \"Ownership\" in the \"Territories\" section.",
                    decay = "Configure \"Decay\" in the \"Territories\" section.",
                    presence = "Configure \"Presence\" in the \"Territories\" section.",
                    activity = "Configure \"Activity scoring\" in the \"Territories\" section.",
                    ownershipBenefits = "Configure \"Ownership benefits\" in the \"Territories\" section.",
                },
                graffiti = {
                    general = "Configure \"General\" in the \"Graffiti\" section.",
                    streaming = "Configure \"Rendering\" in the \"Graffiti\" section.",
                    moderation = "Configure \"Moderation\" in the \"Graffiti\" section.",
                },
                pvpEvents = {
                    pvpAvailability = "Control whether the PvP event app is available and where it appears.",
                    pvpAutomation = "Configure recurring event and automatic start processing.",
                    pvpRuntime = "Tune request handling, deaths, and respawns during live matches.",
                    pvpModes = "Configure the game mode preselected in the PvP tablet.",
                    pvpArenas = "Create the circular zone, observer point, and team spawn points used by PvP events.",
                    pvpLimits = "Set reward and tablet history limits.",
                    pvpPermissions = "Map event management and finances to ACE and job permissions.",
                    pvpTakeoverRules = "Control availability and participation requirements for laboratory and camper takeovers.",
                    pvpTakeoverZones = "Configure interaction, alert, and capture areas together with their durations.",
                    pvpTakeoverMethods = "Configure how long each method takes to breach an entrance.",
                },
                drugs = {
                    creator = "Open the Sky Crime Drug Creator menu and close the Job Configurator.",
                    creatorSettings = "Configure \"Creator Settings\" in the \"Drug System\" section.",
                    interfaceHud = "Configure \"Interface Positions\" in the \"Drug System\" section.",
                    drugsGeneral = "Configure \"General\" in the \"Drug System\" section.",
                    runtimeAccess = "Configure \"Access & Ownership\" in the \"Drug System\" section.",
                    runtimePayouts = "Configure \"Payouts\" in the \"Drug System\" section.",
                    runtimeDispatch = "Configure \"Dispatch & Police\" in the \"Drug System\" section.",
                    performanceInactiveControlIntervalMs = "Runtime setting for Performance / Inactive Control Interval Ms.",
                    performanceInteractionIdleScanIntervalMs = "Runtime setting for Performance / Interaction Idle Scan Interval Ms.",
                    performanceInteractionPromptIntervalMs = "Runtime setting for Performance / Interaction Prompt Interval Ms.",
                    performanceInteractionScanIntervalMs = "Runtime setting for Performance / Interaction Scan Interval Ms.",
                    performanceMinimumScanIntervalMs = "Runtime setting for Performance / Minimum Scan Interval Ms.",
                    performanceStreetPedActivationDistance = "Runtime setting for Performance / Street Ped Activation Distance.",
                    performanceStreetPedIdleScanIntervalMs = "Runtime setting for Performance / Street Ped Idle Scan Interval Ms.",
                    performanceStreetPedScanIntervalMs = "Runtime setting for Performance / Street Ped Scan Interval Ms.",
                    performanceWorldCachePadding = "Runtime setting for Performance / World Cache Padding.",
                    performanceWorldCacheRefreshIntervalMs = "Runtime setting for Performance / World Cache Refresh Interval Ms.",
                    performanceWorldIdleIntervalMs = "Runtime setting for Performance / World Idle Interval Ms.",
                },
                drugProduction = {
                    qualityWeights = "Configure \"Quality Weights\" in the \"Drug Production\" section.",
                    qualityTiers = "Configure \"Quality Tiers\" in the \"Drug Production\" section.",
                    packagingGeneral = "Configure \"General\" in the \"Drug Production\" section.",
                    processingFlow = "Configure \"Process Flow\" in the \"Drug Production\" section.",
                    processingGeneral = "Configure \"General\" in the \"Drug Production\" section.",
                },
                drugOperations = {
                    growingGeneral = "Configure \"General\" in the \"Drug Operations\" section.",
                    plantDefaults = "Configure \"Plant Defaults\" in the \"Drug Operations\" section.",
                    harvestWindow = "Configure \"Harvest Window\" in the \"Drug Operations\" section.",
                    labsGeneral = "Enable lab and camper runtime instances.",
                    labRent = "Configure \"Rent & Lifecycle\" in the \"Drug Operations\" section.",
                    camperDefaults = "Configure \"Camper\" in the \"Drug Operations\" section.",
                    labUpgrades = "Multiplier used when calculating lab tier upgrade prices.",
                    labDefaults = "Configure \"Lab Defaults\" in the \"Drug Operations\" section.",
                    powerGeneral = "Configure \"General\" in the \"Drug Operations\" section.",
                    generators = "Configure \"Generators\" in the \"Drug Operations\" section.",
                    equipmentWear = "Global multiplier for equipment wear caused by processing.",
                    workersGeneral = "Configure \"General\" in the \"Drug Operations\" section.",
                    cultivationGeneral = "Configure \"General\" in the \"Drug Operations\" section.",
                    cultivationCurve = "Configure the title and total XP threshold for every cultivation level.",
                    cultivationExperience = "Configure how much cultivation XP each growing action awards.",
                    cultivationUnlocks = "Configure the required cultivation level for containers, substrates, equipment, strains and scanner tiers.",
                    powerRuntime = "Seconds between generator consumption and power signature updates.",
                    powerHeat = "Configure \"Heat & Signature\" in the \"Drug Operations\" section.",
                    powerModes = "Configure \"Management Modes\" in the \"Drug Operations\" section.",
                    powerPriorities = "Configure \"Load Priorities\" in the \"Drug Operations\" section.",
                },
                drugMarketRisk = {
                    marketGeneral = "Configure \"General\" in the \"Market & Risk\" section.",
                    marketPrices = "Configure \"Prices\" in the \"Market & Risk\" section.",
                    distribution = "Configure \"Distribution\" in the \"Market & Risk\" section.",
                    threatsGeneral = "Configure \"General\" in the \"Market & Risk\" section.",
                    threatHeat = "Configure \"Heat\" in the \"Market & Risk\" section.",
                    threatChances = "Configure \"Chances\" in the \"Market & Risk\" section.",
                    consumptionGeneral = "Configure \"General\" in the \"Market & Risk\" section.",
                    consumerDecay = "Configure \"Tolerance & Addiction Decay\" in the \"Market & Risk\" section.",
                    consumerEffects = "Configure \"Effects & Risk\" in the \"Market & Risk\" section.",
                },
                drugNetworks = {
                    dynamicMarketActionCooldownSeconds = "Runtime setting for Dynamic Market / Action Cooldown Seconds.",
                    dynamicMarketActionHistoryLimit = "Runtime setting for Dynamic Market / Action History Limit.",
                    dynamicMarketAmountSaturationWeight = "Runtime setting for Dynamic Market / Amount Saturation Weight.",
                    dynamicMarketBaseIntelAccuracy = "Runtime setting for Dynamic Market / Base Intel Accuracy.",
                    dynamicMarketDefaultAverageQuality = "Runtime setting for Dynamic Market / Default Average Quality.",
                    dynamicMarketDefaultResourceElasticity = "Runtime setting for Dynamic Market / Default Resource Elasticity.",
                    dynamicMarketDemandCenter = "Runtime setting for Dynamic Market / Demand Center.",
                    dynamicMarketDemandPriceImpact = "Runtime setting for Dynamic Market / Demand Price Impact.",
                    dynamicMarketDirectionThreshold = "Runtime setting for Dynamic Market / Direction Threshold.",
                    dynamicMarketEnabled = "Runtime setting for Dynamic Market / Enabled.",
                    dynamicMarketEventChance = "Runtime setting for Dynamic Market / Event Chance.",
                    dynamicMarketEventDurationMinutes = "Runtime setting for Dynamic Market / Event Duration Minutes.",
                    dynamicMarketEventMinimumDurationMinutes = "Runtime setting for Dynamic Market / Event Minimum Duration Minutes.",
                    dynamicMarketEventStrengthMaximum = "Runtime setting for Dynamic Market / Event Strength Maximum.",
                    dynamicMarketEventStrengthMinimum = "Runtime setting for Dynamic Market / Event Strength Minimum.",
                    dynamicMarketEvents = "Configure \"Events\" in the \"Drug Networks\" section.",
                    dynamicMarketExactIntelReputation = "Runtime setting for Dynamic Market / Exact Intel Reputation.",
                    dynamicMarketExactIntelTrust = "Runtime setting for Dynamic Market / Exact Intel Trust.",
                    dynamicMarketGlobalZoneLabel = "Runtime setting for Dynamic Market / Global Zone Label.",
                    dynamicMarketHistoryLimit = "Runtime setting for Dynamic Market / History Limit.",
                    dynamicMarketInitialDemand = "Runtime setting for Dynamic Market / Initial Demand.",
                    dynamicMarketInitialPriceMultiplier = "Runtime setting for Dynamic Market / Initial Price Multiplier.",
                    dynamicMarketIntelDemandError = "Runtime setting for Dynamic Market / Intel Demand Error.",
                    dynamicMarketIntelMaximumAccuracy = "Runtime setting for Dynamic Market / Intel Maximum Accuracy.",
                    dynamicMarketIntelMinimumAccuracy = "Runtime setting for Dynamic Market / Intel Minimum Accuracy.",
                    dynamicMarketIntelPoliceError = "Runtime setting for Dynamic Market / Intel Police Error.",
                    dynamicMarketIntelPriceError = "Runtime setting for Dynamic Market / Intel Price Error.",
                    dynamicMarketIntelPriceMaximum = "Runtime setting for Dynamic Market / Intel Price Maximum.",
                    dynamicMarketIntelPriceMinimum = "Runtime setting for Dynamic Market / Intel Price Minimum.",
                    dynamicMarketIntelReputationWeight = "Runtime setting for Dynamic Market / Intel Reputation Weight.",
                    dynamicMarketIntelResourcePriceError = "Runtime setting for Dynamic Market / Intel Resource Price Error.",
                    dynamicMarketIntelSaturationError = "Runtime setting for Dynamic Market / Intel Saturation Error.",
                    dynamicMarketIntelSeedBucketSeconds = "Runtime setting for Dynamic Market / Intel Seed Bucket Seconds.",
                    dynamicMarketIntelStatusAccuracyThreshold = "Runtime setting for Dynamic Market / Intel Status Accuracy Threshold.",
                    dynamicMarketIntelStatusErrorThreshold = "Runtime setting for Dynamic Market / Intel Status Error Threshold.",
                    dynamicMarketIntelSupplyError = "Runtime setting for Dynamic Market / Intel Supply Error.",
                    dynamicMarketIntelTrustWeight = "Runtime setting for Dynamic Market / Intel Trust Weight.",
                    dynamicMarketManipulationCooldownMinutes = "Runtime setting for Dynamic Market / Manipulation Cooldown Minutes.",
                    dynamicMarketManipulationDemandShift = "Runtime setting for Dynamic Market / Manipulation Demand Shift.",
                    dynamicMarketManipulationDurationMinutes = "Runtime setting for Dynamic Market / Manipulation Duration Minutes.",
                    dynamicMarketManipulationHeat = "Runtime setting for Dynamic Market / Manipulation Heat.",
                    dynamicMarketManipulationMinimumBatchAmount = "Runtime setting for Dynamic Market / Manipulation Minimum Batch Amount.",
                    dynamicMarketManipulationPaymentAccount = "Runtime setting for Dynamic Market / Manipulation Payment Account.",
                    dynamicMarketManipulationPrice = "Runtime setting for Dynamic Market / Manipulation Price.",
                    dynamicMarketManipulationZoneHeatMultiplier = "Runtime setting for Dynamic Market / Manipulation Zone Heat Multiplier.",
                    dynamicMarketMaximumIntelAgeMinutes = "Runtime setting for Dynamic Market / Maximum Intel Age Minutes.",
                    dynamicMarketMaximumPriceMultiplier = "Runtime setting for Dynamic Market / Maximum Price Multiplier.",
                    dynamicMarketMinimumIntelAgeMinutes = "Runtime setting for Dynamic Market / Minimum Intel Age Minutes.",
                    dynamicMarketMinimumMetricWindowMinutes = "Runtime setting for Dynamic Market / Minimum Metric Window Minutes.",
                    dynamicMarketMinimumPriceMultiplier = "Runtime setting for Dynamic Market / Minimum Price Multiplier.",
                    dynamicMarketMinimumUpdateMinutes = "Runtime setting for Dynamic Market / Minimum Update Minutes.",
                    dynamicMarketPoliceDemandWeight = "Runtime setting for Dynamic Market / Police Demand Weight.",
                    dynamicMarketPolicePriceImpact = "Runtime setting for Dynamic Market / Police Price Impact.",
                    dynamicMarketPoorQualityDemandPenalty = "Runtime setting for Dynamic Market / Poor Quality Demand Penalty.",
                    dynamicMarketPoorQualityThreshold = "Runtime setting for Dynamic Market / Poor Quality Threshold.",
                    dynamicMarketPremiumQualityDemandBonus = "Runtime setting for Dynamic Market / Premium Quality Demand Bonus.",
                    dynamicMarketPremiumQualityThreshold = "Runtime setting for Dynamic Market / Premium Quality Threshold.",
                    dynamicMarketProductionSupplyWeight = "Runtime setting for Dynamic Market / Production Supply Weight.",
                    dynamicMarketProductionWindowMinutes = "Runtime setting for Dynamic Market / Production Window Minutes.",
                    dynamicMarketQualityCenter = "Runtime setting for Dynamic Market / Quality Center.",
                    dynamicMarketQualityConfidenceImpact = "Runtime setting for Dynamic Market / Quality Confidence Impact.",
                    dynamicMarketQualityRange = "Runtime setting for Dynamic Market / Quality Range.",
                    dynamicMarketRarityBonusMaximum = "Runtime setting for Dynamic Market / Rarity Bonus Maximum.",
                    dynamicMarketRegionalGlobalWeight = "Runtime setting for Dynamic Market / Regional Global Weight.",
                    dynamicMarketRegionalLocalWeight = "Runtime setting for Dynamic Market / Regional Local Weight.",
                    dynamicMarketResourceAliases = "Configure \"Resource Aliases\" in the \"Drug Networks\" section.",
                    dynamicMarketResourceDirectionFallThreshold = "Runtime setting for Dynamic Market / Resource Direction Fall Threshold.",
                    dynamicMarketResourceDirectionRiseThreshold = "Runtime setting for Dynamic Market / Resource Direction Rise Threshold.",
                    dynamicMarketResources = "Configure \"Resources\" in the \"Drug Networks\" section.",
                    dynamicMarketSalesWindowMinutes = "Runtime setting for Dynamic Market / Sales Window Minutes.",
                    dynamicMarketSaturationDemandWeight = "Runtime setting for Dynamic Market / Saturation Demand Weight.",
                    dynamicMarketSaturationPriceImpact = "Runtime setting for Dynamic Market / Saturation Price Impact.",
                    dynamicMarketScarcityDemandWeight = "Runtime setting for Dynamic Market / Scarcity Demand Weight.",
                    dynamicMarketScarcityPriceImpact = "Runtime setting for Dynamic Market / Scarcity Price Impact.",
                    dynamicMarketSeasonEndMonths = "Configure \"Season End Months\" in the \"Drug Networks\" section.",
                    dynamicMarketSeasonMultipliers = "Configure \"Season Multipliers\" in the \"Drug Networks\" section.",
                    dynamicMarketShortageRumorThreshold = "Runtime setting for Dynamic Market / Shortage Rumor Threshold.",
                    dynamicMarketStatusThresholds = "Configure \"Status Thresholds\" in the \"Drug Networks\" section.",
                    dynamicMarketTargetSupply = "Runtime setting for Dynamic Market / Target Supply.",
                    dynamicMarketTrendChance = "Runtime setting for Dynamic Market / Trend Chance.",
                    dynamicMarketTrendDurationMinutes = "Runtime setting for Dynamic Market / Trend Duration Minutes.",
                    dynamicMarketTrendMaximumStrength = "Runtime setting for Dynamic Market / Trend Maximum Strength.",
                    dynamicMarketTrendMinimumStrength = "Runtime setting for Dynamic Market / Trend Minimum Strength.",
                    dynamicMarketUpdateMinutes = "Runtime setting for Dynamic Market / Update Minutes.",
                    dynamicMarketVolatilityMaximum = "Runtime setting for Dynamic Market / Volatility Maximum.",
                    dynamicMarketVolatilityMinimum = "Runtime setting for Dynamic Market / Volatility Minimum.",
                    dynamicMarketWeatherMultipliers = "Configure \"Weather Multipliers\" in the \"Drug Networks\" section.",
                    dynamicMarketWeatherState = "Runtime setting for Dynamic Market / Weather State.",
                    heatActionCooldownSeconds = "Runtime setting for Heat & Risk / Action Cooldown Seconds.",
                    heatActivityRiskWeights = "Configure \"Activity Risk Weights\" in the \"Drug Networks\" section.",
                    heatAggressiveHeatMultiplier = "Runtime setting for Heat & Risk / Aggressive Heat Multiplier.",
                    heatBurnerBurnThreshold = "Runtime setting for Heat & Risk / Burner Burn Threshold.",
                    heatBurnerHeatPerWholesale = "Runtime setting for Heat & Risk / Burner Heat Per Wholesale.",
                    heatBurnerPhoneItem = "Runtime setting for Heat & Risk / Burner Phone Item.",
                    heatCamperOperationalHeatMultiplier = "Runtime setting for Heat & Risk / Camper Operational Heat Multiplier.",
                    heatCamperOperationalHeatThreshold = "Runtime setting for Heat & Risk / Camper Operational Heat Threshold.",
                    heatCamperParkedHeat = "Runtime setting for Heat & Risk / Camper Parked Heat.",
                    heatContaminatedHeatMultiplier = "Runtime setting for Heat & Risk / Contaminated Heat Multiplier.",
                    heatContaminatedThreshold = "Runtime setting for Heat & Risk / Contaminated Threshold.",
                    heatCultivationFreePlants = "Runtime setting for Heat & Risk / Cultivation Free Plants.",
                    heatCultivationHeatPerPlant = "Runtime setting for Heat & Risk / Cultivation Heat Per Plant.",
                    heatDealerHiddenMinutes = "Runtime setting for Heat & Risk / Dealer Hidden Minutes.",
                    heatDecayPerTick = "Configure \"Decay Per Tick\" in the \"Drug Networks\" section.",
                    heatEnabled = "Runtime setting for Heat & Risk / Enabled.",
                    heatEnforcementHeat = "Configure \"Enforcement Heat\" in the \"Drug Networks\" section.",
                    heatEnforcementMultipliers = "Configure \"Enforcement Multipliers\" in the \"Drug Networks\" section.",
                    heatEntityTypes = "Configure \"Entity Types\" in the \"Drug Networks\" section.",
                    heatEventCooldownMinutes = "Runtime setting for Heat & Risk / Event Cooldown Minutes.",
                    heatEventHistoryLimit = "Runtime setting for Heat & Risk / Event History Limit.",
                    heatLabHeatSyncThreshold = "Runtime setting for Heat & Risk / Lab Heat Sync Threshold.",
                    heatLayLowCooldownMinutes = "Runtime setting for Heat & Risk / Lay Low Cooldown Minutes.",
                    heatLayLowIdleMinutes = "Runtime setting for Heat & Risk / Lay Low Idle Minutes.",
                    heatLayLowReduction = "Runtime setting for Heat & Risk / Lay Low Reduction.",
                    heatLockdownMinutes = "Runtime setting for Heat & Risk / Lockdown Minutes.",
                    heatMinimumDurationMinutes = "Runtime setting for Heat & Risk / Minimum Duration Minutes.",
                    heatMinimumEventCooldownSeconds = "Runtime setting for Heat & Risk / Minimum Event Cooldown Seconds.",
                    heatMinimumIdleSeconds = "Runtime setting for Heat & Risk / Minimum Idle Seconds.",
                    heatProcessingHeatMultiplier = "Runtime setting for Heat & Risk / Processing Heat Multiplier.",
                    heatRiskWeights = "Configure \"Risk Weights\" in the \"Drug Networks\" section.",
                    heatRotateBurnerReduction = "Runtime setting for Heat & Risk / Rotate Burner Reduction.",
                    heatRouteControlMinutes = "Runtime setting for Heat & Risk / Route Control Minutes.",
                    heatSaleHeat = "Configure \"Sale Heat\" in the \"Drug Networks\" section.",
                    heatThresholds = "Configure \"Thresholds\" in the \"Drug Networks\" section.",
                    heatTickMinutes = "Runtime setting for Heat & Risk / Tick Minutes.",
                    heatWholesaleHeatMultiplier = "Runtime setting for Heat & Risk / Wholesale Heat Multiplier.",
                    heatWorkerLeakAlertRadius = "Runtime setting for Heat & Risk / Worker Leak Alert Radius.",
                    heatWorkerLeakBaseChance = "Runtime setting for Heat & Risk / Worker Leak Base Chance.",
                    heatWorkerLeakFactionMultiplier = "Runtime setting for Heat & Risk / Worker Leak Faction Multiplier.",
                    heatWorkerLeakHighSeverityThreshold = "Runtime setting for Heat & Risk / Worker Leak High Severity Threshold.",
                    heatWorkerLeakLoyaltyChanceMultiplier = "Runtime setting for Heat & Risk / Worker Leak Loyalty Chance Multiplier.",
                    heatWorkerLeakLoyaltyThreshold = "Runtime setting for Heat & Risk / Worker Leak Loyalty Threshold.",
                    heatWorkerLeakMaximumChance = "Runtime setting for Heat & Risk / Worker Leak Maximum Chance.",
                    heatWorkerLeakMinimumCooldownSeconds = "Runtime setting for Heat & Risk / Worker Leak Minimum Cooldown Seconds.",
                    heatWorkerLeakRouteMultiplier = "Runtime setting for Heat & Risk / Worker Leak Route Multiplier.",
                    heatWorkerLeakStrengthMaximum = "Runtime setting for Heat & Risk / Worker Leak Strength Maximum.",
                    heatWorkerLeakStrengthMinimum = "Runtime setting for Heat & Risk / Worker Leak Strength Minimum.",
                    heatWorkerLeakStrengthMultiplier = "Runtime setting for Heat & Risk / Worker Leak Strength Multiplier.",
                    heatWorkerLeakStressChanceMultiplier = "Runtime setting for Heat & Risk / Worker Leak Stress Chance Multiplier.",
                    heatWorkerLeakStressThreshold = "Runtime setting for Heat & Risk / Worker Leak Stress Threshold.",
                    contactsActionCooldownSeconds = "Runtime setting for Contact Network / Action Cooldown Seconds.",
                    contactsActiveHotspotCount = "Runtime setting for Contact Network / Active Hotspot Count.",
                    contactsBurnerHintTrust = "Runtime setting for Contact Network / Burner Hint Trust.",
                    contactsBurnerOfferMaximumMultiplier = "Runtime setting for Contact Network / Burner Offer Maximum Multiplier.",
                    contactsBurnerOfferMinimumMultiplier = "Runtime setting for Contact Network / Burner Offer Minimum Multiplier.",
                    contactsBuyerCooldownMinutes = "Runtime setting for Contact Network / Buyer Cooldown Minutes.",
                    contactsBuyerDeliveryDistance = "Runtime setting for Contact Network / Buyer Delivery Distance.",
                    contactsBuyerPremiumSuccessScore = "Runtime setting for Contact Network / Buyer Premium Success Score.",
                    contactsBuyerPremiumTrustGain = "Runtime setting for Contact Network / Buyer Premium Trust Gain.",
                    contactsBuyerRequestHeatRiskWeight = "Runtime setting for Contact Network / Buyer Request Heat Risk Weight.",
                    contactsBuyerStandardTrustGain = "Runtime setting for Contact Network / Buyer Standard Trust Gain.",
                    contactsContactActiveDelaySeconds = "Configure \"Contact Active Delay Seconds\" in the \"Drug Networks\" section.",
                    contactsContactDemandRange = "Configure \"Contact Demand Range\" in the \"Drug Networks\" section.",
                    contactsContactLossTrust = "Runtime setting for Contact Network / Contact Loss Trust.",
                    contactsDarknetExactIntelMinutes = "Runtime setting for Contact Network / Darknet Exact Intel Minutes.",
                    contactsDarknetHotspotIntelPrice = "Runtime setting for Contact Network / Darknet Hotspot Intel Price.",
                    contactsDarknetIntelPrice = "Runtime setting for Contact Network / Darknet Intel Price.",
                    contactsDealerBasePrice = "Runtime setting for Contact Network / Dealer Base Price.",
                    contactsDealerHireCapacity = "Configure \"Dealer Hire Capacity\" in the \"Drug Networks\" section.",
                    contactsDealerHireRisk = "Configure \"Dealer Hire Risk\" in the \"Drug Networks\" section.",
                    contactsDealerHireSkill = "Configure \"Dealer Hire Skill\" in the \"Drug Networks\" section.",
                    contactsDealerOffers = "Configure \"Dealer Offers\" in the \"Drug Networks\" section.",
                    contactsDealerProtectionHours = "Runtime setting for Contact Network / Dealer Protection Hours.",
                    contactsDealerProtectionPrice = "Runtime setting for Contact Network / Dealer Protection Price.",
                    contactsDealerSaleMax = "Runtime setting for Contact Network / Dealer Sale Max.",
                    contactsDealerSaleMin = "Runtime setting for Contact Network / Dealer Sale Min.",
                    contactsDealerSimulation = "Configure \"Dealer Simulation\" in the \"Drug Networks\" section.",
                    contactsDealerTickMinutes = "Runtime setting for Contact Network / Dealer Tick Minutes.",
                    contactsDealerWage = "Runtime setting for Contact Network / Dealer Wage.",
                    contactsDealerWageDecay = "Runtime setting for Contact Network / Dealer Wage Decay.",
                    contactsDealerWageLoyaltyGain = "Runtime setting for Contact Network / Dealer Wage Loyalty Gain.",
                    contactsDealerWeaknesses = "Configure \"Dealer Weaknesses\" in the \"Drug Networks\" section.",
                    contactsDefaultContactDemand = "Runtime setting for Contact Network / Default Contact Demand.",
                    contactsDefaultContactRisk = "Runtime setting for Contact Network / Default Contact Risk.",
                    contactsDefaultDealerCapacity = "Runtime setting for Contact Network / Default Dealer Capacity.",
                    contactsDefaultDealerRisk = "Runtime setting for Contact Network / Default Dealer Risk.",
                    contactsDefaultDealerSkill = "Runtime setting for Contact Network / Default Dealer Skill.",
                    contactsDefaultHotspotRadius = "Runtime setting for Contact Network / Default Hotspot Radius.",
                    contactsDemandResetMinutes = "Runtime setting for Contact Network / Demand Reset Minutes.",
                    contactsEnabled = "Runtime setting for Contact Network / Enabled.",
                    contactsExactLocationTrust = "Runtime setting for Contact Network / Exact Location Trust.",
                    contactsFactionDiscoveryReputation = "Runtime setting for Contact Network / Faction Discovery Reputation.",
                    contactsFactionHintTrust = "Runtime setting for Contact Network / Faction Hint Trust.",
                    contactsFailedDeliveryCooldownMinutes = "Runtime setting for Contact Network / Failed Delivery Cooldown Minutes.",
                    contactsFakeDealEncounter = "Configure \"Fake Deal Encounter\" in the \"Drug Networks\" section.",
                    contactsFallbackPreferredDrug = "Runtime setting for Contact Network / Fallback Preferred Drug.",
                    contactsFallbackProductLabel = "Runtime setting for Contact Network / Fallback Product Label.",
                    contactsGuideBookItem = "Runtime setting for Contact Network / Guide Book Item.",
                    contactsGuideBookTrust = "Runtime setting for Contact Network / Guide Book Trust.",
                    contactsHireDealerPrice = "Runtime setting for Contact Network / Hire Dealer Price.",
                    contactsHistoryLimit = "Runtime setting for Contact Network / History Limit.",
                    contactsHotspotIntelMinutes = "Runtime setting for Contact Network / Hotspot Intel Minutes.",
                    contactsHotspotRotationMinutes = "Runtime setting for Contact Network / Hotspot Rotation Minutes.",
                    contactsListingDurationMinutes = "Runtime setting for Contact Network / Listing Duration Minutes.",
                    contactsMaxOwnedDealers = "Runtime setting for Contact Network / Max Owned Dealers.",
                    contactsMinimumBuyerDeliveryDistance = "Runtime setting for Contact Network / Minimum Buyer Delivery Distance.",
                    contactsMinimumContactRotationMinutes = "Runtime setting for Contact Network / Minimum Contact Rotation Minutes.",
                    contactsMinimumDemandResetMinutes = "Runtime setting for Contact Network / Minimum Demand Reset Minutes.",
                    contactsMinimumHeatMultiplier = "Runtime setting for Contact Network / Minimum Heat Multiplier.",
                    contactsMinimumHotspotIntelMinutes = "Runtime setting for Contact Network / Minimum Hotspot Intel Minutes.",
                    contactsMinimumHotspotRadius = "Runtime setting for Contact Network / Minimum Hotspot Radius.",
                    contactsMinimumHotspotRotationMinutes = "Runtime setting for Contact Network / Minimum Hotspot Rotation Minutes.",
                    contactsMinimumListingDurationMinutes = "Runtime setting for Contact Network / Minimum Listing Duration Minutes.",
                    contactsMinimumRewardMultiplier = "Runtime setting for Contact Network / Minimum Reward Multiplier.",
                    contactsMinimumRobberyMultiplier = "Runtime setting for Contact Network / Minimum Robbery Multiplier.",
                    contactsMinimumSpotPriceMultiplier = "Runtime setting for Contact Network / Minimum Spot Price Multiplier.",
                    contactsOtherDrugPriceMultiplier = "Runtime setting for Contact Network / Other Drug Price Multiplier.",
                    contactsPaymentAccount = "Runtime setting for Contact Network / Payment Account.",
                    contactsPostDeliveryDemandResetSeconds = "Runtime setting for Contact Network / Post Delivery Demand Reset Seconds.",
                    contactsPreferredDrugPriceMultiplier = "Runtime setting for Contact Network / Preferred Drug Price Multiplier.",
                    contactsRegionLocationTrust = "Runtime setting for Contact Network / Region Location Trust.",
                    contactsRequestAmounts = "Configure \"Request Amounts\" in the \"Drug Networks\" section.",
                    contactsRotationMinutes = "Runtime setting for Contact Network / Rotation Minutes.",
                    contactsSpotPools = "Configure \"Spot Pools\" in the \"Drug Networks\" section.",
                    contactsStreetHotspots = "Configure \"Street Hotspots\" in the \"Drug Networks\" section.",
                    contactsTrustLevels = "Configure \"Trust Levels\" in the \"Drug Networks\" section.",
                    businessActionCooldownSeconds = "Runtime setting for Business Network / Action Cooldown Seconds.",
                    businessBalance = "Configure \"Balance\" in the \"Drug Networks\" section.",
                    businessContracts = "Configure \"Contracts\" in the \"Drug Networks\" section.",
                    businessDefaultBusinessName = "Runtime setting for Business Network / Default Business Name.",
                    businessDefaultRankId = "Runtime setting for Business Network / Default Rank Id.",
                    businessDefaultStaffStyle = "Runtime setting for Business Network / Default Staff Style.",
                    businessDefaultTransport = "Runtime setting for Business Network / Default Transport.",
                    businessEnabled = "Runtime setting for Business Network / Enabled.",
                    businessHubs = "Configure \"Hubs\" in the \"Drug Networks\" section.",
                    businessLimits = "Configure \"Limits\" in the \"Drug Networks\" section.",
                    businessPayments = "Choose which balance pays for Business Network purchases and operating costs.",
                    businessPayoutAccount = "Runtime setting for Business Network / Payout Account.",
                    businessRanks = "Configure \"Ranks\" in the \"Drug Networks\" section.",
                    businessReportDays = "Runtime setting for Business Network / Report Days.",
                    businessRouteEndpointTypes = "Configure \"Route Endpoint Types\" in the \"Drug Networks\" section.",
                    businessRuntime = "Configure \"Runtime\" in the \"Drug Networks\" section.",
                    businessSocietyPermission = "Runtime setting for Business Network / Society Permission.",
                    businessStaff = "Configure \"Staff\" in the \"Drug Networks\" section.",
                    businessTickMinutes = "Runtime setting for Business Network / Tick Minutes.",
                    businessTransports = "Configure \"Transports\" in the \"Drug Networks\" section.",
                },
                robbery = {
                    atmAvailability = "Enable or disable the standalone ATM robbery system.",
                    atmLocations = "Manage the server-authorized ATM positions available for robberies.",
                    atmPolice = "Configure the on-duty police requirement for starting a robbery.",
                    atmItems = "Configure the required drill, sling and explosive charge items.",
                    atmActionTimes = "Set the duration of attaching, planting, detonation, and looting actions.",
                    atmTimeouts = "Control how long a breached ATM remains available to loot.",
                    atmPayout = "Configure the target account and random reward range.",
                    atmDistances = "Set the player and vehicle ranges used by ATM interactions.",
                    atmExplosionEffects = "Configure the explosion native parameters used during detonation.",
                    atmDispatchAlert = "Configure radius, lifetime, and priority for the police alert.",
                    atmDispatchRecipients = "Choose which job names receive ATM robbery alerts.",
                    shopAvailability = "Enable robberies and configure the police requirement.",
                    shopTiming = "Configure intimidation, actions, timeout, and cooldown.",
                    shopSafe = "Configure keypad attempts and the drill item.",
                    shopRegisterReward = "Configure the random reward for each register.",
                    shopSafeReward = "Configure the random safe reward.",
                    shopDispatchSettings = "Configure recipients and alert properties.",
                    shopLocationTable = "Manage staffed retail locations and safes.",
                    pickpocketAvailability = "Enable the feature and optionally limit it to configured crime jobs.",
                    pickpocketGameplay = "Choose the challenge and the independent flee, emergency-call, and counterattack probabilities.",
                    pickpocketItemRewards = "Control empty pockets and visible item choices down to 0.0001 percent.",
                    pickpocketMoney = "Configure the server-generated random cash range.",
                    pickpocketDistances = "Set the NPC range used by the shared radial and target system.",
                    pickpocketRateLimits = "Control request throttling, per-NPC cooldown, and session expiry.",
                    pickpocketDispatchSettings = "Configure the alert sent when an NPC calls emergency services.",
                    heistCrafting = "Choose how much interaction is required when crafting heist equipment. Applies to new attempts across the Crime System.",
                    heistCreatorMenu = "Create, edit, and publish modular heists in the dedicated Heist Creator.",
                    heistExecution = "Start window, inactivity and cooldown for heist runs.",
                    npcPoliceSupport = "This feature is temporarily disabled due to stability issues and currently cannot be enabled in the Job Configurator.",
                },
                baseRaids = {
                    baseRaids = "Raid access, requirements and individually selectable loot categories. Open raids have no transport timeout.",
                },
                weapons = {
                    weaponCreatorMenu = "Manage weapon routes and money wash in one creator.",
                    weaponRuntime = "Control availability and access to weapon routes.",
                    weaponDefaultsgeneral = "Configure \"General defaults\" in the \"Weapon Routes\" section.",
                    weaponDefaultsaccess = "Configure \"Access defaults\" in the \"Weapon Routes\" section.",
                    weaponDefaultscollection = "Configure \"Collection defaults\" in the \"Weapon Routes\" section.",
                    weaponDefaultsproduction = "Configure \"Production defaults\" in the \"Weapon Routes\" section.",
                    weaponDefaultsmarket = "Configure \"Market defaults\" in the \"Weapon Routes\" section.",
                    weaponDefaultsdelivery = "Configure \"Contract defaults\" in the \"Weapon Routes\" section.",
                    weaponStreet = "Configure \"Street weapon sales\" in the \"Weapon Routes\" section.",
                },
                darknetMarket = {
                    darknetAvailability = "Controls the tablet app and its placement.",
                    darknetEconomy = "Configures wallet balances, coin exchange and payment rates.",
                    darknetListings = "Controls offer limits, prices and automatic expiry.",
                    darknetChat = "Limits encrypted marketplace messages.",
                    darknetIdentity = "Configures identity rotation, verification and scam warnings.",
                    darknetDelivery = "Configures physical meetings and stealable world crates.",
                    darknetDeliveryLocations = "Configures the location pools randomly assigned to BlackBay NPC trades.",
                    darknetPolice = "Job groups allowed to publish traps and view investigations.",
                    darknetNpcTraders = "Persistent NPC buyers and sellers with configurable risk.",
                },
                interrogation = {
                    general = "Configure \"General\" in the \"Interrogation\" section.",
                    consent = "Configure \"Player protection\" in the \"Interrogation\" section.",
                    objects = "Configure \"Objects\" in the \"Interrogation\" section.",
                    grab = "Configure \"Grabbing\" in the \"Interrogation\" section.",
                    session = "Configure \"Session\" in the \"Interrogation\" section.",
                    dispatch = "Configure \"Police alerts\" in the \"Interrogation\" section.",
                    logging = "Configure \"Logging\" in the \"Interrogation\" section.",
                    security = "Configure \"Security\" in the \"Interrogation\" section.",
                    presentation = "Configure \"Presentation\" in the \"Interrogation\" section.",
                },
                reputation = {
                    crimeReputation = "Configure \"Reputation\" in the \"Reputation\" section.",
                },
            },
            settingGroups = {
                weaponRuntime = { label = "General", description = "Control availability and access to weapon routes." },
                weaponCreatorMenu = { label = "Illegal Business Creator", description = "Manage weapon routes and money wash in one creator." },
                atmActionTimes = {
                    description = "Set the duration of attaching, planting, detonation, and looting actions.",
                    label = "Action durations",
                },
                atmAvailability = {
                    description = "Enable or disable the standalone ATM robbery system.",
                    label = "Availability",
                },
                atmDispatchAlert = {
                    description = "Configure radius, lifetime, and priority for the police alert.",
                    label = "Alert properties",
                },
                atmDispatchRecipients = {
                    description = "Choose which job names receive ATM robbery alerts.",
                    label = "Recipients",
                },
                atmDistances = {
                    description = "Set the player and vehicle ranges used by ATM interactions.",
                    label = "Interaction distances",
                },
                atmExplosionEffects = {
                    description = "Configure the explosion native parameters used during detonation.",
                    label = "Explosion effects",
                },
                atmItems = {
                    description = "Configure the required drill, sling and explosive charge items.",
                    label = "Required items",
                },
                atmLocations = {
                    description = "Manage the server-authorized ATM positions available for robberies.",
                    label = "ATM locations",
                },
                atmPayout = {
                    description = "Configure the target account and random reward range.",
                    label = "Payout",
                },
                atmPolice = {
                    description = "Configure the on-duty police requirement for starting a robbery.",
                    label = "Police requirement",
                },
                atmPulling = {
                    description = "Configure the movement required to tear an ATM from the wall.",
                    label = "Pull detection",
                },
                atmTimeouts = {
                    description = "Control how long a breached ATM remains available to loot.",
                    label = "Loot timeout",
                },
                baseRaids = {
                    description = "Raid access, requirements and individually selectable loot categories. Open raids have no transport timeout.",
                    label = "Base raids",
                },
                businessPayments = {
                    description = "Choose which balance pays for Business Network purchases and operating costs.",
                    label = "Payments",
                },
                crimeMembership = {
                    description = "Choose how crime organizations store and manage their members.",
                    label = "Membership model",
                },
                darknetAvailability = {
                    description = "Controls the tablet app and its placement.",
                    label = "Availability",
                },
                darknetChat = {
                    description = "Limits encrypted marketplace messages.",
                    label = "Private chat",
                },
                darknetDelivery = {
                    description = "Configures physical meetings and stealable world crates.",
                    label = "Handover and dead drops",
                },
                darknetDeliveryLocations = {
                    description = "Configures the location pools randomly assigned to BlackBay NPC trades.",
                    label = "Handover locations",
                },
                darknetEconomy = {
                    description = "Configures wallet balances, coin exchange and payment rates.",
                    label = "Cryptocurrency",
                },
                darknetIdentity = {
                    description = "Configures identity rotation, verification and scam warnings.",
                    label = "Aliases and reputation",
                },
                darknetListings = {
                    description = "Controls offer limits, prices and automatic expiry.",
                    label = "Offers and expiry",
                },
                darknetNpcTraders = {
                    description = "Persistent NPC buyers and sellers with configurable risk.",
                    label = "NPC traders",
                },
                darknetPolice = {
                    description = "Job groups allowed to publish traps and view investigations.",
                    label = "Police access",
                },
                heistCrafting = {
                    description = "Choose how much interaction is required when crafting heist equipment. Applies to new attempts across the Crime System.",
                    label = "Heist workshop",
                },
                heistCreatorMenu = {
                    description = "Create, edit, and publish modular heists in the dedicated Heist Creator.",
                    label = "Creator menu",
                },
                heistExecution = {
                    description = "Start window, inactivity and cooldown for heist runs.",
                    label = "Heist timing",
                },
                moneywashEconomy = {
                    description = "Enable businesses and configure the deposit account, service fee and interaction distances.",
                    label = "General",
                },
                npcPoliceSupport = {
                    description = "This feature is temporarily disabled due to stability issues and currently cannot be enabled in the Job Configurator.",
                    label = "NPC police support (currently disabled)",
                },
                pickpocketAvailability = {
                    description = "Enable the feature and optionally limit it to configured crime jobs.",
                    label = "Availability",
                },
                pickpocketDispatchSettings = {
                    description = "Configure the alert sent when an NPC calls emergency services.",
                    label = "Emergency dispatch",
                },
                pickpocketDistances = {
                    description = "Set the NPC range used by the shared radial and target system.",
                    label = "Interaction distances",
                },
                pickpocketGameplay = {
                    description = "Choose the challenge and the independent flee, emergency-call, and counterattack probabilities.",
                    label = "Risk and minigame",
                },
                pickpocketItemRewards = {
                    description = "Control empty pockets and visible item choices down to 0.0001 percent.",
                    label = "Visible pocket loot",
                },
                pickpocketMoney = {
                    description = "Configure the server-generated random cash range.",
                    label = "Cash reward",
                },
                pickpocketRateLimits = {
                    description = "Control request throttling, per-NPC cooldown, and session expiry.",
                    label = "Server safeguards",
                },
                pvpArenas = {
                    description = "Create the circular zone, observer point, and team spawn points used by PvP events.",
                    label = "Arenas and combat zones",
                },
                pvpAutomation = {
                    description = "Configure recurring event and automatic start processing.",
                    label = "Automation",
                },
                pvpAvailability = {
                    description = "Control whether the PvP event app is available and where it appears.",
                    label = "Availability",
                },
                pvpLimits = {
                    description = "Set reward and tablet history limits.",
                    label = "Limits and history",
                },
                pvpModes = {
                    description = "Configure the game mode preselected in the PvP tablet.",
                    label = "Game modes",
                },
                pvpPermissions = {
                    description = "Map event management and finances to ACE and job permissions.",
                    label = "Permissions",
                },
                pvpRuntime = {
                    description = "Tune request handling, deaths, and respawns during live matches.",
                    label = "Match runtime",
                },
                pvpTakeoverMethods = {
                    description = "Configure how long each method takes to breach an entrance.",
                    label = "Breach methods",
                },
                pvpTakeoverRules = {
                    description = "Control availability and participation requirements for laboratory and camper takeovers.",
                    label = "Takeover rules",
                },
                pvpTakeoverZones = {
                    description = "Configure interaction, alert, and capture areas together with their durations.",
                    label = "Zones and timing",
                },
                shopAvailability = {
                    description = "Enable robberies and configure the police requirement.",
                    label = "Availability",
                },
                shopDispatchSettings = {
                    description = "Configure recipients and alert properties.",
                    label = "Police alert",
                },
                shopLocationTable = {
                    description = "Manage staffed retail locations and safes.",
                    label = "Shop locations",
                },
                shopRegisterReward = {
                    description = "Configure the random reward for each register.",
                    label = "Register reward",
                },
                shopRegisterTable = {
                    description = "Assign individual registers to shops.",
                    label = "Cash registers",
                },
                shopSafe = {
                    description = "Configure keypad attempts and the drill item.",
                    label = "Safe",
                },
                shopSafeReward = {
                    description = "Configure the random safe reward.",
                    label = "Safe reward",
                },
                shopTiming = {
                    description = "Configure intimidation, actions, timeout, and cooldown.",
                    label = "Timing",
                },
            },
            settingSections = {
                weapons = "Weapon Routes",
                drugs = "Drug System",
                drugProduction = "Drug Production",
                drugOperations = "Drug Operations",
                drugMarketRisk = "Market & Risk",
                drugNetworks = "Drug Networks",
                atmRobbery = "ATM robbery",
                baseRaids = "Base raids",
                crimeOrganizations = "Organizations",
                darknetMarket = "Darknet Market",
                moneywash = "Money Wash",
                pvpEvents = "Faction PvP",
                robbery = "Robbery",
                territories = "Territories",
                graffiti = "Graffiti",
                interrogation = "Interrogation",
            },
            settingSubsections = {
                baseRaidEquipment = "Required equipment",
                baseRaidBreach = "Breaching",
                baseRaidLoot = "Loot & Vehicles",
                graffitiLimits = "Limits & Moderation",
                interrogationTechnical = "Logging & Security",
                atmDispatch = "Police dispatch",
                atmEquipment = "Equipment",
                atmExplosion = "Explosion",
                atmOverview = "Overview & locations",
                atmRewards = "Rewards",
                atmTiming = "Timing",
                atmVehicle = "Vehicle & pulling",
                baseRaids = "Base raids",
                crimeMembership = "Membership",
                heistCreator = "Heist Creator",
                npcPoliceSupport = "NPC police support (currently disabled)",
                pickpocket = "NPC pickpocketing",
                pvpArenas = "Arenas",
                pvpEquipment = "Game modes",
                pvpOverview = "Overview",
                pvpRuntime = "Match runtime",
                pvpTakeovers = "Laboratory takeovers",
                shopRobbery = "Shop robberies",
                atmRobbery = "ATM robbery",
            },
            settings = {
                weaponDefaultGeneralInteractionDistance = { label = "Interaction distance" },
                weaponDefaultGeneralPedModel = { label = "NPC ped model" },
                weaponDefaultAccessActiveHourStart = { label = "Opens at (UTC)" },
                weaponDefaultAccessActiveHourEnd = { label = "Closes at (UTC)" },
                weaponDefaultAccessPoliceRequired = { label = "Required officers on duty" },
                weaponDefaultAccessPoliceJobs = { label = "Police jobs (comma separated)" },
                weaponDefaultCollectionDurationSeconds = { label = "Duration in seconds" },
                weaponDefaultCollectionCooldownSeconds = { label = "Cooldown in seconds" },
                weaponDefaultCollectionCooldownScope = { label = "Cooldown scope" },
                weaponDefaultCollectionUseMinigame = { label = "Use minigame" },
                weaponDefaultCollectionMinigame = { label = "Minigame" },
                weaponDefaultCollectionMinigameRounds = { label = "Minigame rounds" },
                weaponDefaultProductionDurationSeconds = { label = "Duration in seconds" },
                weaponDefaultProductionSuccessChance = { label = "Success chance" },
                weaponDefaultProductionFailureConsumesInputs = { label = "Consume inputs on production failure" },
                weaponDefaultProductionUseMinigame = { label = "Use minigame" },
                weaponDefaultProductionMinigame = { label = "Minigame" },
                weaponDefaultProductionMinigameRounds = { label = "Minigame rounds" },
                weaponDefaultProductionQualityMin = { label = "Minimum output quality" },
                weaponDefaultProductionQualityMax = { label = "Maximum output quality" },
                weaponDefaultProductionCooldownSeconds = { label = "Cooldown in seconds" },
                weaponDefaultProductionCooldownScope = { label = "Cooldown scope" },
                weaponDefaultMarketPayoutAccount = { label = "Payment Account" },
                weaponDefaultMarketPriceMultiplierMin = { label = "Minimum street price (%)" },
                weaponDefaultMarketPriceMultiplierMax = { label = "Maximum street price (%)" },
                weaponDefaultMarketRestockSeconds = { label = "Market refill interval (seconds)" },
                weaponDefaultMarketCooldownSeconds = { label = "Cooldown in seconds" },
                weaponDefaultMarketCooldownScope = { label = "Cooldown scope" },
                weaponDefaultDeliveryContractDurationMinutes = { label = "Delivery deadline (minutes)" },
                weaponDefaultDeliveryContractBonusPercent = { label = "Contract bonus in percent" },
                weaponStreetEnabled = { label = "Rare weapon sales at street buyers" },
                weaponStreetChance = { label = "Weapon offer chance (%)" },
                weaponStreetCooldown = { label = "Cooldown in seconds" },
                weaponStreetAmount = { label = "Maximum amount" },
                weaponStreetPriceMin = { label = "Minimum street price (%)" },
                weaponStreetPriceMax = { label = "Maximum street price (%)" },
                weaponStreetAccount = { label = "Payment Account" },
                weaponStreetDirect = { label = "Direct sale" },
                weaponStreetBulk = { label = "Bulk sale" },
                weaponStreetContract = { label = "Cartel contract" },
                weaponSystemEnabled = { label = "Weapon route system", description = "Enable weapon collection, processing and cartel selling." },
                weaponRuntimeEnabled = { label = "Weapon route actions", description = "Allow configured weapon routes to be used in the world." },
                weaponCreatorAccess = { label = "Weapon Creator access", description = "Choose who may open the Weapon Creator.", options = { permission = "Permission only", jobManagement = "Job management", ownerOnly = "Owner only" } },
                openWeaponCreator = { label = "Illegal Business Creator", description = "Manage weapon routes and money wash in one creator.", buttonLabel = "Illegal Business Creator", unsavedTooltip = "Save first" },

                drugCultivationProgressionEnabled = {
                    label = "Enable cultivation levels",
                    description = "Enable cultivation XP, levels and level-based unlock requirements.",
                },
                drugCultivationMaxLevel = {
                    label = "Maximum cultivation level",
                    description = "Highest active cultivation level. Configured levels above it cannot be reached.",
                },
                drugCultivationLevels = {
                    label = "Level curve",
                    description = "Configure the title and total XP threshold for every cultivation level.",
                },
                drugCultivationActionXp = {
                    label = "XP rewards",
                    description = "Configure how much cultivation XP each growing action awards.",
                },
                drugCultivationUnlocks = {
                    label = "Level unlocks",
                    description = "Configure the required cultivation level for containers, substrates, equipment, strains and scanner tiers.",
                },
                reputationRewards = {
                    label = "Reputation actions",
                    description = "Add actions, change points, and disable or delete entries. Only enabled entries award points.",
                },
                reputationEnabled = {
                    label = "Enable crime reputation",
                    description = "Award personal reputation.",
                },
                reputationPointsPerLevel = {
                    label = "Points per level",
                    description = "Each level requires this many additional points.",
                },
                reputationMinimumJoinPoints = {
                    label = "Minimum reputation to join",
                    description = "Required total points for joining a crime faction. 0 disables the requirement. Existing members keep access.",
                },
                reputation_atm = {
                    label = "ATM robbery",
                    description = "Points per successful completion. 0 disables this reward.",
                },
                reputation_shop_register = {
                    label = "Shop register",
                    description = "Points per successful completion. 0 disables this reward.",
                },
                reputation_shop_safe = {
                    label = "Shop safe",
                    description = "Points per successful completion. 0 disables this reward.",
                },
                reputation_pickpocket = {
                    label = "Pickpocketing",
                    description = "Points per successful completion. 0 disables this reward.",
                },
                reputation_heist = {
                    label = "Heist completion",
                    description = "Points per successful completion. 0 disables this reward.",
                },
                reputation_drug_harvest = {
                    label = "Drug harvest",
                    description = "Points per successful completion. 0 disables this reward.",
                },
                reputation_drug_processing = {
                    label = "Drug processing",
                    description = "Points per successful completion. 0 disables this reward.",
                },
                reputation_drug_sale = {
                    label = "Drug sale",
                    description = "Points per successful completion. 0 disables this reward.",
                },
                reputation_drug_delivery = {
                    label = "Drug delivery",
                    description = "Points per successful completion. 0 disables this reward.",
                },
                reputation_drug_contract = {
                    label = "Distribution contract",
                    description = "Points per successful completion. 0 disables this reward.",
                },
                reputation_drug_raid = {
                    label = "Drug raid",
                    description = "Points per successful completion. 0 disables this reward.",
                },
                reputation_graffiti = {
                    label = "Graffiti",
                    description = "Points per successful completion. 0 disables this reward.",
                },
                reputation_moneywash = {
                    label = "Money laundering",
                    description = "Points per successful completion. 0 disables this reward.",
                },
                reputation_base_raid = {
                    label = "Base raid",
                    description = "Points per successful completion. 0 disables this reward.",
                },
                reputation_pvp_win = {
                    label = "PvP victory",
                    description = "Points per successful completion. 0 disables this reward.",
                },
                atmChargeProp = {
                    description = "Object model displayed on the ATM while the explosive charge is planted.",
                    label = "Charge prop",
                },
                atmConsumeDrill = {
                    description = "Consumes the configured amount after each successfully completed ATM drilling point.",
                    label = "Consume drill",
                },
                atmDrillItem = {
                    description = "Inventory item ID required to drill a detached ATM. Separate from the shop safe drill.",
                    label = "Drill item",
                },
                atmDrillItemAmount = {
                    description = "Number of drill items required for each ATM drilling point.",
                    label = "Required drill amount",
                },
                atmDebug = {
                    description = "Writes detailed ATM robbery diagnostics to the server console and client F8 console.",
                    label = "ATM debug logs",
                },
                atmDispatchDurationSeconds = {
                    description = "Seconds the ATM alert remains relevant to dispatch consumers.",
                    label = "Dispatch duration",
                },
                atmDispatchEnabled = {
                    description = "Creates a Jobs Base incident when an ATM is breached.",
                    label = "Enable police dispatch",
                },
                atmDispatchJobs = {
                    description = "Comma-separated job names that receive the ATM alert.",
                    label = "Dispatch jobs",
                },
                atmDispatchPriority = {
                    description = "Priority value passed unchanged to the dispatch integration.",
                    label = "Dispatch priority",
                },
                atmDispatchRadius = {
                    description = "Approximate alert radius sent to the dispatch integration.",
                    label = "Dispatch radius",
                },
                atmEnabled = {
                    description = "Makes configured ATMs available for sling and explosive robberies.",
                    label = "Enable ATM robberies",
                },
                atmExplosionCameraShake = {
                    description = "Camera shake intensity for the client creating the explosion.",
                    label = "Explosion camera shake",
                },
                atmExplosionDamageScale = {
                    description = "Damage and impulse strength passed to the explosion native.",
                    label = "Explosion damage scale",
                },
                atmExplosionType = {
                    description = "GTA explosion type used at detonation. Keep the default unless another type was tested.",
                    label = "Explosion type",
                },
                atmDrillDurationSeconds = {
                    label = "Minimum drill time per screw (s)",
                    description = "Minimum time in seconds for each of the four screws. Cooling extends the attempt. Applies to newly started drilling attempts.",
                },
                atmExplosiveDurationSeconds = {
                    description = "Seconds required to plant the explosive charge.",
                    label = "Plant charge duration",
                },
                atmExplosiveItem = {
                    description = "Inventory item consumed after the charge is planted.",
                    label = "Explosive item",
                },
                atmExplosiveItemAmount = {
                    description = "Number of explosive items consumed for one planted charge.",
                    label = "Consumed explosive amount",
                },
                atmFuseSeconds = {
                    description = "Seconds between planting and detonation.",
                    label = "Fuse duration",
                },
                atmInteractionDistance = {
                    description = "Maximum client interaction range; server validation adds a safety margin.",
                    label = "Interaction distance",
                },
                atmLocations = {
                    description = "Authoritative production ATMs. Locations created with /atmtest remain temporary.",
                    itemLabel = "ATM location",
                    label = "ATM locations",
                },
                atmLootDurationSeconds = {
                    description = "Seconds required to break open a breached ATM.",
                    label = "Loot duration",
                },
                atmLootReservationTimeoutSeconds = {
                    description = "Maximum seconds one player may reserve an ATM while opening it; automatically kept above the loot duration.",
                    label = "Loot reservation timeout",
                },
                atmLootWindowMinutes = {
                    description = "Minutes a breached ATM remains lootable before it is depleted.",
                    label = "Loot window",
                },
                atmMinimumPolice = {
                    description = "On-duty members of the configured police group required to begin a robbery.",
                    label = "Minimum police",
                },
                atmPoliceGroup = {
                    description = "sky_jobs_base job group counted for the police requirement.",
                    label = "Police job group",
                },
                atmPullDistance = {
                    description = "Vehicle displacement from the ATM position required to complete the breach.",
                    label = "Required pull distance",
                },
                atmPullMinimumSpeed = {
                    description = "Minimum vehicle speed in metres per second when the pull distance is reached.",
                    label = "Minimum pull speed",
                },
                atmReservationTimeoutSeconds = {
                    description = "Maximum seconds reserved while a player attaches a sling or plants a charge; automatically kept above the action duration.",
                    label = "Preparation reservation timeout",
                },
                atmRewardAccount = {
                    description = "Choose whether the ATM pays cash or the black_money item.",
                    label = "ATM payout type",
                },
                atmRewardMaximum = {
                    description = "Highest cash payout from one ATM; never lower than the minimum.",
                    label = "Maximum reward",
                },
                atmRewardMinimum = {
                    description = "Lowest cash payout from one ATM.",
                    label = "Minimum reward",
                },
                atmSlingDurationSeconds = {
                    description = "Seconds required to attach the sling.",
                    label = "Attach sling duration",
                },
                atmSlingItem = {
                    description = "Reusable inventory item required for the vehicle method.",
                    label = "Sling item",
                },
                atmSlingItemAmount = {
                    description = "Number of sling items that must be present. They are not consumed.",
                    label = "Required sling amount",
                },
                atmTestScanDistance = {
                    description = "Maximum distance used by /atmtest when searching for a supported ATM prop.",
                    label = "ATM test scan distance",
                },
                atmVehicleMaxDistance = {
                    description = "Maximum distance between the ATM and an eligible vehicle when attaching the sling.",
                    label = "Vehicle attach distance",
                },
                baseRaid_breachTimeoutSeconds = {
                    description = "Time limit for each breaching attempt at a storage point (seconds).",
                    label = "Breaching timeout (seconds)",
                },
                baseRaid_command = {
                    description = "Command name without a slash. Restart the crime resource after changing it.",
                    label = "Raid command",
                },
                baseRaid_crimeItem = {
                    description = "Gang breaching item.",
                    label = "Gang breaching item",
                },
                baseRaid_crimeVehicles = {
                    description = "Gang vehicle access.",
                    label = "Gang vehicle access",
                },
                baseRaid_difficulty = {
                    description = "Skillcheck difficulty.",
                    label = "Skillcheck difficulty",
                    options = {
                        easy = "Easy",
                        expert = "Expert",
                        hard = "Hard",
                        normal = "Normal",
                    },
                },
                baseRaid_enabled = {
                    description = "Enable base raids.",
                    label = "Enable base raids",
                },
                baseRaid_failedCooldownMinutes = {
                    description = "Cooldown when a raid ends without opening any storage point (minutes).",
                    label = "Cooldown after failure (minutes)",
                },
                baseRaid_interactionDistance = {
                    description = "Storage interaction distance.",
                    label = "Storage interaction distance",
                },
                baseRaid_lootHeistStorage = {
                    description = "Allow complete withdrawal of this inventory category during an active raid.",
                    label = "Loot heist storage",
                },
                baseRaid_lootLaboratories = {
                    description = "Allow complete withdrawal of this inventory category during an active raid.",
                    label = "Loot laboratory storage",
                },
                baseRaid_lootPersonalLockers = {
                    description = "Allow complete withdrawal of this inventory category during an active raid.",
                    label = "Loot personal lockers",
                },
                baseRaid_lootStorage = {
                    description = "Allow complete withdrawal of this inventory category during an active raid.",
                    label = "Loot storage",
                },
                baseRaid_lootVehicleGloveboxes = {
                    description = "Allow complete withdrawal of this inventory category during an active raid.",
                    label = "Loot gloveboxes",
                },
                baseRaid_lootVehicleTrunks = {
                    description = "Allow complete withdrawal of this inventory category during an active raid.",
                    label = "Loot vehicle trunks",
                },
                baseRaid_minimumDefenders = {
                    description = "Minimum online defenders.",
                    label = "Minimum online defenders",
                },
                baseRaid_policeItem = {
                    description = "Police breaching item.",
                    label = "Police breaching item",
                },
                baseRaid_policeRequireDuty = {
                    description = "Police must be on duty.",
                    label = "Police must be on duty",
                },
                baseRaid_policeVehicles = {
                    description = "Police vehicle access.",
                    label = "Police vehicle access",
                },
                baseRaid_protectionHours = {
                    description = "Protection after success (hours).",
                    label = "Protection after success (hours)",
                },
                baseRaid_requiredHits = {
                    description = "Required skillcheck hits.",
                    label = "Required skillcheck hits",
                },
                baseRaid_warrantItem = {
                    description = "One of these items is consumed for every valid police raid start.",
                    label = "Search warrant item",
                },
                crimeMembershipMode = {
                    description = "Framework mode keeps the existing job or native gang integration. Independent mode runs the crime organization in the background alongside the player's normal job and migrates existing memberships automatically.",
                    label = "Organization membership model",
                    options = {
                        framework = "Framework job / gang",
                        independent = "Independent organization",
                    },
                },
                darknetAliasChangeCooldownHours = {
                    description = "Minimum age of an identity before it can be retired again.",
                    label = "Alias change cooldown (hours)",
                },
                darknetCurrencyCode = {
                    description = "Short label shown for the internal cryptocurrency ledger.",
                    label = "Currency code",
                },
                darknetDeadDropInteractionDistance = {
                    description = "Distance required to search and claim a crate.",
                    label = "Dead-drop interaction distance",
                },
                darknetDeadDropLifetimeHours = {
                    description = "Time before an unclaimed crate expires.",
                    label = "Dead-drop lifetime (hours)",
                },
                darknetDeadDropModel = {
                    description = "GTA prop model spawned locally for available dead drops.",
                    label = "Dead-drop crate model",
                },
                darknetDeadDropPollIntervalMs = {
                    description = "Interval used to refresh nearby crates and NPC meetings.",
                    label = "World refresh interval (ms)",
                },
                darknetDeadDropStreamDistance = {
                    description = "Distance at which crates and NPC meeting contacts are streamed.",
                    label = "Dead-drop stream distance",
                },
                darknetDropLocations = {
                    description = "Locations randomly assigned to dead-drop trades with NPCs. Configure at least two.",
                    itemLabel = "Dead-drop location",
                    label = "Dead-drop locations",
                },
                darknetEnabled = {
                    description = "Makes the black-market tablet app and its runtime available.",
                    label = "Enable Darknet Market",
                },
                darknetExchangeBuyPrice = {
                    description = "Amount charged from the payment account for one coin.",
                    label = "Buy price per coin",
                },
                darknetExchangeEnabled = {
                    description = "Allows authenticated BlackBay users to buy and sell coins on their account page.",
                    label = "Enable coin exchange",
                },
                darknetExchangeMaximumAmount = {
                    description = "Largest whole coin amount accepted in one exchange.",
                    label = "Maximum coins per exchange",
                },
                darknetExchangeMinimumAmount = {
                    description = "Smallest whole coin amount accepted in one exchange.",
                    label = "Minimum coins per exchange",
                },
                darknetExchangePaymentAccount = {
                    description = "Framework account used for coin purchases and sale payouts.",
                    label = "Exchange payment account",
                    options = {
                        bank = "Bank",
                        black_money = "Dirty money",
                        money = "Cash",
                    },
                },
                darknetExchangeSellPrice = {
                    description = "Amount paid to the payment account for one coin.",
                    label = "Sell price per coin",
                },
                darknetFaceToFaceDistance = {
                    description = "Maximum distance between both players or the configured NPC point.",
                    label = "Handover distance",
                },
                darknetKnownScammerReports = {
                    description = "Unique trade reports required for the known-scammer badge.",
                    label = "Reports for scammer warning",
                },
                darknetListingExpiryHours = {
                    description = "Active offers expire automatically after this many hours.",
                    label = "Offer lifetime (hours)",
                },
                darknetMaximumListingQuantity = {
                    description = "Upper quantity limit for one offer.",
                    label = "Maximum goods quantity",
                },
                darknetMaximumListings = {
                    description = "Maximum offers per active alias.",
                    label = "Maximum active offers",
                },
                darknetMaximumMessageLength = {
                    description = "Maximum number of characters per encrypted chat message.",
                    label = "Maximum message length",
                },
                darknetMaximumUnitPrice = {
                    description = "Upper crypto price for a single unit.",
                    label = "Maximum unit price",
                },
                darknetMeetingLocations = {
                    description = "Locations randomly assigned to face-to-face trades with NPCs. Configure at least two.",
                    itemLabel = "Meeting location",
                    label = "Meeting locations",
                },
                darknetNpcBuyerAliases = {
                    description = "Fictional names assigned randomly to new NPC buy requests. Configure at least two unique aliases.",
                    label = "NPC buyer aliases",
                },
                darknetNpcMaximumBuyListings = {
                    description = "Upper limit used when randomly choosing how many NPC buy requests become active.",
                    label = "Maximum NPC buy requests",
                },
                darknetNpcMaximumSellListings = {
                    description = "Upper limit used when randomly choosing how many NPC sale offers become active.",
                    label = "Maximum NPC sale offers",
                },
                darknetNpcMinimumBuyListings = {
                    description = "When the NPC market is replenished, at least this many randomly selected buy requests remain active.",
                    label = "Minimum NPC buy requests",
                },
                darknetNpcMinimumSellListings = {
                    description = "When the NPC market is replenished, at least this many randomly selected sale offers remain active.",
                    label = "Minimum NPC sale offers",
                },
                darknetNpcSellerAliases = {
                    description = "Fictional names assigned randomly to new NPC sale offers. Configure at least two unique aliases.",
                    label = "NPC seller aliases",
                },
                darknetNpcTraders = {
                    description = "Configure synthetic offers, delivery method, reputation and scam probability.",
                    label = "NPC buyers and sellers",
                },
                darknetPoliceGroups = {
                    description = "Group keys that can publish bait offers and view investigations.",
                    label = "Authorized police job groups",
                },
                darknetRenewalHours = {
                    description = "Hours added when an owner renews an offer.",
                    label = "Renewal duration (hours)",
                },
                darknetScamChance = {
                    description = "Minimum chance that an NPC trade takes the payment or goods without delivering the return. A higher trader-specific chance still applies.",
                    label = "Global NPC scam chance (%)",
                },
                darknetStarterBalance = {
                    description = "Crypto assigned only when a player opens the market for the first time.",
                    label = "New wallet balance",
                },
                darknetTabletOrder = {
                    description = "Controls the Darknet Market position on the tablet.",
                    label = "Tablet app order",
                },
                darknetVerifiedMinimumRating = {
                    description = "Minimum average rating for a verified seller.",
                    label = "Rating required for verification",
                },
                darknetVerifiedMinimumSales = {
                    description = "Successful sales required before a seller can become verified.",
                    label = "Sales required for verification",
                },
                drugAdvancedBusinessNetworkPaymentAccount = {
                    description = "Account used when the payment source is set to Player account. Organization payments always use the Boss Menu account.",
                    label = "Player payment account",
                    options = {
                        bank = "Bank",
                        black_money = "Dirty money",
                        money = "Cash",
                    },
                    requiresWarning = "Only used with the Player account payment source.",
                },
                drugAdvancedBusinessNetworkPaymentSource = {
                    description = "Use either the purchasing player's balance or the organization's Boss Menu account.",
                    label = "Payment source",
                    options = {
                        player = "Player account",
                        society = "Organization account",
                    },
                },
                drugCamperLockKey = {
                    description = "Sets the default key for locking and unlocking owned or faction-shared campers. Players may override it in their FiveM key bindings.",
                    label = "Camper lock default key",
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
                    description = "Attach quality and batch data to collector outputs by default. Disable this to make raw materials stack normally.",
                    label = "Collector item metadata",
                },
                drugLabAssaultAlertDuration = {
                    description = "Seconds the defender alert radius remains visible on the map.",
                    label = "Defender alert duration",
                },
                drugLabAssaultAlertRadius = {
                    description = "Radius of the attack zone shown to the defending faction on the map.",
                    label = "Defender alert radius",
                },
                drugLabAssaultBreachRadius = {
                    description = "Radius an attacker must remain within while opening the entrance.",
                    label = "Breach hold radius",
                },
                drugLabAssaultCaptureDuration = {
                    description = "Uncontested seconds attackers must hold the entrance to take over the laboratory or camper.",
                    label = "Takeover duration",
                },
                drugLabAssaultCaptureRadius = {
                    description = "Entrance area used to count attackers and contesting defenders.",
                    label = "Capture radius",
                },
                drugLabAssaultElectronicDuration = {
                    description = "Seconds required to hack the entrance system.",
                    label = "Electronic breach duration",
                },
                drugLabAssaultEnabled = {
                    description = "Allows factions to breach and take over rival laboratories and faction-shared campers.",
                    label = "Enable laboratory and camper takeovers",
                },
                drugLabAssaultExplosiveDuration = {
                    description = "Seconds required to breach the entrance with an explosive charge.",
                    label = "Explosive breach duration",
                },
                drugLabAssaultInteractionDistance = {
                    description = "Maximum distance from the laboratory or camper entrance when starting an attack.",
                    label = "Entrance interaction distance",
                },
                drugLabAssaultMechanicalDuration = {
                    description = "Seconds required to drill the entrance lock.",
                    label = "Mechanical breach duration",
                },
                drugLabAssaultMinimumDefenders = {
                    description = "Online members of the defending faction required before an attack may start.",
                    label = "Minimum defenders",
                },
                drugLabAssaultRequireDuty = {
                    description = "Only counts defending faction members who are currently on duty.",
                    label = "Count on-duty defenders only",
                },
                drugProcessingInventoryMetadata = {
                    description = "Attach quality and batch data to processing outputs by default. Individual recipes can override this setting.",
                    label = "Processing item metadata",
                },
                graffitiItemName = {
                    description = "Inventory item required to start spraying when the item requirement is enabled. The item must exist in the active inventory.",
                    label = "Required graffiti item",
                },
                heistCooldownMinutes = {
                    description = "Blocks the same heist after a run with actual interactions ends and is cleaned up. Zero disables the cooldown. An unused start window does not trigger it.",
                    label = "Heist cooldown (minutes)",
                },
                heistCraftingMode = {
                    optionDescriptions = {
                        simple = "Five-second progress bar. Required ingredients are consumed on success.",
                        medium = "Select ingredients in the shown order and pass one timing check per ingredient.",
                        advanced = "Full device assembly for recipes with a device profile; otherwise two precise timing checks per ingredient.",
                    },
                    description = "Simple: five-second progress bar. Medium: ingredient selection and timing checks. Maximum: full device assembly; recipes without a device profile use two precise timing checks per ingredient.",
                    label = "Crafting complexity",
                    options = {
                        advanced = "Maximum complexity",
                        medium = "Medium complexity",
                        simple = "Simple",
                    },
                },
                heistInactivityTimeoutMinutes = {
                    description = "After the first interaction, each new heist action resets this timer. Expiry ends the run and clears its world objects. Applies to new runs.",
                    label = "Heist inactivity limit (minutes)",
                },
                heistStartTimeoutMinutes = {
                    description = "Time after pressing Start to interact at the target. Without an interaction the run resets and can be started again. Applies to new runs.",
                    label = "Minutes until first heist interaction",
                },
                moneywashAccount = {
                    options = {
                        bank = "Bank",
                        black_money = "Dirty money",
                        money = "Cash",
                    },
                },
                moneywashDirtyAccount = {
                    description = "Account from which a player's dirty money is removed when a wash cycle starts.",
                    label = "Deposit account",
                },
                moneywashDrawDistance = {
                    description = "Maximum distance in metres at which business entrances and shops are displayed.",
                    label = "Display distance",
                },
                moneywashEnabled = {
                    description = "Makes organisation-owned money-wash businesses available.",
                    label = "Enable money wash",
                },
                moneywashFeePercent = {
                    description = "Percentage deducted from each batch before payout to the organisation.",
                    label = "Service fee (%)",
                },
                moneywashInteractionDistance = {
                    description = "Maximum distance in metres for using business entrances and shops.",
                    label = "Interaction distance",
                },
                npcPoliceAccuracy = {
                    description = "Accuracy of NPC officers from 0 to 100.",
                    label = "Shooting accuracy",
                },
                npcPoliceArmour = {
                    description = "Armour value of each NPC officer from 0 to 100.",
                    label = "Body armour",
                },
                npcPoliceAtms = {
                    description = "Send NPC police support when an ATM robbery alarm is triggered.",
                    label = "Support during ATM robberies",
                },
                npcPoliceDurationSeconds = {
                    description = "Maximum time NPC officers remain deployed after spawning (30–900 seconds).",
                    label = "Deployment duration (seconds)",
                },
                npcPoliceEnabled = {
                    description = "Currently disabled due to stability issues. This switch cannot activate the feature at this time.",
                    label = "Enable NPC police support",
                },
                npcPoliceHeists = {
                    description = "Send NPC police support when a heist alarm is triggered.",
                    label = "Support during heists",
                },
                npcPoliceOfficerCount = {
                    description = "Number of armed NPC officers dispatched per robbery alarm (1–8).",
                    label = "Officers per response",
                },
                npcPoliceResponseDelaySeconds = {
                    description = "Time between the robbery alarm and the arrival of NPC officers (0–300 seconds).",
                    label = "Response delay (seconds)",
                },
                npcPoliceShops = {
                    description = "Send NPC police support when a shop robbery alarm is triggered.",
                    label = "Support during shop robberies",
                },
                npcPoliceSpawnDistance = {
                    description = "Target distance from the robbery location at which NPC officers spawn (15–150 meters).",
                    label = "Spawn distance (meters)",
                },
                npcPoliceWeapon = {
                    description = "Weapon equipped by every responding NPC officer. The default is a pistol.",
                    label = "Service weapon",
                    options = {
                        WEAPON_CARBINERIFLE = "Carbine rifle",
                        WEAPON_PISTOL = "Pistol",
                        WEAPON_PUMPSHOTGUN = "Pump shotgun",
                    },
                },
                openHeistCreator = {
                    buttonLabel = "Open Heist Creator",
                    description = "Open the Heist Creator and close the Job Configurator.",
                    label = "Heist Creator",
                    unsavedTooltip = "Save changes first",
                },
                pickpocketAggressionChance = {
                    description = "Independent chance that the NPC attacks after a failed, cancelled or expired attempt.",
                    label = "Counterattack chance (%)",
                },
                pickpocketAlertChance = {
                    description = "Independent chance that the NPC reports a failed, cancelled or expired attempt.",
                    label = "Emergency-call chance (%)",
                },
                pickpocketDifficulty = {
                    description = "Controls cursor speed, how quickly the target shrinks, sequence length, and tolerated mistakes.",
                    label = "Difficulty",
                    options = {
                        easy = "Easy",
                        expert = "Expert",
                        hard = "Hard",
                        normal = "Normal",
                    },
                },
                pickpocketDispatchAlways = {
                    description = "Report each started pickpocket attempt once, including successful attempts, regardless of the emergency-call chance.",
                    label = "Always send dispatch",
                },
                pickpocketDispatchDurationSeconds = {
                    description = "Seconds the report remains relevant to dispatch consumers.",
                    label = "Dispatch duration",
                },
                pickpocketDispatchJobs = {
                    description = "Comma-separated job names that receive emergency calls.",
                    label = "Dispatch jobs",
                },
                pickpocketDispatchPriority = {
                    description = "Priority passed unchanged to the dispatch integration.",
                    label = "Dispatch priority",
                },
                pickpocketDispatchRadius = {
                    description = "Approximate alert radius sent to the dispatch integration.",
                    label = "Dispatch radius",
                },
                pickpocketEmptyChance = {
                    description = "Chance that the NPC carries no selectable loot at all.",
                    label = "Empty-pocket chance (%)",
                },
                pickpocketEnabled = {
                    description = "Lets players attempt to pickpocket eligible ambient networked NPCs.",
                    label = "Enable NPC pickpocketing",
                },
                pickpocketFleeChance = {
                    description = "Independent chance that the NPC runs away after a failed, cancelled or expired attempt.",
                    label = "NPC flee chance (%)",
                },
                pickpocketInteractionDistance = {
                    description = "Maximum client range; the server validates with a small synchronization margin.",
                    label = "Interaction distance",
                },
                pickpocketItems = {
                    description = "Each row controls its chance to appear. Four decimal places support 0.0001 percent.",
                    itemLabel = "Item chance",
                    label = "Item loot",
                },
                pickpocketItemsEnabled = {
                    description = "Also rolls configured items into the visible pocket contents.",
                    label = "Enable item loot",
                },
                pickpocketMaximumLootChoices = {
                    description = "Maximum number of server-generated cash or item slots shown for one NPC.",
                    label = "Maximum visible loot",
                },
                pickpocketMinigame = {
                    description = "Choose one challenge or rotate randomly between all three.",
                    label = "Minigame",
                    options = {
                        pulse = "Pressure pulse",
                        random = "Random rotation",
                        sequence = "Direction sequence",
                        timing = "Timing bar",
                    },
                },
                pickpocketMoneyMaximum = {
                    description = "Highest visible cash amount; automatically kept at or above the minimum.",
                    label = "Maximum cash",
                },
                pickpocketMoneyMinimum = {
                    description = "Lowest server-generated amount for a visible cash slot.",
                    label = "Minimum cash",
                },
                pickpocketRequestCooldownSeconds = {
                    description = "Minimum seconds between begin requests from one player.",
                    label = "Request cooldown",
                },
                pickpocketRequireCrimeJob = {
                    description = "Enabled: adds the action only to registered Crime System jobs. Disabled: removes the built-in radial action and requires the server export.",
                    label = "Use Crime-job radial",
                },
                pickpocketRequiredHits = {
                    description = "Base value for every minigame. Valuable cash raises it in steps; extremely rare items require at least eight hits.",
                    label = "Minimum hits",
                },
                pickpocketSessionTimeoutSeconds = {
                    description = "Seconds before an unfinished server challenge expires.",
                    label = "Session timeout",
                },
                pickpocketTargetCooldownMinutes = {
                    description = "Lockout after cancelled or failed attempts; successfully emptied NPCs remain unavailable.",
                    label = "NPC cooldown",
                },
                pvpAdminAce = {
                    description = "ACE object that grants global PvP event management access.",
                    label = "Administrator ACE",
                },
                pvpArenaReturnSeconds = {
                    description = "Default return time for new events. Event leaders can override it in the tablet.",
                    label = "Arena return time",
                },
                pvpArenaWarningPosition = {
                    description = "Controls where the return-to-arena warning appears.",
                    label = "Arena warning position",
                    options = {
                        bottom_center = "Bottom center",
                        bottom_left = "Bottom left",
                        bottom_right = "Bottom right",
                        middle_center = "Screen center",
                        middle_left = "Middle left",
                        middle_right = "Middle right",
                        top_center = "Top center",
                        top_left = "Top left",
                        top_right = "Top right",
                    },
                },
                pvpArenas = {
                    description = "Create circular combat zones with an observer point and at least two team spawn points.",
                    itemLabel = "Arena",
                    label = "PvP arenas",
                },
                pvpCountdownPosition = {
                    description = "Controls where the match start countdown appears.",
                    label = "Countdown position",
                    options = {
                        bottom_center = "Bottom center",
                        bottom_left = "Bottom left",
                        bottom_right = "Bottom right",
                        middle_center = "Screen center",
                        middle_left = "Middle left",
                        middle_right = "Middle right",
                        top_center = "Top center",
                        top_left = "Top left",
                        top_right = "Top right",
                    },
                },
                pvpDefaultMode = {
                    description = "Game mode preselected for new events.",
                    label = "Default game mode",
                    options = {
                        free_for_all = "Free For All",
                        last_man_standing = "Last Man Standing",
                        team_deathmatch = "Team Deathmatch",
                    },
                },
                pvpDefaultScoreLimit = {
                    description = "Default number of kills required to win Team Deathmatch or Free For All.",
                    label = "Default kill target",
                },
                pvpEventsEnabled = {
                    description = "Makes the faction PvP tablet app and event runtime available.",
                    label = "Enable faction PvP events",
                },
                pvpKillfeedPosition = {
                    description = "Controls where recent eliminations are shown.",
                    label = "Killfeed position",
                    options = {
                        bottom_center = "Bottom center",
                        bottom_left = "Bottom left",
                        bottom_right = "Bottom right",
                        middle_center = "Screen center",
                        middle_left = "Middle left",
                        middle_right = "Middle right",
                        top_center = "Top center",
                        top_left = "Top left",
                        top_right = "Top right",
                    },
                },
                pvpLeaderPermission = {
                    description = "Job permission required to create, register, start, and manage faction events.",
                    label = "Faction leader permission",
                },
                pvpMatchDurationMinutes = {
                    description = "Default duration in minutes for new events. Zero disables the time limit.",
                    label = "Match duration",
                },
                pvpMaxHistory = {
                    description = "Maximum number of finished or cancelled events returned to the tablet.",
                    label = "Visible event history",
                },
                pvpMaxRewards = {
                    description = "Maximum number of combined item, weapon, vehicle, or money rewards per event.",
                    label = "Maximum additional rewards",
                },
                pvpMoneyPermission = {
                    description = "Job permission required for entry fees and prize money.",
                    label = "Faction finance permission",
                },
                pvpRequestCooldownMs = {
                    description = "Minimum milliseconds between mutating PvP requests from one player.",
                    label = "Action cooldown",
                },
                pvpRespawnDelaySeconds = {
                    description = "Seconds before a player respawns or moves to the observer area after death.",
                    label = "Respawn delay",
                },
                pvpSchedulePollSeconds = {
                    description = "Seconds between recurring template and automatic start checks.",
                    label = "Schedule check interval",
                },
                pvpScoreboardPosition = {
                    description = "Controls where the compact live scoreboard appears during faction matches.",
                    label = "Scoreboard position",
                    options = {
                        bottom_center = "Bottom center",
                        bottom_left = "Bottom left",
                        bottom_right = "Bottom right",
                        middle_center = "Screen center",
                        middle_left = "Middle left",
                        middle_right = "Middle right",
                        top_center = "Top center",
                        top_left = "Top left",
                        top_right = "Top right",
                    },
                },
                pvpSoloTestingEnabled = {
                    description = "Lets PvP administrators register and manually start with one faction member. Disable this on production.",
                    label = "Enable administrator solo testing",
                },
                pvpStartCountdownSeconds = {
                    description = "Default countdown for newly created events. Event leaders can override it in the tablet.",
                    label = "Start countdown",
                },
                pvpTabletOrder = {
                    description = "Controls where the faction PvP app appears on the tablet.",
                    label = "Tablet app order",
                },
                shopActiveTimeoutMinutes = {
                    description = "Minutes before an abandoned robbery fails.",
                    label = "Active timeout",
                },
                shopConsumeDrill = {
                    description = "Consume the drill after successful opening.",
                    label = "Consume drill",
                },
                shopConsumeHackItem = {
                    description = "Consume the hacking item after successfully opening the safe.",
                    label = "Consume hacking item",
                },
                shopCooldownMinutes = {
                    description = "Runtime-only minutes before the shop resets.",
                    label = "Shop cooldown",
                },
                shopDispatchAlways = {
                    description = "Report each shop robbery once when it starts, including uninterrupted intimidation and shops without a required clerk.",
                    label = "Always send dispatch",
                },
                shopDispatchDurationSeconds = {
                    description = "Seconds the alert remains relevant.",
                    label = "Dispatch duration",
                },
                shopDispatchJobs = {
                    description = "Comma-separated alert recipient jobs.",
                    label = "Dispatch jobs",
                },
                shopDispatchPriority = {
                    description = "Priority passed to dispatch.",
                    label = "Dispatch priority",
                },
                shopDispatchRadius = {
                    description = "Approximate police alert radius.",
                    label = "Dispatch radius",
                },
                shopDrillDurationSeconds = {
                    description = "Seconds required to drill the safe.",
                    label = "Safe drill duration",
                },
                shopDrillItem = {
                    description = "Inventory item ID required to drill shop safes. Separate from the ATM drill.",
                    label = "Drill item",
                },
                shopDrillItemAmount = {
                    description = "Number of drill items required.",
                    label = "Required drill amount",
                },
                shopEnabled = {
                    description = "Enables robberies at configured staffed shops.",
                    label = "Enable shop robberies",
                },
                shopHackItem = {
                    description = "Item required for the safe hacking minigame. Enable the opening method separately for each shop.",
                    label = "Hacking item",
                },
                shopHackItemAmount = {
                    description = "Required quantity of the hacking item.",
                    label = "Hacking item amount",
                },
                shopIntimidationSeconds = {
                    description = "Seconds the clerk must remain at gunpoint.",
                    label = "Intimidation duration",
                },
                shopLocations = {
                    description = "One clerk, one register and an optional safe per shop.",
                    itemLabel = "Shop",
                    label = "Shop locations",
                },
                shopMinimumPolice = {
                    description = "On-duty police group members required to start.",
                    label = "Minimum police",
                },
                shopPoliceGroup = {
                    description = "Job group counted for the police requirement.",
                    label = "Police job group",
                },
                shopRegisterDurationSeconds = {
                    description = "Seconds required to empty a register.",
                    label = "Register loot duration",
                },
                shopRegisterRewardMaximum = {
                    description = "Highest register payout.",
                    label = "Maximum register reward",
                },
                shopRegisterRewardMinimum = {
                    description = "Lowest register payout.",
                    label = "Minimum register reward",
                },
                shopRegisterRewardName = {
                    description = "Optional item or account name.",
                    label = "Register reward name",
                },
                shopRegisterRewardSort = {
                    description = "Choose whether registers pay cash or the black_money item.",
                    label = "Register payout type",
                },
                shopRegisters = {
                    description = "Register positions assigned by shop ID.",
                    itemLabel = "Register",
                    label = "Cash registers",
                },
                shopSafeLootDurationSeconds = {
                    description = "Seconds required to take the cash after entering a valid safe code.",
                    label = "Safe loot duration",
                },
                shopSafeRewardMaximum = {
                    description = "Highest safe payout.",
                    label = "Maximum safe reward",
                },
                shopSafeRewardMinimum = {
                    description = "Lowest safe payout.",
                    label = "Minimum safe reward",
                },
                shopSafeRewardName = {
                    description = "Optional item or account name.",
                    label = "Safe reward name",
                },
                shopSafeRewardSort = {
                    description = "Choose whether safes pay cash or the black_money item.",
                    label = "Safe payout type",
                },
                shopThreatGraceSeconds = {
                    description = "Allowed interruption before the alarm.",
                    label = "Aim grace period",
                },
                territoryDrugSalesEnabled = {
                    description = "Successful street sales to NPCs award influence to the seller's gang in the current Street territory.",
                    label = "NPC sales grant territory influence",
                },
                atmLocationMode = {
                    label = "ATM location mode",
                    description = "Automatically discover supported world props or use only manually configured locations.",
                    options = {
                        automatic = "Automatic",
                        manual = "Manual",
                    },
                },
                atmPoliceRequirementEnabled = {
                    label = "Require police",
                    description = "Requires the configured number of on-duty police before an ATM robbery can begin.",
                },
                openDrugCreator = {
                    label = "Drug Creator Menu",
                    description = "Open the Sky Crime Drug Creator menu and close the Job Configurator.",
                    buttonLabel = "Open Drug Creator",
                    unsavedTooltip = "Save first",
                },
                drugCreatorRuntimeDensity = {
                    label = "Runtime Density",
                    description = "Controls how compact the runtime panel is shown inside the Drug Creator.",
                    options = {
                        comfortable = "Comfortable",
                        compact = "Compact",
                    },
                },
                drugCreatorListDensity = {
                    label = "List Density",
                    description = "Controls how compact the creator entry list is shown.",
                    options = {
                        comfortable = "Comfortable",
                        compact = "Compact",
                    },
                },
                drugCreatorShowEmptyRuntimeLists = {
                    label = "Show Empty Runtime Lists",
                    description = "Show runtime sections even when they have no entries.",
                },
                drugCreatorHideDisabledEntries = {
                    label = "Hide Disabled Entries",
                    description = "Hide disabled module entries in the Drug Creator list.",
                },
                drugCreatorAutoGenerateId = {
                    label = "Auto Generate ID",
                    description = "Generate entry IDs from names while creating new Drug Creator entries.",
                },
                drugCreatorOpenEditorOnModuleChange = {
                    label = "Open Editor On Module Change",
                    description = "Open the editor automatically when switching the active creator module.",
                },
                drugCreatorSmartDuplicateSuffix = {
                    label = "Smart Duplicate Suffix",
                    description = "Append a generated suffix when duplicating Drug Creator entries.",
                },
                drugCreatorAutoSelectRuntimeTargets = {
                    label = "Auto Select Runtime Targets",
                    description = "Automatically preselect available runtime labs and batches.",
                },
                drugCreatorAttentionOnOpen = {
                    label = "Attention On Open",
                    description = "Open the runtime panel focused on attention-relevant entries.",
                },
                drugActivityHudPosition = {
                    label = "Activity HUD Position",
                    description = "Drag the placement and harvesting HUD to the desired screen position.",
                },
                drugInteractionHudPosition = {
                    label = "Interaction HUD Position",
                    description = "Drag the plant, laboratory and camper interaction HUD to the desired screen position.",
                },
                drugPlantStatusHudPosition = {
                    label = "Plant Status HUD Position",
                    description = "Drag the detailed plant status HUD to the desired screen position.",
                },
                drugSystemEnabled = {
                    label = "Drug System",
                    description = "Enable drug production, creator data and runtime APIs for this crime job.",
                },
                drugCreatorAccess = {
                    label = "Drug Creator Access",
                    description = "Controls who should be able to open the advanced Drug Creator.",
                    options = {
                        permission = "Permission only",
                        job_management = "Job management",
                        owner_only = "Owner only",
                    },
                },
                drugRuntimeEnabled = {
                    label = "Runtime APIs",
                    description = "Allow players to use live lab, plant, processing and market runtime actions.",
                },
                drugRuntimePlayerCreateLabs = {
                    label = "Player Lab Creation",
                    description = "Allow non-admin players with runtime access to create labs from creator definitions.",
                },
                drugRuntimeOutdoorPlanting = {
                    label = "Outdoor Planting",
                    description = "Allow player-owned outdoor planting outside a configured lab.",
                },
                drugRuntimePublicOutdoorHarvest = {
                    label = "Public Outdoor Harvest",
                    description = "Allow outdoor plants to be harvested by players other than the planter.",
                },
                drugRuntimeChargeLabPurchase = {
                    label = "Charge Lab Purchase",
                    description = "Charge configured lab purchase prices when players create labs.",
                },
                drugRuntimeStrictInventory = {
                    label = "Strict Inventory",
                    description = "Require configured items, tools and money handlers to succeed before runtime actions continue.",
                },
                drugRuntimeSalePayouts = {
                    label = "Sale Payouts",
                    description = "Pay players when batches or routes are sold through the market runtime.",
                },
                drugRuntimeSalePayoutAccount = {
                    label = "Payout Account",
                    description = "Account used for drug sale payouts, for example black_money.",
                },
                drugRuntimeDispatchEnabled = {
                    label = "Dispatch Alerts",
                    description = "Forward drug risk events into dispatch and police job notifications.",
                },
                drugRuntimeNotifyPoliceJobs = {
                    label = "Police Notifications",
                    description = "Notify configured police jobs when a drug risk event creates a police alert.",
                },
                drugBatchPrefix = {
                    label = "Batch Prefix",
                    description = "Prefix used when new drug batches are generated.",
                },
                drugTestingKitAccuracy = {
                    label = "Testing Kit Accuracy",
                    description = "How much hidden value variance a basic testing kit may have.",
                },
                drugDecayIntervalMinutes = {
                    label = "Decay Interval",
                    description = "Minutes between freshness and contamination decay checks.",
                },
                drugDefaultPackaging = {
                    label = "Default Packaging",
                    description = "Packaging used when raw or processed batches are created without an explicit packaging type.",
                    options = {
                        loose = "Loose",
                        baggy = "Baggy",
                        jar = "Jar",
                        vacuum = "Vacuum Bag",
                        brick = "Brick Wrap",
                        premium_seal = "Premium Seal",
                    },
                },
                drugQualityWeightQuality = {
                    label = "Quality Weight",
                    description = "How strongly base quality affects the final score.",
                },
                drugQualityWeightPurity = {
                    label = "Purity Weight",
                    description = "How strongly purity affects the final score.",
                },
                drugQualityWeightFreshness = {
                    label = "Freshness Weight",
                    description = "How strongly freshness affects the final score.",
                },
                drugQualityWeightPotency = {
                    label = "Potency Weight",
                    description = "How strongly potency affects the final score.",
                },
                drugQualityWeightStability = {
                    label = "Stability Weight",
                    description = "How strongly stability affects the final score.",
                },
                drugQualityWeightContamination = {
                    label = "Contamination Penalty",
                    description = "Negative weight applied to contaminated products.",
                },
                drugTierGoodMin = {
                    label = "Good Tier Min",
                    description = "Minimum score for Good quality.",
                },
                drugTierPremiumMin = {
                    label = "Premium Tier Min",
                    description = "Minimum score for Premium quality.",
                },
                drugTierTopShelfMin = {
                    label = "Top Shelf Tier Min",
                    description = "Minimum score for Top Shelf quality.",
                },
                drugTierLabGradeMin = {
                    label = "Lab Grade Tier Min",
                    description = "Minimum score for Lab Grade quality.",
                },
                drugBaggyDecayMultiplier = {
                    label = "Baggy Decay",
                    description = "Freshness decay multiplier for baggies.",
                },
                drugJarDecayMultiplier = {
                    label = "Jar Decay",
                    description = "Freshness decay multiplier for jars.",
                },
                drugVacuumDecayMultiplier = {
                    label = "Vacuum Decay",
                    description = "Freshness decay multiplier for vacuum bags.",
                },
                drugPremiumSealPriceMultiplier = {
                    label = "Premium Seal Price",
                    description = "Price multiplier for premium sealed products.",
                },
                drugGrowingEnabled = {
                    label = "Growing Enabled",
                    description = "Enable plant growth ticks and harvesting.",
                },
                drugEnvironmentSurveyEnabled = {
                    label = "Plant location survey",
                    description = "When enabled, world plants wait for an automatic location survey by an administrator. Disable to grow without admin approval.",
                },
                drugGrowthTickMinutes = {
                    label = "Growth Tick Minutes",
                    description = "Minutes between automatic plant growth updates.",
                },
                drugBaseGrowthPerTick = {
                    label = "Base Growth Per Tick",
                    description = "Base growth gain before strain, equipment and care modifiers.",
                },
                drugWildPlantRespawnMinutes = {
                    label = "Wild Plant Respawn",
                    description = "Minutes before configured wild plant spawns may return.",
                },
                drugWildPlantHighlightEnabled = {
                    label = "Highlight Wild Plants",
                    description = "Outline spawned wild plants when a player is within the highlight radius.",
                },
                drugWildPlantHighlightDistance = {
                    label = "Wild Plant Highlight Radius",
                    description = "Distance in metres around each spawned wild plant at which its outline becomes visible.",
                },
                drugDefaultPlantWater = {
                    label = "Default Water",
                    description = "Water value used when a plant is created.",
                },
                drugDefaultPlantFertilizer = {
                    label = "Default Fertilizer",
                    description = "Fertilizer value used when a plant is created.",
                },
                drugDefaultPlantHealth = {
                    label = "Default Health",
                    description = "Health value used when a plant is created.",
                },
                drugDefaultPlantMutationChance = {
                    label = "Default Mutation Chance",
                    description = "Base mutation chance used for plants without strain override.",
                },
                drugHarvestPerfectStart = {
                    label = "Perfect Harvest Start",
                    description = "Growth percentage where the best harvest window starts.",
                },
                drugHarvestPerfectEnd = {
                    label = "Perfect Harvest End",
                    description = "Growth percentage where the best harvest window ends.",
                },
                drugLabsEnabled = {
                    label = "Labs Enabled",
                    description = "Enable lab and camper runtime instances.",
                },
                drugMaxLaboratoriesPerCharacter = {
                    label = "Laboratories per Character",
                    description = "Maximum owned or rented fixed laboratories per owner. 0 means unlimited; campers and shared access do not count.",
                },
                drugMaxLaboratoriesPerFaction = {
                    label = "Laboratories per Faction",
                    description = "Maximum owned or rented fixed laboratories per owner. 0 means unlimited; campers and shared access do not count.",
                },
                drugDefaultRentDays = {
                    label = "Default Rent Days",
                    description = "Default duration for rented labs.",
                },
                drugCamperHotVehicleMinutes = {
                    label = "Hot Camper Minutes",
                    description = "How long stolen campers should stay risky.",
                },
                drugLabRentWarningHours = {
                    label = "Rent Warning Hours",
                    description = "Hours before rent expiry where labs should be marked as warning.",
                },
                drugLabRentExpiredHeatGain = {
                    label = "Expired Rent Heat",
                    description = "Heat gained when a lab rent expires.",
                },
                drugCamperMoveCooldownMinutes = {
                    label = "Camper Move Cooldown",
                    description = "Minutes before the same camper lab can be moved again.",
                },
                drugLabUpgradeCostMultiplier = {
                    label = "Upgrade Cost Multiplier",
                    description = "Multiplier used when calculating lab tier upgrade prices.",
                },
                drugCamperBaseSlots = {
                    label = "Camper Slots",
                    description = "Default equipment slots for camper labs.",
                },
                drugCamperBaseStorage = {
                    label = "Camper Storage",
                    description = "Default storage capacity for camper labs.",
                },
                drugCamperBasePower = {
                    label = "Camper Power",
                    description = "Default built-in power for camper labs.",
                },
                drugBasementBaseSlots = {
                    label = "Basement Slots",
                    description = "Default equipment slots for basement labs.",
                },
                drugBasementBaseStorage = {
                    label = "Basement Storage",
                    description = "Default storage capacity for basement labs.",
                },
                drugWarehouseBasePower = {
                    label = "Warehouse Power",
                    description = "Default built-in power for warehouse labs.",
                },
                drugPowerEnabled = {
                    label = "Power System",
                    description = "Enable lab power generation, consumption and overload checks.",
                },
                drugOverloadGraceSeconds = {
                    label = "Overload Grace",
                    description = "Seconds before overloaded power should become dangerous.",
                },
                drugHeatPerKilowatt = {
                    label = "Heat Per Kilowatt",
                    description = "How much lab heat is generated by power consumption.",
                },
                drugGeneratorT1Watts = {
                    label = "Generator T1 Watts",
                    description = "Power output for T1 generators.",
                },
                drugGeneratorT2Watts = {
                    label = "Generator T2 Watts",
                    description = "Power output for T2 generators.",
                },
                drugGeneratorT3Watts = {
                    label = "Generator T3 Watts",
                    description = "Power output for T3 generators.",
                },
                drugEquipmentConditionWearMultiplier = {
                    label = "Wear Multiplier",
                    description = "Global multiplier for equipment wear caused by processing.",
                },
                drugWorkersEnabled = {
                    label = "Workers Enabled",
                    description = "Enable chemists, growers, packagers and security staff in drug labs.",
                },
                drugMaxWorkersPerLab = {
                    label = "Max Workers / Lab",
                    description = "Maximum number of workers that can be assigned to one lab.",
                },
                drugWorkerFatiguePerProcessStep = {
                    label = "Process Fatigue",
                    description = "Fatigue added to matching workers after a processing step.",
                },
                drugWorkerFatiguePerGrowAction = {
                    label = "Grow Fatigue",
                    description = "Fatigue added to growers after harvest or grow work.",
                },
                drugWorkerRecoveryPerTick = {
                    label = "Worker Recovery",
                    description = "Fatigue recovery per growing tick.",
                },
                drugMarketEnabled = {
                    label = "Market Enabled",
                    description = "Enable buyer, dealer and batch selling runtime.",
                },
                drugMarketBasePriceFallback = {
                    label = "Fallback Base Price",
                    description = "Base price used when a drug definition has no custom price.",
                },
                drugMarketStreetMultiplier = {
                    label = "Street Multiplier",
                    description = "Global price multiplier for street sales.",
                },
                drugMarketWholesaleMultiplier = {
                    label = "Wholesale Multiplier",
                    description = "Global price multiplier for wholesale deals.",
                },
                drugMarketPremiumMultiplier = {
                    label = "Premium Multiplier",
                    description = "Global price multiplier for premium buyers.",
                },
                drugMarketHeatPerSale = {
                    label = "Heat / Sale",
                    description = "Base heat added to a lab when a batch is sold.",
                },
                drugDistributionTickMinutes = {
                    label = "Distribution Tick",
                    description = "Minutes between automatic dealer distribution updates.",
                },
                drugDistributionIntervalMinutes = {
                    label = "Distribution Interval",
                    description = "Default minutes a dealer needs before attempting a sale.",
                },
                drugDistributionMaxPerDealer = {
                    label = "Max Dealer Orders",
                    description = "Default maximum active distribution orders per dealer.",
                },
                drugThreatsEnabled = {
                    label = "Threats Enabled",
                    description = "Enable lab heat decay, raids and sabotage events.",
                },
                drugThreatTickMinutes = {
                    label = "Threat Tick",
                    description = "Minutes between heat decay and raid/sabotage checks.",
                },
                drugRaidHeatThreshold = {
                    label = "Raid Heat",
                    description = "Lab heat required before raid rolls can happen.",
                },
                drugSabotageHeatThreshold = {
                    label = "Sabotage Heat",
                    description = "Lab heat required before sabotage rolls can happen.",
                },
                drugThreatHeatDecay = {
                    label = "Heat Decay",
                    description = "Heat removed from labs per threat tick.",
                },
                drugRaidChanceAtThreshold = {
                    label = "Raid Chance",
                    description = "Base raid chance once the raid heat threshold is reached.",
                },
                drugSabotageChanceAtThreshold = {
                    label = "Sabotage Chance",
                    description = "Base sabotage chance once the sabotage heat threshold is reached.",
                },
                drugConsumptionEnabled = {
                    label = "Consumption Enabled",
                    description = "Enable drug effects, tolerance and addiction tracking.",
                },
                drugDoseConsumesBatch = {
                    label = "Dose Consumes Batch",
                    description = "Whether a consumed batch should be removed from runtime stock.",
                },
                drugToleranceDecayMinutes = {
                    label = "Tolerance Decay",
                    description = "Minutes used for tolerance decay updates.",
                },
                drugAddictionDecayMinutes = {
                    label = "Addiction Decay",
                    description = "Minutes used for addiction decay updates.",
                },
                drugPotencyEffectMultiplier = {
                    label = "Potency Multiplier",
                    description = "How strongly potency increases effect intensity.",
                },
                drugOverdosePotencyThreshold = {
                    label = "Overdose Threshold",
                    description = "Potency pressure required before overdose rolls happen.",
                },
                drugBaseAddictionGain = {
                    label = "Base Addiction Gain",
                    description = "Base addiction gained per dose.",
                },
                drugProcessingEnabled = {
                    label = "Processing Enabled",
                    description = "Enable processing jobs, packaging and testing kit runtime.",
                },
                drugBatchMetadataItemKey = {
                    label = "Batch Metadata Key",
                    description = "Inventory metadata key used by integrations for batch data.",
                },
                drugDefaultProcessDuration = {
                    label = "Default Process Time",
                    description = "Default processing duration in seconds when a recipe has no custom duration.",
                },
                drugDefaultFailureRisk = {
                    label = "Default Failure Risk",
                    description = "Default processing failure risk when a recipe has no custom risk.",
                },
                drugPackagingDuration = {
                    label = "Packaging Time",
                    description = "Default packaging duration in seconds.",
                },
                drugPowerTickSeconds = {
                    label = "Power Tick Seconds",
                    description = "Seconds between generator consumption and power signature updates.",
                },
                drugPowerSignatureHeatPerHour = {
                    label = "Signature Heat / Hour",
                    description = "Heat generated per hour from the laboratory power signature.",
                },
                drugPowerOverloadHeatPerHour = {
                    label = "Overload Heat / Hour",
                    description = "Additional heat generated per hour while the laboratory is overloaded.",
                },
                drugPowerIdleHeatDecayPerHour = {
                    label = "Idle Heat Decay / Hour",
                    description = "Heat removed per hour while the laboratory has no active power signature.",
                },
                drugPowerModeManualMaxLoadPercent = {
                    label = "Manual / Maximum Load",
                    description = "Maximum Load used by the manual power mode.",
                },
                drugPowerModeManualHeatMultiplier = {
                    label = "Manual / Heat Multiplier",
                    description = "Heat Multiplier used by the manual power mode.",
                },
                drugPowerModeManualNoiseMultiplier = {
                    label = "Manual / Noise Multiplier",
                    description = "Noise Multiplier used by the manual power mode.",
                },
                drugPowerModeBalancedMaxLoadPercent = {
                    label = "Balanced / Maximum Load",
                    description = "Maximum Load used by the balanced power mode.",
                },
                drugPowerModeBalancedHeatMultiplier = {
                    label = "Balanced / Heat Multiplier",
                    description = "Heat Multiplier used by the balanced power mode.",
                },
                drugPowerModeBalancedNoiseMultiplier = {
                    label = "Balanced / Noise Multiplier",
                    description = "Noise Multiplier used by the balanced power mode.",
                },
                drugPowerModeStealthMaxLoadPercent = {
                    label = "Stealth / Maximum Load",
                    description = "Maximum Load used by the stealth power mode.",
                },
                drugPowerModeStealthHeatMultiplier = {
                    label = "Stealth / Heat Multiplier",
                    description = "Heat Multiplier used by the stealth power mode.",
                },
                drugPowerModeStealthNoiseMultiplier = {
                    label = "Stealth / Noise Multiplier",
                    description = "Noise Multiplier used by the stealth power mode.",
                },
                drugPowerPrioritySmellControl = {
                    label = "Smell Control Priority",
                    description = "Automatic load-shedding priority for smell control equipment.",
                },
                drugPowerPriorityAirflow = {
                    label = "Airflow Priority",
                    description = "Automatic load-shedding priority for airflow equipment.",
                },
                drugPowerPrioritySecurity = {
                    label = "Security Priority",
                    description = "Automatic load-shedding priority for security equipment.",
                },
                drugPowerPriorityGrowing = {
                    label = "Growing Priority",
                    description = "Automatic load-shedding priority for growing equipment.",
                },
                drugPowerPriorityLight = {
                    label = "Lighting Priority",
                    description = "Automatic load-shedding priority for lighting equipment.",
                },
                drugPowerPriorityTesting = {
                    label = "Testing Priority",
                    description = "Automatic load-shedding priority for testing equipment.",
                },
                drugPowerPriorityPackaging = {
                    label = "Packaging Priority",
                    description = "Automatic load-shedding priority for packaging equipment.",
                },
                drugPowerPriorityChemistry = {
                    label = "Chemistry Priority",
                    description = "Automatic load-shedding priority for chemistry equipment.",
                },
                drugPowerPriorityHeating = {
                    label = "Heating Priority",
                    description = "Automatic load-shedding priority for heating equipment.",
                },
                drugPowerPriorityPressing = {
                    label = "Pressing Priority",
                    description = "Automatic load-shedding priority for pressing equipment.",
                },
                drugPowerPriorityGeneral = {
                    label = "General Priority",
                    description = "Automatic load-shedding priority for general equipment.",
                },
                drugAdvancedPerformanceInactiveControlIntervalMs = {
                    label = "Performance / Inactive Control Interval Ms",
                    description = "Runtime setting for Performance / Inactive Control Interval Ms.",
                },
                drugAdvancedPerformanceInteractionIdleScanIntervalMs = {
                    label = "Performance / Interaction Idle Scan Interval Ms",
                    description = "Runtime setting for Performance / Interaction Idle Scan Interval Ms.",
                },
                drugAdvancedPerformanceInteractionPromptIntervalMs = {
                    label = "Performance / Interaction Prompt Interval Ms",
                    description = "Runtime setting for Performance / Interaction Prompt Interval Ms.",
                },
                drugAdvancedPerformanceInteractionScanIntervalMs = {
                    label = "Performance / Interaction Scan Interval Ms",
                    description = "Runtime setting for Performance / Interaction Scan Interval Ms.",
                },
                drugAdvancedPerformanceMinimumScanIntervalMs = {
                    label = "Performance / Minimum Scan Interval Ms",
                    description = "Runtime setting for Performance / Minimum Scan Interval Ms.",
                },
                drugAdvancedPerformanceStreetPedActivationDistance = {
                    label = "Performance / Street Ped Activation Distance",
                    description = "Runtime setting for Performance / Street Ped Activation Distance.",
                },
                drugAdvancedPerformanceStreetPedIdleScanIntervalMs = {
                    label = "Performance / Street Ped Idle Scan Interval Ms",
                    description = "Runtime setting for Performance / Street Ped Idle Scan Interval Ms.",
                },
                drugAdvancedPerformanceStreetPedScanIntervalMs = {
                    label = "Performance / Street Ped Scan Interval Ms",
                    description = "Runtime setting for Performance / Street Ped Scan Interval Ms.",
                },
                drugAdvancedPerformanceWorldCachePadding = {
                    label = "Performance / World Cache Padding",
                    description = "Runtime setting for Performance / World Cache Padding.",
                },
                drugAdvancedPerformanceWorldCacheRefreshIntervalMs = {
                    label = "Performance / World Cache Refresh Interval Ms",
                    description = "Runtime setting for Performance / World Cache Refresh Interval Ms.",
                },
                drugAdvancedPerformanceWorldIdleIntervalMs = {
                    label = "Performance / World Idle Interval Ms",
                    description = "Runtime setting for Performance / World Idle Interval Ms.",
                },
                drugAdvancedDynamicMarketActionCooldownSeconds = {
                    label = "Dynamic Market / Action Cooldown Seconds",
                    description = "Runtime setting for Dynamic Market / Action Cooldown Seconds.",
                },
                drugAdvancedDynamicMarketActionHistoryLimit = {
                    label = "Dynamic Market / Action History Limit",
                    description = "Runtime setting for Dynamic Market / Action History Limit.",
                },
                drugAdvancedDynamicMarketAmountSaturationWeight = {
                    label = "Dynamic Market / Amount Saturation Weight",
                    description = "Runtime setting for Dynamic Market / Amount Saturation Weight.",
                },
                drugAdvancedDynamicMarketBaseIntelAccuracy = {
                    label = "Dynamic Market / Base Intel Accuracy",
                    description = "Runtime setting for Dynamic Market / Base Intel Accuracy.",
                },
                drugAdvancedDynamicMarketDefaultAverageQuality = {
                    label = "Dynamic Market / Default Average Quality",
                    description = "Runtime setting for Dynamic Market / Default Average Quality.",
                },
                drugAdvancedDynamicMarketDefaultResourceElasticity = {
                    label = "Dynamic Market / Default Resource Elasticity",
                    description = "Runtime setting for Dynamic Market / Default Resource Elasticity.",
                },
                drugAdvancedDynamicMarketDemandCenter = {
                    label = "Dynamic Market / Demand Center",
                    description = "Runtime setting for Dynamic Market / Demand Center.",
                },
                drugAdvancedDynamicMarketDemandPriceImpact = {
                    label = "Dynamic Market / Demand Price Impact",
                    description = "Runtime setting for Dynamic Market / Demand Price Impact.",
                },
                drugAdvancedDynamicMarketDirectionThreshold = {
                    label = "Dynamic Market / Direction Threshold",
                    description = "Runtime setting for Dynamic Market / Direction Threshold.",
                },
                drugAdvancedDynamicMarketEnabled = {
                    label = "Dynamic Market / Enabled",
                    description = "Runtime setting for Dynamic Market / Enabled.",
                },
                drugAdvancedDynamicMarketEventChance = {
                    label = "Dynamic Market / Event Chance",
                    description = "Runtime setting for Dynamic Market / Event Chance.",
                },
                drugAdvancedDynamicMarketEventDurationMinutes = {
                    label = "Dynamic Market / Event Duration Minutes",
                    description = "Runtime setting for Dynamic Market / Event Duration Minutes.",
                },
                drugAdvancedDynamicMarketEventMinimumDurationMinutes = {
                    label = "Dynamic Market / Event Minimum Duration Minutes",
                    description = "Runtime setting for Dynamic Market / Event Minimum Duration Minutes.",
                },
                drugAdvancedDynamicMarketEventStrengthMaximum = {
                    label = "Dynamic Market / Event Strength Maximum",
                    description = "Runtime setting for Dynamic Market / Event Strength Maximum.",
                },
                drugAdvancedDynamicMarketEventStrengthMinimum = {
                    label = "Dynamic Market / Event Strength Minimum",
                    description = "Runtime setting for Dynamic Market / Event Strength Minimum.",
                },
                drugAdvancedDynamicMarketEventsCrackdownDemand = {
                    label = "Dynamic Market / Events / Crackdown / Demand",
                    description = "Runtime setting for Dynamic Market / Events / Crackdown / Demand.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPolice = {
                    label = "Dynamic Market / Events / Crackdown / Police",
                    description = "Runtime setting for Dynamic Market / Events / Crackdown / Police.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPrice = {
                    label = "Dynamic Market / Events / Crackdown / Price",
                    description = "Runtime setting for Dynamic Market / Events / Crackdown / Price.",
                },
                drugAdvancedDynamicMarketEventsFestivalDemand = {
                    label = "Dynamic Market / Events / Festival / Demand",
                    description = "Runtime setting for Dynamic Market / Events / Festival / Demand.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem1 = {
                    label = "Dynamic Market / Events / Festival / Effects / 1",
                    description = "Runtime setting for Dynamic Market / Events / Festival / Effects / 1.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem2 = {
                    label = "Dynamic Market / Events / Festival / Effects / 2",
                    description = "Runtime setting for Dynamic Market / Events / Festival / Effects / 2.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem3 = {
                    label = "Dynamic Market / Events / Festival / Effects / 3",
                    description = "Runtime setting for Dynamic Market / Events / Festival / Effects / 3.",
                },
                drugAdvancedDynamicMarketEventsFestivalPrice = {
                    label = "Dynamic Market / Events / Festival / Price",
                    description = "Runtime setting for Dynamic Market / Events / Festival / Price.",
                },
                drugAdvancedDynamicMarketEventsFestivalProfilesItem1 = {
                    label = "Dynamic Market / Events / Festival / Profiles / 1",
                    description = "Runtime setting for Dynamic Market / Events / Festival / Profiles / 1.",
                },
                drugAdvancedDynamicMarketEventsGangconflictDemand = {
                    label = "Dynamic Market / Events / Gang conflict / Demand",
                    description = "Runtime setting for Dynamic Market / Events / Gang conflict / Demand.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPolice = {
                    label = "Dynamic Market / Events / Gang conflict / Police",
                    description = "Runtime setting for Dynamic Market / Events / Gang conflict / Police.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPrice = {
                    label = "Dynamic Market / Events / Gang conflict / Price",
                    description = "Runtime setting for Dynamic Market / Events / Gang conflict / Price.",
                },
                drugAdvancedDynamicMarketEventsGangconflictProfilesItem1 = {
                    label = "Dynamic Market / Events / Gang conflict / Profiles / 1",
                    description = "Runtime setting for Dynamic Market / Events / Gang conflict / Profiles / 1.",
                },
                drugAdvancedDynamicMarketEventsLabbustDemand = {
                    label = "Dynamic Market / Events / Lab bust / Demand",
                    description = "Runtime setting for Dynamic Market / Events / Lab bust / Demand.",
                },
                drugAdvancedDynamicMarketEventsLabbustPolice = {
                    label = "Dynamic Market / Events / Lab bust / Police",
                    description = "Runtime setting for Dynamic Market / Events / Lab bust / Police.",
                },
                drugAdvancedDynamicMarketEventsLabbustPrice = {
                    label = "Dynamic Market / Events / Lab bust / Price",
                    description = "Runtime setting for Dynamic Market / Events / Lab bust / Price.",
                },
                drugAdvancedDynamicMarketEventsLabbustSupply = {
                    label = "Dynamic Market / Events / Lab bust / Supply",
                    description = "Runtime setting for Dynamic Market / Events / Lab bust / Supply.",
                },
                drugAdvancedDynamicMarketEventsPartyDemand = {
                    label = "Dynamic Market / Events / Party / Demand",
                    description = "Runtime setting for Dynamic Market / Events / Party / Demand.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem1 = {
                    label = "Dynamic Market / Events / Party / Effects / 1",
                    description = "Runtime setting for Dynamic Market / Events / Party / Effects / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem2 = {
                    label = "Dynamic Market / Events / Party / Effects / 2",
                    description = "Runtime setting for Dynamic Market / Events / Party / Effects / 2.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem3 = {
                    label = "Dynamic Market / Events / Party / Effects / 3",
                    description = "Runtime setting for Dynamic Market / Events / Party / Effects / 3.",
                },
                drugAdvancedDynamicMarketEventsPartyPrice = {
                    label = "Dynamic Market / Events / Party / Price",
                    description = "Runtime setting for Dynamic Market / Events / Party / Price.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem1 = {
                    label = "Dynamic Market / Events / Party / Profiles / 1",
                    description = "Runtime setting for Dynamic Market / Events / Party / Profiles / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem2 = {
                    label = "Dynamic Market / Events / Party / Profiles / 2",
                    description = "Runtime setting for Dynamic Market / Events / Party / Profiles / 2.",
                },
                drugAdvancedDynamicMarketEventsShortageDemand = {
                    label = "Dynamic Market / Events / Shortage / Demand",
                    description = "Runtime setting for Dynamic Market / Events / Shortage / Demand.",
                },
                drugAdvancedDynamicMarketEventsShortagePrice = {
                    label = "Dynamic Market / Events / Shortage / Price",
                    description = "Runtime setting for Dynamic Market / Events / Shortage / Price.",
                },
                drugAdvancedDynamicMarketEventsShortageSupply = {
                    label = "Dynamic Market / Events / Shortage / Supply",
                    description = "Runtime setting for Dynamic Market / Events / Shortage / Supply.",
                },
                drugAdvancedDynamicMarketExactIntelReputation = {
                    label = "Dynamic Market / Exact Intel Reputation",
                    description = "Runtime setting for Dynamic Market / Exact Intel Reputation.",
                },
                drugAdvancedDynamicMarketExactIntelTrust = {
                    label = "Dynamic Market / Exact Intel Trust",
                    description = "Runtime setting for Dynamic Market / Exact Intel Trust.",
                },
                drugAdvancedDynamicMarketGlobalZoneLabel = {
                    label = "Dynamic Market / Global Zone Label",
                    description = "Runtime setting for Dynamic Market / Global Zone Label.",
                },
                drugAdvancedDynamicMarketHistoryLimit = {
                    label = "Dynamic Market / History Limit",
                    description = "Runtime setting for Dynamic Market / History Limit.",
                },
                drugAdvancedDynamicMarketInitialDemand = {
                    label = "Dynamic Market / Initial Demand",
                    description = "Runtime setting for Dynamic Market / Initial Demand.",
                },
                drugAdvancedDynamicMarketInitialPriceMultiplier = {
                    label = "Dynamic Market / Initial Price Multiplier",
                    description = "Runtime setting for Dynamic Market / Initial Price Multiplier.",
                },
                drugAdvancedDynamicMarketIntelDemandError = {
                    label = "Dynamic Market / Intel Demand Error",
                    description = "Runtime setting for Dynamic Market / Intel Demand Error.",
                },
                drugAdvancedDynamicMarketIntelMaximumAccuracy = {
                    label = "Dynamic Market / Intel Maximum Accuracy",
                    description = "Runtime setting for Dynamic Market / Intel Maximum Accuracy.",
                },
                drugAdvancedDynamicMarketIntelMinimumAccuracy = {
                    label = "Dynamic Market / Intel Minimum Accuracy",
                    description = "Runtime setting for Dynamic Market / Intel Minimum Accuracy.",
                },
                drugAdvancedDynamicMarketIntelPoliceError = {
                    label = "Dynamic Market / Intel Police Error",
                    description = "Runtime setting for Dynamic Market / Intel Police Error.",
                },
                drugAdvancedDynamicMarketIntelPriceError = {
                    label = "Dynamic Market / Intel Price Error",
                    description = "Runtime setting for Dynamic Market / Intel Price Error.",
                },
                drugAdvancedDynamicMarketIntelPriceMaximum = {
                    label = "Dynamic Market / Intel Price Maximum",
                    description = "Runtime setting for Dynamic Market / Intel Price Maximum.",
                },
                drugAdvancedDynamicMarketIntelPriceMinimum = {
                    label = "Dynamic Market / Intel Price Minimum",
                    description = "Runtime setting for Dynamic Market / Intel Price Minimum.",
                },
                drugAdvancedDynamicMarketIntelReputationWeight = {
                    label = "Dynamic Market / Intel Reputation Weight",
                    description = "Runtime setting for Dynamic Market / Intel Reputation Weight.",
                },
                drugAdvancedDynamicMarketIntelResourcePriceError = {
                    label = "Dynamic Market / Intel Resource Price Error",
                    description = "Runtime setting for Dynamic Market / Intel Resource Price Error.",
                },
                drugAdvancedDynamicMarketIntelSaturationError = {
                    label = "Dynamic Market / Intel Saturation Error",
                    description = "Runtime setting for Dynamic Market / Intel Saturation Error.",
                },
                drugAdvancedDynamicMarketIntelSeedBucketSeconds = {
                    label = "Dynamic Market / Intel Seed Bucket Seconds",
                    description = "Runtime setting for Dynamic Market / Intel Seed Bucket Seconds.",
                },
                drugAdvancedDynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Dynamic Market / Intel Status Accuracy Threshold",
                    description = "Runtime setting for Dynamic Market / Intel Status Accuracy Threshold.",
                },
                drugAdvancedDynamicMarketIntelStatusErrorThreshold = {
                    label = "Dynamic Market / Intel Status Error Threshold",
                    description = "Runtime setting for Dynamic Market / Intel Status Error Threshold.",
                },
                drugAdvancedDynamicMarketIntelSupplyError = {
                    label = "Dynamic Market / Intel Supply Error",
                    description = "Runtime setting for Dynamic Market / Intel Supply Error.",
                },
                drugAdvancedDynamicMarketIntelTrustWeight = {
                    label = "Dynamic Market / Intel Trust Weight",
                    description = "Runtime setting for Dynamic Market / Intel Trust Weight.",
                },
                drugAdvancedDynamicMarketManipulationCooldownMinutes = {
                    label = "Dynamic Market / Manipulation Cooldown Minutes",
                    description = "Runtime setting for Dynamic Market / Manipulation Cooldown Minutes.",
                },
                drugAdvancedDynamicMarketManipulationDemandShift = {
                    label = "Dynamic Market / Manipulation Demand Shift",
                    description = "Runtime setting for Dynamic Market / Manipulation Demand Shift.",
                },
                drugAdvancedDynamicMarketManipulationDurationMinutes = {
                    label = "Dynamic Market / Manipulation Duration Minutes",
                    description = "Runtime setting for Dynamic Market / Manipulation Duration Minutes.",
                },
                drugAdvancedDynamicMarketManipulationHeat = {
                    label = "Dynamic Market / Manipulation Heat",
                    description = "Runtime setting for Dynamic Market / Manipulation Heat.",
                },
                drugAdvancedDynamicMarketManipulationMinimumBatchAmount = {
                    label = "Dynamic Market / Manipulation Minimum Batch Amount",
                    description = "Runtime setting for Dynamic Market / Manipulation Minimum Batch Amount.",
                },
                drugAdvancedDynamicMarketManipulationPaymentAccount = {
                    label = "Dynamic Market / Manipulation Payment Account",
                    description = "Runtime setting for Dynamic Market / Manipulation Payment Account.",
                },
                drugAdvancedDynamicMarketManipulationPrice = {
                    label = "Dynamic Market / Manipulation Price",
                    description = "Runtime setting for Dynamic Market / Manipulation Price.",
                },
                drugAdvancedDynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Dynamic Market / Manipulation Zone Heat Multiplier",
                    description = "Runtime setting for Dynamic Market / Manipulation Zone Heat Multiplier.",
                },
                drugAdvancedDynamicMarketMaximumIntelAgeMinutes = {
                    label = "Dynamic Market / Maximum Intel Age Minutes",
                    description = "Runtime setting for Dynamic Market / Maximum Intel Age Minutes.",
                },
                drugAdvancedDynamicMarketMaximumPriceMultiplier = {
                    label = "Dynamic Market / Maximum Price Multiplier",
                    description = "Runtime setting for Dynamic Market / Maximum Price Multiplier.",
                },
                drugAdvancedDynamicMarketMinimumIntelAgeMinutes = {
                    label = "Dynamic Market / Minimum Intel Age Minutes",
                    description = "Runtime setting for Dynamic Market / Minimum Intel Age Minutes.",
                },
                drugAdvancedDynamicMarketMinimumMetricWindowMinutes = {
                    label = "Dynamic Market / Minimum Metric Window Minutes",
                    description = "Runtime setting for Dynamic Market / Minimum Metric Window Minutes.",
                },
                drugAdvancedDynamicMarketMinimumPriceMultiplier = {
                    label = "Dynamic Market / Minimum Price Multiplier",
                    description = "Runtime setting for Dynamic Market / Minimum Price Multiplier.",
                },
                drugAdvancedDynamicMarketMinimumUpdateMinutes = {
                    label = "Dynamic Market / Minimum Update Minutes",
                    description = "Runtime setting for Dynamic Market / Minimum Update Minutes.",
                },
                drugAdvancedDynamicMarketPoliceDemandWeight = {
                    label = "Dynamic Market / Police Demand Weight",
                    description = "Runtime setting for Dynamic Market / Police Demand Weight.",
                },
                drugAdvancedDynamicMarketPolicePriceImpact = {
                    label = "Dynamic Market / Police Price Impact",
                    description = "Runtime setting for Dynamic Market / Police Price Impact.",
                },
                drugAdvancedDynamicMarketPoorQualityDemandPenalty = {
                    label = "Dynamic Market / Poor Quality Demand Penalty",
                    description = "Runtime setting for Dynamic Market / Poor Quality Demand Penalty.",
                },
                drugAdvancedDynamicMarketPoorQualityThreshold = {
                    label = "Dynamic Market / Poor Quality Threshold",
                    description = "Runtime setting for Dynamic Market / Poor Quality Threshold.",
                },
                drugAdvancedDynamicMarketPremiumQualityDemandBonus = {
                    label = "Dynamic Market / Premium Quality Demand Bonus",
                    description = "Runtime setting for Dynamic Market / Premium Quality Demand Bonus.",
                },
                drugAdvancedDynamicMarketPremiumQualityThreshold = {
                    label = "Dynamic Market / Premium Quality Threshold",
                    description = "Runtime setting for Dynamic Market / Premium Quality Threshold.",
                },
                drugAdvancedDynamicMarketProductionSupplyWeight = {
                    label = "Dynamic Market / Production Supply Weight",
                    description = "Runtime setting for Dynamic Market / Production Supply Weight.",
                },
                drugAdvancedDynamicMarketProductionWindowMinutes = {
                    label = "Dynamic Market / Production Window Minutes",
                    description = "Runtime setting for Dynamic Market / Production Window Minutes.",
                },
                drugAdvancedDynamicMarketQualityCenter = {
                    label = "Dynamic Market / Quality Center",
                    description = "Runtime setting for Dynamic Market / Quality Center.",
                },
                drugAdvancedDynamicMarketQualityConfidenceImpact = {
                    label = "Dynamic Market / Quality Confidence Impact",
                    description = "Runtime setting for Dynamic Market / Quality Confidence Impact.",
                },
                drugAdvancedDynamicMarketQualityRange = {
                    label = "Dynamic Market / Quality Range",
                    description = "Runtime setting for Dynamic Market / Quality Range.",
                },
                drugAdvancedDynamicMarketRarityBonusMaximum = {
                    label = "Dynamic Market / Rarity Bonus Maximum",
                    description = "Runtime setting for Dynamic Market / Rarity Bonus Maximum.",
                },
                drugAdvancedDynamicMarketRegionalGlobalWeight = {
                    label = "Dynamic Market / Regional Global Weight",
                    description = "Runtime setting for Dynamic Market / Regional Global Weight.",
                },
                drugAdvancedDynamicMarketRegionalLocalWeight = {
                    label = "Dynamic Market / Regional Local Weight",
                    description = "Runtime setting for Dynamic Market / Regional Local Weight.",
                },
                drugAdvancedDynamicMarketResourceAliasesDrugpackaging = {
                    label = "Dynamic Market / Resource Aliases / Drug packaging",
                    description = "Runtime setting for Dynamic Market / Resource Aliases / Drug packaging.",
                },
                drugAdvancedDynamicMarketResourceAliasesFuelcan = {
                    label = "Dynamic Market / Resource Aliases / Fuel can",
                    description = "Runtime setting for Dynamic Market / Resource Aliases / Fuel can.",
                },
                drugAdvancedDynamicMarketResourceAliasesMachineoil = {
                    label = "Dynamic Market / Resource Aliases / Machine oil",
                    description = "Runtime setting for Dynamic Market / Resource Aliases / Machine oil.",
                },
                drugAdvancedDynamicMarketResourceAliasesPlantnutrients = {
                    label = "Dynamic Market / Resource Aliases / Plant nutrients",
                    description = "Runtime setting for Dynamic Market / Resource Aliases / Plant nutrients.",
                },
                drugAdvancedDynamicMarketResourceAliasesRepairkit = {
                    label = "Dynamic Market / Resource Aliases / Repair kit",
                    description = "Runtime setting for Dynamic Market / Resource Aliases / Repair kit.",
                },
                drugAdvancedDynamicMarketResourceDirectionFallThreshold = {
                    label = "Dynamic Market / Resource Direction Fall Threshold",
                    description = "Runtime setting for Dynamic Market / Resource Direction Fall Threshold.",
                },
                drugAdvancedDynamicMarketResourceDirectionRiseThreshold = {
                    label = "Dynamic Market / Resource Direction Rise Threshold",
                    description = "Runtime setting for Dynamic Market / Resource Direction Rise Threshold.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterBasePrice = {
                    label = "Dynamic Market / Resources / Carbon filter / Base Price",
                    description = "Runtime setting for Dynamic Market / Resources / Carbon filter / Base Price.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterElasticity = {
                    label = "Dynamic Market / Resources / Carbon filter / Elasticity",
                    description = "Runtime setting for Dynamic Market / Resources / Carbon filter / Elasticity.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLabel = {
                    label = "Dynamic Market / Resources / Carbon filter / Label",
                    description = "Runtime setting for Dynamic Market / Resources / Carbon filter / Label.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem1 = {
                    label = "Dynamic Market / Resources / Carbon filter / Linked Drugs / 1",
                    description = "Runtime setting for Dynamic Market / Resources / Carbon filter / Linked Drugs / 1.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem2 = {
                    label = "Dynamic Market / Resources / Carbon filter / Linked Drugs / 2",
                    description = "Runtime setting for Dynamic Market / Resources / Carbon filter / Linked Drugs / 2.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem3 = {
                    label = "Dynamic Market / Resources / Carbon filter / Linked Drugs / 3",
                    description = "Runtime setting for Dynamic Market / Resources / Carbon filter / Linked Drugs / 3.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorBasePrice = {
                    label = "Dynamic Market / Resources / Chemical precursor / Base Price",
                    description = "Runtime setting for Dynamic Market / Resources / Chemical precursor / Base Price.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorElasticity = {
                    label = "Dynamic Market / Resources / Chemical precursor / Elasticity",
                    description = "Runtime setting for Dynamic Market / Resources / Chemical precursor / Elasticity.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLabel = {
                    label = "Dynamic Market / Resources / Chemical precursor / Label",
                    description = "Runtime setting for Dynamic Market / Resources / Chemical precursor / Label.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem1 = {
                    label = "Dynamic Market / Resources / Chemical precursor / Linked Drugs / 1",
                    description = "Runtime setting for Dynamic Market / Resources / Chemical precursor / Linked Drugs / 1.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem2 = {
                    label = "Dynamic Market / Resources / Chemical precursor / Linked Drugs / 2",
                    description = "Runtime setting for Dynamic Market / Resources / Chemical precursor / Linked Drugs / 2.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsBasePrice = {
                    label = "Dynamic Market / Resources / Equipment parts / Base Price",
                    description = "Runtime setting for Dynamic Market / Resources / Equipment parts / Base Price.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsElasticity = {
                    label = "Dynamic Market / Resources / Equipment parts / Elasticity",
                    description = "Runtime setting for Dynamic Market / Resources / Equipment parts / Elasticity.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsLabel = {
                    label = "Dynamic Market / Resources / Equipment parts / Label",
                    description = "Runtime setting for Dynamic Market / Resources / Equipment parts / Label.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerBasePrice = {
                    label = "Dynamic Market / Resources / Fertilizer / Base Price",
                    description = "Runtime setting for Dynamic Market / Resources / Fertilizer / Base Price.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerElasticity = {
                    label = "Dynamic Market / Resources / Fertilizer / Elasticity",
                    description = "Runtime setting for Dynamic Market / Resources / Fertilizer / Elasticity.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLabel = {
                    label = "Dynamic Market / Resources / Fertilizer / Label",
                    description = "Runtime setting for Dynamic Market / Resources / Fertilizer / Label.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLinkedDrugsItem1 = {
                    label = "Dynamic Market / Resources / Fertilizer / Linked Drugs / 1",
                    description = "Runtime setting for Dynamic Market / Resources / Fertilizer / Linked Drugs / 1.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelBasePrice = {
                    label = "Dynamic Market / Resources / Laboratory fuel / Base Price",
                    description = "Runtime setting for Dynamic Market / Resources / Laboratory fuel / Base Price.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelElasticity = {
                    label = "Dynamic Market / Resources / Laboratory fuel / Elasticity",
                    description = "Runtime setting for Dynamic Market / Resources / Laboratory fuel / Elasticity.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelLabel = {
                    label = "Dynamic Market / Resources / Laboratory fuel / Label",
                    description = "Runtime setting for Dynamic Market / Resources / Laboratory fuel / Label.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagBasePrice = {
                    label = "Dynamic Market / Resources / Packaging bag / Base Price",
                    description = "Runtime setting for Dynamic Market / Resources / Packaging bag / Base Price.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagElasticity = {
                    label = "Dynamic Market / Resources / Packaging bag / Elasticity",
                    description = "Runtime setting for Dynamic Market / Resources / Packaging bag / Elasticity.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagLabel = {
                    label = "Dynamic Market / Resources / Packaging bag / Label",
                    description = "Runtime setting for Dynamic Market / Resources / Packaging bag / Label.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotBasePrice = {
                    label = "Dynamic Market / Resources / Plant pot / Base Price",
                    description = "Runtime setting for Dynamic Market / Resources / Plant pot / Base Price.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotElasticity = {
                    label = "Dynamic Market / Resources / Plant pot / Elasticity",
                    description = "Runtime setting for Dynamic Market / Resources / Plant pot / Elasticity.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLabel = {
                    label = "Dynamic Market / Resources / Plant pot / Label",
                    description = "Runtime setting for Dynamic Market / Resources / Plant pot / Label.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLinkedDrugsItem1 = {
                    label = "Dynamic Market / Resources / Plant pot / Linked Drugs / 1",
                    description = "Runtime setting for Dynamic Market / Resources / Plant pot / Linked Drugs / 1.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedBasePrice = {
                    label = "Dynamic Market / Resources / Weed seed / Base Price",
                    description = "Runtime setting for Dynamic Market / Resources / Weed seed / Base Price.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedElasticity = {
                    label = "Dynamic Market / Resources / Weed seed / Elasticity",
                    description = "Runtime setting for Dynamic Market / Resources / Weed seed / Elasticity.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLabel = {
                    label = "Dynamic Market / Resources / Weed seed / Label",
                    description = "Runtime setting for Dynamic Market / Resources / Weed seed / Label.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLinkedDrugsItem1 = {
                    label = "Dynamic Market / Resources / Weed seed / Linked Drugs / 1",
                    description = "Runtime setting for Dynamic Market / Resources / Weed seed / Linked Drugs / 1.",
                },
                drugAdvancedDynamicMarketSalesWindowMinutes = {
                    label = "Dynamic Market / Sales Window Minutes",
                    description = "Runtime setting for Dynamic Market / Sales Window Minutes.",
                },
                drugAdvancedDynamicMarketSaturationDemandWeight = {
                    label = "Dynamic Market / Saturation Demand Weight",
                    description = "Runtime setting for Dynamic Market / Saturation Demand Weight.",
                },
                drugAdvancedDynamicMarketSaturationPriceImpact = {
                    label = "Dynamic Market / Saturation Price Impact",
                    description = "Runtime setting for Dynamic Market / Saturation Price Impact.",
                },
                drugAdvancedDynamicMarketScarcityDemandWeight = {
                    label = "Dynamic Market / Scarcity Demand Weight",
                    description = "Runtime setting for Dynamic Market / Scarcity Demand Weight.",
                },
                drugAdvancedDynamicMarketScarcityPriceImpact = {
                    label = "Dynamic Market / Scarcity Price Impact",
                    description = "Runtime setting for Dynamic Market / Scarcity Price Impact.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsDecember = {
                    label = "Dynamic Market / Season End Months / December",
                    description = "Runtime setting for Dynamic Market / Season End Months / December.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSpring = {
                    label = "Dynamic Market / Season End Months / Spring",
                    description = "Runtime setting for Dynamic Market / Season End Months / Spring.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSummer = {
                    label = "Dynamic Market / Season End Months / Summer",
                    description = "Runtime setting for Dynamic Market / Season End Months / Summer.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsWinter = {
                    label = "Dynamic Market / Season End Months / Winter",
                    description = "Runtime setting for Dynamic Market / Season End Months / Winter.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersAutumn = {
                    label = "Dynamic Market / Season Multipliers / Autumn",
                    description = "Runtime setting for Dynamic Market / Season Multipliers / Autumn.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSpring = {
                    label = "Dynamic Market / Season Multipliers / Spring",
                    description = "Runtime setting for Dynamic Market / Season Multipliers / Spring.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSummer = {
                    label = "Dynamic Market / Season Multipliers / Summer",
                    description = "Runtime setting for Dynamic Market / Season Multipliers / Summer.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersWinter = {
                    label = "Dynamic Market / Season Multipliers / Winter",
                    description = "Runtime setting for Dynamic Market / Season Multipliers / Winter.",
                },
                drugAdvancedDynamicMarketShortageRumorThreshold = {
                    label = "Dynamic Market / Shortage Rumor Threshold",
                    description = "Runtime setting for Dynamic Market / Shortage Rumor Threshold.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHighDemand = {
                    label = "Dynamic Market / Status Thresholds / High Demand",
                    description = "Runtime setting for Dynamic Market / Status Thresholds / High Demand.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHot = {
                    label = "Dynamic Market / Status Thresholds / Hot",
                    description = "Runtime setting for Dynamic Market / Status Thresholds / Hot.",
                },
                drugAdvancedDynamicMarketStatusThresholdsLowDemand = {
                    label = "Dynamic Market / Status Thresholds / Low Demand",
                    description = "Runtime setting for Dynamic Market / Status Thresholds / Low Demand.",
                },
                drugAdvancedDynamicMarketStatusThresholdsSaturated = {
                    label = "Dynamic Market / Status Thresholds / Saturated",
                    description = "Runtime setting for Dynamic Market / Status Thresholds / Saturated.",
                },
                drugAdvancedDynamicMarketTargetSupply = {
                    label = "Dynamic Market / Target Supply",
                    description = "Runtime setting for Dynamic Market / Target Supply.",
                },
                drugAdvancedDynamicMarketTrendChance = {
                    label = "Dynamic Market / Trend Chance",
                    description = "Runtime setting for Dynamic Market / Trend Chance.",
                },
                drugAdvancedDynamicMarketTrendDurationMinutes = {
                    label = "Dynamic Market / Trend Duration Minutes",
                    description = "Runtime setting for Dynamic Market / Trend Duration Minutes.",
                },
                drugAdvancedDynamicMarketTrendMaximumStrength = {
                    label = "Dynamic Market / Trend Maximum Strength",
                    description = "Runtime setting for Dynamic Market / Trend Maximum Strength.",
                },
                drugAdvancedDynamicMarketTrendMinimumStrength = {
                    label = "Dynamic Market / Trend Minimum Strength",
                    description = "Runtime setting for Dynamic Market / Trend Minimum Strength.",
                },
                drugAdvancedDynamicMarketUpdateMinutes = {
                    label = "Dynamic Market / Update Minutes",
                    description = "Runtime setting for Dynamic Market / Update Minutes.",
                },
                drugAdvancedDynamicMarketVolatilityMaximum = {
                    label = "Dynamic Market / Volatility Maximum",
                    description = "Runtime setting for Dynamic Market / Volatility Maximum.",
                },
                drugAdvancedDynamicMarketVolatilityMinimum = {
                    label = "Dynamic Market / Volatility Minimum",
                    description = "Runtime setting for Dynamic Market / Volatility Minimum.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersCold = {
                    label = "Dynamic Market / Weather Multipliers / Cold",
                    description = "Runtime setting for Dynamic Market / Weather Multipliers / Cold.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersHeatwave = {
                    label = "Dynamic Market / Weather Multipliers / Heatwave",
                    description = "Runtime setting for Dynamic Market / Weather Multipliers / Heatwave.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersNormal = {
                    label = "Dynamic Market / Weather Multipliers / Normal",
                    description = "Runtime setting for Dynamic Market / Weather Multipliers / Normal.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersRain = {
                    label = "Dynamic Market / Weather Multipliers / Rain",
                    description = "Runtime setting for Dynamic Market / Weather Multipliers / Rain.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersStorm = {
                    label = "Dynamic Market / Weather Multipliers / Storm",
                    description = "Runtime setting for Dynamic Market / Weather Multipliers / Storm.",
                },
                drugAdvancedDynamicMarketWeatherState = {
                    label = "Dynamic Market / Weather State",
                    description = "Runtime setting for Dynamic Market / Weather State.",
                },
                drugAdvancedHeatActionCooldownSeconds = {
                    label = "Heat & Risk / Action Cooldown Seconds",
                    description = "Runtime setting for Heat & Risk / Action Cooldown Seconds.",
                },
                drugAdvancedHeatActivityRiskWeightsAmount = {
                    label = "Heat & Risk / Activity Risk Weights / Amount",
                    description = "Runtime setting for Heat & Risk / Activity Risk Weights / Amount.",
                },
                drugAdvancedHeatActivityRiskWeightsDurationMinutes = {
                    label = "Heat & Risk / Activity Risk Weights / Duration Minutes",
                    description = "Runtime setting for Heat & Risk / Activity Risk Weights / Duration Minutes.",
                },
                drugAdvancedHeatActivityRiskWeightsPolicePressure = {
                    label = "Heat & Risk / Activity Risk Weights / Police Pressure",
                    description = "Runtime setting for Heat & Risk / Activity Risk Weights / Police Pressure.",
                },
                drugAdvancedHeatActivityRiskWeightsReputation = {
                    label = "Heat & Risk / Activity Risk Weights / Reputation",
                    description = "Runtime setting for Heat & Risk / Activity Risk Weights / Reputation.",
                },
                drugAdvancedHeatActivityRiskWeightsSecurity = {
                    label = "Heat & Risk / Activity Risk Weights / Security",
                    description = "Runtime setting for Heat & Risk / Activity Risk Weights / Security.",
                },
                drugAdvancedHeatAggressiveHeatMultiplier = {
                    label = "Heat & Risk / Aggressive Heat Multiplier",
                    description = "Runtime setting for Heat & Risk / Aggressive Heat Multiplier.",
                },
                drugAdvancedHeatBurnerBurnThreshold = {
                    label = "Heat & Risk / Burner Burn Threshold",
                    description = "Runtime setting for Heat & Risk / Burner Burn Threshold.",
                },
                drugAdvancedHeatBurnerHeatPerWholesale = {
                    label = "Heat & Risk / Burner Heat Per Wholesale",
                    description = "Runtime setting for Heat & Risk / Burner Heat Per Wholesale.",
                },
                drugAdvancedHeatBurnerPhoneItem = {
                    label = "Heat & Risk / Burner Phone Item",
                    description = "Runtime setting for Heat & Risk / Burner Phone Item.",
                },
                drugAdvancedHeatCamperOperationalHeatMultiplier = {
                    label = "Heat & Risk / Camper Operational Heat Multiplier",
                    description = "Runtime setting for Heat & Risk / Camper Operational Heat Multiplier.",
                },
                drugAdvancedHeatCamperOperationalHeatThreshold = {
                    label = "Heat & Risk / Camper Operational Heat Threshold",
                    description = "Runtime setting for Heat & Risk / Camper Operational Heat Threshold.",
                },
                drugAdvancedHeatCamperParkedHeat = {
                    label = "Heat & Risk / Camper Parked Heat",
                    description = "Runtime setting for Heat & Risk / Camper Parked Heat.",
                },
                drugAdvancedHeatContaminatedHeatMultiplier = {
                    label = "Heat & Risk / Contaminated Heat Multiplier",
                    description = "Runtime setting for Heat & Risk / Contaminated Heat Multiplier.",
                },
                drugAdvancedHeatContaminatedThreshold = {
                    label = "Heat & Risk / Contaminated Threshold",
                    description = "Runtime setting for Heat & Risk / Contaminated Threshold.",
                },
                drugAdvancedHeatCultivationFreePlants = {
                    label = "Heat & Risk / Cultivation Free Plants",
                    description = "Runtime setting for Heat & Risk / Cultivation Free Plants.",
                },
                drugAdvancedHeatCultivationHeatPerPlant = {
                    label = "Heat & Risk / Cultivation Heat Per Plant",
                    description = "Runtime setting for Heat & Risk / Cultivation Heat Per Plant.",
                },
                drugAdvancedHeatDealerHiddenMinutes = {
                    label = "Heat & Risk / Dealer Hidden Minutes",
                    description = "Runtime setting for Heat & Risk / Dealer Hidden Minutes.",
                },
                drugAdvancedHeatDecayPerTickBatch = {
                    label = "Heat & Risk / Decay Per Tick / Batch",
                    description = "Runtime setting for Heat & Risk / Decay Per Tick / Batch.",
                },
                drugAdvancedHeatDecayPerTickCamper = {
                    label = "Heat & Risk / Decay Per Tick / Camper",
                    description = "Runtime setting for Heat & Risk / Decay Per Tick / Camper.",
                },
                drugAdvancedHeatDecayPerTickDealer = {
                    label = "Heat & Risk / Decay Per Tick / Dealer",
                    description = "Runtime setting for Heat & Risk / Decay Per Tick / Dealer.",
                },
                drugAdvancedHeatDecayPerTickFaction = {
                    label = "Heat & Risk / Decay Per Tick / Faction",
                    description = "Runtime setting for Heat & Risk / Decay Per Tick / Faction.",
                },
                drugAdvancedHeatDecayPerTickHub = {
                    label = "Heat & Risk / Decay Per Tick / Hub",
                    description = "Runtime setting for Heat & Risk / Decay Per Tick / Hub.",
                },
                drugAdvancedHeatDecayPerTickLab = {
                    label = "Heat & Risk / Decay Per Tick / Lab",
                    description = "Runtime setting for Heat & Risk / Decay Per Tick / Lab.",
                },
                drugAdvancedHeatDecayPerTickPlayer = {
                    label = "Heat & Risk / Decay Per Tick / Player",
                    description = "Runtime setting for Heat & Risk / Decay Per Tick / Player.",
                },
                drugAdvancedHeatDecayPerTickRoute = {
                    label = "Heat & Risk / Decay Per Tick / Route",
                    description = "Runtime setting for Heat & Risk / Decay Per Tick / Route.",
                },
                drugAdvancedHeatDecayPerTickZone = {
                    label = "Heat & Risk / Decay Per Tick / Zone",
                    description = "Runtime setting for Heat & Risk / Decay Per Tick / Zone.",
                },
                drugAdvancedHeatEnabled = {
                    label = "Heat & Risk / Enabled",
                    description = "Runtime setting for Heat & Risk / Enabled.",
                },
                drugAdvancedHeatEnforcementHeatCritical = {
                    label = "Heat & Risk / Enforcement Heat / Critical",
                    description = "Runtime setting for Heat & Risk / Enforcement Heat / Critical.",
                },
                drugAdvancedHeatEnforcementHeatHigh = {
                    label = "Heat & Risk / Enforcement Heat / High",
                    description = "Runtime setting for Heat & Risk / Enforcement Heat / High.",
                },
                drugAdvancedHeatEnforcementHeatLow = {
                    label = "Heat & Risk / Enforcement Heat / Low",
                    description = "Runtime setting for Heat & Risk / Enforcement Heat / Low.",
                },
                drugAdvancedHeatEnforcementHeatMedium = {
                    label = "Heat & Risk / Enforcement Heat / Medium",
                    description = "Runtime setting for Heat & Risk / Enforcement Heat / Medium.",
                },
                drugAdvancedHeatEnforcementMultipliersBatch = {
                    label = "Heat & Risk / Enforcement Multipliers / Batch",
                    description = "Runtime setting for Heat & Risk / Enforcement Multipliers / Batch.",
                },
                drugAdvancedHeatEnforcementMultipliersFaction = {
                    label = "Heat & Risk / Enforcement Multipliers / Faction",
                    description = "Runtime setting for Heat & Risk / Enforcement Multipliers / Faction.",
                },
                drugAdvancedHeatEnforcementMultipliersZone = {
                    label = "Heat & Risk / Enforcement Multipliers / Zone",
                    description = "Runtime setting for Heat & Risk / Enforcement Multipliers / Zone.",
                },
                drugAdvancedHeatEntityTypesBatch = {
                    label = "Heat & Risk / Entity Types / Batch",
                    description = "Runtime setting for Heat & Risk / Entity Types / Batch.",
                },
                drugAdvancedHeatEntityTypesCamper = {
                    label = "Heat & Risk / Entity Types / Camper",
                    description = "Runtime setting for Heat & Risk / Entity Types / Camper.",
                },
                drugAdvancedHeatEntityTypesDealer = {
                    label = "Heat & Risk / Entity Types / Dealer",
                    description = "Runtime setting for Heat & Risk / Entity Types / Dealer.",
                },
                drugAdvancedHeatEntityTypesFaction = {
                    label = "Heat & Risk / Entity Types / Faction",
                    description = "Runtime setting for Heat & Risk / Entity Types / Faction.",
                },
                drugAdvancedHeatEntityTypesHub = {
                    label = "Heat & Risk / Entity Types / Hub",
                    description = "Runtime setting for Heat & Risk / Entity Types / Hub.",
                },
                drugAdvancedHeatEntityTypesLab = {
                    label = "Heat & Risk / Entity Types / Lab",
                    description = "Runtime setting for Heat & Risk / Entity Types / Lab.",
                },
                drugAdvancedHeatEntityTypesPlayer = {
                    label = "Heat & Risk / Entity Types / Player",
                    description = "Runtime setting for Heat & Risk / Entity Types / Player.",
                },
                drugAdvancedHeatEntityTypesRoute = {
                    label = "Heat & Risk / Entity Types / Route",
                    description = "Runtime setting for Heat & Risk / Entity Types / Route.",
                },
                drugAdvancedHeatEntityTypesZone = {
                    label = "Heat & Risk / Entity Types / Zone",
                    description = "Runtime setting for Heat & Risk / Entity Types / Zone.",
                },
                drugAdvancedHeatEventCooldownMinutes = {
                    label = "Heat & Risk / Event Cooldown Minutes",
                    description = "Runtime setting for Heat & Risk / Event Cooldown Minutes.",
                },
                drugAdvancedHeatEventHistoryLimit = {
                    label = "Heat & Risk / Event History Limit",
                    description = "Runtime setting for Heat & Risk / Event History Limit.",
                },
                drugAdvancedHeatLabHeatSyncThreshold = {
                    label = "Heat & Risk / Lab Heat Sync Threshold",
                    description = "Runtime setting for Heat & Risk / Lab Heat Sync Threshold.",
                },
                drugAdvancedHeatLayLowCooldownMinutes = {
                    label = "Heat & Risk / Lay Low Cooldown Minutes",
                    description = "Runtime setting for Heat & Risk / Lay Low Cooldown Minutes.",
                },
                drugAdvancedHeatLayLowIdleMinutes = {
                    label = "Heat & Risk / Lay Low Idle Minutes",
                    description = "Runtime setting for Heat & Risk / Lay Low Idle Minutes.",
                },
                drugAdvancedHeatLayLowReduction = {
                    label = "Heat & Risk / Lay Low Reduction",
                    description = "Runtime setting for Heat & Risk / Lay Low Reduction.",
                },
                drugAdvancedHeatLockdownMinutes = {
                    label = "Heat & Risk / Lockdown Minutes",
                    description = "Runtime setting for Heat & Risk / Lockdown Minutes.",
                },
                drugAdvancedHeatMinimumDurationMinutes = {
                    label = "Heat & Risk / Minimum Duration Minutes",
                    description = "Runtime setting for Heat & Risk / Minimum Duration Minutes.",
                },
                drugAdvancedHeatMinimumEventCooldownSeconds = {
                    label = "Heat & Risk / Minimum Event Cooldown Seconds",
                    description = "Runtime setting for Heat & Risk / Minimum Event Cooldown Seconds.",
                },
                drugAdvancedHeatMinimumIdleSeconds = {
                    label = "Heat & Risk / Minimum Idle Seconds",
                    description = "Runtime setting for Heat & Risk / Minimum Idle Seconds.",
                },
                drugAdvancedHeatProcessingHeatMultiplier = {
                    label = "Heat & Risk / Processing Heat Multiplier",
                    description = "Runtime setting for Heat & Risk / Processing Heat Multiplier.",
                },
                drugAdvancedHeatRiskWeightsBatch = {
                    label = "Heat & Risk / Risk Weights / Batch",
                    description = "Runtime setting for Heat & Risk / Risk Weights / Batch.",
                },
                drugAdvancedHeatRiskWeightsCamper = {
                    label = "Heat & Risk / Risk Weights / Camper",
                    description = "Runtime setting for Heat & Risk / Risk Weights / Camper.",
                },
                drugAdvancedHeatRiskWeightsDealer = {
                    label = "Heat & Risk / Risk Weights / Dealer",
                    description = "Runtime setting for Heat & Risk / Risk Weights / Dealer.",
                },
                drugAdvancedHeatRiskWeightsFaction = {
                    label = "Heat & Risk / Risk Weights / Faction",
                    description = "Runtime setting for Heat & Risk / Risk Weights / Faction.",
                },
                drugAdvancedHeatRiskWeightsHub = {
                    label = "Heat & Risk / Risk Weights / Hub",
                    description = "Runtime setting for Heat & Risk / Risk Weights / Hub.",
                },
                drugAdvancedHeatRiskWeightsLab = {
                    label = "Heat & Risk / Risk Weights / Lab",
                    description = "Runtime setting for Heat & Risk / Risk Weights / Lab.",
                },
                drugAdvancedHeatRiskWeightsPlayer = {
                    label = "Heat & Risk / Risk Weights / Player",
                    description = "Runtime setting for Heat & Risk / Risk Weights / Player.",
                },
                drugAdvancedHeatRiskWeightsRoute = {
                    label = "Heat & Risk / Risk Weights / Route",
                    description = "Runtime setting for Heat & Risk / Risk Weights / Route.",
                },
                drugAdvancedHeatRiskWeightsZone = {
                    label = "Heat & Risk / Risk Weights / Zone",
                    description = "Runtime setting for Heat & Risk / Risk Weights / Zone.",
                },
                drugAdvancedHeatRotateBurnerReduction = {
                    label = "Heat & Risk / Rotate Burner Reduction",
                    description = "Runtime setting for Heat & Risk / Rotate Burner Reduction.",
                },
                drugAdvancedHeatRouteControlMinutes = {
                    label = "Heat & Risk / Route Control Minutes",
                    description = "Runtime setting for Heat & Risk / Route Control Minutes.",
                },
                drugAdvancedHeatSaleHeatBatch = {
                    label = "Heat & Risk / Sale Heat / Batch",
                    description = "Runtime setting for Heat & Risk / Sale Heat / Batch.",
                },
                drugAdvancedHeatSaleHeatCamper = {
                    label = "Heat & Risk / Sale Heat / Camper",
                    description = "Runtime setting for Heat & Risk / Sale Heat / Camper.",
                },
                drugAdvancedHeatSaleHeatDealer = {
                    label = "Heat & Risk / Sale Heat / Dealer",
                    description = "Runtime setting for Heat & Risk / Sale Heat / Dealer.",
                },
                drugAdvancedHeatSaleHeatFaction = {
                    label = "Heat & Risk / Sale Heat / Faction",
                    description = "Runtime setting for Heat & Risk / Sale Heat / Faction.",
                },
                drugAdvancedHeatSaleHeatHub = {
                    label = "Heat & Risk / Sale Heat / Hub",
                    description = "Runtime setting for Heat & Risk / Sale Heat / Hub.",
                },
                drugAdvancedHeatSaleHeatLab = {
                    label = "Heat & Risk / Sale Heat / Lab",
                    description = "Runtime setting for Heat & Risk / Sale Heat / Lab.",
                },
                drugAdvancedHeatSaleHeatPlayer = {
                    label = "Heat & Risk / Sale Heat / Player",
                    description = "Runtime setting for Heat & Risk / Sale Heat / Player.",
                },
                drugAdvancedHeatSaleHeatRoute = {
                    label = "Heat & Risk / Sale Heat / Route",
                    description = "Runtime setting for Heat & Risk / Sale Heat / Route.",
                },
                drugAdvancedHeatSaleHeatZone = {
                    label = "Heat & Risk / Sale Heat / Zone",
                    description = "Runtime setting for Heat & Risk / Sale Heat / Zone.",
                },
                drugAdvancedHeatThresholdsCritical = {
                    label = "Heat & Risk / Thresholds / Critical",
                    description = "Runtime setting for Heat & Risk / Thresholds / Critical.",
                },
                drugAdvancedHeatThresholdsHigh = {
                    label = "Heat & Risk / Thresholds / High",
                    description = "Runtime setting for Heat & Risk / Thresholds / High.",
                },
                drugAdvancedHeatThresholdsLockdown = {
                    label = "Heat & Risk / Thresholds / Lockdown",
                    description = "Runtime setting for Heat & Risk / Thresholds / Lockdown.",
                },
                drugAdvancedHeatThresholdsLow = {
                    label = "Heat & Risk / Thresholds / Low",
                    description = "Runtime setting for Heat & Risk / Thresholds / Low.",
                },
                drugAdvancedHeatThresholdsMedium = {
                    label = "Heat & Risk / Thresholds / Medium",
                    description = "Runtime setting for Heat & Risk / Thresholds / Medium.",
                },
                drugAdvancedHeatTickMinutes = {
                    label = "Heat & Risk / Tick Minutes",
                    description = "Runtime setting for Heat & Risk / Tick Minutes.",
                },
                drugAdvancedHeatWholesaleHeatMultiplier = {
                    label = "Heat & Risk / Wholesale Heat Multiplier",
                    description = "Runtime setting for Heat & Risk / Wholesale Heat Multiplier.",
                },
                drugAdvancedHeatWorkerLeakAlertRadius = {
                    label = "Heat & Risk / Worker Leak Alert Radius",
                    description = "Runtime setting for Heat & Risk / Worker Leak Alert Radius.",
                },
                drugAdvancedHeatWorkerLeakBaseChance = {
                    label = "Heat & Risk / Worker Leak Base Chance",
                    description = "Runtime setting for Heat & Risk / Worker Leak Base Chance.",
                },
                drugAdvancedHeatWorkerLeakFactionMultiplier = {
                    label = "Heat & Risk / Worker Leak Faction Multiplier",
                    description = "Runtime setting for Heat & Risk / Worker Leak Faction Multiplier.",
                },
                drugAdvancedHeatWorkerLeakHighSeverityThreshold = {
                    label = "Heat & Risk / Worker Leak High Severity Threshold",
                    description = "Runtime setting for Heat & Risk / Worker Leak High Severity Threshold.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Heat & Risk / Worker Leak Loyalty Chance Multiplier",
                    description = "Runtime setting for Heat & Risk / Worker Leak Loyalty Chance Multiplier.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyThreshold = {
                    label = "Heat & Risk / Worker Leak Loyalty Threshold",
                    description = "Runtime setting for Heat & Risk / Worker Leak Loyalty Threshold.",
                },
                drugAdvancedHeatWorkerLeakMaximumChance = {
                    label = "Heat & Risk / Worker Leak Maximum Chance",
                    description = "Runtime setting for Heat & Risk / Worker Leak Maximum Chance.",
                },
                drugAdvancedHeatWorkerLeakMinimumCooldownSeconds = {
                    label = "Heat & Risk / Worker Leak Minimum Cooldown Seconds",
                    description = "Runtime setting for Heat & Risk / Worker Leak Minimum Cooldown Seconds.",
                },
                drugAdvancedHeatWorkerLeakRouteMultiplier = {
                    label = "Heat & Risk / Worker Leak Route Multiplier",
                    description = "Runtime setting for Heat & Risk / Worker Leak Route Multiplier.",
                },
                drugAdvancedHeatWorkerLeakStrengthMaximum = {
                    label = "Heat & Risk / Worker Leak Strength Maximum",
                    description = "Runtime setting for Heat & Risk / Worker Leak Strength Maximum.",
                },
                drugAdvancedHeatWorkerLeakStrengthMinimum = {
                    label = "Heat & Risk / Worker Leak Strength Minimum",
                    description = "Runtime setting for Heat & Risk / Worker Leak Strength Minimum.",
                },
                drugAdvancedHeatWorkerLeakStrengthMultiplier = {
                    label = "Heat & Risk / Worker Leak Strength Multiplier",
                    description = "Runtime setting for Heat & Risk / Worker Leak Strength Multiplier.",
                },
                drugAdvancedHeatWorkerLeakStressChanceMultiplier = {
                    label = "Heat & Risk / Worker Leak Stress Chance Multiplier",
                    description = "Runtime setting for Heat & Risk / Worker Leak Stress Chance Multiplier.",
                },
                drugAdvancedHeatWorkerLeakStressThreshold = {
                    label = "Heat & Risk / Worker Leak Stress Threshold",
                    description = "Runtime setting for Heat & Risk / Worker Leak Stress Threshold.",
                },
                drugAdvancedContactNetworkActionCooldownSeconds = {
                    label = "Contact Network / Action Cooldown Seconds",
                    description = "Runtime setting for Contact Network / Action Cooldown Seconds.",
                },
                drugAdvancedContactNetworkActiveHotspotCount = {
                    label = "Contact Network / Active Hotspot Count",
                    description = "Runtime setting for Contact Network / Active Hotspot Count.",
                },
                drugAdvancedContactNetworkBurnerHintTrust = {
                    label = "Contact Network / Burner Hint Trust",
                    description = "Runtime setting for Contact Network / Burner Hint Trust.",
                },
                drugAdvancedContactNetworkBurnerOfferMaximumMultiplier = {
                    label = "Contact Network / Burner Offer Maximum Multiplier",
                    description = "Runtime setting for Contact Network / Burner Offer Maximum Multiplier.",
                },
                drugAdvancedContactNetworkBurnerOfferMinimumMultiplier = {
                    label = "Contact Network / Burner Offer Minimum Multiplier",
                    description = "Runtime setting for Contact Network / Burner Offer Minimum Multiplier.",
                },
                drugAdvancedContactNetworkBuyerCooldownMinutes = {
                    label = "Contact Network / Buyer Cooldown Minutes",
                    description = "Runtime setting for Contact Network / Buyer Cooldown Minutes.",
                },
                drugAdvancedContactNetworkBuyerDeliveryDistance = {
                    label = "Contact Network / Buyer Delivery Distance",
                    description = "Runtime setting for Contact Network / Buyer Delivery Distance.",
                },
                drugAdvancedContactNetworkBuyerPremiumSuccessScore = {
                    label = "Contact Network / Buyer Premium Success Score",
                    description = "Runtime setting for Contact Network / Buyer Premium Success Score.",
                },
                drugAdvancedContactNetworkBuyerPremiumTrustGain = {
                    label = "Contact Network / Buyer Premium Trust Gain",
                    description = "Runtime setting for Contact Network / Buyer Premium Trust Gain.",
                },
                drugAdvancedContactNetworkBuyerRequestHeatRiskWeight = {
                    label = "Contact Network / Buyer Request Heat Risk Weight",
                    description = "Runtime setting for Contact Network / Buyer Request Heat Risk Weight.",
                },
                drugAdvancedContactNetworkBuyerStandardTrustGain = {
                    label = "Contact Network / Buyer Standard Trust Gain",
                    description = "Runtime setting for Contact Network / Buyer Standard Trust Gain.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMax = {
                    label = "Contact Network / Contact Active Delay Seconds / Max",
                    description = "Runtime setting for Contact Network / Contact Active Delay Seconds / Max.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMin = {
                    label = "Contact Network / Contact Active Delay Seconds / Min",
                    description = "Runtime setting for Contact Network / Contact Active Delay Seconds / Min.",
                },
                drugAdvancedContactNetworkContactDemandRangeMax = {
                    label = "Contact Network / Contact Demand Range / Max",
                    description = "Runtime setting for Contact Network / Contact Demand Range / Max.",
                },
                drugAdvancedContactNetworkContactDemandRangeMin = {
                    label = "Contact Network / Contact Demand Range / Min",
                    description = "Runtime setting for Contact Network / Contact Demand Range / Min.",
                },
                drugAdvancedContactNetworkContactLossTrust = {
                    label = "Contact Network / Contact Loss Trust",
                    description = "Runtime setting for Contact Network / Contact Loss Trust.",
                },
                drugAdvancedContactNetworkDarknetExactIntelMinutes = {
                    label = "Contact Network / Darknet Exact Intel Minutes",
                    description = "Runtime setting for Contact Network / Darknet Exact Intel Minutes.",
                },
                drugAdvancedContactNetworkDarknetHotspotIntelPrice = {
                    label = "Contact Network / Darknet Hotspot Intel Price",
                    description = "Runtime setting for Contact Network / Darknet Hotspot Intel Price.",
                },
                drugAdvancedContactNetworkDarknetIntelPrice = {
                    label = "Contact Network / Darknet Intel Price",
                    description = "Runtime setting for Contact Network / Darknet Intel Price.",
                },
                drugAdvancedContactNetworkDealerBasePrice = {
                    label = "Contact Network / Dealer Base Price",
                    description = "Runtime setting for Contact Network / Dealer Base Price.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMax = {
                    label = "Contact Network / Dealer Hire Capacity / Max",
                    description = "Runtime setting for Contact Network / Dealer Hire Capacity / Max.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMin = {
                    label = "Contact Network / Dealer Hire Capacity / Min",
                    description = "Runtime setting for Contact Network / Dealer Hire Capacity / Min.",
                },
                drugAdvancedContactNetworkDealerHireRiskMax = {
                    label = "Contact Network / Dealer Hire Risk / Max",
                    description = "Runtime setting for Contact Network / Dealer Hire Risk / Max.",
                },
                drugAdvancedContactNetworkDealerHireRiskMin = {
                    label = "Contact Network / Dealer Hire Risk / Min",
                    description = "Runtime setting for Contact Network / Dealer Hire Risk / Min.",
                },
                drugAdvancedContactNetworkDealerHireSkillMax = {
                    label = "Contact Network / Dealer Hire Skill / Max",
                    description = "Runtime setting for Contact Network / Dealer Hire Skill / Max.",
                },
                drugAdvancedContactNetworkDealerHireSkillMin = {
                    label = "Contact Network / Dealer Hire Skill / Min",
                    description = "Runtime setting for Contact Network / Dealer Hire Skill / Min.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Id = {
                    label = "Contact Network / Dealer Offers / 1 / Id",
                    description = "Runtime setting for Contact Network / Dealer Offers / 1 / Id.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Item = {
                    label = "Contact Network / Dealer Offers / 1 / Item",
                    description = "Runtime setting for Contact Network / Dealer Offers / 1 / Item.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Label = {
                    label = "Contact Network / Dealer Offers / 1 / Label",
                    description = "Runtime setting for Contact Network / Dealer Offers / 1 / Label.",
                },
                drugAdvancedContactNetworkDealerOffersItem1MinTrust = {
                    label = "Contact Network / Dealer Offers / 1 / Min Trust",
                    description = "Runtime setting for Contact Network / Dealer Offers / 1 / Min Trust.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Price = {
                    label = "Contact Network / Dealer Offers / 1 / Price",
                    description = "Runtime setting for Contact Network / Dealer Offers / 1 / Price.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Id = {
                    label = "Contact Network / Dealer Offers / 2 / Id",
                    description = "Runtime setting for Contact Network / Dealer Offers / 2 / Id.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Item = {
                    label = "Contact Network / Dealer Offers / 2 / Item",
                    description = "Runtime setting for Contact Network / Dealer Offers / 2 / Item.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Label = {
                    label = "Contact Network / Dealer Offers / 2 / Label",
                    description = "Runtime setting for Contact Network / Dealer Offers / 2 / Label.",
                },
                drugAdvancedContactNetworkDealerOffersItem2MinTrust = {
                    label = "Contact Network / Dealer Offers / 2 / Min Trust",
                    description = "Runtime setting for Contact Network / Dealer Offers / 2 / Min Trust.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Price = {
                    label = "Contact Network / Dealer Offers / 2 / Price",
                    description = "Runtime setting for Contact Network / Dealer Offers / 2 / Price.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Id = {
                    label = "Contact Network / Dealer Offers / 3 / Id",
                    description = "Runtime setting for Contact Network / Dealer Offers / 3 / Id.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Item = {
                    label = "Contact Network / Dealer Offers / 3 / Item",
                    description = "Runtime setting for Contact Network / Dealer Offers / 3 / Item.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Label = {
                    label = "Contact Network / Dealer Offers / 3 / Label",
                    description = "Runtime setting for Contact Network / Dealer Offers / 3 / Label.",
                },
                drugAdvancedContactNetworkDealerOffersItem3MinTrust = {
                    label = "Contact Network / Dealer Offers / 3 / Min Trust",
                    description = "Runtime setting for Contact Network / Dealer Offers / 3 / Min Trust.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Price = {
                    label = "Contact Network / Dealer Offers / 3 / Price",
                    description = "Runtime setting for Contact Network / Dealer Offers / 3 / Price.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Id = {
                    label = "Contact Network / Dealer Offers / 4 / Id",
                    description = "Runtime setting for Contact Network / Dealer Offers / 4 / Id.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Item = {
                    label = "Contact Network / Dealer Offers / 4 / Item",
                    description = "Runtime setting for Contact Network / Dealer Offers / 4 / Item.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Label = {
                    label = "Contact Network / Dealer Offers / 4 / Label",
                    description = "Runtime setting for Contact Network / Dealer Offers / 4 / Label.",
                },
                drugAdvancedContactNetworkDealerOffersItem4MinTrust = {
                    label = "Contact Network / Dealer Offers / 4 / Min Trust",
                    description = "Runtime setting for Contact Network / Dealer Offers / 4 / Min Trust.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Price = {
                    label = "Contact Network / Dealer Offers / 4 / Price",
                    description = "Runtime setting for Contact Network / Dealer Offers / 4 / Price.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Id = {
                    label = "Contact Network / Dealer Offers / 5 / Id",
                    description = "Runtime setting for Contact Network / Dealer Offers / 5 / Id.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Item = {
                    label = "Contact Network / Dealer Offers / 5 / Item",
                    description = "Runtime setting for Contact Network / Dealer Offers / 5 / Item.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Label = {
                    label = "Contact Network / Dealer Offers / 5 / Label",
                    description = "Runtime setting for Contact Network / Dealer Offers / 5 / Label.",
                },
                drugAdvancedContactNetworkDealerOffersItem5MinTrust = {
                    label = "Contact Network / Dealer Offers / 5 / Min Trust",
                    description = "Runtime setting for Contact Network / Dealer Offers / 5 / Min Trust.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Price = {
                    label = "Contact Network / Dealer Offers / 5 / Price",
                    description = "Runtime setting for Contact Network / Dealer Offers / 5 / Price.",
                },
                drugAdvancedContactNetworkDealerProtectionHours = {
                    label = "Contact Network / Dealer Protection Hours",
                    description = "Runtime setting for Contact Network / Dealer Protection Hours.",
                },
                drugAdvancedContactNetworkDealerProtectionPrice = {
                    label = "Contact Network / Dealer Protection Price",
                    description = "Runtime setting for Contact Network / Dealer Protection Price.",
                },
                drugAdvancedContactNetworkDealerSaleMax = {
                    label = "Contact Network / Dealer Sale Max",
                    description = "Runtime setting for Contact Network / Dealer Sale Max.",
                },
                drugAdvancedContactNetworkDealerSaleMin = {
                    label = "Contact Network / Dealer Sale Min",
                    description = "Runtime setting for Contact Network / Dealer Sale Min.",
                },
                drugAdvancedContactNetworkDealerSimulationAggressivePriceMultiplier = {
                    label = "Contact Network / Dealer Simulation / Aggressive Price Multiplier",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Aggressive Price Multiplier.",
                },
                drugAdvancedContactNetworkDealerSimulationBaseQualityPriceFactor = {
                    label = "Contact Network / Dealer Simulation / Base Quality Price Factor",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Base Quality Price Factor.",
                },
                drugAdvancedContactNetworkDealerSimulationBulkPriceMultiplier = {
                    label = "Contact Network / Dealer Simulation / Bulk Price Multiplier",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Bulk Price Multiplier.",
                },
                drugAdvancedContactNetworkDealerSimulationCheapPriceMultiplier = {
                    label = "Contact Network / Dealer Simulation / Cheap Price Multiplier",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Cheap Price Multiplier.",
                },
                drugAdvancedContactNetworkDealerSimulationDefaultQuality = {
                    label = "Contact Network / Dealer Simulation / Default Quality",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Default Quality.",
                },
                drugAdvancedContactNetworkDealerSimulationDisloyalThreshold = {
                    label = "Contact Network / Dealer Simulation / Disloyal Threshold",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Disloyal Threshold.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerLevel = {
                    label = "Contact Network / Dealer Simulation / Experience Per Level",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Experience Per Level.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerUnit = {
                    label = "Contact Network / Dealer Simulation / Experience Per Unit",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Experience Per Unit.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentLoyaltyLoss = {
                    label = "Contact Network / Dealer Simulation / Incident Loyalty Loss",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Incident Loyalty Loss.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentRollMaximum = {
                    label = "Contact Network / Dealer Simulation / Incident Roll Maximum",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Incident Roll Maximum.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelPriceBonus = {
                    label = "Contact Network / Dealer Simulation / Level Price Bonus",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Level Price Bonus.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelSaleDivisor = {
                    label = "Contact Network / Dealer Simulation / Level Sale Divisor",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Level Sale Divisor.",
                },
                drugAdvancedContactNetworkDealerSimulationLoyaltyRiskWeight = {
                    label = "Contact Network / Dealer Simulation / Loyalty Risk Weight",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Loyalty Risk Weight.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumIncidentChance = {
                    label = "Contact Network / Dealer Simulation / Maximum Incident Chance",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Maximum Incident Chance.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumLevel = {
                    label = "Contact Network / Dealer Simulation / Maximum Level",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Maximum Level.",
                },
                drugAdvancedContactNetworkDealerSimulationPremiumPriceMultiplier = {
                    label = "Contact Network / Dealer Simulation / Premium Price Multiplier",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Premium Price Multiplier.",
                },
                drugAdvancedContactNetworkDealerSimulationProfileRiskWeight = {
                    label = "Contact Network / Dealer Simulation / Profile Risk Weight",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Profile Risk Weight.",
                },
                drugAdvancedContactNetworkDealerSimulationProtectionRiskReduction = {
                    label = "Contact Network / Dealer Simulation / Protection Risk Reduction",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Protection Risk Reduction.",
                },
                drugAdvancedContactNetworkDealerSimulationQualityPriceDivisor = {
                    label = "Contact Network / Dealer Simulation / Quality Price Divisor",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Quality Price Divisor.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryBaseChance = {
                    label = "Contact Network / Dealer Simulation / Recovery Base Chance",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Recovery Base Chance.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryLoyaltyWeight = {
                    label = "Contact Network / Dealer Simulation / Recovery Loyalty Weight",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Recovery Loyalty Weight.",
                },
                drugAdvancedContactNetworkDealerSimulationRobbedStockLoss = {
                    label = "Contact Network / Dealer Simulation / Robbed Stock Loss",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Robbed Stock Loss.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillRiskReduction = {
                    label = "Contact Network / Dealer Simulation / Skill Risk Reduction",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Skill Risk Reduction.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillSaleDivisor = {
                    label = "Contact Network / Dealer Simulation / Skill Sale Divisor",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Skill Sale Divisor.",
                },
                drugAdvancedContactNetworkDealerSimulationStableLoyaltyThreshold = {
                    label = "Contact Network / Dealer Simulation / Stable Loyalty Threshold",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Stable Loyalty Threshold.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryPriceMultiplier = {
                    label = "Contact Network / Dealer Simulation / Territory Price Multiplier",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Territory Price Multiplier.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryRiskReduction = {
                    label = "Contact Network / Dealer Simulation / Territory Risk Reduction",
                    description = "Runtime setting for Contact Network / Dealer Simulation / Territory Risk Reduction.",
                },
                drugAdvancedContactNetworkDealerTickMinutes = {
                    label = "Contact Network / Dealer Tick Minutes",
                    description = "Runtime setting for Contact Network / Dealer Tick Minutes.",
                },
                drugAdvancedContactNetworkDealerWage = {
                    label = "Contact Network / Dealer Wage",
                    description = "Runtime setting for Contact Network / Dealer Wage.",
                },
                drugAdvancedContactNetworkDealerWageDecay = {
                    label = "Contact Network / Dealer Wage Decay",
                    description = "Runtime setting for Contact Network / Dealer Wage Decay.",
                },
                drugAdvancedContactNetworkDealerWageLoyaltyGain = {
                    label = "Contact Network / Dealer Wage Loyalty Gain",
                    description = "Runtime setting for Contact Network / Dealer Wage Loyalty Gain.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem1 = {
                    label = "Contact Network / Dealer Weaknesses / 1",
                    description = "Runtime setting for Contact Network / Dealer Weaknesses / 1.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem2 = {
                    label = "Contact Network / Dealer Weaknesses / 2",
                    description = "Runtime setting for Contact Network / Dealer Weaknesses / 2.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem3 = {
                    label = "Contact Network / Dealer Weaknesses / 3",
                    description = "Runtime setting for Contact Network / Dealer Weaknesses / 3.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem4 = {
                    label = "Contact Network / Dealer Weaknesses / 4",
                    description = "Runtime setting for Contact Network / Dealer Weaknesses / 4.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem5 = {
                    label = "Contact Network / Dealer Weaknesses / 5",
                    description = "Runtime setting for Contact Network / Dealer Weaknesses / 5.",
                },
                drugAdvancedContactNetworkDefaultContactDemand = {
                    label = "Contact Network / Default Contact Demand",
                    description = "Runtime setting for Contact Network / Default Contact Demand.",
                },
                drugAdvancedContactNetworkDefaultContactRisk = {
                    label = "Contact Network / Default Contact Risk",
                    description = "Runtime setting for Contact Network / Default Contact Risk.",
                },
                drugAdvancedContactNetworkDefaultDealerCapacity = {
                    label = "Contact Network / Default Dealer Capacity",
                    description = "Runtime setting for Contact Network / Default Dealer Capacity.",
                },
                drugAdvancedContactNetworkDefaultDealerRisk = {
                    label = "Contact Network / Default Dealer Risk",
                    description = "Runtime setting for Contact Network / Default Dealer Risk.",
                },
                drugAdvancedContactNetworkDefaultDealerSkill = {
                    label = "Contact Network / Default Dealer Skill",
                    description = "Runtime setting for Contact Network / Default Dealer Skill.",
                },
                drugAdvancedContactNetworkDefaultHotspotRadius = {
                    label = "Contact Network / Default Hotspot Radius",
                    description = "Runtime setting for Contact Network / Default Hotspot Radius.",
                },
                drugAdvancedContactNetworkDemandResetMinutes = {
                    label = "Contact Network / Demand Reset Minutes",
                    description = "Runtime setting for Contact Network / Demand Reset Minutes.",
                },
                drugAdvancedContactNetworkEnabled = {
                    label = "Contact Network / Enabled",
                    description = "Runtime setting for Contact Network / Enabled.",
                },
                drugAdvancedContactNetworkExactLocationTrust = {
                    label = "Contact Network / Exact Location Trust",
                    description = "Runtime setting for Contact Network / Exact Location Trust.",
                },
                drugAdvancedContactNetworkFactionDiscoveryReputation = {
                    label = "Contact Network / Faction Discovery Reputation",
                    description = "Runtime setting for Contact Network / Faction Discovery Reputation.",
                },
                drugAdvancedContactNetworkFactionHintTrust = {
                    label = "Contact Network / Faction Hint Trust",
                    description = "Runtime setting for Contact Network / Faction Hint Trust.",
                },
                drugAdvancedContactNetworkFailedDeliveryCooldownMinutes = {
                    label = "Contact Network / Failed Delivery Cooldown Minutes",
                    description = "Runtime setting for Contact Network / Failed Delivery Cooldown Minutes.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerCount = {
                    label = "Contact Network / Fake Deal Encounter / Attacker Count",
                    description = "Runtime setting for Contact Network / Fake Deal Encounter / Attacker Count.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem1 = {
                    label = "Contact Network / Fake Deal Encounter / Attacker Models / 1",
                    description = "Runtime setting for Contact Network / Fake Deal Encounter / Attacker Models / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem2 = {
                    label = "Contact Network / Fake Deal Encounter / Attacker Models / 2",
                    description = "Runtime setting for Contact Network / Fake Deal Encounter / Attacker Models / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem3 = {
                    label = "Contact Network / Fake Deal Encounter / Attacker Models / 3",
                    description = "Runtime setting for Contact Network / Fake Deal Encounter / Attacker Models / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterDurationSeconds = {
                    label = "Contact Network / Fake Deal Encounter / Duration Seconds",
                    description = "Runtime setting for Contact Network / Fake Deal Encounter / Duration Seconds.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem1 = {
                    label = "Contact Network / Fake Deal Encounter / Police Models / 1",
                    description = "Runtime setting for Contact Network / Fake Deal Encounter / Police Models / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem2 = {
                    label = "Contact Network / Fake Deal Encounter / Police Models / 2",
                    description = "Runtime setting for Contact Network / Fake Deal Encounter / Police Models / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem3 = {
                    label = "Contact Network / Fake Deal Encounter / Police Models / 3",
                    description = "Runtime setting for Contact Network / Fake Deal Encounter / Police Models / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterSpawnRadius = {
                    label = "Contact Network / Fake Deal Encounter / Spawn Radius",
                    description = "Runtime setting for Contact Network / Fake Deal Encounter / Spawn Radius.",
                },
                drugAdvancedContactNetworkFallbackPreferredDrug = {
                    label = "Contact Network / Fallback Preferred Drug",
                    description = "Runtime setting for Contact Network / Fallback Preferred Drug.",
                },
                drugAdvancedContactNetworkFallbackProductLabel = {
                    label = "Contact Network / Fallback Product Label",
                    description = "Runtime setting for Contact Network / Fallback Product Label.",
                },
                drugAdvancedContactNetworkGuideBookItem = {
                    label = "Contact Network / Guide Book Item",
                    description = "Runtime setting for Contact Network / Guide Book Item.",
                },
                drugAdvancedContactNetworkGuideBookTrust = {
                    label = "Contact Network / Guide Book Trust",
                    description = "Runtime setting for Contact Network / Guide Book Trust.",
                },
                drugAdvancedContactNetworkHireDealerPrice = {
                    label = "Contact Network / Hire Dealer Price",
                    description = "Runtime setting for Contact Network / Hire Dealer Price.",
                },
                drugAdvancedContactNetworkHistoryLimit = {
                    label = "Contact Network / History Limit",
                    description = "Runtime setting for Contact Network / History Limit.",
                },
                drugAdvancedContactNetworkHotspotIntelMinutes = {
                    label = "Contact Network / Hotspot Intel Minutes",
                    description = "Runtime setting for Contact Network / Hotspot Intel Minutes.",
                },
                drugAdvancedContactNetworkHotspotRotationMinutes = {
                    label = "Contact Network / Hotspot Rotation Minutes",
                    description = "Runtime setting for Contact Network / Hotspot Rotation Minutes.",
                },
                drugAdvancedContactNetworkListingDurationMinutes = {
                    label = "Contact Network / Listing Duration Minutes",
                    description = "Runtime setting for Contact Network / Listing Duration Minutes.",
                },
                drugAdvancedContactNetworkMaxOwnedDealers = {
                    label = "Contact Network / Max Owned Dealers",
                    description = "Runtime setting for Contact Network / Max Owned Dealers.",
                },
                drugAdvancedContactNetworkMinimumBuyerDeliveryDistance = {
                    label = "Contact Network / Minimum Buyer Delivery Distance",
                    description = "Runtime setting for Contact Network / Minimum Buyer Delivery Distance.",
                },
                drugAdvancedContactNetworkMinimumContactRotationMinutes = {
                    label = "Contact Network / Minimum Contact Rotation Minutes",
                    description = "Runtime setting for Contact Network / Minimum Contact Rotation Minutes.",
                },
                drugAdvancedContactNetworkMinimumDemandResetMinutes = {
                    label = "Contact Network / Minimum Demand Reset Minutes",
                    description = "Runtime setting for Contact Network / Minimum Demand Reset Minutes.",
                },
                drugAdvancedContactNetworkMinimumHeatMultiplier = {
                    label = "Contact Network / Minimum Heat Multiplier",
                    description = "Runtime setting for Contact Network / Minimum Heat Multiplier.",
                },
                drugAdvancedContactNetworkMinimumHotspotIntelMinutes = {
                    label = "Contact Network / Minimum Hotspot Intel Minutes",
                    description = "Runtime setting for Contact Network / Minimum Hotspot Intel Minutes.",
                },
                drugAdvancedContactNetworkMinimumHotspotRadius = {
                    label = "Contact Network / Minimum Hotspot Radius",
                    description = "Runtime setting for Contact Network / Minimum Hotspot Radius.",
                },
                drugAdvancedContactNetworkMinimumHotspotRotationMinutes = {
                    label = "Contact Network / Minimum Hotspot Rotation Minutes",
                    description = "Runtime setting for Contact Network / Minimum Hotspot Rotation Minutes.",
                },
                drugAdvancedContactNetworkMinimumListingDurationMinutes = {
                    label = "Contact Network / Minimum Listing Duration Minutes",
                    description = "Runtime setting for Contact Network / Minimum Listing Duration Minutes.",
                },
                drugAdvancedContactNetworkMinimumRewardMultiplier = {
                    label = "Contact Network / Minimum Reward Multiplier",
                    description = "Runtime setting for Contact Network / Minimum Reward Multiplier.",
                },
                drugAdvancedContactNetworkMinimumRobberyMultiplier = {
                    label = "Contact Network / Minimum Robbery Multiplier",
                    description = "Runtime setting for Contact Network / Minimum Robbery Multiplier.",
                },
                drugAdvancedContactNetworkMinimumSpotPriceMultiplier = {
                    label = "Contact Network / Minimum Spot Price Multiplier",
                    description = "Runtime setting for Contact Network / Minimum Spot Price Multiplier.",
                },
                drugAdvancedContactNetworkOtherDrugPriceMultiplier = {
                    label = "Contact Network / Other Drug Price Multiplier",
                    description = "Runtime setting for Contact Network / Other Drug Price Multiplier.",
                },
                drugAdvancedContactNetworkPaymentAccount = {
                    label = "Contact Network / Payment Account",
                    description = "Runtime setting for Contact Network / Payment Account.",
                },
                drugAdvancedContactNetworkPostDeliveryDemandResetSeconds = {
                    label = "Contact Network / Post Delivery Demand Reset Seconds",
                    description = "Runtime setting for Contact Network / Post Delivery Demand Reset Seconds.",
                },
                drugAdvancedContactNetworkPreferredDrugPriceMultiplier = {
                    label = "Contact Network / Preferred Drug Price Multiplier",
                    description = "Runtime setting for Contact Network / Preferred Drug Price Multiplier.",
                },
                drugAdvancedContactNetworkRegionLocationTrust = {
                    label = "Contact Network / Region Location Trust",
                    description = "Runtime setting for Contact Network / Region Location Trust.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMax = {
                    label = "Contact Network / Request Amounts / Bulk / Max",
                    description = "Runtime setting for Contact Network / Request Amounts / Bulk / Max.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMin = {
                    label = "Contact Network / Request Amounts / Bulk / Min",
                    description = "Runtime setting for Contact Network / Request Amounts / Bulk / Min.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMax = {
                    label = "Contact Network / Request Amounts / Premium / Max",
                    description = "Runtime setting for Contact Network / Request Amounts / Premium / Max.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMin = {
                    label = "Contact Network / Request Amounts / Premium / Min",
                    description = "Runtime setting for Contact Network / Request Amounts / Premium / Min.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMax = {
                    label = "Contact Network / Request Amounts / Standard / Max",
                    description = "Runtime setting for Contact Network / Request Amounts / Standard / Max.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMin = {
                    label = "Contact Network / Request Amounts / Standard / Min",
                    description = "Runtime setting for Contact Network / Request Amounts / Standard / Min.",
                },
                drugAdvancedContactNetworkRotationMinutes = {
                    label = "Contact Network / Rotation Minutes",
                    description = "Runtime setting for Contact Network / Rotation Minutes.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsX = {
                    label = "Contact Network / Spot Pools / Corner dealer / 1 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 1 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsY = {
                    label = "Contact Network / Spot Pools / Corner dealer / 1 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 1 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsZ = {
                    label = "Contact Network / Spot Pools / Corner dealer / 1 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 1 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsW = {
                    label = "Contact Network / Spot Pools / Corner dealer / 1 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 1 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Label = {
                    label = "Contact Network / Spot Pools / Corner dealer / 1 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 1 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Corner dealer / 1 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 1 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Region = {
                    label = "Contact Network / Spot Pools / Corner dealer / 1 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Risk = {
                    label = "Contact Network / Spot Pools / Corner dealer / 1 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 1 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsX = {
                    label = "Contact Network / Spot Pools / Corner dealer / 2 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 2 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsY = {
                    label = "Contact Network / Spot Pools / Corner dealer / 2 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 2 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsZ = {
                    label = "Contact Network / Spot Pools / Corner dealer / 2 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 2 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsW = {
                    label = "Contact Network / Spot Pools / Corner dealer / 2 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 2 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Label = {
                    label = "Contact Network / Spot Pools / Corner dealer / 2 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 2 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Corner dealer / 2 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 2 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Region = {
                    label = "Contact Network / Spot Pools / Corner dealer / 2 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Risk = {
                    label = "Contact Network / Spot Pools / Corner dealer / 2 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 2 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsX = {
                    label = "Contact Network / Spot Pools / Corner dealer / 3 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 3 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsY = {
                    label = "Contact Network / Spot Pools / Corner dealer / 3 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 3 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsZ = {
                    label = "Contact Network / Spot Pools / Corner dealer / 3 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 3 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsW = {
                    label = "Contact Network / Spot Pools / Corner dealer / 3 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 3 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Label = {
                    label = "Contact Network / Spot Pools / Corner dealer / 3 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 3 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Corner dealer / 3 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 3 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Region = {
                    label = "Contact Network / Spot Pools / Corner dealer / 3 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Risk = {
                    label = "Contact Network / Spot Pools / Corner dealer / 3 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Corner dealer / 3 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsX = {
                    label = "Contact Network / Spot Pools / Default buyer / 1 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 1 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsY = {
                    label = "Contact Network / Spot Pools / Default buyer / 1 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 1 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsZ = {
                    label = "Contact Network / Spot Pools / Default buyer / 1 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 1 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsW = {
                    label = "Contact Network / Spot Pools / Default buyer / 1 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 1 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Label = {
                    label = "Contact Network / Spot Pools / Default buyer / 1 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 1 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Default buyer / 1 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 1 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Region = {
                    label = "Contact Network / Spot Pools / Default buyer / 1 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Risk = {
                    label = "Contact Network / Spot Pools / Default buyer / 1 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 1 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsX = {
                    label = "Contact Network / Spot Pools / Default buyer / 2 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 2 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsY = {
                    label = "Contact Network / Spot Pools / Default buyer / 2 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 2 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsZ = {
                    label = "Contact Network / Spot Pools / Default buyer / 2 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 2 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsW = {
                    label = "Contact Network / Spot Pools / Default buyer / 2 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 2 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Label = {
                    label = "Contact Network / Spot Pools / Default buyer / 2 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 2 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Default buyer / 2 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 2 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Region = {
                    label = "Contact Network / Spot Pools / Default buyer / 2 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Risk = {
                    label = "Contact Network / Spot Pools / Default buyer / 2 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 2 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsX = {
                    label = "Contact Network / Spot Pools / Default buyer / 3 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 3 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsY = {
                    label = "Contact Network / Spot Pools / Default buyer / 3 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 3 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsZ = {
                    label = "Contact Network / Spot Pools / Default buyer / 3 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 3 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsW = {
                    label = "Contact Network / Spot Pools / Default buyer / 3 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 3 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Label = {
                    label = "Contact Network / Spot Pools / Default buyer / 3 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 3 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Default buyer / 3 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 3 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Region = {
                    label = "Contact Network / Spot Pools / Default buyer / 3 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Risk = {
                    label = "Contact Network / Spot Pools / Default buyer / 3 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Default buyer / 3 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsX = {
                    label = "Contact Network / Spot Pools / Default dealer / 1 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 1 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsY = {
                    label = "Contact Network / Spot Pools / Default dealer / 1 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 1 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsZ = {
                    label = "Contact Network / Spot Pools / Default dealer / 1 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 1 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsW = {
                    label = "Contact Network / Spot Pools / Default dealer / 1 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 1 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Label = {
                    label = "Contact Network / Spot Pools / Default dealer / 1 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 1 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Default dealer / 1 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 1 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Region = {
                    label = "Contact Network / Spot Pools / Default dealer / 1 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Risk = {
                    label = "Contact Network / Spot Pools / Default dealer / 1 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 1 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsX = {
                    label = "Contact Network / Spot Pools / Default dealer / 2 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 2 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsY = {
                    label = "Contact Network / Spot Pools / Default dealer / 2 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 2 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsZ = {
                    label = "Contact Network / Spot Pools / Default dealer / 2 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 2 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsW = {
                    label = "Contact Network / Spot Pools / Default dealer / 2 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 2 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Label = {
                    label = "Contact Network / Spot Pools / Default dealer / 2 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 2 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Default dealer / 2 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 2 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Region = {
                    label = "Contact Network / Spot Pools / Default dealer / 2 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Risk = {
                    label = "Contact Network / Spot Pools / Default dealer / 2 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 2 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsX = {
                    label = "Contact Network / Spot Pools / Default dealer / 3 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 3 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsY = {
                    label = "Contact Network / Spot Pools / Default dealer / 3 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 3 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsZ = {
                    label = "Contact Network / Spot Pools / Default dealer / 3 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 3 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsW = {
                    label = "Contact Network / Spot Pools / Default dealer / 3 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 3 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Label = {
                    label = "Contact Network / Spot Pools / Default dealer / 3 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 3 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Default dealer / 3 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 3 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Region = {
                    label = "Contact Network / Spot Pools / Default dealer / 3 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Risk = {
                    label = "Contact Network / Spot Pools / Default dealer / 3 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Default dealer / 3 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsX = {
                    label = "Contact Network / Spot Pools / Network dealer / 1 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 1 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsY = {
                    label = "Contact Network / Spot Pools / Network dealer / 1 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 1 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsZ = {
                    label = "Contact Network / Spot Pools / Network dealer / 1 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 1 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsW = {
                    label = "Contact Network / Spot Pools / Network dealer / 1 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 1 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Label = {
                    label = "Contact Network / Spot Pools / Network dealer / 1 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 1 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Network dealer / 1 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 1 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Region = {
                    label = "Contact Network / Spot Pools / Network dealer / 1 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Risk = {
                    label = "Contact Network / Spot Pools / Network dealer / 1 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 1 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsX = {
                    label = "Contact Network / Spot Pools / Network dealer / 2 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 2 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsY = {
                    label = "Contact Network / Spot Pools / Network dealer / 2 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 2 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsZ = {
                    label = "Contact Network / Spot Pools / Network dealer / 2 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 2 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsW = {
                    label = "Contact Network / Spot Pools / Network dealer / 2 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 2 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Label = {
                    label = "Contact Network / Spot Pools / Network dealer / 2 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 2 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Network dealer / 2 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 2 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Region = {
                    label = "Contact Network / Spot Pools / Network dealer / 2 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Risk = {
                    label = "Contact Network / Spot Pools / Network dealer / 2 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 2 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsX = {
                    label = "Contact Network / Spot Pools / Network dealer / 3 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 3 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsY = {
                    label = "Contact Network / Spot Pools / Network dealer / 3 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 3 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsZ = {
                    label = "Contact Network / Spot Pools / Network dealer / 3 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 3 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsW = {
                    label = "Contact Network / Spot Pools / Network dealer / 3 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 3 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Label = {
                    label = "Contact Network / Spot Pools / Network dealer / 3 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 3 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Network dealer / 3 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 3 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Region = {
                    label = "Contact Network / Spot Pools / Network dealer / 3 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Risk = {
                    label = "Contact Network / Spot Pools / Network dealer / 3 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Network dealer / 3 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsX = {
                    label = "Contact Network / Spot Pools / Premium broker / 1 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 1 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsY = {
                    label = "Contact Network / Spot Pools / Premium broker / 1 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 1 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsZ = {
                    label = "Contact Network / Spot Pools / Premium broker / 1 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 1 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsW = {
                    label = "Contact Network / Spot Pools / Premium broker / 1 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 1 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Label = {
                    label = "Contact Network / Spot Pools / Premium broker / 1 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 1 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Premium broker / 1 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 1 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Region = {
                    label = "Contact Network / Spot Pools / Premium broker / 1 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Risk = {
                    label = "Contact Network / Spot Pools / Premium broker / 1 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 1 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsX = {
                    label = "Contact Network / Spot Pools / Premium broker / 2 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 2 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsY = {
                    label = "Contact Network / Spot Pools / Premium broker / 2 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 2 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsZ = {
                    label = "Contact Network / Spot Pools / Premium broker / 2 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 2 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsW = {
                    label = "Contact Network / Spot Pools / Premium broker / 2 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 2 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Label = {
                    label = "Contact Network / Spot Pools / Premium broker / 2 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 2 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Premium broker / 2 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 2 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Region = {
                    label = "Contact Network / Spot Pools / Premium broker / 2 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Risk = {
                    label = "Contact Network / Spot Pools / Premium broker / 2 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 2 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsX = {
                    label = "Contact Network / Spot Pools / Premium broker / 3 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 3 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsY = {
                    label = "Contact Network / Spot Pools / Premium broker / 3 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 3 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsZ = {
                    label = "Contact Network / Spot Pools / Premium broker / 3 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 3 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsW = {
                    label = "Contact Network / Spot Pools / Premium broker / 3 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 3 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Label = {
                    label = "Contact Network / Spot Pools / Premium broker / 3 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 3 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Premium broker / 3 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 3 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Region = {
                    label = "Contact Network / Spot Pools / Premium broker / 3 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Risk = {
                    label = "Contact Network / Spot Pools / Premium broker / 3 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Premium broker / 3 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsX = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 1 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 1 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsY = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 1 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 1 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsZ = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 1 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 1 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsW = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 1 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 1 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Label = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 1 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 1 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 1 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 1 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Region = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 1 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 1 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Risk = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 1 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 1 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsX = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 2 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 2 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsY = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 2 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 2 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsZ = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 2 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 2 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsW = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 2 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 2 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Label = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 2 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 2 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 2 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 2 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Region = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 2 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 2 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Risk = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 2 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 2 / Risk.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsX = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 3 / Coords / X",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 3 / Coords / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsY = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 3 / Coords / Y",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 3 / Coords / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsZ = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 3 / Coords / Z",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 3 / Coords / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsW = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 3 / Coords / W",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 3 / Coords / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Label = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 3 / Label",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 3 / Label.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3PriceMultiplier = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 3 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 3 / Price Multiplier.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Region = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 3 / Region",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 3 / Region.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Risk = {
                    label = "Contact Network / Spot Pools / Wholesale contact / 3 / Risk",
                    description = "Runtime setting for Contact Network / Spot Pools / Wholesale contact / 3 / Risk.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1AcceptBonus = {
                    label = "Contact Network / Street Hotspots / 1 / Accept Bonus",
                    description = "Runtime setting for Contact Network / Street Hotspots / 1 / Accept Bonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Archetype = {
                    label = "Contact Network / Street Hotspots / 1 / Archetype",
                    description = "Runtime setting for Contact Network / Street Hotspots / 1 / Archetype.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsX = {
                    label = "Contact Network / Street Hotspots / 1 / Coords / X",
                    description = "Runtime setting for Contact Network / Street Hotspots / 1 / Coords / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsY = {
                    label = "Contact Network / Street Hotspots / 1 / Coords / Y",
                    description = "Runtime setting for Contact Network / Street Hotspots / 1 / Coords / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsZ = {
                    label = "Contact Network / Street Hotspots / 1 / Coords / Z",
                    description = "Runtime setting for Contact Network / Street Hotspots / 1 / Coords / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1DemandBonus = {
                    label = "Contact Network / Street Hotspots / 1 / Demand Bonus",
                    description = "Runtime setting for Contact Network / Street Hotspots / 1 / Demand Bonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1HeatMultiplier = {
                    label = "Contact Network / Street Hotspots / 1 / Heat Multiplier",
                    description = "Runtime setting for Contact Network / Street Hotspots / 1 / Heat Multiplier.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Id = {
                    label = "Contact Network / Street Hotspots / 1 / Id",
                    description = "Runtime setting for Contact Network / Street Hotspots / 1 / Id.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Label = {
                    label = "Contact Network / Street Hotspots / 1 / Label",
                    description = "Runtime setting for Contact Network / Street Hotspots / 1 / Label.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem1 = {
                    label = "Contact Network / Street Hotspots / 1 / Preferred Drugs / 1",
                    description = "Runtime setting for Contact Network / Street Hotspots / 1 / Preferred Drugs / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem2 = {
                    label = "Contact Network / Street Hotspots / 1 / Preferred Drugs / 2",
                    description = "Runtime setting for Contact Network / Street Hotspots / 1 / Preferred Drugs / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem3 = {
                    label = "Contact Network / Street Hotspots / 1 / Preferred Drugs / 3",
                    description = "Runtime setting for Contact Network / Street Hotspots / 1 / Preferred Drugs / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem4 = {
                    label = "Contact Network / Street Hotspots / 1 / Preferred Drugs / 4",
                    description = "Runtime setting for Contact Network / Street Hotspots / 1 / Preferred Drugs / 4.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PriceMultiplier = {
                    label = "Contact Network / Street Hotspots / 1 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Street Hotspots / 1 / Price Multiplier.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Radius = {
                    label = "Contact Network / Street Hotspots / 1 / Radius",
                    description = "Runtime setting for Contact Network / Street Hotspots / 1 / Radius.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Region = {
                    label = "Contact Network / Street Hotspots / 1 / Region",
                    description = "Runtime setting for Contact Network / Street Hotspots / 1 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1RobberyMultiplier = {
                    label = "Contact Network / Street Hotspots / 1 / Robbery Multiplier",
                    description = "Runtime setting for Contact Network / Street Hotspots / 1 / Robbery Multiplier.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2AcceptBonus = {
                    label = "Contact Network / Street Hotspots / 2 / Accept Bonus",
                    description = "Runtime setting for Contact Network / Street Hotspots / 2 / Accept Bonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Archetype = {
                    label = "Contact Network / Street Hotspots / 2 / Archetype",
                    description = "Runtime setting for Contact Network / Street Hotspots / 2 / Archetype.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsX = {
                    label = "Contact Network / Street Hotspots / 2 / Coords / X",
                    description = "Runtime setting for Contact Network / Street Hotspots / 2 / Coords / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsY = {
                    label = "Contact Network / Street Hotspots / 2 / Coords / Y",
                    description = "Runtime setting for Contact Network / Street Hotspots / 2 / Coords / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsZ = {
                    label = "Contact Network / Street Hotspots / 2 / Coords / Z",
                    description = "Runtime setting for Contact Network / Street Hotspots / 2 / Coords / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2DemandBonus = {
                    label = "Contact Network / Street Hotspots / 2 / Demand Bonus",
                    description = "Runtime setting for Contact Network / Street Hotspots / 2 / Demand Bonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2HeatMultiplier = {
                    label = "Contact Network / Street Hotspots / 2 / Heat Multiplier",
                    description = "Runtime setting for Contact Network / Street Hotspots / 2 / Heat Multiplier.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Id = {
                    label = "Contact Network / Street Hotspots / 2 / Id",
                    description = "Runtime setting for Contact Network / Street Hotspots / 2 / Id.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Label = {
                    label = "Contact Network / Street Hotspots / 2 / Label",
                    description = "Runtime setting for Contact Network / Street Hotspots / 2 / Label.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2MinimumQuality = {
                    label = "Contact Network / Street Hotspots / 2 / Minimum Quality",
                    description = "Runtime setting for Contact Network / Street Hotspots / 2 / Minimum Quality.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem1 = {
                    label = "Contact Network / Street Hotspots / 2 / Preferred Drugs / 1",
                    description = "Runtime setting for Contact Network / Street Hotspots / 2 / Preferred Drugs / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem2 = {
                    label = "Contact Network / Street Hotspots / 2 / Preferred Drugs / 2",
                    description = "Runtime setting for Contact Network / Street Hotspots / 2 / Preferred Drugs / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PriceMultiplier = {
                    label = "Contact Network / Street Hotspots / 2 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Street Hotspots / 2 / Price Multiplier.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Radius = {
                    label = "Contact Network / Street Hotspots / 2 / Radius",
                    description = "Runtime setting for Contact Network / Street Hotspots / 2 / Radius.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Region = {
                    label = "Contact Network / Street Hotspots / 2 / Region",
                    description = "Runtime setting for Contact Network / Street Hotspots / 2 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2RobberyMultiplier = {
                    label = "Contact Network / Street Hotspots / 2 / Robbery Multiplier",
                    description = "Runtime setting for Contact Network / Street Hotspots / 2 / Robbery Multiplier.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3AcceptBonus = {
                    label = "Contact Network / Street Hotspots / 3 / Accept Bonus",
                    description = "Runtime setting for Contact Network / Street Hotspots / 3 / Accept Bonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Archetype = {
                    label = "Contact Network / Street Hotspots / 3 / Archetype",
                    description = "Runtime setting for Contact Network / Street Hotspots / 3 / Archetype.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsX = {
                    label = "Contact Network / Street Hotspots / 3 / Coords / X",
                    description = "Runtime setting for Contact Network / Street Hotspots / 3 / Coords / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsY = {
                    label = "Contact Network / Street Hotspots / 3 / Coords / Y",
                    description = "Runtime setting for Contact Network / Street Hotspots / 3 / Coords / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsZ = {
                    label = "Contact Network / Street Hotspots / 3 / Coords / Z",
                    description = "Runtime setting for Contact Network / Street Hotspots / 3 / Coords / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3DemandBonus = {
                    label = "Contact Network / Street Hotspots / 3 / Demand Bonus",
                    description = "Runtime setting for Contact Network / Street Hotspots / 3 / Demand Bonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3HeatMultiplier = {
                    label = "Contact Network / Street Hotspots / 3 / Heat Multiplier",
                    description = "Runtime setting for Contact Network / Street Hotspots / 3 / Heat Multiplier.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Id = {
                    label = "Contact Network / Street Hotspots / 3 / Id",
                    description = "Runtime setting for Contact Network / Street Hotspots / 3 / Id.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Label = {
                    label = "Contact Network / Street Hotspots / 3 / Label",
                    description = "Runtime setting for Contact Network / Street Hotspots / 3 / Label.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem1 = {
                    label = "Contact Network / Street Hotspots / 3 / Preferred Drugs / 1",
                    description = "Runtime setting for Contact Network / Street Hotspots / 3 / Preferred Drugs / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem2 = {
                    label = "Contact Network / Street Hotspots / 3 / Preferred Drugs / 2",
                    description = "Runtime setting for Contact Network / Street Hotspots / 3 / Preferred Drugs / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem3 = {
                    label = "Contact Network / Street Hotspots / 3 / Preferred Drugs / 3",
                    description = "Runtime setting for Contact Network / Street Hotspots / 3 / Preferred Drugs / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PriceMultiplier = {
                    label = "Contact Network / Street Hotspots / 3 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Street Hotspots / 3 / Price Multiplier.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Radius = {
                    label = "Contact Network / Street Hotspots / 3 / Radius",
                    description = "Runtime setting for Contact Network / Street Hotspots / 3 / Radius.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Region = {
                    label = "Contact Network / Street Hotspots / 3 / Region",
                    description = "Runtime setting for Contact Network / Street Hotspots / 3 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3RobberyMultiplier = {
                    label = "Contact Network / Street Hotspots / 3 / Robbery Multiplier",
                    description = "Runtime setting for Contact Network / Street Hotspots / 3 / Robbery Multiplier.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4AcceptBonus = {
                    label = "Contact Network / Street Hotspots / 4 / Accept Bonus",
                    description = "Runtime setting for Contact Network / Street Hotspots / 4 / Accept Bonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Archetype = {
                    label = "Contact Network / Street Hotspots / 4 / Archetype",
                    description = "Runtime setting for Contact Network / Street Hotspots / 4 / Archetype.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsX = {
                    label = "Contact Network / Street Hotspots / 4 / Coords / X",
                    description = "Runtime setting for Contact Network / Street Hotspots / 4 / Coords / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsY = {
                    label = "Contact Network / Street Hotspots / 4 / Coords / Y",
                    description = "Runtime setting for Contact Network / Street Hotspots / 4 / Coords / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsZ = {
                    label = "Contact Network / Street Hotspots / 4 / Coords / Z",
                    description = "Runtime setting for Contact Network / Street Hotspots / 4 / Coords / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4DemandBonus = {
                    label = "Contact Network / Street Hotspots / 4 / Demand Bonus",
                    description = "Runtime setting for Contact Network / Street Hotspots / 4 / Demand Bonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4HeatMultiplier = {
                    label = "Contact Network / Street Hotspots / 4 / Heat Multiplier",
                    description = "Runtime setting for Contact Network / Street Hotspots / 4 / Heat Multiplier.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Id = {
                    label = "Contact Network / Street Hotspots / 4 / Id",
                    description = "Runtime setting for Contact Network / Street Hotspots / 4 / Id.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Label = {
                    label = "Contact Network / Street Hotspots / 4 / Label",
                    description = "Runtime setting for Contact Network / Street Hotspots / 4 / Label.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem1 = {
                    label = "Contact Network / Street Hotspots / 4 / Preferred Drugs / 1",
                    description = "Runtime setting for Contact Network / Street Hotspots / 4 / Preferred Drugs / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem2 = {
                    label = "Contact Network / Street Hotspots / 4 / Preferred Drugs / 2",
                    description = "Runtime setting for Contact Network / Street Hotspots / 4 / Preferred Drugs / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem3 = {
                    label = "Contact Network / Street Hotspots / 4 / Preferred Drugs / 3",
                    description = "Runtime setting for Contact Network / Street Hotspots / 4 / Preferred Drugs / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PriceMultiplier = {
                    label = "Contact Network / Street Hotspots / 4 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Street Hotspots / 4 / Price Multiplier.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Radius = {
                    label = "Contact Network / Street Hotspots / 4 / Radius",
                    description = "Runtime setting for Contact Network / Street Hotspots / 4 / Radius.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Region = {
                    label = "Contact Network / Street Hotspots / 4 / Region",
                    description = "Runtime setting for Contact Network / Street Hotspots / 4 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4RobberyMultiplier = {
                    label = "Contact Network / Street Hotspots / 4 / Robbery Multiplier",
                    description = "Runtime setting for Contact Network / Street Hotspots / 4 / Robbery Multiplier.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5AcceptBonus = {
                    label = "Contact Network / Street Hotspots / 5 / Accept Bonus",
                    description = "Runtime setting for Contact Network / Street Hotspots / 5 / Accept Bonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Archetype = {
                    label = "Contact Network / Street Hotspots / 5 / Archetype",
                    description = "Runtime setting for Contact Network / Street Hotspots / 5 / Archetype.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsX = {
                    label = "Contact Network / Street Hotspots / 5 / Coords / X",
                    description = "Runtime setting for Contact Network / Street Hotspots / 5 / Coords / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsY = {
                    label = "Contact Network / Street Hotspots / 5 / Coords / Y",
                    description = "Runtime setting for Contact Network / Street Hotspots / 5 / Coords / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsZ = {
                    label = "Contact Network / Street Hotspots / 5 / Coords / Z",
                    description = "Runtime setting for Contact Network / Street Hotspots / 5 / Coords / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5DemandBonus = {
                    label = "Contact Network / Street Hotspots / 5 / Demand Bonus",
                    description = "Runtime setting for Contact Network / Street Hotspots / 5 / Demand Bonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5HeatMultiplier = {
                    label = "Contact Network / Street Hotspots / 5 / Heat Multiplier",
                    description = "Runtime setting for Contact Network / Street Hotspots / 5 / Heat Multiplier.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Id = {
                    label = "Contact Network / Street Hotspots / 5 / Id",
                    description = "Runtime setting for Contact Network / Street Hotspots / 5 / Id.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Label = {
                    label = "Contact Network / Street Hotspots / 5 / Label",
                    description = "Runtime setting for Contact Network / Street Hotspots / 5 / Label.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem1 = {
                    label = "Contact Network / Street Hotspots / 5 / Preferred Drugs / 1",
                    description = "Runtime setting for Contact Network / Street Hotspots / 5 / Preferred Drugs / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem2 = {
                    label = "Contact Network / Street Hotspots / 5 / Preferred Drugs / 2",
                    description = "Runtime setting for Contact Network / Street Hotspots / 5 / Preferred Drugs / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PriceMultiplier = {
                    label = "Contact Network / Street Hotspots / 5 / Price Multiplier",
                    description = "Runtime setting for Contact Network / Street Hotspots / 5 / Price Multiplier.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Radius = {
                    label = "Contact Network / Street Hotspots / 5 / Radius",
                    description = "Runtime setting for Contact Network / Street Hotspots / 5 / Radius.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Region = {
                    label = "Contact Network / Street Hotspots / 5 / Region",
                    description = "Runtime setting for Contact Network / Street Hotspots / 5 / Region.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5RobberyMultiplier = {
                    label = "Contact Network / Street Hotspots / 5 / Robbery Multiplier",
                    description = "Runtime setting for Contact Network / Street Hotspots / 5 / Robbery Multiplier.",
                },
                drugAdvancedContactNetworkTrustLevelsKnown = {
                    label = "Contact Network / Trust Levels / Known",
                    description = "Runtime setting for Contact Network / Trust Levels / Known.",
                },
                drugAdvancedContactNetworkTrustLevelsReliable = {
                    label = "Contact Network / Trust Levels / Reliable",
                    description = "Runtime setting for Contact Network / Trust Levels / Reliable.",
                },
                drugAdvancedContactNetworkTrustLevelsTrusted = {
                    label = "Contact Network / Trust Levels / Trusted",
                    description = "Runtime setting for Contact Network / Trust Levels / Trusted.",
                },
                drugAdvancedBusinessNetworkActionCooldownSeconds = {
                    label = "Business Network / Action Cooldown Seconds",
                    description = "Runtime setting for Business Network / Action Cooldown Seconds.",
                },
                drugAdvancedBusinessNetworkBalanceBaseUnitPrice = {
                    label = "Business Network / Balance / Base Unit Price",
                    description = "Runtime setting for Business Network / Balance / Base Unit Price.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerDealer = {
                    label = "Business Network / Balance / Network Heat Per Dealer",
                    description = "Runtime setting for Business Network / Balance / Network Heat Per Dealer.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerHub = {
                    label = "Business Network / Balance / Network Heat Per Hub",
                    description = "Runtime setting for Business Network / Balance / Network Heat Per Hub.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerRoute = {
                    label = "Business Network / Balance / Network Heat Per Route",
                    description = "Runtime setting for Business Network / Balance / Network Heat Per Route.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerStaff = {
                    label = "Business Network / Balance / Network Heat Per Staff",
                    description = "Runtime setting for Business Network / Balance / Network Heat Per Staff.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityGain = {
                    label = "Business Network / Balance / Reliability Gain",
                    description = "Runtime setting for Business Network / Balance / Reliability Gain.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityLoss = {
                    label = "Business Network / Balance / Reliability Loss",
                    description = "Runtime setting for Business Network / Balance / Reliability Loss.",
                },
                drugAdvancedBusinessNetworkBalanceRouteHeatDecay = {
                    label = "Business Network / Balance / Route Heat Decay",
                    description = "Runtime setting for Business Network / Balance / Route Heat Decay.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem1 = {
                    label = "Business Network / Contracts / Categories / Gang / Amount / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Gang / Amount / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem2 = {
                    label = "Business Network / Contracts / Categories / Gang / Amount / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Gang / Amount / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangMinRank = {
                    label = "Business Network / Contracts / Categories / Gang / Min Rank",
                    description = "Runtime setting for Business Network / Contracts / Categories / Gang / Min Rank.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem1 = {
                    label = "Business Network / Contracts / Categories / Gang / Quality / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Gang / Quality / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem2 = {
                    label = "Business Network / Contracts / Categories / Gang / Quality / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Gang / Quality / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem1 = {
                    label = "Business Network / Contracts / Categories / Gang / Reward / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Gang / Reward / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem2 = {
                    label = "Business Network / Contracts / Categories / Gang / Reward / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Gang / Reward / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem1 = {
                    label = "Business Network / Contracts / Categories / Gang / Risk / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Gang / Risk / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem2 = {
                    label = "Business Network / Contracts / Categories / Gang / Risk / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Gang / Risk / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem1 = {
                    label = "Business Network / Contracts / Categories / Npc network / Amount / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Npc network / Amount / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem2 = {
                    label = "Business Network / Contracts / Categories / Npc network / Amount / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Npc network / Amount / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkMinRank = {
                    label = "Business Network / Contracts / Categories / Npc network / Min Rank",
                    description = "Runtime setting for Business Network / Contracts / Categories / Npc network / Min Rank.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem1 = {
                    label = "Business Network / Contracts / Categories / Npc network / Quality / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Npc network / Quality / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem2 = {
                    label = "Business Network / Contracts / Categories / Npc network / Quality / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Npc network / Quality / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem1 = {
                    label = "Business Network / Contracts / Categories / Npc network / Reward / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Npc network / Reward / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem2 = {
                    label = "Business Network / Contracts / Categories / Npc network / Reward / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Npc network / Reward / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem1 = {
                    label = "Business Network / Contracts / Categories / Npc network / Risk / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Npc network / Risk / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem2 = {
                    label = "Business Network / Contracts / Categories / Npc network / Risk / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Npc network / Risk / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem1 = {
                    label = "Business Network / Contracts / Categories / Organization / Amount / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Organization / Amount / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem2 = {
                    label = "Business Network / Contracts / Categories / Organization / Amount / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Organization / Amount / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationMinRank = {
                    label = "Business Network / Contracts / Categories / Organization / Min Rank",
                    description = "Runtime setting for Business Network / Contracts / Categories / Organization / Min Rank.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem1 = {
                    label = "Business Network / Contracts / Categories / Organization / Quality / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Organization / Quality / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem2 = {
                    label = "Business Network / Contracts / Categories / Organization / Quality / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Organization / Quality / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem1 = {
                    label = "Business Network / Contracts / Categories / Organization / Reward / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Organization / Reward / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem2 = {
                    label = "Business Network / Contracts / Categories / Organization / Reward / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Organization / Reward / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem1 = {
                    label = "Business Network / Contracts / Categories / Organization / Risk / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Organization / Risk / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem2 = {
                    label = "Business Network / Contracts / Categories / Organization / Risk / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Organization / Risk / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem1 = {
                    label = "Business Network / Contracts / Categories / Premium / Amount / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Premium / Amount / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem2 = {
                    label = "Business Network / Contracts / Categories / Premium / Amount / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Premium / Amount / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumMinRank = {
                    label = "Business Network / Contracts / Categories / Premium / Min Rank",
                    description = "Runtime setting for Business Network / Contracts / Categories / Premium / Min Rank.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem1 = {
                    label = "Business Network / Contracts / Categories / Premium / Quality / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Premium / Quality / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem2 = {
                    label = "Business Network / Contracts / Categories / Premium / Quality / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Premium / Quality / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem1 = {
                    label = "Business Network / Contracts / Categories / Premium / Reward / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Premium / Reward / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem2 = {
                    label = "Business Network / Contracts / Categories / Premium / Reward / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Premium / Reward / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem1 = {
                    label = "Business Network / Contracts / Categories / Premium / Risk / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Premium / Risk / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem2 = {
                    label = "Business Network / Contracts / Categories / Premium / Risk / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Premium / Risk / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem1 = {
                    label = "Business Network / Contracts / Categories / Pusher / Amount / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Pusher / Amount / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem2 = {
                    label = "Business Network / Contracts / Categories / Pusher / Amount / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Pusher / Amount / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherMinRank = {
                    label = "Business Network / Contracts / Categories / Pusher / Min Rank",
                    description = "Runtime setting for Business Network / Contracts / Categories / Pusher / Min Rank.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem1 = {
                    label = "Business Network / Contracts / Categories / Pusher / Quality / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Pusher / Quality / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem2 = {
                    label = "Business Network / Contracts / Categories / Pusher / Quality / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Pusher / Quality / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem1 = {
                    label = "Business Network / Contracts / Categories / Pusher / Reward / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Pusher / Reward / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem2 = {
                    label = "Business Network / Contracts / Categories / Pusher / Reward / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Pusher / Reward / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem1 = {
                    label = "Business Network / Contracts / Categories / Pusher / Risk / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Pusher / Risk / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem2 = {
                    label = "Business Network / Contracts / Categories / Pusher / Risk / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Pusher / Risk / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem1 = {
                    label = "Business Network / Contracts / Categories / Special / Amount / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Special / Amount / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem2 = {
                    label = "Business Network / Contracts / Categories / Special / Amount / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Special / Amount / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialMinRank = {
                    label = "Business Network / Contracts / Categories / Special / Min Rank",
                    description = "Runtime setting for Business Network / Contracts / Categories / Special / Min Rank.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem1 = {
                    label = "Business Network / Contracts / Categories / Special / Quality / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Special / Quality / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem2 = {
                    label = "Business Network / Contracts / Categories / Special / Quality / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Special / Quality / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem1 = {
                    label = "Business Network / Contracts / Categories / Special / Reward / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Special / Reward / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem2 = {
                    label = "Business Network / Contracts / Categories / Special / Reward / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Special / Reward / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem1 = {
                    label = "Business Network / Contracts / Categories / Special / Risk / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Special / Risk / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem2 = {
                    label = "Business Network / Contracts / Categories / Special / Risk / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Special / Risk / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem1 = {
                    label = "Business Network / Contracts / Categories / Wholesale / Amount / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Wholesale / Amount / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem2 = {
                    label = "Business Network / Contracts / Categories / Wholesale / Amount / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Wholesale / Amount / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleMinRank = {
                    label = "Business Network / Contracts / Categories / Wholesale / Min Rank",
                    description = "Runtime setting for Business Network / Contracts / Categories / Wholesale / Min Rank.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem1 = {
                    label = "Business Network / Contracts / Categories / Wholesale / Quality / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Wholesale / Quality / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem2 = {
                    label = "Business Network / Contracts / Categories / Wholesale / Quality / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Wholesale / Quality / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem1 = {
                    label = "Business Network / Contracts / Categories / Wholesale / Reward / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Wholesale / Reward / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem2 = {
                    label = "Business Network / Contracts / Categories / Wholesale / Reward / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Wholesale / Reward / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem1 = {
                    label = "Business Network / Contracts / Categories / Wholesale / Risk / 1",
                    description = "Runtime setting for Business Network / Contracts / Categories / Wholesale / Risk / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem2 = {
                    label = "Business Network / Contracts / Categories / Wholesale / Risk / 2",
                    description = "Runtime setting for Business Network / Contracts / Categories / Wholesale / Risk / 2.",
                },
                drugAdvancedBusinessNetworkContractsDeliveryDistance = {
                    label = "Business Network / Contracts / Delivery Distance",
                    description = "Runtime setting for Business Network / Contracts / Delivery Distance.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMax = {
                    label = "Business Network / Contracts / Duration Minutes / Max",
                    description = "Runtime setting for Business Network / Contracts / Duration Minutes / Max.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMin = {
                    label = "Business Network / Contracts / Duration Minutes / Min",
                    description = "Runtime setting for Business Network / Contracts / Duration Minutes / Min.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsX = {
                    label = "Business Network / Contracts / Meeting Points / 1 / Coords / X",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 1 / Coords / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsY = {
                    label = "Business Network / Contracts / Meeting Points / 1 / Coords / Y",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 1 / Coords / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsZ = {
                    label = "Business Network / Contracts / Meeting Points / 1 / Coords / Z",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 1 / Coords / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Id = {
                    label = "Business Network / Contracts / Meeting Points / 1 / Id",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 1 / Id.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Label = {
                    label = "Business Network / Contracts / Meeting Points / 1 / Label",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 1 / Label.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Region = {
                    label = "Business Network / Contracts / Meeting Points / 1 / Region",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 1 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1RewardMultiplier = {
                    label = "Business Network / Contracts / Meeting Points / 1 / Reward Multiplier",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 1 / Reward Multiplier.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Risk = {
                    label = "Business Network / Contracts / Meeting Points / 1 / Risk",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 1 / Risk.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsX = {
                    label = "Business Network / Contracts / Meeting Points / 2 / Coords / X",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 2 / Coords / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsY = {
                    label = "Business Network / Contracts / Meeting Points / 2 / Coords / Y",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 2 / Coords / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsZ = {
                    label = "Business Network / Contracts / Meeting Points / 2 / Coords / Z",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 2 / Coords / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Id = {
                    label = "Business Network / Contracts / Meeting Points / 2 / Id",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 2 / Id.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Label = {
                    label = "Business Network / Contracts / Meeting Points / 2 / Label",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 2 / Label.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Region = {
                    label = "Business Network / Contracts / Meeting Points / 2 / Region",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 2 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2RewardMultiplier = {
                    label = "Business Network / Contracts / Meeting Points / 2 / Reward Multiplier",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 2 / Reward Multiplier.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Risk = {
                    label = "Business Network / Contracts / Meeting Points / 2 / Risk",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 2 / Risk.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsX = {
                    label = "Business Network / Contracts / Meeting Points / 3 / Coords / X",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 3 / Coords / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsY = {
                    label = "Business Network / Contracts / Meeting Points / 3 / Coords / Y",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 3 / Coords / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsZ = {
                    label = "Business Network / Contracts / Meeting Points / 3 / Coords / Z",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 3 / Coords / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Id = {
                    label = "Business Network / Contracts / Meeting Points / 3 / Id",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 3 / Id.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Label = {
                    label = "Business Network / Contracts / Meeting Points / 3 / Label",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 3 / Label.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Region = {
                    label = "Business Network / Contracts / Meeting Points / 3 / Region",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 3 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3RewardMultiplier = {
                    label = "Business Network / Contracts / Meeting Points / 3 / Reward Multiplier",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 3 / Reward Multiplier.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Risk = {
                    label = "Business Network / Contracts / Meeting Points / 3 / Risk",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 3 / Risk.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsX = {
                    label = "Business Network / Contracts / Meeting Points / 4 / Coords / X",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 4 / Coords / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsY = {
                    label = "Business Network / Contracts / Meeting Points / 4 / Coords / Y",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 4 / Coords / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsZ = {
                    label = "Business Network / Contracts / Meeting Points / 4 / Coords / Z",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 4 / Coords / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Id = {
                    label = "Business Network / Contracts / Meeting Points / 4 / Id",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 4 / Id.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Label = {
                    label = "Business Network / Contracts / Meeting Points / 4 / Label",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 4 / Label.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Region = {
                    label = "Business Network / Contracts / Meeting Points / 4 / Region",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 4 / Region.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4RewardMultiplier = {
                    label = "Business Network / Contracts / Meeting Points / 4 / Reward Multiplier",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 4 / Reward Multiplier.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Risk = {
                    label = "Business Network / Contracts / Meeting Points / 4 / Risk",
                    description = "Runtime setting for Business Network / Contracts / Meeting Points / 4 / Risk.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem1 = {
                    label = "Business Network / Contracts / Negotiation / Advance Options / 1",
                    description = "Runtime setting for Business Network / Contracts / Negotiation / Advance Options / 1.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem2 = {
                    label = "Business Network / Contracts / Negotiation / Advance Options / 2",
                    description = "Runtime setting for Business Network / Contracts / Negotiation / Advance Options / 2.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem3 = {
                    label = "Business Network / Contracts / Negotiation / Advance Options / 3",
                    description = "Runtime setting for Business Network / Contracts / Negotiation / Advance Options / 3.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAmountFlexPercent = {
                    label = "Business Network / Contracts / Negotiation / Amount Flex Percent",
                    description = "Runtime setting for Business Network / Contracts / Negotiation / Amount Flex Percent.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationBaseAcceptance = {
                    label = "Business Network / Contracts / Negotiation / Base Acceptance",
                    description = "Runtime setting for Business Network / Contracts / Negotiation / Base Acceptance.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationDeadlineFlexPercent = {
                    label = "Business Network / Contracts / Negotiation / Deadline Flex Percent",
                    description = "Runtime setting for Business Network / Contracts / Negotiation / Deadline Flex Percent.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationMaxRounds = {
                    label = "Business Network / Contracts / Negotiation / Max Rounds",
                    description = "Runtime setting for Business Network / Contracts / Negotiation / Max Rounds.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationQualityFlex = {
                    label = "Business Network / Contracts / Negotiation / Quality Flex",
                    description = "Runtime setting for Business Network / Contracts / Negotiation / Quality Flex.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRejectionCooldownMinutes = {
                    label = "Business Network / Contracts / Negotiation / Rejection Cooldown Minutes",
                    description = "Runtime setting for Business Network / Contracts / Negotiation / Rejection Cooldown Minutes.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRoundPressure = {
                    label = "Business Network / Contracts / Negotiation / Round Pressure",
                    description = "Runtime setting for Business Network / Contracts / Negotiation / Round Pressure.",
                },
                drugAdvancedBusinessNetworkContractsOfferCount = {
                    label = "Business Network / Contracts / Offer Count",
                    description = "Runtime setting for Business Network / Contracts / Offer Count.",
                },
                drugAdvancedBusinessNetworkContractsRefreshMinutes = {
                    label = "Business Network / Contracts / Refresh Minutes",
                    description = "Runtime setting for Business Network / Contracts / Refresh Minutes.",
                },
                drugAdvancedBusinessNetworkDefaultBusinessName = {
                    label = "Business Network / Default Business Name",
                    description = "Runtime setting for Business Network / Default Business Name.",
                },
                drugAdvancedBusinessNetworkDefaultRankId = {
                    label = "Business Network / Default Rank Id",
                    description = "Runtime setting for Business Network / Default Rank Id.",
                },
                drugAdvancedBusinessNetworkDefaultStaffStyle = {
                    label = "Business Network / Default Staff Style",
                    description = "Runtime setting for Business Network / Default Staff Style.",
                },
                drugAdvancedBusinessNetworkDefaultTransport = {
                    label = "Business Network / Default Transport",
                    description = "Runtime setting for Business Network / Default Transport.",
                },
                drugAdvancedBusinessNetworkEnabled = {
                    label = "Business Network / Enabled",
                    description = "Runtime setting for Business Network / Enabled.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterCapacity = {
                    label = "Business Network / Hubs / Distribution center / Capacity",
                    description = "Runtime setting for Business Network / Hubs / Distribution center / Capacity.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterPurchasePrice = {
                    label = "Business Network / Hubs / Distribution center / Purchase Price",
                    description = "Runtime setting for Business Network / Hubs / Distribution center / Purchase Price.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterSecurity = {
                    label = "Business Network / Hubs / Distribution center / Security",
                    description = "Runtime setting for Business Network / Hubs / Distribution center / Security.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterUpkeep = {
                    label = "Business Network / Hubs / Distribution center / Upkeep",
                    description = "Runtime setting for Business Network / Hubs / Distribution center / Upkeep.",
                },
                drugAdvancedBusinessNetworkHubsStashCapacity = {
                    label = "Business Network / Hubs / Stash / Capacity",
                    description = "Runtime setting for Business Network / Hubs / Stash / Capacity.",
                },
                drugAdvancedBusinessNetworkHubsStashPurchasePrice = {
                    label = "Business Network / Hubs / Stash / Purchase Price",
                    description = "Runtime setting for Business Network / Hubs / Stash / Purchase Price.",
                },
                drugAdvancedBusinessNetworkHubsStashSecurity = {
                    label = "Business Network / Hubs / Stash / Security",
                    description = "Runtime setting for Business Network / Hubs / Stash / Security.",
                },
                drugAdvancedBusinessNetworkHubsStashUpkeep = {
                    label = "Business Network / Hubs / Stash / Upkeep",
                    description = "Runtime setting for Business Network / Hubs / Stash / Upkeep.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseCapacity = {
                    label = "Business Network / Hubs / Warehouse / Capacity",
                    description = "Runtime setting for Business Network / Hubs / Warehouse / Capacity.",
                },
                drugAdvancedBusinessNetworkHubsWarehousePurchasePrice = {
                    label = "Business Network / Hubs / Warehouse / Purchase Price",
                    description = "Runtime setting for Business Network / Hubs / Warehouse / Purchase Price.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseSecurity = {
                    label = "Business Network / Hubs / Warehouse / Security",
                    description = "Runtime setting for Business Network / Hubs / Warehouse / Security.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseUpkeep = {
                    label = "Business Network / Hubs / Warehouse / Upkeep",
                    description = "Runtime setting for Business Network / Hubs / Warehouse / Upkeep.",
                },
                drugAdvancedBusinessNetworkLimitsActiveContracts = {
                    label = "Business Network / Limits / Active Contracts",
                    description = "Runtime setting for Business Network / Limits / Active Contracts.",
                },
                drugAdvancedBusinessNetworkLimitsHubs = {
                    label = "Business Network / Limits / Hubs",
                    description = "Runtime setting for Business Network / Limits / Hubs.",
                },
                drugAdvancedBusinessNetworkLimitsLedgerRows = {
                    label = "Business Network / Limits / Ledger Rows",
                    description = "Runtime setting for Business Network / Limits / Ledger Rows.",
                },
                drugAdvancedBusinessNetworkLimitsRoutes = {
                    label = "Business Network / Limits / Routes",
                    description = "Runtime setting for Business Network / Limits / Routes.",
                },
                drugAdvancedBusinessNetworkLimitsStaff = {
                    label = "Business Network / Limits / Staff",
                    description = "Runtime setting for Business Network / Limits / Staff.",
                },
                drugAdvancedBusinessNetworkPayoutAccount = {
                    label = "Business Network / Payout Account",
                    description = "Runtime setting for Business Network / Payout Account.",
                },
                drugAdvancedBusinessNetworkRanksItem1Contracts = {
                    label = "Business Network / Ranks / 1 / Contracts",
                    description = "Runtime setting for Business Network / Ranks / 1 / Contracts.",
                },
                drugAdvancedBusinessNetworkRanksItem1Dealers = {
                    label = "Business Network / Ranks / 1 / Dealers",
                    description = "Runtime setting for Business Network / Ranks / 1 / Dealers.",
                },
                drugAdvancedBusinessNetworkRanksItem1Hubs = {
                    label = "Business Network / Ranks / 1 / Hubs",
                    description = "Runtime setting for Business Network / Ranks / 1 / Hubs.",
                },
                drugAdvancedBusinessNetworkRanksItem1Id = {
                    label = "Business Network / Ranks / 1 / Id",
                    description = "Runtime setting for Business Network / Ranks / 1 / Id.",
                },
                drugAdvancedBusinessNetworkRanksItem1Label = {
                    label = "Business Network / Ranks / 1 / Label",
                    description = "Runtime setting for Business Network / Ranks / 1 / Label.",
                },
                drugAdvancedBusinessNetworkRanksItem1Routes = {
                    label = "Business Network / Ranks / 1 / Routes",
                    description = "Runtime setting for Business Network / Ranks / 1 / Routes.",
                },
                drugAdvancedBusinessNetworkRanksItem1Score = {
                    label = "Business Network / Ranks / 1 / Score",
                    description = "Runtime setting for Business Network / Ranks / 1 / Score.",
                },
                drugAdvancedBusinessNetworkRanksItem1Staff = {
                    label = "Business Network / Ranks / 1 / Staff",
                    description = "Runtime setting for Business Network / Ranks / 1 / Staff.",
                },
                drugAdvancedBusinessNetworkRanksItem2Contracts = {
                    label = "Business Network / Ranks / 2 / Contracts",
                    description = "Runtime setting for Business Network / Ranks / 2 / Contracts.",
                },
                drugAdvancedBusinessNetworkRanksItem2Dealers = {
                    label = "Business Network / Ranks / 2 / Dealers",
                    description = "Runtime setting for Business Network / Ranks / 2 / Dealers.",
                },
                drugAdvancedBusinessNetworkRanksItem2Hubs = {
                    label = "Business Network / Ranks / 2 / Hubs",
                    description = "Runtime setting for Business Network / Ranks / 2 / Hubs.",
                },
                drugAdvancedBusinessNetworkRanksItem2Id = {
                    label = "Business Network / Ranks / 2 / Id",
                    description = "Runtime setting for Business Network / Ranks / 2 / Id.",
                },
                drugAdvancedBusinessNetworkRanksItem2Label = {
                    label = "Business Network / Ranks / 2 / Label",
                    description = "Runtime setting for Business Network / Ranks / 2 / Label.",
                },
                drugAdvancedBusinessNetworkRanksItem2Routes = {
                    label = "Business Network / Ranks / 2 / Routes",
                    description = "Runtime setting for Business Network / Ranks / 2 / Routes.",
                },
                drugAdvancedBusinessNetworkRanksItem2Score = {
                    label = "Business Network / Ranks / 2 / Score",
                    description = "Runtime setting for Business Network / Ranks / 2 / Score.",
                },
                drugAdvancedBusinessNetworkRanksItem2Staff = {
                    label = "Business Network / Ranks / 2 / Staff",
                    description = "Runtime setting for Business Network / Ranks / 2 / Staff.",
                },
                drugAdvancedBusinessNetworkRanksItem3Contracts = {
                    label = "Business Network / Ranks / 3 / Contracts",
                    description = "Runtime setting for Business Network / Ranks / 3 / Contracts.",
                },
                drugAdvancedBusinessNetworkRanksItem3Dealers = {
                    label = "Business Network / Ranks / 3 / Dealers",
                    description = "Runtime setting for Business Network / Ranks / 3 / Dealers.",
                },
                drugAdvancedBusinessNetworkRanksItem3Hubs = {
                    label = "Business Network / Ranks / 3 / Hubs",
                    description = "Runtime setting for Business Network / Ranks / 3 / Hubs.",
                },
                drugAdvancedBusinessNetworkRanksItem3Id = {
                    label = "Business Network / Ranks / 3 / Id",
                    description = "Runtime setting for Business Network / Ranks / 3 / Id.",
                },
                drugAdvancedBusinessNetworkRanksItem3Label = {
                    label = "Business Network / Ranks / 3 / Label",
                    description = "Runtime setting for Business Network / Ranks / 3 / Label.",
                },
                drugAdvancedBusinessNetworkRanksItem3Routes = {
                    label = "Business Network / Ranks / 3 / Routes",
                    description = "Runtime setting for Business Network / Ranks / 3 / Routes.",
                },
                drugAdvancedBusinessNetworkRanksItem3Score = {
                    label = "Business Network / Ranks / 3 / Score",
                    description = "Runtime setting for Business Network / Ranks / 3 / Score.",
                },
                drugAdvancedBusinessNetworkRanksItem3Staff = {
                    label = "Business Network / Ranks / 3 / Staff",
                    description = "Runtime setting for Business Network / Ranks / 3 / Staff.",
                },
                drugAdvancedBusinessNetworkRanksItem4Contracts = {
                    label = "Business Network / Ranks / 4 / Contracts",
                    description = "Runtime setting for Business Network / Ranks / 4 / Contracts.",
                },
                drugAdvancedBusinessNetworkRanksItem4Dealers = {
                    label = "Business Network / Ranks / 4 / Dealers",
                    description = "Runtime setting for Business Network / Ranks / 4 / Dealers.",
                },
                drugAdvancedBusinessNetworkRanksItem4Hubs = {
                    label = "Business Network / Ranks / 4 / Hubs",
                    description = "Runtime setting for Business Network / Ranks / 4 / Hubs.",
                },
                drugAdvancedBusinessNetworkRanksItem4Id = {
                    label = "Business Network / Ranks / 4 / Id",
                    description = "Runtime setting for Business Network / Ranks / 4 / Id.",
                },
                drugAdvancedBusinessNetworkRanksItem4Label = {
                    label = "Business Network / Ranks / 4 / Label",
                    description = "Runtime setting for Business Network / Ranks / 4 / Label.",
                },
                drugAdvancedBusinessNetworkRanksItem4Routes = {
                    label = "Business Network / Ranks / 4 / Routes",
                    description = "Runtime setting for Business Network / Ranks / 4 / Routes.",
                },
                drugAdvancedBusinessNetworkRanksItem4Score = {
                    label = "Business Network / Ranks / 4 / Score",
                    description = "Runtime setting for Business Network / Ranks / 4 / Score.",
                },
                drugAdvancedBusinessNetworkRanksItem4Staff = {
                    label = "Business Network / Ranks / 4 / Staff",
                    description = "Runtime setting for Business Network / Ranks / 4 / Staff.",
                },
                drugAdvancedBusinessNetworkRanksItem5Contracts = {
                    label = "Business Network / Ranks / 5 / Contracts",
                    description = "Runtime setting for Business Network / Ranks / 5 / Contracts.",
                },
                drugAdvancedBusinessNetworkRanksItem5Dealers = {
                    label = "Business Network / Ranks / 5 / Dealers",
                    description = "Runtime setting for Business Network / Ranks / 5 / Dealers.",
                },
                drugAdvancedBusinessNetworkRanksItem5Hubs = {
                    label = "Business Network / Ranks / 5 / Hubs",
                    description = "Runtime setting for Business Network / Ranks / 5 / Hubs.",
                },
                drugAdvancedBusinessNetworkRanksItem5Id = {
                    label = "Business Network / Ranks / 5 / Id",
                    description = "Runtime setting for Business Network / Ranks / 5 / Id.",
                },
                drugAdvancedBusinessNetworkRanksItem5Label = {
                    label = "Business Network / Ranks / 5 / Label",
                    description = "Runtime setting for Business Network / Ranks / 5 / Label.",
                },
                drugAdvancedBusinessNetworkRanksItem5Routes = {
                    label = "Business Network / Ranks / 5 / Routes",
                    description = "Runtime setting for Business Network / Ranks / 5 / Routes.",
                },
                drugAdvancedBusinessNetworkRanksItem5Score = {
                    label = "Business Network / Ranks / 5 / Score",
                    description = "Runtime setting for Business Network / Ranks / 5 / Score.",
                },
                drugAdvancedBusinessNetworkRanksItem5Staff = {
                    label = "Business Network / Ranks / 5 / Staff",
                    description = "Runtime setting for Business Network / Ranks / 5 / Staff.",
                },
                drugAdvancedBusinessNetworkReportDays = {
                    label = "Business Network / Report Days",
                    description = "Runtime setting for Business Network / Report Days.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesBuyer = {
                    label = "Business Network / Route Endpoint Types / Buyer",
                    description = "Runtime setting for Business Network / Route Endpoint Types / Buyer.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesContract = {
                    label = "Business Network / Route Endpoint Types / Contract",
                    description = "Runtime setting for Business Network / Route Endpoint Types / Contract.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesDealer = {
                    label = "Business Network / Route Endpoint Types / Dealer",
                    description = "Runtime setting for Business Network / Route Endpoint Types / Dealer.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesGang = {
                    label = "Business Network / Route Endpoint Types / Gang",
                    description = "Runtime setting for Business Network / Route Endpoint Types / Gang.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesHub = {
                    label = "Business Network / Route Endpoint Types / Hub",
                    description = "Runtime setting for Business Network / Route Endpoint Types / Hub.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesLab = {
                    label = "Business Network / Route Endpoint Types / Lab",
                    description = "Runtime setting for Business Network / Route Endpoint Types / Lab.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesOrganization = {
                    label = "Business Network / Route Endpoint Types / Organization",
                    description = "Runtime setting for Business Network / Route Endpoint Types / Organization.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesPusher = {
                    label = "Business Network / Route Endpoint Types / Pusher",
                    description = "Runtime setting for Business Network / Route Endpoint Types / Pusher.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMax = {
                    label = "Business Network / Runtime / Contract Cadence Minutes / Max",
                    description = "Runtime setting for Business Network / Runtime / Contract Cadence Minutes / Max.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMin = {
                    label = "Business Network / Runtime / Contract Cadence Minutes / Min",
                    description = "Runtime setting for Business Network / Runtime / Contract Cadence Minutes / Min.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCooldownMinimumMinutes = {
                    label = "Business Network / Runtime / Contract Cooldown Minimum Minutes",
                    description = "Runtime setting for Business Network / Runtime / Contract Cooldown Minimum Minutes.",
                },
                drugAdvancedBusinessNetworkRuntimeContractFailureReliabilityLoss = {
                    label = "Business Network / Runtime / Contract Failure Reliability Loss",
                    description = "Runtime setting for Business Network / Runtime / Contract Failure Reliability Loss.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumCadenceMinutes = {
                    label = "Business Network / Runtime / Contract Minimum Cadence Minutes",
                    description = "Runtime setting for Business Network / Runtime / Contract Minimum Cadence Minutes.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumMeetingMultiplier = {
                    label = "Business Network / Runtime / Contract Minimum Meeting Multiplier",
                    description = "Runtime setting for Business Network / Runtime / Contract Minimum Meeting Multiplier.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyGrowth = {
                    label = "Business Network / Runtime / Contract Penalty Growth",
                    description = "Runtime setting for Business Network / Runtime / Contract Penalty Growth.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyMultiplier = {
                    label = "Business Network / Runtime / Contract Penalty Multiplier",
                    description = "Runtime setting for Business Network / Runtime / Contract Penalty Multiplier.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityFailureCooldownMinutes = {
                    label = "Business Network / Runtime / Contract Quality Failure Cooldown Minutes",
                    description = "Runtime setting for Business Network / Runtime / Contract Quality Failure Cooldown Minutes.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceBase = {
                    label = "Business Network / Runtime / Contract Quality Price Base",
                    description = "Runtime setting for Business Network / Runtime / Contract Quality Price Base.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceDivisor = {
                    label = "Business Network / Runtime / Contract Quality Price Divisor",
                    description = "Runtime setting for Business Network / Runtime / Contract Quality Price Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossBase = {
                    label = "Business Network / Runtime / Contract Reliability Loss Base",
                    description = "Runtime setting for Business Network / Runtime / Contract Reliability Loss Base.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossMaximum = {
                    label = "Business Network / Runtime / Contract Reliability Loss Maximum",
                    description = "Runtime setting for Business Network / Runtime / Contract Reliability Loss Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossQualityWeight = {
                    label = "Business Network / Runtime / Contract Reliability Loss Quality Weight",
                    description = "Runtime setting for Business Network / Runtime / Contract Reliability Loss Quality Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReputationQualityWeight = {
                    label = "Business Network / Runtime / Contract Reputation Quality Weight",
                    description = "Runtime setting for Business Network / Runtime / Contract Reputation Quality Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsCategory = {
                    label = "Business Network / Runtime / Contract Risk Weights / Category",
                    description = "Runtime setting for Business Network / Runtime / Contract Risk Weights / Category.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsMeeting = {
                    label = "Business Network / Runtime / Contract Risk Weights / Meeting",
                    description = "Runtime setting for Business Network / Runtime / Contract Risk Weights / Meeting.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubCapacity = {
                    label = "Business Network / Runtime / Default Hub Capacity",
                    description = "Runtime setting for Business Network / Runtime / Default Hub Capacity.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubSecurity = {
                    label = "Business Network / Runtime / Default Hub Security",
                    description = "Runtime setting for Business Network / Runtime / Default Hub Security.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultMeetingRisk = {
                    label = "Business Network / Runtime / Default Meeting Risk",
                    description = "Runtime setting for Business Network / Runtime / Default Meeting Risk.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultQuality = {
                    label = "Business Network / Runtime / Default Quality",
                    description = "Runtime setting for Business Network / Runtime / Default Quality.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteCapacity = {
                    label = "Business Network / Runtime / Default Route Capacity",
                    description = "Runtime setting for Business Network / Runtime / Default Route Capacity.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteIntervalMinutes = {
                    label = "Business Network / Runtime / Default Route Interval Minutes",
                    description = "Runtime setting for Business Network / Runtime / Default Route Interval Minutes.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteRisk = {
                    label = "Business Network / Runtime / Default Route Risk",
                    description = "Runtime setting for Business Network / Runtime / Default Route Risk.",
                },
                drugAdvancedBusinessNetworkRuntimeHubHeatDecay = {
                    label = "Business Network / Runtime / Hub Heat Decay",
                    description = "Runtime setting for Business Network / Runtime / Hub Heat Decay.",
                },
                drugAdvancedBusinessNetworkRuntimeHubLoadHeat = {
                    label = "Business Network / Runtime / Hub Load Heat",
                    description = "Runtime setting for Business Network / Runtime / Hub Load Heat.",
                },
                drugAdvancedBusinessNetworkRuntimeHubRaidRecoveryMinutes = {
                    label = "Business Network / Runtime / Hub Raid Recovery Minutes",
                    description = "Runtime setting for Business Network / Runtime / Hub Raid Recovery Minutes.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostBase = {
                    label = "Business Network / Runtime / Hub Security Cost Base",
                    description = "Runtime setting for Business Network / Runtime / Hub Security Cost Base.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostPerLevel = {
                    label = "Business Network / Runtime / Hub Security Cost Per Level",
                    description = "Runtime setting for Business Network / Runtime / Hub Security Cost Per Level.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityMaximum = {
                    label = "Business Network / Runtime / Hub Security Maximum",
                    description = "Runtime setting for Business Network / Runtime / Hub Security Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityUpgrade = {
                    label = "Business Network / Runtime / Hub Security Upgrade",
                    description = "Runtime setting for Business Network / Runtime / Hub Security Upgrade.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidHeat = {
                    label = "Business Network / Runtime / Hub Unpaid Heat",
                    description = "Runtime setting for Business Network / Runtime / Hub Unpaid Heat.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidSecurityLoss = {
                    label = "Business Network / Runtime / Hub Unpaid Security Loss",
                    description = "Runtime setting for Business Network / Runtime / Hub Unpaid Security Loss.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUpkeepIntervalHours = {
                    label = "Business Network / Runtime / Hub Upkeep Interval Hours",
                    description = "Runtime setting for Business Network / Runtime / Hub Upkeep Interval Hours.",
                },
                drugAdvancedBusinessNetworkRuntimeInitialReliability = {
                    label = "Business Network / Runtime / Initial Reliability",
                    description = "Runtime setting for Business Network / Runtime / Initial Reliability.",
                },
                drugAdvancedBusinessNetworkRuntimeMaximumBusinessNameLength = {
                    label = "Business Network / Runtime / Maximum Business Name Length",
                    description = "Runtime setting for Business Network / Runtime / Maximum Business Name Length.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumContractDeliveryMinutes = {
                    label = "Business Network / Runtime / Minimum Contract Delivery Minutes",
                    description = "Runtime setting for Business Network / Runtime / Minimum Contract Delivery Minutes.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumDeliveryDistance = {
                    label = "Business Network / Runtime / Minimum Delivery Distance",
                    description = "Runtime setting for Business Network / Runtime / Minimum Delivery Distance.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumLedgerRows = {
                    label = "Business Network / Runtime / Minimum Ledger Rows",
                    description = "Runtime setting for Business Network / Runtime / Minimum Ledger Rows.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumRouteIntervalMinutes = {
                    label = "Business Network / Runtime / Minimum Route Interval Minutes",
                    description = "Runtime setting for Business Network / Runtime / Minimum Route Interval Minutes.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvanceCostWeight = {
                    label = "Business Network / Runtime / Negotiation Advance Cost Weight",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Advance Cost Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvancePriceWeight = {
                    label = "Business Network / Runtime / Negotiation Advance Price Weight",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Advance Price Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountCostWeight = {
                    label = "Business Network / Runtime / Negotiation Amount Cost Weight",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Amount Cost Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountFlexMaximum = {
                    label = "Business Network / Runtime / Negotiation Amount Flex Maximum",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Amount Flex Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountRiskWeight = {
                    label = "Business Network / Runtime / Negotiation Amount Risk Weight",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Amount Risk Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationCounterOfferWeight = {
                    label = "Business Network / Runtime / Negotiation Counter Offer Weight",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Counter Offer Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationDeadlineFlexMaximum = {
                    label = "Business Network / Runtime / Negotiation Deadline Flex Maximum",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Deadline Flex Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMaximumAcceptance = {
                    label = "Business Network / Runtime / Negotiation Maximum Acceptance",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Maximum Acceptance.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMinimumAcceptance = {
                    label = "Business Network / Runtime / Negotiation Minimum Acceptance",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Minimum Acceptance.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityBenefitWeight = {
                    label = "Business Network / Runtime / Negotiation Quality Benefit Weight",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Quality Benefit Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityCostWeight = {
                    label = "Business Network / Runtime / Negotiation Quality Cost Weight",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Quality Cost Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityFlexMaximum = {
                    label = "Business Network / Runtime / Negotiation Quality Flex Maximum",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Quality Flex Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityRewardWeight = {
                    label = "Business Network / Runtime / Negotiation Quality Reward Weight",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Quality Reward Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReliabilityWeight = {
                    label = "Business Network / Runtime / Negotiation Reliability Weight",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Reliability Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReputationWeight = {
                    label = "Business Network / Runtime / Negotiation Reputation Weight",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Reputation Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMax = {
                    label = "Business Network / Runtime / Negotiation Requested Reward Max",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Requested Reward Max.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMin = {
                    label = "Business Network / Runtime / Negotiation Requested Reward Min",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Requested Reward Min.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardCostWeight = {
                    label = "Business Network / Runtime / Negotiation Reward Cost Weight",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Reward Cost Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMax = {
                    label = "Business Network / Runtime / Negotiation Reward Max",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Reward Max.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMin = {
                    label = "Business Network / Runtime / Negotiation Reward Min",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Reward Min.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBase = {
                    label = "Business Network / Runtime / Negotiation Urgency Base",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Urgency Base.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBenefitWeight = {
                    label = "Business Network / Runtime / Negotiation Urgency Benefit Weight",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Urgency Benefit Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyRiskWeight = {
                    label = "Business Network / Runtime / Negotiation Urgency Risk Weight",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Urgency Risk Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyWeight = {
                    label = "Business Network / Runtime / Negotiation Urgency Weight",
                    description = "Runtime setting for Business Network / Runtime / Negotiation Urgency Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeOtherFailureHeat = {
                    label = "Business Network / Runtime / Other Failure Heat",
                    description = "Runtime setting for Business Network / Runtime / Other Failure Heat.",
                },
                drugAdvancedBusinessNetworkRuntimePersonalHeatWeight = {
                    label = "Business Network / Runtime / Personal Heat Weight",
                    description = "Runtime setting for Business Network / Runtime / Personal Heat Weight.",
                },
                drugAdvancedBusinessNetworkRuntimePoliceFailureHeat = {
                    label = "Business Network / Runtime / Police Failure Heat",
                    description = "Runtime setting for Business Network / Runtime / Police Failure Heat.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBaseUnits = {
                    label = "Business Network / Runtime / Pusher Base Units",
                    description = "Runtime setting for Business Network / Runtime / Pusher Base Units.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBulkMultiplier = {
                    label = "Business Network / Runtime / Pusher Bulk Multiplier",
                    description = "Runtime setting for Business Network / Runtime / Pusher Bulk Multiplier.",
                },
                drugAdvancedBusinessNetworkRuntimePusherCheapMultiplier = {
                    label = "Business Network / Runtime / Pusher Cheap Multiplier",
                    description = "Runtime setting for Business Network / Runtime / Pusher Cheap Multiplier.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerLevel = {
                    label = "Business Network / Runtime / Pusher Experience Per Level",
                    description = "Runtime setting for Business Network / Runtime / Pusher Experience Per Level.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerUnit = {
                    label = "Business Network / Runtime / Pusher Experience Per Unit",
                    description = "Runtime setting for Business Network / Runtime / Pusher Experience Per Unit.",
                },
                drugAdvancedBusinessNetworkRuntimePusherHubHeatPerUnit = {
                    label = "Business Network / Runtime / Pusher Hub Heat Per Unit",
                    description = "Runtime setting for Business Network / Runtime / Pusher Hub Heat Per Unit.",
                },
                drugAdvancedBusinessNetworkRuntimePusherPremiumMultiplier = {
                    label = "Business Network / Runtime / Pusher Premium Multiplier",
                    description = "Runtime setting for Business Network / Runtime / Pusher Premium Multiplier.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillDivisor = {
                    label = "Business Network / Runtime / Pusher Skill Divisor",
                    description = "Runtime setting for Business Network / Runtime / Pusher Skill Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillGain = {
                    label = "Business Network / Runtime / Pusher Skill Gain",
                    description = "Runtime setting for Business Network / Runtime / Pusher Skill Gain.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationBaseSeconds = {
                    label = "Business Network / Runtime / Route Duration Base Seconds",
                    description = "Runtime setting for Business Network / Runtime / Route Duration Base Seconds.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationPerUnitSeconds = {
                    label = "Business Network / Runtime / Route Duration Per Unit Seconds",
                    description = "Runtime setting for Business Network / Runtime / Route Duration Per Unit Seconds.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem1 = {
                    label = "Business Network / Runtime / Route Failure Causes / 1",
                    description = "Runtime setting for Business Network / Runtime / Route Failure Causes / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem2 = {
                    label = "Business Network / Runtime / Route Failure Causes / 2",
                    description = "Runtime setting for Business Network / Runtime / Route Failure Causes / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem3 = {
                    label = "Business Network / Runtime / Route Failure Causes / 3",
                    description = "Runtime setting for Business Network / Runtime / Route Failure Causes / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem4 = {
                    label = "Business Network / Runtime / Route Failure Causes / 4",
                    description = "Runtime setting for Business Network / Runtime / Route Failure Causes / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureValueMultiplier = {
                    label = "Business Network / Runtime / Route Failure Value Multiplier",
                    description = "Runtime setting for Business Network / Runtime / Route Failure Value Multiplier.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatAmountDivisor = {
                    label = "Business Network / Runtime / Route Heat Amount Divisor",
                    description = "Runtime setting for Business Network / Runtime / Route Heat Amount Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostBase = {
                    label = "Business Network / Runtime / Route Heat Reduction Cost Base",
                    description = "Runtime setting for Business Network / Runtime / Route Heat Reduction Cost Base.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostPerHeat = {
                    label = "Business Network / Runtime / Route Heat Reduction Cost Per Heat",
                    description = "Runtime setting for Business Network / Runtime / Route Heat Reduction Cost Per Heat.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMaximum = {
                    label = "Business Network / Runtime / Route Risk Maximum",
                    description = "Runtime setting for Business Network / Runtime / Route Risk Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMinimum = {
                    label = "Business Network / Runtime / Route Risk Minimum",
                    description = "Runtime setting for Business Network / Runtime / Route Risk Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsHeat = {
                    label = "Business Network / Runtime / Route Risk Weights / Heat",
                    description = "Runtime setting for Business Network / Runtime / Route Risk Weights / Heat.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsLoyalty = {
                    label = "Business Network / Runtime / Route Risk Weights / Loyalty",
                    description = "Runtime setting for Business Network / Runtime / Route Risk Weights / Loyalty.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsRunnerRisk = {
                    label = "Business Network / Runtime / Route Risk Weights / Runner Risk",
                    description = "Runtime setting for Business Network / Runtime / Route Risk Weights / Runner Risk.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsSkill = {
                    label = "Business Network / Runtime / Route Risk Weights / Skill",
                    description = "Runtime setting for Business Network / Runtime / Route Risk Weights / Skill.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationHeatReduction = {
                    label = "Business Network / Runtime / Route Rotation Heat Reduction",
                    description = "Runtime setting for Business Network / Runtime / Route Rotation Heat Reduction.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationRiskReduction = {
                    label = "Business Network / Runtime / Route Rotation Risk Reduction",
                    description = "Runtime setting for Business Network / Runtime / Route Rotation Risk Reduction.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityBase = {
                    label = "Business Network / Runtime / Route Sale Quality Base",
                    description = "Runtime setting for Business Network / Runtime / Route Sale Quality Base.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityDivisor = {
                    label = "Business Network / Runtime / Route Sale Quality Divisor",
                    description = "Runtime setting for Business Network / Runtime / Route Sale Quality Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleRiskDivisor = {
                    label = "Business Network / Runtime / Route Sale Risk Divisor",
                    description = "Runtime setting for Business Network / Runtime / Route Sale Risk Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteStartHeat = {
                    label = "Business Network / Runtime / Route Start Heat",
                    description = "Runtime setting for Business Network / Runtime / Route Start Heat.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerLevel = {
                    label = "Business Network / Runtime / Runner Experience Per Level",
                    description = "Runtime setting for Business Network / Runtime / Runner Experience Per Level.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerUnit = {
                    label = "Business Network / Runtime / Runner Experience Per Unit",
                    description = "Runtime setting for Business Network / Runtime / Runner Experience Per Unit.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureLoyaltyLoss = {
                    label = "Business Network / Runtime / Runner Failure Loyalty Loss",
                    description = "Runtime setting for Business Network / Runtime / Runner Failure Loyalty Loss.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureRiskGain = {
                    label = "Business Network / Runtime / Runner Failure Risk Gain",
                    description = "Runtime setting for Business Network / Runtime / Runner Failure Risk Gain.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerSkillGain = {
                    label = "Business Network / Runtime / Runner Skill Gain",
                    description = "Runtime setting for Business Network / Runtime / Runner Skill Gain.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsHeat = {
                    label = "Business Network / Runtime / Score Weights / Heat",
                    description = "Runtime setting for Business Network / Runtime / Score Weights / Heat.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReliability = {
                    label = "Business Network / Runtime / Score Weights / Reliability",
                    description = "Runtime setting for Business Network / Runtime / Score Weights / Reliability.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReputation = {
                    label = "Business Network / Runtime / Score Weights / Reputation",
                    description = "Runtime setting for Business Network / Runtime / Score Weights / Reputation.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsStructure = {
                    label = "Business Network / Runtime / Score Weights / Structure",
                    description = "Runtime setting for Business Network / Runtime / Score Weights / Structure.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffCapacityBaseMultiplier = {
                    label = "Business Network / Runtime / Staff Capacity Base Multiplier",
                    description = "Runtime setting for Business Network / Runtime / Staff Capacity Base Multiplier.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMax = {
                    label = "Business Network / Runtime / Staff Hire Loyalty / Max",
                    description = "Runtime setting for Business Network / Runtime / Staff Hire Loyalty / Max.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMin = {
                    label = "Business Network / Runtime / Staff Hire Loyalty / Min",
                    description = "Runtime setting for Business Network / Runtime / Staff Hire Loyalty / Min.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMax = {
                    label = "Business Network / Runtime / Staff Hire Risk / Max",
                    description = "Runtime setting for Business Network / Runtime / Staff Hire Risk / Max.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMin = {
                    label = "Business Network / Runtime / Staff Hire Risk / Min",
                    description = "Runtime setting for Business Network / Runtime / Staff Hire Risk / Min.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMax = {
                    label = "Business Network / Runtime / Staff Hire Skill / Max",
                    description = "Runtime setting for Business Network / Runtime / Staff Hire Skill / Max.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMin = {
                    label = "Business Network / Runtime / Staff Hire Skill / Min",
                    description = "Runtime setting for Business Network / Runtime / Staff Hire Skill / Min.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentLoyaltyWeight = {
                    label = "Business Network / Runtime / Staff Incident Loyalty Weight",
                    description = "Runtime setting for Business Network / Runtime / Staff Incident Loyalty Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentMaximumChance = {
                    label = "Business Network / Runtime / Staff Incident Maximum Chance",
                    description = "Runtime setting for Business Network / Runtime / Staff Incident Maximum Chance.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem1 = {
                    label = "Business Network / Runtime / Staff Incident Outcomes / 1",
                    description = "Runtime setting for Business Network / Runtime / Staff Incident Outcomes / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem2 = {
                    label = "Business Network / Runtime / Staff Incident Outcomes / 2",
                    description = "Runtime setting for Business Network / Runtime / Staff Incident Outcomes / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem3 = {
                    label = "Business Network / Runtime / Staff Incident Outcomes / 3",
                    description = "Runtime setting for Business Network / Runtime / Staff Incident Outcomes / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem4 = {
                    label = "Business Network / Runtime / Staff Incident Outcomes / 4",
                    description = "Runtime setting for Business Network / Runtime / Staff Incident Outcomes / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentRiskWeight = {
                    label = "Business Network / Runtime / Staff Incident Risk Weight",
                    description = "Runtime setting for Business Network / Runtime / Staff Incident Risk Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffLoyaltyDecay = {
                    label = "Business Network / Runtime / Staff Loyalty Decay",
                    description = "Runtime setting for Business Network / Runtime / Staff Loyalty Decay.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffMaximumLevel = {
                    label = "Business Network / Runtime / Staff Maximum Level",
                    description = "Runtime setting for Business Network / Runtime / Staff Maximum Level.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffPoachedLoyaltyLoss = {
                    label = "Business Network / Runtime / Staff Poached Loyalty Loss",
                    description = "Runtime setting for Business Network / Runtime / Staff Poached Loyalty Loss.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionCostBase = {
                    label = "Business Network / Runtime / Staff Protection Cost Base",
                    description = "Runtime setting for Business Network / Runtime / Staff Protection Cost Base.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionHours = {
                    label = "Business Network / Runtime / Staff Protection Hours",
                    description = "Runtime setting for Business Network / Runtime / Staff Protection Hours.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionIncidentReduction = {
                    label = "Business Network / Runtime / Staff Protection Incident Reduction",
                    description = "Runtime setting for Business Network / Runtime / Staff Protection Incident Reduction.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionRiskCost = {
                    label = "Business Network / Runtime / Staff Protection Risk Cost",
                    description = "Runtime setting for Business Network / Runtime / Staff Protection Risk Cost.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryBaseChance = {
                    label = "Business Network / Runtime / Staff Recovery Base Chance",
                    description = "Runtime setting for Business Network / Runtime / Staff Recovery Base Chance.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryLoyaltyWeight = {
                    label = "Business Network / Runtime / Staff Recovery Loyalty Weight",
                    description = "Runtime setting for Business Network / Runtime / Staff Recovery Loyalty Weight.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageBaseMultiplier = {
                    label = "Business Network / Runtime / Staff Wage Base Multiplier",
                    description = "Runtime setting for Business Network / Runtime / Staff Wage Base Multiplier.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageLoyaltyGain = {
                    label = "Business Network / Runtime / Staff Wage Loyalty Gain",
                    description = "Runtime setting for Business Network / Runtime / Staff Wage Loyalty Gain.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageSkillDivisor = {
                    label = "Business Network / Runtime / Staff Wage Skill Divisor",
                    description = "Runtime setting for Business Network / Runtime / Staff Wage Skill Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem1 = {
                    label = "Business Network / Runtime / Staff Weaknesses / 1",
                    description = "Runtime setting for Business Network / Runtime / Staff Weaknesses / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem2 = {
                    label = "Business Network / Runtime / Staff Weaknesses / 2",
                    description = "Runtime setting for Business Network / Runtime / Staff Weaknesses / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem3 = {
                    label = "Business Network / Runtime / Staff Weaknesses / 3",
                    description = "Runtime setting for Business Network / Runtime / Staff Weaknesses / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem4 = {
                    label = "Business Network / Runtime / Staff Weaknesses / 4",
                    description = "Runtime setting for Business Network / Runtime / Staff Weaknesses / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem5 = {
                    label = "Business Network / Runtime / Staff Weaknesses / 5",
                    description = "Runtime setting for Business Network / Runtime / Staff Weaknesses / 5.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem6 = {
                    label = "Business Network / Runtime / Staff Weaknesses / 6",
                    description = "Runtime setting for Business Network / Runtime / Staff Weaknesses / 6.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsContracts = {
                    label = "Business Network / Runtime / Structure Weights / Contracts",
                    description = "Runtime setting for Business Network / Runtime / Structure Weights / Contracts.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsDealers = {
                    label = "Business Network / Runtime / Structure Weights / Dealers",
                    description = "Runtime setting for Business Network / Runtime / Structure Weights / Dealers.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsHubs = {
                    label = "Business Network / Runtime / Structure Weights / Hubs",
                    description = "Runtime setting for Business Network / Runtime / Structure Weights / Hubs.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsRoutes = {
                    label = "Business Network / Runtime / Structure Weights / Routes",
                    description = "Runtime setting for Business Network / Runtime / Structure Weights / Routes.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsStaff = {
                    label = "Business Network / Runtime / Structure Weights / Staff",
                    description = "Runtime setting for Business Network / Runtime / Structure Weights / Staff.",
                },
                drugAdvancedBusinessNetworkSocietyPermission = {
                    label = "Business Network / Society Permission",
                    description = "Runtime setting for Business Network / Society Permission.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseCapacity = {
                    label = "Business Network / Staff / Pusher / Base Capacity",
                    description = "Runtime setting for Business Network / Staff / Pusher / Base Capacity.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseWage = {
                    label = "Business Network / Staff / Pusher / Base Wage",
                    description = "Runtime setting for Business Network / Staff / Pusher / Base Wage.",
                },
                drugAdvancedBusinessNetworkStaffPusherCommission = {
                    label = "Business Network / Staff / Pusher / Commission",
                    description = "Runtime setting for Business Network / Staff / Pusher / Commission.",
                },
                drugAdvancedBusinessNetworkStaffPusherHirePrice = {
                    label = "Business Network / Staff / Pusher / Hire Price",
                    description = "Runtime setting for Business Network / Staff / Pusher / Hire Price.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseCapacity = {
                    label = "Business Network / Staff / Runner / Base Capacity",
                    description = "Runtime setting for Business Network / Staff / Runner / Base Capacity.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseWage = {
                    label = "Business Network / Staff / Runner / Base Wage",
                    description = "Runtime setting for Business Network / Staff / Runner / Base Wage.",
                },
                drugAdvancedBusinessNetworkStaffRunnerCommission = {
                    label = "Business Network / Staff / Runner / Commission",
                    description = "Runtime setting for Business Network / Staff / Runner / Commission.",
                },
                drugAdvancedBusinessNetworkStaffRunnerHirePrice = {
                    label = "Business Network / Staff / Runner / Hire Price",
                    description = "Runtime setting for Business Network / Staff / Runner / Hire Price.",
                },
                drugAdvancedBusinessNetworkTickMinutes = {
                    label = "Business Network / Tick Minutes",
                    description = "Runtime setting for Business Network / Tick Minutes.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCapacity = {
                    label = "Business Network / Transports / Aircraft / Capacity",
                    description = "Runtime setting for Business Network / Transports / Aircraft / Capacity.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCost = {
                    label = "Business Network / Transports / Aircraft / Cost",
                    description = "Runtime setting for Business Network / Transports / Aircraft / Cost.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftDurationMultiplier = {
                    label = "Business Network / Transports / Aircraft / Duration Multiplier",
                    description = "Runtime setting for Business Network / Transports / Aircraft / Duration Multiplier.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftRisk = {
                    label = "Business Network / Transports / Aircraft / Risk",
                    description = "Runtime setting for Business Network / Transports / Aircraft / Risk.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCapacity = {
                    label = "Business Network / Transports / Boat / Capacity",
                    description = "Runtime setting for Business Network / Transports / Boat / Capacity.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCost = {
                    label = "Business Network / Transports / Boat / Cost",
                    description = "Runtime setting for Business Network / Transports / Boat / Cost.",
                },
                drugAdvancedBusinessNetworkTransportsBoatDurationMultiplier = {
                    label = "Business Network / Transports / Boat / Duration Multiplier",
                    description = "Runtime setting for Business Network / Transports / Boat / Duration Multiplier.",
                },
                drugAdvancedBusinessNetworkTransportsBoatRisk = {
                    label = "Business Network / Transports / Boat / Risk",
                    description = "Runtime setting for Business Network / Transports / Boat / Risk.",
                },
                drugAdvancedBusinessNetworkTransportsCarCapacity = {
                    label = "Business Network / Transports / Car / Capacity",
                    description = "Runtime setting for Business Network / Transports / Car / Capacity.",
                },
                drugAdvancedBusinessNetworkTransportsCarCost = {
                    label = "Business Network / Transports / Car / Cost",
                    description = "Runtime setting for Business Network / Transports / Car / Cost.",
                },
                drugAdvancedBusinessNetworkTransportsCarDurationMultiplier = {
                    label = "Business Network / Transports / Car / Duration Multiplier",
                    description = "Runtime setting for Business Network / Transports / Car / Duration Multiplier.",
                },
                drugAdvancedBusinessNetworkTransportsCarRisk = {
                    label = "Business Network / Transports / Car / Risk",
                    description = "Runtime setting for Business Network / Transports / Car / Risk.",
                },
                drugAdvancedBusinessNetworkTransportsFootCapacity = {
                    label = "Business Network / Transports / Foot / Capacity",
                    description = "Runtime setting for Business Network / Transports / Foot / Capacity.",
                },
                drugAdvancedBusinessNetworkTransportsFootCost = {
                    label = "Business Network / Transports / Foot / Cost",
                    description = "Runtime setting for Business Network / Transports / Foot / Cost.",
                },
                drugAdvancedBusinessNetworkTransportsFootDurationMultiplier = {
                    label = "Business Network / Transports / Foot / Duration Multiplier",
                    description = "Runtime setting for Business Network / Transports / Foot / Duration Multiplier.",
                },
                drugAdvancedBusinessNetworkTransportsFootRisk = {
                    label = "Business Network / Transports / Foot / Risk",
                    description = "Runtime setting for Business Network / Transports / Foot / Risk.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCapacity = {
                    label = "Business Network / Transports / Truck / Capacity",
                    description = "Runtime setting for Business Network / Transports / Truck / Capacity.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCost = {
                    label = "Business Network / Transports / Truck / Cost",
                    description = "Runtime setting for Business Network / Transports / Truck / Cost.",
                },
                drugAdvancedBusinessNetworkTransportsTruckDurationMultiplier = {
                    label = "Business Network / Transports / Truck / Duration Multiplier",
                    description = "Runtime setting for Business Network / Transports / Truck / Duration Multiplier.",
                },
                drugAdvancedBusinessNetworkTransportsTruckRisk = {
                    label = "Business Network / Transports / Truck / Risk",
                    description = "Runtime setting for Business Network / Transports / Truck / Risk.",
                },
                drugAdvancedBusinessNetworkTransportsVanCapacity = {
                    label = "Business Network / Transports / Van / Capacity",
                    description = "Runtime setting for Business Network / Transports / Van / Capacity.",
                },
                drugAdvancedBusinessNetworkTransportsVanCost = {
                    label = "Business Network / Transports / Van / Cost",
                    description = "Runtime setting for Business Network / Transports / Van / Cost.",
                },
                drugAdvancedBusinessNetworkTransportsVanDurationMultiplier = {
                    label = "Business Network / Transports / Van / Duration Multiplier",
                    description = "Runtime setting for Business Network / Transports / Van / Duration Multiplier.",
                },
                drugAdvancedBusinessNetworkTransportsVanRisk = {
                    label = "Business Network / Transports / Van / Risk",
                    description = "Runtime setting for Business Network / Transports / Van / Risk.",
                },
                interrogationDispatchAdapter = {
                    options = {
                        sky_jobs_base = "Sky Jobs Base",
                        generic = "Generic integration",
                        custom = "Custom integration",
                        none = "Disabled",
                    },
                },
                reputationRules = {
                    label = "Reputation rules",
                    description = "Configure named rules for actions and optional targets. Only enabled rules award points.",
                },
            },
            territoryMap = {
                addPoint = "Add point",
                clear = "Clear",
                create = "Create",
                custom = "Custom territories",
                deletePoint = "Delete point",
                eyebrow = "Territory editor",
                minimum = "Minimum 3",
                pointCount = "{count} points",
                presets = "Preset districts",
                shown = "Shown on map",
                street = "Street",
                supply = "Supply",
                territories = "Territories",
                type = "Territory type",
                undo = "Undo",
            },
            shopPositionTools = {
                currentPosition = "Use current position",
                selectEntity = "Select entity",
                selectEntityHint = "Aim the laser at a register or safe. Enter: use the outlined prop's position and heading. Backspace: cancel.",
            },
            drugSettingSubsections = {
                cultivationLevels = "Cultivation levels",
                general = "General",
                runtime = "Runtime Access",
                quality = "Quality",
                packaging = "Packaging",
                growing = "Growing",
                labs = "Labs & Camper",
                power = "Power & Equipment",
                workers = "Workers",
                market = "Market & Distribution",
                threats = "Raids & Sabotage",
                pvpTakeovers = "Laboratory Takeovers",
                consumption = "Consumption",
                processing = "Processing",
                performance = "Performance",
                dynamicMarket = "Dynamic Market",
                heat = "Heat & Risk",
                contacts = "Contact Network",
                business = "Business Network",
            },
            drugSettingGroups = {
                cultivationGeneral = {
                    label = "General",
                },
                cultivationCurve = {
                    label = "Level curve",
                },
                cultivationExperience = {
                    label = "XP rewards",
                },
                cultivationUnlocks = {
                    label = "Level unlocks",
                },
                creator = {
                    label = "Creator Menu",
                },
                creatorSettings = {
                    label = "Creator Settings",
                },
                interfaceHud = {
                    label = "Interface Positions",
                },
                drugsGeneral = {
                    label = "General",
                },
                runtimeAccess = {
                    label = "Access & Ownership",
                },
                runtimePayouts = {
                    label = "Payouts",
                },
                runtimeDispatch = {
                    label = "Dispatch & Police",
                },
                qualityWeights = {
                    label = "Quality Weights",
                },
                qualityTiers = {
                    label = "Quality Tiers",
                },
                packagingGeneral = {
                    label = "General",
                },
                growingGeneral = {
                    label = "General",
                },
                plantDefaults = {
                    label = "Plant Defaults",
                },
                harvestWindow = {
                    label = "Harvest Window",
                },
                labsGeneral = {
                    label = "General",
                },
                labRent = {
                    label = "Rent & Lifecycle",
                },
                camperDefaults = {
                    label = "Camper",
                },
                labUpgrades = {
                    label = "Upgrades",
                },
                labDefaults = {
                    label = "Lab Defaults",
                },
                powerGeneral = {
                    label = "General",
                },
                generators = {
                    label = "Generators",
                },
                equipmentWear = {
                    label = "Equipment",
                },
                workersGeneral = {
                    label = "General",
                },
                marketGeneral = {
                    label = "General",
                },
                marketPrices = {
                    label = "Prices",
                },
                distribution = {
                    label = "Distribution",
                },
                threatsGeneral = {
                    label = "General",
                },
                threatHeat = {
                    label = "Heat",
                },
                threatChances = {
                    label = "Chances",
                },
                pvpTakeoverRules = {
                    label = "Takeover Rules",
                },
                pvpTakeoverZones = {
                    label = "Zones & Timing",
                },
                pvpTakeoverMethods = {
                    label = "Breach Methods",
                },
                consumptionGeneral = {
                    label = "General",
                },
                consumerDecay = {
                    label = "Tolerance & Addiction Decay",
                },
                consumerEffects = {
                    label = "Effects & Risk",
                },
                processingFlow = {
                    label = "Process Flow",
                },
                processingGeneral = {
                    label = "General",
                },
                powerRuntime = {
                    label = "Runtime",
                },
                powerHeat = {
                    label = "Heat & Signature",
                },
                powerModes = {
                    label = "Management Modes",
                },
                powerPriorities = {
                    label = "Load Priorities",
                },
                performanceInactiveControlIntervalMs = {
                    label = "Inactive Control Interval Ms",
                },
                performanceInteractionIdleScanIntervalMs = {
                    label = "Interaction Idle Scan Interval Ms",
                },
                performanceInteractionPromptIntervalMs = {
                    label = "Interaction Prompt Interval Ms",
                },
                performanceInteractionScanIntervalMs = {
                    label = "Interaction Scan Interval Ms",
                },
                performanceMinimumScanIntervalMs = {
                    label = "Minimum Scan Interval Ms",
                },
                performanceStreetPedActivationDistance = {
                    label = "Street Ped Activation Distance",
                },
                performanceStreetPedIdleScanIntervalMs = {
                    label = "Street Ped Idle Scan Interval Ms",
                },
                performanceStreetPedScanIntervalMs = {
                    label = "Street Ped Scan Interval Ms",
                },
                performanceWorldCachePadding = {
                    label = "World Cache Padding",
                },
                performanceWorldCacheRefreshIntervalMs = {
                    label = "World Cache Refresh Interval Ms",
                },
                performanceWorldIdleIntervalMs = {
                    label = "World Idle Interval Ms",
                },
                dynamicMarketActionCooldownSeconds = {
                    label = "Action Cooldown Seconds",
                },
                dynamicMarketActionHistoryLimit = {
                    label = "Action History Limit",
                },
                dynamicMarketAmountSaturationWeight = {
                    label = "Amount Saturation Weight",
                },
                dynamicMarketBaseIntelAccuracy = {
                    label = "Base Intel Accuracy",
                },
                dynamicMarketDefaultAverageQuality = {
                    label = "Default Average Quality",
                },
                dynamicMarketDefaultResourceElasticity = {
                    label = "Default Resource Elasticity",
                },
                dynamicMarketDemandCenter = {
                    label = "Demand Center",
                },
                dynamicMarketDemandPriceImpact = {
                    label = "Demand Price Impact",
                },
                dynamicMarketDirectionThreshold = {
                    label = "Direction Threshold",
                },
                dynamicMarketEnabled = {
                    label = "Enabled",
                },
                dynamicMarketEventChance = {
                    label = "Event Chance",
                },
                dynamicMarketEventDurationMinutes = {
                    label = "Event Duration Minutes",
                },
                dynamicMarketEventMinimumDurationMinutes = {
                    label = "Event Minimum Duration Minutes",
                },
                dynamicMarketEventStrengthMaximum = {
                    label = "Event Strength Maximum",
                },
                dynamicMarketEventStrengthMinimum = {
                    label = "Event Strength Minimum",
                },
                dynamicMarketEvents = {
                    label = "Events",
                },
                dynamicMarketExactIntelReputation = {
                    label = "Exact Intel Reputation",
                },
                dynamicMarketExactIntelTrust = {
                    label = "Exact Intel Trust",
                },
                dynamicMarketGlobalZoneLabel = {
                    label = "Global Zone Label",
                },
                dynamicMarketHistoryLimit = {
                    label = "History Limit",
                },
                dynamicMarketInitialDemand = {
                    label = "Initial Demand",
                },
                dynamicMarketInitialPriceMultiplier = {
                    label = "Initial Price Multiplier",
                },
                dynamicMarketIntelDemandError = {
                    label = "Intel Demand Error",
                },
                dynamicMarketIntelMaximumAccuracy = {
                    label = "Intel Maximum Accuracy",
                },
                dynamicMarketIntelMinimumAccuracy = {
                    label = "Intel Minimum Accuracy",
                },
                dynamicMarketIntelPoliceError = {
                    label = "Intel Police Error",
                },
                dynamicMarketIntelPriceError = {
                    label = "Intel Price Error",
                },
                dynamicMarketIntelPriceMaximum = {
                    label = "Intel Price Maximum",
                },
                dynamicMarketIntelPriceMinimum = {
                    label = "Intel Price Minimum",
                },
                dynamicMarketIntelReputationWeight = {
                    label = "Intel Reputation Weight",
                },
                dynamicMarketIntelResourcePriceError = {
                    label = "Intel Resource Price Error",
                },
                dynamicMarketIntelSaturationError = {
                    label = "Intel Saturation Error",
                },
                dynamicMarketIntelSeedBucketSeconds = {
                    label = "Intel Seed Bucket Seconds",
                },
                dynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Intel Status Accuracy Threshold",
                },
                dynamicMarketIntelStatusErrorThreshold = {
                    label = "Intel Status Error Threshold",
                },
                dynamicMarketIntelSupplyError = {
                    label = "Intel Supply Error",
                },
                dynamicMarketIntelTrustWeight = {
                    label = "Intel Trust Weight",
                },
                dynamicMarketManipulationCooldownMinutes = {
                    label = "Manipulation Cooldown Minutes",
                },
                dynamicMarketManipulationDemandShift = {
                    label = "Manipulation Demand Shift",
                },
                dynamicMarketManipulationDurationMinutes = {
                    label = "Manipulation Duration Minutes",
                },
                dynamicMarketManipulationHeat = {
                    label = "Manipulation Heat",
                },
                dynamicMarketManipulationMinimumBatchAmount = {
                    label = "Manipulation Minimum Batch Amount",
                },
                dynamicMarketManipulationPaymentAccount = {
                    label = "Manipulation Payment Account",
                },
                dynamicMarketManipulationPrice = {
                    label = "Manipulation Price",
                },
                dynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Manipulation Zone Heat Multiplier",
                },
                dynamicMarketMaximumIntelAgeMinutes = {
                    label = "Maximum Intel Age Minutes",
                },
                dynamicMarketMaximumPriceMultiplier = {
                    label = "Maximum Price Multiplier",
                },
                dynamicMarketMinimumIntelAgeMinutes = {
                    label = "Minimum Intel Age Minutes",
                },
                dynamicMarketMinimumMetricWindowMinutes = {
                    label = "Minimum Metric Window Minutes",
                },
                dynamicMarketMinimumPriceMultiplier = {
                    label = "Minimum Price Multiplier",
                },
                dynamicMarketMinimumUpdateMinutes = {
                    label = "Minimum Update Minutes",
                },
                dynamicMarketPoliceDemandWeight = {
                    label = "Police Demand Weight",
                },
                dynamicMarketPolicePriceImpact = {
                    label = "Police Price Impact",
                },
                dynamicMarketPoorQualityDemandPenalty = {
                    label = "Poor Quality Demand Penalty",
                },
                dynamicMarketPoorQualityThreshold = {
                    label = "Poor Quality Threshold",
                },
                dynamicMarketPremiumQualityDemandBonus = {
                    label = "Premium Quality Demand Bonus",
                },
                dynamicMarketPremiumQualityThreshold = {
                    label = "Premium Quality Threshold",
                },
                dynamicMarketProductionSupplyWeight = {
                    label = "Production Supply Weight",
                },
                dynamicMarketProductionWindowMinutes = {
                    label = "Production Window Minutes",
                },
                dynamicMarketQualityCenter = {
                    label = "Quality Center",
                },
                dynamicMarketQualityConfidenceImpact = {
                    label = "Quality Confidence Impact",
                },
                dynamicMarketQualityRange = {
                    label = "Quality Range",
                },
                dynamicMarketRarityBonusMaximum = {
                    label = "Rarity Bonus Maximum",
                },
                dynamicMarketRegionalGlobalWeight = {
                    label = "Regional Global Weight",
                },
                dynamicMarketRegionalLocalWeight = {
                    label = "Regional Local Weight",
                },
                dynamicMarketResourceAliases = {
                    label = "Resource Aliases",
                },
                dynamicMarketResourceDirectionFallThreshold = {
                    label = "Resource Direction Fall Threshold",
                },
                dynamicMarketResourceDirectionRiseThreshold = {
                    label = "Resource Direction Rise Threshold",
                },
                dynamicMarketResources = {
                    label = "Resources",
                },
                dynamicMarketSalesWindowMinutes = {
                    label = "Sales Window Minutes",
                },
                dynamicMarketSaturationDemandWeight = {
                    label = "Saturation Demand Weight",
                },
                dynamicMarketSaturationPriceImpact = {
                    label = "Saturation Price Impact",
                },
                dynamicMarketScarcityDemandWeight = {
                    label = "Scarcity Demand Weight",
                },
                dynamicMarketScarcityPriceImpact = {
                    label = "Scarcity Price Impact",
                },
                dynamicMarketSeasonEndMonths = {
                    label = "Season End Months",
                },
                dynamicMarketSeasonMultipliers = {
                    label = "Season Multipliers",
                },
                dynamicMarketShortageRumorThreshold = {
                    label = "Shortage Rumor Threshold",
                },
                dynamicMarketStatusThresholds = {
                    label = "Status Thresholds",
                },
                dynamicMarketTargetSupply = {
                    label = "Target Supply",
                },
                dynamicMarketTrendChance = {
                    label = "Trend Chance",
                },
                dynamicMarketTrendDurationMinutes = {
                    label = "Trend Duration Minutes",
                },
                dynamicMarketTrendMaximumStrength = {
                    label = "Trend Maximum Strength",
                },
                dynamicMarketTrendMinimumStrength = {
                    label = "Trend Minimum Strength",
                },
                dynamicMarketUpdateMinutes = {
                    label = "Update Minutes",
                },
                dynamicMarketVolatilityMaximum = {
                    label = "Volatility Maximum",
                },
                dynamicMarketVolatilityMinimum = {
                    label = "Volatility Minimum",
                },
                dynamicMarketWeatherMultipliers = {
                    label = "Weather Multipliers",
                },
                dynamicMarketWeatherState = {
                    label = "Weather State",
                },
                heatActionCooldownSeconds = {
                    label = "Action Cooldown Seconds",
                },
                heatActivityRiskWeights = {
                    label = "Activity Risk Weights",
                },
                heatAggressiveHeatMultiplier = {
                    label = "Aggressive Heat Multiplier",
                },
                heatBurnerBurnThreshold = {
                    label = "Burner Burn Threshold",
                },
                heatBurnerHeatPerWholesale = {
                    label = "Burner Heat Per Wholesale",
                },
                heatBurnerPhoneItem = {
                    label = "Burner Phone Item",
                },
                heatCamperOperationalHeatMultiplier = {
                    label = "Camper Operational Heat Multiplier",
                },
                heatCamperOperationalHeatThreshold = {
                    label = "Camper Operational Heat Threshold",
                },
                heatCamperParkedHeat = {
                    label = "Camper Parked Heat",
                },
                heatContaminatedHeatMultiplier = {
                    label = "Contaminated Heat Multiplier",
                },
                heatContaminatedThreshold = {
                    label = "Contaminated Threshold",
                },
                heatCultivationFreePlants = {
                    label = "Cultivation Free Plants",
                },
                heatCultivationHeatPerPlant = {
                    label = "Cultivation Heat Per Plant",
                },
                heatDealerHiddenMinutes = {
                    label = "Dealer Hidden Minutes",
                },
                heatDecayPerTick = {
                    label = "Decay Per Tick",
                },
                heatEnabled = {
                    label = "Enabled",
                },
                heatEnforcementHeat = {
                    label = "Enforcement Heat",
                },
                heatEnforcementMultipliers = {
                    label = "Enforcement Multipliers",
                },
                heatEntityTypes = {
                    label = "Entity Types",
                },
                heatEventCooldownMinutes = {
                    label = "Event Cooldown Minutes",
                },
                heatEventHistoryLimit = {
                    label = "Event History Limit",
                },
                heatLabHeatSyncThreshold = {
                    label = "Lab Heat Sync Threshold",
                },
                heatLayLowCooldownMinutes = {
                    label = "Lay Low Cooldown Minutes",
                },
                heatLayLowIdleMinutes = {
                    label = "Lay Low Idle Minutes",
                },
                heatLayLowReduction = {
                    label = "Lay Low Reduction",
                },
                heatLockdownMinutes = {
                    label = "Lockdown Minutes",
                },
                heatMinimumDurationMinutes = {
                    label = "Minimum Duration Minutes",
                },
                heatMinimumEventCooldownSeconds = {
                    label = "Minimum Event Cooldown Seconds",
                },
                heatMinimumIdleSeconds = {
                    label = "Minimum Idle Seconds",
                },
                heatProcessingHeatMultiplier = {
                    label = "Processing Heat Multiplier",
                },
                heatRiskWeights = {
                    label = "Risk Weights",
                },
                heatRotateBurnerReduction = {
                    label = "Rotate Burner Reduction",
                },
                heatRouteControlMinutes = {
                    label = "Route Control Minutes",
                },
                heatSaleHeat = {
                    label = "Sale Heat",
                },
                heatThresholds = {
                    label = "Thresholds",
                },
                heatTickMinutes = {
                    label = "Tick Minutes",
                },
                heatWholesaleHeatMultiplier = {
                    label = "Wholesale Heat Multiplier",
                },
                heatWorkerLeakAlertRadius = {
                    label = "Worker Leak Alert Radius",
                },
                heatWorkerLeakBaseChance = {
                    label = "Worker Leak Base Chance",
                },
                heatWorkerLeakFactionMultiplier = {
                    label = "Worker Leak Faction Multiplier",
                },
                heatWorkerLeakHighSeverityThreshold = {
                    label = "Worker Leak High Severity Threshold",
                },
                heatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Worker Leak Loyalty Chance Multiplier",
                },
                heatWorkerLeakLoyaltyThreshold = {
                    label = "Worker Leak Loyalty Threshold",
                },
                heatWorkerLeakMaximumChance = {
                    label = "Worker Leak Maximum Chance",
                },
                heatWorkerLeakMinimumCooldownSeconds = {
                    label = "Worker Leak Minimum Cooldown Seconds",
                },
                heatWorkerLeakRouteMultiplier = {
                    label = "Worker Leak Route Multiplier",
                },
                heatWorkerLeakStrengthMaximum = {
                    label = "Worker Leak Strength Maximum",
                },
                heatWorkerLeakStrengthMinimum = {
                    label = "Worker Leak Strength Minimum",
                },
                heatWorkerLeakStrengthMultiplier = {
                    label = "Worker Leak Strength Multiplier",
                },
                heatWorkerLeakStressChanceMultiplier = {
                    label = "Worker Leak Stress Chance Multiplier",
                },
                heatWorkerLeakStressThreshold = {
                    label = "Worker Leak Stress Threshold",
                },
                contactsActionCooldownSeconds = {
                    label = "Action Cooldown Seconds",
                },
                contactsActiveHotspotCount = {
                    label = "Active Hotspot Count",
                },
                contactsBurnerHintTrust = {
                    label = "Burner Hint Trust",
                },
                contactsBurnerOfferMaximumMultiplier = {
                    label = "Burner Offer Maximum Multiplier",
                },
                contactsBurnerOfferMinimumMultiplier = {
                    label = "Burner Offer Minimum Multiplier",
                },
                contactsBuyerCooldownMinutes = {
                    label = "Buyer Cooldown Minutes",
                },
                contactsBuyerDeliveryDistance = {
                    label = "Buyer Delivery Distance",
                },
                contactsBuyerPremiumSuccessScore = {
                    label = "Buyer Premium Success Score",
                },
                contactsBuyerPremiumTrustGain = {
                    label = "Buyer Premium Trust Gain",
                },
                contactsBuyerRequestHeatRiskWeight = {
                    label = "Buyer Request Heat Risk Weight",
                },
                contactsBuyerStandardTrustGain = {
                    label = "Buyer Standard Trust Gain",
                },
                contactsContactActiveDelaySeconds = {
                    label = "Contact Active Delay Seconds",
                },
                contactsContactDemandRange = {
                    label = "Contact Demand Range",
                },
                contactsContactLossTrust = {
                    label = "Contact Loss Trust",
                },
                contactsDarknetExactIntelMinutes = {
                    label = "Darknet Exact Intel Minutes",
                },
                contactsDarknetHotspotIntelPrice = {
                    label = "Darknet Hotspot Intel Price",
                },
                contactsDarknetIntelPrice = {
                    label = "Darknet Intel Price",
                },
                contactsDealerBasePrice = {
                    label = "Dealer Base Price",
                },
                contactsDealerHireCapacity = {
                    label = "Dealer Hire Capacity",
                },
                contactsDealerHireRisk = {
                    label = "Dealer Hire Risk",
                },
                contactsDealerHireSkill = {
                    label = "Dealer Hire Skill",
                },
                contactsDealerOffers = {
                    label = "Dealer Offers",
                },
                contactsDealerProtectionHours = {
                    label = "Dealer Protection Hours",
                },
                contactsDealerProtectionPrice = {
                    label = "Dealer Protection Price",
                },
                contactsDealerSaleMax = {
                    label = "Dealer Sale Max",
                },
                contactsDealerSaleMin = {
                    label = "Dealer Sale Min",
                },
                contactsDealerSimulation = {
                    label = "Dealer Simulation",
                },
                contactsDealerTickMinutes = {
                    label = "Dealer Tick Minutes",
                },
                contactsDealerWage = {
                    label = "Dealer Wage",
                },
                contactsDealerWageDecay = {
                    label = "Dealer Wage Decay",
                },
                contactsDealerWageLoyaltyGain = {
                    label = "Dealer Wage Loyalty Gain",
                },
                contactsDealerWeaknesses = {
                    label = "Dealer Weaknesses",
                },
                contactsDefaultContactDemand = {
                    label = "Default Contact Demand",
                },
                contactsDefaultContactRisk = {
                    label = "Default Contact Risk",
                },
                contactsDefaultDealerCapacity = {
                    label = "Default Dealer Capacity",
                },
                contactsDefaultDealerRisk = {
                    label = "Default Dealer Risk",
                },
                contactsDefaultDealerSkill = {
                    label = "Default Dealer Skill",
                },
                contactsDefaultHotspotRadius = {
                    label = "Default Hotspot Radius",
                },
                contactsDemandResetMinutes = {
                    label = "Demand Reset Minutes",
                },
                contactsEnabled = {
                    label = "Enabled",
                },
                contactsExactLocationTrust = {
                    label = "Exact Location Trust",
                },
                contactsFactionDiscoveryReputation = {
                    label = "Faction Discovery Reputation",
                },
                contactsFactionHintTrust = {
                    label = "Faction Hint Trust",
                },
                contactsFailedDeliveryCooldownMinutes = {
                    label = "Failed Delivery Cooldown Minutes",
                },
                contactsFakeDealEncounter = {
                    label = "Fake Deal Encounter",
                },
                contactsFallbackPreferredDrug = {
                    label = "Fallback Preferred Drug",
                },
                contactsFallbackProductLabel = {
                    label = "Fallback Product Label",
                },
                contactsGuideBookItem = {
                    label = "Guide Book Item",
                },
                contactsGuideBookTrust = {
                    label = "Guide Book Trust",
                },
                contactsHireDealerPrice = {
                    label = "Hire Dealer Price",
                },
                contactsHistoryLimit = {
                    label = "History Limit",
                },
                contactsHotspotIntelMinutes = {
                    label = "Hotspot Intel Minutes",
                },
                contactsHotspotRotationMinutes = {
                    label = "Hotspot Rotation Minutes",
                },
                contactsListingDurationMinutes = {
                    label = "Listing Duration Minutes",
                },
                contactsMaxOwnedDealers = {
                    label = "Max Owned Dealers",
                },
                contactsMinimumBuyerDeliveryDistance = {
                    label = "Minimum Buyer Delivery Distance",
                },
                contactsMinimumContactRotationMinutes = {
                    label = "Minimum Contact Rotation Minutes",
                },
                contactsMinimumDemandResetMinutes = {
                    label = "Minimum Demand Reset Minutes",
                },
                contactsMinimumHeatMultiplier = {
                    label = "Minimum Heat Multiplier",
                },
                contactsMinimumHotspotIntelMinutes = {
                    label = "Minimum Hotspot Intel Minutes",
                },
                contactsMinimumHotspotRadius = {
                    label = "Minimum Hotspot Radius",
                },
                contactsMinimumHotspotRotationMinutes = {
                    label = "Minimum Hotspot Rotation Minutes",
                },
                contactsMinimumListingDurationMinutes = {
                    label = "Minimum Listing Duration Minutes",
                },
                contactsMinimumRewardMultiplier = {
                    label = "Minimum Reward Multiplier",
                },
                contactsMinimumRobberyMultiplier = {
                    label = "Minimum Robbery Multiplier",
                },
                contactsMinimumSpotPriceMultiplier = {
                    label = "Minimum Spot Price Multiplier",
                },
                contactsOtherDrugPriceMultiplier = {
                    label = "Other Drug Price Multiplier",
                },
                contactsPaymentAccount = {
                    label = "Payment Account",
                },
                contactsPostDeliveryDemandResetSeconds = {
                    label = "Post Delivery Demand Reset Seconds",
                },
                contactsPreferredDrugPriceMultiplier = {
                    label = "Preferred Drug Price Multiplier",
                },
                contactsRegionLocationTrust = {
                    label = "Region Location Trust",
                },
                contactsRequestAmounts = {
                    label = "Request Amounts",
                },
                contactsRotationMinutes = {
                    label = "Rotation Minutes",
                },
                contactsSpotPools = {
                    label = "Spot Pools",
                },
                contactsStreetHotspots = {
                    label = "Street Hotspots",
                },
                contactsTrustLevels = {
                    label = "Trust Levels",
                },
                businessActionCooldownSeconds = {
                    label = "Action Cooldown Seconds",
                },
                businessBalance = {
                    label = "Balance",
                },
                businessContracts = {
                    label = "Contracts",
                },
                businessDefaultBusinessName = {
                    label = "Default Business Name",
                },
                businessDefaultRankId = {
                    label = "Default Rank Id",
                },
                businessDefaultStaffStyle = {
                    label = "Default Staff Style",
                },
                businessDefaultTransport = {
                    label = "Default Transport",
                },
                businessEnabled = {
                    label = "Enabled",
                },
                businessHubs = {
                    label = "Hubs",
                },
                businessLimits = {
                    label = "Limits",
                },
                businessPayments = {
                    label = "Payments",
                },
                businessPayoutAccount = {
                    label = "Payout Account",
                },
                businessRanks = {
                    label = "Ranks",
                },
                businessReportDays = {
                    label = "Report Days",
                },
                businessRouteEndpointTypes = {
                    label = "Route Endpoint Types",
                },
                businessRuntime = {
                    label = "Runtime",
                },
                businessSocietyPermission = {
                    label = "Society Permission",
                },
                businessStaff = {
                    label = "Staff",
                },
                businessTickMinutes = {
                    label = "Tick Minutes",
                },
                businessTransports = {
                    label = "Transports",
                },
            },
            territorySettings = {
                section = "Territories",
                zonesGroup = "Territory zones",
                sourceLabel = "Zone source",
                sourceDescription = "Use the protected preset districts or define your own territory polygons.",
                sourcePreset = "Preset districts",
                sourceCustom = "Custom territories",
                editLabel = "Territory editor",
                editDescription = "Edit the districts used by the selected zone source.",
                editButton = "Edit territories",
                presetSection = "Preset districts",
                presetEntry = "Preset district",
                customSection = "Custom territories",
                customEntry = "Custom territory",
                typeLabel = "Territory type",
                streetType = "Street",
                supplyType = "Supply",
                enabledLabel = "Shown on map",
                enabledDescription = "Disabled preset districts are removed from the map and cannot be claimed.",
                zoneLabel = "Territory boundary",
                zoneDescription = "Add at least three points in order around the territory boundary.",
                ownershipGroup = "Ownership",
                decayGroup = "Decay",
                presenceGroup = "Presence",
                activityGroup = "Activity scoring",
                ownershipBenefitsGroup = "Ownership benefits",
                ownershipThresholdLabel = "Ownership threshold",
                ownershipThresholdDescription = "Control percentage a gang must exceed to officially own a territory.",
                activityFloorLabel = "Fixed activity floor",
                activityFloorDescription = "Counted influence points required when size-based floors are disabled.",
                floorByZoneSizeLabel = "Scale floor by zone size",
                floorByZoneSizeDescription = "Calculate each territory's activity floor from its polygon area instead of using the fixed floor.",
                floorPointsPerSizeUnitLabel = "Floor points per km²",
                floorPointsPerSizeUnitDescription = "Activity-floor points required for each square kilometre of territory area.",
                fixedFloorRequirement = "Disable size-based floors to edit the fixed activity floor.",
                sizeFloorRequirement = "Enable size-based floors to edit points per square kilometre.",
                dailyDecayLabel = "Daily influence decay",
                dailyDecayDescription = "Percentage of influence removed every 24 hours.",
                presenceIntervalLabel = "Presence interval",
                presenceIntervalDescription = "Minutes between automatic territory presence awards.",
                presencePointsLabel = "Presence points per member",
                presencePointsDescription = "Presence points awarded to each eligible gang member per interval.",
                drugSalesEnabledLabel = "NPC sales grant territory influence",
                drugSalesEnabledDescription = "Successful street sales to NPCs award influence to the seller's gang in the current Street territory.",
                drugSalePointsLabel = "Points per drug sold",
                drugSalePointsDescription = "Influence points awarded for each drug unit reported as sold.",
                drugSalesRequirement = "Enable NPC sale influence to configure its points.",
                graffitiPointsLabel = "Graffiti points per 24 hours",
                graffitiPointsDescription = "Presence points awarded when one graffiti has existed for a total of 24 reported hours.",
                streetSellingPriceBonusLabel = "Street selling price bonus",
                streetSellingPriceBonusDescription = "Percentage added to drug selling prices for the official owner of a Street territory.",
                supplyProductionSpeedBonusLabel = "Supply production speed bonus",
                supplyProductionSpeedBonusDescription = "Percentage added to drug production speed for the official owner of a Supply territory.",
                pruneToleranceLabel = "Influence pruning tolerance",
                pruneToleranceDescription = "Effective influence below this value is treated as zero.",
            },
            graffitiSettings = {
                section = "Graffiti",
                generalGroup = "General",
                streamingGroup = "Rendering",
                moderationGroup = "Moderation",
                graffitiEnabledLabel = "Enable graffiti",
                graffitiEnabledDescription = "Allow players to spray and view graffiti.",
                graffitiRequireItemLabel = "Require spray can",
                graffitiRequireItemDescription = "Players need a spray can item to spray. Otherwise the /graffiti command is used.",
                graffitiChargesPerCanLabel = "Charges per can",
                graffitiChargesPerCanDescription = "How many graffiti a single spray can can create.",
                graffitiCooldownSecondsLabel = "Spray cooldown",
                graffitiCooldownSecondsDescription = "Seconds a player must wait between sprays.",
                graffitiMaxPerPlayerLabel = "Max graffiti per player",
                graffitiMaxPerPlayerDescription = "Maximum active graffiti one player can own. 0 means unlimited.",
                graffitiMaxDistanceLabel = "Max spray distance",
                graffitiMaxDistanceDescription = "How far away a wall can be to still spray on it, in metres.",
                graffitiSprayDurationLabel = "Spray duration",
                graffitiSprayDurationDescription = "How long the spray animation lasts, in milliseconds.",
                graffitiExpiryDaysLabel = "Expiry time",
                graffitiExpiryDaysDescription = "Days until a graffiti disappears automatically. 0 means never.",
                graffitiTerritoryHoursLabel = "Territory hours per spray",
                graffitiTerritoryHoursDescription = "Territory presence hours a fresh graffiti grants its gang.",
                graffitiStreamRadiusLabel = "Stream radius",
                graffitiStreamRadiusDescription = "Distance in metres at which graffiti becomes visible to players.",
                graffitiPoolSizeLabel = "Decal pool size",
                graffitiPoolSizeDescription = "How many graffiti are rendered at once. Higher values cost more performance.",
                graffitiReportsEnabledLabel = "Enable reports",
                graffitiReportsEnabledDescription = "Let players report offensive graffiti.",
                graffitiAutoHideThresholdLabel = "Auto-hide threshold",
                graffitiAutoHideThresholdDescription = "Number of reports that automatically hides a graffiti. 0 disables this.",
            },
            darknetSettings = {
                section = "Darknet Market",
                availabilityGroup = "Availability",
                economyGroup = "Cryptocurrency",
                listingsGroup = "Offers and expiry",
                chatGroup = "Private chat",
                identityGroup = "Aliases and reputation",
                deliveryGroup = "Handover and dead drops",
                policeGroup = "Police access",
                npcGroup = "NPC traders",
                enabledLabel = "Enable Darknet Market",
                enabledDescription = "Makes the black-market tablet app and its runtime available.",
                tabletOrderLabel = "Tablet app order",
                tabletOrderDescription = "Controls the Darknet Market position on the tablet.",
                currencyCodeLabel = "Currency code",
                currencyCodeDescription = "Short label shown for the internal cryptocurrency ledger.",
                starterBalanceLabel = "New wallet balance",
                starterBalanceDescription = "Crypto assigned only when a player opens the market for the first time.",
                exchangeEnabledLabel = "Enable coin exchange",
                exchangeEnabledDescription = "Allows authenticated BlackBay users to buy and sell coins on their account page.",
                exchangeAccountLabel = "Exchange payment account",
                exchangeAccountDescription = "Framework account used for coin purchases and sale payouts.",
                exchangeBuyPriceLabel = "Buy price per coin",
                exchangeBuyPriceDescription = "Amount charged from the payment account for one coin.",
                exchangeSellPriceLabel = "Sell price per coin",
                exchangeSellPriceDescription = "Amount paid to the payment account for one coin.",
                exchangeMinimumLabel = "Minimum coins per exchange",
                exchangeMinimumDescription = "Smallest whole coin amount accepted in one exchange.",
                exchangeMaximumLabel = "Maximum coins per exchange",
                exchangeMaximumDescription = "Largest whole coin amount accepted in one exchange.",
                accountMoney = "Cash",
                accountBank = "Bank",
                accountBlackMoney = "Dirty money",
                scamChanceLabel = "Global NPC scam chance (%)",
                scamChanceDescription = "Minimum chance that an NPC trade takes the payment or goods without delivering the return. A higher trader-specific chance still applies.",
                listingExpiryLabel = "Offer lifetime (hours)",
                listingExpiryDescription = "Active offers expire automatically after this many hours.",
                renewalHoursLabel = "Renewal duration (hours)",
                renewalHoursDescription = "Hours added when an owner renews an offer.",
                maximumListingsLabel = "Maximum active offers",
                maximumListingsDescription = "Maximum offers per active alias.",
                maximumQuantityLabel = "Maximum goods quantity",
                maximumQuantityDescription = "Upper quantity limit for one offer.",
                maximumPriceLabel = "Maximum unit price",
                maximumPriceDescription = "Upper crypto price for a single unit.",
                maximumMessageLengthLabel = "Maximum message length",
                maximumMessageLengthDescription = "Maximum number of characters per encrypted chat message.",
                aliasCooldownLabel = "Alias change cooldown (hours)",
                aliasCooldownDescription = "Minimum age of an identity before it can be retired again.",
                verifiedSalesLabel = "Sales required for verification",
                verifiedSalesDescription = "Successful sales required before a seller can become verified.",
                verifiedRatingLabel = "Rating required for verification",
                verifiedRatingDescription = "Minimum average rating for a verified seller.",
                scammerReportsLabel = "Reports for scammer warning",
                scammerReportsDescription = "Unique trade reports required for the known-scammer badge.",
                meetingDistanceLabel = "Handover distance",
                meetingDistanceDescription = "Maximum distance between both players or the configured NPC point.",
                dropModelLabel = "Dead-drop crate model",
                dropModelDescription = "GTA prop model spawned locally for available dead drops.",
                dropStreamLabel = "Dead-drop stream distance",
                dropStreamDescription = "Distance at which crates and NPC meeting contacts are streamed.",
                dropInteractionLabel = "Dead-drop interaction distance",
                dropInteractionDescription = "Distance required to search and claim a crate.",
                dropLifetimeLabel = "Dead-drop lifetime (hours)",
                dropLifetimeDescription = "Time before an unclaimed crate expires.",
                dropPollLabel = "World refresh interval (ms)",
                dropPollDescription = "Interval used to refresh nearby crates and NPC meetings.",
                policeGroupsLabel = "Authorized police job groups",
                policeGroupsDescription = "Job Configurator group keys that can publish bait offers and view investigations.",
                policeGroupEntry = "Police group",
                groupKeyLabel = "Group key",
                npcTradersLabel = "NPC buyers and sellers",
                npcTradersDescription = "Configure persistent synthetic offers, delivery method, reputation and scam probability.",
                npcTraderEntry = "NPC trader",
                npcIdLabel = "ID",
                npcAliasLabel = "Alias",
                npcSideLabel = "Market side",
                sideSell = "Sells to players",
                sideBuy = "Buys from players",
                npcTitleLabel = "Offer title",
                npcDescriptionLabel = "Description",
                npcItemNameLabel = "Inventory item name",
                npcItemLabelLabel = "Goods label",
                npcQuantityLabel = "Quantity",
                npcPriceLabel = "Unit price",
                npcDeliveryLabel = "Delivery method",
                deliveryBoth = "Meeting and dead drop",
                deliveryMeeting = "Face-to-face only",
                deliveryDrop = "Dead drop only",
                npcScamChanceLabel = "Trader scam chance (%)",
                npcPedModelLabel = "NPC ped model",
                npcRatingLabel = "Displayed rating",
                npcRatingCountLabel = "Displayed rating count",
                npcTradesLabel = "Displayed successful trades",
                npcVerifiedLabel = "Verified trader",
                npcScammerLabel = "Known scammer",
                npcEnabledLabel = "Enabled",
            },
            interrogationSettings = {
                section = "Interrogation",
                generalGroup = "General",
                consentGroup = "Player protection",
                objectGroup = "Objects",
                grabGroup = "Grabbing",
                sessionGroup = "Session",
                dispatchGroup = "Police alerts",
                loggingGroup = "Logging",
                securityGroup = "Security",
                presentationGroup = "Presentation",
                enabledLabel = "Enable interrogation",
                enabledDescription = "Allow players to tie others to interrogation chairs and use tools on them.",
                consentRequiredLabel = "Require consent",
                consentRequiredDescription = "Only players who opted in can become victims. Nothing grants consent any more, so this needs the setting below.",
                consentDefaultLabel = "Opted in by default",
                consentDefaultDescription = "New characters start with consent granted instead of denied.",
                globalIntensityLabel = "Effect intensity",
                globalIntensityDescription = "Scales screen effects, particles and sound. 0 turns them off entirely.",
                maxPerPlayerLabel = "Objects per player",
                maxPerPlayerDescription = "How many chairs and carts one player may have placed. 0 means unlimited.",
                maxGlobalLabel = "Objects server-wide",
                maxGlobalDescription = "Total placed objects allowed at once. 0 means unlimited.",
                placementDistanceLabel = "Placement distance",
                placementDistanceDescription = "How far from the player an object may be placed, in metres.",
                interactDistanceLabel = "Interaction distance",
                interactDistanceDescription = "How close a player must be to use a chair or cart, in metres.",
                inactivityMinutesLabel = "Auto-removal after",
                inactivityMinutesDescription = "Minutes of disuse before a placed object disappears. 0 keeps it forever.",
                persistObjectsLabel = "Keep objects after restart",
                persistObjectsDescription = "Placed objects are restored from the database when the server comes back.",
                grabEnabledLabel = "Enable grabbing",
                grabEnabledDescription = "Allow players to overpower and carry off another player.",
                grabItemLabel = "Required item",
                grabItemDescription = "Item the attacker needs to grab someone. Leave empty to require none.",
                grabAngleLabel = "Approach angle",
                grabAngleDescription = "How far to the side of directly behind the attacker may stand, in degrees.",
                grabHealthBelowLabel = "Health threshold",
                grabHealthBelowDescription = "A victim below this health can be grabbed without being restrained. 0 disables it.",
                grabCooldownLabel = "Cooldown after failure",
                grabCooldownDescription = "Seconds before a failed grab may be attempted again.",
                grabVehiclesLabel = "Allowed vehicles",
                grabVehiclesDescription = "Vehicle models a grabbed victim can be loaded into.",
                carryEnabledLabel = "Allow carrying",
                carryEnabledDescription = "Let the attacker carry the victim over their shoulder.",
                restrictVisionLabel = "Restrict victim's view",
                restrictVisionDescription = "Black out the victim's screen while they are being transported.",
                escapeEnabledLabel = "Allow escape attempts",
                escapeEnabledDescription = "Let a transported victim try to break free.",
                escapeSecondsLabel = "Escape duration",
                escapeSecondsDescription = "Seconds the victim must hold the key to break free.",
                maxDurationLabel = "Maximum duration",
                maxDurationDescription = "Minutes after which a session ends by itself.",
                warnMinutesLabel = "Warning before the end",
                warnMinutesDescription = "Minutes before the limit at which both sides are warned.",
                idleMinutesLabel = "Release when idle",
                idleMinutesDescription = "Minutes without any interaction before the victim is released.",
                selfReleaseMinutesLabel = "Self-release after",
                selfReleaseMinutesDescription = "Minutes without attacker interaction before the victim can free themselves.",
                graceSecondsLabel = "Grace after disconnect",
                graceSecondsDescription = "Seconds the victim stays tied up when the attacker leaves the server.",
                rescueEnabledLabel = "Allow rescues",
                rescueEnabledDescription = "Let uninvolved players free a tied-up victim.",
                rescueSecondsLabel = "Rescue duration",
                rescueSecondsDescription = "Seconds a rescuer needs to cut the victim loose.",
                rescueItemLabel = "Rescue item",
                rescueItemDescription = "Item a rescuer needs. Leave empty to require none.",
                allowInventoryLabel = "Victim keeps inventory",
                allowInventoryDescription = "A tied-up victim can still open their inventory.",
                dispatchEnabledLabel = "Enable police alerts",
                dispatchEnabledDescription = "Report kidnappings and interrogations to the emergency services.",
                dispatchAdapterLabel = "Alert system",
                dispatchAdapterDescription = "Which dispatch system receives the reports.",
                dispatchJobsLabel = "Receiving jobs",
                dispatchJobsDescription = "Jobs that get the alert.",
                dispatchGrabChanceLabel = "Chance on grabbing",
                dispatchGrabChanceDescription = "Percentage chance that a grab is reported.",
                dispatchFixateChanceLabel = "Chance on tying up",
                dispatchFixateChanceDescription = "Percentage chance that tying someone to a chair is reported.",
                dispatchToolChanceLabel = "Chance on tool use",
                dispatchToolChanceDescription = "Percentage chance that using a tool is reported.",
                dispatchWitnessLabel = "Require a witness",
                dispatchWitnessDescription = "Only report when another player is close enough to notice.",
                dispatchWitnessRadiusLabel = "Witness radius",
                dispatchWitnessRadiusDescription = "How close a witness must be, in metres.",
                dispatchCooldownLabel = "Alert cooldown",
                dispatchCooldownDescription = "Seconds between two alerts from the same session.",
                dispatchInaccuracyLabel = "Position inaccuracy",
                dispatchInaccuracyDescription = "Metres the reported position is randomly offset by. 0 reports the exact spot.",
                loggingEnabledLabel = "Enable logging",
                loggingEnabledDescription = "Record placements, grabs, tool use, releases and admin action.",
                logDatabaseLabel = "Log to database",
                logDatabaseDescription = "Additionally write every entry into the interrogation log table.",
                logRetentionLabel = "Keep log entries",
                logRetentionDescription = "Days before database log entries are pruned. 0 keeps them forever.",
                pingToleranceLabel = "Distance tolerance",
                pingToleranceDescription = "Metres added to every server-side distance check to absorb lag.",
                violationThresholdLabel = "Violation threshold",
                violationThresholdDescription = "Security violations within the window before the reaction fires. 0 disables it.",
                violationActionLabel = "Reaction to violations",
                violationActionDescription = "What happens once a player passes the violation threshold.",
                violationActionNone = "Do nothing",
                violationActionLog = "Log only",
                violationActionKick = "Kick",
                violationActionCheating = "Report as cheating",
                particlesLabel = "Particle effects",
                particlesDescription = "Show blood, sparks and flames during tool use.",
                soundLabel = "Sound effects",
                soundDescription = "Play tool sounds for everyone nearby.",
                cameraWorkLabel = "Camera work",
                cameraWorkDescription = "Move the camera when tying someone up and during tool use.",
                screenEffectsLabel = "Screen effects",
                screenEffectsDescription = "Shake, flash, blur and colour filters on the victim's screen.",
                objectsSection = "Interrogation objects",
                objectsEntry = "Object",
                objectsEditLabel = "Interrogation objects",
                objectsEditDescription = "Place permanent chairs and tool carts on the map.",
                objectsEditButton = "Edit objects",
                objectsKindLabel = "Object type",
                objectsKindChair = "Chair",
                objectsKindCart = "Tool cart",
                objectsModelLabel = "Prop model",
                objectsPositionLabel = "Position",
                blockedZonesSection = "Blocked zones",
                blockedZonesEntry = "Zone",
                blockedZonesEditLabel = "Blocked zones",
                blockedZonesEditDescription = "Areas where no interrogation object may be placed.",
                blockedZonesEditButton = "Edit zones",
                blockedZonesZoneLabel = "Zone outline",
                blockedZonesZoneDescription = "Drag the corners to shape the area where placement is refused.",
                toolsSection = "Tools",
                toolsEntry = "Tool",
                toolsEditLabel = "Tools",
                toolsEditDescription = "Add or adjust the tools that can be used on a victim.",
                toolsEditButton = "Edit tools",
                toolsItemLabel = "Required item",
                toolsConsumeLabel = "Consume item",
                toolsDamageLabel = "Damage per use",
                toolsHealthFloorLabel = "Health floor",
                toolsCooldownLabel = "Cooldown in seconds",
                toolsProgressLabel = "Progress per use",
                sessionsSection = "Running sessions",
                sessionsEntry = "Session",
                sessionsEditLabel = "Running sessions",
                sessionsEditDescription = "See who is currently being interrogated and end it if needed.",
                sessionsEditButton = "Show sessions",
                sessionsStateLabel = "State",
                sessionsProgressLabel = "Progress",
                orphansSection = "Orphaned objects",
                orphansEntry = "Object",
                orphansEditLabel = "Orphaned objects",
                orphansEditDescription = "Remove objects whose owner has not been seen in a long time.",
                orphansEditButton = "Clean up",
                sessionStates = {
                    binding = "Being restrained",
                    active = "Active",
                    ending = "Ending",
                },
            },
        },
    },
}
