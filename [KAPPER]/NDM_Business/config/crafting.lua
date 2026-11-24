-- Ingredients come from venue stock and the result goes back into venue stock.
-- A crafted item must also be in config/supply.lua with `crafted = true`, for example:
--     { item = 'burger', price = 0, crafted = true },
--
-- Recipe example:
--     {
--         id = 'burger',
--         label = 'Burger',
--         duration = 5000,
--         ingredients = { bun = 1, raw_beef_patty = 1, lettuce = 1 },
--         output = { item = 'burger', count = 1 },
--     },
NDM.CraftingConfig = {
    recipes = {
        -- `station` is the location type that makes it. A Crafting station can make everything.
        restaurant = {
            { id = 'grill_beef', station = 'grill', label = 'Grilled Patty', duration = 6000, ingredients = { raw_beef_patty = 1 }, output = { item = 'grilled_burger', count = 1 } },
            { id = 'grill_chicken', station = 'grill', label = 'Grilled Chicken Patty', duration = 6000, ingredients = { raw_chicken_patty = 1 }, output = { item = 'grilled_chicken_burger', count = 1 } },

            { id = 'fry_fries', station = 'fryer', label = 'Fries', duration = 5000, ingredients = { raw_fries = 1 }, output = { item = 'fries', count = 1 } },
            { id = 'fry_nuggets', station = 'fryer', label = 'Chicken Nuggets', duration = 5000, ingredients = { raw_nuggets = 1 }, output = { item = 'chicken_nuggets', count = 1 } },

            { id = 'make_burger', station = 'prep', label = 'Burger', duration = 4000, ingredients = { bun = 1, grilled_burger = 1, lettuce = 1, tomato = 1 }, output = { item = 'burger', count = 1 } },
            { id = 'make_cheeseburger', station = 'prep', label = 'Cheeseburger', duration = 4000, ingredients = { bun = 1, grilled_burger = 1, cheese = 1, pickle = 1, ketchup = 1 }, output = { item = 'cheeseburger', count = 1 } },
            { id = 'make_double', station = 'prep', label = 'Double Burger', duration = 5000, ingredients = { bun = 1, grilled_burger = 2, cheese = 2, lettuce = 1, mustard = 1 }, output = { item = 'double_burger', count = 1 } },
            { id = 'make_chicken', station = 'prep', label = 'Chicken Burger', duration = 4000, ingredients = { bun = 1, grilled_chicken_burger = 1, lettuce = 1, mayo = 1 }, output = { item = 'chicken_burger', count = 1 } },

            { id = 'pour_cola', station = 'drinks', label = 'Cola', duration = 2500, ingredients = { empty_cup = 1 }, output = { item = 'cola', count = 1 } },
            { id = 'pour_sprunk', station = 'drinks', label = 'Sprunk', duration = 2500, ingredients = { empty_cup = 1 }, output = { item = 'sprunk', count = 1 } },
            { id = 'pour_water', station = 'drinks', label = 'Water', duration = 2000, ingredients = { empty_cup = 1 }, output = { item = 'water', count = 1 } },
            { id = 'pour_coffee', station = 'drinks', label = 'Coffee', duration = 3000, ingredients = { empty_cup = 1 }, output = { item = 'coffee', count = 1 } },
            { id = 'pour_milkshake', station = 'drinks', label = 'Milkshake', duration = 3500, ingredients = { empty_cup = 1 }, output = { item = 'milkshake', count = 1 } },
        },
        club = {},
        business = {},
    },
}
