-- ═══════════════════════════════════════════════════════════════════
--  APEX RESTAURANT — ox_inventory item definitions
-- ═══════════════════════════════════════════════════════════════════
--  HOW TO USE
--  1. Open  ox_inventory/data/items.lua
--  2. Paste every line below INSIDE the  return { ... }  table
--     (before the final closing brace).
--  3. Copy ALL PNGs from  apex_restaurant/[IMAGES]/  into
--     ox_inventory/web/images/  (the filenames already match).
--  4. Restart ox_inventory.
--
--  Auto-generated from apex_restaurant/shared/items.lua — names, images
--  and categories always match the resource. 64 items total.
-- ═══════════════════════════════════════════════════════════════════

    -- ─── RAW INGREDIENTS ───
    ['fish'] = { label = 'Raw Fish', weight = 800, stack = true, close = false, description = '180 kcal', client = { image = 'fish.png' } },
    ['meat'] = { label = 'Raw Meat', weight = 800, stack = true, close = false, description = '250 kcal', client = { image = 'meat.png' } },

    -- ─── VEGETABLES ───
    ['bread_bun'] = { label = 'Burger Bun', weight = 120, stack = true, close = false, description = '220 kcal', client = { image = 'bread_bun.png' } },
    ['carrot'] = { label = 'Carrot', weight = 150, stack = true, close = false, description = '40 kcal', client = { image = 'carrot.png' } },
    ['corn'] = { label = 'Corn', weight = 150, stack = true, close = false, description = '90 kcal', client = { image = 'corn.png' } },
    ['cucumber'] = { label = 'Cucumber', weight = 150, stack = true, close = false, description = '15 kcal', client = { image = 'cucumber.png' } },
    ['lettuce'] = { label = 'Lettuce', weight = 150, stack = true, close = false, description = '15 kcal', client = { image = 'lettuce.png' } },
    ['onion'] = { label = 'Onion', weight = 150, stack = true, close = false, description = '40 kcal', client = { image = 'onion.png' } },
    ['potato'] = { label = 'Potato', weight = 150, stack = true, close = false, description = '80 kcal', client = { image = 'potato.png' } },
    ['soya'] = { label = 'Soya', weight = 150, stack = true, close = false, description = '170 kcal', client = { image = 'soya.png' } },
    ['tomato'] = { label = 'Tomato', weight = 150, stack = true, close = false, description = '20 kcal', client = { image = 'tomato.png' } },
    ['wheat'] = { label = 'Wheat', weight = 150, stack = true, close = false, description = '340 kcal', client = { image = 'wheat.png' } },

    -- ─── FRUITS ───
    ['apple'] = { label = 'Apple', weight = 150, stack = true, close = false, description = '50 kcal', client = { image = 'apple.png' } },
    ['banana'] = { label = 'Banana', weight = 150, stack = true, close = false, description = '90 kcal', client = { image = 'banana.png' } },
    ['lemon'] = { label = 'Lemon', weight = 150, stack = true, close = false, description = '30 kcal', client = { image = 'lemon.png' } },
    ['mango'] = { label = 'Mango', weight = 150, stack = true, close = false, description = '60 kcal', client = { image = 'mango.png' } },
    ['orange'] = { label = 'Orange', weight = 150, stack = true, close = false, description = '50 kcal', client = { image = 'orange.png' } },
    ['peach'] = { label = 'Peach', weight = 150, stack = true, close = false, description = '40 kcal', client = { image = 'peach.png' } },
    ['pear'] = { label = 'Pear', weight = 150, stack = true, close = false, description = '60 kcal', client = { image = 'pear.png' } },
    ['pineapple'] = { label = 'Pineapple', weight = 150, stack = true, close = false, description = '50 kcal', client = { image = 'pineapple.png' } },
    ['strawberry'] = { label = 'Strawberry', weight = 150, stack = true, close = false, description = '35 kcal', client = { image = 'strawberry.png' } },
    ['watermelon'] = { label = 'Watermelon', weight = 150, stack = true, close = false, description = '30 kcal', client = { image = 'watermelon.png' } },

    -- ─── PREPARED / GRILLED (station outputs) ───
    ['cutted_apple'] = { label = 'Cut Apple', weight = 150, stack = true, close = false, description = '50 kcal', client = { image = 'cutted_apple.png' } },
    ['cutted_banana'] = { label = 'Cut Banana', weight = 150, stack = true, close = false, description = '90 kcal', client = { image = 'cutted_banana.png' } },
    ['cutted_carrot'] = { label = 'Cut Carrot', weight = 150, stack = true, close = false, description = '40 kcal', client = { image = 'cutted_carrot.png' } },
    ['cutted_cucumber'] = { label = 'Cut Cucumber', weight = 150, stack = true, close = false, description = '15 kcal', client = { image = 'cutted_cucumber.png' } },
    ['cutted_fish'] = { label = 'Cut Fish', weight = 150, stack = true, close = false, description = '180 kcal', client = { image = 'cutted_fish.png' } },
    ['cutted_lemon'] = { label = 'Cut Lemon', weight = 150, stack = true, close = false, description = '30 kcal', client = { image = 'cutted_lemon.png' } },
    ['cutted_lettuce'] = { label = 'Cut Lettuce', weight = 150, stack = true, close = false, description = '15 kcal', client = { image = 'cutted_lettuce.png' } },
    ['cutted_mango'] = { label = 'Cut Mango', weight = 150, stack = true, close = false, description = '60 kcal', client = { image = 'cutted_mango.png' } },
    ['cutted_meat'] = { label = 'Cut Meat', weight = 150, stack = true, close = false, description = '250 kcal', client = { image = 'cutted_meat.png' } },
    ['cutted_onion'] = { label = 'Cut Onion', weight = 150, stack = true, close = false, description = '40 kcal', client = { image = 'cutted_onion.png' } },
    ['cutted_orange'] = { label = 'Cut Orange', weight = 150, stack = true, close = false, description = '50 kcal', client = { image = 'cutted_orange.png' } },
    ['cutted_peach'] = { label = 'Cut Peach', weight = 150, stack = true, close = false, description = '40 kcal', client = { image = 'cutted_peach.png' } },
    ['cutted_pear'] = { label = 'Cut Pear', weight = 150, stack = true, close = false, description = '60 kcal', client = { image = 'cutted_pear.png' } },
    ['cutted_pineapple'] = { label = 'Cut Pineapple', weight = 150, stack = true, close = false, description = '50 kcal', client = { image = 'cutted_pineapple.png' } },
    ['cutted_potato'] = { label = 'Cut Potato', weight = 150, stack = true, close = false, description = '80 kcal', client = { image = 'cutted_potato.png' } },
    ['cutted_soya'] = { label = 'Cut Soya', weight = 150, stack = true, close = false, description = '170 kcal', client = { image = 'cutted_soya.png' } },
    ['cutted_strawberry'] = { label = 'Cut Strawberry', weight = 150, stack = true, close = false, description = '35 kcal', client = { image = 'cutted_strawberry.png' } },
    ['cutted_tomato'] = { label = 'Cut Tomato', weight = 150, stack = true, close = false, description = '20 kcal', client = { image = 'cutted_tomato.png' } },
    ['cutted_watermelon'] = { label = 'Cut Watermelon', weight = 150, stack = true, close = false, description = '30 kcal', client = { image = 'cutted_watermelon.png' } },
    ['cutted_wheat'] = { label = 'Cut Wheat', weight = 150, stack = true, close = false, description = '340 kcal', client = { image = 'cutted_wheat.png' } },
    ['grilled_burger'] = { label = 'Grilled Patty', weight = 150, stack = true, close = false, description = '280 kcal', client = { image = 'grilled_burger.png' } },
    ['grilled_chicken_burger'] = { label = 'Grilled Chicken Patty', weight = 150, stack = true, close = false, description = '240 kcal', client = { image = 'grilled_chicken_burger.png' } },
    ['grilled_fish'] = { label = 'Grilled Fish Fillet', weight = 150, stack = true, close = false, description = '220 kcal', client = { image = 'grilled_fish.png' } },

    -- ─── DRINKS ───
    ['apple_juice'] = { label = 'Apple Juice', weight = 350, stack = true, close = true, description = '115 kcal', client = { image = 'apple_juice.png' } },
    ['coffe'] = { label = 'Coffee', weight = 350, stack = true, close = true, description = '5 kcal', client = { image = 'coffe.png' } },
    ['coffee_beans'] = { label = 'Coffee Beans', weight = 100, stack = true, close = true, description = '5 kcal', client = { image = 'coffee_beans.png' } },
    ['cola'] = { label = 'Cola', weight = 350, stack = true, close = true, description = '140 kcal', client = { image = 'cola.png' } },
    ['empty_cup'] = { label = 'Empty Cup', weight = 50, stack = true, close = true, description = '0 kcal', client = { image = 'empty_cup.png' } },
    ['milkshake'] = { label = 'Milkshake', weight = 350, stack = true, close = true, description = '350 kcal', client = { image = 'milkshake.png' } },
    ['orange_juice'] = { label = 'Orange Juice', weight = 350, stack = true, close = true, description = '110 kcal', client = { image = 'orange_juice.png' } },
    ['water'] = { label = 'Water', weight = 350, stack = true, close = true, description = '0 kcal', client = { image = 'water.png' } },

    -- ─── COOKED DISHES ───
    ['cheeseburger'] = { label = 'Cheeseburger', weight = 400, stack = true, close = true, description = '500 kcal', client = { image = 'cheeseburger.png' } },
    ['chicken_burger'] = { label = 'Chicken Burger', weight = 400, stack = true, close = true, description = '450 kcal', client = { image = 'chicken_burger.png' } },
    ['chicken_nuggets'] = { label = 'Chicken Nuggets', weight = 400, stack = true, close = true, description = '280 kcal', client = { image = 'chicken_nuggets.png' } },
    ['double_burger'] = { label = 'Double Burger', weight = 400, stack = true, close = true, description = '720 kcal', client = { image = 'double_burger.png' } },
    ['fish_burger'] = { label = 'Fish Burger', weight = 400, stack = true, close = true, description = '400 kcal', client = { image = 'fish_burger.png' } },
    ['fries'] = { label = 'Fries', weight = 400, stack = true, close = true, description = '320 kcal', client = { image = 'fries.png' } },
    ['onion_rings'] = { label = 'Onion Rings', weight = 400, stack = true, close = true, description = '280 kcal', client = { image = 'onion_rings.png' } },
    ['veggie_burger'] = { label = 'Veggie Burger', weight = 400, stack = true, close = true, description = '350 kcal', client = { image = 'veggie_burger.png' } },

    -- ─── UNIVERSAL (single-item shortcuts) ───
    ['restaurant_box'] = { label = 'Food Box', weight = 100, stack = true, close = false, description = '500 kcal', client = { image = 'restaurant_box.png' } },
    ['restaurant_food'] = { label = 'Food', weight = 100, stack = true, close = false, description = '300 kcal', client = { image = 'restaurant_food.png' } },
    ['restaurant_menu'] = { label = 'Menu', weight = 100, stack = true, close = false, description = '0 kcal', client = { image = 'restaurant_menu.png' } },

