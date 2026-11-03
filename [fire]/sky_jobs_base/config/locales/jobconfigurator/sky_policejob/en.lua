JobConfigLocales["sky_policejob:en"] = {
    JobConfiguratorComingSoon = "This job configurator is coming soon.",
    JobConfiguratorImportFailed = "Failed to import config.lua values for '%s': %s.",
    JobConfiguratorImportHistoryFailed = "The import succeeded, but its history entry could not be saved.",
    JobConfiguratorImportNoData = "'%s' provides no config.lua import data.",
    JobConfiguratorImportSuccess = "Imported config.lua values for '%s': %d jobs, %d setting, %d feature, and %d interaction deviations applied.",
    JobConfiguratorNoPermission = "You do not have permission to use this command.",
    JobConfiguratorTitle = "Job Configurator",
    JobConfiguratorUnknown = "Unknown job configurator.",
    Nui = {
        workshopConfig = {
            configs = {
                sky_policejob = {
                    subtitle = "Configure police departments, shops, props, vehicles, stations, and core feature settings.",
                    title = "Police Jobs",
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
                radioButton = "Button",
                radioButtonAction = "Button Action",
                radioButtonStatus = "FMS Status",
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
                dispatchRadioButtons = "Sets the centrally predefined action for each physical function button.",
                dispatchRadioFmsKeys = "Assigns FMS status to the physical number keys. The keypad only performs FMS changes.",
            },
            extensions = {
                caseNumbering = {
                    label = "Case numbers",
                    description = "Configure automatic case numbers for this job.",
                    fields = {
                        prefix = {
                            label = "Case prefix",
                            description = "Prefix for new cases, such as LSPD or LSCSD. Up to 16 characters, converted to uppercase; blank uses CASE. Existing and manually assigned numbers stay unchanged.",
                        },
                    },
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
                trainingSettings = {
                    description = "Configure training access, enrollment, approvals, and course planning for this job.",
                    label = "Training settings",
                },
                dispatchRadioButtons = "Radio Function Buttons",
                dispatchRadioFmsKeys = "FMS Key Assignment",
            },
            features = {
                billing = {
                    description = "Enable police billing workflows.",
                    label = "Billing",
                },
                devices = {
                    description = "Enable deployable enforcement devices.",
                    label = "CCTV and Speed Cameras",
                },
                evidence = {
                    description = "Enable evidence storage, field evidence, and scanner flows.",
                    label = "Evidence",
                },
                impound = {
                    description = "Enable impound lot workflows.",
                    label = "Impound",
                },
                jail = {
                    description = "Enable jail assignment and inmate activities.",
                    label = "Jail",
                },
                propPlacement = {
                    description = "Enable configurable police props and vehicle prop loadouts.",
                    label = "Prop Placement",
                },
                radial = {
                    description = "Enable police radial actions such as impound and wheel clamp.",
                    label = "Radial Actions",
                },
                restraints = {
                    description = "Enable cuffs, zipties, leg restraints, and head bags.",
                    label = "Restraints",
                },
                socialWork = {
                    description = "Enable social work assignment and task activities.",
                    label = "Social Work",
                },
                tablet = {
                    description = "Enable police tablet apps configured by this resource.",
                    label = "Police Tablet",
                },
                tracking = {
                    description = "Enable GPS trackers and ankle monitors.",
                    label = "Tracking",
                },
                vehicleRadar = {
                    description = "Enable patrol vehicle radar.",
                    label = "Vehicle Radar",
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
            settingFields = {
                gangMinimumGrade = "Minimum rank",
                gang = "Gang",
                component = "Component",
                description = "Description",
                fineAmount = "Fine amount",
                itemName = "Item name",
                length = "Length",
                max = "Max",
                maxOverKmh = "Max over",
                min = "Min",
                minOverKmh = "Min over",
                model = "Prop model",
                propModel = "Prop model",
                reason = "Reason",
                vehicleClass = "Class",
            },
            settingGroups = {
                access = {
                    label = "Access",
                },
                animation = {
                    label = "Animation",
                },
                ankleMonitor = {
                    label = "Ankle Monitor",
                },
                ankleMonitorAccess = {
                    label = "Ankle Monitor Access",
                },
                ankleMonitorPlacement = {
                    label = "Ankle Monitor Placement",
                },
                ankleMonitorZone = {
                    label = "Ankle Monitor Zone",
                },
                ankleMonitorZoneVisual = {
                    label = "Ankle Monitor Zone Visuals",
                },
                assignment = {
                    label = "Assignment",
                },
                blip = {
                    label = "Station Blip",
                },
                carry = {
                    label = "Carry",
                },
                cctv = {
                    label = "CCTV",
                },
                cctvDurability = {
                    label = "CCTV Durability",
                },
                cctvMotionDetection = {
                    label = "Motion Detection",
                },
                cctvMotionDispatch = {
                    label = "Motion Detection Dispatch",
                },
                cctvMotionTiming = {
                    label = "Motion Detection Timing",
                },
                cctvPlacement = {
                    label = "CCTV Placement",
                },
                cctvRepair = {
                    label = "CCTV Repair",
                },
                cctvRepairAnimation = {
                    label = "CCTV Repair Animation",
                },
                clamp = {
                    label = "Clamp",
                },
                clampWeld = {
                    label = "Clamp Welding",
                },
                cleanup = {
                    label = "Cleanup",
                },
                collection = {
                    label = "Collection",
                },
                controls = {
                    label = "Controls",
                },
                creator = {
                    label = "Creator",
                },
                crimeSceneTape = {
                    label = "Crime Scene Tape",
                },
                crimeSceneTapeAccess = {
                    label = "Tape Access",
                },
                crimeSceneTapeInventory = {
                    label = "Tape Inventory",
                },
                crimeSceneTapeLength = {
                    label = "Tape Length",
                },
                crimeSceneTapePlacement = {
                    label = "Tape Placement",
                },
                database = {
                    label = "Database",
                },
                delivery = {
                    label = "Delivery",
                },
                detection = {
                    label = "Detection",
                },
                dispatch = {
                    label = "Dispatch",
                },
                display = {
                    label = "Display",
                },
                escape = {
                    label = "Escape",
                },
                escort = {
                    label = "Escort",
                },
                evidenceStorage = {
                    label = "Evidence Storage",
                },
                fastLock = {
                    label = "Auto Fast Lock",
                },
                general = {
                    label = "General",
                },
                gpsTracker = {
                    label = "GPS Tracker",
                },
                gpsTrackerAccess = {
                    label = "GPS Tracker Access",
                },
                gpsTrackerPlacement = {
                    label = "GPS Tracker Placement",
                },
                gpsTrackerTiming = {
                    label = "GPS Tracker Timing",
                },
                gsr = {
                    label = "GSR",
                },
                handcuffs = {
                    label = "Handcuffs",
                },
                handsUp = {
                    label = "Hands Up",
                },
                header = {
                    label = "Header",
                },
                impound = {
                    label = "Impound",
                },
                imprisonment = {
                    label = "Imprisonment",
                },
                jailCanteenGeneral = {
                    label = "Jail Canteen",
                },
                jailCanteenPackage = {
                    label = "Jail Canteen Package",
                },
                jailCarry = {
                    label = "Carry Job",
                },
                jailCarryInspection = {
                    label = "Carry Inspection",
                },
                jailCleaning = {
                    label = "Cleaning Job",
                },
                jailCleaningIllegalFinds = {
                    label = "Illegal Finds",
                },
                jailCleaningOutline = {
                    label = "Cleaning Outline",
                },
                jailDoctor = {
                    label = "Jail Doctor",
                },
                jailElectricalCodes = {
                    label = "Jail Electrical Codes",
                },
                jailElectricalGeneral = {
                    label = "Jail Electrical",
                },
                jailElectricalPenalties = {
                    label = "Jail Electrical Penalties",
                },
                jailElectricalRewards = {
                    label = "Jail Electrical Rewards",
                },
                jailInmatesAlcoholic = {
                    label = "Alcoholic Inmate",
                },
                jailInmatesCodeList = {
                    label = "Informant Inmate",
                },
                jailInmatesDrugDealer = {
                    label = "Drug Dealer Inmate",
                },
                jailInmatesWireCutter = {
                    label = "Tool Runner Inmate",
                },
                jailJobs = {
                    label = "Jail Jobs",
                },
                jailOutfitFemale = {
                    label = "Female Outfit",
                },
                jailOutfitMale = {
                    label = "Male Outfit",
                },
                keybinds = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Keybinds",
                },
                keybindsHandcuff = {
                    label = "Handcuff Keybind",
                },
                keybindsUnhandcuff = {
                    label = "Unhandcuff Keybind",
                },
                marker = {
                    label = "Marker",
                },
                markerColor = {
                    label = "Marker Color",
                },
                mugshotAnimation = {
                    label = "Mugshot Animation",
                },
                mugshotBoard = {
                    label = "Mugshot Board",
                },
                mugshotCameraCoords = {
                    label = "Mugshot Camera Position",
                },
                mugshotCameraRotation = {
                    label = "Mugshot Camera Rotation",
                },
                mugshotGeneral = {
                    label = "Mugshot",
                },
                mugshotMetadata = {
                    label = "Mugshot Metadata",
                },
                mugshotPosition = {
                    label = "Mugshot Position",
                },
                mugshotTiming = {
                    label = "Mugshot Timing",
                },
                officerDown = {
                    label = "Officer Down",
                },
                outfit = {
                    label = "Outfit",
                },
                overlay = {
                    label = "Plate Overlay",
                },
                payment = {
                    label = "Payment",
                },
                paymentFlow = {
                    label = "Payment Flow",
                },
                penalties = {
                    label = "Penalties",
                },
                playerSearch = {
                    label = "Player Search",
                },
                playerSearchAnimation = {
                    label = "Player Search Animation",
                },
                props = {
                    label = "Prop Items",
                },
                reasons = {
                    label = "Reasons",
                },
                release = {
                    label = "Release",
                },
                reports = {
                    label = "Reports",
                },
                restore = {
                    label = "Restore",
                },
                rules = {
                    label = "Rules",
                },
                scan = {
                    label = "Scan",
                },
                scanner = {
                    label = "Scanner",
                },
                sentence = {
                    label = "Sentence",
                },
                shotsFired = {
                    label = "Shots Fired",
                },
                sound = {
                    label = "Sound",
                },
                speedcam = {
                    label = "Speed Cameras",
                },
                speedcamAdvanced = {
                    label = "Advanced Speed Camera",
                },
                speedcamBilling = {
                    label = "Speed Camera Billing",
                },
                speedcamDispatch = {
                    label = "Speed Camera Dispatch",
                },
                speedcamDurability = {
                    label = "Speed Camera Durability",
                },
                speedcamPlacement = {
                    label = "Speed Camera Placement",
                },
                speedcamRepair = {
                    label = "Speed Camera Repair",
                },
                speedcamRepairAnimation = {
                    label = "Speed Camera Repair Animation",
                },
                speedcamTiming = {
                    label = "Speed Camera Timing",
                },
                speedcamVisual = {
                    label = "Speed Camera Visuals",
                },
                speedcams = {
                    label = "Speedcams",
                },
                storage = {
                    label = "Storage",
                },
                subscription = {
                    label = "App Subscription",
                },
                tackle = {
                    label = "Tackle",
                },
                tasks = {
                    label = "Tasks",
                },
                theme = {
                    label = "Theme",
                },
                timing = {
                    label = "Timing",
                },
                vin = {
                    label = "VIN Check",
                },
                warningUi = {
                    label = "Warning UI",
                },
                world = {
                    label = "World",
                },
                zipties = {
                    label = "Zipties",
                },
                ziptiesCutter = {
                    label = "Ziptie Cutter",
                },
            },
            settingSections = {
                radarGun = "Radar Gun",
                billing = "Billing",
                cctv = "CCTV",
                dispatch = "Dispatch",
                equipment = "Equipment",
                evidence = "Evidence",
                fakePlates = "Fake Plates",
                general = "General",
                impound = "Impound",
                jail = "Jail",
                radar = "Vehicle Radar",
                radial = "Radial Actions",
                restraints = "Restraints",
                socialWork = "Social Work",
                speedCamera = "Speed Camera",
                spikeStrips = "Spike Strips",
                stations = "Stations",
                tablet = "Tablet Apps",
                tracking = "Tracking",
            },
            settingSubsections = {
                app = "Speed Camera App",
                apps = "Apps",
                billing = "Billing",
                canteen = "Jail Canteen",
                dispatch = "Dispatch",
                durability = "Durability",
                electrical = "Jail Electrical",
                general = "General",
                handcuffs = "Cuffs & Zipties",
                inmates = "Jail Inmates",
                jobs = "Jail Jobs",
                keybinds = "Keybinds",
                motionDetection = "Motion Detection",
                mugshot = "Mugshot",
                placement = "Placement",
                repair = "Repair",
                timing = "Timing",
                visuals = "Visuals",
            },
            settings = {
                radarGunClearKey = { label = "Radar gun: Clear reading" },
                radarGunToggleUiKey = { label = "Radar gun: Toggle interface" },
                radarGunNoTargetHoldMs = { label = "Target hold time (ms)" },
                radarGunMinimumReading = { label = "Minimum displayed speed" },
                radarGunSpeedSmoothing = { label = "Speed smoothing (0–1)" },
                radarGunBeamRadius = { label = "Beam radius (m)" },
                radarGunRefreshRateMs = { label = "Scan interval (ms)" },
                radarGunUseMph = { label = "Use MPH", description = "Show radar gun measurements in miles per hour instead of kilometres per hour." },
                radarGunRange = { label = "Measurement range", description = "Maximum distance in metres at which the radar gun detects vehicles." },
                radarGunRequireOnDuty = { label = "Require duty", description = "Require officers to be on duty before the radar gun can measure vehicles." },
                radarGunAllowedJobs = { label = "Allowed jobs or groups", description = "Use police for all configured police jobs, or direct job names. An empty list disables job restrictions.", itemLabel = "Job or group" },
                radarGunEnabled = { label = "Radar gun", description = "Enable the handheld SKY SR-2 radar gun." },
                tabletRegistry = {
                    label = "Registry",
                    description = "Enable custom RP registers in File Explorer. Citizen and vehicle records remain available separately.",
                },
                tabletFiles = {
                    label = "File Explorer",
                    description = "Groups police records in File Explorer. DOJ documents appear only while DOJ is running.",
                },
                ankleMonitorAnimDurationMs = {
                    description = "Milliseconds spent applying an ankle monitor.",
                    label = "Apply duration",
                },
                ankleMonitorAnimScenario = {
                    description = "Scenario played while applying an ankle monitor.",
                    label = "Apply scenario",
                },
                ankleMonitorAttachBone = {
                    description = "Ped bone used to attach the ankle monitor prop.",
                    label = "Attach bone",
                },
                ankleMonitorConsumeOnPlace = {
                    description = "Remove the ankle monitor item after placement.",
                    label = "Consume ankle monitor",
                },
                ankleMonitorCutItem = {
                    description = "Inventory item used to remove ankle monitors.",
                    label = "Cut item",
                },
                ankleMonitorEnabled = {
                    description = "Enable ankle monitor placement.",
                    label = "Ankle monitor",
                },
                ankleMonitorItem = {
                    description = "Inventory item used to place ankle monitors.",
                    label = "Ankle monitor item",
                },
                ankleMonitorMapUpdateIntervalMs = {
                    description = "Milliseconds between ankle monitor map updates.",
                    label = "Map update interval",
                },
                ankleMonitorPersistOnDisconnect = {
                    description = "Keep ankle monitors in the database when monitored players disconnect so they are restored after reconnects and server restarts.",
                    label = "Persist after disconnect",
                },
                ankleMonitorPlaceDistance = {
                    description = "Maximum distance to place an ankle monitor.",
                    label = "Place distance",
                },
                ankleMonitorPropModel = {
                    description = "Prop model used for the ankle monitor visual.",
                    label = "Prop model",
                },
                ankleMonitorRequireOnDuty = {
                    description = "Require duty state before using ankle monitors.",
                    label = "Ankle monitor requires duty",
                },
                ankleMonitorRequirePoliceJob = {
                    description = "Require the player to be in the police group before using ankle monitors.",
                    label = "Ankle monitor requires police job",
                },
                ankleMonitorReturnOnRemove = {
                    description = "Return the ankle monitor item when it is removed.",
                    label = "Return ankle monitor on remove",
                },
                ankleMonitorWarningSeconds = {
                    description = "Warning time before an ankle monitor zone violation is dispatched.",
                    label = "Zone warning seconds",
                },
                ankleMonitorZoneBeepIntervalMs = {
                    description = "Milliseconds between ankle monitor zone warning beeps.",
                    label = "Zone beep interval",
                },
                ankleMonitorZoneBeepSound = {
                    description = "Sound name used for ankle monitor zone warnings.",
                    label = "Beep sound",
                },
                ankleMonitorZoneBeepSoundSet = {
                    description = "Sound set used for ankle monitor zone warnings.",
                    label = "Beep sound set",
                },
                ankleMonitorZoneBlipAlpha = {
                    description = "Alpha value used for ankle monitor zone blips.",
                    label = "Blip alpha",
                },
                ankleMonitorZoneBlipColorAllowed = {
                    description = "Blip color used when a target is inside the allowed area.",
                    label = "Allowed blip color",
                },
                ankleMonitorZoneBlipColorExcluded = {
                    description = "Blip color used when a target leaves the allowed area.",
                    label = "Excluded blip color",
                },
                ankleMonitorZoneCheckIntervalMs = {
                    description = "Milliseconds between ankle monitor zone checks.",
                    label = "Zone check interval",
                },
                ankleMonitorZoneDispatchCooldownSeconds = {
                    description = "Seconds before another ankle monitor zone dispatch can be sent.",
                    label = "Zone dispatch cooldown",
                },
                ankleMonitorZoneEnabled = {
                    description = "Enable ankle monitor zone checks.",
                    label = "Ankle monitor zones",
                },
                ankleMonitorZoneLabelSprite = {
                    description = "Blip sprite used for ankle monitor zone markers.",
                    label = "Zone label sprite",
                },
                ankleMonitorZoneOutlineRadius = {
                    description = "Radius used for ankle monitor zone outlines.",
                    label = "Outline radius",
                },
                ankleMonitorZoneOutlineStep = {
                    description = "Step size used for ankle monitor zone outlines.",
                    label = "Outline step",
                },
                billingAccount = {
                    description = "Fallback account used when a job has no configured society account.",
                    label = "Fallback society account",
                },
                billingCloseOnSuccess = {
                    description = "Close the billing UI after a bill was issued.",
                    label = "Close after success",
                },
                billingCurrency = {
                    description = "Currency key used for billing. Leave empty to use the default currency.",
                    label = "Currency",
                },
                billingCustomReasons = {
                    description = "Allow custom billing reasons instead of only presets.",
                    label = "Custom reasons",
                },
                billingDepositToSociety = {
                    description = "Deposit billing revenue into the job society account.",
                    label = "Deposit to society",
                },
                billingMaxReasonLength = {
                    description = "Maximum number of characters for custom billing reasons.",
                    label = "Reason length",
                },
                billingMode = {
                    description = "Choose whether police bills charge instantly, require citizen confirmation, or use the framework billing system.",
                    label = "Billing mode",
                    options = {
                        consent = "Pay or decline",
                        framework = "Framework bill",
                        instant = "Instant charge",
                    },
                },
                billingRange = {
                    description = "Maximum target distance for issuing police bills.",
                    label = "Billing range",
                },
                billingReasonPresets = {
                    description = "Preset billing reasons shown in the billing UI.",
                    itemLabel = "Reason",
                    label = "Reason presets",
                },
                billingRefreshSeconds = {
                    description = "Target refresh interval while the billing UI is open.",
                    label = "Refresh seconds",
                },
                billingShowRecipientName = {
                    description = "Show the citizen's name on ticket previews and receipts.",
                    label = "Show recipient name",
                },
                carryAllowCarrierInVehicle = {
                    description = "Allow the carrier to enter and drive a vehicle without dropping the carried player.",
                    label = "Allow carrier in vehicle",
                },
                carryAllowConscious = {
                    description = "Allow conscious targets to be carried.",
                    label = "Carry conscious targets",
                },
                carryAllowSprint = {
                    description = "Allow sprinting while carrying another player.",
                    label = "Allow sprint while carrying",
                },
                carryEnabled = {
                    description = "Enable carrying players.",
                    label = "Carry",
                },
                carryMaxDistance = {
                    description = "Maximum distance to start carrying a player.",
                    label = "Carry distance",
                },
                carryRequireOnDuty = {
                    description = "Require duty state before starting a carry.",
                    label = "Carry requires duty",
                },
                cctvDamageCooldownMs = {
                    description = "Milliseconds before CCTV damage can be applied again.",
                    label = "Damage cooldown",
                },
                cctvDamagePerHit = {
                    description = "Durability damage applied to CCTV cameras per hit.",
                    label = "Damage per hit",
                },
                cctvDefaultName = {
                    description = "Default display name for deployed CCTV cameras.",
                    label = "CCTV default name",
                },
                cctvDefaultPitch = {
                    description = "Default camera pitch for CCTV placement.",
                    label = "Default pitch",
                },
                cctvDisassembleDistance = {
                    description = "Distance used to disassemble CCTV cameras.",
                    label = "Disassemble distance",
                },
                cctvEnabled = {
                    description = "Enable CCTV camera placement and streaming.",
                    label = "CCTV cameras",
                },
                cctvHealthDisplayDistance = {
                    description = "Distance at which CCTV health is shown.",
                    label = "Health display distance",
                },
                cctvHealthDisplayDurationMs = {
                    description = "Milliseconds that CCTV health remains visible.",
                    label = "Health display duration",
                },
                cctvHealthTextOffset = {
                    description = "Vertical offset used for CCTV health text.",
                    label = "Health text offset",
                },
                cctvHeightStep = {
                    description = "Height step used while positioning CCTV cameras.",
                    label = "Height step",
                },
                cctvItem = {
                    description = "Inventory item used to place CCTV cameras.",
                    label = "CCTV item",
                },
                cctvMaintenanceThreshold = {
                    description = "Durability threshold where CCTV maintenance is recommended.",
                    label = "Maintenance threshold",
                },
                cctvMaxDurability = {
                    description = "Maximum CCTV camera durability.",
                    label = "CCTV durability",
                },
                cctvMotionAlertCooldownSeconds = {
                    description = "Seconds before a camera can create another motion dispatch.",
                    label = "Dispatch cooldown",
                },
                cctvMotionCheckIntervalMs = {
                    description = "Milliseconds between client-side motion scans.",
                    label = "Scan interval",
                },
                cctvMotionClientCooldownMs = {
                    description = "Milliseconds before one client can report the same camera again.",
                    label = "Client report cooldown",
                },
                cctvMotionDefaultCameraEnabled = {
                    description = "Enable motion alerts automatically for newly placed CCTV cameras.",
                    label = "Enable new cameras by default",
                },
                cctvMotionDetectionEnabled = {
                    description = "Enable per-camera motion detection dispatch alerts.",
                    label = "Motion detection alerts",
                },
                cctvMotionDetectionRadius = {
                    description = "Maximum motion detection distance in metres.",
                    label = "Detection radius",
                },
                cctvMotionFieldOfView = {
                    description = "Motion detection cone angle in degrees.",
                    label = "Field of view",
                },
                cctvMotionJobs = {
                    description = "Job names or job-group keys that receive CCTV motion dispatches.",
                    itemLabel = "Job or group",
                    label = "Dispatch jobs",
                },
                cctvMotionMinimumSpeed = {
                    description = "Minimum entity speed in metres per second required to count as movement.",
                    label = "Minimum movement speed",
                },
                cctvMoveStep = {
                    description = "Movement step used while positioning CCTV cameras.",
                    label = "Move step",
                },
                cctvPropModel = {
                    description = "Prop model used for deployed CCTV cameras.",
                    label = "CCTV prop model",
                },
                cctvRepairAnimDict = {
                    description = "Animation dictionary used while repairing CCTV cameras.",
                    label = "Repair animation dict",
                },
                cctvRepairAnimFlag = {
                    description = "Animation flag used while repairing CCTV cameras.",
                    label = "Repair animation flag",
                },
                cctvRepairAnimName = {
                    description = "Animation name used while repairing CCTV cameras.",
                    label = "Repair animation name",
                },
                cctvRepairCancelDelayMs = {
                    description = "Milliseconds before CCTV repair can be cancelled.",
                    label = "Repair cancel delay",
                },
                cctvRepairDistance = {
                    description = "Distance used to repair CCTV cameras.",
                    label = "Repair distance",
                },
                cctvRepairItem = {
                    description = "Inventory item used to repair CCTV cameras.",
                    label = "Repair item",
                },
                cctvRepairPerTick = {
                    description = "Durability restored per CCTV repair tick.",
                    label = "Repair per tick",
                },
                cctvRepairTickMs = {
                    description = "Milliseconds between CCTV repair ticks.",
                    label = "Repair tick",
                },
                cctvRotateStep = {
                    description = "Rotation step used while positioning CCTV cameras.",
                    label = "Rotate step",
                },
                cctvStreamDistance = {
                    description = "Distance used to stream CCTV cameras.",
                    label = "Stream distance",
                },
                cctvViewOffset = {
                    description = "View offset used for CCTV live camera rendering.",
                    label = "View offset",
                },
                crimeSceneTapeCollisionEnabled = {
                    description = "Creates a blocking collision barrier along the tape so players cannot walk through it.",
                    label = "Blocking tape collision",
                },
                crimeSceneTapeConsumeItem = {
                    description = "Remove one tape item from the inventory after successful placement.",
                    label = "Consume tape item",
                },
                crimeSceneTapeDynamic = {
                    description = "Let the tape react to physics and gravity instead of freezing it in place.",
                    label = "Dynamic physics",
                },
                crimeSceneTapeEnabled = {
                    description = "Enable placing crime scene tape from an inventory item.",
                    label = "Crime scene tape",
                },
                crimeSceneTapeEnforceRemovalAccess = {
                    description = "Only allowed jobs may remove the tape and, when enabled, they must be on duty.",
                    label = "Restrict removal",
                },
                crimeSceneTapeItem = {
                    description = "Inventory item name that starts crime scene tape placement.",
                    label = "Tape item",
                },
                crimeSceneTapeJobs = {
                    description = "Job names allowed to use crime scene tape.",
                    itemLabel = "Job",
                    label = "Allowed jobs",
                },
                crimeSceneTapeLabel = {
                    description = "Display name shown for crime scene tape during placement.",
                    label = "Tape label",
                },
                crimeSceneTapeLengthStep = {
                    description = "Increment in metres to which the selected tape length is rounded.",
                    label = "Length increment",
                },
                crimeSceneTapeMaxLength = {
                    description = "Longest permitted distance between the two tape posts, in metres.",
                    label = "Maximum tape length",
                },
                crimeSceneTapeMaxPlacementDistance = {
                    description = "Maximum distance of either endpoint from the officer placing the tape.",
                    label = "Maximum placement distance",
                },
                crimeSceneTapeMinLength = {
                    description = "Shortest permitted distance between the two tape posts, in metres.",
                    label = "Minimum tape length",
                },
                crimeSceneTapeModel = {
                    description = "Prop model name used for placed crime scene tape.",
                    label = "Tape model",
                },
                crimeSceneTapePostModel = {
                    description = "Prop model used for both tape posts.",
                    label = "Post model",
                },
                crimeSceneTapeRemoveDistance = {
                    description = "Maximum distance from which placed crime scene tape can be removed.",
                    label = "Removal distance",
                },
                crimeSceneTapeRequireOnDuty = {
                    description = "Only on-duty members of allowed jobs may place the tape.",
                    label = "Require on duty",
                },
                crimeSceneTapeReturnItemOnRemove = {
                    description = "Return the consumed item when placed tape is removed.",
                    label = "Return item on removal",
                },
                crimeSceneTapeSag = {
                    description = "Maximum downward sag of the tape between the posts, in metres.",
                    label = "Tape sag",
                },
                crimeSceneTapeSections = {
                    description = "Native tape section models used to assemble the selected length.",
                    itemLabel = "Tape section",
                    label = "Tape sections",
                },
                crimeSceneTapeShowPosts = {
                    description = "Spawns visible support posts at both ends of variable-length crime scene tape.",
                    label = "Show tape posts",
                },
                crimeSceneTapeStreamDistance = {
                    description = "Distance within which placed crime scene tape is streamed.",
                    label = "Stream distance",
                },
                crimeSceneTapeTapeHeight = {
                    description = "Height of the tape above the selected ground points.",
                    label = "Tape height",
                },
                crimeSceneTapeVariableLength = {
                    description = "Let officers set a start and end point to place crime scene tape at an adjustable length.",
                    label = "Variable tape length",
                },
                crimeSceneTapeZOffset = {
                    description = "Vertical offset applied when placing the tape model.",
                    label = "Height offset",
                },
                cuffsAnimDict = {
                    description = "Animation dictionary used for restrained players.",
                    label = "Animation dict",
                },
                cuffsAnimFlag = {
                    description = "Animation flag used for restrained players.",
                    label = "Animation flag",
                },
                cuffsAnimName = {
                    description = "Animation name used for restrained players.",
                    label = "Animation name",
                },
                cuffsConsumeItem = {
                    description = "Remove the handcuff item when cuffs are applied.",
                    label = "Consume cuffs",
                },
                cuffsEnabled = {
                    description = "Enable handcuff actions.",
                    label = "Handcuffs",
                },
                cuffsEscapeEnabled = {
                    description = "Enable the cuff escape minigame.",
                    label = "Cuff escape",
                },
                cuffsEscapeKeyPool = {
                    description = "Keys that can appear in the cuff escape minigame.",
                    itemLabel = "Key",
                    label = "Escape key pool",
                },
                cuffsEscapeRounds = {
                    description = "Number of rounds required in the cuff escape minigame.",
                    label = "Escape rounds",
                },
                cuffsEscapeWindowMs = {
                    description = "Milliseconds allowed per cuff escape input window.",
                    label = "Escape window",
                },
                cuffsHandsUpEnabled = {
                    description = "Enable the hands-up state used by cuffs and zipties.",
                    label = "Hands up",
                },
                cuffsHandsUpHoldSeconds = {
                    description = "Seconds the hands-up key must be held before activation.",
                    label = "Hands up hold seconds",
                },
                cuffsHandsUpKey = {
                    description = "Keyboard key used to raise hands.",
                    label = "Hands up key",
                },
                cuffsItem = {
                    description = "Inventory item used for handcuff actions.",
                    label = "Cuff item",
                },
                cuffsMaxDistance = {
                    description = "Maximum target distance for cuff actions.",
                    label = "Cuff distance",
                },
                cuffsRequireItem = {
                    description = "Require the configured handcuff item.",
                    label = "Cuffs require item",
                },
                cuffsRequireOnDuty = {
                    description = "Require duty state before handcuffing.",
                    label = "Cuffs require duty",
                },
                cuffsReturnOnRemove = {
                    description = "Return the handcuff item when cuffs are removed.",
                    label = "Return cuffs",
                },
                dispatchOfficerDownEnabled = {
                    description = "Send a dispatch alert when an on-duty officer goes down.",
                    label = "Officer down alerts",
                },
                dispatchOfficerDownJobs = {
                    description = "Jobs that should receive officer down dispatches.",
                    itemLabel = "Job",
                    label = "Officer down jobs",
                },
                dispatchOfficerDownRequireDuty = {
                    description = "Only notify players that are currently on duty.",
                    label = "Officer down requires duty",
                },
                dispatchShotsFiredChance = {
                    description = "Chance from 0.0 to 1.0 that a detected gunshot creates an alert.",
                    label = "Alert chance",
                },
                dispatchShotsFiredCooldownSeconds = {
                    description = "Seconds before the same player can trigger another shots fired alert.",
                    label = "Shots fired cooldown",
                },
                dispatchShotsFiredEnabled = {
                    description = "Enable shots fired dispatch alerts.",
                    label = "Shots fired alerts",
                },
                dispatchShotsFiredIgnoredWeapons = {
                    description = "Weapons that should not trigger shots fired alerts.",
                    itemLabel = "Weapon",
                    label = "Ignored weapons",
                },
                dispatchShotsFiredJobs = {
                    description = "Jobs that should receive shots fired dispatches.",
                    itemLabel = "Job",
                    label = "Shots fired jobs",
                },
                dispatchShotsFiredRequireDuty = {
                    description = "Only notify players that are currently on duty.",
                    label = "Shots fired require duty",
                },
                dispatchShotsFiredSendDispatch = {
                    description = "Create dispatch entries when shots fired are detected.",
                    label = "Send shots fired dispatch",
                },
                dispatchShotsFiredSuppressedChance = {
                    description = "Chance from 0.0 to 1.0 that a suppressed gunshot creates an alert.",
                    label = "Suppressed alert chance",
                },
                escortEnabled = {
                    description = "Enable escorting players.",
                    label = "Escort",
                },
                escortMaxDistance = {
                    description = "Maximum distance to start escorting a player.",
                    label = "Escort distance",
                },
                escortRequireOnDuty = {
                    description = "Require duty state before escorting players.",
                    label = "Escort requires duty",
                },
                escortVehicleDistance = {
                    description = "Maximum distance to place an escorted player into a vehicle.",
                    label = "Escort vehicle distance",
                },
                evidenceBloodDamageThreshold = {
                    description = "Minimum damage threshold before blood evidence is created.",
                    label = "Blood damage threshold",
                },
                evidenceCasingCreateCooldownMs = {
                    description = "Milliseconds before another casing can be created.",
                    label = "Casing cooldown",
                },
                evidenceCasingMergeRadius = {
                    description = "Radius used to merge nearby casings.",
                    label = "Casing merge radius",
                },
                evidenceCleanupIntervalMs = {
                    description = "Milliseconds between evidence cleanup passes.",
                    label = "Cleanup interval",
                },
                evidenceCleanupTtlSeconds = {
                    description = "Seconds before field evidence expires automatically.",
                    label = "Cleanup TTL",
                },
                evidenceCleanerAllowEveryone = {
                    label = "Public cleaner access",
                    description = "Allow everyone to destroy traces with hydrogen peroxide. Disable to use the job and gang lists.",
                },
                evidenceCleanerJobs = {
                    label = "Cleaner jobs",
                    description = "Exact names allowed when public access is disabled. A matching job or gang grants access; empty lists deny access.",
                    itemLabel = "Job",
                },
                evidenceCleanerGangs = {
                    label = "Cleaner gangs",
                    description = "Exact names allowed when public access is disabled. A matching job or gang grants access; empty lists deny access.",
                    itemLabel = "Gang",
                },
                evidenceCollectDistance = {
                    description = "Distance used to collect field evidence.",
                    label = "Collect distance",
                },
                evidenceDiscoverDistance = {
                    description = "Distance used to discover nearby evidence markers.",
                    label = "Discover distance",
                },
                evidenceFieldEnabled = {
                    description = "Enable evidence creation and collection in the field.",
                    label = "Evidence field",
                },
                evidenceFieldFlashlightWeapon = {
                    description = "Weapon used to inspect and reveal evidence in the field.",
                    label = "Flashlight weapon",
                },
                evidenceGloveFreeHands = {
                    description = "Hand component IDs treated as not wearing gloves.",
                    label = "Glove-free hands",
                },
                evidenceGsrDurationSeconds = {
                    description = "Seconds gunshot residue stays on a player's hands.",
                    label = "GSR duration",
                },
                evidenceGsrGlovesProtectHands = {
                    description = "Prevent GSR from being applied when the shooter wears gloves.",
                    label = "Gloves protect hands",
                },
                evidenceGsrIgnoredWeapons = {
                    description = "Weapons that do not apply gunshot residue.",
                    label = "Ignored weapons",
                },
                evidenceGsrWashCheckIntervalMs = {
                    description = "Milliseconds between water/rain cleanup checks while GSR is active.",
                    label = "Wash check interval",
                },
                evidenceGsrWashInRain = {
                    description = "Allow rain to remove gunshot residue.",
                    label = "Wash in rain",
                },
                evidenceGsrWashInWater = {
                    description = "Allow water to remove gunshot residue.",
                    label = "Wash in water",
                },
                evidenceMarkerColor = {
                    description = "RGBA color used for field evidence markers.",
                    label = "Marker color",
                },
                evidenceMarkerDrawDistance = {
                    description = "Draw distance used for field evidence markers.",
                    label = "Draw distance",
                },
                evidenceMarkerOffset = {
                    description = "Vertical marker offset used for field evidence.",
                    label = "Offset",
                },
                evidenceMarkerScaleX = {
                    description = "Marker X scale used for field evidence.",
                    label = "Scale X",
                },
                evidenceMarkerScaleY = {
                    description = "Marker Y scale used for field evidence.",
                    label = "Scale Y",
                },
                evidenceMarkerScaleZ = {
                    description = "Marker Z scale used for field evidence.",
                    label = "Scale Z",
                },
                evidenceMarkerType = {
                    description = "Marker type used for field evidence.",
                    label = "Marker type",
                },
                evidenceMaxCreateDistance = {
                    description = "Maximum distance for creating evidence records.",
                    label = "Create distance",
                },
                evidenceSalivaConsentTimeoutMs = {
                    description = "Milliseconds allowed for saliva sample consent.",
                    label = "Saliva consent timeout",
                },
                evidenceScannerDistance = {
                    description = "Distance used for evidence scanner interactions.",
                    label = "Scanner distance",
                },
                evidenceScannerDurationMs = {
                    description = "Fingerprint/scanner action duration in milliseconds.",
                    label = "Scanner duration",
                },
                evidenceStorageMaxCompartments = {
                    description = "Maximum number of evidence storage compartments.",
                    label = "Storage compartments",
                },
                fakePlateHeliDisplay = {
                    label = "Helicam shows fake plate",
                    description = "Displays the fake plate in the helicopter camera.",
                },
                fakePlateNormalToolsDisplay = {
                    label = "Normal tools show fake plate",
                    description = "Displays the fake plate in standard police tools.",
                },
                fakePlateRadarDisplay = {
                    label = "Radar shows fake plate",
                    description = "Displays the fake plate on the onboard radar.",
                },
                fakePlateRecognitionEnabled = {
                    description = "Allow police systems to read the shared fake plate statebag.",
                    label = "Recognize fake plates",
                },
                fakePlateRecognitionStateBagKey = {
                    description = "Vehicle entity statebag key published by Mechanicjob.",
                    label = "Statebag key",
                },
                fakePlateSpeedCamDisplay = {
                    label = "Speedcam shows fake plate",
                    description = "Displays the fake plate in fixed radar reports.",
                },
                fakePlateVinAllowedGrades = {
                    description = "Optional job/grade allow-list. Leave empty to allow all grades of the allowed jobs.",
                    label = "VIN grades",
                },
                fakePlateVinAllowedGangs = {
                    label = "Allowed gangs",
                    description = "Select exact gang or independent organization names. A matching job or gang grants the configured permission or exemption. Job duty requirements apply only to jobs.",
                    itemLabel = "Gang",
                },
                fakePlateVinAllowedGangGrades = {
                    label = "Gang minimum ranks",
                    description = "Optional minimum gang ranks. Empty allows all ranks. Item requirements still apply.",
                },
                fakePlateVinAllowedJobs = {
                    label = "VIN jobs",
                    description = "Jobs allowed to use VIN verification.",
                },
                fakePlateVinAudit = {
                    label = "Audit VIN checks",
                    description = "Saves VIN checks to the audit log.",
                },
                fakePlateVinCheckEnabled = {
                    label = "VIN check enabled",
                    description = "Enables the vehicle VIN verification command.",
                },
                fakePlateVinCommand = {
                    label = "VIN command",
                    description = "Command used to verify a vehicle's VIN.",
                },
                fakePlateVinCooldown = {
                    label = "VIN cooldown",
                    description = "Delay between two VIN checks.",
                },
                fakePlateVinDistance = {
                    label = "VIN max distance",
                    description = "Maximum distance between the officer and the vehicle to verify its VIN.",
                },
                fakePlateVinIndicator = {
                    label = "Show fake indicator",
                    description = "Displays an indicator when a check detects a fake plate.",
                },
                fakePlateVinRequireDuty = {
                    label = "Require duty",
                    description = "Requires the officer to be on duty to verify a VIN.",
                },
                fakePlateVinRequireScanner = {
                    label = "Require scanner item",
                    description = "Requires the configured scanner object to verify a VIN.",
                },
                fakePlateVinScannerItem = {
                    label = "Scanner item",
                    description = "Inventory item required to verify a VIN.",
                },
                gpsTrackerBeepDistance = {
                    description = "Distance where GPS tracker beep feedback becomes relevant.",
                    label = "Beep distance",
                },
                gpsTrackerBeepIntervalFarMs = {
                    description = "Milliseconds between beeps when far from a tracker.",
                    label = "Far beep interval",
                },
                gpsTrackerBeepIntervalNearMs = {
                    description = "Milliseconds between beeps when close to a tracker.",
                    label = "Near beep interval",
                },
                gpsTrackerConsumeOnPlace = {
                    description = "Remove the tracker item after placement.",
                    label = "Consume GPS tracker",
                },
                gpsTrackerEnabled = {
                    description = "Enable vehicle GPS tracker placement and scanning.",
                    label = "GPS tracker",
                },
                gpsTrackerItem = {
                    description = "Inventory item used to place GPS trackers.",
                    label = "Tracker item",
                },
                gpsTrackerMapUpdateIntervalMs = {
                    description = "Milliseconds between tracker map updates.",
                    label = "Map update interval",
                },
                gpsTrackerPlaceDistance = {
                    description = "Maximum distance to place a GPS tracker on a vehicle.",
                    label = "Place distance",
                },
                gpsTrackerRemoveDistance = {
                    description = "Maximum distance to remove a placed GPS tracker.",
                    label = "Remove distance",
                },
                gpsTrackerRemoveKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Remove GPS tracker",
                },
                gpsTrackerRequireOnDuty = {
                    description = "Require duty state before using GPS trackers.",
                    label = "GPS requires duty",
                },
                gpsTrackerRequirePoliceJob = {
                    description = "Require the player to be in the police group before using GPS trackers.",
                    label = "GPS requires police job",
                },
                gpsTrackerReturnOnRemove = {
                    description = "Return the tracker item when it is removed.",
                    label = "Return tracker on remove",
                },
                gpsTrackerScanDistance = {
                    description = "Maximum distance to scan for trackers.",
                    label = "GPS scan distance",
                },
                gpsTrackerScanDurationMs = {
                    description = "Milliseconds spent scanning for a GPS tracker.",
                    label = "Scan duration",
                },
                gpsTrackerScannerWeapon = {
                    description = "Weapon or tool used to scan for GPS trackers.",
                    label = "Scanner weapon",
                },
                impoundAccount = {
                    description = "Account used to charge impound releases.",
                    label = "Payment account",
                },
                impoundCreatorVehicleModel = {
                    description = "Vehicle model shown by the impound creator preview.",
                    label = "Creator vehicle model",
                },
                impoundCustomGarageEnabled = {
                    description = "Use a custom garage impound interface when available.",
                    label = "Custom garage impound",
                },
                impoundDefaultPrice = {
                    description = "Default impound release price.",
                    label = "Default price",
                },
                impoundDeliveryDistance = {
                    description = "Distance used for impound delivery interactions.",
                    label = "Delivery distance",
                },
                impoundDeliveryMarker = {
                    description = "Marker configuration used for impound deliveries.",
                    label = "Delivery marker",
                },
                impoundEnabled = {
                    description = "Enable impound workflows.",
                    label = "Impound",
                },
                impoundMarker = {
                    description = "Marker configuration used for impound interactions.",
                    label = "Impound marker",
                },
                impoundRadialEnabled = {
                    description = "Enable radial impound actions.",
                    label = "Impound action",
                },
                impoundRadialRequireOnDuty = {
                    description = "Require duty state before using the radial impound action.",
                    label = "Impound requires duty",
                },
                impoundRadialVehicleDistance = {
                    description = "Maximum distance to the target vehicle for radial impound actions.",
                    label = "Impound vehicle distance",
                },
                impoundReleaseDistance = {
                    description = "Distance used for impound release interactions.",
                    label = "Release distance",
                },
                impoundReleaseKey = {
                    description = "Control code used to release impounded vehicles.",
                    label = "Release key",
                },
                impoundRequireDelivery = {
                    description = "Require delivery to a configured impound lot.",
                    label = "Require delivery",
                },
                impoundStorageBasePrice = {
                    description = "Base release price for stored impound vehicles.",
                    label = "Storage base price",
                },
                impoundStorageDailyFee = {
                    description = "Additional impound storage fee per configured day.",
                    label = "Storage daily fee",
                },
                impoundStorageDaySeconds = {
                    description = "How many seconds count as one storage billing day.",
                    label = "Storage day seconds",
                },
                impoundStorageEnabled = {
                    description = "Enable paid impound storage handling.",
                    label = "Impound storage",
                },
                jailAssignRange = {
                    description = "Maximum distance to assign a target to jail.",
                    label = "Assign range",
                },
                jailCanteenCooldownMinutes = {
                    description = "Minutes a prisoner must wait before claiming another canteen package.",
                    label = "Cooldown minutes",
                },
                jailCanteenPackage = {
                    description = "Items granted by the jail canteen package.",
                    label = "Canteen package",
                },
                jailCellStreamDistance = {
                    description = "Distance used for solitary cell prop streaming.",
                    label = "Cell stream distance",
                },
                jailClearInventory = {
                    description = "Clear player inventory when sending them to jail.",
                    label = "Clear inventory",
                },
                jailDefaultMonths = {
                    description = "Default jail duration when opening the assignment UI.",
                    label = "Default months",
                },
                jailDispatchJobs = {
                    description = "Jobs that should receive jail dispatches.",
                    itemLabel = "Job",
                    label = "Dispatch jobs",
                },
                jailDoctorHealEvent = {
                    description = "Server or client event triggered when the jail doctor heals a prisoner.",
                    label = "Heal event",
                },
                jailElectricalCodeListItem = {
                    description = "Inventory item required to reveal generated electrical codes.",
                    label = "Code list item",
                },
                jailElectricalCodeMax = {
                    description = "Highest random code value for the electrical box.",
                    label = "Maximum code",
                },
                jailElectricalCodeMin = {
                    description = "Lowest random code value for the electrical box.",
                    label = "Minimum code",
                },
                jailElectricalCodesCount = {
                    description = "How many candidate codes are generated for the electrical box.",
                    label = "Codes count",
                },
                jailElectricalEnabled = {
                    description = "Enable the jail electrical breakout minigame.",
                    label = "Electrical box",
                },
                jailElectricalPinLength = {
                    description = "Number of digits used for electrical box PIN codes.",
                    label = "PIN length",
                },
                jailElectricalPropModel = {
                    description = "World prop model used for the jail electrical box.",
                    label = "Prop model",
                },
                jailElectricalShockDamage = {
                    description = "Damage dealt when a prisoner fails the electrical sequence.",
                    label = "Shock damage",
                },
                jailElectricalShockRagdollMs = {
                    description = "Milliseconds of ragdoll after an electrical shock.",
                    label = "Shock ragdoll",
                },
                jailElectricalSuccessReduceMinutes = {
                    description = "Sentence minutes removed after a successful electrical escape attempt.",
                    label = "Success reduce minutes",
                },
                jailInmateAlcoholicRequiredAmount = {
                    description = "Amount required for the alcoholic inmate trade.",
                    label = "Required amount",
                },
                jailInmateAlcoholicRequiredItem = {
                    description = "Item required for the alcoholic inmate trade.",
                    label = "Required item",
                },
                jailInmateAlcoholicRewardAmount = {
                    description = "Reward amount for the alcoholic inmate trade.",
                    label = "Reward amount",
                },
                jailInmateAlcoholicRewardItem = {
                    description = "Reward item for the alcoholic inmate trade.",
                    label = "Reward item",
                },
                jailInmateAlcoholicRewardLabel = {
                    description = "Reward label shown for the alcoholic inmate trade.",
                    label = "Reward label",
                },
                jailInmateCodeListRequiredAmount = {
                    description = "Amount required for the informant inmate trade.",
                    label = "Required amount",
                },
                jailInmateCodeListRequiredItem = {
                    description = "Item required for the informant inmate trade.",
                    label = "Required item",
                },
                jailInmateCodeListRewardAmount = {
                    description = "Reward amount for the informant inmate trade.",
                    label = "Reward amount",
                },
                jailInmateCodeListRewardItem = {
                    description = "Reward item for the informant inmate trade.",
                    label = "Reward item",
                },
                jailInmateCodeListRewardLabel = {
                    description = "Reward label shown for the informant inmate trade.",
                    label = "Reward label",
                },
                jailInmateDrugDealerAcceptedItems = {
                    description = "Accepted items for the drug dealer inmate trade.",
                    label = "Accepted items",
                },
                jailInmateDrugDealerRequiredAmount = {
                    description = "Amount required for the drug dealer inmate trade.",
                    label = "Required amount",
                },
                jailInmateDrugDealerRewardAmount = {
                    description = "Reward amount for the drug dealer inmate trade.",
                    label = "Reward amount",
                },
                jailInmateDrugDealerRewardItem = {
                    description = "Reward item for the drug dealer inmate trade.",
                    label = "Reward item",
                },
                jailInmateDrugDealerRewardLabel = {
                    description = "Reward label shown for the drug dealer inmate trade.",
                    label = "Reward label",
                },
                jailInmateDrugDealerUseCleaningContraband = {
                    description = "Allow contraband found during jail cleaning to count for the drug dealer inmate trade.",
                    label = "Use cleaning contraband",
                },
                jailInmateWireCutterRequiredAmount = {
                    description = "Amount required for the tool runner inmate trade.",
                    label = "Required amount",
                },
                jailInmateWireCutterRequiredItem = {
                    description = "Item required for the tool runner inmate trade.",
                    label = "Required item",
                },
                jailInmateWireCutterRewardAmount = {
                    description = "Reward amount for the tool runner inmate trade.",
                    label = "Reward amount",
                },
                jailInmateWireCutterRewardItem = {
                    description = "Reward item for the tool runner inmate trade.",
                    label = "Reward item",
                },
                jailInmateWireCutterRewardLabel = {
                    description = "Reward label shown for the tool runner inmate trade.",
                    label = "Reward label",
                },
                jailJobsCarryBoxModel = {
                    description = "Prop model used for the carry jail job box.",
                    label = "Carry box model",
                },
                jailJobsCarryDropoffKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Prison work: drop off",
                },
                jailJobsCarryDropoffRadius = {
                    description = "Dropoff radius for the carry jail job.",
                    label = "Dropoff radius",
                },
                jailJobsCarryInspectKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Prison work: inspect",
                },
                jailJobsCarryInspectionJunkItems = {
                    description = "Junk items that can be found while inspecting carry job boxes.",
                    label = "Junk inspection items",
                },
                jailJobsCarryInspectionUsableChance = {
                    description = "Chance for a usable loot reward when inspecting boxes.",
                    label = "Usable loot chance",
                },
                jailJobsCarryInspectionUsableItems = {
                    description = "Usable items that can be found while inspecting carry job boxes.",
                    label = "Usable inspection items",
                },
                jailJobsCarryInteractDistance = {
                    description = "Interaction distance for the carry jail job.",
                    label = "Carry interact distance",
                },
                jailJobsCarryMaxDistance = {
                    description = "Maximum allowed distance for carry jail job progression.",
                    label = "Carry max distance",
                },
                jailJobsCarryPickupKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Prison work: pick up",
                },
                jailJobsCarryPickupOffset = {
                    description = "Offset object used for the carry job pickup location.",
                    label = "Pickup offset",
                },
                jailJobsCarryTimeReduction = {
                    description = "Sentence reduction for completing the carry jail job.",
                    label = "Carry time reduction",
                },
                jailJobsCleaningDumpsterKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Cleaning: dispose",
                },
                jailJobsCleaningDumpsterModel = {
                    description = "Model used for the jail cleaning dumpster prop.",
                    label = "Dumpster model",
                },
                jailJobsCleaningIllegalFindChance = {
                    description = "Chance to find contraband while cleaning.",
                    label = "Illegal find chance",
                },
                jailJobsCleaningIllegalFindItems = {
                    description = "Items that can be found while cleaning in jail.",
                    label = "Illegal find items",
                },
                jailJobsCleaningIllegalFindPromptTimeoutMs = {
                    description = "Timeout for illegal find prompts in milliseconds.",
                    label = "Find prompt timeout",
                },
                jailJobsCleaningInteractDistance = {
                    description = "Distance used for cleaning trash interaction.",
                    label = "Cleaning interact distance",
                },
                jailJobsCleaningMaxDistance = {
                    description = "Maximum distance before cleaning props reset or despawn.",
                    label = "Cleaning max distance",
                },
                jailJobsCleaningMaxTrashProps = {
                    description = "Maximum simultaneous trash props for jail cleaning.",
                    label = "Maximum trash props",
                },
                jailJobsCleaningMinSpawnRadius = {
                    description = "Minimum distance from the center for cleaning trash spawns.",
                    label = "Minimum spawn radius",
                },
                jailJobsCleaningPickupKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Cleaning: pick up",
                },
                jailJobsCleaningSpawnIntervalMs = {
                    description = "Milliseconds between cleaning trash spawn attempts.",
                    label = "Trash spawn interval",
                },
                jailJobsCleaningSpawnRadius = {
                    description = "Radius used to spawn cleaning trash props.",
                    label = "Trash spawn radius",
                },
                jailJobsCleaningTrashModels = {
                    description = "Trash prop models used for the jail cleaning job.",
                    itemLabel = "Model",
                    label = "Trash models",
                },
                jailJobsCleaningTrashOutlineColor = {
                    description = "RGBA outline color used for jail cleaning trash props.",
                    label = "Outline color",
                },
                jailJobsCleaningTrashOutlineEnabled = {
                    description = "Enable outlines on jail cleaning trash props.",
                    label = "Trash outline",
                },
                jailJobsCleaningTrashOutlineShader = {
                    description = "Shader ID used for jail cleaning trash outlines.",
                    label = "Outline shader",
                },
                jailJobsTimeReduction = {
                    description = "Sentence reduction for completing the cleaning jail job.",
                    label = "Cleaning time reduction",
                },
                jailJobsTrashGoal = {
                    description = "Trash items needed to complete the cleaning jail job.",
                    label = "Cleaning trash goal",
                },
                jailMaxMonths = {
                    description = "Maximum selectable jail duration.",
                    label = "Maximum months",
                },
                jailMinMonths = {
                    description = "Minimum selectable jail duration.",
                    label = "Minimum months",
                },
                jailMonthMinutes = {
                    description = "Real-time minutes represented by one jail month.",
                    label = "Minutes per month",
                },
                jailObjectStreamDistance = {
                    description = "Distance used for persistent jail world object streaming.",
                    label = "Object stream distance",
                },
                jailOutfitApplyDelayMs = {
                    description = "Delay after joining before the jail outfit is applied.",
                    label = "Outfit apply delay",
                },
                jailOutfitEnabled = {
                    description = "Enable jail outfits.",
                    label = "Jail outfit",
                },
                jailOutfitFemaleArms = {
                    description = "Female jail outfit arms component.",
                    label = "Arms",
                },
                jailOutfitFemaleChain1 = {
                    description = "Female jail outfit chain drawable.",
                    label = "Chain 1",
                },
                jailOutfitFemaleChain2 = {
                    description = "Female jail outfit chain texture.",
                    label = "Chain 2",
                },
                jailOutfitFemaleDecals1 = {
                    description = "Female jail outfit decals drawable.",
                    label = "Decals 1",
                },
                jailOutfitFemaleDecals2 = {
                    description = "Female jail outfit decals texture.",
                    label = "Decals 2",
                },
                jailOutfitFemaleGlasses1 = {
                    description = "Female jail outfit glasses drawable (-1 removes glasses).",
                    label = "Glasses 1",
                },
                jailOutfitFemaleGlasses2 = {
                    description = "Female jail outfit glasses texture.",
                    label = "Glasses 2",
                },
                jailOutfitFemaleHelmet1 = {
                    description = "Female jail outfit helmet drawable.",
                    label = "Helmet 1",
                },
                jailOutfitFemaleHelmet2 = {
                    description = "Female jail outfit helmet texture.",
                    label = "Helmet 2",
                },
                jailOutfitFemalePants1 = {
                    description = "Female jail outfit pants drawable.",
                    label = "Pants 1",
                },
                jailOutfitFemalePants2 = {
                    description = "Female jail outfit pants texture.",
                    label = "Pants 2",
                },
                jailOutfitFemaleShoes1 = {
                    description = "Female jail outfit shoes drawable.",
                    label = "Shoes 1",
                },
                jailOutfitFemaleShoes2 = {
                    description = "Female jail outfit shoes texture.",
                    label = "Shoes 2",
                },
                jailOutfitFemaleTorso1 = {
                    description = "Female jail outfit torso drawable.",
                    label = "Torso 1",
                },
                jailOutfitFemaleTorso2 = {
                    description = "Female jail outfit torso texture.",
                    label = "Torso 2",
                },
                jailOutfitFemaleTshirt1 = {
                    description = "Female jail outfit T-shirt drawable.",
                    label = "T-Shirt 1",
                },
                jailOutfitFemaleTshirt2 = {
                    description = "Female jail outfit T-shirt texture.",
                    label = "T-Shirt 2",
                },
                jailOutfitMaleArms = {
                    description = "Male jail outfit arms component.",
                    label = "Arms",
                },
                jailOutfitMaleChain1 = {
                    description = "Male jail outfit chain drawable.",
                    label = "Chain 1",
                },
                jailOutfitMaleChain2 = {
                    description = "Male jail outfit chain texture.",
                    label = "Chain 2",
                },
                jailOutfitMaleDecals1 = {
                    description = "Male jail outfit decals drawable.",
                    label = "Decals 1",
                },
                jailOutfitMaleDecals2 = {
                    description = "Male jail outfit decals texture.",
                    label = "Decals 2",
                },
                jailOutfitMaleGlasses1 = {
                    description = "Male jail outfit glasses drawable (-1 removes glasses).",
                    label = "Glasses 1",
                },
                jailOutfitMaleGlasses2 = {
                    description = "Male jail outfit glasses texture.",
                    label = "Glasses 2",
                },
                jailOutfitMaleHelmet1 = {
                    description = "Male jail outfit helmet drawable.",
                    label = "Helmet 1",
                },
                jailOutfitMaleHelmet2 = {
                    description = "Male jail outfit helmet texture.",
                    label = "Helmet 2",
                },
                jailOutfitMalePants1 = {
                    description = "Male jail outfit pants drawable.",
                    label = "Pants 1",
                },
                jailOutfitMalePants2 = {
                    description = "Male jail outfit pants texture.",
                    label = "Pants 2",
                },
                jailOutfitMaleShoes1 = {
                    description = "Male jail outfit shoes drawable.",
                    label = "Shoes 1",
                },
                jailOutfitMaleShoes2 = {
                    description = "Male jail outfit shoes texture.",
                    label = "Shoes 2",
                },
                jailOutfitMaleTorso1 = {
                    description = "Male jail outfit torso drawable.",
                    label = "Torso 1",
                },
                jailOutfitMaleTorso2 = {
                    description = "Male jail outfit torso texture.",
                    label = "Torso 2",
                },
                jailOutfitMaleTshirt1 = {
                    description = "Male jail outfit T-shirt drawable.",
                    label = "T-Shirt 1",
                },
                jailOutfitMaleTshirt2 = {
                    description = "Male jail outfit T-shirt texture.",
                    label = "T-Shirt 2",
                },
                jailRemoveJobOnJail = {
                    description = "Set the prisoner to unemployed when they are jailed.",
                    label = "Remove job on jail",
                },
                jailRequireJailTerminal = {
                    description = "Only allow officer-issued jail sentences near a terminal of the selected jail.",
                    label = "Require jail terminal",
                },
                jailRestoreOriginalJobOnRelease = {
                    description = "Restore the prisoner's original job after release. Disable to keep them unemployed.",
                    label = "Restore original job",
                },
                jailRestoreOutfitOnBreakout = {
                    description = "Restore the saved civilian outfit when a prisoner breaks out.",
                    label = "Restore outfit on breakout",
                },
                jailRestoreSpawnCorrectionMs = {
                    description = "Grace window after restore before spawn correction stops applying.",
                    label = "Restore correction window",
                },
                jailTeleportRestoreOutsideZone = {
                    description = "Teleport restored prisoners back to jail spawn if they load outside the jail zone.",
                    label = "Teleport restored prisoners",
                },
                jailTerminalRange = {
                    description = "Maximum officer distance from a terminal of the selected jail.",
                    label = "Jail terminal range",
                },
                jailZoneExitGraceMs = {
                    description = "Grace window before a jail zone exit can count as a breakout.",
                    label = "Zone exit grace",
                },
                mugshotAnimDict = {
                    description = "Animation dictionary used during mugshot capture.",
                    label = "Animation dict",
                },
                mugshotAnimFlag = {
                    description = "Animation flag used during mugshot capture.",
                    label = "Animation flag",
                },
                mugshotAnimName = {
                    description = "Animation name used during mugshot capture.",
                    label = "Animation name",
                },
                mugshotBoardHeader = {
                    description = "Main header shown on the mugshot board.",
                    label = "Board header",
                },
                mugshotBoardSubheader = {
                    description = "Fallback subheader shown on the mugshot board.",
                    label = "Board subheader",
                },
                mugshotCameraCoordsX = {
                    description = "Camera world X coordinate used for mugshots.",
                    label = "Camera X",
                },
                mugshotCameraCoordsY = {
                    description = "Camera world Y coordinate used for mugshots.",
                    label = "Camera Y",
                },
                mugshotCameraCoordsZ = {
                    description = "Camera world Z coordinate used for mugshots.",
                    label = "Camera Z",
                },
                mugshotCameraFov = {
                    description = "Field of view used for mugshot captures.",
                    label = "Camera FOV",
                },
                mugshotCameraRotX = {
                    description = "Camera rotation X used for mugshots.",
                    label = "Rotation X",
                },
                mugshotCameraRotY = {
                    description = "Camera rotation Y used for mugshots.",
                    label = "Rotation Y",
                },
                mugshotCameraRotZ = {
                    description = "Camera rotation Z used for mugshots.",
                    label = "Rotation Z",
                },
                mugshotCaptureTimeout = {
                    description = "Maximum milliseconds allowed for mugshot capture callbacks.",
                    label = "Capture timeout",
                },
                mugshotEnabled = {
                    description = "Enable mugshot capture during jail intake.",
                    label = "Mugshot capture",
                },
                mugshotHeading = {
                    description = "Heading applied during mugshot capture.",
                    label = "Heading",
                },
                mugshotLocationX = {
                    description = "World X coordinate used for mugshot capture.",
                    label = "Location X",
                },
                mugshotLocationY = {
                    description = "World Y coordinate used for mugshot capture.",
                    label = "Location Y",
                },
                mugshotLocationZ = {
                    description = "World Z coordinate used for mugshot capture.",
                    label = "Location Z",
                },
                mugshotMetadataDescriptionFormat = {
                    description = "Description format used for the stored mugshot metadata.",
                    label = "Metadata description",
                },
                mugshotMetadataName = {
                    description = "Inventory metadata name used for the stored mugshot photo.",
                    label = "Metadata name",
                },
                mugshotWaitMs = {
                    description = "Milliseconds to wait before taking the mugshot photo.",
                    label = "Wait milliseconds",
                },
                playerSearchAnimDict = {
                    description = "Animation dictionary used during player searches.",
                    label = "Animation dict",
                },
                playerSearchAnimFlag = {
                    description = "Animation flag used during player searches.",
                    label = "Animation flag",
                },
                playerSearchAnimName = {
                    description = "Animation name used during player searches.",
                    label = "Animation name",
                },
                playerSearchDurationMs = {
                    description = "Duration of the player search preview in milliseconds.",
                    label = "Search duration",
                },
                playerSearchEnabled = {
                    description = "Enable player search preview workflow.",
                    label = "Player search",
                },
                playerSearchRange = {
                    description = "Maximum distance to start a player search.",
                    label = "Search range",
                },
                playerSearchScenario = {
                    description = "Scenario used when no explicit search animation is played.",
                    label = "Search scenario",
                },
                policeBillingControl200 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Billing · ESCAPE",
                },
                policeBillingControl322 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Billing · ESCAPE",
                },
                policeEditorControl10 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · PAGEUP",
                },
                policeEditorControl11 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · PAGEDOWN",
                },
                policeEditorControl172 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · UP",
                },
                policeEditorControl173 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · DOWN",
                },
                policeEditorControl174 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · LEFT",
                },
                policeEditorControl175 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · RIGHT",
                },
                policeEditorControl177 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · BACK",
                },
                policeEditorControl191 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · RETURN",
                },
                policeEditorControl201 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · RETURN",
                },
                policeEditorControl202 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · ESCAPE",
                },
                policeEditorControl21 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · LSHIFT",
                },
                policeEditorControl32 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · W",
                },
                policeEditorControl322 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · ESCAPE",
                },
                policeEditorControl33 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · S",
                },
                policeEditorControl34 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · A",
                },
                policeEditorControl35 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · D",
                },
                policeEditorControl36 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · LCONTROL",
                },
                policeEditorControl37 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · TAB",
                },
                policeEditorControl38 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · E",
                },
                policeEditorControl44 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · Q",
                },
                policeEditorControl73 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · X",
                },
                policePrimaryColor = {
                    description = "Default color for the police job group.",
                    label = "Primary color",
                },
                primaryColor = {
                    description = "Default color for the police job group.",
                    label = "Primary color",
                },
                propPlacementConsumeItem = {
                    description = "Remove one inventory item when a prop is placed from inventory.",
                    label = "Consume prop item",
                },
                propPlacementEnabled = {
                    description = "Allow configured police props to be placed from items or vehicles.",
                    label = "Prop placement",
                },
                propPlacementItemNames = {
                    description = "Map prop models to inventory item names for item-based prop placement.",
                    label = "Prop item names",
                },
                propPlacementRequireOnDuty = {
                    description = "Only on-duty officers can place configured props.",
                    label = "Props require duty",
                },
                propPlacementReturnItem = {
                    description = "Give the consumed item back when a placed prop is removed.",
                    label = "Return prop item",
                },
                propPlacementVehicleAccess = {
                    description = "Allow job vehicles to expose their configured prop loadout.",
                    label = "Vehicle prop access",
                },
                radialEnabled = {
                    description = "Enable police radial actions.",
                    label = "Police radial",
                },
                radialHandcuffKeybindCommand = {
                    description = "Command name registered for the handcuff keybind.",
                    label = "Handcuff command",
                },
                radialHandcuffKeybindDescription = {
                    description = "Description shown for the handcuff keybind.",
                    label = "Handcuff description",
                },
                radialHandcuffKeybindEnabled = {
                    description = "Enable the direct handcuff keybind.",
                    label = "Handcuff keybind",
                },
                radialHandcuffKeybindKey = {
                    description = "Keyboard key used for the direct handcuff action.",
                    label = "Handcuff key",
                },
                radialKeybindsEnabled = {
                    description = "Enable direct keybinds for selected radial actions.",
                    label = "Direct keybinds",
                },
                radialUnhandcuffKeybindCommand = {
                    description = "Command name registered for the unhandcuff keybind.",
                    label = "Unhandcuff command",
                },
                radialUnhandcuffKeybindDescription = {
                    description = "Description shown for the unhandcuff keybind.",
                    label = "Unhandcuff description",
                },
                radialUnhandcuffKeybindEnabled = {
                    description = "Enable the direct unhandcuff keybind.",
                    label = "Unhandcuff keybind",
                },
                radialUnhandcuffKeybindKey = {
                    description = "Keyboard key used for the direct unhandcuff action.",
                    label = "Unhandcuff key",
                },
                socialWorkAssignRange = {
                    description = "Maximum distance to assign social work tasks.",
                    label = "Assign range",
                },
                socialWorkDeadlineDefault = {
                    description = "Default social work deadline in minutes. Zero disables deadlines.",
                    label = "Default deadline",
                },
                socialWorkDeadlineMax = {
                    description = "Maximum social work deadline in minutes. Zero disables the cap.",
                    label = "Maximum deadline",
                },
                socialWorkDeadlineMin = {
                    description = "Minimum social work deadline in minutes.",
                    label = "Minimum deadline",
                },
                socialWorkDefaultTasks = {
                    description = "Default task amount when opening social work assignment.",
                    label = "Default tasks",
                },
                socialWorkEnabled = {
                    description = "Enable social work assignment and task workflows.",
                    label = "Social work",
                },
                socialWorkImprisonmentJailId = {
                    description = "Jail ID used when social work violations lead to imprisonment.",
                    label = "Fallback jail ID",
                },
                socialWorkImprisonmentMonths = {
                    description = "Months assigned when social work violations result in jail.",
                    label = "Imprisonment months",
                },
                socialWorkImprisonmentOfficerName = {
                    description = "Officer name used for social work imprisonment records.",
                    label = "Imprisonment officer name",
                },
                socialWorkImprisonmentSolitary = {
                    description = "Send violators to solitary when imprisonment triggers.",
                    label = "Use solitary imprisonment",
                },
                socialWorkInactivityMinutes = {
                    description = "Minutes before social work inactivity penalties apply.",
                    label = "Inactivity minutes",
                },
                socialWorkInactivityTaskPenalty = {
                    description = "Task penalty applied when a social work player stays inactive too long.",
                    label = "Inactivity task penalty",
                },
                socialWorkMaxTasks = {
                    description = "Maximum selectable social work tasks.",
                    label = "Maximum tasks",
                },
                socialWorkMinTasks = {
                    description = "Minimum selectable social work tasks.",
                    label = "Minimum tasks",
                },
                speedCamAdvancedAllowFakePlateApproval = {
                    description = "Allow reviewers to bill the registered owner even when the captured plate is flagged as fake or cloned.",
                    label = "Allow suspected fake plates",
                },
                speedCamProcessingMode = {
                    description = "Charge immediately, issue a Pay Later invoice, or store the capture for officer review. Pay Later uses the configured billing deadline.",
                    label = "Processing mode",
                    options = {
                        instant = "Charge immediately",
                        later = "Pay Later (default)",
                        review = "Officer review only",
                    },
                },
                speedCamAdvancedPageSize = {
                    description = "Maximum captures returned per tablet page.",
                    label = "Review page size",
                },
                speedCamAdvancedRecognizedSides = {
                    description = "Vehicle sides whose photos can be used for plate recognition. Use front and/or rear.",
                    itemLabel = "Side",
                    label = "Recognized sides",
                },
                speedCamAdvancedRequireEvidence = {
                    description = "Only allow approval after the speed camera photo upload completed.",
                    label = "Require photo evidence",
                },
                speedCamAdvancedReviewPermission = {
                    description = "Bossmenu permission required to approve or discard captures. 18 is Manage Billing.",
                    label = "Review permission ID",
                },
                speedCamAdvancedStoreUnregistered = {
                    description = "Keep captures whose plate is not present in the registered vehicle database.",
                    label = "Store unregistered vehicles",
                },
                speedCamBillingEnabled = {
                    description = "Issue automatic bills when speed cameras capture a matching offence. Requires the global Billing feature to be enabled.",
                    label = "Automatic fines",
                },
                speedCamBillingExcludedJobs = {
                    description = "Jobs that never receive automatic speed camera bills.",
                    itemLabel = "Job",
                    label = "Excluded jobs",
                },
                speedCamBillingExcludedModels = {
                    description = "Vehicle spawn names that never receive automatic speed camera bills.",
                    itemLabel = "Model",
                    label = "Excluded vehicle models",
                },
                speedCamBillingRules = {
                    description = "Fine rules used by speed cameras. The tightest matching overage range is billed first; if no rule matches, SpeedViolation offences are used as fallback.",
                    label = "Fine rules",
                },
                speedCamCameraEaseMs = {
                    description = "How long the view eases into the speed camera angle. Lower = shorter swing; too low can misalign the photo.",
                    label = "Camera ease (ms)",
                },
                speedCamCameraFov = {
                    description = "Field of view used for speed camera captures.",
                    label = "Camera FOV",
                },
                speedCamCheckIntervalMs = {
                    description = "Milliseconds between speed camera scans.",
                    label = "Check interval",
                },
                speedCamCooldownMs = {
                    description = "Milliseconds before the same speed camera can trigger again.",
                    label = "Trigger cooldown",
                },
                speedCamDamageCooldownMs = {
                    description = "Milliseconds before speed camera damage can be applied again.",
                    label = "Damage cooldown",
                },
                speedCamDamagePerHit = {
                    description = "Durability damage applied to speed cameras per hit.",
                    label = "Damage per hit",
                },
                speedCamDamagedModelThreshold = {
                    description = "Percentage of maximum durability at or below which the damaged model is shown. Example: 50 with maximum durability 200 switches at 100 durability.",
                    label = "Damaged model threshold (%)",
                },
                speedCamDefaultLimit = {
                    description = "Default speed camera limit.",
                    label = "Default speed limit",
                },
                speedCamDefaultName = {
                    description = "Suggested display name when placing a camera. This name can be translated without changing the inventory item or prop model.",
                    label = "Default name",
                },
                speedCamDefaultTolerance = {
                    description = "Default speed camera tolerance.",
                    label = "Default tolerance",
                },
                speedCamDisassembleDistance = {
                    description = "Distance used to disassemble speed cameras.",
                    label = "Disassemble distance",
                },
                speedCamEnabled = {
                    description = "Enable portable speed cameras.",
                    label = "Speed cameras",
                },
                speedCamFlashColor = {
                    description = "RGBA flash color used by speed cameras.",
                    label = "Flash color",
                },
                speedCamFlashDurationMs = {
                    description = "Fade-out time of the red speed camera flash. Do not set too low or the camera swing becomes visible.",
                    label = "Flash duration (ms)",
                },
                speedCamHealthDisplayDistance = {
                    description = "Distance at which speed camera health is shown.",
                    label = "Health display distance",
                },
                speedCamHealthDisplayDurationMs = {
                    description = "Milliseconds that speed camera health remains visible.",
                    label = "Health display duration",
                },
                speedCamHealthTextOffset = {
                    description = "Vertical offset used for speed camera health text.",
                    label = "Health text offset",
                },
                speedCamItem = {
                    description = "Exact inventory item name, e.g. speedcam. Use the item key, not its display label; the job shop must give the same item.",
                    label = "Speed camera item name",
                },
                speedCamMaintenanceThreshold = {
                    description = "Durability threshold where speed camera maintenance is recommended.",
                    label = "Maintenance threshold",
                },
                speedCamMaxDurability = {
                    description = "Maximum durability of deployed speed cameras.",
                    label = "Max durability",
                },
                speedCamMaxLimit = {
                    description = "Maximum configurable speed camera limit.",
                    label = "Maximum speed limit",
                },
                speedCamMaxTolerance = {
                    description = "Maximum configurable speed camera tolerance.",
                    label = "Maximum tolerance",
                },
                speedCamPhotoLocale = {
                    description = "Optional locale used for the timestamp on speed camera photos. Leave empty to use the flashed player's local locale.",
                    label = "Photo locale",
                },
                speedCamPhotoTimeZone = {
                    description = "Optional timezone used for the timestamp on speed camera photos. Leave empty to use the flashed player's local timezone.",
                    label = "Photo timezone",
                },
                speedCamPoliceNotification = {
                    description = "Send a dispatch notification when speed cameras capture violations.",
                    label = "Speedcam police alert",
                },
                speedCamPoliceNotificationGroup = {
                    description = "Treat the speed camera dispatch target as a job group.",
                    label = "Dispatch target is group",
                },
                speedCamPoliceNotificationJob = {
                    description = "Job or group key used for speed camera dispatch notifications.",
                    label = "Dispatch target",
                },
                speedCamPoliceNotificationRequireDuty = {
                    description = "Only notify speed camera dispatch targets that are on duty.",
                    label = "Dispatch requires duty",
                },
                speedCamPoliceNotificationType = {
                    description = "Dispatch severity/type used for speed camera alerts.",
                    label = "Dispatch type",
                },
                speedCamPropModel = {
                    description = "Spawn name of the intact camera prop, e.g. sky_speedcam. A preset also selects its damaged and destroyed models. Custom models must be available in the game.",
                    label = "Speedcam prop model",
                    custom = "Custom model",
                    choose = "Choose a model",
                    preview = "Preview in 3D",
                    customPlaceholder = "Prop spawn name",
                    previewDescription = "View the selected prop in the game. The preview does not save changes.",
                    invalidModel = "Enter a valid prop spawn name first.",
                    modelMissing = "This prop model is not available in the game.",
                    previewFailed = "Could not open the model preview.",
                    intact = "Intact prop model",
                    previewRequiresGame = "Open /jobconfig in FiveM to view the live prop.",
                    previewHelp = "Arrows move, PageUp/PageDown change height, mouse wheel rotates, Enter closes preview, Backspace cancels.",
                    options = {
                        sky_speedcam = "Standard speedcam",
                        sky_germ_speedcam = "German speedcam",
                    },
                },
                speedCamPropModelDamaged = {
                    description = "Spawn name of the damaged camera prop, e.g. sky_speedcam2. Choose a variant that matches the intact model.",
                    label = "Damaged prop model",
                },
                speedCamPropModelDestroyed = {
                    description = "Spawn name shown when camera durability reaches 0, e.g. sky_speedcam1. Choose a variant that matches the intact model.",
                    label = "Destroyed prop model",
                },
                speedCamRepairAnimDict = {
                    description = "Animation dictionary used while repairing speed cameras.",
                    label = "Repair animation dict",
                },
                speedCamRepairAnimFlag = {
                    description = "Animation flag used while repairing speed cameras.",
                    label = "Repair animation flag",
                },
                speedCamRepairAnimName = {
                    description = "Animation name used while repairing speed cameras.",
                    label = "Repair animation name",
                },
                speedCamRepairCancelDelayMs = {
                    description = "Milliseconds before speed camera repair can be cancelled.",
                    label = "Repair cancel delay",
                },
                speedCamRepairDistance = {
                    description = "Distance used to repair speed cameras.",
                    label = "Repair distance",
                },
                speedCamRepairItem = {
                    description = "Exact inventory item name used for repairs, e.g. fixtool. Use the item key, not its display label.",
                    label = "Repair item name",
                },
                speedCamRepairPerTick = {
                    description = "Durability restored per speed camera repair tick.",
                    label = "Repair per tick",
                },
                speedCamRepairTickMs = {
                    description = "Milliseconds between speed camera repair ticks.",
                    label = "Repair tick",
                },
                speedCamStreamDistance = {
                    description = "Distance in metres from the player within which camera props are loaded. Outside this distance the props are unloaded; saved cameras remain placed.",
                    label = "Stream distance",
                },
                speedCamTriggerRadius = {
                    description = "Detection radius in metres around the camera for speeding vehicles.",
                    label = "Trigger radius",
                },
                speedCamUseMph = {
                    description = "Display and process speed camera limits in MPH.",
                    label = "Use MPH",
                },
                speedCamWeaponDamageRestrictionAllowedWeapons = {
                    description = "Weapons that are allowed to damage speed cameras while the restriction is enabled.",
                    itemLabel = "Weapon",
                    label = "Allowed weapons",
                },
                speedCamWeaponDamageRestrictionEnabled = {
                    description = "Only listed weapons can damage speed cameras while this is enabled.",
                    label = "Restriction enabled",
                },
                speedCameraAppClearDistanceMeters = {
                    description = "Distance in meters before clearing speed camera warnings.",
                    label = "Clear distance",
                },
                speedCameraAppDefaultApp = {
                    description = "Show the speed camera app as a default tablet app.",
                    label = "Default app",
                },
                speedCameraAppDescription = {
                    description = "Description shown for the speed camera tablet app.",
                    label = "Description",
                },
                speedCameraAppDeveloper = {
                    description = "Developer label shown for the speed camera tablet app.",
                    label = "Developer",
                },
                speedCameraAppEnabled = {
                    description = "Enable the police tablet speed camera app.",
                    label = "Speed camera tablet app",
                },
                speedCameraAppHeaderEyebrow = {
                    description = "Header eyebrow shown in the speed camera app.",
                    label = "Header eyebrow",
                },
                speedCameraAppHeaderTitle = {
                    description = "Header title shown in the speed camera app.",
                    label = "Header title",
                },
                speedCameraAppIcon = {
                    description = "Icon path used for the speed camera tablet app.",
                    label = "Icon path",
                },
                speedCameraAppIdentifier = {
                    description = "Internal identifier for the speed camera tablet app.",
                    label = "Identifier",
                },
                speedCameraAppInFrontDot = {
                    description = "Dot threshold used to determine if a speed camera is in front of the player.",
                    label = "In front dot",
                },
                speedCameraAppMinimumVehicleSpeedKmh = {
                    description = "Minimum vehicle speed in KMH before warnings are shown.",
                    label = "Minimum vehicle speed",
                },
                speedCameraAppName = {
                    description = "Display name of the speed camera tablet app.",
                    label = "App name",
                },
                speedCameraAppNotifyDistanceMeters = {
                    description = "Distance in meters before notifying about nearby speed cameras.",
                    label = "Notify distance",
                },
                speedCameraAppOnlyInVehicle = {
                    description = "Only warn about speed cameras while the player is in a vehicle.",
                    label = "Only in vehicle",
                },
                speedCameraAppOverlayBackground = {
                    description = "Background color used for the plate image overlay.",
                    label = "Overlay background",
                },
                speedCameraAppOverlayBorder = {
                    description = "Border color used for the plate image overlay.",
                    label = "Overlay border",
                },
                speedCameraAppOverlayColor = {
                    description = "Text color used for the plate image overlay.",
                    label = "Overlay color",
                },
                speedCameraAppOverlayEnabled = {
                    description = "Enable plate image overlays on captured speed camera images.",
                    label = "Overlay enabled",
                },
                speedCameraAppOverlayFontScale = {
                    description = "Font scale used for the plate image overlay.",
                    label = "Overlay font scale",
                },
                speedCameraAppOverlayX = {
                    description = "Normalized overlay X position from left to right.",
                    label = "Overlay X",
                },
                speedCameraAppOverlayY = {
                    description = "Normalized overlay Y position from top to bottom.",
                    label = "Overlay Y",
                },
                speedCameraAppRequireInFront = {
                    description = "Only warn for speed cameras that are in front of the player.",
                    label = "Require in front",
                },
                speedCameraAppRoute = {
                    description = "Router path opened by the speed camera tablet app.",
                    label = "Route",
                },
                speedCameraAppSize = {
                    description = "Reported storage size for the speed camera tablet app.",
                    label = "App size",
                },
                speedCameraAppSoundCoord = {
                    description = "Play speed camera warning sounds at world coordinates.",
                    label = "Coordinate sound",
                },
                speedCameraAppSoundEnabled = {
                    description = "Enable warning sounds for the speed camera app.",
                    label = "Sound enabled",
                },
                speedCameraAppSoundFrontend = {
                    description = "Play speed camera warning sounds on the frontend audio channel.",
                    label = "Frontend sound",
                },
                speedCameraAppSoundLayers = {
                    description = "Number of layered warning sounds played by the speed camera app.",
                    label = "Sound layers",
                },
                speedCameraAppSoundName = {
                    description = "Sound name used for speed camera app warnings.",
                    label = "Sound name",
                },
                speedCameraAppSoundRange = {
                    description = "Range used for speed camera app warning sounds.",
                    label = "Sound range",
                },
                speedCameraAppSoundRepeatCount = {
                    description = "Number of times the speed camera warning sound repeats.",
                    label = "Repeat count",
                },
                speedCameraAppSoundRepeatDelayMs = {
                    description = "Milliseconds between speed camera warning sound repeats.",
                    label = "Repeat delay",
                },
                speedCameraAppSoundSet = {
                    description = "Sound set used for speed camera app warnings.",
                    label = "Sound set",
                },
                speedCameraAppSubscriptionAccount = {
                    description = "Account used for tablet speed camera app subscription payments.",
                    label = "Account",
                },
                speedCameraAppSubscriptionEnabled = {
                    description = "Enable paid subscriptions for the tablet speed camera app.",
                    label = "Subscription enabled",
                },
                speedCameraAppSubscriptionIntervalDays = {
                    description = "Days between tablet speed camera app subscription renewals.",
                    label = "Interval days",
                },
                speedCameraAppSubscriptionPrice = {
                    description = "Price charged for the tablet speed camera app subscription.",
                    label = "Subscription price",
                },
                speedCameraAppThemeAccent = {
                    description = "Accent color used by the speed camera app.",
                    label = "Accent",
                },
                speedCameraAppThemeBackground = {
                    description = "Linear-gradient background used by the speed camera app.",
                    label = "Background",
                },
                speedCameraAppThemeBorder = {
                    description = "Border color used by the speed camera app.",
                    label = "Border",
                },
                speedCameraAppThemeButtonText = {
                    description = "Button text color used by the speed camera app.",
                    label = "Button text",
                },
                speedCameraAppThemeDanger = {
                    description = "Danger color used by the speed camera app.",
                    label = "Danger",
                },
                speedCameraAppThemeGhost = {
                    description = "Ghost button color used by the speed camera app.",
                    label = "Ghost",
                },
                speedCameraAppThemeGhostText = {
                    description = "Ghost text color used by the speed camera app.",
                    label = "Ghost text",
                },
                speedCameraAppThemeGradientSoft = {
                    description = "Soft gradient color used by the speed camera app.",
                    label = "Gradient soft",
                },
                speedCameraAppThemeInactiveBorder = {
                    description = "Inactive border color used by the speed camera app.",
                    label = "Inactive border",
                },
                speedCameraAppThemeModal = {
                    description = "Modal background color used by the speed camera app.",
                    label = "Modal",
                },
                speedCameraAppThemeMutedText = {
                    description = "Muted text color used by the speed camera app.",
                    label = "Muted text",
                },
                speedCameraAppThemeOverlay = {
                    description = "Overlay color used by the speed camera app.",
                    label = "Overlay",
                },
                speedCameraAppThemePillText = {
                    description = "Pill text color used by the speed camera app.",
                    label = "Pill text",
                },
                speedCameraAppThemePrimaryFrom = {
                    description = "Primary gradient start color used by the speed camera app.",
                    label = "Primary from",
                },
                speedCameraAppThemePrimaryTo = {
                    description = "Primary gradient end color used by the speed camera app.",
                    label = "Primary to",
                },
                speedCameraAppThemeShadow = {
                    description = "Shadow color used by the speed camera app.",
                    label = "Shadow",
                },
                speedCameraAppThemeSpotlight = {
                    description = "Spotlight accent color used by the speed camera app.",
                    label = "Spotlight",
                },
                speedCameraAppThemeSubtleText = {
                    description = "Subtle text color used by the speed camera app.",
                    label = "Subtle text",
                },
                speedCameraAppThemeSuccess = {
                    description = "Success color used by the speed camera app.",
                    label = "Success",
                },
                speedCameraAppThemeSurface = {
                    description = "Surface color used by the speed camera app.",
                    label = "Surface",
                },
                speedCameraAppThemeSurfaceSoft = {
                    description = "Soft surface color used by the speed camera app.",
                    label = "Surface soft",
                },
                speedCameraAppThemeText = {
                    description = "Primary text color used by the speed camera app.",
                    label = "Text",
                },
                speedCameraAppWarningUiAccent = {
                    description = "RGBA accent color used for the speed camera warning UI.",
                    label = "Accent RGBA",
                },
                speedCameraAppWarningUiBackground = {
                    description = "RGBA color used for the speed camera warning UI background.",
                    label = "Background RGBA",
                },
                speedCameraAppWarningUiIcon = {
                    description = "RGBA icon color used for the speed camera warning UI.",
                    label = "Icon RGBA",
                },
                speedCameraAppWarningUiIconText = {
                    description = "RGBA icon text color used for the speed camera warning UI.",
                    label = "Icon text RGBA",
                },
                speedCameraAppWarningUiSeconds = {
                    description = "Seconds the warning UI remains visible.",
                    label = "Warning UI seconds",
                },
                speedCameraAppWarningUiSubText = {
                    description = "RGBA sub text color used for the speed camera warning UI.",
                    label = "Sub text RGBA",
                },
                speedCameraAppWarningUiText = {
                    description = "RGBA text color used for the speed camera warning UI.",
                    label = "Text RGBA",
                },
                speedCameraAppWarningUiTitle = {
                    description = "RGBA title color used for the speed camera warning UI.",
                    label = "Title RGBA",
                },
                spikeStripsCheckIntervalMs = {
                    description = "Milliseconds between spike strip proximity checks.",
                    label = "Check interval",
                },
                spikeStripsEnabled = {
                    description = "Enable deployed spike strips.",
                    label = "Spike strips",
                },
                spikeStripsModels = {
                    description = "Prop models treated as active spike strips.",
                    itemLabel = "Model",
                    label = "Models",
                },
                spikeStripsRetryIntervalMs = {
                    description = "Milliseconds before spike strip scanning retries after no match.",
                    label = "Retry interval",
                },
                spikeStripsScanDistance = {
                    description = "Distance used to scan for nearby spike strips.",
                    label = "Scan distance",
                },
                spikeStripsTriggerDistance = {
                    description = "Distance at which tyres are burst by a spike strip.",
                    label = "Trigger distance",
                },
                stationCreatorBlipCategoryLabel = {
                    description = "Category label used for station creator blips.",
                    label = "Station blip category",
                },
                stationCreatorBlipColor = {
                    description = "Map blip color used for police stations.",
                    label = "Station blip color",
                },
                stationCreatorBlipScale = {
                    description = "Scale used for police station blips.",
                    label = "Station blip scale",
                },
                stationCreatorBlipShortRange = {
                    description = "Show station blips only at short range.",
                    label = "Station blip short range",
                },
                stationCreatorBlipSprite = {
                    description = "Map blip sprite used for police stations.",
                    label = "Station blip sprite",
                },
                stationCreatorBlipUseStationName = {
                    description = "Use the configured station name for the map blip label.",
                    label = "Use station name",
                },
                tabletAutoFillCitizens = {
                    description = "Prefill the citizens registry from the framework database.",
                    label = "Auto-fill citizens",
                },
                tabletAutoFillVehicles = {
                    description = "Prefill the vehicles registry from the framework database.",
                    label = "Auto-fill vehicles",
                },
                tabletBolos = {
                    description = "Show the BOLO app.",
                    label = "BOLOs",
                },
                tabletCases = {
                    description = "Show the cases app.",
                    label = "Cases",
                },
                tabletCitizens = {
                    description = "Show the citizens registry app.",
                    label = "Citizens",
                },
                tabletConfiscations = {
                    description = "Show the log of items confiscated during player searches.",
                    label = "Confiscations",
                },
                tabletOffences = {
                    description = "Show the offences app.",
                    label = "Offences",
                },
                tabletPrison = {
                    description = "Show the prison app.",
                    label = "Prison",
                },
                tabletReportEnforcement = {
                    description = "Allow officers to assign offences to report suspects and issue fines or jail sentences from saved reports.",
                    label = "Report enforcement",
                },
                tabletReports = {
                    description = "Show the reports app.",
                    label = "Reports",
                },
                tabletSocialWork = {
                    description = "Show the social work app.",
                    label = "Social work",
                },
                tabletSpeedcamReviews = {
                    description = "Show the advanced speed camera review app when advanced mode is enabled.",
                    label = "Speed camera reviews",
                },
                tabletVehicles = {
                    description = "Show the vehicles registry app.",
                    label = "Vehicles",
                },
                tabletWarrants = {
                    description = "Show the warrants app.",
                    label = "Warrants",
                },
                tabletWeapons = {
                    description = "Show the weapons registry app.",
                    label = "Weapons",
                },
                tackleCommand = {
                    description = "Command registered for tackling the nearest person. Enter the command name without a slash.",
                    label = "Tackle command",
                },
                tackleCuffCommand = {
                    description = "Command registered for cuffing the person currently held after a tackle. Enter the command name without a slash.",
                    label = "Tackle cuff command",
                },
                tackleCuffDescription = {
                    description = "Description displayed for the tackle cuff binding in the FiveM key bindings menu.",
                    label = "Tackle cuff keybind description",
                },
                tackleCuffKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Cuff tackled person",
                },
                tackleDescription = {
                    description = "Description displayed for the tackle binding in the FiveM key bindings menu.",
                    label = "Tackle keybind description",
                },
                tackleEnabled = {
                    description = "Enable tackling the nearest person and holding them on the ground.",
                    label = "Tackle",
                },
                tackleKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Tackle",
                },
                tackleMaxDistance = {
                    description = "Maximum distance to the target when starting a tackle.",
                    label = "Tackle distance",
                },
                tackleNeedsSprint = {
                    description = "Require the officer to be sprinting before tackling a person.",
                    label = "Tackle requires sprinting",
                },
                tackleReleaseCommand = {
                    description = "Command registered for releasing the person currently held after a tackle. Enter the command name without a slash.",
                    label = "Tackle release command",
                },
                tackleReleaseDescription = {
                    description = "Description displayed for the tackle release binding in the FiveM key bindings menu.",
                    label = "Tackle release keybind description",
                },
                tackleReleaseKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Release tackled person",
                },
                tackleRequireOnDuty = {
                    description = "Require duty state before an officer can tackle a person.",
                    label = "Tackle requires duty",
                },
                vehicleRadarAlertCooldownMs = {
                    description = "Milliseconds before another radar alert can be raised.",
                    label = "Alert cooldown",
                },
                vehicleRadarAllowedVehicleClasses = {
                    description = "Vehicle classes allowed to use radar.",
                    label = "Allowed vehicle classes",
                },
                vehicleRadarAutoFastLock = {
                    description = "Automatically flag very fast targets in the radar.",
                    label = "Auto fast lock",
                },
                vehicleRadarAutoFastLockThreshold = {
                    description = "Speed threshold used for auto fast lock.",
                    label = "Fast lock threshold",
                },
                vehicleRadarCustomizeCommand = {
                    description = "Command used to open or close the radar layout editor. Enter the command name without a slash.",
                    label = "Radar layout command",
                },
                vehicleRadarDecreaseLimitKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Radar: Decrease limit",
                },
                vehicleRadarDefaultLimit = {
                    description = "Default speed limit used by the vehicle radar.",
                    label = "Default radar limit",
                },
                vehicleRadarEnabled = {
                    description = "Enable the patrol vehicle radar.",
                    label = "Vehicle radar",
                },
                vehicleRadarIncreaseLimitKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Radar: Increase limit",
                },
                vehicleRadarLimitStep = {
                    description = "Amount changed per radar limit adjustment.",
                    label = "Limit step",
                },
                vehicleRadarLockFrontKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Radar: Front lock",
                },
                vehicleRadarLockRearKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Radar: Rear lock",
                },
                vehicleRadarMaxLimit = {
                    description = "Maximum speed limit allowed in the vehicle radar.",
                    label = "Maximum radar limit",
                },
                vehicleRadarMaxPitchDeg = {
                    description = "Maximum pitch allowed for radar targeting.",
                    label = "Max pitch degrees",
                },
                vehicleRadarMinLimit = {
                    description = "Minimum speed limit allowed in the vehicle radar.",
                    label = "Minimum radar limit",
                },
                vehicleRadarMinTargetSpeed = {
                    description = "Minimum speed before the radar considers a target valid.",
                    label = "Minimum target speed",
                },
                vehicleRadarModeFrontKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Radar: Front mode",
                },
                vehicleRadarModeRearKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Radar: Rear mode",
                },
                vehicleRadarMovingScanIntervalMs = {
                    description = "Milliseconds between radar scans while the patrol vehicle is moving.",
                    label = "Moving scan interval",
                },
                vehicleRadarPassengerControl = {
                    description = "Allow passengers to control the vehicle radar.",
                    label = "Passenger control",
                },
                vehicleRadarPassengerEnabled = {
                    description = "Allow passengers to view mirrored radar data.",
                    label = "Passenger mirror",
                },
                vehicleRadarPassengerSyncIntervalMs = {
                    description = "Milliseconds between radar sync updates for passengers.",
                    label = "Passenger sync interval",
                },
                vehicleRadarProjectionThreshold = {
                    description = "Projection threshold used when evaluating radar targets.",
                    label = "Projection threshold",
                },
                vehicleRadarRequireLineOfSight = {
                    description = "Require clear line of sight before radar locks a target.",
                    label = "Require line of sight",
                },
                vehicleRadarRequireOnDuty = {
                    description = "Require duty state before using vehicle radar.",
                    label = "Radar requires duty",
                },
                vehicleRadarResetLayoutCommand = {
                    description = "Command used to restore the default radar layout. Enter the command name without a slash.",
                    label = "Reset radar layout command",
                },
                vehicleRadarScanIntervalMs = {
                    description = "Milliseconds between stationary radar scans.",
                    label = "Scan interval",
                },
                vehicleRadarScanRadius = {
                    description = "Vehicle radar scan radius.",
                    label = "Scan radius",
                },
                vehicleRadarToggleKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Radar: Toggle",
                },
                vehicleRadarUseMph = {
                    description = "Display radar speed values in MPH.",
                    label = "Radar uses MPH",
                },
                vehicleRadarVehiclePoolRefreshMs = {
                    description = "Milliseconds between nearby vehicle pool refreshes.",
                    label = "Vehicle pool refresh",
                },
                vehicleRadarXmitFrontKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Radar: Front transmit/hold",
                },
                vehicleRadarXmitRearKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Radar: Rear transmit/hold",
                },
                wheelClampConsumeItem = {
                    description = "Remove the wheel clamp item after placement.",
                    label = "Consume clamp item",
                },
                wheelClampEnabled = {
                    description = "Enable the wheel clamp action.",
                    label = "Wheel clamp",
                },
                wheelClampItem = {
                    description = "Inventory item used for wheel clamp placement.",
                    label = "Clamp item",
                },
                wheelClampPropModel = {
                    description = "Prop model used for the placed wheel clamp.",
                    label = "Clamp prop model",
                },
                wheelClampRequireItem = {
                    description = "Require the configured wheel clamp item. Keep this enabled when clamp use mode is set to Inventory or Both.",
                    label = "Clamp requires item",
                },
                wheelClampRequireOnDuty = {
                    description = "Require duty state before placing wheel clamps.",
                    label = "Clamp requires duty",
                },
                wheelClampTyreDistance = {
                    description = "Maximum distance to the tyre when placing or welding a clamp.",
                    label = "Tyre distance",
                },
                wheelClampUseItem = {
                    description = "Use radial, inventory, or both for wheel clamp placement. Inventory or Both should be paired with Clamp requires item.",
                    label = "Clamp use mode",
                    options = {
                        both = "Both",
                        inventory = "Inventory",
                        radial = "Radial",
                    },
                },
                wheelClampVehicleDistance = {
                    description = "Maximum distance to the target vehicle when placing a clamp.",
                    label = "Vehicle distance",
                },
                wheelClampWeldBurstTyre = {
                    description = "Burst the tyre after a clamp is welded off.",
                    label = "Burst tyre",
                },
                wheelClampWeldDurationMs = {
                    description = "Milliseconds required to remove a clamp by welding.",
                    label = "Weld duration",
                },
                wheelClampWeldEnabled = {
                    description = "Allow wheel clamps to be removed with a welder.",
                    label = "Clamp welding",
                },
                wheelClampWeldItem = {
                    description = "Inventory item required for clamp welding.",
                    label = "Welder item",
                },
                wheelClampWeldMinigame = {
                    description = "Require the clamp welding minigame before removal completes.",
                    label = "Weld minigame",
                },
                ziptiesConsumeItem = {
                    description = "Remove a ziptie item when one is applied.",
                    label = "Consume zipties",
                },
                ziptiesCutterConsumeItem = {
                    description = "Remove the cutter item after cutting zipties.",
                    label = "Consume cutter item",
                },
                ziptiesCutterEnabled = {
                    description = "Allow wire cutters to remove zipties.",
                    label = "Ziptie cutter",
                },
                ziptiesCutterItem = {
                    description = "Inventory item used to cut zipties.",
                    label = "Cutter item",
                },
                ziptiesEnabled = {
                    description = "Enable ziptie actions.",
                    label = "Zipties",
                },
                ziptiesItem = {
                    description = "Inventory item used for ziptie actions.",
                    label = "Ziptie item",
                },
                ziptiesRequireHandsUp = {
                    description = "Require hands-up state before applying zipties.",
                    label = "Hands up for zipties",
                },
                ziptiesRequireItem = {
                    description = "Require the configured ziptie item.",
                    label = "Zipties require item",
                },
                ziptiesReturnOnRemove = {
                    description = "Return a ziptie item when zipties are removed.",
                    label = "Return zipties",
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
            warnings = {
                cuffsConsumeRequiresItem = "Consume cuffs has no effect while cuff item requirement is disabled.",
                wheelClampUseItemRequiresItem = "Clamp use mode Inventory or Both requires Clamp requires item to stay enabled.",
                ziptiesConsumeRequiresItem = "Consume zipties has no effect while ziptie item requirement is disabled.",
            },
            locationDescriptions = {
                jail_public_blip = "Position is taken automatically from the jail spawn, or the first jail terminal when no spawn is set.",
            },
        },
    },
}
