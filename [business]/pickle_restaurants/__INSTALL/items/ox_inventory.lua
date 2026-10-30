-- pickle_restaurants — item definitions for ox_inventory
-- Paste these entries into ox_inventory/data/items.lua
--
-- This is the COMPLETE set the resource needs: the handout items players receive
-- (bag / meal / takeout box / Restaurant Item / receipt) plus every raw ingredient & input the kitchen
-- consumes. Cooked/assembled foods (burger, fries, cooked patty, pizza, cake…) are
-- intentionally NOT here — they live only in the per-player cooked-items tray and
-- get packaged into a bag, meal tray, or pizza box at the prep station, so they
-- never enter real inventory. See install/README.md.

    -- ── handout items (what leaves the kitchen) ──────────────────────────────
    -- The BAG and the MEAL are VESSELS, not single foods: each carries the list of
    -- things packed into it as slot metadata, and the player eats them one at a
    -- time. So they must NOT stack (two bags are never the same bag) and ox must
    -- NOT consume them itself — using one calls this resource, which opens the
    -- bag's contents menu (or lays the meal out on the table you're sitting at)
    -- and removes the vessel only once the last item inside it is eaten.
    ['restaurant_bag'] = {
        label  = 'Restaurant Bag',
        weight = 800,
        stack  = false,
        close  = true,
        consume = 0,
        server = { export = 'pickle_restaurants.useItem' },
    },
    ['meal'] = {
        label  = 'Meal',
        weight = 800,
        stack  = false,
        close  = true,
        consume = 0,
        server = { export = 'pickle_restaurants.useItem' },
    },
    -- Every "bag kind" food (soup, salad — anything made in the takeout box)
    -- collects as this ONE item, with the food's identity in its metadata; its
    -- label and image are stamped per instance from the food's display item.
    --
    -- It is a VESSEL too, and must be declared like the bag and the meal above:
    -- `consume = 0` + the export, with NO client status/anim. With `consume = 1`
    -- and a client status block, ox eats the box ITSELF — applies its own hunger,
    -- plays its own clip and destroys the item — so this resource never sees the
    -- use, and a box could never be set down on a table to eat from. The hunger a
    -- box restores is authored on the FOOD (its `consume` block), not here, which
    -- is the whole reason ox must not apply a number of its own.
    ['takeout_box'] = {
        label  = 'Takeout Box',
        weight = 500,
        stack  = false,
        close  = true,
        consume = 0,
        server = { export = 'pickle_restaurants.useItem' },
    },
    -- THE RESTAURANT ITEM: ONE serving of anything the kitchen makes. Every poured
    -- drink is this item with its flavor in the metadata, AND every cooked product a
    -- cook pockets off the tray (a patty, a burger, a pizza, a frosted cake) is this
    -- item with the product + its build stack in the metadata. That is what lets
    -- cooked food be handed to another worker at all: cooked foods have no inventory
    -- items of their own and never will (one-item consolidation), so before this they
    -- could only leave a kitchen packed inside a meal, a bag or a box.
    --
    -- REPLACES the old `drink` item — if you are upgrading, keep `drink` installed
    -- only until your kitchens are empty of them.
    --
    -- A VESSEL like the three above and declared the same way: `consume = 0` + the
    -- export, with NO client status/anim. With ox's own status block ox would eat the
    -- item itself — its own hunger/thirst number, its own generic prop, the item
    -- destroyed — so this resource would never see the use, and a serving could never
    -- be eaten as the food it is (or sipped from the restaurant's branded cup). What
    -- a serving restores is authored on the FOOD (its `consume` block), never here.
    ['restaurant_item'] = {
        label  = 'Restaurant Item',
        weight = 300,
        stack  = false,
        close  = true,
        consume = 0,
        server = { export = 'pickle_restaurants.useItem' },
    },
    ['restaurant_receipt'] = {
        label  = 'Receipt',
        weight = 10,
        stack  = true,
        close  = true,
    },

    -- ── raw cook inputs (bought as supplies, cooked at a station) ─────────────
    ['raw_beef_patty']    = { label = 'Raw Beef Patty',    weight = 220, stack = true, close = true },
    ['raw_chicken_patty'] = { label = 'Raw Chicken Patty', weight = 220, stack = true, close = true },
    ['raw_drumstick']     = { label = 'Raw Drumstick',     weight = 220, stack = true, close = true },
    ['raw_fries']         = { label = 'Raw Cut Fries',     weight = 180, stack = true, close = true },
    ['raw_nuggets']       = { label = 'Raw Nuggets',       weight = 180, stack = true, close = true },
    ['raw_doughnut']      = { label = 'Raw Doughnut',      weight = 150, stack = true, close = true },
    ['empty_cup']         = { label = 'Empty Cup',         weight = 100, stack = true, close = true },
    ['baking_mix']        = { label = 'Baking Mix',        weight = 400, stack = true, close = true },

    -- ── assembly ingredients (dropped onto builds at the prep table) ──────────
    ['bun']          = { label = 'Burger Bun',     weight = 120, stack = true, close = true },
    ['cheese']       = { label = 'Cheese Slice',   weight = 60,  stack = true, close = true },
    ['lettuce']      = { label = 'Lettuce',        weight = 80,  stack = true, close = true },
    ['tomato']       = { label = 'Tomato',         weight = 90,  stack = true, close = true },
    ['pickle']       = { label = 'Pickle',         weight = 40,  stack = true, close = true },
    ['pizza_dough']  = { label = 'Pizza Dough',    weight = 300, stack = true, close = true },
    ['pizza_sauce']  = { label = 'Pizza Sauce',    weight = 100, stack = true, close = true },
    ['pizza_cheese'] = { label = 'Shredded Cheese', weight = 120, stack = true, close = true },
    ['pepperoni']    = { label = 'Pepperoni',      weight = 80,  stack = true, close = true },

    -- ── tools (squeeze bottles, decorating tubes — consumed as applied) ───────
    ['frosting']  = { label = 'Frosting',  weight = 100, stack = true, close = true },
    ['sprinkles'] = { label = 'Sprinkles', weight = 40,  stack = true, close = true },
    ['ketchup']   = { label = 'Ketchup',   weight = 100, stack = true, close = true },
    ['mustard']   = { label = 'Mustard',   weight = 100, stack = true, close = true },
    ['mayo']      = { label = 'Mayo',      weight = 100, stack = true, close = true },
