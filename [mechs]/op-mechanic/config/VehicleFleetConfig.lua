Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Mechanic fleet store + garage
-- Garage script -> Config.GarageScript (MainConfig)
-- ──────────────────────────────────────────────────────────────────────────────
Config.VehicleFleet = {
    storeEnabled = true,
    garageEnabled = true,

    resellPercent = 50,

    garageInteractRadius = 2.5,
    garageStoreRadius = 12.0,

    catalog = {
        {
            model = 'rumpo',
            label = 'Rumpo',
            desc = 'Workshop van - parts & tools.',
            price = 35000,
            resellPrice = 15000,
            image = 'https://data.otherplanet.dev/mechanic/cars/rumpo.png',
        },
        {
            model = 'bison',
            label = 'Bison',
            desc = 'Pickup for roadside jobs.',
            price = 42000,
            resellPrice = 18000,
            image = 'https://data.otherplanet.dev/mechanic/cars/bison.png',
        },
        {
            model = 'towtruck',
            label = 'Towtruck',
            desc = 'Standard recovery truck.',
            price = 55000,
            resellPrice = 22000,
            image = 'https://data.otherplanet.dev/mechanic/cars/towtruck.png',
        },
        {
            model = 'towtruck2',
            label = 'Towtruck (Yanker)',
            desc = 'Heavy recovery truck.',
            price = 65000,
            resellPrice = 26000,
            image = 'https://data.otherplanet.dev/mechanic/cars/towtruck2.png',
        },
        {
            model = 'flatbed3',
            label = 'Flatbed (MTL)',
            desc = 'Advanced ramp.',
            price = 72000,
            resellPrice = 30000,
            image = 'https://data.otherplanet.dev/mechanic/cars/flatbed.png',
        },
    },

    catalogByJob = {},
}