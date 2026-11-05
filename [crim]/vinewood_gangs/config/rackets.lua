Config.Rackets = {
    collectMinutes   = 60,   -- each business adds its income to what it owes this often
    maxOwedPeriods   = 3,    -- owed money stops building after this many periods
    lapsePeriods     = 6,    -- nobody collects for this long and the business stops paying
    minInfluence     = 25,   -- influence your gang needs in the area before owners will listen
    dropBelow        = 10,   -- below this the business drops your protection
    cooldownMinutes  = 60,   -- after a refusal, your gang can't ask that business again for this long

    -- Chance the owner agrees: base, plus influence, plus holding the area, plus leaning on them
    odds = {
        base        = 0.20,
        influence   = 0.35,  -- added in full at the capture threshold, scaled below it
        holdsArea   = 0.20,
        intimidate  = 0.15,
        rival       = -0.25, -- the business is already paying another gang
        min = 0.05, max = 0.90,
    },
    takeoverNeedsLead = true, -- to take a business off a rival, you need more influence there than they have

    policeOnRefusal   = 0.30, -- owner calls the police after turning you down
    policeIntimidate  = 0.25, -- added when you leaned on them
    reportOnCollect   = 0.05, -- owner quietly reports a collection

    talkTime    = 5000,
    collectTime = 4000,

    -- The point is where a member stands to talk to the owner (the counter). income = what the business adds to
    -- its owed money each period. Shops only work inside an area. Add more in game: /gangadmin > Rackets.
    businesses = {
        -- Los Santos
        { key = 'ltd_grove',         label = 'LTD Gasoline, Grove Street',    income = 450, coords = vec3(-47.2, -1758.6, 29.4) },
        { key = '247_innocence',     label = '24/7, Innocence Boulevard',     income = 400, coords = vec3(25.7, -1347.3, 29.5) },
        { key = 'herr_kutz_davis',   label = 'Herr Kutz, Davis',              income = 300, coords = vec3(136.8, -1708.4, 29.3) },
        { key = 'discount_straw',    label = 'Discount Store, Strawberry',    income = 350, coords = vec3(75.3, -1392.9, 29.4) },
        { key = 'ltd_little_seoul',  label = 'LTD Gasoline, Little Seoul',    income = 450, coords = vec3(-707.5, -914.3, 19.2) },
        { key = 'robs_vespucci',     label = "Rob's Liquor, Vespucci",        income = 400, coords = vec3(-1222.9, -907.0, 12.3) },
        { key = 'robs_prosperity',   label = "Rob's Liquor, Prosperity Street", income = 400, coords = vec3(-1487.6, -379.1, 40.2) },
        { key = 'robs_san_andreas',  label = "Rob's Liquor, San Andreas Ave", income = 400, coords = vec3(1135.8, -982.3, 46.4) },
        { key = 'ltd_mirror',        label = 'LTD Gasoline, Mirror Park',     income = 500, coords = vec3(1163.4, -323.8, 69.2) },
        { key = 'herr_kutz_mirror',  label = 'Herr Kutz, Mirror Park',        income = 300, coords = vec3(1212.8, -472.9, 66.2) },
        { key = '247_clinton',       label = '24/7, Clinton Avenue',          income = 450, coords = vec3(373.9, 325.9, 103.6) },
        { key = 'ltd_richman_glen',  label = 'LTD Gasoline, Richman Glen',    income = 500, coords = vec3(-1820.5, 792.5, 138.1) },
        { key = '247_palomino',      label = '24/7, Palomino Freeway',        income = 350, coords = vec3(2557.2, 382.3, 108.6) },
        -- West coast
        { key = 'robs_great_ocean',  label = "Rob's Liquor, Great Ocean Highway", income = 350, coords = vec3(-2968.2, 390.9, 15.0) },
        { key = '247_inseno',        label = '24/7, Inseno Road',             income = 350, coords = vec3(-3038.7, 585.9, 7.9) },
        { key = '247_chumash',       label = '24/7, Chumash',                 income = 350, coords = vec3(-3243.0, 1000.0, 12.8) },
        -- County
        { key = '247_harmony',       label = '24/7, Harmony',                 income = 300, coords = vec3(549.0, 2671.4, 42.2) },
        { key = 'scoops_route68',    label = 'Scoops Liquor, Route 68',       income = 300, coords = vec3(1166.0, 2708.9, 38.2) },
        { key = 'ace_liquor_sandy',  label = 'Ace Liquor, Sandy Shores',      income = 300, coords = vec3(1392.6, 3604.7, 35.0) },
        { key = '247_sandy',         label = '24/7, Sandy Shores',            income = 300, coords = vec3(1961.5, 3740.7, 32.3) },
        { key = 'herr_kutz_sandy',   label = 'Herr Kutz, Sandy Shores',       income = 250, coords = vec3(1931.5, 3729.7, 32.8) },
        { key = '247_senora',        label = '24/7, Senora Freeway',          income = 300, coords = vec3(2678.8, 3280.4, 55.2) },
        { key = 'ltd_grapeseed',     label = 'LTD Gasoline, Grapeseed',       income = 300, coords = vec3(1698.4, 4924.4, 42.1) },
        { key = '247_paleto_hwy',    label = '24/7, Paleto Highway',          income = 300, coords = vec3(1728.7, 6414.2, 35.0) },
        { key = 'herr_kutz_paleto',  label = 'Herr Kutz, Paleto Bay',         income = 250, coords = vec3(-278.1, 6228.5, 31.7) },
        { key = 'discount_paleto',   label = 'Discount Store, Paleto Bay',    income = 300, coords = vec3(5.8, 6511.4, 31.9) },
    },
}
