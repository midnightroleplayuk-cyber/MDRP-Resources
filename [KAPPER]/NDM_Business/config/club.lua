NDM.ClubConfig = {
    entryPrice = 1000,    -- Default entry pass price. Managers can change it per club.
    vipPrice = 5000,      -- Default VIP pass price. Managers can change it per club.
    vipEnabled = true,
    vipDrinkDiscount = 10, -- Percent off bar drinks for VIP pass holders.
    passHours = 6,        -- How long a pass lasts in real hours.
    securityRange = 60.0, -- How close security must be to one of the club's points.

    -- These jobs cannot be thrown out or banned by club security.
    protectedJobs = { police = true, ambulance = true },

    drunk = {
        decayPerSecond = 0.002,
        maxLevel = 0.6,
        thresholds = { light = 0.03, moderate = 0.10, heavy = 0.20, extreme = 0.35 },
        walks = {
            light = 'move_m@drunk@slightlydrunk',
            moderate = 'move_m@drunk@moderatedrunk',
            heavy = 'move_m@drunk@moderatedrunk',
            extreme = 'move_m@drunk@verydrunk',
        },
    },

    -- Served drinks are consumed at the bar, so they do not need inventory items.
    drinks = {
        { id = 'screwdriver_drink', label = 'Screwdriver', alcohol = 8, price = 50 },
        { id = 'cosmopolitan', label = 'Cosmopolitan', alcohol = 15, price = 80 },
        { id = 'cuba_libre', label = 'Cuba Libre', alcohol = 10, price = 60 },
        { id = 'gin_tonic', label = 'Gin & Tonic', alcohol = 12, price = 70 },
        { id = 'tequila_sunrise', label = 'Tequila Sunrise', alcohol = 14, price = 75 },
        { id = 'pina_colada', label = 'Pina Colada', alcohol = 10, price = 65 },
        { id = 'whiskey_sour', label = 'Whiskey Sour', alcohol = 20, price = 85 },
        { id = 'sea_breeze', label = 'Sea Breeze', alcohol = 8, price = 55 },
        { id = 'bay_breeze', label = 'Bay Breeze', alcohol = 6, price = 50 },
        { id = 'shirley_temple', label = 'Shirley Temple', alcohol = 0, price = 30 },
        { id = 'arnold_palmer', label = 'Arnold Palmer', alcohol = 0, price = 25 },
        { id = 'rum_punch', label = 'Rum Punch', alcohol = 18, price = 90 },
        { id = 'jungle_juice', label = 'Jungle Juice', alcohol = 12, price = 70 },
        { id = 'paloma', label = 'Paloma', alcohol = 12, price = 65 },
        { id = 'jack_coke', label = 'Jack & Coke', alcohol = 15, price = 70 },
        { id = 'vodka_cran', label = 'Vodka Cranberry', alcohol = 10, price = 55 },
        { id = 'mai_tai', label = 'Mai Tai', alcohol = 16, price = 85 },
        { id = 'dark_stormy', label = 'Dark & Stormy', alcohol = 14, price = 65 },
    },
}
