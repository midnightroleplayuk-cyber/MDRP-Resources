Config.Drugs = {
    enabled     = true,
    gangOnly    = true,   -- only gang members can deal
    onlyInAreas = true,   -- deals only happen inside an area (where they earn influence)

    -- What can be sold. item = your inventory item name (see install/ for the defaults).
    -- price = paid per unit (random in the range, before area and market adjustments). max = most bought at once.
    -- enterprise = the business type that can bag up stock into this item (Business tab), and whose market events affect it.
    items = {
        { item = 'weed_bag', label = 'weed',    price = { 90, 140 },  max = 3, enterprise = 'weed' },
        { item = 'coke_bag', label = 'cocaine', price = { 240, 340 }, max = 2, enterprise = 'coke' },
        { item = 'meth_bag', label = 'meth',    price = { 180, 260 }, max = 2 },
    },

    -- Payment: 'cash' or 'bank' to the dealer. gangCut = share that goes to the gang's dirty treasury instead.
    moneyType = 'cash',
    gangCut   = 0.0,

    -- Odds (0 to 1). Buyers are likelier on your own turf, less likely on a rival's.
    accept         = 0.65,
    ownArea        = 0.10,  -- added on your gang's turf
    rivalArea      = -0.15, -- added on another gang's turf
    saturation     = 30,    -- sales in an area in an hour before buyers dry up (acceptance and prices halve at this many)
    police         = 0.10,  -- chance someone calls the police after a sale (doubled by a police crackdown)
    policeRival    = 0.05,  -- added on a rival's turf
    snitch         = 0.25,  -- chance a buyer who says no calls the police
    undercover     = 0.03,  -- chance the buyer is an undercover officer
    undercoverHeat = 10,

    cooldown       = 6,     -- seconds between offers per player
    maxPerHour     = 80,    -- deals per player per hour
    dealTime       = 3000,  -- ms of haggling before the outcome
    turfNotice     = 300,   -- seconds between "someone's dealing on your turf" notices to a gang
}
