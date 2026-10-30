-- =============================================
--  modules/sales | server.lua
--  Fast-food POS. The cashier rings up a NEW ORDER from the restaurant's
--  priced, group-accessible sellable catalog; the customer pays at order time
--  (another player gets a confirm prompt; "Myself" charges the cashier) and
--  receives a RECEIPT whose metadata carries the ticket. The order sits in the
--  kitchen queue until staff cook the items and Complete it at the register —
--  the food (build-stack metadata intact) is handed to the receipt holder —
--  or Cancel it (full refund). Nothing sells "from stock" any more.
-- =============================================

local function ReceiptItem() return GetSetting("receipt_item", "restaurant_receipt") end
local function MealItemName() return GetSetting("meal_item", "meal") end

-- The two PACKED VESSELS a ticket can be filled from: the eat-in serving tray meal
-- and the takeaway Restaurant Bag. Both record one top-level metadata layer per
-- thing packed into them, so fulfillment treats them identically — the only
-- difference is which item is consumed and handed over. Anything else a client
-- names falls back to the meal, so a bad payload can never make the POS hand over
-- an arbitrary item.
local function VesselItem(item)
    if item and item == BagItemName() then return item end
    return MealItemName()
end
local function VesselItems() return { MealItemName(), BagItemName() } end

-- The display image for a drink FLAVOR (its `drinks[].output` key). Every poured
-- drink collapses into the ONE generic drink item, so a flavor has no inventory
-- image of its own — the same problem the NUI's localImages helpers solve, resolved
-- ONCE here so EVERY surface (the plain-JS DUI boards, the phone, the tickets widget,
-- register meal layers) gets a correct `image` without re-implementing the lookup.
-- Preference order, mirroring web/src/lib/localImages.ts:
--   1. supplied local art (web/public/items/<output>.png → nui/items/<output>.png),
--      verified present on disk so we never override a good generic with a 404;
--   2. the output key's own inventory image, if an admin pointed the flavor at a
--      real installed drink item;
--   3. nil → the caller falls back to the generic drink item image.
-- The on-disk check is static per resource load, so cache it (false = no file).
local DRINK_ART_FILE = {}
function DrinkFlavorImage(output)
    if type(output) ~= "string" or output == "" then return nil end
    local f = DRINK_ART_FILE[output]
    if f == nil then
        local res = GetCurrentResourceName()
        if LoadResourceFile(res, "nui/items/" .. output .. ".png") then
            f = ("nui://%s/nui/items/%s.png"):format(res, output)
        else
            f = false
        end
        DRINK_ART_FILE[output] = f
    end
    if f then return f end
    if ItemExists(output) then return GetItemImage(output) end
    return nil
end

-- The image an order LINE shows: a drink pins its chosen flavor's art (`variant`),
-- everything else keeps the sellable's own image (fallback to the item image).
local function LineImage(kind, variant, fallback, item)
    if kind == "drink" then
        local img = DrinkFlavorImage(variant)
        if img then return img end
    end
    return fallback or GetItemImage(item)
end

-- A drink's `color` is stored as an { r, g, b } triplet (soda-machine tint); the NUI
-- swatch needs a CSS string. Passes a hex string through unchanged.
local function drinkColorCss(c)
    if type(c) == "table" and c[1] then
        return ("rgb(%d, %d, %d)"):format(
            math.floor(tonumber(c[1]) or 0), math.floor(tonumber(c[2]) or 0), math.floor(tonumber(c[3]) or 0))
    end
    return (type(c) == "string" and c ~= "") and c or nil
end

-- ─── sellable catalog ────────────────────────────────────────────────────────
-- Everything a restaurant may put a price on: cooked recipe outputs, assembled
-- products, drink flavors and finish outputs — group-filtered per restaurant and
-- validity-filtered like the sync payload. Intermediates never sell: a recipe
-- output that is an assembly COMPONENT (a cooked patty) and an assembly output
-- that is a recipe INPUT (raw_pizza) are kitchen-internal. Meals aren't listed
-- either — a meal is an arbitrary arrangement, not a priceable product.
-- `variant` disambiguates drinks: every flavor collects as the ONE drink item,
-- so a price row is keyed (item, variant = flavor key); '' for everything else.
function BuildSellableCatalog(rid)
    local out, seen = {}, {}
    -- `cost` is the raw ingredient cost of this sellable; the computed default
    -- menu price is that cost marked up by the global profit margin.
    local function add(item, variant, label, kind, cost, modifiers, group, imageOverride)
        variant = variant or ""
        local key = item .. (variant ~= "" and ("::" .. variant) or "")
        if seen[key] then return end
        seen[key] = true
        -- A tray-only PRODUCT has no inventory item to borrow a name/picture from, so
        -- it reads from the FOOD that authors it ("Fries", not "Cooked Fries") — the
        -- same identity rule the kitchen bar and the bag's contents menu follow. An
        -- installed item keeps the catalogue's own label/art exactly as before.
        local food = (not ItemExists(item)) and FoodForItem(item) or nil
        out[#out + 1] = { key = key, item = item, variant = variant,
                          label = label or (food and food.label) or GetItemLabel(item), kind = kind,
                          -- the sellable's ACCESS GROUP (Bakery/Pizza…)
                          group = (type(group) == "string" and group ~= "") and group or nil,
                          -- a drink's card borrows its first flavor's art (it has no image of
                          -- its own — see DrinkFlavorImage) so the generic card is never blank
                          image = imageOverride or GetItemImage(item) or (food and FoodImageUrl(food, item)),
                          defaultPrice = MarkupPrice(cost or 0),
                          -- POS customisations the customer can pick (add cheese, no lettuce…)
                          modifiers = (type(modifiers) == "table" and #modifiers > 0) and modifiers or nil }
    end

    -- A sellable's output does NOT have to be an installed inventory item. Cooked and
    -- assembled foods live only in the restaurant-wide cooked-items pool and reach the
    -- customer packed into a meal or a Restaurant Bag — that is the whole point of the
    -- vessels, and why `RecipeMissingItems`/`IsProductItem` never require them to be
    -- installed. Gating the MENU on ItemExists contradicted that: every default cooked
    -- food (fries, doughnut, pizza…) silently vanished from the POS, the boards, the
    -- kiosk and the phone, which reads exactly like the group filter being broken.
    -- What products can't do is be handed over LOOSE — PlanFulfillment enforces that.
    local function sellableOk(item) return ItemExists(item) or IsProductItem(item) end

    -- components of any assembly recipe are kitchen-internal (patties, buns…)
    local isComponent = {}
    for _, a in ipairs(GetAssembly()) do
        for _, c in ipairs(a.components or {}) do isComponent[c] = true end
    end

    -- POS modifiers derived from IN-PLACE finishes on a cooked item (a doughnut's
    -- frosting + sprinkles, a cake's frosting flavor): each finish tool becomes a
    -- single-choice GROUP and every flavor a pick-one option (colored swatch). Only
    -- finishes that keep the SAME item (t.item == t.output — every collapsed finish:
    -- doughnut frosting/sprinkles, cake frosting) become modifiers, so the item
    -- stays ONE sellable. Ticket instructions only — the cook applies the finish.
    local function finishModsFor(item)
        local mods = {}
        for _, f in ipairs(GetFinishes()) do
            if ItemExists(f.tool) then
                local groupLabel = GetItemLabel(f.tool)
                for _, t in ipairs(f.targets or {}) do
                    if t.item == item and t.output == item then
                        for _, fl in ipairs(t.flavors or {}) do
                            mods[#mods + 1] = { id = f.tool .. ":" .. tostring(fl.id),
                                                label = fl.label or fl.id, group = groupLabel,
                                                color = fl.color, price = 0 }
                        end
                    end
                end
            end
        end
        return (#mods > 0) and mods or nil
    end

    for _, r in ipairs(RecipeCache) do
        local outItem = r.output_cooked_item
        if IsRecipeValid(r) and RestaurantHasAccess(rid, r.group)
            and sellableOk(outItem) and not isComponent[outItem] then
            add(outItem, nil, nil, "recipe", ResolveItemCost(outItem), finishModsFor(outItem), r.group)
        end
    end

    for _, a in ipairs(GetAssembly()) do
        -- an assembly output that is some recipe's input is tray-only (raw_pizza)
        if not RecipeByInput[a.output] and sellableOk(a.output)
            and RestaurantHasAccess(rid, a.group) then
            local ok = true
            for _, comp in ipairs(a.components or {}) do
                -- a component is a real item OR a cooked-pool product (a patty) — the
                -- latter is valid without being installed (IsProductItem), so a burger
                -- still sells even though its patty is a pool-only intermediate
                if not ItemExists(comp) and not IsProductItem(comp) then ok = false end
            end
            -- enrich each modifier with its item's image + a clean price for the
            -- POS grid (the raw config price/default/id survive for order pricing)
            local mods
            if type(a.modifiers) == "table" and #a.modifiers > 0 then
                mods = {}
                for _, m in ipairs(a.modifiers) do
                    mods[#mods + 1] = {
                        id = m.id, label = m.label,
                        price = math.max(0, math.floor(tonumber(m.price) or 0)),
                        default = (m.default == true or m.default == 1) or nil,
                        image = (m.item and m.item ~= "") and GetItemImage(m.item) or nil,
                    }
                end
            end
            if ok then add(a.output, nil, a.label, "assembly", ResolveItemCost(a.output), mods, a.group) end
        end
    end

    -- Bag-kind foods (made in the takeout box): every one collapses to the ONE box
    -- item, disambiguated by its `id` as the POS variant (like a drink flavor). A
    -- price row per food (takeout_box::soup). Modifiers enriched exactly like the
    -- assembly block.
    local bagItem = BoxItemName()
    if ItemExists(bagItem) then
        for _, cr in ipairs(GetCrafts()) do
            if cr.id and cr.id ~= "" and cr.components and #cr.components > 0
                and RestaurantHasAccess(rid, cr.group) then
                local ok = true
                for _, comp in ipairs(cr.components) do
                    if not ItemExists(comp) and not IsProductItem(comp) then ok = false end
                end
                local mods
                if type(cr.modifiers) == "table" and #cr.modifiers > 0 then
                    mods = {}
                    for _, m in ipairs(cr.modifiers) do
                        mods[#mods + 1] = {
                            id = m.id, label = m.label,
                            price = math.max(0, math.floor(tonumber(m.price) or 0)),
                            default = (m.default == true or m.default == 1) or nil,
                            image = (m.item and m.item ~= "") and GetItemImage(m.item) or nil,
                        }
                    end
                end
                -- the food's OWN picture on the POS card (a bag-kind food has no prop
                -- and no inventory item of its own to borrow art from)
                if ok then add(bagItem, cr.id, cr.label, "craft", CraftCost(cr), mods, cr.group,
                               FoodImageUrl(cr, bagItem)) end
            end
        end
    end

    -- Drinks collapse to ONE sellable: the drink item, with every accessible flavor a
    -- single-choice modifier (a coloured "pick one" group, exactly like the finish
    -- flavors above). The chosen flavor rides the order line as its `variant` (its menu
    -- identity), so kitchen fulfillment still pins the exact flavor — a Cola order is
    -- never filled by a Sprite. One price covers every flavor (modifier price 0).
    local drinkItem = ServingItemName()
    if ItemExists(drinkItem) then
        local flavors, cost, grp, mixed = {}, nil, nil, false
        for _, d in ipairs(GetDrinks()) do
            if ItemExists(d.input) and d.output and d.output ~= ""
                and RestaurantHasAccess(rid, d.group) then
                -- the flavor tile reads the drink's own metadata: the output key's
                -- item image if one is installed (an admin-picked real drink), else
                -- its configured colour swatch — so the picker is never a blank tile.
                flavors[#flavors + 1] = { id = "flavor:" .. d.output, variant = d.output,
                                          label = d.label or GetItemLabel(d.output),
                                          group = _L("order_drink_flavor_group"),
                                          image = DrinkFlavorImage(d.output),
                                          color = drinkColorCss(d.color), price = 0 }
                local c = ResolveItemCost(d.input)
                if not cost or c < cost then cost = c end
                -- the sellable's access group is the flavors' common group (nil if they
                -- differ)
                local g = (type(d.group) == "string" and d.group) or ""
                if #flavors == 1 then grp = g elseif g ~= grp then mixed = true end
            end
        end
        if #flavors > 0 then
            -- the generic drink card borrows its first flavor's art (mirrors the POS)
            local cardImg = DrinkFlavorImage(flavors[1].variant) or GetItemImage(drinkItem)
            -- NAMED AS A DRINK, not as the item. The vessel is generic now (the same
            -- item holds a pocketed burger), so `GetItemLabel` would put "Restaurant
            -- Item" on the menu board where "Fountain Drink" belongs.
            add(drinkItem, "", _L("sell_drink_label"), "drink", cost or 0, flavors,
                (not mixed and grp ~= "") and grp or nil, cardImg)
        end
    end

    for _, f in ipairs(GetFinishes()) do
        if ItemExists(f.tool) and RestaurantHasAccess(rid, f.group) then
            for _, t in ipairs(f.targets or {}) do
                if sellableOk(t.output) then
                    add(t.output, nil, nil, "finish", ResolveItemCost(f.tool) + ResolveItemCost(t.item), nil, f.group)
                end
            end
        end
    end

    -- INGREDIENTS THAT ARE THINGS IN THEIR OWN RIGHT (a kids-meal toy) sell like
    -- anything else. What marks one is exactly what makes it usable: a `consume`
    -- block. A component has none — lettuce is not a menu item — so this admits the
    -- handful of ingredients a customer actually receives and does something with,
    -- and nothing else. Belt and braces: anything an assembly builds with is
    -- excluded too, so an edible component can never leak onto the POS.
    --
    -- A MULTI-FACED ingredient sells one line PER FACE, each priced from its own
    -- stock key — the takeout box's pattern exactly (one item, a sellable per
    -- variant, the variant pinned on the order line so a Lardboy order is never
    -- filled with a Smelly Kat).
    for _, ing in ipairs(GetIngredientsCfg()) do
        if ing.consume and ing.item and ItemExists(ing.item)
            and not isComponent[ing.item] and RestaurantHasAccess(rid, ing.group) then
            local vs = IngredientVariants(ing.item)
            if vs then
                for _, v in ipairs(vs) do
                    add(ing.item, v.id, v.label, "ingredient",
                        ResolveItemCost(StockKey(ing.item, v.id)), nil, ing.group, v.image)
                end
            else
                add(ing.item, nil, ing.label, "ingredient", ResolveItemCost(ing.item), nil, ing.group)
            end
        end
    end

    table.sort(out, function(a, b) return (a.label or a.item):lower() < (b.label or b.item):lower() end)
    return out
end

-- The catalog joined against the restaurant's price list (`pickle_restaurant_menu`,
-- keyed item+variant). Every entry carries price/enabled; `pricedOnly` keeps just
-- the orderable ones (priced above zero AND enabled) for the POS grid.
function BuildPricedCatalog(rid, pricedOnly)
    local rows = MySQL.query.await(
        "SELECT item, variant, price, enabled FROM pickle_restaurant_menu WHERE restaurant_id = ?", { rid }) or {}
    local priced = {}
    for _, m in ipairs(rows) do
        priced[m.item .. ((m.variant and m.variant ~= "") and ("::" .. m.variant) or "")] =
            { price = math.floor(tonumber(m.price) or 0), enabled = (m.enabled == 1 or m.enabled == true) }
    end
    local catalog, out = BuildSellableCatalog(rid), {}
    for _, e in ipairs(catalog) do
        local p = priced[e.key]
        if p then
            -- explicit per-restaurant row: honoured verbatim (incl. an explicit
            -- 0/disabled — a boss can deliberately pull an item)
            e.price = p.price
            e.enabled = p.enabled
            e.priceIsDefault = false
        else
            -- no row set: fall back to the ingredient-cost default so the item is
            -- orderable out of the box (a $0 default → not orderable, safe)
            e.price = e.defaultPrice or 0
            e.enabled = e.price > 0
            e.priceIsDefault = true
        end
        if not pricedOnly or (e.enabled and e.price > 0) then out[#out + 1] = e end
    end
    return out, priced
end

-- A compact projection of the orderable menu for the customer-facing MENU SCREEN
-- (modules/screens): just what a board needs to show — label, price, image and a
-- coarse `kind` for sectioning. Rides the restaurant sync payload so a placed screen
-- always shows the current, live menu (re-synced whenever the menu is edited).
-- GROUPED, not alphabetical. A menu board is read the way a menu is read — burgers
-- together, drinks together — and the catalog's own `group` is already the category
-- an admin authored (it is the access group, which is what a restaurant's sections
-- ARE here). Ungrouped entries sort last under one unnamed heading rather than
-- being dropped: a board that hides an unfiled item reads as a broken menu.
-- The board paginates PER GROUP off this order, so the sort is the sectioning.
function BuildMenuBoard(rid)
    local out = {}
    for _, e in ipairs((BuildPricedCatalog(rid, true))) do
        out[#out + 1] = { label = e.label or GetItemLabel(e.item), price = e.price,
                          image = e.image or GetItemImage(e.item), kind = e.kind,
                          group = e.group }
    end
    -- Stable-ish: group name (case-folded, ungrouped last), then label.
    table.sort(out, function(a, b)
        local ga = (type(a.group) == "string" and a.group ~= "") and a.group:lower() or nil
        local gb = (type(b.group) == "string" and b.group ~= "") and b.group:lower() or nil
        if ga ~= gb then
            if not ga then return false end
            if not gb then return true end
            return ga < gb
        end
        return (a.label or ""):lower() < (b.label or ""):lower()
    end)
    return out
end

-- ─── shared money bits ───────────────────────────────────────────────────────

-- What cut of a sale the player ringing it up takes, as a percentage. Commission is a
-- property of the RANK, not of a person: a boss sets one rate per grade and everyone
-- on that grade earns it, so there is no per-employee rate to look up any more.
-- ResolvePerms' 3rd return is the JOB INFO of the player at this restaurant — nil for
-- an admin or an owner who doesn't hold the job, so they still earn nothing, exactly
-- as they did when they had no employee row.
local function commissionRate(rid, src)
    local _, _, jobInfo = ResolvePerms(rid, src)
    if not jobInfo then return 0 end
    return math.max(0, math.min(100, tonumber(RankFor(rid, jobInfo.grade).commission) or 0))
end

-- Pay the serving employee's commission out of the restaurant's take (the same
-- flow the old per-item sale used, now per ORDER).
--
-- NOT WHEN THEY SERVED THEMSELVES. A cashier who rings up their own burger is the
-- customer AND the server, so a commission hands them part of their own payment straight
-- back: an $8 burger charged $8, printed a receipt, and returned $1 (10% of 8, rounded),
-- which reads exactly like the POS giving change it has no business giving. It is also a
-- money faucet the moment a rank's commission passes the rounding threshold. Commission
-- is a cut for SERVING SOMEONE; there is no service in a self-purchase.
-- `customerIdent` is the identifier the ticket was rung up for (an NPC's is prefixed, so
-- it can never collide with a real one).
local function payCommission(rid, src, amount, ticket, customerIdent)
    local id = GetIdentifier(src)
    if customerIdent and id and customerIdent == id then return 0 end
    local commission = RoundMoney(amount * commissionRate(rid, src) / 100)
    if commission > 0 then
        AdjustBalance(rid, -commission)
        AddMoney(src, commission, "money")
        AddLedger(rid, "payroll", -commission, _L("ledger_commission", ticket), id)
    end
    return commission
end

-- ─── ticket fulfillment planner (restaurant-wide cooked-items pool) ──────────
-- Tickets are fulfilled from the UNION of every cook's tray for the restaurant
-- (PoolCount*/PoolConsume* in core), not the cashier's inventory — so cooks needn't
-- double as cashiers. Matching is by BASE ITEM (the menu entry): a burger fills any
-- burger order, a cake any cake, regardless of modifiers/toppings — customisations
-- (cheese, frosting, no-lettuce…) are ticket instructions the cook should honour,
-- never a hard completion gate, so an honest mistake still fulfils the order.
-- DRINKS are the one exception: a drink line pins the flavor the customer picked (the
-- chosen flavor modifier is threaded into the line's `variant`), so a drink matches
-- only its flavor — a Cola order is never filled by a Sprite. As MANY packed vessels as
-- the ticket needs are used, each covering the lines its layers' items match.

-- The MODIFIER items an assembly output offers (cheese, lettuce…) → the parts that
-- make a customised build differ from the plain one, keyed by item AND by modifier
-- id (with each id's default flag). Returns nil if the item isn't an assembly
-- output. Base components (buns, patties) are deliberately NOT here: a burger's bun
-- is split into a top + bottom HALF (two `bun` layers), so counting raw parts would
-- read a plain burger as "two buns" and never match a one-bun order. Only the
-- presence of an actual modifier item (a cheese slice) is a variation.
local function modifierSpec(item)
    for _, a in ipairs(GetAssembly()) do
        if a.output == item then
            local byItem, byId = {}, {}
            for _, m in ipairs(a.modifiers or {}) do
                if m.item and m.item ~= "" then
                    byItem[m.item] = true
                    byId[tostring(m.id)] = { item = m.item, default = (m.default == true or m.default == 1) }
                end
            end
            return { byItem = byItem, byId = byId }
        end
    end
    return nil
end

-- The modifier items a built assembly stack actually carries, as item→count. Two
-- forms count toward a modifier: the modifier item as a stack LAYER, OR the same
-- item riding a layer as a melting TOPPING (a burger's cheese is the grill melt on
-- the patty, never a separate slice, so without the second form a grill-made
-- cheeseburger reads as plain and never matches its "+Cheese" order). Fully generic
-- via LayerTopping — the modifier item is whatever the assembly configured.
local function assemblyModCounts(spec, stack)
    local count = {}
    if type(stack) == "table" then
        for _, s in ipairs(stack) do
            if spec.byItem[s.item] then
                count[s.item] = (count[s.item] or 0) + 1
            end
            local topv = LayerTopping(s) -- a melting topping (from the layer's `top`)
            if topv and spec.byItem[topv.item] then
                count[topv.item] = (count[topv.item] or 0) + 1
            end
        end
    end
    return count
end

-- A canonical match key for one cooked instance / meal layer. Matching is by base
-- item (see the section header), so this is "" for everything EXCEPT a drink, whose
-- flavor is its menu identity. Kept in lock-step with lineVariationKey below so a POS
-- line and a cooked instance describe the same thing.
local function variationKey(item, meta)
    if item == ServingItemName() then
        -- what this serving IS, riding as the Restaurant Item's one meta layer: a
        -- fountain flavor (its menu identity) or, for a pocketed cooked product, the
        -- product itself — which is NOT a menu identity of the vessel, so it gets its
        -- own namespace and can never be filled by a drink line or vice versa.
        local key = (type(meta) == "table" and meta[1] and meta[1].item) or ""
        return (IsDrinkOutputKey(key) and "d:" or "w:") .. tostring(key)
    end
    -- A made takeout box (a bag-kind food) is identified by the food id on its first
    -- meta layer.
    if item == BoxItemName() then
        local key = (type(meta) == "table" and meta[1] and meta[1].craft) or nil
        if key then return "c:" .. tostring(key) end
    end
    -- A MULTI-FACED ingredient (one `restaurant_toy` holding five toys) is generic as
    -- an item, so its face is its menu identity — the same reason a drink pins its
    -- flavor. Checked last and only when there IS metadata to read, so nothing else
    -- pays for the lookup.
    if type(meta) == "table" and meta[1] then
        local iv = IngredientVariantOf and IngredientVariantOf(item, meta)
        if iv then return "v:" .. tostring(iv.id) end
    end
    return "" -- item-name match: any variation of the item fills the line
end

-- The match key an order line asks for, in the SAME key space as variationKey. Only
-- a drink line pins a flavor (its `variant`); every other line matches by item alone,
-- so modifiers/toppings stay ticket instructions and never block completion.
local function lineVariationKey(line)
    if line.kind == "drink" then return "d:" .. tostring(line.variant or "") end
    if line.kind == "craft" then return "c:" .. tostring(line.variant or "") end
    -- a multi-faced ingredient pins its face; a single-faced one matches by item
    -- alone, and must resolve to "" — the same empty key its instances produce.
    if line.kind == "ingredient" and line.variant and line.variant ~= "" then
        return "v:" .. tostring(line.variant)
    end
    return ""
end

-- A predicate an instance's meta must satisfy to fill units of (item, key).
local function variationMatcher(item, key)
    return function(meta) return variationKey(item, meta) == key end
end

-- The order's lines expanded into one { item, key, label } unit per qty.
local function requiredUnits(order)
    local req = {}
    for _, l in ipairs(order.lines or {}) do
        local key = lineVariationKey(l)
        for _ = 1, math.max(1, tonumber(l.qty) or 1) do
            req[#req + 1] = { item = l.item, key = key, label = l.label }
        end
    end
    return req
end

-- Resolve a finish tool:flavor to a display view (label like "Frosting: Strawberry"
-- + the flavor's colour swatch), matching how the POS renders a finish modifier.
local function finishFlavorView(toolId, flavorId)
    for _, f in ipairs(GetFinishes()) do
        if f.tool == toolId then
            for _, t in ipairs(f.targets or {}) do
                for _, fl in ipairs(t.flavors or {}) do
                    if fl.id == flavorId then
                        return { label = GetItemLabel(toolId) .. ": " .. (fl.label or fl.id), color = fl.color }
                    end
                end
            end
            return { label = GetItemLabel(toolId) .. ": " .. tostring(flavorId) }
        end
    end
    return { label = tostring(flavorId) }
end

-- Resolve a drink flavor key to a display view (label + colour).
local function drinkFlavorView(key)
    for _, d in ipairs(GetDrinks()) do
        if d.output == key then return { label = d.label or key, color = d.color } end
    end
    return { label = tostring(key) }
end

-- The image-rich contents of a meal's build stack for the register's in-depth meal
-- picker: one entry per top-level layer, each with the item's label + image and its
-- toppings (a burger's cheese/lettuce as item images, a cake/doughnut's frosting +
-- sprinkles as coloured swatches, a drink shown by its flavor) so the cashier sees
-- exactly what's inside before fulfilling with it.
local function mealItemsDetail(meta, vesselItem)
    local mealItem = vesselItem or MealItemName()
    local out = {}
    for _, l in ipairs(type(meta) == "table" and meta or {}) do
        if l.item ~= mealItem then
            local entry = { item = l.item, image = GetItemImage(l.item), mods = {} }
            if l.item == ServingItemName() and IsDrinkServing(l.item, l.stack) then
                local key = type(l.stack) == "table" and l.stack[1] and l.stack[1].item or nil
                entry.label = drinkFlavorView(key).label
                entry.image = DrinkFlavorImage(key) or entry.image
            elseif l.item == BoxItemName() then
                -- a made takeout box reads as the FOOD it holds (soup, salad), not as
                -- the generic box: its own authored label + picture, resolved from the
                -- food id riding its first component layer
                local food = FoodForItem(l.item, l.stack)
                entry.label = (food and food.label) or GetItemLabel(l.item)
                entry.image = FoodImageUrl(food, l.item) or entry.image
            else
                local top = type(l.stack) == "table" and l.stack[1] or nil
                entry.label = GetItemLabel(l.item)
                if type(top) == "table" and top.flavor then
                    local cur = top
                    while type(cur) == "table" and cur.flavor do
                        local fv = finishFlavorView(cur.tool, cur.flavor)
                        entry.mods[#entry.mods + 1] = { label = fv.label, color = fv.color }
                        cur = type(cur.stack) == "table" and cur.stack[1] or nil
                    end
                else
                    local spec = modifierSpec(l.item)
                    if spec then
                        for it, n in pairs(assemblyModCounts(spec, l.stack)) do
                            for _ = 1, n do
                                entry.mods[#entry.mods + 1] = { label = GetItemLabel(it), image = GetItemImage(it) }
                            end
                        end
                    end
                end
            end
            out[#out + 1] = entry
        end
    end
    return out
end

-- Given a VESSEL's build stack (a serving-tray meal or a packed Restaurant Bag —
-- both record one top-level layer per thing inside them), remove the required units
-- its layers cover (EXACT variation match — a cheeseburger layer covers a "+cheese"
-- burger line, never a plain-burger line). Returns the leftovers.
local function mealCovers(meta, required, vesselItem)
    local mealItem = vesselItem or MealItemName()
    local provide = {}
    for _, l in ipairs(type(meta) == "table" and meta or {}) do
        if l.item ~= mealItem then -- ignore any nested vessel layer
            provide[#provide + 1] = { item = l.item, key = variationKey(l.item, l.stack) }
        end
    end
    local uncovered = {}
    for _, u in ipairs(required) do
        local matched = false
        for _, p in ipairs(provide) do
            if not p.used and p.item == u.item and p.key == u.key then
                p.used, matched = true, true
                break
            end
        end
        if not matched then uncovered[#uncovered + 1] = u end
    end
    return uncovered
end

-- Every packed vessel the restaurant can hand over, one row per variation with its
-- available count (the tray pool + what on-duty staff are carrying). Only vessels that
-- are INSTALLED items are listed — a meal or bag can sit in the tray without being one,
-- and handing over something that would vanish is never an option.
-- `count` is decremented as a plan claims instances, so the caller works on a COPY.
local function vesselPool(rid)
    local out = {}
    for _, vi in ipairs(VesselItems()) do
        if ItemExists(vi) then
            for _, v in ipairs(VesselVariations(rid, vi)) do
                out[#out + 1] = { item = vi, sig = v.sig, meta = v.meta, count = v.count or 1 }
            end
        end
    end
    return out
end

local function clonePool(pool)
    local out = {}
    for i, v in ipairs(pool) do
        out[i] = { item = v.item, sig = v.sig, meta = v.meta, count = v.count }
    end
    return out
end

-- How many top-level things a vessel holds (its own nested vessel layers ignored, the
-- same way mealCovers reads it) — used to prefer the TIGHTEST packing.
local function vesselLayerCount(meta, vesselItem)
    local n = 0
    for _, l in ipairs(type(meta) == "table" and meta or {}) do
        if l.item ~= vesselItem then n = n + 1 end
    end
    return n
end

-- The cashier's explicit picks, in ONE shape whichever surface sent them: a LIST of
-- { sig, item } (the register's picker, which can hand over several packages at once)
-- or the single `mealSig` + `mealItem` pair every other caller still sends (the phone
-- KDS, the NPC branch). `VesselItem` sanitises each item name, so a forged payload can
-- still only ever name a meal or a bag.
-- Global for the same reason the vessel-store helpers are: PlanFulfillment is above
-- them, and a local declared after it wouldn't be in its scope.
function NormalizeVesselPins(mealSig, vesselItem)
    local out = {}
    if type(mealSig) == "table" then
        for _, p in ipairs(mealSig) do
            local sig = (type(p) == "table") and p.sig or nil
            if type(sig) == "string" then
                out[#out + 1] = { sig = sig, item = VesselItem(p.item) }
            end
        end
    elseif type(mealSig) == "string" and mealSig ~= "" then
        out[1] = { sig = mealSig, item = VesselItem(vesselItem) }
    end
    return out
end

-- The picks off a completion payload, in the shape PlanFulfillment takes: the
-- register's `vessels` LIST when it sent one, else the legacy single `mealSig`. ONE
-- door, so the two completion callbacks (player and NPC) can never read a payload
-- differently — and an empty list means "no pick", never "pick nothing", so the
-- planner still fills the ticket by itself.
function VesselPinsFrom(d)
    if type(d) ~= "table" then return nil end
    if type(d.vessels) == "table" and d.vessels[1] then return d.vessels end
    if type(d.mealSig) == "string" and d.mealSig ~= "" then return d.mealSig end
    return nil
end

-- How much of an outstanding requirement ONE vessel covers, as { ["item|key"] = n }.
-- Counted PER GROUP rather than per unit on purpose: the picker adds these up across
-- everything the cashier selected, and two bags each holding one of the two pizzas a
-- ticket asks for must add up to both — which a set of matched unit indices could
-- never express (each bag independently matches the FIRST pizza).
local function vesselCoverage(meta, req, vesselItem)
    local cov = {}
    for _, u in ipairs(req) do
        local k = u.item .. "|" .. u.key
        cov[k] = (cov[k] or 0) + 1
    end
    for _, u in ipairs(mealCovers(meta, req, vesselItem)) do
        local k = u.item .. "|" .. u.key
        cov[k] = (cov[k] or 0) - 1
        if cov[k] <= 0 then cov[k] = nil end
    end
    return cov
end

-- Can the pool complete this order, and with WHAT? An order is filled from two stores:
-- packed VESSELS (serving-tray meals and Restaurant Bags, whose top-level layers cover
-- required units) and loose SINGLES straight out of the cooked-items pool.
-- Returns { ok, singles = { {item, key, count}, … }, vessels = { {item, sig}, … }, missing }.
--
-- As MANY vessels as the ticket needs are used, not one: a big order is packed into two
-- bags as naturally as one, and refusing the second would leave a ticket that is plainly
-- ready sitting incomplete. `mealSig`/`vesselItem` are the cashier's explicit PIN — that
-- exact vessel goes first (ignored if it covers nothing, so a stray pick can't give away
-- an unrelated bag) — and the planner then fills what's left itself, preferring the
-- vessel that covers the most units and, among equals, the one with the least left over
-- inside it, so a 4-item bag is never spent on a 1-item ticket while a single-item bag
-- sits next to it.
--
-- SINGLES ARE SPENT FIRST. A burger sitting loose in a cook's tray fills a burger line
-- without opening a bag; vessels are only claimed for what the loose pool can't cover.
--
-- `looseOk` says the food does NOT have to enter an inventory: an NPC customer just
-- takes what it's handed, so its ticket can be filled straight out of the pool. For a
-- PLAYER every single is `Inventory.AddItem`ed, so a cooked product that isn't an
-- installed item can only reach them inside a meal or a Restaurant Bag — those units
-- are covered by a vessel or reported as a shortfall. Default is the strict rule.
--
-- `pool` is an optional pre-built vesselPool(rid) — AnnotateOrders plans a ticket once
-- per available vessel, and rebuilding the pool (which reads every on-duty employee's
-- inventory) for each of those would be the expensive part.
function PlanFulfillment(rid, order, mealSig, vesselItem, looseOk, pool)
    local req = requiredUnits(order)
    local avail = clonePool(pool or vesselPool(rid))
    local used = {}

    local function claim(v)
        local left = mealCovers(v.meta, req, v.item)
        local covered = #req - #left
        if covered <= 0 then return 0 end
        req = left
        v.count = v.count - 1
        used[#used + 1] = { item = v.item, sig = v.sig }
        return covered
    end

    -- 1. the cashier's explicit picks go first — they chose those exact vessels.
    --    A TICKET MAY TAKE SEVERAL: a pizza and a cake are two different foods, so
    --    they are two different packages, and the picker hands over as many as the
    --    order needs. Each is claimed in the order it was picked and one that covers
    --    nothing LEFT is simply not spent (never hand over an unrelated bag), so a
    --    stray tick can't give food away.
    for _, pin in ipairs(NormalizeVesselPins(mealSig, vesselItem)) do
        local pinned
        for _, v in ipairs(avail) do
            if v.item == pin.item and (v.sig or "") == pin.sig and v.count > 0 then pinned = v break end
        end
        if not pinned then return { ok = false, missing = { _L("order_meal_gone") } } end
        claim(pinned)
    end

    -- 2. what the LOOSE pool can cover, per (item, variation key). An uninstalled
    --    product can't be handed to a player at all, so it never counts here.
    local groups, gorder = {}, {}
    for _, u in ipairs(req) do
        local gk = u.item .. "|" .. u.key
        if not groups[gk] then
            groups[gk] = { item = u.item, key = u.key, label = u.label, need = 0 }
            gorder[#gorder + 1] = gk
        end
        groups[gk].need = groups[gk].need + 1
    end
    local singles, shortfall = {}, {}
    for _, gk in ipairs(gorder) do
        local g = groups[gk]
        -- BOTH loose stores: the cooked-items tray AND staff-held singles (a made
        -- takeout box lives in the cook's inventory, never the tray — see
        -- SingleCountMatch), so a boxed food fills its own line.
        local have = (looseOk or ItemExists(g.item))
            and SingleCountMatch(rid, g.item, variationMatcher(g.item, g.key)) or 0
        local take = math.min(have, g.need)
        if take > 0 then singles[#singles + 1] = { item = g.item, key = g.key, count = take } end
        if take < g.need then shortfall[#shortfall + 1] = { g = g, need = g.need - take } end
    end

    -- 3. everything the loose pool couldn't cover has to come packed. Re-derive the
    --    outstanding units and let the best-fitting vessels take them, one at a time.
    req = {}
    for _, s in ipairs(shortfall) do
        for _ = 1, s.need do
            req[#req + 1] = { item = s.g.item, key = s.g.key, label = s.g.label }
        end
    end
    -- WHAT MUST COME PACKED, reported to the panel so a cashier picking vessels by
    -- hand can be told when their selection actually covers the ticket. Snapshotted
    -- HERE — after singles, before any vessel is claimed — because that is exactly the
    -- question the picker is answering, and the claims below consume `req` as they go.
    local packed = {}
    do
        local idx = {}
        for _, u in ipairs(req) do
            local k = u.item .. "|" .. u.key
            if not idx[k] then
                idx[k] = { id = k, item = u.item, key = u.key,
                           label = u.label or GetItemLabel(u.item), need = 0 }
                packed[#packed + 1] = idx[k]
            end
            idx[k].need = idx[k].need + 1
        end
    end
    while #req > 0 do
        local best, bestCovered, bestSpare
        for _, v in ipairs(avail) do
            if v.count > 0 then
                local covered = #req - #mealCovers(v.meta, req, v.item)
                local spare = vesselLayerCount(v.meta, v.item) - covered
                if covered > 0 and (not best or covered > bestCovered
                    or (covered == bestCovered and spare < bestSpare)) then
                    best, bestCovered, bestSpare = v, covered, spare
                end
            end
        end
        if not best then break end
        claim(best)
    end

    -- 4. whatever is still uncovered is the shortfall the cook has to make good
    local missing = {}
    local left = {}
    for _, u in ipairs(req) do
        local gk = u.item .. "|" .. u.key
        if not left[gk] then
            left[gk] = { label = u.label or GetItemLabel(u.item), item = u.item, key = u.key, need = 0 }
            missing[#missing + 1] = left[gk]
        end
        left[gk].need = left[gk].need + 1
    end
    local lines = {}
    for _, m in ipairs(missing) do
        -- a product that exists in the pool but can't be handed over loose isn't
        -- "still cooking" — it's cooked and waiting to be packed, so say so
        local cooked = (not looseOk) and not ItemExists(m.item)
            and PoolCountMatch(rid, m.item, variationMatcher(m.item, m.key)) > 0
        lines[#lines + 1] = _L(cooked and "order_needs_vessel" or "order_qty_line", m.need, m.label)
    end

    return { ok = (#lines == 0), singles = singles,
             vessels = (#used > 0) and used or nil,
             needs = (#packed > 0) and packed or nil,
             missing = (#lines > 0) and lines or nil }
end

-- Attach per-ticket fulfillment state:
--   `ok`          — singles ALONE complete the order (the register's one-tap complete).
--   `mealOptions` — each pool meal that (with singles) completes the WHOLE order, so
--                   only completing options are ever offered; each carries its exact
--                   layer contents.
--   `ready`       — the order is completable AT ALL: singles alone OR using one of the
--                   available meals. This is what the read-only Tickets widget shows,
--                   so a meal on the tray counts toward "ready".
--   `missing`     — the shortfall of the BEST plan (singles, or singles + the meal that
--                   covers the most), shown when the order can't be completed yet.
-- The pool is restaurant-wide, so this is identical for every cashier — it rides the
-- SyncOrders broadcast unchanged.
-- Forward declaration: AnnotateOrders below resolves the claimed driver's server id,
-- but the definition lives further down with the other order helpers.
local findPlayerByIdentifier

-- ─── the vessel pool ─────────────────────────────────────────────────────────
-- A packed vessel (a meal, a Restaurant Bag, a takeout box) is handed to its maker
-- as a real inventory ITEM the moment it's crafted, so unlike loose cooked products
-- it does NOT sit in the tray. Fulfilment therefore has to look in two places, and
-- the restaurant's STAFF are the second: the tray pool is already restaurant-wide
-- (any cook's tray fills any cashier's ticket), so the vessels its employees are
-- carrying are the same pool by a different storage. Without this, crafting a bag
-- would quietly remove it from the POS.
--
-- Tray entries are still read too — `giveVessel` falls back to the tray whenever the
-- item isn't installed or the maker's inventory is full.

-- Everyone whose pockets count as the restaurant's vessel store: whoever the
-- restaurant currently grants kitchen/counter permission to, resolved through
-- ResolvePerms so there is ONE definition of who staffs a restaurant and it can never
-- drift from the one gating the callbacks.
--
-- This was an identifier list built from an employee table + `owner_identifier`, and
-- it missed anyone who works a restaurant WITHOUT being on its payroll — an admin most
-- of all. An admin has every permission here: they can cook, bag and ring up like any
-- employee, but they hold no job here and own nothing, so a bag in their hands was
-- invisible to fulfillment and the ticket read "bag it or plate it up" while they were
-- standing at the till holding the bag. (The owner had the same bug for the same
-- reason before they were special-cased: they are never hired, so they hold no job
-- either. Asking the permission system instead of enumerating stores is what stops the
-- next such role needing its own special case.)
--
-- Sources, not identifiers: every consumer immediately wanted the player anyway, and
-- the old shape paid a full GetPlayers() scan per identifier to find them.
local function vesselSources(rid)
    local out = {}
    for _, p in ipairs(GetPlayers()) do
        local src = tonumber(p)
        if src then
            -- Anyone the restaurant grants standing to: the owner and admins (both
            -- `isBoss`), ANYONE holding the restaurant's job whatever their rank
            -- (ResolvePerms' 3rd return, `jobInfo` — a fry cook on the lowest grade
            -- could always bag food), plus anyone else granted cook/sell.
            local perms, isBoss, jobInfo = ResolvePerms(rid, src)
            if isBoss or jobInfo or (perms and (perms.cook or perms.sell)) then
                out[#out + 1] = src
            end
        end
    end
    return out
end

-- Memo for ONE AnnotateOrders pass (nil at every other time). That pass plans each
-- ticket once per available vessel, and the loose-single store is now read inside the
-- planner too — so without this, a register refresh would search every employee's
-- inventory tickets × vessels × lines times over. Only ever held across straight-line
-- code (nothing here yields), so it can't serve a stale read, and it is deliberately
-- NOT consulted by the consume paths, which must always see the live inventory.
local holderMemo = nil

-- Every vessel of `item` held by staff of this restaurant, one entry per slot so a
-- specific one can be taken later.
local function vesselHolders(rid, item)
    local memoKey = holderMemo and (tostring(rid) .. "|" .. tostring(item)) or nil
    if memoKey and holderMemo[memoKey] then return holderMemo[memoKey] end
    local out = {}
    if memoKey then holderMemo[memoKey] = out end
    if not (Inventory and Inventory.GetItemSlots) then return out end
    -- the staff list is per-restaurant, not per-item: memoized for the pass alongside
    -- the slot reads so a register refresh resolves permissions once, not once per
    -- vessel item per ticket
    local srcKey = holderMemo and ("srcs|" .. tostring(rid)) or nil
    local sources = (srcKey and holderMemo[srcKey]) or vesselSources(rid)
    if srcKey then holderMemo[srcKey] = sources end
    for _, src in ipairs(sources) do
        for _, s in ipairs(Inventory.GetItemSlots(src, item) or {}) do
            local m = type(s.metadata) == "table" and s.metadata or {}
            local stack = type(m.stack) == "table" and m.stack or nil
            out[#out + 1] = { src = src, slot = s.slot, count = s.count or 1,
                              sig = TraySig(stack), meta = stack }
        end
    end
    return out
end

-- Distinct variations of a vessel across BOTH stores, merged by signature.
function VesselVariations(rid, item)
    local out, idx = {}, {}
    local function add(sig, meta, count)
        local k = sig or ""
        if idx[k] then
            idx[k].count = idx[k].count + count
        else
            idx[k] = { sig = sig, meta = meta, count = count }
            out[#out + 1] = idx[k]
        end
    end
    for _, v in ipairs(PoolVariations(rid, item)) do add(v.sig, v.meta, v.count) end
    for _, h in ipairs(vesselHolders(rid, item)) do add(h.sig, h.meta, h.count) end
    return out
end

function VesselCount(rid, item, sig)
    local n = PoolCount(rid, item, sig)
    for _, h in ipairs(vesselHolders(rid, item)) do
        if h.sig == sig then n = n + h.count end
    end
    return n
end

function VesselTopMeta(rid, item, sig)
    local m = PoolTopMeta(rid, item, sig)
    if m ~= nil then return m end
    for _, h in ipairs(vesselHolders(rid, item)) do
        if h.sig == sig then return h.meta end
    end
end

-- Take ONE, returning its contents so the caller can re-stamp them onto whatever
-- it hands the customer. The tray goes first: it only ever holds a vessel the
-- inventory couldn't (uninstalled item, full pockets), so spending it first drains
-- the fallback store instead of letting it accumulate.
function VesselConsume(rid, item, sig)
    if PoolCount(rid, item, sig) >= 1 then
        local taken = PoolConsume(rid, item, sig, 1)
        if taken and #taken >= 1 then return true, taken[1].meta end
    end
    for _, h in ipairs(vesselHolders(rid, item)) do
        if h.sig == sig then
            -- Same rule as giveVessel: the bridge's remove calls return nothing, so
            -- the count is what says whether it actually went.
            local before = Inventory.GetItemCount(h.src, item) or 0
            if Inventory.RemoveItemSlot then Inventory.RemoveItemSlot(h.src, item, 1, h.slot)
            else Inventory.RemoveItem(h.src, item, 1) end
            if (Inventory.GetItemCount(h.src, item) or 0) < before then
                -- same reason as giveVessel: an inventory-side change to the pool has
                -- to flag the open tickets itself, or the next one keeps reading the
                -- bag that is already gone as available
                MarkOrdersDirty(rid)
                return true, h.meta
            end
        end
    end
    return false
end

-- ─── staff-held SINGLES (the takeout box) ────────────────────────────────────
-- `giveVessel` hands all THREE crafted vessels straight into the maker's inventory,
-- but only TWO of them fulfil as VESSELS: a meal and a Restaurant Bag are claimed for
-- the units their layers COVER. A takeout box is different — it holds one food and IS
-- the sellable unit (a `craft` line asks for the box item pinned to that food's id),
-- so it fills a ticket as a loose SINGLE. The loose store is the cooked-items TRAY,
-- which a made box only reaches when the item isn't installed or the cook's pockets
-- were full — so without this, a boxed soup sitting in the cook's own inventory could
-- never complete its own order, however plainly ready the ticket read.
--
-- Deliberately NOT applied to every item: a cook's personal drink or burger is their
-- own, and only the vessels this resource CRAFTS into inventory belong to the pool.
local function isHeldSingle(item)
    return item ~= nil and item == BoxItemName()
end

-- Staff-held instances of `item` whose build stack satisfies `match`, one entry per
-- unit (a slot may stack, even though the shipped box does not).
local function heldMatches(rid, item, match)
    local out = {}
    if not isHeldSingle(item) or not ItemExists(item) then return out end
    for _, h in ipairs(vesselHolders(rid, item)) do
        if match(h.meta) then
            for _ = 1, math.max(1, h.count or 1) do out[#out + 1] = h end
        end
    end
    return out
end

local function HeldCountMatch(rid, item, match)
    return #heldMatches(rid, item, match)
end

-- Take `count` matching instances out of staff pockets, returning { {meta}, … } in
-- PoolConsumeMatch's shape. Best-effort per unit for the same reason VesselConsume
-- is: no bridge's remove call reports success, so the COUNT before/after is what
-- says whether it actually went.
local function HeldConsumeMatch(rid, item, match, count)
    local taken = {}
    for _, h in ipairs(heldMatches(rid, item, match)) do
        if #taken >= count then break end
        local before = Inventory.GetItemCount(h.src, item) or 0
        if Inventory.RemoveItemSlot then Inventory.RemoveItemSlot(h.src, item, 1, h.slot)
        else Inventory.RemoveItem(h.src, item, 1) end
        if (Inventory.GetItemCount(h.src, item) or 0) < before then
            MarkOrdersDirty(rid) -- an inventory-side change to the pool flags the tickets itself
            taken[#taken + 1] = { meta = h.meta }
        end
    end
    return taken
end

-- How many units of one required (item, variation) the restaurant can hand over
-- across BOTH loose stores — the cooked-items tray and staff-held singles.
-- Global for the same reason VesselCount/VesselConsume are: PlanFulfillment sits
-- ABOVE this block (the vessel store it already reads is declared here too), and a
-- local declared after it would not be in its scope.
function SingleCountMatch(rid, item, match)
    return PoolCountMatch(rid, item, match) + HeldCountMatch(rid, item, match)
end

-- Spend `count` of them, tray FIRST for the same reason VesselConsume drains it
-- first: the tray only ever holds what an inventory couldn't take, so spending it
-- first drains the fallback store instead of letting it accumulate. Returns fewer
-- than `count` only if something raced the plan — the caller treats that as a fail.
function SingleConsumeMatch(rid, item, match, count)
    local fromPool = math.min(count, PoolCountMatch(rid, item, match))
    local taken = (fromPool > 0 and PoolConsumeMatch(rid, item, match, fromPool)) or {}
    if #taken < count then
        for _, inst in ipairs(HeldConsumeMatch(rid, item, match, count - #taken)) do
            taken[#taken + 1] = inst
        end
    end
    return taken
end

local function AnnotateOrders(rid, list)
    local bagItem = BagItemName()
    -- Read-only pass: every staff-inventory search below is memoized for its duration
    -- and dropped again at the end, so nothing outside can inherit the snapshot.
    holderMemo = {}
    -- built ONCE for the whole list: it reads every on-duty employee's inventory, and
    -- each ticket is planned once per available vessel below
    local vessels = vesselPool(rid)
    for _, o in ipairs(list) do
        -- an NPC takes its food in hand — nothing has to fit in an inventory, so its
        -- ticket fills straight from the pool (see PlanFulfillment's `looseOk`)
        local loose = (IsNpcOrder and IsNpcOrder(o)) or false
        -- The unpinned plan is the truth: it already claims as many vessels as the
        -- ticket needs, so `ok` (one-tap Complete) and `ready` agree.
        local base = PlanFulfillment(rid, o, nil, nil, loose, vessels)
        -- What still has to come PACKED (everything the loose pool can't cover),
        -- flattened back into units for the coverage maths below.
        local outstanding = {}
        for _, n in ipairs(base.needs or {}) do
            for _ = 1, n.need do
                outstanding[#outstanding + 1] = { item = n.item, key = n.key, label = n.label }
            end
        end
        local opts = {}
        for _, m in ipairs(vessels) do
            -- Offer a vessel if it carries ANYTHING the ticket asked for — the picker
            -- is for choosing WHICH packages go, never for handing over an unrelated
            -- one. It no longer has to complete the order BY ITSELF: a pizza and a
            -- cake are two packages, and refusing to list either because neither is
            -- the whole order is what made that ticket unfulfillable. `covers` is what
            -- it would take off the ticket, so the panel can add a selection up and
            -- say when it's enough; `completes` is the old one-package case.
            local cov = (#outstanding > 0) and vesselCoverage(m.meta, outstanding, m.item) or {}
            if next(cov) then
                local completes = true
                for _, n in ipairs(base.needs or {}) do
                    if (cov[n.id] or 0) < n.need then completes = false break end
                end
                opts[#opts + 1] = { sig = m.sig, item = m.item, bag = (m.item == bagItem) or nil,
                                    label = GetItemLabel(m.item),
                                    -- how many identical copies of this exact packing
                                    -- are in the pool: a two-pizza ticket may be filled
                                    -- by picking the same bag twice
                                    count = m.count,
                                    covers = cov, completes = completes or nil,
                                    items = mealItemsDetail(m.meta, m.item) }
            end
        end
        local fulfill = { ok = base.ok, ready = base.ok, missing = (not base.ok) and base.missing or nil,
                          needs = base.needs }
        if #opts > 0 then fulfill.mealOptions = opts end
        o.fulfill = fulfill
        -- Who (if anyone) has CLAIMED this delivery. This list is broadcast to every
        -- client, so `server` — not the identifier — is what the phone compares against
        -- its own server id to decide whether to offer Cancel Delivery. The claim is
        -- released on disconnect, so a stale id can't linger.
        if o.driver_identifier then
            local dsrc = findPlayerByIdentifier(o.driver_identifier)
            o.driver = { name = DriverName(o), server = dsrc and tonumber(dsrc) or nil }
        else
            o.driver = nil
        end
    end
    holderMemo = nil
    return list
end


-- ─── register payload ────────────────────────────────────────────────────────

local function buildRegister(src, id)
    local r = GetRestaurant(id)
    return {
        ok           = true,
        restaurantId = id,
        label        = r.label,
        balance      = RestaurantBalance(id),
        -- the cashier's own cut, read off their RANK (the POS prints it as a subtitle)
        commission   = commissionRate(id, src),
        catalog      = (BuildPricedCatalog(id, true)),
        tickets      = AnnotateOrders(id, GetOpenOrders(id)), -- initial list; kept live thereafter by SyncOrders
        nearby       = NearbyPlayers(src, 6.0),
        receiptOk    = ItemExists(ReceiptItem()),
        theme        = r.metadata and r.metadata.theme or nil, -- skins the POS panel
    }
end

lib.callback.register("pickle_restaurants:sales:getRegister", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "sell") then return { ok = false, error = _L("no_work_here") } end
    return buildRegister(src, id)
end)

-- ─── the public projection ───────────────────────────────────────────────────
-- Strip an annotated list to what a public board shows. Same SHAPE, not a different one:
-- the screens client projects it again for its own page, and the idle register board
-- renders the ticket queue from these fields, so re-shaping here would break both.
local function publicOrders(list)
    local out = {}
    for _, o in ipairs(list or {}) do
        out[#out + 1] = {
            orderId = o.orderId, ticket = o.ticket, lines = o.lines,
            status = o.status, npc = o.npc, orderType = o.orderType,
            -- `total` STAYS. It is the priced sum of menu lines, and the menu with those
            -- prices is on the board next to this one — it discloses nothing the room
            -- can't already read. What's dropped is who ordered (`customer`), where they
            -- live (`address`) and who's driving it (`driver_*`).
            total = o.total,
            -- an NPC's patience radial is a display element, and an NPC has no privacy
            expiresIn = o.expiresIn, patience = o.patience,
            -- `ready` is the whole point of an orders board; the rest of the fulfilment
            -- plan (what's missing, which vessels could cover it) is kitchen business
            fulfill = { ready = (o.fulfill and o.fulfill.ready) == true },
        }
    end
    return out
end

-- PUBLIC idle payload for the always-on register board (modules/register). The counter
-- screen persistently shows the POS UI even when nobody's ringing anything up, so it
-- needs a seed anyone can fetch — the SAME display-safe data the public menu + orders
-- boards already show (label/theme/catalog + the open-ticket queue). It carries
-- NO balance/commission and NO nearby-players list; those live only in the perm-gated
-- buildRegister a cashier gets on interact.
-- The ticket list goes through publicOrders for the same reason: ANYONE may call this,
-- so it must not be a way to read customer names, delivery addresses, driver identifiers
-- and order totals for a restaurant you have nothing to do with. It previously returned
-- the full staff-grade annotation, which made "display-safe" true of the screen but not
-- of the payload.
lib.callback.register("pickle_restaurants:register:getPublic", function(_, d)
    local id = tonumber(d and d.id)
    local r = id and GetRestaurant(id)
    if not r then return { ok = false } end
    return {
        ok           = true,
        restaurantId = id,
        label        = r.label,
        theme        = r.metadata and r.metadata.theme or nil,
        catalog      = BuildPricedCatalog(id, true),
        tickets      = publicOrders(AnnotateOrders(id, GetOpenOrders(id))),
    }
end)

-- Read-only annotated open tickets for the corner "Tickets" widget shown in every
-- restaurant experience (cooking / management / virtual). Any staff member who
-- can work the restaurant may VIEW them (a cook without `sell` still sees whether
-- the kitchen has cleared each order) — serving stays gated on `sell` in
-- completeOrder. Fulfillment is pool-wide, so this is the same list SyncOrders
-- broadcasts; the widget stays live off that broadcast.
lib.callback.register("pickle_restaurants:sales:getTickets", function(src, d)
    local id = tonumber(d.id)
    if not id or not (HasPerm(id, src, "cook") or HasPerm(id, src, "sell")) then
        return { tickets = {} }
    end
    return { tickets = AnnotateOrders(id, GetOpenOrders(id)) }
end)

-- Seed for the customer-facing ORDERS SCREEN (modules/screens). The screen stays live off
-- the SyncOrders push, but a player who arrives between changes needs the current list
-- once — this is that one-shot. Public on purpose: an orders board is a "now preparing"
-- display anyone standing in the restaurant can read, so it is NOT perm-gated like the
-- staff widget above. Which is exactly why it returns the PROJECTED list: the claim that
-- it carries no customer identity has to be true of the payload, not just of the page
-- drawing it. It used to hand the full annotation to any caller.
-- Seed for the customer-facing MENU SCREEN (modules/screens). Public for the same reason
-- the orders board is: a menu board is a priced menu on a wall, which is the single most
-- public thing a restaurant owns. This exists because the menu was removed from the world
-- sync payload — it was shipping every restaurant's whole catalog to every player when only
-- a board ever read it (see BuildClientRestaurant). Fetched by the board that paints it.
lib.callback.register("pickle_restaurants:screens:getMenu", function(_, d)
    local id = tonumber(d and d.id)
    if not id or not GetRestaurant(id) then return { menu = {} } end
    return { menu = BuildMenuBoard(id) }
end)

lib.callback.register("pickle_restaurants:screens:getOrders", function(src, d)
    local id = tonumber(d.id)
    if not id or not GetRestaurant(id) then return { orders = {} } end
    return { orders = publicOrders(AnnotateOrders(id, GetOpenOrders(id))) }
end)

-- Push the fresh open-ticket list to every client. Each client applies it if it has
-- THIS restaurant's register open (checked client-side). This is the ONE and ONLY
-- path that mutates an open register's ticket list: create/complete/cancel each call
-- it after their change, so every open register — the acting cashier's and any
-- co-worker's — stays live without re-sending the whole panel (catalog, etc.).
-- Because it's the only path AND FiveM delivers these events reliably and in order,
-- the last list sent is always the last list shown — it can never go stale. (The
-- previous bug was a SECOND update path: the acting cashier ALSO refreshed straight
-- from its callback reply, which could race the broadcast and revive a cancelled
-- ticket. The callbacks now return ok/error ONLY and never touch the list.)
-- ONE TICKET LIST, THREE AUDIENCES. This used to go to `-1`: the full staff-grade list,
-- to every player on the server, up to once per 750ms per busy restaurant. Two problems,
-- and the second is the worse one.
--
-- (1) Cost. It is the largest payload the resource sends repeatedly — every open ticket
--     with its lines, mods, totals and fulfilment plan — multiplied by the whole player
--     count, forever, while anyone is cooking.
-- (2) DISCLOSURE. It carried `customer` (character name), `address` (a player's delivery
--     address), `driver_identifier` (a raw license/citizenid) and per-order spend to
--     everybody. The projection that hides those was applied CLIENT-side
--     (modules/screens' projectOrders), which protects nothing: the data was already on
--     every machine. The boundary the callbacks above draw so carefully — getTickets is
--     perm-gated, screens:getOrders is public "because it carries no customer identity" —
--     was simply not drawn on the broadcast.
--
-- So the audience is resolved here, and each member gets the least-privileged list that
-- still works for them. The sets are built disjoint, most-privileged first, so nobody
-- receives two lists and no client has to reconcile them:
--   STAFF    — full list. Anyone with cook/sell who is AT the restaurant, plus whoever
--              is clocked in (the phone KDS is the one staff surface that isn't).
--   PARTY    — a customer or claimed driver gets ONLY the tickets that are theirs.
--   BYSTANDER— everyone else near the restaurant: the same list with every private field
--              removed. That is what the menu/orders boards and the idle register screen
--              paint, and it is all they ever displayed.
-- Anyone further away than a board is readable from gets nothing, because there is
-- nothing they could be looking at. Arriving later is covered by the boards' existing
-- one-shot seeds (screens:getOrders / register:getPublic).

-- The tickets belonging to one party member — the orders they placed, or the delivery
-- they claimed. A customer tracking their order in the phone app needs their own ticket
-- and has no business receiving the restaurant's queue. `own` is the orderId set from
-- OrderPartyIdentifiers; the customer identifier itself is never put on a client.
local function ownOrders(list, own)
    local out = {}
    for _, o in ipairs(list or {}) do
        if own[o.orderId] then out[#out + 1] = o end
    end
    return out
end

function SyncOrders(id)
    local full = AnnotateOrders(id, GetOpenOrders(id))
    local sent = {} -- [src] = true, so the disjoint rule is enforced not just intended

    -- STAFF: at the restaurant with perms, or clocked in from anywhere
    local candidates = PlayersNearRestaurant(id, ScopeRadius.BOARD)
    local staff = {}
    for _, src in ipairs(candidates) do
        if HasPerm(id, src, "cook") or HasPerm(id, src, "sell") then
            staff[#staff + 1] = src; sent[src] = true
        end
    end
    for _, src in ipairs(ClockedInSources and ClockedInSources(id) or {}) do
        if not sent[src] then staff[#staff + 1] = src; sent[src] = true end
    end
    SendTo(staff, "pickle_restaurants:sales:orders", id, full)

    -- PARTY: each customer/driver with a live ticket, their own only. Walks the tickets
    -- (a handful) rather than the player list.
    for ident, own in pairs(OrderPartyIdentifiers(id)) do
        local src = ResolveSourceForIdentifier and ResolveSourceForIdentifier(ident) or nil
        if src and not sent[src] then
            sent[src] = true
            TriggerClientEvent("pickle_restaurants:sales:orders", src, id, ownOrders(full, own))
        end
    end

    -- BYSTANDERS: the boards and the idle register screen
    local pub = nil
    for _, src in ipairs(candidates) do
        if not sent[src] then
            pub = pub or publicOrders(full)
            TriggerClientEvent("pickle_restaurants:sales:orders", src, id, pub)
        end
    end
end

-- ─── order helpers ───────────────────────────────────────────────────────────

function findPlayerByIdentifier(identifier)   -- forward-declared local, see above
    for _, p in ipairs(GetPlayers()) do
        p = tonumber(p)
        if GetIdentifier(p) == identifier then return p end
    end
end

local function playersNear(a, b, dist)
    local pa, pb = GetPlayerPed(a), GetPlayerPed(b)
    if pa == 0 or pb == 0 then return false end
    return #(GetEntityCoords(pa) - GetEntityCoords(pb)) <= dist
end

-- A compact modifier string for a line ("+Cheese, no Lettuce"), or "" for none.
local function modSummary(mods)
    if type(mods) ~= "table" or #mods == 0 then return "" end
    local parts = {}
    for _, m in ipairs(mods) do
        local label = tostring(m.label or m.id or "?")
        parts[#parts + 1] = (m.removed and _L("order_mod_removed", label) or _L("order_mod_added", label))
    end
    return table.concat(parts, ", ")
end

-- One readable "2× Burger (+Cheese), 1× Fries" line for ledger rows & receipt metadata.
local function orderSummary(lines)
    local parts = {}
    for _, l in ipairs(lines) do
        local s = _L("order_qty_line", l.qty, l.label)
        local m = modSummary(l.mods)
        if m ~= "" then s = s .. " (" .. m .. ")" end
        parts[#parts + 1] = s
    end
    return table.concat(parts, ", ")
end

-- Resolve an untrusted cart ({ key, qty, mods }) against the restaurant's LIVE
-- priced catalog into validated, priced order lines + the rounded total. Shared by
-- the staff register (createOrder) and the self-service kiosk (kioskOrder) so both
-- price, clamp quantities and record/charge modifiers identically. Only real
-- catalog entries, allowed modifiers and 1..10 quantities survive. Returns
-- `lines, total` on success, or `nil, nil, errorMessage`.
-- Resolve a customer's selected modifier ids against a sellable entry's allowed set
-- (the NUI is untrusted): record only real additions (a non-default modifier that's
-- on → +price) and removals (a default that's off), enforcing group single-choice.
-- Mods are ticket instructions + pricing; the kitchen match is item-only. Returns the
-- recorded mod list + the price EXTRA the additions add on top of the base. Shared by
-- the à la carte path so validation is identical everywhere.
-- The `variant` an order line carries: the flavor modifier the customer picked
-- (`modVariant`), else the sellable's own variant. A drink MUST pin a flavor, so if
-- the cart somehow sent none, default to the sellable's first flavor — a variant-less
-- drink line ("d:") matches no cooked flavor and would leave the order unfulfillable.
function DrinkLineVariant(e, modVariant)
    if modVariant and modVariant ~= "" then return modVariant end
    if e.kind == "drink" then
        for _, m in ipairs(e.modifiers or {}) do
            if m.variant and m.variant ~= "" then return m.variant end
        end
    end
    return e.variant or ""
end

local function resolveLineModifiers(e, selMods)
    local mods, extra, variant = {}, 0, nil
    if type(e.modifiers) ~= "table" then return mods, extra, variant end
    local sel, groupTaken = {}, {}
    if type(selMods) == "table" then
        for _, mid in ipairs(selMods) do sel[tostring(mid)] = true end
    end
    for _, m in ipairs(e.modifiers) do
        local isDefault = m.default == true or m.default == 1
        local on = sel[tostring(m.id)] == true
        -- a grouped modifier is single-choice — only the first selected in its group
        -- counts (the NUI enforces this; re-enforced here)
        if on and m.group and groupTaken[m.group] then on = false end
        if m.variant and m.variant ~= "" then
            -- a VARIANT modifier (a drink flavor): the selected one is the line's menu
            -- IDENTITY (threaded into `variant` by the callers, used for kitchen matching)
            -- — it always prints as a chip and is never a "removed" default
            if on then
                if m.group then groupTaken[m.group] = true end
                variant = tostring(m.variant)
                local price = math.max(0, math.floor(tonumber(m.price) or 0))
                extra = extra + price
                local label = m.group and (tostring(m.group) .. ": " .. tostring(m.label)) or m.label
                mods[#mods + 1] = { id = m.id, label = label, price = price, added = true,
                                    image = m.image, color = m.color }
            end
        elseif on and not isDefault then
            if m.group then groupTaken[m.group] = true end
            local price = math.max(0, math.floor(tonumber(m.price) or 0))
            extra = extra + price
            local label = m.group and (tostring(m.group) .. ": " .. tostring(m.label)) or m.label
            -- carry the modifier's icon (item image, or flavor colour swatch) so the
            -- kitchen ticket can render it as an image, not just text
            mods[#mods + 1] = { id = m.id, label = label, price = price, added = true,
                                image = m.image, color = m.color }
        elseif isDefault and not on then
            mods[#mods + 1] = { id = m.id, label = m.label, removed = true,
                                image = m.image, color = m.color }
        end
    end
    return mods, extra, variant
end

local function resolveOrderLines(id, cart)
    -- Re-derive the priced catalog server-side; the cart is only keys + counts.
    local priced = select(1, BuildPricedCatalog(id, true))
    local byKey = {}
    for _, e in ipairs(priced) do byKey[e.key] = e end
    local lines, total = {}, 0
    for _, c in ipairs(type(cart) == "table" and cart or {}) do
        local e = type(c) == "table" and byKey[c.key] or nil
        if not e then return nil, nil, _L("order_not_priced") end
        local qty = math.max(1, math.min(10, math.floor(tonumber(c.qty) or 1)))
        local mods, extra, variant = resolveLineModifiers(e, c.mods)
        local unit = e.price + extra
        local lvar = DrinkLineVariant(e, variant)
        lines[#lines + 1] = { item = e.item, variant = lvar, label = e.label,
                              image = LineImage(e.kind, lvar, e.image, e.item),
                              price = unit, qty = qty, kind = e.kind,
                              mods = (#mods > 0) and mods or nil }
        total = total + unit * qty
    end
    if #lines == 0 then return nil, nil, _L("order_nothing_selected") end
    return lines, RoundMoney(total)
end

-- ─── how the customer pays ───────────────────────────────────────────────────
--
-- CASH OR CARD, at the register and at the kiosk alike. Both used to be cash-only,
-- which is a rule about a WALLET dressed up as a rule about a counter: a customer
-- standing at a till with money in the bank could not buy a burger, while the same
-- customer ordering the same burger on the phone could. Only the phone knew about
-- `bank`, and it hardcoded it.
--
-- The wire value is untrusted, so it is normalised to exactly two answers here and
-- nowhere else: the bridge's cash currency is "money", the account is "bank", and
-- `paid_account` (what a REFUND pays back into) is derived from the same call so the
-- two can never disagree.
local function resolvePayment(d)
    local bank = (d and d.payment) == "bank"
    return bank and "bank" or "money", bank and "bank" or "cash"
end

-- The refusal for an empty wallet names WHICH wallet, since the fix differs.
local function notEnough(account)
    return (account == "bank") and _L("not_enough_bank") or _L("not_enough_cash")
end

-- ─── create order ────────────────────────────────────────────────────────────

lib.callback.register("pickle_restaurants:sales:createOrder", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "sell") then return { ok = false, error = _L("no_work_here") } end
    local r = GetRestaurant(id); if not r then return { ok = false } end

    -- Price the untrusted cart into validated order lines (shared with the kiosk).
    local lines, total, lerr = resolveOrderLines(id, d.cart)
    if not lines then return { ok = false, error = lerr } end
    local account, paidAccount = resolvePayment(d)

    -- Resolve the paying customer: 0/nil = the cashier buys their own meal.
    local customerSrc = src
    local target = tonumber(d.customer) or 0
    if target ~= 0 then
        local near = false
        for _, p in ipairs(NearbyPlayers(src, 6.0)) do
            if p.id == target then near = true break end
        end
        if not near then return { ok = false, error = _L("order_customer_missing") } end
        customerSrc = target
        -- The customer confirms the charge on their screen. The client handler
        -- ALWAYS answers (decline button, 30s countdown, view-close watcher),
        -- and pcall covers a mid-await disconnect.
        local okc, accepted = pcall(lib.callback.await, "pickle_restaurants:sales:confirmCharge", customerSrc, {
            restaurant = r.label,
            cashier    = GetPlayerCharacterName(src),
            lines      = lines,
            total      = total,
            payment    = paidAccount, -- the customer is told WHICH wallet they're approving
            theme      = r.metadata and r.metadata.theme or nil, -- skins the customer receipt
        })
        if not okc or accepted ~= true then return { ok = false, error = _L("order_declined") } end
    end

    -- Charge (re-checked after the confirm — money may have moved meanwhile).
    if GetMoney(customerSrc, account) < total then return { ok = false, error = notEnough(account) } end

    -- Create the ticket, charge, and do the bookkeeping under ONE guard. The
    -- client's register callback has NO timeout — a thrown error anywhere here
    -- would hang the POS forever with the money already gone ("charged, no
    -- ticket"). So: create the row FIRST (a create failure never takes money),
    -- then charge, then best-effort side-effects — and whatever happens, log the
    -- real error and fall through to returning a fresh register below.
    local customerId = GetIdentifier(customerSrc)
    local ok, err = pcall(function()
        local order = CreateOrder(id, {
            customer_identifier = customerId,
            customer_name       = GetPlayerCharacterName(customerSrc),
            cashier_identifier  = GetIdentifier(src),
            lines               = lines,
            total               = total,
            paid_account        = paidAccount,
        })

        RemoveMoney(customerSrc, total, account)
        AdjustBalance(id, total)

        local summary = orderSummary(lines)
        AddLedger(id, "sale", total, _L("ledger_sale", order.ticket, summary):sub(1, 255), customerId)
        payCommission(id, src, total, order.ticket, customerId)

        -- Hand the customer their receipt (metadata carries the ticket, so the same
        -- item verifies the right order at completion). Skipped gracefully when the
        -- receipt item isn't installed — the ticket alone still drives fulfillment.
        if ItemExists(ReceiptItem()) then
            Inventory.AddItem(customerSrc, ReceiptItem(), 1, {
                order_id      = order.id,
                restaurant_id = id,
                ticket        = order.ticket,
                description   = _L("receipt_description", r.label, order.ticket, summary, GetCurrencyString(total)),
            })
        end

        ShowNotification(src, _L("order_placed", order.ticket))
        if customerSrc ~= src then ShowNotification(customerSrc, _L("order_charged", order.ticket, GetCurrencyString(total))) end
    end)
    if not ok then
        print(("[pickle_restaurants] createOrder failed: %s"):format(tostring(err)))
        return { ok = false, error = _L("order_failed") }
    end

    -- Broadcast the new ticket to every open register (coworkers'); the acting
    -- cashier also gets the fresh list back in THIS response (reliable, no
    -- dependence on the broadcast round-trip).
    SyncOrders(id)
    -- Reply ok ONLY — the ticket list refreshes via the SyncOrders broadcast above
    -- (which the acting cashier receives too). The reply never carries the list, so
    -- there is no second, racing update path.
    return { ok = true }
end)

-- ─── self-service kiosk ──────────────────────────────────────────────────────
-- A kiosk lets a CUSTOMER order without a cashier: they open the same priced menu
-- the register sells, build a cart, and pay for their OWN order. It still becomes a
-- normal kitchen ticket that staff cook and hand over at the register exactly like a
-- cashier-rung order — the kitchen/fulfillment flow is unchanged. No `sell`
-- permission (the whole point is ordering unattended); the trust boundary is that
-- the ordering player must physically be at one of the restaurant's kiosk props.

local KIOSK_REACH = 4.0
local function PlayerAtKiosk(src, rid)
    local ped = GetPlayerPed(src)
    if ped == 0 then return false end
    local c = GetEntityCoords(ped)
    for _, p in pairs(PropCache) do
        if p.restaurant_id == rid and (p.prop_type == "kiosk" or p.prop_type == "kiosk_ground") then
            if #(c - vector3(p.x + 0.0, p.y + 0.0, p.z + 0.0)) <= KIOSK_REACH then return true end
        end
    end
    return false
end

-- The image + crop the kiosk screen brands with, resolved exactly like the render
-- target driver (modules/rendertarget `specForTarget`): the `kiosk` per-texture
-- override when set, else the restaurant's shared brand image. The kiosk DUI paints
-- this as a full-screen cover that slides up to reveal the menu on open (so the
-- brand the idle screen was showing appears to stay, then lift away), and back down
-- on exit. nil → no brand configured (the DUI covers with solid black, matching the
-- idle screen's `blackDefault`).
local function kioskBrandImage(r)
    local meta = r.metadata or {}
    local o = meta.brand_images and meta.brand_images["kiosk"]
    if type(o) == "table" and o.url and o.url ~= "" then return { url = o.url, crop = o.crop } end
    if type(o) == "string" and o ~= "" then return { url = o } end
    if meta.brand_image and meta.brand_image ~= "" then return { url = meta.brand_image } end
    return nil
end

-- The kiosk's menu payload — the same priced/enabled catalog the register sells,
-- plus the restaurant theme so the order NUI is skinned like every scoped panel.
lib.callback.register("pickle_restaurants:sales:getKiosk", function(src, d)
    local id = tonumber(d.id)
    local r = GetRestaurant(id); if not r then return { ok = false, error = _L("order_failed") } end
    return {
        ok           = true,
        restaurantId = id,
        label        = r.label,
        catalog      = (BuildPricedCatalog(id, true)),
        theme        = r.metadata and r.metadata.theme or nil,
        brand        = kioskBrandImage(r),    -- full-screen cover for the open/close slide
    }
end)

-- Place a self-service order. The customer pays for their own order (there is no
-- cashier to charge someone else) and receives the receipt; the order enters the
-- kitchen queue as an ordinary ticket. No commission is paid at order time (no
-- serving employee yet) — the restaurant keeps the full sale, and staff fulfil the
-- ticket at the register like any other.
lib.callback.register("pickle_restaurants:sales:kioskOrder", function(src, d)
    local id = tonumber(d.id)
    local r = GetRestaurant(id); if not r then return { ok = false, error = _L("order_failed") } end
    if not PlayerAtKiosk(src, id) then return { ok = false, error = _L("kiosk_too_far") } end

    local lines, total, lerr = resolveOrderLines(id, d.cart)
    if not lines then return { ok = false, error = lerr } end
    local account, paidAccount = resolvePayment(d)

    -- Re-check funds here; the real charge is inside the guarded block below.
    if GetMoney(src, account) < total then return { ok = false, error = notEnough(account) } end

    -- Create the row FIRST (a create failure never takes money), then charge, then
    -- best-effort side-effects — mirroring createOrder so a throw can never leave
    -- "charged, no ticket". The customer is their own cashier (self-service).
    local customerId = GetIdentifier(src)
    local ticketNo
    local ok, err = pcall(function()
        local order = CreateOrder(id, {
            customer_identifier = customerId,
            customer_name       = GetPlayerCharacterName(src),
            cashier_identifier  = customerId,
            lines               = lines,
            total               = total,
            paid_account        = paidAccount,
        })
        ticketNo = order.ticket

        RemoveMoney(src, total, account)
        AdjustBalance(id, total)

        local summary = orderSummary(lines)
        AddLedger(id, "sale", total, _L("ledger_sale_kiosk", order.ticket, summary):sub(1, 255), customerId)

        -- Hand the customer their receipt (metadata carries the ticket, so the same
        -- item verifies the right order at completion). Skipped gracefully when the
        -- receipt item isn't installed — the ticket alone still drives fulfillment.
        if ItemExists(ReceiptItem()) then
            Inventory.AddItem(src, ReceiptItem(), 1, {
                order_id      = order.id,
                restaurant_id = id,
                ticket        = order.ticket,
                description   = _L("receipt_description", r.label, order.ticket, summary, GetCurrencyString(total)),
            })
        end

        ShowNotification(src, _L("order_placed", order.ticket))
    end)
    if not ok then
        print(("[pickle_restaurants] kioskOrder failed: %s"):format(tostring(err)))
        return { ok = false, error = _L("order_failed") }
    end

    -- Broadcast the new ticket to every open register / Tickets widget.
    SyncOrders(id)
    return { ok = true, ticket = ticketNo }
end)

-- ─── phone companion: remote order (delivery / pickup / dine-in) ──────────────
-- Placed from the companion phone app. The customer pays for their own order from
-- anywhere; the ticket enters the kitchen queue like a kiosk order (so order-ahead
-- food queues before arrival). Applies an active promo discount and an optional
-- loyalty redemption. order_type / scheduled / address persist on the additive
-- phone columns and ride the GetOpenOrders projection into the KDS + tracking.
DeliveryTargets = {} -- [orderId] = { x, y, z } customer drop, for the driver blip

-- The drop point is ALSO persisted on the order row (dest_x / dest_y). This table is
-- the hot read path; the columns are what survives a restart. Called once at boot
-- from modules/phone's ready thread.
-- z is not persisted: nothing consumes it (SetNewWaypoint is 2D and the driver's
-- "you've arrived" check is a vector2 distance), so a rehydrated target carries 0.0.
function RehydrateDeliveryTargets()
    local rows = MySQL.query.await([[
        SELECT id, dest_x, dest_y FROM `pickle_restaurant_orders`
         WHERE status = 'open' AND order_type = 'delivery'
           AND dest_x IS NOT NULL AND dest_y IS NOT NULL
    ]]) or {}
    local n = 0
    for _, row in ipairs(rows) do
        DeliveryTargets[row.id] = { x = row.dest_x + 0.0, y = row.dest_y + 0.0, z = 0.0 }
        n = n + 1
    end
    if n > 0 then
        print(("[pickle_restaurants] restored %d in-flight delivery destination(s)"):format(n))
    end
    return n
end

lib.callback.register("pickle_restaurants:phone:placeOrder", function(src, d)
    local id = tonumber(d.id)
    local r = GetRestaurant(id); if not r then return { ok = false, error = _L("order_failed") } end

    local lines, total, lerr = resolveOrderLines(id, d.cart)
    if not lines then return { ok = false, error = lerr } end

    local orderType = d.orderType
    if orderType ~= "delivery" and orderType ~= "dine_in" then orderType = "pickup" end
    local scheduled = d.scheduled and tostring(d.scheduled):sub(1, 20) or nil
    local address   = d.address and tostring(d.address):sub(1, 160) or nil

    -- Delivery drop point, from the client-injected ped coords. Sanity-bounded to the
    -- map: the NUI is untrusted, and a junk coordinate would persist as a permanent
    -- bad pin / waypoint. Nil for a non-delivery ticket.
    local destX, destY, destZ
    if orderType == "delivery" and type(d.coords) == "table" then
        local cx, cy, cz = tonumber(d.coords.x), tonumber(d.coords.y), tonumber(d.coords.z)
        if cx and cy and math.abs(cx) <= 10000 and math.abs(cy) <= 10000 then
            destX, destY, destZ = cx + 0.0, cy + 0.0, (cz or 0) + 0.0
        end
    end

    -- Promo discount (percent off the whole cart). Globals from modules/phone.
    local promo = ActivePromo and ActivePromo(id) or nil
    local discountPct = promo and promo.percent or 0

    -- Optional loyalty redemption: a free item = knock the cheapest line's unit
    -- price off the total. Punches are consumed ATOMICALLY only after the charge
    -- succeeds, so a failed order can never burn a redemption.
    local customerId = GetIdentifier(src)
    local redeemAmount, didRedeem = 0, false
    if d.redeem and PhoneCanRedeem and PhoneCanRedeem(id, customerId) then
        local cheapest
        for _, l in ipairs(lines) do
            if not cheapest or l.price < cheapest then cheapest = l.price end
        end
        redeemAmount, didRedeem = cheapest or 0, true
    end

    local finalTotal = RoundMoney(math.max(0, (total - redeemAmount) * (100 - discountPct) / 100))
    -- A phone order is an ONLINE/card payment: it charges BANK, not cash.
    -- (The in-person register + kiosk paths stay cash.)
    if GetMoney(src, "bank") < finalTotal then return { ok = false, error = _L("not_enough_bank") } end

    local ticketNo, orderId
    local ok, err = pcall(function()
        local order = CreateOrder(id, {
            customer_identifier = customerId,
            customer_name       = GetPlayerCharacterName(src),
            cashier_identifier  = customerId,
            lines               = lines,
            total               = finalTotal,
        })
        ticketNo, orderId = order.ticket, order.id
        -- Carry the phone fields on the cache row so GetOpenOrders projects them.
        order.order_type    = orderType
        order.scheduled_for = scheduled
        order.address       = address
        order.paid_account  = "bank"
        -- Recorded so a cancellation can hand the burned punch-card redemption back
        -- (RefundOrder → PhoneRestoreRedeem). Without this the order row has no idea
        -- a free item was spent on it and the customer eats the loss on a cancel.
        order.redeemed      = didRedeem and 1 or 0
        order.dest_x        = destX
        order.dest_y        = destY

        if finalTotal > 0 then RemoveMoney(src, finalTotal, "bank") end
        AdjustBalance(id, finalTotal)

        -- The client supplies its number on phones that expose it client-side
        -- (lb-phone); Quasar only offers GetCurrentPhoneNumber(src), so fall back to
        -- the bridge's server-side lookup rather than storing a NULL number.
        local phoneNumber = d.phone
        if (phoneNumber == nil or phoneNumber == "") and PhoneAppNumber then
            phoneNumber = PhoneAppNumber(src)
        end
        -- Awaited: a phone:home landing before this commits would read order_type NULL
        -- and render a delivery as a pickup until the next refresh.
        MySQL.update.await("UPDATE `pickle_restaurant_orders` SET order_type = ?, scheduled_for = ?, address = ?, phone_number = ?, paid_account = 'bank', redeemed = ?, dest_x = ?, dest_y = ? WHERE id = ?",
            { orderType, scheduled, address, phoneNumber, order.redeemed, destX, destY, order.id })

        local summary = orderSummary(lines)
        local tag = (orderType == "delivery") and _L("order_type_delivery")
            or (orderType == "dine_in") and _L("order_type_dine_in") or _L("order_type_pickup")
        AddLedger(id, "sale", finalTotal, _L("ledger_sale_tagged", order.ticket, summary, tag):sub(1, 255), customerId)

        if ItemExists(ReceiptItem()) then
            Inventory.AddItem(src, ReceiptItem(), 1, {
                order_id = order.id, restaurant_id = id, ticket = order.ticket,
                description = _L("receipt_description", r.label, order.ticket, summary, GetCurrencyString(finalTotal)),
            })
        end

        if didRedeem and PhoneCommitRedeem then PhoneCommitRedeem(id, customerId) end
        if destX then
            DeliveryTargets[order.id] = { x = destX, y = destY, z = destZ }
        end
        ShowNotification(src, _L("order_placed", order.ticket))
    end)
    if not ok then
        print(("[pickle_restaurants] phone placeOrder failed: %s"):format(tostring(err)))
        return { ok = false, error = _L("order_failed") }
    end

    SyncOrders(id)
    return { ok = true, ticket = ticketNo, orderId = orderId, total = finalTotal, discount = discountPct, redeemed = didRedeem, orderType = orderType }
end)

-- Whether a ticket can be fulfilled right now (for the tracking UI). The unpinned plan
-- already claims whatever packed vessels the order needs, so this is the same answer
-- the register shows — a bagged order reads as ready, not as still cooking.
function OrderReadyForPickup(rid, orderId)
    local o = OrderCache[rid] and OrderCache[rid][orderId]
    if not o then return false end
    local plan = PlanFulfillment(rid, o, nil, nil, (IsNpcOrder and IsNpcOrder(o)) or false)
    return plan and plan.ok or false
end

-- The claimed driver's display name, for the "taken by X" copy on other staff phones.
function DriverName(o)
    if not o or not o.driver_identifier then return nil end
    if o.driver_name then return o.driver_name end
    local src = findPlayerByIdentifier(o.driver_identifier)
    return src and GetPlayerCharacterName and GetPlayerCharacterName(src) or nil
end

-- Staff marks a delivery ticket "out for delivery": the customer's phone gets a
-- live driver blip fed by the driver client's ping loop (modules/phone/client).
lib.callback.register("pickle_restaurants:phone:startDelivery", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "sell") then return { ok = false, error = _L("no_work_here") } end
    local o = OrderCache[id] and OrderCache[id][tonumber(d.orderId)]
    if not o then return { ok = false, error = _L("order_not_open") } end
    -- ONE driver per delivery. The run is CLAIMED by whoever accepts it first, and
    -- stays claimed until they cancel, complete it, or leave the server — so a second
    -- staff member opening the same ticket can't take it out from under them.
    local me = GetIdentifier(src)
    if o.driver_identifier and o.driver_identifier ~= me then
        return { ok = false, error = _L("delivery_taken", DriverName(o) or "?") }
    end
    local customerSrc = findPlayerByIdentifier(o.customer_identifier)
    -- Record WHO is driving this ticket. Nothing used to, so the driverPing net event
    -- had nothing to validate against and any client could puppet any customer's blip.
    -- Stored by identifier (survives a reconnect) on the in-memory cache row only —
    -- the assignment is transient, like o.busy, and dies with the ticket.
    o.driver_identifier = me
    o.driver_name = GetPlayerCharacterName and GetPlayerCharacterName(src) or nil
    -- ALWAYS start the DRIVER's ping/route loop. This used to live inside the
    -- `customerSrc` guard below, which meant a customer who happened to be offline /
    -- loading / reconnecting at this exact instant permanently killed the driver's
    -- telemetry for the life of the ticket (the loop is only ever started here).
    -- The loop pings the SERVER, which relays only if the customer is around — so
    -- running it while they're away costs nothing and recovers the moment they're back.
    TriggerClientEvent("pickle_restaurants:phone:beginDriving", src,
        { orderId = o.id, rid = id, target = DeliveryTargets[o.id], customer = customerSrc })
    if customerSrc then
        TriggerClientEvent("pickle_restaurants:phone:driverAssigned", customerSrc, { orderId = o.id, driver = src })
        -- This is the ONLY "on the way" state — completion pushes delivered/collected.
        if PhoneNotify then
            local r = GetRestaurant(id)
            PhoneNotify(customerSrc, _L("phone_order_delivering_title"),
                _L("phone_order_delivering_body", r and (r.label or r.name) or _L("phone_order_fallback"), tostring(o.ticket or "?")))
        end
    end
    -- Re-broadcast, or NOTHING tells the phones the ticket is now claimed: the Work
    -- screen's list is fed by this broadcast, so without it the button never leaves
    -- "Accept Delivery" — for the driver who just took it AND for everyone else, who
    -- can then all try to accept a run that is already gone.
    SyncOrders(id)
    return { ok = true }
end)

-- ─── driver telemetry relays (position + route) ───────────────────────────────
-- Both are INBOUND net events from an untrusted client, so both go through the same
-- gate: the sender must be the ASSIGNED driver of a still-open delivery ticket, the
-- coordinates must be real numbers inside the map, and a sender can only push so
-- often. Anything that fails is dropped silently (a griefer gets no feedback).
--
-- Floor between accepted pushes from ONE source, per event. The driver client pings
-- position every DRIVER_PING_MS (3s) and re-sends its route far more slowly, so
-- these only ever bite on a spammer. TUNE IN-GAME.
local DRIVER_PING_MIN_MS = 1500

local DriverRate = {}   -- [src] = { ping = lastMs }

-- LAST-KNOWN driver telemetry per order. Transient (like o.busy / DeliveryTargets),
-- module-global so modules/phone can read it. The relays below are fire-and-forget
-- broadcasts, so a customer who opens (or RE-opens) a ticket between two pushes had
-- nothing to draw — and the route in particular only re-sends every ROUTE.refresh
-- (12s) or on deviation, so a driver holding a steady course left the polyline blank
-- indefinitely. This is what phone:trackOrder seeds the in-app map from.
-- [orderId] = { x, y, points, at }
DriverTelemetry = {}

local function driverThrottled(src, key, minMs)
    local now = GetGameTimer()
    local seen = DriverRate[src]
    if not seen then seen = {}; DriverRate[src] = seen end
    if seen[key] and now - seen[key] < minMs then return true end
    seen[key] = now
    return false
end

AddEventHandler("playerDropped", function() DriverRate[source] = nil end)

local function sane(v)
    v = tonumber(v)
    if not v or v ~= v then return nil end            -- nil / NaN
    if math.abs(v) > 10000 then return nil end        -- off-map
    return v + 0.0
end

-- The open delivery ticket `src` is the assigned driver of, else nil. Every
-- rejection is a SILENT drop, by design: this gate is what stops anyone spoofing a
-- driver ping for someone else's ticket, so it must never explain itself to the
-- caller.
local function driverOrderFor(src, data)
    if type(data) ~= "table" then return nil end
    local rid, oid = tonumber(data.rid), tonumber(data.orderId)
    if not rid or not oid then return nil end
    local o = OrderCache[rid] and OrderCache[rid][oid]
    if not o then return nil end                       -- closed, or wrong restaurant id
    if o.status ~= "open" then return nil end
    -- No driver assigned = startDelivery was never called for this ticket, so there
    -- is nothing legitimate to relay.
    if not o.driver_identifier then return nil end
    if o.driver_identifier ~= GetIdentifier(src) then return nil end
    return o
end

-- Driver position → the waiting customer (native blip + the in-app map marker).
RegisterNetEvent("pickle_restaurants:phone:driverPing", function(data)
    local src = source
    local o = driverOrderFor(src, data)
    if not o then return end
    local x, y = sane(data.x), sane(data.y)
    if not x or not y then return end
    if driverThrottled(src, "ping", DRIVER_PING_MIN_MS) then
        return
    end
    -- Cached BEFORE the customer-online check: the whole point of the seed cache is
    -- to have something to hand a customer who wasn't listening when this arrived.
    local t = DriverTelemetry[o.id]
    if not t then t = {}; DriverTelemetry[o.id] = t end
    t.x, t.y, t.at = x, y, os.time()
    local customerSrc = findPlayerByIdentifier(o.customer_identifier)
    if customerSrc then
        TriggerClientEvent("pickle_restaurants:phone:driverCoords", customerSrc, { orderId = o.id, x = x, y = y })
    end
end)

-- Release a claim: the run goes back on the board for anyone to accept. Used by the
-- driver's own cancel and by the disconnect sweep — never by another employee.
function ReleaseDelivery(rid, o, reason)
    o.driver_identifier, o.driver_name = nil, nil
    DriverTelemetry[o.id] = nil
    local customerSrc = findPlayerByIdentifier(o.customer_identifier)
    if customerSrc then
        -- Drop the world blip + the in-app marker; the ticket falls back to
        -- "preparing", since nobody is carrying it any more.
        TriggerClientEvent("pickle_restaurants:phone:driverReleased", customerSrc, { orderId = o.id })
        if PhoneNotify then
            local r = GetRestaurant(rid)
            PhoneNotify(customerSrc, _L("phone_order_delayed_title"),
                _L("phone_order_delayed_body", r and (r.label or r.name) or _L("phone_order_fallback"),
                   tostring(o.ticket or "?")))
        end
    end
    SyncOrders(rid)
end

-- Give a delivery back. ONLY the driver holding the claim may do this — not the boss,
-- not another employee, not an admin. A run stuck on an AFK driver is released by the
-- disconnect sweep below instead, which is the only other way a claim ends early.
lib.callback.register("pickle_restaurants:phone:cancelDelivery", function(src, d)
    local id = tonumber(d and d.id)
    local o = id and OrderCache[id] and OrderCache[id][tonumber(d.orderId)]
    if not o then return { ok = false, error = _L("order_not_open") } end
    if not o.driver_identifier then return { ok = false, error = _L("delivery_not_started") } end
    if o.driver_identifier ~= GetIdentifier(src) then
        return { ok = false, error = _L("delivery_not_yours", DriverName(o) or "?") }
    end
    ReleaseDelivery(id, o, "driver cancelled")
    TriggerClientEvent("pickle_restaurants:phone:endDriving", src, { orderId = o.id })
    return { ok = true }
end)

-- Re-set the GPS waypoint to the drop-off. `startDelivery` already sets it on accept,
-- but a waypoint is a single global slot the player (or any other script) can clear or
-- overwrite at any time — so the driver needs a way to get it BACK without giving the
-- run up and re-accepting it. Gated to the claim holder, and it returns the
-- coordinates rather than setting anything: only the driver's own client can do that.
lib.callback.register("pickle_restaurants:phone:deliveryTarget", function(src, d)
    local id = tonumber(d and d.id)
    local o = id and OrderCache[id] and OrderCache[id][tonumber(d.orderId)]
    if not o or o.status ~= "open" then return { ok = false, error = _L("order_not_open") } end
    if o.driver_identifier ~= GetIdentifier(src) then
        return { ok = false, error = _L("delivery_not_yours", DriverName(o) or "?") }
    end
    local t = DeliveryTargets[o.id]
    if not t or not t.x then return { ok = false, error = _L("delivery_no_target") } end
    return { ok = true, x = t.x, y = t.y, z = t.z, ticket = o.ticket }
end)

-- A driver who leaves the server can't finish the run, and the ticket would otherwise
-- sit claimed forever with nobody able to take it (only the holder may cancel). Sweep
-- every open delivery they were carrying and put it back on the board.
AddEventHandler("playerDropped", function()
    local gone = GetIdentifier(source)
    if not gone then return end
    for rid, orders in pairs(OrderCache) do
        for _, o in pairs(orders) do
            if o.status == "open" and o.driver_identifier == gone then
                ReleaseDelivery(rid, o, "driver disconnected")
            end
        end
    end
end)

-- ─── in-app map SEED ─────────────────────────────────────────────────────────
-- The map used to be live-events-only, so a customer who opened a ticket between
-- two pushes (or reconnected, or navigated away and back) saw an empty map for up
-- to a full route-refresh cycle — or forever, if the driver never deviated.
-- OrderMap calls this once on mount and renders the reply exactly as if the events
-- had fired; live events keep updating it afterwards.
--
-- PERMISSION: only the ORDER'S OWN CUSTOMER may read it. Anything else — another
-- player, an unknown order, a closed ticket — gets an empty table, so this can't be
-- polled to track an arbitrary driver around the map.
lib.callback.register("pickle_restaurants:phone:trackOrder", function(src, d)
    local oid = tonumber(type(d) == "table" and d.orderId or nil)
    if not oid then return {} end
    local o
    for _, orders in pairs(OrderCache) do
        if orders[oid] then o = orders[oid]; break end
    end
    if not o or o.status ~= "open" then return {} end
    local me = GetIdentifier(src)
    if not me or not o.customer_identifier or o.customer_identifier ~= me then
        return {}
    end
    local t = DriverTelemetry[oid]
    if not t then return {} end
    local driver = (t.x and t.y) and { x = t.x, y = t.y } or nil
    return { driver = driver }
end)

-- ─── complete order ──────────────────────────────────────────────────────────

-- The order's receipt on the customer. With slot metadata the exact order's
-- receipt is required (metadata.order_id); bare ESX settles for any one receipt
-- item. `consume` false just verifies it's there. Returns false only when the
-- receipt is REQUIRED (item installed) and absent.
local function takeReceipt(customerSrc, order, consume)
    local item = ReceiptItem()
    if not ItemExists(item) then return true end -- receipts not installed → not required
    if Inventory.GetItemSlots then
        for _, s in ipairs(Inventory.GetItemSlots(customerSrc, item) or {}) do
            local m = type(s.metadata) == "table" and s.metadata or {}
            if tonumber(m.order_id) == order.id then
                if consume then Inventory.RemoveItemSlot(customerSrc, item, 1, s.slot) end
                return true
            end
        end
        return false
    end
    if (Inventory.GetItemCount(customerSrc, item) or 0) < 1 then return false end
    if consume then Inventory.RemoveItem(customerSrc, item, 1) end
    return true
end

lib.callback.register("pickle_restaurants:sales:completeOrder", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "sell") then return { ok = false, error = _L("no_work_here") } end
    local o = OrderCache[id] and OrderCache[id][tonumber(d.orderId)]
    -- `o.busy` is a TRANSIENT in-memory claim (double-click / two-cashier guard),
    -- deliberately SEPARATE from o.status: the persisted status stays "open" for the
    -- entire live life of the order. That's the fix for the wedged-ticket bug — a
    -- failure mid-complete can never strand the order in a non-open state that the
    -- guard rejects yet GetOpenOrders still shows. The claim is ALWAYS released on
    -- every failure path below, so the ticket stays actionable without a restart.
    if not o or o.status ~= "open" or o.busy then return { ok = false, error = _L("order_not_open") } end
    o.busy = true
    local function fail(err)
        o.busy = false
        ShowNotification(src, err)
        return { ok = false, error = err }
    end

    -- NPC customer: no player wallet, receipt or inventory hand-off. Verify the NPC is
    -- still waiting at the counter, fulfil from the shared pool (the instances are just
    -- consumed — the NPC "takes" them), then pay the restaurant (+ a possible tip) and
    -- commission the serving staff, and send the ped away happy. The whole player path
    -- below is skipped. (IsNpcOrder/NpcOrderPresent/NpcRollTip/NpcDropOrder are globals
    -- from modules/npc_customers/server.lua.)
    if IsNpcOrder and IsNpcOrder(o) then
        if o.order_type == "delivery" then
            -- An NPC DELIVERY has no ped to stand at a counter, so "is the customer
            -- here" becomes "did the claiming driver actually drive it there". Same
            -- claim rules as a player delivery (see the player branch below), then a
            -- horizontal distance check against the drop point.
            local mine = GetIdentifier(src)
            if not o.driver_identifier then return fail(_L("delivery_accept_first")) end
            if o.driver_identifier ~= mine then
                return fail(_L("delivery_not_yours", DriverName(o) or "?"))
            end
            local t = DeliveryTargets[o.id]
            if not t then return fail(_L("delivery_no_target")) end
            local ped = GetPlayerPed(src)
            local c = ped ~= 0 and GetEntityCoords(ped) or nil
            local radius = (NpcDeliveryRadius and NpcDeliveryRadius()) or 8.0
            if not c or math.sqrt((c.x - t.x) ^ 2 + (c.y - t.y) ^ 2) > radius then
                return fail(_L("order_driver_far"))
            end
        elseif not NpcOrderPresent(id, o.id) then
            return fail(_L("order_customer_missing"))
        end

        -- the packed vessels (meals / Restaurant Bags) the cashier PINNED, if any — a
        -- LIST from the register's picker, or the single mealSig/mealItem pair the
        -- phone sends; the plan claims any further ones the ticket needs by itself
        local pins = VesselPinsFrom(d)
        -- looseOk: the ped is handed the food directly, so nothing here has to be an
        -- installed inventory item (no AddItem happens on this branch at all)
        local plan = PlanFulfillment(id, o, pins, d.mealItem, true)
        if not plan.ok then
            return fail(_L("order_missing_items", table.concat(plan.missing or {}, ", ")))
        end

        -- Consume from the pool under one guard — no yield since PlanFulfillment, so it
        -- can only come up short if something throws.
        local consumed, cerr = pcall(function()
            for _, v in ipairs(plan.vessels or {}) do
                if not VesselConsume(id, v.item, v.sig) then error(GetItemLabel(v.item), 0) end
            end
            for _, g in ipairs(plan.singles) do
                local taken = SingleConsumeMatch(id, g.item, variationMatcher(g.item, g.key), g.count)
                if not taken or #taken < g.count then error(GetItemLabel(g.item), 0) end
            end
        end)
        if not consumed then return fail(_L("order_missing_items", tostring(cerr))) end

        AdjustBalance(id, o.total)
        local summary = orderSummary(o.lines)
        AddLedger(id, "sale", o.total, _L("ledger_sale", o.ticket, summary):sub(1, 255), o.customer_identifier)
        local tip = (NpcRollTip and NpcRollTip(o.total)) or 0
        if tip > 0 then
            -- A TIP IS STAFF MONEY, not the house's. It used to be added to the
            -- restaurant BALANCE, which quietly made every gratuity the owner's; it now
            -- goes into the tip pool (an unpaid `pickle_restaurant_tips` row) for a
            -- manager to pay out, and the ledger records it as the tip line it always
            -- was so the books still show it arriving.
            AddTip(id, tip, nil, "npc")
            AddLedger(id, "tip", tip, _L("ledger_tip", o.ticket), o.customer_identifier)
        end
        -- Commission is a cut of the SALE only. Paying it on the tip as well would take
        -- it out of a balance the tip never entered — the house would be funding the
        -- server's cut of their own gratuity.
        payCommission(id, src, o.total, o.ticket, o.customer_identifier)

        CloseOrder(id, o.id, "completed")
        -- Phone companion seam: cook stats / achievements / leaderboard / tip pool.
        -- NPC orders credit the cook (no customer loyalty — the handler skips npc:).
        TriggerEvent("pickle_restaurants:internal:orderCompleted", id, o, src, tip)
        if NpcDropOrder then NpcDropOrder(id, o.id, true) end
        ShowNotification(src, _L("order_completed", o.ticket))
        SyncOrders(id)
        return { ok = true }
    end

    -- A DELIVERY is handed over at the customer's door, not across the counter, so it
    -- plays by different rules: the driver has to physically reach them (a tighter
    -- 5m — this is a doorstep hand-off, not a counter reach), and there is NO receipt
    -- to present. The paper slip is the counter's proof-of-purchase ritual; a delivery
    -- is already authenticated by the claimed run and the tracked ticket, so demanding
    -- it just wedged every delivery that ever got served.
    local isDelivery = (o.order_type == "delivery")
    -- Only the run's OWN driver hands a delivery over. An unclaimed delivery can't be
    -- served at all — you accept it first — which also means a second employee standing
    -- near the customer can't complete (and take commission on) someone else's run.
    if isDelivery then
        local mine = GetIdentifier(src)
        if not o.driver_identifier then return fail(_L("delivery_accept_first")) end
        if o.driver_identifier ~= mine then
            return fail(_L("delivery_not_yours", DriverName(o) or "?"))
        end
    end
    local customerSrc = findPlayerByIdentifier(o.customer_identifier)
    if not customerSrc or not playersNear(src, customerSrc, isDelivery and 5.0 or 8.0) then
        return fail(isDelivery and _L("order_driver_far") or _L("order_customer_missing"))
    end
    -- Verify the receipt WITHOUT consuming it yet — it's taken last, once the
    -- food has actually changed hands.
    if not isDelivery and not takeReceipt(customerSrc, o, false) then
        return fail(_L("order_no_receipt"))
    end

    -- Fulfil from the restaurant-wide cooked-items pool (every cook's tray), not
    -- the cashier's inventory. Plan first so a shortfall never half-hands an order;
    -- `d.mealSig` (optional) PINS one packed VESSEL the cashier chose to fill from — a
    -- serving-tray meal or a Restaurant Bag; `d.mealItem` says which (VesselItem rejects
    -- anything else, so it always resolves to one of the two). The plan claims any
    -- further vessels the ticket needs on top of it, so a big order packed into two
    -- bags hands over both.
    local plan = PlanFulfillment(id, o, VesselPinsFrom(d), d.mealItem)
    if not plan.ok then
        return fail(_L("order_missing_items", table.concat(plan.missing or {}, ", ")))
    end
    -- Room for every vessel at once — two bags need two slots (vesselPool only ever
    -- offers installed items, so there is nothing to re-check there).
    local perVessel = {}
    for _, v in ipairs(plan.vessels or {}) do perVessel[v.item] = (perVessel[v.item] or 0) + 1 end
    for item, n in pairs(perVessel) do
        if Inventory.CanCarryItem and not Inventory.CanCarryItem(customerSrc, item, n) then
            return fail(_L("order_cant_carry", GetItemLabel(item)))
        end
    end
    for _, g in ipairs(plan.singles) do
        if Inventory.CanCarryItem and not Inventory.CanCarryItem(customerSrc, g.item, g.count) then
            return fail(_L("order_cant_carry", GetItemLabel(g.item)))
        end
    end

    -- Consume from the pool + hand each instance to the customer (build-stack
    -- metadata intact, via BuildInvMeta — a pepperoni pizza arrives as that exact
    -- pizza) + consume the receipt, under ONE guard. There is no yield between the
    -- plan and here, so PoolConsume can't come up short unless something throws.
    local moved, bad = pcall(function()
        for _, v in ipairs(plan.vessels or {}) do
            local got, vmeta = VesselConsume(id, v.item, v.sig)
            if not got then error(GetItemLabel(v.item), 0) end
            Inventory.AddItem(customerSrc, v.item, 1, BuildInvMeta(vmeta, v.item))
        end
        for _, g in ipairs(plan.singles) do
            local taken = SingleConsumeMatch(id, g.item, variationMatcher(g.item, g.key), g.count)
            if not taken or #taken < g.count then error(GetItemLabel(g.item), 0) end
            for _, inst in ipairs(taken) do
                Inventory.AddItem(customerSrc, g.item, 1, BuildInvMeta(inst.meta, g.item))
            end
        end
        -- The receipt is spent the moment the food changes hands — it is proof of an
        -- ORDER, and the order is over. A delivery was never REQUIRED to present one
        -- (nobody hands a slip to the driver), but a phone order still ISSUES one, so
        -- skipping the void left every customer holding a dead receipt for a meal they
        -- had already eaten. It is voided too, just never required: guarded on its own
        -- so an inventory hiccup can't abort a hand-over the customer has already been
        -- given the food for.
        if not isDelivery then takeReceipt(customerSrc, o, true) -- verified above; best-effort by now
        else pcall(takeReceipt, customerSrc, o, true) end
    end)
    if not moved then
        return fail(_L("order_missing_items", tostring(bad)))
    end

    CloseOrder(id, o.id, "completed")
    -- Phone companion seam: customer loyalty punch + cook stats/achievements/tips.
    TriggerEvent("pickle_restaurants:internal:orderCompleted", id, o, src, 0)
    if DeliveryTargets then DeliveryTargets[o.id] = nil end
    if ClearDeliveryChat then ClearDeliveryChat(o.id) end   -- the thread dies with the ticket
    ShowNotification(src, _L("order_completed", o.ticket))
    -- The customer HAS the food at this point (it just moved into their inventory) —
    -- so this is a hand-off confirmation, not a "ready" nudge.
    if customerSrc ~= src then
        ShowNotification(customerSrc, (o.order_type == "delivery")
            and _L("order_delivered", o.ticket) or _L("order_received", o.ticket))
    end
    SyncOrders(id)
    -- Reply ok ONLY — the ticket list refreshes via the SyncOrders broadcast above
    -- (which the acting cashier receives too). The reply never carries the list, so
    -- there is no second, racing update path.
    return { ok = true }
end)

-- ─── cancel order (refund) ───────────────────────────────────────────────────

lib.callback.register("pickle_restaurants:sales:cancelOrder", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "sell") then return { ok = false, error = _L("no_work_here") } end
    local o = OrderCache[id] and OrderCache[id][tonumber(d.orderId)]
    -- Transient claim, separate from the persisted status (see completeOrder) —
    -- guarantees the ticket is never wedged in a non-open state by a failure here.
    if not o or o.status ~= "open" or o.busy then return { ok = false, error = _L("order_not_open") } end
    o.busy = true
    local function fail(err)
        o.busy = false
        ShowNotification(src, err)
        return { ok = false, error = err }
    end

    -- NPC customer: it never pre-paid (NPCs pay on serve), so there's nothing to
    -- refund — just close the ticket and send the ped off. (RefundOrder would also
    -- no-op on an NPC ticket; this branch additionally sends the ped away.)
    if IsNpcOrder and IsNpcOrder(o) then
        CloseOrder(id, o.id, "cancelled")
        if NpcDropOrder then NpcDropOrder(id, o.id, false) end
        ShowNotification(src, _L("order_cancelled", o.ticket))
        SyncOrders(id)
        return { ok = true }
    end

    -- Refund through the ONE shared, idempotent path (core/server.lua). It reverses
    -- the restaurant balance + ledger, returns the charged total to the account that
    -- was actually charged, restores a burned loyalty redemption, and — critically —
    -- does NOT need the customer to be online: an unreachable customer's payout is
    -- persisted and settled on their next login. The old code refused to cancel at
    -- all when the customer had disconnected, which wedged the ticket open forever.
    local customerSrc = findPlayerByIdentifier(o.customer_identifier)
    -- Guarded: a throw in here must not strand the ticket with o.busy latched (the
    -- wedged-ticket failure mode). RefundOrder claims `refunded` before it can throw,
    -- so retrying after a mid-refund error can never double-pay — it just no-ops. A
    -- failed refund is LOUD, never silent: money is involved.
    local okr, rerr, refunded, deferred = pcall(RefundOrder, id, o, _L("refund_reason_cancelled"))
    if not okr then
        print(("[pickle_restaurants] REFUND FAILED for ticket #%s (order %s, restaurant %s): %s")
            :format(tostring(o.ticket), tostring(o.id), tostring(id), tostring(rerr)))
        return fail(_L("order_refund_failed"))
    end
    refunded, deferred = refunded or 0, deferred or false

    -- Void the receipt if it's still on them — truly best-effort: its OWN guard so
    -- an inventory hiccup here can never abort (and thus wedge) the cancel. Only
    -- possible while they're online; a stale receipt on an offline customer is
    -- harmless (completeOrder re-checks the ticket, which is closed by then).
    if customerSrc then
        pcall(function()
            local item = ReceiptItem()
            if ItemExists(item) then
                if Inventory.GetItemSlots then
                    for _, s in ipairs(Inventory.GetItemSlots(customerSrc, item) or {}) do
                        local m = type(s.metadata) == "table" and s.metadata or {}
                        if tonumber(m.order_id) == o.id then
                            Inventory.RemoveItemSlot(customerSrc, item, 1, s.slot)
                            break
                        end
                    end
                elseif (Inventory.GetItemCount(customerSrc, item) or 0) >= 1 then
                    Inventory.RemoveItem(customerSrc, item, 1)
                end
            end
        end)
    end

    if DeliveryTargets then DeliveryTargets[o.id] = nil end
    if ClearDeliveryChat then ClearDeliveryChat(o.id) end   -- the thread dies with the ticket
    -- A cancelled run ends the same way a completed one does as far as the map is
    -- concerned: the customer's driver blip has nothing left to track.
    if customerSrc then
        TriggerClientEvent("pickle_restaurants:phone:deliveryEnded", customerSrc, { orderId = o.id })
    end
    CloseOrder(id, o.id, "cancelled")
    ShowNotification(src, deferred
        and _L("order_cancelled_refund_pending", o.ticket)
        or _L("order_cancelled", o.ticket))
    -- RefundOrder already notified the customer when it paid them directly; only
    -- tell them here if the cashier isn't the customer and nothing was paid out.
    if customerSrc and customerSrc ~= src and refunded <= 0 then
        ShowNotification(customerSrc, _L("order_cancelled", o.ticket))
    end
    SyncOrders(id)
    -- Reply ok ONLY — the ticket list refreshes via the SyncOrders broadcast above
    -- (which the acting cashier receives too). The reply never carries the list, so
    -- there is no second, racing update path.
    return { ok = true }
end)

-- ─── live fulfillment refresh ────────────────────────────────────────────────
-- A ticket's Complete/Not-Complete state depends on the shared pool, which
-- changes as cooks cook, cash out, or food expires — none of which touch the
-- order list. The tray mutators flag the restaurant via MarkOrdersDirty (in tight
-- loops), and this coalescing flusher rebroadcasts the (re-annotated) open list
-- through the SAME single SyncOrders path — no new update path, so the staleness
-- invariant holds. Skipped when a flagged restaurant has no open tickets.
CreateThread(function()
    while true do
        Wait(750)
        for rid in pairs(OrdersDirty) do
            OrdersDirty[rid] = nil
            if OrderCache[rid] and next(OrderCache[rid]) then SyncOrders(rid) end
        end
    end
end)
