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
        restaurant = {},
        club = {},
        business = {},
    },
}
