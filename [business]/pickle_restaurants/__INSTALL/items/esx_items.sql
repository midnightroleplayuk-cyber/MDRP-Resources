-- pickle_restaurants — item definitions for legacy ESX (the `items` table)
-- Run this SQL against your ESX database. Safe to re-run (INSERT IGNORE).
--
-- The COMPLETE set the resource needs: the handout items players receive
-- (bag / meal / takeout box / Restaurant Item / receipt) plus every raw ingredient & input the kitchen
-- consumes. Cooked/assembled foods (burger, fries, cooked patty, pizza, cake…)
-- are intentionally omitted — they exist only in the cooked-items tray and get
-- packaged into a bag / meal tray / pizza box at prep, never entering inventory.

INSERT IGNORE INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
    -- handout items
    ('restaurant_bag',   'Restaurant Bag',  1, 0, 1),
    ('takeout_box',      'Takeout Box',     1, 0, 1),
    ('meal',             'Meal',            1, 0, 1),
    ('restaurant_item',  'Restaurant Item', 1, 0, 1),
    ('restaurant_receipt', 'Receipt',       1, 0, 1),
    -- raw cook inputs
    ('raw_beef_patty',   'Raw Beef Patty',    1, 0, 1),
    ('raw_chicken_patty', 'Raw Chicken Patty', 1, 0, 1),
    ('raw_drumstick',    'Raw Drumstick',   1, 0, 1),
    ('raw_fries',        'Raw Cut Fries',   1, 0, 1),
    ('raw_nuggets',      'Raw Nuggets',     1, 0, 1),
    ('raw_doughnut',     'Raw Doughnut',    1, 0, 1),
    ('empty_cup',        'Empty Cup',       1, 0, 1),
    ('baking_mix',       'Baking Mix',      1, 0, 1),
    -- assembly ingredients
    ('bun',              'Burger Bun',      1, 0, 1),
    ('cheese',           'Cheese Slice',    1, 0, 1),
    ('lettuce',          'Lettuce',         1, 0, 1),
    ('tomato',           'Tomato',          1, 0, 1),
    ('pickle',           'Pickle',          1, 0, 1),
    ('pizza_dough',      'Pizza Dough',     1, 0, 1),
    ('pizza_sauce',      'Pizza Sauce',     1, 0, 1),
    ('pizza_cheese',     'Shredded Cheese', 1, 0, 1),
    ('pepperoni',        'Pepperoni',       1, 0, 1),
    -- tools
    ('frosting',         'Frosting',        1, 0, 1),
    ('sprinkles',        'Sprinkles',       1, 0, 1),
    ('ketchup',          'Ketchup',         1, 0, 1),
    ('mustard',          'Mustard',         1, 0, 1),
    ('mayo',             'Mayo',            1, 0, 1);
