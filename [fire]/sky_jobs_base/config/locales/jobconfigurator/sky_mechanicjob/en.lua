JobConfigLocales["sky_mechanicjob:en"] = {
    Nui = {
        workshopConfig = {
            advancedPricingPreview = {
                compact = "Honda / Compact",
                customer = "Customer price",
                description = "Example cosmetic calculation using the current rules.",
                labor = "Labor",
                live = "Live preview",
                margin = "Margin",
                sports = "Sports car",
                super = "Supercar",
                supplier = "Supplier",
                title = "Price preview",
            },
            configs = {
                sky_mechanicjob = {
                    subtitle = "Configure mechanic jobs, shops, vehicles, and workshop locations.",
                    title = "Mechanic Jobs",
                },
            },
            creatorSections = {
                mobileDyno = {
                    entryLabel = "Mobile dyno installation",
                    entryPluralLabel = "Mobile dyno installations",
                    label = "Mobile dyno installations",
                },
                workshops = {
                    entryLabel = "Workshop",
                    entryPluralLabel = "Workshops",
                    label = "Workshops",
                },
            },
            dispatchActions = {
                addChannel = "Add radio channel",
                addKeyword = "Add keyword",
                addPoi = "Add POI",
                addReporter = "Add reporter",
                addStatus = "Add FMS status",
                addVehicle = "Add virtual unit",
                addVehicleType = "Add unit type",
                currentLocation = "Use current location",
            },
            dispatchFieldDescriptions = {
                autoAlarm = "Immediately assigns matching available units when an incident is created.",
                available = "Units in this status may be suggested and assigned to a new incident.",
                averageResponseSpeedKmh = "Calculates the displayed arrival estimate from straight-line distance.",
                callsign = "Unique radio callsign shown when players staff this virtual unit.",
                centerEnabled = "Allows authorized on-duty members to staff a dispatch center.",
                channelId = "Radio-channel ID for PMA Voice, SaltyChat, and YACA. Numeric IDs such as 2500 remain unchanged; PMA Voice maps text IDs to a stable number.",
                channelLabel = "Readable channel name shown to dispatchers and units.",
                crewCapacity = "Maximum number of personnel who may staff this unit. Use 0 for unlimited crew.",
                defaultChannel = "Defines this response job's fallback channel when no explicit channel is selected. Units still join manually. Select None to use the job-group default.",
                emergencyAppEnabled = "Makes this job selectable as a public service in the Emergency phone app.",
                enabled = "Makes this job available to the Dispatch App and cross-job incidents.",
                icon = "Select the icon shown for this unit category in the Dispatch App.",
                incidentAssessmentEnabled = "Shows medical and danger assessment questions in the full incident intake.",
                jobs = "Additional job names that receive incidents using this keyword.",
                joinLocked = "Prevents additional personnel from joining after this unit has been staffed.",
                minimumCrew = "Minimum number of personnel across the units selected for this response plan.",
                noUnitFallback = "Without a center or staffed unit, sends a Sky notification to all on-duty members.",
                poiId = "Stable technical identifier that central station profiles may reference even when the POI name changes.",
                radius = "Maximum distance in meters at which the station announcement can be heard.",
                readyStatusCode = "FMS status applied when this resource becomes ready for dispatch.",
                requirements = "Response demand as TYPE:COUNT pairs, for example PATROL:2,CRIME:1.",
                resourceType = "Classifies the operational resource for dispatcher filters and coordination.",
                respondingStatusCode = "FMS status applied when this resource responds to an incident.",
                shortLabel = "Optional compact label shown on the six radio channel-memory buttons.",
                stationId = "Associates this unit with a station configured in the dispatch center profile.",
                statusCode = "Numeric FMS status shown on the handheld radio.",
                statusLabel = "Meaning of this FMS status for dispatchers and units.",
                unitId = "Stable technical identifier used to preserve this unit even if its callsign changes.",
                vehicleType = "Must match a vehicle-type code configured in the previous subsection.",
                vehicleTypeCode = "Short unit code used in response requirements, for example PATROL, CRIME, EMS, or RESCUE.",
                vehicleTypeLabel = "Readable name of this unit category.",
            },
            dispatchFields = {
                address = "Address",
                autoAlarm = "Automatic alarm",
                available = "Available for dispatch",
                averageResponseSpeedKmh = "Estimated response speed (km/h)",
                callsign = "Callsign",
                category = "Category",
                centerEnabled = "Enable dispatch center",
                channelId = "Channel ID",
                code = "Code",
                crewCapacity = "Crew capacity",
                defaultChannel = "Default radio channel",
                emergencyAppEnabled = "Show in Emergency App",
                enabled = "Enable dispatch",
                icon = "Icon",
                incidentAssessmentEnabled = "Enable emergency assessment",
                jobs = "Target jobs (comma separated)",
                joinLocked = "Lock crew joining",
                keywordCode = "Keyword code",
                label = "Label",
                minimumCrew = "Minimum crew",
                name = "Name",
                noUnitFallback = "Notify on-duty staff without units",
                noneChannel = "None / group default",
                note = "Note",
                phone = "Phone",
                poiId = "Stable POI ID",
                radius = "Announcement radius",
                readyStatusCode = "Ready status code",
                requirements = "Required units (for example PATROL:2,CRIME:1)",
                resourceType = "Resource type",
                respondingStatusCode = "Responding status code",
                shortLabel = "Radio memory label",
                stationId = "Station ID",
                type = "Type",
                unitId = "Stable unit ID",
                vehicleType = "Response unit type",
            },
            dispatchIconOptions = {
                crime = "Crime Unit",
                emergency = "Emergency Unit",
                ems = "EMS Unit",
                fire = "Fire Unit",
                heavy = "Heavy Unit",
                k9 = "K-9 Unit",
                medical = "Medical Unit",
                patrol = "Patrol",
                rescue = "Rescue Unit",
                service = "Service Unit",
                supervisor = "Supervisor",
                tactical = "Tactical Unit",
            },
            dispatchNavigation = {
                active = "Dispatch active",
                description = "Configure emergency intake, radio, units, response plans, locations, and reporter data for this job.",
                inactive = "Dispatch disabled",
                steps = {
                    accessText = "Enable Dispatch and control public emergency intake and fallback behavior for this response job.",
                    accessTitle = "Access and emergency intake",
                    fleetText = "Configure channels, FMS status codes, vehicle types, and callsigns.",
                    fleetTitle = "Radio and fleet",
                    responseText = "Finish with keywords, response requirements, and POIs.",
                    responseTitle = "Response plans",
                },
                summary = {
                    channels = "Radio channels",
                    plans = "Response plans",
                    reporters = "Known reporters",
                    statuses = "Available FMS",
                    units = "Virtual units",
                },
                title = "Dispatch",
                warnings = {
                    channels = "No explicit radio channels exist; the job-group fallback channel will be used.",
                    defaultChannel = "The selected default channel no longer exists.",
                    disabled = "Dispatch is disabled for this job.",
                    statuses = "At least one FMS status must be available so units can be alarmed.",
                },
            },
            extensionDescriptions = {
                dispatchChannels = "Defines the radio channels that units and staffed dispatch centers can join.",
                dispatchKeywords = "Defines incident keywords, required vehicle counts, participating jobs, and optional automatic alarming.",
                dispatchPois = "Stores stations and common locations for incident forms and position-based station announcements.",
                dispatchReporters = "Maintains job-owned caller names, callback numbers, and dispatch notes.",
                dispatchStatusCodes = "Configures FMS status labels and which statuses count as available for new incidents.",
                dispatchVehicleTypes = "Defines the unit categories used by response plans, such as Patrol, Crime Unit, EMS, or Rescue.",
                dispatchVehicles = "Defines virtual dispatch vehicles that can be staffed from anywhere without requiring a spawned vehicle.",
            },
            diagnosticsSettings = {
                enabledLabel = "Enable vehicle diagnostics",
                enabledDescription = "Allow this job to open vehicle diagnostics and repair parts through it.",
            },
            extensions = {
                diagnosticsSettings = {
                    label = "Vehicle Diagnostics",
                    description = "Configure vehicle diagnostics access for this job.",
                },
                billingPrices = {
                    description = "Configure invoice prices for maintenance and repair history entries. The action key is matched against action_key, action_type, or the work label.",
                    label = "Billing Prices",
                },
                billingSettings = {
                    description = "Configure mechanic billing behavior for this job.",
                    label = "Billing",
                },
                dispatchChannels = "Radio channels",
                dispatchKeywords = "Keywords and response plans",
                dispatchPois = "Dispatch POIs",
                dispatchReporters = "Known reporters",
                dispatchSettings = {
                    description = "Configure dispatch access, emergency intake, and the default radio channel.",
                    label = "Dispatch settings",
                },
                dispatchStatusCodes = "Status codes",
                dispatchVehicleTypes = "Dispatch vehicle types",
                dispatchVehicles = "Dispatch fleet data",
                emptyDescription = "Use the add button above to create the first entry.",
                emptyTitle = "Nothing configured yet",
                invalidSelection = "Invalid selection: {value}",
                partsDeliveryShop = "Parts delivery shop",
                trainingSettings = {
                    description = "Configure training access, enrollment, approvals, and course planning for this job.",
                    label = "Training settings",
                },
                tuningCostProfile = {
                    description = "Configure this job's performance, appearance, wheel, and special option costs. Costs support required item arrays and staged upgrade objects.",
                    label = "Tuning Prices",
                },
            },
            features = {
                tuningFreeCamera = {
                    label = "Free camera in tuning menu",
                    description = "Allow Space to hide the cursor for free camera movement. Escape still closes the menu.",
                },
                tuningCamera = {
                    description = "Automatically focus the selected part. When disabled, keep the normal gameplay camera.",
                    label = "Automatic tuning camera",
                },
                jgMileage = {
                    description = "Use JG Vehicle Mileage while its resource is running. Otherwise use Sky mileage. JG HUD is configured separately.",
                    label = "JG Mileage",
                },
                jgHud = {
                    description = "Show the selected mileage in JG HUD. Works without JG Vehicle Mileage; install the HUD adapter from the README.",
                    label = "JG HUD",
                },
                antiLag = {
                    description = "Enable anti-lag installation and exhaust effects.",
                    label = "Anti-Lag",
                },
                brakeOverheating = {
                    description = "Enable staged brake heat, glowing discs, critical sparks, and short brake fade.",
                    label = "Brake Overheating",
                },
                carryItems = {
                    description = "Require delivered parts to be transported through the workshop.",
                    label = "Physical Parts Handling",
                },
                customHandling = {
                    description = "Enable custom drivetrain and handling tuning.",
                    label = "Custom Handling",
                },
                electronicTuning = {
                    description = "Enable persistent ECU, lighting and driver-assistance tuning options.",
                    label = "Electronic Tuning",
                },
                handlingEditor = {
                    description = "Enable the admin editor and its automatic rules for plates and vehicle models. After disabling, respawn affected vehicles to reset values already applied.",
                    label = "Handling Editor",
                },
                instantTuning = {
                    description = "Allow direct tuning at configured public tuning locations.",
                    label = "Instant Tuning",
                },
                kuv = {
                    description = "Enable technical inspections for mechanics and police. Disabling hides related actions and preserves existing records.",
                    label = "Vehicle technical inspection",
                },
                mileageHud = {
                    description = "Show vehicle mileage information while driving.",
                    label = "Mileage HUD",
                },
                mobileDyno = {
                    description = "Enable the placeable advanced mobile dynamometer, physical control and result displays, fan controller and tablet app.",
                    label = "Mobile Dyno",
                },
                nitro = {
                    description = "Enable nitro installation and vehicle boost use.",
                    label = "Nitro",
                },
                partsDelivery = {
                    description = "Enable workshop parts delivery orders and delivery bays.",
                    label = "Parts Delivery",
                },
                selfServiceOrderNotifications = {
                    description = "Notify on-duty employees when a self-service tuning order is created.",
                    label = "Self-service order notifications",
                },
                stance = {
                    description = "Show Stance adjustments in all tuning menus and enable the Stance Kit item.",
                    label = "Stance",
                },
                stanceWheelSize = {
                    description = "Show, save, and apply wheel size adjustments in Stance.",
                    label = "Stance Wheel Size",
                },
                stanceWheelWidth = {
                    description = "Show, save, and apply wheel width adjustments in Stance.",
                    label = "Stance Wheel Width",
                },
                subscriptions = {
                    description = "Enable workshop subscription terminals, management and customer discounts.",
                    label = "Workshop subscriptions",
                },
                twoStep = {
                    description = "Enable two-step launch control and exhaust effects.",
                    label = "Two-Step",
                },
                vehicleMaintenanceNotifications = {
                    description = "Notify owners when their vehicle reaches the configured maintenance threshold.",
                    label = "Vehicle maintenance notifications",
                },
                vehicleRegistration = {
                    description = "Enable vehicle registration for mechanics and police, independently of technical inspections.",
                    label = "Vehicle registration",
                },
                wheelDamage = {
                    description = "Enable realistic wheel damage and repairs.",
                    label = "Wheel Damage",
                },
                workshopLift = {
                    description = "Enable usable lift points configured in workshops.",
                    label = "Workshop Lift",
                },
            },
            fields = {
                quantity = "Quantity",
            },
            locationDescriptions = {
                vehicle_registry = "Place the point in the workshop inspection bay. Vehicles must be within the configured inspection distance for technical inspections and registration.",
            },
            locationTypes = {
                mobile_dyno_monitor = {
                    description = "Position of the dyno result monitor.",
                    label = "Dyno result monitor",
                },
                mobile_dyno_station = {
                    description = "Position of the mobile dyno station.",
                    label = "Mobile dyno station",
                },
                vehicle_registry = "Vehicle inspection / registration point",
            },
            messages = {
                dispatchEmergencyRequiresDispatch = "Showing this job in the Emergency App requires Dispatch to be enabled. Enable Dispatch or turn off \"Show in Emergency App\" in Dispatch settings.",
                dispatchJobNotCovered = "No enabled dispatch center covers job \"{job}\". In sky_jobs_base/config/config.lua, add \"{job}\" to coveredJobs in the appropriate Config.Dispatch.centers profile, then restart sky_jobs_base. Resetting settings does not change this assignment.",
                invalidDispatchChannels = "Radio channel IDs must be unique and every channel needs a valid label.",
                invalidDispatchDefaultChannel = "The default radio channel does not exist. In Dispatch settings, select an existing channel or \"None\".",
                invalidDispatchKeywords = "Response plans must have unique codes and valid TYPE:COUNT requirements.",
                invalidDispatchPois = "POI IDs, names, and coordinates must be valid and unique.",
                invalidDispatchRadioButtons = "Check Radio function buttons: use each supported button only once and select an action from its list.",
                invalidDispatchRadioFmsKeys = "Check Radio FMS keys: use each key (0-9, * or #) only once and assign an existing status code or leave it unassigned.",
                invalidDispatchReadyStatus = "In Dispatch settings, select a ready status code that is marked as available under Status codes.",
                invalidDispatchReporters = "Known reporter data exceeds the allowed entries or field lengths.",
                invalidDispatchRespondingStatus = "In Dispatch settings, select a responding status code that is marked as unavailable under Status codes.",
                invalidDispatchSettings = "Select an existing available ready status, a non-available responding status, and a valid default channel.",
                invalidDispatchStatusCodes = "FMS codes must be unique and at least one status must be available.",
                invalidDispatchVehicleTypes = "Response-unit type codes must be unique and complete.",
                invalidDispatchVehicles = "Unit IDs and callsigns must be unique and all unit type and station references must exist.",
            },
            settingFieldDescriptions = {
                radialEnabled = "Open mechanic billing from the radial menu.",
                allowTuningInvoices = "Send the tuning basket to the nearest customer. Installation unlocks after full payment.",
                customerRange = "Maximum distance in metres for issuing invoices to nearby customers.",
                allowAnalytics = "Allow billing analytics unless a grade rule overrides it.",
                allowCustomPrices = "Allow mechanics to edit invoice position prices before issuing.",
                allowEstimates = "Allow estimates that customers must accept before payment.",
                allowImmediatePayment = "Allow invoices from this job to be paid directly.",
                allowManualItems = "Allow mechanics to create arbitrary invoice positions.",
                allowPartialPayments = "Allow deposits and multiple payments toward one invoice.",
                analyticsPeriodDays = "Days included in billing analytics.",
                defaultDueDays = "Days until an invoice becomes overdue.",
                depositPercent = "Required deposit percentage after an invoice is issued or an estimate is accepted.",
                enabled = "Allow this job to use mechanic billing.",
                estimateLifetimeHours = "Hours before an unanswered estimate expires.",
                gradeRules = "Invoice limits and actions available to every mechanic grade.",
                maxDiscountPercent = "Largest discount an invoice may receive.",
                maximumInvoiceAmount = "Global maximum total before grade limits.",
                maximumManualItems = "Maximum arbitrary positions per document.",
                maximumReminders = "Maximum reminders allowed per invoice.",
                minimumInvoiceAmount = "Minimum total for estimates and invoices.",
                minimumPartialPayment = "Smallest partial payment, excluding a smaller remaining balance or deposit.",
                reminderFee = "Fee added by every valid reminder.",
                reminderGraceDays = "Days overdue before the first reminder is allowed.",
                taxPercent = "Tax added after discounts.",
            },
            settingFields = {
                radialEnabled = "Invoice radial action",
                allowTuningInvoices = "Invoice tuning customers",
                customerRange = "Customer distance",
                allowAnalytics = "Accounting analytics",
                allowCancellation = "Cancellation",
                allowCustomPrices = "Allow custom prices",
                allowEstimates = "Allow estimates",
                allowImmediatePayment = "Allow immediate payment",
                allowManualItems = "Allow own positions",
                allowPartialPayments = "Allow partial payments",
                allowReminders = "Reminders",
                amount = "Amount",
                analyticsPeriodDays = "Analytics period",
                bone = "Bone",
                category = "Category",
                classId = "Class ID",
                defaultDueDays = "Payment term (days)",
                depositPercent = "Deposit percent",
                difficulty = "Difficulty",
                enabled = "Enabled",
                estimateLifetimeHours = "Estimate lifetime (hours)",
                flow = "Install flow",
                grade = "Grade",
                gradeRules = "Grade rules",
                item = "Item",
                key = "Key",
                kilometersToZero = "Kilometers to zero",
                label = "Label",
                laborFee = "Labor cost",
                laborMultiplier = "Labor multiplier",
                marginAdjustmentPercent = "Margin adjustment",
                marginPercent = "Margin %",
                maxDiscountPercent = "Maximum discount",
                maximumInvoiceAmount = "Maximum invoice",
                maximumManualItems = "Maximum own positions",
                maximumPrice = "Maximum",
                maximumReminders = "Maximum reminders",
                minimumInvoiceAmount = "Minimum invoice",
                minimumPartialPayment = "Minimum partial payment",
                minimumPrice = "Minimum",
                multiplier = "Multiplier",
                name = "Item name",
                partKey = "Part key",
                price = "Price",
                priceType = "Price type",
                prop = "Prop",
                reason = "Reason",
                reminderFee = "Reminder fee",
                reminderGraceDays = "Reminder grace period",
                removeAfterUse = "Consume item",
                repair = "Repair with kit",
                repairItem = "Repair item",
                rx = "Rot X",
                ry = "Rot Y",
                rz = "Rot Z",
                supplierSharePercent = "Supplier %",
                taxPercent = "Invoice tax",
                transport = "Transport",
                x = "X",
                y = "Y",
                z = "Z",
                upgrade = "Upgrade",
                maximumDiscountPercent = "Maximum discount",
            },
            settingGroups = {
                antiExploit = {
                    label = "Anti Exploit",
                },
                coach = {
                    label = "Telemetry Coach",
                },
                cooldownMultipliers = {
                    label = "Cooling multipliers",
                },
                crashFalloff = {
                    label = "Crash Falloff",
                },
                criticalEngine = {
                    label = "Broken Engine",
                },
                deformation = {
                    label = "Deformation",
                },
                diagnostics = {
                    label = "Diagnostics",
                },
                fade = {
                    label = "Brake fade",
                },
                features = {
                    label = "Features",
                },
                format = {
                    label = "Format",
                },
                frontalImpact = {
                    label = "Severe Front Impact",
                },
                general = {
                    label = "General",
                },
                heatMultipliers = {
                    label = "Heat multipliers",
                },
                illegalMarket = {
                    label = "Illegal Market",
                },
                integration = {
                    label = "Integration",
                },
                items = {
                    label = "Items",
                },
                keybinds = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Keybinds",
                },
                lifetime = {
                    label = "Lifetime",
                },
                limits = {
                    label = "Storage Limits",
                },
                repairRestore = {
                    label = "Repair Restore",
                },
                risk = {
                    label = "Risk",
                },
                rules = {
                    label = "Rules",
                },
                safety = {
                    label = "Validation & Safety",
                },
                stages = {
                    label = "Overheating stages",
                },
                tyreRepair = {
                    label = "Tyre Repair",
                },
                visuals = {
                    label = "Visual effects",
                },
            },
            settingSections = {
                electronicTuning = "ECU Engine Software",
                advancedPricing = "Advanced Pricing",
                brakeOverheating = "Brake Overheating",
                carryItems = "Carry Items",
                fakePlates = "Fake Plates",
                firejobVehicleFires = "Vehicle Fires",
                general = "General",
                handlingEditor = "Handling Editor",
                instantTuning = "Instant Tuning",
                maintenanceNotifications = "Maintenance Notifications",
                mileageHud = "Mileage HUD",
                mobileDyno = "Mobile Dyno",
                oilLeaks = "Vehicle Fluid Leaks",
                partsTheft = "Parts Theft",
                subscriptions = "Subscriptions",
                tuning = "Tuning",
                vehicleCare = "Vehicle Care",
                vehicleRegistry = "Vehicle certificates",
                wear = "Wear",
                wheelDamage = "Wheel Damage",
            },
            settingSubsectionGroups = {
                handlingAdditional = "Additional",
                handlingAir = "Air",
                handlingGeneral = "General",
                handlingRoad = "Road",
                handlingWater = "Water",
            },
            settingSubsections = {
                mechanicHotkeys = "Hotkeys",
                database = "Database",
                handlingEditorGeneral = "Editor settings",
                handlingMaximumCBikeHandlingData = "Motorcycle",
                handlingMaximumCBoatHandlingData = "Boat",
                handlingMaximumCCarHandlingData = "Car",
                handlingMaximumCFlyingHandlingData = "Aircraft",
                handlingMaximumCHandlingData = "Vehicle base",
                handlingMaximumCSeaPlaneHandlingData = "Seaplane",
                handlingMaximumCSpecialFlightHandlingData = "Special flight",
                handlingMaximumCSubmarineHandlingData = "Submarine",
                handlingMaximumCTrailerHandlingData = "Trailer",
                handlingMaximumCVehicleWeaponHandlingData = "Vehicle weapons",
                keybinds = "Keybinds",
                operation = "Operation",
                placementRules = "Placement rules",
                testFlow = "Test flow",
                tuning = "Instant tuning options",
            },
            settingValues = {
                air_filter = "Air Filter",
                brake_fluid = "Brake Fluid",
                brake_pads = "Brake Pads",
                catalytic_converter = "Catalytic Converter",
                clutch = "Clutch",
                coolant = "Coolant",
                engine_oil = "Engine Oil",
                inverter = "Power Inverter",
                spark_plugs = "Spark Plugs",
                suspension = "Suspension",
                traction_battery = "Traction Battery",
                transmission_fluid = "Transmission Fluid",
                tyres = "Tyres",
                vehicleClass_0 = "Compacts",
                vehicleClass_1 = "Sedans",
                vehicleClass_10 = "Industrial",
                vehicleClass_11 = "Utility",
                vehicleClass_12 = "Vans",
                vehicleClass_13 = "Cycles",
                vehicleClass_14 = "Boats",
                vehicleClass_15 = "Helicopters",
                vehicleClass_16 = "Planes",
                vehicleClass_17 = "Service",
                vehicleClass_18 = "Emergency",
                vehicleClass_19 = "Military",
                vehicleClass_2 = "SUVs",
                vehicleClass_20 = "Commercial",
                vehicleClass_21 = "Trains",
                vehicleClass_22 = "Open Wheel",
                vehicleClass_3 = "Coupes",
                vehicleClass_4 = "Muscle",
                vehicleClass_5 = "Sports Classics",
                vehicleClass_6 = "Sports",
                vehicleClass_7 = "Super",
                vehicleClass_8 = "Motorcycles",
                vehicleClass_9 = "Off-road",
            },
            settings = {
                vehiclePriceSource = {
                    label = "Vehicle price source",
                    description = "Automatic: ESX SQL; QBCore/Qbox vehicle catalog. Database: configured SQL table on every framework.",
                    options = {
                        auto = "Automatic (framework)",
                        database = "Database",
                    },
                },
                vehiclePriceTable = {
                    label = "Vehicle price table",
                    description = "Table with purchase prices, e.g. dealership_vehicles (JG).",
                },
                vehiclePriceModelColumn = {
                    label = "Spawn name column",
                    description = "Spawn-name column, e.g. spawn_code (JG), not the display name.",
                },
                vehiclePricePriceColumn = {
                    label = "Price column",
                    description = "Numeric purchase-price column, e.g. price.",
                },
                vehiclePriceHashColumn = {
                    label = "Model hash column (optional)",
                    description = "Optional numeric hash column, e.g. hashkey (JG). Leave empty to hash spawn names.",
                },
                addRevenueToSociety = {
                    description = "Deposit paid tuning order money into the tuning job society account.",
                    label = "Deposit revenue to society",
                },
                advancedPricingAlwaysAvailableItemCategories = {
                    description = "Parts delivery shop categories that remain freely purchasable while advanced pricing is enabled. Matching ignores casing and whitespace.",
                    itemLabel = "Category",
                    label = "Always-available categories",
                },
                advancedPricingAlwaysAvailableItemsEnabled = {
                    description = "Keep configured shop items from the selected categories available without a tuning order and price them through the dynamic supplier system.",
                    label = "Always-available shop items",
                },
                advancedPricingAnalyticsPeriodDays = {
                    description = "Number of days shown in the tablet profit analysis.",
                    label = "Analytics period",
                },
                advancedPricingCategoryRules = {
                    description = "Supplier share, margin, labor and price boundaries by tuning category.",
                    label = "Category rules",
                },
                advancedPricingDefaultMarginPercent = {
                    description = "Default mechanic margin before class and grade adjustments.",
                    label = "Default margin",
                },
                advancedPricingDifficultyRules = {
                    description = "Additional labor cost for each tuning difficulty.",
                    label = "Difficulty rules",
                },
                advancedPricingEnabled = {
                    description = "Recalculate tuning prices on the server and, when Parts Delivery is enabled, require Dynasty parts to be purchased for their specific tuning order.",
                    label = "Enable advanced pricing",
                },
                advancedPricingInventoryBaseStock = {
                    description = "Normal virtual stock for every supplier item.",
                    label = "Base stock",
                },
                advancedPricingInventoryDemandDecayPerDay = {
                    description = "Demand points removed per elapsed day.",
                    label = "Daily demand decay",
                },
                advancedPricingInventoryDemandMarkupPerUnitPercent = {
                    description = "Supplier markup added for every demand point.",
                    label = "Demand markup per unit",
                },
                advancedPricingInventoryEnabled = {
                    description = "Raise supplier prices when virtual stock is low or demand is high.",
                    label = "Dynamic supplier stock",
                },
                advancedPricingInventoryLowStockMarkupPercent = {
                    description = "Maximum supplier markup caused by low stock.",
                    label = "Low-stock markup",
                },
                advancedPricingInventoryLowStockThreshold = {
                    description = "Stock level below which scarcity pricing starts.",
                    label = "Low-stock threshold",
                },
                advancedPricingInventoryMaximumDemandMarkupPercent = {
                    description = "Upper boundary for the demand markup.",
                    label = "Maximum demand markup",
                },
                advancedPricingInventoryRestockPerDay = {
                    description = "Virtual units replenished per elapsed day.",
                    label = "Daily restock",
                },
                advancedPricingMaximumDiscountPercent = {
                    description = "Global discount ceiling for mechanic invoices.",
                    label = "Maximum discount",
                },
                advancedPricingMaximumMarginPercent = {
                    description = "Highest permitted mechanic margin.",
                    label = "Maximum margin",
                },
                advancedPricingMaximumRetailPrice = {
                    description = "Global upper price boundary for a tuning part.",
                    label = "Maximum retail price",
                },
                advancedPricingMechanicGradeRules = {
                    description = "Markup, labor and discount boundaries by mechanic grade.",
                    label = "Mechanic grade rules",
                },
                advancedPricingMinimumMarginPercent = {
                    description = "Lowest permitted mechanic margin.",
                    label = "Minimum margin",
                },
                advancedPricingMinimumRetailPrice = {
                    description = "Global lower price boundary for a tuning part.",
                    label = "Minimum retail price",
                },
                advancedPricingPreviewCompactValue = {
                    description = "Vehicle value used for the compact example.",
                    label = "Compact preview value",
                },
                advancedPricingPreviewCostPercent = {
                    description = "Example tuning cost percentage used by the live preview.",
                    label = "Preview tuning rate",
                },
                advancedPricingPreviewSportsValue = {
                    description = "Vehicle value used for the sports example.",
                    label = "Sports preview value",
                },
                advancedPricingPreviewSuperValue = {
                    description = "Vehicle value used for the supercar example.",
                    label = "Super preview value",
                },
                advancedPricingQuoteLifetimeMinutes = {
                    description = "Minutes before an unpaid price quote is recalculated.",
                    label = "Quote lifetime",
                },
                advancedPricingReturnRefundPercent = {
                    description = "Percentage refunded for a procured order-bound part.",
                    label = "Return refund",
                },
                advancedPricingRoundingStep = {
                    description = "Round each Dynasty procurement line to this money step.",
                    label = "Supplier rounding step",
                },
                advancedPricingSupplierSharePercent = {
                    description = "Percentage of the customer part price charged by Dynasty Auto Supply.",
                    label = "Supplier share",
                },
                advancedPricingTaxPercent = {
                    description = "Tax percentage stored separately in pricing accounting.",
                    label = "Tax",
                },
                advancedPricingVehicleClassRules = {
                    description = "Margin and labor adjustments by GTA vehicle class.",
                    label = "Vehicle class rules",
                },
                brakeOverheatingCooldownBrakeUpgradeMultipliers = {
                    label = "Brake upgrade cooldown multipliers",
                },
                brakeOverheatingCooldownClassMultipliers = {
                    label = "Vehicle class cooldown multipliers",
                },
                brakeOverheatingCoolingDelayMs = {
                    description = "Delay in milliseconds after braking before active cooling starts.",
                    label = "Cooling delay",
                },
                brakeOverheatingCoolingPerSecond = {
                    description = "Heat removed per second while the brake is not being used.",
                    label = "Cooling rate",
                },
                brakeOverheatingCriticalThreshold = {
                    description = "Heat level at which sparks and short brake fade can start.",
                    label = "Critical threshold",
                },
                brakeOverheatingFadeChancePerSecond = {
                    description = "Chance from 0 to 1 for a short brake cut-out while braking at critical heat.",
                    label = "Fade chance per second",
                },
                brakeOverheatingFadeCooldownMs = {
                    label = "Fade cooldown",
                },
                brakeOverheatingFadeMaximumDurationMs = {
                    label = "Maximum fade duration",
                },
                brakeOverheatingFadeMinimumDurationMs = {
                    label = "Minimum fade duration",
                },
                brakeOverheatingHeatBrakeUpgradeMultipliers = {
                    label = "Brake upgrade heat multipliers",
                },
                brakeOverheatingHeatClassMultipliers = {
                    label = "Vehicle class heat multipliers",
                },
                brakeOverheatingHeatGainPerSecond = {
                    description = "Base heat gained per second while braking at reference speed.",
                    label = "Heat gain",
                },
                brakeOverheatingHotThreshold = {
                    label = "Hot threshold",
                },
                brakeOverheatingMinimumSpeedKmh = {
                    description = "Minimum vehicle speed in km/h before braking creates heat.",
                    label = "Minimum braking speed",
                },
                brakeOverheatingReferenceSpeedKmh = {
                    description = "Speed in km/h at which the configured base heat gain is applied.",
                    label = "Reference speed",
                },
                brakeOverheatingSparkMaximumIntervalMs = {
                    label = "Maximum spark interval",
                },
                brakeOverheatingSparkMinimumIntervalMs = {
                    label = "Minimum spark interval",
                },
                brakeOverheatingVisualDistance = {
                    description = "Maximum distance in metres for glow and spark rendering.",
                    label = "Visual distance",
                },
                brakeOverheatingWarmThreshold = {
                    label = "Warm threshold",
                },
                carryItems = {
                    description = "Delivered parts that should become physical carried props.",
                    fields = {
                        transport = {
                            options = {
                                engine_lift = "Engine Hoist",
                                forklift = "Forklift",
                                hand = "Hand",
                            },
                        },
                    },
                    itemLabel = "Carry item",
                    label = "Carry items",
                },
                ecuEngineTorqueStage1 = {
                    description = "1.00 adds no boost; 1.10 adds 10% torque. Applies to vehicles with this ECU stage.",
                    label = "Stage 1 torque multiplier",
                },
                ecuEngineTorqueStage2 = {
                    description = "1.00 adds no boost; 1.10 adds 10% torque. Applies to vehicles with this ECU stage.",
                    label = "Stage 2 torque multiplier",
                },
                ecuEngineTorqueStage3 = {
                    description = "1.00 adds no boost; 1.10 adds 10% torque. Applies to vehicles with this ECU stage.",
                    label = "Stage 3 torque multiplier",
                },
                ecuEngineTorqueStage4 = {
                    description = "1.00 adds no boost; 1.10 adds 10% torque. Applies to vehicles with this ECU stage.",
                    label = "Stage 4 torque multiplier",
                },
                fakePlatesAudit = {
                    label = "Audit log",
                },
                fakePlatesBlacklist = {
                    description = "Blocked words or fragments that cannot appear in fake plates.",
                    label = "Blacklist",
                },
                fakePlatesBlankPlateItem = {
                    description = "Craft/shop material used for fake plate economy loops.",
                    label = "Blank plate item",
                },
                fakePlatesCooldownMinutes = {
                    label = "Cooldown minutes",
                },
                fakePlatesCrashFalloffChance = {
                    label = "Falloff chance",
                },
                fakePlatesCrashFalloffEnabled = {
                    label = "Crash falloff enabled",
                },
                fakePlatesCrashFalloffMinSpeedKmh = {
                    label = "Minimum crash speed",
                },
                fakePlatesEnabled = {
                    description = "Allow players to use fake plate kits on vehicles.",
                    label = "Enable fake plates",
                },
                fakePlatesExpireMinutes = {
                    description = "0 keeps fake plates active until reset or restart handling removes them.",
                    label = "Expire minutes",
                },
                fakePlatesExpireOnRestart = {
                    label = "Expire on restart",
                },
                fakePlatesIllegalMarketAccount = {
                    label = "Payment account",
                },
                fakePlatesIllegalMarketEnabled = {
                    label = "Illegal market enabled",
                },
                fakePlatesIllegalMarketPrice = {
                    label = "Illegal market price",
                },
                fakePlatesIllegalMarketRiskMultiplier = {
                    label = "Risk multiplier",
                },
                fakePlatesInstallDurationMs = {
                    label = "Install duration ms",
                },
                fakePlatesItem = {
                    description = "One-use item that starts the fake plate installation flow.",
                    label = "Fake plate kit item",
                },
                fakePlatesMaxLength = {
                    label = "Maximum length",
                },
                fakePlatesMaxVehicleDistance = {
                    label = "Vehicle distance",
                },
                fakePlatesMinLength = {
                    label = "Minimum length",
                },
                fakePlatesPattern = {
                    description = "Lua pattern used to validate fake plate text, for example ^[A-Z0-9]+$.",
                    label = "Lua pattern",
                },
                fakePlatesPlateInstallDistance = {
                    label = "Plate position distance",
                },
                fakePlatesPreventDuplicateDisplayPlates = {
                    label = "Block duplicate active fake plates",
                },
                fakePlatesPrinterItem = {
                    description = "Craft/shop tool used for fake plate economy loops.",
                    label = "Plate printer item",
                },
                fakePlatesRequireEngineOff = {
                    label = "Engine must be off",
                },
                fakePlatesRequireOwnerOrKeys = {
                    description = "Use Config.Functions.CanApplyFakePlate before allowing installation.",
                    label = "Require owner or keys",
                },
                fakePlatesRequireStopped = {
                    label = "Vehicle must be stopped",
                },
                fakePlatesResetOnGarageStore = {
                    description = "Reserved for garage integrations that call the reset event/export.",
                    label = "Reset on garage store",
                },
                fakePlatesRiskCharacters = {
                    label = "Typo characters",
                },
                fakePlatesRiskEnabled = {
                    label = "Risk typos enabled",
                },
                fakePlatesRiskTypoChance = {
                    label = "Typo chance",
                },
                fallbackVehicleValue = {
                    description = "Value used when no vehicle price can be resolved.",
                    label = "Fallback vehicle value",
                },
                firejobVehicleFiresCriticalChance = {
                    description = "Chance from 0 to 1 after the engine remains critical.",
                    label = "Critical engine fire chance",
                },
                firejobVehicleFiresCriticalCooldownSeconds = {
                    description = "Seconds before another broken-engine fire can trigger.",
                    label = "Critical engine cooldown",
                },
                firejobVehicleFiresCriticalDelayMs = {
                    description = "Delay in milliseconds before a broken engine can ignite.",
                    label = "Critical engine delay ms",
                },
                firejobVehicleFiresCriticalEnabled = {
                    description = "Allow critically damaged engines to start a Firejob vehicle fire after a delay.",
                    label = "Ignite broken engines",
                },
                firejobVehicleFiresCriticalSmokeDensity = {
                    description = "Smoke density used for broken-engine fire requests.",
                    label = "Critical engine smoke density",
                },
                firejobVehicleFiresEnabled = {
                    description = "Allow Mechanicjob damage systems to request vehicle fires from Firejob.",
                    label = "Enable Firejob vehicle fires",
                },
                firejobVehicleFiresForwardMotionRatio = {
                    description = "Required forward movement ratio from 0 to 1.",
                    label = "Forward motion ratio",
                },
                firejobVehicleFiresImpactChance = {
                    description = "Chance from 0 to 1 that a qualifying impact starts a fire.",
                    label = "Impact fire chance",
                },
                firejobVehicleFiresImpactCooldownSeconds = {
                    description = "Seconds before another impact fire can trigger.",
                    label = "Impact fire cooldown",
                },
                firejobVehicleFiresImpactEnabled = {
                    description = "Allow strong frontal accidents to request a Firejob vehicle fire.",
                    label = "Ignite after severe crashes",
                },
                firejobVehicleFiresImpactSmokeDensity = {
                    description = "Smoke density used for crash-triggered fire requests.",
                    label = "Impact smoke density",
                },
                firejobVehicleFiresIntegrationMode = {
                    description = "Automatic uses the configured Firejob resource; Disabled prevents Mechanicjob from creating fires.",
                    label = "Integration mode",
                    options = {
                        automatic = "Automatic",
                        disabled = "Disabled",
                    },
                },
                firejobVehicleFiresMinBodyHealthLoss = {
                    description = "Minimum body health lost during the impact.",
                    label = "Minimum body damage",
                },
                firejobVehicleFiresMinEngineHealthLoss = {
                    description = "Minimum engine health lost during the impact.",
                    label = "Minimum engine damage",
                },
                firejobVehicleFiresMinFrontDeformation = {
                    description = "Use 0 to disable this deformation check.",
                    label = "Minimum front deformation",
                },
                firejobVehicleFiresMinImpactSpeedKmh = {
                    description = "Minimum pre-impact speed in km/h.",
                    label = "Minimum impact speed",
                },
                firejobVehicleFiresMinSpeedDropKmh = {
                    description = "Required speed loss in km/h during the impact.",
                    label = "Minimum speed loss",
                },
                firejobVehicleFiresResource = {
                    description = "Resource that receives vehicle fire requests.",
                    label = "Firejob resource",
                },
                firejobVehicleFiresServerEvent = {
                    description = "Internal server event used by the mechanic client to request a Firejob vehicle fire.",
                    label = "Mechanic server event",
                },
                freeVehicles = {
                    description = "Vehicle spawn models that receive free tuning orders.",
                    itemLabel = "Vehicle model",
                    label = "Free tuning vehicles",
                },
                handlingEditorBlockCriticalValidation = {
                    description = "Prevent Apply while a critical handling conflict exists.",
                    label = "Block critical findings",
                },
                handlingEditorCoachMinimumBrakeDeceleration = {
                    description = "Expected maximum deceleration in m/s² for a completed braking test.",
                    label = "Minimum brake deceleration",
                },
                handlingEditorCoachMinimumSamples = {
                    description = "Measured samples required before Telemetry Coach evaluates a run.",
                    label = "Minimum samples",
                },
                handlingEditorCoachWheelSlipWarningKmh = {
                    description = "Measured wheel-slip speed in km/h at which traction loss is reported.",
                    label = "Wheel-slip warning",
                },
                handlingEditorDefaultTab = {
                    description = "Page selected whenever the standalone Handling Editor opens.",
                    label = "Start page",
                    options = {
                        advanced = "Advanced",
                        export = "Export",
                        flags = "Flags",
                        fleet = "Fleet",
                        inspector = "Layers",
                        profiles = "Profiles",
                        simple = "Simple",
                        telemetry = "Telemetry",
                    },
                },
                handlingEditorFieldDocumentationEnabled = {
                    description = "Provide effect, reference range, symptoms, related fields and live support for every handling value.",
                    label = "Field documentation",
                },
                handlingEditorFieldMaximum = {
                    description = "Hard maximum accepted by the editor for this handling field.",
                },
                handlingEditorFlagSearchEnabled = {
                    description = "Search and filter flag names, effects, bit positions and hexadecimal masks.",
                    label = "Flag search",
                },
                handlingEditorFleetManagerEnabled = {
                    description = "Search, inspect, promote and restore model and plate handling rules.",
                    label = "Fleet Manager",
                },
                handlingEditorFocusKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Return to handling editor",
                },
                handlingEditorLayerInspectorEnabled = {
                    description = "Show the vehicle base, installed custom tuning, model rule, plate rule and current editor draft for every field.",
                    label = "Layer inspector",
                },
                handlingEditorMaxFleetResults = {
                    description = "Maximum model and plate rules loaded into Fleet Manager.",
                    label = "Fleet result limit",
                },
                handlingEditorMaxProfileRevisions = {
                    description = "Maximum number of revisions retained for each profile.",
                    label = "Profile revisions",
                },
                handlingEditorMaxWorkspacesPerAdmin = {
                    description = "Maximum named workspaces retained for each administrator.",
                    label = "Personal workspaces",
                },
                handlingEditorPayloadWarningBytes = {
                    description = "Encoded bytes after which an editor request, response or snapshot is reported as large.",
                    label = "Large-payload threshold",
                },
                handlingEditorPerformanceChecksEnabled = {
                    description = "Measure editor operations and warn through Sky.Debug when configured limits are exceeded.",
                    label = "Performance checks",
                },
                handlingEditorPerformanceSummaryIntervalMs = {
                    description = "Milliseconds between aggregated operation summaries while detailed debug logging is enabled.",
                    label = "Summary interval",
                },
                handlingEditorPerformanceWarningMs = {
                    description = "Milliseconds after which a measured Handling Editor operation is reported as slow.",
                    label = "Slow-operation threshold",
                },
                handlingEditorProfileVersioningEnabled = {
                    description = "Create an auditable revision whenever a shared profile is updated or restored.",
                    label = "Profile versioning",
                },
                handlingEditorSliderMaximumDeviationPercent = {
                    description = "Maximum percentage a numeric slider may move above or below the captured vehicle basis. Direct entry and XML import remain lossless. A non-default field maximum overrides the upper slider endpoint.",
                    label = "Maximum slider deviation",
                },
                handlingEditorTelemetryCoachEnabled = {
                    description = "Create transparent rule-based recommendations from measured road-test data.",
                    label = "Telemetry Coach",
                },
                handlingEditorValidatorEnabled = {
                    description = "Detect unsafe or contradictory combinations before handling is applied.",
                    label = "Handling validator",
                },
                handlingEditorWorkspacesEnabled = {
                    description = "Allow administrators to keep named private editor drafts.",
                    label = "Personal workspaces",
                },
                instantTuningAllowedJobs = {
                    description = "Optional global allow-list. Leave empty to allow everyone unless mechanic-only is enabled.",
                    itemLabel = "Job name",
                    label = "Allowed jobs",
                },
                instantTuningBlipColor = {
                    description = "GTA blip color id.",
                    label = "Blip color",
                },
                instantTuningBlipEnabled = {
                    description = "Show map blips for instant tuning locations.",
                    label = "Blip enabled",
                },
                instantTuningBlipName = {
                    description = "Map blip name.",
                    label = "Blip name",
                },
                instantTuningBlipSprite = {
                    description = "GTA blip sprite id.",
                    label = "Blip sprite",
                },
                instantTuningForceMarkerInteraction = {
                    description = "Use marker-style E interaction even when target support is enabled.",
                    label = "Force marker interaction",
                },
                instantTuningInteractionDistance = {
                    description = "Default distance for using instant tuning points.",
                    label = "Interaction distance",
                },
                instantTuningLabel = {
                    description = "Default text shown at instant tuning points.",
                    label = "Default label",
                },
                instantTuningLocations = {
                    description = "Instant tuning points. Use 0 distance to inherit the default interaction distance.",
                    itemLabel = "Locations",
                    label = "Locations",
                },
                instantTuningMarkerEnabled = {
                    description = "Draw a world marker at instant tuning locations.",
                    label = "Marker enabled",
                },
                instantTuningMarkerType = {
                    description = "GTA marker type used for instant tuning locations.",
                    label = "Marker type",
                },
                instantTuningMechanicOnly = {
                    description = "Restrict all instant tuning locations to configured mechanic jobs.",
                    label = "Mechanic only",
                },
                instantTuningRepairEnabled = {
                    label = "Vehicle repair",
                    description = "Offer vehicle repair at instant tuning locations.",
                },
                instantTuningRepairPrice = {
                    label = "Repair price",
                    description = "Fixed repair price, without the tuning price multiplier.",
                },
                instantTuningWashEnabled = {
                    label = "Vehicle wash",
                    description = "Offer vehicle washing at instant tuning locations.",
                },
                instantTuningWashPrice = {
                    label = "Wash price",
                    description = "Fixed wash price, without the tuning price multiplier.",
                },
                instantTuningPriceMultiplier = {
                    description = "Multiplier applied to instant tuning prices.",
                    label = "Price multiplier",
                },
                instantTuningProfile = {
                    description = "Configure which tuning options are available at instant tuning points.",
                    label = "Instant Tuning Options",
                },
                maintenanceNotificationsCooldownMinutes = {
                    description = "Minimum minutes before the same vehicle can trigger another maintenance reminder.",
                    label = "Notification cooldown",
                },
                maintenanceNotificationsEnabled = {
                    description = "Notify vehicle owners when a wear part reaches the maintenance threshold.",
                    label = "Enabled",
                },
                maintenanceNotificationsThreshold = {
                    description = "Wear percentage at or below which maintenance is considered due.",
                    label = "Due threshold",
                },
                mechanicCatalyticConverterCATALYTICACTIONCONTROL = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Catalytic converter theft · E",
                },
                mechanicCatalyticConverterCATALYTICCANCELCONTROL = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Catalytic converter theft · X",
                },
                mechanicDynoControl172 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Dyno · UP",
                },
                mechanicDynoControl173 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Dyno · DOWN",
                },
                mechanicDynoControl174 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Dyno · LEFT",
                },
                mechanicDynoControl175 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Dyno · RIGHT",
                },
                mechanicDynoControl177 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Dyno · BACK",
                },
                mechanicDynoControl38 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Dyno · E",
                },
                mechanicDynoControl45 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Dyno · R",
                },
                mechanicDynoControl47 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Dyno · G",
                },
                mechanicSprayPaintControl200 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Spray painting · ESCAPE",
                },
                mechanicSprayPaintControl202 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Spray painting · ESCAPE",
                },
                mechanicVehicleCareControl200 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Vehicle care · ESCAPE",
                },
                mechanicVehicleCareControl202 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Vehicle care · ESCAPE",
                },
                mechanicVehiclePushINPUTCONTEXT = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Push vehicle · E",
                },
                mechanicVehiclePushINPUTMOVEDOWN = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Push vehicle · S",
                },
                mechanicVehiclePushINPUTMOVELEFT = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Push vehicle · A",
                },
                mechanicVehiclePushINPUTMOVERIGHT = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Push vehicle · D",
                },
                mechanicVehiclePushINPUTMOVEUP = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Push vehicle · W",
                },
                mechanicVehiclePushINPUTSPRINT = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Push vehicle · LSHIFT",
                },
                mechanicWheelChangeControl200 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Wheel change · ESCAPE",
                },
                mechanicWheelChangeControl202 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Wheel change · ESCAPE",
                },
                mechanicWheelChangeControl22 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Wheel change · SPACE",
                },
                mechanicWheelTheftWHEELTHEFTACTIONCONTROL = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Wheel theft · E",
                },
                mechanicWheelTheftWHEELTHEFTCANCELCONTROL = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Wheel theft · X",
                },
                mileageHudDigits = {
                    description = "Number of digits shown in the mileage HUD.",
                    label = "Digits",
                },
                mileageHudPosition = {
                    description = "Drag the mileage HUD preview to the desired screen position.",
                    label = "Position",
                },
                mobileDynoConsumeItem = {
                    description = "Remove one item after successful placement.",
                    label = "Consume item",
                },
                mobileDynoCooldownMs = {
                    label = "Cooldown duration",
                },
                mobileDynoCountdownMs = {
                    label = "Start countdown",
                },
                mobileDynoDuiDistance = {
                    label = "Panel render distance",
                },
                mobileDynoFanInteractionDistance = {
                    description = "Distance in metres for using the physical switch between the cooling fans.",
                    label = "Fan-controller distance",
                },
                mobileDynoFullLoadDurationMs = {
                    description = "Milliseconds spent at sustained full load in profiles that include a full-load stage.",
                    label = "Full-load duration",
                },
                mobileDynoHistoryLimit = {
                    label = "History limit",
                },
                mobileDynoInteractionDistance = {
                    label = "Panel interaction distance",
                },
                mobileDynoItemUseEnabled = {
                    description = "Allow placement by using dyno and monitor items.",
                    label = "Item placement",
                },
                mobileDynoMaxActiveSessions = {
                    label = "Active session limit",
                },
                mobileDynoMaxVehicleDistance = {
                    label = "Vehicle capture distance",
                },
                mobileDynoMonitorItem = {
                    description = "Inventory item for placing a result monitor.",
                    label = "Monitor item",
                },
                mobileDynoPersistItems = {
                    description = "Save new item placements across server restarts.",
                    label = "Save placements",
                },
                mobileDynoPickupDistance = {
                    description = "Maximum distance in metres for picking up equipment.",
                    label = "Pickup distance",
                },
                mobileDynoPlacementMaxHeightSpread = {
                    description = "Maximum ground-height variation in metres accepted across all dyno footprint probes.",
                    label = "Maximum height variation",
                },
                mobileDynoPlacementMaxSlopeDegrees = {
                    description = "Maximum ground slope in degrees accepted across the dyno footprint.",
                    label = "Maximum placement slope",
                },
                mobileDynoRequireOnDuty = {
                    description = "Require mechanics to be on duty for placement and operation.",
                    label = "Require duty",
                },
                mobileDynoResultDuiDistance = {
                    description = "Maximum distance in metres at which the separate result monitor is rendered.",
                    label = "Result display distance",
                },
                mobileDynoReturnItem = {
                    description = "Return a consumed item when picking up the equipment.",
                    label = "Return item",
                },
                mobileDynoStationItem = {
                    description = "Inventory item for placing a dyno.",
                    label = "Dyno item",
                },
                mobileDynoTabletDistance = {
                    description = "Maximum distance in metres from the dyno for tablet control and active tests.",
                    label = "Tablet operating distance",
                },
                nitroActivationKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Hold nitro",
                },
                oilLeaksCooldownSeconds = {
                    description = "Seconds before another impact leak can trigger.",
                    label = "Impact cooldown",
                },
                oilLeaksEnabled = {
                    description = "Allow damaged combustion vehicles to leave fluid behind while driving.",
                    label = "Enable fluid leaks",
                },
                oilLeaksEngineOilChance = {
                    description = "Normal leak chance from 0 to 1.",
                    label = "Engine oil chance",
                },
                oilLeaksEngineOilCriticalChance = {
                    description = "Critical leak chance from 0 to 1.",
                    label = "Critical engine oil chance",
                },
                oilLeaksEngineOilCriticalThreshold = {
                    description = "Engine oil condition at or below which the critical chance is used.",
                    label = "Critical engine oil threshold",
                },
                oilLeaksEngineOilThreshold = {
                    description = "Engine oil condition at or below which a leak can start.",
                    label = "Engine oil threshold",
                },
                oilLeaksForwardMotionRatio = {
                    description = "Required forward movement ratio from 0 to 1.",
                    label = "Forward motion ratio",
                },
                oilLeaksFrontalImpactEnabled = {
                    description = "Allow severe frontal impacts to start a temporary engine fluid leak.",
                    label = "Frontal impact leaks",
                },
                oilLeaksImpactChance = {
                    description = "Chance from 0 to 1 that a qualifying impact starts a leak.",
                    label = "Impact leak chance",
                },
                oilLeaksImpactRadius = {
                    description = "Radius of the initial fluid point created by an impact.",
                    label = "Impact spill radius",
                },
                oilLeaksIntervalSeconds = {
                    description = "Minimum seconds between trail points.",
                    label = "Trail interval",
                },
                oilLeaksLeakDurationSeconds = {
                    description = "Seconds a leak continues after a qualifying impact.",
                    label = "Impact leak duration",
                },
                oilLeaksMinBodyHealthLoss = {
                    description = "Minimum body health lost during the impact.",
                    label = "Minimum body damage",
                },
                oilLeaksMinDistance = {
                    description = "Minimum travelled distance between trail points.",
                    label = "Trail distance",
                },
                oilLeaksMinEngineHealthLoss = {
                    description = "Minimum engine health lost during the impact.",
                    label = "Minimum engine damage",
                },
                oilLeaksMinFrontDeformation = {
                    description = "Required front deformation. Use 0 to disable this check.",
                    label = "Minimum front deformation",
                },
                oilLeaksMinImpactSpeedKmh = {
                    description = "Minimum pre-impact speed in km/h.",
                    label = "Minimum impact speed",
                },
                oilLeaksMinSpeedDropKmh = {
                    description = "Required speed loss in km/h during the impact.",
                    label = "Minimum speed loss",
                },
                oilLeaksMinSpeedKmh = {
                    description = "Minimum vehicle speed in km/h before a fluid leak can create a trail.",
                    label = "Minimum speed",
                },
                oilLeaksRadius = {
                    description = "Radius of regular vehicle fluid trail points.",
                    label = "Trail radius",
                },
                oilLeaksTransmissionFluidChance = {
                    description = "Normal leak chance from 0 to 1.",
                    label = "Transmission fluid chance",
                },
                oilLeaksTransmissionFluidCriticalChance = {
                    description = "Critical leak chance from 0 to 1.",
                    label = "Critical transmission chance",
                },
                oilLeaksTransmissionFluidCriticalThreshold = {
                    description = "Transmission fluid condition at or below which the critical chance is used.",
                    label = "Critical transmission threshold",
                },
                oilLeaksTransmissionFluidThreshold = {
                    description = "Transmission fluid condition at or below which a leak can start.",
                    label = "Transmission fluid threshold",
                },
                orderInstallLiftBypassVehicleClasses = {
                    description = "Vehicle classes that can complete lift-dependent order work without a workshop lift.",
                    itemLabel = "Add vehicle class",
                    label = "Lift bypass vehicle classes",
                    options = {
                        ["0"] = "Compacts",
                        ["1"] = "Sedans",
                        ["10"] = "Industrial",
                        ["11"] = "Utility",
                        ["12"] = "Vans",
                        ["13"] = "Cycles",
                        ["14"] = "Boats",
                        ["15"] = "Helicopters",
                        ["16"] = "Planes",
                        ["17"] = "Service",
                        ["18"] = "Emergency",
                        ["19"] = "Military",
                        ["2"] = "SUVs",
                        ["20"] = "Commercial",
                        ["21"] = "Trains",
                        ["22"] = "Open Wheel",
                        ["3"] = "Coupes",
                        ["4"] = "Muscle",
                        ["5"] = "Sports Classics",
                        ["6"] = "Sports",
                        ["7"] = "Super",
                        ["8"] = "Motorcycles",
                        ["9"] = "Off-road",
                    },
                },
                orderInstallLiftBypassVehicleModels = {
                    description = "Vehicle spawn models that can complete lift-dependent order work without a workshop lift.",
                    itemLabel = "Vehicle model",
                    label = "Lift bypass vehicle models",
                },
                orderInstallNonMinigameDurationMs = {
                    description = "Milliseconds used for order install steps that do not run a minigame.",
                    label = "Simple install duration",
                },
                orderInstallNonMinigameVehicleClasses = {
                    description = "Vehicle class IDs that always use the normal mechanic install without specialized lift or minigame flows.",
                    label = "Non-minigame vehicle classes",
                },
                orderInstallNonMinigameVehicleModels = {
                    description = "Vehicle spawn models that always use the normal mechanic install without specialized lift or minigame flows.",
                    label = "Non-minigame vehicle models",
                },
                partsDeliveryCompanyCard = {
                    description = "Allow parts delivery orders to use company funds.",
                    label = "Company card payment",
                },
                partsDeliveryMode = {
                    description = "Keep the standard physical delivery flow or add the full delivery directly to the collecting player's inventory.",
                    label = "Delivery handling",
                    options = {
                        player_inventory = "Player inventory",
                        standard = "Standard delivery flow",
                    },
                },
                partsDeliveryOpenDurationMs = {
                    description = "Milliseconds required to unpack a ready parts delivery.",
                    label = "Open duration",
                },
                partsDeliveryOwnCard = {
                    description = "Allow players to pay parts delivery orders with their own money.",
                    label = "Own card payment",
                },
                partsDeliveryTimeSeconds = {
                    description = "Seconds between ordering parts and the delivery becoming ready.",
                    label = "Delivery time",
                },
                partsTheftCatalyticConverterItem = {
                    description = "Inventory item awarded when a catalytic converter is stolen.",
                    label = "Catalytic converter item",
                },
                partsTheftDealerAccount = {
                    description = "Account used for stolen parts dealer payouts, such as money or bank.",
                    label = "Dealer payout account",
                },
                partsTheftDealerItems = {
                    description = "Stolen items the dealer will buy and their payout values.",
                    itemLabel = "Dealer item",
                    label = "Dealer items",
                },
                partsTheftDealerPayoutItem = {
                    description = "Inventory item given when the dealer payout type is Item. The sale price is used as the item amount.",
                    label = "Dealer payout item",
                },
                partsTheftDealerPayoutType = {
                    description = "Choose whether the dealer pays into a framework account or gives an inventory item.",
                    label = "Dealer payout type",
                    options = {
                        account = "Account",
                        item = "Item",
                    },
                },
                partsTheftDealerSellDistance = {
                    description = "Maximum distance from the dealer to sell stolen parts.",
                    label = "Dealer sell distance",
                },
                partsTheftDispatchCooldownSeconds = {
                    description = "Seconds before the same vehicle part can create another dispatch.",
                    label = "Dispatch cooldown",
                },
                partsTheftDispatchEnabled = {
                    description = "Create a police dispatch when a wheel or catalytic converter is stolen.",
                    label = "Send police dispatch",
                },
                partsTheftDispatchJobs = {
                    description = "Job names that receive parts theft dispatches.",
                    itemLabel = "Job name",
                    label = "Dispatch jobs",
                },
                partsTheftDispatchMessage = {
                    description = "Message shown on the dispatch alert. Supports {plate}, {part}, and {type}.",
                    label = "Dispatch message",
                },
                partsTheftDispatchTitle = {
                    description = "Title shown on the dispatch alert. Supports {plate}, {part}, and {type}.",
                    label = "Dispatch title",
                },
                partsTheftItem = {
                    description = "Inventory item used to steal wheels and catalytic converters.",
                    label = "Theft tool item",
                },
                partsTheftRemoveItemAfterUse = {
                    description = "Remove the theft tool item after a successful theft action.",
                    label = "Consume theft tool",
                },
                partsTheftStolenWheelItem = {
                    description = "Inventory item awarded when wheels are stolen.",
                    label = "Stolen wheel item",
                },
                priceType = {
                    description = "Percentage calculates costs from the vehicle price. Fixed uses money values. Vehicle class uses the class pricing table.",
                    label = "Price type",
                    options = {
                        class = "Vehicle class",
                        fixed = "Fixed",
                        percentage = "Percentage",
                    },
                },
                primaryColor = {
                    description = "Default color for the mechanic job group and new jobs. Use a hex value such as #EDC001.",
                    label = "Primary color",
                },
                publicUsersSeePrices = {
                    description = "When enabled, public customers pay while ordering. Disable this to create unpaid orders for mechanic billing.",
                    label = "Charge public self-service orders",
                },
                registryBikeChecks = {
                    description = "Motorcycle inspection points",
                    label = "Motorcycle inspection points",
                },
                registryCarChecks = {
                    description = "Car inspection points",
                    label = "Car inspection points",
                },
                registryDistance = {
                    description = "Service distance (metres)",
                    label = "Service distance (metres)",
                },
                registryKuvFee = {
                    description = "Vehicle technical inspection fee",
                    label = "Vehicle technical inspection fee",
                },
                registryKuvValidityDays = {
                    description = "Validity of new inspections in real time. Default: 30 days. Existing expiry dates are preserved.",
                    label = "Inspection validity (real-time days)",
                },
                registryKuvWarningDays = {
                    description = "Warning period (days)",
                    label = "Warning period (days)",
                },
                registryRegistrationFee = {
                    description = "Registration fee",
                    label = "Registration fee",
                },
                registryReinspectionFee = {
                    description = "Reinspection fee",
                    label = "Reinspection fee",
                },
                registryRequireKuv = {
                    description = "Require valid Vehicle technical inspection for registration",
                    label = "Require valid Vehicle technical inspection for registration",
                },
                registrySessionSeconds = {
                    description = "Confirmation period (seconds)",
                    label = "Confirmation period (seconds)",
                },
                registryTransferFee = {
                    description = "Transfer fee",
                    label = "Transfer fee",
                },
                registryVehicleTypes = {
                    description = "Allowed vehicle types",
                    label = "Allowed vehicle types",
                },
                subscriptionsAllowJobSubscriptions = {
                    description = "Allow authorised bosses to purchase a subscription for their entire job using company funds.",
                    label = "Company subscriptions",
                },
                subscriptionsCurrency = {
                    description = "sky_base currency used to purchase subscriptions, for example bank.",
                    label = "Payment currency",
                },
                subscriptionsEnabled = {
                    description = "Enable workshop subscriptions, customer terminals and subscription discounts.",
                    label = "Enabled",
                },
                subscriptionsMaximumDurations = {
                    description = "Maximum duration and price options per subscription model.",
                    label = "Maximum durations",
                },
                subscriptionsMaximumModels = {
                    description = "Maximum subscription models a workshop can configure in the tablet.",
                    label = "Maximum models",
                },
                subscriptionsNpcEmoteClip = {
                    description = "Optional looping animation clip used when the scenario is empty.",
                    label = "NPC emote clip",
                },
                subscriptionsNpcEmoteDict = {
                    description = "Optional animation dictionary used when the scenario is empty.",
                    label = "NPC emote dictionary",
                },
                subscriptionsNpcPedModel = {
                    description = "Ped model spawned at subscription terminals, for example s_m_m_autoshop_01.",
                    label = "NPC ped model",
                },
                subscriptionsNpcScenario = {
                    description = "Optional GTA scenario such as WORLD_HUMAN_CLIPBOARD. Leave empty to use the emote animation.",
                    label = "NPC scenario",
                },
                tuningBlockedPlates = {
                    description = "Vehicles with one of these plates cannot be tuned, installed, or have tuning removed. Matching ignores casing and whitespace.",
                    itemLabel = "Plate",
                    label = "Blocked tuning plates",
                },
                tuningFocusKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Tuning mouse interaction",
                },
                tuningWorkshopDistance = {
                    description = "Maximum distance from a self-service tuning point for required install or removal actions.",
                    label = "Workshop requirement distance",
                },
                tuningWorkshopRequireForInstall = {
                    description = "Require tuning order installs to start and complete near a self-service tuning point.",
                    label = "Require workshop for installs",
                },
                tuningWorkshopRequireForRemoval = {
                    description = "Require tuning removals to start and complete near a self-service tuning point.",
                    label = "Require workshop for removals",
                },
                vehicleCareRepairDurationMs = {
                    description = "Repair progress duration in milliseconds.",
                    label = "Repair duration",
                },
                vehicleCareRepairFixRealisticWheelDamage = {
                    description = "Also reset realistic wheel damage when using the repair action.",
                    label = "Fix realistic wheel damage",
                },
                vehicleCareRepairItem = {
                    description = "Inventory item used by the vehicle repair action.",
                    label = "Repair item",
                },
                vehicleCareRepairMaxDistance = {
                    description = "Maximum distance from the vehicle while repairing.",
                    label = "Repair max distance",
                },
                vehicleCareRepairRemoveAfterUse = {
                    description = "Remove the repair item after use.",
                    label = "Consume repair item",
                },
                vehicleCareRepairVehicleDamage = {
                    description = "Repair normal GTA vehicle damage when using the repair action.",
                    label = "Fix vehicle damage",
                },
                vehicleCareRepairWearParts = {
                    description = "Choose which wear and service parts the repair item restores. Disable fluids here if oil, coolant, brake fluid, or transmission fluid should require the diagnostics repair flow.",
                    itemLabel = "Wear part",
                    label = "Repair kit restored parts",
                },
                vehicleCareWashItem = {
                    description = "Inventory item used to wash a vehicle.",
                    label = "Wash item",
                },
                vehicleCareWashRemoveAfterUse = {
                    description = "Remove the wash item after use.",
                    label = "Consume wash item",
                },
                vehicleCareWaxCleanKilometers = {
                    description = "Distance a waxed vehicle stays clean.",
                    label = "Wax clean kilometers",
                },
                vehicleCareWaxItem = {
                    description = "Inventory item used to wax a vehicle.",
                    label = "Wax item",
                },
                vehicleCareWaxRemoveAfterUse = {
                    description = "Remove the wax item after use.",
                    label = "Consume wax item",
                },
                vehicleClassPricing = {
                    description = "Override the price type and cost multiplier for each GTA vehicle class.",
                    label = "Vehicle class pricing",
                },
                wearParts = {
                    description = "Vehicle wear parts, their lifetime distance, required repair item, item consumption, and install flow.",
                    fields = {
                        flow = {
                            options = {
                                catalytic_converter = "Catalytic converter",
                                fluid_refill = "Fluid refill",
                                hood_install = "Hood install",
                                oil_change = "Oil change",
                                performance = "Performance",
                                underbody_neon = "Underbody / lift",
                                wheel = "Wheel",
                            },
                        },
                    },
                    itemLabel = "Wear part",
                    label = "Wear parts",
                },
                wheelDamageDefaultMultiplier = {
                    description = "Base wheel damage multiplier.",
                    label = "Default multiplier",
                },
                wheelDamageDeformationAngleThreshold = {
                    description = "Filters deformation probe points that do not point back to the vehicle body.",
                    label = "Probe angle threshold",
                },
                wheelDamageDeformationDamageIncrement = {
                    description = "Additional force added each restore iteration.",
                    label = "Deformation damage increment",
                },
                wheelDamageDeformationEnabled = {
                    description = "Capture and restore body dents during tyre repair geometry rebuilds.",
                    label = "Restore deformation",
                },
                wheelDamageDeformationInitialDamage = {
                    description = "Starting force used when restoring dents.",
                    label = "Initial deformation damage",
                },
                wheelDamageDeformationMaxIterations = {
                    description = "Maximum SetVehicleDamage passes used to rebuild dents.",
                    label = "Deformation iterations",
                },
                wheelDamageDeformationThreshold = {
                    description = "Minimum detected deformation magnitude to store.",
                    label = "Deformation threshold",
                },
                wheelDamageOffroadWheelsMultiplier = {
                    description = "Multiplier used when the vehicle has off-road wheels.",
                    label = "Off-road wheel multiplier",
                },
                wheelDamageRepairInstantDamageReapplyPasses = {
                    description = "Extra instant non-wheel damage restore passes after wheel geometry is rebuilt.",
                    label = "Damage reapply passes",
                },
                wheelDamageRepairInstantWheelStateReapplyPasses = {
                    description = "Extra instant passes for still-missing or still-flat tyres after a wheel is repaired.",
                    label = "Wheel-state reapply passes",
                },
                wheelDamageRepairPreserveNonWheelDamage = {
                    description = "Keep body, engine, windows, doors, dirt and visual damage when tyre repair rebuilds wheel geometry.",
                    label = "Preserve vehicle damage",
                },
                wheelDamageRepairQuietWindowRemoval = {
                    description = "Restore broken windows without the loud smash effect where possible.",
                    label = "Quiet broken windows",
                },
                wheelDamageRepairSilentPoppedReapply = {
                    description = "Reapply still-flat tyres without triggering a new tyre pop sound or effect.",
                    label = "Silent flat tyre reapply",
                },
                wheelDamageTyreRepairAttachDistance = {
                    description = "Maximum distance from the damaged or missing tyre for the mount action.",
                    label = "Tyre attach distance",
                },
                wheelDamageTyreRepairCarJackRemoveDistance = {
                    description = "Maximum distance from the placed car jack for the remove action.",
                    label = "Car jack remove distance",
                },
                wheelDamageVehicleClassMultipliers = {
                    description = "Damage multipliers per GTA vehicle class.",
                    itemLabel = "Vehicle class",
                    label = "Vehicle class multipliers",
                },
                vehicleCareRepairBlockForNonMechanicsWhenMechanicsOnDuty = {
                    label = "Block other jobs when mechanics are on duty",
                },
                allowsprint = {
                    label = "Allow sprinting with delivery boxes",
                },
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "Allows employees to enroll themselves in available training sessions.",
                approvalRequired = "Keeps self-enrollments pending until an authorized instructor approves them.",
                defaultCapacity = "Default number of seats used when a new training session is created.",
                enabled = "Makes the Training App available to this job.",
                requireOnDuty = "Requires employees to be on duty before opening or using the Training App.",
                upcomingDays = "Number of future days shown in the Training App schedule.",
            },
            trainingFields = {
                allowSelfEnrollment = "Allow self-enrollment",
                approvalRequired = "Require enrollment approval",
                defaultCapacity = "Default capacity",
                enabled = "Enable training",
                requireOnDuty = "Require duty",
                upcomingDays = "Upcoming period (days)",
            },
            tuningCategories = {
                bodywork = "Bodywork & Appearance",
                electronics = "ECU & Vehicle Electronics",
                engineSounds = "Engine Sounds",
                handling = "Handling",
                lights = "Lights",
                other = "Other",
                paint = "Paint",
                performance = "Performance",
                stance = "Stance",
                wheels = "Wheels",
            },
            tuningOptions = {
                antilag_enabled = {
                    label = "Anti-Lag",
                    values = {
                        [0] = "Disabled",
                        [1] = "GTA Standard",
                        [2] = "Street Pops",
                        [3] = "Race Anti-Lag",
                        [4] = "Rally Anti-Lag",
                    },
                },
                electronic_automatic_hazards = {
                    label = "Automatic Hazards",
                    values = {
                        [0] = "Off",
                        [1] = "On",
                    },
                },
                electronic_brake_lights = {
                    label = "Brake Lights",
                    values = {
                        [0] = "Normal",
                        [1] = "Emergency Flash",
                        [2] = "Off",
                    },
                },
                electronic_engine_tune = {
                    label = "Engine Software",
                    values = {
                        [0] = "Stock",
                        [1] = "Stage 1",
                        [2] = "Stage 2",
                        [3] = "Stage 3",
                        [4] = "Stage 4",
                    },
                },
                electronic_headlight_brightness = {
                    label = "Headlight Brightness",
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
                    label = "High Beams on Horn",
                    values = {
                        [0] = "Off",
                        [1] = "On",
                    },
                },
                electronic_idle_rpm = {
                    label = "Idle RPM",
                    values = {
                        [0] = "Stock",
                        [1] = "20%",
                        [2] = "30%",
                        [3] = "40%",
                        [4] = "50%",
                    },
                },
                electronic_interior_light = {
                    label = "Interior Light",
                    values = {
                        [0] = "Normal",
                        [1] = "Red",
                    },
                },
                electronic_mood_color = {
                    label = "Mood Light Color",
                    values = {
                        [0] = "Off",
                        [1] = "Red",
                        [10] = "Lime",
                        [11] = "Teal",
                        [12] = "Indigo",
                        [13] = "White",
                        [14] = "Warm White",
                        [15] = "Cold White",
                        [16] = "Amber",
                        [2] = "Blue",
                        [3] = "Green",
                        [4] = "Cyan",
                        [5] = "Magenta",
                        [6] = "Yellow",
                        [7] = "Orange",
                        [8] = "Purple",
                        [9] = "Pink",
                    },
                },
                electronic_mood_intensity = {
                    label = "Mood Light Intensity",
                    values = {
                        [0] = "Dim",
                        [1] = "Normal",
                        [2] = "Bright",
                    },
                },
                electronic_radio_power = {
                    label = "Radio Power",
                    values = {
                        [0] = "Off",
                        [1] = "On",
                    },
                },
                electronic_throttle_response = {
                    label = "Throttle Response",
                    values = {
                        [0] = "More Traction",
                        [1] = "Aggressive",
                    },
                },
                electronic_wheelie_tune = {
                    label = "Wheelie Tune",
                    values = {
                        [0] = "Off",
                        [1] = "Soft",
                        [2] = "Intense",
                    },
                },
            },
            vehicleClassLabel = "Class {id} ({name})",
        },
    },
}
