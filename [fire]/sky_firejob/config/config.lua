-- Activity access lists accept exact jobs/groups and "gang:<internal_name>" selectors.
-- Gangs use their own membership; configured job duty requirements apply only to job grants.

-- Ordered image sources (item/weapon/prop/ped/vehicle) are configured once in sky_jobs_base
-- (Config.Nui) and resolved here via the sky_jobs_base:getNuiImageBases callback.

-- Use the shared /jobconfig UI for Config.Jobs and firejob-wide settings.
-- Set to false to use only the Lua job definitions below.
Config.UseJobConfigurator = true

Config.CommandPermissions = {
    -- /skyfire - Spawn a debug fire
    skyfire = { "god", "superadmin", "admin" },
    -- /skyfiremenu - Open the admin fire creator UI
    skyfiremenu = {
        groups = { "god", "superadmin", "admin" },
        jobs = {}, -- Example: { "firefighter", "ambulance" }
    },
    -- /skyfirestop - Stop one debug fire
    skyfirestop = { "god", "superadmin", "admin" },
    -- /skyfirestopnear - Stop the nearest debug fire
    skyfirestopnear = { "god", "superadmin", "admin" },
    -- /skyfireclear - Stop all debug fires
    skyfireclear = { "god", "superadmin", "admin" },
    -- /skyfirelist - List active debug fires and burned-out scenes
    skyfirelist = { "god", "superadmin", "admin" },
    -- /skyfiredebug - Toggle client fire debug labels
    skyfiredebug = { "god", "superadmin", "admin" },
    -- /skyfiredecal - Place a debug burn decal
    skyfiredecal = { "god", "superadmin", "admin" },
    -- /missioncreator - Open the fire scenario creator UI
    missioncreator = { "god", "superadmin", "admin" },
}

Config.AutoExecuteQuery = true -- Automatically creates/updates database tables on start. Set to false to disable.

-- Default FiveM key mappings; players can rebind every action in their FiveM settings.
-- Keyboard: "E", "F6", etc. Other devices: "MOUSE_BUTTON:MOUSE_RIGHT". Empty = unbound default.
-- /jobconfig manages these defaults; it does not overwrite existing player bindings.
Config.Keybinds = {
    fireInteriorExtinguishersControl38 = "E",
    fireEditorControl174 = "LEFT",
    fireEditorControl175 = "RIGHT",
    fireEditorControl14 = "MOUSE_WHEEL:IOM_WHEEL_DOWN",
    fireEditorControl15 = "MOUSE_WHEEL:IOM_WHEEL_UP",
    fireEditorControl177 = "BACK",
    fireWaterMonitorControl172 = "UP",
    fireWaterMonitorControl241 = "MOUSE_WHEEL:IOM_WHEEL_UP",
    fireWaterMonitorControl173 = "DOWN",
    fireWaterMonitorControl242 = "MOUSE_WHEEL:IOM_WHEEL_DOWN",
    fireWaterMonitorControl174 = "LEFT",
    fireWaterMonitorControl175 = "RIGHT",
    fireWaterMonitorControl24 = "MOUSE_BUTTON:MOUSE_LEFT",
    fireWaterMonitorControl25 = "MOUSE_BUTTON:MOUSE_RIGHT",
    fireWaterMonitorControl177 = "BACK",
    fireWaterMonitorControl202 = "ESCAPE",
    fireEditorControl24 = "MOUSE_BUTTON:MOUSE_LEFT",
    fireEditorControl199 = "P",
    fireEditorControl200 = "ESCAPE",
    fireEditorControl202 = "ESCAPE",
    fireEditorControl322 = "ESCAPE",
    firePropIgnitionControl177 = "BACK",
    firePropIgnitionControl38 = "E",
    fireEditorControl25 = "MOUSE_BUTTON:MOUSE_RIGHT",
    fireEditorControl21 = "LSHIFT",
    fireEditorControl36 = "LCONTROL",
    fireEditorControl32 = "W",
    fireEditorControl33 = "S",
    fireEditorControl34 = "A",
    fireEditorControl35 = "D",
    fireEditorControl44 = "Q",
    fireEditorControl38 = "E",
    fireEditorControl45 = "R",
    fireEditorControl191 = "RETURN",
    heliBucketAttachKey = "E",
    heliBucketDumpKey = "X",
    deckGunSprayGamepadKey = "PAD_ANALOGBUTTON:L1_INDEX",
    deckGunSprayKey = "MOUSE_BUTTON:MOUSE_RIGHT",
    firetruckHudToggleKey = "",
    firetruckHudCursorKey = "LCONTROL",
}

Config.PrimaryColor = "#EEA125"

-- "consent" lets the recipient pay cash/card; "framework" uses the sky_base billing provider.
Config.Billing = {
    enabled = true,
    mode = "framework", -- Uses the selected Sky Base provider; Sky Billing is the default.
    range = 6.0,
    maxAmount = 50000,
    reasons = {} -- Invoice presets: { reason = "Service description", amount = 100 }.
}

-- Incident report dropdowns. Add or remove entries to match your department SOPs.
Config.Reports = {
    types = {
        "Structure Fire",
        "Vehicle Fire",
        "Wildfire",
        "Hazmat",
        "Rescue",
        "Alarm",
        "Other"
    },
    statuses = {
        "Active",
        "Contained",
        "Under Investigation",
        "Cleared"
    },
    hazards = {
        "Smoke",
        "Open Flame",
        "Structural Instability",
        "Hazardous Materials",
        "Electrical Hazard",
        "Fuel Leak",
        "Traffic",
        "Confined Space"
    },
    actionsTaken = {
        "Primary Search",
        "Secondary Search",
        "Fire Suppression",
        "Ventilation",
        "Rescue",
        "Medical Assistance",
        "Evacuation",
        "Overhaul",
        "Scene Secured"
    },
    equipmentUsed = {
        "SCBA",
        "Thermal Camera",
        "Attack Line",
        "Supply Line",
        "Foam Line",
        "Hydraulic Rescue Tools",
        "Ladder",
        "Water Monitor",
        "Fire Extinguisher"
    }
}



Config.FireStationBlip = {
    enabled = true,
    name = "Fire Station",
    sprite = 436,
    color = 17,
    scale = 1.0,
}

Config.Interactions = {
    air_refill_station = {
        marker = {
            enabled = true,
            type = 1,
            offset = vector3(0.0, 0.0, 0.0)
        },
        blip = {
            enabled = false,
            sprite = 361,
            color = 1
        },
        npc = {
            enabled = false
        },
        interactionDistance = 1.8
    }
}

Config.FireRadial = {
    enabled = true
}

Config.PlayerCarry = {
    enabled = true,
    maxDistance = 2.5,
    requireOnDuty = true,
    allowSprint = false,
    allowCarrierInVehicle = false,
    carrierAnimation = {
        dict = "missfinale_c2mcs_1",
        name = "fin_c2_mcs_1_camman",
        flag = 49
    },
    passengerAnimation = {
        dict = "nm",
        name = "firemans_carry",
        flag = 33
    },
    attachBone = 0,
    attachOffsets = {
        x = 0.27, y = 0.0, z = 0.63,
        pitch = 0.5, roll = 0.5, yaw = 180.0
    }
}

Config.InteriorExtinguishers = {
    enabled = true,
    item = "WEAPON_FIREEXTINGUISHER",
    label = "",
    requireOnDuty = true,
    noDutyJobs = { "unemployed" },
    interactionDistance = 2.0,
    scanDistance = 12.0,
    restoreDistance = 3.0,
    fullAmmo = 2000,
    pickupDurationMs = 1500,
    restoreDurationMs = 2500,
    emptyMountModel = "sky_fire_exting_mount",
    emptyMountStreamDistance = 100.0,
    emptyMountOffset = {
        x = 0.0,
        y = -0.03,
        z = 0.0
    },
    emptyMountHeadingOffset = 0.0,
    allowedJobs = {}, -- Empty allows every job; requireOnDuty still applies.
    placement = {
        enabled = true,
        item = "fire_extinguisher_mount_kit",
        model = "prop_fire_exting_3a",
        requireOnDuty = true,
        consumeItem = true,
        returnItemOnRemove = true,
        zOffset = 0.0,
        streamDistance = 150.0,
        pickupDistance = 2.5,
        dynamic = false,
        wallPlacement = true,
        wallOffset = 0.01,
        wallHeadingOffset = 0.0,
        allowedJobs = {}
    },
    maintenance = {
        enabled = true,
        requireOnDuty = true,
        allowedJobs = {},
        emptyThresholdPercent = 1.0
    },
    stock = {
        enabled = true,
        allowMountRestock = true,
        storageStationId = "",
        storageGrade = 0,
        extinguisherItem = "WEAPON_FIREEXTINGUISHER",
        extinguisherAmount = 1
    },
    models = {
        "prop_fire_exting_1a",
        "prop_fire_exting_1b",
        "prop_fire_exting_2a",
        "prop_fire_exting_3a"
    }
}

Config.RescueCushion = {
    enabled = true,
    item = "rescue_cushion",
    model = "sky_rescue_cushion",
    label = "Rescue Cushion",
    requireOnDuty = true,
    consumeItem = true,
    returnItemOnRemove = true,
    zOffset = 0.0,
    landingRadius = 3.0,
    landingHeight = 12.0,
    streamDistance = 180.0,
    pickupDistance = 3.0,
    allowedJobs = {}
}

Config.WaterMonitor = {
    enabled = true,
    itemEnabled = true,
    item = "water_monitor",
    commandEnabled = true,
    command = "watermonitor",
    model = "sky_water_monitor",
    label = "Water Monitor",
    requireOnDuty = true,
    consumeItem = true,
    returnItemOnRemove = true,
    zOffset = 0.0,
    streamDistance = 220.0,
    pickupDistance = 3.0,
    interactionDistance = 2.5,
    allowedJobs = {},
    operatingAnimation = {
        enter = {
            dict = "amb@medic@standing@kneel@enter",
            name = "enter",
            durationMs = 1000
        },
        idle = {
            dict = "amb@medic@standing@kneel@idle_a",
            name = "idle_a",
            durationMs = -1
        },
        exit = {
            dict = "amb@medic@standing@kneel@exit",
            name = "exit",
            durationMs = 1000
        }
    },
    stream = {
        range = 75.0,
        minRange = 0.0,
        hitRadius = 12.0,
        waterVelocity = 22.6,
        waterGravityScale = 1.5,
        waterLitersPerSecond = 36.0,
        trajectorySegments = 16,
        progressPerSecond = 32.0
    }
}

Config.HeliBucket = {
    enabled = true,
    itemEnabled = true,
    item = "fire_heli_bucket",
    commandEnabled = true,
    command = "waterbucket",
    model = "sky_fire_heli_bucket",
    label = "Helicopter Bucket",
    allowedJobs = {},
    requireOnDuty = true,
    consumeItem = true,
    returnItemOnRemove = true,
    zOffset = 0.0,
    pickupDistance = 6.0,
    helicopters = {
        "polmav",
        "cargobob",
    },
    requirePilot = true,
    autoAttachOnGround = true,
    groundAttachDistance = 0.25,
    attachDistance = 6.0,
    detachMaxGroundDistance = 2.0,
    ropeLength = 8.0,
    ropeType = 2,
    water = {
        enabled = true,
        capacityLiters = 1300.0,
        fillRateLitersPerSecond = 200.0,
        checkIntervalMs = 250
    },
    dump = {
        enabled = true,
        litersPerSecond = 200.0,
        rayLength = 1000.0,
        hitRadius = 24.0,
        progressPerSecond = 250.0,
        jetScale = 6.0,
        sprayScale = 8.0
    },
    helicopterOffset = {
        default = { x = 0.0, y = 0.0, z = -1.0 },
        polmav = { x = 0.0, y = 0.0, z = -0.7 },
        cargobob = { x = 0.0, y = 0.0, z = -2.0 }
    },
    -- Local rope attachment point on the bucket model.
    bucketOffset = { x = 0.0, y = 0.0, z = 0.0 },
    streamDistance = 2500.0,
    movingStreamDistance = 500.0
}

Config.Hose = {
    nozzleModel = "normal", -- normal | hohlstrahlrohr
    dividing = false, -- Enable the placeable three-way dividing breeching and branch hoses.
    -- "simple" uses the legacy automatic pump behavior; "enhanced" enables the full manual controls.
    pumpPanelStyle = "enhanced",
    pumpControl = {
        minPressure = 50,
        maxPressure = 600,
        pressureStep = 25,
        presetPressure = 300,
        idlePressure = 100,
        idleRpm = 700,
        maxRpm = 3150,
        tankFillLitersPerSecond = 40.0
    },
    performanceMode = "performance",
    propsEnabled = true,
    segmentProp = "sky_hose_segment",
    radius = 0.045,
    propBaseLength = 4.0,
    propBaseRadius = 0.5,
    propLengthRatio = 0.5,
    propRoll = 0.0,
    segmentOverlap = 0.02,
    segmentLength = 0.5,
    addPointDistance = 1.0,
    segmentUpdateDistance = 0.1,
    groundOffset = 0.055,
    groundedNozzleOffset = -0.38,
    hollowNozzleGroundOffset = 0.0,
    groundedNozzleRotation = {
        pitch = 90.0,
        roll = 0.0,
        headingOffset = 90.0
    },
    pumpTargetDistance = 2.0,
    pumpTargetSize = 0.35,
    groundActionAnimation = {
        enabled = true,
        dict = "pickup_object",
        layDownName = "pickup_low",
        pickUpName = "pickup_low",
        durationMs = 1200,
        transitionMs = 650,
        flag = 0
    },
    updateInterval = 50,
    relaxPasses = 1,
    nozzleOffset = {
        x = -0.1,
        y = 0.0,
        z = -0.175
    },
    nozzleExitDirection = {
        x = -1.0,
        y = 0.0,
        z = 0.0
    },
    nozzleExitLength = 0.1,
    nozzleBendDistance = 0.55,
    vehicleOffset = {
        x = -0.85018469737842,
        y = -0.00315706152468,
        z = 0.22376839574426
    },
    vehicleRotation = {
        x = -10.63462514430284,
        y = -10.50662711262703,
        z = -1.41029074788093
    },
    vehicleExitLength = 0.1,
    vehicleBendDistance = 0.55,
    deployDistance = 6.0,
    maxLength = 100.0,
    hydrantConnectDistance = 2.0,
    waterLitersPerSecond = 18.0,
    foamWaterLitersPerSecond = 14.0,
    foamLitersPerSecond = 1.4,
    foamRefill = {
        enabled = true,
        item = "foam_canister",
        liters = 200,
        durationMs = 5000,
        distance = 3.0,
        requireOnDuty = true,
        prop = "xm3_prop_xm3_jerrycan_bl",
        bone = 18905,
        offset = {
            x = 0.11,
            y = 0.0,
            z = 0.25,
            rx = 15.0,
            ry = 170.0,
            rz = 90.42
        },
        anim = {
            dict = "weapon@w_sp_jerrycan",
            name = "fire",
            flag = 49
        }
    },
    -- Prop models used for nearby hydrant connections and streamed map detection.
    hydrants = {
        "prop_fire_hydrant_1",
        "prop_fire_hydrant_2",
        "prop_fire_hydrant_4"
    },
    pump = {
        enabled = true,
        model = "prop_generator_01a",
        connectDistance = 3.0,
        waterProbeDistance = 7.5,
        waterProbeDepth = 6.0,
        intakeExtraLength = 5.0,
        intakeSubmergeDepth = 0.55,
        naturalWaterEnabled = true,
        -- Required server-authoritative allowlist for portable drafting.
        -- Example: { coords = vector3(123.0, 456.0, 7.0), radius = 25.0, zTolerance = 2.0 }
        waterSourceAreas = {
            {
                coords = vector3(1300.0, 4100.0, 30.0),
                radius = 850.0,
                zTolerance = 4.0
            }
        },
        itemEnabled = false,
        itemRequired = false,
        item = "fire_pump"
    },
    vehicleTransfer = {
        enabled = true,
        requireOnDuty = true,
        litersPerSecond = 120.0,
        tickMs = 1000,
        connectDistance = 3.0,
        maxLength = 35.0,
        allowExternalSource = false,
        disconnectWhenSourceEmpty = true,
        disconnectWhenTargetFull = false,
        sourceOffset = {
            x = 0.9,
            y = -0.1,
            z = 0.0,
            directionX = 0.0,
            directionY = -1.0,
            directionZ = 0.0
        },
        targetOffset = {
            x = -0.9,
            y = -0.1,
            z = 0.0,
            directionX = 0.0,
            directionY = -1.0,
            directionZ = 0.0
        }
    },
    vehiclePumpBehavior = {
        enabled = true,
        immobilizeTransferVehicles = true,
        immobilizePumpVehicles = true,
        keepEngineOnWhenAbandoned = true,
        keepEngineOnDuringTransfer = true,
        keepEngineOnDuringPump = true,
        engagementMaxSpeed = 0.5,
        rpmEnabled = true,
        activeRpm = 0.72,
        fuelPercentPerMinute = 2.5,
        ambientTemperature = 25.0,
        overloadWarningLoad = 1.0,
        warningTemperature = 100.0,
        criticalTemperature = 115.0,
        engineDamageEnabled = false, -- Allow pump stress and dry running to damage the vehicle engine.
        damageTemperature = 110.0,
        maxEngineDamagePerSecond = 12.0,
        thermalResponse = 0.04,
        dryRunTemperature = 145.0,
        dryRunDamagePerSecond = 8.0,
        cavitationTemperatureGain = 45.0,
        hydraulics = {
            tankIntakePressure = 35.0,
            tankSupplyGpm = 1200.0,
            hydrantIntakePressure = 150.0,
            hydrantSupplyLitersPerSecond = 100.0,
            pumpIntakePressure = 100.0,
            pumpSupplyGpm = 900.0,
            cavitationStartRatio = 0.85,
            frictionLossPsiPerTenMeters = 10.0
        },
        updateMs = 1000
    },
    vehicles = {
        {
            model = "firetruk",
            label = "Fire Truck",
            x = 0.87584588611499,
            y = 0.15862664906308,
            z = 0.00153079107403,
            rx = -10.63462514430284,
            ry = -10.50662711262703,
            rz = -1.41029074788093,
            pumpPanelConfigured = true,
            pumpPanelX = -0.05274220928549,
            pumpPanelY = 0.11986684054136,
            pumpPanelZ = -0.18809303641319,
            pumpPanelSize = 2.84999999999999,
            hydrantX = 0.89830097118393,
            hydrantY = -0.10419976571573,
            hydrantZ = -0.01111773131415,
            hydrantRx = -10.63462514430284,
            hydrantRy = -10.50662711262703,
            hydrantRz = -1.41029074788093,
            waterTankEnabled = true,
            waterTankSize = 2000,
            foamTankEnabled = true,
            foamTankSize = 200,
            pumpIntakeCount = 2,
            pumpDischargeCount = 3,
            pumpOutlet1Label = "Discharge Rear",
            pumpOutlet1X = -0.57886064052581,
            pumpOutlet1Y = -3.84253191947937,
            pumpOutlet1Z = -0.07665417343378,
            pumpOutlet1Rx = 58.00211928726789,
            pumpOutlet1Ry = -27.15801453155916,
            pumpOutlet1Rz = 6.36408967706901,
            pumpOutlet2Label = "#1 Discharge",
            pumpOutlet2X = 0.87585455179214,
            pumpOutlet2Y = -0.09960932284593,
            pumpOutlet2Z = 0.00153845874592,
            pumpOutlet2Rx = -10.63462539832107,
            pumpOutlet2Ry = -10.50662744231522,
            pumpOutlet2Rz = -1.41029071807861,
            pumpOutlet3Label = "#2 Discharge",
            pumpOutlet3X = 0.87584588611499,
            pumpOutlet3Y = 0.15862664906308,
            pumpOutlet3Z = 0.00153079107403,
            pumpOutlet3Rx = -10.63462514430284,
            pumpOutlet3Ry = -10.50662711262703,
            pumpOutlet3Rz = -1.41029074788093,
            pumpOutlet4Label = "#3 Discharge",
            pumpIntake1Label = "#1 Intake",
            pumpIntake1X = -0.85643655061721,
            pumpIntake1Y = 0.0017159297131,
            pumpIntake1Z = 0.21046194434165,
            pumpIntake1Rx = -10.63462539832107,
            pumpIntake1Ry = -10.50662744231522,
            pumpIntake1Rz = -1.41029071807861,
            pumpIntake2Label = "#2 Intake",
            pumpIntake2X = -0.85583692789077,
            pumpIntake2Y = 0.00366056105121,
            pumpIntake2Z = -0.04687761887907,
            pumpIntake2Rx = -10.63462539832107,
            pumpIntake2Ry = -10.50662744231522,
            pumpIntake2Rz = -1.41029071807861,
            airBottleSlots = 4
        }
    }
}

Config.Jobs = {
    {
        name = "firefighter",
        color = Config.PrimaryColor,
        societyAccount = "society_firefighter",
        offDutyJob = {
            enabled = false,
            job = "off_firefighter"
        },
        shop = {
            { name = "oil_absorbent", label = "Oil Absorbent", price = 35 },
            { name = "broom", label = "Broom", price = 25 },
            { name = "foam_canister", label = "Foam Canister", price = 85 },
            { name = "fire_extinguisher_mount_kit", label = "Fire Extinguisher Mount Kit", price = 250 },
            { name = "rescue_cushion", label = "Rescue Cushion", price = 250 },
            { name = "water_monitor", label = "Water Monitor", price = 750 },
            { name = "fire_heli_bucket", label = "Helicopter Bucket", price = 1500 },
            { name = "lighter", label = "Lighter", price = 15 },
            { name = "fire_air_bottle", label = "SCBA Air Bottle", price = 500 },
            { name = "fire_protective_mask", label = "Wildfire Protective Mask", price = 175 },
            { name = "glas_hammer", label = "Glass Hammer", price = 350 },
            { name = "hydrualic_spreader", label = "Hydraulic Spreader", price = 750 }
        },
        props = {
            { model = "prop_roadcone02a", label = "Traffic Cone" },
            { model = "prop_barrier_work05", label = "Barrier" },
            { model = "v_31a_worklight_03b", label = "Worklight Stand" },
            { model = "prop_worklight_02a", label = "Worklight" }
        },
        vehicles = {
            {
                name = "Fire Truck",
                model = "firetruk",
                price = 75000,
                trunkCapacity = 80,
                garageType = "vehicle",
            }
        }
    }
}

Config.OilSpills = {
    enabled = true,
    deleteOnRestart = true,
    cleanup = {
        requireOnDuty = true,
        allowedJobs = { "mechanic" }, -- Additional jobs allowed to clean oil spills; configured Firejob jobs are always allowed.
        absorbentItem = "oil_absorbent",
        broomItem = "broom",
        consumeAbsorbent = true,
        consumeBroom = false,
        bindDurationMs = 4500,
        sweepDurationMs = 6500,
        absorbentMinigame = {
            enabled = true,
            requiredCoverage = 0.92,
            brushRadius = 42,
            granulesPerMove = 9
        },
        sweepMinigame = {
            enabled = true,
            requiredProgress = 0.98,
            brushRadius = 42,
            minStrokeDistance = 10,
            minUpwardDelta = 8,
            maxSidewaysRatio = 0.55,
            toolWidth = 290
        }
    }
}

Config.VehicleFires = {
    enabled = true,
    manualIgnition = {
        enabled = true,
        requireOnDuty = true,
        requiredJobs = {},
        item = "lighter",
        consumeItem = false,
        maxDistance = 3.0,
        sourceScale = 0.85,
        fireOffset = {
            x = 0.0,
            y = 1.15,
            z = 0.15
        }
    },
    external = {
        enabled = true,
        allowedResources = {
            sky_mechanicjob = true
        }
    },
    explosion = {
        enabled = true,
        delaySeconds = 180,
        removeFire = true
    },
    standaloneAccidents = {
        enabled = true,
        mode = "fallback", -- fallback = only when mechanicjob is not running, always = firejob also detects crashes, disabled = external/mechanic only
        mechanicResources = { "sky_mechanicjob" },
        requireDriver = true,
        ignoreElectric = true,
        allowNpcVehicles = false,
        minImpactSpeedKmh = 85.0,
        minSpeedDropKmh = 38.0,
        minBodyHealthLoss = 110.0,
        minEngineHealthLoss = 130.0,
        forwardMotionRatio = 0.65,
        chance = 0.28,
        cooldownSeconds = 240
    }
}

Config.Lighter = {
    item = "lighter",
    consumeItem = false,
    cooldownSeconds = 3,
    igniteDelaySeconds = 5,
    animationDurationMs = 3000,
    plantAnimation = {
        dict = "anim@amb@drug_field_workers@rake@male_b@idles",
        name = "idle_d",
        flag = 49
    }
}

Config.PropIgnition = {
    enabled = true,
    scanDistance = 12.0,
    scanDurationMs = 15000,
    highlightEnabled = true,
    requireLineOfSight = false,
    maxActiveFires = 25,
    duplicateDistance = 2.5,
    targetMarkerDistance = 20.0,
    targetMarker = {
        enabled = true,
        type = 1,
        scale = {
            x = 0.35,
            y = 0.35,
            z = 0.18
        },
        color = {
            r = 238,
            g = 161,
            b = 37,
            a = 170
        },
        bobUpAndDown = false,
        faceCamera = false,
        rotate = false
    },
    props = {
        {
            model = "prop_bin_05a",
            label = "Trash Bin",
            igniteDistance = 2.0,
            canSpread = true,
            fireType = "normal",
            sourceScale = 0.85,
            zOffset = 0.0
        },
        {
            model = "prop_elecbox_12",
            label = "Electrical Box",
            igniteDistance = 1.8,
            canSpread = false,
            fireType = "electrical",
            sourceScale = 0.72,
            zOffset = 0.1
        },
        {
            model = "prop_barrel_02a",
            label = "Chemical Barrel",
            igniteDistance = 2.0,
            canSpread = true,
            fireType = "chemical",
            sourceScale = 0.95,
            zOffset = 0.05
        }
    }
}

Config.VehicleRescue = {
    enabled = true,
    requireOnDuty = true,
    allowMissionCreatorVehicles = true,
    allowWorldVehicles = true,
    worldVehicleRequiresDamage = true,
    worldVehicleBodyHealthThreshold = 650.0,
    worldVehicleEngineHealthThreshold = 650.0,
    allowEntityStateBag = true,
    entityStateBagKey = "rescueEnabled",
    patientAccessibleAfterAnyDoor = true,
    items = {
        glassHammer = "glas_hammer",
        spreader = "hydrualic_spreader",
        consumeGlassHammer = false,
        consumeSpreader = false
    },
    interaction = {
        requireMatchingGlassForDoor = true,
        glassLabel = "Break window",
        doorLabel = "Force door",
        glassWheelLabel = "%s - Break window",
        doorWheelLabel = "%s - Force door"
    },
    minigames = {
        glass = {
            enabled = true,
            hitPoints = 5,
            requiredHits = 5,
            maxMisses = 4,
            durationMs = 18000,
            perfectZone = 0.16,
            goodZone = 0.28,
            mistakePenalty = 1,
            hammerSwingMs = 820,
            breakWindowOnComplete = true
        },
        spreader = {
            enabled = true,
            phases = 3,
            pumpsRequired = 4,
            minPumpPower = 54.0,
            maxPumpPower = 82.0,
            durationMs = 26000,
            requiredProgress = 100.0,
            progressPerTick = 1.7,
            decayPerTick = 0.42,
            overPressurePenalty = 8.0,
            sweetSpotMin = 42.0,
            sweetSpotMax = 68.0,
            pressureGain = 2.4,
            pressureLoss = 1.15,
            breakDoorOnComplete = true
        }
    },
    playerEntrapment = {
        enabled = true,
        allowOffDuty = true,
        hudEnabled = true,
        doorOverviewEnabled = true,
        preventExit = true,
        releaseOnAnyDoor = false,
        autoReleaseWhenRepaired = true,
        requiredJobs = {},
        repairedBodyHealthThreshold = 920.0,
        repairedEngineHealthThreshold = 850.0,
        repairedMaxRoll = 25.0,
        minBodyHealthLoss = 90.0,
        minEngineHealthLoss = 110.0,
        baseChance = 0.34,
        rolloverMinRoll = 68.0,
        rolloverBonusChance = 0.42,
        cooldownSeconds = 120
    },
    scenarioDefaults = {
        rescueEnabled = true,
        usableGlass = { frontLeft = true, frontRight = true, rearLeft = true, rearRight = true },
        usableDoors = { frontLeft = true, frontRight = true, rearLeft = true, rearRight = true }
    }
}

Config.TrappedPatientRescue = {
    enabled = true,
    requireOnDuty = true,
    requireGlass = true,
    requireDoor = true,
    requireMatchingSide = true,
    allowAnyRemovedDoor = false,
    interactionDistance = 2.2,
    ambulanceDropoffRadius = 3.0,
    extraction = {
        durationMs = 5200,
        allowCarry = true,
        allowDrop = true
    },
    fieldRescue = {
        realisticTypes = {
            forest_injury = true,
            bicycle_accident = true,
            rubble_entrapment = true,
            animal_tree_rescue = true,
            animal_water_rescue = true,
            animal_entrapment = true
        }
    }
}

Config.FireScenarioCreator = {
    randomTrigger = {
        enabled = false,
        -- "rotation" uses every eligible mission before repeating; "random" allows repeats.
        -- Rotation history resets when this resource restarts. Failed starts do not count.
        selectionMode = "rotation",
        intervalMinutes = { min = 30, max = 60 },
        chance = 0.35,
        jobs = {},
        -- Mission entries support: key, enabled, minOnDuty, jobs, and dispatchJobs.
        -- An empty dispatchJobs list uses the global dispatch.jobs targets below.
        missions = {}
    },
    dispatch = {
        enabled = true,
        jobs = {}
    }
}

Config.SocietyRewards = {
    fire = {
        enabled = true,
        scenarioEnabled = true,
        jobs = {}
    },
    oil = {
        enabled = true,
        scenarioEnabled = true,
        jobs = {}
    },
    tree = {
        enabled = true,
        scenarioEnabled = true,
        jobs = {}
    },
    rescue = {
        enabled = true,
        scenarioEnabled = true,
        jobs = {}
    }
}

Config.TreeIncident = {
    enabled = true,
    -- Fallen tree model and the distance at which its networked prop is created.
    propModel = "prop_w_r_cedar_dead",
    spawnRange = 200.0,
    requireOnDuty = true,
    interactionDistance = 2.5,
    -- Local offset on the tree model where the saw interaction and marker appear.
    interactionOffset = { x = 0.0, y = 0.0, z = 1.1 },
    blip = {
        sprite = 500,
        scale = 0.95,
        color = 60,
        label = "Fallen Tree"
    },
    marker = {
        type = 1,
        size = 1.6,
        height = 1.0,
        r = 240,
        g = 120,
        b = 40,
        a = 120
    },
    dispatch = {
        enabled = true,
        jobs = {}
    },
    stages = {
        sawing = {
            sections = 3,
            prop = "sky_chainsaw",
            propBone = 57005,
            propOffset = { x = 0.12, y = 0.03, z = -0.02, rx = 88.0, ry = 2.0, rz = 190.0 },
            propAttach = { useSoftPinning = true, collision = false, isPed = true, rotationOrder = 2, syncRot = true },
            anim = { dict = "anim@heists@fleeca_bank@drilling", name = "drill_straight_end", flag = 51 }
        },
        clearing = {
            pieces = 3,
            pieceModel = "sky_log",
            pieceSpacing = 1.6,
            pickupDistance = 2.0,
            carryMoveBlend = 1.0,
            prop = "sky_log",
            propBone = 28422,
            propOffset = { x = 0.0, y = 0.0, z = 0.05, rx = 90.0, ry = 0.0, rz = 0.0 },
            anim = { dict = "anim@heists@box_carry@", name = "idle", flag = 49 },
            dropZone = {
                -- Local offset from the tree: X sideways, Y along its heading, Z vertical.
                offset = { x = 0.0, y = 8.0, z = 0.0 },
                radius = 2.25,
                cleanupRadius = 150.0,
                marker = { type = 1, height = 1.0, r = 120, g = 200, b = 80, a = 110 }
            }
        }
    }
}

Config.FireSystem = {
    syncDistance = 1000.0,
    -- With UseJobConfigurator enabled, manage these under /jobconfig > Fire > Weapon fires.
    molotovIgnition = {
        enabled = false, -- Enable after configuring the fire department and extinguishing equipment.
        weapons = { "WEAPON_MOLOTOV" } -- Weapon names allowed to create Sky fires; {} allows none.
    },
    dispatch = {
        enabled = true,
        jobs = {}
    },
    render = {
        -- Visual distance in meters. Smoke may remain visible farther away than flames.
        -- With UseJobConfigurator enabled, /jobconfig's visibility setting controls both.
        flameDistance = 1000.0,
        smokeDistance = 1000.0,
        flameScaleMultiplier = 1.0,
        smokeScaleMultiplier = 1.0,
        smokeDensityMultiplier = 1.0, -- Visual opacity multiplier; does not change smoke hazards.
        smokeWindResponse = "normal", -- Packaged smoke: none, gentle, normal, strong. Follows world wind.
        sharedSmoke = {
            maxGroupDistance = 5.0,
            scalePerAdditionalFlame = 0.12,
            maxScaleMultiplier = 3.0
        }
    },
    burnDecals = {
        -- Live marks build from faint to fully visible while a flame keeps burning.
        activeInitialOpacity = 0.18,
        activeFadeSeconds = 45,
        activeRefreshInterval = 10000,
        activeNativeLifetimeSeconds = 30,
        -- Burned surfaces remain for five minutes and fade during the final minute.
        burnedOutLifetimeSeconds = 300,
        burnedOutFadeSeconds = 60,
        burnedOutRefreshInterval = 10000,
        burnedOutNativeLifetimeSeconds = 30
    },
    extinguish = {
        feedback = {
            enabled = true,
            minScale = 0.018,
            maxScale = 0.036,
            height = 0.12,
            alpha = 210
        }
    },
    effects = {
        sounds = {
            fireAmbient = {
                enabled = true,
                volume = 0.65, -- Master volume for positional fire loops (0 = silent, 1 = full).
                range = 40.0 -- Audible distance in meters; direction follows the camera.
            },
            fireFlare = {
                enabled = true,
                volume = 0.5,
                range = 10.0
            },
            chainsaw = {
                enabled = true,
                volume = 0.65,
                range = 10.0
            }
        }
    },
    ignition = {
        startScale = 0.2, -- Default initial flame size in /skyfiremenu, relative to its full profile size.
        growthSeconds = 40.0 -- Time for a newly placed menu fire to reach its full size.
    },
    reignition = {
        enabled = true,
        chancePercent = 10.0, -- Percent chance that an extinguished combustible flame reignites.
        delaySeconds = 6.0,
        startScale = 0.22,
        growthPerSecond = 0.12,
        extinguishRequiredPercent = 50.0, -- Reignited flames are fully extinguished after this percent of normal extinguish progress.
        finalExtinguishHoldSeconds = 5.0, -- Seconds you must keep extinguishing after full progress before a reignited flame is finally out.
        nearImpactTolerance = 0.65, -- Extra hit tolerance in meters for nearly hitting a reignited mini flame.
        nearImpactAccuracy = 0.12, -- Accuracy applied when only the impact is close to a reignited mini flame.
        growthTickMs = 1000
    },
    protectiveGear = {
        enabled = true,
        breathing = {
            smokeExposureMultiplier = 0.0,
            toxicSmokeExposureMultiplier = 0.25,
            maskOverlay = {
                enabled = false,
                forceFirstPerson = true
            },
            air = {
                enabled = true,
                capacitySeconds = 1200,
                pressureBar = 300,
                idleConsumption = 0.65,
                smokeConsumption = 1.0,
                toxicConsumption = 1.35,
                heatConsumption = 1.15,
                runningConsumption = 1.9,
                sprintingConsumption = 2.7,
                jumpingConsumption = 1.4,
                lowPercent = 30,
                criticalPercent = 12,
                hudUpdateInterval = 500,
                item = {
                    enabled = true,
                    name = "fire_air_bottle",
                    savePressure = false, -- Requires an inventory with item metadata support.
                    saveInterval = 60000
                },
                refill = {
                    -- Refill stations require item.enabled and item.savePressure (metadata support).
                    -- Place station points via the fire creator ("SCBA refill station").
                    enabled = true,
                    fillRateBarPerSecond = 10.0,
                    stationRange = 5.0
                }
            },
            protectiveMask = {
                enabled = true,
                smokeExposureMultiplier = 0.15,
                toxicSmokeExposureMultiplier = 0.85,
                maskOverlay = {
                    enabled = false,
                    forceFirstPerson = false
                },
                item = {
                    enabled = true,
                    name = "fire_protective_mask"
                },
                requiredComponents = {
                    { component = 1, gearKey = "mask", label = "wildfire protective mask", drawable = 46, texture = 0 }
                },
                femaleRequiredComponents = {
                    { component = 1, gearKey = "mask", label = "wildfire protective mask", drawable = 46, texture = 0 }
                }
            },
            requiredComponents = {
                { component = 1, gearKey = "mask", label = "breathing mask", drawable = 0, texture = 0 },
                { component = 5, gearKey = "other", label = "air tank", drawable = 48, texture = 0 },
                { component = 7, gearKey = "other", label = "breathing harness", drawable = 45, texture = 0 }
            },
            femaleRequiredComponents = {
                { component = 1, gearKey = "mask", label = "breathing mask", drawable = 0, texture = 0 },
                { component = 5, gearKey = "other", label = "air tank", drawable = 48, texture = 0 },
                { component = 7, gearKey = "other", label = "breathing harness", drawable = 32, texture = 0 }
            }
        },
        heat = {
            damageMultiplier = 0.35,
            burnDurationMultiplier = 0.45,
            ignite = false,
            requiredComponents = {
                { component = 3, gearKey = "top", label = "firefighter arms", drawable = 96, texture = 0 },
                { component = 4, gearKey = "pants", label = "firefighter pants", drawable = 43, texture = 0 },
                { component = 6, gearKey = "shoes", label = "firefighter boots", drawable = 13, texture = 0 },
                { component = 8, gearKey = "top", label = "firefighter undershirt", drawable = 68, texture = 0 },
                { component = 9, gearKey = "top", label = "firefighter vest", drawable = 0, texture = 0 },
                { component = 10, gearKey = "other", label = "firefighter decals", drawable = 16, texture = 0 },
                { component = 11, gearKey = "top", label = "firefighter jacket", drawable = 77, texture = 0 }
            },
            requiredProps = {
                { prop = 0, gearKey = "helmet", label = "firefighter helmet", drawable = 45, texture = 0 }
            },
            femaleRequiredComponents = {
                { component = 3, gearKey = "top", label = "firefighter arms", drawable = 111, texture = 0 },
                { component = 4, gearKey = "pants", label = "firefighter pants", drawable = 42, texture = 0 },
                { component = 6, gearKey = "shoes", label = "firefighter boots", drawable = 13, texture = 0 },
                { component = 8, gearKey = "top", label = "firefighter undershirt", drawable = 44, texture = 0 },
                { component = 9, gearKey = "top", label = "firefighter vest", drawable = 0, texture = 0 },
                { component = 10, gearKey = "other", label = "firefighter decals", drawable = 15, texture = 0 },
                { component = 11, gearKey = "top", label = "firefighter jacket", drawable = 70, texture = 0 }
            },
            femaleRequiredProps = {
                { prop = 0, gearKey = "helmet", label = "firefighter helmet", drawable = 44, texture = 0 }
            }
        }
    },
    npcReactions = {
        enabled = true,
        panicEnabled = true,
        filmEnabled = true,
        updateInterval = 2000,
        reactionRadius = 35.0,
        panicRadius = 18.0,
        filmRadius = 28.0,
        fleeDistance = 55.0,
        maxTrackedPeds = 6,
        filmChance = 0.35,
        reactionDurationMs = 15000,
        cooldownMs = 30000
    },
    materials = {
        vehicle_fuel = {
            -- Set any source to false to block it completely for vehicle fuel fires.
            -- water = hose/nozzle, firetruck cannon and helicopter bucket; water_monitor = portable Water Monitor.
            allowedExtinguishAgents = { water = true, foam = true, water_monitor = false, extinguisher = true },
            waterEffectiveness = 0.65,
            foamEffectiveness = 1.35,
            waterReaction = { enabled = false }
        }
    }
}
