NDM.SupplyConfig = {
    unitsPerBox = 25,      -- How many items fit in one carried box.
    maxBoxesPerOrder = 12, -- The largest order one trip can be.
    maxStock = 500,        -- The most of one item a venue can hold, including items on order.

    -- Items missing from ox_inventory are skipped automatically and logged at startup.
    catalog = {
        restaurant = {
            { item = 'raw_beef_patty', price = 5 },
            { item = 'raw_chicken_patty', price = 5 },
            { item = 'raw_drumstick', price = 4 },
            { item = 'raw_nuggets', price = 3 },
            { item = 'raw_fries', price = 2 },
            { item = 'raw_doughnut', price = 2 },
            { item = 'baking_mix', price = 4 },
            { item = 'pizza_dough', price = 3 },
            { item = 'pizza_sauce', price = 1 },
            { item = 'pizza_cheese', price = 2 },
            { item = 'pepperoni', price = 2 },
            { item = 'bun', price = 1 },
            { item = 'cheese', price = 1 },
            { item = 'lettuce', price = 1 },
            { item = 'tomato', price = 1 },
            { item = 'pickle', price = 1 },
            { item = 'empty_cup', price = 1 },
            { item = 'frosting', price = 2 },
            { item = 'sprinkles', price = 1 },
            { item = 'ketchup', price = 2 },
            { item = 'mustard', price = 2 },
            { item = 'mayo', price = 2 },
        },
        club = {
            { item = 'screwdriver_drink', price = 4 },
            { item = 'cosmopolitan', price = 4 },
            { item = 'cuba_libre', price = 4 },
            { item = 'gin_tonic', price = 4 },
            { item = 'tequila_sunrise', price = 4 },
            { item = 'pina_colada', price = 4 },
            { item = 'whiskey_sour', price = 4 },
            { item = 'sea_breeze', price = 4 },
            { item = 'bay_breeze', price = 4 },
            { item = 'shirley_temple', price = 3 },
            { item = 'arnold_palmer', price = 3 },
            { item = 'rum_punch', price = 4 },
            { item = 'jungle_juice', price = 4 },
            { item = 'paloma', price = 4 },
            { item = 'jack_coke', price = 4 },
            { item = 'vodka_cran', price = 4 },
            { item = 'mai_tai', price = 4 },
            { item = 'dark_stormy', price = 4 },
        },
        business = {},
    },
}
