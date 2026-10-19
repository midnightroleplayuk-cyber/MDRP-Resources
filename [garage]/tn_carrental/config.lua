Config = {}

-- Detected automatically; set explicitly if auto-detection causes issues.
Config.Framework   = 'auto'      -- auto | esx | qb | qbox | standalone
Config.Inventory   = 'auto'      -- auto | ox_inventory | qb | none
Config.Target      = 'auto'      -- auto | ox_target | qb-target | qtarget | none
Config.VehicleKeys = 'Renewed-Vehiclekeys'      -- auto | none | qb-vehiclekeys | qbx_vehiclekeys | qs-vehiclekeys | cd_garage | wasabi_carlock | Renewed-Vehiclekeys | t1ger_keys | mk_vehiclekeys | xd_locksystem | VehicleKeyChain

Config.Locale            = 'en'            -- Locale file to load: de or en
Config.Currency          = '£'             -- Currency symbol shown in the UI
Config.RentalPaperItem   = 'rental_paper'  -- Inventory item name for the rental paper

-- Fraction of the deposit that is refunded on vehicle return.
-- The actual refund is scaled by vehicle condition (engine + body health).
-- Example: 0.25 means up to 25 % of the deposit is returned.
Config.ReturnRefundPercent = 0.25

-- Amount deducted from the player's account for every full minute past the rental end time.
Config.OverdueChargePerMinute = 50

-- Seconds the player may remain outside the rental vehicle before the rental is
-- automatically ended and the vehicle deleted. Set to 0 to disable this feature.
Config.OutOfVehicleTimeout = 300

-- If false, the rental vehicle spawns nearby and the player must enter manually.
Config.SpawnPlayerInsideVehicle = false

-- Radius in metres within which the player can trigger a vehicle return.
Config.MinReturnDistance = 8.0

-- Show permanent blips for rental stations on the minimap.
Config.ShowBlips = true

-- Blip appearance. GTA/FiveM sprite and colour ids can be changed here.
Config.Blips = {
    rental = {
        sprite = 225,
        color = 38,
        scale = 0.72,
        display = 4
    },
    returnStation = {
        sprite = 524,
        color = 2,
        scale = 0.62,
        display = 4
    }
}

-- Maps payment methods to framework money accounts.
Config.PaymentAccounts = {
    cash   = 'money',
    card   = 'bank',
    refund = 'bank'
}

-- Each style defines a brand identity for one rental company.
-- Assign a style to a station via the uiStyle field in Config.RentalStations.
Config.UIStyles = {
    escalera = {
        label      = 'Escalera',
        subtitle   = 'Rent-A-Car',
        accent     = '#a842c2',
        accentText = '#111111',
        logo       = 'Escalera',
        logoImage  = 'img/logos/escaleralogo.png',
        watermark  = 'E'
    },
    touchdown = {
        label      = 'Midnight Rentals',
        subtitle   = 'Car Rentals',
        accent     = '#9434e2',
        accentText = '#ffffff',
        logo       = 'Midnight',
        logoImage  = 'img/logos/touchdownlogo.png',
        watermark  = 'TD'
    },
    jiff = {
        label      = 'JiffiRent',
        subtitle   = 'See San Andreas in a Jiffi',
        accent     = '#f39b21',
        accentText = '#111111',
        logo       = 'JiffiRent',
        logoImage  = 'img/logos/jiffirentlogo.png',
        watermark  = 'JR'
    },
    olymp = {
        label      = 'Olympian Rentals',
        subtitle   = 'Airport Vehicle Hire',
        accent     = '#16834a',
        accentText = '#ffffff',
        logo       = 'Olympian',
        logoImage  = 'img/logos/olympianrentalslogo.png',
        watermark  = 'OL'
    }
}

-- Each station needs a unique id, a display label, a uiStyle (see above),
-- world coordinates for the NPC (coords) and the vehicle spawn point (spawn).
-- vehicles is optional. If omitted, the station uses every entry from Config.Vehicles.
-- You can use model names from Config.Vehicles or full vehicle override tables.
Config.RentalStations = {
    {
        id       = 'airport',
        label    = 'Airport Rental',
        uiStyle  = 'touchdown',
        coords   = vec4(-835.87, -2347.09, 14.69, 182.67),
        spawn    = vec4(-823.86, -2342.91, 14.57, 144.53),
        vehicles = { 'blista', 'sultan', 'baller2', 'faggio', 'faggio2', 'asea' },
        ped = {
            model    = 's_m_m_highsec_01',
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        }
    },
    {
        id       = 'city',
        label    = 'City Rental',
        uiStyle  = 'touchdown',
        coords   = vec4(-282.71, -887.25, 32.08, 69.26),
        spawn    = vec4(-285.46, -887.41, 31.08, 167.33),
        vehicles = { 'blista', 'sultan', 'asea' },
        ped = {
            model    = 's_f_y_airhostess_01',
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        }
    },
    {
        id       = 'Sandy Rental',
        label    = 'City Rental',
        uiStyle  = 'touchdown',
        coords   = vec4(1604.61, 3526.2, 37.24, 109.63),
        spawn    = vec4(1599.38, 3521.23, 35.98, 32.23),
        vehicles = { 'blista', 'sultan', 'baller2', 'faggio', 'faggio2', 'asea' },
        ped = {
            model    = 's_f_y_airhostess_01',
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        }
    }
}

-- Locations where players can return a rental vehicle.
-- Blips and markers are only shown while the player has an active rental.
Config.ReturnStations = {
    {
        id     = 'airport_return',
        label  = 'Airport Return',
        coords = vec3(-826.74, -2333.42, 14.57), vec3(-296.57, -885.98, 31.08)
    },
    {
        id     = 'city_return',
        label  = 'City Return',
        coords = vec3(-296.57, -885.98, 31.08), vec3(-826.74, -2333.42, 14.57)
    }
}

-- priceMultiplier is applied to a vehicle's basePrice to calculate the rental rate.
-- The deposit is always added on top of the rental rate.
Config.RentalDurations = {
    { label = '15 Minutes', minutes = 15,  priceMultiplier = 1.0 },
    { label = '30 Minutes', minutes = 30,  priceMultiplier = 1.8 },
    { label = '1 Hour',     minutes = 60,  priceMultiplier = 3.2 },
    { label = '2 Hours',    minutes = 120, priceMultiplier = 5.7 }
}

-- image paths are relative to the html/ folder.
-- Place vehicle images in html/img/vehicles/ (PNG, JPG or WEBP).
-- accent sets the highlight colour on the vehicle card in the UI.
Config.Vehicles = {
    {
        label     = 'Blista Compact',
        model     = 'blista',
        image     = 'img/vehicles/blista.png',
        category  = 'Compact',
        seats     = 4,
        deposit   = 150,
        basePrice = 250
    },
    {
        label     = 'Sultan',
        model     = 'sultan',
        image     = 'img/vehicles/sultan.png',
        category  = 'Sport',
        seats     = 4,
        deposit   = 350,
        basePrice = 600
    },
    {
        label     = 'Baller',
        model     = 'baller2',
        image     = 'img/vehicles/baller2.png',
        category  = 'SUV',
        seats     = 4,
        deposit   = 500,
        basePrice = 850
    },
    {
        label     = 'Faggio Sport',
        model     = 'faggio',
        image     = 'img/vehicles/faggiosport.png',
        category  = 'Motorcycle',
        seats     = 1,
        deposit   = 75,
        basePrice = 100
    },
    {
        label     = 'Faggio',
        model     = 'faggio2',
        image     = 'img/vehicles/faggio.png',
        category  = 'Motorcycle',
        seats     = 1,
        deposit   = 40,
        basePrice = 75
    },
    {
        label     = 'Asea',
        model     = 'asea',
        image     = 'img/vehicles/asea.png',
        category  = 'Sedan',
        seats     = 4,
        deposit   = 140,
        basePrice = 230
    }
}
