-- ------------------------------------------------------------
-- STOCKS ("Bolsa"): a SIMULATED stock market that lives on the server (server/stocks.lua).
-- Fourteen fictional Los Santos companies, a random walk per company (volatility + slow trend),
-- generated news headlines that push a price up or down, 7 days of price history (5 minute
-- points) and a portfolio per character. Buying and selling moves the player's BANK money through
-- the framework (the same path the Marketplace and Eats use).
--
-- Nothing here is real market data. Everything is server side: every player sees the same prices.
-- ------------------------------------------------------------
Config.Stocks = {
    enabled = false,

    tickSeconds = 60,         -- seconds between price updates (the apps poll the market at this pace)
    fee = 0.005,              -- fee charged on every buy AND every sell, as a fraction (0.005 = 0.5 %)
    maxQty = 10000,           -- maximum shares in one order
    maxOrderValue = 5000000,  -- maximum money in one order (protects against typos)
    historyDays = 7,          -- 5 minute price points kept (1 day / 1 week charts)
    dailyDays = 90,           -- daily closes kept (1 month chart)
    alertsPerPlayer = 10,     -- price alerts a character can keep at the same time
    watchlistMax = 20,        -- symbols in a watchlist

    -- how often news is generated: on average one headline every `newsEveryTicks` ticks (server wide)
    newsEveryTicks = 6,
    newsKeep = 80,            -- headlines kept in the database (the Noticias tab)
    -- size of the price jump a headline causes, as a fraction of the price (random between the two)
    newsImpactMin = 0.006,
    newsImpactMax = 0.035,

    -- symbol: 3 to 4 letters (unique). price: the starting price, also the centre the price slowly returns to.
    -- vol: DAILY volatility as a fraction (0.016 = 1.6 % typical daily move). sector: used to pick headlines.
    -- Sectors available for headlines: Tecnologia, Media, Turismo, Energia, Transportes, Industria,
    -- Alimentacao, Financas, Saude, Imobiliario, Automovel, Retalho.
    companies = {
        { symbol = 'PEAR', name = 'Pear Technologies',        sector = 'Tecnologia',  price = 182.40, vol = 0.016 },
        { symbol = 'VWSG', name = 'Vinewood Studios Group',   sector = 'Media',       price = 64.10,  vol = 0.020 },
        { symbol = 'DPPH', name = 'Del Perro Pier Holdings',  sector = 'Turismo',     price = 27.35,  vol = 0.018 },
        { symbol = 'LSEN', name = 'Los Santos Energy',        sector = 'Energia',     price = 48.90,  vol = 0.011 },
        { symbol = 'SAFR', name = 'San Andreas Freight',      sector = 'Transportes', price = 112.20, vol = 0.012 },
        { symbol = 'BCM',  name = 'Blaine County Minerals',   sector = 'Industria',   price = 15.70,  vol = 0.026 },
        { symbol = 'VESP', name = 'Vespucci Foods',           sector = 'Alimentacao', price = 39.80,  vol = 0.010 },
        { symbol = 'MAZE', name = 'Maze Capital',             sector = 'Financas',    price = 230.00, vol = 0.014 },
        { symbol = 'PLBX', name = 'Pillbox Health',           sector = 'Saude',       price = 88.60,  vol = 0.013 },
        { symbol = 'RHR',  name = 'Rockford Hills Realty',    sector = 'Imobiliario', price = 141.50, vol = 0.015 },
        { symbol = 'GSM',  name = 'Grove Street Motors',      sector = 'Automovel',   price = 22.40,  vol = 0.023 },
        { symbol = 'PBF',  name = 'Paleto Bay Fisheries',     sector = 'Alimentacao', price = 9.85,   vol = 0.021 },
        { symbol = 'ALTA', name = 'Alta Street Retail',       sector = 'Retalho',     price = 56.30,  vol = 0.017 },
        { symbol = 'ZNCA', name = 'Zancudo Aerospace',        sector = 'Industria',   price = 310.00, vol = 0.019 },
    },
}
