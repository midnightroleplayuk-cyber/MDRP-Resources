JobConfigLocales["sky_firejob:en"] = {
    Nui = {
        workshopConfig = {
            configs = {
                sky_firejob = {
                    subtitle = "Configure fire jobs, lighter ignition, vehicle fires, technical rescue, NPC rescue flows, fire stations, and mission creator settings.",
                    title = "Fire Jobs",
                },
            },
            creatorSections = {
                fireStations = {
                    entryLabel = "Fire Station",
                    entryPluralLabel = "Fire Stations",
                    label = "Fire Stations",
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
            extensions = {
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
                trainingSettings = {
                    description = "Configure training access, enrollment, approvals, and course planning for this job.",
                    label = "Training settings",
                },
            },
            extinguisherMaintenanceStates = {
                checked = "Checked",
                damaged = "Damaged",
                empty = "Empty",
                missing = "No extinguisher",
            },
            extinguisherMountStates = {
                empty = "Mount empty",
                mounted = "Extinguisher mounted",
            },
            features = {
                waterMonitor = {
                    description = "Deal with larger fires using a steady water stream with adjustable pitch. Requires a supply line to a fire vehicle with tank water, hydrant, or pump.",
                    label = "Water Monitor",
                },
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
            misc = {
                defaultFireTruckLabel = "Fire Truck",
                fireStationCategoryLabel = "Fire Station",
                fireStationEntryLabel = "Fire Station",
                fireStationPosition = "Fire station position",
                fireStationsTitle = "Fire Stations",
                hoseConnectionEditorTitle = "Hose Connection Editor",
                hydrantConnectionEditorTitle = "Hydrant Hose Connection Editor",
                pumpIntakeEditorTitle = "Pump Intake Editor",
                pumpOutletEditorTitle = "Pump Outlet Editor",
                pumpPanelAccessEditorTitle = "Hose Control Access Editor",
                scbaRefillBlipLabel = "SCBA refill",
                scbaRefillStationLabel = "SCBA refill station",
            },
            settingFields = {
                cannonId = "Water cannon ID",
                cannonLabel = "Water cannon name",
                reason = "Reason",
                airBottleSlots = "Air bottle slots",
                amount = "Amount",
                automatic = "Automatic",
                canSpread = "Can spread",
                component = "Component",
                connection = "Connection",
                currentPosition = "Current position",
                delete = "Delete",
                description = "Description",
                dispatchJobs = "Dispatch jobs",
                drawables = "Drawables",
                enabled = "Enabled",
                fillLevel = "Fill level",
                fireType = "Fire type",
                foamTankEnabled = "Foam tank",
                foamTankSize = "Foam liters",
                gearKey = "Type",
                hydrantConnection = "Hydrant connection",
                hydrantRx = "Hydrant Rot X",
                hydrantRy = "Hydrant Rot Y",
                hydrantRz = "Hydrant Rot Z",
                hydrantX = "Hydrant X",
                hydrantY = "Hydrant Y",
                hydrantZ = "Hydrant Z",
                id = "ID",
                igniteDistance = "Ignition distance",
                intensity = "Intensity",
                job = "Job",
                jobs = "Duty jobs",
                key = "Key",
                label = "Label",
                location = "Location",
                maintenanceStatus = "Maintenance",
                minOnDuty = "Required on duty",
                minimum = "Minimum online",
                mission = "Mission",
                model = "Model",
                name = "Name",
                prop = "Prop",
                pumpConnections = "Pump connections",
                pumpDischargeCount = "Pump discharges",
                pumpIntake1Connection = "Intake 1",
                pumpIntake1Label = "Intake 1 label",
                pumpIntake1Rx = "Intake 1 rotation X",
                pumpIntake1Ry = "Intake 1 rotation Y",
                pumpIntake1Rz = "Intake 1 rotation Z",
                pumpIntake1X = "Intake 1 X",
                pumpIntake1Y = "Intake 1 Y",
                pumpIntake1Z = "Intake 1 Z",
                pumpIntake2Connection = "Intake 2",
                pumpIntake2Label = "Intake 2 label",
                pumpIntake2Rx = "Intake 2 rotation X",
                pumpIntake2Ry = "Intake 2 rotation Y",
                pumpIntake2Rz = "Intake 2 rotation Z",
                pumpIntake2X = "Intake 2 X",
                pumpIntake2Y = "Intake 2 Y",
                pumpIntake2Z = "Intake 2 Z",
                pumpIntakeCount = "Pump intakes",
                pumpOutlet1Connection = "Outlet 1",
                pumpOutlet1Label = "Outlet 1 label",
                pumpOutlet1Rx = "Outlet 1 rotation X",
                pumpOutlet1Ry = "Outlet 1 rotation Y",
                pumpOutlet1Rz = "Outlet 1 rotation Z",
                pumpOutlet1X = "Outlet 1 X",
                pumpOutlet1Y = "Outlet 1 Y",
                pumpOutlet1Z = "Outlet 1 Z",
                pumpOutlet2Connection = "Outlet 2",
                pumpOutlet2Label = "Outlet 2 label",
                pumpOutlet2Rx = "Outlet 2 rotation X",
                pumpOutlet2Ry = "Outlet 2 rotation Y",
                pumpOutlet2Rz = "Outlet 2 rotation Z",
                pumpOutlet2X = "Outlet 2 X",
                pumpOutlet2Y = "Outlet 2 Y",
                pumpOutlet2Z = "Outlet 2 Z",
                pumpOutlet3Connection = "Outlet 3",
                pumpOutlet3Label = "Outlet 3 label",
                pumpOutlet3Rx = "Outlet 3 rotation X",
                pumpOutlet3Ry = "Outlet 3 rotation Y",
                pumpOutlet3Rz = "Outlet 3 rotation Z",
                pumpOutlet3X = "Outlet 3 X",
                pumpOutlet3Y = "Outlet 3 Y",
                pumpOutlet3Z = "Outlet 3 Z",
                pumpOutlet4Connection = "Outlet 4",
                pumpOutlet4Label = "Outlet 4 label",
                pumpOutlet4Rx = "Outlet 4 rotation X",
                pumpOutlet4Ry = "Outlet 4 rotation Y",
                pumpOutlet4Rz = "Outlet 4 rotation Z",
                pumpOutlet4X = "Outlet 4 X",
                pumpOutlet4Y = "Outlet 4 Y",
                pumpOutlet4Z = "Outlet 4 Z",
                pumpPanelAccess = "Hose Control access",
                pumpPanelConfigured = "Panel configured",
                pumpPanelSize = "Panel size",
                pumpPanelX = "Panel X",
                pumpPanelY = "Panel Y",
                pumpPanelZ = "Panel Z",
                resource = "Resource",
                rx = "Rot X",
                ry = "Rot Y",
                rz = "Rot Z",
                scenario = "Mission",
                sourceScale = "Source scale",
                state = "Mount state",
                teleport = "Teleport",
                textures = "Textures",
                turretBone = "Turret barrel bone",
                turretMuzzleOffsetX = "Muzzle offset X",
                turretMuzzleOffsetY = "Muzzle offset Y",
                turretMuzzleOffsetZ = "Muzzle offset Z",
                turretOffsetX = "Turret offset X",
                turretOffsetY = "Turret offset Y",
                turretOffsetZ = "Turret offset Z",
                turretTipOffset = "Barrel tip distance",
                waterGravityScale = "Water gravity",
                waterTankEnabled = "Water tank",
                waterTankSize = "Water liters",
                waterVelocity = "Water velocity",
                weather = "Weather type",
                x = "X",
                y = "Y",
                z = "Z",
                zOffset = "Z offset",
            },
            settingGroups = {
                billing = {
                    label = "Billing",
                },
                absorbentMinigame = {
                    description = "Controls the oil absorbent spreading minigame.",
                    label = "Absorbent Minigame",
                },
                access = {
                    label = "Access",
                },
                air = {
                    label = "Breathing air",
                },
                airItem = {
                    label = "Air bottle item",
                },
                airRefill = {
                    label = "Air refill",
                },
                ambulance = {
                    label = "Ambulance",
                },
                animals = {
                    label = "Animal rescue",
                },
                attachment = {
                    label = "Attachment",
                },
                automaticMissionDispatch = {
                    description = "Controls dispatch creation for automatically and manually started missions.",
                    label = "Dispatch",
                },
                automaticMissionJobs = {
                    description = "These jobs are used when a mission has no mission-specific jobs.",
                    label = "Default duty jobs",
                },
                automaticMissionList = {
                    description = "Every mission from the Mission Creator is listed automatically.",
                    label = "Available missions",
                },
                automaticMissionTiming = {
                    description = "Controls when the scheduler attempts to start an automatic mission.",
                    label = "Automatic trigger",
                },
                breathing = {
                    label = "Breathing",
                },
                breathingClothing = {
                    label = "Breathing protection clothing",
                },
                burnDamage = {
                    label = "Burn damage",
                },
                cleanup = {
                    description = "Controls required cleanup items, item consumption and fallback progress times.",
                    label = "Cleanup flow",
                },
                consumption = {
                    label = "Consumption",
                },
                creator = {
                    label = "Creator",
                },
                detection = {
                    label = "Detection",
                },
                dispatch = {
                    label = "Dispatch",
                },
                distance = {
                    label = "Distances",
                },
                dump = {
                    label = "Water dump",
                },
                effects = {
                    label = "Effects",
                },
                engineBehavior = {
                    label = "Vehicle Safety",
                },
                engineOutput = {
                    label = "Engine Output",
                },
                engineRetention = {
                    label = "Engine Retention",
                },
                enterAnimation = {
                    label = "Enter animation",
                },
                exitAnimation = {
                    label = "Exit animation",
                },
                explosion = {
                    label = "Explosion",
                },
                external = {
                    label = "External",
                },
                extinguish = {
                    label = "Extinguishing",
                },
                extinguisher = {
                    label = "Fire extinguisher",
                },
                femaleBreathingClothing = {
                    label = "Breathing protection clothing",
                },
                femaleHeatClothing = {
                    label = "Heat protection clothing",
                },
                femaleProtectiveMaskClothing = {
                    label = "Protective mask clothing",
                },
                fieldFlow = {
                    label = "Field flow",
                },
                fireExtinguishFeedback = {
                    label = "Fire extinguish feedback",
                },
                fireParticles = {
                    label = "Flames and smoke",
                },
                fireReward = {
                    description = "Controls the society deposit paid when a standalone fire is fully extinguished.",
                    label = "Fire payout",
                },
                fireRewardJobs = {
                    description = "Job societies that receive the standalone fire payout. Each job uses its configured society account.",
                    label = "Fire society jobs",
                },
                fireSoundAmbient = {
                    label = "Fire ambient",
                },
                fireSoundChainsaw = {
                    label = "Chainsaw",
                },
                fireSoundFlare = {
                    label = "Flare sound",
                },
                fireThirst = {
                    label = "Thirst in fire",
                },
                flow = {
                    label = "Flow",
                },
                flowBehavior = {
                    label = "Flow Behavior",
                },
                foamRefill = {
                    label = "Foam refill",
                },
                foamRefillVisual = {
                    label = "Foam refill visual",
                },
                fullFireStage = {
                    label = "Full fire stage",
                },
                general = {
                    label = "General",
                },
                glassMinigame = {
                    description = "Controls the vehicle-window weak-point minigame.",
                    label = "Glass Minigame",
                },
                groundActionAnimation = {
                    label = "Ground Handling Animation",
                },
                hazard = {
                    description = "Controls spill danger, intensity and automatic removal thresholds.",
                    label = "Hazard tuning",
                },
                heat = {
                    label = "Heat",
                },
                heatClothing = {
                    label = "Heat protection clothing",
                },
                heatStress = {
                    label = "Heat stress",
                },
                helicopters = {
                    label = "Helicopters",
                },
                hoseGrounding = {
                    label = "Grounding",
                },
                hosePerformance = {
                    label = "Performance",
                },
                hoseProp = {
                    label = "Hose Prop",
                },
                hosePropGeometry = {
                    label = "Prop Geometry",
                },
                hoseSimulation = {
                    label = "Simulation",
                },
                hydrantSupply = {
                    label = "Hydrant Supply",
                },
                hydrants = {
                    label = "Hydrants",
                },
                idleAnimation = {
                    label = "Operating animation",
                },
                ignition = {
                    label = "New menu fires",
                },
                interaction = {
                    label = "Interaction",
                },
                item = {
                    label = "Item",
                },
                items = {
                    label = "Items",
                },
                keybinds = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Keybinds",
                },
                landing = {
                    label = "Landing",
                },
                limits = {
                    label = "Limits",
                },
                maintenance = {
                    label = "Status",
                },
                maintenanceAccess = {
                    label = "Access",
                },
                manual = {
                    label = "Manual ignition",
                },
                manualOnly = {
                    label = "Manual only",
                },
                nozzle = {
                    label = "Hose nozzle",
                },
                nozzleAttachment = {
                    label = "Hose Attachment",
                },
                nozzleBend = {
                    label = "Connection Bend",
                },
                nozzleDirection = {
                    label = "Exit Direction",
                },
                nozzlePlacement = {
                    label = "Ground Placement",
                },
                npcFireReactions = {
                    label = "NPC fire reactions",
                },
                npcFireReactionsModes = {
                    label = "NPC reaction modes",
                },
                offsets = {
                    label = "Attachment offsets",
                },
                oilReward = {
                    description = "Controls the society deposit paid when an oil spill is cleaned.",
                    label = "Oil payout",
                },
                oilRewardJobs = {
                    description = "Job societies that receive oil cleanup payouts. Each job uses its configured society account.",
                    label = "Oil society jobs",
                },
                placement = {
                    label = "Placement",
                },
                playerEntrapment = {
                    label = "Player entrapment",
                },
                portablePumpSupply = {
                    label = "Portable Pump Supply",
                },
                pressureControl = {
                    label = "Pressure Control",
                },
                pressureLimits = {
                    label = "Pressure Limits",
                },
                progression = {
                    label = "Progression",
                },
                propGeneral = {
                    label = "Object ignition points",
                },
                propLimits = {
                    label = "Ignition source limits",
                },
                propList = {
                    label = "Possible ignition sources",
                },
                props = {
                    label = "Props",
                },
                protectiveMask = {
                    label = "Wildfire protective mask",
                },
                protectiveMaskClothing = {
                    label = "Protective mask clothing",
                },
                protectiveMaskItem = {
                    label = "Protective mask item",
                },
                pump = {
                    label = "Pump",
                },
                pumpDamage = {
                    label = "Pump Damage",
                },
                pumpIntakeHose = {
                    label = "Intake Hose",
                },
                pumpPanelGeneral = {
                    description = "Chooses between the simple automatic and enhanced manual pump controls.",
                    label = "Panel Mode",
                },
                pumpTargets = {
                    label = "Connection Targets",
                },
                rainFire = {
                    label = "Fire behavior",
                },
                rainGeneral = {
                    label = "General",
                },
                rainVisuals = {
                    label = "Visuals",
                },
                rainWeather = {
                    label = "Weather intensity",
                },
                random = {
                    label = "Random",
                },
                randomJobs = {
                    label = "Random jobs",
                },
                reignition = {
                    label = "Reignition",
                },
                release = {
                    label = "Release",
                },
                render = {
                    label = "Visibility",
                },
                requirements = {
                    label = "Requirements",
                },
                rescueReward = {
                    description = "Controls the society deposit paid when a rescue task is completed.",
                    label = "Rescue payout",
                },
                rescueRewardJobs = {
                    description = "Job societies that receive rescue payouts. Each job uses its configured society account.",
                    label = "Rescue society jobs",
                },
                restock = {
                    label = "Restock",
                },
                rpmRange = {
                    label = "RPM Range",
                },
                seatbelt = {
                    description = "Controls the trapped-patient seatbelt cutting minigame.",
                    label = "Seatbelt Minigame",
                },
                smallFireStage = {
                    label = "Small fire stage",
                },
                smokeStage = {
                    label = "Smoke stage",
                },
                spreaderMinigame = {
                    description = "Controls the door-spreader pressure minigame.",
                    label = "Door Spreader Minigame",
                },
                standaloneAccidents = {
                    label = "Standalone accidents",
                },
                standaloneResult = {
                    label = "Standalone result",
                },
                standaloneThresholds = {
                    label = "Standalone thresholds",
                },
                stream = {
                    label = "Water stream",
                },
                sweepMinigame = {
                    description = "Controls the oil sweeping minigame.",
                    label = "Sweep Minigame",
                },
                tankFill = {
                    label = "Tank Fill",
                },
                tankSupply = {
                    label = "Vehicle Tank Supply",
                },
                targets = {
                    label = "Targets",
                },
                thermalWarnings = {
                    label = "Temperature Warnings",
                },
                timing = {
                    label = "Timing",
                },
                treeBase = {
                    description = "Core fallen-tree enable, duty requirement, model and spawn distance.",
                    label = "Incident",
                },
                treeBlip = {
                    description = "Map blip shown for active fallen-tree incidents.",
                    label = "Blip",
                },
                treeCarry = {
                    description = "Carried log model, bone, offsets and movement blend while hauling pieces.",
                    label = "Carry prop",
                },
                treeCarryAnimation = {
                    description = "Animation dictionary, name and flag used while carrying logs.",
                    label = "Carry animation",
                },
                treeDispatch = {
                    description = "Controls whether fallen-tree incidents send a dispatch and which jobs receive it.",
                    label = "Dispatch",
                },
                treeDropMarker = {
                    description = "Marker style and color shown at the log drop-off.",
                    label = "Drop-off marker",
                },
                treeDropZone = {
                    description = "Local offset, radius and cleanup range for delivered logs.",
                    label = "Drop-off zone",
                },
                treeInteractionMarker = {
                    description = "Marker style and color shown at the tree interaction point.",
                    label = "Saw marker",
                },
                treeInteractionPoint = {
                    description = "Interaction distance and local position where players start cutting the tree.",
                    label = "Saw point",
                },
                treeLogSpawn = {
                    description = "Number, model, spacing and pickup distance for generated log pieces.",
                    label = "Log pieces",
                },
                treeReward = {
                    description = "Controls the society deposit paid when a fallen tree is fully cleared.",
                    label = "Tree payout",
                },
                treeRewardJobs = {
                    description = "Job societies that receive fallen-tree payouts. Each job uses its configured society account.",
                    label = "Tree society jobs",
                },
                treeSawAnimation = {
                    description = "Animation dictionary, name and flag used while cutting.",
                    label = "Saw animation",
                },
                treeSawAttach = {
                    description = "Fine tune chainsaw position, rotation, collision and attachment behavior.",
                    label = "Chainsaw attachment",
                },
                treeSawMinigame = {
                    description = "How many saw sections must be completed before logs can be cleared.",
                    label = "Sawing minigame",
                },
                treeSawTool = {
                    description = "Model and bone used for the chainsaw held during cutting.",
                    label = "Chainsaw prop",
                },
                types = {
                    label = "Types",
                },
                usage = {
                    label = "Item and command",
                },
                vehicle = {
                    label = "Vehicle ignition",
                },
                vehicleBend = {
                    label = "Vehicle Connection Bend",
                },
                vehicleEntrapment = {
                    label = "Vehicle entrapment",
                },
                vehiclePumpBehavior = {
                    label = "Pump And Engine Behavior",
                },
                vehicleSmokeClasses = {
                    label = "Protected vehicle types",
                },
                vehicleSmokeProtection = {
                    label = "Vehicle smoke protection",
                },
                vehicleState = {
                    label = "Vehicle state",
                },
                vehicleTransfer = {
                    label = "Vehicle Water Transfer",
                },
                vehicleTransferBehavior = {
                    label = "Transfer Behavior",
                },
                vehicleTransferSourceOffset = {
                    label = "Source Connector",
                },
                vehicleTransferTargetOffset = {
                    label = "Target Connector",
                },
                vehicles = {
                    label = "Vehicles",
                },
                water = {
                    label = "Water",
                },
                waterCannon = {
                    label = "Vehicle water cannon",
                },
                waterReaction = {
                    label = "Water reaction",
                },
            },
            settingSections = {
                billing = "Billing",
                activeOilSpills = "Active Oil Spills",
                automaticMissions = "Automatic Missions",
                consumption = "Consumption",
                effects = "Effects",
                extinguishFeedback = "Feedback",
                extinguishing = "Extinguishing",
                fire = "Fire",
                foamRefill = "Foam Refill",
                foamRefillVisual = "Foam Refill Visuals",
                general = "General",
                heliBucket = "Water Bucket",
                hose = "Hose",
                hydrants = "Hydrants",
                interiorExtinguishers = "Interior Extinguishers",
                lighter = "Lighter",
                minigames = "Minigames",
                npcRescue = "NPC Rescue",
                oilCleanup = "Cleanup",
                oilGeneral = "General",
                oilHazard = "Hazard",
                oilSpills = "Oil Spills",
                protectiveGear = "Protective Gear",
                pump = "Pump",
                pumpPanel = "Pump Panel",
                rain = "Rain",
                reignition = "Reignition",
                rendering = "Rendering",
                rescueCushion = "Rescue Cushion",
                rewardFire = "Fire Reward",
                rewardOil = "Oil Reward",
                rewardRescue = "Rescue Reward",
                rewardTree = "Tree Reward",
                rewards = "Rewards",
                scenarioCreator = "Mission Creator",
                sounds = "Sounds",
                spread = "Fire Spread",
                treeDispatch = "Dispatch",
                treeDrop = "Drop-off",
                treeGeneral = "General",
                treeInteraction = "Interaction",
                treeLogs = "Logs",
                treeSaw = "Sawing",
                trees = "Trees",
                vehicleEntrapment = "Vehicle Entrapment",
                vehicleFires = "Vehicle Fires",
                vehicleRescue = "Vehicle Rescue",
                vehicles = "Vehicles",
                waterMonitor = "Water Monitor",
            },
            settingSubsections = {
                weaponIgnition = "Weapon fires",
                activeOilSpills = "Active Oil Spills",
                consumption = "Consumption",
                engineSafety = "Engine & Safety",
                extinguishFeedback = "Feedback",
                extinguisherCustomMounts = "Custom Mounts",
                extinguisherGeneral = "General",
                extinguisherMaintenance = "Maintenance",
                extinguisherMounts = "Mounts & Fill",
                extinguisherPlacement = "Placement",
                extinguishing = "Extinguishing",
                femaleClothing = "Female Clothing",
                foamRefill = "Foam Refill",
                foamRefillVisual = "Foam Refill Visuals",
                general = "General",
                hydrants = "Hydrants",
                hydraulics = "Hydraulics",
                keybinds = "Keybinds",
                maleClothing = "Male Clothing",
                minigameGlass = "Glass",
                minigameOilAbsorbent = "Oil Absorbent",
                minigameOilSweep = "Oil Sweeping",
                minigameSaw = "Sawing",
                minigameSeatbelt = "Seatbelt",
                minigameSpreader = "Door Spreader",
                nozzle = "Nozzle",
                oilCleanup = "Cleanup",
                oilGeneral = "General",
                oilHazard = "Hazard",
                pressure = "Pressure & RPM",
                pump = "Pump",
                rain = "Rain",
                reignition = "Reignition",
                rendering = "Rendering",
                reward = "Reward",
                rewardFire = "Fire Reward",
                rewardOil = "Oil Reward",
                rewardRescue = "Rescue Reward",
                rewardTree = "Tree Reward",
                simulation = "Simulation",
                sounds = "Sounds",
                spread = "Fire Spread",
                treeDispatch = "Dispatch",
                treeDrop = "Drop-off",
                treeGeneral = "General",
                treeInteraction = "Tree & Interaction",
                treeLogs = "Log Pieces",
                vehicleFires = "Vehicle Fires",
                vehicleTransfer = "Vehicle Transfer",
                vehicles = "Vehicles",
                visuals = "Visuals",
            },
            settings = {
                fireWeaponIgnitionEnabled = {
                    label = "Enable weapon fires",
                    description = "Creates Sky fires from the listed weapons. Leave disabled until your fire department is ready. Existing fires and native GTA flames are unaffected.",
                },
                fireWeaponIgnitionWeapons = {
                    label = "Weapons that can start fires",
                    description = "Weapon names, e.g. WEAPON_MOLOTOV or WEAPON_FLAREGUN. An empty list disables weapon fires. Weapons need detectable projectiles or impacts.",
                },
                hoseHollowNozzleGroundOffset = {
                    label = "Hollow-stream nozzle ground offset",
                },
                hoseNozzleModel = {
                    label = "Nozzle model",
                    choose = "Choose a model",
                    intact = "Nozzle prop model",
                    description = "Choose the normal or EU nozzle. Changing the model returns deployed attack hoses.",
                    preview = "3D preview",
                    previewDescription = "View the actual prop in the game. Save the selection separately.",
                    previewHelp = "Arrow keys move, Page Up/Down changes height, mouse wheel rotates, Enter closes, Backspace cancels.",
                    invalidModel = "Invalid prop model.",
                    modelMissing = "This prop is unavailable in the game.",
                    previewFailed = "Could not open the prop preview.",
                    previewRequiresGame = "Open /jobconfig in FiveM to view the prop.",
                    options = {
                        normal = "Normal nozzle",
                        hohlstrahlrohr = "EU nozzle",
                    },
                },
                fireBillingEnabled = {
                    label = "Enable invoices",
                    description = "Allow on-duty firefighters to issue invoices from the radial menu.",
                },
                fireBillingMode = {
                    label = "Billing system",
                    description = "Use the provider selected in Sky Base (Sky by default), or local cash/card payment.",
                    options = {
                        consent = "Cash or card",
                        framework = "Sky Base billing provider",
                    },
                },
                fireBillingReasons = {
                    label = "Invoice reasons",
                    description = "Selectable reasons and prices. Multiple reasons can be combined.",
                    itemLabel = "Reason",
                },
                fireBillingRange = {
                    label = "Recipient distance",
                    description = "Maximum distance in metres between the issuer and the recipient.",
                },
                fireBillingMaxAmount = {
                    label = "Maximum invoice amount",
                    description = "Upper limit for a single invoice, for both internal and external billing.",
                },
                airBottleSlots = {
                    description = "Configures: Air bottle slots.",
                    label = "Air bottle slots",
                },
                canSpread = {
                    description = "Allows a fire started here to spread through the Firejob spread system.",
                    label = "Allow fire spread",
                },
                connection = {
                    description = "Configures: Connection.",
                    label = "Connection",
                },
                customExtinguisherMounts = {
                    description = "Persistent custom mounts with their current extinguisher and maintenance state.",
                    label = "Placed extinguisher mounts",
                },
                deckGunSprayGamepadKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Hold deck gun spray",
                },
                deckGunSprayKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Hold deck gun spray",
                },
                drawables = {
                    description = "Configures: Drawables.",
                    label = "Drawables",
                },
                fireBreathingAirEnabled = {
                    description = "Consumes finite air pressure while the SCBA is worn.",
                    label = "Use cylinder air",
                },
                fireBreathingCapacitySeconds = {
                    description = "Configures: Air capacity seconds.",
                    label = "Air capacity seconds",
                },
                fireBreathingComponents = {
                    description = "Component rules for mask and air tank. Drawables accept any, anyNonDefault, a number, or comma-separated numbers.",
                    itemLabel = "Component",
                    label = "Required clothing components",
                },
                fireBreathingCriticalPercent = {
                    description = "Configures: Critical air percent.",
                    label = "Critical air percent",
                },
                fireBreathingHeatConsumption = {
                    description = "Configures: Heat consumption.",
                    label = "Heat consumption",
                },
                fireBreathingHudUpdateInterval = {
                    description = "Configures: HUD update interval.",
                    label = "HUD update interval",
                },
                fireBreathingIdleConsumption = {
                    description = "Configures: Idle consumption.",
                    label = "Idle consumption",
                },
                fireBreathingItemEnabled = {
                    description = "Requires the configured inventory item before SCBA can be used.",
                    label = "Require cylinder item",
                },
                fireBreathingItemName = {
                    description = "Configures: Cylinder item name.",
                    label = "Cylinder item name",
                },
                fireBreathingItemSaveInterval = {
                    description = "Configures: Pressure save interval.",
                    label = "Pressure save interval",
                },
                fireBreathingItemSavePressure = {
                    description = "Configures: Save pressure metadata.",
                    label = "Save pressure metadata",
                },
                fireBreathingJumpingConsumption = {
                    description = "Configures: Jumping consumption.",
                    label = "Jumping consumption",
                },
                fireBreathingLowPercent = {
                    description = "Configures: Low air percent.",
                    label = "Low air percent",
                },
                fireBreathingMaskForceFirstPerson = {
                    description = "Forces first-person camera while the mask overlay is active.",
                    label = "Force first person",
                },
                fireBreathingMaskOverlayEnabled = {
                    description = "Shows the first-person mask overlay while breathing protection is active.",
                    label = "Mask overlay",
                },
                fireBreathingPressureBar = {
                    description = "Configures: Full pressure bar.",
                    label = "Full pressure bar",
                },
                fireBreathingProps = {
                    description = "Configures: Required props.",
                    itemLabel = "Prop",
                    label = "Required props",
                },
                fireBreathingRefillEnabled = {
                    description = "Requires the cylinder item with pressure metadata. Place stations via the fire creator.",
                    label = "Enable refill stations",
                },
                fireBreathingRefillRate = {
                    description = "Configures: Fill rate bar per second.",
                    label = "Fill rate bar per second",
                },
                fireBreathingRunningConsumption = {
                    description = "Configures: Running consumption.",
                    label = "Running consumption",
                },
                fireBreathingSmokeConsumption = {
                    description = "Configures: Smoke consumption.",
                    label = "Smoke consumption",
                },
                fireBreathingSmokeMultiplier = {
                    description = "Smoke exposure that still reaches the player while SCBA is active.",
                    label = "Smoke exposure multiplier",
                },
                fireBreathingSprintingConsumption = {
                    description = "Configures: Sprinting consumption.",
                    label = "Sprinting consumption",
                },
                fireBreathingToxicConsumption = {
                    description = "Configures: Toxic consumption.",
                    label = "Toxic consumption",
                },
                fireBreathingToxicMultiplier = {
                    description = "Reserved toxic exposure tuning for SCBA.",
                    label = "Toxic smoke exposure multiplier",
                },
                fireEditorControl14 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · IOM_WHEEL_DOWN",
                },
                fireEditorControl15 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · IOM_WHEEL_UP",
                },
                fireEditorControl174 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · LEFT",
                },
                fireEditorControl175 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · RIGHT",
                },
                fireEditorControl177 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · BACK",
                },
                fireEditorControl191 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · RETURN",
                },
                fireEditorControl199 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · P",
                },
                fireEditorControl200 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · ESCAPE",
                },
                fireEditorControl202 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · ESCAPE",
                },
                fireEditorControl21 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · LSHIFT",
                },
                fireEditorControl24 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · MOUSE_LEFT",
                },
                fireEditorControl25 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · MOUSE_RIGHT",
                },
                fireEditorControl32 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · W",
                },
                fireEditorControl322 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · ESCAPE",
                },
                fireEditorControl33 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · S",
                },
                fireEditorControl34 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · A",
                },
                fireEditorControl35 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · D",
                },
                fireEditorControl36 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · LCONTROL",
                },
                fireEditorControl38 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · E",
                },
                fireEditorControl44 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · Q",
                },
                fireEditorControl45 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · R",
                },
                fireExtinguishFeedbackAlpha = {
                    description = "Sprite opacity from 0 to 255.",
                    label = "Fire feedback alpha",
                },
                fireExtinguishFeedbackEnabled = {
                    description = "Shows the flame sprite above a fire while it is being extinguished.",
                    label = "Enable fire feedback sprite",
                },
                fireExtinguishFeedbackHeight = {
                    description = "Vertical offset above the fire where the sprite is drawn.",
                    label = "Fire feedback height",
                },
                fireExtinguishFeedbackMaxScale = {
                    description = "Largest sprite size when extinguishing has just started.",
                    label = "Fire feedback max scale",
                },
                fireExtinguishFeedbackMinScale = {
                    description = "Smallest sprite size when the extinguish progress is almost complete.",
                    label = "Fire feedback min scale",
                },
                fireExtinguisherEffectiveness = {
                    description = "Universal effectiveness multiplier applied to the extinguisher.",
                    label = "Extinguisher effectiveness",
                },
                fireExtinguisherEnabled = {
                    description = "Allows WEAPON_FIREEXTINGUISHER to extinguish every fire type.",
                    label = "Enable fire extinguisher",
                },
                fireExtinguisherHitRadius = {
                    description = "Configures: Extinguisher hit radius.",
                    label = "Extinguisher hit radius",
                },
                fireExtinguisherProgressPerSecond = {
                    description = "Configures: Extinguisher extinguishing speed.",
                    label = "Extinguisher extinguishing speed",
                },
                fireExtinguisherRange = {
                    description = "Configures: Extinguisher range.",
                    label = "Extinguisher range",
                },
                fireFemaleBreathingComponents = {
                    description = "Female component rules for mask and air tank.",
                    itemLabel = "Component",
                    label = "Required clothing components",
                },
                fireFemaleBreathingProps = {
                    description = "Configures: Required props.",
                    itemLabel = "Prop",
                    label = "Required props",
                },
                fireFemaleHeatComponents = {
                    description = "Female component rules for heat-protective clothing.",
                    itemLabel = "Component",
                    label = "Required clothing components",
                },
                fireFemaleHeatProps = {
                    description = "Configures: Required props.",
                    itemLabel = "Prop",
                    label = "Required props",
                },
                fireFemaleProtectiveMaskComponents = {
                    description = "Female component rules applied when the wildfire protective mask is equipped.",
                    itemLabel = "Component",
                    label = "Required clothing components",
                },
                fireFemaleProtectiveMaskProps = {
                    description = "Configures: Required props.",
                    itemLabel = "Prop",
                    label = "Required props",
                },
                fireFirstSpreadDelaySeconds = {
                    description = "Minimum time after ignition before a fire may begin spreading.",
                    label = "First spread delay seconds",
                },
                fireFlameScaleMultiplier = {
                    description = "Visual flame size. 1 is the normal size; applies to active fires without changing extinguishing difficulty.",
                    label = "Flame size multiplier",
                },
                fireGearEnabled = {
                    description = "Turns the clothing, SCBA and heat protection checks on or off.",
                    label = "Enable protective gear",
                },
                fireHeatBurnDurationMultiplier = {
                    description = "Configures: Burn duration multiplier.",
                    label = "Burn duration multiplier",
                },
                fireHeatComponents = {
                    description = "Component rules for protective clothing. Drawables accept any, anyNonDefault, a number, or comma-separated numbers.",
                    itemLabel = "Component",
                    label = "Required clothing components",
                },
                fireHeatIgnite = {
                    description = "Configures: Can ignite while protected.",
                    label = "Can ignite while protected",
                },
                fireHeatProps = {
                    description = "Configures: Required props.",
                    itemLabel = "Prop",
                    label = "Required props",
                },
                fireHeatResistancePercent = {
                    description = "Simple protection strength for complete firefighter clothing. 0 means no reduction, 100 means no direct fire damage.",
                    label = "Heat resistance percent",
                },
                fireHeatStressBurnLevel = {
                    description = "Configures: Burn level.",
                    label = "Burn level",
                },
                fireHeatStressDamageInterval = {
                    description = "Configures: Heat damage interval.",
                    label = "Heat damage interval",
                },
                fireHeatStressDirectFlameDistance = {
                    description = "Configures: Direct flame distance.",
                    label = "Direct flame distance",
                },
                fireHeatStressEnabled = {
                    description = "Configures: Enable heat stress.",
                    label = "Enable heat stress",
                },
                fireHeatStressExposurePower = {
                    description = "Higher values slow heat buildup when the player is near, but not directly inside, the fire.",
                    label = "Distance heat curve",
                },
                fireHeatStressFullHeatDistance = {
                    description = "Configures: Full heat distance.",
                    label = "Full heat distance",
                },
                fireHeatStressInitialGainMultiplier = {
                    description = "Multiplier used while core temperature is still low.",
                    label = "Initial heat gain multiplier",
                },
                fireHeatStressMaxDistance = {
                    description = "Configures: Heat stress max distance.",
                    label = "Heat stress max distance",
                },
                fireHeatStressProgressionPower = {
                    description = "Higher values keep the early increase slower and let it escalate later.",
                    label = "Heat progression curve",
                },
                fireHeatStressProtectedDamage = {
                    description = "Configures: Protected damage.",
                    label = "Protected damage",
                },
                fireHeatStressProtectedDamageLevel = {
                    description = "Configures: Protected damage level.",
                    label = "Protected damage level",
                },
                fireHeatStressProtectedDecay = {
                    description = "Configures: Protected decay.",
                    label = "Protected decay",
                },
                fireHeatStressProtectedDirectFlameDistance = {
                    description = "Configures: Protected direct flame distance.",
                    label = "Protected direct flame distance",
                },
                fireHeatStressProtectedGain = {
                    description = "Configures: Protected heat gain.",
                    label = "Protected heat gain",
                },
                fireHeatStressUnprotectedDamage = {
                    description = "Configures: Unprotected damage.",
                    label = "Unprotected damage",
                },
                fireHeatStressUnprotectedDamageLevel = {
                    description = "Configures: Unprotected damage level.",
                    label = "Unprotected damage level",
                },
                fireHeatStressUnprotectedDecay = {
                    description = "Configures: Unprotected decay.",
                    label = "Unprotected decay",
                },
                fireHeatStressUnprotectedDirectFlameDistance = {
                    description = "Configures: Unprotected direct flame distance.",
                    label = "Unprotected direct flame distance",
                },
                fireHeatStressUnprotectedGain = {
                    description = "Configures: Unprotected heat gain.",
                    label = "Unprotected heat gain",
                },
                fireIgnitionGrowthSeconds = {
                    description = "Seconds for a newly placed menu fire to reach its full profile size. Applies to new fires.",
                    label = "Initial growth duration",
                },
                fireIgnitionStartScale = {
                    description = "Default initial flame size in the fire menu. Values below 1 grow to the full profile size.",
                    label = "Menu starting size",
                },
                fireInteriorExtinguishersControl38 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Wall extinguisher · E",
                },
                fireMaxFlameSources = {
                    description = "Client-wide limit across all fires. Nearby flames take priority; lower limits leave more particle capacity for water jets.",
                    label = "Maximum visible flame sources",
                },
                fireMaxFlamesPerFire = {
                    description = "Maximum number of flames a single fire may contain.",
                    label = "Maximum flames per fire",
                },
                fireMaxSmokeSources = {
                    description = "Client-wide limit for shared smoke plumes and interior smoke particles. Nearby sources take priority.",
                    label = "Maximum visible smoke sources",
                },
                fireMaxSpreadDistance = {
                    description = "Maximum distance from an existing flame at which a new flame may appear.",
                    label = "Maximum spread distance",
                },
                fireMinSpreadDistance = {
                    description = "Minimum distance from an existing flame at which a new flame may appear.",
                    label = "Minimum spread distance",
                },
                fireNozzleProgressPerSecond = {
                    description = "Extinguishing progress applied by water per second.",
                    label = "Nozzle extinguishing speed",
                },
                fireNozzleRange = {
                    description = "Maximum distance at which the hose nozzle can hit a fire.",
                    label = "Nozzle extinguishing range",
                },
                firePropIgnitionControl177 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Object ignition · BACK",
                },
                firePropIgnitionControl38 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Object ignition · E",
                },
                fireProtectiveMaskComponents = {
                    description = "Component rules applied when the wildfire protective mask is equipped.",
                    itemLabel = "Component",
                    label = "Required clothing components",
                },
                fireProtectiveMaskEnabled = {
                    description = "Enables the reusable filter mask for wildfire smoke without cylinder air.",
                    label = "Enable protective mask",
                },
                fireProtectiveMaskForceFirstPerson = {
                    description = "Forces first-person camera while the protective mask overlay is active.",
                    label = "Force first person",
                },
                fireProtectiveMaskItemEnabled = {
                    description = "Requires the configured inventory item before the protective mask can be used.",
                    label = "Require protective mask item",
                },
                fireProtectiveMaskItemName = {
                    description = "Configures: Protective mask item name.",
                    label = "Protective mask item name",
                },
                fireProtectiveMaskOverlayEnabled = {
                    description = "Shows the first-person mask overlay while the protective mask is active.",
                    label = "Mask overlay",
                },
                fireProtectiveMaskProps = {
                    description = "Configures: Required props.",
                    itemLabel = "Prop",
                    label = "Required props",
                },
                fireProtectiveMaskSmokeMultiplier = {
                    description = "Smoke exposure that still reaches the player while the protective mask is active.",
                    label = "Smoke exposure multiplier",
                },
                fireProtectiveMaskToxicMultiplier = {
                    description = "Toxic exposure that still reaches the player. Higher values make SCBA necessary for hazardous smoke.",
                    label = "Toxic smoke exposure multiplier",
                },
                fireRainEnabled = {
                    description = "Lets rain affect exterior fires.",
                    label = "Enable rain effects",
                },
                fireRainFlameScale = {
                    description = "Visual flame scale at full rain intensity.",
                    label = "Flame scale in rain",
                },
                fireRainLargeFireSpreadMultiplier = {
                    description = "Spread multiplier for large exterior fires at full rain intensity.",
                    label = "Large fire spread multiplier",
                },
                fireRainMinimumIntensity = {
                    description = "Rain values below this threshold have no effect.",
                    label = "Minimum rain intensity",
                },
                fireRainSmallFireMaxFlames = {
                    description = "Exterior fires up to this flame count can be extinguished by rain.",
                    label = "Small fire maximum flames",
                },
                fireRainSmallFireProgressPerSecond = {
                    description = "Rain extinguishing progress per second at full weather intensity.",
                    label = "Small fire extinguishing speed",
                },
                fireRainSmokeScale = {
                    description = "Visual smoke scale at full rain intensity.",
                    label = "Smoke scale in rain",
                },
                fireRainWeatherIntensity = {
                    description = "Rain effect intensity per GTA weather type from 0.0 to 1.0.",
                    itemLabel = "Weather",
                    label = "Weather intensity",
                },
                fireReignitionChancePercent = {
                    description = "Percent chance rolled whenever a combustible flame is extinguished.",
                    label = "Reignition chance percent",
                },
                fireReignitionDelaySeconds = {
                    description = "Seconds between extinguishing and the small returning flame.",
                    label = "Reignition delay seconds",
                },
                fireReignitionEnabled = {
                    description = "Allows extinguished combustible flames to reignite after a short delay.",
                    label = "Enable reignition",
                },
                fireReignitionExtinguishRequiredPercent = {
                    description = "Percent of normal extinguish progress required before a reignited flame is finally out.",
                    label = "Fully out after reignition percent",
                },
                fireReignitionFinalExtinguishHoldSeconds = {
                    description = "Seconds extinguishing must continue after full progress before a reignited flame is finally out.",
                    label = "Final-out hold time",
                },
                fireReignitionGrowthPerSecond = {
                    description = "How much scale the reignited flame gains per second until it reaches full size.",
                    label = "Growth per second",
                },
                fireReignitionNearImpactAccuracy = {
                    description = "Extinguish accuracy used when only the impact is close to a reignited mini flame.",
                    label = "Near impact accuracy",
                },
                fireReignitionNearImpactTolerance = {
                    description = "Extra meters around a reignited mini flame where a nearly matching impact still counts.",
                    label = "Near impact tolerance",
                },
                fireReignitionStartScale = {
                    description = "Scale multiplier used when the flame first reignites.",
                    label = "Starting flame scale",
                },
                fireRenderDistance = {
                    description = "Shared maximum render distance for flames and smoke.",
                    label = "Fire and smoke render distance",
                },
                fireSmokeDensityMultiplier = {
                    description = "Multiplies visible smoke opacity: 0 hides smoke, 1 is normal, and 2 increases opacity up to its limit. Smoke damage stays unchanged.",
                    label = "Smoke density multiplier",
                },
                fireSmokeScaleMultiplier = {
                    description = "Visual size of rising smoke plumes. 1 is the normal size; applies to active smoke.",
                    label = "Smoke size multiplier",
                },
                fireSmokeWindResponse = {
                    description = "How strongly packaged smoke follows the weather wind. Changing the profile restarts smoke plumes.",
                    label = "Smoke wind response",
                    options = {
                        gentle = "Gentle",
                        none = "No wind influence",
                        normal = "Normal",
                        strong = "Strong",
                    },
                },
                fireSoundChainsawEnabled = {
                    description = "Plays the chainsaw sound in 3D while a player saws a fallen tree.",
                    label = "Enable chainsaw sound",
                },
                fireSoundChainsawRange = {
                    description = "Distance in meters where players can hear the chainsaw.",
                    label = "Chainsaw range",
                },
                fireSoundChainsawVolume = {
                    description = "Maximum volume for the 3D chainsaw sound.",
                    label = "Chainsaw volume",
                },
                fireSoundFireAmbientEnabled = {
                    description = "Plays spatial fire loops matched to the type of fire.",
                    label = "Enable fire ambient sound",
                },
                fireSoundFireAmbientRange = {
                    description = "Distance in meters where players can hear active fires.",
                    label = "Fire ambient range",
                },
                fireSoundFireAmbientVolume = {
                    description = "Master volume for all spatial fire loops: 0 = silent, 1 = full. Changes apply to active fires.",
                    label = "Fire ambient volume",
                },
                fireSoundFireFlareEnabled = {
                    description = "Plays the short flare sound during water reactions.",
                    label = "Enable flare sound",
                },
                fireSoundFireFlareRange = {
                    description = "Distance in meters where players can hear water-reaction flare sounds.",
                    label = "Flare sound range",
                },
                fireSoundFireFlareVolume = {
                    description = "Maximum volume for the water-reaction flare sound.",
                    label = "Flare sound volume",
                },
                fireSpreadAttemptsPerTick = {
                    description = "Number of possible spread positions checked during each spread update.",
                    label = "Spread attempts per update",
                },
                fireSpreadEnabled = {
                    description = "Allows active fires to create additional flames on combustible surroundings.",
                    label = "Enable fire spread",
                },
                fireSpreadIntervalSeconds = {
                    description = "Base interval between spread updates. Lower values run spread checks more frequently.",
                    label = "Spread interval seconds",
                },
                fireThirstEnabled = {
                    description = "Increases thirst consumption while the player is exposed to fire heat.",
                    label = "Enable increased thirst",
                },
                fireThirstMinimumBaseLossPerMinute = {
                    description = "Minimum thirst loss used as the multiplier base when the framework rate is too small to notice.",
                    label = "Minimum base loss per minute",
                },
                fireThirstMultiplier = {
                    description = "Multiplies the normal thirst loss while the player is exposed to fire heat.",
                    label = "Thirst multiplier",
                },
                fireThirstUpdateInterval = {
                    description = "Time between framework status checks while the player remains exposed to fire heat.",
                    label = "Status check interval ms",
                },
                fireType = {
                    description = "Determines which Firejob fire profile is used for this ignition source.",
                    label = "Ignition source fire type",
                },
                fireWaterMonitorControl172 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Water monitor · UP",
                },
                fireWaterMonitorControl173 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Water monitor · DOWN",
                },
                fireWaterMonitorControl174 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Water monitor · LEFT",
                },
                fireWaterMonitorControl175 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Water monitor · RIGHT",
                },
                fireWaterMonitorControl177 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Water monitor · BACK",
                },
                fireWaterMonitorControl202 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Water monitor · ESCAPE",
                },
                fireWaterMonitorControl24 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Water monitor · MOUSE_LEFT",
                },
                fireWaterMonitorControl241 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Water monitor · IOM_WHEEL_UP",
                },
                fireWaterMonitorControl242 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Water monitor · IOM_WHEEL_DOWN",
                },
                fireWaterMonitorControl25 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Water monitor · MOUSE_RIGHT",
                },
                firetruckHudCursorKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Hold firetruck HUD mouse interaction",
                },
                firetruckHudToggleKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Toggle firetruck HUD",
                },
                firetruckWaterCannonEnabled = {
                    description = "Allows built-in water cannons on supported vehicles to extinguish fires.",
                    label = "Enable vehicle water cannon",
                },
                firetruckWaterCannonMinRange = {
                    description = "Closest distance the fixed vehicle cannon can reach because it cannot aim fully downward.",
                    label = "Minimum water cannon range",
                },
                firetruckWaterCannonModels = {
                    description = "One row per cannon. Repeat the model for roof/front cannons; use a unique ID per model and the matching barrel bone. Existing entries use deckGun. Each vehicle water cannon needs a unique ID per model (1-48 letters, digits, underscores or hyphens).",
                    itemLabel = "Water cannon",
                    label = "Vehicle water cannons",
                },
                firetruckWaterCannonProgressPerSecond = {
                    description = "Extinguishing progress applied by vehicle water cannons per second.",
                    label = "Water cannon extinguishing speed",
                },
                foamTankEnabled = {
                    description = "Configures: Foam tank.",
                    label = "Foam tank",
                },
                foamTankSize = {
                    description = "Configures: Foam liters.",
                    label = "Foam liters",
                },
                gearKey = {
                    options = {
                        helmet = "Helmet",
                        mask = "Mask",
                        other = "Other (no protection)",
                        pants = "Pants",
                        shoes = "Shoes",
                        top = "Top",
                    },
                },
                heatLevelHudPosition = {
                    description = "Position of the heat exposure HUD panel.",
                    label = "Heat exposure panel position",
                },
                heliBucketAllowedJobs = {
                    description = "Leave empty to allow all jobs configured in this Firejob.",
                    itemLabel = "Job",
                    label = "Allowed jobs",
                },
                heliBucketAttachDistance = {
                    description = "Maximum distance between the helicopter attachment point and bucket when attaching.",
                    label = "Maximum attach distance",
                },
                heliBucketAttachKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Attach/detach helicopter bucket",
                },
                heliBucketAutoAttachOnGround = {
                    description = "Automatically attaches a nearby grounded bucket when the helicopter is in range.",
                    label = "Auto attach rope on ground",
                },
                heliBucketBucketOffsetX = {
                    description = "Local X position where the rope attaches to the bucket prop.",
                    label = "Bucket rope offset X",
                },
                heliBucketBucketOffsetY = {
                    description = "Local Y position where the rope attaches to the bucket prop.",
                    label = "Bucket rope offset Y",
                },
                heliBucketBucketOffsetZ = {
                    description = "Local Z position where the rope attaches to the bucket prop.",
                    label = "Bucket rope offset Z",
                },
                heliBucketCommand = {
                    description = "Command name without a slash, for example waterbucket.",
                    label = "Command",
                },
                heliBucketCommandEnabled = {
                    description = "Allows placing the Water Bucket without an item by using the command.",
                    label = "Enable command usage",
                },
                heliBucketConsumeItem = {
                    description = "Removes one configured item after successful placement.",
                    label = "Consume item on placement",
                },
                heliBucketDetachMaxGroundDistance = {
                    description = "Maximum bucket height above the ground at which detaching is allowed.",
                    label = "Maximum detach height",
                },
                heliBucketDumpEnabled = {
                    description = "Allows stored water to be released from the bucket.",
                    label = "Enable water dump",
                },
                heliBucketDumpHitRadius = {
                    description = "Radius around the falling water column that can affect fires.",
                    label = "Hit radius",
                },
                heliBucketDumpJetScale = {
                    description = "Visual scale of the main water jet below the bucket.",
                    label = "Jet scale",
                },
                heliBucketDumpKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Release helicopter bucket water",
                },
                heliBucketDumpLitersPerSecond = {
                    description = "Amount of stored water released per second while dumping.",
                    label = "Dump liters per second",
                },
                heliBucketDumpProgressPerSecond = {
                    description = "Base extinguishing strength applied to fires inside the water column.",
                    label = "Extinguish progress per second",
                },
                heliBucketDumpRayLength = {
                    description = "Maximum downward distance checked for fires below the bucket.",
                    label = "Ray length",
                },
                heliBucketDumpSprayScale = {
                    description = "Visual scale of the wide water spray effect below the bucket.",
                    label = "Spray scale",
                },
                heliBucketEnabled = {
                    description = "Enables placement, helicopter attachment, filling, and dumping of Water Buckets.",
                    label = "Enable Water Bucket",
                },
                heliBucketGroundAttachDistance = {
                    description = "Maximum bucket-to-ground height allowed for automatic attachment.",
                    label = "Ground attach distance",
                },
                heliBucketHelicopterOffsets = {
                    description = "Rope attachment position per helicopter model; use default as the fallback model.",
                    itemLabel = "Offset",
                    label = "Helicopter rope offsets",
                },
                heliBucketHelicopters = {
                    description = "Helicopter model names that are allowed to attach the Water Bucket.",
                    itemLabel = "Helicopter",
                    label = "Allowed helicopter models",
                },
                heliBucketItem = {
                    description = "Inventory item used to place the Water Bucket.",
                    label = "Item name",
                },
                heliBucketItemEnabled = {
                    description = "Allows placing the Water Bucket by using the configured inventory item.",
                    label = "Enable item usage",
                },
                heliBucketLabel = {
                    description = "Name shown in interactions and notifications.",
                    label = "Display label",
                },
                heliBucketModel = {
                    description = "Prop model spawned for the Water Bucket.",
                    label = "Bucket prop model",
                },
                heliBucketMovingStreamDistance = {
                    description = "Maximum synchronization distance while the Water Bucket is attached and moving.",
                    label = "Moving streaming distance",
                },
                heliBucketPickupDistance = {
                    description = "Maximum distance from which an unattached Water Bucket can be picked up.",
                    label = "Pickup distance",
                },
                heliBucketRequireOnDuty = {
                    description = "Only allows on-duty members of an allowed job to use the Water Bucket.",
                    label = "Require on duty",
                },
                heliBucketRequirePilot = {
                    description = "Requires the player to occupy the helicopter pilot seat before controlling the bucket.",
                    label = "Require pilot seat",
                },
                heliBucketReturnItemOnRemove = {
                    description = "Returns one configured item when the Water Bucket is picked up.",
                    label = "Return item on pickup",
                },
                heliBucketRopeLength = {
                    description = "Length of the rope connecting the helicopter and Water Bucket.",
                    label = "Rope length",
                },
                heliBucketRopeType = {
                    description = "GTA rope type identifier used for the bucket connection.",
                    label = "Rope type",
                },
                heliBucketStreamDistance = {
                    description = "Maximum synchronization distance while the Water Bucket is stationary.",
                    label = "Streaming distance",
                },
                heliBucketWaterCapacityLiters = {
                    description = "Maximum amount of water the bucket can hold.",
                    label = "Capacity liters",
                },
                heliBucketWaterCheckIntervalMs = {
                    description = "Interval in milliseconds between checks for bucket submersion.",
                    label = "Water check interval ms",
                },
                heliBucketWaterEnabled = {
                    description = "Allows the Water Bucket to collect water when submerged.",
                    label = "Enable water filling",
                },
                heliBucketWaterFillRateLitersPerSecond = {
                    description = "Amount of water added per second while the bucket is submerged.",
                    label = "Fill rate liters per second",
                },
                heliBucketZOffset = {
                    description = "Vertical correction applied when placing the bucket prop on the ground.",
                    label = "Ground Z offset",
                },
                hoseAddPointDistance = {
                    description = "Movement distance required before another hose point is added.",
                    label = "Add point distance",
                },
                hoseDeployDistance = {
                    description = "Maximum distance from the vehicle at which a hose may be deployed.",
                    label = "Deploy distance",
                },
                hoseFoamLitersPerSecond = {
                    description = "Foam tank drain rate while spraying foam.",
                    label = "Foam liters per second",
                },
                hoseFoamRefillAnimDict = {
                    description = "Animation dictionary used while refilling foam.",
                    label = "Foam refill anim dict",
                },
                hoseFoamRefillAnimFlag = {
                    description = "Animation playback flag used for the foam refill task.",
                    label = "Foam refill anim flag",
                },
                hoseFoamRefillAnimName = {
                    description = "Animation clip used while refilling foam.",
                    label = "Foam refill anim name",
                },
                hoseFoamRefillBone = {
                    description = "Ped bone used to attach the refill prop.",
                    label = "Foam refill bone",
                },
                hoseFoamRefillDistance = {
                    description = "Maximum distance to the vehicle while refilling.",
                    label = "Foam refill distance",
                },
                hoseFoamRefillDurationMs = {
                    description = "Progress duration for one refill action.",
                    label = "Foam refill duration ms",
                },
                hoseFoamRefillEnabled = {
                    description = "Allow vehicle foam tanks to be refilled with an inventory item.",
                    label = "Enable foam refill",
                },
                hoseFoamRefillItem = {
                    description = "Inventory item required to refill the foam tank.",
                    label = "Foam refill item",
                },
                hoseFoamRefillLiters = {
                    description = "How many liters of foam one canister adds to the vehicle tank.",
                    label = "Foam refill liters",
                },
                hoseFoamRefillOffsetRx = {
                    description = "Pitch rotation for the refill prop.",
                    label = "Foam refill rotation X",
                },
                hoseFoamRefillOffsetRy = {
                    description = "Roll rotation for the refill prop.",
                    label = "Foam refill rotation Y",
                },
                hoseFoamRefillOffsetRz = {
                    description = "Yaw rotation for the refill prop.",
                    label = "Foam refill rotation Z",
                },
                hoseFoamRefillOffsetX = {
                    description = "Horizontal hand offset for the refill prop.",
                    label = "Foam refill offset X",
                },
                hoseFoamRefillOffsetY = {
                    description = "Forward or backward hand offset for the refill prop.",
                    label = "Foam refill offset Y",
                },
                hoseFoamRefillOffsetZ = {
                    description = "Vertical hand offset for the refill prop.",
                    label = "Foam refill offset Z",
                },
                hoseFoamRefillProp = {
                    description = "Prop shown in the hand while refilling the foam tank.",
                    label = "Foam refill prop",
                },
                hoseFoamRefillRequireOnDuty = {
                    description = "Only players currently on duty can refill foam tanks.",
                    label = "Require on duty for foam refill",
                },
                hoseFoamWaterLitersPerSecond = {
                    description = "Water tank drain rate while spraying foam without external supply.",
                    label = "Foam water liters per second",
                },
                hoseGroundActionAnimationDict = {
                    description = "Configures: Animation dictionary.",
                    label = "Animation dictionary",
                },
                hoseGroundActionAnimationDurationMs = {
                    description = "Total animation duration in milliseconds.",
                    label = "Animation duration",
                },
                hoseGroundActionAnimationEnabled = {
                    description = "Play an animation while laying down or picking up the attack hose.",
                    label = "Enable handling animation",
                },
                hoseGroundActionAnimationFlag = {
                    description = "Configures: Animation flag.",
                    label = "Animation flag",
                },
                hoseGroundActionAnimationLayDownName = {
                    description = "Configures: Lay-down animation.",
                    label = "Lay-down animation",
                },
                hoseGroundActionAnimationPickUpName = {
                    description = "Configures: Pick-up animation.",
                    label = "Pick-up animation",
                },
                hoseGroundActionAnimationTransitionMs = {
                    description = "Time in milliseconds at which the nozzle changes between the hand and the ground.",
                    label = "Object transition time",
                },
                hoseGroundOffset = {
                    description = "Vertical offset used when new hose points are placed on the ground.",
                    label = "Hose ground offset",
                },
                hoseGroundedNozzleHeadingOffset = {
                    description = "Yaw correction added to the player's facing direction when laying down the nozzle.",
                    label = "Grounded nozzle heading offset",
                },
                hoseGroundedNozzleOffset = {
                    description = "Vertical correction applied to the weapon object after ground placement. Negative values lower it.",
                    label = "Grounded nozzle offset",
                },
                hoseGroundedNozzlePitch = {
                    description = "Pitch used to lay the nozzle model flat on the ground.",
                    label = "Grounded nozzle pitch",
                },
                hoseGroundedNozzleRoll = {
                    description = "Roll correction applied to the grounded nozzle model.",
                    label = "Grounded nozzle roll",
                },
                hoseHydrantConnectDistance = {
                    description = "Maximum distance to a hydrant prop when attaching a supply line.",
                    label = "Hydrant connect distance",
                },
                hoseHydrants = {
                    description = "Prop models detected as hydrants for hose connections and the map.",
                    itemLabel = "Hydrant",
                    label = "Hydrant prop models",
                },
                hoseMaxLength = {
                    description = "Maximum hose length in meters before the nozzle disconnects.",
                    label = "Maximum hose length",
                },
                hoseNozzleBendDistance = {
                    description = "Distance used to form the hose bend behind the nozzle.",
                    label = "Nozzle bend distance",
                },
                hoseNozzleExitDirectionX = {
                    description = "Local X direction in which the hose exits the nozzle.",
                    label = "Exit direction X",
                },
                hoseNozzleExitDirectionY = {
                    description = "Local Y direction in which the hose exits the nozzle.",
                    label = "Exit direction Y",
                },
                hoseNozzleExitDirectionZ = {
                    description = "Local Z direction in which the hose exits the nozzle.",
                    label = "Exit direction Z",
                },
                hoseNozzleExitLength = {
                    description = "Straight hose length leaving the nozzle before the first bend.",
                    label = "Nozzle exit length",
                },
                hoseNozzleOffsetX = {
                    description = "X offset of the hose attachment on the nozzle weapon.",
                    label = "Nozzle offset X",
                },
                hoseNozzleOffsetY = {
                    description = "Y offset of the hose attachment on the nozzle weapon.",
                    label = "Nozzle offset Y",
                },
                hoseNozzleOffsetZ = {
                    description = "Z offset of the hose attachment on the nozzle weapon.",
                    label = "Nozzle offset Z",
                },
                hoseDividing = {
                    description = "Enable the placeable three-way divider, independent valves and water flow. Off by default.",
                    label = "Dividing breeching",
                },
                hosePerformanceMode = {
                    description = "High End prioritises the smoothest hose motion. Performance reduces hose updates and lowers client load.",
                    label = "Hose performance mode",
                    options = {
                        high_end = "High End",
                        performance = "Performance",
                    },
                },
                hosePropBaseLength = {
                    description = "Original length of the hose segment model before scaling.",
                    label = "Prop base length",
                },
                hosePropBaseRadius = {
                    description = "Original radius of the hose segment model before scaling.",
                    label = "Prop base radius",
                },
                hosePropLengthRatio = {
                    description = "Length correction applied when scaling the hose segment model.",
                    label = "Prop length ratio",
                },
                hosePropRoll = {
                    description = "Roll correction in degrees for the hose segment model.",
                    label = "Prop roll",
                },
                hosePropsEnabled = {
                    description = "Spawn visible hose segment props while using the nozzle. Hydrant supply lines still render when this is disabled.",
                    label = "Render nozzle hose props",
                },
                hosePumpConnectDistance = {
                    description = "Distance used when checking if the pump can draft nearby water.",
                    label = "Pump connect distance",
                },
                hosePumpControlIdlePressure = {
                    description = "Pressure used when a new pump control is created.",
                    label = "Starting pressure",
                },
                hosePumpControlIdleRpm = {
                    description = "Displayed pump-engine RPM at the lowest pressure.",
                    label = "Idle RPM",
                },
                hosePumpControlMaxPressure = {
                    description = "Highest pressure selectable on the enhanced pump panel.",
                    label = "Maximum pressure",
                },
                hosePumpControlMaxRpm = {
                    description = "Displayed pump-engine RPM at maximum pressure.",
                    label = "Maximum RPM",
                },
                hosePumpControlMinPressure = {
                    description = "Minimum PSI required for an outlet to supply water.",
                    label = "Minimum pressure",
                },
                hosePumpControlPresetPressure = {
                    description = "Pressure selected by the preset button and used as the normal-flow reference.",
                    label = "Preset pressure",
                },
                hosePumpControlPressureStep = {
                    description = "PSI added or removed by one button press.",
                    label = "Pressure step",
                },
                hosePumpControlTankFillLitersPerSecond = {
                    description = "Water moved into the vehicle tank each second while Tank Fill is active.",
                    label = "Tank fill liters/second",
                },
                hosePumpEnabled = {
                    description = "Allow pump drafting from detected natural water sources.",
                    label = "Enable portable pump",
                },
                hosePumpIntakeExtraLength = {
                    description = "Additional intake hose length extending into the detected water surface.",
                    label = "Intake extra length",
                },
                hosePumpIntakeSubmergeDepth = {
                    description = "Depth of the intake hose endpoint below the detected water surface.",
                    label = "Intake submerge depth",
                },
                hosePumpItem = {
                    description = "Inventory item used to start the portable pump directly.",
                    label = "Pump item name",
                },
                hosePumpItemEnabled = {
                    description = "Registers the configured pump item so using it starts portable pump placement.",
                    label = "Enable pump item usage",
                },
                hosePumpItemRequired = {
                    description = "Players must carry the configured pump item before they can start a portable pump supply.",
                    label = "Require pump item",
                },
                hosePumpModel = {
                    description = "Prop spawned as the portable drafting pump.",
                    label = "Pump prop model",
                },
                hosePumpNaturalWaterEnabled = {
                    description = "Allow the portable pump to draft from rivers, lakes and other detected water surfaces.",
                    label = "Enable natural water drafting",
                },
                hosePumpPanelStyle = {
                    description = "Simple uses automatic pump control with one intake and one discharge. Enhanced enables manual controls with up to two intakes and four discharges.",
                    label = "Pump panel",
                    options = {
                        enhanced = "Enhanced panel",
                        simple = "Simple panel",
                    },
                },
                hosePumpTargetDistance = {
                    description = "Maximum player distance from a configured pump connection target.",
                    label = "Target interaction distance",
                },
                hosePumpTargetSize = {
                    description = "Radius of each pump connection target point.",
                    label = "Target point radius",
                },
                hosePumpWaterProbeDepth = {
                    description = "How far below each probe point to search for water.",
                    label = "Pump water probe depth",
                },
                hosePumpWaterProbeDistance = {
                    description = "How far around the pump placement point to search for water.",
                    label = "Pump water probe distance",
                },
                hoseRadius = {
                    description = "Rendered radius of the hose segments.",
                    label = "Hose radius",
                },
                hoseRelaxPasses = {
                    description = "Number of constraint passes used to smooth the hose per update.",
                    label = "Relax passes",
                },
                hoseSegmentLength = {
                    description = "Target distance between simulated hose points.",
                    label = "Segment length",
                },
                hoseSegmentOverlap = {
                    description = "Visual overlap between adjacent hose props to hide gaps.",
                    label = "Segment overlap",
                },
                hoseSegmentProp = {
                    description = "Model used to render every visible hose segment.",
                    label = "Segment prop",
                },
                hoseSegmentUpdateDistance = {
                    description = "Minimum movement before rendered hose segments are rebuilt.",
                    label = "Segment update distance",
                },
                hoseUpdateInterval = {
                    description = "Base hose simulation update interval in milliseconds.",
                    label = "Update interval",
                },
                hoseVehicleBendDistance = {
                    description = "Distance used to form the hose bend at the vehicle.",
                    label = "Vehicle bend distance",
                },
                hoseVehicleExitLength = {
                    description = "Straight hose length leaving the vehicle connection.",
                    label = "Vehicle exit length",
                },
                hoseVehiclePumpBehaviorActiveRpm = {
                    description = "RPM value applied while the vehicle pump is active. Use 0.0 to 1.0.",
                    label = "Active RPM",
                },
                hoseVehiclePumpBehaviorAmbientTemperature = {
                    description = "Lowest pump temperature and cooling target in degrees Celsius.",
                    label = "Ambient temperature",
                },
                hoseVehiclePumpBehaviorCavitationTemperatureGain = {
                    description = "Additional target temperature added at full cavitation.",
                    label = "Cavitation temperature gain",
                },
                hoseVehiclePumpBehaviorCriticalTemperature = {
                    description = "Pump temperature at which the critical warning starts.",
                    label = "Critical temperature",
                },
                hoseVehiclePumpBehaviorDamageTemperature = {
                    description = "Pump temperature above which engine damage begins.",
                    label = "Damage temperature",
                },
                hoseVehiclePumpBehaviorDryRunDamagePerSecond = {
                    description = "Engine-health damage applied each second while dry running.",
                    label = "Dry-run damage/second",
                },
                hoseVehiclePumpBehaviorDryRunTemperature = {
                    description = "Target temperature while the pump runs without water.",
                    label = "Dry-run temperature",
                },
                hoseVehiclePumpBehaviorEnabled = {
                    description = "Keeps engines running and controls pump RPM while hose systems use the vehicle.",
                    label = "Enable pump behavior",
                },
                hoseVehiclePumpBehaviorEngagementMaxSpeed = {
                    description = "Highest vehicle speed in meters per second at which the pump may be switched.",
                    label = "Maximum engagement speed",
                },
                hoseVehiclePumpBehaviorEngineDamageEnabled = {
                    description = "Allows overheating and dry running to damage the vehicle engine. Disabled by default; pump warnings remain active.",
                    label = "Pump engine damage",
                },
                hoseVehiclePumpBehaviorFuelPercentPerMinute = {
                    description = "Base fuel percentage consumed per minute while the pump runs.",
                    label = "Fuel percent/minute",
                },
                hoseVehiclePumpBehaviorImmobilizePumpVehicles = {
                    description = "Prevents the pump vehicle from driving while its pump is active.",
                    label = "Lock vehicle while pumping",
                },
                hoseVehiclePumpBehaviorImmobilizeTransferVehicles = {
                    description = "Prevents vehicles from driving while a vehicle-to-vehicle transfer line is connected.",
                    label = "Lock transfer vehicles",
                },
                hoseVehiclePumpBehaviorKeepEngineOnDuringPump = {
                    description = "Keeps the source vehicle engine running while hand hoses or water cannons spray.",
                    label = "Engine on while spraying",
                },
                hoseVehiclePumpBehaviorKeepEngineOnDuringTransfer = {
                    description = "Keeps vehicle engines running while a transfer line is connected.",
                    label = "Engine on during transfer",
                },
                hoseVehiclePumpBehaviorKeepEngineOnWhenAbandoned = {
                    description = "Keeps configured pump vehicles running after the driver exits.",
                    label = "Keep engine on when abandoned",
                },
                hoseVehiclePumpBehaviorMaxEngineDamagePerSecond = {
                    description = "Maximum engine-health damage applied each second by pump stress.",
                    label = "Maximum damage/second",
                },
                hoseVehiclePumpBehaviorOverloadWarningLoad = {
                    description = "Engine-load ratio at which the overload warning starts.",
                    label = "Overload warning load",
                },
                hoseVehiclePumpBehaviorRpmEnabled = {
                    description = "Raises vehicle RPM while a hand hose or water cannon sprays from that vehicle.",
                    label = "Raise pump RPM",
                },
                hoseVehiclePumpBehaviorThermalResponse = {
                    description = "How quickly pump temperature moves toward its calculated target.",
                    label = "Thermal response",
                },
                hoseVehiclePumpBehaviorUpdateMs = {
                    description = "How often the client reapplies engine, lock and RPM behavior in milliseconds.",
                    label = "Update interval",
                },
                hoseVehiclePumpBehaviorWarningTemperature = {
                    description = "Pump temperature at which the overheat warning starts.",
                    label = "Warning temperature",
                },
                hoseVehiclePumpHydraulicsCavitationStartRatio = {
                    description = "Share of source capacity at which cavitation begins.",
                    label = "Cavitation start ratio",
                },
                hoseVehiclePumpHydraulicsFrictionLossPsiPerTenMeters = {
                    description = "Pressure loss applied per ten meters of active hose.",
                    label = "Friction loss PSI per 10 m",
                },
                hoseVehiclePumpHydraulicsHydrantIntakePressure = {
                    description = "Intake pressure in PSI supplied by a hydrant.",
                    label = "Hydrant intake pressure",
                },
                hoseVehiclePumpHydraulicsHydrantSupplyLitersPerSecond = {
                    description = "Maximum hydrant output in liters per second.",
                    label = "Hydrant output",
                },
                hoseVehiclePumpHydraulicsPumpIntakePressure = {
                    description = "Intake pressure in PSI supplied by a portable pump.",
                    label = "Pump intake pressure",
                },
                hoseVehiclePumpHydraulicsPumpSupplyGpm = {
                    description = "Maximum water flow supplied by a portable pump.",
                    label = "Pump supply GPM",
                },
                hoseVehiclePumpHydraulicsTankIntakePressure = {
                    description = "Intake pressure in PSI supplied by the vehicle tank.",
                    label = "Tank intake pressure",
                },
                hoseVehiclePumpHydraulicsTankSupplyGpm = {
                    description = "Maximum water flow supplied by the vehicle tank.",
                    label = "Tank supply GPM",
                },
                hoseVehicleTransferAllowExternalSource = {
                    description = "A source vehicle connected to hydrant or pump supply may fill the target without draining its own tank.",
                    label = "Allow external source",
                },
                hoseVehicleTransferConnectDistance = {
                    description = "Maximum distance from the player to connect a transfer line.",
                    label = "Connect distance",
                },
                hoseVehicleTransferDisconnectWhenSourceEmpty = {
                    description = "Automatically disconnect the transfer when the source tank is empty.",
                    label = "Stop when source empty",
                },
                hoseVehicleTransferDisconnectWhenTargetFull = {
                    description = "Automatically disconnect the transfer when the target tank is full.",
                    label = "Stop when target full",
                },
                hoseVehicleTransferEnabled = {
                    description = "Allows a hose line to transfer water from one fire vehicle tank to another.",
                    label = "Enable vehicle transfer",
                },
                hoseVehicleTransferLitersPerSecond = {
                    description = "Water moved from the source vehicle to the target vehicle each second.",
                    label = "Liters per second",
                },
                hoseVehicleTransferMaxLength = {
                    description = "Maximum distance allowed between the two connected vehicles.",
                    label = "Maximum line length",
                },
                hoseVehicleTransferRequireOnDuty = {
                    description = "Only on-duty firefighters can create vehicle water transfers.",
                    label = "Require on duty",
                },
                hoseVehicleTransferSourceDirectionX = {
                    description = "Configures: Source direction X.",
                    label = "Source direction X",
                },
                hoseVehicleTransferSourceDirectionY = {
                    description = "Configures: Source direction Y.",
                    label = "Source direction Y",
                },
                hoseVehicleTransferSourceDirectionZ = {
                    description = "Configures: Source direction Z.",
                    label = "Source direction Z",
                },
                hoseVehicleTransferSourceOffsetX = {
                    description = "Configures: Source X.",
                    label = "Source X",
                },
                hoseVehicleTransferSourceOffsetY = {
                    description = "Configures: Source Y.",
                    label = "Source Y",
                },
                hoseVehicleTransferSourceOffsetZ = {
                    description = "Configures: Source Z.",
                    label = "Source Z",
                },
                hoseVehicleTransferTargetDirectionX = {
                    description = "Configures: Target direction X.",
                    label = "Target direction X",
                },
                hoseVehicleTransferTargetDirectionY = {
                    description = "Configures: Target direction Y.",
                    label = "Target direction Y",
                },
                hoseVehicleTransferTargetDirectionZ = {
                    description = "Configures: Target direction Z.",
                    label = "Target direction Z",
                },
                hoseVehicleTransferTargetOffsetX = {
                    description = "Configures: Target X.",
                    label = "Target X",
                },
                hoseVehicleTransferTargetOffsetY = {
                    description = "Configures: Target Y.",
                    label = "Target Y",
                },
                hoseVehicleTransferTargetOffsetZ = {
                    description = "Configures: Target Z.",
                    label = "Target Z",
                },
                hoseVehicleTransferTickMs = {
                    description = "Server update interval for active transfer lines.",
                    label = "Transfer tick ms",
                },
                hoseVehicles = {
                    description = "Vehicle models with pump panels, tanks, and individually configurable intake and discharge connections.",
                    itemLabel = "Vehicle",
                    label = "Pump vehicles",
                },
                hoseWaterLitersPerSecond = {
                    description = "Water tank drain rate while spraying water without external supply.",
                    label = "Water liters per second",
                },
                hydrantConnection = {
                    description = "Configures: Hydrant connection.",
                    label = "Hydrant connection",
                },
                hydrantRx = {
                    description = "Configures: Hydrant RX.",
                    label = "Hydrant RX",
                },
                hydrantRy = {
                    description = "Configures: Hydrant RY.",
                    label = "Hydrant RY",
                },
                hydrantRz = {
                    description = "Configures: Hydrant RZ.",
                    label = "Hydrant RZ",
                },
                hydrantX = {
                    description = "Configures: Hydrant X.",
                    label = "Hydrant X",
                },
                hydrantY = {
                    description = "Configures: Hydrant Y.",
                    label = "Hydrant Y",
                },
                hydrantZ = {
                    description = "Configures: Hydrant Z.",
                    label = "Hydrant Z",
                },
                igniteDistance = {
                    description = "How close the player must be to this ignition source to plant the ignition.",
                    label = "Distance to plant ignition",
                },
                interiorExtinguishersAllowedJobs = {
                    description = "Leave empty to allow every job. Disable Require on duty to allow everyone to take and restock extinguishers.",
                    itemLabel = "Job",
                    label = "Allowed jobs",
                },
                interiorExtinguishersEmptyMountHeadingOffset = {
                    description = "Model-specific yaw correction applied to the empty mount.",
                    label = "Mount heading correction",
                },
                interiorExtinguishersEmptyMountModel = {
                    description = "Custom prop shown at the original position while the extinguisher is missing.",
                    label = "Empty mount model",
                },
                interiorExtinguishersEmptyMountOffsetX = {
                    description = "Local left/right offset after applying the prop rotation. Negative values move it left.",
                    label = "Mount offset X",
                },
                interiorExtinguishersEmptyMountOffsetY = {
                    description = "Local forward/backward offset after applying the prop rotation.",
                    label = "Mount offset Y",
                },
                interiorExtinguishersEmptyMountOffsetZ = {
                    description = "Local vertical offset after applying the prop rotation.",
                    label = "Mount offset Z",
                },
                interiorExtinguishersEmptyMountStreamDistance = {
                    description = "Distance within which empty extinguisher mounts are loaded.",
                    label = "Empty mount stream distance",
                },
                interiorExtinguishersEmptyThresholdPercent = {
                    description = "Fill percentage at or below which an extinguisher is empty.",
                    label = "Empty threshold percent",
                },
                interiorExtinguishersEnabled = {
                    description = "Allows firefighters to take configured extinguisher props from interiors.",
                    label = "Enable pickup",
                },
                interiorExtinguishersFullAmmo = {
                    description = "Raw weapon ammo that represents 100 percent fill for inventories without percentage metadata.",
                    label = "Full extinguisher ammo",
                },
                interiorExtinguishersInteractionDistance = {
                    description = "Maximum distance to press E on an extinguisher prop.",
                    label = "Pickup distance",
                },
                interiorExtinguishersItem = {
                    description = "Item or weapon added when an extinguisher is taken and consumed when a mount is restocked.",
                    label = "Inventory item",
                },
                interiorExtinguishersLabel = {
                    description = "Name shown in pickup and restock interactions.",
                    label = "Display label",
                },
                interiorExtinguishersMaintenanceAllowedJobs = {
                    description = "Additional jobs allowed to use extinguisher radial actions. Fire jobs are always included.",
                    itemLabel = "Job",
                    label = "Radial and maintenance jobs",
                },
                interiorExtinguishersMaintenanceEnabled = {
                    description = "Tracks empty and damaged extinguisher states.",
                    label = "Enable maintenance states",
                },
                interiorExtinguishersMaintenanceRequireOnDuty = {
                    description = "Requires allowed maintenance jobs to be on duty.",
                    label = "Require on duty",
                },
                interiorExtinguishersModels = {
                    description = "Interior object models that can be taken.",
                    itemLabel = "Model",
                    label = "Extinguisher prop models",
                },
                interiorExtinguishersNoDutyJobs = {
                    description = "Jobs in this list can take and restock extinguishers without being on duty.",
                    itemLabel = "Job",
                    label = "Jobs without duty",
                },
                interiorExtinguishersPickupDurationMs = {
                    description = "Animation and progress duration before the extinguisher is taken.",
                    label = "Pickup duration ms",
                },
                interiorExtinguishersPlacementAllowedJobs = {
                    description = "Leave empty to use the general extinguisher jobs or all configured Firejob jobs.",
                    itemLabel = "Job",
                    label = "Placement jobs",
                },
                interiorExtinguishersPlacementConsumeItem = {
                    description = "Removes exactly one mounting kit only after placement succeeds.",
                    label = "Consume item on placement",
                },
                interiorExtinguishersPlacementDynamic = {
                    description = "Enables physics for the placed extinguisher.",
                    label = "Dynamic prop",
                },
                interiorExtinguishersPlacementEnabled = {
                    description = "Lets authorized firefighters place extinguisher mounting kits in the world.",
                    label = "Enable placement",
                },
                interiorExtinguishersPlacementItem = {
                    description = "Inventory item that starts placement of a complete extinguisher mounting kit.",
                    label = "Placement item",
                },
                interiorExtinguishersPlacementModel = {
                    description = "Object model used for freely placed extinguishers.",
                    label = "Placed prop model",
                },
                interiorExtinguishersPlacementPickupDistance = {
                    description = "Maximum distance for removing a placed extinguisher.",
                    label = "Pickup distance",
                },
                interiorExtinguishersPlacementRequireOnDuty = {
                    description = "Only on-duty firefighters can place and remove extinguishers.",
                    label = "Require duty for placement",
                },
                interiorExtinguishersPlacementReturnItem = {
                    description = "Returns the mounting kit when its placed prop is removed.",
                    label = "Return item on pickup",
                },
                interiorExtinguishersPlacementStreamDistance = {
                    description = "Distance within which the placed extinguisher is loaded.",
                    label = "Stream distance",
                },
                interiorExtinguishersPlacementWallEnabled = {
                    description = "Aligns the extinguisher with vertical surfaces selected by the placement raycast.",
                    label = "Enable wall placement",
                },
                interiorExtinguishersPlacementWallHeadingOffset = {
                    description = "Rotates the extinguisher around its vertical axis after wall alignment.",
                    label = "Wall heading correction",
                },
                interiorExtinguishersPlacementWallOffset = {
                    description = "Moves the extinguisher away from the selected wall along its surface normal.",
                    label = "Wall distance",
                },
                interiorExtinguishersPlacementZOffset = {
                    description = "Vertical offset applied to the placed extinguisher.",
                    label = "Ground Z offset",
                },
                interiorExtinguishersRequireOnDuty = {
                    description = "Only allows on-duty members of an allowed job to take and restock extinguishers.",
                    label = "Require on duty",
                },
                interiorExtinguishersRestoreDistance = {
                    description = "Maximum distance to a taken mount while pressing E with an extinguisher item.",
                    label = "Restock distance",
                },
                interiorExtinguishersRestoreDurationMs = {
                    description = "Animation and progress duration before the extinguisher item is consumed.",
                    label = "Restock duration ms",
                },
                interiorExtinguishersScanDistance = {
                    description = "Object scan radius around the player.",
                    label = "Scan distance",
                },
                label = {
                    description = "Configures: Label.",
                    label = "Label",
                },
                lighterAnimationDict = {
                    description = "Animation dictionary used while planting the ignition.",
                    label = "Animation dict",
                },
                lighterAnimationDurationMs = {
                    description = "How long the ignition animation and progress action lasts before the ignition is planted.",
                    label = "Animation duration ms",
                },
                lighterAnimationFlag = {
                    description = "TaskPlayAnim flag used for the ignition animation.",
                    label = "Animation flag",
                },
                lighterAnimationName = {
                    description = "Animation clip used while planting the ignition.",
                    label = "Animation name",
                },
                lighterConsumeItem = {
                    description = "Consumes the configured lighter item after a successful ignition trigger.",
                    label = "Consume lighter item",
                },
                lighterCooldownSeconds = {
                    description = "Shared cooldown between lighter uses for props and vehicles.",
                    label = "Cooldown seconds",
                },
                lighterIgniteDelaySeconds = {
                    description = "Delay after successful ignition before the actual fire starts, giving the player time to run.",
                    label = "Ignition delay seconds",
                },
                lighterItem = {
                    description = "Inventory item used to plant ignitions on vehicles and other configured ignition sources.",
                    label = "Lighter item",
                },
                lighterVehicleEnabled = {
                    description = "Allow the lighter item to ignite nearby vehicles.",
                    label = "Enable vehicle ignition",
                },
                lighterVehicleMaxDistance = {
                    description = "Maximum distance to a vehicle for planting the ignition.",
                    label = "Vehicle ignition distance",
                },
                lighterVehicleOffsetX = {
                    description = "Local X offset used for the planted vehicle fire position.",
                    label = "Vehicle fire offset X",
                },
                lighterVehicleOffsetY = {
                    description = "Local Y offset used for the planted vehicle fire position.",
                    label = "Vehicle fire offset Y",
                },
                lighterVehicleOffsetZ = {
                    description = "Local Z offset used for the planted vehicle fire position.",
                    label = "Vehicle fire offset Z",
                },
                lighterVehicleRequireOnDuty = {
                    description = "Only allow vehicle ignition while the player is on duty in the configured fire job.",
                    label = "Require on-duty fire job",
                },
                lighterVehicleRequiredJobs = {
                    description = "If filled, vehicle ignition only works while the configured amount of specific jobs is online.",
                    itemLabel = "Job",
                    label = "Required online jobs",
                },
                lighterVehicleSourceScale = {
                    description = "Scale multiplier applied to fires that are started with the lighter on vehicles.",
                    label = "Vehicle fire scale",
                },
                npcFireReactionsCooldownMs = {
                    description = "Delay before the same NPC is allowed to react to a fire again.",
                    label = "NPC reaction cooldown ms",
                },
                npcFireReactionsDurationMs = {
                    description = "How long an active NPC reaction lasts before it expires.",
                    label = "NPC reaction duration ms",
                },
                npcFireReactionsEnabled = {
                    description = "Allows nearby ambient civilians to panic or film active fires.",
                    label = "Enable NPC fire reactions",
                },
                npcFireReactionsFilmChance = {
                    description = "Chance from 0.0 to 1.0 that a suitable NPC films instead of doing nothing.",
                    label = "Phone filming chance",
                },
                npcFireReactionsFilmEnabled = {
                    description = "Lets suitable civilians stop and record nearby fires with their phone.",
                    label = "Enable phone filming",
                },
                npcFireReactionsFilmRadius = {
                    description = "NPCs inside this distance may film the fire with their phone.",
                    label = "NPC filming radius",
                },
                npcFireReactionsFleeDistance = {
                    description = "How far panicking NPCs try to flee from the fire.",
                    label = "NPC flee distance",
                },
                npcFireReactionsMaxTrackedPeds = {
                    description = "Limits how many NPCs can be controlled by the reaction system at the same time.",
                    label = "Maximum reacting NPCs",
                },
                npcFireReactionsPanicEnabled = {
                    description = "Lets nearby civilians panic and run away when a fire gets too close.",
                    label = "Enable panic reactions",
                },
                npcFireReactionsPanicRadius = {
                    description = "NPCs inside this distance prefer panic and flee reactions.",
                    label = "NPC panic radius",
                },
                npcFireReactionsRadius = {
                    description = "Maximum distance from a fire at which an NPC can react at all.",
                    label = "NPC reaction radius",
                },
                npcFireReactionsUpdateInterval = {
                    description = "How often the system scans for suitable NPCs around active fires.",
                    label = "NPC reaction update interval ms",
                },
                npcRescueAnimalEntrapmentEnabled = {
                    description = "Configures: Animal entrapment.",
                    label = "Animal entrapment",
                },
                npcRescueAnimalEntrapmentPanicChance = {
                    description = "Configures: Entrapped animal panic chance.",
                    label = "Entrapped animal panic chance",
                },
                npcRescueAnimalTreeEnabled = {
                    description = "Configures: Animal in tree / height.",
                    label = "Animal in tree / height",
                },
                npcRescueAnimalTreePanicChance = {
                    description = "Configures: Tree animal panic chance.",
                    label = "Tree animal panic chance",
                },
                npcRescueAnimalWaterEnabled = {
                    description = "Configures: Animal water rescue.",
                    label = "Animal water rescue",
                },
                npcRescueAnimalWaterPanicChance = {
                    description = "Configures: Water animal panic chance.",
                    label = "Water animal panic chance",
                },
                npcRescueBicycleEnabled = {
                    description = "Configures: Rural bicycle accident.",
                    label = "Rural bicycle accident",
                },
                npcRescueDropoffRadius = {
                    description = "Distance required to hand a rescued patient to the ambulance.",
                    label = "Dropoff radius",
                },
                npcRescueEnabled = {
                    description = "Enable NPC rescue missions and task flows.",
                    label = "Enabled",
                },
                npcRescueFieldExtractionDurationMs = {
                    description = "Configures: Default rescue/extraction duration ms.",
                    label = "Default rescue/extraction duration ms",
                },
                npcRescueFieldStabilizationDurationMs = {
                    description = "Configures: Default stabilization duration ms.",
                    label = "Default stabilization duration ms",
                },
                npcRescueForestEnabled = {
                    description = "Configures: Forest injury / forest rescue.",
                    label = "Forest injury / forest rescue",
                },
                npcRescueRubbleEnabled = {
                    description = "Configures: Rubble entrapment / rubble rescue.",
                    label = "Rubble entrapment / rubble rescue",
                },
                npcRescueSearchRadius = {
                    description = "Search radius used for non-vehicle rescue scenes.",
                    label = "Search radius",
                },
                oilAbsorbentBrushRadius = {
                    description = "Radius of each absorbent spread stroke in the absorbent minigame.",
                    label = "Spread radius",
                },
                oilAbsorbentGranulesPerMove = {
                    description = "How many absorbent granules are spawned per valid movement step.",
                    label = "Granules per move",
                },
                oilAbsorbentMinigameEnabled = {
                    description = "Replaces the simple bind action with the absorbent spreading minigame.",
                    label = "Enable absorbent minigame",
                },
                oilAbsorbentRequiredCoverage = {
                    description = "How much of the spill must be covered before the absorbent phase succeeds.",
                    label = "Required coverage",
                },
                oilCleanupAbsorbentItem = {
                    description = "Inventory item required for the absorbent phase of oil cleanup.",
                    label = "Absorbent item",
                },
                oilCleanupAllowedJobs = {
                    description = "Jobs in this whitelist may clean oil spills in addition to jobs configured in this Firejob.",
                    label = "Additional allowed jobs",
                },
                oilCleanupBindDurationMs = {
                    description = "Fallback progress duration if the absorbent minigame is disabled.",
                    label = "Fallback bind duration ms",
                },
                oilCleanupBroomItem = {
                    description = "Inventory item required for sweeping up a bound spill.",
                    label = "Sweep item",
                },
                oilCleanupConsumeAbsorbent = {
                    description = "Consumes one absorbent item on successful use.",
                    label = "Consume absorbent",
                },
                oilCleanupConsumeBroom = {
                    description = "Consumes the configured sweep item after successful cleanup.",
                    label = "Consume sweep item",
                },
                oilCleanupRequireOnDuty = {
                    description = "Members of every allowed cleanup job must be on duty.",
                    label = "Require on duty",
                },
                oilCleanupSweepDurationMs = {
                    description = "Fallback progress duration if the sweep minigame is disabled.",
                    label = "Fallback sweep duration ms",
                },
                oilSpillsActive = {
                    description = "Live list of active oil spills with teleport and delete actions.",
                    label = "Active oil spills",
                },
                oilSpillsDefaultIntensity = {
                    description = "Default hazard intensity used for newly created oil spills.",
                    label = "Default intensity",
                },
                oilSpillsDeleteOnRestart = {
                    description = "Deletes stored oil spills on resource start instead of restoring them.",
                    label = "Delete on restart",
                },
                oilSpillsEnabled = {
                    description = "Enables oil puddles, slipping and cleanup. Automatic spills after collisions or from wear require Sky Mechanic or another connected resource.",
                    label = "Enable oil spill system",
                },
                oilSpillsInteractionDistance = {
                    description = "Distance required to interact with and clean up a spill.",
                    label = "Interaction distance",
                },
                oilSpillsLifetimeMinutes = {
                    description = "How long unremoved oil spills stay active before expiring.",
                    label = "Lifetime minutes",
                },
                oilSpillsMaxActive = {
                    description = "Maximum number of synchronized oil spills that may exist at once.",
                    label = "Maximum active spills",
                },
                oilSpillsObjectGroundOffset = {
                    description = "Ground offset applied to spill props to match the street surface better.",
                    label = "Object ground offset",
                },
                oilSpillsRemoveBelow = {
                    description = "Spills are removed automatically once their intensity drops below this value.",
                    label = "Remove below intensity",
                },
                oilSpillsResetIds = {
                    buttonLabel = "Reset IDs",
                    description = "Renumbers all active oil spills from 1 without gaps and synchronizes every player.",
                    label = "Reset oil spill IDs",
                },
                oilSpillsSlipRadius = {
                    description = "Radius in which players and peds can slip on the spill.",
                    label = "Slip radius",
                },
                oilSweepBrushRadius = {
                    description = "Radius around the broom stroke that contributes sweep progress.",
                    label = "Sweep radius",
                },
                oilSweepMaxSidewaysRatio = {
                    description = "Maximum sideways movement ratio allowed before a sweep stroke is ignored.",
                    label = "Sideways tolerance",
                },
                oilSweepMinStrokeDistance = {
                    description = "Minimum cursor distance required before a sweep stroke can add progress.",
                    label = "Minimum stroke distance",
                },
                oilSweepMinUpwardDelta = {
                    description = "Minimum upward movement required for a valid broom stroke.",
                    label = "Minimum upward movement",
                },
                oilSweepMinigameEnabled = {
                    description = "Replaces the simple sweep progress bar with the broom minigame.",
                    label = "Enable sweep minigame",
                },
                oilSweepRequiredProgress = {
                    description = "Progress from 0.0 to 1.0 required before the bound spill is cleaned.",
                    label = "Required sweep progress",
                },
                oilSweepToolWidth = {
                    description = "Displayed broom image width in the sweep minigame.",
                    label = "Broom image width",
                },
                playerEntrapmentAllowOffDuty = {
                    description = "Also counts the configured off-duty counterpart of a required job when checking the minimum online staff.",
                    label = "Count off-duty jobs",
                },
                playerEntrapmentAutoReleaseWhenRepaired = {
                    description = "Configures: Release when repaired.",
                    label = "Release when repaired",
                },
                playerEntrapmentBaseChance = {
                    description = "Configures: Base chance.",
                    label = "Base chance",
                },
                playerEntrapmentCooldownSeconds = {
                    description = "Configures: Cooldown seconds.",
                    label = "Cooldown seconds",
                },
                playerEntrapmentDoorOverviewEnabled = {
                    description = "Shows a small vehicle with damaged, opened and usable exit doors in the trapped HUD.",
                    label = "Show door overview",
                },
                playerEntrapmentEnabled = {
                    description = "Players can become trapped after sufficient vehicle damage or a rollover.",
                    label = "Enable player entrapment",
                },
                playerEntrapmentHudEnabled = {
                    description = "Configures: Show trapped HUD.",
                    label = "Show trapped HUD",
                },
                playerEntrapmentMinBodyHealthLoss = {
                    description = "Minimum body health lost in one collision before entrapment can trigger. Lower values trigger more easily.",
                    label = "Minimum body damage",
                },
                playerEntrapmentMinEngineHealthLoss = {
                    description = "Minimum engine health lost in one collision before entrapment can trigger. Lower values trigger more easily.",
                    label = "Minimum engine damage",
                },
                playerEntrapmentPreventExit = {
                    description = "Configures: Block leaving vehicle.",
                    label = "Block leaving vehicle",
                },
                playerEntrapmentReleaseOnAnyDoor = {
                    description = "Configures: Release after any opened door.",
                    label = "Release after any opened door",
                },
                playerEntrapmentRepairedBodyHealthThreshold = {
                    description = "Configures: Repair body threshold.",
                    label = "Repair body threshold",
                },
                playerEntrapmentRepairedEngineHealthThreshold = {
                    description = "Configures: Repair engine threshold.",
                    label = "Repair engine threshold",
                },
                playerEntrapmentRepairedMaxRoll = {
                    description = "Configures: Repair max roll.",
                    label = "Repair max roll",
                },
                playerEntrapmentRequiredJobs = {
                    description = "If entries are present here, vehicle entrapment only triggers while the configured amount of specific jobs is online.",
                    itemLabel = "Job",
                    label = "Required online jobs",
                },
                playerEntrapmentRolloverBonusChance = {
                    description = "Configures: Rollover bonus chance.",
                    label = "Rollover bonus chance",
                },
                playerEntrapmentRolloverMinRoll = {
                    description = "Configures: Rollover threshold.",
                    label = "Rollover threshold",
                },
                propIgnitionDuplicateDistance = {
                    description = "Prevents planting another ignition too close to an existing fire.",
                    label = "Minimum distance to existing fire",
                },
                propIgnitionEnabled = {
                    description = "Allows selected objects and fixed ignition sources to be used for planted ignitions with the lighter.",
                    label = "Enable object ignition points",
                },
                propIgnitionHighlightEnabled = {
                    description = "Marks matching ignition sources with an outline while the lighter search is active.",
                    label = "Highlight ignition points",
                },
                propIgnitionMaxActiveFires = {
                    description = "Maximum number of active fires that may exist at once from these ignition points.",
                    label = "Maximum active object fires",
                },
                propIgnitionProps = {
                    description = "Object models or fixed ignition sources where a planted ignition may be used.",
                    itemLabel = "Ignition source",
                    label = "Possible ignition sources",
                },
                propIgnitionRequireLineOfSight = {
                    description = "Only ignition points with a clear line of sight may be highlighted and used.",
                    label = "Require clear line of sight",
                },
                propIgnitionScanDistance = {
                    description = "Radius in which possible ignition points in the area are detected.",
                    label = "Ignition search radius",
                },
                propIgnitionScanDurationMs = {
                    description = "How long detected ignition points remain highlighted before the search closes automatically.",
                    label = "Highlight duration ms",
                },
                pumpDischargeCount = {
                    description = "Configures: Pump discharges.",
                    label = "Pump discharges",
                },
                rescueCushionAllowedJobs = {
                    description = "Leave empty to allow all configured fire jobs to place the rescue cushion item.",
                    itemLabel = "Job",
                    label = "Allowed jobs",
                },
                rescueCushionConsumeItem = {
                    description = "Removes one rescue cushion item from inventory when it is placed.",
                    label = "Consume item on place",
                },
                rescueCushionEnabled = {
                    description = "Turns the rescue cushion system on or off completely.",
                    label = "Enable rescue cushion",
                },
                rescueCushionItem = {
                    description = "Inventory item used to place the rescue cushion.",
                    label = "Item name",
                },
                rescueCushionLabel = {
                    description = "Display name shown for the placed rescue cushion prop.",
                    label = "Label",
                },
                rescueCushionLandingHeight = {
                    description = "Maximum height difference above the cushion at which the landing protection still applies.",
                    label = "Landing height",
                },
                rescueCushionLandingRadius = {
                    description = "Horizontal radius around the cushion in which falling players are protected.",
                    label = "Landing radius",
                },
                rescueCushionModel = {
                    description = "World prop model that gets spawned when the cushion is placed.",
                    label = "Prop model",
                },
                rescueCushionPickupDistance = {
                    description = "How close a player must be to pick the placed rescue cushion back up.",
                    label = "Pickup distance",
                },
                rescueCushionRequireOnDuty = {
                    description = "Only allows on-duty firefighters to place the rescue cushion item.",
                    label = "Require on duty",
                },
                rescueCushionReturnItemOnRemove = {
                    description = "Returns the configured item to the player when the placed cushion is picked up.",
                    label = "Give item back on pickup",
                },
                rescueCushionStreamDistance = {
                    description = "Distance at which the placed rescue cushion prop starts streaming to nearby players.",
                    label = "Stream distance",
                },
                rescueCushionZOffset = {
                    description = "Vertical placement offset applied to the spawned rescue cushion prop.",
                    label = "Placement Z offset",
                },
                rx = {
                    description = "Configures: RX.",
                    label = "RX",
                },
                ry = {
                    description = "Configures: RY.",
                    label = "RY",
                },
                rz = {
                    description = "Configures: RZ.",
                    label = "RZ",
                },
                scbaHudPosition = {
                    description = "Position of the SCBA manometer HUD.",
                    label = "Manometer position",
                },
                scenarioAutomaticMissions = {
                    description = "Enable automatic starts per mission, set the required number of on-duty members, choose the duty jobs counted for that mission, and choose which jobs receive its dispatch. Empty lists use the global duty or dispatch jobs.",
                    itemLabel = "Mission",
                    label = "Available missions",
                },
                scenarioCreatorAllowRescue = {
                    description = "Allow the mission creator to place patient and animal rescue tasks.",
                    label = "Rescue tab",
                },
                scenarioCreatorAllowVehicleFire = {
                    description = "Allow the mission creator to place configured burning vehicles.",
                    label = "Vehicle fire tab",
                },
                scenarioCreatorEnabled = {
                    description = "Enable the fire mission creator and hub tooling.",
                    label = "Enabled",
                },
                scenarioCreatorOpenMenu = {
                    buttonLabel = "Open Mission Creator",
                    description = "Open the Sky Fire Mission Creator menu and close the Job Configurator.",
                    label = "Mission Creator Menu",
                    unsavedTooltip = "Save first",
                },
                scenarioDispatchEnabled = {
                    description = "Creates a sky_jobs_base dispatch when a mission is started.",
                    label = "Send dispatch",
                },
                scenarioDispatchJobs = {
                    description = "Used when a mission has no mission-specific dispatch jobs.",
                    itemLabel = "Job",
                    label = "Dispatch target jobs",
                },
                scenarioRandomChance = {
                    description = "Chance per interval from 0.0 to 1.0.",
                    label = "Trigger chance",
                },
                scenarioRandomEnabled = {
                    description = "Automatically starts an enabled mission after the configured interval.",
                    label = "Enable automatic missions",
                },
                scenarioRandomSelectionMode = {
                    description = "Random rotation starts every currently eligible mission once before repeating. Pure random allows repeats.",
                    label = "Mission selection",
                    options = {
                        rotation = "Random rotation",
                        random = "Pure random",
                    },
                },
                scenarioRandomIntervalMax = {
                    description = "Configures: Maximum interval minutes.",
                    label = "Maximum interval minutes",
                },
                scenarioRandomIntervalMin = {
                    description = "Configures: Minimum interval minutes.",
                    label = "Minimum interval minutes",
                },
                scenarioRandomJobs = {
                    description = "On-duty players in these jobs count when the selected mission has no mission-specific jobs.",
                    itemLabel = "Job",
                    label = "Default duty jobs",
                },
                scenarioRandomManualOnly = {
                    description = "Configures: Manual-only missions.",
                    label = "Manual-only missions",
                },
                smokePoisoningEnabled = {
                    description = "Turns smoke exposure, poisoning and related smoke effects on or off.",
                    label = "Enable smoke poisoning",
                },
                smokeVehicleClosedExposureMultiplier = {
                    description = "Smoke exposure multiplier while all relevant side windows are still intact.",
                    label = "Closed vehicle smoke multiplier",
                },
                smokeVehicleExposureMultiplier = {
                    description = "Smoke exposure multiplier once a protected vehicle loses its window protection or for unprotected vehicle types.",
                    label = "Broken or open vehicle smoke multiplier",
                },
                smokeVehicleProtectAutomobiles = {
                    description = "Configures: Protect automobiles.",
                    label = "Protect automobiles",
                },
                smokeVehicleProtectBoats = {
                    description = "Configures: Protect boats.",
                    label = "Protect boats",
                },
                smokeVehicleProtectCycles = {
                    description = "Configures: Protect cycles.",
                    label = "Protect cycles",
                },
                smokeVehicleProtectHelicopters = {
                    description = "Configures: Protect helicopters.",
                    label = "Protect helicopters",
                },
                smokeVehicleProtectMotorcycles = {
                    description = "Configures: Protect motorcycles.",
                    label = "Protect motorcycles",
                },
                smokeVehicleProtectPlanes = {
                    description = "Configures: Protect planes.",
                    label = "Protect planes",
                },
                smokeVehicleProtectionEnabled = {
                    description = "Lets configured vehicle types shield occupants from smoke while the vehicle stays sealed.",
                    label = "Enable vehicle smoke protection",
                },
                smokeWarningHudPosition = {
                    description = "Position of the smoke poisoning HUD bar.",
                    label = "Smoke poisoning bar position",
                },
                societyRewardFireEnabled = {
                    description = "Global switch for society payouts after a fire is extinguished.",
                    label = "Enable fire payouts",
                },
                societyRewardFireJobs = {
                    description = "Configure each job separately with its own enabled state and payout amount. Enter the job name; its configured society account receives the money.",
                    itemLabel = "Job",
                    label = "Fire reward jobs",
                },
                societyRewardFireScenarioEnabled = {
                    description = "Also pays the fire reward when a fire belonging to a Mission Creator mission is extinguished.",
                    label = "Pay mission fires",
                },
                societyRewardOilEnabled = {
                    description = "Global switch for society payouts after an oil spill is cleaned.",
                    label = "Enable oil payouts",
                },
                societyRewardOilJobs = {
                    description = "Configure each job separately with its own enabled state and payout amount. Enter the job name; its configured society account receives the money.",
                    itemLabel = "Job",
                    label = "Oil reward jobs",
                },
                societyRewardOilScenarioEnabled = {
                    description = "Also pays the oil reward when an oil spill belonging to a Mission Creator mission is cleaned.",
                    label = "Pay mission oil spills",
                },
                societyRewardRescueEnabled = {
                    description = "Global switch for society payouts after a rescue task is completed.",
                    label = "Enable rescue payouts",
                },
                societyRewardRescueJobs = {
                    description = "Configure each job separately with its own enabled state and payout amount. Enter the job name; its configured society account receives the money.",
                    itemLabel = "Job",
                    label = "Rescue reward jobs",
                },
                societyRewardRescueScenarioEnabled = {
                    description = "Also pays the rescue reward when a rescue task belonging to a Mission Creator mission is completed.",
                    label = "Pay mission rescues",
                },
                societyRewardTreeEnabled = {
                    description = "Global switch for society payouts after a fallen tree is cleared.",
                    label = "Enable tree payouts",
                },
                societyRewardTreeJobs = {
                    description = "Configure each job separately with its own enabled state and payout amount. Enter the job name; its configured society account receives the money.",
                    itemLabel = "Job",
                    label = "Tree reward jobs",
                },
                societyRewardTreeScenarioEnabled = {
                    description = "Also pays the tree reward when a fallen tree belonging to a Mission Creator mission is cleared.",
                    label = "Pay mission trees",
                },
                sourceScale = {
                    description = "Scale multiplier applied to the fire created at this ignition source.",
                    label = "Resulting fire size",
                },
                textures = {
                    description = "Configures: Textures.",
                    label = "Textures",
                },
                trappedRescueAllowAnyDoor = {
                    description = "Configures: Allow any removed door.",
                    label = "Allow any removed door",
                },
                trappedRescueAllowCarry = {
                    description = "Configures: Allow carrying rescued person.",
                    label = "Allow carrying rescued person",
                },
                trappedRescueAllowDrop = {
                    description = "Configures: Allow putting person down.",
                    label = "Allow putting person down",
                },
                trappedRescueAmbulanceFreeze = {
                    description = "Configures: Freeze ambulance.",
                    label = "Freeze ambulance",
                },
                trappedRescueAmbulanceInvincible = {
                    description = "Configures: Invincible ambulance.",
                    label = "Invincible ambulance",
                },
                trappedRescueAmbulanceLights = {
                    description = "Configures: Enable emergency lights.",
                    label = "Enable emergency lights",
                },
                trappedRescueAmbulanceOpenRearDoors = {
                    description = "Configures: Open rear doors.",
                    label = "Open rear doors",
                },
                trappedRescueDropoffRadius = {
                    description = "Configures: Ambulance dropoff radius.",
                    label = "Ambulance dropoff radius",
                },
                trappedRescueEnabled = {
                    description = "Enables scenario based person and animal rescue tasks.",
                    label = "Enable NPC rescue tasks",
                },
                trappedRescueExtractionDurationMs = {
                    description = "Configures: Vehicle extraction duration ms.",
                    label = "Vehicle extraction duration ms",
                },
                trappedRescueForceGain = {
                    description = "Configures: Force gain per second.",
                    label = "Force gain per second",
                },
                trappedRescueForceLoss = {
                    description = "Configures: Force loss per second.",
                    label = "Force loss per second",
                },
                trappedRescueForceMax = {
                    description = "Configures: Good pull maximum.",
                    label = "Good pull maximum",
                },
                trappedRescueForceMin = {
                    description = "Configures: Good pull minimum.",
                    label = "Good pull minimum",
                },
                trappedRescueInteractionDistance = {
                    description = "Configures: NPC interaction distance.",
                    label = "NPC interaction distance",
                },
                trappedRescueJamChance = {
                    description = "Configures: Buckle jam chance.",
                    label = "Buckle jam chance",
                },
                trappedRescueMaxMisses = {
                    description = "Configures: Allowed failed pulls.",
                    label = "Allowed failed pulls",
                },
                trappedRescuePullsRequired = {
                    description = "Configures: Required strong pulls.",
                    label = "Required strong pulls",
                },
                trappedRescueReliefHoldMs = {
                    description = "Configures: Tension hold time ms.",
                    label = "Tension hold time ms",
                },
                trappedRescueReliefZoneMax = {
                    description = "Configures: Tension zone maximum.",
                    label = "Tension zone maximum",
                },
                trappedRescueReliefZoneMin = {
                    description = "Configures: Tension zone minimum.",
                    label = "Tension zone minimum",
                },
                trappedRescueRequireDoor = {
                    description = "Configures: Require removed door.",
                    label = "Require removed door",
                },
                trappedRescueRequireGlass = {
                    description = "Configures: Require broken window.",
                    label = "Require broken window",
                },
                trappedRescueRequireMatchingSide = {
                    description = "Configures: Window must match patient side.",
                    label = "Window must match patient side",
                },
                trappedRescueRequireOnDuty = {
                    description = "Configures: Require on duty.",
                    label = "Require on duty",
                },
                trappedRescueSeatbeltDurationMs = {
                    description = "Configures: Time limit ms.",
                    label = "Time limit ms",
                },
                trappedRescueSeatbeltEnabled = {
                    description = "Configures: Enable seatbelt minigame.",
                    label = "Enable seatbelt minigame",
                },
                treeBlipColor = {
                    description = "Configures: Blip color.",
                    label = "Blip color",
                },
                treeBlipLabel = {
                    description = "Configures: Blip label.",
                    label = "Blip label",
                },
                treeBlipScale = {
                    description = "Configures: Blip scale.",
                    label = "Blip scale",
                },
                treeBlipSprite = {
                    description = "Configures: Blip sprite.",
                    label = "Blip sprite",
                },
                treeCarryAnimDict = {
                    description = "Configures: Carry animation dictionary.",
                    label = "Carry animation dictionary",
                },
                treeCarryAnimFlag = {
                    description = "Configures: Carry animation flag.",
                    label = "Carry animation flag",
                },
                treeCarryAnimName = {
                    description = "Configures: Carry animation name.",
                    label = "Carry animation name",
                },
                treeCarryMoveBlend = {
                    description = "Configures: Carry movement blend.",
                    label = "Carry movement blend",
                },
                treeCarryOffsetRx = {
                    description = "Configures: Carry rotation X.",
                    label = "Carry rotation X",
                },
                treeCarryOffsetRy = {
                    description = "Configures: Carry rotation Y.",
                    label = "Carry rotation Y",
                },
                treeCarryOffsetRz = {
                    description = "Configures: Carry rotation Z.",
                    label = "Carry rotation Z",
                },
                treeCarryOffsetX = {
                    description = "Configures: Carry offset X.",
                    label = "Carry offset X",
                },
                treeCarryOffsetY = {
                    description = "Configures: Carry offset Y.",
                    label = "Carry offset Y",
                },
                treeCarryOffsetZ = {
                    description = "Configures: Carry offset Z.",
                    label = "Carry offset Z",
                },
                treeCarryProp = {
                    description = "Configures: Carried prop model.",
                    label = "Carried prop model",
                },
                treeCarryPropBone = {
                    description = "Configures: Carry bone.",
                    label = "Carry bone",
                },
                treeDispatchEnabled = {
                    description = "Configures: Send tree dispatch.",
                    label = "Send tree dispatch",
                },
                treeDispatchJobs = {
                    description = "Configures: Dispatch target jobs.",
                    itemLabel = "Job",
                    label = "Dispatch target jobs",
                },
                treeDropCleanupRadius = {
                    description = "Delivered logs are removed when no player remains within this range.",
                    label = "Cleanup range",
                },
                treeDropMarkerA = {
                    description = "Configures: Marker alpha.",
                    label = "Marker alpha",
                },
                treeDropMarkerB = {
                    description = "Configures: Marker blue.",
                    label = "Marker blue",
                },
                treeDropMarkerG = {
                    description = "Configures: Marker green.",
                    label = "Marker green",
                },
                treeDropMarkerHeight = {
                    description = "Configures: Marker height.",
                    label = "Marker height",
                },
                treeDropMarkerR = {
                    description = "Configures: Marker red.",
                    label = "Marker red",
                },
                treeDropMarkerType = {
                    description = "Configures: Marker type.",
                    label = "Marker type",
                },
                treeDropOffsetX = {
                    description = "Local sideways offset from the fallen tree.",
                    label = "Drop-off offset X",
                },
                treeDropOffsetY = {
                    description = "Local offset along the tree heading.",
                    label = "Drop-off offset Y",
                },
                treeDropOffsetZ = {
                    description = "Vertical drop-off offset.",
                    label = "Drop-off offset Z",
                },
                treeDropRadius = {
                    description = "Configures: Drop-off radius.",
                    label = "Drop-off radius",
                },
                treeEnabled = {
                    description = "Configures: Enable fallen tree incidents.",
                    label = "Enable fallen tree incidents",
                },
                treeInteractionDistance = {
                    description = "Configures: Interaction distance.",
                    label = "Interaction distance",
                },
                treeInteractionOffsetX = {
                    description = "Local sideways offset from the tree model.",
                    label = "Saw point offset X",
                },
                treeInteractionOffsetY = {
                    description = "Local lengthwise offset from the tree model.",
                    label = "Saw point offset Y",
                },
                treeInteractionOffsetZ = {
                    description = "Vertical offset from the tree model.",
                    label = "Saw point offset Z",
                },
                treeMarkerA = {
                    description = "Configures: Marker alpha.",
                    label = "Marker alpha",
                },
                treeMarkerB = {
                    description = "Configures: Marker blue.",
                    label = "Marker blue",
                },
                treeMarkerG = {
                    description = "Configures: Marker green.",
                    label = "Marker green",
                },
                treeMarkerHeight = {
                    description = "Configures: Marker height.",
                    label = "Marker height",
                },
                treeMarkerR = {
                    description = "Configures: Marker red.",
                    label = "Marker red",
                },
                treeMarkerSize = {
                    description = "Configures: Marker size.",
                    label = "Marker size",
                },
                treeMarkerType = {
                    description = "Configures: Marker type.",
                    label = "Marker type",
                },
                treePickupDistance = {
                    description = "Configures: Pickup distance.",
                    label = "Pickup distance",
                },
                treePieceCount = {
                    description = "Configures: Number of log pieces.",
                    label = "Number of log pieces",
                },
                treePieceModel = {
                    description = "Configures: Log piece model.",
                    label = "Log piece model",
                },
                treePieceSpacing = {
                    description = "Configures: Log piece spacing.",
                    label = "Log piece spacing",
                },
                treePropModel = {
                    description = "Object model spawned for the fallen tree.",
                    label = "Fallen tree model",
                },
                treeRequireOnDuty = {
                    description = "Configures: Require on duty.",
                    label = "Require on duty",
                },
                treeSawAnimDict = {
                    description = "Configures: Animation dictionary.",
                    label = "Animation dictionary",
                },
                treeSawAnimFlag = {
                    description = "Configures: Animation flag.",
                    label = "Animation flag",
                },
                treeSawAnimName = {
                    description = "Configures: Animation name.",
                    label = "Animation name",
                },
                treeSawCollision = {
                    description = "Configures: Enable prop collision.",
                    label = "Enable prop collision",
                },
                treeSawIsPed = {
                    description = "Configures: Attach to ped.",
                    label = "Attach to ped",
                },
                treeSawOffsetRx = {
                    description = "Configures: Chainsaw rotation X.",
                    label = "Chainsaw rotation X",
                },
                treeSawOffsetRy = {
                    description = "Configures: Chainsaw rotation Y.",
                    label = "Chainsaw rotation Y",
                },
                treeSawOffsetRz = {
                    description = "Configures: Chainsaw rotation Z.",
                    label = "Chainsaw rotation Z",
                },
                treeSawOffsetX = {
                    description = "Configures: Chainsaw offset X.",
                    label = "Chainsaw offset X",
                },
                treeSawOffsetY = {
                    description = "Configures: Chainsaw offset Y.",
                    label = "Chainsaw offset Y",
                },
                treeSawOffsetZ = {
                    description = "Configures: Chainsaw offset Z.",
                    label = "Chainsaw offset Z",
                },
                treeSawProp = {
                    description = "Configures: Chainsaw prop model.",
                    label = "Chainsaw prop model",
                },
                treeSawPropBone = {
                    description = "Configures: Chainsaw bone.",
                    label = "Chainsaw bone",
                },
                treeSawRotationOrder = {
                    description = "Configures: Rotation order.",
                    label = "Rotation order",
                },
                treeSawSections = {
                    description = "Configures: Required saw sections.",
                    label = "Required saw sections",
                },
                treeSawSoftPinning = {
                    description = "Configures: Use soft pinning.",
                    label = "Use soft pinning",
                },
                treeSawSyncRotation = {
                    description = "Configures: Synchronize rotation.",
                    label = "Synchronize rotation",
                },
                treeSpawnRange = {
                    description = "The networked tree spawns when a player enters this range.",
                    label = "Spawn range",
                },
                vehicleFiresBurnDamageBreakWindows = {
                    description = "Configures: Break windows at full fire.",
                    label = "Break windows at full fire",
                },
                vehicleFiresBurnDamageBurstTyres = {
                    description = "Configures: Burst tyres at full fire.",
                    label = "Burst tyres at full fire",
                },
                vehicleFiresBurnDamageDeformation = {
                    description = "Configures: Visual deformation strength.",
                    label = "Visual deformation strength",
                },
                vehicleFiresBurnDamageEnabled = {
                    description = "Gradually damages and deforms the actual burning vehicle before the delayed explosion.",
                    label = "Damage vehicle while burning",
                },
                vehicleFiresBurnDamageFullBodyHealth = {
                    description = "Configures: Body health at full fire.",
                    label = "Body health at full fire",
                },
                vehicleFiresBurnDamageIntervalSeconds = {
                    description = "Seconds between additional damage ticks during the full-fire stage.",
                    label = "Full-fire damage interval",
                },
                vehicleFiresBurnDamageMinimumBodyHealth = {
                    description = "Configures: Minimum body health before explosion.",
                    label = "Minimum body health before explosion",
                },
                vehicleFiresBurnDamagePerTick = {
                    description = "Configures: Body damage per interval.",
                    label = "Body damage per interval",
                },
                vehicleFiresBurnDamageSmallBodyHealth = {
                    description = "Configures: Body health at small fire.",
                    label = "Body health at small fire",
                },
                vehicleFiresCanExtinguishFoam = {
                    description = "Allows foam from a hose or vehicle supply to extinguish this vehicle fire material.",
                    label = "Extinguishable with foam",
                },
                vehicleFiresCanExtinguishWater = {
                    description = "Allows hose water, vehicle water cannons and helicopter bucket water to extinguish this vehicle fire material.",
                    label = "Extinguishable with water",
                },
                vehicleFiresCanExtinguishWaterMonitor = {
                    description = "Allows the portable Water Monitor to extinguish this vehicle fire material.",
                    label = "Extinguishable with Water Monitor",
                },
                vehicleFiresDuplicateDistance = {
                    description = "Prevents creating another vehicle fire too close to an existing one.",
                    label = "Duplicate distance",
                },
                vehicleFiresEnabled = {
                    description = "Enable the vehicle fire system.",
                    label = "Enabled",
                },
                vehicleFiresEngineHealth = {
                    description = "Kept at 300 or higher to prevent GTA's native vehicle fire and premature explosion.",
                    label = "Engine health while burning",
                },
                vehicleFiresEngineOff = {
                    description = "Configures: Switch engine off.",
                    label = "Switch engine off",
                },
                vehicleFiresExplosionCameraShake = {
                    description = "Configures: Camera shake.",
                    label = "Camera shake",
                },
                vehicleFiresExplosionDamageScale = {
                    description = "Configures: Explosion damage scale.",
                    label = "Explosion damage scale",
                },
                vehicleFiresExplosionDelaySeconds = {
                    description = "Seconds before a burning vehicle explodes.",
                    label = "Explosion delay seconds",
                },
                vehicleFiresExplosionEnabled = {
                    description = "Vehicles do not explode instantly; this controls the optional delayed explosion.",
                    label = "Enable delayed explosion",
                },
                vehicleFiresExplosionPostBurnSeconds = {
                    description = "Seconds the destroyed vehicle continues burning after it explodes.",
                    label = "Burn duration after explosion",
                },
                vehicleFiresExplosionRemoveFire = {
                    description = "Removes the fire after the configured post-explosion burn duration. Disable for an unlimited wreck fire.",
                    label = "Remove fire after post-burn",
                },
                vehicleFiresExplosionType = {
                    description = "Configures: Explosion type.",
                    label = "Explosion type",
                },
                vehicleFiresExternalAllowedResources = {
                    description = "Resources allowed to create vehicle fires through the external hook.",
                    itemLabel = "Resource",
                    label = "Allowed resources",
                },
                vehicleFiresExternalEnabled = {
                    description = "Allow mechanicjob or approved scripts to create Firejob vehicle fires.",
                    label = "Enable external creation",
                },
                vehicleFiresExternalMaxSourceDistance = {
                    description = "Maximum distance between external trigger coordinates and the vehicle.",
                    label = "Maximum source distance",
                },
                vehicleFiresFireType = {
                    description = "Fire source type used when a vehicle fire is created.",
                    label = "Fire type",
                },
                vehicleFiresFoamEffectiveness = {
                    description = "Higher values make foam extinguish vehicle fires faster.",
                    label = "Foam effectiveness",
                },
                vehicleFiresKeepUndriveable = {
                    description = "Configures: Keep vehicle undriveable.",
                    label = "Keep vehicle undriveable",
                },
                vehicleFiresManualConsumeItem = {
                    description = "Configures: Consume lighter item.",
                    label = "Consume lighter item",
                },
                vehicleFiresManualEnabled = {
                    description = "Allow players to ignite nearby vehicles manually.",
                    label = "Manual ignition",
                },
                vehicleFiresManualItem = {
                    description = "Inventory item required for manual vehicle ignition.",
                    label = "Ignition item",
                },
                vehicleFiresManualMaxDistance = {
                    description = "Configures: Maximum ignition distance.",
                    label = "Maximum ignition distance",
                },
                vehicleFiresManualSourceScale = {
                    description = "Configures: Manual ignition fire scale.",
                    label = "Manual ignition fire scale",
                },
                vehicleFiresMaterial = {
                    description = "Material profile used for vehicle fuel behavior.",
                    label = "Fire material",
                },
                vehicleFiresMaxActive = {
                    description = "Configures: Maximum active vehicle fires.",
                    label = "Maximum active vehicle fires",
                },
                vehicleFiresPetrolTankHealth = {
                    description = "Kept at 1000 so only the configured Firejob explosion can destroy the vehicle.",
                    label = "Petrol tank health while burning",
                },
                vehicleFiresProgressionEnabled = {
                    description = "Vehicle fires begin with smoke, grow into a small fire and then reach full intensity.",
                    label = "Enable gradual vehicle fire",
                },
                vehicleFiresProgressionExplosionAfterFullFire = {
                    description = "Adds the smoke and small-fire durations before the configured explosion delay starts.",
                    label = "Explosion timer after full fire",
                },
                vehicleFiresProgressionFullIntensity = {
                    description = "Configures: Full fire intensity.",
                    label = "Full fire intensity",
                },
                vehicleFiresProgressionFullSize = {
                    description = "Configures: Full fire size.",
                    label = "Full fire size",
                },
                vehicleFiresProgressionFullSmokeDensity = {
                    description = "Configures: Full fire smoke density.",
                    label = "Full fire smoke density",
                },
                vehicleFiresProgressionSmallDurationSeconds = {
                    description = "Configures: Small fire duration seconds.",
                    label = "Small fire duration seconds",
                },
                vehicleFiresProgressionSmallIntensity = {
                    description = "Configures: Small fire intensity.",
                    label = "Small fire intensity",
                },
                vehicleFiresProgressionSmallSize = {
                    description = "Configures: Small fire size.",
                    label = "Small fire size",
                },
                vehicleFiresProgressionSmallSmokeDensity = {
                    description = "Configures: Small fire smoke density.",
                    label = "Small fire smoke density",
                },
                vehicleFiresProgressionSmallSourceScale = {
                    description = "Configures: Small fire scale.",
                    label = "Small fire scale",
                },
                vehicleFiresProgressionSmokeDensity = {
                    description = "Configures: Smoke stage density.",
                    label = "Smoke stage density",
                },
                vehicleFiresProgressionSmokeDurationSeconds = {
                    description = "Configures: Smoke duration seconds.",
                    label = "Smoke duration seconds",
                },
                vehicleFiresProgressionSmokeIntensity = {
                    description = "Configures: Smoke stage intensity.",
                    label = "Smoke stage intensity",
                },
                vehicleFiresProgressionSmokeSize = {
                    description = "Configures: Smoke stage size.",
                    label = "Smoke stage size",
                },
                vehicleFiresProgressionSmokeSourceScale = {
                    description = "Keep this very low for mostly smoke with barely visible flames.",
                    label = "Smoke stage flame scale",
                },
                vehicleFiresServerCooldownSeconds = {
                    description = "Global cooldown for manual lighter ignition.",
                    label = "Server-wide ignition cooldown",
                },
                vehicleFiresSourceScale = {
                    description = "Configures: Default fire scale.",
                    label = "Default fire scale",
                },
                vehicleFiresStandaloneAllowNpcVehicles = {
                    description = "Configures: Allow NPC vehicles.",
                    label = "Allow NPC vehicles",
                },
                vehicleFiresStandaloneChance = {
                    description = "Configures: Crash fire chance.",
                    label = "Crash fire chance",
                },
                vehicleFiresStandaloneCooldownSeconds = {
                    description = "Configures: Crash cooldown seconds.",
                    label = "Crash cooldown seconds",
                },
                vehicleFiresStandaloneEnabled = {
                    description = "Let Firejob create vehicle fires from severe crashes without requiring Mechanicjob.",
                    label = "Enable standalone crashes",
                },
                vehicleFiresStandaloneForwardMotionRatio = {
                    description = "Configures: Forward motion ratio.",
                    label = "Forward motion ratio",
                },
                vehicleFiresStandaloneIgnoreElectric = {
                    description = "Configures: Ignore electric vehicles.",
                    label = "Ignore electric vehicles",
                },
                vehicleFiresStandaloneMechanicResources = {
                    description = "Resources that disable fallback crash detection while they are running.",
                    itemLabel = "Resource",
                    label = "Mechanic resources",
                },
                vehicleFiresStandaloneMinBodyHealthLoss = {
                    description = "Configures: Minimum body damage.",
                    label = "Minimum body damage",
                },
                vehicleFiresStandaloneMinEngineHealthLoss = {
                    description = "Configures: Minimum engine damage.",
                    label = "Minimum engine damage",
                },
                vehicleFiresStandaloneMinImpactSpeedKmh = {
                    description = "Configures: Minimum impact speed.",
                    label = "Minimum impact speed",
                },
                vehicleFiresStandaloneMinSpeedDropKmh = {
                    description = "Configures: Minimum speed loss.",
                    label = "Minimum speed loss",
                },
                vehicleFiresStandaloneMode = {
                    description = "Fallback only runs when configured mechanic resources are not active. Always can run alongside Mechanicjob. Disabled keeps only manual, external, or mechanic triggers.",
                    label = "Standalone mode",
                    options = {
                        always = "Always",
                        disabled = "Disabled",
                        fallback = "Fallback",
                    },
                },
                vehicleFiresStandaloneRequireDriver = {
                    description = "Configures: Require player driver.",
                    label = "Require player driver",
                },
                vehicleFiresStandaloneServerMaxDistance = {
                    description = "Maximum allowed player distance from the crash coordinates.",
                    label = "Server max distance",
                },
                vehicleFiresStandaloneSmokeDensity = {
                    description = "Configures: Crash smoke density.",
                    label = "Crash smoke density",
                },
                vehicleFiresStandaloneSourceScale = {
                    description = "Configures: Crash fire scale.",
                    label = "Crash fire scale",
                },
                vehicleFiresWaterEffectiveness = {
                    description = "Use 0 so water does not extinguish vehicle fuel fires.",
                    label = "Water effectiveness",
                },
                vehicleFiresWaterReactionChance = {
                    description = "Configures: Reaction chance.",
                    label = "Reaction chance",
                },
                vehicleFiresWaterReactionEnabled = {
                    description = "Allows water on vehicle fuel fires to spread, smoke or explode depending on the values below.",
                    label = "Water makes it worse",
                },
                vehicleFiresWaterReactionExplosionChance = {
                    description = "Configures: Explosion reaction chance.",
                    label = "Explosion reaction chance",
                },
                vehicleFiresWaterReactionInterval = {
                    description = "Configures: Reaction interval ms.",
                    label = "Reaction interval ms",
                },
                vehicleFiresWaterReactionSmokeIncrease = {
                    description = "Configures: Smoke increase.",
                    label = "Smoke increase",
                },
                vehicleFiresWaterReactionSpreadCount = {
                    description = "Configures: Spread count.",
                    label = "Spread count",
                },
                vehicleRescueAllowMissionCreatorVehicles = {
                    description = "Allow vehicles placed by the Fire Mission Creator to become rescue targets.",
                    label = "Mission creator vehicles",
                },
                vehicleRescueAllowStateBag = {
                    description = "External scripts can mark vehicles with Entity(vehicle).state[configuredKey] = true.",
                    label = "Allow state bag marker",
                },
                vehicleRescueAllowWorldVehicles = {
                    description = "Allow normal damaged vehicles in the world to become rescue targets.",
                    label = "World vehicles",
                },
                vehicleRescueBreakDoorOnComplete = {
                    description = "Configures: Break GTA door on success.",
                    label = "Break GTA door on success",
                },
                vehicleRescueBreakWindowOnComplete = {
                    description = "Configures: Break GTA window on success.",
                    label = "Break GTA window on success",
                },
                vehicleRescueDoorLabel = {
                    description = "Interaction label shown for spreading a vehicle door.",
                    label = "Door interaction label",
                },
                vehicleRescueDoorWheelLabel = {
                    description = "Use %s as placeholder for the detected door side label.",
                    label = "Door wheel label",
                },
                vehicleRescueEnabled = {
                    description = "Enable technical rescue interactions on vehicles.",
                    label = "Enabled",
                },
                vehicleRescueGlassDurationMs = {
                    description = "Configures: Duration ms.",
                    label = "Duration ms",
                },
                vehicleRescueGlassGoodZone = {
                    description = "Configures: Good zone.",
                    label = "Good zone",
                },
                vehicleRescueGlassHammerItem = {
                    description = "Inventory item required to break vehicle windows.",
                    label = "Glass hammer item",
                },
                vehicleRescueGlassHammerProp = {
                    description = "Configures: Glass hammer prop.",
                    label = "Glass hammer prop",
                },
                vehicleRescueGlassHitPoints = {
                    description = "Configures: Weak points.",
                    label = "Weak points",
                },
                vehicleRescueGlassLabel = {
                    description = "Interaction label shown for breaking a vehicle window.",
                    label = "Glass interaction label",
                },
                vehicleRescueGlassMaxMisses = {
                    description = "Configures: Allowed misses.",
                    label = "Allowed misses",
                },
                vehicleRescueGlassMinigameEnabled = {
                    description = "Configures: Enable glass minigame.",
                    label = "Enable glass minigame",
                },
                vehicleRescueGlassMistakePenalty = {
                    description = "Configures: Mistake penalty hits.",
                    label = "Mistake penalty hits",
                },
                vehicleRescueGlassPerfectZone = {
                    description = "Configures: Perfect zone.",
                    label = "Perfect zone",
                },
                vehicleRescueGlassRequiredHits = {
                    description = "Configures: Required hits.",
                    label = "Required hits",
                },
                vehicleRescueGlassWheelLabel = {
                    description = "Use %s as placeholder for the detected door side label.",
                    label = "Glass wheel label",
                },
                vehicleRescueInteractionDistance = {
                    description = "Configures: Interaction distance.",
                    label = "Interaction distance",
                },
                vehicleRescueMaxScanDistance = {
                    description = "Configures: Vehicle scan distance.",
                    label = "Vehicle scan distance",
                },
                vehicleRescuePatientAccessibleAfterAnyDoor = {
                    description = "Sets the vehicle rescue state to accessible after any door is removed.",
                    label = "Patient accessible after one door",
                },
                vehicleRescuePlayerEntrapmentEnabled = {
                    description = "Trap players in heavily damaged vehicles until rescue access is created.",
                    label = "Player entrapment",
                },
                vehicleRescueRequireMatchingGlassForDoor = {
                    description = "The door point only appears after the matching side window has been removed.",
                    label = "Door requires matching glass",
                },
                vehicleRescueRequireOnDuty = {
                    description = "Only on-duty firefighters can break glass and force doors.",
                    label = "Require on duty",
                },
                vehicleRescueSpreaderDecayPerTick = {
                    description = "Configures: Decay per tick.",
                    label = "Decay per tick",
                },
                vehicleRescueSpreaderDurationMs = {
                    description = "Configures: Duration ms.",
                    label = "Duration ms",
                },
                vehicleRescueSpreaderItem = {
                    description = "Inventory item required to spread vehicle doors.",
                    label = "Spreader item",
                },
                vehicleRescueSpreaderMaxPumpPower = {
                    description = "Configures: Good pump maximum.",
                    label = "Good pump maximum",
                },
                vehicleRescueSpreaderMinPumpPower = {
                    description = "Configures: Good pump minimum.",
                    label = "Good pump minimum",
                },
                vehicleRescueSpreaderMinigameEnabled = {
                    description = "Configures: Enable spreader minigame.",
                    label = "Enable spreader minigame",
                },
                vehicleRescueSpreaderOverPressurePenalty = {
                    description = "Configures: Overpressure penalty.",
                    label = "Overpressure penalty",
                },
                vehicleRescueSpreaderPressureGain = {
                    description = "Configures: Pressure gain.",
                    label = "Pressure gain",
                },
                vehicleRescueSpreaderPressureLoss = {
                    description = "Configures: Pressure loss.",
                    label = "Pressure loss",
                },
                vehicleRescueSpreaderProgressPerTick = {
                    description = "Configures: Progress per tick.",
                    label = "Progress per tick",
                },
                vehicleRescueSpreaderProp = {
                    description = "Configures: Spreader prop.",
                    label = "Spreader prop",
                },
                vehicleRescueSpreaderPumpsRequired = {
                    description = "Door is removed after roughly 3 to 5 good spreader pumps.",
                    label = "Required pump cycles",
                },
                vehicleRescueSpreaderRequiredProgress = {
                    description = "Configures: Required progress.",
                    label = "Required progress",
                },
                vehicleRescueSpreaderSweetSpotMax = {
                    description = "Configures: Pressure sweet spot max.",
                    label = "Pressure sweet spot max",
                },
                vehicleRescueSpreaderSweetSpotMin = {
                    description = "Configures: Pressure sweet spot min.",
                    label = "Pressure sweet spot min",
                },
                vehicleRescueStateBagKey = {
                    description = "Configures: State bag key.",
                    label = "State bag key",
                },
                vehicleRescueWorldBodyHealthThreshold = {
                    description = "Configures: Body health threshold.",
                    label = "Body health threshold",
                },
                vehicleRescueWorldEngineHealthThreshold = {
                    description = "Configures: Engine health threshold.",
                    label = "Engine health threshold",
                },
                vehicleRescueWorldRequiresDamage = {
                    description = "When enabled, normal world vehicles must be damaged below the configured thresholds.",
                    label = "World vehicles need damage",
                },
                waterMonitorAllowedJobs = {
                    description = "Leave empty to allow all jobs configured in this Firejob.",
                    itemLabel = "Job",
                    label = "Allowed jobs",
                },
                waterMonitorCommand = {
                    description = "Command name without a slash, for example watermonitor.",
                    label = "Command",
                },
                waterMonitorCommandEnabled = {
                    description = "Allows placing the Water Monitor without an item by using the command.",
                    label = "Enable command usage",
                },
                waterMonitorConsumeItem = {
                    description = "Removes one configured item after successful placement.",
                    label = "Consume item on placement",
                },
                waterMonitorEnabled = {
                    description = "Enables placement and operation of the portable Water Monitor.",
                    label = "Enable Water Monitor",
                },
                waterMonitorEnterAnimDict = {
                    description = "Animation dictionary loaded when a player starts operating the Water Monitor.",
                    label = "Dictionary",
                },
                waterMonitorEnterAnimDurationMs = {
                    description = "Duration of the enter animation in milliseconds; use -1 for no timeout.",
                    label = "Duration ms",
                },
                waterMonitorEnterAnimName = {
                    description = "Animation clip played when entering the operating position.",
                    label = "Animation name",
                },
                waterMonitorExitAnimDict = {
                    description = "Animation dictionary loaded when a player stops operating the Water Monitor.",
                    label = "Dictionary",
                },
                waterMonitorExitAnimDurationMs = {
                    description = "Duration of the exit animation in milliseconds; use -1 for no timeout.",
                    label = "Duration ms",
                },
                waterMonitorExitAnimName = {
                    description = "Animation clip played when leaving the operating position.",
                    label = "Animation name",
                },
                waterMonitorIdleAnimDict = {
                    description = "Animation dictionary used while operating the Water Monitor.",
                    label = "Dictionary",
                },
                waterMonitorIdleAnimDurationMs = {
                    description = "Duration of the operating animation in milliseconds; use -1 to keep it active.",
                    label = "Duration ms",
                },
                waterMonitorIdleAnimName = {
                    description = "Looping animation clip used while operating the Water Monitor.",
                    label = "Animation name",
                },
                waterMonitorInteractionDistance = {
                    description = "Maximum distance from which the Water Monitor can be operated.",
                    label = "Interaction distance",
                },
                waterMonitorItem = {
                    description = "Inventory item used to place the Water Monitor.",
                    label = "Item name",
                },
                waterMonitorItemEnabled = {
                    description = "Allows placing the Water Monitor by using the configured inventory item.",
                    label = "Enable item usage",
                },
                waterMonitorLabel = {
                    description = "Name shown in interactions and notifications.",
                    label = "Display label",
                },
                waterMonitorModel = {
                    description = "Prop model spawned for the Water Monitor.",
                    label = "Prop model",
                },
                waterMonitorPickupDistance = {
                    description = "Maximum distance from which a placed Water Monitor can be picked up.",
                    label = "Pickup distance",
                },
                waterMonitorRequireOnDuty = {
                    description = "Only allows on-duty members of an allowed job to use the Water Monitor.",
                    label = "Require on duty",
                },
                waterMonitorReturnItemOnRemove = {
                    description = "Returns one configured item when the Water Monitor is picked up.",
                    label = "Return item on pickup",
                },
                waterMonitorStreamDistance = {
                    description = "Maximum distance at which placed Water Monitors are synchronized and rendered.",
                    label = "Streaming distance",
                },
                waterMonitorStreamHitRadius = {
                    description = "Radius around the water trajectory that can affect a fire.",
                    label = "Hit radius",
                },
                waterMonitorStreamMinRange = {
                    description = "Minimum stream distance used when aiming the Water Monitor.",
                    label = "Minimum range",
                },
                waterMonitorStreamProgressPerSecond = {
                    description = "Base extinguishing strength applied to fires hit by the stream.",
                    label = "Extinguish progress per second",
                },
                waterMonitorStreamRange = {
                    description = "Maximum travel distance of the water stream in meters.",
                    label = "Range",
                },
                waterMonitorStreamTrajectorySegments = {
                    description = "Number of segments used to calculate the curved water trajectory.",
                    label = "Trajectory segments",
                },
                waterMonitorStreamWaterGravityScale = {
                    description = "Controls how strongly gravity bends the water trajectory downward.",
                    label = "Gravity scale",
                },
                waterMonitorStreamWaterLitersPerSecond = {
                    description = "Water consumed from the connected supply while spraying.",
                    label = "Water liters per second",
                },
                waterMonitorStreamWaterVelocity = {
                    description = "Initial velocity used to calculate the water trajectory.",
                    label = "Water velocity",
                },
                waterMonitorZOffset = {
                    description = "Vertical correction applied when placing the prop on the ground.",
                    label = "Ground Z offset",
                },
                waterTankEnabled = {
                    description = "Configures: Water tank.",
                    label = "Water tank",
                },
                waterTankSize = {
                    description = "Configures: Water liters.",
                    label = "Water liters",
                },
                x = {
                    description = "Configures: X.",
                    label = "X",
                },
                y = {
                    description = "Configures: Y.",
                    label = "Y",
                },
                z = {
                    description = "Configures: Z.",
                    label = "Z",
                },
                zOffset = {
                    description = "Vertical offset so the created fire sits correctly on the chosen ignition source.",
                    label = "Fire height offset",
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
        },
    },
}
