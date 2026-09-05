Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Parts Order (tablet wholesale). Catalog/prices -> Config.Parts.catalog
-- ──────────────────────────────────────────────────────────────────────────────
Config.PartsOrder = {
    enabled = true,
    courier = {
        baseFee = 100,
        feePerPart = 40,
        etaMin = 8, -- minutes
        etaMax = 15,
    },
    warehouses = {
        {
            id = 'ls',
            label = 'Los Santos',
            discountPercent = 0,
            coords = vector3(1175.0, -3200.0, 6.0),
        },
        {
            id = 'sandy',
            label = 'Sandy Shores',
            discountPercent = 5,
            coords = vector3(1737.0, 3709.0, 34.0),
        },
        {
            id = 'paleto',
            label = 'Paleto Bay',
            discountPercent = 10,
            coords = vector3(90.0, 6335.0, 31.0),
        },
    },
    pickup = {
        requireInVehicle = true,
        requireDriver = true,
        deliverTo = 'trunk', -- trunk | player
        debug = false,
        claimRadius = 12.0,
        interactDistance = 2.5,
        blip = {
            sprite = 478,
            color = 5,
            scale = 0.9,
            shortRange = false,
            route = true,
        },
        vehicles = {
            { model = 'rumpo', class = 12 },
            { model = 'rumpo3', class = 12 },
            { model = 'burrito', class = 12 },
            { model = 'burrito3', class = 12 },
            { model = 'speedo', class = 12 },
            { model = 'speedo4', class = 12 },
            { model = 'youga', class = 12 },
            { model = 'youga2', class = 12 },
            { model = 'youga3', class = 12 },
            { model = 'pony', class = 12 },
            { model = 'minivan', class = 12 },
            { model = 'minivan2', class = 12 },
            { model = 'boxville', class = 12 },
            { model = 'boxville2', class = 12 },
            { model = 'boxville3', class = 12 },
            { model = 'boxville4', class = 12 },
            { model = 'mule', class = 20 },
            { model = 'mule2', class = 20 },
            { model = 'mule3', class = 20 },
            { model = 'mule4', class = 20 },
            { model = 'benson', class = 20 },
            { model = 'pounder', class = 20 },
            { model = 'pounder2', class = 20 },
            { model = 'tiptruck', class = 10 },
            { model = 'tiptruck2', class = 10 },
            { model = 'rubble', class = 10 },
            { model = 'mixer', class = 10 },
            { model = 'mixer2', class = 10 },
            { model = 'utillitruck', class = 11 },
            { model = 'utillitruck2', class = 11 },
            { model = 'utillitruck3', class = 11 },
        },
        classCapacity = {
            [10] = 60,
            [11] = 35,
            [12] = 40,
            [20] = 80,
        },
        defaultCapacity = 0,
    },
}