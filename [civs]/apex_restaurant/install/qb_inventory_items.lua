-- ═══════════════════════════════════════════════════════════════════
--  APEX RESTAURANT — QBCore (qb-inventory) item definitions
-- ═══════════════════════════════════════════════════════════════════
--  HOW TO USE
--  1. Open  qb-core/shared/items.lua
--  2. Paste every line below INSIDE the  QBShared.Items = { ... }  table.
--  3. Copy ALL PNGs from  apex_restaurant/[IMAGES]/  into your inventory's
--     image folder (qb-inventory/html/images/  or  ox_inventory/web/images/).
--  4. Restart qb-core (and your inventory).
--
--  NOTE: Qbox (qbx_core) uses ox_inventory — use ox_inventory_items.lua instead.
--  Auto-generated from apex_restaurant/shared/items.lua. 64 items total.
-- ═══════════════════════════════════════════════════════════════════

    -- ─── RAW INGREDIENTS ───
    ['fish'] = { name = 'fish', label = 'Raw Fish', weight = 800, type = 'item', image = 'fish.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '180 kcal' },
    ['meat'] = { name = 'meat', label = 'Raw Meat', weight = 800, type = 'item', image = 'meat.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '250 kcal' },

    -- ─── VEGETABLES ───
    ['bread_bun'] = { name = 'bread_bun', label = 'Burger Bun', weight = 120, type = 'item', image = 'bread_bun.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '220 kcal' },
    ['carrot'] = { name = 'carrot', label = 'Carrot', weight = 150, type = 'item', image = 'carrot.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '40 kcal' },
    ['corn'] = { name = 'corn', label = 'Corn', weight = 150, type = 'item', image = 'corn.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '90 kcal' },
    ['cucumber'] = { name = 'cucumber', label = 'Cucumber', weight = 150, type = 'item', image = 'cucumber.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '15 kcal' },
    ['lettuce'] = { name = 'lettuce', label = 'Lettuce', weight = 150, type = 'item', image = 'lettuce.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '15 kcal' },
    ['onion'] = { name = 'onion', label = 'Onion', weight = 150, type = 'item', image = 'onion.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '40 kcal' },
    ['potato'] = { name = 'potato', label = 'Potato', weight = 150, type = 'item', image = 'potato.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '80 kcal' },
    ['soya'] = { name = 'soya', label = 'Soya', weight = 150, type = 'item', image = 'soya.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '170 kcal' },
    ['tomato'] = { name = 'tomato', label = 'Tomato', weight = 150, type = 'item', image = 'tomato.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '20 kcal' },
    ['wheat'] = { name = 'wheat', label = 'Wheat', weight = 150, type = 'item', image = 'wheat.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '340 kcal' },

    -- ─── FRUITS ───
    ['apple'] = { name = 'apple', label = 'Apple', weight = 150, type = 'item', image = 'apple.png', unique = false, useable = true, shouldClose = false, combinable = nil, description = '50 kcal' },
    ['banana'] = { name = 'banana', label = 'Banana', weight = 150, type = 'item', image = 'banana.png', unique = false, useable = true, shouldClose = false, combinable = nil, description = '90 kcal' },
    ['lemon'] = { name = 'lemon', label = 'Lemon', weight = 150, type = 'item', image = 'lemon.png', unique = false, useable = true, shouldClose = false, combinable = nil, description = '30 kcal' },
    ['mango'] = { name = 'mango', label = 'Mango', weight = 150, type = 'item', image = 'mango.png', unique = false, useable = true, shouldClose = false, combinable = nil, description = '60 kcal' },
    ['orange'] = { name = 'orange', label = 'Orange', weight = 150, type = 'item', image = 'orange.png', unique = false, useable = true, shouldClose = false, combinable = nil, description = '50 kcal' },
    ['peach'] = { name = 'peach', label = 'Peach', weight = 150, type = 'item', image = 'peach.png', unique = false, useable = true, shouldClose = false, combinable = nil, description = '40 kcal' },
    ['pear'] = { name = 'pear', label = 'Pear', weight = 150, type = 'item', image = 'pear.png', unique = false, useable = true, shouldClose = false, combinable = nil, description = '60 kcal' },
    ['pineapple'] = { name = 'pineapple', label = 'Pineapple', weight = 150, type = 'item', image = 'pineapple.png', unique = false, useable = true, shouldClose = false, combinable = nil, description = '50 kcal' },
    ['strawberry'] = { name = 'strawberry', label = 'Strawberry', weight = 150, type = 'item', image = 'strawberry.png', unique = false, useable = true, shouldClose = false, combinable = nil, description = '35 kcal' },
    ['watermelon'] = { name = 'watermelon', label = 'Watermelon', weight = 150, type = 'item', image = 'watermelon.png', unique = false, useable = true, shouldClose = false, combinable = nil, description = '30 kcal' },

    -- ─── PREPARED / GRILLED (station outputs) ───
    ['cutted_apple'] = { name = 'cutted_apple', label = 'Cut Apple', weight = 150, type = 'item', image = 'cutted_apple.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '50 kcal' },
    ['cutted_banana'] = { name = 'cutted_banana', label = 'Cut Banana', weight = 150, type = 'item', image = 'cutted_banana.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '90 kcal' },
    ['cutted_carrot'] = { name = 'cutted_carrot', label = 'Cut Carrot', weight = 150, type = 'item', image = 'cutted_carrot.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '40 kcal' },
    ['cutted_cucumber'] = { name = 'cutted_cucumber', label = 'Cut Cucumber', weight = 150, type = 'item', image = 'cutted_cucumber.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '15 kcal' },
    ['cutted_fish'] = { name = 'cutted_fish', label = 'Cut Fish', weight = 150, type = 'item', image = 'cutted_fish.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '180 kcal' },
    ['cutted_lemon'] = { name = 'cutted_lemon', label = 'Cut Lemon', weight = 150, type = 'item', image = 'cutted_lemon.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '30 kcal' },
    ['cutted_lettuce'] = { name = 'cutted_lettuce', label = 'Cut Lettuce', weight = 150, type = 'item', image = 'cutted_lettuce.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '15 kcal' },
    ['cutted_mango'] = { name = 'cutted_mango', label = 'Cut Mango', weight = 150, type = 'item', image = 'cutted_mango.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '60 kcal' },
    ['cutted_meat'] = { name = 'cutted_meat', label = 'Cut Meat', weight = 150, type = 'item', image = 'cutted_meat.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '250 kcal' },
    ['cutted_onion'] = { name = 'cutted_onion', label = 'Cut Onion', weight = 150, type = 'item', image = 'cutted_onion.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '40 kcal' },
    ['cutted_orange'] = { name = 'cutted_orange', label = 'Cut Orange', weight = 150, type = 'item', image = 'cutted_orange.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '50 kcal' },
    ['cutted_peach'] = { name = 'cutted_peach', label = 'Cut Peach', weight = 150, type = 'item', image = 'cutted_peach.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '40 kcal' },
    ['cutted_pear'] = { name = 'cutted_pear', label = 'Cut Pear', weight = 150, type = 'item', image = 'cutted_pear.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '60 kcal' },
    ['cutted_pineapple'] = { name = 'cutted_pineapple', label = 'Cut Pineapple', weight = 150, type = 'item', image = 'cutted_pineapple.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '50 kcal' },
    ['cutted_potato'] = { name = 'cutted_potato', label = 'Cut Potato', weight = 150, type = 'item', image = 'cutted_potato.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '80 kcal' },
    ['cutted_soya'] = { name = 'cutted_soya', label = 'Cut Soya', weight = 150, type = 'item', image = 'cutted_soya.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '170 kcal' },
    ['cutted_strawberry'] = { name = 'cutted_strawberry', label = 'Cut Strawberry', weight = 150, type = 'item', image = 'cutted_strawberry.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '35 kcal' },
    ['cutted_tomato'] = { name = 'cutted_tomato', label = 'Cut Tomato', weight = 150, type = 'item', image = 'cutted_tomato.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '20 kcal' },
    ['cutted_watermelon'] = { name = 'cutted_watermelon', label = 'Cut Watermelon', weight = 150, type = 'item', image = 'cutted_watermelon.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '30 kcal' },
    ['cutted_wheat'] = { name = 'cutted_wheat', label = 'Cut Wheat', weight = 150, type = 'item', image = 'cutted_wheat.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '340 kcal' },
    ['grilled_burger'] = { name = 'grilled_burger', label = 'Grilled Patty', weight = 150, type = 'item', image = 'grilled_burger.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '280 kcal' },
    ['grilled_chicken_burger'] = { name = 'grilled_chicken_burger', label = 'Grilled Chicken Patty', weight = 150, type = 'item', image = 'grilled_chicken_burger.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '240 kcal' },
    ['grilled_fish'] = { name = 'grilled_fish', label = 'Grilled Fish Fillet', weight = 150, type = 'item', image = 'grilled_fish.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '220 kcal' },

    -- ─── DRINKS ───
    ['apple_juice'] = { name = 'apple_juice', label = 'Apple Juice', weight = 350, type = 'item', image = 'apple_juice.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '115 kcal' },
    ['coffe'] = { name = 'coffe', label = 'Coffee', weight = 350, type = 'item', image = 'coffe.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '5 kcal' },
    ['coffee_beans'] = { name = 'coffee_beans', label = 'Coffee Beans', weight = 100, type = 'item', image = 'coffee_beans.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '5 kcal' },
    ['cola'] = { name = 'cola', label = 'Cola', weight = 350, type = 'item', image = 'cola.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '140 kcal' },
    ['empty_cup'] = { name = 'empty_cup', label = 'Empty Cup', weight = 50, type = 'item', image = 'empty_cup.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '0 kcal' },
    ['milkshake'] = { name = 'milkshake', label = 'Milkshake', weight = 350, type = 'item', image = 'milkshake.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '350 kcal' },
    ['orange_juice'] = { name = 'orange_juice', label = 'Orange Juice', weight = 350, type = 'item', image = 'orange_juice.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '110 kcal' },
    ['water'] = { name = 'water', label = 'Water', weight = 350, type = 'item', image = 'water.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '0 kcal' },

    -- ─── COOKED DISHES ───
    ['cheeseburger'] = { name = 'cheeseburger', label = 'Cheeseburger', weight = 400, type = 'item', image = 'cheeseburger.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '500 kcal' },
    ['chicken_burger'] = { name = 'chicken_burger', label = 'Chicken Burger', weight = 400, type = 'item', image = 'chicken_burger.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '450 kcal' },
    ['chicken_nuggets'] = { name = 'chicken_nuggets', label = 'Chicken Nuggets', weight = 400, type = 'item', image = 'chicken_nuggets.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '280 kcal' },
    ['double_burger'] = { name = 'double_burger', label = 'Double Burger', weight = 400, type = 'item', image = 'double_burger.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '720 kcal' },
    ['fish_burger'] = { name = 'fish_burger', label = 'Fish Burger', weight = 400, type = 'item', image = 'fish_burger.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '400 kcal' },
    ['fries'] = { name = 'fries', label = 'Fries', weight = 400, type = 'item', image = 'fries.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '320 kcal' },
    ['onion_rings'] = { name = 'onion_rings', label = 'Onion Rings', weight = 400, type = 'item', image = 'onion_rings.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '280 kcal' },
    ['veggie_burger'] = { name = 'veggie_burger', label = 'Veggie Burger', weight = 400, type = 'item', image = 'veggie_burger.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = '350 kcal' },

    -- ─── UNIVERSAL (single-item shortcuts) ───
    ['restaurant_box'] = { name = 'restaurant_box', label = 'Food Box', weight = 100, type = 'item', image = 'restaurant_box.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '500 kcal' },
    ['restaurant_food'] = { name = 'restaurant_food', label = 'Food', weight = 100, type = 'item', image = 'restaurant_food.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '300 kcal' },
    ['restaurant_menu'] = { name = 'restaurant_menu', label = 'Menu', weight = 100, type = 'item', image = 'restaurant_menu.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = '0 kcal' },

