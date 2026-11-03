JobConfigLocales["sky_ambulancejob:en"] = {
    Nui = {
        tablet = {
            apps = {
                medicalEvaluations = "Medical Evaluations",
                sharedMedicalEvaluations = "Shared Medical Evaluations",
            },
        },
        workshopConfig = {
            creatorFields = {
                hospitalBeds = {
                    allowRespawn = {
                        label = "Allow Respawn",
                        description = "Controls whether this bed can be selected for player respawns.",
                    },
                },
            },
            configs = {
                sky_ambulancejob = {
                    subtitle = "Configure ambulance jobs, hospital beds, death systems, interactions, and core feature settings.",
                    title = "Ambulance Jobs",
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
            features = {
                bleeding = {
                    description = "Enable the bleeding system.",
                    label = "Bleeding",
                },
                bodybags = {
                    description = "Enable body bags and body bag delivery flows.",
                    label = "Body Bags",
                },
                consciousScenarioBloodPressure = {
                    description = "Allow blood pressure checks while the patient is conscious.",
                    label = "Conscious Blood Pressure",
                },
                deathTimeout = {
                    description = "Enable the death timeout flow.",
                    label = "Death Timeout",
                },
                fractures = {
                    description = "Enable fracture handling and treatment.",
                    label = "Fractures",
                },
                knockout = {
                    description = "Enable the knockout system.",
                    label = "Knockout",
                },
                legShotRagdoll = {
                    description = "Make players fall when shot in configured leg or foot zones.",
                    label = "Leg-shot ragdoll",
                },
                pain = {
                    description = "Enable the pain system.",
                    label = "Pain",
                },
                respawnInBed = {
                    description = "Respawn revived players in a hospital bed when available.",
                    label = "Respawn In Bed",
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
                gang = "Gang",
                allowInVehicle = "Allow in vehicle",
                allowMovement = "Allow movement",
                animDict = "Animation dictionary",
                animFlag = "Animation flag",
                animName = "Animation name",
                bleeding = "Bleeding",
                cause = "Cause",
                chance = "Chance",
                class = "Class",
                companyPrice = "Company price",
                companyPricePerEmployee = "Price per employee",
                copayPercent = "Copay %",
                description = "Description",
                dictionary = "Animation dictionary",
                duration = "Duration",
                durationMs = "Duration (ms)",
                effect = "Effect",
                effectDurationMs = "Effect duration (ms)",
                effectDurationSeconds = "Effect duration (seconds)",
                enabled = "Enabled",
                extractionType = "Extraction type",
                foreignObject = "Foreign object",
                heal = "Healing",
                id = "ID",
                itemName = "Item name",
                key = "Key",
                label = "Label",
                lang = "Language",
                limit = "Limit",
                lossPerSecond = "Loss per second",
                max = "Maximum",
                min = "Minimum",
                minGrade = "Min grade",
                minigame = "Minigame",
                model = "Prop model",
                name = "Job name",
                options = "Options (selection types)",
                pain = "Pain",
                pauseBleedingSeconds = "Pause bleeding (seconds)",
                price = "Price",
                progressbarAllowInVehicle = "Progress: allow in vehicle",
                progressbarAllowMovement = "Progress: allow movement",
                progressbarCanCancel = "Progress can be cancelled",
                progressbarDisableCarMovement = "Progress: disable vehicle movement",
                progressbarDisableCombat = "Progress: disable combat",
                progressbarDisableMouse = "Progress: disable mouse",
                progressbarDisableMovement = "Progress: disable movement",
                progressbarDisableSprint = "Progress: disable sprint",
                progressbarDuration = "Progress duration",
                progressbarEnabled = "Progress bar enabled",
                progressbarLabel = "Progress bar label",
                progressbarUseWhileDead = "Progress usable while dead",
                questions = "Questions",
                requireItems = "Require items",
                required = "Required",
                requiresExtraction = "Requires extraction",
                requiresOpenWound = "Requires open wound",
                sort = "Order",
                state = "State",
                stopBleeding = "Stop bleeding",
                threshold = "Threshold",
                time = "Time",
                type = "Type",
                useAnimation = "Use animation",
                value = "Value",
                zone = "Zone",
                zones = "Zones",
                systolic = "Systolic pressure",
                diastolic = "Diastolic pressure",
                cardiacArrest = "Cardiac arrest",
            },
            settingGroups = {
                appointmentsGeneral = {
                    label = "General",
                },
                appointmentsLimits = {
                    label = "Limits",
                },
                appointmentsNotifications = {
                    label = "Notifications",
                },
                appointmentsScheduling = {
                    label = "Scheduling",
                },
                billingGeneral = {
                    label = "General",
                },
                billingRange = {
                    label = "Range",
                },
                billingReasons = {
                    label = "Reason Presets",
                },
                billingUi = {
                    label = "UI",
                },
                bodyBagAnimation = {
                    label = "Animation",
                },
                bodyBagAttachGeneral = {
                    label = "Attach",
                },
                bodyBagAttachOffsets = {
                    label = "Offsets",
                },
                bodyBagAttachRotation = {
                    label = "Rotation",
                },
                bodyBagDeliveryGeneral = {
                    label = "General",
                },
                bodyBagDeliveryRewardGeneral = {
                    label = "General",
                },
                bodyBagDeliveryRewardPayment = {
                    label = "Payment",
                },
                bodyBagDeliveryUi = {
                    label = "UI",
                },
                bodyBagGeneral = {
                    label = "General",
                },
                crutchAssign = {
                    label = "Assignment",
                },
                crutchDuration = {
                    label = "Duration",
                },
                crutchGeneral = {
                    label = "General",
                },
                crutchItems = {
                    label = "Item",
                },
                crutchRestrictions = {
                    label = "Restrictions",
                },
                damageHandlingBladeWeapons = {
                    label = "Blade Weapons",
                },
                damageHandlingBleedingBlacklist = {
                    label = "Bleeding Blacklist",
                },
                damageHandlingBleedingClasses = {
                    label = "Bleeding Classes",
                },
                damageHandlingBloodSystem = {
                    label = "Blood System",
                },
                damageHandlingDeathInjuries = {
                    label = "Death Injuries",
                },
                damageHandlingInjuryEffects = {
                    label = "Injury Effects",
                },
                damageHandlingInjuryThresholds = {
                    label = "Injury Thresholds",
                },
                damageHandlingLegShotRagdoll = {
                    label = "Leg Shot Ragdoll",
                },
                damageHandlingLegShotRagdollZones = {
                    label = "Leg Shot Ragdoll Zones",
                },
                damageHandlingLiveDamageFractures = {
                    label = "Live Damage Fractures",
                },
                damageHandlingLiveDamageFracturesZones = {
                    label = "Zone Chances",
                },
                damageHandlingLiveOpenWoundStacks = {
                    label = "Open Wound Stacks",
                },
                damageHandlingLiveOpenWoundStacksZones = {
                    label = "Zone Limits",
                },
                damageHandlingLiveWoundBleedingClass = {
                    label = "Live Wound Classes",
                },
                damageHandlingMedications = {
                    label = "Medications",
                },
                damageHandlingPainClasses = {
                    label = "Pain Classes",
                },
                damageHandlingPainEffects = {
                    label = "Pain Effects",
                },
                damageHandlingStatusEffects = {
                    label = "Status Effects",
                },
                damageHandlingVehicleDamage = {
                    label = "Vehicle Damage",
                },
                damageHandlingVehicleImpactCauses = {
                    label = "Damage Causes",
                },
                damageHandlingVehicleImpactInjuries = {
                    label = "Injuries",
                },
                damageHandlingVehicleImpactProtection = {
                    label = "Vehicle Impact Protection",
                },
                deathAnimal = {
                    label = "Animal Fallback",
                },
                deathAnimalAnimation = {
                    label = "Animal Animation",
                },
                deathAnimation = {
                    label = "Animation",
                },
                deathGeneral = {
                    label = "General",
                },
                deathModels = {
                    label = "Per Model Overrides",
                },
                deathScreenAiMedic = {
                    label = "General",
                },
                deathScreenAiMedicAvailability = {
                    label = "Availability",
                },
                deathScreenAiMedicBehaviour = {
                    label = "Behaviour",
                },
                deathScreenAiMedicForceRevive = {
                    label = "Force Revive",
                },
                deathScreenAiMedicPayment = {
                    label = "Payment",
                },
                deathScreenAiMedicReviveInBed = {
                    label = "Revive In Bed",
                },
                deathScreenAiMedicSpawn = {
                    label = "Spawn",
                },
                deathScreenAiMedicTiming = {
                    label = "Timing",
                },
                deathScreenControls = {
                    label = "Controls",
                },
                deathScreenDamageLogs = {
                    label = "Damage Logs",
                },
                deathScreenDimensions = {
                    label = "Dimensions",
                },
                deathScreenDispatch = {
                    label = "Dispatch",
                },
                deathScreenEarlyRespawn = {
                    label = "General",
                },
                deathScreenEarlyRespawnAvailability = {
                    label = "Availability",
                },
                deathScreenEarlyRespawnPayment = {
                    label = "Payment",
                },
                deathScreenGeneral = {
                    label = "General",
                },
                deathScreenHospitalSelection = {
                    label = "Hospital Selection",
                },
                deathScreenHospitalSelectionCamera = {
                    label = "Selection Camera",
                },
                deathScreenInformation = {
                    label = "General",
                },
                deathScreenIntegration = {
                    label = "Integration",
                },
                deathScreenLogs = {
                    label = "Death Logs",
                },
                deathScreenMinigame = {
                    label = "Minigame",
                },
                deathScreenRespawn = {
                    label = "General",
                },
                deathScreenRespawnAccounts = {
                    label = "Accounts",
                },
                deathScreenRespawnFallback = {
                    label = "Fallback Coords",
                },
                deathScreenRespawnItems = {
                    label = "Items",
                },
                deathScreenRespawnWeapons = {
                    label = "Weapons",
                },
                deathScreenStyle = {
                    label = "Death Screen Style",
                },
                deathScreenVoice = {
                    label = "Voice",
                },
                deathTimeoutGeneral = {
                    label = "General",
                },
                deathTimeoutWhitelist = {
                    label = "Whitelisted Jobs",
                },
                diagnoseAnim = {
                    label = "Animation",
                },
                diagnoseCpr = {
                    label = "CPR",
                },
                diagnoseFullHeal = {
                    label = "Full Heal",
                },
                diagnoseGeneral = {
                    label = "General",
                },
                doctorNpcAvailability = {
                    label = "Availability",
                },
                doctorNpcGeneral = {
                    label = "General",
                },
                doctorNpcHealOther = {
                    label = "Heal Other",
                },
                doctorNpcHealSelf = {
                    label = "Heal Self",
                },
                doctorNpcRanges = {
                    description = "These ranges do not control how close a player must be to open the doctor NPC interaction. They only apply after the doctor menu opens.",
                    label = "Ranges",
                },
                doctorNpcRevive = {
                    label = "Revive",
                },
                doctorNpcReviveInBed = {
                    label = "Revive In Bed",
                },
                firstAidAnimation = {
                    label = "Animation",
                },
                firstAidGeneral = {
                    label = "General",
                },
                firstAidLicenseAdd = {
                    label = "License Add",
                },
                firstAidLicenseRemove = {
                    label = "License Remove",
                },
                firstAidPosition = {
                    label = "Position",
                },
                healthCompatibility = {
                    label = "Health Compatibility",
                },
                healthInsuranceExpiration = {
                    label = "Expiration",
                },
                healthInsuranceGeneral = {
                    label = "General",
                },
                healthInsurancePayment = {
                    label = "Payment",
                },
                healthInsuranceProviders = {
                    label = "Providers",
                },
                hospitalBedsBedAnimation = {
                    label = "Bed Animation",
                },
                hospitalBedsCreator = {
                    label = "Creator",
                },
                hospitalBedsDistances = {
                    label = "Distances",
                },
                hospitalBedsGeneral = {
                    label = "General",
                },
                hospitalBedsGetupAnimation = {
                    label = "Getup Animation",
                },
                hospitalBedsModels = {
                    label = "Models",
                },
                hospitalBedsOffsets = {
                    label = "Offsets",
                },
                hospitalBlip = {
                    label = "Hospital Blip",
                },
                imagingGeneral = {
                    label = "General",
                },
                imagingRanges = {
                    label = "Ranges",
                },
                keybinds = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Keybinds",
                },
                knockoutGeneral = {
                    label = "General",
                },
                knockoutWeapons = {
                    label = "Weapons",
                },
                medicCarryAttach = {
                    label = "Attach",
                },
                medicCarryAttachOffsets = {
                    label = "Offsets",
                },
                medicCarryAttachRotation = {
                    label = "Rotation",
                },
                medicCarryCarrierAnimation = {
                    label = "Carrier Animation",
                },
                medicCarryGeneral = {
                    label = "General",
                },
                medicCarryPassengerAnimation = {
                    label = "Passenger Animation",
                },
                medicCarryRestrictions = {
                    label = "Restrictions",
                },
                medicRevivePersistence = {
                    label = "General",
                },
                medicalEvaluationRecipients = {
                    label = "Recipient Jobs",
                },
                medicalEvaluationSharing = {
                    label = "Shared Fields",
                },
                medicalEvaluationTypes = {
                    label = "Evaluation Types",
                },
                medicalEvaluationsGeneral = {
                    label = "General",
                },
                medicalWearablesArmRestrictions = {
                    label = "Arm-cast Restrictions",
                },
                medicalWearablesCasts = {
                    label = "Casts",
                },
                medicalWearablesDuration = {
                    label = "Wear Duration",
                },
                medicalWearablesGeneral = {
                    label = "General",
                },
                medicalWearablesHeadBandage = {
                    label = "Head Bandage",
                },
                medicalWearablesLegRestrictions = {
                    label = "Leg-cast Restrictions",
                },
                medicalWearablesNeckBrace = {
                    label = "Neck Brace",
                },
                medicalWearablesOxygenMask = {
                    label = "Oxygen Mask",
                },
                medicalWearablesPatientHud = {
                    label = "Patient HUD",
                },
                medicalWearablesRemoval = {
                    label = "Removal",
                },
                medicalWearablesSplints = {
                    label = "Splints",
                },
                medicalWearablesTorsoBandage = {
                    label = "Torso Bandage",
                },
                minigamesBloodTransfusionGeneral = {
                    label = "General",
                },
                minigamesCprGeneral = {
                    label = "General",
                },
                minigamesEnabled = {
                    label = "Enabled",
                },
                minigamesRandomization = {
                    label = "Randomization",
                },
                minigamesVentilationGeneral = {
                    label = "General",
                },
                operationsAnesthesia = {
                    label = "Anesthesia",
                },
                operationsDistances = {
                    label = "Distances",
                },
                operationsDoctorAnimation = {
                    label = "Doctor Animation",
                },
                operationsGeneral = {
                    label = "General",
                },
                operationsPatientAnimation = {
                    label = "Patient Animation",
                },
                operationsTrainingAnimation = {
                    label = "Training Animation",
                },
                propPlacement = {
                    label = "Prop Placement",
                },
                propPlacementItems = {
                    label = "Prop Items",
                },
                publicTreatmentGeneral = {
                    label = "General",
                },
                publicTreatmentJobs = {
                    label = "Allowed Jobs",
                },
                publicTreatmentRequirements = {
                    label = "Requirements",
                },
                reviveRewardGeneral = {
                    label = "General",
                },
                reviveRewardPayment = {
                    label = "Payment",
                },
                selfDiagnoseGeneral = {
                    label = "General",
                },
                stretcherAnimation = {
                    label = "Animation",
                },
                stretcherCarryAttach = {
                    label = "Carry Attach",
                },
                stretcherFolded = {
                    label = "Folded Variant",
                },
                stretcherFoldedPatientAttach = {
                    label = "Folded Patient Attach",
                },
                stretcherGeneral = {
                    label = "General",
                },
                stretcherHelicopter = {
                    label = "Helicopter",
                },
                stretcherPatientAttach = {
                    label = "Patient Attach",
                },
                stretcherTreatmentAnim = {
                    label = "Animation",
                },
                stretcherVehicleAttach = {
                    label = "Vehicle Attach",
                },
                stretcherVehicleLists = {
                    label = "Vehicle Models",
                },
                treatmentAnim = {
                    label = "Animation",
                },
                treatmentEnable = {
                    label = "Enable",
                },
                trunk = {
                    label = "Trunk",
                },
                vehiclePullGeneral = {
                    label = "General",
                },
                wheelchairAssign = {
                    label = "Assignment",
                },
                wheelchairDuration = {
                    label = "Duration",
                },
                wheelchairGeneral = {
                    label = "General",
                },
                wheelchairItems = {
                    label = "Item",
                },
                wheelchairRestrictions = {
                    label = "Restrictions",
                },
                xrayGeneral = {
                    label = "General",
                },
                xrayRanges = {
                    label = "Ranges",
                },
            },
            settingSections = {
                billing = "Billing",
                bodyBag = "Body Bag",
                damageHandling = "Damage Handling",
                death = "Death",
                deathScreen = "Death Screen",
                diagnose = "Diagnose",
                doctorNpc = "Doctor NPC",
                general = "General",
                healthInsurance = "Health Insurance",
                hospitalBeds = "Hospital Beds",
                knockout = "Knockout",
                medicCarry = "Medic Carry",
                minigames = "Minigames",
                mobilityAid = "Mobility Aids",
                operations = "Operations",
                organization = "Organization",
                rewards = "Rewards",
                treatment = "Treatment",
                vehiclePull = "Vehicle Pull",
            },
            settingSubsections = {
                aiMedic = "AI Medic",
                anesthesia = "Anesthesia",
                animation = "Animation",
                animations = "Animations",
                appointments = "Appointments",
                attach = "Attach",
                bedAnimation = "Bed Animation",
                blood = "Blood",
                bloodTransfusion = "Blood Transfusion",
                bodyBagDeliveryReward = "Body Bag Delivery Reward",
                carrierAnimation = "Carrier Animation",
                classification = "Classification",
                cpr = "CPR",
                crutch = "Crutch",
                deathInjuries = "Death Injuries",
                deathScreenStyle = "Death Screen Style",
                deathTimeout = "Death Timeout",
                delivery = "Delivery",
                diagnoseAnim = "Diagnose Animation",
                dispatch = "Dispatch",
                earlyRespawn = "Early Respawn",
                effects = "Effects",
                firstAid = "First Aid",
                general = "General",
                getupAnimation = "Getup Animation",
                imaging = "Imaging",
                information = "Information",
                keybinds = "Keybinds",
                liveDamage = "Live Damage",
                logs = "Logs",
                medicRevivePersistence = "Medic Revive Persistence",
                medicalEvaluations = "Medical Evaluations",
                medicalWearables = "Medical Wearables",
                medications = "Medications",
                minigame = "Minigame",
                passengerAnimation = "Passenger Animation",
                pricing = "Pricing",
                propPlacement = "Prop Placement",
                publicTreatment = "Public Treatment",
                respawn = "Respawn",
                reviveInBed = "Revive In Bed",
                reviveReward = "Revive Reward",
                selfDiagnose = "Self Diagnose",
                stretcher = "Stretcher",
                stretcherTreatmentAnim = "Stretcher Treatment Animation",
                thresholds = "Thresholds",
                treatmentAnim = "Treatment Animation",
                trunk = "Trunk",
                vehicleImpact = "Vehicle Impact",
                ventilation = "Ventilation",
                wheelchair = "Wheelchair",
                xray = "X-Ray",
            },
            settings = {
                ambulanceEditorControl172 = {
                    label = "Editor: Move up",
                    description = "Configures: Editor: Move up.",
                },
                ambulanceEditorControl173 = {
                    label = "Editor: Move down",
                    description = "Configures: Editor: Move down.",
                },
                ambulanceEditorControl174 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · LEFT",
                },
                ambulanceEditorControl175 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · RIGHT",
                },
                ambulanceEditorControl177 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · BACK",
                },
                ambulanceEditorControl201 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · RETURN",
                },
                ambulanceEditorControl202 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · ESCAPE",
                },
                ambulanceEditorControl21 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · LSHIFT",
                },
                ambulanceEditorControl32 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · W",
                },
                ambulanceEditorControl33 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · S",
                },
                ambulanceEditorControl34 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · A",
                },
                ambulanceEditorControl35 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · D",
                },
                ambulanceEditorControl36 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · LCONTROL",
                },
                ambulanceEditorControl37 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · TAB",
                },
                ambulanceEditorControl38 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · E",
                },
                ambulanceEditorControl44 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Editor · Q",
                },
                ambulanceFirstAidControl38 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "First aid · E",
                },
                ambulanceStretcherEditorControl177 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Interaction · BACK",
                },
                ambulanceStretcherEditorControl201 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Interaction · RETURN",
                },
                ambulanceStretcherEditorControl202 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Interaction · ESCAPE",
                },
                ambulanceStretcherEditorControl21 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Interaction · LSHIFT",
                },
                ambulanceStretcherEditorControl241 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Interaction · IOM_WHEEL_UP",
                },
                ambulanceStretcherEditorControl242 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Interaction · IOM_WHEEL_DOWN",
                },
                ambulanceStretcherEditorControl25 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Interaction · MOUSE_RIGHT",
                },
                ambulanceStretcherEditorControl32 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Interaction · W",
                },
                ambulanceStretcherEditorControl33 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Interaction · S",
                },
                ambulanceStretcherEditorControl34 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Interaction · A",
                },
                ambulanceStretcherEditorControl35 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Interaction · D",
                },
                ambulanceStretcherEditorControl36 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Interaction · LCONTROL",
                },
                ambulanceStretcherEditorControl38 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Interaction · E",
                },
                ambulanceStretcherEditorControl44 = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Interaction · Q",
                },
                appointmentsBookingCooldownSeconds = {
                    description = "Cooldown in seconds between patient booking attempts.",
                    label = "Booking cooldown",
                },
                appointmentsEnabled = {
                    description = "Enable patient appointment booking and the personal medic calendar.",
                    label = "Enabled",
                },
                appointmentsMaxAdvanceDays = {
                    description = "Maximum number of days into the future that patients may book.",
                    label = "Maximum advance booking",
                },
                appointmentsMaxAppointmentsPerPlayer = {
                    description = "Maximum number of active future appointments a patient may hold.",
                    label = "Maximum appointments per patient",
                },
                appointmentsMinLeadMinutes = {
                    description = "Minimum number of minutes between booking and the appointment.",
                    label = "Minimum lead time",
                },
                appointmentsNotificationApp = {
                    description = "Phone app identifier used for appointment notifications.",
                    label = "Notification app",
                },
                appointmentsNotificationsEnabled = {
                    description = "Notify patients on their phone when appointments are booked or cancelled.",
                    label = "Phone notifications",
                },
                appointmentsReasonMaxLength = {
                    description = "Maximum number of characters accepted for the appointment reason.",
                    label = "Reason character limit",
                },
                appointmentsSlotDurationMinutes = {
                    description = "Duration and grid interval of an appointment slot in minutes.",
                    label = "Slot duration",
                },
                billingAccount = {
                    description = "Legacy fallback society account used for billing.",
                    label = "Account",
                },
                billingCloseOnSuccess = {
                    description = "Close the billing UI automatically after a successful bill.",
                    label = "Close on success",
                },
                billingCurrency = {
                    description = "Optional currency key used for billing payments.",
                    label = "Currency",
                },
                billingCustomBillingReasons = {
                    description = "Allow medics to enter custom billing reasons.",
                    label = "Custom reasons",
                },
                billingDepositToSociety = {
                    description = "Deposit billing revenue into the society account.",
                    label = "Deposit to society",
                },
                billingEnabled = {
                    description = "Enable the medical billing system.",
                    label = "Enabled",
                },
                billingMaxReasonLength = {
                    description = "Maximum length of custom billing reasons.",
                    label = "Max reason length",
                },
                billingMode = {
                    description = "Choose whether medical bills charge instantly, require confirmation, or use the framework billing system.",
                    label = "Billing mode",
                    options = {
                        consent = "Pay or decline",
                        framework = "Framework bill",
                        instant = "Instant charge",
                    },
                },
                billingRange = {
                    description = "Maximum range for finding billable patients.",
                    label = "Range",
                },
                billingReasonPresets = {
                    description = "Preset billing reasons shown in the billing UI.",
                    itemLabel = "Reason",
                    label = "Reason presets",
                },
                billingRefreshSeconds = {
                    description = "Seconds between billable-player refreshes.",
                    label = "Refresh seconds",
                },
                bladeWeapons = {
                    description = "Weapon names or hashes that should be classified as knife damage instead of blunt.",
                    itemLabel = "Weapon",
                    label = "Blade weapons",
                },
                bleedingBlacklist = {
                    description = "Weapons that should never create live bleeding or open wounds.",
                    itemLabel = "Weapon",
                    label = "Bleeding blacklist",
                },
                bleedingClassesProfiles = {
                    description = "Bleeding severity profiles and their blood loss rate.",
                    label = "Bleeding classes",
                },
                bloodSystemDebugLogInterval = {
                    description = "Seconds between blood-system debug log messages.",
                    label = "Debug log interval",
                },
                bloodSystemMaxVolume = {
                    description = "Maximum blood volume value used by the patient state system.",
                    label = "Max volume",
                },
                bloodSystemRegenPerSecond = {
                    description = "Passive blood regeneration applied when the patient is not actively bleeding.",
                    label = "Regen per second",
                },
                bloodSystemTickIntervalMs = {
                    description = "Server tick interval used for blood loss and recovery updates.",
                    label = "Tick interval ms",
                },
                bloodSystemUnconsciousThreshold = {
                    description = "Blood volume threshold below which the patient becomes unconscious.",
                    label = "Unconscious threshold",
                },
                bodyBagAnimationDict = {
                    description = "Animation dictionary used for carrying a body bag.",
                    label = "Animation dictionary",
                },
                bodyBagAnimationEnabled = {
                    description = "Use a dedicated carry animation while carrying a body bag.",
                    label = "Enabled",
                },
                bodyBagAnimationFlag = {
                    description = "TaskPlayAnim flag used for the carry animation.",
                    label = "Animation flag",
                },
                bodyBagAnimationName = {
                    description = "Animation clip used for carrying a body bag.",
                    label = "Animation name",
                },
                bodyBagAttachBone = {
                    description = "Ped bone name or bone ID used for the body bag attachment.",
                    label = "Bone",
                },
                bodyBagAttachRx = {
                    description = "Body bag attach X rotation.",
                    label = "Attach RX",
                },
                bodyBagAttachRy = {
                    description = "Body bag attach Y rotation.",
                    label = "Attach RY",
                },
                bodyBagAttachRz = {
                    description = "Body bag attach Z rotation.",
                    label = "Attach RZ",
                },
                bodyBagAttachX = {
                    description = "Body bag attach X offset.",
                    label = "Attach X",
                },
                bodyBagAttachY = {
                    description = "Body bag attach Y offset.",
                    label = "Attach Y",
                },
                bodyBagAttachZ = {
                    description = "Body bag attach Z offset.",
                    label = "Attach Z",
                },
                bodyBagDeliveryHelpLabelKey = {
                    description = "Locale key used for the body bag drop-off help prompt.",
                    label = "Help label key",
                },
                bodyBagDeliveryInteractDistance = {
                    description = "Distance used for body bag drop-off validation.",
                    label = "Interact distance",
                },
                bodyBagDeliveryInteractKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Body bag delivery",
                },
                bodyBagDeliveryInteraction = {
                    description = "Interaction template key used for body bag drop-offs.",
                    label = "Interaction template",
                },
                bodyBagDeliveryRequireDropOff = {
                    description = "Require medics to hand over body bags at configured drop-off points.",
                    label = "Require drop-off",
                },
                bodyBagDeliveryRequireOnDuty = {
                    description = "Require medics to be on duty before body bag delivery.",
                    label = "Require on duty",
                },
                bodyBagDeliveryRewardAccount = {
                    description = "Primary account key used for body bag delivery rewards.",
                    label = "Account",
                },
                bodyBagDeliveryRewardAccountType = {
                    description = "Primary account type used for body bag delivery rewards.",
                    label = "Account type",
                },
                bodyBagDeliveryRewardAmount = {
                    description = "Reward amount paid for a body bag delivery.",
                    label = "Amount",
                },
                bodyBagDeliveryRewardCurrency = {
                    description = "Optional custom currency key used for body bag delivery rewards.",
                    label = "Currency",
                },
                bodyBagDeliveryRewardEnabled = {
                    description = "Pay a configured reward after a body bag delivery is completed.",
                    label = "Enabled",
                },
                bodyBagDeliveryRewardPayFromSociety = {
                    description = "Deduct body bag delivery rewards from the shared job society before paying the medic.",
                    label = "Pay from society",
                },
                bodyBagEnabled = {
                    description = "Enable the body bag system.",
                    label = "Enabled",
                },
                bodyBagHidePatient = {
                    description = "Hide the patient ped while the body bag is attached.",
                    label = "Hide patient",
                },
                bodyBagModel = {
                    description = "Prop model used for body bags.",
                    label = "Model",
                },
                bodyBagPatientAlpha = {
                    description = "Alpha applied to the patient while body-bagged.",
                    label = "Patient alpha",
                },
                crutchAssignMaxDistance = {
                    description = "Maximum distance for assigning a crutch to another player.",
                    label = "Assign max distance",
                },
                crutchAutoUnequipOnExpire = {
                    description = "Automatically unequip the crutch when the assignment expires.",
                    label = "Auto unequip on expire",
                },
                crutchClipset = {
                    description = "Movement clipset applied while using the crutch.",
                    label = "Clipset",
                },
                crutchDefaultDurationMinutes = {
                    description = "Default assigned crutch duration in minutes.",
                    label = "Default duration",
                },
                crutchDisableSprint = {
                    description = "Block sprinting while a crutch is equipped.",
                    label = "Disable sprint",
                },
                crutchDisableWeapons = {
                    description = "Block weapon usage while a crutch is equipped.",
                    label = "Disable weapons",
                },
                crutchItemName = {
                    description = "Inventory item used for the crutch.",
                    label = "Item name",
                },
                crutchMaxDurationMinutes = {
                    description = "Maximum allowed crutch assignment duration in minutes.",
                    label = "Max duration",
                },
                crutchMinDurationMinutes = {
                    description = "Minimum allowed crutch assignment duration in minutes.",
                    label = "Min duration",
                },
                crutchProp = {
                    description = "Prop model used for the crutch.",
                    label = "Prop",
                },
                damageLogBatchIntervalSeconds = {
                    description = "Seconds during which individual hits are collected into one Discord message.",
                    label = "Batch interval",
                },
                damageLogMaxEntriesPerMessage = {
                    description = "Maximum number of individual hits included in one Discord message.",
                    label = "Hits per message",
                },
                damageLogsEnabled = {
                    description = "Send server-confirmed non-fatal player hits to Discord.",
                    label = "Damage logs",
                },
                deathAnimalAnimationDictionary = {
                    description = "Animation dictionary used for the animal fallback death animation.",
                    label = "Animal dictionary",
                },
                deathAnimalAnimationName = {
                    description = "Animation clip used for the animal fallback death animation.",
                    label = "Animal animation name",
                },
                deathAnimalUseAnimation = {
                    description = "Allow the configured animal fallback to use a scripted death animation.",
                    label = "Animal animation",
                },
                deathAnimationDictionary = {
                    description = "Animation dictionary used for the default death animation.",
                    label = "Animation dictionary",
                },
                deathAnimationName = {
                    description = "Animation clip used for the default death animation.",
                    label = "Animation name",
                },
                deathInjuriesProfiles = {
                    description = "Injury profiles applied when a player dies from a specific cause.",
                    itemLabel = "Injury",
                    label = "Death injuries",
                },
                deathModels = {
                    description = "Override death animation behavior per ped model or model hash.",
                    label = "Model overrides",
                },
                deathScreenAiMedicAccount = {
                    description = "Primary account charged for the AI medic.",
                    label = "Account",
                },
                deathScreenAiMedicAddDeathTimerSeconds = {
                    description = "Seconds added to the bleed-out timer when the AI medic is requested.",
                    label = "Add death timer",
                },
                deathScreenAiMedicAllowFatalWounds = {
                    description = "Allow the AI medic to revive fatal wounds.",
                    label = "Allow fatal wounds",
                },
                deathScreenAiMedicApproachDistance = {
                    description = "Distance at which the AI medic stops and approaches on foot.",
                    label = "Approach distance",
                },
                deathScreenAiMedicCooldownSeconds = {
                    description = "Cooldown before the AI medic can be called again.",
                    label = "Cooldown seconds",
                },
                deathScreenAiMedicCurrency = {
                    description = "Optional currency key used for AI medic payments.",
                    label = "Currency",
                },
                deathScreenAiMedicCurrencyFormatter = {
                    description = "Currency formatter used for AI medic payments.",
                    label = "Currency formatter",
                },
                deathScreenAiMedicDespawnDelaySeconds = {
                    description = "Seconds before the AI medic despawns after finishing.",
                    label = "Despawn delay",
                },
                deathScreenAiMedicDispatchDelaySeconds = {
                    description = "Delay before the AI medic dispatch starts.",
                    label = "Dispatch delay",
                },
                deathScreenAiMedicDriveSpeed = {
                    description = "Drive speed used by the AI medic vehicle.",
                    label = "Drive speed",
                },
                deathScreenAiMedicDriveTimeoutSeconds = {
                    description = "Maximum drive time before force-revive triggers.",
                    label = "Drive timeout",
                },
                deathScreenAiMedicEnabled = {
                    description = "Enable the AI medic rescue flow.",
                    label = "Enabled",
                },
                deathScreenAiMedicFallbackAccount = {
                    description = "Fallback account used when the primary AI medic account has insufficient funds.",
                    label = "Fallback account",
                },
                deathScreenAiMedicForceReviveEnabled = {
                    description = "Force a revive if the AI medic cannot reach the player.",
                    label = "Force revive enabled",
                },
                deathScreenAiMedicMaxMedicsOnline = {
                    description = "AI medic only works while on-duty medics are at or below this count.",
                    label = "Max medics online",
                },
                deathScreenAiMedicMissionTimeoutSeconds = {
                    description = "Maximum mission duration before force-revive triggers.",
                    label = "Mission timeout",
                },
                deathScreenAiMedicPedModel = {
                    description = "Ped model used for the AI medic.",
                    label = "Ped model",
                },
                deathScreenAiMedicPlayerRequestMode = {
                    description = "Destination used when the downed player calls the AI medic.",
                    label = "Player request destination",
                    options = {
                        hospital = "Hospital",
                        location = "Current location",
                    },
                },
                deathScreenAiMedicPrice = {
                    description = "Price charged for calling the AI medic.",
                    label = "Price",
                },
                deathScreenAiMedicRemoteDispatchDelaySeconds = {
                    description = "Seconds after the patient's death before a medic can offer a remote AI medic.",
                    label = "Remote dispatch wait",
                },
                deathScreenAiMedicRemoteDispatchEnabled = {
                    description = "Allow medics to send the AI medic to a downed player from the dispatch map and the /aimedic command.",
                    label = "Remote dispatch",
                },
                deathScreenAiMedicRemoteDispatchMaxMedicsOnline = {
                    description = "Remote AI medic dispatch only works while on-duty medics are at or below this count.",
                    label = "Remote dispatch max medics online",
                },
                deathScreenAiMedicRemoteDispatchMode = {
                    description = "Destination used when a remote AI medic is sent and accepted.",
                    label = "Remote dispatch destination",
                    options = {
                        hospital = "Hospital",
                        location = "Current location",
                    },
                },
                deathScreenAiMedicRemoteOfferTimeoutSeconds = {
                    description = "Seconds the patient has to accept a remote AI medic offer.",
                    label = "Remote offer timeout",
                },
                deathScreenAiMedicReviveDistance = {
                    description = "Distance required before the AI medic starts reviving.",
                    label = "Revive distance",
                },
                deathScreenAiMedicReviveDurationSeconds = {
                    description = "Seconds spent reviving the player.",
                    label = "Revive duration",
                },
                deathScreenAiMedicReviveInBedEnabled = {
                    description = "Teleport the player to a hospital bed instead of reviving on the spot.",
                    label = "Revive in bed",
                },
                deathScreenAiMedicReviveInBedSearchRadius = {
                    description = "Search radius used to find a revive bed.",
                    label = "Bed search radius",
                },
                deathScreenAiMedicSecondsTillAvailable = {
                    description = "Seconds after death before the AI medic becomes available.",
                    label = "Seconds till available",
                },
                deathScreenAiMedicSpawnRadiusMax = {
                    description = "Maximum AI medic spawn radius.",
                    label = "Spawn radius max",
                },
                deathScreenAiMedicSpawnRadiusMin = {
                    description = "Minimum AI medic spawn radius.",
                    label = "Spawn radius min",
                },
                deathScreenAiMedicVehicleModel = {
                    description = "Vehicle model used by the AI medic.",
                    label = "Vehicle model",
                },
                deathScreenAllowVoiceWhileUnconscious = {
                    description = "Voice mode while unconscious: none, listen, or full.",
                    label = "Voice mode",
                    options = {
                        full = "full",
                        listen = "listen",
                        none = "none",
                    },
                },
                deathScreenAllowedControls = {
                    description = "Control IDs that remain enabled while unconscious.",
                    label = "Allowed controls",
                },
                deathScreenAutoRespawnOnExpiredReconnect = {
                    description = "Automatically respawn players if the bleed-out timer already expired while disconnected.",
                    label = "Auto-respawn expired reconnect",
                },
                deathScreenBackgroundEnd = {
                    description = "End color of the death screen background.",
                    label = "Background end",
                },
                deathScreenBackgroundStart = {
                    description = "Start color of the death screen background.",
                    label = "Background start",
                },
                deathScreenBleedOutTimerSeconds = {
                    description = "Seconds before the bleed-out timer expires.",
                    label = "Bleed-out timer",
                },
                deathScreenBlockedDimensions = {
                    description = "Dimensions where the death screen respawn flow is blocked.",
                    label = "Blocked dimensions",
                },
                deathScreenBorderColor = {
                    description = "Border color used by the death screen.",
                    label = "Border color",
                },
                deathScreenDispatchEnabled = {
                    description = "Send dispatch events from the death screen flow.",
                    label = "Dispatch enabled",
                },
                deathScreenDispatchFallbackJobs = {
                    description = "Replacement recipients when no primary recipient is alive and on duty. Leave empty to always alert the primary jobs.",
                    itemLabel = "Job",
                    label = "Fallback jobs",
                },
                deathScreenDispatchJobs = {
                    description = "Jobs alerted when a downed player requests help.",
                    itemLabel = "Job",
                    label = "Alerted jobs",
                },
                deathScreenEarlyRespawnAccount = {
                    description = "Primary account charged for early respawn.",
                    label = "Account",
                },
                deathScreenEarlyRespawnAllowFatalWounds = {
                    description = "Keep early respawn available even for fatal wounds.",
                    label = "Allow fatal wounds",
                },
                deathScreenEarlyRespawnCurrency = {
                    description = "Optional currency key used for early respawn payments.",
                    label = "Currency",
                },
                deathScreenEarlyRespawnCurrencyFormatter = {
                    description = "Currency formatter used for early respawn payments.",
                    label = "Currency formatter",
                },
                deathScreenEarlyRespawnEnabled = {
                    description = "Enable paid early respawn.",
                    label = "Enabled",
                },
                deathScreenEarlyRespawnFallbackAccount = {
                    description = "Fallback account used when the primary account has insufficient funds.",
                    label = "Fallback account",
                },
                deathScreenEarlyRespawnPaymentLabel = {
                    description = "Optional label shown for the early respawn payment.",
                    label = "Payment label",
                },
                deathScreenEarlyRespawnPrice = {
                    description = "Price charged for an early respawn.",
                    label = "Price",
                },
                deathScreenEarlyRespawnRequireNoMedics = {
                    description = "Only allow early respawn when no medics are on duty.",
                    label = "Require no medics",
                },
                deathScreenEarlyRespawnSecondsTillAvailable = {
                    description = "Seconds after death before early respawn becomes available.",
                    label = "Seconds till available",
                },
                deathScreenEnableKeyboard = {
                    description = "Allow keyboard usage on the death screen.",
                    label = "Enable keyboard",
                },
                deathScreenExternalVoiceSystem = {
                    description = "External voice backend to mute when enabled.",
                    label = "External voice system",
                    options = {
                        saltychat = "saltychat",
                        yaca = "yaca",
                    },
                },
                deathScreenFocusKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Death screen mouse interaction",
                },
                deathScreenHandlingMode = {
                    description = "Use the static death animation or preserve natural ragdoll physics until the body settles.",
                    label = "Death handling",
                    options = {
                        natural = "Natural",
                        static = "Static",
                    },
                },
                deathScreenHideOverlayWithoutFocus = {
                    description = "Hide the death screen after SPACE switches to game controls; disable this to keep the legacy visible overlay.",
                    label = "Hide overlay with game controls",
                },
                deathScreenHospitalSelectionCameraFocusHeight = {
                    description = "Height offset applied to the camera focus target.",
                    label = "Focus height",
                },
                deathScreenHospitalSelectionCameraFov = {
                    description = "Preview camera field of view.",
                    label = "Field of view",
                },
                deathScreenHospitalSelectionCameraHeadingOffset = {
                    description = "Heading offset used when placing the preview camera.",
                    label = "Heading offset",
                },
                deathScreenHospitalSelectionCameraHeight = {
                    description = "Height offset applied to the preview camera.",
                    label = "Camera height",
                },
                deathScreenHospitalSelectionCameraPitch = {
                    description = "Pitch applied to the preview camera.",
                    label = "Pitch",
                },
                deathScreenHospitalSelectionCameraRadius = {
                    description = "Distance from the preview camera to the spawn point.",
                    label = "Camera radius",
                },
                deathScreenHospitalSelectionCameraTransition = {
                    description = "Use a smooth transition when opening the hospital selection camera.",
                    label = "Smooth transition",
                },
                deathScreenHospitalSelectionEnabled = {
                    description = "Allow players to select a hospital before respawning.",
                    label = "Hospital selection",
                },
                deathScreenHospitalSelectionRequireMultipleHospitals = {
                    description = "Only show hospital selection when more than one hospital exists.",
                    label = "Require multiple hospitals",
                },
                deathScreenInformationEnabled = {
                    description = "Show the information block on the death screen.",
                    label = "Enabled",
                },
                deathScreenInformationShowDeathCause = {
                    description = "Show the death cause in the death screen information block.",
                    label = "Show death cause",
                },
                deathScreenInformationShowInjuries = {
                    description = "Show injuries in the death screen information block.",
                    label = "Show injuries",
                },
                deathScreenInformationShowKiller = {
                    description = "Show the killer name in the death screen information block.",
                    label = "Show killer",
                },
                deathScreenInformationShowWeapon = {
                    description = "Show the weapon in the death screen information block.",
                    label = "Show weapon",
                },
                deathScreenInformationWhitelistedGangs = {
                    label = "Whitelisted gangs",
                    description = "Select exact gang or independent organization names. A matching job or gang grants the configured permission or exemption. Job duty requirements apply only to jobs.",
                    itemLabel = "Gang",
                },
                deathScreenInformationWhitelistedJobs = {
                    description = "Jobs allowed to see extended death screen information.",
                    itemLabel = "Job",
                    label = "Whitelisted jobs",
                },
                deathScreenLogScreenshotTimeoutSeconds = {
                    description = "Maximum seconds allowed for each death screenshot upload.",
                    label = "Screenshot timeout",
                },
                deathScreenLogScreenshots = {
                    description = "Upload victim and confirmed killer POV images after the text death log.",
                    label = "Screenshots",
                },
                deathScreenLogsEnabled = {
                    description = "Send a Discord log whenever a player dies.",
                    label = "Death logs",
                },
                deathScreenMedicNearbyRadius = {
                    description = "Distance in meters used to count a medic as nearby.",
                    label = "Medic nearby radius",
                },
                deathScreenMinigameEnabled = {
                    description = "Enable the death screen minigame.",
                    label = "Enabled",
                },
                deathScreenMinigameUrl = {
                    description = "URL opened for the death screen minigame.",
                    label = "Minigame URL",
                },
                deathScreenMode = {
                    description = "Use the bundled death screen or an external integration.",
                    label = "Screen mode",
                    options = {
                        external = "External",
                        internal = "Internal",
                    },
                },
                deathScreenMuteExternalVoiceOnDeath = {
                    description = "Mute external voice systems while the player is dead.",
                    label = "Mute external voice",
                },
                deathScreenMutedTextColor = {
                    description = "Muted text color used by the death screen.",
                    label = "Muted text color",
                },
                deathScreenNaturalRagdollDebug = {
                    description = "Print detailed client and server reasons while a natural-death body remains in ragdoll.",
                    label = "Natural ragdoll debug",
                },
                deathScreenNaturalStabilizationMode = {
                    description = "Automatically stabilize settled natural-death bodies or require an on-duty medic to place them in the recovery position.",
                    label = "Natural stabilization",
                    options = {
                        automatic = "Automatic",
                        medic = "Medic required",
                    },
                },
                deathScreenPanelBackground = {
                    description = "Panel background color used by the death screen.",
                    label = "Panel background",
                },
                deathScreenPreventAutoRespawn = {
                    description = "Block automatic respawn after bleed-out.",
                    label = "Prevent auto-respawn",
                },
                deathScreenPreventAutoRespawnIfMedicNearby = {
                    description = "Block auto-respawn while a medic is nearby.",
                    label = "Block when medic nearby",
                },
                deathScreenPreventReviveOnExpiry = {
                    description = "Block revives after the bleed-out timer expires.",
                    label = "Prevent revive on expiry",
                },
                deathScreenPrimaryColor = {
                    description = "Base CSS color used for the death screen theme.",
                    label = "Primary color",
                },
                deathScreenPrimaryDark = {
                    description = "Optional darker accent color for the death screen.",
                    label = "Primary dark",
                },
                deathScreenPrimaryStrong = {
                    description = "Optional stronger accent color for the death screen.",
                    label = "Primary strong",
                },
                deathScreenRespawnDefaultHeading = {
                    description = "Heading used when the station has no heading defined.",
                    label = "Default heading",
                },
                deathScreenRespawnFallbackCoordsHeading = {
                    description = "Fallback respawn heading used when no hospital positions exist.",
                    label = "Fallback heading",
                },
                deathScreenRespawnFallbackCoordsX = {
                    description = "Fallback respawn X coordinate used when no hospital positions exist.",
                    label = "Fallback X",
                },
                deathScreenRespawnFallbackCoordsY = {
                    description = "Fallback respawn Y coordinate used when no hospital positions exist.",
                    label = "Fallback Y",
                },
                deathScreenRespawnFallbackCoordsZ = {
                    description = "Fallback respawn Z coordinate used when no hospital positions exist.",
                    label = "Fallback Z",
                },
                deathScreenRespawnHospitalId = {
                    description = "Choose a fixed hospital for respawns. Leave it empty to use the closest hospital.",
                    label = "Respawn hospital",
                },
                deathScreenRespawnRemoveAccountsEnabled = {
                    description = "Remove account balances on respawn.",
                    label = "Remove accounts",
                },
                deathScreenRespawnRemoveAccountsNames = {
                    description = "Account names removed on respawn.",
                    itemLabel = "Account",
                    label = "Account names",
                },
                deathScreenRespawnRemoveItemsEnabled = {
                    description = "Remove inventory items on respawn.",
                    label = "Remove items",
                },
                deathScreenRespawnRemoveItemsIgnore = {
                    description = "Inventory items kept on respawn.",
                    itemLabel = "Item",
                    label = "Ignored items",
                },
                deathScreenRespawnRemoveWeaponsEnabled = {
                    description = "Remove weapon wheel weapons on respawn.",
                    label = "Remove weapons",
                },
                deathScreenRespawnRemoveWeaponsIgnore = {
                    description = "Weapons kept on respawn.",
                    itemLabel = "Weapon",
                    label = "Ignored weapons",
                },
                deathScreenRespawnTeleportToHospital = {
                    description = "Teleport the player to a hospital on respawn.",
                    label = "Teleport to hospital",
                },
                deathScreenResumeBleedOutOnReconnect = {
                    description = "Resume the bleed-out timer after reconnect instead of resetting it.",
                    label = "Resume on reconnect",
                },
                deathScreenShadowLight = {
                    description = "Soft shadow color used by the death screen.",
                    label = "Shadow light",
                },
                deathScreenShadowMid = {
                    description = "Mid shadow color used by the death screen.",
                    label = "Shadow mid",
                },
                deathScreenShowNearestMedic = {
                    description = "Show the nearest medic on the death screen.",
                    label = "Show nearest medic",
                },
                deathScreenTextColor = {
                    description = "Primary text color used by the death screen.",
                    label = "Text color",
                },
                deathScreenTextShadow = {
                    description = "Text shadow color used by the death screen.",
                    label = "Text shadow",
                },
                deathTimeoutApplyOnKnockout = {
                    description = "Apply the death timeout after knockout revives as well.",
                    label = "Apply on knockout",
                },
                deathTimeoutSeconds = {
                    description = "Seconds after a revive that combat stays disabled.",
                    label = "Seconds",
                },
                deathTimeoutShowUi = {
                    description = "Show the death timeout countdown banner while active.",
                    label = "Show UI",
                },
                deathTimeoutWhitelistedGangs = {
                    label = "Whitelisted gangs",
                    description = "Select exact gang or independent organization names. A matching job or gang grants the configured permission or exemption. Job duty requirements apply only to jobs.",
                    itemLabel = "Gang",
                },
                deathTimeoutWhitelistedJobs = {
                    description = "Jobs exempt from the death timeout restrictions.",
                    itemLabel = "Job",
                    label = "Whitelisted jobs",
                },
                deathUseAnimation = {
                    description = "Play the configured death animation for supported peds.",
                    label = "Use animation",
                },
                diagnoseAnimClip = {
                    description = "Animation clip used while opening diagnose. Leave empty to use a scenario instead.",
                    label = "Animation name",
                },
                diagnoseAnimDict = {
                    description = "Animation dictionary used while opening diagnose. Leave empty to use a scenario instead.",
                    label = "Animation dictionary",
                },
                diagnoseAnimScenario = {
                    description = "Scenario used while opening diagnose. Leave empty to use dict + clip instead.",
                    label = "Scenario",
                },
                diagnoseCprAnimDict = {
                    description = "Animation dictionary used for CPR.",
                    label = "Animation dictionary",
                },
                diagnoseCprAnimName = {
                    description = "Animation clip used for CPR.",
                    label = "Animation name",
                },
                diagnoseFullHealDelaySeconds = {
                    description = "Continuous diagnose time required before the full-heal action appears.",
                    label = "Delay seconds",
                },
                diagnoseRequireRescueBackpack = {
                    label = "Require rescue backpack",
                    description = "Require rescue_backpack to show the left examination-tool hotbar. Disable to always show it; individual tool-item requirements still apply.",
                },
                diagnoseFullHealEnabled = {
                    description = "Allow full healing after a continuous diagnose session.",
                    label = "Enabled",
                },
                diagnoseInteractDistance = {
                    description = "Maximum distance required to diagnose or body-bag a patient.",
                    label = "Interact distance",
                },
                diagnosePatientMovementMode = {
                    label = "Patient movement",
                    description = "Freeze the patient while another player has the treatment menu open, or allow movement and close the menu when the treatment distance is exceeded. Self-diagnosis is configured separately.",
                    options = {
                        freeze = "Freeze patient",
                        distance = "Close at distance limit",
                    },
                },
                diagnoseMaxTreatmentDistance = {
                    label = "Treatment distance (m)",
                    description = "Maximum distance between the treating player and patient before the treatment menu closes in distance mode. The opening distance is configured separately.",
                },
                diagnoseKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Diagnosis interaction",
                },
                diagnoseOpenDelayMs = {
                    description = "Delay before the diagnose UI opens.",
                    label = "Open delay ms",
                },
                diagnosePromptDistance = {
                    description = "Distance used to show the diagnose prompt.",
                    label = "Prompt distance",
                },
                diagnoseTreatmentDurationMs = {
                    description = "Duration used for treatment animations.",
                    label = "Treatment duration ms",
                },
                doctorNpcAddRevenueToSociety = {
                    description = "Deposit doctor payments into the shared society account when charging directly.",
                    label = "Add revenue to society",
                },
                doctorNpcEnabled = {
                    description = "Enable the doctor NPC service.",
                    label = "Enabled",
                },
                doctorNpcHealOtherAccount = {
                    description = "Primary account key used to charge healing another player.",
                    label = "Account",
                },
                doctorNpcHealOtherAccountType = {
                    description = "Primary account type used to charge healing another player.",
                    label = "Account type",
                },
                doctorNpcHealOtherCurrency = {
                    description = "Optional custom currency key used to charge healing another player.",
                    label = "Currency",
                },
                doctorNpcHealOtherPrice = {
                    description = "Price to heal another player at the doctor NPC.",
                    label = "Price",
                },
                doctorNpcHealSelfAccount = {
                    description = "Primary account key used to charge self-heal.",
                    label = "Account",
                },
                doctorNpcHealSelfAccountType = {
                    description = "Primary account type used to charge self-heal.",
                    label = "Account type",
                },
                doctorNpcHealSelfCurrency = {
                    description = "Optional custom currency key used to charge self-heal.",
                    label = "Currency",
                },
                doctorNpcHealSelfPrice = {
                    description = "Price to heal yourself at the doctor NPC.",
                    label = "Price",
                },
                doctorNpcInteractionRange = {
                    description = "How close the user must stay to the doctor NPC while using the open doctor menu. This does not change the initial NPC prompt distance.",
                    label = "Interaction range",
                },
                doctorNpcMaxMedicsOnline = {
                    description = "Doctor NPC only works while on-duty medics are below this limit.",
                    label = "Max medics online",
                },
                doctorNpcPatientRange = {
                    description = "How close the patient must be to the doctor NPC for heal other or revive to work after selecting the action.",
                    label = "Patient range",
                },
                doctorNpcPaymentMode = {
                    description = "Charge players immediately or send an invoice.",
                    label = "Payment mode",
                    options = {
                        bill = "bill",
                        remove = "remove",
                    },
                },
                doctorNpcPlayerScanRange = {
                    description = "Only used to list nearby players in the doctor NPC UI. It does not allow treatment by itself.",
                    label = "Player scan range",
                },
                doctorNpcReviveAccount = {
                    description = "Primary account key used to charge doctor revives.",
                    label = "Account",
                },
                doctorNpcReviveAccountType = {
                    description = "Primary account type used to charge doctor revives.",
                    label = "Account type",
                },
                doctorNpcReviveAllowFatalWounds = {
                    description = "Allow the doctor NPC to revive fatal or unreviveable injuries. Expired bleedout remains blocked.",
                    label = "Allow fatal wounds",
                },
                doctorNpcReviveCurrency = {
                    description = "Optional custom currency key used to charge doctor revives.",
                    label = "Currency",
                },
                doctorNpcReviveInBedEnabled = {
                    description = "Place revived players into the nearest hospital bed after a doctor revive.",
                    label = "Enabled",
                },
                doctorNpcReviveInBedSearchRadius = {
                    description = "Maximum distance used to find a nearby hospital bed for doctor revives.",
                    label = "Search radius",
                },
                doctorNpcRevivePrice = {
                    description = "Price to revive a player at the doctor NPC.",
                    label = "Price",
                },
                enforceMaxHealth = {
                    description = "Keep player maximum health at 200. Disable this when another resource manages maximum health.",
                    label = "Enforce 200 max health",
                },
                firstAidActionDurationMs = {
                    description = "How long the first aid action takes.",
                    label = "Action duration ms",
                },
                firstAidAnimationDict = {
                    description = "Animation dictionary used during the first aid action.",
                    label = "Animation dictionary",
                },
                firstAidAnimationFlag = {
                    description = "TaskPlayAnim flag used during the first aid action.",
                    label = "Animation flag",
                },
                firstAidAnimationName = {
                    description = "Animation clip used during the first aid action.",
                    label = "Animation name",
                },
                firstAidBleedoutExtensionSeconds = {
                    description = "Seconds added to the patient's bleedout timer after first aid.",
                    label = "Bleedout extension seconds",
                },
                firstAidEnabled = {
                    description = "Enable the first aid feature for licensed players.",
                    label = "First Aid enabled",
                },
                firstAidLicense = {
                    description = "Framework license name used to validate first aid access.",
                    label = "License name",
                },
                firstAidLicenseManagementAddEnabled = {
                    description = "Allow ambulance staff to give approved licenses in patient records. The radial action only gives the first aid license.",
                    label = "Add license enabled",
                },
                firstAidLicenseManagementAddRadial = {
                    description = "Show the add-license action in the radial menu.",
                    label = "Add license radial",
                },
                firstAidLicenseManagementAddRequireDuty = {
                    description = "Require EMS duty before the add-license action can be used.",
                    label = "Add license require duty",
                },
                firstAidLicenseManagementAdditionalLicenses = {
                    description = "Additional framework licenses ambulance staff may give or remove in patient records. The configured first aid license is always included.",
                    itemLabel = "License",
                    label = "Additional patient licenses",
                },
                firstAidLicenseManagementRemoveEnabled = {
                    description = "Allow ambulance staff to remove approved licenses in patient records. The radial action only removes the first aid license.",
                    label = "Remove license enabled",
                },
                firstAidLicenseManagementRemoveRadial = {
                    description = "Show the remove-license action in the radial menu.",
                    label = "Remove license radial",
                },
                firstAidLicenseManagementRemoveRequireDuty = {
                    description = "Require EMS duty before the remove-license action can be used.",
                    label = "Remove license require duty",
                },
                firstAidPositionChestOffset = {
                    description = "Chest offset used while aligning for first aid.",
                    label = "Chest offset",
                },
                firstAidPositionSideOffset = {
                    description = "Side offset used while aligning for first aid.",
                    label = "Side offset",
                },
                firstAidPositionZOffset = {
                    description = "Vertical offset used while aligning for first aid.",
                    label = "Z offset",
                },
                firstAidRequireLicense = {
                    description = "Require the configured first aid license before a player can use first aid.",
                    label = "Require license",
                },
                firstAidTargetDistance = {
                    description = "Maximum distance allowed for first aid usage.",
                    label = "Target distance",
                },
                healthInsuranceAccount = {
                    description = "Fallback account key used for insurance payments.",
                    label = "Account",
                },
                healthInsuranceAccountType = {
                    description = "Primary account type used for insurance payments.",
                    label = "Account type",
                },
                healthInsuranceAvailableDays = {
                    description = "Available insurance durations in days.",
                    label = "Available days",
                },
                healthInsuranceCommand = {
                    description = "Chat command used to open the health insurance UI.",
                    label = "Command",
                },
                healthInsuranceCurrency = {
                    description = "Optional custom currency key used for insurance payments.",
                    label = "Currency",
                },
                healthInsuranceEnabled = {
                    description = "Enable the health insurance system.",
                    label = "Enabled",
                },
                healthInsurancePricesManagedInTablet = {
                    description = "Allow authorized employees to change insurance prices in the tablet. Disable this to enforce prices from the provider table below.",
                    label = "Tablet price management",
                },
                healthInsuranceProviders = {
                    description = "Insurance providers offered to players.",
                    itemLabel = "Provider",
                    label = "Providers",
                },
                healthInsuranceSharedAcrossJobs = {
                    description = "Use the same insurance providers and policies for every job registered in this ambulance resource.",
                    label = "Share across ambulance jobs",
                },
                hospitalBedsBedAnimationDict = {
                    description = "Animation dictionary looped while the player lies on the bed. Leave empty to use the default death animation fallback.",
                    label = "Animation dictionary",
                },
                hospitalBedsBedAnimationDurationMs = {
                    description = "Optional manual duration for the looping bed animation. Only used when a custom bed animation is configured.",
                    label = "Duration ms",
                },
                hospitalBedsBedAnimationFlag = {
                    description = "TaskPlayAnim flag used for the looping bed animation. Only used when a custom bed animation is configured.",
                    label = "Animation flag",
                },
                hospitalBedsBedAnimationName = {
                    description = "Animation clip looped while the player lies on the bed. Leave empty to use the default death animation fallback.",
                    label = "Animation name",
                },
                hospitalBedsBreakDistance = {
                    description = "Distance after which the player is forced off the bed.",
                    label = "Break distance",
                },
                hospitalBedsCreatorPedModel = {
                    description = "Preview ped model used in the hospital bed position editor.",
                    label = "Creator ped model",
                },
                hospitalBedsEnabled = {
                    description = "Enable configured hospital bed interactions.",
                    label = "Enabled",
                },
                hospitalBedsGetupAnimationDict = {
                    description = "Animation dictionary played when the player gets up from the bed. Leave empty to use the default stand-up behavior.",
                    label = "Animation dictionary",
                },
                hospitalBedsGetupAnimationDurationMs = {
                    description = "Optional manual duration for the get-up animation. Only used when a custom get-up animation is configured.",
                    label = "Duration ms",
                },
                hospitalBedsGetupAnimationFlag = {
                    description = "TaskPlayAnim flag used for the get-up animation. Only used when a custom get-up animation is configured.",
                    label = "Animation flag",
                },
                hospitalBedsGetupAnimationName = {
                    description = "Animation clip played when the player gets up from the bed. Leave empty to use the default stand-up behavior.",
                    label = "Animation name",
                },
                hospitalBedsHeadingOffset = {
                    description = "Heading offset applied when placing the player on the bed.",
                    label = "Heading offset",
                },
                hospitalBedsHeightOffset = {
                    description = "Vertical offset applied when placing the player on the bed.",
                    label = "Height offset",
                },
                hospitalBedsInteractDistance = {
                    description = "Maximum distance required to use a hospital bed.",
                    label = "Interact distance",
                },
                hospitalBedsInteractKey = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Hospital bed interaction",
                },
                hospitalBedsModels = {
                    description = "World object models treated as usable hospital beds.",
                    itemLabel = "Model",
                    label = "Bed models",
                },
                hospitalBedsSearchRadius = {
                    description = "Radius used to find nearby bed props or configured beds.",
                    label = "Search radius",
                },
                hospitalBlipColor = {
                    description = "Blip color ID used for hospital map blips.",
                    label = "Color",
                },
                hospitalBlipEnabled = {
                    description = "Show hospital map blips for configured hospital positions.",
                    label = "Enabled",
                },
                hospitalBlipName = {
                    description = "Fallback hospital blip name used when no station name is available.",
                    label = "Name",
                },
                hospitalBlipScale = {
                    description = "Blip scale used for hospital map blips.",
                    label = "Scale",
                },
                hospitalBlipSprite = {
                    description = "Blip sprite ID used for hospital map blips.",
                    label = "Sprite",
                },
                imagingInteractionRange = {
                    description = "Maximum distance from the imaging station for the operator.",
                    label = "Interaction range",
                },
                imagingPatientRange = {
                    description = "Maximum distance from the imaging station for the patient.",
                    label = "Patient range",
                },
                imagingScanDurationSeconds = {
                    description = "Duration in seconds for CT and MRI scan results.",
                    label = "Scan duration",
                },
                injuryEffectsBleedingOverlayIntensity = {
                    description = "Visual-only multiplier for bleeding overlay effects.",
                    label = "Bleeding overlay intensity",
                },
                injuryEffectsPainScreenIntensity = {
                    description = "Visual-only multiplier for pain screen effects.",
                    label = "Pain screen intensity",
                },
                injuryThresholdBleedingPainMinPercent = {
                    description = "Minimum percent of max health lost in a single hit before bleeding and pain are applied.",
                    label = "Bleeding/pain min percent",
                },
                injuryThresholdRespectArmor = {
                    description = "Skip bleeding and pain when the hit was absorbed by armor.",
                    label = "Respect armor",
                },
                knockoutRegenerateDamage = {
                    description = "Regenerate knockout damage after the respawn timer expires.",
                    label = "Regenerate damage",
                },
                knockoutRegenerateDurationSeconds = {
                    description = "Seconds over which knockout damage is healed back.",
                    label = "Regeneration duration",
                },
                knockoutRespawnSeconds = {
                    description = "Seconds before an automatic respawn when a player is knocked out.",
                    label = "Respawn seconds",
                },
                knockoutWeapons = {
                    description = "Weapon names or hashes that should trigger knockout instead of the full death screen.",
                    itemLabel = "Weapon",
                    label = "Weapons",
                },
                legShotRagdollChance = {
                    description = "Percent chance that a matching hit triggers a ragdoll.",
                    label = "Chance",
                },
                legShotRagdollCooldownMs = {
                    description = "Minimum delay between leg-shot ragdolls.",
                    label = "Cooldown ms",
                },
                legShotRagdollDebug = {
                    description = "Log leg-shot ragdoll decisions for testing.",
                    label = "Debug",
                },
                legShotRagdollDurationMs = {
                    description = "How long the ragdoll lasts.",
                    label = "Duration ms",
                },
                legShotRagdollFeet = {
                    description = "Allow foot hits to trigger the ragdoll.",
                    label = "Feet",
                },
                legShotRagdollIgnoreArmorHits = {
                    description = "Skip ragdolls when armor absorbed the hit.",
                    label = "Ignore armor hits",
                },
                legShotRagdollLeftLowerLeg = {
                    description = "Allow hits on the left lower leg.",
                    label = "Left lower leg",
                },
                legShotRagdollLeftUpperLeg = {
                    description = "Allow hits on the left upper leg.",
                    label = "Left upper leg",
                },
                legShotRagdollOnlyGunshots = {
                    description = "Only allow gunshots to trigger the ragdoll.",
                    label = "Only gunshots",
                },
                legShotRagdollRightLowerLeg = {
                    description = "Allow hits on the right lower leg.",
                    label = "Right lower leg",
                },
                legShotRagdollRightUpperLeg = {
                    description = "Allow hits on the right upper leg.",
                    label = "Right upper leg",
                },
                liveDamageFracturesChance = {
                    description = "Base chance that a conscious damage hit rolls a fracture.",
                    label = "Chance",
                },
                liveDamageFracturesEnabled = {
                    description = "Allow conscious damage hits to roll fractures.",
                    label = "Enabled",
                },
                liveDamageFracturesMinDamagePercent = {
                    description = "Minimum max-health percentage lost in one hit before a live fracture can be rolled.",
                    label = "Minimum damage percent",
                },
                liveDamageFracturesZones = {
                    description = "Per-zone fracture chances for live damage.",
                    label = "Zone chances",
                },
                liveOpenWoundStacksDefault = {
                    description = "Maximum open wound stacks per zone when no zone override exists.",
                    label = "Default limit",
                },
                liveOpenWoundStacksZones = {
                    description = "Optional per-zone open wound stack limits.",
                    itemLabel = "Zone",
                    label = "Zone limits",
                },
                liveWoundBleedingClassProfiles = {
                    description = "Initial bleeding class applied per live damage cause.",
                    label = "Live wound bleeding class",
                },
                medicCarryAllowCarrierInVehicle = {
                    description = "Allow the carrier to enter and drive a vehicle without dropping the patient.",
                    label = "Allow carrier in vehicle",
                },
                medicCarryAllowConsciousTargets = {
                    description = "Allow carrying conscious players.",
                    label = "Allow conscious targets",
                },
                medicCarryAllowSprint = {
                    description = "Allow sprinting while carrying a patient.",
                    label = "Allow sprint",
                },
                medicCarryAttachBone = {
                    description = "Bone index used to attach the carried player.",
                    label = "Attach bone",
                },
                medicCarryAttachOffsetsPitch = {
                    description = "Carry attach pitch rotation.",
                    label = "Pitch",
                },
                medicCarryAttachOffsetsRoll = {
                    description = "Carry attach roll rotation.",
                    label = "Roll",
                },
                medicCarryAttachOffsetsX = {
                    description = "Carry attach X offset.",
                    label = "Offset X",
                },
                medicCarryAttachOffsetsY = {
                    description = "Carry attach Y offset.",
                    label = "Offset Y",
                },
                medicCarryAttachOffsetsYaw = {
                    description = "Carry attach yaw rotation.",
                    label = "Yaw",
                },
                medicCarryAttachOffsetsZ = {
                    description = "Carry attach Z offset.",
                    label = "Offset Z",
                },
                medicCarryCarrierAnimationDict = {
                    description = "Animation dictionary used by the medic while carrying a patient.",
                    label = "Animation dictionary",
                },
                medicCarryCarrierAnimationFlag = {
                    description = "TaskPlayAnim flag used by the medic carry animation.",
                    label = "Animation flag",
                },
                medicCarryCarrierAnimationName = {
                    description = "Animation clip used by the medic while carrying a patient.",
                    label = "Animation name",
                },
                medicCarryEnabled = {
                    description = "Enable the medic carry system.",
                    label = "Enabled",
                },
                medicCarryMaxDistance = {
                    description = "Maximum distance required to pick up a patient.",
                    label = "Max distance",
                },
                medicCarryPassengerAnimationDict = {
                    description = "Animation dictionary used by the carried patient.",
                    label = "Animation dictionary",
                },
                medicCarryPassengerAnimationFlag = {
                    description = "TaskPlayAnim flag used by the carried patient animation.",
                    label = "Animation flag",
                },
                medicCarryPassengerAnimationName = {
                    description = "Animation clip used by the carried patient.",
                    label = "Animation name",
                },
                medicCarryReapplyDeathAnimation = {
                    description = "Reapply the death animation after dropping an unconscious patient.",
                    label = "Reapply death animation",
                },
                medicCarryRequireOnDuty = {
                    description = "Only on-duty medics can start a carry.",
                    label = "Require on duty",
                },
                medicReviveAllowFatalWounds = {
                    description = "Allow on-duty medics to treat and revive fatal or unreviveable injuries. Expired bleedout remains blocked.",
                    label = "Allow fatal wounds",
                },
                medicRevivePersistenceKeepInjuries = {
                    description = "Keep unresolved injuries after treatment or checklist revives.",
                    label = "Keep injuries",
                },
                medicRevivePersistenceKeepPain = {
                    description = "Keep pain values after treatment or checklist revives when injuries are preserved.",
                    label = "Keep pain",
                },
                medicalEvaluationPatientSelectionRange = {
                    description = "Maximum distance used to list nearby players when creating a medical evaluation.",
                    label = "Nearby patient range",
                },
                medicalEvaluationRecipientJobs = {
                    description = "Jobs for which medical evaluations may be issued and shared.",
                    label = "Recipient jobs",
                },
                medicalEvaluationShareBirthDate = {
                    description = "Allow recipient jobs to see the patient's date of birth.",
                    label = "Share date of birth",
                },
                medicalEvaluationShareConclusion = {
                    description = "Allow recipient jobs to see the medical conclusion.",
                    label = "Share conclusion",
                },
                medicalEvaluationShareEvaluationTypes = {
                    description = "Allow recipient jobs to see which evaluation types were performed.",
                    label = "Share evaluation types",
                },
                medicalEvaluationShareFullName = {
                    description = "Allow recipient jobs to see the patient's full name.",
                    label = "Share full name",
                },
                medicalEvaluationShareGender = {
                    description = "Allow recipient jobs to see the patient's gender.",
                    label = "Share gender",
                },
                medicalEvaluationShareHeight = {
                    description = "Allow recipient jobs to see the patient's height.",
                    label = "Share height",
                },
                medicalEvaluationShareHobbies = {
                    description = "Allow recipient jobs to see the patient's leisure activities and hobbies.",
                    label = "Share leisure and hobbies",
                },
                medicalEvaluationShareIssuer = {
                    description = "Show the author's name. The issuing job always identifies its Shared Documents folder.",
                    label = "Share author details",
                },
                medicalEvaluationSharePersonalId = {
                    description = "Allow recipient jobs to see the patient's personal ID.",
                    label = "Share personal ID",
                },
                medicalEvaluationShareProfession = {
                    description = "Allow recipient jobs to see the patient's profession.",
                    label = "Share profession",
                },
                medicalEvaluationShareQuestionnaireAnswers = {
                    description = "Allow recipient jobs to see questionnaire questions and recorded answers.",
                    label = "Share questions and answers",
                },
                medicalEvaluationShareResult = {
                    description = "Allow recipient jobs to see whether the evaluation is pending, passed or failed.",
                    label = "Share result",
                },
                medicalEvaluationShareWeight = {
                    description = "Allow recipient jobs to see the patient's weight.",
                    label = "Share weight",
                },
                medicalEvaluationTypes = {
                    description = "Configure evaluation types, questions, answer types and whether each question is active.",
                    label = "Evaluation types and questionnaires",
                    options = {
                        boolean = "Yes / No",
                        boolean_text = "Yes / No with details",
                        date = "Date",
                        multi_select = "Multiple choice",
                        number = "Number",
                        rating = "Rating",
                        select = "Single choice",
                        text = "Text",
                        textarea = "Text area",
                        time = "Time",
                    },
                },
                medicalEvaluationsEnabled = {
                    description = "Enable medical evaluations in the ambulance tablet.",
                    label = "Enabled",
                },
                medicalWearablesAllowUntilRemoved = {
                    description = "Offer a permanent duration that remains active until a medic removes the medical aid.",
                    label = "Allow until removed",
                },
                medicalWearablesArmCastsDisableMelee = {
                    description = "Prevent melee attacks while an arm cast is equipped.",
                    label = "Disable melee",
                },
                medicalWearablesArmCastsDisableWeapons = {
                    description = "Force unarmed and prevent weapon switching while an arm cast is equipped.",
                    label = "Disable weapons",
                },
                medicalWearablesArmCastsRestrictionsEnabled = {
                    description = "Apply combat restrictions while an arm cast is equipped.",
                    label = "Enabled",
                },
                medicalWearablesAutoFromFractures = {
                    description = "Treat matching fractures when a cast or splint is applied.",
                    label = "Fracture integration",
                },
                medicalWearablesCastsEnabled = {
                    description = "Allow left/right arm and leg casts.",
                    label = "Enabled",
                },
                medicalWearablesCastsItem = {
                    description = "Inventory item consumed when applying a cast.",
                    label = "Item",
                },
                medicalWearablesCastsMinigame = {
                    description = "Existing treatment minigame used for casts.",
                    label = "Minigame",
                },
                medicalWearablesDefaultDurationMinutes = {
                    description = "Default medical-aid duration in minutes. Set 0 for until removed.",
                    label = "Default minutes",
                },
                medicalWearablesDurationOptionsMinutes = {
                    description = "Medical-aid duration choices shown to medics, in minutes.",
                    label = "Duration options",
                },
                medicalWearablesEnabled = {
                    description = "Enable cast, splint, bandage, collar, and oxygen-mask props in the treatment UI.",
                    label = "Enabled",
                },
                medicalWearablesExpiryCheckSeconds = {
                    description = "How often expired timed medical aids are removed.",
                    label = "Expiry check seconds",
                },
                medicalWearablesHeadBandageEnabled = {
                    description = "Allow the head-bandage prop.",
                    label = "Enabled",
                },
                medicalWearablesHeadBandageItem = {
                    description = "Inventory item consumed for a head bandage.",
                    label = "Item",
                },
                medicalWearablesHeadBandageMinigame = {
                    description = "Existing treatment minigame used for a head bandage.",
                    label = "Minigame",
                },
                medicalWearablesLegCastsDisableJump = {
                    description = "Prevent jumping while a leg cast is equipped.",
                    label = "Disable jump",
                },
                medicalWearablesLegCastsDisableSprint = {
                    description = "Prevent sprinting while a leg cast is equipped.",
                    label = "Disable sprint",
                },
                medicalWearablesLegCastsForceInjuredWalk = {
                    description = "Force the injured movement clipset while a leg cast is equipped.",
                    label = "Force injured walk",
                },
                medicalWearablesLegCastsMoveRate = {
                    description = "Movement-rate override while a leg cast is equipped.",
                    label = "Move rate",
                },
                medicalWearablesLegCastsRestrictionsEnabled = {
                    description = "Apply movement restrictions while a leg cast is equipped.",
                    label = "Enabled",
                },
                medicalWearablesNeckBraceEnabled = {
                    description = "Allow the neck-brace prop.",
                    label = "Enabled",
                },
                medicalWearablesNeckBraceItem = {
                    description = "Inventory item consumed for a neck brace.",
                    label = "Item",
                },
                medicalWearablesNeckBraceMinigame = {
                    description = "Existing treatment minigame used for a neck brace.",
                    label = "Minigame",
                },
                medicalWearablesOxygenMaskEnabled = {
                    description = "Allow the oxygen-mask prop.",
                    label = "Enabled",
                },
                medicalWearablesOxygenMaskItem = {
                    description = "Inventory item consumed for an oxygen mask.",
                    label = "Item",
                },
                medicalWearablesOxygenMaskMinigame = {
                    description = "Existing treatment minigame used for an oxygen mask.",
                    label = "Minigame",
                },
                medicalWearablesPatientHudEnabled = {
                    description = "Show patients their active medical aids and remaining wear time.",
                    label = "Enabled",
                },
                medicalWearablesPatientHudPosition = {
                    description = "Choose where the patient medical-aid HUD is displayed.",
                    label = "Position",
                    options = {
                        ["bottom-center"] = "Bottom center",
                        ["bottom-left"] = "Bottom left",
                        ["bottom-right"] = "Bottom right",
                        center = "Center",
                        ["center-left"] = "Center left",
                        ["center-right"] = "Center right",
                        ["top-center"] = "Top center",
                        ["top-left"] = "Top left",
                        ["top-right"] = "Top right",
                    },
                },
                medicalWearablesPersistence = {
                    description = "Restore timed casts, splints, neck braces, and torso bandages after reconnects and resource restarts.",
                    label = "Medical-aid persistence",
                },
                medicalWearablesRemoval = {
                    description = "Allow medics to remove active casts, splints, neck braces, and torso bandages from the treatment UI.",
                    label = "Medic removal",
                },
                medicalWearablesRemovalTreatmentEnabled = {
                    description = "Show medical-aid removal with the configured tool in the treatment UI.",
                    label = "Removal treatment enabled",
                },
                medicalWearablesRemovalTreatmentItem = {
                    description = "Reusable inventory tool required when removing a medical aid.",
                    label = "Item",
                },
                medicalWearablesRemovalTreatmentMinigame = {
                    description = "Medical-aid removal minigame (cast_saw by default).",
                    label = "Minigame",
                },
                medicalWearablesSplintsEnabled = {
                    description = "Allow left/right arm sling splints.",
                    label = "Enabled",
                },
                medicalWearablesSplintsItem = {
                    description = "Inventory item consumed when applying a splint.",
                    label = "Item",
                },
                medicalWearablesSplintsMinigame = {
                    description = "Existing treatment minigame used for splints.",
                    label = "Minigame",
                },
                medicalWearablesTorsoBandageEnabled = {
                    description = "Allow the torso-bandage prop.",
                    label = "Enabled",
                },
                medicalWearablesTorsoBandageItem = {
                    description = "Inventory item consumed for a torso bandage.",
                    label = "Item",
                },
                medicalWearablesTorsoBandageMinigame = {
                    description = "Existing treatment minigame used for a torso bandage.",
                    label = "Minigame",
                },
                medicationsProfiles = {
                    description = "Declarative medication entries used for treatment and self-medication.",
                    itemLabel = "Medication",
                    label = "Medications",
                },
                minigamesBagValveMaskEnabled = {
                    description = "Enable the bag valve mask minigame.",
                    label = "Bag Valve Mask",
                },
                minigamesCastSawEnabled = {
                    description = "Enable the cast saw minigame for medical-aid removal.",
                    label = "Cast Saw",
                },
                minigamesBandageWrapEnabled = {
                    description = "Enable the bandage wrap minigame.",
                    label = "Bandage Wrap",
                },
                minigamesBandageWrapRandomization = {
                    description = "Randomize the gauze path direction, shape, and proportions.",
                    label = "Bandage wrap variation",
                },
                minigamesBloodPressureEnabled = {
                    description = "Enable the blood pressure minigame.",
                    label = "Blood Pressure",
                },
                minigamesBloodTransfusionAccessRandomization = {
                    description = "Randomize the venous access path for blood transfusions.",
                    label = "Transfusion access variation",
                },
                minigamesBloodTransfusionEnabled = {
                    description = "Enable the blood transfusion minigame.",
                    label = "Blood Transfusion",
                },
                minigamesBloodTransfusionVenousAccess = {
                    description = "Require the multi-step venous access procedure before flow control. Disable for the old simple version.",
                    label = "Venous access stage",
                },
                minigamesBulletExtractionEnabled = {
                    description = "Enable the bullet extraction minigame.",
                    label = "Bullet Extraction",
                },
                minigamesBulletExtractionRandomization = {
                    description = "Randomize the wound canal shape, width, and obstructions.",
                    label = "Bullet extraction variation",
                },
                minigamesCprBreathsPerCycle = {
                    description = "Breaths required during each ventilation phase.",
                    label = "Breaths per cycle",
                },
                minigamesCprCompressionDurationPerSet = {
                    description = "Seconds to complete one compression set.",
                    label = "Compression duration per set",
                },
                minigamesCprCompressionWindow = {
                    description = "Allowed offset when hitting a compression beat.",
                    label = "Compression window",
                },
                minigamesCprCompressionsEnabled = {
                    description = "Enable the CPR compressions minigame stage.",
                    label = "CPR Compressions",
                },
                minigamesCprCompressionsPerSet = {
                    description = "Number of compressions per set.",
                    label = "Compressions per set",
                },
                minigamesCprCycles = {
                    description = "How many CPR cycles are needed to finish the minigame.",
                    label = "Cycles",
                },
                minigamesCprEnabled = {
                    description = "Enable the CPR minigame.",
                    label = "CPR",
                },
                minigamesCprIntroDelaySeconds = {
                    description = "Countdown before CPR compressions start.",
                    label = "Intro delay seconds",
                },
                minigamesCprMaxMisses = {
                    description = "Misses allowed before failing the CPR minigame.",
                    label = "Max misses",
                },
                minigamesCprSetsPerCycle = {
                    description = "How many compression sets run before a breath stage.",
                    label = "Sets per cycle",
                },
                minigamesCprVentilationEnabled = {
                    description = "Enable the CPR ventilation minigame stage.",
                    label = "CPR Ventilation",
                },
                minigamesGlucoseMeterEnabled = {
                    description = "Enable the glucose meter minigame.",
                    label = "Glucose Meter",
                },
                minigamesPulseMeasurementEnabled = {
                    description = "Enable the pulse measurement minigame.",
                    label = "Pulse Measurement",
                },
                minigamesPulseOximeterEnabled = {
                    description = "Enable the pulse oximeter minigame.",
                    label = "Pulse Oximeter",
                },
                minigamesSalineInfusionEnabled = {
                    description = "Enable the saline infusion minigame.",
                    label = "Saline Infusion",
                },
                minigamesVentilationBreathTimeoutSeconds = {
                    description = "Seconds before a ventilation attempt times out. Set 0 to disable.",
                    label = "Breath timeout seconds",
                },
                minigamesVentilationEnabled = {
                    description = "Enable the ventilation minigame.",
                    label = "Ventilation",
                },
                minigamesVentilationTolerance = {
                    description = "Pixel distance tolerance when tracing the airflow wave.",
                    label = "Tolerance",
                },
                operationsBreakDistance = {
                    description = "Maximum distance participants may move from the room before the procedure is aborted.",
                    label = "Break Distance",
                },
                operationsDoctorAnimationDict = {
                    description = "GTA animation dictionary used by the surgeon during a live procedure.",
                    label = "Doctor Animation Dictionary",
                },
                operationsDoctorAnimationFlag = {
                    description = "GTA animation flag applied to the surgeon's live procedure animation.",
                    label = "Doctor Animation Flag",
                },
                operationsDoctorAnimationName = {
                    description = "Animation clip used by the surgeon during a live procedure.",
                    label = "Doctor Animation Name",
                },
                operationsEnabled = {
                    description = "Enables operating rooms and surgical procedures.",
                    label = "Enabled",
                },
                operationsFadeInMs = {
                    description = "Duration of the patient's wake-up screen fade-in in milliseconds.",
                    label = "Wake-Up Fade-In (ms)",
                },
                operationsFadeOutMs = {
                    description = "Duration of the patient's anesthesia screen fade-out in milliseconds.",
                    label = "Anesthesia Fade-Out (ms)",
                },
                operationsIdleTimeoutSeconds = {
                    description = "Maximum time without a valid minigame action before the session is aborted.",
                    label = "Idle Timeout (seconds)",
                },
                operationsInteractDistance = {
                    description = "Maximum distance for displaying and using operating-room interactions.",
                    label = "Interaction Distance",
                },
                operationsInteractKey = {
                    description = "Control ID used to interact with the operating table and surgeon position.",
                    label = "Interaction Key",
                },
                operationsPatientAnimationDict = {
                    description = "GTA animation dictionary used while the patient lies under full anesthesia.",
                    label = "Patient Animation Dictionary",
                },
                operationsPatientAnimationFlag = {
                    description = "GTA animation flag applied to the patient's lying animation.",
                    label = "Patient Animation Flag",
                },
                operationsPatientAnimationName = {
                    description = "Animation clip used while the patient lies under full anesthesia.",
                    label = "Patient Animation Name",
                },
                operationsPatientRange = {
                    description = "Maximum range used to detect a patient lying on the operating table.",
                    label = "Patient Range",
                },
                operationsRequireOnDuty = {
                    description = "Requires surgeons to be on duty before using an operating room.",
                    label = "Require On Duty",
                },
                operationsSelectionTimeoutSeconds = {
                    description = "Maximum time the surgeon may remain in procedure selection before the session is aborted.",
                    label = "Selection Timeout (seconds)",
                },
                operationsTrainingAnimationDict = {
                    description = "GTA animation dictionary used for surgical training without a patient.",
                    label = "Training Animation Dictionary",
                },
                operationsTrainingAnimationFlag = {
                    description = "GTA animation flag applied to the surgical training animation.",
                    label = "Training Animation Flag",
                },
                operationsTrainingAnimationName = {
                    description = "Animation clip used for surgical training without a patient.",
                    label = "Training Animation Name",
                },
                painClassesProfiles = {
                    description = "Pain thresholds, labels, and post-processing effects.",
                    label = "Pain classes",
                },
                painEffectsMinPainLevel = {
                    description = "Minimum pain level before pain screen effects start.",
                    label = "Min pain level",
                },
                primaryColor = {
                    description = "Primary color for the EMS UI and ambulance job group.",
                    label = "Primary color",
                },
                propPlacementConsumeItem = {
                    description = "Consume the matching inventory item when the prop is placed.",
                    label = "Consume item",
                },
                propPlacementEnabled = {
                    description = "Allow configured EMS props to be placed from usable inventory items.",
                    label = "Enabled",
                },
                propPlacementItemNames = {
                    description = "Map EMS prop models to inventory item names for item-based placement.",
                    label = "Prop item names",
                },
                propPlacementRequireOnDuty = {
                    description = "Require the player to be on duty before placing EMS props.",
                    label = "Require on duty",
                },
                propPlacementReturnItem = {
                    description = "Give the consumed item back when a placed prop is removed.",
                    label = "Return item on remove",
                },
                propPlacementVehicleAccess = {
                    description = "Allow trunk props to open the placement flow instead of item-only usage.",
                    label = "Vehicle access",
                },
                publicTreatmentAllowConsciousPatients = {
                    description = "Allow public treatment on conscious players.",
                    label = "Allow conscious patients",
                },
                publicTreatmentAllowedGangs = {
                    label = "Allowed gangs",
                    description = "Select exact gang or independent organization names. A matching job or gang grants the configured permission or exemption. Job duty requirements apply only to jobs. Optional minimum gang ranks. Empty allows all ranks. Item requirements still apply.",
                },
                publicTreatmentAllowedJobs = {
                    description = "Jobs that may use public treatment without being EMS.",
                    label = "Allowed jobs",
                },
                publicTreatmentEnabled = {
                    description = "Enable public treatment for non-EMS responders with valid access.",
                    label = "Public Treatment enabled",
                },
                publicTreatmentInteractDistance = {
                    description = "Maximum distance required to start public treatment.",
                    label = "Interact distance",
                },
                publicTreatmentKeybind = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Provide first aid",
                },
                publicTreatmentInteractionEnabled = {
                    description = "Show the treatment prompt and enable its keybind. Disable this when using exports or a custom radial menu.",
                    label = "Keyboard interaction enabled",
                },
                publicTreatmentPromptDistance = {
                    description = "Distance used to show the public treatment prompt.",
                    label = "Prompt distance",
                },
                publicTreatmentRequireAllItems = {
                    description = "Require every listed medical item instead of only one.",
                    label = "Require all items",
                },
                publicTreatmentRequiredItems = {
                    description = "Inventory items that count as valid public treatment gear.",
                    itemLabel = "Item",
                    label = "Required items",
                },
                reviveRewardAccount = {
                    description = "Primary account key used for revive reward payments.",
                    label = "Account",
                },
                reviveRewardAccountType = {
                    description = "Primary account type used for revive reward payments.",
                    label = "Account type",
                },
                reviveRewardAmount = {
                    description = "Reward amount paid to the medic for a revive.",
                    label = "Amount",
                },
                reviveRewardCurrency = {
                    description = "Optional custom currency key used for revive reward payments.",
                    label = "Currency",
                },
                reviveRewardEnabled = {
                    description = "Pay a configured reward after a successful medic revive.",
                    label = "Enabled",
                },
                reviveRewardPayFromSociety = {
                    description = "Deduct revive rewards from the shared job society before paying the medic.",
                    label = "Pay from society",
                },
                selfDiagnoseCommand = {
                    description = "Chat command used to open self diagnose.",
                    label = "Command",
                },
                selfDiagnoseEnabled = {
                    description = "Allow players to open the diagnose UI on themselves.",
                    label = "Self Diagnose enabled",
                },
                selfDiagnoseKeybind = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Self diagnosis",
                },
                selfDiagnoseOpenDelayMs = {
                    description = "Delay before the self diagnose UI opens.",
                    label = "Open delay ms",
                },
                selfDiagnoseRequireMedicJob = {
                    description = "Restrict self diagnose to medic jobs only.",
                    label = "Require medic job",
                },
                selfDiagnoseSkipFreezeOnSelf = {
                    description = "Do not freeze the player while self diagnosing.",
                    label = "Skip freeze on self",
                },
                statusEffectsProfiles = {
                    description = "Configured screen effects and thresholds for bleeding, low blood, hunger, and thirst.",
                    label = "Status effects",
                },
                stretcherAnimDict = {
                    description = "Animation dictionary used while carrying the stretcher.",
                    label = "Animation dict",
                },
                stretcherAnimName = {
                    description = "Animation name used while carrying the stretcher.",
                    label = "Animation name",
                },
                stretcherAttachRx = {
                    description = "Carry attach X rotation for the stretcher.",
                    label = "Attach RX",
                },
                stretcherAttachRy = {
                    description = "Carry attach Y rotation for the stretcher.",
                    label = "Attach RY",
                },
                stretcherAttachRz = {
                    description = "Carry attach Z rotation for the stretcher.",
                    label = "Attach RZ",
                },
                stretcherAttachX = {
                    description = "Carry attach X offset for the stretcher.",
                    label = "Attach X",
                },
                stretcherAttachY = {
                    description = "Carry attach Y offset for the stretcher.",
                    label = "Attach Y",
                },
                stretcherAttachZ = {
                    description = "Carry attach Z offset for the stretcher.",
                    label = "Attach Z",
                },
                stretcherFoldedEnabled = {
                    description = "Enable the optional folded stretcher variant inside vehicles.",
                    label = "Folded enabled",
                },
                stretcherFoldedModel = {
                    description = "Prop model used for the folded stretcher variant.",
                    label = "Folded model",
                },
                stretcherFoldedPatientAttachHeading = {
                    description = "Patient heading used for the folded stretcher variant.",
                    label = "Folded patient heading",
                },
                stretcherFoldedPatientAttachX = {
                    description = "Patient attach X offset for the folded stretcher.",
                    label = "Folded patient X",
                },
                stretcherFoldedPatientAttachY = {
                    description = "Patient attach Y offset for the folded stretcher.",
                    label = "Folded patient Y",
                },
                stretcherFoldedPatientAttachZ = {
                    description = "Patient attach Z offset for the folded stretcher.",
                    label = "Folded patient Z",
                },
                stretcherHelicopterInteractDistance = {
                    description = "Interaction distance override used for helicopters.",
                    label = "Helicopter interact distance",
                },
                stretcherHelicopterModels = {
                    description = "Vehicle models treated as stretcher helicopters.",
                    itemLabel = "Model",
                    label = "Helicopter models",
                },
                stretcherHelicopterPickupDistance = {
                    description = "Pickup distance override used for helicopters.",
                    label = "Helicopter pickup distance",
                },
                stretcherInteractDistance = {
                    description = "Maximum distance for stretcher interaction prompts.",
                    label = "Interact distance",
                },
                stretcherItemEnabled = {
                    description = "Enable the stretcher inventory item, including shop purchase and use.",
                    label = "Stretcher item",
                },
                stretcherItemPickupEnabled = {
                    description = "Allow stretchers deployed from the inventory item to be returned to the inventory.",
                    label = "Item pickup",
                },
                stretcherModel = {
                    description = "Primary stretcher prop model used by the EMS stretcher system.",
                    label = "Model",
                },
                stretcherPatientAnimationDict = {
                    description = "Animation dictionary for stretcher patients and the preview NPC.",
                    label = "Patient animation dictionary",
                },
                stretcherPatientAnimationName = {
                    description = "Animation clip for stretcher patients and the preview NPC.",
                    label = "Patient animation name",
                },
                stretcherPatientAttachHeading = {
                    description = "Patient heading used while lying on the stretcher.",
                    label = "Patient heading",
                },
                stretcherPatientAttachX = {
                    description = "Patient attach X offset on the stretcher.",
                    label = "Patient X",
                },
                stretcherPatientAttachY = {
                    description = "Patient attach Y offset on the stretcher.",
                    label = "Patient Y",
                },
                stretcherPatientAttachZ = {
                    description = "Patient attach Z offset on the stretcher.",
                    label = "Patient Z",
                },
                stretcherPickupDistance = {
                    description = "Distance required to pick up and interact with the stretcher.",
                    label = "Pickup distance",
                },
                stretcherTreatmentAnimClip = {
                    description = "Animation clip used while treating a patient on a stretcher. Leave empty to use a scenario or the treatment animation fallback.",
                    label = "Animation name",
                },
                stretcherTreatmentAnimDict = {
                    description = "Animation dictionary used while treating a patient on a stretcher. Leave empty to use a scenario or the treatment animation fallback.",
                    label = "Animation dictionary",
                },
                stretcherTreatmentAnimScenario = {
                    description = "Optional scenario used while treating a patient on a stretcher. Leave empty to use dict + clip or the treatment animation fallback.",
                    label = "Scenario",
                },
                stretcherVehicleAttachEditor = {
                    description = "Position and rotate the stretcher inside a configured ambulance.",
                    label = "Vehicle attachment",
                },
                stretcherVehicleAttachRx = {
                    description = "Vehicle attach X rotation for loading the stretcher.",
                    label = "Vehicle RX",
                },
                stretcherVehicleAttachRy = {
                    description = "Vehicle attach Y rotation for loading the stretcher.",
                    label = "Vehicle RY",
                },
                stretcherVehicleAttachRz = {
                    description = "Vehicle attach Z rotation for loading the stretcher.",
                    label = "Vehicle RZ",
                },
                stretcherVehicleAttachX = {
                    description = "Vehicle attach X offset for loading the stretcher.",
                    label = "Vehicle X",
                },
                stretcherVehicleAttachY = {
                    description = "Vehicle attach Y offset for loading the stretcher.",
                    label = "Vehicle Y",
                },
                stretcherVehicleAttachZ = {
                    description = "Vehicle attach Z offset for loading the stretcher.",
                    label = "Vehicle Z",
                },
                stretcherVehicleModels = {
                    description = "Vehicle models allowed to load the stretcher.",
                    itemLabel = "Model",
                    label = "Vehicle models",
                },
                treatmentAnimClip = {
                    description = "Animation clip used while treating a patient. Leave empty to use a scenario instead.",
                    label = "Animation name",
                },
                treatmentAnimDict = {
                    description = "Animation dictionary used while treating a patient. Leave empty to use a scenario instead.",
                    label = "Animation dictionary",
                },
                treatmentAnimScenario = {
                    description = "Scenario used while treating a patient. Leave empty to use dict + clip instead.",
                    label = "Scenario",
                },
                trunkPropsEnabled = {
                    label = "Vehicle Props",
                    description = "Select props at a nearby duty vehicle.",
                },
                trunkEnabled = {
                    description = "Enable the vehicle trunk feature for ambulance vehicles.",
                    label = "Enabled",
                },
                vehicleDamageModifier = {
                    description = "Damage multiplier applied while the player is inside a vehicle.",
                    label = "Vehicle damage modifier",
                },
                vehicleImpactProtectionCauses = {
                    description = "Death causes that should count as protected vehicle impacts.",
                    itemLabel = "Cause",
                    label = "Damage causes",
                },
                vehicleImpactProtectionEnabled = {
                    description = "Prevent low-speed vehicle impacts from killing the player.",
                    label = "Enabled",
                },
                vehicleImpactProtectionFatalSpeedKmh = {
                    description = "Vehicle impacts below this speed cannot kill the player.",
                    label = "Fatal speed km/h",
                },
                vehicleImpactProtectionFullDamageSpeedKmh = {
                    description = "Vehicle impacts at or above this speed use the normal death injury configuration.",
                    label = "Full damage speed km/h",
                },
                vehicleImpactProtectionInjuries = {
                    description = "Injuries applied when vehicle impact protection blocks a fatal hit.",
                    itemLabel = "Injury",
                    label = "Injuries",
                },
                vehicleImpactProtectionSurvivalHealthPercent = {
                    description = "Percent of max health preserved when a protected impact would have killed the player.",
                    label = "Survival health percent",
                },
                vehiclePullEnabled = {
                    description = "Enable pulling patients from vehicles.",
                    label = "Enabled",
                },
                vehiclePullMaxDistance = {
                    description = "Maximum distance required to pull a patient from a vehicle.",
                    label = "Max distance",
                },
                wheelchairAssignMaxDistance = {
                    description = "Maximum distance for assigning a wheelchair to another player.",
                    label = "Assign max distance",
                },
                wheelchairAutoUnequipOnExpire = {
                    description = "Automatically unequip the wheelchair when the assignment expires.",
                    label = "Auto unequip on expire",
                },
                wheelchairDefaultDurationMinutes = {
                    description = "Default assigned wheelchair duration in minutes.",
                    label = "Default duration",
                },
                wheelchairDisableSprint = {
                    description = "Block sprinting while the wheelchair is equipped.",
                    label = "Disable sprint",
                },
                wheelchairDisableWeapons = {
                    description = "Block weapon usage while the wheelchair is equipped.",
                    label = "Disable weapons",
                },
                wheelchairExitControl = {
                    description = "Default FiveM binding, e.g. E, F6 or MOUSE_BUTTON:MOUSE_RIGHT. Empty means no default key. Players can change their own bindings in FiveM settings; saved player bindings are preserved.",
                    label = "Leave wheelchair",
                },
                wheelchairItemName = {
                    description = "Inventory item used for the wheelchair.",
                    label = "Item name",
                },
                wheelchairMaxDurationMinutes = {
                    description = "Maximum allowed wheelchair assignment duration in minutes.",
                    label = "Max duration",
                },
                wheelchairMinDurationMinutes = {
                    description = "Minimum allowed wheelchair assignment duration in minutes.",
                    label = "Min duration",
                },
                wheelchairVehicle = {
                    description = "Vehicle model used for the wheelchair.",
                    label = "Vehicle model",
                },
                xrayInteractionRange = {
                    description = "Maximum distance from the X-ray station for the operator.",
                    label = "Interaction range",
                },
                xrayPatientRange = {
                    description = "Maximum distance from the X-ray station for the patient.",
                    label = "Patient range",
                },
                xrayScanDurationSeconds = {
                    description = "Duration in seconds for the X-ray scan result.",
                    label = "Scan duration",
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
                firstAidPublicTreatmentConflict = "First Aid and Public Treatment cannot both be enabled at the same time. Saving disables both.",
            },
        },
    },
}
