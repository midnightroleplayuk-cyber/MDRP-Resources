--[[
    Apex Restaurant — Item catalogue
    Used by NPC shops, crafting, and the node editor item-picker.
    Add/remove items here freely; the editor reads this on load.

    Each entry: { label, image, price, calories, category }
        calories  — kcal value applied automatically wherever a calorie
                    is shown (Order Here, the ementa, the boss menu
                    builder) and whenever the calorie system kicks in
                    in-game (Config.calorieSystem). The boss never has
                    to type calories — they're sourced from here.
]]

Items = Items or {}

Items.catalogue = {
    -- ─── Raw ─────────────────────────────────────────────
    meat        = { label = 'Raw Meat',     image = 'meat.png',        price = 50,  calories = 250, category = 'raw' },
    fish        = { label = 'Raw Fish',     image = 'fish.png',        price = 50,  calories = 180, category = 'raw' },

    -- ─── Vegetables ──────────────────────────────────────
    onion       = { label = 'Onion',        image = 'onion.png',       price = 10,  calories =  40, category = 'vegetable' },
    carrot      = { label = 'Carrot',       image = 'carrot.png',      price = 10,  calories =  40, category = 'vegetable' },
    lettuce     = { label = 'Lettuce',      image = 'lettuce.png',     price = 10,  calories =  15, category = 'vegetable' },
    cucumber    = { label = 'Cucumber',     image = 'cucumber.png',    price = 10,  calories =  15, category = 'vegetable' },
    potato      = { label = 'Potato',       image = 'potato.png',      price = 10,  calories =  80, category = 'vegetable' },
    tomato      = { label = 'Tomato',       image = 'tomato.png',      price = 10,  calories =  20, category = 'vegetable' },
    corn        = { label = 'Corn',         image = 'corn.png',        price = 10,  calories =  90, category = 'vegetable' },
    soya        = { label = 'Soya',         image = 'soya.png',        price = 10,  calories = 170, category = 'vegetable' },
    wheat       = { label = 'Wheat',        image = 'wheat.png',       price = 10,  calories = 340, category = 'vegetable' },

    -- ─── Fruits ──────────────────────────────────────────
    apple       = { label = 'Apple',        image = 'apple.png',       price = 10,  calories =  50, category = 'fruit' },
    pear        = { label = 'Pear',         image = 'pear.png',        price = 10,  calories =  60, category = 'fruit' },
    lemon       = { label = 'Lemon',        image = 'lemon.png',       price = 10,  calories =  30, category = 'fruit' },
    banana      = { label = 'Banana',       image = 'banana.png',      price = 10,  calories =  90, category = 'fruit' },
    orange      = { label = 'Orange',       image = 'orange.png',      price = 10,  calories =  50, category = 'fruit' },
    peach       = { label = 'Peach',        image = 'peach.png',       price = 10,  calories =  40, category = 'fruit' },
    mango       = { label = 'Mango',        image = 'mango.png',       price = 15,  calories =  60, category = 'fruit' },
    strawberry  = { label = 'Strawberry',   image = 'strawberry.png',  price = 10,  calories =  35, category = 'fruit' },
    watermelon  = { label = 'Watermelon',   image = 'watermelon.png',  price = 15,  calories =  30, category = 'fruit' },
    pineapple   = { label = 'Pineapple',    image = 'pineapple.png',   price = 15,  calories =  50, category = 'fruit' },

    -- ─── Bakery / staples ────────────────────────────────
    bread_bun     = { label = 'Burger Bun',  image = 'bread_bun.png',     price = 5,  calories = 220, category = 'vegetable' },

    -- ─── Drinks ──────────────────────────────────────────
    coffee_beans = { label = 'Coffee Beans', image = 'coffee_beans.png', price = 20, calories =   5, category = 'drink' },
    empty_cup    = { label = 'Empty Cup',    image = 'empty_cup.png',    price =  1, calories =   0, category = 'drink' },
    cola         = { label = 'Cola',         image = 'cola.png',         price =  5, calories = 140, category = 'drink' },
    water        = { label = 'Water',        image = 'water.png',        price =  5, calories =   100, category = 'drink' },
    coffe        = { label = 'Coffee',       image = 'coffe.png',        price =  8, calories =   5, category = 'drink' },
    milkshake    = { label = 'Milkshake',    image = 'milkshake.png',    price = 12, calories = 350, category = 'drink' },
    orange_juice = { label = 'Orange Juice', image = 'orange_juice.png', price = 10, calories = 110, category = 'drink' },
    apple_juice  = { label = 'Apple Juice',  image = 'apple_juice.png',  price = 10, calories = 115, category = 'drink' },

    -- ─── Universal (single-item shortcuts) ───────────────
    restaurant_food = { label = 'Food',     image = 'restaurant_food.png', price = 1, calories = 300, category = 'universal' },
    restaurant_box  = { label = 'Food Box', image = 'restaurant_box.png',  price = 1, calories = 500, category = 'universal' },
    restaurant_menu = { label = 'Menu',     image = 'restaurant_menu.png', price = 1, calories =   0, category = 'universal' },

    -- ─── Prepared cuts (output of the Preparation Table) ─
    -- Cutting doesn't change kcal: each cut inherits its raw value.
    cutted_meat       = { label = 'Cut Meat',       image = 'cutted_meat.png',       price = 0, calories = 250, category = 'cutted' },
    cutted_fish       = { label = 'Cut Fish',       image = 'cutted_fish.png',       price = 0, calories = 180, category = 'cutted' },
    cutted_apple      = { label = 'Cut Apple',      image = 'cutted_apple.png',      price = 0, calories =  50, category = 'cutted' },
    cutted_banana     = { label = 'Cut Banana',     image = 'cutted_banana.png',     price = 0, calories =  90, category = 'cutted' },
    cutted_carrot     = { label = 'Cut Carrot',     image = 'cutted_carrot.png',     price = 0, calories =  40, category = 'cutted' },
    cutted_cucumber   = { label = 'Cut Cucumber',   image = 'cutted_cucumber.png',   price = 0, calories =  15, category = 'cutted' },
    cutted_lemon      = { label = 'Cut Lemon',      image = 'cutted_lemon.png',      price = 0, calories =  30, category = 'cutted' },
    cutted_lettuce    = { label = 'Cut Lettuce',    image = 'cutted_lettuce.png',    price = 0, calories =  15, category = 'cutted' },
    cutted_onion      = { label = 'Cut Onion',      image = 'cutted_onion.png',      price = 0, calories =  40, category = 'cutted' },
    cutted_orange     = { label = 'Cut Orange',     image = 'cutted_orange.png',     price = 0, calories =  50, category = 'cutted' },
    cutted_peach      = { label = 'Cut Peach',      image = 'cutted_peach.png',      price = 0, calories =  40, category = 'cutted' },
    cutted_pear       = { label = 'Cut Pear',       image = 'cutted_pear.png',       price = 0, calories =  60, category = 'cutted' },
    cutted_pineapple  = { label = 'Cut Pineapple',  image = 'cutted_pineapple.png',  price = 0, calories =  50, category = 'cutted' },
    cutted_potato     = { label = 'Cut Potato',     image = 'cutted_potato.png',     price = 0, calories =  80, category = 'cutted' },
    cutted_soya       = { label = 'Cut Soya',       image = 'cutted_soya.png',       price = 0, calories = 170, category = 'cutted' },
    cutted_strawberry = { label = 'Cut Strawberry', image = 'cutted_strawberry.png', price = 0, calories =  35, category = 'cutted' },
    cutted_tomato     = { label = 'Cut Tomato',     image = 'cutted_tomato.png',     price = 0, calories =  20, category = 'cutted' },
    cutted_mango      = { label = 'Cut Mango',      image = 'cutted_mango.png',      price = 0, calories =  60, category = 'cutted' },
    cutted_watermelon = { label = 'Cut Watermelon', image = 'cutted_watermelon.png', price = 0, calories =  30, category = 'cutted' },
    cutted_wheat      = { label = 'Cut Wheat',      image = 'cutted_wheat.png',      price = 0, calories = 340, category = 'cutted' },

    -- ─── Grilled patties (output of the Grill) ───────────
    -- The Grill produces patties; final burgers are then put together
    -- at the Assembly station with a bun + cut vegetables.
    grilled_burger         = { label = 'Grilled Patty',         image = 'grilled_burger.png',         price =  6, calories = 280, category = 'cutted' },
    grilled_chicken_burger = { label = 'Grilled Chicken Patty', image = 'grilled_chicken_burger.png', price =  6, calories = 240, category = 'cutted' },
    grilled_fish           = { label = 'Grilled Fish Fillet',   image = 'grilled_fish.png',           price =  7, calories = 220, category = 'cutted' },

    -- ─── Cooked dishes (output of stations) ──────────────
    cheeseburger    = { label = 'Cheeseburger',    image = 'cheeseburger.png',    price = 20, calories = 500, category = 'food' },
    chicken_burger  = { label = 'Chicken Burger',  image = 'chicken_burger.png',  price = 20, calories = 450, category = 'food' },
    chicken_nuggets = { label = 'Chicken Nuggets', image = 'chicken_nuggets.png', price = 15, calories = 280, category = 'food' },
    double_burger   = { label = 'Double Burger',   image = 'double_burger.png',   price = 25, calories = 720, category = 'food' },
    fish_burger     = { label = 'Fish Burger',     image = 'fish_burger.png',     price = 20, calories = 400, category = 'food' },
    veggie_burger   = { label = 'Veggie Burger',   image = 'veggie_burger.png',   price = 18, calories = 350, category = 'food' },
    fries           = { label = 'Fries',           image = 'fries.png',           price =  8, calories = 320, category = 'food' },
    onion_rings     = { label = 'Onion Rings',     image = 'onion_rings.png',     price =  8, calories = 280, category = 'food' },
}

function Items.get(name)   return Items.catalogue[name] end
function Items.label(name) local i = Items.catalogue[name]; return i and i.label or name end

-- Calorie lookup. Used everywhere a calorie value is needed (menu UI,
-- order card description, calorie system in-game). Falls back to 0
-- for items not in the catalogue.
function Items.calories(name)
    local i = Items.catalogue[name]
    return (i and tonumber(i.calories)) or 0
end

-- Returns the full URL for an item's icon.  Uses Config.itemImageBase
-- so the same data flows through whether you point at ox_inventory,
-- our bundled images, or a CDN.
-- For unknown items we follow the ox_inventory convention of
-- <name>.png so any item present in the user's inventory.lua just
-- works without needing to register it here.
function Items.image(name)
    local i    = Items.catalogue[name]
    local base = (Config and Config.itemImageBase) or 'nui://apex_restaurant/build/html/img/'
    if i and i.image then return base .. i.image end
    return base .. (name or 'restaurant_food') .. '.png'
end

-- Sorted array form (for the editor picker)
function Items.list()
    local out = {}
    for name, def in pairs(Items.catalogue) do
        out[#out+1] = {
            name     = name,
            label    = def.label,
            image    = Items.image(name),   -- full URL via Config.itemImageBase
            price    = def.price,
            calories = def.calories or 0,
            category = def.category,
        }
    end
    table.sort(out, function(a, b)
        if a.category == b.category then return a.label < b.label end
        return a.category < b.category
    end)
    return out
end
