Config.Contracts = {
    offersPerGang   = 4,   -- jobs on each gang's board at once
    offerMinutes    = 45,  -- how long an offer stays up before it's withdrawn
    refreshMinutes  = 5,   -- how often boards are topped up (only for gangs with someone online)
    minRouteDistance = 700.0,
    maxSpeed        = 70.0, -- m/s; deliveries faster than this are rejected as impossible
    policeAlertChance = 0.35,

    -- Difficulty: reward multiplier, trust and reputation gained or lost
    difficulty = {
        [1] = { label = 'Low risk',    reward = 1.0, trust = 5,  reputation = 2, failTrust = -3 },
        [2] = { label = 'Medium risk', reward = 1.6, trust = 8,  reputation = 4, failTrust = -6 },
        [3] = { label = 'High risk',   reward = 2.4, trust = 12, reputation = 7, failTrust = -10 },
    },

    -- Trust with a contact unlocks harder, better-paid jobs from them
    tiers = { [1] = 0, [2] = 40, [3] = 120 },

    contacts = {
        { key = 'mags', label = 'Mags', templates = { 'courier', 'collect' } },
        { key = 'ray',  label = 'Ray the Fence', templates = { 'transport', 'courier' } },
        { key = 'dutchy', label = 'Dutchy', templates = { 'collect', 'transport' } },
    },

    templates = {
        courier = {
            title = 'Courier run',
            reward = 2500, account = 'dirty', timeLimit = 900,
        },
        transport = {
            title = 'Move a stolen car',
            reward = 4000, account = 'dirty', timeLimit = 1200,
            vehicles = { 'sultan', 'felon', 'baller', 'oracle', 'tailgater', 'sentinel' },
        },
        collect = {
            title = 'Collect a debt',
            reward = 3000, account = 'dirty', timeLimit = 900,
            peds = { 'a_m_m_business_01', 'a_m_y_business_02', 'a_m_m_soucent_02', 'g_m_y_mexgoon_01' },
            payChance = 0.55,   -- otherwise he runs or fights (harder jobs pay up less often)
            fightChance = 0.35, -- share of non-payers who fight rather than run
        },
    },

    -- Built-in spots across San Andreas. Add more in game from /gangadmin > Contract spots (no restart needed).
    -- Courier runs and car jobs pick two spots at least minRouteDistance apart.
    locations = {
        -- Pickups and drop-offs (courier runs, car drop-offs, supply van pickups)
        general = {
            -- Los Santos
            { label = 'Elysian Island docks', x = 180.5,   y = -3090.2, z = 5.8 },
            { label = 'Cypress Flats',        x = 880.1,   y = -2180.6, z = 30.5 },
            { label = 'La Mesa',              x = 730.4,   y = -1290.5, z = 26.3 },
            { label = 'Rancho',               x = 430.0,   y = -1830.0, z = 28.0 },
            { label = 'Chamberlain Hills', x = -175.92, y = -1647.04, z = 33.33 },
            { label = 'Strawberry',           x = -205.0,  y = -1310.0, z = 31.3 },
            { label = 'Legion Square',        x = 195.0,   y = -935.0,  z = 30.7 },
            { label = 'Little Seoul', x = -709.94, y = -919.60, z = 19.01 },
            { label = 'Vespucci Canals', x = -1035.61, y = -1012.62, z = 2.15 },
            { label = 'Del Perro Pier',       x = -1604.6, y = -1048.3, z = 13.0 },
            { label = 'Rockford Hills', x = -689.37, y = -148.77, z = 37.64 },
            { label = 'Vinewood',             x = 325.0,   y = -205.0,  z = 54.1 },
            { label = 'Mirror Park',          x = 1150.2,  y = -466.5,  z = 66.6 },
            { label = 'East Vinewood',        x = 972.0,   y = -128.0,  z = 74.3 },
            -- West coast
            { label = 'Banham Canyon', x = -3035.98, y = 586.33, z = 7.81 },
            { label = 'Chumash',              x = -3237.0, y = 1003.0,  z = 12.4 },
            { label = 'Lago Zancudo', x = -2543.27, y = 2318.70, z = 33.22 },
            -- County
            { label = 'Harmony',              x = 549.0,   y = 2654.0,  z = 42.2 },
            { label = 'Sandy Shores', x = 1967.78, y = 3737.22, z = 32.21 },
            { label = 'Sandy Shores Airfield', x = 1732.45, y = 3306.31, z = 41.22 },
            { label = 'Grand Senora Desert',  x = 2748.0,  y = 3472.0,  z = 55.7 },
            { label = 'Grapeseed',            x = 2416.0,  y = 4993.0,  z = 46.2 },
            { label = 'Paleto Forest', x = -559.43, y = 5364.73, z = 70.23 },
            { label = 'Paleto Bay', x = -129.97, y = 6342.60, z = 31.49 },
        },
        -- Where cars for 'Move a stolen car' are parked (w = heading)
        vehicles = {
            { label = 'Legion Square car park', x = 215.5,  y = -810.2,  z = 30.7,  w = 160.0 },
            { label = 'Vinewood car park',      x = 363.0,  y = 297.0,   z = 103.5, w = 160.0 },
            { label = 'Pink Cage Motel',        x = 290.6,  y = -336.4,  z = 44.9,  w = 160.0 },
            { label = 'Mirror Park',            x = 1145.0, y = -475.0,  z = 66.4,  w = 255.0 },
            { label = 'Del Perro',              x = -1183.0, y = -1500.0, z = 4.4,  w = 35.0 },
            { label = 'LSIA long-stay parking', x = -773.0, y = -2033.0, z = 8.9,   w = 315.0 },
            { label = 'Sandy Shores',           x = 1737.8, y = 3719.3,  z = 33.0,  w = 21.2 },
            { label = 'Paleto Bay',             x = 110.8,  y = 6607.8,  z = 31.9,  w = 265.3 },
        },
        -- Where debtors wait for 'Collect a debt' (w = heading they face)
        debtors = {
            { label = 'Vespucci Canals', x = -1035.61, y = -1012.62, z = 2.15, w = 300.99 },
            { label = 'Mirror Park',       x = 1150.2,  y = -466.5,  z = 66.6, w = 0.0 },
            { label = 'Chamberlain Hills', x = -175.92, y = -1647.04, z = 33.33, w = 85.26 },
            { label = 'Rancho',            x = 430.0,   y = -1830.0, z = 28.0, w = 320.0 },
            { label = 'Little Seoul', x = -709.94, y = -919.60, z = 19.01, w = 215.43 },
            { label = 'Strawberry',        x = -205.0,  y = -1310.0, z = 31.3, w = 180.0 },
            { label = 'Vinewood',          x = 325.0,   y = -205.0,  z = 54.1, w = 160.0 },
            { label = 'Harmony',           x = 549.0,   y = 2654.0,  z = 42.2, w = 100.0 },
            { label = 'Sandy Shores', x = 1967.78, y = 3737.22, z = 32.21, w = 226.54 },
            { label = 'Grapeseed',         x = 2416.0,  y = 4993.0,  z = 46.2, w = 45.0 },
            { label = 'Paleto Bay', x = -129.97, y = 6342.60, z = 31.49, w = 148.90 },
        },
    },
}

-- Vehicle keys for 'Move a stolen car'. Runs on the runner's client once the car exists.
-- Change this to suit your keys script.
Config.Contracts.giveKeys = function(vehicle, plate)
    if GetResourceState('qbx_vehiclekeys') == 'started' then
        TriggerServerEvent('vinewood_gangs:server:contractKeys', NetworkGetNetworkIdFromEntity(vehicle))
    elseif GetResourceState('qb-vehiclekeys') == 'started' then
        TriggerEvent('vehiclekeys:client:SetOwner', plate)
    end
end
