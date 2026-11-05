Config = {}

-- 'tr' | 'en'. Also picks the printed board (f4t_board_tr / f4t_board_en).
Config.Locale = 'en'
Config.Debug = false

-- Money is only used for the optional bets.
-- 'auto' | 'qbx' | 'qb' | 'esx' | 'standalone'  (standalone = no bets, the game itself works everywhere)
Config.Framework = 'qbx'

-- ============================================================
-- TABLES
-- Each entry spawns a table with four chairs and the board on it.
-- coords: x, y, z, heading. Seat 1 sits on the -Y side of the heading (facing it).
-- snapToGround: finds the ground under the point, so the z of a player position
--               (about 1 m above the ground) is fine.
-- In game, admins can also place tables with /tycoontable add (saved in data/tables.json)
-- and remove them with /tycoontable remove.
-- ============================================================
Config.Tables = {
    { id = 'bowl1', coords = vector4(1554.63, 3792.96, 33.9, 305.41), snapToGround = true },
    { id = 'bowl2', coords = vector4(1550.3, 3789.94, 33.9, 305.41), snapToGround = true },
}

Config.SpawnDistance = 60.0       -- props are created within this range (and the table is "watched")
Config.InteractDistance = 1.4     -- distance to a chair to get the sit prompt
Config.SitKey = 38                -- E (INPUT_PICKUP)
Config.Blip = { enabled = false, sprite = 680, color = 46, scale = 0.75 }

-- Sitting: the chair props are 0.48 m high. Tweak if a ped model floats or sinks.
Config.Seat = {
    scenario = 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER',
    height = 0.50,                 -- above the chair origin (floor)
    back = 0.02,                   -- metres back from the chair centre
}

-- Admins: ACE 'command' or the 'f4tycoon.admin' ACE (add_ace group.admin f4tycoon.admin allow)
Config.AdminAce = 'f4tycoon.admin'

-- ============================================================
-- RULES (F4 City). Money is in-game money; amounts are full numbers (200000 = 200K).
-- Board, districts, prices and rents: data/board.json (tools/make_board.py).
-- ============================================================
Config.Game = {
    minPlayers = 2,
    maxPlayers = 4,
    startCountdown = 5,           -- seconds after everybody seated is ready
    startingCash = 1500000,
    salary = 200000,              -- every time a token passes or lands on START
    startBonus = 100000,          -- extra for landing on START exactly
    firstLapHouses = 2,           -- houses a district can have before your token passed START once (then 3)
    hotelVisit = 3,               -- the hotel opens when 3 houses stand and you stop there for this time
                                  -- (buying the district is the 1st stop)
    zoneMultiplier = 1.5,         -- rent of every district of a zone you own completely
    rentDay = 20000,              -- rent day: the bank pays this for every space you own
    contractorDiscount = 0.5,     -- contractor: one building at this share of its price
    cityHallGrant = 100000,       -- city hall: paid instead when you have nothing to build on
    taxRate = 0.08,               -- tax: share of everything you own (land + buildings)
    sellRate = 0.60,              -- selling a space to the bank (only to pay a debt) returns this share
    trafficFee = 100000,          -- get out of traffic right away
    trafficTurns = 2,             -- after this many failed double rolls the token drives on
    rentInTraffic = true,         -- owners stuck in traffic still collect rent
    -- the exchange: what you may invest, and what the market roll (two dice) does with it
    exchangeStakes = { 100000, 250000, 500000 },
    exchangeTable = { [2] = -1.0, [3] = -1.0, [4] = -1.0, [5] = -0.5, [6] = -0.5, [7] = 0.0,
                      [8] = 0.5, [9] = 0.5, [10] = 1.5, [11] = 1.5, [12] = 1.5 },
    timeLimit = 0,                -- minutes; 0 = play until somebody wins. Otherwise the richest wins.
    afkStrikes = 3,               -- missed timers in a row before a player is removed
    resultTime = 15,              -- seconds the result screen stays before the table resets
}

-- Prestige: the city's opinion of you. Reaching the target wins the game (besides being the
-- last player standing).
Config.Prestige = {
    target = 45,                  -- 0 = only bankruptcy wins
    district = 1,                 -- every district owned
    house = 1,                    -- every house
    hotel = 6,                    -- a hotel (instead of its houses)
    zone = 3,                     -- every complete zone
    landmark = 2,                 -- every landmark
    allLandmarks = 4,             -- extra for owning all of them
}
Config.WealthTarget = 0           -- > 0: reaching this net worth also wins

-- ============================================================
-- TABLE SETTINGS: what the host (first to sit) may change in the lobby, and the choices.
-- The defaults are the values above. Remove a line to keep that rule fixed; enabled = false
-- turns the settings off. Changing a setting un-readies everyone.
-- ============================================================
Config.LobbySettings = {
    enabled = true,
    options = {
        startingCash = { 1000000, 1500000, 2000000, 3000000 },
        salary = { 100000, 200000, 300000, 400000 },
        startBonus = { 0, 100000, 200000 },
        rentDay = { 0, 20000, 40000 },
        taxRate = { 0.05, 0.08, 0.12 },
        trafficFee = { 50000, 100000, 200000 },
        sellRate = { 0.5, 0.6, 0.75 },
        firstLapHouses = { 2, 3 },              -- 3 = no first lap limit
        hotelVisit = { 2, 3, 4 },
        zoneMultiplier = { 1.5, 2 },
        prestigeTarget = { 0, 35, 45, 60 },     -- 0 = off
        wealthTarget = { 0, 5000000, 8000000, 12000000 },
        timeLimit = { 0, 20, 30, 45, 60 },      -- minutes, 0 = none
        speed = { 'fast', 'normal', 'relaxed' },
    },
}
-- decision timers x this for each pace
Config.Speeds = { fast = 0.6, normal = 1.0, relaxed = 1.6 }

-- Decision timers (seconds). When one runs out the server plays the default move.
Config.Timers = {
    roll = 30,
    buy = 25,                     -- buy (and build) / build on your own district
    traffic = 30,
    pick = 25,                    -- city hall, contractor, renewal, storm
    invest = 20,                  -- the exchange
    card = 8,
    debt = 90,
}

-- Animation timing (ms) the server waits for so every client stays in step.
Config.Timing = {
    dice = 3400,
    hop = 230,
    traffic = 1400,               -- the jump into the traffic jam
    card = 1800,
    turnPause = 700,              -- before the next player's turn
}

-- ============================================================
-- BETS (optional; needs qbx_core, qb-core or es_extended)
-- The first player to sit sets the stake in the lobby, everyone who readies up pays it
-- when the game starts, the winner takes the pot (minus houseCut).
-- ============================================================
Config.Bet = {
    enabled = true,
    account = 'cash',             -- 'cash' | 'bank'
    min = 100,
    max = 1000000,
    houseCut = 0.0,               -- 0.05 = 5 % of the pot is kept by the house
    presets = { 0, 500, 1000, 5000, 10000, 50000 },
}

-- ============================================================
-- AI PLAYERS
-- The host can fill empty seats with bots in the lobby (play alone against the AI, or
-- fill a table). Bots sit on the chairs as NPCs and play with a real strategy. While a
-- bot is seated there are no stakes.
-- ============================================================
Config.Bots = {
    enabled = true,
    names = { 'Shaun', 'Keith', 'Charlie', 'James', 'Paddy', 'Michael' },
    peds = { 'a_m_y_business_01', 'a_f_y_business_02', 'a_m_m_business_01', 'a_f_y_hipster_01' },
    thinkMin = 700,               -- ms a bot "thinks" before each decision
    thinkMax = 1700,
    minReserve = 150000,          -- cash a bot keeps at least (more when expensive spaces lie ahead)
}

Config.Currency = '£'

Config.Camera = {
    fov = 48.0,
    auto = true,                  -- follow dice / tokens / cards automatically
}

-- Player token models (order = lobby selection order)
Config.Tokens = {
    { id = 'crown',  model = 'f4t_token_crown',  color = '#E3B23C' },
    { id = 'rocket', model = 'f4t_token_rocket', color = '#D8423A' },
    { id = 'gem',    model = 'f4t_token_gem',    color = '#29B9D2' },
    { id = 'rook',   model = 'f4t_token_rook',   color = '#8C5AD6' },
    { id = 'anchor', model = 'f4t_token_anchor', color = '#3A72DB' },
    { id = 'star',   model = 'f4t_token_star',   color = '#38B25C' },
}
