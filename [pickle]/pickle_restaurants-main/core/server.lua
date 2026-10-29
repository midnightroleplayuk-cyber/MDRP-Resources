-- =============================================
--  pickle_restaurants | core/server.lua
--  Database bootstrap, seeding, caches & shared server API.
--
--  Everything is database-driven. On first boot every table is created with
--  CREATE TABLE IF NOT EXISTS and sensible defaults (settings + cookable
--  recipes for the streamed food models) are seeded. There is no config.lua.
-- =============================================

RestaurantCache = {}   -- [id]            = row (json fields decoded)
PropCache       = {}    -- [id]            = prop row
RecipeCache     = {}    -- array of recipe rows
RecipeByInput   = {}    -- [input_item]    = recipe
RecipeByOutput  = {}    -- [output_cooked_item] = recipe (reverse map for cost tracing)
StockCache      = {}    -- [restaurantId][item] = count
TrayCache       = {}    -- [restaurantId][identifier][item] = { item, count, metas } (metas: one build stack — or false — per counted instance; TraySig(meta) addresses a variation)
SettingsCache   = {}    -- [key]           = decoded value
ItemImageCache  = {}    -- [item]          = custom image url (admin-set override, from the `item_images` setting; consulted first by GetItemImage so tray-only products — burger, burnt patty — that have no inventory image can still show art everywhere)
OrderCache      = {}    -- [restaurantId][orderId] = open POS ticket row (lines decoded)
NextTicket      = {}    -- [restaurantId]  = next kitchen ticket number
OrdersDirty     = {}    -- [restaurantId]  = true when the pool changed → register needs a live SyncOrders (coalesced flusher in modules/sales)
PendingRefunds  = {}    -- [rowId]         = unpaid refund owed to an OFFLINE customer (see RefundOrder / the settle thread)
TipCache        = {}    -- [restaurantId]  = UNPAID tip total (the pool; the rows are the truth, this is the running sum)
-- (A booking's SEATS and GUESTS are cached by modules/phone, on the booking row
-- itself — that module owns every write to both hold tables, so a second cache of
-- them here would be a second truth, not a shortcut. See the reservations section
-- near the bottom of this file.)

-- `manage_payroll` is the new one: paying the tip pool out and running salaries is a
-- money action a boss may want to delegate without handing over the whole balance.
-- A boss/owner/admin holds it implicitly through ALL_PERMS.
PERMISSIONS = { "cook", "sell", "manage_menu", "manage_props", "manage_employees", "view_finances", "manage_balance", "manage_stock", "manage_payroll" }
ALL_PERMS   = {}
for _, p in ipairs(PERMISSIONS) do ALL_PERMS[p] = true end

-- ─── coalesced confirmations ─────────────────────────────────────────────────

-- ONE PANEL EDIT IS ONE CONFIRMATION, however many writes it took.
-- There are no save buttons by design: every panel group auto-saves on its own
-- debounce, so a single act — editing one recipe — commonly lands as three
-- INDEPENDENT writes (the foods array, the item's custom image, its ingredient
-- cost), each an honest save with its own callback. Notifying per write made that
-- read as "Settings saved." three times over, which is noise about the panel's
-- internals rather than news about the edit.
--
-- So the CONFIRMATION is throttled, never the save. Leading edge: the first write
-- of a burst confirms immediately (feedback stays instant) and further ones under
-- the same key are silent for `ms`. The panel's own inline "Saving…/Saved" hint is
-- still per-group, so nothing is hidden — this only stops the toast repeating.
local notifyAt = {}
local NOTIFY_THROTTLE_MS = 2500

-- Confirm `text` to `src`, at most once per `key` per `ms`. Use for anything an
-- auto-saving panel can fire several of in one gesture; use ShowNotification
-- directly for one-off news (a refusal, a purchase, a payout).
function ShowNotificationOnce(src, key, text, ms)
    src = tonumber(src); if not src then return end
    local k = src .. "|" .. key
    local now = GetGameTimer()
    local last = notifyAt[k]
    if last and now - last < (ms or NOTIFY_THROTTLE_MS) then return end
    notifyAt[k] = now
    ShowNotification(src, text)
end

AddEventHandler("playerDropped", function()
    local src = source
    for k in pairs(notifyAt) do
        if k:sub(1, #tostring(src) + 1) == src .. "|" then notifyAt[k] = nil end
    end
end)

-- ─── json helpers ────────────────────────────────────────────────────────────

local function dec(v, default)
    if type(v) == "table" then return v end
    if type(v) == "string" and v ~= "" then
        local ok, res = pcall(json.decode, v)
        if ok and res ~= nil then return res end
    end
    return default
end

-- ─── settings ────────────────────────────────────────────────────────────────

function GetSetting(key, default)
    local v = SettingsCache[key]
    if v == nil then return default end
    return v
end

function SetSetting(key, value)
    SettingsCache[key] = value
    MySQL.update("INSERT INTO pickle_restaurant_settings (setting_key, setting_value) VALUES (?, ?) "
        .. "ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value)", { key, json.encode(value) })
    -- Anything keyed to a CONFIGURABLE setting re-reads it here (the usable-item
    -- registration in modules/consume watches bag_item / meal_item).
    TriggerEvent("pickle_restaurants:settingChanged", key, value)
end

local DEFAULT_SETTINGS = {
    admin_command   = "restaurants",
    -- The admin panel's OWN NUI theme (skins /restaurants itself — distinct from
    -- any restaurant's franchise theme). Same seed shape as a restaurant theme:
    -- { primary #rrggbb, mode dark|paper, radius sharp|soft|round }. Edited in
    -- Settings → Appearance; the whole palette is derived from it on the client.
    app_theme       = { primary = "#ff7a2e", mode = "dark", radius = "soft" },
    -- The companion phone app's theme (ONE global look for every player's phone —
    -- NOT per-restaurant; the phone deliberately keeps a single consistent skin so it
    -- reads like a real delivery app rather than reskinning per storefront). Same seed
    -- shape as app_theme; edited in Settings → Appearance, derived on the client.
    phone_theme     = { primary = "#ff7a2e", mode = "dark", radius = "round" },
    currency        = "money",
    -- Admin-set custom images for items, keyed by item name → { url, crop? }. Lets a
    -- server give proper art to tray-only PRODUCTS that aren't real inventory items
    -- (a burger, a burnt patty, a cooked pizza…) and so have no catalogue image. The
    -- url overrides GetItemImage for that item EVERYWHERE it's shown (POS, kitchen,
    -- boards, phone). Rendered as a plain cover image on live surfaces; the crop is
    -- kept for the editor's WYSIWYG preview (mirrors how brand images behave). Edited
    -- on the item thumbnails in the Food & Drinks / Ingredients admin tabs.
    item_images     = {},
    starting_balance = 0,
    default_commission = 10,
    -- Menu pricing. A sellable's DEFAULT price is what its ingredients cost the
    -- restaurant to buy (see ingredient_costs) marked up by this profit margin.
    -- A boss can still override any price per-restaurant; an unset price falls
    -- back to this computed default so items are orderable out of the box.
    profit_margin   = 40, -- percent added on top of ingredient cost
    -- What each raw ingredient costs the restaurant to buy from the Supplies tab.
    -- Drives both restocking (money out of the restaurant balance) and the
    -- computed default menu price. Keyed by raw item; anything not listed costs 0
    -- (a product made only from unpriced ingredients defaults to $0 = not
    -- auto-orderable until the boss prices it). Admin-editable in the panel.
    ingredient_costs = {
        raw_drumstick = 4, raw_fries = 2, raw_nuggets = 3,
        raw_beef_patty = 5, raw_chicken_patty = 5,
        raw_doughnut = 2,
        -- raw_cake / raw_cookie are no longer bought directly: they're produced by
        -- rubbing `baking_mix` (below) into a cake tin / cookie tray. Their menu-price
        -- cost traces through the mix in ResolveItemCost.
        baking_mix = 4,
        pizza_dough = 3, pizza_sauce = 1, pizza_cheese = 2, pepperoni = 2,
        bun = 1, cheese = 1, lettuce = 1, tomato = 1, pickle = 1,
        empty_cup = 1, frosting = 2, sprinkles = 1,
        ketchup = 2, mustard = 2, mayo = 2,
    },
    -- Fallback melt duration for a melting topping whose ingredient entry has no
    -- melt_ms of its own (the seeded cheese carries 8000 directly; this survives
    -- for configs written before per-ingredient melts).
    cheese_melt_ms  = 8000,
    -- Decodes tray/inventory metadata written BEFORE toppings were generic: a bare
    -- numeric `cheese` field on a layer/row is resolved to this ingredient. Seed
    -- data only — gameplay code never names the item itself.
    -- Manual per-model stacking corrections applied on top of the measured model
    -- heights (client cooking render). sink = shift a layer's seat (negative sinks
    -- it into the layer below, dragging everything above it along); rise = REPLACE
    -- the measured layer height. Synced to the client; TUNE IN-GAME.
    stack_tweaks = {
        -- the shredded-cheese sheet reads a touch high over the sauce on a pizza
        ["pickle_pizza_sauce_01"]  = { sink = -0.004 },
        ["pickle_pizza_cheese_01"] = { sink = -0.004 },
        ["pickle_pizza_cheese_02"] = { sink = -0.004 },
        ["pickle_patty_beef_02"] = { sink = -1.0 },
    },
    -- WHERE THE SERVINGS SIT IN A BAKING CONTAINER, authored per container model and
    -- keyed by the recipe's `container_model`. A tray's wells are evenly spaced — that
    -- is what a tray IS — so this is a PITCH, not a seat list: `cols` across, then the
    -- centre-to-centre gap between neighbours in metres. Rows are however many the batch
    -- needs. The grid is centred on the container (a short last row centres itself), and
    -- `offset_x`/`offset_y` nudge the whole thing for a tray whose wells aren't centred
    -- on its own origin.
    --   spread_x / offset_x — ACROSS the tray
    --   spread_y / offset_y — ALONG it
    -- Tray-local metres, rotated to whatever heading the tray is drawn at, so ONE
    -- authored layout is what the prep table, the oven rack, the drag preview and a tray
    -- carried in the hand all read.
    --
    -- These numbers are the answer, not a hint: no formula over the prop's bounding box
    -- finds where the artist put the wells. Deriving the grid from the model's extents is
    -- only the FALLBACK for a container with no entry here, so a new tray still renders
    -- something sane before anyone sits down to measure it.
    -- Synced to the client; edited in Settings → Baking trays.
    bake_slots = {
        -- the six-cookie tray: 3 across, 2 deep
        ["pickle_cookie_tray_01"] = { cols = 3, spread_x = 0.0625, spread_y = 0.0625 },
    },
    -- Global default freshness window (seconds) for collected cooked items in the
    -- tray before they spoil and are swept. Default 900 = 15 minutes; 0 = never
    -- expire. A recipe's own `expire_seconds` overrides this per item (NULL on a
    -- recipe = use this default).
    cooked_expire_seconds = 900,
    -- The inventory item a serving-tray arrangement becomes at kitchen prep. The
    -- meal's metadata records every item WITH its position on the tray, so it
    -- re-renders 1:1 wherever it's set back down. This is a HANDOUT item (shipped in
    -- the install/ folder) — never a requirement to use the tray; only moving a
    -- meal into the real inventory needs it installed.
    meal_item       = "meal",
    -- THE RESTAURANT ITEM — one inventory item for ONE SERVING of anything the
    -- kitchen makes. It is the one-item consolidation rule taken to its end: a
    -- poured drink, a cooked patty, an assembled burger, a frosted cake are all
    -- THIS item, told apart by a single build-stack meta layer naming what it is
    -- ({ { item = <drinks[].output key | product item>, stack = <its own build
    -- stack> } }) — the exact shape the drink item used, so a flavor still resolves
    -- its cup and a product still resolves its whole tower.
    --
    -- It REPLACES the old `drink_item`: one item to install, one to explain, and —
    -- the reason it exists — the only way a cooked food can leave the kitchen as a
    -- thing you can hand to another worker. Most cooked products are tray-only (they
    -- have no inventory item of their own and never will, per one-item
    -- consolidation), so before this a burger could only reach a pocket packed
    -- inside a meal, a bag or a box.
    --
    -- A HANDOUT item like the other vessels: shipped in `__INSTALL/items/`, never a
    -- requirement. Without it installed the kitchen still works — the tray simply
    -- can't be cashed out, exactly as before.
    serving_item    = "restaurant_item",
    -- The inventory item a paying customer receives when a POS order is rung up —
    -- its slot metadata carries the order id/ticket so completion can verify the
    -- holder. Like meal_item it's a HANDOUT item (shipped in install/); if the item
    -- isn't installed the POS still works, just without a physical receipt.
    receipt_item    = "restaurant_receipt",
    -- ── the two takeaway vessels ──────────────────────────────────────────────
    -- TAKEOUT BOX — where every `kind = "bag"` FOOD (soup, salad… the non-stack
    -- miscellaneous foods that have no build tower of their own) is made. The
    -- box is a base + hinged-lid pair on the prep table (the pizza box's
    -- machinery): drop the food's components in, "Create <food>", and the
    -- contents become ONE `box_item` carrying the food identity (`id`) + its
    -- component layers as build-stack metadata, exactly like meal_item /
    -- serving_item. Component prop models are OPTIONAL — a component with no model
    -- (via prep_models/itemModel) shows the NUI pill instead of a 3D prop; what a
    -- MADE box shows is the food's OWN authored picture (`image`), drawn as a
    -- textured quad inside the open box (see modules/quad).
    box_item        = "takeout_box",
    box_base_model  = "pickle_takeout_box_01",
    box_lid_model   = "pickle_takeout_box_02",
    -- RESTAURANT BAG — the TAKEOUT CARRIER (the eat-in serving tray's sibling).
    -- Drop finished foods and drinks into the bag on the prep table, "Bag It Up",
    -- and they become ONE `bag_item` whose build-stack metadata lists everything
    -- inside it. The customer USES the bag (usable item), picks a thing out of it,
    -- eats/drinks that one, and the bag disappears once it's empty. `bag_model` is
    -- both the prep-table vessel and the model a finished/held bag renders as.
    bag_item        = "restaurant_bag",
    bag_model       = "pickle_restaurant_bag_01",
    -- FALLBACK consume values for a food that doesn't set its own: how much of the
    -- framework's needs bars ONE serving restores (0-100 percentages — the bridge
    -- scales them, see Nourish) and which animation it's eaten with. Every food can
    -- override all three in the menu editor ("When eaten").
    consume         = { hunger = 25, thirst = 0, anim = "eat_burger" },
    -- The eat/drink ANIMATIONS a food can be assigned, as a pickable list (seeded
    -- with these defaults; an admin can retune them or add their own). `prop` is a
    -- LAST-RESORT prop, held for the duration and deleted after — a serving is
    -- normally eaten with the food's own props (see LayerHeldProps). Which HAND, and
    -- at what offset, is a property of the clip, not of the entry (HOLD_BY_DICT in
    -- modules/consume/client.lua): the scenario-library idles below are right-handed,
    -- the two mp_player_int* clips left. `ms` is how long one serving takes.
    -- Referenced by id from a food's `consume.anim`.
    consume_anims   = {
        { id = "eat_burger", label = "Eating (two-handed)",
          dict = "mp_player_inteat@burger", clip = "mp_player_int_eat_burger",
          prop = "prop_cs_burger_01", ms = 3000 },
        { id = "eat_snack", label = "Eating (snack)",
          dict = "amb@code_human_wander_eating_donut@male@idle_a", clip = "idle_c",
          prop = "prop_amb_donut", ms = 2500 },
        { id = "drink_bottle", label = "Drinking (bottle)",
          dict = "mp_player_intdrink", clip = "loop_bottle",
          prop = "prop_ld_flow_bottle", ms = 3000 },
        { id = "drink_cup", label = "Drinking (cup)",
          dict = "amb@world_human_drinking@coffee@male@idle_a", clip = "idle_c",
          prop = "p_amb_coffeecup_01", ms = 3500 },
    },
    blip            = { sprite = 93, color = 1, scale = 0.8, enabled = true },
    -- ── jobs, ranks & payroll ─────────────────────────────────────────────────
    -- A restaurant is STAFFED BY A JOB (its `metadata.job`), and what each GRADE of
    -- that job may do is the restaurant's own `metadata.ranks`. There is no employee
    -- roster to keep in step with the framework's any more — the job IS the roster.
    --
    -- `jobs` only matters on a frameworkless server, where this resource is the job
    -- system (bridge/custom reads it through StandaloneJobs; the admin panel edits
    -- it). With ESX/QB/QBox running, the framework's own job list is used and this
    -- stays empty.
    jobs            = {},
    -- What a NON-BOSS grade is given when a job is first assigned to a restaurant
    -- (SetRestaurantJob seeds one rank per grade). Boss grades get everything. A
    -- deliberately timid default: a new hire can cook and sell, nothing else.
    default_rank_permissions = { cook = true, sell = true },
    -- Automatic salary runs, in minutes (0 = manual only, the default — a server that
    -- hasn't set salaries up should never be quietly draining restaurant balances).
    payroll_interval_minutes = 0,
    -- How the tip pool is divided when it's paid out: "even" (equal shares) or
    -- "grade" (weighted by grade + 1, so seniority earns a bigger cut).
    tip_split       = "even",
    -- ── reservations ──────────────────────────────────────────────────────────
    -- The bookable timeslots, as CANONICAL ids the server validates a booking
    -- against — a reservation is an access grant over real seat anchors now, so an
    -- arbitrary slot string would create a hold nothing could ever line up with.
    -- "now" means "from the moment it was booked".
    reservation_slots = { "now", "17:00", "18:00", "19:00", "20:00", "21:00" },
    -- How long a booking holds its seats: its slot time .. + this many minutes.
    reservation_hold_minutes = 90,
    -- The lid pressed onto a filled cup before it can be collected — kitchen
    -- equipment like the serving tray (no inventory item; cups come with lids),
    -- only its world model is configurable.
    drink_lid_model = "pickle_drink_lid_01",
    -- Sides (fries…) are served IN a container box — kitchen equipment like the drink
    -- lid (no inventory item; visual-only). `side_container_model` is the box prop;
    -- `side_container_items` lists the collected item(s) rendered inside it. The box
    -- prepends to the item's build stack, so a served side shows box + food as ONE
    -- unit everywhere (bar, dragged, placed, meal layer) — never a bare loose serving.
    -- Add nuggets (cooked_nuggets/burnt_nuggets) here to box them too.
    side_container_model = "pickle_side_container_01",
    side_container_items = { "cooked_fries", "burnt_fries" },
    soda_ice_ms     = 1500, -- how long the middle (ice) nozzle takes to dispense
    -- NPC customers. AI customers walk up to a restaurant's counter, queue, place a
    -- REAL POS ticket (a random pick off the restaurant's priced menu), wait for staff
    -- to cook + serve them at the register, pay into the balance, and walk away — a
    -- living stream of business for a manned restaurant. Edited in the admin panel's
    -- Customers tab (a single map setting like blip/prep_models). modules/npc_customers
    -- reads it through NpcConfig() which clamps every value, so a bad NUI write can
    -- never break the world (the "validate on read" pattern drinks/finishes use).
    npc_customers = {
        enabled          = true,   -- master on/off for the whole system
        require_staff    = true,   -- only spawn while a sell/cook player is near the counter
        staff_radius     = 30.0,   -- how near a staff member must be to count as present
        spawn_interval   = 45,     -- seconds between spawn attempts per restaurant
        max_queue        = 4,      -- concurrent NPC customers per restaurant
        patience_seconds = 300,    -- how long an NPC waits before leaving unserved (5 min)
        min_items        = 1,      -- fewest line items an NPC orders
        max_items        = 2,      -- most line items an NPC orders
        tip_chance       = 25,     -- % of served orders that leave a tip
        tip_max_percent  = 15,     -- tip is 0..this% of the order total
        counter_offset   = 1.0,    -- front NPC's distance in front of the counter (TUNE IN-GAME)
        queue_spacing    = 0.85,   -- lateral gap between queued NPCs (TUNE IN-GAME)
        spawn_distance   = 6.0,    -- how far back NPCs appear before walking up (TUNE IN-GAME)
        -- Ped models an NPC customer may spawn as (picked at random, server-authoritative).
        models = { "a_m_y_business_01", "a_f_y_business_02", "a_m_m_business_01",
                   "a_f_y_hipster_02", "a_m_y_hipster_01", "a_f_m_business_02" },
    },
    -- SUPPLY RUNS. Off by default, and off means EXACTLY today's behaviour: buying in
    -- the Supplies tab credits the larder on the spot. Switched on, a purchase becomes
    -- a PENDING RUN that somebody has to go and fetch — checkout at the panel, drive to
    -- a supplier depot, carry the boxes from its package point onto the trailer, and an
    -- NPC driver takes the load away and the larder is credited.
    --
    -- Depots are SERVER-WIDE (a supplier serves every restaurant), which is what makes
    -- the run a commute rather than a walk out back. Each depot holds LOADING ZONES,
    -- and a zone is used by ONE player at a time — two crews sharing one box stack
    -- would each be taking boxes off the other's pile.
    --
    -- Points are placed with the gizmo from the admin panel, never typed: a package
    -- point that isn't on the warehouse floor is worse than no depot at all.
    supply_runs = {
        enabled     = false,
        -- The per-ITEM ceiling on a restaurant's larder (0 = uncapped). This is what
        -- forces the commute to be a REGULAR one: you cannot buy a year of patties in
        -- one run. Pending (bought, uncollected) units count against it, so ordering
        -- twice can't slip past it.
        max_stock   = 100,
        -- How the order becomes cargo, expressed against the CAP rather than in raw
        -- units: a full larder is this many boxes. Units per box is DERIVED from it
        -- (cap 100 over 4 boxes = 25 a box), so raising the cap makes the boxes bigger
        -- instead of silently making every run four times longer.
        boxes_per_cap = 4,
        -- Cargo + haulage models. `box_model` must be ONE BOX, never a pre-made pile
        -- prop (`prop_boxpile_*`): the pile is BUILT out of this model, one entity per
        -- box, so that taking one off the stack removes one box — and the box in the
        -- player's arms is the SAME model, so what you picked up is what you're
        -- carrying. A pile prop here would stack piles and hand you a pile.
        box_model     = "hei_prop_heist_box",
        truck_model   = "phantom",
        trailer_model = "trailers",
        -- Where the tractor unit sits relative to its trailer's placed point, along the
        -- trailer's own forward. One gizmo pass places the trailer; the truck is derived
        -- so an admin never has to line two vehicles up by hand.
        truck_gap   = 8.5,
        -- Seconds a claimed loading zone is held before it is swept back: a player who
        -- disconnects or wanders off mid-run must not lock a bay forever.
        claim_ttl   = 900,
        -- [{ id, label, blip = {...}, zones = [{ id, package = {x,y,z,heading},
        --    trailer = {x,y,z,heading} }] }]
        depots      = {},
    },
    -- KITCHEN FIRES. Food left burning on a station eventually sets the station
    -- alight: the station can't be worked until somebody puts it out, and what was
    -- on it is destroyed when they do. Server-authoritative (modules/cookfx), so a
    -- fire keeps burning while nobody is looking and every client sees the same one.
    kitchen_fires = {
        enabled           = true,
        delay_seconds     = 90,   -- how long food sits BURNT before it catches
        extinguish_ms     = 5000, -- how long putting one out takes
        reach             = 4.0,  -- how close you must be to fight it (metres)
        -- The item a player must be carrying to fight a fire. It is NOT consumed —
        -- an extinguisher is equipment. Leave empty (or name an item that isn't
        -- installed) and anyone can put a fire out bare-handed.
        extinguisher_item = "fire_extinguisher",
    },
}


-- ─── unified menu seed data (foods / tools / ingredients) ─────────────────────
-- THE creation system. Everything the resource ships is expressed here as plain
-- config — no food has bespoke gameplay code. Three kinds:
--   • FOOD ("New Recipe"): a sellable, made either as an interactive experience
--     (ordered `steps`: assemble at prep / cook at a station / pour at the
--     fountain — a multi-step food like pizza is ONE entry) or as a combinable
--     `kind = "bag"` (components dropped into the TAKEOUT BOX; the food's own
--     `label` + `image` ride the box's slot metadata so it reads as the food itself).
--   • TOOL ("New Tool"): a quantity-based item applied over food. `mode` picks the
--     gesture/effect: "layer" squeezes its `applied_model` onto a build stack
--     (condiments), "decorate" rubs over a finished product (frosting targets +
--     flavors), "fill" rubs into a free bake tray to produce an oven-ready input.
--   • INGREDIENT ("New Ingredient"): a stackable component (item + prep prop +
--     behavior properties): `halves` = renders/splits as top+bottom half props,
--     each worth 0.5 units; `melts` = can be dropped onto a cooking dual-sided
--     item and melts applied_model → melted_model; `box_base` = a build whose
--     bottom layer is (or derives from) this ingredient fits the pizza box.
-- Seeded once and merged idempotently by id/item — admin edits are never
-- clobbered; deleting a default re-seeds on restart.

-- RAW STATION INPUTS lead the list. These are bought into the larder and dragged
-- onto their station (grill / fryer / oven / fountain), never onto a prep build —
-- the `GetPrepModels()` door in cooking's getIngredients skips anything a recipe or
-- a tap consumes, so listing them here does NOT put a raw patty on the prep
-- components bar. They are here because an ingredient entry is what gives an item
-- an ADMIN-VISIBLE row (Menu → Ingredients, priceable next to its own picture) and
-- a prep PROP; without one they existed only as a price key in Settings →
-- Ingredient Costs, which is why they read as unobtainable. The models are the
-- single-serving RAW props (the `_01` of each family) — the recipe's own cook-state
-- models are the in-basket/on-griddle piles instead.
--
-- EVERY shipped entry carries a `group`, matching the food it belongs to ("Fast
-- Food" / "Bakery" / "Pizza" / "Drinks" / "Condiments"). Remember what a group IS:
-- an opt-in ACCESS RESTRICTION (`RestaurantHasAccess`) as well as the heading the
-- admin Menu and boss Supplies tabs file a row under — a restaurant with NO groups
-- set still carries everything, but one restricted to "Pizza" now gets the pizza
-- ingredients only, which is the point of grouping them. Leave `group` off an entry
-- that every restaurant should always be able to buy.
DEFAULT_INGREDIENTS = {
    { item = "raw_beef_patty",    model = "pickle_patty_beef_01",         group = "Fast Food" },
    { item = "raw_chicken_patty", model = "pickle_patty_friedchicken_01", group = "Fast Food" },
    { item = "raw_drumstick",     model = "pickle_chicken_drumstick_01",  group = "Fast Food" },
    { item = "raw_fries",         model = "pickle_side_fries_01",         group = "Fast Food" },
    { item = "raw_nuggets",       model = "pickle_side_nuggets_01",       group = "Fast Food" },
    { item = "raw_doughnut",      model = "pickle_dough_unapplied_01",    group = "Bakery" },
    { item = "empty_cup",         model = "pickle_drink_container_01",    group = "Drinks" },
    { item = "bun", model = "pickle_bread_bun_01", group = "Fast Food",
      halves = { top_model = "pickle_bread_bun_01", bottom_model = "pickle_bread_bun_02" } },
    { item = "cheese", model = "pickle_cheese_applied_01", group = "Fast Food",
      melts = { applied_model = "pickle_cheese_applied_01", melted_model = "pickle_cheese_applied_02", melt_ms = 8000 } },
    { item = "lettuce", model = "pickle_lettuce_applied_01", group = "Fast Food" },
    { item = "tomato",  model = "pickle_tomato_applied_01",  group = "Fast Food" },
    { item = "pickle",  model = "pickle_pickle_applied_01",  group = "Fast Food" },
    { item = "pizza_dough",  model = "pickle_pizza_dough_01", box_base = true, group = "Pizza" },
    { item = "pizza_sauce",  model = "pickle_pizza_sauce_01",  group = "Pizza" },
    { item = "pizza_cheese", model = "pickle_pizza_cheese_01", group = "Pizza" },
    { item = "pepperoni",    model = "pickle_pizza_pepperoni_01", group = "Pizza" },
}

DEFAULT_TOOLS = {
    { id = "frosting", item = "frosting", tool_model = "pickle_frosting_tube_01",
      mode = "decorate", rub_dist = 1.2, group = "Bakery",
      targets = {
        { item = "cooked_cake", output = "cooked_cake", mode = "replace",
          flavors = {
            { id = "strawberry", label = "Strawberry", model = "pickle_cake_01", color = "#f472b6" },
            { id = "chocolate",  label = "Chocolate",  model = "pickle_cake_02", color = "#8b5a2b" },
            { id = "vanilla",    label = "Vanilla",    model = "pickle_cake_03", color = "#f3e5ab" },
            { id = "pickle",     label = "Pickle",     model = "pickle_cake_04", color = "#65a30d" },
          } },
        { item = "cooked_doughnut", output = "cooked_doughnut", mode = "overlay",
          flavors = {
            { id = "strawberry", label = "Strawberry", model = "pickle_doughnut_topping_01", color = "#f472b6" },
            { id = "chocolate",  label = "Chocolate",  model = "pickle_doughnut_topping_02", color = "#8b5a2b" },
            { id = "glazed",     label = "Glazed",     model = "pickle_doughnut_topping_03", color = "#f0c36d" },
            { id = "vanilla",    label = "Vanilla",    model = "pickle_doughnut_topping_04", color = "#f3e5ab" },
            { id = "pickle",     label = "Pickle",     model = "pickle_doughnut_topping_05", color = "#65a30d" },
          } },
        -- Cookies take the same tube as the cake and the doughnut. The asset pack
        -- ships the iced-cookie props in the CAKE's flavor order (01..04 =
        -- strawberry / chocolate / vanilla / pickle), one short of the doughnut's,
        -- which has a glazed state cookies have no prop for.
        { item = "cooked_cookie", output = "cooked_cookie", mode = "overlay",
          flavors = {
            { id = "strawberry", label = "Strawberry", model = "pickle_cookie_frosting_01", color = "#f472b6" },
            { id = "chocolate",  label = "Chocolate",  model = "pickle_cookie_frosting_02", color = "#8b5a2b" },
            { id = "vanilla",    label = "Vanilla",    model = "pickle_cookie_frosting_03", color = "#f3e5ab" },
            { id = "pickle",     label = "Pickle",     model = "pickle_cookie_frosting_04", color = "#65a30d" },
          } },
      } },
    { id = "sprinkles", item = "sprinkles", tool_model = "pickle_sprinkles_tube_01",
      mode = "decorate", rub_dist = 1.2, group = "Bakery",
      targets = {
        { item = "cooked_doughnut", output = "cooked_doughnut", mode = "overlay",
          requires_finish = "frosting",
          flavors = {
            { id = "vanilla",   label = "Vanilla",   model = "pickle_doughnut_sprinkles_01", color = "#f3e5ab" },
            { id = "chocolate", label = "Chocolate", model = "pickle_doughnut_sprinkles_02", color = "#8b5a2b" },
          } },
        -- No `requires_finish` on the cookie target, unlike the doughnut's: sprinkles
        -- and chips are pressed into cookie dough rather than stuck to icing, and the
        -- pack ships the chip prop as a plain cookie (no frosted variant of it), so
        -- gating it on frosting would make that model unreachable.
        { item = "cooked_cookie", output = "cooked_cookie", mode = "overlay",
          flavors = {
            { id = "vanilla",   label = "Vanilla",         model = "pickle_cookie_sprinkles_01", color = "#f3e5ab" },
            { id = "chocolate", label = "Chocolate",       model = "pickle_cookie_sprinkles_02", color = "#8b5a2b" },
            { id = "chips",     label = "Chocolate Chips", model = "pickle_cookie_chips_01",     color = "#5b3a21" },
          } },
      } },
    -- The squeeze bottles are their own group rather than "Fast Food": sauce goes on
    -- anything, so a pizza place carrying only "Pizza" should be able to add
    -- "Condiments" without also taking the burger line. (A restaurant with no groups
    -- set still gets them, as always.)
    { id = "ketchup", item = "ketchup", mode = "layer", group = "Condiments",
      tool_model = "pickle_ketchup_container_01", applied_model = "pickle_ketchup_applied_01" },
    { id = "mustard", item = "mustard", mode = "layer", group = "Condiments",
      tool_model = "pickle_mustard_container_01", applied_model = "pickle_mustard_applied_01" },
    { id = "mayo", item = "mayo", mode = "layer", group = "Condiments",
      tool_model = "pickle_mayo_container_01", applied_model = "pickle_mayo_applied_01" },
    { id = "baking_mix", item = "baking_mix", tool_model = "pickle_cake_mix_01",
      mode = "fill", rub_dist = 1.2, group = "Bakery",
      trays = {
        { kind = "caketin",    label = "Cake Tin",    tray_model = "pickle_cake_container_01",
          output = "raw_cake",   raw_model = "pickle_cake_mix_pour_02", group = "Bakery" },
        { kind = "cookietray", label = "Cookie Tray", tray_model = "pickle_cookie_tray_01",
          output = "raw_cookie", raw_model = "pickle_cookie_01", slots = 6, group = "Bakery" },
      } },
}

DEFAULT_FOODS = {
    -- fryer batches: the basket cooks as a pile (the step's models); each collected
    -- serving is held/stacked as one item (serving_model / serving_burnt_model)
    { id = "cooked_drumstick", label = "Drumsticks", kind = "interactive", group = "Fast Food",
      consume = { hunger = 20, anim = "eat_snack" },
      steps = { { type = "cook", input = "raw_drumstick", station = "fryer", method = "fry",
        raw_model = "pickle_fryer_drumstick_01", cooked_model = "pickle_fryer_drumstick_02", burnt_model = "pickle_fryer_drumstick_03",
        output = "cooked_drumstick", output_burnt = "burnt_drumstick", cook_ms = 15000, burn_ms = 15000,
        output_count = 4, serving_model = "pickle_chicken_drumstick_02", serving_burnt_model = "pickle_chicken_drumstick_03" } } },
    { id = "cooked_fries", label = "Fries", kind = "interactive", group = "Fast Food",
      consume = { hunger = 15, anim = "eat_snack" },
      steps = { { type = "cook", input = "raw_fries", station = "fryer", method = "fry",
        raw_model = "pickle_fryer_fries_01", cooked_model = "pickle_fryer_fries_02", burnt_model = "pickle_fryer_fries_03",
        output = "cooked_fries", output_burnt = "burnt_fries", cook_ms = 12000, burn_ms = 12000,
        output_count = 4, serving_model = "pickle_side_fries_02", serving_burnt_model = "pickle_side_fries_03" } } },
    { id = "cooked_nuggets", label = "Nuggets", kind = "interactive", group = "Fast Food",
      -- a serving of nuggets is a handful, not a one-handed nibble: two-handed
      consume = { hunger = 15, anim = "eat_burger" },
      steps = { { type = "cook", input = "raw_nuggets", station = "fryer", method = "fry",
        raw_model = "pickle_fryer_nuggets_01", cooked_model = "pickle_fryer_nuggets_02", burnt_model = "pickle_fryer_nuggets_03",
        output = "cooked_nuggets", output_burnt = "burnt_nuggets", cook_ms = 12000, burn_ms = 12000,
        output_count = 20, serving_model = "pickle_side_nuggets_02", serving_burnt_model = "pickle_side_nuggets_03" } } },
    -- cook-then-assemble: the patty grills dual-sided, then builds into the burger
    -- at kitchen prep. ONE entry — the intermediate patty is implied by the steps.
    { id = "burger", label = "Burger", kind = "interactive", group = "Fast Food",
      consume = { hunger = 40, anim = "eat_burger" },
      steps = {
        { type = "cook", input = "raw_beef_patty", station = "stovetop", method = "grill", dual_sided = 1,
          raw_model = "pickle_patty_beef_01", cooked_model = "pickle_patty_beef_02", burnt_model = "pickle_patty_beef_03",
          output = "cooked_beef_patty", output_burnt = "burnt_beef_patty", cook_ms = 18000, burn_ms = 15000 },
        { type = "assemble", output = "burger", model = "pickle_bread_bun_01",
          components = { "bun", "cooked_beef_patty" } },
      },
      modifiers = {
        { id = "cheese",  label = "Cheese",  item = "cheese",  price = 2 },
        { id = "lettuce", label = "Lettuce", item = "lettuce", price = 0 },
        { id = "tomato",  label = "Tomato",  item = "tomato",  price = 0 },
        { id = "pickle",  label = "Pickle",  item = "pickle",  price = 0 },
      } },
    { id = "chicken_sandwich", label = "Chicken Sandwich", kind = "interactive", group = "Fast Food",
      consume = { hunger = 40, anim = "eat_burger" },
      steps = {
        { type = "cook", input = "raw_chicken_patty", station = "fryer", method = "fry",
          raw_model = "pickle_patty_friedchicken_01", cooked_model = "pickle_patty_friedchicken_02", burnt_model = "pickle_patty_friedchicken_03",
          output = "cooked_chicken_patty", output_burnt = "burnt_chicken_patty", cook_ms = 18000, burn_ms = 15000 },
        { type = "assemble", output = "chicken_sandwich", model = "pickle_bread_bun_01",
          components = { "bun", "cooked_chicken_patty" } },
      },
      modifiers = {
        { id = "cheese",  label = "Cheese",  item = "cheese",  price = 2 },
        { id = "lettuce", label = "Lettuce", item = "lettuce", price = 0 },
        { id = "tomato",  label = "Tomato",  item = "tomato",  price = 0 },
        { id = "pickle",  label = "Pickle",  item = "pickle",  price = 0 },
      } },
    { id = "cooked_doughnut", label = "Doughnut", kind = "interactive", group = "Bakery",
      consume = { hunger = 15, anim = "eat_burger" },
      steps = { { type = "cook", input = "raw_doughnut", station = "fryer", method = "fry",
        raw_model = "pickle_doughnut_01", cooked_model = "pickle_doughnut_02", burnt_model = "pickle_doughnut_03",
        output = "cooked_doughnut", output_burnt = "burnt_doughnut", cook_ms = 12000, burn_ms = 12000 } } },
    -- baked goods: the raw input is produced by the baking-mix FILL tool (see
    -- DEFAULT_TOOLS) rubbed into the matching free tray; the oven bakes it inside
    -- its container prop (visual only, never an item).
    { id = "cooked_cookie", label = "Cookies", kind = "interactive", group = "Bakery",
      consume = { hunger = 10, anim = "eat_snack" },
      steps = { { type = "cook", input = "raw_cookie", station = "stovetop", method = "oven",
        raw_model = "pickle_cookie_01", cooked_model = "pickle_cookie_02", burnt_model = "pickle_cookie_03",
        container_model = "pickle_cookie_tray_01", output_count = 6,
        output = "cooked_cookie", output_burnt = "burnt_cookie", cook_ms = 20000, burn_ms = 18000 } } },
    { id = "cooked_cake", label = "Cake", kind = "interactive", group = "Bakery",
      steps = { { type = "cook", input = "raw_cake", station = "stovetop", method = "oven",
        raw_model = "pickle_cake_mix_pour_02", cooked_model = "pickle_cake_mix_pour_03", burnt_model = "pickle_cake_mix_pour_04",
        container_model = "pickle_cake_container_01",
        output = "cooked_cake", output_burnt = "burnt_cake", cook_ms = 30000, burn_ms = 25000 } } },
    -- assemble-then-cook: the raw pizza is built at kitchen prep (dough + sauce +
    -- cheese sheet; pepperoni is an optional topping alteration) then oven-baked.
    -- ONE entry — `raw_pizza` is a kitchen intermediate, never an installed item.
    { id = "cooked_pizza", label = "Pizza", kind = "interactive", group = "Pizza",
      -- STATED, not left to the global `consume` fallback: a pizza is held in both
      -- hands, and a food that authors no clip is at the mercy of whatever an admin
      -- has set as the default for everything else.
      consume = { hunger = 40, anim = "eat_burger" },
      steps = {
        { type = "assemble", output = "raw_pizza", label = "Pizza (uncooked)", model = "pickle_pizza_dough_01",
          components = { "pizza_dough", "pizza_sauce", "pizza_cheese" } },
        { type = "cook", input = "raw_pizza", station = "stovetop", method = "oven",
          raw_model = "pickle_pizza_dough_01", cooked_model = "pickle_pizza_dough_02", burnt_model = "pickle_pizza_dough_03",
          output = "cooked_pizza", output_burnt = "burnt_pizza", cook_ms = 25000, burn_ms = 20000 },
      } },
    -- poured drinks: one food per fountain flavor. Position among the pour foods =
    -- tap order (first six hold the taps); `flavor` is a KEY, not an item — every
    -- poured drink collects as the ONE `serving_item` item with the flavor as
    -- build-stack metadata. `color` tints the poured liquid stream.
    { id = "water", label = "Pure Aqua", kind = "interactive", group = "Drinks",
      consume = { thirst = 30, anim = "drink_cup" },
      steps = { { type = "pour", input = "empty_cup", flavor = "water", model = "pickle_drink_container_01", fill_ms = 3000, color = { 160, 205, 230 } } } },
    { id = "lemonade", label = "Lemonade Bliss", kind = "interactive", group = "Drinks",
      consume = { thirst = 30, anim = "drink_cup" },
      steps = { { type = "pour", input = "empty_cup", flavor = "lemonade", model = "pickle_drink_container_01", fill_ms = 3000, color = { 235, 215, 90 } } } },
    { id = "soda", label = "Classic Cola", kind = "interactive", group = "Drinks",
      consume = { thirst = 30, anim = "drink_cup" },
      steps = { { type = "pour", input = "empty_cup", flavor = "soda", model = "pickle_drink_container_01", fill_ms = 3000, color = { 90, 50, 25 } } } },
    { id = "diet_cola", label = "Diet Cola", kind = "interactive", group = "Drinks",
      consume = { thirst = 30, anim = "drink_cup" },
      steps = { { type = "pour", input = "empty_cup", flavor = "diet_cola", model = "pickle_drink_container_01", fill_ms = 3000, color = { 120, 80, 55 } } } },
    { id = "grape_soda", label = "Grape Zap", kind = "interactive", group = "Drinks",
      consume = { thirst = 30, anim = "drink_cup" },
      steps = { { type = "pour", input = "empty_cup", flavor = "grape_soda", model = "pickle_drink_container_01", fill_ms = 3000, color = { 135, 70, 170 } } } },
    { id = "coffee", label = "Coffee", kind = "interactive", group = "Drinks",
      consume = { thirst = 30, anim = "drink_cup" },
      steps = { { type = "pour", input = "empty_cup", flavor = "coffee", model = "pickle_drink_container_01", fill_ms = 3000, color = { 80, 50, 30 } } } },
}

-- ─── DB bootstrap ────────────────────────────────────────────────────────────

local function CreateTables()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurants` (
            `id`               INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `name`             VARCHAR(60)  NOT NULL,
            `label`            VARCHAR(100) NOT NULL,
            `owner_identifier` VARCHAR(80)  DEFAULT NULL,
            `balance`          BIGINT       NOT NULL DEFAULT 0,
            `blip`             JSON         DEFAULT NULL,
            `counter`          JSON         DEFAULT NULL,
            `roles`            JSON         DEFAULT NULL,
            `groups`           JSON         DEFAULT NULL,
            `menu_enabled`     TINYINT(1)   NOT NULL DEFAULT 1,
            `metadata`         JSON         DEFAULT NULL,
            `created_at`       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `updated_at`       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_owner` (`owner_identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    -- LEGACY. Restaurants are staffed by a framework JOB now (`metadata.job` +
    -- `metadata.ranks`), so nothing reads or writes this table any more. The CREATE
    -- stays because the schema is DECLARED and never migrated: dropping it would
    -- destroy the one record a server upgrading from the employee model has of who
    -- used to work where, which is exactly what an operator needs to re-hire them
    -- into the job. Do not add reads back.
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_employees` (
            `id`              INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `restaurant_id`   INT UNSIGNED NOT NULL,
            `identifier`      VARCHAR(80)  NOT NULL,
            `name`            VARCHAR(100) DEFAULT NULL,
            `grade`           INT          NOT NULL DEFAULT 0,
            `commission_rate` DECIMAL(5,2) NOT NULL DEFAULT 10.00,
            `hired_at`        TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `metadata`        JSON         DEFAULT NULL,
            PRIMARY KEY (`id`),
            UNIQUE KEY `uniq_emp` (`restaurant_id`, `identifier`),
            KEY `idx_rest` (`restaurant_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_props` (
            `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `restaurant_id` INT UNSIGNED NOT NULL,
            `prop_type`     VARCHAR(30)  NOT NULL,
            `model`         VARCHAR(80)  NOT NULL,
            `x`             DOUBLE       NOT NULL,
            `y`             DOUBLE       NOT NULL,
            `z`             DOUBLE       NOT NULL,
            `heading`       DOUBLE       NOT NULL DEFAULT 0,
            `metadata`      JSON         DEFAULT NULL,
            `created_at`    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_rest` (`restaurant_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_menu` (
            `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `restaurant_id` INT UNSIGNED NOT NULL,
            `item`          VARCHAR(60)  NOT NULL,
            -- drinks are ONE item (`serving_item`) with the flavor as metadata, so
            -- per-flavor pricing needs a variant dimension on the menu key (variant =
            -- the drinks[].output flavor key; '' for everything else). NOT NULL so the
            -- unique key upserts reliably (MySQL treats NULLs in unique keys as distinct).
            `variant`       VARCHAR(60)  NOT NULL DEFAULT '',
            `label`         VARCHAR(100) NOT NULL,
            `price`         INT          NOT NULL DEFAULT 0,
            `category`      VARCHAR(40)  DEFAULT 'food',
            `enabled`       TINYINT(1)   NOT NULL DEFAULT 1,
            PRIMARY KEY (`id`),
            UNIQUE KEY `uniq_item` (`restaurant_id`, `item`, `variant`),
            KEY `idx_rest` (`restaurant_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_stock` (
            `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `restaurant_id` INT UNSIGNED NOT NULL,
            `item`          VARCHAR(60)  NOT NULL,
            `count`         INT          NOT NULL DEFAULT 0,
            PRIMARY KEY (`id`),
            UNIQUE KEY `uniq_stock` (`restaurant_id`, `item`),
            KEY `idx_rest` (`restaurant_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    -- SUPPLY RUNS: stock that has been PAID FOR but not yet fetched from a depot.
    -- A row is created at checkout (the money leaves then, so a run is never a free
    -- option) and consumed when the last box is loaded, at which point the units land
    -- in `pickle_restaurant_stock`. An abandoned run stays claimable — the restaurant
    -- has already paid for it, so it is the restaurant's cargo, not the buyer's.
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_supply_orders` (
            `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `restaurant_id` INT UNSIGNED NOT NULL,
            `identifier`    VARCHAR(80)  DEFAULT NULL,
            `lines`         JSON         NOT NULL,
            `units`         INT          NOT NULL DEFAULT 0,
            `boxes`         INT          NOT NULL DEFAULT 0,
            `status`        VARCHAR(16)  NOT NULL DEFAULT 'pending',
            `created_at`    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_rest` (`restaurant_id`, `status`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    -- Per-player, per-restaurant "Cooked Items" tray: cooked products held between
    -- the grill and the prep station. One row per (restaurant, cook, item); every
    -- build variation (toppings, alterations) lives inside the per-instance metadata.
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_cooked_items` (
            `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `restaurant_id` INT UNSIGNED NOT NULL,
            `identifier`    VARCHAR(80)  NOT NULL,
            `item`          VARCHAR(60)  NOT NULL,
            `count`         INT          NOT NULL DEFAULT 0,
            -- Per-instance build stacks (JSON array, one entry per counted item) so an
            -- assembled product remembers what actually went into it — toppings (a
            -- melting cheese slice), alterations and all — and can be taken back apart
            -- faithfully. Melt state rides each layer's `top` field (config-driven,
            -- from the ingredient's `melts`), never a hardcoded column.
            `metadata`      JSON         DEFAULT NULL,
            -- UNIX seconds the row's items were cooked (freshness clock for expiration);
            -- set when the row is created, preserved as more are stacked onto it.
            `cooked_at`     BIGINT       NOT NULL DEFAULT 0,
            PRIMARY KEY (`id`),
            UNIQUE KEY `uniq_tray` (`restaurant_id`, `identifier`, `item`),
            KEY `idx_rest_id` (`restaurant_id`, `identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_ledger` (
            `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `restaurant_id` INT UNSIGNED NOT NULL,
            `type`          VARCHAR(30)  NOT NULL,
            `amount`        BIGINT       NOT NULL DEFAULT 0,
            `description`   VARCHAR(255) DEFAULT NULL,
            `identifier`    VARCHAR(80)  DEFAULT NULL,
            `created_at`    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_rest` (`restaurant_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_settings` (
            `setting_key`   VARCHAR(60) NOT NULL,
            `setting_value` JSON        NOT NULL,
            PRIMARY KEY (`setting_key`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    -- POS kitchen tickets. `lines` snapshots {item, variant, label, price, qty, kind}
    -- at order time so later price/menu edits never change an open ticket. `ticket`
    -- is the per-restaurant kitchen number shown to staff & printed on the receipt.
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_orders` (
            `id`                  INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `restaurant_id`       INT UNSIGNED NOT NULL,
            `ticket`              INT UNSIGNED NOT NULL DEFAULT 1,
            `customer_identifier` VARCHAR(80)  NOT NULL,
            `customer_name`       VARCHAR(100) DEFAULT NULL,
            `cashier_identifier`  VARCHAR(80)  DEFAULT NULL,
            `lines`               JSON         NOT NULL,
            `total`               INT          NOT NULL DEFAULT 0,
            `status`              VARCHAR(12)  NOT NULL DEFAULT 'open',
            `created_at`          TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `closed_at`           TIMESTAMP    NULL DEFAULT NULL,
            -- refund bookkeeping. `refunded` is the idempotence flag RefundOrder sets
            -- (cache + DB) before paying out, so no cancel/delete/race pays a ticket
            -- twice. `paid_account` is which wallet was charged ('bank' for phone/card
            -- orders, 'cash' for register + kiosk) so a refund returns to it. `redeemed`
            -- marks a loyalty punch-card redemption burned on this order, handed back on
            -- cancel.
            `refunded`            TINYINT UNSIGNED NOT NULL DEFAULT 0,
            `paid_account`        VARCHAR(8)   NOT NULL DEFAULT 'cash',
            `redeemed`            TINYINT UNSIGNED NOT NULL DEFAULT 0,
            -- The phone app's columns (delivery/pickup/dine-in + order-ahead). All
            -- nullable/defaulted, so the register + kiosk paths never set them.
            `order_type`          VARCHAR(12)  NOT NULL DEFAULT 'pickup',
            `scheduled_for`       VARCHAR(20)  DEFAULT NULL,
            `address`             VARCHAR(160) DEFAULT NULL,
            -- delivery DROP POINT, persisted so RehydrateDeliveryTargets() can restore
            -- an in-flight delivery across a restart (and the phone can draw its pin)
            `dest_x`              DOUBLE       DEFAULT NULL,
            `dest_y`              DOUBLE       DEFAULT NULL,
            `phone_number`        VARCHAR(24)  DEFAULT NULL,
            `rated`               TINYINT UNSIGNED NOT NULL DEFAULT 0,
            PRIMARY KEY (`id`),
            KEY `idx_rest_status` (`restaurant_id`, `status`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])


    -- OFFLINE REFUNDS. A cancellation must never be blocked by (or silently
    -- swallow money because of) the customer being disconnected. When there's no
    -- live source to hand the money to, RefundOrder parks the payout here and the
    -- settle thread pays it the moment that identifier is online again. The UNIQUE
    -- key on order_id is a second, database-level guarantee that one ticket can
    -- never queue two payouts.
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_pending_refunds` (
            `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `order_id`      INT          NOT NULL,
            `restaurant_id` INT UNSIGNED NOT NULL,
            `identifier`    VARCHAR(80)  NOT NULL,
            `ticket`        INT UNSIGNED NOT NULL DEFAULT 0,
            `amount`        INT          NOT NULL DEFAULT 0,
            `account`       VARCHAR(8)   NOT NULL DEFAULT 'money',
            `reason`        VARCHAR(64)  DEFAULT NULL,
            `created_at`    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `paid_at`       TIMESTAMP    NULL DEFAULT NULL,
            PRIMARY KEY (`id`),
            UNIQUE KEY `uniq_order` (`order_id`),
            KEY `idx_ident_paid` (`identifier`, `paid_at`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    -- STANDALONE JOB ASSIGNMENTS. Only used on a frameworkless server, where this
    -- resource is the job system (bridge/custom). One row per player — a character
    -- holds one job, exactly as a framework would model it — so `identifier` is
    -- unique and an unemployed player is simply the absence of a row.
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_job_players` (
            `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `identifier` VARCHAR(80)  NOT NULL,
            `job`        VARCHAR(60)  NOT NULL,
            `grade`      INT          NOT NULL DEFAULT 0,
            `name`       VARCHAR(100) DEFAULT NULL,
            `updated_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            UNIQUE KEY `uniq_jp` (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    -- TIPS OWED. A tip is STAFF money, never the house's: it lands here instead of on
    -- the restaurant balance, and the POOL is simply the unpaid rows. Keeping the rows
    -- (rather than one running total) is what lets a payout say who earned what and
    -- makes a partially-paid pool impossible to lose track of.
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_tips` (
            `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `restaurant_id` INT UNSIGNED NOT NULL,
            -- who earned it, when that is known (a phone order's server). NULL for a
            -- tip nobody in particular earned — an NPC leaving one on the counter.
            `identifier`    VARCHAR(80)  DEFAULT NULL,
            `amount`        INT          NOT NULL,
            `source`        VARCHAR(16)  DEFAULT NULL,
            `paid`          TINYINT(1)   NOT NULL DEFAULT 0,
            `created_at`    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_rest_paid` (`restaurant_id`, `paid`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    -- THE STANDALONE SOCIETY STORE. Used ONLY on a server with no banking resource at
    -- all (bridge/society falls back to it) — everywhere else a restaurant's money is the
    -- job's real society account and this table stays empty. Keyed by JOB, not by
    -- restaurant: two restaurants on one job share their books, exactly as a society
    -- account does everywhere else.
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_society` (
            `job`        VARCHAR(60)  NOT NULL,
            `amount`     BIGINT       NOT NULL DEFAULT 0,
            `updated_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`job`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    -- PAYSLIP HISTORY. Every tip payout and salary run writes one row per recipient —
    -- the audit trail behind the Payroll tab. Money that left the restaurant has to be
    -- answerable for per person, which a single ledger line ("payroll -$1,240") isn't.
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_payroll` (
            `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `restaurant_id` INT UNSIGNED NOT NULL,
            `identifier`    VARCHAR(80)  NOT NULL,
            `name`          VARCHAR(100) DEFAULT NULL,
            `grade`         INT          NOT NULL DEFAULT 0,
            `amount`        INT          NOT NULL DEFAULT 0,
            `kind`          VARCHAR(12)  NOT NULL DEFAULT 'salary', -- 'salary' | 'tips'
            `paid_at`       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_rest` (`restaurant_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    -- RESERVED SEATS. A reservation is an ACCESS GRANT over specific seat anchors for
    -- one timeslot (never an instance), so the seats it holds are rows of their own:
    -- `prop_id` is a `pickle_restaurant_props` seat row. One booking, many seats.
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_reservation_seats` (
            `id`             INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `reservation_id` INT UNSIGNED NOT NULL,
            `prop_id`        INT UNSIGNED NOT NULL,
            PRIMARY KEY (`id`),
            KEY `idx_res` (`reservation_id`),
            KEY `idx_prop` (`prop_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    -- GUESTS. Who else may sit in a booking's seats. Granted per RESERVATION rather
    -- than per seat: a party that has been let in is let in, and asking a holder to
    -- approve every chair separately is the same question five times.
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_reservation_guests` (
            `id`             INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `reservation_id` INT UNSIGNED NOT NULL,
            `identifier`     VARCHAR(80)  NOT NULL,
            `name`           VARCHAR(100) DEFAULT NULL,
            PRIMARY KEY (`id`),
            KEY `idx_res` (`reservation_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])
end

-- Every table CreateTables is responsible for. The boot refuses to open the
-- RestaurantsReady gate until all of these exist — oxmysql only LOGS a failed
-- query, it doesn't raise, so a CREATE that fell over transiently (or a schema
-- yanked out from under a live resource) would otherwise let the gate open on a
-- broken DB and the schedulers would spam "table doesn't exist".
local REQUIRED_TABLES = {
    "pickle_restaurants", "pickle_restaurant_employees", "pickle_restaurant_props",
    "pickle_restaurant_menu", "pickle_restaurant_stock", "pickle_restaurant_cooked_items",
    "pickle_restaurant_ledger", "pickle_restaurant_settings", "pickle_restaurant_orders",
    "pickle_restaurant_pending_refunds", "pickle_restaurant_job_players",
    "pickle_restaurant_tips", "pickle_restaurant_payroll", "pickle_restaurant_society",
    "pickle_restaurant_reservation_seats", "pickle_restaurant_reservation_guests",
    "pickle_restaurant_supply_orders",
}

-- Returns the first required table that is still missing (nil = schema is whole).
local function FirstMissingTable()
    local rows = MySQL.query.await([[
        SELECT table_name AS t FROM information_schema.tables
        WHERE table_schema = DATABASE() AND table_name LIKE 'pickle_restaurant%'
    ]]) or {}
    local present = {}
    for _, row in ipairs(rows) do present[row.t or row.table_name] = true end
    for _, name in ipairs(REQUIRED_TABLES) do
        if not present[name] then return name end
    end
    return nil
end

-- ─── loaders ─────────────────────────────────────────────────────────────────

-- Tray-only PRODUCTS the default menu makes (cooked/burnt/assembled/decorated foods).
-- They are NOT real inventory items (they live in the cooked-items tray, never a slot),
-- so they have no catalogue image — but the resource SHIPS 2D art for them in
-- `nui/items/`. These get seeded as default custom images (item_images) below so the
-- shipped menu looks right out of the box. Deliberately excludes: drink flavors (art
-- resolved by DrinkFlavorImage, keyed by the drink `output`; the item itself is
-- the Restaurant Item), kitchen equipment (serving_tray / pizza_box / cake_tin / cookie_tray / cup_lid — EQUIP_IMAGE,
-- not items) and restaurant_bag (a real installed item with its own inventory image).
local DEFAULT_PRODUCT_IMAGES = {
    "burger", "cheeseburger", "deluxe_burger", "chicken_sandwich",
    "cooked_beef_patty", "burnt_beef_patty", "cooked_chicken_patty", "burnt_chicken_patty",
    "cooked_drumstick", "burnt_drumstick", "cooked_fries", "burnt_fries",
    "cooked_nuggets", "burnt_nuggets",
    "cooked_doughnut", "burnt_doughnut", "frosted_doughnut",
    "cooked_cake", "burnt_cake", "raw_cake", "decorated_cake",
    "cooked_cookie", "burnt_cookie", "raw_cookie",
    "cooked_pizza", "burnt_pizza", "raw_pizza",
}

local function LoadSettings()
    SettingsCache = {}
    local rows = MySQL.query.await("SELECT setting_key, setting_value FROM pickle_restaurant_settings") or {}
    for _, row in ipairs(rows) do
        SettingsCache[row.setting_key] = dec(row.setting_value, nil)
    end
    -- Seed any missing defaults (idempotent; only writes keys that don't exist).
    for key, value in pairs(DEFAULT_SETTINGS) do
        if SettingsCache[key] == nil then SetSetting(key, value) end
    end

    -- One-time: seed default custom images for the tray-only products from the shipped
    -- nui/items art. Only files that EXIST are seeded (a server can drop art or not),
    -- and only keys the admin hasn't already set — an edit or a removal is preserved.
    -- Gated by a flag so it runs once; bump the reseed by clearing the flag.
    if not SettingsCache.item_images_seeded then
        local map = type(SettingsCache.item_images) == "table" and SettingsCache.item_images or {}
        local res, changed = GetCurrentResourceName(), false
        for _, item in ipairs(DEFAULT_PRODUCT_IMAGES) do
            if map[item] == nil and LoadResourceFile(res, "nui/items/" .. item .. ".png") then
                map[item] = { url = ("nui://%s/nui/items/%s.png"):format(res, item) }
                changed = true
            end
        end
        if changed then SetSetting("item_images", map) end
        SetSetting("item_images_seeded", true)
    end

end


-- Reset the whole authored menu (foods / tools / ingredients) to the shipped
-- defaults verbatim (the admin "Reset menu" action). Unlike the boot-time seed
-- merge (which only fills gaps), this deliberately discards customisations.
function ResetMenuToDefault()
    SetSetting("foods", dec(json.encode(DEFAULT_FOODS), {}))
    SetSetting("tools", dec(json.encode(DEFAULT_TOOLS), {}))
    SetSetting("ingredients", dec(json.encode(DEFAULT_INGREDIENTS), {}))
    RebuildDerived()
end


-- ─── unified menu: authored config accessors ─────────────────────────────────
-- The three authored settings arrays (the ONLY authoring surface). Everything the
-- runtime consumes is DERIVED from these by RebuildDerived() below.
--
-- ...plus whatever the installed DLC PACKS contribute (modules/dlc). These three
-- getters are the ONE place the runtime reads the menu from, which is exactly why
-- the overlay lives here and nowhere else: a pack's ingredients and foods flow into
-- the recipe cache, the cooking bar, the POS catalogue, sync validation and the
-- admin annotations without a single one of those knowing DLC exists.
--
-- The AUTHORED array always wins. A pack entry whose id/item an admin has also
-- authored is dropped rather than appended — appending would double the entry
-- (two identical assembly rows) and, worse, let a pack silently take over a
-- DerivedPrepModels / DerivedFoodById key that the server's own config owns.
-- DLC content is never stored: it is re-read from the pack on every boot, and
-- carries a `dlc` mark that the sanitizers refuse to persist.

-- MEMOIZED, because these getters are not called once per page load: the cooking
-- engine reaches for IngredientDef / MeltingToppingFor / ToppingMeltMs inside its
-- own polling, and ResolveItemCost walks the cost map per sellable while building a
-- catalogue. With no pack installed the authored array is handed straight back
-- (zero cost — the overwhelmingly common case); with one, the merge is rebuilt only
-- when the authored table is REPLACED (SetSetting writes a fresh table, so identity
-- is a sound dirty check) or when the pack registry changes (`DlcRev`, bumped by
-- modules/dlc). Never a per-call allocation in a loop.
DlcRev = DlcRev or 0
local mergeCache = {}

local function withDlc(key, authored, dlc, idField)
    if type(authored) ~= "table" then authored = {} end
    if not dlc or #dlc == 0 then return authored end
    local c = mergeCache[key]
    if c and c.src == authored and c.rev == DlcRev then return c.out end
    local out, seen = {}, {}
    for _, e in ipairs(authored) do
        out[#out + 1] = e
        if type(e) == "table" and e[idField] then seen[e[idField]] = true end
    end
    for _, e in ipairs(dlc) do
        if e[idField] and not seen[e[idField]] then
            seen[e[idField]] = true
            out[#out + 1] = e
        end
    end
    mergeCache[key] = { src = authored, rev = DlcRev, out = out }
    return out
end

function GetFoods()          return withDlc("foods",       GetSetting("foods", {}),       DlcFoods and DlcFoods() or nil,            "id")   end
function GetTools()          return withDlc("tools",       GetSetting("tools", {}),       DlcTools and DlcTools() or nil,            "id")   end
function GetIngredientsCfg() return withDlc("ingredients", GetSetting("ingredients", {}), DlcIngredients and DlcIngredients() or nil, "item") end

-- The buy-in price map behind the Supplies tab and every default menu price. A DLC
-- ships defaults for its OWN items so a freshly installed pack is immediately
-- buyable; the `ingredient_costs` setting is layered on top, so pricing a pack's
-- item in the panel works exactly like pricing anything else and the admin's number
-- always wins.
function IngredientCosts()
    local authored = GetSetting("ingredient_costs", {}) or {}
    if not (DlcIngredientCosts and AnyDlcInstalled and AnyDlcInstalled()) then return authored end
    -- Same memo discipline as the three menu getters: ResolveItemCost walks this
    -- per sellable while a catalogue is built, so it must not rebuild each time.
    -- NOTE the copy — the pack's own table must never be written into.
    local c = mergeCache.__costs
    if c and c.src == authored and c.rev == DlcRev then return c.out end
    local out = {}
    for item, cost in pairs(DlcIngredientCosts()) do out[item] = cost end
    for item, cost in pairs(authored) do out[item] = cost end
    mergeCache.__costs = { src = authored, rev = DlcRev, out = out }
    return out
end

-- The ingredient entry for `item` (nil when unconfigured). Linear scan — the
-- list is tiny and authored, like findAssembly.
function IngredientDef(item)
    if not item or item == "" then return nil end
    for _, ing in ipairs(GetIngredientsCfg()) do
        if ing.item == item then return ing end
    end
    return nil
end

-- `variants` property: ONE item with several interchangeable faces (the five
-- kids-meal toys under one `restaurant_toy`). Which one an instance is rides as
-- build-stack metadata exactly like a poured drink's flavor — a nested one-layer
-- stack `{ { item = <variant id> } }` — so `TraySig` tells two variants apart for
-- free and every store that already threads `stack` (reservations, tray rows, meal
-- and bag metadata, decompose) carries it with no changes.
--
-- Returns nil for an ordinary single-faced ingredient, so nothing pays for this.
function IngredientVariants(item)
    local d = IngredientDef(item)
    return d and type(d.variants) == "table" and #d.variants > 0 and d.variants or nil
end

function IngredientVariantById(item, id)
    if not id then return nil end
    for _, v in ipairs(IngredientVariants(item) or {}) do
        if v.id == id then return v end
    end
    return nil
end

-- The variant a HELD instance is, read off its metadata. Mirrors drinkFlavor: the
-- variant id sits on the first nested layer's `item`. Returns nil for a plain
-- instance (a row stored without one, or a framework that stripped slot metadata) — every
-- caller falls back to the ingredient's own model/label, so an un-tagged toy is
-- generic rather than broken.
function IngredientVariantOf(item, meta)
    local l = type(meta) == "table" and meta[1]
    if type(l) ~= "table" or not l.item then return nil end
    return IngredientVariantById(item, l.item)
end

-- The metadata that MAKES an instance a given variant — the one place the shape is
-- written, so the reservation, the render and the reader can't drift apart.
function IngredientVariantMeta(id)
    return id and { { item = id } } or nil
end

-- ─── stock keys ──────────────────────────────────────────────────────────────
-- What the shared larder counts a thing UNDER. For everything else that is just
-- the item; for a variants ingredient it is per VARIANT, because the pool has to
-- be able to tell a $12 Lardboy from a $10 Kitty Kat. Buying five Kitty Kats and
-- handing out five Lardboys is exactly what a single generic "toy" line would
-- allow, and it is why per-toy pricing is only meaningful with per-toy stock.
--
-- This is a key in OUR OWN table (`pickle_restaurant_stock.item` is a plain
-- varchar, never a foreign key into the framework's inventory), so a composite key
-- costs no schema change. It must never be handed to the inventory as an item
-- name: `ItemExists` is false for one, which is what keeps the deposit/withdraw
-- paths — the only stock code that touches real inventory — refusing them.
function StockKey(item, variant)
    if not item or not variant or variant == "" then return item end
    return item .. ":" .. variant
end

-- Split a stock key back into (item, variantId). The variant is only reported when
-- the ingredient really declares it, so an item whose own name contains a colon
-- can never be mistaken for a variant key.
function SplitStockKey(key)
    if type(key) ~= "string" then return key, nil end
    local item, vid = key:match("^(.-):([^:]+)$")
    if item and IngredientVariantById(item, vid) then return item, vid end
    return key, nil
end

-- How one stock key reads and looks in the Supplies tab / the ledger.
function StockKeyLabel(key)
    local item, vid = SplitStockKey(key)
    local v = vid and IngredientVariantById(item, vid)
    return (v and v.label) or GetItemLabel(item)
end

function StockKeyImage(key)
    local item, vid = SplitStockKey(key)
    local v = vid and IngredientVariantById(item, vid)
    return (v and v.image) or GetItemImage(item)
end

-- `halves` property: the ingredient renders/splits as two half props (top +
-- bottom), each worth 0.5 stack units (buns).
function IngredientHalves(item)
    local d = IngredientDef(item)
    return d and type(d.halves) == "table" and d.halves or nil
end

-- `melts` property: the ingredient can be dropped onto a cooking dual-sided item
-- and transitions applied_model -> melted_model on its melt timer (cheese).
function MeltingToppingFor(item)
    local d = IngredientDef(item)
    if d and type(d.melts) == "table" and d.melts.applied_model then return d end
    return nil
end

-- The topping riding a build-stack layer (or a cook/tray record), normalized:
-- { item, state = "applied"|"melted" } from the layer's `top` field; nil when the
-- layer carries no topping.
function LayerTopping(l)
    if type(l) ~= "table" then return nil end
    if type(l.top) == "table" and l.top.item then
        return { item = l.top.item, state = (l.top.state == "melted") and "melted" or "applied" }
    end
    return nil
end

-- The prop a topping renders as at its current melt state, from its ingredient's
-- `melts` models. nil when the ingredient is unconfigured (caller falls back).
function ToppingModel(top)
    if type(top) ~= "table" or not top.item then return nil end
    local d = IngredientDef(top.item)
    local m = d and d.melts
    if type(m) ~= "table" then return d and d.model or nil end
    if top.state == "melted" then return m.melted_model or m.applied_model end
    return m.applied_model or d.model
end

-- The melt duration for a topping ingredient (its own melt_ms, else the global
-- fallback setting).
function ToppingMeltMs(item)
    local d = MeltingToppingFor(item)
    local ms = d and d.melts and tonumber(d.melts.melt_ms)
    return ms or tonumber(GetSetting("cheese_melt_ms", 8000)) or 8000
end

-- ─── unified menu: sanitizers ─────────────────────────────────────────────────
-- Applied to every admin save (the NUI is untrusted) and to migration output.
-- Liberal: clamp types and drop structurally-empty entries; validity (missing
-- items / models) is annotation, not rejection — a half-built entry must survive
-- the round trip so it can be finished later.

local function trimStr(v) return (type(v) == "string" and v ~= "") and v or nil end
local function numOr(v, d) local n = tonumber(v); return n ~= nil and n or d end

local function sanitizeModifiers(mods)
    if type(mods) ~= "table" then return nil end
    local out = {}
    for _, m in ipairs(mods) do
        if type(m) == "table" and (trimStr(m.id) or trimStr(m.item) or trimStr(m.label)) then
            out[#out + 1] = {
                id      = trimStr(m.id) or trimStr(m.item) or trimStr(m.label),
                label   = trimStr(m.label) or trimStr(m.item) or trimStr(m.id),
                item    = trimStr(m.item),
                price   = RoundMoney(numOr(m.price, 0)),
                default = m.default == true or nil,
            }
        end
    end
    return #out > 0 and out or nil
end

local function sanitizeComponents(comps)
    local out = {}
    for _, c in ipairs(type(comps) == "table" and comps or {}) do
        if type(c) == "string" and c ~= "" then out[#out + 1] = c end
    end
    return out
end

-- A normalized crop rectangle (all fractions 0..1) or nil. Mirrors the brand-image
-- crop sanitizer in modules/management (kept local there); item images reuse the
-- exact { url, crop } shape brand images use.
local function sanitizeImageCrop(c)
    if type(c) ~= "table" then return nil end
    local x, y, w, h = tonumber(c.x), tonumber(c.y), tonumber(c.w), tonumber(c.h)
    if not (x and y and w and h) or w <= 0 or h <= 0 then return nil end
    local function clamp(v) return math.max(0.0, math.min(1.0, v)) end
    x, y = clamp(x), clamp(y)
    w, h = math.min(w, 1.0 - x), math.min(h, 1.0 - y)
    if w <= 0 or h <= 0 then return nil end
    return { x = x, y = y, w = w, h = h }
end

-- Sanitize the admin `item_images` map (untrusted NUI): item name → { url, crop? }.
-- Blank/oversized urls are dropped; an item with no valid url is omitted entirely.
function SanitizeItemImages(map)
    local out = {}
    for item, v in pairs(type(map) == "table" and map or {}) do
        if type(item) == "string" and item ~= "" and type(v) == "table" then
            local url = trimStr(v.url)
            if url then
                out[item] = { url = url:sub(1, 512), crop = sanitizeImageCrop(v.crop) }
            end
        end
    end
    return out
end

-- A FOOD's own picture — the same { url, crop } shape items/brands use, but
-- authored on the food itself rather than borrowed from an inventory item. This is
-- what a takeout-box food shows on its in-world quad, in the tray, on the POS and
-- in the bag's contents menu; a food with no prop of its own has nothing else.
local function sanitizeFoodImage(v)
    if type(v) ~= "table" then return nil end
    local url = trimStr(v.url)
    if not url then return nil end
    return { url = url:sub(1, 512), crop = sanitizeImageCrop(v.crop) }
end

-- What eating ONE serving of a food does: the needs it restores (0-100 percentages
-- of the framework's bars) and which `consume_anims` entry plays. All three are
-- optional — anything missing falls back to the global `consume` setting.
local function sanitizeConsume(v)
    if type(v) ~= "table" then return nil end
    local function pct(n)
        n = tonumber(n)
        if not n then return nil end
        return math.max(0, math.min(100, math.floor(n)))
    end
    -- `stress` is RELIEF, not a need: the other two fill a bar, this one drains one.
    -- Kept in the same block (and the same 0-100 units) because it is the same
    -- question — "what does using one of these do to the player" — and a food may
    -- well answer it in more than one way. The bridge decides what "stress" means on
    -- the framework in play, and a server with no stress system simply has nothing
    -- to drain (see Relax).
    local out = { hunger = pct(v.hunger), thirst = pct(v.thirst), stress = pct(v.stress),
                  anim = trimStr(v.anim) }
    -- `bites` is authored on foods through the same block; keep it so an entry can
    -- say "this is used in ONE go" (a toy) instead of inheriting the 3-bite default.
    local bites = tonumber(v.bites)
    if bites then out.bites = math.max(1, math.min(20, math.floor(bites))) end
    if out.hunger == nil and out.thirst == nil and out.stress == nil
        and not out.anim and not out.bites then return nil end
    return out
end

-- The admin-editable eat/drink animation catalogue (`consume_anims`), sanitized on
-- read so a bad NUI write can never hand the client a malformed clip. Entries with
-- no id/dict/clip are dropped.
-- A DLC pack ships the clips its own content needs (a toy is squeezed, not eaten),
-- appended AFTER the authored catalogue so an admin can retune a packaged clip by
-- authoring an entry with the same id — theirs is found first by ConsumeSpecFor's
-- linear scan, and the pack's is skipped here as a duplicate id.
function ConsumeAnims()
    local out, seen = {}, {}
    local function add(a)
        if type(a) ~= "table" then return end
        local id, dict, clip = trimStr(a.id), trimStr(a.dict), trimStr(a.clip)
        if id and dict and clip and not seen[id] then
            seen[id] = true
            out[#out + 1] = { id = id, label = trimStr(a.label) or id, dict = dict, clip = clip,
                              prop = trimStr(a.prop),
                              ms = math.max(500, math.min(20000, math.floor(tonumber(a.ms) or 3000))) }
        end
    end
    for _, a in ipairs(GetSetting("consume_anims", {}) or {}) do add(a) end
    for _, a in ipairs(DlcConsumeAnims and DlcConsumeAnims() or {}) do add(a) end
    return out
end

function SanitizeConsumeAnims(list)
    local out, seen = {}, {}
    for _, a in ipairs(type(list) == "table" and list or {}) do
        if type(a) == "table" then
            local id, dict, clip = trimStr(a.id), trimStr(a.dict), trimStr(a.clip)
            if id and dict and clip and not seen[id] then
                seen[id] = true
                out[#out + 1] = { id = id, label = trimStr(a.label) or id, dict = dict, clip = clip,
                                  prop = trimStr(a.prop),
                                  ms = math.max(500, math.min(20000, math.floor(tonumber(a.ms) or 3000))) }
            end
        end
    end
    return out
end

-- Rebuild the item → url override cache from the stored `item_images` setting.
-- Called from RebuildDerived (boot + every menu/settings save).
function RebuildItemImages()
    ItemImageCache = {}
    -- A DLC pack's own art goes down FIRST so the admin's `item_images` overrides
    -- (written next) win — a pack ships a picture, it doesn't claim one.
    for item, url in pairs(DlcItemImages and DlcItemImages() or {}) do
        ItemImageCache[item] = url
    end
    for item, v in pairs(GetSetting("item_images", {}) or {}) do
        if type(v) == "table" and type(v.url) == "string" and v.url ~= "" then
            ItemImageCache[item] = v.url
        end
    end
end

-- Set (or clear, blank url) ONE item's custom image, MERGING into the stored map so
-- concurrent edits from the two menu tabs can't clobber each other's entries. Returns
-- true on a valid item. Caller re-syncs the world.
function SetItemImageOverride(item, url, crop)
    if type(item) ~= "string" or item == "" then return false end
    local next = {}
    for k, v in pairs(GetSetting("item_images", {}) or {}) do next[k] = v end
    url = trimStr(url)
    next[item] = url and { url = url:sub(1, 512), crop = sanitizeImageCrop(crop) } or nil
    SetSetting("item_images", next)
    RebuildItemImages()
    return true
end

-- A stable food id derived from its display label — the same slug the NUI shows,
-- computed SERVER-side. A food authors its own identity, so the label IS the
-- identity. Without this a newly created food has no id, and an id-less food is
-- dropped on save — it would vanish the moment the tab was left.
local function foodSlug(s)
    return (tostring(s or ""):lower():gsub("[^a-z0-9]+", "_"):gsub("^_+", ""):gsub("_+$", ""))
end

-- DLC content is never PERSISTED. It is contributed by an installed pack at
-- runtime (modules/dlc) and merged into the three getters, so it reaches the admin
-- panel's lists like everything else — and the panel saves its lists whole. Marked
-- entries are therefore dropped on the way IN, which is the one place that can't be
-- got around: even a hand-crafted NUI post can't strand a pack's food in the
-- settings table where it would outlive the pack that defines it.
local function isDlcEntry(e) return type(e) == "table" and trimStr(e.dlc) ~= nil end

function SanitizeFoods(list)
    local out, seen = {}, {}
    for _, f in ipairs(type(list) == "table" and list or {}) do
        if type(f) == "table" and not isDlcEntry(f) then
            local food = {
                id    = trimStr(f.id),
                label = trimStr(f.label),
                kind  = (f.kind == "bag") and "bag" or "interactive",
                group = trimStr(f.group),
                modifiers = sanitizeModifiers(f.modifiers),
                -- A food's OWN face + effect, authored (never borrowed from an
                -- inventory item): the picture it shows everywhere it has no prop of
                -- its own, and what eating one serving does.
                image   = sanitizeFoodImage(f.image),
                -- what's painted on the quad INSIDE a takeout box, when that should
                -- differ from the card art (the card wants a packshot; the box wants
                -- the bare food, top-down). Falls back to `image`.
                box_image = sanitizeFoodImage(f.box_image),
                consume = sanitizeConsume(f.consume),
            }
            if food.kind == "bag" then
                food.components = sanitizeComponents(f.components)
                -- identity: an explicit id, else the label slug
                food.id = food.id or trimStr(foodSlug(food.label))
            else
                local steps, cooks, pours = {}, 0, 0
                local prevOutput = nil
                for _, st in ipairs(type(f.steps) == "table" and f.steps or {}) do
                    if type(st) == "table" then
                        if st.type == "cook" and cooks == 0 then
                            cooks = cooks + 1
                            local station = (st.station == "fryer") and "fryer" or "stovetop"
                            local method = st.method
                            if station == "fryer" then method = "fry"
                            elseif method ~= "oven" then method = "grill" end
                            steps[#steps + 1] = {
                                type = "cook",
                                input = trimStr(st.input) or prevOutput,
                                station = station, method = method,
                                raw_model = trimStr(st.raw_model), cooked_model = trimStr(st.cooked_model),
                                burnt_model = trimStr(st.burnt_model),
                                output = trimStr(st.output), output_burnt = trimStr(st.output_burnt),
                                cook_ms = math.max(1000, math.floor(numOr(st.cook_ms, 15000))),
                                burn_ms = math.max(1000, math.floor(numOr(st.burn_ms, 15000))),
                                dual_sided = (st.dual_sided == 1 or st.dual_sided == true) and 1 or nil,
                                output_count = math.max(1, math.floor(numOr(st.output_count, 1))),
                                container_model = trimStr(st.container_model),
                                expire_seconds = st.expire_seconds ~= nil and st.expire_seconds ~= ""
                                    and math.max(0, math.floor(numOr(st.expire_seconds, 0))) or nil,
                                serving_model = trimStr(st.serving_model),
                                serving_burnt_model = trimStr(st.serving_burnt_model),
                            }
                            prevOutput = steps[#steps].output or prevOutput
                        elseif st.type == "assemble" then
                            steps[#steps + 1] = {
                                type = "assemble",
                                output = trimStr(st.output),
                                label = trimStr(st.label),
                                model = trimStr(st.model),
                                components = sanitizeComponents(st.components),
                            }
                            prevOutput = steps[#steps].output or prevOutput
                        elseif st.type == "pour" and pours == 0 and #steps == 0 then
                            -- a pour step stands alone (the fountain IS the whole make)
                            pours = pours + 1
                            steps[#steps + 1] = {
                                type = "pour",
                                input = trimStr(st.input),
                                flavor = trimStr(st.flavor),
                                model = trimStr(st.model),
                                fill_ms = math.max(500, math.floor(numOr(st.fill_ms, 3000))),
                                color = (type(st.color) == "table") and {
                                    math.floor(numOr(st.color[1] or st.color.r, 200)),
                                    math.floor(numOr(st.color[2] or st.color.g, 200)),
                                    math.floor(numOr(st.color[3] or st.color.b, 210)),
                                } or nil,
                            }
                            prevOutput = steps[#steps].flavor or prevOutput
                        end
                    end
                end
                food.steps = steps
                -- deterministic identity: the final step's output / flavor (this is
                -- what lets the default merge + migration agree on the same id)
                -- identity: the final step's output / flavor, else the label slug —
                -- so a half-built recipe (no outputs typed yet) still SURVIVES the
                -- save and can be finished later instead of disappearing
                food.id = food.id or prevOutput or trimStr(foodSlug(food.label))
            end
            if food.id and not seen[food.id] then
                seen[food.id] = true
                food.label = food.label or GetItemLabel(food.id)
                out[#out + 1] = food
            end
        end
    end
    return out
end

function SanitizeTools(list)
    local out, seen = {}, {}
    for _, t in ipairs(type(list) == "table" and list or {}) do
        if type(t) == "table" and not isDlcEntry(t) and (trimStr(t.item) or trimStr(t.id)) then
            local mode = (t.mode == "layer" or t.mode == "decorate" or t.mode == "fill") and t.mode or "layer"
            local tool = {
                id = trimStr(t.id) or trimStr(t.item),
                item = trimStr(t.item) or trimStr(t.id),
                tool_model = trimStr(t.tool_model),
                mode = mode,
                group = trimStr(t.group),
            }
            if mode == "layer" then
                tool.applied_model = trimStr(t.applied_model)
            elseif mode == "decorate" then
                tool.rub_dist = math.max(0.1, numOr(t.rub_dist, 1.2))
                local targets = {}
                for _, tg in ipairs(type(t.targets) == "table" and t.targets or {}) do
                    if type(tg) == "table" and trimStr(tg.item) then
                        local flavors = {}
                        for _, fl in ipairs(type(tg.flavors) == "table" and tg.flavors or {}) do
                            if type(fl) == "table" and (trimStr(fl.id) or trimStr(fl.label)) then
                                flavors[#flavors + 1] = {
                                    id = trimStr(fl.id) or trimStr(fl.label),
                                    label = trimStr(fl.label) or trimStr(fl.id),
                                    model = trimStr(fl.model),
                                    color = trimStr(fl.color),
                                }
                            end
                        end
                        targets[#targets + 1] = {
                            item = trimStr(tg.item),
                            output = trimStr(tg.output) or trimStr(tg.item),
                            mode = (tg.mode == "replace") and "replace" or "overlay",
                            requires_finish = trimStr(tg.requires_finish),
                            flavors = flavors,
                        }
                    end
                end
                tool.targets = targets
            elseif mode == "fill" then
                tool.rub_dist = math.max(0.1, numOr(t.rub_dist, 1.2))
                local trays = {}
                for _, tr in ipairs(type(t.trays) == "table" and t.trays or {}) do
                    if type(tr) == "table" and trimStr(tr.kind) then
                        trays[#trays + 1] = {
                            kind = trimStr(tr.kind),
                            label = trimStr(tr.label) or trimStr(tr.kind),
                            tray_model = trimStr(tr.tray_model),
                            output = trimStr(tr.output),
                            raw_model = trimStr(tr.raw_model),
                            slots = tonumber(tr.slots) and math.max(1, math.floor(tonumber(tr.slots))) or nil,
                            group = trimStr(tr.group),
                        }
                    end
                end
                tool.trays = trays
            end
            if not seen[tool.id] then
                seen[tool.id] = true
                out[#out + 1] = tool
            end
        end
    end
    return out
end

function SanitizeIngredients(list)
    local out, seen = {}, {}
    for _, ing in ipairs(type(list) == "table" and list or {}) do
        if type(ing) == "table" and not isDlcEntry(ing) and trimStr(ing.item) and not seen[ing.item] then
            seen[ing.item] = true
            local e = {
                item = ing.item,
                model = trimStr(ing.model),
                group = trimStr(ing.group),
                box_base = ing.box_base == true or nil,
                label = trimStr(ing.label),
                -- What USING one does, for an ingredient that is a thing in its own
                -- right rather than a component — a DLC toy dropped in a bag or on a
                -- meal tray is picked out and played with, not eaten. Same block a
                -- food authors (`hunger`/`thirst`/`stress`/`anim`/`bites`), read by
                -- ConsumeSpecFor when no FOOD claims the item. nil for a plain
                -- component (a lettuce leaf is never used on its own).
                consume = sanitizeConsume(ing.consume),
            }
            -- VARIANTS: one item, many faces. Per the one-item consolidation rule,
            -- a family of interchangeable things (the five kids-meal toys) is ONE
            -- installed item whose variation rides in build-stack metadata — never
            -- five items. Each variant carries its own prop, name, picture and
            -- (optionally) its own effect layered over the ingredient's; the bar
            -- shows one card per variant, all spending the same stock.
            if type(ing.variants) == "table" then
                local vs, vseen = {}, {}
                for _, v in ipairs(ing.variants) do
                    if type(v) == "table" then
                        local vid = trimStr(v.id) or (trimStr(v.label) and foodSlug(v.label))
                        if vid and vid ~= "" and not vseen[vid] then
                            vseen[vid] = true
                            vs[#vs + 1] = { id = vid, label = trimStr(v.label) or PrettyItemName(vid),
                                            model = trimStr(v.model), image = trimStr(v.image),
                                            consume = sanitizeConsume(v.consume) }
                        end
                    end
                end
                if #vs > 0 then e.variants = vs end
            end
            if type(ing.halves) == "table" and (trimStr(ing.halves.top_model) or trimStr(ing.halves.bottom_model)) then
                e.halves = { top_model = trimStr(ing.halves.top_model),
                             bottom_model = trimStr(ing.halves.bottom_model) }
            end
            if type(ing.melts) == "table" and trimStr(ing.melts.applied_model) then
                e.melts = { applied_model = trimStr(ing.melts.applied_model),
                            melted_model = trimStr(ing.melts.melted_model) or trimStr(ing.melts.applied_model),
                            melt_ms = tonumber(ing.melts.melt_ms) and math.max(500, math.floor(tonumber(ing.melts.melt_ms))) or nil }
            end
            out[#out + 1] = e
        end
    end
    return out
end

-- ─── unified menu: derivation layer ──────────────────────────────────────────
-- Rebuilds the exact runtime shapes the 5k-line cooking engine / sales /
-- sync consume — RecipeCache rows, assembly/drinks/crafts/finishes/
-- condiments lists, the baking config (now a LIST, one per fill tool) and the
-- item->prep-prop map — from the three authored arrays. Run at boot and after
-- every save of foods/tools/ingredients. Gameplay code never reads the authored
-- arrays directly (except IngredientDef, which IS the authored surface).

DerivedAssembly   = {}
DerivedDrinks     = {}
DerivedCrafts     = {}
DerivedFinishes   = {}
DerivedCondiments = {}
DerivedBaking     = {}
DerivedPrepModels = {}

-- Food lookups for anything that needs a food's OWN presentation/effect from just
-- an item (its picture, its label, what eating it does): by authored id, and by
-- every terminal output the food produces. Built in RebuildDerived.
DerivedFoodById     = {}
DerivedFoodByOutput = {}

function GetAssembly()   return DerivedAssembly end
function GetDrinks()     return DerivedDrinks end
function GetCrafts()     return DerivedCrafts end
function GetFinishes()   return DerivedFinishes end
function GetCondiments() return DerivedCondiments end
function GetBakingList() return DerivedBaking end
function GetPrepModels() return DerivedPrepModels end

function RebuildDerived()
    RecipeCache, RecipeByInput, RecipeByOutput = {}, {}, {}
    DerivedAssembly, DerivedDrinks, DerivedCrafts = {}, {}, {}
    DerivedFinishes, DerivedCondiments, DerivedBaking = {}, {}, {}
    DerivedPrepModels = {}
    DerivedFoodById, DerivedFoodByOutput = {}, {}

    for _, ing in ipairs(GetIngredientsCfg()) do
        -- A variants-only ingredient (the toy family) authors no prop of its own —
        -- each variant has one. Map the item to the FIRST variant's prop so an
        -- instance whose metadata was stripped still renders as something rather
        -- than falling through to a model-less 2D pill.
        local model = ing.model
        if not model and type(ing.variants) == "table" then
            model = (ing.variants[1] or {}).model
        end
        if ing.item and model then DerivedPrepModels[ing.item] = model end
    end

    for _, food in ipairs(GetFoods()) do
        if food.id then DerivedFoodById[food.id] = food end
        -- every terminal output this food can be HELD as, so an item alone resolves
        -- back to the food that authored it (its picture, label and consume effect):
        -- a cook step's cooked output, an assemble step's product, a pour's flavor.
        for _, st in ipairs(food.steps or {}) do
            local out = st.output or st.flavor
            if out and out ~= "" then DerivedFoodByOutput[out] = food end
        end
        if food.kind == "bag" then
            -- NOTHING IS MADE FROM NOTHING: a food with no components would match an
            -- EMPTY takeout box and let anyone create it out of thin air. Such an
            -- entry is never derived (the admin panel still lists it, flagged
            -- invalid, so it can be fixed).
            if food.id and #(food.components or {}) > 0 then
                DerivedCrafts[#DerivedCrafts + 1] = {
                    id = food.id, label = food.label or food.id, group = food.group,
                    components = food.components or {}, modifiers = food.modifiers,
                    -- BOTH pictures ride along: the item card art and the one painted
                    -- inside the box. Dropping `box_image` here silently fell every
                    -- box back to the card art (FoodBoxImageUrl's fallback).
                    image = food.image, box_image = food.box_image,
                    consume = food.consume, food_id = food.id,
                }
            end
        else
            local steps = food.steps or {}
            local prevOutput = nil
            for si, st in ipairs(steps) do
                local isLast = (si == #steps)
                if st.type == "cook" then
                    local input = st.input or prevOutput
                    if input and st.output and not RecipeByInput[input] then
                        local row = {
                            id = #RecipeCache + 1,
                            input_item = input,
                            station = st.station or "stovetop",
                            method = st.method or "grill",
                            raw_model = st.raw_model, cooked_model = st.cooked_model,
                            burnt_model = st.burnt_model,
                            output_cooked_item = st.output,
                            output_burnt_item = st.output_burnt or "",
                            cook_ms = tonumber(st.cook_ms) or 15000,
                            burn_ms = tonumber(st.burn_ms) or 15000,
                            dual_sided = (st.dual_sided == 1 or st.dual_sided == true) and 1 or 0,
                            output_count = math.max(1, math.floor(tonumber(st.output_count) or 1)),
                            container_model = st.container_model,
                            expire_seconds = st.expire_seconds,
                            group = food.group,
                            food_id = food.id,
                        }
                        RecipeCache[#RecipeCache + 1] = row
                        RecipeByInput[input] = row
                        RecipeByOutput[st.output] = row
                        if st.serving_model then DerivedPrepModels[st.output] = st.serving_model end
                        if st.serving_burnt_model and st.output_burnt then
                            DerivedPrepModels[st.output_burnt] = st.serving_burnt_model
                        end
                    end
                    prevOutput = st.output or prevOutput
                elseif st.type == "assemble" then
                    -- likewise: a component-less assembly would be satisfied by any
                    -- stack (stackSatisfies over an empty requirement is trivially
                    -- true), i.e. buildable from nothing — never derive one
                    if st.output and #(st.components or {}) > 0 then
                        DerivedAssembly[#DerivedAssembly + 1] = {
                            output = st.output,
                            label = isLast and (food.label or st.output)
                                or (st.label or ((food.label or st.output) .. " (uncooked)")),
                            model = st.model, group = food.group,
                            components = st.components or {},
                            modifiers = isLast and food.modifiers or nil,
                            food_id = food.id,
                        }
                    end
                    prevOutput = st.output or prevOutput
                elseif st.type == "pour" then
                    -- a pour CONSUMES its cup: no cup item, no drink (the fountain
                    -- would otherwise fill nothing into nothing)
                    if st.flavor and st.input and st.input ~= "" then
                        DerivedDrinks[#DerivedDrinks + 1] = {
                            input = st.input, output = st.flavor,
                            label = food.label or st.flavor,
                            model = st.model, fill_ms = tonumber(st.fill_ms) or 3000,
                            color = st.color, group = food.group, food_id = food.id,
                        }
                    end
                end
            end
        end
    end

    for _, t in ipairs(GetTools()) do
        if t.mode == "decorate" then
            DerivedFinishes[#DerivedFinishes + 1] = {
                tool = t.item, tool_model = t.tool_model, rub_dist = t.rub_dist,
                group = t.group, targets = t.targets or {}, tool_id = t.id,
            }
        elseif t.mode == "layer" then
            DerivedCondiments[#DerivedCondiments + 1] = {
                item = t.item, container_model = t.tool_model,
                applied_model = t.applied_model, tool_id = t.id,
            }
        elseif t.mode == "fill" then
            DerivedBaking[#DerivedBaking + 1] = {
                mix_item = t.item, mix_model = t.tool_model, rub_dist = t.rub_dist,
                trays = t.trays or {}, group = t.group, tool_id = t.id,
            }
        end
    end

    RebuildItemImages()
end


-- Idempotent default merge for the three authored arrays: create a missing key
-- outright, else append shipped entries whose id/item isn't present. An admin's
-- customised entry (same id) is never touched; a deleted default re-seeds on
-- restart.
local function SeedUnifiedMenu()
    local function merge(key, defaults, idField)
        local list = GetSetting(key, nil)
        if type(list) ~= "table" then
            SetSetting(key, dec(json.encode(defaults), {}))
            return
        end
        local seen = {}
        for _, e in ipairs(list) do if e[idField] then seen[e[idField]] = true end end
        local changed = false
        for _, def in ipairs(defaults) do
            if not seen[def[idField]] then
                list[#list + 1] = dec(json.encode(def), nil)
                changed = true
            end
        end
        if changed then SetSetting(key, list) end
    end
    merge("foods", DEFAULT_FOODS, "id")
    merge("tools", DEFAULT_TOOLS, "id")
    merge("ingredients", DEFAULT_INGREDIENTS, "item")
end

local function LoadStock()
    StockCache = {}
    local rows = MySQL.query.await("SELECT * FROM pickle_restaurant_stock") or {}
    for _, row in ipairs(rows) do
        StockCache[row.restaurant_id] = StockCache[row.restaurant_id] or {}
        StockCache[row.restaurant_id][row.item] = row.count
    end
end

local function LoadOrders()
    OrderCache, NextTicket = {}, {}
    -- NPC orders are ephemeral: each is tied to a live NPC ped + in-memory queue
    -- (NpcState) that cannot survive a restart. Any still 'open' at boot is orphaned
    -- — no ped, no queue entry — so it can never be fulfilled and just clogs every
    -- register's Tickets widget. Cancel them up front (before loading the cache) so
    -- they're gone on restart. Closed rows still count for ticket numbering below.
    MySQL.update.await(
        "UPDATE pickle_restaurant_orders SET status = 'cancelled', closed_at = NOW() "
        .. "WHERE status = 'open' AND customer_identifier LIKE 'npc:%'")
    -- Only open tickets live in the cache; completed/cancelled rows stay in the DB
    -- as history. Ticket numbering continues from the highest ever issued so a
    -- restart never reuses a number a customer's receipt still shows.
    local rows = MySQL.query.await("SELECT * FROM pickle_restaurant_orders WHERE status = 'open'") or {}
    for _, row in ipairs(rows) do
        row.lines = dec(row.lines, {})
        OrderCache[row.restaurant_id] = OrderCache[row.restaurant_id] or {}
        OrderCache[row.restaurant_id][row.id] = row
    end
    local maxes = MySQL.query.await(
        "SELECT restaurant_id, MAX(ticket) AS t FROM pickle_restaurant_orders GROUP BY restaurant_id") or {}
    for _, m in ipairs(maxes) do
        NextTicket[m.restaurant_id] = (tonumber(m.t) or 0) + 1
    end
end

local function LoadCookedItems()
    TrayCache = {}
    local rows = MySQL.query.await("SELECT * FROM pickle_restaurant_cooked_items") or {}
    for _, row in ipairs(rows) do
        if (row.count or 0) > 0 then
            TrayCache[row.restaurant_id] = TrayCache[row.restaurant_id] or {}
            TrayCache[row.restaurant_id][row.identifier] = TrayCache[row.restaurant_id][row.identifier] or {}
            TrayCache[row.restaurant_id][row.identifier][row.item] =
                { item = row.item, count = row.count, metas = dec(row.metadata, {}),
                  cookedAt = tonumber(row.cooked_at) or 0 }
        end
    end
end


local function LoadProps()
    PropCache = {}
    local rows = MySQL.query.await("SELECT * FROM pickle_restaurant_props") or {}
    for _, row in ipairs(rows) do
        row.metadata = dec(row.metadata, {})
        PropCache[row.id] = row
    end
end

function LoadRestaurants()
    RestaurantCache = {}
    local rows = MySQL.query.await("SELECT * FROM pickle_restaurants") or {}
    for _, row in ipairs(rows) do
        row.blip     = dec(row.blip, nil)
        row.counter  = dec(row.counter, nil)
        row.roles    = dec(row.roles, nil)
        row.groups   = dec(row.groups, nil)
        row.metadata = dec(row.metadata, {})
        RestaurantCache[row.id] = row
    end
end

function GetRestaurant(id) return RestaurantCache[tonumber(id)] end

-- Counters are placeable props (prop_type "counter") — a restaurant can have as
-- many register anchors as it likes, exactly like stations. The `counter` COLUMN
-- lives on as the single PRIMARY anchor everything else pins to (map blip, kitchen
-- shell XY, NPC queue origin, brand render anchor): it's the LOWEST-id counter
-- prop, recomputed whenever a counter is placed / moved / removed. No counter props
-- → nil (no register interaction, no blip). Returns true if the anchor changed.
function RecomputeCounterAnchor(restaurantId)
    restaurantId = tonumber(restaurantId)
    local r = RestaurantCache[restaurantId]
    if not r then return false end
    local best
    for _, p in pairs(PropCache) do
        if p.restaurant_id == restaurantId and p.prop_type == "counter" and (not best or p.id < best.id) then
            best = p
        end
    end
    local counter = best and { x = best.x + 0.0, y = best.y + 0.0, z = best.z + 0.0, heading = (best.heading or 0.0) + 0.0 } or nil
    local cur = r.counter
    local same = (cur == nil and counter == nil) or (cur ~= nil and counter ~= nil
        and cur.x == counter.x and cur.y == counter.y and cur.z == counter.z and cur.heading == counter.heading)
    if same then return false end
    r.counter = counter
    MySQL.update.await("UPDATE pickle_restaurants SET counter = ? WHERE id = ?",
        { counter and json.encode(counter) or nil, restaurantId })
    return true
end


-- The station type a prop row behaves as. A virtual point (an invisible anchor
-- that opens a station inside the restaurant's kitchen shell) cooks as its
-- metadata.target; everything else cooks as its own prop_type. Every cooking
-- read of prop.prop_type goes through this so virtual points inherit the full
-- station behavior while keeping their own per-row (= per point) state.
function StationType(prop)
    if prop and prop.prop_type == "virtual_point" then
        return (prop.metadata and prop.metadata.target) or ""
    end
    return prop and prop.prop_type or ""
end

-- The per-prop shape the panels consume (admin restaurants list, management
-- stations tab, placement getProps) — one place so the views can't drift.
function PropSummary(p)
    return {
        id = p.id, prop_type = p.prop_type, model = p.model,
        target = p.metadata and p.metadata.target, -- virtual points: the station they open
    }
end

-- ─── recipe groups ───────────────────────────────────────────────────────────
-- A recipe / assembly / drink / finish entry may carry an optional `group`
-- ("bakery", "pizza"…). A restaurant carries a `groups` array; it can only cook
-- and sell content whose group it carries. No group on the content = available
-- to EVERY restaurant, so a fresh install behaves exactly as before.

-- Group names are matched LOOSELY: trimmed and case-folded. They are free text
-- typed (or picked) in one panel and typed again on a food in another, so "Bakery"
-- vs "bakery" vs "Bakery " is a naming slip, not a deliberate distinction — and an
-- exact-match comparison turns that slip into a restaurant that silently can't cook
-- anything, which is indistinguishable from the feature being broken.
function NormalizeGroup(g)
    if type(g) ~= "string" then return "" end
    return (g:gsub("^%s+", ""):gsub("%s+$", "")):lower()
end

function RestaurantHasAccess(restaurantId, group)
    local want = NormalizeGroup(group)
    if want == "" then return true end
    local r = GetRestaurant(restaurantId)
    if not r then return false end
    -- No groups set on the restaurant = access to EVERYTHING. Groups are an
    -- opt-in RESTRICTION: leave empty for the full menu, add groups to limit a
    -- restaurant to only those categories.
    if type(r.groups) ~= "table" or #r.groups == 0 then return true end
    for _, g in ipairs(r.groups) do
        if NormalizeGroup(g) == want then return true end
    end
    return false
end

-- Every distinct group name in use across recipes + the grouped settings lists —
-- the suggestion pool for the admin UIs (groups exist by being used, not managed).
function CollectGroups()
    local seen, out = {}, {}
    local function add(g)
        if type(g) == "string" and g ~= "" and not seen[g] then
            seen[g] = true
            out[#out + 1] = g
        end
    end
    for _, f in ipairs(GetFoods()) do add(f.group) end
    for _, t in ipairs(GetTools()) do add(t.group) end
    for _, ing in ipairs(GetIngredientsCfg()) do add(ing.group) end
    table.sort(out)
    return out
end

-- The group a BUYABLE item files under — the heading the boss panel's Supplies tab
-- and the admin Menu tab put its row beneath. The item's own authored entry wins
-- (an ingredient's `group`, a tool's `group`); failing that it is DERIVED from what
-- consumes it, so a larder still reads as organised on a config written before the
-- shipped defaults carried groups (or one an admin only half-grouped). A derivation
-- is only trusted when every consumer agrees: an item used by two different groups
-- belongs to neither, and guessing one would file it somewhere misleading.
-- Returns nil for ungrouped (the caller shows it under "Ungrouped").
function ItemGroup(item)
    if not item or item == "" then return nil end
    local ing = IngredientDef(item)
    if ing and ing.group and ing.group ~= "" then return ing.group end
    for _, t in ipairs(GetTools()) do
        if t.item == item and t.group and t.group ~= "" then return t.group end
    end
    local found
    local function note(g)
        if not g or g == "" then return end
        if found == nil then found = g
        elseif found ~= g then found = false end -- consumers disagree: no honest answer
    end
    local rec = RecipeByInput[item]
    if rec then note(rec.group) end
    for _, a in ipairs(GetAssembly()) do
        for _, c in ipairs(a.components or {}) do
            if c == item then note(a.group) end
        end
    end
    for _, d in ipairs(GetDrinks()) do
        if d.input == item then note(d.group) end
    end
    for _, cr in ipairs(GetCrafts()) do
        for _, c in ipairs(cr.components or {}) do
            if c == item then note(cr.group) end
        end
    end
    for _, b in ipairs(GetBakingList()) do
        if b.mix_item == item then
            note(b.group)
            for _, tr in ipairs(b.trays or {}) do note(tr.group) end
        end
    end
    return found or nil
end

-- ─── ingredient cost & default pricing ───────────────────────────────────────
-- A sellable's DEFAULT menu price is what its ingredients cost the restaurant to
-- buy (the `ingredient_costs` setting) marked up by `profit_margin`. Any item's
-- cost traces down to raw ingredients: an explicit cost wins; a recipe output
-- costs its input (divided by the batch output_count → per serving); an assembly
-- output costs the sum of its components. Recursive, cycle-guarded.
function ResolveItemCost(item, seen)
    if not item then return 0 end
    local costs = IngredientCosts()
    if costs[item] ~= nil then return tonumber(costs[item]) or 0 end
    -- A VARIANTS ingredient is priced per variant (per stock key), so the bare item
    -- has no entry of its own. Cost it at its cheapest face — this only feeds
    -- default menu pricing, where the honest floor is what the restaurant could
    -- have paid, and it stops such an item reading as free.
    local vs = IngredientVariants(item)
    if vs then
        local best
        for _, v in ipairs(vs) do
            local c = tonumber(costs[StockKey(item, v.id)])
            if c and (not best or c < best) then best = c end
        end
        if best then return best end
    end
    seen = seen or {}
    if seen[item] then return 0 end
    seen[item] = true
    local rec = RecipeByOutput[item]
    if rec then
        local per = math.max(1, tonumber(rec.output_count) or 1)
        return ResolveItemCost(rec.input_item, seen) / per
    end
    for _, a in ipairs(GetAssembly()) do
        if a.output == item then
            local sum = 0
            for _, c in ipairs(a.components or {}) do sum = sum + ResolveItemCost(c, seen) end
            return sum
        end
    end
    -- A bake-tray output (raw_cake / raw_cookie) is produced by rubbing a fill
    -- tool's mix into a free tray, so it costs one mix item.
    for _, b in ipairs(GetBakingList()) do
        for _, t in ipairs(b.trays or {}) do
            if t.output == item then return ResolveItemCost(b.mix_item, seen) end
        end
    end
    return 0
end

-- Apply the global profit margin to a raw cost, rounded to whole dollars.
function MarkupPrice(cost)
    local margin = tonumber(GetSetting("profit_margin", 0)) or 0
    return RoundMoney((tonumber(cost) or 0) * (1 + margin / 100))
end

-- ─── item catalogue / validation ─────────────────────────────────────────────
-- The framework bridge populates Inventory.Items (name -> { label }). The NUI
-- needs that catalogue so configs are built by *picking* real items instead of
-- typing raw codenames, and any config that references a missing item is shown
-- with an error and hidden in-game until it's fixed.

function ItemExists(name)
    if not name or name == "" then return false end
    -- Prefer the bridge's live lookup so we never validate against a stale
    -- startup snapshot of the inventory catalogue (an item registered after this
    -- resource booted must still be recognised).
    if Inventory and Inventory.ItemExists then return Inventory.ItemExists(name) end
    local items = Inventory and Inventory.Items
    -- If the catalogue hasn't loaded yet we can't validate; don't penalise.
    if not items or next(items) == nil then return true end
    return items[name] ~= nil or items[toupper(name)] ~= nil
end

-- Sorted array of every known item: { { name, label, image }, ... }. A custom
-- admin image (ItemImageCache) wins over the inventory catalogue image, so the NUI
-- pickers/thumbnails show the same art the world does.
function BuildItemList()
    local list = {}
    local items = (Inventory and Inventory.Items) or {}
    for name, data in pairs(items) do
        list[#list + 1] = {
            name  = name,
            label = (type(data) == "table" and data.label) or name,
            image = ItemImageCache[name] or (type(data) == "table" and data.image) or nil,
        }
    end
    table.sort(list, function(a, b) return (a.label or a.name):lower() < (b.label or b.name):lower() end)
    return list
end

-- Every KITCHEN PRODUCT the authored menu creates that is NOT an installed inventory
-- item — a cooked patty, an assembled `raw_pizza`, a frosted cake, a bake tray's raw
-- sheet. These live only in the cooked-items pool, so the inventory catalogue
-- (BuildItemList) can never list them, yet they are legitimate COMPONENTS of another
-- recipe. The component pickers show this alongside the item catalogue, which is what
-- lets those pickers refuse free text: everything a component may be is now offered,
-- so anything typed that isn't here is a typo rather than a kitchen-only name.
function BuildProductList()
    local seen, list = {}, {}
    local function add(item)
        if not item or item == "" or seen[item] or ItemExists(item) then return end
        seen[item] = true
        list[#list + 1] = { name = item, label = GetItemLabel(item), image = GetItemImage(item) }
    end
    for _, r in ipairs(RecipeCache) do add(r.output_cooked_item) end
    for _, a in ipairs(GetAssembly()) do add(a.output) end
    for _, f in ipairs(GetFinishes()) do
        for _, t in ipairs(f.targets or {}) do add(t.output) end
    end
    for _, b in ipairs(GetBakingList()) do
        for _, t in ipairs(b.trays or {}) do add(t.output) end
    end
    table.sort(list, function(a, b) return (a.label or a.name):lower() < (b.label or b.name):lower() end)
    return list
end

-- Every baking CONTAINER a recipe declares, with how many servings it has to seat.
-- Feeds the admin panel's bake-seat editor, so the trays it lists are the trays that
-- exist: a container is authored on a RECIPE, never in the seat map, and typing a model
-- name into the seat editor would be the one way to author seats for a tray no recipe
-- ever renders. `slots` is the recipe's output_count (a cake tin 1, a cookie tray 6) —
-- the number of seats that container owes.
-- Deduped by model: two recipes may bake in the same tray, and the seats belong to the
-- TRAY. Where they disagree on the count, the largest wins — a seat past a shorter
-- batch's end simply goes unused, whereas a short list would leave servings unseated.
function BakeContainerList()
    local byModel, list = {}, {}
    for _, r in ipairs(RecipeCache) do
        local m = r.container_model
        if type(m) == "string" and m ~= "" then
            local n = math.max(math.floor(tonumber(r.output_count) or 1), 1)
            local e = byModel[m]
            if e then
                e.slots = math.max(e.slots, n)
            else
                e = { model = m, slots = n,
                      label = GetItemLabel(r.output_cooked_item or r.input_item) }
                byModel[m] = e
                list[#list + 1] = e
            end
        end
    end
    table.sort(list, function(a, b) return (a.label or a.model):lower() < (b.label or b.model):lower() end)
    return list
end

-- The image url for an item. An admin custom image (the `item_images` setting) wins;
-- otherwise the inventory catalogue image; nil when neither is known. Consulted by
-- every payload that shows an item, so a custom image propagates everywhere at once.
function GetItemImage(name)
    if not name then return nil end
    local override = ItemImageCache[name] or ItemImageCache[toupper(name)]
    if override then return override end
    local items = Inventory and Inventory.Items
    local data = items and (items[name] or items[toupper(name)])
    return (type(data) == "table" and data.image) or nil
end

-- Items a recipe references that don't exist in the catalogue. Cook OUTPUTS are
-- tray-held products, not necessarily items:
--   • the INPUT is always a real consumed item (bought into the shared stock pool);
--   • the COOKED output is a kitchen PRODUCT — it collects into the per-player
--     cooked-items pool and is only ever handed on via a MEAL or RESTAURANT BAG (or
--     built into an assembly), never as a bare inventory item, so it is NEVER
--     required to be installed (aligns recipe validity with IsProductItem, which
--     treats every cook output as a product);
--   • the BURNT output is NEVER an item — burnt food is unexchangeable and destroyed
--     when binned, so it's never required to be installed.
function RecipeMissingItems(r)
    local missing = {}
    -- the input must be an installed consumed item UNLESS it's itself a kitchen
    -- product (an assembled/baked intermediate like raw_pizza — tray-only)
    if not ItemExists(r.input_item) and not IsProductItem(r.input_item) then
        missing[#missing + 1] = r.input_item
    end
    if not IsProductItem(r.output_cooked_item) and not ItemExists(r.output_cooked_item) then
        missing[#missing + 1] = r.output_cooked_item
    end
    return missing
end

function IsRecipeValid(r) return #RecipeMissingItems(r) == 0 end

-- How a recipe is cooked: "grill" (cooktop surface), "oven" (inside a door), or
-- "fry" (fryer basket). Defaults to grill for an untagged row.
function RecipeMethod(r) return (r and r.method) or "grill" end

-- The item every bag-KIND food (soup, salad…) becomes when it is created in the
-- takeout box (one item for all of them; the food id is its POS variant).
-- Mirrors ServingItemName/MealItem.
function BoxItemName() return GetSetting("box_item", "takeout_box") end

-- ─── THE RESTAURANT ITEM ─────────────────────────────────────────────────────
-- ONE inventory item for ONE SERVING of anything the kitchen makes — every poured
-- drink AND every cooked/assembled product. What it is rides as a SINGLE build-stack
-- layer: { { item = <flavor key | product item>, stack = <that product's own build
-- stack> } }. That is the shape the drink item already used, which is why every
-- generic-vessel reader (FoodForItem, LayerDisplay, layerIdentity, compSpec, TraySig)
-- needed only a delegating branch rather than a new concept.
--
-- NOT to be confused with `IsProductItem` below, which asks whether a NAME is a
-- kitchen product (a tray-only output). This is the item those products are POCKETED
-- as. Renamed from `drink_item`, which it replaces outright.
function ServingItemName() return GetSetting("serving_item", "restaurant_item") end

-- The one layer a Restaurant Item carries — what this serving IS. nil for the item
-- with no readable metadata (a bare-ESX inventory, a hand-spawned one), which every
-- reader treats as a plain drink exactly as it always did.
function ServingLayer(item, meta)
    if not item or item ~= ServingItemName() then return nil end
    local l = (type(meta) == "table") and meta[1] or nil
    if type(l) ~= "table" or type(l.item) ~= "string" or l.item == "" then return nil end
    -- a serving item wrapping ITSELF is nonsense (and would recurse); refuse it here
    -- so no reader has to carry a depth guard.
    if l.item == item then return nil end
    return l
end

-- Is this key one of the fountain's flavors (a `drinks[].output`)? That is what
-- separates the two things one Restaurant Item can be: a DRINK (drunk from the
-- restaurant's capped cup, quenching thirst) or any other serving (eaten as the
-- product it holds). Derived config, so it follows the menu.
function IsDrinkOutputKey(key)
    if type(key) ~= "string" or key == "" then return false end
    for _, dd in ipairs(GetDrinks()) do
        if dd.output == key then return true end
    end
    return false
end

-- Does THIS instance of the Restaurant Item hold a drink? (an instance with no
-- readable metadata counts as one — a plain drink is the historical meaning of a
-- metadata-less vessel, and it stays drinkable rather than becoming a dud.)
function IsDrinkServing(item, meta)
    if not item or item ~= ServingItemName() then return false end
    local l = ServingLayer(item, meta)
    if not l then return true end
    return IsDrinkOutputKey(l.item)
end

-- ─── a held thing → the FOOD that authored it ────────────────────────────────
-- Every generic vessel item is one of many foods, told apart by its metadata: a
-- takeout box by the food id on its first layer, a drink by its flavor key. Anything
-- else is looked up by the terminal output it was made as. This is what lets a food's
-- OWN picture / label / eating effect follow it everywhere without borrowing an
-- inventory item's identity.
function FoodForItem(item, meta)
    if not item or item == "" then return nil end
    local first = (type(meta) == "table") and meta[1] or nil
    if item == BoxItemName() or item == BagItemName() then
        local fid = type(first) == "table" and first.craft or nil
        if fid then return DerivedFoodById[fid] end
    end
    -- THE RESTAURANT ITEM is whatever its one layer names — a fountain flavor key or
    -- a product item. Both resolve through the same two derived maps, which is why
    -- one branch covers a cola and a cooked burger alike.
    if item == ServingItemName() then
        local key = type(first) == "table" and first.item or nil
        if key then return DerivedFoodById[key] or DerivedFoodByOutput[key] end
    end
    return DerivedFoodByOutput[item] or DerivedFoodById[item]
end

-- The picture a food shows AS AN ITEM — the hotbar/tray card, the POS, the bag's
-- contents menu, the inventory slot. Authored on the food; falls back to the vessel
-- item's own art so nothing is ever blank.
function FoodImageUrl(food, item)
    local url = type(food) == "table" and type(food.image) == "table" and food.image.url or nil
    if url and url ~= "" then return url end
    return item and AbsItemImage(item) or nil
end

-- The CROP that belongs with FoodImageUrl's picture ({x,y,w,h}, 0..1) — nil when the
-- food authored no image of its own (the item's catalogue art is already square) or
-- cropped none. Surfaces that draw the card art at its own shape honour this; the
-- inventory-style thumbnails deliberately don't.
function FoodImageCrop(food)
    local img = type(food) == "table" and type(food.image) == "table" and food.image or nil
    return img and img.crop or nil
end

-- The picture painted on the quad INSIDE an open takeout box: its url AND the
-- normalised source rectangle the admin cropped ({x,y,w,h}, 0..1) — the quad's DUI
-- draws exactly that rect, the same contract brand textures use, so what was cropped
-- in the panel is what lands in the box. Its own setting when the card art doesn't
-- work lying in a box (a packshot vs the bare food), otherwise the picture the item
-- shows (with ITS crop). Returns url, crop.
function FoodBoxImageUrl(food, item)
    local box = type(food) == "table" and type(food.box_image) == "table" and food.box_image or nil
    if box and type(box.url) == "string" and box.url ~= "" then return box.url, box.crop end
    local own = type(food) == "table" and type(food.image) == "table" and food.image or nil
    if own and type(own.url) == "string" and own.url ~= "" then return own.url, own.crop end
    return FoodImageUrl(food, item), nil
end

-- What using ONE serving of a held thing does: { hunger, thirst, stress, anim },
-- resolved from the food that authored it and filled in from the global `consume`
-- setting. `anim` is the full clip spec (dict/clip/prop/ms) so the client needs no
-- catalogue.
--
-- An INGREDIENT may author the block too, and is consulted when no FOOD claims the
-- item. That is what makes a thing-in-its-own-right possible without inventing a
-- fourth authoring kind: a DLC toy is an ingredient (it has a prop, it's bought
-- into the larder, it drops into a bag or onto a meal tray like any component) that
-- happens to also say what using one does. A component that authors nothing —
-- lettuce — resolves to the global fallback exactly as before, and is never offered
-- on its own anyway.
function ConsumeSpecFor(item, meta)
    local fallback = GetSetting("consume", {}) or {}
    local own = (FoodForItem(item, meta) or {}).consume
    if not own then
        -- No food claims it: fall through to the ingredient, then to THIS INSTANCE's
        -- variant layered over it. That layering is what lets one `restaurant_toy`
        -- item hold five toys that share an animation and a bite count but relieve
        -- different amounts of stress — the variant states only what differs.
        local ing = IngredientDef(item)
        own = ing and ing.consume or nil
        local v = ing and IngredientVariantOf(item, meta)
        if v and v.consume then
            local merged = {}
            for k, val in pairs(own or {}) do merged[k] = val end
            for k, val in pairs(v.consume) do merged[k] = val end
            own = merged
        end
        own = own or {}
    end
    -- A DRINK whose food states no effect of its own quenches thirst rather than
    -- hunger, and is drunk rather than eaten. Without this an upgraded server (whose
    -- stored foods predate `consume`) would have every drink feed the wrong bar
    -- until someone edited it — the seeded defaults only reach a fresh install.
    -- A Restaurant Item is only a DRINK when the serving it holds is one: the same
    -- item now also holds cooked food, and a burger must not be quenching thirst
    -- through a bottle-drinking clip.
    local isDrink = IsDrinkServing(item, meta)
    local silent = own.hunger == nil and own.thirst == nil
    local function pick(k, d)
        local v = own[k]
        if v == nil and isDrink and silent then
            -- swap the fallback's food value onto thirst for an un-authored drink
            v = (k == "thirst") and (fallback.thirst ~= nil and fallback.thirst ~= 0
                and fallback.thirst or fallback.hunger) or 0
        end
        if v == nil then v = fallback[k] end
        v = tonumber(v)
        if not v then v = d end
        return math.max(0, math.min(100, math.floor(v)))
    end
    local animId = own.anim or (isDrink and not own.anim and silent and "drink_cup") or fallback.anim
    local anim, first
    for _, a in ipairs(ConsumeAnims()) do
        first = first or a
        if a.id == animId then anim = a break end
    end
    -- How many BITES (or SIPS) a serving takes. One portion is spread across them:
    -- each mouthful restores its share, and the food only leaves the vessel on the
    -- last one — so a burger eaten in three goes feeds exactly as much as a burger
    -- swallowed whole. Authored per food, else the global `consume` fallback, else
    -- the defaults below (drinks get one more, because sipping reads as slower).
    local portions = tonumber(own.bites) or tonumber(fallback.bites)
    if not portions then portions = isDrink and 4 or 3 end
    portions = math.max(1, math.min(20, math.floor(portions)))
    local hunger, thirst = pick("hunger", 25), pick("thirst", 0)
    -- `stress` never inherits the global fallback: that setting is the FOOD default
    -- ("what a serving with no opinion feeds"), and quietly relaxing everyone who
    -- eats a burger is not what an admin typing a number there is asking for. Stress
    -- relief is only ever what an entry explicitly says it is.
    local stress = math.max(0, math.min(100, math.floor(tonumber(own.stress) or 0)))
    -- Something that relieves stress and feeds NOTHING isn't eaten — it's used (a
    -- toy). One flag, derived rather than authored, decides the verb the player is
    -- offered, the notification they get and the icon on the row; nothing else about
    -- the consume path changes.
    local play = (stress > 0 and hunger == 0 and thirst == 0) or nil
    return { hunger = hunger, thirst = thirst, stress = stress,
             anim = anim or first, bites = portions, drink = isDrink or nil, play = play }
end
function BoxBaseModel() return GetSetting("box_base_model", "pickle_takeout_box_01") end
function BoxLidModel()  return GetSetting("box_lid_model", "pickle_takeout_box_02") end

-- The TAKEOUT CARRIER item: one Restaurant Bag holding any number of finished
-- foods/drinks as its build-stack metadata (the takeaway counterpart of the
-- eat-in meal). Mirrors MealItem.
function BagItemName() return GetSetting("bag_item", "restaurant_bag") end
function BagModel() return GetSetting("bag_model", "pickle_restaurant_bag_01") end

-- A CARRIER NEVER GOES INSIDE ANOTHER CARRIER. The serving tray and the Restaurant
-- Bag are both multi-item carriers whose contents ride as build-stack metadata, so
-- nesting one in the other is a container inside itself: the layer would render as a
-- bare bag/meal prop lying on a tray, its own contents invisible, and every consumer
-- that walks a vessel's layers (the eat menu, layerIdentity, the POS's mealCovers,
-- prepDecompose) would have to recurse a second vessel layer deep to describe or
-- refund it. Fulfilment would double-count too — a bagged meal's units would be
-- claimable through both carriers. A TAKEOUT BOX is deliberately NOT here: it holds
-- exactly one food and IS a sellable unit, so a box on a tray or in a bag is a side
-- in its box, which the render/consume paths already handle.
function IsCarrierItem(item)
    if not item or item == "" then return false end
    return item == BagItemName() or item == GetSetting("meal_item", "meal")
end

-- A bag food's raw ingredient cost = the sum of its component costs (the bag
-- output itself is free packaging, never an ingredient). Default menu price.
function CraftCost(cr)
    local sum = 0
    for _, c in ipairs(cr.components or {}) do sum = sum + ResolveItemCost(c) end
    return sum
end

-- ─── unified menu: annotation (admin panel payloads) ─────────────────────────
-- Shallow-copied so annotations never leak back into the stored config (the NUI
-- strips them before save regardless). Validity rules:
--   • a raw consumed item (cook input, component, cup, tool bottle) must be an
--     installed inventory item — UNLESS it's itself a kitchen product (an
--     intermediate like raw_pizza / a cooked patty), which is tray-only;
--   • a cook output is a kitchen product (tray-held) — it's handed on only via a
--     meal or restaurant bag (or built into an assembly), never as a bare inventory
--     item, so it is never required to be installed;
--   • burnt outputs are never required.

function AnnotateFoods()
    -- the ONE Restaurant Item every poured drink now collects as (it replaced the
    -- separate drink item); a pour step reports it missing exactly as before
    local drinkInstalled = ItemExists(ServingItemName())
    -- a bag-kind food is created in the TAKEOUT BOX and collects as the box item
    local boxInstalled = ItemExists(BoxItemName())
    local inputOwner = {}  -- duplicate cook-input detection (replaces the SQL unique key)
    local pourIndex = 0
    local out = {}
    for _, f in ipairs(GetFoods()) do
        local copy = {}; for k, v in pairs(f) do copy[k] = v end
        local missing = {}
        local function needItem(item)
            if item and not ItemExists(item) and not IsProductItem(item) then
                missing[#missing + 1] = item
            end
        end
        -- NOTHING IS MADE FROM NOTHING. Every step of every food has to CONSUME
        -- something: components to combine, an input to cook, a cup to pour into.
        -- A step with none would be creatable out of thin air, so the derivation
        -- refuses to build it (RebuildDerived) and this flags it here with the step
        -- that's empty, rather than leaving the entry silently inert in-game.
        local empty = nil
        local function needsInput(what) empty = empty or what end
        if f.kind == "bag" then
            if #(f.components or {}) == 0 then needsInput("components") end
            for _, c in ipairs(f.components or {}) do needItem(c) end
            -- NOTE: no display-item check. A bag-kind food authors its own picture
            -- and label (`image`/`label`); it never borrows an inventory item's
            -- identity, so there is nothing here that has to be installed except the
            -- takeout box item it collects as.
            copy.box_item_installed = boxInstalled
            copy.defaultPrice = MarkupPrice(CraftCost(f))
        else
            local prevOutput, priceItem = nil, nil
            for _, st in ipairs(f.steps or {}) do
                if st.type == "cook" then
                    local input = st.input or prevOutput
                    needItem(input)
                    if not input or input == "" then needsInput("cook_input") end
                    if input then
                        if inputOwner[input] and inputOwner[input] ~= f.id then
                            copy.duplicate_input = input
                        else
                            inputOwner[input] = f.id
                        end
                    end
                    if st.output and not IsProductItem(st.output) and not ItemExists(st.output) then
                        missing[#missing + 1] = st.output
                    end
                    prevOutput, priceItem = st.output, st.output
                elseif st.type == "assemble" then
                    if #(st.components or {}) == 0 then needsInput("components") end
                    for _, c in ipairs(st.components or {}) do needItem(c) end
                    prevOutput, priceItem = st.output, st.output
                elseif st.type == "pour" then
                    if not st.input or st.input == "" then needsInput("pour_cup") end
                    if st.input and not ItemExists(st.input) then missing[#missing + 1] = st.input end
                    copy.serving_item_installed = drinkInstalled
                    pourIndex = pourIndex + 1
                    copy.tap = (pourIndex <= 6) and pourIndex or nil
                    priceItem = st.input
                end
            end
            if #(f.steps or {}) == 0 then needsInput("steps") end
            copy.defaultPrice = MarkupPrice(ResolveItemCost(priceItem))
        end
        copy.no_input = empty
        copy.valid, copy.missing = (#missing == 0 and not empty), missing
        out[#out + 1] = copy
    end
    return out
end

function AnnotateTools()
    local out = {}
    for _, t in ipairs(GetTools()) do
        local copy = {}; for k, v in pairs(t) do copy[k] = v end
        local missing = {}
        if not ItemExists(t.item) then missing[#missing + 1] = t.item end
        if t.mode == "decorate" then
            for _, tg in ipairs(t.targets or {}) do
                -- a target/output that's a tray PRODUCT is valid without being installed
                if not IsProductItem(tg.item)   and not ItemExists(tg.item)   then missing[#missing + 1] = tg.item end
                if not IsProductItem(tg.output) and not ItemExists(tg.output) then missing[#missing + 1] = tg.output end
            end
        elseif t.mode == "fill" then
            for _, tr in ipairs(t.trays or {}) do
                if tr.output and not ItemExists(tr.output) and not IsProductItem(tr.output) then
                    missing[#missing + 1] = tr.output
                end
            end
        end
        copy.valid, copy.missing = #missing == 0, missing
        out[#out + 1] = copy
    end
    return out
end

function AnnotateIngredients()
    local costs = IngredientCosts()
    local out = {}
    for _, ing in ipairs(GetIngredientsCfg()) do
        local copy = {}; for k, v in pairs(ing) do copy[k] = v end
        local missing = {}
        if not ItemExists(ing.item) then missing[#missing + 1] = ing.item end
        -- What it costs to buy and what it would therefore sell for. Both were
        -- missing here, so an ingredient row could show neither — and a DLC row,
        -- whose cost is the ONE thing the panel may change, had nothing to show at
        -- all. `costKey` is what a cost edit writes: the stock key, so a multi-faced
        -- ingredient is priced per face.
        copy.costKey = ing.item
        copy.cost = tonumber(costs[ing.item]) or 0
        copy.defaultPrice = MarkupPrice(ResolveItemCost(ing.item))
        -- Variants are COPIED before annotating: the originals belong to the pack
        -- that registered them, and stamping prices onto those tables would write
        -- into content we don't own (and leak between restaurants).
        if type(ing.variants) == "table" then
            local vs = {}
            for _, v in ipairs(ing.variants) do
                local vc = {}; for k, val in pairs(v) do vc[k] = val end
                vc.costKey = StockKey(ing.item, v.id)
                vc.cost = tonumber(costs[vc.costKey]) or 0
                vc.defaultPrice = MarkupPrice(ResolveItemCost(vc.costKey))
                vs[#vs + 1] = vc
            end
            copy.variants = vs
        end
        copy.valid, copy.missing = #missing == 0, missing
        out[#out + 1] = copy
    end
    return out
end

-- ─── jobs & ranks (who works here, and what they may do) ─────────────────────
-- A restaurant is STAFFED BY A JOB. `metadata.job` names it and `metadata.ranks`
-- says what each GRADE of that job may do here — so hiring, firing and promoting
-- are the framework's own job actions and there is no private employee roster to
-- keep in step with them. (The `pickle_restaurant_employees` table is legacy; see
-- the CREATE.) The framework is reached only through the bridge job API
-- (GetJobList / GetPlayerJobInfo / …), which every variant defines — including the
-- standalone one, where WE are the job system.

-- The `jobs` setting (standalone only), validated on READ like every other
-- admin-editable list: the NUI is untrusted, and a malformed grade here would mean a
-- restaurant whose ranks can't be resolved.
function SanitizeJobs(list)
    local out, seen = {}, {}
    for _, j in ipairs(type(list) == "table" and list or {}) do
        if type(j) == "table" then
            local name = trimStr(j.name) or (trimStr(j.label) and foodSlug(j.label))
            if name and not seen[name] then
                seen[name] = true
                local grades, gseen = {}, {}
                for _, g in ipairs(type(j.grades) == "table" and j.grades or {}) do
                    if type(g) == "table" then
                        local lvl = math.max(0, math.floor(numOr(g.grade, 0)))
                        if not gseen[lvl] then
                            gseen[lvl] = true
                            grades[#grades + 1] = { grade = lvl,
                                                    label = trimStr(g.label) or _L("job_grade_n", lvl),
                                                    isboss = g.isboss == true or nil }
                        end
                    end
                end
                table.sort(grades, function(a, b) return a.grade < b.grade end)
                -- A job with no grades can never have a boss, so nobody could ever
                -- manage a restaurant assigned to it: give it grade 0 as the boss.
                if #grades == 0 then
                    grades[1] = { grade = 0, label = _L("job_grade_n", 0), isboss = true }
                end
                out[#out + 1] = { name = name:sub(1, 60), label = trimStr(j.label) or name, grades = grades }
            end
        end
    end
    return out
end

function StandaloneJobs() return SanitizeJobs(GetSetting("jobs", {})) end

-- The job a restaurant is staffed by, or nil (unassigned — then only the owner and
-- admins can do anything there, which is the sane out-of-the-box state).
function RestaurantJob(rid)
    local r = GetRestaurant(rid)
    local j = r and type(r.metadata) == "table" and r.metadata.job or nil
    return (type(j) == "string" and j ~= "") and j or nil
end

-- One rank config, sanitized. `permissions` is filtered against PERMISSIONS so a
-- forged key can never appear in a perms table; `boss` short-circuits to ALL_PERMS
-- wherever it's read, so what's stored for a boss grade doesn't matter.
local function sanitizeRank(cfg, label, boss)
    cfg = type(cfg) == "table" and cfg or {}
    local perms = {}
    for _, p in ipairs(PERMISSIONS) do
        if type(cfg.permissions) == "table" and cfg.permissions[p] == true then perms[p] = true end
    end
    local isBoss = (cfg.boss == true) or (boss == true) or nil
    if isBoss then
        for _, p in ipairs(PERMISSIONS) do perms[p] = true end
    end
    return {
        label       = trimStr(cfg.label) or label,
        permissions = perms,
        commission  = math.max(0, math.min(100, math.floor(numOr(cfg.commission,
                          tonumber(GetSetting("default_commission", 10)) or 10)))),
        salary      = math.max(0, math.floor(numOr(cfg.salary, 0))),
        boss        = isBoss,
    }
end

-- Every rank of a restaurant's job, keyed by GRADE NUMBER — always complete: the
-- framework's grades UNION whatever the restaurant has authored. Complete matters
-- because a grade added to the job after the restaurant was set up must still be
-- workable (it gets `default_rank_permissions`), and a rank authored for a grade the
-- framework has since dropped must still be visible so it can be cleaned up.
--
-- Stored under STRING keys (it lives in a JSON column, which has no other kind), read
-- back as numbers so every caller can just index by grade.
function RestaurantRanks(rid)
    local r = GetRestaurant(rid)
    if not r then return {} end
    local stored = (type(r.metadata) == "table" and type(r.metadata.ranks) == "table") and r.metadata.ranks or {}
    local defaults = type(GetSetting("default_rank_permissions", {})) == "table"
        and GetSetting("default_rank_permissions", {}) or {}
    local out = {}
    local function put(grade, label, boss)
        grade = tonumber(grade)
        if not grade or out[grade] then return end
        local cfg = stored[tostring(grade)] or stored[grade]
        -- No authored rank for this grade: it gets the default permission set (a new
        -- grade must be able to work, not silently be locked out of the kitchen).
        if type(cfg) ~= "table" then cfg = { permissions = defaults } end
        out[grade] = sanitizeRank(cfg, label or _L("job_grade_n", grade), boss)
    end
    local job = RestaurantJob(rid)
    if job and GetJobGradeList then
        for _, g in ipairs(GetJobGradeList(job) or {}) do put(g.grade, g.label, g.isboss) end
    end
    for k in pairs(stored) do put(k) end
    return out
end

-- ONE rank, never nil. A grade the job doesn't declare (renamed away, or a player
-- moved by another script) still HOLDS the job, so it resolves to a basic employee —
-- the default permissions, never boss.
function RankFor(rid, grade)
    local ranks = RestaurantRanks(rid)
    local g = tonumber(grade) or 0
    if ranks[g] then return ranks[g] end
    local defaults = type(GetSetting("default_rank_permissions", {})) == "table"
        and GetSetting("default_rank_permissions", {}) or {}
    return sanitizeRank({ permissions = defaults }, _L("job_grade_n", g), false)
end

-- Write-through of ONE rank. Sanitized here rather than at the call site so a panel
-- can hand the stored shape straight in.
function SetRestaurantRank(rid, grade, cfg)
    rid = tonumber(rid)
    local r = GetRestaurant(rid); if not r then return false end
    grade = tonumber(grade); if not grade then return false end
    local job = RestaurantJob(rid)
    local boss = (job and IsJobBossGrade and IsJobBossGrade(job, grade)) or false
    r.metadata = type(r.metadata) == "table" and r.metadata or {}
    r.metadata.ranks = type(r.metadata.ranks) == "table" and r.metadata.ranks or {}
    r.metadata.ranks[tostring(grade)] = sanitizeRank(cfg, _L("job_grade_n", grade), boss)
    MySQL.update.await("UPDATE pickle_restaurants SET metadata = ? WHERE id = ?", { json.encode(r.metadata), rid })
    return true
end

-- Assign (or clear, jobName nil) a restaurant's job and SEED one rank per grade of
-- it: boss grades get everything, the rest get `default_rank_permissions`. Seeding
-- up front is what makes the Ranks editor immediately meaningful instead of an empty
-- list the boss has to guess the shape of. An existing rank for a grade is KEPT — a
-- re-assignment to the same job must not wipe a boss's tuning.
function SetRestaurantJob(rid, jobName)
    rid = tonumber(rid)
    local r = GetRestaurant(rid); if not r then return false end
    jobName = trimStr(jobName)
    r.metadata = type(r.metadata) == "table" and r.metadata or {}
    r.metadata.job = jobName
    if jobName then
        local defaults = type(GetSetting("default_rank_permissions", {})) == "table"
            and GetSetting("default_rank_permissions", {}) or {}
        local stored = type(r.metadata.ranks) == "table" and r.metadata.ranks or {}
        for _, g in ipairs((GetJobGradeList and GetJobGradeList(jobName)) or {}) do
            local key = tostring(g.grade)
            if type(stored[key]) ~= "table" then
                stored[key] = sanitizeRank({ permissions = defaults }, g.label, g.isboss)
            end
        end
        r.metadata.ranks = stored
        -- The job's account is where this restaurant's money now lives, so make sure it
        -- EXISTS the moment the job is assigned. A provider that creates on first write
        -- answers true and does nothing; one that doesn't (Renewed-Banking) gets its
        -- account made here, before the first sale needs somewhere to land.
        -- SAY SO WHEN THE ACCOUNT COULD NOT BE MADE. Some banks refuse to create one
        -- for us (and Renewed 2.1.4 fails at it outright — see its provider file), and
        -- a restaurant whose account does not exist reads as broke, refuses every
        -- deposit and pays no wages, with nothing anywhere to say why.
        if EnsureSocietyAccount then
            local label = (GetJobLabel and GetJobLabel(jobName)) or r.label
            if not EnsureSocietyAccount(jobName, label) then
                print(("[pickle_restaurants] ^3could not create a business account for job '%s' in %s. "
                    .. "Create it in your banking resource, or restaurant %s cannot hold money.^7")
                    :format(jobName, SocietyProvider and SocietyProvider() or "?", tostring(rid)))
            end
        end
    end
    MySQL.update.await("UPDATE pickle_restaurants SET metadata = ? WHERE id = ?", { json.encode(r.metadata), rid })
    -- No world sync here on purpose. Assigning a job changes `metadata.job`/`metadata.ranks`
    -- and neither is in the sync payload — BuildClientRestaurant carries none of it, because
    -- employment is server-side authority (ResolvePerms) and no client renders it. This used
    -- to push the ENTIRE world config to every player to change nothing observable.
    return true
end

-- Everyone holding the restaurant's job, annotated with the RESTAURANT's rank labels
-- (the boss renames a grade for their own staff, not for the framework). `cb` is
-- always called — with an empty list when no job is assigned.
--
-- Callback-shaped because a bridge's roster MAY be async (the contract allows it);
-- every variant we ship answers inline, which is what `RosterNow` below relies on.
function RestaurantRoster(rid, cb)
    rid = tonumber(rid)
    local job = RestaurantJob(rid)
    if not job or not GetJobEmployees then
        if type(cb) == "function" then cb({}) end
        return
    end
    local ranks = RestaurantRanks(rid)
    GetJobEmployees(job, function(list)
        local out = {}
        for _, e in ipairs(list or {}) do
            local grade = tonumber(e.grade) or 0
            local rank = ranks[grade]
            out[#out + 1] = {
                identifier = e.identifier,
                name       = e.name or e.identifier,
                grade      = grade,
                gradeLabel = (rank and rank.label) or e.gradeLabel or _L("job_grade_n", grade),
                boss       = (rank and rank.boss == true) or false,
            }
        end
        if type(cb) == "function" then cb(out) end
    end)
end

-- The roster as a plain return, for the money paths (which are written straight-line
-- and can't be turned inside out around a callback). Every shipped bridge calls back
-- inline; one that didn't would yield an empty list here rather than paying a
-- half-built roster, which is the safe way to be wrong about money.
function RosterNow(rid)
    local got = nil
    RestaurantRoster(rid, function(list) got = list end)
    return got or {}
end

-- ─── permissions ─────────────────────────────────────────────────────────────

-- Returns: permsTable, isBoss, jobInfo (the bridge's job info table for `source`).
-- The ONE authority — every mutating callback gates on this (or on HasPerm).
--
-- Note DUTY is not consulted: plenty of servers never toggle it, and a restaurant
-- nobody can work because a flag defaults to off is indistinguishable from broken.
function ResolvePerms(restaurantId, source)
    local r = GetRestaurant(restaurantId)
    if not r then return nil, false, nil end
    if IsPlayerAdmin(source) then return ALL_PERMS, true, nil end
    local id = GetIdentifier(source)
    if not id then return nil, false, nil end
    if r.owner_identifier and r.owner_identifier == id then return ALL_PERMS, true, nil end
    local job = RestaurantJob(restaurantId)
    if not job then return nil, false, nil end
    local info = GetPlayerJobInfo and GetPlayerJobInfo(source) or nil
    if not info or info.name ~= job then return nil, false, nil end
    local rank = RankFor(restaurantId, info.grade)
    -- Boss either way round: the framework's own per-grade flag, or the rank the
    -- restaurant marked as its boss (a server whose job defs have no boss grade must
    -- still be able to appoint a manager).
    if info.isBoss == true or rank.boss == true then return ALL_PERMS, true, info end
    return rank.permissions or {}, false, info
end

function HasPerm(restaurantId, source, perm)
    local perms, isOwner = ResolvePerms(restaurantId, source)
    if not perms then return false end
    if isOwner then return true end
    return perms[perm] == true
end

-- A player's job changed (or a job DEFINITION did — then `src` is nil and it applies
-- to everyone holding it). Every bridge funnels its framework's own event into this
-- one, and nothing here is cached per player, so there is nothing to invalidate
-- server-side: what needs telling is the CLIENT, whose open phone/panel is showing
-- the employment it resolved a moment ago. Relayed as one client event so those
-- surfaces can re-ask rather than sitting on a stale answer.
AddEventHandler("pickle_restaurants:jobChanged", function(src)
    TriggerClientEvent("pickle_restaurants:jobChanged", src and tonumber(src) or -1)
end)

-- ─── balance / ledger / stock ────────────────────────────────────────────────
-- THE BALANCE IS THE JOB'S SOCIETY ACCOUNT. We host no money: `bridge/society` resolves
-- whichever banking resource the server runs and every dollar in and out of a restaurant
-- moves THERE, so the boss menu, a job's own banking UI and this resource can't disagree
-- about what a business is worth. The `pickle_restaurants.balance` column is dead —
-- declared (the schema is declared, never migrated) and never read or written again.
--
-- No job assigned ⇒ no account ⇒ no money movement. That is the same rule employment
-- follows, and it is why a restaurant REQUIRES a job.

-- The standalone store, used ONLY when no banking resource exists (bridge/society's
-- FALLBACK provider calls these). Rows are per JOB, not per restaurant: two restaurants
-- sharing a job share their books, which is what a society account means everywhere else.
function SocietyLocalBalance(job)
    if not job or job == "" then return 0 end
    local row = MySQL.single.await("SELECT amount FROM pickle_restaurant_society WHERE job = ?", { job })
    return math.floor(tonumber(row and row.amount) or 0)
end

function SocietyLocalAdjust(job, delta)
    if not job or job == "" then return false end
    delta = RoundMoney(delta)
    if delta == 0 then return true end
    -- ONE statement, so two concurrent sales can't both read-then-write the same total.
    -- The WHERE clause is what refuses an overdraw: no row is updated when the funds
    -- aren't there, and `affectedRows` reports it.
    if delta < 0 then
        local res = MySQL.update.await(
            "UPDATE pickle_restaurant_society SET amount = amount + ? WHERE job = ? AND amount >= ?",
            { delta, job, -delta })
        return (tonumber(res) or 0) > 0
    end
    MySQL.query.await([[
        INSERT INTO pickle_restaurant_society (job, amount) VALUES (?, ?)
        ON DUPLICATE KEY UPDATE amount = amount + VALUES(amount)
    ]], { job, delta })
    return true
end

-- What a restaurant is worth right now. Read it; never cache it — the account is shared
-- with the rest of the server and can move without us.
function RestaurantBalance(restaurantId)
    local job = RestaurantJob(restaurantId)
    if not job then return 0 end
    return GetSocietyBalance and GetSocietyBalance(job) or 0
end

-- Move money in (delta > 0) or out (delta < 0). Returns TRUE only if the account
-- actually moved: a withdrawal that would overdraw is refused, and callers must treat
-- false as "the money did not move" rather than assuming it did.
function AdjustBalance(restaurantId, delta)
    local job = RestaurantJob(restaurantId)
    delta = RoundMoney(delta)
    if delta == 0 then return true end
    if not job then
        -- Loud, not silent: an unassigned restaurant taking a customer's cash would drop
        -- it on the floor, and that is a money bug someone has to be able to find.
        print(("[pickle_restaurants] ^1restaurant %s has no job, so it has no account: %s not moved^7")
            :format(tostring(restaurantId), tostring(delta)))
        return false, "no_job"
    end
    local ok
    if delta > 0 then ok = AddSocietyMoney(job, delta) else ok = RemoveSocietyMoney(job, -delta) end
    if not ok and delta > 0 then
        print(("[pickle_restaurants] ^1society credit REFUSED by %s (restaurant %s, job '%s', %s). "
            .. "The bank most likely has no account under that job name — create one there. "
            .. "The ledger row still records it, so reconcile by hand.^7")
            :format(SocietyProvider and SocietyProvider() or "?", tostring(restaurantId), job, tostring(delta)))
    end
    -- The SECOND return says WHY, because the two refusals need different words in
    -- front of a boss: "no job assigned" is an admin's job to fix, "the bank said no"
    -- is not, and a panel that says the first when it means the second sends them
    -- looking at a setting that is already correct.
    if ok then return true end
    return false, "refused"
end

function AddLedger(restaurantId, ltype, amount, description, identifier)
    MySQL.insert("INSERT INTO pickle_restaurant_ledger (restaurant_id, type, amount, description, identifier) VALUES (?, ?, ?, ?, ?)",
        { restaurantId, ltype, RoundMoney(amount), description or "", identifier })
end

-- ─── tips & payroll ──────────────────────────────────────────────────────────
-- A TIP IS STAFF MONEY, NOT HOUSE MONEY. It used to be added to the restaurant
-- balance, which quietly made every gratuity the owner's — so tips now land in
-- `pickle_restaurant_tips` as unpaid rows and never touch the balance in either
-- direction. The POOL is the unpaid rows; paying it out splits it across the current
-- roster and marks them paid.
--
-- SALARIES are the other direction: they DO come out of the balance (that is what a
-- wage is), one payroll row per recipient plus a single ledger line, and the whole run
-- is refused if the balance can't cover it — a half-paid payroll is worse than a late
-- one.
--
-- Both pay ONLINE staff only. There is no deferred-wages store (the one deferral
-- machinery this resource has, pending refunds, exists because a CUSTOMER must never
-- lose money they already spent), and a wage nobody was present to earn is better
-- caught by the next run than parked forever. That is also why the tip pool is left
-- untouched when nobody is on shift, instead of being paid to an empty room.

function AddTip(rid, amount, identifier, source)
    rid = tonumber(rid)
    amount = RoundMoney(amount)
    if not rid or amount <= 0 then return false end
    TipCache[rid] = (TipCache[rid] or 0) + amount
    MySQL.insert("INSERT INTO pickle_restaurant_tips (restaurant_id, identifier, amount, source) VALUES (?, ?, ?, ?)",
        { rid, identifier, amount, tostring(source or "order"):sub(1, 16) })
    return true
end

function TipPool(rid) return TipCache[tonumber(rid)] or 0 end

-- One payroll row per person paid — the audit behind the Payroll tab (`kind` is
-- "tips" or "salary").
local function AddPayrollRow(rid, m, amount, kind)
    MySQL.insert("INSERT INTO pickle_restaurant_payroll (restaurant_id, identifier, name, grade, amount, kind) "
        .. "VALUES (?, ?, ?, ?, ?, ?)",
        { rid, m.identifier, m.name, m.grade or 0, RoundMoney(amount), kind })
end

-- The roster members who are actually reachable right now, each with its live source.
local function PayableRoster(rid)
    local out = {}
    for _, m in ipairs(RosterNow(rid)) do
        local src = ResolveSourceForIdentifier(m.identifier)
        if src then
            out[#out + 1] = { identifier = m.identifier, name = m.name, grade = m.grade,
                              gradeLabel = m.gradeLabel, source = src }
        end
    end
    return out
end

-- Split the unpaid pool across the roster and pay it out. Returns paid, recipients
-- (and an error key as a third return when there was nothing to do).
function PayTips(rid)
    rid = tonumber(rid)
    local total = TipPool(rid)
    if total <= 0 then return 0, {}, "tips_none" end
    local roster = PayableRoster(rid)
    if #roster == 0 then return 0, {}, "tips_no_staff" end

    -- "even" = equal shares; "grade" = weighted by grade + 1 (grade 0 still earns a
    -- share — a weight of zero would mean a trainee works the shift for nothing).
    local byGrade = GetSetting("tip_split", "even") == "grade"
    local weights, sum = {}, 0
    for i, m in ipairs(roster) do
        weights[i] = byGrade and ((tonumber(m.grade) or 0) + 1) or 1
        sum = sum + weights[i]
    end

    -- Whole dollars, and the ROUNDING REMAINDER goes to the first recipient rather
    -- than being lost: the pool is emptied by this payout, so every cent of it has to
    -- land on somebody.
    local shares, handed = {}, 0
    for i = 1, #roster do
        shares[i] = math.floor(total * weights[i] / sum)
        handed = handed + shares[i]
    end
    shares[1] = shares[1] + (total - handed)

    -- CLAIM FIRST, exactly as RefundOrder does: empty the pool before any payout, so
    -- a second call (or one racing the payroll thread) finds nothing left to pay.
    TipCache[rid] = 0
    MySQL.update.await("UPDATE pickle_restaurant_tips SET paid = 1 WHERE restaurant_id = ? AND paid = 0", { rid })

    local recipients = {}
    for i, m in ipairs(roster) do
        local amount = shares[i]
        if amount > 0 then
            AddMoney(m.source, amount, "money")
            AddPayrollRow(rid, m, amount, "tips")
            ShowNotification(m.source, _L("payroll_tips_paid", GetCurrencyString(amount)))
            recipients[#recipients + 1] = { identifier = m.identifier, name = m.name,
                                            grade = m.grade, amount = amount }
        end
    end
    -- Ledger, not AdjustBalance: the money was never in the balance to take out of it.
    -- The line exists so the finances tab can still account for what left the business.
    AddLedger(rid, "payroll", -total, _L("ledger_tips_paid", #recipients), nil)
    return total, recipients
end

-- Pay every roster member their rank's salary. Returns paid, recipients (and an error
-- key as a third return when the run didn't happen).
function RunPayroll(rid)
    rid = tonumber(rid)
    local r = GetRestaurant(rid); if not r then return nil, nil, "no_restaurant" end
    local ranks = RestaurantRanks(rid)
    local due, total = {}, 0
    for _, m in ipairs(PayableRoster(rid)) do
        local rank = ranks[m.grade] or RankFor(rid, m.grade)
        local salary = math.max(0, math.floor(tonumber(rank.salary) or 0))
        if salary > 0 then
            m.amount = salary
            due[#due + 1] = m
            total = total + salary
        end
    end
    if total <= 0 then return 0, {}, "payroll_none" end
    -- ALL OR NOTHING. Paying the first three of five staff and leaving the rest owed
    -- is the failure mode a boss can't unpick, so a short balance refuses the run.
    -- The DEBIT is the check that counts: the balance is a society account shared with
    -- the rest of the server, so it can move between a read and a write. Take the whole
    -- wage bill out FIRST and only pay anyone if that succeeded — the pre-read is just a
    -- cheap early exit.
    if RestaurantBalance(rid) < total then return nil, nil, "payroll_insufficient" end
    if not AdjustBalance(rid, -total) then return nil, nil, "payroll_insufficient" end
    local recipients = {}
    for _, m in ipairs(due) do
        AddMoney(m.source, m.amount, "money")
        AddPayrollRow(rid, m, m.amount, "salary")
        ShowNotification(m.source, _L("payroll_salary_paid", GetCurrencyString(m.amount)))
        recipients[#recipients + 1] = { identifier = m.identifier, name = m.name,
                                        grade = m.grade, amount = m.amount }
    end
    AddLedger(rid, "payroll", -total, _L("ledger_payroll", #recipients), nil)
    return total, recipients
end

-- Automatic salary runs. One thread for every restaurant (the cadence is global —
-- it's a server policy, not a per-restaurant one), and every skip is SILENT: nobody
-- owed, no staff online or a balance that can't cover it are all ordinary states, not
-- errors worth spamming a console over. `payroll_interval_minutes = 0` disables it,
-- and the setting is re-read every pass so a change applies without a restart.
CreateThread(function()
    while not RestaurantsReady do Wait(1000) end
    while true do
        local mins = math.floor(tonumber(GetSetting("payroll_interval_minutes", 0)) or 0)
        if mins <= 0 then
            Wait(60000)
        else
            Wait(mins * 60000)
            if (tonumber(GetSetting("payroll_interval_minutes", 0)) or 0) > 0 then
                for rid in pairs(RestaurantCache) do pcall(RunPayroll, rid) end
            end
        end
    end
end)

local function LoadTips()
    TipCache = {}
    local rows = MySQL.query.await(
        "SELECT restaurant_id, SUM(amount) AS total FROM pickle_restaurant_tips WHERE paid = 0 GROUP BY restaurant_id") or {}
    for _, row in ipairs(rows) do
        TipCache[row.restaurant_id] = math.floor(tonumber(row.total) or 0)
    end
end

function GetStockCount(restaurantId, item)
    return (StockCache[restaurantId] and StockCache[restaurantId][item]) or 0
end

-- Tell cooks their ingredient bar is stale after the shared stock pool changed
-- (another cook consumed, a decompose refunded, or a manager restocked). Clients
-- refresh only if they're currently at a station; getIngredients is
-- restaurant-scoped server-side, so an unnecessary refresh is harmless.
-- Scoped to the restaurant, and it matters here more than anywhere: this fires on EVERY
-- stock movement — every single ingredient a cook consumes, every decompose refund, every
-- restocked line — so as a `-1` it was one message per connected player per lettuce leaf.
-- Only someone standing at one of this restaurant's stations can act on it (the handler
-- refreshes an open ingredient bar and does nothing otherwise), and a cook is at the
-- restaurant by definition — the stations are physical props in it.
local function BroadcastStockDirty(restaurantId)
    SendTo(PlayersNearRestaurant(restaurantId, ScopeRadius.BOARD),
           "pickle_restaurants:cooking:stockDirty", restaurantId)
end

function AddStock(restaurantId, item, count)
    StockCache[restaurantId] = StockCache[restaurantId] or {}
    StockCache[restaurantId][item] = (StockCache[restaurantId][item] or 0) + count
    MySQL.update("INSERT INTO pickle_restaurant_stock (restaurant_id, item, count) VALUES (?, ?, ?) "
        .. "ON DUPLICATE KEY UPDATE count = count + VALUES(count)", { restaurantId, item, count })
    BroadcastStockDirty(restaurantId)
end

function RemoveStock(restaurantId, item, count)
    if GetStockCount(restaurantId, item) < count then return false end
    StockCache[restaurantId][item] = StockCache[restaurantId][item] - count
    MySQL.update("UPDATE pickle_restaurant_stock SET count = count - ? WHERE restaurant_id = ? AND item = ?",
        { count, restaurantId, item })
    BroadcastStockDirty(restaurantId)
    return true
end

-- ─── POS orders (kitchen tickets) ────────────────────────────────────────────
-- Write-through mutators over OrderCache, same pattern as stock/tray. Only OPEN
-- tickets are cached; closing removes the row from the cache but keeps the DB
-- row as history.
--
-- STALENESS FIX — the register's ticket list is kept live by exactly ONE path: the
-- server broadcasts the full open-order list on every change (see SyncOrders), and
-- clients apply it unconditionally. FiveM server→client events are reliable AND
-- ordered per client, so the LAST list the server sends is always the last one a
-- client applies — no sequence numbers, no reconciliation, no race. The bug this
-- replaced came from a SECOND path (the acting cashier also updated straight from
-- its callback reply), which could land out of order against the broadcast and
-- resurrect a just-cancelled ticket. One ordered path can't disagree with itself.

function CreateOrder(restaurantId, order)
    NextTicket[restaurantId] = NextTicket[restaurantId] or 1
    order.restaurant_id = restaurantId
    order.ticket = NextTicket[restaurantId]
    order.status = "open"
    NextTicket[restaurantId] = order.ticket + 1
    -- `lines` is a MariaDB reserved keyword — it MUST be backtick-quoted here just
    -- as it is in CREATE TABLE, or the INSERT is a syntax error and no ticket saves.
    -- Which wallet paid is written WITH the ticket, not patched on afterwards: it is
    -- what a refund pays back into, so a ticket that exists without it would refund a
    -- card payment as cash. (The phone path still UPDATEs its own row — it decides
    -- delivery/scheduling in the same statement.)
    order.paid_account = (order.paid_account == "bank") and "bank" or "cash"
    order.id = MySQL.insert.await([[
        INSERT INTO `pickle_restaurant_orders`
            (`restaurant_id`, `ticket`, `customer_identifier`, `customer_name`, `cashier_identifier`, `lines`, `total`, `paid_account`)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ]], { restaurantId, order.ticket, order.customer_identifier, order.customer_name,
          order.cashier_identifier, json.encode(order.lines or {}), order.total or 0,
          order.paid_account })
    -- Fall back to the ticket-scoped id if the insert didn't return one, so the
    -- order is still cached + completable and never indexes the cache with nil.
    if not order.id then order.id = -order.ticket end
    OrderCache[restaurantId] = OrderCache[restaurantId] or {}
    OrderCache[restaurantId][order.id] = order
    return order
end

function CloseOrder(restaurantId, orderId, status)
    local o = OrderCache[restaurantId] and OrderCache[restaurantId][orderId]
    if not o then return false end
    -- SAFETY NET: closing a ticket as "cancelled" means the customer never got the
    -- food, so the money must have gone back. Callers are expected to have already
    -- gone through RefundOrder (and normally have) — but this makes it structurally
    -- impossible for a NEW cancel path to be added that forgets. RefundOrder is
    -- idempotent, so the normal path's call here is a no-op; only a path that
    -- skipped it actually pays out. NPC tickets no-op inside RefundOrder (they
    -- never pre-paid).
    if status == "cancelled" and o.refunded ~= 1 and o.refunded ~= true then
        local ok, err = pcall(RefundOrder, restaurantId, o, _L("refund_reason_cancelled"))
        if not ok then
            print(("[pickle_restaurants] REFUND FAILED closing ticket #%s (order %s, restaurant %s): %s")
                :format(tostring(o.ticket), tostring(orderId), tostring(restaurantId), tostring(err)))
        end
    end
    o.status = status
    MySQL.update("UPDATE pickle_restaurant_orders SET status = ?, closed_at = NOW() WHERE id = ?",
        { status, orderId })
    OrderCache[restaurantId][orderId] = nil
    -- The last-known driver position/route seed (modules/sales) dies with the ticket.
    -- Cleared HERE rather than in each caller so completed, cancelled and any future
    -- close path all drop it — the cache is keyed by order id and would otherwise leak.
    if DriverTelemetry then DriverTelemetry[orderId] = nil end
    return true
end

-- Drop a restaurant's entire order state (used when a restaurant is deleted).
function ClearOrders(restaurantId)
    OrderCache[restaurantId] = nil
    NextTicket[restaurantId] = nil
end

-- ─── refunds (the ONE path money ever goes back to a customer) ───────────────
-- Every cancellation — cashier cancel at the POS, phone/KDS cancel, an admin
-- deleting a whole restaurant out from under its in-flight tickets, or anything
-- added later — MUST come through RefundOrder. Duplicating "give the money back"
-- per call site is exactly how a path ends up refunding the wrong account, the
-- pre-discount total, or nothing at all.
--
-- IDEMPOTENCE: an order is refundable EXACTLY ONCE. `refunded` is flipped on the
-- cache row (and written through to the DB) BEFORE any payout, with no yield
-- between the check and the set — so a second call, a cancel racing a completion,
-- or a cancel racing an admin delete finds the flag already up and returns false
-- without paying. The flag is PERSISTED, so a restart can't resurrect the ability
-- to refund a ticket that was already paid back.
--
-- OFFLINE: a disconnected customer has no source to AddMoney to. That is NOT a
-- reason to refuse the cancel (which would wedge the ticket open forever) and it
-- is emphatically not a reason to drop the money on the floor: the payout is
-- persisted to pickle_restaurant_pending_refunds and settled on their next login
-- by SettlePendingRefunds.
--
-- Returns ok, amount, deferred.

-- Which wallet a ticket was charged to: phone/card orders take BANK, register and
-- kiosk take cash. "money" is the bridge's cash currency name.
function OrderRefundAccount(order)
    return (order and order.paid_account == "bank") and "bank" or "money"
end

-- Resolve a live source for an identifier. The bridge's GetSourceFromIdentifier is
-- the fast path, but it goes through the framework's own player index, which some
-- setups populate late (multichar) — so fall back to scanning connected players
-- the way modules/sales does. Getting this wrong means a REACHABLE customer gets
-- their refund deferred, so it's worth the second look.
function ResolveSourceForIdentifier(identifier)
    if not identifier then return nil end
    if GetSourceFromIdentifier then
        local src = GetSourceFromIdentifier(identifier)
        if src then return tonumber(src) end
    end
    for _, p in ipairs(GetPlayers()) do
        p = tonumber(p)
        if GetIdentifier(p) == identifier then return p end
    end
    return nil
end

-- Park a payout for an offline customer. Cache + DB write-through; the UNIQUE key
-- on order_id makes a duplicate row impossible even if this were reached twice.
local function QueueRefund(restaurantId, order, amount, account, reason)
    local row = {
        order_id      = order.id,
        restaurant_id = restaurantId,
        identifier    = order.customer_identifier,
        ticket        = order.ticket or 0,
        amount        = amount,
        account       = account,
        reason        = reason,
    }
    local id = MySQL.insert.await([[
        INSERT INTO `pickle_restaurant_pending_refunds`
            (`order_id`, `restaurant_id`, `identifier`, `ticket`, `amount`, `account`, `reason`)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE `order_id` = `order_id`
    ]], { row.order_id, row.restaurant_id, row.identifier, row.ticket, row.amount, row.account, row.reason })
    -- A FALSY-OR-ZERO id means the ON DUPLICATE branch fired (MySQL leaves
    -- LAST_INSERT_ID at 0 for a no-op update) — a payout is already queued for this
    -- ticket, so there's nothing to add. Note `id > 0`, not just `if id`: 0 is TRUTHY
    -- in Lua, and caching a row under key 0 would give it a payout the settle thread
    -- can never mark paid (the UPDATE would match no row), so it would pay out again
    -- on every restart. That is the double-refund bug this whole flag exists to stop.
    id = tonumber(id) or 0
    if id <= 0 then
        -- Either the duplicate branch fired or the insert failed outright. Read the
        -- row back to tell those apart: "already queued" is fine, "no row at all" is
        -- money that has left the restaurant's balance with nothing owing it back —
        -- the one case that must never pass silently.
        local existing = MySQL.query.await(
            "SELECT * FROM `pickle_restaurant_pending_refunds` WHERE `order_id` = ?", { row.order_id })
        local found = existing and existing[1]
        if not found then
            print(("[pickle_restaurants] MONEY LOST — could not queue a refund for ticket #%s (order %s, restaurant %s): %s owed to %s (%s). Pay this back manually.")
                :format(tostring(row.ticket), tostring(row.order_id), tostring(restaurantId),
                        GetCurrencyString(amount), tostring(row.identifier), account))
            return false
        end
        if found.paid_at == nil then PendingRefunds[found.id] = found end
        return true
    end
    row.id = id
    PendingRefunds[id] = row
    print(("[pickle_restaurants] REFUND DEFERRED: ticket #%s (order %s, restaurant %s) owes %s to %s (%s) — customer offline, will pay on next login")
        :format(tostring(row.ticket), tostring(row.order_id), tostring(restaurantId),
                GetCurrencyString(amount), tostring(row.identifier), account))
    return true
end

function RefundOrder(restaurantId, order, reason)
    if not order then return false, 0, false end
    -- Already paid back (or being paid back right now, further down this same
    -- non-yielding block). Never pay twice.
    if order.refunded == 1 or order.refunded == true then return false, 0, false end

    -- NPC customers pay on serve, so an unserved NPC ticket never took money.
    -- Flag it refunded anyway so the accounting is uniform and no later path
    -- mistakes it for an unrefunded charge.
    local isNpc = (IsNpcOrder and IsNpcOrder(order)) or false

    -- CLAIM FIRST. Everything below can yield; nothing below may run twice.
    order.refunded = 1
    if order.id then
        MySQL.update("UPDATE `pickle_restaurant_orders` SET `refunded` = 1 WHERE `id` = ?", { order.id })
    end
    if isNpc then return false, 0, false end

    -- The amount actually CHARGED is what the row stores: resolveOrderLines
    -- rounds it, and the phone path stores the post-discount, post-redemption
    -- finalTotal. Round again defensively — money crossing a boundary is always
    -- whole dollars (house rule), and a stored row could hold anything.
    local amount  = RoundMoney(order.total or 0)
    local account = OrderRefundAccount(order)

    -- Reverse the restaurant's side of the sale regardless of whether the
    -- customer is reachable — the house never keeps money for an unserved order.
    AdjustBalance(restaurantId, -amount)
    AddLedger(restaurantId, "refund", -amount,
        _L("ledger_refund", tostring(order.ticket), reason or _L("refund_reason_cancelled")), order.customer_identifier)

    -- Hand back a loyalty redemption burned on this order (the free-item punches
    -- were consumed at placeOrder; PhoneRestoreRedeem is a global from
    -- modules/phone, absent if that module isn't loaded).
    if (order.redeemed == 1 or order.redeemed == true) and PhoneRestoreRedeem then
        pcall(PhoneRestoreRedeem, restaurantId, order.customer_identifier)
    end

    if amount <= 0 then return true, 0, false end

    local src = ResolveSourceForIdentifier(order.customer_identifier)
    if not src then
        QueueRefund(restaurantId, order, amount, account, reason)
        return true, amount, true
    end

    AddMoney(src, amount, account)
    ShowNotification(src, _L("order_refunded", order.ticket or 0, GetCurrencyString(amount)))
    return true, amount, false
end

-- Pay out everything owed to one identifier that is now online. Safe to call
-- repeatedly: a row leaves the cache the moment it's paid, and paid_at is set in
-- the DB in the same step, so a restart mid-settle can't pay it a second time.
function SettlePendingRefunds(src)
    if not src then return 0 end
    local identifier = GetIdentifier(src)
    if not identifier then return 0 end
    -- Snapshot first. The loop below removes (and on failure re-adds) cache keys,
    -- and re-adding a key mid-`pairs` is undefined behaviour in Lua — so iterate a
    -- plain array of the rows we intend to settle, never the live table.
    local due = {}
    for id, row in pairs(PendingRefunds) do
        if row.identifier == identifier then due[#due + 1] = { id = id, row = row } end
    end
    local paid = 0
    for _, e in ipairs(due) do
        local id, row = e.id, e.row
        if PendingRefunds[id] then -- still unclaimed (another sweep may have taken it)
            -- Claim before paying, same rule as RefundOrder.
            PendingRefunds[id] = nil
            MySQL.update("UPDATE `pickle_restaurant_pending_refunds` SET `paid_at` = NOW() WHERE `id` = ?", { id })
            local amount = RoundMoney(row.amount or 0)
            if amount > 0 then
                -- Claiming before paying is the right trade (a double payout is worse
                -- than a retried one), but a throw mid-payout would otherwise burn the
                -- row. Put it back and clear paid_at so the next sweep tries again.
                local okp = pcall(AddMoney, src, amount, row.account == "bank" and "bank" or "money")
                if okp then
                    ShowNotification(src, _L("order_refunded", row.ticket or 0, GetCurrencyString(amount)))
                    paid = paid + amount
                else
                    PendingRefunds[id] = row
                    MySQL.update("UPDATE `pickle_restaurant_pending_refunds` SET `paid_at` = NULL WHERE `id` = ?", { id })
                    print(("[pickle_restaurants] refund payout failed for pending row %s (%s to %s) — requeued")
                        :format(tostring(id), GetCurrencyString(amount), tostring(identifier)))
                end
            end
        end
    end
    return paid
end

local function LoadPendingRefunds()
    PendingRefunds = {}
    local rows = MySQL.query.await(
        "SELECT * FROM `pickle_restaurant_pending_refunds` WHERE `paid_at` IS NULL") or {}
    local n = 0
    for _, row in ipairs(rows) do
        PendingRefunds[row.id] = row
        n = n + 1
    end
    if n > 0 then
        print(("[pickle_restaurants] %d unpaid refund(s) queued for offline customers"):format(n))
    end
end

-- Settle queue. Deliberately a poll rather than a framework "player loaded" hook:
-- every bridge (esx / qb / custom) already exposes GetSourceFromIdentifier, none
-- of them expose a common load event, and money owed must not depend on which
-- framework is running. Idle cost is one table scan when nothing is owed.
CreateThread(function()
    while true do
        Wait(20000)
        if next(PendingRefunds) then
            local seen = {}
            for _, row in pairs(PendingRefunds) do
                local ident = row.identifier
                if ident and not seen[ident] then
                    seen[ident] = true
                    local src = ResolveSourceForIdentifier(ident)
                    if src then SettlePendingRefunds(src) end
                end
            end
        end
    end
end)

-- Open tickets for the register NUI, oldest first (kitchen works the queue in order).
-- Only genuinely-open rows are surfaced: the callbacks hold their transient claim in
-- o.busy (never o.status), so o.status is always "open" here — but the explicit
-- filter is a hard guarantee that a row can never render as a phantom the register
-- shows yet the action guard rejects (the wedged-ticket failure mode).
-- How an open ticket REACHED the kitchen, as one word the ticket UIs badge it with.
-- Delivery and dine-in are explicit on the row; the rest splits on whether the order
-- came through the phone app (order-ahead, collected at the counter) or was rung up
-- in person at a register/kiosk. Note `order_type` alone can't make that second call:
-- the column DEFAULTS to 'pickup', so every walk-in reloaded from the DB after a
-- restart would read as a phone pickup. A phone order is the one that paid by card,
-- which is what `paid_account`/`phone_number` record.
function OrderChannel(o)
    if not o then return "walk_in" end
    if o.order_type == "delivery" then return "delivery" end
    if o.order_type == "dine_in" then return "dine_in" end
    local viaPhone = (o.paid_account == "bank")
        or (type(o.phone_number) == "string" and o.phone_number ~= "")
    return viaPhone and "pickup" or "walk_in"
end

-- Who is PARTY to this restaurant's open tickets: `[identifier] = { [orderId] = true }`
-- for every customer and claimed driver. Read straight off the cache rather than added
-- to the GetOpenOrders projection on purpose — a customer identifier is exactly the kind
-- of field that leaks the moment it rides a list somebody broadcasts (see SyncOrders in
-- modules/sales, which uses this to send each customer THEIR OWN ticket and nobody
-- else's). Nothing needs it on a client, so it never goes to one.
function OrderPartyIdentifiers(restaurantId)
    local out = {}
    for _, o in pairs(OrderCache[restaurantId] or {}) do
        if o.status == "open" then
            for _, ident in ipairs({ o.customer_identifier, o.driver_identifier }) do
                if ident and ident ~= "" then
                    out[ident] = out[ident] or {}
                    out[ident][o.id] = true
                end
            end
        end
    end
    return out
end

function GetOpenOrders(restaurantId)
    local list = {}
    for _, o in pairs(OrderCache[restaurantId] or {}) do
        if o.status == "open" then
            -- NPC tickets carry a patience countdown so the POS / kitchen widget can
            -- show the time left (and a radial) before the customer walks. Helpers
            -- are globals from modules/npc_customers; guard so this stays valid even
            -- if that module is absent. Player tickets get npc=false / no timer.
            local isNpc = (IsNpcOrder and IsNpcOrder(o)) or false
            local expiresIn, patience
            if isNpc and NpcOrderTimer then expiresIn, patience = NpcOrderTimer(restaurantId, o.id) end
            list[#list + 1] = {
                orderId   = o.id,
                ticket    = o.ticket,
                customer  = o.customer_name,
                lines     = o.lines,
                total     = o.total,
                status    = o.status,
                npc       = isNpc,
                expiresIn = expiresIn, -- seconds left at send time (client ticks down)
                patience  = patience,  -- full patience window (radial denominator)
                -- Phone companion (modules/phone): delivery/pickup/dine-in + order-ahead.
                -- nil on register/kiosk/NPC tickets (they never set them). Additive.
                orderType = o.order_type,
                scheduled = o.scheduled_for,
                address   = o.address,
                -- How it got here (delivery / pickup / dine_in / walk_in). Resolved
                -- server-side so every ticket surface badges it identically — and so
                -- a cashier can tell a delivery (only its claimed driver may hand it
                -- over, at the customer's door) from an order waiting at the counter.
                channel   = OrderChannel(o),
                -- The transient delivery claim (modules/sales' startDelivery). This is a
                -- PROJECTION, not the cache row, so anything AnnotateOrders needs has to
                -- be carried across explicitly — without these the driver lookup always
                -- saw nil and the phone's "Accept Delivery" never flipped to "Cancel".
                driver_identifier = o.driver_identifier,
                driver_name       = o.driver_name,
            }
        end
    end
    table.sort(list, function(a, b) return a.ticket < b.ticket end)
    return list
end

-- Players within `radius` of `src`, for pickers (hiring, POS customer select).
function NearbyPlayers(src, radius)
    local ped = GetPlayerPed(src)
    local c = GetEntityCoords(ped)
    local list = {}
    for _, p in ipairs(GetPlayers()) do
        p = tonumber(p)
        if p ~= src then
            local pc = GetEntityCoords(GetPlayerPed(p))
            if #(c - pc) < (radius or 10.0) then list[#list + 1] = { id = p, name = GetPlayerCharacterName(p) } end
        end
    end
    return list
end

-- ─── audience scoping: never send a world event to the whole world ───────────
--
-- A `-1` send costs one queued outbound message PER CONNECTED PLAYER. At 2000
-- players a single patty flip is 2000 messages, and this resource emits several per
-- cooked item, per NPC, per door, per fire — enough backlog to stall the server and
-- crash clients. Almost none of it is world news: a prop spawning on a grill, an oven
-- door swinging, a basket dipping and an NPC queueing are only observable within a few
-- dozen metres, and the client handlers throw the rest away anyway (after paying for
-- the delivery, the deserialization and, for the spawn events, a real CreateObject).
--
-- So every world event goes through one of the helpers below, which resolve an
-- AUDIENCE — a plain list of server ids — and send once per member. Rules:
--   • an event that renders something in the world  -> SendNear / SendNearProp
--   • an event only one player can act on           -> TriggerClientEvent(ev, src, …)
--   • genuinely global config news (a blip, a theme) -> -1 is still correct
--
-- Positions come from a CACHE refreshed on a slow thread, not from GetEntityCoords per
-- send: the cache is read many times per second by the cooking module, and a per-send
-- scan of every ped would replace a network cost with a native-call cost. A cache that
-- is up to PLAYER_POS_MS stale is fine for a metre-scale radius — every audience radius
-- here is padded well past a second of sprinting, and the consequence of a miss is one
-- late prop, which the range-entry re-hydration fixes anyway.
local PlayerPos = {}          -- [src] = { x, y, z } as of the last sweep
local PLAYER_POS_MS = 1000    -- position cache refresh (TUNE IN-GAME)

CreateThread(function()
    while true do
        local fresh = {}
        for _, p in ipairs(GetPlayers()) do
            local src = tonumber(p)
            local ped = src and GetPlayerPed(src)
            if ped and ped ~= 0 then
                local c = GetEntityCoords(ped)
                -- a player still loading in sits at the origin; treat as unplaced so a
                -- spawn point near 0,0,0 doesn't become everybody's audience
                if c and not (c.x == 0.0 and c.y == 0.0) then
                    fresh[src] = { x = c.x, y = c.y, z = c.z }
                end
            end
        end
        PlayerPos = fresh -- swap whole, so a reader never sees a half-built table
        Wait(PLAYER_POS_MS)
    end
end)

-- Server ids within `radius` of a point. Squared compare, no vector allocation — this
-- runs on the cooking module's hot paths.
function PlayersNearPoint(x, y, z, radius)
    local out, r2 = {}, (radius or 60.0) * (radius or 60.0)
    for src, c in pairs(PlayerPos) do
        local dx, dy, dz = c.x - x, c.y - y, c.z - z
        if (dx * dx + dy * dy + dz * dz) <= r2 then out[#out + 1] = src end
    end
    return out
end

-- Server ids within `radius` of a placed prop. The audience for anything that renders
-- ON that prop: cooking items, oven doors, fryer baskets, kitchen fires, NPCs at a
-- counter. An unknown prop id yields NOBODY, deliberately — a prop we can't place is a
-- prop nothing can be looking at, and falling back to -1 would silently restore the
-- broadcast this exists to remove.
function PlayersNearProp(propId, radius)
    local p = PropCache[tonumber(propId or 0) or 0]
    if not p or not p.x then return {} end
    return PlayersNearPoint(p.x, p.y, p.z, radius)
end

-- A restaurant's extent as ONE sphere: the centroid of its placed props plus the
-- distance to the furthest one. Testing every prop against every player would be props ×
-- players per send — a 40-seat venue on a full server is tens of thousands of compares
-- for a list that changes twice a second. One padded sphere costs one compare per player
-- and can only ever be too generous, which is the safe direction to be wrong in.
--
-- Cached with a short TTL rather than invalidated on prop change: placement, deletion and
-- the gizmo all move props, and a stale sphere for a few seconds means at worst a slightly
-- wide audience, where a missed invalidation would mean a permanently wrong one.
local RestaurantExtent = {}   -- [rid] = { x, y, z, r, at = os.time() }
local EXTENT_TTL = 5

local function restaurantExtent(rid)
    local c = RestaurantExtent[rid]
    if c and (os.time() - c.at) < EXTENT_TTL then return c end
    local sx, sy, sz, n = 0.0, 0.0, 0.0, 0
    for _, p in pairs(PropCache) do
        if p.restaurant_id == rid and p.x then
            sx, sy, sz, n = sx + p.x, sy + p.y, sz + p.z, n + 1
        end
    end
    if n == 0 then RestaurantExtent[rid] = nil; return nil end
    local cx, cy, cz = sx / n, sy / n, sz / n
    local far = 0.0
    for _, p in pairs(PropCache) do
        if p.restaurant_id == rid and p.x then
            local dx, dy, dz = p.x - cx, p.y - cy, p.z - cz
            local d = dx * dx + dy * dy + dz * dz
            if d > far then far = d end
        end
    end
    c = { x = cx, y = cy, z = cz, r = math.sqrt(far), at = os.time() }
    RestaurantExtent[rid] = c
    return c
end

-- Server ids within `radius` of any part of restaurant `rid`. The audience for anything
-- restaurant-wide rather than prop-specific: the ticket list its boards and register
-- paint, NPC queue news. A restaurant with no props placed yet has no location, so
-- nobody — same fail-closed rule as PlayersNearProp.
function PlayersNearRestaurant(rid, radius)
    local e = restaurantExtent(tonumber(rid) or rid)
    if not e then return {} end
    return PlayersNearPoint(e.x, e.y, e.z, e.r + (radius or 60.0))
end

-- The same sphere, for the CLIENT. A client needs to know where a restaurant is without
-- holding its props — that is the whole point of loading props by proximity — so this rides
-- the sync payload per restaurant and is what the client's own approach loop measures
-- against. It also gives a blip a position for a restaurant that has no counter placed:
-- SetupBlip used to fall back to `props[1]`, which is exactly the dependency being removed.
function RestaurantCentre(rid)
    local e = restaurantExtent(tonumber(rid) or rid)
    if not e then return nil end
    return { x = e.x, y = e.y, z = e.z, r = e.r }
end

-- Send one event to an explicit audience. `targets` is a list of server ids; an empty
-- list sends nothing, which is the whole point — nobody is looking.
function SendTo(targets, event, ...)
    for i = 1, #targets do TriggerClientEvent(event, targets[i], ...) end
end

function SendNear(x, y, z, radius, event, ...)
    SendTo(PlayersNearPoint(x, y, z, radius), event, ...)
end

function SendNearProp(propId, radius, event, ...)
    SendTo(PlayersNearProp(propId, radius), event, ...)
end

-- Radii, in metres (TUNE IN-GAME). Padded past what the client actually renders at, so
-- a player crossing into range during the position cache's staleness window is already
-- receiving events by the time anything is visible to them.
--   PROP  — things rendered on a station prop. modules/quad draws at 40m, cookfx at 40m;
--           100m covers both plus a sprint through the cache window.
--   NPC   — npc_customers' own RENDER_DIST is 150m, so the audience must not be tighter.
--   BOARD — the menu/orders boards and the register POS screen: readable well inside
--           this, but a client keeps the nearest restaurant's data bound, so give it
--           room to be the nearest one.
ScopeRadius = { PROP = 100.0, NPC = 160.0, BOARD = 120.0 }

-- ─── cooked-items tray (per-player, per-restaurant) ──────────────────────────

-- Flag a restaurant's pool as changed so an open register re-computes ticket
-- fulfillability. Coalesced and flushed via SyncOrders by a thread in modules/sales
-- (the tray mutates in tight loops — a per-op broadcast would spam clients).
function MarkOrdersDirty(rid) if rid then OrdersDirty[rid] = true end end

-- Canonical signature of one instance's build stack: its ordered layers as
-- "item|half" joined with ",". "" = no recorded stack (a plain instance).
-- Two builds of the same item with different stacks (e.g. a pizza with and without
-- pepperoni) get different signatures, so the tray can tell the variations apart
-- instead of merging them into one count and popping the wrong one on removal.
function TraySig(meta)
    if type(meta) ~= "table" or #meta == 0 then return "" end
    local parts = {}
    for _, l in ipairs(meta) do
        local part = tostring(l.item) .. "|" .. tostring(l.half or "")
        -- a melting topping riding this layer (its `top` field): its item + melt
        -- state are part of the variation identity
        local topv = LayerTopping(l)
        if topv then
            part = part .. "+" .. tostring(topv.item) .. ":" .. tostring(topv.state)
        end
        -- a layer that is itself a product carries its own nested build stack
        -- (a burger holding a pepperoni pizza ≠ one holding a plain pizza)
        if type(l.stack) == "table" and #l.stack > 0 then
            part = part .. "{" .. TraySig(l.stack) .. "}"
        end
        -- A finished (frosted…) layer carries the TOOL and the flavor: a strawberry
        -- cake and a chocolate one are different variations of the same output item.
        -- THE TOOL IS PART OF THE IDENTITY, not decoration. Two finishes can target one
        -- item with flavors that share an id — frosting and sprinkles both offer
        -- `vanilla` and `chocolate` on a cookie — and on flavor alone a vanilla-FROSTED
        -- cookie and a vanilla-SPRINKLED one signed identically. That made them one tray
        -- entry, so both rendered and labelled as whichever instance happened to sit on
        -- top, and a sig-pinned consume could spend the wrong one.
        -- The doughnut hid this only by accident: `requires_finish` means a sprinkled
        -- doughnut always nests a frosted stack, and the nested `{…}` above already
        -- separated the two. The cookie is deliberately ungated, so nothing separated
        -- them there. Cakes have one tool today and were never bitten, but the collision
        -- was structural — a second cake tool sharing a flavor id would have been.
        -- A legacy layer with a flavor and no tool signs as it always did.
        if l.tool ~= nil then
            part = part .. "#" .. tostring(l.tool)
        end
        if l.flavor ~= nil then
            part = part .. "#" .. tostring(l.flavor)
        end
        -- a meal layer carries its tray offset: the same items in a different
        -- arrangement are a different meal (offsets are quantized to 1cm at
        -- make time, so the format is stable through the JSON round trip)
        if l.dx ~= nil or l.dy ~= nil then
            part = part .. ("@%.2f,%.2f"):format(tonumber(l.dx) or 0.0, tonumber(l.dy) or 0.0)
        end
        -- a meal made in a pizza box (flag on the first layer) is a different
        -- variation from the same pizza arranged on a serving tray
        if l.box then
            part = part .. "^box"
        end
        -- a crafted Restaurant Bag carries its craft id (flag on the first
        -- layer): the bag item is generic, so the craft IS its variation
        -- identity — two crafts with the same components stay distinct.
        if l.craft ~= nil then
            part = part .. "~" .. tostring(l.craft)
        end
        parts[#parts + 1] = part
    end
    return table.concat(parts, ",")
end

-- Signature of the i-th counted instance. `metas` can be shorter than `count`
-- (units added without one — a plain refund); the tail is plain ("").
local function traySigAt(e, i)
    local m = e.metas and e.metas[i]
    if type(m) ~= "table" then return "" end
    return TraySig(m)
end

-- `sig` (optional, here and below): address only the instances whose build stack
-- matches that signature. nil = any instance (plain LIFO).
function GetTrayCount(rid, identifier, item, sig)
    local e = TrayCache[rid] and TrayCache[rid][identifier] and TrayCache[rid][identifier][item]
    if not e then return 0 end
    if sig == nil then return e.count or 0 end
    local n = 0
    for i = 1, e.count or 0 do
        if traySigAt(e, i) == sig then n = n + 1 end
    end
    return n
end

-- The build stack of the most-recently-added (matching) instance of a tray entry,
-- or nil for a plain instance with no recorded stack. `metas` holds one entry per
-- counted item (a stack table, or false when that instance wasn't assembled from parts).
function TrayTopMeta(rid, identifier, item, sig)
    local e = TrayCache[rid] and TrayCache[rid][identifier] and TrayCache[rid][identifier][item]
    if not e then return nil end
    for i = e.count or 0, 1, -1 do
        if sig == nil or traySigAt(e, i) == sig then
            local m = e.metas and e.metas[i]
            return (type(m) == "table") and m or nil
        end
    end
    return nil
end

-- `meta` (optional) is this add's build stack, stored per-instance so an assembled
-- product can later be taken back apart into exactly what went into it.
function AddTray(rid, identifier, item, count, meta)
    if not rid or not identifier or not item then return end
    count = count or 1
    TrayCache[rid] = TrayCache[rid] or {}
    TrayCache[rid][identifier] = TrayCache[rid][identifier] or {}
    local e = TrayCache[rid][identifier][item]
    if not e then
        e = { item = item, count = 0, metas = {}, cookedAt = os.time() }
        TrayCache[rid][identifier][item] = e
    end
    e.metas = e.metas or {}
    e.count = e.count + count
    -- EVERY add restamps the row's freshness clock: the newest instance is fresh,
    -- and the row expires as one unit — so topping a slot up gives the whole stack
    -- the full window again instead of inheriting the oldest instance's leftovers.
    e.cookedAt = os.time()
    for _ = 1, count do e.metas[#e.metas + 1] = meta or false end
    MySQL.update("INSERT INTO pickle_restaurant_cooked_items (restaurant_id, identifier, item, count, metadata, cooked_at) "
        .. "VALUES (?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE count = count + VALUES(count), metadata = VALUES(metadata), cooked_at = VALUES(cooked_at)",
        { rid, identifier, item, count, json.encode(e.metas), e.cookedAt })
    MarkOrdersDirty(rid)
end

function RemoveTray(rid, identifier, item, count, sig)
    count = count or 1
    if GetTrayCount(rid, identifier, item, sig) < count then return false end
    local e = TrayCache[rid][identifier][item]
    e.metas = e.metas or {}
    -- Drop the newest matching instances alongside the count (LIFO, matching
    -- TrayTopMeta). An instance past #metas is plain (""), so removing it only
    -- decrements the count — it must never pop another instance's stack.
    for _ = 1, count do
        local idx
        for i = e.count, 1, -1 do
            if sig == nil or traySigAt(e, i) == sig then idx = i; break end
        end
        if idx and idx <= #e.metas then table.remove(e.metas, idx) end
        e.count = e.count - 1
    end
    if e.count <= 0 then
        TrayCache[rid][identifier][item] = nil
        MySQL.update("DELETE FROM pickle_restaurant_cooked_items WHERE restaurant_id = ? AND identifier = ? AND item = ?",
            { rid, identifier, item })
    else
        MySQL.update("UPDATE pickle_restaurant_cooked_items SET count = count - ?, metadata = ? WHERE restaurant_id = ? AND identifier = ? AND item = ?",
            { count, json.encode(e.metas), rid, identifier, item })
    end
    MarkOrdersDirty(rid)
    return true
end

-- A display list for the NUI: resolves label/image and a cheese flag. Instances
-- with different build stacks are split into separate entries (a pepperoni pizza
-- is not the same thing as a plain one), each carrying its `sig` so every drag /
-- consume can address exactly that variation, plus its `meta` (one instance's
-- stack) for stack rendering and descriptions.
function GetTray(rid, identifier)
    local out = {}
    local byKey = TrayCache[rid] and TrayCache[rid][identifier]
    if not byKey then return out end
    for _, e in pairs(byKey) do
        if e.count > 0 then
            local groups, order = {}, {}
            for i = 1, e.count do
                local s = traySigAt(e, i)
                if not groups[s] then
                    local m = e.metas and e.metas[i]
                    groups[s] = { count = 0, meta = (type(m) == "table") and m or nil }
                    order[#order + 1] = s
                end
                groups[s].count = groups[s].count + 1
            end
            for _, s in ipairs(order) do
                out[#out + 1] = {
                    item = e.item, count = groups[s].count,
                    sig = s, meta = groups[s].meta, cookedAt = e.cookedAt or 0,
                    label = GetItemLabel(e.item), image = GetItemImage(e.item),
                }
            end
        end
    end
    return out
end

-- ─── restaurant-wide pool (read/consume across every cook's tray) ─────────────
-- The tray stays per-player; the POS register fulfils from the UNION of a
-- restaurant's trays so cooks don't have to double as cashiers. `matchSig` (nil =
-- any) filters to one build variation exactly as the per-player tray functions do;
-- item matching spans every cheese state (a plain "burger" line is satisfied by a
-- cheesed burger too — item-name matching, same as the old inventory path).

-- Total count of `item` across all identifiers + cheese states matching `matchSig`.
function PoolCount(rid, item, matchSig)
    local byId = TrayCache[rid]
    if not byId then return 0 end
    local n = 0
    for identifier, byKey in pairs(byId) do
        for _, e in pairs(byKey) do
            if e.item == item then
                n = n + GetTrayCount(rid, identifier, item, matchSig)
            end
        end
    end
    return n
end

-- The build stack of some pool instance of `item` matching `matchSig` (any cook),
-- or nil. Read-only — used to compute a meal's coverage before deciding to consume.
function PoolTopMeta(rid, item, matchSig)
    local byId = TrayCache[rid]
    if not byId then return nil end
    for identifier, byKey in pairs(byId) do
        for _, e in pairs(byKey) do
            if e.item == item then
                local m = TrayTopMeta(rid, identifier, item, matchSig)
                if m ~= nil then return m end
            end
        end
    end
    return nil
end

-- Distinct build variations of `item` in the pool, merged across cooks:
-- { { sig, meta, count, label }, … }. For the register's meal picker.
function PoolVariations(rid, item)
    local out, idx = {}, {}
    local byId = TrayCache[rid]
    if not byId then return out end
    for identifier in pairs(byId) do
        for _, e in ipairs(GetTray(rid, identifier)) do
            if e.item == item then
                local k = e.sig or ""
                if not idx[k] then
                    idx[k] = { sig = e.sig, meta = e.meta, count = 0, label = e.label }
                    out[#out + 1] = idx[k]
                end
                idx[k].count = idx[k].count + e.count
            end
        end
    end
    return out
end

-- Consume up to `count` matching instances of `item` from the pool (any identifier,
-- LIFO within each row). Returns a list of { meta } for every
-- consumed instance (meta read BEFORE its RemoveTray, like trayToInventory), or nil
-- if the pool can't cover `count` — in which case nothing is consumed.
function PoolConsume(rid, item, matchSig, count)
    count = count or 1
    if PoolCount(rid, item, matchSig) < count then return nil end
    local taken = {}
    local byId = TrayCache[rid] or {}
    for identifier, byKey in pairs(byId) do
        for _, e in pairs(byKey) do
            if e.item == item then
                while #taken < count and GetTrayCount(rid, identifier, item, matchSig) > 0 do
                    local meta = TrayTopMeta(rid, identifier, item, matchSig)
                    if not RemoveTray(rid, identifier, item, 1, matchSig) then break end
                    taken[#taken + 1] = { meta = meta }
                end
            end
            if #taken >= count then break end
        end
        if #taken >= count then break end
    end
    return taken
end

-- Pool count/consume with a CUSTOM instance matcher `match(meta) -> bool` (meta is
-- one instance's build stack, or nil for a plain instance). The sales
-- fulfillment planner matches by VARIATION (a cheeseburger ≠ a plain burger, a
-- strawberry cake ≠ a plain one) rather than by the raw TraySig, so it can't use
-- the sig-keyed PoolCount/PoolConsume — it hands the semantics in as a predicate.
function PoolCountMatch(rid, item, match)
    local byId = TrayCache[rid]
    if not byId then return 0 end
    local n = 0
    for _, byKey in pairs(byId) do
        for _, e in pairs(byKey) do
            if e.item == item then
                for i = 1, e.count or 0 do
                    local m = e.metas and e.metas[i]
                    if match((type(m) == "table") and m or nil) then n = n + 1 end
                end
            end
        end
    end
    return n
end

-- Consume up to `count` instances of `item` for which match(meta) is true (any
-- identifier, LIFO within each row). Returns { {meta}, … } for every
-- consumed instance (meta read BEFORE its removal), or nil if the pool can't cover
-- `count` — in which case nothing is consumed. Removal pins the instance's EXACT sig
-- so a broader variation match never pops the wrong stack.
function PoolConsumeMatch(rid, item, match, count)
    count = count or 1
    if PoolCountMatch(rid, item, match) < count then return nil end
    local taken = {}
    local byId = TrayCache[rid] or {}
    for identifier, byKey in pairs(byId) do
        for _, e in pairs(byKey) do
            if e.item == item then
                local i = e.count or 0
                while #taken < count and i >= 1 do
                    local m = e.metas and e.metas[i]
                    local mt = (type(m) == "table") and m or nil
                    if match(mt) then
                        local sig = traySigAt(e, i)
                        if RemoveTray(rid, identifier, item, 1, sig) then
                            taken[#taken + 1] = { meta = mt }
                        end
                        i = e.count or 0 -- the row shrank; rescan from the (new) top
                    else
                        i = i - 1
                    end
                end
            end
            if #taken >= count then break end
        end
        if #taken >= count then break end
    end
    return taken
end

-- ─── reservations: the seats a booking HOLDS ─────────────────────────────────
-- A reservation is ACCESS CONTROL over real seat anchors for one timeslot — never an
-- instance, never a private room. The booking rows themselves belong to
-- modules/phone (ReservationCache); what lives here is the part the rest of the
-- engine needs: which SEATS a booking holds, who may sit in them, whether a booking
-- is currently active at all, and the expiry sweep that frees seats nobody turned up
-- for. Without a sweep a single "now" booking would hold a table until the next
-- restart.

-- The canonical bookable slots. Validated on read (the NUI is untrusted and a slot
-- is what the hold window is computed FROM — an arbitrary string would create a hold
-- that never starts and never ends). "now" always survives: it is the one slot that
-- needs no clock and the fallback if an admin empties the list.
function ReservationSlots()
    local out, seen = {}, {}
    for _, s in ipairs(GetSetting("reservation_slots", {}) or {}) do
        if type(s) == "string" then
            s = s:gsub("^%s+", ""):gsub("%s+$", "")
            if s ~= "" and not seen[s] and (s == "now" or s:match("^%d%d?:%d%d$")) then
                seen[s] = true
                out[#out + 1] = s
            end
        end
    end
    if #out == 0 then out[1] = "now" end
    return out
end

function IsReservationSlot(slot)
    for _, s in ipairs(ReservationSlots()) do
        if s == slot then return true end
    end
    return false
end

function ReservationHoldMinutes()
    return math.max(5, math.floor(tonumber(GetSetting("reservation_hold_minutes", 90)) or 90))
end

-- When a booking was made, as unix seconds. Rows come from three places with three
-- shapes (a freshly-created cache row stamped by the phone, oxmysql's `created_at`,
-- or a row loaded with no timestamp selected at all), so all three are accepted. A
-- row we genuinely can't date is stamped NOW and remembered: that way a "now" booking
-- restarts its hold window after a resource restart, rather than either expiring the
-- instant the server comes back or holding its table forever.
local function reservationCreated(row)
    local n = tonumber(row.createdAt)
    if n then return n end
    local c = row.created_at
    if type(c) == "number" then
        row.createdAt = (c > 1e11) and math.floor(c / 1000) or math.floor(c)
        return row.createdAt
    end
    if type(c) == "string" then
        local y, mo, d, h, mi, s = c:match("(%d+)-(%d+)-(%d+)[T ](%d+):(%d+):(%d+)")
        if y then
            row.createdAt = os.time({ year = tonumber(y), month = tonumber(mo), day = tonumber(d),
                                      hour = tonumber(h), min = tonumber(mi), sec = tonumber(s) })
            return row.createdAt
        end
    end
    row.createdAt = os.time()
    return row.createdAt
end

-- The window a booking holds its seats for: its slot time TODAY (server local time)
-- .. + `reservation_hold_minutes`. "now" starts the moment it was booked.
function ReservationWindow(row)
    if type(row) ~= "table" then return 0, 0 end
    local hold = ReservationHoldMinutes() * 60
    local slot = row.slot
    if type(slot) ~= "string" or slot == "" or slot == "now" then
        local from = reservationCreated(row)
        return from, from + hold
    end
    local h, m = slot:match("^(%d%d?):(%d%d)$")
    if not h then
        local from = reservationCreated(row)
        return from, from + hold
    end
    local now = os.date("*t")
    local from = os.time({ year = now.year, month = now.month, day = now.day,
                           hour = tonumber(h), min = tonumber(m), sec = 0 })
    return from, from + hold
end

-- Is this booking holding its seats right now? A cancelled/expired row never is.
function ReservationActive(row)
    if type(row) ~= "table" then return false end
    if row.status ~= nil and row.status ~= "booked" then return false end
    local from, to = ReservationWindow(row)
    local now = os.time()
    return now >= from and now < to
end

-- The booking row for an id, out of the phone module's cache (nil when that module
-- isn't loaded, or the booking is gone — either way there is no live hold).
function ReservationById(resId)
    resId = tonumber(resId)
    if not resId then return nil end
    for _, byId in pairs(ReservationCache or {}) do
        if byId[resId] then return byId[resId] end
    end
    return nil
end

-- WHICH SEATS A BOOKING HOLDS, AND WHO IT ADMITS, LIVES IN modules/phone.
-- That module owns `ReservationCache` and every write to the two hold tables, and it
-- carries a booking's seats and guests ON the cached row — so a second cache of the
-- same two tables here (which this file briefly had) is not a speed-up, it is a
-- second truth that drifts the moment either half writes. The engine-side helpers
-- this file keeps are the ones that need no row at all: the slot vocabulary, the hold
-- window, and whether a row is live. Everything else is the phone's:
--   ReservationForSeat(propId) / ReservationAdmits(res, ident) / ReservationAddGuest /
--   ReleaseReservation(res) / ReservedSeatMap(rid)


-- EXPIRY SWEEP. Nothing else ends a booking: a party that never showed up would
-- otherwise hold its table forever (there was no expiry at all before this). A lapsed
-- row is marked `expired` in the DB, dropped from the phone's cache and its seats
-- freed — one pass a minute is ample for a 90-minute hold.
--
-- Driven off ReservationCache rather than a query, so this is a no-op on a server
-- running without the phone module (no bookings can exist) and never touches a table
-- that module owns the schema of.
-- Freeing the seats and guest grants is `ReleaseReservation` (modules/phone), the same
-- path a cancellation takes — an expiry is a cancellation the clock performed, and two
-- ways to end a booking is how one of them ends up forgetting the guest rows.
CreateThread(function()
    while not RestaurantsReady do Wait(1000) end
    -- The boot sync ran before the phone module loaded its bookings, so the first
    -- payload went out with no `reservedSeats`. Re-sync once we can actually see them.
    local seeded = false
    while true do
        Wait(60000)
        local expired = {}
        for _, byId in pairs(ReservationCache or {}) do
            for resId, row in pairs(byId) do
                if not ReservationActive(row) then expired[#expired + 1] = { id = resId, row = row } end
            end
        end
        local freed = {}
        for _, e in ipairs(expired) do
            MySQL.update("UPDATE pickle_restaurant_reservations SET status = 'expired' WHERE id = ?", { e.id })
            e.row.status = "expired"
            if e.row.restaurant_id then freed[e.row.restaurant_id] = true end
            if ReleaseReservation then
                ReleaseReservation(e.row) -- drops the cache row, the seats and the guests
            end
        end
        -- A freed table has to stop reading "Reserved" — but only its own restaurant's
        -- seats changed, so this is a per-restaurant delta, not a world sync.
        for rid in pairs(freed) do SyncReservedSeats(rid) end
        if not seeded and ReservedSeatMap and ReservationCache and next(ReservationCache) ~= nil then
            -- The boot sync went out before the phone module had loaded its bookings, so
            -- every client's seat labels are missing. This one IS world-wide: it's a
            -- one-shot correction of the payload everybody already holds.
            seeded = true
            for rid in pairs(ReservationCache) do SyncReservedSeats(rid) end
        end
    end
end)

-- ─── client sync ─────────────────────────────────────────────────────────────

local function BuildClientRestaurant(r)
    return {
        id      = r.id,
        name    = r.name,
        label   = r.label,
        -- Per-restaurant map blip { enabled, sprite, color, scale }, edited in the
        -- admin panel. An EMPTY column follows the global `blip` setting — resolved
        -- here rather than on the client (which has no settings), so clearing an
        -- override hands the restaurant back to the server default instead of the
        -- client's hardcoded fallback.
        blip    = r.blip or GetSetting("blip", nil),
        counter = r.counter,
        -- brand image URLs (drive the runtime texture replacement on packaging props):
        -- `brand_image` is the shared default; `brand_images` holds per-texture
        -- overrides keyed by the rendertarget target key (pizza_box, cup, tray, side).
        brand_image  = r.metadata and r.metadata.brand_image or nil,
        brand_images = r.metadata and r.metadata.brand_images or nil,
        -- NUI theme seed { primary, mode, radius } — the client passes it along
        -- when it opens a panel scoped to this restaurant (cooking stations).
        theme        = r.metadata and r.metadata.theme or nil,
        -- virtual kitchen shell anchor { x, y, z, heading } — where a virtual
        -- point session builds its local shell + stations (XY = counter).
        shell        = r.metadata and r.metadata.shell or nil,
        -- WHERE THIS RESTAURANT IS, as { x, y, z, r }, independent of its props. The
        -- client loads props by PROXIMITY, so it needs a position it can measure against
        -- before it holds any of them — this is what its approach loop and its blip use.
        centre       = RestaurantCentre(r.id),
        -- NO `menu` HERE. The priced board menu used to ride this payload, and it was the
        -- worst-scaling term in the whole sync: every restaurant's ENTIRE priced catalog
        -- (label + price + kind + a full nui:// image url per entry, 3-5KB each) shipped to
        -- every player, whether or not that player was anywhere near a menu board — and
        -- re-shipped on every config edit. Exactly ONE consumer ever read it: the placed
        -- MENU SCREEN prop in modules/screens. So it is fetched per restaurant, on demand,
        -- by the board that actually paints it (`screens:getMenu`), through the same
        -- seed-once + epoch machinery that module already uses for its orders board.
        -- Seat anchors currently held by an ACTIVE reservation, { [propId] = true }.
        -- Purely so the seat interaction can read "Reserved" instead of promising a
        -- chair the server will refuse: it is holder-agnostic, and whether THIS player
        -- may sit is still decided on `seating:sit` where the holder and its guests are
        -- known. (Numeric keys survive the trip — events are msgpack, not JSON.)
        -- Guarded, not assumed: the resolver lives in modules/phone (which owns the
        -- booking cache) and core's first sync runs before that module has loaded —
        -- an unguarded call would error out the whole boot payload.
        reservedSeats = (ReservedSeatMap and ReservedSeatMap(r.id)) or {},
    }
end

-- A "product" is anything the kitchen PRODUCES: a recipe cook output, an assembly
-- output, or a finish output. Products live in the per-player cooked-items tray,
-- never the real inventory, so they do NOT need to be installed inventory items to
-- be valid config — a finish can target/output one (a frosted doughnut) that only
-- ever exists as a cooked/tray item. Finish targets & outputs are validated with
-- `ItemExists(x) or IsProductItem(x)` so a tray-only product never hides the tool,
-- exactly like the beef/chicken patties. (Mirrors the cooking module's isTrayItem,
-- but global so the sync/annotate here can use it.)
function IsProductItem(item)
    if not item or item == "" then return false end
    for _, r in ipairs(RecipeCache) do
        if r.output_cooked_item == item or r.output_burnt_item == item then return true end
    end
    for _, a in ipairs(GetAssembly()) do
        if a.output == item then return true end
    end
    for _, f in ipairs(GetFinishes()) do
        for _, t in ipairs(f.targets or {}) do
            if t.output == item then return true end
        end
    end
    -- a bake-tray output (raw_cake / raw_cookie) is a tray-only uncooked
    -- intermediate (like raw_pizza) — a kitchen product, never a carried item
    for _, b in ipairs(GetBakingList()) do
        for _, t in ipairs(b.trays or {}) do
            if t.output == item then return true end
        end
    end
    return false
end

-- A finish target/output item is usable if it's an installed inventory item OR a
-- kitchen product (tray item). The tool itself is NOT a product — it must be real.
local function FinishItemOk(item) return ItemExists(item) or IsProductItem(item) end

function BuildSyncPayload()
    -- Only valid configs are shipped to the game world. A recipe / drink /
    -- assembly that references a missing item is hidden until an admin fixes it
    -- (it still shows in the admin panel, flagged, so it *can* be fixed).
    local recipes = {}
    for _, r in ipairs(RecipeCache) do
        if IsRecipeValid(r) then recipes[#recipes + 1] = r end
    end
    local drinks = {}
    for i, d in ipairs(GetDrinks()) do
        -- only the cup (input) must be an installed item — the output is a flavor
        -- KEY (poured drinks collect as the one `serving_item` item, flavor in meta)
        if ItemExists(d.input) then
            -- `tap` = the entry's RAW config position: the fountain tap it holds
            -- (first six only). Stamped on a copy so the derived row stays clean.
            local copy = {}
            for k, v in pairs(d) do copy[k] = v end
            copy.tap = (i <= 6) and i or nil
            drinks[#drinks + 1] = copy
        end
    end
    local assembly = {}
    for _, a in ipairs(GetAssembly()) do
        -- the OUTPUT is a kitchen product (tray-held, IsProductItem) — it works
        -- without being an installed item (raw_pizza never is; only taking it out
        -- via trayToInventory would need one). Components are real consumed items.
        local ok = true
        for _, comp in ipairs(a.components or {}) do
            -- a component is a real consumed item OR a kitchen product (a cooked patty
            -- from the pool) — the latter needn't be installed (IsProductItem)
            if not ItemExists(comp) and not IsProductItem(comp) then ok = false end
        end
        if ok then assembly[#assembly + 1] = a end
    end
    -- Bag foods: shipped only when the ONE takeout-box item is installed (every
    -- bag food collects as it — no box item, nothing to hand out) AND every
    -- component resolves (a real consumed item OR a cooked-pool product).
    local crafts = {}
    if ItemExists(BoxItemName()) then
        for _, cr in ipairs(GetCrafts()) do
            local ok = (cr.id and cr.id ~= "" and cr.components and #cr.components > 0)
            for _, comp in ipairs(cr.components or {}) do
                if not ItemExists(comp) and not IsProductItem(comp) then ok = false end
            end
            if ok then crafts[#crafts + 1] = cr end
        end
    end
    -- Decorate tools ship with only their valid targets: the tool must be a real
    -- (consumed) inventory item, but a target/output may be a tray-only PRODUCT
    -- (a frosted doughnut is a finish output, never installed) — FinishItemOk. An
    -- entry with no surviving targets is dropped entirely.
    local finishes = {}
    for _, f in ipairs(GetFinishes()) do
        if ItemExists(f.tool) then
            local targets = {}
            for _, t in ipairs(f.targets or {}) do
                if FinishItemOk(t.item) and FinishItemOk(t.output) then targets[#targets + 1] = t end
            end
            if #targets > 0 then
                local copy = {}; for k, v in pairs(f) do copy[k] = v end
                copy.targets = targets
                finishes[#finishes + 1] = copy
            end
        end
    end

    -- Layer tools (condiments): shipped only when the bottle's inventory item is
    -- real (consumed) and both of its props are configured. An entry missing any
    -- of these is dropped — the applicator would have nothing to spawn otherwise.
    local condiments = {}
    for _, c in ipairs(GetCondiments()) do
        if c.item and ItemExists(c.item) and c.container_model and c.applied_model then
            condiments[#condiments + 1] = c
        end
    end

    -- Fill tools (baking): a LIST now (one entry per fill tool). Each ships only
    -- when its mix is a real (consumed) inventory item; individual trays are
    -- dropped unless their output is a usable item/product (raw_cake/raw_cookie
    -- are real items — needed for bakeTrayToInv).
    local baking = {}
    for _, b in ipairs(GetBakingList()) do
        if b.mix_item and ItemExists(b.mix_item) then
            local trays = {}
            for _, t in ipairs(b.trays or {}) do
                if t.kind and t.tray_model and FinishItemOk(t.output) then trays[#trays + 1] = t end
            end
            if #trays > 0 then
                baking[#baking + 1] = { mix_item = b.mix_item, mix_model = b.mix_model,
                                        rub_dist = b.rub_dist, trays = trays }
            end
        end
    end

    -- Ingredients: the client's per-item behavior config (prep prop + halves /
    -- melts properties). Only entries whose item is installed are shipped —
    -- everything the client needs to render toppings, split halves, etc.
    local ingredients = {}
    for _, ing in ipairs(GetIngredientsCfg()) do
        if ing.item and ItemExists(ing.item) then
            ingredients[#ingredients + 1] = ing
        end
    end

    -- Pizza-box acceptance, resolved server-side into a plain MODEL list so the
    -- client's drag preview can hash-match the carried pile's bottom prop: every
    -- box_base ingredient's own prop, plus the cook-state models of any recipe fed
    -- by an assembly whose FIRST component is that ingredient (raw pizza at every
    -- cook state), plus a recipe cooking the ingredient directly.
    local boxSeen, box_base_models = {}, {}
    local function addBoxModel(m)
        if m and m ~= "" and not boxSeen[m] then boxSeen[m] = true; box_base_models[#box_base_models + 1] = m end
    end
    for _, ing in ipairs(GetIngredientsCfg()) do
        if ing.box_base then
            addBoxModel(ing.model)
            local function addRecipeModels(r)
                if r then addBoxModel(r.raw_model); addBoxModel(r.cooked_model); addBoxModel(r.burnt_model) end
            end
            addRecipeModels(RecipeByInput[ing.item])
            for _, a in ipairs(GetAssembly()) do
                if (a.components or {})[1] == ing.item then
                    if a.model then addBoxModel(a.model) end
                    addRecipeModels(RecipeByInput[a.output])
                end
            end
        end
    end

    local payload = { restaurants = {}, props = {}, recipes = recipes, settings = {
        drinks   = drinks,
        assembly = assembly,
        crafts   = crafts,
        -- The two takeaway vessels, so the client can spawn the equipment and
        -- render a finished/held one: the TAKEOUT BOX (base + hinged lid) every
        -- bag-kind food is created in, and the RESTAURANT BAG carrier a takeaway
        -- order is packed into.
        box_item       = BoxItemName(),
        box_base_model = BoxBaseModel(),
        box_lid_model  = BoxLidModel(),
        bag_item  = BagItemName(),
        bag_model = BagModel(),
        -- the EAT-IN carrier's item name. Synced only so the client can refuse a
        -- carrier-in-a-carrier drag up front (IsCarrierItem) — prepAdd is the
        -- authority; this just outlines the drop red instead of round-tripping.
        meal_item = GetSetting("meal_item", "meal"),
        -- THE RESTAURANT ITEM: one serving of anything the kitchen makes (every
        -- poured drink, every pocketed cooked product), what it is riding in
        -- metadata. Shipped so the client can tell a finished SERVING from a build
        -- component by item name rather than by guessing at cup models — a serving
        -- is finished and never takes part in stacking.
        serving_item = ServingItemName(),
        finishes = finishes,
        condiments = condiments,
        baking   = baking,
        ingredients = ingredients,
        box_base_models = box_base_models,
        -- per-model manual stacking corrections for the client render (see the
        -- stack_tweaks setting seed)
        stack_tweaks = GetSetting("stack_tweaks", {}),
        -- authored per-container serving seats for a batch bake (see the bake_slots
        -- setting seed) — the client lays a cookie tray out from these, not from maths
        bake_slots = GetSetting("bake_slots", {}),
        -- SUPPLY DEPOTS (modules/supply). Genuinely global world config — a handful of
        -- points and model names — and the client needs them to build the depot
        -- interactions at all. Validated on read there, so what ships is already the
        -- shape the client can trust; nil with the module absent.
        supply = SupplyConfig and SupplyConfig() or nil,
        -- the side-serving container box (fries…) — shipped so the client can apply
        -- the mesh-bottom base-lift correction when it's the base of a build stack
        side_container_model = GetSetting("side_container_model", ""),
    } }
    for _, r in pairs(RestaurantCache) do payload.restaurants[#payload.restaurants + 1] = BuildClientRestaurant(r) end
    for _, p in pairs(PropCache) do payload.props[#payload.props + 1] = p end
    -- No props fingerprint here. There briefly was one, so a client could skip rebuilding
    -- the world when the props hadn't changed — but the client now DIFFS PER PROP against
    -- the row it built each one from (`propRowSig`, modules/main/client.lua), which is
    -- strictly finer: a single moved prop no longer rebuilds the world either, and the
    -- reconciler needs a per-prop answer anyway to load props by proximity. One mechanism,
    -- in the place that acts on it.
    return payload
end

function SyncToClient(target)
    TriggerClientEvent("pickle_restaurants:sync", target, BuildSyncPayload())
end

-- ─── the full world sync is COALESCED ────────────────────────────────────────
--
-- `SyncToClient(-1)` is the single most expensive thing this resource can do: the payload
-- is every restaurant (with its whole priced menu), every prop, every recipe and the
-- entire authored menu config — tens to hundreds of KB — and it is sent once per
-- connected player. On the receiving end DoApplySync then tears down and respawns every
-- prop of every restaurant, blocking on each model.
--
-- Nearly every caller is an EDIT from an auto-saving panel (the NUI has no save buttons by
-- design), so dragging a colour picker or typing in a price field used to emit one of
-- these per debounce tick. They are also almost always redundant with each other: ten
-- setting writes in a row need ONE resulting payload, not ten identical ones.
--
-- So config changes call SyncWorldSoon() and a flusher sends at most one payload per
-- SYNC_MIN_MS, building it ONCE for everybody. Callers that must be immediate (a client's
-- own requestSync, boot) still call SyncToClient directly with their target.
local worldDirty = false
local SYNC_MIN_MS = 1500 -- floor between full world syncs (TUNE IN-GAME)

function SyncWorldSoon() worldDirty = true end

CreateThread(function()
    while true do
        Wait(SYNC_MIN_MS)
        if worldDirty then
            worldDirty = false
            -- one payload, reused for every recipient by the event layer
            SyncToClient(-1)
        end
    end
end)

-- Push ONE restaurant's reserved-seat map. A booking starting, being cancelled or lapsing
-- changes a `{ propId -> true }` table and nothing else — it used to cost a full world
-- sync (every restaurant, every prop, every recipe, to every player), including one from
-- the expiry sweep as often as once a minute for as long as the server is up.
--
-- Scoped to the restaurant, which is only safe because the map rides the approach fetch
-- (`world:getRestaurant`) as well: a client bakes "Reserved" into a seat's interaction from
-- whatever map it last held, so without that edge a player who was across the map when a
-- booking landed would keep a stale label indefinitely. With it, they read the current map
-- as they walk in — before any of those seats is in reach.
function SyncReservedSeats(rid)
    rid = tonumber(rid) or rid
    if not rid or not ReservedSeatMap then return end
    SendTo(PlayersNearRestaurant(rid, ScopeRadius.BOARD),
           "pickle_restaurants:reservedSeats", rid, ReservedSeatMap(rid))
end

-- ONE RESTAURANT'S AUTHORITATIVE WORLD, fetched by a client as it approaches.
--
-- This is the HYDRATION EDGE that lets the prop events be scoped at all. `propPlaced`,
-- `propRemoved`, `shellMoved` and `reservedSeats` now go only to players near the
-- restaurant, so a client that was across the map while an admin was placing props holds a
-- stale set. It repairs itself here: approaching a restaurant replaces everything the client
-- knows about it with the server's current answer, before anything of it is in view.
--
-- Public and unguarded on purpose — placed props are world furniture, visible to anyone who
-- walks in. `reservedSeats` rides along because it is the other thing a seat's interaction
-- needs and it is holder-agnostic (a label hint; `seating:sit` is the gate).
lib.callback.register("pickle_restaurants:world:getRestaurant", function(_, d)
    local rid = tonumber(d and d.id)
    if not rid or not GetRestaurant(rid) then return nil end
    local props = {}
    for _, p in pairs(PropCache) do
        if p.restaurant_id == rid then props[#props + 1] = p end
    end
    return {
        id    = rid,
        props = props,
        reservedSeats = (ReservedSeatMap and ReservedSeatMap(rid)) or {},
    }
end)

RegisterNetEvent("pickle_restaurants:requestSync", function()
    -- Rebuild the catalogue from the live inventory first, so newly-registered
    -- items reach the client picker (and validation) without a resource restart.
    if Inventory and Inventory.RefreshItems then Inventory.RefreshItems() end
    -- Hand the framework bridge's item list to the client so GetItemLabel works
    -- and the client-side Inventory mirror flips to Ready.
    if Inventory and Inventory.Items then
        TriggerClientEvent("pickle_restaurants:setupInventory", source, { items = Inventory.Items })
    end
    SyncToClient(source)
end)

-- ─── boot ────────────────────────────────────────────────────────────────────

CreateThread(function()
    MySQL.ready(function()
        CreateTables()
        -- Do not open the gate on a broken schema. oxmysql swallows a failed CREATE
        -- (logs, never raises), so verify the tables actually landed and retry
        -- rather than letting every downstream query spam "table doesn't exist".
        local missing = FirstMissingTable()
        while missing do
            print(("[pickle_restaurants] schema incomplete after CreateTables (missing `%s`) — retrying in 2s. If you just wiped SQL, RESTART this resource; a live DROP doesn't re-run migrations."):format(missing))
            Wait(2000)
            CreateTables()
            missing = FirstMissingTable()
        end
        LoadSettings()
        SeedUnifiedMenu()
        RebuildDerived()
        LoadRestaurants()
        LoadProps()
        LoadStock()
        LoadOrders()
        LoadPendingRefunds() -- refunds owed to customers who were offline at cancel time
        LoadCookedItems()
        LoadTips()             -- the unpaid tip pool per restaurant
        -- NOT the reservation holds: modules/phone owns the booking cache and loads each
        -- row's seats and guests onto it in its own LoadReservations (it also creates
        -- those tables, after core has booted — a load from here would race that).
        RestaurantsReady = true
        debugPrint(("Booted: %d restaurants, %d props, %d recipes."):format(
            #BuildSyncPayload().restaurants, #BuildSyncPayload().props, #RecipeCache))
        -- Push to anyone already connected (resource restart mid-session).
        SyncToClient(-1)
    end)
end)
