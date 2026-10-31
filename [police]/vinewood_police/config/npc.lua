---------------------------------------------------------------------------
-- NPC traffic stops (phase 2, drop 2).
-- An NPC's record (identity, licence, insurance, MOT, tax, keeper, warrants) is generated the first
-- time their vehicle is stopped and kept, so stopping the same plate again finds the same people.
-- Weights are relative: { a = 80, b = 20 } means a 4 in 5 chance of a.
---------------------------------------------------------------------------
Config.NPC = {
    Enabled = true,

    -- Limits so NPC stops never flood the server
    MaxActive = 12,           -- NPC stops open across the whole server
    PerOfficer = 1,           -- open NPC stops per officer
    Cooldown = 10,            -- seconds between NPC stops by the same officer
    ForgetAfterDays = 7,      -- generated records nobody has met for this long are deleted
                              -- (wanted people, arrests and failed-to-stop vehicles are kept)

    -- What the driver's record looks like
    Licence = { valid = 80, provisional = 5, disqualified = 4, none = 6, expired = 5 },
    Insurance = { insured = 86, none = 8, notCovered = 6 },     -- notCovered: policy exists, driver not on it
    MOT = { valid = 86, expired = 10, dangerous = 4 },
    Tax = { taxed = 88, untaxed = 9, sorn = 3 },
    Keeper = { driver = 70, family = 15, company = 8, recentSale = 4, stolen = 3 },
    WantedChance = 3,         -- % with an outstanding warrant
    PriorRecordChance = 18,   -- % with a criminal record (fingerprints on file)
    DrinkChance = 4,          -- % over the drink-drive limit (breath tests come in drop 3)
    DrugChance = 3,           -- % who would fail a drug wipe
    DefectChance = 10,        -- % with an obvious defect

    -- False details: base %, raised for people with something to hide
    FalseDetails = { base = 5, wanted = 55, disqualified = 40, noLicence = 25 },

    -- Behaviour when stopped. Modifiers are added to these weights for the people they apply to.
    Behaviour = {
        weights = { compliant = 70, nervous = 12, uncooperative = 8, aggressive = 3, flee_foot = 4, flee_vehicle = 3 },
        modifiers = {
            wanted     = { flee_vehicle = 15, flee_foot = 15, aggressive = 5 },
            stolen     = { flee_vehicle = 30, flee_foot = 15 },
            drink      = { nervous = 15, flee_vehicle = 6 },
            disqualified = { nervous = 15, flee_foot = 8, flee_vehicle = 6 },
        },
        -- A nervous driver asked to step out runs this % of the time
        NervousBolt = 20,
    },

    -- Hostile NPCs (squaring up to the officer). Always unarmed; never in these zones or when
    -- lots of players are about. false = 'aggressive' NPCs argue and refuse but never fight.
    AllowHostile = true,
    HostileMaxPlayersNearby = 6,   -- players within 60 m
    NoHostileZones = {
        { coords = vec3(-265.0, -963.0, 31.2), radius = 250.0 },  -- Legion Square
        { coords = vec3(441.0, -982.0, 30.7), radius = 120.0 },   -- Mission Row
        { coords = vec3(298.0, -584.0, 43.3), radius = 120.0 },   -- Pillbox Hill hospital
    },

    -- Pursuits
    LostDistance = 400.0,     -- metres away counts as lost...
    LostSeconds = 40,         -- ...for this long
    GiveUpChance = 12,        -- % chance every 15 s that a fleeing driver gives up
    AddToANPR = true,         -- a vehicle that fails to stop goes on ANPR (vinewood-mdt)
    ANPRHours = 24,

    -- Someone running on foot gives up when an officer is this close for this long, or is tasered/knocked down
    CatchDistance = 2.2,
    CatchSeconds = 1.5,

    -- Mobile fingerprint check (identifies people with prints on file)
    FingerprintItem = false,  -- e.g. 'mobile_id' to need an item; false = every officer can
}

---------------------------------------------------------------------------
-- Names and places the generator picks from
---------------------------------------------------------------------------
Config.NPCNames = {
    male = { 'James', 'Oliver', 'Jack', 'Harry', 'Thomas', 'George', 'Daniel', 'Liam', 'Connor', 'Ryan', 'Callum', 'Kieran',
        'Mohammed', 'Adam', 'Jamal', 'Tyrone', 'Darren', 'Craig', 'Wayne', 'Lee', 'Mark', 'Paul', 'Stephen', 'Gary', 'Reece', 'Kai' },
    female = { 'Olivia', 'Amelia', 'Emily', 'Jessica', 'Sophie', 'Chloe', 'Lauren', 'Megan', 'Hannah', 'Charlotte', 'Aisha',
        'Priya', 'Zara', 'Kerry', 'Tracey', 'Stacey', 'Leanne', 'Nicola', 'Gemma', 'Jade', 'Shannon', 'Kelly' },
    surnames = { 'Smith', 'Jones', 'Taylor', 'Brown', 'Williams', 'Wilson', 'Johnson', 'Davies', 'Robinson', 'Wright', 'Thompson',
        'Evans', 'Walker', 'White', 'Roberts', 'Green', 'Hall', 'Wood', 'Jackson', 'Clarke', 'Patel', 'Khan', 'Ali', 'Hughes',
        'Edwards', 'Turner', 'Murphy', "O'Brien", 'Kelly', 'McDonald', 'Campbell', 'Hussain', 'Begum', 'Ahmed', 'Okafor', 'Mensah' },
    streets = { 'Grove Street', 'Forum Drive', 'Carson Avenue', 'Strawberry Avenue', 'Davis Avenue', 'Jamestown Street',
        'Palomino Avenue', 'Vespucci Boulevard', 'Mirror Park Boulevard', 'Nikola Avenue', 'Elgin Avenue', 'Tongva Drive',
        'Alhambra Drive', 'Zancudo Avenue', 'Paleto Boulevard', 'Procopio Drive', 'Joshua Road', 'Marina Drive' },
    areas = { 'Davis', 'Strawberry', 'Chamberlain Hills', 'Mirror Park', 'Vespucci', 'Little Seoul', 'Rockford Hills', 'Sandy Shores',
        'Paleto Bay', 'Grapeseed', 'Harmony', 'La Mesa', 'Murrieta Heights', 'El Burro Heights' },
    companies = { 'Bugstars Pest Control', 'Post OP Deliveries', 'GoPostal', 'Big Goods Removals', 'Dynasty 8 Real Estate', 'Bilkington Lease Ltd' },
    warrants = { 'Failing to appear at court', 'Breach of bail conditions', 'Recall to prison (licence breach)',
        'Wanted for burglary', 'Wanted for assault occasioning ABH', 'Wanted for theft of a motor vehicle' },
    defects = { 'Bald front tyre', 'Brake light not working', 'Cracked windscreen in driver\'s view', 'Number plate unreadable',
        'Headlight not working', 'Excessive exhaust smoke' },
}
