-- Hex territory: San Andreas is a honeycomb of hexes, and the hexes a gang holds are its turf. Tags, rackets,
-- dealing, street events, gang tiers and the maps all work on them.
-- Staff place each gang's starting hexes in game (/gangadmin > Gangs > a gang > Turf) and set the
-- numbers below in game too (/gangadmin > Turf); this file is the starting point.
Config.Hexes = {
    size   = 150.0,                  -- metres from a hex's centre to a corner
    origin = { x = 0.0, y = 0.0 },   -- where the grid is anchored

    -- Changing size or origin after gangs hold turf: on the next start, existing turf is moved onto the new grid
    -- in the same place. 'centre' = each old hex becomes the one new hex at its centre (gangs keep the same number
    -- of hexes); 'fill' = each old hex becomes every new hex inside it (gangs keep the same ground, as more hexes).
    onResize = 'centre',

    startHexes = 2,     -- hexes staff give a new gang (its compound); the first is the main hex
    protectCompound = true, -- compound hexes can drop to 0% but are never lost

    -- Control (0 to 100%)
    -- Selling these on your own hex builds control (must match your item names). Each can have its own rate:
    -- { item = 'weed_og_kush', perUnit = 0.5 }; a plain name uses controlPerSale. Also changeable in /gangadmin > Turf.
    turfDrugs      = { 'weed_og_kush' },
    anyDrugCounts  = false,              -- true = any drug sold on your own hex builds control
    controlPerSale = 1.5,  -- % per unit of a turf drug sold on your own hex
    rivalLoss      = 2.0,  -- % a hex loses per unit of any drug a rival gang sells on it
    decayPerHour   = 4.0,  -- % every hex loses per hour
    decayOnlyOnline = true, -- only while at least one member of that gang is online (rivals dealing there still costs control)
    startControl   = 10.0, -- % a newly bought hex starts at

    -- Expanding: buy a hex touching one of yours that's at expandAt % or more
    expandAt = 100.0,
    expandCost = {
        money = 50000, account = 'dirty',            -- from the gang treasury
        item = 'weed_og_kush', count = 50,            -- from the buyer's own pockets (false for none)
    },

    -- Tags: the first goes on the main hex; one more tag for every sprayEvery hexes held
    sprayEvery = 3,

    -- Rivals' hexes stay hidden until your gang deals on one; then it shows on your tablet and map.
    revealDays = 0, -- 0 = stays revealed until it changes hands; otherwise forgotten after this many days

    -- Names for hexes: each takes the name of the nearest of these
    districts = {
        { 'Davis', 100, -1700 }, { 'Strawberry', -150, -1400 }, { 'Chamberlain Hills', -170, -1640 }, { 'Rancho', 430, -1800 },
        { 'La Mesa', 800, -1100 }, { 'Cypress Flats', 900, -2200 }, { 'Elysian Island', 100, -2700 }, { 'Terminal', 900, -3000 },
        { 'LSIA', -1200, -2800 }, { 'La Puerta', -700, -1500 }, { 'Vespucci', -1200, -1300 }, { 'Vespucci Canals', -1050, -1000 },
        { 'Del Perro', -1550, -650 }, { 'Little Seoul', -700, -900 }, { 'Pillbox Hill', 150, -900 }, { 'Mission Row', 400, -1000 },
        { 'Textile City', 400, -750 }, { 'Burton', -450, -200 }, { 'Rockford Hills', -800, -200 }, { 'Richman', -1500, 200 },
        { 'West Vinewood', -200, 150 }, { 'Downtown Vinewood', 300, 200 }, { 'East Vinewood', 900, -200 }, { 'Mirror Park', 1150, -550 },
        { 'Murrieta Heights', 1200, -1400 }, { 'El Burro Heights', 1400, -1800 }, { 'Vinewood Hills', 0, 800 }, { 'Pacific Bluffs', -1900, 600 },
        { 'Banham Canyon', -2900, 500 }, { 'Chumash', -3200, 1000 }, { 'Tongva Hills', -1700, 2000 }, { 'Lago Zancudo', -2300, 2700 },
        { 'Great Chaparral', -300, 2400 }, { 'Harmony', 500, 2700 }, { 'Grand Senora Desert', 1500, 3000 }, { 'Sandy Shores', 1800, 3700 },
        { 'Alamo Sea', 900, 4000 }, { 'Grapeseed', 2000, 4800 }, { 'Mount Chiliad', 500, 5500 }, { 'Paleto Forest', -500, 5300 },
        { 'Paleto Bay', -200, 6300 }, { 'Tataviam Mountains', 1800, 0 }, { 'Palomino Highlands', 2300, -500 },
    },
}
