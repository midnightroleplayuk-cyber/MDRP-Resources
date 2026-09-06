-- Define your fertilizer types here

Config.fertilizerTypes = {
    ['growth_speed'] = {
        label = 'Growth speed',
        item = 'kq_weed_fertilizer_speed',

        -- 0 = Blue -- 1 = Yellow -- 2 = White -- 3 = Red -- 4 = Black -- 5 = Brown -- 6 = Purple -- 7 = Green
        color = 0,
        multipliers = {
            -- General growth speed
            growthSpeed = 1.3,
            -- Water consumption multiplier
            waterConsumption = 1.4,
            -- Plant resistance to dryness, insects and decay(collection) lifespan
            resistance = 0.9,
            -- Amount of weed received from the plant
            yield = 0.9,
        },
    },
    ['yield_amount'] = {
        label = 'Yield amount',
        item = 'kq_weed_fertilizer_yield',

        -- 0 = Blue -- 1 = Yellow -- 2 = White -- 3 = Red -- 4 = Black -- 5 = Brown -- 6 = Purple -- 7 = Green
        color = 1,
        multipliers = {
            -- General growth speed
            growthSpeed = 0.75,
            -- Water consumption multiplier
            waterConsumption = 1.2,
            -- Plant resistance to dryness, insects and decay(collection) lifespan
            resistance = 1.0,
            -- Amount of weed received from the plant
            yield = 1.45,
        },
    },
    ['resistance_booster'] = {
        label = 'Resistance booster',
        item = 'kq_weed_fertilizer_resistance',

        -- 0 = Blue -- 1 = Yellow -- 2 = White -- 3 = Red -- 4 = Black -- 5 = Brown -- 6 = Purple -- 7 = Green
        color = 7,
        multipliers = {
            -- General growth speed
            growthSpeed = 0.95,
            -- Water consumption multiplier
            waterConsumption = 1.1,
            -- Plant resistance to dryness, insects and decay(collection) lifespan
            resistance = 2.5,
            -- Amount of weed received from the plant
            yield = 1.0,
        },
    },
    ['blackmarket_fertilizer'] = {
        label = 'Blackmarket',
        item = 'kq_weed_fertilizer_blackmarket',

        -- 0 = Blue -- 1 = Yellow -- 2 = White -- 3 = Red -- 4 = Black -- 5 = Brown -- 6 = Purple -- 7 = Green
        color = 6,
        multipliers = {
            -- General growth speed
            growthSpeed = 1.3,
            -- Water consumption multiplier
            waterConsumption = 1.5,
            -- Plant resistance to dryness, insects and decay(collection) lifespan
            resistance = 0.75,
            -- Amount of weed received from the plant
            yield = 1.1,
        },
    },

    -- You can add as many different types of fertilizers as you want
}
