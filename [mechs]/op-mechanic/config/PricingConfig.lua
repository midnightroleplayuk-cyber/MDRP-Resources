Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Tuning prices (flat per option)
-- ──────────────────────────────────────────────────────────────────────────────
Config.Pricing = {
    -- Base vehicle value for byModel mode = 'vehicleValue'
    -- multiplier = vehiclePrice / scaleReferencePrice
    scaleReferencePrice = 50000,

    defaults = {
        labor = 150,
        variant = 500,
        toggle = 250,
        color = 350,
        repairEngine = 800,
        repairBody = 600,
        repairWash = 200,
        repairFull = 1200,
    },

    performance = {
        engine = { 0, 2500, 5000, 8500, 12000 },
        brakes = { 0, 1500, 3000, 4500 },
        transmission = { 0, 2000, 4000, 6500 },
        suspension = { 0, 1200, 2400, 3800, 5200 },
        armor = { 0, 2000, 4000, 6500, 9000, 12000 },
        turbo = 7500,
    },

    body = {
        spoiler = 900,
        frontBumper = 1100,
        rearBumper = 1100,
        sideSkirt = 800,
        exhaust = 950,
        frame = 1300,
        grille = 700,
        hood = 1000,
        fender = 850,
        rightFender = 850,
        roof = 900,
        trunk = 750,
        archCover = 700,
        aerials = 400,
        windows = 650,
        engineBlock = 1200,
        airFilter = 550,
        struts = 700,
        tank = 600,
        lightBar = 950,
        livery = 800,
        plate = 250,
        windowTint = 600,
        horn = 450,
    },

    wheels = {
        category = 0,
        model = 1200,
        color = 400,
        tireSmoke = 600,
        customTires = 500,
        bulletproof = 3500,
        size = 250,
        width = 250,
        offset = 250,
    },

    paint = {
        primary = 800,
        secondary = 700,
        pearlescent = 600,
        wheel = 400,
        dashboard = 450,
        interior = 450,
        finish = 300,
    },

    lights = {
        xenon = 1200,
        xenonColor = 350,
        neonSide = 400,
        neonColor = 500,
    },

    interior = {
        trimA = 650,
        trimB = 500,
        ornaments = 500,
        dashboard = 600,
        dial = 450,
        doorSpeaker = 400,
        seats = 900,
        steeringWheel = 700,
        shifterLeavers = 450,
        aPlate = 400,
        speakers = 550,
    },

    extras = {
        extra = 300,
        hydraulics = 4500,
    },

    nitro = {
        kit = 8500,
    },

    rgb = {
        controller = 6500,
    },

    tuning = {
        engine = 28000,
        tires = 12000,
        brakes = 16000,
        drivetrain = 32000,
        antilag = {
            backfire = 4500,
            nitro = 6500,
            combo = 8500,
            torch = 9500,
        },
        antilagChance = 750,
        antilagSize = 900,
        antilagColor = 1200,
        antilagSound = 1000,
    },

    stance = {
        height = 200,
        camber = 200,
        width = 200,
        offset = 200,
        size = 250,
    },

    -- ──────────────────────────────────────────────────────────────────────────
    -- Per model (spawn / display name, lowercase)
    -- mode = 'advanced'     → deep-merge overrides below onto global prices
    -- mode = 'vehicleValue' → scale all prices by vehiclePrice / scaleReferencePrice
    -- optional: labor (fixed labor), multiplier (manual scale instead of vehiclePrice)
    -- ──────────────────────────────────────────────────────────────────────────
    byModel = {
        -- adder = {
        --     mode = 'advanced',
        --     defaults = { labor = 400 },
        --     performance = { turbo = 25000, engine = { 0, 8000, 16000, 28000, 40000 } },
        --     body = { spoiler = 3500 },
        -- },
        -- sultan = {
        --     mode = 'vehicleValue',
        --     vehiclePrice = 35000,
        -- },
    },
}