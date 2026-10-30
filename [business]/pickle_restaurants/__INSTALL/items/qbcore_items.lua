-- pickle_restaurants — item definitions for QBCore
-- Paste these entries into qb-core/shared/items.lua (inside the QBShared.Items table).
--
-- The COMPLETE set the resource needs: the handout items players receive
-- (bag / meal / takeout box / Restaurant Item / receipt) plus every raw ingredient & input the kitchen
-- consumes. Cooked/assembled foods (burger, fries, cooked patty, pizza, cake…) are
-- intentionally omitted — they exist only in the cooked-items tray and get packaged
-- into a bag / meal tray / pizza box at prep, never entering inventory.

    -- ── handout items ────────────────────────────────────────────────────────
    ['restaurant_bag'] = { name = 'restaurant_bag', label = 'Restaurant Bag', weight = 800, type = 'item', image = 'restaurant_bag.png', unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'A bag of food from a restaurant. Use it to pick what to eat.' },
    ['meal']           = { name = 'meal',           label = 'Meal',            weight = 800, type = 'item', image = 'meal.png',           unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'A meal tray from a restaurant. Sit down at a table to eat it.' },
    ['takeout_box']    = { name = 'takeout_box',    label = 'Takeout Box',     weight = 500, type = 'item', image = 'takeout_box.png',    unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'A takeout box of food from a restaurant.' },
    -- THE RESTAURANT ITEM: one serving of anything the kitchen makes — every poured
    -- drink AND every cooked product a cook pockets off the tray. What it holds rides
    -- in its metadata. Replaces the old `drink` item.
    ['restaurant_item'] = { name = 'restaurant_item', label = 'Restaurant Item', weight = 300, type = 'item', image = 'restaurant_item.png', unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'One serving from a restaurant.' },
    ['restaurant_receipt'] = { name = 'restaurant_receipt', label = 'Receipt',    weight = 10,  type = 'item', image = 'restaurant_receipt.png', unique = false, useable = false, shouldClose = true, combinable = nil, description = 'An order receipt.' },

    -- ── raw cook inputs ──────────────────────────────────────────────────────
    ['raw_beef_patty']    = { name = 'raw_beef_patty',    label = 'Raw Beef Patty',    weight = 220, type = 'item', image = 'raw_beef_patty.png',    unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['raw_chicken_patty'] = { name = 'raw_chicken_patty', label = 'Raw Chicken Patty', weight = 220, type = 'item', image = 'raw_chicken_patty.png', unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['raw_drumstick']     = { name = 'raw_drumstick',     label = 'Raw Drumstick',     weight = 220, type = 'item', image = 'raw_drumstick.png',     unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['raw_fries']         = { name = 'raw_fries',         label = 'Raw Cut Fries',     weight = 180, type = 'item', image = 'raw_fries.png',         unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['raw_nuggets']       = { name = 'raw_nuggets',       label = 'Raw Nuggets',       weight = 180, type = 'item', image = 'raw_nuggets.png',       unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['raw_doughnut']      = { name = 'raw_doughnut',      label = 'Raw Doughnut',      weight = 150, type = 'item', image = 'raw_doughnut.png',      unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['empty_cup']         = { name = 'empty_cup',         label = 'Empty Cup',         weight = 100, type = 'item', image = 'empty_cup.png',         unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['baking_mix']        = { name = 'baking_mix',        label = 'Baking Mix',        weight = 400, type = 'item', image = 'baking_mix.png',        unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },

    -- ── assembly ingredients ─────────────────────────────────────────────────
    ['bun']          = { name = 'bun',          label = 'Burger Bun',     weight = 120, type = 'item', image = 'bun.png',          unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['cheese']       = { name = 'cheese',       label = 'Cheese Slice',   weight = 60,  type = 'item', image = 'cheese.png',       unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['lettuce']      = { name = 'lettuce',      label = 'Lettuce',        weight = 80,  type = 'item', image = 'lettuce.png',      unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['tomato']       = { name = 'tomato',       label = 'Tomato',         weight = 90,  type = 'item', image = 'tomato.png',       unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['pickle']       = { name = 'pickle',       label = 'Pickle',         weight = 40,  type = 'item', image = 'pickle.png',       unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['pizza_dough']  = { name = 'pizza_dough',  label = 'Pizza Dough',    weight = 300, type = 'item', image = 'pizza_dough.png',  unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['pizza_sauce']  = { name = 'pizza_sauce',  label = 'Pizza Sauce',    weight = 100, type = 'item', image = 'pizza_sauce.png',  unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['pizza_cheese'] = { name = 'pizza_cheese', label = 'Shredded Cheese', weight = 120, type = 'item', image = 'pizza_cheese.png', unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['pepperoni']    = { name = 'pepperoni',    label = 'Pepperoni',      weight = 80,  type = 'item', image = 'pepperoni.png',    unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },

    -- ── tools ────────────────────────────────────────────────────────────────
    ['frosting']  = { name = 'frosting',  label = 'Frosting',  weight = 100, type = 'item', image = 'frosting.png',  unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['sprinkles'] = { name = 'sprinkles', label = 'Sprinkles', weight = 40,  type = 'item', image = 'sprinkles.png', unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['ketchup']   = { name = 'ketchup',   label = 'Ketchup',   weight = 100, type = 'item', image = 'ketchup.png',   unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['mustard']   = { name = 'mustard',   label = 'Mustard',   weight = 100, type = 'item', image = 'mustard.png',   unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
    ['mayo']      = { name = 'mayo',      label = 'Mayo',      weight = 100, type = 'item', image = 'mayo.png',      unique = false, useable = false, shouldClose = true, combinable = nil, description = '' },
